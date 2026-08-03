### RES-01 — Bounded-degree self-covariant landing search (E1)
- tries: positive construction; exhaustive-through-a-bound search for a nonzero homogeneous G-covariant f:W→W of some fixed degree whose image lies in the Klein cubic X (would give a dominant equivariant map U→X).
- sources: RESOLUTION.md "Certified covariant exclusion through degree 24" (~2141–2793) and "Why homogeneous self-covariants are exhaustive" (~1861–1908); SPEC.md task E1 (~1452–1516).
- status_labels: "No nonzero homogeneous polynomial G-covariant W→W of degree at most 15 has image contained in the Klein cubic" (RESOLUTION.md); superseded by "...degree at most 24..." (RESOLUTION.md); "Degree 25 is now the next unrestricted homogeneous landing degree" (RESOLUTION.md); "This is a bounded exclusion only... there is no degree bound; therefore this calculation supplies no negative answer" (RESOLUTION.md).
- runs: degree 7–9 (Gröbner unit ideal); degree 10 (Macaulay2 dim 0); degree 11; degree 12 (msolve leading ideal, dim 0); degree 13 (`M13/fM10` quotient + independent 21-variable Gröbner, `tmp/structural_degree13`, `tmp/degree13_opt`); degree 14 (`tmp/degree14_structural`); degree 15 (`tmp/degree15_structural`); degree 16 (superseded probe `tmp/degree16_landing_probe`, `tmp/degree16_exceptional_search`, then closed by forced-plus-plane injectivity); degrees 17–21 (restriction-rank kernel exclusion, `tmp/covariant_arrangement_module`); degree 22 (V4-line linear algebra); degree 23/24 (chart unit ideals, independent from-scratch audits); degree 25 structural probe (`tmp/degree25_structural_probe`, open) plus the large `m1_relative_border_p19/p20/p21_d5` chain bounding `dim L_25≤15` without closing it.
- confidence: certain

### RES-02 — Problem F involution-mechanism import / 55-plane D10–D12 arrangement continuation
- tries: import the surface-path technique used to solve a related "Problem F" (involution fixed-plane/fixed-line blowup argument) to push the bounded landing-covariant analysis past degree 24 via the full 55-plane/55-line/D10/D12-point arrangement.
- sources: RESOLUTION.md "2026-07-29 structural advances" items 12–13 (~806–974).
- status_labels: "the rational fixed line invalidates the constant-image step in Problem F's surface path proof" (import itself fails as direct proof); "the leading common-line order-exactly-three system factors through 37 dimensions and was not sent to a nonlinear solver... Since degree 25 is odd, no universal minus-line vanishing relation may be added either" (open).
- runs: D10/D12 symbolic module and `m1_compact_degree25` plane/line/point construction (+two independent audits); Derksen–Sidman free-fibre regularity / `T_m` saturation (`tmp/symbolic_global_exactness`, `tmp/m1_t1_f3_colon_attack`, `tmp/m1_t1_char0_d35_gate`); `m3_line_point_boundary` D12 rank-8/8 point closure.
- confidence: inferred (explicit "Problem F" label is verbatim; the grouping of degree-25 continuation runs under it follows the text's own cross-reference).

### RES-03 — Explicit generic-twist frame (x,C,D,E,K covariant basis)
- tries: infrastructure/positive partial construction; build an explicit Hilbert-90 trivialization from primitive covariants x,C,D,E,K (degrees 1,4,5,6,7, nonzero determinant Δ), reducing the generic-twist point problem to one cubic Φ(a)=0 in 5 variables over K_proj=C(P(W))^G.
- sources: RESOLUTION.md "Explicit generic-twist frame" (~1784–1955) and "All-degree self-covariant normal form" (~3166–3269).
- status_labels: "This completes the generic ambient-space descent explicitly. It does not produce a nonzero a∈K_0^5 with Φ(a)=0; that is precisely the remaining generic-twist point problem" (RESOLUTION.md).
- runs: three-coordinate frame planes (ten smooth genus-one plane sections; degree 11–14 landing-ansatz exclusion; degree 15 no verdict); rational-flex exclusion on all ten planes; degree-free Jacobian/flat-connection equation J_∇(a)=0 (561 literal ansätze excluded; PDE itself open).
- confidence: certain

### RES-04 — `xCD` flex/3-descent plane-section attack
- tries: decide whether the ternary cubic F(ax+bC+cD)=0 (the "xCD" plane section) has a K_proj-rational point, via genuine elliptic 3-descent (flex algebra, E[3]-Kummer class α_R) and via singularity/factoriality analysis of an associated total space C6 over the Klein-sextic base H6.
- sources: RESOLUTION.md "The xCD flex and 3-descent audit" (~1956–2140); "2026-07-28 exact advances" items 4,7 (~1209–1381); "2026-07-29 structural advances" item 6 (~858–907); director-review section (~3649–3728).
- status_labels: "the original projective xCD plane cubic has no K_proj,C-point" (RESOLUTION.md, proved for this plane); "This closes only the plane section F(a*x+b*C+c*D)=0, not the full generic twisted Klein cubic threefold; the headline remains open" (RESOLUTION.md, SPEC.md E3).
- runs: fake-vs-genuine descent distinction; α_R = det(M0)/ℓ(M0)^3 Kummer construction; discriminant-divisor local solubility; gauge divisors A=0/B=0/C=0; f5=0/f6=0 smooth-reduction residues; retired local class-image/Rees-lattice route; Jung–Saito defect/factoriality computation (`xcd_actual_class_image`, `xcd_repeated_factor_incidence`, `xcd_general_slice_completion`); singular-locus dim≤1 proof; SGA2 Picard-restriction theorem.
- confidence: certain

### RES-05 — Six-dimensional Schur projective-source route (E2)
- tries: find a rational G-equivariant map P(V6)⇢X from the six-dimensional Schur representation of SL2(11); by the projective-source lemma any such map is automatically dominant and, via index-2 Brauer splitting plus quadratic descent, would solve the headline.
- sources: RESOLUTION.md "Six-dimensional projective-source route" (~2795–3086); SPEC.md item 9 and task E2 (~550–592, 1517–1563).
- status_labels: "the projective-source route is not a resolution" (RESOLUTION.md); degree-12 "remains open" after a terminal solver nonverdict (`tmp/step4_degree12_solver_terminal`); "the exact solve timed out... no leading output" (SPEC.md).
- runs: constant-coefficient exclusions in degrees 4,6,8,10; irreducibility of the degree-six pencil; degree-eight rational frame (K_Schur field); ten coordinate-line exclusions; ten coordinate-plane smoothness; ternary S12-space exclusions (degrees 0,4,6,8,10,12); degree-12 decomposable/primitive exclusion and terminal solver stop.
- confidence: certain

### RES-06 — Degree-19 Cayley–Bacharach residual-curve construction on the generic Schur twist
- tries: positive construction — starting from the accepted degree-55 D12-stabilized line-orbit point on the generic Schur twist, build a G-equivariant degree-19 curve through it whose residual intersection would force a rational point (alternatively, seek a torsor-dependent no-point obstruction).
- sources: RESOLUTION.md "2026-07-30 audited advances" item 2 (~350–386); SPEC.md ~109–144.
- status_labels: "Both non-ACM branches remain" (RESOLUTION.md); "no geometrically integral ACM degree-19 curve works" (excluded only for one descended hyperplane-selected point); "this is an exact non-ACM frontier, not a nonexistence theorem" (RESOLUTION.md).
- runs: `schur_degree19_structural_design`(+audit), `schur_degree19_nonacm_attack`(+audit); Y=V(f3,f5) genus-31 complete-intersection construction; Rao-dimension computation (0,16,29,38,42,40+ε); (5,6)/(5,7) complete-intersection link residual-genus checks.
- confidence: certain

### RES-07 — Pfaffian Hermitian gate: quaternion/Morita idempotent construction (E4)
- tries: reduce the headline to existence of a common isotropic right D-line for a 5-plane of Hermitian forms on D^3 (D a quaternion division algebra coming from the nonsplit Schur Brauer class), by constructing an explicit 36-dimensional descended algebra with involution, extracting a rank-2 Morita idempotent, quaternion core, and the five Hermitian matrices.
- sources: RESOLUTION.md "2026-07-30 audited advances" item 3 (~388–500); "Other audited boundaries" Pfaffian bullet (~3371–3416); "Current open boundary" bullet; SPEC.md item 8 and task E4 (~961–1000, 1603–1663).
- status_labels: "A common line for the generic tuple proves the headline positively" (open); "every individual Hermitian member is isotropic... only simultaneous common-line isotropy remains open" (RESOLUTION.md/SPEC.md); "no explicit K_proj coordinates, quaternion corner, or common isotropic line are known" (SPEC.md); matched covariants "excluded through degree fifteen... degree sixteen is a strict solver nonverdict."
- runs: `pfaffian_generic_schur_audit`, `pfaffian_explicit_descent`(+audit), `pfaffian_25plus11_descent`(+audit), `quadratic_grassmannian_covariant`, `pfaffian_rank2_idempotent_attack`(+hostile audit), `pfaffian_binary_cubic_attack`(+geometric audit), `pfaffian_ternary_cubic_triage`(+hostile audit), `pfaffian_minimal_ternary_model`(+audit); the "FAIL-SCOPE" bridge audit that corrected the scope of the "abstract K_proj-point" claim.
- confidence: certain

### RES-08 — Minimal fixed-frame triple (0,1,2) explicit genus-one point construction
- tries: continuation of RES-07 using the minimal fixed coordinate triple (0,1,2): build the depressed genus-one model F=u^3+u(q0v²+q1vw+q2w²)+r0v³+...=0 over K_proj, compute its Hessian/Jacobian/flex data, then decide the point problem via D5/f5=0 residual local analysis, E[3]/Kummer descent, a BKK degree-6 field computation with monodromy, and singularity/Picard analysis of an auxiliary "target incidence" of candidate F-conics.
- sources: RESOLUTION.md "2026-07-30 latest fixed-frame result" (~97–303).
- status_labels: "The main question is again... The answer remains OPEN" (RESOLUTION.md); "D5 is no longer a possible local obstruction" (retired); "f5=0 is also locally soluble and retired" (SPEC.md); "The residual point itself fails globally by B*rB(t1)!=0... A point with varying direction is not excluded" (RESOLUTION.md); "None of these statements constructs or excludes the full 15-coordinate self-adjoint Pfaffian idempotent, and none settles the headline" (RESOLUTION.md).
- runs: `pfaffian_depressed_torsor_next`(+audit), `pfaffian_torsor_valuation_attack`(+audit), `pfaffian_depressed_alpha_r`(+audit), `pfaffian_alpha_local_kummer`(+audit), `pfaffian_d5_residual_attack`(+audit), `d5_degree_bound_invariant_salvage`, `pfaffian_d5_degree_projective_audit`; BKK sparse determinant + independent hostile replay proving [K_proj:F]=6, monodromy S6; `target_branch_delta_saturated_singularity`/`HESSIAN_PROOF_AUDIT` singular-point and Hessian-rank computations.
- confidence: inferred grouping under RES-07 (same Pfaffian/F14-bridge target); the individual runs and their open status are certain.

### RES-09 — KLS (Kraft–Loetscher–Schwarz) covariant-dimension / all-degree Jacobian criterion
- tries: negative/structural route reformulating ed(G)=3 as "some nonzero homogeneous self-covariant f:W→W has identically zero Jacobian determinant" (not necessarily landing in X), and searching this all-degree rather than by a bounded landing search.
- sources: RESOLUTION.md "Covariant-dimension criterion and the third symmetric power" (~3087–3165); SPEC.md item 10 (~593–617).
- status_labels: "Neither the KLS theorem nor finite generation of the covariant module gives an all-degree cutoff; an explicit S5-module counterexample rules out that shortcut. All higher degrees also remain open for this Jacobian test" (RESOLUTION.md); degree≤11 fully excluded (dominant); degree 12 "remains open only over a proper closed exceptional subset of the mixed parameter space."
- confidence: certain

### RES-10 — KLS minimal-contraction / vertical-divisor / foliation obstruction program
- tries: prove no minimal landing self-covariant exists (i.e. h=1 / ed(G)=4) by studying the image hypersurface H=V(F), the contracted-gradient gcd h, log-canonicity of the induced foliation, and vertical/nonnormal divisor geometry (LC-minimality lemma + vertical-divisor comparison lemma).
- sources: RESOLUTION.md "2026-07-29 structural advances" items 1–3 (~532–733); "2026-07-30 audited advances" item 1 (KLS conductor/discrepancy, ~309–386); "2026-07-28 exact advances" item 3 (~1166–1206); director-review KLS paragraph (~3730–3759); "Current open boundary" bullet.
- status_labels: "the headline remains open... h=1 remains unproved" (RESOLUTION.md); "The KLS route therefore needs both an LC-minimality lemma and a vertical-divisor comparison lemma, or direct canonicity of one minimal image" (SPEC.md); "Further negative progress requires the minimal-contraction lemma or canonicity for one minimal solution, not another finite sparse-support sweep" (RESOLUTION.md).
- runs: `kls_minimal_contraction_attack`, `kls_vertical_divisor_geometry`(+audit), `kls_nonstable_vertical_orbits`(+audit), `kls_a5_logarithmic_divisor`, `kls_wstar_first_integrals`, `kls_degree28_stein_fixed_point`, `kls_a5_linearized_pencil_obstruction`(+audit), `kls_a5_conductor_surface_feasibility`(+audit), `kls_structural_successor`, `kls_global_foliation_theorem`, `kls_discrepancy_next_gate`(+audit), `kls_divisor_ansatz`, `kls_residue_next`, `kls_first_jet_two_fiber`/`three_fiber`, `kls_structural_audit`.
- confidence: certain

### RES-11 — Fable A4-trisection / Koszul lifting construction
- tries: positive construction — at a V4-fixed centre (normalizer A4), build an A4-equivariant degree-3 birational trisection map to a cubic surface S(a,b,c), then iteratively lift compatibility across the whole 55-plane/D10/D12 arrangement via symbolic Rees powers I^(m)/I^(m+2), aiming for an actual landing covariant.
- sources: RESOLUTION.md "2026-07-29 structural advances" item 4 (~734–857); SPEC.md task E1 continuation (~1488–1516) and pitfalls (~1763–1781).
- status_labels: "the one-centre trisection gate is solved" (positive sub-result, RESOLUTION.md); "the global factorized Koszul family cannot reach I11/I13"; "The proposed primitive nonfactorized continuation is impossible as well... every normal-order 3/4 planewise extension retaining these line germs is closed; a Fable escape must change the boundary or leading normal order. No later correction or algebraization is proved. This is a scoped negative landing theorem" (RESOLUTION.md).
- runs: `fable_positive_construction`, `fable_trisection_attack`, `fable_trisection_compatibility`, `fable_nonlinear_first_gate`, `fable_resolved_descent`, `fable_constrained_cokernel`(+audit), `fable_finite_d12_constrained`, `fable_d12_char0_bridge`(+audit), `fable_d12_rees_sigma_interface`(+audit), `fable_first_gate_koszul`(+audit), `fable_d12_simultaneous_successor`, `fable_order12_qsection_correction`, `fable_d12_joint_rank`, `fable_d12_koszul_rank`, `fable_d12_module_adversary`, `fable_d12_bulk_correction_rank`, `fable_d12_triangular_bulk_closure`, `fable_relative_divisor_trace_obstruction`, `fable_fixed_plane_boundary_adversary`, `fable_relative_q_trace_obstruction`, `fable_nonfactorized_successor`, `fable_nonfactorized_syzygy_obstruction`, `fable_nonfactorized_feasibility`.
- confidence: certain

### RES-12 — Voisin X^[3] very-versality construction
- tries: use Voisin's rank-2-vector-bundle construction (dominant map from a product of Grassmannians to the Hilbert scheme X^[3] of 3 points on the Klein cubic) to obtain a G-very-versal auxiliary variety, hoping to equivariantly select one of the three points and reduce to X.
- sources: RESOLUTION.md "Six-dimensional projective-source route" closing paragraph (~3150–3164); SPEC.md item 10 end (~613–616) and pitfalls (~1729–1730).
- status_labels: "C^[3] is G-very-versal" (proved positive infrastructure); "This nine-dimensional variety does not improve the essential-dimension bound and does not select one of the three points... the apparent selection step is circular" (RESOLUTION.md); listed pitfall: "very versality of X^[3] without a rational equivariant operation selecting one point of its degree-three cycle."
- confidence: certain

### RES-13 — Finite-orbit / secant / binary-chord-tree construction
- tries: positive classical-geometry construction using fixed-point orbits of maximal subgroups (A5, 11:5, D12) and secant/chord (third-intersection) constructions, attempting to iteratively reduce a G-orbit to a single point or pair.
- sources: RESOLUTION.md "Finite-orbit and secant audit" (~3270–3327).
- status_labels: "This excludes only finite-orbit binary folding. It does not exclude a continuous covariant mixing an entire orbit at once" (RESOLUTION.md); "no such binary chord tree reaches a singleton or a two-point orbit"; for the 220-point orbit, "A torsor-dependent semilinear degree-74 interpolation curve would evade this argument and would solve the problem, but constructing it is another form of the unresolved varying-covariant problem" (open).
- confidence: certain

### RES-14 — Level-11 theta/Schwarz modular construction attempt
- tries: positive-construction attempt testing the July 2026 level-11 theta/Schwarz map construction (Kopeliovich–Sanabria), matched to the correct projective representation, for a landing map.
- sources: RESOLUTION.md "2026-07-28 exact advances" item 5 (~1267–1271).
- status_labels: "This particular recent modular lead is therefore closed" (RESOLUTION.md); F(HΦ11)=ξ44^5u^11+O(u^99)≠0; "all 25 classical Hessian-minor tests are nonzero."
- confidence: certain

### RES-15 — Gross–Popescu modular-moduli reinterpretation (rejected route)
- tries: examine whether Gross–Popescu's identification of the level-structure moduli space A^lev_11 with the Klein cubic (with matching change-of-level G-action) furnishes an equivariant parametrization.
- sources: RESOLUTION.md "Other audited boundaries" bullet (~3343–3350).
- status_labels: "This does not furnish an equivariant parametrization... No linear or already very versal source for the deck action is produced, so the modular interpretation restates rather than solves the current problem" (RESOLUTION.md).
- confidence: certain

### RES-16 — Kresch–Tschinkel integral decomposition of the diagonal (rejected obstruction tool)
- tries: test whether the equivariant integral-decomposition-of-the-diagonal / equivariant Burnside-invariant machinery can supply a negative obstruction.
- sources: RESOLUTION.md "Other audited boundaries" bullet (~3417–3423).
- status_labels: "does not furnish a new obstruction here... failure of decomposition would not obstruct mere G-unirationality. Conversely, its existence would not prove G-unirationality" (RESOLUTION.md).
- confidence: certain

### RES-17 — Universal-torsor / higher Amitsur cohomological obstruction route (E3)
- tries: negative route seeking a cohomological obstruction (universal-torsor class, higher Amitsur groups, Brauer group of twists) to G-unirationality.
- sources: RESOLUTION.md "Other audited boundaries" bullet (~3424–3431), "2026-07-29 structural advances" item 5 (~862–866); SPEC.md task E3 (~1581–1583).
- status_labels: "The ordinary and all higher Amitsur obstructions vanish, even after restriction to subgroups... These are necessary-condition checks, not point theorems" (RESOLUTION.md); "That branch is closed unless a new dominance-functorial invariant is introduced" (SPEC.md).
- confidence: certain

### RES-18 — Prime-local essential-dimension bound (rejected negative route)
- tries: attempt to force ed(G)=4 via prime-local essential dimensions ed_p(G).
- sources: RESOLUTION.md "Other audited boundaries" bullet (~3432–3433); "Explicit generic-twist frame" (~1856–1858).
- status_labels: "Prime-local essential dimension cannot force the value four: the local values are two at 2 and one at 3, 5, and 11" (RESOLUTION.md).
- confidence: certain

### RES-19 — Birational superrigidity route (rejected as insufficient for a negative answer)
- tries: examine whether known G-birational superrigidity of X could itself supply a negative resolution.
- sources: RESOLUTION.md "Unconditional starting point" item 7 (~394–397), "Other audited boundaries" last bullet (~3434–3435); SPEC.md pitfalls list.
- status_labels: "Birational rigidity is not a negative answer... a dominant map U-->X may have degree greater than one" (RESOLUTION.md/SPEC.md); "Equivariant birational superrigidity excludes birational linearization, not a dominant equivariant map of higher degree."
- confidence: certain

### RES-20 — Cassels–Swinnerton-Dyer conditional route
- tries: conditional positive route — invoke the CSD conjecture (cubic hypersurface with a zero-cycle of degree prime to 3 has a rational point) for the restricted family of Klein-cubic twists, all of which already carry a degree-one zero-cycle.
- sources: RESOLUTION.md "Conditional forks and stakes" (~412–436); SPEC.md same section (~412–436); SPEC.md task E2 bullet (~1525–1526).
- status_labels: "would prove that X is G-unirational and ed(G)=3" (conditional, unproved); "A proof conditional on one of the conjectures below is not a resolution unless that conjecture is proved in the required case" (RESOLUTION.md/SPEC.md).
- confidence: certain

### RES-21 — Duncan–Reichstein Conjecture 8.8 conditional route
- tries: conditional positive route — invoke Conjecture 8.8 (Sylow-subgroup versality implies G-versality); since every Sylow restriction on X is already versal (Condition A holds), this would give G-unirationality directly.
- sources: RESOLUTION.md "Conditional forks and stakes" (~417–419, ~435–436).
- status_labels: "would prove that X is G-unirational and that ed(G)=3" (conditional, unproved); a negative headline resolution "would also refute Duncan–Reichstein Conjecture 8.8 in this example, because every Sylow restriction is already versal" (RESOLUTION.md).
- confidence: certain

### RES-22 — Dolgachev Crdim(G)≤ed(G) conditional route (toward a negative answer)
- tries: conditional negative route — invoke Dolgachev's proposed inequality Crdim(G)≤ed(G); since Prokhorov proves Crdim(G)=4, this would force ed(G)=4 and rule out G-unirationality.
- sources: RESOLUTION.md "Conditional forks and stakes" (~424–436).
- status_labels: "would instead give ed(G)=4, which rules out G-unirationality of X" (conditional, unproved); "a positive solution would give ed(G)=3 and a counterexample to Dolgachev's proposed inequality" (RESOLUTION.md).
- confidence: certain

### RES-23 — Exact reduction theorem: X is G-unirational ⟺ ed_C(G)=3
- tries: proved infrastructure result (not itself a resolution) — via Prokhorov's Cremona-rank-3 classification, the Tschinkel–Zhang Pfaffian bridge to F14, and a "quadratic descent for cubics" lemma, shows the headline is equivalent to the single numeric dichotomy ed(G)∈{3,4}.
- sources: RESOLUTION.md "Exact reduction to essential dimension" (~1613–1737); SPEC.md "There is also a stronger unconditional reduction..." (~439–455).
- status_labels: theorem proved unconditionally ("This proves the theorem", RESOLUTION.md); "This exact reduction still does not choose between the two values, so the headline remains open" (SPEC.md).
- confidence: certain

### RES-24 — E0: exact action and twist infrastructure (stub/infrastructure task)
- tries: infrastructure — fix exact matrices for G→GL(W), verify faithfulness, cubic invariance, Sylow/abelian fixed loci, and construct an explicit generic torsor / Hilbert-90 model.
- sources: SPEC.md task E0 (~1436–1450); RESOLUTION.md "Exact action" (~1738–1783).
- status_labels: "This is infrastructure, not a resolution" (SPEC.md); underlying facts certified (exact cyclotomic generator matrices, full 660-element Cayley-graph check, invariance of F verified).
- confidence: certain

### RES-25 — Path T (REPAIR.md pointer, visible only as a boundary-table entry)
- tries: (per pointer only, elaborated in REPAIR.md, out of this lens) a finite generic-rank-one/birational "fold" construction, together with claims labeled T-BIRATIONAL, T-NONNORMAL, and dim Sing_S=2 concerning normalization/singular-locus dimension of some surface S.
- sources: RESOLUTION.md and SPEC.md "2026-07-31 theorem-boundary repair" tables (~lines 37–90 in both files, identical content).
- status_labels: "Path T: T-BIRATIONAL — retained at its stated generic/open theorem boundary"; "Path T: T-NONNORMAL — suspended; not proved by the current T2 packet; pending T2R gate"; "Path T: dim Sing_S = 2 — unproved; current exact cuts do not establish it; pending T2R"; "T-NONNORMAL — suspended"; "'normalization defect is divisorial' — unproved"; "'Ann_B(S/B) is the normalization conductor' — false notation; conductors separated" (all verbatim, RESOLUTION.md/SPEC.md).
- runs: T2 packet; T2R gate (pending); `certificates/fold_normalization*` (owned by a concurrent worker per the note).
- confidence: certain (existence/labels); content largely opaque within this lens — inferred only.

### RES-26 — Path G / Path G4.1 / P25.1 (REPAIR.md pointer)
- tries: (per pointer only) a finite-truncation search with isolation cutoff N⋆=d+2m+1, degree-13/19 "obstruction" claims, a symbolic free-fibre recurrence (G4.1), and a scoped degree-25 continuation (P25.1) — plausibly related to the degree-N landing/Rees-module material of RES-01/RES-02 but not confirmed connected within this lens.
- sources: RESOLUTION.md and SPEC.md repair tables (same line ranges as RES-25).
- status_labels: "Path G: finite truncation and isolation cutoff N⋆=d+2m+1 — retained"; "Path G: degree-13/19 'obstruction' labels — downgraded to sample residuals (G13-SAMPLE-RESIDUAL, G19-SAMPLE-RESIDUAL)"; "Path G4.1 symbolic free-fibre recurrence — retained at its stated free-fibre boundary"; "P25.1 P25-TOWER-SURVIVES — retained as scoped free-fibre/degree-25 continuation"; "G13-OBSTRUCTION / G19-OBSTRUCTION — nonzero selected sample residuals" (all verbatim).
- confidence: certain (labels/status); mathematical content inferred/unconfirmed within this lens.

### RES-27 — Path A (REPAIR.md pointer)
- tries: (per pointer only) a P^1-reduction and "index-34 duality," plus an executable extraction interface ("L,V_Z") for a Pfaffian idempotent via a "single-minor"/Krylov-minor formulation — plausibly connected to the explicit-extraction machinery of RES-07/RES-08 (Morita idempotent, 15-element Sym(A,σ) basis) but not confirmed within this lens.
- sources: RESOLUTION.md and SPEC.md repair tables (same line ranges as RES-25).
- status_labels: "Path A P^1-reduction — retained"; "Path A index-34 duality — retained"; "Path A single-minor formulation — corrected to the ideal of all maximal minors"; "Path A executable L,V_Z claim — downgraded to an abstract interface"; "one universal nonzero Krylov minor — ideal of all maximal minors / pointwise cover"; "exact executable generic L,V_Z — abstract interface only" (all verbatim).
- confidence: certain (labels/status); mathematical content inferred/unconfirmed within this lens.

### RES-28 — Hodge-center split-injection theorem (REPAIR.md pointer)
- tries: (per pointer only) a Hodge-theoretic "Hodge-center" conclusion proved via a split-injection theorem, later rewritten through a relatively-ample class after the 2026-07-31 repair.
- sources: RESOLUTION.md and SPEC.md repair tables (~lines 48/66 and 62/80 respectively).
- status_labels: "Hodge-center conclusion — salvageable; proof rewritten via relatively ample class (REPAIR.md §8)"; "corrected Hodge-center split-injection theorem after §8 substitution" (listed among trusted results retained).
- confidence: certain (existence/labels); mathematical content unknown within this lens — inferred only.