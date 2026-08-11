# STATUS — TERMINUS_STRATA_PW

**Opened** 2026-08-10. **State: COMPLETE, verified at two primes.**
**Problem E remains OPEN** — this packet makes no headline claim.

## What it is

The full **orbit-type (exact-stabilizer) stratification** of the terminus `Z`
of the `STANDARD_FORM_PW` standard-form tower over `P(W) ≅ P⁴`,
`G = PSL(2,11)`: every `G`-orbit of components of every `Z_{=H}`, at every
stage of the tower, with dimension, component count, exact pointwise stabilizer,
setwise stabilizer, residual action, normal characters, tower provenance,
boundary/crossing position, toroidal local model and birational class; plus the
closure poset, the `Z/G` quotient stratification, and the delta to `Z⁺`.

Main document: `THEOREM.md`.

## Headline numbers

| | |
|---|---|
| stratum orbits on `Z` | **80** (1216 → 7336 → 9591 → **11 076** components over the four stages) |
| occurring point stabilizers | `1, C2, C3, V4, C5, C6, C11` — the other **9 of 16** classes certified empty |
| occurring setwise stabilizers | `C2, C3, V4, C5, C6, C11, D12, PSL(2,11)` — **8 of 16**; `A4` and `D10` occur at level 0 but **not** on `Z` |
| closure poset | 145 strict containments at `G`-orbit level |
| crossings | 19 orbits with `|I|=2` (generic stabilizer `1` or `C2`), **5 orbits of 165 with `|I|=3`** (all on `ℓ_V`-`P_σ` flags, over `A4`- and `D12`-points), all with generic stabilizer `C2` |
| `Z/G` | 80 locally closed pieces, generic fibres `G/H` |
| `Z → Z⁺` | 3 rows consumed, 3 new, 77 unchanged; the 2 new `V4` surfaces (`2 × 165 = 330`) **are** the fabulous corners |

## Exit strings

```text
TERMINUS-ORBIT-STRATA-PW-PASS
TERMINUS-STRATA-ALL-16-CLASSES-CERTIFIED
TERMINUS-CLOSURE-POSET-SEALED
TERMINUS-QUOTIENT-STRATIFICATION-COMPLETE
TERMINUS-ZPLUS-DELTA-SEALED
STANDARD-FORM-PW-5D-COUNTS-CORRECTED
```

## How to check

```
cd problems/E-klein-cubic/goal_runs_20260810/TERMINUS_STRATA_PW
python3 verifier.py                      # TERMINUS_STRATA_PW_VERIFY_OK / ALLGREEN  (~9 min)
python3 scripts/t2_orbit_strata.py       # T2_ORBIT_STRATA_OK   the census, all 4 stages
python3 scripts/t3_localmodels.py        # T3_LOCAL_MODELS_OK   42 local models + cross-checks
python3 scripts/t4_poset.py              # T4_POSET_OK          the closure poset
python3 scripts/t5_zplus.py              # T5_ZPLUS_OK          the Z -> Z+ delta
M2 --script scripts/t6_charts.m2         # T6_CHARTS_OK  18/18   exact chart checks over QQ(zeta_6)
```

Everything is python3 + Macaulay2 only; two split primes 331 and 661.

## Verification tiering — sampled vs complete, honestly

* **COMPLETE and exact (Tier 1).** The chart form of `Z` (Theorem 1), the
  tangent-weight rule (Theorem 2), the census criterion (Theorem 3), and
  everything combinatorial derived from them: smoothness and irreducibility of
  **all** crossings, rationality of **every** stratum, the closure rule, the
  poset axioms, the quotient stratification, the `Z⁺` delta bookkeeping.
* **COMPLETE over all `G`-orbits, mod `p` at two primes (Tier 2).** Every row of
  every table, at 331 and 661, with **identical row sets at every stage**.
* **PER-ROW EXPLICIT WITNESS (Tier 2+).** All 79 non-free rows: an explicit
  point of the stratum is constructed as flag data over `F_p` and its stabilizer
  computed by brute force in the 660-element group; in every case, at both
  primes, it is **exactly** the claimed `H`. This is what makes the nine empty
  classes a positive certification.
* **EXACT over `QQ(ζ_6)` (Tier 1), one representative per genre.**
  `scripts/t6_charts.m2`, **18/18**, replayed independently by hand: for each of
  the four row genres (point-, line-, plane-exceptional, and the point<line<plane
  triple crossing) it builds the blowup chart by literal successive substitution
  and checks that the substitution is monomial and unimodular; that the
  transported action is **forced** by equivariance against the geometric blowup
  map and the raw diagonal action — so Theorem 2's weight formula is tested, not
  assumed; that each `D_{S_i} = {t_i = 0}` is a divisor and the triple crossing
  `(t_1,t_2,t_3)` is prime of codimension 3; and that `Fix` in the chart has
  codimension equal to the number of nontrivial weights.
* **SAMPLED (Tier 3), flagged.**
  1. The M2 check covers **four representative genres, not all 80 rows**.
  2. The identification of `Z` with the maximal De Concini–Procesi wonderful
     model of the arrangement uses the standard chart description of those
     models as a cited theorem; the arrangement's closure under intersection
     and the resulting local models are machine-checked here.
  3. The `Z⁺` delta derives normal bundles from the graded weight bookkeeping
     rather than an independent chart, and is cross-checked against
     `DUNCAN_CORNER_F2`'s independent corner inventory.

## Relations to sibling packets

* **`STANDARD_FORM_PW`** (branch `agent/standard-form-pw-20260810`, commit
  `1430ffa` — **not on `main`**). Foundation. Everything qualitative in it is
  reproduced here independently: the 1215 divisors in 14 orbits, the **42
  terminal local models class-by-class**, the crossing table, the abelian
  floor, "no fabulous corner at the minimal terminus", the per-class dimension
  profiles.
  **ONE CORRECTION.** Its §5(d) component counts "created inside exceptional
  divisors" are **lower bounds**: `s5_terminus.py` de-duplicates on the
  signature `(stabilizer name, dim, normal rank, orbit size)` and thereby merges
  distinct `G`-orbits. Corrected: `C2 {1:1155,2:440,3:110} → {1:1320,2:605,3:110}`,
  `V4 {0:660,1:330} → {0:1155,1:330}`, `C5 396 → 1320`, `C6 330 → 1100`,
  `C11 60 → 240`; `C3` unchanged. No exit string of that packet is affected.
* **`DUNCAN_CORNER_F2`.** Nothing contradicted. `M_τ^V` appears as an ordinary
  row of this census (`C2`, dim 2, 165, `Stab_G = V4`); its 165 copies are shown
  pairwise disjoint on `Z`; the `Z⁺` delta produces exactly the 330 fabulous
  corners in 2 orbits of 165.
* **`certificates/STRATA_EXACT.md`.** Level-0 census reproduced from scratch.

## Files

```
THEOREM.md                    the main document
STATUS.md                     this file
REGISTRATION_SNIPPET.md       proposed NOTEBOOK entry + manifest record
verifier.py                   ALLGREEN gate; per-row exact-stabilizer sampling
scripts/psl211.py             packet-local model of PSL(2,11) on W (from STANDARD_FORM_PW)
scripts/sfcore.py             packet-local subgroup/character core (from STANDARD_FORM_PW)
scripts/tcore.py              NEW: the arrangement, chains, graded reps, the census engine
scripts/t2_orbit_strata.py    the census, all four stages + setwise index + quotient
scripts/t3_localmodels.py     point types (42 local models), crossings, cross-checks
scripts/t4_poset.py           the closure poset
scripts/t5_zplus.py           the Z -> Z+ delta
scripts/t6_charts.m2          exact QQ(zeta_6) chart checks, one per genre (18/18)
results/*.txt, results/*.json all outputs (no *.log: gitignore blocks it)
```

## Open threads this packet leaves

1. The census is source-side only. The obvious next step is the same census on
   the **target** `X` (or on a toroidal model of it), so that the two
   decorated complexes can be compared row-by-row under `prop:rcc_total`.
2. `Z⁺` is described only as a delta. A full `Z⁺` census would need the chain
   formalism extended by one non-linear (sub-bundle) centre.
3. The `|I| = 3` crossings (5 orbits of 165 = 825 components, all on
   `ℓ_V`-`P_σ` flags) carry generic stabilizer `C2`; `prop:rcc` gives only connectedness at `|I| ≥ 3`,
   so they carry no landing constraint — but they are the natural place to look
   if a three-branch version of (F2) is ever wanted.
