# The class-\((1,2)\) double-dodecic frontier

## Status and scope

Let

\[
X=(x^tA(y)x=0)\subset \mathbf P^2_x\times\mathbf P^2_y
\]

be a general hypersurface of bidegree \((2,4)\).  This note starts the
class-\((1,2)\) case of D4.  It gives the exact canonical-resolution
rationality table, including every square-factor row, and audits what the
existing determinant-incidence estimates do on the dominant open set of
base-point-free quadratic triples.  Section 7 records the subsequent
geometric reductions proved in the companion certificates.

The case is **not closed** here.  The exact conclusions are:

1. after removing its maximal square, the normalized Stein model is a
   connected double plane with reduced branch of degree \(12-2e\);
2. in the squarefree row, the anti-invariant bicanonical summand excludes
   the profile \([2^{10}]\), leaving six profiles arithmetically; subsequent
   geometry excludes \([5]\) and \([4,3,2]\), leaving four;
3. on the base-point-free quadratic-triple locus, the existing factor
   estimate excludes integral cubic and quartic branch components, but no
   complete square-factor row;
4. the two-line proper-multiplicity estimate has best moving margins at
   most seventeen, equal to the dimension of the quadratic-triple
   parameter space, and therefore excludes none of the remaining profiles;
5. a common line factor reduces exactly to the now-excluded \(k=1\) case,
   while a common conic factor reduces to the excluded \(k=0\) case; and
6. the base-point-free \([4,2^4]\) and \([3^3,2]\) profiles and every
   base-point-free square-factor row \(e=1,\ldots,5\) are absent, while the
   primitive isolated base schemes are now classified exactly, the
   primitive \(e=2\) and isolated-base \(e=3,4\) rows are absent, and the
   connected isolated-base integral-quintic square-root row is absent; and
7. the entire proper-high seven-distinct-singleton \([3,2^7]\) row is
   absent.  For \(n=2\), the common-support jet theorem reduces to rank-zero
   or reducible-residual boundaries and the residual-boundary theorem
   excludes them.  For \(n=3\), the fixed-fiber simultaneous-jet theorem
   excludes every integral deleted cubic and the nonintegral-block theorem
   excludes the complete complement.

The vector-bundle ledger below does not itself cover primitive triples with
a zero-dimensional base scheme or perform combined Enriques-diagram
incidences.  The companion results summarized in Section 7 now cover part,
but not all, of those boundaries.  No surviving stratum is claimed to
occur.

## 1. The double-dodecic model

A section of \(\mathcal O(1,2)\) has the form

\[
L_\sigma=\sigma(y)^t x,
\qquad
0\ne\sigma\in H^0(\mathcal O_{\mathbf P^2}(2))^{\oplus3},
\]

so the projective parameter space of quadratic triples has dimension

\[
3h^0(\mathcal O(2))-1=17.
\tag{1.1}
\]

Over the function field of \(\mathbf P^2_y\), eliminating the linear
equation \(L_\sigma\) from the conic gives the discriminant

\[
\boxed{
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma,
\qquad \deg B_\sigma=2\cdot2+2\cdot4=12.}
\tag{1.2}
\]

This formula remains the function-field branch formula when \(\sigma\)
has isolated common zeros; the original projection then has nonfinite
fibers over those points.

If the branch is smooth, its half-branch is \(6H\).  The standard
double-cover formulas give

\[
\boxed{
(K^2,\chi,p_g,q,P_2)=(18,11,10,0,29).}
\tag{1.3}
\]

Here \(P_2=28+1\): unlike the degree-ten case, the anti-invariant
bicanonical summand is one-dimensional.

## 2. Canonical resolution and the exact rationality rows

Factor the maximal square

\[
B_\sigma=G^2C,
\qquad e=\deg G,
\qquad \deg C=2m=12-2e,
\]

with \(C\ne0\) reduced.  Resolve the reduced branch canonically.  At every
proper or infinitely-near center let \(r_i\) be the multiplicity of the
corrected total branch, including a branch exceptional component, and set

\[
t_i=\left\lfloor\frac{r_i}{2}\right\rfloor,
\qquad
D=\sum_i(t_i-1)E_i.
\]

In the total-transform exceptional basis, the half-branch on the final
blowup \(f:Y\to\mathbf P^2\) is

\[
L_Y=mH-\sum_i t_iE_i.
\]

For the smooth resolved double cover \(\widetilde W\to Y\), one has

\[
\begin{aligned}
\chi(\mathcal O_{\widetilde W})
 &=1+\binom{m-1}{2}-\sum_i\binom{t_i}{2},\\
p_g(\widetilde W)
 &=h^0\bigl(Y,(m-3)H-D\bigr),\\
q(\widetilde W)
 &=p_g+\sum_i\binom{t_i}{2}-\binom{m-1}{2},\\
P_2(\widetilde W)
 &=h^0\bigl(Y,(2m-6)H-2D\bigr)\\
 &\quad+h^0\left(Y,(m-6)H+\sum_i(2-t_i)E_i\right).
\end{aligned}
\tag{2.1}
\]

The last line records both invariant and anti-invariant bicanonical
summands.  Thus Castelnuovo's criterion makes the following table exact.
The displayed adjoint systems are required to have no section.

| \(e\) | \(\deg C\) | correction profiles and exact extra conditions |
|---:|---:|---|
| 0 | 12 | Initially \([5]\), \([4,3,2]\), \([4,2,2,2,2]\), \([3,3,3,2]\), \([3,3,2,2,2,2]\), \([3,2,2,2,2,2,2,2]\), or \([2^{10}]\).  The systems \(H^0(Y,3H-D)\) and \(H^0(Y,6H-2D)\) must vanish.  The last profile is impossible by the anti-invariant summand, so precisely the first six are retained arithmetically. |
| 1 | 10 | \([4]\), \([3,3]\), \([3,2,2,2]\), or \([2^6]\), with \(H^0(Y,2H-D)=H^0(Y,4H-2D)=0\). |
| 2 | 8 | \([3]\) or \([2,2,2]\), with \(H^0(Y,H-D)=H^0(Y,2H-2D)=0\). |
| 3 | 6 | Exactly one essential \(t=2\) center; the degree-zero adjoint systems then vanish. |
| 4 | 4 | Every center has \(t=1\); rationality is automatic for the connected resolved double plane. |
| 5 | 2 | Every center has \(t=1\); rationality is automatic for a nonzero reduced conic. |

For \(e=6\), the branch is a pure square.  The generic double algebra
splits.  A horizontal component would have odd degree over
\(\mathbf P^2_y\), impossible because every divisor class on the smooth
threefold has even degree on a conic fiber.

Here is the promised anti-invariant check in the squarefree row.  If all
essential centers have \(t=2\), then

\[
\sum_i(2-t_i)E_i
\]

is effective: essential centers have coefficient zero and inessential
\(t=1\) centers have coefficient one.  Hence \(P_2\ge1\), excluding
\([2^{10}]\).  Conversely, every other partition of ten contains a center
with \(t_i\ge3\).  Every ancestor of such a center has strict branch
multiplicity at least four, hence corrected \(t\ge2\).  In the prime
exceptional basis, the coefficient along that center is therefore a sum of
nonpositive ancestor coefficients and contains the strictly negative term
\(2-t_i\).  The exceptional degree-zero divisor is not effective, so its
space of sections is zero.  Thus no additional anti-invariant condition is
hidden in the first six profiles.

## 3. Common factors of the quadratic triple

Before applying incidence estimates, one must remove a geometric source of
square factors that is present for every equation.  If

\[
\sigma=g\tau,
\]

then

\[
L_\sigma=gL_\tau,
\qquad
B_\sigma=g^2B_\tau.
\tag{3.1}
\]

Thus:

- if \(\deg g=1\), the divisor is the union of a vertical component and a
  class-\((1,1)\) horizontal component.  After normalization its horizontal
  double plane is exactly the \(k=1\) double-decic problem;
- if \(\deg g=2\), then \(\tau\) is constant and the horizontal component
  has class \((1,0)\), which is nonrational by
  [`k0_du_val_exclusion_theorem.md`](k0_du_val_exclusion_theorem.md).

Consequently a squared-line exclusion analogous to the \(k=1\) theorem is
false without the word *primitive*: triples with a common line produce such
a square for every \(A\).  The common-line locus is not a new \(k=2\)
source; it is exactly the earlier \(k=1\) frontier.

## 4. The base-point-free factor-incidence ledger

Assume now that the three quadrics \(\sigma_i\) have no common zero.  Let
\(\mathscr K\) be the kernel bundle

\[
0\longrightarrow\mathscr K\longrightarrow
\mathcal O^{\oplus3}\xrightarrow{\ \sigma\ }\mathcal O(2)
\longrightarrow0.
\]

The restricted quadratic form is a section of

\[
\mathcal Q_2=\operatorname {Sym}^2(\mathscr K^\vee)\otimes\mathcal O(4).
\]

Symmetrizing the dual presentation gives

\[
0\longrightarrow3\mathcal O(2)\longrightarrow6\mathcal O(4)
\longrightarrow\mathcal Q_2\longrightarrow0,
\qquad h^0(\mathcal Q_2)=72.
\tag{4.1}
\]

This is also the quotient dimension

\[
h^0(\mathcal O(2,4))-h^0(\mathcal O(1,2))=90-18=72.
\]

Let \(T\) be an integral plane curve of degree \(j\).  The restriction
image has dimension

\[
I_j=72-h^0(\mathcal Q_2(-j)).
\tag{4.2}
\]

On the normalization of \(T\), the globally generated bundle
\(\mathscr K^\vee\) has degree \(2j\), while the twist \(\mathcal O(4)\)
has degree \(4j\).  The rank-one-cone estimate from the \(k=1\) factor
proof bounds the locus \(\det(q|_T)=0\) by

\[
R(2j,4j)=
\max_{-2j\le a\le2j}
\left(
\max\{2j-2a+1,0\}+\max\{2a+4j+1,0\}
\right).
\tag{4.3}
\]

Since integral degree-\(j\) curves move in dimension
\(N_j=\binom{j+2}{2}-1\), the fixed-\(\sigma\), moving-factor codimension
is at least

\[
M_j=I_j-R(2j,4j)-N_j.
\]

The complete ledger through degree six is

\[
\begin{array}{c|rrrrrr}
j&1&2&3&4&5&6\\ \hline
I_j&21&39&54&66&72&72\\
R(2j,4j)&9&17&25&33&41&49\\
N_j&2&5&9&14&20&27\\
M_j&10&17&20&19&11&-4.
\end{array}
\tag{4.4}
\]

The quadratic-triple space has dimension seventeen.  Therefore, for a
general \(A\), no **base-point-free** \(\sigma\) has an integral cubic or
quartic component in \(B_\sigma\), because \(20,19>17\).  The conic row is
only equality, and the line, quintic, and sextic rows are smaller.  Those
rows give no exclusion.  In particular:

- a square root \(G\) containing an integral cubic or quartic component is
  excluded on this open locus;
- no value of \(e=1,\ldots,5\) is excluded in its entirety, since its
  square root may be built from lines and conics, or may have an integral
  quintic component; and
- unlike the \(k=1\) decic frontier, a retained reduced dodecic is not yet
  known to be integral.

These conclusions do not silently include primitive triples with isolated
base points; their blowup-bundle strata require a separate audit.

## 5. Why the existing proper-multiplicity estimate stops

The numerical obstruction already appears on the balanced-line open set.
On a balanced line,

\[
\mathcal Q_2|_L=\mathcal O_L(6)^{\oplus3}.
\]

The fixed fiber of

\[
(a,b,c)\longmapsto ac-b^2
\]

on triples of sextics has dimension at most eight.  For the zero fiber this
is the UFD parametrization

\[
(a,b,c)=h(u^2,uv,v^2)
\]

together with its diagonal boundaries; every other fiber has the same
bound by scaling degeneration to the zero fiber.  Degree-twelve determinant
targets with contact at least \(r\) at a fixed point have dimension
\(13-r\).  Hence one line contributes bad dimension at most \(21-r\).

Restriction to two balanced lines through the point is onto, because
\(H^1(\mathcal Q_2(-2))=0\), and its target has dimension

\[
21+21-3=39.
\]

Ignoring the shared constant fiber only enlarges the bad locus.  Thus a
proper corrected branch point of multiplicity \(r\) has fixed-point
codimension at least \(2r-3\), and moving the point leaves

\[
\boxed{2r-5.}
\tag{5.1}
\]

For the corrected multiplicities occurring in the retained squarefree
profiles, the margins are

\[
\begin{array}{c|cc|cc|cc}
t&3&3&4&4&5&5\\
r&6&7&8&9&10&11\\ \hline
2r-5&7&9&11&13&15&17.
\end{array}
\tag{5.2}
\]

Exclusion after allowing \(\sigma\) would require a strict inequality over
seventeen.  Even the largest entry is only equality.  Therefore the
existing two-line proper-point theorem removes none of the six squarefree
profiles.  This is a limitation of that estimate, not an assertion that
such profiles occur.

The doubled-line computation has the same boundary.  On a balanced line,
sections on the first infinitesimal neighborhood have patterns

\[
q=q_0+zq_1\pmod {z^2},
\qquad q_0:\mathcal O(6)^3,
\qquad q_1:\mathcal O(5)^3,
\]

in a target of dimension \(21+18=39\).  The rank-one cone for \(q_0\)
has dimension at most eight, and for every nonzero \(q_0\) the linearized
determinant has rank at least six on the eighteen-dimensional \(q_1\)
space.  Including the zero and diagonal boundaries, the doubled-line locus
has dimension at most twenty.  Its moving codimension is therefore only

\[
39-20-2=17,
\]

again equality.  Jumping lines can only weaken this raw bound.  Equation
(3.1) also shows geometrically why a universal squared-line exclusion
cannot hold.

## 6. Original arithmetic frontier

At the stage of the raw ledger, the genuinely new \(k=2\) problem reduced
to primitive quadratic triples and the following unresolved pieces:

1. the six squarefree profiles

   \[
   [5],\ [4,3,2],\ [4,2^4],\ [3,3,3,2],\
   [3,3,2^4],\ [3,2^7],
   \]

   with both adjoint systems in the \(e=0\) row vanishing;
2. every square-factor row \(e=1,\ldots,5\) allowed by the table, except
   for the base-point-free subloci whose square root has an integral cubic
   or quartic component;
3. the primitive zero-dimensional base-scheme strata; and
4. combined cluster incidence, rather than one-proper-point estimates.

Common-line triples are routed exactly to \(k=1\), and common-conic triples
are excluded by \(k=0\).  No stronger D4 conclusion was claimed at this
stage.

This list is retained to separate the arithmetic table from the later
geometric input.  It is superseded by the current frontier below.

## 7. Subsequent geometric reductions (2026-07-23)

The companion certificates sharpen Section 6 as follows.

1. The profile \([5]\) is absent on the entire primitive locus: the
   base-point-free case is excluded by three concurrent restriction lines,
   and the isolated-base classification treats high centers off the base,
   at multiplicity-two base points, and at proper simple base points.
2. No reduced degree-twelve plane branch has profile \([4,3,2]\).  The
   proximity classification is determinant-independent: every realizable
   diagram forces a doubled line.
3. On the base-point-free locus, \([4,2^4]\) is absent for every proper or
   infinitely-near placement of its four \(t=2\) centers.  Cubic-adjoint
   vanishing forces the three \(t=3\) centers of \([3^3,2]\) to be proper
   triangle vertices, so that entire row is absent.
4. Primitive isolated base schemes are exhausted by the rank-three
   length-one, length-two, length-three, and \(\mathfrak m_p^2\) rows and
   the rank-two \((2,2)\) complete-intersection rows.  Their triple strata
   have dimension at most sixteen.  No such stratum has an integral conic
   branch component.
5. The entire degree-two square-factor row is absent on the
   base-point-free locus, including integral-conic, two-line, and
   doubled-line square roots.
6. Consequently the degree-three and degree-four square-factor rows are
   absent on that locus as well: every remaining factorization contains a
   degree-two divisor.  The same routing leaves only an integral quintic
   in degree five, and the normalization/gonality incidence excludes every
   such component.  Thus the degree-five row is absent too.
7. Resolved-line incidences exclude \([4,2^4]\) and \([3^3,2]\) on every
   primitive isolated-base stratum, and a sequential doubled-line argument
   excludes the isolated-base degree-two square-factor row.
8. Deleted-adjoint cubics exclude \([3^2,2^4]\) whenever its four \(t=2\)
   centers are proper, including the proper/free-first-near high-center
   row, and exclude the all-proper \([3,2^7]\) row.  The latter reduction
   ends with strict line--line, line--conic, and conic--conic factor-pair
   incidences.
9. The base-point-free squared-line row first reduces to two extremal
   first-neighborhood strata.  Their inverse elementary transforms have
   \(c_2=3\) and \(2\), so neither is the settled \(k=1\) kernel.  Complete
   transformed-bundle incidences then exclude both, closing base-point-free
   \(e=1\).  Away from an isolated base, a squared line is reduced to one
   unbalanced high-diagonal stratum.  The isolated-base sharpening excludes
   that stratum for a one-point base, leaves only the rank-three
   two-distinct-point off-base row, and reduces lines meeting the base to six
   explicit cluster positions.  For isolated integral-quintic roots,
   the off-base and transverse-proper theorems combine with the cluster
   theorem for singular proper contact, infinitely-near simple centers, and
   multiplicity-two base points to close the connected \(e=5\) row.  The
   degree-zero quotient boundary instead gives a disconnected pure square,
   not a blanket exclusion of all of its quintic components.
10. In the distinct-singleton subrows of both remaining squarefree
    profiles, exactly one nonproper low tree is absent.  Thus at least two
    are necessary; doubled-adjoint vanishing gives the opposite bound
    three for \([3,2^7]\).
11. The same one-nonproper exclusions hold for isolated-base triples when
    the base support avoids every selected adjoint cubic and the marked
    tangent line.  Any remaining isolated case requires that alignment.
12. A nonproper \(t=3\) center in \([3,2^7]\) is forced to be the free
    first-near successor of a proper \(t=2\) center, with
    \((r_p,r_q;m_p,m_q)=(5,6;5,5)\).  If the other six lows are
    singleton trees, at most two of them are nonproper.
13. In the proper-high seven-distinct-singleton row with exactly two
    nonproper lows,
    both nonproper-label-deleted cubics are nonintegral.  The low-factor-pair
    theorem reduces any survivor to a common line through \(p\) and two
    proper lows or a common conic through \(p\) and all five proper lows.
    The two-line jet theorem reduces these supports to rank-zero or
    reducible-residual boundaries; the residual-boundary theorem excludes
    all of them, including mixed mismatches.  Therefore that entire scoped
    \(n=2\) row is absent.  With three nonproper lows, the fixed-fiber
    simultaneous-jet theorem excludes all seven integral deleted-adjoint
    cubics.  The nonintegral-block theorem then excludes every line--conic
    and three-line distribution, forces and eliminates the only possible
    common low-degree branch factor, and excludes the final integral and
    reducible residual-conic boundaries.  Therefore the scoped \(n=3\) row,
    and hence the entire proper-high seven-distinct-singleton row, is absent.

Consequently the current primitive squarefree arithmetic frontier is

\[
\boxed{[4,2^4],\ [3^3,2],\ [3^2,2^4],\ [3,2^7].}
\tag{7.1}
\]

This four-profile list is arithmetic, not a claim that every profile
survives on the determinant locus.  The first two profiles are now absent
on every primitive stratum, so the actual primitive squarefree frontier is

\[
\boxed{[3^2,2^4],\ [3,2^7].}
\tag{7.2}
\]

On the base-point-free locus a survivor in the first profile must have an
infinitely-near \(t=2\) center, while a survivor in the second must have an
infinitely-near essential center.  In their distinct-singleton subrows,
both require at least two nonproper low trees.  In the proper-high
seven-distinct-singleton \([3,2^7]\) subrow there are exactly two or three;
both rows are absent by item 13.  Thus the entire proper-high
seven-distinct-singleton subrow is absent.  Nonproper-high, repeated
essential-tree, isolated-base, and other \([3,2^7]\) cluster types are
outside that conclusion.

The base-point-free square-factor locus is now closed.  Separately, the
conductor-safe component theorem closes the isolated-base \(e=3,4\) rows;
together with the degree-two and connected integral-quintic theorems, this
leaves only the isolated-base squared-line row \(e=1\).  Combined branch/base
clusters and all \(k\ge3\) remain open.

The proofs and replays are
[`k2_profile5_three_line_exclusion.md`](k2_profile5_three_line_exclusion.md),
[`k2_primitive_base_scheme_reduction.md`](k2_primitive_base_scheme_reduction.md),
[`k2_profile432_proximity_exclusion.md`](k2_profile432_proximity_exclusion.md),
[`k2_combined_proper_cluster_exclusion.md`](k2_combined_proper_cluster_exclusion.md),
[`k2_basepointfree_degree2_square_exclusion.md`](k2_basepointfree_degree2_square_exclusion.md),
[`k2_profile3332_properness_exclusion.md`](k2_profile3332_properness_exclusion.md),
[`k2_basepointfree_higher_square_reduction.md`](k2_basepointfree_higher_square_reduction.md),
[`k2_basepointfree_quintic_component_exclusion.md`](k2_basepointfree_quintic_component_exclusion.md),
[`k2_basepointfree_line_square_reduction.md`](k2_basepointfree_line_square_reduction.md),
[`k2_basepointfree_line_square_transformed_bundle_exclusion.md`](k2_basepointfree_line_square_transformed_bundle_exclusion.md),
[`k2_isolated_quintic_offbase_exclusion.md`](k2_isolated_quintic_offbase_exclusion.md),
[`k2_isolated_line_square_offbase_reduction.md`](k2_isolated_line_square_offbase_reduction.md),
[`k2_isolated_line_square_base_aligned_frontier.md`](k2_isolated_line_square_base_aligned_frontier.md),
[`k2_isolated_quintic_transverse_base_exclusion.md`](k2_isolated_quintic_transverse_base_exclusion.md),
[`k2_isolated_quintic_base_cluster_exclusion.md`](k2_isolated_quintic_base_cluster_exclusion.md),
[`k2_isolated_cubic_quartic_component_exclusion.md`](k2_isolated_cubic_quartic_component_exclusion.md),
[`k2_isolated_base_retained_profile_exclusion.md`](k2_isolated_base_retained_profile_exclusion.md),
[`k2_isolated_degree2_square_exclusion.md`](k2_isolated_degree2_square_exclusion.md),
[`k2_remaining_all_proper_adjoint_reduction.md`](k2_remaining_all_proper_adjoint_reduction.md),
[`k2_profile3324_one_nonproper_singleton_exclusion.md`](k2_profile3324_one_nonproper_singleton_exclusion.md),
[`k2_profile327_one_nonproper_singleton_exclusion.md`](k2_profile327_one_nonproper_singleton_exclusion.md),
[`k2_profile327_multiple_nonproper_frontier.md`](k2_profile327_multiple_nonproper_frontier.md),
[`k2_profile327_n2_common_support_jet_reduction.md`](k2_profile327_n2_common_support_jet_reduction.md),
[`k2_profile327_n2_residual_boundary_exclusion.md`](k2_profile327_n2_residual_boundary_exclusion.md),
[`k2_profile327_n3_simultaneous_jet_frontier.md`](k2_profile327_n3_simultaneous_jet_frontier.md),
[`k2_profile327_n3_nonintegral_block_exclusion.md`](k2_profile327_n3_nonintegral_block_exclusion.md),
[`k2_profile327_nonproper_high_reduction.md`](k2_profile327_nonproper_high_reduction.md),
and
[`k2_one_nonproper_singleton_offbase_exclusion.md`](k2_one_nonproper_singleton_offbase_exclusion.md).

All arithmetic tables and incidence margins are replayed by
[`k2_double_dodecic_frontier_checks.py`](k2_double_dodecic_frontier_checks.py).
