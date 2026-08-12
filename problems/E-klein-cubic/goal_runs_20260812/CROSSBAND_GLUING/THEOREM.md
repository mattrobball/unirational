# Cross-band gluing: scheme-level agreement on shared loci

**Packet:** `goal_runs_20260812/CROSSBAND_GLUING/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

> # VERDICT: **GLUING AUTOMATIC ON THE SEALED CELLS**
>
> One positive-dimensional cross-band locus orbit (the 55 lines `ℓ_V`,
> stab `A4`). Primary gluing of plus-plane `(d−1,1)` leading data along
> each `ℓ_V` has **rank 0** on the d=35 universal 37-cell and on the d=36
> 63-cell (both primes): both bands restrict to the zero section, so they
> agree without a new cut. All 22 survivors stay live at dim ≤ 37. No
> degree excluded.

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
CROSSBAND-LOCI-INVENTORY
CROSSBAND-GLUING-D35
CROSSBAND-GLUING-D36
CROSSBAND-DEPTH6-DIAGNOSTIC
CROSSBAND-NO-DEATHS-22
CROSSBAND-NO-DEGREE-EXCLUSION
```

Machine markers: `CROSSBAND_GLUING_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — both primes `p = 331, 661`).

---

## Summary (≤ 25 lines)

1. **Headline:** Problem E remains OPEN; this packet excludes no degree.
2. **Pos-dim gluing loci:** **1** `G`-orbit — the 55 lines `ℓ_V = P_σ ∩ P_τ`
   for commuting involution pairs in a `V4` (also `P_σ ∩ ℓ_V` for each of
   the three involutions). Stabilizer `A4 = N_G(V4)`, order 12.
3. **Excluded (not pos-dim):** non-commuting plane meets (points); minus-line
   pairs (points or empty); plane ∩ foreign minus-line (points); `ℓ_V ∩ L`
   (empty). Counts match FIX-A0: 165 commuting pairs, 1320 non-commuting.
4. **d=35 primary gluing on the 37-cell:** rank **0** (sat-checked, full
   orbit of 55); dim stays **37**. Mechanism: the plus-plane `(34,1)`
   leading form vanishes identically on every `ℓ_V` in the sealed Layer-0
   cell (compatible with `ord_{ℓ_V} ≥ 6`), so both bands give the zero
   section and agree automatically.
5. **The 22:** **0 dead, 22 live** at dim ≤ 37. No new closed cut.
6. **d=36 on the 63-cell:** same locus inventory; primary gluing rank **0**;
   dim stays **63** (both primes).
7. **Depth-6 diagnostic (not a kill):** bulk jets along `ℓ_V` first go
   nonzero at `t^6` in generic normal directions (sealed `r0=6`); pure
   common-normal direction stays zero through `t^7` on the cell. Recorded
   only as depth bookkeeping — not imposed as a death of the 22.
8. **Degree-general:** loci are arrangement strata (degree-independent).
   Primary gluing of the `(d−1,1)` plus-plane leading form along `ℓ_V`
   exists whenever `m=1` is forced; it is automatic on the sealed `(1,6)`
   cells. Class-dependent: jet order of bulk line data (`r0`), parity of
   minus-line rules, C5/C6/C11 structure cuts.
9. **Not claimed:** no degree exclusion; no residue-class zero; Corollary 3.4
   not armed. Depth-6 bulk observations are Tier-2 modular diagnostics.

---

## 0. Inputs (read-only)

| source | use |
|---|---|
| `STAGE1_COMPLEX_MAPS` THEOREM | census, sweep rows, closure structure |
| `theory/FIX_VII_carrier.md` §7 | arrangement assembly (lines, planes, `ℓ_V`, conics) |
| `PAIR_ATTACK_D35` | Layer-0 null `(39,637)`, universal 37-cell, 22 survivors, jet/frame |
| `D34_GUIDED_SWEEP/slicelib.py` | `jet_rows`, `build_frame`, `nullspace` |
| `D35_EXTENDED_SIEVE/results/cell37_p*.npy` | sealed 37-cell basis on the 39-slice |
| `LANDING_INVARIANT_SIDE/results/{A,C,Bcell}_d36_p*.npy` | d=36 63-cell |

Primes: **331, 661**. python3 only.

---

## 1. Inventory of positive-dimensional cross-band loci

Sweep-row closures belonging to **different** group elements' bands meet in
positive dimension only along the following orbit.

### L1 — the lines `ℓ_V` (unique pos-dim orbit)

For each of the 55 Klein four-groups `V4 = {1,σ,τ,ρ}`:

- `W|_{V4} = A ⊕ χ_σ ⊕ χ_τ ⊕ χ_ρ` (dims 2+1+1+1),
- `ℓ_V = P(A) = P(W^{V4})`,
- `P_σ ∩ P_τ = ℓ_V` (vector dim of `W⁺_σ ∩ W⁺_τ` is 2),
- `ℓ_V ⊂ P_σ` for each of the three involutions,
- `Stab_G(ℓ_V) = A4 = N_G(V4)` (order 12); orbit size `660/12 = 55`.

The three plus-plane bands `D_{P_σ}, D_{P_τ}, D_{P_ρ}` all contain the
exceptional geometry over `ℓ_V`. Pairwise shared stratum in the wonderful
model: the common-normal section (direction `χ_ρ ∈ W⁻_σ ∩ W⁻_τ` for the
pair `{σ,τ}`).

### Zero-dimensional / empty (recorded, not glued as sections)

| id | geometry | dim | reason excluded |
|---|---|---:|---|
| L2 | non-commuting `P_σ ∩ P_σ'` | 0 | point only (`W⁺` meet dim 1) |
| L3 | `L_σ ∩ L_τ` | 0 / −1 | type-I point if commuting; empty if not |
| L4 | `P_σ ∩ L_τ` | 0 / −1 | point on `E_σ` if commuting; never a line in a foreign plane |
| L5 | `ℓ_V ∩ L_τ` | −1 | always empty |

Machine census at both primes: 165 commuting pairs (plus-meet dim 2, minus-meet
dim 1); 1320 non-commuting (plus-meet dim 1, minus-meet dim 0); 55 `V4`s each
with `dim A = 2`.

---

## 2. Primary gluing condition (degree-general form)

On `ℓ_V`, for each commuting pair `{σ,τ}` with third involution `ρ`:

- plus-plane leading multidegree at forced `m = 1` is bidegree `(d−1, 1)`;
- along the common normal `y = χ_ρ` and basepoints `w ∈ A`, the leading
  value `VAL(w,y)` of `T` must land in `L_σ ∩ L_τ = P(χ_ρ)` (so the two
  row-images agree at the unique point of the target lines' meet).

Linear extraction (reuse of `slicelib.jet_rows` + frame projection as in
`PAIR_ATTACK_D35/scripts/director_worked_example.py`):

```text
VAL = [t^1] T(w + t y)          # shape (ns, 5)
frame_σ = [χ_τ | χ_ρ | W⁺_σ]
require  (VAL · frame_σ^{-1})_0  = 0     # vanish χ_τ-component
(and the symmetric τ-side condition)
```

Rigidity anchors: on the working cell, `W⁺` components of every extracted
leading value vanish (profile residual). Sampling saturation-checked
(extra points do not raise rank).

---

## 3. Results at d = 35 (universal 37-cell)

Working cell: Layer-0 nullspace dim 39, cut by the six universal flips
(rank 2) → **37**. Ambient basis `AMB = cell37 @ layer0_null` shape
`(37, 637)`.

| prime | rank (rep, sat) | rank (orbit 55) | dim after | sat ok | dead among 22 | live |
|---:|---:|---:|---:|:---:|---:|---:|
| 331 | 0 | 0 | **37** | yes | 0 | **22** |
| 661 | 0 | 0 | **37** | yes | 0 | **22** |

**Why rank 0.** Load-bearing vanish table (both primes identical in
pattern): on the 37-cell the `(34,1)` leading form has

| sample locus | rank on 37-cell |
|---|---:|
| `ℓ_V × W⁻_σ` | **0** |
| `ℓ_V × χ_ρ` (common normal) | **0** |
| generic `P_σ × W⁻_σ` | **> 0** (nonzero; m=1 exact) |

So the leading form of each plus-plane band **vanishes identically on
`ℓ_V`**, while remaining nonzero on a Zariski-open of `P_σ`. Both sides of
every cross-band pair therefore restrict to the zero section on the shared
locus and agree without imposing a new equation. Compatible with the sealed
Layer-0 cut `ord_{ℓ_V} ≥ r_0 = 6` (which forces high vanishing of bulk jets
along `ℓ_V` in all transverse directions).

**Per-cell (all 22).** Pattern-independent closed cut of rank 0:

```text
ids 5,7,13,15,21,23,29,31,37,39,45,47,53,55,61,63,69,71,697,699,701,703
each: LIVE, dim_upper = 37, mechanism = "gluing automatic"
```

No deaths. No FLAG for all-dead (the all-dead branch was not taken).

---

## 4. Results at d = 36 (63-cell)

Working cell: sealed `Bcell_d36` shape `(63, 706)` from
`LANDING_INVARIANT_SIDE` (matches D34 ladder `ALIVE:63`). Even degree: no
six-flip cut; minus-line band on, but no new pos-dim cross-band locus.

| prime | rank (orbit 55) | dim after | sat ok |
|---:|---:|---:|:---:|
| 331 | 0 | **63** | yes |
| 661 | 0 | **63** | yes |

Same automatic-vanishing mechanism for the `(35,1)` leading form on `ℓ_V`.

---

## 5. Depth-6 diagnostic (bulk line jets; not a 22-kill)

Sealed `ord_{ℓ_V} ≥ 6` forces `t^0..t^5 ≡ 0` along `ℓ_V`. On the 37-cell:

| direction class | first nonzero order | rank of that jet on 37-cell |
|---|---:|---:|
| full normal `W/A` (3-dim) | 6 | 37 (full) |
| `W⁻_σ` (2-dim) | 6 | positive |
| pure common normal `χ_ρ` | ≥ 8 (zero through t^7) | 0 |

This is bulk line-order data, **not** the plus-plane multidegree leading
form used for primary gluing. It is recorded for bookkeeping; it is **not**
imposed as a closed death of the 22 in this packet.

---

## 6. Degree-general inventory (symbolic)

**Loci (degree-independent arrangement strata):**

- Always present: L1 (`ℓ_V`, 55, stab A4) — the unique pos-dim cross-band
  support of plus-plane bands.
- Always 0-dim/empty: L2–L5 as in §1.

**Gluing conditions that exist at every degree with forced `m = 1`:**

- Primary: section agreement of the `(d−1,1)` plus-plane leading forms of
  the three involutions of each `V4` along `ℓ_V` (common-normal section).
  On every sealed `(1, r_0=6)` Layer-0 cell tested (d=35,36), this is
  automatic (rank 0) because the leading form vanishes on `ℓ_V`.

**Class-dependent:**

- Jet depth of bulk line data along `ℓ_V` (`r_0` from the cone / profile).
- Whether the minus-line band is active (`d` even ⇒ (M) on) — still no
  pos-dim cross-band locus from minus-lines.
- Structure cuts C5/C6/C11 (residue tables of STAGE2).
- Six universal flips: odd `d` only (ODDZERO).

No residue class is killed by this packet.

---

## 7. Honesty tiering

| tier | content |
|---|---|
| Tier 1 (sealed reuse) | Layer-0 dims 39/63; universal rank-2 → 37; 22 survivor ids; arrangement counts 55/165/1320 |
| Tier 2 (two-prime modular) | gluing ranks 0 at d=35 and d=36; vanish table; rigidity zero-counts; depth-6 first-nonzero orders |
| Tier 3 (diagnostic only) | bulk t^6 observations; not used as deaths |

---

## 8. Not claimed

* Problem E remains **OPEN**.
* **No degree is excluded.** d=35 stays a fight over 22 cells of dim ≤ 37;
  d=36 stays a 63-cell.
* Cross-band gluing does **not** supply a new closed cut at the primary
  (multidegree-leading) layer on the sealed cells.
* Depth-6 bulk jet remarks are **not** claimed as deaths of the 22.
* No residue-class zero; Corollary 3.4 not armed.
* Modular ranks are upper bounds on corank in characteristic 0 when
  positive; rank 0 here means the sampled conditions are dependent on the
  sealed cell (no new information), verified by saturation and dual primes.

---

## 9. Replay

```sh
cd goal_runs_20260812/CROSSBAND_GLUING
python3 scripts/run_all.py          # inventory + d35 + d36 at 331 and 661
python3 verifier.py
```

Individual:

```sh
python3 scripts/inventory.py 331
python3 scripts/gluing_d35.py 331
python3 scripts/gluing_d36.py 331
# same with 661
```

Artefacts under `results/`: `inventory_p*.json`, `gluing_d35_p*.json`,
`gluing_d36_p*.json`, `summary.json`, matrices `gluing_phi_*_p*.npy`,
`cell37_amb_p*.npy`.

---

## 10. Dependencies

| packet / theory | role |
|---|---|
| `STAGE1_COMPLEX_MAPS` | sweep-row census, bands, closure |
| `FIX_VII_carrier` §7 / FIX-A0 / FIX-A1 | arrangement incidences |
| `PAIR_ATTACK_D35` | 37-cell, 22, jet machinery, Layer-0 |
| `D34_GUIDED_SWEEP` | `slicelib`, ladder dims |
| `D35_EXTENDED_SIEVE` | sealed `cell37` |
| `LANDING_INVARIANT_SIDE` | d=36 `Bcell` |
| `LANDING_SWEEP` | d=36 anchor dim 63, even-d rules |

## Director adjudication (2026-08-12, appended before sealing)

Replayed clean: ALLGREEN. Provenance: executed by a weak-model lane
before the Fable-only rule for morphism work was instituted; the
execution is mechanically sound (verifier replayed by the director) and
the result is an honest null — this layer is now SPENT WITH NO CUT at
the current depth. Landed for the ledger's completeness, not for bite.
