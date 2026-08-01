# Goal R2 — construct a rational curve on the genuine generic twist

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 14  
**Possible headline direction:** positive

## Mission

Find a base-field rational curve on the genuine generic Klein or Schur twist whose geometry yields a rational point or a unirational parametrization. Work on descended Hilbert schemes, not merely geometric curve classes over the algebraic closure.

This route is independent of the marked degree-19 construction, though it may reuse its Hilbert/monad technology.

## Work packages

### R2.0 — curve-class ranking

Compute the expected dimensions, obstruction groups, and descent data for:

- lines and conics, incorporating the known no-line/no-plane-conic theorems;
- twisted cubics;
- rational quartics and quintics;
- higher-degree free rational curves;
- curves constrained through the degree-55 Schur point or subgroup orbits.

Select classes whose Hilbert spaces are expected to dominate the twist or admit evaluation maps with rational fibres.

### R2.1 — exact descended Hilbert components

For each selected class:

- construct the Hilbert/Quot component over the invariant field;
- prove geometric integrality and identify Galois action;
- compute universal ideals/monads and tangent-obstruction spaces;
- determine whether the component has a rational point or a zero-cycle of controlled degree;
- verify the universal curve lies on the genuine twist.

A geometric component over the algebraic closure is insufficient without descent.

### R2.2 — evaluation and point extraction

Use one or two marked points, incidence with a known closed orbit, or rational connectedness of the Hilbert component to obtain a rational point on the twist. Every field-of-definition step must be explicit.

### R2.3 — exact certification

Construct the curve equations over the base field, substitute into the genuine cubic, verify rationality/integrality, and execute the appropriate positive bridge.

## Exits

```text
R2-RATIONAL-CURVE-HEADLINE-POSITIVE
R2-HILBERT-COMPONENT-PASS
R2-SELECTED-CLASSES-EMPTY-SCOPED
R2-DESCENT-OBSTRUCTED
R2-UNDECIDED
```

Emptiness of finitely many curve classes is not a negative headline.

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/R_RATIONAL_CURVES/
```

Provide `CLASS_RANKING.md`, descended Hilbert/Quot payloads, universal curve equations, exact point extraction, independent verifiers, and `SEAL.json`.