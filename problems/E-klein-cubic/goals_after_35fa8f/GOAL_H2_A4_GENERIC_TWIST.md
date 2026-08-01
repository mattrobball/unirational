# Goal H2 — decide the installed generic `A4` twist

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 5  
**Possible headline directions:** negative via `BR-SUBGROUP-NEG`, or positive information for the subgroup route

## Mission

Decide whether the exact generic `A4`-twist of the Klein cubic installed in

```text
H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json
```

has a rational point over `K_A4=C(P^2)^{A4}`. Pointlessness gives an immediate negative headline for the original `G`-action. A rational point closes this subgroup obstruction and may suggest a construction for the full group.

Do not substitute another bounded polynomial-covariant ladder for the rational-point problem. Degrees 1--4 are already excluded for all projective character multipliers; degree 5 is a useful finite gate only.

## Structural input

The restriction is

\[
W|_{A_4}=1'\oplus1''\oplus3.
\]

The exact Hilbert--90 frame, genuine twisted Klein equation, invariant field, and index-one theorem are installed. Index one is not a point.

## Work packages

### H2.0 — canonical affine/invariant presentation

Replace the large frame-substituted equation by a minimal exact model over an explicit transcendence basis of `K_A4`.

- compute a presentation of `C(P^2)^{A4}` and its relation to the Hilbert--90 frame;
- exploit the `1'`, `1''`, and `3` decomposition;
- express the cubic in invariant/norm-form coordinates;
- record all denominator opens and verify equivalence with the original twisted equation.

### H2.1 — search for a structural fibration or torsor

Analyze projections to the character coordinates and the twisted three-space. Seek:

- conic bundles or genus-one fibrations on a birational modification;
- norm-form equations from the conjugate character lines;
- rational multisections whose degree is coprime to the fibre index;
- torsors under tori or elliptic curves with computable classes;
- a rational curve or surface contained in the twist.

The geometric Picard-rank-one obstruction for the prime Fano model does not prohibit birational fibrations after blowups.

### H2.2 — valuation and unramified obstruction

If no point is found, compute divisorial valuations of the exact invariant field adapted to the `A4` quotient. Test:

- specialization index;
- unramified Brauer classes;
- degree-three or mixed-prime torsion;
- zero-cycles and local solubility;
- stable reduction of the cubic.

A special pointless fibre is insufficient. The valuation must extend a hypothetical generic point by properness and land on a residual variety proved pointless.

### H2.3 — exact point or pointlessness certificate

#### Point

Construct exact coordinates in `K_A4`, substitute into the genuine twist, and verify every denominator. Explain whether the point comes from a rational `A4`-equivariant map and whether it has any implication for the full `G`-problem.

#### Pointlessness

Prove the genuine generic twist has no `K_A4`-point and invoke `BR-SUBGROUP-NEG` to conclude that the Klein cubic is not `G`-unirational.

## Optional finite gate

Compute the complete degree-5 projective `A4`-equivariant landing schemes for all three character multipliers only if it feeds the structural model. An empty degree-5 result is scoped and must not terminate the rational-point mission.

## Exits

```text
H-A4-POINTLESS-HEADLINE-NEGATIVE
H-A4-RATIONAL-POINT
H-A4-STRUCTURAL-MODEL-PASS
H-A4-DEGREE5-EMPTY-SCOPED
H-A4-UNDECIDED
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/H_A4_TWIST/
```

Provide `FIELD_MODEL.md`, `TWIST_MODEL.md`, `FIBRATION_OR_VALUATION.md`, exact point/obstruction payloads, independent verifiers, and `SEAL.json`.