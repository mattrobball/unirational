# Section search and exact unresolved component

## Section classes

An exceptional section exists exactly when the smooth centre

\[
C_{012}=V(\Phi(a_0,a_1,a_2,0,0))\subset\mathbf P^2_K
\]

has a `K`-point.  Such a point is already headline-positive.

For a nonexceptional section of `H`-degree `d>=1`, write

\[
A_i\in K[s,t]_d,\qquad r\in K[s,t]_{d-1}.
\]

The exact coefficient problem is

\[
\Phi(A_0,A_1,A_2,sr,tr)=0,
\qquad
\gcd(A_0,A_1,A_2,r)=1.
\]

There are `4d+3` affine coefficients, common scalar is quotiented, and the
identity gives `3d+1` cubic coefficient equations.  The graph fixes the base
coordinate, so no `PGL2` quotient is allowed.  The curve has

\[
(H\cdot R,D\cdot R,L\cdot R)=(d,d-1,1).
\]

The active-field no-line theorem excludes `d=1`.  If there is no section,
then `C_012(K)` is empty and the genus-one centre has index three.  Since
`D.R=d-1` is a zero-cycle degree on the centre, every hypothetical
nonexceptional section then satisfies

\[
d\equiv1\pmod3.
\]

Thus the first independent class after the line gate is `d=4`.

## The honest degree-four coefficient scheme

Write

\[
A_i=\sum_{j=0}^4A_{ij}s^{4-j}t^j,
\qquad
r=\sum_{j=0}^3r_js^{3-j}t^j.
\]

The raw locus is cut out by 13 cubics in `P18_K`.  The genuine section locus
is the complement of the projected incidence

\[
\exists[s:t]\quad A_0=A_1=A_2=r=0.
\]

Saturation is essential.  Multiplying any lower-degree solution by a common
binary form gives a false degree-four solution.  For lower degree `e=0,1,2,3`,
the resulting boundary has expected dimension

\[
(e+1)+(4-e)=5,
\]

the same as the naive 13-cubic intersection.  A raw Groebner dimension or a
point before saturation therefore proves nothing about a degree-four
section.

## Two-prime reconnaissance

The exact Reynolds frame was reduced at `p=23` and `p=67`.  In each split
fibre a deterministic involution line gives a degree-one section.  Multiplying
it by the squarefree binary cubic `[1,0,1,1]` gives a raw degree-four boundary
point.  The checks give:

```text
prime   usable involution lines   d4 Jacobian rank / 13
23      53                         7
67      51                         7
```

Both tuples satisfy all 13 equations, but both have a common cubic factor and
are outside the section open.  The rank-seven boundary explains why the raw
scheme has large singular deformation directions.  Finite-field points are
not descent evidence: the two centre cubics themselves have finite-field
points, and the torsor is split at the witnesses.

Fibrewise third intersection of two distinct installed line sections also
gives a genuine gcd-free `d=4` point at each prime.  Both points have Jacobian
rank 13 for the 13 equations, hence lie on a smooth projective local branch of
dimension five:

```text
prime   gcd degree   Jacobian rank / 13   local projective dimension
23      0            13                   5
67      0            13                   5
```

This verifies that the saturated geometric section locus has at least one
smooth point, and hence a smooth local five-dimensional branch, in each split
reduction.  It does not prove that an entire component is smooth.  It also
does not give a rational point of the twisted `K`-locus or an invariant
characteristic-zero branch.

A square sliced `msolve` run on the `p=23` boundary was interrupted after
more than 180 seconds without a result; the `p=67` solve was not run.  This
is not an emptiness, component, or existence certificate.

## Exact direct pair-secant audit

At the sealed `p=23` link witness, all 1,485 unordered pairs of the 55
installed specialized line sections were reconstructed.  Fibrewise third
intersection was checked in both the cubic and graph equations over
`F_23`.  The pair orbits for the specialized 660-action have sizes

```text
165,330,165,330,165,330.
```

The first orbit consists of 55 line triangles and folds three-to-one back to
the known specialized line orbit.  Every other specialized orbit stays
nontrivial and contains gcd-free `H`-degree-four section representatives over
`F_23`; no singleton residual occurs at this witness.

No characteristic-zero residual family, specialization-injectivity map, or
descent datum is certified here.  Thus this census is exact finite-field
evidence, but it does not prove failure of `K`-descent for the generic direct
pair construction, exclude an unrelated section, or compute the saturated
degree-four scheme over `K`.

## Verdict

No exceptional point, invariant degree-one line, or exact `K`-coefficient
point of the saturated degree-four scheme was found.  A bounded search cannot
exclude higher classes `d=7,10,...`.  The smallest explicit unresolved
section object is the `K`-rational locus of the saturated `d=4` scheme in
`SECTION_CLASSES.json`; the all-degree section question remains open.
