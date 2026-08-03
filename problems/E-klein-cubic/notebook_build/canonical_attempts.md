# Problem E (Klein cubic, PSL(2,11)-equivariant unirationality) — Canonical Attempt Ledger

> **FROZEN — PRE-ADJUDICATION MERGE (2026-08-03).** This file is the
> seven-lens merge as synthesized BEFORE the 2026-08-03 review rounds. It
> retains superseded content — E03 "uncharacterized", E25 "inherited
> unverified", the static precedence rule, pre-demotion G3H/G3D readings, and
> the E28 "exit label only" account. Do not regenerate the notebook from this
> file. Current state: `NOTEBOOK.md` (adjudicated) and
> `notebook_build/manifest.json` (machine-readable).

Merged from seven independent lens reports in `tmp/notebook_build/`:
`lens_directories.md`, `lens_gitlog.md`, `lens_certificates.md`, `lens_handoff.md`,
`lens_resolution_spec.md`, `lens_status_docs.md`, `lens_workorders.md`.

Lens abbreviations used in the `lenses` field:
**DIR** = directories, **GIT** = gitlog, **CERT** = certificates, **HAND** = handoff,
**RES** = resolution_spec, **STAT** = status_docs, **WORK** = workorders.

All paths are relative to `/Users/worker/unirational/problems/E-klein-cubic/`.

**Evidence-precedence rule applied throughout** (per director instruction 4c):
`PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md` was produced by an offline ChatGPT session.
Where it conflicts with run-level `STATUS.md` artifacts or with `REPAIR.md`, the
run-level artifact and `REPAIR.md` outrank it; the ledger label is still recorded
verbatim and the disagreement is preserved in a `conflict` field.

Total entries: **55**.

---

## 1. A — Path A: Schur–Krylov degree-55 field algebra / P¹-reduction / index-34 duality

- **aliases:** Path A; A1/A2/A3 gates; `A_EMPTY` / `A_EMPTY_UNDECIDED`; HAND `R13`; RES `RES-27`; CERT bucket `A — A, A-DEG19`; WORK folds this into `S19-Krylov` (Attempt 3 / Path A Krylov / Route S19)
- **tries:** positive construction — install an executable degree-55 field-algebra / marked-point interface (monogenic schema `B_34(τ,V_Z)`, rank-55 maximal-minor matrix, "index-34 duality", a `P¹`-reduction theorem) on the generic Schur twist, yielding an algebra-code pair `(L,V_Z)` from which a rational point / landing construction could be extracted.
- **method:** mixed (CAS elimination + structural algebra)
- **status_labels:**
  - PRE-REPAIR: "some 55×55 minor is nonzero at every primitive tau" (single global minor claim); A2 packet described as having installed "exact generic coordinates" [STAT, from REPAIR.md §9–10]
  - POST-REPAIR: quantifier corrected to `∀τ ∃M_τ: M_τ(τ)≠0`, i.e. the ideal of **all** maximal minors, `V(I_55(B_34))∩U_primitive=∅` [STAT/REPAIR.md §9]
  - POST-REPAIR: "Path A executable L,V_Z claim — downgraded to an abstract interface" [HAND R13, RES RES-27]
  - POST-REPAIR retained: "Path A P¹-reduction — retained"; "Path A index-34 duality — retained" [HAND R13, RES RES-27, STAT]
  - "A2 downgraded to abstract degree-55 algebra and marked-evaluation interface installed; exact executable marked algebra-code pair (L,V_Z) **not installed** — superseded by packet `A_EMPTY_UNDECIDED`" [STAT/REPAIR.md §10]
  - GIT: `9bee33a` 2026-07-31 "Path A statement A_empty"; `3c9b385` 2026-07-31 "A_empty attack — exit A_EMPTY_UNDECIDED"; `cdc016b` 2026-07-30 "Path A Gates A1-A3 — A1 PASS"; `4baad2f` 2026-07-30 "Path A collapse audit — no lossless collapse"
  - WORK: "Path A is computationally stopped in its current form... No memory increase changes that"; "Do not restart primitive-element/Krylov elimination"
- **current_state:** UNDECIDED-STOPPED — the P¹-reduction and index-34 duality survive the repair; the executable `(L,V_Z)` extraction is only an abstract interface and the direct 52-variable Krylov elimination is computationally retired.
- **runs:** A1–A3 gates (`cdc016b`); Path A collapse audit (`4baad2f`); A2 packet; `A_EMPTY` / `A_EMPTY_UNDECIDED`; `orbit_code`, `field_algebra`, `marked_point`, `krylov_incidence`, `structural_collapse`, `vz_power_basis`, `P1_REDUCTION` (all under `certificates/schur_krylov/`); Path A A0–A4 low-degree block-Krylov growth theorem (POST_ELO, after elimination retired)
- **sources:** `REPAIR.md` §§9–10, §§15–17; `certificates/schur_krylov/`; `HANDOFF.md` 2026-07-31 theorem-boundary repair tables; `RESOLUTION.md` / `SPEC.md` repair tables; `WORKORDER_ELO_TEN_PATHS.md` (Path A, ranked #1); `WORKORDER_POST_ELO_CONSTRUCTION.md` (Path A, A0–A4); `CURRENT_PATHS.md`
- **lenses:** GIT, CERT, HAND, RES, STAT, WORK (6/7)
- **confidence:** high
- **possibly-same-as:** entry 30 (S19). CERT and WORK both group `schur_krylov` + `schur_degree19` / "Path A Krylov / Route S19" as one programme; DIR and GIT keep `S19_MARKED_CURVE` and `PathA` distinct. Kept separate per the repo's own distinct route letters; see identity questions.

---

## 2. A0 — Canonical audit / CAS baseline

- **aliases:** `A0_CANONICAL_AUDIT`; "canonical audit of projection bulk"; `HEADLINE_CAS_BASELINE_ACCEPT` (link inferred); CERT `headline_cas_order`
- **tries:** infrastructure — certify the baseline exact 660-element `PSL(2,11)` action, Klein-cubic invariance, and the "projection bulk 4140/315" figures as a replayable checked-in certificate package; verify authoritative P25 nonmembership counts and canonical state.
- **method:** CAS
- **status_labels:**
  - `A0-CANONICAL-AUDIT-PASS` [DIR, run `STATUS.md` in `goal_runs_after_35fa/A0_CANONICAL_AUDIT`; also WORK/`REMAINING_GOALS_NOTE.md`]
  - "TERMINAL PASS — Projection bulk data certified (4140/315) — Infrastructure only" [STAT, `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`]
  - "already terminal, not an open mission" [WORK]
  - `HEADLINE_CAS_BASELINE_ACCEPT` marker, "distinguished from mathematical verification" [STAT/REPAIR.md §0]
- **current_state:** TERMINAL-PASS (infrastructure only; not a mathematical route).
- **runs:** `goal_runs_after_35fa/A0_CANONICAL_AUDIT`
- **sources:** `goal_runs_after_35fa/A0_CANONICAL_AUDIT/STATUS.md`; `REMAINING_GOALS_NOTE.md`; `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`; `REPAIR.md` §0; `certificates/headline_cas_order/`; `README.md`
- **lenses:** DIR, STAT, WORK, CERT (4/7)
- **confidence:** certain

---

## 3. A1-AUD — Path A audit packet

- **aliases:** CERT `AUD — AUD-A1`; `certificates/audit_a1`; possibly GIT `78abba4` "audit theorem-boundary" / `cdc016b` "Path A Gates A1-A3 — A1 PASS"
- **tries:** infrastructure/audit — an audit packet recording findings for Path A (`AUDIT_FINDINGS.md`, `audit_findings.json`).
- **method:** CAS/document audit
- **status_labels:** none verbatim; CERT records only file inventory (`audit_a1/AUDIT_FINDINGS.md`, `README.md`, `audit_findings.json`) [CERT, "confidence: inferred-from-name"]
- **current_state:** INFRASTRUCTURE — audit artifact; contents not characterized by any lens.
- **runs:** `certificates/audit_a1/`
- **sources:** `certificates/audit_a1/AUDIT_FINDINGS.md`
- **lenses:** CERT (1/7) — **single-lens**
- **confidence:** low
- **possibly-same-as:** entry 55 (REPAIR, theorem-boundary audit) and/or the Path A `A1 PASS` gate of entry 1. Two candidate parents; no lens disambiguates.

---

## 4. A5Q — A5 index-11 point transfer / degree-4 quartic rescue

- **aliases:** `A5Q_QUARTIC_RESCUE`, `A5Q_QUARTIC_RESCUE_old`; `G4_A5_INDEX11_TRANSFER`; `G4A_INDUCTION_PROJECTORS`; WORK `G4/A5Q`; GIT `A5`; STAT reads "A5Q" as "A5-quadric branch (KLS)"
- **tries:** positive construction — transport the exact degree-11 closed points obtained from the A5 subgroup twists into a genuine PSL(2,11) projective generic-twist point, via induced-representation/coset projectors and a field-descent argument; then test whether the degree-11 closed point on the full generic twist lies on a descended rational normal quartic in `P⁴` (meeting the cubic in degree 12, leaving a rational residual point).
- **method:** CAS
- **status_labels:**
  - `A5Q-INDEX11-CLOSED-POINT-PASS`; `A5Q-DEGREE4-RESCUE-EMPTY-SCOPED` [DIR, run `STATUS.md`]
  - `G4-INDUCED-DEGREE11-POINT-PASS` [DIR, `goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/STATUS.md`]
  - "A high-risk but finite new positive route" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §4 Rank6]; "Need: compatibility of subgroup embeddings; field descent argument"; "not yet run" [WORK, `GOALS_NEXT_10_ROUTES_2026-08-02.md` #4]
  - GIT: `83d35f7` 2026-08-01 "index-11 quartic rescue goal"; `30cccfa` 2026-08-02 "index-11 transfer goal"
  - Bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger, under its "A5Q" reading]
- **conflict:** STAT reads "A5Q" as "A5-quadric branch (KLS)" (explicitly flagged there as inferred, "no document explicitly writes out A5Q as an expansion") and therefore assigns it the KLS A5-quadric closure status. DIR + WORK + GIT agree A5Q = "A5 quartic rescue / index-11 transfer". Two-lens rule resolves in favour of quartic rescue; the KLS A5-quadric branch is a genuinely distinct object and is recorded inside entry 22.
- **current_state:** PARTIAL — index-11 closed point installed (PASS); the degree-4 quartic rescue is empty in the scoped range; transfer to a full G-point not achieved.
- **runs:** `goal_runs_after_bd610a/A5Q_QUARTIC_RESCUE`, `.../A5Q_QUARTIC_RESCUE_old`, `goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER`, `goal_runs_after_141f60/G4A_INDUCTION_PROJECTORS`
- **sources:** the four run dirs above (+ their `STATUS.md`); `GOALS_NEXT_10_ROUTES_2026-08-02.md` #4; `DIRECTOR_REVIEW_AFTER_BD610A.md` §4
- **lenses:** DIR, GIT, WORK, STAT (4/7)
- **confidence:** high (identity as quartic rescue); STAT's alternative reading recorded as conflict.

---

## 5. Attempt1–5 — Five-attempts dispatch wave

- **aliases:** `WORKORDER_FIVE_ATTEMPTS.md`; GIT `Attempt1`, `Attempt2`, `Attempt3`, `Attempt5`; exits `STOP-1`..`STOP-3`, `FAIL-SCOPE`, `P1`, `P1-CONDITIONAL`, `N1-SCOPED`
- **tries:** infrastructure/dispatch — a five-way competitive dispatch (2026-07-30) that gated five routes in parallel. Mapping: **Attempt 1** = Pfaffian–Morita idempotent (→ entry 26/7); **Attempt 2** = T fold-algebra/target branch (→ entry 32); **Attempt 3** = S19 degree-19 rescue curve (→ entry 30); **Attempt 4** = KLS minimality-conductor (→ entry 22); **Attempt 5** = G global lifting (→ entry 16).
- **method:** mixed (dispatch/process)
- **status_labels:**
  - `1c07871` 2026-07-30 "Attempt 1 Gates 1-2 — FAIL-SCOPE on the bridge" [GIT]
  - `FAIL-SCOPE`: "idempotent gives a point of auxiliary P^2_D, not of F_{14,T}" [WORK, `WORKORDER_ELO_TEN_PATHS.md` §1]
  - `b7be961` 2026-07-30 "Attempt 2 Gate 1 — STOP-2 at measured 9.4 GB"; `a5b3d66` "option (c) — degree-43 factor reconstructed" [GIT]
  - `83d2b10` 2026-07-30 "Attempt 3 Gates 1-2 — implication chain PASSES, exit STOP-3" [GIT]; "implication chain PASS; both Rao branches remain live; STOP-3" [WORK]
  - `dddb743` 2026-07-30 "Attempt 5 Gate 1 — global state image formulated, containment UNDECIDED" [GIT]
- **current_state:** COMPLETED-WAVE — all five attempts exited at scope/resource stops; the wave itself is closed and its content lives in the successor route entries.
- **runs:** Attempt 1 gates 1B/1C/1D; Attempt 2 gate 1 + option (c); Attempt 3 gates 3B–3D; Attempt 4 gates 4B–4D; Attempt 5 gate 1; `certificates/GATE_REPORT_FIVE_ATTEMPTS_1.md`
- **sources:** `WORKORDER_FIVE_ATTEMPTS.md`; `certificates/GATE_REPORT_FIVE_ATTEMPTS_1.md`; git `1c07871`, `b7be961`, `a5b3d66`, `83d2b10`, `dddb743`
- **lenses:** GIT, WORK (2/7)
- **confidence:** certain (wave existence and mapping; Attempt1↔Pfaffian–Morita confirmed by the shared verbatim `FAIL-SCOPE`/bridge language across GIT and WORK). Attempt 4 is not visible in GIT.

---

## 6. B — Fixed-frame exhaustiveness bridge

- **aliases:** `B_FIXED_FRAME_BRIDGE`, `B_FIXED_FRAME_EXHAUSTIVENESS_20260802`; "fixed-frame bridge"; HAND `R11` (Pfaffian fixed-frame D5/target-branch point-search programme); RES `RES-08` (minimal fixed-frame triple (0,1,2)); CERT bucket `B — B-GLOBAL, B-MOD3, B-T10` (`target_branch_*`) — alias uncertain, see conflict
- **tries:** negative obstruction — descend the full Klein-twist problem to the fixed four-parameter frame `F=C(A,B,Y,Z)`, build the depressed genus-one/ternary cubic `u³+u(q₀v²+q₁vw+q₂w²)+r₀v³+…=0` over `K_proj`, prove it pointless, and then argue the fixed projector slice is **exhaustive** in the full Fano/projector variety so that fixed-frame pointlessness certifies non-unirationality.
- **method:** mixed (exact CAS + arithmetic geometry)
- **status_labels:**
  - `B-UNDECIDED` [DIR, `goal_runs_after_35fa/B_FIXED_FRAME_BRIDGE/STATUS.md`]
  - `B-BRIDGE-REFUTED` [DIR, `goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/STATUS.md`; WORK, `REMAINING_GOALS_NOTE.md`]
  - "TERMINAL NEGATIVE (B-BRIDGE-REFUTED) — Fixed-frame bridge is false; cannot certify non-unirationality — Warns against overusing frame reductions" [STAT, 08-02 ledger]
  - "Pointlessness of the fixed-frame ternary cubic does not transfer to the generic Klein twist... the fixed projector slice is not exhaustive in the full Fano/projector variety" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §1, §2.3]
  - 2026-07-30 (pre-refutation): presented as the **leading active route**, with "D5 residue gate closed positively", sextic discriminant factorization, exact sparse-BKK `[K_proj:F]=6`, monodromy `S6`/`A6` [STAT, `CURRENT_PATHS.md` lines 91–333]
  - "D5 is soluble and is retired as an obstruction"; "ind(C/F)=3, C(F)=∅"; "[K_proj:F]=6"; "the present certificates do not decide global projective small resolvability or the final class-group obstruction"; "Verdict remains OPEN" [HAND R11]
  - "The main question is again... The answer remains OPEN"; "f5=0 is also locally soluble and retired"; "The residual point itself fails globally by B*rB(t1)!=0... A point with varying direction is not excluded" [RES RES-08]
- **conflict (preserved, instruction 4b):** status reverses across dates — **leading route** on 2026-07-30 (`CURRENT_PATHS.md`) vs **`B-BRIDGE-REFUTED`** on 2026-08-02 (run `STATUS.md` + `REMAINING_GOALS_NOTE.md` + 08-02 ledger). Here the 08-02 verdict is corroborated by a run-level `STATUS.md` and by `REMAINING_GOALS_NOTE.md`, so it is not merely the offline-ledger claim; the reversal is real, not a document artifact.
- **conflict (identity):** CERT assigns `certificates/target_branch_global`, `target_branch_mod3`, `target_branch_t10` to "B". But `target_branch_t10` carries `exit_t10.json` and matches GIT's T10 work order (`1d3fe3b`), and HAND R11/R12 attach "target branch" to Path T. Not merged; recorded under both entry 6 and entry 32.
- **current_state:** TERMINAL-NEGATIVE (as a bridge) — the exhaustiveness bridge is refuted; the fixed-frame arithmetic itself (index 3, `[K_proj:F]=6`, `S6`/`A6` monodromy, D5/f5 retired) survives as scoped fact and is now non-headline.
- **runs:** `goal_runs_after_35fa/B_FIXED_FRAME_BRIDGE`; `goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802`; D5 residue gate / target-branch incidence; resolved-branch incidence (upstairs critical determinant, degree 37); positive conic/algebra test (`P5(F)`); twelve-point nonnormal singularity gate; residual `E[3]`/Kummer computation on `F0=C(A,Y,Z)`; `tmp/pfaffian_d5_constant_point`, `tmp/pfaffian_d5_residual_attack`, `tmp/full_scaled_frame_degree_attack`, `tmp/pfaffian_six_sheet_branch_obstruction`, `tmp/target_branch_delta_saturated_singularity/`
- **sources:** the two `goal_runs_after_35fa/B_*` dirs; `CURRENT_PATHS.md` lines 91–333; `REMAINING_GOALS_NOTE.md`; `DIRECTOR_REVIEW_AFTER_BD610A.md` §1/§2.3; `HANDOFF.md` "2026-07-30 latest Pfaffian closure"; `RESOLUTION.md` "2026-07-30 latest fixed-frame result"; `certificates/target_branch_*` (contested)
- **lenses:** DIR, CERT, HAND, RES, STAT, WORK (6/7)
- **confidence:** certain

---

## 7. C0–C3 — Direct twisted Fano section (quaternion / Hermitian common isotropic line)

- **aliases:** Route C; Path C; Tracks C0, C1, C2, C2.1, C3; SPEC task **E4**; RES `RES-07` (Pfaffian Hermitian gate); CERT bucket `C — C0, C1, C2, C2.1, C3` (`fano_interface_c0`, `fano_c1`, `fano_c2`, `fano_c2_1`, `fano_c3`); GIT `C0`, `C1`, `C2`, `C3`
- **tries:** positive construction — install an executable model of the descended central simple algebra `A_proj` (quaternion corner `D=eAe`, five Hermitian matrices `h₁..h₅ ∈ Herm₃(D)`), independently construct restricted Plücker / rank-one equations for `F_{14,T}`, and search (fibration / multisection / direct solve) for a common isotropic right `D`-line, i.e. a `K_proj`-point of `F_{14,T}` (⇒ `BR-FANO-POS`).
- **method:** CAS (exact linear algebra over cyclotomic / multiprime, msolve/M2)
- **status_labels:**
  - `C0-UNDECIDED — verified`; "no executable Fano model; needs `A_proj` descent → Morita symbol" [WORK, `DIRECTOR_HANDOFF.md` §8]
  - "Two clean negatives... no such mechanism exists geometrically... No model installed" [WORK, `DIRECTOR_HANDOFF.md` §8]
  - `1ad97cf` 2026-07-31 "V2 Track C0 — C0-UNDECIDED" [GIT]
  - `3f71710` 2026-07-31 "C1.1 preflight — C1-UNDECIDED, floor named at char-0" [GIT]
  - `d769885` 2026-07-31 "C2.0 — two-generator word basis sealed"; `4da9f8f` "C2.1 — partial constants sealed" [GIT]
  - `0cf23e5` 2026-07-31 "C3.0 — rectangular basis installed" [GIT]
  - Sub-installation exits `C0-MODEL-PASS`/`C1-MODEL-PASS`/`C2-FANO-MODEL`/`C3-FANO-MODEL-PASS`, `C2-TWO-GENERATORS-MODULAR`, `C3-RECTANGULAR-BASIS-MODULAR`; target exit `C-POSITIVE`/`C-FANO-POINT` **not reached** [WORK]
  - "every individual Hermitian member is isotropic... only simultaneous common-line isotropy remains open"; "no explicit K_proj coordinates, quaternion corner, or common isotropic line are known" [RES RES-07]
- **current_state:** OPEN-UNDECIDED — model installation advanced through C3 (bases sealed, modular only); the common-isotropic-line solve is not reached, char-0 transfer not made.
- **runs:** C1/C2/C3 (CAS_HEADLINE, REVISED); C0.1–C0.2 (`WORKORDER_CAS_AFTER_5E72D8E.md`); C1.1–C1.2 (`WORKORDER_CAS_T9_P25Z.md`); C2.0–C2.3 (`WORKORDER_CAS_T10_P25W_C2.md`); C3.0–C3.3 (`WORKORDER_CAS_T11_P25V_C3.md`); certificate dirs `certificates/fano_interface_c0` (incl. `DIRECTOR_CORRECTION_C0.md`), `fano_c1`, `fano_c2`, `fano_c2_1`, `fano_c3`
- **sources:** `WORKORDER_CAS_HEADLINE.md` §6; `WORKORDER_CAS_HEADLINE_REVISED.md` §5; `WORKORDER_CAS_DECISION_AFTER_7FDBE42.md`/`_V2.md` §4; `WORKORDER_CAS_AFTER_5E72D8E.md` §5; `WORKORDER_CAS_T9_P25Z.md` §5; `WORKORDER_CAS_T10_P25W_C2.md` §5; `WORKORDER_CAS_T11_P25V_C3.md` §5; `DIRECTOR_HANDOFF.md`; `RESOLUTION.md` "2026-07-30 audited advances" item 3; `SPEC.md` task E4
- **lenses:** GIT, CERT, RES, WORK (+HAND via R9 quaternionic reduction) (5/7)
- **confidence:** certain
- **possibly-same-as:** entry 8 (C5/C6). See identity questions.

---

## 8. C5/C6 — Corrected Palatini / Plücker common-line big cell

- **aliases:** `C5_PROJECTOR_INCIDENCE`, `C5_MULTIPRIME_20260802`, `C5_NEXT_GATE_20260802`, `C6_PALATINI_BIG_CELL`; `GOAL_C6_PALATINI_BIG_CELL.md`; STAT "C5/C6 common-line Fano"; GIT `C6` (`1b764bf`)
- **tries:** positive construction, corrected alternative to Route C's quaternion encoding — represent the common isotropic right line directly via a self-adjoint reduced-rank-two idempotent `e` in the exact lazy algebra with involution (`e²=e`, `σ(e)=e`, `Trd(e)=2`, `eSᵢe=0` for i=1..5), using a corrected alternating-form / Plücker / square-zero common-line incidence model (retiring the earlier inconsistent encoding `e·S₀·e=0`); C6 then lifts split points to constant-line or positive-degree sections via Morita descent on a Palatini determinantal big cell.
- **method:** CAS (multiprime + determinantal/Plücker elimination)
- **status_labels:**
  - `C5-UNDECIDED` [DIR, run `STATUS.md`; WORK, `REMAINING_GOALS_NOTE.md`]
  - `C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS`; `C6-POSITIVE-DEGREE-RESIDUAL` [DIR, `goal_runs_after_141f60/C6_PALATINI_BIG_CELL/STATUS.md`]
  - "Rank 1 ... the strongest live positive route ... All ingredients except the final full incidence solve are already available. An exact point executes BR-FANO-POS and closes the headline positively" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §4 Rank1]
  - Supersession note: "C5 idempotent e*S_0*e=0 | Plücker/alternating-form model → C6" [WORK, `REMAINING_GOALS_NOTE.md`]
  - "OPEN — Corrected Plucker/alternating model survives — Possible geometric construction/refutation" [STAT, 08-02 ledger]
  - `1b764bf` 2026-08-02 "add C6 determinantal Fano goal" [GIT]
- **current_state:** OPEN — highest-ranked live positive route as of 2026-08-02; C6 birational determinantal model PASSES, residual is the positive-degree section lift; the full incidence solve is not executed.
- **runs:** `goal_runs_after_bd610a/C5_PROJECTOR_INCIDENCE`, `.../C5_MULTIPRIME_20260802`, `.../C5_NEXT_GATE_20260802`; `goal_runs_after_141f60/C6_PALATINI_BIG_CELL`
- **sources:** the four run dirs above; `REMAINING_GOALS_NOTE.md`; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #3; `DIRECTOR_REVIEW_AFTER_BD610A.md` §4; `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`
- **lenses:** DIR, GIT, STAT, WORK (4/7)
- **confidence:** certain
- **possibly-same-as:** entry 7 (C0–C3) — same target (`K_proj`-point of `F_{14,T}` via a common isotropic `D`-line), different and explicitly *corrected* model. WORK is the only lens that states the supersession; kept separate.

---

## 9. COV — degree-31/35 m=1 covariant landing modules

- **aliases:** `COV_M1_DEG31_35`; STAT "COV — m=1 charts"; `tmp/covariant_arrangement_module`; `tmp/m1_*`
- **tries:** positive/negative bounded-degree — decide the plane-order-one (`m=1`) covariant landing modules `[(I^(m)/I^(m+2))_d ⊗ W]^G` in degrees 31 and 35 (and their based/nonbased C3/C6 linear gates), coupled to degree 25 by invariant multiplication; sibling of P25 at higher degree.
- **method:** CAS (modular / multiprime)
- **status_labels:**
  - `COV-UNDECIDED` [DIR, run `STATUS.md`; WORK, `REMAINING_GOALS_NOTE.md`]
  - "148 residual charts; modular [1] ≠ char-0 transfer" [WORK, `REMAINING_GOALS_NOTE.md`]
  - "Degrees 31 and 35 still require saturation of their based and nonbased C3/C6 charts and are coupled to degree 25 by invariant multiplication" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §2.6]; "the degree-35 zero linear quotient is not a degree-wide emptiness theorem" [§1 item 6]
  - "OPEN/DEFERRED — Modular information only — Needs characteristic-zero transfer" [STAT, 08-02 ledger]
  - `[(T_1)_d⊗W]^G = 0` through degree 34 and for degree ≥164, but **dimension 1 at degree 35** in the split-`F_67` fibre — "this does not lift to characteristic zero" [STAT, `CURRENT_PATHS.md`]
- **current_state:** OPEN/DEFERRED — modular results only; char-0 transfer is the blocking gap (the degree-35 one-dimensional `T₁` residue is precisely what refutes the all-degree colon shortcut, see entry 16).
- **runs:** `goal_runs_after_35fa/COV_M1_DEG31_35`; `tmp/m1_t1_saturation`, `tmp/m1_t1_f3_colon_attack`, `tmp/m1_t1_f3_colon_degree35_audit`, `tmp/m1_t1_char0_d35_gate`, `tmp/covariant_arrangement_module/verify_all.py`
- **sources:** `goal_runs_after_35fa/COV_M1_DEG31_35/STATUS.md`; `REMAINING_GOALS_NOTE.md`; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #10; `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 5, §2.6; `CURRENT_PATHS.md` 2026-07-29 item 9
- **lenses:** DIR, STAT, WORK (3/7)
- **confidence:** certain

---

## 10. D/D2 — Equivariant motive / stack-invariant obstruction

- **aliases:** Goal D; Path D (Elo ten paths, ranked #9); `D2_STACK_INVARIANT`; GIT `D` (`fc4e490`, `e1fc474`)
- **tries:** negative obstruction — find a mixed-prime additive or nonadditive **stack invariant** (equivariant motive / equivariant Burnside-style) that bounds the dimension of any compression, i.e. forces `ed_C(G)=4`.
- **method:** analytic (with CAS character/representation screens)
- **status_labels:**
  - `D2-NO-VALID-BRIDGE` [DIR, `goal_runs_after_35fa/D2_STACK_INVARIANT/STATUS.md`]
  - `fc4e490` 2026-08-01 "Resolve Goal D equivariant motive route"; `e1fc474` 2026-08-01 "Record Goal D artifact commit and seal" [GIT]
  - "The unrestricted equivariant motive/Hodge invariant is too flexible: admissible blowup centres can reproduce the required summand" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 2]
  - Decision exits `N-D`, `D-NARROW`, `D-STOP` — none resolved [WORK, `WORKORDER_ELO_TEN_PATHS.md`]
  - Bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger; STAT itself notes "content entirely unknown from this lens"]
- **current_state:** TERMINAL-NEGATIVE-FOR-THE-ROUTE — no valid bridge from the stack invariant to a dimension bound; the unrestricted motive/Hodge invariant is too flexible to obstruct.
- **runs:** `goal_runs_after_35fa/D2_STACK_INVARIANT`; Path D D1 (repair split-injection proof, install period lattice / CM order / polarization), D2 (geometric channel screen)
- **sources:** `goal_runs_after_35fa/D2_STACK_INVARIANT/STATUS.md`; `WORKORDER_ELO_TEN_PATHS.md` (Path D); `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 2; git `fc4e490`, `e1fc474`
- **lenses:** DIR, GIT, STAT, WORK (4/7)
- **confidence:** high
- **possibly-same-as:** entry 19 (Hodge-center). WORK merges WP-H1 (Hodge-center) with Path D as one entry; DIR/STAT/RES/HAND keep the Hodge-center split-injection theorem separate. Kept separate.

---

## 11. E / H2 / H3 — Proper-subgroup generic twists (A4, both A5 classes)

- **aliases:** Path E (Elo #8); Goal H / "Route H" (`WORKORDER_CAS_HEADLINE.md` §9); `H_A4_TWIST/H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801`; `H_A5_TWISTS`; GIT `A4`, `A5`, `H` (`2301a43` "resolve Goal H subgroup-twist sweep")
- **tries:** negative-first strategy — since `X` G-unirational ⇒ `H`-unirational for every `H≤G`, test one maximal-subgroup class at a time for a **pointless** generic `H`-twist (⇒ `BR-SUBGROUP-NEG`). Outcome was positive instead: exact rational points were constructed on the generic `A4` twist and on **both** maximal `A5`-class generic twists.
- **method:** CAS (exact cyclotomic + Reynolds covariants)
- **status_labels:**
  - `H-A4-RATIONAL-POINT`, `H-A4-STRUCTURAL-MODEL-PASS` [DIR, `goal_runs_after_35fa/H_A4_TWIST/H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/STATUS.md`]
  - `H-A5-CLASS1-RATIONAL-POINT`, `H-A5-CLASS2-RATIONAL-POINT`, `H-A5-STRUCTURAL-MODEL-PASS` [DIR, `goal_runs_after_35fa/H_A5_TWISTS/STATUS.md`]
  - "The canonical generic A_4 twist has an exact rational point... Both maximal A_5 generic twists have exact rational points" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §1]
  - "The subgroup points close the corresponding subgroup point obstructions. They do not construct a dominant G-equivariant map... the A_5 returns cannot be promoted" [WORK, §2.1]
  - Decision exits `N-E`, `P-E-SCOPED`, `E-STOP` — none resolved [WORK]
  - `08859c0` 2026-08-02 "Certify exact A4 surface parameters"; `20be6ba` 2026-08-01 "generic-twist continuation goal"; `2301a43` 2026-08-01 "resolve Goal H subgroup-twist sweep" [GIT]
- **current_state:** SCOPED-POSITIVE (route closed) — all three maximal-subgroup obstructions are closed positively; no promotion to a dominant G-map exists, so the headline is untouched.
- **runs:** `goal_runs_after_35fa/H_A4_TWIST/H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801`; `goal_runs_after_35fa/H_A5_TWISTS`; E1 one-A5-class pilot; H1 two maximal A5 classes (`WORKORDER_CAS_HEADLINE.md` §9); `goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER` (interface attempt — see entry 17)
- **sources:** the two `goal_runs_after_35fa/H_*` dirs; `WORKORDER_ELO_TEN_PATHS.md` (Path E); `WORKORDER_CAS_HEADLINE.md` §9; `WORKORDER_CAS_HEADLINE_REVISED.md` §6.3; `REMAINING_GOALS_NOTE.md`; `DIRECTOR_REVIEW_AFTER_BD610A.md` §1–§2.1
- **lenses:** DIR, GIT, WORK (3/7)
- **confidence:** certain

---

## 12. Elo — Elo ranking / ten-paths prioritization system

- **aliases:** `WORKORDER_ELO_TEN_PATHS.md`; "post-Elo"; Paths A–J with Elo ratings; GIT `Elo` (`c5e71be`, `5e765ce`, `c28bb08`)
- **tries:** infrastructure/process — introduce an Elo-style competitive ranking over ten candidate paths (A–J) to allocate scarce CAS resource, followed by post-Elo re-dispatch (`WORKORDER_POST_ELO_CONSTRUCTION.md`).
- **method:** process
- **status_labels:**
  - `c5e71be` 2026-07-30 "issue post-Elo finite-lifting work order"; `5e765ce` 2026-07-30 "Elo cycle-1 gate report"; `c28bb08` 2026-07-31 "Path G post-Elo" [GIT]
  - `3bfbd01` 2026-07-31 "post-Elo gate 1 — record Path F"; `d96b408` 2026-07-31 "Path T post-Elo — Gate T1 T-BIRATIONAL" [GIT]
  - Path rankings: A #1, F #2, ... H #6, I #7, E #8, D #9, J #10 (Elo values e.g. I = 1473) [WORK]
- **current_state:** COMPLETED-PROCESS — ranking wave executed; superseded by the post-Elo construction dispatch and later by the goal-run regime.
- **runs:** Elo cycle-1 gate report (`certificates/GATE_REPORT_ELO_1.md`); post-Elo gate 1 (`certificates/GATE_REPORT_POST_ELO_1.md`)
- **sources:** `WORKORDER_ELO_TEN_PATHS.md`; `WORKORDER_POST_ELO_CONSTRUCTION.md`; `certificates/GATE_REPORT_ELO_1.md`; `certificates/GATE_REPORT_POST_ELO_1.md`
- **lenses:** GIT, WORK (2/7)
- **confidence:** certain

---

## 13. F — Path F: fixed-frame genus-one torsor / restricted E[3]-class arithmetic

- **aliases:** Path F (Elo #2); F0–F4; Fork F1-N / Fork F1-P; gate `F1-P`; CERT `certificates/restricted_e3`, `certificates/fixed_frame_arithmetic`; GIT `F1`, `PathF`
- **tries:** decide rationality of an explicit fixed-frame genus-one curve / restricted `E[3]`-Selmer class over `K_proj` — either find a divisorial local obstruction (Kummer-image nonmembership ⇒ pointless) **or** construct a rational point via a conic/intersection-algebra reformulation (a length-6 conic ∩ curve whose coordinate algebra `≅ K_proj`).
- **method:** mixed (CAS + descent arithmetic)
- **status_labels:**
  - `56e61c3` 2026-07-30 "Path F Gate F1-P — terminality audit passes" [GIT]
  - `865b262` 2026-07-30 "Paths F and G cycle 2 — F existence undecided" [GIT]
  - `3bfbd01` 2026-07-31 "post-Elo gate 1 — record Path F" [GIT]
  - Decision exits defined `N-F`, `P-F`, `F-LOCAL-SOLUBLE`, `F-STOP`; **no exit verbatim-resolved**; headline "OPEN" [WORK]
  - CERT inventory: `restricted_e3/CUBE_TEST.md`, `DECISION.md`, `RESTRICTED_ETALE_ALGEBRA.md`, `divisor_vector_mod3.json`, `group_cohomology.json`; `fixed_frame_arithmetic/EXISTENCE_STATUS.md`, `TERMINALITY_AUDIT.md`, `conic_algebra_*`, `five_forms.json` [CERT]
  - Bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger — but STAT flags "F" as ambiguous, see conflict]
- **conflict:** STAT could not determine whether the ledger's "F" means Path F, the cross-problem "Problem F" import (entry 14), or shorthand for "Fable" (entry 15). WORK + GIT + CERT support Path F as a distinct in-repo route with its own gates and certificate dirs; the ledger's bundled `TERMINAL` label may therefore be attached to the wrong object.
- **current_state:** UNDECIDED — F1 terminality audit passes and F1/F2/F3 artifacts exist (restricted étale algebra, mod-3 divisor cube test, group-cohomological restriction), but no decision exit is recorded; 08-02 "terminal" bundling is unverified for this route.
- **runs:** F1 restricted étale algebra (`certificates/restricted_e3`); F2 divisor-cube test mod 3; F3 group-cohomological restriction; F4 consequences; Fork F1-N (new divisorial obstruction) vs Fork F1-P (conic/intersection-algebra construction, `certificates/fixed_frame_arithmetic`)
- **sources:** `WORKORDER_POST_ELO_CONSTRUCTION.md` (Path F, F0–F4); `WORKORDER_ELO_TEN_PATHS.md` (Path F); `certificates/restricted_e3/`; `certificates/fixed_frame_arithmetic/`; git `56e61c3`, `865b262`, `3bfbd01`
- **lenses:** GIT, CERT, WORK, STAT(ambiguous) (4/7)
- **confidence:** high for the route; low for the ledger's TERMINAL label applying to it.

---

## 14. F-IMPORT — Problem F involution-mechanism / F-engine technique import

- **aliases:** "F-technique import"; "generalize the F-engine"; HAND `R16` (Path B / Problem-F import: V4-fixed exceptional-path technique transfer); RES `RES-02` (Problem F involution-mechanism import / 55-plane D10–D12 arrangement continuation)
- **tries:** negative obstruction by technique transfer — import Problem F's all-degree `V₄`-fixed exceptional-path obstruction (parity forcing, forced basepoints, pointwise-fixed exceptional curves, path-lemma tree argument) to try to kill all equivariant maps `P(W)⇢C` at once; later generalized as the "F-engine" and used to push the bounded landing-covariant analysis past degree 24 via the full 55-plane / 55-line / D10 / D12-point arrangement.
- **method:** analytic (with CAS arrangement modules)
- **status_labels:**
  - Header label "AUDIT PASSED, resolution committed" (for Problem F itself: "RESOLVED NEGATIVE") [HAND R16]
  - For the Klein-cubic transfer: "**the verbatim transfer fails**"; generalized engine — "the transition system closes rather than obstructs"; this outcome "weighs toward a POSITIVE construction... instead" [HAND R16]
  - "the rational fixed line invalidates the constant-image step in Problem F's surface path proof" [RES RES-02]
  - "the leading common-line order-exactly-three system factors through 37 dimensions and was not sent to a nonlinear solver... Since degree 25 is odd, no universal minus-line vanishing relation may be added either" [RES RES-02]
  - `2b8cf41` 2026-07-28 "generalize the F-engine"; `1a52c93` 2026-07-28 "F-technique import" [GIT]
  - "Do not rerun the Problem F constant-path argument" [STAT, `CURRENT_PATHS.md` line 2442, Deprioritized work]
- **current_state:** REFUTED-AS-TRANSFER — the verbatim import fails and the generalized engine closes rather than obstructs; explicitly deprioritized, and its failure is cited as evidence favouring a positive construction.
- **runs:** `tmp/involution_exceptional_divisor` (+`verify_v4.py`), `tmp/d12_line_restriction`, `tmp/v4_surface_slice_audit`; D10/D12 symbolic module and `m1_compact_degree25` plane/line/point construction (+2 independent audits); `m3_line_point_boundary` D12 rank-8/8 point closure
- **sources:** `HANDOFF.md` 2026-07-28 sections (technique import; generalizing the F-engine; exact audit of Fable's generalized engine); `RESOLUTION.md` "2026-07-29 structural advances" items 12–13; `CURRENT_PATHS.md` Deprioritized work; git `2b8cf41`, `1a52c93`
- **lenses:** GIT, HAND, RES, STAT (4/7)
- **confidence:** certain
- **possibly-same-as:** entry 13 (F). Distinct content (cross-problem technique import vs in-repo fixed-frame genus-one route); the letter "F" is overloaded in the repo.

---

## 15. Fable — A4 trisection / Koszul lifting construction

- **aliases:** Fable route; "quadratic triangle / trisection"; HAND `R17` (trisection attack), `R18` (Koszul first-gate), `R19` (factorized `q_P·R_P` family), `R20` (nonfactorized successor); RES `RES-11`; WORK `FABLE — Koszul ansatz order-twelve gate` (`WORKORDER_ORDER12.md`)
- **tries:** positive construction — at a `V₄`-fixed centre (normalizer `A₄`), blow up the length-3 base orbit `R=X∩P(T)`, prove every `A₄`-equivariant `P(U)⇢X` has projected degree divisible by 3, and explicitly construct a degree-3 `A₄`-equivariant birational map `P(U)⇢S⊂X` onto a cubic surface `S(a,b,c)`; then lift compatibility across the whole 55-plane / D10 / D12 arrangement via symbolic Rees powers `I^(m)/I^(m+2)` and a Koszul construction, aiming at an actual landing covariant.
- **method:** mixed (equivariant geometry + CAS module/rank computations)
- **status_labels:**
  - "the first local positive gate is solved" / "the one-centre trisection gate is solved"; "does not automatically define a section of the full 55-plane symbolic sheaf" [HAND R17, RES RES-11]
  - "This solves exactly the first formal landing correction"; "the theorem closes only `I^(9)/I^(11)`" [HAND R18]
  - Factorized family: "**obstructed**"; "impossible ... for irreducible, split, nonreduced, singular, nonnormal, or irregular double planes"; "closed at the first full `I^(11)/I^(13)` gate" [HAND R19]
  - Nonfactorized successor: "now closed as well"; "every planewise normal-order 3/4 extension retaining these fixed line germs is impossible"; "A Fable escape must change the boundary data or the leading normal order" [HAND R20, RES RES-11]
  - "This is a scoped negative landing theorem" [RES RES-11]
  - "Fable remains a redesign route, not the current lead" [STAT, `CURRENT_PATHS.md` 2026-07-30 item 4]
  - `WORKORDER_ORDER12.md`: active dispatch, headline "OPEN", target = second gate (`F(σ+e)=0 mod I^13`) [WORK]
  - "the Fable positive branch was closed by two obstruction theorems (elliptic quadratic-trace; Veronese/Hilbert–Burch syzygy dichotomy)" [WORK, `WORKORDER_STRATA_MACHINE.md` addendum re commit `71ba6bd`]
- **conflict:** `WORKORDER_ORDER12.md` dispatches the order-12 second gate as **active** while `WORKORDER_STRATA_MACHINE.md`'s addendum and HAND R19/R20 record the branch as **closed by two obstruction theorems**. Ordering: the order-12 dispatch predates the closure theorems (WORK notes the refutation "is inferred from cross-reference only"); the closure is the later state.
- **current_state:** CLOSED-IN-CURRENT-FORM — one-centre trisection and first Koszul gate (`I^(9)/I^(11)`) are positive results; both the factorized and nonfactorized continuations to `I^(11)/I^(13)` are obstructed; a Fable escape requires changed boundary data or leading normal order (redesign route).
- **runs:** `tmp/fable_positive_construction`, `fable_trisection_attack`, `fable_trisection_compatibility`, `fable_nonlinear_first_gate`, `fable_resolved_descent`, `fable_constrained_cokernel`(+audit), `fable_finite_d12_constrained`, `fable_d12_char0_bridge`(+audit), `fable_d12_rees_sigma_interface`(+audit), `fable_first_gate_koszul`(+audit), `fable_d12_simultaneous_successor`, `fable_order12_qsection_correction`, `fable_d12_joint_rank`, `fable_d12_koszul_rank`, `fable_d12_module_adversary`, `fable_d12_bulk_correction_rank`, `fable_d12_triangular_bulk_closure`, `fable_relative_divisor_trace_obstruction`, `fable_fixed_plane_boundary_adversary`, `fable_relative_q_trace_obstruction`, `fable_nonfactorized_successor`, `fable_nonfactorized_syzygy_obstruction`, `fable_nonfactorized_feasibility`
- **sources:** `HANDOFF.md` "2026-07-29 xCD completion and Fable update" and "2026-07-29 Fable positive-construction assessment"; `RESOLUTION.md` "2026-07-29 structural advances" item 4; `SPEC.md` task E1 continuation; `CURRENT_PATHS.md` 2026-07-29 item 3; `WORKORDER_ORDER12.md`; `WORKORDER_STRATA_MACHINE.md` environment addendum
- **lenses:** HAND, RES, STAT, WORK (4/7)
- **confidence:** certain

---

## 16. G — Path G: universal object, global finite lifting, bounded landing-covariant degree ladder

- **aliases:** Path G; G0–G5; G1 finite truncation; G2 finite generation; G4.1 symbolic free-fibre recurrence; G7 degree-7 exit; `G_UNIVERSAL`; SPEC task **E1**; HAND `R1` (bounded landing self-covariant search), `R2` (G4.1 recurrence), `R3` (P25.1 tower continuation); RES `RES-01`, `RES-26`; CERT bucket `GLIFT` (`global_lifting`, `global_finite_lifting`, `global_lifting_decision`, `global_terminal_module`, `global_transition`); STAT "Landing self-covariants degree ladder / 55-plane symbolic arrangement module"
- **tries:** positive construction with a built-in negative exit — build a nonzero homogeneous `G`-equivariant landing self-covariant `p:W→W` with `F(p)=0`, via formal normal-cone / polar lifting along the exact stabilizer stratification (finite-truncation theorem with isolation cutoff `N⋆=d+2m+1`, terminal-residual towers at degrees 7/13/19, global-state-image vs nonlinear-rank-drop analysis, an equivariant-resolution "G3-algebraization" shortcut); `G-NEGATIVE` is the all-degree negative fallback if every family's universal terminal projective zero support is empty. The bounded degree ladder (degrees 7–24 excluded) is the executable face of this route.
- **method:** CAS (Macaulay2 / msolve / multiprime linear algebra) with structural theorems
- **status_labels:**
  - PRE-REPAIR: degree-13/19 packets labeled `G13-OBSTRUCTION` / `G19-OBSTRUCTION`, read as degree-wide obstruction theorems [STAT/REPAIR.md §§11–12]
  - POST-REPAIR: downgraded to `G13-SAMPLE-RESIDUAL`, `G19-SAMPLE-RESIDUAL`, `G-PATTERN` — "proven only that the residual map is not identically zero, not that its zero locus (Θ⁻¹(0)) is empty" [STAT/REPAIR.md §§11–12; HAND R1; RES RES-26]
  - POST-REPAIR retained: "Path G: finite truncation and isolation cutoff (N⋆=d+2m+1) — retained" [HAND R1, RES RES-26]
  - "Path G4.1 symbolic free-fibre recurrence — retained at its stated free-fibre boundary"; "the split-fibre all-degree colon is therefore refuted"; "target-1,572 certificate ... refuted" [HAND R2]
  - "P25.1 `P25-TOWER-SURVIVES` — retained as scoped free-fibre/degree-25 continuation"; "dim Z<=15"; "No `P^22` or successor slice is authorized" [HAND R3]
  - `G2-FINITE-GENERATION-PASS` [DIR, `goal_runs_after_35fa/G_UNIVERSAL/STATUS.md`]; "TERMINAL STRUCTURAL PASS (G2-FINITE-GENERATION-PASS) — All-degree reduction achieved — Leaves arithmetic decision of surviving universal object" [STAT, 08-02 ledger]
  - "No nonzero homogeneous polynomial G-covariant W→W of degree at most 24 has image contained in the Klein cubic"; "Degree 25 is now the next unrestricted homogeneous landing degree"; "This is a bounded exclusion only... there is no degree bound; therefore this calculation supplies no negative answer" [RES RES-01]
  - "A search through any finite degree is not a negative resolution" [HAND R1]
  - `e050464` 2026-07-30 "Path G Gate G1 — containment FALSE at (1,7)"; `865b262` "G exits G-CONSTRUCTION"; `c28bb08` 2026-07-31 "G1 finite truncation PASSES; degree-7 exits G7-OBSTRUCTION"; `68147f3` "Route G verdict — G4.1 symbolic formula achieved, gate G-A blocked"; `62a3fcb` "Path G3 — exit G-PATTERN"; `23f40f7` 2026-08-02 "finish G/G2 universal all-degree theorem"; `6a2ccaa` "retire completed G2 structural mission" [GIT]
  - "no finite global presentation was constructed... nonexistence of such a presentation is not proved" [WORK, `WORKORDER_CAS_HEADLINE_REVISED.md`, parked]
  - "Marked state gives a boundary map — not proved"; "Equivariant interpolation from projective endpoint data — false without a common-character hypothesis"; "Affine completion has the same formal-rational field as the full completion — false"; "G-unirationality — not proved" [WORK, `NOTES_PATH_G_GLOBAL_LIFTING.md` §18]
- **current_state:** STRUCTURAL-PASS, ARITHMETIC-OPEN — G2 achieves the all-degree finite-generation reduction and the mission is formally retired; the bounded ladder excludes degrees ≤24; the degree-13/19 "obstructions" are only sample residuals post-repair; everything now hands off to G3 (entry 17) and P25 (entry 25).
- **runs:** G1 finite-truncation theorem; G2 degree-7 tower; G3 degrees 13/19 comparison; G4 global correction sheaves; G5 candidate audit; G4.1–G4.4; G-A/G-B/G-C/G-D boundary-realization questions; `goal_runs_after_35fa/G_UNIVERSAL`; degrees 7–24 exclusions (`tmp/structural_degree13`, `degree14_structural`, `degree15_structural`, `degree16_landing_probe`, `degree16_exceptional_search`, `covariant_arrangement_module` for 17–21, `degree22_compression`, `degree23_common_line_landing`, `degree24_landing`); `tmp/symbolic_global_exactness`, `m1_compact_graded_pilot`, `m1_t1_saturation`, `m1_t1_f3_colon_attack`, `m1_t1_f3_colon_degree35_audit`, `m1_t1_char0_d35_gate`; `tmp/local_symbolic_rees`; `certificates/global_*`, `certificates/lifting/`
- **sources:** `WORKORDER_CAS_HEADLINE.md` §4; `WORKORDER_CAS_HEADLINE_REVISED.md` §6.1; `WORKORDER_POST_ELO_CONSTRUCTION.md` (Path G, G0–G5); `WORKORDER_FIVE_ATTEMPTS.md` (Attempt 5); `NOTES_PATH_G_GLOBAL_LIFTING.md`; `REPAIR.md` §§11–12, §16; `RESOLUTION.md` degree-24 exclusion sections; `SPEC.md` task E1; `goal_runs_after_35fa/G_UNIVERSAL/STATUS.md`; `certificates/global_finite_lifting/`, `global_lifting/`, `global_lifting_decision/`, `global_terminal_module/`, `global_transition/`
- **lenses:** DIR, GIT, CERT, HAND, RES, STAT, WORK (7/7)
- **confidence:** certain

---

## 17. G3 — Universal cubic arithmetic (G3A/G3B/G3C/G3D/G3H/G3P/G3S)

- **aliases:** "G3 universal cubic arithmetic"; `G3A_EXACT_ARITHMETIC_DOMINANCE`, `G3B_LINE_CONIC_SEARCH`, `G3C_LINE_CONIC_FANO`, `G3D_DIRECT_ARITHMETIC`, `G3H_A5_SEMILINEAR_SPRINGER`, `G3P_POLAR_ODD_DEGREE_DESCENT`, `G3S` (structured direct arithmetic); GIT `G3`, `G3A`, `G3H`, `G3S`
- **tries:** positive/arithmetic successor to Path G — having reduced the headline to a "surviving universal object", decide whether its associated cubic `Φ` has a `K_proj`-rational point, i.e. decide `V(Φ)(K_proj) ≠ ∅`; sub-attacks via exact field arithmetic + automatic dominance (G3A), rational conic sections satisfying tautological polar constraints (G3B/G3C), direct arithmetic on the generic twist (G3D/G3S), an A5 quadratic-Springer semilinear lift (G3H), and tautological-polar / odd-degree descent (G3P).
- **method:** CAS + arithmetic
- **status_labels:**
  - "OPEN — Decide V(Phi)(K_proj) — Highest priority" [STAT, 08-02 ledger]
  - "G3 arithmetic OPEN" [WORK, `REMAINING_GOALS_NOTE.md`]
  - `G3A-ARITHMETIC-DOMINANCE-PASS` [DIR]
  - `G3P-POLAR-SYSTEM-PASS` [DIR]
  - `G3H-SEMILINEAR-G3-FRAME-PASS`, `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` [DIR]
  - G3B / G3C / G3D: no `STATUS.md` label captured — "inferred from directory name" [DIR]
  - `62a3fcb` 2026-07-31 "Path G3 — exit G-PATTERN"; `5eb1214` 2026-08-02 "add G3 universal cubic arithmetic goal"; `5cb3d11` "add G3A arithmetic and dominance goal"; `d1f43d6` "Add G3H A5 semilinear Springer execution order"; `7da4fdf` "Add G3S structured direct arithmetic execution order" [GIT]
- **current_state:** OPEN — highest-priority live route as of 2026-08-02; dominance and polar-system sub-gates PASS, the A5 semilinear quadratic interface is a scoped NO-GO, and the point decision itself is undecided.
- **runs:** `goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE`, `.../G3B_LINE_CONIC_SEARCH`, `.../G3C_LINE_CONIC_FANO`, `.../G3P_POLAR_ODD_DEGREE_DESCENT`, `.../G7_DOUBLE_A5_BIPLANE`; `goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC`; `goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER`; G3S execution order (`7da4fdf`)
- **sources:** the run dirs above (+ `STATUS.md`); `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`; `REMAINING_GOALS_NOTE.md`; git `5eb1214`, `5cb3d11`, `d1f43d6`, `7da4fdf`, `62a3fcb`
- **lenses:** DIR, GIT, STAT, WORK (4/7)
- **confidence:** certain

---

## 18. H11:5 / H5 / H6 — 11:5 Frobenius subgroup trace-cubic programme

- **aliases:** `H_11_5_TWIST`, `H5_11_5_TRACE_CUBIC`, `H5_FIBRATION_PROBE_20260802`, `H5_WAVE2_LAURENT_PROJ`, `H6_TRACE_CUBIC_DECISION`, `H6A_PROJECTIVE_11_ISOGENY`; STAT "H — trace-cubic program (H11:5, H5, H6)"; WORK "H5/H6 — 11:5 (Frobenius) subgroup generic twist / trace cubic via torus isogeny"; GIT `H6` (`027e002`)
- **tries:** negative/structural obstruction for the proper subgroup `C11⋊C5 ≤ G` — reduce the generic 11:5 twist exactly to a genuine cyclic trace cubic `Tr_{E/K}(r₂⁻¹ a² σ(a)) = 0` over a rational four-parameter invariant field, then decide the trace cubic's pointlessness using the degree-11 torus / `μ₁₁`-torsor / isogeny structure (⇒ `BR-SUBGROUP-NEG` if pointless).
- **method:** CAS + arithmetic (elliptic/torsor)
- **status_labels:**
  - `H-11_5-NORM-MODEL-PASS` [DIR, `goal_runs_after_35fa/H_11_5_TWIST/STATUS.md`; WORK]
  - `H5-UNDECIDED` [DIR, `goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/STATUS.md`]; "no K-point; binary open" [WORK]
  - `H6-TORSOR-CLASS-PASS` [DIR, `goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/STATUS.md`]
  - "the exact trace model is now sufficiently small to attack, but no pointlessness theorem is present"; ranked "Rank 2 — the smallest exact genuine twist left" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §2.5, §4]
  - Ledger: H11:5 `OPEN — Need genuine degree-11 torus/isogeny decision — H6 route`; H5 `PARTIAL — Model sealed but no K-point conclusion — Input to H6` [STAT]
  - `027e002` 2026-08-02 "add H6 degree-11 isogeny goal" [GIT]
- **current_state:** OPEN — norm model and `μ₁₁`-torsor class installed and PASSING; the arithmetic binary (does the cyclic trace cubic have a K-point) is unresolved; ranked second-strongest negative route.
- **runs:** `goal_runs_after_35fa/H_11_5_TWIST`; `goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC`, `.../H5_FIBRATION_PROBE_20260802`, `.../H5_WAVE2_LAURENT_PROJ`; `goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION`, `.../H6A_PROJECTIVE_11_ISOGENY`
- **sources:** the six run dirs above; `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 4, §2.5, §4 Rank2; `REMAINING_GOALS_NOTE.md`; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #5; `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`
- **lenses:** DIR, GIT, STAT, WORK (4/7)
- **confidence:** certain
- **note:** STAT flags a false-positive textual match: the symbol `H5` also appears as a polynomial coefficient `H5=(3/8)b²P3` inside the xCD route (entry 35) — unrelated. Likewise `H6` as a route code vs `H_6=V(f_6)` the Klein sextic in the xCD narrative — identification not established.

---

## 19. Hodge-center — split-injection theorem / CM-polarized screen

- **aliases:** WP-H1; Path D D1 (per WORK's merge); HAND `R31`; RES `RES-28`; `certificates/hodge_centers/HODGE_CENTER_NECESSITY.md`; GIT `H1` (`db25516` "WP-H1 Hodge-center screen — no numerical contradiction")
- **tries:** negative necessary-condition screen — from a hypothetical dominant equivariant `P⁴⇢X` and its equivariant resolution `f:Z→X`, use the split injection `H³(X)↪H³(Z)` and the blowup formula `H³(Bl_C Y)≅H³(Y)⊕H¹(C)(-1)` to force `H^{2,1}(X)` as a `G`-representation to be supplied by `H^{1,0}` of positive-irregularity blowup centres, then upgrade the representation-only screen to the integral polarized intermediate-Jacobian (CM order, principal polarization) structure and force a contradiction via minimum-genus/orbit-size bounds (Riemann–Hurwitz / Chevalley–Weil).
- **method:** analytic (Hodge theory) + CAS character screens
- **status_labels:**
  - PRE-REPAIR: proof via "generically finite" pushforward `f_*:H³(Z)→H³(X)` — **relative-dimension error**: since `dim Z=4`, `dim X=3`, dominant `f` has relative dimension one, not zero, so the displayed degree-`d` identity is invalid [STAT/REPAIR.md §7]
  - POST-REPAIR: "Hodge-center conclusion — salvageable; proof rewritten via relatively ample class (REPAIR.md §8)"; "corrected Hodge-center split-injection theorem after §8 substitution" (listed among trusted results retained) [HAND R31, RES RES-28, STAT]
  - Required file edit: `certificates/hodge_centers/HODGE_CENTER_NECESSITY.md` must replace the generically-finite argument with the relatively-ample-class argument [STAT/REPAIR.md §15]
  - "necessary condition only; 40 representation channels survive" [WORK, `WORKORDER_ELO_TEN_PATHS.md`]
  - `db25516` 2026-07-30 "WP-H1 Hodge-center screen — no numerical contradiction" [GIT]
- **current_state:** SALVAGED-BUT-NONBINDING — the split-injection theorem survives after the §8 rewrite, but the screen yields no numerical contradiction (40 representation channels survive), so it obstructs nothing.
- **runs:** WP-H1 tasks 1–6 (split injection; `H^{2,1}` representation; character screen; Riemann–Hurwitz / Chevalley–Weil bounds); `certificates/hodge_centers/` (`character_screen.g`, `character_screen.json`, `verify.py`)
- **sources:** `REPAIR.md` §§7–8, §15; `certificates/hodge_centers/HODGE_CENTER_NECESSITY.md`; `WORKORDER_STRATA_LIFTING_BLOCKERS.md` Part VI WP-H1; `WORKORDER_ELO_TEN_PATHS.md` (Path D); `CURRENT_PATHS.md` repair-summary line 48; git `db25516`
- **lenses:** GIT, CERT, HAND, RES, STAT, WORK (6/7)
- **confidence:** certain
- **possibly-same-as:** entry 10 (D/D2) — WORK merges them; other lenses separate.

---

## 20. I — Hermitian five-plane intersection theory

- **aliases:** Path I (Elo #7); exits `N-I`, `P-I`, `I-STOP`
- **tries:** positive/negative via arithmetic invariants — study the common zero locus of the five Hermitian sections on `SB_2(A) ≅ P²_D` using **intersection theory** rather than direct elimination; look for a "point-sensitive" invariant (Chow–Witt Euler class, Witt-group obstruction, unramified cohomology, canonical dimension/incompressibility, Hermitian Euler class) beyond the ordinary Chow class.
- **method:** analytic
- **status_labels:** ranked "structural", Elo 1473; decision exits `N-I`, `P-I`, `I-STOP` — none resolved [WORK, `WORKORDER_ELO_TEN_PATHS.md` Path I]
- **current_state:** UNRESOLVED/UNRUN — defined with exits, never dispatched to a verdict.
- **runs:** I1 identify point-sensitive invariant (planned)
- **sources:** `WORKORDER_ELO_TEN_PATHS.md` (Path I, ranked #7)
- **lenses:** WORK (1/7) — **single-lens**
- **confidence:** certain (as a stated route); no execution evidence

---

## 21. J/J2 — Direct essential/canonical-dimension invariant; base-locus Prym countermodel

- **aliases:** Path J (Elo #10); Goal J; `J_BASELOCUS_PRYM`; exits `N-J`, `J-CANDIDATE`, `J-STOP`
- **tries:** negative — prove `ed_C(G)=4` directly via a cohomological / canonical-dimension / motivic invariant that survives every 3-dimensional compression, auditing candidate invariants (cohomological invariants, equivariant Chow/Steenrod operations, canonical dimension/incompressibility, motives of generic projective representations, unramified cohomology) against four required criteria; realized as an equivariant resolution of the landing covariant's base locus with analysis of the resulting Prym factors.
- **method:** analytic (with CAS resolution/Prym computation)
- **status_labels:**
  - `J2-UNRESTRICTED-COUNTERMODEL-EXTENDS` [DIR, `goal_runs_after_35fa/J_BASELOCUS_PRYM/STATUS.md`]
  - "theory watch" (queue status); decision exits `N-J`, `J-CANDIDATE`, `J-STOP` — none resolved [WORK, `WORKORDER_ELO_TEN_PATHS.md` Path J]
  - Bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger; STAT notes "content entirely unknown from this lens"]
- **conflict:** WORK describes Path J as an *invariant audit* never executed ("theory watch"); DIR shows an executed run whose exit is a *countermodel* (`J2-UNRESTRICTED-COUNTERMODEL-EXTENDS`). Same letter, plausibly the same route after execution, but no lens states the link. Best reconciliation: J is the motivic/canonical-dimension invariant route, executed as the base-locus Prym analysis, and terminated by a countermodel showing the unrestricted invariant does not obstruct — consistent with the parallel finding for D (entry 10).
- **current_state:** TERMINAL — the unrestricted invariant admits an extending countermodel; no point-sensitive invariant found.
- **runs:** `goal_runs_after_35fa/J_BASELOCUS_PRYM`; J1 candidate-invariant audit (planned)
- **sources:** `goal_runs_after_35fa/J_BASELOCUS_PRYM/STATUS.md`; `WORKORDER_ELO_TEN_PATHS.md` (Path J); `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`
- **lenses:** DIR, STAT, WORK (3/7)
- **confidence:** medium (identity of the two descriptions)

---

## 22. KLS — Kraft–Loetscher–Schwarz self-covariant landing framework

- **aliases:** KLS / KLS2; `KLS_MINIMALITY`; Path H (Elo #6); Attempt 4; HAND `R4` (Jacobian-zero criterion), `R7` (A5-quadric/P22 branch closure), `R8` (minimal-contraction / vertical-divisor); RES `RES-09` (all-degree Jacobian criterion), `RES-10` (minimal-contraction / vertical-divisor / foliation program); STAT "KLS", "KLS2", "Degree-12 mixed Jacobian problem"
- **tries:** general framework, both directions — (positive) seek a primitive rank-4 self-covariant `q:W→W` whose Gauss-map/adjugate structure lands equivariantly on the Klein cone; equivalently (KLS theorem) `ed(G)=3` iff some nonzero homogeneous self-covariant `W→W` has identically zero Jacobian determinant; (negative) prove no minimal landing self-covariant exists (`h=1`, `ed(G)=4`) via the image hypersurface `H=V(F)`, the contracted-gradient gcd `h`, log-canonicity of the induced foliation, vertical/nonnormal divisor geometry, and a minimality-to-conductor reduction.
- **method:** mixed (birational geometry / foliation theory + CAS sweeps)
- **status_labels:**
  - Jacobian-zero criterion: "every such covariant through degree 11 is dominant; no degree cutoff is known"; degree 12 "remains open only on a proper closed exceptional locus" [HAND R4]; "Neither the KLS theorem nor finite generation of the covariant module gives an all-degree cutoff; an explicit S5-module counterexample rules out that shortcut" [RES RES-09]
  - Degree-12: "Degree 12 is still open on that exceptional closed subset"; parameter-free top ideal certified (Hilbert function `[1,12,78,364,1365,3647,3726,0,0]`, colength 9,193); "no relative Fitting determinant has yet been produced" [STAT]
  - A5-quadric branch: "now closed"; `q_A5∤h`, `P22∤h` for normal `H`; "does not construct a KLS self-covariant or conductor surface"; nonnormal-conductor branch remains open; degree identity "still forces `d<=9`" for a `P22·k` variant [HAND R7, STAT]
  - Minimal-contraction/vertical-divisor: "sharpened without a degree sweep"; "does not prove h=1"; "the surviving theorem is genuinely paired: prove LC-minimality ... and a vertical-divisor comparison ... or prove the minimal image canonical directly" [HAND R8, RES RES-10]
  - `KLS2-NO-FINITE-REDUCTION` [DIR, `goal_runs_after_35fa/KLS_MINIMALITY/STATUS.md`]
  - "The proposed KLS minimality-to-discrepancy reduction does not produce a nontrivial finite list... no proved theorem controls the conductor support" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 4]
  - "No large KLS computation is authorized until the analyst supplies a precise theorem" [WORK, `WORKORDER_CAS_HEADLINE.md` §8]; exits `KLS-FINITE-TABLE-CLOSED`, `KLS-COUNTERMODEL`, `KLS-NO-THEOREM`, `N-H`, `H-UNIQUE`, `H-COUNTERMODEL` — none resolved
  - "the headline remains open... h=1 remains unproved" [RES RES-10]
  - `0d16f55` 2026-08-01 "add theorem-first KLS continuation goal"; `6737bec` "add goal-mode KLS minimality-conductor route" [GIT]
  - Bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger]
- **conflict (preserved, instruction 4a):** the 08-02 offline ledger marks KLS/KLS2 `TERMINAL — background only`, while `CURRENT_PATHS.md` (07-29/07-30) documents several still-open branches (foliation LC-minimality / vertical-divisor gate; nonnormal-conductor branch; degree-12 Jacobian exceptional locus; the unsolved flat-connection PDE), and `KLS_MINIMALITY/STATUS.md` records only `KLS2-NO-FINITE-REDUCTION` — which closes the *minimality-conductor reduction*, not the framework. Run-level `STATUS.md` and `CURRENT_PATHS.md` outrank the offline ledger: the framework is **not** globally terminal.
- **current_state:** CONFLICT → best reconciliation: the *minimality-to-conductor reduction* is closed (`KLS2-NO-FINITE-REDUCTION`) and the A5-quadric/P22 branch is closed; the framework as a whole (Jacobian-zero criterion above degree 11, nonnormal conductor, LC-minimality + vertical-divisor pair) remains **open but unauthorized for further large computation** pending a precise theorem.
- **runs:** `goal_runs_after_35fa/KLS_MINIMALITY`; `tmp/kls_minimal_contraction_attack`, `kls_vertical_divisor_geometry`(+audit), `kls_nonstable_vertical_orbits`(+audit), `kls_a5_logarithmic_divisor`, `kls_wstar_first_integrals`, `kls_degree28_stein_fixed_point`, `kls_a5_linearized_pencil_obstruction`(+audit), `kls_a5_conductor_surface_feasibility`(+audit), `kls_actual_conductor_geometry`, `kls_proper_multiple_structure`, `kls_structural_successor`, `kls_global_foliation_theorem`, `kls_discrepancy_next_gate`(+audit), `kls_divisor_ansatz`, `kls_residue_next`, `kls_first_jet_two_fiber`, `kls_first_jet_three_fiber`, `kls_full_support_p9_msolve`, `kls_structural_audit`; `tmp/degree10_jacobian`, `degree11_jacobian`, `degree12_jacobian`, `degree12_jacobian_structural`, `relative_kls_chart`, `relative_kls_hyperplane`
- **sources:** `goal_runs_after_35fa/KLS_MINIMALITY/STATUS.md`; `CURRENT_PATHS.md` 2026-07-29 items 1–3, Ranking B item 2; `RESOLUTION.md` "2026-07-29 structural advances" items 1–3 and "2026-07-30 audited advances" item 1; `SPEC.md` item 10; `HANDOFF.md` 2026-07-29/07-30 KLS blocks; `WORKORDER_CAS_HEADLINE.md` §8; `WORKORDER_FIVE_ATTEMPTS.md` (Attempt 4); `WORKORDER_ELO_TEN_PATHS.md` (Path H); `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 4
- **lenses:** DIR, GIT, HAND, RES, STAT, WORK (6/7)
- **confidence:** certain

---

## 23. L1 — Full polar range recursion

- **aliases:** `L1_FULL_POLAR_RANGE`; possibly WP-L1 "universal polar expansion" (`WORKORDER_STRATA_LIFTING_BLOCKERS.md` Part II)
- **tries:** infrastructure/positive — construct a universal finite formal-recursion certificate valid for **all odd normal orders**, completing the polar-expansion range used by the Path G lifting tower.
- **method:** CAS
- **status_labels:** `L1-FULL-RANGE-PASS` [DIR, `goal_runs_after_7030dd/L1_FULL_POLAR_RANGE/STATUS.md`]
- **current_state:** PASS — universal finite formal recursion certified across the full odd-order range.
- **runs:** `goal_runs_after_7030dd/L1_FULL_POLAR_RANGE`; (candidate alias run) WP-L1 universal polar expansion → `certificates/lifting/polar_expansion.json`, `polar_expansion.py`, `verify_polar_expansion.py`
- **sources:** `goal_runs_after_7030dd/L1_FULL_POLAR_RANGE/STATUS.md`; `WORKORDER_STRATA_LIFTING_BLOCKERS.md` Part II (WP-L1); `certificates/lifting/`
- **lenses:** DIR (1/7 for the `L1` label) — **single-lens** as labelled; the WP-L1 identification adds WORK/CERT circumstantially
- **confidence:** certain for the run and its PASS; medium for the WP-L1 identity

---

## 24. M / M2 / M3 — Sarkisov link / degree-3 del Pezzo fibration section search

- **aliases:** `M_SARKISOV`, `M3_SARKISOV_SECTION`, `M3B_SECTION_RESIDUAL_G1_20260802`; STAT "M3 — section vs multisection"; WORK "R/M-stub" ("M/M2 prior terminals"); GIT `M3` (`96195e8`, `139ab6c`, `5167255`)
- **tries:** positive/structural — construct an exact type-I Sarkisov link (blow up a smooth plane cubic on the Schur generic Klein twist) to a relative degree-3 del Pezzo fibration over `P¹` with multisections of degree 3 and 55 (hence index 1), then search in Cox coordinates for an actual **rational section** (headline-positive) as opposed to only a degree-4 multisection (which proves index 1 only).
- **method:** mixed (birational geometry + CAS Cox-ring search)
- **status_labels:**
  - `M2-EXPLICIT-LINK-PASS` [DIR, `goal_runs_after_35fa/M_SARKISOV/STATUS.md`]
  - `M3-INTEGRAL-DEGREE4-MULTISECTION` (terminal, multisection only); `M3B-G1-MODULAR-NONEMPTY-PASS` (residual); "K-section open" [WORK]
  - "A rational section... would... close the headline positively. The current packet does not select the section branch. A degree-four multisection... proves only index one and cannot be promoted to a section" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §2.2]
  - "OPEN — Multisection closed; section remains — Possible residual Galois route" [STAT, 08-02 ledger]
  - `96195e8` 2026-08-02 "finish M3 residual section close-out"; `139ab6c` "M3: restore recursive packet seal"; `5167255` "M3: restore residual gate" [GIT]
  - "prior terminals" for M/M2 [WORK, `REMAINING_GOALS_NOTE.md` "Already terminal" table]
- **current_state:** OPEN-NARROWED — the explicit Sarkisov link and the degree-4 integral multisection are terminal PASSes; the rational-section question remains open as a residual Galois-descent route.
- **runs:** `goal_runs_after_35fa/M_SARKISOV`; `goal_runs_after_bd610a/M3B_SECTION_RESIDUAL_G1_20260802`; artifact pointer `M3_SARKISOV_SECTION`
- **sources:** `goal_runs_after_35fa/M_SARKISOV/STATUS.md`; `goal_runs_after_bd610a/M3B_SECTION_RESIDUAL_G1_20260802/`; `DIRECTOR_REVIEW_AFTER_BD610A.md` §1 item 3, §2.2, §4 Rank4; `REMAINING_GOALS_NOTE.md`; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #8; `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`
- **lenses:** DIR, GIT, STAT, WORK (4/7)
- **confidence:** certain
- **conflict:** STAT could not disambiguate whether the ledger's "M3 multisection closed" refers to the Fable `A₄` multisection-index-3 theorem or to the Schur ten-fibration no-section theorem; WORK's Sarkisov description (degree-3 dP fibration, degree-3 and degree-55 multisections) is the more specific and is adopted.

---

## 25. P25 — Degree-25 landing self-covariant (P25R / V / W / X / Y / Z)

- **aliases:** P25; P25.1–P25.4; P25R, P25V, P25W, P25X, P25Y, P25Z; `P25W-RankK`, ROW-RANK, SUPPORT-F4, TOWER, MOLIEN; HAND `R3`; STAT "P25 — landing support"; CERT bucket `P` (`degree25_*`)
- **tries:** positive construction (with a negative-emptiness exit) — build an exact, primitive, characteristic-zero **degree-25** homogeneous `G`-equivariant landing self-covariant `p:W→W` with `F(p)=0` and generic Jacobian rank 4, via increasingly rigorous finite/global coefficient models, border/Fitting-module presentations, and projective-support decisions (with DVR-properness arguments for emptiness). Degree 25 is the first unresolved degree in the landing ladder (entry 16).
- **method:** CAS (multiprime linear algebra, border bases, msolve/F4, DVR arguments)
- **status_labels:**
  - `P25-TOWER-EMPTY` / `P25-TOWER-SURVIVES`; `P25R0/1/2-*`; `P25X0/1/2-PASS/FAIL/UNDECIDED`; `P25Y-DVR-PASS`; `P25Z-ROW-RANK-746` ("the direct landing row rank is exactly 746"); `P25Z-FINITE-PRESENTATION-LOWER`; `P25W-PRESENTATION-EXACT/ENLARGE/UNDECIDED`; `P25-DEGREE25-EMPTY`; targets `P25-COVARIANT`/`P25-POLYNOMIAL` **not reached** [WORK]
  - `P25-UNDECIDED`; "63 charts on D(H_8)... PREPARED_NOT_RUN" [WORK, `REMAINING_GOALS_NOTE.md`]
  - historical 842-row / rank-28 packets "quarantined" and later "retired on mathematical grounds" [WORK, `DIRECTOR_HANDOFF.md`]
  - "P25.1 `P25-TOWER-SURVIVES` — retained as scoped free-fibre/degree-25 continuation"; "dim Z<=15"; "`P^21` a strict nonverdict (`3933 ≤ rank ≤ 7910`)"; "No `P^22` or successor slice is authorized" [HAND R3]
  - "OPEN/DEFERRED — Finite chart computation only — Not headline without bridge" [STAT, 08-02 ledger]; "Degree 25 remains open" [STAT, `CURRENT_PATHS.md`]
  - `19da967` 2026-07-31 "P25W — Stage A kernel incidence EMPTY"; `841005b` "P25Z.3 — direct landing row rank EXACTLY 746"; `2140419` 2026-08-01 "P25V.0 — degree-four closure FAILS"; `6096429` "V2 Track P25Y — P25Y-DVR-PASS"; `5e72d8e` "V2 Track P25X — P25X0-PASS, P25X1-FAIL; the 842 basis is not recovered" [GIT]
- **current_state:** OPEN/DEFERRED — extensive partial structure (`dim Z ≤ 15`, row rank exactly 746, DVR pass, Stage-A kernel incidence empty), but the degree-25 landing locus is neither populated nor proved empty; further slices unauthorized and the route is explicitly "not headline without a bridge".
- **runs:** P25.1–P25.4 (CAS_HEADLINE); P25R.0–P25R.3 (REVISED); P25X.0–P25X.2 (DECISION/_V2); P25Y.1–P25Y.4 (AFTER_5E72D8E); P25Z.1–P25Z.3 (T9_P25Z); P25W.0–P25W.3 (T10_P25W_C2); P25V.0–P25V.3 (T11_P25V_C3); WP-B1, WP-6; `tmp/m1_relative_border_rank28`, `m1_relative_border_maxslice`, `m1_relative_border_p19_d5`, `char0_lift_p19_d5`, `m1_relative_border_p20_d5`, `char0_lift_p20_d5`, `m1_relative_border_p21_d5_design`, `tmp/degree25_structural_probe`; certificate dirs `certificates/degree25_exact`, `degree25_global`, `degree25_tower`, `degree25_finite_module`, `degree25_direct_support`, `degree25_support_f4`, `degree25_rowrank`, `degree25_rank_k`, `degree25_molien`, `degree25_p25v`, `degree25_p25w`
- **sources:** `WORKORDER_CAS_HEADLINE.md` §5; `WORKORDER_CAS_HEADLINE_REVISED.md` §3; `WORKORDER_CAS_DECISION_AFTER_7FDBE42.md`/`_V2.md`; `WORKORDER_CAS_AFTER_5E72D8E.md`; `WORKORDER_CAS_T9_P25Z.md`; `WORKORDER_CAS_T10_P25W_C2.md`; `WORKORDER_CAS_T11_P25V_C3.md`; `DIRECTOR_HANDOFF.md`; `REMAINING_GOALS_NOTE.md`; `HANDOFF.md` repair table line 41; `CURRENT_PATHS.md` Ranking A item 1; `certificates/degree25_*/`
- **lenses:** GIT, CERT, HAND, RES, STAT, WORK (6/7)
- **confidence:** certain

---

## 26. Pfaffian — Pfaffian/Morita quaternionic descent bridge (Brauer index-2 / Hermitian gate)

- **aliases:** Attempt 1 (Pfaffian–Morita idempotent); SPEC task **E4**; HAND `R6` (F14-cone matched-covariant search), `R9` (nonsplit Brauer obstruction & quaternionic reduction), `R10` (idempotent / characteristic-cubic construction); RES `RES-07`; STAT "Pfaffian — quaternionic descent route"; CERT `certificates/pfaffian_point` (`BRIDGE_AUDIT.md`, `CFOSS_W1_INPUT.md`, `IDEMPOTENT_TO_KLEIN_POINT.md`, `quaternion_corner.json`)
- **tries:** positive construction + structural reduction — via Tschinkel–Zhang's Pfaffian bridge `X ↔ F14`, prove the generic projective Schur boundary class is nonzero of **period and index exactly 2** in `Br(K_proj)`, so `P(V6)`-twist is a nonsplit non-stably-rational Severi–Brauer fivefold; pass to 2-planes to get `SB_2(A_proj)=P²_{D_proj}` (rational), reducing the headline to a **common isotropic right `D`-line for five Hermitian forms**; construct explicitly a reduced-rank-two `σ`-self-adjoint idempotent `e=(a²-c₁(a)a+c₂(a)1)/c₂(a)` by solving `c₃(a)=0, c₂(a)≠0`; separately search for matched polynomial covariants landing in the `F14` Pfaffian cone.
- **method:** mixed (Brauer/algebra-with-involution theory + CAS)
- **status_labels:**
  - "now proved nonzero"; "generic Brauer class has period and index exactly two"; "anisotropic-member certificate is now impossible"; residual "common isotropic right D-line" gate "open" [HAND R9]
  - "every individual Hermitian member is isotropic... only simultaneous common-line isotropy remains open"; "no explicit K_proj coordinates, quaternion corner, or common isotropic line are known" [RES RES-07]
  - "Matched polynomial covariants into the F14 cone are excluded only through degree 15"; "degree 16 remains open for the Pfaffian target" (80-dim space, 1,313 necessary quadrics, solver times out without leading ideal) [HAND R6, RES RES-07]
  - "known abstractly to have a K_proj-point ... but its coordinates in the installed basis are not known" [HAND R10]
  - PRE/POST-REPAIR narrative precision: per `REPAIR.md` §13 this must be read strictly — the abstract `K_proj`-point refers "only to the auxiliary Pfaffian characteristic cubic in Sym(A,σ), **not** to a point of `F_{14,T}` or of the generic Klein twist"; the `FAIL-SCOPE` bridge audit is authoritative [HAND R10, STAT]
  - `FAIL-SCOPE`: "idempotent gives a point of auxiliary P^2_D, not of F_{14,T}" [WORK, Attempt 1]
- **current_state:** OPEN-AT-THE-COMMON-LINE-GATE — the Brauer reduction is a solid proved theorem and the anisotropic-member escape is closed; the abstract idempotent exists but its `K_proj` coordinates do not, and the bridge from it to a Klein point is scope-failed. This is the parent of entries 7 (C0–C3), 8 (C5/C6) and 6 (B).
- **runs:** `tmp/pfaffian_generic_schur_audit`, `pfaffian_explicit_descent`(+audit), `pfaffian_representation_alignment`, `pfaffian_25plus11_descent`(+audit), `quadratic_grassmannian_covariant`, `pfaffian_rank2_idempotent_attack`(+hostile audit), `pfaffian_binary_cubic_attack`(+geometric audit), `pfaffian_ternary_cubic_triage`(+hostile audit), `pfaffian_minimal_ternary_model`(+audit), `pfaffian_depressed_torsor_next`, `pfaffian_torsor_valuation_attack`, `pfaffian_depressed_alpha_r`, `pfaffian_alpha_local_kummer`; `tmp/fano14_twist`, `fano14_degree12`, `fano14_degree16`; Attempt-1 gates 1B (CFOSS w1 pin, implication-chain bridge audit), 1C (quaternion-corner reduction), 1D (exact coordinate extraction)
- **sources:** `certificates/pfaffian_point/`; `HANDOFF.md` "Strongest proved progress" item 7, "2026-07-29 structural KLS, Schur and Pfaffian update", "2026-07-30 latest Pfaffian closure"; `RESOLUTION.md` "2026-07-30 audited advances" item 3, "Other audited boundaries"; `SPEC.md` item 8 / task E4; `CURRENT_PATHS.md` 2026-07-30 item 1; `REPAIR.md` §13; `WORKORDER_FIVE_ATTEMPTS.md` (Attempt 1)
- **lenses:** CERT, HAND, RES, STAT, WORK (5/7)
- **confidence:** certain

---

## 27. Q / Q3 — Schur index-one descent obstruction / primitive quartic resolvent

- **aliases:** `Q_SCHUR_INDEX_ONE`, `Q_SCHUR_INDEX_ONE_DEGREE6_11_5_20260801_2A6C`, `Q_SCHUR_INDEX_ONE_EXACT_FRAME_20260801_8F3D`, `Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802`, `Q3_QUARTIC_RESOLVENT_STABLE_MAP`; GIT `Q` (`827f0da`, `4e44e73`)
- **tries:** negative/structural — decide a "Schur point" binary via a descent-obstruction audit on the Schur index-one locus (prove the index-one locus contains a rational point, or obstruct it via a valuation); when the standard descent-obstruction package proved insufficient, replace it with a **stable-cubic/resolvent descent from a primitive quartic resolvent** (Q3) and prove any resulting obstruction transfers to the headline.
- **method:** mixed (descent arithmetic + CAS)
- **status_labels:**
  - `Q-UNDECIDED` [DIR, `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/STATUS.md`; WORK]
  - "descent obstruction completed via valuation" [DIR, run `Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802`]
  - `Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS` (scoped pass); "Q3 preferred" as successor [WORK]
  - "PARTIAL (Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS) — Standard obstruction package insufficient — Q3 stable cubic/resolvent route remains" [STAT, 08-02 ledger]
  - `Q3-SCHUR-MONODROMY-PASS` [DIR, `goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/STATUS.md`]
  - `827f0da` 2026-07-31 "add descent obstruction close-out packet"; `4e44e73` "seal scoped descent obstruction close-out" [GIT]
- **current_state:** PARTIAL-OPEN — the standard obstruction package is audited and found insufficient (scoped PASS); Q3's Schur-monodromy gate PASSES but the quartic-resolvent descent has not produced a decision.
- **runs:** `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE`, `.../Q_SCHUR_INDEX_ONE_DEGREE6_11_5_20260801_2A6C`, `.../Q_SCHUR_INDEX_ONE_EXACT_FRAME_20260801_8F3D`, `.../Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802`; `goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP`
- **sources:** the five run dirs above; `REMAINING_GOALS_NOTE.md`; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #7; `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`; `CURRENT_PATHS.md` ~line 2187; git `827f0da`, `4e44e73`
- **lenses:** DIR, GIT, STAT, WORK (4/7)
- **confidence:** certain

---

## 28. R / R2 — Rational curves via Pfaffian / elliptic descent (Picard obstruction)

- **aliases:** `R_RATIONAL_CURVES`; WORK "R/M-stub" ("R/R2 prior terminals"); CERT `certificates/elliptic_lifting` (`PICARD_OBSTRUCTION.md`) — link plausible
- **tries:** negative obstruction — prove a descent obstruction for the Pfaffian elliptic quintic and its residual quartic components, i.e. rule out the relevant rational-curve constructions on the twist.
- **method:** mixed (elliptic/Picard arithmetic + CAS)
- **status_labels:**
  - `R2-DESCENT-OBSTRUCTED` [DIR, `goal_runs_after_35fa/R_RATIONAL_CURVES/STATUS.md`]
  - "prior terminals" [WORK, `REMAINING_GOALS_NOTE.md` "Already terminal" table: "...R/R2, M/M2 | prior terminals"] — WORK explicitly notes "no mathematical description is given in any document read under this lens"
- **current_state:** TERMINAL-OBSTRUCTED — the descent obstruction closes this rational-curve route.
- **runs:** `goal_runs_after_35fa/R_RATIONAL_CURVES`; `certificates/elliptic_lifting/` (candidate)
- **sources:** `goal_runs_after_35fa/R_RATIONAL_CURVES/STATUS.md`; `REMAINING_GOALS_NOTE.md`; `certificates/elliptic_lifting/PICARD_OBSTRUCTION.md`
- **lenses:** DIR, WORK (+CERT circumstantially) (2–3/7)
- **confidence:** high for the exit; medium for the `elliptic_lifting` identification (WP-E1 "elliptic Pic⁰ obstruction" under Path G is a competing owner of that certificate dir).

---

## 29. R0 — Canonical live-ledger refresh

- **aliases:** `R0_CANONICAL_REFRESH`; GIT anchor `0aecc89` 2026-08-02 "Klein cubic: add canonical refresh goal"
- **tries:** infrastructure — update and verify the canonical live-ledger state after the G2, V3 and B results and the post-pin refinements.
- **method:** document/CAS audit
- **status_labels:** `R0-CANONICAL-REFRESH-PASS` [DIR, `goal_runs_after_141f60/R0_CANONICAL_REFRESH/STATUS.md`]
- **current_state:** PASS — infrastructure only.
- **runs:** `goal_runs_after_141f60/R0_CANONICAL_REFRESH`
- **sources:** `goal_runs_after_141f60/R0_CANONICAL_REFRESH/STATUS.md`; git `0aecc89`, `b77b04c` (record V3 residue normal form in live ledger), `141f604` (fix live-ledger table formatting)
- **lenses:** DIR, GIT (2/7)
- **confidence:** certain

---

## 30. S19 — Degree-19 Cayley–Bacharach residual curve on the generic Schur twist

- **aliases:** Route S19; Attempt 3; `S19_MARKED_CURVE/CODEX_ROOT_20260801_7B4E`, `.../CODEX_ROOT_20260801_7B4E_CONT2`; HAND `R15` (unrestricted generic Schur twist positive-point construction); RES `RES-06`; CERT `certificates/schur_degree19` (grouped under "A" there); WORK `S19-Krylov`
- **tries:** positive construction — starting from the accepted degree-55 `D12`-stabilized closed point of **index one** on the generic Schur twist, build a `G`-equivariant, geometrically integral degree-19 genus-0 curve through it so the residual cubic intersection is a length-2 cycle, forcing a `K_proj`-point (⇒ `BR-SCHUR19-POS`); alternatively seek a torsor-dependent no-point obstruction.
- **method:** CAS (Hilbert function / Rao module / Quot scheme) + classical projective geometry
- **status_labels:**
  - "index one, but no rational point is currently known" [HAND R15; also `REPAIR.md` §14 narrative correction replacing the earlier "no rational point" phrasing that implied proved pointlessness]
  - "ACM Hilbert-function obstruction on one hyperplane choice; non-ACM branch and a `(3,5)` complete-intersection `Y` with Rao-ledger analysis left open"; "neither the no-quintic branch nor the special quintic-carrier branch is closed" [HAND R15]
  - "Both non-ACM branches remain"; "no geometrically integral ACM degree-19 curve works" (only for one descended hyperplane-selected point); "this is an exact non-ACM frontier, not a nonexistence theorem" [RES RES-06]
  - `S19-UNDECIDED` [DIR, `goal_runs_after_35fa/S19_MARKED_CURVE/.../STATUS.md`]
  - "implication chain PASS; both Rao branches remain live; STOP-3" [WORK]; targets `P-A`/`P3`/`S19-POSITIVE` **not reached**
  - "no worker is dispatched this round unless T10, P25W, and C2 all stop" [WORK, `WORKORDER_CAS_T10_P25W_C2.md` §6]
- **current_state:** UNDECIDED — the ACM branch is excluded for one hyperplane choice; both non-ACM Rao branches remain live; deprioritized behind the T/P25/C tracks.
- **runs:** `goal_runs_after_35fa/S19_MARKED_CURVE/CODEX_ROOT_20260801_7B4E`, `.../CODEX_ROOT_20260801_7B4E_CONT2`; `tmp/schur_unrestricted_point_attack`, `schur_degree19_structural_design`(+audit), `schur_degree19_nonacm_attack`(+audit); Attempt 3 gates 3B–3D; S19.1–S19.3 (universal split-hyperplane marked orbit; relative ideal/resolution; marked Quot schemes for the two Rao branches); `certificates/schur_degree19/` (`marked_hilbert`, `quintic_carriers`, `rao_resolutions`, `betti_tables`, `IMPLICATION_AUDIT.md`)
- **sources:** the two `S19_MARKED_CURVE` run dirs; `certificates/schur_degree19/`; `HANDOFF.md` "2026-07-30 audited delta" item 2; `RESOLUTION.md` "2026-07-30 audited advances" item 2; `SPEC.md` ~109–144; `WORKORDER_FIVE_ATTEMPTS.md` (Attempt 3); `WORKORDER_CAS_HEADLINE.md` §7; `WORKORDER_CAS_HEADLINE_REVISED.md` §6.2; `REPAIR.md` §14
- **lenses:** DIR, CERT, HAND, RES, WORK (5/7)
- **confidence:** certain
- **possibly-same-as:** entry 1 (A). CERT and WORK treat A and S19 as one programme.

---

## 31. Schur — Six-dimensional Schur projective-source route

- **aliases:** SPEC task **E2**; "projective source"; "degree-8 rational frame"; "unrestricted Schur route"; HAND `R5` (V6→W constant-coefficient landing search), `R14` (ternary-plane genus-one fibration / no-section theorem); RES `RES-05`; STAT "Schur source"
- **tries:** positive construction — find a rational `G`-equivariant map `P(V6)⇢X` from the six-dimensional Schur representation of `SL₂(11)`; by the projective-source lemma any such map is automatically dominant and, with index-2 Brauer splitting plus quadratic descent, solves the headline. Includes a degree-8 Reynolds-covariant all-degree normal form and a structural study of the ten coordinate-line genus-one fibrations.
- **method:** CAS (constant-coefficient exhaustive solves) + Picard/fibration theory
- **status_labels:**
  - "Complete constant-coefficient landing loci are empty in degrees 4, 6, 8, 10"; degree 12 "remains open"; "Finite scans still cannot prove a negative answer" [HAND R5]
  - degree 12 reconstructed (dim 48) but only decomposable/low-primitive-support slices excluded; full-rank char-23 solve (rank 1,124) times out [HAND R5]
  - "the projective-source route is not a resolution"; "the exact solve timed out... no leading output" [RES RES-05, SPEC]
  - Fibration theorem: "The former `ξ_ij=0`/3-descent section target is retired"; each ambient-line projection is a genus-one fibration with `Pic=Z·H⊕Z·E`, fibre-degree image `3Z`, exact index/period 3, hence **no rational section**; "This is not a no-point theorem" [HAND R14]
  - "do not confuse a no-section theorem with a no-point theorem" [STAT, `CURRENT_PATHS.md` Ranking B item 4]
  - Post-repair: "the generic Schur twist has index one, but no rational point is currently known" [STAT/REPAIR.md §14]
- **current_state:** OPEN-STALLED — degrees 4/6/8/10 empty, degree 12 blocked by a terminal solver nonverdict; the genus-one fibration no-section theorem is real but does not obstruct points.
- **runs:** `tmp/projective_source`, `tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`, `tmp/projective_source_degree12*`, `tmp/step4_degree12_solver_terminal`, `tmp/schur_ternary_planes`, `tmp/schur_structural_routes`, `tmp/schur_fibration_picard_obstruction`
- **sources:** `RESOLUTION.md` "Six-dimensional projective-source route"; `SPEC.md` item 9 / task E2; `HANDOFF.md` "Strongest proved progress" items 5 and 9; `CURRENT_PATHS.md` §2 and Ranking A/B; `REPAIR.md` §14
- **lenses:** HAND, RES, STAT (3/7)
- **confidence:** certain

---

## 32. T — T-track: fold-algebra / target-branch normalization and 3-primary index-three obstruction

- **aliases:** Path T; T1–T4; T2, T2R (T2R.1–T2R.5), T3, T3A, T6 (T6.0–T6.3), T8 (T8.1–T8.4), T8n1, T9 (T9.0–T9.3), T10 (T10.0–T10.3), T11 (T11.0–T11.3), T11b; `T_TARGET_BRANCH`; `T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER`; Attempt 2; Path B "upstairs simple fold" (ELO ten paths); WP-T1; HAND `R11`/`R12`; RES `RES-25`; CERT buckets `T` (`fold_*`) and (contested) `B` (`target_branch_*`)
- **tries:** negative obstruction — prove the normalized target branch / fold algebra `S_G=(B[u]/(P,P_u))[Σ⁻¹]` retains a residue-degree-one branch of Cramer index 3, i.e. `(Cl/Pic)[3]=0` on a normalized cubic-discriminant-contact model, giving a pointless versal Klein twist (⇒ `BR-T-NEG`). Chain: finite birationality `S→B`; Serre normality (`S₂`+`R₁`); conductor/discriminant contact mod 3; class-group assembly; later reframed to normalize `S_G` directly (avoiding raw elimination of the degree-43 target-branch hypersurface) via subresultant / Hensel / binodal analysis.
- **method:** CAS (msolve, Macaulay2, Singular; saturation, subresultants, RUR)
- **status_labels:**
  - PRE-REPAIR (historical): `T-NONNORMAL` proved, `dim Sing_S=2` proved, terminal marker `FOLD_NORMALIZATION_T2_VERIFIER_ACCEPT` treated as proof [STAT/REPAIR.md]
  - POST-REPAIR: "Path T: `T-BIRATIONAL` — retained at its stated generic/open theorem boundary"; "`T-NONNORMAL` — **suspended**; not proved by the current T2 packet; pending T2R gate"; "`dim Sing_S = 2` — **unproved**; current exact cuts do not establish it; pending T2R"; required interim label `T2-UNDECIDED pending exact saturated same-open dimension proof`; verifier explicitly must **not** be consumed as proof; "'normalization defect is divisorial' — unproved"; "'Ann_B(S/B) is the normalization conductor' — false notation; conductors separated" [HAND R12, RES RES-25, STAT/REPAIR.md §§1–3, §15]
  - `T2R-UNDECIDED`: `S₂` proved, `dim Sing(S_G) ≤ 2`, `R₁` undecided [WORK, `DIRECTOR_HANDOFF.md`]; `7fdbe42` 2026-07-31 "T2R.4 PASS (factors installed); T2R.5 still T2R-UNDECIDED" [GIT]
  - `T2-ROUTE-REFUTED` [DIR, `goal_runs_after_35fa/T_TARGET_BRANCH/STATUS.md`]
  - `17e0e5f` 2026-07-31 "Path T2 — exit T-NONNORMAL; S2 holds, R1 fails" [GIT]; `d96b408` "Path T post-Elo — Gate T1 T-BIRATIONAL"
  - `T60-UNDECIDED` [WORK, `DIRECTOR_HANDOFF.md` §8; GIT `11474f5`]
  - `T8-S1-UNDECIDED` (`dc43a86`); `T8-S1-NONUNIT-ANALYTIC` confirmed (`7866c68`); `T9-HENSEL-NONUNIT-SEALED`; `T8-N1` Jacobian correction sealed (`2645c91`) [GIT, WORK]
  - `T-BRANCH-NONNORMAL` (target branch has a divisorial binodal locus); `T10-BINODAL-NO-3-DEFECT`; `T10.0` sealed, `T10.1 UNDECIDED` (`19e9490`); `T11.0` simple point sealed, `T11.1 UNDECIDED` (`faf6169`); `T11b Route C obstructed` (`715faf4`) [GIT, WORK]
  - `T10-FOLD-HEIGHT1`/`T11-FOLD-HEIGHT1` sought but undecided [WORK]
  - `T3-UNDECIDED`; "Local-runner portfolio only; fixed-frame; **not headline after B-BRIDGE-REFUTED**" [WORK, `REMAINING_GOALS_NOTE.md`]; ledger: T3 `AUXILIARY OPEN — Fixed-frame/non-headline after B — Local runner only` [STAT]
  - "the strongest developed negative route... needed facts are finite and local"; "Ordinary Picard theory is complete... Neither its vanishing nor a dangerous class has been proved" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §4 Rank3, §2.4]
  - Ledger: T/T2 bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger]
- **conflict (preserved, instruction 4a):** the 08-02 offline ledger marks T/T2 `TERMINAL`, but `REPAIR.md` holds the mandatory **T2R gate pending** with no certified exit (`T2R-NONNORMAL`/`T2R-NORMAL`/`T2R-UNDECIDED` — none reached), T3 is blocked from consuming `T-NONNORMAL` until T2R exits, and `7fdbe42` leaves `T2R.5` explicitly `T2R-UNDECIDED`. `REPAIR.md` and the run-level artifacts outrank the ledger: the T-track is **suspended-pending-T2R**, not proved terminal. Separately, DIR's `T2-ROUTE-REFUTED` and GIT's `T-NONNORMAL` exit describe the same T2 packet whose conclusion REPAIR later suspended.
- **conflict (identity):** CERT assigns `certificates/target_branch_global/mod3/t10` to route **B**; GIT/WORK tie `target_branch_t10` to the T10 track and HAND R11/R12 place "target branch" inside the Path T/fixed-frame programme. Recorded in both entries; not merged.
- **current_state:** CONFLICT → best reconciliation: SUSPENDED-PENDING-T2R. `T-BIRATIONAL` retained; `T-NONNORMAL` and `dim Sing_S=2` suspended/unproved; sub-gates T6/T8/T9 sealed at analytic non-unit results; T10/T11 sealed with `.1` stages undecided; T3 demoted to non-headline after `B-BRIDGE-REFUTED`. Not terminal despite the 08-02 ledger.
- **runs:** `goal_runs_after_35fa/T_TARGET_BRANCH`; T1–T4 (POST_ELO); T3.1–T4 (HEADLINE); T2R.4–T2R.5 (REVISED); T6.0–T6.3; T8.1–T8.4; T9.0–T9.3; T10.0–T10.3 (+ `WORKORDER_CAS_T10_P25W_C2_CORRECTION.md`); T11.0–T11.3; T3A local RUR exhaustiveness (`c9d75e1`); T3 split into local worker goals (`b49fc81`, `74045be`, `823beb1`); WP-T1; Path B B1–B4 upstairs normalization; certificate dirs `certificates/fold_normalization`, `fold_normalization_t2r`, `fold_normalization_t3`, `fold_decision_t6`, `fold_decision_t8`, `fold_decision_t8n1`, `fold_binodal_t9`, `fold_t11`, `fold_t11b`; (contested) `certificates/target_branch_global`, `target_branch_mod3`, `target_branch_t10`
- **sources:** `REPAIR.md` Parts I, VI, §§1–3, §6, §15; `WORKORDER_CAS_HEADLINE.md` §3; `WORKORDER_CAS_HEADLINE_REVISED.md` §4; `WORKORDER_CAS_DECISION_AFTER_7FDBE42.md`/`_V2.md`; `WORKORDER_CAS_AFTER_5E72D8E.md`; `WORKORDER_CAS_T9_P25Z.md`; `WORKORDER_CAS_T10_P25W_C2.md`(+`_CORRECTION.md`); `WORKORDER_CAS_T11_P25V_C3.md`; `WORKORDER_POST_ELO_CONSTRUCTION.md` (Path T); `WORKORDER_ELO_TEN_PATHS.md` (Path B); `WORKORDER_STRATA_LIFTING_BLOCKERS.md` Part V; `DIRECTOR_HANDOFF.md`; `DIRECTOR_REVIEW_AFTER_BD610A.md`; `REMAINING_GOALS_NOTE.md`; `CURRENT_PATHS.md` lines 19–90; `HANDOFF.md` repair tables; `RESOLUTION.md`/`SPEC.md` repair tables; `certificates/fold_*/`
- **lenses:** DIR, GIT, CERT, HAND, RES, STAT, WORK (7/7)
- **confidence:** certain

---

## 33. V / V2 / V3 / V4 (+G5) — Genuine valuation / residue-twist obstruction

- **aliases:** `V_GENUINE_VALUATION`, `V3_VALUATION_RESIDUE_CLOSEOUT_20260802`, `V4_SIMULTANEOUS_ODD_NORMALS_20260802`, `G5_FULL_RESIDUE_CUBICS`; WORK "V/G5 — residue twist f5/f6 valuation obstruction"; STAT "V — residue obstruction"; GIT `V3`, `V4`
- **tries:** negative obstruction — analyze divisorial valuations on the twist and test whether a place is **transferable** to the genuine (non-fixed-frame) twist via inertia; decide pointlessness of the full residual `f5`/`f6` twist (a valuation/residue construction tied to the degree-11 torus structure) rather than of finite proxies; then classify simultaneous odd normal coefficients and test the trisection genus-two quotient approach (V4).
- **method:** CAS + valuation-theoretic argument
- **status_labels:**
  - `V2-FIXED-FRAME-PLACE-NONTRANSFERABLE` [DIR, `goal_runs_after_35fa/V_GENUINE_VALUATION/STATUS.md`]
  - `V-UNDECIDED`; `V3-RESIDUE-NORMAL-FORM-PASS` ("mechanics closed; residual is residue binaries only") [WORK, `REMAINING_GOALS_NOTE.md`]
  - "PARTIAL (V3-RESIDUE-NORMAL-FORM-PASS) — Mechanics closed, residue binaries remain — Feeds G5/H6" [STAT, 08-02 ledger]
  - `G5-F5-CUBIC-MODEL-PASS`, `G5-F6-CUBIC-MODEL-PASS` [DIR, `goal_runs_after_141f60/G5_FULL_RESIDUE_CUBICS/STATUS.md`]
  - `V4-SIMULTANEOUS-CLASSIFICATION-PASS`, `V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED` [DIR, `goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/STATUS.md`]
  - `ebb5769` 2026-08-02 "genus-two quotient classification for V4 normal maps"; `bc56247` "Record V4 simultaneous-normal theorem boundary"; `04d1d1c` "Classify simultaneous V4 odd normal maps"; `b77b04c` "record V3 residue normal form in live ledger" [GIT]
- **conflict (label collision):** GIT's "V2" tokens (`11474f5` "V2 Track T", `dc43a86` "V2 Track T8", `6096429` "V2 Track P25Y", `1ad97cf` "V2 Track C0", `5e72d8e` "V2 Track P25X") denote the *version-2 work order* (`WORKORDER_CAS_DECISION_AFTER_7FDBE42_V2.md`), **not** this route. DIR's `V2-...` is the exit label of `V_GENUINE_VALUATION`. Do not merge.
- **current_state:** PARTIAL — the fixed-frame place is proved non-transferable and the residue normal form / f5-f6 cubic models PASS; V4's simultaneous-normal classification PASSES but its local-path headline route is REFUTED; only residue binaries remain.
- **runs:** `goal_runs_after_35fa/V_GENUINE_VALUATION`; `goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802`; `goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802`; `goal_runs_after_141f60/G5_FULL_RESIDUE_CUBICS`
- **sources:** the four run dirs above; `REMAINING_GOALS_NOTE.md`; `GOALS_NEXT_10_ROUTES_2026-08-02.md` #6; `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`; git `b77b04c`, `04d1d1c`, `bc56247`, `ebb5769`
- **lenses:** DIR, GIT, STAT, WORK (4/7)
- **confidence:** certain

---

## 34. WP-strata — Exact stabilizer strata & normal-cone transition necessity machine

- **aliases:** WP0–WP7; WP-R0, WP-L1, WP-L2, WP-E1, WP-B1, WP-T1, WP-H1, WP-Z, WP-4A–4E, WP-5, WP-6; `WORKORDER_STRATA_MACHINE.md`, `WORKORDER_STRATA_LIFTING_BLOCKERS.md`; CERT `certificates/strata`, `transitions`, `transition_repair`, `lifting`, `border_support`; GIT `WP`
- **tries:** infrastructure/negative — build a portable characteristic-zero stabilizer stratification of `P⁴` and `X`, tangent/normal character decorations, local transition modules, and a global inverse-limit ("normal-cone necessity theorem") as an **all-degree necessary-condition screen** for any hypothetical landing covariant; feeds Path G.
- **method:** CAS
- **status_labels:**
  - "Problem E remains open" (file-wide) [WORK, `WORKORDER_STRATA_MACHINE.md`]
  - Environment addendum: GAP / SageMath / Singular / PARI / Julia "NOT INSTALLED", blocking WP-1/WP-3 as literally specified [WORK]
  - type-I/type-II `V4` incidence inconsistency in the supplied `strata.md` flagged **unresolved** [WORK]
  - `d9cadc3` 2026-07-30 "WP-Z director gate report — ranking 4"; `ced3153` "WP-6 STOP with formulation"; `db25516` "WP-H1 Hodge-center screen" [GIT]
  - CERT: `transition_repair/CATEGORY_AUDIT.md`, `category_repaired.json` (WP-R0 category repair); `transitions/{c3_lines,d12_binary_line,involution_plane,point_links,v4_fixed_line}`; `lifting/OBSTRUCTION_TOWER.md`, `lifting/families/{based_minus_lines_odd_m, residual_e1_swap_both, residual_e_ge7_generic_swap_both}`; `border_support/`
- **current_state:** INFRASTRUCTURE-PARTIAL — the stratification, local transition modules, global transition diagram, and border/Fitting integration are built and checked in; WP-6 exited STOP with a formulation; the machine produced no all-degree obstruction.
- **runs:** WP0 input audit; WP1 exact stratification; WP2 tangent/normal characters; WP3 marked S3 geometry; WP4A–4E local transition modules; WP5 global transition diagram (exits N1/N2/N3/P); WP6 border/Fitting integration; WP7 theorem assembly; WP-R0 category repair; WP-L1 universal polar expansion; WP-L2 relative obstruction tower; WP-E1 elliptic `Pic⁰` obstruction; WP-B1; WP-T1; WP-H1
- **sources:** `WORKORDER_STRATA_MACHINE.md`; `WORKORDER_STRATA_LIFTING_BLOCKERS.md`; `certificates/strata/`, `certificates/transitions/`, `certificates/transition_repair/`, `certificates/lifting/`, `certificates/border_support/`, `certificates/GLOBAL_TRANSITION_DIAGRAM.md`, `certificates/LOCAL_TRANSITION_MODULES.md`, `certificates/MARKED_S3_GEOMETRY.md`, `certificates/BORDER_SUPPORT.md`
- **lenses:** GIT, CERT, WORK (3/7)
- **confidence:** certain

---

## 35. xCD — Plane-section flex / 3-descent route

- **aliases:** "xCD plane cubic"; `F(a·x+b·C+c·D)=0`; SPEC task **E3** partly; HAND `R21` (generic-slice census & Klein-sextic factoriality), `R22` (invariant-module multiprime radical experiment), `R23` (generic Čech / first-descent `E[3]` Kummer construction), `R24` (class-image / Zariski-descent Rees-lattice attack), `R25` (residue-class gate at `f6=0` / Jung–Saito base factoriality); RES `RES-04`
- **tries:** positive/negative — decide whether the explicit characteristic-zero ternary cubic `F(a·x+b·C+c·D)=0` (a distinguished Schur-derived plane section of the generic twist) has a `K_proj,C`-point, via genuine elliptic 3-descent (flex algebra, `E[3]`-Kummer class `α_R` built by a typed nested-étale Čech circuit) and via singularity/factoriality analysis of the associated total space `C6` over the Klein sextic base `H6=V(f6)`.
- **method:** mixed (descent arithmetic + heavy CAS)
- **status_labels:**
  - "the original projective xCD plane cubic has no `K_proj,C`-point" (proved for this plane) [RES RES-04]
  - "This closes only the plane section `F(a*x+b*C+c*D)=0`, not the full generic twisted Klein cubic threefold; the headline remains open" [RES RES-04, SPEC E3]
  - "This closes the construction `F(a·x+b·C+c·D)=0`; it does not prove that the full generic twisted Klein cubic threefold has no point. The headline remains open" [HAND R21]
  - `Cl(H6)=Pic(H6)=Z[O(1)]`, `def(H_6)=0` via the Jung–Saito defect formula; horizontal Weil degree image forced to `3Z` [HAND R21/R25, STAT]
  - Čech/Kummer component: "The general-slice theorem now proves that this component has no `K_proj,C`-point, so that distinguished component is closed negatively. This is not an obstruction to points elsewhere" [HAND R23]
  - Rees/class-image sub-attack: "retained as a failure ledger for an alternative proof of that plane-section theorem. It is no longer a live gate"; "The proposed degree-one Zariski Morse chart is now refuted"; "do not continue a formal jet ladder" [HAND R24]
  - Multiprime radical experiment: "still failed withheld-prime rational reconstruction"; "This makes no QQ support claim and is retired for the census" [HAND R22]
  - "refuted and retired" [WORK, `WORKORDER_ORDER12.md` line 4]
- **current_state:** CLOSED-SCOPED-NEGATIVE — the distinguished plane component provably has no point; explicitly not a headline obstruction; the route is retired.
- **runs:** `tmp/xcd_invariant_fibre_discriminants`, `xcd_repeated_factor_incidence`, `xcd_singular_curve_enumeration_audit`, `xcd_general_slice_completion`, `xcd_actual_class_image`, `xcd_picard_restriction`, `xcd_singular_locus_bound`, `xcd_invariant_module_multiprime`, `xcd_control_next`, `xcd_generic_cech_next`, `xcd_first_descent_next`, `xcd_genuine_descent`, `xcd_nonzero_kummer`, `xcd_total_normality`, `xcd_local_class_defect`, `xcd_class_globalization_next`, `xcd_zariski_descent_gate`, `xcd_formal_mf_all_order`, `xcd_formal_algebraization_audit`, `xcd_class_image_attack`, `xcd_ca_class_group`, `xcd_algebraic_null_polar`, `xcd_zariski_morse_chart`, `xcd_discriminant_divisor`, `xcd_gauge_divisors`, `xcd_residue_class_gate`, `xcd_arithmetic_next`, `xcd_descent_algebra`, `xcd_invariant_field`
- **sources:** `RESOLUTION.md` "The xCD flex and 3-descent audit"; `SPEC.md` task E3; `HANDOFF.md` "2026-07-29 xCD completion and Fable update", "2026-07-30 audited delta" item 3; `CURRENT_PATHS.md` §4 and 2026-07-28 items 4,5,7; `WORKORDER_ORDER12.md`
- **lenses:** HAND, RES, STAT, WORK (4/7)
- **confidence:** certain

---

## 36. theta11 — Level-11 theta/Schwarz modular construction

- **aliases:** `tmp/theta11_test`; "Kopeliovich–Sanabria"; HAND `R26`; RES `RES-14`
- **tries:** positive construction — test whether the July-2026 level-11 theta-series / Schwarz-map construction, matched to the repository's exact 5-dimensional Klein representation after monomial conjugacy, yields a Klein-cubic parametrization / landing map.
- **method:** CAS (series expansion)
- **status_labels:**
  - "does not lie on the Klein cubic: `F(HΦ₁₁)=ξ₄₄⁵u¹¹+O(u⁹⁹)`... Close this as a headline path" [HAND R26]
  - "This particular recent modular lead is therefore closed"; "all 25 classical Hessian-minor tests are nonzero" [RES RES-14]
  - "Do not pursue the level-11 theta/Schwarz curve as a Klein-cubic parametrization" [STAT, `CURRENT_PATHS.md` Deprioritized-work list]
- **current_state:** CLOSED-REFUTED.
- **runs:** `tmp/theta11_test/theta11_test.py`
- **sources:** `RESOLUTION.md` "2026-07-28 exact advances" item 5; `HANDOFF.md` "2026-07-30 audited delta" closing bullet; `CURRENT_PATHS.md` 2026-07-29 item 5
- **lenses:** HAND, RES, STAT (3/7)
- **confidence:** certain

---

## 37. ED-REDUCTION — Exact reduction: X is G-unirational ⟺ ed_C(G)=3

- **aliases:** HAND `INF1`; RES `RES-23`; "essential-dimension reduction"; `tmp/step4_essential_dimension`
- **tries:** infrastructure/positive framework — via Prokhorov's Cremona-rank-3 two-model classification, the Tschinkel–Zhang twisted Pfaffian bridge to `F14` (index ≤2 Brauer class), and a "quadratic descent for cubics" lemma, prove the headline equivalent to the single numeric dichotomy `ed_C(G) ∈ {3,4}`, i.e. to whether the generic projective torsor `C_gen` has a `K_proj`-point.
- **method:** analytic
- **status_labels:**
  - "This proves the theorem" — proved unconditionally [RES RES-23]
  - "This exact reduction still does not choose between the two values, so the headline remains open" [RES RES-23, SPEC]
  - "none of the audited local, Brauer, Amitsur, or standard stable-cohomology invariants decides whether it has a point"; headline "OPEN" [HAND INF1]
- **current_state:** PROVED-INFRASTRUCTURE — the single most load-bearing reduction in the problem; decides nothing on its own.
- **runs:** `tmp/step4_essential_dimension/` (`REPORT.md`, `verify_reductions.py`)
- **sources:** `RESOLUTION.md` "Exact reduction to essential dimension"; `SPEC.md` "There is also a stronger unconditional reduction..."; `HANDOFF.md` "Strongest proved progress" item 1
- **lenses:** HAND, RES (2/7)
- **confidence:** certain

---

## 38. INV-INFRA — Exact action & certified invariant-theory infrastructure (E0)

- **aliases:** SPEC task **E0**; HAND `INF2`; RES `RES-24`; `certificates/exact_weil_check.py`, `exact_molien.py`, `exact_covariants_check.py`
- **tries:** infrastructure — fix exact cyclotomic matrices for `G→GL(W)` (660 elements), verify faithfulness and Klein-cubic invariance, compute exact Molien dimensions, and construct an explicit generic torsor / Hilbert-90 model; Sylow/abelian fixed loci.
- **method:** CAS
- **status_labels:**
  - "This is infrastructure, not a resolution" [RES RES-24, SPEC E0]
  - "certified/checked-in; no obstruction/positive claim itself" [HAND INF2]
  - underlying facts certified (exact cyclotomic generator matrices, full 660-element Cayley-graph check, invariance of `F` verified) [RES RES-24]
- **current_state:** CERTIFIED-INFRASTRUCTURE — underlies every other route.
- **runs:** `certificates/exact_weil_check.py`, `certificates/exact_molien.py`, `certificates/exact_covariants_check.py`, `certificates/generic_covariant_basis_check.py`
- **sources:** `SPEC.md` task E0; `RESOLUTION.md` "Exact action"; `HANDOFF.md` "Strongest proved progress" item 2 and "Verification" §; `certificates/CHECKS.md`
- **lenses:** HAND, RES (2/7)
- **confidence:** certain

---

## 39. FRAME — Generic covariant frame (x, C, D, E, K)

- **aliases:** HAND `INF3`; RES `RES-03`; "explicit generic-twist frame"; "all-degree self-covariant normal form"
- **tries:** infrastructure/positive partial construction — build an explicit Hilbert-90 trivialization of the generic twisted ambient five-space from primitive covariants `x, C, D, E, K` of degrees 1,4,5,6,7 (determinant `Δ` nonzero at a sample point), writing `F(Ma)=0` over `C(W)^G` and reducing the generic-twist point problem to one cubic `Φ(a)=0` in five variables over `K_proj = C(P(W))^G`; exclude all ten frame coordinate lines as trivial roots.
- **method:** CAS
- **status_labels:**
  - "This completes the generic ambient-space descent explicitly. It does not produce a nonzero `a∈K_0^5` with `Φ(a)=0`; that is precisely the remaining generic-twist point problem" [RES RES-03]
  - "explicitly trivializes"; ten coordinate lines "excluded"; frame point must use ≥3 coordinates [HAND INF3]
  - Sub-results: ten smooth genus-one three-coordinate frame planes; degree 11–14 landing-ansatz exclusion; degree 15 no verdict; rational-flex exclusion on all ten planes [RES RES-03]
- **current_state:** CERTIFIED-INFRASTRUCTURE — the frame is the standing coordinate system for entries 6, 17, 35, 40.
- **runs:** `certificates/generic_frame_lines_check.py`, `generic_frame_planes_check.py`, `generic_frame_planes_specialization.py`, `flex_cover_check.py`, `flex_line_scan.py`
- **sources:** `RESOLUTION.md` "Explicit generic-twist frame" and "All-degree self-covariant normal form"; `HANDOFF.md` "Strongest proved progress" item 3
- **lenses:** HAND, RES (+CERT circumstantially) (2–3/7)
- **confidence:** certain

---

## 40. PDE-FLAT — K_proj flat-connection all-degree module PDE

- **aliases:** HAND `INF4`; STAT "Essential-dimension flat-connection / all-degree module PDE"; `det[a,∇₁a,∇₂a,∇₃a,∇₄a]=0`
- **tries:** degree-free reformulation of the KLS landing problem — prove algebraic independence of the five primaries `f3,f5,f6,f8,f11`, install a free Hironaka basis (12 secondaries), the full multiplication table and a `τ = f3²/f5`-normalized degree-12 model, define a flat connection `∇` on `K_proj⁵`, and recast the whole headline as solving (or proving universal nonvanishing of) the rational PDE `det[a,∇₁a,…,∇₄a]=0` over `P⁴(C(P(W))^G)` — removing the artificial polynomial-degree parameter used everywhere else.
- **method:** mixed (CAS arithmetic circuits + analytic PDE)
- **status_labels:**
  - "certified"; "No solution or universal-nonvanishing theorem is known"; 121 constant / 440 Hironaka-linear ansätze and 15 gradient-cross-product covariants "fail to land" [HAND INF4]
  - infrastructure complete (`[K_proj:P0]=12`; rank-12 Hironaka basis; connection matrices as exact arithmetic circuits); "the full rational PDE remains unsolved" [STAT]
  - explicit `S5`-module counterexample shows finite covariant generation gives no all-degree cutoff — "no uniform bound on every solution can be the missing reduction" [STAT]
- **current_state:** OPEN-REFORMULATION — the cleanest degree-free statement of the headline; unsolved, and the finite-generation shortcut is provably unavailable.
- **runs:** `tmp/kproj_arithmetic/`, `tmp/kproj_connection/`, `tmp/covariant_module/`, `tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`, `tmp/ed_binary_attack/verify_all_degree_module_pde.py`, `tmp/step4_essential_dimension/`
- **sources:** `HANDOFF.md` "Strongest proved progress" item 6; `CURRENT_PATHS.md` §1 tail (lines 1863–1901), Ranking B item 2
- **lenses:** HAND, STAT (2/7)
- **confidence:** certain

---

## 41. VOISIN — Voisin C^[3] / X^[3] very-versality pullback

- **aliases:** HAND `R28`; RES `RES-12`; "Voisin C^[3]"
- **tries:** positive construction — use Voisin's rank-2-vector-bundle construction (a dominant map from a product of Grassmannians to the Hilbert scheme `X^[3]` of 3 points on the Klein cubic), proving `C^[3]` is `G`-very-versal, and try to equivariantly select one of the three points to reduce to `X`.
- **method:** analytic
- **status_labels:**
  - "`C^[3]` is `G`-very-versal" (proved positive infrastructure) [RES RES-12]
  - "gives a source birationally fibered over C and is therefore **circular** for the missing point" [HAND R28]
  - "This nine-dimensional variety does not improve the essential-dimension bound and does not select one of the three points... the apparent selection step is circular" [RES RES-12]
  - Theorem boundary: "Very versality of `C^[3]` does not give very versality of `C`: no rational equivariant operation selecting one point of the degree-three cycle is known" [HAND R28]
- **current_state:** CLOSED-CIRCULAR — the versality is real; the selection step is circular.
- **runs:** `tmp/ed_binary_attack/REPORT.md`
- **sources:** `RESOLUTION.md` "Six-dimensional projective-source route" closing paragraph; `SPEC.md` item 10 end and pitfalls; `HANDOFF.md` "Strongest proved progress" item 10
- **lenses:** HAND, RES (2/7)
- **confidence:** certain

---

## 42. ZC-SECANT — Zero-cycle / finite-orbit / secant chord-tree construction

- **aliases:** HAND `R27`; RES `RES-13`; "Finite-orbit and secant audit"; "zero-cycle descent"
- **tries:** positive classical-geometry construction — build an equivariant point from orbit configurations (`C11, C5, V4, C3` fixed loci; the 220-point orbit and its complete-intersection links) using secant/chord (third-intersection) constructions, iteratively reducing a `G`-orbit to a single point or a pair.
- **method:** analytic + CAS enumeration
- **status_labels:**
  - "these are finite-construction no-gos, not an exclusion of continuous covariants"; "A torsor-dependent semilinear degree-74 curve remains a precise positive target" [HAND R27]
  - "This excludes only finite-orbit binary folding. It does not exclude a continuous covariant mixing an entire orbit at once"; "no such binary chord tree reaches a singleton or a two-point orbit" [RES RES-13]
  - "A torsor-dependent semilinear degree-74 interpolation curve would evade this argument and would solve the problem, but constructing it is another form of the unresolved varying-covariant problem" [RES RES-13]
- **current_state:** CLOSED-FOR-FINITE-CONSTRUCTIONS — binary chord folding is excluded; the degree-74 semilinear interpolation curve remains a named open positive target.
- **runs:** `tmp/zero_cycle_descent`
- **sources:** `RESOLUTION.md` "Finite-orbit and secant audit"; `HANDOFF.md` "Strongest proved progress" item 8, "Best re-entry points" (Orbit constructions)
- **lenses:** HAND, RES (2/7)
- **confidence:** certain

---

## 43. GROSS-POPESCU — Modular-moduli reinterpretation

- **aliases:** RES `RES-15`; `A^lev_11` level-structure moduli
- **tries:** examine whether Gross–Popescu's identification of the level-11 abelian-surface moduli space `A^lev_11` with the Klein cubic (with matching change-of-level `G`-action) furnishes an equivariant parametrization.
- **method:** analytic (literature)
- **status_labels:** "This does not furnish an equivariant parametrization... No linear or already very versal source for the deck action is produced, so the modular interpretation **restates rather than solves** the current problem" [RES RES-15]
- **current_state:** REJECTED — restates the problem.
- **runs:** none named
- **sources:** `RESOLUTION.md` "Other audited boundaries" bullet
- **lenses:** RES (1/7) — **single-lens**
- **confidence:** certain

---

## 44. KRESCH-TSCHINKEL — Integral decomposition of the diagonal / equivariant Burnside

- **aliases:** RES `RES-16`
- **tries:** test whether equivariant integral-decomposition-of-the-diagonal / equivariant Burnside-invariant machinery supplies a negative obstruction.
- **method:** analytic (literature)
- **status_labels:** "does not furnish a new obstruction here... failure of decomposition would not obstruct mere `G`-unirationality. Conversely, its existence would not prove `G`-unirationality" [RES RES-16]
- **current_state:** REJECTED — wrong direction of implication in both senses.
- **runs:** none named
- **sources:** `RESOLUTION.md` "Other audited boundaries" bullet
- **lenses:** RES (1/7) — **single-lens**
- **confidence:** certain

---

## 45. AMITSUR — Universal-torsor / higher Amitsur cohomological obstruction (E3)

- **aliases:** SPEC task **E3**; HAND `R30`; RES `RES-17`
- **tries:** negative obstruction — seek a cohomological obstruction (universal-torsor class, higher Amitsur groups, Brauer group of twists) to `G`-unirationality.
- **method:** analytic
- **status_labels:**
  - "the higher Amitsur route is **exhausted** here because `Pic(X)=Z[H]` and `O_X(1)` is honestly `G`-linearized, so the relevant groups vanish after restriction to every subgroup" [HAND R30]
  - "The ordinary and all higher Amitsur obstructions vanish, even after restriction to subgroups... These are necessary-condition checks, not point theorems" [RES RES-17]
  - "That branch is closed unless a new dominance-functorial invariant is introduced" [SPEC task E3]
- **current_state:** CLOSED-EXHAUSTED.
- **runs:** `tmp/recent_structural_tools_audit/verify.py`
- **sources:** `RESOLUTION.md` "Other audited boundaries" bullet, "2026-07-29 structural advances" item 5; `SPEC.md` task E3; `HANDOFF.md` 2026-07-29 primary-source audit bullet
- **lenses:** HAND, RES (2/7)
- **confidence:** certain

---

## 46. ED-P — Prime-local essential dimension

- **aliases:** RES `RES-18`; `ed_p(G)`
- **tries:** negative route — force `ed(G)=4` via prime-local essential dimensions.
- **method:** analytic
- **status_labels:** "Prime-local essential dimension **cannot** force the value four: the local values are two at 2 and one at 3, 5, and 11" [RES RES-18]
- **current_state:** REJECTED — numerically impossible.
- **runs:** none named
- **sources:** `RESOLUTION.md` "Other audited boundaries" bullet; `RESOLUTION.md` "Explicit generic-twist frame" (~1856–1858)
- **lenses:** RES (1/7) — **single-lens**
- **confidence:** certain

---

## 47. SUPERRIGID — Birational superrigidity

- **aliases:** RES `RES-19`; "equivariant birational superrigidity"
- **tries:** examine whether the known `G`-birational superrigidity of `X` itself supplies a negative resolution.
- **method:** analytic
- **status_labels:**
  - "Birational rigidity is not a negative answer... a dominant map `U⇢X` may have degree greater than one" [RES RES-19, SPEC pitfalls]
  - "Equivariant birational superrigidity excludes birational linearization, not a dominant equivariant map of higher degree" [RES RES-19]
- **current_state:** REJECTED — proves the wrong statement.
- **runs:** none named
- **sources:** `RESOLUTION.md` "Unconditional starting point" item 7, "Other audited boundaries" last bullet; `SPEC.md` pitfalls
- **lenses:** RES (1/7) — **single-lens**
- **confidence:** certain

---

## 48. CSD — Cassels–Swinnerton-Dyer conditional route

- **aliases:** RES `RES-20`; "Conditional forks and stakes"
- **tries:** conditional positive — invoke the CSD conjecture (a cubic hypersurface with a zero-cycle of degree prime to 3 has a rational point) for the restricted family of Klein-cubic twists, all of which already carry a degree-one zero-cycle.
- **method:** analytic (conditional)
- **status_labels:**
  - "would prove that `X` is `G`-unirational and `ed(G)=3`" (conditional, unproved) [RES RES-20]
  - "A proof conditional on one of the conjectures below is **not a resolution** unless that conjecture is proved in the required case" [RES RES-20, SPEC]
- **current_state:** CONDITIONAL — would settle the headline positively; not usable as a resolution.
- **runs:** none named
- **sources:** `RESOLUTION.md` "Conditional forks and stakes"; `SPEC.md` same section and task E2 bullet
- **lenses:** RES (1/7) — **single-lens**
- **confidence:** certain

---

## 49. DR88 — Duncan–Reichstein Conjecture 8.8 conditional route

- **aliases:** RES `RES-21`
- **tries:** conditional positive — invoke Conjecture 8.8 (Sylow-subgroup versality implies `G`-versality); since every Sylow restriction on `X` is already versal (Condition A holds), this gives `G`-unirationality directly.
- **method:** analytic (conditional)
- **status_labels:**
  - "would prove that `X` is `G`-unirational and that `ed(G)=3`" (conditional, unproved) [RES RES-21]
  - a negative headline resolution "would also **refute** Duncan–Reichstein Conjecture 8.8 in this example, because every Sylow restriction is already versal" [RES RES-21]
- **current_state:** CONDITIONAL — and raises the stakes of a negative answer.
- **runs:** none named
- **sources:** `RESOLUTION.md` "Conditional forks and stakes"
- **lenses:** RES (1/7) — **single-lens**
- **confidence:** certain

---

## 50. DOLGACHEV — Crdim(G) ≤ ed(G) conditional route

- **aliases:** RES `RES-22`
- **tries:** conditional negative — invoke Dolgachev's proposed inequality `Crdim(G) ≤ ed(G)`; since Prokhorov proves `Crdim(G)=4`, this forces `ed(G)=4` and rules out `G`-unirationality.
- **method:** analytic (conditional)
- **status_labels:**
  - "would instead give `ed(G)=4`, which rules out `G`-unirationality of `X`" (conditional, unproved) [RES RES-22]
  - "a positive solution would give `ed(G)=3` and a **counterexample to Dolgachev's proposed inequality**" [RES RES-22]
- **current_state:** CONDITIONAL — the mirror-image stake to entry 49.
- **runs:** none named
- **sources:** `RESOLUTION.md` "Conditional forks and stakes"
- **lenses:** RES (1/7) — **single-lens**
- **confidence:** certain

---

## 51. LIT-AUDIT — Recent-literature and computational-tool audit

- **aliases:** HAND `R32`; STAT "Literature & computational-tool audit"; `tmp/recent_structural_tools_audit`, `recent_equivariant_tools_2026`, `groebnerjl_change_matrix_pilot`
- **tries:** infrastructure/negative-clearance — recurring due-diligence sweep for a turnkey theorem or software that would shortcut a route: Kresch–Tschinkel versal-twist reduction, Poonen–Stoll discriminant-valuation theorem, Jung–Saito defect/factoriality revisions, Spicer–Tasin, Robbiano border-basis survey, Groebner.jl change-matrix API, June-2026 BSS/Koszul-homology spline paper, Magma/OSCAR/HomotopyContinuation.jl availability, and the 2026-07-18 Cheltsov–Tschinkel–Zhang manuscript.
- **method:** literature/tool audit
- **status_labels:**
  - "found no recent theorem that closes the headline" [HAND R32]
  - Poonen–Stoll "closes those components as local-obstruction places... says nothing about the global torsor"; Jung–Saito "does not compute `Cl(B)` or `Cl(C6)`"; Groebner.jl "the public high-level route is stopped"; BSS/Koszul "generic hyperplane-fan theorems do not apply directly" [HAND R32]
  - "no theorem that converts index one or a degree-55 point on a cubic threefold into a rational point"; the 2026-07-18 Cheltsov–Tschinkel–Zhang manuscript "still lists this full action as open" [STAT]
  - one genuinely material missed theorem found (Poonen–Stoll), already absorbed into the xCD route [STAT]
- **current_state:** ONGOING-CLEARANCE — no turnkey theorem exists; one absorbed import (Poonen–Stoll).
- **runs:** `tmp/recent_structural_tools_audit/`, `tmp/recent_equivariant_tools_2026/`, `tmp/groebnerjl_change_matrix_pilot/`
- **sources:** `CURRENT_PATHS.md` "Recent literature and tool audit" (lines 1655–1785); `HANDOFF.md` 2026-07-29 primary-source audit bullet and "Current structural ledger" tail
- **lenses:** HAND, STAT (2/7)
- **confidence:** certain

---

## 52. DP-REPLAY — del Pezzo closure-mechanism replay

- **aliases:** `GOALS_NEXT_10_ROUTES_2026-08-02.md` #2
- **tries:** proposed analytic search — identify the Problem-E analogue of a prior successful del Pezzo closure mechanism: a canonical torsor, universal family section, or equivariant intermediate object whose existence is *equivalent* to `G`-unirationality of `X`.
- **method:** analytic
- **status_labels:** listed as priority-2 dispatch item; "Type: analytic"; **not yet run** [WORK]
- **current_state:** PROPOSED-UNRUN.
- **runs:** none
- **sources:** `GOALS_NEXT_10_ROUTES_2026-08-02.md` #2
- **lenses:** WORK (1/7) — **single-lens**
- **confidence:** certain (as a stated route)

---

## 53. UNKNOWN-EX — Hidden intermediate-variety example search

- **aliases:** `GOALS_NEXT_10_ROUTES_2026-08-02.md` #9; "unknown-example"
- **tries:** proposed search — look through cubic threefolds, Fano varieties and finite-simple-group actions for previously unknown examples where equivariant unirationality was settled by a **hidden intermediate variety** rather than by representation covariants, in order to import the technique.
- **method:** analytic (literature)
- **status_labels:** listed as priority-9 dispatch item; **not yet run** [WORK]
- **current_state:** PROPOSED-UNRUN.
- **runs:** none
- **sources:** `GOALS_NEXT_10_ROUTES_2026-08-02.md` #9
- **lenses:** WORK (1/7) — **single-lens**
- **confidence:** certain (as a stated route)

---

## 54. CTR-TWIST — Counterexample twist / no-point G-torsor target

- **aliases:** HAND `R29`; "sharp negative target"; "Counterexample twist" (Best re-entry points)
- **tries:** negative construction (proposed, not executed) — exhibit an explicit `G`-torsor over an infinite field whose Klein twist has **no** rational point, which would prove both the negative headline and `ed(G)=4`.
- **method:** analytic/construction
- **status_labels:** listed as a live target, not yet attempted/found: "An explicit `G`-torsor whose Klein twist has no point would prove both the negative headline and `ed(G)=4`" [HAND R29]; "The sharp negative target is any boundary-zero `G`-torsor ... whose Klein twist has no point" [HAND, 2026-07-30 audited delta item 2]
- **current_state:** OPEN-TARGET — the canonical statement of what a negative resolution would look like; no candidate constructed.
- **runs:** none named
- **sources:** `HANDOFF.md` "Best re-entry points" (Counterexample twist), "2026-07-30 audited delta" item 2
- **lenses:** HAND (1/7) — **single-lens**
- **confidence:** certain

---

## 55. REPAIR — 2026-07-31 theorem-boundary repair audit

- **aliases:** `REPAIR.md`; "theorem-boundary audit of every standing exit"; GIT `78abba4`; the repair tables reproduced identically in `HANDOFF.md`, `RESOLUTION.md`, `SPEC.md`, `CURRENT_PATHS.md`
- **tries:** infrastructure/meta — audit every standing exit label in the project against its actual proof, downgrade overclaimed labels, and specify mandatory repair gates. Outcomes: Path T `T-NONNORMAL` and `dim Sing_S=2` suspended pending T2R; Path G `G13/G19-OBSTRUCTION` → `G13/G19-SAMPLE-RESIDUAL`; Path A single-minor → ideal of all maximal minors and `(L,V_Z)` → abstract interface; Hodge-center proof rewritten via a relatively ample class; Pfaffian "abstract K_proj-point" scoped to the auxiliary characteristic cubic only; Schur "no rational point" → "no rational point is currently known".
- **method:** document/proof audit
- **status_labels:**
  - `78abba4` 2026-07-31 "audit theorem-boundary" / "theorem-boundary audit of every standing exit" [GIT]
  - "Trusted results retained": Path A P¹-reduction; Path A index-34 duality; corrected Hodge-center split-injection theorem after §8 substitution; Path G finite truncation and isolation cutoff; Path G4.1 free-fibre recurrence; P25.1 `P25-TOWER-SURVIVES`; `T-BIRATIONAL` [HAND, RES, STAT]
  - "Suspended or downgraded": `T-NONNORMAL`, `dim Sing_S=2`, `G13/G19-OBSTRUCTION`, Path A single-minor formulation, Path A executable `L,V_Z` claim [HAND, RES]
- **current_state:** APPLIED — the repair is the governing correction layer; its verdicts outrank the later offline 08-02 ledger wherever the two disagree.
- **runs:** `REPAIR.md` §§0–17; mandated file edits (`certificates/hodge_centers/HODGE_CENTER_NECESSITY.md`, `certificates/schur_krylov/*`, `certificates/fold_normalization*`)
- **sources:** `REPAIR.md`; `HANDOFF.md` "2026-07-31 theorem-boundary repair"; `RESOLUTION.md` / `SPEC.md` repair tables; `CURRENT_PATHS.md` lines 19–90; git `78abba4`
- **lenses:** GIT, HAND, RES, STAT (4/7)
- **confidence:** certain

---
---

# (a) Single-lens attempts — flag for a second look

| id | name | only lens | why it matters |
|---|---|---|---|
| 3 | A1-AUD — Path A audit packet | CERT | a whole certificate directory (`certificates/audit_a1`) with no narrative owner; may be REPAIR fallout or a Path A gate |
| 20 | I — Hermitian five-plane intersection theory | WORK | a fully specified Elo path with defined exits and no execution trace anywhere else |
| 23 | L1 — full polar range recursion | DIR | carries a PASS (`L1-FULL-RANGE-PASS`) that no other lens records; possible alias of WP-L1 |
| 43 | GROSS-POPESCU | RES | rejected literature route |
| 44 | KRESCH-TSCHINKEL | RES | rejected obstruction tool |
| 46 | ED-P — prime-local essential dimension | RES | rejected on explicit numerics |
| 47 | SUPERRIGID — birational superrigidity | RES | rejected as proving the wrong statement |
| 48 | CSD — Cassels–Swinnerton-Dyer | RES | conditional positive; would close the headline |
| 49 | DR88 — Duncan–Reichstein 8.8 | RES | conditional positive; negative answer would refute it |
| 50 | DOLGACHEV — Crdim ≤ ed | RES | conditional negative; positive answer would refute it |
| 52 | DP-REPLAY | WORK | proposed, unrun |
| 53 | UNKNOWN-EX | WORK | proposed, unrun |
| 54 | CTR-TWIST | HAND | the canonical negative target; no other lens names it |

Note: entries 43–50 are all seen only by `lens_resolution_spec.md` because `RESOLUTION.md`/`SPEC.md` are the only documents that carry the "Other audited boundaries" and "Conditional forks and stakes" sections. Their single-lens status is a document-structure artifact, not weak evidence.

# (b) Open conflicts

1. **T-track terminality** (entry 32). `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md` (offline ChatGPT session): T/T2 `TERMINAL — Background only`. Against: `REPAIR.md` holds the T2R gate **mandatory and pending** (no certified exit among `T2R-NONNORMAL`/`T2R-NORMAL`/`T2R-UNDECIDED`), T3 is blocked from consuming `T-NONNORMAL`, and git `7fdbe42` leaves T2R.5 `T2R-UNDECIDED`. **Resolution applied:** REPAIR + run artifacts outrank the ledger → suspended-pending-T2R, not terminal.
2. **KLS terminality** (entry 22). Ledger: KLS/KLS2 `TERMINAL — Background only`. Against: `CURRENT_PATHS.md` (07-29/07-30) lists still-open branches (LC-minimality + vertical-divisor pair, nonnormal conductor, degree-12 Jacobian exceptional locus, unsolved flat-connection PDE); `KLS_MINIMALITY/STATUS.md` records only `KLS2-NO-FINITE-REDUCTION`. **Resolution applied:** the *reduction* is closed; the framework is open-but-unauthorized.
3. **B status reversal** (entry 6). 2026-07-30 `CURRENT_PATHS.md`: leading active route with positive milestones. 2026-08-02: `B-BRIDGE-REFUTED` in a run `STATUS.md`, `REMAINING_GOALS_NOTE.md` and the ledger. **Resolution applied:** the refutation is corroborated outside the offline ledger; the reversal is genuine. Downstream, T3 and the fixed-frame arithmetic are demoted to non-headline.
4. **Ledger label "F"** (entry 13 vs 14 vs 15). STAT cannot tell whether the 08-02 ledger's bundled-terminal "F" means Path F (fixed-frame genus-one / restricted E[3]), the Problem-F technique import, or "Fable". Three distinct objects share the letter. Unresolved.
5. **Fable order-12 dispatch vs closure** (entry 15). `WORKORDER_ORDER12.md` dispatches the second Koszul gate as active; `WORKORDER_STRATA_MACHINE.md` addendum + HAND R19/R20 record the branch closed by two obstruction theorems. Chronology suggests dispatch-then-closure but no lens states it.
6. **"G4" label collision** (entries 16 vs 4). GIT/HAND: G4 = "Route G verdict, G4.1 symbolic free-fibre recurrence" (2026-07-31). DIR/WORK: `G4_A5_INDEX11_TRANSFER` with `G4-INDUCED-DEGREE11-POINT-PASS` (2026-08-02). Two different objects.
7. **"G7" label collision** (entries 16 vs 17). GIT: `c28bb08` "degree-7 exits `G7-OBSTRUCTION`" inside Path G. DIR: `goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE`. Two different objects.
8. **"V2" label collision** (entry 33). GIT "V2 Track T / T8 / P25X / P25Y / C0" = the `_V2` work-order document. DIR `V2-FIXED-FRAME-PLACE-NONTRANSFERABLE` = exit label of `V_GENUINE_VALUATION`. Two different objects.
9. **"H1" / "H" label collisions** (entries 11, 18, 19, 22). GIT `H1` = WP-H1 Hodge-center; WORK `H1` = "two maximal A5 classes" gate in `WORKORDER_CAS_HEADLINE.md` §9 and also the KLS Path-H target-theorem task; GIT `H` (`2301a43`) = Goal H subgroup-twist sweep; DIR `H` = `H_11_5_TWIST`. At least four referents.
10. **A5Q expansion** (entry 4). STAT reads A5Q = "A5-quadric branch (KLS)"; DIR/WORK/GIT read A5Q = "A5 quartic rescue / index-11 transfer". Resolved 3–1 in favour of quartic rescue, but STAT's reading is recorded because the KLS A5-quadric branch is a real, separately-closed object.
11. **J route content** (entry 21). WORK: never-executed invariant audit ("theory watch"). DIR: executed run exiting `J2-UNRESTRICTED-COUNTERMODEL-EXTENDS`. Same letter; link inferred, not stated.
12. **`certificates/elliptic_lifting` ownership** (entry 28 vs 34). Claimed by R/R2 (Pfaffian elliptic quintic descent, `PICARD_OBSTRUCTION.md`) and by WP-E1 ("elliptic Pic⁰ obstruction", Path G lifting blockers). Unresolved.

# (c) Identity questions — possibly-same-as pairs

| pair | evidence for merging | evidence against | verdict |
|---|---|---|---|
| **7 (C0–C3)** ↔ **8 (C5/C6)** | same target (`K_proj`-point of `F_{14,T}` via a common isotropic right `D`-line); WORK records C5 as the *corrected* successor model ("C5 idempotent `e*S_0*e=0` \| Plücker/alternating-form model → C6") | CERT keeps `fano_c0..c3` as a closed certificate family with its own exits; DIR/GIT treat C5/C6 as new Aug-2 goal runs with new labels | **KEPT SEPARATE** — successor relationship, not identity (director-flagged pair) |
| **1 (A)** ↔ **30 (S19)** | CERT groups `schur_krylov` + `schur_degree19` under one heading "A"; WORK titles its entry "S19-Krylov — Schur degree-19 rescue curve (Attempt 3 / Path A Krylov / Route S19)" | DIR has a distinct `S19_MARKED_CURVE` goal run with its own `S19-UNDECIDED`; GIT has distinct `PathA`/`A_empty` commits; the repo assigns distinct route codes | **KEPT SEPARATE** — two stages of one Schur programme (A = degree-55 field-algebra/Krylov interface; S19 = degree-19 residual curve) |
| **6 (B)** ↔ **32 (T)**, via `certificates/target_branch_*` | CERT assigns `target_branch_global/mod3/t10` to "B"; both routes work on the same fixed-frame/target-branch geometry | `target_branch_t10/exit_t10.json` matches GIT's T10 work order (`1d3fe3b`); HAND R11/R12 place "target branch" inside the Path T programme | **KEPT SEPARATE**, certificates listed under both (director-flagged pair) |
| **5 (Attempt1)** ↔ **26 (Pfaffian)** | GIT `1c07871` "Attempt 1 Gates 1-2 — **FAIL-SCOPE on the bridge**" and WORK "Attempt-1-Pfaffian ... `FAIL-SCOPE`: idempotent gives a point of auxiliary `P^2_D`, not of `F_{14,T}`" share the verbatim exit and the bridge language; `certificates/pfaffian_point/{BRIDGE_AUDIT.md, CFOSS_W1_INPUT.md}` matches WORK's Attempt-1 gate 1B ("CFOSS w1 pin, implication-chain check") | none | **MERGED** (two-lens agreement, director-flagged pair): Attempt 1 = the Pfaffian–Morita idempotent gate of entry 26 |
| **10 (D/D2)** ↔ **19 (Hodge-center)** | WORK presents them as one entry (Path D D1 = "repair split-injection proof", D2 = "geometric channel screen"); both conclude the unrestricted invariant is too flexible | DIR/GIT/HAND/RES/STAT treat the Hodge-center split-injection theorem as a standalone REPAIR-corrected theorem with its own certificate dir | **KEPT SEPARATE** — Hodge-center is a theorem inside the broader D route |
| **21 (J)** WORK-description ↔ DIR-run | same letter; both are "invariant that survives every compression" style arguments; both terminate without an obstruction | WORK's version is explicitly never executed; DIR's has an exit label | **PROVISIONALLY MERGED** into one entry with the discrepancy recorded as conflict 11 |
| **23 (L1)** ↔ WP-L1 | both are "universal polar expansion / full polar range" over the Path G lifting tower | WORK never uses the code `L1`; DIR never uses `WP-L1` | **KEPT SEPARATE** (single entry with alias flagged, medium confidence) |
| **28 (R/R2)** ↔ `certificates/elliptic_lifting` / WP-E1 | both concern an elliptic Picard/`Pic⁰` obstruction | WP-E1 sits inside Path G's lifting blockers; R/R2 is an Aug-1 goal run | **UNRESOLVED** (see conflict 12) |
| **13 (F)** ↔ **14 (F-IMPORT)** ↔ **15 (Fable)** | all three are addressed by the single ledger token "F" | contents are unrelated (fixed-frame genus-one torsor vs Problem-F involution import vs A4 trisection) | **KEPT SEPARATE**; the ledger token is ambiguous (see conflict 4) |
| **18 (H6 route)** ↔ `H_6=V(f_6)` in xCD (**35**) | symbol match | STAT: "no explicit cross-reference found"; H6 is a trace-cubic torsor decision, `H_6` is the Klein sextic | **KEPT SEPARATE** |
