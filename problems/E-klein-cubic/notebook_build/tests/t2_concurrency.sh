#!/bin/sh
# T2 -- the concurrency proof.
#
#   t2_concurrency.sh <clone> driver     T2a: with the merge driver installed,
#                                             the merge is zero-touch clean
#   t2_concurrency.sh <clone> nodriver   T2b: without it, the merge conflicts in
#                                             the generated digest ONLY, and the
#                                             single documented command
#                                             `reconcile.py --resolve-merge`
#                                             resolves it -- nothing else.
#
# Both variants: two branches off one commit, each adding a NEW entry file and a
# NEW branch marker, then reconciling and committing. That is the exact shape of
# two concurrent sessions.
set -u

clone=$1
mode=$2
problem="$clone/problems/E-klein-cubic"
build="$problem/notebook_build"
fail=0

say() { echo "$1 T2$mode $2"; }
ok()  { say "OK  " "$1"; }
bad() { say "FAIL" "$1"; fail=1; }

make_session() {  # $1 = session letter, $2 = entry ordinal
  letter=$1
  ord=$2
  cat > "$build/entries/2026-08-12-$ord-t2-session-$letter.md" <<EOF
<!-- T2_SESSION_${letter}_20260812 -->

# Notebook supplement — 2026-08-12: T2 concurrency probe, session $letter

Written by notebook_build/tests/t2_concurrency.sh. Probe string:
T2-SESSION-$letter-PROBE.
EOF
  printf 'branch: test/t2-session-%s\nregistered: 2026-08-12\n' "$letter" \
    > "$build/branches/test%2Ft2-session-$letter"
  NOTEBOOK_SKIP_DRIVER_SETUP=1 python3 "$build/reconcile.py" > /dev/null || exit 9
  git -C "$clone" add -A -- problems/E-klein-cubic > /dev/null
  git -C "$clone" commit -q -m "t2: session $letter entry" || exit 9
}

git -C "$clone" checkout -q -b "t2-a-$mode"
make_session A 90
git -C "$clone" checkout -q -b "t2-b-$mode" HEAD~1
make_session B 91
git -C "$clone" checkout -q "t2-a-$mode"

if [ "$mode" = "driver" ]; then
  ( cd "$clone" && sh "$build/setup_merge_driver.sh" > /dev/null ) || exit 9
fi

git -C "$clone" merge --no-edit "t2-b-$mode" > "$clone/.merge.log" 2>&1
merge_rc=$?
unmerged=$(git -C "$clone" diff --name-only --diff-filter=U)

if [ "$mode" = "driver" ]; then
  [ $merge_rc -eq 0 ] && ok "merge exited 0 (no conflict)" \
                      || bad "merge exited $merge_rc: $(tail -2 "$clone/.merge.log")"
  [ -z "$unmerged" ] && ok "zero unmerged paths -- nothing to resolve by hand" \
                     || bad "unmerged paths: $unmerged"
  grep -q '^<<<<<<<' "$problem/NOTEBOOK.md" && bad "conflict markers in NOTEBOOK.md" \
                                            || ok "no conflict markers in NOTEBOOK.md"
  python3 "$build/generate_notebook.py" --check > /dev/null 2>&1 \
    && ok "merged digest is already byte-fresh (no reconcile needed)" \
    || bad "merged digest is not what the generator produces"
else
  [ $merge_rc -ne 0 ] && ok "merge conflicted, as expected without the driver" \
                      || bad "merge unexpectedly clean without the driver"
  case "$unmerged" in
    *NOTEBOOK.md*) ok "conflict is in the generated digest" ;;
    *) bad "expected a NOTEBOOK.md conflict, got: $unmerged" ;;
  esac
  echo "$unmerged" | grep -q 'notebook_build/entries/' \
    && bad "an entry file conflicted -- sources are supposed to merge cleanly" \
    || ok "no entry/section source file conflicted"
  # the single documented resolution, and nothing else
  python3 "$build/reconcile.py" --resolve-merge > "$clone/.reconcile.log" 2>&1 \
    || bad "reconcile --resolve-merge failed: $(tail -2 "$clone/.reconcile.log")"
  still=$(git -C "$clone" diff --name-only --diff-filter=U)
  [ -z "$still" ] && ok "one command cleared every unmerged path" \
                  || bad "still unmerged after reconcile: $still"
  git -C "$clone" commit -q --no-edit && ok "merge commit created" \
                                      || bad "merge commit failed"
fi

# both sessions' content survived
for probe in T2-SESSION-A-PROBE T2-SESSION-B-PROBE; do
  grep -q "$probe" "$problem/NOTEBOOK.md" && ok "digest carries $probe" \
                                          || bad "digest lost $probe"
done
for letter in A B; do
  low=$(echo "$letter" | tr 'AB' 'ab')
  [ -f "$build/branches/test%2Ft2-session-$low" ] \
    && ok "branch marker for session $letter survived" \
    || bad "branch marker for session $letter lost"
done

python3 "$build/reconcile.py" > /dev/null 2>&1 || bad "post-merge reconcile failed"
python3 "$problem/scripts/check_manifest_parity.py" > "$clone/.parity.log" 2>&1
if [ $? -eq 0 ]; then
  ok "parity checker PASS after reconcile"
else
  bad "parity checker FAIL: $(grep -E '^(FAIL|RESULT)' "$clone/.parity.log" | tr '\n' ' ')"
fi

echo
if [ $fail -eq 0 ]; then echo "T2$mode RESULT: PASS"; else echo "T2$mode RESULT: FAIL"; fi
exit $fail
