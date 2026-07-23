# One nonproper singleton in the \([3,2^7]\) profile

## Statement and scope

Let

\[
0\longrightarrow \mathscr K\longrightarrow O_{\mathbf P^2}^{3}
\xrightarrow{\ \sigma\ }O_{\mathbf P^2}(2)\longrightarrow0
\]

be defined by a base-point-free quadratic triple, and let
\(B=\sigma^t\operatorname {adj}(A)\sigma\) be its reduced degree-twelve
branch for a general bidegree-\((2,4)\) equation.  There is no rational
squarefree branch with profile

\[
\boxed{[3,2^7]}
\tag{0.1}
\]

in the following Enriques stratum:

1. the \(t=3\) center is proper;
2. the seven \(t=2\) centers lie in seven distinct proper-origin trees;
3. six of those centers are their proper origins; and
4. the seventh is the first free point over its proper origin and has no
   essential predecessor.

Thus, after the all-proper exclusion, a base-point-free survivor in the
seven-singleton partition would need at least two nonproper singleton
trees.  The doubled sextic adjoint gives the opposite bound of three, so
the exact singleton boundary left by this note is two or three nonproper
trees.  This note does not treat repeated essential trees, a nonproper
\(t=3\) center, those two remaining singleton counts, or a triple with an
isolated base scheme.

The proof extends the seven-cubic block argument in
[`k2_remaining_all_proper_adjoint_reduction.md`](k2_remaining_all_proper_adjoint_reduction.md).
The new point is a pair of exact one-variable determinant-jet bounds which
recovers the tangent condition hidden when a nonproper singleton is pushed
down to its proper origin.

## 1. The unique nonproper singleton

Write \(p\) for the proper \(t=3\) center, write
\(P_1,\ldots,P_6\) for the six proper \(t=2\) centers, and write

\[
a<q
\tag{1.1}
\]

for the remaining singleton tree, with \(q\) free first-near to \(a\).
The minimal-essential lemma gives the exact local data

\[
(r_a,r_q)=(3,4),\qquad (m_a,m_q)=(3,3).
\tag{1.2}
\]

In particular, the line \(T\) representing the marked direction
\(a<q\) has branch contact at least six along that path.

The adjoint weight at \(q\) is one.  Its complete ideal pushes down merely
to \(\mathfrak m_a\): it remembers the origin but not the tangent
direction.  Consequently the cubic adjoint cluster is

\[
D=2p+P_1+\cdots+P_6+a.
\tag{1.3}
\]

It has exact colength ten, and rationality says
\(H^0(\mathcal J_D(3))=0\).  Cubic evaluation is therefore an
isomorphism.  For each one of the seven low labels, deleting that label
selects a unique projective cubic \(C_i\), and the deleted origin does not
lie on \(C_i\).

There is also an exact upper bound valid for the entire seven-singleton
partition.  If \(n\) of the seven low singletons are nonproper, the doubled
adjoint weight two pushes down to \(\mathfrak m_P^2\), of colength three,
at a proper singleton, and to the tangent ideal \((x^2,y)\), of colength
two, at a nonproper singleton.  The high weight four has colength ten.
All eight proper origins are distinct, so

\[
\ell(O/\mathcal J_{2D})
=10+3(7-n)+2n=31-n.
\tag{1.4}
\]

The second rationality condition
\(H^0(\mathcal J_{2D}(6))=0\) injects the twenty-eight-dimensional sextic
space into this quotient.  Hence

\[
28\le31-n,\qquad\boxed{n\le3}.
\tag{1.5}
\]

Together with the all-proper theorem and the present \(n=1\) exclusion,
this leaves exactly \(n=2,3\) in the seven-singleton partition.

## 2. Two six-jet lemmas

Put \(R=k[t]/(t^6)\), and let \(U_d\subset R\) be the image of the
polynomials of degree at most \(d\).  Multiplying every \(U_d\) by the
same unit does not change any assertion below.

### 2.1 A point outside the selected cubic

Fix an affine translate of one of the two twelve-dimensional spaces

\[
U_3\oplus U_3\oplus U_3,
\qquad
R\oplus U_3\oplus U_1.
\tag{2.1}
\]

For coordinates \((A,B,C)\), the locus

\[
AC-B^2=0\quad\text{in }R
\tag{2.2}
\]

has dimension at most six in the first space and at most seven in the
second.  Hence its codimension is at least six and five, respectively.

Here is a direct boundary audit.  In the second space stratify by
\(s=\operatorname {ord}(C)\).  For \(C\ne0\), multiplication by \(C\)
on the unrestricted \(R\)-summand has kernel dimension \(s\), while
\(B^2\in(C)\) forces
\(\operatorname {ord}(B)\ge\lceil s/2\rceil\).  The dimensions for
\(s=0,1,2,3,4,5\) are at most

\[
6,5,5,5,6,6.
\]

On \(C=0\), one has \(B^2=0\), so \(B\in(t^3)\); this boundary has
dimension at most \(6+1=7\).

Here is the full balanced audit, including the unit boundary.  If
\(s=\operatorname {ord}(C)=1,\ldots,5\), the choices of \(C\), the
necessary condition
\(\operatorname {ord}(B)\ge\lceil s/2\rceil\), and the intersection of
the multiplication kernel with \(U_3\) have respective dimensions at
most

\[
\max(4-s,0),\qquad
4-\lceil s/2\rceil,
\qquad
\max(s-2,0).
\tag{2.2a}
\]

Their sums are \(6,5,4,4,4\).  On \(C=0\), one has
\(B\in(t^3)\), so that boundary has dimension at most \(4+1=5\).

It remains only to take \(C\) a unit.  If
\(r=\operatorname {ord}(B)\ge2\), the choices of \((B,C)\) already
have dimension at most \(2+4=6\).  If \(r=1\), the coefficient of
\(t^4\) in \(B^2/C\) contains \(2b_1b_3/c_0\); since
\(b_1c_0\ne0\), prescribing that coefficient solves for \(b_3\) and
again leaves dimension at most six.

Finally suppose that both \(B\) and \(C\) are units.  Make the invertible
change of truncated-jet coordinates

\[
(B,C)\longleftrightarrow(B,A=B^2/C).
\]

The degree-four and degree-five coefficients of \(B\) and \(A\) are
already fixed, so their lower coefficients give an eight-dimensional
space.  We must prescribe the last two coefficients of
\(C=B^2/A\).  Put \(e=B/A\).  The Jacobian of those two coefficients
with respect to \((b_3,a_3)\) is, up to a nonzero scalar,

\[
\det\begin{pmatrix}
2e_1&-(e^2)_1\\
2e_2&-(e^2)_2
\end{pmatrix}
=-2e_1^3.
\tag{2.2b}
\]

On \(e_1=0\), the Jacobian with respect to \((b_2,a_3)\) has determinant
\(-4e_0e_2^2\).  Thus the two prescribed coefficients cut codimension
two unless \(e_1=e_2=0\).  That exceptional locus itself has codimension
two in the eight-dimensional unit-jet space, and hence has dimension at
most six even if both equations vanish there.  This proves the balanced
bound uniformly for every affine translate, including every dependent-
Jacobian fiber.

### 2.2 A transverse point on the selected cubic

Suppose now that the selected cubic is smooth at \(a\) and transverse to
the marked line \(T\).  Differences of extensions vanish once along
\(C\cap T\).  The relevant affine translation spaces are therefore

\[
tU_3\oplus tU_3\oplus tU_3
\tag{2.3}
\]

in the balanced case, and

\[
tR\oplus tU_3\oplus tU_1
\tag{2.4}
\]

in the unbalanced case, where \(tR\) has dimension five.  Requiring
determinant contact six cuts these spaces in codimension at least four and
three, respectively.

To see the worst boundary, translate to a solution.  If its constant
symmetric matrix has rank one, put a unit in a diagonal entry.  The
determinant equations successively solve the available coefficients of
the opposite diagonal entry; in (2.4) the first two are solved and the
coefficient of \(t^3\) supplies a third independent equation.  If the
constant matrix has rank zero, divide all entries by \(t\).  The balanced
problem becomes the full determinant-zero fiber over
\(k[t]/(t^4)\), of codimension four.  In the unbalanced problem the
effective spaces have dimensions \((4,4,2)\); the valuation strata of the
last entry have dimensions at most six inside dimension ten, again giving
codimension four.  Thus the rank-one unbalanced boundary is the unique
worst value, namely three.

### 2.3 Why these are the actual extension spaces

For a selected cubic \(C\), extensions of a fixed restriction differ by

\[
V=H^0(\mathcal Q_2(-3)),\qquad \dim V=18.
\tag{2.5}
\]

For every line \(T\), the sequence obtained by restricting
\(\mathcal Q_2(-3)\) to \(T\) is onto because
\(H^1(\mathcal Q_2(-4))=0\).  The two splitting types give

\[
\mathcal Q_2(-3)|_T\simeq
O_T(3)^3
\quad\text{or}\quad
O_T(5)\oplus O_T(3)\oplus O_T(1).
\tag{2.6}
\]

If \(a\notin C\), multiplication by the equation of \(C\) is a unit at
\(a\), giving (2.1).  If \(a\in C\) transversely to \(T\), it has a
simple zero, giving (2.3)--(2.4).  Thus the preceding Artin-ring bounds
apply inside the actual eighteen-dimensional extension fiber.  They
include the zero-matrix and every rank boundary.

## 3. Every integral deleted cubic is excluded

First delete the nonproper label \(q\), equivalently its pushed-down
origin \(a\).  The selected cubic is double at \(p\), passes through all
six \(P_i\), and avoids \(a\).  If it is integral, its marked branch
contact is

\[
2\cdot6+6\cdot4=36=\deg(B|_C).
\tag{3.1}
\]

The integral-cubic determinant estimate gives a bad subspace of dimension
at most twenty-four inside the fifty-four-dimensional cubic restriction
image, hence fixed codimension thirty.  The omitted path has contact six
on \(T\).  Section 2.1 adds codimension six when \(T\) is balanced and
five when it is unbalanced.  An unbalanced marked line costs one parameter
in the joint \((\sigma,T)\)-space.  The margins are therefore

\[
\begin{aligned}
30+6-(14+3+17)&=2,\\
30+5-(14+3+16)&=2.
\end{aligned}
\tag{3.2}
\]

Here fourteen moves \(p,P_1,\ldots,P_6\), while three moves the omitted
origin and its tangent direction.

Now delete one of the proper labels.  The selected cubic contains \(a\),
the other five proper low centers, and the remaining proper center count
is therefore five.  If the cubic is singular at \(a\), or its strict
transform follows the marked direction \(T\), its contact is at least

\[
2\cdot6+5\cdot4+(m_a+m_q)=38>36.
\tag{3.3}
\]

It would be an integral cubic branch component, which is already absent on
the base-point-free locus.  Otherwise it is smooth at \(a\) and transverse
to \(T\).  Its visible contact is

\[
2\cdot6+5\cdot4+m_a=35,
\tag{3.4}
\]

so the determinant target has dimension two.  The fixed cubic-restriction
codimension is at least \(54-(23+2)=29\).  Section 2.2 adds four in the
balanced case and three in the unbalanced case.  Forget the omitted proper
center entirely.  The resulting margins are

\[
\begin{aligned}
29+4-(14+1+17)&=1,\\
29+3-(14+1+16)&=1.
\end{aligned}
\tag{3.5}
\]

The additional one parameter is the tangent direction at \(a\), already
separate from the fourteen parameters of the selected proper origins.
Thus every one of the seven deleted cubics is reducible or nonreduced.

## 4. The block cover still produces two components

Use the same forty-two labeled blocks as in the all-proper theorem:

\[
P_{ij}: p,P_i,P_j\text{ collinear},
\qquad
Q_{ij}: p\text{ and the other five low origins lie on a conic}.
\tag{4.1}
\]

The label \(a\) is allowed in either pair.  Every reducible deleted cubic
again supplies a block covering its omitted label.  The capacity audit has
only one new boundary.  A line through \(p\) and two low origins has
contact at least

\[
6+4+3=13>12,
\tag{4.2}
\]

so every \(P\)-block gives a branch line.  An integral \(Q\)-conic has
contact at least

\[
6+4\cdot4+3=25>24,
\tag{4.3}
\]

so it is a branch component.

If a \(Q\)-conic splits and its component through \(p\) contains two low
origins, that component is a \(P\)-line.  If it contains at most one, the
other line contains at least four low origins and is a branch component.
The latter exceptional line necessarily contains \(a\) and three proper
low origins.  For a fixed such line, all \(Q\)-blocks which produce it
cover labels only in the three-element complement of its four low labels.

This observation is enough to retain the final set-cover step.  A single
branch component can account for covered labels in a set of size at most

\[
5\quad\text{for a line through }p,\qquad
3\quad\text{for an exceptional four-low line},\qquad
2\quad\text{for an integral conic}.
\tag{4.4}
\]

Indeed, a line through \(p\) contains at most two low origins in a
squarefree branch, so its pair is fixed and its \(P\)-cover is the
five-element complement.  A conic contains at most five low origins: if
it contained six, subtracting it once would leave contact at least

\[
(6-1)+5(4-1)+(3-1)=22>20
\tag{4.5}
\]

on the residual degree-ten branch.  Formula (4.4) now follows also for
all repeated appearances of the same component.

A nonreduced deleted cubic causes no gap.  If \(a\) is omitted, its two
supports cover at most five of the six selected proper lows.  If \(a\) is
selected, the only new capacity boundary is
\(2L+M\), where \(L\) passes through \(p\) and two lows while \(M\)
contains \(a\) and three proper lows.  Both \(L\) and \(M\) are branch
lines by (4.2) and by contact fifteen on \(M\).  It already supplies the
forbidden pair.

Since the seven omitted labels are covered, (4.4) proves that at least two
distinct integral branch components of degree at most two occur.  The
factor-pair theorem in Section 7 of
[`k2_remaining_all_proper_adjoint_reduction.md`](k2_remaining_all_proper_adjoint_reduction.md)
excludes such a pair for a general base-point-free equation.  This proves
the theorem.

The Artin-ring dimensions, contact capacities, and all incidence margins
are replayed by
[`k2_profile327_one_nonproper_singleton_checks.py`](k2_profile327_one_nonproper_singleton_checks.py).
