### INF1 — Essential-dimension equivalence (RESOLUTION.md reduction)
- tries: infrastructure/positive framework — proves `C` is `G`-unirational iff `ed_C(G)=3`, via Prokhorov's two-model classification, the twisted Pfaffian bridge (index ≤2 Brauer class), and quadratic descent for cubic points; reduces headline to whether the generic projective torsor `C_gen` has a `K_proj`-point.
- sources: HANDOFF.md "Strongest proved progress" item 1; "Best re-entry points" ("Essential dimension"); "Theorem boundaries".
- status_labels: proved equivalence stands; "none of the audited local, Brauer, Amitsur, or standard stable-cohomology invariants decides whether it has a point"; headline "OPEN".
- runs: `tmp/step4_essential_dimension/` (REPORT.md, verify_reductions.py).
- confidence: certain

### INF2 — Certified invariant-theory infrastructure
- tries: infrastructure — exact cyclotomic matrices for the 660-element `G`-action, Klein-cubic invariance checks, exact Molien dimensions; underlies every other route.
- sources: HANDOFF.md "Strongest proved progress" item 2; "Verification" §.
- status_labels: certified/checked-in; no obstruction/positive claim itself.
- runs: `certificates/exact_weil_check.py`, `certificates/exact_molien.py`, `certificates/exact_covariants_check.py`.
- confidence: certain

### INF3 — Generic covariant frame construction (x,C,D,E,K)
- tries: infrastructure — trivializes the generic twisted ambient five-space with primitive covariants of degree 1,4,5,6,7 (determinant nonzero at a sample point), writes `F(Ma)=0` over `C(W)^G`; excludes all ten frame coordinate lines as trivial roots.
- sources: HANDOFF.md "Strongest proved progress" item 3.
- status_labels: "explicitly trivializes"; ten coordinate lines "excluded"; frame point must use ≥3 coordinates.
- runs: none named beyond the frame construction itself (feeds items 4–11).
- confidence: certain

### INF4 — K_proj generic arithmetic / flat-connection interface
- tries: infrastructure — algebraic independence of the five primaries, free Hironaka basis (12 secondaries), full multiplication table, τ-normalized degree-12 model; recasts KLS problem as the degree-free equation `det[a,∇₁a,...,∇₄a]=0` on `P⁴(C(P(W))^G)`.
- sources: HANDOFF.md "Strongest proved progress" item 6.
- status_labels: "certified"; "No solution or universal-nonvanishing theorem is known"; 121 constant/440 Hironaka-linear ansätze and 15 gradient-cross-product covariants "fail to land".
- runs: `tmp/kproj_arithmetic/`, `tmp/kproj_connection/`, `tmp/covariant_module/`, `tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`.
- confidence: certain

### R1 — Path G: bounded landing self-covariant search (W→W into cone C)
- tries: positive construction (search) — exhaustive/finite-truncation search for a homogeneous self-covariant `W→W` landing on the Klein cubic `C`, using an "isolation cutoff `N⋆=d+2m+1`"; degree-by-degree exclusion via Macaulay2/msolve through degree 24, with a quartic-precomposition trick (degree-256 endomorphism `c`) showing no all-solutions degree bound can exist.
- sources: HANDOFF.md repair table (lines 38–39); "Strongest proved progress" item 4; "Best re-entry points" ("Higher covariants"); degree13–25 narrative blocks.
- status_labels: "Path G: finite truncation and isolation cutoff (N⋆=d+2m+1) — retained"; "Path G: degree-13/19 'obstruction' labels — downgraded to sample residuals (`G13-SAMPLE-RESIDUAL`, `G19-SAMPLE-RESIDUAL`)"; degrees through 24 "excluded"; degree 25 "the first bounded unknown"; "A search through any finite degree is not a negative resolution."
- runs: `tmp/structural_degree13`, `tmp/degree14_structural`, `tmp/degree15_structural`, `tmp/degree16_landing_probe`, `tmp/degree22_compression`, `tmp/degree23_common_line_landing`, `tmp/degree24_landing`, `tmp/degree25_structural_probe`.
- confidence: certain (bounded-search facts); Path‑G label mapping to this narrative: inferred (label only appears in the repair summary table, not attached in-line to these degree runs).

### R2 — Path G4.1: symbolic free-fibre recurrence
- tries: infrastructure/negative — proves for every fixed symbolic order `m`, the iterated "plane normalization → triple-line equalizer → residual point kernel" construction equals the sheaf of `I^(m)/I^(m+2)` in every twist, up to a finite irrelevant-torsion module `T_m`; over split `F_67`, `[(T_1)_d⊗W]^G=0` through degree 34 but is 1-dimensional in degree 35, refuting the proposed all-degree zero-colon shortcut.
- sources: HANDOFF.md repair table (line 40); "2026-07-28 delta" symbolic-successor block (~lines 1067–1110, 3407–3477).
- status_labels: "Path G4.1 symbolic free-fibre recurrence — retained at its stated free-fibre boundary"; "the split-fibre all-degree colon is therefore refuted"; "target-1,572 certificate ... refuted".
- runs: `tmp/symbolic_global_exactness`, `tmp/m1_compact_graded_pilot`, `tmp/m1_t1_saturation`, `tmp/m1_t1_f3_colon_attack`, `tmp/m1_t1_f3_colon_degree35_audit`, `tmp/m1_t1_char0_d35_gate`.
- confidence: inferred (verbatim retained/status from repair table; content identification from surrounding narrative is inferred by proximity/topic match)

### R3 — P25.1: degree-25 tower continuation (relative border/Fitting)
- tries: infrastructure/negative-search continuation — pushes the degree-25 landing-locus exclusion via a rank-28 border-basis presentation and coordinate-chart emptiness (`P^18`,`P^19`,`P^20`,`P^21`) to shrink `dim Z` from ≤23 down to ≤15 (char-0 promoted), with `P^21` a strict nonverdict (`3933 ≤ rank ≤ 7910`).
- sources: HANDOFF.md repair table (line 41); "2026-07-28 delta" (~lines 1111–1242, 3454–3477).
- status_labels: "P25.1 `P25-TOWER-SURVIVES` — retained as scoped free-fibre/degree-25 continuation"; "dim Z<=15"; "No `P^22` or successor slice is authorized."
- runs: `tmp/m1_relative_border_rank28`, `tmp/m1_relative_border_maxslice`, `tmp/m1_relative_border_p19_d5`, `tmp/char0_lift_p19_d5`, `tmp/m1_relative_border_p20_d5`, `tmp/char0_lift_p20_d5`, `tmp/m1_relative_border_p21_d5_design`.
- confidence: inferred (label from repair table; content match inferred)

### R4 — Jacobian-zero self-covariant search (direct KLS criterion)
- tries: positive-construction search — KLS alternative theorem: `ed(G)=3` iff a nonzero homogeneous self-covariant `W→W` has identically zero Jacobian; exhaustive search through degree 11 fully, degree 12 reduced to a proper closed exceptional locus (empty on a certified open).
- sources: HANDOFF.md "Strongest proved progress" item 10; "Best re-entry points" ("Covariant dimension").
- status_labels: "every such covariant through degree 11 is dominant; no degree cutoff is known"; degree 12 "remains open only on a proper closed exceptional locus."
- runs: `tmp/degree10_jacobian`, `tmp/degree11_jacobian`, `tmp/degree12_jacobian`, `tmp/degree12_jacobian_structural`, `tmp/relative_kls_chart`.
- confidence: certain

### R5 — Projective Schur source landing search (V6→W, constant coefficients)
- tries: positive construction — any rational `G`-map `P(V6)⇢C` solves the headline (index ≤2 descent); exhaustive constant-coefficient search excludes degrees 4,6,8,10; degree 12 reconstructed (dim 48) but only decomposable/low-primitive-support slices excluded, full-rank char-23 solve (rank 1,124) times out.
- sources: HANDOFF.md "Strongest proved progress" item 9; "Best re-entry points" ("Projective Schur source").
- status_labels: "Complete constant-coefficient landing loci are empty in degrees 4, 6, 8, 10"; degree 12 "remains open"; "Finite scans still cannot prove a negative answer."
- runs: `tmp/projective_source`, `tmp/projective_source_degree12*`, `tmp/step4_degree12_solver_terminal`.
- confidence: certain

### R6 — Pfaffian matched-covariant landing search (F14 cone, degrees 12–16)
- tries: positive-construction search — search for polynomial covariants matching into the `F14` Pfaffian cone; degrees 12–15 excluded, degree 16 fully reconstructed (80-dim space, 1,313 necessary quadrics) but solver times out without leading ideal.
- sources: HANDOFF.md "Strongest proved progress" item 7; "Best re-entry points" ("Pfaffian branch").
- status_labels: "Matched polynomial covariants into the F14 cone are excluded only through degree 15"; "degree 16 remains open for the Pfaffian target."
- runs: `tmp/fano14_twist`, `tmp/fano14_degree12`, `tmp/fano14_degree16`.
- confidence: certain

### R7 — KLS conductor geometry / A5-quadric P22 branch closure
- tries: negative obstruction — proves that for normal images `H`, an invariant `A5`-stabilized smooth quadric (and the squarefree orbit-11 product `P22`) cannot divide the gcd `h` of a rank-four self-covariant's landing derivatives, via a general normal-image multiplicity theorem `rad(h)|b`, `s-ρ≥r+d(e-5)+4`.
- sources: HANDOFF.md "2026-07-29 structural KLS, Schur, and Pfaffian update"; "2026-07-30 audited delta" item 1.
- status_labels: "now closed" (A5-quadric branch); "does not construct a KLS self-covariant or conductor surface"; nonnormal-conductor branch remains open; KLS degree identity "still forces `d<=9`" for a `P22·k` variant.
- runs: `tmp/kls_a5_linearized_pencil_obstruction`, `tmp/kls_a5_conductor_surface_feasibility`, `tmp/kls_actual_conductor_geometry`, `tmp/kls_proper_multiple_structure`.
- confidence: certain

### R8 — KLS minimal-contraction / vertical-divisor comparison
- tries: negative/paired obstruction — a minimal rank-deficient self-covariant's image gcd `h` is invariant with every prime factor's zero locus a Darboux-invariant leaf divisor; individually-`G`-stable vertical components force resolution irregularity ≥26 (or ≥12 for `11:5`-stabilized orbit-12 components), excluding rational/klt/canonical/plt; log-canonicity of the kernel foliation would give a Spicer–Tasin reduced divisor bridge.
- sources: HANDOFF.md "2026-07-29 structural KLS..." (KLS branch); "Current structural ledger" item (2).
- status_labels: "sharpened without a degree sweep"; "does not prove h=1"; "surviving theorem is genuinely paired: prove LC-minimality ... and a vertical-divisor comparison ... or prove the minimal image canonical directly."
- runs: `tmp/kls_minimal_contraction_attack`, `tmp/kls_vertical_divisor_geometry` (+ audit), `tmp/kls_nonstable_vertical_orbits`, `tmp/kls_wstar_first_integrals`, `tmp/kls_degree28_stein_fixed_point`.
- confidence: certain

### R9 — Pfaffian nonsplit Brauer obstruction & quaternionic reduction
- tries: negative obstruction + reduction — shows the generic projective Schur boundary class is nonzero of index 2 in `Br(K_proj)`, so `P(V6)` twist is a nonsplit non-stably-rational Severi–Brauer fivefold with no stable linear replacement; passing to 2-planes gives `SB_2(A_proj)=P²_{D_proj}`, which is rational, reducing the residual gate to a common isotropic right `D`-line for five Hermitian forms.
- sources: HANDOFF.md "Strongest proved progress" item 7; "2026-07-29 structural KLS, Schur, and Pfaffian update".
- status_labels: "now proved nonzero"; "generic Brauer class has period and index exactly two"; "anisotropic-member certificate is now impossible"; residual "common isotropic right D-line" gate "open".
- runs: `tmp/pfaffian_generic_schur_audit`, `tmp/pfaffian_explicit_descent`.
- confidence: certain

### R10 — Pfaffian idempotent / characteristic-cubic construction
- tries: positive construction — builds an explicit reduced-rank-two idempotent `e=(a²-c₁(a)a+c₂(a)1)/c₂(a)` in `Sym(A,σ)` by solving `c₃(a)=0, c₂(a)≠0` (an "auxiliary Pfaffian characteristic cubic"); 15 symmetrizations give a `K_proj`-basis; all 455 coordinate-pair restrictions proved smooth/geometrically integral; a `K_proj`-point of this cubic is known abstractly to exist but not in installed coordinates.
- sources: HANDOFF.md "2026-07-30 latest Pfaffian closure" item 3; REPAIR.md §13 narrative-correction cross-reference.
- status_labels: "known abstractly to have a K_proj-point ... but its coordinates in the installed basis are not known"; per REPAIR.md, this refers only to "the auxiliary Pfaffian characteristic cubic in Sym(A,σ), not to a point of F_{14,T} or of the generic Klein twist".
- runs: `tmp/pfaffian_representation_alignment`, `tmp/pfaffian_25plus11_descent`, `tmp/quadratic_grassmannian_covariant`, `tmp/pfaffian_rank2_idempotent_attack`, `tmp/pfaffian_binary_cubic_attack`, `tmp/pfaffian_ternary_cubic_triage`, `tmp/pfaffian_minimal_ternary_model`.
- confidence: certain

### R11 — Pfaffian fixed-frame D5/target-branch point-search programme
- tries: positive construction — attempts to find an actual `K_proj`-point of the depressed fixed-frame cubic `u³+u(q₀v²+...)+r₀v³+...=0` obtained from the Pfaffian idempotent, via: the "D5" constant point `[X:v:w]=[x1:t1:1]` (soluble over a subfield, but fails in the full equation), the index-3 fixed-frame extension over `F=C(A,B,Y,Z)` with `Pic⁰(C)(F)=0`, an exact BKK degree-6 certificate for `[K_proj:F]`, primitive-root/discriminant-divisor line probes, and deep singularity analysis of the "target branch" (Cramer-minor saturation, delta-saturated nonnormality, rank-2 Hessian, higher-jet vanishing, RUR-based membership attacks `P∈(P_A,P_B,P_Y)`).
- sources: HANDOFF.md "2026-07-30 latest Pfaffian closure" (entire section, lines 85–436); `tmp/target_branch_delta_saturated_singularity/PROOF_AUDIT.md` and `HESSIAN_PROOF_AUDIT.md` cross-refs.
- status_labels: "D5 is soluble and is retired as an obstruction"; "ind(C/F)=3, C(F)=∅"; "[K_proj:F]=6"; local branch "nonnormal Morse–Bott crossing" candidate, "not ordinary double points"; "the present certificates do not decide global projective small resolvability or the final class-group obstruction"; "This does not prove h=0; finite jets cannot do so"; Verdict remains **OPEN**.
- runs: `tmp/pfaffian_d5_constant_point`, `tmp/pfaffian_d5_residual_attack`, `tmp/full_scaled_frame_degree_attack`, `tmp/pfaffian_six_sheet_branch_obstruction`, `tmp/target_branch_delta_saturated_singularity/build_hprime_rur_certificate.py`, `.../certify_kernel_cubic_rur.py`, `.../certify_effective_quartic_rur.py`, `.../audit_exact_primitive_rur.py`, `EXACT_PRIMITIVE_PROOF_AUDIT.md`, `LOCALIZED_MEMBERSHIP_ATTACK_REPORT.md`, `FORMAL_PRIMITIVE_GOOD_PRIMES_AUDIT.md`, `DETERMINANTAL_CRITICAL_SURFACE_AUDIT.md`, `LOGARITHMIC_CRITERION_AUDIT.md`.
- confidence: certain (as a distinct programme); identification with the repair table's "Path T" label ("T-BIRATIONAL"/"T-NONNORMAL"/"dim Sing_S=2") is inferred, not stated explicitly in-line.

### R12 — Path T (repair-table label; likely = R11)
- tries: as summarized in the repair status table — finite generic-rank-one/birational fold construction on a stated open (`T-BIRATIONAL`), plus a nonnormality claim for the fold's target (`T-NONNORMAL`) and a `dim Sing_S=2` claim, gated behind a pending "T2R" computation.
- sources: HANDOFF.md "2026-07-31 theorem-boundary repair" (lines 13–83), "Immediate route status after repair" table, "Suspended or downgraded" table.
- status_labels: "T-BIRATIONAL — retained at its stated generic/open theorem boundary"; "T-NONNORMAL — suspended; not proved by the current T2 packet; pending T2R gate"; "dim Sing_S = 2 — unproved; current exact cuts do not establish it; pending T2R"; "Concurrent worker owns certificates/fold_normalization*."
- runs: T2/T2R packet (not further named in HANDOFF.md itself); `certificates/fold_normalization*`.
- confidence: inferred (this may be identical to R11, or a related-but-distinct fold-normalization computation not otherwise narrated in HANDOFF.md's prose sections)

### R13 — Path A: P¹-reduction / index-34 duality / Krylov-minor interface
- tries: as summarized in the repair table only — a `P¹`-reduction technique, an "index-34 duality" theorem, and an executable interface via a Krylov-type maximal-minors ideal and objects `L, V_Z`.
- sources: HANDOFF.md "2026-07-31 theorem-boundary repair" tables (lines 43–45, 54).
- status_labels: "Path A index-34 duality — retained"; "Path A single-minor formulation — corrected to the ideal of all maximal minors"; "Path A executable L,V_Z claim — downgraded to an abstract interface"; also listed among "Trusted results retained": "Path A P¹-reduction; Path A index-34 duality."
- runs: not named within HANDOFF.md itself (only referenced via the repair table).
- confidence: inferred (content essentially unknown from this lens beyond the table; no prose elaboration found in HANDOFF.md)

### R14 — Schur ternary-plane genus-one fibration / no-section theorem
- tries: negative structural result — shows the ten ternary coordinate sections of the Schur frame are smooth genus-one curves with no rational line/conic, no regular lower-dimensional fibration, no separated cubic-norm equation; after blow-up, each ambient-line projection is a genus-one fibration with `Pic=Z·H⊕Z·E`, fibre-degree image `3Z`, exact index/period 3, hence no rational section.
- sources: HANDOFF.md "2026-07-29 structural KLS, Schur, and Pfaffian update"; "Strongest proved progress" item 5.
- status_labels: "The former xi_ij=0/3-descent section target is retired"; "This is not a no-point theorem"; Chevalley–Warning/Tsen guarantee finite/one-parameter specializations are soluble regardless.
- runs: `tmp/schur_structural_routes`, `tmp/schur_fibration_picard_obstruction`.
- confidence: certain

### R15 — Unrestricted generic Schur twist positive-point construction
- tries: positive construction — builds a degree-55 closed point (not merely a cycle) fixed by a maximal `D12` on the generic Schur twist, index one via degree-three linear section; seeks a degree-19 curve through it with multiplicity-one intersection (ACM Hilbert-function obstruction on one hyperplane choice; non-ACM branch and a `(3,5)` complete-intersection `Y` with Rao-ledger analysis left open).
- sources: HANDOFF.md "2026-07-30 audited delta" item 2.
- status_labels: "index one, but no rational point is currently known"; "The sharp negative target is any boundary-zero G-torsor ... whose Klein twist has no point"; "neither the no-quintic branch nor the special quintic-carrier branch is closed."
- runs: `tmp/schur_unrestricted_point_attack`, `tmp/schur_degree19_structural_design`, `tmp/schur_degree19_nonacm_attack`.
- confidence: certain

### R16 — Path B / Problem-F import: V4-fixed exceptional-path technique transfer
- tries: negative-obstruction attempt (technique import) — imports Problem F's all-degree `V₄`-fixed exceptional-path obstruction (parity forcing, forced basepoints, pointwise-fixed exceptional curves, path-lemma tree argument) to try to kill all equivariant maps `P(W)⇢C` at once.
- sources: HANDOFF.md "2026-07-28 — Technique import from Problem F" §, "2026-07-28 — Generalizing the F-engine..." §, "2026-07-28 — Exact audit of Fable's generalized engine" §, "2026-07-29 — Fable positive-construction assessment" §.
- status_labels: header label "AUDIT PASSED, resolution committed" (for Problem F itself, "RESOLVED NEGATIVE"); for the Klein-cubic transfer: "the verbatim transfer fails"; generalized engine — "the transition system closes rather than obstructs"; explicitly, this outcome "weighs toward a POSITIVE construction... instead."
- runs: `tmp/involution_exceptional_divisor` (+ `verify_v4.py`), `tmp/d12_line_restriction`, `tmp/v4_surface_slice_audit`.
- confidence: certain

### R17 — Fable trisection attack (A4-equivariant cubic-surface construction)
- tries: positive construction — for `K=V4`, `A=N_G(K)=A4`, blows up the length-3 base orbit `R=X∩P(T)`; proves `A4`-equivariant maps `P(U)⇢X` have projected degree divisible by 3; explicitly constructs a degree-3 `A4`-equivariant birational map `P(U)⇢S⊂X` (a cubic surface `S(a,b,c)`) with 6 simple basepoints giving degree-1 edge maps onto the triangle's minus-lines.
- sources: HANDOFF.md "2026-07-29 xCD completion and Fable update" (Fable bullets); "2026-07-29 — Fable positive-construction assessment".
- status_labels: "the first local positive gate is solved"; "does not automatically define a section of the full 55-plane symbolic sheaf."
- runs: `tmp/fable_positive_construction`, `tmp/fable_trisection_attack`, `tmp/fable_trisection_compatibility`.
- confidence: certain

### R18 — Fable Koszul first-gate symbolic-arrangement construction
- tries: positive construction — extends the trisection to all 55 centres via equivariant Serre extension and a Koszul construction, producing a nonzero compatible high-twist class `σ ∈ H⁰(~(I^(9)/I^(11))(3d)⊗W)^G` with `F(σ)=0 mod I^(11)`; separates odd orders (automatically zero by representation theory) from even orders (rank-one invariant residue sheaf) and repairs a degree-7 joint equalizer.
- sources: HANDOFF.md "2026-07-29 xCD completion and Fable update"; "2026-07-29 — Fable positive-construction assessment"; "Current structural ledger" item (1).
- status_labels: "This solves exactly the first formal landing correction"; "the theorem closes only I^(9)/I^(11)."
- runs: `tmp/fable_nonlinear_first_gate`, `tmp/fable_resolved_descent`, `tmp/fable_constrained_cokernel`, `tmp/fable_finite_d12_constrained`, `tmp/fable_d12_char0_bridge`, `tmp/fable_first_gate_koszul`, `tmp/fable_d12_joint_rank`, `tmp/fable_d12_koszul_rank`, `tmp/fable_d12_module_adversary`, `tmp/fable_d12_bulk_correction_rank`, `tmp/fable_d12_triangular_bulk_closure`.
- confidence: certain

### R19 — Fable factorized q_P·R_P family continuation
- tries: positive-construction continuation — attempts the next correction `I^(5)/I^(7) → I^(11)/I^(13)` via a factorized ansatz `p3=q_P·R_P`, `p4=i_(Γ_RP)(η_P)`.
- sources: HANDOFF.md "2026-07-29 xCD completion and Fable update"; "Current structural ledger" item (1).
- status_labels: "**obstructed**"; "impossible ... for irreducible, split, nonreduced, singular, nonnormal, or irregular double planes"; "closed at the first full I^(11)/I^(13) gate."
- runs: `tmp/fable_relative_divisor_trace_obstruction`, `tmp/fable_fixed_plane_boundary_adversary`, `tmp/fable_relative_q_trace_obstruction`.
- confidence: certain

### R20 — Fable nonfactorized successor
- tries: positive-construction continuation — attempts a primitive nonfactorized replacement for the closed factorized family, using a constant polarization isomorphism and Hilbert–Burch syzygy analysis.
- sources: HANDOFF.md "2026-07-29 xCD completion and Fable update"; "Current structural ledger" item (1).
- status_labels: "now closed as well"; "every planewise normal-order 3/4 extension retaining these fixed line germs is impossible"; "A Fable escape must change the boundary data or the leading normal order."
- runs: `tmp/fable_nonfactorized_successor`, `tmp/fable_nonfactorized_syzygy_obstruction`, `tmp/fable_nonfactorized_feasibility`.
- confidence: certain

### R21 — xCD generic-slice census & Klein-sextic factoriality
- tries: negative obstruction (scoped) — completes the census of `Sing(C6)` for the invariant sextic pencil `f6+tf3²`, proves `def(Y)=0` and factoriality of `Y`/`C6` via Jung–Saito, forcing horizontal Weil degree image `3Z` and hence no `K_proj,C`-point on the `xCD` plane cubic `F(a·x+b·C+c·D)=0`.
- sources: HANDOFF.md "2026-07-29 xCD completion and Fable update"; "2026-07-30 audited delta" narrative on `H6`.
- status_labels: "This closes the construction F(a·x+b·C+c·D)=0; it does not prove that the full generic twisted Klein cubic threefold has no point. The headline remains open."
- runs: `tmp/xcd_invariant_fibre_discriminants`, `tmp/xcd_repeated_factor_incidence`, `tmp/xcd_singular_curve_enumeration_audit`, `tmp/xcd_general_slice_completion`, `tmp/xcd_actual_class_image`, `tmp/xcd_picard_restriction`, `tmp/xcd_singular_locus_bound`.
- confidence: certain

### R22 — xCD invariant-module multiprime radical experiment
- tries: infrastructure attack (abandoned) — a 15-prime modular radical / 14-prime CRT reconstruction of the invariant module support, meant to feed the general slice census.
- sources: HANDOFF.md "2026-07-29 xCD completion and Fable update".
- status_labels: "still failed withheld-prime rational reconstruction"; "This makes no QQ support claim and is retired for the census."
- runs: `tmp/xcd_invariant_module_multiprime/verify_reconstruction.py` ("only for provenance").
- confidence: certain

### R23 — xCD generic Cech / first-descent E[3] Kummer construction
- tries: positive construction — builds an exact `E[3]` Kummer-class representative `α_R` for the `xCD` plane cubic via a typed nested-étale Cech circuit, diagonal idempotent, and unit scalar-cochain normalization; assembles a 10-variable, 9-cubic affine unit chart (`3⁸` = 729 geometric degree-9 components) whose distinguished base-defined component is isomorphic to the original `xCD` cubic.
- sources: HANDOFF.md "2026-07-30 audited delta" item 3 (xCD sub-thread within Pfaffian section is separate — this is the earlier "Strongest proved progress" item 11 and "2026-07-29" descent narrative).
- status_labels: "The general-slice theorem now proves that this component has no K_proj,C-point, so that distinguished component is closed negatively. This is not an obstruction to points elsewhere."
- runs: `tmp/xcd_control_next`, `tmp/xcd_generic_cech_next` (`verify_generic_dag.py`, `verify_cech_extension.py`, `verify_typed_cech.py`, `verify_alpha_corrected.py`), `tmp/xcd_first_descent_next`, `tmp/xcd_genuine_descent`, `tmp/xcd_nonzero_kummer`.
- confidence: certain

### R24 — xCD class-image / Zariski-descent Rees-lattice attack
- tries: negative-obstruction attempt (retired as non-live) — tries to prove individual descent of primitive Rees-module branch classes across `s=1` via a weighted Rees family, matrix factorizations to all formal orders, Artin–Popescu approximation, and a critical-curve/polar-minor "null-polar test"; multiple candidate algebraic elements and correction terms (`a0`,`a1`,`a2`) are tested and refuted by explicit 5-jet computations.
- sources: HANDOFF.md "2026-07-29 xCD completion and Fable update" (long Rees/class-image block, ~lines 1536–1693).
- status_labels: "retained as a failure ledger for an alternative proof of that plane-section theorem. It is no longer a live gate."; "The proposed degree-one Zariski Morse chart is now refuted"; "Its henselian divisor and the factoriality of B[1/a2] remain open; do not continue a formal jet ladder."
- runs: `tmp/xcd_total_normality`, `tmp/xcd_local_class_defect`, `tmp/xcd_class_globalization_next`, `tmp/xcd_zariski_descent_gate`, `tmp/xcd_formal_mf_all_order`, `tmp/xcd_formal_algebraization_audit`, `tmp/xcd_class_image_attack`, `tmp/xcd_ca_class_group`, `tmp/xcd_algebraic_null_polar`, `tmp/xcd_zariski_morse_chart`.
- confidence: certain

### R25 — xCD residue-class gate at f6=0 / Jung–Saito base factoriality
- tries: infrastructure/negative — analyzes the pullback residue cubic on `H6=V(f6)`; proves total space integral/normal/S2/R1 (using Poonen–Stoll), computes `Sing(H6)` exactly, and applies the new Jung–Saito defect formula to get `Cl(H6)=Z[O(1)]`, closing the Picard/Cartier gap for `C6`.
- sources: HANDOFF.md "2026-07-29 xCD completion and Fable update" (long `f6=0` block).
- status_labels: "does not produce a local obstruction, but it replaces an open-ended point sweep by a precise divisor-class gate"; feeds R21's closure.
- runs: `tmp/xcd_discriminant_divisor`, `tmp/xcd_gauge_divisors`, `tmp/xcd_residue_class_gate`, `tmp/xcd_arithmetic_next`.
- confidence: certain

### R26 — Level-11 theta/Schwarz modular construction
- tries: positive construction (closed) — tests a "July 2026 level-11 theta/Schwarz construction" with the correct projective representation as a candidate point/map onto the Klein cubic.
- sources: HANDOFF.md "2026-07-30 audited delta" (closing bullet), replay list.
- status_labels: "does not lie on the Klein cubic: F(HΦ₁₁)=ξ₄₄⁵u¹¹+O(u⁹⁹)... Close this as a headline path."
- runs: `tmp/theta11_test/theta11_test.py`.
- confidence: certain

### R27 — Zero-cycle / orbit-based descent construction
- tries: positive construction — attempts to build an equivariant point via orbit configurations (`C11,C5,V4,C3` fixed loci, the 220-point orbit and its complete-intersection links); a torsor-dependent semilinear degree-74 curve is proposed as the live positive target after constant orbit selection and binary chord trees are ruled out.
- sources: HANDOFF.md "Strongest proved progress" item 8; "Best re-entry points" ("Orbit constructions").
- status_labels: "these are finite-construction no-gos, not an exclusion of continuous covariants"; "A torsor-dependent semilinear degree-74 curve remains a precise positive target."
- runs: `tmp/zero_cycle_descent`.
- confidence: certain

### R28 — Voisin C^[3] very-versal pullback
- tries: positive construction (closed as circular) — attempts to use Voisin's proof that `C^[3]` is `G`-very-versal by pulling the universal marked cover back along her parameterization.
- sources: HANDOFF.md "Strongest proved progress" item 10.
- status_labels: "gives a source birationally fibered over C and is therefore circular for the missing point."; "Very versality of C^[3] does not give very versality of C: no rational equivariant operation selecting one point of the degree-three cycle is known" (Theorem boundaries).
- runs: `tmp/ed_binary_attack/REPORT.md`.
- confidence: certain

### R29 — Counterexample-twist / no-point G-torsor construction
- tries: negative construction (proposed, not executed) — seeks an explicit `G`-torsor over an infinite field whose Klein twist has no rational point, which would prove both the negative headline and `ed(G)=4`.
- sources: HANDOFF.md "Best re-entry points" ("Counterexample twist"); "2026-07-30 audited delta" item 2 ("sharp negative target").
- status_labels: listed as a live target, not yet attempted/found: "An explicit G-torsor whose Klein twist has no point would prove both the negative headline and ed(G)=4."
- runs: none named.
- confidence: certain

### R30 — Amitsur invariant / higher-cohomology obstruction route
- tries: negative obstruction (checked, exhausted) — considers whether higher Amitsur-invariant / stable-cohomology obstructions could decide the generic twist's point.
- sources: HANDOFF.md "2026-07-29 xCD completion and Fable update" (primary-source audit bullet, ~line 2013).
- status_labels: "the higher Amitsur route is exhausted here because Pic(X)=Z[H] and O_X(1) is honestly G-linearized, so the relevant groups vanish after restriction to every subgroup."
- runs: `tmp/recent_structural_tools_audit/verify.py`.
- confidence: certain

### R31 — Hodge-center split-injection theorem
- tries: positive/salvage result — a "Hodge-center conclusion," originally in doubt, resalvaged by rewriting the proof via a relatively ample class.
- sources: HANDOFF.md "2026-07-31 theorem-boundary repair" table (line 42, 56); REPAIR.md §8 cross-reference.
- status_labels: "Hodge-center conclusion — salvageable; proof rewritten via relatively ample class (REPAIR.md §8)"; "corrected Hodge-center split-injection theorem after §8 substitution" (listed among trusted results retained).
- runs: not named in HANDOFF.md itself (detail lives in REPAIR.md).
- confidence: inferred (content beyond the table label is outside this lens)

### R32 — Recent-literature/tool audit sweep
- tries: infrastructure/negative-clearance — systematically checks whether recent papers/tools (Kresch–Tschinkel versal-twist reduction, Poonen–Stoll discriminant-valuation theorem, Jung–Saito defect/factoriality revisions, Spicer–Tasin, Robbiano border-basis survey, Groebner.jl change-matrix API, June-2026 BSS/Koszul-homology spline paper) close the headline or unlock a stuck computation.
- sources: HANDOFF.md "2026-07-29 xCD completion and Fable update" (primary-source audit bullet); "Current structural ledger" (Poonen–Stoll / Jung–Saito paragraphs); tail of "Current structural ledger" (Groebner.jl, Robbiano, BSS/Koszul).
- status_labels: "found no recent theorem that closes the headline"; Poonen–Stoll "closes those components as local-obstruction places... says nothing about the global torsor"; Jung–Saito "does not compute Cl(B) or Cl(C6)"; Groebner.jl "the public high-level route is stopped"; BSS/Koszul "generic hyperplane-fan theorems do not apply directly."
- runs: `tmp/recent_structural_tools_audit`, `tmp/recent_equivariant_tools_2026`, `tmp/groebnerjl_change_matrix_pilot`.
- confidence: certain