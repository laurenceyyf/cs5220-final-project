#!/usr/bin/env python3
"""Plot CUDA Sobel benchmark CSVs produced by cuda_profile_sweep.py."""

import argparse
import csv
import html
import sys
from collections import defaultdict
from pathlib import Path

try:
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
except ImportError:
    plt = None


TIMING_FIELDS = [
    "allocation_ms",
    "h2d_ms",
    "kernel_ms",
    "d2h_ms",
    "free_ms",
    "cuda_section_ms",
]

VARIANT_ORDER = [
    "naive",
    "atan_approx",
    "shared",
    "shared_atan_approx",
]


def build_parser():
    parser = argparse.ArgumentParser(
        description="Generate CUDA scaling and time-breakdown plots from a timing CSV."
    )
    parser.add_argument("csv_path", help="CSV produced by cuda_profile_sweep.py")
    parser.add_argument(
        "--variant",
        default=None,
        help="Plot one CUDA variant only; defaults to all variants present in the CSV",
    )
    parser.add_argument(
        "--out-dir",
        default=None,
        help="Output directory for PNG plots; defaults next to the CSV",
    )
    parser.add_argument(
        "--prefix",
        default=None,
        help="Output filename prefix; defaults to the CSV stem",
    )
    parser.add_argument(
        "--format",
        choices=["auto", "png", "svg"],
        default="auto",
        help="Plot format. auto uses PNG when matplotlib is installed, otherwise SVG.",
    )
    return parser


def read_rows(path):
    with path.open(newline="") as handle:
        reader = csv.DictReader(handle)
        rows = list(reader)
    if not rows:
        raise ValueError("CSV has no data rows: {}".format(path))
    return rows


def row_variant(row):
    return row.get("variant", "naive")


def variant_sort_key(variant):
    try:
        return (0, VARIANT_ORDER.index(variant))
    except ValueError:
        return (1, variant)


def split_rows_by_variant(rows):
    groups = defaultdict(list)
    for row in rows:
        groups[row_variant(row)].append(row)
    return {
        variant: groups[variant]
        for variant in sorted(groups, key=variant_sort_key)
    }


def summarize(rows):
    has_num_gpus = "num_gpus" in rows[0]
    distinct_gpus = set()
    if has_num_gpus:
        distinct_gpus = set(int(row["num_gpus"]) for row in rows)
    multi_gpu_mode = len(distinct_gpus) > 1

    groups = defaultdict(list)
    for row in rows:
        if multi_gpu_mode:
            key = (int(row["num_gpus"]), int(row["block_x"]), int(row["block_y"]))
        else:
            key = (int(row["block_x"]), int(row["block_y"]))
        groups[key].append(row)

    summaries = []
    for key, group_rows in groups.items():
        if multi_gpu_mode:
            num_gpus, block_x, block_y = key
            label = "{} GPU{}".format(num_gpus, "" if num_gpus == 1 else "s")
        else:
            block_x, block_y = key
            num_gpus = int(group_rows[0].get("num_gpus", 1))
            label = "{}x{}".format(block_x, block_y)
        entry = {
            "variant": row_variant(group_rows[0]),
            "num_gpus": num_gpus,
            "block_x": block_x,
            "block_y": block_y,
            "threads": block_x * block_y,
            "label": label,
            "runs": len(group_rows),
        }
        for field in TIMING_FIELDS:
            values = [float(row[field]) for row in group_rows]
            entry[field] = sum(values) / float(len(values))
        summaries.append(entry)

    if multi_gpu_mode:
        summaries.sort(key=lambda item: (item["num_gpus"], item["threads"]))
    else:
        summaries.sort(key=lambda item: (item["threads"], item["block_x"], item["block_y"]))
    return summaries


def is_multi_gpu_summary(summaries):
    return len(set(item.get("num_gpus", 1) for item in summaries)) > 1


def set_log2_xaxis(ax, values):
    try:
        ax.set_xscale("log", base=2)
    except TypeError:
        ax.set_xscale("log", basex=2)
    ax.set_xticks(values)
    ax.set_xticklabels([str(value) for value in values])


def plot_scaling(summaries, out_path):
    multi_gpu = is_multi_gpu_summary(summaries)
    if multi_gpu:
        x_positions = [item["num_gpus"] for item in summaries]
    else:
        labels = [item["label"] for item in summaries]
        x_positions = list(range(len(labels)))
    kernel_ms = [item["kernel_ms"] for item in summaries]
    cuda_ms = [item["cuda_section_ms"] for item in summaries]

    fig, ax = plt.subplots(figsize=(8.5, 4.8))
    ax.plot(x_positions, kernel_ms, marker="o", linewidth=2.0, label="kernel")
    ax.plot(x_positions, cuda_ms, marker="s", linewidth=2.0, label="CUDA total")

    if multi_gpu:
        baseline_gpus = x_positions[0]
        baseline_kernel = kernel_ms[0]
        ideal_kernel = [baseline_kernel * baseline_gpus / float(gpus) for gpus in x_positions]
        ax.plot(
            x_positions,
            ideal_kernel,
            linestyle="--",
            color="#555555",
            linewidth=1.8,
            label="ideal kernel scaling",
        )
        set_log2_xaxis(ax, x_positions)
        ax.set_xlabel("Number of GPUs (log2 scale)")
        ax.set_title("CUDA Sobel Multi-GPU Strong Scaling")
    else:
        ax.set_xticks(x_positions)
        ax.set_xticklabels(labels)
        ax.set_xlabel("CUDA block shape")
        ax.set_title("CUDA Sobel Block-Configuration Scaling")
    ax.set_ylabel("Average time (ms)")
    ax.grid(axis="y", alpha=0.3)
    ax.legend(frameon=False)
    fig.tight_layout()
    fig.savefig(out_path, dpi=220)
    plt.close(fig)


def plot_breakdown(summaries, out_path):
    labels = [item["label"] for item in summaries]
    x_positions = list(range(len(labels)))
    h2d = [item["h2d_ms"] for item in summaries]
    kernel = [item["kernel_ms"] for item in summaries]
    d2h = [item["d2h_ms"] for item in summaries]

    fig, ax = plt.subplots(figsize=(8.5, 4.8))
    ax.bar(x_positions, h2d, label="H2D copy")
    bottoms = h2d[:]
    ax.bar(x_positions, kernel, bottom=bottoms, label="kernel")
    bottoms = [a + b for a, b in zip(bottoms, kernel)]
    ax.bar(x_positions, d2h, bottom=bottoms, label="D2H copy")

    ax.set_xticks(x_positions)
    ax.set_xticklabels(labels)
    if is_multi_gpu_summary(summaries):
        ax.set_xlabel("Number of GPUs")
        ax.set_title("CUDA Sobel Multi-GPU Time Breakdown")
    else:
        ax.set_xlabel("CUDA block shape")
        ax.set_title("CUDA Sobel Time Breakdown")
    ax.set_ylabel("Average time (ms)")
    ax.grid(axis="y", alpha=0.3)
    ax.legend(frameon=False)
    fig.tight_layout()
    fig.savefig(out_path, dpi=220)
    plt.close(fig)


def plot_speedup(summaries, out_path):
    if not is_multi_gpu_summary(summaries):
        return False

    x_values = [item["num_gpus"] for item in summaries]
    baseline_gpus = x_values[0]
    baseline_kernel = summaries[0]["kernel_ms"]
    speedup = [baseline_kernel / item["kernel_ms"] for item in summaries]
    ideal = [gpus / float(baseline_gpus) for gpus in x_values]

    fig, ax = plt.subplots(figsize=(8.5, 4.8))
    ax.plot(x_values, speedup, marker="o", linewidth=2.0, label="measured")
    ax.plot(x_values, ideal, linestyle="--", color="#555555", linewidth=1.8, label="ideal")
    set_log2_xaxis(ax, x_values)
    ax.set_xlabel("Number of GPUs (log2 scale)")
    ax.set_ylabel("Speedup over {} GPU{}".format(baseline_gpus, "" if baseline_gpus == 1 else "s"))
    ax.set_title("CUDA Sobel Multi-GPU Speedup")
    ax.grid(axis="y", alpha=0.3)
    ax.legend(frameon=False)
    fig.tight_layout()
    fig.savefig(out_path, dpi=220)
    plt.close(fig)
    return True


def plot_variant_comparison(variant_summaries, out_path):
    labels = [item["label"] for item in next(iter(variant_summaries.values()))]
    x_positions = list(range(len(labels)))

    fig, ax = plt.subplots(figsize=(8.8, 5.0))
    for variant, summaries in variant_summaries.items():
        by_label = {item["label"]: item["kernel_ms"] for item in summaries}
        kernel_ms = [by_label[label] for label in labels]
        ax.plot(
            x_positions,
            kernel_ms,
            marker="o",
            linewidth=2.0,
            label=variant,
        )

    ax.set_xticks(x_positions)
    ax.set_xticklabels(labels)
    ax.set_xlabel("CUDA block shape")
    ax.set_ylabel("Average kernel time (ms)")
    ax.set_title("CUDA Sobel Variant Comparison")
    ax.grid(axis="y", alpha=0.3)
    ax.legend(frameon=False)
    fig.tight_layout()
    fig.savefig(out_path, dpi=220)
    plt.close(fig)


def nice_max(values):
    max_value = max(values) if values else 1.0
    if max_value <= 0.0:
        return 1.0
    return max_value * 1.12


def svg_text(x, y, text, size=12, anchor="middle", weight="normal", rotate=None):
    transform = ""
    if rotate is not None:
        transform = ' transform="rotate({} {} {})"'.format(rotate, x, y)
    return (
        '<text x="{:.2f}" y="{:.2f}" font-size="{}" font-family="Arial, sans-serif" '
        'font-weight="{}" text-anchor="{}"{}>{}</text>'
    ).format(x, y, size, weight, anchor, transform, html.escape(str(text)))


def write_svg(out_path, width, height, elements):
    with out_path.open("w") as handle:
        handle.write(
            '<svg xmlns="http://www.w3.org/2000/svg" width="{}" height="{}" '
            'viewBox="0 0 {} {}">\n'.format(width, height, width, height)
        )
        handle.write('<rect width="100%" height="100%" fill="white"/>\n')
        for element in elements:
            handle.write(element)
            handle.write("\n")
        handle.write("</svg>\n")


def plot_scaling_svg(summaries, out_path):
    width = 920
    height = 540
    left = 82
    right = 28
    top = 58
    bottom = 96
    plot_width = width - left - right
    plot_height = height - top - bottom

    labels = [item["label"] for item in summaries]
    kernel_ms = [item["kernel_ms"] for item in summaries]
    cuda_ms = [item["cuda_section_ms"] for item in summaries]
    y_max = nice_max(kernel_ms + cuda_ms)
    count = max(1, len(labels))
    step = plot_width / float(max(1, count - 1))

    def x_at(index):
        return left + step * index if count > 1 else left + plot_width / 2.0

    def y_at(value):
        return top + plot_height - (float(value) / y_max) * plot_height

    elements = [
        svg_text(width / 2, 30, "CUDA Sobel Block-Configuration Scaling", 18, weight="bold"),
        '<line x1="{0}" y1="{1}" x2="{0}" y2="{2}" stroke="#333"/>'.format(
            left, top, top + plot_height
        ),
        '<line x1="{0}" y1="{2}" x2="{1}" y2="{2}" stroke="#333"/>'.format(
            left, left + plot_width, top + plot_height
        ),
        svg_text(24, top + plot_height / 2, "Average time (ms)", 13, rotate=-90),
        svg_text(left + plot_width / 2, height - 18, "CUDA block shape", 13),
    ]

    for tick in range(5):
        value = y_max * tick / 4.0
        y = y_at(value)
        elements.append(
            '<line x1="{0}" y1="{1:.2f}" x2="{2}" y2="{1:.2f}" stroke="#ddd"/>'.format(
                left, y, left + plot_width
            )
        )
        elements.append(svg_text(left - 10, y + 4, "{:.3g}".format(value), 11, anchor="end"))

    for index, label in enumerate(labels):
        x = x_at(index)
        elements.append(svg_text(x, top + plot_height + 24, label, 11))

    def line_path(values):
        parts = []
        for index, value in enumerate(values):
            command = "M" if index == 0 else "L"
            parts.append("{} {:.2f} {:.2f}".format(command, x_at(index), y_at(value)))
        return " ".join(parts)

    elements.append(
        '<path d="{}" fill="none" stroke="#2563eb" stroke-width="3"/>'.format(
            line_path(kernel_ms)
        )
    )
    elements.append(
        '<path d="{}" fill="none" stroke="#f97316" stroke-width="3"/>'.format(
            line_path(cuda_ms)
        )
    )
    for index, value in enumerate(kernel_ms):
        elements.append(
            '<circle cx="{:.2f}" cy="{:.2f}" r="4" fill="#2563eb"/>'.format(
                x_at(index), y_at(value)
            )
        )
    for index, value in enumerate(cuda_ms):
        elements.append(
            '<rect x="{:.2f}" y="{:.2f}" width="8" height="8" fill="#f97316"/>'.format(
                x_at(index) - 4, y_at(value) - 4
            )
        )

    legend_x = left + plot_width - 156
    elements.extend(
        [
            '<circle cx="{:.2f}" cy="62" r="4" fill="#2563eb"/>'.format(legend_x),
            svg_text(legend_x + 12, 66, "kernel", 12, anchor="start"),
            '<rect x="{:.2f}" y="58" width="8" height="8" fill="#f97316"/>'.format(
                legend_x + 80
            ),
            svg_text(legend_x + 94, 66, "CUDA total", 12, anchor="start"),
        ]
    )
    write_svg(out_path, width, height, elements)


def plot_breakdown_svg(summaries, out_path):
    width = 920
    height = 540
    left = 82
    right = 28
    top = 58
    bottom = 96
    plot_width = width - left - right
    plot_height = height - top - bottom

    labels = [item["label"] for item in summaries]
    h2d = [item["h2d_ms"] for item in summaries]
    kernel = [item["kernel_ms"] for item in summaries]
    d2h = [item["d2h_ms"] for item in summaries]
    totals = [a + b + c for a, b, c in zip(h2d, kernel, d2h)]
    y_max = nice_max(totals)
    count = max(1, len(labels))
    slot = plot_width / float(count)
    bar_width = min(58.0, slot * 0.62)

    def y_at(value):
        return top + plot_height - (float(value) / y_max) * plot_height

    elements = [
        svg_text(width / 2, 30, "CUDA Sobel Time Breakdown", 18, weight="bold"),
        '<line x1="{0}" y1="{1}" x2="{0}" y2="{2}" stroke="#333"/>'.format(
            left, top, top + plot_height
        ),
        '<line x1="{0}" y1="{2}" x2="{1}" y2="{2}" stroke="#333"/>'.format(
            left, left + plot_width, top + plot_height
        ),
        svg_text(24, top + plot_height / 2, "Average time (ms)", 13, rotate=-90),
        svg_text(left + plot_width / 2, height - 18, "CUDA block shape", 13),
    ]

    for tick in range(5):
        value = y_max * tick / 4.0
        y = y_at(value)
        elements.append(
            '<line x1="{0}" y1="{1:.2f}" x2="{2}" y2="{1:.2f}" stroke="#ddd"/>'.format(
                left, y, left + plot_width
            )
        )
        elements.append(svg_text(left - 10, y + 4, "{:.3g}".format(value), 11, anchor="end"))

    colors = [("#10b981", "H2D copy"), ("#2563eb", "kernel"), ("#f97316", "D2H copy")]
    for index, label in enumerate(labels):
        center = left + slot * (index + 0.5)
        x = center - bar_width / 2.0
        base = 0.0
        for value, (color, unused_label) in zip(
            [h2d[index], kernel[index], d2h[index]], colors
        ):
            y_top = y_at(base + value)
            y_bottom = y_at(base)
            elements.append(
                '<rect x="{:.2f}" y="{:.2f}" width="{:.2f}" height="{:.2f}" fill="{}"/>'.format(
                    x, y_top, bar_width, max(0.0, y_bottom - y_top), color
                )
            )
            base += value
        elements.append(svg_text(center, top + plot_height + 24, label, 11))

    legend_x = left + plot_width - 245
    for i, (color, label) in enumerate(colors):
        x = legend_x + i * 88
        elements.append('<rect x="{:.2f}" y="58" width="10" height="10" fill="{}"/>'.format(x, color))
        elements.append(svg_text(x + 15, 68, label, 12, anchor="start"))

    write_svg(out_path, width, height, elements)


def main():
    try:
        args = build_parser().parse_args()
        csv_path = Path(args.csv_path).resolve()
        out_dir = Path(args.out_dir).resolve() if args.out_dir else csv_path.parent
        out_dir.mkdir(parents=True, exist_ok=True)
        prefix = args.prefix if args.prefix else csv_path.stem
        plot_format = args.format
        if plot_format == "auto":
            plot_format = "png" if plt is not None else "svg"
        if plot_format == "png" and plt is None:
            print("matplotlib is unavailable; writing SVG plots instead")
            plot_format = "svg"

        rows = read_rows(csv_path)
        rows_by_variant = split_rows_by_variant(rows)

        if args.variant is not None:
            if args.variant not in rows_by_variant:
                raise ValueError(
                    "Variant '{}' is not present in {}".format(args.variant, csv_path)
                )
            rows_by_variant = {args.variant: rows_by_variant[args.variant]}

        variant_summaries = {}
        for variant, variant_rows in rows_by_variant.items():
            summaries = summarize(variant_rows)
            variant_summaries[variant] = summaries
            variant_prefix = prefix if len(rows_by_variant) == 1 else prefix + "." + variant
            scaling_path = out_dir / (variant_prefix + ".cuda_scaling." + plot_format)
            breakdown_path = out_dir / (variant_prefix + ".cuda_breakdown." + plot_format)
            speedup_path = out_dir / (variant_prefix + ".cuda_speedup." + plot_format)

            if plot_format == "png":
                plot_scaling(summaries, scaling_path)
                plot_breakdown(summaries, breakdown_path)
                wrote_speedup = plot_speedup(summaries, speedup_path)
            else:
                plot_scaling_svg(summaries, scaling_path)
                plot_breakdown_svg(summaries, breakdown_path)
                wrote_speedup = False

            print("Wrote {}".format(scaling_path))
            print("Wrote {}".format(breakdown_path))
            if wrote_speedup:
                print("Wrote {}".format(speedup_path))

        if (
            plot_format == "png"
            and len(variant_summaries) > 1
            and not any(is_multi_gpu_summary(summaries) for summaries in variant_summaries.values())
        ):
            comparison_path = out_dir / (prefix + ".cuda_variant_comparison." + plot_format)
            plot_variant_comparison(variant_summaries, comparison_path)
            print("Wrote {}".format(comparison_path))
        return 0
    except Exception as exc:
        print("Error: {}".format(exc), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
