# Special-seed stability frontier: the double-residual surface

## What is proved here, and what is not

Let

\[
X=\{F(x,y)=0\}\subset \mathbf P^2_x\times\mathbf P^2_y,
\qquad d\geq 4,
\]

and use the global tangent-residual spaces from
`special_seed_uniform_dualizing_theorem.md`.  Thus

\[
\mathcal I=\{(p,\ell,r):p,r\in\ell\},
\qquad
\mathcal Z_F=\{F_x|_\ell\text{ vanishes on }2p+r\},
\]

and \(g:\mathcal Z_F\to Y=\mathbf P^2_y\) remembers \(p\).

The purpose of this note is to audit the remaining discriminant problem,
especially the diagonal \(p=r\).  It gives an unconditional global
double-residual surface, its canonical and ramification classes, an exact
first-jet rank stratification, and the local surface singularities which
would result from the expected stable models.  It does **not** prove the
required two- and three-jet or two-point transversality for the restricted
family of \((2,d)\)-forms.  Consequently it does not upgrade the uniform
ample-dualizing theorem to an all-special-seeds general-type theorem.

> **Unconditional theorem.**  For a general \(F\), the marked
> double-residual locus
>
> \[
> \mathcal M_F=
> \{(x,p,\ell,r):F_x|_\ell\text{ vanishes on }2p+2r\}
> \tag{0.1}
> \]
>
> is a smooth surface, including along \(p=r\).  Its canonical class is
>
> \[
> \boxed{
> K_{\mathcal M_F}
> =5H+5J+2(d-4)(P+R).}
> \tag{0.2}
> \]
>
> This class is ample on every component.  On every component on which
> \(h:\mathcal M_F\to Y\), \(h(x,p,\ell,r)=p\), is generically finite, its
> ramification line bundle has class
>
> \[
> \boxed{
> \mathcal R_h
> =K_{\mathcal M_F}-h^*K_Y
> =5H+5J+(2d-5)P+2(d-4)R,}
> \tag{0.3}
> \]
>
> and is ample.  Every residual critical point of \(g\) is represented on
> \(\mathcal M_F\), also when \(p=r\).  In a smooth tangent chart the only
> possible excess in \(\operatorname {Ram}(h)\) is the triple-residual-root
> divisor.  For \(d=4\) there is no such excess on this smooth tangent
> chart, so there \(\operatorname {Ram}(h)\) is exactly the residual
> critical locus of \(g\).  Equality after saturated closure through the
> conic and tangent-base boundary is not proved in this note; it is
> subsequently proved in `special_seed_residual_saturation.md` and
> `special_seed_ramification_comparison.md`.

For \(d=4\), the Chow calculation gives

\[
P^2[\mathcal M_F]=32,
\qquad
H^2[\mathcal M_F]=56,
\tag{0.4}
\]

and, writing \(K=K_{\mathcal M_F}\) and denoting the formal ramification
class by \(R_h=K+3P\),

\[
\boxed{
K^2=5400,\quad
K R_h=7740,\quad
R_h^2=10368,\quad
P R_h=876.}
\tag{0.5}
\]

Thus this class has arithmetic genus

\[
\boxed{p_a(R_h)=1+\frac{(K+R_h)R_h}{2}=9055.}
\tag{0.6}
\]

On every generically finite component it is the class of the actual
ramification divisor.  If that divisor is smooth, then each of its
components has genus at least two:
distinct smooth components are disjoint, while ampleness gives both
\(K C>0\) and \(R_hC=C^2>0\), so adjunction gives
\(2g(C)-2=(K+C)C>0\).

> **Current conditional stability consequence.**  The later ramification
> comparison theorem proves that every component of \(\mathcal M_F\)
> dominates \(Y\), that the saturated closure is the smooth actual
> ramification curve, and that its components map generically one-to-one to
> distinct positive-genus discriminant components.  The later boundary-fold
> theorem also proves the ordinary fold/double-cover model and
> \(\gamma\ne0\) at every middle and bottom multiplier-boundary point.  If,
> in addition, the open residual map has only the fold/cusp behavior listed
> below and all isolated multiple values have the ordinary transverse models
> listed there, then every immersive
> rational seed gives a normal surface with only Du Val singularities.  Its
> resolution is therefore of general type by the ample-dualizing formula in
> `special_seed_uniform_dualizing_theorem.md`.

The ramification and generic-image hypotheses are proved in
`special_seed_ramification_comparison.md`, and the boundary fold and mixed
coefficient in
[`special_seed_boundary_fold_theorem.md`](special_seed_boundary_fold_theorem.md);
only the stated
open-residual and isolated-collision hypotheses remain conditional.

## 1. The length-four evaluation bundle

Work on

\[
\mathcal A=\mathbf P^2_x\times\mathcal I.
\]

It is smooth of dimension six, and

\[
K_{\mathcal A}=-3H-2P-J-2R.
\tag{1.1}
\]

On the universal line, \(2p+2r\) is a flat divisor of length four.  This
remains true on the diagonal, where it becomes \(4p\).  Restriction of
\(F\) to this divisor is a section of a rank-four bundle
\(\mathscr E^{(4)}_d\).  A useful filtration has four line-bundle quotients

\[
\begin{aligned}
L_1&=2H+dP,\\
L_2&=2H+(d-2)P+J,\\
L_3&=2H-2P+(d-2)R+2J,\\
L_4&=2H-2P+(d-4)R+3J.
\end{aligned}
\tag{1.2}
\]

Indeed, the two layers at \(p\) contribute

\[
dP,\qquad dP+(J-2P),
\]

where \(J-2P\) is the conormal class of \(p\) in the universal line.  After
division by \(2p\), the first layer at \(r\) has class

\[
dR-2\Delta,
\qquad
\Delta=P+R-J,
\]

and the second adds \(J-2R\).  Tensoring each layer by
\(\mathcal O(2H)\) gives (1.2).  Hence

\[
c_1(\det\mathscr E^{(4)}_d)
=8H+(2d-6)(P+R)+6J.
\tag{1.3}
\]

At every flag, degree-\(d\) forms on a line separate a length-four divisor
for \(d\geq4\), and a quadric can be chosen nonzero at a prescribed \(x\).
The coefficient space therefore generates \(\mathscr E^{(4)}_d\).
Vector-bundle Bertini proves that the zero locus (0.1) of a general section
is smooth of dimension two, including on the diagonal.

Adjunction using (1.1) and (1.3) proves (0.2).  The map which remembers
\((x,\ell)\) is finite on \(\mathcal M_F\): a nonzero binary form has only
finitely many ordered pairs of double roots, and a general \(F\) has no
line component in any \(C_x\).  Thus \(H+J\) is ample on
\(\mathcal M_F\).  Formula (0.2) is the sum of \(5(H+J)\) and nef classes,
so it is ample.  Formula (0.3) is the generically finite ramification
formula and is ample for the same reason.

## 2. Exact first-jet ranks, including the diagonal

The following calculation is over the integers.  It is useful because an
evaluation-at-\(p\)-and-\(r\) basis ceases to be a frame at \(p=r\) and gives
a false rank drop.  The flat remainder frame avoids that error.

Choose affine coordinates

\[
x=[1:A:B],\qquad p=(u=0),\qquad
\ell=(v=Lu),\qquad r=(u=T).
\]

A monomial of \(F\) restricts, up to its coefficient, as

\[
A^aB^bL^j u^{i+j}.
\tag{2.1}
\]

For the length-three divisor \(2p+r\), use the remainder modulo
\(u^2(u-T)\).  In the basis \(1,u,u^2\),

\[
u^k\equiv T^{k-2}u^2\pmod {u^2(u-T)}
\qquad(k\geq2).
\tag{2.2}
\]

For \(2p+2r\), use the remainder modulo \(u^2(u-T)^2\).  In the basis
\(1,u,u^2,u^3\),

\[
u^k\equiv
(3-k)T^{k-2}u^2+(k-2)T^{k-3}u^3
\pmod {u^2(u-T)^2}
\tag{2.3}
\]

for \(k\geq2\), with the evident interpretations at \(k=2,3\).  At
\(T=0\), these are exactly the ordinary \(3p\)- and \(4p\)-jet frames.

Let \(s=(s_i)\) be the remainder vector.  A relative critical point over
\(p\) is recorded by a nonzero Lagrange multiplier \(\lambda\) and the
linear coefficient conditions

\[
s=0,
\qquad
\lambda\cdot\partial_A s=
\lambda\cdot\partial_B s=
\lambda\cdot\partial_L s=
\lambda\cdot\partial_T s=0.
\tag{2.4}
\]

For the length-three problem, the coefficient matrix in (2.4) has the
following exact ranks:

\[
\begin{array}{c|c|c}
\lambda\in\mathbf P^2&\text{rank}&\text{geometric stratum}\\ \hline
\lambda_2\neq0&7&\text{residual critical locus}\\
\lambda_2=0,\ [\lambda]\neq[1:0:0]&6&\text{tangent-base locus}\\
[\lambda]=[1:0:0]&5&\text{conic-bundle locus}.
\end{array}
\tag{2.5}
\]

The same table holds at \(T=0\).  For length four the ranks are

\[
\begin{array}{c|c}
\lambda\in\mathbf P^3&\text{rank}\\ \hline
\lambda\notin\Pi_T&8\\
\lambda\in\Pi_T,\ [\lambda]\neq[1:0:0:0]&7\\
[\lambda]=[1:0:0:0]&6
\end{array}
\tag{2.6}
\]

where \(\Pi_T\) is the projective plane of functionals which factor through
the quotient from \(2p+2r\) to \(2p+r\).  In the frame (2.3),

\[
\Pi_1=\{\lambda_2=\lambda_3\},
\qquad
\Pi_0=\{\lambda_3=0\}.
\tag{2.7}
\]

Here is a coordinate-free explanation of the ranks.  The section rows and
the \(A,B\) derivative rows contribute respectively five rows in the
length-three calculation and six in the length-four calculation.  The
\(L\)-derivative adds one row unless the functional is evaluation at \(p\),
namely \([1:0:\cdots:0]\).  The moving-\(r\) derivative adds one more row
unless the functional factors through the divisor with one fewer layer at
\(r\).  This proves (2.5)--(2.6) in every characteristic-zero degree
\(d\geq4\), not only over the finite fields used by the checker.

The exhaustive finite-field replay in
`special_seed_stability_frontier_checks.py` gives, over \(\mathbf F_q\),

\[
\begin{array}{c|ccc}
&\text{top rank}&\text{middle rank}&\text{bottom rank}\\ \hline
2p+r&q^2&q&1\\
2p+2r&q^3&q^2+q&1.
\end{array}
\tag{2.8}
\]

It checks both \(T=1\) and \(T=0\) over two primes.

The important conclusion is narrow but exact: the diagonal creates no new
first-order critical mechanism.  It does not prove that the saturated
closure of the residual stratum is smooth, nor that its map to \(Y\) is
generically one-to-one.

## 3. What the double-residual surface captures

Away from the conic and tangent-base critical loci, the tangent flag is
smooth over \(Y\).  Choose a coordinate \(u\) along its one-dimensional
fiber.  After division by \(2p\), write the residual equation as

\[
Q(u,r)=0,
\qquad \deg_r Q=d-2.
\tag{3.1}
\]

Then

\[
\mathcal M_F=\{Q=Q_r=0\}.
\]

On this surface, the determinant of the derivative of
\(h:\mathcal M_F\to Y\) in the \((u,r)\)-directions is, up to a unit,

\[
\det
\begin{pmatrix}
Q_u&Q_r\\
Q_{ur}&Q_{rr}
\end{pmatrix}
=Q_uQ_{rr}.
\tag{3.2}
\]

Thus

- \(Q_u=0\) is precisely the singular-fiber, or residual critical,
  condition for \(g\); and
- \(Q_{rr}=0\) is the triple-residual-root condition.

This proves both inclusion and the exact possible excess.  When \(d=4\),
\(Q\) is quadratic.  Its second derivative is a unit wherever the line is
not a component of \(C_x\), so (3.2) has no triple-root factor.  For
\(d\geq5\), using all of \(\operatorname {Ram}(h)\) as the residual critical
curve would overcount this triple-root divisor.  The flat formulas
(2.2)--(2.3) prove that the same assertion remains valid in the limit
\(p=r\): \(2p+2r\) becomes \(4p\), rather than disappearing as an artifact
of a nonflat evaluation basis.

## 4. Quartic intersection arithmetic

The Chow ring calculation takes place in the product of four planes, with

\[
[\mathcal I]=(P+J)(R+J),
\qquad H^3=P^3=J^3=R^3=0.
\]

The fundamental class of \(\mathcal M_F\) is

\[
[\mathcal M_F]=L_1L_2L_3L_4
\quad\text{on }\mathbf P^2_x\times\mathcal I,
\tag{4.1}
\]

with the \(L_i\) from (1.2).  At \(d=4\),

\[
K=5H+5J,
\qquad
R_h=5H+3P+5J.
\tag{4.2}
\]

Extracting the coefficient of \(H^2P^2J^2R^2\) after multiplication by
\((P+J)(R+J)\) gives (0.4)--(0.5).  The checks are reproduced without a
computer-algebra dependency in `special_seed_stability_frontier_checks.py`.

The two enumerative numbers have useful meanings.  The value
\(P^2[\mathcal M_F]=32\) is the degree of the marked-bitangent surface over
a general \(p\in Y\).  If every component of \(\mathcal M_F\) is generically
finite over \(Y\), the actual ramification pushforward cycle has plane degree

\[
\deg h_*R_h=P R_h=876.
\]

This is a cycle degree.  It does not by itself show that a component of
\(R_h\) maps birationally to its image: if a component maps with degree
\(m>1\), its image occurs with multiplicity \(m\) in this pushforward.
That is exactly why a two-point multijet argument was necessary; its generic
degree-one conclusion is subsequently proved in
`special_seed_ramification_comparison.md`.

## 5. Stable local models and the explicit obstruction

The ordinary stable models cause no difficulty for an arbitrary immersed
seed.

1.  At a fold, the family is \(uv=s\).  If the seed has contact order
    \(m<\infty\) with \(s=0\), its pullback is \(uv=t^m\), hence is smooth
    for \(m=1\) and has type \(A_{m-1}\) for \(m\geq2\).

2.  At a cusp, use the miniversal equation

    \[
    u^2+v^3+av+b=0.
    \]

    Along an immersed seed, either \(b'(0)\neq0\), in which case the total
    surface is smooth, or \(a'(0)\neq0\), in which case its quadratic part
    is nondegenerate and the singularity is \(A_1\).

3.  Two folds over the same base point but at distinct source points give
    two separate \(A\)-singularities after base change.

There is also a forced interaction between a fold of the tangent base and
the quartic residual double cover.  The subsequent boundary-fold theorem
proves at every middle and bottom multiplier-boundary point that the
transverse local model is

\[
uv=s,
\qquad
z^2=u+v+\gamma t,
\qquad \gamma\neq0.
\tag{5.1}
\]

Putting \(w=u-v\) eliminates \(u,v\) and gives

\[
\boxed{
w^2=(z^2-\gamma t)^2-4s.}
\tag{5.2}
\]

The two discriminant branches in the base are

\[
s=0,
\qquad
4s=\gamma^2t^2;
\tag{5.3}
\]

they have forced quadratic tangency.  Let an immersed seed through the
origin be \(t=\tau, s=\phi(\tau)\); the other tangent direction gives a
smooth pullback.  If the seed is not contained in either branch, (5.2)
has only Du Val singularities:

- if \(\operatorname {ord}\phi=m>2\), it has type \(A_{2m-1}\);
- if \(\operatorname {ord}\phi=2\) and
  \(4\phi/\tau^2\) does not start with \(\gamma^2\), it has type \(A_3\);
- if
  \(k=\operatorname {ord}(4\phi-\gamma^2\tau^2)\geq3\), it has type
  \(D_{k+1}\).

These forms follow from the splitting lemma applied to

\[
w^2-z^4+2\gamma\tau z^2+4\phi(\tau)-\gamma^2\tau^2.
\]

Containment in either branch gives a one-dimensional or reducible
singular locus and must be excluded globally.

The nonzero coefficient in (5.1) is essential.  If \(\gamma=0\) and the
seed is \(s=\tau^m\), the pullback becomes

\[
\boxed{w^2-z^4+4\tau^m=0.}
\tag{5.4}
\]

For \(m=2\) this is \(A_3\), and for \(m=3\) it is \(E_6\).  For \(m=4\)
it is the simple-elliptic Brieskorn singularity of type
\(\widetilde E_7\), hence is not Du Val or canonical; for \(m>4\) it is
worse.  Formula (5.4) is an explicit obstruction, not merely a gap in a
positivity argument.

## 6. Retrospective status of the transversality frontier

The first-jet audit originally reduced the quartic problem to the following
finite list.  Later certificates settle part of it as indicated.

1.  **Saturated one-point closure — completed.**  Saturate the
    \(\lambda_2\neq0\) residual critical incidence before taking its closure
    along the tangent line, the conic point, and \(p=r\).  Prove that its
    general-\(F\) fiber equals the full actual ramification divisor in class
    \(R_h\) and is smooth.  The lower ranks in (2.5) are genuine adjacent
    mechanisms, so unsaturated generic smoothness is not enough.  This is
    proved in `special_seed_residual_saturation.md` and
    `special_seed_ramification_comparison.md`.

2.  **Relative two- and three-jets — boundary part completed.**  Prove that
    the open-residual critical points are folds except for isolated cusps,
    with no higher Morin degeneration.  The ordinary fold/double-cover model
    and \(\gamma\neq0\) at every middle and bottom multiplier-boundary point
    are proved in
    [`special_seed_boundary_fold_theorem.md`](special_seed_boundary_fold_theorem.md).
    The one-point
    coefficient ranks (2.5)--(2.6) alone did not control these derivatives.

3.  **Two-point multijets — generic part completed.**  Prove that the normalization of the total
    ramification curve is generically one-to-one over every discriminant
    component: each source component has generic degree one, and two distinct
    source components never share a generic image.  Isolated transverse
    double values are harmless; a common image component is not.  One must
    also exclude triple coincidences and nontransverse collisions with the
    two forced discriminants.  Generic degree one and distinct generic
    images are proved in `special_seed_ramification_comparison.md`; the
    isolated triple-value and collision classification remains.

Ampleness of \(K\) and \(R_h\), together with the completed generic-image
theorem, now proves unconditionally that every residual discriminant
component has positive-genus normalization.  The conic discriminant and
tangent-base image already have positive-genus normalizations.  The
all-special-seeds conclusion still awaits the open-residual part of item 2
and the isolated part of item 3 for the restricted 90-dimensional quartic
coefficient family.
