# Exclusion of the root partition \([2,2,1,1]\)

## Statement

Work over an algebraically closed field of characteristic zero in the
squarefree six-\(t=2\) row of
[`k1_double_decic_frontier.md`](k1_double_decic_frontier.md).  Suppose that
two proper-origin trees contain two essential centers each and that two
further proper-origin trees contain one essential center each.  Then this
incidence does not occur for a general bidegree \((2,4)\) equation, for
either a rank-three or a rank-two bilinear section \(\sigma\).

Thus the root partition

\[
\boxed{[2,2,1,1]}
\]

is absent.  For fixed canonical \(\sigma\), every rank-three incidence below
has affine codimension at least nine in the sixty-dimensional restricted
coefficient space.  Every rank-two incidence has codimension at least eight.
These bounds are strictly larger than the projective matrix-orbit dimensions
eight and seven.

The proof applies the complete local classification in
[`k1_two_essential_tree_classification.md`](k1_two_essential_tree_classification.md)
independently to the two repeated trees.  It retains the antinef unloading,
both singleton trees, the predecessor divisor \(D_1\), and every position of
the rank-two base point.  The global fixed-branch determinant-fiber bound
\(31\) from
[`k1_repeated_root_frontier.md`](k1_repeated_root_frontier.md) remains valid;
the conic restrictions below give sharper bounds for this incidence.

## 1. The two repeated-tree cores

At a canonical center \(v\), write

\[
m_v=\operatorname {mult}_v(B_v^{\mathrm {strict}}),\qquad
e_v=\#\{\text{exceptional branch curves through }v\},\qquad
r_v=m_v+e_v.
\tag{1.1}
\]

Each repeated tree contains exactly two essential centers.  The comparability
and separator arguments of the cited classification are local to that tree,
so each of the two trees independently has one of the following six cores.
The displayed point bases are the antinef unloadings of the raw weights on
the essential centers.

\[
\begin{array}{c|c|c|c|c|c|c}
C&(m_v)&D&2D&\ell_C&\rho_C&t_C\\ \hline
A_{44}&(4,4)&(1,1)&(2,2)&6&4&8\\
A_{54}&(5,3)&(1,1)&(2,2)&6&5&8\\
A_{55}&(5,4)&(1,1)&(2,2)&6&5&9\\
F_P&(4,3,3)&(1,1,0)&(2,1,1)&5&4&7\\
F_N&(3,3,3,3)&(1,1,0,0)&(1,1,1,1)&4&3&6\\
S&(5,2,2)&(1,1,0)&(2,1,1)&5&5&7
\end{array}
\tag{1.2}
\]

Here \(\ell_C\) is the local colength of the doubled cluster, \(\rho_C\)
is the strict multiplicity at the proper origin, and \(t_C\) is the branch
contact forced on a smooth curve through the length-two tangent cluster at
that origin.  It is the sum of the first two strict multiplicities on the
displayed path.  In particular,

\[
2\rho_C\ge t_C
\tag{1.3}
\]

in every row.  This last inequality will handle a conic whose node is the
tangent-marked origin.

A singleton tree has one of the three parity-decorated forms

\[
\begin{array}{c|c|c|c}
Z&(r;m)&\lambda_Z&s_Z\\ \hline
P_4&(4;4)&3&4\\
P_5&(5;5)&3&5\\
N&(3,4;3,3)&2&3.
\end{array}
\tag{1.4}
\]

Here \(\lambda_Z\) is the doubled-cluster colength and \(s_Z\) the strict
multiplicity at the proper origin.  Thus

\[
s_Z\ge\lambda_Z+1.
\tag{1.5}
\]

The simple cluster has local length two in each repeated tree and length one
in each singleton tree, hence global length six.  For repeated cores
\(C_1,C_2\) and singletons \(Z_1,Z_2\), the doubled-cluster vanishing gives

\[
H^0(\mathcal J_{2D}(4))=0,
\qquad
L:=\ell_{C_1}+\ell_{C_2}+\lambda_{Z_1}+\lambda_{Z_2}\ge15.
\tag{1.6}
\]

All the unloadings in (1.2) take place within disjoint proper-origin trees,
so their colengths add exactly.  No independence of strict degree-ten jets
is asserted or used.

## 2. A length-five conic with contact at least eighteen

Define

\[
M(C_1,C_2)=
\max\{t_{C_1}+\rho_{C_2},\ t_{C_2}+\rho_{C_1}\}.
\tag{2.1}
\]

The small inequality behind the proof is

\[
M(C_1,C_2)\ge\ell_{C_1}+\ell_{C_2},
\tag{2.2}
\]

with equality only for \((C_1,C_2)=(A_{44},A_{44})\).  Indeed, put
\(\alpha_C=t_C-\ell_C\) and
\(\beta_C=\rho_C-\ell_C\).  The six rows give

\[
\begin{array}{c|rrrrrr}
C&A_{44}&A_{54}&A_{55}&F_P&F_N&S\\ \hline
\alpha_C&2&2&3&2&2&2\\
\beta_C&-2&-1&-1&-1&-1&0.
\end{array}
\tag{2.3}
\]

Now \(M-\ell_{C_1}-\ell_{C_2}\) is the maximum of
\(\alpha_{C_1}+\beta_{C_2}\) and
\(\alpha_{C_2}+\beta_{C_1}\).  It is nonnegative, and it can vanish only
when both cores are \(A_{44}\).  Otherwise it is at least one.

Choose the orientation attaining (2.1).  Mark the length-two tangent cluster
in that repeated tree, the proper origin of the other repeated tree, and the
two singleton origins.  This is a length-five quotient of the full simple
cluster.  Since

\[
H^0(\mathcal J_D(2))=0
\tag{2.4}
\]

and both sides of the full evaluation map have dimension six, there is a
unique projective conic \(Q\) through this length-five marked cluster.

If \(Q\) is smooth, its marked branch contact is at least

\[
c=M(C_1,C_2)+s_{Z_1}+s_{Z_2}.
\tag{2.5}
\]

If the core pair is not \((A_{44},A_{44})\), equations (1.5), (1.6), and
(2.2) give

\[
c\ge L+3\ge18.
\tag{2.6}
\]

For the exceptional pair, \(M=12\), while each singleton proper origin has
strict multiplicity at least three.  Hence again

\[
\boxed{c\ge18.}
\tag{2.7}
\]

Only the proper origin of the second repeated tree was marked.  Its omitted
tangent direction and all its later essential-span conditions remain actual
conditions on the determinant branch; forgetting them enlarges the marked
incidence.  The same applies to terminal or side \(t=1\) decorations.  Their
canonical positions are finite over a fixed branch and do not add parameters.
Thus this selection does not replace the actual branch by
\(H^0(\mathcal J_{4D}(10))\), and it does not discard \(D_1\): all omitted
strict and odd-exceptional conditions can only cut the locus estimated below.

## 3. Determinant restriction lemmas

For a smooth conic, the fixed-fiber and restriction-image bounds proved in
[`k1_singleton_root_exclusion.md`](k1_singleton_root_exclusion.md) are

\[
\begin{array}{c|c|c|c}
\text{rank/base position}&\text{binary degrees}&\text{image rank}&F\\ \hline
3&(10,10,10)&33&12\\
2,\ b\notin Q&(12,10,8)&33&13\\
2,\ b\in Q&(10,9,8)&30&11.
\end{array}
\tag{3.1}
\]

Here \(F\) bounds every fixed determinant fiber, including the zero fiber.
Scaling gives

\[
\dim\det^{-1}(U)\le F+\dim U
\tag{3.2}
\]

for every linear determinant target \(U\).

For a reduced two-line conic, write \(V_{654}\) and \(V_{444}\) for the
entry triples on an off-base line and on the strict transform of a line
through the rank-two base point.  UFD factorization of \(AC-B^2\), stratified
by the common symmetric-matrix value at the node, gives the bounds

\[
F(V_{654}\mathop{\times}_{\mathrm{node}}V_{654})\le13,
\qquad
F(V_{444}\mathop{\times}_{\mathrm{node}}V_{654})\le11.
\tag{3.3}
\]

The zero fiber in one \(V_{444}\) has dimension at most six.  These are the
nodal bounds proved, including diagonal and vanished-entry boundaries, in
Section 3 of
[`k1_two_essential_partition_exclusion.md`](k1_two_essential_partition_exclusion.md).
The restriction-image ranks are respectively

\[
33,\qquad30,\qquad29,
\tag{3.4}
\]

when no line, exactly one line, or both lines pass through the rank-two base
point.  In the last case the strict lines are disjoint on the blowup and the
rank-twenty-nine image is a subspace of
\(V_{444}\times V_{444}\).

## 4. The smooth-conic incidence

A smooth conic, its tangent-marked proper origin, and the other three proper
origins move in dimension

\[
5+1+3=9.
\tag{4.1}
\]

For rank three, a degree-twenty determinant with the contact (2.7) lies in a
target of dimension \(\max\{21-c,0\}\).  Hence

\[
33-\bigl(12+\max\{21-c,0\}\bigr)-9\ge9.
\tag{4.2}
\]

For rank two the exhaustive base-point positions give

\[
\begin{array}{c|c|c|c|c|c}
\text{position of }b&\text{image}&F&\dim U&\dim\text{ config}&
\text{codim}\\ \hline
b\notin Q&33&13&\max\{21-c,0\}&9&\ge8\\
b\in Q\text{ unmarked}&30&11&\max\{19-c,0\}&8&\ge10\\
b\text{ a marked origin}&30&11&\max\{21-c,0\}&7&\ge9.
\end{array}
\tag{4.3}
\]

In the middle row the unmarked base square leaves a degree-eighteen
determinant.  In the last row it consumes two units of the marked contact.
All four proper origins supporting essential trees are marked.  If \(b\) is
instead an additional proper \(t=1\) center, or any other proper point, it is
already included in the corresponding unmarked row.

## 5. Non-smooth conics

Over the ground field, a non-smooth conic is either a double line or a
reduced union of two lines.

### 5.1 The double-line case is impossible

If \(Q=2L\), then \(L\) contains all four distinct proper origins.  A double
line through the selected tangent vector need not follow that tangent
direction, so only the proper multiplicities may be counted on its support.
They are nevertheless all at least three.  Thus

\[
I(B,L)\ge3+3+3+3=12>10.
\tag{5.1}
\]

Bezout forces \(L\) to be a branch component, contrary to the retained
degree-one component exclusion.  Hence \(Q\) is not a double line.

### 5.2 Marked contacts on a reduced nodal conic

Write \(Q=L_1\cup L_2\), and let \(a_i\) be the branch contact on \(L_i\)
forced by the selected marks.  If the node is unmarked, every marked origin
is smooth on exactly one component; the component through the tangent-marked
origin follows its marked tangent.  Therefore
\(a_1+a_2\ge c\).

If the node is a marked origin other than the tangent-marked root, its proper
multiplicity contributes on both components, so the same inequality remains
true.  If the node is the tangent-marked root, the length-two tangent scheme
is contained for every tangent direction and no component need follow it.
In that case the two components contribute at least \(2\rho_C\), which is at
least \(t_C\) by (1.3).  Thus in every case

\[
a_1+a_2\ge c\ge18.
\tag{5.2}
\]

Neither line is a branch component, so \(a_i\le10\).  Consequently

\[
8\le a_i\le10.
\tag{5.3}
\]

A reduced two-line conic moves in dimension four.  If its node is unmarked,
the four marked origins each move in one dimension, for configuration
dimension at most eight.  If the node is marked, only three origins move,
for dimension at most seven.  When the tangent-marked root is the node, its
actual infinitely-near direction is forgotten: it is canonical and finite
over the branch, while retaining it would only add a condition.  It therefore
does not add a configuration parameter.

If the node is unmarked, the two degree-ten determinant targets have
dimensions \(11-a_1\) and \(11-a_2\), and equality of their values at the
node cuts one condition.  If the node is marked, both values are already
zero and there is no gluing condition.  Hence

\[
\dim U\le
\begin{cases}
21-(a_1+a_2)\le3,&\text{node unmarked},\\
22-(a_1+a_2)\le4,&\text{node marked}.
\end{cases}
\tag{5.4}
\]

Equations (3.3)--(3.4) now give the rank-three codimensions

\[
33-(13+3)-8=9,
\qquad
33-(13+4)-7=9.
\tag{5.5}
\]

They also give the same two values for rank two when \(b\notin Q\).

### 5.3 Rank two with the base point on one component

Suppose \(b\) is a non-node point on \(L_1\).  If it is unmarked, removal of
the base square leaves target dimensions at most

\[
\max\{9-a_1,0\}+(11-a_2)\le3.
\tag{5.6}
\]

The base-point condition lowers the configuration dimension to at most
seven.  If \(b\) is a marked origin, the square consumes two units of its
marked contact, so

\[
\dim U\le(11-a_1)+(11-a_2)\le4,
\tag{5.7}
\]

and the configuration dimension is at most six.  Any determinant gluing at
the node can only lower these target dimensions.  The mixed fixed-fiber
bound in (3.3) gives in both cases

\[
30-(11+3)-7=9,
\qquad
30-(11+4)-6=9.
\tag{5.8}
\]

These bounds also cover the subcases in which the node is separately marked.

### 5.4 Rank two with the base point equal to the node

If the node \(b\) is unmarked, factoring the base square on each strict line
leaves determinant-target dimensions

\[
\max\{9-a_1,0\}+\max\{9-a_2,0\}\le1.
\tag{5.9}
\]

The two \(V_{444}\) zero fibers have total dimension at most twelve, so the
bad restriction locus has dimension at most thirteen.  The two lines through
fixed \(b\) and the four marked origins move in dimension at most six.  Thus

\[
29-13-6=10.
\tag{5.10}
\]

If the node \(b\) is a marked origin, the base square on each component
consumes two units of the contact at that origin.  The two residual targets
therefore have total dimension

\[
(11-a_1)+(11-a_2)\le4.
\tag{5.11}
\]

Scaling the two \(V_{444}\) zero-fiber bounds gives a bad-locus dimension at
most \(12+4=16\).  The two lines through fixed \(b\) and the other three
origins move in dimension at most five.  This is the sharp rank-two row:

\[
29-16-5=8>7.
\tag{5.12}
\]

Sections 5.2--5.4 exhaust whether the node and the base point are marked,
unmarked, equal, or disjoint.

## 6. Conclusion and mechanical scope

The independent six-core classification, the doubled-cluster inequality,
the length-five conic, and the smooth, double-line, and reduced-nodal audits
exhaust the root partition \([2,2,1,1]\).  Pullback from each fixed-\(\sigma\)
restriction image to the sixty-dimensional coefficient space preserves the
displayed codimensions.  Adding the rank-three or rank-two matrix orbit still
leaves positive codimension.  Therefore the partition is absent for a
general bidegree \((2,4)\) equation.

The accompanying checker
[`k1_two_repeated_trees_checks.py`](k1_two_repeated_trees_checks.py)
replays the unloadings and core invariants, all parity-decorated core and
singleton pairs allowed by quartic colength, the contact inequality, the
smooth margins, the nodal fixed-fiber arithmetic, and every rank-two
base-point row.
