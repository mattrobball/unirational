# Goal C5 — solve the full self-adjoint projector incidence

**Pinned state:** `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`  
**Priority:** 1  
**Possible headline direction:** positive  
**Accepted bridge:** `BR-FANO-POS`

## Mission

Construct a `K_proj`-point of the genuine twisted Fano section without first
requiring a fully expanded quaternion Morita model.

Use the exact lazy degree-six algebra `A`, its symplectic involution `sigma`,
and the installed distinguished five-plane of self-adjoint elements

```text
S_1,...,S_5 in Sym(A,sigma).
```

A common isotropic right quaternionic line can be encoded directly by a
self-adjoint reduced-rank-two idempotent `e`.  Solve the full incidence

```text
e^2 = e,
sigma(e) = e,
Trd(e) = 2,
e S_i e = 0,  i=1,...,5.
```

The fixed ternary projector cubic is only a linear slice of this scheme and
must not be used as an exhaustive model.

## Binding inputs

Consume and canonically merge the accepted post-`35fa8f` Pfaffian packets:

- exact minimal polynomials and the rectangular basis;
- the lazy multiplication oracle in the aligned algebra;
- the transported symplectic involution, with eigendimensions `15/21`;
- the exact distinguished five-plane;
- the exact auxiliary projector point/open, only as a chart seed;
- the audit quarantining the namespace-mutated cyclotomic RUR.

Record exact hashes and choose one authoritative copy of every duplicated
object.  If the copies disagree, stop with `C5-CANONICAL-INPUT-FAIL` and the
smallest inconsistent set.

## Mathematical convention gate

Before solving, prove in the installed left/right convention that:

1. a `sigma`-self-adjoint idempotent of reduced trace two determines the
   required reduced-rank-two right ideal, equivalently a right `D`-line after
   Morita reduction;
2. the restriction of the Hermitian form represented by `S_i` to that line
   vanishes exactly when `e S_i e=0` in the chosen convention;
3. the resulting point is a point of the genuine `F_{14,T}`, not merely an
   ambient projector or characteristic-cubic point;
4. changing between `Ae`, `eA`, column, row, and transposed conventions does
   not alter the equations silently.

Deliver `CONVENTION_AND_EQUIVALENCE.md` with exact mutually inverse maps or a
fully instantiated Morita lemma.  A theorem for an arbitrary CSA without the
installed coordinate maps is insufficient.

## Work packages

### C5.0 — canonical exact algebra

Create a single input manifest and a deterministic API for:

```text
multiply(x,y), sigma(x), reduced_trace(x), S_i.
```

All operations must accept coordinates in one fixed exact basis and return
coordinates over `K_proj`.  The independent verifier must recompute selected
products, involution identities, traces, and all five `S_i` from the sealed
source circuits.

Required marker:

```text
C5_CANONICAL_ALGEBRA_OK
```

### C5.1 — full projector-incidence equations

Choose an exact basis `q_0,...,q_14` of `Sym(A,sigma)` and put

```text
e(t) = sum_j t_j q_j.
```

Construct, without interpolation:

- all coordinate equations of `e(t)^2-e(t)=0`;
- `Trd(e(t))-2=0`;
- all coordinate equations of `e(t) S_i e(t)=0` for `i=1,...,5`;
- denominator and projector-open conditions;
- a proof that no equation from the full algebra has been discarded by a
  dependent coordinate projection.

Use linear algebra to remove redundant equations, but retain a certificate of
row span over the exact coefficient field.  Give both a homogeneous/projective
formulation where appropriate and affine charts meeting every reduced-rank-two
component.

Deliver:

```text
PROJECTOR_INCIDENCE.md
projector_incidence.json
build_incidence.py
verify_incidence.py
```

### C5.2 — structural reduction before Groebner work

Use the exact known auxiliary projector only to select useful charts and
compute tangent/normal blocks.  Then reduce the full scheme by, in order:

1. solve all linear equations and trace constraints;
2. block-diagonalize the idempotent tangent equations at split good primes;
3. identify and remove components with wrong reduced rank or failed open
   conditions;
4. exploit the Peirce decomposition induced by a chart projector;
5. eliminate linear and bilinear blocks before any general Groebner solve;
6. compute dimension, degree, and component data at two discovery primes and
   one unused holdout prime.

A point in the old fixed three-space is not required.  Conversely, emptiness
of that slice is irrelevant to the full solve.

### C5.3 — exact point or exact scoped emptiness

#### Point branch

From a smooth modular point or a low-degree component:

1. Hensel lift or reconstruct exact coordinates over `K_proj`;
2. reduce every coordinate to the canonical field presentation;
3. verify `e^2=e`, `sigma(e)=e`, `Trd(e)=2`, and every `eS_i e=0` exactly;
4. prove all denominators and Fano open conditions are units;
5. map the projector to original Plucker/Fano coordinates and substitute in
   the authoritative equations.

The final verifier must not import the point-producing solver.

#### Empty branch

If every chart is empty, certify projective saturation of the full incidence
away from all required opens in characteristic zero.  This gives only
`C5-FULL-FANO-SCHEME-EMPTY-SCOPED`; it is not a negative headline without a
new necessity theorem for rational points on the generic Klein twist.

A modular unit ideal alone is acceptable only with a written spreading-out
argument proving that the chosen prime is good for every denominator,
saturation, and rank condition and that emptiness specializes in the required
direction.

### C5.4 — headline bridge

For an exact point, provide `BRIDGE_FANO_POS.md` checking each hypothesis of
`BR-FANO-POS`:

- exact field identity with `K_proj`;
- genuine twisted Fano section;
- common simultaneous line, not five separately soluble forms;
- conversion to a point of the genuine generic Klein twist;
- versality and the accepted implication to a dominant `G`-map;
- generic-rank/open checks required for `G`-unirationality.

## Parallel attack lanes

Sol Ultra workers may run these independently after C5.0:

- **Lane A — direct idempotent solve:** the equations above in the 15-dimensional
  symmetric space;
- **Lane B — right-ideal Grassmann chart:** parameterize the corresponding
  reduced-dimension right ideals and impose the five restrictions;
- **Lane C — explicit Morita fallback:** construct `D=e_0Ae_0`, transport the
  five forms to `Herm_3(D)`, and solve in quaternionic projective coordinates.

The lanes must reconcile in the authoritative algebra before any point is
promoted.

## Exits

```text
C5-POINT-HEADLINE-POSITIVE
C5-EXECUTABLE-FULL-INCIDENCE
C5-FULL-FANO-SCHEME-EMPTY-SCOPED
C5-CANONICAL-INPUT-FAIL
C5-UNDECIDED
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_bd610a/C5_PROJECTOR_INCIDENCE/
```

Provide at least:

```text
INPUT_MANIFEST.json
CONVENTION_AND_EQUIVALENCE.md
CANONICAL_ALGEBRA.md
PROJECTOR_INCIDENCE.md
POINT.md or EMPTY.md
BRIDGE_FANO_POS.md when applicable
produce.py
verify.py
SEAL.json
STATUS.md
```

The seal must exclude mutable solver scratch and include every exact circuit,
coordinate map, saturation, transcript, and verifier consumed by the exit.