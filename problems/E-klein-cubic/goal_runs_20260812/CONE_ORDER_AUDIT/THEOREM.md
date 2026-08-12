# Cone-order audit: `ord_{ℓ_V}(T) ≥ 6` for every landing covariant

**Packet:** `goal_runs_20260812/CONE_ORDER_AUDIT/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

> # VERDICT: **CONFIRMED-AT-GENERAL-DEGREE**
>
> The sealed local statement (FIX-N2 Theorem A + H0-1 + cone) forces
> `ord_{ℓ_V}(T) ≥ 6` for every landing covariant at every degree. Independent
> modular filtration at `d ∈ {31,…,42}` (all residues mod 6), primes
> `331` and `661`, finds **no landing witness with `r < 6`**, reproduces the
> D34 ladder anchors, and shows that the *linear* structure space still has
> room at exact orders `r = 2..5` (non-landing; `F(T)=0` not imposed). The
> workorder's parenthetical "dim(ord≥r)=dim(ord≥6) in the structure space" is
> **false** and is not what the premise asserts.

## Summary (≤ 20 lines)

1. **Sealed statement (verbatim, FIX-N2 Theorem A):** for `r ∈ {2,3,4,5}` there is no `A₄`-equivariant simultaneous landing family with common plane order `≥ 1` and triple-line order `r`, in any line degree.
2. **Bridge:** H0-1 forces `m` odd and `m ≥ 1` on every landing tuple; cone forbids `r ≤ 1`; propagation empties `(3,5)` and higher bottom cells; for `m ≥ 5` cone already gives `r ≥ 8`. Hence **every landing tuple has `r ≥ 6`**.
3. **Level (transport §5–6):** **tuple** — applies to every landing tuple (not only reduced maps); restriction of a `G`-equivariant landing tuple to the formal neighbourhood of `ℓ_V` is an `A₄`-equivariant landing family.
4. **Machine (both primes, `d = 31..42`):** exact-order upper bounds for `r = 2..5` inside STAGE2-structure + plane are **positive** at every degree; `ord ≥ 6` dims match D34 (`0` for `d ≤ 34`; `39,63,121,151,218,261,343,397` for `35..42`); saturation stable; random low-order samples all fail `F(T(v))=0` at probe points.
5. **Not a refutation:** positive linear cells are non-landing room. A refutation would need an explicit landing `T` with `ord_{ℓ_V}(T) < 6` — none found.
6. **Windows:** `r0(d) = 6` for all `d ∈ [31,42]`; scoping every window by `r ≥ 6` remains justified.

## Exit ledger

```text
CONE-ORDER-CONFIRMED-AT-GENERAL-DEGREE
CONE-ORDER-SEALED-THEOREM-A-QUOTED
CONE-ORDER-LEVEL-TUPLE
CONE-ORDER-LINEAR-CELLS-R2TO5-NONEMPTY
CONE-ORDER-NO-LANDING-WITNESS-R-LT-6
CONE-ORDER-D34-ANCHORS-REPRODUCED
CONE-ORDER-R0-EQUALS-6-ALL-D
CONE-ORDER-NO-DEGREE-EXCLUSION
```

Machine markers: `CONE_ORDER_AUDIT_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py`).

---

## 1. Provenance — sealed statement and proof, quoted

### 1.1 The statement that forces `r ≥ 6` for landing families

Source: `goal_runs_after_fc5e2d3/FIX_N2_CELL_CLASSIFICATION/CELL_TABLE.md` §4.1
(also `STATUS.md` "Proved" item 3; adopted into `theory/FIX_II_jets.md` §4 cell table).

> **Theorem A.**  For `r = 2, 3, 4, 5` the only `C_3`-equivariant pointwise
> tuple of degree `r` in `J_1` with `F = 0` is zero, for each of the three
> projective scalars `lam in mu_3`.  Hence **no `A_4`-equivariant simultaneous
> landing family with common plane order `>= 1` and triple-line order
> `r in {2,3,4,5}` exists, in any line degree.**

Certified in that packet by three independent engines (Macaulay2 `dim I = 0`;
Macaulay rank over `F_100057`; msolve coordinate-saturation). Consequences
listed there: cells `(1,2),(1,3),(1,4),(1,5),(2,3),(2,4),(2,5),(3,5)` EMPTY
at all line degrees.

### 1.2 Cone bound (Note II Lemma 2.1), quoted

Source: `theory/FIX_II_jets.md` §1.

> **Lemma 2.1 (order cone).** For any monomial `x₁^{α₁}⋯x_k^{α_k}` in the
> normal coordinates,
>
> ```
> Σ_{i=1}^{k} ord_{P_i} = (k−1) · ord_R ,
> ```
>
> … if the common plane order is `≥ m` then
>
> ```
> ord_R ≥ ⌈ k·m / (k−1) ⌉   —   for k = 3:  ord_R ≥ ⌈3m/2⌉ = (3m+1)/2  (m odd).
> ```

### 1.3 Propagation (Note II Lemma 2.4 / FIX-N2 Lemma C'), quoted

> **Lemma C' (emptiness shift).**  If `r <= 2m` then
> `(J_{m+2})_{r+3} = xyz * (J_m)_r`, and therefore `(m,r)` is empty (all line
> degrees) **iff** `(m+2,r+3)` is.

So `(1,2) → (3,5) → (5,8) → …` all empty.

### 1.4 How the windows consume this

`D34_GUIDED_SWEEP/THEOREM.md` Tier note 4 (honest inheritance, not re-derivation):

> 4. **`r` is read as `ord_{ℓ_V}(T)`**, matching FIX-P1's `produce_slice.py`
>    ("the cone order r = 6") and FIX-P2's `line_block`. This packet inherits
>    that reading rather than re-deriving it from Note II.

`produce_ladder.py` hard-codes the empty cells and takes
`r0(d) = min r` over admissible profiles — always `6` for `d ∈ [31,42]`.

FIX-P1 `produce_slice.py` docstring (the phrase Tier note 4 cites):

> ```
> (B)  ord_{ell_V}(T)   >= 6   at every one of the 55 V4-triple-lines
>      [the cone order r = 6].
> ```

### 1.5 Level classification (transport note §5–6)

Per `theory/EXCLUSION_TRANSPORT_20260811.md` §5–6:

| claim | level | reason |
|---|---|---|
| FIX-N2 Theorem A (local cell emptiness) | **tuple** on germs | about any `A₄`-equivariant landing family, including germs of imprimitive global tuples |
| H0-1 parity / plus-planes in base locus | **tuple** | transport table: "module vanishing" |
| cone bound `r ≥ (3m+1)/2` | **tuple** | pure incidence on any multi-order |
| **composite: every landing covariant has `ord_{ℓ_V} ≥ 6`** | **tuple** | composition of the three; transports under invariant multiplication |

Not map-level: no reduction to coprime coordinates is used. Content
`T = c·T°` can only *raise* orders, so the bound survives imprimitivity.

---

## 2. Independent machine verification

### 2.1 Method

For each `d ∈ {31,…,42}` and each prime `p ∈ {331, 661}`:

1. Build a Reynolds basis of `M_d` (rank of pure-evaluation matrix = sealed
   `dim M_d`).
2. Impose STAGE2 structure (minus-lines when even; C3-eigenline
   vanish/contract by `d mod 3`; D10/D12/C6/C11/C5 points by congruence) plus
   plane conditions `(P)/(P+)` at `m = 1`.
3. Compute line jets along one `ℓ_V` to order 6; rank-compare
   `dim(structure + ord ≥ r)` for `r = 0..6`.
4. Exact-order upper bound: `dim(≥r) − dim(≥r+1)` for `r = 0..5`.
5. Saturation: second independent line-pair sample at `ord ≥ 6`.
6. Landing probe: random seed-combos with measured line-order lower bound
   `< 6`; evaluate `F(T(v))` at random points. `F ≠ 0` certifies non-landing
   (safe direction only).

Semantics: `slicelib.__doc__` — modular dim `0` is char-0 empty; nonzero is an
upper bound; sampling functionals only enlarges the kernel.

### 2.2 Degree sweep table (both primes agree on every `ord ≥ 6` entry)

Exact-order columns are **upper bounds** on the dimension of the structure
space at that exact order (differences of modular upper bounds). The
`ord ≥ 6` column is decisive when zero.

| `d` | `d mod 6` | `dim M_d` | struct `≥0` | exact `r=0..5` (p=331) | `ord ≥ 6` | p=661 |
|---:|---:|---:|---:|---|---:|---|
| 31 | 1 | 410 | 187 | 0,0,20,51,80,36 | **0** | **0** |
| 32 | 2 | 459 | 208 | 0,0,21,53,85,49 | **0** | **0** |
| 33 | 3 | 511 | 257 | 0,0,22,55,90,90 | **0** | **0** |
| 34 | 4 | 576 | 306 | 15,1,23,59,95,113 | **0** | **0** |
| 35 | 5 | 637 | 375 | 19,10,24,61,100,122 | **39** | **39** |
| 36 | 0 | 706 | 431 | 21,25,25,63,105,129 | **63** | **63** |
| 37 | 1 | 786 | 528 | 15,30,49,67,110,136 | **121** | **121** |
| 38 | 2 | 865 | 589 | 21,31,59,69,115,143 | **151** | **151** |
| 39 | 3 | 950 | 691 | 21,32,79,71,120,150 | **218** | **218** |
| 40 | 4 | 1050 | 767 | 23,33,92,76,125,157 | **261** | **261** |
| 41 | 5 | 1148 | 887 | 19,34,97,100,130,164 | **343** | **343** |
| 42 | 0 | 1255 | 974 | 25,35,100,109,137,171 | **397** | **397** |

Saturation at `ord ≥ 6` was stable at every degree and both primes.
Landing probe: at every degree, all 8 low-order samples had `F(T(v)) ≠ 0`
at some probe point (no candidate landing with `r < 6`).

### 2.3 What the table says about the premise

* **Linear structure cells with `r ∈ {2,3,4,5}` are nonempty** (positive
  upper bounds) at every tested degree. The workorder's operational gloss
  "dim(ord≥r) = dim(ord≥6) for r < 6" is **false** for the structure space.
  That gloss is not the premise: structure alone does not encode
  `F(T) ≡ 0`.
* **Landing cells with `r < 6` remain empty** by the sealed local theorem;
  the modular global check finds no counterexample and kills every probed
  low-order sample by `F ≠ 0`.
* **Window anchors match D34 exactly** on the `ord ≥ 6` slice (the column
  the windows actually use).

### 2.4 Sieve check

With the FIX-P2 corrected bound `n ≥ 2e` and the sealed empty-cell list, every
`d ∈ [31,42]` has minimal admissible `r0 = 6`. Reproduced in
`scripts/verifier.py` group B.

---

## 3. Verdict

**CONFIRMED-AT-GENERAL-DEGREE.**

The premise that scopes every window — every landing covariant has
`ord_{ℓ_V}(T) ≥ 6` along the 55 V4-triple-lines — is:

1. **proved** at the local cell level by the sealed FIX-N2 Theorem A (quoted
   §1.1), with the H0-1 / cone / propagation bridge (§1.2–1.3);
2. **tuple-level** under the transport discipline (§1.5);
3. **machine-consistent** at general degree across all residues mod 6 and two
   primes (§2): no landing witness with `r < 6`, D34 anchors reproduced,
   `r0 = 6` universal in the window range.

**Not claimed as refuted:** positive linear exact-order cells for `r = 2..5`
are expected non-landing room. **Not a provenance gap:** the sealed proof
exists and is quoted verbatim. **No degree is excluded** by this packet.

---

## 4. Honesty tiering

**Tier 1 — sealed, quoted, not re-proved here.** FIX-N2 Theorem A; Note II
Lemmas 2.1 and 2.4 / Lemma C'; H0-1 as used by the window cascade.

**Tier 2 — exact modular linear algebra, both primes, saturation.** The
filtration table of §2.2; D34 anchor reproduction; sieve `r0 = 6`.

**Tier 3 — flagged.** Landing probe uses random point samples of `F(T(v))`
only (safe for non-landing certificates; never a landing certificate). The
packet does not re-run the three FIX-N2 engines.

---

## 5. Not claimed

* No headline. Problem E remains OPEN.
* No degree is excluded; no surviving dimension is claimed from below.
* No claim that the linear structure space forces `ord ≥ 6`.
* No re-proof of FIX-N2 Theorem A.
* Nothing about cells with `r ≥ 6` being empty or populated as maps.

## 6. Replay

```sh
cd goal_runs_20260812/CONE_ORDER_AUDIT
python3 scripts/produce_sweep.py 331 31 42 80 60
python3 scripts/produce_sweep.py 661 31 42 80 60
python3 verifier.py
```

Wall time (this machine): ~22 min per prime for the full sweep; verifier ~30 s.

## 7. Dependencies

| import | role |
|---|---|
| FIX-N2 `CELL_TABLE.md` / `STATUS.md` | Theorem A (quoted) |
| `theory/FIX_II_jets.md` | Lemma 2.1, cell table, inheritance trail |
| `theory/EXCLUSION_TRANSPORT_20260811.md` §5–6 | level discipline |
| D34 `slicelib` / `p2lib` / `d34lib` (copied into `scripts/`) | jet engine, STAGE2 blocks |
| D34 ladder table | anchors for cross-check |

## Director adjudication (2026-08-12, appended before sealing)

Replayed from a clean shell: ALLGREEN. Accepted as delivered.
Specific notes: the worker's rejection of the workorder's test gloss
(structure-space dims do NOT collapse for r < 6; the emptiness is
landing-conditional, exactly FIX-N2's content) is correct and recorded as
a director-brief error. The tuple-level classification is entered in the
transport note's §6 table: cone-order-based exclusions transport.
