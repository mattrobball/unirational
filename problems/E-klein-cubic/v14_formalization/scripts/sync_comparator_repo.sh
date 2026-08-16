#!/bin/bash
# Copy this project into an already-running comparator-base without .lake.
# The harness `container cp` of the 16G .lake tree hits an XPC timeout.
set -euo pipefail
CTR="${1:-comparator-base}"
DEST="${2:-/work/current/repo}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
container exec "${CTR}" mkdir -p "${DEST}"
tar -C "${ROOT}" \
  --exclude='.lake' \
  --exclude='.container-app' \
  --exclude='.container-logs' \
  --exclude='.home' \
  --exclude='.comparator-slim' \
  -cf - . \
  | container exec -i "${CTR}" tar -C "${DEST}" -xf -
echo "synced ${ROOT} -> ${CTR}:${DEST} (no .lake)"
