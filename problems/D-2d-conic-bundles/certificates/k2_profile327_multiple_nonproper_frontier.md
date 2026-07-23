# Multiple nonproper singletons in the \([3,2^7]\) profile

## Verdict and scope

Let

\[
0\longrightarrow \mathscr K\longrightarrow O_{\mathbf P^2}^{3}
\xrightarrow{\ \sigma\ }O_{\mathbf P^2}(2)\longrightarrow0
\]

be defined by a base-point-free quadratic triple, and let
\(B=\sigma^t\operatorname {adj}(A)\sigma\) be its reduced degree-twelve
branch whose connected double plane is rational.  Assume that the unique
\(t=3\) center is proper and that the seven
\(t=2\) centers lie in seven distinct proper-origin singleton trees.  Write
\(n\) for the number of nonproper singletons, each of which is a free first-
near point over its proper origin with no essential predecessor.  The
doubled-adjoint injection recalled in the one-nonproper theorem gives
\(n\le3\), so the only rows in scope below are \(n=2,3\).

This note proves the following strict reduction.

1. If \(n=2\), each of the two deleted-adjoint cubics obtained by omitting
   a nonproper label is nonintegral for a general equation.
2. Each of those two nonintegral cubics supplies an integral branch
   component of degree at most two.  Hence a surviving \(n=2\) row is
   forced into exactly one of two common-support alignments: either both
   cubics contain the same line through \(p\) and exactly two proper low
   origins, or both contain the same integral conic through \(p\) and all
   five proper low origins.
3. If \(n=3\), the identical one-line calculation is exactly borderline:
   it has incidence margin zero, not a strict exclusion.
4. For an integral deleted cubic containing \(s\) selected nonproper
   origins, the cubic restriction has fixed codimension \(30-s\).  After
   retaining all \(s\) marked tangents, a proof by simultaneous transverse
   six-jets would require joint codimension at least

   \[
   \boxed{2s+2-e},
   \tag{0.1}
   \]

   where \(e\) is the actual codimension contributed by the joint
   unbalanced-line conditions.  For distinct independently moving marked
   lines one has \(e=j\), where \(j\) of them are unbalanced; coincident or
   dependent jumping-line conditions can have \(e<j\).  Thus the first
   genuinely new bounds are \(6-e\) for \(s=2\) and \(8-e\) for \(s=3\).
   The existing one-line lemmas do not by themselves prove that their
   codimensions add.
5. The exact weak-block table is recorded in Section 4.  Distinct
   \(P\)-blocks can have the same supporting line without contradicting
   squarefreeness only when \(n=3\) and the line contains the high center
   and all three nonproper origins.  Distinct integral \(Q\)-blocks can
   have the same supporting conic only when \(n=3\) and the conic contains
   the high center, all three nonproper origins, and three proper low
   origins.

Two subsequent theorems close item 2.  The two-line jet theorem first
reduces its common supports to the exact rank-zero or reducible-residual
complement; see
[`k2_profile327_n2_common_support_jet_reduction.md`](k2_profile327_n2_common_support_jet_reduction.md).
The residual-boundary theorem then excludes that entire complement,
including the mixed mismatches; see
[`k2_profile327_n2_residual_boundary_exclusion.md`](k2_profile327_n2_residual_boundary_exclusion.md).
Consequently the full \(n=2\) stratum in this note's scope is absent.

Two further subsequent theorems close \(n=3\).  The fixed-fiber
simultaneous-jet theorem
[`k2_profile327_n3_simultaneous_jet_frontier.md`](k2_profile327_n3_simultaneous_jet_frontier.md)
excludes all seven integral deleted-adjoint cubics.  The nonintegral-block
theorem
[`k2_profile327_n3_nonintegral_block_exclusion.md`](k2_profile327_n3_nonintegral_block_exclusion.md)
excludes the complete nonintegral complement.  Consequently the full
\(n=3\) stratum in this note's scope is also absent.  Items 3--5 remain the
historical frontier statements proved by this note, not exclusions by
themselves.  No assertion here or in the successor theorems concerns
repeated essential trees, a nonproper high center, isolated base schemes,
or other cluster rows.

The local six-jet bounds used below are proved, including every rank
boundary, in
[`k2_profile327_one_nonproper_singleton_exclusion.md`](k2_profile327_one_nonproper_singleton_exclusion.md).

## 1. Adjoint data and notation

Write \(p\) for the proper high center.  A proper low singleton has plane
branch multiplicity at least four.  For a nonproper singleton write

\[
a<q.
\tag{1.1}
\]

The minimal-essential calculation gives

\[
(r_a,r_q)=(3,4),\qquad (m_a,m_q)=(3,3).
\tag{1.2}
\]

Its cubic-adjoint ideal pushes down to \(\mathfrak m_a\), so the cubic
adjoint cluster is always

\[
D=2p+z_1+\cdots+z_7,
\tag{1.3}
\]

where the \(z_i\) are the seven distinct proper origins.  It has colength
ten.  Rationality gives \(H^0(\mathcal J_D(3))=0\), hence cubic evaluation
is an isomorphism.  Deleting any low label \(i\) selects a unique
projective cubic \(C_i\), double at \(p\), through the other six origins,
and avoiding \(z_i\).

Suppose that \(C_i\) is integral and that exactly \(s\) of its six selected
low origins are nonproper.  If \(C_i\) follows a marked tangent at any one
of those origins, its marked contact increases by three.  In every row
used below this either forces \(C_i\) to be a branch component or gives a
strictly smaller incidence.  The worst row is therefore the one in which
\(C_i\) is smooth and transverse to every selected marked tangent.

In that row the visible contact on the normalization of \(C_i\) is

\[
2\cdot6+(6-s)\cdot4+s\cdot3=36-s.
\tag{1.4}
\]

The allowed determinant targets form a vector space of dimension at most
\(1+s\).  The zero target would make the integral cubic a branch component,
which is already absent on the base-point-free locus by the degree-three
factor theorem in
[`k2_double_dodecic_frontier.md`](k2_double_dodecic_frontier.md).  A fixed
nonzero determinant fiber has dimension at most
twenty-three, so the remaining bad part of the fifty-four-dimensional
cubic restriction image has dimension at most \(24+s\).  Its fixed
codimension is therefore

\[
\boxed{54-(24+s)=30-s.}
\tag{1.5}
\]

## 2. The two omitted-nonproper cubics when \(n=2\)

Assume \(n=2\), and omit one of the two nonproper labels.  Then \(s=1\),
so (1.5) gives fixed cubic codimension twenty-nine.  Forget the marked
tangent direction of the selected nonproper singleton, but retain its
proper origin.  This enlarges the incidence and leaves the following
moving data:

\[
\begin{array}{c|c}
\text{data}&\text{dimension}\\ \hline
p,\text{ five proper low origins, selected nonproper origin}&14\\
\text{omitted nonproper origin and its marked direction}&3\\
\sigma&17.
\end{array}
\tag{2.1}
\]

Thus the moving dimension is thirty-four.  The omitted origin is outside
\(C_i\), and its marked line has branch contact at least six.  The outside-
cubic six-jet lemma adds codimension six when that line is balanced.  The
margin is

\[
29+6-34=1.
\tag{2.2}
\]

When the marked line is unbalanced, the six-jet contribution drops to
five, but unbalancedness costs one parameter in the joint
\((\sigma,T)\)-space.  The margin remains

\[
29+5-33=1.
\tag{2.3}
\]

The calculation applies to either nonproper label.  Hence both deleted
cubics which omit a nonproper label are nonintegral for a general equation.
No simultaneous multijet assertion is used.

## 3. Why this note's original count leaves \(n=3\) open

If \(n=3\) and a nonproper label is omitted, then \(s=2\), so the fixed
cubic codimension is twenty-eight.  Forget both selected marked tangent
directions.  The retained origins, the omitted marked direction, and
\(\sigma\) move in dimension thirty-four in the balanced row and thirty-
three in the unbalanced row.  The outside-cubic lemma gives respectively

\[
28+6-34=0,
\qquad
28+5-33=0.
\tag{3.1}
\]

Thus the direct one-line argument is exactly borderline.

More generally, omit a proper low label and forget that omitted point.
The selected data \(p,z_1,\ldots,z_6\), their \(s\) marked tangent
directions, and \(\sigma\) move in dimension

\[
14+s+17-e=31+s-e,
\tag{3.2}
\]

where \(e\) is the actual codimension of the joint unbalanced-line
condition in the moving \((\sigma,T_1,\ldots,T_s)\)-space.  If the marked
lines are distinct and their jumping conditions are independent, then
\(e=j\), the number of unbalanced lines.  Coincident lines or dependent
jumping conditions may instead give \(e<j\).  Combining (1.5) with a
putative simultaneous tangent codimension \(c_s\) gives margin

\[
(30-s+c_s)-(31+s-e)=c_s-(2s+1-e).
\tag{3.3}
\]

Strictness therefore requires (0.1).  In particular,

\[
\begin{array}{c|c|c}
s&\text{required joint codimension}&
\text{formal sum of separate bounds when }j\text{ lines are unbalanced}\\ \hline
2&6-e&8-j\\
3&8-e&12-j.
\end{array}
\tag{3.4}
\]

The numerical slack is real, but it is not a proof of additivity.  The
extension space is the single eighteen-dimensional space

\[
H^0(\mathcal Q_2(-3)),
\tag{3.5}
\]

and restrictions at different marked lines are coupled.  Coincident
lines, a marked origin lying on another marked line, and dependent rank-one
determinant boundaries must be stratified before (3.4) can be used.  This
is the exact missing multijet statement.

## 4. Exact block weights

Give a proper low origin weight \(4\) and a nonproper low origin its visible
plane weight \(3\).  For a block

\[
P_{ab}:\ p,z_a,z_b\text{ collinear},
\tag{4.1}
\]

the marked line contact is

\[
6+w_a+w_b.
\tag{4.2}
\]

It exceeds twelve, and hence forces a branch line, unless both labels are
nonproper and the line is transverse to both marked directions.  In that
worst row it is exactly twelve; for fixed marked points the determinant
target has vector dimension one.  Following either marked direction adds
the next infinitely-near multiplicity and makes the line forced.

For an integral block conic

\[
Q_{ab}:\ p\text{ and the five origins outside }\{a,b\}
\text{ lie on a conic},
\tag{4.3}
\]

let \(u\) be the number of selected nonproper origins.  In the worst row,
where the conic is transverse to their marked directions, its marked
contact and fixed-point target dimension are

\[
R_Q=6+4(5-u)+3u=26-u,
\qquad
\tau_Q=\max(25-R_Q,0)=\max(u-1,0).
\tag{4.4}
\]

Thus the exact table is

\[
\begin{array}{c|c|c|c}
u&0&1&2&3\\ \hline
R_Q&26&25&24&23\\
\tau_Q&0&0&1&2.
\end{array}
\tag{4.5}
\]

If the conic follows even one selected marked direction, its contact rises
by three.  The nonzero-target rows \(u=2,3\) cannot be fed directly into the
low-degree factor-pair theorem: when the marked points move, the root
divisor moves as well.  Merely subtracting \(\tau_Q\) from a fixed-curve
margin would undercount the incidence.

## 5. Repeated support and the two exact \(n=3\) alignments

Suppose two distinct \(P\)-blocks have the same supporting line.  That
line contains \(p\) and at least three distinct low origins.  If \(u\) of
three such origins are nonproper, then after subtracting the forced line
once, the residual degree-eleven curve has contact at least

\[
5+2u+3(3-u)=14-u.
\tag{5.1}
\]

For \(n=2\), this is at least twelve and forces the line a second time.
For \(n=3\), it is still at least twelve unless \(u=3\).  The unique
squarefree-compatible boundary is therefore

\[
\boxed{p,a_1,a_2,a_3\text{ collinear, with no proper low origin on that line},}
\tag{5.2}
\]

where the \(a_i\) are precisely the three nonproper origins and the line is
transverse to all three marked directions.  The original contact is fifteen
and the residual contact is exactly eleven, so the two-pass argument is
genuinely sharp there.  If the line follows a marked direction, the
infinitely-near residual contact makes the inequality strict and forces a
second copy.

Now suppose two distinct integral \(Q\)-blocks have the same supporting
conic.  Their two five-label sets have union of size at least six.  After
subtracting the forced conic once, a conic containing \(p\), \(v\) low
origins, and \(u\) of the nonproper origins has residual contact at least

\[
5+2u+3(v-u)=5+3v-u.
\tag{5.3}
\]

For \(v=6\), this exceeds twenty unless \(u=3\), when it equals twenty.
For \(v=7\) it again exceeds twenty.  Hence the unique squarefree-
compatible repeated integral-conic support is

\[
\boxed{Q\supset p,a_1,a_2,a_3\text{ and exactly three proper low origins},}
\tag{5.4}
\]

with \(Q\) transverse to all three marked directions.  This boundary also
has exact residual contact twenty.  Tangency to any marked direction makes
the residual inequality strict.  Reducible block conics may share only one
component, and require a separate componentwise analysis; (5.4) is asserted
only for a repeated integral conic.

## 6. The exact common-support frontier when \(n=2\)

Write the nonproper labels as \(N_1,N_2\) and the proper low labels as
\(P_1,\ldots,P_5\).  By Section 2 the two cubics \(C_{N_1},C_{N_2}\)
are nonintegral.  We first show that each supplies an integral branch
component of degree at most two.

Fix \(i\), so the selected lows on \(C_{N_i}\) are the five \(P\)'s and
the other nonproper origin.  If

\[
C_{N_i}=L\cup Q
\tag{6.1}
\]

with \(Q\) integral, both factors pass through \(p\).  If \(L\) contains
two selected lows, their pair contains at most one nonproper origin, so
the line contact is at least thirteen and \(L\mid B\).  If \(L\) contains
at most one selected low, then \(Q\) contains at least five; at most one is
nonproper, so its contact is at least twenty-five and \(Q\mid B\).

If \(C_{N_i}\) is three distinct lines, at least two pass through \(p\).
If one of those contains two selected lows it is a branch line by the same
estimate.  Otherwise the third line contains at least four selected lows,
so its contact is at least

\[
3+3\cdot4=15>12
\tag{6.2}
\]

and it is a branch line.

Finally suppose \(C_{N_i}=2L+M\).  The doubled line \(L\) passes through
\(p\).  It cannot contain three selected lows: after subtracting its
forced branch copy, even the worst selected triple gives residual contact

\[
5+2+2\cdot3=13>11.
\tag{6.3}
\]

If \(L\) contains at most one selected low, then \(M\) contains at least
five and is likewise forced twice.  Hence the only squarefree-compatible
distribution has two lows on \(L\) and the other four on \(M\).  The pair
on \(L\) contains at most one nonproper origin, so \(L\mid B\); the four
on \(M\) have total contact at least fifteen, so \(M\mid B\).  This gives
two distinct branch lines and is excluded by the low-degree factor-pair
theorem.  A triple line is still more restrictive.  Thus a survivor has a
reduced factorization and at least one integral degree-one or degree-two
branch factor arising from it.

Apply this to both \(C_{N_1}\) and \(C_{N_2}\).  If the supplied branch
factors are distinct, the factor-pair theorem excludes them.  Therefore a
survivor has a single common support \(H\).  Moreover, because
\(H\mid C_{N_i}\) and \(C_{N_i}\) avoids its omitted origin, the common
support contains neither \(N_1\) nor \(N_2\).

If \(H\) is a line through \(p\), it contains at least two selected lows in
each cubic.  Indeed, in a line--integral-conic factorization a line through
\(p\) carrying at most one selected low leaves an integral conic through at
least five selected lows, which is a distinct branch component by the
argument in lines (6.1)--(6.2).  In a three-line factorization, if this
\(p\)-line carries at most one low, either the other \(p\)-line carries two
and is a distinct branch component, or both \(p\)-lines carry at most one
and the third line carries at least four, again supplying a distinct branch
component.  On the other hand, squarefreeness permits \(H\) to contain at
most two low origins: with three, the residual contact is at least twelve
because only two lows in the entire profile are nonproper.  Thus it contains
exactly two, and the preceding omitted-origin observation makes both proper.
Therefore

\[
\boxed{C_{N_1}=LQ_1,\quad C_{N_2}=LQ_2,\quad
L\supset p,P_a,P_b.}
\tag{6.4}
\]

A common line not through \(p\) occurs only in a three-line factorization,
whose other two lines pass through \(p\).  Each of those two lines contains
at most one selected low, since otherwise it is a distinct branch component.
Hence the common line contains at least four selected lows in each cubic.
The omitted-origin observation makes them proper.  Four common proper lows
already give residual contact twelve, contradicting squarefreeness.  Hence
(6.4) is the only common-line row.

If \(H\) is an integral conic, its residual line passes through \(p\) and
contains at most one selected low, since two would make it a distinct branch
line.  Thus \(H\) contains \(p\) and at least five selected lows for each
cubic.  It contains neither omitted nonproper origin, so those five lows are
exactly \(P_1,\ldots,P_5\).  Equivalently, if the two five-sets were
different, their union would contain at least six lows.  With at most two
nonproper lows, the residual contact after subtracting the conic would be at least

\[
5+2\cdot2+4\cdot3=21>20,
\tag{6.5}
\]

forcing \(H\) a second time.  Thus

\[
\boxed{C_{N_1}=QL_1,\quad C_{N_2}=QL_2,\quad
Q\supset p,P_1,\ldots,P_5.}
\tag{6.6}
\]

These two common-support rows are not excluded here.  They are the exact
\(n=2\) alignment frontier left after the two omitted-nonproper cubics and
the low-degree factor-pair theorem are used.

> **Subsequent closure.**  The two-line jet theorem in
> [`k2_profile327_n2_common_support_jet_reduction.md`](k2_profile327_n2_common_support_jet_reduction.md)
> excludes either selected pair when its residual component is integral and
> the selected form has rank one.  In the common-conic row this leaves rank
> zero at both nonproper origins.  In the common-line row the exact remaining
> complement is
>
> \[
> (R_1\text{ reducible or }\operatorname {rk}q(a_2)=0)
> \quad\text{and}\quad
> (R_2\text{ reducible or }\operatorname {rk}q(a_1)=0).
> \]
>
> The residual-boundary theorem in
> [`k2_profile327_n2_residual_boundary_exclusion.md`](k2_profile327_n2_residual_boundary_exclusion.md)
> excludes this entire complement, including the mixed mismatches.  Thus the
> full \(n=2\) row is absent.
>
> For \(n=3\), the fixed-fiber repair in
> [`k2_profile327_n3_simultaneous_jet_frontier.md`](k2_profile327_n3_simultaneous_jet_frontier.md)
> excludes all seven integral deleted-adjoint cubics.  The remaining
> nonintegral-cubic block combinatorics are excluded in
> [`k2_profile327_n3_nonintegral_block_exclusion.md`](k2_profile327_n3_nonintegral_block_exclusion.md).
> Thus the full \(n=3\) row is absent as well.  Together with the prior
> all-proper and exactly-one-nonproper exclusions, this closes the entire
> proper-high seven-distinct-singleton \([3,2^7]\) row.

The incidence margins, the simultaneous-jet thresholds, the weak-block
table, the residual contacts, and the common-support inequalities are
replayed by
[`k2_profile327_multiple_nonproper_checks.py`](k2_profile327_multiple_nonproper_checks.py).
