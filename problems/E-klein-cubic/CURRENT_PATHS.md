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

This is a bounded theorem, not an all-degree one. A characteristic-zero
covariant verified to have zero Jacobian would be headline-positive; a
finite-field survivor would only be a lifting candidate. Degree 12 is the
first unresolved KLS Jacobian degree.

There is now also an exact degree-free form of this attack.  With
\(K=\mathbf C(\mathbf P(W))^G\), normalize the generic frame by
\(\tau=f_3^2/f_5\).  Its logarithmic derivative defines a flat connection
\(\nabla\) on \(K^5\), and the complete KLS question is

\[
\exists[a]\in\mathbf P^4(K):
\det[a,\nabla_1a,\nabla_2a,\nabla_3a,\nabla_4a]=0.
\]

A point proves essential dimension three; universal nonvanishing proves
essential dimension four.  This removes the artificial polynomial-degree
parameter but does not solve the resulting first-order rational PDE.  Finite
module generation gives no cutoff, as an exact \(S_5\) counterexample shows.
The next concrete infrastructure is the rank-12 Hironaka multiplication table
and the four connection matrices.

Evidence: `tmp/degree10_jacobian/REPORT.md` and
`tmp/degree11_jacobian/REPORT.md`, with the all-degree reduction in
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
any such point must use at least three frame coordinates. Ternary,
four-coordinate, and five-coordinate points remain open; the line exclusions
are not a negative solution.

The separate constant-coefficient degree-twelve filtration is now exhausted
through primitive support two.  Here `dim D_12=16` and
`dim(M_12/D_12)=32`; exact leading ideals exclude `D_12`, all 32
`D_12+<p_i>` slices, and all 496 `D_12+<p_i,p_j>` slices.  Thus a landing
covariant must use at least three nonzero primitive coordinates in this fixed
quotient basis.  This basis-dependent support theorem is not emptiness of the
full 48-dimensional landing locus.

Evidence: `tmp/projective_source/REPORT.md`,
`tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`, and
`tmp/ed_binary_attack/PROJECTIVE_PENCIL_AUDIT.md`, together with
`tmp/projective_source_degree12_structural/REPORT.md`.

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

is now explicit in ten coefficient polynomials (1,256 terms in total), with
exact universal \(c_4,c_6\) and Jacobian formulas.  A fixed line over
\(\mathbf F_{23}(s)\) has an exact primitive-element presentation of its
degree-nine flex-torsor algebra and is everywhere locally soluble.  Full
function-field multiplication serialization stalled at denominator
inversion;
the completed \(9\)-by-\(9\) packet is only the \(s=1\) control fiber, whose
rational flex makes its class trivial.  The public L-function computation
timed out,
and the independent 2-Selmer submission returned HTTP 504; both are strict
nonverdicts.  A lower-height line reduces the expected L-polynomial degree
from 116 to 86 and retains a nonzero flex class, but its Magma inputs are
unrun and any answer would remain specialization-only.

The descent audit identifies two conceptual requirements that cannot be
skipped:

1. the flex-torsor algebra is not the coordinate algebra of \(E[3]\), so the
   genuine first-Kummer equation still requires the latter algebra and a
   representative of the flex class in it;
2. a true second 3-descent also requires the degree-twelve algebra of lines
   through triples of flexes, not only tangent forms in the flex algebra.

An exhaustive calculation over the actual base field is additionally blocked
by missing invariant-field arithmetic. Exact primitive formulas for all four
formerly missing generators are now installed; the remaining finite
prerequisite is:

```text
certify algebraic independence of f3,f5,f6,f8,f11
certify the rank-12 Hironaka basis over
  A = C[f3,f5,f6,f8,f11]
compute and verify its 12 by 12 multiplication table
normalize by tau=f3^2/f5 to obtain K_proj/P0 of degree 12.
```

This produces honest addition, inversion, trace, and norm in
\(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\).  Factoring in the ambient
660-fold cover \(\mathbf C(\mathbf P(W))\) cannot substitute for it.
Positive-only candidate searches need not wait for the full table: one may
compute in \(\mathbf Q(\zeta_{11})(w_0,\ldots,w_4)\), then certify a proposed
point by checking the coordinate ratios under the exact group generators and
verifying the cleared cubic identity.  What cannot be made there is an
exhaustive negative or a factorization claim over \(K_{\rm proj}\).

Evidence: `tmp/xcd_descent_algebra/REPORT.md`,
`tmp/xcd_descent_math/REPORT.md`, and
`tmp/xcd_invariant_field/REPORT.md`, with the reconstructed generators in
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

1. **Degree-twelve Jacobian-zero system, only with a structural plan.**
   Degree eleven is now closed. Degree twelve is the first unresolved KLS
   degree, but another finite chart calculation remains only a bounded
   theorem; prioritize the all-degree connection equation below or a positive
   candidate over a blind size increase.
2. **A transformed primitive-chart pilot for Schur degree twelve.**  The
   direct 48-variable route has reached a certified stopping rule.  The full
   coefficient-polynomial span over \(\mathbf F_{23}\) has rank 1,124, but
   the exact homogeneous run has no resumable basis, and exact 120-second
   probes on two affine charts reproduce its first
   \(36595\times244805\) degree-four bottleneck.  All 48 standard chart
   leading-cubic restrictions still have rank 1,124, so a standard chart
   sweep is not a reduction.  The only justified bounded successor is first
   to change to the exact decomposition
   \(M_{12}=D_{12}\oplus\langle p_0,\ldots,p_{31}\rangle\).  Since the
   landing locus in \(D_{12}\) is empty, the 32 primitive-coordinate charts
   cover any possible landing point.  Run one transformed chart as a gate;
   scale only if its exact trace is materially smaller.  Otherwise stop and
   pursue elimination of the 16 decomposable variables.  See
   `tmp/step4_degree12_solver_terminal/REPORT.md` and
   `tmp/projective_source_degree12_chart_probe/REPORT.md`.
3. **Pfaffian degree sixteen only after a structural reduction.**  The
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

1. **Build exact \(K_{\rm proj}\) arithmetic, then run honest generic
   `xCD` descent and point searches.**  A point in this plane immediately
   solves the headline, and the invariant-field implementation is reusable
   in all generic-frame searches.  Nonmembership for this one plane would
   close only that plane, so a negative result must not be promoted to the
   full cubic.
2. **Attack the exact flat-connection KLS equation.**  First certify the
   rank-12 Hironaka multiplication table and express the four matrices
   \(\Gamma_r\) in that basis.  Then seek a rational point of
   \(\mathcal J_\nabla=0\), or a theorem proving universal nonvanishing.
   Degree 12 remains a useful bounded candidate search, not a route to a
   negative conclusion by itself.
3. **Solve a ternary (or larger) support in the rational degree-eight Schur
   frame.**  Any nonzero \(K\)-point on its explicit twisted Klein cubic gives
   a rational equivariant map \(\mathbf P(V_6)\dashrightarrow C\) and solves
   the headline.  The frame is exhaustive in all degrees and its ten binary
   supports are closed, so the next meaningful search starts with its ten
   coordinate planes rather than with more constant-coefficient null scans.
4. **Use the Pfaffian Hermitian model structurally.**  A theorem producing a
   common isotropic quaternionic line has headline leverage.  Another finite
   covariant exclusion does not.

## Deprioritized work

- Use the completed hash-verified q67 artifact; the earlier live log and the
  26-class partial degree-thirteen F4 certificate were not proofs by
  themselves.
- Do not spend the next cycle rerunning the same 80-variable Pfaffian solve.
- Do not resample the complete characteristic-23 degree-twelve Schur equation
  span, rerun the same homogeneous 600-second job, or launch the remaining
  standard affine charts without a structural change.
- Do not treat a rank or point result on an \(\mathbf F_{23}(s)\) source line
  as transferring to the characteristic-zero generic plane.
- Do not use the flex-torsor algebra as if it were the \(E[3]\) algebra.
- Do not expect finite generation of covariants to supply an all-degree
  cutoff; the exact module audit and the installed \(S_5\) counterexample
  rule out that shortcut.

## Fast replay

```sh
python3 tmp/degree10_jacobian/verify_outputs.py
python3 tmp/degree11_jacobian/verify_outputs.py
python3 tmp/ed_binary_attack/verify_all_degree_module_pde.py
python3 tmp/step4_essential_dimension/verify_reductions.py
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
python3 tmp/xcd_magma_rank_audit/verify_audit.py
python3 tmp/xcd_low_height/verify.py
```

The terminal degree-thirteen verifier checks the completed output, input and
output hashes, and the pure-power Artinianness certificate.
