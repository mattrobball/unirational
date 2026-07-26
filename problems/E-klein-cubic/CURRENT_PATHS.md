# Current paths for Problem E

Date: 2026-07-26.

## Verdict

The headline remains **OPEN**:

\[
C\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3,
\]

but the current work does not choose between essential dimensions three and
four.  The calculations below are exact at their stated finite degree or
specialization; none is an all-degree negative solution.

## What the four current attacks established

### 1. Jacobian-zero self-covariants

The complete degree-eleven system is certified. At the good split prime 67
the degree-eleven self-covariant space has dimension 12. The same 640 source
points separate all 509 degree-50 invariants, and the universal Jacobian
coefficients have exact rank 496. All twelve triangular projective charts
return the unit ideal; the two largest take 85.89 and 18.57 seconds. Proper
specialization therefore proves that every nonzero degree-eleven
self-covariant is dominant. Together with the earlier degrees, the
Kraft--Loetscher--Schwarz Jacobian-zero alternative is excluded through
degree eleven only.

The certified degree-eleven envelope is:

```text
self-covariant dimension                 12
coefficient degree of det(Dq)             5
source degree of det(Dq)                 50
dimension of source invariants R_50     509
coefficient quintic monomials          4368
retained exact solver input             35.7 MB
```

Degree twelve has now also been reconstructed completely at the good split
prime 67.  The self-covariant space has dimension 16, the Jacobian has source
degree 55, and the complete coefficient span has rank

```text
dim R_55                                  721
coefficient quintic monomials          15504
retained independent equation rows       721
```

The exact splitting used for the structural attack is

\[
M^{W}_{12}=D^{W}_{12}\oplus P^{W}_{12},\qquad
\dim D^{W}_{12}=12,\quad \dim P^{W}_{12}=4.
\]

The pure primitive locus is empty because its restriction has the full
rank 56 of all quintics in four variables.  All twelve triangular charts of
the decomposable projective locus are unit ideals.  The genuinely mixed
locus is not decided: the gate on the first primitive chart timed out after
600 seconds at a degree-seven matrix of size `104836 x 166810`, which is
worse than the original standard-chart gate.  The other three primitive
charts were therefore not launched.  Thus the KLS Jacobian alternative is
excluded through degree eleven and on the two pure degree-twelve strata, but
degree twelve remains open exactly on the mixed locus.

These are bounded theorems, not an all-degree result. A
characteristic-zero covariant verified to have zero Jacobian would be
headline-positive; a finite-field survivor would only be a lifting
candidate.

There is now also an exact degree-free form of this attack.  Put
\(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\) and
\(P_0=\mathbf C(t_3,t_6,t_8,t_{11})\).  Normalize the generic frame by
\(\tau=f_3^2/f_5\).  Its logarithmic derivative defines a flat connection
\(\nabla\) on \(K_{\rm proj}^5\), and the complete KLS question is

\[
\exists[a]\in\mathbf P^4(K_{\rm proj}):
\det[a,\nabla_1a,\nabla_2a,\nabla_3a,\nabla_4a]=0.
\]

A point proves essential dimension three; universal nonvanishing proves
essential dimension four.  This removes the artificial polynomial-degree
parameter but does not solve the resulting first-order rational PDE.  Finite
module generation gives no cutoff, as an exact \(S_5\) counterexample shows.
The invariant-field infrastructure is no longer missing.  The primaries
\(f_3,f_5,f_6,f_8,f_{11}\) are certified algebraically independent, Adler's
twelve secondaries are certified as a free Hironaka basis, all 78 symmetric
basis products have exact rational reductions, and the normalization by
\(\tau\) gives a checked extension \([K_{\rm proj}:P_0]=12\).  This model
supports exact addition, multiplication, inversion, trace, and norm.  The
four connection matrices are now retained as exact arithmetic circuits in
this model rather than expanded through the tested 1,810,306-term
primitive-element adjugate.  The circuit is backed by 101 frame/structure reductions
and 20 secondary-derivative reductions over \(\mathbf Q\).  At
\((t_3,t_6,t_8,t_{11})=(1,2,3,4)\), the horizontal regular operator has rank
48, the frame determinant is invertible, all 100 specialized matrix entries
are reconstructed exactly, and Leibniz is checked on all 78 field products.
Exact modular-rank certificates exclude all 121 projective constant
directions in \(\{-1,0,1\}^5\) and all 440 ordered Hironaka-linear ansätze
\(e_i\pm b_s e_j\).  The full rational PDE remains unsolved.

Evidence: `tmp/degree10_jacobian/REPORT.md`,
`tmp/degree11_jacobian/REPORT.md`, `tmp/degree12_jacobian/REPORT.md`,
`tmp/degree12_jacobian_structural/REPORT.md`, and
`tmp/kproj_arithmetic/REPORT.md`, with the connection circuit in
`tmp/kproj_connection/REPORT.md` and the all-degree reduction in
`tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`.

### 2. Schur source: the degree-six pencil and rational degree-eight frame

The full rational-coefficient degree-six pencil is closed.  After reduction
modulo 23 its primitive landing cubic is a single exponent-one factor of
total degree 21 and pencil degree three over both \(\mathbf F_{23}\) and
\(\mathbf F_{23^3}\).  Independently, a degree-72 discriminant
specialization factors in degrees 12, 21, and 39, all with exponent one, so
it is nonsquare.  This proves that the primitive cubic
\(F(q_0+tq_1)\) is absolutely irreducible after good reduction and hence has
no root even in \(\mathbf C(V_6)\).

This is stronger than a constant-coefficient pencil calculation.  More
importantly, five explicit degree-eight Reynolds covariants, divided by a
degree-eight invariant, form a basis of the descended Klein five-space over

\[
K=\mathbf C(\mathbf P(V_6))^G.
\]

Thus they give an all-degree normal form for every rational Schur-source map:
this Schur-source path is exactly whether one explicit twisted Klein cubic
has a nonzero \(K\)-point, which would solve the headline. All ten coordinate
lines of this frame are excluded by exact good-reduction factorization, so
any such point must use at least three frame coordinates.  The ten ternary
coordinate planes have now been tested for the full invariant-coefficient
spaces in degrees 0, 4, 6, 8, and 10 and for the five-dimensional degree-12
space \(S_{12}=f_4R_8+\langle f_6^2\rangle\); every one is projectively
empty.  All 90 enlargements \(S_{12}+\langle p_j\rangle\), for the nine
fixed quotient directions in \(R_{12}/S_{12}\), are also empty by exact
Artinian leading ideals.  One two-direction gate is empty, but its measured
cost projects all 360 pair gates to 4.73 hours, so the other 359 were not run.
Those other two-direction slices, all larger quotient-support combinations,
the full \(R_{12}\), higher
coefficient degrees, and four- or five-coordinate points remain open.  These
bounded coefficient-support exclusions are not a negative solution.

The separate constant-coefficient degree-twelve filtration is now exhausted
through primitive support two.  Write \(D_{12}^{V_6}\) for its decomposable
sector (called `D_12` in the artifacts).  Then
\(\dim D_{12}^{V_6}=16\) and \(\dim(M_{12}/D_{12}^{V_6})=32\); exact leading
ideals exclude \(D_{12}^{V_6}\), all 32
\(D_{12}^{V_6}+\langle p_i\rangle\) slices, and all 496
\(D_{12}^{V_6}+\langle p_i,p_j\rangle\) slices.  Thus a landing
covariant must use at least three nonzero primitive coordinates in this fixed
quotient basis.  This basis-dependent support theorem is not emptiness of the
full 48-dimensional landing locus.

The justified transformed chart gate has also been run.  In the exact
\(D_{12}^{V_6}\oplus\langle p_0,\ldots,p_{31}\rangle\) coordinates, the chart
\(p_0=1\) retains all 1,124 equations but times out after 600.877 seconds at
a `44328 x 245460` matrix, slightly worse than the old standard-coordinate
gate.  The remaining 31 transformed charts were therefore not launched.
The length-439 decomposable quotient is available for a future relative
elimination, but any such argument must track monic-reduction and rank-drop
exceptional strata.

Evidence: `tmp/projective_source/REPORT.md`,
`tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`, and
`tmp/ed_binary_attack/PROJECTIVE_PENCIL_AUDIT.md`, together with
`tmp/projective_source_degree12_structural/REPORT.md`,
`tmp/projective_source_degree12_primitive_chart/REPORT.md`, and
`tmp/schur_ternary_planes/REPORT.md`.

### 3. Degree-thirteen and degree-fourteen landing self-covariants

The authoritative result is the independent structural proof, not the
partial direct F4 run.  At the split prime 67, 48 necessary cubics restrict
the support of

\[
M_{13}/fM_{10},\qquad \dim(M_{13}/fM_{10})=11,
\]

to the scalar plane.  Writing a lift as \(q=rx+fh\), both possible
\(f\)-adic branches have exact Artinian leading ideals, with Hilbert
functions

```text
[1,10,55,140,6,0]
[1,10,55,116,3,0].
```

Proper specialization therefore proves that no nonzero degree-thirteen
self-covariant lands in the Klein cone. This is now subsumed into the
degree-fourteen cutoff below.

The direct q67 terminal run now independently corroborates this theorem. It
completed normally in 7,458.060 seconds; its hash-verified leading ideal has
21,674 monomials and contains a pure power of every one of the 21 coefficient
variables. The verifier therefore certifies an Artinian affine cone and an
empty projective landing locus. Its quotient Hilbert function begins
`[1,21,231,1569,6408,7303,26]`; the nonzero degree-six value is compatible
with Artinianness. The earlier partial F4 basis, which leaves 26 standard
classes in degrees six and seven, proves no projective emptiness by itself.

Evidence: `tmp/structural_degree13/REPORT.md` and
`tmp/degree13_opt/REPORT.md`; the superseded partial diagnostic is in
`tmp/degree13_step2/REPORT.md`.

Degree fourteen is now closed by its structural successor at the same split
prime 67.  The quotient \(M_{14}/fM_{11}\) has dimension 14, and its complete
rank-64 landing-equation span is supported on the two-dimensional scalar
subspace: all twelve normal-complement Rabinowitsch systems are unit ideals.
For the two lift branches, the degree-11 landing ideal has Hilbert function
`[1,12,78,253,76,0]`, while the normalized tangent image
\(T(h)=fh-A_hx\) has Hilbert function `[1,12,78,233,34,0]`.
Both are Artinian. Proper specialization therefore excludes landing
self-covariants through degree fourteen; degree fifteen is now the first
unrestricted homogeneous landing degree.

Evidence: `tmp/degree14_structural/REPORT.md`.

### 4. The `xCD` Kummer/3-descent route

The characteristic-zero plane cubic

\[
F(ax+bC+cD)=0
\]

is explicit in ten coefficient polynomials (1,256 terms in total), with exact
universal \(c_4,c_6\) and Jacobian formulas.  The exact rank-12 arithmetic
model of \(K_{\rm proj}\) now decomposes all ten coefficients and computes
the full characteristic-zero discriminant.  Over this field the genuine
rank-nine \(E[3]\) algebra is installed as

\[
\mathcal R=K_{\rm proj}\times
K_{\rm proj}[x,y]/(\psi_3(x),y^2-x^3-Ax-B),
\]

with the group, difference, and normalized Kummer-function formulas kept
distinct from the flex torsor.  This completes the generic algebraic
presentation, but not the torsor's class representative.

At \(s=1\), an independent exact control fiber includes all nine \(E[3]\)
points, the distinct flex torsor, the true degree-12 three-flex-line algebra
with Frobenius orbit degrees `4+8`, its incidence and norm identities, and a
positive cube witness.  That fiber has a rational flex, so its Kummer class is
trivial and it cannot validate a nonzero generic class.  The lower-height
degree-86 non-coordinate specialization has a nonzero flex class; only its
frozen Magma L-function and 2-Selmer jobs remain unrun.  Separately, a low-height
coordinate-line plane over \(\mathbf F_{23}(t)\) has a rational point
\(O=[1:0:1]\) and an absolutely irreducible degree-nine flex cover.  Its flex
class is therefore nonzero but abstractly Kummer, equal to \(\delta(Q)\) for
\(Q=[H-3O]\), where \(H\) is a hyperplane section.  No explicit coordinates
for \(Q\) in the saved Jacobian model, translation algebra, determinant representative, or \(G(Q)\)
comparison were produced; a 30-second generic translation-matrix probe timed
out before a degree marker.

The descent audit identifies the remaining conceptual requirements that
cannot be skipped:

1. the flex-torsor algebra is not the coordinate algebra of \(E[3]\).  The
   correct first-Kummer class is
   \(\alpha_{\mathcal R}=\det(M_T)\bmod \mathcal R^{\times3}\), where
   \(M_T\in\operatorname{GL}_3(\mathcal R)\) is a Galois-equivariant lift of the
   projective translation action of \(T\in E[3]\) on the plane cubic.  The
   universal matrix \(M_T\), hence the generic \(\alpha_{\mathcal R}\), is still
   missing;
2. the degree-twelve algebra of lines through triples of flexes is certified
   only in the \(s=1\) control.  The generic twisted algebra, line forms, and
   normalization constants are still required for true second descent.

The former invariant-field blocker is closed.  Exact primitive formulas for
all four formerly missing generators are installed, and the following items
are now certified:

```text
algebraic independence of f3,f5,f6,f8,f11
the rank-12 Hironaka basis over
  A = C[f3,f5,f6,f8,f11]
the complete 12 by 12 multiplication table
the tau=f3^2/f5 normalization giving [K_proj:P0] = 12.
```

This supplies honest addition, inversion, trace, and norm in
\(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\).  Factoring in the ambient
660-fold cover \(\mathbf C(\mathbf P(W))\) cannot substitute for it.
Positive-only candidate searches may also proceed directly in the ambient
field: one may
compute in \(\mathbf Q(\zeta_{11})(w_0,\ldots,w_4)\), then certify a proposed
point by checking the coordinate ratios under the exact group generators and
verifying the cleared cubic identity.  What cannot be made there is an
exhaustive negative or a factorization claim over \(K_{\rm proj}\).

Evidence: `tmp/xcd_descent_algebra/REPORT.md`,
`tmp/xcd_descent_math/REPORT.md`, `tmp/kproj_arithmetic/REPORT.md`, and
`tmp/xcd_genuine_descent/REPORT.md`, with the nonzero Kummer control in
`tmp/xcd_nonzero_kummer/REPORT.md` and the reconstructed generators in
`tmp/xcd_invariant_field/f10_probe/REPORT.md`.

All four attacks now converge on a canonical arithmetic boundary.  For the
generic projective torsor over
\(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\), let \(C_{\rm gen}\) be the Klein
twist.  Then

\[
\operatorname{ed}(G)=3\iff C_{\rm gen}(K_{\rm proj})\ne\varnothing,
\qquad
\operatorname{ed}(G)=4\iff C_{\rm gen}(K_{\rm proj})=\varnothing.
\]

Every Klein twist has index one from the cycle degrees \(60,132,165,220\),
but no audited point theorem applies.  All prime-local essential dimensions
are at most two, and the standard Brauer, Amitsur, and stable-cohomology
packages checked here do not distinguish the two cases.  This strict ledger
is in `tmp/step4_essential_dimension/REPORT.md`.

## Ranking A: fastest exact next computations

1. **A theoretically motivated nonconstant connection ansatz.**  The four
   \(\Gamma_r\) circuits are complete.  Exactly 561 literal constant and
   one-Hironaka-basis two-coordinate ansätze are excluded.  Use
   the circuit directly on a structural rational-function family or in a
   differential-algebraic argument; further ad hoc finite sampling is not
   justified.  A positive exact point has headline force; failure of another
   bounded ansatz does not.
2. **A genuine `xCD` class representative on the low-height control.**
   First compute \(Q_{\rm ctl}=[H-3O]\) in the saved Jacobian model of the
   characteristic-23 coordinate-line control.  Let
   \(\mathcal R_{\rm ctl}=\operatorname{Map}_{\mathbf F_{23}(t)}
   (E[3],\overline{\mathbf F_{23}(t)})\).  Then build its Galois-equivariant
   \(\operatorname{GL}_3(\mathcal R_{\rm ctl})\) translation lift
   \(M_{T,\rm ctl}\) and compare \(\det(M_{T,\rm ctl})\) with the genuine
   Kummer evaluation \(G(Q_{\rm ctl})\).  This
   is the smallest exact validation of the cocycle-to-Kummer machinery before
   attempting the generic characteristic-zero class.
3. **Relative elimination for one mixed degree-twelve locus.**  Both the KLS
   Jacobian and constant Schur calculations have run their authorized
   transformed gates, and both gates worsened.  Resume either only with a
   certified relative/Fitting or monic-elimination argument that tracks the
   exceptional strata.  Do not launch the remaining three Jacobian or 31
   Schur charts unchanged.
4. **Pfaffian degree sixteen only after a structural reduction.**  The
   existing 80-variable, 1,313-quadratic run timed out without a leading
   ideal.  Repeating the same envelope with a longer clock is less promising
   than changing variables or exploiting the quaternionic-Hermitian model.

The completed q67 degree-thirteen terminal job is not ranked because it has
now corroborated a bounded locus already decided by the structural proof.
The structural degree-fourteen quotient and both lift branches are also no
longer ranked because their exact exclusion is complete.
The 496 degree-twelve two-primitive slices are likewise no longer ranked:
their exact scan is complete and raises the fixed-basis primitive-support
lower bound from two to three.
The unchanged homogeneous degree-twelve solve and the 48 standard-coordinate
chart sweep are also no longer ranked: the terminal audit proves that more
source sampling cannot enlarge the equation span, the saved F4 rounds are not
resumable, and the tested charts retain the same computational bottleneck.

## Ranking B: strategic headline leverage

1. **Attack the exact flat-connection KLS equation.**  The rank-12 Hironaka
   arithmetic and the checked circuit form of the four matrices \(\Gamma_r\)
   are certified.  Seek a rational point of
   \(\mathcal J_\nabla=0\), or a theorem proving universal nonvanishing.
   Degree 12 remains a useful bounded candidate search, not a route to a
   negative conclusion by itself.
2. **Finish honest generic `xCD` descent and point searches.**  Construct the
   exact generic translation lifts and hence \(\alpha_{\mathcal R}\), then the generic
   twisted three-flex-line algebra, line forms, and constants.  A point in this plane
   immediately solves the headline.  Nonmembership for this one plane would
   close only that plane, so a negative result must not be promoted to the
   full cubic.
3. **Solve a ternary (or larger) support in the rational degree-eight Schur
   frame.**  Any nonzero \(K\)-point on its explicit twisted Klein cubic gives
   a rational equivariant map \(\mathbf P(V_6)\dashrightarrow C\) and solves
   the headline.  The frame is exhaustive in all degrees and its ten binary
   supports are closed.  The bounded ternary coefficient envelopes through
   \(S_{12}+\langle p_j\rangle\) are also closed; the remaining problem is
   an unrestricted invariant-field point, not another low-degree null scan.
4. **Use the Pfaffian Hermitian model structurally.**  A theorem producing a
   common isotropic quaternionic line has headline leverage.  Another finite
   covariant exclusion does not.

## Deprioritized work

- Use the completed hash-verified q67 artifact; the earlier live log and the
  26-class partial degree-thirteen F4 certificate were not proofs by
  themselves.
- Do not spend the next cycle rerunning the same 80-variable Pfaffian solve.
- Do not resample the complete characteristic-23 degree-twelve Schur equation
  span, rerun either homogeneous/transformed 600-second job, or launch the
  remaining standard or primitive affine charts without a structural change.
- Do not launch the remaining 359 Schur ternary two-direction slices: the
  exact gate projects the sweep to 4.73 hours and no symmetry quotient is
  certified.
- Do not launch the other three mixed degree-twelve Jacobian charts after the
  first transformed gate worsened the terminal matrix.
- Do not treat a rank or point result on an \(\mathbf F_{23}(s)\) source line
  as transferring to the characteristic-zero generic plane.
- Do not use the flex-torsor algebra as if it were the \(E[3]\) algebra.
- Do not expect finite generation of covariants to supply an all-degree
  cutoff; the exact module audit and the installed \(S_5\) counterexample
  rule out that shortcut.

## Fast replay

The commands below replay the local research state and require the ignored
2.4 GB `tmp/` artifact tree. They are not expected to work in a fresh clone;
use the commands in `certificates/README.md` for the portable checked-in
subset.

```sh
python3 tmp/degree10_jacobian/verify_outputs.py
python3 tmp/degree11_jacobian/verify_outputs.py
python3 tmp/degree12_jacobian/verify_outputs.py --require-gate
python3 tmp/degree12_jacobian_structural/verify.py
python3 tmp/degree12_jacobian_structural/verify_decomposable_cover.py
python3 tmp/degree12_jacobian_structural/verify_mixed_gate.py
python3 tmp/ed_binary_attack/verify_all_degree_module_pde.py
python3 tmp/step4_essential_dimension/verify_reductions.py
python3 tmp/kproj_arithmetic/verify.py
python3 tmp/kproj_connection/verify.py
python3 tmp/projective_source/verify_degree6_geometric_factor.py
python3 tmp/projective_source/degree8_rational_frame.py
python3 tmp/projective_source/degree8_frame_line_probe.py
python3 tmp/projective_source/primitive_degree12/verify.py
python3 tmp/projective_source_degree12_structural/verify_decomposable.py
python3 tmp/projective_source_degree12_structural/verify_primitive_one_slices.py
python3 tmp/projective_source_degree12_structural/verify_primitive_two_slices.py
python3 tmp/projective_source_degree12_extension_independent/verify.py
python3 tmp/projective_source_degree12_extension_independent/landing_verify.py
python3 tmp/projective_source_degree12_extension/verify_landing.py
python3 tmp/projective_source_degree12_chart_probe/audit_and_probe.py --verify
python3 tmp/projective_source_degree12_primitive_chart/verify.py
python3 tmp/projective_source_degree12_primitive_chart/analyze_relative.py
python3 tmp/schur_ternary_planes/verify.py
python3 tmp/schur_ternary_planes/one_primitive/verify.py
python3 tmp/d12_solver_strategy/verify.py
python3 tmp/step4_degree12_solver_terminal/verify_terminal.py
python3 tmp/structural_degree13/verify.py
python3 tmp/degree13_step2/verify_certificate.py
python3 tmp/degree13_opt/verify_q67_terminal.py
python3 tmp/degree11_feasibility/audit.py
python3 tmp/degree14_feasibility/audit.py
python3 tmp/degree14_structural/verify.py
python3 tmp/xcd_invariant_field/presentation_audit.py
python3 tmp/xcd_invariant_field/f10_probe/verify.py
python3 tmp/xcd_descent_algebra/verify_xcd.py
python3 tmp/xcd_descent_math/verify_fiber_flex_algebra.py
python3 tmp/xcd_descent_math/verify_hesse_norms.py
PYTHONPATH=tmp/xcd_genuine_descent python3 tmp/xcd_genuine_descent/verify.py
python3 tmp/xcd_nonzero_kummer/verify.py
python3 tmp/xcd_magma_rank_audit/verify_audit.py
python3 tmp/xcd_low_height/verify.py
```

The terminal degree-thirteen verifier checks the completed output, input and
output hashes, and the pure-power Artinianness certificate.
