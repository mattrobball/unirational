#!/usr/bin/env bash
# Runs Comparator against this project's comparator.json.
#
# Modeled on the comparator-harness's local in-container check.sh, adapted
# for GitHub Actions: instead of a container with tools preinstalled under
# /opt/verification-tools, the calling workflow
# (.github/workflows/v14-comparator.yml) builds comparator, lean4export,
# landrun and nanoda under $GITHUB_WORKSPACE/.verification-tools, creates the
# unprivileged `leancheck` user, runs lean-eval's sandbox_engaged_probe.py,
# and only then invokes this script AS leancheck with the paths to those
# binaries passed in as environment variables. This script does the same
# toolchain-agreement assertions and the same "wipe the build before running"
# discipline as check.sh, then runs Comparator itself.
#
# Required environment (set by the workflow):
#   COMPARATOR_BIN          path to the built comparator binary
#   COMPARATOR_LANDRUN      path to the built landrun binary
#   COMPARATOR_LEAN4EXPORT  path to the built lean4export binary
#   COMPARATOR_NANODA       path to the built nanoda_bin binary
#   LEAN_TOOLCHAIN          toolchain the four tools above were built for
#   TOOLS_DIR               $GITHUB_WORKSPACE/.verification-tools
#
# Optional:
#   CONFIG   Comparator config, relative to this project's root
#            (default: comparator.json)
set -euo pipefail

CONFIG="${CONFIG:-comparator.json}"
: "${COMPARATOR_BIN:?}"
: "${COMPARATOR_LANDRUN:?}"
: "${COMPARATOR_LEAN4EXPORT:?}"
: "${COMPARATOR_NANODA:?}"
: "${LEAN_TOOLCHAIN:?}"
: "${TOOLS_DIR:?}"

for exe in "${COMPARATOR_BIN}" "${COMPARATOR_LEAN4EXPORT}" "${COMPARATOR_NANODA}" "${COMPARATOR_LANDRUN}"; do
    [ -x "${exe}" ] || { echo "${exe} is not executable." >&2; exit 2; }
done

# Self-locate the project root (this script lives at <project>/scripts/).
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

echo "=== repo ==="
git --no-pager log -1 --format='commit %H%n%ci%n%s' -- . 2>/dev/null || echo "(no git metadata)"

echo
echo "=== Lean toolchain agreement ==="
repo_tc="$(tr -d '[:space:]' < lean-toolchain)"
want="$(echo "${LEAN_TOOLCHAIN}" | tr -d '[:space:]')"
echo "project lean-toolchain     : ${repo_tc}"
echo "tools built for            : ${want}"
echo "comparator lean-toolchain  : $(tr -d '[:space:]' < "${TOOLS_DIR}/comparator/lean-toolchain")"
echo "lean4export lean-toolchain : $(tr -d '[:space:]' < "${TOOLS_DIR}/comparator/.lake/packages/lean4export/lean-toolchain")"
echo "lean-eval lean-toolchain   : $(tr -d '[:space:]' < "${TOOLS_DIR}/lean-eval/lean-toolchain")"
echo "resolved lean              : $(lean --short-version)"
if [ "${repo_tc}" != "${want}" ]; then
    echo "MISMATCH between project and tools toolchain." >&2
    exit 3
fi
test "$(lean --short-version)" = "${want##*:v}"

echo
echo "=== sandbox preconditions ==="
echo "kernel: $(uname -r)"
abi="$(python3 -c "
import ctypes
libc = ctypes.CDLL(None, use_errno=True)
print(libc.syscall(444, None, ctypes.c_size_t(0), ctypes.c_uint32(1)))
")"
echo "landlock ABI: ${abi}"
if [ "${abi}" -lt 1 ] 2>/dev/null; then
    echo "ERROR: no Landlock on this runner's kernel." >&2
    echo "       Comparator's sandbox guarantee cannot be met without it." >&2
    exit 4
fi
kv="$(uname -r | sed 's/-.*//')"; kmaj="${kv%%.*}"; krest="${kv#*.}"; kmin="${krest%%.*}"
if [ "${kmaj}" -lt 6 ] || { [ "${kmaj}" -eq 6 ] && [ "${kmin}" -lt 7 ]; }; then
    echo "ERROR: Comparator needs Linux >= 6.7 for Landlock network rules" >&2
    exit 4
fi
echo "landrun: $("${COMPARATOR_LANDRUN}" --version 2>&1 || true)"

echo
echo "=== Mathlib cache ==="
lake exe cache get 2>&1 | tail -3

echo
echo "=== clean project build state ==="
# Comparator must build both the challenge and the solution itself: a
# pre-built solution would not be rebuilt, and compiling the solution
# beforehand can compromise the challenge. This only removes the project's
# own build output; Mathlib's cached build lives under
# .lake/packages/mathlib/.lake/build and is untouched.
rm -rf .lake/build
if find .lake/build -name '*.olean' -print -quit 2>/dev/null | grep -q .; then
    echo "ERROR: project modules present before Comparator" >&2; exit 5
fi
echo "clean"

echo
echo "=== config: ${CONFIG} ==="
cat "${CONFIG}"

echo
echo "=== Comparator (user=$(id -un)) ==="
export LEAN_ABORT_ON_PANIC=1
S=$(date +%s)
set +e
lake env "${COMPARATOR_BIN}" "${CONFIG}"
RC=$?
set -e
echo "COMPARATOR_EXIT_CODE=${RC}"
echo "elapsed $(( $(date +%s) - S ))s"
exit ${RC}
