#pragma once

#include <cstdint>

struct CudaTimingBreakdown {
    double allocation_ms = 0.0;
    double h2d_ms = 0.0;
    double kernel_ms = 0.0;
    double d2h_ms = 0.0;
    double free_ms = 0.0;
};

CudaTimingBreakdown compute_sobel_cuda(
    const uint8_t* input,
    int width,
    int height,
    float* magnitude,
    float* direction
);
