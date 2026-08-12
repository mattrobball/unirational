# Adversarial audit of the arc-jet ladder (the 62 flagged kills)

**Packet:** `goal_runs_20260812/ARCJET_AUDIT/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Hostile audit of the four machine facts behind the 62 arc-jet deaths of the
508 extended blueprints in `D35_EXTENDED_SIEVE`. Confirmation is meaningful
only because refutation was attempted with an independent Reynolds engine.
No target is REFUTED; all four are **CONFIRMED** (with recorded soft notes).

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
ARCJET-AUDIT-A1-VANISHING-CONFIRMED
ARCJET-AUDIT-A2-FRAMES-CONFIRMED
ARCJET-AUDIT-A3-MATERIALIZE-CONFIRMED
ARCJET-AUDIT-A4-ANCHOR-CONFIRMED
ARCJET-AUDIT-THIRD-PRIME-991
ARCJET-AUDIT-NO-DEGREE-EXCLUSION
```

Machine markers: `ARCJET_AUDIT_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — primes `p = 331, 661, 991` for A1/A2/A4;
`331, 661` for A3 materialization).

---

## Summary (≤ 20 lines)

```text
Headline: Problem E remains OPEN; this packet excludes no degree.

A1 IDENTICALLY-ZERO PATTERN: CONFIRMED (331/661/991). Own Reynolds jets J=10
  at 12 period-3 kids; hard rigidity 0 at κ∈{0,1,2,5,8}; zero counts match
  sealed (κ2:4/12, κ5:12/12, κ8:4/12). Replay kills all 62 at 331/661.
A2 FRAME CONSTRUCTION (no level-0): CONFIRMED. 4/12 p3 kids lack surface
  values; U_char from first available level; 12/12 invertible frames; hard
  rigidity still 0 on no-level0 kids. Kills sit on forced-deeper rows that DO
  have level-0 (68/69 at 331; 74/75 at 661).
A3 508 + 298/148/62: CONFIRMED. Independent join re-enumeration: J=1264,
  strat=756, ext=508; sol_hash sets equal sealed; partition multi/line/ladder
  = 298/148/62 both primes.
A4 22-ANCHOR: CONFIRMED at 331/661 (hashes reappear, final live 22) and at
  991 (null dim 39, six-flip rank 2 → dim 37; survivor ids stable).
Third prime 991: vanishing histogram and hard rigidity match 331/661.
Soft notes (not refutations): κ=4 soft rigidity ~5084/7644 (as sealed);
  κ=7 full jet has W+ mass while character component is 0 (kill uses character).
What stands: the 62 arc-jet deaths as modular finite-exact on the 37-cell.
What does not: any degree exclusion; the 22 remain live at dim ≤ 37.
```

---

## 0. What was audited

| target | claim (from D35_EXTENDED_SIEVE) | method |
|---|---|---|
| **A1** | identically-zero arc-jet pattern on the 37-cell behind the 62 kills (κ≡1/κ≡2 keeps with all admissible levels vanishing) | own Reynolds `eval_jet`; own Weil frame; own F_p linalg; primes **331, 661, 991** |
| **A2** | attaching frames for period-3 children without level-0 surface values | independent frame build (U_char from first available level); geometry + rigidity |
| **A3** | 508 materialization hashes; partition 298/148/62 | re-enumerate joint residue-5 via DEPTH menus; sol_hash identity; partition |
| **A4** | 22-anchor sealed hashes unchanged; third prime 991 | sieve/census anchors at 331/661; null+six-flip geometry at 991 |

**Hard constraint observed:** A1 evaluation uses `scripts/reynolds.py` (own
Reynolds sum). It does **not** import `slicelib.jet_rows`. Frame and linear
algebra reimplemented in `scripts/frame.py` and `scripts/linalg.py`. Sealed
Layer-0 seeds and nullspaces at 331/661 consumed read-only; at 991 the
D35_AUDIT null cache is consumed read-only. Writes only under this packet.

---

## 1. Per-target verdicts

### A1 — identically-zero pattern: **CONFIRMED** (331, 661, 991)

Own six-flip cut rebuilds the 37-cell (rank 2, rigidity 0) matching the sealed
cell row-space at 331/661. Jets through order 9 along each of the 12 period-3
attaching pairs; character component on the 37-cell:

| prime | κ2 zero | κ5 zero | κ8 zero | κ1 zero | hard rig {0,1,2,5,8} | replay 62 |
|---:|---:|---:|---:|---:|---|---|
| 331 | **4/12** | **12/12** | **4/12** | 12/12 | all 0 | **62 dead / 0 live** |
| 661 | **4/12** | **12/12** | **4/12** | 12/12 | all 0 | **62 dead / 0 live** |
| 991 | **4/12** | **12/12** | **4/12** | 12/12 | all 0 | (no 508 live list) |

Sealed vanishing table: **0 mismatches** at 331/661. The 4 kids with all of
κ∈{2,5,8} vanishing are exactly the forced-deeper period-3 rows (68/69 at
331; 74/75 at 661; 74/75 family at 991). Both mod-1 and mod-2 closed sites
fire on every one of the 62 (primary mechanism prime-dependent in the sealed
ledger; both available).

**Soft note (not a refutation):** at κ=7 the *character* component vanishes on
killers but the full 5-vector jet has nonzero W⁺ components on the 37-cell.
The sealed kill reads only the character component (the quantity that realises
a domain label). Soft rigidity at κ=4 (~5084/7644) matches the sealed ladder;
hard anchors exclude κ=4.

### A2 — frames without level-0: **CONFIRMED**

At every prime, **4 of 12** period-3 kids lack a level-0 surface value
(e.g. 8972, 8974, 9597, 9599 at p=331). Frame construction:

1. prefer U₀ = `S.value(a=(34,1))` when own-frame label exists;
2. else first κ∈{0..8} with a defined cycle label;
3. else a kid line / y fallback.

All 12 frames invertible; hard rigidity 0 including on the 4 no-level0 kids.
Attaching pairs (w, y) are nonzero +1/−1 eigendata for Stage1 σ. **No frame
error.** The 62 kills concentrate on forced-deeper p3 rows that *have* level-0;
the no-level0 novelty is exercised by the jet table and rigidity anchors, not
by the death sites themselves.

### A3 — 508 materialization / 298·148·62: **CONFIRMED**

Independent re-enumeration of the residue-5 joint (DEPTH menus + stratified
core), both primes:

| prime | J | strat | ext | multi | line | ladder | sol_hash = sealed |
|---:|---:|---:|---:|---:|---:|---:|---|
| 331 | 1264 | 756 | **508** | **298** | **148** | **62** | joint ✓ ext ✓ |
| 661 | 1264 | 756 | **508** | **298** | **148** | **62** | joint ✓ ext ✓ |

Sol-hash sets equal the sealed joint/ext files exactly. Sealed content_hashes
are self-consistent under the sealed payload formula (0 self-mismatches on
1264+508). Partition 298/148/62 reproduced as closed classification of the
independent 508.

### A4 — 22-anchor: **CONFIRMED** (331, 661, 991)

| prime | check | result |
|---:|---|---|
| 331 | sealed 22 hashes present in joint/strat live; final live 22 | **OK** |
| 661 | same | **OK** |
| 991 | null dim 39; own-Reynolds six-flip rank 2 → dim 37; rigidity 0; survivor ids = SURV_IDS | **OK** |

Survivor ids
`[5,7,13,15,21,23,29,31,37,39,45,47,53,55,61,63,69,71,697,699,701,703]`
are stable across 331/661 and underwrite the 22 at 991 via the same geometric
cut (full 1264 re-materialization at 991 not required for the anchor).

---

## 2. Honesty tiering

| claim | tier |
|---|---|
| A1 vanishing histogram + hard rigidity, three primes, own Reynolds | **three-prime finite exact** |
| A1 replay of 62 deaths at 331/661 | **two-prime finite exact** |
| A2 frames / no-level0 rigidity | **three-prime finite exact** |
| A3 508 identity + 298/148/62 partition | **two-prime finite exact** |
| A4 22-anchor + 991 six-flip dim 37 | **three-prime finite exact** on geometry; two-prime on full sieve ledger |
| 62 deaths as degree exclusion | **not claimed** (22 remain) |
| any degree exclusion | **not claimed** |

---

## 3. Not claimed

* Degree 35 is **not** closed. The 22 remain live at dim ≤ 37 under closed
  conditions.
* The 508 all-dead status is modular finite-exact and now **audit-backed**
  for the arc-jet layer; it is still not a degree exclusion.
* Char-0 emptiness claimed only where modular rank is full (six-flip rank 2;
  not for nonzero kernels on the 37-cell).
* Open-condition realization of the 22 is untouched.

---

## 4. Reproduction

```sh
cd goal_runs_20260812/ARCJET_AUDIT

python3 scripts/audit_a1_a2.py 331 661 991    # ~90s/prime
python3 scripts/audit_a3_materialize.py 331 661  # ~3–4 min/prime
python3 scripts/audit_a4_anchor.py
python3 verifier.py
# expect: ARCJET_AUDIT_VERIFY_OK / ALLGREEN
```

Hard constraints: python3 only; primes 331, 661, 991; no git; writes only
inside this packet; own Reynolds engine (no `slicelib.jet_rows` for A1).

---

## 5. Dependencies (read-only)

| source | use |
|---|---|
| `D35_EXTENDED_SIEVE` | claims under audit; sealed 508/ladder/census for comparison |
| `DEPTH_TABLE_GENERAL` | depth menus for A3 re-enumeration |
| `TUPLE_JOINT_RESIDUE` | join semantics J(5)=1264 |
| `D35_AUDIT` | independent-engine precedent; null at 991; 22 content ids |
| `PAIR_ATTACK_D35` | Layer-0 seeds A,C and nullspaces 331/661 |
| Stage-1 engine packets | census kids / attaching geometry (shared); evaluation independent |

## Director adjudication

*(to be appended by the director before sealing)*

## Director adjudication (2026-08-12, appended before sealing)

Replayed clean: ALLGREEN. All four targets CONFIRMED at three primes with
an independent engine; the soft notes (κ=4 soft rigidity, κ=7 character
reading) are recorded as scope, not defects. CONSEQUENCE PROMOTED: the 62
arc-jet kills leave FLAGGED status; the degree-35 tuple-complete census
1264 → 22 is now audit-backed at every layer (promotion banner placed on
`D35_EXTENDED_SIEVE`).
