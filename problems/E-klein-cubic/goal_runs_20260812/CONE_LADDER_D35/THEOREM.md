# Section ladder for the d=35 landing cone

**Packet:** `goal_runs_20260812/CONE_LADDER_D35/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Lane 1 of `DATA_SPEC_CONE_SWARM_20260812.md`. The landing cone is
`V = {c : F(T_c(x)) ≡ 0}` inside the sealed 37-cell. A generic `m`-plane
`L` with `V ∩ L = {0}` proves `dim V ≤ 37 − m`. Free rungs fill all of
`Sym³(L)`; later rungs use `msolve -g 1` on the **full** restricted cubic
span (never a subset — §0 of the spec).

Machine markers: `CONE_LADDER_D35_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py`).

## Exit ledger

```text
CONE-LADDER-D35-CELL-P3-REPRODUCED
CONE-LADDER-D35-FREE-M19
CONE-LADDER-D35-M20-CONTROL
CONE-LADDER-D35-FULLSPAN-MSOLVE
CONE-LADDER-D35-TIGHTEST-BOUND
CONE-LADDER-D35-NO-DEGREE-EXCLUSION
```

---

## 0. What is and is not claimed

**Claimed (modular, two-prime where marked).** The 37-cell and `P3 = 1380`
reproduce the sealed record at `p = 331` and `p = 661`. Restricted cubics
fill `Sym³(L)` at `m = 18, 19` (both primes), so `V ∩ L = {0}` and
`dim V ≤ 18`. Full-span `msolve -g 1` leading ideals contain a pure power
of every section variable at the rungs tabulated below, so those sections
are zero-dimensional and the bound tightens to `dim V ≤ 37 − m`.

**Not claimed.** Emptiness of `V`. Any characteristic-zero Nullstellensatz
on the 37-cell. Any degree exclusion. The unrestricted `m = 37` system
(the director's 16-thread job; not this packet).

---

## 1. Method (the counterintuitive generator rule)

Each sample point `x` gives one cubic in the section parameters via
`F = ∑_k y_k² y_{k+1}` on `T_{c(t)}(x)` — the expansion in
`director_probes_20260812/cone_dimension_probe.py` and
`section_deficiency_probe.py`, reused here. Sample ≥ 1.4× the expected
span, take an independent basis, feed **all** of it.

Degree of regularity on the full 37-cell (director, spec §0):

| # generators | dreg | Macaulay columns |
|------------:|-----:|-----------------:|
| 55 | 21 | ~10¹⁵ |
| 520 | 7 | ~32×10⁶ |
| 1380 (full `P3`) | 5 | 749 398 |

A small subset is correct (`V(subset) ⊇ V`) and ruinously more expensive.
This packet never subsets.

Zero-dimensionality: `msolve -g 1 -t 4`; every variable has a pure power
among the leading monomials. Homogeneous ⇒ `V ∩ L = {0}`. Threads 4;
memory watched against the director's 16-thread job.

---

## 2. Anchors reproduced

| check | p=331 | p=661 |
|---|:---:|:---:|
| cell shape | 37 × 637 | 37 × 637 |
| six-flip rank (`rank U`) | 2 | 2 |
| `P3` (1971 samples) | **1380** | **1380** |
| `m=18` rank / `C(20,3)=1140` | 1140 / FREE | 1140 / FREE |
| `m=19` rank / `C(21,3)=1330` | 1330 / FREE | 1330 / FREE |

Cell from `PAIR_ATTACK_D35/results/layer0_null_p{p}.npy` and
`worked_example_p{p}.json` (`universal_matrix_6x39`). Seeds
`layer0_A_p331.npy` / `layer0_C_p331.npy` (prime-independent).
No structural deficiency: from `m = 20` on, rank is exactly 1380
(`HF_L(3) = C(m+2,3) − 1380`), matching the director's table.

Free rungs: `dim V ≤ 19` from `m = 18`, `dim V ≤ 18` from `m = 19`.

---

## 3. Control: `m = 20`

**Director artefact** (`director_probes_20260812/cone_m20_lead.out`,
240 generators, a subset): 11 201 leading monomials; pure powers
`(3×10, 4×5, 5×5)`; zero-dimensional; `dim V ≤ 17`. Re-parsed in this
packet.

**This packet, full span (1380 generators):**

| prime | nlead | pure powers | time | bound |
|------:|------:|---|------:|------:|
| 331 | 1540 | `t1..t19³`, `t20⁴` | 2.42 s | ≤ 17 |
| 661 | 1540 | `t1..t19³`, `t20⁴` | 2.75 s | ≤ 17 |

Full span is two orders of magnitude faster than the 240-gen subset
(director dreg 5 vs a larger staircase). Control cleared at both primes.

---

## 4. Ladder (full restricted span, 1380 generators)

| m | 37−m | p=331 | p=661 | max F4 matrix (331) | time 331 |
|--:|-----:|---|---|---|---:|
| 18 | 19 | FREE | FREE | — | — |
| 19 | 18 | FREE | FREE | — | — |
| 20 | 17 | ZERO_DIM | ZERO_DIM | 27599 × 8854 | 2.4 s |
| 22 | 15 | ZERO_DIM | ZERO_DIM | 30359 × 12649 | 7.2 s |
| 24 | 13 | ZERO_DIM | ZERO_DIM | 99840 × 27156 | 22.8 s |
| 28 | 9 | ZERO_DIM | ZERO_DIM | 388920 × 100272 | 160 s |
| 32 | 5 | **NO VERDICT** | not run | deg 4: 44159 × 52359 in 1755 s; deg 5 opened 493128 pairs | killed at 13.6 GB |

A rung with no finished leading ideal is **no verdict**, not a guess.
`m = 32` was stopped at the start of the degree-5 F4 round (RSS 13.6 GB)
to stay under the 15 GB cap. `m = 34, 36` systems were emitted at p=331
and were not solved.

Leading-ideal files: `results/cone_m{m}_p{p}_lead.out`.
Inputs: `results/cone_m{m}_p{p}.ms` (regenerate via
`python3 scripts/produce_ladder.py emit --p P --ms …`).

---

## 5. Tightest proven bound

**Tightest proven bound: `dim V ≤ 9`** (two-prime: `m = 28` at 331 and 661).

Recorded in `results/summary.json`. Modular (generic `F_p`-section;
Macaulay rank lifts, the section itself is modular). Does **not** exclude
`d = 35`. `m = 32` has no verdict.

---

## 6. Honesty

| tier | content |
|---|---|
| `[T2]` machine-verified modular | cell dim 37; `P3=1380`; free-span ranks; leading-ideal pure-power tests |
| `[T2]` two-prime | every FREE or ZERO_DIM rung marked both-prime in §4 |
| `[EXT]` none | no external CAS beyond python3 + msolve |

Char-0 scope: a full-rank Macaulay matrix mod `p` is full rank over `Q`
for that specific system. The section `L` is chosen over `F_p`, so the
bound is stated as modular. No exclusion is claimed, so no ODDZERO
adversarial audit is triggered.

---

## 7. Replay

```text
python3 scripts/produce_ladder.py director-control
python3 scripts/produce_ladder.py emit --p 331 --ms 18,19,20,22,24,28,32
python3 scripts/produce_ladder.py solve --p 331 --m 20 --t 4
python3 verifier.py
python3 verifier.py --live    # rebuilds the 37-cell at p=331
```

Never gap / gp / sage / magma. Heavy `.ms` / `.out` files live in
`results/` and may be regenerated; JSON ledgers are the small record.

---

## 8. Not claimed

- `V = {0}`
- any bound on `dim V` in characteristic zero as a sealed theorem
- any exclusion of degree 35 or any other degree
- the unrestricted 37-variable system
- any dominance / Jacobian statement (Lane 3)
- any `d = 36` statement (Lane 2)
