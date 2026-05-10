#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

CUDA_BIN="${CUDA_BIN:-${REPO_ROOT}/cuda/build/sobel_cuda}"
NVIDIA_NCU="${NVIDIA_NCU:-ncu}"
WIDTH="${WIDTH:-4096}"
HEIGHT="${HEIGHT:-4096}"
WARMUP="${WARMUP:-0}"
REPEATS="${REPEATS:-1}"
TARGET_PROCESSES="${TARGET_PROCESSES:-application-only}"
ROOFLINE_MODE="${ROOFLINE_MODE:-section}"
SECTION_NAME="${SECTION_NAME:-SpeedOfLight_RooflineChart}"
SET_NAME="${SET_NAME:-roofline}"
FORCE_OVERWRITE="${FORCE_OVERWRITE:-1}"
PAUSE_DCGM="${PAUSE_DCGM:-1}"
USE_SRUN_FOR_DCGMI="${USE_SRUN_FOR_DCGMI:-0}"
NO_OUTPUT_WRITE="${NO_OUTPUT_WRITE:-1}"
SKIP_D2H="${SKIP_D2H:-1}"
INPUT_PATH="${INPUT_PATH:-${REPO_ROOT}/data/cuda_benchmark/inputs/cuda_sobel_${WIDTH}x${HEIGHT}.img.bin}"
REPORT_DIR="${REPORT_DIR:-${REPO_ROOT}/data/cuda_benchmark/ncu_roofline/${WIDTH}x${HEIGHT}}"
OUTPUT_DIR="${OUTPUT_DIR:-/tmp/cuda_sobel_ncu}"
EXTRA_NCU_ARGS="${EXTRA_NCU_ARGS:-}"
EXTRA_APP_ARGS="${EXTRA_APP_ARGS:-}"

VARIANTS=(
  "naive:32x16"
  "atan_approx:16x8"
  "shared:8x8"
  "shared_atan_approx:16x8"
)

usage() {
  cat <<'EOF'
Run Nsight Compute roofline profiling for the four CUDA Sobel variants.

Environment overrides:
  WIDTH, HEIGHT          Input size. Default: 4096 x 4096
  INPUT_PATH             Input .bin path. Default matches WIDTH/HEIGHT under data/cuda_benchmark/inputs
  REPORT_DIR             Output directory for .ncu-rep files
  OUTPUT_DIR             Placeholder output path root passed to sobel_cuda
  CUDA_BIN               Path to sobel_cuda
  NVIDIA_NCU             Path to ncu
  WARMUP, REPEATS        sobel_cuda run counts. Default: 0, 1
  ROOFLINE_MODE          section or set. Default: section
  SECTION_NAME           Default: SpeedOfLight_RooflineChart
  SET_NAME               Default: roofline
  PAUSE_DCGM             1 to pause DCGM before profiling and resume after. Default: 1
  USE_SRUN_FOR_DCGMI     1 to run dcgmi through srun --ntasks-per-node=1. Default: 0
  EXTRA_NCU_ARGS         Extra ncu args, appended before the target application
  EXTRA_APP_ARGS         Extra sobel_cuda args, appended before positional args

Examples:
  ./tools/run_ncu_roofline.sh
  WIDTH=32768 HEIGHT=32768 ./tools/run_ncu_roofline.sh
  ROOFLINE_MODE=set EXTRA_NCU_ARGS="--cache-control none" ./tools/run_ncu_roofline.sh
  USE_SRUN_FOR_DCGMI=1 ./tools/run_ncu_roofline.sh
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

if [[ ! -x "${CUDA_BIN}" ]]; then
  echo "CUDA binary not found or not executable: ${CUDA_BIN}" >&2
  echo "Build it first with: cmake --build ${REPO_ROOT}/cuda/build" >&2
  exit 1
fi

if [[ ! -f "${INPUT_PATH}" ]]; then
  echo "Input file not found: ${INPUT_PATH}" >&2
  exit 1
fi

mkdir -p "${REPORT_DIR}" "${OUTPUT_DIR}"

PROFILE_PAUSED=0

run_dcgmi() {
  if [[ "${USE_SRUN_FOR_DCGMI}" == "1" ]]; then
    srun --ntasks-per-node=1 dcgmi "$@"
  else
    dcgmi "$@"
  fi
}

resume_dcgmi_if_needed() {
  if [[ "${PROFILE_PAUSED}" == "1" ]]; then
    echo
    echo "Resuming DCGM profiling..."
    if ! run_dcgmi profile --resume; then
      echo "WARNING: failed to resume DCGM profiling automatically." >&2
      echo "Try running: dcgmi profile --resume" >&2
    fi
    PROFILE_PAUSED=0
  fi
}

trap resume_dcgmi_if_needed EXIT

NCU_PROFILE_SELECTOR=()
if [[ "${ROOFLINE_MODE}" == "set" ]]; then
  NCU_PROFILE_SELECTOR=(--set "${SET_NAME}")
else
  NCU_PROFILE_SELECTOR=(--section "${SECTION_NAME}")
fi

NCU_COMMON_ARGS=(
  --target-processes "${TARGET_PROCESSES}"
)

if [[ "${FORCE_OVERWRITE}" == "1" ]]; then
  NCU_COMMON_ARGS+=(-f)
fi

if [[ -n "${EXTRA_NCU_ARGS}" ]]; then
  # shellcheck disable=SC2206
  NCU_COMMON_ARGS+=(${EXTRA_NCU_ARGS})
fi

APP_COMMON_ARGS=(
  --warmup "${WARMUP}"
  --repeats "${REPEATS}"
)

if [[ "${NO_OUTPUT_WRITE}" == "1" ]]; then
  APP_COMMON_ARGS+=(--no-output-write)
fi

if [[ "${SKIP_D2H}" == "1" ]]; then
  APP_COMMON_ARGS+=(--skip-d2h)
fi

if [[ -n "${EXTRA_APP_ARGS}" ]]; then
  # shellcheck disable=SC2206
  APP_COMMON_ARGS+=(${EXTRA_APP_ARGS})
fi

echo "========================================"
echo "Nsight Compute Roofline Run"
echo "Repo:        ${REPO_ROOT}"
echo "Binary:      ${CUDA_BIN}"
echo "Input:       ${INPUT_PATH}"
echo "Image:       ${WIDTH}x${HEIGHT}"
echo "Report dir:  ${REPORT_DIR}"
echo "Mode:        ${ROOFLINE_MODE}"
echo "Warmup:      ${WARMUP}"
echo "Repeats:     ${REPEATS}"
echo "Pause DCGM:  ${PAUSE_DCGM}"
echo "Variants:    ${#VARIANTS[@]}"
echo "========================================"

if [[ "${PAUSE_DCGM}" == "1" ]]; then
  if ! command -v dcgmi >/dev/null 2>&1; then
    echo "dcgmi not found in PATH, but PAUSE_DCGM=1 was requested." >&2
    exit 1
  fi
  echo
  echo "Pausing DCGM profiling..."
  run_dcgmi profile --pause
  PROFILE_PAUSED=1
fi

for entry in "${VARIANTS[@]}"; do
  variant="${entry%%:*}"
  block="${entry##*:}"
  report_prefix="${REPORT_DIR}/${variant}_${block}_${WIDTH}x${HEIGHT}"
  output_path="${OUTPUT_DIR}/${variant}_${block}_${WIDTH}x${HEIGHT}.magdir.bin"

  echo
  echo "=== ${variant} @ ${block} ==="
  echo "+ ${NVIDIA_NCU} ${NCU_COMMON_ARGS[*]} ${NCU_PROFILE_SELECTOR[*]} -o ${report_prefix} ${CUDA_BIN} --variant ${variant} --block ${block} ${APP_COMMON_ARGS[*]} ${INPUT_PATH} ${output_path} ${WIDTH} ${HEIGHT}"

  "${NVIDIA_NCU}" \
    "${NCU_COMMON_ARGS[@]}" \
    "${NCU_PROFILE_SELECTOR[@]}" \
    -o "${report_prefix}" \
    "${CUDA_BIN}" \
    --variant "${variant}" \
    --block "${block}" \
    "${APP_COMMON_ARGS[@]}" \
    "${INPUT_PATH}" \
    "${output_path}" \
    "${WIDTH}" \
    "${HEIGHT}"
done

resume_dcgmi_if_needed

echo
echo "Finished. Reports written under:"
echo "  ${REPORT_DIR}"
echo
echo "Open one with:"
echo "  ncu-ui ${REPORT_DIR}/naive_32x16_${WIDTH}x${HEIGHT}.ncu-rep"
