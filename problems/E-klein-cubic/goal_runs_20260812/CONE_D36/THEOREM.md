# The landing cone at d = 36

**Packet:** `goal_runs_20260812/CONE_D36/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

The cone instrument of `director_probes_20260812/` (section ladder: a
generic `m`-plane `L` with `V ∩ L = {0}` proves `dim V ≤ N − m`) is run
at `d = 36` on the QR-cut window cell. Generators are the **full**
restricted span of landing cubics — never a subset. **No degree is
excluded.**

Machine markers: `CONE_D36_VERIFY_OK` / `ALLGREEN` (`python3 verifier.py`).

## Exit ledger

```text
CONE-D36-CELL62-REPRODUCED
CONE-D36-P3-1850-REPRODUCED
CONE-D36-FREE-M21
CONE-D36-MSOLVE-CLEARED
CONE-D36-NO-DEGREE-EXCLUSION
```

---

## 0. Object

`N = 62` is the Layer-0 `(1,6)` cell at `d = 36` after the sealed
60-point C11 cut (`QR_POINT_CUTS`). Even degree: six-flip is idle.
`V = {c ∈ 62-cell : F(T_c(x)) ≡ 0}` is a cone. Each sample `x` gives
one cubic in the cell (or section) parameters.

Bounding rule: `dim(V ∩ L) = max(0, dim V + m − N)` for generic
`m`-dimensional `L`. `V ∩ L = {0}` ⇒ `dim V ≤ 62 − m`.

Counterintuitive generator rule (mandatory): feed the **full**
restricted span. Degree of regularity falls as the number of cubics
rises (director table at `d = 35`, `n = 37`: 55 gens → deg 21; 520 →
deg 7; 1380 → deg 5, 749398 columns).

---

## 1. Fatal anchors (both primes)

| check | p=331 | p=661 |
|---|---:|---:|
| Layer-0 cell | **63** | **63** |
| C11-point rank / sat | **1** / yes | **1** / yes |
| post-cut dim | **62** | **62** |
| P3 on 63-cell (sealed 1850) | **1850** sat | **1850** sat |
| P3 on 62-cell | **1835** sat | **1835** sat |

Both fatal anchors reproduce. The 15-dimensional drop 1850 → 1835 on
the hyperplane is the only new P3 number; free-rung combinatorics still
permit `m ≤ 21` (`C(23,3) = 1771 ≤ 1835 < 2024 = C(24,3)`).

---

## 2. Free rungs (no Gröbner)

Restricted cubics span **all** of `Sym³(L)` at `m = 16, 18, 19, 20, 21`
at both primes. In particular every `t_i³` is in the restricted ideal,
so `V ∩ L = {0}`. Full rank mod `p` is full rank over `Q`.

> **dim V ≤ 41** (free, `m = 21`, both primes).

At `m = 22`, rank = 1835 = P3(62) `< 2024` — first non-free rung,
exactly the generic-cap prediction.

---

## 3. msolve rungs (`-g 1`, full span, `-t 4`)

Zero-dimensionality: every section variable has a pure power among the
leading monomials.

| m | gens | p=331 | p=661 | bound |
|--:|-----:|:-----:|:-----:|------:|
| 22 | 1835 | cleared (~6s) | cleared (~21s) | ≤ 40 |
| 24 | 1835 | cleared (~18s) | cleared (~37s) | ≤ 38 |
| 28 | 1835 | cleared (~174s) | cleared (~263s) | ≤ 34 |
| 30 | 1835 | cleared (~511s) | cleared (~406s) | ≤ 32 |
| 32 | 1835 | **timeout 1200s** — no verdict | — | — |

> **Tightest proven bound: dim V ≤ 32** (`m = 30`, full span,
> leading ideal zero-dimensional at both primes).

`m = 32` did not terminate in the 1200s budget; no guess.

---

## 4. Honesty tiering

**Tier 1 — two-prime modular linear algebra, char-0 on zeros.**
Cell dims 63/62, C11 rank 1, P3(63)=1850, P3(62)=1835, free rungs
through `m = 21`.

**Tier 2 — modular Gröbner, leading ideal.** msolve `-g 1` over `F_p`.
`m = 22, 24, 28, 30` agree at both primes. Tightest bound is `m = 30`.

**Tier 3 — flagged / not claimed.**
No emptiness of `V`. No degree exclusion. `m = 32` is a timeout, not
a positive-dimensional reading.

---

## 5. Not claimed

* That `d = 36` is closed, or that `V = {0}`.
* Any characteristic-zero Nullstellensatz on the 62-cell.
* A lower bound on `dim V`.
* That the `m = 32` timeout would fail or succeed given more time.
* **Problem E remains OPEN; this packet excludes no degree.**

---

## 6. Replay

```bash
cd goal_runs_20260812/CONE_D36
python3 verifier.py
# python3 scripts/produce.py 331 anchors
# python3 scripts/produce.py 331 free
# python3 scripts/produce.py 331 msolve 22,24,28
# python3 scripts/compile_summary.py
```

Heavy `*.npy` / `*.ms` / `*_lead.out` are regenerable (50 MB hosting
limit). msolve always `-t 4`.

## 7. Dependencies

| import | role |
|---|---|
| `goal_runs_20260811/D34_GUIDED_SWEEP` | Layer-0 engine |
| `goal_runs_20260812/LANDING_SWEEP` | cell recipe |
| `goal_runs_20260812/QR_POINT_CUTS` | C11 cut, fatal 62 |
| `goal_runs_20260812/LANDING_INVARIANT_SIDE` | sealed P3(36)=1850 |
| `director_probes_20260812` | cubic expansion, cone rule |
