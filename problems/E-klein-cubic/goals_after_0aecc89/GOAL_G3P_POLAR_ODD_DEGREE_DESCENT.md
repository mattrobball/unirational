# Goal G3P — tautological polar geometry and odd-degree quadratic descent

**Audited parent state:** `0aecc89f0598cfd982295107352e6cc6e9fb04e9`  
**Priority:** 2  
**Parent goal:** G3  
**Dependency:** `G3A-ARITHMETIC-DOMINANCE-PASS` or an equivalent exact engine  
**Headline direction:** positive

## Mission

Use the canonical `K_proj`-point of the **twisted ambient** projective
four-space to construct a point of

\[
X_{\rm gen}=V(\Phi)\subset\mathbf P^4_{K_{\rm proj}}.
\]

The ambient point is not on the cubic.  Its value is to make the family of
lines through it, the first and second polar forms, and their discriminants
canonical over `K_proj`.  Search for a rational section of the resulting
quadric/conic geometry.  The exact degree-eleven points induced from the two
maximal `A5` classes may be used only through a proved odd-degree descent step.

This goal is the focused replacement for G3 Lane C.  It must not expand into a
general search through every projective chart.

## Binding inputs

Consume and hash

```text
goal_runs_after_35fa/G_UNIVERSAL/
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json
goals_after_0aecc89/GOAL_G3A_EXACT_ARITHMETIC_DOMINANCE.md
```

and, when available,

```text
goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/
goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/
```

The worker may reconstruct the canonical ambient point directly from the
normalized frame if G4 has not yet returned.  It may not invent coordinates by
specializing the invariant field.

## G3P.0 — canonical ambient point and polar convention

Let `q in P^4(K_proj)` be the point obtained by descending the tautological
point of the generic projective torsor.  Prove exactly:

1. `q` is defined over `K_proj` in the installed frame;
2. `Phi(q)` is a nonzero element on an explicit open;
3. the coordinate description agrees with the G2 twisting convention;
4. every denominator used below is recorded.

Let `B` be the symmetric trilinear form normalized by

\[
\Phi(x)=B(x,x,x).
\]

For a direction `v`, reconstruct independently the line polynomial

\[
P_v(t)=\Phi(q+t v)
      =\Phi(q)+3tB(q,q,v)+3t^2B(q,v,v)+t^3\Phi(v).
\]

Define and verify the exact polar objects

```text
H_q: B(q,q,v)=0                         (second-polar hyperplane),
Q_q: B(q,v,v)=0                         (first-polar quadric),
D_q: disc_t(P_v)=0                      (tangent/double-root locus),
I_q: P_v(t)=dP_v/dt=0                   (resolved tangent incidence).
```

All are considered in the projective space of directions modulo the line
`<q>`; quotient coordinates and irrelevant ideals must be handled explicitly.

Required marker:

```text
G3P-POLAR-SYSTEM-PASS
```

## G3P.1 — exact rank and Witt analysis

Compute over the actual field `K_proj`, not only after splitting:

1. the rank, determinant, discriminant, and Clifford invariant of `Q_q` and
   of every quadric naturally appearing after restricting `D_q` or `I_q`;
2. singular loci and low-rank fibres of the polar pencil;
3. rational linear subspaces forced by the frame or by a polar degeneracy;
4. whether any quadric/conic bundle has a section, an odd-degree multisection,
   or a fibre with a certified rational point.

Ordinary Brauer obstruction language must respect Q2.1: a fixed
transfer-compatible Brauer class cannot obstruct the original cubic.  A
Clifford calculation is useful here only as part of an explicit quadratic
fibration whose section gives a cubic point.

## G3P.2 — line-intersection constructions

Run the following exact constructions in order.

### A. Second-polar directions

On `H_q`, the line polynomial has no linear term.  Determine whether a rational
parameterization of a subvariety of `H_q` makes the remaining quadratic/cubic
factor have a `K_proj`-root.  Reduce square conditions to explicit quadrics or
conics whenever possible.

### B. First-polar directions

On `Q_q`, the quadratic coefficient vanishes.  Analyze the resulting depressed
cubic in `t`; search for rational components of its discriminant cover and for
rational specializations forced by the invariant-field relations.

### C. Tangent incidence

Eliminate `t` only after retaining the resolved incidence `I_q`.  Determine
whether projection to directions is birational to a conic bundle, quadric
bundle, or rational cover.  A rational point `(v,t)` gives the exact cubic
point `q+t v` and must be verified directly in `Phi`.

### D. Singular-polar projection

If any polar quadric or discriminant component has a rational singular point or
rational linear space, project from it and write the inverse formulas.  Check
that the inverse meets the open where `q+t v` is a genuine point of the smooth
cubic.

## G3P.3 — use of the degree-eleven `A5` points

For either maximal `A5` class, G4 is expected to produce an integral
odd-degree extension `L/K_proj` and a point `p in X_gen(L)`.  This alone does
**not** descend a point of a cubic threefold.

The permitted odd-degree argument is narrower:

1. use `p` and `q` to construct an `L`-point on a **quadratic** object from
   G3P.1 or G3P.2;
2. prove that quadratic object and all of its defining data descend to
   `K_proj`;
3. prove `L/K_proj` has odd degree on the exact open being used;
4. apply Springer only to that quadratic form or quadric;
5. convert the descended isotropic vector through explicit inverse formulas to
   `(v,t)` and then to a point of `X_gen`.

The worker must reject any attempted inference

```text
cubic has an odd-degree point  =>  cubic has a ground-field point
```

unless it has genuinely passed through the audited quadratic interface above.
Treat both `A5` classes separately and record whether either produces the
required quadratic point.

## G3P.4 — exact promotion

For a candidate `r=q+t v`:

1. verify `Phi(r)=0` exactly in the authoritative secondary basis;
2. check `r` is nonzero and every denominator/open condition;
3. clear denominators through the G2 map to an original homogeneous
   `G`-covariant;
4. verify the original Klein equation and generator equivariance independently;
5. consume the G3A dominance ledger.

Deliver `BRIDGE_POLAR_POS.md` and exit
`G3P-POINT-HEADLINE-POSITIVE` only after all five steps pass.

## Deliverables

Write under

```text
problems/E-klein-cubic/goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/
```

Provide at least

```text
INPUT_MANIFEST.json
TAUTOLOGICAL_POINT.md
POLAR_SYSTEM.md
polar_system.json
QUADRATIC_INVARIANTS.md
quadratic_invariants.json
TANGENT_INCIDENCE.md
ODD_DEGREE_DESCENT.md
POINT.md when obtained
BRIDGE_POLAR_POS.md when applicable
produce.py
verify_polars.py
verify_quadrics.py
verify_point.py
verify_all.py
REPLAY.md
SHA256SUMS
SEAL.json
STATUS.md
```

## Authorized exits

```text
G3P-POINT-HEADLINE-POSITIVE
G3P-QUADRATIC-SPRINGER-REDUCTION-PASS
G3P-RATIONAL-FIBRATION-PASS
G3P-POLAR-SYSTEM-PASS
G3P-UNDECIDED
G3P-CANONICAL-INPUT-FAIL
```

Only the first exit is a Problem-E headline candidate.