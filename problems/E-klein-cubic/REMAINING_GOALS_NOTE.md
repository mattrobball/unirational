# Remaining worker goals — state note

**Date:** 2026-08-02  
**Scope:** open tasks under `goals_after_bd610a/`, `goals_after_35fa8f/`, and `goals_2026-08-01/`  
**Problem E headline:** still **OPEN** (no positive or negative headline in any portfolio)

This note lists only goals that still have work left. Goals that already reached an authorized terminal exit (route refutation, scoped empty, structural pass, subgroup point, etc.) are omitted.

---

## How to read status

| Label | Meaning |
|---|---|
| **Mechanical** | Audit / replay / seal / prepared CAS cover — no new theorem required to “close the packet” |
| **Finite CAS** | Named finite chart cover or prepared job; may still fail, timeout, or need transfer |
| **Research** | Needs a new point, bridge, emptiness theorem, or genuine mathematical decision |

---

## 1. `goals_after_bd610a`

| Goal | Exit / state | Class | Remaining work |
|---|---|---|---|
| **C5** projector incidence | `C5-UNDECIDED` | Research | Solve corrected full Fano / self-adjoint projector incidence over \(K_{\mathrm{proj}}\) (or prove emptiness). Executable incidence is installed; no \(K_{\mathrm{proj}}\)-point. |
| **H5** 11:5 trace cubic | *no sealed run* | Research | Binary decision on the genuine cyclic trace cubic \(\Phi=\mathrm{Tr}(r_2^{-1}a^2\sigma(a))=0\). Model work lives under H4. |
| **T3** target-branch mod 3 | `T3-UNDECIDED` (scratch only) | Research | Normalize genuine target branch; decide horizontal \((\mathrm{Cl}/\mathrm{Pic})[3]\). |
| **M3** Sarkisov section | `M3-INTEGRAL-DEGREE4-MULTISECTION`; `section_question: UNDECIDED` | Research | Multisection existence is sealed. Still need rational section vs full no-section analysis of the degree-3 del Pezzo fibration. |
| **P25/COV** finite support | `PC-UNDECIDED` | Finite CAS + research | Transition-stable structure advanced; full deg-25/31/35 landing support still open. See also P25 / COV m=1 below. |

**Completed in this portfolio (for reference):** A5Q (`A5Q-DEGREE4-RESCUE-EMPTY-SCOPED`).

---

## 2. `goals_after_35fa8f`

| Goal | Exit / state | Class | Remaining work |
|---|---|---|---|
| **A0** canonical audit | No `CANONICAL_STATE`; only `IMPLEMENTATION_AUDIT.md` | **Mechanical** | Inventory, clean replay of load-bearing claims (especially P25 quartic nonmembership), merge C/COV authority, write `CANONICAL_STATE.md` / `.json`, seal. Exit target: `A0-CANONICAL-AUDIT-PASS`. |
| **P25** enlarged closure & support | `P25-UNDECIDED` (live under `goals_2026-08-01/P25_LANDING_SUPPORT/`) | **Finite CAS** (resource-blocked) | Finite certified cover of Stage B/C charts on \(D(H_8)\). Pair-split job sealed as `PREPARED_NOT_RUN`; prior F4 OOM / nonverdict. No char-0 covariant and no full special-fibre unit ideal yet. |
| **C** Morita + common line | `C-UNDECIDED` | Research | C0–C2 partial; still need simultaneous common isotropic line, original Fano equations, headline bridge (C3–C4). |
| **COV m=1** equalizers deg 31/35 | `COV-UNDECIDED` | Finite CAS + transfer gap | Full \(m=1\) modules and landing equations exist. Projective saturations undecided. Large residual affine chart cover; modular `[1]` on some charts does **not** transfer by proper specialization alone. |
| **S19** marked-curve continuation | `S19-UNDECIDED` | Research | Qualifying deg-19 curve / exclude both Rao branches / residual degree-2 cycle. Hankel reformulation installed; still nondecisional. |
| **Q** Schur index-one decision | `Q-UNDECIDED` | Research | Binary: \(X_{\mathrm{Schur}}(K_{\mathrm{Schur}})\) nonempty vs empty. Many scoped exclusions; neither binary proved. |
| **H4** 11:5 generic twist | `H-11_5-NORM-MODEL-PASS` | Research | Model sealed. Remaining theorem: existence of \(0\neq a\in E\) with \(\mathrm{Tr}_{E/K}(r_2^{-1}a^2\sigma(a))=0\). Feeds H5. |

**Completed in this portfolio (for reference):** B (`B-BRIDGE-REFUTED`), G2 (`G2-FINITE-GENERATION-PASS`), H2, H3, T2, KLS2, J2, V2, D2, R2, M2.  
For B, the functorial fixed-frame exhaustiveness theorem is refuted; the direct arithmetic decision for `F14_T(K_proj)` remains C/C5.  
For G2, the intrinsic generic twist and exact all-degree equivalence are sealed; only the arithmetic point/pointlessness gate on `V(Phi)` remains under G.

---

## 3. `goals_2026-08-01`

| Goal | Exit / state | Class | Remaining work |
|---|---|---|---|
| **C** Pfaffian Fano point | `C-UNDECIDED` | Research | Same frontier as 35fa C / bd610a C5: common line + original equations. |
| **P25** landing support | `P25-UNDECIDED` | **Finite CAS** (resource-blocked) | Same as 35fa P25: 34 Stage-B + 29 Stage-C opens on \(D(H_8)\); prepared pair-split not launched. |
| **G** universal-cubic arithmetic | `G2-FINITE-GENERATION-PASS`; arithmetic gate **OPEN** | Research | Universal object, primitive/scalar reduction, and all-degree theorem are complete. Decide \(V(\Phi)(K_{\mathrm{proj}})\neq\varnothing\) with dominance, or prove pointlessness and replay the accepted source-exhaustiveness bridge. |
| **H** subgroup twists | `H-SWEEP-UNDECIDED` | Research (mostly retired) | Later H2/H3 closed A4 and both A5 classes with points. **Only 11:5 remains** (see H4/H5). |
| **Q** Schur index-one descent | `Q-UNDECIDED` | Research | Same binary as 35fa Q; live multi-packet research status. |
| **V** valuation / tropical | `V-UNDECIDED`; `V3-RESIDUE-NORMAL-FORM-PASS` | Research | Valuation mechanics are sealed: every possible nonpoint is unramified, non-`C1`, rank at most two, index one, with decomposition group `G` or `11:5`. Decide the full residue twist at `f5=0` or `f6=0`, or the `11:5` trace cubic. |

**Completed in this portfolio (for reference):** F, T, S19 (literal scoped empty), KLS, COV structured search, M, J, R, D; the G/G2 structural mission is complete at `G2-FINITE-GENERATION-PASS`.

---

## 4. Consolidated open fronts (deduplicated)

Ordered by how close they are to a finite close-out, not by headline strength.

| # | Front | Portfolios | State | Class |
|---:|---|---|---|---|
| 1 | **A0** canonical ledger | 35fa | Not sealed | Mechanical |
| 2 | **P25** deg-25 support | 0801 / 35fa / bd610a | Finite chart cover; CAS blocked / nonverdict | Finite CAS |
| 3 | **COV m=1** deg 31/35 | 35fa (+ bd610a P25/COV) | Equations ready; saturations / chart cover open | Finite CAS + transfer |
| 4 | **C / C5** Fano–common line | 0801 / 35fa / bd610a | Algebra partial; no point | Research |
| 5 | **H4 / H5** 11:5 trace cubic | 35fa / bd610a | Exact model; binary open | Research |
| 6 | **M3** del Pezzo section | bd610a | Multisection yes; section undecided | Research |
| 7 | **Q** Schur binary | 0801 / 35fa | Frame installed; binary open | Research |
| 8 | **T3** target branch mod 3 | bd610a | Scratch; route already weak from T/T2 | Research |
| 9 | **G** universal-cubic arithmetic | 0801 / 35fa | G2 structural pass sealed; point/pointlessness open | Research |
| 10 | **S19** continuation | 35fa | Reformulated; no curve | Research |
| 11 | **V** valuation | 0801 / bd610a | Normal form sealed; only unramified rank-at-most-two residue binaries for `G` or `11:5` remain | Research |

---

## 5. What is *not* still open as a worker mission

These already have authorized terminal exits (Problem E may still be open):

- **A5Q** — degree-4 rescue emptied  
- **B** — fixed-frame exhaustiveness refuted (`B-BRIDGE-REFUTED`); direct Fano arithmetic is C/C5  
- **F** — fixed-frame conic criterion empty  
- **G2** — intrinsic universal object, exact all-degree theorem, and primitive/scalar reduction complete (`G2-FINITE-GENERATION-PASS`); the residual arithmetic binary is G  
- **H2 / H3** — A4 and both A5 twists have rational points  
- **T / T2** — target-branch negative route refuted / bridge blocked  
- **J / J2, D / D2, KLS / KLS2, V2** — route-level exits  
- **V3 mechanics** — ramified, `C1`-residue, rank-at-least-three, and both maximal-`A5` valuation sites are retired (`V3-RESIDUE-NORMAL-FORM-PASS`); the residual point binaries remain V  
- **R / R2, M / M2** — structural / link exits (section is M3)  
- **S19 (0801 literal)** — goal-qualified locus empty (`S19-NO-CURVE-SCOPED`)  
- **COV structured (0801)** — selected higher-order ansätze empty; full \(m=1\) is a separate goal  

---

## 6. Parallel dispatch plan (subagents)

Run independent fronts concurrently. **Hard rule:** at most one unrelated job expected to exceed about 8 GiB RSS at a time. Do not co-schedule heavy P25 F4/`msolve` with heavy COV m=1 chart CAS.

### Wave A — always parallel (light / medium)

| Slot | Front | Agent task | Output dir | Conflict |
|---|---|---|---|---|
| A1 | **A0** | Inventory + replay + `CANONICAL_STATE.md/.json` + seal | `goal_runs_after_35fa/A0_CANONICAL_AUDIT/` | None |
| A2 | **H5** (from H4 model) | Point search / first exact charts on \(Phi=0\); or setup sealed H5 workspace | `goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/` | None |
| A3 | **C / C5** | Next exact chart toward common line / projector; no full expanded \(L_a\) | `goal_runs_after_bd610a/C5_*` or C worktree | None |
| A4 | **Q** | Scoped successor only (document smallest gate; optional light search) | existing `Q_SCHUR_*` dirs | None |
| A5 | **M3** | Section vs multisection residual analysis (theorem/CAS light) | `goals_after_bd610a/M3_SARKISOV_SECTION/` | None |

### Wave B — heavy CAS (serialize; pick one)

| Slot | Front | Agent task | Notes |
|---|---|---|---|
| B1 | **P25** | Launch prepared `parallel/r66_pair_split/` when unsandboxed RSS census allows | `PREPARED_NOT_RUN`; prior OOM nonverdict |
| B2 | **COV m=1** | Residual chart cover (prefer charts already reduced) | Modular `[1]` is not characteristic-zero emptiness without transfer |

### Wave C — deferred research (parallel among themselves, not with Wave B)

| Front | Note |
|---|---|
| **G arithmetic** | Decide the single `V(Phi)(K_proj)` point/pointlessness gate; no degree ladder substitute |
| **S19** continuation | Hankel / Rao branch decision |
| **V** | Full residue binary at `f5`/`f6` or `11:5`; no separate valuation-mechanics shortcut remains |
| **T3** | Only if still wanted after T/T2 route refutation |

### Orchestrator checklist

1. Spawn Wave A slots **in parallel**.  
2. Assign **at most one** Wave B heavy job.  
3. Do not edit sealed historical packets; new artifacts only in route-specific directories.  
4. Each subagent returns: exit string, `STATUS.md` delta, seal/replay command, resource peak if CAS.  
5. After Wave A joins, refresh this note’s states from returned exits.

---

## 7. Practical next actions

1. **Wave A in parallel:** A0, H5 setup, C/C5 next gate, M3 residual, Q gate note.  
2. **Wave B (single heavy):** P25 prepared pair-split **or** one COV m=1 chart family — not both.  
3. Treat CAS timeouts/OOM as nonverdicts; do not promote modular emptiness without transfer.  
4. Do not treat structural `*-UNDECIDED` exits as headline-ready.

---

## Artifact pointers

| Front | Primary status path |
|---|---|
| A0 | `goals_after_35fa8f/IMPLEMENTATION_AUDIT.md` (goal: `GOAL_A0_…`) |
| P25 | `goals_2026-08-01/P25_LANDING_SUPPORT/STATUS.md` |
| COV m=1 | `goal_runs_after_35fa/COV_M1_DEG31_35/STATUS.md` |
| C | `goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/STATUS.md` |
| C5 | `goals_after_bd610a/C5_PROJECTOR_INCIDENCE/STATUS.md` |
| H4 | `goal_runs_after_35fa/H_11_5_TWIST/STATUS.md` |
| H5 | `goals_after_bd610a/GOAL_H5_11_5_TRACE_CUBIC_DECISION.md` (no run yet) |
| M3 | `goals_after_bd610a/M3_SARKISOV_SECTION/STATUS.md` |
| Q | `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/STATUS.md` |
| B (completed) | `goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/STATUS.md` |
| G2 (completed structural theorem) | `goal_runs_after_35fa/G_UNIVERSAL/STATUS.md` |
| G arithmetic | `goal_runs_after_35fa/G_UNIVERSAL/DECISION.md` |
| S19 continuation | `goal_runs_after_35fa/S19_MARKED_CURVE/CODEX_ROOT_20260801_7B4E_CONT2/STATUS.md` |
| V | `goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/STATUS.md` |
| T3 | `goals_after_bd610a/scratch_t3/` |
