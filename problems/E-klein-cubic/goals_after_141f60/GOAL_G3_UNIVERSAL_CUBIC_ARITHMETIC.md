# Goal G3 — decide the universal generic Klein cubic

**Pinned state:** `141f6042f628f984771fc79d8d16beb12cedcb94`  
**Priority:** 1  
**Headline direction:** positive or negative  
**Accepted structural input:** `G2-FINITE-GENERATION-PASS`

## Mission

Decide the exact arithmetic alternative

\[
X_{\rm gen}(K_{\rm proj})\ne\varnothing
\quad\text{or}\quad
X_{\rm gen}(K_{\rm proj})=\varnothing,
\]

where

\[
X_{\rm gen}=V(\Phi)\subset\mathbf P^4_{K_{\rm proj}}
\]

is the explicit 35-coefficient cubic installed by G/G2.  This is the full
all-degree landing problem, not a finite-degree proxy.

A point authorizes the positive headline after the dominance bridge is
checked.  Pointlessness authorizes the negative headline after the accepted
source-exhaustiveness theorem is replayed.

## Binding inputs

Consume and hash:

```text
goal_runs_after_35fa/G_UNIVERSAL/
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json
certificates/global_transition/necessity_theorem.json
SPEC.md
REPAIR.md
```

Use the exact Hironaka field arithmetic and secondary multiplication tables
already installed in the repository.  Do not replace `K_proj` by a random
specialization or by the larger splitting field.

## G3.0 — canonical arithmetic engine

Build a deterministic exact API for

```text
K_proj elements;
secondary-basis multiplication and inversion;
the 35 coefficients of Phi;
Phi(a0,...,a4);
all first and second partial derivatives;
denominator/open ledgers.
```

Requirements:

1. Reconstruct all 35 coefficients from the upstream invariant data rather
   than merely loading their JSON values.
2. Verify the normalized cubic is smooth over `K_proj` or state the exact
   singular locus if the current packet did not already prove this.
3. Produce efficient export to Magma, Sage, Macaulay2, and plain sparse
   rational arithmetic without expanding unrelated Pfaffian algebras.
4. Record a primitive-element presentation only if it reduces arithmetic;
   retain the 12-element secondary basis as the verification authority.

Required marker:

```text
G3-EXACT-ARITHMETIC-ENGINE-PASS
```

## G3.1 — headline bridge and dominance audit

Audit the point-to-map direction of the all-degree theorem and the argument in
`SPEC.md`.

Given `a in X_gen(K_proj)`, denominator clearing gives a nonzero homogeneous
`G`-covariant `p` with `F(p)=0`.  Let `Z` be the irreducible image.  Check
carefully that:

1. the map from the honest linear representation to `Z` makes `Z` very
   versal;
2. the action kernel on `Z` is normal in the simple group `G`;
3. the kernel is not all of `G`, because `X^G=empty`;
4. `ed_C(G)>=3` therefore gives `dim Z>=3`;
5. since `dim X=3`, the map is dominant.

If this proof is valid in the installed affine/projective conventions, record

```text
G3-DOMINANCE-AUTOMATIC
```

and remove any additional rank requirement from the positive bridge.  If it
fails, identify the precise implication and use the correct affine-cone or
projective differential rank, not an unexplained rank-four test.

For the negative branch, identify the exact already-proved source
exhaustiveness theorem that turns `X_gen(K_proj)=empty` into absence of every
linear-source equivariant map.  No new all-degree module argument is allowed.

## G3.2 — direct rational-point lanes

Run the following lanes in parallel after G3.0.  A bounded failure in any lane
is only a scoped return.

### Lane A — projective charts and fibrations

For each `a_i=1` chart:

1. regard `Phi` successively as a cubic, quadratic, or linear equation in one
   remaining variable;
2. factor exact leading coefficients and discriminants over `K_proj`;
3. identify rational components, conic bundles, quadric-surface bundles, or
   genus-one fibrations;
4. compute the generic fibre class and search for an exact section;
5. check every denominator and reconstruct the point in the original frame.

Prefer structural factorization over random coefficient searches.

### Lane B — lines and plane conics

Construct the exact Fano scheme of lines on `X_gen` in Grassmann big cells.
Search for a `K_proj`-point or a rational component.  In parallel, search for a
`K_proj`-defined plane conic contained in `X_gen`; its residual plane line is
then `K_proj`-defined and gives a point.

Every candidate line or conic must be substituted into all cubic restriction
coefficients by an independent verifier.

### Lane C — tautological polar geometry

The generic torsor supplies a canonical `K_proj`-point of the twisted ambient
`P^4`, although it is not on the cubic.  Compute exactly:

- its first polar quadric;
- the tangent-line/discriminant incidence for lines through it;
- the cubic-plus-polar surface;
- singular and low-rank loci of the polar system.

Search for a rational tangent or residual construction producing a point of
`X_gen`.  State explicitly why any selected polar point gives a rational
third intersection.

### Lane D — multi-prime reconstruction

Use good-prime solutions only to discover coefficient patterns.  Require the
same support, tangent dimension, and component degree at several unrelated
primes and one unused holdout prime.  Reconstruct over the full secondary
basis and verify `Phi=0` identically.  A point on one specialized fibre is not
an exit.

## G3.3 — exact pointlessness lanes

A negative result must prove `X_gen(K_proj)=empty`.  Permitted approaches are:

1. the full `f5` or `f6` unramified residue cubic from Goal G5;
2. the genuine `11:5` trace cubic from Goal H6;
3. a new point-dependent/non-transfer obstruction surviving Q2.1;
4. a complete exact birational reduction to a known pointless variety.

Not permitted as negative evidence:

- finite degree exclusions;
- empty fixed frames or ternary sections;
- index one without a point;
- modular emptiness without the correct specialization direction;
- local solubility failures on an auxiliary twist;
- a nonzero tropicalization or value-group argument already retired by V3.

## Deliverables

Write under

```text
problems/E-klein-cubic/goal_runs_after_141f60/G3_UNIVERSAL_CUBIC_ARITHMETIC/
```

Provide at least:

```text
INPUT_MANIFEST.json
FIELD_ARITHMETIC.md
phi_exact.json
DOMINANCE_BRIDGE.md
CHART_FIBRATIONS.md
LINE_CONIC_SEARCH.md
POLAR_GEOMETRY.md
POINT.md or POINTLESSNESS.md when obtained
BRIDGE_G_POS.md or BRIDGE_G_NEG.md when applicable
produce.py
verify.py
REPLAY.md
SEAL.json
STATUS.md
```

## Authorized exits

```text
G3-POINT-HEADLINE-POSITIVE
G3-POINTLESS-HEADLINE-NEGATIVE
G3-BIRATIONAL-FIBRATION-PASS
G3-DOMINANCE-AUTOMATIC
G3-EXACT-ARITHMETIC-ENGINE-PASS
G3-UNDECIDED
G3-CANONICAL-INPUT-FAIL
```

Only the first two are headline candidates.  Structural exits must preserve
the binary as open.
