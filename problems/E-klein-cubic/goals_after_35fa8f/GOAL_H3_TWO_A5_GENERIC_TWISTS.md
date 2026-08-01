# Goal H3 — decide the two nonconjugate maximal `A5` generic twists

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 13  
**Possible headline direction:** negative via `BR-SUBGROUP-NEG`

## Mission

Treat the two maximal `A5` embeddings separately and decide whether either installed genuine generic twist is pointless. One pointless twist disproves `G`-unirationality.

Both exact Hilbert--90 frames and twist equations are installed. Both twists have index one. No rational point or pointlessness theorem is known.

## Work packages

### H3.0 — compare but do not identify the two embeddings

Compute invariant-field presentations and exact birational invariants of the two twist equations. Determine which data are conjugate only after an outer automorphism or field extension, and which genuinely differ. Maintain separate payloads throughout.

### H3.1 — minimal exact models

Exploit the irreducible five-dimensional `A5` representation and classical icosahedral invariant theory to express each twist over a small transcendence basis of `C(P^2)^{A5}`. Verify equivalence with the original frame-substituted equation.

### H3.2 — geometric and arithmetic attacks

For each class independently, seek:

- rational curves/surfaces or birational fibrations;
- valuations with residual index obstruction;
- unramified Brauer/cohomological invariants distinguishing point from index-one zero-cycle;
- explicit covariant maps from the three-dimensional source;
- quotient-stack or icosahedral norm-form descriptions.

The two classes may have different answers; no symmetry shortcut is permitted without proof.

### H3.3 — exact decision

#### Pointlessness

Prove one genuine generic twist has no point and invoke `BR-SUBGROUP-NEG`.

#### Point

Construct exact coordinates and verify the original twisted equation. Record whether the point is induced by an `A5`-equivariant rational map and whether it informs the full `G` route.

## Exits

```text
H-A5-CLASS1-POINTLESS-HEADLINE-NEGATIVE
H-A5-CLASS2-POINTLESS-HEADLINE-NEGATIVE
H-A5-CLASS1-RATIONAL-POINT
H-A5-CLASS2-RATIONAL-POINT
H-A5-STRUCTURAL-MODEL-PASS
H-A5-UNDECIDED
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/H_A5_TWISTS/
```

Use separate class directories with field models, twist equations, point/obstruction payloads, independent verifiers, and one combined `SEAL.json`.