# Exclusion of the root partition \([2,1,1,1,1]\)

## Statement

Work over an algebraically closed field of characteristic zero in the
squarefree six-\(t=2\) row of
[`k1_double_decic_frontier.md`](k1_double_decic_frontier.md).  Suppose that
two essential centers lie in one proper-origin tree and that the other four
essential centers lie in four singleton trees.  Then this incidence does not
occur for a general bidegree \((2,4)\) equation, for either a rank-three or a
rank-two bilinear section \(\sigma\).

Thus the root partition

\[
\boxed{[2,1,1,1,1]}
\]

is absent.  For a fixed canonical \(\sigma\), every rank-three incidence
below has affine codimension at least nine in the sixty-dimensional
restricted coefficient space, and every rank-two incidence has codimension
at least eight.  These are strictly larger than the projective matrix-orbit
dimensions eight and seven.

The complete classification of the two-essential tree is the input from
[`k1_two_essential_tree_classification.md`](k1_two_essential_tree_classification.md).
The proof below retains its unloading, all four singleton roots, the full
canonical branch, and every rank-two base-point position.  No predecessor
divisor is discarded.  The uniform fixed-branch determinant-fiber bound
\(31\) from
[`k1_repeated_root_frontier.md`](k1_repeated_root_frontier.md) remains valid;
the marked conics below give the sharper binary bounds needed for a direct
incidence proof.

## 1. The exact local data

At a canonical center \(v\), write

\[
m_v=\operatorname {mult}_v(B_v^{\mathrm {strict}}),\qquad
e_v=\#\{\text{exceptional branch curves through }v\},\qquad
r_v=m_v+e_v.
\tag{1.1}
\]

The classification theorem makes the following table exhaustive.  In a
point basis, the entries in the two cluster columns are the antinef unloadings
of the raw total-transform weights supported at the essential centers.  Zero
terminal entries have been suppressed.

\[
\begin{array}{c|c|c|c|c|c}
\text{core}&(r_v)&(m_v)&D&2D&
 c_R\\ \hline
A_{44}&(4,4)&(4,4)&(1,1)&(2,2)&8\\
A_{54}&(5,4)&(5,3)&(1,1)&(2,2)&8\\
A_{55}&(5,5)&(5,4)&(1,1)&(2,2)&9\\
F\!-\!P&(4,3,4)&(4,3,3)&(1,1)&(2,1,1)&7\\
S&(5,3,4)&(5,2,2)&(1,1)&(2,1,1)&7\\
F\!-\!N&(3,4,3,4)&(3,3,3,3)&(1,1)&(1,1,1,1)&6
\end{array}
\tag{1.2}
\]

Here \(A\) is an adjacent free pair.  In \(F\!-\!P\), a proper essential
center and its essential descendant are separated by one free negligible
center.  In \(S\), the negligible center is free and the later essential
center is the satellite at the two displayed exceptional curves.  In
\(F\!-\!N\), the first essential is first-near over a proper triple point,
and the remaining steps are free.  The number \(c_R\) is a lower bound for
the contact of the branch with a smooth curve through the length-two tangent
cluster at the proper root: it is the sum of the first two strict
multiplicities in the displayed path.

The simple cluster in every row is therefore a length-two tangent vector at
the proper root.  The doubled local lengths are

\[
\ell_A=6,\qquad
\ell_{F-P}=\ell_S=5,\qquad
\ell_{F-N}=4,
\tag{1.3}
\]

because a consistent point basis \((a_i)\) has colength
\(\sum_i\binom{a_i+1}{2}\).

Each singleton tree has one of the two types already proved in
[`k1_singleton_root_exclusion.md`](k1_singleton_root_exclusion.md):

\[
\begin{array}{c|c|c|c}
\text{type}&(r_v;m_v)&\operatorname {length}(D)&
 \operatorname {length}(2D)\\ \hline
P&(4\text{ or }5;\ 4\text{ or }5)&1&3\\
N&(3,4;\ 3,3)&1&2.
\end{array}
\tag{1.4}
\]

Let \(n\) be the number of type-\(N\) singleton trees among the four.  The
five proper origins are distinct, so their local ideals are comaximal.  The
doubled-cluster length is therefore

\[
\ell_R+3(4-n)+2n=\ell_R+12-n.
\tag{1.5}
\]

The vanishing \(H^0(\mathcal J_{2D}(4))=0\) injects the
fifteen-dimensional space of quartics into this quotient.  Hence

\[
\boxed{
n\le3\text{ in }A,\qquad
n\le2\text{ in }F\!-\!P\text{ or }S,\qquad
n\le1\text{ in }F\!-\!N.}
\tag{1.6}
\]

All intermediate negligible centers are present in (1.2), and hence in its
unloading and contact numbers.  A terminal \(t=1\) decoration after the last
essential center has zero weight in \(D\) and \(2D\), so it does not change
the complete ideals above.  Its position is a canonical resolution center
determined, up to a finite choice, by the branch; it is not an independent
parameter after the branch is fixed.  Forgetting it from the marked
incidence therefore does not enlarge a fiber dimension, while its branch
condition can only cut the locus.  This is the precise sense in which the
full predecessor divisor \(D_1\) and all terminal decorations are retained
below.  In particular, the proof never replaces the actual determinantal
branch by the enlarged system \(H^0(\mathcal J_{4D}(10))\): the strict
multiplicities in (1.2) retain the odd exceptional branch components, and
every unmarked \(D_1\)-condition is an additional condition on the same
branch.

## 2. Selecting the test conic

The simple cluster has length six: the tangent vector at the repeated root
and the four reduced singleton origins.  Since

\[
H^0(\mathcal J_D(2))=0,
\]

evaluation of the six-dimensional space of conics on this cluster is an
isomorphism.  Consequently, after choosing any three singleton origins,
there is a unique projective conic \(Q\) through those three points and the
length-two tangent vector.

Choose the three origins by omitting a type-\(N\) origin whenever one is
available.  If \(n_s\) is the number of selected type-\(N\) origins, the
bounds (1.6) give

\[
\begin{array}{c|c|c|c}
\text{core}&n_s\text{ needed}&c_R&
c:=I(B,Q)\text{ forced at the marks}\\ \hline
A&n_s\le2&8&c_R+12-n_s\ge18\\
F\!-\!P,S&n_s\le1&7&c_R+12-n_s\ge18\\
F\!-\!N, n=0&0&6&18\\
F\!-\!N, n=1&0&6&18.
\end{array}
\tag{2.1}
\]

For a smooth \(Q\), the repeated tangent vector makes its strict transform
pass through the first two centers used in \(c_R\).  A selected \(P\) origin
contributes at least four and a selected \(N\) origin at least three.  This
proves (2.1).  Any extra contact, including contact from \(D_1\), only makes
the determinant target smaller.

### 2.1 Why a smooth choice exists

The line-component theorem in
[`k1_six_proper_centers_exclusion.md`](k1_six_proper_centers_exclusion.md)
will be used repeatedly: a line with branch contact greater than ten is a
branch component and is absent in the retained locus.  A double-line conic is
always impossible here, because its support contains the repeated root and
all three selected origins and hence has contact greater than ten.

If \(A\) has \(n\le2\), choose at most one \(N\) among the three marks.  If a
reducible conic is smooth at the repeated root, it is the union of the marked
tangent line \(\tau\) and another line.  A selected point on \(\tau\) gives
contact at least \(8+3>10\), while no selected point on \(\tau\) puts all
three on the other line, with contact at least eleven.  If the conic is
singular at the repeated root, one component contains that root and two
selected origins.  At least one of those two is a \(P\) origin, so its
contact is at least \(4+(4+3)>10\).  Thus \(Q\) is smooth.

Suppose \(A\) has \(n=3\), with singleton origins \(P,N_1,N_2,N_3\).
For each \(i\), take the candidate omitting \(N_i\).  A nonsmooth candidate
can have only one of the following two forms:

1. \(\tau\) plus the line through \(P,N_j,N_k\); or
2. in the \(A_{44}\) row only, the two lines through the repeated root, one
   of which also contains \(N_j,N_k\).

A selected origin at the node of the two components only increases one of
these line contacts and is already excluded.  Associate the pair
\(\{N_j,N_k\}\) to \(P\) in the first case and to the repeated root in the
second.  If all three candidates were nonsmooth, two of the three pairs
would be associated to the same point.  The two pair-lines share an \(N_i\),
so that point and all three \(N_i\) would be collinear.  Their branch contact
is at least \(4+3+3+3=13\), a contradiction.  At least one candidate is
smooth.

For \(F\!-\!P\) and \(S\), the same elementary check proves smoothness when
\(n\le1\).  When \(n=2\), take the two candidates obtained by omitting one
of the two \(N\) origins.  A nonsmooth candidate can only be
\(\tau\) union the line through the two selected \(P\) origins, with the
selected \(N\) origin on \(\tau\); the two line contacts are then the limiting
values ten and eight.  If both candidates failed, both \(N\) origins would
lie on \(\tau\), giving contact at least \(7+3+3=13\).  Hence one is smooth.

For \(F\!-\!N\) with \(n=0\), at most one of the four \(P\) origins can lie
on \(\tau\).  Omit it if it exists.  A reducible candidate would then put all
three selected \(P\) origins on one line, or two of them on a line through
the repeated root.  The contacts are respectively twelve and
\(3+4+4=11\), so the conic is smooth.

Finally let \(F\!-\!N\) have \(n=1\), and omit the unique \(N\) origin.  If
none of the three selected \(P\) origins lies on \(\tau\), the same argument
gives a smooth conic.  If one, say \(P_1\), lies on \(\tau\), the candidate is
again smooth unless

\[
\boxed{Q=\tau\cup L,\qquad P_1\in\tau,\qquad P_2,P_3\in L.}
\tag{2.2}
\]

The two lines are distinct and their node is unmarked; otherwise one line
has contact greater than ten.  This is the sole nodal exception, treated in
Section 5.

## 3. Determinant-fiber bounds

For a smooth conic, the fixed-fiber bounds already proved in the singleton
certificate are

\[
\begin{array}{c|c|c}
\text{rank/base position}&\text{binary degrees}&F\\ \hline
3&(10,10,10)&12\\
2,\ b\notin Q&(12,10,8)&13\\
2,\ b\in Q&(10,9,8)&11.
\end{array}
\tag{3.1}
\]

Here \(F\) bounds every fiber over a fixed determinant, including zero.
The scaling degeneration to the zero fiber then gives
\(\dim\det^{-1}(U)\le F+\dim U\) for every linear determinant target \(U\).

We also need the following nodal version.  Write \(V_{654}\) and
\(V_{444}\) for the two line-restriction spaces.  At the chosen node point on
each line, stratify the determinant-zero cone by the common symmetric matrix
value \(M\).  Direct UFD factorization gives

\[
\begin{array}{c|c|c|c}
V&\dim\{\det=0\}&M=0&\text{fixed nonzero rank-one }M\\ \hline
V_{654}&7&6&\le5,\text{ except }\le6\text{ on the high diagonal}\\
V_{444}&6&5&\le4.
\end{array}
\tag{3.2}
\]

For \(M=0\), divide all entries by the marked linear form; the two dimensions
are the zero-cone dimensions in \(V_{543}\) and \(V_{333}\).  For nonzero
\(M\), the nonboundary UFD form
\((a,b,c)=h(u^2,uv,v^2)\) loses the two parameters of the rank-one value.
The only larger boundary is \((a,0,0)\) in \(V_{654}\): fixing its nonzero
constant leaves six parameters, and those values move in a one-dimensional
diagonal cone.  This proves (3.2), including all vanished-entry boundaries.

Two \(V_{654}\) triples with the same value therefore have determinant-zero
cone of dimension at most

\[
\max\{6+6,\ 2+5+5,\ 1+6+6\}=13.
\tag{3.3}
\]

A \(V_{444}\) and a \(V_{654}\) triple with the same value have bound

\[
\max\{5+6,\ 2+4+5,\ 1+4+6\}=11.
\tag{3.4}
\]

Scaling again bounds every fixed determinant fiber by thirteen or eleven,
respectively.

Restriction to a reduced two-line conic has rank thirty-three in rank three.
In rank two the ranks are thirty-three if neither component contains the
base point, thirty if exactly one does, and twenty-nine if their node is the
base point.  The first two spaces are the full fiber products in (3.3) and
(3.4).  The last is a codimension-one subspace of
\(V_{444}\times V_{444}\); componentwise bounds suffice there.

## 4. The smooth-conic incidence

A smooth conic, one marked point on it with its tangent, and three further
marked points on it move in dimension

\[
5+1+3=9.
\tag{4.1}
\]

This count may be read either as the conic plus points or as the unique conic
of Section 2.  The unmarked fourth singleton root and all later canonical
centers are singularity data determined finitely by the branch and add no
fiber dimension.

In rank three, restriction is onto a thirty-three-dimensional space.  A
degree-twenty determinant with the contact \(c\) from (2.1) lies in a target
of dimension \(\max\{21-c,0\}\).  Equations (3.1) and (4.1) give

\[
33-\bigl(12+\max\{21-c,0\}\bigr)-9\ge9.
\tag{4.2}
\]

For rank two, let \(b\) be the base point.  The exhaustive positions are

\[
\begin{array}{c|c|c|c|c}
\text{position of }b&\text{image}&F&\dim U&\dim\text{ configuration}\\ \hline
b\notin Q&33&13&\max\{21-c,0\}&9\\
b\in Q\text{ unmarked}&30&11&\max\{19-c,0\}&8\\
b\text{ is a marked origin}&30&11&\max\{21-c,0\}&7.
\end{array}
\tag{4.3}
\]

In the middle row the forced base square is at an unmarked point, leaving a
degree-eighteen determinant.  In the last row it consumes two units of the
marked contact, giving the displayed target; the marked point may be the
repeated root or a selected singleton origin.  Since \(c\ge18\), the three
fixed-\(\sigma\) codimensions are at least

\[
8,\qquad10,\qquad9,
\tag{4.4}
\]

respectively.  This proves all smooth-conic rows.

## 5. The sole nodal conic

It remains to treat (2.2).  Along \(\tau\), the repeated \(F\!-\!N\) chain
contributes six and \(P_1\) contributes four, so the determinant target on
that line is one-dimensional.  Along \(L\), the two proper origins contribute
eight, giving a three-dimensional target.  Their node is unmarked, and
equality of determinant values there cuts one scalar.  Thus the determinant
target on \(Q=\tau\cup L\) has dimension three.

The two lines, the repeated root and \(P_1\) on \(\tau\), and \(P_2,P_3\) on
\(L\) move in dimension

\[
(2+1+1)+(2+1+1)=8.
\tag{5.1}
\]

For rank three, (3.3) gives

\[
33-(13+3)-8=9>8.
\tag{5.2}
\]

For rank two, the complete base-point audit is

\[
\begin{array}{c|c|c|c|c|c}
\text{position of }b&\text{image}&\text{fiber}&\dim U&
\dim\text{ config}&\text{codim}\\ \hline
b\notin Q&33&13&3&8&9\\
b\in\tau\text{ unmarked}&30&11&2&7&10\\
b\in L\text{ unmarked}&30&11&1&7&11\\
b\text{ a marked origin}&30&11&3&6&10\\
b=\tau\cap L&29&\text{componentwise bad }13&-&6&10.
\end{array}
\tag{5.3}
\]

Here are the target calculations.  If \(b\) is unmarked on \(\tau\), the
base square plus its ten marked contacts force the residual degree-eight
determinant to vanish.  The three-dimensional target on \(L\) must also
vanish at the node, leaving dimension two.  If \(b\) is unmarked on \(L\),
the two one-dimensional component targets glue to a one-dimensional target.
If \(b\) is a marked origin, removal of the base square gives component target
dimensions one and three, with one gluing condition, hence three.  This
includes \(b\) equal to the repeated root, \(P_1\), \(P_2\), or \(P_3\).

If \(b\) is the unmarked node, both strict lines have pattern \(V_{444}\)
and are disjoint on the blowup.  The contact-ten line has zero determinant,
of dimension at most six; the contact-eight line has a one-dimensional
target, of inverse-image dimension at most seven.  Their product has
dimension at most thirteen.  The actual rank-twenty-nine restriction image
is a subspace of that product, proving the last row.  An omitted \(N\) origin
which happens to equal \(b\), or to lie on a component, is already included
in the corresponding unmarked row.

Every entry of (5.3) is larger than the rank-two orbit dimension seven.

## 6. Conclusion and mechanical scope

The exact tree classification, the doubled-cluster length bound, the
smooth-conic selection, and the exceptional nodal audit exhaust the root
partition \([2,1,1,1,1]\).  Pullback from each fixed-\(\sigma\) restriction
space to the space of quartic equations preserves the displayed
codimensions.  Adding the rank-three or rank-two matrix orbit still leaves
positive codimension.  Therefore this root partition is absent for a general
bidegree \((2,4)\) equation.

The accompanying checker
[`k1_two_essential_partition_checks.py`](k1_two_essential_partition_checks.py)
replays the unloadings and local lengths, the allowed values of \(n\), every
smooth-conic margin, the nodal zero-cone dimensions, and every row of
(5.2)--(5.3).
