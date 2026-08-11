#!/bin/sh
# Acceptance tests for the Problem E notebook protocol.
#
#   sh problems/E-klein-cubic/notebook_build/tests/run_tests.sh [branch]
#
# T1  migrate -> regenerate -> parity, and nothing the old digest said is lost
# T2a with the merge driver: two concurrent sessions merge zero-touch clean
# T2b without it: the digest conflicts and ONE documented command resolves it
# T3  grep -C3 on the generated digest is byte-identical to before the split
#
# Everything runs in scratch clones (KEEP=1 to leave them behind). The working
# tree is never modified.
set -u

here=$(cd "$(dirname "$0")" && pwd)
build=$(dirname "$here")
problem=$(dirname "$build")
repo=$(git -C "$problem" rev-parse --show-toplevel)
gitdir=$(git -C "$problem" rev-parse --git-common-dir)
gitdir=$(cd "$(dirname "$gitdir")" && pwd)/$(basename "$gitdir")
branch=${1:-$(git -C "$problem" rev-parse --abbrev-ref HEAD)}
origin_url=$(git -C "$problem" config --get remote.origin.url)

scratch=${SCRATCH:-$(mktemp -d)}
echo "notebook protocol acceptance tests"
echo "  branch under test : $branch"
echo "  scratch           : $scratch"
echo

make_clone() {  # $1 = name
  target="$scratch/$1"
  git clone --quiet --local --shared --no-checkout "$gitdir" "$target" || exit 9
  git -C "$target" checkout -q -b t2-base "origin/$branch" 2>/dev/null \
    || git -C "$target" checkout -q -b t2-base "$branch" || exit 9
  git -C "$target" config user.email "notebook-tests@local"
  git -C "$target" config user.name "notebook tests"
  # point origin at the real remote so the parity checker's branch checks see
  # the same world they see in a normal clone
  [ -n "$origin_url" ] && git -C "$target" remote set-url origin "$origin_url"
  git -C "$target" fetch -q --prune origin 2>/dev/null
  echo "$target"
}

rc=0

echo "--- T1: migration, regeneration, parity, content preservation ---"
c1=$(make_clone t1)
python3 "$here/t1_migrate_parity.py" --repo "$c1" || rc=1
echo

echo "--- T3: grep-discoverability against the pre-migration digest ---"
python3 "$here/t3_grep_context.py" --repo "$c1" || rc=1
echo

echo "--- T2a: concurrent merge WITH the merge driver ---"
c2=$(make_clone t2a)
sh "$here/t2_concurrency.sh" "$c2" driver || rc=1
echo

echo "--- T2b: concurrent merge WITHOUT the merge driver ---"
c3=$(make_clone t2b)
sh "$here/t2_concurrency.sh" "$c3" nodriver || rc=1
echo

if [ "${KEEP:-0}" = "0" ]; then rm -rf "$scratch"; else echo "kept: $scratch"; fi
if [ $rc -eq 0 ]; then echo "ALL TESTS PASS"; else echo "SOME TESTS FAILED"; fi
exit $rc
