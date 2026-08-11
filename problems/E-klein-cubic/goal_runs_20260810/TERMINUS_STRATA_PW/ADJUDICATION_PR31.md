# ADJUDICATION — PR #31 (`agent/terminus-strata-pw-20260810`)

**Date** 2026-08-11. **Adjudicator** director-side agent, worktree
`agent-a91690e4a856bb38b`. **Subject** `goal_runs_20260810/TERMINUS_STRATA_PW`,
the stabilized-strata census of the source terminus `Z` (+34 459 lines,
1 commit `e7778c22`).

**VERDICT: READY (merge-ready).** Every load-bearing count is confirmed, most
of them by a *fully independent* recount written for this adjudication. Six
defects were found; all six are documentation or registration level and all six
are fixed on this branch. No mathematical claim was withdrawn or weakened.

---

## 1. What was replayed

| replay | result |
|---|---|
| `python3 verifier.py` | 18 `CHECK … PASS`, 0 `FAIL`, `TERMINUS_STRATA_PW_VERIFY_OK` / `ALLGREEN` in 2 m 19 s; output **byte-identical** to the committed `results/verifier_run.txt` |
| `M2 --script scripts/t6_charts.m2` | `18/18 checks passed`, `T6_CHARTS_OK` |
| `scripts/t2_orbit_strata.py`, `t3_localmodels.py`, `t4_poset.py`, `t5_zplus.py` | all four markers emitted, no internal `FAIL` (via the verifier) |
| `scripts/psl211.py`, `scripts/sfcore.py` vs the merged `STANDARD_FORM_PW` copies | **byte-identical** (`diff` clean) |
| `scripts/check_manifest_parity.py` | see §5 |

## 2. The independent recount

The packet's own verifier re-checks each row against the raw 660-element group
action, but it takes the *row list* from `tcore.census` — the same engine that
produced the tables. So the headline "80 orbits / 11 076 components" was, as
committed, asserted by one engine and replayed at two primes with that same
engine. To close that gap this adjudication wrote an independent census,
committed here as **`scripts/adj_indep_census.py`** (+ `adj_indep_extra.py`,
output `results/adj_indep_census.txt`). It shares with the packet **only** the
sealed group model `psl211.Model` and its linear algebra; everything else is
written from scratch and differs by design:

* the arrangement `A` is rebuilt from the **eigenspaces of the 659 non-identity
  elements** plus intersection closure (the packet builds it from *subgroup*
  character subspaces);
* **all 4900 chains are enumerated, not `G`-orbit representatives**, and
  components are counted **one at a time** — the class of de-duplication bug
  that this packet reports in `STANDARD_FORM_PW`'s `s5_terminus.py` cannot
  survive this;
* eigen-pieces are computed by successive splitting of *lifted* subspaces of
  `W` (the packet uses quotient representations and a character table);
* each orbit is separately checked to be closed under `G` and to have size
  exactly `660/|Stab_G(F)|`.

**Result, at both split primes 331 and 661, identical:**

| stage | packet | independent recount |
|---|---|---|
| arrangement | 940 + 220 + 55 = 1215 in 14 orbits, intersection-closed | **same** |
| chains | (implicit) | 1215 / 2860 / 825 of length 1 / 2 / 3, none longer |
| 0 `P(W)` | 15 orbits, 1216 components | **same**, and every per-class/per-dim cell |
| 1 (after T0) | 57, 7336 | **same**, all cells |
| 2 (after T1) | 70, 9591 | **same**, all cells |
| 3 `Z` (after T2) | **80, 11 076** | **same**, all cells |
| setwise index | `C2 1 · C3 8 · V4 26 · C5 10 · C6 27 · C11 4 · D12 3 · G 1` | **same** |
| `Z^H`, one fixed `H` | 239 / 80 / 54 / 20 / 38 / 20 | **same**, with the same dimension breakdowns |
| `STANDARD_FORM_PW` §5(d) correction | `C2 {1:1320,2:605,3:110}`, `C3` unchanged, `V4 {0:1155,1:330}`, `C5 1320`, `C6 1100`, `C11 240` | **same** |

Orbit-closure / orbit-size anomalies: **0**, at every stage, at both primes.

## 3. Per-claim verdicts

| # | claim | verdict |
|---|---|---|
| 1 | `A` = 940 lines + 220 planes + 55 3-spaces, 14 orbits, closed under intersection | **CONFIRMED INDEPENDENTLY** |
| 2 | `Z` is the maximal De Concini–Procesi wonderful model of `A`; Theorems 1–3 (chart form, tangent weights, census criterion) | **ACCEPTED, TIER AS DECLARED.** `A` intersection-closed is machine-checked, so `A` is its own maximal building set and the increasing-dimension tower is the DCP model; the chart description is cited, and tested exactly over `QQ(ζ_6)` for one representative of each of the four genres (18/18, transport forced by equivariance). Not verified for all 80 rows — the packet says so in §9 Tier 3 item 1. The independent census below is *conditional on these theorems*, as any census must be. |
| 3 | **80 stratum orbits, 11 076 components**; stages 15/1216 → 57/7336 → 70/9591 → 80/11 076 | **CONFIRMED INDEPENDENTLY**, both primes |
| 4 | per-class totals `C2` 15/2145, `C3` 13/2310, `V4` 18/2970, `C5` 10/1320, `C6` 19/2090, `C11` 4/240, free 1/1, with dimension breakdowns | **CONFIRMED INDEPENDENTLY**, every cell, all four stages |
| 5 | point stabilizers on `Z` are exactly `{1,C2,C3,V4,C5,C6,C11}`; the other **9 of 16** classes are empty | **CONFIRMED INDEPENDENTLY.** The independent enumeration admits nonabelian exact stabilizers (it ranges over *all* subgroups of each chain stabilizer and uses linear-character eigen-pieces) and finds none. Plus the packet's 79 per-row explicitly sampled points with brute-force stabilizers at two primes. |
| 6 | setwise stabilizers: **8 of 16** occur, with orbit counts `C2 1, C3 8, V4 26, C5 10, C6 27, C11 4, D12 3, G 1` | **CONFIRMED INDEPENDENTLY** |
| 7 | `A4` and `D10` occur at level 0 but not on `Z` | **CONFIRMED** — with a timing correction, see D2 |
| 8 | crossings: `|I| ≤ 3`; 1215 divisors; 19 orbits at `|I|=2`; **5 orbits of 165 = 825** at `|I|=3`, all on `ℓ_V`-`P_σ` flags | **CONFIRMED INDEPENDENTLY** for the counts: the independent chain enumeration gives exactly 1215 / 2860 / 825 chains of length 1 / 2 / 3 and none longer, and the packet's per-orbit crossing sizes sum to exactly 2860 and 825. Generic crossing stabilizers (`1`/`C2` at `|I|=2`, `C2` at `|I|=3`) are packet-computed, and are consistent with the independent finding that **no census row has a length-3 chain** — the triple crossings are non-generic loci inside larger `C2`-strata, which is exactly what "generic stabilizer `C2`" requires. |
| 9 | dictionary `Z^H = ⊔_{K ⊇ H} Z_{=K}`; 239 / 80 / 54 / 20 / 38 / 20 | **CONFIRMED INDEPENDENTLY**, with dimension breakdowns |
| 10 | 42 terminal local models, split `1:2, C2:7, C3:9, V4:3, C5:1, C6:16, C11:4` | **CONFIRMED AS A CROSS-CHECK.** The packet's global chain enumeration and `STANDARD_FORM_PW`'s local character automaton are genuinely independent engines and agree class by class; I verified the merged packet's §5(b) table carries exactly this split. Not recomputed a third time here. |
| 11 | **CORRECTION** to `STANDARD_FORM_PW` §5(d): its counts are lower bounds | **CONFIRMED INDEPENDENTLY.** My recount of "components created over the generic point of each centre, at the moment of creation" reproduces the corrected values exactly. The correction is now also recorded *in* the merged `STANDARD_FORM_PW` (THEOREM.md §5(d) and STATUS.md item 3), so its numbers can no longer be read without it. Its dimension profiles and all its exit strings are unaffected — confirmed. |
| 12 | every stratum is rational (closure = a blowup of `P(A_0) × ∏ P(A_i)`) | **ACCEPTED (Tier 1 given Theorems 1–3).** The product factors are exactly the eigen-piece dimensions the independent enumeration produces, so the birational-model column is structurally forced row by row. |
| 13 | closure poset: **145** strict containments; strict partial order; components of `Z^H` pairwise disjoint; 42 orbits with nothing above but `Z`; minimal elements = the 51 `dim 0` rows | **ACCEPTED AS PACKET-VERIFIED, NOT INDEPENDENTLY REPLICATED** — with one prose defect found (D6). `t4_poset.py` machine-checks the order axioms, the isotropy/dimension monotonicity and the disjointness at both primes; `results/t4_poset.json` does carry 145 relations and 42 orbits whose only container is the free stratum. Reproducing the relation *count* would mean re-implementing the packet's own closure rule, so no independent value was available; this is the one substantive claim I did not re-derive. It is derived (nothing else depends on it) and not load-bearing for any exit outside this packet. The minimal-element list *is* independently confirmed: the census has exactly 51 `dim 0` orbits, split `V4 12 · C3 6 · C5 10 · C6 19 · C11 4` as §5 states. |
| 14 | `Z → Z⁺`: 3 rows consumed, 3 new, 77 unchanged; the 2 new `V4` surface orbits = `2 × 165 = 330` fabulous corners | **ACCEPTED AT THE PACKET'S OWN TIER 3.** I independently confirm the input row: `M_τ^V` is a single census row, `C2`, `dim 2`, exactly **165 components**, `Stab_G = V4`. The delta itself is weight bookkeeping, not an independent chart, and the packet says so (§9 Tier 3 item 3); it agrees with `DUNCAN_CORNER_F2`'s independently derived 330 = 55 × 6 corner labels. The word "fabulous" rests on `thm:pairs`, correctly flagged **EXTERNAL-UNVERIFIED**; the computed statements are unconditional. |
| 15 | "every `V4` row sits on a crossing (`|I| ≥ 2`)" | **CONFIRMED INDEPENDENTLY**: 2970 of 2970 `V4` components have chain length ≥ 2 |
| 16 | no conflation with the spin packets | **CONFIRMED.** The source here is `P(W)`, `W` the 5-dimensional Klein representation of `PSL(2,11)`. The strings `P(U)`, `spin`, `V14` do not occur anywhere in the packet's prose. The spin packets' source-side censuses concern `P(U)` for the 6-dimensional spin representation of `SL(2,11)` and are a different object; nothing here touches them. |
| 17 | headline unchanged: Problem E remains OPEN; no target-side claim | **CONFIRMED.** §11 disclaims explicitly; the manifest record carries `headline_claim: null`, `problem_state: OPEN`. |

## 4. Defects found, and the fixes applied on this branch

**D1 — `THEOREM.md` §2, wrong column (fixed).** The last column, headed
"components for ONE fixed `H`" and captioned "`|N_G(H)|/|Stab_G(F)|` summed
over the orbit", carried **239** for `C2` and **80** for `C3`. Those are the
`Z^H` totals of §6, not the `Z_{=H}` ones: the stated formula gives **39** and
**42** (and the machine's own `#/fixedK` column in `results/t2_strata.txt` sums
to exactly 39 and 42). The other four rows agree under both readings, because
`V4, C5, C6, C11` have no larger occurring class above them. Fixed by splitting
the column in two and giving both numbers.

**D2 — `THEOREM.md` §4, stage table (fixed).** The table put "`A4` and `D10`
gone" at stage 2, implying `D10` survives T0. It does not: `D10` is already
absent as a setwise stabilizer at stage 1 (independently confirmed at both
primes); only `A4` survives T0 and dies at T1. §4's own prose said this
correctly ("`D12` and `D10` vanish outright" at T0); the table did not.

**D3 — stale provenance (fixed).** `THEOREM.md` §10 and `STATUS.md` asserted
that `STANDARD_FORM_PW` is "**not on `main`**". It has been on `main` since
PR #29 (merge `64e41d3`). The carried copies of `psl211.py` and `sfcore.py`
are byte-identical to the merged ones — checked, and recorded in the note.

**D4 — registration / parity (fixed).** The branch was 1 commit behind a
much-advanced `main`, and its manifest did **not** list
`agent/terminus-strata-pw-20260810` in `known_branches`, so
`check_manifest_parity.py` **FAILED** (`unknown_remote_branches`, 9 branches).
Fixed by merging `origin/main` (both sides' NOTEBOOK entries kept; manifest
records and `known_branches` unioned; parent-head pin set to the merge's first
parent) and adding the three live branches created since `main`'s last manifest
rebuild.

**D6 — `THEOREM.md` §5, two wrong number words (fixed).** The breakdown of the
42 orbits "with nothing above them but `Z`" read "the seven `dim 2` and two
`dim 3` families … and eighteen isolated `dim 0` families". `Z` has only **five**
`dim 2` orbits in total, and the itemised lists in the same sentence name 5
surfaces and `10 + 4 + 6 = 20` isolated points. `results/t4_poset.json` gives
the split `dim 3: 2 · dim 2: 5 · dim 1: 15 · dim 0: 20 = 42`. The lists were
right; the two number words were not. Fixed.

**D5 — verifier docstring overclaimed (fixed).** `verifier.py` said it
"re-derives every census row independently of the census code". It does not —
it imports `census` from `tcore` and checks properties of that engine's output.
The docstring now states the scope accurately and points at
`scripts/adj_indep_census.py` for the completeness check.

## 5. Registration and parity at the final commit

* `NOTEBOOK.md` carries the `TERMINUS_STRATA_PW` entry with all six exit
  strings and the verify line; both sides of the merge are preserved.
* `notebook_build/manifest.json` carries the record (`entry E56`,
  `ALGEBRAIC-RECOMPUTE`, primary exit `TERMINUS-ORBIT-STRATA-PW-PASS`,
  `headline_claim: null`), and `known_branches` lists all 63 live remotes.
* `python3 problems/E-klein-cubic/scripts/check_manifest_parity.py` →
  **`RESULT: PASS (all checks passed)`**, including `exits_surfaced_in_notebook`.

## 6. Recommendation

**READY to merge.** The census is the strongest source-side artifact in the
packet series: its four headline numbers now have two independent derivations
agreeing at two primes, and its one genuine correction to a merged packet is
independently confirmed and has been propagated into that packet. The declared
Tier 3 items (four M2 genres rather than 80 rows; the cited DCP chart theorem;
the `Z⁺` delta from weight bookkeeping) are correctly scoped, and claim 13 (the
poset) should be read as packet-verified rather than adjudicator-replicated.
