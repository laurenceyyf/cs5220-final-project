from __future__ import annotations

import argparse
import csv
import struct
from pathlib import Path

import numpy as np

from io_utils import write_u8_image


# IDX magic number for image files.
IMAGE_MAGIC = 2051

# IDX magic number for label files.
LABEL_MAGIC = 2049


def read_idx_images(path: str | Path) -> np.ndarray:
    # Read the raw IDX image file from disk.
    path = Path(path)
    with path.open("rb") as f:
        # The image header stores:
        # magic number, number of images, rows, cols.
        header = f.read(16)
        if len(header) != 16:
            raise ValueError(f"{path} is too short to be a valid IDX image file")
        magic, count, rows, cols = struct.unpack(">IIII", header)
        if magic != IMAGE_MAGIC:
            raise ValueError(
                f"{path} has image magic {magic}, expected {IMAGE_MAGIC}"
            )

        # Read the remaining bytes as uint8 pixel values.
        data = np.frombuffer(f.read(), dtype=np.uint8)

    # Make sure the file has exactly count * rows * cols pixels.
    expected = count * rows * cols
    if data.size != expected:
        raise ValueError(
            f"{path} has {data.size} pixels, expected {expected} "
            f"for {count} images of shape ({rows}, {cols})"
        )

    # Reshape into (num_images, height, width).
    return data.reshape((count, rows, cols))


def read_idx_labels(path: str | Path) -> np.ndarray:
    # Read the raw IDX label file from disk.
    path = Path(path)
    with path.open("rb") as f:
        # The label header stores:
        # magic number, number of labels.
        header = f.read(8)
        if len(header) != 8:
            raise ValueError(f"{path} is too short to be a valid IDX label file")
        magic, count = struct.unpack(">II", header)
        if magic != LABEL_MAGIC:
            raise ValueError(
                f"{path} has label magic {magic}, expected {LABEL_MAGIC}"
            )

        # Read the remaining bytes as uint8 labels.
        data = np.frombuffer(f.read(), dtype=np.uint8)

    # Make sure the number of labels matches the header.
    if data.size != count:
        raise ValueError(f"{path} has {data.size} labels, expected {count}")

    return data


def export_subset(
    images: np.ndarray,
    labels: np.ndarray,
    output_dir: Path,
    counts: list[int],
    prefix: str,
) -> None:
    # Create the output directory if it does not exist.
    output_dir.mkdir(parents=True, exist_ok=True)
    manifest_path = output_dir / "manifest.csv"

    # We export images up to the largest requested subset size.
    max_count = max(counts)
    if max_count > images.shape[0]:
        raise ValueError(
            f"Requested {max_count} images, but dataset only has {images.shape[0]}"
        )

    # Write one manifest that lists every exported file.
    with manifest_path.open("w", newline="") as manifest_file:
        writer = csv.writer(manifest_file)
        writer.writerow(["subset", "source_index", "label", "file"])

        for idx in range(max_count):
            # Get one image and its class label.
            image = images[idx]
            label = int(labels[idx])

            # Example name: image_00000_label_9.bin
            file_name = f"{prefix}_{idx:05d}_label_{label}.bin"
            file_path = output_dir / file_name

            # Save the image as raw uint8 binary data.
            write_u8_image(file_path, image)

            # Record metadata in the manifest.
            writer.writerow([prefix, idx, label, file_name])

    # Also write a small text file for each requested subset size.
    # This is useful later for running benchmarks on 1, 10, 100, 1000 images.
    for count in counts:
        subset_manifest_path = output_dir / f"subset_{count}.txt"
        with subset_manifest_path.open("w") as subset_file:
            for idx in range(count):
                label = int(labels[idx])
                file_name = f"{prefix}_{idx:05d}_label_{label}.bin"
                subset_file.write(f"{file_name}\n")


def build_parser() -> argparse.ArgumentParser:
    # Define command line arguments for the exporter script.
    parser = argparse.ArgumentParser(
        description="Export Fashion-MNIST IDX data to grayscale uint8 .bin files."
    )
    parser.add_argument("--images", required=True, help="Path to IDX image file")
    parser.add_argument("--labels", required=True, help="Path to IDX label file")
    parser.add_argument(
        "--output-dir",
        required=True,
        help="Directory for exported .bin files and manifest.csv",
    )
    parser.add_argument(
        "--counts",
        type=int,
        nargs="+",
        default=[1, 10, 100, 1000],
        help="Export the first N images for each requested count",
    )
    parser.add_argument(
        "--prefix",
        default="image",
        help="File name prefix for exported images",
    )
    return parser


def main() -> None:
    # Read command line arguments.
    args = build_parser().parse_args()

    # Sort and deduplicate the requested subset sizes.
    counts = sorted(set(args.counts))

    # Basic input validation.
    if any(count <= 0 for count in counts):
        raise ValueError("--counts must all be positive")

    # Load image and label arrays from the Fashion-MNIST IDX files.
    images = read_idx_images(args.images)
    labels = read_idx_labels(args.labels)

    # Each image should have one matching label.
    if images.shape[0] != labels.shape[0]:
        raise ValueError(
            f"Image count {images.shape[0]} does not match label count {labels.shape[0]}"
        )

    # Export the requested subset to our project format.
    output_dir = Path(args.output_dir)
    export_subset(images, labels, output_dir, counts, args.prefix)

    # Print a short summary for the user.
    print(
        f"Exported {max(counts)} Fashion-MNIST images to {output_dir} "
        f"with shape {images.shape[1:]}"
    )
    print(f"Requested checkpoints: {counts}")


if __name__ == "__main__":
    main()
