# Goal S19.2 — construct the marked degree-19 curve on the genuine Schur twist

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 8  
**Possible headline direction:** positive

## Mission

Construct a qualifying degree-19 rational curve through the genuine degree-55 Schur point and execute the already audited residual-degree-two bridge to a rational point of the generic Schur twist.

No August worker implemented this goal. Consume the earlier exact Hilbert/Rao and Krylov packets at their repaired boundaries.

## Binding state

- the positive implication chain `BR-SCHUR19-POS` is audited and field-correct;
- the selected degree-55 point and its marked orbit are genuine;
- integral ACM degree-19 curves through one descended point are excluded;
- two non-ACM Rao branches remain;
- the relevant marked Hilbert scheme is defined over the base field;
- emptiness of this construction is not a negative headline.

## Work packages

### S19.0 — canonical marked 55-point family

Rebuild the universal split-hyperplane 55-point scheme from the exact `D12` lines, with hyperplane parameters and the good-open conditions. Produce a fixed integral presentation and verify the Hilbert function on a dense open by exact generic freeness, not random fibres alone.

### S19.1 — marked Hilbert/Quot components

For each surviving Rao branch:

- construct the relative marked Hilbert or Quot component over the hyperplane base;
- compute tangent/obstruction spaces and component dimensions;
- impose passage through the full descended 55-point orbit;
- distinguish geometric integrality, rationality, and descent;
- compute the universal ideal or a finite monad/resolution.

### S19.2 — special carrier Picard and liaison

Resolve the remaining special quintic-carrier branch. Determine the Picard group of the actual carrier selected by the unknown curve, not a very-general carrier. Use Noether--Lefschetz with base locus, explicit divisor class computation, or liaison to either construct or exclude the curve.

### S19.3 — exact curve and residual cycle

For a surviving component:

1. construct an exact base-field point of the marked Hilbert component;
2. verify the curve is geometrically integral, rational, degree 19, and passes through the marked orbit;
3. compute the residual degree-two cycle in the genuine Schur intersection;
4. verify the residual line/field argument in the original equations;
5. obtain a rational point and invoke `BR-SCHUR19-POS`.

## Exits

```text
S19-CURVE-HEADLINE-POSITIVE
S19-BRANCH-EXCLUDED-SCOPED
S19-MARKED-COMPONENT-PASS
S19-SPECIAL-HYPERPLANE-ONLY
S19-UNDECIDED
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/S19_MARKED_CURVE/
```

Provide universal marked ideals, component/monad payloads, carrier Picard calculations, exact curve/residual verification, independent verifiers, and `SEAL.json`.