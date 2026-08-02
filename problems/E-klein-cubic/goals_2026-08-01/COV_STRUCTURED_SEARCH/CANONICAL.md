# Canonical marker — Goal COV structured search (A0 audit)

**Authority:** this directory is the **canonical** COV structured packet for
consumption of theorem boundaries.

| Item | Value |
|---|---|
| Canonical exit | `COV-NEW-ANSATZ-STRUCTURAL` |
| Seal | `SEAL.json` |

## Theorem (exact scope)

1. At selected higher plane orders `(d,m,e) ∈ {(25,3,7),(31,5,1),(35,5,5)}`,
   the global coefficient module is zero after the first normal Taylor
   coefficients — those higher-plane-order branches do not globalize.
2. Named composition / invariant-gradient cross-product / mixed ansatz
   families are empty in characteristic zero at the sealed scope.
3. **Every `m=1` degree remains open.** Degrees 25, 31, 35 are **not**
   degree-wide empty.

## Do not consume

Do **not** treat sibling exit
`COV-STRUCTURED-DEGREES-EMPTY-SCOPED`
(`../COV_STRUCTURED_SEARCH_ROOT/`) as degree-wide emptiness. Canonical
semantic repair:

```text
COV-HIGHER-ORDER-BRANCHES-EMPTY-SCOPED
```

(equivalent in force to this packet’s `COV-NEW-ANSATZ-STRUCTURAL` plus the
higher-order branch emptiness).

## Audit reference

`goal_runs_after_35fa/A0_CANONICAL_AUDIT/`
