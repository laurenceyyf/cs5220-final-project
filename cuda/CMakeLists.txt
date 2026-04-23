cmake_minimum_required(VERSION 3.18)
project(SobelCUDA LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_STANDARD 17)

set(CMAKE_CUDA_ARCHITECTURES 80)

find_package(CUDAToolkit REQUIRED)

add_executable(sobel_cuda 
    main.cpp 
    kernel.cu
)

target_link_libraries(sobel_cuda PRIVATE 
    CUDA::cudart
)

target_compile_options(sobel_cuda PUBLIC
    $<$<COMPILE_LANGUAGE:CUDA>:--use_fast_math -O3>
)
