# Adjoint reduction of the remaining squarefree profiles

## Statement and scope

Let

\[
0\longrightarrow \mathscr K\longrightarrow
\mathcal O_{\mathbf P^2}^{\oplus3}
\xrightarrow{\ \sigma\ }\mathcal O_{\mathbf P^2}(2)
\longrightarrow0
\]

be defined by a base-point-free quadratic triple, and put

\[
\mathcal Q_2=\operatorname {Sym}^2(\mathscr K^\vee)
\otimes\mathcal O_{\mathbf P^2}(4).
\]

For a general bidegree-\((2,4)\) equation:

1. there is no squarefree branch with profile

   \[
   \boxed{[3,3,2,2,2,2]}
   \tag{0.1}
   \]

   whose four \(t=2\) centers are all proper; and
2. there is no squarefree branch with profile \([3,2^7]\) whose eight
   essential centers are all proper.  Its seven reducible adjoint cubics
   first reduce to a cover by forty-two explicit line or conic blocks;
   every block supplies a branch component of degree one or two, whereas
   Section 7 excludes every pair of such components for a general
   equation.

Both assertions are new exclusions.  Thus a base-point-free survivor of
\([3^2,2^4]\), if one exists, has an infinitely-near \(t=2\) center; a
survivor of \([3,2^7]\) has an infinitely-near essential center.  This
note does not treat isolated-base triples, infinitely-near \(t=2\) centers
in the first profile, or any infinitely-near center in the second.

Throughout, \(B\) denotes the reduced degree-twelve branch.  At a proper
\(t=3\) center its plane multiplicity is at least six, and at a proper
\(t=2\) center it is at least four.

## 1. Exact deleted adjoint cubics for \([3^2,2^4]\)

Write the adjoint cluster as

\[
D=2v_1+2v_2+r_1+r_2+r_3+r_4,
\tag{1.1}
\]

where only the four \(r_i\)'s are initially assumed proper.  Its virtual
colength is

\[
2\binom32+4=10.
\]

The rationality condition \(H^0(\mathcal J_D(3))=0\) therefore makes
cubic evaluation an isomorphism.  On deleting \(r_i\), the remaining
cluster has colength nine and has a unique projective cubic \(C_i\).  The
omitted point does not lie on it.

Deleting all four coefficient-one summands shows in the same way that
\(2v_1+2v_2\) has colength six and that its cubic space has vector
dimension four.  Equality with the virtual colength means that unloading
does not erase either coefficient-two condition; the strict transform of
every cubic has multiplicity at least two at both marked centers.  This
forces an exact dichotomy for the two high centers.
A reduced cubic can have two marked double centers only at two distinct
proper points, or at a proper intersection point of a line and a conic and
their free first-near intersection in the tangent case.  In every other
Enriques position, any cubic satisfying both double conditions is
nonreduced.  Its double line must follow both centers, so the whole cubic
path; the first infinitely-near direction (or the two proper origins)
determines that plane line uniquely.  The whole cubic space is therefore
contained in

\[
L^2H^0(\mathcal O_{\mathbf P^2}(1)),
\]

which has dimension three, a contradiction.  Hence either:

1. \(v_1=p\) and \(v_2=q\) are distinct proper points; or
2. \(v_1=p\) is proper and \(v_2=q\) is its free first-near point in a
   plane-line direction \(L\).

In the second case every cubic in the four-dimensional system contains
\(L\).  Its residual conic passes through both intersection centers, so it
is tangent to \(L\) at \(p\).  Every reducible conic in this tangent
linear system contains \(L\): if it is smooth at \(p\), its component
through \(p\) is the tangent line; if it is singular there, one tangent
direction must be the marked direction \(L\).

The four proper low centers do not lie on \(L\).  The strict branch
multiplicities along the two high centers sum to at least twelve: the only
free parity rows have sums 12 or 13.  Adding one low multiplicity gives
the same two-pass bound \(16\), then 13 after subtracting \(L\), so a low
center on \(L\) would force \(L^2\mid B\).

If all four deleted residual conics were reducible, each would be
\(L\cup M_i\), and the three selected low points would lie on \(M_i\).
Every complementary triple of the four low points would then be collinear,
contradicting the fact that the omitted point is not on \(C_i\).  Thus some
selected residual conic is integral.  Section 2 applies verbatim, with
high-center movement dimension three instead of four.  Its ordinary and
all-unbalanced-pencil margins are consequently two rather than one.  This
excludes the free first-near case.

It remains to treat the first case.  Put \(L=\overline{pq}\).  A cubic
double at both \(p\) and \(q\) has intersection multiplicity at least four
with \(L\), so Bezout forces
\(L\) to be a component.  Consequently

\[
C_i=L\cup Q_i,
\tag{1.2}
\]

where \(Q_i\) is the unique conic through \(p,q\) and the three points
\(r_j\), \(j\ne i\).  Moreover

\[
r_i\notin L\cup Q_i.
\tag{1.3}
\]

No \(r_i\) lies on \(L\).  Indeed, the marked branch contact on such a
line would be at least \(6+6+4=16\).  After subtracting the forced line
once, the residual degree-eleven curve would still have contact at least
\(5+5+3=13\), forcing \(L\) a second time.  This contradicts
squarefreeness.

## 2. An integral selected conic

Suppose some \(Q_i\) is integral.  On its normalization,

\[
\mathscr K^\vee|_{Q_i}\simeq
\mathcal O_{\mathbf P^1}(a)\oplus
\mathcal O_{\mathbf P^1}(4-a),
\qquad 0\le a\le2.
\]

The three entries of a restricted symmetric form have degrees

\[
(8+2a,\ 12,\ 16-2a).
\tag{2.1}
\]

The binary UFD estimate gives dimension at most seventeen for every fixed
determinant fiber, including the zero fiber.  The contact at \(p,q\) and
the three selected \(r_j\)'s is at least

\[
6+6+3\cdot4=24=\deg(B|_{Q_i}),
\]

so the allowed determinant targets form a vector space of dimension at
most one.  The bad locus on \(Q_i\) has dimension at most eighteen.

On \(L\), contact at \(p,q\) is at least twelve.  The bad dimension is at
most nine when \(L\) is balanced and ten when it is unbalanced.  Since
restriction to the reduced cubic \(L\cup Q_i\) has image dimension

\[
72-h^0(\mathcal Q_2(-3))=72-18=54,
\]

forgetting the gluing at \(L\cap Q_i\) gives fixed codimension at least

\[
54-(10+18)=26.
\tag{2.2}
\]

The omitted point \(r_i\notin C_i\) supplies four further determinant-jet
conditions.  This is the four-jet lemma from
[`k2_combined_proper_cluster_exclusion.md`](k2_combined_proper_cluster_exclusion.md):
extensions of a fixed restriction to \(C_i\) differ by
\(H^0(\mathcal Q_2(-3))\), and a balanced line through \(r_i\) realizes
arbitrary symmetric four-jets.  The six selected points move in dimension
twelve and \(\sigma\) in dimension seventeen, so even the worst ordinary
margin is

\[
(26+4)-(12+17)=1.
\tag{2.3}
\]

If every line through \(r_i\) is unbalanced, omit its branch condition.
The pair \((\sigma,r_i)\) then has dimension at most fifteen.  The other
five points move in dimension ten, and (2.2) leaves the same strict margin

\[
26-(10+15)=1.
\tag{2.4}
\]

Thus the integral-\(Q_i\) subrow is absent.

## 3. When all four selected conics split

Assume now that no \(Q_i\) is integral.  A nonreduced conic would be
\(2M\).  Since it contains \(p\) and \(q\), one has \(M=L\), contrary to
Section 1.  Thus every \(Q_i\) is a union of two distinct lines.

At least one \(Q_i\) does not contain \(L\).  Otherwise the three points
\(r_j\), \(j\ne i\), would be collinear for every \(i\).  The triples for
\(i=1,2\) share two points, hence all four \(r_j\)'s would lie on one line.
Then that line would also contain the omitted point in (1.3), a
contradiction.  Fix an index with

\[
C_i=L\cup M\cup N
\tag{3.1}
\]

three distinct lines.

There is also a parameter saving that must not be discarded.  Reducibility
of \(Q_i\) says that the five marked points on it contain a collinear
triple.  Because no \(r_j\) lies on \(L\), such a triple is either one of
\(p,q\) together with two low points, or three low points.  The first type
can witness at most two of the four reducibilities \(Q_i\); the second can
witness only one.  Hence all four conics being reducible requires at least
two distinct collinearity equations.  Distinct collinearity determinants
are nonassociate irreducible equations on the open ordered-point
configuration space.  Therefore

\[
\dim\{(p,q,r_1,\ldots,r_4):Q_1,\ldots,Q_4
\text{ all reducible}\}\le12-2=10.
\tag{3.2}
\]

## 4. Exact three-line bound in the split case

Let \(j\) be the number of unbalanced lines among \(L,M,N\).  For a line
with marked contact \(R\), the determinant bad dimension is bounded by

\[
\begin{cases}
8+\max(13-R,0),&\text{balanced},\\
9+\max(13-R,0),&\text{unbalanced}.
\end{cases}
\tag{4.1}
\]

The maximum with zero is essential: if \(R>12\), the target is the zero
polynomial, but its inverse image still has dimension eight or nine.

The line \(L\) has \(R\ge12\), so its contribution is at most nine, plus
one if it is unbalanced.  Each of \(M,N\) contains exactly one of
\(p,q\).  Indeed, neither is \(L\), and a marked high point cannot lie on
both lines.  Squarefreeness prevents a line through a high point and three
low points.  The three selected low points are consequently distributed
as \((2,1)\), or as \((2,2)\) when one low point is \(M\cap N\).

In the first case the line carrying one high and two lows has contact at
least fourteen.  It is a branch component, and squarefreeness forces the
contact to be exactly fourteen; its bad dimension is at most eight.  The
other line has contact at least ten and bad dimension at most eleven.  In
the second case both lines are branch components and their balanced bad
dimensions are at most eight each.  Uniformly, the product bad dimension
on the three lines is therefore at most

\[
28+j.
\tag{4.2}
\]

Inside the fifty-four-dimensional restriction image, the fixed
codimension is at least \(26-j\).  At an ordinary omitted point, the
four-jet lemma raises this to \(30-j\).

For \(j=0\), (3.2) and the seventeen-dimensional \(\sigma\)-space leave
margin three.  For \(j>0\), unbalancedness of any one selected line is a
proper hypersurface in the \(\sigma\)-space, so the moving dimension is at
most \(10+16=26\).  The margins for \(j=1,2,3\) are respectively

\[
3,\ 2,\ 1.
\tag{4.3}
\]

It remains to check the all-unbalanced pencil through the omitted point
\(z=r_i\).  The locus of pairs \((\sigma,z)\) has dimension fifteen, so
its fiber product with the configuration locus (3.2) has dimension at most
\(10+15-2=23\).  For \(j=0,1,2\), the margins from \(26-j\) are
\(3,2,1\).

When \(j=3\), one additional condition is available.  On the
all-unbalanced-pencil locus, the value-and-first-derivative matrix of
\(\sigma\) at \(z\) has rank one.  Conversely, after a target change, a
rank-one first jet has two entries with zero value and first derivatives;
they are binary quadrics in the two coordinates vanishing at \(z\), and
their restrictions to every line through \(z\) are proportional.  Thus,
on the base-point-free open set, the all-pencil locus is precisely this
irreducible determinantal stratum.  Unbalancedness of a fixed line not
through \(z\) is not automatic there.  In coordinates
\(z=[0:0:1]\), the base-point-free triple

\[
(z^2,x^2,y^2)
\]

has every line through \(z\) unbalanced, while its restrictions to a line
such as \(z=x+y\) are balanced.  Since (1.3) says that all three selected
lines avoid the omitted point, one selected unbalanced-line equation cuts
the pair stratum by at least one.  Its moving dimension is at most 22, and
the fixed codimension \(26-3=23\) again leaves margin one.

Sections 1--4 exclude every \([3^2,2^4]\) realization whose four
\(t=2\) centers are proper.

## 5. Adjoint blocks for \([3,2^7]\)

Now write

\[
D=2p+q_1+\cdots+q_7
\tag{5.1}
\]

with all eight centers proper.  Cubic evaluation is again an isomorphism.
For each omitted label \(i\), let \(C_i\) be the unique cubic double at
\(p\), through all \(q_j\) with \(j\ne i\), and not through \(q_i\).
The integral-\(C_i\) case is excluded in Section 6 of
[`k2_combined_proper_cluster_exclusion.md`](k2_combined_proper_cluster_exclusion.md).

For distinct labels \(a,b\), introduce two blocks:

\[
\begin{aligned}
P_{ab}&:\quad p,q_a,q_b\text{ are collinear},\\
Q_{ab}&:\quad p\text{ and the five }q_j\ (j\notin\{a,b\})
\text{ lie on a conic}.
\end{aligned}
\tag{5.2}
\]

Regard \(P_{ab}\) as covering the five omitted labels outside
\(\{a,b\}\), and \(Q_{ab}\) as covering the two labels \(a,b\).

Every squarefree-compatible reducible \(C_i\) supplies a block covering
\(i\).  To see this, first note that a line through \(p\) and three low
points, or a line through four low points, would occur twice in \(B\) by
the two-pass Bezout lemma.  A nonreduced cubic \(2L+M\) cannot pass through
the six selected low points within these capacities: the double line must
pass through \(p\), so the two supports cover at most \(2+3=5\) low
points.

If \(C_i\) is a line times an integral conic, both components pass through
\(p\).  If the line contains two selected low points, it gives a
\(P_{ab}\) block with \(i\notin\{a,b\}\).  Otherwise the conic contains
at least five selected low points and gives a \(Q_{ab}\) block with
\(i\in\{a,b\}\).  If \(C_i\) is three distinct lines, at least two pass
through \(p\); the capacity bounds force one of them to contain two
selected low points, again giving a \(P\)-block.

Thus the block-cover condition is necessary:

\[
\boxed{
\{1,\ldots,7\}
\subset
\bigcup P_{ab}^{\rm cover}\cup\bigcup Q_{ab}^{\rm cover}.}
\tag{5.3}
\]

There are twenty-one blocks of each kind.

## 6. The exact two-block alternatives

The set-cover problem in (5.3) is elementary and exact.

- Two \(P\)-blocks cover all seven labels precisely when their excluded
  pairs are disjoint.  There are

  \[
  \binom74\cdot3=105
  \tag{6.1}
  \]

  unordered labeled types.
- A \(P_{ab}\) and a \(Q_{cd}\) cover all labels precisely when
  \(\{a,b\}=\{c,d\}\).  There are 21 matched types.
- Two \(Q\)-blocks cover at most four labels.

The matched type sharpens further.  The \(P_{ab}\)-line has branch contact
at least fourteen and is a branch component.  If the matched conic
\(Q_{ab}\) is integral, its contact at \(p\) and its five marked low points
is at least \(6+5\cdot4=26\), so it too is a branch component.  Restriction
to their reduced cubic has image dimension 54; the zero-determinant fibers
have dimensions at most nine on the line and seventeen on the conic.
Thus the fixed codimension is at least

\[
54-(9+17)=28.
\]

The line, conic, and \(\sigma\) move in dimensions \(2+5+17=24\), leaving
a strict margin four.

If the matched conic is reducible, squarefreeness forces its component
through \(p\) to contain exactly two of the five low points, while the
other component contains the remaining three.  This produces a second
\(P\)-block whose label pair is disjoint from \(\{a,b\}\).  A nonreduced
matched conic would put \(p\) and five low points on one line and is
impossible.  Hence every two-block survivor is already one of the 105
disjoint-\(P\) types.

At this point, a putative survivor either has two distinct branch lines
through \(p\), each carrying a disjoint pair of the seven \(t=2\) points,
or its block cover has no two-block subcover and uses at least three of the
explicitly named conditions (5.2).  The next section excludes both
possibilities at once.

## 7. Two low-degree branch components are absent

For a general equation on the base-point-free quadratic-triple locus, the
branch cannot contain two distinct integral components, each of degree at
most two.  This follows directly from determinant restriction.

For two distinct lines, restriction has image dimension 39.  If exactly
\(j\) of the lines are unbalanced, the product of the two zero-determinant
fibers has dimension at most \(16+j\), while the corresponding
\(\sigma\)-stratum has dimension at most \(17-j\).  After the two lines
move in dimension four, the equation-space margin is uniformly

\[
\bigl(39-(16+j)\bigr)-\bigl((17-j)+4\bigr)=2.
\tag{7.1}
\]

For a line and an integral conic, restriction to their cubic union has
image dimension 54.  The zero-determinant fibers have dimensions at most
eight and seventeen when the line is balanced, and at most nine and
seventeen when it is unbalanced.  Unbalancedness costs one \(\sigma\)
parameter, so both splitting strata have margin

\[
54-(8+17)-(17+2+5)
=54-(9+17)-(16+2+5)=5.
\tag{7.2}
\]

For two distinct integral conics, restriction to their quartic union has
image dimension 66.  The two zero fibers have product dimension at most
34.  The conics and \(\sigma\) move in dimension \(10+17\), leaving

\[
66-34-(10+17)=5.
\tag{7.3}
\]

All three margins are strict.  The estimates forget every gluing condition
at intersections, so tangencies and special intersections are included.

We now return to the block cover.  Every \(P_{ab}\)-block gives a branch
line: its marked contact is at least fourteen.  A \(Q_{ab}\)-block has
contact at least 26 on its conic.  If that conic is integral, it is a
branch component.  If it is reducible, squarefreeness forces the component
through \(p\) to contain exactly two of the five marked low points; this is
a \(P\)-block whose five-label cover contains the original two-label
\(Q\)-cover.  A nonreduced conic is impossible.  Thus every \(Q\)-block
may be retained as an integral branch conic or replaced by a branch-line
\(P\)-block without losing any covered label.

Distinct \(P\)-blocks give distinct branch lines.  Otherwise one line
would contain \(p\) and at least three low points and would be doubled in
\(B\).  Distinct integral \(Q\)-blocks give distinct branch conics.  If
one integral conic realized two different blocks, it would contain \(p\)
and at least six low points.  After subtracting it once, the residual
degree-ten branch would still have intersection at least

\[
(6-1)+6(4-1)=23>20
\]

with that conic, forcing it a second time.

Consequently a block cover of all seven labels produces at least two
distinct branch components of degrees at most two: a single \(P\)-block
covers only five labels, and a single integral \(Q\)-block only two.
Equations (7.1)--(7.3) exclude that pair for a general equation.  This
closes the all-proper \([3,2^7]\) row.

The colengths, restriction dimensions, contact strata, margins, the
complete forty-two-block/two-block enumeration, and the low-degree factor
pair exclusions are replayed by
[`k2_remaining_all_proper_adjoint_checks.py`](k2_remaining_all_proper_adjoint_checks.py).
