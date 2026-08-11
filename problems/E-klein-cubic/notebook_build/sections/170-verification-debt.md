## Verification debt

Aggregated from the `verify_flags` of all four sessions files plus the canonical
ledger's conflicts. Priority order 1–8 is fixed by the strategic weight of the
claim; 9+ are ordered by route.

### 1. Verifier depth — the weak spots are six named packets, not the whole seal regime

- **Claim under test:** the blanket statement that "packet `verify.py` scripts check hashes and markers, not algebra", i.e. that a `verify.py`/`SEAL.json` replay never verifies a packet's mathematics.
- **Measured result (2026-08-03, `notebook_build/verifier_depth.md`):** the blanket claim is **wrong as a generalization**. In the `goal_runs` layer, **69 of 75** run/sub-run verifiers ALGEBRAIC-RECOMPUTE — they independently reconstruct the objects and re-verify identities, ranks, or emptiness computationally; there are **zero** packets with no verifier at all. In the certificates layer, **13 of 26** sampled packets ALGEBRAIC-RECOMPUTE and a further **10** PARTIAL-RECOMPUTE. The weak verifiers number roughly 6 out of ~100.
- **The actual weak spots — these, and only these, are the debt:**
  - `R0_CANONICAL_REFRESH` ([E29](#e29)) — CONSISTENCY-ONLY, and the only `-PASS` primary exit resting on one. Already marked stale.
  - `B_FIXED_FRAME_EXHAUSTIVENESS_20260802` ([E06](#e06)) — CONSISTENCY-ONLY (JSON dimension fields and text markers), and it backs `B-BRIDGE-REFUTED`, a headline-load-bearing negative sitting over an analytic finiteness citation. **This is the one that matters** — see debt item 3.
  - `Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802` ([E27](#e27)) — CONSISTENCY-ONLY (git-blob hashes and markers), matching that session's own disclosure.
  - G3H phase 4 ([E17](#e17)) — interface bookkeeping only; the `INTERFACE_INSTALLED` frame.
  - `certificates/elliptic_lifting` ([E28](#e28)) — its internal `PROVED_AS_REGRESSION` marker is accepted by hash-check/field-read only.
  - `certificates/pfaffian_point` ([E26](#e26)) — NO-VERIFIER; it hosts the `FAIL-SCOPE` bridge audit, which is an analytic audit document by nature.
- **Why still load-bearing:** Binding rule 3 stands — replay is not verification of an analytic implication a verifier merely reads from JSON or Markdown. But the correct posture is targeted, not systemic: re-derive the six above rather than distrusting all ~100.
- **Where it lives:** `notebook_build/verifier_depth.md` holds the full per-packet tables for both layers.
- **What verification looks like:** for each of the six named packets whose exit label is cited in a headline argument, an independent re-derivation of the mathematical step rather than a replay. The per-packet triage this item used to ask for **has now been done** — it is `verifier_depth.md`.
- **Entry-level classes extend the artifact rubric** with ANALYTIC-PROOF-REVIEW, LITERATURE-DEPENDENT, EXTERNAL-UNVERIFIED, PROPOSAL-UNRUN for records with no machine verifier by nature — analytic arguments audited only by reading, conditional literature forks, session-only claims, and specified-but-unrun proposals, respectively. All 55 canonical entries now carry a **Verification class:** line under this extended vocabulary.

### 2. G2 five-way reduction + `G3-DOMINANCE-AUTOMATIC` — foundation of the current strategy

- **Claim under test:** (i) `G2-FINITE-GENERATION-PASS` — the all-degree equivalence of five formulations (a `K_proj`-point of `X_T`; a `G`-equivariant rational map `P(W)⇢X`; a nonzero landing covariant in *any* degree; a primitive landing covariant mod `k^×`; a `K_proj`-point of the explicit 35-coefficient cubic `V(Φ)⊂P⁴`); (ii) `G3A-ARITHMETIC-DOMINANCE-PASS` ⇒ `G3-DOMINANCE-AUTOMATIC`, that any exact `K_proj`-point automatically gives a dominant equivariant map with no separate Jacobian-rank-4 gate.
- **Why load-bearing:** every currently live route ([E08](#e08), [E17](#e17), [E18](#e18), [E24](#e24), [E33](#e33)) is aimed at "find a point of `V(Φ)`" *because of* this reduction. If the equivalence or the dominance step is wrong, the whole current strategy targets the wrong object. Note that `github-repo-task-update-6a7054fb.md` explicitly recorded the dominance argument as **unproven at the time it wrote it** ("should be made binding by G3"), and only a later session sealed it.
- **Where it lives:** `goal_runs_after_35fa/G_UNIVERSAL/` (`ALL_DEGREE_THEOREM.md`, `UNIVERSAL_OBJECT.md`, `NOETHERIANITY.md`, `theorem.json`); `goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/`. Upstream source `goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json`, blob `965abb5`.
- **What verification looks like:** (a) execute the upstream replay that re-derives the 35-coefficient `generic_cubic.json` from the original Klein equation — `finish-g-g2-theorem-6a705522.md` states this was "installed but not executed"; (b) an independent proof check of the degree-clearing equivalence `F(p)=h³Φ(a)` in both directions (the session checked it only with a small symbolic degree-arithmetic script); (c) a written proof of the dominance step from `G` simple + `ed_C(G)≥3` + image 3-dimensional, cross-checked against the sealed `G3A` packet.

### 3. `B-BRIDGE-REFUTED`'s finite-automorphism citation

- **Claim under test:** that `Γ_eff = ` the effective image of `Γ=PGU(h_struct)∩Stab_{PGL_3(D)}(H_T)` in `Aut(Y_K̄)` is **finite**, via Kuznetsov–Prokhorov–Shramov Thm 1.1.2 for Picard-rank-1 genus-8 prime Fano threefolds.
- **Why load-bearing:** it is the sole engine of a **headline-load-bearing negative result** that retired an entire route and demoted T3 and the fixed-frame arithmetic to non-headline. If the citation does not apply to this specific `Y`, `B-BRIDGE-REFUTED` collapses and the fixed-frame programme returns.
- **Where it lives:** `goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/`; session `task-b-in-repo-6a70554b.md` (commit `5899d05`). The derivation is largely behind redacted tool output.
- **What verification looks like:** (i) re-derive `Γ_eff` finiteness directly; (ii) independently confirm that `Y=F_{14,T}` is a Picard-rank-1 genus-8 prime Fano threefold **not** among KPS's infinite-automorphism exceptions; (iii) check that the refutation is scoped to the fixed-frame bridge and does not silently undermine other in-repo claims resting on the same `Σ`/`Γ` construction. The session flags this as directly relevant to the standing "good-line deviation" concern (a hardcoded line `L` where the source proof chooses it generically) and asks for that cross-check specifically.

### 4. The G7B invalidation — confirm the repo quarantine actually happened — **RESOLVED (confirmed 2026-08-03)**

- **Claim under test:** `mattrobball-unirational-task-6a7054e2.md` declares `G7-INDUCED-DOUBLE-CYCLE-PASS` and `G7-PROJECTIVE-SCALING-PASS` **INVALID** by independent recomputation (`|Stab_G([e0])|=11`, `|G·[e0]|=60` ⇒ `[e0]` fixed by neither maximal A5; 44/44 generator-point equivariance checks failed; the "cycle" is representative-dependent).
- **Why load-bearing:** an invalid PASS left standing in the repo will be consumed by later routes as an established induced cycle. The session dispatched only a quarantine *order* (G3H.0) — it did not itself quarantine.
- **Where it lives:** `goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/`; the G7B directory; goal file pushed at `3aa13c6`.
- **What verification looks like:** re-run the stabilizer computation in the certified 660-element model ([E38](#e38)); then confirm the G7B packet's `STATUS.md` was actually corrected or quarantined downstream rather than left contradicting the audit. Separately re-check `G7-CROSS-CLASS-PROJECTOR-PASS`'s module decomposition (`1⊕V10` with `V10` absolutely irreducible, not `1⊕V5⊕V5'`).
- **Resolution (confirmed 2026-08-03):** the invalidation is already fixed in-repo. Commit `4a5beac` (2026-08-02 14:54, ~2h after the flawed packet at `eb21458`) rewrote `goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/STATUS.md`: primary exit is now `G7-PROJECTIVE-SCALING-PASS` (re-derived by an independent chart-normalization/cone-lift method), the induced-cycle claim is downgraded to RESIDUAL, refutation marker `G7B-INDUCED-CYCLE-REFUTED` is installed, the defect is documented in `cycles/INDUCED_CYCLE_REFUTATION.md` (`|Stab_G([e0])|=11`, `|G·[e0]|=60`, 44/44 equivariance checks failed), the withdrawn data is quarantined as `cycles/cycles_WITHDRAWN_rho_e0.json`, and the verifier is hardened (`verify_cycles.py` + `cycles/audit_induced_refutation.py`). See [E17](#e17).

### 5. V3's char-67 → char-0 transfer

- **Claim under test:** `V-F5-DEGREE16-SUPPORT-LE5-EMPTY` — all 11,628 size-≤5 coefficient supports among 19 variables (151 independent equations mod 67) are projectively empty, therefore any degree-16 landing survivor for `f5=0` needs ≥6 nonzero coefficients **in characteristic zero**.
- **Why load-bearing:** the payload itself scopes the result to "necessary sampled landing equations at the good prime; projective special-fibre emptiness excludes the corresponding characteristic-zero support stratum". Per Binding rule 2 the char-0 conclusion needs an explicit bridge. This is the same modular-to-char-0 gap that blocks [E09](#e09) and [E25](#e25).
- **Where it lives:** `goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/`; markers `V_F5_DEGREE16_SMALL_SUPPORT_FULL_OK`.
- **What verification looks like:** write out the specialization/lifting argument (good-reduction hypotheses, flatness of the relevant family, why special-fibre emptiness excludes the char-0 stratum) and re-run the linear algebra with an independent tool — the session had **no CAS available** and hand-rolled all `F_p` linear algebra in Python/numpy with no cross-check. Also re-check the residue-normal-form theorem's structural claims (decomposition-group restriction, Abhyankar rank-2 conditions), which build on prior repo state not re-derived in the transcript.

### 6. κ± Weil values and the V4 trisection counterexample

- **Claim under test:** the exact Weil-representation values `κ± = (13±3√33)/16`; the genus-2 smoothness claim (resultant `64(κ₊−κ₋)³≠0`) for `C: y²=(κ₊t³+κ₋)((κ₊+4)t³+κ₋+4)`; the `M1-TRIPLE-ORDER3-ALL-LINE-DEGREE-EMPTY` factorization; and the explicit trisection counterexample family (`κ=(B³−1)²/B³`, landing identity `κw³+w(u0²+u1²+u2²)+u0u1u2=0`).
- **Why load-bearing:** `κ±` underpins both the emptiness theorem and the genus-2/degree-25 corollary, while the counterexample family is the sole reason `V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED` was declared and the whole local strategy abandoned. If the counterexample is wrong, a live negative route was abandoned prematurely.
- **Where it lives:** `goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/` (`THEOREM.md`, `GENUS2_QUOTIENT.md`, `DEGREE25_COROLLARY.md`, `verify.py`, `verify_kappa_genus2.py`); commits `04d1d1c`, `bc56247`, `ebb5769`, `fb4bcea`, `08859c0`, `72147bd`.
- **What verification looks like:** re-derive `κ±` from the certified Weil representation ([E38](#e38)); actually run `verify_kappa_genus2.py` (the reviewing session described the replay but did not re-run it independently); recompute the resultant and the counterexample family's landing identity symbolically. **Also resolve the `DEGREE25-LANDING-EMPTY` vs [E25](#e25) tension** — see conflict 13.
- **Verified scoping (adjudicated 2026-08-03):** `DEGREE25_COROLLARY.md` proves only the order-three branch of the degree-25 filtration — but it proves it **in characteristic zero for all line degrees** (Theorem 2.12, scoped to `A4`-equivariant, `m=1` involution-plane order, exact triple-line order three). The order-two and order-≥4 branches are **independently audited but modular-only** (split fibre `F_67`; the from-scratch audit rebuilt the complete degree-25 space, both jet filtrations, the 56/56 landing span and the 3124/3124 overlap rank — `HANDOFF.md` ~1061–1066), *not* "inherited unverified" as previously written. What they lack is a characteristic-zero bridge, so the exit label `DEGREE25-LANDING-EMPTY` overstates its char-0 scope. The corollary's own text: "It is not an all-degree theorem and does not settle equivariant unirationality." See [E25](#e25) and conflict 13.

### 7. M3 full replay never executed

- **Claim under test:** `M3-INTEGRAL-DEGREE4-MULTISECTION` as an *unconditional* both-branch result (no-section branch via a point-or-degree-4 theorem; section branch via a cyclic quartic extension plus Weil restriction of Kollár unirationality).
- **Why load-bearing:** it is the terminal exit for [E24](#e24) and it defines the residual dichotomy (section ⟺ imprimitive quartic) that the remaining Galois-descent route is built on. The session itself states "The complete repository-level M3 replay was not executed in this environment" — it checked only Python syntax, JSON validity, absence of merge markers, and SHA-256 against `SEAL.json`.
- **Where it lives:** `goals_after_bd610a/M3_SARKISOV_SECTION/`; merge commit `96195e8` (PR #6).
- **What verification looks like:** run `verify_all.py` against `SEAL.json` in-repo end to end; confirm current `main` is genuinely free of merge-conflict artifacts and that seal hashes are internally consistent (the session only partially checked this after its own repair); spot-check the early-exploration claims that underlie the "unconditional" framing — 1,485 secants checked, a smooth 4-dimensional degree-3 component, and the index-4 subfield exclusion.

### 8. External-literature citations from in-session web search

**Partial retirement 2026-08-06:** the CTZ sub-claim ("still lists the
Klein `PSL_2(F_11)` action as an open exceptional case") is VERIFIED from
the archived arXiv:2502.19598 PDF (Thm 5.1 exception list; E56 wave 26;
E51 date reconciliation — the "2026-07-18"/"March-2026" artifacts are
this same Feb-2025 paper). The remaining sub-claims below stand as debt.

- **Claim under test:** all literature assertions produced by ChatGPT web search with connector citations, including: the Cheltsov–Tschinkel–Zhang classification "still lists the Klein `PSL_2(F_11)` action as an open exceptional case"; a "`G`-birationally superrigid" theorem for the Klein cubic; essential-dimension results for Frobenius groups; Jodi Black arXiv 1009.4621 and Gordon-Sarney–Suresh 1702.00516 hypotheses; Kuznetsov–Prokhorov–Shramov Thm 1.1.2.
- **Why load-bearing:** these carry real hallucination risk and are used both to justify routes (E27's Theorem 5.1, E06's refutation) and to conclude that the headline is *not* already settled in the literature. A fabricated or misapplied citation could either invalidate a sealed result or hide an existing resolution.
- **Where it lives:** `github-repo-task-update-6a7054fb.md`, `repo-push-request-6a705556.md`, `task-b-in-repo-6a70554b.md`, `klein-cubic-threefold-psl-6a6b6514.md`; downstream in [E06](#e06), [E27](#e27), [E51](#e51).
- **What verification looks like:** pull each cited paper from arXiv/publisher, confirm the theorem number and statement, and check hypothesis-matching against the specific objects used (for Black: no `E_8` factor, quasisplit outside `G_2`; for KPS: the exact Fano class).

### 9. `L1-FULL-RANGE-PASS` recursion correctness

- **Claim:** the universal coefficient recursion for `F(p)` over all odd initial normal orders `m` and degrees `d≥m` through terminal order `3d`, with even-`δ` vanishing by involution parity, odd `δ≤q` isolation equations, odd `δ>q` terminal compatibility equations.
- **Why load-bearing:** it completes the polar range for the Path G lifting tower; every all-degree lifting statement above the old `3m+3` boundary rests on it. Computed with no external CAS.
- **Where:** `goal_runs_after_7030dd/L1_FULL_POLAR_RANGE/` (`produce.py`, `verify.py`, `SEAL.json`); commit `82de03d`.
- **Verification:** re-derive the recursion independently and re-run `produce.py`/`verify.py` with an exact CAS rather than `fractions.Fraction` alone.

### 10. A4 / A5 exact rational points

- **Claim:** the generic `A4` twist and both maximal `A5` generic twists carry exact rational points via corrected degree-3/degree-11 Reynolds covariants; the prior A4 emptiness computation was invalid due to a **wrong transpose convention**.
- **Why load-bearing:** these close all three maximal-subgroup obstructions ([E11](#e11)), permanently removing the cheapest negative route. A transpose-convention error once already produced the opposite answer here.
- **Where:** `goal_runs_after_35fa/H_A4_TWIST/H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/`, `goal_runs_after_35fa/H_A5_TWISTS/`; commit `08859c0`; session `progress-on-klein-cubic-6a705563.md`.
- **Verification:** re-derive the corrected maps in the certified action and substitute into `F` exactly; confirm the transpose convention against `certificates/exact_weil_check.py`.

### 11. Q-packet mathematical inputs

- **Claims:** existence of the degree-3 and degree-55 **effective** closed points on the Schur twist (inherited from prior "installed ledger" work, not re-derived); smoothness of the *specific* twist `X` (needed for `π₁^et=1` via Lefschetz — smoothness of the original Klein cubic is not enough); correct matching of Jodi Black's hypotheses to the torsors excluded.
- **Why load-bearing:** Theorems 2.1–5.1 of [E27](#e27) all rest on the coprime degrees 3 and 55 and on the étale-triviality argument.
- **Where:** `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802/`.
- **Verification:** locate and re-check the degree-3 and degree-55 point constructions in-repo; prove smoothness of the twist; hypothesis-match Black's theorem.

### 12. Hodge-center refinement inputs

- **Claims:** `J(X)≅E₋₁₁⁵` (Roulleau, CM) and `E_t` non-CM with `j=8192/11`; `H^{1,0}(E_t)≅sgn` under the residual `S3`; the triviality of the global equivariant IJ-torsor via `z=Σ[L_t]−18h²`.
- **Why load-bearing:** they are the basis of the claimed strengthening of [E19](#e19) ("the 55 fixed elliptics cannot supply `H^{2,1}(X)`"), and of the conclusion that the character-valued Jacobian obstruction does not kill the first live family.
- **Where:** session `mathematical-equivariance-query-6a70557e.md`; `certificates/hodge_centers/`.
- **Verification:** re-derive the CM claim and the `j`-invariant; recompute the `S3`-character of `H^{1,0}(E_t)`; confirm the degree-1 invariant cycle.

### 13. Degree-exclusion and covariant-module computations

- **Claims:** per-degree exclusions for 22–24 ("unit ideal on all charts", computational); ~~the P25 quartic-membership counts 4140/315~~ (**RESOLVED**, see below); the COV zero-module claims for `(d,m,e)=(25,3,7),(31,5,1),(35,5,5)`.
- **Why load-bearing:** the degree ladder of [E16](#e16) and the "degree 25 is first open" framing rest on them, as does the reduction of degrees 25/31/35 to the `m=1` case.
- **Where:** `tmp/degree22_compression`, `degree23_common_line_landing`, `degree24_landing` (all untracked local scratch, Binding rule 5); `goal_runs_after_35fa/A0_CANONICAL_AUDIT`; `goal_runs_after_35fa/COV_M1_DEG31_35`.
- **4140/315 sub-claim — RESOLVED 2026-08-03.** A0 **does** recompute these independently, contrary to the external session's self-flag and to a later review's proposal to downgrade A0 to packet-consistency-only. `verify_p25_bulk_projection.c` rebuilds `π(G)` and all 4140+315 test vectors from sealed, hash-cross-checked binary inputs and recomputes membership by random sparse projection + FLINT RREF over `F_89`; `verify_p25_bulk_projection_result.json` records `reads_4140_from_json: false`, and the expected values are hardcoded pass literals compared against runtime-computed figures. The real defect — the stock `verify_p25v0.py` asserting JSON fields only — was found and repaired **by A0 itself** (`VERIFIER_REPLAY.md`:33–35). See [E02](#e02).
- **Verification (remaining):** re-run the chart computations for 22–24; re-derive the three zero-module claims. The invalid exit label `COV-STRUCTURED-DEGREES-EMPTY-SCOPED` has been **retired** — `goal_runs_after_35fa/A0_CANONICAL_AUDIT/CANONICAL_STATE.md`:42 repairs it to `COV-HIGHER-ORDER-BRANCHES-EMPTY-SCOPED` (higher-order-branch emptiness only); see [E09](#e09) and Goal-wave worker roots, COV caveat. This item is done, not open.

### 14. Was T3.0–T3.5 ever executed?

- **Claim (as landed by `t3-normalization-push-6a70553b.md`):** none there — that
  session's `T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER` push was planning documents
  only, and the session's own text states no T3 workflow existed on `main` at
  that time.
- **Correction (2026-08-03 goal-wave sweep):** read as a global statement —
  "T3 was never executed" — this is **false**. `goals_after_bd610a/scratch_t3`,
  a separate worker root unrelated to the `t3-normalization-push` session,
  contains an actually-executed T3 fixed-frame computation: an exact
  discriminant constructed and factored, with the plane boundary `A=15, Y=12`
  certified to have contact order two and one generic ordinary node (`Δ_cub`
  irreducible of degree 15 over `Q(ζ₁₁)`, 719 terms), markers
  `T3_FIXED_FRAME_DISCRIMINANT_DISCOVERY_DONE` and
  `T3_DISC_PLANE_GENERIC_ONE_ORDINARY_NODE`. The correct statement is: **no
  promoted T3 packet exists** — no synthesized `STATUS.md`/verifier packet
  carries this result forward into [E32](#e32)'s canonical record — but an
  executed worker-root computation exists **unpromoted** in `scratch_t3`.
- **Why load-bearing:** "T3" must not be treated as touched in any substantive
  way *without this qualification*; and after `B-BRIDGE-REFUTED` a successful
  T3 would prove only the fixed-frame index-three theorem, not the headline —
  the `scratch_t3` result, if verified and promoted, would still only bear on
  that non-headline theorem.
- **Where:** `goals_after_5899d0/T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER/`
  (planning-only push; commit `b49fc81`); `goals_after_bd610a/scratch_t3/`
  (executed, unpromoted computation — see [E32](#e32) and Goal-wave worker
  roots).
- **Verification:** re-derive the `scratch_t3` discriminant computation and
  its node/contact-order claim independently; check whether any later run
  directory carries a T3 exit label built on it; then promote into a portable
  packet or retire (Verification debt item 20).

### 15. Off-problem theorems asserted by planning sessions

- **Claims:** OD16 Type-II on the Fermat degree-2 del Pezzo and C9⋊C3 on the Fermat cubic threefold are not weakly versal / not unirational; the "rational-chain going-down principle"; the assertion that the repo's PSL(2,7) result is "the all-degree V4-exceptional-path obstruction"; the assertion that the Klein involution fixed locus contains **both** a rational line and an elliptic curve.
- **Why load-bearing:** the last of these is the stated reason the cheap fixed-divisor test fails for Problem E and therefore why the full stratification machinery ([E34](#e34)) is required. The OD16/C9⋊C3 "theorems" were never machine-checked (Priority-0 checkers unimplemented) and one session's own text is internally inconsistent about whether C9⋊C3 is closed.
- **Where:** sessions `klein-cubic-threefold-psl-6a6b6514.md`, `g-equivariant-rational-maps-6a70559f.md`, `mathematical-machine-implementation-6a7055b7.md` — **none pushed anything to the repo**.
- **RETIRED-WITH-CORRECTIONS (2026-08-04, [E56](#e56)):** all four claims are now settled in-repo. The Klein involution fixed-locus claim: VERIFIED exactly (`FIX-A0-ARRANGEMENT-PASS` — `X^σ = E_σ ⊔ L_σ`). The going-down principle: PROVED (`theory/FIX_I_bcomplex.md` Lem 4.2). The OD16/C9⋊C3 theorems: now corollaries of the central obstruction (`theory/FIX_T_gate.md` Cor T3.1) with hypotheses machine-verified by `FIX-T34-CENTRAL-HYPOTHESES-PASS` — **but corrected**: they hold for named conjugacy classes only (13/17 order-16 classes on the dP2; 2/3 `C₉⋊C₃`-classes on the Fermat cubic), the deck-curve genus is 3 not 1, `Fix(z,P⁴) = P²⊔P¹` not `P²⊔pt⊔pt`, and the naive `C₉⋊C₃` generator (class T4-C03) actually FAILS `X^G = ∅` — the sessions' displayed instantiation was false as stated. The PSL(2,7)-characterization assertion: VERIFIED by gate item T2 (2026-08-04) — the source proof ingested, its checker director-replayed (`WP3_ALL_DEGREE_PATH_OBSTRUCTION_OK`), and the argument re-derived as chain-level unsolvability (`theory/FIX_T_gate.md` Thm T2.3, via the scalar-birth and `V₄`-chain lemmas T2.1/T2.2). Debt item 15 is now fully retired.

### 16. Ledger-vs-artifact conflicts inherited from the canonical ledger

Each of conflicts 1–12 in the next section is verification debt in its own right.
The three with headline consequences are: **T-track terminality** (the 08-02 ledger
says `TERMINAL`, `REPAIR.md` holds the T2R gate pending — resolve by exiting T2R);
**KLS terminality** (ledger says `TERMINAL`, `CURRENT_PATHS.md` lists open branches
— resolve by deciding whether the framework is authorized); and the **`certificates/elliptic_lifting` ownership**
question. (That last one no longer bears on whether [E28](#e28)'s exit has mathematical
content — the R/R2 theorem was recovered from the packet on 2026-08-03 — but it still
determines which route owns the certificate.)

### 17. G3D `STATUS.md` phase-ledger bug — an invalid `PASS` pair left standing in a sealed packet

- **Defect (adjudicated 2026-08-03, not merely alleged):** in `goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC/STATUS.md`, the embedded phase-ledger JSON block (lines ~44–56) marks the witt and spinor phases `G3D-POLAR-CLIFFORD-PASS` and `G3D-SPINOR-DISCRIMINANT-PASS`. This contradicts the same file's own prose (line ~5), `SEAL.json`, and every stage document, all of which read `*-PARTIAL`.
- **Why load-bearing:** it is exactly the failure mode of debt item 4 (G7B) — a machine-readable `PASS` that a later route can consume as established. Any tool reading the JSON block rather than the prose gets the wrong answer about the Clifford and spinor-discriminant stages of [E17](#e17).
- **Governing artifact:** **`SEAL.json`.** Canonical state: simple-field model, polar cubic surface, Hessian-kernel and cube reduction are structural passes at scope; Clifford, spinor discriminant and the 27-line algebra are **PARTIAL**; exit `G3D-UNDECIDED`.
- **Why it is not fixed in place:** the packet is hash-sealed, so editing `STATUS.md` would break the seal. The correction is recorded here and in [E17](#e17) instead.
- **What resolution looks like:** either re-seal the packet with a corrected phase ledger, or add a machine-readable erratum next to `SEAL.json` that consumers are required to read. Until then, treat the JSON block as unreliable for this packet.

### 18. Two branch-only packets are unverified from `main`

- **Claim under test:** the branch-only packets recorded in [E17](#e17)
  (`goal_runs_after_eb21458/G3P_A5_SEMILINEAR_QUADRATIC/`, branch
  `agent/g3p-a5-semilinear-20260802`) and [E24](#e24)
  (`goal_runs_after_bd610a/M3_SARKISOV_SECTION/`, branch
  `agent/m3-sarkisov-section-residual`).
- **Why load-bearing:** both packets carry real theorem content (the G3P
  A5-semilinear formula-level materialization and canonical-polar miss; the
  M3-SECTION-COMPONENT-PASS proofs about `C_012`, the no-line/no-conic
  theorems, and the no-quartic-subfield result) that is not checkable from a
  `main`-only checkout, since the packets do not exist there.
- **Where it lives:** both packets' content remains unmerged into main's
  canonical run trees, but both are now referenced by NOTEBOOK.md and
  manifest.json and archived as immutable snapshots under `external_packets/`
  (pinned heads `086e08928bd3a0d360018e6f809739517f72702e`,
  `6fdac74fc2c850dd062288691bf6daba5ec0228d`).
- **Verifier findings (2026-08-03):** the G3P snapshot contains NO verify
  script at any level — narrative and data only. The M3 snapshot's
  packet-level orchestrator `verify_all.py` calls `verify_section_search.py`
  against `section_search_payload.json` — neither exists in the snapshot —
  so its `M3-SECTION-COMPONENT-PASS` exit is asserted via JSON field reads
  only (the genuine recompute in `verify_residual_galois.py` covers only the
  group-theoretic part).
- **What verification looks like:** replay requires checking out the branch
  directly (`git checkout agent/g3p-a5-semilinear-20260802` /
  `agent/m3-sarkisov-section-residual`) and re-running each packet's
  verifier — the archived `external_packets/` snapshots are read-only
  references, not a substitute for that replay. A merge-or-retire decision
  is pending for both branches — until one is made, treat both packets as
  local-to-branch, not repository state.

### 19. Load-bearing `tmp/`-only results are not portable

- **Claim under test:** several load-bearing route results have no evidence
  outside untracked `tmp/` scratch (Binding rule 5), so they are auditable
  only on the machine holding the scratch tree, not from a fresh `main`
  checkout.
- **Why load-bearing:** [E37](#e37)'s essential-dimension reduction cites
  `tmp/step4_essential_dimension/` as replay support for a theorem otherwise
  proved in `RESOLUTION.md`; the xCD ([E35](#e35), 29 `tmp/xcd_*`
  directories), Fable ([E15](#e15), ~20 `tmp/fable_*` directories), KLS
  ([E22](#e22), ~25 `tmp/kls_*` directories), and degree-22–25 exclusion
  report trees ([E16](#e16)/[E25](#e25), `tmp/degree{22,23,24}_*`,
  `tmp/m1_*`) are entirely `tmp/`-only or largely so.
- **What resolution looks like:** promote these into portable packets under
  `certificates/` or `goal_runs_*/` with a checked-in verifier, following the
  pattern already used for the routes that graduated out of `tmp/`. Until
  then, treat these attempts' evidence as local-only and unauditable from the
  pushed repository.

### 20. The 7 UNPROMOTED-RESULT worker roots need verify-and-promote-or-retire

- **Claim under test:** the 2026-08-03 goal-wave disposition sweep
  (`## Goal-wave worker roots`) found 7 of the 43 flagged worker roots
  contain an executed computation with a specific claim absent from every
  packet and every entry: `goals_after_bd610a/A5Q_QUARTIC_RESCUE_WORK`
  ([E04](#e04)); `goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3`
  ([E07](#e07)/[E08](#e08)); `goals_after_bd610a/P25_COV_SUPPORT`
  ([E09](#e09)/[E25](#e25)); `goals_2026-08-01/H_SUBGROUP_TWISTS_CODEX_ROOT_20260801`
  ([E11](#e11)); `goals_2026-08-01/G_ALL_DEGREE_ROOT_20260801` ([E16](#e16));
  `goals_2026-08-01/R_RATIONAL_CURVES_ROOT_JACOBIAN_ZERO` ([E28](#e28));
  `goals_after_bd610a/scratch_t3` ([E32](#e32)).
- **Why load-bearing:** each of these is worker-root evidence only (Binding
  rule 4) — none has a synthesized `STATUS.md`, verifier, or seal, and none
  has been independently re-derived. Several would strengthen an existing
  entry's scope if verified (e.g. [E11](#e11)'s completeness claim), and
  `scratch_t3` corrects a standing notebook error (Verification debt item
  14) about T3 execution status.
- **What resolution looks like:** for each of the 7, either (a) re-derive the
  claim independently and promote it into a portable packet under
  `certificates/` or `goal_runs_*/` with a checked-in verifier, folding the
  result into its owning entry above, or (b) retire it — record why the
  claim does not hold or is out of scope. Until one or the other happens,
  none of these 7 claims may move any entry's headline-relevant status.

### 21. FIX-H1/FIX-C1 open residue (2026-08-05) — adopted live runs and unrun upgrades
(renumbered 2026-08-06 from a duplicate "20")

- **Adopted live computations** (worker-detached processes running inside
  the sealed FIX-H1 packet's `msolve/`, `m2/`, `logs/` at integration time;
  director monitors, integrates on completion as amendments): the six hard
  `(1,8)` line-degree-0 leaves (`pl_r8_{one,om,om2}_{B_43,D_41}_qq` — the
  only gap between `FIX-H1-HOLE-1EVEN-PARTIAL` and a full `(1,8)`-`n=0`
  verdict — plus one mod-`p` retry `hardp_r8_one_D`), and the `(1,6)`
  line-degree-6 modular run (`ld_n6_om_1_T3_C2_0`). The packet's `msolve/`
  bulk (~13k regenerable `.ms`/`.out`, 545M) is untracked by design
  (in-packet `.gitignore` with rationale); `logs/` are untracked by the
  repo-wide `*.log` convention (regenerable by replay, like every packet);
  the tracked evidence layer is `payloads/` (incl. `HOLES_REPORT.md` and
  the per-part transcripts), scripts, verifier, `STATUS.md`/`REPLAY.md`.
- **Specified but unrun:** the char-0 upgrade of the `(1,6)` `n = 3,4,5`
  mod-`p` findings (4 runs per `(n,λ)` over `QQ` with minimal polynomials
  adjoined — H1 packet §6b); `(1, r=10)` four-strata completion; the
  stabilisation-in-`n` theorem for `(1,6)` (structural leads recorded in
  `HOLES_REPORT.md` §5.4); the deeper-layer equalizer for the H1-C
  `n₃`-divisible sub-family; C1's part-D level 3, levels ≥ 4, part-A level 3
  on `{ℓ₀ = 0}`, and the exact `ℓ₀` for the `λ = ω, ω²` blocks
  (structure exact via M2; two-prime reconstruction did not stabilise).
- **Internal supersession inside the sealed H1 packet:** `HOLES_REPORT.md`
  §3 (written during an interim clean-EMPTY reading of `(1,8)`) is
  superseded by `STATUS.md` §6a (282/288 + six undecided); the packet
  records this itself; `logs/M2PASS_R8.log` ends in a `BrokenPipeError`
  (driver crash, not mathematical) so only 40 of the 288 leaves carry an
  M2 verdict on top of the msolve/QQ + sympy pair — zero disagreements
  anywhere.
- **Why load-bearing:** these are exactly the items separating the current
  `PARTIAL` verdicts from decided ones; Binding rule 1 (a hole is a hole)
  applies until each lands with a replayed verifier.
- **Update 2026-08-05 (FIX-H2):** the six hard `(1,8)` leaves are DECIDED
  (msolve/QQ unit ideal ×6; each run individually char-0-complete);
  remaining on this item: the five outstanding M2 second-engine
  confirmations (`run_m2_final.py` adopted live — on completion the exit
  upgrades `-MSOLVE-EMPTY → -EMPTY` in an amendment commit); `(1,6)`
  `n = 3` closed char-0; `n = 4, 5` CPU-pending (systems built and
  validated in the H2 packet); `(1, r = 10)` = one command on the same
  pipeline; the `(1,6)` `n = 6` modular sweep still live (~2 days at
  measured rate); stabilisation-in-`n` and all positive-line-degree
  cells unchanged. New M2 landmines (underscore variables parsed as
  indexed subscripts; `saturate(I,{f,g})` successive) recorded in the
  toolchain memory alongside the msolve pair.

### 22. Wave-28 residue (2026-08-06): seal disposition and in-flight adoptions

- **Note IX §5 sealing assignments — RESOLVED SAME DAY** by the
  director-run packet `goal_runs_after_c53d89a/FIX_IX_SEAL`
  (`FIX-IX-SEAL-PASS`): sextic smoothness, both-primes + char-0
  exactness of (a)/(b), ambient smooth/dim-3/deg-14, Klein-Pfaffian
  identification. Recorded here so the assignment→discharge pair is
  auditable. Residue CLOSED same day: the direct char-0
  Jacobian-minors run completed (36 min) — SIGPLUS and SIGMINUS both
  `smooth true` over `Q(ζ₁₁)` (`results/m2_sigma_K.out`); hypothesis
  (a) is now char-0-certified both a priori and directly.
- **Cited-not-recomputed layer of Cor IX.1:** the Note I lemmas
  (Thm 2.1, Lem 4.2/4.3, Prop 3.3/equivariant resolution) — gate-audited
  (T1–T5) but the planned independent Note-review was never done; IX.1's
  proof consumes them. Any external use of the V₁₄ theorem should cite
  this dependency explicitly.
- **Worker-grade inputs awaiting their packet:** the FIX-IX-V14MODEL
  in-flight data used narratively in Note IX §8 (stab-exactly-C₁₁ on the
  5 C₁₁-points ⟹ `V₁₄^{F55} = ∅`) and the A5LADDER interim (cones empty
  through d = 7; "cplus" candidate mid-verification). Neither is
  load-bearing for IX.1/IX.2; both must be sealed or retired when the
  workers return (worker-return write-race discipline: wait for quiesce).
- **Pre-registered blind test:** IX.1 ⟹ V14MODEL stage-4 ladder EMPTY at
  all degrees — check on landing; a verified hit reopens this item as a
  contradiction to resolve.

---
