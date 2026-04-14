from __future__ import annotations

from pathlib import Path

import numpy as np


def read_u8_image(path: str | Path, height: int, width: int) -> np.ndarray:
    # Read a grayscale input image stored as raw uint8 bytes.
    path = Path(path)
    expected = height * width
    data = np.fromfile(path, dtype=np.uint8)

    # Check that the file size matches the expected image shape.
    if data.size != expected:
        raise ValueError(
            f"{path} has {data.size} uint8 values, expected {expected} "
            f"for shape ({height}, {width})"
        )

    # Return the image as a 2D NumPy array.
    return data.reshape((height, width))


def read_f32_image(path: str | Path, height: int, width: int) -> np.ndarray:
    # Read a program output image stored as raw float32 values.
    path = Path(path)
    expected = height * width
    data = np.fromfile(path, dtype=np.float32)

    # Check that the file size matches the expected image shape.
    if data.size != expected:
        raise ValueError(
            f"{path} has {data.size} float32 values, expected {expected} "
            f"for shape ({height}, {width})"
        )

    # Return the image as a 2D NumPy array.
    return data.reshape((height, width))


def write_u8_image(path: str | Path, image: np.ndarray) -> None:
    # Save an image as raw uint8 bytes.
    image = np.asarray(image, dtype=np.uint8)
    image.tofile(Path(path))


def write_f32_image(path: str | Path, image: np.ndarray) -> None:
    # Save an image as raw float32 values.
    image = np.asarray(image, dtype=np.float32)
    image.tofile(Path(path))
