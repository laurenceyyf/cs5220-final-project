#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <sstream>
#include <stdexcept>
#include <vector>

#include <cuda_runtime.h>

#include "kernel.h"

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

__global__ void sobel_kernel(
    const uint8_t* input,
    int width,
    int height,
    float* __restrict__ magnitude,
    float* __restrict__ direction,

    unsigned long long* smem_load_clocks,
    unsigned long long* sync_clocks,
    unsigned long long* compute_clocks
) {
    extern __shared__ uint8_t tile[];

    const int BX = static_cast<int>(blockDim.x);
    const int BY = static_cast<int>(blockDim.y);
    const int tile_w = BX + 2;   // shared mem row stride
    const int tile_h = BY + 2;

    const int tx = static_cast<int>(threadIdx.x);
    const int ty = static_cast<int>(threadIdx.y);

    // Top-left corner of this block's OUTPUT region in the output image.
    const int out_x0 = static_cast<int>(blockIdx.x) * BX;
    const int out_y0 = static_cast<int>(blockIdx.y) * BY;

    // Top-left corner of the INPUT tile (one pixel of halo above/left).
    const int in_x0 = out_x0;   // output pixel (out_x, out_y) reads input at
    const int in_y0 = out_y0;   // (out_x+1, out_y+1), so tile[0,0] = input[in_x0, in_y0]

    const int out_width  = width  - 2;
    const int out_height = height - 2;

    const bool do_clocks = (smem_load_clocks != nullptr);
    unsigned long long t0 = 0, t1 = 0, t2 = 0, t3 = 0;

    const int tid = ty * BX + tx;
    const int block_threads = BX * BY;
    const int tile_size = tile_w * tile_h;

    if (do_clocks && tid == 0) t0 = clock64();

    for (int i = tid; i < tile_size; i += block_threads) {
        const int tile_row = i / tile_w;
        const int tile_col = i % tile_w;

        // Map tile coordinate to global input coordinate, clamp to valid range.
        const int gx = max(0, min(width  - 1, in_x0 + tile_col));
        const int gy = max(0, min(height - 1, in_y0 + tile_row));

        tile[i] = input[gy * width + gx];
    }

    if (do_clocks && tid == 0) t1 = clock64();

    __syncthreads();

    if (do_clocks && tid == 0) t2 = clock64();

    const int out_x = out_x0 + tx;
    const int out_y = out_y0 + ty;

    if (out_x < out_width && out_y < out_height) {
        float sum_x = 0.0f;
        float sum_y = 0.0f;

        for (int ky = 0; ky < 3; ++ky) {
            for (int kx = 0; kx < 3; ++kx) {
                const int kernel_index = ky * 3 + kx;
                const float px = static_cast<float>(tile[(ty + ky) * tile_w + (tx + kx)]);
                sum_x += px * static_cast<float>(kGx[kernel_index]);
                sum_y += px * static_cast<float>(kGy[kernel_index]);
            }
        }

        const int output_index = out_y * out_width + out_x;
        magnitude[output_index] = sqrtf(sum_x * sum_x + sum_y * sum_y);
        direction[output_index] = atan2f(sum_y, sum_x);
    }

    if (do_clocks && tid == 0) {
        t3 = clock64();
        smem_load_clocks[blockIdx.y * gridDim.x + blockIdx.x] = t1 - t0;
        sync_clocks     [blockIdx.y * gridDim.x + blockIdx.x] = t2 - t1;
        compute_clocks  [blockIdx.y * gridDim.x + blockIdx.x] = t3 - t2;
    }
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
    const size_t smem_bytes =
        static_cast<size_t>(block.x + 2) * (block.y + 2) * sizeof(uint8_t);

    CudaTimingBreakdown timing;
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
            // Sub-phase clock buffers: not used in multi-GPU path for simplicity.
            sobel_kernel_smem<<<grid, block, smem_bytes, work.stream>>>(
                work.d_input,
                width,
                work.local_input_rows,
                work.d_magnitude,
                work.d_direction,
                nullptr, nullptr, nullptr
            );
            check_cuda(cudaGetLastError(), "sobel_kernel_smem multi launch");
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
    if (width < 3 || height < 3)
        throw std::runtime_error("width and height must both be at least 3");
    validate_launch_config(launch_config);
    if (launch_config.copy_output_to_host && (magnitude == nullptr || direction == nullptr))
        throw std::runtime_error("host output buffers required when copying output to host");

    // if (launch_config.use_multi_gpu || launch_config.num_gpus > 1) {
    //     return compute_sobel_cuda_multi_gpu_impl(
    //         input, width, height, magnitude, direction, launch_config
    //     );
    // }

    CudaTimingBreakdown timing;
    timing.num_gpus = 1;
    timing.block_x = launch_config.block_x;
    timing.block_y = launch_config.block_y;
    timing.copied_output_to_host = launch_config.copy_output_to_host;

    const size_t input_bytes = static_cast<size_t>(width) * height * sizeof(uint8_t);
    const size_t output_bytes =
        static_cast<size_t>(width - 2) * (height - 2) * sizeof(float);

    const dim3 block(
        static_cast<unsigned int>(launch_config.block_x),
        static_cast<unsigned int>(launch_config.block_y)
    );
    const dim3 grid(
        static_cast<unsigned int>((width  - 2 + block.x - 1) / block.x),
        static_cast<unsigned int>((height - 2 + block.y - 1) / block.y)
    );
    timing.grid_x = static_cast<int>(grid.x);
    timing.grid_y = static_cast<int>(grid.y);

    // Shared memory: (BX+2) * (BY+2) bytes per block.
    const size_t smem_bytes =
        static_cast<size_t>(block.x + 2) * (block.y + 2) * sizeof(uint8_t);

    
    const size_t num_blocks = static_cast<size_t>(grid.x) * grid.y;
    const size_t clock_bytes = num_blocks * sizeof(unsigned long long);

    unsigned long long* d_smem_load_clocks = nullptr;
    unsigned long long* d_sync_clocks      = nullptr;
    unsigned long long* d_compute_clocks   = nullptr;

    uint8_t* d_input     = nullptr;
    float*   d_magnitude = nullptr;
    float*   d_direction = nullptr;

    const auto allocation_start = std::chrono::steady_clock::now();
    check_cuda(cudaMalloc(&d_input, input_bytes),  "cudaMalloc(d_input)");
    check_cuda(cudaMalloc(&d_magnitude, output_bytes), "cudaMalloc(d_magnitude)");
    check_cuda(cudaMalloc(&d_direction, output_bytes), "cudaMalloc(d_direction)");
    check_cuda(cudaMalloc(&d_smem_load_clocks, clock_bytes),  "cudaMalloc(d_smem_load_clocks)");
    check_cuda(cudaMalloc(&d_sync_clocks,clock_bytes),  "cudaMalloc(d_sync_clocks)");
    check_cuda(cudaMalloc(&d_compute_clocks,clock_bytes),  "cudaMalloc(d_compute_clocks)");
    const auto allocation_end = std::chrono::steady_clock::now();
    timing.allocation_ms = elapsed_host_ms(allocation_start, allocation_end);

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

        check_cuda(cudaEventRecord(kernel_start), "cudaEventRecord(kernel_start)");
        sobel_kernel_smem<<<grid, block, smem_bytes>>>(
            d_input, width, height,
            d_magnitude, d_direction,
            d_smem_load_clocks, d_sync_clocks, d_compute_clocks
        );
        // timing.h2d_ms +=1123123123;
        check_cuda(cudaGetLastError(), "sobel_kernel_smem launch");
        check_cuda(cudaEventRecord(kernel_stop), "cudaEventRecord(kernel_stop)");
        check_cuda(cudaEventSynchronize(kernel_stop), "cudaEventSynchronize(kernel_stop)");
        timing.kernel_ms = elapsed_event_ms(kernel_start, kernel_stop);
        check_cuda(cudaDeviceSynchronize(),  "cudaDeviceSynchronize");

        {
            int sm_clock_khz = 0;
            check_cuda(
                cudaDeviceGetAttribute(&sm_clock_khz, cudaDevAttrClockRate, 0),
                "cudaDeviceGetAttribute(clockRate)"
            );
            const double cycles_per_ms = static_cast<double>(sm_clock_khz);

            std::vector<unsigned long long> h_smem(num_blocks);
            std::vector<unsigned long long> h_sync(num_blocks);
            std::vector<unsigned long long> h_comp(num_blocks);

            check_cuda(
                cudaMemcpy(h_smem.data(), d_smem_load_clocks,
                           clock_bytes, cudaMemcpyDeviceToHost),
                "cudaMemcpy(smem_load_clocks D2H)"
            );
            check_cuda(
                cudaMemcpy(h_sync.data(), d_sync_clocks,
                           clock_bytes, cudaMemcpyDeviceToHost),
                "cudaMemcpy(sync_clocks D2H)"
            );
            check_cuda(
                cudaMemcpy(h_comp.data(), d_compute_clocks,
                           clock_bytes, cudaMemcpyDeviceToHost),
                "cudaMemcpy(compute_clocks D2H)"
            );

            unsigned long long max_smem = 0, max_sync = 0, max_comp = 0;
            for (size_t i = 0; i < num_blocks; ++i) {
                max_smem = std::max(max_smem, h_smem[i]);
                max_sync = std::max(max_sync, h_sync[i]);
                max_comp = std::max(max_comp, h_comp[i]);
                // max_smem += h_smem[i];
                // max_sync += h_sync[i];
                // max_comp += h_comp[i];
            }

            timing.smem_load_ms = static_cast<double>(max_smem) / cycles_per_ms;
            timing.sync_ms      = static_cast<double>(max_sync) / cycles_per_ms;
            timing.compute_ms   = static_cast<double>(max_comp) / cycles_per_ms;
        }

        // --- D2H ---
        if (launch_config.copy_output_to_host) {
            check_cuda(cudaEventRecord(d2h_start), "cudaEventRecord(d2h_start)");
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
        check_cuda(cudaEventDestroy(kernel_stop "cudaEventDestroy(kernel_stop)");
        check_cuda(cudaEventDestroy(d2h_start), "cudaEventDestroy(d2h_start)");
        check_cuda(cudaEventDestroy(d2h_stop), "cudaEventDestroy(d2h_stop)");
    } catch (...) {
        cudaFree(d_input);
        cudaFree(d_magnitude);
        cudaFree(d_direction);
        cudaFree(d_smem_load_clocks);
        cudaFree(d_sync_clocks);
        cudaFree(d_compute_clocks);
        throw;
    }

    const auto free_start = std::chrono::steady_clock::now();
    check_cuda(cudaFree(d_input), "cudaFree(d_input)");
    check_cuda(cudaFree(d_magnitude), "cudaFree(d_magnitude)");
    check_cuda(cudaFree(d_direction), "cudaFree(d_direction)");
    check_cuda(cudaFree(d_smem_load_clocks), "cudaFree(d_smem_load_clocks)");
    check_cuda(cudaFree(d_sync_clocks), "cudaFree(d_sync_clocks)");
    check_cuda(cudaFree(d_compute_clocks), "cudaFree(d_compute_clocks)");
    const auto free_end = std::chrono::steady_clock::now();
    timing.free_ms = elapsed_host_ms(free_start, free_end);

    return timing;
}
