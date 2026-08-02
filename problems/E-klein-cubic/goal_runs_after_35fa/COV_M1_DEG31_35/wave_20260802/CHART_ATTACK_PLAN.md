# COV m=1 deg 31/35 — Chart Attack Plan (wave 2026-08-02)

Packet status remains **COV-UNDECIDED**. This wave is chart inventory + light
modular CAS only. It does **not** authorize `COV-DEGREE-EMPTY` or any headline
change.

## Transfer limitation (mandatory)

> **Modular Groebner basis `[1]` over a prime field does not transfer to
> characteristic zero without a proper-specialization / integral-model theorem.**
>
> Every residual cover chart below is an *affine* chart on a *fibre-specific*
> kernel basis (typically built at `p=463`). Emptiness over `F_p` is a special-
> fibre screen only. Closing a characteristic-zero branch additionally requires
> either:
>
> 1. a projective saturation / complete-intersection minor that is integral and
>    of full rank after reduction (as used for the sealed 5-dimensional deep
>    tails), or
> 2. a model of the chart equations over `Z` (or a localization) with controlled
>    denominators and a proper-specialization theorem for that flat model.
>
> Linear gate ranks that agree at two split primes (`463`, `727`) do transfer as
> characteristic-zero *upper bounds* on kernel dimensions via nonzero fixed
> minors, but that is weaker than affine emptiness.

---

## Residual chart cover (exact counts from STATUS.md / EXIT.json)

Characteristic-zero cover still open (affine saturations away from factorable /
composition incidence loci). Counts are **normalization charts** on the
indicated decision kernels:

| Family | Deg 31 | Deg 35 | Kernel dim (p=463=p=727) | Notes |
|---|---:|---:|---:|---|
| C3-nonbased (constant scalar charts) | **10** | **12** | 187 / 348 | earliest nonbased; largest residual |
| First-normal nonbased, **tangent-reduced** | **15** | **9** | 137 / 266 | was 17+11 before tangent |
| Pure second-normal nonbased | **7** | **24** | 99 / 247 | pure quadratic jet |
| Mixed second-normal nonbased, **tangent-reduced** | **9** | **16** | 45 / 156 | was 13+20 before tangent |
| Pure third-normal nonbased | **6** | **31** | 36 / 140 | d31: 2 of 6 empty over `F_463` only |
| Mixed-third nonbased, **tangent-reduced** (d35) | — | **9** | 39 | quadratic subsystem prepared in WORK twin |
| Deep projective tails (based scalar-zero) | **0** | **0** | 5 / 5 | sealed empty: full 35/35 cubic span |

**Total residual affine charts (char-0 cover):**  
`10+15+7+9+6 = 47` (deg 31) + `12+9+24+16+31+9 = 101` (deg 35) = **148 charts**.

Special-fibre (`p=463`) refinement of d31 pure-third: charts 0,1 unit ⇒ residual
**4** charts in that fibre only; all **6** remain open in char-0.

### Already-closed modular screens (do not promote)

Sealed packet (`goal_runs_after_35fa/COV_M1_DEG31_35/`):

- d31 pure-third charts **0,1** → msolve GB `[1]` over `F_463`
- deep tails d31/d35 → cubic span rank 35/35 over `F_463` (projective emptiness;
  linear ranks agree at 463 and 727)

WORK twin extras (read-only inventory; not sealed into packet):

- d31 pure-third **affine-eliminated** residual charts **4,5** (original cover) → `[1]`
- d31 pure-third **vandermonde residual** charts **3,4,5** → `[1]`; chart **2** incomplete
- d35 mixed-third **quadratic eliminated** charts **0,1** → `[1]`; charts **2–8** incomplete
- P25 common branch B: 7 unit charts + empty boundary (projective empty in char-0
  for that P25 sub-arrangement only)

---

## Size / resource estimates (attack order = smallest first)

Expected CAS footprint is dominated by variable count and equation density.
Hard cap for this wave: **~4 GiB RSS**, timeout rather than hang; prefer
prepare+seal (row-rank profiles, affine elimination) over silent long RREF.

| Priority | Chart class | Vars after chart elim | Eqns (typical) | Input size | Feasible under 4GiB? |
|---:|---|---:|---:|---:|---|
| 1 | **d35 mixed-third quadratic residual 2–8** | 38 | ~137 quadrics | ~1.2 MB | **YES** — primary attack |
| 2 | d31 pure-third residual affine **5** | 30 | ~1153 cubics | ~88 MB | borderline; prior run finished |
| 3 | d31 pure-third residual affine **4** | 31 | ~1157 cubics | ~98 MB | borderline |
| 4 | d31 pure-third residual affine **3** | 32 | ~1157 cubics | ~107 MB | prior out empty (timeout/kill) |
| 5 | d31 pure-third residual affine **2** | 33 | ~1157 cubics | ~117 MB | prior out empty |
| 6 | d31 mixed-second tangent charts (9) | ≤45 | dense cubics | multi-100MB | heavy |
| 7 | d35 mixed-second tangent (16) | ≤156 | — | huge | no for this wave |
| 8 | pure second / first-normal / C3-nonbased | 99–348 | full landing | multi-GB | no |

Rough RAM rule of thumb used here: cubic systems with ≥30 vars and ~10³ dense
equations can exceed 4 GiB during F4; quadratic 38-var systems with ~10² eqs
stay well under.

---

## Primes

| Role | Prime | Status |
|---|---:|---|
| Primary modular fibre | **463** | all cubic/quadratic chart runs so far |
| Linear-rank holdout | **727** | gate ranks agree (sealed) |
| Basis / Reynolds holdout | **419** | sealed self-covariant / dual ranks |
| P25 strict branch A sample | 199, 331 | WORK twin only |
| Preferred next emptiness holdout | **727** or **991** | requires full chart rebuild of equations |

**Holdout policy for emptiness:** a second prime requires rebuilding the
fibre-specific kernel and the restricted landing (or quadratic) equations.
Linear rank agreement at 463/727 does **not** by itself empty affine charts.

Independent verifier for this wave: **Singular** `std` / `slimgb` on the same
msolve input (or a thin Singular translation), plus msolve replay with `-g 1`.

---

## Attack protocol (per chart)

1. **Prepare:** impose chart scalar = 1 and prior residual scalars = 0; solve
   those linears exactly; substitute into a fixed row basis of the landing
   (or jet) equations (`export_*_affine_msolve.py` / `emit_*_chart.py`).
2. **Seal profile:** optional `fflas_rank_u16 --profile-only` to drop redundant
   rows before export.
3. **Solve:** `msolve -f … -o … -g 1 -t 4 -v 1` with external timeout and RSS
   soft limit (~4 GiB).
4. **Verify:** re-run with Singular, or re-hash input and replay msolve.
5. **Record:** JSON under `wave_20260802/` with sha256 of input/output;
   **do not** re-seal packet `SEAL.json` unless a full packet re-assemble is
   authorized.
6. **State explicitly** that modular `[1]` is special-fibre only.

---

## This wave targets

1. Inventory + this plan.
2. Independent msolve + Singular verification of **d35 mixed-third chart 0**
   (already `[1]` in WORK twin).
3. Complete residual **d35 mixed-third quadratic charts 2–8** over `F_463` if
   inputs can be emitted under the RSS cap.
4. Inventory/re-seal of **d31 pure-third residual charts 4,5** modular results
   into the wave dir (already unit in WORK; no char-0 claim).
5. Optional attempt on **d31 pure-third residual chart 3** with hard timeout.

**Next chart after this wave (recommended):** finish any unfinished d35
mixed-third quadratic charts, then d31 pure-third residual chart 3 (32 vars)
with prepare+seal + longer timeout, then d31 mixed-second tangent chart 0
(45 vars) if RSS budget allows.

---

## Forbidden inferences

- Do **not** claim `COV-DEGREE-EMPTY` or scoped full-degree emptiness.
- Do **not** promote the zero degree-35 linear module quotient to emptiness
  (primitive counterexamples sealed).
- Do **not** treat P25.2 as closed; residual P25 image can still enter early
  nonbased covers (strict branch A upper bound 37 remains open in WORK).
- Do **not** treat fibre-specific unit charts as characteristic-zero charts.
