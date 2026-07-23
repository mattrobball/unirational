# Uniform conic exclusion of the remaining six-center partitions

## Statement

Work over an algebraically closed field of characteristic zero in the
squarefree six-\(t=2\) row of
[`k1_double_decic_frontier.md`](k1_double_decic_frontier.md).  Suppose the
essential root partition has at most four proper-origin trees.  Then this
incidence does not occur for a general bidegree \((2,4)\) equation, for
either a rank-three or a rank-two bilinear section \(\sigma\).

Equivalently, this note excludes all nine partitions left after the already
excluded rows \([1,1,1,1,1,1]\) and \([2,1,1,1,1]\):

\[
\boxed{
[2,2,1,1],\ [3,1,1,1],\ [2,2,2],\ [4,1,1],\ [3,2,1],
\ [3,3],\ [5,1],\ [4,2],\ [6].}
\tag{0.1}
\]

For fixed canonical \(\sigma\), every rank-three incidence below has affine
codimension at least nine in the sixty-dimensional restricted coefficient
space, and every rank-two incidence has codimension at least eight.  These
bounds are strictly larger than the projective matrix-orbit dimensions eight
and seven.

The proof uses only the two complete-cluster vanishings

\[
H^0(\mathcal J_D(2))=0,
\qquad
H^0(\mathcal J_{2D}(4))=0,
\tag{0.2}
\]

the absence of branch components of degree at most five, and the fixed-conic
determinant bounds already proved in the earlier \(k=1\) certificates.  It
does not assert degree-ten jet independence and does not replace the branch
by the enlarged system \(H^0(\mathcal J_{4D}(10))\).

Together with
[`k1_singleton_root_exclusion.md`](k1_singleton_root_exclusion.md) and
[`k1_two_essential_partition_exclusion.md`](k1_two_essential_partition_exclusion.md),
this closes the squarefree six-\(t=2\) row.

## 1. Local conventions and the essential-chain lemma

At a canonical center \(v\), write

\[
m_v=\operatorname {mult}_v(B_v^{\mathrm {strict}}),\qquad
e_v=\#\{\text{exceptional branch curves through }v\},\qquad
r_v=m_v+e_v.
\tag{1.1}
\]

Every essential center has \(r_v=4\) or \(5\), and every negligible center
on an essential path has \(r_v=2\) or \(3\).  The exceptional curve created
at \(v\) is a branch component exactly when \(r_v\) is odd.  Strict
multiplicities satisfy the proximity inequalities

\[
m_u\geq\sum_{v\succ u}m_v.
\tag{1.2}
\]

In particular, every strict multiplicity in the present row is at most five.

### 1.1 Satellite starts and forks

There are two points which must be checked before reusing the two-essential
classification locally.

First, an essential center cannot have an immediately satellite essential
successor.  Let \(v\) be such a successor of \(u\), also proximate to the
older center \(w\).  Thus both \(u\) and \(v\) are proximate to \(w\).  A
direct enumeration of

\[
r_u,r_v\in\{4,5\},\qquad e_u,e_v\le2,
\qquad m_w\ge m_u+m_v,
\tag{1.3}
\]

leaves only \((r_w,e_w,m_w)=(5,0,5)\), with

\[
(r_u,e_u,m_u;r_v,e_v,m_v)
=(4,2,2;4,1,3)
\quad\text{or}\quad
(5,2,3;4,2,2).
\tag{1.4}
\]

Both rows are geometrically impossible.  The equality \(e_u=2\) says that
the older branch exceptional meeting \(E_w\) at \(u\) is already a branch
component through \(w\).  Hence \(e_w\ge1\), contradicting \(e_w=0\).

Nor can a satellite negligible center start the path from one essential
center to the next.  Write \(s\succ u,w\), where \(u\) is its immediate
predecessor and \(w\) is the older parent.  To carry an essential descendant,
\(s\) must have \(m_s\ge2\); the \(r_s=2,3\) cases leave only \(m_s=2\).
A free successor or a satellite successor on the \(E_u\)-side would need
strict multiplicity at least three, contrary to nonincrease.  The sole
strict-double essential continuation allowed by the parity equations is a
satellite \(v\succ s,w\) on the other side.  But \(u,s,v\) are then all
proximate to \(w\), so

\[
m_w\ge m_u+m_s+m_v\ge2+2+2=6,
\]

again impossible.  Additional negligible centers only add nonnegative
proximate load.  Thus an essential-to-essential path starts free; its sole
satellite possibility is the terminal center in the \(S\)-pattern below.

Now suppose two essential-bearing paths fork after a center \(a\), and let
\(x,y\) be their first centers.  An essential center has strict multiplicity
at least two, and strict multiplicity cannot increase along an immediate
successor chain.  Hence

\[
m_x,m_y\ge2,
\qquad
m_a\ge m_x+m_y\ge4.
\tag{1.5}
\]

Thus \(a\) is itself essential.  If, say, \(x\) were satellite and also
proximate to an older center \(w\), then both \(a\) and \(x\) would be
proximate to \(w\).  Proximity at \(w\) would give

\[
m_w\ge m_a+m_x\ge6,
\]

contrary to the standing bound \(m_w\le r_w\le5\).  Therefore both first
centers are free over \(a\).  Apply the exact free-path \(A/F/S\) separator
audit recalled in the next subsection to the first essential center on each
branch.  An \(A\)- or \(F\)-branch contributes at least three to the
proximity sum at \(a\).  An \(S\)-branch contributes its strict-double free
separator and strict-double satellite, both proximate to \(a\), and hence
contributes four.  Two branches therefore contribute at least six,
contradicting \(m_a\le5\).

We have proved the uniform statement

\[
\boxed{\text{all essential centers in one proper-origin tree are linearly
ordered.}}
\tag{1.6}
\]

This is the extra point not supplied merely by the classification of a tree
containing exactly two or three essentials.

### 1.2 The three edge types and their words

For two consecutive essential centers on this chain, the local
\(e=0,1,2\) analysis is now exactly the one in
[`k1_two_essential_tree_classification.md`](k1_two_essential_tree_classification.md).
There are only three edge types.

* \(A\): the later essential center is the free immediate successor.
* \(F\): one free corrected-triple center separates the essentials.
* \(S\): a free strict-double corrected-triple center is followed by the
  satellite essential at the two branch exceptionals.

There cannot be two negligible separators.  An \(F\)-edge ends at a
corrected quadruple of strict multiplicity three, so only another \(F\)-edge
can follow.  An \(S\)-edge ends at strict multiplicity two and is terminal.
If the first essential center is nonproper, the minimal-essential lemma gives
the exact initial pair

\[
(r;m)=(3,4;3,3),
\tag{1.7}
\]

and again only \(F\)-edges can follow.

Consequently a tree with \(k\) essential centers has exactly one of the
following skeletons:

\[
\boxed{
P:A^aF^b\ (a+b=k-1),\qquad
P:A^{k-2}S\ (k\ge2),\qquad
N:F^{k-1}.}
\tag{1.8}
\]

For \(k\ge2\), the exact corrected-parity families and their strict vectors
on the positive simple support are

\[
\begin{array}{c|c|c}
\text{family}&\text{number}&(m_i)_{i<k}\\ \hline
P_4:A_4^aF^b,\ a+b=k-1&k&(4^{a+1},3^b)\\
P_5:A_5^aA_4F^b,\ a+b=k-2&k-1&(5,4^a,3^{b+1})\\
P_5:A_5^{k-1}&1&(5,4^{k-1})\\
P_5:A_5^{k-2}S&1&(5,4^{k-2},2)\\
N:F^{k-1}&1&(3^k).
\end{array}
\tag{1.9}
\]

Thus there are \(2k+2\) parity-decorated cores for \(k\ge2\).  For \(k=1\)
the three cores are \(P_4,P_5,N\).

Here \(P\) means that the first essential is proper, while \(N\) includes
the proper corrected-triple predecessor in (1.7).  Terminal or side
\(t=1\) decorations containing no essential center are not part of the
essential span.  They have coefficient zero in \(D\) and \(2D\), are finite
over a fixed branch, and may safely be forgotten in a negative incidence
argument.

## 2. Uniform unloading and contact

Write

\[
D=\sum_{v\text{ essential}}E_v^*
\tag{2.1}
\]

in the total-transform basis.  The positive part of the unloaded simple
point basis is curvilinear in every row of (1.8).

### 2.1 The \(P:A^aF^b\) core

The essential-span center sequence is a free chain of length \(k+b\): its
first \(a+1\) centers are essential, and the remaining essentials alternate
with their \(F\)-separators.  Direct unloading gives

\[
\begin{aligned}
\mathcal J_D &: (1^k,0^b),\\
\mathcal J_{2D} &: (2^{a+1},1^{2b}),\\
\ell_D&=k,\qquad \ell_{2D}=3k-b.
\end{aligned}
\tag{2.2}
\]

For the first \(j\le k\) centers in the simple support, parity and
nonincrease give

\[
\sum_{i=0}^{j-1}m_i\ge
4\min\{j,a+1\}+3\max\{j-a-1,0\}.
\tag{2.3}
\]

Indeed, an adjacent essential run is either all corrected quadruples, all
corrected quintuples, or a string of corrected quintuples ending in a
quadruple.  Its strict-prefix sums are at least four per center.  After the
first \(F\)-edge, every center relevant to (2.3) has strict multiplicity
three.

### 2.2 The terminal \(S\) core

For \(P:A^{k-2}S\), the last essential center is satellite and lies just
outside the positive simple support.  The unloadings and strict lower vector
on that support are

\[
\begin{aligned}
\mathcal J_D &: (1^k,0),\\
\mathcal J_{2D} &: (2^{k-1},1,1),\\
\ell_D&=k,\qquad \ell_{2D}=3k-1,\\
(m_i)_{i<k}&=(5,4^{k-2},2).
\end{aligned}
\tag{2.4}
\]

The adjacent run must consist of corrected quintuples because an \(S\)-edge
starts at a corrected quintuple.

### 2.3 The nonproper initial core

For \(N:F^{k-1}\), the essential span is a free chain of length \(2k\),
beginning with the predecessor in (1.7).  One has

\[
\begin{aligned}
\mathcal J_D &: (1^k,0^k),\\
\mathcal J_{2D} &: (1^{2k}),\\
\ell_D&=k,\qquad \ell_{2D}=2k,\\
(m_i)_{i<k}&=(3^k).
\end{aligned}
\tag{2.5}
\]

All three unloading formulas follow inductively from the two elementary
moves \((0,1)\rightsquigarrow(1,0)\) and
\((0,2)\rightsquigarrow(1,1)\), with the satellite proximity included in
the \(S\)-row.  The accompanying checker also performs the standard antinef
unloading directly on every core of size at most six.

Define the defect

\[
\delta_T=
\begin{cases}
b,&P:A^aF^b,\\
1,&P:A^{k-2}S,\\
k,&N:F^{k-1}.
\end{cases}
\tag{2.6}
\]

Equations (2.2)--(2.5) give, for every local tree,

\[
\boxed{
\ell(\mathcal O/\mathcal J_D)=k,\qquad
\ell(\mathcal O/\mathcal J_{2D})=3k-\delta_T,\qquad
\sum_{v\in\operatorname {supp}\mathcal J_D}m_v
\ge4k-\delta_T.}
\tag{2.7}
\]

In particular, the last term is at least
\(\ell(\mathcal O/\mathcal J_{2D})+k\).

## 3. Selecting the length-five conic

Let the essential root partition be \((k_1,\ldots,k_r)\), and put

\[
\Delta=\sum_T\delta_T.
\tag{3.1}
\]

Since \(\sum k_i=6\), (2.7) gives

\[
\ell(\mathcal O/\mathcal J_D)=6,
\qquad
\ell(\mathcal O/\mathcal J_{2D})=18-\Delta.
\tag{3.2}
\]

The second vanishing in (0.2) injects the fifteen-dimensional quartic space
into the doubled-cluster quotient.  Hence

\[
18-\Delta\ge15,
\qquad
\boxed{\Delta\le3.}
\tag{3.3}
\]

The total branch contact against the full simple support is at least

\[
24-\Delta\ge21.
\tag{3.4}
\]

Delete the terminal point of one local curvilinear point basis.  This gives
a complete length-five subcluster \(K\subset D\).  If some terminal strict
multiplicity is at most three, delete one with minimal value; (3.4) gives
marked contact at least eighteen.  Otherwise every terminal multiplicity is
at least four, and the exact vectors in (1.9) show that every preceding
positive-support multiplicity is also at least four.  Any five retained
points then give contact at least twenty.  Thus
there is always a terminal deletion with

\[
c(K):=\sum_vm_v\mu_v\ge18,
\tag{3.5}
\]

where \(\mu\) is the point basis of \(K\).

Because the conic evaluation map on the full length-six cluster is an
isomorphism by the first vanishing in (0.2), its projection to any
length-five quotient is surjective with one-dimensional kernel.  Therefore
there is a unique projective conic

\[
Q_K\in\mathbf P H^0(\mathcal I_K(2)).
\tag{3.6}
\]

The narrower rule “take a full local length-three cluster and two origins”
has one first counterexample among the classified three-essential rows:

\[
FF_N+P_4^3.
\tag{3.7}
\]

Its proposed contact is \(9+4+4=17\).  It is repaired by retaining only the
length-two prefix of \(FF_N\) and all three proper origins, giving

\[
6+4+4+4=18.
\tag{3.8}
\]

Thus (3.7) is a counterexample to that special marking recipe, not to the
terminal-deletion theorem.

### 3.1 The finite double-line selection

One further choice among the admissible terminal deletions removes every
double-line degeneration.  If a local selected prefix has length \(h\), its
curvilinear algebra is \(k[t]/(t^h)\).  If \(Q_K=L^2\), then

\[
L(t)^2=0\pmod {t^h},
\qquad
\operatorname {ord}_tL(t)\ge\left\lceil\frac h2\right\rceil.
\tag{3.9}
\]

Hence \(L\) follows the first \(\lceil h/2\rceil\) centers of that local
simple support.  Noether's intersection formula gives the corresponding
strict-prefix branch contact on \(L\).

For every tuple of local core types with \(\Delta\le3\), choose among the
terminal deletions satisfying (3.5) one which maximizes this support-line
contact.  Equations (2.3)--(2.5) give the exhaustive minima below.  The
columns are indexed by \(\Delta=3,2,1,0\).

\[
\begin{array}{c|rrrr}
\text{partition}&3&2&1&0\\ \hline
[3,1,1,1]&14&15&16&16\\
[2,2,1,1]&14&14&15&16\\
[4,1,1]&14&14&15&16\\
[3,2,1]&11&15&15&16\\
[2,2,2]&11&11&12&12\\
[5,1]&12&12&12&12\\
[4,2]&11&11&12&12\\
[3,3]&11&12&12&12\\
[6]&12&12&12&12
\end{array}
\tag{3.10}
\]

Every entry is greater than ten.  Thus \(Q_K=L^2\) would force \(L\) to be
a component of the degree-ten branch.  This is impossible by the line-factor
theorem.  Consequently the selected conic is either smooth or a reduced
union of two distinct lines.

The checker enumerates every corrected-multiplicity parity assignment in
(1.8)--(1.9), not only the lower vectors in (2.3)--(2.5).  For the nine partitions
in (0.1), the numbers of ordered parity-decorated rows with \(\Delta\le3\)
are respectively

\[
285,187,188,74,124,54,28,49,10
\tag{3.11}
\]

in the order used there.  It checks every terminal deletion in every row and
reproduces (3.10).

## 4. Smooth-conic incidence

The selected length-five cluster has curvilinear local pieces supported at
at most four proper roots.  A local length-\(h\) curvilinear cluster moves in
dimension at most \(h+1\): two for its proper root and one for each later
free center.  Hence the whole selected configuration moves in dimension at
most

\[
5+r\le9.
\tag{4.1}
\]

Equivalently, on a smooth conic the conic moves in dimension five and each
proper support point in dimension one; its later curvilinear points are then
fixed by the conic.

The fixed-fiber and restriction-image bounds from the earlier certificates
are

\[
\begin{array}{c|c|c|c}
\text{rank/base position}&\text{binary degrees}&\text{image}&F\\ \hline
3&(10,10,10)&33&12\\
2,\ b\notin Q&(12,10,8)&33&13\\
2,\ b\in Q&(10,9,8)&30&11.
\end{array}
\tag{4.2}
\]

Here \(F\) bounds every fixed determinant fiber, including zero, and scaling
gives \(\dim\det^{-1}(U)\le F+\dim U\) for a linear target \(U\).

For \(c\ge18\), the exhaustive smooth-conic margins are

\[
\begin{array}{c|c|c|c|c|c}
\text{position of }b&\text{image}&F&\dim U&\dim\text{ config}&
\text{codim}\\ \hline
\text{rank }3&33&12&\le3&\le9&\ge9\\
\text{rank }2,\ b\notin Q&33&13&\le3&\le9&\ge8\\
b\in Q\text{ unmarked}&30&11&\le1&\le8&\ge10\\
b\text{ a marked root}&30&11&\le3&\le7&\ge9.
\end{array}
\tag{4.3}
\]

In the unmarked row the rank-two base square leaves a degree-eighteen
determinant with all eighteen marked zeros.  In the marked row it consumes
two units of marked contact, leaving at least sixteen forced zeros.  The
omitted sixth cluster point, all later essential-span conditions, and every
terminal \(t=1\) decoration remain conditions on the actual branch; forgetting
them only enlarges the incidence.

## 5. Reduced nodal conics

Suppose

\[
Q_K=L_1\cup L_2
\tag{5.1}
\]

is reduced.  The degree-one-through-five component exclusions, including
[`k1_quintic_factor_exclusion.md`](k1_quintic_factor_exclusion.md), imply
that the retained reduced decic is integral.  In particular neither line is
a branch component.  Let \(c_i\) be the branch contact on \(L_i\) forced by
the selected local clusters.

Noether's formula for the complete selected cluster gives

\[
c_1+c_2\ge c(K)\ge18.
\tag{5.2}
\]

Since \(B\cdot L_i=10\) and \(L_i\) is not a component,

\[
8\le c_i\le10.
\tag{5.3}
\]

There is one configuration subtlety when the node is a selected proper root.
For a local curvilinear prefix of length \(h\ge2\), the equation
\(L_1L_2=0\) modulo \(t^h\) makes one component follow the first \(h-1\)
centers; only the last infinitely-near direction can remain free.  Forget
that last direction.  The two components then contribute at least

\[
m_0+\sum_{j=0}^{h-2}m_j
\ge\sum_{j=0}^{h-1}m_j,
\tag{5.4}
\]

because strict multiplicity is nonincreasing.  Thus the same contact lower
bound survives while the forgotten direction adds no configuration
parameter.  This includes \(h=2\), where (5.4) is
\(2m_0\ge m_0+m_1\).  For \(h=1\), both components pass through the
selected proper root, so their total contact is \(2m_0\ge m_0\), and there
is no infinitely-near direction to count.

A reduced nodal conic moves in dimension four.  If its node is unmarked, the
selected proper roots give configuration dimension at most eight.  If its
node is marked, (5.4) gives dimension at most seven.

### 5.1 Rank three and a rank-two base point off the conic

The nodal fixed-fiber bound is

\[
F(V_{654}\mathop{\times}_{\rm node}V_{654})\le13.
\tag{5.5}
\]

If the node is unmarked, the two degree-ten determinant targets have total
dimension

\[
(11-c_1)+(11-c_2)-1\le3,
\tag{5.6}
\]

where the last minus one glues their values at the node.  If the node is
marked, both values already vanish, so the target dimension is at most

\[
(11-c_1)+(11-c_2)\le4.
\tag{5.7}
\]

Both rank three and rank two with \(b\notin Q\) therefore have codimensions

\[
33-(13+3)-8=9,
\qquad
33-(13+4)-7=9.
\tag{5.8}
\]

### 5.2 A rank-two base point on exactly one component

The mixed fixed-fiber bound is

\[
F(V_{444}\mathop{\times}_{\rm node}V_{654})\le11,
\tag{5.9}
\]

and the restriction image has dimension thirty.  If \(b\) is unmarked, the
base square is separate from the selected contacts, the determinant target
has dimension at most three, and the configuration has dimension at most
seven.  If \(b\) is a marked non-node root, the square consumes two units of
its contact; the corresponding bounds are four and six.  Thus

\[
30-(11+3)-7=9,
\qquad
30-(11+4)-6=9.
\tag{5.10}
\]

These estimates include the subcases in which the node is separately marked.

### 5.3 The rank-two base point is the node

Both strict lines now have pattern \(V_{444}\), and the restriction image
has dimension twenty-nine.  If the node is unmarked, removing the base
square on each component leaves total target dimension at most one.  The two
zero fibers have dimension at most \(6+6=12\), and the configuration has
dimension at most six.  Hence

\[
29-(12+1)-6=10.
\tag{5.11}
\]

If the node is marked, the base square on each line consumes two units of
the contact at that root.  The residual targets have total dimension at most

\[
(11-c_1)+(11-c_2)\le4.
\tag{5.12}
\]

The two lines through the fixed point and the other selected roots move in
dimension at most five.  This gives the sharp rank-two row

\[
29-(12+4)-5=8>7.
\tag{5.13}
\]

Equations (5.8), (5.10), and (5.11)--(5.13) exhaust whether the node and the
rank-two base point are marked, unmarked, equal, or disjoint.

## 6. Conclusion and mechanical scope

The essential-chain theorem, the three core words, the exact unloadings, and
the defect bound \(\Delta\le3\) produce a length-five complete cluster with
branch contact at least eighteen in every partition (0.1).  The finite
support-line table excludes a doubled conic.  Sections 4--5 give strict
rank-orbit margins for every smooth or reduced nodal conic and every
rank-two base-point position.  Pullback from the fixed-\(\sigma\) restriction
image to the sixty-dimensional coefficient space preserves these
codimensions.

Therefore every partition in (0.1) is absent for a general equation.  With
the two earlier partition theorems, no squarefree six-\(t=2\) branch remains
in the class-\((1,1)\) frontier.

The accompanying checker
[`k1_uniform_six_center_conic_checks.py`](k1_uniform_six_center_conic_checks.py)
replays:

* all core words for \(1\le k\le6\), every corrected-parity assignment, and
  every antinef unloading;
* the local colength and strict-prefix inequalities;
* all nine integer partitions, all ordered tuples with \(\Delta\le3\), and
  every possible terminal deletion;
* the contact-eighteen and support-line minima, including the first failure
  (3.7) of the narrower marking recipe; and
* every smooth, nodal, rank-two base-point, and marked-node arithmetic
  margin.
