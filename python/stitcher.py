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
    parser.add_argument("width",  type=int, default=10, help="Image width")
    parser.add_argument("height",  type=int, default=10, help="Image height")
    return parser

def stitch_images(data, grid_rows, grid_cols, img_dim=IMAGE_EDGE_DIM):
    """
    data: np.ndarray of shape (N, 784)
    grid_rows: how many images tall the result is
    grid_cols: how many images wide the result is
    """
    n_images = grid_rows * grid_cols
    
    # 1. Grab the subset of images and reshape to 2D
    # Shape: (n_images, 28, 28)
    rng = np.random.default_rng()
    subset = rng.choice(data, size=n_images, replace=True, axis=0).reshape(n_images, img_dim, img_dim)
    # 2. Reshape into the grid structure
    # Shape: (grid_rows, grid_cols, 28, 28)
    grid = subset.reshape(grid_rows, grid_cols, img_dim, img_dim)
    
    # 3. Transpose to align rows correctly
    # We want (grid_rows, img_dim) to be the first two dims to form the vertical axis
    # and (grid_cols, img_width) to form the horizontal axis.
    # Current: (0:g_rows, 1:g_cols, 2:img_h, 3:img_w)
    # Target:  (0:g_rows, 2:img_h, 1:g_cols, 3:img_w)
    stitched = grid.transpose(0, 2, 1, 3)
    
    # 4. Flatten back to the requested row-major 1D array
    # Final shape will be (grid_rows * 28 * grid_cols * 28,)
    return stitched.ravel()



def main():
    args = build_parser().parse_args()
    df = pd.read_csv("./fashion-mnist_test.csv")
    df = df.drop(['label'], axis=1)
    arr = df.to_numpy('uint8')
    stitch_images_arr = stitch_images(arr, args.width, args.height)
    magnitude, direction = sobel_reference(stitch_images_arr.reshape(IMAGE_EDGE_DIM*args.width, IMAGE_EDGE_DIM*args.height))
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