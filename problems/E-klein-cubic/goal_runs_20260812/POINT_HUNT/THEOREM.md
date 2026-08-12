# Point hunt on the d=35 landing cone (contingency if V is nonempty)

**Packet:** `goal_runs_20260812/POINT_HUNT/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Insurance lane for the cone-dimension swarm. The sibling ladder
(`CONE_LADDER_D35`) bounds `dim V ≤ 9` (modular, `m = 28` zero-dimensional
at both primes). Emptiness of `V` would close `d = 35`. If `V` is *not*
empty, every nonzero point is a candidate landing tuple, and the campaign
question becomes dominance. This packet is the extraction + Jacobian
pipeline for that case.

Machine markers: `POINT_HUNT_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py`).

## Exit ledger

```text
POINT-HUNT-SELFTEST
POINT-HUNT-CELL-P3-REPRODUCED
POINT-HUNT-JACOBIAN-EULER-CONTROL
POINT-HUNT-FULLSPAN-EXTRACT
POINT-HUNT-DOMINANCE-OR-INFEASIBLE
POINT-HUNT-NO-DEGREE-EXCLUSION
```

---

## 0. What is and is not claimed

**Claimed (modular).** The 37-cell and `P3 = 1380` reproduce the sealed
record. The director Jacobian probe is reproduced: generic cell members
have rank `5` and the Euler identity `J(w)·w = 35·T(w)` holds exactly
(fatal if it fails). A synthetic msolve self-test recovers a planted
line, an empty chart, and a positive-dimensional marker. On each
attempted section the restricted landing system uses the **full** cubic
span (never a subset). Extraction is by affine chart + msolve solving
over `F_p`. Any recovered point is scored by an independent landing
check `F(T_c(x)) ≡ 0` at sample `x` and by generic Jacobian rank.

**Not claimed.** Emptiness of `V`. Any degree exclusion. Any
characteristic-zero Nullstellensatz. Dominance of a map that was not
actually extracted. A rank-`≤ 3` point is recorded as not dominant and
does **not** answer the headline positively.

---

## 1. Method

`V = {c : F(T_c(x)) ≡ 0 in x}` inside the sealed 37-cell. A generic
`m`-plane `L` meets `V` in a cone of dimension `max(0, dim V + m − 37)`.
Sibling bound `dim V ≤ 9` implies a generic `L` with `m ≤ 28` has
`V ∩ L = {0}`. The first section that can contain a nonzero point, if
the bound is sharp, is `m = 29` (expected: a line). Larger `m` is used
only if it terminates inside the resource cap.

Generators: each sample `x` gives one cubic in the section parameters
via `F = ∑_k y_k² y_{k+1}` on `T_{c(t)}(x)` — the director expansion.
Sample `≥ 1.4×` the expected span, take an independent basis, feed
**all** of it (`DATA_SPEC_CONE_SWARM_20260812` §0). A subset is correct
for emptiness proofs (`V(subset) ⊇ V`) and the wrong cost model; it is
also the wrong hunt (extra components that are not on `V`).

Extraction, when `V ∩ L` is not zero-dimensional:

1. Dehomogenize a chart `t_i = 1` (an affine hyperplane, not through
   the origin). A 1-dimensional cone meets a generic chart in finitely
   many points.
2. If msolve reports infinitely many solutions, add further random
   affine linear cuts and retry.
3. Parse the prime-field rational parametrization; keep `F_p`-points.
4. Reject any point at which the full restricted span does not vanish.
5. Lift `t ↦ c = t·S ↦ vec = c·B_{37}` and test landing independently
   by evaluating `F(T_c(x))` at fresh sample points.
6. Dominance: 5×5 Jacobian of `T` at generic `w`, same implementation
   as `director_probes_20260812/jacobian_rank_probe.py`. Euler
   `J(w)·w = 35·T(w)` is fatal. Generic rank `≤ 3` is not dominant onto
   the 3-fold.

Resource cap (director jobs live): `msolve -t 2`, RSS kill at 7 GiB.

Heavy `.ms` / `.out` files in `results/` are regenerable
(`python3 scripts/produce_hunt.py emit` / `extract`) and may exceed the
50 MB hosting limit.

---

## 2. Anchors

Recorded in `results/p3_p331.json`, `results/jac_control_p331.json`,
`results/selftest.json` (and `p=661` when that emit ran).

| check | expect |
|---|---|
| cell | 37 × 637 |
| six-flip rank `U` | 2 |
| `P3` | 1380 |
| selftest | planted line `(0,0,1)`; empty `[-1]:`; positive-dim `[1,n,-1,[]]` |
| generic cell Jacobian | rank 5, Euler exact |

---

## 3. Hunt results

See `results/summary.json` and `results/hunt_m29_p{331,661}.json`.

**Anchors (both primes).** Cell `37 × 637`, `rank U = 2`, `P3 = 1380`.
Self-test recovers the planted line, `[-1]:`, and positive-dimension.
Generic cell Jacobian rank `5`, Euler exact (3 trials each prime).

**`m = 19`.** Free: rank `1330 / 1330` both primes. Only the origin.

**`m = 20` (extraction control).** Full span 1380. Affine chart `t1=1`
empty (`p=331`: three charts, ~10 s, 289 MB; `p=661`: 3.0 s).
Homogeneous `-g 1` at `p=331` is zero-dimensional (11.8 s). No nonzero
point.

**`m = 29` (first section that can meet a 9-dimensional cone).**
Full span 1380 generators, never a subset.

| prime | step | verdict | time | peak RSS |
|------:|---|---|---:|---:|
| 331 | chart `t1=1` | `EMPTY_CHART` (unit ideal) | 641 s | 6.4 GiB |
| 331 | slice `t1=0` (`-g 1`, 28 vars) | `ZERO_DIM` (13110 leads; `t1..t19³`, `t20..t28⁴`) | 298 s | 7.3 GiB |
| 331 | homogeneous `-g 1` on 29 vars | `NO_VERDICT_MEMORY` (not needed once chart+slice close) | 544 s | killed ~7.1 GiB |
| 661 | chart `t1=1` | `EMPTY_CHART` | 479 s | 5.9 GiB |
| 661 | slice `t1=0` (`-g 1`, 28 vars) | `NO_VERDICT_MEMORY` (8.2 GiB) | 341 s | killed |
| 661 | chart `t1=0`, `t2=1` | `EMPTY_CHART` | 390 s | 4.6 GiB |
| 661 | slice `t1=t2=0` (`-g 1`, 27 vars) | `ZERO_DIM` (10430 leads, no missing pure powers) | 361 s | 5.9 GiB |

At both primes: `V ∩ L = {0}` on this packet’s independent `m=29`
section. **No F_p-point extracted. No dominance verdict to issue.**

**`m = 30` (infeasible).** Emitted at `p=331` (full span 1380 / 4960,
98.6 MB). Affine chart `t1=1` was killed at 544 s / 8.10 GiB
(`NO_VERDICT_MEMORY`). **Extraction becomes infeasible at section
dimension 30** under the 2-thread / 8 GB cap. No point, and no emptiness
certificate, is claimed at this `m`.

**Infeasible instrument.** Direct `msolve -g 1` on the 29-variable
homogeneous system (and the 28-variable slice at `p=661`) exceeds the
8 GB cap. Point extraction uses affine charts, which stayed inside the
cap through `m=29`.

These are modular statements about specific `F_p`-sections. They do not
prove `V = {0}` and they do not exclude `d = 35`.

---

## 4. Honesty

| tier | content |
|---|---|
| `[T2]` machine-verified modular | cell; `P3`; Euler identity; Jacobian ranks; msolve parses |
| `[T2]` two-prime | `P3`, Jacobian/Euler, `m=19` free, `m=20` empty charts, `m=29` `V ∩ L = {0}` |
| `[EXT]` none | python3 + msolve only |

Char-0 scope: a found `F_p`-point is an `F_p`-point. It does not by
itself give a characteristic-zero landing map. No exclusion is claimed,
so no ODDZERO adversarial audit is triggered.

---

## 5. Replay

```text
python3 scripts/produce_hunt.py selftest
python3 scripts/produce_hunt.py emit --p 331 --ms 19,20,29
python3 scripts/produce_hunt.py jac-control --p 331
python3 scripts/produce_hunt.py extract --p 331 --m 20 --t 2 --charts 1
python3 scripts/produce_hunt.py extract --p 331 --m 29 --t 2 --charts 1
python3 scripts/produce_hunt.py slice --p 331 --m 29 --t 2
python3 scripts/produce_hunt.py extract --p 331 --m 30 --t 2 --timeout 900 --charts 1
python3 verifier.py
python3 verifier.py --live
```

Never gap / gp / sage / magma.

---

## 6. Not claimed

- `V = {0}`, or any bound on `dim V` (that is the sibling ladder)
- any exclusion of degree 35 or any other degree
- dominance of the generic cell (director rank 5 is a control, not a
  landing point)
- any point that failed the landing residual or the Euler identity
- characteristic-zero existence of a landing tuple
