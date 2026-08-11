# Proposed registration (NOT applied — `NOTEBOOK.md` and `manifest.json` untouched)

## A. NOTEBOOK.md entry (≤ 30 lines, exit strings verbatim)

```markdown
### TERMINUS_STRATA_PW — the full stabilized-strata census of the source terminus (2026-08-10)

`goal_runs_20260810/TERMINUS_STRATA_PW/THEOREM.md`. Source side only; **Problem E
remains OPEN**. The orbit-type (exact-stabilizer) stratification of the terminus
`Z` of the `STANDARD_FORM_PW` tower over `P(W) = P^4`, `G = PSL(2,11)`.

Identifies `Z` as the maximal De Concini–Procesi wonderful model of the
1215-element subspace arrangement `A` (940 points, 220 lines, 55 planes, closed
under intersection), which gives a closed chart form for every point and makes
the census exact and finite.

* **80 `G`-orbits of orbit-type strata; 11 076 components.** Per stage:
  15/1216 (`P(W)`) → 57/7336 (T0) → 70/9591 (T1) → 80/11 076 (T2).
* Point stabilizers: exactly `{1,C2,C3,V4,C5,C6,C11}`; the other **9 of the 16**
  subgroup classes are **certified empty** (exhaustive enumeration + 79 sampled
  points with brute-force stabilizers at two primes).
* Setwise stabilizers: only **8 of 16** occur — `C2,C3,V4,C5,C6,C11,D12,G`.
  `A4` and `D10` occur at level 0 and are destroyed by the tower.
* Closure poset: 145 containments. Crossings: 19 orbits at `|I|=2`, **5 orbits of
  165 at `|I|=3`** (all on `ℓ_V`-`P_σ` flags). No non-cyclic generic crossing
  stabilizer ⇒ no fabulous corner on `Z`.
* Every stratum is **rational** (a blowup of a product of projective spaces) —
  verified per row, not imported from `lem:rational_strata_propagate`.
* `Z → Z⁺` (the corner packet's T3): 3 rows consumed, 3 new, 77 unchanged; the
  two new `V4`-fixed surfaces, `2 × 165 = 330`, **are** `DUNCAN_CORNER_F2`'s
  fabulous corners.
* Reproduces independently: `STRATA_EXACT` level-0, the 1215 divisors in 14
  orbits, the **42 terminal local models class-by-class**, the crossing table.
* **CORRECTION.** `STANDARD_FORM_PW` §5(d)'s "components created inside
  exceptional divisors" counts are lower bounds (its producer de-duplicates on a
  signature that merges distinct `G`-orbits): `C2 {1:1155,2:440,3:110} →
  {1:1320,2:605,3:110}`, `V4 {0:660,1:330} → {0:1155,1:330}`, `C5 396 → 1320`,
  `C6 330 → 1100`, `C11 60 → 240`; `C3` unchanged. No exit string affected.

Exits: `TERMINUS-ORBIT-STRATA-PW-PASS`, `TERMINUS-STRATA-ALL-16-CLASSES-CERTIFIED`,
`TERMINUS-CLOSURE-POSET-SEALED`, `TERMINUS-QUOTIENT-STRATIFICATION-COMPLETE`,
`TERMINUS-ZPLUS-DELTA-SEALED`, `STANDARD-FORM-PW-5D-COUNTS-CORRECTED`.
Verify: `python3 verifier.py` → `TERMINUS_STRATA_PW_VERIFY_OK` / `ALLGREEN`.
```

## B. `notebook_build/manifest.json` record

```json
{
  "id": "TERMINUS_STRATA_PW",
  "date": "2026-08-10",
  "problem": "E-klein-cubic",
  "path": "goal_runs_20260810/TERMINUS_STRATA_PW",
  "main_document": "THEOREM.md",
  "status": "COMPLETE",
  "headline_claim": null,
  "problem_state": "OPEN",
  "side": "source",
  "primary_exit": "TERMINUS-ORBIT-STRATA-PW-PASS",
  "exits": [
    "TERMINUS-ORBIT-STRATA-PW-PASS",
    "TERMINUS-STRATA-ALL-16-CLASSES-CERTIFIED",
    "TERMINUS-CLOSURE-POSET-SEALED",
    "TERMINUS-QUOTIENT-STRATIFICATION-COMPLETE",
    "TERMINUS-ZPLUS-DELTA-SEALED",
    "STANDARD-FORM-PW-5D-COUNTS-CORRECTED"
  ],
  "exits_surfaced": true,
  "machine_marker": "TERMINUS_STRATA_PW_VERIFY_OK",
  "verifier": "python3 verifier.py",
  "verifier_runtime_minutes": 9,
  "toolchain": ["python3", "Macaulay2"],
  "primes": [331, 661],
  "depends_on": [
    "goal_runs_20260810/STANDARD_FORM_PW",
    "goal_runs_20260810/DUNCAN_CORNER_F2",
    "theory/FIX_I_bcomplex.md",
    "certificates/STRATA_EXACT.md"
  ],
  "external_unverified": ["thm:pairs"],
  "corrects": {
    "target": "goal_runs_20260810/STANDARD_FORM_PW section 5(d)",
    "nature": "component counts were lower bounds (de-duplication merged distinct G-orbits)",
    "affects_exits": false
  },
  "key_numbers": {
    "stratum_orbits": 80,
    "components": 11076,
    "stages": {"P(W)": [15, 1216], "T0": [57, 7336], "T1": [70, 9591], "T2": [80, 11076]},
    "point_stabilizer_classes_occurring": 7,
    "point_stabilizer_classes_empty": 9,
    "setwise_stabilizer_classes_occurring": 8,
    "poset_relations": 145,
    "double_crossing_orbits": 19,
    "triple_crossing_orbits": 5,
    "triple_crossing_components": 825,
    "zplus_delta": {"consumed": 3, "new": 3, "unchanged": 77, "fabulous_corners": 330}
  },
  "notes": "Foundation packet STANDARD_FORM_PW is not on main; it lives on branch agent/standard-form-pw-20260810, commit 1430ffa. This packet carries its own copies of psl211.py and sfcore.py."
}
```

## C. Registration caveats for the notebook maintainer

1. **`STANDARD_FORM_PW` is not merged.** Registering this packet before it
   creates a dangling `depends_on`. Either merge that branch first, or record
   the dependency as `branch:agent/standard-form-pw-20260810@1430ffa`.
2. The correction in §7 of `THEOREM.md` should be reflected in whatever
   NOTEBOOK entry `STANDARD_FORM_PW` receives — its §5(d) table needs the five
   revised cells. **No exit string of that packet changes.**
3. `thm:pairs` remains EXTERNAL-UNVERIFIED and is load-bearing only for the word
   "fabulous"; the computed statements are unconditional.
4. The Macaulay2 check `scripts/t6_charts.m2` (18/18, `T6_CHARTS_OK`) is exact
   over `QQ(ζ_6)` but covers **four representative genres, not all 80 rows** —
   marked sampled in `STATUS.md`. It is not invoked by `verifier.py`, which is
   pure python3 by the packet convention.
