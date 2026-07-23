# One nonproper singleton in the \([3^2,2^4]\) profile

## Statement and scope

Let \(\sigma\) be a base-point-free quadratic triple and let
\(B=\sigma^t\operatorname {adj}(A)\sigma\) be the reduced degree-twelve
branch of a general bidegree-\((2,4)\) equation.  There is no rational
squarefree branch with profile

\[
\boxed{[3,3,2,2,2,2]}
\tag{0.1}
\]

when the four \(t=2\) centers lie in four distinct singleton
proper-origin trees and exactly one of them is nonproper.  The two
\(t=3\) centers may be either the two distinct proper centers or the
proper/free-first-near pair allowed by the exact high-subcluster
classification.

Together with the all-proper theorem, a base-point-free survivor in the
four-singleton partition would therefore need at least two nonproper
singleton trees.  Repeated low essential trees, two or more nonproper
singletons, and isolated-base triples are not treated here.

We use the six-jet lemmas proved in
[`k2_profile327_one_nonproper_singleton_exclusion.md`](k2_profile327_one_nonproper_singleton_exclusion.md).

## 1. Adjoint cubics and the four residual conics

Denote the high centers by \(v_1,v_2\), the three proper low centers by
\(P_1,P_2,P_3\), and the nonproper singleton by

\[
a<q,\qquad (r_a,r_q)=(3,4),\qquad(m_a,m_q)=(3,3).
\tag{1.1}
\]

The adjoint weight at \(q\) pushes down to the simple proper-origin
condition at \(a\).  Thus

\[
D=2v_1+2v_2+P_1+P_2+P_3+a
\tag{1.2}
\]

has exact colength ten, and cubic evaluation is an isomorphism.  Deleting
any low label \(i\) gives a unique cubic \(C_i\), and its omitted origin
does not lie on it.

The four-dimensional cubic system through \(2v_1+2v_2\) has exactly the
dichotomy proved in
[`k2_remaining_all_proper_adjoint_reduction.md`](k2_remaining_all_proper_adjoint_reduction.md).

1. If \(v_1=p,v_2=p'\) are distinct proper points, put
   \(L=\overline {pp'}\).  Every \(C_i\) is
   \(L\cup Q_i\), where \(Q_i\) is the conic through \(p,p'\) and the
   other three low origins.
2. If \(v_2\) is the free first-near point over \(v_1=p\) in direction
   \(L\), every cubic contains \(L\), and every residual \(Q_i\) is
   tangent to \(L\) at \(p\).  Every reducible such \(Q_i\) contains
   \(L\).

In either case the selected line has branch contact at least twelve.  An
integral \(Q_i\) has high-center contact at least twelve as well.  Its
three low-origin contributions are four for a proper singleton and three
for the nonproper singleton unless its strict transform follows the marked
direction \(T\), in which case that contribution is six.

## 2. Integral residual conics

Suppose first that the nonproper label is omitted.  Then \(Q_q\) passes
through the three proper low centers and has contact

\[
12+3\cdot4=24.
\tag{2.1}
\]

On the reduced cubic \(L\cup Q_q\), restriction has image dimension
fifty-four.  The line bad dimension is at most ten and the integral-conic
bad dimension at most eighteen, so the fixed codimension is at least

\[
54-(10+18)=26.
\tag{2.2}
\]

The omitted tangent line \(T\) has contact six and is disjoint from the
selected cubic at its marked origin.  The outside-cubic six-jet lemma adds
at least five conditions.  In the proper/proper high row the selected
centers move in dimension ten; the omitted origin and direction move in
dimension three.  Hence even the uniform worst margin is

\[
(26+5)-(10+3+17)=1.
\tag{2.3}
\]

The free-first-near high row has one fewer parameter and is stronger.

Now omit a proper low label, so that \(Q_i\) contains \(a\), two proper
low origins, and the two high paths.  If \(Q_i\) is transverse to \(T\),
its visible contact is

\[
12+2\cdot4+3=23.
\tag{2.4}
\]

Its determinant target has dimension two.  The line-plus-conic fixed
codimension is therefore at least

\[
54-(10+(17+2))=25.
\tag{2.5}
\]

The transverse six-jet lemma adds four in the balanced case and three in
the unbalanced case.  Unbalancedness of the marked line costs one parameter
in the joint \((\sigma,T)\)-space.  Forgetting the omitted proper low
center, the proper/proper margins are

\[
25+4-(10+1+17)=1,
\qquad
25+3-(10+1+16)=1.
\tag{2.6}
\]

Again the free-first-near high row improves both margins by one.

If \(Q_i\) follows \(T\), its contact is at least
\(12+8+6=26>24\), so it is a conic branch component.  The line target has
dimension at most ten and the conic zero fiber at most seventeen, giving
fixed codimension twenty-seven.  The omitted proper center is outside
\(L\cup Q_i\); the standard four-jet lemma contributes four conditions,
or on the all-unbalanced pencil stratum one forgets that condition and uses
the fifteen-dimensional \((\sigma,z)\)-bound.  The two margins are

\[
(27+4)-(10+2+17)=2,
\qquad
27-(10+15)=2.
\tag{2.7}
\]

Here the tangent direction is determined by \(Q_i\), so it costs no
additional parameter.  This excludes every integral \(Q_i\).

## 3. Four split residual conics force two branch lines

All four \(Q_i\) are now reducible.  A nonreduced residual conic would be
\(2L\); its three selected low origins on \(L\), together with the high
contact, would force \(L^2\mid B\).  Thus every \(Q_i\) is a union of two
distinct lines.

In the proper/proper high row, a \(Q_i\) which does not contain \(L\)
has one component through each high point.  One component contains two of
the three selected low origins.  Since at most one is nonproper, that line
has contact at least

\[
6+4+3=13>12
\tag{3.1}
\]

and is a branch component.  In the free-first-near row every reducible
\(Q_i\) contains \(L\); its other component contains the three selected
low origins.  If those are all proper it has contact twelve; if one is
nonproper it has contact eleven.  The complementary-triple argument below
therefore first forces an integral \(Q_i\), already excluded in Section 2.
So the free-first-near row is closed.

It remains to finish the proper/proper row.  Not all four \(Q_i\) contain
\(L\), because otherwise every complementary triple of the four low
origins would be collinear, and then the omitted origin would lie on
\(C_i\).  Suppose only one branch line \(M\ne L\) arose from all the
non-\(L\) conics.  It passes through one fixed high point and a fixed pair
of low origins, so it can occur only for the two omitted labels outside
that pair.  For the two labels in the pair, the corresponding conics would
then have to be of type \(L\cup N_i\).  Their complementary triples share
the other two low origins; hence their two lines \(N_i\) coincide and all
four low origins are collinear.  This again puts an omitted origin on its
deleted cubic, a contradiction.

Thus at least two distinct lines different from \(L\) are branch
components.  Section 7 of
[`k2_remaining_all_proper_adjoint_reduction.md`](k2_remaining_all_proper_adjoint_reduction.md)
excludes two distinct branch lines for a general base-point-free equation.
This proves the theorem.

The contacts, jet margins, and split-conic combinatorics are replayed by
[`k2_profile3324_one_nonproper_singleton_checks.py`](k2_profile3324_one_nonproper_singleton_checks.py).
