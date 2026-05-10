#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <sstream>
#include <stdexcept>
#include <vector>

#include <cuda_runtime.h>

#include "kernel.h"

const char* cuda_kernel_variant_name(CudaKernelVariant variant) {
    switch (variant) {
        case CudaKernelVariant::NaiveExact:
            return "naive";
        case CudaKernelVariant::NaiveAtanApprox:
            return "atan_approx";
        case CudaKernelVariant::SharedExact:
            return "shared";
        case CudaKernelVariant::SharedAtanApprox:
            return "shared_atan_approx";
    }

    return "unknown";
}

namespace {

__device__ __constant__ int kGx[9] = {
    -1, 0, 1,
    -2, 0, 2,
    -1, 0, 1
};

__device__ __constant__ int kGy[9] = {
    -1, -2, -1,
     0,  0,  0,
     1,  2,  1
};

void check_cuda(cudaError_t status, const char* call) {
    if (status == cudaSuccess) {
        return;
    }

    std::ostringstream oss;
    oss << call << " failed: " << cudaGetErrorString(status);
    throw std::runtime_error(oss.str());
}

float elapsed_event_ms(cudaEvent_t start, cudaEvent_t stop) {
    float milliseconds = 0.0f;
    check_cuda(cudaEventElapsedTime(&milliseconds, start, stop), "cudaEventElapsedTime");
    return milliseconds;
}

double elapsed_host_ms(
    const std::chrono::steady_clock::time_point& start,
    const std::chrono::steady_clock::time_point& stop
) {
    return std::chrono::duration<double, std::milli>(stop - start).count();
}

__device__ __forceinline__ float cuda_atan2_f32(float y, float x) {
    const float PI          = 3.14159265358979f;
    const float PI_2        = 1.57079632679490f;
    const float C           = 0.273f;
    const float PI_4_PLUS_C = 0.7853981634f + 0.273f;

    // Absolute values
    float ax = fabsf(x);
    float ay = fabsf(y);

    // Determine if we need to swap x and y (equivalent to _mm256_cmp_ps + _mm256_blendv_ps)
    bool swap = (ay > ax);
    float t_num = swap ? ax : ay; 
    float t_den = swap ? ay : ax;

    // Safe division: prevent division by zero
    // In CUDA, if t_den is 0.0f, x and y were both 0, so atan2 is undefined (usually 0)
    float t = (t_den != 0.0f) ? (t_num / t_den) : 0.0f;

    // Approximation: atan(t) ~ t * ( (pi/4 + c) - c*t )
    // Using fmaf(a, b, c) calculates (a * b + c)
    // We want: t * (PI_4_PLUS_C - C * t)
    float p = t * fmaf(-C, t, PI_4_PLUS_C);

    // If we swapped (|y| > |x|), p = pi/2 - p
    if (swap) p = PI_2 - p;

    // If x < 0, p = pi - p (Handles Quadrants 2 and 3)
    if (x < 0.0f) p = PI - p;

    // Restore the sign of y (Equivalent to xor with sign bit)
    // copybit copies the sign of the second argument to the first
    return copysignf(p, y);
}

template <bool UseApproxDirection>
__device__ __forceinline__ float sobel_direction(float sum_y, float sum_x) {
    if constexpr (UseApproxDirection) {
        return cuda_atan2_f32(sum_y, sum_x);
    }
    return atan2f(sum_y, sum_x);
}

template <bool UseApproxDirection>
__global__ void sobel_kernel_naive(
    const uint8_t* input,
    int width,
    int height,
    float* magnitude,
    float* direction
) {
    const int out_x = blockIdx.x * blockDim.x + threadIdx.x;
    const int out_y = blockIdx.y * blockDim.y + threadIdx.y;
    const int out_width = width - 2;
    const int out_height = height - 2;

    if (out_x >= out_width || out_y >= out_height) {
        return;
    }

    const int x = out_x + 1;
    const int y = out_y + 1;

    float sum_x = 0.0f;
    float sum_y = 0.0f;

    // Each thread computes one output pixel from its surrounding 3x3 patch.
    #pragma unroll
    for (int ky = -1; ky <= 1; ++ky) {
        #pragma unroll
        for (int kx = -1; kx <= 1; ++kx) {
            const int kernel_index = (ky + 1) * 3 + (kx + 1);
            const uint8_t pixel = input[(y + ky) * width + (x + kx)];
            sum_x += static_cast<float>(pixel) * static_cast<float>(kGx[kernel_index]);
            sum_y += static_cast<float>(pixel) * static_cast<float>(kGy[kernel_index]);
        }
    }

    const int output_index = out_y * out_width + out_x;
    magnitude[output_index] = sqrtf(sum_x * sum_x + sum_y * sum_y);
    direction[output_index] = sobel_direction<UseApproxDirection>(sum_y, sum_x);
}

template <bool UseApproxDirection>
__global__ void sobel_kernel_shared(
    const uint8_t* input,
    int width,
    int height,
    float* magnitude,
    float* direction
) {
    const int out_x = blockIdx.x * blockDim.x + threadIdx.x;
    const int out_y = blockIdx.y * blockDim.y + threadIdx.y;
    const int out_width = width - 2;
    const int out_height = height - 2;

    const int tile_width = static_cast<int>(blockDim.x) + 2;
    const int tile_height = static_cast<int>(blockDim.y) + 2;
    const int tile_elements = tile_width * tile_height;
    const int thread_linear =
        static_cast<int>(threadIdx.y * blockDim.x + threadIdx.x);
    const int thread_count = static_cast<int>(blockDim.x * blockDim.y);
    const int block_input_x = static_cast<int>(blockIdx.x * blockDim.x);
    const int block_input_y = static_cast<int>(blockIdx.y * blockDim.y);

    extern __shared__ uint8_t tile[];

    for (int idx = thread_linear; idx < tile_elements; idx += thread_count) {
        const int tile_y = idx / tile_width;
        const int tile_x = idx % tile_width;
        const int global_x = block_input_x + tile_x;
        const int global_y = block_input_y + tile_y;

        uint8_t pixel = 0;
        if (global_x < width && global_y < height) {
            pixel = input[global_y * width + global_x];
        }
        tile[idx] = pixel;
    }

    __syncthreads();

    if (out_x >= out_width || out_y >= out_height) {
        return;
    }

    const int shared_x = static_cast<int>(threadIdx.x) + 1;
    const int shared_y = static_cast<int>(threadIdx.y) + 1;

    float sum_x = 0.0f;
    float sum_y = 0.0f;

    #pragma unroll
    for (int ky = -1; ky <= 1; ++ky) {
        #pragma unroll
        for (int kx = -1; kx <= 1; ++kx) {
            const int kernel_index = (ky + 1) * 3 + (kx + 1);
            const uint8_t pixel = tile[(shared_y + ky) * tile_width + (shared_x + kx)];
            sum_x += static_cast<float>(pixel) * static_cast<float>(kGx[kernel_index]);
            sum_y += static_cast<float>(pixel) * static_cast<float>(kGy[kernel_index]);
        }
    }

    const int output_index = out_y * out_width + out_x;
    magnitude[output_index] = sqrtf(sum_x * sum_x + sum_y * sum_y);
    direction[output_index] = sobel_direction<UseApproxDirection>(sum_y, sum_x);
}

bool variant_uses_shared_memory(CudaKernelVariant variant) {
    return variant == CudaKernelVariant::SharedExact
        || variant == CudaKernelVariant::SharedAtanApprox;
}

size_t shared_memory_bytes_for_variant(const CudaLaunchConfig& launch_config) {
    if (!variant_uses_shared_memory(launch_config.variant)) {
        return 0;
    }

    return static_cast<size_t>(launch_config.block_x + 2)
        * static_cast<size_t>(launch_config.block_y + 2)
        * sizeof(uint8_t);
}

void launch_sobel_kernel(
    const uint8_t* input,
    int width,
    int height,
    float* magnitude,
    float* direction,
    const dim3& grid,
    const dim3& block,
    cudaStream_t stream,
    const CudaLaunchConfig& launch_config
) {
    const size_t shared_bytes = shared_memory_bytes_for_variant(launch_config);

    switch (launch_config.variant) {
        case CudaKernelVariant::NaiveExact:
            sobel_kernel_naive<false><<<grid, block, 0, stream>>>(
                input, width, height, magnitude, direction
            );
            break;
        case CudaKernelVariant::NaiveAtanApprox:
            sobel_kernel_naive<true><<<grid, block, 0, stream>>>(
                input, width, height, magnitude, direction
            );
            break;
        case CudaKernelVariant::SharedExact:
            sobel_kernel_shared<false><<<grid, block, shared_bytes, stream>>>(
                input, width, height, magnitude, direction
            );
            break;
        case CudaKernelVariant::SharedAtanApprox:
            sobel_kernel_shared<true><<<grid, block, shared_bytes, stream>>>(
                input, width, height, magnitude, direction
            );
            break;
    }

    check_cuda(cudaGetLastError(), "sobel kernel launch");
}

struct DeviceWork {
    int device = 0;
    int output_start_row = 0;
    int output_rows = 0;
    int local_input_rows = 0;
    int grid_x = 0;
    int grid_y = 0;
    size_t local_input_bytes = 0;
    size_t local_output_bytes = 0;
    cudaStream_t stream = nullptr;
    uint8_t* d_input = nullptr;
    float* d_magnitude = nullptr;
    float* d_direction = nullptr;
};

void cleanup_device_work(std::vector<DeviceWork>& works, bool throw_on_error) {
    for (DeviceWork& work : works) {
        cudaSetDevice(work.device);

        if (work.d_input != nullptr) {
            cudaError_t status = cudaFree(work.d_input);
            if (throw_on_error) {
                check_cuda(status, "cudaFree(multi d_input)");
            }
            work.d_input = nullptr;
        }
        if (work.d_magnitude != nullptr) {
            cudaError_t status = cudaFree(work.d_magnitude);
            if (throw_on_error) {
                check_cuda(status, "cudaFree(multi d_magnitude)");
            }
            work.d_magnitude = nullptr;
        }
        if (work.d_direction != nullptr) {
            cudaError_t status = cudaFree(work.d_direction);
            if (throw_on_error) {
                check_cuda(status, "cudaFree(multi d_direction)");
            }
            work.d_direction = nullptr;
        }
        if (work.stream != nullptr) {
            cudaError_t status = cudaStreamDestroy(work.stream);
            if (throw_on_error) {
                check_cuda(status, "cudaStreamDestroy(multi stream)");
            }
            work.stream = nullptr;
        }
    }
}

void validate_launch_config(const CudaLaunchConfig& launch_config) {
    if (launch_config.block_x <= 0 || launch_config.block_y <= 0) {
        throw std::runtime_error("CUDA block dimensions must be positive");
    }
    if (launch_config.block_x * launch_config.block_y > 1024) {
        throw std::runtime_error("CUDA block dimensions exceed 1024 threads per block");
    }
    if (launch_config.num_gpus <= 0) {
        throw std::runtime_error("number of GPUs must be positive");
    }
}

CudaTimingBreakdown compute_sobel_cuda_multi_gpu_impl(
    const uint8_t* input,
    int width,
    int height,
    float* magnitude,
    float* direction,
    const CudaLaunchConfig& launch_config
) {
    if (launch_config.copy_output_to_host && (magnitude == nullptr || direction == nullptr)) {
        throw std::runtime_error("host output buffers are required when copying output to host");
    }

    int device_count = 0;
    check_cuda(cudaGetDeviceCount(&device_count), "cudaGetDeviceCount");
    if (device_count < launch_config.num_gpus) {
        std::ostringstream oss;
        oss << "requested " << launch_config.num_gpus
            << " GPU(s), but CUDA reports only " << device_count;
        throw std::runtime_error(oss.str());
    }

    const int output_width = width - 2;
    const int output_height = height - 2;
    const int active_gpus = std::min(launch_config.num_gpus, output_height);
    const dim3 block(
        static_cast<unsigned int>(launch_config.block_x),
        static_cast<unsigned int>(launch_config.block_y)
    );

    CudaTimingBreakdown timing;
    timing.variant = launch_config.variant;
    timing.num_gpus = active_gpus;
    timing.block_x = launch_config.block_x;
    timing.block_y = launch_config.block_y;
    timing.copied_output_to_host = launch_config.copy_output_to_host;

    std::vector<DeviceWork> works;
    works.reserve(static_cast<size_t>(active_gpus));

    int output_row_cursor = 0;
    const int base_rows = output_height / active_gpus;
    const int extra_rows = output_height % active_gpus;

    const auto allocation_start = std::chrono::steady_clock::now();
    try {
        for (int gpu = 0; gpu < active_gpus; ++gpu) {
            works.push_back(DeviceWork{});
            DeviceWork& work = works.back();
            work.device = gpu;
            work.output_start_row = output_row_cursor;
            work.output_rows = base_rows + (gpu < extra_rows ? 1 : 0);
            work.local_input_rows = work.output_rows + 2;
            work.local_input_bytes =
                static_cast<size_t>(work.local_input_rows) * width * sizeof(uint8_t);
            work.local_output_bytes =
                static_cast<size_t>(work.output_rows) * output_width * sizeof(float);
            work.grid_x = static_cast<int>((output_width + block.x - 1) / block.x);
            work.grid_y = static_cast<int>((work.output_rows + block.y - 1) / block.y);

            check_cuda(cudaSetDevice(work.device), "cudaSetDevice(multi allocate)");
            check_cuda(cudaStreamCreate(&work.stream), "cudaStreamCreate(multi stream)");
            check_cuda(cudaMalloc(&work.d_input, work.local_input_bytes), "cudaMalloc(multi d_input)");
            check_cuda(
                cudaMalloc(&work.d_magnitude, work.local_output_bytes),
                "cudaMalloc(multi d_magnitude)"
            );
            check_cuda(
                cudaMalloc(&work.d_direction, work.local_output_bytes),
                "cudaMalloc(multi d_direction)"
            );

            timing.grid_x = std::max(timing.grid_x, work.grid_x);
            timing.grid_y = std::max(timing.grid_y, work.grid_y);
            output_row_cursor += work.output_rows;
        }
    } catch (...) {
        cleanup_device_work(works, false);
        throw;
    }
    const auto allocation_stop = std::chrono::steady_clock::now();
    timing.allocation_ms = elapsed_host_ms(allocation_start, allocation_stop);

    try {
        const auto h2d_start = std::chrono::steady_clock::now();
        for (DeviceWork& work : works) {
            check_cuda(cudaSetDevice(work.device), "cudaSetDevice(multi h2d)");
            const uint8_t* chunk_input =
                input + static_cast<size_t>(work.output_start_row) * width;
            check_cuda(
                cudaMemcpyAsync(
                    work.d_input,
                    chunk_input,
                    work.local_input_bytes,
                    cudaMemcpyHostToDevice,
                    work.stream
                ),
                "cudaMemcpyAsync(multi input H2D)"
            );
        }
        for (DeviceWork& work : works) {
            check_cuda(cudaSetDevice(work.device), "cudaSetDevice(multi h2d sync)");
            check_cuda(cudaStreamSynchronize(work.stream), "cudaStreamSynchronize(multi h2d)");
        }
        const auto h2d_stop = std::chrono::steady_clock::now();
        timing.h2d_ms = elapsed_host_ms(h2d_start, h2d_stop);

        const auto kernel_start = std::chrono::steady_clock::now();
        for (DeviceWork& work : works) {
            check_cuda(cudaSetDevice(work.device), "cudaSetDevice(multi kernel)");
            const dim3 grid(
                static_cast<unsigned int>(work.grid_x),
                static_cast<unsigned int>(work.grid_y)
            );
            launch_sobel_kernel(
                work.d_input,
                width,
                work.local_input_rows,
                work.d_magnitude,
                work.d_direction,
                grid,
                block,
                work.stream,
                launch_config
            );
        }
        for (DeviceWork& work : works) {
            check_cuda(cudaSetDevice(work.device), "cudaSetDevice(multi kernel sync)");
            check_cuda(cudaStreamSynchronize(work.stream), "cudaStreamSynchronize(multi kernel)");
        }
        const auto kernel_stop = std::chrono::steady_clock::now();
        timing.kernel_ms = elapsed_host_ms(kernel_start, kernel_stop);

        if (launch_config.copy_output_to_host) {
            const auto d2h_start = std::chrono::steady_clock::now();
            for (DeviceWork& work : works) {
                check_cuda(cudaSetDevice(work.device), "cudaSetDevice(multi d2h)");
                const size_t output_offset =
                    static_cast<size_t>(work.output_start_row) * output_width;
                check_cuda(
                    cudaMemcpyAsync(
                        magnitude + output_offset,
                        work.d_magnitude,
                        work.local_output_bytes,
                        cudaMemcpyDeviceToHost,
                        work.stream
                    ),
                    "cudaMemcpyAsync(multi magnitude D2H)"
                );
                check_cuda(
                    cudaMemcpyAsync(
                        direction + output_offset,
                        work.d_direction,
                        work.local_output_bytes,
                        cudaMemcpyDeviceToHost,
                        work.stream
                    ),
                    "cudaMemcpyAsync(multi direction D2H)"
                );
            }
            for (DeviceWork& work : works) {
                check_cuda(cudaSetDevice(work.device), "cudaSetDevice(multi d2h sync)");
                check_cuda(cudaStreamSynchronize(work.stream), "cudaStreamSynchronize(multi d2h)");
            }
            const auto d2h_stop = std::chrono::steady_clock::now();
            timing.d2h_ms = elapsed_host_ms(d2h_start, d2h_stop);
        }
    } catch (...) {
        cleanup_device_work(works, false);
        throw;
    }

    const auto free_start = std::chrono::steady_clock::now();
    cleanup_device_work(works, true);
    const auto free_stop = std::chrono::steady_clock::now();
    timing.free_ms = elapsed_host_ms(free_start, free_stop);

    return timing;
}

}  // namespace

CudaTimingBreakdown compute_sobel_cuda(
    const uint8_t* input,
    int width,
    int height,
    float* magnitude,
    float* direction
) {
    CudaLaunchConfig launch_config;
    return compute_sobel_cuda(input, width, height, magnitude, direction, launch_config);
}

CudaTimingBreakdown compute_sobel_cuda(
    const uint8_t* input,
    int width,
    int height,
    float* magnitude,
    float* direction,
    const CudaLaunchConfig& launch_config
) {
    if (width < 3 || height < 3) {
        throw std::runtime_error("width and height must both be at least 3");
    }
    validate_launch_config(launch_config);
    if (launch_config.copy_output_to_host && (magnitude == nullptr || direction == nullptr)) {
        throw std::runtime_error("host output buffers are required when copying output to host");
    }
    if (launch_config.use_multi_gpu || launch_config.num_gpus > 1) {
        return compute_sobel_cuda_multi_gpu_impl(
            input,
            width,
            height,
            magnitude,
            direction,
            launch_config
        );
    }

    CudaTimingBreakdown timing;
    timing.variant = launch_config.variant;
    timing.num_gpus = 1;
    timing.block_x = launch_config.block_x;
    timing.block_y = launch_config.block_y;
    timing.copied_output_to_host = launch_config.copy_output_to_host;

    const size_t input_bytes = static_cast<size_t>(width) * height * sizeof(uint8_t);
    const size_t output_bytes =
        static_cast<size_t>(width - 2) * (height - 2) * sizeof(float);

    uint8_t* d_input = nullptr;
    float* d_magnitude = nullptr;
    float* d_direction = nullptr;

    const auto allocation_start = std::chrono::steady_clock::now();
    check_cuda(cudaMalloc(&d_input, input_bytes), "cudaMalloc(d_input)");
    check_cuda(cudaMalloc(&d_magnitude, output_bytes), "cudaMalloc(d_magnitude)");
    check_cuda(cudaMalloc(&d_direction, output_bytes), "cudaMalloc(d_direction)");
    const auto allocation_end = std::chrono::steady_clock::now();
    timing.allocation_ms =
        std::chrono::duration<double, std::milli>(allocation_end - allocation_start).count();

    try {
        cudaEvent_t h2d_start = nullptr;
        cudaEvent_t h2d_stop = nullptr;
        cudaEvent_t kernel_start = nullptr;
        cudaEvent_t kernel_stop = nullptr;
        cudaEvent_t d2h_start = nullptr;
        cudaEvent_t d2h_stop = nullptr;

        check_cuda(cudaEventCreate(&h2d_start), "cudaEventCreate(h2d_start)");
        check_cuda(cudaEventCreate(&h2d_stop), "cudaEventCreate(h2d_stop)");
        check_cuda(cudaEventCreate(&kernel_start), "cudaEventCreate(kernel_start)");
        check_cuda(cudaEventCreate(&kernel_stop), "cudaEventCreate(kernel_stop)");
        check_cuda(cudaEventCreate(&d2h_start), "cudaEventCreate(d2h_start)");
        check_cuda(cudaEventCreate(&d2h_stop), "cudaEventCreate(d2h_stop)");

        check_cuda(
            cudaEventRecord(h2d_start),
            "cudaEventRecord(h2d_start)"
        );
        check_cuda(
            cudaMemcpy(d_input, input, input_bytes, cudaMemcpyHostToDevice),
            "cudaMemcpy(input H2D)"
        );
        check_cuda(cudaEventRecord(h2d_stop), "cudaEventRecord(h2d_stop)");
        check_cuda(cudaEventSynchronize(h2d_stop), "cudaEventSynchronize(h2d_stop)");
        timing.h2d_ms = elapsed_event_ms(h2d_start, h2d_stop);

        const dim3 block(
            static_cast<unsigned int>(launch_config.block_x),
            static_cast<unsigned int>(launch_config.block_y)
        );
        const dim3 grid(
            static_cast<unsigned int>((width - 2 + block.x - 1) / block.x),
            static_cast<unsigned int>((height - 2 + block.y - 1) / block.y)
        );
        timing.grid_x = static_cast<int>(grid.x);
        timing.grid_y = static_cast<int>(grid.y);

        check_cuda(
            cudaEventRecord(kernel_start),
            "cudaEventRecord(kernel_start)"
        );
        launch_sobel_kernel(
            d_input,
            width,
            height,
            d_magnitude,
            d_direction,
            grid,
            block,
            nullptr,
            launch_config
        );
        check_cuda(cudaEventRecord(kernel_stop), "cudaEventRecord(kernel_stop)");
        check_cuda(cudaEventSynchronize(kernel_stop), "cudaEventSynchronize(kernel_stop)");
        timing.kernel_ms = elapsed_event_ms(kernel_start, kernel_stop);
        check_cuda(cudaDeviceSynchronize(), "cudaDeviceSynchronize");

        if (launch_config.copy_output_to_host) {
            check_cuda(
                cudaEventRecord(d2h_start),
                "cudaEventRecord(d2h_start)"
            );
            check_cuda(
                cudaMemcpy(magnitude, d_magnitude, output_bytes, cudaMemcpyDeviceToHost),
                "cudaMemcpy(magnitude D2H)"
            );
            check_cuda(
                cudaMemcpy(direction, d_direction, output_bytes, cudaMemcpyDeviceToHost),
                "cudaMemcpy(direction D2H)"
            );
            check_cuda(cudaEventRecord(d2h_stop), "cudaEventRecord(d2h_stop)");
            check_cuda(cudaEventSynchronize(d2h_stop), "cudaEventSynchronize(d2h_stop)");
            timing.d2h_ms = elapsed_event_ms(d2h_start, d2h_stop);
        }

        check_cuda(cudaEventDestroy(h2d_start), "cudaEventDestroy(h2d_start)");
        check_cuda(cudaEventDestroy(h2d_stop), "cudaEventDestroy(h2d_stop)");
        check_cuda(cudaEventDestroy(kernel_start), "cudaEventDestroy(kernel_start)");
        check_cuda(cudaEventDestroy(kernel_stop), "cudaEventDestroy(kernel_stop)");
        check_cuda(cudaEventDestroy(d2h_start), "cudaEventDestroy(d2h_start)");
        check_cuda(cudaEventDestroy(d2h_stop), "cudaEventDestroy(d2h_stop)");
    } catch (...) {
        cudaFree(d_input);
        cudaFree(d_magnitude);
        cudaFree(d_direction);
        throw;
    }

    const auto free_start = std::chrono::steady_clock::now();
    check_cuda(cudaFree(d_input), "cudaFree(d_input)");
    check_cuda(cudaFree(d_magnitude), "cudaFree(d_magnitude)");
    check_cuda(cudaFree(d_direction), "cudaFree(d_direction)");
    const auto free_end = std::chrono::steady_clock::now();
    timing.free_ms =
        std::chrono::duration<double, std::milli>(free_end - free_start).count();

    return timing;
}
