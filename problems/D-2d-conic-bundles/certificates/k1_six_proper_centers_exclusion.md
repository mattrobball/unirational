# Exclusion of line components and six proper essential centers

## Statement

Let

\[
X=(x^tA(y)x=0)\subset \mathbf P^2_x\times\mathbf P^2_y
\]

be a general hypersurface of bidegree \((2,4)\), and let
\(B_\sigma=\sigma^t\operatorname {adj}(A)\sigma\) be the degree-ten branch
attached to a rank-two or rank-three section of class \((1,1)\).

This note proves two assertions.

1. No such \(B_\sigma\) has a line component.
2. No such \(B_\sigma\) has six distinct proper points of multiplicity at
   least four which impose independent conditions on conics.

Consequently, the all-proper subrow of the squarefree six-\(t=2\) frontier in
[`k1_double_decic_frontier.md`](k1_double_decic_frontier.md) is empty.  In
that row the first cluster vanishing

\[
H^0(\mathcal J_D(2))=0
\]

says exactly that the six proper centers impose independent conditions on
conics.  The second vanishing is not needed for this subrow.

The proof deliberately makes no assertion about infinitely-near essential
centers.  For example, a simple total-transform weight at a first-near center
can ask a conic only to pass through its proper origin.  The corresponding
conic transform can share an odd exceptional branch component, so one cannot
replace the argument below by an unqualified claim of four units of plane
contact per infinitely-near weight.

All dimensions below are affine.  Every locus is a homogeneous cone, so the
same codimensions hold projectively.

## 1. Binary rank-one cones

For three binary forms \((a,b,c)\) with
\(\deg a+\deg c=2\deg b\), the equation

\[
ac-b^2=0
\tag{1.1}
\]

has, away from the one-entry boundaries, the UFD parametrization

\[
(a,b,c)=h(u^2,uv,v^2).
\tag{1.2}
\]

After quotienting the common rescaling of \((h,u,v)\), this gives the
following affine dimensions, including the diagonal boundaries:

\[
\begin{array}{c|ccccc}
(\deg a,\deg b,\deg c)&(6,5,4)&(4,4,4)&(10,10,10)&
(12,10,8)&(10,9,8)\\ \hline
\dim\{ac=b^2\}&7&6&12&13&11.
\end{array}
\tag{1.3}
\]

We also need inverse images of a one-dimensional determinant space.  Let
\(f\) be a binary form with five distinct roots, each of multiplicity four.
Then

\[
\begin{aligned}
\dim\{(a,b,c)\in H^0(O(10))^3:ac-b^2\in kf\}&\le13,\\
\dim\{(a,b,c)\in H^0(O(12))\oplus H^0(O(10))\oplus H^0(O(8)):
ac-b^2\in kf\}&\le14.
\end{aligned}
\tag{1.4}
\]

Here is a complete bound, including multiple-root and zero-entry strata.  In
the first row choose a nonzero diagonal entry \(a\).  For fixed nonzero
\(\lambda f\), restriction of \(b\) to the length-ten zero scheme of \(a\)
has a one-dimensional kernel.  If \(m_i\) is the multiplicity of \(a\) at a
marked root, the local square-root scheme for

\[
z^2=x^4\pmod{x^{m_i}}
\]

has dimension

\[
\delta(m_i,4)=\min\{\lfloor m_i/2\rfloor,2\}\le m_i.
\]

The loss of \(\sum m_i\) parameters in \(a\) pays for these local freedoms.
Thus a fixed nonzero fiber has dimension at most twelve, and allowing
\(\lambda\) gives thirteen.  If \(a=0\) but \(c\ne0\), interchange the two
equal-degree diagonal entries; if \(a=c=0\), then \(b\) is a scalar multiple
of \(\sqrt{-f}\), a still smaller boundary.  The zero fiber has dimension
twelve by (1.3).

For the second row use the degree-eight entry \(c\).  Restriction of the
degree-ten entry \(b\) to \(Z(c)\) has a three-dimensional kernel, giving
the same bound twelve for a fixed nonzero fiber.  There is one larger
boundary: since \(f\) is a square, \(c=0\), \(b=\mu\sqrt{-f}\), and arbitrary
degree-twelve \(a\) form a fourteen-dimensional family.  This proves the
second line of (1.4); in particular this boundary must not be discarded.

Finally, if \(f'\) has four roots of multiplicity four and one root of
multiplicity two, then

\[
\dim\{(a,b,c)\text{ of degrees }(10,9,8):ac-b^2\in kf'\}\le12.
\tag{1.5}
\]

The same proof uses the degree-eight entry and its two-dimensional
restriction kernel.  The largest diagonal boundary is
\(c=0, b=\mu\sqrt{-f'}\), with arbitrary degree-ten \(a\), and has dimension
twelve.

## 2. A line cannot divide the branch

Fix a rank-three \(\sigma\), put

\[
E=\Omega^1_{\mathbf P^2}(1),\qquad
\mathcal Q=\operatorname {Sym}^2(E^\vee)\otimes O(4),
\]

and write \(q\in H^0(\mathcal Q)\) for the restricted quadratic form.  The
symmetric Euler resolution is

\[
0\longrightarrow 3O(3)\longrightarrow6O(4)
\longrightarrow\mathcal Q\longrightarrow0.
\tag{2.1}
\]

It gives \(H^1(\mathcal Q(-1))=0\).  Restriction to any line is therefore
onto

\[
H^0(\mathcal Q)\longrightarrow
H^0\bigl(O_L(6)\oplus O_L(5)\oplus O_L(4)\bigr),
\]

whose target has dimension eighteen.  The condition \(L\mid\det(q)\) is
exactly (1.1).  By (1.3) its fixed-line locus has codimension at least
\(18-7=11\).  Lines move in dimension two, so the fixed-\(\sigma\)
codimension is at least

\[
18-7-2=9>8,
\tag{2.2}
\]

where eight is the projective rank-three matrix-orbit dimension.

For rank two, let \(b\) be the base point of \(\sigma\).  If \(b\notin L\),
restriction is onto the same \((6,5,4)\) space; this follows either directly
from the quartic coefficient groups or from the rank-two incidence sequence.
Thus (2.2) applies, and nine is also larger than the rank-two orbit dimension
seven.

If \(b\in L\), normalize \(L=\{y_1=0\}\).  On the line

\[
B_\sigma|_L=y_0^2(ac-b_1^2),
\]

where \((a,b_1,c)=(A_{11},A_{12},A_{22})|_L\) are arbitrary quartics.  The
target has dimension fifteen and its determinant-zero cone has dimension six
by (1.3).  The pencil of lines through the fixed point \(b\) has dimension
one, leaving

\[
15-6-1=8>7.
\tag{2.3}
\]

Equations (2.2)--(2.3) exclude a line component for a general \(A\) in all
rank and base-point positions.

## 3. Five proper centers lie on a smooth conic

Suppose now that \(B_\sigma\) has six distinct proper points
\(p_1,\ldots,p_6\) of multiplicity at least four and that no conic contains
all six.  Evaluation on the six points is an injective map between
six-dimensional spaces,

\[
H^0(O_{\mathbf P^2}(2))\longrightarrow k^6,
\]

and hence is an isomorphism.  Every five-point subset therefore lies on a
unique conic \(C\).

That conic is smooth.  If it were a doubled line, that line would contain all
five points.  If it were the union of two lines, one of the lines would
contain at least three of the five distinct points.  In either case a line
\(L\) meets the decic \(B_\sigma\) at the selected proper centers with total
intersection multiplicity at least \(3\cdot4=12>10\).  Bezout then makes
\(L\) a component of the branch, contrary to Section 2.

Thus the bad incidence is contained in the incidence of a smooth conic, five
ordered points on it, and multiplicity at least four at those points.  The
sixth center can be forgotten: doing so only enlarges the incidence.

## 4. Restriction to the conic

### 4.1 Rank three

On the normalization \(C\simeq\mathbf P^1\),

\[
E^\vee|_C=O(1)\oplus O(1),\qquad
\mathcal Q|_C=O(10)^3.
\]

The vanishing \(H^1(\mathcal Q(-2))=0\) makes restriction onto this
thirty-three-dimensional space surjective.  At each marked point,
\(B_\sigma|_C\) has order at least four.  Its degree is twenty, so

\[
\det(q|_C)\in k\prod_{i=1}^5\ell_i^4.
\]

By (1.4) the bad part of the target has dimension at most thirteen.  Smooth
conics move in dimension five and five ordered points on one move in
dimension five.  The fixed-\(\sigma\) codimension is therefore at least

\[
33-13-(5+5)=10>8.
\tag{4.1}
\]

### 4.2 Rank two away from the base point

If \(b\notin C\), the resolved kernel dual restricts as
\(O(2)\oplus O\), and the quadratic-form degrees are

\[
(12,10,8).
\]

Restriction is onto the thirty-three-dimensional target.  The second line
of (1.4), including its fourteen-dimensional diagonal boundary, gives

\[
33-14-(5+5)=9>7.
\tag{4.2}
\]

### 4.3 Rank two through the base point

If \(b\in C\), removal of the common base-point factor gives degrees

\[
(10,9,8),
\]

and a thirty-dimensional target; the original branch restriction is
\(s^2\det(q|_C)\), where \(s\) vanishes at the point over \(b\).

If \(b\) is not one of the five marked points, the five order-four conditions
have total degree twenty on the degree-eighteen determinant, forcing
\(\det(q|_C)=0\).  The zero cone has dimension eleven.  Conics through the
fixed point \(b\) move in dimension four and the five points move in
dimension five, so

\[
30-11-(4+5)=10>7.
\tag{4.3}
\]

If \(b\) is one of the marked points, the factor \(s^2\) leaves determinant
orders two at \(b\) and four at the other four points.  Equation (1.5) bounds
the bad target by twelve dimensions.  Now only four marked points move, and

\[
30-12-(4+4)=10>7.
\tag{4.4}
\]

The positions in (4.2)--(4.4) are exhaustive.

## 5. Incidence conclusion

The fixed-rank codimensions are at least ten in rank three and at least nine
in rank two.  They are strictly larger than the projective matrix-orbit
dimensions eight and seven.  Pullback from each complete restriction space
to the space of quartic equations preserves these codimensions.  Therefore a
general \(A\) admits neither a line component nor an all-proper
six-\(t=2\) branch satisfying the first cluster vanishing.

The UFD dimensions and every displayed orbit margin are replayed by
[`k1_six_proper_centers_checks.py`](k1_six_proper_centers_checks.py).
