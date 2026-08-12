# Landing instruments swept across degrees 34–42

**Packet:** `goal_runs_20260812/LANDING_SWEEP/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

The d = 35 endgame tools (Layer-0 cell, parity-forced line-order finisher,
six-flip cut, landing Hilbert P3/HF3, random section battery) are run at every
degree `d ∈ {34,…,42}`. Degree 34 is the sealed-closed control and must
reproduce cell dimension 0. Instrument verdicts at unclosed degrees are
map-level facts about the `(1,6)` window cells, conditional on the cone-order
premise (audited in parallel — cite `WORKORDER_CONE_ORDER_T6_GENERAL.md`).

Machine markers: `LANDING_SWEEP_VERIFY_OK` / `ALLGREEN` (`python3 verifier.py`).

## Exit ledger

```text
LANDING-SWEEP-DEGREE-TABLE
LANDING-SWEEP-D34-CONTROL-ZERO
LANDING-SWEEP-FINISHER-KILL-35-36
LANDING-SWEEP-SIXFLIP-RANK-2-ODD
LANDING-SWEEP-P3-D35-REPRODUCED
LANDING-SWEEP-SECTIONS-ORIGIN-ONLY
LANDING-SWEEP-NO-DEGREE-EXCLUSION
```

---

## 0. Set-up and engines reused

- **Cell.** Layer-0 slice of the `(m,r) = (1,6)` window: STAGE2 structure
  blocks of `produce_ladder.py` plus `ord_{ℓ_V} ≥ 6`, on `M_d = (Sym^d W* ⊗ W)^G`.
  Engine: `D34_GUIDED_SWEEP` (`slicelib`, `p2lib`, `d34lib`, `produce_d34`,
  `produce_ladder`) imported, not forked.
- **Finisher.** Parity-forced minimal *positive* line order on one minus-line:
  `ord ≡ d+1 (mod 2)`. At odd `d` the option is `ord ≥ 2`; at even `d`,
  `ord ≥ 1` is already forced by STAGE2 (M) when it fires, so the instrument
  tests `ord ≥ 3`. Source: `PAIR_ATTACK_D35/scripts/director_finish_d35.py`,
  degree-generalized.
- **Six-flip.** Six V4-child flip functionals (odd `d` only; at even `d` the
  level-0 value is the demanded vertex — skipped). Source:
  `director_worked_example.py` Stage A.
- **P3 / HF3.** Span of sampled landing cubics `F(T_c(x))` on the post-flip
  cell; `HF(3) = binom(K+2,3) − P3`. Source: `D35_LANDING/scripts/hilbert_cert.py`
  / `sample_plateau.py`. Dense saturation only for small `K`; larger cells
  flagged `too_large` (no false exact claim).
- **Sections.** 10 random `P^1` + 10 random `P^2` linear sections of the
  post-flip cell; `msolve -g 2` origin-only verdict. Never the 37-variable
  monolith.
- **Primes.** `p ∈ {331, 661}` end to end. No gap/gp/sage/magma.

---

## 1. The degree table (both primes agree on every core entry)

| d | cell | fin demand | fin rank | fin impossible? | flip rank | post-flip K | P3 | HF3 | P1 oo | P2 oo |
|--:|-----:|-----------:|---------:|:---------------:|----------:|------------:|---:|----:|------:|------:|
| 34 | **0** | — | 0 | yes (empty) | skip | 0 | 0 | 0 | — | — |
| 35 | **39** | ≥2 | **39** | **yes** | **2** | 37 | **1380** | **7759** | 10/10 | 10/10 |
| 36 | **63** | ≥3 | **63** | **yes** | skip | 63 | ≥1500* | ≤42180* | 10/10 | 10/10 |
| 37 | **121** | ≥2 | 54 | no | **2** | 119 | —† | —† | 10/10 | 10/10 |
| 38 | **151** | ≥3 | 114 | no | skip | 151 | —† | —† | 10/10 | 10/10 |
| 39 | **218** | ≥2 | 57 | no | **2** | 216 | —† | —† | 10/10 | 10/10 |
| 40 | **261** | ≥3 | 122 | no | skip | 261 | —† | —† | 10/10 | 10/10 |
| 41 | **343** | ≥2 | 61 | no | **2** | 341 | —† | —† | 10/10 | 10/10 |
| 42 | **397** | ≥3 | 130 | no | skip | 397 | —† | —† | 10/10 | 10/10 |

\* d = 36: dense sampling reached rank 1500 / `N3 = 43680` without a stable
plateau in the budgeted window; reported as a **lower bound** only.
† d ≥ 37: post-flip dim `K > 80` makes dense `Sym^3` (`N3 = binom(K+2,3)`) exceed
the packet budget; P3 deferred (mode `too_large`), not claimed zero.

Cell dimensions match the sealed D34 alive-table upper bounds
(`D34_GUIDED_SWEEP/THEOREM.md` §4) at both primes. Artefacts:
`results/d{d}_p{p}.json`, `results/degree_table.json`.

---

## 2. OBSERVATIONS (data, not theorems)

**OBS-1 (d = 34 control).** The cascade reproduces `cell_dim = 0` at
`p = 331` and `p = 661`. The sealed closure of degree 34 is intact.

**OBS-2 (finisher kill is narrow).** The parity-forced line-order instrument
is a full-rank kill on the Layer-0 cell **only at d = 35 and d = 36** among
the open degrees:

- odd: `ord ≥ 2` kills the 39-cell at d = 35, but leaves residual dimensions
  `67, 161, 282` at d = 37, 39, 41;
- even: `ord ≥ 3` kills the 63-cell at d = 36, but leaves residual dimensions
  `37, 139, 267` at d = 38, 40, 42.

So the 398-style line-order kill that finished residue-5 blueprints at d = 35
does **not** extend as a blanket kill across the window. σ-band pattern census
kill-fractions are reported only where residue-5 data already exists (d ≡ 5
mod 6, i.e. d = 35, 41 in range); this packet does **not** rebuild pattern
enumerations at other residues.

**OBS-3 (six-flip rank is constantly 2 on odd degrees).** For every odd
`d ∈ {35, 37, 39, 41}` the six flip functionals have

- rigidity violations `r1_bad = 0`,
- ambient rank `2` on all of `M_d`,
- slice rank **exactly 2** on the Layer-0 cell,

so `post_flip_dim = cell_dim − 2`. The ODDZERO F1 corank-2 phenomenon is
degree-stable through 41 in this window (observed, modular).

**OBS-4 (finisher ranks grow slowly past the kill window).**

| parity class | (d, fin_rank) sequence |
|---|---|
| odd, ord ≥ 2 | (35, 39), (37, 54), (39, 57), (41, 61) |
| even, ord ≥ 3 | (36, 63), (38, 114), (40, 122), (42, 130) |

After the full-rank kills, the rank increases by only a few units per two
degrees on the odd side, and by ~8 per two degrees on the even side after the
36→38 jump. No closed form is claimed; the sequences are recorded for later fit.

**OBS-5 (P3 at d = 35 reproduces the sealed landing number).** Dense saturated
plateau gives `P3 = 1380`, `HF3 = 7759 = binom(39,3) − 1380` at both primes —
identical to `D35_LANDING`. At d = 36 a lower bound `P3 ≥ 1500` on the 63-cell
(`N3 = 43680`) was obtained; HF3 remains positive. For `K > 80` the dense
certificate was not attempted.

**OBS-6 (sections origin-only across the window).** At every alive degree
d = 35…42, all 10 line-sections and all 10 plane-sections are origin-only by
msolve GB at both primes (80 + 80 section certificates). Same reading as
D35_LANDING: rules out positive-dimensional components that meet a random
low-dimensional linear space; does **not** Nullstellensatz-kill a pure
0-dimensional scheme in high projective dimension.

**OBS-7 (cell dimensions are not a low-degree polynomial in d of small degree
with small coefficients — raw differences).** Successive cell dims
`0, 39, 63, 121, 151, 218, 261, 343, 397` have first differences
`39, 24, 58, 30, 67, 43, 82, 54`. The even/odd subsequences
`(39, 121, 218, 343)` and `(63, 151, 261, 397)` both curve upward; no
degree-1 or degree-2 fit with small integer coefficients is forced by the
nine samples. Stated as an observation only.

**OBS-8 (HF3 does not vanish at low degree where measured).** At d = 35,
`HF3 = 7759 > 0` and the D35_LANDING bound `HF4 ≥ 40330` already shows the
Hilbert ladder cannot close by degree 4 on the 37-cell. At d = 36 the partial
span leaves `HF3 ≤ 42180` with room to spare. No degree in the sweep is
Hilbert-killed at degree 3.

---

## 3. Residue-5 kill note (no new pattern census)

At residue 5 (d = 35, and d = 41 in range) the σ-band pattern data of
`PAIR_ATTACK_D35` already exists at d = 35: the finisher full-rank kill
(`ord ≥ 2` rank = 39) is the universal demand that emptied every survivor
blueprint's closed cut. At d = 41 the same instrument is **not** full rank
(rank 61 of 343), so the analogous 398-style kill does **not** fire. Pattern
enumerations at non-5 residues are deliberately not rebuilt here.

---

## 4. Honesty tiering

**Tier 1 — exact modular agreement at two primes, with d = 34 control and
d = 35 sealed calibration.** Cell dims, finisher ranks, six-flip ranks,
d = 35 P3/HF3.

**Tier 2 — modular section GBs on reduced subsystems; P3 lower bounds /
`too_large` deferrals at large K.**

**Tier 3 — flagged.**

1. Nonzero cell dimensions are **upper bounds** only (modular rank ≤ char-0
   rank); zero at d = 34 is a characteristic-zero emptiness statement by the
   standard FIX-P1/P2 bridge.
2. Finisher/six-flip are linear conditions on the Layer-0 cell; they do not by
   themselves exclude a degree unless the cell dies (only d = 34 does among
   the sweep, and that was already sealed).
3. Origin-only sections are empty-leaning evidence, not a full Groebner
   certificate on the cell.
4. Cone-order premise for the `(1,6)` window is consumed from the D34 ladder /
   FIX-P2 sieve; T6 audit is parallel work.

## 5. Not claimed

- That any degree d ≥ 35 is closed or open as a final verdict.
- Any characteristic-zero Nullstellensatz for the landing ideal on a live cell.
- A closed form for cell dim, finisher rank, or P3 as a polynomial in d.
- Pattern-census kill fractions outside residue 5.
- **Problem E remains OPEN; this packet excludes no degree.**

## 6. Replay

```bash
cd goal_runs_20260812/LANDING_SWEEP
python3 verifier.py                 # JSON checks, fast
# python3 verifier.py --live        # also rebuilds d=34,35 cells at p=331
# optional full regeneration (slow):
#   python3 scripts/sweep_fast.py 331 34 42
#   python3 scripts/sweep_fast.py 661 34 42
#   python3 scripts/compile_table.py
```

Heavy binaries (`*.npy`, `*.ms`, `*.out`) are gitignored — hosting limit
50 MB/file; fully regenerable from the scripts above.

## 7. Dependencies

| import | role |
|---|---|
| `goal_runs_20260811/D34_GUIDED_SWEEP` | Layer-0 ladder engine, alive-table anchors |
| `goal_runs_20260811/PAIR_ATTACK_D35` | six-flip + finisher instruments |
| `goal_runs_20260811/D35_LANDING` | P3/HF3 + section protocol; storage lesson |
| `WORKORDER_LANDING_DEGREE_SWEEP.md` | this packet's commission |
| `WORKORDER_CONE_ORDER_T6_GENERAL.md` | cone-order premise (parallel audit) |

## Director adjudication (2026-08-12, appended before sealing)

Replayed from a clean shell: ALLGREEN. Accepted as delivered.
Specific notes: the d = 36 full-rank verdict (ν ≥ 3 line-branches die
before the window opens) is the standout yield and pre-arms the next
window; the fade of the instrument for d ≥ 37 is honest data steering the
general-degree program toward the transport/class-at-infinity route
rather than per-window grinding.
