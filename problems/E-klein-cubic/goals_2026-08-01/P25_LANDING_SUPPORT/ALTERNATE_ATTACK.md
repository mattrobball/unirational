# P25 landing support — alternate attack (no full-F4 launch this session)

**Date:** 2026-08-02  
**Exit:** `P25-UNDECIDED`  
**Launch status:** technical non-`ps` path exists; **runtime launch BLOCKED** by competing COV msolve (~3.5 GiB). Mission prefers structural attack when COV is heavy.

This note ranks **shortcuts that shrink residual charts without pretending a full
F4 completion**. No chart is claimed empty. No `P25-DEGREE-EMPTY`.

---

## 0. Why full F4 is deferred (this session)

| Fact | Detail |
|---|---|
| Prepared chart | Stage B `q0=1,b1_0=1`, 66 eqs / 41 vars, `-m 100` pair-cap |
| Prior nonverdict | deg≤5 done; entered 1708-pair deg-6; **manual stop ~4.275 GiB RSS** |
| 4.5 GiB fence | **theater** (+230 MiB after incomplete stop) — retired |
| Proposed fence | **16 GiB default**, flag range **[8,32]** on **128 GiB** host |
| Non-`ps` monitor | **implemented**: libproc RSS + `proc_listpids` census + `sysctl(KERN_PROCARGS2)` argv |
| Memory gate | free+speculative **~93 GiB** ≥ 14 GiB → pass |
| Process gate | **fail**: live COV_M1 deg-35 msolve replay PID active |
| Mission policy | do not co-schedule with heavy COV; prefer alternate structural attack |

So: launch path is fail-safe and no longer blocked by sandbox `ps`, but a
single-chart launch is **not truly safe now** (COV contention). Work below is
structural ranking for the next agent once COV is idle, or for pure-algebra
routes that avoid multi-GB F4.

---

## 1. Ranked alternate attacks (highest value first)

### Rank A — Secondary linear splits inside each MDS open (shrink variables)

**Idea.** Each of the 34 Stage-B MDS opens is still large (r66: 41 vars after
`q0=1,b1_0=1`). Further **exact affine strata** by setting one free outside-q
or residual b1 coordinate to 1 (and the complementary zero loci as separate
opens) produce a finite subcover with **fewer free variables per chart**.

| Split family | Cover correctness | Expected chart size | Risk |
|---|---|---|---|
| Extra outside-q flag `q_j=1` on residual free H8 coords after MDS normalize | finite open cover of `D(ℓ_k)` | drop ~1 var; many more charts | multiplies residual count; only wins if F4 becomes easy |
| Extra pure-b1 flag on residual `b1` after `m_k=1` | finite cover of `D(m_k)` in `P^5` | 5 residual b1 charts | must not re-use twisted b0/b1 mixing |
| Paired secondary RS code of shorter length on a **subspace** of free coords | needs new MDS proof | can cut several vars at once | new cover certificate required |

**Why ranked high.** Prior F4 cost is dominated by matrix width at deg 5–6
(685k columns already at deg 5). Dropping free variables is the only structural
lever that directly shrinks that width without inventing false equations.

**Not authorized:** claiming one subchart empty ⇒ parent MDS open empty
without the complementary subcharts.

**Next concrete prep (no launch):** pick chart 0 (`ℓ_0,m_0` / `q0=1,b1_0=1`)
and produce **two** byte-bound jobs:

```text
(q0=1, b1_0=1, q1=1)   and   (q0=1, b1_0=1, q1=0, q12=1)
```

(or any free H8 coordinate with nonzero residual support). Verify entrywise
against the r66 packet. Seal as `PREPARED_NOT_RUN` with the same 16 GiB fence
path. Only launch when COV is idle.

---

### Rank B — Keep r66 necessary system; never enlarge to all-690 for first pass

**Idea.** The r66 contractions are **necessary** for Stage B. Unit ideal on an
r66 chart ⇒ that Stage-B chart is empty. The all-690 systems (62 vars after
two normalizations) are strictly harder and only needed if r66 is nonunit.

| Object | eqs | vars (typical chart) | role |
|---|---:|---:|---|
| r66 Stage B | 66 | 41 | necessary; emptiness transfers up |
| all-690 Stage B | 690 | ~62 | sufficient; larger |
| r66 Stage C | 66 | 42 | necessary for normalized Stage C |

**Rank rationale.** Already the active package. Do not “upgrade” to all-690
until r66 either units or returns a completed nonunit basis (the latter is
still only a nonverdict for the full incidence).

---

### Rank C — Degree-bounded annihilator / Fitting without full GB

**Idea.** From structural audits:

- M2 Steiner cokernel is exact and sheaf-zero (Stage A closed).
- Stage B is about injectivity/compatibility of the six-column P3 map after
  M2 syzygies.
- Pure-power membership and dual functionals were **undecided**, not refuted.

**Actions that stay light-memory:**

1. On chart `q_i=1`, continue **exact low-degree Fitting ranks** of the
   contracted P3 block (affine filtration already ranks `6,222,4218` on
   sampled axes).
2. Search for a **degree-bounded left inverse** of selected minors only on
   `D(H8)` (not globally — systematic 21×21 minors already vanish somewhere
   on each `D(q_i)`).
3. Compute annihilators of coker in degree ≤ d for small d on one affine
   chart using **linear algebra only** (no F4), recording only rank
   certificates.

**Win condition.** A chartwise polynomial certificate that 1 is in the
Fitting ideal of the Stage-B map (or an explicit Nullstellensatz identity
with bounded degree).  
**Fail-closed.** Missing inverse / nonzero remainder = nonverdict (as in
power-membership packet).

---

### Rank D — Engine / order diversity on the **same** sealed chart (only after COV idle)

| Engine | Why try | Fence proposal | Caveat |
|---|---|---|---|
| msolve ordinary F4, `-m 100` | prepared; isolates pair-cap | **16–32 GiB**, wall 1200–3600 s | current primary |
| msolve ordinary F4, `-m 0` | baseline completeness | 32 GiB | already hit ~4.28 GiB incomplete under small fence |
| Singular `std` / `slimgb`, dp or lp | different selection | 16 GiB | affine_chart_solver already saw long nonverdicts |
| signature F4 (`-q 1`) | sometimes smaller | — | **rejected**: nonhomogeneous + wrong char report; inapplicable |

Do **not** launch signature mode again as evidence.

---

### Rank E — Stage-C residual opens only after Stage-B progress

Stage C: 29 residual opens on `D(H8)` with `b0=1`. Prepared package
`parallel/r66_stagec/` is larger (~2.88× Stage-B neighbor terms; ~118 MiB
input). Prefer **not** to open Stage-C F4 while Stage-B pair-split and COV
are unresolved. Structural rank work (C-style compatibility ranks as on L8)
on one Stage-C chart may be cheaper than F4 if a closed-form minor appears.

---

### Rank F — Deeper contractions (use with extreme care)

| Contraction | Status | Use? |
|---|---|---|
| r66 (64 support-balanced + 2 full-basis) | rank-7 on all 666 lines | **keep** |
| old r48 / r43 | certified **false loci** on L8-type spaces | **retired** |
| sparsest-43 of r256 | false locus on large coordinate span | **do not** use for unit proofs |
| further greedy row drops from r66 | may reintroduce axis rank defects | only if new line-rank cert |

Any smaller-than-r66 packet needs a **full 666-line rank-7 replay** before it
can host an emptiness claim.

---

### Rank G — Direct full-module pure-power / weighted jobs (global, expensive)

`parallel/global_compatibility/` prepared direct `690×28` degree-8 and pure-power
jobs. A terminal all-zero would empty the whole lower presentation. Those jobs
are **heavier** than one MDS chart and compete with COV. Park until COV quiet
and chart-wise residual count is still 63.

---

## 2. Smaller stratum splits that do **not** require full F4

These can be implemented as pure rank/cert scripts (light):

1. **H8 support filtration by Hamming weight** of outside-q coordinates  
   - wt ≤ 2 already empty by r66 line certificate.  
   - wt = 3,4,… as successive strata: for each weight class, either prove
     rank obstruction by evaluation of maximal minors of `[P4|P3]` on a
     dense open, or fall back to tiny F4 on that stratum only.

2. **b1-support filtration**  
   - support exactly 1 already empty globally (global_compatibility).  
   - support 2: 15 combinatorial types × projective scale — candidate for
     small exact systems (few free b1 ratios).

3. **L8-complement vs pure-H8 mixed terms**  
   - Already closed Stage B/C on L8.  
   - Any point with both L8 and H8 coordinates nonzero is still open; try
     dehomogenizations that set one L8 coord = 1 **and** one H8 coord = 1
     with fewer free vars than pure H8 MDS charts.

---

## 3. Explicit non-goals (do not “shortcut” these)

- Reinterpreting incomplete F4 / RSS kill as emptiness.
- Using signature-mode logs (wrong field / nonhomogeneous reject).
- Using r48/r43 false-locus packets for unit proofs.
- Claiming one of 34 MDS opens empty from a proper subchart without the
  complementary cover.
- Claiming char-0 landing empty from modular emptiness without the sealed
  DVR hypothesis on the **complete** special fibre.

---

## 4. Recommended sequence for the next free CAS slot

```text
1. Confirm COV msolve gone (libproc census competing_p25_probes == []).
2. Optional: prepare Rank-A secondary split of chart 0 (two subcharts).
3. Launch exactly ONE job:
     run_pair_split.py --confirm-parent-notified --rss-gib 16 --timeout-seconds 1200
   or a sealed Rank-A subchart under the same fences.
4. If unit: mark chart empty; prepare next MDS open.
5. If nonverdict under 16 GiB / 1200 s: try --rss-gib 32 --timeout-seconds 3600
   once, still one-at-a-time; if still incomplete, pivot hard to Rank C
   (Fitting / weight strata) rather than endless F4.
```

---

## 5. Files / tooling this session leaves behind

| Path | Role |
|---|---|
| `parallel/r66_pair_split/run_pair_split.py` | non-`ps` fail-closed runner; `--rss-gib` 8–32; `--timeout-seconds` 60–3600; default **16 GiB / 1200 s** |
| `parallel/r66_pair_split/verify_prepared.py` | live gate snapshot via libproc |
| `LAUNCH_READINESS.md` | readiness verdict |
| `ALTERNATE_ATTACK.md` (this file) | ranked non-F4 / shrink-chart plan |

---

## 6. One-line

```text
ALTERNATE: non-ps launch path OK + 16GiB fence implemented;
           runtime BLOCKED by COV msolve; prefer Rank-A secondary splits
           and Rank-C Fitting/weight strata over long F4 while COV heavy.
```
