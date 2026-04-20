#include <cstdint>
#include <chrono>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

#include "kernel.h"

namespace {

double elapsed_ms(
    const std::chrono::steady_clock::time_point& start,
    const std::chrono::steady_clock::time_point& end
) {
    return std::chrono::duration<double, std::milli>(end - start).count();
}

void print_timing_line(const std::string& label, double milliseconds) {
    std::cout << "  " << std::left << std::setw(22) << label
              << std::right << std::fixed << std::setprecision(3)
              << milliseconds << " ms" << std::endl;
}

}  // namespace

int main(int argc, char* argv[]) {
    if (argc != 5) {
        std::cerr << "Usage: " << argv[0]
                  << " <input.bin> <output.bin> <width> <height>" << std::endl;
        return 1;
    }

    try {
        const auto total_start = std::chrono::steady_clock::now();

        std::string input_path = argv[1];
        std::string output_path = argv[2];
        int width = std::stoi(argv[3]);
        int height = std::stoi(argv[4]);

        if (width < 3 || height < 3) {
            throw std::runtime_error("width and height must both be at least 3");
        }

        const size_t total_pixels = static_cast<size_t>(width) * height;
        const size_t magdir_size = static_cast<size_t>(width - 2) * (height - 2);

        std::ifstream is(input_path, std::ios::binary);
        if (!is) {
            throw std::runtime_error("Could not open input file " + input_path);
        }

        // Read the raw grayscale image from disk into host memory.
        const auto read_start = std::chrono::steady_clock::now();
        std::vector<uint8_t> img_data(total_pixels);
        is.read(reinterpret_cast<char*>(img_data.data()), total_pixels);
        if (static_cast<size_t>(is.gcount()) != total_pixels) {
            throw std::runtime_error("Input file size does not match width * height");
        }
        const auto read_end = std::chrono::steady_clock::now();

        std::vector<float> magnitude(magdir_size, 0.0f);
        std::vector<float> direction(magdir_size, 0.0f);

        std::cout << "Processing " << width << "x" << height
                  << " image on CUDA..." << std::endl;
        // Launch the CUDA path and collect a small timing breakdown.
        const auto compute_start = std::chrono::steady_clock::now();
        CudaTimingBreakdown gpu_timing = compute_sobel_cuda(
            img_data.data(),
            width,
            height,
            magnitude.data(),
            direction.data()
        );
        const auto compute_end = std::chrono::steady_clock::now();

        std::ofstream os(output_path, std::ios::binary);
        if (!os) {
            throw std::runtime_error("Could not open output file " + output_path);
        }

        // Write the packed [magnitude][direction] output file.
        const auto write_start = std::chrono::steady_clock::now();
        os.write(reinterpret_cast<const char*>(magnitude.data()), magdir_size * sizeof(float));
        os.write(reinterpret_cast<const char*>(direction.data()), magdir_size * sizeof(float));
        if (!os) {
            throw std::runtime_error("Failed while writing output file " + output_path);
        }
        const auto write_end = std::chrono::steady_clock::now();

        const auto total_end = std::chrono::steady_clock::now();

        std::cout << "Success. Results stored in " << output_path << std::endl;
        std::cout << "Timing summary:" << std::endl;
        print_timing_line("host input read", elapsed_ms(read_start, read_end));
        print_timing_line("device allocation", gpu_timing.allocation_ms);
        print_timing_line("host to device", gpu_timing.h2d_ms);
        print_timing_line("kernel execution", gpu_timing.kernel_ms);
        print_timing_line("device to host", gpu_timing.d2h_ms);
        print_timing_line("device free", gpu_timing.free_ms);
        print_timing_line("cuda section total", elapsed_ms(compute_start, compute_end));
        print_timing_line("host output write", elapsed_ms(write_start, write_end));
        print_timing_line("end-to-end total", elapsed_ms(total_start, total_end));
        return 0;
    } catch (const std::exception& ex) {
        std::cerr << "Error: " << ex.what() << std::endl;
        return 1;
    }
}
