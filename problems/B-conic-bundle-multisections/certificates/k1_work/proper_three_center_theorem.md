# Exclusion of three proper essential centers in class `(1,1)`

## Statement

Work over an algebraically closed field of characteristic zero.  For a general

\[
 [A]\in\mathbf P H^0(\mathbf P^2_x\times\mathbf P^2_y,
 \mathcal O(2,3))=\mathbf P^{59},
\]

there is no rank-two or rank-three linear triple \(\sigma\) for which

\[
 B_{A,\sigma}=\sigma^t\operatorname{adj}(A)\sigma
\]

has multiplicity at least four at three distinct noncollinear proper points of
\(\mathbf P^2_y\).

Consequently, the part of the square-free three-`t=2` row in
`certificates/k1_frontier.md` in which all three essential centers are proper
is absent for a general `A`.  At proper centers the two cluster-system
vanishings in that row are equivalent to noncollinearity: no line passes
through the three points, and a nonzero conic having a double point at all
three exists only when it is the doubled line through three collinear points.

Multiplicity five only imposes stronger conditions, so it is included.  The
theorem does not address rows with an infinitely-near essential center.
Rank-one triples reduce to a class `(1,0)` horizontal component and are
excluded as rational multisections by the certified `k=0` theorem.

All local spaces below are affine vector spaces.  Since every condition is a
homogeneous cone, affine and projective codimensions agree.

## 1. Two exact edge lemmas

Use homogeneous coordinates `[s:t]` on a line.

### 1.1 The `(5,4,3)` edge

Put

\[
 V_{543}=H^0(O(5))\oplus H^0(O(4))\oplus H^0(O(3))
\]

and write \(q=(a,b,c)\), \(\det q=ac-b^2\).  Then

\[
 \dim\{q:\det q\in k\,s^4t^4\}\le7.
 \tag{1.1}
\]

Here the scalar is allowed to be zero.  We prove the bound including all
multiple-root and zero-entry strata.

First fix a nonzero scalar multiple \(f\) of \(s^4t^4\).  If \(a\ne0\), let
`m_0,m_infinity` be the multiplicities of `a` at the two endpoints and put
`d=m_0+m_infinity`.  The corresponding affine stratum of quintics `a` has
dimension `6-d`.  Divisibility

\[
 a\mid b^2+f
 \tag{1.2}
\]

determines `c`.  Restriction

\[
 H^0(O(4))\longrightarrow H^0(O_{Z(a)}(4))
\]

is an isomorphism.  Away from the two endpoints a square root of the unit
`-f` in each Artin local factor is a finite choice.  At an endpoint, in
`k[x]/(x^m)`, the solution scheme of

\[
 z^2=x^k\pmod{x^m}
\]

for even `k` has dimension

\[
 \delta(m,k)=\min(\lfloor m/2\rfloor,k/2).
 \tag{1.3}
\]

Indeed, if `k>=m` this says `ord(z)>=ceil(m/2)`; if `k<m`, the unit part of
`z/x^(k/2)` is fixed up to finitely many choices and its last `k/2`
coefficients are free.  Therefore every fixed-nonzero-`f` stratum has
dimension at most

\[
 6-d+\delta(m_0,4)+\delta(m_\infty,4)\le6.
\]

If `a=0`, then `b` is one of the two square roots of `-f` and `c` is arbitrary,
giving dimension four.

For `f=0`, the UFD classification of `ac=b^2` gives, when all entries are
nonzero,

\[
 (a,b,c)=h(u^2,uv,v^2).
\]

The degree types are

\[
 (\deg h,\deg u,\deg v)=(1,2,1)\quad\text{or}\quad(3,1,0),
\]

and each parameter space has affine dimension six after the common rescaling
is removed.  The boundary components `(a,0,0)` and `(0,0,c)` have dimensions
six and four.  Thus the zero fiber also has dimension at most six.  Allowing
the scalar multiplying \(s^4t^4\) adds one parameter to the nonzero fibers and
proves (1.1).

### 1.2 The `(3,3,3)` edge through the rank-two base point

Put \(V_{333}=H^0(O(3))^3\).  Then

\[
 \dim\{q:\det q\in k\,s^2t^4\}\le6,
 \qquad
 \dim\{q:\det q=0\}\le5.
 \tag{1.4}
\]

For fixed nonzero \(f=s^2t^4\), the same argument applies with `deg(a)=3`.
Now restriction of cubics to the length-three scheme `Z(a)` is surjective
with one-dimensional kernel `k a`.  Hence a stratum with endpoint
multiplicities `m_0,m_infinity` has dimension at most

\[
 (4-d)+1+\delta(m_0,2)+\delta(m_\infty,4)\le5.
\]

The case `a=0` has dimension four.  In the zero fiber, the two UFD degree
types are `(deg h,deg u,deg v)=(1,1,1)` and `(3,0,0)`, both of affine
dimension five; the one-entry boundaries have dimension four.  This proves
(1.4).  Notice that the affine determinant-zero dimension is five, not four.

The finite arithmetic behind (1.1)--(1.4) is checked in
`proper_three_center_local_checks.py`.

## 2. Rank three: restriction to the triangle

Fix the canonical rank-three triple

\[
 H_\sigma=x_0y_0+x_1y_1+x_2y_2.
\]

As in the previous class-`(1,1)` exclusions, put

\[
 E=\Omega^1_{\mathbf P^2}(1),\qquad
 \mathcal Q=\operatorname{Sym}^2(E^\vee)\otimes O(3),\qquad
 W=H^0(\mathcal Q),
\]

so `dim W=42` and \(B=\det q\).  Let `p_1,p_2,p_3` be the three noncollinear
points and let

\[
 T=L_{12}\cup L_{23}\cup L_{31}
\]

be their triangle.  The resolution

\[
 0\longrightarrow O(-1)^3\longrightarrow O^6
 \longrightarrow\mathcal Q(-3)\longrightarrow0
\]

gives \(H^1(\mathcal Q(-3))=0\) and \(h^0(\mathcal Q(-3))=6\).  Therefore

\[
 W\longrightarrow H^0(T,\mathcal Q|_T)
 \tag{2.1}
\]

is surjective and its target has dimension 36.

On each edge,

\[
 \mathcal Q|_{L_{ij}}\simeq O(5)\oplus O(4)\oplus O(3).
\]

If `B` has multiplicity at least four at both endpoints, then its degree-eight
restriction to that edge is a scalar multiple of \(s^4t^4\); the zero
restriction, corresponding to an edge component of `B`, is included.  By
(1.1), the edge form belongs to a locus of dimension at most seven.

Because `T` is reduced, restriction to its normalization injects

\[
 H^0(T,\mathcal Q|_T)\hookrightarrow
 \bigoplus_{ij}H^0(L_{ij},\mathcal Q|_{L_{ij}}).
\]

The matching conditions at the three vertices can only decrease dimension.
Thus the bad locus in the 36-dimensional target of (2.1) has dimension at
most `3*7=21`, hence codimension at least 15.  Ordered noncollinear triples
move in dimension six, so for fixed rank-three `sigma` the locus with some
such triple has codimension at least

\[
 15-6=9.
\]

The projective rank-three orbit has dimension eight.  Its sweep therefore
cannot dominate the coefficient space of `A`.

## 3. Rank two: preparation on the blowup

Fix

\[
 H_\sigma=x_0y_0+x_1y_1,
 \qquad b=[0:0:1].
\]

Let \(Z=\operatorname{Bl}_b\mathbf P^2\), with `H` the pullback of a line,
`E_b` the exceptional curve, and `R=H-E_b`.  Removing the common exceptional
factor from `sigma` gives

\[
 K=O_Z\oplus O_Z(-R)
\]

and identifies the 42-dimensional restricted coefficient space with

\[
 W_2=H^0\!\left(Z,\operatorname{Sym}^2K^\vee\otimes O(3H)\right)
 =H^0(O(5H-2E_b))\oplus H^0(O(4H-E_b))\oplus H^0(O(3H)).
 \tag{3.1}
\]

Moreover \(\pi^*B=E_b^2\det(q)\).  There are three exhaustive positions of
`b` relative to a noncollinear triangle `T`.

## 4. Rank two: `b` is outside the triangle

Here `b` lies on none of the three edges.  Restriction to `T` is surjective
onto a 36-dimensional target: equivalently, on
`Y_sigma` use

\[
 0\longrightarrow O_Y(2,0)\longrightarrow O_Y(2,3)
 \longrightarrow O_{Y|T}(2,3)\longrightarrow0
\]

and \(H^1(O_Y(2,0))=0\).  Every edge has the `(5,4,3)` pattern, so the bad
target has dimension at most 21 and codimension at least 15.  This open
stratum of triples has dimension six.  The fixed-`sigma` codimension is at
least nine, greater than the rank-two orbit dimension seven.

## 5. Rank two: `b` lies on one edge away from its vertices

Suppose `b` lies on `L_12` but is distinct from the three centers.  The strict
triangle has class `3H-E_b`.  Restricting (3.1) is surjective onto a
33-dimensional target, because after subtracting the strict triangle the
three component bundles are

\[
 O(2H-E_b),\qquad O(H),\qquad O(E_b),
\]

all with vanishing `H^1`.

On the strict transform of `L_12`, the kernel dual has degree zero, so the
quadratic form has the `(3,3,3)` pattern.  The original branch restriction
already contains the forced square of the basepoint factor.  The two endpoint
multiplicities contribute another four zeros at each endpoint; since the
original restriction has degree eight, it must be identically zero.  After
the basepoint factor is removed this is exactly \(\det(q|_{L_{12}})=0\), whose
locus has dimension at most five by (1.4).  The other two edges contribute at
most seven dimensions each.  Hence the bad target has dimension at most

\[
 5+7+7=19,
\]

and codimension at least `33-19=14`.

Triples for which a specified edge contains `b` have dimension five: choose a
line through `b`, two points on it, and a third point off it.  After this
five-dimensional movement, the fixed-`sigma` codimension remains at least
nine, again greater than seven.

## 6. Rank two: `b` is a vertex

Suppose `p_1=b`.  The strict triangle has class `3H-2E_b`.  Its full
normalization/gluing target has dimension 33, but restriction of (3.1) has
rank only 32.  Indeed, after subtracting the strict triangle the component
bundles are

\[
 O(2H),\qquad O(H+E_b),\qquad O(2E_b).
\]

Their `h^0` values are `6,3,1`; the first two have zero `H^1`, while
\(h^1(O(2E_b))=1\).  Thus the kernel has dimension ten and the cokernel has
dimension one, giving image rank 32.  This is the same compatibility defect
that appears for a cubic singular at the rank-two base point.

On each of the two edges through `b`, removing the forced basepoint square
leaves a `(3,3,3)` determinant of degree six.  Multiplicity at least four at
`b` requires two further zeros there, and the other endpoint supplies four;
therefore the determinant is a scalar multiple of \(s^2t^4\).  Each such
edge locus has dimension at most six by (1.4).  The third edge has a
`(5,4,3)` locus of dimension at most seven.  Hence the product bound is

\[
 6+6+7=19.
\]

Intersecting with the rank-32 actual restriction image cannot increase this
dimension.  The fixed-triangle codimension in `W_2` is therefore at least
`32-19=13`.  With `b` fixed as one vertex, the other two noncollinear vertices
move in dimension four.  The fixed-`sigma` codimension is at least nine,
strictly greater than the rank-two orbit dimension seven.

## 7. Incidence conclusion

For a fixed rank-three triple, the union over all allowed proper center
triples has codimension at least nine in `W`; adding the eight-dimensional
rank orbit still leaves positive codimension.  In every rank-two position the
fixed-triple union likewise has codimension at least nine; adding the
seven-dimensional rank orbit leaves positive codimension.  Pullback along the
surjective 60-to-42-dimensional restriction map preserves these
codimensions.  Therefore neither rank orbit sweeps a dominant incidence in
\(\mathbf P_A^{59}\), proving the statement.

