cmake_minimum_required(VERSION 3.18)
project(SobelMPI LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

find_package(MPI REQUIRED)

add_executable(sobel_mpi 
    main.cpp 
)

target_link_libraries(sobel_mpi PRIVATE 
    MPI::MPI_CXX 
)


add_executable(sobel_mpi1d 
    mpi_1d.cpp 
)

target_compile_options(sobel_mpi1d PRIVATE -mavx2)
target_link_libraries(sobel_mpi1d PRIVATE 
    MPI::MPI_CXX 
)

add_executable(sobel_mpi2d 
    mpi_2d.cpp 
)

target_compile_options(sobel_mpi2d PRIVATE -mavx2)
target_link_libraries(sobel_mpi2d PRIVATE 
    MPI::MPI_CXX 
)
