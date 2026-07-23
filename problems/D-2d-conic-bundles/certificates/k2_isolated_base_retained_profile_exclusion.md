# Two retained squarefree profiles on the isolated-base locus

## Statement

Let

\[
X=(x^tA(y)x=0)\subset \mathbf P^2_x\times\mathbf P^2_y
\]

be a general hypersurface of bidegree \((2,4)\), and let

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma
\]

for a primitive quadratic triple \(\sigma\) with a nonempty
zero-dimensional base scheme.  Then neither of the squarefree correction
profiles

\[
\boxed{[4,2^4]\qquad\text{or}\qquad[3^3,2]}
\tag{0.1}
\]

occurs.

Together with the base-point-free exclusions, this removes both profiles
from the entire primitive quadratic-triple locus.  The proof treats every
rank-three base scheme of length one, two, or three, the rank-three
\(\mathfrak m_p^2\) row, and both rank-two \((2,2)\) complete-intersection
rows.  Proper, free, and satellite base centers are included.

The argument uses three inputs from the companion certificates.

1. The isolated-base classification and its exact dimensions are those of
   [`k2_primitive_base_scheme_reduction.md`](k2_primitive_base_scheme_reduction.md).
2. Cubic adjoint vanishing selects four distinct lines through the proper
   \(t=4\) center in \([4,2^4]\), each carrying all twelve units of branch
   contact; see Section 5 of
   [`k2_combined_proper_cluster_exclusion.md`](k2_combined_proper_cluster_exclusion.md).
3. In \([3^3,2]\), the three \(t=3\) centers are proper, distinct, and
   noncollinear, and their unique cubic is their triangle; see
   [`k2_profile3332_properness_exclusion.md`](k2_profile3332_properness_exclusion.md).

The new issue is that a selected line can meet the base cluster, so its
kernel splitting and the coefficient-image rank change.  Sections 1--2
give the uniform resolved-line ledger.  Sections 3--4 apply it to the two
profiles.

## 1. Resolved-line determinant ledger

Resolve the base ideal and write

\[
R=2H-M,
\qquad
0\longrightarrow\mathscr K\longrightarrow O^3
\xrightarrow{\ \sigma\ }O(R)\longrightarrow0.
\tag{1.1}
\]

Let \(L\) be a plane line and \(\widetilde L\) its strict transform.  Put

\[
s=M\cdot\widetilde L,
\qquad d=R\cdot\widetilde L=2-s.
\tag{1.2}
\]

Nefness of the resolved conic system gives \(s\in\{0,1,2\}\).  The
globally generated bundle \(\mathscr K^\vee|_{\widetilde L}\) has degree
\(d\).  Up to ordering, its possible splittings and the three quadratic
form degrees are

\[
\begin{array}{c|c|c|c}
s&d&\mathscr K^\vee|_{\widetilde L}&
\operatorname {Sym}^2(\mathscr K^\vee)(4H)|_{\widetilde L}\\ \hline
0&2&O(1)\oplus O(1)&(6,6,6)\\
0&2&O\oplus O(2)&(4,6,8)\\
1&1&O\oplus O(1)&(4,5,6)\\
2&0&O\oplus O&(4,4,4).
\end{array}
\tag{1.3}
\]

Their section-space dimensions are respectively \(21,21,18,15\), and
their determinant targets have dimensions \(13,13,11,9\).

Suppose the selected branch cluster contributes at least twelve units of
plane contact on the line.  At most \(2s\) of that marked contact can come
from the forced base square, so the residual determinant has contact at
least

\[
12-2s=8+2d=\deg(\det q|_{\widetilde L}).
\tag{1.4}
\]

If a base center on the line is not part of the marked branch path, it
contributes additional contact and forces the residual determinant to
vanish identically; this is already included in the zero fiber below.
Thus in every case the residual determinant ranges in a vector space of
dimension at most one.

The complete fixed-determinant fiber bounds, including the zero fiber, are

\[
\begin{array}{c|cccc}
\text{degrees}&(6,6,6)&(4,6,8)&(4,5,6)&(4,4,4)\\ \hline
\dim\text{ fixed fiber}&8&9&7&6\\
\dim\text{ fiber over a one-dimensional target}&9&10&8&7.
\end{array}
\tag{1.5}
\]

For the two degree-six splittings these are the binary-UFD bounds already
proved in the three-line certificate.  For \(d=1,0\), the zero fiber is
the rank-one cone and has dimension

\[
R(d,4)=
\max_{-2\le a\le d}
\bigl(\max\{d-2a+1,0\}+\max\{2a+5,0\}\bigr),
\tag{1.6}
\]

namely seven and six.  A fixed nonzero fiber has no larger dimension:
scaling a quadratic form degenerates it into the zero fiber.  Adding the
scalar determinant target proves (1.5).

### 1.1 Elementary transforms along a selected line union

Let \(C\) be a reduced union of three or four selected lines, and assume
for the moment that no multiple point of \(C\) is a base point.  Let
\(S=\sum_Ls_L\).  The coefficient image for a base-point-free triple has
dimension fifty-four on three lines and sixty-six on four lines.  After
resolving base centers on the smooth loci of the selected lines, its
dimension is at least

\[
\boxed{54-3S\quad\text{or}\quad66-3S.}
\tag{1.7}
\]

Here is a direct proof, including infinitely-near centers.  On one
normalized line, decreasing \(d\) by one changes the sum of the three
degrees in (1.3) by three.  The resolved symmetric presentation is

\[
0\to3O(4H-R)\to6O(4H)\to
\operatorname {Sym}^2(\mathscr K^\vee)(4H)\to0.
\tag{1.8}
\]

Blowing up a simple base center on the strict transform of the line is the
corresponding length-three elementary quotient of its symmetric cokernel.
A second free center followed by the same strict line performs the next
length-three quotient.  The same two quotients describe an
\(\mathfrak m_p^2\) center.  The coefficient map commutes with these
quotients, so elementary linear algebra says that each step can lower its
rank by at most the quotient length, namely three.  This is also immediate
by restricting (1.8) to the normalized line: the sum of the three degrees
drops by three, and all \(H^1\)'s in degrees \(4,5,6\) vanish.

A strict transform of a plane line follows only free base centers; it
cannot pass through a satellite point at the intersection of two
exceptionals.  Satellite base centers therefore make no contribution to
\(S\).  Centers off \(C\) do not affect the restriction.  These
observations prove (1.7), including every possible base diagram.

The only exceptions to this elementary calculation occur when several
selected lines meet at a base point.  They are computed exactly in
Section 2.

## 2. A selected-line node which is a simple base point

The multiplicity-two base strata cannot occur here: Section 4 of the
primitive-base certificate proves that such a center always has \(t=2\)
for general \(A\).  Thus a selected \(t=3\) or \(t=4\) center which is a
base point is a simple base point.

Let \(p\) be simple and put \(Z=\operatorname {Bl}_p\mathbf P^2\), with
exceptional curve \(E\).  On this first blowup

\[
0\to3O_Z(2H+E)\to6O_Z(4H)\to\mathcal Q\to0.
\tag{2.1}
\]

There are two first-jet ranks.  Rank two has normal form \((u,v,0)\) on
\(E\), and the local base length is one.  Rank one has normal form
\((u,0,0)\).  Its higher quadratic terms distinguish local curvilinear
base lengths two, three, and four.  Length four occurs only in the
rank-two pencil row.  First-jet rank zero is the multiplicity-two base
row and cannot be the selected \(t=3\) or \(t=4\) center.

### 2.1 Four concurrent lines

For four lines through \(p\), their disjoint strict transforms have class

\[
D_4=4H-4E.
\]

Twisting (2.1) by \(-D_4\) gives source and target line bundles

\[
-2H+5E,\qquad4E.
\tag{2.2}
\]

Their cohomology dimensions are

\[
h^1(-2H+5E)=10,\qquad
h^0(4E)=1,\qquad h^1(4E)=6.
\tag{2.3}
\]

By Serre duality the relevant cohomology map is the truncated local
contraction

\[
\operatorname {Sym}^2(k^3)\otimes k[u,v]/(u,v)^3
\xrightarrow{\ q\mapsto q\sigma\ }
k^3\otimes k[u,v]/(u,v)^4.
\tag{2.4}
\]

The normal forms and exact contraction ranks, stratified by the local base
length \(\mu\), are

\[
\begin{array}{c|c|c}
\mu&\text{one possible local normal form}&\operatorname {rank}(2.4)\\ \hline
1&(u,v,0)&26\\
2&(u,v^2,0)&22\\
3&(u+v^2,uv,0)&20\\
4&(u+v^2,u^2,0)&18.
\end{array}
\tag{2.5}
\]

These ranks are lower bounds for the whole indicated stratum.  They may be
read from the order filtration: the displayed initial forms give the
listed pivots, and extra terms cannot remove associated-graded pivots.
Here is the short exhaustion argument.  In first-jet rank one, make
\(\sigma_0=u+q_0\) and let \(\sigma_1,\sigma_2\) be quadratic.  Eliminate
\(u\) with the first equation.  If one of the last two quadrics has a
nonzero \(v^2\) term, the quotient starts with \(v^2\) and has length two.
Otherwise both are divisible by \(u\).  Isolatedness forces the \(v^2\)
term of \(q_0\) to be nonzero.  A nonzero \(uv\) term in the last two
components then gives \(v^3\), while the remaining case starts with
\(u^2\) and gives \(v^4\).  These are exactly the last three rows of
(2.5).  Thus the four normal forms exhaust the Hilbert functions of an
isolated ideal generated by quadrics whose first-jet rank is positive.
Therefore the kernel of

\[
3H^1(-2H+5E)\longrightarrow6H^1(4E)
\]

has dimension at most \(30-r_\mu\), where \(r_\mu\) is the last column of
(2.5).  The coefficient restriction images on the four strict lines
consequently have dimensions at least

\[
\begin{array}{c|rrrr}
\mu&1&2&3&4\\ \hline
\dim\operatorname {im}&62&58&56&54.
\end{array}
\tag{2.6}
\]

The local matrices and all four ranks are replayed by the checker.  The
corresponding maximal triple-stratum dimensions are

\[
\begin{array}{c|rrrr}
\mu&1&2&3&4\\ \hline
\dim\{\sigma\}&16&14&12&10.
\end{array}
\tag{2.7}
\]

The first three bounds are read directly from the rank-three base table;
rank-two subrows are no larger.  For \(\mu=4\), a punctual curvilinear
length-four complete intersection moves in dimension at most five
(including its support), and its projective spanning frames add five.

### 2.2 A triangle vertex

If two sides of a triangle meet at the simple base point \(p\), their
strict-transform union with the opposite side has class

\[
D_3=3H-2E.
\]

The twist of (2.1) now has source and target

\[
-H+3E,\qquad H+2E.
\tag{2.8}
\]

Their relevant dimensions are

\[
h^1(-H+3E)=3,\qquad
h^0(H+2E)=3,\qquad h^1(H+2E)=1.
\tag{2.9}
\]

Exceptional filtration gives multiplication ranks five and three in the
two first-jet strata.  Hence the restriction images have dimensions at
least

\[
\boxed{50\text{ in first-jet rank two},\qquad
48\text{ in first-jet rank one}.}
\tag{2.10}
\]

At that vertex the two incident line targets have degree pattern
\((4,5,6)\), so their total bad dimension is at most sixteen.  The
opposite line contributes at most ten.  Thus (2.10) gives fixed
codimensions at least twenty-four and twenty-two, respectively.

The image losses at distinct triangle vertices add because their
exceptional filtrations have disjoint support.  The bad-space gains on a
side shared by two base vertices do not quite add: that side changes from
bad dimension ten to seven, a gain of three rather than four.  This small
overlap is included explicitly in Section 4.  Further base centers on a
selected strict line are the elementary transforms of Section 1.1.

## 3. Exclusion of \([4,2^4]\)

Let \(p\) be the \(t=4\) center.  It is proper.  Adjoint vanishing selects
four distinct lines \(L_1,\ldots,L_4\) through \(p\), and each has total
branch contact at least twelve.  The center together with the four marked
paths moves in dimension at most

\[
2+4\cdot2=10.
\tag{3.1}
\]

### 3.1 The center is not a base point

First suppose that the pencil through \(p\) is not entirely unbalanced.
Let \(U\) be the number of selected lines with \(s=0\) which are
unbalanced, and put \(S=\sum s_L\).  Every such unbalanced direction is
one of finitely many jumping members of the pencil and removes one
direction parameter.  From (1.5) and (1.7), the product bad dimension is
at most

\[
36+U-S,
\]

so the restriction codimension is at least

\[
(66-3S)-(36+U-S)=30-U-2S.
\tag{3.2}
\]

Write \(c=17-\dim\{\sigma\}\) for the codimension of the base stratum.
For a simple base cluster of length \(\ell\), the exhaustive table in the
primitive-base certificate gives

\[
c\ge\ell.
\tag{3.3}
\]

If \(S\) of its simple centers lie successively on the selected strict
lines, this incidence has codimension at least \(S\) in the joint
base-cluster/marked-line space.  Call that codimension \(a\).  This
includes proper centers and successive free tangent directions: at each
blowup the selected strict line is a divisor in the surface on which the
next free center moves.  Satellite centers are not followed by a plane
line and do not contribute to \(S\).  Thus

\[
a\ge S,\qquad S\le\ell.
\tag{3.4}
\]

After all parameters move, the margin from (3.2) is at least

\[
(30-U-2S)-\bigl((17-c)+10-a-U\bigr)
=3+c+a-2S\ge3.
\tag{3.5}
\]

For a multiplicity-two base point on one selected line, \(S=2\), while
\(c\ge7\) and the support-line incidence gives \(a\ge1\).  Its margin is
at least seven.

Now suppose every line through \(p\) is unbalanced.  The all-unbalanced
pencil classification has two rank-three alternatives.  One is
base-point-free; the other has precisely a length-two base cut out on a
fixed line.  Rank-two triples form the remaining case.  In all cases the
pair \((\sigma,p)\) has dimension at most fifteen.  Before further base
alignments, (1.5) gives codimension \(66-4\cdot10=26\), and the four
residual marked paths move in dimension at most eight.

A selected line containing one simple base unit lowers this codimension
by one; a line containing two lowers it by three.  Requiring the marked
line to follow those units costs respectively at least one or two joint
parameters.  Since there are at most four simple units, the total loss is
at most the alignment codimension plus two.  Hence the remaining margin is
at least

\[
26-(15+8)+a-(a+2)=1.
\tag{3.6}
\]

An \(\mathfrak m_p^2\) base point on a selected line also lowers the
codimension by three but costs one alignment parameter, giving margin one
already from (3.6).  The smaller dimension of its actual base stratum only
improves the result.

### 3.2 The center is a simple base point

If \(p\) itself is a simple base point, all four selected strict lines
initially have \(s=1\), so their bad dimensions sum to at most thirty-two.
For local base lengths \(\mu=1,2,3,4\), (2.6) and (2.7) give respectively

\[
\begin{array}{c|rrrr}
\mu&1&2&3&4\\ \hline
\text{fixed codimension}&30&26&24&22\\
\text{triple dimension}&16&14&12&10\\
\text{margin after four residual paths}&6&4&4&4.
\end{array}
\tag{3.7}
\]

If a further base center lies on a selected strict line, its elementary
transform loses at most two units of fixed codimension.  The line
incidence costs one parameter and the appropriate base stratum drops by at
least one dimension.  Thus neither margin can decrease.  This also covers
additional proper base supports.  A multiplicity-two center cannot equal
\(p\), by the uniform \(t=2\) theorem.

All cases have a strict margin.  Therefore a general equation has no
primitive isolated-base triple with profile \([4,2^4]\).

## 4. Exclusion of \([3^3,2]\)

By the intrinsic properness theorem, the three \(t=3\) centers
\(p_1,p_2,p_3\) are proper, distinct, and noncollinear.  Their triangle

\[
C=L_{12}\cup L_{23}\cup L_{31}
\]

has twelve units of branch contact on every side.  The single \(t=2\)
center is now forgotten entirely; it need not be proper and need not be
separated from the base scheme.

Suppose first that no vertex is a base point.  With no base incidence, the
three-line coefficient image has dimension fifty-four and the worst
product bad dimension is thirty, so the fixed codimension is twenty-four.
The vertices move in dimension six.

A selected side containing one simple base unit lowers the image by three
and the bad dimension by two, so it lowers the fixed codimension by one.
Two units on the same side lower the image by six and the bad dimension by
three, hence lower the codimension by three.  Let \(\lambda\) be the sum
of these losses.  For a simple base cluster of length \(\ell\), the joint
alignment codimension \(a\) is at least the number of units on the
triangle.  A two-unit side costs two parameters, so

\[
\lambda\le a+2.
\tag{4.1}
\]

Using \(c\ge\ell\), the moving margin is

\[
(24-\lambda)-\bigl(6+(17-c)-a\bigr)
=1+c+a-\lambda>0.
\tag{4.2}
\]

The margin is at least two; the four-unit configuration consisting of two
two-unit sides has margin three.  For a multiplicity-two base point on a side,
\(\lambda=3\), \(a\ge1\), and \(c\ge7\), so the margin is at least six.

It remains to allow base vertices.  At a first-jet-rank-two base vertex,
Section 2.2 gives fixed codimension twenty-four: the four-dimensional
restriction-image loss is exactly compensated by the four-dimensional
drop in the two bad line spaces.  The coincidence also removes two vertex
parameters, and its base stratum has codimension at least one.

At a first-jet-rank-one base vertex, the fixed codimension is at least
twenty-two, a loss of two.  Such a base cluster has length at least two and
lies in a triple stratum of dimension at most fourteen, while the vertex
coincidence again removes two parameters.  The gain in parameter dimension
is therefore at least five against a loss of two.

For completeness, here is a single simultaneous audit which does not use
the base-stratum codimension twice.  Let \(v_2\) and \(v_1\) be the numbers
of first-jet-rank-two and first-jet-rank-one base vertices, and put
\(v=v_1+v_2\).  For each triangle side let \(s_i\in\{0,1,2\}\) be its
total base weight, including its base endpoints and any further free
centers followed by that side, and set

\[
S=s_1+s_2+s_3,\qquad
\beta(0)=0,\quad\beta(1)=2,\quad\beta(2)=3.
\]

The elementary image loss would be \(3S\).  At a rank-two base vertex the
exceptional calculation restores two image dimensions; at a rank-one
vertex it restores none.  The product bad dimension is at most
\(30-\sum_i\beta(s_i)\).  Therefore the fixed codimension is at least

\[
24-3S+2v_2+\sum_i\beta(s_i).
\tag{4.3}
\]

The vertex coincidences remove \(2v\) parameters.  Let \(a\) count only
the alignments of the remaining, nonvertex base units with triangle sides,
and let \(c\) be the single global base-stratum codimension.  The resulting
margin is

\[
\boxed{
1+c+a+2v+2v_2-3S+\sum_i\beta(s_i).}
\tag{4.4}
\]

Now allocate the inequality \(c\ge\ell\) once, one unit for every simple
base center.  A vertex unit contributes two to \(S\), removes two vertex
parameters, and contributes one to \(c\).  A further unit changing
\(s_i:0\to1\) contributes one to both \(c\) and \(a\) and lowers the fixed
codimension by one; a unit changing \(s_i:1\to2\) contributes the same two
parameter conditions and lowers the fixed codimension by two.  Thus adding
any nonvertex unit cannot lower (4.4).  With vertices alone, (4.4) becomes

\[
1+c+2v_2-\binom v2>0
\tag{4.5}
\]

for \(0\le v\le3\).  A rank-one vertex consumes an additional successor
base unit, so its actual \(c\) is larger than this conservative bound.
This proves all multiple-vertex and mixed vertex/side rows without reusing
any dimension drop.

Consequently no primitive isolated-base triple has profile \([3^3,2]\)
for a general equation.

## 5. Resulting squarefree boundary

The companion certificates exclude \([5]\) and \([4,3,2]\) on the whole
primitive locus.  The present theorem removes \([4,2^4]\) and
\([3^3,2]\).  Hence the primitive squarefree \(k=2\) frontier is reduced
to

\[
\boxed{[3^2,2^4]\qquad\text{and}\qquad[3,2^7].}
\tag{5.1}
\]

No existence is asserted for either remaining profile.  The numerical
line-fiber ledger, base-stratum margins, exceptional-filtration ranks, and
all worst-case incidence margins are replayed by
[`k2_isolated_base_retained_profile_checks.py`](k2_isolated_base_retained_profile_checks.py).
