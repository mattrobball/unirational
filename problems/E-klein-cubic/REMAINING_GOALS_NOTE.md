# Remaining worker goals — state note

**Date:** 2026-08-02  
**Problem E headline:** **OPEN**  
**Dispatch authority:** `goals_after_141f60/README.md` (+ refinements in `goals_after_0aecc89/`)  
**R0 packet:** `goal_runs_after_141f60/R0_CANONICAL_REFRESH/` (`R0-CANONICAL-REFRESH-PASS`)

Live orientation after G2 / V3 / B / Q2.1. Structural seals are **not** open missions. Superseded routes stay listed only as residual work or inputs.

## Active dispatch (post-141f60 ranking)

| Priority | Goal | State | Decisive target |
|---:|---|---|---|
| 0 | **R0** | `R0-CANONICAL-REFRESH-PASS` | this ledger refresh (done) |
| 1 | **G3** | arithmetic **OPEN** | decide \(V(\Phi)(K_{\mathrm{proj}})\) (primary headline target) |
| 2 | **C6** | not started | \(K_{\mathrm{proj}}\)-point of corrected Fano via determinantal / common-line big cell |
| 3 | **G4** | not started | transfer exact A5 degree-11 points to a \(K_{\mathrm{proj}}\)-point |
| 4 | **H6** | not started | decide genuine `11:5` trace cubic via degree-11 torus isogeny |
| 5 | **G5** | not started | pointlessness of full `f5` or `f6` residue twist |
| 6 | **Q3** | not started | descend stable cubic from primitive quartic resolvent |

**Refinements (may run under 0aecc89):** G3A arithmetic/dominance → G3P polar; G7 double-A5 biplane (after G4 design inputs).

**Headline still OPEN.** No BR-FANO / all-degree empty / residue-pointless seal.

### Heavy CAS rule

At most one unrelated job expected to exceed ~8 GiB RSS. Do **not** co-schedule heavy P25 F4/`msolve` with heavy COV m=1 charts. T3 local runners keep their own serialized heavy slot.

---

## Available but demoted (not primary routes)

Finite/witness work only. Not all-degree proxies after `G2-FINITE-GENERATION-PASS`.

| Front | State | Residual | Path |
|---|---|---|---|
| **P25** | `P25-UNDECIDED` | 63 charts on \(D(H_8)\); pair-split `PREPARED_NOT_RUN` / launch blocked when heavy CAS competes | `goals_2026-08-01/P25_LANDING_SUPPORT/` |
| **COV m=1** | `COV-UNDECIDED` | 148 residual charts; modular `[1]` ≠ char-0 transfer | `goal_runs_after_35fa/COV_M1_DEG31_35/` |
| **C5** (input to C6) | `C5-UNDECIDED` | Corrected **alternating-form / Plücker / square-zero** common-line model; Morita multiprime holdout partial. **Not** the inconsistent idempotent encoding (`e*S_0*e=0`, retired) | `goals_after_bd610a/C5_PROJECTOR_INCIDENCE/` |
| **H5** (input to H6) | `H5-UNDECIDED` | Sealed run + wave2/fibration probes; no K-point; binary open | `goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/` |
| **T3** (auxiliary) | `T3-UNDECIDED` | Local-runner portfolio only; fixed-frame; **not** headline after `B-BRIDGE-REFUTED` | `goals_after_5899d0/T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER/` (+ `goals_2026-08-02/…`) |
| **M3 section** | multisection sealed; section undecided | residual G1 modular nonempty (`M3B-G1-MODULAR-NONEMPTY-PASS`); K-section open | `goals_after_bd610a/M3_SARKISOV_SECTION/` + `goal_runs_after_bd610a/M3B_SECTION_RESIDUAL_G1_20260802/` |

---

## Off primary dispatch — residual binaries

| Front | State | Remaining binary |
|---|---|---|
| **G** arithmetic | G2 structural sealed | \(V(\Phi)(K_{\mathrm{proj}})\) — **same as G3** |
| **V** residue | `V-UNDECIDED`; scoped `V3-RESIDUE-NORMAL-FORM-PASS` | full `f5`/`f6` or `11:5` — **G5 / H6** |
| **Q** | `Q-UNDECIDED`; scoped `Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS` | Schur point binary — **Q3** preferred |
| **S19** cont. | `S19-UNDECIDED` | curve / Rao (research) |

---

## Already terminal (not open missions)

| Front | Exit | Note |
|---|---|---|
| **A0** | `A0-CANONICAL-AUDIT-PASS` | projection bulk 4140/315 certified |
| **B** | `B-BRIDGE-REFUTED` | fixed-frame exhaustiveness false; **not** on active dispatch |
| **G2** structural | `G2-FINITE-GENERATION-PASS` | universal object + all-degree theorem; residual is **G3** |
| **V3** mechanics | `V3-RESIDUE-NORMAL-FORM-PASS` | mechanics closed; residual residue binaries only |
| **H4** model | `H-11_5-NORM-MODEL-PASS` | decision is H5/H6 |
| **M3** multisection | `M3-INTEGRAL-DEGREE4-MULTISECTION` | section still open |
| **H2 / H3** | points on A4 and both A5 twists | — |
| **A5Q, F, T/T2, J/J2, D/D2, KLS/KLS2, V2, R/R2, M/M2** | prior terminals | — |
| **S19 literal (0801)** | scoped empty | continuation separate |
| **COV structured (0801)** | named-ansatz empty | full m=1 separate |

---

## Supersession map (short)

| Demoted / closed route | Prefer |
|---|---|
| Degree ladder / G2 re-proof | **G3** on \(V(\Phi)\) |
| V mechanics re-proof | **G5** / **H6** residue binaries |
| B exhaustiveness headline | **C6** / C5 corrected Fano |
| C5 idempotent `e*S_0*e=0` | Plücker / alternating-form model → **C6** |
| H5-only endgame | **H6** isogeny method |
| Q standard obstruction package | **Q3** after Q2.1 |
| T3 scratch as primary | T3 **local runners** (non-headline) |
| P25/COV as all-degree proxy | finite witness only; **G3** for all-degree |

---

## Practical next actions

1. **Primary:** G3 arithmetic on \(V(\Phi)\) (optionally G3A engine first).  
2. **Parallel light/medium:** C6 from corrected C5 model; G4; H6; Q3; G5 if not duplicating H6.  
3. **Demoted heavy (serialize):** one of P25 pair-split **or** COV chart family **or** T3 CAS — not with each other.  
4. Do not schedule **B**, **G2 structural**, or **V3 mechanics** as open missions.  
5. Modular emptiness without transfer is a nonverdict.

---

## Artifact pointers

| Front | Primary path |
|---|---|
| R0 | `goal_runs_after_141f60/R0_CANONICAL_REFRESH/` |
| G3 goal | `goals_after_141f60/GOAL_G3_UNIVERSAL_CUBIC_ARITHMETIC.md` |
| G2 / decision | `goal_runs_after_35fa/G_UNIVERSAL/` |
| C6 goal | `goals_after_141f60/GOAL_C6_PALATINI_BIG_CELL.md` |
| C5 corrected | `goals_after_bd610a/C5_PROJECTOR_INCIDENCE/` |
| G4 / H6 / G5 / Q3 | `goals_after_141f60/GOAL_*.md` |
| H5 sealed | `goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/` |
| V3 | `goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/` |
| B terminal | `goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/` |
| A0 | `goal_runs_after_35fa/A0_CANONICAL_AUDIT/` |
| P25 | `goals_2026-08-01/P25_LANDING_SUPPORT/` |
| COV m=1 | `goal_runs_after_35fa/COV_M1_DEG31_35/` |
| T3 local runners | `goals_after_5899d0/T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER/` |
| M3 | `goals_after_bd610a/M3_SARKISOV_SECTION/` |
| Q2.1 | `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802/` |
