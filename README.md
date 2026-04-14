# Sobel Edge Detection Project

This repository compares three Sobel edge detection implementations:

- `serial/`: serial CPU baseline
- `mpi/`: MPI CPU version
- `cuda/`: CUDA GPU version

## Data Format

For correctness testing and benchmarking, we use a simple binary image format.

### Input image (`uint8`)

- Grayscale only
- Row-major layout
- Shape is provided on the command line
- File contents are exactly `height * width` bytes

For Fashion-MNIST, the default shape is `28 x 28`.

### Output image (`float32`)

- Sobel gradient magnitude
- Row-major layout
- Shape matches the input image
- File contents are exactly `height * width * 4` bytes

## Python Utilities

The `python/` directory contains:

- `io_utils.py`: binary image I/O helpers
- `sobel_reference.py`: NumPy reference Sobel implementation
- `check_output.py`: compares program output against the reference
- `export_fashion_mnist.py`: exports Fashion-MNIST images to `.bin`

### Example

```bash
python3 python/check_output.py \
  --input data/sample_0001.bin \
  --output results/sample_0001.out.bin \
  --width 28 \
  --height 28
```

The checker assumes:

- input dtype: `uint8`
- output dtype: `float32`
- border handling: border pixels are set to `0`
- Sobel output: `sqrt(gx^2 + gy^2)`

## Exporting Fashion-MNIST

The exporter reads Fashion-MNIST from the original IDX files and writes a set of
grayscale `.bin` images.

Expected source files:

- `train-images-idx3-ubyte`
- `train-labels-idx1-ubyte`
- `t10k-images-idx3-ubyte`
- `t10k-labels-idx1-ubyte`

Example:

```bash
python3 python/export_fashion_mnist.py \
  --images path/to/train-images-idx3-ubyte \
  --labels path/to/train-labels-idx1-ubyte \
  --output-dir data/fashion_mnist/train \
  --counts 1 10 100 1000
```

This will create:

- image files such as `image_00000_label_9.bin`
- `manifest.csv` with file names, labels, and source indices
