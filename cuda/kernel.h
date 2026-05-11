#pragma once

#include <cstdint>

enum class CudaKernelVariant {
    NaiveExact = 0,
    NaiveAtanApprox,
    SharedExact,
    SharedAtanApprox,
};

enum class CudaAtanMethod {
    Exact = 0,
    Approx1Deg,
    Approx2Deg,
    Approx5Deg,
    Approx11Deg,
    Approx15Deg,
};

struct CudaTimingBreakdown {
    CudaKernelVariant variant = CudaKernelVariant::NaiveExact;
    CudaAtanMethod atan_method = CudaAtanMethod::Exact;
    int num_gpus = 1;
    int block_x = 0;
    int block_y = 0;
    int grid_x = 0;
    int grid_y = 0;
    bool copied_output_to_host = true;
    double allocation_ms = 0.0;
    double h2d_ms = 0.0;
    double kernel_ms = 0.0;
    double d2h_ms = 0.0;
    double free_ms = 0.0;
};

struct CudaLaunchConfig {
    int block_x = 16;
    int block_y = 16;
    int num_gpus = 1;
    bool use_multi_gpu = false;
    bool copy_output_to_host = true;
    CudaKernelVariant variant = CudaKernelVariant::NaiveExact;
    CudaAtanMethod atan_method = CudaAtanMethod::Exact;
};

const char* cuda_kernel_variant_name(CudaKernelVariant variant);
const char* cuda_kernel_implementation_name(CudaKernelVariant variant);
const char* cuda_atan_method_name(CudaAtanMethod method);

CudaTimingBreakdown compute_sobel_cuda(
    const uint8_t* input,
    int width,
    int height,
    float* magnitude,
    float* direction
);

CudaTimingBreakdown compute_sobel_cuda(
    const uint8_t* input,
    int width,
    int height,
    float* magnitude,
    float* direction,
    const CudaLaunchConfig& launch_config
);
