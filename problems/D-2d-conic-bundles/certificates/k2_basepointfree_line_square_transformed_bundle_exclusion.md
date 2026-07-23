# Exclusion of the two transformed-bundle squared-line strata

## Statement

Let \(A\) be a general symmetric \(3\times3\) matrix of plane quartics,
let \(\sigma\) be a base-point-free triple of quadrics, and put

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma .
\]

The two extremal strata retained by
[`k2_basepointfree_line_square_reduction.md`](k2_basepointfree_line_square_reduction.md)
do not give a rational connected double plane.  More precisely, if
\(L^2\mid B_\sigma\) lies in either retained stratum and

\[
D=B_\sigma/L^2,
\]

then the normalization of the double plane with branch \(D\) is not
rational.  Consequently the entire base-point-free \(e=1\) row is absent
for a general \(A\).

The proof treats the two inverse elementary transforms separately.  If
\(F=(\mathscr K')^\vee\), their Chern classes and complete conditional
quadratic-form spaces are

\[
\begin{array}{c|c|c|c}
\text{retained stratum}&c_2(F)&
Q_F=\operatorname {Sym}^2F(4)&h^0(Q_F)\\ \hline
\text{balanced constant direction}&3&Q_3&52\\
\text{unbalanced high diagonal}&2&Q_2&56.
\end{array}
\tag{0.1}
\]

Neither row is identified with the settled \(c_2=1\) bundle.  Instead,
the proof uses presentations intrinsic to the two transformed bundles,
a new low-degree factor estimate that does not assume that \(F\) is
globally generated, and a proper-triple-point incidence.

## 1. The two transformed bundles

Retain the notation

\[
0\longrightarrow\mathscr K\longrightarrow O^3
\xrightarrow{\ \sigma\ }O(2)\longrightarrow0.
\tag{1.1}
\]

### 1.1 The unbalanced row: \(c_2=2\)

On the unbalanced retained row there is a constant relation on \(L\).
After changing the three generators, write

\[
\sigma_0=LM,
\]

with \(M\) linear.  Replacing the first generator by its inverse
elementary transform gives

\[
0\longrightarrow\mathscr K'\longrightarrow
O(1)\oplus2O\xrightarrow{(M,\sigma_1,\sigma_2)}O(2)
\longrightarrow0.
\tag{1.2}
\]

The three entries have no common zero: otherwise the original triple
would have a base point.  Dualizing (1.2) gives

\[
0\longrightarrow O(-2)\longrightarrow O(-1)\oplus2O
\longrightarrow F_2\longrightarrow0.
\tag{1.3}
\]

The Koszul complex of the base-point-free forms of degrees \(1,2,2\)
also gives

\[
0\longrightarrow F_2\longrightarrow O(2)\oplus2O(1)
\longrightarrow O(3)\longrightarrow0.
\tag{1.4}
\]

Thus \((c_1,c_2)(F_2)=(1,2)\).

### 1.2 The balanced row: \(c_2=3\)

Here \(\mathscr K^\vee|_L=O_L(1)^2\), and the selected kernel direction
is a line \(U\simeq O_L(-1)\).  Dualizing the inverse elementary
transform gives

\[
0\longrightarrow F_3\longrightarrow\mathscr K^\vee
\longrightarrow O_L(1)\longrightarrow0.
\tag{1.5}
\]

The composite \(3O\to\mathscr K^\vee\to O_L(1)\) spans
\(H^0(O_L(1))\).  Its kernel is

\[
G_3\simeq\Omega^1_{\mathbf P^2}(1)\oplus O.
\]

Using \(0\to O(-2)\to3O\to\mathscr K^\vee\to0\) in (1.5) therefore
gives

\[
0\longrightarrow O(-2)\longrightarrow
\Omega^1_{\mathbf P^2}(1)\oplus O
\longrightarrow F_3\longrightarrow0.
\tag{1.6}
\]

In particular \((c_1,c_2)(F_3)=(1,3)\).  Stability is also visible
directly in this construction.  Lift the selected linear syzygy on
\(L\) to linear forms \(f_i\), and put

\[
S=-\frac{\sum_i f_i\sigma_i}{L}\in H^0(O(2)).
\]

The presentation of \(G_3\) used above is
\(0\to O(-1)\to4O\to G_3^\vee\to0\).  Under the composite
\(4O\to G_3^\vee\to O(2)\), the four basis vectors map to
\(\sigma_0,\sigma_1,\sigma_2,S\).  These quadrics are
linearly independent.  Otherwise \(S\) would lie in
\(\langle\sigma_0,\sigma_1,\sigma_2\rangle\), and the displayed
identity would give a linear syzygy among three base-point-free
quadrics.  They form a homogeneous regular sequence, whose first Koszul
syzygies have degree two, so no such linear syzygy exists.  Hence
\(H^0((F_3)^\vee)=0\), proving stability.  The Koszul resolution behind
(1.4) gives the same conclusion for \(F_2\).  Thus neither bundle is the
\(c_2=1\) bundle \(T_{\mathbf P^2}(-1)\).

### 1.3 Line splittings

Both (1.3) and (1.6), after restriction to a line \(R\), have the form

\[
0\longrightarrow O_R(-2)\longrightarrow
O_R(-1)\oplus2O_R\longrightarrow F_i|_R\longrightarrow0.
\tag{1.7}
\]

Twisting by \(-1\) shows \(h^0(F_i|_R(-1))\le2\).  Since
\(\deg(F_i|_R)=1\), this leaves exactly

\[
F_i|_R\simeq O_R\oplus O_R(1)
\quad\text{or}\quad
O_R(-1)\oplus O_R(2).
\tag{1.8}
\]

Accordingly

\[
Q_i|_R\simeq
O_R(4)\oplus O_R(5)\oplus O_R(6)
\quad\text{or}\quad
O_R(2)\oplus O_R(5)\oplus O_R(8).
\tag{1.9}
\]

## 2. Cohomology and completeness of the conditional form spaces

If \(0\to O(-2)\to G_i\to F_i\to0\) denotes (1.3) or (1.6), then
multiplication by the distinguished line subbundle gives an exact
sequence

\[
0\longrightarrow G_i(-2)\longrightarrow
\operatorname {Sym}^2G_i\longrightarrow
\operatorname {Sym}^2F_i\longrightarrow0.
\tag{2.1}
\]

For \(i=2\), twisting (2.1) by four gives

\[
0\longrightarrow O(1)\oplus2O(2)\longrightarrow
O(2)\oplus2O(3)\oplus3O(4)\longrightarrow Q_2
\longrightarrow0.
\tag{2.2}
\]

For \(i=3\), put \(E=\Omega^1(1)\).  Then
\(G_3=E\oplus O\), and the symmetric Euler sequence

\[
0\longrightarrow\operatorname {Sym}^2E(t)
\longrightarrow6O(t)\longrightarrow3O(t+1)
\longrightarrow0
\tag{2.3}
\]

is short exact.  Explicitly, over a point represented by a nonzero vector
\(x\), its last map is

\[
\operatorname {Sym}^2(k^3)\longrightarrow k^3,
\qquad Q\longmapsto Qx.
\]

It is onto, and its kernel is
\(\operatorname {Sym}^2(x^\perp)=\operatorname {Sym}^2(E_x)\).
Thus there is no further \(O(t+2)\) term; such a term would also violate
the rank identity \(3-6+3=0\).  Sequence (2.3), together with (2.1),
computes the second row below.  The resulting exact table is

\[
\begin{array}{c|ccccc|cccc}
 &h^0(Q_i)&h^0(Q_i(-1))&h^0(Q_i(-2))&h^0(Q_i(-3))&h^0(Q_i(-4))
 &r_1&r_2&r_3&r_4\\ \hline
i=2&56&38&23&11&3&18&33&45&53\\
i=3&52&34&19&7&1&18&33&45&51.
\end{array}
\tag{2.4}
\]

Here

\[
r_d=h^0(Q_i)-h^0(Q_i(-d))
\tag{2.5}
\]

is the rank of restriction to any integral degree-\(d\) divisor.  The
same calculation gives

\[
H^1(Q_i(-1))=H^1(Q_i(-2))=H^1(Q_i(-3))=0.
\tag{2.6}
\]

For completeness, in the \(c_2=3\) row one obtains

\[
h^0(\operatorname {Sym}^2F_3(t))
=7,19,34,52\quad(t=1,2,3,4),
\]

while \(h^0(\operatorname {Sym}^2F_3)=1\).  These follow directly from
(2.1)--(2.3).  More explicitly, for \(t=1,2,3\), the long exact
cohomology sequence of

\[
0\longrightarrow G_3(t-2)\longrightarrow
\operatorname {Sym}^2G_3(t)\longrightarrow
\operatorname {Sym}^2F_3(t)\longrightarrow0
\]

and the Euler sequence give
\(H^1(\operatorname {Sym}^2F_3(t))=0\).  At \(t=1\), the sole
\(H^1(G_3(-1))\simeq k\) contributes one additional section, giving
\(h^0=6+1=7\); at \(t=2,3\), subtraction of the \(G_3(t-2)\) sections
gives \(19,34\).  The complete cohomology ledger used here is

\[
\begin{array}{c|cc|cc|cc}
t&h^0(G_3(t-2))&h^1(G_3(t-2))&
h^0(\operatorname {Sym}^2G_3(t))&
h^1(\operatorname {Sym}^2G_3(t))&
h^0(\operatorname {Sym}^2F_3(t))&
h^1(\operatorname {Sym}^2F_3(t))\\ \hline
1&0&1&6&0&7&0\\
2&1&0&20&0&19&0\\
3&6&0&40&0&34&0.
\end{array}
\]

Each entry follows from the ordinary Euler sequence and (2.3).  In
particular, the global map in (2.3) is an isomorphism at \(t=1\): if a
symmetric matrix \(Q\) of linear forms satisfies \(Q(x)x=0\), its
coefficient tensor is symmetric in its first two indices and
antisymmetric in its last two, hence is zero.  The source and target both
have dimension eighteen.  Together with \(H^2(\operatorname {Sym}^2E)=0\),
this says that \(\operatorname {Sym}^2E\) is \(2\)-regular, so the global
map in (2.3) is surjective for \(t\ge2\).  No generic maximal-rank
assertion is being used.

The form spaces in (0.1) are the complete conditional spaces, not merely
subspaces of them.  Indeed, fix the kernel direction \(U\) in the
balanced row.  Its first-neighborhood data have dimensions

\[
7+12=19,
\]

and the forms vanishing on \(2L\) have dimension \(33\).  Thus the
conditional space has dimension \(19+33=52=h^0(Q_3)\).  In the
unbalanced high-diagonal row the corresponding dimensions are

\[
23+33=56=h^0(Q_2).
\]

The local elementary-transform matrix identifies these spaces with
\(H^0(Q_3)\) and \(H^0(Q_2)\), respectively.

## 3. No integral component of degree at most four

Let \(C\) be an integral plane curve of degree \(d\le4\), let
\(\nu:T\to C\) be its normalization, and suppose
\(C\mid\det(q)\) for some \(q\in H^0(Q_i)\).  Then \(q|_T\) has rank at
most one.  At a nonzero rank-one point its image saturates to a line
subbundle

\[
M\subset F_i|_T,
\qquad m=\deg M.
\]

This time \(F_i\) is not assumed globally generated.  Instead take the
inverse image \(N\subset G_i|_T\).  Since

\[
0\longrightarrow O_T(-2d)\longrightarrow N\longrightarrow M
\longrightarrow0
\]

and both \(G_2=O(-1)\oplus2O\) and
\(G_3=\Omega^1(1)\oplus O\) embed as subbundles of a trivial bundle,
\(\det N\) maps nontrivially to a trivial line.  Hence

\[
m-2d=\deg N\le0,
\qquad m\le2d.
\tag{3.1}
\]

The scalar rank-one form is a section of
\(M^2\otimes O_T(4d)\), so \(m\ge-2d\).  The Quot tangent estimate and
the elementary bound \(h^0(P)\le\max\{\deg P+1,0\}\) for a line bundle
on a smooth curve give the following affine dimension bound for the
rank-one cone:

\[
\begin{aligned}
R'(d)
&=\max_{-2d\le m\le2d}
\left(
\max\{d-2m+1,0\}
+\max\{2m+4d+1,0\}
\right)\\
&=8d+1.
\end{aligned}
\tag{3.2}
\]

Integral degree-\(d\) curves move in dimension
\(N_d=\binom{d+2}{2}-1\).  Equations (2.4) and (3.2) give

\[
\begin{array}{c|c|c|c|c}
d&R'(d)&N_d&r_d-R'(d)-N_d\ (c_2=2)&
r_d-R'(d)-N_d\ (c_2=3)\\ \hline
1&9&2&7&7\\
2&17&5&11&11\\
3&25&9&11&11\\
4&33&14&6&4.
\end{array}
\tag{3.3}
\]

Every margin is strictly larger than two.  Thus, after the transformed
bundle and all curve parameters move, a general original equation has no
retained form whose residual determinant contains an integral component
of degree one through four.

## 4. Proper triple points of the residual determinant are absent

We next prove a residual codimension-three statement.  Because of (2.6),
restriction of \(H^0(Q_i)\) to a line, and to a union of two lines, is
surjective.

The stable bundle \(F_i\) has a proper closed jumping-line locus.  Fix a
point \(p\) for which the dual pencil \(p^*\) is not a component of that
locus, and choose two nonjumping lines \(R_1,R_2\) through \(p\).  On each
line the entries of the restricted symmetric form have degrees
\((4,5,6)\).  The two triples share their constant symmetric matrix at
\(p\).

The condition

\[
\operatorname {ord}_p\det(q|_{R_j})\ge3,
\qquad j=1,2,
\tag{4.1}
\]

has codimension at least five in the fiber-product restriction space.
Indeed:

1. a rank-two common constant matrix is impossible;
2. the nonzero rank-one constant stratum has codimension one, and after
   diagonalizing it the coefficients of orders one and two solve for two
   successive coefficients of the opposite diagonal on each branch,
   giving \(1+2+2=5\); and
3. the zero constant matrix has codimension three, after which the first
   derivative matrix on each branch must have zero determinant, giving
   \(3+1+1=5\).

Allowing \(p\) to move costs two parameters.  Thus proper triple points
over this locus have codimension at least three in \(H^0(Q_i)\).

There are only finitely many points \(p\) for which \(p^*\) is a line
component of the jumping locus.  At any such point use one line through
\(p\).  Its splitting is one of (1.8), so its entry degrees are either
\((4,5,6)\) or \((2,5,8)\).  The one-branch order-three condition has
codimension at least three: it is one constant determinant equation plus
two tail equations on the nonzero rank-one stratum, while the zero
constant stratum already has codimension three.  The exceptional point is
fixed by the bundle and contributes no moving-point parameter.  Hence in
all cases

\[
\boxed{\operatorname {codim}_{H^0(Q_i)}
\{\det(q)\text{ has a proper point of multiplicity }\ge3\}\ge3.}
\tag{4.2}
\]

## 5. Why this also removes the \([2^6]\) profile

The previous section is stronger than a proper-high-center exclusion.
Let \(C\) be any reduced plane curve.  If every proper point of \(C\) has
multiplicity at most two, then every corrected branch center in the
canonical double-plane resolution has multiplicity at most two.

Indeed, a proper double point has even corrected multiplicity.  Its
blowup therefore does **not** insert the exceptional curve into the
corrected branch.  The multiplicities of the strict transforms above it
are at most two.  Inductively every later blowup again has corrected
multiplicity at most two and inserts no branch exceptional component.
The assertion is immediate over a smooth proper point as well.  Taking
the contrapositive,

\[
\text{a corrected center with }t=\lfloor r/2\rfloor\ge2
\quad\Longrightarrow\quad
\text{a proper ancestor of multiplicity at least three.}
\tag{5.1}
\]

Thus (4.2) excludes not only proper \(t\ge2\) centers but every nonproper
essential center.  In particular it excludes all six essential centers
in the squarefree profile \([2^6]\), as well as nonproper descendants in
the profiles containing \(t=3\) or \(4\).  No theorem about the
\(c_2=1\) bundle is used here.

## 6. The final incidence ledger

For a fixed balanced \((\sigma,L,U)\), the squared-line condition has
codimension

\[
72-52=20.
\]

The parameters \((\sigma,L,U)\) have dimensions \(17+2+1=20\), so the
first-neighborhood margin is zero.  Any positive residual codimension
excludes an additional condition for general \(A\).

For the unbalanced row, the pairs \((\sigma,L)\) have dimension
\(17+2-1=18\), while the squared-line condition has codimension

\[
72-56=16.
\]

This row has excess two.  It is therefore excluded by every residual
condition of codimension at least three.

Now factor the maximal square in the residual decic:

\[
D=G^2C,
\qquad \deg G=e.
\]

If \(e=0\), the exact degree-ten rationality table has one of the
squarefree profiles

\[
[4],\quad[3,3],\quad[3,2,2,2],\quad[2^6].
\]

Every profile has an essential center, hence by (5.1) a proper triple
point.  Its residual codimension is at least three by (4.2).

If \(1\le e\le4\), an integral component of \(G\) has degree at most
four.  Section 3 excludes it with residual codimension at least four.  If
\(e=5\), the double algebra splits and does not give a connected
degree-two multisection.  These cases are exhaustive, proving the stated
exclusion of both transformed-bundle rows.

All cohomology dimensions, rank-one bounds, factor margins, and the final
incidence ledger are replayed by
[`k2_basepointfree_line_square_transformed_bundle_checks.py`](k2_basepointfree_line_square_transformed_bundle_checks.py).
