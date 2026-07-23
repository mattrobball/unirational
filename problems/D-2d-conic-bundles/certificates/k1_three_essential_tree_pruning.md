# Three-essential tree classification and the sharp adjacent exclusion

## Statement

Work in the squarefree six-\(t=2\) row of
[`k1_double_decic_frontier.md`](k1_double_decic_frontier.md), with essential
root partition

\[
[3,1,1,1].
\]

This note proves three results.

1. The proper-origin tree containing three essential centers has exactly
   eight parity-decorated essential-span cores.  This classification includes
   every predecessor and every intervening \(t=1\) center, and every free or
   satellite proximity.
2. Exact unloading, the quartic cluster vanishing, and universal
   degree-at-most-five Bezout tests reduce the sixty-eight initial
   core/singleton rows to fourteen.  Every retained proper singleton has
   corrected multiplicity four.
3. The sharp all-adjacent row

   \[
   A_{444}+N^3
   \]

   is absent for a general bidegree \((2,4)\) equation, in both rank orbits.
   The apparent contact-seventeen conic is not the optimal marking: retaining
   the full length-three repeated cluster and two of the three \(N\) origins
   gives a smooth marked conic with contact at least eighteen and strict
   orbit margins.

Thus thirteen structural rows remain at this intermediate stage.  They are
all excluded by the later uniform incidence theorem
[`k1_uniform_six_center_conic_exclusion.md`](k1_uniform_six_center_conic_exclusion.md).
No row is asserted to occur.  Terminal \(t=1\) decorations contain
no essential center, have coefficient zero in \(D\) and \(2D\), and may be
forgotten in a negative incidence proof exactly as in
[`k1_two_essential_tree_classification.md`](k1_two_essential_tree_classification.md).

## 1. Local conventions and edge types

At a canonical center \(v\), put

\[
m_v=\operatorname {mult}_v(B_v^{\mathrm {strict}}),\qquad
e_v=\#\{\text{exceptional branch curves through }v\},\qquad
r_v=m_v+e_v.
\tag{1.1}
\]

Essential centers have \(r=4\) or \(5\); negligible centers have \(r=2\)
or \(3\).  The exceptional created at \(v\) belongs to the corrected branch
exactly when \(r_v\) is odd.  Strict multiplicities satisfy

\[
m_u\ge\sum_{v\succ u}m_v.
\tag{1.2}
\]

The three essential centers are linearly ordered.  Indeed, if two essential
descendants fork after a center \(a\), the first centers on the two branches
have strict multiplicity at least two.  Proximity makes \(m_a\ge4\), hence
\(a\) is a third essential center in addition to the two descendants.  This
already accounts for all three essentials.  The minimal-essential lemma then
makes \(a\) proper, and the first centers on the two branches are distinct
free points over \(a\).  On either branch, an adjacent essential child or an
\(F\)-separator has strict multiplicity at least three.  An \(S\)-branch has
a strict-double separator and a strict-double satellite, both proximate to
\(a\), and therefore consumes four units there.  Two branches consequently
require at least six units, contradicting \(m_a\le5\).  Thus no essential
fork exists.

For consecutive comparable essential centers there are exactly three edge
types.  The proof is the same local \(e=0,1,2\) analysis as for the
two-essential classification.

* \(A\): the centers are adjacent.
* \(F\): one free corrected-triple center separates them, with corrected
  sequence \((4,3,4)\); all three centers are free along the path.
* \(S\): one free corrected-triple center is followed by a satellite
  essential center, with corrected sequence \((5,3,4)\).

There cannot be two negligible separators.  In the \(e=1\) case the
separator and later essential have strict multiplicity three, and an extra
predecessor would have corrected multiplicity two.  In the \(e=2\) case the
separator and satellite have strict multiplicity two, are both proximate to
the earlier essential, and already saturate the allowed proximity budget.

The possible two-edge skeletons are

\[
A\!-\!A,\qquad A\!-\!F,\qquad A\!-\!S,\qquad F\!-\!F.
\tag{1.3}
\]

After an \(F\) edge the target has corrected multiplicity four and strict
multiplicity three, so an adjacent successor is impossible and an \(S\) edge
cannot start.  After an \(S\) edge the target has strict multiplicity two,
so no further essential edge can start.  These observations exclude
\(F\!-\!A,S\!-\!A,F\!-\!S,S\!-\!F,S\!-\!S\).

In the remaining \(A\!-\!A\) skeleton the first essential is proper and the
second is free.  The third is free as well.  If it were the satellite at the
intersection of the exceptionals created by the first two centers, write
\(r_i=4+\epsilon_i\).  The last two strict multiplicities would be

\[
m_1=4+\epsilon_1-\epsilon_0,
\qquad
m_2=4+\epsilon_2-\epsilon_0-\epsilon_1.
\]

Both are proximate to the first center, but

\[
m_1+m_2=8+\epsilon_2-2\epsilon_0
   >4+\epsilon_0=m_0,
\]

for \(\epsilon_0=0,1\), contradicting proximity.  Thus the displayed
successive-free chain is exhaustive.

## 2. The eight exact cores

Enumerating parity in the four skeletons of (1.3) gives the following table.
A star marks an essential center; `B` means that the exceptional created at
that center is a branch component.

| core | centers and proximities | corrected \(r\) | exceptional count \(e\) | strict \(m\) | new exceptional |
|---|---|---|---|---|---|
| \(AA_{444}\) | \(p^*<q^*<s^*\), free chain | \((4,4,4)\) | \((0,0,0)\) | \((4,4,4)\) | \((-,-,-)\) |
| \(AA_{554}\) | same | \((5,5,4)\) | \((0,1,1)\) | \((5,4,3)\) | \((B,B,-)\) |
| \(AA_{555}\) | same | \((5,5,5)\) | \((0,1,1)\) | \((5,4,4)\) | \((B,B,B)\) |
| \(AF_4\) | \(p^*<q^*<w<s^*\), free chain | \((4,4,3,4)\) | \((0,0,0,1)\) | \((4,4,3,3)\) | \((-,-,B,-)\) |
| \(AF_5\) | same | \((5,4,3,4)\) | \((0,1,0,1)\) | \((5,3,3,3)\) | \((B,-,B,-)\) |
| \(AS\) | \(p^*<q^*<w\) free; \(s^*\succ q,w\) | \((5,5,3,4)\) | \((0,1,1,2)\) | \((5,4,2,2)\) | \((B,B,B,-)\) |
| \(FF_P\) | \(p^*<w<q^*<z<s^*\), free chain | \((4,3,4,3,4)\) | \((0,0,1,0,1)\) | \((4,3,3,3,3)\) | \((-,B,-,B,-)\) |
| \(FF_N\) | \(a<p^*<w<q^*<z<s^*\), free chain | \((3,4,3,4,3,4)\) | \((0,1,0,1,0,1)\) | \((3,3,3,3,3,3)\) | \((B,-,B,-,B,-)\) |

For \(A\!-\!A\), direct nonincrease leaves only \((4,4,4)\),
\((5,5,4)\), and \((5,5,5)\).  For \(A\!-\!F\), the middle essential
must have corrected multiplicity four, while the proper root may have four
or five.  An \(S\) edge starts at a corrected quintuple center, and its
adjacent proper predecessor must also be quintuple; this gives the unique
\(AS\) row.  Finally, the first \(F\) edge is either proper-minimal or begins
with the forced \((3,4;3,3)\) minimal nonproper cluster, giving \(FF_P\) and
\(FF_N\).

## 3. Exact unloading and the quartic bound

Let

\[
D=\sum_{v\text{ essential}}E_v^*
\]

in the total-transform basis.  The antinef point bases and local colengths
are:

| cores | raw \(D\) weights | point basis of \(\mathcal J_D\) | point basis of \(\mathcal J_{2D}\) | \((\ell_D,\ell_{2D})\) |
|---|---|---|---|---|
| all \(AA\) | \((1,1,1)\) | \((1,1,1)\) | \((2,2,2)\) | \((3,9)\) |
| \(AF_4,AF_5,AS\) | \((1,1,0,1)\) | \((1,1,1,0)\) | \((2,2,1,1)\) | \((3,8)\) |
| \(FF_P\) | \((1,0,1,0,1)\) | \((1,1,1,0,0)\) | \((2,1,1,1,1)\) | \((3,7)\) |
| \(FF_N\) | \((0,1,0,1,0,1)\) | \((1,1,1,0,0,0)\) | \((1,1,1,1,1,1)\) | \((3,6)\) |

The \(AS\) point bases satisfy the satellite inequalities
\(\mu_q\ge\mu_w+\mu_s\) and \(\mu_w\ge\mu_s\); the displayed vectors are
the least antinef divisors dominating the raw prime coefficients.  The other
rows are successive-free one-line unloadings.

Each of the three singleton trees is \(P_4,P_5\), or \(N\), with doubled
local length respectively \(3,3,2\), as in the two-essential
classification.  Let \(n\) count the \(N\) singletons.  The simple global
cluster always has length

\[
3+3=6,
\tag{3.1}
\]

so \(H^0(\mathcal J_D(2))=0\) makes conic evaluation an isomorphism.  The
doubled lengths are

\[
\ell(O/\mathcal J_{2D})=
\begin{cases}
18-n,&AA,\\
17-n,&AF,AS,\\
16-n,&FF_P,\\
15-n,&FF_N.
\end{cases}
\tag{3.2}
\]

The quartic vanishing therefore forces

\[
\boxed{
n\le3\ (AA),\qquad n\le2\ (AF,AS),\qquad
n\le1\ (FF_P),\qquad n=0\ (FF_N).}
\tag{3.3}
\]

Including parity of the proper singleton roots, (3.3) leaves sixty-eight
unlabelled rows.

## 4. Degree-at-most-five structural pruning

The test-curve lemma from the two-essential classification applies without
change.  For a consistent point basis \(\mu\) and \(d\le5\), if

\[
\sum_v\binom{\mu_v+1}{2}<\binom{d+2}{2},
\tag{4.1}
\]

then a nonzero degree-\(d\) curve \(G\) through that cluster exists.  Since
the retained branch has no component of degree at most five, Noether's
formula requires

\[
\sum_vm_v\mu_v\le10d.
\tag{4.2}
\]

Enumerating all point bases on the eight tiny cores and the three singleton
types gives the following first violations when all proper singleton roots
are \(P_4\):

| excluded row | first violating degree and contact |
|---|---|
| \(AA_{554},n=0,1,2\) | \((2,21),(3,31),(4,41)\) |
| \(AA_{555},n=0,1,2,3\) | \((2,21),(2,21),(3,31),(3,31)\) |
| \(AF_5,n=0,1\) | \((3,31),(4,41)\) |
| \(AS,n=0\) | \((2,21)\) |

Every row containing a \(P_5\) singleton also has a violating conic or
cubic.  For completeness, it is enough to treat one \(P_5\) in each row
which survives the preceding table; increasing another singleton from four
to five only increases contact.  The first contacts are:

| base row | first violating degree and contact after one \(P_5\) |
|---|---|
| \(AA_{444},n=0,1,2\) | \((2,21),(2,21),(3,31)\) |
| \(AF_4,n=0,1,2\) | \((2,21),(3,31),(3,31)\) |
| \(AF_5,n=2\) | \((3,31)\) |
| \(AS,n=1,2\) | \((2,21),(3,31)\) |
| \(FF_P,n=0,1\) | \((3,31),(3,31)\) |
| \(FF_N,n=0\) | \((3,31)\) |

The checker records an explicit consistent point basis and its colength for
every entry, not only the displayed maxima.  Exactly fourteen rows survive:

| repeated core | \(n\) | singleton multiset | doubled length | maximal forced contacts for \(d=1,2,3,4,5\) |
|---|---:|---|---:|---|
| \(AA_{444}\) | 0 | \(P_4^3\) | 18 | \((8,20,28,40,48)\) |
| \(AA_{444}\) | 1 | \(NP_4^2\) | 17 | \((8,20,30,39,50)\) |
| \(AA_{444}\) | 2 | \(N^2P_4\) | 16 | \((8,19,29,40,50)\) |
| \(AA_{444}\) | 3 | \(N^3\) | 15 | \((8,18,30,39,49)\) |
| \(AA_{554}\) | 3 | \(N^3\) | 15 | \((9,18,30,40,50)\) |
| \(AF_4\) | 0 | \(P_4^3\) | 17 | \((8,20,30,39,50)\) |
| \(AF_4\) | 1 | \(NP_4^2\) | 16 | \((8,19,29,40,50)\) |
| \(AF_4\) | 2 | \(N^2P_4\) | 15 | \((8,18,30,39,49)\) |
| \(AF_5\) | 2 | \(N^2P_4\) | 15 | \((9,18,30,40,50)\) |
| \(AS\) | 1 | \(NP_4^2\) | 16 | \((9,20,30,40,50)\) |
| \(AS\) | 2 | \(N^2P_4\) | 15 | \((9,19,30,40,50)\) |
| \(FF_P\) | 0 | \(P_4^3\) | 16 | \((8,19,29,40,50)\) |
| \(FF_P\) | 1 | \(NP_4^2\) | 15 | \((8,18,30,39,49)\) |
| \(FF_N\) | 0 | \(P_4^3\) | 15 | \((8,18,30,39,49)\) |

These maxima concern universally existing curves supported on marked core
subclusters.  Equality with \(10d\) is not an exclusion, and special-position
curves remain available to a later incidence proof.

## 5. Exclusion of the sharp \(AA_{444}+N^3\) row

Write the successive free essential chain as

\[
p<q<s,\qquad (r_p,r_q,r_s)=(m_p,m_q,m_s)=(4,4,4),
\tag{5.1}
\]

and write the three singleton cores as

\[
a_i<b_i,\qquad (r_{a_i},r_{b_i};m_{a_i},m_{b_i})=(3,4;3,3),
\quad 1\le i\le3.
\tag{5.2}
\]

The simple complete cluster has point basis \((1,1,1)\) on the repeated
chain and \((1,0)\) on each singleton.  It has length six, and its conic
evaluation is an isomorphism.  For each \(i\), omit the origin \(a_i\).
There is a unique projective conic \(Q_i\) through the full length-three
cluster \(p<q<s\) and the other two proper origins.

Let \(\tau\) be the tangent line represented by \(q\).  The center \(s\)
is not the continuation point of \(\tau\), since otherwise

\[
I_p(B,\tau)\ge m_p+m_q+m_s=12>10,
\]

forcing a line component.

At least one \(Q_i\) is smooth.  A doubled-line candidate must be supported
on \(\tau\); its support also contains the two selected \(a_j,a_k\), giving
line contact at least \(4+4+3+3=14>10\).  Now suppose \(Q_i\) is the union
of two distinct lines.  It cannot be smooth at \(p\): the component tangent
to \(\tau\) gives only prime valuation two at the noncontinuation center
\(s\), below the required value three.  Hence its node is \(p\), one
component is \(\tau\), and the other is the line through
\(p,a_j,a_k\).  Neither selected origin lies on \(\tau\), since that line
would have contact at least \(4+4+3=11\).  If two of the three candidates
were reducible, their second components would share \(p\) and one \(a_i\),
so all three \(a_i\) would lie with \(p\) on one line.  That line has branch
contact at least

\[
4+3+3+3=13>10,
\]

again impossible.  Thus a smooth \(Q=Q_i\) exists.

On this conic, the repeated chain contributes twelve units of branch contact
and the two marked proper triple points contribute three each:

\[
\boxed{I(B,Q)\ge18.}
\tag{5.3}
\]

Only the proper points \(a_j,a_k\) are retained; forgetting their tangent
directions \(b_j,b_k\), and forgetting the third singleton entirely,
enlarges the incidence.  The repeated chain moves in dimension four and the
two proper points in dimension four, so the marked configuration has
dimension eight.  The conic is uniquely selected and adds no parameter.

For rank three, restriction to \(Q\) is onto the
thirty-three-dimensional \((10,10,10)\) quadratic-form space.  Every fixed
determinant fiber has dimension at most twelve, and a degree-twenty
determinant with eighteen marked zeros lies in a three-dimensional linear
target.  Hence the fixed-\(\sigma\) codimension is at least

\[
33-(12+3)-8=10>8.
\tag{5.4}
\]

For rank two, let \(b\) be the base point.  The exhaustive positions are

\[
\begin{array}{c|c|c|c|c|c}
\text{position of }b&\text{image}&\text{fixed fiber}&\dim U&
\dim\text{ config}&\text{codim}\\ \hline
b\notin Q&33&13&3&8&9\\
b\in Q\text{ unmarked}&30&11&1&7&11\\
b=p,a_j,\text{ or }a_k&30&11&3&6&10.
\end{array}
\tag{5.5}
\]

In the unmarked row, the forced base square leaves a degree-eighteen
determinant with all eighteen marked zeros.  In the marked row, the square
uses two units at the marked point, leaving sixteen forced zeros on a
degree-eighteen determinant.  The table includes the omitted origin when it
happens to equal \(b\), or to lie on \(Q\), because that is an unmarked
condition in the enlarged incidence.  Every rank-two codimension is larger
than the orbit dimension seven.

Thus the row \(AA_{444}+N^3\) is absent for a general equation.

## 6. Exact intermediate boundary

After Section 5, the structural list contains thirteen rows: the fourteen
rows in Section 4 except \(AA_{444}+N^3\).  This is the boundary of the
classification-and-pruning argument in this note, not the current D4
boundary; the uniform conic theorem cited above excludes all thirteen.  The
quintic-factor theorem makes
the retained branch integral, so

\[
G=n_5-n_2\ge0.
\tag{6.1}
\]

There are no \(P_5\) singleton roots.  Consequently the terminal
corrected-double bounds are

\[
\begin{array}{c|c|c}
\text{cores}&n_5&\text{bound}\\ \hline
AA_{444},AF_4,FF_P,FF_N&0&n_2=0,\ G=0,\\
AF_5&1&0\le n_2\le1,\\
AA_{554},AS&2&0\le n_2\le2.
\end{array}
\tag{6.2}
\]

Any terminal \(t=1\) extension is subject to (6.2), proximity, terminal
smoothness, and degree-ten contact.  It does not change either complete
cluster ideal, and forgetting it is safe for subsequent negative incidence
arguments.

The accompanying
[`k1_three_essential_tree_checks.py`](k1_three_essential_tree_checks.py)
replays the eight core parity/proximity tables, antinef minimality, all
colength bounds, the sixty-eight-to-fourteen test-curve pruning, and every
margin in (5.4)--(5.5).
