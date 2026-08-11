# Global coherence: shared-μ collapse and the incidence/Z⁺ join

**Packet:** `goal_runs_20260811/GLOBAL_COHERENCE/` · opened 2026-08-11.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

The independence formula of `STAGE1_TIGHTEN` §2.4 (corrected `K` from
`STAGE1_STRATIFIED`)

```
   count(d)  =  K(d mod 6)  ×  D10(d, μ₁)  ×  3⁸ ,     D10 ∈ {13, 10}
```

is false twice over. This packet removes both lies: (1) the 22 immune rows
share the jet orders `μ` of their centre, so independent residual counting
overcounts attainable value-vectors; (2) the D10 C2-line branch parity uses
the same `μ₀` as the `pt_D10` rows, and the order-0 incidence lattice is
imposed globally (it does not bind the immune block — see §3).

Everything is **map-level** (pinning inputs assume a reduced lift). No
residue has `G = 0` or `F_odd = 0`; nothing is flagged for exclusion; no
transport-pairing claim is made.

*(Filename note: main document is `THEOREM.md`; the harness refuses `REPORT.md`.)*

## Exit ledger

```text
GLOBAL-COHERENCE-SHARED-MU
GLOBAL-COHERENCE-F-ODD
GLOBAL-COHERENCE-JOIN
GLOBAL-COHERENCE-D10-MU-COUPLING
GLOBAL-COHERENCE-INCIDENCE-IMMUNE-FREE
GLOBAL-COHERENCE-NO-DEGREE-EXCLUSION
```

Machine markers: `GLOBAL_COHERENCE_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **116 checks, 0 failures**; weight layer
prime-free; `K` table sealed at both `p = 331, 661`).

---

## 0. Inputs consumed (not rewritten)

| source | used for |
|---|---|
| `STAGE2_ODD_ORDER_PINNING` `scripts/s2pin.py` | `IMMUNE_ROWS` chain data; PATH A / PATH B `w(R)` (47 736 cases, 0 mismatches, reused) |
| `STAGE2_SECOND_ORDER` | `μ ≥ 2` at A4-points; C6-point excluded at `μ = 3`; residual table |
| `STAGE1_STRATIFIED` | corrected `K = (11068, 1178, 1512, 6216, 1344, 756)` |
| `STAGE1_TIGHTEN` §2.3–2.4 | D10 split `{13, 10}`; product formula being replaced |
| `STAGE1_COMPLEX_MAPS` §4, §15.5 | 145 order-0 relations; immune factor; Z⁺ rows |

---

## 1. Phase 1 — shared-μ enumeration

### 1.1 Centre inventory (22 rows → 6 orbits)

| centre | #rows | shared `μ` | period(s) | sealed constraints |
|---|---:|---|---|---|
| C11-points | 4 | `μ` | 11 | `μ ≥ 0` if `d ∈ QR11`, else `μ ≥ 1` |
| C5 orbit (a) | 4 | `μ` | 5 | `μ = 0` open iff `5 ∤ d`; else `5 ∤ μ` |
| C5 orbit (b) | 4 | `μ` | 5 | same |
| D10-points | 2 | `μ₀` | 5 | `μ₀ ≥ 1`, `5 ∤ μ₀` (always base) |
| A4 orbit (a) | 4 | `(μ₁, μ₂)` | `(3, 3)` | `μ₁ ≥ 2`, `μ₂ ≥ 1`; residual by Thm 2.2 |
| A4 orbit (b) | 4 | `(μ₁′, μ₂′)` | `(3, 3)` | same |

Master formula (sealed): `w(R) = d·a_k + Σ μ_l c_l (mod n)`. Truncation of
each `μ_l` at `n / gcd(c_l, n)` is sound. The `μ_l = 0` collapse (all
exceptional strata take `T(p₀)`) is used at C11/C5 when open.

**A4 residual** (`STAGE2_SECOND_ORDER` Thm 2.2):

| `μ₁` | residual per row |
|---:|---:|
| 1 | impossible |
| 2, 4 | 0 (row valueless / `UNDEF`) |
| 3 | 2 (`X^{C6}` excluded) |
| ≥ 5 | 3 |

### 1.2 `F_odd(d mod 330)`

Centres are independent G-orbits, so

```
   F_odd(d)  =  ∏_{centres C}  #{distinct value-subvectors of C at d}
```

under joint `μ`-assignments (sharing ON). Machine-readable per-centre
vector lists: `results/F_odd_factors.json` (keyed by `d mod 165`);
counts: `results/F_odd_counts.json`, `results/F_odd_table.txt`.

**Profile (sharing ON):**

| | value |
|---|---:|
| min | 2 265 760 |
| typical (median) | 2 492 336 |
| max | 58 798 784 |
| **`F_odd(35)`** | **36 252 160** |
| # distinct values across 330 residues | 8 |

At `d = 35` the factors are
`C11:10 × C5a:4 × C5b:4 × D10:4 × A4a:238 × A4b:238`.

`F_odd` is a **union over admissible `μ`**, so it exceeds `3⁸ = 6 561`:
different `μ` realise different weight patterns (different eigenlines), and
the C11/C5 blocks contribute multiple forced patterns rather than the
STAGE2 “factor 1 per residue” residual reading. Both readings are honest;
the product formula used the residual reading.

### 1.3 Sharing-off anchors (STAGE2 §4)

With sharing DISABLED:

* A4 block = `3⁸ = 6 561` at every tested residue;
* C11, C5a, C5b, D10 each contribute a single pattern;
* `F_odd^{off}(d) = 3⁸` for all `d mod 330`;
* Theorem 4.1 consistency: every residue admits a total assignment
  (`F_odd^{off} > 0`); C11 quadruple rule reproduced.

---

## 2. Phase 2 — the global join

### 2.1 Formula

```
   G(d)  =  K(d mod 6)  ·  H_immune_D10(d)
```

where

```
   H_immune_D10(d)
     =  (∏_{C ≠ D10} #patterns(C))
        ·  Σ_{μ₀ ∈ {1,2,3,4}}  D10_branch(μ₀) ,
   D10_branch(μ₀)  =  13  (μ₀ even, E-branch)  or  10  (μ₀ odd, L-branch),
   Σ                          =  46 .
```

> **2026-08-11 director correction (§13):** the branch sum is wrong — the
> range `{1,2,3,4}` truncates the shared `μ₀` at period 5, but `μ₀` feeds
> the pt_D10 values **mod 5** and the C2-line branch parity **mod 2**;
> the joint lattice is mod 10 with eight admissible classes, and the
> correct single-cover sum is **92**. Every `G` value in this document is
> therefore **½ of the corrected count**; the corrected tables are
> `results/G_table_corrected.txt` / `G_counts_corrected.json`
> (`G_corrected(35 mod 330) = 630 352 558 080`). `F_odd` and the
> `vectors_d35.json` deliverable are unaffected (the 22-row vectors see
> `μ₀` only mod 5). See §13 for the audit.

This replaces `D10(μ₁) × 3⁸` by a configuration sum over shared-`μ`
patterns: the D10 C2-line branch is tied to the same `μ₀` that pins the
two `pt_D10` rows (`STAGE1_TIGHTEN` Prop 2.1, centre weight even ⇒ parity
of `μ₀`).

**Trivialized join** (immune+D10 factors set to 1): `G_triv(d) = K(d mod 6)`
— reproduces the corrected stratified table exactly.

### 2.2 `G` table highlights

| `d mod 6` | `K` | role |
|---:|---:|---|
| 0 | 11 068 | even, largest σ-band |
| 1 | 1 178 | odd, repaired |
| 2 | 1 512 | even |
| 3 | 6 216 | odd, repaired |
| 4 | 1 344 | even |
| 5 | **756** | residue of `d = 35` |

| | value |
|---|---:|
| `G` min | 19 698 517 440 |
| `G` typical | 43 336 738 368 |
| `G` max | 7 484 026 825 088 |
| **`G(35 mod 330)`** | **315 176 279 040** |
| zeros of `G` | **none** |
| zeros of `F_odd` | **none** |

At `d = 35`: `K = 756`, `F_odd = 36 252 160`, `H = 416 899 840`,
`G = 756 × 416 899 840 = 315 176 279 040`.
Comparison product `K × 23 × 3⁸ = 114 082 668` is a **different
quantity** (single-`μ` residual reading); see §1.2. Artifacts:
`results/G_counts.json`, `results/G_table.txt`, `results/vectors_d35.json`.

### 2.3 Mechanism diagnostics

How the independent product is reorganised:

1. **Shared `μ` on A4.** Residual still multiplies within a fixed weight
   pattern, but attainable weight 4-tuples are those of a single
   `(μ₁, μ₂)`, and second-order cuts residual to `0`/`2`/`3` by `μ₁`.
2. **Shared `μ₀` on D10.** Branch sum `46` over `{1,2,3,4}` replaces free
   `23` per pattern; per-map only one of `{13, 10}` is open.
3. **C11/C5 `μ`-patterns.** Forced value-vectors range over admissible
   `μ` (factor `> 1` in the union count; factor `1` in the residual
   reading of STAGE2 §4).
4. **Incidence.** See §3.

---

## 3. Incidence lattice and Z⁺

The 145 order-0 closure relations (`STAGE1_COMPLEX_MAPS` §4 / Layer 3)
act on the terminus by forcing shared values along parent/child strata.

**Immune rows (the 22).** By `STAGE1` §15.5 they have the free stratum as
their **only** proper parent. No sweep evaluation reaches them; no closure
relation of the 145 binds an immune-row value to a σ-band value. The join
of Phase-1 vectors with the σ-band is therefore a free product at order 0:

```
   incidence bindings (immune ↔ σ-band)  =  0 .
```

**Z⁺ rows.** The D10 C2-line (dim 1, 330 components, 23 values = 21 points
+ 2 one-parameter families) and the two one-parameter families inside it
sit outside the 43 008 coherent core (`STAGE1` §15.3). Their only new
coupling is the weight-congruence branch split of Prop 2.1, imposed in §2
via shared `μ₀`. No further closure relation of the 145 binds the C2-line
value menu to the immune block beyond that parity.

Corrected σ-band patterns themselves are already coherent under the 145
relations (consumed as the stratified `K` table; not re-enumerated here).

---

## 4. Verification

```sh
python3 scripts/phase1_shared_mu.py   # F_odd, path A/B crosscheck
python3 scripts/phase2_join.py        # G table, d=35 vectors
python3 verifier.py                   # 116 checks, ALLGREEN
```

| group | content |
|---|---|
| **A** | s2pin chain load; PATH A ≡ PATH B (47 736 cases) |
| **B** | sharing-off: A4 `= 3⁸`, C5/C11/D10 single-pattern, at 11 residues |
| **C** | Thm 4.1 sharing-off consistency; C11 quadruple rule |
| **D** | second-order residual table; D10 branch sum 46; UNDEF pattern |
| **E** | trivialized join `= K`; `G = K·H`; `G(35)`; no zeros; artifacts |
| **F** | cross-prime identity of `K`; prime-free determinism of `F_odd`/`G` |
| **G** | centre inventory and truncation periods |

---

## 5. Honesty tiering

**Tier 1 — exact, prime-free.** Master weight formula; centre inventory;
sharing-off `3⁸` arithmetic; D10 branch parity from `μ₀`; free-product
structure of coherence-immune rows with the σ-band; `G = K · H` as a
finite integer identity.

**Tier 2 — finite exact computation.** `F_odd` and `G` tables mod 330;
second-order residual counts; path A/B crosscheck; corrected `K` consumed
from the two-prime stratified seal.

**Tier 3 — flagged.**

1. A4 residual for `μ₁ > 5` uses residual `3` (sealed only through `μ = 5`;
   `STAGE2_SECOND_ORDER` Tier 3.1).
2. `F_odd` is a **union-over-`μ`** count, not the single-`μ` residual factor
   `3⁸` of STAGE2 §4; compare carefully when consuming in the pair attack.
3. σ-band patterns are not re-enumerated; `K` is consumed from
   `STAGE1_STRATIFIED` (itself Tier 2 there).
4. Map-level only: a hypothetical future `G(ρ) = 0` would not feed
   tuple-level transport without the `Φ_J`-closure upgrade.

---

## 6. Not claimed

* No headline. **Problem E remains OPEN; this packet excludes no degree.**
* No residue has `G = 0` or `F_odd = 0`; nothing is flagged for exclusion.
* No transport-pairing claim (`theory/EXCLUSION_TRANSPORT_20260811.md` §6).
* No claim that a landing covariant exists at any degree.
* No claim that every enumerated value-vector is realised by a global map —
  only that if a reduced lift exists, its immune values and D10 branch lie
  among the tabulated patterns.
* No re-derivation of the sealed sweeps `d ≤ 30` empty or `d = 25` dead.

---

## 7. Dependencies

| import | grade |
|---|---|
| `STAGE2_ODD_ORDER_PINNING` (s2pin, Thm 1.2, §4) | chain data and both `w(R)` paths **reused**, not rewritten |
| `STAGE2_SECOND_ORDER` (A4 jet table) | residual counts consumed |
| `STAGE1_STRATIFIED` (corrected `K`) | consumed; two-prime seal cited |
| `STAGE1_TIGHTEN` §2.3–2.4 | D10 split, product formula |
| `STAGE1_COMPLEX_MAPS` §4, §15.5 | incidence, immune, Z⁺ |

## 8. Named remainders

1. Pair attack at `d = 35` consumes `G(35)` / the factorised vectors
   (`WORKORDER_PAIR_ATTACK_D35`).
2. Whether a finer lattice than mod 330 is forced by higher-order jets.
3. Fully stratified non-full-flag σ-band rows (Tier-3 of STRATIFIED) may
   still raise `K`.
4. Algebraisation of the enumerated patterns to actual maps (Stage 2+).

## 13. Director adjudication (2026-08-11, appended before sealing)

1. **Located error — the D10 branch sum.** `admissible_mus_D10() =
   [1,2,3,4]` (`scripts/centers.py`) truncates at period 5, but `μ₀` feeds
   two moduli (pt_D10 values mod 5; C2-line branch parity mod 2): the
   joint lattice is mod 10, eight admissible classes. On `{1,2,3,4}` the
   parity is a function of the mod-5 class, locking branch to residue; the
   classes `{6,7,8,9}` realize the four complementary (mod-5, parity)
   pairs. The packet's own phase-2 `incidence_note` states both parities
   are attainable via `μ₀ ↦ μ₀+5` — the formula contradicted its own
   note. Correct single-cover sum: **92**; every `G` in this document is
   half the corrected value, uniformly (all 330 residues).
2. **Semantics note found by the audit.** `H` sums branch MENU SIZES over
   the enumerated `μ₀` list rather than taking a union over distinct
   joint classes; on any single cover the two agree (each class once),
   which is why `{1,2,3,4}` was internally consistent. The audit
   criterion is therefore cover-independence, verified both ways:
   two disjoint single covers agree exactly, and a double cover gives
   exactly `2×`.
3. **The audit instrument.** `scripts/director_range_audit.py`: re-runs
   both phases under range extensions; asserts (i) `F_odd` invariant
   under all extensions (mod-5 collapse of the 22-row vectors — so
   `vectors_d35.json`, consumed by the pair attack, is unaffected);
   (ii) cover-independence and the exact-`2×` double-cover behavior;
   (iii) the correction is exactly `×2` on every residue;
   (iv) the A4 (`{2..8}×{1..3} → {2..11}×{1..6}`), C5 and C11
   truncations are adequate (counts invariant). Output:
   `results/G_table_corrected.txt`, `G_counts_corrected.json`.
   **`G_corrected(35 mod 330) = 630 352 558 080`**; corrected min/max
   over residues `3.94 × 10¹⁰ / 1.50 × 10¹³`; still **no zeros**, so no
   exclusion arises and the map-level framing of §D stands unchanged.
4. **What survives untouched.** Phase 1 in full (`F_odd`, the value
   vectors, the sharing-off anchors `3⁸`, Theorem 4.1 reproduction), the
   trivialized-join anchor (= corrected `K` table), the s2pin two-path
   weight replay, and the union-over-`μ` reinterpretation of the immune
   factor — which is the packet's real content: the old
   `K × D10 × 3⁸` was a fixed-`μ` snapshot, not an upper bound.
5. **Director replay:** `python3 verifier.py` from a clean shell — 116
   checks, 0 failures (`GLOBAL_COHERENCE_VERIFY_OK` / `ALLGREEN`);
   note the verifier tests the worker's formula against its own tables,
   so it is green on both the original and the corrected semantics; the
   correction is carried by the audit script and this section.
