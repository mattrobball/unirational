# The d = 34 window is empty: the ladder is closed through degree 34

**Packet:** `goal_runs_20260811/D34_GUIDED_SWEEP/` · opened 2026-08-11.
**Headline: Problem E remains OPEN.** This packet contains no headline claim.
It closes one window and names the next one.

The sealed ladder had `d ≤ 30` empty, `31–33` computed zero, and **`d = 34`,
`(m,r) = (1,6)`, `n = 28` as the first open window**, with the FIX-P2 profile
slice measuring `16`. `STAGE2_ODD_ORDER_PINNING` then proved several
base-locus statements that hold for *every* landing covariant of degree 34 and
that the FIX-P2 sweep never imposed. Imposing them:

```
   dim M_34 = 576
     + ord_{P_sigma} >= 1  (55 plus-planes)                        316
     + ord_{P_sigma}(T^+) >= 2                                     316    (vacuous)
     + ord_{ell_V} >= 6    (55 V4-lines, the (1,6) profile)         16    <- FIX-P2 stopped here
     + T|_{L_sigma} = 0    (55 minus-lines; 34 is even)              2    <- NEW
     + T contracts each C3-eigenline to its X^{C6} point             0    <- NEW
```

**The window closes.** Every admissible profile at `d = 34` has `m ≥ 1` and
`r ≥ 6`, so its slice sits inside the `(1,6)` slice: **all 30 profiles die at
once and degree 34 is empty.** Same cascade, same numbers, at four primes
`p = 67, 199, 331, 661`; a computed dimension `0` mod `p` is a
characteristic-zero verdict.

The same engine run degree by degree gives **`d = 35`, `(1,6)`, `n = 29` as the
new first open window**, with the fully constrained space of dimension
**≤ 39** (down from FIX-P2's 46).

## Exit ledger

```text
D34-WINDOW-EMPTY                 degree 34 admits no landing covariant (all 30 profiles)
D34-ONESIX-EMPTY                 the (1,6), n = 28 slice is zero
D34-MINUS-LINE-CUT               Prop 1.4(i) takes the slice 16 -> 2
D34-EIGENLINE-CUT                Prop 1.6 takes it 2 -> 0
LADDER-EMPTY-THROUGH-34          d <= 34 empty (31-33 re-run here, 25-30 consumed)
D35-FIRST-OPEN-WINDOW            first open window moves to d = 35, (1,6), n = 29, dim <= 39
D34-DIMENSION-LEDGER-SEALED      exact equivariant dimension bookkeeping, two paths
STAGE2-ROWS-ARE-EFFECTIVE        the new base-locus rows are not vacuous on the slice
```

Machine markers: `D34_GUIDED_SWEEP_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **72 checks, 0 failures**).

---

## 0. Set-up

```
G = PSL(2,11), |G| = 660;   W = the 5-dimensional Weil (Klein) representation;
X = {F = 0} subset P(W) = P^4,    F = sum_{i in Z/5} x_i^2 x_{i+1};   Aut(X) = G.
```

`T ∈ M_d := (Sym^d W* ⊗ W)^G` is a reduced homogeneous lift of a dominant
`G`-equivariant rational map `P(W) ⇢ X` (`STAGE2` Lemma 0.1: no character
twist, because `G` is perfect); `F ∘ T ≡ 0` (Lemma 0.2). For an involution
`σ`, `W = W⁺_σ ⊕ W⁻_σ` has dims `(3,2)`, `P_σ = P(W⁺_σ)` is the plus-plane and
`L_σ = P(W⁻_σ) ⊂ X` the minus-line; `ℓ_V = P(W^{V4})` is a V4-triple-line
(55 of each). The sealed profile of a map is `(m, r)` with
`m = ord_{P_σ}(T⁻)` (odd) and `r = ord_{ℓ_V}(T)`, line degree `n = d − r`.

---

## 1. The exact dimension ledger at d = 34

Every number in this section is **exact**: characters are evaluated in `F_P`
for `P = 400291`, which satisfies `P ≡ 1 (mod 330)` (so every root of unity of
every element order in `{1,2,3,5,6,11}` is present and `1/660` is a unit) and
`P > 5·C(38,4) = 369075` (so a dimension, an integer in `[0, 369075]`, is
determined uniquely by its residue). No floating point, no rounding, no
cyclotomic-field arithmetic.

**Two independent code paths** produce every entry (`produce_dims34.py`):

* **PATH A** — abstract character theory. The 8 conjugacy classes of
  `PSL(2,11)` with the eigenvalue weight-multisets of `W` recorded in
  `STAGE2` §0; and for the stabilisers the abstract character tables of
  `D12 = ⟨σ⟩ × S3`, `A4 = N_G(V4)`, `C6 = Stab(ℓ_w)`, `D10 = Stab(D10-point)`,
  using the sealed restriction data `W⁺ = 1 ⊠ (triv ⊕ std)`,
  `W⁻ = ε ⊠ std`, `W|_{A4} = ω ⊕ ω² ⊕ Θ`, `W^{V4} = ω ⊕ ω²`.
* **PATH B** — brute force on the explicit modular Weil frame: the 660
  matrices built from the Gauss-sum formulas, the actual subgroups located by
  centraliser/normaliser search inside them, and symmetric-power characters
  read off char polys via `χ_{Sym^k V}(g) = [t^k] 1/det(1 − t·g|_V)`.

PATH A never looks at a matrix; PATH B never looks at a character table.
**They agree on every entry** (`verifier.py` A9–A15).

Self-tests: `⟨χ_W, χ_W⟩ = 1`, `⟨χ_W, 1⟩ = 0`, and the sealed Molien row
`dim M_d = 1,0,0,2,1,2,4` for `d = 1..7`
(`certificates/exact_covariants_check.py:53`) is reproduced, as are
`dim M_25 = 189` (FIX-P1) and `dim M_36 = 706` (FIX-P2).

### 1.1 The space and the condition budget

| object | equivariant target | dim |
|---|---|---:|
| `M_34 = (Sym^34 W* ⊗ W)^G` | — | **576** |
| 55 plus-planes, `ord ≥ 1` | `(Sym^34 (W⁺)* ⊗ W)^{D12}` | 324 |
| 55 minus-lines, `ord ≥ 1` | `(Sym^34 (W⁻)* ⊗ W)^{D12}` | **18** |
| 55 V4-lines, `ord ≥ 6` | `⊕_{k<6}(Sym^k Q* ⊗ Sym^{34−k} U* ⊗ W)^{A4}` | 732 |
| 110 C3-eigenlines, contraction | `(Sym^34 (W_w)* ⊗ W/⟨p_w⟩)^{C6}` | **18** |
| 66 D10-points | `W^{D10}` | 1 |
| 110 `X^{C6}` points | `W^{C6}` | 1 |
| 55 D12-points | `W^{D12}` | 1 |
| **total condition budget** | | **1095** |

By Frobenius reciprocity a `G`-orbit of conditions imposes at most the
dimension of the *stabiliser*-equivariant target, and it suffices to impose
the condition at ONE representative of the orbit — the reduction FIX-P1 and
FIX-P2 already use for the plus-plane and the V4-line. The budget `1095`
against `dim M_34 = 576` is a bound only: the conditions overlap heavily
(`ℓ_V ⊂ P_σ`, `X^{C6} ⊂ L_σ`, `c_σ ∈ P_σ`), so the *measured* ranks below are
what decides.

### 1.2 Measured ranks (all of `M_34`, p = 67/199/331/661 agree)

| block | measured rank | budget |
|---|---:|---:|
| `(P)` plus-planes | 260 | 324 |
| `(M)` minus-lines | **16** | 18 |
| `(L)` V4-lines to order 6 | 490 | 732 |
| `(E)` C3-eigenline contraction | **18** | 18 |

`(E)` saturates its budget exactly. `(M)` has corank 2 in its budget: the
restriction `M_34 → (Sym^34(W⁻)* ⊗ W)^{D12}` is **not** surjective. `(P+)`
(`ord_{P_σ}(T⁺) ≥ 2`) adds nothing — the `σ`-parity identity of `H0-1`, the
same vacuity FIX-P2's d = 36 cascade recorded.

### 1.3 The Stage-1 window datum, reproduced and confirmed

`STAGE1_COMPLEX_MAPS` §4 records the order-0 leading-datum count

```
   N(d,m) = dim ( Sym^{d-m}(W^+)* (x) Sym^m (W^-)* (x) W^- )^{D12} ,
   N(34,1) = 397 ,
```

and draws the conclusion that *"order 0 is nowhere near rigid there; the
sieve's bite at `d = 34` must come from higher order or from the line-degree
bookkeeping, not from the sweep datum."*

The same PATH-A machinery reproduces `N(34,1) = 397` exactly, together with
the whole published sample row `N(1,1)=1, N(3,1)=4, N(3,3)=1, N(5,1)=10,
N(7,1)=19, N(34,3)=704` (`verifier.py` A18, A19). **And the prediction is
confirmed**: the plus-plane condition alone leaves `316` of `576` — no bite —
and the bite comes from the *line-degree* layer, `ord_{ℓ_V} ≥ 6` taking `316`
to `16`, and then from the two `STAGE2` line conditions taking `16` to `0`.

---

## 2. The two conditions that close the window

Both are **profile-independent** consequences of `STAGE2_ODD_ORDER_PINNING`
(Tier 1 there: exact, prime-free, no computation), and neither was imposed by
the FIX-P2 sweep.

> **(M) — the minus-lines** (`STAGE2` Prop. 1.4(i)). `d = 34` is even, so
> `T|_{L_σ} ≡ 0`: **all 55 minus-lines lie in `Bs(T)`**, with
> `ord_{L_σ}(T) ≡ d+1 ≡ 1 (mod 2)` odd.
>
> *Why it is a linear condition on `M_34`.* For `v ∈ W⁻` the minus half `T⁻`
> needs `σ`-bidegree `q = d` odd, so `T⁻|_{W⁻} = 0` automatically when `d` is
> even; `T|_{L_σ} = T⁺|_{L_σ}` then maps `P¹ ⇢ E_σ = X ∩ P(W⁺)` (genus 1),
> hence is constant, hence `D12`-fixed, hence `0` because `X^{D12} = ∅`.

> **(E) — the C3-eigenlines** (`STAGE2` Prop. 1.6). `34 ≡ 1 (mod 3)`, so each
> of the 110 `C3`-eigenlines `ℓ_w` is contracted by `T` to the **single**
> `X^{C6}`-point lying on `ℓ_w` itself.
>
> *Why it is a linear condition on `M_34`.* Every degree-`d` monomial in the
> two coordinates of `W_w` has `ρ`-weight `dw ≡ w`, so `T(ℓ_w) ⊆ W_w`
> (Lemma 1.1 — verified here as a control, see below); landing puts the image
> in `X ∩ ℓ_w`, three points, so `T|_{ℓ_w}` is constant; the constant is fixed
> by `Stab_G(ℓ_w) = C6` and `X^{C6} ∩ ℓ_w` is one point `p_w`. The condition
> imposed is therefore `ann(p_w)·T(v) = 0` for `v ∈ ℓ_w` — which is also
> satisfied in the degenerate branch `T|_{ℓ_w} ≡ 0`, so nothing is
> over-imposed.

**Control on (E).** Lemma 1.1 predicts that the functionals annihilating the
whole weight space `W_w` already vanish on *all* of `M_34`. Measured rank of
that block: **0**, at every prime (`verifier.py` C2, E2). This is a genuine
falsifiable test of the frame, the seed basis and the jet engine at once.

**Implied conditions add nothing.** The `D10`-point, the `D12`-point `c_σ` and
the two `X^{C6}` points are base points for every `d` (`STAGE2` B(D10),
B(D12), Cor. 1.5), and `c_σ ∈ P_σ`, `X^{C6} ⊂ L_t`. Adding their vanishing
blocks changes no dimension in the cascade (`verifier.py` C7) — exactly as the
containments predict.

---

## 3. The cascade at d = 34

`dim M_34 = 576`, seeds = 576 Reynolds averages of monomials certified to be a
basis by the rank of a pure-evaluation matrix.

**Profile-first** (the FIX-P2 route, then the STAGE2 rows):

| step | condition | dim |
|---|---|---:|
| 0 | `dim M_34` (exact, Molien, two paths) | **576** |
| 1 | `+ (P) ord_{P_σ}(T) ≥ 1` — 55 plus-planes | 316 |
| 2 | `+ (P+) ord_{P_σ}(T⁺) ≥ 2` | 316 |
| 3 | `+ (L) ord_{ℓ_V}(T) ≥ 6` — the `(1,6)` profile | **16** ← FIX-P2 stopped here |
| 4 | `+ (M)` 55 minus-lines in `Bs(T)` | **2** |
| 5 | `+ (E)` 110 C3-eigenlines contract | **0** |
| 6 | `+ (D10)/(D12)/(X^{C6})` base points | 0 |

**Structure-first** (no profile assumed — this row is about *every* degree-34
landing covariant, whatever its profile):

| step | condition | dim |
|---|---|---:|
| 0 | `dim M_34` | 576 |
| 1–2 | `+ (P) + (P+)` | 316 |
| 3 | `+ (M)` | 302 |
| 4 | `+ (E)` | 290 |
| 5 | `+` base points | 290 |
| 6 | `+ (L) ord_{ℓ_V} ≥ 6` | **0** |

Step 3 of the profile-first cascade reproduces FIX-P2's published
`d = 34, (m,r) = (1,6), n = 28 → 16` **exactly**, at four primes, from an
independently built frame and an independently drawn seed basis. That is the
calibration that makes steps 4–5 believable.

**Saturation control.** Re-drawing every sampled point set (a second,
independent random sample of plane pairs, line pairs, minus-line points and
eigenline points) and stacking it on top leaves the answer at `0`
(`verifier.py` C8).

**Unit controls.** `(M)` alone leaves dimension 560 — it does not kill
everything, so the pipeline is not trivially over-imposing. A deliberately
impossible condition, `ord_{ℓ_V}(T) ≥ 14`, gives dimension 0
(`verifier.py` E10, E11).

### 3.1 From `(1,6)` to all 30 profiles

The FIX-P2 corrected sieve (`n ≥ 2e`, i.e. `d ≥ 3r − 2m`) admits exactly **30**
profiles at `d = 34`, and

```
   min over the 30 admissible profiles of m  =  1 ,
   min over the 30 admissible profiles of r  =  6 .
```

(`verifier.py` B1–B4; the full list is in `results/tables.txt`.) The slice of
profile `(m,r)` is `{T : ord_{P_σ} ≥ m, ord_{ℓ_V} ≥ r}`, which for `m ≥ 1` and
`r ≥ 6` is **contained** in `{T : ord_{P_σ} ≥ 1, ord_{ℓ_V} ≥ 6}`. Intersecting
both with the profile-independent structure and using the cascade:

> **Theorem D34.** For every admissible profile `(m,r)` at `d = 34`, the space
> of `T ∈ M_34` satisfying the profile conditions together with the
> `STAGE2` base-locus conditions (M), (E), (C6), (D10), (D12) is **zero**.
> Hence **there is no dominant `G`-equivariant rational map `P(W) ⇢ X` of
> degree 34.**

Independently, the ladder engine re-runs `d = 31, 32, 33` in this packet and
gets `0` at every one (FIX-P2's rows, reproduced): **`d ≤ 34` is empty.**

---

## 4. The ladder, degree by degree

`produce_ladder.py` applies the `d`-dependent `STAGE2` rules automatically —
(M) when `d` is even; (E) as *vanishing* when `3 | d` and as *contraction to
the `X^{C6}` point of `ℓ_{dw}`* when `3 ∤ d`; `X^{C6}` vanishing unless
`d ≡ ±1 (mod 6)`; `X^{C11}` vanishing when `d` is a non-residue mod 11;
`X^{C5}` vanishing when `5 | d`; `D10`/`D12` always — then adds
`ord_{ℓ_V} ≥ r0(d)` for the minimal admissible `r0`.

| `d` | `dim M_d` | #prof | `r0` | FIX-P2 profile-only | structure-only | **both** | verdict |
|---:|---:|---:|---:|---:|---:|---:|---|
| 31 | 410 | 24 | 6 | 0 | 187 | **0** | EMPTY |
| 32 | 459 | 26 | 6 | 0 | 208 | **0** | EMPTY |
| 33 | 511 | 28 | 6 | 0 | 257 | **0** | EMPTY |
| **34** | **576** | **30** | **6** | **16** | **290** | **0** | **EMPTY** |
| 35 | 637 | 32 | 6 | 46 | 346 | **39** | alive |
| 36 | 706 | 34 | 6 | 83 | 385 | **63** | alive |
| 37 | 786 | 37 | 6 | 127 | 466 | **121** | alive |
| 38 | 865 | 39 | 6 | 173 | 527 | **151** | alive |
| 39 | 950 | 41 | 6 | 225 | 631 | **218** | alive |
| 40 | 1050 | 44 | 6 | 287 | 707 | **261** | alive |
| 41 | 1148 | 46 | 6 | 351 | 825 | **343** | alive |
| 42 | 1255 | 49 | 6 | 423 | 917 | **397** | alive |

Every degree in the table has `r0 = 6`, so the monotonicity argument of §3.1
applies verbatim at each of them.

> **`d = 35`, `(m,r) = (1,6)`, `n = 29` is the new first open window**, of
> dimension **≤ 39** — the STAGE2 rows cut FIX-P2's 46 by 7 there. Its
> congruence profile (`35 ≡ 5 mod 6`, `≡ 2 mod 3`, `≡ 0 mod 5`, `≡ 2 mod 11`)
> is the *opposite* of `d = 34`'s in every slot that mattered: the minus-lines
> are **free** (35 is odd), the `X^{C6}` pair is **swapped** rather than based,
> and the eigenline contraction goes to the *other* eigenline. What it gains
> instead: all 60 `X^{C11}` points and all 264 `X^{C5}` points are base points.
> Those are point conditions with tiny equivariant budgets, which is why they
> buy only 7 dimensions. **`d = 34` closed because it is the even, `≡ 1 mod 3`
> degree in the window — the two conditions with line-sized budgets.**

Degrees `35, 41` and `36, 42` show the same pattern; nothing in this packet
closes any of them.

---

## 5. Why a modular computation is a characteristic-zero verdict

Verbatim the FIX-P1/FIX-P2 semantics (`slicelib.__doc__`), respected
throughout. Reynolds averages of monomial seeds lie in the `O`-lattice of
`M_d`, `O = Z[ζ_33]` localised at a prime over `p` (`p ∤ 660`, so `1/|G|` is a
unit and is dropped, rescaling rows only). For the functional matrix `Φ`,

```
        rank_{O/P}(Φ mod P)  <=  rank_K(Φ) ,        K = Frac(O) ,
```

so a computed rank equal to `dim M_d` forces the same over `K`, hence over
`C`: **a computed dimension of 0 is a genuine characteristic-zero emptiness
statement.** A nonzero computed dimension is an UPPER BOUND only. Likewise,
using only a random SUBSET of the functionals of a vanishing condition can only
ENLARGE the computed kernel, so zero is decisive either way. Consequently the
`d ≥ 35` rows of §4 are upper bounds, and the `d ≤ 34` rows are theorems.

The verdict is produced at **four** primes — `67, 199, 331, 661` — from
independently built frames, and (at `p = 661`) with a random seed no producer
used. `p = 331, 661` additionally satisfy `330 | p−1`, so every element order
splits and the `C5`/`C11` blocks are `F_p`-rational there; at `p = 67, 199`
the `B(C5)` block is simply omitted, which is safe (fewer functionals).

---

## 6. Verification

```sh
python3 produce_dims34.py                # results/dimension_ledger.json
python3 produce_d34.py 67  120 90        # results/cascade34_p67.json
python3 produce_d34.py 199 120 90
python3 produce_d34.py 331 120 90
python3 produce_ladder.py 331 31 33 100 80
python3 produce_ladder.py 331 34 42 100 80
python3 verifier.py                      # 70 checks, ALLGREEN
```

Check groups: **A** the exact ledger, its two paths, and the reproduced
`STAGE1`/`FIX-P1`/`FIX-P2`/sealed-Molien figures (25), **B** the d = 34 sieve
and the monotonicity hypotheses (4), **C** the three producer runs and their
agreement (28), **D** the ladder payload (4), **E** an independent
from-scratch replay at `p = 661` with a fresh random seed, including two unit
controls (11). Total **72**, 0 failures, ~97 s.

Reference wall times (this machine): ledger 40 s; each cascade 64 s; ladder
34–42 561 s; ladder 31–33 82 s; verifier 95 s. Everything is `python3` +
`numpy`; no CAS was needed and none was used.

---

## 7. Honesty tiering

**Tier 1 — exact, prime-free.** The whole dimension ledger of §1 (integer
arithmetic in `F_P` with `P` larger than any dimension involved, two
independent paths). The monotonicity argument of §3.1. The
characteristic-zero bridge of §5.

**Tier 2 — exact modular linear algebra, replicated at four primes with
independent frames, seed bases and random samples, with saturation and unit
controls.** Every dimension in the cascade of §3 and the ladder of §4.

**Tier 3 — flagged.**

1. **The two new conditions are consumed, not re-proved.** (M) and (E) are
   `STAGE2_ODD_ORDER_PINNING` Prop. 1.4(i) and Prop. 1.6. This packet does
   not re-derive them; it re-verifies their *frame-level inputs*
   (`X^{C6} = ` the weight-`{1,5}` pair, `|Stab_G(ℓ_w)| = 6`, `X^{D12} = ∅`
   via `dim W^{D12} = 1` with the fixed point off `X`, the D10-point off `X`)
   and one *consequence* of Lemma 1.1 as a live control (rank 0). Both
   propositions use the landing condition `F ∘ T ≡ 0`; the closure is
   therefore a statement about *landing* covariants, not about `M_34` alone.
2. **`STAGE2_ODD_ORDER_PINNING` is on an unmerged branch**
   (`agent/stage2-odd-order-pinning-20260810`); only its `scripts/` are on
   `main` at the time of writing. If that packet is ever revised, this one
   must be re-adjudicated.
3. **The landing system `F(T) ≡ 0` was never assembled.** It did not need to
   be: the linear space it would have to live in is already zero. The
   Gröbner/Nullstellensatz branch of the FIX-P1 methodology is therefore
   *vacuous* at `d = 34`, not *skipped*.
4. **`r` is read as `ord_{ℓ_V}(T)`**, matching FIX-P1's `produce_slice.py`
   ("the cone order r = 6") and FIX-P2's `line_block`. This packet inherits
   that reading rather than re-deriving it from Note II.
5. **The `d ≥ 35` rows are upper bounds**, and the `39` at `d = 35` is a
   modular upper bound on the characteristic-zero dimension, not a
   construction of anything.
6. **No claim about degrees above 42** and no claim that the sequence of
   surviving dimensions has any structure.

## 8. Not claimed

* No headline. Problem E remains OPEN.
* No statement that a landing covariant exists at any degree.
* No degree above 34 is excluded, and no *lower bound* on any surviving
  dimension is claimed (a nonzero modular dimension bounds from above only).
* Nothing about the `3⁸` residual factor, the `μ`-bounds, or the `V4`/type-I
  layer named as remainders by `STAGE2` §11.
* No re-derivation of `d ≤ 30` (consumed from `FIX-P2-SWEEP2-EMPTY-THROUGH-30`)
  or of `FIX-P1-WINDOW-25-EMPTY`.

## 9. Dependencies

| import | used for | grade |
|---|---|---|
| `STAGE2_ODD_ORDER_PINNING` (branch `agent/stage2-odd-order-pinning-20260810`) | Prop. 1.3, 1.4(i), 1.6, Cor. 1.5, B(D10), B(D12), Lemma 1.1 | **consumed**; frame-level inputs and one Lemma-1.1 consequence re-verified here |
| `FIX_P2_GATEWAY_D36` | `slicelib.py`, `p2lib.py` (copied verbatim), the corrected sieve `n ≥ 2e`, the `d = 34` baseline `16` | libraries copied; the baseline **reproduced independently at four primes** |
| `FIX_P1_DEGREE25_GUIDED` | the profile-slice methodology, the `(m,r)` cell table, `dim M_25 = 189` | methodology reused; `dim M_25` reproduced |
| `theory/FIX_H1_coupling.md` §8 (Correction H1-D) | `d ≥ 3r − 2m`, cutoff `d ≤ 30`, window `d = 34` | consumed as corrected |
| `certificates/exact_covariants_check.py:53` | the sealed Molien row `d = 1..7` | **reproduced independently, twice** |
| `STAGE1_COMPLEX_MAPS` (branch) §4 | the `(34,1)` leading-datum space is 397-dimensional | **reproduced independently** (see §1.3); its *prediction* is confirmed |

## 10. Named remainders

1. **`d = 35`, `(1,6)`, `n = 29`, `dim ≤ 39`** — the new first open window.
   The obvious next move is the layer-`k` equalizer (`H1-C`'s "high vanishing
   at the D12-orbit is a universal evasion channel") applied to that 39, or a
   second-order datum at the `X^{C11}`/`X^{C5}` base points, which at `d = 35`
   are forced but only point-sized.
2. **`d = 36`, `dim ≤ 63`** — the degree where `3 | d` puts all 110
   `C3`-eigenlines in the base locus and `d` even puts all 55 minus-lines
   there, yet the slice only drops `83 → 63`. Worth understanding: the
   line-sized budgets are being spent almost entirely inside the profile
   conditions already.
3. **The corank-2 gap in `(M)`.** The restriction
   `M_34 → (Sym^34(W⁻)* ⊗ W)^{D12}` has rank 16 against a budget of 18. Which
   two `D12`-isotypic pieces are missed, and whether that is a `d`-independent
   phenomenon, is not determined here.
4. **Degrees `> 42`** are untouched.
