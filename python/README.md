# Python Utilities

This folder contains helper scripts for data preparation and correctness checking.

## What Each File Does

- `io_utils.py`
  - Reads and writes raw binary image files.
  - Input images use `uint8`.
  - Sobel outputs use `float32`.

- `export_fashion_mnist.py`
  - Reads the original Fashion-MNIST IDX files.
  - Exports images to our project `.bin` format.
  - Writes a `manifest.csv`.
  - Writes subset lists like `subset_1.txt`, `subset_10.txt`, `subset_100.txt`.

- `sobel_reference.py`
  - Computes the reference Sobel output with NumPy.
  - This is the "correct answer" used for comparison.

- `check_output.py`
  - Compares a program output against the Python reference.
  - Prints error statistics and pass/fail.

## Data Format

### Input image

- grayscale only
- shape: usually `28 x 28`
- layout: row-major
- type: `uint8`
- file size for Fashion-MNIST: `28 * 28 = 784` bytes

### Output image

- Sobel gradient magnitude
- shape: same as input
- layout: row-major
- type: `float32`
- file size for Fashion-MNIST: `28 * 28 * 4 = 3136` bytes

## Important Terms

- `index`
  - The position of one image inside the original dataset.
  - Example: `index = 17` means the 18th image in Fashion-MNIST.

- `label`
  - The class of the clothing item in Fashion-MNIST.
  - This is dataset metadata, not Sobel output.
  - Common labels:
    - `0`: T-shirt/top
    - `1`: Trouser
    - `2`: Pullover
    - `3`: Dress
    - `4`: Coat
    - `5`: Sandal
    - `6`: Shirt
    - `7`: Sneaker
    - `8`: Bag
    - `9`: Ankle boot

- `file name`
  - The exported file stored in this project.
  - Example: `image_00017_label_9.bin`
  - This means:
    - exported image number `17`
    - dataset label `9`

## Typical Workflow

### 1. Export Fashion-MNIST

```bash
python3 python/export_fashion_mnist.py \
  --images path/to/train-images-idx3-ubyte \
  --labels path/to/train-labels-idx1-ubyte \
  --output-dir data/fashion_mnist/train \
  --counts 1 10 100 1000
```

This creates:

- image files like `image_00000_label_9.bin`
- `manifest.csv`
- `subset_1.txt`, `subset_10.txt`, `subset_100.txt`, `subset_1000.txt`

The output files are written into the directory given by `--output-dir`.

### 2. Generate a Reference Sobel Output

```bash
python3 python/sobel_reference.py \
  --input data/fashion_mnist/train/image_00000_label_9.bin \
  --output results/image_00000.ref.bin \
  --width 28 \
  --height 28
```

This reads one input image and writes the expected Sobel output.

### 3. Check a Program Output

```bash
python3 python/check_output.py \
  --input data/fashion_mnist/train/image_00000_label_9.bin \
  --output results/image_00000.serial.bin \
  --width 28 \
  --height 28
```

This script:

1. reads the input image
2. computes the reference Sobel result
3. reads the serial / MPI / CUDA output
4. compares the two arrays

## Notes

- We do not need OpenCV for these Python scripts.
- The reference implementation uses NumPy only.
- Border pixels are set to `0` in the reference Sobel output.
- The Sobel output is `sqrt(gx^2 + gy^2)`.
