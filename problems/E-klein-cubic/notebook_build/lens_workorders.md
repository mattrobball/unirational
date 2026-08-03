### G — universal finite global lifting to a polynomial landing covariant
- tries: positive construction (with a built-in negative exit): build a nonzero G-equivariant homogeneous landing self-covariant p:W→W (F(p)=0) via formal normal-cone/polar lifting along the exact stabilizer stratification — finite-truncation theorem, terminal-residual towers at degrees 7/13/19, global-state-image vs. nonlinear-rank-drop analysis, and (in the NOTES synthesis) an analytic "G3-algebraization" shortcut via boundary maps on an equivariant resolution; G-NEGATIVE is the fallback all-degree negative exit if every family's universal terminal projective zero support is empty.
- sources: problems/E-klein-cubic/WORKORDER_CAS_HEADLINE.md (§4), WORKORDER_CAS_HEADLINE_REVISED.md (§6.1, parked), WORKORDER_POST_ELO_CONSTRUCTION.md (Path G, G0-G5), WORKORDER_FIVE_ATTEMPTS.md (Attempt 5), WORKORDER_ELO_TEN_PATHS.md (Path G), WORKORDER_STRATA_LIFTING_BLOCKERS.md (Parts I-III: WP-R0, WP-L1, WP-L2, WP-E1), WORKORDER_STRATA_MACHINE.md (WP-4, WP-5, WP-6), NOTES_PATH_G_GLOBAL_LIFTING.md, REMAINING_GOALS_NOTE.md, GOALS_NEXT_10_ROUTES_2026-08-02.md (#1).
- status_labels: "no finite global presentation was constructed... nonexistence of such a presentation is not proved" (WORKORDER_CAS_HEADLINE_REVISED.md, parked); `G_{m,d}⊆R_{3,m}` vs open meeting "undecided" (WORKORDER_FIVE_ATTEMPTS.md); table of certified/false/not-proved sub-claims incl. "Marked state gives a boundary map — not proved", "Equivariant interpolation from projective endpoint data — false without a common-character hypothesis", "Affine completion has the same formal-rational field as the full completion — false", "G-unirationality — not proved" (NOTES_PATH_G_GLOBAL_LIFTING.md §18); "G2-FINITE-GENERATION-PASS: universal object + all-degree theorem; residual is G3" and "G3 arithmetic OPEN" (REMAINING_GOALS_NOTE.md).
- runs: G1 finite-truncation theorem; G2 degree-7 tower; G3 degrees 13/19 comparison; G4 global correction sheaves; G5 candidate audit; WP-R0 category repair (source/normal-cone/target P(E_-) separation); WP-L1 universal polar expansion; WP-L2 relative obstruction tower (families based_minus_lines_odd_m, residual_e1_swap_both, residual_e_ge7_generic_swap_both); WP-E1 elliptic Pic^0 obstruction; WP-4A-4E local transition modules; WP-5 global transition diagram (Levels 1-3); WP-6 border/Fitting integration; G4.1-G4.4 (CAS_HEADLINE); G-A/G-B/G-C/G-D boundary-realization questions (NOTES_PATH_G).
- confidence: certain

### WP-STRATA — exact stabilizer strata & normal-cone transition necessity machine
- tries: infrastructure/negative — build a portable characteristic-zero stabilizer stratification of P^4 and X, tangent/normal character decorations, local transition modules, and a global inverse-limit ("normal-cone necessity theorem") as an all-degree necessary-condition screen for any hypothetical landing covariant; feeds into Path G.
- sources: problems/E-klein-cubic/WORKORDER_STRATA_MACHINE.md.
- status_labels: "Problem E remains open" (file-wide); WP0-WP7 gate structure; environment addendum: GAP/SageMath/Singular/PARI/Julia "NOT INSTALLED", blocking WP-1/WP-3 as literally specified; type-I/type-II V4 incidence inconsistency in supplied `strata.md` flagged unresolved.
- runs: WP0 input audit; WP1 exact stratification; WP2 tangent/normal characters; WP3 marked S3 geometry; WP4 local transition modules (A-E); WP5 global transition diagram (exits N1/N2/N3/P); WP6 border/Fitting integration; WP7 theorem assembly.
- confidence: certain

### FABLE — Koszul ansatz order-twelve gate
- tries: positive construction — extend a sealed "first-gate Koszul theorem" (projective Fable trisection class σ at 165 plane-line flags, F(σ)=0 mod I^11) to a "second gate": find a correction e with F(σ+e)=0 mod I^13, via an explicit rank-one invariant residue sheaf on the genuine Q=0 sections and character-projector/Serre-vanishing machinery.
- sources: problems/E-klein-cubic/WORKORDER_ORDER12.md; cross-referenced in WORKORDER_STRATA_MACHINE.md (environment addendum, re: commit 71ba6bd) and WORKORDER_FIVE_ATTEMPTS.md (§0 item 4).
- status_labels: WORKORDER_ORDER12.md — active dispatch, headline "OPEN," target = second gate; WORKORDER_STRATA_MACHINE.md addendum — "the Fable positive branch was closed by two obstruction theorems (elliptic quadratic-trace; Veronese/Hilbert–Burch syzygy dichotomy)"; WORKORDER_FIVE_ATTEMPTS.md — "The known elliptic Pic^0-trace obstruction is valid but specific to the previous Fable order-3/4 ansatz."
- runs: first gate (Koszul theorem, sealed, not re-derived); second gate order-twelve residue-sheaf construction (construct residue sheaf globally; solve residue equation section-by-section; check thickened-ring compatibility with B_desc; absorb remainder via correction map e↦3Φ(p,p,e); seal packet).
- confidence: certain (existence/target); refutation mechanism/timing is inferred from cross-reference only

### xCD — plane-section route
- tries: unspecified plane-section-based route toward the headline; no mathematical content is available in this document set beyond the name.
- sources: problems/E-klein-cubic/WORKORDER_ORDER12.md (line 4, mentioned only as background).
- status_labels: "refuted and retired" (WORKORDER_ORDER12.md).
- runs: none recorded.
- confidence: inferred (stub — no mathematical content given in this lens)

### T — target-branch/fold-algebra normalization and 3-primary index-three obstruction
- tries: negative obstruction — prove that the normalized target branch / fold algebra S_G retains a residue-degree-one branch of Cramer index 3, i.e. (Cl/Pic)[3]=0 on a normalized cubic-discriminant-contact model, giving a pointless versal Klein twist (⇒ BR-T-NEG). Long chain: finite birationality S→B, Serre normality (S_2+R_1), conductor/discriminant-contact mod 3, class-group assembly; later reframed to normalize the fold algebra S_G directly (avoiding raw elimination of the degree-43 target-branch hypersurface) via subresultant/Hensel/binodal analysis. Includes the "upstairs simple-fold" precursor strategy.
- sources: problems/E-klein-cubic/WORKORDER_CAS_HEADLINE.md (§3), WORKORDER_CAS_HEADLINE_REVISED.md (§4), WORKORDER_CAS_DECISION_AFTER_7FDBE42.md & _V2.md (Track T, T6.0-T6.3), WORKORDER_CAS_AFTER_5E72D8E.md (Track T8), WORKORDER_CAS_T9_P25Z.md (Track T9), WORKORDER_CAS_T10_P25W_C2.md + WORKORDER_CAS_T10_P25W_C2_CORRECTION.md (Track T10), WORKORDER_CAS_T11_P25V_C3.md (Track T11), WORKORDER_POST_ELO_CONSTRUCTION.md (Path T), WORKORDER_FIVE_ATTEMPTS.md (Attempt 2), WORKORDER_ELO_TEN_PATHS.md (Path B "upstairs simple fold"), WORKORDER_STRATA_LIFTING_BLOCKERS.md (Part V WP-T1), DIRECTOR_HANDOFF.md, DIRECTOR_REVIEW_AFTER_BD610A.md, REMAINING_GOALS_NOTE.md.
- status_labels: `T-BIRATIONAL` retained; `T-NONNORMAL` suspended (WORKORDER_CAS_HEADLINE_REVISED.md); `T2R-UNDECIDED`: S_2 proved, dim Sing(S_G)≤2, R_1 undecided (DIRECTOR_HANDOFF.md); `T60-UNDECIDED` (DIRECTOR_HANDOFF.md §8); `T8-S1-NONUNIT-ANALYTIC` / `T9-HENSEL-NONUNIT-SEALED` settled (DIRECTOR_HANDOFF.md, WORKORDER_CAS_T9_P25Z.md); `T-BRANCH-NONNORMAL` (target branch has a divisorial binodal locus) (WORKORDER_CAS_T9_P25Z.md, WORKORDER_CAS_T10_P25W_C2.md); `T10-BINODAL-NO-3-DEFECT`; `T10-FOLD-HEIGHT1`/`T11-FOLD-HEIGHT1` sought but undecided at T10, pursued at T11; DIRECTOR_REVIEW_AFTER_BD610A.md §4 Rank3: "the strongest developed negative route... needed facts are finite and local"; §2.4: "Ordinary Picard theory is complete... Neither its vanishing nor a dangerous class has been proved."
- runs: T1-T4 (POST_ELO); T3.1-T4 (HEADLINE); T2R.4-T2R.5 (REVISED); T6.0-T6.3 (DECISION/_V2); T8.1-T8.4 (AFTER_5E72D8E); T9.0-T9.3 (T9_P25Z); T10.0-T10.3 (T10_P25W_C2, incl. binding correction re: "Q→Q_101 regular extension" wording); T11.0-T11.3 (T11_P25V_C3); WP-T1 (STRATA_LIFTING_BLOCKERS); Path B B1-B4 upstairs normalization (ELO_TEN_PATHS, precursor to the S_G fold-algebra strategy).
- confidence: certain

### T3-local — fixed-frame local-runner normalization
- tries: infrastructure/auxiliary continuation of the T/index-3 class-group computation, scoped to the fixed-frame slice via local CAS runners; explicitly demoted from headline status.
- sources: problems/E-klein-cubic/REMAINING_GOALS_NOTE.md.
- status_labels: `T3-UNDECIDED`; "Local-runner portfolio only; fixed-frame; not headline after B-BRIDGE-REFUTED."
- runs: none named beyond the front code (artifact pointer `T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER`).
- confidence: inferred (thin documentation in this lens)

### B — fixed-frame exhaustiveness bridge
- tries: negative bridge attempt — argue that pointlessness of the exact fixed-frame ternary cubic slice is exhaustive for (implies pointlessness of) the full projector/Fano variety, which would let the fixed-frame pointlessness result close the headline negatively.
- sources: problems/E-klein-cubic/REMAINING_GOALS_NOTE.md, DIRECTOR_REVIEW_AFTER_BD610A.md (§1 item 1; §2.3).
- status_labels: `B-BRIDGE-REFUTED` (REMAINING_GOALS_NOTE.md); "Pointlessness of the fixed-frame ternary cubic does not transfer to the generic Klein twist... the fixed projector slice is not exhaustive in the full Fano/projector variety" (DIRECTOR_REVIEW_AFTER_BD610A.md §1, §2.3).
- runs: artifact pointer `B_FIXED_FRAME_EXHAUSTIVENESS_20260802`.
- confidence: certain

### F — fixed-frame genus-one torsor / restricted E[3]-class arithmetic
- tries: decide rationality of an explicit fixed-frame genus-one curve / restricted E[3]-Selmer class over K_proj: either find a divisorial local obstruction (Kummer-image nonmembership ⇒ pointless) or construct a rational point via a conic/intersection-algebra reformulation (a length-6 conic ∩ curve whose coordinate algebra ≅ K_proj).
- sources: problems/E-klein-cubic/WORKORDER_POST_ELO_CONSTRUCTION.md (Path F, F0-F4), WORKORDER_ELO_TEN_PATHS.md (Path F, ranked #2), WORKORDER_FIVE_ATTEMPTS.md (§0 background).
- status_labels: no exit verbatim-resolved in this document set; decision exits defined `N-F`,`P-F`,`F-LOCAL-SOLUBLE`,`F-STOP`; headline "OPEN".
- runs: F1 restricted étale algebra; F2 divisor-cube test mod 3; F3 group-cohomological restriction; F4 consequences; Fork F1-N (new divisorial obstruction) vs Fork F1-P (conic/intersection-algebra construction).
- confidence: certain

### V/G5 — residue twist f5/f6 valuation obstruction
- tries: negative obstruction — decide pointlessness of the full residual "f5" or "f6" twist (a valuation/residue construction tied to the degree-11 torus structure), as opposed to finite proxy computations.
- sources: problems/E-klein-cubic/REMAINING_GOALS_NOTE.md, GOALS_NEXT_10_ROUTES_2026-08-02.md (#6).
- status_labels: `V-UNDECIDED`; `V3-RESIDUE-NORMAL-FORM-PASS` (mechanics closed; "residual is residue binaries only").
- runs: artifact pointer `V3_VALUATION_RESIDUE_CLOSEOUT_20260802`.
- confidence: inferred (reconstructed mainly from front-code table entries)

### P25 — degree-25 landing self-covariant construction
- tries: positive construction — build an exact, primitive, characteristic-zero degree-25 homogeneous G-equivariant landing self-covariant p:W→W with F(p)=0 and generic Jacobian rank 4, via a sequence of increasingly rigorous finite/global coefficient models, border/Fitting-module presentations, and projective-support decisions (with DVR-properness arguments for emptiness).
- sources: problems/E-klein-cubic/WORKORDER_CAS_HEADLINE.md (§5), WORKORDER_CAS_HEADLINE_REVISED.md (§3, P25R), WORKORDER_CAS_DECISION_AFTER_7FDBE42.md & _V2.md (Track P25, P25X), WORKORDER_CAS_AFTER_5E72D8E.md (Track P25Y), WORKORDER_CAS_T9_P25Z.md (Track P25Z), WORKORDER_CAS_T10_P25W_C2.md (Track P25W), WORKORDER_CAS_T11_P25V_C3.md (Track P25V), WORKORDER_STRATA_MACHINE.md (WP-6), WORKORDER_STRATA_LIFTING_BLOCKERS.md (WP-B1), DIRECTOR_HANDOFF.md, REMAINING_GOALS_NOTE.md, GOALS_NEXT_10_ROUTES_2026-08-02.md (#1, #10).
- status_labels: `P25-TOWER-EMPTY/SURVIVES`, `P25R0/1/2-*`, `P25X0/1/2-PASS/FAIL/UNDECIDED`, `P25Y-DVR-PASS`, `P25Z-ROW-RANK-746` (verified: "the direct landing row rank is exactly 746"), `P25Z-FINITE-PRESENTATION-LOWER`, `P25W-PRESENTATION-EXACT/ENLARGE/UNDECIDED`, `P25-DEGREE25-EMPTY`, `P25-COVARIANT`/`P25-POLYNOMIAL` (target, not reached); `P25-UNDECIDED`, "63 charts on D(H_8)... PREPARED_NOT_RUN" (REMAINING_GOALS_NOTE.md); historical 842-row / rank-28 packets "quarantined" and later "retired on mathematical grounds" (DIRECTOR_HANDOFF.md).
- runs: P25.1-P25.4 (HEADLINE); P25R.0-P25R.3 (REVISED); P25X.0-P25X.2 (DECISION/_V2); P25Y.1-P25Y.4 (AFTER_5E72D8E); P25Z.1-P25Z.3 (T9_P25Z); P25W.0-P25W.3 (T10_P25W_C2); P25V.0-P25V.3 (T11_P25V_C3); WP-B1 (STRATA_LIFTING_BLOCKERS); WP-6 (STRATA_MACHINE).
- confidence: certain

### COV — degree-31/35 covariant landing modules
- tries: positive construction, sibling of P25 at higher degree — decide the plane-order-one covariant modules in degrees 31 and 35 (and their based/nonbased C3/C6 linear gates), coupled to degree 25 by invariant multiplication.
- sources: problems/E-klein-cubic/REMAINING_GOALS_NOTE.md, GOALS_NEXT_10_ROUTES_2026-08-02.md (#10), DIRECTOR_REVIEW_AFTER_BD610A.md (§1 item 5, §2.6).
- status_labels: `COV-UNDECIDED`, "148 residual charts; modular [1] ≠ char-0 transfer" (REMAINING_GOALS_NOTE.md); "Degrees 31 and 35 still require saturation of their based and nonbased C3/C6 charts and are coupled to degree 25 by invariant multiplication" (DIRECTOR_REVIEW_AFTER_BD610A.md §2.6); "the degree-35 zero linear quotient is not a degree-wide emptiness theorem" (§1 item 6).
- runs: artifact pointer `COV_M1_DEG31_35`.
- confidence: inferred (reconstructed mainly from director-review prose and front-code table)

### Attempt-1-Pfaffian — Pfaffian–Morita idempotent construction
- tries: positive construction — convert an abstractly-proved σ-self-adjoint reduced-rank-two idempotent in the Morita/Pfaffian algebra into a K_proj-point on the generic Klein twist, via quaternion-corner reduction and a conic/intersection-algebra coordinate extraction; requires an explicit bridge audit (idempotent ⇒ common isotropic line ⇒ point ⇒ unirationality).
- sources: problems/E-klein-cubic/WORKORDER_FIVE_ATTEMPTS.md (Attempt 1, §1A-1D), WORKORDER_ELO_TEN_PATHS.md (§1 status table), WORKORDER_POST_ELO_CONSTRUCTION.md (§0 item 5).
- status_labels: `FAIL-SCOPE`: "idempotent gives a point of auxiliary P^2_D, not of F_{14,T}" (WORKORDER_ELO_TEN_PATHS.md); decision exits defined `P1`,`P1-CONDITIONAL`,`N1-SCOPED`,`STOP-1` (WORKORDER_FIVE_ATTEMPTS.md).
- runs: 1B Gate1 bridge audit (CFOSS w1 pin, implication-chain check); 1C Gate2 quaternion-corner reduction / rational-section-or-torsor identification; 1D Gate3 exact coordinate extraction (symmetric cubic solve; conic/intersection-algebra formulation).
- confidence: certain

### C — direct twisted Fano section (quaternion/Hermitian/common isotropic line)
- tries: positive construction — install an executable model of the descended central simple algebra A_proj (quaternion corner D=eAe, five Hermitian matrices h_1..h_5∈Herm_3(D)), independently construct restricted Plücker/rank-one equations for F_{14,T}, and search (fibration/multisection/direct solve) for a common isotropic right D-line, i.e. a K_proj-point of F_{14,T} (⇒ BR-FANO-POS).
- sources: problems/E-klein-cubic/WORKORDER_CAS_HEADLINE.md (§6), WORKORDER_CAS_HEADLINE_REVISED.md (§5), WORKORDER_CAS_DECISION_AFTER_7FDBE42.md & _V2.md (§4), WORKORDER_CAS_AFTER_5E72D8E.md (§5, Track C0), WORKORDER_CAS_T9_P25Z.md (§5, Track C1), WORKORDER_CAS_T10_P25W_C2.md (§5, Track C2, two-generator compression), WORKORDER_CAS_T11_P25V_C3.md (§5, Track C3, maximal-étale compression), WORKORDER_POST_ELO_CONSTRUCTION.md (Path C), WORKORDER_ELO_TEN_PATHS.md (Path C), DIRECTOR_HANDOFF.md, REMAINING_GOALS_NOTE.md.
- status_labels: `C0-UNDECIDED — verified`, "no executable Fano model; needs A_proj descent → Morita symbol"; "Two clean negatives... no such mechanism exists geometrically... No model installed" (DIRECTOR_HANDOFF.md §8); sub-installation exits `C0-MODEL-PASS`/`C1-MODEL-PASS`/`C2-FANO-MODEL`/`C3-FANO-MODEL-PASS`, `C2-TWO-GENERATORS-MODULAR`, `C3-RECTANGULAR-BASIS-MODULAR`; target exit `C-POSITIVE`/`C-FANO-POINT` not reached.
- runs: C1/C2/C3 (HEADLINE, REVISED); C0.1-C0.2 (AFTER_5E72D8E); C1.1-C1.2 (T9_P25Z); C2.0-C2.3 (T10_P25W_C2); C3.0-C3.3 (T11_P25V_C3).
- confidence: certain

### C5/C6 — corrected Palatini/common-line Plücker big cell
- tries: positive construction, alternative model to Route C's quaternion approach — represent the common isotropic right line directly via a self-adjoint reduced-rank-two idempotent e in the exact lazy algebra with involution (e²=e, σ(e)=e, Trd(e)=2, eS_ie=0 for i=1..5), using a corrected alternating-form/Plücker/square-zero common-line incidence model (retiring an earlier inconsistent idempotent encoding e·S_0·e=0).
- sources: problems/E-klein-cubic/REMAINING_GOALS_NOTE.md, GOALS_NEXT_10_ROUTES_2026-08-02.md (#3), DIRECTOR_REVIEW_AFTER_BD610A.md (§4 Rank1).
- status_labels: `C5-UNDECIDED`; ranked "Rank 1" in DIRECTOR_REVIEW_AFTER_BD610A.md as the strongest live positive route at that time ("All ingredients except the final full incidence solve are already available. An exact point executes BR-FANO-POS and closes the headline positively"); supersession note: "C5 idempotent e*S_0*e=0 | Plücker/alternating-form model → C6" (REMAINING_GOALS_NOTE.md).
- runs: artifact pointer `C5_PROJECTOR_INCIDENCE`; goal file `GOAL_C6_PALATINI_BIG_CELL.md` (pointer only, not read in this lens).
- confidence: inferred (details reconstructed from cross-document references; underlying goal files not in this lens's document set)

### I — Hermitian five-plane intersection theory
- tries: positive/negative via arithmetic invariants — study the common zero locus of the five Hermitian sections on SB_2(A)≅P^2_D using intersection theory rather than direct elimination; look for a "point-sensitive" invariant (Chow–Witt Euler class, Witt-group obstruction, unramified cohomology, canonical-dimension/incompressibility, Hermitian Euler class) beyond the ordinary Chow class.
- sources: problems/E-klein-cubic/WORKORDER_ELO_TEN_PATHS.md (Path I, ranked #7).
- status_labels: ranked "structural," Elo 1473; decision exits `N-I`,`P-I`,`I-STOP` (none resolved in this lens).
- runs: I1 identify point-sensitive invariant.
- confidence: certain

### S19-Krylov — Schur degree-19 rescue curve (Attempt 3 / Path A Krylov / Route S19)
- tries: positive construction — build a geometrically integral degree-19 genus-0 curve through the exact degree-55 closed marked point on the generic Schur twist so the residual cubic intersection is a length-2 cycle, giving a K_proj-point (⇒ BR-SCHUR19-POS); pursued via (a) classification of Rao branches/marked Hilbert schemes for the two live branches, (b) a Schur–Krylov rational-parametrization/incidence-matrix approach, later demoted to a "low-degree Krylov-growth theorem" after the direct 52-variable elimination was found computationally intractable, and (c) a relative universal-hyperplane-family + marked Quot-scheme construction.
- sources: problems/E-klein-cubic/WORKORDER_FIVE_ATTEMPTS.md (Attempt 3), WORKORDER_ELO_TEN_PATHS.md (Path A, ranked #1), WORKORDER_POST_ELO_CONSTRUCTION.md (Path A, A0-A4, retired direct elimination), WORKORDER_CAS_HEADLINE.md (§7 Route S19), WORKORDER_CAS_HEADLINE_REVISED.md (§6.2), WORKORDER_CAS_T9_P25Z.md / T10_P25W_C2.md / T11_P25V_C3.md (lower-priority S19 track).
- status_labels: "implication chain PASS; both Rao branches remain live; STOP-3" (WORKORDER_ELO_TEN_PATHS.md); "Path A is computationally stopped in its current form... No memory increase changes that" (WORKORDER_POST_ELO_CONSTRUCTION.md §0 item 4); "Do not restart primitive-element/Krylov elimination... no worker is dispatched this round unless T10, P25W, and C2 all stop" (WORKORDER_CAS_T10_P25W_C2.md §6); target exits `P-A`/`P3`/`S19-POSITIVE` not reached.
- runs: Attempt 3 3B-3D (implication audit; Rao-branch classification; negative boundary-zero-torsor subroute); Path A A1-A5 (P^1-reduction theorem; degree-55 algebra install; Krylov incidence construction); Path A A0-A4 (POST_ELO_CONSTRUCTION, low-degree block-Krylov growth theorem, after elimination retired); Route S19 S19.1-S19.3 (universal split-hyperplane marked orbit; relative ideal/resolution; marked Quot schemes for the two Rao branches).
- confidence: certain

### M3 — Sarkisov link / del Pezzo fibration section search
- tries: positive/structural — having constructed an exact type-I Sarkisov link (blow up a smooth plane cubic on the Schur generic Klein twist) to a relative degree-3 del Pezzo fibration over P^1 with multisections of degree 3 and 55 (hence index 1), search in Cox coordinates for an actual rational section (positive headline) as opposed to only a degree-4 multisection (insufficient, proves only index 1).
- sources: problems/E-klein-cubic/DIRECTOR_REVIEW_AFTER_BD610A.md (§1 item 3, §2.2, §4 Rank4), REMAINING_GOALS_NOTE.md, GOALS_NEXT_10_ROUTES_2026-08-02.md (#8).
- status_labels: `M3-INTEGRAL-DEGREE4-MULTISECTION` (terminal, multisection only); `M3B-G1-MODULAR-NONEMPTY-PASS` (residual); "K-section open"; "A rational section... would... close the headline positively. The current packet does not select the section branch. A degree-four multisection... proves only index one and cannot be promoted to a section" (DIRECTOR_REVIEW_AFTER_BD610A.md §2.2).
- runs: artifact pointers `M3_SARKISOV_SECTION` (primary) and `M3B_SECTION_RESIDUAL_G1_20260802` (residual sub-run).
- confidence: certain (existence/status); construction detail is inferred from director-review prose since underlying goal packets are outside this lens

### Q/Q3 — Schur index / primitive quartic resolvent descent obstruction
- tries: negative/structural obstruction related to M3 — decide a "Schur point" binary via a descent-obstruction audit; replace a failed standard descent obstruction with a stable-cubic/resolvent descent from a primitive quartic resolvent, and prove any resulting obstruction transfers to the headline.
- sources: problems/E-klein-cubic/REMAINING_GOALS_NOTE.md, GOALS_NEXT_10_ROUTES_2026-08-02.md (#7).
- status_labels: `Q-UNDECIDED`; `Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS` (scoped pass); "Q3 preferred" as successor.
- runs: artifact pointer `Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802`.
- confidence: inferred (reconstructed mainly from front-code tables; underlying goal file not in this lens)

### E — proper-subgroup generic twists (A4, both A5 classes)
- tries: negative-first strategy — since X G-unirational ⇒ H-unirational for every H≤G, test one maximal-subgroup class at a time for a pointless generic H-twist (⇒ BR-SUBGROUP-NEG); positive results found rational points on the generic A4 twist and on both maximal A5-class generic twists, but these only close the corresponding subgroup obstruction and do not construct a dominant G-map (published A5 maps have two-dimensional image).
- sources: problems/E-klein-cubic/WORKORDER_ELO_TEN_PATHS.md (Path E, ranked #8), WORKORDER_CAS_HEADLINE.md (§9 Route H), WORKORDER_CAS_HEADLINE_REVISED.md (§6.3), REMAINING_GOALS_NOTE.md ("H2/H3 | points on A4 and both A5 twists"), DIRECTOR_REVIEW_AFTER_BD610A.md (§1 items 1-2, §2.1).
- status_labels: decision exits `N-E`,`P-E-SCOPED`,`E-STOP` (none resolved); "The canonical generic A_4 twist has an exact rational point... Both maximal A_5 generic twists have exact rational points" (DIRECTOR_REVIEW_AFTER_BD610A.md §1); "The subgroup points close the corresponding subgroup point obstructions. They do not construct a dominant G-equivariant map... the A_5 returns cannot be promoted" (§2.1).
- runs: E1 one-A5-class pilot; H1 two maximal A5 classes (WORKORDER_CAS_HEADLINE.md §9); A4 twist point construction (H2); A5 twist point constructions (H3, degree-11 Reynolds covariants).
- confidence: certain

### H5/H6 — 11:5 (Frobenius) subgroup generic twist / trace cubic via torus isogeny
- tries: negative/structural obstruction for the proper subgroup C11⋊C5 ≤ G — reduce the generic 11:5 twist exactly to a genuine cyclic trace cubic Tr_{E/K}(r_2^{-1}a²σ(a))=0 over a rational four-parameter invariant field, and decide the trace cubic's pointlessness using the degree-11 torus/isogeny structure (⇒ BR-SUBGROUP-NEG if pointless).
- sources: problems/E-klein-cubic/DIRECTOR_REVIEW_AFTER_BD610A.md (§1 item 4, §2.5, §4 Rank2), REMAINING_GOALS_NOTE.md, GOALS_NEXT_10_ROUTES_2026-08-02.md (#5).
- status_labels: `H-11_5-NORM-MODEL-PASS` (model installed); `H5-UNDECIDED`, "no K-point; binary open"; "the exact trace model is now sufficiently small to attack, but no pointlessness theorem is present" (DIRECTOR_REVIEW_AFTER_BD610A.md §2.5); ranked "Rank 2 — the smallest exact genuine twist left" (§4).
- runs: artifact pointer `H5_11_5_TRACE_CUBIC`.
- confidence: certain (status/target); mechanism partly inferred since underlying goal files are outside this lens

### G4/A5Q — A5 degree-11 point transfer / quartic rescue
- tries: positive construction — transfer the exact degree-11 A5 twist points into a genuine PSL(2,11) projective generic-twist point, via subgroup-embedding compatibility and a field-descent argument; alternatively, test whether the degree-11 closed point on the full generic twist lies on a descended rational normal quartic in P^4 (meeting the cubic in degree 12, leaving a rational residual point).
- sources: problems/E-klein-cubic/GOALS_NEXT_10_ROUTES_2026-08-02.md (#4), DIRECTOR_REVIEW_AFTER_BD610A.md (§4 Rank6).
- status_labels: "A high-risk but finite new positive route" (DIRECTOR_REVIEW_AFTER_BD610A.md); listed as priority-4 dispatch item, "Need: compatibility of subgroup embeddings; field descent argument" (GOALS_NEXT_10_ROUTES_2026-08-02.md); not yet run.
- runs: two-stage plan (install degree-11 point on full generic twist; test quartic-descent residual).
- confidence: inferred (two documents apparently describing the same route under two names, merged here)

### KLS — minimality-conductor theorem
- tries: negative all-degree theorem — prove that a primitive minimal rank-4 landing self-covariant cannot exist by coupling minimality to conductor geometry (control of non-plt conductor places, source-component multiplicities dominating each conductor component, degree-lowering operations), given that normality/lc/plt alone are proven-insufficient hypotheses (explicit countermodels exist).
- sources: problems/E-klein-cubic/WORKORDER_CAS_HEADLINE.md (§8, conditional), WORKORDER_FIVE_ATTEMPTS.md (Attempt 4), WORKORDER_ELO_TEN_PATHS.md (Path H, ranked #6).
- status_labels: "No large KLS computation is authorized until the analyst supplies a precise theorem" (WORKORDER_CAS_HEADLINE.md §8); exits `KLS-FINITE-TABLE-CLOSED`,`KLS-COUNTERMODEL`,`KLS-NO-THEOREM`, `N-H`,`H-UNIQUE`,`H-COUNTERMODEL` (none resolved); "The proposed KLS minimality-to-discrepancy reduction does not produce a nontrivial finite list... no proved theorem controls the conductor support" (DIRECTOR_REVIEW_AFTER_BD610A.md §1 item 4).
- runs: H1/4B target-theorem formalization; H2/4C degree-lowering operation construction; 4D global inequality; KLS.1-KLS.3 (HEADLINE, conditional).
- confidence: certain

### Hodge — equivariant Hodge-center / CM-polarized obstruction
- tries: negative necessary-condition screen — from a hypothetical dominant equivariant map P^4⇢X and its equivariant resolution, use the split injection H^3(X)↪H^3(Z) and the blowup formula H^3(Bl_C Y)≅H^3(Y)⊕H^1(C)(-1) to show H^{2,1}(X) as a G-representation must be supplied by H^{1,0} of positive-irregularity blowup centers; then upgrade this representation-only screen to the integral polarized intermediate-Jacobian (CM order, principal polarization) structure to try to force a contradiction via minimum-genus/orbit-size bounds (Riemann–Hurwitz/Chevalley–Weil).
- sources: problems/E-klein-cubic/WORKORDER_STRATA_LIFTING_BLOCKERS.md (Part VI WP-H1), WORKORDER_ELO_TEN_PATHS.md (Path D, ranked #9), WORKORDER_FIVE_ATTEMPTS.md (§0 item 5), DIRECTOR_REVIEW_AFTER_BD610A.md (§1 item 2).
- status_labels: "necessary condition only; 40 representation channels survive" (WORKORDER_ELO_TEN_PATHS.md); decision exits `N-D`,`D-NARROW`,`D-STOP` (none resolved); "The unrestricted equivariant motive/Hodge invariant is too flexible: admissible blowup centres can reproduce the required summand" (DIRECTOR_REVIEW_AFTER_BD610A.md §1 item 2).
- runs: WP-H1 tasks 1-6 (split injection, H^{2,1} representation, character screen, Riemann-Hurwitz/Chevalley-Weil bounds); Path D D1 (repair split-injection proof, install period lattice/CM order/polarization), D2 (geometric channel screen).
- confidence: certain

### J — direct essential-dimension / canonical-dimension invariant
- tries: negative — prove ed_C(G)=4 directly via a cohomological/canonical-dimension/motivic invariant that survives every 3-dimensional compression, by auditing candidate invariants (cohomological invariants, equivariant Chow/Steenrod operations, canonical dimension/incompressibility, motives of generic projective representations, unramified cohomology) against four required criteria before any computation.
- sources: problems/E-klein-cubic/WORKORDER_ELO_TEN_PATHS.md (Path J, ranked #10).
- status_labels: "theory watch" (queue status); decision exits `N-J`,`J-CANDIDATE`,`J-STOP` (none resolved in this lens).
- runs: J1 candidate-invariant audit.
- confidence: certain

### dP-replay — del Pezzo-style invariant geometric obstruction replay
- tries: proposed analytic search — identify the analogue, for Problem E, of an unspecified prior "successful del Pezzo closure mechanism": search for a canonical torsor, universal family section, or equivariant intermediate object whose existence is equivalent to G-unirationality of X.
- sources: problems/E-klein-cubic/GOALS_NEXT_10_ROUTES_2026-08-02.md (#2).
- status_labels: listed as priority-2 dispatch item; not yet run ("Type: analytic").
- runs: none.
- confidence: certain (as a stated proposed route); mathematical content beyond the brief description is not available in this lens

### unknown-example — literature/internal search for hidden intermediate-variety mechanism
- tries: proposed search (cubic threefolds, Fano varieties, finite simple group actions) for previously unknown examples where equivariant unirationality was settled by a hidden intermediate variety rather than by representation covariants, to import technique.
- sources: problems/E-klein-cubic/GOALS_NEXT_10_ROUTES_2026-08-02.md (#9).
- status_labels: listed as priority-9 dispatch item; not yet run.
- runs: none.
- confidence: certain (as stated); no further detail available

### A0 — canonical audit of projection bulk
- tries: infrastructure verification (not itself a route to the headline) — certify the "projection bulk 4140/315" figure underlying canonical reduction/audit machinery used elsewhere in the project.
- sources: problems/E-klein-cubic/REMAINING_GOALS_NOTE.md.
- status_labels: `A0-CANONICAL-AUDIT-PASS` (already terminal, not an open mission).
- runs: artifact pointer `A0_CANONICAL_AUDIT`.
- confidence: inferred (single-line description only; mathematical substance not elaborated in this lens)

### R/M-stub — prior terminal routes R/R2, M/M2 (undocumented in this lens)
- tries: unknown — referenced only by code name as completed/superseded prior routes; no mathematical description is given in any document read under this lens. (Other codes in the same table row — A5Q, F, T/T2, J/J2, D/D2, KLS/KLS2, V2 — are documented elsewhere in this taxonomy under their own entries; R/R2 and M/M2 remain unexplained here.)
- sources: problems/E-klein-cubic/REMAINING_GOALS_NOTE.md ("Already terminal" table: "A5Q, F, T/T2, J/J2, D/D2, KLS/KLS2, V2, R/R2, M/M2 | prior terminals").
- status_labels: "prior terminals" (no further detail).
- runs: none named.
- confidence: inferred (stub; codes only, no accompanying mathematical description in this document set)