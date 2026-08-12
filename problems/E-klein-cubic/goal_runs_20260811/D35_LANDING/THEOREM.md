# The landing certificate on the 37-cell at d = 35

**Packet:** `goal_runs_20260811/D35_LANDING/` · 2026-08-11.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

The pair-attack survivor space is one 37-dimensional linear cell (the sealed
39-dim Layer-0 slice cut by the six universal flip conditions). This packet
imposes the cubic landing equation `F(T_c) ≡ 0` on that cell — the first time
the campaign has imposed the actual landing ideal rather than linear necessary
conditions. Outcome: **O4 INCONCLUSIVE**, leaning **O1 EMPTY**, flagged as a
**window-closure candidate**. Modular evidence is **Tier 2**. The adversarial
audit (`WORKORDER_D35_ADVERSARIAL_AUDIT`) is the gate; **nothing is claimed**.

## Exit ledger

```text
D35-LANDING-I3-PLATEAU
D35-LANDING-HF-PROFILE
D35-LANDING-SECTIONS-ORIGIN-ONLY
D35-LANDING-NO-NONEMPTY-WITNESS
D35-LANDING-O1-LEANING-FLAG
D35-LANDING-NO-DEGREE-EXCLUSION
```

Machine markers: `D35_LANDING_VERIFY_OK` / `ALLGREEN` (`python3 verifier.py`).

---

## 0. Object

- **Cell.** `c ∈ F_p^{37}` parametrizes `T_c = Σ_j c_j T_j` inside the
  G-invariant space `M_35`, after the six flip cuts. Inputs:
  `PAIR_ATTACK_D35/results/layer0_null_p{331,661}.npy`,
  `worked_example_p{p}.json` (`universal_matrix_6x39`), seed tables
  `layer0_A_p331.npy` / `layer0_C_p331.npy` (prime-independent).
- **Landing ideal.** `I = ( F(T_c(x)) : x ∈ P^4 ) ⊂ F_p[c_0,…,c_36]`,
  homogeneous, generated in degree 3. Each sample point gives one cubic.
- **Primes.** `p ∈ {331, 661}` end to end.
- **G-action.** Residual action of `G = PSL(2,11)` on the 37-cell is **trivial**
  (`χ(g) = 37` on every conjugacy class; isotypic type `37 · 1`). There are no
  isotypic blocks to exploit for Groebner. (Equivariance is still used: orbit
  sampling saturates the cubic span.)

---

## 1. Degree-3 piece: saturated plateau (exact linear algebra)

`I_3 ⊂ Sym^3(F_p^{37})^*`, ambient dimension `N_3 = binom(39,3) = 9139`.

| prime | P3 = dim I_3 | HF(3) = 9139 − P3 | npts tested | extra batches (+0?) | cross-check new dirs |
|------:|-------------:|------------------:|------------:|---------------------:|---------------------:|
| 331   | **1380**     | **7759**          | 3001        | 2 × 400, both +0     | 0 / 300              |
| 661   | **1380**     | **7759**          | 2681        | 2 × 400, both +0     | 0 / 300              |

Saturation protocol: incremental row-echelon span of sampled cubics until
`stable_window = 500` consecutive non-increasing samples; then two independent
extra batches of 400 points (fresh seeds) must add rank 0; then a third-seed
cross-check of 300 points must produce 0 new directions.

**Deliverable.** `P3 = 1380` at both primes. Artefacts:
`results/I3_echelon_p{p}.npy`, `results/plateau_p{p}.json`,
`results/cubic_indep_p{p}.npy`.

**Consequence.** HF(3) = 7759 > 0, so emptiness is **not** settled by degree-3
linear algebra alone (the generators do not span all of `Sym^3`).

---

## 2. Higher Hilbert pieces (Tier-2 bounds)

`I_{d+1} = span{ x_i · f : f ∈ I_d, i = 0..36 }`.

| deg | N_d = dim Sym^d | P_d lower | P_d upper | HF lower | HF upper | method |
|----:|----------------:|----------:|----------:|---------:|---------:|--------|
| 3   | 9139            | 1380      | 1380      | 7759     | 7759     | exact sample plateau |
| 4   | 91390           | ≥ 6000    | ≤ 51060 = 37·P3 | ≥ 40330 | ≤ 85390 | k×k random sketches (two seeds, k≤6000) + domain upper bound |
| 5   | 749398          | —         | ≤ min(N_5, 37·P4_ub) = 749398 | ≥ 0 | — | bound only |
| 6   | 5245786         | —         | chain     | ≥ 0 | — | bound only |

At degree 4 the multiplication map cannot be surjective: domain dimension
`37 · 1380 = 51060 < 91390 = N_4`, so **HF(4) ≥ 40330 > 0** exactly (not just
as a probe). Emptiness would require some later degree `d ≥ 5` with
`I_d = Sym^d`. Building an exact `I_4` basis (up to ~50k dense vectors of length
~91k) and pushing the Hilbert function to the vanishing degree exceeds the
resource budget of this packet; the k×k sketches give `P4 ≥ 6000` at both
primes (Tier 2) but do not certify a plateau.

**No HF(d) = 0 certificate.** Linear algebra alone does not prove O1 in this run.

---

## 3. Reduced-subsystem section attack (msolve on P^s, never the monolith)

Full 37-variable msolve/M2 on 1380 dense cubics is a resource wall (70MB+
input; prefix cascades of 20–100 equations time out). Protocol: random linear
sections of the 37-cell of projective dimensions 1, 2, 3; restrict the landing
cubics; run `msolve -g 2`; test whether the GB is the irrelevant ideal
`(a_0,…,a_s)`.

| prime | P1 origin-only | P2 | P3 | nondeg witnesses | fail |
|------:|---------------:|---:|---:|-----------------:|-----:|
| 331   | 40 / 40        | 25 / 25 | 12 / 12 | 0 | 0 |
| 661   | 40 / 40        | 25 / 25 | 12 / 12 | 0 | 0 |

Spot check (p = 331, random P1): GB = `[a0, a1]` (irrelevant). Degeneracy
kernel of “`T` vanishes on the minus-line” has rank 8, kernel dimension 29; on
that 29-space, 15 random P2 sections are likewise origin-only at both primes.

**Reading.**
- Rules out a **positive-dimensional** component of `V(I)` that meets a
  random low-dimensional linear space (all such sections empty of nontrivial
  points).
- Does **not** by itself Nullstellensatz-kill a pure 0-dimensional scheme of
  positive degree in `P^{36}` (a random `P^1` misses finite points with
  overwhelming probability). Hence this is **O1-leaning section evidence**,
  not a full O1 Groebner certificate on the 37-cell.

No non-degenerate witness `c ≠ 0` with `F(T_c) ≈ 0` on samples was found
(outcome O3 not reached). No section hit supported only on the degeneracy
locus either (so O2 is not positively certified; if solutions exist they were
not seen).

---

## 4. Outcome and honesty

| code | status |
|------|--------|
| **O4 INCONCLUSIVE** | **delivered** |
| leaning | **O1 EMPTY** |
| flag | **window-closure candidate** |
| honesty tier | **2 (modular)** |
| gate | `WORKORDER_D35_ADVERSARIAL_AUDIT` |
| claimed? | **no** |

Stuck at:
1. full 37-var Groebner / dim resource wall;
2. HF not driven to 0 (HF(3)=7759, HF(4)≥40330);
3. section origin-only is empty-leaning but not a 0-dim Nullstellensatz.

What would promote O1: a replayable Groebner (or Macaulay) certificate that
`I_d = Sym^d` for some `d`, or an irrelevant-ideal GB of the saturated ideal
on the 37-cell, at both primes.

---

## 5. The 22 blueprints

All 22 survivors of `PAIR_ATTACK_D35` are open-condition profiles on this same
37-cell (order-0 line branches). Disposition under this packet:

| disposition | meaning |
|-------------|---------|
| **conditionally dead under O1** | if the landing ideal is irrelevant, every blueprint dies with the cell |
| **no live witness** | no non-degenerate `c` was produced |
| **not degree-excluded** | packet does not close the `d = 35` window; claim waits on audit |

Per-blueprint hashes remain those of `survivors22_p{p}.json`; this packet does
not refine them individually beyond the common cell-level obstruction.

---

## 6. Not claimed

- That `d = 35` is closed, or that no pair `(T,r)` exists at this degree.
- Characteristic-zero emptiness of the landing scheme on the cell.
- That the section campaign is a full Groebner certificate for O1.
- Any degree exclusion. **Problem E remains OPEN.**

---

## 7. Replay

```bash
cd goal_runs_20260811/D35_LANDING
python3 verifier.py
# optional regeneration (slow):
#   python3 scripts/hilbert_cert.py 331   # I3 plateau + character
#   python3 scripts/hf_multiply.py 331 661
#   python3 scripts/degeneracy_attack.py 331 661
```

Primary artefacts under `results/`: `plateau_p{p}.json`, `I3_echelon_p{p}.npy`,
`hf_mul_p{p}.json`, `degeneracy_p{p}.json`, `landing_summary.json`,
`landing_final_p{p}.json`.

## Director adjudication (2026-08-11, appended before sealing)

1. Replayed from a clean shell: `D35_LANDING_VERIFY_OK` / `ALLGREEN`
   (71 checks). The outcome O4-leaning-O1 is accepted as delivered;
   nothing is promoted.
2. Two structural facts from this packet now steer the endgame:
   (a) `HF(3) = 7759` and `HF(4) ≥ 40 330` are exact/definitive — the
   Hilbert ladder CANNOT close the certificate at low degree, so a
   decisive verdict requires either a structured Gröbner effort beyond
   the observed 37-variable wall or a genuinely new reduction; (b) the
   worker's own caveat is adopted: origin-only random sections are
   consistent with a small positive-dimensional cone and are evidence,
   not proof.
3. The 22 blueprints remain the live set, now "conditionally dead if O1
   holds" — the window statement is unchanged and MUST remain so until a
   certified emptiness (or witness) exists.
4. Queued for the next cycle, in order of expected bite: the corrected
   period-3 keep-pass on the 22 (audited semantics from `D35_AUDIT` T4 —
   new closed conditions at rows 68/69, independent of the cubic); the
   T6 cone-order audit; then the cubic again with whatever structure
   those passes expose (a smaller live set shrinks the relevant
   degenerate-locus saturation).

**Storage note (director, at sealing):** the heavy binary intermediates in
`results/` (`*.npy` echelon/sample matrices, `*.ms`/`*.m2` solver inputs;
~800 MB) are gitignored — they exceed hosting limits and are fully
regenerable: re-run the producing scripts (`scripts/hilbert_cert.py` /
`scripts/hf_multiply.py` (and `sample_plateau.py`), per prime) before replaying verifier check
group A; groups B–E replay from the tracked JSON/logs alone.
