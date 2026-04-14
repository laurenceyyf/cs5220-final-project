from __future__ import annotations

import argparse
import sys

import numpy as np

from io_utils import read_f32_image, read_u8_image
from sobel_reference import sobel_reference


def build_parser() -> argparse.ArgumentParser:
    # Define command line arguments for the checker.
    parser = argparse.ArgumentParser(
        description="Compare a program output against the NumPy Sobel reference."
    )
    parser.add_argument("--input", required=True, help="Path to input uint8 .bin file")
    parser.add_argument("--output", required=True, help="Path to program output float32 .bin")
    parser.add_argument("--width", type=int, default=28, help="Image width")
    parser.add_argument("--height", type=int, default=28, help="Image height")
    parser.add_argument("--atol", type=float, default=1e-4, help="Absolute tolerance")
    parser.add_argument("--rtol", type=float, default=1e-4, help="Relative tolerance")
    parser.add_argument(
        "--report-limit",
        type=int,
        default=10,
        help="Maximum number of mismatched pixels to print",
    )
    return parser


def main() -> int:
    # Read command line arguments.
    args = build_parser().parse_args()

    # Load the original input image.
    image = read_u8_image(args.input, args.height, args.width)

    # Compute the expected Sobel result with the Python reference.
    expected = sobel_reference(image)

    # Load the output produced by the serial / MPI / CUDA program.
    actual = read_f32_image(args.output, args.height, args.width)

    # Compute error statistics.
    abs_diff = np.abs(expected - actual)
    max_abs_error = float(np.max(abs_diff))
    mean_abs_error = float(np.mean(abs_diff))

    # Decide whether the two outputs match within tolerance.
    passed = np.allclose(actual, expected, atol=args.atol, rtol=args.rtol)

    print(f"input shape: ({args.height}, {args.width})")
    print(f"max abs error: {max_abs_error:.8f}")
    print(f"mean abs error: {mean_abs_error:.8f}")
    print(f"tolerance: atol={args.atol} rtol={args.rtol}")

    if passed:
        print("CHECK PASSED")
        return 0

    # Find every pixel that does not match closely enough.
    mismatch_mask = ~np.isclose(actual, expected, atol=args.atol, rtol=args.rtol)
    mismatch_indices = np.argwhere(mismatch_mask)
    print(f"CHECK FAILED: {mismatch_indices.shape[0]} mismatched pixels")

    # Print a small sample of mismatches to help debugging.
    for row, col in mismatch_indices[: args.report_limit]:
        print(
            f"  ({row}, {col}) expected={expected[row, col]:.8f} "
            f"actual={actual[row, col]:.8f} abs_diff={abs_diff[row, col]:.8f}"
        )

    if mismatch_indices.shape[0] > args.report_limit:
        remaining = mismatch_indices.shape[0] - args.report_limit
        print(f"  ... {remaining} more mismatches not shown")

    return 1


if __name__ == "__main__":
    sys.exit(main())
