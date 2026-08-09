# The canonical `(1,3)` quartic component is the Klein cubic

Date: 2026-08-08

## 1. Outcome

Let

\[
 f:A\longrightarrow \bigwedge^2U^*,\qquad \dim A=5,\quad \dim U=6,
\]

be the regular Pfaffian net for the Klein cubic.  Write

\[
 Y=\{\operatorname{Pf}(f(a))=0\}\subset\mathbf P(A),
 \qquad
 X=\mathbf P(f(A)^\perp)\cap\operatorname{Gr}(2,U)
\]

for the Klein cubic and its orthogonal genus-eight `V14`.  Let
`Q subset P(U)` be their common Palatini quartic and let `Gamma=Sing(Q)`.

There is a natural open moduli space `H_(1,3)^good(X)` of geometrically
integral Pluecker quartics `D subset X` such that

* the normalization is `P1`;
* the pulled-back tautological bundle is

  \[
  \mathcal O(-1)\oplus\mathcal O(-3);
  \]

* the line defined by the unique maximal subline `O(-1)` is disjoint from
  `Gamma`.

The main result of this packet is the equivariant isomorphism

\[
 \boxed{H_{(1,3)}^{\mathrm{good}}(X)\simeq Y^\circ,}
\]

where `Y^circ` is the complement of the ruled surface of jumping `B`-lines.
Under this isomorphism a point `y` is sent to the quartic obtained from its
kernel line

\[
 n_y=\mathbf P(\ker f(y))\subset Q.
\]

The kernel-line morphism is a closed embedding

\[
 h:Y\hookrightarrow F_1(Q).
\]

Its image is an irreducible component: a good kernel line has trivial normal
bundle in `Q`, hence the line scheme is smooth of dimension three there, while
`h(Y)` also has dimension three.  The closure of the good quartic locus in
that component is therefore literally `h(Y)\simeq Y`.  This argument uses the
regular-net small resolution and applies to the special Klein net; it does not
specialize a generic-component theorem.  Thus the quartic arithmetic is not a
new space on which to find an obstruction: it is the Klein cubic again.

After twisting by the genuine generic `G=PSL_2(F_11)` torsor `T/K`, this gives

\[
 \boxed{H_{(1,3),T}^{\mathrm{good}}(X_T)(K)\ne\varnothing
 \quad\Longleftrightarrow\quad
 Y_T(K)\ne\varnothing.}
\]

This is an exact circularity theorem, not a proof that either side is empty.

## 2. The two small resolutions and the degree relation

Let `E` be the theta bundle on `Y` and `U_X` the tautological bundle on `X`.
Kuznetsov's two small resolutions are

\[
 \mathbf P_Y(E^\vee)\xrightarrow{\psi}Q
 \xleftarrow{\phi}\mathbf P_X(U_X).
\]

They are isomorphisms away from their ruled exceptional surfaces over
`Gamma`, and their birational transform is the Pfaffian--Grassmannian flop.

On their common isomorphism locus put

\[
 e=c_1(\psi^*\mathcal O_Q(1))=c_1(\phi^*\mathcal O_Q(1)),
 \quad
 x=p_X^*H_X,
 \quad
 y=p_Y^*H_Y.
\]

The line-bundle transform in Kuznetsov's Proposition 3.23 is

\[
 \boxed{y=4e-x.}
\]

Consequently, if `L subset Q` is a line disjoint from `Gamma`, and its two
lifts project to curves of degrees `d_X` and `d_Y`, then

\[
 \boxed{d_X+d_Y=4.}
\]

Both degrees are nonnegative.  This is the key finite bound: lines of `Q` can
produce only degrees `0,1,2,3,4` on `X`.

## 3. From an unbalanced quartic to a kernel line

Let

\[
 g:\mathbf P^1\longrightarrow X
\]

be a good integral quartic with

\[
 g^*U_X\simeq\mathcal O(-1)\oplus\mathcal O(-3).
\]

The maximal-degree line subbundle is unique.  Composing it with
`g^*U_X subset U tensor O` gives

\[
 \mathcal O(-1)\hookrightarrow U\otimes\mathcal O.
\]

Its projectivization is a line `L subset P(U)`.  It cannot be constant: a
one-dimensional subspace of `H^0(O(1))` has a base point, whereas the displayed
map is a subbundle.  Since every point of `L` lies in the two-plane represented
by `g(t)`, one has `L subset Q`.

The lift of `L` to `P_X(U_X)` is the section defined by `O(-1)`.  Its
`x`-degree is the Pluecker degree of `g`, namely four, and its `e`-degree is
one.  The relation of Section 2 therefore gives

\[
 d_Y=4-d_X=0.
\]

Since `H_Y` is ample, the projection of the other lift to `Y` is constant.
Call its value `y`.  The line `L` is then the fibre

\[
 \mathbf P(E_y^\vee)=\mathbf P(\ker f(y))=n_y.
\]

This recovers `y` uniquely from the quartic.

Conversely, for `y` whose kernel line misses `Gamma`, the flop sends `n_y` to
a section over a geometrically integral quartic in `X`.  The already audited
kernel calculation gives tautological splitting `(1,3)`.  These constructions
are inverse in families, proving

\[
 H_{(1,3)}^{\mathrm{good}}(X)\simeq Y^\circ.
\]

The construction is canonical for the Pfaffian net and hence equivariant.

## 4. What the bounded parameter scheme actually contains

This section records the precise finite CAS model and corrects a tempting
but false saturation target.

On the Grassmann chart write a line as

\[
 \ell(s,t)=sa+tb,
\]

with

\[
 a=e_0+\sum_{j=2}^5x_je_j,
 \qquad
 b=e_1+\sum_{j=2}^5y_je_j.
\]

Thus there are eight line variables.  Write a cubic companion as

\[
 c(s,t)=\sum_{k=0}^3c_k s^{3-k}t^k,
 \qquad c_k\in U.
\]

The transformation

\[
 c\longmapsto c+q(s,t)\ell(s,t),\qquad q\in H^0(\mathcal O(2)),
\]

does not change the two-plane or its Pluecker coordinates.  The three gauge
conditions

\[
 (c_0)_0=(c_1)_0=(c_3)_1=0
\]

leave exactly 21 companion variables.  Expanding

\[
 f(a_i)(\ell(s,t),c(s,t))=0,
 \qquad i=0,\ldots,4,
\]

in the five binary-quartic coefficients gives a `25 x 21` matrix `B(x,y)`.

Suppose the line lifts to a degree-`d` curve on `X`.  Its pulled-back
tautological bundle fits into

\[
 0\longrightarrow\mathcal O(-1)
 \longrightarrow F_L
 \longrightarrow\mathcal O(1-d)\longrightarrow0.
\]

After quotienting the three-dimensional gauge space, the companion kernel is

\[
 H^0(\mathcal O(4-d)),
\]

of dimension `5-d`.  Therefore

\[
 \boxed{\operatorname{rank}B=16+d.}
\]

In particular:

| `X`-degree | gauge-fixed nullity | rank of `B` |
|---:|---:|---:|
| 0 | 5 | 16 |
| 1 | 4 | 17 |
| 2 | 3 | 18 |
| 3 | 2 | 19 |
| 4 | 1 | 20 |

Thus, on the good basepoint-free open, `rank(B)<=20` imposes only the
Palatini-line condition and does not isolate the canonical quartic component.
For a general Palatini quartic, Flamini--Sernesi describe the five
corresponding components as

\[
 X,\quad D,\quad X',\quad Y',\quad h(Y),
\]

in degrees `0,1,2,3,4`.  These four lower-degree components explain exactly
why the naive rank-at-most-20 target is false in the general model.  The same
degree constructions exist for the Klein net, but neither reducedness nor
completeness of this five-component inventory is asserted for the special
Klein line scheme.

The correct locally closed CAS target is

\[
 \operatorname{rank}B=20,
\]

together with the basepoint-free maximal-minor condition.  By the degree
relation and the mutually inverse geometric constructions of Section 3, that
stratum is exactly `h(Y)` on the good open.  Globally, its closure is the
component `h(Y)` by the regular-net normal-bundle argument in Section 1.

## 5. Exact chartwise elimination and inverse

The checked script `verify_exact.py` consumes the sealed `15 x 5` Pfaffian
intertwiner over `Q(zeta_11)`.  It performs only the following forced finite
operations:

1. construct the five `6 x 6` skew forms;
2. verify that their Pfaffian is a nonzero scalar times

   \[
   y_0^2y_1+y_1^2y_2+y_2^2y_3+y_3^2y_4+y_4^2y_0;
   \]

3. use the analytically chosen point

   \[
   [1:1:1:-2:0]\in Y;
   \]

4. form the single `4 x 6` contraction matrix on its kernel line;
5. check that all complementary maximal minors are quartics, have gcd one,
   satisfy every Pluecker quadric, and satisfy the five linear equations of
   `X`;
6. form the `12 x 5` inverse contraction matrix and verify rank four, so its
   projective kernel is the unique original cubic point;
7. put the kernel line in the eight-variable standard chart and compare the
   localized determinantal equations.

At the chosen point the script proves exactly over `Q(zeta_11)` that

\[
 \operatorname{rank}B=20,
 \qquad
 \operatorname{rank}C=4,
\]

where `C` is the `12 x 5` kernel-line contraction matrix.  A nonzero
`20 x 20` pivot reduces the `126` maximal minors of `B` to the five entries of
one Schur complement.  A nonzero `4 x 4` pivot similarly reduces the kernel
locus to eight Schur-complement entries.  Their exact Jacobians both have rank
five in the eight line variables, and their combined conormal matrix still has
rank five.  The geometric construction gives a universal containment of the
kernel-line locus in the rank-at-most-20 locus.  Hence the two codimension-five
smooth germs agree scheme-theoretically at this point, consistently with the
universal inverse of Section 3.

The independent good reductions

\[
 (p,\zeta_{11})=(23,2),\qquad(67,9)
\]

repeat the ranks and common codimension.  They are regression certificates,
not substitutes for the characteristic-zero proof.

This is an exact *local* rank-exact pivot-chart computation, not a global
Groebner saturation.  The global identification of the rank-exact good stratum
with `h(Y)` comes from Sections 2--3; the computation independently certifies
the expected scheme structure at one characteristic-zero point.  No unbounded
Groebner basis, coefficient-height search, or degree search is used.

## 6. Deformations and the normal bundle

Let `D_y` be a good canonical quartic and let `D_tilde` be its lift to
`P_X(U_X)`.  Under the flop, `D_tilde` is a fibre of the `P1`-bundle over `Y`.
Therefore

\[
 N_{\widetilde D/\mathbf P_X(U_X)}\simeq\mathcal O^{\oplus3}.
\]

The relative tangent line of `P_X(U_X) -> X` along this section is

\[
 \operatorname{Hom}(\mathcal O(-1),\mathcal O(-3))
 \simeq\mathcal O(-2).
\]

Consequently

\[
 \boxed{
 0\longrightarrow\mathcal O(-2)
 \longrightarrow\mathcal O^{\oplus3}
 \longrightarrow N_{D_y/X}
 \longrightarrow0.}
\]

It follows immediately that

\[
 h^0(N_{D_y/X})=4,
 \qquad
 h^1(N_{D_y/X})=0.
\]

Thus the quartic Hilbert scheme is smooth of dimension four at every such
curve, whereas the canonical family has dimension three.  The tangent quotient
is

\[
 H^1(\mathcal O(-2))\simeq K.
\]

At the exact point used in Section 5, the injection `O(-2)->O^3` is the
complete three-dimensional system of binary quadrics.  Hence

\[
 \boxed{N_{D_y/X}\simeq\mathcal O(1)\oplus\mathcal O(1)}
\]

there, and therefore at a general canonical quartic.

Locally the canonical family is the Maroni divisor where the pulled-back
tautological bundle jumps from the balanced type `(2,2)` to `(1,3)`.  Indeed,
after twisting by `O(1)`, the `(1,3)` fibre is

\[
 \mathcal O\oplus\mathcal O(-2),
\]

with one-dimensional `H0` and `H1`; the determinant-of-cohomology section cuts
the jump in one equation.  The one transverse Hilbert direction is precisely
the class in `H1(O(-2))`.

## 7. Compactification and arithmetic boundary

The kernel-line morphism

\[
 h:Y\longrightarrow F_1(Q)
\]

is a closed embedding and its image is an irreducible component.  The
Pluecker coordinates are the `4 x 4` Pfaffian cofactors of the `6 x 6` skew
matrix, hence are quadratic in `y`.  Therefore

\[
 h^*\mathcal O_{\operatorname{Gr}(2,U)}(1)
 \simeq\mathcal O_Y(2)=-K_Y,
\]

and the component has Pluecker degree

\[
 (2H_Y)^3=8\cdot3=24.
\]

The boundary of the good locus is

\[
 R_Y=p_Y(\psi^{-1}(\Gamma)),
\]

the ruled surface swept out by the jumping `B`-lines of the theta bundle.
It is exactly where the kernel line meets the exceptional curve `Gamma` and
the fibrewise flop ceases to give a smooth integral quartic without a boundary
modification.

All of these objects are canonical and equivariant, so twisting commutes with
the moduli isomorphism and gives

\[
 H_{(1,3),T}^{\mathrm{good}}(X_T)\simeq
 Y_T\setminus R_{Y,T}.
\]

The compactification is `Y_T` itself and the boundary is `R_{Y,T}`.  This
boundary does not give a separate arithmetic obstruction:

* a `K`-point of the good quartic locus is already a `K`-point of `Y_T`;
* if `Y_T(K)` is nonempty, its ambient Brauer--Severi fourfold has a `K`-point
  and is split; the resulting smooth cubic threefold is `K`-unirational over
  the infinite generic field `K`, so its `K`-points are dense and one can
  choose a point outside `R_{Y,T}`.

Consequently the displayed open-subscheme isomorphism upgrades to the exact
existence equivalence

\[
 H_{(1,3),T}^{\mathrm{good}}(X_T)(K)\ne\varnothing
 \quad\Longleftrightarrow\quad Y_T(K)\ne\varnothing.
\]

Thus no boundary, discriminant, or normal-line invariant of this canonical
quartic compactification can settle the headline unless it already proves
`Y_T(K)=\varnothing`.

## 8. Theorem boundary

Proved here:

* the good `(1,3)` quartic moduli is equivariantly isomorphic to a dense open
  of the Klein cubic;
* its natural compactification as a Palatini-line component is the Klein cubic;
* the exact inverse recovers the cubic point from the distinguished line;
* the naive `rank(B)<=20` locus is too large and contains all degree strata;
* the correct rank-exactly-20 chart agrees with the kernel-line chart;
* the normal sequence is `0 -> O(-2) -> O^3 -> N -> 0`, and generically
  `N=O(1)^2`;
* the only transverse deformation balances `(1,3)` to `(2,2)`;
* twisting introduces no new quartic-moduli obstruction: the problem is
  exactly circular.

Not proved:

* pointlessness of the genuine generic twist `Y_T`;
* nonexistence of its canonical Schur quartic;
* non-`PSL_2(F_11)`-unirationality of the Klein cubic.

Terminal markers:

    SCHUR-QUARTIC-KERNEL-COMPONENT-IS-KLEIN
    SCHUR-QUARTIC-RANK20-CHART-EXACT
    SCHUR-QUARTIC-NORMAL-O1-O1-GENERIC
    HEADLINE-OPEN
