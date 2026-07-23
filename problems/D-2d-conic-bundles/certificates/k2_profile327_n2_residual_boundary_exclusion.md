# Closing the \(n=2\) common-support boundary

## Verdict and scope

Continue with the proper-high, seven-singleton \([3,2^7]\) stratum and
the notation of
[`k2_profile327_multiple_nonproper_frontier.md`](k2_profile327_multiple_nonproper_frontier.md)
and
[`k2_profile327_n2_common_support_jet_reduction.md`](k2_profile327_n2_common_support_jet_reduction.md).
There are exactly two nonproper singleton trees, with origins
\(a_1,a_2\) and marked tangent lines \(T_1,T_2\).  This note proves that
neither common-support alignment left by those certificates occurs for a
general base-point-free equation.  Consequently the entire \(n=2\)
singleton stratum is absent.

More precisely, the two previously uncovered sets were

\[
(R_1\text{ reducible or }\operatorname {rk}q(a_2)=0)
\quad\text{and}\quad
(R_2\text{ reducible or }\operatorname {rk}q(a_1)=0)
\tag{0.1}
\]

in the common-line alignment, and

\[
\operatorname {rk}q(a_1)=\operatorname {rk}q(a_2)=0
\tag{0.2}
\]

in the common-conic alignment.  Two new estimates close these sets.

1. If both values of the restricted binary form are zero, the outside
   six-jet costs \(7\) conditions on a balanced line and \(6\) on an
   unbalanced line.  The selected rank-zero constant-matrix problem has
   effective codimension at least three after splitting, ramification,
   and cross-incidence strata are included.  Together with the fixed
   codimension twenty-five from the preceding certificate, the incidence
   margin is one.
2. If a residual conic \(R_i\) is reducible, elementary contact
   combinatorics leaves only one three-line distribution.  Its fixed
   restriction has effective codimension twenty-five, and its reducibility
   costs one configuration parameter.  The selected rank-one lemma from
   the preceding certificate, or the rank-zero lemma proved here, then
   gives margin at least one.

Thus the mixed mismatches in (0.1) are closed as well; it is not necessary
to assume that both residual conics are reducible.  This note makes no
claim about \(n=3\), repeated essential trees, a nonproper high center, or
isolated base schemes.

We work over the characteristic-zero ground field of the problem.

## 1. An outside rank-zero six-jet

Put \(R_6=k[t]/(t^6)\), and let \(U_d\subset R_6\) be the image of
polynomials of degree at most \(d\).  At a point outside the selected
cubic, the two extension spaces on the marked line are

\[
U_3^3
\quad\text{and}\quad
R_6\oplus U_3\oplus U_1
\tag{1.1}
\]

in the balanced and unbalanced cases.  Suppose that the resulting binary
form \((a,b,c)\) has value zero at \(t=0\).  Factoring one \(t\) from
every entry turns the determinant-six condition into

\[
a'c'-(b')^2=0\pmod {t^4}.
\tag{1.2}
\]

The extension space is affine, so the factored balanced entries are
actually

\[
U_2+\alpha t^3\pmod {t^4}
\tag{1.2a}
\]

for three fixed tail coefficients; coefficients in order four do not
enter (1.2).  Write \(s=\operatorname {ord}(c')\) modulo \(t^4\).  This
gives a direct audit uniform in all three fixed tails.  If \(s=0\), the
first three determinant coefficients solve successively for
\(a'_0,a'_1,a'_2\).  Prescribing the fixed coefficient \(a'_3\) leaves a
genuinely nonzero fourth equation in the six lower coefficients of
\((b',c')\): after specializing
\(c'_0=1,c'_1=c'_2=b'_0=0\), that equation contains
\(a'_3-2b'_1b'_2\).  Hence this stratum has dimension at most five.

If \(s\ge1\), the constant equation gives \(b'_0=0\).  For
\(s=1\), the next three equations solve successively for
\(a'_0,a'_1,a'_2\), leaving dimension four.  For \(s=2\), they solve for
\(a'_0,a'_1\), while \(a'_2\) is free, again leaving dimension four.  For
\(s=3\), they force \(b'_1=a'_0=0\), leaving dimension three.  Finally,
if \(c'=0\pmod {t^4}\), then \(b'_0=b'_1=0\), leaving dimension four.
Thus every affine-tail fiber in the nine-dimensional variable space has
dimension at most five.

In the unbalanced case the first factored entry is unrestricted in its
five relevant coefficients, the middle entry has three variable
coefficients and fixed positive-degree tails, and the last has one
variable constant coefficient and fixed positive-degree tails.  Thus the
three affine spaces have dimensions

\[
(5,3,1).
\tag{1.3}
\]

With arbitrary tails let \(s\) be the order modulo \(t^4\) of the last
entry.  If \(s=0\), its multiplication map is invertible and determines
the first four coefficients of the first entry, leaving dimension five.
For \(s=1,2,3,4\), divisibility forces the middle entry to have order at
least \(\lceil s/2\rceil\), and the dimensions are bounded directly by

\[
(3-\lceil s/2\rceil)+s+1=4,5,5,6,
\tag{1.3a}
\]

where the last summand is the irrelevant fifth coefficient of the first
entry.  Thus the largest affine-tail boundary has dimension six.

The companion checker also exhausts the affine tails over \(\mathbf F_3\).
Across the \(27\) balanced tail triples its largest fiber has \(459\)
points, attained at zero tail; across the \(81\) unbalanced tail tuples
its largest fiber has \(891\) points, again attained at zero tail.  These
finite-field counts corroborate, but do not replace, the direct
characteristic-zero stratification above.

The value-zero condition itself fixes three affine constant coefficients.
Consequently, inside either twelve-dimensional space in (1.1), the joint
condition

\[
q(a)=0,\qquad \det(q|_T)=0\pmod {t^6}
\tag{1.4}
\]

has codimension at least

\[
\boxed{7\text{ on a balanced line},\qquad
6\text{ on an unbalanced line}.}
\tag{1.5}
\]

Unbalancedness costs one parameter, so (1.5) has effective codimension
seven in both splitting strata.  This is one more than the unrestricted
outside six-jet estimate.

## 2. The selected rank-zero constant-matrix lemma

Fix the restriction to a selected reduced cubic \(C\), then fix the bad
six-jet on the outside marked line \(T_1\).  As in the preceding
two-point certificate, the remaining freedom is

\[
\ell_1M,\qquad M\in\operatorname {Sym}^2k^3.
\tag{2.1}
\]

Suppose \(q(a_2)=0\), that \(C\) is smooth at \(a_2\), and that it meets
\(T_2\) transversely there.  Along \(T_2\), write the fixed form as
\(tS(t)\).  In the noncross case the remaining variation is
\(t u(t)M|_{\mathscr K}\); in the cross case
\(a_2\in T_1\), \(T_1\ne T_2\), it is
\(t^2u(t)M|_{\mathscr K}\).  Dividing by the unit \(u\) and by the common
factor \(t^2\) in the determinant, the required contact is

\[
\det(S+\rho(M))=0\pmod {t^4}
\tag{2.2}
\]

or, in the cross case,

\[
\det(S+t\rho(M))=0\pmod {t^4}.
\tag{2.3}
\]

If this affine fiber is nonempty, choose one solution \(M_0\), translate
\(M\mapsto M-M_0\), and absorb \(\rho(M_0)\), or \(t\rho(M_0)\) in the
cross case, into \(S\).  If it is empty there is nothing to bound.  Thus
we may and do take the fixed form itself to be a solution, so
\(\det S=0\pmod {t^4}\).

Here is the coefficient calculation, including the splitting boundary.
With

\[
M=\begin{pmatrix}A&B&C\\B&D&E\\C&E&F\end{pmatrix},
\tag{2.4}
\]

the three restrictions modulo \(t^4\) are

\[
\rho_{\rm bal}(M)=
\begin{pmatrix}
D-2Bt+At^2&E-Ct-Bt^2+At^3\\
E-Ct-Bt^2+At^3&F-2Ct^2
\end{pmatrix},
\tag{2.5}
\]

\[
\rho_{\rm unr}(M)=
\begin{pmatrix}
D-2Bt+At^2&E-Ct\\E-Ct&F
\end{pmatrix},
\tag{2.6}
\]

and, at a ramification point of the unbalanced degree-two map,

\[
\rho_{\rm ram}(M)=
\begin{pmatrix}
D-2Bt^2&E-Ct^2\\E-Ct^2&F
\end{pmatrix}.
\tag{2.7}
\]

Expanding the four determinant coefficients and splitting by the rank of
the leading binary matrix gives the following maximal fiber dimensions in
the six variables \(A,\ldots,F\):

\[
\begin{array}{c|c|c|c}
\rho&\text{variation}&\text{maximum dimension}&\text{codimension}\\ \hline
\rho_{\rm bal}&\rho(M)&3&3\\
\rho_{\rm bal}&t\rho(M)&4&2\\
\rho_{\rm unr}&\rho(M)&3&3\\
\rho_{\rm unr}&t\rho(M)&4&2\\
\rho_{\rm ram}&\rho(M)&4&2\\
\rho_{\rm ram}&t\rho(M)&5&1.
\end{array}
\tag{2.8}
\]

For completeness, the rank audit behind (2.8) is as follows.  In the
noncross rows the constant term of \(\rho(M)\) is the arbitrary symmetric
matrix with entries \(D,E,F\).  On the rank-zero leading stratum those
three variables are fixed, leaving at most \(A,B,C\).  On a rank-one
chart write the leading matrix as
\(h(1,r)^t(1,r)\).  Substitution in the next three determinant
coefficients leaves at most three free variables in (2.5)--(2.6), and at
most four in (2.7).  The potentially flat chart \(r=0\) is included:
for (2.5) its first nonzero equations have, after harmless affine
translations, the successive terms

\[
C(2h+C),\qquad 2BC,
\tag{2.9}
\]

while the condition \(r=0\) itself supplies the missing chart equation.
For (2.6), the same substitution uses the successive coefficients in
orders zero, one, and two, hence has the same maximum dimension three.
For (2.7), \(A\) is invisible modulo \(t^4\), which is exactly the one
additional free variable recorded in the table.  The other rank-one chart
is obtained by exchanging the two kernel generators.

In the cross rows the leading matrix is fixed.  If it has rank one, the
first varying determinant coefficient is a nonzero linear functional of
the arbitrary matrix \((D,E,F)\); the next coefficient gives the second
condition for (2.5)--(2.6).  If it has rank zero, divide by its first
common power of \(t\) and use the same two leading-rank charts.  This also
includes the completely flat translate \(S=0\): in that translate the
first two coefficients of \(\det\rho(M)\) give dimensions four for
(2.5)--(2.6), while (2.7) has only the leading determinant equation and
dimension five.  Thus no affine translate or flat leading chart is
omitted.  In the ramified row only the first condition remains before
order four, again exactly as displayed.

The companion checker exhausts all \(8{,}505\) determinant-zero matrices
over \(\mathbf F_3[t]/(t^4)\), and for each one enumerates all \(3^6\)
constant matrices in every row of (2.8).  The exact largest affine-fiber
counts are

\[
51,\ 135,\ 45,\ 135,\ 135,\ 243
\tag{2.9a}
\]

in the order displayed in (2.8), including the completely flat
translate.  This finite-field exhaustion corroborates the uniform
normal-form table but does not replace its characteristic-zero
coefficient proof.

It follows that a selected rank-zero point contributes at least three
effective conditions:

\[
\begin{array}{c|c|c|c}
T_2&\text{cross?}&\text{jet codimension}&
\text{parameter cost}\\ \hline
\text{balanced}&\text{no}&3&0\\
\text{balanced}&\text{yes}&2&1\\
\text{unbalanced, unramified}&\text{no}&3&0\\
\text{unbalanced, unramified}&\text{yes}&2&1\\
\text{unbalanced, ramified}&\text{no}&2&1\\
\text{unbalanced, ramified}&\text{yes}&1&2.
\end{array}
\tag{2.10}
\]

The last parameter column does not use the unbalanced-line condition: it
counts the cross-incidence in the unramified cross row, ramification in
the ramified noncross row, and ramification plus the cross-incidence in the
last row.  Thus the effective contribution three does not assume that a
marked-line splitting condition is independent of a component-line
splitting condition.  Coincident marked lines are already absent by the
extra-zero argument in the preceding certificate.

## 3. Two rank-zero origins are strictly excluded

Use either common-support cubic \(C=C_{N_1}\).  It contains \(a_2\),
avoids \(a_1\), and has fixed restriction codimension twenty-five.  If
both values of \(q\) are zero, Section 1 gives effective outside
codimension seven at \(a_1\), and Section 2 gives effective selected
codimension three at \(a_2\).  The common-support configuration and
quadratic triple move in the baseline dimension thirty-four of the
preceding certificate.  Hence

\[
25+7+3-34=\boxed1.
\tag{3.1}
\]

This includes both the common-conic boundary (0.2) and the both-rank-zero
part of the common-line boundary.  No condition is assigned to the local
flatness of the rank-zero form.

## 4. Reducible residual conics

Now use the common-line alignment

\[
C_{N_i}=L R_i,
\qquad L\supset p,P_1,P_2,
\tag{4.1}
\]

where \(L\) is the common branch line and contains neither nonproper
origin.  Fix \(i\), write \(a=a_{3-i}\), and suppose \(R_i\) is
reducible.  The residual conic passes through

\[
p,P_3,P_4,P_5,a.
\tag{4.2}
\]

A double residual line contains all five points and has branch contact at
least

\[
6+3\cdot4+3=21>12;
\tag{4.3}
\]

it is a second branch line and is absent by the low-degree factor-pair
theorem.  Write a reduced residual as \(R_i=U\cup V\).  If both lines
pass through \(p\), avoiding a branch line permits at most one selected
low origin on each, which cannot cover the four lows in (4.2).  Thus
exactly one, say \(U\), passes through \(p\).

The \(p\)-line \(U\) again contains at most one selected low.  Therefore
\(V\) contains at least three.  Its intersection with the already-branch
line \(L\) supplies one further determinant zero.  If a selected low lay
at \(U\cap V\), then \(U\) could contain no other low and \(V\) would
contain all four, forcing \(V\).  Hence the selected lows are disjointly
distributed.  The only weight at most twelve on \(V\) is

\[
4+4+3+1=12.
\tag{4.4}
\]

Consequently every unforced reducible row has, after relabeling,

\[
\boxed{U=\overline{pP_3},\qquad
V=\overline{P_4P_5},\qquad a\in V.}
\tag{4.5}
\]

The collinearity in (4.5) costs one parameter beyond the common-line
alignment.  If \(V=T_{3-i}\), its contact uses the infinitely-near
multiplicity as well and exceeds twelve, so the selected intersection is
transverse.

We next bound the restriction to the three-line cubic \(L\cup U\cup V\).
The determinant target on \(L\) is zero.  The visible contacts on \(U,V\)
are ten and twelve, so their target dimensions are three and one.  At the
third node \(r=U\cap V\), which is distinct from all prescribed roots,
the two determinants must agree.  The one-dimensional target on \(V\)
does not vanish at \(r\), and evaluation of the three-dimensional target
on \(U\) is onto.  Thus determinant gluing cuts one condition, and the
joint target dimension is

\[
3+1-1=3.
\tag{4.6}
\]

Let \(j\) of the three component lines be unbalanced.  The fixed
determinant fibers have dimensions eight on a balanced line and nine on
an unbalanced line.  Ignoring all matrix gluing only enlarges the locus,
so its dimension in the fifty-four-dimensional cubic restriction image is
at most

\[
(24+j)+3=27+j.
\tag{4.7}
\]

The fixed codimension is therefore \(27-j\).  For \(j\le2\) this is at
least twenty-five.  If \(j=3\), the fixed codimension is twenty-four, but
requiring the three prescribed distinct lines all to be unbalanced lies
inside the proper unbalanced-line equation for any one of them and hence
costs at least one parameter in the quadratic-triple space.  Thus (4.7)
has **effective fixed codimension at least twenty-five in every splitting
stratum**.

There is no hidden additivity assumption when the outside marked line is
also unbalanced.  It is distinct from \(L,U,V\), because its marked origin
is outside the selected cubic.  For any two distinct prescribed lines
\(H,T\), their unbalanced conditions are independent on the rank-two
open set.  Indeed, after fixing a rank-two restriction on \(H\), add
\(\ell_H\) times arbitrary linear forms to the three quadrics.  This
preserves the restriction on \(H\).  On \(T\), the variations give three
copies of the two-dimensional space of quadratics vanishing at
\(H\cap T\).  Base-point-freeness gives a nonzero value there, and after
a target change two variations complete that value to a basis of
\(H^0(O_T(2))\).  Hence \(T\) is balanced somewhere on the irreducible
rank-two unbalanced divisor for \(H\).  In particular the all-three-
component-unbalanced condition and outside unbalancedness cost at least
two parameters jointly.

The common-line baseline has moving dimension thirty-four; (4.5) lowers it
to thirty-three.  Separate the two selected ranks so that no splitting
condition is borrowed twice.

In selected rank zero, the cubic restriction together with the outside
jet has joint effective codimension at least \(25+6=31\).  For \(j\le2\)
this follows directly from (4.7), with the outside unbalanced divisor
paying for its own one-dimensional jet loss.  For \(j=3\) and a balanced
outside line, any one component unbalanced divisor pays for the cubic
loss.  For \(j=3\) and an unbalanced outside line, the independent pair
of component and outside conditions proved above pays for both losses.
Section 2 then adds effective codimension three, so

\[
(25+6)+3-33=\boxed1.
\tag{4.8a}
\]

This remains safe in the ramified selected rows.  Ramification has
codimension one inside the unbalanced selected-line locus; in the only
row needing three simultaneous parameter conditions, the preceding
two-point theorem proves that outside unbalancedness remains independent
on the ramified-unbalanced selected-line locus.  Those three marked-line
conditions can pay for all three raw losses, leaving the component-line
condition unused.  Cross-incidence lowers the moving configuration
dimension directly.

In selected rank one, ignore every component-line parameter saving and use
the raw all-unbalanced cubic codimension twenty-four.  The rank-one
constant-matrix lemma and marked-line independence argument in the
preceding certificate give the outside and selected marked conditions joint
effective contribution \(6+4\), including every unbalanced,
ramified-flat, and cross row.  Hence independently

\[
24+(6+4)-33=\boxed1.
\tag{4.8b}
\]

This proves that a reducible residual \(R_i\) is absent, independently of
the rank of \(q(a_{3-i})\) and independently of the other residual conic.

## 5. Exhaustion of the old complement

In the common-conic alignment both residual components are lines.  The
preceding two-point theorem excludes the row unless both values of \(q\)
are zero, and Section 3 excludes that last row.

In the common-line alignment, if some \(R_i\) is reducible, Section 4
excludes the equation.  If both \(R_i\) are integral, the preceding
two-point theorem excludes the equation unless both cross-values of
\(q\) are zero, and Section 3 again excludes the remaining row.  This
exhausts (0.1), including both mixed mismatches.

The local dimensions, contact distribution, three-line restriction bound,
and all effective margins are replayed by
[`k2_profile327_n2_residual_boundary_checks.py`](k2_profile327_n2_residual_boundary_checks.py).
