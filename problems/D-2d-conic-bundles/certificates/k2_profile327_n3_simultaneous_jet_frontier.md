# Simultaneous jets and the fixed-fiber repair for \(n=3\)

## Verdict and exact boundary

Continue with the proper-high, seven-distinct-singleton \([3,2^7]\)
stratum of
[`k2_profile327_multiple_nonproper_frontier.md`](k2_profile327_multiple_nonproper_frontier.md).
Assume that exactly three low singleton trees are nonproper, with proper
origins \(a_1,a_2,a_3\) and marked tangent lines \(T_1,T_2,T_3\).
This note proves the following reduction for integral deleted-adjoint
cubics.

1. Every integral cubic obtained by deleting a nonproper label is absent.
   After the outside six-jet is fixed, only one of the two selected marked
   lines is needed: its constant-matrix condition has effective
   codimension at least three, giving strict margin one.
2. For two selected marked points, the required joint bound \(6-e\) is
   always satisfied, including all rank, splitting, ramification, cross,
   and coincident-line strata.
3. For three selected marked points, the required joint bound \(8-e\) is
   satisfied unless all three restricted values have rank zero and the
   three marked lines are balanced, pairwise distinct, and free of every
   cross-incidence \(a_j\in T_i\), \(i\ne j\).
4. In that last row, the accepted local estimates give only seven
   conditions.  The missing condition is nevertheless present globally.
   A rank-zero value lowers the only twenty-three-dimensional boundary of
   the fixed nonzero integral-cubic determinant fiber to dimension
   twenty-two.  The fixed cubic codimension rises from twenty-seven to
   twenty-eight, and the seven local conditions then give strict margin
   one.

Consequently every integral deleted-adjoint cubic is absent when \(n=3\):

\[
\boxed{
\text{all seven deleted-adjoint cubics are nonintegral}.}
\tag{0.1}
\]

This does **not** exclude the full \(n=3\) stratum.  Its remaining
boundary is now purely the nonintegral-cubic block combinatorics described
in Sections 4--5 of the multiple-nonproper frontier note.  No assertion is
made about repeated essential trees, a nonproper high center, or isolated
base schemes.

## 1. The shared extension space

Fix an integral selected cubic \(C\), and put

\[
\mathcal E=\mathcal Q_2(-3).
\tag{1.1}
\]

The symmetrized presentation gives

\[
0\longrightarrow3O(-1)\longrightarrow6O(1)
\longrightarrow\mathcal E\longrightarrow0,
\qquad h^0(\mathcal E)=18.
\tag{1.2}
\]

Thus an extension difference is represented by a symmetric
\(3\times3\) matrix of linear forms.  Restriction to any marked line is
onto a twelve-dimensional space and has the exact six-dimensional kernel

\[
\ker\bigl(H^0(\mathcal E)\to H^0(\mathcal E|_{T_1})\bigr)
=\ell_1\operatorname {Sym}^2k^3.
\tag{1.3}
\]

For two distinct lines the joint restriction is injective: a matrix of
linear forms divisible by both \(\ell_1\) and \(\ell_2\) is zero.  Its
image has dimension eighteen inside the twenty-four-dimensional product;
equivalently, the two restrictions have a six-dimensional coupling, not
independent twelve-dimensional freedoms.

At a selected nonproper origin the cubic is smooth and transverse to the
marked line in the worst row.  The other cases either force the cubic as a
branch component or lower the moving incidence.  The accepted one-line
selected-jet bounds are

\[
\begin{array}{c|c|c}
\operatorname {rk}q(a)&T\text{ balanced}&T\text{ unbalanced}\\ \hline
1&4&3\\
0&4&4.
\end{array}
\tag{1.4}
\]

The rank-one row is the selected-point lemma in
[`k2_profile327_one_nonproper_singleton_exclusion.md`](k2_profile327_one_nonproper_singleton_exclusion.md);
the same coefficient audit there gives four in rank zero in both
splittings.

After the first marked-line restriction has been fixed, the remaining
variation is \(\ell_1M\), with \(M\) a constant symmetric matrix.  At a
second selected point not on \(T_1\), the accepted constant-matrix bounds
are

\[
\begin{array}{c|c|c|c}
\operatorname {rk}q(a_2)&T_2&\text{ordinary}&a_2\in T_1\\ \hline
1&\text{balanced}&4&3\\
1&\text{unbalanced, unramified}&3&2\\
1&\text{unbalanced, ramified-flat}&2&2\\
0&\text{balanced}&3&2\\
0&\text{unbalanced, unramified}&3&2\\
0&\text{unbalanced, ramified}&2&1.
\end{array}
\tag{1.5}
\]

For rank one this is Sections 2--3 of
[`k2_profile327_n2_common_support_jet_reduction.md`](k2_profile327_n2_common_support_jet_reduction.md).
For rank zero it is Section 2 of
[`k2_profile327_n2_residual_boundary_exclusion.md`](k2_profile327_n2_residual_boundary_exclusion.md).
Ramification costs one parameter inside the unbalanced locus.  A cross-
incidence \(a_2\in T_1\), with \(T_1\ne T_2\), also costs one parameter.
For two distinct marked lines their unbalanced divisors are independent,
including on the ramified locus, by the variation argument in the first
of those two-point certificates.

## 2. The two-line effective bound

Take two distinct selected lines.  If one selected value has rank zero,
put that line first.  By (1.4) its condition costs four in either
splitting.  If the second value has rank one, (1.5), together with its
unbalanced, ramification, or cross cost when needed, supplies effective
contribution four.  If the second value has rank zero, (1.5) supplies
effective contribution three without charging unbalancedness: the
unramified rows give three raw, while ramification or cross-incidence pays
for the one-condition drop.

If both selected values have rank one, use (1.4) followed by (1.5).
Every balanced line contributes four.  An unramified unbalanced line
loses one jet condition and contributes one independent splitting
condition.  The ramified-flat row loses one more and contributes
ramification; a cross row loses one and contributes the cross-incidence.

Let \(e_{12}\) be the actual codimension of the joint unbalanced-line
condition for this pair, and let \(d_{12}\) collect ramification and
cross-incidence costs not included in \(e_{12}\).  The resulting bound is

\[
c_{12}+d_{12}\ge
\begin{cases}
8-e_{12},&\text{unless both selected values have rank zero},\\
7,&\text{if both selected values have rank zero}.
\end{cases}
\tag{2.1}
\]

In the second row, if either line is unbalanced then \(e_{12}\ge1\), so
seven is again at least \(8-e_{12}\).  Therefore the only two-line loss
relative to the three-point target is a balanced rank-zero/rank-zero pair.

For the two-point target itself, the requirement from the incidence
ledger is only

\[
c_{12}\ge6-e_{12}.
\tag{2.2}
\]

Equation (2.1) is strictly stronger in every distinct-line row.

## 3. Coincident and cross lines

If \(T_1=T_2\), the two distinct origins determine their common line, so
both marked directions are fixed rather than moving.  This costs two
configuration parameters.  Keeping only one selected-line condition in
(1.4) gives

\[
4+2=6\quad\text{if the line is balanced},
\qquad
3+2=5=6-1\quad\text{in the worst unbalanced rank-one row}.
\tag{3.1}
\]

Thus (2.2) also holds for coincident lines.  If all three marked lines
coincide, the three origins must first be collinear and all three marked
directions are fixed.  The configuration cost is \(1+3=4\), and one
selected condition gives

\[
4+4=8\quad\text{in the balanced row},
\qquad
3+4=7=8-1\quad\text{in the worst unbalanced row}.
\tag{3.2}
\]

If exactly two of three lines coincide, use their common line and the
third line in (2.1); the unused coincidence cost only improves the bound.

For distinct lines a cross-incidence \(a_j\in T_i\) lowers the
constant-matrix contribution by at most one, exactly as in (1.5), and
costs one configuration parameter.  Two opposite cross-incidences force
the lines to coincide, which was just handled.  Hence cross rows never
worsen the effective bounds.

## 4. Deleting a nonproper label when \(n=3\)

Delete one nonproper label.  The integral cubic contains the other two
nonproper origins, so its fixed cubic-restriction codimension is

\[
30-2=28.
\tag{4.1}
\]

Retain all three marked directions.  The eight proper origins move in
dimension sixteen, the directions in dimension three, and the quadratic
triple in dimension seventeen, for total moving dimension

\[
16+3+17=36.
\tag{4.2}
\]

The omitted nonproper origin lies outside the cubic.  Its six-jet gives
effective codimension six: the raw bounds are six and five on balanced
and unbalanced lines, and unbalancedness costs one parameter.  After that
restriction is fixed, choose either selected marked line distinct from
the outside line.  By (1.5) its rank-one condition has effective
codimension at least four, and its rank-zero condition at least three.
The worst margin is therefore

\[
28+6+3-36=\boxed1.
\tag{4.3}
\]

If one selected line coincides with the outside line, use the other.  If
both do, all three lines coincide; the configuration cost four already
makes \(28+6\) strictly larger than \(36-4\).  Cross-incidences are paid
for as in Section 3.  Thus **every nonproper-label-deleted integral cubic
is absent**.

## 5. Deleting a proper label

Delete one proper low label and forget its point.  When \(s\) selected
nonproper origins remain, the fixed cubic codimension and moving dimension
are

\[
30-s,\qquad31+s-e.
\tag{5.1}
\]

For \(s=2\), (2.1)--(3.1) imply the required bound \(6-e\), with room to
spare.  For \(s=3\), strictness requires the bound \(8-e\).  If some
selected value has rank one, pair it with any other selected point and
order a rank-zero point first when available.  The first row of (2.1)
gives \(8-e_{12}\), and the total unbalanced codimension satisfies
\(e\ge e_{12}\): the locus on which all three prescribed lines are
unbalanced is a subset of the locus on which the chosen pair is
unbalanced, so this inequality uses no additivity assumption.  The third
tangent condition may be forgotten.

If all three values have rank zero but some marked line is unbalanced,
pair that line with any other.  The second row of (2.1) gives seven, while
\(e\ge1\), so again seven is at least \(8-e\).  Coincidence and cross
rows were closed in Section 3.  Hence the only row not covered by the
local jet ledger is the all-rank-zero, balanced, pairwise-distinct,
noncrossing row.

Outside that local row, the worst proper-deleted margin is

\[
(30-3)+(8-e)-(34-e)=\boxed1.
\tag{5.2}
\]

## 6. The local dependency

In the remaining local row, apply the full selected-line rank-zero bound four at
\(T_1\).  The fiber is the six-dimensional constant-matrix space.  The
balanced rank-zero condition at \(T_2\) has codimension three, leaving the
current total

\[
4+3=7,
\tag{6.1}
\]

exactly one below the required eight.

This loss is visible in the coefficient algebra, not just in the
bookkeeping.  On the completely flat affine translate \(S_2=0\) of the
balanced rank-zero equation

\[
\det(S_2+\rho_{T_2}(M))=0\pmod {t^4},
\tag{6.2}
\]

the maximal three-dimensional component contains the cone

\[
\{M\in\operatorname {Sym}^2k^3:\operatorname {rk}M\le1\}.
\tag{6.3}
\]

The cone in (6.3) has dimension three: it is the image of
\(v\mapsto vv^t\) from \(k^3\), with generically finite fibers in
characteristic zero.  The uniform balanced constant-matrix theorem bounds
the whole fiber in (6.2) by dimension three.  Hence this cone is itself a
maximal-dimensional irreducible component, rather than merely a smaller
subset of an unspecified component.

For every line \(T_3\), the restriction of such an \(M\) still has rank
at most one, so its determinant vanishes identically.  If the third
rank-zero affine translate is simultaneously flat, its condition is
automatic on (6.3).  Thus the accepted local lemmas cannot manufacture an
eighth equation merely by adding the third line.

This is a dependency in the local affine-jet model, not an assertion that
the simultaneous flat translates occur in the global fixed-cubic
restriction locus.  In particular, the third line alone cannot be used
to claim the missing eighth condition.

## 7. The fixed integral-cubic fiber supplies the eighth condition

The global fixed-cubic restriction count does supply the missing
condition.  Let \(\nu:\mathbf P^1\to C\) be the normalization.  The
accepted splitting calculation gives

\[
\nu^*\mathscr K^\vee
\simeq O_{\mathbf P^1}(\alpha)\oplus
O_{\mathbf P^1}(6-\alpha),
\qquad \alpha=1,2,3,
\tag{7.1}
\]

and the three entries of the restricted symmetric form have degrees

\[
(12+2\alpha,\ 18,\ 24-2\alpha).
\tag{7.2}
\]

Fix a nonzero determinant target \(f\).  The zero target is not an omitted
fiber case: it would make the integral
cubic \(C\) a component of the branch divisor, which is already excluded by
the degree-three factor margin cited in that proof.

Choose the lower-degree diagonal entry \(c\).  The complete nonzero-fiber
proof in
[k2_combined_proper_cluster_exclusion.md](k2_combined_proper_cluster_exclusion.md)
has two branches:

\[
\begin{array}{c|c}
c\ne0&\text{fiber dimension at most }20,\\
c=0&b^2=-f\text{ has finitely many solutions and the higher diagonal
entry is arbitrary.}
\end{array}
\tag{7.3}
\]

The second branch has dimension

\[
(24-2\alpha)+1=23,21,19
\tag{7.4}
\]

for \(\alpha=1,2,3\).  It is the only branch which can attain the uniform
bound twenty-three.

Now let \(a\) be any selected nonproper origin at which \(q(a)=0\).
Every allowed determinant target vanishes at \(a\), so on the
\(c=0\) branch the equation \(b^2=-f\) already gives \(b(a)=0\).
Rank zero then says exactly that the arbitrary higher diagonal entry also
vanishes at \(a\).  Evaluation at \(a\) is a nonzero linear functional on
\(H^0(O_{\mathbf P^1}(24-2\alpha))\), so this cuts (7.4) by one.  Hence

\[
\dim\{\det q=f,\ q(a)=0\}\le
\max(20,22)=22
\tag{7.5}
\]

for every fixed nonzero \(f\).  In the three-nonproper row the allowed
targets have vector dimension four.  The bad fixed-cubic restriction
locus therefore has dimension at most

\[
22+4=26
\tag{7.6}
\]

inside the fifty-four-dimensional cubic restriction image.  Its fixed
codimension is at least

\[
54-26=28,
\tag{7.7}
\]

one larger than the unrefined \(30-3=27\).

Apply (7.7) in the sole local boundary from Section 5.  Any two balanced
rank-zero selected lines give the seven conditions in (6.1), while the
moving dimension is thirty-four.  The final margin is

\[
28+7-34=\boxed1.
\tag{7.8}
\]

Thus the local flat-cone dependency is real but harmless globally, and
every proper-label-deleted integral cubic is absent as well.  Together
with Section 4 this proves (0.1).

The extension dimensions, two-line rank table, coincidence costs, and
all incidence and fixed-fiber margins are replayed by
[`k2_profile327_n3_simultaneous_jet_checks.py`](k2_profile327_n3_simultaneous_jet_checks.py).
