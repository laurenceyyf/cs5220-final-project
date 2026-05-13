cmake_minimum_required(VERSION 3.18)
project(SobelMPI LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

find_package(MPI REQUIRED)



add_executable(sobel_mpi1d 
    mpi_1d.cpp 
)

target_link_libraries(sobel_mpi1d PRIVATE 
    MPI::MPI_CXX 
)

add_executable(sobel_mpi2d 
    mpi_2d.cpp 
)

target_link_libraries(sobel_mpi2d PRIVATE 
    MPI::MPI_CXX 
)

target_compile_options(sobel_mpi2d PRIVATE 
        -O3                # Maximum standard optimization
        -march=native      # Optimize for YOUR specific CPU (enables AVX/AVX2/AVX-512)
        -ffast-math        # Crucial for sqrt/atan2; relaxes strict IEEE compliance
        -fopt-info-vec     # GCC: Reports if loops were vectorized
        -funroll-loops     # Helps the CPU pipeline
        -fopt-info-vec-optimized
        -fopt-info-vec-all
)
target_compile_options(sobel_mpi1d PRIVATE 
        -O3                # Maximum standard optimization
        -march=native      # Optimize for YOUR specific CPU (enables AVX/AVX2/AVX-512)
        -ffast-math        # Crucial for sqrt/atan2; relaxes strict IEEE compliance
        -fopt-info-vec     # GCC: Reports if loops were vectorized
        -funroll-loops     # Helps the CPU pipeline
        -fopt-info-vec-optimized
        -fopt-info-vec-all
)