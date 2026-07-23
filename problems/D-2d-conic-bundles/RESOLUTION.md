# Resolution status for Problem D

## Bottom line

The unirationality of a general hypersurface

\[
X_{2,d}\subset \mathbf P^2_x\times\mathbf P^2_y,
\qquad d\ge 4,
\]

is **not decided here**.  In particular, the negative result below is not a
non-unirationality theorem for \(X\).

What is decided is the primary construction singled out in `SPEC.md`.  For a
general \((2,4)\) equation, the tangent-residual incidence becomes a double
cover only after resolving thirty-six base points of the tangent-line map.
The resolved cover \(Z_4\) is smooth and irreducible, its canonical class is
ample, and

\[
\boxed{
(K_{Z_4}^2,\chi(\mathcal O_{Z_4}),p_g(Z_4),q(Z_4),P_2(Z_4))
=(608,127,126,0,735).}
\]

Thus \(Z_4\) is a surface of general type, not a rational surface.  The
sufficient route

\[
Z_4\text{ rational}\Longrightarrow X_{2,4}\text{ unirational}
\]

does not fire.

The calculation also gives a limits theorem.  For every \(d\ge4\), the
resolved tangent-residual incidence from a fixed line and a general equation
has ample canonical class.  For each fixed seed degree, the same holds for a
general pair consisting of the equation and an immersive parametrized
rational plane seed.  This generic-seed result does not quantify over a
special seed chosen as a function of \(X\).  Uniformly for one general
equation and every immersed rational seed, however, the scheme-theoretic
residual is lci with ample dualizing sheaf; only normalization and
canonical-singularity control remain open.  For quartics, the residual-multiplier
compactification is saturated exactly through \(\lambda _2=0\): its
closure is prime, restores the missing rank, and a general coefficient
fiber avoids the closure's only intrinsic singular stratum.  It lies over
\([1:0:0]\) and is transversely a rank-four quadric cone.  The saturated
closure is now identified scheme-theoretically with the actual
ramification divisor, which is a smooth curve with unique multiplier and
finite reduced boundary.  Exact two-point ranks prove generic degree one
over every image and separate distinct generic images.  Ampleness and
adjunction then show that every residual discriminant component has
normalization of genus at least two.  Every middle and bottom
multiplier-boundary point is now an ordinary fold with simultaneous model
\(uv=s\), \(z^2=u+v+\phi(t)\), and reducedness forces
\(\phi'(0)=\gamma\ne0\).  Open-residual fold/cusp and higher-Morin models
and isolated multiple-value collisions remain.

There is also a separate D4 exclusion result.  On a general \((2,4)\)
member, every divisor of class \(H_x\) is integral and normal with only Du
Val singularities, and its minimal resolution has \(p_g=3\).  Thus the
class-\((1,0)\), or \(k=0\), frontier contains no rational surface.
For class \((1,1)\), the double-decic analysis removes every square-factor
row, the nested \([3,2,2,2]\) profile, and every low-degree component.  The
six- and five-root partitions are absent by direct conic incidences.  A
uniform essential-chain classification then handles every remaining
squarefree six-\(t=2\) diagram: exact unloading selects a length-five conic
with contact at least eighteen, doubled lines force a forbidden line
component, and every smooth/nodal determinant incidence has strict
rank-orbit margin.  Thus the class-\((1,1)\), or \(k=1\), case is complete.

For class \((1,2)\), the branch has degree twelve and the exact
canonical-resolution table is now available.  The anti-invariant
bicanonical summand excludes the all-\(t=2\) profile \([2^{10}]\), leaving
six profiles arithmetically.  Geometry first excludes \([5]\) and
\([4,3,2]\), leaving four arithmetic profiles.  Resolved-line incidences
then exclude \([4,2^4]\) and \([3^3,2]\) on every primitive triple stratum,
so the actual primitive squarefree frontier has two profiles.  For the
base-point-free \([3^3,2]\) row, cubic-adjoint vanishing intrinsically forces the three high
centers to be the proper vertices of a triangle.  An all-proper
\([3,2^7]\) row is now excluded, as is \([3^2,2^4]\) whenever its four
\(t=2\) centers are proper.  Primitive isolated base
schemes are classified, have parameter dimension at most sixteen, and
support neither \([5]\) nor an integral conic branch component.  The entire
degree-two square-factor row and the connected isolated-base
integral-quintic square-root row are absent on the primitive locus, and every
base-point-free square-factor row \(e=1,\ldots,5\) is absent.  Retained base-point-free subrows of
\([3^2,2^4]\) and \([3,2^7]\) therefore require infinitely-near
low/essential centers.  In the distinct-singleton subrows, each profile
requires at least two nonproper lows.  In the proper-high
seven-distinct-singleton \([3,2^7]\) subrow, doubled-adjoint vanishing permits
exactly two or three.  Its two-nonproper row is reduced to
a shared proper-low line or conic support for its two deleted cubics.  The
two-line jet theorem reduces these supports to rank-zero or
reducible-residual boundaries, and the residual-boundary theorem excludes
all of them, including the mixed mismatches.  Hence that full scoped \(n=2\)
singleton row is absent.  Its three-nonproper row has an exact zero-margin
simultaneous-jet boundary.
The conductor-safe theorem closes the isolated-base \(e=3,4\) rows.
Together with primitive \(e=2\) and the connected isolated-base \(e=5\)
theorem, this leaves only isolated \(e=1\) and combined branch/base clusters
among connected square-factor candidates.  Within that isolated squared-line row,
only a rank-three two-distinct-point off-base high-diagonal case and six
explicit through-base cluster positions survive the current incidences.

A second D3 candidate is decided as well.  The surface of quartic
bitangents is a smooth relative square-quartic pullback with

\[
K\equiv4(H_x+H_\ell),\qquad K^2=1728.
\]

Its degree-two marked-root incidence maps to \(X\) but remains of general
type, so the bitangent-point construction supplies no rational source.  The
direct flex/Hessian incidence is likewise smooth with ample canonical class

\[
3H+(3d-8)P+J
\]

for every \(d\ge4\).

The complete proof is
[`certificates/tangent_residual_limits_theorem.md`](certificates/tangent_residual_limits_theorem.md).
Two exact checkers independently verify the quartic covariant and the
intersection/cohomology arithmetic.  The D4 exclusion is proved in
[`certificates/k0_du_val_exclusion_theorem.md`](certificates/k0_du_val_exclusion_theorem.md).
The bitangent calculation is
[`certificates/bitangent_incidence_general_type.md`](certificates/bitangent_incidence_general_type.md).
The all-degree flex calculation is
[`certificates/flex_incidence_general_type.md`](certificates/flex_incidence_general_type.md).

The uniform special-seed theorem is
[special_seed_uniform_dualizing_theorem.md](certificates/special_seed_uniform_dualizing_theorem.md),
and its exact higher-jet stability frontier is
[special_seed_stability_frontier.md](certificates/special_seed_stability_frontier.md).
The restricted-family multijet obstruction and rank atlas are
[special_seed_multijet_reduction.md](certificates/special_seed_multijet_reduction.md).
The exact multiplier-boundary saturation is
[special_seed_residual_saturation.md](certificates/special_seed_residual_saturation.md).
Its scheme-theoretic ramification comparison and two-point separation are
[special_seed_ramification_comparison.md](certificates/special_seed_ramification_comparison.md).
The ordinary middle/bottom boundary fold, simultaneous double-cover model,
and nonzero mixed coefficient are
[special_seed_boundary_fold_theorem.md](certificates/special_seed_boundary_fold_theorem.md).
The all-proper and singleton-root class-\((1,1)\) analyses are
[k1_six_proper_centers_exclusion.md](certificates/k1_six_proper_centers_exclusion.md),
[k1_singleton_root_exclusion.md](certificates/k1_singleton_root_exclusion.md).
Integral quintic factors and the five-root partition are excluded in
[k1_quintic_factor_exclusion.md](certificates/k1_quintic_factor_exclusion.md),
[k1_two_essential_tree_classification.md](certificates/k1_two_essential_tree_classification.md),
and
[k1_two_essential_partition_exclusion.md](certificates/k1_two_essential_partition_exclusion.md).
The first two four-root analyses are
[k1_two_repeated_trees_exclusion.md](certificates/k1_two_repeated_trees_exclusion.md)
and
[k1_three_essential_tree_pruning.md](certificates/k1_three_essential_tree_pruning.md).
The uniform closure is
[k1_uniform_six_center_conic_exclusion.md](certificates/k1_uniform_six_center_conic_exclusion.md).
The exact class-\((1,1)\) arithmetic frontier is
[k1_double_decic_frontier.md](certificates/k1_double_decic_frontier.md).
The class-\((1,2)\) arithmetic ledger is
[k2_double_dodecic_frontier.md](certificates/k2_double_dodecic_frontier.md).
Its subsequent geometric reductions are
[k2_profile5_three_line_exclusion.md](certificates/k2_profile5_three_line_exclusion.md),
[k2_primitive_base_scheme_reduction.md](certificates/k2_primitive_base_scheme_reduction.md),
[k2_profile432_proximity_exclusion.md](certificates/k2_profile432_proximity_exclusion.md),
[k2_combined_proper_cluster_exclusion.md](certificates/k2_combined_proper_cluster_exclusion.md),
[k2_basepointfree_degree2_square_exclusion.md](certificates/k2_basepointfree_degree2_square_exclusion.md),
[k2_profile3332_properness_exclusion.md](certificates/k2_profile3332_properness_exclusion.md),
[k2_basepointfree_higher_square_reduction.md](certificates/k2_basepointfree_higher_square_reduction.md),
[k2_basepointfree_quintic_component_exclusion.md](certificates/k2_basepointfree_quintic_component_exclusion.md),
[k2_basepointfree_line_square_reduction.md](certificates/k2_basepointfree_line_square_reduction.md),
[k2_basepointfree_line_square_transformed_bundle_exclusion.md](certificates/k2_basepointfree_line_square_transformed_bundle_exclusion.md),
[k2_isolated_quintic_offbase_exclusion.md](certificates/k2_isolated_quintic_offbase_exclusion.md),
[k2_isolated_line_square_offbase_reduction.md](certificates/k2_isolated_line_square_offbase_reduction.md),
[k2_isolated_line_square_base_aligned_frontier.md](certificates/k2_isolated_line_square_base_aligned_frontier.md),
[k2_isolated_quintic_transverse_base_exclusion.md](certificates/k2_isolated_quintic_transverse_base_exclusion.md),
[k2_isolated_quintic_base_cluster_exclusion.md](certificates/k2_isolated_quintic_base_cluster_exclusion.md),
[k2_isolated_cubic_quartic_component_exclusion.md](certificates/k2_isolated_cubic_quartic_component_exclusion.md),
[k2_isolated_base_retained_profile_exclusion.md](certificates/k2_isolated_base_retained_profile_exclusion.md),
[k2_isolated_degree2_square_exclusion.md](certificates/k2_isolated_degree2_square_exclusion.md),
[k2_remaining_all_proper_adjoint_reduction.md](certificates/k2_remaining_all_proper_adjoint_reduction.md),
[k2_profile3324_one_nonproper_singleton_exclusion.md](certificates/k2_profile3324_one_nonproper_singleton_exclusion.md),
[k2_profile327_one_nonproper_singleton_exclusion.md](certificates/k2_profile327_one_nonproper_singleton_exclusion.md),
[k2_profile327_multiple_nonproper_frontier.md](certificates/k2_profile327_multiple_nonproper_frontier.md),
[k2_profile327_n2_common_support_jet_reduction.md](certificates/k2_profile327_n2_common_support_jet_reduction.md),
[k2_profile327_n2_residual_boundary_exclusion.md](certificates/k2_profile327_n2_residual_boundary_exclusion.md),
[k2_one_nonproper_singleton_offbase_exclusion.md](certificates/k2_one_nonproper_singleton_offbase_exclusion.md),
and
[k2_profile327_nonproper_high_reduction.md](certificates/k2_profile327_nonproper_high_reduction.md).
The failed global shortcuts are retained as a limits audit in
[k1_repeated_root_frontier.md](certificates/k1_repeated_root_frontier.md).
The nested subrow is excluded in
[k1_nested_profile_exclusion.md](certificates/k1_nested_profile_exclusion.md).

## 1. Correction to the all-degree covariant

Let \(L=\{W=0\}\), write

\[
f(U,V,W)=g(U,V)+Wh(U,V)+W^2k(U,V,W),
\]

and put

\[
P_{U,V,W}(u,v)=Ug_u(u,v)+Vg_v(u,v)+Wh(u,v).
\]

With the standard discriminant convention, the identity in the original
specification had the wrong sign.  The correct formula is

\[
\boxed{
\operatorname {Res}_{u,v}(g,P)
-(-1)^{d(d-1)/2}\Delta(g)f=W^2q_f.}
\]

Indeed, if \(g(u,v)=a\prod_i(u-r_iv)\), the root formula gives

\[
\operatorname {Res}(g,P_{U,V,0})
=(-1)^{d(d-1)/2}\Delta(g)g(U,V).
\]

The sign is therefore plus after moving the discriminant term to the left
for \(d\equiv2,3\pmod4\), including the cubic case, and minus for
\(d\equiv0,1\pmod4\), including the quartic case.

The form \(q_f\) has degree \(d-2\) in \((U,V,W)\), and every coefficient
is homogeneous of degree \(2d-1\) in the coefficients of \(f\).  After those
coefficients are replaced by quadrics in \(x\), the residual divisor has
class

\[
T\sim(4d-2)H_x+(d-2)H_y.
\]

For \(d=4\), the checker proves all of the following exactly:

- the identity is \(\operatorname {Res}-\Delta f=W^2q_f\);
- \(q_f\) is a ternary quadric whose six coefficients have coefficient
  degree seven and greatest common divisor one;
- a deterministic substitution by fifteen ternary quadrics produces six
  degree-fourteen coefficients with no common factor;
- a smooth quartic witness has eight distinct residual points, all away from
  \(L\); and
- \(T\sim14H_x+2H_y\), so its degree over \(\mathbf P^2_y\) is \(28\).

These are the D1 gates in `SPEC.md`; see
[`quartic_tangent_residual_checks.py`](certificates/quartic_tangent_residual_checks.py).

## 2. The thirty-six missing centers

Put

\[
S=X\cap(\mathbf P^2_x\times L)
   \subset \mathbf P^2_x\times\mathbf P^1.
\]

Write \(H=\mathcal O_S(1,0)\) and \(F_0=\mathcal O_S(0,1)\).  For
\(d=4\),

\[
H^2=4,\qquad HF_0=2,\qquad F_0^2=0,
\qquad K_S=-H+2F_0.
\]

The tangent line is undefined where all three \(y\)-partials of the equation
vanish.  Euler's identity puts this scheme \(\Gamma\) on \(S\).  On \(S\)
the gradient is a section of the rank-two bundle

\[
\mathcal O_S(2H+3F_0)\oplus\mathcal O_S(2H+2F_0),
\]

so for a general equation it is transverse and

\[
\operatorname {length}(\Gamma)
=(2H+3F_0)(2H+2F_0)=36.
\]

At each point of \(\Gamma\), the plane quartic fiber has an ordinary node,
while \(S\) itself is smooth.  The tangent-map base ideal on \(S\) is the
maximal ideal.  Consequently one ordinary blowup

\[
\mu:\widetilde S=\operatorname {Bl}_{\Gamma}S\longrightarrow S,
\qquad E=\sum_{i=1}^{36}E_i,
\]

resolves the map, and its moving line bundle is

\[
A=2H+3F_0-E.
\]

This is the correction missed by the raw branch estimate in `SPEC.md`.

## 3. The resolved double cover and its branch

Let \(\mathcal K\) be the rank-two tangent-line bundle on \(\widetilde S\),
defined by

\[
0\longrightarrow\mathcal K\longrightarrow
V_y\otimes\mathcal O_{\widetilde S}
\longrightarrow\mathcal O_{\widetilde S}(A)\longrightarrow0.
\]

On \(\mathbf P(\mathcal K)\), with
\(\zeta=c_1(\mathcal O_{\mathbf P(\mathcal K)}(1))\), the quartic equation
has class \(4\zeta+2H\).  It contains twice the marked-point section.
Removing that doubled section leaves

\[
[Z_4]=2\zeta+6H+4F_0-2E.
\]

This is a finite flat double cover of \(\widetilde S\).  Its half-branch
class and branch class are

\[
L_Z=8H+7F_0-3E,
\qquad
\boxed{\widetilde B=2L_Z=16H+14F_0-6E.}
\]

Downstairs, the raw branch has class \(16H+14F_0\) and an ordinary
sixfold point at each of the thirty-six points of \(\Gamma\).  The six
tangent directions are the six simple ramification directions obtained by
projecting the normalization of a general nodal quartic from its node.  The
strict transform is smooth and meets every \(E_i\) transversely in those six
points.  Away from the exceptional curves, vector-bundle Bertini and jet
separation make the residual incidence smooth, including along ordinary
flexes and hyperflexes.

The branch is nonempty and reduced.  A disconnected smooth double cover
would be a disjoint union of two degree-one, hence unramified, covers.
Therefore \(Z_4\) is connected and irreducible.

For clarity, an ordinary flex at the marked point has intersection
\(3p+r\): the residual roots \(p,r\) are distinct, so this is not branch.
Branch on a smooth quartic means \(2p+2r\), or \(4p\) at a hyperflex.

## 4. Exact invariants

On \(\widetilde S\),

\[
K_{\widetilde S}=-H+2F_0+E
\]

and hence

\[
D:=K_{\widetilde S}+L_Z
=7H+9F_0-2E
=2A+3H+3F_0.
\]

The last expression proves that \(D\) is ample: \(H\) is positive on every
nonexceptional curve, while \(A\cdot E_i=1\).  Thus

\[
K_{Z_4}=\pi^*D
\]

is ample.  Intersection theory gives

\[
D^2=304,
\qquad
L_ZD=250,
\]

and the double-cover formulas give

\[
K_{Z_4}^2=608,
\qquad
\chi(\mathcal O_{Z_4})=127.
\]

The geometric genus is not a generic-points subtraction.  The length-thirty-six
scheme \(\Gamma\) is the regular zero scheme of the displayed rank-two
gradient bundle.  The standard resolution of its squared ideal, twisted by
\(7H+9F_0\), is

\[
\begin{split}
0\longrightarrow&
\mathcal O_S(H+F_0)\oplus\mathcal O_S(H+2F_0)\\
\longrightarrow&
\mathcal O_S(3H+3F_0)\oplus
\mathcal O_S(3H+4F_0)\oplus
\mathcal O_S(3H+5F_0)\\
\longrightarrow&I_\Gamma^2(7H+9F_0)\longrightarrow0.
\end{split}
\]

The five spaces of sections have dimensions \(6,9,40,47,54\), and the
needed higher cohomology vanishes.  Therefore

\[
p_g(Z_4)=(40+47+54)-(6+9)=126.
\]

Together with \(\chi=127\), this gives \(q=0\).  Kodaira vanishing and
Riemann--Roch, using the ample canonical divisor, give

\[
P_2(Z_4)=\chi(\mathcal O_{Z_4})+K_{Z_4}^2=735.
\]

The corrected branch itself has genus \(407\): the raw branch has arithmetic
genus \(947\), and the thirty-six ordinary sixfold points remove
\(36\binom62=540\).

All numerical identities and the cohomology dimensions rerun from
[`quartic_residual_cover_invariants.py`](certificates/quartic_residual_cover_invariants.py).
That script deliberately certifies arithmetic only; the transversality and
smoothness statements are proved in the theorem note.

## 5. The limits theorem for all \(d\ge4\)

For general \(d\), let \(n=d-2\).  There are \(12(d-1)\) reduced tangent-map
base points.  After blowing them up, put

\[
A=2H+(d-1)F_0-E.
\]

The smooth residual incidence is finite flat of degree \(n\) over the blown-up
source and has class

\[
[Z_d]=n\zeta+6H+2nF_0-2E.
\]

Adjunction gives

\[
\boxed{
K_{Z_d}
=\bigl((d-4)\zeta+3H+(2d-5)F_0+2A\bigr)|_{Z_d}.}
\]

All four displayed summands are nef.  The \(H\)-term is positive on every
nonexceptional curve, the \(A\)-term is positive on every exceptional curve,
and \(H|_{Z_d}\) is big.  Nakai's criterion therefore makes \(K_{Z_d}\)
ample for every \(d\ge4\).  A useful numerical check is

\[
K_{Z_d}^2=48d^3-91d^2-422d+680.
\]

The discriminant class is

\[
B_n=(n-1)\bigl(2(n+6)H+n(n+5)F_0-(n+4)E\bigr),
\]

and a general fiber over \(L\) has genus

\[
g=(n-1)(2n+11)=(d-3)(2d+7).
\]

For each fixed \(e\), the same computation for a general pair consisting of
\(F\) and an immersive
\(\nu:\mathbf P^1\to\mathbf P^2_y\) of degree \(e\) gives

\[
K_{Z_{d,e}}
=\bigl((d-4)\zeta+3H+(e(2d-3)-2)F_0+2A_e\bigr)|_{Z_{d,e}},
\]

which is again ample.  Thus the generic line, conic, and fixed-degree
parametrized rational-curve versions have general-type total space once
\(d\ge4\).  This smooth general-type conclusion does not cover a special
seed selected from \(F\), or a single Zariski-open set uniform in all \(e\).

There is nevertheless a uniform scheme-level theorem for special seeds.
For one general \(F\), every nonconstant immersive map
\(\nu:\mathbf P^1\to\mathbf P^2_y\) of degree \(e\) gives an lci Gorenstein
residual surface, finite flat of degree \(d-2\) over its tangent-flag base,
with

\[
\boxed{
\omega_{Z_{F,\nu}}
=\mathcal O\bigl(
3H+2J+(d-4)R+(e(2d-3)-2)F_0
\bigr).}
\]

This dualizing sheaf is ample for every such \(\nu\), simultaneously for
the fixed general equation.  The tangent base has only finitely many
base-point fibers: its global critical curve has genus

\[
1+9(d-1)(3d-5)
\]

and maps birationally to its image in \(\mathbf P^2_y\), so no rational seed
can be that image.

This does not yet make every special-seed normalization or resolution
general type.  A special base change can be nonnormal or noncanonical, and
the conductor or negative discrepancies can destroy bigness.  The later
ramification theorem rules out containment in a residual discriminant
component.  The exact remaining input is therefore local canonical-
singularity control for special immersed base changes.  The scheme-level
theorem and the original boundary are proved in
[special_seed_uniform_dualizing_theorem.md](certificates/special_seed_uniform_dualizing_theorem.md).

The double-residual audit sharpens this boundary.  Its global length-four
incidence \(\mathcal M_F\), including the diagonal \(p=r\), is smooth.  For
quartics, its canonical and formal ramification classes give

\[
K_{\mathcal M_F}^2=5400,\qquad
K_{\mathcal M_F}R_h=7740,\qquad
R_h^2=10368,\qquad
p_a(R_h)=9055.
\]

All one-point first-jet ranks are exact.  The saturated multiplier closure
is now the actual ramification scheme; it is smooth, has unique multiplier,
and has finite reduced boundary.  Uniform two-point ranks prove generic
one-to-one mapping.  The middle and bottom multiplier boundary is now
uniformly an ordinary fold/double-cover interaction with nonzero mixed
coefficient.  The former counterfactual \(\gamma=0\) family
\(w^2-z^4+4t^m=0\) would already be noncanonical at \(m=4\); the boundary
theorem excludes it there.  The remaining local problem is the
open-residual fold/cusp and higher-Morin classification and isolated
collisions.  See
[special_seed_stability_frontier.md](certificates/special_seed_stability_frontier.md)
and
[special_seed_boundary_fold_theorem.md](certificates/special_seed_boundary_fold_theorem.md).

The subsequent multijet audit proves why unrestricted Thom transversality
cannot be invoked: two distinct \(x\)-first-jets of \(O(2)\) have rank five,
with kernel the square of their joining line, so the tensorized coefficient
map has rank \(75<90\).  Singularity-specific fold/cusp and two-point rows do
recover the expected ranks on the tested open strata, including the flat
diagonal.  The residual multiplier ideal has now also been saturated
scheme-theoretically through \(\lambda _2=0\).  Its unsaturated ranks
\(7,6,5\) become \(7,7,6\); the saturated normal form is prime, its only
intrinsic boundary singular stratum lies over \([1:0:0]\) and has
transverse rank-four quadric type.  It imposes eight coefficient conditions
over the six-dimensional flag space.  A general equation therefore avoids it, while
the remaining boundary is finite or empty and has no curve component.  The
length-four determinant comparison identifies its image with the smooth
actual ramification curve, and the two-point row-space theorem gives generic
birationality and distinct generic images.  Reduced boundary forces the
mixed coefficient \(\gamma\ne0\) after the boundary-fold theorem supplies
the ordinary fold/double-cover model at every middle and bottom boundary
point.  Uniform open-residual fold/cusp, higher-Morin, and isolated
multiple-value classification remain.  See
[special_seed_multijet_reduction.md](certificates/special_seed_multijet_reduction.md)
and
[special_seed_residual_saturation.md](certificates/special_seed_residual_saturation.md),
and
[special_seed_ramification_comparison.md](certificates/special_seed_ramification_comparison.md).
The boundary normal form and nonzero mixed coefficient are proved in
[special_seed_boundary_fold_theorem.md](certificates/special_seed_boundary_fold_theorem.md).

## 6. Two non-tangent incidences

### Quartic bitangents

Let \(Y=(\mathbf P^2_y)^\vee\), let \(\mathcal K\) be its universal
rank-two subbundle, and put

\[
\mathcal E=\operatorname {Sym}^4\mathcal K^*,
\qquad
\mathcal G=\operatorname {Sym}^2\mathcal K^*.
\]

Squaring gives a relative projected-Veronese embedding

\[
v:\mathbf P_Y(\mathcal G)\hookrightarrow\mathbf P_Y(\mathcal E).
\]

Restriction of \(F\) to the universal line defines a section map from
\(\mathbf P^2_x\times Y\) to \(\mathbf P_Y(\mathcal E)\).  General
parameter transversality makes its inverse image \(B_F\) of the square
surface smooth.  Over a smooth quartic, its fiber is the set of twenty-eight
bitangent lines.

With \(H,J\) pulled back from the two planes and \(\eta\) the quadratic
projective-bundle class, relative adjunction gives

\[
\det N_v=7(\eta+J),
\qquad
2\eta=2H\text{ on }B_F.
\]

Therefore

\[
\boxed{K_{B_F}\equiv4(H+J),\qquad K_{B_F}^2=1728.}
\]

The canonical class is ample.  Marking a root of the quadratic is finite of
degree two over \(B_F\), so every dominating normalization component remains
of general type and maps naturally to \(X\).  This closes the bitangent-point
entry of D3; it does not close compositions built from bitangents.

The full bundle calculation, including

\[
[B_F]=16H^2+32HJ+28J^2
\]

and the genus-\(135\) general line slice, is in
[`certificates/bitangent_incidence_general_type.md`](certificates/bitangent_incidence_general_type.md).

### Flex and Hessian marking in every degree

Let

\[
\mathcal F=\{(p,\ell):p\in\ell\}
\]

be the point-line flag threefold, and consider
\(T=\mathbf P^2_x\times\mathcal F\).  The direct flex incidence is the zero
locus of the rank-three bundle that evaluates \(F_x|_\ell\) on the
length-three divisor \(3p\).  Its Chern roots are

\[
2H+dP,
\qquad
2H+(d-2)P+J,
\qquad
2H+(d-4)P+2J.
\]

The evaluation is fiberwise surjective, so a general equation gives a smooth
surface.  Since \(K_T=-3H-2P-2J\), adjunction yields

\[
\boxed{
K_{I_{F,d}}=3H+(3d-8)P+J,
\qquad
K_{I_{F,d}}^2=9(3d-4)(17d-42).}
\]

The canonical class is ample for every \(d\ge4\).  The incidence has degree
\(3d(d-2)\) over \(\mathbf P^2_x\), maps directly to \(X\) by its marked
flex point, and is not rational.  Thus the direct Hessian/flex marking is
closed throughout Problem D.  The proof and quartic numerical replay are in
[`certificates/flex_incidence_general_type.md`](certificates/flex_incidence_general_type.md).

## 7. The first D4 exclusion: class \((1,0)\)

Every member of \(|H_x|\) is obtained by restricting \(X\) over a line
\(\ell\subset\mathbf P^2_x\):

\[
S_\ell=X\cap(\ell\times\mathbf P^2_y)
\subset\mathbf P^1\times\mathbf P^2.
\]

For a general \((2,4)\) equation, the discriminant curve of the
plane-quartic fibration over \(\mathbf P^2_x\) is irreducible of degree
\(54\) and has only nodes and cusps.  It contains no line.  Restricting the
versal local quartic models to an arbitrary line gives only

\[
uv=z^m,
\]

the corresponding independent two-node models, or a smooth point/an
ordinary double point from the cuspidal model.  Hence every \(S_\ell\) is
integral and normal with only Du Val singularities.

Adjunction gives

\[
\omega_{S_\ell}=\mathcal O_{S_\ell}(0,1),
\qquad h^0(\omega_{S_\ell})=3.
\]

Du Val resolutions are crepant and rational, so the minimal resolution of
every \(S_\ell\) has \(p_g=3\).  It is not rational.  Therefore no divisor
of class \((1,0)\) supplies the rational degree-two multisection sought in
D4.  This theorem and its arbitrary-line local analysis are in
[`certificates/k0_du_val_exclusion_theorem.md`](certificates/k0_du_val_exclusion_theorem.md).

The result is exactly the \(k=0\) boundary.  The next section gives the
separate \(k=1\) analysis.

## 8. The class \((1,1)\) double-decic exclusion

For \(W_\sigma\in|H_x+H_y|\), write the equation of \(X\) as
\(x^tA(y)x\), where \(A\) is a symmetric matrix of quartic forms, and write
the bilinear section as \(\sigma(y)^tx\).  For rank two or three, the
normalized Stein model of \(W_\sigma\) is the connected double plane

\[
w^2=B_\sigma,\qquad
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma,\qquad
\deg B_\sigma=10.
\]

A smooth member would have

\[
(K^2,\chi,p_g,q,P_2)=(8,7,6,0,15).
\]

The canonical double-plane resolution gives an exact rationality table for
every maximal square factor \(B_\sigma=G^2C\).  D-specific incidence
arguments then prove, uniformly over all rank-two and rank-three
\(\sigma\):

- no proper branch point has multiplicity at least six;
- no branch has a squared-line factor; and
- no integral curve of degree one through five divides the branch.

Rank one reduces to the already excluded class \((1,0)\).  These results
remove every square-factor row.  A separate proximity argument forces the
only possible nested \([3,2,2,2]\) local type to be

\[
(r_p,r_q;m_p,m_q)=(5,6;5,5),
\]

with \(p\) proper and \(q\) free first-near.  Restriction to the tangent
line and one transverse line leaves codimension nine after the local
configuration moves, so this profile is absent for both rank orbits.

The line-component incidence also excludes the all-proper six-center subrow.
A second theorem uses the exact local colengths of the simple and doubled
cluster ideals to exclude the entire singleton-root partition
\([1,1,1,1,1,1]\).  A complete classification of the first repeated tree,
followed by a smooth/nodal conic incidence, excludes
\([2,1,1,1,1]\).  Every row left at that stage is an integral squarefree
decic with six essential \(t=2\) centers on at most four proper-origin
trees.  Its complete cluster systems must satisfy

\[
H^0(\mathcal J_D(2))=0,\qquad
H^0(\mathcal J_{2D}(4))=0.
\]

The uniform theorem proves that every essential span is a chain of one of
three word types.  Its local contact is at least the doubled-cluster
colength plus the number of essential centers.  Since the quartic vanishing
forces doubled colength at least fifteen, deleting a terminal unit gives a
unique conic with branch contact at least eighteen.  An exhaustive
parity/unloading audit gives support-line contact at least eleven whenever
that conic doubles, forcing a forbidden line component.  Smooth and reduced
nodal conics have fixed-rank codimensions at least nine and eight.  Hence all
nine remaining root partitions are absent and \(k=1\) is closed.

The table, factor exclusions, and arithmetic replay are in
[k1_double_decic_frontier.md](certificates/k1_double_decic_frontier.md).
The nested exclusion is proved in
[k1_nested_profile_exclusion.md](certificates/k1_nested_profile_exclusion.md).
The line/all-proper and singleton-root exclusions are proved in
[k1_six_proper_centers_exclusion.md](certificates/k1_six_proper_centers_exclusion.md)
and
[k1_singleton_root_exclusion.md](certificates/k1_singleton_root_exclusion.md).
The quintic and five-root results are
[k1_quintic_factor_exclusion.md](certificates/k1_quintic_factor_exclusion.md),
[k1_two_essential_tree_classification.md](certificates/k1_two_essential_tree_classification.md),
and
[k1_two_essential_partition_exclusion.md](certificates/k1_two_essential_partition_exclusion.md).
The first two four-root packages and the uniform closure are
[k1_two_repeated_trees_exclusion.md](certificates/k1_two_repeated_trees_exclusion.md),
[k1_three_essential_tree_pruning.md](certificates/k1_three_essential_tree_pruning.md),
and
[k1_uniform_six_center_conic_exclusion.md](certificates/k1_uniform_six_center_conic_exclusion.md).
The exact obstruction to the raw quintic-adjoint and global-dimension
shortcuts is recorded in
[k1_repeated_root_frontier.md](certificates/k1_repeated_root_frontier.md).

## 9. The class \((1,2)\) double-dodecic frontier

For \(k=2\), a quadratic triple \(\sigma\) gives branch

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma,
\qquad \deg B_\sigma=12.
\]

The smooth double plane has

\[
(K^2,\chi,p_g,q,P_2)=(18,11,10,0,29).
\]

The canonical-resolution correction sum is ten.  Of its seven numerical
profiles, \([2^{10}]\) is excluded by the anti-invariant bicanonical
summand.  The raw arithmetic table then retains six squarefree profiles,
but two are now excluded geometrically.  The squarefree list left by this
arithmetic table and the first geometric exclusions is

\[
\boxed{[4,2^4],\ [3^3,2],\ [3^2,2^4],\ [3,2^7].}
\]

The profile \([5]\) is absent on the whole primitive locus.  Three
concurrent lines give a strict base-point-free incidence margin, while the
isolated-base theorem treats the off-base, multiplicity-two-base, and
proper-simple-base positions of its unique high center.  Independently,
an exhaustive proximity/parity classification proves that no reduced
degree-twelve plane branch has profile \([4,3,2]\): all realizable diagrams
force a doubled line.

On the base-point-free locus, a combined adjoint-cubic argument excludes
\([4,2^4]\) for arbitrary proper or infinitely-near positions of its four
\(t=2\) centers.  A second intrinsic adjoint argument proves that the three
\(t=3\) centers in \([3^3,2]\) must be proper, distinct, and noncollinear;
the triangle incidence therefore excludes that entire base-point-free row.
Deleted-adjoint cubics then exclude \([3^2,2^4]\) whenever all four low
centers are proper, including its proper/free-first-near high-center row.
They also exclude the all-proper \([3,2^7]\) row: reducible adjoint cubics
would force two distinct line/conic branch components, which a uniform
factor-pair incidence forbids.  The original integral cubic/quartic
component exclusions remain in force.

Primitive isolated base schemes are now exhaustive: rank-three nets have
length one, two, three, or \(\mathfrak m_p^2\) base, and rank-two pencils
have a length-four \((2,2)\) complete intersection whose cluster pattern is
either \((1,1,1,1)\), allowing proper or infinitely-near curvilinear
distributions, or one multiplicity-two center.  Every such triple stratum
has dimension at most sixteen.  On its principalization the fixed
exceptional square leaves residual branch class \(12H-2M\).  Simple bases
preserve the smooth starting
invariants \((18,11,10,0,29)\); a multiplicity-two base gives
\((16,10,9,0,26)\).  No isolated-base stratum has an integral conic branch
component.

The square-factor rows \(e=1,\ldots,5\) are absent on the base-point-free locus.
For \(e=2\), doubled integral conics, squares of two distinct lines, and
fourth powers of a line all have strict restriction-incidence margins.
Every degree-three or degree-four square root then either contains an
already excluded integral cubic/quartic component or has a degree-two
divisor.  The same factor routing reduces \(e=5\) to an integral quintic,
and the normalization/gonality incidence excludes every such component.
For \(e=1\), the complete first-neighborhood stratification first leaves a
balanced constant-direction form and an unbalanced high-diagonal form.
Dividing their squared lines produces inverse elementary transforms with
\(c_2=3\) and \(2\), so the settled \(k=1\) theorem cannot simply be reused.
Their complete form spaces have dimensions fifty-two and fifty-six;
proper-triple codimension three and strict degree-one-through-four factor
margins exclude both transformed strata.  Common line and common conic
factors of the triple itself route to the settled
\(k=1\) and \(k=0\) problems.

The resolved-line theorem excludes the isolated-base versions of
\([4,2^4]\) and \([3^3,2]\), reducing the primitive squarefree frontier to
\([3^2,2^4]\) and \([3,2^7]\).  The sequential doubled-line theorem also
extends the \(e=2\) exclusion across every isolated-base stratum.
An isolated-base integral-quintic square root disjoint from the base scheme
is also absent, as is one transverse to a reduced proper base scheme.
The cluster theorem treats the remaining singular proper contact,
infinitely-near simple centers, and multiplicity-two base points.  Hence the
connected isolated-base integral-quintic square-root row is absent.  Its
degree-zero quotient boundary is instead rank two with a disconnected pure
square; no blanket exclusion of quintic components of that pure square is
claimed.  For isolated-base squared lines, the off-base high-diagonal
boundary is absent for a one-point base by transfer to the complete \(k=1\)
form space, and all other off-base rows were already strict.  The sole
off-base survivor is therefore the rank-three two-distinct-point row.  For
lines meeting the base, exactly six cluster positions have nonpositive
margin; every other simple or multiplicity-two position is absent.

The remaining boundary is therefore geometric rather than merely
numerical.  It consists of the unresolved strata of \([3^2,2^4]\) and
\([3,2^7]\); on the base-point-free locus these require respectively an
infinitely-near \(t=2\) center and an infinitely-near essential center.
When all low trees are distinct singletons, the exactly-one-nonproper rows
are absent in both profiles.  In the proper-high \([3,2^7]\) subrow,
doubled adjoints restrict the seven singleton trees to exactly two or three
nonproper lows.  With two, both
nonproper-label-deleted cubics are nonintegral and any survivor has a shared
proper-low line or conic support.  The two-line jet theorem reduces these
supports to rank-zero or reducible-residual boundaries, and the
residual-boundary theorem excludes every one, including the mixed
mismatches.  Thus that entire scoped \(n=2\) singleton row is absent.  With three,
the analogous one-line count has margin zero, and simultaneous
tangent-jet additivity remains open.  Away from an isolated base
support the same one-nonproper exclusions hold; any survivor must align the
base with a selected adjoint cubic or the marked tangent line.  Beyond
these rows, a nonproper \(t=3\) center in \([3,2^7]\) is uniquely a free
first-near successor of a proper \(t=2\) center, with
\((r_p,r_q;m_p,m_q)=(5,6;5,5)\); under the six-singleton hypothesis at
most two of the other lows are nonproper.  The conductor-safe component
incidence excludes every positive-quotient and rank-zero integral cubic or
quartic factor across isolated bases.  Its degree-zero boundary routes to a
disconnected pure square, while the remaining reducible roots route to the
settled degree-two theorem.  Thus, outside these squarefree strata, only the
isolated squared-line row \(e=1\) and combined branch/base clusters remain.  No surviving
stratum is asserted to exist.  The arithmetic ledger and all geometric
sharpenings are in
[k2_double_dodecic_frontier.md](certificates/k2_double_dodecic_frontier.md),
[k2_profile5_three_line_exclusion.md](certificates/k2_profile5_three_line_exclusion.md),
[k2_primitive_base_scheme_reduction.md](certificates/k2_primitive_base_scheme_reduction.md),
[k2_profile432_proximity_exclusion.md](certificates/k2_profile432_proximity_exclusion.md),
[k2_combined_proper_cluster_exclusion.md](certificates/k2_combined_proper_cluster_exclusion.md),
[k2_basepointfree_degree2_square_exclusion.md](certificates/k2_basepointfree_degree2_square_exclusion.md),
[k2_profile3332_properness_exclusion.md](certificates/k2_profile3332_properness_exclusion.md),
[k2_basepointfree_higher_square_reduction.md](certificates/k2_basepointfree_higher_square_reduction.md),
[k2_basepointfree_quintic_component_exclusion.md](certificates/k2_basepointfree_quintic_component_exclusion.md),
[k2_basepointfree_line_square_reduction.md](certificates/k2_basepointfree_line_square_reduction.md),
[k2_basepointfree_line_square_transformed_bundle_exclusion.md](certificates/k2_basepointfree_line_square_transformed_bundle_exclusion.md),
[k2_isolated_quintic_offbase_exclusion.md](certificates/k2_isolated_quintic_offbase_exclusion.md),
[k2_isolated_line_square_offbase_reduction.md](certificates/k2_isolated_line_square_offbase_reduction.md),
[k2_isolated_line_square_base_aligned_frontier.md](certificates/k2_isolated_line_square_base_aligned_frontier.md),
[k2_isolated_quintic_transverse_base_exclusion.md](certificates/k2_isolated_quintic_transverse_base_exclusion.md),
[k2_isolated_quintic_base_cluster_exclusion.md](certificates/k2_isolated_quintic_base_cluster_exclusion.md),
[k2_isolated_cubic_quartic_component_exclusion.md](certificates/k2_isolated_cubic_quartic_component_exclusion.md),
[k2_isolated_base_retained_profile_exclusion.md](certificates/k2_isolated_base_retained_profile_exclusion.md),
[k2_isolated_degree2_square_exclusion.md](certificates/k2_isolated_degree2_square_exclusion.md),
[k2_remaining_all_proper_adjoint_reduction.md](certificates/k2_remaining_all_proper_adjoint_reduction.md),
[k2_profile3324_one_nonproper_singleton_exclusion.md](certificates/k2_profile3324_one_nonproper_singleton_exclusion.md),
[k2_profile327_one_nonproper_singleton_exclusion.md](certificates/k2_profile327_one_nonproper_singleton_exclusion.md),
[k2_profile327_multiple_nonproper_frontier.md](certificates/k2_profile327_multiple_nonproper_frontier.md),
[k2_profile327_n2_common_support_jet_reduction.md](certificates/k2_profile327_n2_common_support_jet_reduction.md),
[k2_profile327_n2_residual_boundary_exclusion.md](certificates/k2_profile327_n2_residual_boundary_exclusion.md),
[k2_profile327_nonproper_high_reduction.md](certificates/k2_profile327_nonproper_high_reduction.md),
and
[k2_one_nonproper_singleton_offbase_exclusion.md](certificates/k2_one_nonproper_singleton_offbase_exclusion.md).

## 10. What remains open

This result closes D1 and gives the expected negative verdict in D2 with
certified invariants.  It also proves the branch-positivity limits theorem
requested in D3 for a fixed line and, degree by degree, for general seed
pairs.  Section 6 closes the direct bitangent-point and flex/Hessian
incidences, Section 7 completes D4 at \(k=0\), Section 8 completes \(k=1\),
and Section 9 gives the exact open \(k=2\) arithmetic/incidence boundary.

It does **not** settle the headline unirationality question.  The following
parts of the original program remain genuinely open:

- other quartic covariants, including osculating and iterated correspondences
  (including compositions built from bitangents or flexes);
- canonical-singularity control for special
  rational seeds (their lci residual schemes already have ample dualizing
  sheaf uniformly, and their actual ramification curve is smooth and
  generically separated with positive-genus images; the middle/bottom
  boundary fold and mixed-\(\gamma\) theorem is complete, while
  open-residual fold/cusp, higher-Morin, and isolated-collision models remain);
- constructions unrelated to the tangent-residual mechanism; and
- the scoped incidences inside the two remaining primitive squarefree \(k=2\)
  profiles, the open isolated-base squared-line row \(e=1\), the combined
  strata, and
  all D4 classes \(k\ge3\).

The double-octic branch classification from Problem B applied only to the
now-settled \(k=0\) numerics; its incidence theorems concern a different
determinant map.  The D-specific double-decic table, factor exclusions, and
uniform conic theorem together settle \(k=1\).

Accordingly, a negative answer for this correspondence must not be stated as
a negative answer for \(X\).  The current conclusion is exact but deliberately
narrow:

\[
\boxed{
Z_d\text{ is of general type for }d\ge4;
\quad
\text{unirationality of a general }X_{2,d}\text{ remains open}.}
\]

## Verification

From the repository root, run

~~~bash
python3 problems/D-2d-conic-bundles/certificates/quartic_tangent_residual_checks.py
python3 problems/D-2d-conic-bundles/certificates/quartic_residual_cover_invariants.py
python3 problems/D-2d-conic-bundles/certificates/bitangent_incidence_invariants.py
python3 problems/D-2d-conic-bundles/certificates/flex_incidence_invariants.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_uniform_dualizing_checks.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_stability_frontier_checks.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_multijet_reduction_checks.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_residual_saturation_checks.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_ramification_comparison_checks.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_boundary_fold_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_double_decic_frontier_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_six_proper_centers_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_singleton_root_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_repeated_root_frontier_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_quintic_factor_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_two_essential_tree_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_two_essential_partition_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_two_repeated_trees_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_three_essential_tree_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_uniform_six_center_conic_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_double_dodecic_frontier_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile5_three_line_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_primitive_base_scheme_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile432_proximity_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_combined_proper_cluster_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_basepointfree_degree2_square_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile3332_properness_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_basepointfree_higher_square_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_basepointfree_quintic_component_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_basepointfree_line_square_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_basepointfree_line_square_transformed_bundle_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_quintic_offbase_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_line_square_offbase_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_line_square_base_aligned_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_quintic_transverse_base_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_quintic_base_cluster_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_cubic_quartic_component_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_base_retained_profile_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_degree2_square_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_remaining_all_proper_adjoint_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile3324_one_nonproper_singleton_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_one_nonproper_singleton_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_multiple_nonproper_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_n2_common_support_jet_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_n2_residual_boundary_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_one_nonproper_singleton_offbase_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_nonproper_high_checks.py
~~~

The first command verifies the universal/specialized quartic covariant and
the eight-point witness.  The second verifies the corrected double-cover
intersection and cohomology arithmetic.  The third checks the bitangent
surface's relative-Veronese class and intersection numbers.  The fourth
checks the all-degree flex formulas and quartic intersection numbers.  The
fifth replays the uniform special-seed adjunction and critical-curve
arithmetic.  The sixth checks the double-residual Chow, ramification, and
first-jet calculations.  The seventh records the restricted-family multijet
rank atlas, the eighth checks the saturated multiplier boundary, the ninth
checks its ramification comparison and two-point ranks, and the tenth checks
the quartic multiplier-boundary fold theorem.  The remaining thirty-seven
replay the class-\((1,1)\) double-decic table,
all-proper, singleton, quintic, repeated-tree, and uniform conic analyses;
the class-\((1,2)\) arithmetic ledger; and all subsequent geometric
sharpenings.  Their exact
outputs are stored beside the scripts as recorded logs.  The first checker
requires SymPy; see
[`certificates/README.md`](certificates/README.md) for the exact recorded
environment and the local interpreter distinction.
