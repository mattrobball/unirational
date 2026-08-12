# The landing system in invariant coordinates

**Packet:** `goal_runs_20260812/LANDING_INVARIANT_SIDE/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Every landing cubic `c ↦ F(T_c)` lands in the degree-`3d` invariants
`Inv^{3d} ⊂ Sym^{3d} W*` (`F` invariant, `T_c` equivariant). Director probe
`director_probes_20260812/` gives Molien ceilings `I(3d)`; the raw ambient
`Sym^3(cell)` is far larger for `d ≥ 36`. This packet measures the landing
rank `P3(d)` by an invariant-side evaluation matrix (sketched dual of `Inv`
via point evaluations of the already-invariant form `F(T_c)`), saturates it
at two primes, and continues the d=35 Hilbert ladder to degree 4 with
certified two-sided bounds. **Observations only; no degree excluded.**

## Exit ledger

```text
LANDING-INV-P3-CONTROL-D35
LANDING-INV-P3-EXACT-36-38
LANDING-INV-CEILINGS-I3D
LANDING-INV-HF4-BOUNDS-D35
LANDING-INV-KERNEL-PROBE
LANDING-INV-NO-DEGREE-EXCLUSION
```

Machine markers: `LANDING_INV_VERIFY_OK` / `ALLGREEN` (`python3 verifier.py`).

---

## 0. Object and method

- **Cell.** Post-flip Layer-0 slice of the `(m,r)=(1,6)` window at degree `d`:
  sealed K from `LANDING_SWEEP` / D34 alive-table
  (`K ∈ {37,63,119,151}` for `d=35..38`). At `d=35` the sealed 37-cell is
  loaded from `PAIR_ATTACK_D35`; at `d≥36` rebuilt by Layer-0 + six-flip.
- **Map.** `μ: Sym^3(cell) → Inv^{3d}`, rank `P3(d)`. Ceiling: `P3(d) ≤ I(3d)`.
  Cell-side Hilbert piece: `HF3(d) = binom(K+2,3) − P3(d)`.
- **Invariant-side rank.** Sample random points `y_t ∈ W`, random cell
  coefficients `c_s`; form the matrix `M_{s,t} = F(T_{c_s}(y_t))`; take rank
  over `F_p`. For `char > 3` pure cubes span `Sym^3`, so the span of
  `{F(T_c)}` recovers `im(μ)`. No dense `binom(K+2,3)` ambient is built.
- **Saturation.** Incremental rank until `stable_window` non-increasing
  samples; two extra batches of 500 must add rank 0. Both primes must agree.
- **Primes.** `p ∈ {331, 661}` end to end. python3 only (+ msolve/M2 unused
  here; no gap/gp/sage/magma).

---

## 1. Exact P3 / HF3 table against Molien ceilings

| d | K | N3 = C(K+2,3) | P3 | HF3 | I(3d) | deficit I−P3 | P3/I | sat both primes |
|--:|--:|--------------:|---:|----:|------:|-------------:|-----:|:---------------:|
| 35 | 37 | 9139 | **1380** | **7759** | 8555 (I105) | 7175 | 0.161 | yes |
| 36 | 63 | 43680 | **1850** | **41830** | 9545 (I108) | 7695 | 0.194 | yes |
| 37 | 119 | 287980 | **2642** | **285338** | 10614 (I111) | 7972 | 0.249 | yes |
| 38 | 151 | 585276 | **3285** | **581991** | 11776 (I114) | 8491 | 0.279 | yes |

Control: `P3(35)=1380` reproduces `D35_LANDING` / `LANDING_SWEEP` at both
primes (mode `inv_eval_matrix`). Prior `LANDING_SWEEP` left `P3(36) ≥ 1500`
unsaturated; this packet saturates **P3(36)=1850** and delivers exact
**P3(37)=2642**, **P3(38)=3285**.

**Observation (not a closed form).** Over `d=35..38`, `P3/I(3d)` rises
~0.16→0.28 while the absolute deficit `I(3d)−P3` grows slowly
(~7175→8491). No low-degree polynomial formula for `P3(d)` is forced by
four points. The ceiling is never attained: the landing image is a proper
subspace of the full invariant space at every tested degree.

Artefacts: `results/p3_inv_d{d}_p{p}.json`, `results/summary.json`.
Heavy cell bases `A_*.npy`, `C_*.npy`, `Bcell_*.npy` are gitignored
(regenerate via `python3 scripts/produce_p3.py`).

---

## 2. HF(4) at d=35 (Tier-2 two-sided bounds)

Ambient `N4 = binom(40,4) = 91390`. Multiplication map domain dimension
`37 · P3 = 37 · 1380 = 51060 < N4`, so **exactly**

```text
HF4_lower = N4 − 37·P3 = 40330 > 0
P4_upper  = 51060
```

(characteristic-free linear algebra; sealed already in `D35_LANDING`).

k×k random sketches of the multiply (two independent seeds, both primes,
`k=6000`, I3 basis from `D35_LANDING/results/I3_echelon_p{p}.npy`):

| prime | P4_lower (sketch) | P4_upper | HF4_lower | HF4_upper | method |
|------:|------------------:|---------:|----------:|----------:|--------|
| 331   | ≥ 6000            | 51060    | **40330** | ≤ 85390   | kxk two seeds |
| 661   | ≥ 6000            | 51060    | **40330** | ≤ 85390   | kxk two seeds |

No rank-`<k` plateau at `k=6000` (sketch full rank) — exact `P4` not
reached within packet budget. Honesty: **domain lower bound on HF4 is
exact**; sketch lower bounds on `P4` are **Tier 2 modular**. Emptiness of
the landing ideal is still not settled by linear algebra (HF never driven
to 0 at degrees 3–4).

Artefacts: `results/hf4_p{p}.json`, `results/hf4_summary.json`.
Regenerate: `python3 scripts/produce_hf4.py`.

---

## 3. Kernel question (timeboxed)

Why is `rank(μ: Sym^3(cell) → Inv^{105})` only 1380, leaving a 7759-dim
kernel inside `Sym^3` of the 37-cell (and a 7175-dim deficit vs `I(105)`)?

**Candidate tested.** Polarization degeneracy from `T_c` ranging over a
*linear* subspace of the quadratically-sized `M_35`.

**Nested r-planes in the 37-cell** (`results/kernel_p331.json`, curve
length 7):

| r | P3 | N3=C(r+2,3) | note |
|--:|---:|------------:|------|
| 5 | 35 | 35 | full rank |
| 10 | 220 | 220 | full rank |
| 15 | 680 | 680 | full rank |
| 20 | 1300 | 1540 | first drop |
| 25 | 1380 | 2925 | already at cell value |
| 30 | 1380 | 4960 | plateau |
| 37 | 1380 | 9139 | cell |

**Verdict (`partial_structural`).** On nested random r-planes, `μ` is
**full rank** for `r ≤ 15` (`P3 = N3`). Image dimension reaches the cell
value 1380 by `r ≈ 25` and then plateaus while `N3` grows — so the
7759-dim kernel is the excess of `Sym^3(cell)` over a 1380-dim image that
already saturates on a proper subspace. Full `M_35` has `P3 ≥ 5400`
(timeboxed, unsaturated), far above the cell: the Layer-0/flip cut is a
major source of rank drop, but even full `M` stays below `I(105)`. The
pure “linear family in quadratic M” slogan is therefore only half the
story: small linear slices are non-degenerate, and degeneracy onsets near
dimension ~20. Simple dim-`W=5` pointwise image bound is a documented
dead end (caps a single cubic, not the span).

---

## 4. Honesty and outcome

| item | status |
|------|--------|
| honesty tier | **2 (modular)** |
| P3(35..38) | exact, two-prime agreement, saturated |
| HF4 domain lb | exact (char-free) |
| HF4 sketch bounds | Tier 2 modular |
| kernel probe | exploratory structural observation |
| degree exclusion | **none** |
| claimed Nullstellensatz / O1 | **no** |

Stuck at the same structural wall as `D35_LANDING`: HF(3) and HF(4) stay
large positive; the invariant compression un-walls exact `P3` through
`d=38` but does not by itself drive the Hilbert ladder to zero.

---

## 5. Not claimed

- That any degree `d ∈ {35,…,38}` is closed, or that no pair `(T,r)` exists.
- Characteristic-zero emptiness of any landing scheme on these cells.
- An exact value of `P4` or `HF(d)=0` for any `d`.
- A closed-form formula for `P3(d)` or for the 7759-dim cubic kernel.
- Any degree exclusion. **Problem E remains OPEN.**

---

## 6. Replay

```bash
cd goal_runs_20260812/LANDING_INVARIANT_SIDE
python3 verifier.py
# optional regeneration (slow; heavy *.npy gitignored, 50 MB hosting limit):
#   python3 scripts/produce_p3.py              # d=35..38 both primes
#   python3 scripts/produce_p3.py 38 661       # single (d,p)
#   python3 scripts/produce_hf4.py             # HF4 sketches both primes
#   python3 scripts/produce_kernel.py          # nested kernel probe
#   python3 scripts/compile_summary.py
```

Primary artefacts under `results/`: `p3_inv_d{d}_p{p}.json`,
`hf4_p{p}.json`, `kernel_p331.json`, `summary.json`, `verifier_output.json`.

## Director adjudication (2026-08-12, appended at sealing, post-resume)

1. First worker session externally terminated pre-writeup; resumed and
   completed; replayed clean (53 checks, ALLGREEN).
2. The P3 table through d = 38 (1380/1850/2642/3285 against ceilings
   8555/9545/10614/11776) makes the landing system's rank deficit a
   FOUR-DEGREE phenomenon with the deficit growing — the named open
   question (what is the structural kernel?) now has a data curve, and
   any future explanation must reproduce these four numbers.
3. HF4 at 35 remains [40330, 85390]: the linear-algebra ladder cannot
   close the d = 35 certificate — settled twice now; the decisive
   instrument must be structured elimination or a new reduction.
