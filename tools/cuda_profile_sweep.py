#!/usr/bin/env python3
"""Run CUDA Sobel block-configuration or multi-GPU timing sweeps."""

import argparse
import subprocess
import sys
from pathlib import Path

try:
    import numpy as np
except ImportError as exc:
    raise SystemExit("cuda_profile_sweep.py requires numpy") from exc


REPO_ROOT = Path(__file__).resolve().parents[1]
CUDA_SOURCE_DIR = REPO_ROOT / "cuda"
CUDA_BUILD_DIR = CUDA_SOURCE_DIR / "build"
CUDA_BINARY = CUDA_BUILD_DIR / "sobel_cuda"
DEFAULT_OUTPUT_DIR = REPO_ROOT / "data" / "cuda_benchmark"
DEFAULT_BLOCKS = ["8x8", "16x8", "16x16", "32x8", "32x16", "32x32"]
DEFAULT_VARIANTS = ["naive"]
ALLOWED_VARIANTS = {
    "naive",
    "atan_approx",
    "shared",
    "shared_atan_approx",
}


def build_parser():
    parser = argparse.ArgumentParser(
        description=(
            "Generate a raw grayscale input image, run the CUDA Sobel executable "
            "over several block shapes or GPU counts, and collect timing rows in one CSV."
        )
    )
    parser.add_argument("--width", type=int, default=4096, help="Input width in pixels")
    parser.add_argument("--height", type=int, default=4096, help="Input height in pixels")
    parser.add_argument(
        "--prefix",
        default="cuda_sobel",
        help="Prefix for generated input and output artifact names",
    )
    parser.add_argument(
        "--block",
        default="16x16",
        help="Fixed CUDA block shape for multi-GPU sweeps",
    )
    parser.add_argument(
        "--variants",
        nargs="+",
        default=DEFAULT_VARIANTS,
        help=(
            "CUDA kernel variants to run. Choices: naive, atan_approx, "
            "shared, shared_atan_approx"
        ),
    )
    parser.add_argument(
        "--blocks",
        nargs="+",
        default=DEFAULT_BLOCKS,
        help="CUDA block shapes in WxH format for single-GPU block sweeps",
    )
    parser.add_argument(
        "--gpus",
        nargs="+",
        type=int,
        default=None,
        help="GPU counts for strong scaling, for example --gpus 1 2 4",
    )
    parser.add_argument(
        "--repeats",
        type=int,
        default=5,
        help="Measured runs per block configuration",
    )
    parser.add_argument(
        "--warmup",
        type=int,
        default=1,
        help="Warm-up runs before measuring each configuration",
    )
    parser.add_argument(
        "--output-dir",
        default=str(DEFAULT_OUTPUT_DIR),
        help="Directory for generated inputs and timing CSVs",
    )
    parser.add_argument(
        "--csv",
        default=None,
        help="Output CSV path; defaults inside --output-dir",
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=0,
        help="Random seed for generated input pixels",
    )
    parser.add_argument(
        "--chunk-mb",
        type=int,
        default=64,
        help="Input generation chunk size in MiB",
    )
    parser.add_argument(
        "--append",
        action="store_true",
        help="Append to an existing CSV instead of replacing it",
    )
    parser.add_argument(
        "--force-input",
        action="store_true",
        help="Regenerate the input file even if it already has the expected size",
    )
    parser.add_argument(
        "--skip-build",
        action="store_true",
        help="Reuse the existing CUDA binary",
    )
    parser.add_argument(
        "--kernel-only",
        action="store_true",
        help="Skip device-to-host copies for pure kernel timing",
    )
    return parser


def run_command(cmd, cwd=REPO_ROOT):
    print("+", " ".join(str(part) for part in cmd), flush=True)
    subprocess.run([str(part) for part in cmd], cwd=str(cwd), check=True)


def validate_block(block):
    parts = block.lower().split("x")
    if len(parts) != 2:
        raise ValueError("block shape must use WxH format: {}".format(block))
    block_x = int(parts[0])
    block_y = int(parts[1])
    if block_x <= 0 or block_y <= 0:
        raise ValueError("block dimensions must be positive: {}".format(block))
    if block_x * block_y > 1024:
        raise ValueError("CUDA blocks cannot exceed 1024 threads: {}".format(block))
    return "{}x{}".format(block_x, block_y)


def validate_gpu_count(gpu_count):
    if gpu_count <= 0:
        raise ValueError("GPU counts must be positive: {}".format(gpu_count))
    return gpu_count


def validate_variant(variant):
    if variant not in ALLOWED_VARIANTS:
        raise ValueError(
            "Unknown CUDA variant '{}'; choose from {}".format(
                variant, ", ".join(sorted(ALLOWED_VARIANTS))
            )
        )
    return variant


def ensure_cuda_binary(skip_build):
    if skip_build:
        if not CUDA_BINARY.exists():
            raise FileNotFoundError(
                "CUDA binary not found at {}; rerun without --skip-build".format(
                    CUDA_BINARY
                )
            )
        return

    CUDA_BUILD_DIR.mkdir(parents=True, exist_ok=True)
    run_command(["cmake", "-S", CUDA_SOURCE_DIR, "-B", CUDA_BUILD_DIR])
    run_command(["cmake", "--build", CUDA_BUILD_DIR])


def generate_input(path, width, height, seed, chunk_mb, force):
    expected_bytes = width * height
    if path.exists() and path.stat().st_size == expected_bytes and not force:
        print("Reusing existing input: {}".format(path))
        return

    path.parent.mkdir(parents=True, exist_ok=True)
    rng = np.random.default_rng(seed)
    chunk_bytes = max(1, chunk_mb) * 1024 * 1024
    remaining = expected_bytes

    print("Generating {} bytes of uint8 input at {}".format(expected_bytes, path))
    with path.open("wb") as handle:
        while remaining > 0:
            n_values = min(chunk_bytes, remaining)
            pixels = rng.integers(0, 256, size=n_values, dtype=np.uint8)
            pixels.tofile(handle)
            remaining -= n_values


def main():
    try:
        args = build_parser().parse_args()
        if args.width < 3 or args.height < 3:
            raise ValueError("width and height must both be at least 3")
        if args.repeats <= 0:
            raise ValueError("--repeats must be positive")
        if args.warmup < 0:
            raise ValueError("--warmup must be nonnegative")

        blocks = [validate_block(block) for block in args.blocks]
        fixed_block = validate_block(args.block)
        variants = [validate_variant(variant) for variant in args.variants]
        gpu_counts = None
        if args.gpus is not None:
            gpu_counts = [validate_gpu_count(gpu_count) for gpu_count in args.gpus]
        output_dir = Path(args.output_dir).resolve()
        stem = "{}_{}x{}".format(args.prefix, args.width, args.height)
        input_dir = output_dir / "inputs"
        input_path = input_dir / (stem + ".img.bin")
        if gpu_counts is not None:
            sweep_dir = "variant_strong_scaling" if len(variants) > 1 else "strong_scaling"
            experiment_dir = output_dir / "multi_gpu" / sweep_dir / "{}x{}".format(
                args.width, args.height
            )
        else:
            sweep_dir = (
                "variant_block_shape_sweep" if len(variants) > 1 else "block_shape_sweep"
            )
            experiment_dir = output_dir / "single_gpu" / sweep_dir / "{}x{}".format(
                args.width, args.height
            )
        experiment_dir.mkdir(parents=True, exist_ok=True)
        if args.csv:
            csv_path = Path(args.csv).resolve()
        elif gpu_counts is not None:
            csv_path = experiment_dir / "timings.csv"
        else:
            csv_path = experiment_dir / "timings.csv"

        if csv_path.exists() and not args.append:
            csv_path.unlink()

        ensure_cuda_binary(args.skip_build)
        generate_input(
            input_path,
            args.width,
            args.height,
            args.seed,
            args.chunk_mb,
            args.force_input,
        )

        if gpu_counts is not None:
            for variant in variants:
                for gpu_count in gpu_counts:
                    output_path = experiment_dir / (
                        "{}.{}gpu.{}.magdir.bin".format(variant, gpu_count, fixed_block)
                    )
                    cmd = [
                        CUDA_BINARY,
                        "--variant",
                        variant,
                        "--num-gpus",
                        gpu_count,
                        "--block",
                        fixed_block,
                        "--warmup",
                        args.warmup,
                        "--repeats",
                        args.repeats,
                        "--csv",
                        csv_path,
                        "--csv-append",
                        "--no-output-write",
                    ]
                    if args.kernel_only:
                        cmd.append("--skip-d2h")
                    cmd.extend([input_path, output_path, args.width, args.height])
                    run_command(cmd)
        else:
            for variant in variants:
                for block in blocks:
                    output_path = experiment_dir / ("{}.{}.magdir.bin".format(variant, block))
                    cmd = [
                        CUDA_BINARY,
                        "--variant",
                        variant,
                        "--block",
                        block,
                        "--warmup",
                        args.warmup,
                        "--repeats",
                        args.repeats,
                        "--csv",
                        csv_path,
                        "--csv-append",
                        "--no-output-write",
                    ]
                    if args.kernel_only:
                        cmd.append("--skip-d2h")
                    cmd.extend([input_path, output_path, args.width, args.height])
                    run_command(cmd)

        print("Wrote CUDA timing CSV: {}".format(csv_path))
        return 0
    except Exception as exc:
        print("Error: {}".format(exc), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
