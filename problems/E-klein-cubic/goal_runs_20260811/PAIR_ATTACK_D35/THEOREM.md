# The pair attack at d = 35: r-side compiler over the classified patterns

**Packet:** `goal_runs_20260811/PAIR_ATTACK_D35/` · opened 2026-08-11.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

A pair `(T, r)`: `T ∈ M_35 = (Sym³⁵ W* ⊗ W)^G` a reduced landing tuple
(map-level, `d_min = 35`; `dim M_35 = 637`), `r` one of the 756 corrected
σ-band boundary patterns at residue `5 (mod 6)`. The attack: for each `r`,
compile the linear conditions `r` forces on `M_35` together with the sealed
degree-35 cuts, and decide the cell — empty or a surviving slice.

Everything here is **map-level**. No degree is excluded. Any all-dead linear
outcome is flagged, not claimed; the window statement stays "first open
window `d = 35`" until an ODDZERO-standard adversarial audit promotes it.

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
PAIR-ATTACK-D35-LAYER0-REPRODUCED
PAIR-ATTACK-D35-PATTERNS-756
PAIR-ATTACK-D35-HIERARCHICAL-COMPILER
PAIR-ATTACK-D35-SURVIVORS-OR-ALLDEAD-FLAG
PAIR-ATTACK-D35-NO-DEGREE-EXCLUSION
```

Machine markers: `PAIR_ATTACK_D35_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — both primes `p = 331, 661`).

---

## 0. Inputs consumed (read-only; not rewritten)

| source | used for |
|---|---|
| `D34_GUIDED_SWEEP` ladder / `produce_ladder.py` | sealed cut list; target dim ≤ 39 at `d = 35` |
| `STAGE2_ODD_ORDER_PINNING` THEOREM §§1.3, 1.5, 4 | B(C5), B(C11), Prop 1.6, Cor 1.5, residue table |
| `STAGE2_SECOND_ORDER` | `μ ≥ 2` at A4-points |
| `STAGE1_STRATIFIED` scripts | regenerate `K(5) = 756` patterns |
| `theory/CONSTRAINT_ADDITIONS_20260811.md` C4, C6, C13 | imposition order |
| `RT_ACTUAL_LANDING/D35_BRANCH_TABLE.md` | cite only: 27 open T-cells; `d' ∈ {2,3,4,5}` dead |
| `GLOBAL_COHERENCE/results/vectors_d35.json` | Layer-2 odd-order menus at `d = 35` |

Residues of 35: `5 (mod 6)`, `0 (mod 5)`, `2 (mod 11)`, `2 (mod 3)`.

Route filters (handoff §2): no factoring through V14; central-character ledger
(spin→spin only at odd `d`); Duncan imports by label only.

---

## 1. Layer 0 — r-independent sealed cuts (reproduce ≤ 39)

On `M_35` (dim 637, exact Molien — `D34_GUIDED_SWEEP/results/dimension_ledger.json`):

**Profile-independent STAGE2 structure** (`produce_ladder.structure_blocks` at
`d = 35`):

| rule | at `d = 35` | citation |
|---|---|---|
| (P) plus-plane `ord ≥ 1`, `ord(T⁺) ≥ 2` | always | STAGE2 Prop 1.3 |
| (M) minus-lines in `Bs` | **off** (35 odd) | Prop 1.4(i) |
| (E) C3-eigenline contraction | to `X^{C6}` on **other** line (`35 ≡ 2 mod 3`) | Prop 1.6 |
| (C6) both `X^{C6}` based | **off** (`35 ≡ 5 mod 6`: swap) | Cor 1.5 |
| (C11) all 60 points based | **on** (35 non-residue mod 11), `μ ≥ 1` | B(C11) §1.3 |
| (C5) all 264 points based | **on** (`5 ∣ 35`) | B(C5) §1.3 |
| (D10)/(D12) | always | B(D10)/B(D12) |

**Profile:** `(m, r) = (1, 6)` — the minimal admissible FIX-P2 cell; every
admissible profile at `d = 35` has `m ≥ 1`, `r ≥ 6`, so is contained in this
slice (D34 monotonicity).

**A4 `μ ≥ 2`:** jet order ≥ 2 at both A4-points on `ℓ_V` (STAGE2_SECOND_ORDER).

**C13:** automatic for Reynolds `G`-covariant seeds (complete orbit support).

**C4 / C6:** deferred to the survivor jet stage. C4's first polar identity is
bilinear in `(T, dT)` until `F(T) = 0`; C6 is the tangent space at a candidate
point of the landing scheme (`CONSTRAINT_ADDITIONS` imposition order).

### 1.1 Reproduction (STOP rule)

| prime | profile-only | structure-only | **structure + (1,6)** | + A4 `μ≥2` |
|---:|---:|---:|---:|---:|
| 331 | 46 | 375 | **39** | 39 |
| 661 | 46 | 375 | **39** | 39 |

Sealed target: `D34_GUIDED_SWEEP` ladder row `d = 35`,
`dim_structure_plus_(1,r0) = 39`, verdict `ALIVE:39`. **Reproduced exactly at
both primes.** No STOP.

(Structure-only differs slightly from D34's 346 under coarser sampling —
sampling only enlarges the kernel; the decisive both-cut is exact.)

---

## 2. The 756 patterns

Regenerated via `STAGE1_STRATIFIED` stratified full-flag tables at residue 5:

```
total = 23 · IMM1 · 756 ,     IMM1 = 6⁸ · 4¹⁰ · 5⁴ ,
```

and 756 is the solution count of the largest (51-row) block of the multi-valued
constraint graph. Enumerated explicitly (`scripts/patterns_r5.py`); each
pattern tagged with every compatible full-flag multidegree class.

Full-flag multidegree classes at `d = 35` (lift of residue-5 classes):

| row | dims | classes `(a₀, a₁)` | D_P order `m` / D_L slot |
|---|---|---|---|
| `D_{P_σ}` | 3+2 | `(34,1)`, `(32,3)`, `(30,5)` | `m ∈ {1,3,5}` |
| `D_{L⁻_σ}` | 2+3 | `(35,0)`, `(33,2)`, `(31,4)` | slot `∈ {35,33,31}` |

---

## 3. Layer 1 — hierarchical prune on full-flag leading data

Architecture: **never** the flat product `756 × D10 × F_odd`. Tree:

1. Shared Layer-0 nullspace (dim 39).
2. Branch on D_P multidegree class `m` (shared order-blocks).
3. Within each live `m`, branch on value fingerprints (group by coherent
   full-flag compatibility); kill zeros immediately.
4. A pattern survives the multidegree cut iff at least one compatible class
   has positive kernel.

### 3.1 Multidegree cut (the load-bearing observation)

Imposing `ord_{P_σ} ≥ m` on the Layer-0 slice (both primes):

| `m` | dim after order cut | patterns with `min_m = m` |
|---:|---:|---:|
| 1 | **39** (already in Layer 0) | **420** alive |
| 3 | **0** | 252 dead |
| 5 | **0** | 84 dead |

So every `T` in the sealed working slice has **exact** plus-plane order
`m = 1`. Patterns whose only compatible D_P classes have `m ∈ {3,5}` die
here (336 total). Patterns compatible with `m = 1` (420) survive with
slice dimension ≤ 39.

### 3.2 Value conditions (deferred)

Pointwise value conditions require evaluating the bihomogeneous leading form
at STAGE1 child coordinates (`kid["qs"]`) in a frame aligned with the D34
Weil frame. A global annihilator against every assigned *image* value is
**unsound** (forces the leading form into the intersection of many lines,
hence zero). This packet records value fingerprints per group (12 groups at
residue 5) for frame-aligned follow-up and does **not** further cut the
T-slice on values.

---

## 4. Layer 2 — D10 + odd-order (GLOBAL_COHERENCE)

`goal_runs_20260811/GLOBAL_COHERENCE/results/vectors_d35.json` is present.

Consumed:

| quantity | value | source |
|---|---:|---|
| `K(5)` | 756 | STAGE1_STRATIFIED / this packet |
| `F_odd(35)` | 36 252 160 | vectors_d35 |
| `G(35)` (worker) | 315 176 279 040 | vectors_d35 |
| `G_corrected(35)` | 630 352 558 080 | G_table_corrected.txt |

Per-centre menus (symbolic eigenpoint labels): C11 (10), C5a (4), C5b (4),
D10 (4), A4a (238), A4b (238). Joint 22-row vectors = cartesian product.

**T-side linear layer:** the sealed base-locus already forces the C5/C11/D10
points into `Bs(T)` and A4 `μ ≥ 2`. The symbolic menus refine *which* residual
value a non-undefined row takes; matching them to frame coordinates is a
realization test on survivors, not an ambient linear cut. D10 `μ₀`-parity
selects the E/L branch of the C2-line — both remain open on the T-linear
layer. The tree only shrinks under a future geometric join.

---

## 5. Survivors

| prime | Layer-0 dim | L1 dead (m-class) | L1 alive | survivor dims | all-dead? |
|---:|---:|---:|---:|---|---|
| 331 | 39 | 336 | **420** | `{39}` | no |
| 661 | 39 | 336 | **420** | `{39}` | no |

Survivors: the 420 patterns with a compatible D_P class of order `m = 1`,
each carrying the Layer-0 nullspace (dim ≤ 39) as slice basis (shared across
the `m = 1` groups). Ranked by dimension: all equal at the upper bound 39.
Machine list: `results/survivors_p*.json`; bases: `results/surv_basis_m1_*.npy`.

No exclusion claimed. The list is the deliverable for realization tests
(value linearization after frame alignment; then C1–C3, C5 foliation,
dominance algebra C3).

**RT intersection (cite only).** T-side has 27 open cells
(`D35_BRANCH_TABLE.md`); `d' ∈ {2,3,4,5}` and `k ∈ {32,33}` excluded. This
packet is r-side; no re-derivation of their cells. Any survivor `T` must still
land in one of their 27 open cells.

---

## 6. Honesty tiering

| claim | tier |
|---|---|
| `dim M_35 = 637` | exact Molien (char-free) |
| Layer-0 dim = 39 at both primes | modular upper bound; matches sealed; 0 would be char-0 |
| `m ∈ {3,5}` kills the slice | modular upper bound 0 ⇒ char-0 emptiness of those order cuts |
| survivor dims | modular **upper bounds** only |
| all-dead (if any) | modular; flagged not claimed; needs ODDZERO-audit for promotion |
| no degree excluded | mandatory framing |

---

## 7. Not claimed

- No degree exclusion above the sealed cutoff `d ≤ 34`.
- No transport / tuple-level pairing
  (`theory/EXCLUSION_TRANSPORT_20260811.md` §6 is out of scope: map-level).
- No claim that a survivor realises a dominant map (landing `F(T) = 0` and
  dominance algebra C3 are next).
- No re-derivation of RT T-side cells.
- C4 polar tower and C6 tangent space not imposed as ambient linear cuts
  (deferred; see §1).

---

## 8. Verification

```sh
python3 scripts/layer0_base.py 331
python3 scripts/layer0_base.py 661
python3 scripts/compile_tree.py 331
python3 scripts/compile_tree.py 661
python3 verifier.py
```

Check groups: **A** slice-dimension vs sealed ≤ 39; **B** anchor replays of
every sealed constraint (file+section); **C** per-layer counts; **D**
cross-prime; **E** ≥ 20 random dead branches and EVERY survivor.

---

## 9. Reproduction commands and artefacts

| path | content |
|---|---|
| `results/layer0_p{331,661}.json` | Layer-0 dimensions and rules fired |
| `results/layer0_null_p*.npy` | Layer-0 nullspace basis |
| `results/patterns_r5_p*.json` | 756 patterns + tags |
| `results/death_stats_p*.json` | per-layer death table |
| `results/survivors_p*.json` | survivor list (or empty) |
| `results/surv_basis_*.npy` | slice bases for live groups |
| `results/verifier_output.json` | verifier totals |

## 10. Director adjudication (2026-08-11, appended before sealing)

1. **Base slice.** The sealed `≤ 39` is reproduced as exactly 39 at both
   primes from the D34-ladder citation trail; the workorder's STOP rule was
   not triggered. The A4 `μ ≥ 2` layer imposes nothing new on the slice —
   consistent with the D34 ladder having consumed it.
2. **The multidegree kill is sound.** For the 336 patterns with
   `m ∈ {3, 5}` the forced order cuts have full rank modulo both primes;
   modular full rank implies characteristic-0 emptiness (the sound
   direction of the modular inference — the packet's Tier table says this
   correctly).
3. **The deferral, adjudicated.** §3.2's reframing of the child-value
   conditions as "realization tests on survivors" understates them: after
   the STAGE1 σ-frames are aligned with the D34 Weil frame, each child
   evaluation is a linear functional on the multidegree block, so the
   value assignments of `r` ARE ambient linear cuts. The deferral is
   accepted as honest scoping (the worker refused to impose unsound
   global annihilators — right call), and the alignment derivation is
   queued as the next work unit. Until it lands, **420 is an upper census
   of live `m = 1` cells under a sieve strictly weaker than the brief**,
   not a survivor count of the full pair attack. No cell is decided
   beyond the 336 dead.
4. **GLOBAL_COHERENCE consumption.** The consumed `vectors_d35.json` is
   invariant under that packet's §13 director correction (mod-5 collapse,
   audited there), so no re-run is needed on that account.
5. **Director replay:** `python3 verifier.py` from a clean shell —
   1754 checks, 0 failures, both primes
   (`PAIR_ATTACK_D35_VERIFY_OK` / `ALLGREEN`); replay log archived at
   `results/replay_director_stdout.txt`.

## 11. Director addendum (2026-08-11, same day): the value layer, engaged

Supersedes the deferral recorded in §3.2/§10.3. The director derived the
frame alignment and imposed the value layer directly; full plain-language
account and check instructions in `WORKED_EXAMPLE.md`; script
`scripts/director_worked_example.py`; results
`results/worked_example_p{331,661}.json`. Summary, identical at both
primes:

1. The six forced flips have rank 2 on the 39-dim slice: every live cell
   is at most 37-dimensional. (Anchors: 3 822 rigidity zeros; 702 profile
   zeros; ambient rank exactly 2 = the sealed ODDZERO corank.)
2. Pattern 0 imposed end to end (rid-1 row): its flip demands cut to 36;
   ALL its keep demands fail identically — DEAD.
3. Pattern-independent: at 14 of the 18 value-defined rid-1 rows the
   level-0 reading vanishes identically on the slice — keeping is
   impossible there for every candidate.
4. Census over all 756 stored patterns: 336 dead by multidegree (§3),
   420 dead by impossible keeps, **0 alive at this layer**.

**FLAGGED, NOT CLAIMED** (campaign rule §G): the all-dead census is
window-closure-adjacent. Promotion gate: an ODDZERO-standard adversarial
audit that (a) repairs the tagged-table nondeterminism this work exposed
(pattern-to-demand linkage must be by content, not index — the defect is
recorded in `WORKED_EXAMPLE.md` §4.1), (b) independently rebuilds the
14-row vanishing table, and (c) rebuilds the blueprint enumeration with
the forced-deeper rows imposed, deciding whether deeper coherent patterns
exist at d = 35 or the window closes. The headline stays: Problem E
remains OPEN; no degree is excluded by this packet.
