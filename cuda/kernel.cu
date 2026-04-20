#include <chrono>
#include <cmath>
#include <cstdint>
#include <sstream>
#include <stdexcept>

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

__global__ void sobel_kernel(
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
    for (int ky = -1; ky <= 1; ++ky) {
        for (int kx = -1; kx <= 1; ++kx) {
            const int kernel_index = (ky + 1) * 3 + (kx + 1);
            const uint8_t pixel = input[(y + ky) * width + (x + kx)];
            sum_x += static_cast<float>(pixel) * static_cast<float>(kGx[kernel_index]);
            sum_y += static_cast<float>(pixel) * static_cast<float>(kGy[kernel_index]);
        }
    }

    const int output_index = out_y * out_width + out_x;
    magnitude[output_index] = sqrtf(sum_x * sum_x + sum_y * sum_y);
    direction[output_index] = atan2f(sum_y, sum_x);
}

}  // namespace

CudaTimingBreakdown compute_sobel_cuda(
    const uint8_t* input,
    int width,
    int height,
    float* magnitude,
    float* direction
) {
    CudaTimingBreakdown timing;
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

        const dim3 block(16, 16);
        const dim3 grid(
            static_cast<unsigned int>((width - 2 + block.x - 1) / block.x),
            static_cast<unsigned int>((height - 2 + block.y - 1) / block.y)
        );

        check_cuda(
            cudaEventRecord(kernel_start),
            "cudaEventRecord(kernel_start)"
        );
        sobel_kernel<<<grid, block>>>(d_input, width, height, d_magnitude, d_direction);
        check_cuda(cudaGetLastError(), "sobel_kernel launch");
        check_cuda(cudaEventRecord(kernel_stop), "cudaEventRecord(kernel_stop)");
        check_cuda(cudaEventSynchronize(kernel_stop), "cudaEventSynchronize(kernel_stop)");
        timing.kernel_ms = elapsed_event_ms(kernel_start, kernel_stop);
        check_cuda(cudaDeviceSynchronize(), "cudaDeviceSynchronize");

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
