import pandas as pd
import numpy as np
import argparse
from sobel_reference import sobel_reference

IMAGE_EDGE_DIM = 28

def build_parser() -> argparse.ArgumentParser:
    # Define command line arguments for the checker.
    parser = argparse.ArgumentParser(
        description="Create stictched image of width * height images and sobel output."
    )
    parser.add_argument("output",  help="Path to program output for uint8 .img.bin and float32 .magdir.bin")
    parser.add_argument("width",  type=int, default=10, help="Image width in pixels")
    parser.add_argument("height",  type=int, default=10, help="Image height in pixels")
    return parser

def stitch_images(data, pixel_rows, pixel_cols, img_dim=28):
    """
    data: np.ndarray of shape (N, img_dim**2)
    pixel_rows: target height in pixels
    pixel_cols: target width in pixels
    """
    # 1. Calculate necessary grid size
    grid_rows = int(np.ceil(pixel_rows / img_dim))
    grid_cols = int(np.ceil(pixel_cols / img_dim))
    n_images = grid_rows * grid_cols
    
    # 2. Grab and reshape subset
    rng = np.random.default_rng()
    subset = rng.choice(data, size=n_images, replace=True, axis=0).reshape(n_images, img_dim, img_dim)
    
    # 3. Reshape into grid structure
    grid = subset.reshape(grid_rows, grid_cols, img_dim, img_dim)
    
    # 4. Transpose and reshape to create the full image
    # We transpose to (rows, img_h, cols, img_w) then reshape to merge the dims
    stitched = grid.transpose(0, 2, 1, 3).reshape(grid_rows * img_dim, grid_cols * img_dim)
    
    # 5. Crop to the exact pixel dimensions requested
    cropped = stitched[:pixel_rows, :pixel_cols]
    
    return cropped.ravel()



def main():
    args = build_parser().parse_args()
    df = pd.read_csv("./fashion-mnist_test.csv")
    df = df.drop(['label'], axis=1)
    arr = df.to_numpy('uint8')
    stitch_images_arr = stitch_images(arr, args.width, args.height)
    
    magnitude, direction = sobel_reference(stitch_images_arr.reshape(args.width, args.height))
    stitch_images_arr.tofile(f"{args.output}_{args.width}_{args.height}.img.bin")
    
    combined_floats = np.concatenate([magnitude, direction]).astype('float32')
    combined_floats.tofile(f"{args.output}_{args.width}_{args.height}.magdir.bin")

if __name__ == "__main__": 
    main()


"""
// to read .img.bin
#include <fstream>
#include <vector>

// ... inside a function
std::ifstream file("stitched_image.bin", std::ios::binary);
std::vector<uint8_t> buffer((std::istreambuf_iterator<char>(file)), 
                             std::istreambuf_iterator<char>());



// to read .magdir.bin
int total_pixels = rows * cols; // e.g., 278 * 278
std::ifstream file("kernel_results.bin", std::ios::binary);

std::vector<float> all_floats(total_pixels * 2);
file.read(reinterpret_cast<char*>(all_floats.data()), all_floats.size() * sizeof(float));

// Split pointers for easy access
float* magnitude = &all_floats[0];
float* direction = &all_floats[total_pixels];
"""