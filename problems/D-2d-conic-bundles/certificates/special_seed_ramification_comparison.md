# Quartic residual ramification: exact comparison and two-point separation

## Statement and scope

Keep the quartic notation of
[`special_seed_stability_frontier.md`](special_seed_stability_frontier.md)
and
[`special_seed_residual_saturation.md`](special_seed_residual_saturation.md).
Thus $s=(s_0,s_1,s_2)$ is the flat remainder modulo
$u^2(u-T)$, $W=\partial_Ts_2$, and
$\mathcal M_F$ is the marked $2p+2r$ surface.  Let
$h:\mathcal M_F\to\mathbf P^2_y$ remember $p$.

This note closes two of the previously separate gaps.

> **Ramification comparison theorem.**  For a general equation
> $F\in H^0(\mathcal O(2,4))$, the scheme-theoretic image on
> $\mathcal M_F$ of the saturated residual multiplier incidence is
> exactly the relative ramification scheme of $h$.  It is a smooth
> curve, and the multiplier is unique at every one of its points.
> Its intersection with the multiplier boundary $\lambda _2=0$ is
> finite and reduced.

> **Two-point separation theorem.**  On the open residual stratum
> $\lambda _2\ne0$, ordered pairs of distinct critical points over a
> common $p$ form a finite scheme for a general $F$.  Consequently
> every ramification component maps generically with degree one to its
> image in $\mathbf P^2_y$, and two different components cannot have
> the same generic image.

Combining these statements with the ample classes computed in
[`special_seed_stability_frontier.md`](special_seed_stability_frontier.md)
gives an unconditional geometric corollary:

> **Positive-genus discriminant corollary.**  Every residual
> discriminant component has normalization of genus at least two, and
> distinct ramification components normalize distinct discriminant
> components.  In particular, the residual discriminant has no rational
> irreducible component.

Indeed, purity of the smooth ramification curve rules out an
$h$-vertical surface component of $\mathcal M_F$, so every component is
generically finite over $\mathbf P^2_y$.  Its canonical class and
ramification class are ample.  Distinct smooth ramification components
are disjoint; for each such component $C$, adjunction gives

\[
2g(C)-2=(K_{\mathcal M_F}+C)C>0.
\]

The two-point theorem identifies $C$ birationally with its image and
prevents another component from sharing that image.

The first theorem removes both the ramification-comparison gap and the use
of relative second jets merely to prove smoothness of the ramification
curve.  The second removes the generic-birationality part of the two-point
gap.  It does **not** classify every isolated double or triple value, prove
the fold/cusp normal form at every source point, or exclude every higher
Morin degeneration.  In particular, the implication for the mixed
coefficient $\gamma$ at the end of Section 4 is deliberately conditional
on first establishing the ordinary fold/double-cover form there.

The subsequent
[`special_seed_boundary_fold_theorem.md`](special_seed_boundary_fold_theorem.md)
establishes that form at every middle and bottom multiplier-boundary point
and therefore makes the nonzero-$\gamma$ conclusion unconditional there.
Open-residual cusp/higher-Morin and isolated-collision questions remain.

## 1. The length-four ideal is $(s,W)$

On the standard affine chart write

\[
F_x|_\ell=c_0+c_1u+c_2u^2+c_3u^3+c_4u^4.
\tag{1.1}
\]

The length-three remainder is

\[
s_0=c_0,\qquad s_1=c_1,\qquad
s_2=c_2+Tc_3+T^2c_4,
\tag{1.2}
\]

and hence

\[
W=\partial_Ts_2=c_3+2Tc_4,
\qquad U:=\partial_TW=2c_4.
\tag{1.3}
\]

Modulo $u^2(u-T)^2$, the last two coefficients in the flat basis
$1,u,u^2,u^3$ are

\[
e_2=c_2-T^2c_4,\qquad e_3=c_3+2Tc_4.
\tag{1.4}
\]

Since

\[
s_2=e_2+Te_3,\qquad W=e_3,
\tag{1.5}
\]

the two ideals agree scheme-theoretically:

\[
\boxed{I_{\mathcal M_F}=(s_0,s_1,s_2,W).}
\tag{1.6}
\]

If $U=0$ at a point of this ideal, then (1.2)--(1.3) give
$c_2=c_3=c_4=0$, while $s_0=s_1=0$ gives $c_0=c_1=0$.  Thus
$F_x|_\ell\equiv0$.  A general $(2,4)$-equation has no such pair
$(x,\ell)$: vanishing of a binary quartic imposes five independent
conditions, while $(x,\ell)$ varies in dimension four.  Therefore

\[
\boxed{U\text{ is a unit everywhere on }\mathcal M_F.}
\tag{1.7}
\]

The argument is invariant under changing the affine coordinate on
$\ell$, so it also covers $T=0$ and the complementary chart at
infinity.

## 2. Determinant comparison and smoothness

Use $z=(A,B,L,T)$ as relative coordinates over $p$, and set

\[
K=D_{A,B,L}(s_0,s_1,s_2).
\tag{2.1}
\]

On $\mathcal M_F$, the $T$-column of $D_zs$ is zero, because it is
$(0,0,W)^{\mathsf t}$.  The $T$-column of the full relative Jacobian of
$(s_0,s_1,s_2,W)$ is therefore $(0,0,0,U)^{\mathsf t}$.  Expansion in
that column gives the identity in the local ring of $\mathcal M_F$

\[
\boxed{
\det D_z(s_0,s_1,s_2,W)=U\det K.}
\tag{2.2}
\]

By (1.7), the actual relative ramification ideal is exactly
$(\det K)$.  On the other hand, the saturated multiplier incidence is

\[
s=W=0,\qquad [\lambda]\,D_zs=0.
\tag{2.3}
\]

Because the last column of $D_zs$ vanishes on $\mathcal M_F$, its
set-theoretic image is the maximal-minor locus

\[
\operatorname {rank}K\le2,
\tag{2.4}
\]

whose ideal is $(\det K)$.  The scheme assertion can be checked locally,
without relying on a blanket elimination statement.  As shown below, a
general $F$ has $\operatorname {rank}K=2$ everywhere on this locus.  On an
open set where a chosen $2\times2$ minor is invertible, two multiplier
coordinates are solved uniquely from $[\lambda]K=0$; the remaining
multiplier equation is exactly $\det K=0$ after multiplication by that
unit minor.  Thus the kernel incidence is locally the graph over the
Cartier divisor $(\det K)$, with its scheme structure.  This proves the
comparison as schemes, not only set-theoretically and not only on
$\lambda _2\ne0$.

It remains to justify the asserted smoothness.  The saturated universal
incidence is prime, and its only intrinsic singular locus is the rank-four
quadric-cone locus

\[
[\lambda]=[1:0:0],\qquad \eta _1=\eta _2=0.
\tag{2.5}
\]

As proved in `special_seed_residual_saturation.md`, this locus imposes
eight coefficient conditions over the six-dimensional flag space.  Its
universal dimension is therefore at most $87<89$.  The multiplier and
flag spaces are projective, so the projection of this locus to coefficient
space is closed as well as proper.  A general coefficient fiber avoids it.

Off (2.5) the universal incidence is smooth.  Its projection to
$\mathbf P^{89}$ is projective, hence proper.  It is also dominant.  One
way to see dominance without a dimension-only inference is to use
$P^2[\mathcal M_F]=32$: the total horizontal degree is $32$, so at least
one component of $\mathcal M_F$ is $h$-horizontal.  In characteristic zero
the Jacobian is not identically zero on that component, while its
nontrivial ample ramification class forces the Jacobian to vanish along a
curve.
Thus general coefficients occur in the multiplier image.  After first
deleting the closed coefficient image of (2.5), the whole inverse image is
smooth.  Generic smoothness shows that the relative nonsmooth locus does
not dominate coefficient space.  It is closed, and properness makes its
coefficient image closed; deleting that image supplies a further dense
open over which the entire morphism, not merely an open part of its source,
is smooth.  Every coefficient fiber over this open is consequently a
smooth curve.

There is no hidden projective-kernel ambiguity.  In the eight-dimensional
space of matrices

\[
\begin{pmatrix}
*&*&0\\ *&*&*\\ *&*&*
\end{pmatrix},
\tag{2.6}
\]

the rank-at-most-one locus has codimension four.  Together with the four
equations $s=W=0$, it imposes eight conditions on $F$ at a fixed flag.
The flag space has dimension six, so a general $F$ avoids it.  Hence
$K$ has rank exactly two along $\det K=0$, its left kernel is a unique
line, and (2.3) is the graph of that kernel.  The smooth multiplier fiber
is therefore isomorphic to the actual ramification curve.

There is also an immediate componentwise consequence.  If a surface
component of $\mathcal M_F$ were $h$-vertical, the relative differential
would have rank at most one generically on that component, so $\det K$
would vanish identically there.  The actual ramification scheme would then
contain a surface component, contradicting its identification with the
pure smooth multiplier curve.  Hence every component of $\mathcal M_F$
dominates $\mathbf P^2_y$ and is generically finite over it.

Finally consider $\lambda _2=0$.  On the middle stratum
$\lambda _1\ne0$, the seven coefficient rows are independent over a
seven-dimensional flag-plus-multiplier space.  On the bottom stratum
$[\lambda]=[1:0:0]$, six rows are independent over the six-dimensional
flag space.  Each smooth universal stratum is therefore generically finite
over coefficient space if it dominates, and is absent from a general fiber
if it does not.  Generic smoothness makes every dominating degree-zero
fiber finite etale, hence scheme-theoretically reduced.  The intersection
of the two boundary-component closures, and the intrinsic node (2.5), have
coefficient image of codimension at least one.  After deleting these closed
images, every boundary point belongs to exactly one of the two etale
strata.  Thus the Cartier pullback of $\lambda _2=0$ to a general smooth
ramification curve is a finite reduced scheme.

## 3. Uniform two-point ranks

Let $W_y=H^0(\mathbf P^2_y,\mathcal O(4))^*$.  At a residual flag

\[
\theta=(x,p,\ell,r,[\lambda]),\qquad \lambda _2\ne0,
\]

normalize $\lambda _2=1$.  Denote by $e_x,a_x,b_x$ the value and two
first-derivative functionals on $H^0(\mathbf P^2_x,\mathcal O(2))$.  The
seven critical rows have the intrinsic direct-sum form

\[
\boxed{
R_\theta=e_x\otimes U_\theta
 +(\langle a_x,b_x\rangle\otimes\langle q_\theta\rangle),}
\tag{3.1}
\]

where

\[
q_\theta=\lambda _0s_0+\lambda _1s_1+s_2
\tag{3.2}
\]

is a nonzero length-three distribution and
$U_\theta\subset W_y$ is the five-space spanned by the three section
rows and the $L,T$ multiplier rows.  Formula (3.1) is just the
coefficient-block splitting behind the saturation theorem.

### Distinct $x$-points

For $x_1\ne x_2$, the two three-dimensional first-jet spaces of conics
meet in one dimension.  In coordinates
$x_1=(0,0),x_2=(1,0)$, their common functional is represented by

\[
2e_{x_1}+a_{x_1}=2e_{x_2}-a_{x_2}.
\tag{3.3}
\]

It follows directly from (3.1) that

\[
R_{\theta _1}\cap R_{\theta _2}\ne0
\quad\Longleftrightarrow\quad
[q_{\theta _1}]=[q_{\theta _2}],
\tag{3.4}
\]

and in that case the intersection has dimension one.  The distribution
$q_\theta$ recovers the $y$-flag and the multiplier.  If $r\ne p$,
then, up to the chosen trivializations,

\[
q_\theta(f)=\lambda _0f(p)+\lambda _1D_\ell f(p)
+\frac{f(r)-f(p)-T D_\ell f(p)}{T^2}.
\tag{3.4a}
\]

Its support away from $p$ recovers $r$, hence
$\ell=\overline{pr}$, and its order-at-$p$ coefficients recover
$\lambda$.  If $r=p$, the flat limit is

\[
q_\theta(f)=\lambda _0f(p)+\lambda _1D_\ell f(p)
+\tfrac12D_\ell^2f(p).
\tag{3.4b}
\]

Its nonzero quadratic principal symbol is the square of the direction of
$\ell$, and the lower-order terms again recover $\lambda$.  Therefore

\[
\operatorname {rank}(R_{\theta _1}+R_{\theta _2})=
\begin{cases}
14,&(\ell_1,r_1,\lambda _1)\ne(\ell_2,r_2,\lambda _2),\\
13,&(\ell_1,r_1,\lambda _1)=(\ell_2,r_2,\lambda _2).
\end{cases}
\tag{3.5}
\]

### Equal $x$-points

When $x_1=x_2$, (3.1) gives

\[
\dim(R_{\theta _1}+R_{\theta _2})
=\dim(U_{\theta _1}+U_{\theta _2})
 +2\dim\langle q_{\theta _1},q_{\theta _2}\rangle.
\tag{3.6}
\]

The required binary-quartic calculation is uniform in the multipliers:

\[
\begin{array}{c|c|c|c}
\text{$y$-flags}&\dim(U_1+U_2)&\dim\langle q_1,q_2\rangle
 &\operatorname {rank}\\ \hline
\ell_1\ne\ell_2,\ \text{not both }r_i=p&9&2&13\\
\ell_1\ne\ell_2,\ r_1=r_2=p&8&2&12\\
\ell_1=\ell_2,\ r_1\ne r_2&7&2&11.
\end{array}
\tag{3.7}
\]

For completeness, put the two distinct lines on the coordinate axes.  On
$v=0$, the five-space is

\[
\begin{aligned}
\langle;&c_{00},c_{10},
c_{20}+Tc_{30}+T^2c_{40},c_{30}+2Tc_{40},\\
&\lambda _1c_{01}+c_{11}+Tc_{21}+T^2c_{31}\rangle,
\end{aligned}
\tag{3.8}
\]

and the formula on $u=0$ is obtained by interchanging the indices.  The
intersection has dimension one unless both $T$'s vanish; then the extra
common vector is

\[
\lambda _{1,2}c_{10}+\lambda _{1,1}c_{01}+c_{11}.
\tag{3.9}
\]

On one common line, the two radial planes

\[
\langle c_{20}+Tc_{30}+T^2c_{40},\ c_{30}+2Tc_{40}\rangle
\tag{3.10}
\]

meet in one dimension for distinct $T$, while the two transverse rows in
(3.8) are independent.  This proves every entry of (3.7) in
characteristic zero.

### Incidence dimensions

The ordered pair space over a common $p$, including the two multipliers,
has dimension fourteen.  The complete list needed off the source diagonal
is

\[
\begin{array}{c|c|c}
\text{stratum}&\text{parameter dimension}&\text{coefficient rank}\\ \hline
x_1\ne x_2,\ q_1\ne q_2&14&14\\
x_1\ne x_2,\ q_1=q_2&10&13\\
x_1=x_2,\ \ell_1\ne\ell_2,\ \text{not both diagonal}&12&13\\
x_1=x_2,\ \ell_1\ne\ell_2,\ r_1=r_2=p&10&12\\
x_1=x_2,\ \ell_1=\ell_2,\ r_1\ne r_2&11&11.
\end{array}
\tag{3.11}
\]

The last row is absent for a general $F$, not merely dimension zero.  At
a residual critical point $W=0$, so $r$ is a double residual root.  Two
distinct such roots on the same quartic line section, already divisible by
$p^2$, force that line section to vanish identically.  This is the
forbidden line-component locus of Section 1.

The source diagonal with two different multipliers is not an omitted
off-diagonal case.  Section 2 proves $\operatorname {rank}K=2$ at every
ramification point of a general $F$, so its left kernel, and hence its
projective multiplier, is unique.

For every other off-diagonal stratum, parameter dimension minus coefficient
rank is at most zero, and equality occurs only in the first row.  Hence the
universal off-diagonal pair incidence has dimension at most $89$, with all
potential excess strata having smaller image.  A general coefficient fiber
is finite.  A ramification component of generic degree at least two, or two
components with a common generic image, would instead give a curve in this
fiber product.  This proves the two-point separation theorem.

## 4. What reduced boundary says about \(\gamma\)

There is a useful exact local consequence, but it must not be read as a
proof of an unestablished normal form.  Suppose a middle-boundary point has
already been reduced analytically to

\[
uv=s,\qquad z^2=u+v+\phi(t),
\tag{4.1}
\]

with the first map an ordinary fold and the second an ordinary double-cover
branch.  The residual multiplier equations, with multiplier
$[a:b]$, are

\[
av-b=au-b=2bz=0.
\tag{4.2}
\]

Saturating by $b$ gives

\[
z=0,\qquad u=v=b/a,\qquad 2u+\phi(t)=0.
\tag{4.3}
\]

The boundary $b=0$ on the saturated critical curve therefore has local
ring

\[
k[[t]]/(\phi(t)).
\tag{4.4}
\]

It is reduced exactly when

\[
\phi'(0)\ne0.
\tag{4.5}
\]

After the notation of `special_seed_stability_frontier.md`, this derivative
is the mixed coefficient $\gamma$.  Thus the reduced-boundary theorem
forces $\gamma\ne0$ at every point where (4.1), apart from the value of
$\gamma$, has independently been justified.

The subsequent boundary-fold theorem establishes the fold/double-cover model
at every middle and bottom boundary point, so (4.5) now gives
$\gamma\ne0$ there.  The remaining one-point obstruction is the full
radical/cubic rank stratification on the open residual chart.  Likewise,
this note proves generic one-to-one mapping, but not a complete analytic
classification of every isolated multiple value.

## 5. Mechanical replay

[`special_seed_ramification_comparison_checks.py`](special_seed_ramification_comparison_checks.py)
checks the triangular change (1.5), the determinant factorization (2.2),
all ranks in (3.5)--(3.7) at the projective normal forms, and exhausts every
residual multiplier pair over two small finite fields.  Its recorded output
is
[`special_seed_ramification_comparison_checks.log`](special_seed_ramification_comparison_checks.log).
