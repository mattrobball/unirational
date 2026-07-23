# Exclusion of degree-two square roots on the primitive isolated-base locus

## Statement

Let

\[
X=(x^tA(y)x=0)\subset \mathbf P^2_x\times\mathbf P^2_y
\]

be a general hypersurface of bidegree \((2,4)\), let

\[
\sigma=(\sigma _0,\sigma _1,\sigma _2)
\]

be a primitive quadratic triple with a nonempty zero-dimensional base
scheme, and put

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma.
\]

Then there is no factorization

\[
\boxed{B_\sigma=G^2C,\qquad \deg G=2.}
\tag{0.1}
\]

The integral-conic case was excluded in
[`k2_primitive_base_scheme_reduction.md`](k2_primitive_base_scheme_reduction.md).
This note treats the two remaining shapes

\[
G=L_1L_2\quad(L_1\ne L_2),
\qquad G=L^2.
\]

Together with
[`k2_basepointfree_degree2_square_exclusion.md`](k2_basepointfree_degree2_square_exclusion.md),
this excludes the entire degree-two square-factor row on the primitive
quadratic-triple locus.  Common-line and common-conic triples are not
primitive and remain routed to the already settled lower-\(k\) cases.

The point of the proof is that a line through a base cluster cannot be
treated by the base-point-free restriction table.  One must first divide
the common factor of \(\sigma|_L\).  For two distinct lines, a sequential
argument then uses perturbations divisible by the square of the first line;
the second step is governed by the same kernel bundle with twist two
instead of four.

## 1. The four line types

Resolve the base ideal

\[
\pi:S\longrightarrow\mathbf P^2,
\qquad
R=2H-M,
\]

and let \(\mathscr K\) be the resolved kernel bundle

\[
0\to\mathscr K\to O_S^3\xrightarrow{\sigma}O_S(R)\to0.
\tag{1.1}
\]

The residual quadratic form is a section of

\[
\mathcal Q=
\operatorname {Sym}^2(\mathscr K^\vee)\otimes O_S(4H).
\tag{1.2}
\]

Let \(\widetilde L\) be the strict transform of a plane line.  If the
base cluster is simple, let \(h\) be the length of the complete subcluster
lying on \(L\).  Primitivity gives \(h\le2\).  Then

\[
d=R\cdot\widetilde L=2-h,
\qquad
s=\widetilde L^2=1-h.
\tag{1.3}
\]

After dividing the common degree-\(h\) factor of \(\sigma|_L\), the
splitting of \(\mathscr K^\vee|_{\widetilde L}\) and the three degrees of
the leading quadratic form are as follows.

\[
\begin{array}{c|c|c|c}
h&\mathscr K^\vee|_{\widetilde L}&q_0\text{ degrees}&s\\ \hline
0&O(1)^2\text{ or }O\oplus O(2)&(6,6,6)\text{ or }(4,6,8)&1\\
1&O\oplus O(1)&(4,5,6)&0\\
2&O^2&(4,4,4)&-1.
\end{array}
\tag{1.4}
\]

At a multiplicity-two base point, every line through the point has a
degree-two common restriction factor, but only one blowup is made.  The
last row is therefore replaced by

\[
\mathscr K^\vee|_{\widetilde L}=O^2,
\qquad q_0:(4,4,4),
\qquad s=0.
\tag{1.5}
\]

On the first neighborhood, the next layer has the degrees of \(q_0\)
minus \(s\).  The complete UFD calculation gives

\[
\begin{array}{c|c|c|c}
\text{line type}&\dim H^0(\mathcal Q|_{2\widetilde L})
&\dim\{\det q=0\text{ on }2\widetilde L\}
&\text{label}\ \beta\\ \hline
h=0,\text{ balanced}&39&20&20\\
h=0,\text{ unbalanced}&39&23&23\\
h=1&36&20&20\\
h=2,\text{ simple}&33&18&18\\
m=2&30&16&16.
\end{array}
\tag{1.6}
\]

The corresponding fourth-neighborhood bad dimensions are

\[
38,\quad45,\quad46,\quad48,\quad36,
\tag{1.7}
\]

in the same order.  We will use (1.6) for two distinct lines.  For a
fourth-order line, the actual plane-coefficient filtration is sharper than
subtracting (1.7) from a possibly defective restriction image; Section 3
uses that sharper filtration.

## 2. The binary UFD calculation

Here is the calculation behind all later bounds.  Suppose

\[
q_0=(a,b,c),
\qquad
(\deg a,\deg b,\deg c)=(A,B,C),
\qquad A+C=2B.
\]

Every nonboundary point of \(ac-b^2=0\) has the form

\[
q_0=h(u^2,uv,v^2),
\tag{2.1}
\]

where

\[
\deg h=\delta,
\quad
\deg u=(A-\delta)/2,
\quad
\deg v=(C-\delta)/2.
\]

This stratum has affine dimension \(B+2\).  If the next layer is shifted
by \(k\), the kernel of the linearized determinant has dimension

\[
\boxed{B+\delta+2k+2.}
\tag{2.2}
\]

Indeed, after removing \(h\), the image is the degree piece of
\((u,v)^2\).  The two Hilbert--Burch syzygies have degrees
\(2\deg u+\deg v\) and \(\deg u+2\deg v\), which gives (2.2).

The diagonal boundary \((0,0,c)\) has dimension \(C+1\), and its
linearized kernel consists of the free \(b_1,c_1\) entries.  The opposite
diagonal is analogous.  The zero leading form is treated one order later.
Applying these three rows gives exactly (1.6)--(1.7).  In particular, no
zero-determinant component is omitted.

## 3. A fourth-order line

Assume \(L^4\mid B_\sigma\).  Expand the six quartic coefficients of the
equation in a plane normal parameter to \(L\).  Conditional on all lower
orders, the equation at order \(i\) is affine-linear in the order-\(i\)
coefficient, with linear part \(D\det(q_0)\).  Thus the dimensions of the
successive kernels may be added.

### 3.1 The line avoids the base scheme

The base-point-free fourth-line calculation applies verbatim.  Its fixed
codimension is at least twenty-eight on a balanced line and twenty-one on
an unbalanced line.  An isolated-base triple has dimension at most sixteen,
and the line adds two parameters.  The worst margin is therefore

\[
21-(16+2)=3.
\tag{3.1}
\]

### 3.2 One simple center on the line

Let \(g\) be the degree-one common factor of \(\sigma|_L\).  The leading
target has degrees \((4,5,6)\) and dimension eighteen.  Varying only the
order-\(i\) coefficient of the plane quartic matrix supplies

\[
g^iH^0\bigl((4-i,5-i,6-i)\bigr),
\tag{3.2}
\]

of dimensions fifteen, twelve, and nine for \(i=1,2,3\).

On a nonboundary UFD row, the leading rank-one cone has dimension seven,
so it costs eleven conditions.  Here \(\delta\le4\).  Formula (2.2),
after removing \(g^i\), says that the first two new equations have ranks

\[
10-\delta,\qquad9-\delta.
\]

Their worst values are six and five.  Thus this row costs at least
twenty-two conditions.  On the largest diagonal row the costs are

\[
11+4+3=18.
\tag{3.3}
\]

The zero leading form already costs eighteen.  Hence the uniform fixed
codimension is at least eighteen.  A line through one proper base support
moves in one dimension, so the largest moving pair has dimension

\[
16+1=17.
\tag{3.4}
\]

This includes the case in which the base scheme has an infinitely-near
successor in another direction: the calculation used only the divided
restriction on \(L\).

### 3.3 Two simple centers on the line

Now the common factor \(g\) has degree two, the divided kernel is trivial,
and \(q_0\) is a triple of quartics.  Its rank-one cone has dimension six,
so the leading equation costs nine conditions.  The accessible first two
layers are

\[
g^iH^0(O_L(4-i))^3,
\]

of dimensions twelve and nine.  The nonboundary ranks are

\[
8-\delta,\qquad7-\delta,
\qquad \delta\le4.
\]

The worst total is therefore

\[
9+4+3=16.
\tag{3.5}
\]

The diagonal row costs at least \(10+4+3=17\).  If \(q_0=0\), its fifteen
linear conditions are followed by the nonzero order-two determinant
equation, again giving at least sixteen.  A line containing a length-two
complete subcluster is determined by that cluster.  The largest relevant
triple stratum is the two-distinct-point row of dimension fifteen, so the
margin is at least one.

### 3.4 A multiplicity-two base point

For a line through the point, \(q_0\) is again a triple of quartics.  In
the plane normal filtration the accessible layers are the degree-\(i\)
point factor times three forms of degree \(4-i\).  The calculation in
Section 3.3 is unchanged and gives fixed codimension at least sixteen.
The rank-three and rank-two multiplicity-two triple strata have dimensions
ten and nine, respectively, and the line adds one.  The margin is at least
five.

Combining the four cases proves

\[
\boxed{L^4\nmid B_\sigma
\text{ for every primitive isolated-base }\sigma
\text{ and general }A.}
\tag{3.6}
\]

## 4. One doubled-line condition

Before imposing two different lines, record the fixed codimension of one
condition

\[
L^2\mid B_\sigma.
\]

The same leading-form and first-normal-coefficient calculation used in
Section 3 gives

\[
\begin{array}{c|c}
\text{line type}&
c(L):=\operatorname {codim}_A\{L^2\mid B_\sigma\}\\ \hline
h=0&\ge16\\
h=1&\ge15\\
h=2,\text{ simple}&\ge13\\
m=2&\ge13.
\end{array}
\tag{4.1}
\]

For \(h=0\), these are the base-point-free values nineteen and sixteen
on balanced and unbalanced lines.  For \(h=1\), the leading
\((4,5,6)\) rank-one condition costs eleven.  On a nonboundary row the
first normal coefficient has rank at least \(10-\delta\ge6\); on the
largest diagonal row it has rank four.  The minimum is therefore
\(11+4=15\).  For \(h=2\), the leading triple of quartics costs nine and
the first normal rank is at least \(8-\delta\ge4\), giving thirteen.
The diagonal and zero-leading boundaries are smaller.  The
multiplicity-two calculation is identical at this order.

## 5. Sequential line squares and the twist-two gain

Suppose \(L_1\ne L_2\).  After imposing \(L_2^2\mid B_\sigma\), vary the
equation matrix by

\[
A\longmapsto A+L_2^2N,
\qquad
N\in H^0\bigl(\operatorname {Sym}^2(k^3)^\vee\otimes O(2)\bigr).
\tag{5.1}
\]

Let \(V\) be the equation space and let \(W=L_2^2H^0(\operatorname
{Sym}^2(k^3)^\vee\otimes O(2))\).  The first-condition locus is invariant
under translation by \(W\): the restricted quadratic form depends
linearly on \(A\), and it is unchanged modulo \(L_2^2\).  Thus, after
quotienting \(V\) by \(W\), every fiber of the first-condition locus is a
whole \(W\)-coset.  Its codimension in \(V/W\) is the same
first-condition codimension \(c(L_2)\) recorded in (4.1).

On the first neighborhood of \(L_1\), multiplication by \(L_2^2\) is
injective: \(L_2\) is a nonzerodivisor on \(2L_1\).

For completeness, fix all coefficients outside the perturbation space in
(5.1).  The equations

\[
\det(q_A+L_2^2q_N)=0\quad\text{on }2L_1
\]

have degree at most two in \(N\).  At projective infinity their leading
equations are

\[
L_2^4\det(q_N)=0.
\]

Injectivity of multiplication by \(L_2^4\) reduces this to
\(\det(q_N)=0\).  More explicitly, let \(K\) be the kernel of the
linear restriction map from the quadratic-matrix space to its image,
whose dimension is \(I^{(2)}_{L_1}\).  If an affine solution component
has positive dimension \(r\), its projective closure meets the hyperplane
at infinity in dimension at least \(r-1\).  That intersection lies in the
projectivization of the inverse image of the zero-determinant cone, which
has dimension at most

\[
\dim K+\beta^{(2)}_{L_1}-1.
\]

Hence \(r\le\dim K+\beta^{(2)}_{L_1}\); the zero-dimensional case is
automatic.  The second condition therefore cuts every \(W\)-fiber by at
least \(I^{(2)}_{L_1}-\beta^{(2)}_{L_1}\).  Since the first condition was
already measured on \(V/W\), these two codimensions add.  Consequently the
extra codimension obtained from \(L_1\) is at least

\[
g(L_1)=I^{(2)}_{L_1}-\beta^{(2)}_{L_1},
\tag{5.2}
\]

where \(I^{(2)}\) is the image dimension for a symmetric matrix of
quadrics and \(\beta^{(2)}\) is its zero-determinant dimension.

The relevant bundle is

\[
\mathcal Q^{(2)}
=\operatorname {Sym}^2(\mathscr K^\vee)\otimes O(2H),
\]

with presentation

\[
0\to3O_S(2H-R)=3O_S(M)
\to6O_S(2H)\to\mathcal Q^{(2)}\to0.
\tag{5.3}
\]

For a simple base cluster, its global coefficient image has dimension
\(36-3=33\).  If \(L\) contains no base center, restriction to
\(2\widetilde L\) has image twenty-seven.  At a touched simple center,
twisting (5.3) by \(-2\widetilde L\) gives exceptional source pieces
\(H^1(O_E(-2))\) and \(H^1(O_E(-3))\), of dimensions one and two, and
one target piece \(H^1(O_E(-2))\).  With the three source and six target
copies, multiplication by a rank-two first-jet triple \((u,v,0)\) has
graded ranks

\[
0,\ 5,
\]

so its local kernel has dimension four.  A rank-one first-jet triple
\((u,0,0)\) has ranks

\[
0,\ 3,
\]

and local kernel dimension six.  The six global sections of the
exceptional target are counted once.  Hence

\[
I^{(2)}_L\ge27-\sum_{v\in L}\kappa_v,
\qquad
\kappa_v=
\begin{cases}
4,&v\text{ terminal},\\
6,&v\text{ nonterminal}.
\end{cases}
\tag{5.4}
\]

The lower-twist UFD calculation obtained from Section 2 has bad
dimensions

\[
\begin{array}{c|ccccc}
\text{type}&h=0\text{ bal.}&h=0\text{ unbal.}&h=1&h=2&m=2\\ \hline
\beta^{(2)}&14&17&14&12&10.
\end{array}
\tag{5.5}
\]

Combining (5.4)--(5.5) gives the exact gains used below:

\[
\begin{array}{c|c|c|c}
\text{line type}&I^{(2)}&\beta^{(2)}&g\\ \hline
h=0,\text{ worst unbalanced}&27&17&10\\
h=1,\text{ terminal center}&23&14&9\\
h=1,\text{ nonterminal center}&21&14&7\\
h=2,\text{ terminal--terminal}&19&12&7\\
h=2,\text{ nonterminal--terminal}&17&12&5\\
h=2,\text{ nonterminal--nonterminal}&15&12&3.
\end{array}
\tag{5.6}
\]

At a multiplicity-two base point, choose a component frame after fixing
the line.  The leading restriction of \(N\) supplies three arbitrary
quadratics, of dimension nine, and the first normal coefficient supplies
at least six further independent coefficients.  Thus

\[
I^{(2)}\ge15,\qquad
\beta^{(2)}=10,\qquad
g\ge5.
\tag{5.7}
\]

The argument is symmetric in the two root lines.  Therefore the fixed
codimension for a pair is at least

\[
\boxed{
\max\{c(L_1)+g(L_2),\ c(L_2)+g(L_1)\}.}
\tag{5.8}
\]

## 6. Exhaustive simple-cluster margins

For a rank-three net, the simple base partitions and triple dimensions are
the ones classified in the primitive-base note.  For a rank-two pencil
with four simple centers, a partition with \(s\) proper supports has
base-scheme dimension \(4+s\); the pencil is determined by its
complete-intersection scheme and a spanning triple has dimension five.
Hence its triple dimension is \(9+s\).

A line containing a fixed complete subcluster of length \(h\) moves in
dimension \(2-h\).  Use (4.1), (5.6), and both orders in (5.8).  The
exhaustive minimum margins are

\[
\begin{array}{c|c|c}
\text{rank and base partition}&\dim\{\sigma\}&
\min\{\text{fixed codimension}-\text{moving pair dimension}\}\\ \hline
3:[1]&16&6\\
3:[1,1]&15&6\\
3:[2]&14&5\\
3:[1,1,1]&14&6\\
3:[2,1]&13&5\\
3:[3]&12&7\\ \hline
2:[1,1,1,1]&13&7\\
2:[2,1,1]&12&6\\
2:[2,2]&11&7\\
2:[3,1]&11&7\\
2:[4]&10&9.
\end{array}
\tag{6.1}
\]

The brackets in (6.1) record base-cluster distributions, not branch
correction profiles.  To see that the table is exhaustive, a line may be
off the base, pass through one proper support, be the tangent line through
the first two centers of a local chain, or be the chord through two
distinct proper supports.  A primitive conic pencil has no line containing
a base subcluster of length three.  Terminal/nonterminal labels in each of
these possibilities select exactly one row of (5.6).

Every entry in (6.1) is strict.  Thus no simple isolated-base stratum has
a two-line square root.

## 7. Multiplicity-two base schemes

For a line avoiding the multiplicity-two base point, use

\[
c=16,\qquad g=10.
\]

For a line through the point, Sections 4 and 5 give

\[
c=13,\qquad g=5.
\]

The rank-three and rank-two multiplicity-two triple strata have dimensions
ten and nine, so it is enough to use ten.  Applying the better of the two
orders in (5.8) gives

\[
\begin{array}{c|c|c|c}
\text{root lines through }p&\text{fixed codimension}&
\text{moving pair dimension}&\text{margin}\\ \hline
0&26&14&12\\
1&23&13&10\\
2&18&12&6.
\end{array}
\tag{7.1}
\]

Consequently

\[
\boxed{L_1^2L_2^2\nmid B_\sigma
\qquad(L_1\ne L_2)}
\tag{7.2}
\]

for every primitive isolated-base triple and general \(A\).

## 8. Conclusion

An algebraically closed plane quadratic is an integral conic, two distinct
lines, or a doubled line.  The integral-conic theorem from the primitive
base-scheme note, (3.6), and (7.2) exhaust the possibilities.  This proves
(0.1).

The UFD dimensions, exceptional kernels, cluster-stratum dimensions, and
every margin in the proof are replayed by
[`k2_isolated_degree2_square_checks.py`](k2_isolated_degree2_square_checks.py).
