# Problem E handoff

## Headline

The problem remains **OPEN**. Do not reinterpret the essential-dimension
equivalence, generic-twist frame, or bounded covariant search as a binary
resolution.

The current two-axis ranking and the four-path audit are in
[`CURRENT_PATHS.md`](CURRENT_PATHS.md).

## 2026-07-28 delta

> **Cross-problem import, easy to miss (see the full section near the end
> of this file):** Problem F — the PSL(2,7) degree-2 del Pezzo — is now
> RESOLVED NEGATIVE, adversarially audited, by an all-degree V₄-fixed
> exceptional-path obstruction.  The engine (parity-forced constancy on
> involution eigenloci + pointwise-fixed exceptional curves + path
> propagation into fixed loci with no rational curves) is a candidate
> obstruction mechanism for THIS problem, with five cheap exact first
> checks listed in "Technique import from Problem F".  Any negative-route
> plan should evaluate those five checks before its next dispatch.

The headline is still open, but the following next steps were completed and
replayed.

- The first unexcluded landing degree, 15, is now excluded exactly.  The
  quotient \(M_{15}/fM_{12}\) has dimension 16; the complete landing image
  has rank 75 in an independently certified 76-dimensional ambient quotient;
  all twelve normal charts are unit ideals; and both 16-variable lift
  branches are Artinian.  The characteristic-zero landing cutoff is now
  degree **15**, not 14.  Replay with
  `python3 tmp/degree15_structural/verify.py`.
- Degree 16 is not excluded, but it is now structurally finite over the scalar
  base.  The complete
  quotient has dimension 20 and the complete landing image rank 93.  The
  pure-normal ideal is Artinian of length `6,169`, so projection to the
  scalar `P3` is finite.  The scalar locus has a common nine-dimensional
  normal tangent kernel, and that entire straight kernel stratum is empty by
  an exact weighted cokernel of length `713`.  The weighted-projective
  second-order lifting incidence is also empty, so no nonzero normal tangent
  direction admits a second-order lift.  Global rank 15 is now exactly refuted, since
  the `93 x 15` weighted matrix has rank five on the tangent-kernel `P8`.
  That forced rank drop does not meet `y=(Sym^2(s),s,1)`.  Resume at the true
  Veronese-affine residual incidence, but do not collapse it to `P6`:
  `Q(n)` and `C(n)` retain all nine kernel coordinates, so the honest base is
  the blowup of `P15` along `P8`.  The cleared `83 x 5` quotient formulation
  has 19 variables and 93 equations of degrees 12 and 13, not a smaller
  solve.  Use the absence of nonzero second-order lifts to split or saturate away the scalar
  component in the original cubic system.  A full 13-variable `K9+s4` fiber
  at `t=[1,2,30,32,60,2,48]` is exactly empty: a saved 93-coefficient linear
  combination of the original cubics equals one, and `msolve` independently
  returned `[-1]:`.  Properness of the controlled boundary puts all possible
  survivors over a proper closed subset of `P6`, also in characteristic zero.
  Target that exceptional image, not more isolated `t` samples.  Do not run
  more fixed-scalar charts, expand 5-minors, or extend the false weighted-cokernel target.
  Replay with
  `python3 -u tmp/degree16_landing_probe/verify.py`,
  `python3 tmp/degree16_landing_probe/verify_off_k_residual_audit.py`, and
  `python3 tmp/degree16_landing_probe/verify_off_k_t_fiber_attack.py`.
- The degree-12 mixed Jacobian incidence is generically empty over its
  primitive `P^3`.  The exact fiber `[1:1:1:1]` is a unit ideal, and the
  empty decomposable center makes projection proper.  Remaining solutions,
  if any, lie on a proper closed exceptional locus.  With
  `A=F_67[p1,p2,p3]`, the retained `mu7: A^65611 -> A^50388` is only a
  degree-seven border truncation, not a
  presentation of that locus: specialized membership of `1` does not lift
  automatically to a relative annihilator.  The parameter-independent
  degree-five block has a certified \(721\times721\) minor of determinant
  \(18\bmod67\), and the completed top-form Groebner calculation has Hilbert
  function `[1,12,78,364,1365,3647,3726,0,0]` and colength `9,193`.
  Its full 15,283,769-term reduced basis is audited, proving finite top
  control and identifying a possible `9,193 x 24,416` Schur target.  The
  missing object is still a multiplication-stable relative determinant with
  nonzero value at `(1,1,1)`.  An audited shortcut now reduces this to two
  exact witnesses: a right inverse/PLU circuit for the
  `31,824 x 56,238` degree-seven top map and one degree-at-most-two
  multiplier vector whose lazy rank-18,564 reduced multiplication operator
  has full rank at the sample point.  A length-65,611 specialized unit vector
  guarantees such a choice, but a sparse choice may suffice.  Its determinant
  kills the full quotient over `F_67` without any confluence claim.  A
  characteristic-zero determinant would still require lifting the pivot
  minors and replaying the solves over an integral or number-field model.
  The witnesses are not yet certified.  The ancestor-closed survivor replay
  has now completed under the `768 MiB` trace-allocation gate: `55,966` roots,
  `45,751,159` committed operations, `479,691,384` discarded zero-row
  operations, and `372,506,624` allocated bytes.  Its corrected leaf map
  records the permutation and normalization of all 721 original generators.
  Structural replay passes.  A separate exact semantic replay checks every
  one of the 721 degree-five final rows coefficientwise in 4,368 ambient
  monomials: 2,882 selected roots, 474,949 trace operations, and zero
  mismatches.  One full cross-round degree-seven row with 48,255 nonzero
  source entries also multiplies exactly to `d11^7`.  The verified
  division plan covers all 31,824 target monomials using 8,181 retained basis
  rows.  This is the right circuit format, but the selected degree-six and
  remaining degree-seven roots have not yet been compared coefficientwise
  with the retained basis, so no full `M7` right inverse or `M7 R = I`
  certificate is claimed.  Dense expansion is
  rejected: it would need `782,526,535` live bytes before overhead and about
  `1.59e12` scalar updates.  The exact next gate is to extend the ambient-
  polynomial semantic verifier from the completed degree-five layer to the
  remaining 7,846 degree-six/seven rows (the audited all-row plan uses
  `478,080,096` peak bytes and about `1.05e12` updates), followed by circuit-level right-inverse and
  multiplication-rank checks.  Everything remains over `F_67`.  See
  `tmp/relative_kls_chart/DEGREE_LOWERING_DETERMINANT.md` and
  `tmp/relative_kls_chart/TRANSFORM_EXTRACTION_GATE.md`, plus
  `tmp/relative_kls_chart/survivor_trace/REPORT.md`,
  `tmp/relative_kls_chart/survivor_trace/evaluator/REPORT.md`, and
  `tmp/relative_kls_chart/survivor_trace/semantic_check/REPORT.md`.
  Replay with
  `python3 tmp/relative_kls_chart/verify.py` and
  `python3 tmp/relative_kls_chart/verify_top_full_gb.py`; replay the extraction
  gate with
  `python3 tmp/relative_kls_chart/verify_transform_extraction_gate.py`, and
  replay the corrected survivor circuit with
  `python3 -u tmp/relative_kls_chart/survivor_trace/verify_survivor_trace.py`
  followed by
  `python3 -u tmp/relative_kls_chart/survivor_trace/evaluator/verify.py --manifest tmp/relative_kls_chart/survivor_trace/evaluator/manifest.json`;
  replay the degree-five semantic layer with
  `/opt/homebrew/bin/python3 -u tmp/relative_kls_chart/survivor_trace/semantic_check/verify.py`.
  A complete triangular cover of the base hyperplane `p3=0` also hit its
  bounded stop: all three 14/13/12-variable charts timed out in degree seven.
  A deterministic coordinate-nondegenerate projective line had the same
  first-matrix sizes and densities, so its solver was not launched.  It was
  not proved generic relative to the unknown exceptional image.  These are
  strict non-verdicts: finite
  projection and even a dimension bound remain unproved.  Replay with
  `python3 tmp/relative_kls_hyperplane/verify.py` and
  `python3 tmp/relative_kls_hyperplane/verify_line_pilot.py`.
- The degree-free KLS connection has exactly the frame and trace-branch polar
  divisors (away from `t3=0`).  Its norm determinant is
  \(2^{10}3^8 11^{12}D\Delta/(5^4t_3^{24})\).  The general residue leading
  systems are now solved and are positive-dimensional rational determinant
  hypersurfaces, not local obstructions.  In addition to the earlier 140
  one-parameter families, all 60 smallest constant simultaneous `P2`
  modifications are excluded exactly.  The complete two-fibre first-jet
  screen also excludes all `60*4*3=720` projective families in which one of
  the three coefficients acquires one slope `d*t_q`; every frame triple,
  base direction, and coefficient role is computed directly.  The stronger
  `P5` screen gives all three coefficients independent slopes in one common
  base direction and excludes all `60*4=240` projective families.  The entire
  constant `P4` is now excluded as well, and the simultaneous constant
  centralizer is scalar.  The canonical `P8` two-coordinate family for
  triple `(0,1,2)`, directions `(t3,t6)`, and three regular fibres is also
  completely empty: seven Macaulay2 charts, one exact msolve chart, and the
  last point give a complete projective cover.  Do not scale this into more
  three-support sweeps.  The local KLS determinant hypersurface has dimension
  19, while all four-direction first jets with fixed three-coordinate support
  have dimension at most 10; `P3/P5/P8` families cannot be exhaustive.  The
  first full-support `P9` chart hit the 700 MiB stop with no verdict.  The
  negative route now needs a global foliation/line-subsheaf theorem or a
  bounded-pole normal form.  Replay with
  `python3 tmp/kls_divisor_ansatz/verify.py` and
  `python3 -u tmp/kls_residue_next/verify.py`, then
  `python3 tmp/kls_first_jet_two_fiber/verify_manifest.py`,
  `python3 tmp/kls_first_jet_two_fiber/verify.py --ledger-only`,
  `python3 tmp/kls_first_jet_two_fiber/verify_manifest_p5.py`, and
  `python3 tmp/kls_first_jet_two_fiber/verify_p5.py --ledger-only`, then
  `python3 -u tmp/kls_first_jet_three_fiber/verify_combined_p8.py` and
  `python3 -u tmp/kls_structural_audit/verify.py`.
- On the characteristic-23 soluble `xCD` control, \(Q=[H-3O]\), the
  irreducible nonzero \(E[3]\) field, and the genuine nonzero representative
  \(G(Q)\) are explicit.  Translation interpolation still times out before a
  matrix and is no longer the critical control task.  This validates the
  conventions but does not transfer the control class to characteristic
  zero.  Replay with
  `python3 tmp/xcd_control_next/verify.py`.
  The determinant-free generic construction has now passed the full Cech
  coordinate gate.  A replay-locked DAG contains the monic degree-nine
  flex eliminant, first subresultants, their inverse, and the universal flex
  point over the rank-nine algebra.  A segmented extension contains
  `Q'^-1` and all 81 coordinates of the diagonal idempotent.  A typed
  nested-etale circuit executes
  `lambdaSharp=(lambda+eDelta)^-1*(1-eDelta)` and constructs the actual Cech
  `X,Y`; rank-81 replay checks the short curve, 3-division, diagonal, and
  swap identities.  The outputs are typed whole-`K_proj` algebra nodes, not
  distributed Hironaka coordinates.  The raw determinant ratio fails to
  descend (rank `108`, augmented rank `109`), but the corrected unit
  scalar-cochain normalization succeeds.  The exact geometric descent lemma
  and a selected `9 x 9` solve produce a generic-open rational representative
  `alpha_R=det(M0)/ell(M0)^3` modulo cubes.  The `GF(101)` full-81 calculation
  corroborates rather than proves the generic descent.  Cubic scaling and
  orientation agree.  The saved representative retains
  `alpha_R(O)=71^-3` and fixes `z_O=71`; equivalently, cube-normalizing the
  identity coefficient to one would fix `z_O=1`.  The affine first-descent
  unit chart is now assembled: it has ten variables, nine cubics over the
  exact `QQ`-model, and the condition `Norm_R8(z_star)!=0`.  Its
  `3^8`-sheet covering scheme has 729 geometric components, each a
  degree-nine 3-covering, so do not run an algebraic-closure emptiness solve.
  A `K_proj,QQ` point suffices positively after base change, but a negative
  result must hold over
  \(K_{\mathrm{proj},\mathbf C}=K_{\mathrm{proj},\mathbf Q}
  \otimes_{\mathbf Q}\mathbf C\).  CFOSS identifies a
  distinguished base-defined component that is isomorphic as a covering to
  the original projective `xCD` cubic; use that cubic rather than extracting
  or closing all 729 components.  Exact Hensel pilots rule out every prime
  component of `A=0`, `B=0`, and `C=0` as a local-obstruction place.  The
  degree-120 discriminant packet now rejects every one of its height-one
  components as well: its pullback is squarefree and gauge-coprime, every
  normalized discriminant valuation is one, and Poonen--Stoll gives a
  residue-rational node which lifts to a local point.  The two motivated
  smooth-reduction primes `f5=0` and `f6=0` are geometrically integral and
  have alternate unit gauges.  Their coordinate vertices and every complete
  invariant-polynomial `x,C,D` ansatz through total degree 15 are empty.  This
  is not a local obstruction; the next negative gate is their actual residue
  3-descent or a relative unramified 3-Selmer calculation.  Do not use
  arithmetic-prime or `QQ`-only Selmer
  results as negative evidence, enter a splitting field, or expand an `81 x 81`
  determinant.  Even a nonpoint theorem for this component would close only
  this `xCD` plane construction, not the headline.  Replay with
  `python3 -u tmp/xcd_generic_cech_next/verify_generic_dag.py` and
  `python3 -u tmp/xcd_generic_cech_next/verify_cech_extension.py`, then
  `python3 -u tmp/xcd_generic_cech_next/verify_typed_cech.py`,
  `python3 -u tmp/xcd_generic_cech_next/verify_alpha_corrected.py`, and
  `python3 -u tmp/xcd_first_descent_next/verify.py`, then
  `python3 -u tmp/xcd_arithmetic_next/verify.py`,
  `python3 -u tmp/xcd_discriminant_divisor/verify.py`, and
  `/opt/homebrew/bin/python3 -u tmp/xcd_gauge_divisors/verify.py`.
- The July 2026 level-11 theta/Schwarz construction uses the correct
  projective representation but does not lie on the Klein cubic:
  \(F(H\Phi_{11})=\xi_{44}^5u^{11}+O(u^{99})\).  It is also outside the
  classical Hessian-singular model.  Close this as a headline path.  Replay
  with `python3 tmp/theta11_test/theta11_test.py`.

The local ignored `tmp/` tree is now about 6.1 GB.  The new material is
dominated by a 647 MiB gated raw-coordinate Cech prototype, the 373 MiB full
top Groebner basis, the 351 MiB degree-12 survivor circuit, the 1.3 GiB local
Julia/Groebner.jl installation and pilot, the degree-12 hyperplane-chart
inputs, and the degree-16 probe inputs.  The accepted segmented generic DAGs include files of about
95 MB, 62 MB, and 39 MB; the typed Cech `X,Y` extension is under 1 MB.  They remain under
`tmp/` and therefore do not enlarge GitHub history unless deliberately
force-added.

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
   degree **15**. Degree ten and eleven use dynamically regenerated
   Macaulay2 ideals. Degree twelve reconstructs a 16-dimensional basis and
   143 independent sampled necessary landing cubics; an exact `msolve`
   Gröbner basis has quotient Hilbert function zero in degree five. Degree
   thirteen uses the quotient \(M_{13}/fM_{10}\): 48 necessary cubics force
   the scalar plane, after which exact degree-ten and tangent Hilbert
   functions kill both lifts. Degree fourteen similarly reduces the
   14-dimensional quotient to its scalar line with twelve unit
   Rabinowitsch systems; its two 12-variable branch Hilbert functions vanish
   in degree five. Degree fifteen has a 16-dimensional quotient whose
   complete rank-75 landing system is supported on the scalar four-plane;
   all twelve normal charts are unit ideals, and both 16-variable lift
   branches vanish projectively in degree five. See
   `tmp/structural_degree13/REPORT.md`,
   `tmp/degree14_structural/REPORT.md`, and
   `tmp/degree15_structural/REPORT.md`.

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
    The first direct mixed chart timed out at `104836 x 166810`, so the other
    three were not launched.  Relative specialization has since proved that
    the fiber `[1:1:1:1]` is a unit ideal.  The empty decomposable center and
    proper projection imply that the mixed incidence is empty on a nonempty
    open subset of primitive `P^3`, also in characteristic zero.  Degree
    twelve remains open only on a proper closed exceptional locus.  The map
    `mu7: A^65611 -> A^50388` is an exact degree-seven truncation, not a
    presentation of that locus.  The fixed top ideal has colength `9,193`
    and no degree-seven standard monomials, but no explicit relative
    annihilator is installed. See
    `tmp/degree12_jacobian/REPORT.md`,
    `tmp/degree12_jacobian_structural/REPORT.md`, and
    `tmp/relative_kls_chart/TOP_IDEAL_REPORT.md`.
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
    section.  The tangent residual now gives exact coordinates for
    \(Q=[H-3O]\) in the saved Jacobian model, and the irreducible nonzero
    \(E[3]\) field together with \(G_T(Q)\) replays as the genuine nonzero
    first-Kummer representative.  On the generic side, replay-locked DAGs
    now install the monic flex eliminant, universal point over the rank-nine
    flex algebra, and all 81 coordinates of the diagonal idempotent.  A typed
    quotient-algebra circuit now gives the tangent inverse off the diagonal
    and the actual Cech `X,Y`, with the curve, 3-torsion, diagonal, and swap
    identities checked.  A unit scalar-cochain normalization of the induced
    projective translation lift now gives a generic-open rational rank-nine
    first-Kummer representative `alpha_R` modulo cubes.  The actual equation
    `G(P)=alpha_R*z^3` is assembled as a ten-variable, nine-cubic affine unit
    chart.  Its `3^8` sheets split geometrically into 729 degree-nine
    components.  Its distinguished base-defined component is isomorphic as a
    covering to the original projective `xCD` cubic.  The remaining task is a
    `K_proj,C`-rational point or a geometric-divisor obstruction on that
    cubic; the pure-coefficient places `A=0`, `B=0`, and `C=0` are already
    locally soluble.
    Generic true second descent still needs the
    twisted three-flex-line algebra, line forms, and constants. See
    `tmp/kproj_arithmetic/REPORT.md`, `tmp/xcd_genuine_descent/REPORT.md`,
    `tmp/xcd_control_next/REPORT.md`,
    `tmp/xcd_generic_cech_next/REPORT.md`, and
    `tmp/xcd_first_descent_next/REPORT.md`, and
    `tmp/xcd_arithmetic_next/REPORT.md`.

## Verification

The initial `certificates/...` commands below form the portable checked-in
suite. Every later command under `tmp/...` requires the intentionally ignored
about 6.1 GB local artifact tree and will not be available in a fresh clone.

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
python3 tmp/kls_divisor_ansatz/verify.py
python3 -u tmp/kls_residue_next/verify.py
python3 tmp/kls_first_jet_two_fiber/verify_manifest.py
python3 tmp/kls_first_jet_two_fiber/verify.py --ledger-only
python3 tmp/kls_first_jet_two_fiber/verify_manifest_p5.py
python3 tmp/kls_first_jet_two_fiber/verify_p5.py --ledger-only
python3 -u tmp/kls_first_jet_three_fiber/verify_combined_p8.py
python3 -u tmp/kls_structural_audit/verify.py
python3 tmp/kls_full_support_p9_msolve/verify_p9.py --ledger-only
python3 tmp/relative_kls_chart/verify.py
python3 tmp/relative_kls_chart/analyze_exceptional.py
python3 tmp/relative_kls_chart/analyze_top_ideal.py
python3 tmp/relative_kls_chart/verify_top_full_gb.py
python3 tmp/relative_kls_chart/verify_degree_lowering_plan.py
python3 tmp/relative_kls_chart/verify_transform_extraction_gate.py
python3 -u tmp/relative_kls_chart/survivor_trace/verify_survivor_trace.py
python3 -u tmp/relative_kls_chart/survivor_trace/evaluator/verify.py \
  --manifest tmp/relative_kls_chart/survivor_trace/evaluator/manifest.json
/opt/homebrew/bin/python3 -u \
  tmp/relative_kls_chart/survivor_trace/semantic_check/verify.py
python3 tmp/relative_kls_chart/bihomogeneous_pilot.py
python3 tmp/relative_kls_hyperplane/verify.py
python3 tmp/relative_kls_hyperplane/verify_line_pilot.py
python3 tmp/theta11_test/theta11_test.py
python3 tmp/fano14_degree12/degree12_msolve.py \
  --degree 15 --verify-leading tmp/fano14_degree12/leading15.out
python3 tmp/structural_degree13/verify.py
# Optional expensive replay of the exact solvers:
python3 tmp/structural_degree13/verify.py --rerun-msolve
python3 tmp/degree13_step2/verify_certificate.py
python3 tmp/degree13_opt/verify_q67_terminal.py
python3 tmp/degree14_feasibility/audit.py
python3 tmp/degree14_structural/verify.py
python3 tmp/degree15_structural/verify.py
python3 -u tmp/degree16_landing_probe/verify.py
python3 tmp/degree16_landing_probe/verify_off_k_residual_audit.py
python3 tmp/degree16_landing_probe/verify_off_k_t_fiber_attack.py
python3 tmp/fano14_degree16/verify_artifacts.py
python3 tmp/xcd_invariant_field/presentation_audit.py
python3 tmp/xcd_invariant_field/f10_probe/verify.py
python3 tmp/xcd_descent_algebra/verify_xcd.py
python3 tmp/xcd_descent_math/verify_fiber_flex_algebra.py
python3 tmp/xcd_descent_math/verify_hesse_norms.py
PYTHONPATH=tmp/xcd_genuine_descent python3 tmp/xcd_genuine_descent/verify.py
python3 tmp/xcd_nonzero_kummer/verify.py
python3 tmp/xcd_control_next/verify.py
python3 -u tmp/xcd_generic_cech_next/verify.py
python3 -u tmp/xcd_generic_cech_next/verify_generic_dag.py
python3 -u tmp/xcd_generic_cech_next/verify_cech_extension.py
python3 -u tmp/xcd_generic_cech_next/verify_typed_cech.py
python3 -u tmp/xcd_generic_cech_next/verify_alpha_corrected.py
python3 -u tmp/xcd_first_descent_next/verify.py
python3 -u tmp/xcd_arithmetic_next/verify.py
python3 -u tmp/xcd_discriminant_divisor/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_gauge_divisors/verify.py
python3 tmp/groebnerjl_change_matrix_pilot/verify.py
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

The ranked bounded attacks are now: (1) pilot the `P8` two-coordinate KLS
family at three affinely independent regular fibres, after the completed
`P3` and stronger one-direction `P5` screens, (2)
attack the original projective `xCD` cubic through a relative unramified
3-Selmer calculation or the residue 3-descent at `f5=0` or `f6=0`, not the
now-closed discriminant route or
the raw 729-component unit-chart union, (3) run the ambient-polynomial semantic
verifier through the remaining 7,846 degree-six/seven rows and then compose
and check the `M7` solve circuit before testing the rank-18,564 multiplication operator,
(4) compute the true degree-16 residual only after a scalar-component
colon/saturation, and (5) touch Pfaffian degree sixteen only after a structural
reduction.  The degree-12 trace-extraction step itself is complete; its next
semantic check is exact but expensive (about `1.05e12` updates), so it no
longer outranks the two all-degree/geometric routes.  Do not launch unchanged degree-12 mixed
charts, repeat control translation interpolation, or start a generic flex
splitting-field computation.  For headline leverage: (1) the exact
flat-connection KLS equation, (2) honest generic `xCD` descent and point
searches using the completed \(K_{\rm proj}\) arithmetic, (3) an unrestricted
rational point in the exhaustive degree-eight Schur frame, and (4) structural
use of the Pfaffian Hermitian model.
See `CURRENT_PATHS.md` for costs, implications, and stopping rules.

There is one conditional recent-tool branch: generalized multiplication
matrices for bihomogeneous systems can compute the degree-12 elimination ideal
if the exceptional projection is finite or empty and an admissible bidegree
is certified.  Exact Hilbert counts already rule out all fiber degrees five
and six; the first merely count-feasible gate is `(2,7)`, a
`422,484 x 434,763` structured hyperplane-rank problem.  Its dimension is
currently unknown.  The direct `p3=0` cover timed out on all three charts and
the tested deterministic coordinate-nondegenerate line showed no structural
gain, so do not adopt the method or extend those tests without a sparse/block route;
a proper closed projection need not be finite.

One very recent theorem did materially change the `xCD` boundary:
Poonen--Stoll, *The valuation of the discriminant of a hypersurface*
(2026-06-30), Theorem 1.1.  It turns the certified valuation-one statement at
every degree-120 discriminant component into a residue-rational nondegenerate
node.  Together with projection and Hensel lifting, this closes those
components as local-obstruction places; it says nothing about the global
torsor or smooth-reduction places.

The 2026-07-27 Groebner.jl change-matrix API was installed and tested rather
than dismissed.  Exact small identities pass, but the fixed two-generator
change calculation and 512-row parsing already cross the `768 MiB` RSS gate;
the public high-level route is stopped.  SPQR does allow elimination orders
for positive-dimensional systems, but Mathematica is unavailable locally and
its reconstructed candidates would still need independent exact
verification.  No further broad tool search is justified unless a release
offers a public memory-efficient raw change-matrix interface or certified
generic function-field local/Selmer machinery.  See
`tmp/groebnerjl_change_matrix_pilot/REPORT.md`.

## Best re-entry points

- **Generic twist.** The exact invariants, algebraically independent
  primaries, rank-twelve Hironaka basis and multiplication table, normalized
  \(K_{\rm proj}\) arithmetic, and genuine rank-nine \(E[3]\) algebra are all
  certified.  The rank-nine flex algebra, its generic universal point, the
  determinant-free Cech circuit, the triple-overlap/rank-81 markers, and the
  generic diagonal idempotent are also certified.  The typed
  `lambdaSharp=(lambda+eDelta)^-1*(1-eDelta)` circuit and its actual Cech
  `X,Y` packet are certified as well.  The raw determinant ratio is proved
  not to descend, while a unit scalar-cochain normalization supplies the
  certified generic-open rank-nine `alpha_R` modulo cubes.  The actual
  equation `G(P)=alpha_R*z^3` is assembled as a ten-variable, nine-cubic
  unit-chart interface; a universal translation matrix is no longer required.
  The unit-open scheme has 729 geometric degree-nine components, with a
  distinguished base-defined component isomorphic as a covering to the
  original projective `xCD` cubic.  Generic first descent now needs a
  `K_proj,C`-rational point search or geometric-divisor obstruction on that
  cubic.  The three pure-coefficient divisor families are locally soluble;
  nonexistence only over the saved `QQ`-model is insufficient.
  True second descent then needs the generic twisted three-flex-line algebra,
  line forms, and constants.  The soluble coordinate-line control is now
  explicit: \(Q_{\rm ctl}=[H-3O]\), its irreducible nonzero \(E[3]\) field,
  and the genuine nonzero \(G_T(Q_{\rm ctl})\) representative all replay
  exactly.  It validates conventions only and does not transfer to the
  generic characteristic-zero plane. Positive candidate searches may
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
- **Higher covariants.** Degrees 13, 14, and 15 are now completely excluded. The structural
  proof in `tmp/structural_degree13/REPORT.md` forces every quotient class
  modulo the source cubic into the scalar plane and eliminates both possible
  lifts by exact ten-variable leading ideals. The completed direct q67 run in
  `tmp/degree13_opt/REPORT.md` independently produces an Artinian leading
  ideal in all 21 coefficient variables. The degree-14 successor in
  `tmp/degree14_structural/REPORT.md` proves scalar support for the
  14-dimensional quotient with twelve unit Rabinowitsch systems and excludes
  both lift branches by 12-variable Artinian ideals. The degree-15 successor
  in `tmp/degree15_structural/REPORT.md` proves scalar support for its
  16-dimensional quotient with twelve unit normal charts and excludes both
  lift branches by 16-variable Artinian ideals. Degree 16 is the next
  unrestricted homogeneous degree.  Its complete quotient/landing system is
  now reduced to a finite-over-`P3` residual incidence: pure normal infinity,
  the common nine-dimensional tangent-kernel slice are empty, and no nonzero
  normal tangent direction admits a second-order lift.  Global rank 15 of the `93 x 15`
  weighted matrix is refuted, not open: its rank is five on the kernel `P8`.
  The remaining target must retain the constrained
  `y=(Sym^2(s),s,1)` locus and all nine kernel coordinates.  `P6` controls
  only the quotient subspace; the actual base is the blowup of `P15` along
  `P8`, and the cleared quotient formulation is no smaller than the 93
  original equations.  The next structural target is a scalar-component
  colon/saturation using the absence of nonzero second-order lifts.  The first
  exceptional-image equation has now been found exactly in the mod-67 fibre:
  a fixed combination of the complete 93 cubics is `59*L^3`, with `L`
  annihilating the tangent kernel.  Thus the whole residual special-fibre
  image lies in the explicit hyperplane
  `t0+38*t1+20*t2+6*t3+8*t4+2*t5+25*t6=0` of `P6`.  Two fixed row
  combinations vanish there and its generic row rank is 91.  Full solves
  exclude 264 deterministic fibres on this hyperplane, but this is not an
  exhaustive cover.  The first complete 18-variable, 91-cubic hyperplane
  chart hit the 700 MiB watchdog with no verdict at both four and one thread.
  Continue only with a sparse/block scheme-theoretic image or saturation on
  this exact stratum; do not add isolated samples.  See
  `tmp/degree16_landing_probe/REPORT.md` and
  `tmp/degree16_exceptional_search/REPORT.md`. A landing point would give a dominant map
  automatically; any further finite null search remains only a bounded
  exclusion. The separate direct F4 audit in
  `tmp/degree13_step2/REPORT.md` leaves 26 standard monomials and is explicitly
  only a partial-leading diagnostic, not the source of the exclusion.
  The completed degree-14 calculation uses prime 67 throughout; its quotient
  equation rank is the exact upper bound 64 and both branch Hilbert functions
  vanish in degree five. The degree-15 quotient image has exact rank 75 in
  its independently checked 76-dimensional ambient quotient, and both
  branch Hilbert functions again vanish in degree five.
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
  decomposable and pure primitive strata are also excluded, and the mixed
  incidence is empty over a certified nonempty open of primitive `P3`; any
  survivor lies on a proper closed exceptional subset.  No equation or
  dimension bound for that subset is known.  The Hironaka arithmetic
  and all four connection circuits are complete; the 561 constant and
  Hironaka-linear ansätze are excluded.  Attack the exact equation
  \(\mathcal J_\nabla(a)=0\) over the invariant field through a structural
  rational-function family or differential-algebraic argument. See
  `tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`,
  `tmp/degree11_jacobian/REPORT.md`, `tmp/degree12_jacobian/REPORT.md`,
  `tmp/degree12_jacobian_structural/REPORT.md`,
  `tmp/relative_kls_chart/REPORT.md`, and `tmp/kproj_connection/REPORT.md`.
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
  landing \(W\to W\) is excluded through degree 15; Jacobian degeneracy for
  \(W\to W\) completely only through degree 11, with the two pure degree-12
  strata excluded and generic-open emptiness on the mixed primitive
  parameter space; its proper closed exceptional locus remains open. The
  constant-coefficient
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

## 2026-07-28 — Technique import from Problem F (label: AUDIT PASSED, resolution committed)

Problem F (the PSL(2,7) degree-2 del Pezzo, `../F-dp2-psl27/`) is
RESOLVED NEGATIVE: director review and an independent adversarial audit
(from-scratch recomputation of all finite inputs) both passed it, and the
proof in fact shows S is not even G-weakly versal.  The mechanism below
may now be cited as a working engine; novelty-vs-antecedents positioning
is under a separate literature sweep.

### The mechanism: a V₄-fixed exceptional-path obstruction

For a hypothetical equivariant map presented by primitive covariants, F's
capstone (`../F-dp2-psl27/certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md`)
derives a contradiction from four ingredients, none degree-dependent:

1. **Parity forcing on involution eigenloci.**  For an involution `s` and
   `v ∈ E₋(s)`, `s·p(v) = p(−v) = ±p(v)` by degree parity, so `p` maps the
   eigenlocus into `E₊(s)` (even) or `E₋(s)` (odd).  Either way the
   restriction of the map to a *rational* eigenlocus lands in an involution
   fixed locus of the target; when that fixed locus contains no rational
   curve (elliptic-or-points), the restriction is CONSTANT and the constant
   is centralizer-fixed — often already a contradiction (F's odd case dies
   on `D₈` having no invariant line).
2. **Forced basepoints.**  At a point where several involution loci meet
   with distinct forced constant values, the map cannot be regular.
3. **Pointwise-fixed exceptional curves.**  Blowing the basepoint orbit:
   when the stabilizer contains a central involution `z` with SCALAR
   differential, the exceptional curve is pointwise `z`-fixed, so its image
   lies in the target's `z`-fixed locus — constant again, with the value's
   projection pinned by a stabilizer-representation argument
   (`[H,H] ∋ z` kills invariant lines in `E₋(z)`).
4. **The path lemma.**  In an equivariant resolution by point blowups, the
   local total transform over the meeting point of two such curves is a
   TREE; `K = ⟨z,s⟩ ≅ V₄` fixes the endpoint-to-endpoint path vertexwise;
   each intermediate exceptional `ℙ¹` is the projectivized tangent rep of a
   `K`-fixed birth center, so the `ℙ(T_x)`-action factors through one
   character and some nonidentity involution of `K` acts POINTWISE on it.
   Every path component therefore maps constantly into an involution fixed
   locus; adjacency propagates one constant across the path, contradicting
   the distinct forced endpoints.  This kills ALL degrees at once — the
   step that degree-by-degree elimination (F went 24–34 before finding it)
   could not reach.

### Why it plausibly speaks to the Klein cubic

- `PSL₂(𝔽₁₁)` has a single conjugacy class of 55 involutions, and its
  2-Sylow is `(ℤ/2)²` — exactly the `V₄ = ⟨z,s⟩` the path lemma consumes
  (Beauville, *Finite simple groups of small essential dimension*, §16.4.5,
  notes the 2-Sylow fixes points on both Prokhorov threefolds).
- **(verify)** involution eigenspace dimensions on the 5-dim rep `W`
  (expected `(dim E₊, dim E₋) = (3,2)` from the character); then
  `X^t ⊇ X ∩ ℙ(E₊(t))` is a PLANE CUBIC — if smooth for the Klein cubic,
  that is the genus-one no-rational-curves input, and `X ∩ ℙ(E₋(t))` is a
  finite set playing the isolated-points role.
- The parity forcing (1) applies verbatim to covariant quintuples
  `p : W → W`.

### The honest obstacle to a verbatim transfer

F's path lemma is SURFACE mathematics: point blowups, tree dual graphs.
On `ℙ(W) = ℙ⁴` an equivariant resolution has positive-dimensional centers
and 2-complex dual structure; steps (2)–(4) do not port as stated.  The
candidate workaround is dimensional reduction BEFORE resolving: restrict
the hypothetical map to a well-chosen `G`- or `K`-stable rational SURFACE
in `ℙ(W)` (a span-configuration of involution eigenspaces, or a member of
a stable pencil) on which the forced-value dichotomy already lives, and
run F's argument on that surface.  Choosing the slice so that both forced
endpoint values appear on it is the actual work.

### Cheap exact first checks (before any theory)

1. eigen-dimensions of an involution on `W`; 2. smoothness/genus of
`X ∩ ℙ(E₊(t))`; 3. the finite set `X ∩ ℙ(E₋(t))`; 4. explicit `V₄`-fixed
points on `X` and the local characters there; 5. stabilizer structure at
special points of the eigenspace configuration (the `D₈`-analogue), and
whether two involution loci through such a point carry distinct forced
values.  All five are `wp1_fixed_loci.py`-style computations; F's script
is the template.

## 2026-07-28 — Generalizing the F-engine after the first exact check (director)

The worker's finding is confirmed and sharpened.  For an involution `t`,
`X^t = E_t ⊔ L_t` with `E_t = X ∩ ℙ(E₊(t))` a smooth genus-one curve and
`L_t = ℙ(E₋(t))` a LINE CONTAINED IN X — so the F-input "no rational
curve in the fixed locus" fails.  Worse, and new: for `K = ⟨z,s⟩ ≅ V₄`
(the 2-Sylow), the trace-1 involution character forces the joint
`K`-decomposition of `W` to have dimensions **(2,1,1,1)** across the sign
classes `(++, +−, −+, −−)` **(verify exactly — derived from
χ(involution) = 1, consistent with the worker's plane/line split)**.
Hence:

- `L_z ∩ L_s = ℙ(W^{−−})`, and cyclically — the three lines form a
  **triangle inside X** with vertices the three mixed joint eigenpoints;
- each `E_t` passes through the vertex opposite its line
  (`ℙ(W^{+−}) ∈ E_z ∩ L_s ∩ L_{zs}` etc.);
- the `V₄`-fixed configuration is therefore CONNECTED, so bare
  constancy-propagation can never reach an F-style contradiction, even
  where constancy holds.

### The generalized engine to build

Replace "every path component maps constantly" by the corrected local
dichotomy and track the richer state:

1. **Dichotomy.**  A rational path component `C` pointwise-fixed by
   `t_C` maps into `E_{t_C} ⊔ L_{t_C}`: either CONSTANT (elliptic side)
   or into the line `L_{t_C}` — possibly nonconstant.
2. **Rigidity on the line.**  `C` is `K`-stable and `f` equivariant, so a
   nonconstant image in `L_{t_C}` is a `K`-stable irreducible curve in a
   line — the line itself; the residual action of `K/⟨t_C⟩ ≅ C₂` on
   `L_{t_C}` has exactly two fixed points, and they are two vertices of
   the triangle **(verify: the mixed eigenpoints on that line)**.
3. **Transition system.**  Adjacency of path components now propagates a
   FINITE state — a constant value, or a line with marked vertices —
   through the configuration (triangle ∪ three elliptic curves).  The
   obstruction target: show the two forced endpoint values (the E-analogs
   of F's `a_q`, `b_s`, to be computed) are NOT connectable in this
   finite transition system, with degree/parity bookkeeping along
   nonconstant components as the second invariant if pure reachability
   is not enough.
4. **Dimension caveat unchanged:** run it on a `K`-stable rational
   surface slice where both forced values live; the ℙ⁴ resolution issue
   is unchanged from the original note.

### Cheap exact next checks (all `wp1`-style, ranked)

1. The `(2,1,1,1)` joint decomposition and the triangle, exactly.
2. The two residual-fixed points on each `L_t` = which triangle vertices.
3. The incidences `E_t ∩ L_{t'}` for all pairs in one `V₄`, exactly.
4. The E-analog of F's §2: what values are FORCED on involution-fixed
   loci by a hypothetical equivariant `p` (parity trick on `E₋(t)`,
   noting `dim E₋ = 2` now, so "constancy on `L_t`" itself needs the
   §2-style recomputation, not citation).
5. Whether the triangle vertices are smooth points of `X` and their
   stabilizers (the `D₈`-analog data for forced basepoints).

If 4 shows the forced values already land on triangle vertices, the
transition system may CLOSE rather than obstruct — that outcome would be
evidence toward a POSITIVE construction attempt along the fixed
configuration instead, and is worth knowing either way.
