# The base-aligned frontier for squared lines on the isolated-base locus

## Statement

Let \(\sigma\) be a primitive rank-two or rank-three triple of plane
quadrics with a nonempty zero-dimensional base scheme, and put

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma
\]

for a general symmetric matrix \(A\) of plane quartics.  Combine the
fixed-line estimates of
[`k2_isolated_degree2_square_exclusion.md`](k2_isolated_degree2_square_exclusion.md)
with the exact dimensions of the primitive base strata in
[`k2_primitive_base_scheme_reduction.md`](k2_primitive_base_scheme_reduction.md).
Then a squared-line incidence \(L^2\mid B_\sigma\) is absent except
possibly in the rows in the following list.

1.  Off the base scheme, the only remaining row is the unbalanced
    high-diagonal stratum for a rank-three base scheme consisting of two
    distinct points.
2.  If \(L\) meets the base scheme, the only rows not made strict by the
    resolved first-neighborhood estimate are

    \[
    \begin{array}{c|c}
    \text{base cluster}&\text{position of }L\\ \hline
    [1]&\text{through its support},\\
    [1,1]&\text{through one support, or the chord},\\
    [2]&\text{a nontangent line through the support, or the tangent},\\
    [1,1,1]&\text{through one support, or a chord},\\
    [2,1]&\text{the tangent or the chord joining the two supports},\\
    r=2:[1,1,1,1]&\text{a chord through two base points}.
    \end{array}
    \tag{0.1}
    \]

Here brackets record the distribution of the simple base cluster, not a
branch-correction profile.  In particular all multiplicity-two base
schemes, the rank-three curvilinear length-three cluster, and every
rank-two simple cluster other than the chord row displayed in (0.1) are
excluded.

The improvement in item 1 uses the inverse elementary transform, but in a
way that keeps track of the point conditions coming from the isolated
base.  For a one-point rank-three base scheme, the double dual of the
off-base high-diagonal torsion-free transform is
\(T_{\mathbf P^2}(-1)\).  Its conditional form space has dimension
fifty-six, hence codimension four in the complete sixty-dimensional
\(k=1\) rank-three form space.  The complete \(k=1\)
incidence theorem gives codimension at least nine for rational connected
double planes in that complete space.  Intersecting with a codimension-four
subspace still leaves residual codimension at least five, which is more
than the one parameter of excess in the original squared-line incidence.

For two distinct base points the double dual is
\(O\oplus O(1)\), but the induced fifty-six-dimensional space has
codimension eight in the complete sixty-four-dimensional quadratic-form
space.  No theorem currently in the certificate package controls the
rational determinant locus after imposing those eight point conditions.
This is the exact obstruction to applying the new base-point-free
transformed-bundle theorem verbatim.

This note is an incidence frontier, not an exclusion of the rows in
(0.1).  In particular it does not claim that the transforms on a line
through the base are either of the two bundles treated in
[`k2_basepointfree_line_square_transformed_bundle_exclusion.md`](k2_basepointfree_line_square_transformed_bundle_exclusion.md).

## 1. The off-base high-diagonal row

For a line disjoint from the base, the companion off-base certificate
excludes every first-neighborhood stratum except the unbalanced
high-diagonal one.  Its fixed-line codimension is sixteen.  For a
rank-three net, unbalanced lines form a proper closed subset of the dual
plane, hence have dimension at most one.  Therefore the moving margins
\(16-(\dim\{\sigma\}+1)\) are

\[
\begin{array}{c|c|c}
\text{rank-three base type}&\dim\{\sigma\}&\text{margin}\\ \hline
[1]&16&-1\\
[1,1]&15&0\\
[2]&14&1.
\end{array}
\tag{1.1}
\]

For every length-three rank-three scheme the kernel dual is
\(O(1)^2\), so there are no unbalanced lines.  A rank-two triple has
dimension thirteen and every line is unbalanced, giving margin
\(16-(13+2)=1\).  Thus only the first two rows of (1.1) survive the raw
count.

### 1.1 One base point and the rank-three \(k=1\) double dual

On the high-diagonal row a constant relation lets us write
\(\sigma_0=LM\).  Since \(L\cap Z=\varnothing\), every base point lies on
the cofactor line \(M\).  In particular a rank-three base scheme in this
row has length at most two.

Let first \(Z=\{p\}\), and put

\[
\overline F=\operatorname {coker}\left[
O(-2)\xrightarrow{(M,\sigma_1,\sigma_2)}O(-1)\oplus2O
\right].
\tag{1.2}
\]

This is the plane pushdown of the transformed bundle on the
principalization.  It is torsion-free, is singular exactly at \(p\), and
has \((c_1,c_2)=(1,2)\).  The quotient
\(\overline F^{**}/\overline F\) has length one, so
\(c_2(\overline F^{**})=1\).  There is no degree-compatible constant
syzygy among \((M,\sigma_1,\sigma_2)\): such a syzygy would make two of the
original quadrics share \(M\), increasing the base length.  The standard
classification furnished by the resulting three-linear-form presentation
therefore gives

\[
\boxed{\overline F^{**}\simeq T_{\mathbf P^2}(-1)},
\qquad
0\longrightarrow\overline F\longrightarrow T_{\mathbf P^2}(-1)
\longrightarrow O_p\longrightarrow0.
\tag{1.3}
\]

The equation space restricted to a fixed rank-three \(\sigma\) has
dimension \(90-18=72\).  Restriction to \(2L\) is onto the
thirty-nine-dimensional target, and the high-diagonal subspace there has
dimension twenty-three.  Hence the transformed conditional form space has
dimension

\[
72-39+23=56.
\tag{1.4}
\]

On the other hand
\(h^0(\operatorname {Sym}^2T_{\mathbf P^2}(-1)(4))=60\).
Thus (1.4) is a codimension-four linear subspace of the complete \(k=1\)
rank-three space.  The completed \(k=1\) incidence package proves that the
forms defining connected rational double planes have codimension at least
nine in the complete space: the factor rows have fixed-form codimension at
least nine, and the final squarefree Enriques-diagram incidence has the
same lower bound.  Therefore their intersection with (1.4) has codimension
at least

\[
9-4=5.
\tag{1.5}
\]

Since the original high-diagonal row has excess one by (1.1), (1.5)
excludes the one-point row for a general \(A\).

### 1.2 Two distinct base points give the unresolved split transform

Now let \(Z\) consist of two distinct points.  The cofactor line is their
chord.  After a constant change of generators the divided triple has the
form \((M,Q,MN)\).  Consequently

\[
\overline F\simeq O\oplus I_Z(1),
\qquad
\boxed{\overline F^{**}\simeq O\oplus O(1).}
\tag{1.6}
\]

The transformed conditional space still has dimension fifty-six by
(1.4), whereas

\[
h^0\bigl(\operatorname {Sym}^2(O\oplus O(1))(4)\bigr)
=h^0(O(4))+h^0(O(5))+h^0(O(6))=64.
\tag{1.7}
\]

The missing eight dimensions are precisely why neither the complete-space
\(k=1\) theorem nor the complete \(c_2=2,3\) transformed-bundle theorem
can simply be quoted.  The zero-margin row in (1.1) remains.

For clarity, a rank-two length-four pencil is not covered by this
rank-three double-dual discussion.  On the principalization its kernel is
\(O\oplus O(-R)\); the off-base high kernel is the global \(O\), and its
transform is the split bundle

\[
O(-H)\oplus O(R),
\qquad c_2=-2.
\tag{1.8}
\]

It is neither a \(k=1\) bundle nor either transformed bundle in the
base-point-free theorem.  Its original squared-line incidence is already
absent by the strict margin \(16-(13+2)=1\), so no residual theorem is
needed.

## 2. Lines meeting a simple base cluster

Let \(h\) be the length of the complete simple subcluster followed by the
strict transform of \(L\).  Primitivity gives \(h\le2\).  The fixed-line
codimension estimates already proved in the degree-two-square certificate
are

\[
c_1\ge15\quad(h=1),
\qquad
c_2\ge13\quad(h=2).
\tag{2.1}
\]

A line through one specified proper support moves in a pencil, while a
line following two base units is determined: it is either a chord of two
proper supports or the tangent direction of a local chain.  Subtracting
the exact triple dimensions gives

\[
\begin{array}{c|c|c|c}
\text{rank}&\text{cluster}&h=1\text{ margin}&h=2\text{ margin}\\ \hline
3&[1]&-2&--\\
3&[1,1]&-1&-2\\
3&[2]&0&-1\\
3&[1,1,1]&0&-1\\
3&[2,1]&1&0\\
3&[3]&2&1\\ \hline
2&[1,1,1,1]&1&0\\
2&[2,1,1]&2&1\\
2&[2,2]&3&2\\
2&[3,1]&3&2\\
2&[4]&4&3.
\end{array}
\tag{2.2}
\]

A dash means that the cluster has no length-two subcluster on a line.
Every positive entry is a strict incidence margin.  Reading the
nonpositive entries of (2.2) gives exactly (0.1).

If a line were to follow three simple base units, every conic of the
triple would have three zeros on that line and hence contain it.  This is
forbidden by primitivity, so (2.2) is exhaustive.

### 2.1 Why the base-point-free transformed theorem does not close (0.1)

The obstruction can be stated intrinsically.  On the principalization
write

\[
R=2H-M,
\qquad C=\widetilde L,
\qquad d=R\cdot C.
\]

Assume first that the restricted quadratic form is nonzero of generic rank
one, and let

\[
U=\ker(q|_C)\subset K|_C,
\qquad u=\deg U.
\]

The inverse elementary transform and its dual are

\[
0\to K\to K_U\to i_*(U(C))\to0,
\qquad
0\to F:=K_U^\vee\to K^\vee\to i_*U^\vee\to0.
\tag{2.3}
\]

Grothendieck--Riemann--Roch gives the exact numerical formula

\[
\boxed{c_1(F)=R-C,
\qquad c_2(F)=R^2-d-u.}
\tag{2.4}
\]

For a simple cluster of total length \(\ell\), the two line types give

\[
\begin{array}{c|c|c|c}
h&K|_C&u&c_2(F)\\ \hline
1&O\oplus O(-1)&0,-1,-2,-3&3-\ell-u\\
2&O^2&0,-1,-2&4-\ell-u.
\end{array}
\tag{2.5}
\]

At a multiplicity-two point, \(R^2=d=0\) and
\(c_2(F)=-u\).  Thus some rows in (2.5) have the same numerical second
Chern class as one of the two base-point-free transforms, but this does
not identify the bundles.

For example, in the constant-kernel row \(u=0\), a constant relation
gives \(\sigma_v=LM\) and the resolved transform has presentations

\[
0\to O(-R)\to O(-C)\oplus2O\to F\to0,
\tag{2.6}
\]

\[
0\to F\to O(R)\oplus2O(R-C)\to O(2R-C)\to0.
\tag{2.7}
\]

Only when the cofactor \(M\) is a unit at every base center on \(C\) do
the exceptional pairs cancel and give the particular \(c_2=2\) plane
bundle used in the base-point-free theorem.  If \(M\) vanishes at a base
center, restriction to its exceptional curve can instead be
\(O_E(-1)\oplus O_E(1)\), which does not descend.  In the \(u=-1\) rows,
even numerical \(c_2=3\) does not provide the special presentation of the
base-point-free \(c_2=3\) bundle; the exceptional quotient direction can
again obstruct descent.  These are genuine bundle-moduli issues, not
missing arithmetic in the first-neighborhood count.

Finally, if \(q|_C=0\), the whole quadratic form is divisible by \(C\)
and there is no distinguished kernel line \(U\).  That stratum is included
in the incidence bounds (2.1)--(2.2), but is outside the transform
classification (2.3).  It requires a separate scalar-factor argument.

## 3. Multiplicity-two base schemes

Every line through the multiplicity-two support is of the special
\(m=2\) type.  Its fixed codimension is at least thirteen.  The
rank-three and rank-two triple strata have dimensions ten and nine, and
the pencil of lines adds one.  Their margins are therefore

\[
13-(10+1)=2,
\qquad
13-(9+1)=3.
\tag{3.1}
\]

Lines avoiding the support were already strict.  Thus no
multiplicity-two base scheme supports a squared line for a general
equation.

For a rank-two pencil the resolved kernel is split.  If a line through the
base has strict transform \(C\), its high constant-kernel transform is

\[
F=O(-C)\oplus O(R),
\qquad c_2(F)=-R\cdot C.
\tag{3.2}
\]

This is another reason not to identify a through-base row merely from a
numerical \(c_2\) value.  Here the strict incidence margins already give
the exclusions except for the four-distinct-point chord row in (0.1).

All dimensions, margins, transformed Chern classes, and conditional-space
codimensions are replayed by
[`k2_isolated_line_square_base_aligned_checks.py`](k2_isolated_line_square_base_aligned_checks.py).
