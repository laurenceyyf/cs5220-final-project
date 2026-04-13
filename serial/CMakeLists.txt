cmake_minimum_required(VERSION 3.18)
project(SobelSerial LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

# Find OpenCV for image loading/saving [cite: 74]
find_package(OpenCV REQUIRED)

add_executable(sobel_serial main.cpp)

target_include_directories(sobel_serial PRIVATE ${OpenCV_INCLUDE_DIRS})
target_link_libraries(sobel_serial PRIVATE ${OpenCV_LIBS})
