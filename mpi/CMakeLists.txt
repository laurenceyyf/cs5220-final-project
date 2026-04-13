cmake_minimum_required(VERSION 3.18)
project(SobelMPI LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

find_package(MPI REQUIRED)
find_package(OpenCV REQUIRED)

add_executable(sobel_mpi 
    main.cpp 
    mpi_kernel.cpp
)

target_link_libraries(sobel_mpi PRIVATE 
    MPI::MPI_CXX 
    ${OpenCV_LIBS}
)
