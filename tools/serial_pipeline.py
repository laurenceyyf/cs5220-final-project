#!/usr/bin/env python3
"""End-to-end Sobel validation runner."""

import argparse
import math
import subprocess
import sys
from pathlib import Path

import numpy as np


REPO_ROOT = Path(__file__).resolve().parents[1]
CSV_PATH = REPO_ROOT / "python" / "fashion-mnist_test.csv"
DEFAULT_OUTPUT_DIR = REPO_ROOT / "data" / "serial_pipeline"
IMAGE_EDGE_DIM = 28

BACKEND_CONFIG = {
    "serial": {
        "source_dir": REPO_ROOT / "serial",
        "build_dir": REPO_ROOT / "serial" / "build",
        "binary": REPO_ROOT / "serial" / "build" / "sobel_serial",
        "output_suffix": "serial",
    },
    "cuda": {
        "source_dir": REPO_ROOT / "cuda",
        "build_dir": REPO_ROOT / "cuda" / "build",
        "binary": REPO_ROOT / "cuda" / "build" / "sobel_cuda",
        "output_suffix": "cuda",
    },
}

GX = np.array(
    [
        [-1.0, 0.0, 1.0],
        [-2.0, 0.0, 2.0],
        [-1.0, 0.0, 1.0],
    ],
    dtype=np.float32,
)

GY = np.array(
    [
        [-1.0, -2.0, -1.0],
        [0.0, 0.0, 0.0],
        [1.0, 2.0, 1.0],
    ],
    dtype=np.float32,
)


def build_parser():
    parser = argparse.ArgumentParser(
        description=(
            "Generate a stitched Fashion-MNIST test image, run the serial Sobel "
            "implementation, and compare the output against a NumPy reference."
        )
    )
    parser.add_argument("prefix", help="File prefix for generated artifacts")
    parser.add_argument("width", type=int, help="Input image width in pixels")
    parser.add_argument("height", type=int, help="Input image height in pixels")
    parser.add_argument(
        "--backend",
        choices=sorted(BACKEND_CONFIG),
        default="serial",
        help="Implementation to build and validate",
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=0,
        help="Random seed for stitched image generation",
    )
    parser.add_argument(
        "--csv",
        default=str(CSV_PATH),
        help="Path to the Fashion-MNIST CSV source",
    )
    parser.add_argument(
        "--output-dir",
        default=str(DEFAULT_OUTPUT_DIR),
        help="Directory for generated .bin artifacts",
    )
    parser.add_argument(
        "--skip-build",
        action="store_true",
        help="Skip CMake configure/build and reuse the existing serial binary",
    )
    parser.add_argument(
        "--atol",
        type=float,
        default=1e-4,
        help="Absolute tolerance for output comparison",
    )
    parser.add_argument(
        "--rtol",
        type=float,
        default=1e-4,
        help="Relative tolerance for output comparison",
    )
    return parser


def run_command(cmd, cwd=None):
    # Print every external command so runs are easy to inspect and debug.
    print("+", " ".join(cmd))
    try:
        subprocess.run(cmd, cwd=str(cwd) if cwd is not None else None, check=True)
    except subprocess.CalledProcessError as exc:
        raise RuntimeError(
            "Command failed with exit code {}: {}".format(exc.returncode, " ".join(cmd))
        )


def load_dataset_pixels(csv_path):
    # The Fashion-MNIST CSV stores one label column plus 784 pixel columns.
    data = np.loadtxt(str(csv_path), delimiter=",", skiprows=1, dtype=np.uint8)
    if data.ndim != 2 or data.shape[1] != 785:
        raise ValueError(
            "Expected Fashion-MNIST CSV with 785 columns (label + 784 pixels), "
            "got shape {}".format(data.shape)
        )
    return data[:, 1:]


def stitch_images(data, width, height, seed, img_dim=IMAGE_EDGE_DIM):
    # Build a large test image by tiling random 28x28 Fashion-MNIST samples.
    grid_rows = int(math.ceil(float(height) / float(img_dim)))
    grid_cols = int(math.ceil(float(width) / float(img_dim)))
    n_images = grid_rows * grid_cols

    rng = np.random.RandomState(seed)
    indices = rng.randint(0, data.shape[0], size=n_images)
    subset = data[indices].reshape(n_images, img_dim, img_dim)
    grid = subset.reshape(grid_rows, grid_cols, img_dim, img_dim)
    stitched = grid.transpose(0, 2, 1, 3).reshape(
        grid_rows * img_dim, grid_cols * img_dim
    )
    return stitched[:height, :width].astype(np.uint8, copy=False)


def sobel_reference(image):
    # Match the current serial code: 3x3 Sobel, no padding, inner region only.
    image = np.asarray(image, dtype=np.float32)
    if image.ndim != 2:
        raise ValueError("Expected a 2D grayscale image, got shape {}".format(image.shape))

    height, width = image.shape
    magnitude = np.zeros((height - 2, width - 2), dtype=np.float32)
    direction = np.zeros((height - 2, width - 2), dtype=np.float32)

    for row in range(1, height - 1):
        for col in range(1, width - 1):
            patch = image[row - 1 : row + 2, col - 1 : col + 2]
            gx = np.sum(patch * GX)
            gy = np.sum(patch * GY)
            magnitude[row - 1, col - 1] = np.sqrt(gx * gx + gy * gy)
            direction[row - 1, col - 1] = np.arctan2(gy, gx)

    return magnitude, direction


def read_magdir(path, width, height):
    # Current output format is [magnitude][direction] as float32 values.
    expected_size = (width - 2) * (height - 2)
    expected_total = expected_size * 2
    raw = np.fromfile(str(path), dtype=np.float32)
    if raw.size != expected_total:
        raise ValueError(
            "Expected {} float32 values in {}, found {}".format(
                expected_total, path, raw.size
            )
        )
    return raw[:expected_size], raw[expected_size:]


def compare_arrays(expected, actual, label, atol, rtol):
    abs_diff = np.abs(expected - actual)
    max_abs_error = float(np.max(abs_diff))
    mean_abs_error = float(np.mean(abs_diff))
    passed = bool(np.allclose(actual, expected, atol=atol, rtol=rtol))

    print("{}:".format(label))
    print("  max abs error: {:.8f}".format(max_abs_error))
    print("  mean abs error: {:.8f}".format(mean_abs_error))
    print("  tolerance: atol={} rtol={}".format(atol, rtol))
    print("  status: {}".format("PASS" if passed else "FAIL"))
    return passed


def ensure_backend_binary(config, skip_build):
    binary_path = config["binary"]
    build_dir = config["build_dir"]
    source_dir = config["source_dir"]

    if skip_build:
        if not binary_path.exists():
            raise FileNotFoundError(
                "Binary not found at {}. Remove --skip-build or build it first.".format(
                    binary_path
                )
            )
        return

    # Configure and build the selected target if the caller did not opt out.
    build_dir.mkdir(parents=True, exist_ok=True)
    run_command(
        ["cmake", "-S", str(source_dir), "-B", str(build_dir)],
        cwd=REPO_ROOT,
    )
    run_command(["cmake", "--build", str(build_dir)], cwd=REPO_ROOT)


def main():
    try:
        args = build_parser().parse_args()

        if args.width < 3 or args.height < 3:
            raise ValueError("width and height must both be at least 3")

        config = BACKEND_CONFIG[args.backend]
        csv_path = Path(args.csv).resolve()
        output_dir = Path(args.output_dir).resolve()
        output_dir.mkdir(parents=True, exist_ok=True)

        stem = "{}_{}x{}".format(args.prefix, args.width, args.height)
        input_path = output_dir / (stem + ".img.bin")
        reference_path = output_dir / (stem + ".reference.magdir.bin")
        backend_output_path = output_dir / (
            stem + "." + config["output_suffix"] + ".magdir.bin"
        )

        # Generate both the binary test input and the Python reference output.
        pixels = load_dataset_pixels(csv_path)
        image = stitch_images(pixels, args.width, args.height, args.seed)
        magnitude, direction = sobel_reference(image)

        image.tofile(str(input_path))
        np.concatenate([magnitude.ravel(), direction.ravel()]).astype(np.float32).tofile(
            str(reference_path)
        )

        ensure_backend_binary(config, args.skip_build)
        # Run the selected C++/CUDA implementation with the same input image.
        run_command(
            [
                str(config["binary"]),
                str(input_path),
                str(backend_output_path),
                str(args.width),
                str(args.height),
            ],
            cwd=REPO_ROOT,
        )

        reference_mag, reference_dir = read_magdir(reference_path, args.width, args.height)
        backend_mag, backend_dir = read_magdir(
            backend_output_path, args.width, args.height
        )

        # Compare magnitude and direction separately to make failures easier to read.
        mag_ok = compare_arrays(reference_mag, backend_mag, "magnitude", args.atol, args.rtol)
        dir_ok = compare_arrays(reference_dir, backend_dir, "direction", args.atol, args.rtol)

        print("input image: {}".format(input_path))
        print("reference output: {}".format(reference_path))
        print("{} output: {}".format(args.backend, backend_output_path))

        return 0 if mag_ok and dir_ok else 1
    except Exception as exc:
        print("Error: {}".format(exc), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
