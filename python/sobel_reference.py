from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

from io_utils import read_u8_image, write_f32_image


# Standard Sobel kernel for the x direction.
GX = np.array(
    [
        [-1.0, 0.0, 1.0],
        [-2.0, 0.0, 2.0],
        [-1.0, 0.0, 1.0],
    ],
    dtype=np.float32,
)

# Standard Sobel kernel for the y direction.
GY = np.array(
    [
        [-1.0, -2.0, -1.0],
        [0.0, 0.0, 0.0],
        [1.0, 2.0, 1.0],
    ],
    dtype=np.float32,
)


def sobel_reference(image: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    # Convert the input to float so the convolution math is stable.
    image = np.asarray(image, dtype=np.float32)
    if image.ndim != 2:
        raise ValueError(f"Expected a 2D grayscale image, got shape {image.shape}")

    height, width = image.shape

    # Start with all zeros. Border pixels stay zero in this reference.
    magnitude = np.zeros((height-2, width-2), dtype=np.float32)
    direction = np.zeros((height-2, width-2), dtype=np.float32)

    # For each non-border pixel, apply the 3x3 Sobel kernels.
    for row in range(1, height - 1):
        for col in range(1, width - 1):
            patch = image[row - 1 : row + 2, col - 1 : col + 2]
            gx = np.sum(patch * GX)
            gy = np.sum(patch * GY)

            # Output gradient magnitude.
            magnitude[row-1, col-1] = np.sqrt(gx * gx + gy * gy)
            direction[row-1, col-1] = np.atan2(gy, gx)

    return magnitude, direction


def main() -> None:
    # Parse command line arguments.
    parser = argparse.ArgumentParser(
        description="Compute reference Sobel output for a grayscale uint8 .bin image."
    )
    parser.add_argument("--input", required=True, help="Path to input uint8 .bin file")
    parser.add_argument("--output", required=True, help="Path to output float32 .bin file")
    parser.add_argument("--width", type=int, default=28, help="Image width")
    parser.add_argument("--height", type=int, default=28, help="Image height")
    args = parser.parse_args()

    # Load the input image, run the reference Sobel, and save the result.
    image = read_u8_image(args.input, args.height, args.width)
    result, _ = sobel_reference(image)

    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    write_f32_image(output_path, result)

    # Print a short summary for the user.
    print(
        f"Wrote reference Sobel output to {output_path} "
        f"for image shape ({args.height}, {args.width})"
    )


if __name__ == "__main__":
    main()
