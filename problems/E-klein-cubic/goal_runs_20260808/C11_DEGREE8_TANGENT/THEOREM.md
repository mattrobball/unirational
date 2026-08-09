# The finite `C11` degree-eight tangent-curve incidence

## Setup

Work after splitting the generic degree-11 point supplied by the projective
isogeny.  Normalize coordinates so that

\[
 X=\left\{F=\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}\subset\mathbf P^4,
 \qquad
 T=\operatorname {diag}(\zeta^{w_0},\ldots,\zeta^{w_4}),
\]

with

\[
 (w_0,\ldots,w_4)=(1,9,4,3,5),\qquad 2w_i+w_{i+1}=0\pmod {11}.
\]

Let `p=[p_0:...:p_4]` be a point of the dense torus of `X`, put

\[
 A_i=p_i^2p_{i+1},
\]

and note that every `A_i` is nonzero and `sum A_i=0`.  Its `C11` orbit is the
split form of the degree-11 closed point.

## 1. Complete classification through degree eight

Let `C` be an irreducible `C11`-stable geometrically rational curve through
the orbit of `p`, and suppose `deg C=d<=8`.  The `C11` action on the
normalization `P1` is faithful.  After choosing `[s:t]` and allowing a common
projective character, its normalization map has the form

\[
 f_e([s:t])=
 [p_i s^{d-e_i}t^{e_i}]_{i=0}^4,
 \qquad
 e_i\equiv m w_i+c\pmod {11},
\]

for some `m in F_11^*` and `c in F_11`.  Because `d<11`, each relevant
character space in `H^0(P1,O(d))` contains at most one monomial.  Thus this is
not an ansatz: it is every equivariant parametrization in the stated degree
range.  Passing through `p` fixes the five coefficients, up to reparametrizing
`P1`.

Exact enumeration of the 110 pairs `(m,c)` gives:

- no curve of degree at most six;
- ten oriented normalized exponent vectors of width seven, paired by
  `e -> 7-e` into five degree-seven curves;
- ten oriented normalized exponent vectors of width eight, paired by
  `e -> 8-e` into five degree-eight curves;
- equivalently, 30 raw placements have all exponents in `[0,8]`: 20 are the
  two base-point presentations of the width-seven vectors and 10 have width
  eight.

All normalized vectors have gcd of exponent differences one, so the displayed
maps are birational onto their images.

Representatives for the five degree-eight curves are

```text
m=1: (0,8,3,2,4)
m=2: (0,5,6,4,8)
m=3: (2,4,0,8,3)
m=4: (3,2,4,0,8)
m=5: (4,0,8,3,2).
```

## 2. Exact pullback and empty tangent incidence

For any exponent vector `e` of degree `d`, put

\[
 n_i=2e_i+e_{i+1}.
\]

Then

\[
 f_e^*F=\sum_i A_i s^{3d-n_i}t^{n_i}.
\]

For the canonical degree-eight vector

\[
 e=(0,8,3,2,4),\qquad n=(8,19,8,8,8),
\]

the trace relation `sum A_i=0` gives the exact identity

\[
 \boxed{f_e^*F=A_1s^5t^8(t^{11}-s^{11}).}
\]

Thus the 11 orbit points are simple intersections.  The residual divisor is

\[
 5[s=0]+8[t=0],
\]

of degree 13, not a quadratic divisor.

The same calculation closes all five degree-eight types.  In every case the
five integers `n_i` take exactly two values differing by 11, and one of the
two value classes is a singleton.  After using `sum A_i=0`,

\[
 f_e^*F=\mathord\pm A_j s^a t^b(t^{11}-s^{11}),
 \qquad a+b=13,
\]

for one index `j`.  Since `p` lies in the torus, `A_j` is a unit.  Hence each
orbit point has intersection multiplicity exactly one.  Equivalently, on
each of the five finite charts the tangency ideal contains a coordinate
monomial `A_j`; saturation by `product A_i` is the unit ideal.

Therefore:

```text
There is no C11-equivariant degree-eight rational curve through a dense-torus
C11 orbit that is tangent to X at all 11 orbit points.
```

No unbounded search and no characteristic change enters this conclusion.

For comparison, each degree-seven pullback is a nonzero proper subset sum of
the `A_i` times an orbit factor and an endpoint monomial.  It is generically
not contained in `X`; on the corresponding proper linear divisor in the
trace hyperplane, the whole degree-seven curve is contained in `X`.  This
does not produce the desired double orbit divisor.

## 3. Semilinear `C5` descent

The five unoriented curve types are indexed by

\[
 \mathbf F_{11}^{\!*}/\{\pm1\}.
\]

The semilinear `C5` multiplier (`5` in the Klein-coordinate convention, `9`
in the dual kernel convention) acts transitively on these five types.  Thus
no individual curve in either the degree-seven or degree-eight list is fixed
by the complement.

There is also a coordinate-free reason.  The normalizer of a faithful
`C11` in `PGL_2` induces only the automorphisms `g -> g` and `g -> g^-1`.
An `F55`-stable geometrically rational curve carrying this orbit would require
the complement to induce `g -> g^5` (equivalently `g -> g^9`), which is
impossible.  This argument applies to an `F55`-stable curve already known to
be `C11`-stable.  It does **not** say that every rational curve through the
11 points must be `C11`-stable.

Even a hypothetical split tangent curve would have five `C5` conjugates; its
quadratic residual would norm only to a degree-ten cycle.  It would not give
the descended quadratic cycle required by this positive rescue.

## Scope

This is a theorem-grade emptiness result for the complete finite incidence of
`C11`-stable rational curves of degree at most eight through the degree-11
torus orbit.  It closes that bounded positive/falsification target.  It is not
a pointlessness theorem for the trace cubic, because a `K`-rational curve
through the degree-11 point need not be `C11`-stable after base change.

