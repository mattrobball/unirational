# Problem E notebook — PSL(2,11)-unirationality of the Klein cubic

Single cohesive record of every attempt at the headline, its justification, status,
and outcome. Supersedes `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md` as the tracking
document; binding mathematical status remains governed by `REPAIR.md` and
`CURRENT_PATHS.md` as described below.

Last rebuilt: 2026-08-03. Headline status: **OPEN**.

Citation-verified 2026-08-03: a four-agent sweep checked 92 status labels, 279 cited paths, and 103 commit hashes against artifacts; all corrections applied. Lens and session provenance in `notebook_build/`.

Content source for the attempt entries: `notebook_build/canonical_attempts.md`
(55 merged entries from seven independent lens reports). External-session content:
`notebook_build/sessions_batch1.md` … `sessions_batch4.md` (15 offline ChatGPT
sessions). History anchors: `notebook_build/lens_gitlog.md`.

## Headline

Decide whether the Klein cubic threefold admits a genuine PSL(2,11)-equivariant
dominant rational map from a rational representation — equivalently, whether
ed_C(PSL(2,11)) = 3 or 4. A positive route must produce a verified generic twist
point or primitive landing covariant. A negative route must rule out all
characteristic-zero homogeneous self-covariants/landing mechanisms or prove the
genuine generic twist pointless.

## Binding rules (read before trusting any status below)

1. **Precedence.** Where documents conflict: `REPAIR.md` > `CURRENT_PATHS.md` >
   run `STATUS.md` files > workorders > narrative docs (`RESOLUTION.md`,
   `HANDOFF.md`, `SPEC.md`). The 2026-07-31 repair downgraded several historical
   labels; a pre-repair claim never overrides its post-repair replacement.
2. **Ledger rule.** Finite computations, modular ranks, and formal states are
   not headline conclusions unless an explicit characteristic-zero geometric
   bridge is supplied.
3. **Replay ≠ verification.** Hash/verifier replay certifies file presence and
   internal packet consistency — not the analytic implications a verifier merely
   reads from JSON or Markdown. Method tags below distinguish `CAS` (replayable),
   `formal` (kernel-checked), and `analytic` (audited only by reading).
4. **Provenance.** `source: repo` entries cite in-repo artifacts. `source:
   external-chatgpt` entries record offline sessions (see
   `external_sessions/`); their claims are **not machine-verifiable** and must
   be re-derived in-repo before affecting the headline.

## History

Chronology and hash anchors from `notebook_build/lens_gitlog.md`.

- **2026-07-28** — `1a52c93` F-technique import; `2b8cf41` generalize the F-engine. Problem F's all-degree V₄-fixed exceptional-path obstruction is imported; the verbatim transfer fails and the generalized engine "closes rather than obstructs" (E14).
- **2026-07-30** — WP strata/lifting machine wave: `d9cadc3` WP-Z director gate report (ranking 4), `ced3153` WP-6 STOP with formulation, `db25516` WP-H1 Hodge-center screen — "no numerical contradiction" (E34, E19).
- **2026-07-30** — Five-attempts competitive dispatch: `1c07871` Attempt 1 `FAIL-SCOPE` on the bridge; `b7be961` Attempt 2 `STOP-2` at measured 9.4 GB; `a5b3d66` degree-43 factor reconstructed; `83d2b10` Attempt 3 implication chain PASSES, `STOP-3`; `dddb743` Attempt 5 containment UNDECIDED (E5).
- **2026-07-30** — Elo ten-path ranking introduced to allocate CAS resource: `5e765ce` Elo cycle-1 gate report, `c5e71be` post-Elo finite-lifting work order (E12).
- **2026-07-30** — Path gates open in parallel: `cdc016b` Path A gates A1–A3 (A1 PASS), `4baad2f` Path A collapse audit (no lossless collapse), `56e61c3` Path F gate F1-P terminality audit passes, `e050464` Path G gate G1 containment FALSE at (1,7), `865b262` Paths F and G cycle 2.
- **2026-07-31** — Post-Elo path verdicts: `c28bb08` Path G — G1 finite truncation PASSES, degree-7 exits `G7-OBSTRUCTION`; `68147f3` G4.1 symbolic free-fibre formula achieved, gate G-A blocked; `62a3fcb` Path G3 exits `G-PATTERN`; `3bfbd01` post-Elo gate 1 records Path F; `d96b408` Path T gate T1 `T-BIRATIONAL`.
- **2026-07-31** — T-track subdivision: `17e0e5f` T2 exits `T-NONNORMAL` (S2 holds, R1 fails); `11474f5`/`d8550e1`/`7fdbe42` T2R stays `T2R-UNDECIDED` (T2R.4 PASS, T2R.5 open); `dc43a86`/`2645c91` T8; `7866c68`/`d1417c3` T9; `19e9490`/`1d3fe3b` T10; `faf6169`/`9ce2233` T11.
- **2026-07-31** — C-track model installs: `1ad97cf` `C0-UNDECIDED`; `3f71710` `C1-UNDECIDED`, char-0 floor named; `d769885`/`4da9f8f` C2 two-generator word basis and partial constants sealed; `0cf23e5` C3 rectangular basis installed.
- **2026-07-31 → 08-01** — P25 variant sweep: `19da967` P25W Stage-A kernel incidence EMPTY; `841005b` P25Z.3 direct landing row rank EXACTLY 746; `5e72d8e` P25X0-PASS / P25X1-FAIL (the 842 basis is not recovered); `6096429` `P25Y-DVR-PASS`; `2140419` P25V.0 degree-four closure FAILS.
- **2026-07-31** — `9bee33a` Path A statement A_empty; `3c9b385` A_empty attack exits `A_EMPTY_UNDECIDED`; `827f0da`/`4e44e73` Q descent-obstruction close-out sealed.
- **2026-07-31** — `78abba4` **theorem-boundary repair audit** of every standing exit (E55): `T-NONNORMAL` and `dim Sing_S=2` suspended pending T2R; `G13/G19-OBSTRUCTION` → `G13/G19-SAMPLE-RESIDUAL`; Path A single-minor → ideal of all maximal minors and `(L,V_Z)` → abstract interface; Hodge-center proof rewritten via a relatively ample class; Schur "no rational point" → "no rational point is currently known".
- **2026-08-01** — Goal-mode waves begin, anchors `35fa8f5` (publish August goal-route reports) and `bd610a0` (publish post-35fa route audits): `2301a43`/`53e267a` Goal H subgroup-twist sweep resolved; `20be6ba` generic-twist continuation; `fc4e490`/`e1fc474` Goal D equivariant-motive route resolved and sealed; `0d16f55`/`6737bec` KLS goals; `83d35f7` index-11 quartic rescue; `715faf4` T11b Route C obstructed.
- **2026-08-02** — Anchors `141f604`, `0aecc89`, `eb21458`, `ff69434`, `7030dda`, `f1f0be5`, `5899d05`. G2 reduction lands: `23f40f7` finish G/G2 universal all-degree theorem, `6a2ccaa` retire completed G2 structural mission, `5ded147` post-G2 headline reassessment; successors dispatched `5eb1214` G3, `5cb3d11` G3A, `d1f43d6` G3H, `7da4fdf` G3S; `027e002` H6 degree-11 isogeny; `1b764bf` C6 determinantal Fano.
- **2026-08-02** — B refutation and adjacent close-outs: `5899d05` finish Task B fixed-frame exhaustiveness (→ `B-BRIDGE-REFUTED`); `b77b04c` record V3 residue normal form; `96195e8`/`139ab6c`/`5167255` M3 residual section close-out; `b49fc81`/`74045be`/`823beb1`/`c9d75e1` T3/T3A split into local-runner goals; `30cccfa` index-11 transfer goal.
- **2026-08-02** — V4 closure wave: `04d1d1c` classify simultaneous V4 odd normal maps; `bc56247` record V4 simultaneous-normal theorem boundary; `ebb5769`/`fb4bcea` genus-two quotient classification; `08859c0` certify exact A4 surface parameters; `72147bd` record degree-25 corollary.

## Index

55 canonical attempts. `state` is the reconciled state from `canonical_attempts.md`,
not a verbatim exit label.

| ID | Name | Target | Method | State |
|---|---|---|---|---|
| [E01](#e01) | A — Path A Schur–Krylov degree-55 field algebra | positive | mixed | UNDECIDED-STOPPED |
| [E02](#e02) | A0 — canonical audit / CAS baseline | infrastructure | CAS | TERMINAL-PASS (infra only) |
| [E03](#e03) | A1-AUD — Path A audit packet | infrastructure | CAS | INFRASTRUCTURE (uncharacterized) |
| [E04](#e04) | A5Q — A5 index-11 transfer / quartic rescue | positive | CAS | PARTIAL |
| [E05](#e05) | Attempt1–5 — five-attempts dispatch wave | infrastructure | mixed | COMPLETED-WAVE |
| [E06](#e06) | B — fixed-frame exhaustiveness bridge | negative | mixed | TERMINAL-NEGATIVE (bridge refuted) |
| [E07](#e07) | C0–C3 — direct twisted Fano section | positive | CAS | OPEN-UNDECIDED |
| [E08](#e08) | C5/C6 — corrected Palatini / Plücker big cell | positive | CAS | OPEN (top-ranked positive) |
| [E09](#e09) | COV — degree-31/35 m=1 landing modules | positive/negative | CAS | OPEN/DEFERRED |
| [E10](#e10) | D/D2 — equivariant motive / stack invariant | negative | analytic | TERMINAL-NEGATIVE-FOR-THE-ROUTE |
| [E11](#e11) | E/H2/H3 — proper-subgroup generic twists | negative (outcome positive) | CAS | SCOPED-POSITIVE (route closed) |
| [E12](#e12) | Elo — ten-paths ranking system | infrastructure | mixed (process) | COMPLETED-PROCESS |
| [E13](#e13) | F — Path F fixed-frame genus-one torsor | positive/negative | mixed | UNDECIDED |
| [E14](#e14) | F-IMPORT — Problem F / F-engine technique import | negative | analytic | REFUTED-AS-TRANSFER |
| [E15](#e15) | Fable — A4 trisection / Koszul lifting | positive | mixed | CLOSED-IN-CURRENT-FORM |
| [E16](#e16) | G — Path G universal object / degree ladder | positive (neg. exit) | CAS | STRUCTURAL-PASS, ARITHMETIC-OPEN |
| [E17](#e17) | G3 — universal cubic arithmetic (A/B/C/D/H/P/S) | positive | mixed | OPEN (highest priority) |
| [E18](#e18) | H11:5 / H5 / H6 — 11:5 trace-cubic programme | negative | mixed | OPEN |
| [E19](#e19) | Hodge-center — split-injection / CM screen | negative | mixed | SALVAGED-BUT-NONBINDING |
| [E20](#e20) | I — Hermitian five-plane intersection theory | positive/negative | analytic | UNRESOLVED/UNRUN |
| [E21](#e21) | J/J2 — canonical-dimension invariant / Prym | negative | analytic | TERMINAL (countermodel) |
| [E22](#e22) | KLS — self-covariant landing framework | positive/negative | mixed | CONFLICT → reduction closed, framework open |
| [E23](#e23) | L1 — full polar range recursion | infrastructure | CAS | PASS |
| [E24](#e24) | M/M2/M3 — Sarkisov link / dP3 section search | positive | mixed | OPEN-NARROWED |
| [E25](#e25) | P25 — degree-25 landing self-covariant | positive (neg. exit) | CAS | OPEN/DEFERRED |
| [E26](#e26) | Pfaffian — Pfaffian/Morita quaternionic descent | positive | mixed | OPEN-AT-THE-COMMON-LINE-GATE |
| [E27](#e27) | Q/Q3 — Schur index-one descent obstruction | negative | mixed | PARTIAL-OPEN |
| [E28](#e28) | R/R2 — rational curves / elliptic descent | negative | mixed | TERMINAL-OBSTRUCTED |
| [E29](#e29) | R0 — canonical live-ledger refresh | infrastructure | mixed | PASS |
| [E30](#e30) | S19 — degree-19 Cayley–Bacharach residual curve | positive | mixed | UNDECIDED |
| [E31](#e31) | Schur — six-dimensional projective-source route | positive | CAS | OPEN-STALLED |
| [E32](#e32) | T — fold-algebra / target-branch index-three | negative | CAS | SUSPENDED-PENDING-T2R (conflict) |
| [E33](#e33) | V/V2/V3/V4 (+G5) — valuation / residue-twist | negative | mixed | PARTIAL |
| [E34](#e34) | WP-strata — stabilizer strata / normal-cone machine | infrastructure/negative | CAS | INFRASTRUCTURE-PARTIAL |
| [E35](#e35) | xCD — plane-section flex / 3-descent | positive/negative | mixed | CLOSED-SCOPED-NEGATIVE |
| [E36](#e36) | theta11 — level-11 theta/Schwarz construction | positive | CAS | CLOSED-REFUTED |
| [E37](#e37) | ED-REDUCTION — G-unirational ⟺ ed_C(G)=3 | infrastructure | analytic | PROVED-INFRASTRUCTURE |
| [E38](#e38) | INV-INFRA — exact action & invariant theory (E0) | infrastructure | CAS | CERTIFIED-INFRASTRUCTURE |
| [E39](#e39) | FRAME — generic covariant frame (x,C,D,E,K) | infrastructure | CAS | CERTIFIED-INFRASTRUCTURE |
| [E40](#e40) | PDE-FLAT — K_proj flat-connection all-degree PDE | infrastructure (reformulation) | mixed | OPEN-REFORMULATION |
| [E41](#e41) | VOISIN — C^[3] very-versality pullback | positive | analytic | CLOSED-CIRCULAR |
| [E42](#e42) | ZC-SECANT — zero-cycle / secant chord-tree | positive | mixed | CLOSED-FOR-FINITE-CONSTRUCTIONS |
| [E43](#e43) | GROSS-POPESCU — modular-moduli reinterpretation | positive | analytic | REJECTED (restates problem) |
| [E44](#e44) | KRESCH-TSCHINKEL — diagonal / equiv. Burnside | negative | analytic | REJECTED (wrong implication) |
| [E45](#e45) | AMITSUR — universal-torsor / higher Amitsur (E3) | negative | analytic | CLOSED-EXHAUSTED |
| [E46](#e46) | ED-P — prime-local essential dimension | negative | analytic | REJECTED (numerics) |
| [E47](#e47) | SUPERRIGID — birational superrigidity | negative | analytic | REJECTED (wrong statement) |
| [E48](#e48) | CSD — Cassels–Swinnerton-Dyer | conditional (positive) | analytic | CONDITIONAL |
| [E49](#e49) | DR88 — Duncan–Reichstein Conjecture 8.8 | conditional (positive) | analytic | CONDITIONAL |
| [E50](#e50) | DOLGACHEV — Crdim(G) ≤ ed(G) | conditional (negative) | analytic | CONDITIONAL |
| [E51](#e51) | LIT-AUDIT — literature & tool audit | infrastructure | analytic | ONGOING-CLEARANCE |
| [E52](#e52) | DP-REPLAY — del Pezzo closure-mechanism replay | positive (proposed) | analytic | PROPOSED-UNRUN |
| [E53](#e53) | UNKNOWN-EX — hidden intermediate-variety search | positive (proposed) | analytic | PROPOSED-UNRUN |
| [E54](#e54) | CTR-TWIST — counterexample twist target | negative (target) | analytic | OPEN-TARGET |
| [E55](#e55) | REPAIR — 2026-07-31 theorem-boundary audit | infrastructure | analytic | APPLIED |

## Attempts

Lens abbreviations in status citations: **DIR** directories, **GIT** gitlog,
**CERT** certificates, **HAND** handoff, **RES** resolution/spec, **STAT** status
docs, **WORK** workorders. "08-02 ledger" = `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md`
(offline-ChatGPT-produced; outranked by `REPAIR.md` and run-level `STATUS.md`).

<a id="e01"></a>
### E01 — A — Path A: Schur–Krylov degree-55 field algebra / P¹-reduction / index-34 duality

- **Target:** positive construction — install an executable degree-55 field-algebra / marked-point interface on the generic Schur twist (monogenic schema `B_34(τ,V_Z)`, rank-55 maximal-minor matrix, "index-34 duality", a `P¹`-reduction theorem), yielding an algebra-code pair `(L,V_Z)` from which a rational point / landing construction could be extracted.
- **Justification:** A marked closed point of degree 55 with an executable field-algebra presentation would let the `P¹`-reduction convert index data into an actual `K_proj`-point of the generic Schur twist, which by E37 closes the headline positively.
- **Method:** mixed (CAS elimination + structural algebra)
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
- **Status:** TERMINAL-PASS (infrastructure only; not a mathematical route).
  - `A0-CANONICAL-AUDIT-PASS` [DIR, `goal_runs_after_35fa/A0_CANONICAL_AUDIT/STATUS.md`; also WORK/`REMAINING_GOALS_NOTE.md`]
  - "TERMINAL PASS — Projection bulk data certified (4140/315) — Infrastructure only" [STAT, 08-02 ledger]
  - "already terminal, not an open mission" [WORK]
  - `HEADLINE_CAS_BASELINE_ACCEPT` marker, "distinguished from mathematical verification" [STAT/`REPAIR.md` §0]
- **What was actually established:** the exact action, invariance, and the 4140/315 projection-bulk counts are certified and replayable. NOT established: anything about the headline; the marker is explicitly distinguished from mathematical verification.
- **Aliases:** `A0_CANONICAL_AUDIT`; "canonical audit of projection bulk"; `HEADLINE_CAS_BASELINE_ACCEPT` (link inferred); CERT `headline_cas_order`
- **Provenance:** `goal_runs_after_35fa/A0_CANONICAL_AUDIT`; `certificates/headline_cas_order/`.
  - `source: external-chatgpt` — `sessions_batch1.md` § `github-repo-task-update-6a7054fb.md`: A0 bulk P25 replay succeeded at payload level (4,140 `T_i` tests + 315 commutator tests certified) while `STATUS.md` still read "running" — flagged there as a bookkeeping inconsistency only.
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_A0_CANONICAL_IMPLEMENTATION_AUDIT.md` (round-3 push, head `37d61c1`), and separately flags that the 4140/315 counts were "read from producer JSON, not independently recomputed".
- **Pointers:** `goal_runs_after_35fa/A0_CANONICAL_AUDIT/STATUS.md`; `REMAINING_GOALS_NOTE.md`; `REPAIR.md` §0; `README.md`
- *Lenses 4/7 (DIR, STAT, WORK, CERT); confidence certain.*

---

<a id="e03"></a>
### E03 — A1-AUD — Path A audit packet

- **Target:** infrastructure/audit — an audit packet recording findings for Path A (`AUDIT_FINDINGS.md`, `audit_findings.json`).
- **Justification:** Cannot close the headline; it exists to record what a Path A audit found. Listed because a whole certificate directory has no narrative owner.
- **Method:** CAS / document audit
- **Status:** INFRASTRUCTURE — contents not characterized by any lens.
  - No verbatim status label exists. CERT records only file inventory (`audit_a1/AUDIT_FINDINGS.md`, `README.md`, `audit_findings.json`) [CERT, "confidence: inferred-from-name"]
- **What was actually established:** unknown. No lens reads the packet's contents; only its file inventory is recorded.
- **Aliases:** CERT `AUD — AUD-A1`; `certificates/audit_a1`; possibly GIT `78abba4` "audit theorem-boundary" or `cdc016b` "Path A Gates A1-A3 — A1 PASS"
- **Provenance:** `certificates/audit_a1/`. No external session matches.
- **Pointers:** `certificates/audit_a1/AUDIT_FINDINGS.md`
- *Lenses 1/7 (CERT) — **single-lens**; confidence low. Possibly-same-as [E55](#e55) and/or the Path A `A1 PASS` gate of [E01](#e01); no lens disambiguates — ambiguity carried forward.*

---

<a id="e04"></a>
### E04 — A5Q — A5 index-11 point transfer / degree-4 quartic rescue

- **Target:** positive construction — transport the exact degree-11 closed points obtained from the A5 subgroup twists into a genuine PSL(2,11) projective generic-twist point via induced-representation/coset projectors and field descent; then test whether the degree-11 closed point on the full generic twist lies on a descended rational normal quartic in `P⁴` (meeting the cubic in degree 12, leaving a rational residual point).
- **Justification:** A rational residual point on the generic twist is exactly a `K_proj`-point, which closes the headline positively via E37. The A5 twists already have exact points (E11), so only the transfer is missing.
- **Method:** CAS
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
- **Status:** COMPLETED-WAVE — all five exited at scope/resource stops; the wave is closed and its content lives in the successor route entries.
  - `1c07871` "Attempt 1 Gates 1-2 — `FAIL-SCOPE` on the bridge" [GIT]; `FAIL-SCOPE`: "idempotent gives a point of auxiliary `P^2_D`, not of `F_{14,T}`" [WORK, `WORKORDER_ELO_TEN_PATHS.md` §1]
  - `b7be961` "Attempt 2 Gate 1 — `STOP-2` at measured 9.4 GB"; `a5b3d66` "option (c) — degree-43 factor reconstructed" [GIT]
  - `83d2b10` "Attempt 3 Gates 1-2 — implication chain PASSES, exit `STOP-3`" [GIT]; "implication chain PASS; both Rao branches remain live; `STOP-3`" [WORK]
  - `dddb743` "Attempt 5 Gate 1 — global state image formulated, containment UNDECIDED" [GIT]
- **What was actually established:** the mapping of the five attempts to routes, and their exit reasons (scope failure, memory ceiling, undecided implications). NOT established: any headline movement; Attempt 4 leaves no GIT trace.
- **Aliases:** `WORKORDER_FIVE_ATTEMPTS.md`; GIT `Attempt1`, `Attempt2`, `Attempt3`, `Attempt5`; exits `STOP-1`..`STOP-3`, `FAIL-SCOPE`, `P1`, `P1-CONDITIONAL`, `N1-SCOPED`
- **Provenance:** Attempt 1 gates 1B/1C/1D; Attempt 2 gate 1 + option (c); Attempt 3 gates 3B–3D; Attempt 4 gates 4B–4D; Attempt 5 gate 1; `certificates/GATE_REPORT_FIVE_ATTEMPTS_1.md`. No external session matches.
- **Pointers:** `WORKORDER_FIVE_ATTEMPTS.md`; `certificates/GATE_REPORT_FIVE_ATTEMPTS_1.md`
- *Lenses 2/7 (GIT, WORK); confidence certain for the wave and mapping (Attempt1↔Pfaffian–Morita confirmed by the shared verbatim `FAIL-SCOPE`/bridge language).*

---

<a id="e06"></a>
### E06 — B — Fixed-frame exhaustiveness bridge

- **Target:** negative obstruction — descend the full Klein-twist problem to the fixed four-parameter frame `F=C(A,B,Y,Z)`, build the depressed genus-one/ternary cubic over `K_proj`, prove it pointless, and then argue the fixed projector slice is **exhaustive** in the full Fano/projector variety, so that fixed-frame pointlessness certifies non-unirationality.
- **Justification:** The fixed-frame cubic was already proved pointless; if the fixed slice were exhaustive, that single arithmetic fact would transfer to the whole generic twist and settle the headline negatively.
- **Method:** mixed (exact CAS + arithmetic geometry)
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
- **Justification:** By the Pfaffian bridge (E26), a `K_proj`-point of `F_{14,T}` is equivalent to the headline-positive answer; the quaternion reduction makes the search a finite-dimensional isotropy problem over an explicit algebra.
- **Method:** CAS (exact linear algebra over cyclotomic / multiprime, msolve/M2)
- **Status:** OPEN-UNDECIDED — model installation advanced through C3 (bases sealed, modular only); the common-isotropic-line solve is not reached, char-0 transfer not made.
  - `C0-UNDECIDED — verified`; "no executable Fano model; needs `A_proj` descent → Morita symbol" [WORK, `DIRECTOR_HANDOFF.md` §8]
  - "Two clean negatives... no such mechanism exists geometrically... No model installed" [WORK, §8]
  - `1ad97cf` "V2 Track C0 — `C0-UNDECIDED`"; `3f71710` "C1.1 preflight — `C1-UNDECIDED`, floor named at char-0"; `d769885` "C2.0 — two-generator word basis sealed"; `4da9f8f` "C2.1 — partial constants sealed"; `0cf23e5` "C3.0 — rectangular basis installed" [GIT]
  - Sub-installation exits `C0-MODEL-PASS`/`C1-MODEL-PASS`/`C2-FANO-MODEL`/`C3-FANO-MODEL-PASS`, `C2-TWO-GENERATORS-MODULAR`, `C3-RECTANGULAR-BASIS-MODULAR`; target exit `C-POSITIVE`/`C-FANO-POINT` **not reached** [WORK]
  - "every individual Hermitian member is isotropic... only simultaneous common-line isotropy remains open"; "no explicit `K_proj` coordinates, quaternion corner, or common isotropic line are known" [RES `RES-07`]
- **What was actually established:** partial algebra models through C3, all modular; individual Hermitian isotropy. NOT established: the common isotropic line, explicit `K_proj` coordinates, or any char-0 lift.
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
- **Status:** OPEN — highest-ranked live positive route as of 2026-08-02; the C6 birational determinantal model PASSES, residual is the positive-degree section lift; the full incidence solve is not executed.
  - `C5-UNDECIDED` [DIR, run `STATUS.md`; WORK, `REMAINING_GOALS_NOTE.md`]
  - `C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS`; `C6-POSITIVE-DEGREE-RESIDUAL` [DIR, `goal_runs_after_141f60/C6_PALATINI_BIG_CELL/STATUS.md`]
  - "Rank 1 ... the strongest live positive route" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §4 Rank1]
  - Supersession note: "C5 idempotent `e*S_0*e=0` | Plücker/alternating-form model → C6" [WORK, `REMAINING_GOALS_NOTE.md`]
  - "OPEN — Corrected Plucker/alternating model survives — Possible geometric construction/refutation" [STAT, 08-02 ledger]
  - `1b764bf` "add C6 determinantal Fano goal" [GIT]
- **What was actually established:** the corrected incidence encoding and a birational determinantal model of the big cell (PASS). NOT established: a point; the residual is a positive-degree section lift and the full incidence solve was never run.
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
- **Status:** OPEN/DEFERRED — modular results only; char-0 transfer is the blocking gap.
  - `COV-UNDECIDED` [DIR, run `STATUS.md`; WORK, `REMAINING_GOALS_NOTE.md`]
  - "148 residual charts; modular [1] ≠ char-0 transfer" [WORK, `REMAINING_GOALS_NOTE.md`]
  - "Degrees 31 and 35 still require saturation of their based and nonbased C3/C6 charts and are coupled to degree 25 by invariant multiplication"; "the degree-35 zero linear quotient is not a degree-wide emptiness theorem" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §2.6, §1 item 6]
  - "OPEN/DEFERRED — Modular information only — Needs characteristic-zero transfer" [STAT, 08-02 ledger]
  - `[(T_1)_d⊗W]^G = 0` through degree 34 and for degree ≥164, but **dimension 1 at degree 35** in the split-`F_67` fibre — "this does not lift to characteristic zero" [STAT, `CURRENT_PATHS.md`]
- **What was actually established:** modular vanishing through degree 34 and above 164, with a one-dimensional `T₁` residue at degree 35 over the split `F_67` fibre. NOT established: any char-0 statement; the degree-35 residue is precisely what refutes the all-degree colon shortcut used in [E16](#e16).
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
- **Status:** SCOPED-POSITIVE (route closed) — all three maximal-subgroup obstructions are closed positively; no promotion to a dominant G-map exists, so the headline is untouched.
  - `H-A4-RATIONAL-POINT`, `H-A4-STRUCTURAL-MODEL-PASS` [DIR, `goal_runs_after_35fa/H_A4_TWIST/H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/STATUS.md`]
  - `H-A5-CLASS1-RATIONAL-POINT`, `H-A5-CLASS2-RATIONAL-POINT`, `H-A5-STRUCTURAL-MODEL-PASS` [DIR, `goal_runs_after_35fa/H_A5_TWISTS/STATUS.md`]
  - "The canonical generic `A_4` twist has an exact rational point... Both maximal `A_5` generic twists have exact rational points" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §1]
  - "The subgroup points close the corresponding subgroup point obstructions. They do not construct a dominant G-equivariant map... the `A_5` returns cannot be promoted" [WORK, §2.1]
  - Decision exits `N-E`, `P-E-SCOPED`, `E-STOP` — none resolved [WORK]
  - `08859c0` "Certify exact A4 surface parameters"; `20be6ba` "generic-twist continuation goal"; `2301a43` "resolve Goal H subgroup-twist sweep" [GIT]
- **What was actually established:** exact rational points on the generic `A4` twist and on both maximal `A5`-class generic twists; the corresponding subgroup obstructions are therefore dead. NOT established: any dominant G-map; the image dimension of the constructed maps is ≤2.
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
- **Status:** UNDECIDED — F1 terminality audit passes and F1/F2/F3 artifacts exist, but no decision exit is recorded.
  - `56e61c3` "Path F Gate F1-P — terminality audit passes"; `865b262` "Paths F and G cycle 2 — F existence undecided"; `3bfbd01` "post-Elo gate 1 — record Path F" [GIT]
  - Decision exits defined `N-F`, `P-F`, `F-LOCAL-SOLUBLE`, `F-STOP`; **no exit verbatim-resolved**; headline "OPEN" [WORK]
  - CERT inventory: `restricted_e3/{CUBE_TEST.md, DECISION.md, RESTRICTED_ETALE_ALGEBRA.md, divisor_vector_mod3.json, group_cohomology.json}`; `fixed_frame_arithmetic/{EXISTENCE_STATUS.md, TERMINALITY_AUDIT.md, conic_algebra_*, five_forms.json}` [CERT]
  - Bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger — but STAT flags "F" as ambiguous]
  - **Conflict (label attribution):**
    - *Side 1 (STAT):* the 08-02 ledger's bundled `TERMINAL` token "F" may denote this route.
    - *Side 2 (WORK + GIT + CERT):* Path F is a distinct in-repo route with its own gates and certificate dirs; the token "F" is equally readable as the Problem-F import ([E14](#e14)) or "Fable" ([E15](#e15)).
    - STAT itself cannot determine the referent. The `TERMINAL` label may be attached to the wrong object; unresolved.
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
- **Pointers:** `HANDOFF.md` 2026-07-28 sections; `RESOLUTION.md` "2026-07-29 structural advances" items 12–13; `CURRENT_PATHS.md` Deprioritized work
- *Lenses 4/7 (GIT, HAND, RES, STAT); confidence certain. The letter "F" is overloaded — see [E13](#e13), [E15](#e15).*

---

<a id="e15"></a>
### E15 — Fable — A4 trisection / Koszul lifting construction

- **Target:** positive construction — at a `V₄`-fixed centre (normalizer `A₄`), blow up the length-3 base orbit `R=X∩P(T)`, prove every `A₄`-equivariant `P(U)⇢X` has projected degree divisible by 3, and explicitly construct a degree-3 `A₄`-equivariant birational map `P(U)⇢S⊂X` onto a cubic surface `S(a,b,c)`; then lift compatibility across the whole 55-plane / D10 / D12 arrangement via symbolic Rees powers `I^(m)/I^(m+2)` and a Koszul construction, aiming at an actual landing covariant.
- **Justification:** A local positive construction that lifts to a global section of the symbolic sheaf would *be* the landing covariant, closing the headline positively.
- **Method:** mixed (equivariant geometry + CAS module/rank computations)
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
- **Status:** OPEN — highest-priority live route as of 2026-08-02; dominance and polar-system sub-gates PASS, the A5 semilinear quadratic interface is a scoped NO-GO, and the point decision itself is undecided.
  - "OPEN — Decide `V(Phi)(K_proj)` — Highest priority" [STAT, 08-02 ledger]; "G3 arithmetic OPEN" [WORK, `REMAINING_GOALS_NOTE.md`]
  - `G3A-ARITHMETIC-DOMINANCE-PASS` [DIR]
  - `G3P-POLAR-SYSTEM-PASS` [DIR]
  - `G3H-SEMILINEAR-G3-FRAME-PASS`, `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` [DIR]
  - `G3B-UNDECIDED` [DIR, `goal_runs_after_0aecc89/G3B_LINE_CONIC_SEARCH/STATUS.md`]; `G3C-UNDECIDED` [DIR, `goal_runs_after_0aecc89/G3C_LINE_CONIC_FANO/STATUS.md`]; `G3D-UNDECIDED` (primary exit) [DIR, `goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC/STATUS.md`] — G3D also records five structural PASS sub-labels (`G3D-K-SIMPLE-MODEL-PASS`, `G3D-POLAR-CUBIC-SURFACE-PASS`, `G3D-HESSIAN-KERNEL-PASS`, `G3D-HESSIAN-CUBE-REDUCTION-PASS`, `G3D-A5-STRUCTURED-DESCENT-PASS`) and three PARTIAL sub-labels (`G3D-POLAR-CLIFFORD-PARTIAL`, `G3D-SPINOR-DISCRIMINANT-PARTIAL`, `G3D-LINE-27-ALGEBRA-PARTIAL`)
  - `62a3fcb` "Path G3 — exit `G-PATTERN`"; `5eb1214` "add G3 universal cubic arithmetic goal"; `5cb3d11` "add G3A arithmetic and dominance goal"; `d1f43d6` "Add G3H A5 semilinear Springer execution order"; `7da4fdf` "Add G3S structured direct arithmetic execution order" [GIT]
  - **G7B invalidation resolved in-repo (confirmed 2026-08-03):** `4a5beac` (2026-08-02 14:54, ~2h after the flawed packet at `eb21458`) rewrote `goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/STATUS.md`: primary exit is now `G7-PROJECTIVE-SCALING-PASS` (re-derived by an independent chart-normalization/cone-lift method), the induced-cycle claim is downgraded to RESIDUAL, a refutation marker `G7B-INDUCED-CYCLE-REFUTED` is installed, the defect is documented in `cycles/INDUCED_CYCLE_REFUTATION.md` (`|Stab_G([e0])|=11`, `|G·[e0]|=60`, 44/44 equivariance checks failed), the withdrawn data is quarantined as `cycles/cycles_WITHDRAWN_rho_e0.json`, and the verifier is hardened (`verify_cycles.py` + `cycles/audit_induced_refutation.py`). See Verification debt item 4.
  - **Conflict (external audit vs run labels), unresolved here:**
    - *Side 1 (DIR run labels):* `G3A-ARITHMETIC-DOMINANCE-PASS`, `G3P-POLAR-SYSTEM-PASS`, `G3H-SEMILINEAR-G3-FRAME-PASS`.
    - *Side 2 (`sessions_batch4.md` § `2026-08-03-problem-e-review.md`):* "G3H phase-4 'executable field points' are unbuilt (formula-level/interpolated only, `INTERFACE_INSTALLED`)"; "phase-3/4 'independent verifiers' check hashes/strings, not algebra"; "G3D's internal phase ledger says `PASS` while prose says Clifford/spinor stages are partial/`UNDECIDED` (a direct self-contradiction flagged in-repo)".
    - The session's meta-claims about repo state may themselves be stale; both sides recorded.
- **What was actually established:** an exact arithmetic/dominance frame (`G3A`) — reported as proving `G3-DOMINANCE-AUTOMATIC`, i.e. that any exact `K_proj`-point automatically yields a dominant equivariant map with no separate Jacobian-rank-4 gate — plus a polar-system pass and a semilinear G3 frame. NOT established: a point of `V(Φ)`; the A5 quadratic interface is a scoped NO-GO; G3B/G3C/G3D carry no captured exit label.
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
- **Status:** OPEN — norm model and `μ₁₁`-torsor class installed and PASSING; the arithmetic binary is unresolved; ranked second-strongest negative route.
  - `H-11_5-NORM-MODEL-PASS` [DIR, `goal_runs_after_35fa/H_11_5_TWIST/STATUS.md`; WORK]
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

- **Target:** negative — prove `ed_C(G)=4` directly via a cohomological / canonical-dimension / motivic invariant that survives every 3-dimensional compression, auditing candidate invariants (cohomological invariants, equivariant Chow/Steenrod operations, canonical dimension/incompressibility, motives of generic projective representations, unramified cohomology) against four required criteria; realized as an equivariant resolution of the landing covariant's base locus with analysis of the resulting Prym factors.
- **Justification:** A single invariant that cannot drop under compression settles `ed_C(G)=4` outright.
- **Method:** analytic (with CAS resolution/Prym computation)
- **Status:** TERMINAL — the unrestricted invariant admits an extending countermodel; no point-sensitive invariant found.
  - `J2-UNRESTRICTED-COUNTERMODEL-EXTENDS` [DIR, `goal_runs_after_35fa/J_BASELOCUS_PRYM/STATUS.md`]
  - "theory watch" (queue status); decision exits `N-J`, `J-CANDIDATE`, `J-STOP` — none resolved [WORK, `WORKORDER_ELO_TEN_PATHS.md` Path J]
  - Bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger; STAT notes "content entirely unknown from this lens"]
  - **Conflict (route content):**
    - *Side 1 (WORK):* Path J is an *invariant audit* never executed ("theory watch").
    - *Side 2 (DIR):* an executed run whose exit is a *countermodel*, `J2-UNRESTRICTED-COUNTERMODEL-EXTENDS`.
    - Same letter, plausibly the same route after execution; no lens states the link. The canonical ledger's best reconciliation: J is the motivic/canonical-dimension invariant route, executed as the base-locus Prym analysis and terminated by a countermodel — parallel to the finding for D ([E10](#e10)).
- **What was actually established:** that the unrestricted invariant does not obstruct (a countermodel extends). NOT established: any statement about restricted or point-sensitive invariants.
- **Aliases:** Path J (Elo #10); Goal J; `J_BASELOCUS_PRYM`; exits `N-J`, `J-CANDIDATE`, `J-STOP`
- **Provenance:** `goal_runs_after_35fa/J_BASELOCUS_PRYM`; J1 candidate-invariant audit (planned).
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `GOAL_J_FIXED_CENTRE_PRYM.md` (added by `fa543e2`; indexed in `3569d63`); its Prym/one-motive analysis is also reported in § `progress-on-klein-cubic-6a705563.md` as "decisively demoted — should not be redispatched unchanged".
- **Pointers:** `goal_runs_after_35fa/J_BASELOCUS_PRYM/STATUS.md`; `WORKORDER_ELO_TEN_PATHS.md` (Path J)
- *Lenses 3/7 (DIR, STAT, WORK); confidence medium for the identity of the two descriptions.*

---

<a id="e22"></a>
### E22 — KLS — Kraft–Loetscher–Schwarz self-covariant landing framework

- **Target:** general framework, both directions — (positive) seek a primitive rank-4 self-covariant `q:W→W` whose Gauss-map/adjugate structure lands equivariantly on the Klein cone; equivalently (KLS theorem) `ed(G)=3` iff some nonzero homogeneous self-covariant `W→W` has identically zero Jacobian determinant; (negative) prove no minimal landing self-covariant exists (`h=1`, `ed(G)=4`) via the image hypersurface `H=V(F)`, the contracted-gradient gcd `h`, log-canonicity of the induced foliation, vertical/nonnormal divisor geometry, and a minimality-to-conductor reduction.
- **Justification:** The KLS criterion is an exact iff for the headline; the negative branch would give `ed(G)=4` from birational geometry alone, with no degree search.
- **Method:** mixed (birational geometry / foliation theory + CAS sweeps)
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

- **Target:** positive/structural — construct an exact type-I Sarkisov link (blow up a smooth plane cubic on the Schur generic Klein twist) to a relative degree-3 del Pezzo fibration over `P¹` with multisections of degree 3 and 55 (hence index 1), then search in Cox coordinates for an actual **rational section** (headline-positive) as opposed to only a degree-4 multisection (which proves index 1 only).
- **Justification:** A rational section of the dP3 fibration gives a `K_Schur`-point directly, closing the headline positively; the link is explicit and the search is finite-dimensional in Cox coordinates.
- **Method:** mixed (birational geometry + CAS Cox-ring search)
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
- **Status:** OPEN/DEFERRED — extensive partial structure, but the degree-25 landing locus is neither populated nor proved empty; further slices unauthorized and the route is explicitly "not headline without a bridge".
  - `P25-TOWER-EMPTY` / `P25-TOWER-SURVIVES`; `P25R0/1/2-*`; `P25X0/1/2-PASS/FAIL/UNDECIDED`; `P25Y-DVR-PASS`; `P25Z-ROW-RANK-746` ("the direct landing row rank is exactly 746"); `P25Z-FINITE-PRESENTATION-LOWER`; `P25W-PRESENTATION-EXACT/ENLARGE/UNDECIDED`; `P25-DEGREE25-EMPTY`; targets `P25-COVARIANT`/`P25-POLYNOMIAL` **not reached** [WORK]
  - `P25-UNDECIDED`; "63 charts on `D(H_8)`... `PREPARED_NOT_RUN`" [WORK, `REMAINING_GOALS_NOTE.md`]
  - historical 842-row / rank-28 packets "quarantined" and later "retired on mathematical grounds" [WORK, `DIRECTOR_HANDOFF.md`]
  - "P25.1 `P25-TOWER-SURVIVES` — retained as scoped free-fibre/degree-25 continuation"; "dim Z<=15"; "`P^21` a strict nonverdict (`3933 ≤ rank ≤ 7910`)"; "No `P^22` or successor slice is authorized" [HAND `R3`]
  - "OPEN/DEFERRED — Finite chart computation only — Not headline without bridge" [STAT, 08-02 ledger]; "Degree 25 remains open" [STAT, `CURRENT_PATHS.md`]
  - `19da967` "P25W — Stage A kernel incidence EMPTY"; `841005b` "P25Z.3 — direct landing row rank EXACTLY 746"; `2140419` "P25V.0 — degree-four closure FAILS"; `6096429` "V2 Track P25Y — `P25Y-DVR-PASS`"; `5e72d8e` "V2 Track P25X — `P25X0-PASS`, `P25X1-FAIL`; the 842 basis is not recovered" [GIT]
  - **Conflict (degree-25 emptiness), unresolved here:**
    - *Side 1 (canonical ledger, run artifacts):* the degree-25 landing locus is **neither populated nor proved empty**; `P25-UNDECIDED`; 63 charts `PREPARED_NOT_RUN`.
    - *Side 2 (`sessions_batch4.md` § `2026-08-03-problem-e-review.md`):* claims exit `DEGREE25-LANDING-EMPTY` — "no homogeneous degree-25 landing self-covariant in char 0" — derived as a corollary of the V4 simultaneous-normal classification, and committed under `goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/DEGREE25_COROLLARY.md` (added by `ac5e899`, "Close degree-25 landing stratum using V4 theorem"; `72147bd` only modified `STATUS.md`).
    - The canonical ledger files that corollary under [E33](#e33) and does not update E25's state. Do not treat degree 25 as closed on this basis without re-derivation.
    - **Verified scoping (confirmed 2026-08-03):** `DEGREE25_COROLLARY.md` is explicitly a "Bounded corollary" whose own packet proves only the order-three branch of the degree-25 filtration — via Theorem 2.12 of `THEOREM.md`, scoped to `A4`-equivariant simultaneous landing families with involution-plane order `m=1` and exact triple-line order three, independent of line degree. The order-two (parity-excluded) and order-≥4 (rank 56/56) branches asserted in the same corollary are **inherited unverified** from the HANDOFF-era degree-25 structural filtration — the same P25 family this entry records as `P25-UNDECIDED` with 63 charts `PREPARED_NOT_RUN`. The corollary's own text states: "It is not an all-degree theorem and does not settle equivariant unirationality." The conflict is real and stands; the headline stays OPEN.
- **What was actually established:** `dim Z ≤ 15`; direct landing row rank exactly 746; a DVR-properness pass; Stage-A kernel incidence empty; `P^21` a strict nonverdict (`3933 ≤ rank ≤ 7910`); the 842-row basis is not recoverable. NOT established: a degree-25 covariant, or (per the run artifacts) its nonexistence.
- **Aliases:** P25; P25.1–P25.4; P25R, P25V, P25W, P25X, P25Y, P25Z; `P25W-RankK`, ROW-RANK, SUPPORT-F4, TOWER, MOLIEN; HAND `R3`; CERT bucket `P` (`degree25_*`)
- **Provenance:** P25.1–P25.4 (CAS_HEADLINE); P25R.0–P25R.3 (REVISED); P25X.0–P25X.2 (DECISION/_V2); P25Y.1–P25Y.4 (AFTER_5E72D8E); P25Z.1–P25Z.3 (T9_P25Z); P25W.0–P25W.3 (T10_P25W_C2); P25V.0–P25V.3 (T11_P25V_C3); WP-B1, WP-6; `tmp/m1_relative_border_*`, `char0_lift_p19_d5`, `char0_lift_p20_d5`, `tmp/degree25_structural_probe`; `certificates/degree25_{exact, global, tower, finite_module, direct_support, support_f4, rowrank, rank_k, molien, p25v, p25w}`.
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `Goal P25` (`28faa47`) and `GOAL_P25_ENLARGED_CLOSURE_AND_SUPPORT.md` (added by `27fcc1b`; indexed in `37d61c1`); audited returns `P25V-PRESENTATION-ENLARGED` ("strongly supported, not canonical — decisive counts 4140/315 read from producer JSON, not independently recomputed") and `P25V-SUPPORT-UNDECIDED` (faithful).
  - `source: external-chatgpt` — `sessions_batch3.md` § `progress-on-klein-cubic-6a705563.md` issues a correction: "`K₁/(R₊K₁)` is NOT the primitive-covariant quotient — degree 25 must be rebuilt from the full 746-dim relation space."
- **Pointers:** `WORKORDER_CAS_HEADLINE.md` §5; `WORKORDER_CAS_HEADLINE_REVISED.md` §3; `WORKORDER_CAS_T9_P25Z.md`; `WORKORDER_CAS_T10_P25W_C2.md`; `WORKORDER_CAS_T11_P25V_C3.md`; `DIRECTOR_HANDOFF.md`; `HANDOFF.md` repair table line 41; `CURRENT_PATHS.md` Ranking A item 1
- *Lenses 6/7 (GIT, CERT, HAND, RES, STAT, WORK); confidence certain.*

---

<a id="e26"></a>
### E26 — Pfaffian — Pfaffian/Morita quaternionic descent bridge (Brauer index-2 / Hermitian gate)

- **Target:** positive construction + structural reduction — via Tschinkel–Zhang's Pfaffian bridge `X ↔ F14`, prove the generic projective Schur boundary class is nonzero of **period and index exactly 2** in `Br(K_proj)`, so the `P(V6)`-twist is a nonsplit non-stably-rational Severi–Brauer fivefold; pass to 2-planes to get `SB_2(A_proj)=P²_{D_proj}` (rational), reducing the headline to a **common isotropic right `D`-line for five Hermitian forms**; construct explicitly a reduced-rank-two `σ`-self-adjoint idempotent `e=(a²-c₁(a)a+c₂(a)1)/c₂(a)` by solving `c₃(a)=0, c₂(a)≠0`; separately search for matched polynomial covariants landing in the `F14` Pfaffian cone.
- **Justification:** This is the structural parent of the whole C-family: it converts the headline into an isotropy problem over an explicit quaternion algebra, and the target space `P²_D` is rational.
- **Method:** mixed (Brauer/algebra-with-involution theory + CAS)
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
- **Status:** TERMINAL-OBSTRUCTED — the descent obstruction closes this rational-curve route.
  - `R2-DESCENT-OBSTRUCTED` [DIR, `goal_runs_after_35fa/R_RATIONAL_CURVES/STATUS.md`]
  - "prior terminals" [WORK, `REMAINING_GOALS_NOTE.md` "Already terminal" table] — WORK explicitly notes "no mathematical description is given in any document read under this lens"
- **What was actually established:** the exit label only. No lens supplies the mathematical content of the obstruction.
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
- **Status:** SUSPENDED-PENDING-T2R — `T-BIRATIONAL` retained; `T-NONNORMAL` and `dim Sing_S=2` suspended/unproved; sub-gates T6/T8/T9 sealed at analytic non-unit results; T10/T11 sealed with `.1` stages undecided; T3 demoted to non-headline after `B-BRIDGE-REFUTED`.
  - PRE-REPAIR (historical): `T-NONNORMAL` proved, `dim Sing_S=2` proved, terminal marker `FOLD_NORMALIZATION_T2_VERIFIER_ACCEPT` treated as proof [STAT/`REPAIR.md`]
  - POST-REPAIR: "Path T: `T-BIRATIONAL` — retained at its stated generic/open theorem boundary"; "`T-NONNORMAL` — **suspended**; not proved by the current T2 packet; pending T2R gate"; "`dim Sing_S = 2` — **unproved**; current exact cuts do not establish it; pending T2R"; required interim label `T2-UNDECIDED pending exact saturated same-open dimension proof`; verifier explicitly must **not** be consumed as proof; "'normalization defect is divisorial' — unproved"; "'`Ann_B(S/B)` is the normalization conductor' — false notation; conductors separated" [HAND `R12`, RES `RES-25`, STAT/`REPAIR.md` §§1–3, §15]
  - `T2R-UNDECIDED`: `S₂` proved, `dim Sing(S_G) ≤ 2`, `R₁` undecided [WORK, `DIRECTOR_HANDOFF.md`]; `7fdbe42` "T2R.4 PASS (factors installed); T2R.5 still `T2R-UNDECIDED`" [GIT]
  - `T2-ROUTE-REFUTED` [DIR, `goal_runs_after_35fa/T_TARGET_BRANCH/STATUS.md`]
  - `17e0e5f` "Path T2 — exit `T-NONNORMAL`; S2 holds, R1 fails"; `d96b408` "Path T post-Elo — Gate T1 `T-BIRATIONAL`" [GIT]
  - `T60-UNDECIDED` [WORK, `DIRECTOR_HANDOFF.md` §8; GIT `11474f5`]
  - `T8-S1-UNDECIDED` (`dc43a86`); `T8-S1-NONUNIT-ANALYTIC` confirmed (`7866c68`); `T9-HENSEL-NONUNIT-SEALED`; `T8-N1` Jacobian correction sealed (`2645c91`) [GIT, WORK]
  - `T-BRANCH-NONNORMAL` (divisorial binodal locus); `T10-BINODAL-NO-3-DEFECT`; `T10.0` sealed, `T10.1 UNDECIDED` (`19e9490`); `T11.0` simple point sealed, `T11.1 UNDECIDED` (`faf6169`); `T11b Route C obstructed` (`715faf4`) [GIT, WORK]
  - `T10-FOLD-HEIGHT1`/`T11-FOLD-HEIGHT1` sought but undecided [WORK]
  - `T3-UNDECIDED`; "Local-runner portfolio only; fixed-frame; **not headline after `B-BRIDGE-REFUTED`**" [WORK, `REMAINING_GOALS_NOTE.md`]; ledger: T3 `AUXILIARY OPEN — Fixed-frame/non-headline after B — Local runner only` [STAT]
  - "the strongest developed negative route... needed facts are finite and local"; "Ordinary Picard theory is complete... Neither its vanishing nor a dangerous class has been proved" [WORK, `DIRECTOR_REVIEW_AFTER_BD610A.md` §4 Rank3, §2.4]
  - Ledger: T/T2 bundled `TERMINAL — Prior local obstructions/witnesses exhausted — Background only` [STAT, 08-02 ledger]
  - **Conflict (terminality):**
    - *Side 1 (08-02 ledger, offline):* T/T2 `TERMINAL`.
    - *Side 2 (`REPAIR.md` + run artifacts):* the T2R gate is **mandatory and pending** with no certified exit among `T2R-NONNORMAL`/`T2R-NORMAL`/`T2R-UNDECIDED`; T3 is blocked from consuming `T-NONNORMAL` until T2R exits; `7fdbe42` leaves T2R.5 explicitly `T2R-UNDECIDED`.
    - Per Binding rule 1, `REPAIR.md` and the run-level artifacts outrank the ledger: suspended-pending-T2R, not terminal. Separately, DIR's `T2-ROUTE-REFUTED` and GIT's `T-NONNORMAL` exit describe the same T2 packet whose conclusion `REPAIR.md` later suspended.
  - **Conflict (certificate ownership):** as in [E06](#e06) — CERT assigns `certificates/target_branch_{global,mod3,t10}` to route B; GIT/WORK tie `target_branch_t10` to T10 and HAND `R11`/`R12` place "target branch" inside Path T. Recorded in both entries; not merged.
- **What was actually established:** `T-BIRATIONAL` (at its stated generic/open boundary); `S₂` for `S_G`; `dim Sing(S_G) ≤ 2`; analytic non-unit results at T8/T9; a divisorial binodal locus with `T10-BINODAL-NO-3-DEFECT`. NOT established: `R₁`, `T-NONNORMAL`, `dim Sing_S = 2`, any class-group vanishing, or the index-three obstruction. The T2 verifier marker is explicitly not a proof.
- **Aliases:** Path T; T1–T4, T2R, T3, T3A, T6, T8, T8n1, T9, T10, T11, T11b; `T_TARGET_BRANCH`; `T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER`; Attempt 2; Path B "upstairs simple fold" (Elo ten paths); WP-T1; HAND `R11`/`R12`; RES `RES-25`; CERT `fold_*` and (contested) `target_branch_*`
- **Provenance:** `goal_runs_after_35fa/T_TARGET_BRANCH`; T1–T4 (POST_ELO); T3.1–T4 (HEADLINE); T2R.4–T2R.5 (REVISED); T6.0–T6.3; T8.1–T8.4; T9.0–T9.3; T10.0–T10.3 (+`_CORRECTION.md`); T11.0–T11.3; T3A local RUR exhaustiveness (`c9d75e1`); T3 split into local worker goals (`b49fc81`, `74045be`, `823beb1`); WP-T1; Path B B1–B4 upstairs normalization; `certificates/fold_normalization`, `fold_normalization_t2r`, `fold_normalization_t3`, `fold_decision_t6`, `fold_decision_t8`, `fold_decision_t8n1`, `fold_binodal_t9`, `fold_t11`, `fold_t11b`.
  - `source: external-chatgpt` — `sessions_batch2.md` § `t3-normalization-push-6a70553b.md`; pushed `goals_after_5899d0/T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER/` directly to main at `b49fc81` (README, WORK_ORDER, LOCAL_RUNNER_COMMANDS, ACCEPTANCE_MATRIX, WORKER_GOALS) — **planning documents only, no computed result or verifier packet**. The session delivered no proof, confirms "No T3 workflow exists on main", and notes it accidentally triggered GitHub Actions runs against an explicit local-runner-only instruction (runs failed at a preliminary boundary-audit step; the PR was closed with no changes). The packet itself states a successful T3 would prove only the "fixed-frame index-three theorem" and would **not** close Problem E after `B-BRIDGE-REFUTED`.
  - `source: external-chatgpt` — `sessions_batch1.md` § `github-repo-task-update-6a7054fb.md` records the T3 split into local workers (T3-RUR/NORM/DISC/PIC/INTEGRATE), fixed-frame only after B's failure.
  - `source: external-chatgpt` — `sessions_batch3.md` § `mathematical-equivariance-query-6a70557e.md` authored `Goal T` (`aaab49f`) and `GOAL_T2_TARGET_BRANCH_NORMALIZATION.md` (added by `ba5aa87`; indexed in `37d61c1`); § `progress-on-klein-cubic-6a705563.md` reports the target branch reduced to `ind(C/F)=3`, `C(F)=∅`, `Pic⁰(C)(F)=0`, `Pic(T_D)=ZH_z⊕ZH_λ`, the only escape being the horizontal 3-primary part of `(Cl(T_D)/Pic(T_D))[3]`, and that the critical locus is a **degree-14 curve, not 12 nodes** (killing a hoped-for ODP shortcut).
- **Pointers:** `REPAIR.md` Parts I, VI, §§1–3, §6, §15; `WORKORDER_CAS_HEADLINE.md` §3; `WORKORDER_CAS_HEADLINE_REVISED.md` §4; `DIRECTOR_HANDOFF.md`; `DIRECTOR_REVIEW_AFTER_BD610A.md`; `CURRENT_PATHS.md` lines 19–90; `certificates/fold_*/`
- *Lenses 7/7; confidence certain.*

---

<a id="e33"></a>
### E33 — V / V2 / V3 / V4 (+G5) — Genuine valuation / residue-twist obstruction

- **Target:** negative obstruction — analyze divisorial valuations on the twist and test whether a place is **transferable** to the genuine (non-fixed-frame) twist via inertia; decide pointlessness of the full residual `f5`/`f6` twist (a valuation/residue construction tied to the degree-11 torus structure) rather than of finite proxies; then classify simultaneous odd normal coefficients and test the trisection genus-two quotient approach (V4).
- **Justification:** A henselian valuation whose residue twist is pointless would give a genuine (not proxy) pointlessness certificate, closing the headline negatively — the failure mode that sank [E06](#e06) is exactly non-transferability, which this route attacks head-on.
- **Method:** mixed (CAS + valuation-theoretic argument)
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
- *Lenses 4/7 (DIR, GIT, STAT, WORK); confidence certain. The `DEGREE25-LANDING-EMPTY` corollary is in tension with [E25](#e25) — see that entry's conflict.*

---

<a id="e34"></a>
### E34 — WP-strata — Exact stabilizer strata & normal-cone transition necessity machine

- **Target:** infrastructure/negative — build a portable characteristic-zero stabilizer stratification of `P⁴` and `X`, tangent/normal character decorations, local transition modules, and a global inverse-limit ("normal-cone necessity theorem") as an **all-degree necessary-condition screen** for any hypothetical landing covariant; feeds Path G.
- **Justification:** If the inverse limit of transition conditions is empty, no landing covariant exists in any degree — an all-degree negative with no search.
- **Method:** CAS
- **Status:** INFRASTRUCTURE-PARTIAL — the stratification, local transition modules, global transition diagram, and border/Fitting integration are built and checked in; WP-6 exited STOP with a formulation; the machine produced no all-degree obstruction.
  - "Problem E remains open" (file-wide) [WORK, `WORKORDER_STRATA_MACHINE.md`]
  - Environment addendum: GAP / SageMath / Singular / PARI / Julia "NOT INSTALLED", blocking WP-1/WP-3 as literally specified [WORK]
  - type-I/type-II `V4` incidence inconsistency in the supplied `strata.md` flagged **unresolved** [WORK]
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
- **Status:** PROVED-INFRASTRUCTURE — the single most load-bearing reduction in the problem; decides nothing on its own.
  - "This proves the theorem" — proved unconditionally [RES `RES-23`]
  - "This exact reduction still does not choose between the two values, so the headline remains open" [RES `RES-23`, SPEC]
  - "none of the audited local, Brauer, Amitsur, or standard stable-cohomology invariants decides whether it has a point"; headline "OPEN" [HAND `INF1`]
- **What was actually established:** the equivalence, unconditionally, in both directions. NOT established: which of the two values holds.
- **Aliases:** HAND `INF1`; RES `RES-23`; "essential-dimension reduction"; `tmp/step4_essential_dimension`
- **Provenance:** `tmp/step4_essential_dimension/` (`REPORT.md`, `verify_reductions.py`).
  - `source: external-chatgpt` — `sessions_batch3.md` § `klein-cubic-threefold-psl-6a6b6514.md` reports an apparently from-scratch re-derivation of the same equivalence in-session (equivariant MMP / Prokhorov X-vs-F14 dichotomy, Brauer-index argument with degree-6 CSA of index ∈{1,2}, quadratic-descent lemma for cubic hypersurfaces, Duncan–Reichstein weakly-versal ⇒ very-versal upgrade), reducing to `X_gen(K_proj)≠∅` over the degree-1/4/5/6/7 covariant frame. No commits from that session.
- **Pointers:** `RESOLUTION.md` "Exact reduction to essential dimension"; `SPEC.md` "There is also a stronger unconditional reduction..."; `HANDOFF.md` "Strongest proved progress" item 1
- *Lenses 2/7 (HAND, RES); confidence certain.*

---

<a id="e38"></a>
### E38 — INV-INFRA — Exact action & certified invariant-theory infrastructure (E0)

- **Target:** infrastructure — fix exact cyclotomic matrices for `G→GL(W)` (660 elements), verify faithfulness and Klein-cubic invariance, compute exact Molien dimensions, and construct an explicit generic torsor / Hilbert-90 model; Sylow/abelian fixed loci.
- **Justification:** Every other entry computes inside this data; an error here invalidates everything downstream.
- **Method:** CAS
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
- **Status:** CONDITIONAL — and raises the stakes of a negative answer.
  - "would prove that `X` is `G`-unirational and that `ed(G)=3`" (conditional, unproved) [RES `RES-21`]
  - a negative headline resolution "would also **refute** Duncan–Reichstein Conjecture 8.8 in this example, because every Sylow restriction is already versal" [RES `RES-21`]
- **What was actually established:** that Condition A holds (every Sylow restriction versal), hence the conditional implication and the refutation stake.
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
- **Status:** CONDITIONAL — the mirror-image stake to [E49](#e49).
  - "would instead give `ed(G)=4`, which rules out `G`-unirationality of `X`" (conditional, unproved) [RES `RES-22`]
  - "a positive solution would give `ed(G)=3` and a **counterexample to Dolgachev's proposed inequality**" [RES `RES-22`]
- **What was actually established:** the implication and the symmetric stake. Together with [E49](#e49): whichever way Problem E resolves, a published conjecture falls.
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
- **Status:** ONGOING-CLEARANCE — no turnkey theorem exists; one absorbed import (Poonen–Stoll).
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
- **Justification:** The del Pezzo problems in this repo were closed by finding such an equivalent object; the same move might work here.
- **Method:** analytic
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
- **Status:** APPLIED — the governing correction layer.
  - `78abba4` "Klein cubic: audit A1 -- theorem-boundary audit of every standing exit" [GIT]
  - "Trusted results retained": Path A `P¹`-reduction; Path A index-34 duality; corrected Hodge-center split-injection theorem after §8 substitution; Path G finite truncation and isolation cutoff; Path G4.1 free-fibre recurrence; P25.1 `P25-TOWER-SURVIVES`; `T-BIRATIONAL` [HAND, RES, STAT]
  - "Suspended or downgraded": `T-NONNORMAL`, `dim Sing_S=2`, `G13/G19-OBSTRUCTION`, Path A single-minor formulation, Path A executable `L,V_Z` claim [HAND, RES]
- **What was actually established:** the corrected boundary of every standing claim. Specific outcomes: Path T `T-NONNORMAL` and `dim Sing_S=2` suspended pending T2R; Path G `G13/G19-OBSTRUCTION` → `SAMPLE-RESIDUAL`; Path A single-minor → ideal of all maximal minors, `(L,V_Z)` → abstract interface; Hodge-center proof rewritten via a relatively ample class (fixing a relative-dimension error); Pfaffian "abstract `K_proj`-point" scoped to the auxiliary characteristic cubic only; Schur "no rational point" → "no rational point is currently known".
- **Aliases:** `REPAIR.md`; "theorem-boundary audit of every standing exit"; GIT `78abba4`; the repair tables are reproduced identically in `HANDOFF.md`, `RESOLUTION.md`, `SPEC.md`, `CURRENT_PATHS.md`
- **Provenance:** `REPAIR.md` §§0–17; mandated file edits (`certificates/hodge_centers/HODGE_CENTER_NECESSITY.md`, `certificates/schur_krylov/*`, `certificates/fold_normalization*`). No external session; note that the offline 08-02 ledger post-dates this repair and conflicts with it in several places (see Open conflicts).
- **Pointers:** `REPAIR.md`; `HANDOFF.md` "2026-07-31 theorem-boundary repair"; `RESOLUTION.md`/`SPEC.md` repair tables; `CURRENT_PATHS.md` lines 19–90
- *Lenses 4/7 (GIT, HAND, RES, STAT); confidence certain.*

---

## External sessions

15 offline ChatGPT sessions, summarized in `notebook_build/sessions_batch{1,2,3,4}.md`.
Per Binding rule 4, **nothing below is machine-verifiable**; claims must be
re-derived in-repo before affecting the headline. Where a session's push landed
in the repo, the commit is cited in the corresponding attempt entry above with
the tag `source: external-chatgpt`.

| Session file | Title / gist | Date | Kind | Key outcomes | Repo artifacts |
|---|---|---|---|---|---|
| `mattrobball-unirational-task-6a7054e2.md` (b1) | "Complete packet L1" + Route 1/2 dispatch | 2026-08-02 | mixed (execute + review + plan) | `L1-FULL-RANGE-PASS` sealed; accepted G2/G3A/B/Q2.1/V3; **invalidated** `G7-INDUCED-DOUBLE-CYCLE-PASS` / `G7-PROJECTIVE-SCALING-PASS`; declared `R0` stale | `82de03d`, `d1f43d6`, `7da4fdf` (then `ff69434` deletion), `b1915a5` |
| `github-repo-task-update-6a7054fb.md` (b1) | Repeated full repo audit-and-dispatch cycles | 2026-08-02 | mixed (review + plan) | 3 successive audits vs true `main` heads; restates G/G2 five-way equivalence; H5 degree-11 isogeny identity; coins a **different** "L1" | `312ff0a`, `5cb3d11`, `25de051`, `3aa13c6`, `6558772` |
| `finish-m3-section-6a705514.md` (b1) | M3 section vs multisection / residual Galois | 2026-08-02 | mixed (execute + repair + merge) | `M3-INTEGRAL-DEGREE4-MULTISECTION`, `section_question: UNDECIDED`; repaired 42 merge-conflict lines; merged PR #6 | `96195e8` |
| `g-equivariant-rational-maps-6a7055aa.md` (b1) | Generalize obstruction to arbitrary `X⇢Y` | none stated | planning (theory only) | Generic obstruction schema; **explicitly had no repo access** | none |
| `finish-g-g2-theorem-6a705522.md` (b2) | Finish G/G2 universal object / all-degree theorem | 2026-08-02 | mixed (execute + verify + push) | `G2-FINITE-GENERATION-PASS`; five-way all-degree equivalence; Hironaka presentation; finite generation ≠ degree cutoff | PR #3 → `23f40f7`; `6a2ccaa` |
| `repo-push-results-6a70552d.md` (b2) | Finish V — valuation/residue obstruction | 2026-08-02 | execution (heavy `F_p` linear algebra) + push | `V3-RESIDUE-NORMAL-FORM-PASS`; `V-F5-DEGREE16-SUPPORT-LE5-EMPTY` (11,628 supports mod 67); governing exit stays `V-UNDECIDED` | PR #5 → `30ce03b`; `b77b04c`, `141f604` |
| `t3-normalization-push-6a70553b.md` (b2) | Finish T3 — normalization + Cl/Pic[3] | ~2026-08-02 | planning (work order only) | **No proof, no exit**; pushed T3.0–T3.5 program for a local runner; confirms no T3 workflow on main | `b49fc81` |
| `task-b-in-repo-6a70554b.md` (b2) | Finish task B — bridge/exhaustiveness theorem | 2026-08-02 | mixed (research + proof + push) | `B-BRIDGE-REFUTED` — the exhaustiveness theorem is **false**, via finiteness of `Γ_eff` in `Aut(Y_K̄)` | PR #4 → `5899d05` |
| `repo-push-request-6a705556.md` (b2) | Finish Q (mostly) — descent/obstruction theory | 2026-08-02 | mixed (theorems + literature + push) | `Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS`; transfer-annihilation Thm 2.1; `π₁^et(X_K̄)=1`; goal exit stays `Q-UNDECIDED` | `4e44e73` |
| `progress-on-klein-cubic-6a705563.md` (b3) | Director review of worker returns through `bd610a0` | none explicit | mixed (review + dispatch) | A4 + both A5 twists have exact rational points (prior emptiness invalidated by wrong transpose convention); Sarkisov disjunction; critical locus is a degree-14 curve, not 12 nodes | branch head `83d35f7`; draft PR #1 (**never merged in-session**) |
| `mathematical-equivariance-query-6a70557e.md` (b3) | Fixed-stratum census → 3 rounds of goal dispatch | folder `goals_2026-08-01` | mixed (derivation + dispatch) | V4-line bound, mod-330 sieve; `H^{1,0}(E_t)≅sgn` strengthening of Hodge-center; degrees 1–24 excluded, 25 first open; faithfulness audit of 15-goal wave (only 6/15 returned meaningful packets) | `089bdc6`, `3569d63`, `37d61c1` |
| `klein-cubic-threefold-psl-6a6b6514.md` (b3) | "Prove or disprove: Klein cubic is PSL-unirational" | none (cites 2026-07-18 CTZ) | mixed (derivation + technique generalization) | Re-derives `G`-unirational ⟺ `ed_C(G)=3`; claims **new** OD16 and C9⋊C3 negative theorems; confirms Problem-F mechanism fails on Klein | **none pushed** |
| `g-equivariant-rational-maps-6a70559f.md` (b4) | Obstructions from fixed strata / normal cones (LaTeX) | 2026-07-31 | planning (theory + survey) | Graph/valuative/normal-cone necessity theorems; retracts "exceptional-chain" for "fixed-divisor constancy"; proves **no inheritance theorem**; Klein involution locus has both a rational line and an elliptic curve | none (sandbox `.tex`/`.pdf` only) |
| `mathematical-machine-implementation-6a7055b7.md` (b4) | Universal fixed-stratum machine work order (P0–P8) | none (refs `62a3fcb`) | planning (work order + proof notes) | 9-part work order; LaTeX proof notes for OD16 and C9⋊C3; **Priority-0 checkers never built or run** | none (sandbox `.md`/`.tex`/`.pdf`/`.zip`) |
| `2026-08-03-problem-e-review.md` (b4) | Problem E review, ledger, ranking, V4 proof attempt | 2026-08-02 content / 2026-08-03 session | mixed (ledger + self-critique + execution) | Pushed the 08-02 ledger and 10-route goals; self-audit found them "already materially stale"; V4 classification PASS, genus-2 quotient PASS, `DEGREE25-LANDING-EMPTY`, and `V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED` | `61b1902`, `f1f0be5`, `fb4bcea` (+ `ebb5769`, `08859c0`, `72147bd`) |

### Sessions that made load-bearing claims

**`mattrobball-unirational-task-6a7054e2.md`** — sealed `L1-FULL-RANGE-PASS` ([E23](#e23)) using pure `fractions.Fraction` arithmetic with no external CAS, extending the coefficient/obstruction recursion for `F(p)` past the historical `3m+3` boundary through the full `3d` range. Its second contribution is corrective: it independently recomputed point stabilizers in the 660-element model and **declared `G7-INDUCED-DOUBLE-CYCLE-PASS` and `G7-PROJECTIVE-SCALING-PASS` invalid** (`|Stab_G([e0])|=11`, `|G·[e0]|=60`, 44/44 generator-point equivariance checks failed). It accepted `G2-FINITE-GENERATION-PASS` as "strategy-changing" and `G3A-ARITHMETIC-DOMINANCE-PASS` as establishing `G3-DOMINANCE-AUTOMATIC`. It dispatched but did not execute Routes 1 (G3H) and 2 (G3D).

**`github-repo-task-update-6a7054fb.md`** — three successive full audits against real `main` heads (`b49fc81` → `0aecc89` → later), each reconciling a stale `REMAINING_GOALS_NOTE.md`, each concluding the headline is open. Load-bearing content: a restatement of the G/G2 five-way equivalence chain; the observation that the dominance step was **unproven at the time of writing** and "should be made binding by G3"; and the H5 degree-11 isogeny group-ring identity `(2+σ)(5-3σ+σ²-σ³)=11-(1+σ+σ²+σ³+σ⁴)`. Its external-literature claims came from live web search.

**`finish-m3-section-6a705514.md`** — authorized `M3-INTEGRAL-DEGREE4-MULTISECTION` with `section_question: UNDECIDED` ([E24](#e24)), claiming the degree-4 multisection is unconditional in both branches (no-section via a point-or-degree-4 theorem, section via a cyclic quartic extension plus Weil restriction of Kollár unirationality), so quartic-locus nonemptiness alone cannot select the section branch. It also repaired real repo corruption (42 merge-conflict artifact lines across four authoritative M3 files) and merged PR #6. It self-discloses that the full repository-level M3 replay was never executed.

**`finish-g-g2-theorem-6a705522.md`** — the source of `G2-FINITE-GENERATION-PASS` ([E16](#e16)): identifies the universal object as the generic twist `X_T = T×^G X` over `K_proj`, proves the all-degree equivalence among five formulations, proves the `F(p)=h³Φ(a)` two-way denominator clearing, verifies `PSL(2,11)` perfect of order 660, and records a finite Hironaka presentation (`rank_A R=12`, `rank_A M=60`) together with an explicit counterexample showing finite generation does **not** give a finite degree cutoff. It states the upstream replay re-deriving the 35-coefficient `generic_cubic.json` was "installed but not executed".

**`repo-push-results-6a70552d.md`** — produced `V3-RESIDUE-NORMAL-FORM-PASS` ([E33](#e33)): a structural theorem constraining any henselian-nonpoint valuation (trivial inertia; non-C1 residue field with `trdeg≥2`; rational and Krull rank `≤2`; decomposition group `PSL(2,11)` or maximal `11:5`; residue twist smooth of index one), hence every Krull-rank-≥3 valuation is locally soluble. Plus `V-F5-DEGREE16-SUPPORT-LE5-EMPTY`: all 11,628 size-≤5 coefficient supports among 19 variables (151 independent equations mod 67) are projectively empty. **No CAS was available** — all linear algebra was hand-rolled Python/numpy over `F_p` with no independent cross-check.

**`task-b-in-repo-6a70554b.md`** — the `B-BRIDGE-REFUTED` result ([E06](#e06)). It establishes `dim Σ ≤ 1` and that the admissible gauge group `Γ` has **finite** effective image in `Aut(Y_K̄)`, citing Kuznetsov–Prokhorov–Shramov Thm 1.1.2 (Picard-rank-1 genus-8 prime Fano threefolds; `Y` not among the infinite-automorphism exceptions), so ≤1-dimensional translates cannot exhaust the threefold. It states the proposed theorem is **false rather than merely unproved**, and explicitly does not decide `F_{14,T}(K_proj)`, `X_gen(K_proj)`, or the implication `C(K_proj)=∅ ⇒ F_{14,T}(K_proj)=∅`.

**`repo-push-request-6a705556.md`** — the Q descent audit ([E27](#e27)). Theorem 2.1 (transfer-annihilation) uses the coprime degrees 3 and 55 (Bézout `55-18·3=1`) to kill any point-trivializing abelian class with restriction/corestriction; corollaries neutralize commutative torsor recipients (Picard/Albanese/Brauer/Amitsur/tori/semiabelian/abelian varieties), constant finite nonabelian recipients, and — via Jodi Black — semisimple recipients. Theorem 4.1 proves `π₁^et(X_K̄)=1` by Grothendieck–Lefschetz, making finite étale/fppf descent tautological. The packet flags `binary_claim_made: false`.

**`progress-on-klein-cubic-6a705563.md`** — the director review that overturned the A4-twist emptiness computation (**wrong transpose convention**) and reported exact rational points on the generic A4 twist and both maximal A5 twists via degree-11 Reynolds covariants ([E11](#e11)), while insisting these give no dominant G-map (image dimension ≤2). It also recorded the Sarkisov disjunction, the exact 11:5 trace-cubic rewrite, the target-branch reduction to the horizontal 3-primary part of `(Cl(T_D)/Pic(T_D))[3]`, and the correction that the critical locus is a degree-14 curve rather than 12 nodes (killing a hoped-for ODP shortcut). Its PR #1 was opened as a draft and **not merged in-session**.

**`mathematical-equivariance-query-6a70557e.md`** — derived the fixed-stratum necessary conditions (V4-line order bound `ord_R(p)≥(3m+1)/2`, mod-330 degree sieve, compulsory base points) and a claimed strengthening of the Hodge-center screen: `H^{1,0}(E_t)≅sgn` under the residual `S3` ⇒ the 55 fixed elliptics cannot supply `H^{2,1}(X)` ([E19](#e19)). It concluded that the character-valued Jacobian obstruction does not kill the first live family `(m,d)=(1,7)`, that "no stronger invariant of the abstract fixed locus alone is likely to work", and that the degree cutoff is "weak-to-moderate negative evidence, not strong asymptotic evidence" because compatible-plane-jet growth `O(d²)` dominates constraint growth `O(d)`. Its faithfulness audit of the 15-goal wave found only 6/15 routes returned meaningful packets and flagged `COV-STRUCTURED-DEGREES-EMPTY-SCOPED` as an invalid exit label.

**`klein-cubic-threefold-psl-6a6b6514.md`** — re-derived `X` G-unirational ⟺ `ed_C(G)=3` from scratch ([E37](#e37)) and independently confirmed that Problem F's involution obstruction does **not** transfer, because the negative eigenspace gives an entire line `L_t⊂X` (V4 gives a triangle of such lines) so "the transition analysis closes rather than producing contradictory endpoint values" ([E14](#e14)). It also observed that a quartic `G`-endomorphism exists (degree scaling `4ⁿd`), so no uniform degree bound can justify a finite search. It claims **two new theorems outside Problem E** (OD16 Type-II on the Fermat degree-2 del Pezzo, and C9⋊C3 on the Fermat cubic threefold, both not weakly versal), but the same response's "remaining possible exceptions" list still names C9⋊C3 — an internal inconsistency. Nothing was pushed.

**`2026-08-03-problem-e-review.md`** — pushed `PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md` (`61b1902`) and `GOALS_NEXT_10_ROUTES_2026-08-02.md` (`f1f0be5`), then self-audited both as "already materially stale" (G4/H6/G5/Q3 had completed packets listed as "not started"; G3H phase-4 field points unbuilt; phase-3/4 "independent verifiers" check hashes and strings, not algebra; G3D's phase ledger says `PASS` while its prose says `UNDECIDED`). Its own execution attempt produced `V4-SIMULTANEOUS-CLASSIFICATION-PASS`, `M1-TRIPLE-ORDER3-ALL-LINE-DEGREE-EMPTY`, `V4-TRISECTION-GENUS2-QUOTIENT-PASS` (`κ± = (13±3√33)/16`; genus-2 curve smooth since resultant `64(κ₊−κ₋)³≠0`) and a `DEGREE25-LANDING-EMPTY` corollary — but then found an explicit primitive line-degree-6 toric-boundary counterexample family refuting the blanket local-V4-path strategy (`V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED`). Headline left OPEN, with a stated personal "modestly negative" lean.

### Sessions with no load-bearing repo claims

`t3-normalization-push-6a70553b.md` delivered a work-order packet only, with no proof and no exit ([E32](#e32)); it also accidentally triggered GitHub Actions runs against an explicit local-runner-only instruction. `g-equivariant-rational-maps-6a7055aa.md`, `g-equivariant-rational-maps-6a70559f.md`, and `mathematical-machine-implementation-6a7055b7.md` are theory/planning sessions that pushed nothing; the latter two nevertheless assert repo facts (Klein involution fixed-locus structure, the character of the repo's PSL(2,7) argument, OD16/Fermat fixed-scheme data) that were never machine-checked.

### Required caveats

**(a) Connector/tool outputs are redacted and unrecoverable.** The share pages redact tool output. `repo-push-results-6a70552d.md` alone ran ~500 tool calls that are "almost entirely redacted". The derivations behind several sealed claims — notably the `Γ_eff` finiteness argument in `task-b-in-repo-6a70554b.md` — are therefore not inspectable from the transcripts at all.

**(b) Session claims are not machine-verifiable (Binding rule 4).** Nothing in this section may move the headline until re-derived in-repo. Where a session's packet ships a `verify.py`, that script generally checks hashes, JSON validity, and text markers — not the algebra (see Verification debt item 1).

**(c) `g-equivariant-rational-maps-6a7055aa.md` had NO repo access.** The assistant states plainly (verbatim): "I do not have the repository contents available from the current tool context, so I cannot honestly claim to have read the exact implementation" — paraphrased above as "could not access the repository contents" — and produced a from-scratch generic framework instead. Its apparent matches to repo terminology (fixed-locus obstruction, stratification monotonicity, inertia/quotient-stack formulation) are **coincidental**. If that framework is ever invoked to justify or extend an in-repo obstruction argument (B, Q2.1, V3, H5/H6), it must first be checked against those packets' actual definitions.

**(d) "L1" name collision.** `mattrobball-unirational-task-6a7054e2.md` uses `L1` for the **full polar range recursion** ([E23](#e23), commit `82de03d`, `goal_runs_after_7030dd/L1_FULL_POLAR_RANGE/`). `github-repo-task-update-6a7054fb.md` independently coins `L1` for **"ambient self-map rigidity"**, an entirely different proposed route citing a "G-birationally superrigid" theorem. These are two different objects sharing one label; the first session had to spend effort disambiguating what "packet L1" even meant. Do not conflate them, and do not read `L1-FULL-RANGE-PASS` as bearing on self-map rigidity.

---

## Verification debt

Aggregated from the `verify_flags` of all four sessions files plus the canonical
ledger's conflicts. Priority order 1–8 is fixed by the strategic weight of the
claim; 9+ are ordered by route.

### 1. Packet `verify.py` scripts check hashes and markers, not algebra — systemic

- **Claim under test:** that a `verify.py`/`SEAL.json` replay constitutes verification of a packet's mathematics.
- **Why load-bearing:** this is the foundation of the entire seal regime, and it is false. Three independent sessions say so: `repo-push-request-6a705556.md` ("checks only self-consistency — Bézout arithmetic, git-blob hashes, presence of required text markers — and explicitly does **not** machine-verify the cited Grothendieck–Lefschetz or Jodi Black theorems; mathematical correctness of Theorems 2.1–5.1 rests entirely on unverified prose/LaTeX"); `finish-g-g2-theorem-6a705522.md` ("only local packet self-consistency checks (hashing, JSON structure, text markers) were executed"); `2026-08-03-problem-e-review.md` ("phase-3/4 'independent verifiers' check hashes/strings, not algebra"). Binding rule 3 already states this; the debt is that packets are nonetheless cited as if replay settled them.
- **Where it lives:** every `goal_runs_after_*/*/verify.py` and `SEAL.json`.
- **What verification looks like:** a per-packet triage marking each verifier as `HASH-ONLY`, `ARITHMETIC`, or `ALGEBRA`; then, for every packet whose exit label is cited in a headline argument, an independent re-derivation of the mathematical step rather than a replay.

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
- **Verified scoping (confirmed 2026-08-03):** `DEGREE25_COROLLARY.md` proves only the order-three branch of the degree-25 filtration (via Theorem 2.12, scoped to `A4`-equivariant, `m=1` involution-plane order, exact triple-line order three, any line degree); the order-two and order-≥4 branches are inherited unverified from the HANDOFF-era filtration. The corollary's own text: "It is not an all-degree theorem and does not settle equivariant unirationality." See [E25](#e25) and conflict 13.

### 7. M3 full replay never executed

- **Claim under test:** `M3-INTEGRAL-DEGREE4-MULTISECTION` as an *unconditional* both-branch result (no-section branch via a point-or-degree-4 theorem; section branch via a cyclic quartic extension plus Weil restriction of Kollár unirationality).
- **Why load-bearing:** it is the terminal exit for [E24](#e24) and it defines the residual dichotomy (section ⟺ imprimitive quartic) that the remaining Galois-descent route is built on. The session itself states "The complete repository-level M3 replay was not executed in this environment" — it checked only Python syntax, JSON validity, absence of merge markers, and SHA-256 against `SEAL.json`.
- **Where it lives:** `goals_after_bd610a/M3_SARKISOV_SECTION/`; merge commit `96195e8` (PR #6).
- **What verification looks like:** run `verify_all.py` against `SEAL.json` in-repo end to end; confirm current `main` is genuinely free of merge-conflict artifacts and that seal hashes are internally consistent (the session only partially checked this after its own repair); spot-check the early-exploration claims that underlie the "unconditional" framing — 1,485 secants checked, a smooth 4-dimensional degree-3 component, and the index-4 subfield exclusion.

### 8. External-literature citations from in-session web search

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

- **Claims:** per-degree exclusions for 22–24 ("unit ideal on all charts", computational); the P25 quartic-membership counts 4140/315, **explicitly self-flagged as read from producer JSON and not independently recomputed**; the COV zero-module claims for `(d,m,e)=(25,3,7),(31,5,1),(35,5,5)`.
- **Why load-bearing:** the degree ladder of [E16](#e16) and the "degree 25 is first open" framing rest on them, as does the reduction of degrees 25/31/35 to the `m=1` case.
- **Where:** `tmp/degree22_compression`, `degree23_common_line_landing`, `degree24_landing`; `goal_runs_after_35fa/A0_CANONICAL_AUDIT`; `goal_runs_after_35fa/COV_M1_DEG31_35`.
- **Verification:** independently recompute 4140/315 from the certified action rather than reading the producer JSON; re-run the chart computations for 22–24; re-derive the three zero-module claims. Also retire or correct the invalid exit label `COV-STRUCTURED-DEGREES-EMPTY-SCOPED`.

### 14. Was T3.0–T3.5 ever executed?

- **Claim:** none — `t3-normalization-push-6a70553b.md` landed planning documents only.
- **Why load-bearing:** "T3" must not be treated as touched in any substantive way; and after `B-BRIDGE-REFUTED` a successful T3 would prove only the fixed-frame index-three theorem, not the headline.
- **Where:** `goals_after_5899d0/T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER/`; commit `b49fc81`.
- **Verification:** check whether any later run directory carries a T3 exit label; confirm no T3 workflow exists on `main`.

### 15. Off-problem theorems asserted by planning sessions

- **Claims:** OD16 Type-II on the Fermat degree-2 del Pezzo and C9⋊C3 on the Fermat cubic threefold are not weakly versal / not unirational; the "rational-chain going-down principle"; the assertion that the repo's PSL(2,7) result is "the all-degree V4-exceptional-path obstruction"; the assertion that the Klein involution fixed locus contains **both** a rational line and an elliptic curve.
- **Why load-bearing:** the last of these is the stated reason the cheap fixed-divisor test fails for Problem E and therefore why the full stratification machinery ([E34](#e34)) is required. The OD16/C9⋊C3 "theorems" were never machine-checked (Priority-0 checkers unimplemented) and one session's own text is internally inconsistent about whether C9⋊C3 is closed.
- **Where:** sessions `klein-cubic-threefold-psl-6a6b6514.md`, `g-equivariant-rational-maps-6a70559f.md`, `mathematical-machine-implementation-6a7055b7.md` — **none pushed anything to the repo**.
- **Verification:** check the Klein involution fixed-locus claim against the repo's actual involution data; if the OD16/C9⋊C3 results are ever imported, build and run the exact-arithmetic checkers first; resolve the closed-vs-still-listed inconsistency against the actual CTZ paper state.

### 16. Ledger-vs-artifact conflicts inherited from the canonical ledger

Each of conflicts 1–12 in the next section is verification debt in its own right.
The three with headline consequences are: **T-track terminality** (the 08-02 ledger
says `TERMINAL`, `REPAIR.md` holds the T2R gate pending — resolve by exiting T2R);
**KLS terminality** (ledger says `TERMINAL`, `CURRENT_PATHS.md` lists open branches
— resolve by deciding whether the framework is authorized); and the **`certificates/elliptic_lifting` ownership**
question, which determines whether [E28](#e28)'s exit label has any mathematical content behind it.

---

## Open conflicts and identity questions

### Open conflicts (from `canonical_attempts.md` §(b))

1. **T-track terminality** ([E32](#e32)). Ledger (offline): T/T2 `TERMINAL — Background only`. Against: `REPAIR.md` holds the T2R gate **mandatory and pending** (no certified exit among `T2R-NONNORMAL`/`T2R-NORMAL`/`T2R-UNDECIDED`), T3 is blocked from consuming `T-NONNORMAL`, and `7fdbe42` leaves T2R.5 `T2R-UNDECIDED`. *Resolution applied:* REPAIR + run artifacts outrank the ledger → suspended-pending-T2R, not terminal.
2. **KLS terminality** ([E22](#e22)). Ledger: KLS/KLS2 `TERMINAL — Background only`. Against: `CURRENT_PATHS.md` (07-29/07-30) lists still-open branches (LC-minimality + vertical-divisor pair, nonnormal conductor, degree-12 Jacobian exceptional locus, unsolved flat-connection PDE); `KLS_MINIMALITY/STATUS.md` records only `KLS2-NO-FINITE-REDUCTION`. *Resolution applied:* the *reduction* is closed; the framework is open-but-unauthorized.
3. **B status reversal** ([E06](#e06)). 2026-07-30 `CURRENT_PATHS.md`: leading active route with positive milestones. 2026-08-02: `B-BRIDGE-REFUTED` in a run `STATUS.md`, `REMAINING_GOALS_NOTE.md`, and the ledger. *Resolution applied:* the refutation is corroborated outside the offline ledger; the reversal is genuine. Downstream, T3 and the fixed-frame arithmetic are demoted to non-headline.
4. **Ledger label "F"** ([E13](#e13) vs [E14](#e14) vs [E15](#e15)). STAT cannot tell whether the 08-02 ledger's bundled-terminal "F" means Path F (fixed-frame genus-one / restricted `E[3]`), the Problem-F technique import, or "Fable". Three distinct objects share the letter. **Unresolved.**
5. **Fable order-12 dispatch vs closure** ([E15](#e15)). `WORKORDER_ORDER12.md` dispatches the second Koszul gate as active; `WORKORDER_STRATA_MACHINE.md` addendum + HAND `R19`/`R20` record the branch closed by two obstruction theorems. Chronology suggests dispatch-then-closure but no lens states it. **Unresolved.**
6. **"G4" label collision** ([E16](#e16) vs [E04](#e04)). GIT/HAND: G4 = "Route G verdict, G4.1 symbolic free-fibre recurrence" (2026-07-31). DIR/WORK: `G4_A5_INDEX11_TRANSFER` with `G4-INDUCED-DEGREE11-POINT-PASS` (2026-08-02). Two different objects.
7. **"G7" label collision** ([E16](#e16) vs [E17](#e17)). GIT `c28bb08`: "degree-7 exits `G7-OBSTRUCTION`" inside Path G. DIR: `goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE`. Two different objects.
8. **"V2" label collision** ([E33](#e33)). GIT "V2 Track T / T8 / P25X / P25Y / C0" = the `_V2` work-order document. DIR `V2-FIXED-FRAME-PLACE-NONTRANSFERABLE` = exit label of `V_GENUINE_VALUATION`. Two different objects.
9. **"H1" / "H" label collisions** ([E11](#e11), [E18](#e18), [E19](#e19), [E22](#e22)). GIT `H1` = WP-H1 Hodge-center; WORK `H1` = the "two maximal A5 classes" gate in `WORKORDER_CAS_HEADLINE.md` §9 *and* the KLS Path-H target-theorem task; GIT `H` (`2301a43`) = Goal H subgroup-twist sweep; DIR `H` = `H_11_5_TWIST`. **At least four referents.**
10. **A5Q expansion** ([E04](#e04)). STAT reads A5Q = "A5-quadric branch (KLS)"; DIR/WORK/GIT read A5Q = "A5 quartic rescue / index-11 transfer". Resolved 3–1 in favour of quartic rescue; STAT's reading is preserved because the KLS A5-quadric branch is a real, separately-closed object.
11. **J route content** ([E21](#e21)). WORK: a never-executed invariant audit ("theory watch"). DIR: an executed run exiting `J2-UNRESTRICTED-COUNTERMODEL-EXTENDS`. Same letter; link inferred, not stated.
12. **`certificates/elliptic_lifting` ownership** ([E28](#e28) vs [E34](#e34)). Claimed by R/R2 (Pfaffian elliptic quintic descent, `PICARD_OBSTRUCTION.md`) and by WP-E1 ("elliptic `Pic⁰` obstruction", Path G lifting blockers). **Unresolved.**

### Additional conflicts surfaced by the session merge

13. **Degree-25 emptiness** ([E25](#e25) vs [E33](#e33)). Run artifacts and the canonical ledger hold degree 25 `OPEN/DEFERRED` — neither populated nor proved empty, with 63 charts `PREPARED_NOT_RUN`. Against: `2026-08-03-problem-e-review.md` claims exit `DEGREE25-LANDING-EMPTY` ("no homogeneous degree-25 landing self-covariant in char 0") as a corollary of the V4 classification, committed at `ac5e899` under the V4 packet (`72147bd` only touched `STATUS.md`). **Verified scoping (confirmed 2026-08-03):** the corollary's own packet, `DEGREE25_COROLLARY.md`, proves only the order-three branch of the degree-25 filtration (via Theorem 2.12, scoped to `A4`-equivariant, involution-plane order `m=1`, exact triple-line order three, any line degree); the order-two (parity) and order-≥4 (rank 56/56) branches are inherited unverified from the HANDOFF-era degree-25 structural filtration — the same P25 family E25 records as `P25-UNDECIDED` with 63 charts `PREPARED_NOT_RUN`. The corollary's own text: "It is not an all-degree theorem and does not settle equivariant unirationality." **Unresolved** — the conflict is real and stands; do not treat degree 25 as closed without re-derivation.
14. **"L1" collision across sessions** ([E23](#e23) vs a proposed route). `mattrobball-unirational-task-6a7054e2.md`: `L1` = full polar range recursion (commit `82de03d`). `github-repo-task-update-6a7054fb.md`: `L1` = "ambient self-map rigidity", a different proposed route citing a `G`-birational superrigidity theorem. Two objects, one label; the first session had to disambiguate before starting.
15. **G3 sub-packet labels vs external audit** ([E17](#e17)). DIR run labels record `G3A-ARITHMETIC-DOMINANCE-PASS`, `G3P-POLAR-SYSTEM-PASS`, `G3H-SEMILINEAR-G3-FRAME-PASS`. Against: `2026-08-03-problem-e-review.md` reports G3H phase-4 field points unbuilt (`INTERFACE_INSTALLED`, formula-level/interpolated only) and a direct self-contradiction inside G3D (phase ledger `PASS` vs prose `UNDECIDED`). That session's repo-state claims may themselves be stale. **Unresolved.**

### Identity questions (from `canonical_attempts.md` §(c))

| Pair | For merging | Against | Verdict |
|---|---|---|---|
| [E07](#e07) C0–C3 ↔ [E08](#e08) C5/C6 | same target (`K_proj`-point of `F_{14,T}` via a common isotropic right `D`-line); WORK records C5 as the *corrected* successor model | CERT keeps `fano_c0..c3` as a closed certificate family with its own exits; DIR/GIT treat C5/C6 as new Aug-2 goal runs with new labels | **KEPT SEPARATE** — successor relationship, not identity |
| [E01](#e01) A ↔ [E30](#e30) S19 | CERT groups `schur_krylov` + `schur_degree19` under one heading "A"; WORK titles its entry "S19-Krylov (Attempt 3 / Path A Krylov / Route S19)" | DIR has a distinct `S19_MARKED_CURVE` run with its own `S19-UNDECIDED`; GIT has distinct `PathA`/`A_empty` commits; the repo assigns distinct route codes | **KEPT SEPARATE** — two stages of one Schur programme |
| [E06](#e06) B ↔ [E32](#e32) T, via `certificates/target_branch_*` | CERT assigns `target_branch_{global,mod3,t10}` to "B"; both work the same fixed-frame/target-branch geometry | `target_branch_t10/exit_t10.json` matches GIT's T10 work order (`1d3fe3b`); HAND `R11`/`R12` place "target branch" inside Path T | **KEPT SEPARATE**, certificates listed under both |
| [E05](#e05) Attempt1 ↔ [E26](#e26) Pfaffian | GIT `1c07871` and WORK share the verbatim `FAIL-SCOPE` exit and bridge language; `certificates/pfaffian_point/{BRIDGE_AUDIT.md, CFOSS_W1_INPUT.md}` matches WORK's Attempt-1 gate 1B | none | **MERGED** — Attempt 1 = the Pfaffian–Morita idempotent gate |
| [E10](#e10) D/D2 ↔ [E19](#e19) Hodge-center | WORK presents them as one entry (D1 = "repair split-injection proof", D2 = "geometric channel screen"); both conclude the unrestricted invariant is too flexible | DIR/GIT/HAND/RES/STAT treat the Hodge-center theorem as standalone with its own certificate dir | **KEPT SEPARATE** — Hodge-center is a theorem inside the broader D route |
| [E21](#e21) J: WORK-description ↔ DIR-run | same letter; both are "invariant that survives every compression" arguments; both terminate without an obstruction | WORK's version is explicitly never executed; DIR's has an exit label | **PROVISIONALLY MERGED**, discrepancy kept as conflict 11 |
| [E23](#e23) L1 ↔ WP-L1 | both are "universal polar expansion / full polar range" over the Path G lifting tower | WORK never uses the code `L1`; DIR never uses `WP-L1` | **KEPT SEPARATE** (single entry, alias flagged, medium confidence) |
| [E28](#e28) R/R2 ↔ `certificates/elliptic_lifting` / WP-E1 | both concern an elliptic Picard/`Pic⁰` obstruction | WP-E1 sits inside Path G's lifting blockers; R/R2 is an Aug-1 goal run | **UNRESOLVED** (conflict 12) |
| [E13](#e13) F ↔ [E14](#e14) F-IMPORT ↔ [E15](#e15) Fable | all three are addressed by the single ledger token "F" | contents unrelated (fixed-frame genus-one torsor vs Problem-F involution import vs A4 trisection) | **KEPT SEPARATE**; ledger token ambiguous (conflict 4) |
| [E18](#e18) H6 route ↔ `H_6=V(f_6)` in xCD ([E35](#e35)) | symbol match | STAT: "no explicit cross-reference found"; H6 is a trace-cubic torsor decision, `H_6` is the Klein sextic | **KEPT SEPARATE** |
| [E03](#e03) A1-AUD ↔ [E55](#e55) REPAIR or [E01](#e01)'s A1 gate | `certificates/audit_a1` has no narrative owner; both `78abba4` (theorem-boundary audit) and `cdc016b` (Path A gate A1 PASS) are candidate parents | no lens characterizes the packet's contents | **UNRESOLVED** |

### Single-lens attempts flagged for a second look

[E03](#e03) (CERT only — orphan certificate directory), [E20](#e20) (WORK only — fully specified Elo path with no execution trace), [E23](#e23) (DIR only — carries a PASS no other lens records), [E52](#e52), [E53](#e53) (WORK only — proposed, unrun), [E54](#e54) (HAND only — the canonical negative target).

[E43](#e43), [E44](#e44), [E46](#e46), [E47](#e47), [E48](#e48), [E49](#e49), [E50](#e50) are single-lens (RES) only because `RESOLUTION.md`/`SPEC.md` are the sole carriers of the "Other audited boundaries" and "Conditional forks and stakes" sections. That is a document-structure artifact, **not** weak evidence.

