# Integral-quintic squares transverse to a reduced isolated base

## Statement

Let \(\sigma\) be a primitive quadratic triple whose base cluster has
simple proper centers, and let \(T\) be an integral plane quintic.  Suppose
that every base center lying on \(T\) is a smooth point of \(T\), that the
intersection is simple, and that at least one base center lies on \(T\).
For a general symmetric quartic matrix \(A\), there is no connected
factorization

\[
B_\sigma=T^2C,
\qquad 0\ne C\text{ a reduced conic}.
\tag{0.1}
\]

At this stage, together with
[`k2_isolated_quintic_offbase_exclusion.md`](k2_isolated_quintic_offbase_exclusion.md),
this left only integral quintics tangent or singular at a base point, or
quintics meeting an infinitely-near or multiplicity-two base cluster.
Those cases are subsequently excluded in
[`k2_isolated_quintic_base_cluster_exclusion.md`](k2_isolated_quintic_base_cluster_exclusion.md),
closing the connected isolated-base integral-quintic square-root row.  The
degree-zero quotient boundary there is a disconnected pure square, not a
blanket component exclusion.

## 1. Restriction image after \(h\) simple base intersections

Let the full simple base scheme have length \(l\), and suppose \(T\)
contains exactly \(h\) of its proper reduced points.  On the base
resolution,

\[
R=2H-\sum_{i=1}^lE_i,
\qquad
\widetilde T=5H-\sum_{i=1}^hE_i.
\]

The divided triple generates \(O(R)\), and its quadratic forms have the
symmetric presentation

\[
0\longrightarrow3O(4H-R)\longrightarrow6O(4H)
\longrightarrow\mathcal Q\longrightarrow0.
\tag{1.1}
\]

Each quartic coefficient restricts to a fifteen-dimensional space on the
integral quintic: a plane quartic vanishing on \(T\) is zero.  Along
\(\widetilde T\), the relation line in (1.1) is

\[
O_{\widetilde T}(4H-R)
=O_T(2)(p_1+\cdots+p_h).
\tag{1.2}
\]

Here blowing up a smooth point of the curve does not change the curve, and
\(p_i\) denotes the corresponding point on it.  Plane restriction gives
\(h^0(O_T(2))=6\); adding \(h\) points increases \(h^0\) by at most
\(h\).  Therefore the kernel of coefficient restriction to the quadratic
form on \(\widetilde T\) has dimension at most \(3(6+h)\).  Its image has
dimension at least

\[
\boxed{I_h=90-3(6+h)=72-3h.}
\tag{1.3}
\]

On the normalization of \(T\), the resolved dual kernel is globally
generated of degree

\[
f=R\cdot\widetilde T=10-h,
\tag{1.4}
\]

while the quadratic-form twist still has degree twenty.

## 2. Rank-one and curve-family bounds

Let \(M\) be the saturated image line of the nonzero rank-one restriction,
put \(m=\deg M\), and let

\[
d=\deg(F/M)=f-m.
\]

The local affine dimension of this rank-one stratum is at most

\[
D(f,m)=\max\{f-2m+1,0\}+\max\{2m+21,0\}.
\tag{2.1}
\]

The quotient \(F/M\) is globally generated.  Splitting according to its
degree gives the following uniform bounds for \(1\le h\le4\):

\[
\begin{array}{c|c|c}
d&\max D(f,m)&\dim\{T\}\\ \hline
d\ge4&32-h&\le20-h\\
d=3&33,31,29,28\ (h=1,2,3,4)&\le\min\{19,20-h\}\\
d=2&37-2h&\le\min\{17,20-h\}\\
d=1&39-2h&\le\min\{14,20-h\}.
\end{array}
\tag{2.2}
\]

The first curve bound records the \(h\) imposed points.  For \(d=3\),
the quotient pencil forces gonality at most three, so a plane quintic is
singular.  For \(d=2\), Castelnuovo--Severi gives normalization genus at
most three.  For \(d=1\), the normalization is rational.  The dimensions
19, 17, and 14 are the corresponding equigeneric bounds.  Taking the
minimum with the point-condition dimension is always safe.

There is again no rank-zero restriction row contributing to (0.1).  Its
image is the origin of the target in (1.3), so its fixed-coefficient
codimension is at least \(I_h\), before the curve and triple parameters
move.  Even in the worst row this leaves

\[
(72-3h)-(20-h)-\dim\{\sigma\}\ge31,
\]

far stronger than needed.  Thus the coefficient-relation kernel has not
been silently counted as a family of rank-one forms.

## 3. Exhaustive strict margins

The possible reduced proper base schemes and maximal triple-stratum
dimensions are

\[
\begin{array}{c|c|c}
\operatorname {rank}(\sigma)&l&\dim\{\sigma\}\\ \hline
3&1&16\\
3&2&15\\
3&3&14\\
2&4&13.
\end{array}
\tag{3.1}
\]

For every \(1\le h\le l\), subtract from the image lower bound
\(I_h=72-3h\) the appropriate two entries of (2.2) and the triple
dimension in (3.1).  The smallest margin in each quotient-degree column is

\[
\begin{array}{c|cccc}
d&\ge4&3&2&1\\ \hline
\text{minimum margin}&3&1&1&2.
\end{array}
\tag{3.2}
\]

All margins are strict.  Thus no rank-one restriction with \(d>0\) occurs
for a general equation.

If \(d=0\), the quotient is trivial and its dual gives a constant relation
among the divided triple along \(\widetilde T\).  Away from the finitely
many base points this says that a constant linear combination of the plane
quadrics vanishes on \(T\), hence vanishes identically.  The triple has
rank two.  In rank two,

\[
\mathscr K=O\oplus O(-R).
\]

The degree-\(f\) image line is the \(O(R)|_{\widetilde T}\) summand.  If
\(q=(a,b;b,c)\), support on its square gives \(a|_T=0\).  The coefficient
\(a\) is a plane quartic, so \(a=0\) and \(\det q=-b^2\) is a pure square.
It cannot yield the nonzero reduced residual conic in (0.1).

This completes the transverse proper-base exclusion.  The image bounds and
all \((l,h,d)\) margins are replayed by
[`k2_isolated_quintic_transverse_base_checks.py`](k2_isolated_quintic_transverse_base_checks.py).
