# Exclusion of integral cubic factors in class `(1,1)`

## Statement

Work over an algebraically closed field of characteristic zero.  Let

\[
 B_{A,\sigma}=\sigma^t\operatorname{adj}(A)\sigma,
 \qquad
 A\in H^0(\mathbf P^2_x\times\mathbf P^2_y,\mathcal O(2,3)).
\]

For a general projective class \([A]\), there is no rank-two or rank-three
linear triple \(\sigma\) for which \(B_{A,\sigma}\) has an integral cubic divisor.
In particular it cannot have the square of an irreducible cubic as a factor.
Rank-one triples reduce to a class `(1,0)` horizontal component and are already
excluded as rational multisections by the certified `k=0` theorem.

This is stronger than the exclusion needed for the `e=3` row of
`certificates/k1_frontier.md`: only `D | B` is imposed below, not `D^2 | B`.

All dimensions in the proof are affine-vector-space dimensions.  The loci are
homogeneous cones, so the codimensions are unchanged after projectivizing.

## 1. Rank orbits and the restricted coefficient space

The projective rank-three and rank-two orbits of the `3 x 3` coefficient
matrix of `sigma` have dimensions eight and seven.  For either fixed canonical
triple, restriction to

\[
 Y_\sigma=\{\sigma(y)\mathbin\cdot x=0\}
\]

is a surjection

\[
 H^0(\mathcal O(2,3))\longrightarrow
 W_\sigma:=H^0(Y_\sigma,\mathcal O_{Y_\sigma}(2,3))
\]

with 18-dimensional kernel and \(\dim W_\sigma=42\).  Thus a codimension
computed in \(W_\sigma\) pulls back unchanged to the 60-dimensional space of
\(A\)'s.

## 2. A rank-one quadratic-form lemma

Let \(T\) be either a smooth elliptic curve or \(\mathbf P^1\).  Let \(F\) be a globally
generated rank-two bundle of degree `f`, let \(N\) be a line bundle of degree
nine, and put

\[
 V(F,N)=H^0(T,\operatorname{Sym}^2F\otimes N).
\]

Every nonzero `q` with identically zero determinant belongs to

\[
 H^0(T,M^2\otimes N)
 \subset V(F,N)
 \tag{2.1}
\]

for some saturated line subbundle \(M\subset F\).  Indeed, the generic rank-one
tensor determines a line in the generic fiber of `F`; saturating it gives
\(M\), and the locally split inclusion \(M\subset F\) shows that the regular
tensor lies in the subbundle \(M^2\otimes N\).  The zero tensor is harmless.

For fixed `m=deg M`, the scheme of saturated inclusions has local dimension at
most

\[
 h^0((F/M)\otimes M^{-1}),
 \tag{2.2}
\]

the dimension of its Quot-scheme tangent space.  The tensors over it have
dimension at most \(h^0(M^2\otimes N)\).  Only finitely many `m` occur: a
nonzero section in (2.1) bounds `m` below, while `F/M` is a globally generated
line bundle and hence `m <= f`.

On an elliptic curve, for a line bundle of positive degree `d`, `h^0=d`.
Consequently:

* if `f=3`, (2.2) plus the tensor dimension is at most 15;
* if `f=2`, it is at most 13.

For completeness, if `f=3`, then for `m <= 1` the sum is
`(3-2m)+(2m+9)=12`, while `m=2,3` give 13 and 15.  If `f=2`, then `m <= 0`
gives 11, `m=1` gives at most 12 (including the possible degree-zero Hom),
and `m=2` gives 13.

On \(\mathbf P^1\), write \(F=O(a)\oplus O(f-a)\) with both summands
nonnegative.  For a
saturated `M=O(m)`, the same sum is bounded by

\[
 \max(f-2m+1,0)+\max(2m+10,0).
\]

Using `m <= f` gives the bounds

\[
 \dim\{\det q=0\}\le
 \begin{cases}
 16,&f=3,\\
 14,&f=2,\\
 12,&f=1.
 \end{cases}
 \tag{2.3}
\]

These are dimensions of affine cones and include all degree types of the
saturated line, all boundary tensors with zeros, and `q=0`.

## 3. Rank three

Normalize `sigma` to

\[
 x_0y_0+x_1y_1+x_2y_2.
\]

Put \(E=\Omega^1_{\mathbf P^2}(1)\), \(F=E^\vee\), and

\[
 \mathcal Q=\operatorname{Sym}^2F\otimes\mathcal O(3).
\]

Then \(W=H^0(\mathcal Q)\) and \(B=\det q\).  If `D` is an integral plane cubic,
the resolution

\[
 0\longrightarrow O(-1)^3\longrightarrow O^6
 \longrightarrow \mathcal Q(-3)\longrightarrow0
\]

shows that \(H^1(\mathcal Q(-3))=0\) and \(h^0(\mathcal Q(-3))=6\).  Hence

\[
 W\longrightarrow H^0(D,\mathcal Q|_D)
 \tag{3.1}
\]

is surjective and the target has dimension `42-6=36`.

If `D` is smooth, it is elliptic, `F|_D` is globally generated of degree
three, and `N=O_D(3)` has degree nine.  Section 2 bounds the determinant-zero
locus in the 36-dimensional target by 15.  Thus, for fixed smooth `D`, the
condition `D | B` has codimension at least 21.  Smooth cubics move in a
nine-dimensional projective space, leaving codimension at least

\[
 21-9=12
 \tag{3.2}
\]

for the fixed rank-three `sigma`.

If `D` is singular and integral, its normalization is \(\mathbf P^1\) and its unique
singularity is a node or cusp with delta invariant one.  Pullback of the
locally free sheaf \(\mathcal Q|_D\) gives an injection

\[
 H^0(D,\mathcal Q|_D)\hookrightarrow
 H^0(\mathbf P^1,\operatorname{Sym}^2\nu^*F\otimes\nu^*N).
 \tag{3.3}
\]

Here \(\nu^*F\) is globally generated of degree three, hence splits with
nonnegative summand degrees adding to three.  By (2.3), the rank-one locus in
the normalization target has dimension at most 16.  Intersecting it with the
actual 36-dimensional image in (3.3) cannot increase that dimension.  The
fixed-`D` codimension is therefore at least 20.  Integral singular cubics form
an eight-dimensional discriminant locus, again leaving

\[
 20-8=12.
 \tag{3.4}
\]

This treats both nodal and cuspidal cubics; no gluing assumption on the two
branches of a node is being made.  The gluing/conductor conditions define the
actual subspace in (3.3), and using the larger normalization rank-one locus is
an upper bound.

## 4. Rank two away from the base point

Normalize

\[
 H_\sigma=x_0y_0+x_1y_1,
 \qquad b=[0:0:1].
\]

If \(b\notin D\), the two restricted coordinate sections form a basepoint-free
pencil in `H^0(O_D(1))`.  The kernel of

\[
 O_D^3\longrightarrow O_D(1)
\]

is \(O_D\oplus O_D(-1)\), so its dual \(F\) is globally generated of degree three.
Restriction to the cubic is surjective: on `Y=Y_sigma`,

\[
 0\longrightarrow O_Y(2,0)\longrightarrow O_Y(2,3)
 \longrightarrow O_{Y|D}(2,3)\longrightarrow0,
\]

and the ambient sequence

\[
 0\longrightarrow O(1,-1)\longrightarrow O(2,0)
 \longrightarrow O_Y(2,0)\longrightarrow0
\]

gives `H^1(O_Y(2,0))=0` and `h^0(O_Y(2,0))=6`.  Thus the target again has
dimension 36.  The smooth and singular arguments of Section 3 apply verbatim:
after moving `D`, both leave fixed-`sigma` codimension at least 12.

## 5. Rank two: the cubic contains the base point

Let \(Z=\operatorname{Bl}_b\mathbf P^2\), with \(H\) the pullback of a line and \(E\) the exceptional
curve, and set `R=H-E`.  After dividing the pulled-back triple by its common
exceptional factor, one obtains a basepoint-free quotient

\[
 O_Z^3\longrightarrow O_Z(R),
 \qquad K=O_Z\mathbin\oplus O_Z(-R).
\]

The induced quadratic forms form the complete 42-dimensional space

\[
 H^0(Z,\operatorname{Sym}^2K^\vee\otimes O(3H))
 =H^0(O(5H-2E))\oplus H^0(O(4H-E))\oplus H^0(O(3H)),
 \tag{5.1}
\]

of dimensions `18+14+10`.  The map from `W` to (5.1) is an isomorphism.
Indeed, a section in its kernel vanishes on the dense strict transform of the
irreducible divisor \(Y_\sigma\), so before passing to `W` it is a multiple of
\(H_\sigma\); both sides then have dimension 42.  Moreover

\[
 \pi^*B=E^2\det(q).
 \tag{5.2}
\]

Thus `D | B` implies that the strict transform of `D` divides `det(q)`.

### 5.1 The cubic is smooth at `b`

Here \(\widetilde D=3H-E\).  Its restriction of \(K^\vee\) is globally generated of
degree two.  The three entries of \(q|_{\widetilde D}\) have line-bundle degrees
13, 11, and 9, so the target has dimension 33 when `D` is smooth elliptic.
The restriction of (5.1) is surjective because after subtracting \(\widetilde D\)
the three component bundles are

\[
 O(2H-E),\qquad O(H),\qquad O(E),
\]

and all have vanishing `H^1`.  The elliptic rank-one locus has dimension at
most 13.  Fixed-`D` codimension is at least `33-13=20`; cubics through the
fixed point `b` move in dimension eight, leaving codimension 12.

If the cubic is singular away from `b`, its strict transform remains an
integral arithmetic-genus-one curve and its normalization is \(\mathbf P^1\).
Restriction is still surjective onto the 33-dimensional actual target.  The
normalization pullback of \(K^\vee\) is globally generated of degree two, so
(2.3) bounds the normalization rank-one locus by 14.  Cubics containing `b`
and singular elsewhere form a seven-dimensional family.  Hence the remaining
codimension is at least

\[
 (33-14)-7=12.
 \tag{5.3}
\]

As in (3.3), the actual nodal or cuspidal conductor conditions only cut down
the normalization locus.

### 5.2 The cubic is singular at `b`

Every integral plane cubic singular at `b` has multiplicity two there and is
nodal or cuspidal.  One blowup gives its smooth normalization as the strict
transform

\[
 \widetilde D=3H-2E\simeq \mathbf P^1.
\]

Now \(\deg(K^\vee|_{\widetilde D})=1\), and the full normalization target has dimension
33, with entry degrees 11, 10, and 9.  It is important that (5.1) does **not**
surject onto all 33 coefficients.  After subtracting \(\widetilde D\), its three
components are

\[
 O(2H),\qquad O(H+E),\qquad O(2E).
\]

Their spaces of sections have dimensions `6,3,1`; the first two have zero
`H^1`, while

\[
 h^1(O(2E))=1.
\]

Consequently the restriction has kernel dimension ten, rank 32, and
one-dimensional cokernel.  This is the precise normalization compatibility
condition.  It lies in the shortest entry, the restriction of the plane cubic
coefficient `A_22`.  It is present for both a node and a cusp.

The rank-one locus in the full 33-dimensional normalization target has
dimension at most 12 by (2.3).  Its intersection with the actual rank-32 image
has dimension no larger than 12, so fixed-`D` codimension in `W` is at least

\[
 32-12=20.
\]

Cubics singular at the specified point `b` form a six-dimensional projective
family: vanishing of the value and two independent first derivatives gives
three independent linear conditions in `P^9`.  The fixed-`sigma` codimension
after `D` moves is therefore at least 14.

The node/cusp distinction introduces no omitted component.  On normalization,
standard parametrizations are

\[
 [s:t]\mapsto[s^2t:st^2:s^3+t^3]
 \quad\text{(node)},
 \qquad
 [s:t]\mapsto[s^2t:s^3:t^3]
 \quad\text{(cusp)}.
\]

The common divisors of `(y_0,y_1)` have degree two (`st` and `s^2`), and after
removing them the residual pair has degree one and is basepoint free.  The
exact restriction ranks for both parametrizations are checked in
`cubic_factor_local_checks.py`.

## 6. Incidence conclusion and exhaustive coverage

For fixed rank-three `sigma`, every family of integral cubics leaves
codimension at least 12 in `W`; adding the eight-dimensional rank-three orbit
still leaves codimension at least four in the coefficient space of `A`.
For fixed rank-two `sigma`, every family leaves codimension at least 12 (and
the singular-at-`b` family leaves 14); adding the seven-dimensional orbit
still leaves positive codimension.

The cubic list is exhaustive.  Over an algebraically closed field of
characteristic zero, an integral plane cubic is either smooth elliptic or has
one delta-one node or cusp.  Relative to the rank-two base point it either
avoids `b`, contains `b` as a smooth point (with or without its unique
singularity elsewhere), or is singular at `b`.  Sections 4, 5.1, and 5.2
treat these mutually exclusive cases.  Therefore the associated universal
incidence cannot dominate \(\mathbf P_A^{59}\), proving the statement.
