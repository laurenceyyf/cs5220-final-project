#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$ROOT_DIR/build/runner-venv"

# Create a lightweight local virtual environment on first use.
if [[ ! -x "$VENV_DIR/bin/python" ]]; then
  python3 -m venv --system-site-packages "$VENV_DIR"
fi

# Forward all user arguments to the Python pipeline runner.
exec "$VENV_DIR/bin/python" "$ROOT_DIR/tools/serial_pipeline.py" "$@"
