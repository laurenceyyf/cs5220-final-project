#include <cstdint>
#include <chrono>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
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

struct ProgramOptions {
    std::string input_path;
    std::string output_path;
    int width = 0;
    int height = 0;
    int repeats = 1;
    int warmup = 0;
    std::string csv_path;
    bool csv_append = false;
    bool no_output_write = false;
    CudaLaunchConfig launch_config;
};

struct RunResult {
    CudaTimingBreakdown timing;
    double cuda_section_ms = 0.0;
};

void print_timing_line(const std::string& label, double milliseconds) {
    std::cout << "  " << std::left << std::setw(22) << label
              << std::right << std::fixed << std::setprecision(3)
              << milliseconds << " ms" << std::endl;
}

void print_usage(const char* program) {
    std::cerr
        << "Usage: " << program << " [options] <input.bin> <output.bin> <width> <height>\n"
        << "\n"
        << "Options:\n"
        << "  --variant NAME        CUDA kernel variant: naive, atan_approx,\n"
        << "                        shared, shared_atan_approx\n"
        << "  --block WxH           CUDA thread block shape, default 16x16\n"
        << "  --block-x N           CUDA block x dimension\n"
        << "  --block-y N           CUDA block y dimension\n"
        << "  --num-gpus N          Split the image across N GPUs for strong scaling\n"
        << "  --warmup N            Warm-up runs before measured runs, default 0\n"
        << "  --repeats N           Measured runs, default 1\n"
        << "  --csv PATH            Write per-run timing rows to CSV\n"
        << "  --csv-append          Append CSV rows instead of replacing the file\n"
        << "  --no-output-write     Skip writing the output .bin file\n"
        << "  --skip-d2h            Skip device-to-host output copies; requires --no-output-write\n"
        << "  --help                Show this help text\n";
}

int parse_nonnegative_int(const std::string& value, const std::string& label) {
    size_t consumed = 0;
    int parsed = 0;
    try {
        parsed = std::stoi(value, &consumed);
    } catch (const std::exception&) {
        throw std::runtime_error(label + " must be an integer");
    }
    if (consumed != value.size() || parsed < 0) {
        throw std::runtime_error(label + " must be a nonnegative integer");
    }
    return parsed;
}

int parse_positive_int(const std::string& value, const std::string& label) {
    const int parsed = parse_nonnegative_int(value, label);
    if (parsed <= 0) {
        throw std::runtime_error(label + " must be positive");
    }
    return parsed;
}

std::string next_arg(int& index, int argc, char* argv[], const std::string& option) {
    if (index + 1 >= argc) {
        throw std::runtime_error(option + " requires a value");
    }
    ++index;
    return argv[index];
}

void parse_block_shape(const std::string& value, ProgramOptions& options) {
    size_t separator = value.find('x');
    if (separator == std::string::npos) {
        separator = value.find('X');
    }
    if (separator == std::string::npos) {
        throw std::runtime_error("--block must use WxH format, for example 16x16");
    }

    options.launch_config.block_x =
        parse_positive_int(value.substr(0, separator), "block x dimension");
    options.launch_config.block_y =
        parse_positive_int(value.substr(separator + 1), "block y dimension");
}

CudaKernelVariant parse_kernel_variant(const std::string& value) {
    if (value == "naive") {
        return CudaKernelVariant::NaiveExact;
    }
    if (value == "atan_approx") {
        return CudaKernelVariant::NaiveAtanApprox;
    }
    if (value == "shared") {
        return CudaKernelVariant::SharedExact;
    }
    if (value == "shared_atan_approx") {
        return CudaKernelVariant::SharedAtanApprox;
    }

    throw std::runtime_error(
        "unknown --variant value: " + value
        + " (expected naive, atan_approx, shared, or shared_atan_approx)"
    );
}

ProgramOptions parse_args(int argc, char* argv[]) {
    ProgramOptions options;
    std::vector<std::string> positional;

    for (int i = 1; i < argc; ++i) {
        const std::string arg = argv[i];
        if (arg == "--help" || arg == "-h") {
            print_usage(argv[0]);
            std::exit(0);
        } else if (arg == "--variant") {
            options.launch_config.variant =
                parse_kernel_variant(next_arg(i, argc, argv, arg));
        } else if (arg == "--block") {
            parse_block_shape(next_arg(i, argc, argv, arg), options);
        } else if (arg == "--block-x") {
            options.launch_config.block_x =
                parse_positive_int(next_arg(i, argc, argv, arg), "block x dimension");
        } else if (arg == "--block-y") {
            options.launch_config.block_y =
                parse_positive_int(next_arg(i, argc, argv, arg), "block y dimension");
        } else if (arg == "--num-gpus") {
            options.launch_config.num_gpus =
                parse_positive_int(next_arg(i, argc, argv, arg), "number of GPUs");
            options.launch_config.use_multi_gpu = true;
        } else if (arg == "--warmup") {
            options.warmup = parse_nonnegative_int(next_arg(i, argc, argv, arg), "warmup");
        } else if (arg == "--repeats") {
            options.repeats = parse_positive_int(next_arg(i, argc, argv, arg), "repeats");
        } else if (arg == "--csv") {
            options.csv_path = next_arg(i, argc, argv, arg);
        } else if (arg == "--csv-append") {
            options.csv_append = true;
        } else if (arg == "--no-output-write") {
            options.no_output_write = true;
        } else if (arg == "--skip-d2h") {
            options.launch_config.copy_output_to_host = false;
        } else if (!arg.empty() && arg[0] == '-') {
            throw std::runtime_error("unknown option: " + arg);
        } else {
            positional.push_back(arg);
        }
    }

    if (positional.size() != 4) {
        std::ostringstream oss;
        oss << "expected 4 positional arguments, got " << positional.size();
        throw std::runtime_error(oss.str());
    }

    options.input_path = positional[0];
    options.output_path = positional[1];
    options.width = parse_positive_int(positional[2], "width");
    options.height = parse_positive_int(positional[3], "height");

    if (!options.launch_config.copy_output_to_host && !options.no_output_write) {
        throw std::runtime_error("--skip-d2h requires --no-output-write");
    }
    return options;
}

CudaTimingBreakdown average_timing(const std::vector<RunResult>& results) {
    CudaTimingBreakdown avg;
    if (results.empty()) {
        return avg;
    }

    avg.variant = results.front().timing.variant;
    avg.block_x = results.front().timing.block_x;
    avg.block_y = results.front().timing.block_y;
    avg.num_gpus = results.front().timing.num_gpus;
    avg.grid_x = results.front().timing.grid_x;
    avg.grid_y = results.front().timing.grid_y;
    avg.copied_output_to_host = results.front().timing.copied_output_to_host;

    for (const RunResult& result : results) {
        avg.allocation_ms += result.timing.allocation_ms;
        avg.h2d_ms += result.timing.h2d_ms;
        avg.kernel_ms += result.timing.kernel_ms;
        avg.d2h_ms += result.timing.d2h_ms;
        avg.free_ms += result.timing.free_ms;
    }

    const double n = static_cast<double>(results.size());
    avg.allocation_ms /= n;
    avg.h2d_ms /= n;
    avg.kernel_ms /= n;
    avg.d2h_ms /= n;
    avg.free_ms /= n;
    return avg;
}

double average_cuda_section_ms(const std::vector<RunResult>& results) {
    if (results.empty()) {
        return 0.0;
    }
    double total = 0.0;
    for (const RunResult& result : results) {
        total += result.cuda_section_ms;
    }
    return total / static_cast<double>(results.size());
}

std::string csv_escape(const std::string& value) {
    bool needs_quotes = false;
    for (char ch : value) {
        if (ch == ',' || ch == '"' || ch == '\n') {
            needs_quotes = true;
            break;
        }
    }
    if (!needs_quotes) {
        return value;
    }

    std::string escaped = "\"";
    for (char ch : value) {
        if (ch == '"') {
            escaped += "\"\"";
        } else {
            escaped += ch;
        }
    }
    escaped += "\"";
    return escaped;
}

void write_csv_rows(
    const ProgramOptions& options,
    const std::vector<RunResult>& results,
    size_t total_pixels
) {
    if (options.csv_path.empty()) {
        return;
    }

    bool need_header = true;
    if (options.csv_append) {
        std::ifstream existing(options.csv_path);
        need_header = !existing.good() || existing.peek() == std::ifstream::traits_type::eof();
    }

    std::ofstream csv(
        options.csv_path,
        options.csv_append ? std::ios::app : std::ios::trunc
    );
    if (!csv) {
        throw std::runtime_error("Could not open CSV file " + options.csv_path);
    }

    if (need_header) {
        csv << "input_path,width,height,variant,total_pixels,warmup_runs,block_x,block_y,"
            << "num_gpus,grid_x,grid_y,run,allocation_ms,h2d_ms,kernel_ms,d2h_ms,"
            << "free_ms,cuda_section_ms,copied_output_to_host,no_output_write\n";
    }

    csv << std::fixed << std::setprecision(6);
    for (size_t i = 0; i < results.size(); ++i) {
        const RunResult& result = results[i];
        csv << csv_escape(options.input_path) << ','
            << options.width << ','
            << options.height << ','
            << cuda_kernel_variant_name(result.timing.variant) << ','
            << total_pixels << ','
            << options.warmup << ','
            << result.timing.block_x << ','
            << result.timing.block_y << ','
            << result.timing.num_gpus << ','
            << result.timing.grid_x << ','
            << result.timing.grid_y << ','
            << i << ','
            << result.timing.allocation_ms << ','
            << result.timing.h2d_ms << ','
            << result.timing.kernel_ms << ','
            << result.timing.d2h_ms << ','
            << result.timing.free_ms << ','
            << result.cuda_section_ms << ','
            << (result.timing.copied_output_to_host ? 1 : 0) << ','
            << (options.no_output_write ? 1 : 0) << '\n';
    }
}

}  // namespace

int main(int argc, char* argv[]) {
    try {
        const auto total_start = std::chrono::steady_clock::now();

        const ProgramOptions options = parse_args(argc, argv);

        if (options.width < 3 || options.height < 3) {
            throw std::runtime_error("width and height must both be at least 3");
        }

        const size_t total_pixels = static_cast<size_t>(options.width) * options.height;
        const size_t magdir_size =
            static_cast<size_t>(options.width - 2) * (options.height - 2);

        std::ifstream is(options.input_path, std::ios::binary);
        if (!is) {
            throw std::runtime_error("Could not open input file " + options.input_path);
        }

        // Read the raw grayscale image from disk into host memory.
        const auto read_start = std::chrono::steady_clock::now();
        std::vector<uint8_t> img_data(total_pixels);
        is.read(reinterpret_cast<char*>(img_data.data()), total_pixels);
        if (static_cast<size_t>(is.gcount()) != total_pixels) {
            throw std::runtime_error("Input file size does not match width * height");
        }
        const auto read_end = std::chrono::steady_clock::now();

        std::vector<float> magnitude;
        std::vector<float> direction;
        if (options.launch_config.copy_output_to_host) {
            magnitude.assign(magdir_size, 0.0f);
            direction.assign(magdir_size, 0.0f);
        }

        float* magnitude_ptr = magnitude.empty() ? nullptr : magnitude.data();
        float* direction_ptr = direction.empty() ? nullptr : direction.data();

        std::cout << "Processing " << options.width << "x" << options.height
                  << " image on CUDA with variant "
                  << cuda_kernel_variant_name(options.launch_config.variant)
                  << ", "
                  << options.launch_config.num_gpus << " GPU(s) and block "
                  << options.launch_config.block_x << "x"
                  << options.launch_config.block_y << "..." << std::endl;

        for (int run = 0; run < options.warmup; ++run) {
            compute_sobel_cuda(
                img_data.data(),
                options.width,
                options.height,
                magnitude_ptr,
                direction_ptr,
                options.launch_config
            );
        }

        std::vector<RunResult> results;
        results.reserve(static_cast<size_t>(options.repeats));
        for (int run = 0; run < options.repeats; ++run) {
            RunResult result;
            const auto compute_start = std::chrono::steady_clock::now();
            result.timing = compute_sobel_cuda(
                img_data.data(),
                options.width,
                options.height,
                magnitude_ptr,
                direction_ptr,
                options.launch_config
            );
            const auto compute_end = std::chrono::steady_clock::now();
            result.cuda_section_ms = elapsed_ms(compute_start, compute_end);
            results.push_back(result);
        }

        double output_write_ms = 0.0;
        if (!options.no_output_write) {
            std::ofstream os(options.output_path, std::ios::binary);
            if (!os) {
                throw std::runtime_error("Could not open output file " + options.output_path);
            }

            // Write the packed [magnitude][direction] output file.
            const auto write_start = std::chrono::steady_clock::now();
            os.write(
                reinterpret_cast<const char*>(magnitude.data()),
                magdir_size * sizeof(float)
            );
            os.write(
                reinterpret_cast<const char*>(direction.data()),
                magdir_size * sizeof(float)
            );
            if (!os) {
                throw std::runtime_error("Failed while writing output file " + options.output_path);
            }
            const auto write_end = std::chrono::steady_clock::now();
            output_write_ms = elapsed_ms(write_start, write_end);
        }

        const auto total_end = std::chrono::steady_clock::now();

        write_csv_rows(options, results, total_pixels);

        if (options.no_output_write) {
            std::cout << "Success. Output file write skipped." << std::endl;
        } else {
            std::cout << "Success. Results stored in " << options.output_path << std::endl;
        }

        const CudaTimingBreakdown avg_timing = average_timing(results);
        std::cout << "Measured runs: " << options.repeats
                  << " after " << options.warmup << " warm-up run(s)" << std::endl;
        std::cout << "CUDA variant: " << cuda_kernel_variant_name(avg_timing.variant) << std::endl;
        std::cout << "CUDA GPUs used: " << avg_timing.num_gpus << std::endl;
        std::cout << "CUDA grid: " << avg_timing.grid_x << "x"
                  << avg_timing.grid_y << std::endl;
        std::cout << "Timing summary (average measured run):" << std::endl;
        print_timing_line("host input read", elapsed_ms(read_start, read_end));
        print_timing_line("device allocation", avg_timing.allocation_ms);
        print_timing_line("host to device", avg_timing.h2d_ms);
        print_timing_line("kernel execution", avg_timing.kernel_ms);
        print_timing_line("device to host", avg_timing.d2h_ms);
        print_timing_line("device free", avg_timing.free_ms);
        print_timing_line("cuda section total", average_cuda_section_ms(results));
        if (!options.no_output_write) {
            print_timing_line("host output write", output_write_ms);
        }
        print_timing_line("end-to-end total", elapsed_ms(total_start, total_end));
        if (!options.csv_path.empty()) {
            std::cout << "CSV timing rows: " << options.csv_path << std::endl;
        }
        return 0;
    } catch (const std::exception& ex) {
        std::cerr << "Error: " << ex.what() << std::endl;
        print_usage(argv[0]);
        return 1;
    }
}
