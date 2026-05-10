#!/usr/bin/env python3
"""Generate a roofline plot from CUDA Sobel timing CSVs."""

import argparse
import csv
import html
import math
import sys
from collections import defaultdict
from pathlib import Path

try:
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    from matplotlib.lines import Line2D
except ImportError:
    plt = None


VARIANT_ORDER = [
    "naive",
    "atan_approx",
    "shared",
    "shared_atan_approx",
]

NAIVE_VARIANTS = {"naive", "atan_approx"}
SHARED_VARIANTS = {"shared", "shared_atan_approx"}

VARIANT_LABELS = {
    "naive": "naive",
    "atan_approx": "atan approx",
    "shared": "shared",
    "shared_atan_approx": "shared + atan approx",
}

VARIANT_COLORS = {
    "naive": "#1f77b4",
    "atan_approx": "#ff7f0e",
    "shared": "#2ca02c",
    "shared_atan_approx": "#d62728",
}

ROOF_COLOR = "#3558d6"
COMPUTE_COLOR = "#5f6f89"

def build_parser():
    parser = argparse.ArgumentParser(
        description=(
            "Plot a roofline using the best block shape for each CUDA Sobel variant."
        )
    )
    parser.add_argument("csv_path", help="Timing CSV produced by cuda_profile_sweep.py")
    parser.add_argument(
        "--out-dir",
        default=None,
        help="Directory for the generated roofline image and summary CSV",
    )
    parser.add_argument(
        "--prefix",
        default=None,
        help="Output filename prefix; defaults to the CSV stem",
    )
    parser.add_argument(
        "--peak-bandwidth-gbs",
        type=float,
        default=1555.0,
        help=(
            "Peak memory bandwidth in GB/s. Default assumes one NVIDIA A100 40GB on "
            "Perlmutter."
        ),
    )
    parser.add_argument(
        "--peak-gflops",
        type=float,
        default=19500.0,
        help=(
            "Peak FP32 throughput in GFLOP/s. Default assumes one NVIDIA A100 40GB "
            "on Perlmutter."
        ),
    )
    parser.add_argument(
        "--flops-per-pixel",
        type=float,
        default=25.0,
        help=(
            "FLOP model per output pixel. This intentionally excludes the "
            "special-function cost of atan2/sqrt so the plot emphasizes memory behavior."
        ),
    )
    parser.add_argument(
        "--num-gpus",
        type=int,
        default=1,
        help="Filter to one GPU count from the CSV. Default is 1.",
    )
    parser.add_argument(
        "--format",
        choices=["auto", "png", "svg"],
        default="auto",
        help="Plot format. auto uses PNG when matplotlib is installed, otherwise SVG.",
    )
    return parser


def variant_sort_key(variant):
    try:
        return (0, VARIANT_ORDER.index(variant))
    except ValueError:
        return (1, variant)


def read_rows(path, num_gpus):
    with path.open(newline="") as handle:
        rows = list(csv.DictReader(handle))
    if not rows:
        raise ValueError("CSV has no data rows: {}".format(path))

    filtered = [row for row in rows if int(row.get("num_gpus", 1)) == num_gpus]
    if not filtered:
        raise ValueError("CSV has no rows for num_gpus={}".format(num_gpus))
    return filtered


def require_single_problem(rows):
    widths = {int(row["width"]) for row in rows}
    heights = {int(row["height"]) for row in rows}
    if len(widths) != 1 or len(heights) != 1:
        raise ValueError("Roofline script expects one width/height pair per CSV")
    return widths.pop(), heights.pop()


def summarize_best_variants(rows, flops_per_pixel):
    width, height = require_single_problem(rows)
    output_pixels = float((width - 2) * (height - 2))

    groups = defaultdict(list)
    for row in rows:
        key = (row.get("variant", "naive"), int(row["block_x"]), int(row["block_y"]))
        groups[key].append(float(row["kernel_ms"]))

    entries = []
    for (variant, block_x, block_y), kernel_values in groups.items():
        kernel_ms = sum(kernel_values) / float(len(kernel_values))
        if variant in NAIVE_VARIANTS:
            input_bytes_per_pixel = 9.0
        elif variant in SHARED_VARIANTS:
            input_bytes_per_pixel = float((block_x + 2) * (block_y + 2)) / float(block_x * block_y)
        else:
            raise ValueError("Unknown variant in CSV: {}".format(variant))

        bytes_per_pixel = input_bytes_per_pixel + 8.0
        time_s = kernel_ms / 1000.0
        oi = flops_per_pixel / bytes_per_pixel
        gflops = (output_pixels * flops_per_pixel) / time_s / 1.0e9
        gpixels = output_pixels / time_s / 1.0e9
        entries.append(
            {
                "variant": variant,
                "block_x": block_x,
                "block_y": block_y,
                "kernel_ms": kernel_ms,
                "input_bytes_per_pixel": input_bytes_per_pixel,
                "bytes_per_pixel": bytes_per_pixel,
                "operational_intensity": oi,
                "gflops": gflops,
                "gpixels": gpixels,
            }
        )

    best_by_variant = {}
    for entry in entries:
        variant = entry["variant"]
        current = best_by_variant.get(variant)
        if current is None or entry["kernel_ms"] < current["kernel_ms"]:
            best_by_variant[variant] = entry

    ordered = [
        best_by_variant[variant]
        for variant in sorted(best_by_variant, key=variant_sort_key)
    ]
    return width, height, ordered


def write_summary_csv(path, width, height, flops_per_pixel, summaries):
    with path.open("w", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(
            [
                "width",
                "height",
                "variant",
                "best_block",
                "kernel_ms",
                "input_bytes_per_pixel",
                "total_bytes_per_pixel",
                "operational_intensity_flops_per_byte",
                "gflops",
                "gpixels_per_s",
                "flops_per_pixel_model",
            ]
        )
        for item in summaries:
            writer.writerow(
                [
                    width,
                    height,
                    item["variant"],
                    "{}x{}".format(item["block_x"], item["block_y"]),
                    "{:.6f}".format(item["kernel_ms"]),
                    "{:.6f}".format(item["input_bytes_per_pixel"]),
                    "{:.6f}".format(item["bytes_per_pixel"]),
                    "{:.6f}".format(item["operational_intensity"]),
                    "{:.6f}".format(item["gflops"]),
                    "{:.6f}".format(item["gpixels"]),
                    "{:.6f}".format(flops_per_pixel),
                ]
            )


def roofline_knee_x(peak_bandwidth_gbs, peak_gflops):
    return peak_gflops / peak_bandwidth_gbs


def choose_x_limits(summaries, peak_bandwidth_gbs, peak_gflops):
    oi_values = [item["operational_intensity"] for item in summaries]
    knee_x = roofline_knee_x(peak_bandwidth_gbs, peak_gflops)
    min_x = min(min(oi_values) * 0.62, knee_x / 20.0)
    max_x = max(max(oi_values) * 1.25, knee_x * 1.8)
    return min_x, max_x


def choose_y_limits(summaries, peak_bandwidth_gbs, peak_gflops, min_x):
    min_point_y = min(item["gflops"] for item in summaries)
    memory_y_at_min_x = peak_bandwidth_gbs * min_x
    min_y = min(min_point_y * 0.72, memory_y_at_min_x * 0.72)
    max_y = peak_gflops * 1.10
    return min_y, max_y


def variant_display_label(item):
    return "{} ({:d}x{:d})".format(
        VARIANT_LABELS.get(item["variant"], item["variant"]),
        item["block_x"],
        item["block_y"],
    )


def choose_zoom_limits(summaries):
    oi_values = [item["operational_intensity"] for item in summaries]
    perf_values = [item["gflops"] for item in summaries]
    span_x = max(oi_values) - min(oi_values)
    span_y = max(perf_values) - min(perf_values)
    pad_x = max(0.08, span_x * 0.22)
    pad_y = max(70.0, span_y * 0.24)
    return (
        min(oi_values) - pad_x,
        max(oi_values) + pad_x,
        min(perf_values) - pad_y,
        max(perf_values) + pad_y,
    )


def plot_variant_points(ax, summaries, point_size):
    for item in summaries:
        variant = item["variant"]
        color = VARIANT_COLORS.get(variant, "#000000")
        x_value = item["operational_intensity"]
        y_value = item["gflops"]
        ax.scatter(
            x_value,
            y_value,
            s=point_size,
            color=color,
            edgecolor="white",
            linewidth=1.2,
            zorder=4,
        )


def add_variant_legend(fig, ax, summaries):
    handles = []
    for item in summaries:
        variant = item["variant"]
        color = VARIANT_COLORS.get(variant, "#000000")
        handles.append(
            Line2D(
                [0],
                [0],
                marker="o",
                linestyle="None",
                markerfacecolor=color,
                markeredgecolor="white",
                markeredgewidth=1.1,
                markersize=10,
                label=variant_display_label(item),
            )
        )
    legend = ax.legend(
        handles=handles,
        title="Variants (best block)",
        loc="center left",
        bbox_to_anchor=(1.02, 0.42),
        frameon=False,
        fontsize=9.5,
        title_fontsize=10,
        borderaxespad=0.0,
    )
    fig.add_artist(legend)


def add_roof_legend(ax):
    handles = [
        Line2D([0], [0], color=ROOF_COLOR, linewidth=2.6, label="memory roof"),
        Line2D([0], [0], color=COMPUTE_COLOR, linewidth=2.0, linestyle="--", label="compute roof"),
    ]
    ax.legend(
        handles=handles,
        loc="lower right",
        frameon=False,
        fontsize=9.5,
    )


def plot_roofline(out_path, width, height, summaries, peak_bandwidth_gbs, peak_gflops):
    min_x, max_x = choose_x_limits(summaries, peak_bandwidth_gbs, peak_gflops)
    min_y, max_y = choose_y_limits(summaries, peak_bandwidth_gbs, peak_gflops, min_x)
    knee_x = roofline_knee_x(peak_bandwidth_gbs, peak_gflops)
    x_values = []
    current = min_x
    while current <= max_x * 1.001:
        x_values.append(current)
        current *= 1.12
    memory_values = [peak_bandwidth_gbs * x for x in x_values]

    fig, ax = plt.subplots(figsize=(11.2, 6.8))
    ax.plot(x_values, memory_values, linewidth=2.6, color=ROOF_COLOR)
    ax.axhline(
        peak_gflops,
        linestyle="--",
        linewidth=2.0,
        color=COMPUTE_COLOR,
    )
    ax.scatter([knee_x], [peak_gflops], s=46, color=ROOF_COLOR, zorder=5)

    plot_variant_points(ax, summaries, point_size=92)

    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlim(min_x, max_x)
    ax.set_ylim(min_y, max_y)
    ax.set_xlabel("Operational Intensity (FLOPs/Byte)")
    ax.set_ylabel("Performance (GFLOP/s)")
    ax.set_title("CUDA Sobel Roofline ({}x{})".format(width, height), pad=10)
    ax.grid(which="major", alpha=0.24, linewidth=0.9)
    ax.grid(which="minor", alpha=0.10, linewidth=0.6)
    ax.set_axisbelow(True)

    zoom_left, zoom_right, zoom_bottom, zoom_top = choose_zoom_limits(summaries)
    inset = ax.inset_axes([0.075, 0.52, 0.40, 0.34])
    inset.set_facecolor("#fbfbfc")
    for spine in inset.spines.values():
        spine.set_edgecolor("#b8c1cc")
        spine.set_linewidth(0.9)
    plot_variant_points(inset, summaries, point_size=120)
    inset.set_xlim(zoom_left, zoom_right)
    inset.set_ylim(zoom_bottom, zoom_top)
    inset.tick_params(labelsize=8)
    inset.grid(alpha=0.18, linewidth=0.6)
    inset.set_title("Point zoom", fontsize=9.5, pad=5)
    ax.indicate_inset_zoom(inset, edgecolor="#b8c1cc", alpha=0.9)

    add_roof_legend(ax)
    add_variant_legend(fig, ax, summaries)
    fig.subplots_adjust(left=0.10, right=0.75, bottom=0.12, top=0.90)
    fig.savefig(out_path, dpi=220)
    plt.close(fig)


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


def plot_roofline_svg(out_path, width, height, summaries, peak_bandwidth_gbs, peak_gflops):
    plot_w = 1120
    plot_h = 660
    left = 92
    right = 280
    top = 58
    bottom = 86
    inner_w = plot_w - left - right
    inner_h = plot_h - top - bottom

    min_x, max_x = choose_x_limits(summaries, peak_bandwidth_gbs, peak_gflops)
    min_y, max_y = choose_y_limits(summaries, peak_bandwidth_gbs, peak_gflops, min_x)
    knee_x = roofline_knee_x(peak_bandwidth_gbs, peak_gflops)
    log_min_x = math.log10(min_x)
    log_max_x = math.log10(max_x)
    log_min_y = math.log10(min_y)
    log_max_y = math.log10(max_y)

    def x_at(value):
        frac = (math.log10(value) - log_min_x) / (log_max_x - log_min_x)
        return left + frac * inner_w

    def y_at(value):
        frac = (math.log10(value) - log_min_y) / (log_max_y - log_min_y)
        return top + inner_h - frac * inner_h

    x_values = []
    current = min_x
    while current <= max_x * 1.001:
        x_values.append(current)
        current *= 1.12
    memory_values = [peak_bandwidth_gbs * x for x in x_values]

    def path_for(values_x, values_y):
        parts = []
        for index, (vx, vy) in enumerate(zip(values_x, values_y)):
            command = "M" if index == 0 else "L"
            parts.append("{} {:.2f} {:.2f}".format(command, x_at(vx), y_at(vy)))
        return " ".join(parts)

    x_ticks = [0.5, 1.0, 2.0, 4.0, 8.0, 16.0]
    x_ticks = [tick for tick in x_ticks if min_x <= tick <= max_x]
    y_ticks = [300, 1000, 3000, 10000, 30000]
    y_ticks = [tick for tick in y_ticks if min_y <= tick <= max_y]

    elements = [
        svg_text(plot_w / 2, 30, "CUDA Sobel Roofline ({}x{})".format(width, height), 18, weight="bold"),
        '<line x1="{0}" y1="{1}" x2="{0}" y2="{2}" stroke="#333"/>'.format(
            left, top, top + inner_h
        ),
        '<line x1="{0}" y1="{2}" x2="{1}" y2="{2}" stroke="#333"/>'.format(
            left, left + inner_w, top + inner_h
        ),
        svg_text(26, top + inner_h / 2, "Performance (GFLOP/s)", 13, rotate=-90),
        svg_text(left + inner_w / 2, plot_h - 20, "Operational Intensity (FLOPs/Byte)", 13),
    ]

    for tick in x_ticks:
        x = x_at(tick)
        elements.append(
            '<line x1="{0:.2f}" y1="{1}" x2="{0:.2f}" y2="{2}" stroke="#e1e1e1"/>'.format(
                x, top, top + inner_h
            )
        )
        elements.append(svg_text(x, top + inner_h + 24, "{:.3g}".format(tick), 11))

    for tick in y_ticks:
        y = y_at(tick)
        elements.append(
            '<line x1="{0}" y1="{1:.2f}" x2="{2}" y2="{1:.2f}" stroke="#e1e1e1"/>'.format(
                left, y, left + inner_w
            )
        )
        elements.append(svg_text(left - 10, y + 4, "{:.3g}".format(tick), 11, anchor="end"))

    elements.append(
        '<path d="{}" fill="none" stroke="{}" stroke-width="3"/>'.format(
            path_for(x_values, memory_values),
            ROOF_COLOR,
        )
    )
    elements.append(
        '<line x1="{0}" y1="{1:.2f}" x2="{2}" y2="{1:.2f}" stroke="{3}" '
        'stroke-width="2" stroke-dasharray="7,5"/>'.format(
            left, y_at(peak_gflops), left + inner_w, COMPUTE_COLOR
        )
    )
    elements.append(
        '<circle cx="{:.2f}" cy="{:.2f}" r="4.5" fill="{}"/>'.format(
            x_at(knee_x), y_at(peak_gflops), ROOF_COLOR
        )
    )

    legend_x = left + inner_w + 28
    elements.extend(
        [
            '<line x1="{:.2f}" y1="82" x2="{:.2f}" y2="82" stroke="{}" stroke-width="3"/>'.format(legend_x, legend_x + 28, ROOF_COLOR),
            svg_text(legend_x + 36, 86, "memory roof", 11, anchor="start"),
            '<line x1="{:.2f}" y1="104" x2="{:.2f}" y2="104" stroke="{}" stroke-width="2" stroke-dasharray="7,5"/>'.format(legend_x, legend_x + 28, COMPUTE_COLOR),
            svg_text(legend_x + 36, 108, "compute roof", 11, anchor="start"),
            svg_text(legend_x, 146, "Variants (best block)", 12, anchor="start", weight="bold"),
        ]
    )

    for index, item in enumerate(summaries, start=1):
        variant = item["variant"]
        x = x_at(item["operational_intensity"])
        y = y_at(item["gflops"])
        label = variant_display_label(item)
        color = VARIANT_COLORS.get(variant, "#000000")
        legend_y = 170 + (index - 1) * 30
        elements.append(
            '<circle cx="{:.2f}" cy="{:.2f}" r="7" fill="{}" stroke="white" stroke-width="1.2"/>'.format(x, y, color)
        )
        elements.append(
            '<circle cx="{:.2f}" cy="{}" r="7" fill="{}" stroke="white" stroke-width="1.0"/>'.format(
                legend_x + 8, legend_y, color
            )
        )
        elements.append(svg_text(legend_x + 24, legend_y + 4, label, 11, anchor="start"))

    write_svg(out_path, plot_w, plot_h, elements)


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

        rows = read_rows(csv_path, args.num_gpus)
        width, height, summaries = summarize_best_variants(rows, args.flops_per_pixel)

        summary_path = out_dir / (prefix + ".roofline_summary.csv")
        plot_path = out_dir / (prefix + ".roofline." + plot_format)
        write_summary_csv(summary_path, width, height, args.flops_per_pixel, summaries)
        if plot_format == "png":
            plot_roofline(
                plot_path,
                width,
                height,
                summaries,
                args.peak_bandwidth_gbs,
                args.peak_gflops,
            )
        else:
            plot_roofline_svg(
                plot_path,
                width,
                height,
                summaries,
                args.peak_bandwidth_gbs,
                args.peak_gflops,
            )

        print("Wrote {}".format(summary_path))
        print("Wrote {}".format(plot_path))
        return 0
    except Exception as exc:
        print("Error: {}".format(exc), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
