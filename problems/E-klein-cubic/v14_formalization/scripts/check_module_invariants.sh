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
#   2. `#print axioms` on the three published theorems — must be exactly
#      propext, Classical.choice, Quot.sound.
#   3. the statement-identity check (scripts/check_statement_identity.lean):
#      the challenge and solution environments must give both theorems
#      STRUCTURALLY identical types, which is what Comparator's statement-match
#      phase does. This is the check that catches the 7680055a class of bug,
#      where two per-module `private abbrev`s made the statements defeq but not
#      syntactically equal.
#   4. the reachable-constant walk (scripts/check_comparator_walk.lean):
#      Comparator does not stop at the two statements. It walks every constant
#      those statements reach and compares full `ConstantInfo`, VALUES included.
#      Step 3 passes on challenges this step rejects — see DEFECTS.md D15.
#
# Since 2026-08-19 `comparator.json` names ONE target, the coordinate-free
# theorem. Steps 2-4 still cover all three published theorems: the other two
# stay in the tree, stay proved, and stay identical on both sides, so checking
# them is strictly stronger than what Comparator will run.
#
# Exit 0 iff all four pass.
set -u
cd "$(dirname "$0")/.."
fail=0

print "== 1. import all gate =="
hits=$(grep -rn --include='*.lean' '^[[:space:]]*\(public[[:space:]]\+\)\?import all[[:space:]]' . \
         --exclude-dir=.lake 2>/dev/null || true)
if [[ -n "$hits" ]]; then
  print 'FAIL: import all present:'
  print "$hits"
  fail=1
else
  print 'OK: zero import all lines'
fi

print "== 2. axioms =="
tmp=$(mktemp -t axcheck).lean
cat > "$tmp" <<'EOF'
import V14Solution
#print axioms V14Formalization.Comparator.noEquivariantRationalMap_projectiveSpaceOfRep
#print axioms V14Formalization.Comparator.noEquivariantRationalMap_from_ambient
#print axioms V14Formalization.Comparator.noEquivariantRationalMap_projectiveGVariety
EOF
ax=$(lake env lean "$tmp" 2>&1)
rm -f "$tmp"
print "$ax"
n_ok=$(print "$ax" | tr -d ' \n' | grep -o 'dependsonaxioms:\[propext,Classical.choice,Quot.sound\]' | wc -l | tr -d ' ')
if [[ "$n_ok" != "3" ]]; then
  print "FAIL: axiom set is not exactly [propext, Classical.choice, Quot.sound] for all three theorems"
  fail=1
else
  print "OK: all three theorems depend on exactly the three permitted axioms"
fi

print "== 3. statement identity (Comparator surrogate) =="
if lake env lean --run scripts/check_statement_identity.lean; then
  print "OK"
else
  print "FAIL: challenge and solution statements are not structurally identical"
  fail=1
fi

print "== 4. reachable-constant walk (Comparator surrogate, phase 2) =="
if lake env lean --run scripts/check_comparator_walk.lean; then
  print "OK"
else
  print "FAIL: a constant reachable from the published statements differs between"
  print "      challenge and solution (see DEFECTS.md D15)"
  fail=1
fi

print "== result: $([[ $fail -eq 0 ]] && print PASS || print FAIL) =="
exit $fail
