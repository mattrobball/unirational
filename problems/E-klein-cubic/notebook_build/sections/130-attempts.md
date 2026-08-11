## Attempts

The 56 records below span nine types — construction, obstruction, reduction, bounded
computation, infrastructure, audit/repair, dispatch/process, conditional implication,
proposal/unrun — recorded per entry on the **Record type:** line. Entries with
substantial run or certificate provenance also carry a **Verification class:** line
sourced from `notebook_build/verifier_depth.md`.

Lens abbreviations in status citations: **DIR** directories, **GIT** gitlog,
**CERT** certificates, **HAND** handoff, **RES** resolution/spec, **STAT** status
docs, **WORK** workorders. "08-02 ledger" = `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`
(offline-ChatGPT-produced; outranked by `REPAIR.md` and run-level `STATUS.md`).

<a id="e01"></a>
### E01 — A — Path A: Schur–Krylov degree-55 field algebra / P¹-reduction / index-34 duality

- **Target:** positive construction — install an executable degree-55 field-algebra / marked-point interface on the generic Schur twist (monogenic schema `B_34(τ,V_Z)`, rank-55 maximal-minor matrix, "index-34 duality", a `P¹`-reduction theorem), yielding an algebra-code pair `(L,V_Z)` from which a rational point / landing construction could be extracted.
- **Justification:** A marked closed point of degree 55 with an executable field-algebra presentation would let the `P¹`-reduction convert index data into an actual `K_proj`-point of the generic Schur twist, which by E37 closes the headline positively.
- **Method:** mixed (CAS elimination + structural algebra)
- **Record type:** construction
- **Thread:** T5 — Schur-source and curve constructions
- **Verification class:** `certificates/schur_krylov` PARTIAL-RECOMPUTE.
- **Status:** UNDECIDED-STOPPED — the `P¹`-reduction and index-34 duality survive the repair; the executable `(L,V_Z)` extraction is only an abstract interface and the direct 52-variable Krylov elimination is computationally retired.
  - PRE-REPAIR: "some 55×55 minor is nonzero at every primitive tau" (single global minor claim); A2 packet described as having installed "exact generic coordinates" [STAT, `REPAIR.md` §§9–10]
  - POST-REPAIR: quantifier corrected to `∀τ ∃M_τ: M_τ(τ)≠0`, i.e. the ideal of **all** maximal minors, `V(I_55(B_34))∩U_primitive=∅` [STAT/`REPAIR.md` §9]
  - POST-REPAIR: "Path A executable L,V_Z claim — downgraded to an abstract interface" [HAND `R13`, RES `RES-27`]
  - POST-REPAIR retained: "Path A P¹-reduction — retained"; "Path A index-34 duality — retained" [HAND `R13`, RES `RES-27`, STAT]
  - "A2 downgraded to abstract degree-55 algebra and marked-evaluation interface installed; exact executable marked algebra-code pair (L,V_Z) **not installed** — superseded by packet `A_EMPTY_UNDECIDED`" [STAT/`REPAIR.md` §10]
  - GIT: `9bee33a` "Path A statement A_empty"; `3c9b385` "A_empty attack — exit `A_EMPTY_UNDECIDED`"; `cdc016b` "Path A Gates A1-A3 — A1 PASS"; `4baad2f` "Path A collapse audit — no lossless collapse"
  - WORK: "Path A is computationally stopped in its current form... No memory increase changes that"; "Do not restart primitive-element/Krylov elimination"
- **What was actually established:** the `P¹`-reduction theorem and the index-34 duality are retained post-repair; the maximal-minor nonvanishing holds in the corrected `∀τ ∃M_τ` form. NOT established: an executable `(L,V_Z)` pair, any rational point, or emptiness — `A_EMPTY` exited `A_EMPTY_UNDECIDED`.
- **Aliases:** Path A; A1/A2/A3 gates; `A_EMPTY` / `A_EMPTY_UNDECIDED`; HAND `R13`; RES `RES-27`; CERT bucket `A — A, A-DEG19`; WORK folds this into `S19-Krylov` (Attempt 3 / Path A Krylov / Route S19)
- **Provenance:** A1–A3 gates (`cdc016b`); collapse audit (`4baad2f`); A2 packet; `A_EMPTY`/`A_EMPTY_UNDECIDED`; `certificates/schur_krylov/{orbit_code, field_algebra, marked_point, krylov_incidence, structural_collapse, vz_power_basis, P1_REDUCTION}`; Path A A0–A4 low-degree block-Krylov growth theorem (POST_ELO, after elimination retired). `WORKORDER_ELO_TEN_PATHS.md` (Path A, ranked #1); `WORKORDER_POST_ELO_CONSTRUCTION.md`.
- **Pointers:** `REPAIR.md` §§9–10, §§15–17; `certificates/schur_krylov/`; `HANDOFF.md` 2026-07-31 repair tables; `RESOLUTION.md`/`SPEC.md` repair tables; `CURRENT_PATHS.md`
- *Lenses 6/7 (GIT, CERT, HAND, RES, STAT, WORK); confidence high. Possibly-same-as [E30](#e30) — kept separate.*

---

<a id="e02"></a>
### E02 — A0 — Canonical audit / CAS baseline

- **Target:** infrastructure — certify the baseline exact 660-element `PSL(2,11)` action, Klein-cubic invariance, and the "projection bulk 4140/315" figures as a replayable checked-in certificate package; verify authoritative P25 nonmembership counts and canonical state.
- **Justification:** Every downstream route computes inside this action and these counts; an error here would silently invalidate the whole ledger. It is a precondition, not a route.
- **Method:** CAS
- **Record type:** infrastructure
- **Thread:** T8 — process and audits
- **Verification class:** ALGEBRAIC-RECOMPUTE — `verify_p25_bulk_projection.c` independently rebuilds `π(G)` and all 4140+315 test vectors from sealed, hash-cross-checked binary inputs and recomputes membership by random sparse projection + FLINT RREF over `F_89` (`reads_4140_from_json: false`; expected values are hardcoded pass literals, freshly computed at runtime).
- **Status:** TERMINAL-PASS (infrastructure only; not a mathematical route).
  - `A0-CANONICAL-AUDIT-PASS` [DIR, `goal_runs_after_35fa/A0_CANONICAL_AUDIT/STATUS.md`; also WORK/`REMAINING_GOALS_NOTE.md`]
  - "TERMINAL PASS — Projection bulk data certified (4140/315) — Infrastructure only" [STAT, 08-02 ledger]
  - "already terminal, not an open mission" [WORK]
  - `HEADLINE_CAS_BASELINE_ACCEPT` marker, "distinguished from mathematical verification" [STAT/`REPAIR.md` §0]
  - **4140/315 independence adjudicated 2026-08-03 (review claim REFUTED).** A proposal to downgrade A0 to packet-consistency-only was checked and rejected. `verify_p25_bulk_projection.c` **independently rebuilds** `π(G)` and all 4140+315 test vectors from sealed, hash-cross-checked binary inputs, then recomputes membership via random sparse projection + FLINT RREF over `F_89`; `verify_p25_bulk_projection_result.json` records `reads_4140_from_json: false`, and the expected values are hardcoded pass literals compared against figures freshly computed at runtime. The genuine defect — the stock `verify_p25v0.py` asserting JSON fields only — was identified and repaired **by A0 itself** (`VERIFIER_REPLAY.md`:33–35). The external-session flag below ("read from producer JSON, not independently recomputed") is therefore superseded; Verification debt item 13's 4140/315 sub-claim is RESOLVED.
- **What was actually established:** the exact action, invariance, and the 4140/315 projection-bulk counts are certified, independently recomputed, and replayable. NOT established: anything about the headline; the marker is explicitly distinguished from mathematical verification.
- **Aliases:** `A0_CANONICAL_AUDIT`; "canonical audit of projection bulk"; `HEADLINE_CAS_BASELINE_ACCEPT` (link inferred); CERT `headline_cas_order`
- **Provenance:** `goal_runs_after_35fa/A0_CANONICAL_AUDIT`; `certificates/headline_cas_order/`.
  - `source: external-chatgpt` — `sessions_batch1.md` § `github-repo-task-update-6a7054fb.md`: A0 bulk P25 replay succeeded at payload level (4,140 `T_i` tests + 315 commutator tests certified) while `STATUS.md` still read "running" — flagged there as a bookkeeping inconsistency only.
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_A0_CANONICAL_IMPLEMENTATION_AUDIT.md` (round-3 push, head `37d61c1`), and separately flags that the 4140/315 counts were "read from producer JSON, not independently recomputed".
- **Pointers:** `goal_runs_after_35fa/A0_CANONICAL_AUDIT/STATUS.md`; `REMAINING_GOALS_NOTE.md`; `REPAIR.md` §0; `README.md`
- *Lenses 4/7 (DIR, STAT, WORK, CERT); confidence certain.*

---

<a id="e03"></a>
### E03 — A1-AUD — Path A audit packet

- **Target:** audit/repair — a ranked theorem-boundary audit of standing claims (`AUDIT_FINDINGS.md`, `audit_findings.json`), functioning as the **second correction layer** after `REPAIR.md`.
- **Justification:** Cannot close the headline; it governs the truth-value of claims other entries assert. Per Binding rule 1(i) its verdicts override anything they predate, within their stated scope.
- **Method:** CAS / document audit
- **Record type:** audit/repair
- **Thread:** T8 — process and audits
- **Verification class:** ANALYTIC-PROOF-REVIEW — `certificates/audit_a1` is NO-VERIFIER at the artifact level (`no_computation_performed: true`; a claims-about-claims audit of other packets' markers, no verify script per `notebook_build/verifier_depth.md`); the audit's content and 8 findings were read and characterized directly.
- **Status:** CHARACTERIZED (2026-08-03) — `certificates/audit_a1/AUDIT_FINDINGS.md` is a 510-line ranked theorem-boundary audit, a second correction layer after `REPAIR.md` (2026-07-31, `db37f58`/`07d1c4e`), performed 2026-07-31 21:38, commit `78abba4` ("Klein cubic: audit A1 -- theorem-boundary audit of every standing exit"; message states `AUDIT-A1-COMPLETE`, "No computation performed, no narrative file edited, no sealed packet edited").
  - Verdict vocabulary: **SOUND** / **SCOPE-DRIFT** / **UNSUPPORTED** / **UNCITED-HYPOTHESIS**, applied against a bill of ~20 markers.
  - Eight ranked findings:
    - **F1 (critical)** — `T-BRANCH-NONNORMAL` / T10 local-model attribution: **UNSUPPORTED + SCOPE-DRIFT**. T9 explicitly does not seal the completed ordinary-node local model `K'[[x,y,z1,z2]]/(xy)`; the "divisorial binodal locus" is analytic work-order input, not a CAS-sealed local form (`AUDIT_FINDINGS.md`:47–49, 73–75). See [E32](#e32).
      - **Director's refinement (recorded in the `78abba4` commit message):** F1 is "correct as PROVENANCE but the mathematics is not in doubt". The branch differentials `dh_i = grad_x P(·,u_i)` have a nonzero 2×2 minor modulo p at each witness (director's values 14, 155, 40), and a minor nonzero mod p is nonzero in `Z_p`, so `dh_1`, `dh_2` are independent at the lifted `Q_101` point; with `P_uu(u_i)` units, distinct roots, and `G` a unit, the formal Morse/Weierstrass factorization `H = unit·h_1·h_2` follows — so `T-BRANCH-NONNORMAL` is sound, and what is wrong is only the citation (it rests on the work order's analytic section 1.2 plus modular data that provably lifts, not on T9 or a CAS identity). Still modular-witness support; a char-0/formal sealing remains the open item.
    - **F2 (high)** — `T10-BINODAL-NO-3-DEFECT`: **SOUND as algebra**, **UNCITED-HYPOTHESIS as geometry**. The theorem is conditional: *if* the completed local ring is an ordinary node, *then* there is no 3-primary local Picard defect (`AUDIT_FINDINGS.md`:90–94, 119–120).
    - **F3 (high)** — `P25Z-FINITE-PRESENTATION`: **SCOPE-DRIFT**.
    - **F4 (high)** — sealed T8 prose asserts Jacobian determinants that were never computed: **UNSUPPORTED residual**.
    - **F5 (medium)** — `P25Y-DVR-PASS`'s Molien claims: **SCOPE-DRIFT**.
    - **F6 (medium)** — the stale "746 lower bound only" phrasing: **SCOPE-DRIFT**.
    - **F7 (low–medium)** — `P25X0-PASS` is titled characteristic-zero but is multiprime: **SCOPE-DRIFT**.
    - **F8 (low)** — the C0 order-12 table's known-residual clause: **UNSUPPORTED**.
- **What was actually established:** a ranked, scoped correction of eight standing claims across the T-track and the P25 family, with an explicit verdict vocabulary. NOT established: anything new about the headline — this is a correction layer, not a route.
- **Aliases:** CERT `AUD — AUD-A1`; `certificates/audit_a1`; "the audit_a1 layer"; GIT `78abba4` "audit theorem-boundary" (confirmed); possibly also `cdc016b` "Path A Gates A1-A3 — A1 PASS"
- **Provenance:** `certificates/audit_a1/` (`AUDIT_FINDINGS.md`, `README.md`, `audit_findings.json`). No external session matches.
- **Pointers:** `certificates/audit_a1/AUDIT_FINDINGS.md`; downstream consumers [E25](#e25) (F3/F5/F6/F7), [E32](#e32) (F1/F2/F4)
- *Lenses 1/7 (CERT) — **single-lens** by lens count, but the packet's contents were read directly and characterized on 2026-08-03; confidence high for the content, medium for its relationship to [E55](#e55) and the Path A `A1 PASS` gate of [E01](#e01).*

---

<a id="e04"></a>
### E04 — A5Q — A5 index-11 point transfer / degree-4 quartic rescue

- **Target:** positive construction — transport the exact degree-11 closed points obtained from the A5 subgroup twists into a genuine PSL(2,11) projective generic-twist point via induced-representation/coset projectors and field descent; then test whether the degree-11 closed point on the full generic twist lies on a descended rational normal quartic in `P⁴` (meeting the cubic in degree 12, leaving a rational residual point).
- **Justification:** A rational residual point on the generic twist is exactly a `K_proj`-point, which closes the headline positively via E37. The A5 twists already have exact points (E11), so only the transfer is missing.
- **Method:** CAS
- **Record type:** construction
- **Thread:** T6 — genuine subgroup twists
- **Verification class:** ALGEBRAIC-RECOMPUTE (both `A5Q` runs, `G4`, `G4A`).
- **Status:** PARTIAL — index-11 closed point installed (PASS); the degree-4 quartic rescue is empty in the scoped range; transfer to a full G-point not achieved.
  - `A5Q-INDEX11-CLOSED-POINT-PASS`; `A5Q-DEGREE4-RESCUE-EMPTY-SCOPED` [DIR, run `STATUS.md`]
  - `G4-INDUCED-DEGREE11-POINT-PASS` [DIR, `goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/STATUS.md`]
  - "A high-risk but finite new positive route"; "Need: compatibility of subgroup embeddings; field descent argument"; "not yet run" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §4 Rank6; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #4]
  - GIT: `83d35f7` "index-11 quartic rescue goal"; `30cccfa` "index-11 transfer goal"
  - Bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger, under its "A5Q" reading]
  - **Conflict (identity, unresolved here):**
    - *Side 1 (STAT):* "A5Q" = "A5-quadric branch (KLS)" — explicitly flagged in STAT as inferred, "no document explicitly writes out A5Q as an expansion" — and therefore carries the KLS A5-quadric closure status.
    - *Side 2 (DIR + WORK + GIT):* A5Q = "A5 quartic rescue / index-11 transfer".
    - The canonical ledger notes the two-lens rule favours side 2 and that the KLS A5-quadric branch is a genuinely distinct object recorded inside [E22](#e22). Both readings are preserved.
- **What was actually established:** an exact index-11 closed point on the induced object (PASS), and emptiness of the degree-4 quartic rescue **in the scoped range only**. NOT established: a rational point on the full generic twist; the field-descent/compatibility step is unbuilt.
- **Worker-root, unpromoted/unverified:** `goals_after_bd610a/A5Q_QUARTIC_RESCUE_WORK/COMMON_CYCLE_VARIANT.md` claims that per class the 11×15 quadratic-evaluation matrix has rank 11, and that stacking both classes gives a 22×15 matrix of rank 15 with a nonzero combined-submatrix determinant — absent from the sealed A5Q packet. See Goal-wave worker roots.
- **Aliases:** `A5Q_QUARTIC_RESCUE`, `A5Q_QUARTIC_RESCUE_old`; `G4_A5_INDEX11_TRANSFER`; `G4A_INDUCTION_PROJECTORS`; WORK `G4/A5Q`; GIT `A5`
- **Provenance:** `goal_runs_after_bd610a/A5Q_QUARTIC_RESCUE`, `.../A5Q_QUARTIC_RESCUE_old`, `goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER`, `.../G4A_INDUCTION_PROJECTORS`.
  - `source: external-chatgpt` — `sessions_batch3.md` § `progress-on-klein-cubic-6a705563.md`, branch `agent/klein-bd610a-closure-goals` head `83d35f7`, draft PR #1 (8 files: director review, dispatch index, six goal files). The session opened the draft PR but did not itself merge it; the merge landed as `e77298c` ("Merge pull request #1 ..."), 2026-08-01 20:21:41, 8 minutes after the head commit.
  - `source: external-chatgpt` — `sessions_batch1.md` § `mattrobball-unirational-task-6a7054e2.md` accepted G4/G4A "only with a strict scope fence (induced point is semilinear over `L_H`, not a constant-field orbit)".
- **Pointers:** the four run dirs above + their `STATUS.md`; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #4; `DIRECTOR_REVIEW_AFTER_BD610A.md` §4
- *Lenses 4/7 (DIR, GIT, WORK, STAT); confidence high for the quartic-rescue identity.*

---

<a id="e05"></a>
### E05 — Attempt1–5 — Five-attempts dispatch wave

- **Target:** infrastructure/dispatch — a five-way competitive dispatch (2026-07-30) gating five routes in parallel. Mapping: Attempt 1 = Pfaffian–Morita idempotent ([E26](#e26)); Attempt 2 = T fold-algebra/target branch ([E32](#e32)); Attempt 3 = S19 degree-19 rescue curve ([E30](#e30)); Attempt 4 = KLS minimality-conductor ([E22](#e22)); Attempt 5 = G global lifting ([E16](#e16)).
- **Justification:** Process, not mathematics: it allocated scarce CAS resource across five candidate closers simultaneously so that the cheapest stop would be found first.
- **Method:** mixed (dispatch/process)
- **Record type:** dispatch/process
- **Thread:** T8 — process and audits
- **Verification class:** NO-VERIFIER — a dispatch/process record; the wave allocates compute to other routes' verifiers and has no computation of its own to verify.
- **Status:** COMPLETED-WAVE — all five exited at scope/resource stops; the wave is closed and its content lives in the successor route entries.
  - `1c07871` "Attempt 1 Gates 1-2 — `FAIL-SCOPE` on the bridge" [GIT]; `FAIL-SCOPE`: "idempotent gives a point of auxiliary `P^2_D`, not of `F_{14,T}`" [WORK, `WORKORDER_ELO_TEN_PATHS.md` §1]
  - `b7be961` "Attempt 2 Gate 1 — `STOP-2` at measured 9.4 GB"; `a5b3d66` "option (c) — degree-43 factor reconstructed" [GIT]
  - `83d2b10` "Attempt 3 Gates 1-2 — implication chain PASSES, exit `STOP-3`" [GIT]; "implication chain PASS; both Rao branches remain live; `STOP-3`" [WORK]
  - `dddb743` "Attempt 5 Gate 1 — global state image formulated, containment UNDECIDED" [GIT]
- **What was actually established:** the mapping of the five attempts to routes, and their exit reasons (scope failure, memory ceiling, undecided implications). NOT established: any headline movement; Attempt 4 leaves no GIT trace.
- **Aliases:** `WORKORDER_FIVE_ATTEMPTS.md`; GIT `Attempt1`, `Attempt2`, `Attempt3`, `Attempt5`; exits `STOP-1`..`STOP-3`, `FAIL-SCOPE`, `P1`, `P1-CONDITIONAL`, `N1-SCOPED`, `N5`/`N5-SCOPED` (Attempt-5 Fork-A exit)
- **Provenance:** Attempt 1 gates 1B/1C/1D; Attempt 2 gate 1 + option (c); Attempt 3 gates 3B–3D; Attempt 4 gates 4B–4D; Attempt 5 gate 1; `certificates/GATE_REPORT_FIVE_ATTEMPTS_1.md`. No external session matches.
- **Pointers:** `WORKORDER_FIVE_ATTEMPTS.md`; `certificates/GATE_REPORT_FIVE_ATTEMPTS_1.md`
- *Lenses 2/7 (GIT, WORK); confidence certain for the wave and mapping (Attempt1↔Pfaffian–Morita confirmed by the shared verbatim `FAIL-SCOPE`/bridge language).*

---

<a id="e06"></a>
### E06 — B — Fixed-frame exhaustiveness bridge

- **Target:** negative obstruction — descend the full Klein-twist problem to the fixed four-parameter frame `F=C(A,B,Y,Z)`, build the depressed genus-one/ternary cubic over `K_proj`, prove it pointless, and then argue the fixed projector slice is **exhaustive** in the full Fano/projector variety, so that fixed-frame pointlessness certifies non-unirationality.
- **Justification:** The fixed-frame cubic was already proved pointless; if the fixed slice were exhaustive, that single arithmetic fact would transfer to the whole generic twist and settle the headline negatively.
- **Method:** mixed (exact CAS + arithmetic geometry)
- **Record type:** obstruction
- **Thread:** T4 — Pfaffian / fixed-frame / common-line
- **Verification class:** bridge run `B_FIXED_FRAME_BRIDGE` PARTIAL-RECOMPUTE; exhaustiveness run `B_FIXED_FRAME_EXHAUSTIVENESS_20260802` **CONSISTENCY-ONLY** (JSON dimension fields and text markers only). `B-BRIDGE-REFUTED` therefore rests on a consistency-only verifier sitting over an analytic finiteness citation — it stays at the top of Verification debt.
- **Status:** TERMINAL-NEGATIVE (as a bridge) — the exhaustiveness bridge is refuted; the fixed-frame arithmetic survives as scoped, now non-headline, fact.
  - `B-UNDECIDED` [DIR, `goal_runs_after_35fa/B_FIXED_FRAME_BRIDGE/STATUS.md`]
  - `B-BRIDGE-REFUTED` [DIR, `goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/STATUS.md`; WORK, `REMAINING_GOALS_NOTE.md`]
  - "TERMINAL NEGATIVE (`B-BRIDGE-REFUTED`) — Fixed-frame bridge is false; cannot certify non-unirationality — Warns against overusing frame reductions" [STAT, 08-02 ledger]
  - "Pointlessness of the fixed-frame ternary cubic does not transfer to the generic Klein twist... the fixed projector slice is not exhaustive in the full Fano/projector variety" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §1, §2.3]
  - 2026-07-30 (pre-refutation): presented as the **leading active route**, "D5 residue gate closed positively", sextic discriminant factorization, exact sparse-BKK `[K_proj:F]=6`, monodromy `S6`/`A6` [STAT, `CURRENT_PATHS.md` lines 91–333]
  - "D5 is soluble and is retired as an obstruction"; "ind(C/F)=3, C(F)=∅"; "`[K_proj:F]=6`"; "the present certificates do not decide global projective small resolvability or the final class-group obstruction"; "Verdict remains OPEN" [HAND `R11`]
  - "The answer remains OPEN"; "f5=0 is also locally soluble and retired"; "The residual point itself fails globally by `B*rB(t1)!=0`... A point with varying direction is not excluded" [RES `RES-08`]
  - **Conflict (date reversal):**
    - *Side 1 (2026-07-30, `CURRENT_PATHS.md`):* leading active route with positive milestones.
    - *Side 2 (2026-08-02, run `STATUS.md` + `REMAINING_GOALS_NOTE.md` + 08-02 ledger):* `B-BRIDGE-REFUTED`.
    - The canonical ledger records that side 2 is corroborated outside the offline ledger, so the reversal is genuine rather than a document artifact.
  - **Conflict (certificate ownership):**
    - *Side 1 (CERT):* assigns `certificates/target_branch_global`, `target_branch_mod3`, `target_branch_t10` to "B".
    - *Side 2 (GIT/WORK/HAND):* `target_branch_t10` carries `exit_t10.json` and matches the T10 work order (`1d3fe3b`); HAND `R11`/`R12` attach "target branch" to Path T.
    - Not merged; recorded under both E06 and [E32](#e32).
- **What was actually established:** the proposed exhaustiveness theorem is **false**, not merely unproved. The fixed-frame arithmetic (index 3, `C(F)=∅`, `[K_proj:F]=6`, `S6`/`A6` monodromy, D5 and f5 retired) stands as scoped fact. NOT established: any statement about `F_{14,T}(K_proj)` or `X_gen(K_proj)`; the implication `C(K_proj)=∅ ⇒ F_{14,T}(K_proj)=∅` "could still hold for a separate arithmetic reason, including vacuously".
- **Aliases:** `B_FIXED_FRAME_BRIDGE`, `B_FIXED_FRAME_EXHAUSTIVENESS_20260802`; "fixed-frame bridge"; HAND `R11`; RES `RES-08`; CERT bucket `B — B-GLOBAL, B-MOD3, B-T10` (contested)
- **Provenance:** the two `goal_runs_after_35fa/B_*` dirs; D5 residue gate / target-branch incidence; resolved-branch incidence (upstairs critical determinant, degree 37); positive conic/algebra test (`P5(F)`); twelve-point nonnormal singularity gate; residual `E[3]`/Kummer computation on `F0=C(A,Y,Z)`; `tmp/pfaffian_d5_constant_point`, `tmp/pfaffian_d5_residual_attack`, `tmp/full_scaled_frame_degree_attack`, `tmp/pfaffian_six_sheet_branch_obstruction`, `tmp/target_branch_delta_saturated_singularity/`.
  - `source: external-chatgpt` — `sessions_batch2.md` § `task-b-in-repo-6a70554b.md`; merged PR #4, main commit `5899d05`; packet `goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/`. Refutation argument: `dim Σ ≤ 1`; the gauge group `Γ=PGU(h_struct)∩Stab_{PGL_3(D)}(H_T)` has finite effective image in `Aut(Y_K̄)` (citing Kuznetsov–Prokhorov–Shramov Thm 1.1.2 for Picard-rank-1 genus-8 prime Fano threefolds), so ≤1-dimensional translates of `Σ` cannot exhaust the 3-fold `Y`. Replay markers `B-FIXED-FRAME-EXHAUSTIVENESS-REFUTED`, `B-BRIDGE-REFUTED`, `HEADLINE-OPEN`.
- **Pointers:** `CURRENT_PATHS.md` lines 91–333; `REMAINING_GOALS_NOTE.md`; `DIRECTOR_REVIEW_AFTER_BD610A.md` §1/§2.3; `HANDOFF.md` "2026-07-30 latest Pfaffian closure"; `RESOLUTION.md` "2026-07-30 latest fixed-frame result"
- *Lenses 6/7 (DIR, CERT, HAND, RES, STAT, WORK); confidence certain.*

---

<a id="e07"></a>
### E07 — C0–C3 — Direct twisted Fano section (quaternion / Hermitian common isotropic line)

- **Target:** positive construction — install an executable model of the descended central simple algebra `A_proj` (quaternion corner `D=eAe`, five Hermitian matrices `h₁..h₅ ∈ Herm₃(D)`), independently construct restricted Plücker / rank-one equations for `F_{14,T}`, and search for a common isotropic right `D`-line, i.e. a `K_proj`-point of `F_{14,T}` (⇒ `BR-FANO-POS`).
- **Justification:** By the Pfaffian bridge ([E26](#e26)), a `K_proj`-point of `F_{14,T}` is **sufficient** for the headline-positive answer — the chain runs forward only, and no converse is asserted anywhere. Arrow B (common isotropic `D`-line ⟺ `F14_T(K)≠∅` ⇒ `C_gen(K)≠∅`) and Arrow C (`C_gen` point ⇒ `G`-unirational) both PASS; Arrow A (idempotent ⇒ common line) is `FAIL-SCOPE` (`certificates/pfaffian_point/BRIDGE_AUDIT.md`:160–161). Note `BRIDGE_AUDIT.md` §5, the "Stable-factor trap (Tschinkel–Zhang)": the stable equivalence `X×P²×P(V) ~_G Y×P²×P(V)` does **not** transport unirationality once `P(V)` is replaced by a nonsplit Severi–Brauer variety with no rational point, so any argument that cites only the stable product formula to move a point onto `C_gen` is invalid in the twisted setting. The quaternion reduction makes the search a finite-dimensional isotropy problem over an explicit algebra.
- **Method:** CAS (exact linear algebra over cyclotomic / multiprime, msolve/M2)
- **Record type:** construction
- **Thread:** T4 — Pfaffian / fixed-frame / common-line
- **Verification class:** `certificates/fano_interface_c0` CONSISTENCY-ONLY (the `C0-UNDECIDED` boundary is asserted, not re-derived); `certificates/fano_c2_1` PARTIAL-RECOMPUTE.
- **Status:** OPEN-UNDECIDED — model installation advanced through C3 (bases sealed, modular only); the common-isotropic-line solve is not reached, char-0 transfer not made.
  - `C0-UNDECIDED — verified`; "no executable Fano model; needs `A_proj` descent → Morita symbol" [WORK, `DIRECTOR_HANDOFF.md` §8]
  - "Two clean negatives... no such mechanism exists geometrically... No model installed" [WORK, §8]
  - `1ad97cf` "V2 Track C0 — `C0-UNDECIDED`"; `3f71710` "C1.1 preflight — `C1-UNDECIDED`, floor named at char-0"; `d769885` "C2.0 — two-generator word basis sealed"; `4da9f8f` "C2.1 — partial constants sealed"; `0cf23e5` "C3.0 — rectangular basis installed" [GIT]
  - Sub-installation exits `C0-MODEL-PASS`/`C1-MODEL-PASS`/`C2-FANO-MODEL`/`C3-FANO-MODEL-PASS`, `C2-TWO-GENERATORS-MODULAR`, `C3-RECTANGULAR-BASIS-MODULAR`; target exit `C-POSITIVE`/`C-FANO-POINT` **not reached** [WORK]
  - "every individual Hermitian member is isotropic... only simultaneous common-line isotropy remains open"; "no explicit `K_proj` coordinates, quaternion corner, or common isotropic line are known" [RES `RES-07`]
- **What was actually established:** partial algebra models through C3, all modular; individual Hermitian isotropy. NOT established: the common isotropic line, explicit `K_proj` coordinates, or any char-0 lift.
- **Worker-root note:** a compact unpromoted/unverified claim (`C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3`) shared between this entry and [E08](#e08) is recorded at [E08](#e08) and in Goal-wave worker roots.
- **Aliases:** Route C; Path C; Tracks C0, C1, C2, C2.1, C3; SPEC task **E4**; RES `RES-07`; CERT `fano_interface_c0`, `fano_c1`, `fano_c2`, `fano_c2_1`, `fano_c3`
- **Provenance:** C1/C2/C3 (CAS_HEADLINE, REVISED); C0.1–C0.2 (`WORKORDER_CAS_AFTER_5E72D8E.md`); C1.1–C1.2 (`WORKORDER_CAS_T9_P25Z.md`); C2.0–C2.3 (`WORKORDER_CAS_T10_P25W_C2.md`); C3.0–C3.3 (`WORKORDER_CAS_T11_P25V_C3.md`); certificate dirs incl. `certificates/fano_interface_c0/DIRECTOR_CORRECTION_C0.md`.
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` audited the worker return as `C-UNDECIDED`, "faithful but fragmented, no self-adjoint idempotent/quaternion corner/common line yet"; authored `GOAL_C_EXPLICIT_MORITA_AND_COMMON_LINE.md` (round-3 push, head `37d61c1`) and earlier `Goal C` (`e495a58`).
- **Pointers:** `WORKORDER_CAS_HEADLINE.md` §6; `WORKORDER_CAS_HEADLINE_REVISED.md` §5; `WORKORDER_CAS_DECISION_AFTER_7FDBE42.md` §4 (Conditional Track C; `_V2.md`'s corresponding Track C section is §5, not §4); `DIRECTOR_HANDOFF.md`; `SPEC.md` task E4
- *Lenses 5/7 (GIT, CERT, RES, WORK, +HAND via `R9`); confidence certain. Possibly-same-as [E08](#e08) — successor relationship, kept separate.*

---

<a id="e08"></a>
### E08 — C5/C6 — Corrected Palatini / Plücker common-line big cell

- **Target:** positive construction, corrected alternative to Route C — represent the common isotropic right line directly via a self-adjoint reduced-rank-two idempotent `e` in the exact lazy algebra with involution (`e²=e`, `σ(e)=e`, `Trd(e)=2`, `eSᵢe=0` for i=1..5), using a corrected alternating-form / Plücker / square-zero common-line incidence model (retiring the earlier inconsistent encoding `e·S₀·e=0`); C6 then lifts split points to constant-line or positive-degree sections via Morita descent on a Palatini determinantal big cell.
- **Justification:** Same target as E07 but with a consistent encoding; WORK ranks it Rank 1 — "All ingredients except the final full incidence solve are already available. An exact point executes `BR-FANO-POS` and closes the headline positively."
- **Method:** CAS (multiprime + determinantal/Plücker elimination)
- **Record type:** construction
- **Thread:** T4 — Pfaffian / fixed-frame / common-line
- **Verification class:** ALGEBRAIC-RECOMPUTE (all three C5 runs; C6 and its two phases).
- **Status:** OPEN — highest-ranked live positive route as of 2026-08-02; the C6 birational determinantal model PASSES, residual is the positive-degree section lift; the full incidence solve is not executed.
  - `C5-UNDECIDED` [DIR, run `STATUS.md`; WORK, `REMAINING_GOALS_NOTE.md`]
  - `C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS`; `C6-POSITIVE-DEGREE-RESIDUAL` [DIR, `goal_runs_after_141f60/C6_PALATINI_BIG_CELL/STATUS.md`]
  - "Rank 1 ... the strongest live positive route" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §4 Rank1]
  - Supersession note: "C5 idempotent `e*S_0*e=0` | Plücker/alternating-form model → C6" [WORK, `REMAINING_GOALS_NOTE.md`]
  - "OPEN — Corrected Plucker/alternating model survives — Possible geometric construction/refutation" [STAT, 08-02 ledger]
  - `1b764bf` "add C6 determinantal Fano goal" [GIT]
- **What was actually established:** the corrected incidence encoding and a birational determinantal model of the big cell (PASS). NOT established: a point; the residual is a positive-degree section lift and the full incidence solve was never run.
- **Worker-root, unpromoted/unverified** (shared with [E07](#e07)): `goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3` ("research only" per A0) claims a degree-12 full-wedge covariant with nonzero symplectic contraction, an idempotent of reduced rank two, and Morita corner ranks 4/12/5 — not promoted. See Goal-wave worker roots.
- **Aliases:** `C5_PROJECTOR_INCIDENCE`, `C5_MULTIPRIME_20260802`, `C5_NEXT_GATE_20260802`, `C6_PALATINI_BIG_CELL`; `GOAL_C6_PALATINI_BIG_CELL.md`; STAT "C5/C6 common-line Fano"; GIT `C6`
- **Provenance:** `goal_runs_after_bd610a/C5_PROJECTOR_INCIDENCE`, `.../C5_MULTIPRIME_20260802`, `.../C5_NEXT_GATE_20260802`; `goal_runs_after_141f60/C6_PALATINI_BIG_CELL`.
  - `source: external-chatgpt` — `sessions_batch2.md` § `task-b-in-repo-6a70554b.md` (commit `5899d05`) explicitly reassigns "the remaining direct common-line problem solely to C/C5" after refuting B.
  - `source: external-chatgpt` — `sessions_batch4.md` § `2026-08-03-problem-e-review.md` judges C6's further searches (linear/quadratic/bounded-height/Morita) "non-decisive without a boundedness theorem".
- **Pointers:** the four run dirs above; `REMAINING_GOALS_NOTE.md`; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #3; `DIRECTOR_REVIEW_AFTER_BD610A.md` §4
- *Lenses 4/7 (DIR, GIT, STAT, WORK); confidence certain.*

---

<a id="e09"></a>
### E09 — COV — degree-31/35 m=1 covariant landing modules

- **Target:** positive/negative bounded-degree — decide the plane-order-one (`m=1`) covariant landing modules `[(I^(m)/I^(m+2))_d ⊗ W]^G` in degrees 31 and 35 (and their based/nonbased C3/C6 linear gates), coupled to degree 25 by invariant multiplication; sibling of P25 at higher degree.
- **Justification:** A nonzero module in degree 31 or 35 is a candidate landing covariant (headline-positive); emptiness in char 0 would extend the exclusion ladder of E16 upward.
- **Method:** CAS (modular / multiprime)
- **Record type:** bounded computation
- **Thread:** T2 — degree ladder
- **Verification class:** ALGEBRAIC-RECOMPUTE (`COV_M1_DEG31_35`).
- **Status:** OPEN/DEFERRED — modular results only; char-0 transfer is the blocking gap.
  - `COV-UNDECIDED` [DIR, run `STATUS.md`; WORK, `REMAINING_GOALS_NOTE.md`]
  - "148 residual charts; modular [1] ≠ char-0 transfer" [WORK, `REMAINING_GOALS_NOTE.md`]
  - "Degrees 31 and 35 still require saturation of their based and nonbased C3/C6 charts and are coupled to degree 25 by invariant multiplication"; "the degree-35 zero linear quotient is not a degree-wide emptiness theorem" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §2.6, §1 item 6]
  - "OPEN/DEFERRED — Modular information only — Needs characteristic-zero transfer" [STAT, 08-02 ledger]
  - `[(T_1)_d⊗W]^G = 0` through degree 34 and for degree ≥164, but **dimension 1 at degree 35** in the split-`F_67` fibre — "this does not lift to characteristic zero" [STAT, `CURRENT_PATHS.md`]
  - **Research lead (unexploited, flagged 2026-08-03):** V4's `M1-TRIPLE-ORDER3-ALL-LINE-DEGREE-EMPTY` theorem (`goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/THEOREM.md`) is a **characteristic-zero, all-line-degree** emptiness result for the `m=1` triple-line order-three stratum, and it has **never been invoked against the sibling degree-31/35 `m=1` modules** — no packet applies it there. It closed the corresponding branch at degree 25 (see [E25](#e25)); applying it here is a potential char-0 closure route for part of this entry's question, and is the cheapest unexplored move on E09.
- **What was actually established:** modular vanishing through degree 34 and above 164, with a one-dimensional `T₁` residue at degree 35 over the split `F_67` fibre. NOT established: any char-0 statement; the degree-35 residue is precisely what refutes the all-degree colon shortcut used in [E16](#e16).
- **Worker-root note:** a compact unpromoted/unverified claim (`P25_COV_SUPPORT`) shared between this entry and [E25](#e25) is recorded at [E25](#e25) and in Goal-wave worker roots.
- **COV caveat:** A0's `CANONICAL_STATE.md` (`goal_runs_after_35fa/A0_CANONICAL_AUDIT/CANONICAL_STATE.md`:42) downgraded/repaired the invalid worker-root exit label `COV-STRUCTURED-DEGREES-EMPTY-SCOPED` to `COV-HIGHER-ORDER-BRANCHES-EMPTY-SCOPED` (higher-order-branch emptiness only); this repair is recorded as **done** (Verification debt item 13), not an open item.
- **Aliases:** `COV_M1_DEG31_35`; STAT "COV — m=1 charts"; `tmp/covariant_arrangement_module`; `tmp/m1_*`
- **Provenance:** `goal_runs_after_35fa/COV_M1_DEG31_35`; `tmp/m1_t1_saturation`, `tmp/m1_t1_f3_colon_attack`, `tmp/m1_t1_f3_colon_degree35_audit`, `tmp/m1_t1_char0_d35_gate`, `tmp/covariant_arrangement_module/verify_all.py`.
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_COV_STRUCTURED_POSITIVE_SEARCH.md` (`3569d63`) and `GOAL_COV_M1_EQUALIZERS_DEG31_35.md` (`37d61c1`); claims the triples `(d,m,e)=(25,3,7),(31,5,1),(35,5,5)` have zero global coefficient module ⇒ any covariant in degrees 25/31/35 must have `m=1`; and flags one worker exit label `COV-STRUCTURED-DEGREES-EMPTY-SCOPED` as overclaiming/invalid.
- **Pointers:** `goal_runs_after_35fa/COV_M1_DEG31_35/STATUS.md`; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #10; `CURRENT_PATHS.md` 2026-07-29 item 9
- *Lenses 3/7 (DIR, STAT, WORK); confidence certain.*

---

<a id="e10"></a>
### E10 — D/D2 — Equivariant motive / stack-invariant obstruction

- **Target:** negative obstruction — find a mixed-prime additive or nonadditive **stack invariant** (equivariant motive / equivariant Burnside-style) that bounds the dimension of any compression, i.e. forces `ed_C(G)=4`.
- **Justification:** A dimension-bounding invariant preserved by every compression would rule out all 3-dimensional compressions at once, closing the headline negatively without any covariant search.
- **Method:** analytic (with CAS character/representation screens)
- **Record type:** obstruction
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** ALGEBRAIC-RECOMPUTE (`D2_STACK_INVARIANT`).
- **Status:** TERMINAL-NEGATIVE-FOR-THE-ROUTE — no valid bridge from the stack invariant to a dimension bound.
  - `D2-NO-VALID-BRIDGE` [DIR, `goal_runs_after_35fa/D2_STACK_INVARIANT/STATUS.md`]
  - `fc4e490` "Resolve Goal D equivariant motive route"; `e1fc474` "Record Goal D artifact commit and seal" [GIT]
  - "The unrestricted equivariant motive/Hodge invariant is too flexible: admissible blowup centres can reproduce the required summand" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 2]
  - Decision exits `N-D`, `D-NARROW`, `D-STOP` — none resolved [WORK, `WORKORDER_ELO_TEN_PATHS.md`]
  - Bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger; STAT itself notes "content entirely unknown from this lens"]
- **What was actually established:** that the unrestricted invariant admits admissible blowup centres reproducing the required summand, so no bridge exists. NOT established: any obstruction; a *restricted* invariant is not excluded.
- **Aliases:** Goal D; Path D (Elo #9); `D2_STACK_INVARIANT`; GIT `D`
- **Provenance:** `goal_runs_after_35fa/D2_STACK_INVARIANT`; Path D D1 (repair split-injection proof, install period lattice / CM order / polarization), D2 (geometric channel screen).
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_D_EQUIVARIANT_DEGREE_MOTIVE.md` (`3569d63`) and audited the return as `D-INVARIANT-REPRODUCIBLE`, "faithful refutation of the motive/degree-formula route".
- **Pointers:** `goal_runs_after_35fa/D2_STACK_INVARIANT/STATUS.md`; `WORKORDER_ELO_TEN_PATHS.md` (Path D); `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 2
- *Lenses 4/7 (DIR, GIT, STAT, WORK); confidence high. Possibly-same-as [E19](#e19) — WORK merges, others separate; kept separate.*

---

<a id="e11"></a>
### E11 — E / H2 / H3 — Proper-subgroup generic twists (A4, both A5 classes)

- **Target:** negative-first strategy — since `X` G-unirational ⇒ `H`-unirational for every `H≤G`, test one maximal-subgroup class at a time for a **pointless** generic `H`-twist (⇒ `BR-SUBGROUP-NEG`). The outcome was positive instead.
- **Justification:** A single pointless maximal-subgroup twist would immediately force the negative headline. Cheapest possible negative route, since subgroup twists are far smaller objects than the full generic twist.
- **Method:** CAS (exact cyclotomic + Reynolds covariants)
- **Record type:** obstruction / construction (dual — negative route, scoped-positive outcome)
- **Thread:** T6 — genuine subgroup twists
- **Verification class:** ALGEBRAIC-RECOMPUTE (`H_A4`, `H_A5` and all subpackets).
- **Status:** SCOPED-POSITIVE (route closed) — all three maximal-subgroup obstructions are closed positively; no promotion to a dominant G-map exists, so the headline is untouched.
  - `H-A4-RATIONAL-POINT`, `H-A4-STRUCTURAL-MODEL-PASS` [DIR, `goal_runs_after_35fa/H_A4_TWIST/H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/STATUS.md`]
  - `H-A5-CLASS1-RATIONAL-POINT`, `H-A5-CLASS2-RATIONAL-POINT`, `H-A5-STRUCTURAL-MODEL-PASS` [DIR, `goal_runs_after_35fa/H_A5_TWISTS/STATUS.md`]
  - "The canonical generic `A_4` twist has an exact rational point... Both maximal `A_5` generic twists have exact rational points" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §1]
  - "The subgroup points close the corresponding subgroup point obstructions. They do not construct a dominant G-equivariant map... the `A_5` returns cannot be promoted" [WORK, §2.1]
  - Decision exits `N-E`, `P-E-SCOPED`, `E-STOP` — none resolved [WORK]
  - `08859c0` "Certify exact A4 surface parameters"; `20be6ba` "generic-twist continuation goal"; `2301a43` "resolve Goal H subgroup-twist sweep" [GIT]
- **What was actually established:** exact rational points on the generic `A4` twist and on both maximal `A5`-class generic twists; the corresponding subgroup obstructions are therefore dead. NOT established: any dominant G-map; the image dimension of the constructed maps is ≤2.
- **Worker-root, unpromoted/unverified:** `goals_2026-08-01/H_SUBGROUP_TWISTS_CODEX_ROOT_20260801` claims a COMPLETE proper-subgroup decision boundary — "every proper subgroup of an A5 or 11:5 not already displayed is outside the possible exceptions of CTZ Theorem 5.1" — stronger than the canonical packet; if verified this upgrades this entry's scope from finite sample to complete boundary. See Goal-wave worker roots.
- **Aliases:** Path E (Elo #8); Goal H / "Route H" (`WORKORDER_CAS_HEADLINE.md` §9); `H_A4_TWIST/H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801`; `H_A5_TWISTS`; GIT `A4`, `A5`, `H`
- **Provenance:** the two `goal_runs_after_35fa/H_*` dirs; E1 one-A5-class pilot; H1 two maximal A5 classes (`WORKORDER_CAS_HEADLINE.md` §9); `goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER` (interface attempt — see [E17](#e17)).
  - `source: external-chatgpt` — `sessions_batch3.md` § `progress-on-klein-cubic-6a705563.md` (branch head `83d35f7`): reports the A4 twist's prior emptiness computation was invalidated by a **wrong transpose convention**, and that both maximal A5 twists get exact points via degree-11 Reynolds covariants — "kills A4/A5 subgroup-pointlessness routes but gives no dominant G-map, image dimension ≤2".
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_H_SUBGROUP_TWISTS.md` (`3569d63`) and `GOAL_H2_A4_GENERIC_TWIST.md` (`37d61c1`); audited the return as `H-SWEEP-UNDECIDED`, "A4-twist now smallest unresolved subgroup object" (pre-dating the A4 point).
- **Pointers:** the two `H_*` run dirs; `WORKORDER_ELO_TEN_PATHS.md` (Path E); `WORKORDER_CAS_HEADLINE_REVISED.md` §6.3; `DIRECTOR_REVIEW_AFTER_BD610A.md` §1–§2.1
- *Lenses 3/7 (DIR, GIT, WORK); confidence certain.*

---

<a id="e12"></a>
### E12 — Elo — Elo ranking / ten-paths prioritization system

- **Target:** infrastructure/process — Elo-style competitive ranking over ten candidate paths (A–J) to allocate scarce CAS resource, followed by post-Elo re-dispatch.
- **Justification:** Process only. It determined which of E01–E22 received compute, so it shapes what is and is not known, but it proves nothing.
- **Method:** mixed (process)
- **Record type:** dispatch/process
- **Thread:** T8 — process and audits
- **Verification class:** NO-VERIFIER — a dispatch/process record (Elo ranking allocates compute; it performs no computation of its own to verify).
- **Status:** COMPLETED-PROCESS — ranking wave executed; superseded by the post-Elo construction dispatch and later by the goal-run regime.
  - `c5e71be` "issue post-Elo finite-lifting work order"; `5e765ce` "Elo cycle-1 gate report"; `c28bb08` "Path G post-Elo" [GIT]
  - `3bfbd01` "post-Elo gate 1 — record Path F"; `d96b408` "Path T post-Elo — Gate T1 `T-BIRATIONAL`" [GIT]
  - Path rankings: A #1, F #2, ... H #6, I #7, E #8, D #9, J #10 (Elo values e.g. I = 1473) [WORK]
- **What was actually established:** a resource-allocation order and two gate reports. Nothing mathematical.
- **Aliases:** `WORKORDER_ELO_TEN_PATHS.md`; "post-Elo"; Paths A–J with Elo ratings; GIT `Elo`
- **Provenance:** `certificates/GATE_REPORT_ELO_1.md`; `certificates/GATE_REPORT_POST_ELO_1.md`; `WORKORDER_POST_ELO_CONSTRUCTION.md`. No external session matches.
- **Pointers:** `WORKORDER_ELO_TEN_PATHS.md`; `WORKORDER_POST_ELO_CONSTRUCTION.md`
- *Lenses 2/7 (GIT, WORK); confidence certain.*

---

<a id="e13"></a>
### E13 — F — Path F: fixed-frame genus-one torsor / restricted E[3]-class arithmetic

- **Target:** positive/negative — decide rationality of an explicit fixed-frame genus-one curve / restricted `E[3]`-Selmer class over `K_proj`: either find a divisorial local obstruction (Kummer-image nonmembership ⇒ pointless) **or** construct a rational point via a conic/intersection-algebra reformulation (a length-6 conic ∩ curve whose coordinate algebra `≅ K_proj`).
- **Justification:** The fixed-frame genus-one curve is small enough for full 3-descent; a decision either way feeds the fixed-frame programme (though after `B-BRIDGE-REFUTED` the negative branch no longer transfers to the headline).
- **Method:** mixed (CAS + descent arithmetic)
- **Record type:** construction / obstruction (dual)
- **Thread:** T4 — Pfaffian / fixed-frame / common-line
- **Verification class:** mixed — `certificates/fixed_frame_arithmetic` ALGEBRAIC-RECOMPUTE (`existence_verify.py` recomputes the degree-6 line eliminant and its S6 Galois group via sympy; `conic_algebra_verify.py` recomputes the five-form rank and fixed-direction residual identities); `certificates/restricted_e3` PARTIAL-RECOMPUTE (an independent Julia/Hecke replay recomputes the decisive degree-8 field claim at one fresh specialization, but structural fields and the binary `res(xi)` decision itself are read from JSON, not run).
- **Status:** UNDECIDED — F1 terminality audit passes and F1/F2/F3 artifacts exist, but no decision exit is recorded.
  - `56e61c3` "Path F Gate F1-P — terminality audit passes"; `865b262` "Paths F and G cycle 2 — F existence undecided"; `3bfbd01` "post-Elo gate 1 — record Path F" [GIT]
  - Decision exits defined `N-F`, `P-F`, `F-LOCAL-SOLUBLE`, `F-STOP`; **no exit verbatim-resolved**; headline "OPEN" [WORK]
  - CERT inventory: `restricted_e3/{CUBE_TEST.md, DECISION.md, RESTRICTED_ETALE_ALGEBRA.md, divisor_vector_mod3.json, group_cohomology.json}`; `fixed_frame_arithmetic/{EXISTENCE_STATUS.md, TERMINALITY_AUDIT.md, conic_algebra_*, five_forms.json}` [CERT]
  - Bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger — but STAT flags "F" as ambiguous]
  - **Conflict (label attribution):**
    - *Side 1 (STAT):* the 08-02 ledger's bundled `TERMINAL` token "F" may denote this route.
    - *Side 2 (WORK + GIT + CERT):* Path F is a distinct in-repo route with its own gates and certificate dirs; the token "F" is equally readable as the Problem-F import ([E14](#e14)) or "Fable" ([E15](#e15)).
    - STAT itself cannot determine the referent. The `TERMINAL` label may be attached to the wrong object; unresolved.
- **Note:** Not to be confused with [E14](#e14) (Problem-F technique import) or [E15](#e15) (Fable) — the ledger token `F` is ambiguous across all three (glossary; conflict 4).
- **What was actually established:** the F1 terminality audit passes; the restricted étale algebra, mod-3 divisor cube test, and group-cohomological restriction artifacts exist. NOT established: existence or nonexistence of a point; no decision exit.
- **Aliases:** Path F (Elo #2); F0–F4; Fork F1-N / Fork F1-P; gate `F1-P`; CERT `restricted_e3`, `fixed_frame_arithmetic`; GIT `F1`, `PathF`
- **Provenance:** F1 restricted étale algebra; F2 divisor-cube test mod 3; F3 group-cohomological restriction; F4 consequences; Fork F1-N (new divisorial obstruction) vs Fork F1-P (conic/intersection-algebra construction).
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_F_CONIC_INTERSECTION_ALGEBRA.md` (`3569d63`) and audited the return as `F-CONIC-CRITERION-EMPTY`, "faithful, scoped: `C(K_proj)=∅` proved only for the fixed-frame cubic, not shown to be a necessary slice of the genuine problem" — the gap that `GOAL_B` was then written to target.
- **Pointers:** `WORKORDER_POST_ELO_CONSTRUCTION.md` (Path F, F0–F4); `certificates/restricted_e3/`; `certificates/fixed_frame_arithmetic/`
- *Lenses 4/7 (GIT, CERT, WORK, STAT-ambiguous); confidence high for the route, low for the ledger's TERMINAL label applying to it.*

---

<a id="e14"></a>
### E14 — F-IMPORT — Problem F involution-mechanism / F-engine technique import

- **Target:** negative obstruction by technique transfer — import Problem F's all-degree `V₄`-fixed exceptional-path obstruction (parity forcing, forced basepoints, pointwise-fixed exceptional curves, path-lemma tree argument) to kill all equivariant maps `P(W)⇢C` at once; later generalized as the "F-engine" and used to push the bounded landing-covariant analysis past degree 24 via the full 55-plane / 55-line / D10 / D12-point arrangement.
- **Justification:** Problem F was resolved negatively by exactly this mechanism; a verbatim transfer would have settled Problem E negatively in one step.
- **Method:** analytic (with CAS arrangement modules)
- **Record type:** obstruction
- **Thread:** T3 — mechanism transfer from solved examples (tooling also feeds T2 — degree ladder)
- **Verification class:** not covered by `notebook_build/verifier_depth.md` — provenance is `tmp/` scratch only, so the evidence is local-only (Binding rule 5).
- **Status:** REFUTED-AS-TRANSFER — the verbatim import fails and the generalized engine closes rather than obstructs; explicitly deprioritized.
  - Header label "AUDIT PASSED, resolution committed" (for Problem F itself: "RESOLVED NEGATIVE") [HAND `R16`]
  - For the Klein-cubic transfer: "**the verbatim transfer fails**"; generalized engine — "the transition system closes rather than obstructs"; this outcome "weighs toward a POSITIVE construction... instead" [HAND `R16`]
  - "the rational fixed line invalidates the constant-image step in Problem F's surface path proof" [RES `RES-02`]
  - "the leading common-line order-exactly-three system factors through 37 dimensions and was not sent to a nonlinear solver... Since degree 25 is odd, no universal minus-line vanishing relation may be added either" [RES `RES-02`]
  - `2b8cf41` "generalize the F-engine"; `1a52c93` "F-technique import" [GIT]
  - "Do not rerun the Problem F constant-path argument" [STAT, `CURRENT_PATHS.md` line 2442, Deprioritized work]
- **What was actually established:** that the mechanism does **not** transfer, and specifically why (the rational fixed line breaks the constant-image step). The failure is cited as evidence favouring a positive construction. NOT established: any obstruction for Problem E.
- **Aliases:** "F-technique import"; "generalize the F-engine"; HAND `R16`; RES `RES-02`
- **Provenance:** `tmp/involution_exceptional_divisor` (+`verify_v4.py`), `tmp/d12_line_restriction`, `tmp/v4_surface_slice_audit`; D10/D12 symbolic module and `m1_compact_degree25` plane/line/point construction (+2 independent audits); `m3_line_point_boundary` D12 rank-8/8 point closure.
  - `source: external-chatgpt` — `sessions_batch3.md` § `klein-cubic-threefold-psl-6a6b6514.md` reconstructed the PSL(2,7)/Problem-F obstruction from scratch, abstracted it into a "normalizer fixed-stratum descent" machine, and confirmed independently that it fails on the Klein cubic ("rational lines in involution fixed loci give escape transitions"); proposed a "transition cosheaf" `𝒯_X` as successor. No commits.
  - `source: external-chatgpt` — `sessions_batch4.md` § `g-equivariant-rational-maps-6a70559f.md` and § `mathematical-machine-implementation-6a7055b7.md` further generalize the same mechanism (fixed-divisor constancy, rational-chain going-down principle) and both assert the Klein involution fixed locus contains **both** a rational line and an elliptic curve — the stated reason the cheap test fails. Sandbox LaTeX/PDF only; nothing committed.
- **Pointers:** `HANDOFF.md` 2026-07-28 sections; `RESOLUTION.md` "2026-07-29 structural advances" items 12–13; `CURRENT_PATHS.md` Deprioritized work; `F-dp2-psl27/RESOLUTION.md` (the F-side source of the transfer assessment; verified 2026-08-03 to contain no independent E work)
- *Lenses 4/7 (GIT, HAND, RES, STAT); confidence certain. The letter "F" is overloaded — see [E13](#e13), [E15](#e15).*

---

<a id="e15"></a>
### E15 — Fable — A4 trisection / Koszul lifting construction

- **Target:** positive construction — at a `V₄`-fixed centre (normalizer `A₄`), blow up the length-3 base orbit `R=X∩P(T)`, prove every `A₄`-equivariant `P(U)⇢X` has projected degree divisible by 3, and explicitly construct a degree-3 `A₄`-equivariant birational map `P(U)⇢S⊂X` onto a cubic surface `S(a,b,c)`; then lift compatibility across the whole 55-plane / D10 / D12 arrangement via symbolic Rees powers `I^(m)/I^(m+2)` and a Koszul construction, aiming at an actual landing covariant.
- **Justification:** A local positive construction that lifts to a global section of the symbolic sheaf would *be* the landing covariant, closing the headline positively.
- **Method:** mixed (equivariant geometry + CAS module/rank computations)
- **Record type:** construction
- **Thread:** T3 — mechanism transfer from solved examples
- **Verification class:** not covered by `notebook_build/verifier_depth.md` — provenance is `tmp/` scratch only, so the evidence is local-only (Binding rule 5).
- **Status:** CLOSED-IN-CURRENT-FORM — one-centre trisection and the first Koszul gate are positive results; both continuations to `I^(11)/I^(13)` are obstructed.
  - "the first local positive gate is solved" / "the one-centre trisection gate is solved"; "does not automatically define a section of the full 55-plane symbolic sheaf" [HAND `R17`, RES `RES-11`]
  - "This solves exactly the first formal landing correction"; "the theorem closes only `I^(9)/I^(11)`" [HAND `R18`]
  - Factorized family: "**obstructed**"; "impossible ... for irreducible, split, nonreduced, singular, nonnormal, or irregular double planes"; "closed at the first full `I^(11)/I^(13)` gate" [HAND `R19`]
  - Nonfactorized successor: "now closed as well"; "every planewise normal-order 3/4 extension retaining these fixed line germs is impossible"; "A Fable escape must change the boundary data or the leading normal order" [HAND `R20`, RES `RES-11`]
  - "This is a scoped negative landing theorem" [RES `RES-11`]
  - "Fable remains a redesign route, not the current lead" [STAT, `CURRENT_PATHS.md` 2026-07-30 item 4]
  - `WORKORDER_ORDER12.md`: active dispatch, headline "OPEN", target = second gate (`F(σ+e)=0 mod I^13`) [WORK]
  - "the Fable positive branch was closed by two obstruction theorems (elliptic quadratic-trace; Veronese/Hilbert–Burch syzygy dichotomy)" [WORK, `WORKORDER_STRATA_MACHINE.md` addendum re `71ba6bd`]
  - **Conflict (dispatch vs closure):**
    - *Side 1 (`WORKORDER_ORDER12.md`):* the order-12 second gate is dispatched as **active**.
    - *Side 2 (`WORKORDER_STRATA_MACHINE.md` addendum + HAND `R19`/`R20`):* the branch is **closed** by two obstruction theorems.
    - Chronology suggests the order-12 dispatch predates the closure theorems (WORK notes the refutation "is inferred from cross-reference only"), but no lens states the ordering.
- **What was actually established:** the one-centre trisection gate and the first Koszul gate (`I^(9)/I^(11)`) are solved positively; the factorized `q_P·R_P` family and its nonfactorized successor are both impossible at `I^(11)/I^(13)`. NOT established: a global section of the 55-plane symbolic sheaf; the local gate does not define one.
- **Aliases:** Fable route; "quadratic triangle / trisection"; HAND `R17`–`R20`; RES `RES-11`; WORK `FABLE — Koszul ansatz order-twelve gate`
- **Provenance:** `tmp/fable_positive_construction`, `fable_trisection_attack`, `fable_trisection_compatibility`, `fable_nonlinear_first_gate`, `fable_resolved_descent`, `fable_constrained_cokernel`(+audit), `fable_finite_d12_constrained`, `fable_d12_char0_bridge`(+audit), `fable_d12_rees_sigma_interface`(+audit), `fable_first_gate_koszul`(+audit), `fable_d12_simultaneous_successor`, `fable_order12_qsection_correction`, `fable_d12_joint_rank`, `fable_d12_koszul_rank`, `fable_d12_module_adversary`, `fable_d12_bulk_correction_rank`, `fable_d12_triangular_bulk_closure`, `fable_relative_divisor_trace_obstruction`, `fable_fixed_plane_boundary_adversary`, `fable_relative_q_trace_obstruction`, `fable_nonfactorized_successor`, `fable_nonfactorized_syzygy_obstruction`, `fable_nonfactorized_feasibility`.
  - **Terminology overlap, unresolved:** `sessions_batch4.md` § `2026-08-03-problem-e-review.md` reports `V4-TRISECTION-GENUS2-QUOTIENT-PASS` and a positive-line-degree-6 "trisection" counterexample family. The canonical ledger files those runs under [E33](#e33) (commit match `goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/`), not here. No input resolves whether the two "trisection" objects are the same.
- **Pointers:** `HANDOFF.md` "2026-07-29 xCD completion and Fable update", "2026-07-29 Fable positive-construction assessment"; `RESOLUTION.md` "2026-07-29 structural advances" item 4; `SPEC.md` task E1 continuation; `WORKORDER_ORDER12.md`
- *Lenses 4/7 (HAND, RES, STAT, WORK); confidence certain.*

---

<a id="e16"></a>
### E16 — G — Path G: universal object, global finite lifting, bounded landing-covariant degree ladder

- **Target:** positive construction with a built-in negative exit — build a nonzero homogeneous `G`-equivariant landing self-covariant `p:W→W` with `F(p)=0`, via formal normal-cone / polar lifting along the exact stabilizer stratification (finite-truncation theorem with isolation cutoff `N⋆=d+2m+1`, terminal-residual towers at degrees 7/13/19, global-state-image vs nonlinear-rank-drop analysis, an equivariant-resolution "G3-algebraization" shortcut); `G-NEGATIVE` is the all-degree negative fallback if every family's universal terminal projective zero support is empty. The bounded degree ladder (degrees 7–24 excluded) is its executable face.
- **Justification:** A landing self-covariant in any degree is equivalent to the headline-positive answer; an all-degree emptiness theorem is equivalent to the headline-negative answer. This is the only route with both exits built in.
- **Method:** CAS (Macaulay2 / msolve / multiprime linear algebra) with structural theorems
- **Record type:** construction / reduction (dual — the bounded ladder is a construction search; G2 is a proved reduction)
- **Thread:** T1 — reduction spine; also T2 — degree ladder
- **Verification class:** ALGEBRAIC-RECOMPUTE (`G_UNIVERSAL`; certificates `global_finite_lifting`, `global_lifting_decision`, `global_terminal_module`).
- **Status:** STRUCTURAL-PASS, ARITHMETIC-OPEN — G2 achieves the all-degree finite-generation reduction and the mission is formally retired; the bounded ladder excludes degrees ≤24; the degree-13/19 "obstructions" are only sample residuals post-repair; everything hands off to [E17](#e17) and [E25](#e25).
  - PRE-REPAIR: degree-13/19 packets labeled `G13-OBSTRUCTION` / `G19-OBSTRUCTION`, read as degree-wide obstruction theorems [STAT/`REPAIR.md` §§11–12]
  - POST-REPAIR: downgraded to `G13-SAMPLE-RESIDUAL`, `G19-SAMPLE-RESIDUAL`, `G-PATTERN` — "proven only that the residual map is not identically zero, not that its zero locus (`Θ⁻¹(0)`) is empty" [STAT/`REPAIR.md` §§11–12; HAND `R1`; RES `RES-26`]
  - POST-REPAIR retained: "Path G: finite truncation and isolation cutoff (`N⋆=d+2m+1`) — retained" [HAND `R1`, RES `RES-26`]
  - "Path G4.1 symbolic free-fibre recurrence — retained at its stated free-fibre boundary"; "the split-fibre all-degree colon is therefore refuted"; "target-1,572 certificate ... refuted" [HAND `R2`]
  - "P25.1 `P25-TOWER-SURVIVES` — retained as scoped free-fibre/degree-25 continuation"; "dim Z<=15"; "No `P^22` or successor slice is authorized" [HAND `R3`]
  - `G2-FINITE-GENERATION-PASS` [DIR, `goal_runs_after_35fa/G_UNIVERSAL/STATUS.md`]; "TERMINAL STRUCTURAL PASS — All-degree reduction achieved — Leaves arithmetic decision of surviving universal object" [STAT, 08-02 ledger]
  - "No nonzero homogeneous polynomial G-covariant `W→W` of degree at most 24 has image contained in the Klein cubic"; "Degree 25 is now the next unrestricted homogeneous landing degree"; "This is a bounded exclusion only... there is no degree bound; therefore this calculation supplies no negative answer" [RES `RES-01`]
  - "A search through any finite degree is not a negative resolution" [HAND `R1`]
  - `e050464` "Path G Gate G1 — containment FALSE at (1,7)"; `865b262` "G exits `G-CONSTRUCTION`"; `c28bb08` "G1 finite truncation PASSES; degree-7 exits `G7-OBSTRUCTION`"; `68147f3` "Route G verdict — G4.1 symbolic formula achieved, gate G-A blocked"; `62a3fcb` "Path G3 — exit `G-PATTERN`"; `23f40f7` "finish G/G2 universal all-degree theorem"; `6a2ccaa` "retire completed G2 structural mission" [GIT]
  - "no finite global presentation was constructed... nonexistence of such a presentation is not proved" [WORK, `WORKORDER_CAS_HEADLINE_REVISED.md`, parked]
  - "Marked state gives a boundary map — not proved"; "Equivariant interpolation from projective endpoint data — false without a common-character hypothesis"; "Affine completion has the same formal-rational field as the full completion — false"; "G-unirationality — not proved" [WORK, `NOTES_PATH_G_GLOBAL_LIFTING.md` §18]
- **What was actually established:** (i) degrees ≤24 contain no landing self-covariant, explicitly a bounded exclusion with no degree bound available; (ii) the finite-truncation/isolation-cutoff theorem; (iii) the G4.1 free-fibre recurrence at its stated boundary; (iv) `G2-FINITE-GENERATION-PASS`, the all-degree reduction of the headline to a single arithmetic question. NOT established: the covariant, its nonexistence, or any finite global presentation — and finite generation explicitly does **not** give a finite degree cutoff.
- **Worker-root, unpromoted/unverified:** `goals_2026-08-01/G_ALL_DEGREE_ROOT_20260801` is a self-acknowledged isolated delta (concurrent-worker collision) with 8 unmerged structural results, e.g. an eight-chart scheme audit proving the split-67 line-degree-four scheme equals the inherited `D_L` multiple scheme scheme-theoretically. See Goal-wave worker roots.
- **Research lead, uncited/unpursued (recorded 2026-08-03):** `tmp/alternative_covariants` (worker-root, uncited anywhere until 2026-08-03) computes exact Molien-style multiplicities of `Hom_G(Sym^n(source), W)` for alternative source representations `W⊕1`, `W⊕W`, `∧²W`, `Sym²W`, plus a modular landing scan for `∧²W→W` — a genuinely different covariant-source strategy from every named route above (all of which use `W` itself as the source). Raw multiplicity tables only, no conclusion drawn, never pursued further.
- **Aliases:** Path G; G0–G5; G1 finite truncation; G2 finite generation; G4.1 symbolic free-fibre recurrence; G7 degree-7 exit; `G_UNIVERSAL`; SPEC task **E1**; HAND `R1`–`R3`; RES `RES-01`, `RES-26`; CERT bucket `GLIFT`
- **Provenance:** G1–G5, G4.1–G4.4, G-A/G-B/G-C/G-D; `goal_runs_after_35fa/G_UNIVERSAL`; degree exclusions 7–24 (`tmp/structural_degree13`, `degree14_structural`, `degree15_structural`, `degree16_landing_probe`, `degree16_exceptional_search`, `covariant_arrangement_module` for 17–21, `degree22_compression`, `degree23_common_line_landing`, `degree24_landing`); `tmp/symbolic_global_exactness`, `m1_compact_graded_pilot`, `m1_t1_*`; `tmp/local_symbolic_rees`; `certificates/global_*`, `certificates/lifting/`.
  - `source: external-chatgpt` — `sessions_batch2.md` § `finish-g-g2-theorem-6a705522.md`; branch `agent/g2-universal-all-degree-20260802`, PR #3 squash-merged as `23f40f7`, ledger commit `6a2ccaa`; packet `goal_runs_after_35fa/G_UNIVERSAL/` (`STATUS.md`, `UNIVERSAL_OBJECT.md`, `ALL_DEGREE_THEOREM.md`, `NOETHERIANITY.md`, `DECISION.md`, `theorem.json`, `verify.py`, `SEAL.json`; upstream source `goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json`, blob `965abb5`). Claims: universal object = generic twist `X_T = T×^G X` over `K_proj`; five-way all-degree equivalence; `F(p)=h³Φ(a)` two-way denominator clearing; `PSL(2,11)` verified perfect of order 660 ⇒ primitive representatives unique up to `k^×`; Hironaka presentation `rank_A R=12`, `rank_A M=60` over `A=k[f3,f5,f6,f8,f11]`; explicit counterexample that finite generation does **not** imply a finite degree cutoff.
  - `source: external-chatgpt` — `sessions_batch1.md` § `mattrobball-unirational-task-6a7054e2.md` accepted `G2-FINITE-GENERATION-PASS` as "strategy-changing".
  - `source: external-chatgpt` — `sessions_batch1.md` § `github-repo-task-update-6a7054fb.md` restates the five-way equivalence (point of `X_gen`; equivariant rational map; nonzero landing covariant in any degree; primitive landing covariant; rational point of the explicit 35-coefficient cubic `V(Φ)⊂P⁴_{K_proj}`) and notes the dominance step "should be made binding by G3" — i.e. unproven at that time.
- **Pointers:** `WORKORDER_CAS_HEADLINE.md` §4; `WORKORDER_CAS_HEADLINE_REVISED.md` §6.1; `WORKORDER_POST_ELO_CONSTRUCTION.md` (Path G); `NOTES_PATH_G_GLOBAL_LIFTING.md`; `REPAIR.md` §§11–12, §16; `SPEC.md` task E1; `certificates/global_finite_lifting/`, `global_lifting/`, `global_lifting_decision/`, `global_terminal_module/`, `global_transition/`
- *Lenses 7/7 — the only entry seen by every lens; confidence certain.*

---

<a id="e17"></a>
### E17 — G3 — Universal cubic arithmetic (G3A/G3B/G3C/G3D/G3H/G3P/G3S)

- **Target:** positive/arithmetic successor to Path G — having reduced the headline to a "surviving universal object", decide whether its associated cubic `Φ` has a `K_proj`-rational point, i.e. decide `V(Φ)(K_proj) ≠ ∅`; sub-attacks via exact field arithmetic + automatic dominance (G3A), rational conic sections satisfying tautological polar constraints (G3B/G3C), direct arithmetic on the generic twist (G3D/G3S), an A5 quadratic-Springer semilinear lift (G3H), and tautological-polar / odd-degree descent (G3P).
- **Justification:** After `G2-FINITE-GENERATION-PASS` this single rational-point question **is** the headline; any exact point closes it positively, and `G3A` claims to remove the separate dominance gate.
- **Method:** mixed (CAS + arithmetic)
- **Record type:** construction
- **Thread:** T1 — reduction spine

| Subroute | Exact target | Last outcome | State | Governing artifact |
|---|---|---|---|---|
| G3A | exact arithmetic + automatic dominance (removes the separate Jacobian-rank-4 gate for any exact `K_proj`-point) | `G3A-ARITHMETIC-DOMINANCE-PASS` | structural pass | `goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md` |
| G3B | rational conic sections satisfying tautological polar constraints (line-conic search) | `G3B-UNDECIDED` | UNDECIDED | `goal_runs_after_0aecc89/G3B_LINE_CONIC_SEARCH/STATUS.md` |
| G3C | rational conic sections satisfying tautological polar constraints (line-conic Fano) | `G3C-UNDECIDED` | UNDECIDED | `goal_runs_after_0aecc89/G3C_LINE_CONIC_FANO/STATUS.md` |
| G3D | direct arithmetic on the generic twist | `G3D-UNDECIDED` (primary exit); Clifford/spinor-discriminant/27-line-algebra stages PARTIAL | STATUS-ledger `PASS`-vs-`PARTIAL` JSON bug; `SEAL.json` governs | `goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC/{STATUS.md,SEAL.json}` |
| G3H | A5 quadratic-Springer semilinear lift | `G3H-SEMILINEAR-G3-FRAME-PASS` (demoted); `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` | interface installed only — no executable field point materialized or verified | `goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase4_g3_frame/G3_FRAME.md` |
| G3P | tautological-polar / odd-degree descent | `G3P-POLAR-SYSTEM-PASS` (main); branch-only `G3P-UNDECIDED` | PASS on main; branch packet's canonical-polar route misses, archived snapshot | `goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/STATUS.md`; branch `agent/g3p-a5-semilinear-20260802` at `external_packets/g3p-a5-semilinear-20260802_G3P_A5_SEMILINEAR_QUADRATIC/` |
| G3S | structured direct arithmetic (execution order) | none recorded | dispatched | commit `7da4fdf` "Add G3S structured direct arithmetic execution order" |
| G7A/B/C | double-A5 biplane (induced cycles / projective scaling / cross-class projector) | `G7-PROJECTIVE-SCALING-PASS` (re-derived); geometry subpacket `G7-RESIDUAL-GEOMETRY-PASS` (polarization, third-intersection formula, residual census) | re-derived pass; induced-cycle claim `G7B-INDUCED-CYCLE-REFUTED` and quarantined | `goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/{cycles,geometry}/STATUS.md` (`4a5beac`) |

- **Verification class:** mixed — G3A/G3B/G3C/G3P/G3D (+`line27_exact`) and the G3H phase-5 subpackets ALGEBRAIC-RECOMPUTE; `G3H_A5_SEMILINEAR_SPRINGER` **top level PARTIAL-RECOMPUTE** (phase 2 rebuilds the covariant `Y`; phases 1/4/5 are hash/flag checks, and phase 4 is the `INTERFACE_INSTALLED` frame).
- **Status:** OPEN — highest-priority live route as of 2026-08-02; dominance and polar-system sub-gates PASS, the A5 semilinear G3 frame is **interface-installed only** (demoted 2026-08-03), the A5 semilinear quadratic interface is a scoped NO-GO, and the point decision itself is undecided.
  - "OPEN — Decide `V(Phi)(K_proj)` — Highest priority" [STAT, 08-02 ledger]; "G3 arithmetic OPEN" [WORK, `REMAINING_GOALS_NOTE.md`]
  - `G3A-ARITHMETIC-DOMINANCE-PASS` [DIR]
  - `G3P-POLAR-SYSTEM-PASS` [DIR]
  - `G3H-SEMILINEAR-G3-FRAME-PASS`, `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` [DIR]
  - **G3H demoted (adjudicated 2026-08-03).** `G3H-SEMILINEAR-G3-FRAME-PASS` is an **interface/schema installation**, not a constructed field point. The primitive element is abstract — "A primitive element θᵢ is any separating Hᵢ-invariant rational function" (`goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase4_g3_frame/G3_FRAME.md`:14) — and the deliverable is the *formal expression* `a_i = M̄^{-1}(P_i/τ^33)`. The power-basis reduction status is verbatim `INTERFACE_INSTALLED`. `verify_phase4.py` checks only marker-string equality, `coefficient_count == 35`, sha256 comparisons, `len(power_basis) == 11`, and substring membership of `"Phi(a_i)=0"` — **no field reconstruction and no arithmetic evaluation**. Effective state: **interface installed; the executable degree-11 field point is neither materialized nor verified.** The scoped quadratic no-go `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` stands at its stated level and is unaffected.
  - **G3D internal contradiction adjudicated 2026-08-03.** The `PASS`-vs-`PARTIAL` conflict is an **in-repo bug**, not a genuine disagreement: in `goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC/STATUS.md` the embedded phase-ledger JSON block (lines ~44–56) marks the witt/spinor phases `G3D-POLAR-CLIFFORD-PASS` / `G3D-SPINOR-DISCRIMINANT-PASS`, contradicting the same file's prose (line ~5) and `SEAL.json` plus the stage documents, all of which read `*-PARTIAL`. **`SEAL.json` governs.** Canonical state: the simple-field model, polar cubic surface, Hessian-kernel and cube reduction are structural passes at their stated scope; **Clifford, spinor discriminant, and the 27-line algebra are PARTIAL**; the exit is `G3D-UNDECIDED`. The sealed packet is deliberately **not** edited (hash seals); the bug is recorded here and in Verification debt.
  - **Unmerged-branch packet (recorded 2026-08-03, provenance `branch-only (unmerged)`).** `goal_runs_after_eb21458/G3P_A5_SEMILINEAR_QUADRATIC/` exists **only** on branch `agent/g3p-a5-semilinear-20260802` (head `086e089`, pinned to main `eb21458`) — **not on main**. Exit `G3P-UNDECIDED`; scoped markers `G3P-A5-SEMILINEAR-MATERIALIZATION-PASS`, `G3P-A5-CANONICAL-POLAR-MISS`, `G3P-A5-CLASSIFYING-DEGREE-LE4-POLAR-EMPTY`. Content: the genuine degree-11 A5 points are expressed in the normalized G3 frame by an `H`-invariant circuit `a_H(w) = diag(τ^(1,4,5,6,7))·B_poly(w)^{-1}·J_H·Φ_H(Y_H(w))` — closing the missing-coordinate gate at formula level — but exact good-reduction witnesses show the pulled-back point lies on neither canonical polar `H_q` nor `Q_q`, and the complete constant-coefficient classifying-map family through degree 4 is excluded from both polar identities; the first remaining family has degree 5 and dimension 5 (local CAS order pending in the packet's `CAS_NEXT_ORDER.md`). The packet also contains `G7B_SCOPE_CORRECTION.md`: independent corroboration of the G7B refutation (the assignment `gH → [ρ(g)e0]` requires `[e0]` `H`-fixed, which it is not), listing what survives — the abstract degree-11 étale algebra `L_H/K_proj`, the `H`-`A5` semilinear point, and the Paley 2-(11,5,2) incidence matrix; archived snapshot: `external_packets/g3p-a5-semilinear-20260802_G3P_A5_SEMILINEAR_QUADRATIC/` (branch head `086e08928bd3a0d360018e6f809739517f72702e`); the snapshot contains no verify script — narrative and data only.
  - `G3B-UNDECIDED` [DIR, `goal_runs_after_0aecc89/G3B_LINE_CONIC_SEARCH/STATUS.md`]; `G3C-UNDECIDED` [DIR, `goal_runs_after_0aecc89/G3C_LINE_CONIC_FANO/STATUS.md`]; `G3D-UNDECIDED` (primary exit) [DIR, `goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC/STATUS.md`] — G3D also records five structural PASS sub-labels (`G3D-K-SIMPLE-MODEL-PASS`, `G3D-POLAR-CUBIC-SURFACE-PASS`, `G3D-HESSIAN-KERNEL-PASS`, `G3D-HESSIAN-CUBE-REDUCTION-PASS`, `G3D-A5-STRUCTURED-DESCENT-PASS`) and three PARTIAL sub-labels (`G3D-POLAR-CLIFFORD-PARTIAL`, `G3D-SPINOR-DISCRIMINANT-PARTIAL`, `G3D-LINE-27-ALGEBRA-PARTIAL`)
  - `62a3fcb` "Path G3 — exit `G-PATTERN`"; `5eb1214` "add G3 universal cubic arithmetic goal"; `5cb3d11` "add G3A arithmetic and dominance goal"; `d1f43d6` "Add G3H A5 semilinear Springer execution order"; `7da4fdf` "Add G3S structured direct arithmetic execution order" [GIT]
  - **G7B invalidation resolved in-repo (confirmed 2026-08-03):** `4a5beac` (2026-08-02 14:54, ~2h after the flawed packet at `eb21458`) rewrote `goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/STATUS.md`: primary exit is now `G7-PROJECTIVE-SCALING-PASS` (re-derived by an independent chart-normalization/cone-lift method), the induced-cycle claim is downgraded to RESIDUAL, a refutation marker `G7B-INDUCED-CYCLE-REFUTED` is installed, the defect is documented in `cycles/INDUCED_CYCLE_REFUTATION.md` (`|Stab_G([e0])|=11`, `|G·[e0]|=60`, 44/44 equivariance checks failed), the withdrawn data is quarantined as `cycles/cycles_WITHDRAWN_rho_e0.json`, and the verifier is hardened (`verify_cycles.py` + `cycles/audit_induced_refutation.py`). See Verification debt item 4.
  - **Conflict (external audit vs run labels) — ADJUDICATED 2026-08-03, in favour of Side 2:**
    - *Side 1 (DIR run labels):* `G3A-ARITHMETIC-DOMINANCE-PASS`, `G3P-POLAR-SYSTEM-PASS`, `G3H-SEMILINEAR-G3-FRAME-PASS`.
    - *Side 2 (`sessions_batch4.md` § `2026-08-03-problem-e-review.md`):* "G3H phase-4 'executable field points' are unbuilt (formula-level/interpolated only, `INTERFACE_INSTALLED`)"; "phase-3/4 'independent verifiers' check hashes/strings, not algebra"; "G3D's internal phase ledger says `PASS` while prose says Clifford/spinor stages are partial/`UNDECIDED` (a direct self-contradiction flagged in-repo)".
    - *Resolution:* both Side-2 claims were checked against the artifacts and **confirmed** — see the two adjudication bullets above. G3H is interface-only; the G3D contradiction is a JSON-block bug in `STATUS.md` overridden by `SEAL.json`. `G3A-ARITHMETIC-DOMINANCE-PASS` and `G3P-POLAR-SYSTEM-PASS` are untouched by this and stand (both ALGEBRAIC-RECOMPUTE). See conflict 15.
- **What was actually established:** an exact arithmetic/dominance frame (`G3A`) — reported as proving `G3-DOMINANCE-AUTOMATIC`, i.e. that any exact `K_proj`-point automatically yields a dominant equivariant map with no separate Jacobian-rank-4 gate — plus a polar-system pass (`G3P`), and, from G3D at scope, the simple-field model, polar cubic surface, Hessian-kernel and cube reduction. NOT established: a point of `V(Φ)`; the G3H semilinear frame is an **installed interface only**, with no materialized or verified executable degree-11 field point; the A5 quadratic interface is a scoped NO-GO; G3D's Clifford, spinor-discriminant and 27-line-algebra stages are PARTIAL with exit `G3D-UNDECIDED`; G3B/G3C carry no captured exit label.
- **Aliases:** "G3 universal cubic arithmetic"; `G3A_EXACT_ARITHMETIC_DOMINANCE`, `G3B_LINE_CONIC_SEARCH`, `G3C_LINE_CONIC_FANO`, `G3D_DIRECT_ARITHMETIC`, `G3H_A5_SEMILINEAR_SPRINGER`, `G3P_POLAR_ODD_DEGREE_DESCENT`, `G3S`; GIT `G3`, `G3A`, `G3H`, `G3S`
- **Provenance:** `goal_runs_after_0aecc89/{G3A_EXACT_ARITHMETIC_DOMINANCE, G3B_LINE_CONIC_SEARCH, G3C_LINE_CONIC_FANO, G3P_POLAR_ODD_DEGREE_DESCENT, G7_DOUBLE_A5_BIPLANE}`; `goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC`; `goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER`; G3S execution order.
  - `source: external-chatgpt` — `sessions_batch1.md` § `mattrobball-unirational-task-6a7054e2.md`: dispatched Route 1 (`G3H_A5_SEMILINEAR_SPRINGER`, commit `d1f43d6`) and Route 2 (`GOAL_G3D_DIRECT_ARITHMETIC`, commit `b1915a5`); pushed then withdrew `G3B_C_STRUCTURED_ARITHMETIC_SEARCH.md` (`7da4fdf`, deleted by `ff69434` after user pushback). Accepted `G3A-ARITHMETIC-DOMINANCE-PASS` and its `G3-DOMINANCE-AUTOMATIC` consequence. **Also declared `G7-INDUCED-DOUBLE-CYCLE-PASS` / `G7-PROJECTIVE-SCALING-PASS` INVALID** by independent recomputation of point stabilizers in the 660-element model: `|Stab_G([e0])|=11`, `|G·[e0]|=60`, so `[e0]` is fixed by neither maximal A5; all 44/44 generator-point equivariance checks failed — representative-dependent, not a genuine induced cycle. Accepted `G7-CROSS-CLASS-PROJECTOR-PASS` but noted it "weakens the motivating route": the permutation module is `1⊕V10` with `V10` absolutely irreducible, not the hoped-for `1⊕V5⊕V5'`.
  - `source: external-chatgpt` — `sessions_batch1.md` § `github-repo-task-update-6a7054fb.md`: commits `312ff0a` (post-0aecc89 execution goals), `5cb3d11` (G3A arithmetic and dominance goal), `25de051` (focused polar descent goal → G3P), `3aa13c6` (double-A5 biplane goal → G7), `6558772` (split local worker goals).
- **Pointers:** the run dirs above + their `STATUS.md`; `REMAINING_GOALS_NOTE.md`; `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`
- *Lenses 4/7 (DIR, GIT, STAT, WORK); confidence certain. "G7" collides with Path G's degree-7 exit — see [E16](#e16) and conflict 7.*

---

<a id="e18"></a>
### E18 — H11:5 / H5 / H6 — 11:5 Frobenius subgroup trace-cubic programme

- **Target:** negative/structural obstruction for the proper subgroup `C11⋊C5 ≤ G` — reduce the generic 11:5 twist exactly to a genuine cyclic trace cubic `Tr_{E/K}(r₂⁻¹ a² σ(a)) = 0` over a rational four-parameter invariant field, then decide the trace cubic's pointlessness using the degree-11 torus / `μ₁₁`-torsor / isogeny structure (⇒ `BR-SUBGROUP-NEG` if pointless).
- **Justification:** It is "the smallest exact genuine twist left" — a pointless 11:5 twist forces the negative headline, and unlike the fixed-frame route the object is genuine, not a proxy.
- **Method:** mixed (CAS + arithmetic: elliptic/torsor)
- **Record type:** obstruction
- **Thread:** T6 — genuine subgroup twists
- **Verification class:** ALGEBRAIC-RECOMPUTE (`H_11_5`, all three H5 runs, `H6` +phase, `H6A`).
- **Status:** OPEN — norm model and `μ₁₁`-torsor class installed and PASSING; the arithmetic binary is unresolved; ranked second-strongest negative route.
  - `H-11_5-NORM-MODEL-PASS` [DIR, `goal_runs_after_35fa/H_11_5_TWIST/STATUS.md`; WORK]
  - `H6-PROJECTIVE-11-ISOGENY-PASS` — exact isogeny model for `H_tr` and its dual multiplicative resolvent installed [DIR, `goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY/STATUS.md`]
  - `H5-UNDECIDED` [DIR, `goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/STATUS.md`]; "no K-point; binary open" [WORK]
  - `H6-TORSOR-CLASS-PASS` [DIR, `goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/STATUS.md`]
  - "the exact trace model is now sufficiently small to attack, but no pointlessness theorem is present"; "Rank 2 — the smallest exact genuine twist left" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §2.5, §4]
  - Ledger: H11:5 `OPEN — Need genuine degree-11 torus/isogeny decision — H6 route`; H5 `PARTIAL — Model sealed but no K-point conclusion — Input to H6` [STAT]
  - `027e002` "add H6 degree-11 isogeny goal" [GIT]
- **What was actually established:** an exact norm model and the `μ₁₁`-torsor class of the trace cubic. NOT established: whether the cyclic trace cubic has a K-point; no pointlessness theorem exists.
- **Aliases:** `H_11_5_TWIST`, `H5_11_5_TRACE_CUBIC`, `H5_FIBRATION_PROBE_20260802`, `H5_WAVE2_LAURENT_PROJ`, `H6_TRACE_CUBIC_DECISION`, `H6A_PROJECTIVE_11_ISOGENY`; GIT `H6`
- **Provenance:** `goal_runs_after_35fa/H_11_5_TWIST`; `goal_runs_after_bd610a/{H5_11_5_TRACE_CUBIC, H5_FIBRATION_PROBE_20260802, H5_WAVE2_LAURENT_PROJ}`; `goal_runs_after_141f60/{H6_TRACE_CUBIC_DECISION, H6A_PROJECTIVE_11_ISOGENY}`.
  - `source: external-chatgpt` — `sessions_batch1.md` § `github-repo-task-update-6a7054fb.md` reports a new reduction: H5's trace map `a↦a²σ(a)` is a degree-11 isogeny on the projective norm torus via the group-ring identity `(2+σ)(5-3σ+σ²-σ³)=11-(1+σ+σ²+σ³+σ⁴)`; also states `H5-UNDECIDED` is sealed and that the ledger's "no sealed run" claim was stale.
  - `source: external-chatgpt` — `sessions_batch3.md` § `progress-on-klein-cubic-6a705563.md` records the 11:5 twist rewritten exactly as `Φ(a)=Tr_{E/K}(r₂⁻¹a²σ(a))=0`, undecided.
  - `source: external-chatgpt` — `sessions_batch2.md` § `repo-push-results-6a70552d.md` and § `repo-push-request-6a705556.md` both leave "the full 11:5 trace cubic" on their explicit not-closed lists.
- **Pointers:** the six run dirs above; `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 4, §2.5, §4 Rank2; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #5
- *Lenses 4/7 (DIR, GIT, STAT, WORK); confidence certain. STAT flags false-positive symbol matches: `H5=(3/8)b²P3` in the xCD route, and `H_6=V(f_6)` the Klein sextic — unrelated to these route codes.*

---

<a id="e19"></a>
### E19 — Hodge-center — split-injection theorem / CM-polarized screen

- **Target:** negative necessary-condition screen — from a hypothetical dominant equivariant `P⁴⇢X` and its equivariant resolution `f:Z→X`, use the split injection `H³(X)↪H³(Z)` and the blowup formula `H³(Bl_C Y)≅H³(Y)⊕H¹(C)(-1)` to force `H^{2,1}(X)` as a `G`-representation to be supplied by `H^{1,0}` of positive-irregularity blowup centres, then upgrade to the integral polarized intermediate-Jacobian structure (CM order, principal polarization) and force a contradiction via minimum-genus/orbit-size bounds (Riemann–Hurwitz / Chevalley–Weil).
- **Justification:** If no admissible family of blowup centres can supply `H^{2,1}(X)` as a G-representation, no dominant equivariant map exists and the headline closes negatively.
- **Method:** mixed (Hodge theory + CAS character screens)
- **Record type:** obstruction
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** ALGEBRAIC-RECOMPUTE (`certificates/hodge_centers`).
- **Status:** SALVAGED-BUT-NONBINDING — the split-injection theorem survives the §8 rewrite, but the screen yields no numerical contradiction (40 representation channels survive).
  - PRE-REPAIR: proof via "generically finite" pushforward `f_*:H³(Z)→H³(X)` — **relative-dimension error**: since `dim Z=4`, `dim X=3`, a dominant `f` has relative dimension one, not zero, so the displayed degree-`d` identity is invalid [STAT/`REPAIR.md` §7]
  - POST-REPAIR: "Hodge-center conclusion — salvageable; proof rewritten via relatively ample class (`REPAIR.md` §8)"; "corrected Hodge-center split-injection theorem after §8 substitution" listed among trusted retained results [HAND `R31`, RES `RES-28`, STAT]
  - Required file edit: `certificates/hodge_centers/HODGE_CENTER_NECESSITY.md` must replace the generically-finite argument with the relatively-ample-class argument [STAT/`REPAIR.md` §15]
  - "necessary condition only; 40 representation channels survive" [WORK, `WORKORDER_ELO_TEN_PATHS.md`]
  - `db25516` "WP-H1 Hodge-center screen — no numerical contradiction" [GIT]
- **What was actually established:** a corrected split-injection theorem and a representation-level necessary condition. NOT established: any contradiction — 40 channels survive, so the screen obstructs nothing.
- **Aliases:** WP-H1; Path D D1 (per WORK's merge); HAND `R31`; RES `RES-28`; GIT `H1`
- **Provenance:** WP-H1 tasks 1–6; `certificates/hodge_centers/` (`character_screen.g`, `character_screen.json`, `verify.py`).
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` reports a claimed **strengthening**: `H^{1,0}(E_t)≅sgn` under the residual `S3` ⇒ "the 55 fixed elliptics cannot supply `H^{2,1}(X)`"; also that the global equivariant IJ-torsor is trivial (neutralized by a degree-1 invariant cycle `z=Σ[L_t]−18h²`), that the genuine IJ object for the pair `(X,t)` is a Prym of a genus-4 double cover, and that `J(X)^t ~ E₋₁₁³` while the first live bridge curve `(m,d)=(1,7)` has genus 55 — so "the character-valued Jacobian obstruction does not kill the first live family". Final verdict there: "no stronger invariant of the abstract fixed locus alone is likely to work."
- **Pointers:** `REPAIR.md` §§7–8, §15; `certificates/hodge_centers/HODGE_CENTER_NECESSITY.md`; `WORKORDER_STRATA_LIFTING_BLOCKERS.md` Part VI WP-H1; `CURRENT_PATHS.md` repair-summary line 48
- *Lenses 6/7 (GIT, CERT, HAND, RES, STAT, WORK); confidence certain. Possibly-same-as [E10](#e10) — kept separate.*

---

<a id="e20"></a>
### E20 — I — Hermitian five-plane intersection theory

- **Target:** positive/negative via arithmetic invariants — study the common zero locus of the five Hermitian sections on `SB_2(A) ≅ P²_D` using **intersection theory** rather than direct elimination; look for a "point-sensitive" invariant (Chow–Witt Euler class, Witt-group obstruction, unramified cohomology, canonical dimension/incompressibility, Hermitian Euler class) beyond the ordinary Chow class.
- **Justification:** The ordinary Chow class cannot see rational points; a point-sensitive refinement would decide the common-line problem of E07/E08 without solving it.
- **Method:** analytic
- **Record type:** proposal/unrun
- **Thread:** T4 — Pfaffian / fixed-frame / common-line
- **Verification class:** PROPOSAL-UNRUN — a fully specified Elo route (`WORKORDER_ELO_TEN_PATHS.md` Path I) with no execution and nothing to verify.
- **Status:** UNRESOLVED/UNRUN — defined with exits, never dispatched to a verdict.
  - Ranked "structural", Elo 1473; decision exits `N-I`, `P-I`, `I-STOP` — none resolved [WORK, `WORKORDER_ELO_TEN_PATHS.md` Path I]
- **What was actually established:** nothing. The route exists as a specification only.
- **Aliases:** Path I (Elo #7); exits `N-I`, `P-I`, `I-STOP`
- **Provenance:** I1 identify point-sensitive invariant (planned). No external session matches.
- **Pointers:** `WORKORDER_ELO_TEN_PATHS.md` (Path I, ranked #7)
- *Lenses 1/7 (WORK) — **single-lens**; confidence certain as a stated route, no execution evidence.*

---

<a id="e21"></a>
### E21 — J/J2 — Direct essential/canonical-dimension invariant; base-locus Prym countermodel

**Conflict (route content) — ADJUDICATED-SPLIT (2026-08-03).** This entry
bundles two distinct programs sharing only the letter J. The Elo "Path J"
charter (candidate-invariant survey; task list and exit vocabulary
`N-J`/`J-CANDIDATE`/`J-STOP`, "theory watch", never run) and Goal J /
`J_BASELOCUS_PRYM` (executed fixed-centre Albanese–Prym obstruction; gates
`J0–J4`, exit `J2-UNRESTRICTED-COUNTERMODEL-EXTENDS`) share nothing in task
list or exit vocabulary, and no document anywhere asserts their identity;
the earlier provisional-identity claim is withdrawn (see conflict 11). They
are recorded below as sub-records **E21a**/**E21b** under this one entry and
anchor — cite each individually as `[E21a]`/`[E21b]`, not bare "E21" or "J".

---

**E21a — Elo "Path J": direct canonical-dimension invariant survey (unexecuted).**

- **Target:** negative (proposed) — prove `ed_C(G)=4` directly via a
  cohomological / canonical-dimension / motivic invariant that survives
  every 3-dimensional compression; audit candidate invariants (cohomological
  invariants, equivariant Chow groups and Steenrod operations, canonical
  dimension/incompressibility, motives of generic projective representations,
  unramified cohomology) against four required criteria — degree; value on
  the generic `G`-torsor; why it must vanish on every field of transcendence
  degree at most three or every threefold compression; whether existing
  subgroup restrictions already force it to vanish — before any candidate
  proceeds.
- **Justification:** A single invariant that cannot drop under compression
  would settle `ed_C(G)=4` outright.
- **Method:** analytic
- **Record type:** proposal/unrun
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** PROPOSAL-UNRUN — a fully specified Elo route
  (`WORKORDER_ELO_TEN_PATHS.md` Path J) with no execution and nothing to
  verify.
- **Status:** UNRUN (theory watch) — defined with exits, never dispatched to
  a verdict.
  - Ranked #10/10, Elo 1379, queue status "theory watch"; decision exits
    `N-J`, `J-CANDIDATE`, `J-STOP` — none resolved [WORK,
    `WORKORDER_ELO_TEN_PATHS.md` Path J]
- **What was actually established:** nothing. The route exists as a Gate-J1
  candidate-invariant-audit specification only; no candidate was ever listed
  or scored against the four required criteria.
- **Aliases:** Path J (Elo #10); exits `N-J`, `J-CANDIDATE`, `J-STOP`
- **Provenance:** J1 candidate-invariant audit (planned). No external
  session matches.
- **Pointers:** `WORKORDER_ELO_TEN_PATHS.md` (Path J, ranked #10)
- *Lenses 1/7 (WORK) — **single-lens**; confidence certain as a stated
  route, no execution evidence.*

---

**E21b — Goal J / `J_BASELOCUS_PRYM`: fixed-centre Albanese–Prym obstruction (executed).**

- **Target:** negative — realized as an equivariant resolution of the
  landing covariant's base locus with analysis of the resulting Prym
  factors, testing whether an unrestricted point-sensitive invariant on that
  resolution obstructs the generic twist.
- **Justification:** If the base-locus resolution's unrestricted invariant
  cannot vary across the family, it settles `ed_C(G)=4`; this packet tests
  that directly rather than surveying candidates in the abstract (E21a's
  unrun charter).
- **Method:** analytic (with CAS resolution/Prym computation)
- **Record type:** obstruction
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** ALGEBRAIC-RECOMPUTE (`J_BASELOCUS_PRYM`).
- **Status:** TERMINAL — the unrestricted invariant admits an extending countermodel; no point-sensitive invariant found.
  - `J2-UNRESTRICTED-COUNTERMODEL-EXTENDS` [DIR, `goal_runs_after_35fa/J_BASELOCUS_PRYM/STATUS.md`]
  - **Structural content of the packet (recorded 2026-08-03; previously omitted).** From `goal_runs_after_35fa/J_BASELOCUS_PRYM/` (`STATUS.md`, `FIXED_CENTRE_1MOTIVE.md`, `POLARIZATION_ISOGENY.md`, `D_COUNTERMODEL_AUDIT.md`, `BASE_IDEAL_CONSTRAINTS.md`): for **any** hypothetical primitive landing covariant there is an equivariant log resolution of its base ideal whose centre has stabilizer `C₂`, orbit size **330**, six `S₃`-permuted fixed components, and normal eigenranks `(1,2)`. The blowup contribution splits off a copy of `H³(X,ℚ)(1)` with exact averaging scalar **198** and a **CM discriminant −11** factor tied to the polarization, together with an `S₃`-equivariant quotient carrying the order-three Albanese class of `E_t`. This is real structure about the base locus of any landing covariant, independent of the countermodel that terminates the route.
  - Bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger; STAT notes "content entirely unknown from this lens"; this citation predates the E21a/E21b split and its bundling target is unclear — treated as background only, not attributed specifically to either sub-record].
- **What was actually established:** (i) that the unrestricted invariant does not obstruct (a countermodel extends); (ii) the base-locus structure theorem above — an equivariant log resolution of any primitive landing covariant's base ideal with `C₂`-stabilized centre, orbit size 330, six `S₃`-permuted fixed components, normal eigenranks `(1,2)`, an `H³(X,ℚ)(1)` summand with averaging scalar 198 and CM discriminant −11, and an `S₃`-equivariant quotient carrying `E_t`'s order-three Albanese class. NOT established: any statement about restricted or point-sensitive invariants — that survey is E21a's unrun charter, not this packet's target.
- **Aliases:** Goal J; `J_BASELOCUS_PRYM`
- **Provenance:** `goal_runs_after_35fa/J_BASELOCUS_PRYM`.
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_J_FIXED_CENTRE_PRYM.md` (added by `fa543e2`; indexed in `3569d63`); its Prym/one-motive analysis is also reported in § `progress-on-klein-cubic-6a705563.md` as "decisively demoted — should not be redispatched unchanged".
- **Pointers:** `goal_runs_after_35fa/J_BASELOCUS_PRYM/STATUS.md`
- *Lenses 2/7 (DIR, STAT — STAT's bundled content is unknown from this
  lens); confidence certain as the executed program.*

---

<a id="e22"></a>
### E22 — KLS — Kraft–Loetscher–Schwarz self-covariant landing framework

- **Target:** general framework, both directions — (positive) seek a primitive rank-4 self-covariant `q:W→W` whose Gauss-map/adjugate structure lands equivariantly on the Klein cone; equivalently (KLS theorem) `ed(G)=3` iff some nonzero homogeneous self-covariant `W→W` has identically zero Jacobian determinant; (negative) prove no minimal landing self-covariant exists (`h=1`, `ed(G)=4`) via the image hypersurface `H=V(F)`, the contracted-gradient gcd `h`, log-canonicity of the induced foliation, vertical/nonnormal divisor geometry, and a minimality-to-conductor reduction.
- **Justification:** The KLS criterion is an exact iff for the headline; the negative branch would give `ed(G)=4` from birational geometry alone, with no degree search.
- **Method:** mixed (birational geometry / foliation theory + CAS sweeps)
- **Record type:** construction / obstruction (dual — the KLS criterion is an exact iff, worked from both sides)
- **Thread:** T2 — degree ladder
- **Verification class:** ALGEBRAIC-RECOMPUTE (`KLS_MINIMALITY`).
- **Status:** CONFLICT → best reconciliation: the *minimality-to-conductor reduction* is closed (`KLS2-NO-FINITE-REDUCTION`) and the A5-quadric/P22 branch is closed; the framework as a whole remains **open but unauthorized for further large computation** pending a precise theorem.
  - Jacobian-zero criterion: "every such covariant through degree 11 is dominant; no degree cutoff is known"; degree 12 "remains open only on a proper closed exceptional locus" [HAND `R4`]; "Neither the KLS theorem nor finite generation of the covariant module gives an all-degree cutoff; an explicit `S5`-module counterexample rules out that shortcut" [RES `RES-09`]
  - Degree-12: parameter-free top ideal certified (Hilbert function `[1,12,78,364,1365,3647,3726,0,0]`, colength 9,193); "no relative Fitting determinant has yet been produced" [STAT]
  - A5-quadric branch: "now closed"; `q_A5∤h`, `P22∤h` for normal `H`; "does not construct a KLS self-covariant or conductor surface"; nonnormal-conductor branch remains open; degree identity "still forces `d<=9`" for a `P22·k` variant [HAND `R7`, STAT]
  - Minimal-contraction/vertical-divisor: "sharpened without a degree sweep"; "does not prove `h=1`"; "the surviving theorem is genuinely paired: prove LC-minimality ... and a vertical-divisor comparison ... or prove the minimal image canonical directly" [HAND `R8`, RES `RES-10`]
  - `KLS2-NO-FINITE-REDUCTION` [DIR, `goal_runs_after_35fa/KLS_MINIMALITY/STATUS.md`]
  - "The proposed KLS minimality-to-discrepancy reduction does not produce a nontrivial finite list... no proved theorem controls the conductor support" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 4]
  - "No large KLS computation is authorized until the analyst supplies a precise theorem" [WORK, `WORKORDER_CAS_HEADLINE.md` §8]; exits `KLS-FINITE-TABLE-CLOSED`, `KLS-COUNTERMODEL`, `KLS-NO-THEOREM`, `N-H`, `H-UNIQUE`, `H-COUNTERMODEL` — none resolved
  - "the headline remains open... `h=1` remains unproved" [RES `RES-10`]
  - `0d16f55` "add theorem-first KLS continuation goal"; `6737bec` "add goal-mode KLS minimality-conductor route" [GIT]
  - **Conflict (terminality):**
    - *Side 1 (08-02 ledger, offline):* KLS/KLS2 `TERMINAL — Prior local obstructions/witnesses exhausted — Background only`.
    - *Side 2 (`CURRENT_PATHS.md` 07-29/07-30 + `KLS_MINIMALITY/STATUS.md`):* several branches still open — foliation LC-minimality / vertical-divisor gate; nonnormal-conductor branch; degree-12 Jacobian exceptional locus; the unsolved flat-connection PDE. The run `STATUS.md` records only `KLS2-NO-FINITE-REDUCTION`, which closes the *reduction*, not the framework.
    - Per Binding rule 1, run-level `STATUS.md` and `CURRENT_PATHS.md` outrank the offline ledger: the framework is **not** globally terminal.
- **What was actually established:** all self-covariants through degree 11 are dominant (so no KLS witness there); the degree-12 top ideal is certified parameter-free; the A5-quadric/P22 branch is closed for normal `H`; the minimality-to-conductor reduction produces no finite list. NOT established: `h=1`; any all-degree cutoff (explicitly refuted by an `S5`-module counterexample); the degree-12 exceptional locus.
- **Aliases:** KLS / KLS2; `KLS_MINIMALITY`; Path H (Elo #6); Attempt 4; HAND `R4`, `R7`, `R8`; RES `RES-09`, `RES-10`; STAT "Degree-12 mixed Jacobian problem"
- **Provenance:** `goal_runs_after_35fa/KLS_MINIMALITY`; `tmp/kls_minimal_contraction_attack`, `kls_vertical_divisor_geometry`(+audit), `kls_nonstable_vertical_orbits`(+audit), `kls_a5_logarithmic_divisor`, `kls_wstar_first_integrals`, `kls_degree28_stein_fixed_point`, `kls_a5_linearized_pencil_obstruction`(+audit), `kls_a5_conductor_surface_feasibility`(+audit), `kls_actual_conductor_geometry`, `kls_proper_multiple_structure`, `kls_structural_successor`, `kls_global_foliation_theorem`, `kls_discrepancy_next_gate`(+audit), `kls_divisor_ansatz`, `kls_residue_next`, `kls_first_jet_two_fiber`, `kls_first_jet_three_fiber`, `kls_full_support_p9_msolve`, `kls_structural_audit`; `tmp/degree{10,11,12}_jacobian`, `degree12_jacobian_structural`, `relative_kls_chart`, `relative_kls_hyperplane`.
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_KLS_MINIMALITY_CONDUCTOR.md` (added by `6737bec`; indexed in `3569d63`); § `progress-on-klein-cubic-6a705563.md` demotes KLS minimality ("should not be redispatched unchanged"); § `klein-cubic-threefold-psl-6a6b6514.md` independently restates "KLS Jacobian-vanishing covariants excluded only through degree 11, degree 12 open on a proper exceptional locus".
- **Pointers:** `goal_runs_after_35fa/KLS_MINIMALITY/STATUS.md`; `CURRENT_PATHS.md` 2026-07-29 items 1–3, Ranking B item 2; `RESOLUTION.md` 07-29 items 1–3 / 07-30 item 1; `SPEC.md` item 10; `WORKORDER_CAS_HEADLINE.md` §8; `WORKORDER_ELO_TEN_PATHS.md` (Path H)
- *Lenses 6/7 (DIR, GIT, HAND, RES, STAT, WORK); confidence certain.*

---

<a id="e23"></a>
### E23 — L1 — Full polar range recursion

- **Target:** infrastructure/positive — construct a universal finite formal-recursion certificate valid for **all odd normal orders**, completing the polar-expansion range used by the Path G lifting tower.
- **Justification:** The Path G lifting tower needs coefficient recursions past the historical `3m+3` boundary; without the full range, every all-degree lifting statement is truncated.
- **Method:** CAS
- **Record type:** infrastructure
- **Thread:** T2 — degree ladder
- **Verification class:** ALGEBRAIC-RECOMPUTE (`L1_FULL_POLAR_RANGE`).
- **Status:** PASS — universal finite formal recursion certified across the full odd-order range.
  - `L1-FULL-RANGE-PASS` [DIR, `goal_runs_after_7030dd/L1_FULL_POLAR_RANGE/STATUS.md`]
- **What was actually established:** a complete universal coefficient recursion for `F(p)` over the full odd-order range. NOT established: anything about existence of `p` itself; this is tower infrastructure.
- **Aliases:** `L1_FULL_POLAR_RANGE`; possibly WP-L1 "universal polar expansion" (`WORKORDER_STRATA_LIFTING_BLOCKERS.md` Part II) — identification medium-confidence.
- **Provenance:** `goal_runs_after_7030dd/L1_FULL_POLAR_RANGE`; candidate alias run WP-L1 → `certificates/lifting/polar_expansion.json`, `polar_expansion.py`, `verify_polar_expansion.py`.
  - `source: external-chatgpt` — `sessions_batch1.md` § `mattrobball-unirational-task-6a7054e2.md`, commit `82de03d` "Klein cubic: complete L1 full polar recursion" → `goal_runs_after_7030dd/L1_FULL_POLAR_RANGE/`. Claimed content: complete recursion of `F(p)` for every odd initial normal order `m` and degree `d≥m` through terminal order `3d`; even-`δ` coefficients vanish by involution parity; odd `δ≤q` are isolation equations `L_δ(b_{m+δ})=-R_δ`; odd `δ>q` are terminal compatibility equations `T_δ=C_δ=0`. Computed with pure exact `fractions.Fraction` arithmetic, **no external CAS**. The session also had to disambiguate what "packet L1" meant before starting.
  - **Name collision:** `sessions_batch1.md` § `github-repo-task-update-6a7054fb.md` independently coins a *different* "L1" = "ambient self-map rigidity". See conflict list.
- **Pointers:** `goal_runs_after_7030dd/L1_FULL_POLAR_RANGE/STATUS.md`; `WORKORDER_STRATA_LIFTING_BLOCKERS.md` Part II; `certificates/lifting/`
- *Lenses 1/7 for the `L1` label (DIR) — **single-lens**; WP-L1 identification adds WORK/CERT circumstantially. Confidence certain for the run and PASS, medium for the WP-L1 identity.*

---

<a id="e24"></a>
### E24 — M / M2 / M3 — Sarkisov link / degree-3 del Pezzo fibration section search

- **Target:** positive/structural — construct an exact type-I Sarkisov link (blow up a smooth plane cubic on the Schur generic Klein twist) to a relative degree-3 del Pezzo fibration over `P¹` with multisections of degree 3 and 55 (hence index 1), then search in Cox coordinates for an actual **rational section** (headline-positive) as opposed to only a degree-4 multisection (which proves index 1 only) (the 'dP3' here is the fibration target of the Sarkisov link — unrelated to Problem F's del Pezzo obstruction, see the Nomenclature glossary).
- **Justification:** A rational section of the dP3 fibration gives a `K_Schur`-point directly, closing the headline positively; the link is explicit and the search is finite-dimensional in Cox coordinates.
- **Method:** mixed (birational geometry + CAS Cox-ring search)
- **Record type:** construction
- **Thread:** T5 — Schur-source and curve constructions

| Subroute | Exact target | Last outcome | State | Governing artifact |
|---|---|---|---|---|
| M/M2 | exact type-I Sarkisov link (blow up a plane cubic on the Schur generic Klein twist → degree-3 dP fibration over `P¹`) | `M2-EXPLICIT-LINK-PASS` | terminal PASS | `goal_runs_after_35fa/M_SARKISOV/STATUS.md` |
| M3 multisection | integral finite-flat degree-4 multisection (proves index 1 only) | `M3-INTEGRAL-DEGREE4-MULTISECTION` | terminal (multisection only, not a section) | artifact pointer `M3_SARKISOV_SECTION` |
| M3 section question | a `K_Schur`-rational section (headline-positive), vs. multisection only | not selected by the multisection packet | UNDECIDED; lowest section gate `C_012(K)` | `DIRECTOR_REVIEW_AFTER_BD610A.md` §2.2; branch packet `M3_SARKISOV_SECTION` (unmerged) |
| M3B residual G1 | residual Galois-descent modular nonemptiness check | `M3B-G1-MODULAR-NONEMPTY-PASS` | residual PASS | `goal_runs_after_bd610a/M3B_SECTION_RESIDUAL_G1_20260802` |
| Branch section-component packet | classify nonexceptional degree-1/2/3 sections; 55-line splitting-field structure | `M3-SECTION-COMPONENT-PASS` | branch-only; `verify_all.py` references a missing `verify_section_search.py`; archived | `external_packets/m3-sarkisov-section-residual_M3_SARKISOV_SECTION/` (branch `agent/m3-sarkisov-section-residual`, head `6fdac74`) |

- **Verification class:** ALGEBRAIC-RECOMPUTE (`M_SARKISOV`, `M3B`).
- **Status:** OPEN-NARROWED — the explicit Sarkisov link and the degree-4 integral multisection are terminal PASSes; the rational-section question remains open as a residual Galois-descent route.
  - `M2-EXPLICIT-LINK-PASS` [DIR, `goal_runs_after_35fa/M_SARKISOV/STATUS.md`]
  - `M3-INTEGRAL-DEGREE4-MULTISECTION` (terminal, multisection only); `M3B-G1-MODULAR-NONEMPTY-PASS` (residual); "K-section open" [WORK]
  - "A rational section... would... close the headline positively. The current packet does not select the section branch. A degree-four multisection... proves only index one and cannot be promoted to a section" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §2.2]
  - "OPEN — Multisection closed; section remains — Possible residual Galois route" [STAT, 08-02 ledger]
  - `96195e8` "finish M3 residual section close-out"; `139ab6c` "M3: restore recursive packet seal"; `5167255` "M3: restore residual gate" [GIT]
  - "prior terminals" for M/M2 [WORK, `REMAINING_GOALS_NOTE.md` "Already terminal" table]
  - **Conflict (referent of "M3 multisection closed"):**
    - *Side 1 (STAT):* cannot disambiguate whether it refers to the Fable `A₄` multisection-index-3 theorem or the Schur ten-fibration no-section theorem.
    - *Side 2 (WORK):* the Sarkisov description (degree-3 dP fibration, degree-3 and degree-55 multisections) is more specific and is adopted by the canonical ledger.
  - **Unmerged-branch packet (recorded 2026-08-03, provenance `branch-only (unmerged)`).** `goal_runs_after_bd610a/M3_SARKISOV_SECTION/` exists **only** on branch `agent/m3-sarkisov-section-residual` (head `6fdac74`) — **not on main**, and **distinct** from the merged `goals_after_bd610a/M3_SARKISOV_SECTION` close-out packet. Exit `M3-SECTION-COMPONENT-PASS`. Proved (at its stated boundary): exceptional sections are exactly the points of the center cubic `C_012`; nonexceptional sections of `H`-degree 1 and 2 are impossible (binding no-line and no-conic theorems); the first nonexceptional degree-3 section scheme has a horizontal projective four-dimensional geometric component (standard-smooth points mod 23 and 67); the 55-line splitting field has Galois group `PSL_2(F_11)` and contains **no** quartic subfield; all six pair orbits of the 55 horizontal line sections have non-singleton fibrewise-secant images (min image cardinality 55 at both split primes). Not proved: existence or nonexistence of a `K`-rational section; an explicit integral degree-4 multisection. Lowest section gate: `C_012(K)`. Note the interaction with the merged dichotomy: the no-quartic-subfield theorem forces any integral quartic to generate an extension not contained in the 55-line field; archived snapshot: `external_packets/m3-sarkisov-section-residual_M3_SARKISOV_SECTION/` (branch head `6fdac74fc2c850dd062288691bf6daba5ec0228d`); caveat: the packet's `M3-SECTION-COMPONENT-PASS` exit is not independently re-derived by any script present in the snapshot — `verify_all.py` references a missing `verify_section_search.py`; only the group-theoretic facts are recomputed (`verify_residual_galois.py`).
- **What was actually established:** the explicit type-I link `X_T ← Bl_{C012}(X_T) → P¹_K`; an integral finite-flat degree-4 multisection, claimed unconditional; index one. NOT established: a rational section, a `K_Schur`-point, or any positive unirationality bridge. The nonemptiness of the quartic locus alone provably cannot select the section branch.
- **Aliases:** `M_SARKISOV`, `M3_SARKISOV_SECTION`, `M3B_SECTION_RESIDUAL_G1_20260802`; STAT "M3 — section vs multisection"; WORK "R/M-stub"; GIT `M3`
- **Provenance:** `goal_runs_after_35fa/M_SARKISOV`; `goal_runs_after_bd610a/M3B_SECTION_RESIDUAL_G1_20260802`; artifact pointer `M3_SARKISOV_SECTION`.
  - `source: external-chatgpt` — `sessions_batch1.md` § `finish-m3-section-6a705514.md`; PR #6 merged as `96195e8`. Authorized exit `M3-INTEGRAL-DEGREE4-MULTISECTION`, `section_question: UNDECIDED`, `headline: OPEN`. Sharpened dichotomy: section ⟺ imprimitive quartic; under no-section every integral quartic must be primitive (`A4` or `S4`), have irreducible cubic resolvent, and span `P³`. The session also **repaired repo corruption**: 42 merge-conflict artifact lines removed across `COMPLETION_AUDIT.md`, `STATUS.md`, `SEAL.json`, `verify_all.py`; restored `SECTION_RESIDUAL.md`, `residual_gate.json`, their seal hashes, and the `verify_residual_gate.py` call. Self-disclosed limitation: "The complete repository-level M3 replay was not executed in this environment."
  - `source: external-chatgpt` — `sessions_batch2.md` § `finish-g-g2-theorem-6a705522.md` pivoted to M3 late and built a PSL(2,11) secant-line/residual-covariant computation on branch `agent/m3-sarkisov-section-residual`, but the thread trails off with **no confirmed merge**.
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_M_SARKISOV_BIRATIONAL_MODELS.md` (added by `ee30036`; indexed in `3569d63`); § `progress-on-klein-cubic-6a705563.md` records the link as established with the disjunction unresolved.
- **Pointers:** `goal_runs_after_35fa/M_SARKISOV/STATUS.md`; `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 3, §2.2, §4 Rank4; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #8
- *Lenses 4/7 (DIR, GIT, STAT, WORK); confidence certain.*

---

<a id="e25"></a>
### E25 — P25 — Degree-25 landing self-covariant (P25R / V / W / X / Y / Z)

- **Target:** positive construction with a negative-emptiness exit — build an exact, primitive, characteristic-zero **degree-25** homogeneous `G`-equivariant landing self-covariant `p:W→W` with `F(p)=0` and generic Jacobian rank 4, via increasingly rigorous finite/global coefficient models, border/Fitting-module presentations, and projective-support decisions (with DVR-properness arguments for emptiness).
- **Justification:** Degree 25 is the first unresolved degree in the landing ladder of [E16](#e16); a covariant there closes the headline positively, and proved emptiness advances the ladder by one rung.
- **Method:** CAS (multiprime linear algebra, border bases, msolve/F4, DVR arguments)
- **Record type:** bounded computation
- **Thread:** T2 — degree ladder
- **Verification class:** mixed — `degree25_tower`, `degree25_rank_k` ALGEBRAIC-RECOMPUTE; `degree25_exact`, `degree25_global`, `degree25_finite_module` PARTIAL-RECOMPUTE.
- **Status:** **OPEN at degree 25 — order-3 branch closed in char 0; other branches modular-only.** (Adjudicated 2026-08-03; supersedes the earlier flat `OPEN/DEFERRED`.) Extensive partial structure; further slices unauthorized; the route is still "not headline without a bridge".
  - **Adjudication (conflict 13), 2026-08-03.** V4's **Theorem 2.12** (`goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/THEOREM.md` §2.3) genuinely closes the **37-dimensional order-three branch in characteristic zero, for all line degrees**. The **order-two and order-≥4** branch exclusions are proved **only over the split fibre `F_67`** — `HANDOFF.md` states its own caveat, "no characteristic-zero exclusion is claimed" (~line 1060). They were, however, **independently audited at that modular level**: a from-scratch audit rebuilt the complete degree-25 space, both jet filtrations, the 56/56 landing span, and the 3124/3124 overlap rank (`HANDOFF.md` ~1061–1066; `tmp/degree25_structural_probe_independent_audit/REPORT.md` — local-only per Binding rule 5). Their correct description is therefore **independently audited, modular-only** — *not* "inherited unverified", the phrasing this entry previously carried.
  - The packet label `DEGREE25-LANDING-EMPTY` **overstates its characteristic-zero scope** and violates Binding rule 2 (modular ranks require an explicit char-0 bridge).
  - The **63-chart P25 route** (`goals_2026-08-01/P25_LANDING_SUPPORT`, `PREPARED_NOT_RUN`) targets the same characteristic-zero binary through an **unreconciled independent presentation** and **remains live**. It is the route that would close the remaining branches in char 0.
  - **The bounded char-0 cutoff is unchanged: through degree 24, with degree 25 partially closed** (order-3 branch in char 0; the remainder modular). Do not restate the cutoff as 25.
  - `P25-TOWER-EMPTY` / `P25-TOWER-SURVIVES`; `P25R0/1/2-*`; `P25X0/1/2-PASS/FAIL/UNDECIDED`; `P25Y-DVR-PASS`; `P25Z-ROW-RANK-746` ("the direct landing row rank is exactly 746"); `P25Z-FINITE-PRESENTATION-LOWER`; `P25W-PRESENTATION-EXACT/ENLARGE/UNDECIDED`; `P25-DEGREE25-EMPTY`; targets `P25-COVARIANT`/`P25-POLYNOMIAL` **not reached** [WORK]
  - `P25-UNDECIDED`; "63 charts on `D(H_8)`... `PREPARED_NOT_RUN`" [WORK, `REMAINING_GOALS_NOTE.md`]
  - historical 842-row / rank-28 packets "quarantined" and later "retired on mathematical grounds" [WORK, `DIRECTOR_HANDOFF.md`]
  - "P25.1 `P25-TOWER-SURVIVES` — retained as scoped free-fibre/degree-25 continuation"; "dim Z<=15"; "`P^21` a strict nonverdict (`3933 ≤ rank ≤ 7910`)"; "No `P^22` or successor slice is authorized" [HAND `R3`]
  - "OPEN/DEFERRED — Finite chart computation only — Not headline without bridge" [STAT, 08-02 ledger]; "Degree 25 remains open" [STAT, `CURRENT_PATHS.md`]
  - `19da967` "P25W — Stage A kernel incidence EMPTY"; `841005b` "P25Z.3 — direct landing row rank EXACTLY 746"; `2140419` "P25V.0 — degree-four closure FAILS"; `6096429` "V2 Track P25Y — `P25Y-DVR-PASS`"; `5e72d8e` "V2 Track P25X — `P25X0-PASS`, `P25X1-FAIL`; the 842 basis is not recovered" [GIT]
  - **Conflict (degree-25 emptiness) — ADJUDICATED 2026-08-03, split resolution:**
    - *Side 1 (canonical ledger, run artifacts):* the degree-25 landing locus is **neither populated nor proved empty**; `P25-UNDECIDED`; 63 charts `PREPARED_NOT_RUN`.
    - *Side 2 (`sessions_batch4.md` § `2026-08-03-problem-e-review.md`):* claims exit `DEGREE25-LANDING-EMPTY` — "no homogeneous degree-25 landing self-covariant in char 0" — derived as a corollary of the V4 simultaneous-normal classification, and committed under `goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/DEGREE25_COROLLARY.md` (added by `ac5e899`, "Close degree-25 landing stratum using V4 theorem"; `72147bd` only modified `STATUS.md`).
    - *Resolution:* **neither side is wholly right.** Side 2's char-0 closure is real **for the order-three branch only** (Theorem 2.12, all line degrees, `A4`-equivariant, involution-plane order `m=1`, exact triple-line order three). Side 1's "not proved empty" is right for the **order-two and order-≥4** branches, which are proved only over the split fibre `F_67` — but those branches were **independently audited at that modular level**, so they are *modular-only*, not unverified. `DEGREE25_COROLLARY.md` is explicitly a "Bounded corollary" and states: "It is not an all-degree theorem and does not settle equivariant unirationality." Net state: degree 25 is **partially closed**; the exit label `DEGREE25-LANDING-EMPTY` overstates its char-0 scope; the char-0 bounded cutoff stays at 24; the headline stays OPEN. See conflict 13.
- **What was actually established:** `dim Z ≤ 15`; direct landing row rank exactly 746; a DVR-properness pass; Stage-A kernel incidence empty; `P^21` a strict nonverdict (`3933 ≤ rank ≤ 7910`); the 842-row basis is not recoverable; and — via V4 Theorem 2.12 — **characteristic-zero emptiness of the order-three branch of the degree-25 filtration, for all line degrees**. NOT established: a degree-25 covariant; char-0 emptiness of the order-two and order-≥4 branches (audited over `F_67` only, no char-0 bridge); therefore not degree-25 emptiness as a whole. Per `audit_a1` (see [E03](#e03)), several P25 labels also carry SCOPE-DRIFT verdicts: `P25Z-FINITE-PRESENTATION` (F3), `P25Y-DVR-PASS`'s Molien claims (F5), the stale "746 lower bound only" phrasing (F6), and `P25X0-PASS`, which is titled characteristic-zero but is in fact multiprime (F7).
- **Worker-root, unpromoted/unverified** (shared with [E09](#e09)): `goals_after_bd610a/P25_COV_SUPPORT` claims exact `F_89` ranks 690/56/746; multiplication rank 27583; kernel dim 19; a coupled degree-4 relation space of rank 29880; a 25200-state transition-stable border hull; and contraction rank 75/75 on all 7770 three-coordinate q-planes — none of these figures appear in any packet. See Goal-wave worker roots.
- **Aliases:** P25; P25.1–P25.4; P25R, P25V, P25W, P25X, P25Y, P25Z; `P25W-RankK`, ROW-RANK, SUPPORT-F4, TOWER, MOLIEN; HAND `R3`; CERT bucket `P` (`degree25_*`)
- **Provenance:** P25.1–P25.4 (CAS_HEADLINE); P25R.0–P25R.3 (REVISED); P25X.0–P25X.2 (DECISION/_V2); P25Y.1–P25Y.4 (AFTER_5E72D8E); P25Z.1–P25Z.3 (T9_P25Z); P25W.0–P25W.3 (T10_P25W_C2); P25V.0–P25V.3 (T11_P25V_C3); WP-B1, WP-6; `tmp/m1_relative_border_*`, `char0_lift_p19_d5`, `char0_lift_p20_d5`, `tmp/degree25_structural_probe`; `certificates/degree25_{exact, global, tower, finite_module, direct_support, support_f4, rowrank, rank_k, molien, p25v, p25w}`.
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `Goal P25` (`28faa47`) and `GOAL_P25_ENLARGED_CLOSURE_AND_SUPPORT.md` (added by `27fcc1b`; indexed in `37d61c1`); audited returns `P25V-PRESENTATION-ENLARGED` ("strongly supported, not canonical — decisive counts 4140/315 read from producer JSON, not independently recomputed") and `P25V-SUPPORT-UNDECIDED` (faithful).
  - `source: external-chatgpt` — `sessions_batch3.md` § `progress-on-klein-cubic-6a705563.md` issues a correction: "`K₁/(R₊K₁)` is NOT the primitive-covariant quotient — degree 25 must be rebuilt from the full 746-dim relation space."
- **Pointers:** `WORKORDER_CAS_HEADLINE.md` §5; `WORKORDER_CAS_HEADLINE_REVISED.md` §3; `WORKORDER_CAS_T9_P25Z.md`; `WORKORDER_CAS_T10_P25W_C2.md`; `WORKORDER_CAS_T11_P25V_C3.md`; `DIRECTOR_HANDOFF.md`; `HANDOFF.md` repair table line 41 and ~1060–1066 (modular-scope caveat + independent audit); `CURRENT_PATHS.md` Ranking A item 1; `goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/THEOREM.md` §2.3; `goals_2026-08-01/P25_LANDING_SUPPORT` (63 charts, `PREPARED_NOT_RUN`); `certificates/audit_a1/AUDIT_FINDINGS.md`
- *Lenses 6/7 (GIT, CERT, HAND, RES, STAT, WORK); confidence certain.*

---

<a id="e26"></a>
### E26 — Pfaffian — Pfaffian/Morita quaternionic descent bridge (Brauer index-2 / Hermitian gate)

- **Target:** positive construction + structural reduction — via Tschinkel–Zhang's Pfaffian bridge `X ↔ F14`, prove the generic projective Schur boundary class is nonzero of **period and index exactly 2** in `Br(K_proj)`, so the `P(V6)`-twist is a nonsplit non-stably-rational Severi–Brauer fivefold; pass to 2-planes to get `SB_2(A_proj)=P²_{D_proj}` (rational), reducing the headline to a **common isotropic right `D`-line for five Hermitian forms**; construct explicitly a reduced-rank-two `σ`-self-adjoint idempotent `e=(a²-c₁(a)a+c₂(a)1)/c₂(a)` by solving `c₃(a)=0, c₂(a)≠0`; separately search for matched polynomial covariants landing in the `F14` Pfaffian cone.
- **Justification:** This is the structural parent of the whole C-family: it converts the headline into an isotropy problem over an explicit quaternion algebra, and the target space `P²_D` is rational.
- **Method:** mixed (Brauer/algebra-with-involution theory + CAS)
- **Record type:** construction / reduction (dual)
- **Thread:** T4 — Pfaffian / fixed-frame / common-line
- **Verification class:** NO-VERIFIER — `certificates/pfaffian_point` hosts the `FAIL-SCOPE` bridge audit as an analytic audit document; there is no machine verifier by nature.
- **Status:** OPEN-AT-THE-COMMON-LINE-GATE — the Brauer reduction is a solid proved theorem and the anisotropic-member escape is closed; the abstract idempotent exists but its `K_proj` coordinates do not, and the bridge from it to a Klein point is scope-failed.
  - "now proved nonzero"; "generic Brauer class has period and index exactly two"; "anisotropic-member certificate is now impossible"; residual "common isotropic right D-line" gate "open" [HAND `R9`]
  - "every individual Hermitian member is isotropic... only simultaneous common-line isotropy remains open"; "no explicit `K_proj` coordinates, quaternion corner, or common isotropic line are known" [RES `RES-07`]
  - "Matched polynomial covariants into the `F14` cone are excluded only through degree 15"; "degree 16 remains open for the Pfaffian target" (80-dim space, 1,313 necessary quadrics, solver times out without leading ideal) [HAND `R6`, RES `RES-07`]
  - "known abstractly to have a `K_proj`-point ... but its coordinates in the installed basis are not known" [HAND `R10`]
  - PRE/POST-REPAIR precision: per `REPAIR.md` §13 this must be read strictly — the abstract `K_proj`-point refers "only to the auxiliary Pfaffian characteristic cubic in `Sym(A,σ)`, **not** to a point of `F_{14,T}` or of the generic Klein twist"; the `FAIL-SCOPE` bridge audit is authoritative [HAND `R10`, STAT]
  - `FAIL-SCOPE`: "idempotent gives a point of auxiliary `P^2_D`, not of `F_{14,T}`" [WORK, Attempt 1]
- **What was actually established:** period and index exactly 2 for the generic Brauer class (a proved theorem); the reduction to a common isotropic right `D`-line; isotropy of each individual Hermitian member; exclusion of matched covariants into the `F14` cone through degree 15. NOT established: the common line; explicit `K_proj` coordinates; any bridge from the auxiliary characteristic cubic to `F_{14,T}` — that step is `FAIL-SCOPE`.
- **Aliases:** Attempt 1 (Pfaffian–Morita idempotent); SPEC task **E4**; HAND `R6`, `R9`, `R10`; RES `RES-07`; CERT `certificates/pfaffian_point`
- **Provenance:** `tmp/pfaffian_generic_schur_audit`, `pfaffian_explicit_descent`(+audit), `pfaffian_representation_alignment`, `pfaffian_25plus11_descent`(+audit), `quadratic_grassmannian_covariant`, `pfaffian_rank2_idempotent_attack`(+hostile audit), `pfaffian_binary_cubic_attack`(+geometric audit), `pfaffian_ternary_cubic_triage`(+hostile audit), `pfaffian_minimal_ternary_model`(+audit), `pfaffian_depressed_torsor_next`, `pfaffian_torsor_valuation_attack`, `pfaffian_depressed_alpha_r`, `pfaffian_alpha_local_kummer`; `tmp/fano14_twist`, `fano14_degree12`, `fano14_degree16`; Attempt-1 gates 1B (CFOSS w1 pin, implication-chain bridge audit), 1C (quaternion-corner reduction), 1D (exact coordinate extraction). No external session executed this packet directly.
- **Pointers:** `certificates/pfaffian_point/{BRIDGE_AUDIT.md, CFOSS_W1_INPUT.md, IDEMPOTENT_TO_KLEIN_POINT.md, quaternion_corner.json}`; `REPAIR.md` §13; `HANDOFF.md` "Strongest proved progress" item 7; `SPEC.md` item 8 / task E4; `CURRENT_PATHS.md` 2026-07-30 item 1
- *Lenses 5/7 (CERT, HAND, RES, STAT, WORK); confidence certain. **Merged** with Attempt 1 of [E05](#e05) on two-lens verbatim agreement.*

---

<a id="e27"></a>
### E27 — Q / Q3 — Schur index-one descent obstruction / primitive quartic resolvent

- **Target:** negative/structural — decide a "Schur point" binary via a descent-obstruction audit on the Schur index-one locus (prove the index-one locus contains a rational point, or obstruct it via a valuation); when the standard descent-obstruction package proved insufficient, replace it with a **stable-cubic/resolvent descent from a primitive quartic resolvent** (Q3) and prove any resulting obstruction transfers to the headline.
- **Justification:** The generic Schur twist already carries a degree-one zero-cycle; a surviving descent obstruction would show the cycle cannot be effectivized, giving the negative headline.
- **Method:** mixed (descent arithmetic + CAS)
- **Record type:** obstruction
- **Thread:** T5 — Schur-source and curve constructions; also T7 — cohomological/motivic obstruction sweep
- **Verification class:** mixed — `Q_SCHUR_INDEX_ONE` (+13 subpackets) and `Q3` ALGEBRAIC-RECOMPUTE; the descent-obstruction run `Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802` is **CONSISTENCY-ONLY** (git-blob hashes and markers only), matching that session's own disclosure.
- **Status:** PARTIAL-OPEN — the standard obstruction package is audited and found insufficient (scoped PASS); Q3's Schur-monodromy gate PASSES but the quartic-resolvent descent has produced no decision.
  - `Q-UNDECIDED` [DIR, `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/STATUS.md`; WORK]
  - `Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS` (scoped pass, the actual exit recorded in `Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802/STATUS.md`); "Q3 preferred" as successor [WORK]
  - Correction: the phrase "descent obstruction completed via valuation" was previously attributed to this run but appears nowhere in that directory's artifacts; it originated in a lens report, not the packet itself, and is removed here.
  - "PARTIAL (`Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS`) — Standard obstruction package insufficient — Q3 stable cubic/resolvent route remains" [STAT, 08-02 ledger]
  - `Q3-SCHUR-MONODROMY-PASS` [DIR, `goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/STATUS.md`]
  - `827f0da` "add descent obstruction close-out packet"; `4e44e73` "seal scoped descent obstruction close-out" [GIT]
- **What was actually established:** broad classes of obstruction are provably neutral — see the session provenance below — so the *standard* package cannot give the negative answer; the Q3 monodromy gate passes. NOT established: `X(K)≠∅` or `=∅`; effectivization of the degree-1 cycle; primitive `A4/S4` quartic descent; intermediate-Jacobian/cycle-moduli torsors; nonlinear/gerbal/point-dependent obstructions.
- **Aliases:** `Q_SCHUR_INDEX_ONE`, `Q_SCHUR_INDEX_ONE_DEGREE6_11_5_20260801_2A6C`, `Q_SCHUR_INDEX_ONE_EXACT_FRAME_20260801_8F3D`, `Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802`, `Q3_QUARTIC_RESOLVENT_STABLE_MAP`; GIT `Q`
- **Provenance:** the five run dirs above.
  - `source: external-chatgpt` — `sessions_batch2.md` § `repo-push-request-6a705556.md`; head commit `4e44e73`; packet `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802/` (`README.md`, `STATUS.md`, `TRANSFER_AND_DESCENT_THEOREM.md`, `OBSTRUCTION_FRONTIER.md`, `audit_payload.json`, `verify.py`, `REPLAY.md`, `SEAL.json`), explicitly a scoped successor leaving the historical `Q_SCHUR_INDEX_ONE/` packet unchanged. Claimed theorems: 2.1 transfer-annihilation (any point-trivializing abelian class with restriction/corestriction is killed by the coprime degrees 3 and 55, using `55-18·3=1`); corollaries killing fixed abelian classes and commutative torsor recipients (Picard/Albanese/Brauer/Amitsur/tori/semiabelian/abelian varieties); 3.1 constant finite nonabelian torsor recipients neutral; 4.1 + 4.2 `π₁^et(X_K̄)=1` via Grothendieck–Lefschetz ⇒ finite étale/fppf descent is geometrically tautological; 5.1 semisimple torsor recipients neutral via Jodi Black (arXiv 1009.4621), with Gordon-Sarney–Suresh (1702.00516) scoping. Packet flags `binary_claim_made: false`.
  - `source: external-chatgpt` — `sessions_batch1.md` § `mattrobball-unirational-task-6a7054e2.md` and § `github-repo-task-update-6a7054fb.md` both accept `Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS` at its stated scope (the latter calling it a "sealed no-go").
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_Q_SCHUR_INDEX_ONE_DESCENT.md` (added by `f182802`; indexed in `3569d63`).
- **Pointers:** the five run dirs; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #7; `CURRENT_PATHS.md` ~line 2187
- *Lenses 4/7 (DIR, GIT, STAT, WORK); confidence certain.*

---

<a id="e28"></a>
### E28 — R / R2 — Rational curves via Pfaffian / elliptic descent (Picard obstruction)

- **Target:** negative obstruction — prove a descent obstruction for the Pfaffian elliptic quintic and its residual quartic components, i.e. rule out the relevant rational-curve constructions on the twist.
- **Justification:** Rational curves through a marked cycle are the standard way to convert index data into a point; obstructing them closes that family of positive constructions.
- **Method:** mixed (elliptic/Picard arithmetic + CAS)
- **Record type:** obstruction
- **Thread:** T5 — Schur-source and curve constructions
- **Verification class:** `R_RATIONAL_CURVES` ALGEBRAIC-RECOMPUTE; the contested `certificates/elliptic_lifting` CONSISTENCY-ONLY (its internal `PROVED_AS_REGRESSION` marker is accepted via hash-check/field-read only).
- **Status:** TERMINAL-OBSTRUCTED — the descent obstruction closes this rational-curve route.
  - `R2-DESCENT-OBSTRUCTED` [DIR, `goal_runs_after_35fa/R_RATIONAL_CURVES/STATUS.md`]
  - "prior terminals" [WORK, `REMAINING_GOALS_NOTE.md` "Already terminal" table] — WORK notes "no mathematical description is given in any document read under this lens"; the content was recovered directly from the packet on 2026-08-03 and is recorded below.
- **What was actually established (recovered 2026-08-03 from `goal_runs_after_35fa/R_RATIONAL_CURVES/STATUS.md`:19–67):**
  - (i) Over the splitting field, the Pfaffian kernel bundle `E_0` has `H⁰(E_0(1)) = V_6^*`, with universal section-zero curve given by `A(x)λ = 0` and the identity `M(x)A(x) = Pf(M(x))·I_6`.
  - (ii) `Pf(M(x))` is a nonzero scalar multiple of the Klein cubic. An **independent good-reduction check** verifies that the resulting curve is a smooth, geometrically integral **elliptic normal quintic**: degree 5, Hilbert polynomial `5t`, tangent dimension 10, `H¹(N_{C/X}) = 0`.
  - (iii) Exact **period-lattice and group-cohomology certificates** give `J(C)^G = 0` and `H¹(G, J[3]) = 0`, so the degree-two Abel–Jacobi torsor has exactly **one fixed point `q_2`**.
  - (iv) The Hilbert fibre twists to `SB(A_proj^op)` with `ind(A_proj) = 2`; hence the selected Hilbert component has **no `K`-point**. That is the obstruction.
- **Explicitly NOT excluded:** unmarked rational quartics and quintics; higher free rational curves; incidence constructions through the degree-55 orbit; the Schur-source route over `K_Schur`.
- **Worker-root, unpromoted/unverified:** `goals_2026-08-01/R_RATIONAL_CURVES_ROOT_JACOBIAN_ZERO` extends the canonical degree-2/3 closure: every geometrically integral K-curve on the twist with genus-zero normalization forces a K-point (degree-two anticanonical divisor spans a K-secant line), plus claimed irreducibility/dimensions 8 and 10 for rational quartic/quintic loci with dominant Abel–Jacobi maps — absent from this entry's canonical packet. See Goal-wave worker roots.
- **Aliases:** `R_RATIONAL_CURVES`; WORK "R/M-stub"; CERT `certificates/elliptic_lifting` (`PICARD_OBSTRUCTION.md`) — link plausible, contested.
- **Provenance:** `goal_runs_after_35fa/R_RATIONAL_CURVES`; `certificates/elliptic_lifting/` (candidate).
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_R_RATIONAL_CURVES_ON_TWIST.md` (added by `8a14d67`; indexed in `3569d63`).
- **Pointers:** `goal_runs_after_35fa/R_RATIONAL_CURVES/STATUS.md`; `certificates/elliptic_lifting/PICARD_OBSTRUCTION.md`
- *Lenses 2–3/7 (DIR, WORK, +CERT circumstantially); confidence high for the exit, medium for the `elliptic_lifting` identification — WP-E1 "elliptic Pic⁰ obstruction" under Path G is a competing owner (conflict 12).*

---

<a id="e29"></a>
### E29 — R0 — Canonical live-ledger refresh

- **Target:** infrastructure — update and verify the canonical live-ledger state after the G2, V3 and B results and the post-pin refinements.
- **Justification:** Bookkeeping. It determines which routes downstream dispatches treat as open.
- **Method:** mixed (document/CAS audit)
- **Record type:** audit/repair
- **Thread:** T8 — process and audits
- **Verification class:** **CONSISTENCY-ONLY** — the only `-PASS` primary exit in the goal_runs layer resting on a consistency-only verifier, and already stale.
- **Status:** PASS — infrastructure only.
  - `R0-CANONICAL-REFRESH-PASS` [DIR, `goal_runs_after_141f60/R0_CANONICAL_REFRESH/STATUS.md`]
- **What was actually established:** the ledger state was refreshed and verified at that commit. NOT established: anything mathematical; and see the staleness note below.
- **Aliases:** `R0_CANONICAL_REFRESH`; GIT anchor `0aecc89`
- **Provenance:** `goal_runs_after_141f60/R0_CANONICAL_REFRESH`; git `0aecc89`, `b77b04c`, `141f604`.
  - `source: external-chatgpt` — `sessions_batch1.md` § `mattrobball-unirational-task-6a7054e2.md` declares `R0-CANONICAL-REFRESH-PASS` **stale** after L1/G3A/G3P/G4/G7A/G5/H6/G7B landed.
  - `source: external-chatgpt` — `sessions_batch1.md` § `github-repo-task-update-6a7054fb.md` repeatedly reconciles a stale `REMAINING_GOALS_NOTE.md` against actual landed exits across three successive `main` heads.
- **Pointers:** `goal_runs_after_141f60/R0_CANONICAL_REFRESH/STATUS.md`
- *Lenses 2/7 (DIR, GIT); confidence certain.*

---

<a id="e30"></a>
### E30 — S19 — Degree-19 Cayley–Bacharach residual curve on the generic Schur twist

- **Target:** positive construction — starting from the accepted degree-55 `D12`-stabilized closed point of **index one** on the generic Schur twist, build a `G`-equivariant, geometrically integral degree-19 genus-0 curve through it so the residual cubic intersection is a length-2 cycle, forcing a `K_proj`-point (⇒ `BR-SCHUR19-POS`); alternatively seek a torsor-dependent no-point obstruction.
- **Justification:** Cayley–Bacharach converts an index-one configuration into an actual rational point if the right residual curve exists — a direct positive closure.
- **Method:** mixed (CAS Hilbert function / Rao module / Quot scheme + classical projective geometry)
- **Record type:** construction
- **Thread:** T5 — Schur-source and curve constructions
- **Verification class:** ALGEBRAIC-RECOMPUTE (both `S19` runs; `certificates/schur_degree19`).
- **Status:** UNDECIDED — the ACM branch is excluded for one hyperplane choice; both non-ACM Rao branches remain live; deprioritized behind the T/P25/C tracks.
  - "index one, but no rational point is currently known" [HAND `R15`; also `REPAIR.md` §14, correcting an earlier "no rational point" phrasing that implied proved pointlessness]
  - "ACM Hilbert-function obstruction on one hyperplane choice; non-ACM branch and a `(3,5)` complete-intersection `Y` with Rao-ledger analysis left open"; "neither the no-quintic branch nor the special quintic-carrier branch is closed" [HAND `R15`]
  - "Both non-ACM branches remain"; "no geometrically integral ACM degree-19 curve works" (only for one descended hyperplane-selected point); "this is an exact non-ACM frontier, not a nonexistence theorem" [RES `RES-06`]
  - `S19-UNDECIDED` [DIR, `goal_runs_after_35fa/S19_MARKED_CURVE/.../STATUS.md`]
  - "implication chain PASS; both Rao branches remain live; `STOP-3`" [WORK]; targets `P-A`/`P3`/`S19-POSITIVE` **not reached**
  - "no worker is dispatched this round unless T10, P25W, and C2 all stop" [WORK, `WORKORDER_CAS_T10_P25W_C2.md` §6]
- **What was actually established:** the implication chain (that such a curve would force a point) PASSES; the ACM branch is excluded for one hyperplane choice. NOT established: existence or nonexistence of the curve; the result is "an exact non-ACM frontier, not a nonexistence theorem".
- **Aliases:** Route S19; Attempt 3; `S19_MARKED_CURVE/CODEX_ROOT_20260801_7B4E`(`_CONT2`); HAND `R15`; RES `RES-06`; CERT `certificates/schur_degree19` (grouped under "A" there); WORK `S19-Krylov`
- **Provenance:** the two `S19_MARKED_CURVE` run dirs; `tmp/schur_unrestricted_point_attack`, `schur_degree19_structural_design`(+audit), `schur_degree19_nonacm_attack`(+audit); Attempt 3 gates 3B–3D; S19.1–S19.3; `certificates/schur_degree19/` (`marked_hilbert`, `quintic_carriers`, `rao_resolutions`, `betti_tables`, `IMPLICATION_AUDIT.md`).
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_S19_SCHUR_CURVE.md` (added by `67218b6`; indexed in `3569d63`).
- **Pointers:** `certificates/schur_degree19/`; `HANDOFF.md` "2026-07-30 audited delta" item 2; `RESOLUTION.md` "2026-07-30 audited advances" item 2; `SPEC.md` ~109–144; `REPAIR.md` §14
- *Lenses 5/7 (DIR, CERT, HAND, RES, WORK); confidence certain. Possibly-same-as [E01](#e01) — CERT and WORK treat them as one programme; kept separate.*

---

<a id="e31"></a>
### E31 — Schur — Six-dimensional Schur projective-source route

- **Target:** positive construction — find a rational `G`-equivariant map `P(V6)⇢X` from the six-dimensional Schur representation of `SL₂(11)`; by the projective-source lemma any such map is automatically dominant and, with index-2 Brauer splitting plus quadratic descent, solves the headline. Includes a degree-8 Reynolds-covariant all-degree normal form and a structural study of the ten coordinate-line genus-one fibrations.
- **Justification:** The projective-source lemma removes the dominance requirement entirely — merely landing in `X` from `P(V6)` suffices.
- **Method:** CAS (constant-coefficient exhaustive solves) + Picard/fibration theory
- **Record type:** construction
- **Thread:** T5 — Schur-source and curve constructions
- **Verification class:** not covered by `notebook_build/verifier_depth.md` — provenance is `tmp/` scratch only, so the evidence is local-only (Binding rule 5).
- **Status:** OPEN-STALLED — degrees 4/6/8/10 empty, degree 12 blocked by a terminal solver nonverdict; the genus-one fibration no-section theorem is real but does not obstruct points.
  - "Complete constant-coefficient landing loci are empty in degrees 4, 6, 8, 10"; degree 12 "remains open"; "Finite scans still cannot prove a negative answer" [HAND `R5`]
  - degree 12 reconstructed (dim 48) but only decomposable/low-primitive-support slices excluded; full-rank char-23 solve (rank 1,124) times out [HAND `R5`]
  - "the projective-source route is not a resolution"; "the exact solve timed out... no leading output" [RES `RES-05`, SPEC]
  - Fibration theorem: "The former `ξ_ij=0`/3-descent section target is retired"; each ambient-line projection is a genus-one fibration with `Pic=Z·H⊕Z·E`, fibre-degree image `3Z`, exact index/period 3, hence **no rational section**; "This is not a no-point theorem" [HAND `R14`]
  - "do not confuse a no-section theorem with a no-point theorem" [STAT, `CURRENT_PATHS.md` Ranking B item 4]
  - Post-repair: "the generic Schur twist has index one, but no rational point is currently known" [STAT/`REPAIR.md` §14]
- **What was actually established:** emptiness of constant-coefficient landing loci in degrees 4, 6, 8, 10; a genus-one fibration structure with exact index/period 3 on all ten ambient-line projections, hence no rational section; index one for the generic Schur twist. NOT established: a map, or emptiness in degree 12 (solver nonverdict), or pointlessness — the no-section theorem is explicitly not a no-point theorem.
- **Aliases:** SPEC task **E2**; "projective source"; "degree-8 rational frame"; "unrestricted Schur route"; HAND `R5`, `R14`; RES `RES-05`; STAT "Schur source"
- **Provenance:** `tmp/projective_source`, `tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`, `tmp/projective_source_degree12*`, `tmp/step4_degree12_solver_terminal`, `tmp/schur_ternary_planes`, `tmp/schur_structural_routes`, `tmp/schur_fibration_picard_obstruction`. No external session executed this route.
- **Pointers:** `RESOLUTION.md` "Six-dimensional projective-source route"; `SPEC.md` item 9 / task E2; `HANDOFF.md` "Strongest proved progress" items 5 and 9; `CURRENT_PATHS.md` §2 and Ranking A/B; `REPAIR.md` §14
- *Lenses 3/7 (HAND, RES, STAT); confidence certain.*

---

<a id="e32"></a>
### E32 — T — T-track: fold-algebra / target-branch normalization and 3-primary index-three obstruction

- **Target:** negative obstruction — prove the normalized target branch / fold algebra `S_G=(B[u]/(P,P_u))[Σ⁻¹]` retains a residue-degree-one branch of Cramer index 3, i.e. `(Cl/Pic)[3]=0` on a normalized cubic-discriminant-contact model, giving a pointless versal Klein twist (⇒ `BR-T-NEG`). Chain: finite birationality `S→B`; Serre normality (`S₂`+`R₁`); conductor/discriminant contact mod 3; class-group assembly; later reframed to normalize `S_G` directly (avoiding raw elimination of the degree-43 target-branch hypersurface) via subresultant / Hensel / binodal analysis.
- **Justification:** WORK calls it "the strongest developed negative route... needed facts are finite and local" — an index-3 obstruction on a genuine versal twist would close the headline negatively.
- **Method:** CAS (msolve, Macaulay2, Singular; saturation, subresultants, RUR)
- **Record type:** obstruction
- **Thread:** T4 — Pfaffian / fixed-frame / common-line

| Subroute | Exact target | Last outcome | State | Governing artifact |
|---|---|---|---|---|
| T/T2 | fold-algebra birationality and normalization of `S_G` (`T-NONNORMAL`, `dim Sing_S=2`) | `T-BIRATIONAL` retained; `T-NONNORMAL` and `dim Sing_S=2` suspended/unproved | suspended pending T2R | `REPAIR.md` §§1–3 |
| T2R | `S₂`/`R₁` normality gate | `T2R-UNDECIDED` (`S₂` proved, `dim Sing(S_G)≤2`, `R₁` undecided) | UNDECIDED; mandatory and pending | `DIRECTOR_HANDOFF.md` §8; commit `7fdbe42` |
| T3 | fixed-frame index-three theorem (local runner) | no promoted packet on `main`; `scratch_t3` worker root has an executed discriminant computation | unpromoted, worker-root evidence only | `goals_after_bd610a/scratch_t3` |
| T6 | fold decision T6 | `T60-UNDECIDED` | UNDECIDED | `DIRECTOR_HANDOFF.md` §8; commit `11474f5` |
| T8/T8n1 | analytic non-unit / Jacobian results at fold decision T8 | `T8-S1-NONUNIT-ANALYTIC` confirmed; T8-N1 Jacobian correction sealed | analytic non-unit results stand; sealed T8 Jacobian prose UNSUPPORTED per `audit_a1` F4 | `certificates/audit_a1/AUDIT_FINDINGS.md` (F4) |
| T9 | Hensel non-unit result at the binodal locus | `T9-HENSEL-NONUNIT-SEALED` | sealed at its own scope; does NOT seal the completed ordinary-node local model | `certificates/audit_a1/AUDIT_FINDINGS.md` (F1) |
| T10 | no 3-primary local Picard defect at the binodal locus | `T10-BINODAL-NO-3-DEFECT`; T10.0 sealed, T10.1 UNDECIDED | conditional on the unsealed ordinary-node hypothesis | `certificates/audit_a1/AUDIT_FINDINGS.md` (F2) |
| T11/T11b | exact local chart at the simple point; Route C obstruction test | T11.0 sealed, T11.1 UNDECIDED; T11b Route C obstructed | exact local chart established; route C obstructed | commits `faf6169`, `715faf4` |

- **Verification class:** mixed — `T_TARGET_BRANCH` PARTIAL-RECOMPUTE (mostly hash/field checks plus an embedded sympy partial-derivative identity); `fold_decision_t8`, `fold_decision_t8n1`, `fold_binodal_t9`, `fold_t11`, `fold_t11b`, `target_branch_mod3` ALGEBRAIC-RECOMPUTE; `fold_normalization`, `fold_normalization_t2r`, `fold_decision_t6`, `target_branch_global`, `target_branch_t10` PARTIAL-RECOMPUTE.
- **Status:** SUSPENDED-PENDING-T2R — `T-BIRATIONAL` retained; `T-NONNORMAL` and `dim Sing_S=2` suspended/unproved; sub-gates T6/T8/T9 sealed at analytic non-unit results; T10/T11 sealed with `.1` stages undecided; T3 demoted to non-headline after `B-BRIDGE-REFUTED`.
  - PRE-REPAIR (historical): `T-NONNORMAL` proved, `dim Sing_S=2` proved, terminal marker `FOLD_NORMALIZATION_T2_VERIFIER_ACCEPT` treated as proof [STAT/`REPAIR.md`]
  - POST-REPAIR: "Path T: `T-BIRATIONAL` — retained at its stated generic/open theorem boundary"; "`T-NONNORMAL` — **suspended**; not proved by the current T2 packet; pending T2R gate"; "`dim Sing_S = 2` — **unproved**; current exact cuts do not establish it; pending T2R"; required interim label `T2-UNDECIDED pending exact saturated same-open dimension proof`; verifier explicitly must **not** be consumed as proof; "'normalization defect is divisorial' — unproved"; "'`Ann_B(S/B)` is the normalization conductor' — false notation; conductors separated" [HAND `R12`, RES `RES-25`, STAT/`REPAIR.md` §§1–3, §15]
  - `T2R-UNDECIDED`: `S₂` proved, `dim Sing(S_G) ≤ 2`, `R₁` undecided [WORK, `DIRECTOR_HANDOFF.md`]; `7fdbe42` "T2R.4 PASS (factors installed); T2R.5 still `T2R-UNDECIDED`" [GIT]
  - `T2-ROUTE-REFUTED` [DIR, `goal_runs_after_35fa/T_TARGET_BRANCH/STATUS.md`]
  - `17e0e5f` "Path T2 — exit `T-NONNORMAL`; S2 holds, R1 fails"; `d96b408` "Path T post-Elo — Gate T1 `T-BIRATIONAL`" [GIT]
  - `T60-UNDECIDED` [WORK, `DIRECTOR_HANDOFF.md` §8; GIT `11474f5`]
  - `T8-S1-UNDECIDED` (`dc43a86`); `T8-S1-NONUNIT-ANALYTIC` confirmed (`7866c68`); `T9-HENSEL-NONUNIT-SEALED`; `T8-N1` Jacobian correction sealed (`2645c91`) [GIT, WORK]
  - `T-BRANCH-NONNORMAL` (divisorial binodal locus); `T10-BINODAL-NO-3-DEFECT`; `T10.0` sealed, `T10.1 UNDECIDED` (`19e9490`); `T11.0` simple point sealed, `T11.1 UNDECIDED` (`faf6169`); `T11b Route C obstructed` (`715faf4`) [GIT, WORK]
  - **Qualified by `audit_a1` (2026-07-31 layer, `78abba4`; applied here 2026-08-03) — see [E03](#e03):**
    - **F1 (critical):** `T-BRANCH-NONNORMAL`, the "divisorial binodal locus", is **UNSUPPORTED + SCOPE-DRIFT as a CAS-sealed local form**. It is **analytic work-order input only**: T9 explicitly does **not** seal the completed ordinary-node local model `K'[[x,y,z1,z2]]/(xy)` (`certificates/audit_a1/AUDIT_FINDINGS.md`:47–49, 73–75). The conditional/UNCITED-HYPOTHESIS reading stands at the char-0/formal level; but the `78abba4` audit commit itself records the director's verification that the branch differentials have nonzero 2×2 minors mod p at the witnesses (values 14, 155, 40), which is independence at the lifted `Q_101` point and supports the ordinary-node factorization at the modular level — see [E03](#e03) for the full argument.
    - **F2 (high):** `T10-BINODAL-NO-3-DEFECT` is **conditional** — SOUND as pure algebra on an abstract ordinary node, UNCITED-HYPOTHESIS as geometry. Its correct statement is: *if* the completed local ring is an ordinary node, *then* there is no 3-primary local Picard defect (`AUDIT_FINDINGS.md`:90–94, 119–120). The hypothesis is exactly what F1 says is unsealed.
    - **F4 (high):** the sealed T8 prose asserts Jacobian determinants that were never computed — an **UNSUPPORTED residual**.
  - `T10-FOLD-HEIGHT1`/`T11-FOLD-HEIGHT1` sought but undecided [WORK]
  - `T3-UNDECIDED`; "Local-runner portfolio only; fixed-frame; **not headline after `B-BRIDGE-REFUTED`**" [WORK, `REMAINING_GOALS_NOTE.md`]; ledger: T3 `AUXILIARY OPEN — Fixed-frame/non-headline after B — Local runner only` [STAT]
  - **Correction (2026-08-03 goal-wave sweep):** the notebook previously
    recorded T3 as never executed. That is false as a global statement: no
    *promoted* T3 packet exists on `main`, but a separate worker root,
    `goals_after_bd610a/scratch_t3` (distinct from the planning-only
    `T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER` push cited below), contains an
    **actually-executed** T3 fixed-frame computation: an exact discriminant
    constructed and factored, with the plane boundary `A=15, Y=12` certified
    to have contact order two and one generic ordinary node (`Δ_cub`
    irreducible of degree 15 over `Q(ζ₁₁)`, 719 terms), markers
    `T3_FIXED_FRAME_DISCRIMINANT_DISCOVERY_DONE` and
    `T3_DISC_PLANE_GENERIC_ONE_ORDINARY_NODE`. This is worker-root evidence
    only — unpromoted, unverified, no synthesized packet or verifier. See
    Goal-wave worker roots and Verification debt item 14.
  - "the strongest developed negative route... needed facts are finite and local"; "Ordinary Picard theory is complete... Neither its vanishing nor a dangerous class has been proved" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §4 Rank3, §2.4]
  - Ledger: T/T2 bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger]
  - **Conflict (terminality):**
    - *Side 1 (08-02 ledger, offline):* T/T2 `TERMINAL`.
    - *Side 2 (`REPAIR.md` + run artifacts):* the T2R gate is **mandatory and pending** with no certified exit among `T2R-NONNORMAL`/`T2R-NORMAL`/`T2R-UNDECIDED`; T3 is blocked from consuming `T-NONNORMAL` until T2R exits; `7fdbe42` leaves T2R.5 explicitly `T2R-UNDECIDED`.
    - Per Binding rule 1, `REPAIR.md` and the run-level artifacts outrank the ledger: suspended-pending-T2R, not terminal. Separately, DIR's `T2-ROUTE-REFUTED` and GIT's `T-NONNORMAL` exit describe the same T2 packet whose conclusion `REPAIR.md` later suspended.
  - **Conflict (certificate ownership):** as in [E06](#e06) — CERT assigns `certificates/target_branch_{global,mod3,t10}` to route B; GIT/WORK tie `target_branch_t10` to T10 and HAND `R11`/`R12` place "target branch" inside Path T. Recorded in both entries; not merged.
  - **Certificate note (manifest completion sweep, NO-VERIFIER):** `certificates/fold_normalization_t3` is an empty stub directory — two empty subdirectories, no files, never populated.
- **What was actually established (flat, unconditional):** `T-BIRATIONAL` (at its stated generic/open boundary); `S₂` for `S_G`; `dim Sing(S_G) ≤ 2`; analytic non-unit results at T8/T9.
- **Established only conditionally / analytically (per `audit_a1`):** the "divisorial binodal locus" `T-BRANCH-NONNORMAL` is an **analytic work-order input**, not a CAS-sealed local form — T9 does not seal the completed ordinary-node model. `T10-BINODAL-NO-3-DEFECT` holds **conditionally**: as pure algebra on an abstract ordinary node it is sound, but as a statement about *this* branch it presupposes the unsealed ordinary-node hypothesis. Neither belongs in the unconditional list.
- **NOT established:** `R₁`, `T-NONNORMAL`, `dim Sing_S = 2`, any class-group vanishing, the index-three obstruction, or the T8 Jacobian determinants asserted in sealed prose. The T2 verifier marker is explicitly not a proof.
- **Aliases:** Path T; T1–T4, T2R, T3, T3A, T6, T8, T8n1, T9, T10, T11, T11b; `T_TARGET_BRANCH`; `T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER`; Attempt 2; Path B "upstairs simple fold" (Elo ten paths); WP-T1; HAND `R11`/`R12`; RES `RES-25`; CERT `fold_*` and (contested) `target_branch_*`
- **Provenance:** `goal_runs_after_35fa/T_TARGET_BRANCH`; T1–T4 (POST_ELO); T3.1–T4 (HEADLINE); T2R.4–T2R.5 (REVISED); T6.0–T6.3; T8.1–T8.4; T9.0–T9.3; T10.0–T10.3 (+`WORKORDER_CAS_T10_P25W_C2_CORRECTION.md`, the binding Q→Q_101 wording correction); T11.0–T11.3; T3A local RUR exhaustiveness (`c9d75e1`); T3 split into local worker goals (`b49fc81`, `74045be`, `823beb1`); WP-T1; Path B B1–B4 upstairs normalization; `certificates/fold_normalization`, `fold_normalization_t2r`, `fold_normalization_t3`, `fold_decision_t6`, `fold_decision_t8`, `fold_decision_t8n1`, `fold_binodal_t9`, `fold_t11`, `fold_t11b`.
  - `source: external-chatgpt` — `sessions_batch2.md` § `t3-normalization-push-6a70553b.md`; pushed `goals_after_5899d0/T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER/` directly to main at `b49fc81` (README, WORK_ORDER, LOCAL_RUNNER_COMMANDS, ACCEPTANCE_MATRIX, WORKER_GOALS) — **planning documents only, no computed result or verifier packet**. The session delivered no proof, confirms "No T3 workflow exists on main" (true of this push, but not true globally — `goals_after_bd610a/scratch_t3` is a separate, later-surfaced worker root with an executed T3 computation; see Verification debt item 14), and notes it accidentally triggered GitHub Actions runs against an explicit local-runner-only instruction (runs failed at a preliminary boundary-audit step; the PR was closed with no changes). The packet itself states a successful T3 would prove only the "fixed-frame index-three theorem" and would **not** close Problem E after `B-BRIDGE-REFUTED`.
  - `source: external-chatgpt` — `sessions_batch1.md` § `github-repo-task-update-6a7054fb.md` records the T3 split into local workers (T3-RUR/NORM/DISC/PIC/INTEGRATE), fixed-frame only after B's failure.
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `Goal T` (`aaab49f`) and `GOAL_T2_TARGET_BRANCH_NORMALIZATION.md` (added by `ba5aa87`; indexed in `37d61c1`); § `progress-on-klein-cubic-6a705563.md` reports the target branch reduced to `ind(C/F)=3`, `C(F)=∅`, `Pic⁰(C)(F)=0`, `Pic(T_D)=ZH_z⊕ZH_λ`, the only escape being the horizontal 3-primary part of `(Cl(T_D)/Pic(T_D))[3]`, and that the critical locus is a **degree-14 curve, not 12 nodes** (killing a hoped-for ODP shortcut).
- **Pointers:** `REPAIR.md` Parts I, VI, §§1–3, §6, §15; `certificates/audit_a1/` (`AUDIT_FINDINGS.md` F1/F2/F4 — the second correction layer over this track); `WORKORDER_CAS_HEADLINE.md` §3; `WORKORDER_CAS_HEADLINE_REVISED.md` §4; `DIRECTOR_HANDOFF.md`; `DIRECTOR_REVIEW_AFTER_BD610A.md`; `CURRENT_PATHS.md` lines 19–90; `certificates/fold_*/`
- *Lenses 7/7; confidence certain.*

---

<a id="e33"></a>
### E33 — V / V2 / V3 / V4 (+G5) — Genuine valuation / residue-twist obstruction

- **Target:** negative obstruction — analyze divisorial valuations on the twist and test whether a place is **transferable** to the genuine (non-fixed-frame) twist via inertia; decide pointlessness of the full residual `f5`/`f6` twist (a valuation/residue construction tied to the degree-11 torus structure) rather than of finite proxies; then classify simultaneous odd normal coefficients and test the trisection genus-two quotient approach (V4).
- **Justification:** A henselian valuation whose residue twist is pointless would give a genuine (not proxy) pointlessness certificate, closing the headline negatively — the failure mode that sank [E06](#e06) is exactly non-transferability, which this route attacks head-on.
- **Method:** mixed (CAS + valuation-theoretic argument)
- **Record type:** obstruction
- **Thread:** T6 — genuine subgroup twists; also T2 — degree ladder

| Subroute | Exact target | Last outcome | State | Governing artifact |
|---|---|---|---|---|
| V | test fixed-frame place transferability to the genuine (non-fixed-frame) twist | `V2-FIXED-FRAME-PLACE-NONTRANSFERABLE` | established (non-transferable) | `goal_runs_after_35fa/V_GENUINE_VALUATION/STATUS.md` |
| V3 | residue normal-form theorem constraining which valuations could give a nonpoint | `V3-RESIDUE-NORMAL-FORM-PASS` | PASS; governing exit remains `V-UNDECIDED` | `goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/` |
| V-f5 degree-16 support | size-≤5 coefficient-support search for degree-16 `f5=0` landing survivors | `V-F5-DEGREE16-SUPPORT-LE5-EMPTY` (all `C(19,5)=11,628` supports mod 67 empty) | modular; any survivor now needs ≥6 nonzero coefficients | `goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/` |
| G5 | full residue cubic models at `f5=0`, `f6=0` | `G5-F5-CUBIC-MODEL-PASS`, `G5-F6-CUBIC-MODEL-PASS` | PASS; local-solubility binaries undecided | `goal_runs_after_141f60/G5_FULL_RESIDUE_CUBICS/STATUS.md` |
| V4 | classify simultaneous odd normal coefficients; test the trisection genus-two-quotient local-path strategy | `V4-SIMULTANEOUS-CLASSIFICATION-PASS`; `V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED` | classification PASS (Thm 2.12, char-0 only); blanket local-path strategy refuted by an explicit counterexample | `goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/STATUS.md` |

- **Verification class:** ALGEBRAIC-RECOMPUTE (`V_GENUINE_VALUATION`, `V3`, `V4`, `G5`).
- **Status:** PARTIAL — the fixed-frame place is proved non-transferable and the residue normal form / `f5`-`f6` cubic models PASS; V4's simultaneous-normal classification PASSES but its local-path headline route is REFUTED; only residue binaries remain.
  - `V2-FIXED-FRAME-PLACE-NONTRANSFERABLE` [DIR, `goal_runs_after_35fa/V_GENUINE_VALUATION/STATUS.md`]
  - `V-UNDECIDED`; `V3-RESIDUE-NORMAL-FORM-PASS` ("mechanics closed; residual is residue binaries only") [WORK, `REMAINING_GOALS_NOTE.md`]
  - "PARTIAL (`V3-RESIDUE-NORMAL-FORM-PASS`) — Mechanics closed, residue binaries remain — Feeds G5/H6" [STAT, 08-02 ledger]
  - `G5-F5-CUBIC-MODEL-PASS`, `G5-F6-CUBIC-MODEL-PASS` [DIR, `goal_runs_after_141f60/G5_FULL_RESIDUE_CUBICS/STATUS.md`]
  - `V4-SIMULTANEOUS-CLASSIFICATION-PASS`, `V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED` [DIR, `goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/STATUS.md`]
  - `ebb5769` "genus-two quotient classification for V4 normal maps"; `bc56247` "Record V4 simultaneous-normal theorem boundary"; `04d1d1c` "Classify simultaneous V4 odd normal maps"; `b77b04c` "record V3 residue normal form in live ledger" [GIT]
  - **Conflict (label collision, not a status conflict):** GIT's "V2" tokens (`11474f5` "V2 Track T", `dc43a86` "V2 Track T8", `6096429` "V2 Track P25Y", `1ad97cf` "V2 Track C0", `5e72d8e` "V2 Track P25X") denote the *version-2 work order* `WORKORDER_CAS_DECISION_AFTER_7FDBE42_V2.md`, **not** this route. DIR's `V2-...` is the exit label of `V_GENUINE_VALUATION`. Do not merge.
- **What was actually established:** the fixed-frame place is non-transferable to the genuine twist; a residue normal-form theorem constraining which valuations could give a nonpoint; exact `f5`/`f6` cubic models; the simultaneous-odd-normal classification at a representative V4/A4-stabilizer intersection. NOT established: any pointless residue twist — three named binaries remain (full-G residue twist at `f5=0`, full-G residue twist at `f6=0`, the maximal 11:5 trace cubic); and the blanket local-V4-path strategy is **refuted** by an explicit counterexample.
- **Aliases:** `V_GENUINE_VALUATION`, `V3_VALUATION_RESIDUE_CLOSEOUT_20260802`, `V4_SIMULTANEOUS_ODD_NORMALS_20260802`, `G5_FULL_RESIDUE_CUBICS`; WORK "V/G5 — residue twist f5/f6 valuation obstruction"; GIT `V3`, `V4`
- **Provenance:** the four run dirs above.
  - `source: external-chatgpt` — `sessions_batch2.md` § `repo-push-results-6a70552d.md`; PR #5 squash-merged as `30ce03b`, ledger commits `b77b04c`, `141f604`; packet `goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/`. Claims: any henselian-nonpoint valuation must have trivial inertia, non-C1 residue field with `trdeg≥2`, rational and Krull rank `≤2` (rank-2 must be Abhyankar with residue trdeg exactly 2), decomposition group `PSL(2,11)` or maximal `11:5`, surviving residue twist smooth of index one; consequently every valuation of Krull rank `≥3` is locally soluble. New certificate `V-F5-DEGREE16-SUPPORT-LE5-EMPTY`: all `C(19,5)=11,628` size-≤5 coefficient supports (151 independent equations mod 67) are projectively empty, so any degree-16 landing survivor for `f5=0` needs ≥6 nonzero coefficients. Markers `V_F5_DEGREE16_SMALL_SUPPORT_FULL_OK`, `V3_VALUATION_RESIDUE_CLOSEOUT_OK`. Governing exit remains `V-UNDECIDED`. **No CAS was available in-session** — all linear algebra hand-rolled Python/numpy over `F_p`.
  - `source: external-chatgpt` — `sessions_batch4.md` § `2026-08-03-problem-e-review.md`; packet `goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/` (`THEOREM.md`, `GENUS2_QUOTIENT.md`, `DEGREE25_COROLLARY.md`, `STATUS.md`, `verify.py`, `verify_kappa_genus2.py`), latest commit `fb4bcea`; corroborated by repo log entries `ebb5769`, `08859c0`, `72147bd`. Claimed exits: `V4-SIMULTANEOUS-CLASSIFICATION-PASS`; `M1-TRIPLE-ORDER3-ALL-LINE-DEGREE-EMPTY`; `V4-TRISECTION-GENUS2-QUOTIENT-PASS` (smooth genus-2 curve `C: y²=(κ₊t³+κ₋)((κ₊+4)t³+κ₋+4)`, smooth since resultant `64(κ₊−κ₋)³≠0`, with exact Weil-representation values `κ± = (13±3√33)/16`); `DEGREE25-LANDING-EMPTY`; and `V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED`, disproved by an explicit primitive line-degree-6 toric-boundary counterexample family (`κ=(B³−1)²/B³`, landing identity `κw³+w(u0²+u1²+u2²)+u0u1u2=0`).
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_V_VALUATION_TROPICAL_POINTLESSNESS.md` (added by `400c138`; indexed in `3569d63`).
- **Pointers:** the four run dirs; `REMAINING_GOALS_NOTE.md`; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #6
- *Lenses 4/7 (DIR, GIT, STAT, WORK); confidence certain. The `DEGREE25-LANDING-EMPTY` corollary was **adjudicated 2026-08-03** (conflict 13): its char-0 content is the order-three branch only — real, and for all line degrees — while the order-two and order-≥4 branches are audited but modular-only. The label overstates its char-0 scope; see [E25](#e25).*

---

<a id="e34"></a>
### E34 — WP-strata — Exact stabilizer strata & normal-cone transition necessity machine

- **Target:** infrastructure/negative — build a portable characteristic-zero stabilizer stratification of `P⁴` and `X`, tangent/normal character decorations, local transition modules, and a global inverse-limit ("normal-cone necessity theorem") as an **all-degree necessary-condition screen** for any hypothetical landing covariant; feeds Path G.
- **Justification:** If the inverse limit of transition conditions is empty, no landing covariant exists in any degree — an all-degree negative with no search.
- **Method:** CAS
- **Record type:** infrastructure / obstruction (dual)
- **Thread:** T3 — mechanism transfer from solved examples; also T2 — degree ladder
- **Verification class:** mixed — `certificates/strata`, `transitions` (sampled `v4_fixed_line`/`c3_lines`), `global_transition`, `lifting`, `border_support` ALGEBRAIC-RECOMPUTE (each independently rebuilds the underlying group/module data and recomputes ranks or dimensions, not just hash-checks); `transition_repair` CONSISTENCY-ONLY (adversarial re-classification checks only, no numerical/algebraic recomputation).
- **Status:** INFRASTRUCTURE-PARTIAL — the stratification, local transition modules, global transition diagram, and border/Fitting integration are built and checked in; WP-6 exited STOP with a formulation; the machine produced no all-degree obstruction.
  - "Problem E remains open" (file-wide) [WORK, `WORKORDER_STRATA_MACHINE.md`]
  - Environment addendum: GAP / SageMath / Singular / PARI / Julia "NOT INSTALLED", blocking WP-1/WP-3 as literally specified [WORK]
  - type-I/type-II `V4` incidence inconsistency in the supplied `strata.md` flagged unresolved [WORK] — **ADJUDICATED 2026-08-04 by `goal_runs_after_2880a28/FIX_A1_V4_INCIDENCE_REPAIR` (`FIX-A1-V4-REPAIR-PASS`, all 55 V4s):** `strata.md` claim 1 ("every type-II point lies on three fixed elliptic curves") is TRUE (`ℓ_V ⊂ P_σᵢ` for all three `i`); claim 2's "**only** type-I points" is FALSE — both types are meetings of positive-dimensional fixed closures, in two patterns: type-I (165 triangle vertices) = one plane cubic ∩ two minus-lines; type-II (3 per V4) = three plane cubics ∩ `ℓ_V` (with `ℓ_V ⊄ X`). Confirms and de-caveats the single-representative in-repo verdict `CLAIM_1_SURVIVES_CLAIM_2_REFUTED`. Bonus certifications: `X^{A4} = ∅` (the standing WP-4C hypothesis), `F|_{ℓ_V} = αU³+βV³` normal form, `marked_s3_geometry.json`'s unflagged 9-vs-0 regression mismatch caused by inert-prime choice (repaired primes: 397/419).
  - `d9cadc3` "WP-Z director gate report — ranking 4"; `ced3153` "WP-6 STOP with formulation"; `db25516` "WP-H1 Hodge-center screen" [GIT]
  - CERT: `transition_repair/CATEGORY_AUDIT.md`, `category_repaired.json` (WP-R0 category repair); `transitions/{c3_lines, d12_binary_line, involution_plane, point_links, v4_fixed_line}`; `lifting/OBSTRUCTION_TOWER.md`, `lifting/families/{based_minus_lines_odd_m, residual_e1_swap_both, residual_e_ge7_generic_swap_both}`; `border_support/`
- **What was actually established:** the machine's components exist and are checked in. NOT established: any all-degree obstruction; WP-1/WP-3 are blocked by missing CAS; a `V4` incidence inconsistency in the input stratification is unresolved.
- **Aliases:** WP0–WP7; WP-R0, WP-L1, WP-L2, WP-E1, WP-B1, WP-T1, WP-H1, WP-Z, WP-4A–4E, WP-5, WP-6; GIT `WP`
- **Provenance:** WP0 input audit; WP1 exact stratification; WP2 tangent/normal characters; WP3 marked S3 geometry; WP4A–4E local transition modules; WP5 global transition diagram (exits N1/N2/N3/P); WP6 border/Fitting integration; WP7 theorem assembly; WP-R0; WP-L1; WP-L2; WP-E1; WP-B1; WP-T1; WP-H1.
  - `source: external-chatgpt` — `sessions_batch3.md` § `klein-cubic-threefold-psl-6a6b6514.md` and `sessions_batch4.md` § `mathematical-machine-implementation-6a7055b7.md`, § `g-equivariant-rational-maps-6a70559f.md` all propose successors to this machine (a "transition cosheaf" `𝒯_X` on the 55-plane incidence complex with `H⁰(𝒯_X^land)=0 ⇒ non-unirational`; a universal fixed-stratum scanner; local jet automata; a Klein incidence-and-flag packet of 55 involutions/V4s/plus-planes/triple lines, 66 D10 and 55 D12 points). **None of these were committed** — sandbox LaTeX/PDF/zip deliverables only; the Priority-0 exact-arithmetic checkers were never built or run.
- **Pointers:** `WORKORDER_STRATA_MACHINE.md`; `WORKORDER_STRATA_LIFTING_BLOCKERS.md`; `certificates/{strata, transitions, transition_repair, lifting, border_support}/`; `certificates/GLOBAL_TRANSITION_DIAGRAM.md`, `LOCAL_TRANSITION_MODULES.md`, `MARKED_S3_GEOMETRY.md`, `BORDER_SUPPORT.md`
- *Lenses 3/7 (GIT, CERT, WORK); confidence certain.*

---

<a id="e35"></a>
### E35 — xCD — Plane-section flex / 3-descent route

- **Target:** positive/negative — decide whether the explicit characteristic-zero ternary cubic `F(a·x+b·C+c·D)=0` (a distinguished Schur-derived plane section of the generic twist) has a `K_proj,C`-point, via genuine elliptic 3-descent (flex algebra, `E[3]`-Kummer class `α_R` built by a typed nested-étale Čech circuit) and via singularity/factoriality analysis of the total space `C6` over the Klein sextic base `H6=V(f6)`.
- **Justification:** A point on a distinguished plane section would be a point of the twist; conversely a full 3-descent obstruction on a canonical section was the most concrete available negative sub-target.
- **Method:** mixed (descent arithmetic + heavy CAS)
- **Record type:** construction / obstruction (dual — closed scoped-negative)
- **Thread:** T4 — Pfaffian / fixed-frame / common-line
- **Verification class:** not covered by `notebook_build/verifier_depth.md` — provenance is `tmp/xcd_*` scratch only (29 directories), so the evidence is local-only (Binding rule 5).
- **Status:** CLOSED-SCOPED-NEGATIVE — the distinguished plane component provably has no point; explicitly not a headline obstruction; the route is retired.
  - "the original projective xCD plane cubic has no `K_proj,C`-point" (proved for this plane) [RES `RES-04`]
  - "This closes only the plane section `F(a*x+b*C+c*D)=0`, not the full generic twisted Klein cubic threefold; the headline remains open" [RES `RES-04`, SPEC E3]
  - "This closes the construction `F(a·x+b·C+c·D)=0`; it does not prove that the full generic twisted Klein cubic threefold has no point" [HAND `R21`]
  - `Cl(H6)=Pic(H6)=Z[O(1)]`, `def(H_6)=0` via the Jung–Saito defect formula; horizontal Weil degree image forced to `3Z` [HAND `R21`/`R25`, STAT]
  - Čech/Kummer component: "The general-slice theorem now proves that this component has no `K_proj,C`-point, so that distinguished component is closed negatively. This is not an obstruction to points elsewhere" [HAND `R23`]
  - Rees/class-image sub-attack: "retained as a failure ledger... It is no longer a live gate"; "The proposed degree-one Zariski Morse chart is now refuted"; "do not continue a formal jet ladder" [HAND `R24`]
  - Multiprime radical experiment: "still failed withheld-prime rational reconstruction"; "This makes no QQ support claim and is retired for the census" [HAND `R22`]
  - "refuted and retired" [WORK, `WORKORDER_ORDER12.md` line 4]
- **What was actually established:** the distinguished plane section has no `K_proj,C`-point (proved); `Cl(H6)=Pic(H6)=Z[O(1)]` with zero defect; horizontal Weil degree image `3Z`. NOT established: anything about the threefold — explicitly scoped to one plane.
- **Documented dead branch (tmp, dated 2026-07-29, recorded 2026-08-03):** an 18-directory `tmp/xcd_*` family (`xcd_mf_*`, `xcd_lower_cech_*`, `xcd_slice_*` — full list in `notebook_build/tmp_disposition.md`) attacked the `def(Y)=0` Q-factoriality question via two independent sub-attempts: (a) an order-by-order weighted-Rees matrix-factorization ladder, where orders 1–4 survive but is explicitly labeled "not an all-order formal factorization"; and (b) a lower-Čech/Brieskorn pole-complex chain whose key local comparison formula is explicitly labeled CONJECTURAL ("GAP: not a proof"). Abandoned; superseded by the recorded rank-720/Bertini closure of `def(Y)=0` above.
- **Aliases:** "xCD plane cubic"; `F(a·x+b·C+c·D)=0`; SPEC task **E3** (partly); HAND `R21`–`R25`; RES `RES-04`
- **Provenance:** `tmp/xcd_*` (29 directories: `invariant_fibre_discriminants`, `repeated_factor_incidence`, `singular_curve_enumeration_audit`, `general_slice_completion`, `actual_class_image`, `picard_restriction`, `singular_locus_bound`, `invariant_module_multiprime`, `control_next`, `generic_cech_next`, `first_descent_next`, `genuine_descent`, `nonzero_kummer`, `total_normality`, `local_class_defect`, `class_globalization_next`, `zariski_descent_gate`, `formal_mf_all_order`, `formal_algebraization_audit`, `class_image_attack`, `ca_class_group`, `algebraic_null_polar`, `zariski_morse_chart`, `discriminant_divisor`, `gauge_divisors`, `residue_class_gate`, `arithmetic_next`, `descent_algebra`, `invariant_field`). No external session executed this route; the Poonen–Stoll import from [E51](#e51) was absorbed here.
- **Pointers:** `RESOLUTION.md` "The xCD flex and 3-descent audit"; `SPEC.md` task E3; `HANDOFF.md` "2026-07-29 xCD completion and Fable update", "2026-07-30 audited delta" item 3; `CURRENT_PATHS.md` §4
- *Lenses 4/7 (HAND, RES, STAT, WORK); confidence certain.*

---

<a id="e36"></a>
### E36 — theta11 — Level-11 theta/Schwarz modular construction

- **Target:** positive construction — test whether the July-2026 level-11 theta-series / Schwarz-map construction, matched to the repository's exact 5-dimensional Klein representation after monomial conjugacy, yields a Klein-cubic parametrization / landing map.
- **Justification:** A ready-made modular parametrization matching the Klein representation would supply the landing map directly.
- **Method:** CAS (series expansion)
- **Record type:** construction
- **Thread:** standalone
- **Verification class:** not covered by `notebook_build/verifier_depth.md` — provenance is `tmp/theta11_test` scratch only, so the evidence is local-only (Binding rule 5).
- **Status:** CLOSED-REFUTED.
  - "does not lie on the Klein cubic: `F(HΦ₁₁)=ξ₄₄⁵u¹¹+O(u⁹⁹)`... Close this as a headline path" [HAND `R26`]
  - "This particular recent modular lead is therefore closed"; "all 25 classical Hessian-minor tests are nonzero" [RES `RES-14`]
  - "Do not pursue the level-11 theta/Schwarz curve as a Klein-cubic parametrization" [STAT, `CURRENT_PATHS.md` Deprioritized-work list]
- **What was actually established:** the candidate series does not lie on the Klein cubic — an explicit nonvanishing leading term. Route closed.
- **Aliases:** `tmp/theta11_test`; "Kopeliovich–Sanabria"; HAND `R26`; RES `RES-14`
- **Provenance:** `tmp/theta11_test/theta11_test.py`. No external session.
- **Pointers:** `RESOLUTION.md` "2026-07-28 exact advances" item 5; `HANDOFF.md` "2026-07-30 audited delta" closing bullet; `CURRENT_PATHS.md` 2026-07-29 item 5
- *Lenses 3/7 (HAND, RES, STAT); confidence certain.*

---

<a id="e37"></a>
### E37 — ED-REDUCTION — Exact reduction: X is G-unirational ⟺ ed_C(G)=3

- **Target:** infrastructure/positive framework — via Prokhorov's Cremona-rank-3 two-model classification, the Tschinkel–Zhang twisted Pfaffian bridge to `F14` (index ≤2 Brauer class), and a "quadratic descent for cubics" lemma, prove the headline equivalent to the single numeric dichotomy `ed_C(G) ∈ {3,4}`, i.e. to whether the generic projective torsor `C_gen` has a `K_proj`-point.
- **Justification:** It is the reduction every other entry presupposes: it converts a birational-geometry question into a single rational-point question.
- **Method:** analytic
- **Record type:** reduction
- **Thread:** T1 — reduction spine
- **Verification class:** ANALYTIC-PROOF-REVIEW — the equivalence is a proved analytic result audited by reading (`RESOLUTION.md` "Exact reduction to essential dimension"); the untracked `tmp/step4_essential_dimension/` packet is local-only supplementary replay only (Binding rule 5), not the portable source.
- **Status:** **PROVED-ANALYTIC-IN-RESOLUTION** (reclassified 2026-08-03) — the single most load-bearing reduction in the problem; decides nothing on its own. The canonical proof lives in `RESOLUTION.md`: minimal-dimensional versality; Prokhorov's classification; the cubic/`F14` stable birational bridge; index-≤2 splitting; quadratic descent; and the weakly-versal-to-very-versal upgrade. The cited packet `tmp/step4_essential_dimension/` exists **locally only and is not tracked in git** (Binding rule 5), so `RESOLUTION.md` — not that packet — is the portable source for this theorem.
  - "This proves the theorem" — proved unconditionally [RES `RES-23`]
  - "This exact reduction still does not choose between the two values, so the headline remains open" [RES `RES-23`, SPEC]
  - "none of the audited local, Brauer, Amitsur, or standard stable-cohomology invariants decides whether it has a point"; headline "OPEN" [HAND `INF1`]
- **What was actually established:** the equivalence, unconditionally, in both directions. NOT established: which of the two values holds.
- **Aliases:** HAND `INF1`; RES `RES-23`; "essential-dimension reduction"; `tmp/step4_essential_dimension`
- **Provenance:** `RESOLUTION.md` "Exact reduction to essential dimension" (portable, committed). Also `tmp/step4_essential_dimension/` (`REPORT.md`, `verify_reductions.py`) — **untracked local scratch**, retained for replay only.
  - `source: external-chatgpt` — `sessions_batch3.md` § `klein-cubic-threefold-psl-6a6b6514.md` reports an apparently from-scratch re-derivation of the same equivalence in-session (equivariant MMP / Prokhorov X-vs-F14 dichotomy, Brauer-index argument with degree-6 CSA of index ∈{1,2}, quadratic-descent lemma for cubic hypersurfaces, Duncan–Reichstein weakly-versal ⇒ very-versal upgrade), reducing to `X_gen(K_proj)≠∅` over the degree-1/4/5/6/7 covariant frame. No commits from that session.
- **Pointers:** `RESOLUTION.md` "Exact reduction to essential dimension"; `SPEC.md` "There is also a stronger unconditional reduction..."; `HANDOFF.md` "Strongest proved progress" item 1
- *Lenses 2/7 (HAND, RES); confidence certain.*

---

<a id="e38"></a>
### E38 — INV-INFRA — Exact action & certified invariant-theory infrastructure (E0)

- **Target:** infrastructure — fix exact cyclotomic matrices for `G→GL(W)` (660 elements), verify faithfulness and Klein-cubic invariance, compute exact Molien dimensions, and construct an explicit generic torsor / Hilbert-90 model; Sylow/abelian fixed loci.
- **Justification:** Every other entry computes inside this data; an error here invalidates everything downstream.
- **Method:** CAS
- **Record type:** infrastructure
- **Thread:** T1 — reduction spine
- **Verification class:** ALGEBRAIC-RECOMPUTE — `certificates/exact_weil_check.py`, `exact_molien.py`, `exact_covariants_check.py`, `generic_covariant_basis_check.py` independently reconstruct the exact cyclotomic representation and recompute invariance/Molien data from scratch; not among the 26 packets sampled by `notebook_build/verifier_depth.md`, but the same computational-recompute character applies on direct inspection.
- **Status:** CERTIFIED-INFRASTRUCTURE — underlies every other route.
  - "This is infrastructure, not a resolution" [RES `RES-24`, SPEC E0]
  - "certified/checked-in; no obstruction/positive claim itself" [HAND `INF2`]
  - underlying facts certified (exact cyclotomic generator matrices, full 660-element Cayley-graph check, invariance of `F` verified) [RES `RES-24`]
- **What was actually established:** the exact action, faithfulness, invariance, and Molien data are certified and replayable. Nothing about the headline.
- **Aliases:** SPEC task **E0**; HAND `INF2`; RES `RES-24`
- **Provenance:** `certificates/exact_weil_check.py`, `exact_molien.py`, `exact_covariants_check.py`, `generic_covariant_basis_check.py`. Independently re-confirmed in `sessions_batch2.md` § `finish-g-g2-theorem-6a705522.md`, which verified `PSL(2,11)` is perfect of order 660 (`source: external-chatgpt`).
- **Pointers:** `SPEC.md` task E0; `RESOLUTION.md` "Exact action"; `HANDOFF.md` "Strongest proved progress" item 2; `certificates/CHECKS.md`
- *Lenses 2/7 (HAND, RES); confidence certain.*

---

<a id="e39"></a>
### E39 — FRAME — Generic covariant frame (x, C, D, E, K)

- **Target:** infrastructure/positive partial construction — build an explicit Hilbert-90 trivialization of the generic twisted ambient five-space from primitive covariants `x, C, D, E, K` of degrees 1,4,5,6,7 (determinant `Δ` nonzero at a sample point), writing `F(Ma)=0` over `C(W)^G` and reducing the generic-twist point problem to one cubic `Φ(a)=0` in five variables over `K_proj = C(P(W))^G`; exclude all ten frame coordinate lines as trivial roots.
- **Justification:** This is the coordinate system in which the headline is stated as a single cubic equation — the object `V(Φ)` that [E16](#e16)/[E17](#e17) try to find a point on.
- **Method:** CAS
- **Record type:** infrastructure
- **Thread:** T1 — reduction spine
- **Verification class:** ALGEBRAIC-RECOMPUTE — `certificates/generic_frame_lines_check.py`, `generic_frame_planes_check.py`, `generic_frame_planes_specialization.py`, `flex_cover_check.py`, `flex_line_scan.py` independently rebuild the covariant frame and recompute the determinant witness and line/plane factorizations via sympy, not read from JSON; not among the 26 packets sampled by `notebook_build/verifier_depth.md`.
- **Status:** CERTIFIED-INFRASTRUCTURE — the standing coordinate system for [E06](#e06), [E17](#e17), [E35](#e35), [E40](#e40).
  - "This completes the generic ambient-space descent explicitly. It does not produce a nonzero `a∈K_0^5` with `Φ(a)=0`; that is precisely the remaining generic-twist point problem" [RES `RES-03`]
  - "explicitly trivializes"; ten coordinate lines "excluded"; frame point must use ≥3 coordinates [HAND `INF3`]
  - Sub-results: ten smooth genus-one three-coordinate frame planes; degree 11–14 landing-ansatz exclusion; degree 15 no verdict; rational-flex exclusion on all ten planes [RES `RES-03`]
- **What was actually established:** the explicit trivialization and reduction to `Φ(a)=0`; exclusion of the ten coordinate lines, degree 11–14 landing ansätze, and rational flexes on all ten planes. NOT established: a solution `a`; degree 15 has no verdict.
- **Aliases:** HAND `INF3`; RES `RES-03`; "explicit generic-twist frame"; "all-degree self-covariant normal form"
- **Provenance:** `certificates/generic_frame_lines_check.py`, `generic_frame_planes_check.py`, `generic_frame_planes_specialization.py`, `flex_cover_check.py`, `flex_line_scan.py`.
  - `source: external-chatgpt` — `sessions_batch2.md` § `finish-g-g2-theorem-6a705522.md` builds its all-degree theorem on exactly this frame `(x,C,D,E,K_7)` of degrees (1,4,5,6,7) with normalizer `τ=f3²/f5`, and the 35-coefficient cubic `V(Φ)⊂P⁴`.
- **Pointers:** `RESOLUTION.md` "Explicit generic-twist frame" and "All-degree self-covariant normal form"; `HANDOFF.md` "Strongest proved progress" item 3
- *Lenses 2–3/7 (HAND, RES, +CERT circumstantially); confidence certain.*

---

<a id="e40"></a>
### E40 — PDE-FLAT — K_proj flat-connection all-degree module PDE

- **Target:** infrastructure / degree-free reformulation of the KLS landing problem — prove algebraic independence of the five primaries `f3,f5,f6,f8,f11`, install a free Hironaka basis (12 secondaries), the full multiplication table and a `τ=f3²/f5`-normalized degree-12 model, define a flat connection `∇` on `K_proj⁵`, and recast the headline as solving (or proving universal nonvanishing of) the rational PDE `det[a,∇₁a,…,∇₄a]=0` over `P⁴(C(P(W))^G)`.
- **Justification:** It removes the artificial polynomial-degree parameter that makes every other search a bounded scan; a solution is a landing covariant and universal nonvanishing is the negative answer.
- **Method:** mixed (CAS arithmetic circuits + analytic PDE)
- **Record type:** infrastructure
- **Thread:** T1 — reduction spine
- **Verification class:** not covered by `notebook_build/verifier_depth.md` — provenance is `tmp/` scratch only, so the evidence is local-only (Binding rule 5).
- **Status:** OPEN-REFORMULATION — the cleanest degree-free statement of the headline; unsolved, and the finite-generation shortcut is provably unavailable.
  - "certified"; "No solution or universal-nonvanishing theorem is known"; 121 constant / 440 Hironaka-linear ansätze and 15 gradient-cross-product covariants "fail to land" [HAND `INF4`]
  - infrastructure complete (`[K_proj:P0]=12`; rank-12 Hironaka basis; connection matrices as exact arithmetic circuits); "the full rational PDE remains unsolved" [STAT]
  - explicit `S5`-module counterexample shows finite covariant generation gives no all-degree cutoff — "no uniform bound on every solution can be the missing reduction" [STAT]
- **What was actually established:** the algebraic independence, the rank-12 Hironaka basis and multiplication table, the connection matrices as exact circuits, and the failure of 121+440+15 explicit ansätze. NOT established: any solution or nonvanishing theorem; and the finite-generation shortcut is explicitly ruled out.
- **Aliases:** HAND `INF4`; STAT "Essential-dimension flat-connection / all-degree module PDE"; `det[a,∇₁a,∇₂a,∇₃a,∇₄a]=0`
- **Provenance:** `tmp/kproj_arithmetic/`, `tmp/kproj_connection/`, `tmp/covariant_module/`, `tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`, `tmp/ed_binary_attack/verify_all_degree_module_pde.py`, `tmp/step4_essential_dimension/`. No external session.
- **Pointers:** `HANDOFF.md` "Strongest proved progress" item 6; `CURRENT_PATHS.md` §1 tail (lines 1863–1901), Ranking B item 2
- *Lenses 2/7 (HAND, STAT); confidence certain.*

---

<a id="e41"></a>
### E41 — VOISIN — Voisin C^[3] / X^[3] very-versality pullback

- **Target:** positive construction — use Voisin's rank-2-vector-bundle construction (a dominant map from a product of Grassmannians to the Hilbert scheme `X^[3]` of 3 points on the Klein cubic), prove `C^[3]` is `G`-very-versal, and equivariantly select one of the three points to reduce to `X`.
- **Justification:** Very-versality of `C^[3]` is a genuine positive result; if a single point of the degree-3 cycle could be selected equivariantly, the headline would close positively.
- **Method:** analytic
- **Record type:** construction
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** ANALYTIC-PROOF-REVIEW — the circularity finding is an analytic argument audited by reading (`RESOLUTION.md`, `HANDOFF.md` R28); no machine verifier by nature.
- **Status:** CLOSED-CIRCULAR — the versality is real; the selection step is circular.
  - "`C^[3]` is `G`-very-versal" (proved positive infrastructure) [RES `RES-12`]
  - "gives a source birationally fibered over C and is therefore **circular** for the missing point" [HAND `R28`]
  - "This nine-dimensional variety does not improve the essential-dimension bound and does not select one of the three points... the apparent selection step is circular" [RES `RES-12`]
  - Theorem boundary: "Very versality of `C^[3]` does not give very versality of `C`: no rational equivariant operation selecting one point of the degree-three cycle is known" [HAND `R28`]
- **What was actually established:** `C^[3]` is `G`-very-versal. NOT established: any selection operation; the construction does not improve the essential-dimension bound.
- **Aliases:** HAND `R28`; RES `RES-12`; "Voisin C^[3]"
- **Provenance:** `tmp/ed_binary_attack/REPORT.md`. No external session.
- **Pointers:** `RESOLUTION.md` "Six-dimensional projective-source route" closing paragraph; `SPEC.md` item 10 end and pitfalls; `HANDOFF.md` "Strongest proved progress" item 10
- *Lenses 2/7 (HAND, RES); confidence certain.*

---

<a id="e42"></a>
### E42 — ZC-SECANT — Zero-cycle / finite-orbit / secant chord-tree construction

- **Target:** positive classical-geometry construction — build an equivariant point from orbit configurations (`C11, C5, V4, C3` fixed loci; the 220-point orbit and its complete-intersection links) using secant/chord (third-intersection) constructions, iteratively reducing a `G`-orbit to a single point or a pair.
- **Justification:** The most elementary possible positive construction: if any chord tree folds an orbit to a singleton, that singleton is the required point.
- **Method:** mixed (analytic + CAS enumeration)
- **Record type:** construction
- **Thread:** T5 — Schur-source and curve constructions
- **Verification class:** ANALYTIC-PROOF-REVIEW — the finite-construction closure is an analytic/enumerative argument audited by reading (`RESOLUTION.md` "Finite-orbit and secant audit", `HANDOFF.md` R27); no machine verifier by nature.
- **Status:** CLOSED-FOR-FINITE-CONSTRUCTIONS — binary chord folding is excluded; the degree-74 semilinear interpolation curve remains a named open positive target.
  - "these are finite-construction no-gos, not an exclusion of continuous covariants"; "A torsor-dependent semilinear degree-74 curve remains a precise positive target" [HAND `R27`]
  - "This excludes only finite-orbit binary folding. It does not exclude a continuous covariant mixing an entire orbit at once"; "no such binary chord tree reaches a singleton or a two-point orbit" [RES `RES-13`]
  - "A torsor-dependent semilinear degree-74 interpolation curve would evade this argument and would solve the problem, but constructing it is another form of the unresolved varying-covariant problem" [RES `RES-13`]
- **What was actually established:** no binary chord tree over the enumerated orbits reaches a singleton or a two-point orbit. NOT established: any exclusion of continuous covariants mixing a whole orbit.
- **Aliases:** HAND `R27`; RES `RES-13`; "Finite-orbit and secant audit"; "zero-cycle descent"
- **Provenance:** `tmp/zero_cycle_descent`. Related but not identical: `sessions_batch1.md` § `finish-m3-section-6a705514.md` reports "1,485 secants checked" on the 55-point configuration in the M3 context (`source: external-chatgpt`).
- **Pointers:** `RESOLUTION.md` "Finite-orbit and secant audit"; `HANDOFF.md` "Strongest proved progress" item 8, "Best re-entry points" (Orbit constructions)
- *Lenses 2/7 (HAND, RES); confidence certain.*

---

<a id="e43"></a>
### E43 — GROSS-POPESCU — Modular-moduli reinterpretation

- **Target:** positive — examine whether Gross–Popescu's identification of the level-11 abelian-surface moduli space `A^lev_11` with the Klein cubic (with matching change-of-level `G`-action) furnishes an equivariant parametrization.
- **Justification:** A moduli interpretation with the right action could produce a rational source for free.
- **Method:** analytic (literature)
- **Record type:** construction
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** ANALYTIC-PROOF-REVIEW — a literature-interpretation rejection audited by reading (`RESOLUTION.md` "Other audited boundaries"); no machine verifier by nature.
- **Status:** REJECTED — restates the problem.
  - "This does not furnish an equivariant parametrization... No linear or already very versal source for the deck action is produced, so the modular interpretation **restates rather than solves** the current problem" [RES `RES-15`]
- **What was actually established:** that the identification exists but supplies no source. Nothing usable.
- **Aliases:** RES `RES-15`; `A^lev_11` level-structure moduli
- **Provenance:** no runs named; no external session.
- **Pointers:** `RESOLUTION.md` "Other audited boundaries" bullet
- *Lenses 1/7 (RES) — **single-lens** (document-structure artifact, not weak evidence); confidence certain.*

---

<a id="e44"></a>
### E44 — KRESCH-TSCHINKEL — Integral decomposition of the diagonal / equivariant Burnside

- **Target:** negative — test whether equivariant integral-decomposition-of-the-diagonal / equivariant Burnside-invariant machinery supplies an obstruction.
- **Justification:** These are the standard modern obstructions to equivariant rationality; if one applied, it would close the headline negatively.
- **Method:** analytic (literature)
- **Record type:** obstruction
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** ANALYTIC-PROOF-REVIEW — a logical-mismatch rejection audited by reading (`RESOLUTION.md` "Other audited boundaries"); no machine verifier by nature.
- **Status:** REJECTED — wrong direction of implication in both senses.
  - "does not furnish a new obstruction here... failure of decomposition would not obstruct mere `G`-unirationality. Conversely, its existence would not prove `G`-unirationality" [RES `RES-16`]
- **What was actually established:** the logical mismatch. Nothing about `X`.
- **Aliases:** RES `RES-16`
- **Provenance:** no runs named. Related: `sessions_batch4.md` § `g-equivariant-rational-maps-6a70559f.md` surveys the Kresch–Tschinkel Burnside formalism among adjacent literature without repo interaction (`source: external-chatgpt`).
- **Pointers:** `RESOLUTION.md` "Other audited boundaries" bullet
- *Lenses 1/7 (RES) — **single-lens**; confidence certain.*

---

<a id="e45"></a>
### E45 — AMITSUR — Universal-torsor / higher Amitsur cohomological obstruction (E3)

- **Target:** negative obstruction — seek a cohomological obstruction (universal-torsor class, higher Amitsur groups, Brauer group of twists) to `G`-unirationality.
- **Justification:** A nonvanishing cohomological class surviving restriction to all subgroups would obstruct the map.
- **Method:** analytic
- **Record type:** obstruction
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** ANALYTIC-PROOF-REVIEW — the Amitsur-exhaustion argument is audited by reading (`RESOLUTION.md`, `HANDOFF.md` R30); no machine verifier by nature.
- **Status:** CLOSED-EXHAUSTED.
  - "the higher Amitsur route is **exhausted** here because `Pic(X)=Z[H]` and `O_X(1)` is honestly `G`-linearized, so the relevant groups vanish after restriction to every subgroup" [HAND `R30`]
  - "The ordinary and all higher Amitsur obstructions vanish, even after restriction to subgroups... These are necessary-condition checks, not point theorems" [RES `RES-17`]
  - "That branch is closed unless a new dominance-functorial invariant is introduced" [SPEC task E3]
- **What was actually established:** vanishing of all ordinary and higher Amitsur obstructions, including after restriction to every subgroup — a proved negative-clearance result. NOT established: anything about points.
- **Aliases:** SPEC task **E3**; HAND `R30`; RES `RES-17`
- **Provenance:** `tmp/recent_structural_tools_audit/verify.py`. Consistent with `sessions_batch2.md` § `repo-push-request-6a705556.md`, which independently kills Amitsur-type recipients via transfer-annihilation (`source: external-chatgpt`).
- **Pointers:** `RESOLUTION.md` "Other audited boundaries", "2026-07-29 structural advances" item 5; `SPEC.md` task E3; `HANDOFF.md` 2026-07-29 primary-source audit bullet
- *Lenses 2/7 (HAND, RES); confidence certain.*

---

<a id="e46"></a>
### E46 — ED-P — Prime-local essential dimension

- **Target:** negative — force `ed(G)=4` via prime-local essential dimensions.
- **Justification:** `ed_p(G) ≤ ed(G)`; a prime-local value of 4 would settle it.
- **Method:** analytic
- **Record type:** obstruction
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** ANALYTIC-PROOF-REVIEW — a numerical-impossibility argument audited by reading (`RESOLUTION.md` "Other audited boundaries"); no machine verifier by nature.
- **Status:** REJECTED — numerically impossible.
  - "Prime-local essential dimension **cannot** force the value four: the local values are two at 2 and one at 3, 5, and 11" [RES `RES-18`]
- **What was actually established:** the explicit local values (2 at p=2; 1 at p=3,5,11), which are all too small. Route is dead on numerics.
- **Aliases:** RES `RES-18`; `ed_p(G)`
- **Provenance:** no runs named; no external session.
- **Pointers:** `RESOLUTION.md` "Other audited boundaries" bullet; `RESOLUTION.md` "Explicit generic-twist frame" (~1856–1858)
- *Lenses 1/7 (RES) — **single-lens**; confidence certain.*

---

<a id="e47"></a>
### E47 — SUPERRIGID — Birational superrigidity

- **Target:** negative — examine whether the known `G`-birational superrigidity of `X` supplies a negative resolution.
- **Justification:** Superrigidity is a strong known theorem about `X`; if it applied it would be free.
- **Method:** analytic
- **Record type:** obstruction
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** ANALYTIC-PROOF-REVIEW — a mismatch-of-statements argument audited by reading (`RESOLUTION.md` "Other audited boundaries", `SPEC.md` pitfalls); no machine verifier by nature.
- **Status:** REJECTED — proves the wrong statement.
  - "Birational rigidity is not a negative answer... a dominant map `U⇢X` may have degree greater than one" [RES `RES-19`, SPEC pitfalls]
  - "Equivariant birational superrigidity excludes birational linearization, not a dominant equivariant map of higher degree" [RES `RES-19`]
- **What was actually established:** the precise mismatch between superrigidity and unirationality. Nothing usable.
- **Aliases:** RES `RES-19`; "equivariant birational superrigidity"
- **Provenance:** no runs named.
  - `source: external-chatgpt` — `sessions_batch1.md` § `github-repo-task-update-6a7054fb.md` nonetheless proposed a new "ambient-extendable equivariant self-map rigidity" route citing a "G-birationally superrigid" theorem for the Klein cubic, while itself stating the theorem is insufficient alone. That session's route is the second, colliding, "L1" — see conflict list.
- **Pointers:** `SPEC.md` "Unconditional starting point" item 7 (~394-397), pitfalls; `RESOLUTION.md` "Other audited boundaries" last bullet
- *Lenses 1/7 (RES) — **single-lens**; confidence certain.*

---

<a id="e48"></a>
### E48 — CSD — Cassels–Swinnerton-Dyer conditional route

- **Target:** conditional positive — invoke the CSD conjecture (a cubic hypersurface with a zero-cycle of degree prime to 3 has a rational point) for the restricted family of Klein-cubic twists, all of which already carry a degree-one zero-cycle.
- **Justification:** The degree-one zero-cycle is already established; CSD would convert it to a point immediately.
- **Method:** analytic (conditional)
- **Record type:** conditional implication
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** LITERATURE-DEPENDENT — a conditional fork on the unproved Cassels–Swinnerton-Dyer conjecture; not resolvable without an external proof.
- **Status:** CONDITIONAL — would settle the headline positively; not usable as a resolution.
  - "would prove that `X` is `G`-unirational and `ed(G)=3`" (conditional, unproved) [RES `RES-20`]
  - "A proof conditional on one of the conjectures below is **not a resolution** unless that conjecture is proved in the required case" [RES `RES-20`, SPEC]
- **What was actually established:** the implication, and that the hypothesis (degree-one zero-cycle) holds. NOT established: the conjecture, in this or any restricted case.
- **Aliases:** RES `RES-20`; "Conditional forks and stakes"
- **Provenance:** no runs named. Cross-referenced independently in `sessions_batch3.md` § `klein-cubic-threefold-psl-6a6b6514.md` (`source: external-chatgpt`).
- **Pointers:** `SPEC.md` "Conditional forks and stakes" (lines ~412-438), task E2 bullet
- *Lenses 1/7 (RES) — **single-lens**; confidence certain.*

---

<a id="e49"></a>
### E49 — DR88 — Duncan–Reichstein Conjecture 8.8 conditional route

- **Target:** conditional positive — invoke Conjecture 8.8 (Sylow-subgroup versality implies `G`-versality); since every Sylow restriction on `X` is already versal (Condition A holds), this gives `G`-unirationality directly.
- **Justification:** The hypothesis is already verified for `X`; only the conjecture is missing.
- **Method:** analytic (conditional)
- **Record type:** conditional implication
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** LITERATURE-DEPENDENT — a conditional fork on the unproved Duncan–Reichstein Conjecture 8.8; not resolvable without an external proof.
- **Status:** REFUTED-BY-LITERATURE (2026-08-06) — **Scavia arXiv:2607.25118
  (July 2026) refutes Conjecture 8.8** (counterexample: `(C₇⋊C₃)×C₂` on a
  degree-2 del Pezzo surface; the paper explicitly flags the Klein-cubic
  consequence). The conditional route is DEAD and its refutation-stake
  bullet is moot: a negative headline no longer refutes 8.8 (already
  false). The D-R trichotomy of Prop 10.8 is now the DICHOTOMY
  CSD ⟹ YES vs Dolgachev ⟹ NO ([E56](#e56) wave 27, Note IX §1).
  - PRE-REFUTATION RECORD: "would prove that `X` is `G`-unirational and that `ed(G)=3`" (conditional, unproved) [RES `RES-21`]
  - PRE-REFUTATION RECORD: a negative headline resolution "would also **refute** Duncan–Reichstein Conjecture 8.8 in this example, because every Sylow restriction is already versal" [RES `RES-21`]
- **What was actually established:** that Condition A holds (every Sylow restriction versal); the conditional implication, now vacated by Scavia's refutation of the conjecture itself.
- **Aliases:** RES `RES-21`
- **Provenance:** no runs named. Cross-referenced in `sessions_batch3.md` § `klein-cubic-threefold-psl-6a6b6514.md` (`source: external-chatgpt`).
- **Pointers:** `SPEC.md` "Conditional forks and stakes" (lines ~412-438)
- *Lenses 1/7 (RES) — **single-lens**; confidence certain.*

---

<a id="e50"></a>
### E50 — DOLGACHEV — Crdim(G) ≤ ed(G) conditional route

- **Target:** conditional negative — invoke Dolgachev's proposed inequality `Crdim(G) ≤ ed(G)`; since Prokhorov proves `Crdim(G)=4`, this forces `ed(G)=4` and rules out `G`-unirationality.
- **Justification:** `Crdim(G)=4` is a proved input; only the inequality is conjectural.
- **Method:** analytic (conditional)
- **Record type:** conditional implication
- **Thread:** T7 — cohomological/motivic obstruction sweep
- **Verification class:** LITERATURE-DEPENDENT — a conditional fork on Dolgachev's unproved proposed inequality `Crdim(G) ≤ ed(G)`; not resolvable without an external proof.
- **Status:** CONDITIONAL — the mirror-image stake to [E49](#e49).
  - "would instead give `ed(G)=4`, which rules out `G`-unirationality of `X`" (conditional, unproved) [RES `RES-22`]
  - "a positive solution would give `ed(G)=3` and a **counterexample to Dolgachev's proposed inequality**" [RES `RES-22`]
- **What was actually established:** the implication and the symmetric stake. The former pairing with [E49](#e49) is updated (2026-08-06): E49's conjecture is refuted by Scavia, so the live separator is now [E48](#e48) vs this entry — CSD ⟹ headline YES, Dolgachev ⟹ headline NO, still incompatible (D-R Prop 10.8; E56 wave 27); whichever way Problem E resolves, a published conjecture still falls.
- **Aliases:** RES `RES-22`
- **Provenance:** no runs named. Cross-referenced in `sessions_batch3.md` § `klein-cubic-threefold-psl-6a6b6514.md` (`source: external-chatgpt`).
- **Pointers:** `SPEC.md` "Conditional forks and stakes" (lines ~412-438)
- *Lenses 1/7 (RES) — **single-lens**; confidence certain.*

---

<a id="e51"></a>
### E51 — LIT-AUDIT — Recent-literature and computational-tool audit

- **Target:** infrastructure/negative-clearance — recurring due-diligence sweep for a turnkey theorem or software that would shortcut a route: Kresch–Tschinkel versal-twist reduction, Poonen–Stoll discriminant-valuation theorem, Jung–Saito defect/factoriality revisions, Spicer–Tasin, Robbiano border-basis survey, Groebner.jl change-matrix API, June-2026 BSS/Koszul-homology spline paper, Magma/OSCAR/HomotopyContinuation.jl availability, and the 2026-07-18 Cheltsov–Tschinkel–Zhang manuscript.
- **Justification:** Prevents wasted effort on already-solved sub-problems and catches any theorem that would close the headline outright.
- **Method:** analytic (literature/tool audit)
- **Record type:** audit/repair
- **Thread:** T8 — process and audits
- **Verification class:** ANALYTIC-PROOF-REVIEW — a literature and tool-availability audit read and characterized directly; no machine verifier by nature.
- **Status:** ONGOING-CLEARANCE — no turnkey theorem exists; one absorbed import (Poonen–Stoll).
  - **2026-08-06 date reconciliation:** the "2026-07-18 CTZ manuscript" and "March-2026 CTZ classification" cited below are both the SAME paper, arXiv:2502.19598 (Feb 2025), now archived in `external_docs/` and read directly (E56 wave 26, Note VIII §7); the "still lists the Klein action as open" claim is VERIFIED from the PDF (Thm 5.1 exception list, p.18). The hallucination-risk flag on this sub-claim is retired (debt item 8); the phantom dates were session-reporting artifacts.
  - "found no recent theorem that closes the headline" [HAND `R32`]
  - Poonen–Stoll "closes those components as local-obstruction places... says nothing about the global torsor"; Jung–Saito "does not compute `Cl(B)` or `Cl(C6)`"; Groebner.jl "the public high-level route is stopped"; BSS/Koszul "generic hyperplane-fan theorems do not apply directly" [HAND `R32`]
  - "no theorem that converts index one or a degree-55 point on a cubic threefold into a rational point"; the 2026-07-18 Cheltsov–Tschinkel–Zhang manuscript "still lists this full action as open" [STAT]
  - one genuinely material missed theorem found (Poonen–Stoll), already absorbed into the xCD route [STAT]
- **What was actually established:** a negative clearance — no external theorem or tool closes the headline; one import (Poonen–Stoll) absorbed into [E35](#e35).
- **Aliases:** HAND `R32`; STAT "Literature & computational-tool audit"
- **Provenance:** `tmp/recent_structural_tools_audit/`, `tmp/recent_equivariant_tools_2026/`, `tmp/groebnerjl_change_matrix_pilot/`.
  - `source: external-chatgpt` — `sessions_batch1.md` § `github-repo-task-update-6a7054fb.md` ran repeated live web searches (arXiv, Cheltsov–Tschinkel–Zhang classification, essential-dimension results for Frobenius groups) and reports the March-2026 CTZ classification still lists the Klein `PSL_2(F_11)` action as an open exceptional case. **These citations came from in-session web search with connector citations and carry hallucination risk** (see Verification debt).
  - `source: external-chatgpt` — `sessions_batch3.md` § `klein-cubic-threefold-psl-6a6b6514.md` cites the 2026-07-18 CTZ manuscript twice; `sessions_batch4.md` § `g-equivariant-rational-maps-6a70559f.md` surveys Kollár–Szabó/Reichstein–Youssin going-down, Duncan–Reichstein versality, Blanc, Shinder, Prokhorov, Kresch–Tschinkel, Esser, Tschinkel–Zhang Condition A.
- **Pointers:** `CURRENT_PATHS.md` "2026-07-30 audited route ranking" (~lines 410–411, "no theorem that converts..." quote); `CURRENT_PATHS.md` "Recent literature and tool audit" (lines 1655–1785, CTZ-manuscript-still-open statement only); `HANDOFF.md` 2026-07-29 primary-source audit bullet and "Current structural ledger" tail
- *Lenses 2/7 (HAND, STAT); confidence certain.*

---

<a id="e52"></a>
### E52 — DP-REPLAY — del Pezzo closure-mechanism replay

- **Target:** proposed positive/analytic search — identify the Problem-E analogue of a prior successful del Pezzo closure mechanism: a canonical torsor, universal family section, or equivariant intermediate object whose existence is *equivalent* to `G`-unirationality of `X`.
- Distinct from [E14](#e14) (which imported Problem F's *obstruction*, and failed) and from [E24](#e24)'s degree-3 del Pezzo fibration (a Sarkisov target, unrelated to Problem F): this proposal replays the *equivalent-object* lesson of the dP closures.
- **Justification:** The del Pezzo problems in this repo were closed by finding such an equivalent object; the same move might work here.
- **Method:** analytic
- **Record type:** proposal/unrun
- **Thread:** T3 — mechanism transfer from solved examples
- **Verification class:** PROPOSAL-UNRUN — a specification-only priority-2 dispatch item, never run.
- **Status:** PROPOSED-UNRUN.
  - Listed as priority-2 dispatch item; "Type: analytic"; **not yet run** [WORK]
- **What was actually established:** nothing; specification only.
- **Aliases:** `GOALS_NEXT_10_ROUTES_2026-08-02.md` #2
- **Provenance:** none. The parent document was pushed by `sessions_batch4.md` § `2026-08-03-problem-e-review.md` as commit `f1f0be5` (`source: external-chatgpt`).
- **Pointers:** `GOALS_NEXT_10_ROUTES_2026-08-02.md` #2
- *Lenses 1/7 (WORK) — **single-lens**; confidence certain as a stated route.*

---

<a id="e53"></a>
### E53 — UNKNOWN-EX — Hidden intermediate-variety example search

- **Target:** proposed positive search — look through cubic threefolds, Fano varieties and finite-simple-group actions for previously unknown examples where equivariant unirationality was settled by a **hidden intermediate variety** rather than by representation covariants, in order to import the technique.
- **Justification:** Every in-repo positive attempt goes through representation covariants; a different published mechanism would be a genuinely new attack.
- **Method:** analytic (literature)
- **Record type:** proposal/unrun
- **Thread:** T3 — mechanism transfer from solved examples
- **Verification class:** PROPOSAL-UNRUN — a specification-only priority-9 dispatch item, never run.
- **Status:** PROPOSED-UNRUN.
  - Listed as priority-9 dispatch item; **not yet run** [WORK]
- **What was actually established:** nothing; specification only.
- **Aliases:** `GOALS_NEXT_10_ROUTES_2026-08-02.md` #9; "unknown-example"
- **Provenance:** none. Parent document pushed as `f1f0be5` by `sessions_batch4.md` § `2026-08-03-problem-e-review.md` (`source: external-chatgpt`).
- **Pointers:** `GOALS_NEXT_10_ROUTES_2026-08-02.md` #9
- *Lenses 1/7 (WORK) — **single-lens**; confidence certain as a stated route.*

---

<a id="e54"></a>
### E54 — CTR-TWIST — Counterexample twist / no-point G-torsor target

- **Target:** negative construction (proposed, not executed) — exhibit an explicit `G`-torsor over an infinite field whose Klein twist has **no** rational point, which would prove both the negative headline and `ed(G)=4`.
- **Justification:** This is the canonical statement of what a negative resolution looks like; every negative route is ultimately trying to produce or certify such an object.
- **Method:** analytic/construction
- **Record type:** proposal/unrun
- **Thread:** T6 — genuine subgroup twists
- **Verification class:** PROPOSAL-UNRUN — a target specification for a negative construction that was never attempted.
- **Status:** OPEN-TARGET — no candidate constructed.
  - "An explicit `G`-torsor whose Klein twist has no point would prove both the negative headline and `ed(G)=4`" [HAND `R29`]
  - "The sharp negative target is any boundary-zero `G`-torsor ... whose Klein twist has no point" [HAND, "2026-07-30 audited delta" item 2]
- **What was actually established:** the target's precise form. No candidate.
- **Aliases:** HAND `R29`; "sharp negative target"; "Counterexample twist"
- **Provenance:** none named; no external session constructed one.
- **Pointers:** `HANDOFF.md` "Best re-entry points" (Counterexample twist), "2026-07-30 audited delta" item 2
- *Lenses 1/7 (HAND) — **single-lens**; confidence certain.*

---

<a id="e55"></a>
### E55 — REPAIR — 2026-07-31 theorem-boundary repair audit

- **Target:** infrastructure/meta — audit every standing exit label in the project against its actual proof, downgrade overclaimed labels, and specify mandatory repair gates.
- **Justification:** Governs the truth-value of every other entry. Per Binding rule 1 its verdicts outrank all later narrative documents including the offline 08-02 ledger.
- **Method:** analytic (document/proof audit)
- **Record type:** audit/repair
- **Thread:** T8 — process and audits
- **Verification class:** ANALYTIC-PROOF-REVIEW — the theorem-boundary audit `REPAIR.md` was read and characterized directly, a document/proof audit with no machine verifier by nature (same treatment as [E03](#e03)).
- **Status:** APPLIED — the FIRST binding correction layer (the `audit_a1` layer of [E03](#e03), same day and ~13h later, is the SECOND).
  - `db37f58` (2026-07-31 08:50) "Klein cubic: record analytic audit repairs and suspend overstated certificates" introduces `REPAIR.md`; `07d1c4e` (2026-07-31 09:01) "Klein cubic: apply REPAIR.md theorem-boundary corrections (Parts II-VI)" applies it [GIT]. (`78abba4`, 21:38 the same day, is the separate `audit_a1` layer — see [E03](#e03); it is not part of this entry.)
  - "Trusted results retained": Path A `P¹`-reduction; Path A index-34 duality; corrected Hodge-center split-injection theorem after §8 substitution; Path G finite truncation and isolation cutoff; Path G4.1 free-fibre recurrence; P25.1 `P25-TOWER-SURVIVES`; `T-BIRATIONAL` [HAND, RES, STAT]
  - "Suspended or downgraded": `T-NONNORMAL`, `dim Sing_S=2`, `G13/G19-OBSTRUCTION`, Path A single-minor formulation, Path A executable `L,V_Z` claim [HAND, RES]
- **What was actually established:** the corrected boundary of every standing claim. Specific outcomes: Path T `T-NONNORMAL` and `dim Sing_S=2` suspended pending T2R; Path G `G13/G19-OBSTRUCTION` → `SAMPLE-RESIDUAL`; Path A single-minor → ideal of all maximal minors, `(L,V_Z)` → abstract interface; Hodge-center proof rewritten via a relatively ample class (fixing a relative-dimension error); Pfaffian "abstract `K_proj`-point" scoped to the auxiliary characteristic cubic only; Schur "no rational point" → "no rational point is currently known".
- **Aliases:** `REPAIR.md`; "theorem-boundary audit of every standing exit"; GIT `db37f58` (introduces), `07d1c4e` (applies Parts II–VI); the repair tables are reproduced identically in `HANDOFF.md`, `RESOLUTION.md`, `SPEC.md`, `CURRENT_PATHS.md`
- **Provenance:** `REPAIR.md` §§0–17; mandated file edits (`certificates/hodge_centers/HODGE_CENTER_NECESSITY.md`, `certificates/schur_krylov/*`, `certificates/fold_normalization*`). No external session; note that the offline 08-02 ledger post-dates this repair and conflicts with it in several places (see Open conflicts).
- **Pointers:** `REPAIR.md`; `HANDOFF.md` "2026-07-31 theorem-boundary repair"; `RESOLUTION.md`/`SPEC.md` repair tables; `CURRENT_PATHS.md` lines 19–90
- *Lenses 4/7 (GIT, HAND, RES, STAT); confidence certain.*

---

<a id="e56"></a>
### E56 — FIX — Equivariant fixed-locus b-complex program

- **Target:** dual — build the general abstract structure whose shadows
  closed the dP and Fermat cases: the decorated fixed-locus b-complex
  `𝔽_b(X)` (fixed strata across all `G`-models with normal-representation,
  residual-action, and birational-class decorations), its blowup calculus,
  and its functoriality under equivariant dominant rational maps; then
  compute the induced constraint-satisfaction problem for
  `P(W) ⇢ X_Klein` (obstruction exit) while exposing any forced structure
  usable constructively (reduction exit).
- **Justification:** the dP/OD16/Fermat closures all used fragments of this
  structure; the head-on general theory is the only geometry-first route to
  a search-free all-degree answer and subsumes E14/E15/E34/E33's shadows.
- **Method:** analytic (director notes) + CAS (foundation and instantiation
  packets).
- **Record type:** reduction / obstruction (dual)
- **Thread:** T3 — mechanism transfer, now head-on (method family 4)
- **Verification class:** ANALYTIC-PROOF-REVIEW (notes) + per-packet classes
  as they land
- **Status:** ACTIVE (opened 2026-08-04). **Foundation packets landed and
  director-replayed same day: `FIX-A0-ARRANGEMENT-PASS` (all six predictions
  exact: `(3,2)` splits, `L_σ ⊂ X`, `j(E_σ) = 8192/11` by two independent
  char-0 routes ⇒ non-CM proved, normal types `(−1)^{⊕2}`, `D12`/residual-S3
  via the standard 2-dim irrep, full 55-arrangement tables; finding: no line
  lies in another involution's plane — `L_τ ∩ P_σ` is a point iff `⟨σ,τ⟩ ≅
  V4`, and those points lie on `E_σ`) and `FIX-A1-V4-REPAIR-PASS` (V4 ground
  truth on all 55; type-I/type-II inconsistency adjudicated — see [E34](#e34);
  `X^{A4} = ∅`; `F|_{ℓ_V} = αU³+βV³`). Cor 5.2's FIX-A0/A1 conditionality is
  discharged: the funnel target is now the verified arrangement. Gate
  progress (`theory/FIX_T_gate.md`): T1 derived — Thm T1.2, chains map to
  chains on the resolved graph in dim 2, reproducing the collaborator's
  observation from the general definitions (flagged for their review);
  T3/T4 CLOSED via central-obstruction Cor T3.1 +
  `FIX-T34-CENTRAL-HYPOTHESES-PASS` (director-replayed; class-named
  instantiations, session descriptions corrected — see the gate note and
  debt item 15); T2 CLOSED (Thm T2.3 — Problem F re-derived as chain-level
  unsolvability via the scalar-birth and `V₄`-chain lemmas; source checker
  director-replayed; **first theorem in the series to spend the
  decoration and incidence layers** — parity forcing on `L_s`, forced
  basepoints at quadruple points, member-wise involutions along the
  exceptional tree; Klein export recorded: over the 165 vertices the same
  chains yield constrained path maps, not contradictions); T5 CLOSED —
  the exact line-degree-6 `A₄`-equivariant trisection family
  (`goal_runs_after_f1f0be` packet §4, along `ℓ_V` itself) verified as a
  solution of every fielded local constraint layer (funnel, T2-chains,
  decoration, residual equivariance), with no finite constancy state
  space (genus-2 reciprocal cover) — the formalism provably cannot close
  Klein on local data. **GATE CLOSED: T1–T5 all passed (2026-08-04).**
  FIX results now consumable. Note II landed 2026-08-05
  (`theory/FIX_II_jets.md`): the jet ladder — multi-order cone filtration
  at incidence flags (Lemma 2.1 derives the `(3m+1)/2` bound as pure
  incidence combinatorics; Lemma 2.2's parity table derives the
  `(3m+3)/2` "type-II delay"), the ladder differential `e ↦ 3Φ(p₀,p₀,e)`
  identifying Fable's correction operator and making "changed boundary
  data" an enumerable choice of bottom-cell solution, both validation
  instances passed (order bounds; packet Thm 2.12 as the `(1,3)`-cell
  obstruction computation), and the local cell classification table with
  the open cells assigned to packet FIX-N2 (principal target: `m = 1`,
  triple order ≥ 4, all line degrees). Cleared program continues: Note II
  (done), Note III skeleton landed same day (`theory/FIX_III_cosheaf.md`:
  the landing site 𝒜 with residually-pinned elliptic point-sites, stalks
  from the [II] cells, the honest logical strength — `H⁰ = ∅` is the
  negative headline, `H⁰ ≠ ∅` yields candidate global landing data — and
  the **quotient reduction**: `G`-equivariance computes `H⁰` on `𝒜/G`,
  a CSP in a handful of variety-valued orbit-variables, solvable by exact
  elimination). FIX-B landed 2026-08-05
  (`FIX-B-SYMBOLS-PASS`, director-replayed; FIX-A2 cross-validated a
  third time by a from-scratch verifier): the 20-symbol table of
  `[P(W)]`; removability audit over all 1023 admissible centers —
  **9-symbol non-removable core, with the plus-planes unconditionally
  rigid** (no smooth `G`-stable center of any kind can contain one, since
  three planes pass through each `ℓ_V`) and minus-lines/`C3`-lines/`ℓ_V`
  rigid-in-class: the cosheaf's stalk supports cannot be blown away, as
  Note III needs. Findings: the 60 poset-isolated `C11`-points are
  **surgically removable** (the level-11 stratum is NOT in the core —
  the modular-symbol resonance is a model-choice artifact, margin note
  deflated accordingly); `C5/χ` and `C5/χ²` are distinct orbits with the
  identical symbol; the `D12`-point blowup destroys 5 and creates 9
  stratum orbits (symbol multiplicities non-monotone); 45/54 exceptional
  weight-patterns hit would-be KT vanishing configurations — recorded
  LITERATURE-DEPENDENT, not applied. FIX-N2 landed 2026-08-05
  (`FIX-N2-CELLS-PARTIAL`, director-replayed): the `m = 1` row is EMPTY
  through `r = 5` (r = 4, 5 are new all-line-degree theorems, decided by
  the new Specialisation Lemma — adopted as Note II Lemma 2.3 — via three
  independent engines); **the cell `(2,6)` is POPULATED** (new explicit
  family, generalizing to `(2k, 3δ+3k)`) so even `m` is not uniformly
  empty; even-`m` bottom cells all empty; type-II-delay cell `(3,5)`
  empty; above-first-layer odd cells populated (`(3,8)`, `(3,9)`
  witnesses); structural finding: invariant multiplication reaches
  `{2k} ∪ {m₀+2k, m₀ ≥ 3}` but **never `m = 1`** — an `m = 1` family must
  be genuinely primitive, making the `m = 1` row the decisive local
  question. OPEN: `m = 1, r = 6` at positive line degree and `r ≥ 7`
  (per-`r` decidable; dispatched as FIX-N2b). Convention dictionary
  packet-vs-Note-II recorded; §4 family's residual scalar `λ = ω²`
  exhibited (previously asserted without scalars). FIX-A3 landed 2026-08-05
  (`FIX-A3-SITES-PASS`, director-replayed): the elliptic landing-site
  inventory is **COMPLETE with zero new sites** — 12 per `E_σ` (3 type-I
  + 9 type-II), 330 points in exactly the two known `G`-orbits;
  `C3`/`S3`-fixed candidates all off `X`; new structural fact: the 3
  type-I points of each `E_σ` lie on the `S3`-invariant std-line;
  type-II points generate degree-3 extensions of `Q(ζ₁₁)`
  (Galois-closure degree flagged open, unneeded). **The Note III site 𝒜
  is now fully finite and closed.** The CSP is now ASSEMBLED
  (`FIX_III_cosheaf.md` §4b, 2026-08-05): three variety-valued
  orbit-variables (`x_L` on the line stalk, `x_I` at the type-I vertex,
  `x_{II}` at the type-II relay) and six finite constraint families
  (line self-consistency with `S3`-equivariance; two-line vertex gluing
  via chain adjacency + ladder jet matching; `C₃` triangle rotation with
  the pinned `λ = ω²` scalars; three-elliptic type-II relay; dominance;
  cone/parity admissibility). `H⁰` = a constructible set computable by
  exact elimination starting from `x_L`. FIX-N2b landed 2026-08-05
  (`FIX-N2B-M1-ROW-PARTIAL`, director-replayed, 25 checks): the **`m = 2`
  row is fully decided** (Thm N2B-3: `(2,r)` populated for every
  `r ≥ 6`, with `(2,3..5)` empty — new families `e₂·D_B(x)`,
  `Δ·D_B(x)`); `(1,6)` has no plane-order-1 cone point (char-0 exact
  classification) and is excluded through line degree 2; the
  Specialisation Lemma provably cannot decide `(1, ≥7)`; the
  **stabilization conjecture** `FIX-N2B-STABILISATION` (every family is
  `G·D_B(X)` or mirror) would empty the whole `m = 1` row, with exact
  evidence at `r ≤ 6` and verified predictions at `r = 7,8,9`. **ALARM
  (not promoted, ledger rule):** modular-only evidence at `p = 100057`
  of plane-order-1 points in the `(1,7)` cone — if it lifts, the
  conjecture is false and a genuinely primitive `m = 1` branch exists.
  Decider packet FIX-N2c dispatched: multi-prime testing, rational
  lift attempt over `Q(ω, κ₊)`, and char-0 saturation of the
  plane-order-1 locus. Two negative structural results recorded to
  prevent re-attempts (the false `(1,6)` ladder step; the `J₅ = J₆`
  parity vacuity). Section-from-map
  theorem written to full rigor same day (`FIX_III_cosheaf.md` §4c, Thm
  5.1: every `f` induces a CSP solution, constraint by constraint;
  `H⁰ = ∅ ⇒` negative headline via [E37]/[E16]; converse not claimed) and
  the working-order recipe fixed (finite, from the cell table once
  FIX-N2c lands). **FIX-N2c landed 2026-08-05: THE ALARM
  WAS REAL** (`FIX-N2C-M1-R7-POPULATED`, director-replayed): the `(1,7)`
  cone contains plane-order-1 points in characteristic zero — an explicit
  closed-form primitive `m = 1` family whose parameter locus is cut by
  the Chebyshev cubics `c³−3c = κ₊+2`, `v³−3v = −27/(4(κ₊+2))`
  (`dim 0, deg 9` over `Q(ω, κ₊)` — refined by the packet's Thm N2C-1′:
  populated in ALL THREE eigenblocks, 9 witnesses per `λ`-block, 27
  total, with clean per-block Chebyshev ideals), corroborated by three
  split primes, msolve-over-QQ, numerics, and a from-scratch engine
  rebuild; invariant `q`-multiplication populates every odd `r ≥ 7`.
  **Uniformization fact for the CSP:** `c = B + B⁻¹`, `κ = B³ + B⁻³` —
  the primitive branch shares the `D_B` families' `B`-parameter: all
  stalk branches live on one reciprocal `B`-cover (FIX-H0 task D
  half-answered at the parameter level). `FIX-N2B-STABILISATION`
  is FALSE; packet-§6 exclusion (i) does NOT close; the cosheaf gains a
  primitive `m = 1` stalk branch no construction predicted. Remaining
  holes ((1,6) above line degree 2; even `r ≥ 8`) only ADD components:
  they gate a negative `H⁰` verdict, not a positive one. **Toolchain
  landmine (repo-wide, memory + MSOLVE_PARSER.md):** msolve 0.10.1
  silently mis-parses parenthesised qq-mode coefficients (exit 0, wrong
  GB, can report unit ideal for a consistent system — a false-EMPTY
  factory), and 0-byte outputs were being read as non-unit; one FIX-N2b
  sub-result (`λ=ω, B8`) is spurious for that reason (no verdict rested
  on it). FIX-H0 landed 2026-08-05
  (`FIX-H0-H0-PARTIAL`, director-replayed): **the program's first two
  unconditional global theorems** — H0-1 (plus-plane parity: for ANY
  equivariant dominant map, `m` is odd at every involution ⇒ the entire
  even-`m` stalk row is globally excluded; **correction 2026-08-05**: the
  odd-row holes — `(1,6)` above line degree 2 and `(1, even r ≥ 8)` —
  still gate a final negative verdict, since `m = 1` is odd; the H0
  theorems themselves are unconditional) and H0-2 (point-sections
  impossible: the σ-exceptional divisor `D_σ` maps ONTO `L_σ` — every
  hypothetical map is FORCED to sweep every line; direct input to the
  common-line program). Note III §4b corrected (a missing constraint
  class — the plus-plane leading half, the only one that removed
  components; within-triangle gluing already discharged by cell
  equivariance; the genuine remaining coupling is cross-V4 through each
  σ — three transpositions generating `S3`, with `ℓ_V ∩ L_σ = ∅`
  certified on all 55×55). Uniformization fully confirmed: one trace
  geometry, the `m = 1` branch over the odd-`m` branch under the cubic
  isogeny `τ ↦ τ³`, with the exact identity `(κ₊+2)(κ₋+2) = 27/4`
  making the `m = 1` stalk the `3×3` fibre product of the two character
  surfaces' trace covers. **`H⁰` now reduces to the cross-V4 coupling
  for exactly two surviving branches** (the `(3,·)` `D_B` family and the
  `(1, odd r ≥ 7)` primitive Chebyshev branch) — packet FIX-H1.
  Note III (compatibility cosheaf / global CSP on the verified
  arrangement), FIX-B (Burnside shadow). Director finding en route: the
  sealed `verify_kappa_genus2.py` is replay-brittle on sympy 1.14
  (structural equality vs a sign-flipped `factor` form; identity
  re-derived by hand and semantically — `V4-TRISECTION-GENUS2-QUOTIENT-
  PASS` stands; packet untouched).** **FIX-H1 landed 2026-08-05
  (`FIX-H1-PARTIAL`, director-replayed, 43/43 + by-hand re-derivation of
  both closed forms): Theorem H1-1 — the equalizer criterion derived to
  full rigor (`Φ = (N₁N₂N₃)^e·Ψ`, the mirror cubic carrying `sgn`;
  conditions only at orders `2e, 2e+1`; the transposition part automatic,
  the whole content the residual 3-cycle no `N_G(V4)`-computation sees),
  with the unconditional corollaries **`d ≥ 7r − 6m`** and **no
  line-degree-0 cell element is ever the leading datum of a global map**.
  Both classified branches FAIL the order-0 equalizer, unconditionally
  in `d`: `FIX-H1-EQ-M3-EMPTY` (the equalizer line pins
  `B_eff = (−5+ν)/6` and forces `B³+B⁻³ = (5−√33)/6` against the trace
  curve — both `κ`-roots, all four Galois twists) and `FIX-H1-EQ-M1-EMPTY`
  (`τ` forces `Λ` diagonal, `ρ` forces `B5 = λ·B8`, dead at all 27
  witnesses; closed form `4(κ₊+2)²+27 = 0` — **the equalizer is exactly
  the collision of the two character surfaces and the Klein identity
  `(κ₊+2)(κ₋+2) = 27/4` prevents it**). No per-V4 freedom (one `G`-class,
  one `A₄`-fixed stalk element, `C₃` permutes the three D12-points): one
  computation decides all 55×3 sites. Finding
  `FIX-H1-D12-IS-THE-CHEBYSHEV-POINT`: `β = −(1+c)`, `β³+3β²+κ₊ = 0` —
  the concurrency point IS the Chebyshev point. **Director correction
  H1-C (Note H1 §7)**: the equalizer conditions are inclusive of zero, so
  the `n₃`-divisible sub-family (`f` vanishing at all three D12-points,
  `d−r ≥ 6e+9`) evades the leading layer vacuously — the M3 kill's "every
  line degree" is corrected to "every line degree except `n₃ | f`, which
  joins the positive-line-degree unknowns"; the packet's pure-term
  degeneration handling and everything else stands. Secondary task, holes
  NOT closed: `FIX-H1-HOLE-1EVEN-PARTIAL` — `(1,8)` line degree 0 is
  282/288 leaves char-0 EMPTY with the sharp partial theorem (both
  plane-order-1 coefficients `B6, B9` must be nonzero); six hard leaves
  live (adopted). `FIX-H1-HOLE-16-PARTIAL` — `(1,6)` `n = 3,4,5`
  forced-zero mod `p = 100057` ONLY (finding; does not lift); `n = 6`
  live; `≥ 7` untouched; stabilisation in `n` unproved. Toolchain
  landmine #2 recorded (msolve `-g` `#`-header ⇒ `startswith('[1]')` is a
  false-NONEMPTY factory; MSOLVE_PARSER.md addendum + memory). FIX-C1
  landed 2026-08-05 (`FIX-C1-LADDER-M1-EXTENDS-THROUGH-3` mixed +
  `FIX-C1-OB2-NONZERO-AT-K-RATIONAL-POINT`, director-replayed, 48/48;
  dispatched as the direct answer to the constructive-use question):
  **Theorem C1-1** — the nine-point scheme's cubics are REDUCIBLE over
  `K`: `c₀ = (4κ₊−1)/3` (director-verified by hand: `c₀² = 2κ₊+1`,
  `c₀³ = 5κ₊+1`, so `c₀³−3c₀ = κ₊+2` exactly), `P1₀ = (4/3)ω^{j+1}c₀`;
  witnesses split Galois-stably `1+2+2+4` per block (parts A–D), part A
  the untwisted Chebyshev root — exactly where the `m = 1` branch meets
  the `D_B` parameter. **Theorem C1-2** — the ladder differential jumps
  at part A (rank 15 → 14, kernel 3 → 4) and the quadratic Kuranishi
  map is NONZERO there: `Ob₂ = ℓ₀ ⊗ L`, zero locus one hyperplane of
  the kernel (M2 exact, `dim 3, deg 4`, all three blocks; `ℓ₀` closed-form
  for `λ = 1`); the extra deformation direction existing only at the
  `K`-rational point is precisely the obstructed one. Obstructed-at-`n=0`
  propagates to EVERY line degree in the `h·T₀` ansatz — the three part-A
  witnesses are dead as leading data at all `d`. Parts B, C extend
  exactly through level 3 (`Ob₂ ≡ Ob₃ ≡ 0`; part D's level 3 unfinished)
  — but `FIX-C1-CONTROL-CALIBRATION-WEAK`: the same ladder on the `(3,6)`
  `D_B` seed (boundary data of the branch Fable killed at
  `I^{(11)}/I^{(13)}`, [E15](#e15)) is unobstructed at every level
  computed, so single-stratum "extends" verdicts carry little weight;
  only obstructions are information. Combined position after both
  packets: the classified branch data are dead (equalizer + H1-1(a) +
  part-A obstruction); the negative endgame is gated by the
  positive-line-degree unclassified space — the three tracked `m = 1`
  components (`(1,6)` `n ≥ 3`, map-relevant `n ≥ 30`; `(1, even r ≥ 8)`;
  `(1, odd r ≥ 7)` positive-`n` with the explicit two-scalar residual
  constraint), the H1-C `n₃`-divisible `D_B` sub-family, and the
  never-classified odd-`m ≥ 3` beyond-`D_B` class
  (`FIX-H0-PURE-ODDM-UNDECIDED`). Amendment recorded: FIX-N2C's
  ω/ω²-completion flush tail (Thm N2C-1′ text, `witness_om2.py`,
  corrected §6) landed after commit `8de0a37` — the worker-return write
  race again; witness replays + `verdict_checks.py` re-run green,
  committed with this update.** **External event 2026-08-05: the
  collaborator's notes received** ("Obstructions to equivariant rational
  maps", A. Duncan + AI assistants;
  `external_docs/duncan_higher_obstruction_20260805.tex`) — the
  independent formalization of the surface observation the T1 gate was
  built to reproduce. Full comparison in the director's reply of
  2026-08-05; summary: same trunk in two vocabularies (their {toroidal
  form via Bergh–Rydh destackification, `W_nt`-fibre connectivity
  ("fabulous" strata), iterated flag restrictions `F_σ`, RCC chains} ≅
  Note I's {b-complex minus decorations, funnel, chains, RCC
  propagation}); three independent convergences — their §6 application
  (S4 on `P²` vs the Fermat-quartic dP2: contraction forced, images
  identified through a fabulous V4-crossing born from breaking a
  non-abelian stabilizer, two Sylow-2s generate, `S^G = ∅`) is the T2/T3
  closing mechanism re-derived; their Thm 4.2 (pairs: fabulous ⟺
  `G_{D_ij}` NON-CYCLIC, with an explicit weighted-blowup severing ideal
  for the cyclic case) is the abstract iff behind our scalar-birth/V4-chain
  lemmas AND retroactively explains FIX-B's `C11`-points-surgically-
  removable verdict (cyclic ⟺ severable); their Lemma 6.4 = our Lemma 4.3
  mechanism. **Their genus-3 remark exposed Correction I-C** (Note I §4):
  Lemma 4.3's boxed consequence quantified over ALL models but its
  induction closes only for stabilizer-stratified towers; in-house sharper
  counterexample constructed (blow up the `G`-orbit of a generic quartic
  in `P_σ` — a genus-3 σ-fixed section on a legal model of `P(W)`).
  Audit: Thm 2.1/4.1, Lem 4.2, gate T1–T5, H0/N2/H1 untouched
  (jet-theoretic, resolution-free); Note III §1 re-based on H0-2 (the
  line sites carry every map via the forced sweeps — the funnel demoted
  from premise to motivation). Imports registered as candidates: the
  pairs-iff + severing ideal (would upgrade several chain arguments to
  iff-grade and gives a NEW test on the Klein source complex's cyclic
  crossings), the total-RCC theorem (Galois-on-trees + Tsen; the
  fibre-based repair of the funnel for arbitrary models), Bergh–Rydh
  foundations (no resolution of singularities), and the toric wall-graph
  fabulousness criterion. Their qualitative engine applied directly to
  the Klein headline hits exactly the E14 wall (X_nt of the Klein cubic
  CONTAINS the 55 rational lines, so "no rational curve in `Y_nt`" fails
  and their Thm 3.10 chains land legally in the arrangement) — FIX's
  decorated/jet layer (Notes II–III, H0/H1) is precisely the
  continuation past that wall; no contradiction between the frameworks
  anywhere. Follow-up 2026-08-05, on request: **Theorem T2′.1**
  (`theory/FIX_T_gate.md` §T2′) — Duncan's §6 application (S4 on the
  Fermat dP2) re-derived entirely in the calculus, step-named
  (scalar-birth T2.1 at the nonabelian `D8` quadruple point → V4-chain
  T2.2 at the born crossing → contraction via Lem 4.2/Cor 4.4 (dim-2
  scope, I-C vacuous on surfaces) → central obstruction Cor T3.1, two
  Sylow-2s generate, `S^{S4} = ∅`); group facts machine-checked; a fresh
  third sibling of T2/T3 closed with zero new lemmas, plus the CSP
  localization remark (only the exceptional-tree constraint is
  unsatisfiable — the original-arrangement system is solvable,
  matching Duncan's closing remark).** **FIX-H2 landed 2026-08-05
  (`FIX-H2-HOLE-16-N3-EMPTY` + `FIX-H2-HOLE-1EVEN-N0-MSOLVE-EMPTY`,
  director-replayed, 53 checks): H1's six hard `(1,8)` leaves were a
  PRESENTATION problem, not a hardness problem — the certified-strata
  licence (adjoin `Y1 = 0` to the whole `B6`-chart; 6 leaves → 3
  questions), the closed `U`-exponent-0 face (`Y0 = 0 ⇒ X1 = X2 = Y2 =
  0`, CASE Z/N dichotomy), and a cube-root cover `t³ = B9` splitting the
  true blocking cubic `X1³ = −Y0³B9²` decide ALL SIX as the unit ideal
  over `QQ` in 1–10 s each (msolve side complete; each run individually
  a full char-0 proof by Galois transitivity; the packet's two-engine
  seal stood at 1/6 M2 confirmations at close; **UPGRADED same day to
  `FIX-H2-HOLE-1EVEN-N0-EMPTY`** — after M2 and Singular proved
  coefficient-dependent/timeout-bound on these systems, the second
  engine was delivered by **OSCAR `groebner_basis_f4` under the freshly
  repaired official Julia build: all six cases unit,
  `OSCAR-ALL-UNIT: true`** (parser/encoding-path independent of the
  worker's text-mode msolve route — exactly the failure mode the
  two-engine rule guards; kernel-overlap caveat + full five-engine
  table in the packet's `director_amendment_20260805/README.md`; no
  terminated engine contradicts). **The `r = 8` cone has no
  plane-order-1 point at line degree 0 in any eigenblock** — the
  statement H1 was six leaves short of, now sealed. `(1,6)` at line degree 3 **closed in characteristic zero** (96
  runs, all unit; endpoint parameters as variables with their minimal
  polynomials; supersedes H1's mod-`p` finding); `n = 4, 5` built and
  validated, CPU-pending; the pipeline is parameterized in `r` (`r = 10`
  = one command). Strata A, C re-certified (3 engines, zero
  disagreements). Driver cover-vs-whole semantics bug caught mid-run
  (a cover's leaves must ALL be empty — the first version would have
  manufactured a false EMPTY on CASE N; fixed, recorded). Two M2
  landmines recorded (memory + debt): variables containing `_` are
  parsed as indexed subscripts (silent kill that reads like solver
  failure; rename `inv_Y0 → invY0`), and `saturate(I,{f,g})` is
  SUCCESSIVE saturation `I:(f·g)^∞`, not `I:(f,g)^∞` (verified on a
  discriminating example). **Director's registered prediction GRADED
  (the comparative the 2026-08-05 analytic derivation was for): the
  `(1,8)`-six-leaves call — NONEMPTY at 60/40, anchored over type-II
  points — was WRONG on both verdict and mechanism.** The frame was
  right (the `V4`-invariant normal form `F = C(a,b) + ΣQ_i·(squares) +
  c·xyz` is exact; the pure-`x^{3r}` coefficient IS `κ₊A³+κ₋B³`,
  irreducible over `K` — worker-confirmed), and "hardness = an
  irreducible cubic the reducer cannot split" was right IN KIND — but
  the anchor is VACUOUS on the cell (the `(1,r)` cell support bans
  `x^r` from every slot: the plane-order constraint `ord_{P_i} ≥ 1`,
  which the director's parity-only scratch check did not impose), and
  the actual blocking cubic is internal (`X1³ = −Y0³B9²`). The `(1,6)`
  call (EMPTY confirms, 90/10) was RIGHT at `n = 3`. Method lesson
  recorded: hand predictions about cells must impose the FULL cell
  constraints (support/plane-order bounds), not representation-theoretic
  admissibility alone. **REORDER (user directive, 2026-08-06): "prove
  that completing would close the result before computing." All new
  compute suspended (the mid-flight `(1,6)` `n = 4` run finishes on its
  own; `n = 5`, char-0 `n = 6`, `r = 10` NOT fired). Note IV opened
  (`theory/FIX_IV_closure.md`): the CONDITIONAL CLOSURE THEOREM
  (Thm 3.1) — proved inputs (P1)–(P7) plus four named unproved
  hypotheses ([U1] shape-uniformity in `n`; [U2] `r`-tower reduction —
  the keystone; [U3] odd `m ≥ 5`; [L] layered-equalizer exhaustiveness)
  imply `H⁰ = ∅` and the negative headline. First new lemma proved en
  route (Note IV Lemma 2.1): the `q`-tower FIXES leading line jets
  (`j(qT) = j(T)`), so reachable-jet sets increase along each parity
  class of `r` and the Chebyshev tower's jets are constant in `r` —
  the opening move of [U2]. Compute is now strictly downstream: a run
  fires only when a hypothesis proof names its verdict as a base
  clause. Derivation log opened (Note IV §5, 2026-08-06): **Lemma 5.1**
  (hand-proved multiplicity formula: `dim V_m[triv] = dim V_m[sgn] =
  ((m+1) − χ_{Sym^m}(ρ))/3` — the equalizer space GROWS with `m`, so
  [U3] must go through divisibility, not pinning: strategy corrected);
  **Lemma 5.2** (family structure: a positive-`n` leading datum is a
  `C₃`-equivariant morphism `ℓ_V → cone` with fibers at the TWO
  `C₃`-fixed points pinned to the classified equivariant locus);
  **Prop 5.3** (constancy criterion: if the pointwise non-equivariant
  `PO₁(r)` locus is finite, [U1] holds for the `(1,r)` row modulo a
  finite `u₀+v₀` check); **§5.4** ([L] groundwork correction: the naive
  layer tower's kinematic conditions thin out — [L] must be an
  equalizer OF THE LADDER, coupled through `F`, not of the
  representation). First proof-named computation dispatched:
  `FIN(7)` (packet `goal_runs_after_9094303/FIX_U1_FIN7`, in flight) —
  either verdict directs the [U1] proof. Second derivation wave (Note
  IV §§5.5–5.8, same day): **Lemma 5.5** (concurrency amplification:
  line-wise order-2 vanishing at `c_σ` forces full order 3; every jet
  term below the line-wise order is `D_T`-divisible; first escape =
  `D_T ⊗ w₁`, `w₁ ∈ V[sgn^{e+1}]`); **Lemma 5.6** (the kinematic tower
  terminates — the evasion channel is kinematically free past order
  `2e+1`, so [L] MUST go through the landing coupling); **§5.7** (the
  coupled tower exact from certified A3: `F = F₀ + Q`, level identities
  `I₀: Q(Θ⁽⁰⁾; Φ⁽⁰⁾, Φ⁽⁰⁾) ≡ 0`, `I₁`, … — a NEW global identity
  neither H0 nor H1 used; `Q` has exactly two isotypic frame constants
  `α, β`); **§5.8** (the first transfer condition, proved modulo stated
  case bookkeeping: on the maximal evasion channel,
  `c²·[αθ_t(γ⊗γ)_t + β⟨θ_s,(γ⊗γ)_s⟩] = 0` — either the evasion
  coefficient dies or `Θ⁽⁰⁾(c_σ)` is forced onto an explicit
  hyperplane; the [L]-ladder's first rung in closed form). Second
  proof-named computation dispatched: `FIX-L1` (frame constants,
  `γ`-generators for `m = 1, 3` both twists, transfer-pairing
  nondegeneracy; packet `goal_runs_after_9094303/FIX_L1_FRAME_CONSTANTS`,
  in flight). Third derivation wave (Note IV §5.9 + Correction IV-a,
  2026-08-06): **Correction IV-a, self-caught** — Lemma 2.1's corollary
  `j(qT) = j(T)` conflated jet orders (the `(m,r+2)` cell reads orders
  `2e+4, 2e+5` of the same section); corollary withdrawn, section-
  invariance stands, [U2] reframed. **Theorem 5.9 (the recursion
  principle)**: pointwise cone elements ARE V4-equivariant rational
  maps `P² ⇢ X`; at odd `r`, parity alone forces each source V4-line
  into the corresponding target 55-line and each source vertex to a
  χ-vertex on the elliptic (`X^{V4}` = exactly 6 points: 3 type-II + 3
  χ-vertices); line-restrictions are unconstrained at `x`-level 0
  (`L ⊂ X`, certificate A2) and constrained only by the higher-level
  source-side `I_k` identities. **Torus correction to Prop 5.3**: the
  diagonal 2-torus makes literal finiteness trivially false; the
  criterion is corrected to finitely-many-torus-orbits and SURVIVES
  (complete rational curves in a torus are constant); the FIN(7)
  worker redirected mid-flight before the wasted verdict. **[U2]'s
  sharpest form**: one structure theorem classifying V4-equivariant
  `P² ⇢ X` uniformly in degree — the program recursing onto its own
  surface case, where the collaborators' machinery (T2.2 chains =
  fabulous crossings at the non-cyclic source vertices) applies
  verbatim. Fourth derivation wave (Note IV §5.10, 2026-08-06): **the
  source-side ladder in closed form** — the level-1 identity along a
  source line is `(Q₂ₐuP² + Q₃ₐvQ²)A + (Q₂ᵦuP² + Q₃ᵦvQ²)B + cPQU ≡ 0`
  (the target-line partials vanish because `L ⊂ X`: the minus-normal
  data is level-1-free, the plus-normal data enters linearly) — and
  **Lemma 5.10 (squareness, uniform in `r`)**: the level-1 system is
  SQUARE (`3s+1 × 3s+1`, `r = 2s+1`) at every odd `r`, so a UNIVERSAL
  matrix `M(P,Q)` of degree-independent shape governs the row: generic
  line-maps rigidly determine the first normal layer; all branch/moduli
  phenomena are confined to `det M = 0` and the level-≥2 consistency
  resultants — polynomial objects of fixed shape. [U2]'s proof plan is
  now concrete (show the consistency locus is a finite union of torus
  orbits of the known shapes, one argument for all odd `r`), and the
  redirected FIN(7) computation measures exactly this system's kernel
  at the 27 witnesses: derivation and computation converged on the
  same object. Fifth derivation wave (Note IV §5.11, 2026-08-06):
  **Theorem 5.11, three parts, all by hand** — (i) strict parity
  alternation at odd `r` (minus slots even in `x`, plus slots odd: the
  normal ladder alternates strictly); (ii) **level 2 is VACUOUS**
  (`d²F` on plus⊗plus vanishes along the line, `dF` kills minus, and
  level-2 data is pure minus: the `x²`-identity is `0 + 0`) — an entire
  ladder level collapses, the first genuine consistency conditions on
  the line map live at level ≥ 3; (iii) **rigidity**:
  `det M(P,Q) ≠ 0` whenever `gcd(P,Q) = 1`, `u ∤ Q`, `v ∤ P` — a clean
  divisibility proof, uniform in `r`: on the nondegenerate stratum the
  first plus-layer is uniquely determined by the line map; (iv) the
  three degeneration strata are geometric — base points on the line
  (DEGREE DROP: downward induction in `s`) and vertex base points
  (partially forbidden outright by plane-order-1). The `(1, odd r)`
  row now splits into a rigid stratum (consistency analysis at levels
  ≥ 3 on `(P,Q)` alone) plus inductively-descending degenerations —
  the structure [U2]'s uniformity needed. Next: compute the crossing
  level `ℓ*(s)` and the leading consistency resultant. Sixth
  derivation wave (Note IV §§5.12–5.14, 2026-08-06): **Theorem 5.12
  (the balance theorem)** — all even levels of the landing identity
  are EMPTY by pure V4-parity (subsuming 5.11(ii)'s Hessian argument);
  exact counts per level; the cumulative deficit is `D(2T+1) =
  2T(T−s)`: zero at level 1, negative through the middle, **exactly
  zero at the last unknown level `r`** — the source ladder is
  precisely critical — and the tail levels `r+2 … 3r` impose exactly
  **`s·r` pure consistency equations on `2s−1` essential line-map
  parameters** (overdetermination margin `2s²−s+1`, growing
  quadratically: the right shape for uniform finiteness); `ℓ* = r+2`
  for every `s`. **§5.13: [U3] MERGED into [U1]/[U2]** — the slot
  parities are `m`-independent, so all odd `m` sit in ONE master
  consistency variety filtered by endpoint vanishing orders, and the
  deep-`m` strata are exactly the vertex-degenerate strata already in
  the degree-drop induction (dictionary owed, no new mechanism).
  **§5.14: the full reduction status** — remaining THEOREMS: (T1)
  tail uniformity (the keystone's final form: rigid-stratum
  consistency = finite torus orbits, uniformly in `s`; induction base
  = the sealed `(1, r ≤ 5)` ledger) and (T2) [L]-completion (rung 2 +
  exhaustiveness, blocked only on FIX-L1 constants); unavoidable CAS:
  (C1) FIN(7) in flight, (C2) FIX-L1 in flight, (C3) the `s = 3` tail
  resultant when (T1) names its base requirement, (C4) even-`r` base
  cases ALREADY BANKED. Assembly + audit close the program once
  (T1), (T2) land. Seventh wave — (T2) EXECUTED and FIX-L1 LANDED
  (Note IV §§5.15–5.17, 2026-08-06): **Theorem 5.15 (finite-rung
  exhaustiveness, proved)** — in the constancy regime a degree-`n`
  form cannot vanish to total order `> n` across the D12-orbit, so at
  most `⌈n/3⌉+1` rungs are needed and "all layers vanish" contradicts
  the sweep (P3); **Reduction 5.15′** — [L] holds given (T1) + (C2)
  + one finite rung-independence check (C2′); the §5.8 case
  bookkeeping is subsumed (the budget is order-pattern-independent).
  **Theorem 5.16 (division dichotomy, proved)** — on the `u+v`
  gcd-stratum, either `q | T` (degree drop, the induction descends)
  or the conic-restriction is a nonzero V4-equivariant landing datum
  on the invariant conic: a NEW recursion floor `P⁴ → P² → P¹`
  (V4-equivariant rational curves on `X` with six-point vanishing),
  named (T1b). **§5.17: (T1) decomposed** into (T1a) rigid-tail orbit
  finiteness — THE remaining core — (T1b) the conic floor, (T1c)
  endpoint bookkeeping. **FIX-L1 landed same day
  (`FIX-L1-CONSTANTS-OK`, director-replayed 272/272)**: `α = 12c ≠ 0`
  with `F(c_σ) = c³` — the t-channel nondegeneracy IS the certified
  "`c_σ` off `X`", structurally undegenerable; `β = 1`; transfer
  NONVACUOUS in all four `(m,twist)` cases; all four generators
  closed-form (`V₃[sgn]` matches H1); worker-caught correction to
  §5.8 applied (`Θ`-space 3-dim at `m = 3`, transfer codim 2);
  flagged open bookkeeping: possible forced `D`-divisibility of
  `Θ⁽⁰⁾` (shifts rung orders, budget unaffected). **(C2) DISCHARGED.
  The negative headline now rests on: (T1a), (T1b) as theorems;
  (C1) in flight, (C2′), (C3) named; (T1c) bookkeeping; assembly +
  audit. Eighth wave — (T1a) attacked at maximal depth (Note IV
  §5.18, 2026-08-06): **Correction IV-b, self-caught** (the first
  top-tail computation missed the `Q₁·u₀'²` term; corrected equation
  `P0·Q₁(α) + c·β₁β₂ = 0` = the SECOND FUNDAMENTAL FORM of `X` at the
  χ-vertex applied to the map's 2-jet); **Theorem 5.18-A** — the tail
  IS the vertex-jet landing system (levels ↔ vertex jets to order
  `2r−2`; the consistency variety = the two-boundary problem
  line-boundary vs vertex-jet, with the higher fundamental forms as
  the successive equations); **Theorem 5.18-B** — the
  double-projection reformulation: the χ-vertex lies on `X` (and on
  `L₂, L₃`), projection from it is V4-equivariant 2:1 onto `P³`
  branched over a quartic `Δ_v`, so V4-maps into `X` = V4-maps into
  `P³` + a sheet datum with the DISCRETE divisibility condition
  `h*(Δ_v)` even — the landing condition becomes degree-uniform
  parity over a free mapping space. Named: the equivariant lifting
  criterion over the contracted lines (derivation), **(C5)** compute
  `Δ_v` + V4-structure (small CAS), then orbit-finiteness as a
  parity-class count. **(T1a) NOT closed tonight — stated plainly;
  the double projection is the weapon it will be closed with. Ninth
  wave (Note IV §5.19, 2026-08-06): **the branch quartic in closed
  form, by hand** — `Δ_v = c²y²z² − 4Q₁(Q₂y² + Q₃z² + C)`, with the
  `x′`-cancellation as built-in consistency check and
  `Δ_v ≡ (cyz)² mod Q₁`; **the γ-criterion (proved)** — `h` lifts to
  `X` iff `Q₂Y² + Q₃Z² + C = γ(cYZ − Q₁γ)` for a `χ₁`-form `γ`;
  **honest scope recorded**: pointwise the projection is a REWRITING
  of `F(T) = 0` (`u₀′ = xγ̃` collapses the 52-equation systems to ONE
  degree-`3s` identity in the invariant variables `(t,v,w)` — adopt
  for all (C3)-type runs), while the NEW content is the family-level
  monodromy principle: sheet data of `P¹`-families is finite 2-torsion
  branch-parity data, giving the discrete stratification the (T1a)
  parity count runs on. `FIX-C5` dispatched (in flight): verify
  `Δ_v`, irreducibility, singular locus, the census of `X`-lines
  through the χ-vertex, γ-criterion smoke test on a Chebyshev
  witness. Tenth wave, at /effort max on "finish (T1a)" (Note IV
  §5.20, 2026-08-06): **Theorem 5.20 (proved)** — projecting from the
  V4-stable LINE `L₁ ⊂ X` gives the classical conic bundle
  equivariantly; (a) the landing identity is QUADRATIC in the minus
  data (`q_φ(Ỹ,Z̃) = m_φ`, explicit Gram; a pointwise element = base
  map `φ` + a section of the pulled-back conic bundle); (b) **the
  discriminant quintic FACTORS: `Δ₅ = F₀·(4Q₂Q₃ − c²x²) = E_{σ₁} ∪ 
  (V4-conic)`** — the arrangement's elliptic curve IS a discriminant
  component of the Clemens–Griffiths structure (generic cubics have
  irreducible Δ₅; the V4-line splits it): the FIX geometry and the
  classical conic-bundle geometry are one object; (c) **(T1a) splits**
  into the PARITY half (function-field solvability = vanishing of the
  2-torsion Brauer class `φ*β`, residues along the two Δ₅-components —
  discrete, degree-uniform, provable by residue calculus: named (D1),
  mechanical) and the HEIGHT half (degree-`s` sections finite mod
  torus on the admissible locus — the elliptic discriminant component
  puts this in the arena of function-field Mordell–Weil/LANG–NÉRON
  finite generation, the first theorem-backed route to the finiteness:
  named (D2), the last substantive analytic step). **(T1a) NOT closed
  at max effort — split, with (D1) bookkeeping and (D2) the final
  boss, now carrying a classical finiteness theorem instead of a
  counting heuristic. Eleventh wave (Note IV §§5.21–5.22,
  2026-08-06): **(D1) CLOSED — Theorem 5.21 (proved)**: the Brauer
  class is `β = (−F₀Q₂, Δ_c)`; residues live only on the two
  discriminant components (the `{Q₂=0}` corner is `−(cx)²`, a square,
  and its conic intersection is even — both residue classes hang on
  the SAME six-point divisor `E ∩ K_c`); `φ` extends across the
  source lines (the common `x` cancels — the boundary indeterminacy
  evaporates); and `φ*β = 0 ⟺` per-component lifting to the ONE
  elliptic double cover `Ẽ → E` plus even tangency against the
  six-point divisor on the `K_c`-side (pure intersection parity for
  rational components). Admissibility is thereby DISCRETE and
  degree-uniform: the stratification (D2) runs on is proved
  finite-type. **FIN(7) landed and integrated
  (`FIX-U1-FIN7-NOT-FINITE-MOD-TORUS-DIM-GE-15`, replayed 104/104)**:
  three linear 17-dim components (image-in-line maps) kill the
  constancy route at `r = 7` — Prop 5.3 is DEAD as the [U1]
  mechanism; essential tangent = 2 evidenced (bracket `[0,2]`
  certified) at the B/C/D witnesses; `u₀+v₀ ≠ 0` at all 27
  (the §5.3 check discharged); `u₀−v₀ ≠ 0` independently reconfirms
  the H1 kill. **Correction IV-c (third instance of the
  support-bounds error class)**: §5.9(b) vertices are BASE POINTS for
  `m ≥ 1`; §5.18's displayed equations m-naive (structure survives,
  re-derivation owed); N2C's nine-point scheme singular at part A
  (linear-slice refinement). Banked: `F(T) = xyz·G` + the degree-14
  perfect-square normal form (30 unknowns) — the concrete
  (C3)-object. New small item **(D3)**: exact linear jet/equalizer
  analysis of the image-in-line components. **Remaining for the
  negative headline: (D2) height finiteness (Lang–Néron route), (D3)
  linear, (T1b) conic floor, (C2′), (C3), (C5) in flight, (T1c)
  bookkeeping, assembly + audit. Twelfth wave (Note IV §5.23,
  2026-08-06): **(D2) RESOLVED BY BOUNDARY RIGIDITY — Theorem 5.23
  (proved)**: (i) the conic inhomogeneity `m_φ` vanishes on every
  source line, so the section's boundary value is an ISOTROPIC vector
  of `q_φ|_line` — the line-map `(P,Q)` is a DISCRETE branch choice
  (`(cγ̃ ± √Δ_q)/2vQ₂`-type), not a modulus; (ii) section
  deformations (`ζ′ = ζρ√Δ_q/m_φ`) are pole-forced into the occupied
  isotropic direction on the lines — interior moduli CANNOT move the
  boundary jets; (iii) hence FIN(7)'s essential moduli, the Pell/unit
  torsor structure, and any unbounded pointwise components are ALL
  invisible to the equalizer — **no global finiteness is needed;
  Lang–Néron exits the program**; (iv) [U1] reduces to the finite
  boundary-jet computation **(D2′/C6)**: the equalizer conditions on
  branch-root jets at the three D12-points, which is the SAME
  `Δ_q`-parity calculus as (D1) at three marked points —
  finite-dimensional, degree-uniform. **The last conceptual obstacle
  in (T1a) is gone. Remaining, all finite and named: (D2′), (D3),
  (T1b), (C2′), (C3), (C5 in flight), (T1c), assembly + audit.
  Thirteenth wave (Note IV §5.24, 2026-08-06): **Correction IV-d
  (fourth self-caught, conceptual)** — 5.23(iii) overclaimed: the
  equalizer consumes the fibers' VERTEX-side data (`Λ = diag(β₁,β₂)`,
  the section at the fiber vertex), not the source-line data whose
  rigidity 5.23(i)–(ii) proved. Replaced by something stronger:
  **Thm 5.24-A (product pinning)** — the vertex conic relation pins
  `β₁β₂ = g(λ)`, an explicit plus-side function (`Q₁γ̃/c` at the
  vertex); only the ratio is an interior modulus. **Thm 5.24-B
  (square-root structure)** — equalizer-passing jets satisfy
  `w² = g_{4e}(p_i)`: the nonvanishing branch passes the buck
  entirely to the Θ-jets at `c_σ`, where I₀/I₁ live — **[U1] and [L]
  merge into one coupled jet problem**. **Thm 5.24-C ((D3) CLOSED,
  one line)** — image-in-line components have plus ≡ 0 ⟹ `g ≡ 0` ⟹
  `w = 0`: equalizer jets vanish there in every degree. **The
  TERMINAL SYSTEM (D2″)** defined: five coupled jet conditions at
  `c_σ` (square-root pinning, order-1 equalizer, I₀-transfer with the
  L1 constants `α = 12c, β = 1`, the `g`-loop in the same
  θ-variables, I₁-binding) — ONE exact finite computation decides the
  `w ≠ 0` branch; `w = 0` is the evasion channel killed by [L]
  (budget 5.15 + (C2) discharged + (C2′)). **Supersessions with
  justification: (T1b), (T1c), (C3) RETIRE** — the terminal-system
  route is component-agnostic (uses only P2–P4, the vertex relation,
  I₀/I₁, L1 constants; never the pointwise classification).
  **Complete remaining ledger: (D2″) + (C2′), then assembly + the
  full independent audit. Nothing else remains. **FIX-D2 dispatched
  (in flight, `goal_runs_after_354a548/FIX_D2_TERMINAL_SYSTEM`): the
  terminal system (D2″) at `c_σ` for `m = 1, 3` + the (C2′)
  rung-independence check — the last two computations of the negative
  program; either terminal verdict feeds the director's assembly of
  Thm 3.1 (INCONSISTENT ⟹ [U1] via the `w = 0` channel + [L];
  SOLVABLE ⟹ an explicit candidate jet, a finding of first
  importance). Fourteenth wave (Note IV §5.25, 2026-08-06, on the
  user's compress-D2 challenge): **Correction IV-e (fifth
  self-caught, BEFORE the computation ran)** — 5.24-A's product
  pinning is VACUOUS (`γ̃₀ = [x^r]u₀′ ≡ 0`: the vertex is a base
  point, IV-c's own content; the same support-error class, caught
  in time); 5.24-C's one-line (D3) kill is withdrawn with it (the
  image-in-line stratum re-enters the terminal system). Replaced by
  stronger theorems: **Thm 5.25-A (the Brutality Theorem)** —
  `w ≠ 0 ⟹ Ψ(c_σ) = w·id` invertible `⟹ det Ψ ≢ 0 ⟹` (I₀ + the
  L1 fact that `Q` is an ISOMORPHISM `W⁺ ≅ (Sym²W⁻)*`)
  **`Θ⁽⁰⁾ ≡ 0` identically** — the plus-half hyper-vanishes to
  order `m+3` at all 55 planes; a TOTAL kill replacing 5.8's
  hyperplane transfer, no computation needed. **Thm 5.25-B** — `I₁`
  then kills exactly the 7-dim diagonal contraction of `Θ⁽¹⁾`
  (8-dim residual). **The terminal system COMPRESSED (D2″-v2)**:
  remaining crux = whether the level-`(3r−6)` β-relation
  coefficients lie in `I₁`'s killed 7 or the free 8, plus H1-1
  orders 0/1, the `I₂`-binding, and the multi-frame closure; the
  FIX-D2 worker REDIRECTED mid-flight (two brief conditions became
  theorems, one exposed vacuous; verification of `Q`-isomorphy and
  the rank-7 count assigned as cheap cross-checks). Fifteenth wave
  (Note IV §5.26, 2026-08-06): **the crux decided by hand** —
  **Thm 5.26-A**: `κ` is the multiplication `(Sym⁴)*⊗(Sym²)* →
  (Sym⁶)*`, surjective (comultiplication injectivity), kernel
  `≅ (Sym⁴)* ⊕ (Sym²)*` (Clebsch–Gordan `4⊗2 = 6⊕4⊕2`) — 5.25-B
  proved structurally with exact kernel coordinates; **Thm 5.26-B**:
  the level-`(3r−6)` β-relations are the `x`-top graded piece of
  `I₁` itself (one identity, two gradings) and constrain `Θ⁽¹⁾`'s
  twisted diagonal, NOT the β's — solvable for any invertible
  minus-datum; every level `I_k` is level-locally solvable through
  its surjective contraction. **The terminal question in final form
  (D2″-v3): the GLOBAL DEGREE BUDGET** — with `Θ⁽⁰⁾ ≡ 0` at all 55
  planes the plus-half is forced into `I^{(4)}`-type symbolic-power
  loci of the 55-plane arrangement while the minus-half holds order
  1 with nonvanishing equalizer jets: **exactly Fable's original
  `I^{(m)}`-ladder territory ([E15]), whose dimension tables are
  banked in the repo** — the terminal computation is a feasibility
  count on certified data (infeasible ∀d = the kill; feasible = the
  explicit candidate). Worker re-redirected (second redirect: two of
  its three derivation tasks now theorems; target = the budget
  count consuming the E15-era tables). Sixteenth wave — **FIX-C5
  landed (`FIX-C5-GEOMETRY-OK`, director-replayed, five green routes:
  139/180/M2/OSCAR/61)**: the hand-derived `Δ_v` VERIFIED three ways
  (incl. `Res_x(F, ∂F/∂x) = −Q₁Δ_v`); **absolutely irreducible** —
  the 5.18-B parity condition is single-channel; **`Sing(Δ_v) = six
  ordinary nodes**, all on `{Q₁ = 0}`, and `π_v(contracted locus) =
  Sing(Δ_v)` AS SCHEMES; **line census: exactly 6 lines through the
  χ₁-vertex** (the classical count) — `L₂ = ℓ_{σ₃}`, `L₃ = ℓ_{σ₂}`
  from the 55-arrangement plus FOUR NEW lines over quadratic
  extensions (V4-orbits 2+2); `Δ_v` is a 6-nodal quartic (nodal K3),
  `Δ_v/V4` rational. Smoke test on the sealed N2C witness PASSES
  with two worker-caught findings applied: **(C5-1)** the §5.19
  dictionary sign is `γ = −u₀′` (corrected); **(C5-2)** the
  invariant identity is a faithful 52-coefficient reindexing (3
  variables, degree `3s`), not an equation-count reduction; plus a
  notation-collision note (`c` = xyz-coefficient ≠ FIX-L1's
  Chebyshev `c`). The (D1)-criterion's specific tangency data
  (`E ∩ K_c` of the LINE projection) remains write-up material,
  extractable by the same methods. Seventeenth wave (Note IV §5.27,
  2026-08-06): **the plus-deep reduction** — on the `w ≠ 0` branch,
  Brutality forces every fiber into the plus-deep sub-locus (order-2
  plus coefficients = 0), a LINEAR slice of the sealed N2C system;
  the 27 Chebyshev witnesses (plus-order exactly 2) are EXCLUDED, so
  the fibers live in the image-in-line components or in
  as-yet-unknown plus-deep extras. **Named (C7)** (cheap,
  route-deciding): solve the sealed 52-equation system + the linear
  plus-deep conditions — image-in-line-only vs explicit extra
  candidates. **The departure recursion** (proposition, sketch
  recorded): if image-in-line-only, the `w ≠ 0` germ hugs one
  arrangement line; the departure package at the first off-line cone
  order re-enters the SAME machinery (self-similar, shape
  degree-independent) — either every stage kills (⟹ image in the
  line ⟹ non-dominant ⟹ KILL) or one stage's system is solvable
  (⟹ the explicit candidate); **one stage computation decides all
  stages**, and the E15-table budget count demotes to FALLBACK.
  FIX-D2 re-redirected (third): (C7) first, then the stage system;
  output-discipline directive in force after the worker's 64k
  overflow death and resume. Eighteenth wave — **director probe of
  (C7)** (2026-08-06, UNSEALED, msolve single-engine on six
  bare-integer systems, seconds each; worker seals): **the
  equivariant plus-deep PO-1 locus at `r = 7` is EMPTY** (unit ideal,
  all three eigenblocks, both saturations). Consequences modulo
  sealing (Note IV §5.27-probe block): (i) the image-in-line
  components are purely NON-equivariant (the C3-relations make the
  three minus slots rotations of one function — found en route,
  exact); (ii) on the `w ≠ 0` branch the fibers at the TWO C3-fixed
  points of `ℓ_V` are equivariant + plus-deep, hence NOT PO-1: their
  minus-order jumps to ≥ 3 (parity), `Λ` vanishes at five marked
  points (`3 D12 + 2 C3-fixed`), the degree bound sharpens to
  `n ≥ 6e + 2`, and the special fibers are forced into the
  `D_B`-shaped plus-deep locus. The `w ≠ 0` germ is pinned:
  generically PO-1, `D_B`-type at the special points — the stage
  analysis inherits this. Probe artifacts in the session scratchpad;
  the sealed (C7) with two engines + controls remains FIX-D2's
  deliverable. **NINETEENTH WAVE — THE TERMINAL VERDICT (FIX-D2
  landed 2026-08-06, director-replayed 68/68 + 29 producer + 11
  controls; verifier fully independent, own field model):
  `FIX-D2-TERMINAL-SOLVABLE` — the `w ≠ 0` branch of [U1] is NOT
  killed by the `c_σ`-localized machinery.** **Correction IV-f
  (worker-caught, double-refuted — the sixth and deepest): Theorem
  5.25-A (Brutality) is FALSE** — `Θ⁽⁰⁾` carries `y`-arguments of
  order `m+1` (§5.7's own level count requires it), so `I₀` kills
  only the diagonal contraction (rank 5/9 at `m=1`, 7/15 at `m=3`),
  exactly consistent with FIX-L1's banked equivariant ranks
  (reproduced from scratch, survivors exhibited). Withdrawn in
  cascade: 5.25-A; §5.27's plus-deep reduction, departure recursion,
  and the (C7) premise (the director probe's emptiness stands as a
  computation but no longer bears on the branch); the `I^{(4)}`/E15
  budget framing (corrected condition: a rank-4 subbundle condition
  on order-2 jets; NO global `h⁰(I^{(k)}(d))` tables exist — the
  `I^{(11)}/I^{(13)}` numbers are LOCAL D12 data). Confirmed
  positively: 5.26-A exactly (rank 7, ker 5+3), 5.26-B one level
  earlier, `Q`-isomorphy, unambiguous order-accounting. **(C2′)**:
  `m=1` rungs INDEPENDENT; `m=3` DEPENDENT with exact cause
  (`V₃[twist] = quadratic·V₁[twist]` — the H1-forced `m=3` datum is
  degenerate). **(D3): NOT-KILLED** (landing automatic on
  `T⁺ ≡ 0`; only non-dominance excludes, which does not bind germ
  data). **Load-bearing fact: the residual `Θ`-freedom GROWS along
  the ladder (1,2,4,7 / 1,4,7) — the `I`-ladder can never exhaust
  the jet space. Consequence: Thm 3.1 remains CONDITIONAL, [U1] is
  genuinely OPEN, the Note-IV endgame does NOT close by
  D12-localization; remaining negative options are GLOBAL (the
  corrected budget/moduli question, unbanked and hard) or
  beyond-FIX machinery. The jet-solvable locus is recorded as
  potential positive-side evidence per the standing directive
  (stated, not pursued). Problem E headline: OPEN. **GOAL PIVOT
  (user directive, 2026-08-06, superseding the 08-05 negative-only
  rule): "This clearly puts constraints on the possible rational maps
  giving unirationality. Use this info as a guide to produce an
  explicit such map." THE CONSTRUCTION PROGRAM opens — Note V
  (`theory/FIX_V_construction.md`): the entire negative campaign
  converts into the sieve and ansatz. The forced profile of any map
  (sealed): multi-order/parity/base-locus/sweep/degree bound
  `d ≥ 7r−6m`/H1-1 jets, with the classified shapes dead and exactly
  two survivor channels (the `w = 0` evasion; FIX-D2's `w ≠ 0`
  jet-solvable locus). Window arithmetic: at `d = 25` (the ladder's
  minimal open degree, ≤ 24 sealed closed) the ONLY admissible
  profile is `(3,6)` with `n = 19` in the evasion channel — whether
  `n = 19` passes the line-degree dictionary is the sieve's first
  question (a NO closes `d = 25` by pure profile arithmetic, a new
  ladder-closure theorem). First `(1,7)` window: `d = 43` (where the
  FIX-D2 solvable jets live). Route 1: the guided degree-25 transfer
  (E25's parked `F_67` branches, now SLICED by the FIX ansatz) —
  **FIX-P1 dispatched** (in flight,
  `goal_runs_after_063da5a/FIX_P1_DEGREE25_GUIDED`): Stage 1 the
  sieve, Stage 2 the guided search; candidate ⟹ the director's
  E17-dominance verification chain; emptiness ⟹ the sieve advances.
  Route 2 (queued): prolongation from the FIX-D2 solvable jets
  toward `d = 43` with the corrected γ-dictionary. Cautions carried:
  jet-solvability ≠ algebraization (T5/C1); every candidate gets the
  full two-engine seal; all six Note-IV corrections were
  support-class errors — every ansatz dimension count
  machine-verified before consumption. **FIX-P1 LANDED
  (2026-08-06, director-replayed 35/35):
  `FIX-P1-D25-CLOSED-BY-PROFILE` + `FIX-P1-WINDOW-25-EMPTY` + the
  SWEEP THEOREM — no
  equivariant dominant map of degree ≤ 35 exists in characteristic
  zero** (previous sealed cutoff: 24). Stage 1 (the dictionary):
  `D_B` is CUBIC in `X = f·yz`, so `n = 3·deg f` — `3 | n` always
  (19 excluded at `d = 25`); H1-1(a) ⟺ `n₃²|f` (`n ≥ 18`); evasion
  ⟺ `n₃³|f` (`n ≥ 27 = 6e+9`, reproducing Correction H1-C's bound
  exactly); Lemma P1-1 (shape-free order window `2e ≤ ord ≤
  ⌊n/3⌋`). Bonus theorems: P1-A (`d ≥ 24` by pure profile
  arithmetic — an independent re-derivation of the sealed ladder
  cutoff), P1-B (`d ≥ 3r+2`), P1-C (odd-`m` bottom cells empty).
  Stage 2: `dim M₂₅ = 189`; the profile slice cascades
  `189 → 59 → 3 → 0` — at degree 25 the max plane order is 2 (need
  3) and max line order 4 (need 6): the landing equations were
  never needed. The `F₆₇` order-2 branch was NEVER inside the
  admissible profile (`(1,2)` empty); the order-≥4 branch is now
  char-0 empty. Sweep: every admissible profile at every
  `24 ≤ d ≤ 35` has a ZERO slice; every `m ≥ 3` profile stays zero
  through `d = 38` (killing H1-C's evasion sub-family globally at
  its only degrees ≤ 38). **FIRST OPEN WINDOW: `d = 36`,
  `(m,r) = (1,6)`, `n = 30`, slice dim ≤ 83 — exactly Note II's
  `(1,6)` hole at exactly its H1-1(a) minimal degree: the
  gateway.** NOT DECIDED: `d ≥ 39`; the `(1,6)` stratum at
  `d ≥ 36`. Scope: dominant maps only. **FIX-P2 dispatched** (in
  flight, `goal_runs_after_2666fdb/FIX_P2_GATEWAY_D36`): the
  gateway's linear cascade, then landing equations, then the sieve
  advance; cell implications for the `(1,6)` hole reported en
  route. **CLEANUP AND HANDOFF (user goal, 2026-08-06):** the packet
  mill winds down; `HANDOFF_2026-08-06.md` written (self-contained
  state-of-the-problem for human continuation: the cutoff theorem,
  the profile theory, the cell ledger, the terminal verdict, the two
  walls, the trust guidance separating sealed packets from
  draft-grade Note IV §5 hand-proofs with the six-correction
  history, the repo map, and the ranked open problems). Deliberately
  STOPPED: the `(1,6)` `n = 6` modular sweep (at 2028/~4300 runs,
  finding-grade; partial logs remain in the H1 packet) and the
  Groebner.jl third-kernel redundancy sweep (its target already
  double-sealed). KEPT RUNNING: the `(1,6)` `n = 4` char-0 run (a
  live ledger clause, majority of leaves unit so far) and FIX-P2
  (the gateway window; integrate on return). Director probe
  artifacts preserved in `director_probes_20260806/`. Next per the
  user: the split-discriminant Prym investigation (Note V's
  option-2 think; `Δ₅ = E_σ ∪ K_c`). **TWENTIETH WAVE — FIX-P2
  LANDED (2026-08-06, director-replayed 48/48) with
  `FIX-P2-H11A-SCOPE-QUERY`, adjudicated as **CORRECTION H1-D (the
  seventh, and the first inside a sealed packet's prose)**: H1-1(a)'s
  "at ALL THREE D12-points" clause is FALSE — `θ` transports the
  datum together with the point (one statement, not three); measured
  on the real `(1,6)` slice at two primes: own-point order exactly
  `2e`, foreign points order ~1. **Corrected bound: `d ≥ 3r − 2m`.**
  Withdrawn: P1-A, P1's `d ≤ 35` sweep and window-36 exit, Note II's
  `n ≥ 30` figures, Note V §2's arithmetic, H1-C's `6e+9` (to be
  re-derived). Survives and machine-confirmed on a real slice
  (`FIX-P2-H11-LOCAL-CONFIRMED`): H1-1's own-point content, (b),
  (c), the M3/M1 equalizer kills, no-line-degree-0, E25's
  independent `≤ 24` cutoff. **Corrected state: unconditional cutoff
  `d ≤ 30` (all 107 corrected-list profiles at 25–30 slice-zero);
  31–33 near-complete, every computed row zero; first
  possibly-nonzero window `d = 34` via `(1,6)` at `n = 28`, slice
  ≤ 16.** Banked: Theorem P2-A's machinery (`L₀ ∩ L₁ = 0` in 69/69
  profiles, exact); unconditional `(1,6)` structural facts
  (anti-diagonal leading datum, own-point order exactly `2e`,
  `L₀/L₁` landings). `(1,6)` `n = 4` remains NOT-DECIDED (9
  timeouts, one run live). HANDOFF_2026-08-06.md corrected in place
  (cutoff paragraph + a sharpened trust rule: sealed packets' PROSE
  clauses are draft-grade until machine-exercised). Trust lesson
  recorded. Headline: OPEN. **Item-2 investigation opened (Note VI,
  `theory/FIX_VI_prym.md`, DRAFT-FOR-DERIVATION): the
  split-discriminant Prym.** Hand-derived with all consistency checks
  passing: for each of the 55 involutions, the admissible-cover Prym
  of `Δ₅ = E_σ ∪ K_c` gives `J(X) ~ Prym(Ẽ/E_σ) × J(K̃_σ)` — a
  (3-dim) × (2-dim) isogeny splitting, with `Ẽ → E_σ` branched at
  the six intersection points (`g = 4`) and `K̃ → K_c ≅ P¹` branched
  at the six `F₀`-points (`g = 2`; both branch parities are exactly
  the (D1) residue computations); the dual-graph norm is toric-an
  isogeny, and `p_a` arithmetic checks (`6 → 11 = 2·6−1`; Prym dim
  5 ✓). No splitting is `G`-stable (`H³ = W ⊕ W̄` irreducible
  pieces); `G` permutes the 55 — a joint rigidity on `J(X)`'s
  isogeny type. Next: pin the two curves exactly (small, frame data
  banked; does `J(K̃)` split under the D12-symmetry?),
  machine-verify the genus/branch arithmetic, then the
  twisted-torsor question over `K_proj`. NOT to be consumed until
  machine-checked (per the H1-D trust rule). **Wave 21 first
  result (director probes, `director_probes_20260806/prym_*.py`,
  Note VI §2.5): the genus-2 factor has CM by `Q(√−11)`.** In the
  explicit normal form the `K̃`-branch restriction is exact
  (`F₀|_{K_c} = (κ₊+4)a³+(κ₋+4)b³`, product `= 22 = 2·11`), the
  branch sextic is exactly even after conjugating the conic
  involution to `s ↦ −s`, so `K̃` is bielliptic with
  `J(K̃) ~ E₊ × E₋`, and `j(E₊) = j(E₋) = −32768 = −2¹⁵` EXACTLY
  (both symbolic: `prym_exact.py`, `prym_exact2.py`) — the
  discriminant-(−11) CM j-invariant, the field of the Weil
  representation itself. Modulo the bielliptic bookkeeping to be
  machine-sealed: `J(X) ~ Prym₃(Ẽ/E_σ) × E_{−11}²` per involution.
  **Wave 21 literature anchor (Note VI §2.6):** Roulleau
  arXiv:1001.4853 (J. Math. Kyoto 49 (2009); PDF archived in
  `external_docs/`) Theorem 2 computes the period lattice of `J(X)`
  as an explicit rank-5 `Z[ν]`-lattice, `ν = (−1+i√11)/2`, and
  records `J(X) ≅ E⁵` (as abelian varieties, not ppav's; first
  proved by Adler, J. Algebra 72 (1981) 146–165) for `E = C/Z[ν]` —
  exactly the `j = −32768` CM(−11) curve. So the probe re-derived
  two of the five known CM factors by the split-discriminant route
  (strong end-to-end validation), `Prym₃ ~ E_{−11}³` is FORCED by
  Poincaré reducibility (no computation needed), and the new
  content over the literature is the localization (CM factors live
  on the conic side of the SPLIT discriminant), the 55
  D12-covariant splittings, and the equivariant statement `H₁(J(X),
  Q) ≅ W` over `Q(√−11)` (`Λ` a `Z[ν][G]`-lattice; CM commutes
  with `G`). Note VI §3 rewritten: curve-pinning DONE; next = the
  machine-seal packet, then the twisted-torsor question. Probe-grade
  until the machine pass. **Wave 21 dispatch:** packet
  `goal_runs_after_576ad77/FIX_VI_PRYM_SEAL` (IN-FLIGHT,
  PROPOSAL-UNRUN): sections A–D per brief — restriction identity,
  sextic evenness, both j's exact by two independent routes,
  Hilbert-class-poly check `H₋₁₁(X) = X + 32768`, `E_σ` coherence
  (`j = 8192/11`), six intersection points, RH/admissible
  arithmetic; independent `verifier.py`; exits
  `FIX-VI-PRYM-SEAL-ALLGREEN` / `FIX-VI-PRYM-SEAL-DEVIATION`.
  **Wave 22 (director derivation, Note VII opened:
  `theory/FIX_VII_carrier.md`): the W-carrier condition.** Two
  results. (1) Auto-CM lemma: ANY weight-1 rational `G`-Hodge
  structure of type `W_Q` is automatically isogenous to
  `E_{−11}⁵` (only `G`-stable Hodge splittings of `W ⊕ W̄` are the
  isotypic ones; the character field `Q(√−11)` then acts as CM
  with signature (5,0); `h(−11) = 1`) — Adler's `J(X) ≅ E⁵` is
  pure representation theory. (2) Carrier theorem: if an
  equivariant dominant `P(W) ⇢ X` exists then, since `H³(P⁴) = 0`
  and pullback along the resolved map is injective, SOME blowup
  center of every equivariant resolution carries `W_Q` in `H¹` —
  the Weil fivefold must appear in the Albanese of the base
  locus. The sealed forced base locus (lines/planes/sweeps) is
  all `H¹ = 0`, so this is structure beyond everything the FIX
  program forced. Chevalley–Weil ledger of minimal carriers:
  irreducible `G`-curve needs genus ≥ 26 = the `(2,3,11)` Hurwitz
  class of the modular curve `X(11)` (recalled classical model
  `Sing(Hess F)` in `P(W)` itself, deg 20 — TO-VERIFY vs
  Adler–Ramanan); induced alternatives: 11 A5-curves of genus 5
  (`(3,3,5)`, `Res W = V₅`), 12 F55-curves of genus 12, 60
  C11-curves of genus 5, 55 D12-curves of genus ≥ 3; plus
  degree-0 "tower carriers" over point orbits (evade degree
  counts; the FIX-D2 jet towers probe exactly these). THE RACE
  (next derivation): per (profile, carrier), containment cost
  (~`5(δd+1−g)`, linear in `d`, slope `5δ`) vs slice budget; a
  uniform win would be the missing effective degree bound
  (Wall #1) modulo the tower-carrier branch. Note VI §3 updated
  (trdeg slip fixed: `K_proj` is C₄ not C₃; elementary obstruction
  vanishes; `3[T₁] = 0`). **Wave 22 same-hour corrections and
  probes (Note VII §§3–6 revised in place):** (i) the "race"
  framing was OVERSTATED and is superseded in §4 — Lemma 3 (new):
  free-orbit centers satisfy the representation condition with any
  genus ≥ 1 center (`Ind` from trivial stabilizer contains
  everything), so the carrier condition's negative force on big
  orbits is Hodge-local, not representation-theoretic; the honest
  negative-side statement is the per-window trichotomy
  (arrangement-supported / new positive-degree orbit /
  irregularity-forcing free singularity), branch (c) being a
  FIX-D2-class wall. Representation rigidity bites exactly on the
  small orbits. (ii) Probes (committed in
  `director_probes_20260806/`): `hess_probe.m2` — `Sing(Hess F)`
  is dim 1, degree 20, Hilbert poly `20i−25`, `p_a = 26` — the
  X(11) model confirmed by direct computation (identification
  literature-anchored: Klein, Adler–Ramanan LNM 1644,
  arXiv:2409.02589); `triples_probe.py` — generating tuples
  (2,3,11) in G, (3,3,5) in A5, (5,5,5)/(5,5,11) in F55 all
  EXIST (obligations 2, 3 of Note VII §5 closed). (iii) §6 opened:
  next derivation = the HESSIAN WINDOW (equivariant character of
  `H⁰(I_{C₂₀}(d))` via Chevalley–Weil on X(11); first `d`
  admitting a landing covariant vanishing on the Hessian
  curve). **Wave 21 packet LANDED: `FIX-VI-PRYM-SEAL-ALLGREEN`**
  (`goal_runs_after_576ad77/FIX_VI_PRYM_SEAL`; main 24/24,
  independent verifier 24/24, director-replayed exit 0; exact
  dim-4 field model, no simplify heuristics; verifier used a
  different parameterisation, involution, resultant restriction,
  Aronhold invariants, Eisenstein CM route; M2 cross-engine on
  the intersection geometry, `b³ = −(283+21√33)/256`; deviations
  none mathematical). Note VI §§2–2.5 computational claims are
  now SEALED; manifest upgraded. **Wave 22 §6 EXECUTED (probes
  `hess_fix*.m2`, `hess_window.py`, `chartab.jl/out`): the
  equivariant coordinate ring of X(11) ⊂ P(W) fully computed.**
  Fixed data machine-extracted mod 397, CW+Lefschetz-consistent:
  order-11 = the 5 coordinate points (smooth on C, tangents
  ζ^{QNR}), order-2 = 6 points all in P(V₊) (`χ_d(σ) ≡ 3`),
  order-3 = 2+2 on the two fixed lines (tangents ω,ω,ω²,ω²;
  `χ_d(ρ)` cycles (2,−2,0)), orders 5/6 empty. Atiyah–Bott then
  yields all `mult_V(H⁰(O(d)|_{X(11)}))`, `d = 3..64`: every
  mult a non-negative integer, dims sum to `20d−25`, character
  table OSCAR-verified (incl. power map `11a² ∈ 11b`), `H¹(C) =
  W ⊕ W̄ ⊕ 10^{⊕2} ⊕ 11^{⊕2}` reproduces all Lefschetz numbers.
  READOUTS: (1) Hessian containment is representation-cheap
  (on-curve mult 3–10 through d=64): at the d=34 gateway it
  costs ≤ 6 of the ≤ 16 slice dims — THE CARRIER CONDITION DOES
  NOT OBSTRUCT THE GATEWAY; supply of Hessian-vanishing W-valued
  covariants exists from d=6 (d=34: ≥ 570). (2) Ideal-parts are
  lower bounds only (at d=4 the gradient `∇Hess` vanishes on C
  while the bound reads 0 — restriction not surjective). Note
  VII §5 obligations 1–3 all closed (OSCAR table, triples,
  Hessian degree/genus). **Correction VII-a (same day, caught
  in-turn by a Hilbert-function contradiction, `conx.m2`):
  readout (2) as just stated was WRONG — the same
  support/argument-slot class as IV-a…f, H1-D. `span(∂H) ⊂ S⁴W*`
  is the unique W-copy (hand-verified Molien `mult_W(S⁴) = 1`),
  so `∇H` is a POLAR-type covariant `P(W) → P(W̄)` in the OTHER
  ladder (where exactness `1 − 0 = 1` holds on the nose);
  restriction at d = 3,4,5,6 is in fact SURJECTIVE (HF
  {35,55,75,95} = h⁰(L^d)), and the W̄-type d=4 ideal-part really
  is 0. Both type-ladders now machine-tabulated
  (`dual_dims.py`): they differ in low degree, converge by d≈25,
  both ≥ 570 at the gateway; compositions through the dual
  (∇F at d=2, ∇H at d=4 are the polar generators) enlarge the
  constructive calculus. Also machine-read: F ∉ I_C (the Hessian
  curve is NOT on X); invariant ladder mult_triv(S^d) starts
  3 (F), 5 (H), 6, 7 (new fundamentals beyond products at 5, 6,
  7); on-curve invariants grow at rate 1/33 (first 2-dim at
  d=33 — X(11)/G = P¹ consistency). **Note VI §3 torsor angle
  CLOSED as PARKED OPEN-EXTERNAL** (second pass): BW obstructs
  rationality, not points; a K-point yields only degree ≡ 0 mod 3
  canonical curve classes (3, 6, 6); no points-obstruction
  theorem exists to instantiate (the open CSD-type index-1
  question); the CM-explicit `J_tw` stands ready if one appears.
  Investigation's unconditional yield = Note VII. **Wave 23
  dispatch:** packet `goal_runs_after_ad6746b/FIX_VII_XRING`
  (IN-FLIGHT, PROPOSAL-UNRUN): explicit `G` as 660 matrices mod
  397/1321 (Weil S-matrix construction protocol), covariant
  spaces BOTH types `d ≤ 12` via generator-equivariance
  null-spaces (dims must reproduce the banked AB/Molien tables),
  TRUE ideal-type multiplicities (restriction ranks mod `I_C`),
  canonical generators (`∇F`, `∇H`, the d=6 map-type pair, the
  `∇F̌∘∇F` dual-polar composition, identities in the 2-dim
  polar-5 space `{F·∇F, ∇J₆, HessF·∇H, HessH·∇F}`), invariant
  ladder extraction (H, F², J₆, J₇), control prime. Exits
  `FIX-VII-XRING-ALLGREEN` / `FIX-VII-XRING-DEVIATION`. This is
  the foundation layer for the gateway assembly (d=34,
  `(1,6)`-profile + Hessian base). **Wave 23 assembly calculus
  (Note VII §7; probes `sixpts.m2`, `hess_sextet.m2`):** (i) all
  55 lines lie on the Hessian quintic with `ord_L(H) = 1` (hand
  block-proof: rank ≤ 4 anti-diagonal structure; machine
  confirmed); `ord_L(F) = 1`; both polars `∇F`, `∇H` collapse the
  `V₋`-directions along lines (each maps every line into the dual
  plus-plane; `∇F(L)` an explicit conic). (ii) **The Hessian
  sextet:** `C₂₀ ∩ Π_σ = C₂₀^σ` = six points ON the conic `K_c`
  and OFF `E_σ` — the carrier meets the arrangement exactly
  through the 55 CM-carrying conics (330 = 55·6 order-2 points),
  disjoint from all lines and all `E_σ`; each conic now carries
  TWO canonical D12-stable sextets (discriminant `E∩K_c` vs
  Hessian `C∩Π`). (iii) CONTRAST: the Hessian sextet is τ-stable
  and exactly even in the bielliptic coordinate
  (machine-verified), but its genus-2 cover splits into two
  DIFFERENT non-CM quotients (mod 397: j = −85, −150 vs CM ≡ 183,
  arrangement ≡ 59) — the CM(−11) rigidity belongs to the
  DISCRIMINANT sextet specifically, sharpening the Note VI
  finding. (iv) Gateway bookkeeping: profile and carrier
  condition systems interact ONLY at the 330 sextet points — the
  d=34 assembly decomposes as profile + carrier + a finite
  gluing block on the sextets; computing the gluing block's rank
  at the `(1,6)` window is the step after XRING lands. **Wave 23
  packet LANDED: `FIX-VII-XRING-ALLGREEN`**
  (`goal_runs_after_ad6746b/FIX_VII_XRING`; 71/71 at p=397 AND
  p2=1321; director-replayed verifier exit 0 — multiplication
  table closure, Molien-projector dims, pointwise equivariance of
  the d6 pair over all 660 elements, unsaturated-ideal
  membership). Protocol correction (worker-caught, brief error):
  the working Weil-S labeling is the square-root one
  `b = (1,3,2,5,4)`, signs `(1,1,−1,1,1)` — the brief's labeling
  family has NO solution (exhaustive search); exactly the 5
  u-orbit labelings work. Results: linear AND projective closure
  both exactly 660; ladder dims d ≤ 12 both types = banked
  EXACTLY; TRUE ideal mults = the left-exactness bounds AT EVERY
  d (restriction surjective on equivariant parts throughout —
  stronger than the HF argument); `F̌` same pentagonal shape; NEW
  explicit invariant `J₆` (±1 coefficients); identities
  `HessF·(∇F̌∘∇F) = 10·F·∇F + 2·∇J₆`,
  `adj(HessF)·∇F = ½·H·x`; the map-type d=6 ideal pair is
  `⟨H·x, F̌″(∇F,∇H)⟩`, both structurally vanishing on `C₂₀`;
  identity coefficients identical over Q at both primes; manifest
  upgraded. **Wave 24 dispatch:** packet
  `goal_runs_after_ac61998/FIX_VII_GATE` (IN-FLIGHT,
  PROPOSAL-UNRUN): the d=34 gateway decision — span `M₃₄`
  self-certified to rank 576 (invariant×generator products, XRING
  recipes at the P2 primes 67/199), impose the (1,6) profile at
  one orbit representative (plane containment + line multi-orders
  translated from the P2 sieve; NO c_σ conditions per
  `FIX-P2-H11-LOCAL-CONFIRMED`), MANDATORY cross-check `n1` =
  sealed P2 slice dim, then the carrier cut (NF mod `I_C` at
  degree 34, target dim 655). Exits:
  `FIX-VII-GATE-CANDIDATES-EXIST` (explicit basis dumped) /
  `FIX-VII-GATE-HESSIAN-ANSATZ-EMPTY` /
  `FIX-VII-GATE-DEVIATION`. **Wave 24 Italian-moves probes
  (user-prompted strategy discussion; `italian_probe.m2`,
  `seed25.py`, probe-grade mod 397):** (i) the Steinerian
  involution of the Hessian quintic is now EXPLICIT and verified
  (`st` = cofactor row of the Hessian matrix: `Hess·st ≡ 0` and
  `H(st) ≡ 0 mod (H)`; the classical symmetric-trilinear argument
  `F‴(x,y,·)` makes it an involution, G-equivariant for free) — a
  genuine canonical self-map added to the toolkit; `st` does NOT
  carry `V(H)` into `X`. (ii) Short polar words do NOT preserve
  `X` or `V(H)`: `F(∇F̌∘∇F) ≢ 0 mod (F)` etc. — consistent with
  the sealed ≤ 24 landing emptiness. (iii) SCOPE FACT surfaced by
  the discussion: a landing SEED need not be dominant (the sealed
  Kollár circle upgrades ANY nonzero landing covariant to the
  headline via chord amplification), and degrees 25–33 are NOT
  closed for landing covariants (E25: ≤ 24 closed char-0, 25
  PARTIAL — the F_67-branch char-0 transfer is a named open task;
  the ≤ 30 sweeps assume dominance). (iv) The ONLY
  pure-composition family at degree 25 is (dual-polar-5)∘(polar-5)
  — the explicit `⟨F·∇F, ∇J₆⟩` mirror pair — a P¹×P¹ family:
  swept COMPLETELY mod 397 against 4 independent probe points:
  NO landing seed (caveats: one prime; `J̌₆` same-shape-in-dual
  assumed by the F̌-uniqueness argument, unverified). Planned
  after GATE lands: FIX-VII-SEED — the mechanical catalog sweep of
  all structured candidates at 25–33 (compositions with degree
  products in range, `F̌″(P,Q)`-contractions with
  `deg P + deg Q` in range, Hessian-ideal-structured elements)
  plus the E25 char-0 completion. **Wave 24 same-day amendment
  (08-06, relocated here to restore chronology): FIX-C1's
  detached part-D level-3 run landed — `Ob₃ = 0` on all 25
  coefficients, rank profile identical to parts B, C;
  `FIX-C1-LADDER-M1-EXTENDS-THROUGH-3` is now EXACT on all 24
  non-rational witnesses (C1 §7 item 1 closed); the H1 leftover
  M2 chain's late `hard_r8_om2_*` inputs are moot (H2 decided
  those leaves) and are committed for completeness of the packet
  dir.** **Wave 25 (user redirect: hunt a
  concatenation of CLASSICAL GEOMETRIC MOVES, IJ geometry as the
  hint; Note VIII opened, `theory/FIX_VIII_italian.md`; probes
  `cycle55.py` on GATE's explicit group): THE PROJECTION MOVE.**
  (i) `π_σ = (I−σ)/2` maps `P(W)` onto `L_σ ⊂ X`,
  D12-equivariantly — machine 55/55. Hence: an `L`-point of
  `X_tw` for the degree-55 field `L = C(P(W))^{D12}`; combined
  with the degree-3 closed points from line sections,
  `gcd(55,3) = 1` so **`X_tw` has INDEX 1 over `K_proj`** (new);
  by Kollár **`X_tw` is L-UNIRATIONAL**; the headline is now a
  STRUCTURED prime-to-3 descent (55 ≡ 1 mod 3) of the open
  Coray/CSD type, with obstructions priced in the Note-VI CM
  fivefold. (ii) Triangle calculus: the 55 V4-line-triples are
  PLANE SECTIONS of X (`F|_{a=b=0} = xyz`); vertex orbit 165 =
  the χ-vertices, stabilizer V4; the chord-triple of the three
  projections is COLLINEAR (Menelaus, machine 6/6) — a canonical
  55-line-valued map `ℓ_{V4}(v)` (axes have full Plücker rank 10
  at random v). (iii) The in-plane 3-adic wall: chord dynamics
  `T: rᵢ ↦ −rⱼ/rₖ` has `T³ = cubing` — no in-plane word reduces
  the triple to a point (reachable degrees `3k+3m ≠ 1`); the
  descent must be CROSS-V4, where 55 ≡ 1 mod 3 gives room. Move
  catalog for the campaign in Note VIII §3 (cross-V4 chord orbits
  110/330, axis incidence at special v, unique-RNC-through-7
  configurations, conic-bundle overlay, tangent-construction over
  G-stable Fano families). GATE's landing-cone computation
  (FIX-VII-LAND) queued as the linear-system face of the same
  hunt. **Wave 25 dispatches:** (i) the landing-cone dimension
  run (60 point-sampled cubics in 13 vars mod 67 from the GATE
  candidate basis; M2 GB, background) — decisive for the
  d=34 Hessian-ansatz: dim 0 ⇒ no landing candidate, dim > 0 ⇒
  extract points and verify full landing; (ii) packet
  `goal_runs_after_aa68551/FIX_VIII_MOVES` (IN-FLIGHT,
  PROPOSAL-UNRUN): the Note VIII §3 cross-V4 experiment sweep —
  noncommuting chord-cycle orbits (degrees/collapses/incidences),
  Menelaus axes at special source loci, second-layer canonical
  pairings, reachable degrees mod 3; exits COLLAPSE-FOUND /
  NO-COLLAPSE / DEVIATION. **Wave 25 packet LANDED (director-run):
  `FIX-VII-LAND-EMPTY`** (`goal_runs_after_10804b2/FIX_VII_LAND`):
  the landing cone on GATE's 13-dim (1,6)+Hessian space at d=34
  is EMPTY — msolve solve-mode returns only the origin at BOTH
  primes 67/199, and the reduced GB at 67 is exactly
  `{c0,…,c12}` (the sampled ideal IS the irrelevant ideal —
  certificate-grade); independent verifier (different seed, 80
  points, fresh runs, landmine-safe parsing) 3/3 PASS. Note VII
  §8 records the verdict: no degree-34 equivariant dominant map
  has a resolution center dominating the Hessian curve (mod-p,
  two primes; char-0 evidence-grade since the 13-space is
  mod-p); the canonical-carrier ansatz at the gateway is
  CLOSED-NEGATIVE; d=34 survives only via moduli-carrier
  families or tower carriers; next linear-system target = the
  d=43/(1,7) analogue. The Italian face (Note VIII, MOVES
  in-flight) is untouched. **Wave 25 packet LANDED:
  `FIX-VIII-MOVES-NO-COLLAPSE`** (60/60; director-replayed census
  exact). Correction VIII-a (worker-caught): no 110-pair-orbit;
  all six pair-orbits ≡ 0 mod 3 — no first-layer chord cycle
  moves the residue. Census: G on the 55 involutions is
  PRIMITIVE; reachable canonical degrees {11,55,66,110,165,330},
  only 55 ≡ 1 mod 3; transitive G-sets ≡ 1 mod 3 = {1, 55, 220};
  the unique sub-55 composite is 22 = 11+11 needing canonical
  A5-points (constant versions dead: `W^{A5} = 0`; the 55
  D12-fixed points miss X). Axes: no rank drop at any special
  source; the Hessian curve is the unique degeneration-free
  source locus. Naive move layer CLOSED BY MEASUREMENT; Note VIII
  §5 records the two doors: A5-equivariant constructions (ANY
  A5-map to X = a point over the degree-11 field ⟹
  L₁₁-unirationality, descent gap 55 → 11; G-ladder emptiness
  says nothing about A5-covariants, supply from d=2) and
  C-sourced constructions. **Wave 26 dispatch:** packet
  `goal_runs_after_88f0967/FIX_VIII_A5LADDER` (IN-FLIGHT,
  PROPOSAL-UNRUN): the A5 landing ladder — A5-covariant map-type
  spaces d = 1..12 (null-spaces from an extracted A5 ⊂ G660,
  dims vs A5-Molien), landing cone per degree by the LAND method
  (sampled cubics + msolve, landmine rules), first-hit
  extraction with full-identity verification at both primes and
  image-dimension measurement. Exits A5LADDER-HIT-d<k> /
  A5LADDER-EMPTY-THROUGH-<cap> / DEVIATION. **Wave 26 audit
  (user-prompted): the STOP-RULE, and stopping the (1,6)-uniform
  sweep.** Adopted discipline, recorded as binding: every CAS run
  must be attached to a NAMED FINITE QUESTION whose both outcomes
  redirect the program; no unbounded degree/parameter sweeps. By
  this rule the inherited (1,6) n=4/5 modular sweep (H2 packet,
  Task-B: an unbounded family n = 4,5,6,… with no convergence
  theorem, running since before the pivot; 4.4 CPU-days on the
  Singular long-runner alone) NO LONGER EARNS ITS COMPUTE: the
  descent program does not route through it, and the d=34
  canonical gateway is closed by FIX-VII-LAND regardless of its
  outcome. STOPPED 2026-08-06 (driver + msolve leaf + Singular;
  317 completed leaf outputs preserved on disk in the packet;
  status remains NOT-DECIDED at n=4/5, finding-grade, honestly
  recorded as stopped-not-finished). The A5LADDER run is bounded
  (d ≤ 12, each degree a decidable cone) and gated: it will NOT
  be extended past 12 without a structural justification (the
  finite RY-style fixed-point-matching analysis for A5-maps —
  which could kill the whole A5-route with a theorem — is the
  named gate). The linear-system face (d=43 etc.) is DEQUEUED:
  it runs only if the descent face stalls AND a structural
  argument distinguishes the window beyond "next number". **Wave
  26 (user question: descent literature + does the extension
  point give H-unirationality; Note VIII §6 written):** (i)
  LEMMA 4 (specialization): for EVERY `H ≤ G`, an `L_H`-point of
  `X_tw` ⟺ a DOMINANT H-equivariant map `P(W) ⇢ X` — the strong
  form; proof = Kollár + graph-composition with a generic
  H-invariant `τ: P(W) ⇢ P³` (étale-jet realizability at an
  unramified point; fiberwise-dominance gives surjective
  differential). COROLLARY: the Klein cubic is D12-EQUIVARIANTLY
  UNIRATIONAL (first unconditional equivariant-unirationality
  theorem of the program; holds for every `H ≤ D12`). (ii)
  Literature verified and archived: Duncan–Reichstein 1109.6093
  (headline = weak versality; abelian necessary conditions all
  PASS — X^A ≠ ∅ checked for all 7 abelian classes; sufficiency
  = the missing cubic Springer theorem); CSD conjecture open all
  dims; Coray surfaces {1,4,10}; C-T–Madore cd-1 cubic-surface
  counterexamples (index-1 ⇏ point for surfaces — live threat
  since cd(K_proj) = 4); Qixiao Ma 1908.03139 (PDF archived):
  cubic 3-folds degree 7 → {1,2,4,5} via unique-RNC; 2 → 1 by
  chord; Sym⁷ ~st Sym⁵; NOTHING known from 55. (iii) NEW NAMED
  FINITE QUESTION: a degree-7 closed point on `X_tw` (= a
  G-stable IRREDUCIBLE 7-multisection of X over P(W)) would
  finish the descent to {1,4,5}; the MOVES census does NOT
  apply (irreducible multisections are not G-sets) — candidate
  sources: odd multisections of the 55 conic bundles (vs the
  (D1) Brauer class), incidence correspondences, the carrier
  geometry. Next derivation target. **Wave 26 literature event
  (decision-grade; Note VIII §7; PDF archived): CTZ
  arXiv:2502.19598** (Cheltsov–Tschinkel–Zhang, Feb 2025,
  "Equivariant unirationality of Fano threefolds") — Theorem 5.1
  proves G-unirationality for smooth cubic threefolds under
  Condition (A) EXCEPT: Fermat/C₉⋊C₃, **Klein/PSL₂(F₁₁),
  Klein/C₁₁⋊C₅** ("remains open", p.18), and **irreducible-A₅ on
  the Klein–Segre pencil** ("remains open", p.20). So: (i)
  Correction to wave-26 novelty claim: D12-unirationality was
  KNOWN (CTZ Thm 5.1 instance via index-2 fixed points; our
  projection proof is independent + explicit, not new); (ii) THE
  HEADLINE IS A NAMED OPEN CASE of the Feb-2025 literature, as
  are F55 and irreducible-A5-on-Klein — the running A5LADDER
  attacks a named open case; (iii) CTZ Remark 5.4: under
  Duncan–Reichstein Conjecture 10.4 (+ their Thm 10.5),
  G-unirationality reduces to the 3-Sylow, and for the Klein
  cubic `C₃` fixes points ⟹ **the headline is CONDITIONALLY YES
  under the D-R conjecture**. The problem is pinched between the
  D-R p-group detection conjecture (positive) and the CSD
  descent gap (negative). Immediate read: D-R §10 exact
  statements. **Wave 27 (D-R §10 read in full; Note VIII §8;
  PDF archived):** D-R Conjecture 10.4 IS Cassels–Swinnerton-
  Dyer; Theorem 10.5 (2011, unconditional): for smooth invariant
  cubic hypersurfaces very versal ⟺ versal ⟺ weakly versal (our
  Lemma 4 = an instance; novelty re-corrected), and under CSD
  further ⟺ 3-Sylow versality. **Proposition 10.8: the headline
  separates named conjectures** — Duncan's Sylow conjecture ⟹
  ed(PSL₂(F₁₁)) = 3 (YES); CSD ⟹ 3 (YES, via Beauville's Sylow
  fixed points arXiv:1101.1372 + Cor 10.6); Dolgachev's
  ed ≥ Crdim ⟹ 4 (NO, via Prokhorov Crdim ≥ 4). D-R: "10.4 and
  10.7 are incompatible; they cannot both be true; same for 8.8
  and 10.7" — EITHER resolution of the headline refutes a named
  conjecture, and settles the last case of Beauville's
  classification of finite simple groups of essential dimension
  3 (Remark 10.9). **Remark 10.10 opens the V₁₄ TWIN AVENUE:**
  exactly two equivariant birational classes of RC
  PSL₂(F₁₁)-threefolds (Prokhorov) — Klein cubic and the genus-8
  Fano V₁₄ — so ed = 3 ⟺ Klein-G-unirational OR
  V₁₄-G-unirational; the V₁₄ face (twists, index over K_proj,
  hyperplane degree 14 ≡ 2 mod 3 cycle arithmetic) is unexamined
  and named as the next derivation. Program placement final:
  positive face = CSD-instances on the two twins; negative face
  = Dolgachev's instance ed = 4. A5LADDER interim (in-flight):
  [Status 2026-08-10: STALE. The A5LADDER worker was killed
  mid-msolve inside the first d = 11 branch; the packet is CLOSED
  as FIX-VIII-A5LADDER-EMPTY-THROUGH-10 with d = 11, 12 undecided.
  See wave 33 below.]
  cones EMPTY through d = 7; surviving branches from d = 8
  (dims 1, 12, 19, 45, 60 at d = 8..12); worker mid-verification
  of a candidate ("cplus") — report pending. **Wave 27
  (user-directed V₁₄ + user-demanded openness confirmation; Note
  IX opened, `theory/FIX_IX_v14.md`; three PDFs archived):**
  OPENNESS VERDICT: headline OPEN (CTZ Feb-2025 exception; no
  later resolution); A5-on-pencil OPEN; F55 OPEN; V₁₄-twin
  G-unirationality OPEN and NOT covered by CTZ (index-1 outside
  their scope). LANDSCAPE CHANGE: **Scavia arXiv:2607.25118
  (July 2026) REFUTES Duncan's Sylow-detection conjecture**
  ((C₇⋊C₃)×C₂ on a dP2; explicitly flags the Klein-cubic
  connection) — the D-R trichotomy is now the DICHOTOMY CSD ⟹
  YES vs Dolgachev ⟹ NO. **Tschinkel–Zhang arXiv:2409.08392
  Thm 1.1: Y × P² × P(V) ~_G X × P² × P(V)** (V = the 6-dim
  SL₂(F₁₁)-irrep; both actions birationally rigid so plainly
  nonbirational) — with the caveat, derived here and ALREADY
  RECORDED in substance at [E07](#e07)'s bridge audit as the
  "stable-factor trap" (novelty accordingly scoped): the
  P(V)-factor's Schur-class twist is Brauer-nontrivial over
  K_proj (nonsplit C₂-extension ⟹ the twisted Severi–Brauer P⁵
  has no point), so plain (U) does NOT transfer across the
  equivalence; the twins' questions are linked modulo an order-2
  Brauer class = a new invariant handle. MODEL START (probe `v14_model.py`): the
  6-dim even-Weil rep of SL₂(F₁₁) built mod 397 (S² = 11·I,
  closure exactly 660 ✓); `1⊕W` provably WRONG (its section
  degenerates to Gr(2,W) — hand proof); packet FIX-IX-V14MODEL
  planned (Λ²U decomposition, Gr∩P(M) verification deg-14/smooth,
  fixed-locus arrangement, M-valued ladder with QUADRATIC landing
  conditions, small-orbit/index census with 14 ≡ 2 mod 3). **Wave 27 V₁₄
  triage (Note IX §4; probes v14_lambda2/a5fix/d12fix2): the
  dP/Fermat toolbox CANNOT close V₁₄ — proofs.** Full G: the
  three deaths (irreducible M, simple G, no invariant
  hyperplane). Subgroup fixed-point tools: `Λ²U = 5 ⊕ 10′`
  (corrected Weil normalization `S² = −I`, SL-closure 1320;
  10′-projector rank 10 ✓); `M^{A5}` is the SYMPLECTIC form of
  quaternionic `U|_{2.A5}` — rank 6, off the Grassmannian ⟹
  `V₁₄^{A5} = ∅` (twins agree); `M^{D12}`-pencil rank
  distribution `{6: 395, 4: 3}` — min rank 4 ⟹ `V₁₄^{D12} = ∅`.
  Induction tool: dies STRUCTURALLY on index-1 Fanos (hyperplane
  sections are K3s, never unirational — why CTZ stop at index
  ≥ 2). **Wave 28 dispatch:** packet
  `goal_runs_after_d0ab8d0/FIX_IX_V14MODEL` (IN-FLIGHT,
  PROPOSAL-UNRUN): exact model (quadrics in 10 vars, deg 14,
  smooth, G-invariant, two primes), σ/V4/cyclic arrangement +
  Condition-(A) census, curve-orbit census (55-conic
  Iliev–Markushevich transfer, lines Fano scheme, index
  arithmetic), 10′-ladder with QUADRATIC landing cones (a
  verified stage-4 hit = a K_proj-point of the twisted V₁₄ =
  the HEADLINE POSITIVE — triple-verify protocol in
  brief). **Correction IX-a (user-caught): the wave-27 triage
  prose called the section-induction tool "the Fermat-closer" —
  WRONG: the Fermat cubic is NOT closed. CTZ's Clebsch-section
  induction closed C₃×S₅, C₃×A₅, C₃×F₅ on the Fermat; C₉⋊C₃ on
  the Fermat remains open in the same exception list as the
  Klein cases — and being a 3-group it is exactly the open case
  that CSD does NOT resolve via the D-R 3-Sylow reduction. Note
  IX §4 corrected in place; the V₁₄ conclusions (three deaths,
  A5/D12 emptiness, K3-section structural death) are
  unaffected.**
  **Wave 28 (user keystone; Note IX §§5–6): the CENTRALIZER OBSTRUCTION —
  the V₁₄ linear-source case closes on the measured data.** User-proposed
  argument, derived as **Cor IX.1** (= Cor T3.1 with `C_G(σ)` replacing
  the center): for `σ` an involution with `ρ(σ) ≠ ±id` (automatic for
  faithful linear reps of centerless `G`), if (a) no positive-dim
  component of `Y^σ` contains a rational curve and (b)
  `Y^{C_G(σ)} = ∅`, then NO `G`-equivariant rational map `P(V) ⇢ Y` or
  `V ⇢ Y` exists for ANY faithful LINEAR rep `V` (dominant or not) — proof by RCC-stratum induction up any
  equivariant resolution tower ([I] Thm 2.1/Lem 4.2/4.3): the σ-eigenspace
  stratum `P(V₊)` is `C_G(σ)`-stable BECAUSE the rep is linear, survives
  strict transform/exceptional-eigenbundle replacement, and its resolved
  image is a single `C_G(σ)`-fixed point in `Y^σ` — empty by (b). On the
  V₁₄ the in-flight worker's stage-2 data supplies both hypotheses at
  p=397: `V₁₄^σ` = irreducible degree-6 genus-1 curve ⊔ 2 reduced points
  (NO rational curve — the exact escape hatch that killed the E14
  transfer on the Klein, `L_σ ⊂ X^σ`, is ABSENT on the twin) and
  `V₁₄^{D12} = ∅` (all three character pieces; invariant pencil rank
  never 2). PENDING SEALS (assigned in Note IX §5): smoothness of the
  sextic (M2 `g1` is arithmetic genus — a nodal-rational curve would
  void (a)), exactness at both primes/char-0, stage-1 smooth/deg-14, and
  the `C_G(σ) = D12` CHECK (already sealed group-side by FIX-A0).
  **Cor IX.2 (disjunction collapse):** granting the seals,
  `ed_C(PSL₂(F₁₁)) = 3 ⟺ the Klein cubic is G-unirational` (Prokhorov
  two-class + versality birational invariance + D-R Thm 10.5); the
  headline is SINGLE-TARGET — Dolgachev's instance is exactly "Klein
  negative", CSD's exactly "Klein positive"; the V₁₄ cannot
  independently supply `ed = 3`. NOT closed — **the spin flank (Note IX
  §6)**: sources `P(V)` with `V` a faithful `SL₂(F₁₁)`-rep (`−1 ↦ −id`;
  e.g. the T-Z stable factor `P(U)`): `σ̃` has order 4, the
  D12-reflections invert it and SWAP the two eigenplanes `P(V_{±i})`
  (each only `C6`-stable), so the argument forces only a D12-stable
  PAIR of `C6`-fixed points — and `V₁₄^σ`'s two isolated points ARE
  such a pair (stab exactly `C6`, 110-orbit, D12-swapped): escape shape
  and measured geometry MATCH. Spin sources need the V4/Q8-chain
  analysis (`U|_{Q8}` expected quaternionic ⟹ `P(U)^{V4} = ∅` —
  combinatorics differs from Problem F); immaterial for weak
  versality/IX.2, central for the T-Z Brauer face. Ledger discipline:
  IX.1/IX.2 are DRAFT-FOR-DERIVATION until the seals land; no packet
  claims an exit yet. **Wave 28 addendum (user consistency challenge —
  "aren't the twins stably birational?" — answered; Note IX §7):** no
  contradiction with T-Z Thm 1.1, and the check yields the TRANSPORT
  LATTICE. (i) Twisting the equivalence by the generic torsor makes the
  `P(V)`-factor a POINTLESS Severi–Brauer fivefold (`β_T ≠ 0`, §2), so
  both twisted products are pointless regardless of the twins —
  Lang–Nishimura transfers nothing; on the liftable locus `β_T = 0`
  twist-points DO cross both ways (recorded). (ii) Folding lemma IX.3:
  absorbing the `P(V)`-factor into a single source flips linear↔spin
  central character; hence Prop IX.4: Klein-lin ⟹ V₁₄-SPIN, V₁₄-lin ⟹
  Klein-spin, spin ⟺ spin across the twins, lin ⟹ spin on each. IX.1
  ("V₁₄-lin FALSE") sits exactly at the boundary the equivalence
  enforces — a same-method spin-kill would transport to a CSD
  refutation, which fixed-locus data alone should not deliver. **Cor
  IX.5: headline YES ⟹ V₁₄ spin-unirational; so killing the V₁₄ spin
  flank ⟹ headline NEGATIVE, `ed = 4` (new sufficient negative target,
  on the twin whose σ-geometry is machine-friendly).** **Cor IX.6
  (D12-shadow): the V₁₄ IS D12-spin-unirational (transport of the
  Klein's D12-theorem) yet NOT D12-lin-unirational (T3.1 with G = D12,
  σ central, for `ρ(σ)` non-scalar; the `ρ(σ) = −id` reps die
  separately — σ acts trivially on the source, image inside `V₁₄^σ`,
  never dominant) — the twins DIVERGE at D12 and the
  C6-pair spin escape is REALIZED, not hypothetical.**
  **Pre-registered prediction (worker blind, in flight): IX.1 ⟹
  FIX-IX-V14MODEL stage 4 (W-side `10′`-ladder = LINEAR source P(W))
  finds EMPTY landing cones at ALL degrees; any verified hit falsifies
  the loci data or the derivation — a live blind test.**
  **Wave 28 landing (director-run, user directive "seal that problem"):
  packet `goal_runs_after_c53d89a/FIX_IX_SEAL` — exit
  `FIX-IX-SEAL-PASS`.** Both Cor IX.1 hypotheses sealed INDEPENDENTLY of
  the in-flight worker, two engines (exact python linear algebra + M2),
  primes 397/199, verifier end-to-end at fresh prime 353, and EXACT CHAR
  0 over `Q(ζ₁₁)` (the model's field; mod-397 shadow for projective
  orders): (a) `V₁₄^σ` = a SMOOTH irreducible genus-1 SEXTIC (dim 1,
  deg 6, HP `6i`, radical, prime, Jacobian-minors saturate to
  irrelevant — the nodal-rational-sextic trap excluded) ⊔ 2 reduced
  points (stabilizer EXACTLY C6, D12-swapped, measured at 397); (b)
  `V₁₄^{D12} = ∅` in ALL FOUR character pieces (dims 2,1,1,0) at
  397/199/353/K. Ambient: the dual Pfaffian-adjoint system `J = (Pf₆) +
  (adjoint bivector ∈ M)` on `P(Ann M)` is EMPTY at 397/199/353/K ⟹
  `V₁₄` SMOOTH, PURE DIM 3 in char 0 (tangency argument; rank-≤2 case
  subsumed), degree 14 by transversality + ESZ connectedness; direct GB
  cross-check dim 3/deg 14 at three primes. `C_G(σ)` = order 12 with 7
  projective involutions = D12 (matches FIX-A0); `Λ²U = 5 ⊕ 10′` by
  χ-averaging AND the verifier's independent trace-sum identification;
  `Pf₆` on `Ann(M)` is a nonzero G-invariant cubic ⟹ the KLEIN CUBIC by
  E38 uniqueness (Pfaffian-partner identification machine-verified).
  Char-0 curve smoothness also follows a priori from ambient char-0
  smoothness (fixed loci of finite-order automorphisms); char-0
  connectedness/reducedness by flatness (equal HP) + semicontinuity
  from the smooth connected mod-p fibers. **CONSEQUENCE (Cor IX.1 now
  sealed): the V₁₄ PSL₂(F₁₁)-action is NOT G-unirational — no
  equivariant rational map from any faithful linear source, dominant or
  not; not weakly versal; generic twist pointless. Cor IX.2 stands on
  sealed feet: `ed_C(PSL₂(F₁₁)) = 3 ⟺ the Klein cubic is
  G-unirational` (+ Prokhorov two-class, D-R Thm 10.5). The headline is
  SINGLE-TARGET.** Remaining cited-not-computed layer: the [I]-lemmas
  (Thm 2.1, Lem 4.2/4.3, equivariant resolution) — Note I,
  gate-audited. **Wave 28 (user question "which H ≤ G transfer under
  T-Z?": Note IX §8): the ODD-ORDER CRITERION.** Lemma IX.7: `2.G → G`
  splits over `H` ⟺ `|H|` odd (unique involution `−I` in SL₂(F₁₁);
  Schur–Zassenhaus), and for odd `H` the linear/spin distinction
  COLLAPSES ⟹ `Y` H-unirational ⟺ `X` H-unirational, both directions,
  negatives included; for even `H` nothing transfers (D12 = the
  realized divergence witness). Odd subgroups: `1, C₃, C₅, C₁₁, F55`.
  NEW: (i) **F55 — Klein-F55 ⟺ V₁₄-F55, and NOT-F55 on either twin ⟹
  headline NEGATIVE, ed = 4** (F55 restricts any G-map; a named CTZ
  open case acquires a second geometric model; involution machine
  inapplicable — odd-element analogue named as next derivation; first
  cut: faithful F55-reps with `V^{C₁₁} ≠ 0` die on `V₁₄^{F55} = ∅`,
  which follows from the worker-grade stab-exactly-C₁₁ datum on the 5
  C₁₁-points); (ii) **the V₁₄ IS C₃-unirational** (Klein
  D12-unirational ⟹ C₃-unirational ⟹ transfer — the V₁₄'s first
  unconditional positive equivariant statement); (iii) C₅/C₁₁ open,
  equivalent across twins, cheap Klein-side targets. V₁₄ scoreboard: G
  NO (sealed); D12 lin NO / spin YES; C₃ YES; C₅/C₁₁/F55 open ⟺ Klein;
  spin-G open = the transported headline. **Wave 28 (user: "what does
  the machine say about F55?"; Note IX §8.1): the machine's F55 pass.**
  (i) TOTAL SCOPE: `M(F55) = 1` + odd order ⟹ every F55-source is
  linear ⟹ no spin-type escape — a machine close of F55 closes it
  outright on both twins and settles the headline NEGATIVE. (ii) First
  cut: sources with `V^{C₁₁} ≠ 0` die on `V₁₄^{F55} = ∅`; survivors =
  pure induced `a·ρ₅ ⊕ b·ρ₅′`. (iii) BIJECTIVITY RIGIDITY (derived):
  the five C₁₁-eigenstrata map bijectively + C₅-equivariantly onto the
  five points of `V₁₄^{C₁₁}` (a shared image manufactures an F55-fixed
  point — none exists); incidence alone CANNOT kill F55. (iv) Weight
  tables (probe `v14_f55_weights.py`, mod 397): V₁₄ — exactly one
  C₅-orbit of the ten `C₁₁`-eigenpoints of `P(M)` lies on V₁₄; tangent
  pattern `{4a, 8a, 9a}`, normal `{a,2a,3a,5a,6a,7a}`, C₅-scaling
  `a ↦ 5a`; Klein — coordinate points, tangent `{2a,3a,4a}`, normal
  `{8a}`, scaling `a ↦ −2a`. VERDICT: neither killed nor cleared — F55
  reduces at full source scope to the odd-Frobenius chain/weight lemma
  (T2.2 is dihedral-only; new derivation named) or to the E18 trace-
  cubic decision (pointless ⟹ F55-NO ⟹ ed = 4). **Wave 28 (user:
  lane assignment + E18 discipline; Note IX §8.2 opened): the
  odd-Frobenius chain derivation is the DIRECTOR LANE, run to a
  decision (obstruction OR proved no-go — a no-go leaves E18 as the
  only F55 route). Derived at opening: (1) ⟨5⟩ = QR ⟹ source/target
  characters each fill one QR-coset and the whole configuration has
  ONE discrete modulus t = a/c ∈ units/QR; (2) the first-order germ
  layer is EMPTY (weights c·{2,3,4,8} generate Z/11 additively) ⟹ any
  obstruction is GLOBAL (divisor/degree bookkeeping, the H0/H1
  altitude); (3) structural risk recorded: C₅ acts freely on all
  C₁₁-fixed data at every level — the exact freedom behind the E14
  escape — so a no-go is live. E18 protocol per user (think before
  crunch): NO point searches (can only prove YES); step 1 = derive the
  bad places and run LOCAL SOLUBILITY only (bounded, both outcomes
  decisive: an insoluble place ⟹ F55-NO ⟹ ed = 4; soluble everywhere
  ⟹ the obstruction is global, informing the descent tool choice).**
  **Wave 28 lane decision (same day; Note IX §8.3): Theorem IX.8 —
  the F55 NO-GO.** All four calculus layers are SOLVABLE for F55 on
  either twin: incidence (bijective matching exists), germs
  (`c·{2,3,4,8}` generates `Z/11` — both `t`-values realizable),
  scalar-birth (target `C₁₁`-fixed loci are FINITE ⟹ forced
  pointwise-fixed source strata contract consistently — the
  0-dimensionality that would have armed the σ-machine DISARMS the
  odd one), and links (the endpoint weight-negation graph is the full
  `K₅` on both twins — computed independently on each, agreement =
  IX.7 consistency test; no self-links; no constraint on `t`). The
  C₅-freeness decomposes the global system into five conjugate
  independent subsystems ⟹ solvable. THE MACHINE AT ITS CURRENT
  ALTITUDE CANNOT CLOSE F55 (mirror of the Klein FIX-D2 terminal
  verdict; scope: no-go, not unprovability; no map constructed — F55
  stays OPEN). Route 1 CLOSED-NO-GO; F55 rides on E18 arithmetic
  (bad-places derivation next, local solubility only) or a new global
  invariant. Moral recorded: BOTH named negative targets (spin-G,
  F55) now have provably-insufficient fixed-locus machinery — every
  negative road leads through arithmetic or a genuinely global tool.**
  **Correction IX-b (same day, user-caught): THEOREM IX.8 WITHDRAWN.**
  The layer-4 "solvable" verdict assumed the target supplies every
  weight-admissible linking curve; the machine's full form requires
  MEASURING the target curve inventory (the exact analogue of the
  E14-deciding measurement `X^σ ⊃ L_σ`). Measured (Note IX §8.4, probe
  `v14_f55_curves.py`, mod 397): **THE PENTAGON** — contained lines
  join exactly the five ratio-{5,9} pairs of the C₁₁-points (the
  5-cycle 2—7—8—6—10), NO lines on the five pentagram (ratio-{3,4})
  pairs, and NO equivariant conics anywhere (tangency fails); the
  inventory is STRICTLY smaller than the abstract weight test's K₅, so
  IX.8's proof collapses. F55-machine status: OPEN-DERIVATION with two
  named finite sub-questions — (1) INVENTORY: any equivariant stable
  rational curve through a pentagram pair at any degree
  (eigen-support/wedge-table classification, input = the 45-pair
  table); (2) FORCING: are tower values rigid (all fixed components of
  one tower ↦ one point)? Rigid + empty inventory ⟹ F55-NO ⟹ ed = 4;
  flexible + nonempty ⟹ honest no-go. Layers 1–3 of §8.3 stand;
  §8.3's consequence paragraph is withdrawn with the theorem. E18
  unaffected, still parallel.** **Wave 28 (user pace-challenge "Days?"
  — inventory sub-question largely resolved same evening; Note IX §8.4
  span classification): any stable curve spans a stable sum of
  eigen-lines; the full 256-subset sweep (one C₅-orbit covers all five
  diagonal pairs) shows through-components only at span ≥ 8; at span 8
  exactly two sections hit, each = (pentagon line) ∪ (irreducible
  C₁₁-stable DEGREE-13 curve, p_a = 6, through both diagonal points).
  **Lemma IX.9 (equivariant fixed-point count): an irreducible curve
  with nontrivial C₁₁-action and ≥ 3 fixed points of multiplicity < 11
  is not rational.** Both deg-13 curves carry exactly THREE fixed
  points (A: y₂ mult-2 + y₆, y₇; B: y₂, y₆ + y₈ singular) ⟹ both
  NON-RATIONAL. **Span-≤8 verdict: the rational-curve inventory
  through the five C₁₁-points is EXACTLY the pentagon; no rational
  curve joins any diagonal pair.** Remaining: span-9/10 no-reuse
  systems (degrees 8, 9 — finite, named), the degree-≥11
  character-reuse lemma (open), and the §8.4 rigidity sub-question
  (untouched). Probes `v14_f55_sweep.py` + inline follow-ups,
  mod 397.** **Wave 28 (user doctrine: reduce to computation through
  analytic proofs; Note IX §8.5): the inventory by analysis.** Weil
  weights `U = {0} ∪ QR`, each once ⟹ **Theorem A**: the five
  C₁₁-points are the five pure decomposables = the edges of `{1,3,4,5,9}`
  with non-residue sum; contained lines ⟺ shared vertex; the
  shared-vertex graph is 2-regular ⟹ THE PENTAGON IS A THEOREM (no
  computation). **Lemma B**: `|V₁₄^{C₁₁}| = 5` via topological
  Lefschetz (`χ = 4 − tr(ĥ|H³)`, `H³ ≅ H³(Klein)` = all ten nontrivial
  characters by Griffiths residues ⟹ `tr = −1`) ⟹ the M-eigenvectors
  `v_q` (q ∈ QR) are nondecomposable ⟹ the V₁₄-condition is one
  bilinear identity `E_q` per residue weight with BOTH coefficients
  nonzero. **Theorem C (u₀-free kill, all degrees and genera, no
  equivariance needed)**: a curve whose planes avoid `u_0` has all five
  diagonal Plücker minors ≡ 0 (by `E_q`), and the `{1,4,5,9}` Plücker
  relation then forces `D₁₅·D₄₉ ≡ 0` — a domain ⟹ the curve misses one
  of the two diagonal endpoints. NO u₀-free curve joins any diagonal
  pair (subsumes/explains the two deg-13 curves, which use u₀).
  **Reduction D**: all survivors factor through ONE shifted-Plücker
  system on the C₁₁-quotient (`ζ = z¹¹`; ten one-variable polynomials,
  Grassmann relations with carry-shifts in `ζ^{0/1}`, two endpoint
  units), finite per ζ-degree, ζ-degree 0 = the old span-9/10 cases;
  uniform closure = one remaining analytic gap (valuation descent,
  named). Rigidity still open and still required.** **Wave 28 (user:
  "close the remaining analytic gap faithfully"; Note IX §8.6): the
  gap is closed AS A REDUCTION — unbounded degree is eliminated —
  but the final verdict is honestly NOT yet derived. Proved tonight:
  **Theorem E (squares kill)**: after diagonal elimination each
  `D₀q²` sits in one Plücker relation; support analysis kills every
  `|Z| ≤ 3` (Z = the set of nonzero u₀-minors; Z = ∅ is Theorem C) ⟹
  survivors use u₀ in ≥ 4 of the 5 residue weights, with forced
  nonzero pentagon coordinates per stratum. **Tropical layer**: at
  each endpoint the valuation vector of the ten forms is a tropical
  Plücker (tree) vector on six leaves with mod-11 congruence
  rigidity, exact proportionality equalities, corner normalization,
  and a shared degree budget. **Lemma F (exposure)**: in the six
  quadruples through the corner pair the corner unit exposes one
  coordinate each; exposed coordinates can never attain the global
  minimum ⟹ the minimum lives only on the three pairs meeting the
  corner plane once (`{w₀₉ = w₄₅, w₁₉, w₃₄}` at 0; primed twins at
  ∞); `|Z| = 4` strata degenerate quadruples to EXACT two-term
  equalities. REMAINING: feasibility of the doubly-constrained tree
  system (finitely many topologies × 10 σ × 6 strata) — infeasible
  ⟹ pentagram inventory EMPTY at all degrees; feasible trees ⟹
  bounded exact solves re-enter legitimately. No claim beyond
  this.** **Wave 28 (continuation; Note IX §8.7): Lemma G — the tree
  system is FEASIBLE; the tropical route ends WITHOUT a kill.** In
  corner coordinates (contact orders p, q against the corner plane)
  the five proportionality constraints become `q₅ = p₀` plus four
  twice-min matchings, congruence-consistent in every branch; an
  explicit certificate at `σ = 7`, `|Z| = 5` (`m = 5`, cascade
  `q₁ = 2m, p₃ = 3m, q₀ = 5m, E″ = 4m`, free `q₃ = 13, p₁ = 12`)
  satisfies ALL fifteen four-point conditions (hand-checked), the
  cascade is congruence-automatic for every σ, certificates exist at
  all σ for large m, and the ∞-corner is the C₅-translate (pair
  `{1,5} = 3·{4,9}`). CONSEQUENCE: the necessary-conditions tower
  (incidence → germs → links → span sweep → squares → trees) is
  EXHAUSTED — everything provable at these altitudes is proved, and
  the last layer is satisfiable, so valuations alone cannot decide
  the pentagram inventory. The decision drops to bounded exact
  solves at the tree-pinned minimal profiles (legitimate computation
  per doctrine). Strategic read: feasible degeneration profiles at
  every σ RAISE the odds the inventory is nonempty and the machine's
  F55 run ends in an honest no-go — F55 then rides on E18/arithmetic
  alone. Rigidity unaffected, still open.** **Wave 29 (user: "continue
  until an answer in either direction for F55"; Note IX §8.8): the
  DECISION DRIVE.** (i) F55 LANDING LADDER opened (monomial reduction:
  F55-characters are trivial on C₁₁ ⟹ no h-twist; `T_i = ω^{si}·
  shift^i(T₀)`; probe `f55_ladder.py`, p = 661 ≡ 1 mod 55, all five
  C₅-twists, geometric emptiness by saturation): d = 2 EMPTY by hand
  (unique family `ε_i x_{i+1}x_{i+3}`, five distinct landing
  monomials); d = 3 EMPTY (full P²(F₆₆₁) scan + saturation); d = 4, 5
  EMPTY (saturation); d = 6 in flight; stop-rule gate at 7. (ii) THE
  TWO SIDES MEET: by specialization + D-R 10.5, F55-YES ⟺ the generic
  F55-twist has a K-point, and that twist is ALREADY SEALED as E18's
  five-variable cyclic trace cubic `Φ(a) = Tr_{E/K}(r₂⁻¹a²σ(a))` over
  `K = C(U₁..U₄)` (packet H_11_5_TWIST, order-11 coefficient class
  sealed, class-alone-insufficient sealed). **The F55 binary on BOTH
  twins is exactly: does Φ have a nontrivial K-zero? YES ⟺ new
  positive CTZ case; NO ⟺ headline NEGATIVE, ed = 4.** Next
  derivation: divisorial/local analysis of Φ at the order-11 class's
  ramification — the trace-form-specific obstruction the sealed
  packet stopped short of. No answer yet; both flanks now aimed at
  one explicit cubic.** **Wave 29 (continuation; Note IX §8.9,
  DRAFT-FOR-DERIVATION): the valuation campaign on Φ opened.** Under a
  monomial valuation the five trace terms have orders `μᵢ = 2sᵢ +
  sᵢ₊₁ − w₂₊ᵢ`; `det(2I+σ) = 33` yields invariant congruences `Σμᵢ ≡
  0 (mod 3)` and `Σaᵢμᵢ ≡ −W (mod 11)` — the mod-11 functional is the
  KLEIN WEIGHT vector `aᵢ = (−2)ⁱ` (transpose kernel), tying the
  twist arithmetic to the weight calculus of §8.1. Yields: `W ≢ 0
  (mod 11)` forbids five-way ties; unique-minimum ⟹ `Φ(a) ≠ 0`
  outright; pointlessness reduces to a FINITE tie-cascade (2/3/4-term
  residual equations over trdeg-3 residue fields, order-11 class as
  engine). One closing valuation ⟹ F55-NO ⟹ ed = 4. Route is
  NO-only; YES stays with the ladder (d = 6 in flight). Active
  derivation: the tie-cascade.** **Wave 29 (analytic derivation
  completed while the ladder runs; Note IX §8.9.1 + Correction
  IX-c):** the mod-11 functional corrected to `λᵢ = 5ⁱ = (−2)^{−i}`
  (conjugate Weil vector; consequences unchanged). **Proposition
  (ψ-structure):** `Φ = Tr(r₂⁻¹ψ(a))`, `ψ(a) = a²σa`; if `[r₂]` died
  in `E*/ψ(E*)·C*` the form WOULD have zeros (untwist to the Klein
  trace form, which vanishes on `X(C)`) ⟹ any pointlessness proof
  must essentially use the sealed order-11 class; no generic
  argument can work. **Tempering theorem:** leading-term cancellation
  at any single tie/cone is always coefficient-solvable (face
  restrictions of one Newton polytope, chain-coupled slots) ⟹ the
  obstruction, if real, is a GLOBAL lifting obstruction across the
  normal fan — same difficulty class as §8.7's tropical-to-exact gap.
  The §8.9 quick-cascade hope is WITHDRAWN (correction discipline).
  **Honest position: both F55 flanks end at matching lifting gaps
  (geometric §8.7, arithmetic §8.9.1) — presumably why the case is
  named-open. Live decisive assets: ladder hit (d = 6 running, gate
  7); a new class-to-form idea; machine inventory+rigidity against
  trend. No elementary closure either way — the analytic conclusion
  of the campaign.**** **Wave 29 (user: "work on the class-to-form
  bridge"; Note IX §8.10): the bridge derivation session.** **Theorem
  H:** Φ is LOCALLY SOLUBLE at every split place (exact-tie
  realizability on the index-33 lattice + free residue solutions +
  Hensel; σ-invariant places PARTIAL-sketch soluble) ⟹ no
  one-bad-place proof exists; pointlessness is irreducibly global.
  **Theorem I (bridge, exact form):** F55-YES ⟺ ∃ trace-zero φ
  (= ρ−σρ, additive H90) with div_T(φ) ∈ Im(2+σ) and monomial
  λ-class ≡ 8 mod 11; per-orbit invariants = (sum mod 3,
  5ⁱ-weighted sum mod 11). **Mod-3 surprise:** the naive families
  `(r^m − r^{σm})k³` die at the MOD-3 orbit-sum (cube corrections
  cannot fix it), while the mod-11 defect is correctable — the first
  tooth of the bridge is the 3-part of coker(2+σ) (the cubic-ness),
  not the 11-part. **Alignment:** the Kummer generator b satisfies
  λ(e_b) ≡ 0 (11) and Σe_b ≡ 0 (3) ⟹ b = c·ψ(monomial): the
  11-cover and ψ are aligned; any reciprocity NO-argument must work
  modulo this, any YES-construction can exploit it. Named next:
  reciprocity pairing against the b-cover on a compactification
  (NO); the (i)-(iii) interpolation problem (YES; bounded search now
  legitimate).** **Wave 29 (continuation; Note IX §8.11): the
  reciprocity layer.** **Theorem J (trace-zero twice-min law):** for
  trace-zero φ, EVERY σ-orbit of primes on any equivariant model
  (zeros and poles alike) attains its multiplicity-minimum at least
  twice (leading-jet cancellation in `Σφ∘σ⁻ⁱ = 0`); at σ-invariant
  primes the trace-zero condition RECURS on the leading jet. The
  arithmetic twin of §8.6's tropical Plücker twice-min — the two F55
  flanks obey the SAME shadow law (one lifting problem, two
  costumes). **Corollary J.1:** Theorem-I image-patterns with unique
  minimum (e.g. `(5,2,0,1,4)`) are FORBIDDEN; `(1,2,0,0,0)` survives
  — the feasible set is a proper computable refinement, not yet
  empty. **The anchored pairing exists:** the naive per-orbit
  `λ = Σ5ⁱvᵢ mod 11` is base-point-ambiguous by ×5; the SEALED
  Kummer recursion `σ(b) = r₂⁻¹¹b⁻²` twists b's residue character by
  ×(−2); `5·(−2) ≡ 1 (mod 11)` ⟹ `⟨φ, b⟩_O` is WELL-DEFINED — the
  11-cover's (−2)-cocycle exactly compensates the weight ambiguity
  (the Klein's own (−2) again). Remaining: the global Parshin-style
  sum formula for `Σ_O⟨φ,b⟩_O` on the μ₁₁-cover; a forced global
  term ≢ 8 would violate Theorem I ⟹ F55-NO. Active derivation.**
  **Wave 29 (user: "derive the sum"; Note IX §8.12 + Correction
  IX-d): the sum derived faithfully.** CORRECTION IX-d: §8.11's
  "well-defined in Z/11" was overclaimed — over C the divisibility of
  C* kills every scalar reduction; the pairing lives in
  `κ(P)*/(κ(P)*)¹¹` and the only true sum formula is the GERSTEN
  reciprocity for `Br(E)[11]`. Derived exact identities: (1) the
  b-cover is the torus isogeny with deck μ₁₁ and σ acting on the deck
  by −2 ⟹ its symmetry group is F55 ITSELF; (2) `Σ(−2)ⁱ = 11` ⟹
  `N_{E/K}(b)` is an 11th power (norm-trivial); (3) `e₁+e_b` is even
  ⟹ with `n = r^{(1,1,−2,2,0)}`: `σ⁻¹b = b⁵n⁻¹¹` EXACTLY ⟹
  `[σ⁻¹b] = [b]⁵` on the nose; (4) under Theorem-I(ii):
  `A_K = cores(φ,b) = 7·cores(a,b) + cores(r₂⁻¹,b)` in `Br(K)[11]`;
  (5) THEOREM K: the transported orbit-residue is `[b|_P]^{λ_O}` ⟹
  (ii) makes `A_K` UNRAMIFIED at all split interior primes — its only
  possible ramification is σ-invariant primes (Theorem-J jet
  recursion) and the boundary (where (iii) lives). ENDGAME SHAPE: a
  bounded residue computation on a σ-stable toric compactification —
  inconsistency ⟹ F55-NO ⟹ ed = 4; consistency ⟹ the reciprocity
  route exhausts and F55 rides on construction alone. Analysis-first
  has carried the route to the last bounded computation.** **Wave 29
  (user challenge "are you sure you are done with analysis?" — NO;
  Note IX §8.13): three further derivations.** **Theorem K′:** σ has
  exactly FIVE fixed points on T (codim 4) ⟹ T → T/σ étale in codim
  1 ⟹ interior places split or inert only; at inert places the
  A_K-residue is a NORM of b-data, killed by N(b) ∈ (E*)¹¹ ⟹ **A_K
  is unramified on the ENTIRE interior**, and K rational ⟹ Br_ur = 0
  ⟹ A_K is determined by BOUNDARY residues alone. **Constraint
  (iv):** interior residue-matching of the two A_K-expressions forces
  the SECOND-ORDER congruence λ₂ = λ∘(2+σ̃)⁻¹ ≡ 0 on φ's orbit
  patterns (index 33 → 363) at every orbit whose primes are not
  b-split; the only escape is complete splitting in the T′-cover.
  **The cover loop:** the escape localizes on T′, whose symmetry
  group is F55 itself — the obstruction analysis closes onto an
  F55-symmetric 4-torus (deck μ₁₁ by translations, σ by lattice
  maps). Remaining analysis: (α) the boundary ledger, with
  cores(r₂⁻¹,b) fully explicit; (β) the b-split orbits on T′.
  Computation threshold NOT yet reached.** **Wave 29 ("keep pushing";
  Note IX §8.14): the boundary ledger lands.** `c := Σ5ⁱe_{2−i} ≡
  3·(−2)ⁱ` — the Klein weight vector's THIRD role. No σ-invariant
  rays exist (N^σ = 0) ⟹ all boundary orbits size 5. **Theorem L:**
  `∂_q(B) = ∂_w(r^{−c}, b) = [r^{⟨w,c⟩e_b − ⟨w,e_b⟩c}]`, vanishing
  iff both pairings ≡ 0 mod 11; e_b, c independent mod 11 ⟹ **B =
  cores(r₂⁻¹,b) ≠ 0 in Br(K)[11]** — the obstruction algebra
  genuinely lives, with a fully explicit ledger. **Theorem M:** the
  λ-twisted norm `N_λ(x) = Πσ⁻ⁱ(x)^{5ⁱ}` satisfies `N_λ(ψa) =
  N_λ(a)⁷`, `N_λ(r₂) = r^c` — the SAME 7 and c as the §8.12
  corestriction identity: independent computations agree (coherence
  check passed). **Theorem N:** `λ_w(φ) ≡ −⟨w,c⟩` at EVERY boundary
  orbit — φ's boundary λ-invariants are PINNED to c, no freedom; at
  rays with ⟨w,c⟩ ≢ 0 the boundary pattern exits Im(2+σ̃) while
  Theorem J still binds. Remaining analysis: (α) clean per-ray
  solvability of the full consistency equation; (β) b-split orbits
  on T′; (γ) codim-2 Gersten links. One unmatchable ray ⟹ F55-NO ⟹
  ed = 4.** **Wave 29 ("keep pushing"; Note IX §8.15): the per-ray
  equation COLLAPSES.** **Theorem O:** with leading units, the whole
  per-ray consistency equation cancels (the N_λ- and r^c-terms meet
  their Theorem-M twins exactly — another coherence pass) down to
  `[ℓ_w(b)]^{7λ_w(a)} ≡ 1`: NO ray is unmatchable outright; instead
  the UNIFORM LAW (iv′): `λ_O(div a) ≡ 0 (mod 11)` at EVERY orbit,
  interior AND boundary, off the b-split locus. The Brauer-residue
  layer yields no direct contradiction — it yields the second-order
  law everywhere. **Theorem P (transpose identity):** via the §8.10
  alignment, `cores(a,b) = cores(ψ*(a), r^x)` with `ψ* = 2+σ⁻¹` —
  a second independent residue computation with `⟨σⁱw,x⟩`-weightings;
  equating the two adds third-layer relations mixing the weight
  systems. **CONSOLIDATION: all Brauer theory discharged; the
  arithmetic flank is now ONE self-contained lattice-combinatorics
  feasibility system (F1)–(F4) on the single datum div(a):** J-laws
  on `(2+σ̃)D − div(r₂)`, the uniform (iv′), the transpose
  relations, and pinned-boundary/principality closure. Infeasible ⟹
  F55-NO ⟹ ed = 4; feasible ⟹ the arithmetic flank ends at the same
  lifting gap as the geometric one. Honest prior: feasible (every
  prior layer escaped), but this is the tightest interlock yet.
  Next and plausibly last analysis block of the flank.** **Wave 29
  ("keep going"; Note IX §8.16): the CRUX POLYTOPE QUESTION.**
  Boundary-(F1) through Newton polytopes: pattern =
  `(2h_Q(σⁱw) + h_Q(σ^{i−1}w) − ⟨σⁱw, e₂⟩)ᵢ`. **Theorem Q:** the
  boundary half of the final system ⟺ ∃ lattice polytope Q with that
  pattern's min attained twice for EVERY w. Proven tonight:
  0-dim Q fails (shadow echo of "no monomial is trace-zero");
  σ-invariant Q fails IDENTICALLY, and the exact defect-removal
  demands the NON-LATTICE point `(2+σ)⁻¹e₂` (denominator exactly 11)
  — **the order-11 class in its THIRD guise: multiplicative class →
  congruence functional → polytope non-integrality.** Honest
  trace-zero functions satisfy J via chain-sharing of Newton faces
  (the `r₀ − r₁` pentagon chain); a feasible Q must orchestrate the
  chain against the e₂-defect; first candidates fail; asymmetric
  zonotopes next. **Two DISTINCT 11-covers** govern the two escape
  hatches (`adj(2+σ)e₂ ≢ unit·e_b` mod 11). Interior orbits are
  free (`11e₀`-certificates). STATUS: F55-NO ⟺(shadow) no such Q +
  (F3)/b-split closure; an explicit Q ⟹ the arithmetic flank ends at
  the same lifting wall as the geometric flank. Active: structured-Q
  hunt vs a hoped-for unique-exposure invariant.** **Wave 29 (user:
  "keep going, no report until YES/NO"; Note IX §8.17 + probe
  `f55_cruxlp.py`): the endgame state — ONE NAMED LEMMA from the
  headline.** **Theorem R (h-free congruence):** `2 + 9 = 11` ⟹
  `Σ9ⁱF(σⁱn) ≡ −⟨n, c₉⟩ (mod 11)` for ANY integer-valued h, every
  lattice n; at anchors (`⟨n,c₉⟩ ≢ 0`, e.g. the special orbit
  `(1,…,1) − 5eⱼ`) the five orbit-values can never be all equal.
  **Certificate hand-verified:** the LP's four-term mod-11 Farkas
  vector (coeffs 1,10,3,6 at the special rays) IS Theorem R in
  consecutive-difference form — all five h-coefficients cancel, the
  e₂-part survives ≡ ±1. **Sweep:** A₄ fan (unimodular, 30 rays):
  every uniform pattern (20) and 400 random patterns: solvable over
  Q and mod 2,3,5 — INFEASIBLE mod 11, every time; stellar
  refinement (135 cells): 120 random per-cell patterns — all
  infeasible; invariant rational solution has denominator exactly
  33. **Structural web:** every chamber contains exactly one special
  ray; one value-vector V; 120 tie-edges on Z/5; horns: trivial
  partition ⟹ twice-min fails; total ⟹ Theorem R violated;
  constant partitions killed by shift-monodromy (d | 5). **LEMMA S
  (named, finite, OPEN):** the varying-partition escape cannot dodge
  all anchors on any σ-invariant fan. **Lemma S ⟹ Theorem Q = NO ⟹
  Φ pointless ⟹ F55-NO on both twins ⟹ HEADLINE NEGATIVE, ed = 4,
  CSD instance refuted, Beauville classification completed. Lemma S
  false ⟹ arithmetic flank ends at the lifting wall, F55 open. NOT
  claimed either way (IX-8 discipline; four prior escapes demand the
  lemma be decided explicitly). First time in the program: a single
  named finite statement stands between the state and the
  headline.** **Wave 30 ("go get it"; Note IX §8.18, probes
  `f55_design.py`, `f55_hfan.py`): THE CONSERVED ELEVEN — both poles
  of the escape space die.** The one identified escape: the G₉-fan
  (orderings of `Hₖ = ⟨σᵏ·, G₉⟩`; every wall-normal ≡ G₉ mod 11;
  `c₉ = 4G₉`) dissolves the level-1 obstruction into `Στ ≡ 7`.
  There: isotropic margin designs solve (ii) (particular `7P₂+P₃`,
  kernel dim 7) but PROVABLY fail covering (200k samples + support
  analysis); the free design reduces to ELEVEN ray-unknowns
  (bottom-2 zero-pattern = perfect 2-cover). Exact fate (15,892
  conditions): mod 5 and mod 11 both force `v ≡ 0` — the wall
  degeneracy imports 55-divisible ray-gaps, re-importing 11 through
  INTEGRALITY — and at level 121 the substituted system is
  **INCONSISTENT**: the anchor content reappears one 11-adic level
  up. Mechanism now end-to-end: class → congruence → denominator →
  gap → next level; the eleven is conserved. **Proof plan for Lemma
  S:** (α) dichotomy (anchor-obstructed vs G₉-aligned-with-regress);
  (β) the regress induction. Remaining sweeps: mixed fans, other
  H-fan patterns, the second 11-cover direction. Needle points hard
  at S-TRUE (⟹ F55-NO ⟹ ed = 4); theorem NOT yet claimed.**
  **Wave 30 ("careful and thorough but LFG"; Note IX §8.19, probe
  `f55_sweep2.py`): TOTAL CORNER CLOSURE + two proved lemmas; the
  last gap is ONE renormalization statement.** Sweep table (all
  verdicts rigorous — infeasibility from finitely many derived-valid
  constraints): A₄ 420 patterns dead at level 11; stellar refinement
  120 non-equivariant patterns dead; G₉-fan ALL 26 rank-patterns
  (complete): 9 with no free rays (anchors violated), 17 forced
  `v ≡ 0` then DEAD at level 121; e_b-fan (second cover direction)
  4/4 same signature; isotropic designs covering-infeasible
  (complete support analysis). **Lemma T (freezing, PROVED):**
  wall-span confinement of ū mod 11. **Lemma U (ker-π₉ case,
  PROVED):** 9-inactive wall-span ⟹ level-1 death (`0 ≡ −4`).
  **Lemma V (self-similarity, OPEN, exactly stated):** for 9-active
  aligned fans the level-(t+1) system ≅ the same system on the
  11-isogenous lattice (the T′-cover, deck symmetry F55) with the
  SAME anchor c₉ (eigenvector, anchors persist under refinement);
  V + T + U + descent ⟹ Lemma S ⟹ F55-NO ⟹ HEADLINE NEGATIVE,
  ed = 4. Verified instances of V: two independent aligned fans,
  level 1→2, both dying at 121. Remaining routine: non-rank
  patterns on aligned fans; mixed fans. The conserved eleven now
  has a name at every level of the tower.** **Wave 30 (continuation;
  Note IX §8.20 + Correction IX-e): the U-FRAME and the exact level-2
  system.** Working with per-cone slopes `U(C) ∈ Λ` (equivalent to
  integer values — full-dim cones' lattice points generate N):
  (3) ⟺ (ii) EXACTLY, purely mod 11 — **Correction IX-e:** the
  "anchor at mod 121" prose was imprecise; the computations were
  sound (derived-valid conditions) and what they detected is now
  identified exactly: on aligned fans `U = τG₉ + 11V`; level 1 fixes
  `Στ ≡ 7` and `m_W` mod 11; the residual freedom `m_W ↦ m_W + 11`
  shifts V-jumps by exactly `ν_W` (the recursion in miniature); the
  binding level-2 constraints are the **V-WEB SYSTEM** — V-path-sums
  between zero-cells must vanish, with inhomogeneity DRIVEN BY the
  τ-field (`Στ ≡ 7 ≠ 0` ⟹ τ ≢ 0 ⟹ nonzero renormalized anchor).
  **Lemma V (final form):** the V-web is again a (1)(2)(3)-type
  system with anchor = the τ-class, nontrivial whenever the level
  above was ⟹ induction ⟹ `U ≡ 0 mod 11^∞` ⟹ contradiction ⟹
  Lemma S. V-web infeasibility COMPUTED on both aligned fans, all
  coherent patterns; the self-similarity proof + two routine
  closures = the single remaining task.** **Wave 30 (continuation;
  Note IX §8.21 + Correction IX-f): the level-2 certificate and the
  SIMPLER endgame.** **Correction IX-f:** §8.20's "iterate the
  descent" was wrong-shaped — there is NO infinite descent: level 1
  is solvable and LEVEL 2 (the V-web) dies OUTRIGHT on both aligned
  fans, every pattern; the remaining task shrinks to direct V-web
  infeasibility. **Derived: the τ/Θ-curvature reformulation** —
  `Θ_W = ρ_W/λ_W mod L₉`; the V-web mod 11 ⟺ τ ⊥ the Θ-curvature
  web (summation by parts; τ dies at zero-cells); Lemma S (aligned)
  ⟺ **the orbit-sum functional lies in the span of the Θ-curvature
  relations** (⟹ 7 ≡ 0 absurd). Seed: `ρ₀₁ = −(1,3,2,3,5)` exact.
  **Level-2 Farkas certificate extracted: FOUR terms again**
  (coeffs 6,6,2,1; anchors 8,5,1,6) but spanning four DIFFERENT
  rank-chambers — a genuine web identity, as the curvature picture
  predicts. Final list: (1) unwind the certificate ⟹ span-statement
  on the G₉-fan; (2) generalize over aligned fans; (3) two routine
  closures. Nothing else stands before Lemma S ⟹ F55-NO ⟹
  ed = 4.** **Wave 30 (user request): `HANDOFF_F55_ENDGAME.md`
  written — the complete endgame handoff: the reduction chain with
  per-link status, everything proved toward Lemma S, tasks T0–T7 in
  order (re-verify certificates; unwind the level-2 certificate;
  span-statement on the G₉-fan; generalize to aligned fans; free
  patterns; mixed fans; assemble + re-audit the chain; seal +
  external review), the failure-branch protocol, parallel items,
  trust notes (six corrections, conventions that bite), and the
  file map.** **Wave 31 (2026-08-07, "complete the endgame"; Note IX
  §8.22 + Corrections IX-g/h; probes `f55_exact1.py`, `f55_exact2.py`,
  `f55_eweb.py`, `f55_xistar.py`, `f55_free_sweep.py`,
  `f55_signfan.py`, `f55_signfan_close.py`): T0–T2 and T4 CLOSED; the
  aligned kill made exact and pattern-complete on two fan classes.**
  T0: level-1 certificate reproduced exactly ((1,10,3,6) at the
  special orbit, b·y = 10; Theorem R re-derived by hand); G₉-fan
  sweep reproduced — **Correction IX-g**: the §8.19 split is 8
  no-free-rays + 18 level-2 deaths (not 9+17; all 26 dead), and
  `f55_sweep2.py`'s part (B) never ran. T1–T2: the sampled "level-121"
  system collapses exactly (profile lemma `H_a ≡ 5^a V₀`; ray gaps
  all 55; `9·5 ≡ 1`) to 24 σ-invariant chamber rows `E(O)·w ≡ 2`
  that are PATTERN-INDEPENDENT (zero chambers' functionals die on
  bordered rays), factor through SIX twisted translate-sums
  (`rank(E) = 6`), and admit the unique solution ξ* = (7,4,2,10,3,9),
  nowhere zero. Feasibility ⟺ every subset-class keeps a free ray;
  exhaustive transversal count: 0 of 15,625 admissible ⟹ **Theorem X:
  EVERY pattern (rank or free, any ≥2-per-orbit zero web) on every
  fan with walls among {H_a = H_b} is infeasible** — level-1 forcing
  by hand via Lemma T + 11-divisible ray values (Theorem W; machine
  rank cross-check), hand certificates: 3-row canonical with column
  sums 77,77,55,55,55,55 vs RHS 4; sixteen patterns die by 2-row
  proportional pairs (ratio −5 = −9⁻¹; 54+1 = 55). Sharp: with ≥1
  zero/orbit all 15,625 transversals survive — twice-min is exactly
  load-bearing. T4 (unswept free patterns): closed by the same
  theorem; 4,000-random + hill-climb + all-uniform sweeps confirm.
  **Theorem X′: the sign-fan** (arrangement {H_a = 0}, first aligned
  fan NOT refined by the G₉-fan) **dies for every pattern**: the
  (τ,Ψ) pair-field shadow (Θ-list (0,(0,0,10),(0,2,10),(7,2,10),
  (3,7,5)), 7-dim jump+sum space) is inconsistent for ANY two zeros
  on the corank-1 orbit (10/10 pairs; middle orbits 5/10; singles
  consistent); DFS over all 10⁶ minimal patterns prunes at orbit one.
  **Correction IX-h: IX-f's "no tower needed" overgeneralized** —
  depth-t aligned fans (walls ≡ λG₉⁽ᵗ⁾ mod 11ᵗ, Hensel lifts; σ-orbit
  arrangement construction) exist for all t and their level-2 shadow
  is SOLVABLE (all Θ = Θ*, the transport-fixed point): the corrected
  Lemma-S-aligned shape is induction on alignment depth, finite per
  fan (9̂ ∉ Q ⟹ no integer normal is deep to all orders). Derived
  for T3: the canonical (τ,Ψ)-frame with affine transport
  **Θ_{σW} = 5σΘ_W + 5γ′**, γ′ = (0,−4,−2,−3,−7) ∉ ⟨G₉,diag⟩ ⟹ ≤1
  flat wall per σ-orbit (σ-invariance itself generates curvature);
  null walls impossible (content 11). REMAINING for Lemma S: general
  aligned fans (depth induction + general depth-1 combinatorics) and
  mixed fans (T5). Lemma S / F55-NO / ed = 4 remain UNCLAIMED.**
  **Wave 31 (continuation; Note IX §8.23, probe `f55_a4exact.py`):
  THE A₄-FAN DIES FOR EVERY PATTERN — level 1, three lines.** The
  η-rows are (ii) AT THE RAY POINTS (`ray(S+k) = σᵏray(S)`): six
  class targets `−5c₉(T_c) = (2,1,8,7,9,4)`, all nonzero; d = 0 at
  bordered ray points; the SAME covering theorem (0/15,625) forces a
  fully-bordered class ⟹ 0 ≡ nonzero. **Theorem X″** upgrades A₄
  from 420 sampled patterns to ALL patterns (+ all coarsenings of
  the A₄ arrangement); verified: identity at 200 patterns × 20
  points, 20,000 random + 26 uniform patterns infeasible, T6-audit
  of chain links 2–5 re-derived clean (Theorem I necessity is
  immediate; Theorem J one-line; min-normalization sound via
  Σ9ᵏ = 22 ≡ 0; value ⟺ slope standard). **The order-fan
  criterion:** for the order fan of any σ-orbit of a primitive form
  ℓ — generic ℓ: dies for every pattern iff all six
  ⟨ray_ℓ(T_c), c₉⟩ ≢ 0 (A₄ = ℓ = e₀*); aligned ℓ: level-2 with
  ℓ-specific ξ*(ℓ), dies iff nowhere zero (G₉-fan: (7,4,2,10,3,9));
  zeros push one 11-adic level deeper — the IX-h tower visible
  inside one family. Three fan classes now closed for every pattern
  (A₄ {n_a=n_b} level 1; G₉ {H_a=H_b} level 2; sign {H_a=0} level 2
  pair-field); the recurring final step is one covering statement
  against one finite nonvanishing vector. Lemma S still UNCLAIMED
  (arbitrary fans outside the three classes; mixed; depth tower).**
  **Wave 31 (continuation; Note IX §8.24, probe `f55_ellfan.py`):
  THE ORDER-FAN EIGEN-CLASSIFICATION (Theorem X‴).** By the active
  set A(ℓ) ⊆ {3,9,5,4} of mod-11 eigencomponents: (i) 5 ∉ A —
  Lemma U kills (level 1). (ii) A full — every ray keeps a nonzero
  v₅-component (block-Fourier lemma: all 24 coefficients 1̂_S(ε) ≢ 0)
  ⟹ all six class targets ≢ 0 ⟹ ray-point argument + covering kill
  EVERY pattern at level 1 (A₄ = the instance ℓ = e₀*; sweep 816
  fully-active ℓ, zero violations). (iii) A = {5} (aligned) — v ≡ 0
  forced, ξ*(ℓ)-criterion; **the e_b-fan CLOSED for all patterns**
  (ξ*(e_b) = (1,10,5,3,2,6) nowhere zero; e_b ≡ 8G₉ + 5·diag —
  upgrading the 4/4-sampled record), likewise G₉+11μ for three μ;
  the member G₉+11e₁ has 121-divisible ray gaps — the first concrete
  depth-2 tower inhabitant (level-3 analysis needed). (iv) 5 ∈ A,
  intermediate — rays collapse mod 11 into the inactive eigenspan,
  all targets vanish, profile carries |A| parameters: OPEN (the
  86/400 "bad generic" sweep = exactly the union a₃/a₉/a₄ ≡ 0,
  matching). Open territory now exactly: (iv), general ξ*(ℓ)
  nonvanishing, the depth tower, non-order fans beyond the sign-fan
  ((τ,Ψ)-frame), and mixed wall-systems. Lemma S UNCLAIMED.**
  **Wave 32 (2026-08-07/08, "delegate and finish"; Note IX
  §§8.25–8.26 + Corrections IX-i/j; seven delegated worker probes,
  every headline re-adjudicated by rerunning the committed
  deterministic scripts): REGIME (iv) SWEPT DEAD, ξ* PROJECTIVELY
  RIGID, THE TOWER VERIFIED TO 11⁴, THE FLAG-SIGN FAN CLOSED
  GLOBALLY, LINK 1 REPLAYED — AND THE MIXED FAN DEFEATS THE
  RELAXATION: POSITIVITY IS LOAD-BEARING.** `f55_verify_all.py`:
  all wave-31 verdicts re-asserted at fresh seeds (9 items / 40
  sub-checks, ALL PASS); both link-1 packets replay green
  (FIX-IX-SEAL end-to-end at fresh prime 353 incl. four M2
  recomputes; H_11_5_TWIST read-only OK; its ψ-matrix det-33 /
  denominator-11 block IS the Theorem-R operator and its pinned
  (2,1,−4,4,0) is e_b). **Correction IX-i:** sweep2's else-branch
  mod-11 reduction of 11∤L rows is not implied as written (G₉
  verdicts stand — the unreduced modulus carries the 11; the new
  level tools derive the reduction cleanly). `f55_midfan.py`:
  regime (iv) — 8 fans covering all six intermediate active sets,
  24,568 pattern tests, ZERO feasible; per-orbit row spaces provably
  saturated (dim = |A|); level-1 forcing is per-pattern (the
  no-pattern residual = the linear family, dim 4−|A|); 92/896
  regime-(iv) ℓ are deeper (tower inside (iv), unswept).
  `f55_alignedsweep.py`: 608 aligned fans, 455 with ξ* — EVERY one
  equals c·(7,4,2,10,3,9), c ∈ F₁₁*: **projective rigidity ⟹
  nowhere-vanishing** (the §8.24 open item is now ONE statement);
  (λ,μ mod 11)-dependence refuted but only through the scalar;
  deeper strata 135/17/1 at depth 2/3/4; the depth-2 fan G₉+11e₁:
  all 26 rank patterns DEAD at level 11³ (v ≡ 0 forced at levels
  1–2, full rank), a depth-3 member dead at 11⁴, killing row count
  invariantly 2286 — Lemma V's self-similarity has three verified
  rungs. `f55_mixedfan.py` (T5): the A₄∨G₉ refinement, 1090 cells
  and 2570 walls both PROVABLY complete (exact Zaslavsky counts),
  every wall certified by an exact rational facet point: level-1
  splits exactly — all non-aligned patterns (26 A₄-rank + 500
  random + saturating) DIE at level 1; 25 G₉-rank + all aligned
  pullbacks SURVIVE with solution space exactly U ∈ F₁₁·G₉
  (confinement forced by the zero web THROUGH the generic walls);
  survival criterion (every G₉-orbit keeps a shadow-free chamber)
  exact on 1052/1052. `f55_flagsign.py`: the flag-sign fan (480
  cells, 1080 walls) closed for EVERY pattern by solution-space
  DFS (83,386 nodes) — and NO local kill exists (0/96 orbits have
  an inconsistent pair; anchor 7→0 flips feasible): the first
  GLOBAL kill; the Theorem-X′ local template cannot carry the
  general aligned case. By-product: the G₉-order fan's (τ,Ψ)
  shadow dies independently (dim 24, DFS). `f55_mixedlevel2.py`:
  the mixed survivors' pair-field (dim 62 = 24 + 38 Ψ-slides along
  generic walls; law Δτ ≡ 0, ΔΨ ∈ F₁₁·ν̄ verified by 8000 integer
  simulations): 23/25 die — but **P = {0,1} and P = {3,4} are
  FEASIBLE** (+95 one-orbit variants + a non-pullback witness),
  twice-certified. `f55_mixedlevel3.py`: validated Z/11ˢ solver
  (1000 planted systems, Farkas certificates verified); gates: A₄
  dies at 11¹ (26/26), G₉-order at ≤11² ({1:1, 2:25}); mixed: 23/25
  die at 11², the two survivors are feasible through 11⁸ AND
  INTEGRALLY: ker_Z rank exactly 19, 11-SATURATED (⟹ the whole
  tower ⟺ Z), explicit integer U-field (max|U| = 336) verified
  over Z on every wall/zero/congruence and ground-truthed at 10⁴
  lattice points; ≥14 patterns carry integral witnesses; the
  witness has 81 NEGATIVE cells. **Correction IX-j (MAJOR): the
  (1)(2)(3)-frame and the handoff's Lemma-S transcription dropped
  positivity (d ≥ 0, the min-normalization); every recorded kill
  stands (relaxation, a fortiori), but the relaxation is strictly
  lossy — Lemma S must be restated with (0) d ≥ 0, and T5 cannot
  be closed by congruences at any 11-adic depth: the discarded
  inequalities are the whole remaining content on mixed fans.**
  The positivity-restored question is a bounded exact LP/ILP on the
  rank-19 solution lattice (`f55_mixedpos.py`, in flight at ledger
  time). Lemma S (corrected) UNCLAIMED in both directions.**
  **Wave 32 (continuation; Note IX §8.27, probe `f55_mixedpos.py`,
  director-adjudicated): POSITIVITY DOES NOT RESTORE THE KILL —
  LEMMA S AS STATED IS FALSE.** Mixed-fan rays enumerated exactly
  (460, with an INDEPENDENT completeness proof: essential
  arrangement ⟹ pointed chambers ⟹ every extreme ray has
  active-set rank 3 ⟹ count = 2×#(rank-3 flats) = 2×230 = 460;
  cross-checked by exact nonnegative-combination tests at 1500
  interior points of 550 cells), so `d ≥ 0` everywhere ⟺ at the
  460 rays. For the witness patterns the positivity cone K⁺ is
  FULL-DIMENSIONAL (dim K⁺ = 19 = dim ker_Q H) — no Farkas
  certificate exists — and explicit NONNEGATIVE INTEGRAL witnesses
  are constructed and verified for P = {0,1} (max|U| = 432),
  P = {3,4} (max|U| = 845) and 12 (e)-variants, 14 in all: 0/2570
  wall-integrality failures, 0/436 nonzero zero-cells (≥2 per
  orbit), 0/460 negative rays, and at 15,986 random lattice points
  with all σ-translates **d ≥ 0, the TWICE-MIN law, and (ii) all
  hold with 0 failures**. (15 of 27 (e)-variants die at the mod-11
  congruence layer alone; all 12 congruence-feasible ones carry
  witnesses.) **So the honest necessary system of IX-j — (0) d ≥ 0,
  (1) twice-min zeros, (2) integral slopes, (3) congruence — is
  SATISFIABLE on a σ-invariant complete fan: the UNIVERSAL
  quantifier in Lemma S is refuted.** Every §§8.22–8.25 fan kill
  stands as a theorem about the fan it names; what dies is
  "infeasible for EVERY fan". NOT a refutation of F55-NO: the value
  form is a SHADOW of Theorem Q, and a witness counts only if it
  LIFTS through `2h + h∘σ⁻¹ − e₂* = d + m` (per cone
  `2U_h(C) + σ_*U_h(σ⁻¹C) − e₂ = U_d(C) + U_m(C)`, m σ-invariant,
  wall conditions on both) — an 11-torsion global lattice question
  (det(2+σ) = 11 on Λ) that may carry more than the congruence (3).
  Lift ⟹ Lemma S false at the honest level, arithmetic flank ends
  at the lifting wall, F55 OPEN (handoff §4 failure branch); no
  lift ⟹ the preimage condition is NEW constraint content and the
  campaign resumes against it. Decisive probe `f55_qpreimage.py` in
  flight. Lemma S, F55-NO and the headline all UNCLAIMED.**
  **Wave 32 (terminal; Note IX §8.28 + Correction IX-k, probe
  `f55_qpreimage.py`, director-adjudicated incl. an independent
  sympy check of the key identity): THE WITNESS LIFTS — THEOREM Q
  IS SATISFIED, LEMMA S IS FALSE, THE VALUE-FORM ROUTE CANNOT
  PROVE F55-NO.** The lift is an IDENTITY, not a search: in
  `Z[x]/(x⁵−1)`, `(x+2)G(x) = x⁵+32 ≡ 33` with
  `G = 16−8x+4x²−2x³+x⁴`, so `2+σ̃` is injective, h is UNIQUE
  (`h = G(σ̃)(d+m+e₂*)/33`), and solvability ⟺ 33 | that, cellwise.
  `G(1) = 11` ⟹ σ-invariant m contributes `11U_m`, so CRT splits
  it: **mod 11 the m drops out and the condition IS congruence
  (3)** (verified as an operator identity); **mod 3 it is
  `U_m ≡ U_D`**, `D = Σ_j d∘σʲ`, satisfied by `m = D`. Mod 3 is
  load-bearing (m=0: 5/1090 cells divisible; m=D: 1090/1090) —
  §8.10's mod-3 surprise returning, here SATISFIABLE since m is
  free. **So on the mixed fan the value form and Theorem Q are
  EQUIVALENT, not strictly weaker** (§8.17's virtual-polytope
  generality vindicated; the preimage carries no extra content).
  Theorem Q proper delivered with an ACTUAL LATTICE POLYTOPE:
  `Φ = Σ|⟨l,·⟩|` over the 20 σ-stable forms is σ-invariant and
  strictly wall-convex with `2Φ+Φ∘σ⁻¹ = 3Φ`, so `h₀ ↦ h₀+128Φ`
  shifts F by an orbit-constant, is convex (0 failures at all 460
  rays), and `Q = conv{slopes}` has `h_Q = h_T`. FAN-FREE oracle
  (brute-force max over Q's lattice points, no fan/cells/walls):
  40,000 random w — twice-min 40000/40000 (multiplicity exactly 2
  at 39,712), Theorem R 40000/40000. All 14 witnesses lift.
  **Every fan-kill theorem of §§8.22–8.25 stands about its own
  fan; the universal quantifier is dead, and neither 11-adic depth
  nor positivity can repair it. §4 FAILURE BRANCH: the arithmetic
  flank ends at the same lifting wall as the geometric flank
  (§8.7) — two faces of one difficulty, as §8.21 suspected.**
  NOT settled: F55. Q-feasibility is necessary, not sufficient —
  it closes only the boundary half (F1); the (F3) transpose layer,
  the b-split bookkeeping, and the class-to-form existence of a
  trace-zero φ (§8.9.1) are untouched. **F55 OPEN; the headline
  UNDECIDED.** Second engine (Nemo/PARI) in flight.**
  **Wave 32 (continuation; probe `f55_core.gp`): TWO-ENGINE
  CONFIRMATION OF THE ALGEBRAIC CORE (PARI/GP 2.17.4, BLIND).** An
  independent PARI implementation, written without reading the
  Python probes or Note IX and only afterwards compared, reproduces
  every §§8.22–8.24 value: ray gap 55 with profile
  (11(5−|S|), −11|S|) and the 30 rays themselves; Theorem R at 3000
  random (h,n) with 0 failures, plus the symbolic reason (h-part
  coefficient 2+9 = 11 ≡ 0; twisted e₂-vector ≡ −c₉); rank(E) = 6;
  **the twist base 5 determined BY TEST, not assumption** (ker P₅ ⊆
  ker E holds, ker P₉ fails, 0 vs 500 mismatches); unique
  **ξ* = (7,4,2,10,3,9), nowhere zero**; covering 0/15625 at ≥2 and
  15625/15625 at ≥1; drop-one counts (3125,350,350,350,350,3125);
  A₄ targets (2,1,8,7,9,4). NO disagreements. Two extras: the
  covering failure is uniformly a SINGLE orbit (min survivors = 1
  for all 15,625; best transversal reaches 23 of 24 orbits), with
  a structural reason — within an orbit chamber π+d dies iff
  d ≡ u[c_j] − m_j (mod 5), so #survivors = 5 − #distinct{...},
  making "≥1" automatic and "≥2" a simultaneous-collision demand.
  **Correction IX-l (labelling, no math affected):** §8.23 printed
  `5·c₉(T_c) = (9,10,3,4,2,7)`, correct as labelled but the
  NEGATIVE of the actual targets `η(T_c) = (2,1,8,7,9,4)`; §8.23
  now carries an explicit sign note, since the wrong tuple would
  propagate into any later note or formalization.
  **ENGINE VERDICT (scale test, sparse 3000×4000, 6 nnz/row):**
  PARI is excellent for the F_p layer — rank/kernel/image mod p all
  ~4–5 s — and WRONG for the integral layer: `matker` over Q died
  at 118 s (e_STACKTHREAD, 8 GB), `matkerint` still running at
  600 s, `mathnf` grew the PARI stack 8→16→32→64 GB (43 GB RSS)
  before being killed. So the modular + CRT/rational-reconstruction
  design used by `f55_mixedlevel3.py`/`f55_qpreimage.py` was the
  right one; future heavy work should use PARI for mod-p passes and
  keep the integral layer modular, never dense HNF.**
  **Wave 32 (continuation; probes `f55_witness_dump.py`,
  `f55_verify.jl`): THE MIXED-FAN WITNESS SURVIVES A FULLY
  INDEPENDENT ENGINE (Julia + Oscar/polymake + Nemo) — and the
  positivity claim is upgraded from SAMPLED to EXACT.** The witness
  crossed the engine boundary as convention-free data only (20
  normals; sign-vector → slope; zero-cell sign vectors) — no cell
  indices, orbit numbering, wall list or ray list — and the Julia
  side rebuilt adjacency, rays, the σ-action, the orbit structure
  and the intersection lattice from the definitions. Results, both
  G₉-rank patterns, ZERO failures throughout: (B) all **2570**
  walls have `U − U′ = m·ν` exactly (1400 A₄ / 1170 G₉, adjacency
  recomputed as Hamming-distance 1 on sign vectors) — and since
  that IMPLIES continuity, check (A) is settled exactly rather than
  at samples; (C) own exact ray enumeration gives **460 rays**,
  intersection lattice {1,20,125,230,1}, Zaslavsky chambers
  **1090 = the cell count**, with d ≥ 0 at every ray; **(C2), added
  by the worker: an exact Rational{BigInt} phase-1 simplex
  certificate that `U_C` lies in the cell's dual cone for all 1090
  cells — so `d ≥ 0` holds on ALL of N⊗R exactly, bypassing rays
  and Minkowski–Weyl entirely** (control: `−U_C` in the dual cone
  for 0 of 654 nonzero cells); (D) 1,000,000 lattice points per
  pattern across boxes 5/20/100/1000 — d < 0: 0, twice-min: 0,
  congruence: 0; **(D2), added: the on-wall 27% that (D) discards,
  closed by ±push-off at 200,000 points — 0 disagreements**;
  (E) 218 free σ-orbits, exactly 2 zero cells per orbit, 0 of 436
  zero cells with U ≠ 0. **Oscar/polymake independently built the
  fan as the normal fan of a zonotope (nothing from the JSON
  entering) and returned 460 rays and 1090 maximal cones whose SIGN
  VECTORS EQUAL THE EXPORTED KEYS EXACTLY.** All three negative
  controls fire (perturbed cell: 289 congruence failures; c₉→0:
  46,100; broken jump: non-integral on 4/4 of its walls, 4/2570
  discontinuities, 48 push-off disagreements). Also two-engine
  confirmed by the director's own PARI run: ξ* = (7,4,2,10,3,9),
  rank(E) = 6, twist base 5 by test, covering 0/15625 and
  15625/15625, min-survivors histogram [0,15625,0,0,0,0] (the
  failure is uniformly ONE orbit; best transversal 23 of 24).
  **Correction IX-k therefore rests on three independent engines
  (Python, Julia/Oscar, PARI) plus the director's own check of the
  33-identity; Lemma S is FALSE as a statement about the value-form
  system, and the caveat is unchanged — the value form is what was
  refuted, and F55 itself is untouched.**
  **Wave 32 (continuation; Note IX §8.29 + Correction IX-m, probe
  `f55_f2f3.py`, director-adjudicated by rerun): (F2)/(F3) TESTED —
  AND THE BRAUER LAYER'S INDEX FLIP MAKES (F2) CIRCULAR.** (F2), IF
  VALID, **kills all 14 witnesses AND their entire families**
  (77–78 failures each; family-wide mod-11 systems infeasible 14/14
  under all three b-split readings, every infeasibility with a
  verified Farkas certificate, 44 one-row ones per family;
  hand-checkable: w = (−27,−12,13,13,13) gives ⟨w,c₉⟩ ≡ 0 but
  ⟨w,c⟩ ≡ 8, so (F2) reads 0 ≡ 3). (F3) **kills nothing — it is an
  identity** (0 failures over 14×92; 6/6 perturbations break it, so
  the test is live). **Correction IX-m:** §8.9 uses the COMPONENT
  index (transpose kernel 5ⁱ), §§8.14–8.16 and all code the RAY
  index (9ⁱ); in the pinned convention λ∘ψ = 7λ but L9∘ψ = 0, so
  every "pattern ∈ Im(2+σ̃) ⟹ λ ≡ 0" step (Theorem I(ii) per-orbit,
  Theorem K, §8.13's 33→363, Theorem N) uses a property λ has only
  in the OTHER index. **Consequently Theorem N IS (F2) at the
  boundary — deriving (F2) from it is circular — Theorem O's
  per-ray equation collapses to 0 = 0, and interior (iv′) rests on
  the same step: as written the Brauer layer supplies NO (F2).**
  Also: §8.10's alignment is transposed (L9(e_b) = 7 ≠ 0 so
  (2+σ̃)x = e_b is unsolvable; e_b = (2+σ⁻¹)x with x = (0,2,−3,2,0);
  Theorem P survives with ψ/ψ* interchanged), and Theorem O's
  ℓ_w(b) factor is uniformizer-dependent off ⟨w,e_b⟩ ≡ 0 so the
  strict b-split exemption is EMPTY at the boundary. The work
  order's proposed gate (N ⟺ (3)) was itself FALSE — (3) is
  9-weighted, N is 5-weighted; both were run through one code path,
  the 9-weighted clean 92/92 on 14/14 and FEASIBLE 14/14 as the
  positive control. **STATUS: §8.28 stands about the VALUE-FORM
  system, but whether that defeats the programme now hinges on
  (F2), whose derivation is BROKEN, not disproved. Repairable ⟹ the
  witnesses die and Theorem-Q-YES does not by itself defeat F55-NO;
  unrepairable ⟹ the witnesses stand and the route is dead.
  Deciding is a derivation task (in flight,
  `theory/DRAFT_f2_repair_20260808.md`). F55 and the headline
  UNMOVED either way.**
  **Wave 32 (TERMINAL; Note IX §8.30 + Corrections IX-n/o; probes
  `f55_qpre_nemo.jl`, `f55_f2repair_adjudicate.py`; both
  director-adjudicated by rerun): THE REPAIR PROVABLY FAILS AND THE
  LIFT IS TWO-ENGINE CONFIRMED — THE ARITHMETIC FLANK ENDS.**
  (A) Julia/Nemo, rebuilding the fan from convention-free data
  (1090/2570/218 all matching, σ_* derived, reduction (**) verified
  before use and reported failing loudly first on a wrong
  orientation), solves the full 19780×5232 integer system: soluble
  mod every prime, rank drop only at 11, denominator exactly 11,
  kernel rank 15, saturation PROVED by an integer left inverse;
  certificate = substitution into ALL 19780 rows, 0 violations,
  plus 20,374 pointwise checks. **And the lift can be taken
  CONVEX** — h + 15,241,389·Σ_k g∘σᵏ has 0/2570 convexity
  violations and h = max_C⟨U_h(C),·⟩ at 2421/2421, so **h is the
  support function of an honest lattice polytope**. Both negative
  controls behave. Engine lesson measured: 80 s vs an estimated
  10–30 min/prime in Python. (B) **Correction IX-n — Theorem D
  (eigen-exhaustion, PROVED):** for β in the ε-eigencomponent,
  cores(φ,β) = (2+ε⁻¹)cores(a,β) − cores(r₂,β); if 2+ε⁻¹ is a unit
  the identity merely DEFINES cores(a,β) (why Theorem K and (iv)
  fail), and 2+ε⁻¹ ≡ 0 holds for EXACTLY ONE ε — mod 11 that is
  ε = 5, spanned by c, NOT by e_b (ε = 9, factor 7). Its output is
  exactly Theorem I(ii) and **Theorem R = congruence (3)**. So the
  Brauer layer's ENTIRE output is what §§8.17–8.28 already used:
  **b was the wrong element to pair against, and (F2) is not
  repairable.** Rejected routes recorded (other Kummer elements,
  non-eigen β, unramified⟹zero — the ε=5 class is itself
  boundary-ramified, Gersten, mod-3). Blast radius settled: FAIL =
  K, K′, (iv), the cover loop, N, O's conclusion, (iv′)/(F2);
  CORRECTED = I(ii) (L9≡0), I(iii) (L9(m)≡7), §8.10 alignment,
  P (identity ⟹ F3 vacuous), §8.16's σ-invariant-Q obstruction;
  SURVIVE = H, I(i), J, J.1, L, M, K′(a), K′(b), Q and the whole
  9-weighted line (§8.9's W IS ⟨w,c₉⟩, so §8.9's congruence already
  IS Theorem R). **Correction IX-o:** §8.16's "two distinct
  11-covers" is FALSE — adj(2+σ)e₂ ≡ 8·e_b, one isogeny. Witness
  re-test: the derivable condition holds 1288/1288, (F2) as printed
  206/1288 — the 14 witnesses SURVIVE. **TERMINAL: the corrected
  system collapses to (F1)+(F4) = Theorem Q, which is SATISFIED by
  an explicit lattice polytope on two engines. LEMMA S IS FALSE and
  the value-form route to F55-NO is structurally exhausted, not
  stalled. F55 OPEN, ed_C(PSL₂(F₁₁)) UNDECIDED.** Live lanes =
  handoff §4: exact solves at pinned profiles, rigidity (§8.4.2),
  the YES-side ladder, construction via Theorem I. The V₁₄ theorem
  and every §§8.22–8.25 fan kill are untouched.**
  **Wave 32 (continuation; work-in-progress commit `215e538`, probes
  `director_probes_20260806/f55_exact_lift_*`): HARNESS VALIDATED, MAIN
  COMPUTATION UNDECIDED.** Parser controls pass both ways (unit ideal →
  `[1]`; non-unit → `[xx*yy-1]`); GATE-1 PASS; GATE-2 PASS — the
  free-support NON-EMPTY control at sigma = 7, e = 13, where the
  pentagon-line covers live, reported NON-UNIT independently by M2, Singular
  and msolve (M2 `unit=false ngens=94 dim=4`, Singular `leadone=0 size=94
  dim=4`, msolve `NONUNIT`). The MAIN computation is UNDECIDED: Lemma G
  profiles at sigma = 7, e = 39, count = 3; profile 0 timed out in M2 after
  7200 s; identified bottleneck: a degree-20 Rabinowitsch generator. **NO
  emptiness or non-emptiness claim is made; the run was interrupted by an
  external usage limit, and outputs are gitignored (regenerate by rerunning
  the scripts).** Cross-reference handoff §4 lane (a).
  **Cross-reference (2026-08-08/09 parallel line, independent of waves
  31–32): AN INDEPENDENT PROGRAM LANDS ON THE SAME OPEN VERDICT.** The F55
  audit + polar-circuit reduction + Coverage-C adjudication recorded in the
  supplement above, and the ambient-Rees/selfmap/carrier program of
  `goal_runs_20260809/*` with its packet ledger
  `NOTEBOOK_AMBIENT_REES_SELFMAP_CLASSIFICATION_20260809.md`, reached
  conclusions consistent with the wave-32 terminal state: the old
  Lemma-S/conserved-eleven negative claims are withdrawn by audit on the one
  side, refuted by explicit witnesses on the other, and both lines agree the
  question is OPEN. The ambient-Rees line's own named open targets: the
  refinement-invariant normalized-Rees carrier theorem (named in
  `theory/FIX_I_bcomplex.md`), the finite d = 24 divisibility problem (0 ≠ V
  ∈ K_21, J_23 | F(V)), and the type-I/type-II carrier enumeration with the
  55-configuration synchronization statement. **Its proved boundary: ambient
  landing coordinate degree ≥ 22 and retraction coordinate degree ≥ 24, with
  `NO-DOMINANT-G-AMBIENT-LANDING-MAP` and `KLEIN-PSL2(11)-NONUNIRATIONAL`
  both explicitly NOT PROVED.**
  **Director adjudication (2026-08-10): TWO PROPOSED THEOREM TARGETS CHECKED
  AGAINST THE REPO — NEITHER IS A NEW REDUCTION.** (i) A "bounded-circuit
  theorem for F55" is Coverage Theorem C territory, already adjudicated
  `F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE` (see the supplement entry
  above) — rejected as a reduction; the noncircular residue is the
  adjudication's own routes (1)–(3) (a proved universal circuit list; a
  finite-generation theorem for primitive cores; a direct
  arithmetic/geometric obstruction to the trace cubic). (ii) A
  "coordinate-minimal Rees reduction lemma" is, nearly verbatim, the
  ambient-Rees line's own named gap, not a new discovery; as stated it names
  the summit, not a step toward it. The viable next theorems are that line's
  own two smallest-remaining targets: the d = 24 finite divisibility
  problem, and the carrier enumeration plus 55-configuration synchronization
  statement. **Recorded so future proposals are checked against these
  adjudications before development.**
  **Wave 32 (status corrections, 2026-08-10).** (i) THE d = 6 LADDER
  RUNG IS STOPPED, NOT FINISHED: the M2 run (`f55land_d6_s0..s4.m2`)
  was killed mid-flight during the 2026-08-08 usage interruption
  after ~45 h CPU on s0, left NO output files, and was never
  restarted; the "d = 6 running / in flight" phrases in the wave-30
  entries above and in Note IX §8.8 are stale as of this note. Per
  the stop-rule's own bookkeeping the rung is recorded
  stopped-not-finished; no verdict at d = 6 exists, and under the
  2026-08-10 allocation decision (no further effort on the positive
  side) it stays parked unless deliberately reopened. (ii)
  ADJUDICATION OF THE SCAVIA MECHANISM (extraction, director
  spot-checked): Scavia's non-versality proof is a bare
  essential-dimension bound — (C₇⋊C₃)×C₂ has no faithful 2-dim
  complex representation (the σρσ⁻¹ = ρ⁴ relation forces three
  distinct ρ-eigenvalues), so ed = 3 > 2 = dim S — NOT a computable
  obstruction class on S. Consequence: the refutation of Conjecture
  8.8 exports NO transportable machinery; the analogous move for the
  Klein cubic ("prove ed > 3 by pure group theory") IS the headline,
  not a tool. E49's verdict (conditional route vacated) stands
  unchanged; no "Scavia-type obstruction evaluation on the Klein
  twist" exists as a task, and any proposal so phrased should be
  rejected as shapeless. (iii) VERIFICATION DEBT (Beauville Sylow
  fixed points on the Klein cubic, the input to D-R Cor 10.6): in
  NOTEBOOK + theory/, Sylow-2 (V₄: six points) is independently
  derived and packet-certified; Sylow-3 is cited from CTZ, not
  re-derived; Sylow-11 is consistent-but-not-shown-in-place;
  **Sylow-5 has no in-repo record at all**; FIX_VIII's parenthetical
  "our vertex/eigenpoint checks reproduce this" carries no script
  pointer. Recorded as debt, not as doubt.** Note I
  (`theory/FIX_I_bcomplex.md`) drafted: definitions (decorated complex,
  Def 1.1), blowup calculus (Thm 2.1, checked against the classical
  dimension-2 weight calculus), b-complex over `Mod_G(X)` with equivariant
  weak factorization as the computability bridge (Prop 3.3),
  graph-is-a-model functoriality (Obs 4.0, Thm 4.1) with endomorphism
  stability by construction, rational-chain going-down proved (Lemma 4.2 —
  retiring the session-asserted principle), RCC propagation (Lemma 4.3),
  and the linear-source funnel (Cor 4.4: for `X = P(W)` every fixed stratum
  of every **stabilizer-stratified** model is RCC, so all genus-≥1 target
  strata receive only points from such strata — conditional on FIX-A0, the
  whole source complex funnels into the 55-line arrangement, Cor 5.2;
  **scope-corrected 2026-08-05 by Correction I-C** — the original "every
  model" quantifier is false, see the E56 status entry for the Duncan-notes
  event that exposed it). Acceptance gate T1–T5 (§6): derive the
  surface chains-to-chains picture unprompted; re-derive the Problem-F dP,
  OD16, and Fermat-cubic closures; certify non-overreach against the V4
  trisection family. **Nothing here is consumable for headline routing
  until the gate passes.**
- **What was actually established** (refreshed 2026-08-06, wave 28): Note I
  calculus (Thm 2.1, Thm 4.1, Lemmas 4.2/4.3, Cor 4.4 as scope-corrected by
  I-C); the T-gate closures (Problem-F re-derivation T2.3; central
  obstruction T3.1 with FIX-T34's class-corrected OD16/Fermat instances);
  the profile/equalizer/cell theory and the FIX-D2 terminal verdict on the
  localized negative; the Note VI Prym split; the Note VIII projection
  move, index 1, D12-unirationality (independent proof of a CTZ instance),
  MOVES census; **Note IX: the V₁₄ model, triage, and the SEALED
  Cor IX.1/IX.2 — the V₁₄ action is not G-unirational and
  `ed_C(G) = 3 ⟺ Klein G-unirational` (headline single-target; the first
  sealed unconditional theorem of the program with direct headline
  content)**; the transport lattice IX.3–IX.5, D12-shadow IX.6, odd-order
  transfer IX.7 (V₁₄ C₃-unirational; F55 = a transferable sufficient
  negative target). Headline itself: STILL OPEN, both directions.
- **Aliases:** FIX; "fixed-locus calculus"; the program-4 head-on attack
- **Provenance:** `theory/FIX_I_bcomplex.md` … `FIX_IX_v14.md` (Notes
  I–IX) and `theory/FIX_T_gate.md`, `theory/FIX_H1_coupling.md`.
  Foundation packets FIX-A0/A1 (dispatched and LANDED 2026-08-04,
  director-replayed: `(3,2)` split from `χ_W(2A)=1`, `X^σ = E_t ⊔ L_t`,
  `j(E_t)`, normal types `(−1)^{⊕2}`, `C_G(σ) ≅ D12`;
  `W|_{V4} = triv² ⊕ χ₁ ⊕ χ₂ ⊕ χ₃`; incidence repair); then A2, T34, H0,
  H1(+C/D corrections), N2/N2b/N2c, C1, C5, D2, P1/P2, L1, GATE, VII-LAND,
  VIII-MOVES, IX-SEAL under their `goal_runs_after_*` dirs, each with its
  verifier; in-flight: FIX-VIII-A5LADDER, FIX-IX-V14MODEL.
- **Pointers:** `theory/FIX_*.md` (nine notes + T-gate); [E14](#e14),
  [E15](#e15), [E33](#e33), [E34](#e34) (the shadows); Verification debt
  items 21–22; `HANDOFF_2026-08-06.md` (snapshot predating waves 25–28 —
  see its banner).
- *Opened by the director 2026-08-04; the collaborator's surface
  observation is deliberately not ingested — test T1 must reproduce it
  independently.*

---
