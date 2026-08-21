#!/bin/zsh
# Per-stage checkpoint for the module-system migration.
#
#   scripts/check_module_invariants.sh
#
# Assumes `LEAN_NUM_THREADS=8 lake build V14Challenge V14Solution AxiomAudit`
# has already succeeded. Runs, in order:
#
#   1. the `import all` gate — ZERO occurrences are permitted anywhere in the
#      tree. `import all` reinstates full-environment loading on whatever edge
#      it sits on, and the edges it sat on were the hottest modules in the
#      export closure. Comment text mentioning the phrase is fine; this
#      matches the import syntax only (start of line).
#   2. `#print axioms` on the published theorems — the axiom SET must equal the
#      `permitted_axioms` set of `comparator.json`, in any order.
#   3. the statement-identity check (scripts/check_statement_identity.lean):
#      the challenge and solution environments must give every audited theorem
#      STRUCTURALLY identical types, which is what Comparator's statement-match
#      phase does. This is the check that catches the 7680055a class of bug,
#      where two per-module `private abbrev`s made the statements defeq but not
#      syntactically equal.
#   4. the reachable-constant walk (scripts/check_comparator_walk.lean):
#      Comparator does not stop at the statements. It walks every constant
#      those statements reach and compares full `ConstantInfo`, VALUES included.
#      Step 3 passes on challenges this step rejects — see DEFECTS.md D15.
#
# SINGLE SOURCE OF TRUTH (2026-08-20). `comparator.json` is parsed once, here,
# and the target list, permitted-axiom list and the two module names are passed
# to the Lean scripts as arguments. Nothing downstream hardcodes a theorem name.
# The only list that lives in this file is `CANARIES`: theorems that are NOT
# Comparator targets but are still published and still kept identical on both
# sides. Checking them is strictly stronger than what Comparator will run.
#
# Exit 0 iff all four pass.
set -u
cd "$(dirname "$0")/.."
fail=0

# ---------------------------------------------------------------- the sources

# Theorems that are published and kept identical on both sides but are not
# Comparator targets. They would drag the coordinate machinery into the trusted
# base, so `comparator.json` does not name them; this gate checks them anyway.
CANARIES=(
  V14Formalization.Comparator.noEquivariantRationalMap_projectiveSpaceOfRep
  V14Formalization.Comparator.noEquivariantRationalMap_from_ambient
  V14Formalization.Comparator.noEquivariantRationalMap_projectiveGVariety
)

cfg=$(python3 - comparator.json <<'PY'
import json, sys
c = json.load(open(sys.argv[1]))
def emit(key, default=None):
    v = c.get(key, default)
    if v is None:
        raise SystemExit(f"comparator.json: missing key {key!r}")
    print(v if isinstance(v, str) else ",".join(v))
emit("challenge_module")
emit("solution_module")
emit("theorem_names")
emit("permitted_axioms")
PY
) || { print "FAIL: could not parse comparator.json"; exit 1; }

CHALLENGE_MODULE=${${(f)cfg}[1]}
SOLUTION_MODULE=${${(f)cfg}[2]}
TARGETS=${${(f)cfg}[3]}
PERMITTED=${${(f)cfg}[4]}
CANARY_LIST=${(j:,:)CANARIES}

print "== configuration (from comparator.json) =="
print "  challenge module: $CHALLENGE_MODULE"
print "  solution module:  $SOLUTION_MODULE"
print "  targets:          $TARGETS"
print "  permitted axioms: $PERMITTED"
print "  local canaries:   $CANARY_LIST"

# --------------------------------------------------------------- 1. import all

print "== 1. import all gate =="
# `grep -r` exits 0 on a match, 1 on a clean sweep, >1 on a tool error. The old
# `|| true` swallowed the third case, so a broken grep reported OK.
hits=$(grep -rn --include='*.lean' '^[[:space:]]*\(public[[:space:]]\+\)\?import all[[:space:]]' . \
         --exclude-dir=.lake 2>/dev/null)
grep_rc=$?
if [[ $grep_rc -gt 1 ]]; then
  print "FAIL: the import-all sweep could not run (grep exit $grep_rc)"
  fail=1
elif [[ $grep_rc -eq 0 ]]; then
  print 'FAIL: import all present:'
  print "$hits"
  fail=1
else
  print 'OK: zero import all lines'
fi

# ------------------------------------------------------------------ 2. axioms

print "== 2. axioms =="
AUDITED="$TARGETS,$CANARY_LIST"
tmp=$(mktemp -t axcheck).lean
print "import $SOLUTION_MODULE" > "$tmp"
for n in ${(s:,:)AUDITED}; do
  print "#print axioms $n" >> "$tmp"
done
axout=$(mktemp -t axout).txt
lake env lean "$tmp" > "$axout" 2>&1
rm -f "$tmp"
cat "$axout"
if python3 scripts/check_axiom_sets.py "$PERMITTED" "$AUDITED" "$axout"; then
  print "OK: every audited theorem depends on exactly the permitted axiom set"
else
  print "FAIL: axiom set differs from comparator.json's permitted_axioms"
  fail=1
fi
rm -f "$axout"

# ------------------------------------------------------- 3. statement identity

print "== 3. statement identity (Comparator surrogate) =="
if lake env lean --run scripts/check_statement_identity.lean \
     --challenge "$CHALLENGE_MODULE" --solution "$SOLUTION_MODULE" \
     --targets "$TARGETS" --canaries "$CANARY_LIST"; then
  print "OK"
else
  print "FAIL: challenge and solution statements are not structurally identical"
  fail=1
fi

# --------------------------------------------------------------- 4. the walk

print "== 4. reachable-constant walk (Comparator surrogate, phase 2) =="
if lake env lean --run scripts/check_comparator_walk.lean \
     --challenge "$CHALLENGE_MODULE" --solution "$SOLUTION_MODULE" \
     --targets "$TARGETS" --canaries "$CANARY_LIST"; then
  print "OK"
else
  print "FAIL: a constant reachable from the published statements differs between"
  print "      challenge and solution (see DEFECTS.md D15)"
  fail=1
fi

print "== result: $([[ $fail -eq 0 ]] && print PASS || print FAIL) =="
exit $fail
