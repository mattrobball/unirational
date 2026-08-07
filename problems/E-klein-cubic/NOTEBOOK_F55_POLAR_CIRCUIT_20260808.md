# Research notebook supplement — F55 polar-circuit reduction

**Date:** 2026-08-08  
**Branch:** `agent/f55-audit-obstruction`  
**Canonical parent:** `NOTEBOOK.md`  
**Status:** branch supplement pending later notebook compaction  
**Headline:** `F55-QUESTION-OPEN`

This supplement records the proof reduction and runner dispatch that followed
the F55/V14 audit.  It is intentionally theorem-oriented rather than an event
log.  The detailed proof is in
`F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md`.

## 1. Corrected research state

The replacement obstruction must distinguish support-function compatibility
from exact coefficient realizability.  The corrected F55 boundary/PL system
has an integral convex solution, so divisorial valuations alone cannot close
the problem.  The degree-7 calculation demonstrates the missing altitude:
exact squared-slot multiplicities produce a two-row monomial identity even
when the generator-level support shadow survives.

The authoritative equation is used directly:

\[
\Phi(a)=\sum_{i=0}^4\sigma^i\!\left(\chi^{-e_2}a^2\sigma(a)\right)=0
\]

in the rank-four group algebra.  This removes the five projective twists from
the all-degree analysis.  The trace-support coefficients are positive
integers; cyclotomic phases are needed only in bounded covariant comparisons.

## 2. Proven reduction

The following steps are now proved.

### R1 — finite primitive Laurent support

Every rational solution can be multiplied by the invariant norm of its
denominator to obtain a Laurent-polynomial solution.  Choosing minimal Newton
width then removes every nonunit invariant polynomial divisor.  Because the
cyclic action has no nonzero fixed lattice vector, this normalization is a
factor normalization, not a common exponent-translation quotient.

### R2 — exact support ideal

For finite support \(S\), the coefficient rows are

\[
F_\gamma=
\sum_{T_i(p,q;r)=\gamma}\mu(p,q)A_pA_qA_r,
\qquad
\mu=1\text{ or }2.
\]

An exact-support zero exists precisely when

\[
I_S:(\prod_{s\in S}A_s)^\infty\ne(1).
\]

The smallest general negative artifact is one sparse identity placing a
monomial in \(I_S\).

### R3 — polar candidates have one affine form

Every two-row polar pattern comes from adjacent cyclic slots and

\[
2w=\sigma u+\sigma^2v+e_2-\sigma e_2.
\]

For clean rows

\[
f=\alpha X_u^2X_v+\beta X_uX_w^2,
\quad
g=\alpha'X_uX_vX_z+\beta'X_zX_w^2,
\]

the determinant
\(\Delta=\alpha\beta'-\alpha'\beta\) gives

\[
\alpha X_ug-\alpha'X_zf
 =\Delta X_uX_zX_w^2.
\]

Thus the runner searches one affine parity relation, not arbitrary
quadruples.

### R4 — binomial holonomy is complete

For binomial rows, integer relations among exponent differences are the only
compatibility conditions.  Smith/Hermite normal form plus exact rational
return products gives a complete torus decision for an all-binomial support
and an immediate obstruction whenever one cycle product is nontrivial.

### R5 — minimal core and remaining gap

An inclusion-minimal support zero has a connected variable/row incidence graph,
and minimal zero-sum row circuits cover every support variable.  The sole
all-degree structural gap is a coverage theorem forcing one of:

```text
singleton row;
nonzero clean polar determinant;
failed binomial holonomy;
bounded sparse monomial consequence.
```

No finite support bound has been proved.  In particular, unrestricted Laurent
collision lattices cannot be replaced automatically by a finite Hilbert-basis
census.  Normaliz calculations are valid only after a pointed cone or bounded
degree has been fixed.

## 3. Minimized computational interface

Only three computational operations remain:

```text
C0  compile exact integer trace rows and cross-check direct expansion;
C1  inspect classified polar pairs and one integral holonomy kernel;
C2  saturate only the finite supports that survive C1, retaining one exact
    monomial identity or one exact torus point.
```

The coverage theorem itself is a mathematical gate.  PC4 performs bounded
falsification and locates the smallest exceptional core; bounded emptiness is
not promotable.

## 4. Runner dispatch

The five staged work orders are:

```text
WORKORDER_F55_PC1_PRIMITIVE_LAURENT.md
WORKORDER_F55_PC2_TRACE_SUPPORT_COMPILER.md
WORKORDER_F55_PC3_POLAR_EDGE_HOLONOMY.md
WORKORDER_F55_PC4_MINIMAL_CORE_SEARCH.md
WORKORDER_F55_PC5_EXACT_SATURATION_CERTIFICATES.md
```

Dependency DAG:

```text
PC1 -----> shared lattice conventions
             |
PC2 ---------+----> PC3 ----> PC4 first exception ----> PC5
                         \----> direct finite-support NO
```

PC5 has an asymmetric theorem boundary:

- a monomial certificate kills only the supplied support unless coverage has
  been proved;
- an exact torus coefficient point gives a Laurent solution of the
  authoritative trace equation and triggers immediate `F55-YES` assembly.

## 5. Supersession note

This supplement and
`F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md` supersede the unrestricted
finite-Hilbert-basis and invariant-translation language in §8 of
`F55_REPLACEMENT_OBSTRUCTION_20260808.md`.  The coefficient-holonomy program
itself remains live; only its proposed route to all-support finiteness is
corrected.

## 6. Current markers

```text
F55-PC-PROOF-REDUCTION-COMPLETE
F55-PC-DISPATCH-COMPLETE
F55-PC-COVERAGE-THEOREM-OPEN
F55-QUESTION-OPEN
```
