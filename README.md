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

The current serial implementation writes one `.magdir.bin` file with two
back-to-back arrays:

- Sobel gradient magnitude for the inner region
- Sobel gradient direction for the inner region
- Row-major layout
- Each array has shape `(height - 2) x (width - 2)`
- Total file contents are exactly `2 * (height - 2) * (width - 2) * 4` bytes

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
- output layout: `[magnitude][direction]`
- valid output region: `(height - 2) x (width - 2)`
- Sobel output: `sqrt(gx^2 + gy^2)`

## One-Command Validation

Use the helper runner to generate a stitched input image, build the serial
program, run it, and compare the output against a NumPy reference.

Example:

```bash
./run_serial_pipeline.sh demo 100 100
```

For CUDA, use the matching wrapper on a node with a CUDA-capable GPU:

```bash
./run_cuda_pipeline.sh demo 100 100
```

This command creates:

- `data/serial_pipeline/demo_100x100.img.bin`
- `data/serial_pipeline/demo_100x100.reference.magdir.bin`
- `data/serial_pipeline/demo_100x100.serial.magdir.bin`

Useful options:

- `--seed 0`: fix the random stitched image for reproducible runs
- `--skip-build`: reuse an existing `serial/build/sobel_serial`
- `--output-dir PATH`: write artifacts into a different directory

## CUDA Benchmarking

The CUDA executable also accepts benchmark-oriented options without changing the
default validation command:

```bash
cuda/build/sobel_cuda \
  --block 16x16 \
  --warmup 1 \
  --repeats 5 \
  --csv data/cuda_benchmark/demo.cuda.csv \
  --no-output-write \
  data/cuda_benchmark/demo.img.bin \
  data/cuda_benchmark/demo.out.bin \
  4096 \
  4096
```

Use the sweep helper to generate a deterministic stitched Fashion-MNIST
grayscale input, run several CUDA block shapes, and write one CSV for plotting:

```bash
python3 tools/cuda_profile_sweep.py \
  --width 4096 \
  --height 4096 \
  --repeats 5 \
  --warmup 1
```

The benchmark input defaults to `--input-source fashion_mnist`, using
`python/fashion-mnist_test.csv` and the selected `--seed` to tile 28x28 examples
into the requested image size. For synthetic stress tests, pass
`--input-source random`.

To compare global-memory and shared-memory kernels across exact and approximate
direction calculations, use `--variants` and `--atan-methods`:

```bash
python3 tools/cuda_profile_sweep.py \
  --width 4096 \
  --height 4096 \
  --variants naive shared \
  --atan-methods exact approx_1deg approx_2deg approx_15deg \
  --blocks 8x8 16x16 32x8 32x16 \
  --repeats 5 \
  --warmup 1 \
  --measure-error
```

The CUDA CSV includes per-run `h2d_ms`, `kernel_ms`, `d2h_ms`, `total_ms`,
`implementation`, `atan_method`, `mean_error_deg`, and `max_error_deg` columns.

For pure kernel timing, add `--kernel-only`; otherwise the CSV includes H2D,
kernel, and D2H timing. Plot the CSV with:

```bash
python3 tools/plot_cuda_benchmark.py data/cuda_benchmark/cuda_sobel_4096x4096.cuda.csv
```

For CUDA strong scaling, keep the input size and block shape fixed while
varying the number of GPUs:

```bash
python3 tools/cuda_profile_sweep.py \
  --width 32768 \
  --height 32768 \
  --gpus 1 2 4 \
  --block 16x16 \
  --repeats 5 \
  --warmup 1 \
  --kernel-only \
  --csv data/cuda_benchmark/cuda_sobel_32768x32768.multi_gpu.csv
```

The plotting helper groups multi-GPU CSVs by `num_gpus`, uses a log2 x-axis for
strong scaling plots, and includes an ideal baseline in the speedup plot when
Matplotlib is available.

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
