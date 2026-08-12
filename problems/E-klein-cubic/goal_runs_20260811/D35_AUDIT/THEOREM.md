# Adversarial audit of the d = 35 kill tables, plus the linkage repair

**Packet:** `goal_runs_20260811/D35_AUDIT/` · opened 2026-08-11.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Hostile audit of the five machine facts behind the degree-35 collapse
`756 → 22` in `PAIR_ATTACK_D35` (THEOREM §§10–12; `WORKED_EXAMPLE.md`,
including the §6 retraction). Confirmation is meaningful only because
refutation was attempted. One target is **REFUTED with witness**.

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
D35-AUDIT-T1-ORD2-CONFIRMED
D35-AUDIT-T2-SIXFLIP-CONFIRMED
D35-AUDIT-T3-VANISHING-CONFIRMED
D35-AUDIT-T4-DEPTH-PARITY-REFUTED
D35-AUDIT-T5-FLIP-SPAN-CONFIRMED
D35-AUDIT-LINKAGE-REPAIRED
D35-AUDIT-CENSUS-336-398-22-REPRODUCED
D35-AUDIT-NO-DEGREE-EXCLUSION
```

Machine markers: `D35_AUDIT_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py`).

---

## 0. What was audited

| target | claim (from PAIR_ATTACK_D35) | method |
|---|---|---|
| **T1** | `ord ≥ 2` on one minus-line has rank 39 on the sealed 39-slice (kills 398) | independent Reynolds jet engine; own points/directions/seeds; primes 331, 661, **991** |
| **T2** | universal six-flip cut: slice rank 2, ambient rank 2 | independent V4 construction + Reynolds `(34,1)` extraction |
| **T3** | 14 of 18 value-defined rid-1 rows have level-0 reading ≡ 0 on the slice | independent evaluation of all value-defined kids |
| **T4** | exactly six type-I-plus-plane V4-children have arc-period 2; every other child is depth-constant | `s3jet.chi_arc_of` + `value_at_level` at κ = 0,1,2 |
| **T5** | six flip functionals lie in the span of plain line-evals (joint rank = rank V1 = 10; V1 on 37-cell has rank 8) | joint rank of (V1 ‖ FLIP) on the slice |
| **repair** | content-addressed re-emission of 756 patterns; 3-run identical; split 336+398+22; 22 match `survivors22` | deterministic sort of tagged tables; embed full assign dicts |

**Hard constraint observed:** T1–T3 evaluation uses `scripts/reynolds.py`
(own Reynolds sum). It does **not** import `slicelib.jet_rows`. Linear algebra
and the Weil frame are reimplemented in `scripts/linalg.py` and
`scripts/frame.py`. Sealed Layer-0 seeds `A,C` and nullspaces at 331/661 are
consumed read-only; at 991 the nullspace is rebuilt (`results/layer0_null_p991.npy`,
dim 39).

---

## 1. Per-target verdicts

### T1 — `ord ≥ 2` impossibility: **CONFIRMED**

At every prime 331, 661, 991, with RNG seed and involution pick different from
the director finisher:

| prime | rank V1 (ord ≥ 1) | rank V1+V2 (ord ≥ 2) | alt-line ord ≥ 2 | saturation |
|---:|---:|---:|---:|---|
| 331 | 10 | **39** | 39 | OK |
| 661 | 10 | **39** | 39 | OK |
| 991 | 10 | **39** | 39 | OK |

Dimension after ord ≥ 2 is **0**. Second minus-line (different involution)
also full-rank. Modular full rank ⇒ characteristic-0 emptiness of the ord ≥ 2
branch on the sealed slice (sound direction of the modular inference).

The 398 patterns whose L-row options are all of transverse order ≥ 2 are
therefore dead by a construction-independent route.

### T2 — universal six-flip cut: **CONFIRMED**

| prime | R1 rigidity violations | ambient rank | slice rank |
|---:|---:|---:|---:|
| 331 | 0 / 3822 | **2** | **2** |
| 661 | 0 / 3822 | **2** | **2** |
| 991 | 0 / 3822 | **2** | **2** |

Matches ODDZERO F1 (ambient corank) by an independent V4/Reynolds route.
Every live m = 1 cell has dim ≤ 37.

### T3 — 14-row vanishing table: **CONFIRMED** (with interpretation)

| prime | value-defined rows | forced-deeper | matches sealed p331 ids |
|---:|---:|---:|---|
| 331 | 18 | **14** | yes: `[23,24,35,36,37,38,41–46,68,69]` |
| 661 | 18 | **14** | no (ids prime-dependent): `[23,24,37–46,74,75]` |

Rigidity 0 at both primes. **Interpretation (machine-checked against T4):**
a vanishing level-0 reading means the reading lives deeper; it is a *value*
contradiction only where the arc character has period > 1. This is exactly
the subtlety that forced the §6 retraction of the 420-kill census.

### T4 — depth-parity semantics: **REFUTED**

**Claim under audit:** *exactly* the six type-I-plus-plane V4-children have
arc-character period 2 on `D_{P_σ}`, and every other child's value is
depth-constant.

**Machine fact (both primes identical histogram):**

| period | # kids (rid 1) |
|---:|---:|
| 1 | 36 |
| **2** | **6** |
| **3** | **12** |

- The six period-2 kids exist, sit on rows `{25, 26}`, and **all alternate**
  lab₀ ≠ lab₁. That sub-claim stands.
- **Counterexample to “every other child is depth-constant”:** twelve kids
  have period 3; of these, six have both lab₀ and lab₁ defined and
  **lab₀ ≠ lab₁**. Witnesses (p = 331), among others:

  - kid 6210, row 68, period 3: lab₀ ≠ lab₁ (both in cell `P6`)
  - kid 6214, row 69, period 3: lab₀ ≠ lab₁
  - kids 8973, 8975, 9596, 9598 on rows 61, 63: same

So the keep-kill inference “level-0 vanishes ⇒ kept value unattainable” is
valid on a **strictly larger** set than the six period-2 locations: it also
applies wherever period > 1 and the level-1 eigenline exists. The §6
retraction correctly withdrew the 420-kill that treated *all* 14 forced-deeper
rows as value contradictions; but the residual slogan “only the six alternate”
is false.

**Campaign consequence (not a degree exclusion):** any future open-condition
analysis on the 22 survivors must use the full period table (period ∈ {2, 3}
both flip values), not a hand-count of six. The 336 + 398 closed kills do
**not** depend on this claim and stand.

### T5 — flips in the span of line-evals: **CONFIRMED**

| prime | rank FLIP | rank V1 | rank joint | rank V1 on 37-cell |
|---:|---:|---:|---:|---:|
| 331 | 2 | **10** | **10** | **8** |
| 661 | 2 | 10 | 10 | 8 |
| 991 | 2 | 10 | 10 | 8 |

Joint rank = rank V1 ⇒ the six flip functionals are linear combinations of
plain line-evaluation functionals on the corresponding minus-line.

**Geometric reason (recorded, not fully formalised):** after the sealed
profile cuts, the bidegree-(34, 1) reading of a Reynolds covariant along an
attaching arc at a point of a minus-line is a linear functional of the
restriction of `T` to a neighbourhood of that line. Sampling enough plain
evaluations on the line therefore spans those six readings. Equivariance
moves the fact from one line to all.

---

## 2. Linkage repair: **REPAIRED**

**Defect.** `patterns_r5.py` stores `compat_ff` as indices into tables rebuilt
by `build_tagged_ff_tables`. Table order is not content-addressed; across
runs the same index can resolve to a different assignment (observed by the
director on blueprint 0).

**Fix (this packet only; sealed scripts untouched).**
`scripts/repair_patterns.py`:

1. Rebuilds tagged full-flag tables.
2. Sorts every rid’s entries by the canonical assignment key.
3. For each of the 756 sealed patterns, embeds the **full assignment
   dictionaries** of every sorted-table entry whose multidegree lies in the
   pattern’s `a35_{P,L}_options` (content match — no index indirection).
4. Content-hashes each pattern from the embedded payload.
5. Writes `results/patterns_r5_content_p{331,661}.json`.

**Verification.**

| check | 331 | 661 |
|---|---|---|
| three independent runs, content-sha1 identical | **yes** (sha1 `35f2ef03…`) | **yes** (algorithm + emission) |
| split 756 = 336 + 398 + 22 | yes | yes |
| 22 ids match `survivors22_p*.json` | yes | yes |
| 22 sealed hashes match | yes | yes |
| every pattern has embedded assigns for rid 1 and 2 | yes | yes |

Survivor ids (both primes):
`[5, 7, 13, 15, 21, 23, 29, 31, 37, 39, 45, 47, 53, 55, 61, 63, 69, 71, 697, 699, 701, 703]`.

---

## 3. Honesty tiering

| claim | tier |
|---|---|
| T1 rank-39 ord ≥ 2 on the 39-slice, three primes, independent Reynolds | **char-0 unconditional** (modular full rank) |
| T2 ambient/slice rank 2 of six flips | **char-0 unconditional** (same) |
| T3 count 14/18 forced-deeper | **two-prime finite exact**; row ids prime-dependent |
| T4 refutation (period-3 kids exist and alternate) | **two-prime finite exact** |
| T5 joint rank / span | **three-prime finite exact** |
| 336 multidegree kill (m ∈ {3, 5}) | **not re-audited** (consumes PAIR_ATTACK Layer-1; full-rank there already) |
| 398 ord ≥ 2 kill | **promoted** by T1 |
| 22 live cells at dim ≤ 37 | **upper bounds**, open-condition layer not closed |
| any degree exclusion | **not claimed** |

---

## 4. Not claimed

- Degree 35 is **not** closed. The window statement is unchanged.
- The 22 survivors are **not** decided: keeps, jet layer, C4/C6, dominance
  remain open. T4’s refutation widens the set of rows where a keep of a
  forced-deeper reading is a genuine value contradiction (period 2 **and**
  period 3), so any future keep-analysis must be redone against the full
  period table.
- The 336 multidegree kill is not independently rebuilt here (out of scope of
  T1–T5; it is a sealed full-rank cut on m ∈ {3, 5}).
- No corrected global count of coherent patterns at odd residue is offered.
- Char-0 statements that rest on a *nonzero* modular kernel are not made.

---

## 5. Reproduction

```sh
cd goal_runs_20260811/D35_AUDIT

# independent rebuilds (heavy; ~minutes each)
python3 scripts/audit_t1_ord2.py 331 661 991
python3 scripts/audit_t2_sixflip.py 331 661 991
python3 scripts/audit_t3_vanishing.py 331 661
python3 scripts/audit_t4_depth_parity.py 331 661
python3 scripts/audit_t5_flip_span.py 331 661 991
python3 scripts/repair_patterns.py three 331
python3 scripts/repair_patterns.py three 661

# verifier (reads results/)
python3 verifier.py
# expect: D35_AUDIT_VERIFY_OK / ALLGREEN
```

---

## 6. Summary for the director (≤ 25 lines)

```text
Headline: Problem E remains OPEN; this packet excludes no degree.

T1 ord≥2 impossibility:     CONFIRMED  (rank 39 at 331, 661, 991; dim 0)
T2 six-flip cut:             CONFIRMED  (ambient 2, slice 2; all three primes)
T3 14-of-18 vanishing table: CONFIRMED  (ids prime-dependent; count stable)
T4 depth-parity semantics:   REFUTED    (12 period-3 kids; 6 with lab0≠lab1)
T5 flips ⊂ span(line-evals): CONFIRMED  (V1=10, joint=10, V1|37=8; 3 primes)

Third prime 991: Layer-0 null dim 39; T1/T2/T5 all confirm.

Linkage repair: REPAIRED. Content-addressed 756 patterns with embedded
assignment dicts; 3-run content-sha1 identical at p=331; split
756 = 336 + 398 + 22; 22 ids/hashes match survivors22_p{331,661}.json.

What stands: 336 + 398 closed kills; 22 live at dim ≤ 37.
What does not: any degree exclusion; open-condition kill of the 22
(must use full period table, not “only six alternate”).
```

## Director adjudication (2026-08-11, appended before sealing)

1. Replayed from a clean shell: `D35_AUDIT_VERIFY_OK` / `ALLGREEN`
   (92 checks). The T1/T2/T3/T5 confirmations at the third prime with an
   independent engine promote the 336 + 398 closed kills and the
   22-at-dim-≤-37 census to audit-grade; the linkage repair's
   content-addressed pattern files are now the canonical blueprint data.
2. **T4's refutation is accepted and propagated**: correction banners are
   placed on `PAIR_ATTACK_D35` §12.1 and `WORKED_EXAMPLE.md` §6. The
   census retraction STANDS (the inference was still misapplied), but its
   stated justification ("value constant except at six children") was
   wrong a second time — the true period histogram is 36 / 6 / 12, and at
   the period-3 children over rows 68/69 (both among the 14 dead rows)
   the keep-demands genuinely force additional closed vanishing layers.
   That corrected keep-analysis is queued as the value-layer pass on the
   22, on the audited period table.
3. **T6 (the cone-order premise, `ord_{ℓ_V} ≥ 6`) was added to the
   workorder after this worker launched and is NOT covered here.** It
   remains the one unaudited premise scoping the 39-space; open item for
   the next audit round.
