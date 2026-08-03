### T — Path T (fold normalization / T-BIRATIONAL / T-NONNORMAL)
- tries: positive-construction infrastructure route: builds a "fold algebra" `S=(B[u]/(P,P_u))[Σ⁻¹]` for the Klein-cubic normalization/conductor problem, tries to prove a birational fold construction (`T-BIRATIONAL`) and separately that the folded model is non-normal with a 2-dimensional singular locus (`T-NONNORMAL`, `dim Sing_S=2`), which would feed a normalization/conductor argument toward class-group control.
- sources: REPAIR.md (Parts I, VI); CURRENT_PATHS.md (repair-summary lines 19-90, reproducing REPAIR.md); PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (bundled row 2, "T/T2").
- status_labels: PRE-REPAIR (historical, implicit in old certificates): `T-NONNORMAL` proved, `dim Sing_S=2` proved, terminal marker `FOLD_NORMALIZATION_T2_VERIFIER_ACCEPT` treated as proof [REPAIR.md]. POST-REPAIR: `T-BIRATIONAL` retained at its stated generic/open theorem boundary; `T-NONNORMAL` **suspended, not proved**; `dim Sing_S=2` **unproved**; required interim label `T2-UNDECIDED pending exact saturated same-open dimension proof`; verifier explicitly must **not** be consumed as a proof [REPAIR.md §§1-3,15; CURRENT_PATHS.md lines 41-43,68-70]. Ledger (2026-08-02) bundles it as `TERMINAL — Prior local obstructions/witnesses exhausted — Background only`, in apparent tension with REPAIR's "pending T2R gate" framing.
- runs: T2 (dimension inference, now invalid — counterexample given in REPAIR.md §1.1); T2R.1/T2R.2/T2R.3 (mandatory repair gate: same-open scheme, saturated singular ideal, lower/upper bound certificates) with exits `T2R-NONNORMAL` / `T2R-NORMAL` / `T2R-UNDECIDED` (none yet certified); T3 (height-one normalization, blocked from consuming T-NONNORMAL until T2R exits).
- confidence: certain (Path T itself); the ledger's "T/T2 TERMINAL" bundling is certain as text but its relation to the still-open T2R gate is inferred/flagged as tension.

### T3 — normalization + Cl/Pic[3]
- tries: infrastructure/positive route continuing Path T: local class-group / Cl/Pic[3] computation built on the fixed-frame normalization, intended to feed a divisor-class obstruction.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (row "T3 normalization + Cl/Pic[3]"); REPAIR.md §6 (T3 height-one normalization gate, blocked pending T2R).
- status_labels: ledger: `AUXILIARY OPEN — Fixed-frame/non-headline after B — Local runner only`. REPAIR.md: T3 "must not be consumed" until T2R exits.
- runs: local runner (unnamed specific tmp/ run not visible in this lens).
- confidence: inferred link to Path T's T3 stage; explicit "non-headline after B" status is certain from the ledger text.

### G — Path G (universal object / finite-generation reduction)
- tries: positive/structural route: builds a "universal object" whose finite generation (over a proposed `(m,d)`-semigroup grading) would give an all-degree reduction of the KLS-style landing problem, using a finite truncation and isolation cutoff `N⋆=d+2m+1`, sample residual computations at degrees 13 and 19, and a symbolic free-fibre recurrence (G4.1).
- sources: REPAIR.md (Part IV, §§11-12, §17); CURRENT_PATHS.md (repair-summary lines 19-90); PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (row "G universal object").
- status_labels: PRE-REPAIR (historical): degree-13/19 packets labeled `G13-OBSTRUCTION` / `G19-OBSTRUCTION`, read as degree-wide obstruction theorems. POST-REPAIR: downgraded to `G13-SAMPLE-RESIDUAL`, `G19-SAMPLE-RESIDUAL`, `G-PATTERN` — proven only that the residual map is not identically zero, not that its zero locus (Θ⁻¹(0)) is empty [REPAIR.md §§11-12]. Retained/trusted: finite truncation, isolation cutoff `N⋆=d+2m+1`, exact sample residuals, G4.1 free-fibre recurrence at its stated scope [REPAIR.md §16]. Ledger (2026-08-02): `TERMINAL STRUCTURAL PASS (G2-FINITE-GENERATION-PASS)` — "All-degree reduction achieved" — "Leaves arithmetic decision of surviving universal object."
- runs: degree-13 tower, degree-19 tower, G4.1 symbolic free-fibre recurrence, G4.2 (halted — finite generation of full equalizer/Fitting layers not proved), P25.1 (`P25-TOWER-SURVIVES`, scoped free-fibre/degree-25 continuation, confirms the correction per REPAIR.md §12).
- confidence: certain.

### G3 — universal cubic arithmetic
- tries: positive/arithmetic route, successor to Path G: having reduced the problem to a "surviving universal object," decide whether its associated cubic `Φ` has a `K_proj`-rational point, i.e. decide `V(Φ)(K_proj)`.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (row "G3 universal cubic arithmetic").
- status_labels: `OPEN — Decide V(Phi)(K_proj) — Highest priority` [ledger].
- runs: none named in this lens beyond the ledger row itself.
- confidence: certain as a named route; details of `Φ` not visible in this lens (inferred sub-route of Path G).

### Hodge-center — split-injection theorem
- tries: negative/structural route toward the essential-dimension question via Hodge theory: constructs a map `f:Z→X` (Z resolving a rational map from P⁴, X the Klein cubic) and argues `f*` splits `H³(X)` into `H³(Z)`, which would be used as an obstruction/necessity argument (Hodge-structure splitting as a necessary condition, "Hodge-center necessity").
- sources: REPAIR.md (Part II, §§7-8, §16, §17 file list); CURRENT_PATHS.md (repair-summary line 48).
- status_labels: PRE-REPAIR (historical): proof via "generically finite" pushforward `f_*:H³(Z)→H³(X)` — **relative-dimension error**: since `dim Z=4`, `dim X=3`, dominant `f` has relative dimension one, not zero, so the displayed degree-`d` identity is invalid [REPAIR.md §7]. POST-REPAIR: conclusion "salvageable" via a corrected proof using a `G`-invariant ample class `η` and the projection-formula splitting `s(β)=1/n·f_*(η∪β)`, giving `f*` as a split injection of rational Hodge structures [REPAIR.md §8]. Required file edit: `certificates/hodge_centers/HODGE_CENTER_NECESSITY.md` must replace the generically-finite argument with the relatively-ample-class argument [REPAIR.md §15].
- runs: none named beyond the single theorem file.
- confidence: certain.

### A — Path A (Schur-Krylov degree-55 field algebra)
- tries: positive-construction route: installs a degree-55 field algebra/marked point via a monogenic schema (`B_34(τ,V_Z)`, rank-55 maximal-minor matrix) and an index-34 duality, aiming toward an executable algebra-code pair `(L,V_Z)` that could supply a rational point / landing construction.
- sources: REPAIR.md (Part III, §§9-10, §16, §17, §15 file list); CURRENT_PATHS.md (repair-summary lines 19-90).
- status_labels: PRE-REPAIR (historical): "some 55×55 minor is nonzero at every primitive tau" (single global minor claim); A2 packet described as having installed "exact generic coordinates." POST-REPAIR: quantifier corrected to `∀τ ∃M_τ: M_τ(τ)≠0`, i.e. the ideal of **all** maximal minors, `V(I_55(B_34))∩U_primitive=∅` [REPAIR.md §9]; A2 downgraded to "abstract degree-55 algebra and marked-evaluation interface installed; exact executable marked algebra-code pair (L,V_Z) **not installed**" — superseded by packet `A_EMPTY_UNDECIDED` [REPAIR.md §10]. Retained/trusted: Path A P¹-reduction, Path A index-34 duality [REPAIR.md §16, §17].
- runs: A2 packet; `A_EMPTY` / `A_EMPTY_UNDECIDED`; `orbit_code`, `field_algebra`, `marked_point` (files listed in REPAIR.md §15, `certificates/schur_krylov/*`).
- confidence: certain.

### A0 — canonical audit
- tries: infrastructure route (not itself a mathematical construction/obstruction): certifies the baseline exact 660-element `PSL(2,11)` action, Klein-cubic invariance, and "projection bulk data" as a checked-in replayable certificate package.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (row "A0 canonical audit"); README.md ("checked-in certificate package verifies the exact 660-element action and Klein-cubic invariance..."); REPAIR.md §0 (`HEADLINE_CAS_BASELINE_ACCEPT` marker, distinguished from mathematical verification).
- status_labels: ledger: `TERMINAL PASS — Projection bulk data certified (4140/315) — Infrastructure only`.
- runs: none named beyond the ledger row; possibly the same baseline as `HEADLINE_CAS_BASELINE_ACCEPT` (inferred, not confirmed by exact figures).
- confidence: certain for existence/status; link to `HEADLINE_CAS_BASELINE_ACCEPT`/README's 660-element package is inferred.

### B — fixed-frame exhaustiveness
- tries: negative-obstruction route: descends the full Klein-twist problem to a fixed four-parameter "fixed frame" `F=C(A,B,Y,Z)` (via Pfaffian generator alignment, the map `W→∧²V6*`, symplectic involution, and a "D5 residue gate"), computing an exact sparse-BKK field degree `[K_proj:F]=6`, monodromy groups `S6`/`A6`, and attempting to show the index-3 curve stays pointless over `K_proj`, which would certify non-unirationality.
- sources: CURRENT_PATHS.md (2026-07-30 "Latest fixed-frame update" and "Pfaffian descent is the leading constructive route," lines 91-333); PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (row "B fixed-frame exhaustiveness"); REPAIR.md (T3 row references "after B").
- status_labels: CURRENT_PATHS.md (2026-07-30): presented as the **leading active route** with three "structured continuations" (target branch incidence, resolved branch incidence, positive conic/algebra test) and multiple positive milestones (D5 residue gate "closed positively," sextic discriminant factorization, S6/A6 monodromy). Ledger (2026-08-02, three days later): **`TERMINAL NEGATIVE (B-BRIDGE-REFUTED)` — "Fixed-frame bridge is false; cannot certify non-unirationality" — "Warns against overusing frame reductions."** This is a marked status reversal across the two dated documents in this lens.
- runs: D5 residue gate/target branch incidence; resolved branch incidence (upstairs critical determinant, degree 37); positive conic/algebra test (`P5(F)` algebraic interface); twelve-point nonnormal singularity gate; residual `E[3]`/Kummer class computation on `F0=C(A,Y,Z)`.
- confidence: certain for both status snapshots; the causal link between the 07-30 narrative and the 08-02 refutation verdict is inferred (same "fixed-frame" subject matter, no explicit bridging text found).

### V — residue obstruction
- tries: negative-obstruction route, mechanics of a residue/valuation argument now closed with remaining binary (yes/no) decisions to resolve; feeds forward into other sub-routes (G5, H6).
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (row "V residue obstruction").
- status_labels: `PARTIAL (V3-RESIDUE-NORMAL-FORM-PASS) — Mechanics closed, residue binaries remain — Feeds G5/H6`.
- runs: V3 (residue normal-form pass); forward dependency on an unnamed "G5" sub-route not otherwise documented in this lens.
- confidence: certain as a named route; no corroborating detail found elsewhere in this lens, so mathematical content is unknown (possible link to the `adj(Dq)=b·v·Ā^t` vertical-divisor `v`/`h` machinery in CURRENT_PATHS.md's KLS narrative is speculative only).

### Q — descent obstruction
- tries: negative-obstruction route testing a "standard obstruction package" (plausibly Brauer/Amitsur/local-global descent obstructions) against the Klein-twist point problem; found insufficient, with a "stable cubic/resolvent" continuation (Q3) remaining.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (row "Q descent obstruction"); CURRENT_PATHS.md (line ~2187: "the standard Brauer, Amitsur, and stable-cohomology packages checked here do not distinguish the two cases" — plausible thematic match, not a confirmed identity).
- status_labels: `PARTIAL (Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS) — Standard obstruction package insufficient — Q3 stable cubic/resolvent route remains`.
- runs: Q2.1 (descent obstruction audit); Q3 (planned, stable cubic/resolvent route).
- confidence: certain as a named route; link to the Brauer/Amitsur passage in CURRENT_PATHS.md is inferred/low-confidence.

### H — trace-cubic program (H11:5, H5, H6)
- tries: positive/arithmetic route constructing a "trace cubic" model, possibly tied to the order-55 subgroup `11:5` of `PSL(2,11)` and to `H6=V(f6)`, aimed at a genuine degree-11 torus/isogeny decision that would resolve a rational-point question.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (rows "H11:5 trace cubic," "H5 trace cubic model"); CURRENT_PATHS.md (2026-07-28 item 7, "the f6=0 residue attack is now a relative class-group problem," `H_6=V(f_6)`, `Cl(H6)=Pic(H6)=Z[O_H6(1)]`, "H5" appears only as an unrelated polynomial coefficient `H5=(3/8)b²P3` inside the xCD route — likely a false-positive textual match, not the same "H5").
- status_labels: ledger: H11:5 `OPEN — Need genuine degree-11 torus/isogeny decision — H6 route`; H5 `PARTIAL — Model sealed but no K-point conclusion — Input to H6`.
- runs: H6 (target route, feeds from both H11:5 and H5).
- confidence: H11:5/H5/H6 as named ledger rows: certain. Identification of "H6" with `H_6=V(f_6)` in CURRENT_PATHS.md's xCD narrative: inferred (symbol match `H6`/`H_6`, but no explicit cross-reference found); identification of the unrelated `H5` coefficient with ledger's "H5 trace cubic model" is very low confidence / likely coincidental and flagged as such.

### C5/C6 — common-line Fano
- tries: positive-construction route: a "corrected Plücker/alternating model" (Grassmannian/skew-matrix coordinates) aimed at a Fano-type common-line construction, possibly geometric construction or refutation.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (row "C5/C6 common-line Fano"); CURRENT_PATHS.md Pfaffian narrative (2026-07-30 item 1 and 2026-07-29 item 7) — "the unique map `W→∧²V6*`," "simultaneous common-line problem," "seek a common isotropic right `D_proj`-line" — thematically matching "common-line"/Plücker/alternating language, not textually identical.
- status_labels: ledger: `OPEN — Corrected Plucker/alternating model survives — Possible geometric construction/refutation`.
- runs: none explicitly named beyond the ledger row.
- confidence: named route certain; identification with the Pfaffian/Grassmannian "common isotropic line" construction in CURRENT_PATHS.md is inferred (moderate confidence, based on strong thematic/terminological overlap: Plücker↔Grassmannian, alternating↔skew-symmetric Pfaffian forms, common-line↔common isotropic D-line).

### M3 — section vs multisection
- tries: negative/structural route: having closed a "multisection" existence question (index exactly 3, no rational section), the remaining open question is whether a genuine rational section (K-point) exists — a possible residual Galois-descent route.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (row "M3 section vs multisection"); CURRENT_PATHS.md — two thematically matching passages: (a) Fable's `A_4` "quadratic triangle globalization" — "for every A-equivariant f:P(U)⇢X..., deg(π∘f)≡0 (mod 3)"; "the A4 equivariant multisection index is exactly three" (line 2448); (b) the ten Schur ternary-coordinate genus-one fibrations — "fibre-degree image is exactly `3Z`... none admits a rational section... do not confuse a no-section theorem with a no-point theorem" (Ranking B item 4, lines 2419-2429).
- status_labels: ledger: `OPEN — Multisection closed; section remains — Possible residual Galois route`.
- runs: none explicitly named beyond the ledger row.
- confidence: named route certain; specific identification with either the Fable A4 multisection result or the Schur ten-fibration no-section result is inferred (both are plausible referents; document does not disambiguate).

### P25 — landing support
- tries: positive/negative bounded-degree route: finite chart computation testing whether a landing self-covariant exists in degree 25 (the first unresolved degree in the "landing self-covariants" exclusion ladder), via an 842-cubic system on a 43-dimensional parameter space.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (row "P25 landing support"); CURRENT_PATHS.md (Ranking A item 1, lines 2193-2241; "Degree 25 is the first bounded unknown," lines 949-963, 1543-1653).
- status_labels: ledger: `OPEN/DEFERRED — Finite chart computation only — Not headline without bridge`. CURRENT_PATHS.md: extensive partial results (`dim Z≤15` via degree-five `P^19`/`P^20` successors; `P^21` non-full, rank only bounded `3933≤rank≤7910`) but explicitly "Degree 25 remains open."
- runs: `P^10` sparse chart, `P^18`/`P^19`/`P^20`/`P^21` coordinate charts, rank-28 order-ideal module, 842-cubic determinantal-tail computation (see `tmp/m1_relative_border_p19_d5`, `p20_d5`, `p21_d5_design`, `tmp/degree25_structural_probe`).
- confidence: certain link (explicit "degree 25" match in both sources).

### COV — m=1 charts
- tries: positive/negative bounded-degree route: symbolic covariant-arrangement module computation restricted to the `m=1` (order-one plane) case of the general "landing detection" problem on `[(I^(m)/I^(m+2))_d ⊗ W]^G`, producing modular (finite characteristic) information about the finite irrelevant-torsion module `T_1`.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (row "COV m=1 charts"); CURRENT_PATHS.md (2026-07-29 item 9, lines 1469-1653; `tmp/covariant_arrangement_module/verify_all.py` and the many `tmp/m1_*` reports in the Fast Replay list).
- status_labels: ledger: `OPEN/DEFERRED — Modular information only — Needs characteristic-zero transfer`. CURRENT_PATHS.md: split-`F_67` computation shows `[(T_1)_d⊗W]^G=0` through degree 34 and for degree ≥164, but dimension 1 at degree 35 — "this does not lift to characteristic zero."
- runs: `tmp/m1_t1_saturation`, `tmp/m1_t1_f3_colon_attack`, `tmp/m1_t1_char0_d35_gate`, `tmp/covariant_arrangement_module/verify_all.py`.
- confidence: certain link (direct filename match "covariant_arrangement_module" = "COV," explicit "m=1" match).

### A5Q — A5-quadric branch (KLS)
- tries: negative-obstruction sub-branch of the KLS self-covariant-landing framework: tests whether either maximal invariant `A5`-quadric `q_A5` (or its degree-22 orbit product `P22`) can divide the gcd `h` of a normal-image KLS solution; would-be positive/negative candidate for the vertical-divisor branch.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (bundled row 2, "...KLS/KLS2"); CURRENT_PATHS.md (2026-07-29 structural update item 1, lines 481-497: "The normal-image orbit-eleven quadric branch is now **closed**... `q_A5∤h`, `P22∤h` for normal H").
- status_labels: CURRENT_PATHS.md: branch explicitly **closed** ("This excludes the former degree-25 and degree-28 P22 logarithmic fields as realizations of the normal-image KLS branch"). Ledger: bundled under `TERMINAL — Prior local obstructions/witnesses exhausted — Background only`.
- runs: `tmp/kls_a5_linearized_pencil_obstruction/`, `tmp/kls_a5_conductor_surface_feasibility/`.
- confidence: inferred (name "A5Q" plausibly = "A5-quadric," consistent with the closed status in both sources, but no document explicitly writes out "A5Q" as an expansion).

### F — stub (bundled terminal)
- tries: unknown from this lens; possibly a separate related problem's argument ("Problem F constant-path argument," referenced in CURRENT_PATHS.md's Deprioritized-work section as something *not* to rerun) rather than a Problem-E-internal path, or possibly shorthand for the "Fable" route.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (bundled row 2); CURRENT_PATHS.md line 2442 ("Do not rerun the Problem F constant-path argument...").
- status_labels: ledger: bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only`.
- runs: none identifiable in this lens.
- confidence: inferred/low — genuinely ambiguous whether "F" denotes a cross-problem reference or the in-repo "Fable" route.

### J / J2 — stub (bundled terminal)
- tries: unknown from this lens; no other occurrence of "J" or "J2" found in CURRENT_PATHS.md or REPAIR.md.
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (bundled row 2).
- status_labels: ledger: bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only`.
- runs: none identifiable.
- confidence: inferred existence only; content entirely unknown from this lens.

### D / D2 — stub (bundled terminal)
- tries: unknown from this lens; distinct from the "D5"/"D12" computational waypoints used inside the fixed-frame (B) and KLS/Fable narratives (no explicit "D" or "D2" path label found matching those).
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (bundled row 2).
- status_labels: ledger: bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only`.
- runs: none identifiable.
- confidence: inferred existence only; content entirely unknown from this lens.

### KLS — Kraft–Loetscher–Schwarz self-covariant landing framework
- tries: general framework (both positive and negative): seeks a primitive rank-4 self-covariant `q:W→W` whose Gauss-map/adjugate structure "lands" equivariantly on the Klein cone, which would give a positive parametrization; alternatively proves structural obstructions (minimal-image canonicity, vertical-divisor/conductor analysis, log-canonicity of the associated foliation) that would rule out all such solutions.
- sources: CURRENT_PATHS.md (2026-07-29 structural update items 1-2, lines 429-577; Ranking B item 2, lines 2364-2406; "What the current attacks established" §1 Jacobian-zero alternative, lines 1789-1901); PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (bundled as "KLS/KLS2").
- status_labels: CURRENT_PATHS.md (07-29/07-30): actively open with several closed sub-branches (A5-quadric branch closed; stable-component/genus≥26 and genus≥12 exclusions for stabilizers with orbit lengths 11 and 12; foliation LC-minimality/vertical-divisor gate still needed; flat-connection PDE `det[a,∇a,...]=0` unsolved). Jacobian-zero alternative specifically: "excluded through degree eleven only," degree 12 open except on a proper closed exceptional subset. Ledger (08-02): bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` — in tension with the still-open branches described three days earlier in CURRENT_PATHS.md.
- runs: `tmp/kls_minimal_contraction_attack/`, `tmp/kls_vertical_divisor_geometry/`, `tmp/kls_nonstable_vertical_orbits/`, `tmp/kls_a5_logarithmic_divisor/`, `tmp/kls_wstar_first_integrals/`, `tmp/kls_degree28_stein_fixed_point/`, `tmp/kls_a5_linearized_pencil_obstruction/`, `tmp/kls_a5_conductor_surface_feasibility/`, `tmp/kls_global_foliation_theorem/`, `tmp/kls_structural_audit/`, `tmp/kls_structural_successor/`, `tmp/degree10_jacobian/`, `tmp/degree11_jacobian/`, `tmp/degree12_jacobian/`.
- confidence: certain as a rich, actively-documented route; the ledger's terminal/background characterization is certain as text but its reconciliation with CURRENT_PATHS.md's open status is flagged as an unresolved tension in this lens.

### KLS2 — stub bundled variant
- tries: unknown specific distinguishing content from this lens; plausibly a second/finite-jet-box computational variant of KLS (e.g. the sparse `P^8`/`P^9` constant-coefficient jet family sweeps described in CURRENT_PATHS.md, which are explicitly said to be "the stopping point for three-support sweeps" and superseded by the structural approach).
- sources: PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md (bundled row 2); CURRENT_PATHS.md (2026-07-29 item 3, lines 1050-1122, sparse jet-family sweeps `P3/P5/P8/P9`).
- status_labels: ledger: bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only`; CURRENT_PATHS.md explicitly stops these bounded jet sweeps ("This is the stopping point for three-support sweeps").
- runs: `tmp/kls_first_jet_two_fiber/`, `tmp/kls_first_jet_three_fiber/`, `tmp/kls_full_support_p9_msolve/`.
- confidence: inferred link only (no document literally writes "KLS2").

### Schur source — projective source / degree-8 rational frame / unrestricted Schur route
- tries: positive-construction route: shows five explicit degree-8 Reynolds covariants (divided by a degree-8 invariant) give an all-degree normal form for every rational Schur-source equivariant map, reducing the headline to whether one explicit twisted Klein cubic has a nonzero `K`-point over `K=C(P(V6))^G`; separately builds a "D12 line" giving a degree-55 closed point of index one on the generic Schur twist, and studies genus-one fibrations from the ten coordinate lines.
- sources: CURRENT_PATHS.md ("What the current attacks established" §2, lines 1903-1988; 2026-07-30 item 2, lines 334-367; 2026-07-29 item 6, lines 826-872; Ranking A/B items).
- status_labels: coordinate-line/support exclusions complete (all ten lines empty; support-3+ needed); structural fibration result complete (no rational line/conic/regular fibration/separated norm form; all ten coordinate-line genus-one fibrations have Picard fibre-degree image `3Z`, index/period 3, no section — "not headline-negative: do not confuse a no-section theorem with a no-point theorem"); headline point question **open**. Post-repair narrative correction (REPAIR.md §14): "the generic Schur twist has index one, but no rational point is currently known" (historical phrasing "no rational point" — implying proved pointlessness — replaced; pointlessness NOT proved).
- runs: `tmp/projective_source/`, `tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`, `tmp/schur_ternary_planes/`, `tmp/schur_structural_routes/`, `tmp/schur_fibration_picard_obstruction/`.
- confidence: certain for CURRENT_PATHS.md content; the REPAIR.md §14 pre/post-repair correction is certain and directly applicable to this route (moderate-confidence link to Path A's "index-34" figure, since the numbers 1/34 differ and may denote different objects).

### Pfaffian — quaternionic descent route
- tries: positive-construction route: descends the Klein cubic to a self-adjoint-Pfaffian construction over `Sym(A,σ)` (a 36-dimensional algebra with involution), proves the generic Schur Brauer class has period/index exactly 2, giving a rational Severi–Brauer plane `P²_D` (`SB_2(M_3(D_proj))`), and seeks a common isotropic right `D_proj`-line among five Hermitian matrices — which would be headline-positive.
- sources: CURRENT_PATHS.md (2026-07-30 item 1, lines 236-333; 2026-07-29 item 7, lines 874-911; Ranking A item 4, Ranking B item 5); REPAIR.md (Part V §13, narrative correction).
- status_labels: CURRENT_PATHS.md: Brauer class nonzero index-2 proved; every individual Hermitian form proved isotropic (via degree-55 `A4` orbit + Springer) so the "anisotropic member" route is "retired as impossible"; simultaneous common-line problem remains **exact and open**; "the auxiliary Pfaffian characteristic cubic in Sym(A,σ) has a K_proj-point abstractly" — but per REPAIR.md §13 this must be read strictly: **not** a point of `F_{14,T}` or of the generic Klein twist (`FAIL-SCOPE` bridge audit is authoritative). This is a pre/post-repair narrative-precision correction (loose phrasing → scoped phrasing), not a status downgrade.
- runs: `tmp/pfaffian_generic_schur_audit/`, `tmp/pfaffian_explicit_descent/`.
- confidence: certain.

### xCD — plane cubic Kummer/3-descent route
- tries: positive/negative route: studies the explicit characteristic-zero plane cubic `F(ax+bC+cD)=0` (a specific Schur-derived plane section), builds its `E[3]`/flex-torsor algebra and first-Kummer class, and determines whether this selected plane has a `K_proj,C`-point (a sufficient positive certificate if found; a proof of pointlessness only closes this one component, not the headline).
- sources: CURRENT_PATHS.md ("What the current attacks established" §4, lines 2072-2189; 2026-07-28 items 4, 5, 7, lines 721-1436; Ranking A item 2, Ranking B item 3).
- status_labels: this distinguished/selected component is proved to have **no `K_proj,C`-point** ("general-slice theorem"), via `Cl(H6)=Pic(H6)=Z[O(1)]` and factoriality (Jung–Saito defect formula, `def(H_6)=0`); explicitly scoped: "this selected component is closed negatively; the other components and full twisted threefold are not" — headline remains open. All four listed sub-attacks (control fiber, invariant-field, descent algebra, class-group) "converge on a canonical arithmetic boundary": `ed(G)=3 ⟺ C_gen(K_proj)≠∅`.
- runs: `tmp/xcd_control_next/`, `tmp/xcd_generic_cech_next/`, `tmp/xcd_first_descent_next/`, `tmp/xcd_discriminant_divisor/`, `tmp/xcd_residue_class_gate/`, `tmp/xcd_total_normality/`, `tmp/xcd_general_slice_completion/`, `tmp/xcd_descent_algebra/`, `tmp/xcd_nonzero_kummer/`, `tmp/xcd_invariant_field/`.
- confidence: certain.

### Fable — quadratic triangle / trisection route
- tries: positive-construction route: projects `X` from the `V4`/`A4` fixed summand, studies base-orbit triangle/trisection geometry, and attempts an `A4`(or `D12`)-equivariant birational landing map via successive "boundary germ" corrections (order-three/four normal-order germs) and Koszul/Rees-module compatibility computations.
- sources: CURRENT_PATHS.md (2026-07-29 item 3, lines 578-720; 2026-07-28 item 8, lines 1438-1467; Ranking B item 1, Deprioritized-work items).
- status_labels: multiple sub-branches proved closed: no nonzero quadratic `A4`-equivariant landing map exists; degree-three trisection constructed and extended through `I^{(9)}/I^{(11)}` (Koszul theorem); "factorized continuation is now obstructed" at `I^{(11)}/I^{(13)}`; "nonfactorized planewise replacement is now obstructed too" (Veronese/Hilbert–Burch); overall: "all planewise normal-order 3/4 extensions of these fixed germs are closed... Only a changed boundary or leading normal order remains inside Fable" — i.e. current-form route exhausted, framework needs redesign. CURRENT_PATHS.md (2026-07-30) item 4 explicitly: "Fable remains a redesign route, not the current lead."
- runs: `tmp/fable_positive_construction/`, `tmp/fable_trisection_attack/`, `tmp/fable_d12_koszul_rank/`, `tmp/fable_d12_module_adversary/`, `tmp/fable_nonfactorized_successor/`, `tmp/fable_nonfactorized_syzygy_obstruction/`, `tmp/fable_nonfactorized_feasibility/`.
- confidence: certain.

### Landing self-covariants degree ladder / 55-plane symbolic arrangement module
- tries: negative-obstruction route (general, not restricted to the Jacobian-zero alternative): proves no nonzero self-covariant can "land" in the Klein cone through increasing degrees, using a reduced 55-triple-line/121-multiple-point arrangement and a symbolic Rees/`I^(m)/I^(m+2)` module architecture; aims for an all-degree "landing-detection" theorem `[(I^(m)/I^(m+2))_d⊗W]^G` incompatibility that would prove the negative headline.
- sources: CURRENT_PATHS.md ("What the current attacks established" §3, lines 1990-2071; 2026-07-28 item 1, lines 923-969; 2026-07-29 item 9, lines 1469-1653; Ranking A item 1, Ranking B item 1).
- status_labels: exclusion complete through degree 24 (via forced-plus-plane restriction, disjoint chart covers); degree 25 open ("the first bounded unknown," structural probe stops at a 37-dimensional quotient — "a stopping boundary, not an exclusion"); `T_1` module vanishes through degree 34 and ≥164 but is nonzero (dim 1) at degree 35 in the split-`F_67` fibre, with no characteristic-zero lift proved.
- runs: `tmp/degree22_compression/`, `tmp/degree23_common_line_landing/`, `tmp/degree24_landing/`, `tmp/degree25_structural_probe/`, `tmp/local_symbolic_rees/`, `tmp/m1_t1_saturation/`, `tmp/symbolic_global_exactness/`.
- confidence: certain.

### Degree-12 mixed Jacobian problem
- tries: bounded negative-obstruction sub-route within the KLS Jacobian-zero alternative: shows the degree-12 Jacobian-zero self-covariant locus is generically empty over its primitive parameter space, leaving only a proper closed exceptional subset undecided.
- sources: CURRENT_PATHS.md (2026-07-28 item 2, lines 971-1039; "What the current attacks established" §1, lines 1812-1857; Deprioritized-work item).
- status_labels: "Degree 12 is still open on that exceptional closed subset"; parameter-free top ideal fully certified (Hilbert function `[1,12,78,364,1365,3647,3726,0,0]`, colength 9,193); "no relative Fitting determinant has yet been produced."
- runs: `tmp/relative_kls_chart/` (`TOP_IDEAL_REPORT.md`, `DEGREE_LOWERING_DETERMINANT.md`, `survivor_trace/`), `tmp/relative_kls_hyperplane/`.
- confidence: certain.

### theta11/Schwarz level-11 parametrization test
- tries: positive-construction test route: checks whether a July-2026 level-11 theta-series/Schwarz-map construction (matching the repository's exact 5-dimensional Klein representation after monomial conjugacy) gives a Klein-cubic parametrization.
- sources: CURRENT_PATHS.md (2026-07-29 item 5, lines 1200-1212; Deprioritized-work list, line 2546).
- status_labels: **closed/refuted** — `F(HΦ_11)=ξ44⁵u¹¹+O(u⁹⁹)≠0`, all 25 classical Hessian minors nonzero; "Do not pursue the level-11 theta/Schwarz curve as a Klein-cubic parametrization."
- runs: `tmp/theta11_test/`.
- confidence: certain.

### Essential-dimension flat-connection / all-degree module PDE
- tries: positive/negative degree-free reformulation of the KLS landing problem: normalizes the generic frame by `τ=f3²/f5`, defines a flat connection `∇` on `K_proj⁵`, and reduces the whole headline to solving (or proving universal nonvanishing of) the rational PDE `det[a,∇1a,∇2a,∇3a,∇4a]=0` over `K_proj`; removes the artificial polynomial-degree parameter used elsewhere.
- sources: CURRENT_PATHS.md ("What the current attacks established" §1 tail, lines 1863-1901; Ranking B item 2).
- status_labels: infrastructure complete (algebraic independence of `f3,f5,f6,f8,f11`; rank-12 Hironaka basis; `[K_proj:P0]=12`; connection matrices as exact arithmetic circuits); "the full rational PDE remains unsolved"; explicit counterexample shows finite covariant generation gives no all-degree cutoff (`S5` counterexample) — "no uniform bound on every solution can be the missing reduction."
- runs: `tmp/kproj_arithmetic/`, `tmp/kproj_connection/`, `tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`, `tmp/ed_binary_attack/verify_all_degree_module_pde.py`, `tmp/step4_essential_dimension/`.
- confidence: certain.

### Literature & computational-tool audit (infrastructure)
- tries: not a mathematical construction/obstruction route itself, but a recurring due-diligence check for missed turnkey theorems or software (Magma, OSCAR, HomotopyContinuation.jl, Groebner.jl, Mathematica-alternatives) that could shortcut any of the above routes.
- sources: CURRENT_PATHS.md ("Recent literature and tool audit," lines 1655-1785).
- status_labels: "no theorem that converts index one or a degree-55 point on a cubic threefold into a rational point"; 2026-07-18 Cheltsov–Tschinkel–Zhang manuscript "still lists this full action as open"; several 2026 papers (subspace-arrangement regularity, border-basis schemes, equivariant birational invariants) found not to supply a missed obstruction/turnkey solution; one genuinely material missed theorem identified (Poonen–Stoll discriminant-valuation theorem, already absorbed into the xCD route).
- runs: `tmp/recent_structural_tools_audit/`, `tmp/recent_equivariant_tools_2026/`, `tmp/groebnerjl_change_matrix_pilot/`.
- confidence: certain (included as a stub/infrastructure entry per instructions to record even non-mathematical recurring efforts).