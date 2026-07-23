# Exclusion of the six-singleton root partition

## Statement

Work in the squarefree six-\(t=2\) row of
[`k1_double_decic_frontier.md`](k1_double_decic_frontier.md).  Suppose the six
essential centers lie in six distinct proper-origin trees, one essential
center in each tree.  Then this row does not occur for a general bidegree
\((2,4)\) equation \(A\), for either a rank-three or a rank-two bilinear
section \(\sigma\).

Thus every branch left in the class-\((1,1)\) frontier has at least two
essential centers in the same proper-origin tree.  This note does **not**
exclude those repeated-root partitions.  In particular, no total-transform
weight in a repeated tree is replaced here by an independent proper point.

The proof uses the line-component and all-proper exclusions in
[`k1_six_proper_centers_exclusion.md`](k1_six_proper_centers_exclusion.md).
All dimensions below are affine; the homogeneous-cone codimensions are
unchanged after projectivizing.

## 1. Exact local cluster lengths

Let \(n\) be the number of the six singleton trees whose essential center is
nonproper.  There are only two local types.

- Type \(P\): the essential center is its proper origin and the branch has
  multiplicity at least four there.
- Type \(N\): the essential center \(q\) is nonproper.  The
  minimal-essential lemma gives the exact first-near sequence

  \[
  (m_p,m_q)=(3,3),\qquad (r_p,r_q)=(3,4),
  \tag{1.1}
  \]

  where \(p\) is the proper origin and the marked tangent direction is
  denoted \(\tau\).

At a \(P\) root, a simple cluster weight pushes down to \(\mathfrak m_p\)
and its double to \(\mathfrak m_p^2\), of colengths one and three.  At an
\(N\) root, choose coordinates in which \(\tau=(y=0)\).  A simple weight at
the first-near point again pushes down to \(\mathfrak m_p\), while the doubled
weight pushes down to

\[
(x^2,y),
\tag{1.2}
\]

of colength two.  The six proper origins are distinct, so the global ideals
are intersections of these comaximal local ideals.  Consequently

\[
\operatorname {length}(O/\mathcal J_D)=6,
\qquad
\operatorname {length}(O/\mathcal J_{2D})=3(6-n)+2n=18-n.
\tag{1.3}
\]

The first cluster vanishing says that the six origins impose independent
conditions on conics.  The second gives an injection from the
fifteen-dimensional space of quartics into the second quotient in (1.3).
Therefore

\[
15\le18-n,\qquad\boxed{n\le3}.
\tag{1.4}
\]

This colength argument is specific to the singleton-root partition.  In a
repeated tree, unloading couples the total-transform weights and (1.3) is not
the applicable decomposition.

## 2. Restriction bounds used below

Write \(V_{a,b,c}\) for triples of binary forms of degrees \((a,b,c)\), with
determinant \(AC-B^2\).  UFD factorization of the zero fiber, together with
the scaling degeneration of a fixed nonzero fiber to the zero fiber, gives

\[
\begin{array}{c|ccccc}
V&V_{10,10,10}&V_{12,10,8}&V_{10,9,8}&V_{6,5,4}&V_{4,4,4}\\ \hline
\text{maximum fixed-fiber dimension}&12&13&11&7&6.
\end{array}
\tag{2.1}
\]

For completeness, the scaling argument is this.  If \(Z\) is a component of
a fiber over a fixed nonzero determinant \(f\), take the closure of
\((q,\lambda)\mapsto(\lambda q,\lambda^2)\) in the family
\(\det(q)=sf\).  The principal ideal theorem makes its fiber at \(s=0\)
have dimension \(\dim Z\), so \(\dim Z\) is at most the zero-fiber bound.
The fiber-dimension theorem then implies

\[
\dim\det^{-1}(U)\le F+\dim U
\tag{2.2}
\]

for a linear determinant target \(U\), where \(F\) is the corresponding
entry in (2.1).  These bounds include zero entries and every diagonal
boundary.

For rank three, restriction of the sixty-dimensional quadratic-form space
has ranks

\[
33,\quad54,\quad45
\tag{2.3}
\]

on a smooth conic, a reduced union of two conics, and a reduced union of
three lines, respectively.  They follow from the symmetric Euler resolution
and the vanishings of \(H^1(\mathcal Q(-2))\),
\(H^1(\mathcal Q(-4))\), and \(H^1(\mathcal Q(-3))\).

For rank two, let \(b\) be the base point.  A conic avoiding \(b\) has
pattern \(V_{12,10,8}\) and target dimension thirty-three; a conic through
\(b\) has pattern \(V_{10,9,8}\), target dimension thirty, and
\(B|_C=s^2\det(q|_C)\).  If a union of two conics has multiplicity
\(s=0,1,2\) at \(b\), its restriction-image ranks are

\[
54,\quad51,\quad50.
\tag{2.4}
\]

If a union of three distinct lines has \(s=0,1,2,3\) components through
\(b\), the ranks are

\[
45,\quad42,\quad41,\quad41.
\tag{2.5}
\]

For example, (2.4)--(2.5) follow by subtracting the strict divisor from the
three complete coefficient spaces

\[
H^0(O(6H-2E))\oplus H^0(O(5H-E))\oplus H^0(O(4H)).
\]

All arithmetic in this section is replayed by the checker accompanying this
note.

## 3. Zero or one nonproper singleton

The case \(n=0\) is the all-proper theorem already proved in
`k1_six_proper_centers_exclusion.md`.

Suppose \(n=1\).  Omit the \(N\) origin and take a conic through the five
\(P\) origins.  Independence of the six conic conditions makes it unique.
It is smooth: a reducible conic through five proper origins has a line through
at least three of them, and that line has branch contact at least
\(3\cdot4=12>10\), contrary to the line-component theorem.

The restriction has five order-four contacts, hence a one-dimensional
determinant target.  The conic and five ordered points move in dimension ten.
The fixed-\(\sigma\) codimensions are

\[
\begin{array}{c|c|c|c|c}
\text{rank/base position}&\text{image}&\text{bad}&\text{configuration}&
\text{codimension}\\ \hline
3&33&12+1&10&10\\
2,\ b\notin C&33&13+1&10&9\\
2,\ b\in C\text{ unmarked}&30&11&9&10\\
2,\ b=P_i&30&11+1&8&10.
\end{array}
\tag{3.1}
\]

In the unmarked row the degree-eighteen determinant cannot carry the twenty
marked zeros and is identically zero.  In the last row the forced square at
\(b\) removes two of the twenty contact units.  Every rank-three entry in
(3.1) is larger than eight and every rank-two entry is larger than seven.

## 4. Two nonproper singletons

Now let \(n=2\), with four proper origins \(P_1,\ldots,P_4\) and nonproper
origins \(N_1,N_2\).  Let \(C_i\) be a conic through all four \(P_j\) and
\(N_i\).  Each \(C_i\) is unique and smooth.  Indeed, any reducible member
has a line through at least three of these five origins; the least possible
contact is \(4+4+3=11>10\).  A positive-dimensional pencil would contain a
reducible member and is therefore impossible.  The two conics are distinct,
because a common conic would contain all six origins.  Their four proper
origins exhaust \(C_1\cdot C_2=4\), so they meet transversely exactly there.

Each conic has branch contact at least

\[
4\cdot4+3=19,
\tag{4.1}
\]

so its determinant target has dimension two.  The pair of conics, their two
extra origins, and the two marked tangent directions move in dimension

\[
10+2+2=14.
\tag{4.2}
\]

Restriction to \(C_1\cup C_2\) now gives

\[
\begin{array}{c|c|c|c|c}
\text{rank/base position}&\text{image}&\text{bad}&\text{configuration}&
\text{codimension}\\ \hline
3&54&2(12+2)&14&12\\
2,\ b\notin C_1\cup C_2&54&2(13+2)&14&10\\
2,\ b\text{ unmarked on one }C_i&51&11+(13+2)&13&12\\
2,\ b=N_i&51&(11+2)+(13+2)&12&11\\
2,\ b=P_j&50&2(11+2)&12&12.
\end{array}
\tag{4.3}
\]

For an unmarked base point on one conic, its degree-eighteen determinant is
forced to zero by the nineteen contacts.  At a marked \(N_i\), or at a
common proper origin, removal of the forced square leaves seventeen contact
units and hence a two-dimensional determinant target.  The rows in (4.3)
exhaust all base-point positions and have strict orbit margins.

## 5. Three nonproper singletons

There are now three proper origins \(P_1,P_2,P_3\) and three type-\(N\)
origins \((N_i,\tau_i)\).

### 5.1 A tangent line avoiding the proper origins

Suppose some \(\tau_i\) contains none of the \(P_j\).  Choose a conic \(C\)
through the three \(P_j\), through \(N_i\), and tangent to \(\tau_i\) there.
These are five linear conditions on conics, so such a conic exists.  Every
member is smooth.  If a reducible member is smooth at \(N_i\), its tangent
component is \(\tau_i\) and its other line contains all three \(P_j\).  If it
is singular at \(N_i\), one component contains \(N_i\) and at least two
\(P_j\), with branch contact at least \(3+4+4=11\).  A doubled-line member is
even easier.  Every alternative contradicts the line-component theorem.

By (1.1), the tangent conic has contact at least six at \(N_i\), and the three
proper origins contribute twelve more.  Thus its determinant target has
dimension three.  The conic, the three proper points, and \(N_i\) move in
dimension

\[
5+3+1=9;
\]

the marked tangent is the tangent of the conic and adds no parameter.  The
codimensions are

\[
\begin{array}{c|c|c|c|c}
\text{rank/base position}&\text{image}&\text{bad}&\text{configuration}&
\text{codimension}\\ \hline
3&33&12+3&9&9\\
2,\ b\notin C&33&13+3&9&8\\
2,\ b\in C\text{ unmarked}&30&11+1&8&10\\
2,\ b=P_j\text{ or }N_i&30&11+3&7&9.
\end{array}
\tag{5.1}
\]

In the unmarked row the eighteen selected contacts exactly fill the
degree-eighteen determinant after removing the base square.  In the marked
row the square removes two contact units, leaving a degree-sixteen fixed
factor and a three-dimensional target.

### 5.2 Every tangent line contains a proper origin

It remains to suppose that every \(\tau_i\) contains some \(P_j\).  A tangent
line cannot contain two proper origins, because its contact would be at least
\(6+4+4=14>10\).  Nor can two of the \(\tau_i\) coincide: the common line
would already have contact at least \(6+6+4>10\).  Thus the three tangent
lines are distinct, and each carries exactly one of the proper marked
origins relevant to this count.

On each line the degree-ten branch has contact at least \(6+4=10\).  The
inverse image of this one-dimensional determinant target has dimension at
most eight in \(V_{6,5,4}\).  The reduced cubic union has rank-three
restriction dimension forty-five.  The three lines, their three \(N\)
origins, and the proper points on them move in dimension at most twelve.
Hence

\[
45-3\cdot8-12=9>8.
\tag{5.2}
\]

For rank two, let \(s\) of the three lines pass through the base point.  An
off-base line has bad dimension at most eight.  A through-base line has
pattern \(V_{4,4,4}\), and after the forced square is removed its bad
dimension is at most seven (and at most six when the base point is
unmarked).  The configuration bounds for \(s=0,1,2,3\) are
\(12,11,10,10\).  The last value, rather than nine, is needed when all three
tangents pass through the same proper origin \(P=b\).  Using (2.5), the four
codimensions are

\[
\begin{array}{c|cccc}
s&0&1&2&3\\ \hline
\text{codimension}&
45-24-12&42-23-11&41-22-10&41-21-10\\
&9&8&9&10.
\end{array}
\tag{5.3}
\]

All are larger than the rank-two orbit dimension seven.

## 6. Conclusion

Equations (1.4), (3.1), (4.3), and (5.1)--(5.3) exhaust the singleton-root
partition.  After adding the projective rank-three or rank-two matrix orbit,
every incidence still has positive codimension in the space of quartic
equations.  Therefore the root partition \([1,1,1,1,1,1]\) is absent for a
general \(A\).

The cluster lengths, restriction ranks, and every displayed margin are
replayed by
[`k1_singleton_root_checks.py`](k1_singleton_root_checks.py).
