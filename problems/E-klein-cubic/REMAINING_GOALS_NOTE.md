# Remaining worker goals — state note

**Date:** 2026-08-02  
**Problem E headline:** **OPEN**

Rectified from live seals/STATUS (merge conflict resolved; B / G2 / Q2.1 / V3 / A0 brought current).

## Active queue (this worker)

Computational / process fronts only. Analytic/research-only fronts are **out of queue** (dispatched elsewhere).

| # | Front | State | Work |
|---:|---|---|---|
| 1 | **P25** | `P25-UNDECIDED` | 63 residual charts on \(D(H_8)\) (34 Stage-B + 29 Stage-C); pair-split `PREPARED_NOT_RUN`. Launch **BLOCKED** when competing heavy CAS is live (libproc RSS path OK; default fence 16 GiB). `LAUNCH_READINESS.md` |
| 2 | **COV m=1** | `COV-UNDECIDED` | Full \(m=1\) modules + landing equations exist; **148** residual affine charts still open. Modular `[1]` on d31 pure-third 0–1 @463 does **not** transfer by proper specialization alone |
| 3 | **C / C5** | `C5-UNDECIDED` | Generic/`K_proj` Morita interpreter → common line → Fano. Partial: multiprime holdout `C5-MORITA-MULTIPRIME-HOLDOUT-PASS` (holdout 353). p23 walker / record interpreter alone is **not** full incidence |
| 4 | **H5** | `H5-UNDECIDED` | Point search / certified emptiness on H4 trace cubic \(\Phi=0\). Wave2 Laurent/proj + fibration probe: large K-screens empty; no K-point |

**A0 closed:** `A0-CANONICAL-AUDIT-PASS` (projection bulk 4140/315 independently certified; full dense RREF killed as nonverdict).

**Heavy CAS rule:** at most one of P25 F4/`msolve` **or** COV m=1 heavy charts at a time.

### Parallel wave 2026-08-02 — **complete**

| Slot | Front | Outcome |
|---|---|---|
| W1 | H5 deep | `H5-UNDECIDED` — large K-screens empty; projection residual over \(E\); full verifier re-run (`H5_WAVE2_LAURENT_PROJ/`) |
| W2 | C5 multiprime | Partial: holdout 353 + multiprime ledger (`C5-MORITA-MULTIPRIME-HOLDOUT-PASS`); still undecided |
| W3 | COV m=1 | 148 residual charts catalogued; d31 pure-third modular `[1]` @463 on first two charts only; no char-0 transfer |
| W4 | P25 | BLOCKED + ALTERNATE; libproc; 16 GiB fence; residual 63 |
| W5 | H5 fibration | modular discovery only; soluble samples; no K-point |

**Headline still OPEN.** No degree-empty / BR-FANO / H5 binary.

### Pointers (active)

| Front | Path |
|---|---|
| A0 (closed) | `goal_runs_after_35fa/A0_CANONICAL_AUDIT/` |
| P25 | `goals_2026-08-01/P25_LANDING_SUPPORT/` |
| COV m=1 | `goal_runs_after_35fa/COV_M1_DEG31_35/` |
| C5 live | `goals_after_bd610a/C5_PROJECTOR_INCIDENCE/` |
| C5 multiprime | `goal_runs_after_bd610a/C5_MULTIPRIME_20260802/` |
| C cont. | `goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/` (authority also `…/C_PFAFFIAN_FANO_CODEX_ROOT/`) |
| H5 | `goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/` |
| H5 wave2 | `goal_runs_after_bd610a/H5_WAVE2_LAURENT_PROJ/` |
| H4 model | `goal_runs_after_35fa/H_11_5_TWIST/` (`H-11_5-NORM-MODEL-PASS`) |

---

## Off queue — analytic / research only

**Owner:** external / more capable agents. Do not schedule computational worker slots here.

| Front | State | Why off queue / residual gate |
|---|---|---|
| **M3** section | Multisection sealed `M3-INTEGRAL-DEGREE4-MULTISECTION`; **section undecided** | Residual Galois / saturated \(H\)-degree-4 section scheme over \(K\) |
| **Q** | `Q-UNDECIDED`; scoped `Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS` | Standard descent/obstruction package exhausted; Schur binary still open (A4/S4 frontier, nonstandard interfaces) |
| **G** arithmetic | Structural `G2-FINITE-GENERATION-PASS`; **point/pointlessness OPEN** | Decide \(V(\Phi)(K_{\mathrm{proj}})\neq\varnothing\) with dominance, or pointlessness + source bridge |
| **V** residue | `V-UNDECIDED`; scoped `V3-RESIDUE-NORMAL-FORM-PASS` (+ `V-F5-DEGREE16-SUPPORT-LE5-EMPTY`) | Mechanics sealed: only unramified rank-≤2 non-`C1` sites with decomp group \(G\) or `11:5`. Residue binaries at `f5`/`f6` or H5 remain |
| **T3** | Scratch / local-runner undecided | Cl/Pic[3] after T/T2 refutation; route already weak |
| **S19** cont. | `S19-UNDECIDED` | Curve/Rao (mostly geometric research); Hankel reformulation installed |

### Pointers (dispatched elsewhere)

| Front | Path |
|---|---|
| M3 | `goals_after_bd610a/M3_SARKISOV_SECTION/` |
| Q (live audit) | `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802/` |
| Q (parent frame) | `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/` |
| G / G2 structural | `goal_runs_after_35fa/G_UNIVERSAL/` (`DECISION.md` for residual arithmetic gate) |
| G earlier portfolio | `goals_2026-08-01/G_ALL_DEGREE/` |
| V3 close-out | `goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/` |
| V earlier | `goals_2026-08-01/V_VALUATION_TROPICAL_CODEX_ROOT_20260801/` |
| T3 scratch | `goals_after_bd610a/scratch_t3/` |
| T3 runner goals | `goals_2026-08-02/T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER/` |
| S19 continuation | `goal_runs_after_35fa/S19_MARKED_CURVE/CODEX_ROOT_20260801_7B4E_CONT2/` |

---

## Consolidated open fronts (deduplicated)

Ordered by closeness to a finite close-out, not by headline strength.

| # | Front | State | Class |
|---:|---|---|---|
| 1 | **P25** deg-25 support | Finite chart cover (63); CAS blocked / nonverdict | Finite CAS |
| 2 | **COV m=1** deg 31/35 | Equations ready; 148-chart residual cover open | Finite CAS + transfer |
| 3 | **C / C5** Fano–common line | Algebra partial (Morita multiprime holdout); no point | Research / exact CAS |
| 4 | **H5** 11:5 trace cubic | Exact H4 model; binary open | Research |
| 5 | **M3** del Pezzo section | Multisection yes; section undecided | Research |
| 6 | **Q** Schur binary | Descent/obstruction audit pass; binary open | Research |
| 7 | **G** universal-cubic arithmetic | G2 structural sealed; \(V(\Phi)\) gate open | Research |
| 8 | **V** residue binaries | Normal form sealed; `f5`/`f6` / `11:5` remain | Research |
| 9 | **S19** continuation | Reformulated; no curve | Research |
| 10 | **T3** target branch mod 3 | Scratch; route weak from T/T2 | Research |

---

## Already terminal (not on queue)

These have authorized terminal / structural exits (Problem E may still be open):

| Front | Exit | Note |
|---|---|---|
| **A0** | `A0-CANONICAL-AUDIT-PASS` | Process ledger closed |
| **B** | `B-BRIDGE-REFUTED` | Fixed-frame exhaustiveness theorem false; direct Fano arithmetic is C/C5. Packet: `goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/` |
| **G2** structural | `G2-FINITE-GENERATION-PASS` | Universal object + all-degree theorem + primitive/scalar reduction; residual arithmetic is **G** |
| **A5Q** | `A5Q-DEGREE4-RESCUE-EMPTY-SCOPED` | Degree-4 rescue emptied |
| **F** | fixed-frame conic criterion empty | — |
| **H2 / H3** | A4 and both A5 twists have rational points | Only 11:5 remains (H4/H5) |
| **H4** model | `H-11_5-NORM-MODEL-PASS` | Model sealed; decision is H5 |
| **T / T2** | target-branch negative route refuted / bridge blocked | — |
| **J / J2, D / D2, KLS / KLS2, V2** | route-level exits | — |
| **V3 mechanics** | `V3-RESIDUE-NORMAL-FORM-PASS` | Ramified, `C1`-residue, rank-≥3, and both maximal-`A5` valuation sites retired; residual point binaries remain **V** / **H5** |
| **R / R2, M / M2** | structural / link exits | Section is M3 |
| **M3 multisection** | `M3-INTEGRAL-DEGREE4-MULTISECTION` | Structural only; section still open |
| **S19 (0801 literal)** | `S19-NO-CURVE-SCOPED` | Literal scoped empty |
| **COV structured (0801)** | higher-order / named-ansatz empty | Full \(m=1\) is a separate goal |

---

## Practical next actions

1. **Active computational slots (parallel light/medium):** C/C5 Morita generic interpreter / common line; H5 residual binary (projection descent, exact charts, or residue anisotropy).
2. **Heavy CAS (single job):** P25 prepared pair-split **or** one COV m=1 chart family — not both. Do not launch P25 while COV heavy is live.
3. Treat CAS timeouts/OOM as nonverdicts; do not promote modular emptiness without transfer.
4. Do not treat structural `*-UNDECIDED` exits as headline-ready.
5. Analytic fronts (G arithmetic, Q residual, V residue, M3 section, S19, T3) stay off this worker’s queue unless explicitly reassigned.

---

## Artifact pointers (primary STATUS / seal)

| Front | Primary status path |
|---|---|
| A0 | `goal_runs_after_35fa/A0_CANONICAL_AUDIT/STATUS.md` |
| P25 | `goals_2026-08-01/P25_LANDING_SUPPORT/STATUS.md` (+ `LAUNCH_READINESS.md`) |
| COV m=1 | `goal_runs_after_35fa/COV_M1_DEG31_35/STATUS.md` |
| C | `goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/STATUS.md` |
| C5 | `goals_after_bd610a/C5_PROJECTOR_INCIDENCE/STATUS.md` |
| C5 multiprime | `goal_runs_after_bd610a/C5_MULTIPRIME_20260802/STATUS.md` |
| H4 | `goal_runs_after_35fa/H_11_5_TWIST/STATUS.md` |
| H5 | `goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/STATUS.md` |
| H5 wave2 | `goal_runs_after_bd610a/H5_WAVE2_LAURENT_PROJ/STATUS.md` |
| M3 | `goals_after_bd610a/M3_SARKISOV_SECTION/STATUS.md` |
| Q | `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802/STATUS.md` |
| B (terminal) | `goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/STATUS.md` |
| G2 structural | `goal_runs_after_35fa/G_UNIVERSAL/STATUS.md` |
| G arithmetic | `goal_runs_after_35fa/G_UNIVERSAL/DECISION.md` |
| S19 continuation | `goal_runs_after_35fa/S19_MARKED_CURVE/CODEX_ROOT_20260801_7B4E_CONT2/STATUS.md` |
| V3 | `goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/STATUS.md` |
| T3 | `goals_after_bd610a/scratch_t3/` |

---

Wave-A packaging and readiness notes (P25 launch fence, C5 p23 walker, M3 residual gate docs) are process only — not gate closes.
