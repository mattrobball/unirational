# Axiom audit

## Policy

Zero project `axiom` / `sorry` / `admit` / `sorryAx` / seal `opaque` on the Thm 3.1 and V14 application path.

## `#print axioms` (AxiomAudit.lean)

The first two rows are the theorems `comparator.json` names; they are the only
two declarations Comparator checks, and until 2026-08-18 `AxiomAudit.lean` did
not mention them.

| Theorem | Axioms |
|---------|--------|
| `Comparator.noEquivariantRationalMap_from_ambient` | `propext`, `Classical.choice`, `Quot.sound` |
| `Comparator.noEquivariantRationalMap_projectiveGVariety` | `propext`, `Classical.choice`, `Quot.sound` |
| `centralizerObstruction` | `propext`, `Classical.choice`, `Quot.sound` |
| `centralizerObstruction_one_rep` | `propext`, `Classical.choice`, `Quot.sound` |
| `noDegenerates_of_centerless_involution` | `propext`, `Classical.choice`, `Quot.sound` |
| `V14App.V14_not_weakly_versal` | `propext`, `Classical.choice`, `Quot.sound` |
| `V14App.V14_no_equivariant_map_from_faithful_rep` | `propext`, `Classical.choice`, `Quot.sound` |
| `V14App.V14_not_GUnirational` | `propext`, `Classical.choice`, `Quot.sound` |

No project-named axioms or seals appear.

## How to re-run

```bash
lake build
lake env lean AxiomAudit.lean
bash scripts/verify.sh
```
