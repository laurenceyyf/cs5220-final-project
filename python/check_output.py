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
    parser.add_argument("to_check", help="Path to outputted .magdir.bin")
    parser.add_argument("reference", help="Path to precaled .magdir.bin")
    parser.add_argument("width", type=int, default=28, help="pixel widths")
    parser.add_argument("height", type=int, default=28, help="pixel height")
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
    all_tocheck= np.fromfile(args.to_check, dtype=np.float32)
    all_reference= np.fromfile(args.reference, dtype=np.float32)

    size = (args.width - 2) * (args.height-2)

    to_check_mag = all_tocheck[:size]
    to_check_dir = all_tocheck[size:]
    reference_mag = all_reference[:size]
    reference_dir = all_reference[size:]
    # Load the output produced by the serial / MPI / CUDA program.

    # Compute error statistics.
    def compare(expected, actual, message) -> bool:
        abs_diff = np.abs(expected - actual)
        max_abs_error = float(np.max(abs_diff))
        mean_abs_error = float(np.mean(abs_diff))

        # Decide whether the two outputs match within tolerance.
        passed = np.allclose(actual, expected, atol=args.atol, rtol=args.rtol)

        print(message)
        print(f"\tinput shape: ({args.height}, {args.width})")
        print(f"\tmax abs error: {max_abs_error:.8f}")
        print(f"\tmean abs error: {mean_abs_error:.8f}")
        print(f"\ttolerance: atol={args.atol} rtol={args.rtol}")

        if passed:
            print("CHECK PASSED")
            return True

        # Find every pixel that does not match closely enough.
        mismatch_mask = ~np.isclose(actual, expected, atol=args.atol, rtol=args.rtol)
        mismatch_indices = np.argwhere(mismatch_mask)
        print(f"CHECK FAILED: {mismatch_indices.shape[0]} mismatched pixels")

        
        if mismatch_indices.shape[0] > args.report_limit:
            remaining = mismatch_indices.shape[0] - args.report_limit
            print(f"  ... {remaining} more mismatches not shown")

        return False
    compare(reference_dir, to_check_dir, "dir")
    compare(reference_mag, to_check_mag, "mag")
    return 0

if __name__ == "__main__":
    sys.exit(main())
