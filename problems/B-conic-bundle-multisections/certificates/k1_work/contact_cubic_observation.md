# A universal contact cubic for the three-`t=2` row

## Statement and scope

Work over an algebraically closed field of characteristic zero.  Let

\[
 f:Y\longrightarrow \mathbf P^2
\]

be the complete canonical resolution of a reduced plane octic in the last
class `(1,1)` rationality row.  Thus exactly three canonical centers have
`t=2`, every other center has `t=1`, and, in the total-transform basis,

\[
 D=E_{q_1}+E_{q_2}+E_{q_3},\qquad
 D_1=\sum_{t_j=1}E_j .
\]

Throughout, `E_i` denotes the **full total-transform** exceptional divisor
class `E_i^*`.  These are the orthogonal classes used in the intersection
calculation below.  The prime strict exceptional curve itself is denoted
`bar(E_i)` when it must be distinguished.

The two rationality conditions are

\[
 H^0\bigl(Y,O_Y(H-D)\bigr)=0,\qquad
 H^0\bigl(Y,O_Y(2H-2D)\bigr)=0.                 \tag{0.1}
\]

There is always a nonzero effective divisor

\[
 \Gamma_Y\in |3H-2D|.                           \tag{0.2}
\]

Equivalently, there is a plane cubic in the complete cluster ideal
`J_(2D)`.  Its degree is minimal, because the second vanishing in (0.1)
excludes a conic in the same doubled cluster ideal.

The corrected terminal branch has intersection zero with every such divisor:

\[
 B_Y\cdot\Gamma_Y=0.                             \tag{0.3}
\]

If `B_Y` and `Gamma_Y` have no common irreducible component, they are
disjoint.  On the normalization of every nonexceptional component of
`Gamma_Y`, the restriction of the original octic then has an even divisor.
If they share a component, especially an odd exceptional component inserted
during canonical resolution, this even-contact conclusion need not hold on
the remaining plane-cubic components.  That shared-component alternative is
why this observation did not by itself settle the infinitely-near analysis.

This observation supplies a uniform degree-three test object, but the broad
incidence of arbitrary contact cubics is numerically too large to exclude the
row without retaining the marked cluster data.  The later singleton and
separator theorems do retain that data and now exclude the row completely.

## 1. The line vanishing does not separate the proper origins

It is important not to infer that the three essential centers have distinct
proper origins.  Total-transform weights at an ancestor and a descendant
accumulate into a tangent condition.

For example, let `q` be the first point over a proper point `p`, in tangent
direction `tau`, and let `r` be another proper point.  For

\[
 D=E_p+E_q+E_r
\]

in the total-transform basis, a line in `|H-D|` would have to be the line
`pr` and its strict transform would also have to pass through `q`.  Thus
`H^0(O_Y(H-D))=0` whenever `tau` is not the direction of `pr`.  In the same
configuration, a conic in `|2H-2D|` would have to be the doubled tangent line
`tau^2`; it fails the condition at `r` when `r` is not on that line.  Hence
both vanishings in (0.1) can hold with two essential centers in one
infinitely-near tree.

The skeleton is realized by reduced octics.  In coordinates take

\[
 p=[0:0:1],\qquad r=[0:1:1],\qquad \tau=(y=0),
\]

and choose four general pairs `(a_i,b_i)` with the `a_i` nonzero and pairwise
distinct and the `b_i` pairwise distinct.  The conics

\[
 Q_{a_i,b_i}=yz+a_ix^2+b_i xy-y^2
\]

are smooth, pass through `p` and `r`, and have common tangent `tau` at `p`.
In the blowup chart `y=xw`, their strict transforms have distinct tangent
lines `w+a_i x=0` at the point `q` over `tau`.  At `r`, their tangent lines
are distinct because the `b_i` are distinct.  For general choices all their
other pairwise intersections are transverse and no three occur at the same
point.  This open condition is nonempty: for

\[
 (a_i,b_i)=(1,0),(2,1),(3,3),(4,7),
\]

the six residual pairwise intersection points, after the fixed intersections
at `p` and `r` are removed, are

\[
 [1:-1:0],\ [6:-4:5],\ [21:-9:40],\
 [2:-1:5],\ [3:-1:14],\ [4:-1:35].
\]

They are distinct, and direct substitution shows that none lies on either of
the two remaining conics.  Since two chosen conics have intersection
multiplicity two at `p` and one at `r`, Bezout then makes their residual
intersection transverse.  Therefore

\[
 B=\prod_{i=1}^4Q_{a_i,b_i}
\]

is a square-free octic with corrected essential sequence `(4,4)` at `p<q`,
an ordinary corrected quadruple point at `r`, and only `t=1` nodes elsewhere.
The preceding line and conic calculation shows that both systems in (0.1)
vanish.  This example has conic components, so the separate
[`conic_factor_theorem.md`](conic_factor_theorem.md) prevents it from being
the branch of a general rank-two or rank-three determinantal member.  Its
role here is to prove that ancestor type `[2,1]` is genuine plane-curve
geometry and cannot be deleted at the cluster level.

## 2. An essential center with no essential predecessor

There is nevertheless a useful exact reduction for a center whose earlier
tree contains no `t=2` center.  At any canonical center `v`, write

\[
 m_v=\operatorname{mult}_v(B_v^{\mathrm{strict}}),\qquad
 e_v=\#\{\text{prime exceptional branch components through }v\},
 \qquad r_v=m_v+e_v.                              \tag{2.1}
\]

At a point of a blown-up smooth surface, at most two exceptional curves pass
through the point, so `e_v` is `0`, `1`, or `2`.

**Lemma.**  Suppose `q` is a nonproper center with `t_q=2`, and every strict
predecessor of `q` has `t=1`.  Then `q` is the first point over a proper
center `p`, and

\[
 (m_p,m_q)=(3,3),\qquad (r_p,r_q)=(3,4).          \tag{2.2}
\]

To prove this, let `v` be the immediate predecessor of `q`.  Multiplicity of
the strict transform cannot increase under blowup, so `m_q<=m_v`.  More
precisely, the strict-transform multiplicities satisfy the proximity
inequality

\[
 m_u\ge \sum_{w\succ u}m_w,                      \tag{2.3}
\]

where the sum is over all later centers `w` proximate to `u`.

There are three cases.

1. If `e_q=0`, the new exceptional curve created at `v` is not a branch
   component.  Hence `r_v` is even.  Since `t_v=1`, one has `r_v=2`, so
   `m_q<=m_v<=2`, contradicting `r_q>=4`.
2. If `e_q=1`, then `m_q>=3`.  The inequalities
   `m_q<=m_v<=r_v<=3` force

   \[
   m_q=m_v=r_v=3,\qquad e_v=0.
   \]

   The odd value `r_v=3` inserts the new exceptional curve, which is the
   unique exceptional branch through `q`; hence `r_q=3+1=4`.  The center
   `v` must be proper.  Indeed, if it were nonproper, its immediate
   predecessor exceptional would not be a branch component because
   `e_v=0`; that predecessor would have even corrected multiplicity two,
   and proximity would give `m_v<=2`, a contradiction.  Thus `v=p` and
   (2.2) follows.
3. If `e_q=2`, then `q` is satellite.  Write `v` for its immediate
   predecessor and `u` for the earlier center to which `q` is also
   proximate.  The new exceptional from `v` must be a branch component, so
   `r_v=3`.  The older exceptional through `v` is also a branch component,
   whence `e_v>=1` and `m_v<=2`.  Since `r_q=m_q+2>=4` and
   `m_q<=m_v`, one gets `m_q=m_v=2`.  Both `v` and `q` are proximate to
   `u`, so (2.3) yields

   \[
   m_u\ge m_v+m_q=4.
   \]

   Consequently `r_u>=4`, making `u` an essential predecessor of `q`,
   contrary to the hypothesis.

This proves the lemma.  A fixed proper-origin tree has at most one minimal
essential center.  If its proper root is not essential, the lemma makes every
minimal essential center a first-near point with `m_p=m_q=3`.  Two distinct
such first-near points `q,q'` would violate proximity at the root:

\[
 m_p\ge m_q+m_{q'}=6.
\]

Thus the minimal essential center is unique.  Partition the three essential
centers according to their proper-origin trees.  In root type `[1,1,1]`, every
nonproper essential center is exactly an immediate `(3,4)` cluster of the
form (2.2).  In root types `[2,1]` and `[3]`, every essential center after the
unique minimal one in a repeated tree has an essential ancestor.  These types
remain separate: the lemma does not exclude or classify their later
`(4,4)`-type behavior.

One immediate-successor case can also be settled.  A minimal essential center
of type `(3,4)` cannot have an essential center immediately above it.  Indeed,
write the cluster as `p<q` with `m_p=m_q=3` and `r_q=4`.  The blowup at `q`
does not insert its new exceptional curve into the branch.  At a free point
immediately above `q` one therefore has corrected multiplicity at most three.
At the satellite point on the older branch exceptional, essentiality would
force strict multiplicity at least three; but both `q` and that satellite are
proximate to `p`, contradicting

\[
 m_p\ge m_q+m_{\mathrm{satellite}}\ge6.
\]

Consequently, a **minimal** essential center with an immediate essential
successor is proper.  In particular, when a root tree contains exactly two
essential centers and they are adjacent, the earlier one is proper.  This is
the scope reduction used by
[`adjacent_nested_pair_theorem.md`](adjacent_nested_pair_theorem.md).

## 3. Riemann--Roch produces the cubic

Use the total-transform basis on `Y`.  It has intersection form

\[
 H^2=1,\qquad E_i^2=-1,\qquad H\cdot E_i=E_i\cdot E_j=0\ (i\ne j),
\]

and

\[
 K_Y=-3H+\sum_iE_i .
\]

Set `M=3H-2D`.  Since `D` contains exactly three exceptional basis classes,

\[
 M^2=9-4\cdot3=-3,
 \qquad
 M\cdot K_Y=-9+2\cdot3=-3.
\]

Riemann--Roch gives

\[
 \chi(O_Y(M))
 =1+\frac{M\cdot(M-K_Y)}2=1.                    \tag{3.1}
\]

Moreover

\[
 K_Y-M=-6H+3D+D_1.
\]

Its intersection with the nef pullback `H` is `-6`, so it is not effective.
Thus `h^2(O_Y(M))=h^0(O_Y(K_Y-M))=0`, and (3.1) implies

\[
 h^0(O_Y(M))=1+h^1(O_Y(M))\ge1.                 \tag{3.2}
\]

Pushing down identifies this space with

\[
 H^0\!\left(\mathbf P^2,
 O_{\mathbf P^2}(3)\otimes
 f_*O_Y(-2D)\right)
 =H^0\bigl(\mathbf P^2,J_{2D}(3)\bigr).
\]

This proves (0.2).  The equality uses the complete divisorial cluster ideal;
no unloading of raw infinitely-near weights is being suppressed.

## 4. Zero intersection with the corrected branch

At a canonical center of corrected multiplicity `r_i`, put
`t_i=floor(r_i/2)`.  The canonical blowup rule subtracts `2t_i E_i` from the
pullback branch class.  Hence the final corrected branch is

\[
 B_Y\sim 8H-2\sum_i t_iE_i
      =8H-4D-2D_1.                              \tag{4.1}
\]

Using the diagonal total-transform intersection form,

\[
 \begin{aligned}
 B_Y\cdot M
  &=(8H-4D-2D_1)\cdot(3H-2D)\\
  &=24+8D^2\\
  &=24+8(-3)=0.
 \end{aligned}                                  \tag{4.2}
\]

Both `B_Y` and `Gamma_Y` are effective divisors on the smooth surface `Y`.
If they have no common component, all local intersection multiplicities are
nonnegative, so (4.2) forces them to be disjoint.

The relation between the original octic and the corrected branch is

\[
 f^*B=B_Y+4D+2D_1.                              \tag{4.3}
\]

Let `G` be a nonexceptional irreducible component of `Gamma_Y`, and assume
the no-common-component case.  Restricting (4.3) to the normalization of `G`
and using `B_Y\cap G=\varnothing` gives

\[
 \operatorname{div}\bigl((f^*B)|_{\widetilde G}\bigr)
 =2\,\bigl((2D+D_1)|_{\widetilde G}\bigr).       \tag{4.4}
\]

Thus the contact divisor is even.  Equivalently, the restricted octic
section is a square for one of the square roots of the restricted line bundle
`f^*O_(P^2)(8)|_(tilde G)`.  On a smooth plane cubic this line bundle has
degree 24, and its square roots differ from `O_G(4)` by the finite two-torsion
subgroup; it is not legitimate to select only the trivial square root without
proof.

If `B_Y` and `Gamma_Y` share a component, (4.2) no longer implies
disjointness of their other components: negative self-intersection of the
shared component can offset positive intersections elsewhere.  This occurs
naturally when a predecessor has odd corrected multiplicity.  Its prime
exceptional curve `bar(E_i)` is inserted into `B_Y` and can also be a fixed
exceptional component of `|3H-2D|`.  Therefore (4.4) is deliberately asserted only in the
no-common-component case.

## 5. Why the unmarked contact-cubic incidence is insufficient

For a fixed rank-three `sigma` and a fixed smooth plane cubic `Gamma`, the
restriction space has dimension

\[
 h^0(\Gamma,\mathcal Q|_\Gamma)=36,
\]

while the determinant lies in the 24-dimensional space
`H^0(Gamma,O_Gamma(8))`.  A square root has degree twelve and therefore a
12-dimensional space of sections on the elliptic cubic.  Even under the
optimistic equidimensional count for the determinant map, the inverse image
of the square cone has expected codimension only

\[
 24-12=12.
\]

Plane cubics move in dimension nine, leaving only three conditions for a
fixed `sigma`, far short of the rank-three orbit dimension eight.  Reducible,
nonreduced, and shared-component cubics can only require additional
stratification.

Accordingly, (0.2)--(0.3) do not by themselves exclude the last row.  The
later successful marked incidences retain the three essential
centers, their full Enriques diagram and proximity types, the two
cluster-system vanishings, and the component-sharing alternatives.  The
observation is a uniform reduction to degree-three geometry, not by itself an
incidence theorem.
