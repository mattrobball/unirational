# Exclusion of degree-two square roots on the base-point-free \(k=2\) locus

## Statement

Let \(\sigma=(\sigma_0,\sigma_1,\sigma_2)\) be a base-point-free triple of
plane quadrics and let

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma
\]

be the degree-twelve branch associated with a bidegree-\((2,4)\) equation.
For a general equation there is no factorization

\[
\boxed{B_\sigma=G^2C,\qquad \deg G=2.}
\tag{0.1}
\]

Thus the entire \(e=2\) square-factor row of
[k2_double_dodecic_frontier.md](k2_double_dodecic_frontier.md) is absent
on the base-point-free quadratic-triple locus.

Over \(\mathbf C\), a quadratic \(G\) is an integral conic, a product of
two distinct lines, or a doubled line.  The three cases are treated
separately below.  The theorem does not include primitive triples with an
isolated base scheme, and it makes no assertion about the other
square-factor degrees.

## 1. The common restriction image

For

\[
0\longrightarrow\mathscr K\longrightarrow O^3
\xrightarrow{\ \sigma\ }O(2)\longrightarrow0,
\qquad
\mathcal Q_2=\operatorname {Sym}^2(\mathscr K^\vee)\otimes O(4),
\]

one has

\[
0\longrightarrow3O(2)\longrightarrow6O(4)
\longrightarrow\mathcal Q_2\longrightarrow0,
\qquad h^0(\mathcal Q_2)=72.
\tag{1.1}
\]

Let \(D\) be any effective plane Cartier divisor of degree four, including
\(2C\), \(2L_1+2L_2\), or \(4L\).  Twisting (1.1) by \(-4\) gives

\[
h^0(\mathcal Q_2(-4))=6.
\]

Multiplication by the equation of \(D\) identifies this space with the
kernel of restriction.  Hence every degree-four divisor used below has
restriction image

\[
\boxed{I_D=72-6=66.}
\tag{1.2}
\]

The ninety-dimensional equation space maps onto
\(H^0(\mathcal Q_2)\), with the eighteen multiples of \(L_\sigma\) as
kernel.  The codimensions below therefore pull back unchanged to equations.

## 2. First neighborhoods of lines

On a balanced line,

\[
\mathscr K^\vee|_L=O(1)^2,\qquad
\mathcal Q_2|_L=O(6)^3.
\]

Write a section on \(2L\) as \(q=q_0+tq_1\), where the three entries of
\(q_0\) have degree six and those of \(q_1\) have degree five.  The target
has dimension \(21+18=39\).  The zero-determinant cone for \(q_0\) has
dimension at most eight.  For every nonzero rank-one \(q_0\), the
linearized determinant on \(q_1\) has rank at least six.  Including the
zero and diagonal boundaries gives

\[
\boxed{\dim\{\det q\equiv0\pmod {t^2}\}\le20.}
\tag{2.1}
\]

On an unbalanced line,

\[
\mathscr K^\vee|_L=O\oplus O(2).
\]

The degree patterns of \(q_0,q_1\) are respectively

\[
(4,6,8),\qquad(3,5,7).
\]

The nonboundary UFD strata
\(q_0=h(u^2,uv,v^2)\) give dimension at most eighteen after the
linearized equation.  The boundary \(q_0=(0,0,c)\), with
\(\deg c=8\), has dimension nine and leaves a fourteen-dimensional kernel
in the eighteen-dimensional \(q_1\)-space.  This is the largest row:

\[
\boxed{\dim\{\det q\equiv0\pmod {t^2}\}\le23.}
\tag{2.2}
\]

These bounds allow the determinant to vanish identically on \(L\).

## 3. Two distinct lines

Suppose \(G=L_1L_2\) with \(L_1\ne L_2\).  Restriction to

\[
D=2L_1+2L_2
\]

embeds the 66-dimensional image (1.2) in the product of the two
39-dimensional first-neighborhood spaces.  Forgetting their compatibility
at \(L_1\cap L_2\) only enlarges the bad locus.

If at least one line is balanced, (2.1)--(2.2) give bad-product dimension
at most \(20+23=43\), hence fixed codimension at least

\[
66-43=23.
\]

The triple and the two lines move in dimension at most \(17+4=21\), leaving
codimension at least two.

If both lines are unbalanced, the bad-product dimension is at most
\(23+23=46\), so the fixed codimension is twenty.  The relevant moving
stratum has dimension at most nineteen.  Indeed, for a fixed line \(L\),
unbalancedness says that the \(3\times3\) matrix of the restrictions
\(\sigma_i|_L\in H^0(O_L(2))\) has zero determinant.  This is an
irreducible hypersurface in \(\mathbf P^{17}_\sigma\).  For two distinct
lines the two determinant hypersurfaces are distinct, and hence their
intersection has codimension two.  Allowing the two lines to move gives

\[
(17-2)+4=19.
\]

The remaining codimension is one.  Thus a general equation has no
base-point-free triple for which \(L_1^2L_2^2\mid B_\sigma\).

## 4. A doubled integral conic

Let \(C\) be an integral conic and normalize it as \(\mathbf P^1\).  Write

\[
\mathscr K^\vee|_C=O(\alpha)\oplus O(4-\alpha),
\qquad0\le\alpha\le2.
\]

On the first neighborhood \(2C\), the degree patterns of \(q_0\) and its
normal coefficient \(q_1\) are

\[
\begin{aligned}
q_0 &: (2\alpha+8,\ 12,\ 16-2\alpha),\\
q_1 &: (2\alpha+4,\ 8,\ 12-2\alpha).
\end{aligned}
\tag{4.1}
\]

Their dimensions are 39 and 27, totaling 66 as in (1.2).  Stratify the
zero-determinant \(q_0\)'s by the UFD form
\(h(u^2,uv,v^2)\) and its two diagonal boundaries.  On a nonboundary
stratum the form space has dimension fourteen and the kernel of the
linearized determinant has dimension at most
\(14+2\alpha-2s\), where \(s=\deg u\); the total is at most thirty-two.
The two diagonal totals are

\[
39-4\alpha,\qquad23+4\alpha.
\]

For \(0\le\alpha\le2\), every row is at most thirty-nine.  Therefore

\[
\boxed{\dim\{\det q\equiv0\pmod {I_C^2}\}\le39.}
\tag{4.2}
\]

The omitted zero leading form causes no larger boundary: if \(q_0=0\),
then the determinant already vanishes modulo \(I_C^2\) and \(q_1\) is
arbitrary, giving dimension \(27<39\).

The fixed codimension in the 66-dimensional image is at least 27.  An
integral conic moves in dimension five, so after allowing both \(C\) and
\(\sigma\) to move, the remaining codimension is

\[
27-(5+17)=5.
\tag{4.3}
\]

Hence \(C^2\nmid B_\sigma\) for a general equation.

## 5. A fourth-order line

It remains to treat \(G=L^2\), which would imply \(L^4\mid B_\sigma\).
Write on \(4L\)

\[
q=q_0+tq_1+t^2q_2+t^3q_3.
\]

At each positive order the new determinant equation is linear in \(q_i\)
with linear part \(D\det(q_0)\).  The UFD stratification therefore gives
an exact uniform dimension bound by adding the kernels of this same
linearized determinant in the three successive degree layers.

For a balanced line the layer dimensions are \(21,18,15,12\).
The nonboundary rank-one strata of \(q_0\) have dimension eight.  If the
common factor \(h\) has degree \(d=0,2,4,6\), the three kernel dimensions
are

\[
6+d,\qquad4+d,\qquad2+d.
\]

The maximum total is

\[
8+(12+3d)\le38.
\tag{5.1}
\]

For an unbalanced line the layer degree patterns are

\[
(4-i,\ 6-i,\ 8-i),\qquad i=0,1,2,3.
\]

The nonboundary rows total at most thirty-two.  The boundary
\(q_0=(0,0,c_8)\) is largest: it has dimension nine, while the three
linearized kernels have dimensions \(14,12,10\).  Hence

\[
\boxed{
\dim\{L^4\mid\det q\}\le
\begin{cases}
38,&L\text{ balanced},\\
45,&L\text{ unbalanced}.
\end{cases}}
\tag{5.2}
\]

These maxima also include the zero-leading-form boundary.  If \(q_0=0\),
the remaining equations are

\[
\det(q_1)=0,
\qquad D\det(q_1)(q_2)=0,
\]

while \(q_3\) is free.  The same UFD calculation gives total dimension at
most \(29\) in the balanced case and \(32\) in the unbalanced case, both
strictly below the bounds in (5.2).

In the balanced case the fixed codimension is \(66-38=28\), while
\((\sigma,L)\) moves in dimension nineteen.  In the unbalanced case the
fixed codimension is \(66-45=21\).  The universal unbalanced pair locus is
the single determinant hypersurface described in Section 3, so it has
dimension \(17+2-1=18\).  The remaining codimensions are respectively
nine and three.  Thus \(L^4\nmid B_\sigma\) for a general equation.

Sections 3--5 exhaust degree-two plane quadrics \(G\), proving (0.1).
The arithmetic and every stratum margin are replayed by
[k2_basepointfree_degree2_square_checks.py](k2_basepointfree_degree2_square_checks.py).
