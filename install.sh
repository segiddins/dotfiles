#!/bin/bash
set -euo pipefail

command -v chezmoi >/dev/null || sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

chezmoi init --apply --source="${CHEZMOI_SOURCE:-$(cd "$(dirname "$0")" && pwd)}"
