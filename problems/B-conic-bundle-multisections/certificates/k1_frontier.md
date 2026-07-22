# Exact canonical-resolution frontier for class `(1,1)`

This note gives the finite calculation excluding rational normalized double
octics arising from class `(1,1)`.  Every row is now treated.  Namely,
[`k1_work/proper_sixfold_theorem.md`](k1_work/proper_sixfold_theorem.md)
excludes the square-free one-`t=3` row, and
[`k1_work/square_line_theorem.md`](k1_work/square_line_theorem.md) excludes the
residual-sextic row, reducible higher square factors, and `B_sigma=0`.
[`k1_work/conic_factor_theorem.md`](k1_work/conic_factor_theorem.md) then
excludes the residual-quartic row, and
[`k1_work/cubic_factor_theorem.md`](k1_work/cubic_factor_theorem.md) excludes
even a single integral cubic factor.  The final universal incidence to be
excluded was the square-free three-`t=2` row.  Within it,
[`k1_work/proper_three_center_theorem.md`](k1_work/proper_three_center_theorem.md)
excludes the subrow in which all three essential centers are proper.  Every
diagram then left has at least one infinitely-near essential center.
[`k1_work/adjacent_nested_pair_theorem.md`](k1_work/adjacent_nested_pair_theorem.md)
excludes every adjacent root type `[2,1]` and the proper-root successive-free
adjacent chain of root type `[3]`.  The later theorem
[`k1_work/three_singleton_first_near_theorem.md`](k1_work/three_singleton_first_near_theorem.md)
excludes the complete root type `[1,1,1]`.  The exact separator classification
in [`k1_work/root_three_separator_theorem.md`](k1_work/root_three_separator_theorem.md),
the complete `[2,1]` theorem
[`k1_work/root_two_one_separator_theorem.md`](k1_work/root_two_one_separator_theorem.md),
and the `[3]` free-separator and completion theorems
[`k1_work/root_three_free_separator_theorem.md`](k1_work/root_three_free_separator_theorem.md)
and [`k1_work/root_three_completion_theorem.md`](k1_work/root_three_completion_theorem.md)
exclude every remaining infinitely-near diagram.  Consequently no rational
class-`(1,1)` member occurs for a general class-`(2,3)` equation.

## 1. Remove square factors first

For a linear triple `sigma`, put

\[
 B=B_\sigma=\sigma^t\operatorname{adj}(A)\sigma,\qquad \deg B=8.
\]

Write

\[
 B=G^2C,
\]

where `G` is the maximal square divisor and `C` is reduced.  The normalization
of the connected double algebra has function field

\[
 \mathbf C(\mathbf P^2)(\sqrt C).
\]

Thus `deg(C)=2m` with `m=4-e`, where `e=deg(G)` is one of `0,1,2,3`.
The case `e=4` is a pure square: the generic double algebra splits and does
not give an integral degree-two multisection.  For a general smooth `X`, a
horizontal component of odd degree is independently excluded by
`Pic(X)=Z H_x + Z H_y`.

This step also handles rank-one `sigma`: then
\(S=\{l=0\}\cup\{v\mathbin{\cdot}x=0\}\), and for general \(A\) its horizontal
component is excluded by the certified `(1,0)` theorem.  Rank-two
`sigma` must remain in the calculation.  Its isolated base point makes the
original projection nonfinite there, so the formulas below apply to the
normalized Stein/function-field double plane rather than literally to that
projection as a finite cover.

## 2. Canonical-resolution data

Run the canonical resolution of the reduced branch `C`.  At the `i`-th
center let `r_i` be the multiplicity of the **corrected branch divisor**
(including an exceptional curve when the preceding multiplicity was odd), and
set

\[
 t_i=\left\lfloor\frac{r_i}{2}\right\rfloor.
\]

If `f:Y -> P^2` is the resulting blown-up plane and `L_Y` is the corrected
half-branch, then

\[
 K_Y+L_Y=f^*O_{\mathbf P^2}(m-3)-\sum_i(t_i-1)E_i.
\]

Consequently

\[
 \begin{aligned}
 \chi(O_{\widetilde T})
   &=1+\binom{m-1}{2}-\sum_i\binom{t_i}{2},\\
 p_g(\widetilde T)
   &=h^0\!\left(O_{\mathbf P^2}(m-3)\otimes
       f_*O_Y\!\left(-\sum_i(t_i-1)E_i\right)\right),\\
 q(\widetilde T)&=1+p_g-\chi.
 \end{aligned}
\]

All exceptional divisors here are interpreted in the total-transform basis;
the pushforward is the complete cluster ideal and includes all proximity
conditions.  No assumption that the essential centers are proper or ordinary
is being made.

Put

\[
 D=\sum_i(t_i-1)E_i,\qquad
 \mathcal J_D=f_*\mathcal O_Y(-D),\qquad
 \mathcal J_{2D}=f_*\mathcal O_Y(-2D).
\]

For infinitely-near centers these are divisorial-valuation ideals, and the
raw weights need not be antinef.  They must be unloaded (equivalently, one
must use the displayed pushforwards), and in general
\(\mathcal J_{2D}\ne\mathcal J_D^2\).  For example, if `q` is the first point
infinitely near to `p` in the tangent direction `y=0`, then in local
coordinates

\[
 f_*\mathcal O_Y(-E_q)=\mathfrak m_p=(x,y),\qquad
 f_*\mathcal O_Y(-2E_q)=(x^2,y).
\]

Thus a simple weight at `q` asks a line only to pass through `p`, whereas the
doubled weight asks a conic for the corresponding tangent two-jet.  It is not
legitimate to read the doubled total-transform weight as multiplicity two of
the successive strict transform at `q`.

The bicanonical system splits as

\[
 H^0(2K_{\widetilde T})=
 H^0(Y,2K_Y+2L_Y)\oplus H^0(Y,2K_Y+L_Y).
\]

For `m <= 4` the second summand has plane degree `m-6<0` and vanishes.  The
first is the cluster system

\[
 H^0\!\left(O_{\mathbf P^2}(2m-6)\otimes
       f_*O_Y\!\left(-\sum_i2(t_i-1)E_i\right)\right).
\]

These formulas remain valid for reducible reduced `C`.  Nodes, ordinary
triple points, and every other center with `t_i=1` are numerically negligible,
although they can be predecessors of an essential infinitely-near center and
therefore cannot be deleted from the incidence.

## 3. Complete rationality table

Over an algebraically closed field of characteristic zero, let \(C\ne0\) be
the reduced residual branch and take the connected normalized double plane
after its complete canonical resolution.  Castelnuovo's criterion says that
this smooth surface is rational exactly when `q=P_2=0`.  Applying the
preceding formulas, if

\[
 s=\sum_i\binom{t_i}{2},\qquad c_m=\binom{m-1}{2},
\]

then \(q=p_g+s-c_m\).  A nonzero canonical section has a nonzero square,
so `P_2=0` forces `p_g=0`.  Rationality is therefore equivalent to
\(s=c_m\), `p_g=0`, and `P_2=0`.  This gives the following exhaustive table.

| `e=deg G` | `deg C` | required canonical-resolution data |
|---:|---:|---|
| 0 | 8 | `sum binom(t_i,2)=3`, and both \(H^0(\mathcal J_D(1))=0\) and \(H^0(\mathcal J_{2D}(2))=0\).  Equivalently, either there is one `t_i=3` and all other `t_j=1` (the two vanishings are then automatic), or there are three `t_i=2` and all other `t_j=1`, and the two displayed cluster systems must both vanish. |
| 1 | 6 | Exactly one center has `t_i=2`; every other center has `t_j=1`. |
| 2 | 4 | Every center has `t_i=1` (all singularities are negligible for the double cover). |
| 3 | 2 | Automatic for a nonzero reduced conic. |

In the octic row, if the correction sum is three and there is one `t=3`
center, that center is necessarily proper.  Indeed, along a chain whose
predecessors all have `t=1`, the strict-curve multiplicity is at most three and
at most two odd exceptional branch components pass through a point, so the
corrected multiplicity is at most five.  A corrected multiplicity six or seven
would therefore have an earlier essential center, contradicting the correction
sum.  At a proper `t=3` center a line cannot have multiplicity two and a conic
cannot have multiplicity four, so both cluster systems vanish automatically.

For three `t=2` centers, the linear and conic systems must be tested
separately.  The conic vanishing implies the linear vanishing by squaring, but
the converse is false for infinitely-near centers.  Here is an explicit
reduced-octic counterexample to the converse.  In coordinates `[x:y:z]`, put

\[
\begin{gathered}
 Q=xz-y^2,\quad L_1=z,\quad L_2=x,\quad L_3=x-2y+z,\\
 R=xz(x-2y+z)+(xz-y^2)(x+z),\qquad
 C=Q L_1L_2L_3R.
\end{gathered}
\]

The cubic `R` is smooth, and on `Q` its restriction is that of
`L_1L_2L_3`.  At the three noncollinear points

\[
 p_1=[1:0:0],\qquad p_2=[0:0:1],\qquad p_3=[1:1:1],
\]

the three components `Q`, `L_i`, and `R` are smooth with a common tangent and
distinct second-order directions.  Hence the corrected branch multiplicities
at `p_i` and at the first infinitely-near point `q_i` are `(3,4)`, so the
essential data are three `t=2` centers `q_i`; every other center has `t=1`.
For \(D=E_{q_1}+E_{q_2}+E_{q_3}\), a line in
\(H^0(\mathcal J_D(1))\) would have to pass through all three `p_i`, so this
space is zero.  But `Q` has divisorial value two at each `q_i`, and therefore

\[
 0\ne Q\in H^0(\mathcal J_{2D}(2)).
\]

Thus this double octic has `p_g=q=0` but `P_2>0` and is not rational.  If the
octic correction sum is \(s<3\), then \(q=0\) can occur only with
\(p_g=3-s>0\), and squaring a canonical section again gives \(P_2>0\); if
`s>3`, then `q>0`.  In the sextic row, the one `t=2` center kills both the
constant adjoint and the degree-zero bicanonical section, even when it is
infinitely near.  The quartic and conic rows have no adjoint or bicanonical
sections.

The table is both necessary and sufficient for rationality of the connected
normalized double plane.  In particular, merely killing `p_g` is not enough:
the numerical equality for `chi`, including every infinitely-near center, is
essential.

## 4. The finite universal incidence

Let `P_A=P^59`, `P_sigma=P^8`, and let `Gamma_beta` be the closure of the graph
of the rational branch map

\[
 \beta:P_A\times P_\sigma \dashrightarrow P(H^0(O_{\mathbf P^2}(8))),
 \qquad (A,\sigma)\longmapsto [B_\sigma].
\]

For each `e=0,1,2,3`, retain the factorization variables by forming the fiber
product of `Gamma_beta` with the projective multiplication morphism

\[
 \mu_e:P(H^0(O(e)))\times P(H^0(O(8-2e)))\longrightarrow P(H^0(O(8))),
 \qquad (G,C)\longmapsto [G^2C].
\]

Merely intersecting with the image of `mu_e` would lose the residual curve
`C` needed for the resolution incidence.

For each complete canonical-resolution Enriques diagram `D` of a reduced
plane curve of degree `8-2e`, form the iterated universal blow-up parameter
space `Cl_D` of ordered proper and infinitely-near centers.  Here “complete”
includes the `t=1` blowups needed to separate crossings or tangencies of the
corrected branch, not merely the centers in a minimal embedded resolution of
the strict curve.  On the standard affine charts, the conditions

\[
 \operatorname{mult}_{p_i}(C_i)=r_i,
 \qquad C_{i+1}=\widetilde C_i+(r_i\bmod2)E_i
\]

are explicit jet equations plus nonvanishing conditions.  Exact multiplicity
\(r\) is covered by the union of opens on which one chosen order-\(r\) jet is
nonzero; take the corresponding saturation on each open, rather than inverting
the product of all order-\(r\) jets.  Retain exactly the diagrams satisfying the
corresponding row of the table.  In the octic three-`t=2` case, use the actual
complete cluster ideals and restrict to the opens on which both evaluation
maps

\[
 H^0(O(1))\longrightarrow H^0(O(1)/\mathcal J_D(1)),\qquad
 H^0(O(2))\longrightarrow H^0(O(2)/\mathcal J_{2D}(2))
\]

are injective.  After flattening the universal cluster quotients, these opens
are covered by nonvanishing maximal minors.  A naive determinant obtained by
evaluating strict transforms at infinitely-near points does not compute these
maps.  Take the projective closure of each chart after the required
reducedness, chart, exactness, terminal-smoothness, and rank-condition
saturations.  Denote the resulting finite collection of closed incidences by
`I_bar(e,D)`.  Omitting terminal smoothness only enlarges an incidence and is
therefore safe for a negative certificate, but it no longer gives the claimed
exact stratification.

There are only finitely many diagrams to check by bounded embedded
resolution/equiresolution for plane curves of fixed degree.  The elementary
bound \(\delta\le d(d-1)/2\), hence at most \(28\) here, controls centers where
the strict curve has multiplicity at least two; bounded equiresolution (or,
equivalently, additional degree-bounded intersection/contact estimates) also
controls multiplicity-one tangency centers involving odd exceptional branch
components.  Thus the projective spaces of forms of degrees `2,4,6,8`
admit a finite equiresolution stratification suitable for this calculation.

The exact class-`(1,1)` exclusion statement is

\[
 \dim\operatorname{pr}_{P_A}\overline I(e,D)<59
 \quad\text{for every retained }(e,D),
\]

together with non-dominance of the branch-map base locus `B_sigma=0`.
Construct every schematic closure over one common integral model
\(\mathbf Z[1/N]\).  Because every factor and cluster space has a projective
compactification, their images are closed.  A finite-field matrix `A` lying
outside the special fibers of all those integral projective closures is then a
characteristic-zero certificate by the same properness argument as in
`k0_no_triple.m2`.  Here “outside” must mean outside the geometric image after
base change to \(\overline{\mathbf F}_p\), as certified for example by unit
fiber ideals on a projective chart cover; merely finding no
\(\mathbf F_p\)-rational cluster is insufficient.  Independently recomputing
saturated closures only after reduction would not suffice, since saturation
need not commute with specialization.

This incidence includes all square factors, reducible residual branches,
isolated base points of `sigma`, and infinitely-near essential centers.  A
calculation restricted to proper quadruple/sextuple points is only a
sub-incidence and cannot certify the full `(1,1)` exclusion.

## 5. Computational bottleneck

Even the smallest new closed sub-incidence is much larger than the `k=0`
calculation.  A proper sixfold point on a square-free octic is cut out by the
twenty-one order-five derivatives in

\[
 P^8_\sigma\times P^2_y.
\]

After choosing affine charts this is an overdetermined system in ten
variables, with equations quadratic in the nine coefficients of `sigma` and
cubic in the point coordinates.  A direct `dim ideal(...)` Gröbner
calculation did not finish its first chart in several minutes on the existing
witness.  The generator
[`generate_k1_sixfold.py`](generate_k1_sixfold.py) was subsequently run with
`msolve` over \(\mathbf F_{1073741827}\).  For the chosen coefficient matrix,
exact sparse linear algebra gives the unit ideal on the single affine chart
`sigma-chart=0, point-chart=0`; five probabilistic runs also returned the unit
ideal, covering that chart and four additional charts.  The commands, timings,
incomplete chart coverage, and exact/probabilistic distinction are recorded in
[`k1_sixfold_screen.log`](k1_sixfold_screen.log).  One exact affine chart did
not certify the projective sub-incidence.  The conceptual proper-sixfold
theorem now supersedes that incomplete chart calculation.  The later
square-line, conic-factor, and cubic-factor theorems remove every square-factor
row.  The proper-three-center theorem also removes the all-proper part of the
three-`t=2` row.  The adjacent-nesting theorem further removes every adjacent
`[2,1]` skeleton and the proper-root successive-free adjacent `[3]` chain.

The earlier low-genus/determinant-fiber attempt and the uniform bounds it
would have required are recorded in
[`k1_work/three_center_equigeneric_attempt.md`](k1_work/three_center_equigeneric_attempt.md).
Its proposed genus-three premise is disproved by the exact reduced-octic
certificate
[`k1_work/three_center_genus_counterexample.md`](k1_work/three_center_genus_counterexample.md).
The source-level and first-order limits of the determinant-fiber shortcut are
separated in
[`k1_work/determinant_fiber_limits.md`](k1_work/determinant_fiber_limits.md).
The structural root types, the immediate `(3,4)` lemma in type
`[1,1,1]`, a reduced `[2,1]` realization, and the universal doubled-cluster
cubic are recorded in
[`k1_work/contact_cubic_observation.md`](k1_work/contact_cubic_observation.md).
The cubic has zero intersection with the corrected branch, but forced shared
exceptional components explain why that unmarked argument alone did not close
the incidence.
The direct tangent-line/conic incidence proof and its exact determinant-bound
and codimension arithmetic are in
[`k1_work/adjacent_nested_pair_theorem.md`](k1_work/adjacent_nested_pair_theorem.md),
[`k1_work/adjacent_nested_pair_local_checks.py`](k1_work/adjacent_nested_pair_local_checks.py),
and the recorded
[`log`](k1_work/adjacent_nested_pair_local_checks.log).  The three-singleton
proof and its exact arithmetic are in
[`k1_work/three_singleton_first_near_theorem.md`](k1_work/three_singleton_first_near_theorem.md),
[`k1_work/three_singleton_first_near_local_checks.py`](k1_work/three_singleton_first_near_local_checks.py),
and the recorded
[`log`](k1_work/three_singleton_first_near_local_checks.log).  The surviving
essential skeletons at that stage were `[2,1]` with a separator and the
nonadjacent part of `[3]`.

The final separator classification and exclusions are in
[`k1_work/root_three_separator_theorem.md`](k1_work/root_three_separator_theorem.md),
[`k1_work/root_two_one_separator_theorem.md`](k1_work/root_two_one_separator_theorem.md),
[`k1_work/root_three_free_separator_theorem.md`](k1_work/root_three_free_separator_theorem.md),
and [`k1_work/root_three_completion_theorem.md`](k1_work/root_three_completion_theorem.md).
The exact arithmetic of the three exclusion theorems is checked by
[`k1_work/root_two_one_separator_local_checks.py`](k1_work/root_two_one_separator_local_checks.py)
and its [`log`](k1_work/root_two_one_separator_local_checks.log),
[`k1_work/root_three_free_separator_local_checks.py`](k1_work/root_three_free_separator_local_checks.py)
and its [`log`](k1_work/root_three_free_separator_local_checks.log), and
[`k1_work/root_three_completion_local_checks.py`](k1_work/root_three_completion_local_checks.py)
and its [`log`](k1_work/root_three_completion_local_checks.log).  The four
theorems classify every gap as a unique free or
satellite separator, exclude all `[2,1]` diagrams with minima `9>8` in rank
three and `8>7` in rank two, and exclude all `[3]` diagrams with the same
strict final margins.  This completes the class-`(1,1)` nonexistence theorem.
