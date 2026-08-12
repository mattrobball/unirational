# The general depth-value table, and the corrected keep-pass on the 22

**Packet:** `goal_runs_20260812/DEPTH_TABLE_GENERAL/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Primary product: the sealed **general** depth-value table for every full-flag
child, indexed by multidegree class mod 6. Application: the corrected
keep-pass on the 22 d = 35 survivors, using closed conditions only and the
audited period table (`D35_AUDIT` T4: histogram 36 / 6 / 12).

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
DEPTH-TABLE-GENERAL-BUILT
DEPTH-TABLE-TWO-CLASS-VERIFIED
DEPTH-TABLE-T4-ANCHOR-REPRODUCED
DEPTH-TABLE-KEEP-PASS-22
DEPTH-TABLE-NO-DEGREE-EXCLUSION
```

Machine markers: `DEPTH_TABLE_GENERAL_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — both primes `p = 331, 661`).

---

## 0. Why general

The audited fact (`D35_AUDIT` T4): on the plus-row, children have arc-period
histogram **36 / 6 / 12** (periods 1 / 2 / 3), and values **change with depth**
wherever period > 1. Period structure and value cycles are
**degree-independent** — the degree enters only through the class `(a, ψ)` of
the leading datum (mod-6 data, Theorem S). So the correct deliverable is not a
d = 35 patch but the sealed general table every window consumes from now on.

---

## 1. Deliverable 1 — the general table

### 1.1 Shape

For **both** full-flag rows and every child, as a function of the multidegree
class mod 6:

| row | id | slots | class key | representative |
|---|---:|---|---|---|
| plus-row `D_{P_σ}` | rid 1 | dims 3+2 | `(d mod 6, m mod 6)` | `a = (d−m, m)` |
| line-row `D_{L⁻_σ}` | rid 2 | dims 2+3 | `(d mod 6, ν mod 6)` | `a = (d−ν, ν)` |

Per child and class:

* arc-character period (`s3jet.chi_arc_of`);
* value **cycle** at depth levels `κ = 0, …, period−1` (`value_at_level` +
  `own_frame` labels, machine-readable);
* which cycle entries are arc-consistent (label ∈ child row's domain) — the
  depth levels a coherent blueprint may assert.

Period is class-independent (depends only on the child's Λ). The cycle depends
on `a` only through its residue mod 6: two absolute multidegrees in the same
class produce identical cycles (verified).

### 1.2 Period histograms (both primes identical)

| row | period 1 | period 2 | period 3 | n kids |
|---|---:|---:|---:|---:|
| rid 1 | **36** | **6** | **12** | 54 |
| rid 2 | 0 | **12** | **6** | 18 |

T4 anchor on rid 1: **reproduced** (36 / 6 / 12). The six period-2 kids sit on
the type-I-plus-plane V4 children and alternate; twelve period-3 kids also
change value with depth (T4 refutation of “only the six alternate”).

### 1.3 Two-class verification

Explicit character-rule evaluation at both primes for two distinct degree
classes:

| row | class A | class B | same-class lift match |
|---|---|---|---|
| rid 1 | `(d,m) ≡ (5,1)` (res. of 35, m=1) | `(4,1)` (res. of 34, m=1) | 54/54 both primes |
| rid 2 | `(d,ν) ≡ (5,0)` → a=(35,0) | `(4,1)` → a=(33,1) | 18/18 and 16-class match |

Concrete absolute evaluation at d = 35, a = (34, 1) is stored under
`concrete_class_d35_a_34_1` (period hist 36/6/12; full cycles).

Artefacts: `results/depth_table_p{331,661}.json`.

---

## 2. Deliverable 2 — corrected keep-pass on the 22

### 2.1 Setup

* Base: sealed Layer-0 null (dim 39) cut by the universal six flips → **37-cell**
  (rank 2; rigidity 0/3822).
* Blueprints: content-addressed 22 from `D35_AUDIT` repair
  (`patterns_r5_content_p*.json`), ids
  `[5,7,13,15,21,23,29,31,37,39,45,47,53,55,61,63,69,71,697,699,701,703]`.
* Forced-deeper rows recomputed in-run: **14 of 18** value-defined rid-1 rows
  have level-0 reading ≡ 0 on the 39-slice (ids prime-dependent; count stable).
* Working class: `(34, 1)` on rid 1.

### 2.2 Closed-condition rule (from the general table)

At each keep on a forced-deeper row, split by the child's period:

| period | rule |
|---|---|
| 1 | keep unaffected (value depth-constant) — **no closed condition** |
| > 1, kept value only at levels `κ ≡ 0 (mod period)` | level 0 is dead ⇒ force **levels 1 … period−1 vanish** (closed) |
| > 1, kept value at other residues | **open** demand — recorded, not used to kill |

Level-κ functional = the `t^{κ+1}` jet of the Reynolds reading along the
child's attaching pair `(w, y)` (director frame; same extraction as the six
flips' level-0). Rigidity anchors: transverse W⁻ component vanishes for all
637 basis covariants at every new jet order (0 violations of 31 850 checks
per level per prime).

### 2.3 Outcome (both primes identical)

| quantity | value |
|---|---:|
| survivors in | 22 |
| **dead by closed keep-pass** | **0** |
| **live** | **22** |
| live dims (upper bounds) | **{37}** |

On the period-3 forced-deeper kids (rows 68/69 at p=331; prime-dependent ids
at p=661), every survivor that keeps the level-0 label imposes 8 closed
functionals (4 kids × levels {1,2}). Those functionals have **rank 0** on the
37-cell: intermediate levels already vanish on the sealed slice. The closed
conditions are satisfied free of charge; they kill no cell.

Branches that keep a non-mod-0 cycle value (e.g. lab at κ≡1 or κ≡2) carry
**open** nonvanishing / depth-matching demands — listed per branch in
`results/keep_pass_22_p*.json` under `open_demands`. Period-1 keeps on the
other 12 forced-deeper rows are likewise open only as residual nonvanishing
deeper, not as closed cuts.

**No keep-based kill outside the period->1-with-dead-level-0 rule.** No cell
death is claimed beyond what closed conditions soundly give (here: none).

---

## 3. Honesty tiering

| claim | tier |
|---|---|
| rid-1 period histogram 36/6/12 (T4 anchor) | **two-prime finite exact** |
| rid-2 period histogram 12/6 | **two-prime finite exact** |
| value cycles depend on a only mod 6 (same-class lift) | **two-prime finite exact** |
| 14/18 forced-deeper at d=35 | **two-prime finite exact** (ids prime-dependent) |
| universal six rank 2 → dim ≤ 37 | **char-0 unconditional** (modular full rank of corank-2 cut; sealed) |
| closed keep-pass rank 0 on 37-cell; 0 deaths | **two-prime finite exact** upper bounds on live dims |
| any degree exclusion | **not claimed** |

---

## 4. Not claimed

* Degree 35 is **not** closed. The 22 remain live at dim ≤ 37 under closed
  conditions.
* Open keep demands (nonvanishing at the correct depth residue; realization
  C4/C6/dominance) are **not** used to kill.
* No corrected global pattern count at odd residue.
* Char-0 emptiness is claimed only where modular rank is full (not for
  nonzero kernels).

---

## 5. Reproduction

```sh
cd goal_runs_20260812/DEPTH_TABLE_GENERAL

python3 scripts/build_depth_table.py 331 661
python3 scripts/keep_pass_22.py 331
python3 scripts/keep_pass_22.py 661
python3 verifier.py
# expect: DEPTH_TABLE_GENERAL_VERIFY_OK / ALLGREEN
```

Hard constraints observed: python3 only; primes 331, 661; no git; writes only
inside this packet.

---

## 6. Summary for the director (≤ 25 lines)

```text
Headline: Problem E remains OPEN; this packet excludes no degree.

GENERAL TABLE (primary product).
  rid1 (plus-row): period hist 36 / 6 / 12 over 54 kids; cycles by (d,m) mod 6.
  rid2 (line-row): period hist 12 / 6 over 18 kids; cycles by (d,ν) mod 6.
  T4 anchor 36/6/12 reproduced. Same-class lift: cycles invariant under a_i += 6.
  Two-class verification at both primes: rid1 classes (5,1)&(4,1); rid2 (5,0)&(4,1).

KEEP-PASS ON THE 22 (application at d=35, a=(34,1)).
  Forced-deeper: 14/18. Universal six: rank 2 → 37-cell. Rigidity 0 at levels 0,1,2.
  Period-3 keeps of lab0 force levels 1,2 vanish: rank 0 on the 37-cell (already free).
  Closed-condition deaths: 0. Live: 22 at dim ≤ 37. Open demands recorded per branch.

What stands: the general table every window must use; the 336+398 closed kills
untouched; 22 still live under the corrected closed keep-pass.
What does not: any degree exclusion; open-condition kill of the 22.
```

## Director adjudication (2026-08-12, appended before sealing)

Replayed from a clean shell: ALLGREEN. Accepted as delivered.
Specific notes: the honest null outcome of the keep-pass is accepted (the
period-3 level-1/2 functionals vanish identically on the 37-cell, so the
kept values recur freely at level 3 — no closed kill); the general table
(including the line-row's new 12/6 histogram) is the sealed product and
every future window consumes it instead of re-deriving depth semantics.
