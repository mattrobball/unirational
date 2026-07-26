# Problem E handoff

## Headline

The problem remains **OPEN**. Do not reinterpret the essential-dimension
equivalence, generic-twist frame, or bounded covariant search as a binary
resolution.

The current two-axis ranking and the four-path audit are in
[`CURRENT_PATHS.md`](CURRENT_PATHS.md).

## Strongest proved progress

1. [RESOLUTION.md](RESOLUTION.md) proves

   \[
   C\text{ is }G\text{-unirational}
   \quad\Longleftrightarrow\quad
   \operatorname{ed}_{\mathbf C}(G)=3.
   \]

   Thus a negative answer is equivalent to essential dimension four. The
   proof uses Prokhorov's two-model classification, the twisted Pfaffian
   bridge, its index-at-most-two Brauer class, and quadratic descent for
   points on cubics.

   Canonically, if \(C_{\rm gen}\) is the generic projective-torsor twist over
   \(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\), then essential dimension three
   is equivalent to \(C_{\rm gen}(K_{\rm proj})\ne\varnothing\), and value four
   is equivalent to emptiness. Every Klein twist has index one from the orbit
   degrees \(60,132,165,220\), but no audited theorem turns that zero-cycle
   into a point. See `tmp/step4_essential_dimension/REPORT.md`.

2. `certificates/` gives exact cyclotomic matrices, checks the complete
   660-element action and Klein cubic invariance, and computes exact Molien
   dimensions.

3. The primitive covariants \(x,C,D,E,K\) of degrees \(1,4,5,6,7\) form a
   generic frame. Their determinant is \(-295136920\) at
   \((-2,-2,-2,-2,-1)\). Hence

   \[
   M=[x\ C\ D\ E\ K]
   \]

   explicitly trivializes the generic twisted ambient five-space and writes
   its cubic as \(F(Ma)=0\) over \(\mathbf C(W)^G\).

   Every one of the ten frame coordinate lines has also been excluded: the
   multivariate polynomial \(F(U+tV)\) has absolutely irreducible good
   reduction over \(\mathbf F_2\) and \(\mathbf F_8\). Hence its cubic in
   \(t\) is irreducible over \(\mathbf C(W)\) and has no rational-function
   root. Thus a frame point must use at least three coordinates.

4. Exact characteristic-zero and good-reduction certificates exclude every
   homogeneous polynomial self-covariant \(W\to W\) landing in \(C\) through
   degree **14**. Degree ten and eleven use dynamically regenerated
   Macaulay2 ideals. Degree twelve reconstructs a 16-dimensional basis and
   143 independent sampled necessary landing cubics; an exact `msolve`
   Gröbner basis has quotient Hilbert function zero in degree five. Degree
   thirteen uses the quotient \(M_{13}/fM_{10}\): 48 necessary cubics force
   the scalar plane, after which exact degree-ten and tangent Hilbert
   functions kill both lifts. Degree fourteen similarly reduces the
   14-dimensional quotient to its scalar line with twelve unit
   Rabinowitsch systems; its two 12-variable branch Hilbert functions vanish
   in degree five. See `tmp/structural_degree13/REPORT.md` and
   `tmp/degree14_structural/REPORT.md`.

5. All ten three-column frame sections are smooth geometrically integral
   plane cubics. A complete good-reduction audit excludes every
   invariant-polynomial landing ansatz in those planes in total degrees
   **11--14**. This closes factor/node shortcuts and a finite degree range; it
   does not show that the plane cubics lack \(K_0\)-points. Their degree-nine
   flex schemes are also geometrically irreducible, so none has a rational
   flex; an ordinary rational point can still exist without one.

6. The all-degree self-covariant module becomes exactly free on
   \(x,C,D,E,K\) after localizing at their determinant. Thus a full module
   presentation leaves precisely the same generic cubic \(\Phi=0\); it does
   not create a finite degree bound.  After normalizing by
   \(\tau=f_3^2/f_5\), the KLS problem is exactly the degree-free equation
   \(\det[a,\nabla_1a,\ldots,\nabla_4a]=0\) on
   \(\mathbf P^4(\mathbf C(\mathbf P(W))^G)\) for the flat connection defined
   by the generic frame.  No solution or universal-nonvanishing theorem is
   known.  The field arithmetic needed to make this explicit is certified:
   the five primaries are algebraically independent, Adler's twelve
   secondaries form a free Hironaka basis, the full multiplication table is
   checked, and the \(\tau\)-normalized degree-12 model implements exact
   addition, inversion, trace, and norm.  The four \(\Gamma_r\) are compiled
   as exact arithmetic circuits backed by 121 characteristic-zero reduction
   identities.  Their exact specialization verifies the horizontal rank 48,
   frame-determinant inverse, all 100 matrix entries, all twelve basis
   derivatives, and Leibniz on 78 products.  Rank certificates exclude 121
   projective constant and 440 ordered Hironaka-linear ansätze, with no
   survivor; the universal PDE remains open.  All 15 canonical
   gradient-cross-product covariants from the explicit
   invariants of degrees 3--9 also fail to land. See
   `tmp/kproj_arithmetic/REPORT.md`, `tmp/kproj_connection/REPORT.md`,
   `tmp/covariant_module/REPORT.md`, and
   `tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`.

7. The nonsplit Pfaffian branch has been reduced to five simultaneous
   quaternionic-Hermitian isotropy equations on \(D^3\). The ambient
   \(D\)-projective plane is rational, but the section has no automatic point,
   and its quaternion class remains nonsplit over its function field. Matched
   polynomial covariants into the \(F_{14}\) cone are excluded only through
   degree **15**. The full 80-dimensional degree-16 space and 1,313 necessary
   quadrics are reconstructed, but the exact solver timed out without a
   leading ideal. There is no all-degree cutoff; degree 16 remains open.

8. Every complex orbit on \(C\) has length at least 60. Exact chord and
   subgroup-lattice checks show that the natural \(C_{11},C_5,V_4,C_3\)
   fixed configurations cannot be collapsed by an equivariant binary
   residual-intersection tree. The 220-point orbit also has no containing
   divisor through degree four, and its first complete-intersection link only
   increases degree. These are finite-construction no-gos, not an exclusion
   of continuous covariants.

9. Let \(V_6\) be the Schur representation of
   \(\operatorname{SL}_2(11)\). Any rational \(G\)-map
   \(\mathbf P(V_6)\dashrightarrow C\) is automatically dominant and solves
   the headline: every twisted source has index at most two, and a resulting
   quadratic point on the cubic descends by third intersection. Complete
   constant-coefficient landing loci are empty in degrees **4, 6, 8, 10**.
   The exact degree-10 ideal has rank 470 and Hilbert function
   \([1,21,231,1301,889,0]\). Arbitrary rational coefficient ratios are
   described exhaustively by a five-vector degree-eight frame. Its full
   degree-six pencil and all ten rational coordinate lines are excluded.  On
   the ten ternary planes, all invariant-coefficient ansätze through degrees
   0, 4, 6, 8, and 10, the degree-12 space \(S_{12}\), and all 90 spaces
   \(S_{12}+\langle p_j\rangle\) are excluded.  One two-direction gate is
   also empty; its measured cost stopped the other 359.  Unrestricted ternary
   and larger rational supports remain open. In degree 12 the
   16-dimensional decomposable sector \(D_{12}^{V_6}\), all
   decomposable-plus-one-primitive
   slices, and all 496 decomposable-plus-two-primitive slices are excluded;
   equivalently, a landing point needs at least three primitive coordinates
   in that fixed quotient basis. In a fixed complete 48-vector Reynolds basis every
   coordinate support of size at most five is excluded. Quadratic-extension
   unisolvence now proves that the complete characteristic-23 landing-equation
   span has rank 1,124, and a hash-verified 1,124-row base-field solver input
   is installed. Its 600-second exact solve timed out during the second
   degree-four matrix with a zero-byte leading file. This equation-rank
   theorem is not a projective-emptiness theorem; degree 12 remains open. A
   terminal audit now proves that further characteristic-23 sampling cannot
   enlarge the span, that the saved F4 rounds contain no resumable basis, and
   that all 48 standard affine charts retain rank 1,124 in their cubic leading
   parts. Exact probes on charts 0 and 47 reproduce the same
   \(36595\times244805\) degree-four bottleneck. Hence no identical retry or
   standard-chart sweep is justified without a structural or solver-level
   change.  The transformed decomposable-plus-primitive gate \(p_0=1\) also
   times out, at `44328 x 245460` on a worse trajectory, so the other 31
   transformed charts are stopped.  The length-439 decomposable quotient is
   only an anchor for relative elimination with exceptional strata, not a
   mixed-locus theorem. See
   `tmp/projective_source/REPORT.md`,
    `tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`,
    `tmp/schur_ternary_planes/one_primitive/REPORT.md`, and the reports
   under `tmp/projective_source_degree12*` and
   `tmp/step4_degree12_solver_terminal/REPORT.md`.

10. Kraft--Loetscher--Schwarz give the exact alternative
    \(\operatorname{ed}(G)=3\) iff a nonzero homogeneous self-covariant
    \(W\to W\) has identically zero Jacobian. Complete exact checks show every
    such covariant through degree **11** is dominant; no degree cutoff is
    known. The degree-11 certificate reconstructs the full 12-dimensional
    space, proves same-point unisolvence on all 509 degree-50 invariants,
    obtains the complete rank-496 Jacobian-quintic span, and finds unit ideals
    on all twelve charts of \(\mathbf P^{11}\). See
    `tmp/degree10_jacobian/REPORT.md` and
    `tmp/degree11_jacobian/REPORT.md`.  Degree twelve is reconstructed
    completely: \(\dim M_{12}=16\), and the universal coefficient span has
    rank 721 in 15,504 quintic monomials.  In the exact 12+4
    decomposable/primitive splitting, both pure projective strata are empty.
    The first genuinely mixed chart times out at `104836 x 166810`, so the
    other three were not launched.  Degree twelve remains open exactly on the
    mixed locus. See `tmp/degree12_jacobian/REPORT.md` and
    `tmp/degree12_jacobian_structural/REPORT.md`.
    The exact all-degree replacement for blind degree scans is the
    flat-connection determinant in item 6.
    Voisin's current construction proves \(C^{[3]}\) is \(G\)-very-versal,
    but pulling the universal marked cover back along her parameterization
    gives a source birationally fibered over \(C\) and is therefore circular
    for the missing point. See
    `tmp/ed_binary_attack/REPORT.md`.

11. The `xCD` frame plane has an exact characteristic-zero ternary cubic,
    universal \(c_4,c_6,\Delta\), and all ten coefficients evaluated in the
    certified \(K_{\rm proj}\) arithmetic.  The genuine generic rank-nine
    \(E[3]\) algebra
    \(\mathcal R=\operatorname{Map}_{K_{\rm proj}}(E[3],\overline K_{\rm proj})\)
    and normalized group/difference/Kummer functions are
    installed and kept distinct from the flex torsor.  At \(s=1\), the true
    degree-12 three-flex-line algebra has orbit degrees `4+8` and satisfies
    all incidence and norm identities, but the rational flex makes this
    class trivial.  A separate low-height coordinate-line control has rational
    point \(O=[1:0:1]\) and irreducible flex cover, proving a nonzero class
    abstractly equal to \(\delta([H-3O])\), where \(H\) is a hyperplane
    section.  No explicit coordinates for \(Q=[H-3O]\) in the saved Jacobian model, translation algebra,
    determinant representative, or \(G(Q)\)
    comparison were obtained.  The generic first-descent boundary is the
    Galois-equivariant \(\operatorname{GL}_3(\mathcal R)\) lift \(M_T\) giving
    \(\alpha_{\mathcal R}=\det(M_T)\bmod \mathcal R^{\times3}\); generic true second descent still
    needs the twisted three-flex-line algebra, line forms, and constants. See
    `tmp/kproj_arithmetic/REPORT.md`, `tmp/xcd_genuine_descent/REPORT.md`, and
    `tmp/xcd_nonzero_kummer/REPORT.md`.

## Verification

The initial `certificates/...` commands below form the portable checked-in
suite. Every later command under `tmp/...` requires the intentionally ignored
2.4 GB local artifact tree and will not be available in a fresh clone.

From this directory run:

```sh
python3 certificates/exact_weil_check.py
python3 certificates/exact_molien.py
python3 certificates/exact_covariants_check.py
python3 certificates/septic_landing_check.py
python3 certificates/generic_covariant_basis_check.py
python3 certificates/generic_frame_lines_check.py
python3 certificates/generic_frame_planes_specialization.py
python3 certificates/generic_frame_planes_check.py 11 14
python3 certificates/flex_cover_check.py
python3 certificates/subgroup_secant_check.py
python3 certificates/subgroup_orbit_check.py
python3 certificates/orbit_hilbert_check.py
python3 certificates/modular_covariant_scan.py
python3 certificates/degree10_m2_check.py
python3 certificates/degree11_m2_check.py
python3 certificates/degree12_msolve_check.py --threads 4 --timeout 120
python3 tmp/projective_source/character_scan.py
python3 tmp/projective_source/landing_scan.py
python3 tmp/projective_source/degree6_rational_root.py
python3 tmp/projective_source/verify_degree6_geometric_factor.py
python3 tmp/projective_source/primitive_degree12/verify.py
python3 tmp/ed_binary_attack/check_projective_pencil_skip_factor.py
python3 tmp/projective_source/degree8_m2.py
python3 tmp/projective_source/degree10_msolve_verify.py
python3 tmp/projective_source/degree8_rational_frame.py
python3 tmp/projective_source/degree8_frame_line_probe.py
python3 tmp/projective_source_degree12/verify_artifacts.py
python3 tmp/projective_source_degree12_structural/verify_decomposable.py
python3 tmp/projective_source_degree12_structural/verify_primitive_one_slices.py
python3 tmp/projective_source_degree12_structural/verify_primitive_two_slices.py
python3 tmp/projective_source_degree12_support/audit_coordinate_support.py \
  --verify --batch-size 257
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
python3 tmp/ed_binary_attack/projective_pencil_root_test.py --skip-factor
python3 tmp/ed_binary_attack/covdim_dominance_scan.py
python3 tmp/ed_binary_attack/covdim_degree8_scan.py
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
python3 tmp/fano14_degree12/degree12_msolve.py \
  --degree 15 --verify-leading tmp/fano14_degree12/leading15.out
python3 tmp/structural_degree13/verify.py
# Optional expensive replay of the exact solvers:
python3 tmp/structural_degree13/verify.py --rerun-msolve
python3 tmp/degree13_step2/verify_certificate.py
python3 tmp/degree13_opt/verify_q67_terminal.py
python3 tmp/degree14_feasibility/audit.py
python3 tmp/degree14_structural/verify.py
python3 tmp/fano14_degree16/verify_artifacts.py
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

The modular checks use NumPy/SymPy. The frame-line,
`generic_frame_planes_check.py`, flex, degree-10, and degree-11 checkers also
require the `M2` executable; the degree-12 checker requires `msolve`. The
degree-10, degree-11, and degree-12 certificate commands regenerate their
equations from the direct reduction of the cyclotomic matrices. Do not use the older
static files under `tmp/agent_high/` as certificate provenance; those were
generated in an alternate ATLAS basis. The two covariant-dominance commands
use `msolve`; the saved projective degree-10 and Pfaffian degree-15 verifiers
do not rerun their full solver jobs. The degree-six rational-root and
degree-eight projective-source commands require `M2`; the fast discriminant
replay is an independent supplement and does not by itself replace the base
and cubic-extension irreducibility checks in `degree6_rational_root.py`.
The durable q67 terminal wrapper has now recorded normal completion and a
nonempty output. `verify_q67_terminal.py` checks both hashes and confirms that
the 21,674-monomial leading ideal contains a pure power of all 21 variables,
so it is an independent direct certificate of degree-thirteen projective
emptiness. The structural proof above remains the smaller independent
certificate; neither bounded theorem gives an all-degree cutoff.

## Current ranking

For the fastest exact calculations: (1) use the checked flat-connection
circuit on a theoretically motivated nonconstant ansatz, (2) compute
\(Q_{\rm ctl}\) in the saved Jacobian model and construct the
Galois-equivariant translation lift \(M_{T,\rm ctl}\) on the nontrivial
characteristic-23 function-field control, (3)
attempt either degree-12 mixed locus only
through a certified relative/Fitting elimination, and (4) Pfaffian degree
sixteen only after a structural reduction.  Both authorized degree-12 chart
gates have already worsened; the remaining three Jacobian and 31 Schur charts
must not be launched unchanged. For headline leverage: (1) the exact
flat-connection KLS equation, (2) honest generic `xCD` descent and point
searches using the completed \(K_{\rm proj}\) arithmetic, (3) an unrestricted
rational point in the exhaustive degree-eight Schur frame, and (4) structural
use of the Pfaffian Hermitian model.
See `CURRENT_PATHS.md` for costs, implications, and stopping rules.

## Best re-entry points

- **Generic twist.** The exact invariants, algebraically independent
  primaries, rank-twelve Hironaka basis and multiplication table, normalized
  \(K_{\rm proj}\) arithmetic, and genuine rank-nine \(E[3]\) algebra are all
  certified.  Generic first descent still needs a Galois-equivariant
  \(\operatorname{GL}_3(\mathcal R)\) translation lift \(M_{T,\rm gen}\) and
  the class representative
  \(\alpha_{\mathcal R}=\det(M_{T,\rm gen})\bmod \mathcal R^{\times3}\); true
  second descent needs the generic twisted three-flex-line algebra, line
  forms, and constants.  Separately, validating the soluble coordinate-line
  control explicitly requires computing \(Q_{\rm ctl}=[H-3O]\) in its saved
  Jacobian model, then comparing \(\det(M_{T,\rm ctl})\) with
  \(G(Q_{\rm ctl})\).  The control proves its
  nonzero flex class is abstractly Kummer but supplies none of those explicit
  data. Positive
  candidate searches may
  proceed immediately in the ambient rational-function field if invariance
  and the cleared cubic identity are checked exactly. Continue the ten
  three-coordinate planes of
  \(\Phi(a)=F(a_0x+a_1C+a_2D+a_3E+a_4K)\) over the invariant field and find
  one nonzero isotropic vector. The frame and all coordinate lines are
  controlled, all plane sections are smooth, and invariant-polynomial plane
  ansätze are excluded only through total degree 14; the cubic point remains
  open. The point problem already descends from \(\mathbf C(W)^G\) to the
  transcendence-degree-four field \(\mathbf C(\mathbf P(W))^G\), but its
  \(C_4\) bound does not apply to a five-variable cubic. Rational flexes are
  excluded in every frame plane; the exact remaining genus-one question is
  whether the flex class lies in the Kummer image. See
  `tmp/plane_genus_one/REPORT.md`.
- **Higher covariants.** Degrees 13 and 14 are now completely excluded. The structural
  proof in `tmp/structural_degree13/REPORT.md` forces every quotient class
  modulo the source cubic into the scalar plane and eliminates both possible
  lifts by exact ten-variable leading ideals. The completed direct q67 run in
  `tmp/degree13_opt/REPORT.md` independently produces an Artinian leading
  ideal in all 21 coefficient variables. The degree-14 successor in
  `tmp/degree14_structural/REPORT.md` proves scalar support for the
  14-dimensional quotient with twelve unit Rabinowitsch systems and excludes
  both lift branches by 12-variable Artinian ideals. Degree 15 is the next
  unrestricted homogeneous degree. A landing point would give a dominant map
  automatically; any further finite null search remains only a bounded
  exclusion. The separate direct F4 audit in
  `tmp/degree13_step2/REPORT.md` leaves 26 standard monomials and is explicitly
  only a partial-leading diagnostic, not the source of the exclusion.
  The completed degree-14 calculation uses prime 67 throughout; its quotient
  equation rank is the exact upper bound 64 and both branch Hilbert functions
  vanish in degree five.
- **Pfaffian branch.** The exact quaternionic model and the matched-covariant
  checker are in `tmp/fano14_twist/REPORT.md` and
  `tmp/fano14_degree12/REPORT.md`. Degrees 12--15 are excluded. Degree 16 has
  been fully reconstructed, but its 1,313-quadratic exact solve timed out in
  degree three and remains a strict nonverdict; see
  `tmp/fano14_degree16/REPORT.md`. The structural target is still a common
  isotropic line for the special five-plane of Hermitian forms.
- **Projective Schur source.** `tmp/projective_source/REPORT.md` proves that
  any rational \(\mathbf P(V_6)\dashrightarrow C\) would solve the problem and
  excludes constant-coefficient degrees 4, 6, 8, and 10. Degree 12 has now
  been reconstructed completely (dimension 48), but only the 16-dimensional
  decomposable sector, every one-primitive slice, every one of the 496
  two-primitive slices, and fixed-basis supports of size at most five are
  excluded. Thus the structural quotient basis needs primitive support at
  least three. The old incomplete 1,093-row solve timed
  out; the complete characteristic-23 equation span has rank 1,124 and a
  verified full input. Its complete-input solve also timed out in degree four
  with no leading ideal, so there is still no projective-locus verdict. The
  terminal audit excludes more source sampling and identical retries: all 48
  standard chart leading-cubic restrictions have rank 1,124, and two exact
  chart probes reproduce the same degree-four bottleneck.  The equations have
  now been changed to
  \(D_{12}^{V_6}\oplus\langle p_0,\ldots,p_{31}\rangle\), and the authorized
  \(p_0=1\) gate timed out on a worse trajectory.  Do not run the other 31
  charts; resume only through relative elimination of the 16 decomposable
  variables with explicit exceptional-stratum control. The rational
  problem has an exhaustive degree-eight frame over the invariant quotient
  field.  Its ten coordinate lines and the bounded ternary envelopes through
  all 90 spaces \(S_{12}+\langle p_j\rangle\) are excluded.  Unrestricted
  ternary points remain open; the other 359 two-direction degree-12 slices
  are not budget-justified. Finite scans still cannot prove a negative
  answer. See the reports under `tmp/projective_source_degree12*`,
  `tmp/step4_degree12_solver_terminal/REPORT.md`, and
  `tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`.
- **Covariant dimension.** Search directly for a Jacobian-zero
  self-covariant \(W\to W\). Such a map is equivalent to
  \(\operatorname{ed}(G)=3\), even if its image is not initially presented as
  the Klein cone. Degrees through 11 are excluded; in degree 12 the pure
  decomposable and pure primitive strata are also excluded, while the mixed
  chart gate timed out and stopped the other three.  The Hironaka arithmetic
  and all four connection circuits are complete; the 561 constant and
  Hironaka-linear ansätze are excluded.  Attack the exact equation
  \(\mathcal J_\nabla(a)=0\) over the invariant field through a structural
  rational-function family or differential-algebraic argument. See
  `tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`,
  `tmp/degree11_jacobian/REPORT.md`, `tmp/degree12_jacobian/REPORT.md`,
  `tmp/degree12_jacobian_structural/REPORT.md`, and
  `tmp/kproj_connection/REPORT.md`.
- **Essential dimension.** Any unconditional proof that
  \(\operatorname{ed}(G)=3\) or \(4\) now settles the headline in the
  corresponding direction.  The canonical target is the generic Klein twist
  over \(K_{\rm proj}\): it has index one, but none of the audited local,
  Brauer, Amitsur, or standard stable-cohomology invariants decides whether it
  has a point. See `tmp/step4_essential_dimension/REPORT.md`.
- **Counterexample twist.** An explicit \(G\)-torsor whose Klein twist has no
  point would prove both the negative headline and \(\operatorname{ed}(G)=4\).
- **Orbit constructions.** A successful orbit-based formula must mix an
  entire configuration continuously; constant orbit selection and binary
  chord trees are now ruled out by the exact subgroup audit. The 220-point
  orbit has no containing divisor through degree four, its first
  complete-intersection link increases the residual degree to at least 320,
  and a constant invariant degree-74 interpolation curve is impossible. A
  torsor-dependent semilinear degree-74 curve remains a precise positive
  target; see `tmp/zero_cycle_descent/REPORT.md`.

## Theorem boundaries

- Current literature explicitly retains this action as open.
- \(\operatorname{Crdim}(G)=4\) does not imply
  \(\operatorname{ed}(G)=4\) without Dolgachev's conjecture.
- Superrigidity rules out equivariant birational linearization, not a
  dominant map of higher degree.
- The three bounded covariant statements have different sources and cutoffs:
  landing \(W\to W\) is excluded through degree 14; Jacobian degeneracy for
  \(W\to W\) completely only through degree 11, with the two pure degree-12
  strata also excluded and its mixed locus open; and constant-coefficient
  landing \(V_6\to W\) completely only in degrees 4, 6, 8, and 10. Its
  degree 12 has only the scoped decomposable and coordinate-support
  exclusions stated above.  Rank 721 or 1,124 is an exact special-fiber
  equation-span statement, not projective emptiness by itself.
  Rational coefficients on the last source have an exhaustive five-vector
  degree-eight frame.  The full degree-six pencil, all ten coordinate lines,
  and the bounded ternary envelopes through all 90 one-direction degree-12
  slices are excluded; arbitrary invariant-field points remain open.
- Very versality of \(C^{[3]}\) does not give very versality of \(C\): no
  rational equivariant operation selecting one point of the degree-three
  cycle is known, and Voisin's marked parameter space is already fibered over
  \(C\).
- The projective Schur source \(\mathbf P(V_6)\) is not itself weakly versal.
  A map from it is sufficient only because its twists split over extensions of
  degree at most two and the resulting quadratic cubic points descend.
- The Pfaffian bridge contains a genuinely nonsplit projective factor. It
  always splits after an extension of degree at most two, but this yields a
  Klein-cubic point only in the \(F_{14}\)-very-versal branch of the
  essential-dimension argument in `RESOLUTION.md`. Rationality of the ambient
  \(D\)-projective plane does not imply a point on its codimension-five Fano
  section, and the quaternion class persists over that section's function
  field.
- The generic twist has no rational line: a point on its twisted Fano surface
  of lines would force a faithful very versal surface, contradicting
  \(\operatorname{ed}(G)\ge3\). It has no \(K_0\)-defined conic either, since
  the residual plane-section component would be such a line. A successful
  point construction must not assume either curve.
- The Gross--Popescu modular interpretation respects the \(G\)-action, but
  its unirationality inference uses ordinary cubic unirationality and supplies
  no equivariant linear source.
- A search through any finite degree is not a negative resolution.
