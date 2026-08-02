# Wave 2026-08-02 status (medium-CAS chart inventory)

**Packet exit:** `COV-UNDECIDED` (unchanged; packet `SEAL.json` **not** re-sealed).  
**Headline:** OPEN.  
**No claim of `COV-DEGREE-EMPTY` or any scoped full-degree emptiness.**

## Transfer limitation (binding)

**Modular Groebner basis `[1]` over a prime field does not transfer to
characteristic zero without a proper-specialization / integral-model theorem.**

All affine chart kernels and eliminated systems below are fibre-specific
(built at `p=463`). Linear gate ranks that agree at `463` and `727` give
characteristic-zero *upper bounds* on dimensions only.

---

## Residual chart counts (char-0 cover, from sealed STATUS.md)

| Family | d31 | d35 | kernel dim |
|---|---:|---:|---:|
| C3-nonbased | 10 | 12 | 187 / 348 |
| First-normal tangent-reduced | 15 | 9 | 137 / 266 |
| Pure second-normal | 7 | 24 | 99 / 247 |
| Mixed second tangent-reduced | 9 | 16 | 45 / 156 |
| Pure third-normal | 6 | 31 | 36 / 140 |
| Mixed-third tangent-reduced | — | 9 | 39 |
| **Totals** | **47** | **101** | **148** |

Deep projective tails: sealed empty (35/35 cubic span).

---

## Wave modular CAS results

### Primary: d35 mixed-third quadratic charts (all 9) over `F_463`

| Chart | Vars | Eqns | Unit GB | Elapsed | Max RSS | Role |
|---:|---:|---:|---|---:|---:|---|
| 0 | 38 | 137 | **[1]** | 799.6 s (replay) | ~5.0 GiB | independent msolve replay + prior WORK |
| 1 | 38 | 137 | **[1]** | (prior) | — | WORK twin / wave hardlink |
| 2 | 38 | 137 | **[1]** | 649.1 s | ~4.9 GiB | **new this wave** |
| 3 | 38 | 137 | **[1]** | 649.5 s | ~4.6 GiB | **new this wave** |
| 4 | 38 | 137 | **[1]** | 611.1 s | ~4.6 GiB | **new this wave** |
| 5 | 38 | 137 | **[1]** | 611.4 s | ~4.9 GiB | **new this wave** |
| 6 | 38 | 137 | **[1]** | 614.9 s | ~4.6 GiB | **new this wave** |
| 7 | 38 | 137 | **[1]** | 609.4 s | ~4.6 GiB | **new this wave** |
| 8 | 38 | 137 | **[1]** | 614.3 s | ~4.6 GiB | **new this wave** |

Record: `d35_mixed_third_quadratic_msolve.json`.

**Independent verifier:** msolve full replay of chart 0 → unit `[1]` (PASS).  
Singular `std` on chart 0: killed after ~45 min with no output (not a certificate).  
**Holdout prime emptiness:** not rebuilt; linear tangent-gate ranks already agree
at 463/727 in the sealed packet.

**Scope of claim:** special-fibre emptiness of the nine tangent-reduced mixed-third
nonbased charts over `F_463` only. **Does not close the char-0 branch.**

### Catalogued (not re-run) smaller d31 pure-third screens

- Sealed packet: charts 0,1 unit over `F_463` (special-fibre only).  
- WORK twin residual affine original charts **4,5** unit (hardlinked into wave).  
- Residual affine original charts **2,3** and vandermonde chart **2**: incomplete
  (0-byte outs from prior timeouts).

### Resource note

msolve peak RSS per d35 chart was ~4.6–5.3 GiB (soft over the ~4 GiB wave
target). Wall time ~10–13 min/chart. Prefer serial charts; do not run many in
parallel under the RSS cap.

---

## Still open (char-0) — recommended next attack

1. **Next:** `d31` pure-third residual affine **chart 3** (32 vars after elim,
   ~107 MB cubic input) with prepare+seal and hard wall-clock timeout.  
2. Then residual chart **2** (33 vars).  
3. Optionally rebuild the now-complete d35 mixed-third systems at holdout prime
   `727` (still special-fibre evidence only).  
4. Then d31 mixed-second tangent charts (9 charts, ≤45 vars).  
5. Large covers (C3-nonbased, first-normal, pure-second, d35 pure-third) remain
   heavy multi-hour targets.

---

## Artifacts under `wave_20260802/`

- `CHART_ATTACK_PLAN.md` — inventory, sizes, primes, protocol  
- `MODULAR_RESULTS.json` — summary inventory v2  
- `d35_mixed_third_quadratic_msolve.json` — full 9-chart modular seal for this wave  
- `degree_35/*` — inputs/outputs for mixed-third quadratic charts  
- `degree_31/*` — residual pure-third charts 4,5 hardlinks  
- `WAVE_STATUS.md` — this file  

**Forbidden inferences this wave:** `COV-DEGREE-EMPTY`, headline change, promoting
the zero degree-35 linear module quotient, treating modular unit charts as
characteristic-zero closures, or re-sealing the packet without authorized
re-assemble.
