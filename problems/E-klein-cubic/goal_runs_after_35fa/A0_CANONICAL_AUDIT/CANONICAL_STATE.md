# Canonical state ledger — Goal A0

**Audit packet:** `goal_runs_after_35fa/A0_CANONICAL_AUDIT/`  
**Audit date (UTC):** 2026-08-02T10:13:21Z  
**Live HEAD at audit:** `8e7f074cb9a9ccc15cd7239970635af588bf5c95`  
**Pinned August publish commit:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem E headline:** **OPEN**

This ledger is the A0 authoritative one-line status map for the fifteen
`goals_2026-08-01` routes and the post-`35fa8f` packets that carry seals.
Historical sealed packets are not rewritten; canonical markers and this ledger
record consumption rules.

---

## 1. Fifteen original routes (`goals_2026-08-01`)

| Route | One-line canonical status | Canonical packet | Exit / marker |
|---|---|---|---|
| **C** | Partial exact interface sealed; Fano/common-line open | `C_PFAFFIAN_FANO_CODEX_ROOT/` (+ `CANONICAL.md`) | `C-UNDECIDED` / `C-PARTIAL-EXACT-INTERFACE-VERIFIED` |
| **COV** | Higher-order branches + named ansätze empty; `m=1` open | `COV_STRUCTURED_SEARCH/` (+ `CANONICAL.md`) | `COV-NEW-ANSATZ-STRUCTURAL` (not degree-wide empty) |
| **D** | Route completed as authorized negative | `D_EQUIVARIANT_MOTIVE/` | `D-INVARIANT-REPRODUCIBLE` |
| **F** | Fixed-frame conic criterion empty; no genuine-twist headline | `F_CONIC_ALGEBRA/` | `F-CONIC-CRITERION-EMPTY` |
| **G** | Structural advances only; all-degree decision open | `G_ALL_DEGREE/` | `G-STRUCTURAL-UNDECIDED` |
| **H** | Subgroup sweep undecided at dispatch; later H2/H3 close A4/A5 | `H_SUBGROUP_TWISTS_ROOT_019FBE10/` | `H-SWEEP-UNDECIDED` (0801); see post-35fa H2/H3 |
| **J** | Fixed-centre invariant too weak for route | `J_FIXED_CENTRE_PRYM/` | `J-INVARIANT-TOO-WEAK` |
| **KLS** | No minimality-to-discrepancy theorem | `KLS_MINIMALITY/` | `KLS-NO-THEOREM` |
| **M** | New Mori fibre structural; section open (see M2/M3) | `M_SARKISOV/` | `M-NEW-MORI-FIBRE-STRUCTURAL` |
| **P25** | Presentation enlarged over `F_89`; support undecided | `certificates/degree25_p25v/` + `P25_LANDING_SUPPORT/` | `P25V-PRESENTATION-ENLARGED` + `P25-UNDECIDED` / `P25V-SUPPORT-UNDECIDED` |
| **Q** | Schur index-one binary open | `Q_SCHUR_DESCENT/` (+ later stage packets) | `Q-UNDECIDED` |
| **R** | Hilbert-component structural only | `R_RATIONAL_CURVES_CODEX/` | `R-HILBERT-COMPONENT-STRUCTURAL` |
| **S19** | Goal-qualified deg-19 locus empty (scoped) | `S19_SCHUR_CURVE/` | `S19-NO-CURVE-SCOPED` |
| **T** | Target-branch negative route refuted | `T_TARGET_BRANCH_INDEX3_ROOT_019FBE13/` | `T-ROUTE-REFUTED` |
| **V** | No decisive pointless genuine completion | `V_VALUATION_TROPICAL/` | `V-UNDECIDED` |

### Duplicate / authority notes (0801)

| Issue | Resolution |
|---|---|
| **C** three directories | Canonical = `C_PFAFFIAN_FANO_CODEX_ROOT/` (sealed). `C_PFAFFIAN_FANO/` historical; `..._A7C3/` continuation without joining seal — research only. |
| **COV** two exits | Canonical exit `COV-NEW-ANSATZ-STRUCTURAL`. Root label `COV-STRUCTURED-DEGREES-EMPTY-SCOPED` repaired to **higher-order-branch** emptiness only (`COV-HIGHER-ORDER-BRANCHES-EMPTY-SCOPED`). |
| **P25** verifier gap | Structural 126 cubic nonmembership independently replayed. Bulk 4140/315: independent full FLINT recompute launched under audit (see `REPLAY.md`); input binaries and prior `deg0_result.json` hash-locked. |

---

## 2. Post-`35fa8f` sealed packets (`goal_runs_after_35fa/`)

| Packet | Exit | Class |
|---|---|---|
| **B** fixed-frame bridge | `B-UNDECIDED` | Research (bridge missing) |
| **COV m=1** deg 31/35 | `COV-UNDECIDED` | Finite CAS + transfer |
| **D2** stack invariant | `D2-NO-VALID-BRIDGE` | Route closed negatively |
| **H2** A4 generic twist | `H-A4-RATIONAL-POINT` | Point found; A4 obstruction retired |
| **H3** A5 twists | `H-A5-CLASS1-RATIONAL-POINT` + `H-A5-CLASS2-RATIONAL-POINT` | Both A5 classes have points |
| **H4** 11:5 norm model | `H-11_5-NORM-MODEL-PASS` | Model sealed; trace cubic open |
| **J2** baselocus Prym | `J2-UNRESTRICTED-COUNTERMODEL-EXTENDS` | Route weakened |
| **KLS2** minimality | `KLS2-NO-FINITE-REDUCTION` | Route-level exit |
| **M2** equivariant Sarkisov | `M2-EXPLICIT-LINK-PASS` | Link structural; section is M3 |
| **Q** Schur index-one | `Q-UNDECIDED` | Binary open |
| **R2** rational curves | `R2-DESCENT-OBSTRUCTED` | Descent obstructed |
| **S19** marked continuation | `S19-UNDECIDED` | Continuation open |
| **T2** target branch | `T2-ROUTE-REFUTED` | Confirms T negative |
| **V2** genuine valuation | `V2-FIXED-FRAME-PLACE-NONTRANSFERABLE` | Fixed-frame place does not transfer |

---

## 3. Load-bearing theorem consumption rules

1. **F:** consume only as fixed-frame plane-cubic pointlessness + empty conic criterion. **No** automatic transfer to the genuine generic Klein twist (bridge = Goal B).
2. **D / D2:** do not rerun unrestricted equivariant motive; route refuted / bridge invalid.
3. **H:** D10/D12 soluble; A4 and both A5 classes have points (H2/H3). Remaining subgroup gate is **11:5** (H4 model; H5 binary).
4. **COV:** higher-order + named-ansatz emptiness only; **not** deg-25/31/35 wide empty; full `m=1` is COV m=1 goal.
5. **P25:** may use `P25V-PRESENTATION-ENLARGED` after bulk 4140/315 independent confirmation (this audit). Support emptiness **not** proved. Enlarge presentation before claiming T-stable module.
6. **C:** use sealed lazy algebra + involution + five-plane only from canonical CODEX_ROOT. Ambient projector is auxiliary. No Morita/common-line theorem yet.
7. **T/T2, J/J2, KLS/KLS2, R/R2, S19 (0801 scoped), M/M2:** consume at stated scoped exits; none is a Problem E headline.

---

## 4. Dependency graph for the next round

```text
                    Problem E (OPEN)
                          |
        +-----------------+------------------+
        |                 |                  |
   positive point    degree-scoped      negative obstruction
        |              emptiness              |
   C / Q / R2/H5     P25 / COV m=1 / G     T× V× D× J× KLS×
        |                 |                  |
        +---- B bridge ← F fixed-frame empty
        |
   H4/H5 11:5 residual subgroup
   M3 section (after M2 multisection)
```

**Highest-leverage mechanical/CAS next:**

1. Finish P25 Stage-B/C affine cover on `D(H8)` (resource-blocked prepared jobs).
2. COV m=1 saturations / chart cover with proper specialization discipline.
3. C common isotropic line + original Fano equations (research).
4. H5 trace-cubic binary on the H4 model.
5. B bridge: fixed-frame emptiness → genuine twist (or exhaustiveness theorem).

---

## 5. Replay summary (this audit)

| Check | Result |
|---|---|
| P25 structural 126 / rank V0=690 | **PASS** (`verify_p25v0.py`) |
| P25v1 compressions / no false emptiness | **PASS** |
| P25 SHA256SUMS | **PASS** |
| P25 bulk 4140/315 independent recompute | **IN PROGRESS** full FLINT (`replay_p25_flint_full.log`); see STATUS for final |
| C `verify_all.py` | **PASS** → `C-PARTIAL-EXACT-INTERFACE-VERIFIED` |
| COV ROOT `verify_all.py` | **PASS** → `COV_STRUCTURED_SEARCH_ALL_VERIFIED` |
| COV structured ansatz modules | **PASS** modules/cross; combined may still be running at seal time |
| F `verify.py` | **PASS** → criterion empty accept |
| D `verify.py` | **PASS** |
| H `verify.py` | **PASS** |

---

## 6. Exit

See first line of `STATUS.md` in this directory.
