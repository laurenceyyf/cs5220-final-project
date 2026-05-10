# Private Demo Notes

## GPU Login

Request one interactive GPU node for 30 minutes:

```bash
salloc --nodes 1 --qos interactive --time 00:30:00 -C gpu -G 4 --account=m4341_g
```

Go to the project directory:

```bash
cd /global/homes/y/yz3526/CS5220/cs5220-final-project
```

Optional quick check:

```bash
echo $CUDA_VISIBLE_DEVICES
nvidia-smi -L
```

Expected: 4 visible A100 GPUs.

## Build CUDA

Configure once:

```bash
cmake -S cuda -B cuda/build
```

Build:

```bash
cmake --build cuda/build
```

`cmake -S ... -B ...` prepares the build directory.

`cmake --build ...` compiles the executable.

## Serial Pipeline

Run serial correctness check:

```bash
./run_serial_pipeline.sh demo 100 100 --skip-build
```

What it does:

- generates a stitched input image
- generates a NumPy reference output
- runs the serial Sobel program
- compares serial output against the reference

## CUDA Pipeline

Run CUDA correctness check:

```bash
./run_cuda_pipeline.sh demo 100 100 --skip-build
```

What it does:

- generates a stitched input image
- generates a NumPy reference output
- runs the CUDA Sobel program
- compares CUDA output against the reference
- prints a timing summary

## Good Demo Commands

Small smoke test:

```bash
./run_serial_pipeline.sh smoke 28 28 --skip-build
./run_cuda_pipeline.sh smoke 28 28 --skip-build
```

Normal square case:

```bash
./run_serial_pipeline.sh demo 100 100 --skip-build
./run_cuda_pipeline.sh demo 100 100 --skip-build
```

Rectangular case:

```bash
./run_serial_pipeline.sh rect 100 80 --skip-build
./run_cuda_pipeline.sh rect 100 80 --skip-build
```

## Naming Reminder

In commands like:

```bash
./run_cuda_pipeline.sh demo 100 100 --skip-build
```

- `demo` is just a file prefix
- `100 100` means width and height in pixels

## When To Use `--skip-build`

Use `--skip-build` only if the executable is already built and code has not changed.

If CUDA code changed:

```bash
cmake --build cuda/build
```

If serial code changed:

```bash
cmake --build serial/build
```

## Very Short Demo Flow

```bash
salloc --nodes 1 --qos interactive --time 00:30:00 -C gpu -G 4 --account=m4341_g
cd /global/homes/y/yz3526/CS5220/cs5220-final-project
cmake -S cuda -B cuda/build
cmake --build cuda/build
./run_serial_pipeline.sh demo 100 100 --skip-build
./run_cuda_pipeline.sh demo 100 100 --skip-build
```
