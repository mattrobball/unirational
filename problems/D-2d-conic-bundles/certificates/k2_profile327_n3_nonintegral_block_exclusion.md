# The nonintegral-block exclusion for \(n=3\)

## Verdict and exact scope

Continue with the proper-high, seven-distinct-singleton
\([3,2^7]\) stratum of
[`k2_profile327_multiple_nonproper_frontier.md`](k2_profile327_multiple_nonproper_frontier.md).
Assume that exactly three low singleton trees are nonproper.  Write

\[
a_i<q_i,\qquad T_i=\overline{a_iq_i},\qquad i=1,2,3,
\tag{0.1}
\]

for their proper origins and marked tangent lines, and write
\(P_1,\ldots,P_4\) for the four proper low origins.  The high origin is
\(p\).  For each \(i\), let \(C_i=C_{N_i}\) be the unique cubic which is
double at \(p\), contains

\[
P_1,\ldots,P_4,a_j,a_k,\qquad \{i,j,k\}=\{1,2,3\},
\tag{0.2}
\]

and avoids \(a_i\).

The simultaneous-jet theorem
[`k2_profile327_n3_simultaneous_jet_frontier.md`](k2_profile327_n3_simultaneous_jet_frontier.md)
proves that every integral \(C_i\) is absent for a general base-point-free
equation.  This note excludes the entire nonintegral complement.  The
argument has four steps.

1. A reduced nonintegral \(C_i\) with no branch component has only three
   possible contact distributions.  Each has strict incidence margin.
   Every nonreduced \(C_i\) either doubles a branch line or supplies two
   distinct branch lines.
2. Hence every surviving \(C_i\) supplies exactly one integral branch
   component of degree one or two.  The low-degree factor-pair theorem
   forces the three supplied components to be one common component \(H\).
3. A common integral conic, and a common line not through \(p\), are
   impossible.  A common line through \(p\) must contain exactly two of
   the four proper low origins.
4. For that last common line, both integral and reducible residual conics
   have strict incidence margin.  The all-rank-one integral-residual row
   uses a new fact: three distinct prescribed jumping lines impose
   codimension three on a net of conics, and ramification on the third
   line imposes a fourth condition.

Combining this note with the preceding integral-cubic theorem gives

\[
\boxed{
\text{the proper-high seven-distinct-singleton }n=3
\text{ stratum is absent.}}
\tag{0.3}
\]

This assertion is only about the \(n=3\) row in the stated singleton
problem.  It makes no new claim about repeated essential trees, a
nonproper high center, isolated base schemes, or any other profile.

We work over the characteristic-zero ground field of the problem.

## 1. Contact rules and the local estimates

The reduced branch curve \(B\) has degree twelve.  At the high origin it
has multiplicity at least six.  A proper low origin contributes contact
four.  At a nonproper tree \(a_i<q_i\), a curve transverse to \(T_i\)
sees contact three at \(a_i\); if it follows \(T_i\), it sees the further
contact three at \(q_i\).

The following estimates have already been proved, including rank,
splitting, ramification, and cross-incidence boundaries, in
[`k2_profile327_n2_common_support_jet_reduction.md`](k2_profile327_n2_common_support_jet_reduction.md),
[`k2_profile327_n2_residual_boundary_exclusion.md`](k2_profile327_n2_residual_boundary_exclusion.md),
and
[`k2_profile327_n3_simultaneous_jet_frontier.md`](k2_profile327_n3_simultaneous_jet_frontier.md).

* At an omitted nonproper origin outside a selected cubic, the marked
  six-jet has raw codimension six on a balanced line and five on an
  unbalanced line.  Since unbalancedness costs one parameter, its
  effective codimension is six.
* If the outside value has rank zero, the corresponding raw codimensions
  are seven and six.  Its effective codimension is seven.
* After the outside line has been fixed, a selected rank-zero point gives
  effective codimension at least three.  This count uses ramification or
  cross-incidence when necessary, but does not use the selected-line
  unbalanced condition.
* After the outside line has been fixed, a selected rank-one point gives
  effective codimension four when its splitting and, in the flat row,
  its ramification are counted.  If the selected-line splitting condition
  is reserved for another purpose, the contribution is still at least
  three: the ordinary unbalanced row has raw codimension three, while
  ramification and cross-incidence pay for their respective further
  losses.
* For two distinct prescribed lines, their unbalanced conditions are
  independent.  This remains true when ramification at a specified point
  on one of the lines is imposed.

Whenever a selected component follows \(T_j\), the extra contact three
either makes that component a branch component or improves the fixed
restriction estimate.  Thus the worst rows below are smooth and
transverse at the selected nonproper origin.

## 2. Coincident and cross marked lines

The case

\[
T_1=T_2=T_3=T
\tag{2.1}
\]

is impossible before any cubic is selected.  The three nonproper paths
give contact \(3(3+3)=18\) on \(T\), so \(T\mid B\).  After one copy is
removed, each path leaves residual contact
\((3-1)+(3-1)=4\).  Hence the residual degree-eleven curve has contact
twelve with \(T\), forcing \(T\) a second time.  This contradicts the
reducedness of \(B\).

Consequently, for every omitted index needed below, one can choose a
selected index \(j\ne i\) with \(T_j\ne T_i\).  If exactly two of the
three marked lines coincide, choose the other selected line.  The unused
coincidence only lowers the moving dimension.

A cross-incidence

\[
a_j\in T_i,\qquad T_i\ne T_j,
\tag{2.2}
\]

costs one configuration parameter.  The constant-matrix selected-jet
bound loses at most one equation, so the effective estimates in Section 1
are unchanged.  Opposite cross-incidences force the two lines to coincide
and are handled by the preceding choice.

There is a stronger observation after a common branch component \(H\) has
been obtained.  The common component contains none of the \(a_i\), so
\(H\ne T_i\) for every \(i\).  If \(T_i=T_j\), the two followed
nonproper paths already give contact twelve on that line, while the
intersection with the distinct branch component \(H\) supplies another
zero.  Thus \(T_i\) would be a second branch line, contrary to the
low-degree factor-pair theorem.  Therefore, on the common-support survivor,

\[
\boxed{H,T_1,T_2,T_3\text{ are distinct, and the }T_i
\text{ are pairwise distinct}.}
\tag{2.3}
\]

Cross-incidences between these distinct lines are still allowed and are
paid for by \((2.2)\).

## 3. A nonproper-deleted cubic without a branch factor

Fix \(i\), and choose \(j\ne i\) with \(T_j\ne T_i\).  Retain the
outside direction \(T_i\), the selected direction \(T_j\), all eight
proper origins of the pushed-down cluster, and the quadratic triple.  The
moving dimension before a factorization condition is

\[
16+2+17=35.
\tag{3.1}
\]

The fixed restriction image on a cubic has dimension fifty-four.  For a
fixed determinant on a line, the matrix fiber has dimension at most
eight on a balanced line and nine on an unbalanced line.  For a fixed
determinant on an integral conic, the uniform fiber bound is seventeen.

### 3.1 Integral cubic

This case is already excluded by the preceding \(n=3\) theorem.  With
only the two retained directions in \((3.1)\), its fixed codimension is
twenty-eight, and the simpler margin is already

\[
28+6+3-35=\boxed2.
\tag{3.2}
\]

We include \((3.2)\) only to make the present factor audit self-contained.

### 3.2 A line and an integral conic

Suppose

\[
C_i=L\cup Q,
\tag{3.3}
\]

where \(Q\) is integral, and suppose neither component divides \(B\).
Both components pass through \(p\).  The selected low weights are

\[
4,4,4,4,3,3,
\tag{3.4}
\]

of total weight twenty-two.  The line can carry low weight at most six,
and the conic can carry low weight at most eighteen.  Therefore the only
branch-free distributions are

\[
\begin{array}{c|c|c|c}
L\text{ carries}&Q\text{ carries}&B\cdot L&B\cdot Q\\ \hline
\text{one proper low}&\text{three proper and two nonproper lows}&10&24\\
\text{both nonproper lows}&\text{four proper lows}&12&22.
\end{array}
\tag{3.5}
\]

A selected low at the second point of \(L\cap Q\) would be counted on
both components.  Even the smallest duplicated weight three exceeds the
combined spare capacity two, so one component would be forced.  Thus the
distributions in \((3.5)\) are disjoint.  Following a selected marked tangent
also forces the component which contains that point.

The determinant target dimensions on \(L,Q\) are respectively
\((3,1)\) and \((1,3)\).  At the second point of \(L\cap Q\), determinant
gluing cuts one condition, so the joint target has dimension three.

Hence the bad fixed-restriction locus has dimension at most

\[
8+17+3=28
\tag{3.6}
\]

when \(L\) is balanced, and at most twenty-nine when it is unbalanced.
The raw fixed codimensions are twenty-six and twenty-five.  The
unbalanced-line condition makes the effective fixed codimension
twenty-six in both rows.

If \(L\) and \(Q\) are tangent at \(p\), their length-two intersection is
supported there.  Both determinant targets already vanish to order at
least six at \(p\), so determinant gluing on that length-two scheme is
automatic.  The joint target then has dimension four and the effective
fixed codimension drops from twenty-six to twenty-five.  Tangency of
\(L,Q\) at \(p\) is one further configuration condition, so this row has
the separate strict margin

\[
25+6+3-(35-1-1)=\boxed1.
\tag{3.7}
\]

The factorization itself costs one parameter.  In the first row of \((3.5)\),
the conic must contain \(p\) and the remaining five lows; in the second,
the condition is the collinearity of \(p\) with the two nonproper lows.
The component line and the outside marked line are distinct.  Their
splitting conditions are independent, while the selected contribution
three uses no selected-line splitting condition.  Thus

\[
26+6+3-(35-1)=\boxed1.
\tag{3.8}
\]

Every reduced line--integral-conic factorization without a branch
component is absent.

### 3.3 Three distinct lines

At least two of the three component lines pass through \(p\).  If all
three did, their combined low-weight capacity would be eighteen, smaller
than the total twenty-two.  Thus exactly two pass through \(p\).

A \(p\)-line can carry low weight at most six, and the third line can
carry weight at most twelve.  The unique branch-free distribution, up to
swapping the two \(p\)-lines, is

\[
\boxed{
\begin{array}{c|c|c}
\text{first }p\text{-line}&\text{second }p\text{-line}&
\text{non-}p\text{ line}\\ \hline
\text{both nonproper lows}&\text{one proper low}&\text{three proper lows}\\
12&10&12.
\end{array}}
\tag{3.9}
\]

Again, a low at a component node would duplicate at least weight three,
while the total spare capacity is only two; hence no selected low is a
node in a branch-free row.  Following a marked tangent forces the
corresponding component.

The target dimensions are \(1,3,1\).  The two nodes away from \(p\) give
two independent determinant equalities, so the joint target dimension is
three.  If \(j\) of the three component lines are unbalanced, the bad
fixed-restriction locus has dimension at most

\[
(24+j)+3=27+j.
\tag{3.10}
\]

Thus the raw fixed codimension is \(27-j\).  For \(j\le2\) it is already
at least twenty-five.  If all three lines are unbalanced, any one of
their proper jumping conditions raises the effective fixed codimension
from twenty-four to twenty-five.  If the outside marked line is also
unbalanced, its condition is independent of the condition on any one
distinct component line.  Hence the cubic and outside jet have joint
effective codimension at least \(25+6\).

The distribution \((3.9)\) costs two configuration parameters: the two
nonproper lows are collinear with \(p\), and the remaining three proper
lows are collinear.  Therefore

\[
25+6+3-(35-2)=\boxed1.
\tag{3.11}
\]

Every reduced three-line factorization without a branch component is
absent.

### 3.4 Nonreduced cubics

Write a nonreduced cubic as

\[
C_i=2L+M.
\tag{3.12}
\]

The doubled line \(L\) passes through \(p\).  Assign a low at \(L\cap M\)
to either support; its actual contribution is no smaller than the
assigned one.  The following disjoint-assignment audit is therefore
sufficient.

* If \(L\) carries at least three selected lows, the least possible triple
  consists of the two nonproper lows and one proper low.  After a forced
  copy of \(L\) is removed from \(B\), the residual contact is

  \[
  5+2+2+3=12>11.
\tag{3.13}
  \]

  Thus \(L\) occurs twice in \(B\), contrary to reducedness.
* If \(L\) carries exactly two lows and they are both nonproper, \(M\)
  carries the four proper lows.  After one copy of \(M\) is removed, the
  residual contact is \(4\cdot3=12>11\), so \(M\) occurs twice in \(B\).
* If the pair on \(L\) is nonproper--proper or proper--proper, then both
  \(L\) and \(M\) have contact greater than twelve.  They are two distinct
  branch lines, excluded by the low-degree factor-pair theorem.
* If \(L\) carries at most one low, \(M\) carries at least five.  The
  smallest residual contact after removing \(M\) is

  \[
  2\cdot2+3\cdot3=13>11,
\tag{3.14}
  \]

  so \(M\) occurs twice in \(B\).

A triple line is still more restrictive.  Thus no nonreduced \(C_i\)
survives.

### 3.5 Consequence for each deleted cubic

Sections 3.1--3.4 exhaust all cubic factorizations.  Therefore a surviving
\(C_i\) has at least one integral branch component of degree one or two.
It has at most one, since two distinct such components are excluded by the
factor-pair theorem.  Hence every \(C_i\) supplies exactly one branch
component.

## 4. The common branch component

Let \(H_i\) be the unique branch component supplied by \(C_i\).  If two
of the \(H_i\) were distinct, the low-degree factor-pair theorem would
exclude the equation.  Thus

\[
H_1=H_2=H_3=H.
\tag{4.1}
\]

Since \(H\mid C_i\) and \(C_i\) avoids \(a_i\),

\[
\boxed{a_1,a_2,a_3\notin H.}
\tag{4.2}
\]

### 4.1 A common integral conic

Suppose \(H\) is an integral conic.  It must pass through \(p\); otherwise
the residual line in \(C_i\) gives only multiplicity one at \(p\).  The
residual line also passes through \(p,a_j,a_k\), because \((4.2)\) puts the
two selected nonproper origins off \(H\).  Applying this for all three
omitted indices makes \(p,a_1,a_2,a_3\) collinear.  The residual line in
every \(C_i\) then contains the omitted \(a_i\), contradicting the defining
avoidance \(a_i\notin C_i\).  A common conic is impossible.

### 4.2 A common line not through \(p\)

Suppose \(H\) is a line not through \(p\).  The residual conic in every
\(C_i\) is double at \(p\), hence is a union of two \(p\)-lines; the
nonreduced alternative was excluded in Section 3.4.

Neither residual \(p\)-line can be a second branch line.  One such line
may contain both selected nonproper lows, of combined weight six, while
the other may contain at most one proper low.  If the nonproper lows are
separated, neither \(p\)-line can also contain a proper low.  Therefore
\(H\) contains at least three of the four proper lows.

If it contains all four, removing the branch line \(H\) leaves residual
contact

\[
4(4-1)=12>11,
\tag{4.3}
\]

so \(H\) is doubled in \(B\).  If it contains exactly three, the remaining
proper low lies on one residual \(p\)-line, and the two selected
nonproper lows must lie together on the other.  This must hold for every
pair \(a_j,a_k\), so \(p,a_1,a_2,a_3\) are collinear.  The corresponding
residual line again contains the omitted \(a_i\), contradicting
\(a_i\notin C_i\).  A common non-\(p\) line is impossible.

### 4.3 A common line through \(p\)

Suppose \(H\) is a line through \(p\), and let \(h\) be the number of
proper low origins on \(H\).  By \((4.2)\), it contains no nonproper origin.

If \(h=0\), the residual conic in \(C_i\) has visible contact

\[
6+4\cdot4+2\cdot3=28>24,
\tag{4.4}
\]

so it or one of its components is a second branch component.  If \(h=1\),
the visible residual contact is exactly twenty-four.  The branch factor
\(H\mid B\) supplies one further zero at the second point of intersection
with the residual conic.  If that intersection is tangent at \(p\), the
same extra zero is present scheme-theoretically: writing \(B=HB'\), one
has contact at least \(2+5=7\) at \(p\), one above the visible six.
Thus \(h=1\) also forces a second residual branch component.

If \(h\ge3\), then after removing \(H\) the residual contact on it is

\[
5+3h>11,
\tag{4.5}
\]

so \(H\) is doubled.  The only surviving value is therefore

\[
\boxed{h=2.}
\tag{4.6}
\]

Relabel the proper lows so that

\[
H=\overline{pP_1P_2}.
\tag{4.7}
\]

This common collinearity costs one configuration parameter.

## 5. Three prescribed jumping lines

The all-rank-one row below needs an independence statement for three line
splittings.  We prove it here rather than assuming additivity.

Let

\[
V=H^0(\mathbf P^2,O(2)),\qquad \dim V=6,
\tag{5.1}
\]

and let \(S\in\operatorname {Gr}(3,V)\) be the net spanned by a quadratic
triple.  For a line \(L=(\ell=0)\), put

\[
W_L=\ell H^0(O(1))\subset V,\qquad \dim W_L=3.
\tag{5.2}
\]

On the base-point-free open set, \(L\) is unbalanced exactly when

\[
S\cap W_L\ne0.
\tag{5.3}
\]

Indeed, \((5.3)\) says that the restriction of the three quadrics to \(L\)
has rank at most two.  It cannot have rank at most one on a base-point-free
net, because a one-dimensional system of positive-degree sections on
\(L\simeq\mathbf P^1\) has a zero.

Fix three distinct lines \(L_1,L_2,L_3\).  Choose
\([q_i]\in\mathbf P(W_{L_i})\).  When \(q_1,q_2,q_3\) are independent,
they span the unique net \(S\), so the incidence has dimension

\[
2+2+2=6.
\tag{5.4}
\]

It remains to audit dependent triples.  If the three lines are not
concurrent, normalize them to \(x=0,y=0,z=0\).  A relation has the form

\[
x m_1+y m_2+z m_3=0,
\tag{5.5}
\]

with linear \(m_i\).  The linear-syzygy space has vector dimension three.
Thus the projective dependent-triple space has dimension at most two;
choosing a three-plane containing its two-dimensional span adds

\[
\dim\operatorname {Gr}(1,4)=3.
\tag{5.6}
\]

The dependent incidence has dimension at most five.  A relation with one
zero coefficient is a proportional-pair boundary and has the same or
smaller dimension.

If the lines are concurrent, normalize them to
\(x=0,y=0,x+y=0\).  Then

\[
x m_1+y m_2+(x+y)m_3=0
\tag{5.7}
\]

has a four-dimensional vector solution space:

\[
m_1=-m_3+\lambda y,\qquad
m_2=-m_3-\lambda x.
\tag{5.8}
\]

The projective dependent-triple space has dimension at most three, and
\((5.6)\) gives incidence dimension at most six.  The common-factor subrow
\(\lambda=0\) has dimension at most five after \(S\) is chosen.  The
independent-triple incidence is disjoint from the base-point-free open in
the concurrent case, because its three generators all vanish at the
common point.

Since

\[
\dim\operatorname {Gr}(3,6)=9,
\tag{5.9}
\]

\((5.4)\)--\((5.8)\) prove

\[
\boxed{
L_1,L_2,L_3\text{ all unbalanced has codimension at least }3.}
\tag{5.10}
\]

The bound remains true in the ordered projective seventeen-dimensional
space of quadratic triples, because choosing an ordered projective basis
of \(S\) adds the same eight dimensions to every stratum.

Now fix a point \(a\in L_3\).  Ramification of the degree-two map on
\(L_3\) is one closed equation on the rank-two unbalanced locus.  It is
not automatic on either six-dimensional incidence component above.  On
the nonconcurrent independent component, the two nonzero restrictions to
\(L_3\) can be chosen as quadratics with prescribed distinct linear
factors \(L_1\cap L_3\) and \(L_2\cap L_3\); their cofactors can be chosen
so that the pencil is base-point-free and its Wronskian is nonzero at any
specified \(a\).  For example, for the coordinate triangle the
base-point-free net

\[
S=\langle x^2,\ y(x+y),\ z^2\rangle
\tag{5.11}
\]

restricts on \(z=0\), near \([1:0:0]\), to
\([1,t+t^2]\), which is unramified there.

On the concurrent dependent component, take

\[
\begin{aligned}
q_1&=x(y-z),\\
q_2&=-y(z+x),\\
q_3&=(x+y)z,\\
g&=x^2+y^2+z^2.
\end{aligned}
\qquad q_1+q_2+q_3=0.
\tag{5.12}
\]

The net \(\langle q_1,q_2,g\rangle\) is base-point-free and contains a
nonzero element of every \(W_{L_i}\).  On \(x+y=0\), near the common
point, its pencil is represented by
\([-t-t^2,1+2t^2]\), whose Wronskian is nonzero at \(t=0\).  Varying the
cofactor and \(g\) gives the same conclusion at any prescribed point.
Thus ramification cuts every top-dimensional component, while all other
components already have dimension at most five.  Therefore

\[
\boxed{
\begin{gathered}
L_1,L_2,L_3\text{ all unbalanced, and the map on }L_3\\
\text{ramified at a specified point, has codimension at least }4.
\end{gathered}}
\tag{5.13}
\]

This proof includes dependent and concurrent triples; it is not a
generic-line transversality assertion.

## 6. Excluding the common line

Write

\[
C_i=H R_i,
\tag{6.1}
\]

with \(H\) as in \((4.7)\).  The residual conic passes through

\[
p,P_3,P_4,a_j,a_k.
\tag{6.2}
\]

Retain \(T_i\) and one selected \(T_j\).  The common collinearity in
\((4.7)\) lowers \((3.1)\) to the baseline moving dimension

\[
35-1=34.
\tag{6.3}
\]

### 6.1 Integral residual conic: fixed restriction

Suppose \(R_i\) is integral.  Its visible contact is

\[
6+2\cdot4+2\cdot3=20.
\tag{6.4}
\]

The determinant target initially has dimension \(25-20=5\).  The second
intersection with the branch line \(H\) cuts it to dimension four.  If
\(H\) and \(R_i\) are tangent at \(p\), the same extra zero is present
scheme-theoretically, as in Section 4.3.

The fixed bad locus therefore has dimension at most

\[
8+(17+4)=29
\tag{6.5}
\]

when \(H\) is balanced, and at most thirty when \(H\) is unbalanced.  Its
raw fixed codimension is twenty-five or twenty-four; the unbalancedness
of \(H\) makes the effective fixed codimension twenty-five.

The marked lines \(T_i,T_j\) are distinct from \(H\) by \((2.3)\).  Tangency
of \(R_i\) to \(T_j\) raises the visible residual contact from twenty to
twenty-three.  The zero supplied by \(H\) raises it to twenty-four, so the
residual determinant target has dimension one.  The effective fixed
codimension is then twenty-eight.  This tangency costs one configuration
parameter, and we may forget the selected-line jet entirely:

\[
28+6-(34-1)=\boxed1.
\tag{6.6}
\]

Thus the tangent row is absent, and Sections 6.2--6.3 may assume that the
selected intersection is transverse.

### 6.2 A rank-zero value

Suppose some \(q(a_i)\) has rank zero, and select the cubic \(C_i\) which
omits that origin.  The outside condition has effective codimension
seven.  The splitting conditions on \(H\) and \(T_i\) are independent,
so the fixed restriction and outside condition have joint effective
codimension \(25+7\).  Either selected origin then contributes three
without using its splitting condition.  The margin is

\[
25+7+3-34=\boxed1.
\tag{6.7}
\]

Thus every integral-residual row containing a rank-zero nonproper value
is absent.

### 6.3 All three values have rank one

Assume now that all three values have rank one.  Choose \(i,j\) with
\(T_i\ne T_j\), as in Section 2.  The three lines

\[
H,T_i,T_j
\]

are distinct.  A raw loss of one may occur when each is unbalanced: in
the fixed restriction, the outside six-jet, and the selected
constant-matrix condition, respectively.  Equation \((5.10)\) supplies the
three independent splitting conditions.  If the selected unbalanced map
is in the ramified-flat row, its further raw loss is paid by \((5.13)\).

If a cross-incidence \(a_j\in T_i\) occurs, it costs one configuration
parameter and pays for the corresponding one-equation local loss.  The
ramification statement \((5.13)\) still applies: its prescribed point may be
\(T_i\cap T_j\), and \(H\) does not pass through that point by \((4.2)\).
Rows with fewer unbalanced lines use the one- and two-line versions of
the same incidence statement.

Hence the fixed restriction, outside jet, and selected jet have joint
effective codimension at least \(25+6+4\), and

\[
25+6+4-34=\boxed1.
\tag{6.8}
\]

This closes the all-rank-one integral-residual row, including dependent,
concurrent, ramified, and cross marked-line strata.

### 6.4 Reducible residual conic

It remains to suppose

\[
R_i=U\cup V
\tag{6.9}
\]

is reduced.  If both residual lines passed through \(p\), their total
low-weight capacity would be twelve, smaller than the weight fourteen in
\((6.2)\).  Thus exactly one, say \(U\), passes through \(p\).

The three component lines \(H,U,V\) are distinct.  Indeed, \(U\ne V\)
because the residual conic is reduced, and \(V\ne H\) because \(V\) does
not pass through \(p\).  If \(U=H\), then \(C_i=H^2V\) is nonreduced and
was already excluded in Section 3.4.  Thus every invocation of the
three-line jumping lemma below is on three genuinely distinct lines.

The branch line \(H\) meets \(V\) and supplies one determinant zero there.
If the four selected lows are disjoint from \(U\cap V\), the exact
branch-free distributions are

\[
\begin{array}{c|c|c|c}
U\text{ carries}&V\text{ carries}&B\cdot U&B\cdot V
\text{ including }H\cap V\\ \hline
\text{one nonproper low}&\text{two proper and one nonproper lows}&9&12\\
\text{one proper low}&\text{one proper and two nonproper lows}&10&11\\
\text{both nonproper lows}&\text{two proper lows}&12&9.
\end{array}
\tag{6.10}
\]

The component target dimensions sum to five.  Determinant gluing at
\(U\cap V\) cuts one condition, so the joint target dimension is

\[
\boxed4.
\tag{6.11}
\]

This is the sharp value; no second gluing condition is counted after the
zero at \(H\cap V\) has already been included in \((6.10)\).

The only possible selected-low overlap at \(U\cap V\) is one nonproper
origin: then \(U\) contains both nonproper lows and \(V\) contains that
node together with the two proper lows.  Both determinant targets vanish
at the common node, lowering their joint dimension to two, and the node
condition costs one further configuration parameter.  Thus this overlap
is strictly better than \((6.10)\).  A proper-low overlap exceeds the total
contact capacity.  An intersection \(H\cap V\) at \(P_1\) or \(P_2\)
adds the full proper-low contact and is again strictly better.

There is one selected-tangency row which is not forced into the branch.
In the first row of \((6.10)\), the \(p\)-line \(U\) has contact nine;
if its unique nonproper low is selected and \(T_j=U\), the contact rises
to exactly twelve.  Every other selected tangency in \((6.10)\) raises a
component contact above its degree.  In this exceptional row, the target
on \(U\) drops from dimension four to dimension one, so the joint
\(U,V\) target drops from four to one.  If \(j\) component lines are
unbalanced, the raw fixed codimension is therefore \(29-j\).

The tangent-direction equality costs one configuration parameter, and we
forget the selected jet.  To avoid any four-line independence claim, keep
only effective fixed codimension twenty-eight.  For \(j=2\), one
component-line condition pays for the single raw loss; for \(j=3\), two
component-line conditions pay for the two raw losses.  If the outside
line is also unbalanced, use one component plus the outside line when
\(j=2\), and two components plus the outside line when \(j=3\).
Two-line independence and \((5.10)\) give the required two or three
conditions.  The outside line is distinct from every component.  Hence
this tangent row has margin

\[
28+6-(34-1-1)=\boxed2.
\tag{6.12}
\]

Let \(j\) of \(H,U,V\) be unbalanced.  Ignoring matrix gluing enlarges the
fixed bad locus to dimension at most

\[
(24+j)+4=28+j.
\tag{6.13}
\]

Thus the raw fixed codimension is

\[
\boxed{26-j.}
\tag{6.14}
\]

The reducibility condition in \((6.10)\) costs one parameter: according to
the row, it is a three-point collinearity on \(U\) or \(V\).  The moving
dimension is therefore at most thirty-three.

We now allocate splitting conditions without double counting.  If
\(j=0,1\), \((6.13)\) is already at least twenty-five.  If \(j=2\), one of
the two component-line conditions raises the effective fixed codimension
to twenty-five.  If \(j=3\), two of the three component-line conditions
do so.  If the outside marked line is also unbalanced, it is distinct
from all components because its origin \(a_i\) lies outside \(C_i\).
For \(j=2\), one component line together with the outside line gives two
independent conditions.  For \(j=3\), two component lines together with
the outside line give three conditions by \((5.10)\).  Consequently, in every
splitting row, the fixed cubic restriction and the outside jet have joint
effective codimension at least

\[
25+6=31.
\tag{6.15}
\]

At most one selected nonproper origin is the node \(U\cap V\), so choose
the other selected origin for the constant-matrix condition.  It is a
smooth point of the cubic.  Pairwise distinctness of the marked lines is
already known from \((2.3)\).  The selected point contributes three without
using its unbalanced-line condition in the ordinary rows; a cross-incidence
is paid for as in Section 2.

There is no hidden reuse in a ramified selected row.  If a component line
\(K\), the outside line \(T_i\), and the selected line \(T_j\) are all
unbalanced, then they are three distinct prescribed lines.  Apply
\((5.13)\) to

\[
K,\ T_i,\ T_j
\tag{6.16}
\]

with ramification specified at \(a_j\).  Their three splitting conditions
together with ramification have joint codimension four.  In the worst row
\(j=3\), with the outside and selected lines unbalanced and the selected
map ramified, use one component-line condition, the outside-line
condition, the selected-line condition, and ramification from this
codimension-four incidence.  The raw sum is

\[
(26-3)+(6-1)+2=30,
\tag{6.17}
\]

and the four independent parameter conditions raise it to thirty-four.
The other two component-line jumping conditions are not counted.  If
fewer of these lines are unbalanced, the raw fixed or jet codimension
improves; the two-line ramification independence recalled in Section 1
handles the remaining boundary.  A cross-incidence, if present, is a
separate configuration condition and pays only for its own local loss.

Thus in every selected rank and ramification row,

\[
31+3-(34-1)=\boxed1.
\tag{6.18}
\]

Every reducible-residual row is absent, independently of the three value
ranks.

## 7. Exhaustion

Every nonproper-deleted cubic is integral, a reduced line--integral-conic
union, three distinct lines, or nonreduced.  Section 3 excludes an
integral cubic and every nonintegral cubic with no branch factor, while
nonreduced cubics contradict reducedness or the factor-pair theorem.
Thus each cubic supplies a unique low-degree branch factor.  Section 4
forces those factors to be one common \(H\) and reduces \(H\) to the line
through \(p\) and exactly two proper lows.  Sections 6.1--6.4 exclude both
possible residual-conic types for that line, in every rank, splitting,
ramification, coincidence, tangency, node, and cross-incidence stratum.

There is no nonintegral block row left.  Together with the integral-cubic
exclusion in the preceding \(n=3\) theorem, this proves \((0.3)\).

The contact partitions, fixed target dimensions, raw and effective
codimensions, syzygy dimensions in the three-line Schubert incidence,
explicit nonramification witnesses, and every strict margin are replayed
by
[`k2_profile327_n3_nonintegral_block_checks.py`](k2_profile327_n3_nonintegral_block_checks.py).
