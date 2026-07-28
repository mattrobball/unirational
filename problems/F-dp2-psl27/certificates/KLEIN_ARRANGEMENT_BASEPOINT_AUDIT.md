# Klein arrangement: local basepoint and Noether/Hodge audit

## Verdict and scope

The 21 contracted involution lines force a precise basepoint cluster.  At
each of the 21 quadruple points the proper multiplicity is at least \(4\),
and each of the four incident directions is a further first-near
basepoint.  At each of the 28 triple points the proper multiplicity is at
least \(1\).  Since every involution line contains four points of each
kind, this gives

\[
d\ge4(4+1)+4=24.
\]

Thus the arrangement geometry recovers the structural degree bound
exactly.  It does not strengthen it to an all-degree contradiction:
the minimal cluster has square sum \(448\), leaving self-intersection
\(24^2-448=128>0\), and explicit orbit bookkeeping leaves positive even
slack in every even degree \(d\ge24\).

This is a route audit, not a resolution of Problem F.  Its exact finite
calculations are checked by
[klein_arrangement_basepoint_audit.py](klein_arrangement_basepoint_audit.py).

## 1. Exact arrangement and target-line calculation

For an involution \(t\), let

\[
L_t=\mathbf P(E_-(t)).
\]

The script constructs all 21 lines from the exact
\(\mathbf Q(\zeta_7)\)-matrices and intersects every pair.  It obtains
exactly 49 points:

\[
21\text{ points on four lines, with stabilizer }D_8,
\]

\[
28\text{ points on three lines, with stabilizer }S_3.
\]

For every point \(q\), let \(t_1,\ldots,t_r\) be its incident
involutions.  An even-degree landing map contracts \(L_{t_i}\) to a point
over the \(+1\)-eigenline \(E_+(t_i)\).  The checker proves that these
\(r\) target eigenlines are distinct and collinear.

At a triple point, restriction of the Klein quartic to this target line is
a nonzero scalar times the square of a separable quadratic: its gcd with
its derivative has degree \(2\), and the quotient is proportional to the
gcd.  Thus the line is a bitangent.

At a quadruple point, the restricted binary quartic is squarefree: its gcd
with its derivative has degree \(0\).

Since distinct incident source lines have distinct target points, every
one of the 49 intersections is necessarily a basepoint.

## 2. Quadruple-point multiplicity

Fix a quadruple point \(q\), with stabilizer \(D_8\).  The script verifies
that the stabilizer has a unique central involution \(z\), that \(z\)
fixes \(q\) through its \(+1\)-eigenline, and that the four incident lines
belong to the four noncentral involutions.  Consequently \(z\) acts as
\(-1\) on \(T_q\mathbf P^2\), and hence acts trivially on the first
exceptional divisor

\[
E_q=\mathbf P(T_q\mathbf P^2).
\]

Let \(m\) be the proper base multiplicity at \(q\), and let
\((p_m,h_{2m})\) be the first nonzero homogeneous jet of the landing map.
The global landing degree is even, so no additional character twist
appears in this local action.

If \(m\) is odd, \(z\) forces \(p_m\) into the two-dimensional
\(-1\)-eigenspace.  The induced map from \(E_q\simeq\mathbf P^1\) therefore
lands in the genus-one component of \(S^z\).  It must be constant.  Full
\(D_8\)-equivariance would then give a \(D_8\)-invariant line in that
two-dimensional module, which does not exist.  Hence \(m\) is even.

If \(m\) is even, \(z\) forces

\[
p_m=s_m e_z
\]

for a scalar binary form \(s_m\) of degree \(m\) and a vector spanning
\(E_+(z)\).  At the four tangent directions of the incident lines, the
map must eventually take four distinct target values, none equal to
\(\mathbf P(E_+(z))\).  If \(s_m\) were nonzero at one of those directions,
the first blowup would already define the value
\(\mathbf P(E_+(z))\), a contradiction.  Thus \(s_m\) has all four
directions as roots, and

\[
m\ge4.
\]

Each root is still a basepoint on the first blowup, so each incident
direction contributes at least one additional infinitely-near
multiplicity.  At the level of multiplicity and proximity alone, the
lower bounds \(m=4\) and four simple first-near points are numerically
compatible: the leading scalar can be the product of the four tangent
linear forms.  They are not claimed to form a compatible landing cluster.
The later all-degree path obstruction proves that no finite equivariant
resolution can connect the forced endpoint values.

## 3. Triple-point multiplicity

At a triple point the stabilizer is \(S_3\).  Its fixed source line is the
sign character and

\[
T_q\mathbf P^2\simeq\mathrm{Std}.
\]

The plane spanned by the three target eigenlines is another copy of the
standard module.  Hence there is an equivariant linear leading map.  The
exact bitangent calculation in Section 1 says that the Klein quartic on
this plane is a square quadratic, so this linear map lifts to one of the
two exceptional curves above the bitangent.  Therefore multiplicity one
is locally allowed, and the exact mandatory lower bound is only

\[
m_{\mathrm{triple}}\ge1.
\]

## 4. The line sum

Resolve the base ideal and write the pullback of a target line as

\[
\mathcal L=dH-\sum_i m_iE_i.
\]

The strict transform of every \(L_t\) is contracted, so its intersection
with \(\mathcal L\) is zero.  Each line contains four quadruple and four
triple points.  At each quadruple it also contains one of the mandatory
first-near points.  Consequently

\[
0=\mathcal L\cdot\widetilde L_t
\le d-4(4+1)-4,
\]

which gives \(d\ge24\).

This is the same bound as \(Xh\mid J_p\), now recovered from the local
stabilizer geometry.

## 5. Exact numerical slack

At equality, the mandatory cluster is

\[
\begin{array}{c|c|c}
\text{points} & \text{number} & \text{multiplicity}\\ \hline
\text{proper quadruple} & 21 & 4\\
\text{quadruple first-near directions} & 84 & 1\\
\text{proper triple} & 28 & 1.
\end{array}
\]

Thus

\[
\sum m_i^2=21\cdot16+84+28=448,
\qquad
\mathcal L^2=24^2-448=128.
\]

After these blowups, each contracted involution line has
self-intersection

\[
1-8-4=-11,
\]

and distinct line transforms are disjoint.  The central exceptional
curve over each quadruple point has self-intersection \(-5\) and
intersection zero with \(\mathcal L\).  Hence the known contracted curves
already have a negative-definite intersection matrix, exactly as Hodge
index requires.

There is equally explicit slack above degree 24.  A generic \(G\)-orbit on
the line union has size \(84\) and meets each line in four points.  The
two order-four eigenlines in each \(L_t\) form an orbit of size \(42\),
meeting each line in two points.  Write

\[
d=24+4q+2\epsilon,\qquad q\ge0,\quad\epsilon\in\{0,1\}.
\]

Adding \(q\) simple size-84 orbits and, when \(\epsilon=1\), one simple
size-42 orbit makes every contracted-line sum equal to \(d\).  The
resulting necessary self-intersection is

\[
\mathcal L^2=
\begin{cases}
16q^2+108q+128,&\epsilon=0,\\
16q^2+124q+186,&\epsilon=1.
\end{cases}
\]

Both expressions are positive and even for all \(q\ge0\).  These are
formal basepoint clusters satisfying the line-sum, parity, proximity, and
Hodge-sign necessary conditions; they are not asserted to arise from
actual landing covariants.  They show precisely why those numerical
conditions alone cannot exclude any remaining even degree.

## Replay

From the repository root:

~~~text
PYTHONPATH=certificates python3 certificates/klein_arrangement_basepoint_audit.py
~~~

The final marker is

~~~text
KLEIN_ARRANGEMENT_BASEPOINT_AUDIT_OK
~~~
