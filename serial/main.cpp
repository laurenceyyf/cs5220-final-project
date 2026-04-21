#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <string>

void compute_sobel(const uint8_t* input, int height, int width, float* magnitude, float* direction) {
    const int Gx[3][3] = {
        {-1, 0, 1},
        {-2, 0, 2},
        {-1, 0, 1}
    };
    
    const int Gy[3][3] = {
        {-1, -2, -1},
        { 0,  0,  0},
        { 1,  2,  1}
    };

    size_t magdir_size = static_cast<size_t>(width-2) * (height-2);
    for (size_t i = 0; i < magdir_size; ++i) {
        magnitude[i] = 0.0f;
        direction[i] = 0.0f;
    }

    for (int y = 1; y < height - 1; ++y) {
        for (int x = 1; x < width - 1; ++x) {
            float sumX = 0.0f;
            float sumY = 0.0f;

            for (int ky = -1; ky <= 1; ++ky) {
                for (int kx = -1; kx <= 1; ++kx) {
                    uint8_t pixel = input[(y + ky) * width + (x + kx)];
                    sumX += pixel * Gx[ky + 1][kx + 1];
                    sumY += pixel * Gy[ky + 1][kx + 1];
                }
            }

            magnitude[(y-1) * (width-2) + (x-1)] = std::sqrt(sumX * sumX + sumY * sumY);
            direction[(y-1) * (width-2) + (x-1)] = std::atan2(sumY, sumX);
        }
    }
}

int main(int argc, char* argv[]) {
    std::string input_path = argv[1];
    std::string output_path = argv[2];
    int height = std::stoi(argv[3]);
    int width = std::stoi(argv[4]);
    size_t total_pixels = static_cast<size_t>(width) * height;
    size_t magdir_size = static_cast<size_t>(width-2) * (height-2);

    // std::cout << input_path << std::endl;
    std::ifstream is(input_path, std::ios::binary);
    if (!is) {
        std::cerr << "Error: Could not open input file " << input_path << std::endl;
        return 1;
    }
    std::vector<uint8_t> img_data(total_pixels);
    is.read(reinterpret_cast<char*>(img_data.data()), total_pixels);
    is.close();

    // for(int i = 0; i < 4; i++){
    //     for (int j = 0; j < 9; j++){
    //         std::cout << static_cast<int>(img_data[i*9 + j]) <<", "; 
    //     }
    //     std::cout <<std::endl; 
    // }
    
    std::vector<float> magnitude(magdir_size);
    std::vector<float> direction(magdir_size);

    // std::cout << "Processing h:" << height << " w:" << width << " image..." << std::endl;
    compute_sobel(img_data.data(), height, width, magnitude.data(), direction.data());

    std::ofstream os(output_path, std::ios::binary);
    if (!os) {
        std::cerr << "Error: Could not open output file " << output_path << std::endl;
        return 1;
    }
    os.write(reinterpret_cast<const char*>(magnitude.data()), magdir_size * sizeof(float));
    os.write(reinterpret_cast<const char*>(direction.data()), magdir_size * sizeof(float));
    os.close();

    std::cout << "Success. Results stored in " << output_path << std::endl;
    return 0;
}