#!/bin/sh
# Install the Problem E notebook merge driver in THIS clone.
#
# Merge drivers cannot be committed (git config is per clone), so every clone
# that merges notebook work runs this once. notebook_build/reconcile.py runs it
# automatically when it finds the driver unconfigured.
#
# Without the driver nothing breaks: a merge simply conflicts in the generated
# digest, and the documented one-command fix is
#     python3 problems/E-klein-cubic/notebook_build/reconcile.py --resolve-merge
set -e

root=$(git rev-parse --show-toplevel)
driver_script="$root/problems/E-klein-cubic/notebook_build/merge_driver.py"

if [ ! -f "$driver_script" ]; then
  echo "setup_merge_driver: $driver_script not found" >&2
  exit 1
fi

git config merge.notebook.name \
  "Problem E notebook digest: discard both sides, regenerate from notebook_build/"
git config merge.notebook.driver \
  "python3 \"$driver_script\" %O %A %B %P"

echo "configured merge.notebook.driver -> $driver_script"
