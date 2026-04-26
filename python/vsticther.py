import pandas as pd
import numpy as np
import argparse
from sobel_reference import sobel_reference

IMAGE_EDGE_DIM = 28

def build_parser() -> argparse.ArgumentParser:
    # Define command line arguments for the checker.
    parser = argparse.ArgumentParser(
        description="Create stictched image of height * width images and sobel output."
    )
    # parser.add_argument("output",  help="Path to program output for uint8 .img.bin and float32 .magdir.bin")
    parser.add_argument("height",  type=int, default=10, help="Image height in pixels")
    parser.add_argument("width",  type=int, default=10, help="Image width in pixels")
    return parser

def sobel_vectorized(image: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    image = np.asarray(image, dtype=np.float32)
    print(image.shape)
    
    # Define kernels (assuming these were global in your snippet)
    GX = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]], dtype=np.float32)
    GY = np.array([[-1, -2, -1], [0, 0, 0], [1, 2, 1]], dtype=np.float32)

    # Use Scipy's convolution (much faster than manual loops)
    from scipy.signal import convolve2d
    
    # 'valid' mode automatically handles the (height-2, width-2) requirement
    gx = convolve2d(image, GX, mode='valid')
    gy = convolve2d(image, GY, mode='valid')

    magnitude = np.sqrt(gx**2 + gy**2)
    direction = np.arctan2(gy, gx)
    print(direction)
    print(magnitude.shape, direction.shape)
    return magnitude, direction

def stitch_images(data, pixel_height, pixel_width, img_dim=28):
    """
    data: np.ndarray of shape (N, img_dim**2)
    pixel_height: target height in pixels
    pixel_width: target width in pixels
    """
    # 1. Calculate necessary grid size
    grid_rows = int(np.ceil(pixel_height / img_dim))
    grid_cols = int(np.ceil(pixel_width / img_dim))
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
    cropped = stitched[:pixel_height, :pixel_width]
    return cropped.ravel()



def main():
    args = build_parser().parse_args()
    df = pd.read_csv("./fashion-mnist_test.csv")
    df = df.drop(['label'], axis=1)
    arr = df.to_numpy('uint8')
    print('generating image')
    stitch_images_arr = stitch_images(arr, args.height, args.width)
    print('writing image')
    # stitch_images_arr.tofile(f"{args.output}_{args.height}_{args.width}.img.bin")
    
    print('running sobel')
    magnitude, direction = sobel_vectorized(stitch_images_arr.reshape(args.height, args.width))

    actmag, actdir = sobel_reference(stitch_images_arr.reshape(args.height, args.width))
    print(np.allclose(magnitude, actmag))
    print(np.allclose(direction, actdir))

    print('writing output')
    combined_floats = np.concatenate([magnitude, direction]).astype('float32')
    # combined_floats.tofile(f"{args.output}_{args.height}_{args.width}.magdir.bin")

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