#!/usr/bin/env bash
# Committed verification entrypoint: build + zero-axiom/sorry census + axiom audit.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "== lake build =="
lake build

echo "== lake build AxiomAudit =="
lake build AxiomAudit 2>/dev/null || true

echo "== zero project axiom / sorry / admit / sorryAx census =="
# Exclude comments: require line not only a module-doc mention.
FAIL=0
if rg -n --glob '*.lean' --glob '!.lake/**' '^\s*axiom\s' .; then
  echo "FAIL: project-declared axiom found" >&2
  FAIL=1
fi
if rg -n --glob '*.lean' --glob '!.lake/**' --glob '!probe*.lean' \
    '(^|[^a-zA-Z/`_])sorry([^a-zA-Z`]|$)|(^|[^a-zA-Z])admit([^a-zA-Z]|$)|sorryAx' . \
    | grep -v 'zero `sorry`' | grep -v 'no sorry' | grep -v '# Zero' ; then
  echo "FAIL: found sorry/admit/sorryAx" >&2
  FAIL=1
fi
if [[ "$FAIL" -ne 0 ]]; then exit 1; fi
echo "OK: no project axiom/sorry/admit/sorryAx"

echo "== #print axioms (headline theorems; only classical Lean axioms) =="
AUDIT_OUT="$(mktemp)"
lake env lean AxiomAudit.lean >"$AUDIT_OUT" 2>&1 || {
  echo "FAIL: AxiomAudit lean run failed" >&2
  cat "$AUDIT_OUT" >&2
  exit 1
}
cat "$AUDIT_OUT"
if grep -E 'sorryAx|V14Formalization\.[A-Za-z0-9_]*\.?axiom|depends on axioms: \[.*axiom' "$AUDIT_OUT" \
    | grep -v 'propext\|Classical.choice\|Quot.sound' ; then
  # Also fail if any non-classical axiom appears
  :
fi
# Explicitly require only classical triple
while IFS= read -r line; do
  if [[ "$line" == *"depends on axioms:"* ]]; then
    # strip to list contents
    list="${line#*depends on axioms: }"
    # allow only propext, Classical.choice, Quot.sound
    cleaned=$(echo "$list" | tr -d '[] ' | tr ',' '\n' | sed '/^$/d')
    while IFS= read -r ax; do
      case "$ax" in
        propext|Classical.choice|Quot.sound) ;;
        *)
          echo "FAIL: non-classical axiom on path: $ax (line: $line)" >&2
          exit 1
          ;;
      esac
    done <<< "$cleaned"
  fi
done < "$AUDIT_OUT"
echo "OK: only classical axioms on headline paths"

echo "== headline theorems present =="
for t in \
  centralizerObstruction \
  centralizerObstruction_one_rep \
  noDegenerates_of_centerless_involution \
  V14_not_weakly_versal \
  V14_no_equivariant_map_from_faithful_rep \
  V14_not_GUnirational
do
  if ! rg -q "theorem $t" --glob '*.lean' --glob '!.lake/**' .; then
    echo "FAIL: missing theorem $t" >&2
    exit 1
  fi
  echo "OK: theorem $t"
done

echo "== coupling: plusProjectiveStratum uses plusEigenspace =="
if ! rg -q 'plusProjectiveStratum|plusEigenspace' V14Formalization/Definitions.lean; then
  echo "FAIL: plus stratum / eigenspace missing" >&2
  exit 1
fi
if ! rg -q 'x.submodule ≤ R.plusEigenspace|plusProjectiveStratum' V14Formalization/Definitions.lean; then
  echo "FAIL: plus stratum not coupled to plusEigenspace" >&2
  exit 1
fi
echo "OK: plus stratum coupled to eigenspace"

echo "== IsGUnirational requires dominance =="
if ! rg -q 'HasDominantGEquivariantRationalMap' V14Formalization/Definitions.lean; then
  echo "FAIL: IsGUnirational missing dominance" >&2
  exit 1
fi
echo "OK: dominance present"

echo "== geometric V14 inputs are theorems (not axioms) =="
for a in \
  V14_hypothesisA \
  V14_hypothesisB \
  PSL2F11_isCenterless \
  sigma_isInvolution \
  image_of_trackedStratum_singleton \
  regularRep
do
  if rg -q "^\s*axiom\s\+$a" --glob '*.lean' --glob '!.lake/**' .; then
    echo "FAIL: $a is still an axiom" >&2
    exit 1
  fi
  if ! rg -q "$a" --glob '*.lean' --glob '!.lake/**' .; then
    echo "FAIL: missing $a" >&2
    exit 1
  fi
  echo "OK: $a present and not axiom"
done

echo "== no forbidden seals =="
for a in fact29_resolve_tracked plusStratumPackage V14_existsFaithfulLinearRep; do
  if rg -q "^\s*axiom\s\+$a|opaque\s\+$a" --glob '*.lean' --glob '!.lake/**' .; then
    echo "FAIL: forbidden seal $a still present" >&2
    exit 1
  fi
done
echo "OK: no forbidden seals"

echo "== noDegenerates is a theorem (not axiom) =="
if rg -q '^\s*axiom\s\+noDegenerates_of_centerless_involution' --glob '*.lean' --glob '!.lake/**' .; then
  echo "FAIL: noDegenerates still an axiom" >&2
  exit 1
fi
if ! rg -q 'theorem noDegenerates_of_centerless_involution' --glob '*.lean' --glob '!.lake/**' .; then
  echo "FAIL: noDegenerates theorem missing" >&2
  exit 1
fi
echo "OK: noDegenerates proved"

echo "ALL VERIFY CHECKS PASSED"
