cmake_minimum_required(VERSION 3.18)
project(SobelMPI LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

# Find MPI and OpenCV
find_package(MPI REQUIRED)
find_package(OpenCV REQUIRED)

# Include both the orchestrator and the kernel logic [cite: 47]
add_executable(sobel_mpi 
    main.cpp 
    mpi_kernel.cpp
)

target_link_libraries(sobel_mpi PRIVATE 
    MPI::MPI_CXX 
    ${OpenCV_LIBS}
)
