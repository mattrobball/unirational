# Cross-prime of the director cone-ladder at p=661

**Packet:** `goal_runs_20260812/CONE_CROSSPRIME/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Independent reproduction, at `p = 661`, of the director's single-prime
(`p = 331`) cone-ladder measurements on the sealed 37-cell at `d = 35`.
Sections are freshly drawn (packet seeds, not the director stream and not
`CONE_LADDER_D35`). The `m = 20` msolve rung uses the **full** restricted
span (1380 generators), never a subset.

Machine markers: `CONE_CROSSPRIME_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py`).

## Exit ledger

```text
CONE-CROSSPRIME-CELL-P3-REPRODUCED
CONE-CROSSPRIME-RANKS-AGREE
CONE-CROSSPRIME-FREE-M19
CONE-CROSSPRIME-M20-FULLSPAN
CONE-CROSSPRIME-NO-PRIME-DEPENDENCE
CONE-CROSSPRIME-NO-DEGREE-EXCLUSION
```

---

## 0. What is and is not claimed

**Claimed (modular).** The sealed 37-cell and `P3 = 1380` reproduce at
`p = 661`. On independently drawn generic sections, restricted landing
cubics have the same ranks as the director's `p = 331` table. Free rungs
`m = 6, 8, 10, 18, 19` fill `Sym³(L)`, so `V ∩ L = {0}` and
`dim V ≤ 18`. Full-span `msolve -g 1 -t 2` at `m = 20` has a pure power
of every section variable, so that section is zero-dimensional and
`dim V ≤ 17` over `F_661`. No prime-dependence was observed.

**Not claimed.** Emptiness of `V`. Any characteristic-zero Nullstellensatz
on the 37-cell. Any degree exclusion. The unrestricted `m = 37` system.

---

## 1. Method

Sealed inputs (read-only):
`goal_runs_20260811/PAIR_ATTACK_D35/results/layer0_null_p661.npy` and
`worked_example_p661.json` (`universal_matrix_6x39`); seeds
`layer0_A_p331.npy` / `layer0_C_p331.npy` (prime-independent). Engine:
`D34_GUIDED_SWEEP/slicelib`. Cubic expansion as in
`director_probes_20260812/{cone_dimension,section_deficiency}_probe.py`.

Packet seeds (independent of the director and of `CONE_LADDER_D35`):
point seed `661350035`; section seed `661082012 + 10007·m`.

Sample ≥ 1.4× the expected span, take an independent basis, feed **all**
of it. Spec §0: a subset is correct (`V(subset) ⊇ V`) and much more
expensive. This packet never subsets. `msolve -g 1 -t 2` only.

Zero-dimensionality: every variable has a pure power among the leading
monomials. Homogeneous ⇒ `V ∩ L = {0}` ⇒ `dim V ≤ 37 − m`.

---

## 2. Anchors at p=661

| check | p=661 |
|---|:---:|
| cell shape | 37 × 637 |
| six-flip rank (`rank U`) | 2 |
| `dim_universal` in worked example | 37 |
| `P3` (1971 samples) | **1380** |

---

## 3. Restricted ranks (independent sections)

Director table is `p = 331`. This packet is `p = 661`.

| m | dim Sym³(L) | director 331 | this 661 | HF_L(3) | generic |
|--:|------------:|-------------:|---------:|--------:|--------:|
| 6 | 56 | 56 (full) | **56** | 0 | 56 |
| 8 | 120 | 120 (full) | **120** | 0 | 120 |
| 10 | 220 | 220 (full) | **220** | 0 | 220 |
| 18 | 1140 | 1140 (full) | **1140** | 0 | 1140 |
| 19 | 1330 | 1330 (full) | **1330** | 0 | 1330 |
| 20 | 1540 | 1380 | **1380** | 160 | 1380 |
| 22 | 2024 | 1380 | **1380** | 644 | 1380 |

Free rungs: `V ∩ L = {0}` at `m = 19` ⇒ `dim V ≤ 18`. No structural
deficiency: from `m = 20` the restriction is injective on the global
span.

---

## 4. The m=20 rung (full span)

**Director artefact** (`director_probes_20260812/cone_m20_lead.out`,
240 generators, a subset, `p = 331`): 11 201 leading monomials; pure
powers with exponents `(3×10, 4×5, 5×5)`; zero-dimensional;
`dim V ≤ 17`. Re-parsed in this packet.

**This packet, full span (1380 generators), `p = 661`, 2 threads:**
`nlead = 1540`; pure powers `t1…t19³`, `t20⁴`; 8.9 s; `ZERO_DIM`;
`dim V ≤ 17`.

The staircase exponents differ (independent section; full span vs a
240-gen subset). Zero-dimensionality agrees. That is not prime-dependence.

---

## 5. Prime-dependence

None observed. Every director rank, every `HF_L(3)`, and the `m = 20`
zero-dimensionality verdict agree at `p = 661` on independently drawn
sections. Cross-prime agreement is the campaign's standard evidence
class; a disagreement would have been a serious finding and is not
present.

The bound `dim V ≤ 17` is modular (`F_661` section + leading ideal).
It does **not** exclude `d = 35`.

---

## 6. Honesty

| tier | content |
|---|---|
| `[T2]` machine-verified modular | cell dim 37; `P3=1380`; free-span ranks; leading-ideal pure-power test |
| `[T2]` two-prime | ranks and `m=20` zero-dim agree with director `p=331` |
| `[EXT]` none | no external CAS beyond python3 + msolve |

Char-0 scope: a full-rank Macaulay matrix mod `p` is full rank over `Q`
for that specific system. The section `L` is chosen over `F_p`, so the
bound is stated as modular. No exclusion is claimed, so no ODDZERO
adversarial audit is triggered.

---

## 7. Replay

```text
python3 scripts/produce.py
python3 verifier.py
python3 verifier.py --live    # rebuilds the 37-cell at p=661
```

Never gap / gp / sage / magma. Heavy `.ms` / `.out` files live in
`results/` and may be regenerated from `scripts/produce.py`; JSON
ledgers are the small record.

---

## 8. Not claimed

- `V = {0}`
- any bound on `dim V` in characteristic zero as a sealed theorem
- any exclusion of degree 35 or any other degree
- the unrestricted 37-variable system
- any dominance / Jacobian statement
- any `d ≠ 35` statement
