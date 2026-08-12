# Stage 2, first computation: the odd-order rows are pinned by degree congruences

**Packet:** `goal_runs_20260810/STAGE2_ODD_ORDER_PINNING/` · opened 2026-08-11.
**Headline: Problem E remains OPEN.** This packet contains no headline claim and
**excludes no degree**.

What it does: it takes the `1.1 × 10¹⁵` coherence-immune factor that
`STAGE1_COMPLEX_MAPS` §15.5 isolated — the 22 rows of the terminus `Z` whose
exact stabiliser has odd order, on which order-0 theory has nothing to say — and
**pins it by exact character arithmetic**. Fourteen of the 22 rows collapse to a
*single* value determined by `d mod 5`, `d mod 11` and the local jet order; the
other eight collapse from six values to three. The immune factor drops from

```
   6⁸ · 4¹⁰ · 5⁴ = 1 100 753 141 760 000     to      3⁸ = 6 561 ,
```

a reduction by exactly `2²⁸ · 5⁴ = 167 772 160 000`.

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
STAGE2-ODD-ORDER-PINNING-SEALED
STAGE2-IMMUNE-FACTOR-COLLAPSED
STAGE2-BASE-LOCUS-CONGRUENCES-SEALED
STAGE2-C11-QUADRUPLE-OBSTRUCTION
STAGE2-MINUS-LINE-PARITY
STAGE2-NO-DEGREE-EXCLUSION
STAGE2-FIRST-ORDER-CHARACTER-TABLE
```

Machine markers: `STAGE2_ODD_ORDER_PINNING_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **95 checks, 0 failures**, at `p = 331` and `p = 661`).

`STAGE2-NO-DEGREE-EXCLUSION` is a **negative** exit: the congruence system is
consistent for every one of the 165 residues. No window closes. It is recorded
because the brief asked the question and because it independently confirms the
repository's own adjudication of the unsealed external "mod-330 degree sieve"
(`COMBINED_DEGREE_SIEVE/CONSTRAINT_LEDGER.md` B1/B2, EXCLUDED).

---

## 0. Set-up, and the one normalisation everything rests on

```
G = PSL(2,11), |G| = 660;   W = the 5-dimensional Klein representation;
X = {F = 0} ⊂ P(W) = P⁴,    F = Σ_{i ∈ Z/5} x_i² x_{i+1};   Aut(X) = G.
```

Let `φ : P(W) ⇢ X` be **any** dominant `G`-equivariant rational map and let
`T = (T_0,…,T_4)`, `T_i ∈ Sym^d W*`, be a reduced homogeneous lift (no common
factor). Two facts fix the bookkeeping.

> **Lemma 0.1 (no character twist).** `T(g·v) = g·T(v)` for all `g ∈ G`, i.e.
> `T ∈ (Sym^d W* ⊗ W)^G` exactly.
>
> *Proof.* Equivariance of `φ` gives `T(gv) = c(g)·g·T(v)` for a function
> `c : G → C*`; associativity forces `c(gh) = c(g)c(h)`, so `c` is a linear
> character. `G` is simple non-abelian, hence perfect, hence has no non-trivial
> linear character. ∎

This is the repo's own convention (`STAGE1_COMPLEX_MAPS` §4: "`T ∈
(Sym^d W* ⊗ W)^G` a landing covariant of degree `d`"), now with the reason
attached rather than assumed.

> **Lemma 0.2 (landing).** `F ∘ T ≡ 0`. Hence for every `v` with `T(v) ≠ 0`,
> `[T(v)] ∈ X`.

Both are used below in exactly one way each: Lemma 0.1 gives the congruence,
Lemma 0.2 turns "the only candidate target is off `X`" into "`T` vanishes there".

**The eigen-data.** For `g` of order `n` write `W = ⊕_a W_a`, `g|_{W_a} = ζ_n^a`.
Verified exactly at `p = 331` and `p = 661` (`scripts/s2eigen.py`,
`results/eigen_data.json`), and agreeing row-for-row with the sealed
`RECEIVER_LEDGER_X` and with the normal characters of `TERMINUS_STRATA_PW`:

| `n` | weight multiset on `W` | eigenpoints ON `X` | off `X` |
|---|---|---|---|
| 11 | `{1,3,4,5,9}` = the quadratic residues `Q`, all distinct | **all five** | — |
| 5 | `{0,1,2,3,4}` (regular rep) | `1,2,3,4` | `0` (= the `D10`-point) |
| 6 | `{0,1,2,4,5}` (`3` absent) | `1,5` (the two `X^{C6}` points, on `L_t`) | `0` (`D12`-pt), `2`, `4` |
| 3 | `{0,1,1,2,2}` | the two **eigenLINES** `w = 1,2` meet `X` in 3 pts each | `0` (= the `D12`-point) |

`Q = {1,3,4,5,9}` is the subgroup of index 2 in `(Z/11)*`; it is cyclic of
order 5 and `−2 ∈ Q` (`−2 ≡ 9`).

---

## 1. The pinning theorem

### 1.1 The congruence

> **Lemma 1.1 (monomial character).** In a `g`-eigenbasis with dual coordinates
> `x_j`, a monomial `x^α` occurs in `T_i` only if
> `Σ_j α_j a_j ≡ a_i (mod n)`.
>
> *Proof.* `T(gv) = gT(v)` reads component-wise `T_i(gv) = ζ^{a_i} T_i(v)`, and
> `x^α(gv) = ζ^{Σ α_j a_j} x^α(v)`. Monomials are linearly independent. ∎

### 1.2 The master weight formula

Let `Z' → P(W)` be any composition of blowups in `g`-invariant centres, and let
`R` be a `g`-fixed stratum of `Z'` reached by the chain

```
   the centre p₀ = [e_k]  (g-weight a_k)
   → exceptional direction of relative g-weight c₁
   → exceptional direction of relative g-weight c₂  →  …
```

Write `μ₁ = mult_{p₀}(T)`, `μ₂ =` order of vanishing of the level-1 leading form
at the level-1 centre, etc. (`μ_l ≥ 0`; `μ_l = 0` means the previous leading map
is already non-zero there, so the whole next exceptional fibre is contracted).

> **Theorem 1.2 (pinning).** The value of `T` at the generic point of `R` is a
> `g`-fixed point of `X` lying in the eigenspace of weight
>
> ```
>      w(R)  =  d · a_k  +  Σ_l  μ_l · c_l      (mod n) ,
> ```
>
> or it is `0` (the map is undefined along `R`, and the analysis moves one level
> further down the same chain). In particular, **if the weight `w(R)` does not
> occur in `W`, or occurs only at points off `X`, then `R` lies in the
> indeterminacy locus.**
>
> *Proof.* Level 0 is Lemma 1.1 with `α = d·δ_k`: `T(e_k) ∈ W_{d a_k}`. For the
> inductive step, put `v = e_k + Σ_{j≠k} y_j e_j`; `g` scales `y_j` by
> `ζ^{a_j − a_k}`, and Lemma 1.1 says the coefficient `C_ν` of `y^ν` lies in
> `W_{d a_k + Σ ν_j (a_j − a_k)}`. Blowing up (`y = s·u`) makes the induced map on
> the exceptional divisor `u ↦ Φ₁(u) = Σ_{|ν| = μ₁} C_ν u^ν`, so at the
> eigendirection of relative weight `c₁` the value lies in `W_{d a_k + μ₁ c₁}`.
> Repeat with `Φ₁` in place of `T`. Landing (Lemma 0.2) forces the value to be a
> point of `X`, and it is `g`-fixed because the whole computation is `g`-equivariant;
> if no such point exists in that eigenspace, the value is `0`. ∎

`μ_l = 0` is the important degenerate case: **when `T` is defined and non-zero at
`p₀`, every stratum of every exceptional fibre over `p₀` takes the single value
`T(p₀)`.** That is where the big collapse comes from.

**Two independent code paths** compute `w(R)` (`scripts/s2pin.py`): PATH A is the
closed form above; PATH B never uses it — it enumerates global degree-`d`
monomials, applies Lemma 1.1, and reads the local expansion off the exponents.
**47 736 cases, 0 mismatches** (`verifier.py` C1).

### 1.3 The five base-locus corollaries (all `d`, no hypotheses)

Reading Theorem 1.2 at level 0, with the on-`X` column of §0:

| corollary | statement | previously |
|---|---|---|
| **B(C11)** | `X^{C11}` (all 60 points) `⊆ Bs(T)` **iff `d` is not a quadratic residue mod 11** (`d ≡ 0` included) | proposed, UNSEALED (`CONSTRAINT_LEDGER` B1) |
| **B(C5)** | `X^{C5}` (all 264 `C5`-eigenpoints) `⊆ Bs(T)` **iff `5 ∣ d`** | proposed, UNSEALED (B1) |
| **B(D10)** | the 66 `D10`-points lie in `Bs(T)` for **every** `d` | sealed (`C5/D10` corollary) — **re-derived by character arithmetic alone** |
| **B(D12)** | the 55 `D12`-points lie in `Bs(T)` for **every** `d` | sealed (`RECEIVER_LEDGER_X` Cor. C3) — **re-derived** |
| **B(C3)** | both `C3`-eigenlines (110 lines) lie in `Bs(T)` **iff `3 ∣ d`** | proposed, UNSEALED (B1) |

`B(D10)`/`B(D12)` are the character-theoretic shadow of the sealed
indeterminacy corollaries: `W^{C5}` and `W^{C3}` are the weight-`0` eigenspaces,
`d·0 = 0` for every `d`, and the weight-`0` eigenpoint is off `X` in both cases.
No geometry is used.

### 1.4 The involution layer, and `X^{C6}`

`σ` an involution, `W = W⁺_σ ⊕ W⁻_σ` of dims `(3,2)`, `X ∩ P(W⁺) = E_σ` (genus 1,
`j = 8192/11`, no CM), `L_σ = P(W⁻) ⊂ X`, `X^{D12} = ∅`.

> **Proposition 1.3 (the plus-plane).** `P(W⁺_σ) ⊆ Bs(T)` for every `d`;
> moreover `ord_{P_σ}(T⁻) = m` is **odd** and `ord_{P_σ}(T⁺)` is **even and ≥ 2**.
>
> *Proof.* In the `σ`-bigrading a monomial of bidegree `(p,q)` has `σ`-character
> `(−1)^q`, so `T⁺` has `q` even and `T⁻` has `q` odd (this is the sealed parity
> `H0-1`, `STAGE1` Thm 9(i)). Hence `T⁻|_{W⁺} = 0`. And `T⁺|_{W⁺}` is a map
> `P(W⁺) ⇢ X ∩ P(W⁺) = E_σ` from a rational surface to a genus-1 curve, hence
> constant; the constant is `D12`-fixed because `D12 = N_G(⟨σ⟩)` acts, and
> `X^{D12} = ∅`. So `T⁺|_{W⁺} = 0` too, which upgrades `q ≥ 0` to `q ≥ 2`. ∎

> **Proposition 1.4 (the minus-line; new).**
> (i) If `d` is **even** then `T|_{L_σ} ≡ 0`: **all 55 minus-lines lie in `Bs(T)`.**
> (ii) In all cases `ord_{L_σ}(T) ≡ d + 1 (mod 2)`.
>
> *Proof.* (i) For `v ∈ W⁻`, `T⁻` needs `q = d` odd, so `T⁻|_{W⁻} = 0` when `d` is
> even, and `T|_{L_σ} = T⁺|_{L_σ}` maps `P¹ ⇢ E_σ`, hence is constant, hence
> `D12`-fixed, hence `0`.
> (ii) Put `ν = ord_{L_σ}(T)` and expand `T(v + w)`, `v ∈ W⁻`, `w ∈ W⁺`. From
> `T(σ(v+w)) = σT(v+w)` and `T(−u) = (−1)^d T(u)` one gets
> `σ T^{(ν)}(w) = (−1)^{ν+d} T^{(ν)}(w)`, so `T^{(ν)}` lands in `W⁺` when `ν+d` is
> even and in `W⁻` when `ν+d` is odd. The exceptional divisor
> `D_{L⁻_σ} ≅ P(W⁻)×P(W⁺)` has `Stab_G = D12`, so its image cannot be a point
> (`X^{D12} = ∅`) and cannot be `E_σ` (rationality) — it is `L_σ`, which is
> `STAGE1` Theorem 3 re-derived. That forces the `W⁻` alternative, i.e. `ν + d`
> odd. ∎

Proposition 1.4(ii) is the exact mirror of the sealed "`m` odd along the
plus-plane", and it is **new**: the sealed profile records no order along `L_σ`.

> **Corollary 1.5 (`X^{C6}`).** Let `C6 = ⟨g⟩ ⊃ ⟨t⟩`, `X^{C6}` = the two
> `ρ`-fixed points of `L_t` (weights `1` and `5`). Then
>
> * `d ≡ 1 (mod 6)`: `T` **fixes** each of the two points;
> * `d ≡ 5 (mod 6)`: `T` **swaps** them;
> * `d ≡ 0,2,3,4 (mod 6)`: **both lie in `Bs(T)`.**
>
> Two independent proofs agree: the weight congruence `1 ↦ d`, `5 ↦ 5d` with the
> on-`X` set `{1,5}` (and no weight `3` in `W`, killing `d ≡ 3`); and, for `d`
> even, Proposition 1.4(i) plus `X^{C6} ⊂ L_t`.

### 1.5 The `C3` eigenlines

> **Proposition 1.6 (eigenline contraction).** Let `ℓ_w = P(W_w)` be a
> `C3`-eigenline (`w ∈ {1,2}`, `dim W_w = 2`), `X ∩ ℓ_w` = one `X^{C6}`-point
> plus two exact-`C3` points.
>
> * `3 ∣ d`: `ℓ_w ⊆ Bs(T)`.
> * `3 ∤ d`: `T(ℓ_w)` is the **single** `X^{C6}` point lying on `ℓ_{dw}` — the
>   `C6`-point of `ℓ_w` itself when `d ≡ 1`, the one on the other eigenline when
>   `d ≡ 2`. **Never an exact-`C3` point.**
>
> *Proof.* Every degree-`d` monomial in the two coordinates of `W_w` has weight
> `dw`, so `T(ℓ_w) ⊆ P(W_{dw}) ∩ X`. For `dw ≡ 0` that set is the `D12`-point,
> off `X`, so `T|_{ℓ_w} = 0`. Otherwise it is 3 points, so `T|_{ℓ_w}` is constant;
> the constant is fixed by `Stab_G(ℓ_w) = C_G(C3) = C6` (the pointwise stabiliser
> of `ℓ_w` is `C3`, so its setwise stabiliser lies in `N_G(C3) = D12`, and the
> six elements outside `C6` swap the two eigenlines); and
> `X^{C6} ∩ ℓ_{dw}` is one point. ∎

This reproduces `PHI_SEXTIC_ISOGENY` Thm 4 / `STAGE1` Thm 6 (`X^{C6}` = the
`ρ`-fixed pair, swapped by `D12/C6`) and sharpens it to a **`d`-dependent
choice** of which of the pair.

---

## 2. The 22 coherence-immune rows, pinned

The rows are `STAGE1_COMPLEX_MAPS` §15.5's list; their chain data (base weight
`a_k`, starred relative weights `c_l`) is read off `TERMINUS_STRATA_PW`
`results/t2_strata.txt`, stage-3 block, and re-verified here from the matrices
(`verifier.py` B3, B8, B16).

### 2.1 `C11` — four rows, `5⁴ = 625` patterns → **1**

The 60 `C11`-points are the level-0 centres; the four rows are the four
eigendirections of the exceptional `P³` over each. Index the five eigenpoints by
their weight `k ∈ Q` and the four rows by `r = j/k ∈ Q∖{1} = {3,4,5,9}` (so
`c = k(r−1)`). Theorem 1.2 gives

```
     value of row r over the point k  =  the eigenpoint of weight  k·( d + μ (r−1) ) ,
     admissible  ⟺  d + μ (r−1) ∈ Q ,           μ = mult of T at a C11-point.
```

* **`d ∈ Q` (i.e. `d ≡ 1,3,4,5,9 mod 11`).** `μ = 0` is open, and then all four
  rows take the **same** value `e_{dk}` — the whole exceptional `P³` is
  contracted to `T(e_k)`. `625 → 1`.
* **`d ∉ Q`.** `μ ≥ 1` is forced (Corollary B(C11)) and the four values are again
  determined by `(d, μ)` — one pattern, not `625`.

> **Theorem 2.1 (the `C11` quadruple obstruction; new).** All four `C11`-rows
> carry a value on `X` simultaneously **iff `d ∈ Q` and `μ ≡ 0` or `μ ≡ d`
> (mod 11)**. If `d` is a non-residue mod 11 at most **three** of the four can;
> if `11 ∣ d` at most **two** can. (`verifier.py` D3; the full `μ`-profile for
> each `d mod 11` is in `results/tables.json`.)

### 2.2 `C5` — ten rows, `4¹⁰ = 1 048 576` patterns → **1**

* **Eight `pt_C5` rows** (the four eigendirections over each of the two
  `G`-orbits `{q_1,q_4}`, `{q_2,q_3}` of exact-`C5` points). Value of the row of
  relative weight `c` over `q_a`: the eigenpoint of weight `da + μc`.
  If `5 ∤ d` then `μ = 0` is open and **all four rows over `q_a` share the single
  value `q_{da}`**; the two orbits are preserved when `d ≡ ±1 (mod 5)` and
  interchanged when `d ≡ ±2`. If `5 ∣ d` then `μ ≥ 1` and the values are
  `q_{μc}`, again one pattern. Either way `4⁸ → 1`.
* **Two `pt_D10` rows** (the two `D10`-orbits of eigendirections over the 66
  `D10`-points). Here `a_k = 0`, so the value weight is `μ₀·c`, `c ∈ {1,2}`,
  **independent of `d`**; admissible iff `5 ∤ μ₀`. `4² → 1`.

> **Proposition 2.2.** For every `μ₀` with `5 ∤ μ₀` the two `pt_D10` rows land in
> **different** `C5`-orbits (`{μ₀, 2μ₀}` always meets both `{1,4}` and `{2,3}`).
> This is exactly `STAGE1` §0's equivariance count "`|D10/C5| = 2`, and `2 × 2`
> target orbits gives the four points of `X^{C5}`" — now derived rather than
> counted. (`verifier.py` D6.)

### 2.3 `C3` — eight rows, `6⁸ = 1 679 616` patterns → **`3⁸ = 6 561`**

The centres are the 110 `A4`-points `q` (two `G`-orbits of 55, the `ω`- and
`ω²`-eigenvectors of `A4` inside `ℓ_V = P(W^{V4})`). `W|_{A4} = ω ⊕ ω² ⊕ Θ` with
`Θ` the 3-dimensional irreducible; the projective normal space is
`N = ω ⊕ Θ`, whose `C3`-weights are `{0,1,1,2}` for the `ω`-orbit and `{0,1,2,2}`
for the `ω²`-orbit — **matching the sealed terminus normal characters exactly**.
The eight rows (per orbit: one `dim 1` row = the 2-dimensional weight-`a_k`
eigenspace, one `dim 0` row, two `dim 0` rows in the `<ell_V` chain) have

| orbit | row | chain `(c₁[,c₂])` | value weight |
|---|---|---|---|
| `(a)`, `a_k = 1` | `dim 1`, `pt_A4(a)` | `(1)` | `d + μ₁` |
| | `dim 0`, `pt_A4(a)` | `(2)` | `d + 2μ₁` |
| | `dim 0`, `pt_A4(a)<ell_V` | `(1,1)` | `d + μ₁ + μ₂` |
| | `dim 0`, `pt_A4(a)<ell_V` | `(1,2)` | `d + μ₁ + 2μ₂` |
| `(b)`, `a_k = 2` | `dim 1`, `pt_A4(b)` | `(2)` | `2d + 2μ₁'` |
| | `dim 0`, `pt_A4(b)` | `(1)` | `2d + μ₁'` |
| | `dim 0`, `pt_A4(b)<ell_V` | `(2,2)` | `2d + 2μ₁' + 2μ₂'` |
| | `dim 0`, `pt_A4(b)<ell_V` | `(2,1)` | `2d + 2μ₁' + μ₂'` |

> **Proposition 2.3.** `μ₁ ≥ 1` and `μ₂ ≥ 1` always.
>
> *Proof.* `q ∈ ℓ_V ⊂ P(W⁺_σ)` for the three involutions of its `V4`, and the
> plus-planes are in `Bs(T)` (Prop. 1.3), so `μ₁ ≥ 1`. For `μ₂`: the level-1
> leading form `Φ` satisfies `h·Φ(n_ω^{μ₁}) = ω(h)^{d+μ₁} Φ(n_ω^{μ₁})` for
> `h ∈ A4`, where `n_ω` is the `ℓ_V`-direction; the `ω`-isotypic parts of `W|_{A4}`
> are the two `A4`-points, both **off** `X`, and `W^{A4} = 0`. So
> `Φ(n_ω^{μ₁}) = 0`. ∎

**What the congruence pins, and what it does not.** The value weight determines
**which of the two eigenlines** the value sits on — three of the six points of
`X^{C3}`, namely one `X^{C6}` point and two exact-`C3` points. It cannot separate
those three, and the reason is structural:

> the residual group of `X^{C3}` is `W(C3) = D12/C3 ≅ V4`. Its
> eigenline-swapping generator acts on weights by `w ↦ −w`, which **commutes**
> with `w ↦ dw`, so the congruence sees it. Its other generator is
> `C6/C3 = ⟨t⟩`, which acts **inside** each eigenline — fixing the `C6`-point and
> swapping the two exact-`C3` points. A source row with setwise stabiliser `C3`
> (odd order) carries no `t`, so no equivariance constraint reaches that
> involution. **That is exactly the surviving factor 3 per row.**

So: `6 → 3` per row, `6⁸ → 3⁸ = 6 561`, and no further at this order.

### 2.4 The collapsed count

```
   Stage-1 coherence-immune factor      6⁸ · 4¹⁰ · 5⁴ = 1 100 753 141 760 000
   after Stage-2 odd-order pinning                3⁸ =             6 561
   reduction                                2²⁸ · 5⁴ =   167 772 160 000
```

Carried into `STAGE1` Theorem A's fibered product
`43 008 × 23 × (immune)`, the stratum-coherent order-0 count drops

```
   1 088 847 395 778 723 840 000   ⟶   43 008 · 23 · 3⁸  =  6 490 036 224 .
```

The two other factors are **carried unchanged, not recounted**: this packet
constrains the `σ`-band (§3.4 removes `C6`-children of `D_{P_σ}` when
`m ≢ d (mod 3)`, and Prop. 1.4 puts every `L_σ` in the base locus when `d` is
even) but does not re-run `STAGE1`'s coherence enumeration, so `43 008` and `23`
are upper bounds inherited from Stage 1.

**Honest scope.** This is not a bound on maps. It says: for a *fixed* `d` and a
*fixed* map, the 22 immune rows are not free — fourteen of them have exactly one
possible value and eight have exactly three. The `μ`'s are invariants of the map,
not choices.

---

## 3. The consistency system

Everything the brief asked to check, checked.

### 3.1 `F55` at `C11` — **commutes (proved, not refuted)**

`N_G(C11)/C11 = C5` acts on the five eigenpoints by multiplication by an element
`u` of the order-5 subgroup of `(Z/11)*`, which **is** `Q` (machine-verified: the
four order-5 normalising elements act by `u = 3,4,5,9`). The pinned value map is
`a ↦ da`, also multiplication in the abelian group `(Z/11)*`. Multiplications
commute. `0` violations over all `(u,d,a)` (`verifier.py` E1). Equivalently:
`X^{C11}` is a torsor-like `Z/5`, the normaliser acts by translation and `T` by
multiplication by `log_u d` — the two are compatible for every `d`.

### 3.2 `D10` at `C5` — **commutes**

The residual `C2 = D10/C5` acts by `a ↦ −a` (verified from the matrices); `a ↦ da`
commutes with it. `0` violations (`verifier.py` E2).

### 3.3 `D12/C3` at `C3` — **commutes on the part it sees**

The eigenline swap is `w ↦ −w`, which commutes with `w ↦ dw` (`0` violations,
`verifier.py` E3). The complementary generator `t` is invisible — §2.3.

### 3.4 The `C6`-pair condition on `D_{P_σ}` — the exact `d mod 3` condition

`D_{P_σ} ≅ P(W⁺_σ) × P(W⁻_σ)` sweeps onto `L_σ` (`STAGE1` Thm 3) via the leading
datum `T_m ∈ Sym^{d−m}(W⁺*) ⊗ Sym^m(W⁻*) ⊗ W⁻`, `m` odd. Its six `C6`-fixed
points are `(f_i, f_j)`, `i ∈ {0,2,4}` (the `C6`-weights on `W⁺`, i.e. the
`D12`-point and the two off-`X` `C6`-points), `j ∈ {1,5}` (the two `X^{C6}`
points) — precisely `STAGE1` §15.3's "six `C6`-rows lying inside `D_{P_σ}` (four
over the plus-plane `C6`-points, two over the `D12`-points)". Theorem 1.2 and the
coherence evaluation of `T_m` give the **same** value weight,

```
      w(i,j)  =  (d − m)·i  +  m·j        (mod 6) ,
```

which must lie in `{1,5}`. Reducing mod 3 the six weights are
`{m, 2m, 2d−m, 2d, d, d+m}`, so

> **Proposition 3.1.** All six `C6`-children of `D_{P_σ}` are non-degenerate
> **iff `d ≢ 0 (mod 3)` and `m ≡ d (mod 3)`.** Otherwise exactly two of the six
> are degenerate (`T_m` vanishes there), except when `3 ∣ d` **and** `3 ∣ m`, when
> **all six** are. (`verifier.py` E4, E5.)

This is the coupling the brief asked for: the `C3`-part of the `C6` congruence
constrains the *sealed jet order* `m`, not `d` alone. It is a genuine new
condition on the `(m, r, n)` profile, and it is invisible to the order-0
coherence layer, which only knows that `T_m` exists.

### 3.5 New jet-order constraints, collected

| # | constraint | source |
|---|---|---|
| J1 | `m = ord_{P_σ}(T⁻)` odd; `ord_{P_σ}(T⁺)` even and `≥ 2` | Prop. 1.3 (`m` odd = sealed `H0-1`, re-derived; `≥ 2` new) |
| J2 | `ord_{L_σ}(T) ≡ d + 1 (mod 2)` | Prop. 1.4(ii) — **new** |
| J3 | `mult_{D12-point}(T)` is **odd** | forced sweep of the central-involution line `P(W⁻_σ) ⊂ E_{pt_D12}`, same argument as 1.4(ii) — **new** |
| J4 | `5 ∤ μ₀` at a `D10`-point, else the two `pt_D10` rows go deeper | §2.2 |
| J5 | `μ₁ ≥ 1`, `μ₂ ≥ 1` at an `A4`-point | Prop. 2.3 — **new** |
| J6 | `m ≡ d ≢ 0 (mod 3)` for a non-degenerate `C6`-band | Prop. 3.1 — **new** |

---

## 4. The residue table, `d mod 165`

Full table: `results/residues_165.txt` (165 rows). Compressed — the verdict
depends only on `(d mod 3, d mod 5, d mod 11)` through the three flags below,
and **every one of the 165 residues is CONSISTENT**:

| `d mod 11` | `C11` branch | max of the 4 rows defined | `#` residues |
|---|---|---:|---:|
| `∈ {1,3,4,5,9}` (QR) | `T` defined at all 60 points; `a ↦ da`; all four rows share one value | **4** (iff `μ ≡ 0` or `d`) | 75 |
| `∈ {2,6,7,8,10}` (non-residue) | all 60 points in `Bs(T)`, `μ ≥ 1` | **3** | 75 |
| `≡ 0` | all 60 points in `Bs(T)`, `μ ≥ 1` | **2** | 15 |

| `d mod 5` | `C5` branch | 8 `pt_C5` rows | 2 `pt_D10` rows |
|---|---|---:|---:|
| `≠ 0` | `T` defined on `X^{C5}`; `a ↦ da`; orbits preserved (`d ≡ ±1`) or swapped (`d ≡ ±2`) | 8/8, one value each | 2/2, one value each, always in different orbits |
| `≡ 0` | all 264 `C5`-points in `Bs(T)` | 8/8 (via `5 ∤ μ`), one value each | 2/2 |

| `d mod 3` | `C3` branch | 8 `A4` rows |
|---|---|---:|
| `≡ 1` | each eigenline contracts to the `X^{C6}` point **on it** | 8/8, three values each |
| `≡ 2` | each eigenline contracts to the `X^{C6}` point on the **other** line | 8/8, three values each |
| `≡ 0` | both eigenlines (110) in `Bs(T)` | 8/8, three values each |

and the `mod 2` refinement (so `mod 330` in total), which the `mod 165` table
cannot carry:

| `d mod 6` | `L_σ` | `X^{C6}` | `ord_{L_σ}(T)` |
|---|---|---|---|
| `1` | not in `Bs` | `T` fixes both points | even (0 allowed) |
| `5` | not in `Bs` | `T` swaps them | even (0 allowed) |
| `0,2,3,4` | **all 55 in `Bs(T)`** when `d` even; `d ≡ 3` also kills `X^{C6}` | both in `Bs` | odd when `d` even |

> **Theorem 4.1 (no degree exclusion).** For every residue `d mod 165` (and every
> `d mod 330`) the odd-order pinning system admits a consistent total assignment.
> **The congruences exclude no degree.**

This is not a disappointment but a confirmation: the repository's own
adjudication of the unsealed external "mod-330 degree sieve"
(`COMBINED_DEGREE_SIEVE/CONSTRAINT_LEDGER.md` B1, quoting the source: *"These
congruence statements do not by themselves constrain `D`, because a rational map
may be based on the corresponding finite orbit"*) is now **independently
re-derived, proved and machine-verified**. What was proposed-and-excluded is here
proved-and-sealed as base-locus bookkeeping (§1.3), and the *new* content — the
value pinning of §2, Theorem 2.1, Propositions 1.4, 1.6, 2.3, 3.1 — is not in
that transcript at all.

---

## 5. Which windows survive

The degree gate is unchanged, because §4 removes nothing:

* `d ≤ 30` **empty** (sealed `FIX-P2-SWEEP2-EMPTY-THROUGH-30`); `31–33`
  near-complete with every computed row zero;
* `d = 25` **dead** (sealed `FIX-P1-WINDOW-25-EMPTY`, characteristic zero, three
  primes, two jet engines) — and it stays dead: Stage-2 pinning is consistent at
  `d = 25` and therefore adds nothing to its exclusion;
* **`d = 34` is still the first open window**, via `(m,r) = (1,6)`, `n = 28`.

What this packet *adds* to each live window (`results/degrees.txt`):

| `d` | `(3,5,11,6)` | `C11` | `C5` | `C3` | `L_σ` | `X^{C6}` | max rk `dT` (11/5/6) |
|---:|---|---|---|---|---|---|---|
| **25** | `1,0,3,1` | pinned, `a↦3a` | **all 264 in `Bs`** | line fixed | free | fixed | **0**/–/3 |
| **34** | `1,4,1,4` | pinned, `a↦a` (identity!) | pinned, `a↦−a` | line fixed | **all 55 in `Bs`** | **in `Bs`** | 3/3/– |
| 35 | `2,0,2,5` | all 60 in `Bs` | all 264 in `Bs` | lines swapped | free | swapped | –/–/2 |
| 36 | `0,1,3,0` | pinned `a↦3a` | pinned `a↦a` | **110 lines in `Bs`** | in `Bs` | in `Bs` | 0/3/– |
| 37 | `1,2,4,1` | pinned `a↦4a` | pinned `a↦2a` | line fixed | free | fixed | 1/3/3 |
| 38 | `2,3,5,2` | pinned `a↦5a` | pinned `a↦3a` | lines swapped | in `Bs` | in `Bs` | 1/3/– |
| 39 | `0,4,6,3` | all 60 in `Bs` | pinned `a↦4a` | 110 lines in `Bs` | free | in `Bs` | –/3/– |
| 40 | `1,0,7,4` | all 60 in `Bs` | all 264 in `Bs` | line fixed | in `Bs` | in `Bs` | –/–/– |
| 41 | `2,1,8,5` | all 60 in `Bs` | pinned `a↦a` | lines swapped | free | swapped | –/3/2 |
| 42 | `0,2,9,0` | pinned `a↦9a` | pinned `a↦2a` | 110 lines in `Bs` | in `Bs` | in `Bs` | 1/3/– |
| 43 | `1,3,10,1` | all 60 in `Bs` | pinned `a↦3a` | line fixed | free | fixed | –/3/3 |
| 44 | `2,4,0,2` | all 60 in `Bs` (`11∣d`, ≤2 rows) | pinned `a↦4a` | lines swapped | in `Bs` | in `Bs` | –/3/– |
| 45 | `0,0,1,3` | pinned `a↦a` | all 264 in `Bs` | 110 lines in `Bs` | free | in `Bs` | 3/–/– |
| 46 | `1,1,2,4` | all 60 in `Bs` | pinned `a↦a` | line fixed | in `Bs` | in `Bs` | –/3/– |

**The two verdicts the brief asked for explicitly.**

* **`d = 25`** — consistent, no new exclusion; it remains dead by the sealed
  `FIX-P1` sweep. Its congruence profile is unusual: `T` would be defined at all
  60 `C11`-points and permute `X^{C11}` by `a ↦ 3a` (a 5-cycle), yet
  **`dT = 0` at every one of them** (§6). All 264 `C5`-points would be base
  points. Had `d = 25` survived `FIX-P1`, this is where the next cut would have
  come from.
* **`d = 34`** — consistent, survives. New conditions the `FIX-P2` slice sweep did
  not impose, and which are actionable for the open `(1,6)`, `n = 28` search:
  1. **all 55 minus-lines `L_σ` lie in `Bs(T)`**, with `ord_{L_σ}(T)` **odd**
     (Prop. 1.4, since `34` is even);
  2. **both `X^{C6}` points lie in `Bs(T)`** (Cor. 1.5, `34 ≡ 4 mod 6`);
  3. `m ≡ d ≡ 1 (mod 3)` is required for a non-degenerate `C6`-band — and the
     window's own profile has `m = 1`, so **this one is satisfied** (Prop. 3.1);
  4. `T` restricted to `X^{C11}` is the **identity** (`34 ≡ 1 mod 11`) and
     restricted to `X^{C5}` is the `D10`-involution (`34 ≡ −1 mod 5`).

Item 1 is a base-locus condition on the 55 lines that the `(m,r,n)` profile does
not record; it is a strictly extra linear condition on the `d = 34` covariant
slice. **Recommended next computation:** re-run the `d = 34`, `(1,6)`, `n = 28`
slice with the minus-line vanishing imposed. This packet does not run it.

---

## 6. First-order layer

At a pinned point `p = [e_k]` with `T(p) = [e_i]`, `a_i = d a_k`:

> **Proposition 6.1.** `dT_p` **preserves the relative weight**: it maps the
> weight-`c` block of `T_pP(W)` into the weight-`c` block of `T_{[e_i]}P(W)`.
> Moreover `dF` at a weight-`a` eigenpoint of `X` is supported on the
> weight-`(−2a)` eigenspace, so `T_{[e_i]}X` drops exactly the relative weight
> `−3a_i`.
>
> *Proof.* Differentiate `T(g(e_k + w)) = g T(e_k + w)` in the chart, using
> `T(λv) = λ^d T(v)` and `a_i = d a_k`: `g·dT(w) = ζ^{d a_k + c} dT(w)` for `w` of
> relative weight `c`. For `dF`: `F(gv) = F(v)` and `dF` is quadratic in `v`, so
> `dF|_v ∘ g = ζ^{−2a} dF|_v`, which pairs non-trivially only with weight `−2a`.
> (Machine-checked directly from the gradient at `p = 331`, `verifier.py` F5;
> note `−2 ≡ 9 ∈ Q`, so the excluded target really is one of the eigenpoints.) ∎

Admissible differential blocks (full tables in `results/first_order.txt`):

**`C11`** — source blocks at `e_k` are `k·{2,3,4,8}`; target-tangent-to-`X`
blocks at `e_{dk}` are `dk·{2,3,4}`. Intersection:

| `d mod 11` | admissible blocks (times `k`) | max rank of `dT` |
|---|---|---:|
| `1` | `{2,3,4}` | **3** |
| `3` | `∅` | **0** — `dT` vanishes at all 60 points |
| `4` | `{8}` | 1 |
| `5` | `{4}` | 1 |
| `9` | `{3}` | 1 |
| non-residue, `0` | not a pinned point | — |

**`C5`** — source blocks `{1,2,3,4}`, target drops `−3da`; admissible blocks are
the other three, **max rank 3 for every `d` with `5 ∤ d`**.

**`C6`** — at `X^{C6}`: `d ≡ 1 (mod 6)` gives blocks `{1,4,5}` (rank ≤ 3);
`d ≡ 5 (mod 6)` gives `{1,5}` (**rank ≤ 2** — `T` cannot be submersive at the
`C6`-points).

**No rank claims beyond this.** Equivariance bounds the rank from above; nothing
here says any block is actually non-zero. `dT` has rank `≤ 3` everywhere anyway
(`dim X = 3`), so only the entries `0`, `1` and `2` above are cuts.

---

## 7. Verification

```sh
python3 scripts/s2eigen.py            # results/eigen_data.json      (2 primes)
python3 scripts/s2covariants.py       # results/covariant_bruteforce.json
python3 scripts/s2tables.py           # all results/*.txt + tables.json
python3 verifier.py                   # 95 checks, ALLGREEN
```

Four genuinely different routes; every claim is produced by at least two.

| route | what it does |
|---|---|
| **integer congruence, closed form** (`s2pin.pathA_*`) | `w = d a_k + Σ μ_l c_l` in `Z/n` |
| **integer congruence, enumeration** (`s2pin.pathB_*`) | rebuilds the same weights by enumerating global degree-`d` monomials and applying Lemma 1.1 to their exponents; **47 736 cases, 0 mismatches** |
| **exact `F_p` model of `G` on `W`** (`s2core.py`, `s2eigen.py`) | the repo's `S`, `T` from `certificates/exact_weil_check.py` reduced at `p = 331, 661` (`330 ∣ p−1`, so every order in `{1,2,3,5,6,11}` splits); eigenbases, `X`-membership by exact evaluation of `F`, stabiliser orders by brute force in the 660-element group, normal characters compared against the sealed `TERMINUS_STRATA_PW` table |
| **brute-force covariants** (`s2covariants.py`) | an honest basis of `M_d = (Sym^d W* ⊗ W)^G` over `F_p` by solving `S·T = T`, `T_{mat}·T = T` exactly; then each covariant is re-expressed in the eigenbasis of an element of order `3,5,6,11` and **every** non-zero coefficient is checked against Lemma 1.1, and every eigenpoint value against Theorem 1.2 |

The brute force reproduces the sealed Molien table
`dim M_d = 1,0,0,2,1,2,4` for `d = 1,…,7`
(`certificates/exact_covariants_check.py:53`) at both primes, and finds
**0 monomial-congruence violations out of 6 213 / 6 211 non-zero coefficients
tested, and 0 eigenpoint-value violations**, at `n = 3,5,6,11`.

Check groups: **A** model (6), **B** eigen layer + sealed-normal-character
agreement (38), **C** congruence engine and the five base-locus corollaries (8),
**D** the pinned rows and the collapsed counts (12), **E** equivariance
commutation and the `C6`-band condition (6), **F** first-order table (5),
**G** brute-force covariants (18), **H** cross-prime (2). Total **95**.

---

## 8. Honesty tiering

**Tier 1 — exact, prime-free, no computation.** Lemma 0.1; Lemma 1.1;
Theorem 1.2; Propositions 1.3, 1.4, 1.6, 2.3, 3.1, 6.1; Corollary 1.5;
Theorem 4.1 (it is a finite check in `Z/165`, done twice). The five base-locus
corollaries of §1.3. The collapse arithmetic of §2.4.

**Tier 2 — finite integer computation, done by two independent code paths, plus
an exact `F_p` replay at two split primes.** The eigen-data table of §0; the
identification of the 22 rows with their chain weights (read from the sealed
`TERMINUS_STRATA_PW` census and re-verified against the matrices); Theorem 2.1's
`μ`-profile; the residue table; the first-order tables; the brute-force covariant
confirmation.

**Tier 3 — flagged.**

1. **The row identification is consumed, not rebuilt.** The 22 rows and their
   chains come from `STAGE1_COMPLEX_MAPS` §15.5 and `TERMINUS_STRATA_PW`
   `t2_strata.txt`. This packet re-verifies the *eigen-data* of those chains
   (base weights, normal characters, `X`-membership) from the matrices, but does
   **not** rebuild the 11 076-component census.
2. **`μ` is an invariant of the hypothetical map, not a free parameter.** All
   statements of the form "for every `μ` …" are honest; statements of the form
   "there exists `μ` such that all four rows are defined" are existence
   statements about the *arithmetic*, not about maps.
3. **The residual factor 3 on the eight `C3`-rows is real.** It is not an
   artefact of the method: §2.3 identifies the exact group-theoretic reason
   (the invisible `C6/C3` involution) and no order-0 or first-order datum can
   remove it. Separating the `X^{C6}` point from the two exact-`C3` points on an
   eigenline requires an even-order equivariance the source rows do not carry.
4. **"Undefined" is a legitimate branch.** When the congruence gives a weight
   with no point of `X`, the conclusion is that the row lies in the
   indeterminacy locus of the lift to `Z` — which is allowed (it has codimension
   `≥ 2`, and these rows have dimension 0 or 1 in a 4-fold). It is *not* a
   contradiction, and that is precisely why §4 excludes no degree.
5. **Proposition 1.4(ii) and J3 use `STAGE1` Theorem 3** (the forced sweeps),
   which is Tier-1 there but quantified over the Tier-2 census.
6. The `d = 34` recommendation in §5 is a recommendation. This packet does not
   run the slice.

## 9. Not claimed

* No headline. Problem E remains OPEN.
* **No degree is excluded** by anything in this packet.
* No statement that a landing covariant exists at any degree.
* No rank claim about `dT` beyond the upper bounds equivariance forces.
* No claim that the `μ`'s are realisable; only that *if* a map exists, its `μ`'s
  satisfy J1–J6 and the row values are as tabulated.
* No re-derivation of the sealed sweep `d ≤ 30` or of `FIX-P1-WINDOW-25-EMPTY`;
  both are consumed.

## 10. Dependencies

| import | used for | grade |
|---|---|---|
| `RECEIVER_LEDGER_X` (branch `agent/receiver-ledger-x-20260810`) | `X^H` for `H = C3,C5,C6,C11`; `X^{D12} = X^{D10} = X^{A4} = X^{F55} = ∅`; the residual actions | **every row re-verified here from the matrices at two primes** |
| `TERMINUS_STRATA_PW` (branch `agent/terminus-strata-pw-20260810`) | the 22 rows' chains and normal characters | chains consumed; **normal characters re-derived and matched** |
| `STAGE1_COMPLEX_MAPS` (branch, latest commit `a8c8ad9`) | §15.5's immune factor; Thms 3, 6, 9(i); the coherence framing | consumed; Thm 3 re-derived en route (Prop. 1.4), Thm 6 sharpened (Prop. 1.6), Thm 9(i) re-derived (Prop. 1.3) |
| `certificates/exact_weil_check.py` | the exact `S`, `T` on `W` | reduced mod 331, 661 |
| `certificates/exact_covariants_check.py:53` | the sealed Molien row `dim M_d` | **reproduced independently** |
| `FIX_H1_coupling.md` §8 (Correction H1-D), `NOTEBOOK.md:3177` | `m` odd, `r ≥ (3m+1)/2`, `d ≥ 3r−2m`, cutoff `d ≤ 30`, window `d = 34` | consumed as corrected |
| `FIX_P1_DEGREE25_GUIDED`, `FIX_P2_GATEWAY_D36` | `d = 25` empty; sweep empty through 30 | consumed, not re-run |
| `COMBINED_DEGREE_SIEVE/CONSTRAINT_LEDGER.md` B1, B2 | the excluded unsealed mod-330 sieve | **its base-locus content is proved and sealed here (§1.3); its adjudication as "no degree constraint" is independently confirmed (Thm 4.1)** |

## 11. Named remainders

1. **The factor `3⁸`.** Removing it needs a datum that distinguishes the
   `X^{C6}` point of a `C3`-eigenline from the two exact-`C3` points. Candidates:
   the second-order jet at the `A4`-points, or a global argument through the free
   stratum. Not attempted here.
2. **`μ` bounds.** Nothing here bounds `mult_{C11-point}(T)`,
   `mult_{A4-point}(T)` or `μ₀` in terms of `d`. Such a bound would turn
   Theorem 2.1 from a structural statement into a possible exclusion.
3. **The `d = 34` minus-line condition** (§5 item 1) is stated but not imposed on
   the covariant slice.
4. **`J6` versus the sealed profile.** `m ≡ d (mod 3)` couples the plane order to
   the degree. Its interaction with `r ≥ (3m+1)/2` and `d ≥ 3r − 2m` is not
   worked out.
5. The `V4`/type-I layer (even order) is only touched in passing; the analogous
   pinning there interacts with `STAGE1` Theorem 4 and is left to a later packet.

> **2026-08-12 strengthening (`goal_runs_20260812/L12_ORDER11`,
> referee-confirmed):** B(C11)'s "iff `d` is not a QR" is strengthened:
> at QR degrees too, no landing map is defined at the `X^{C11}` points
> (the μ = 0 branch dies by algebraic integrality of the localization
> trace — genus-free, model-independent, map level). Hence all 60
> C11-points lie in `Bs(T)` at EVERY degree, and §4's QR row ("T defined
> at all 60 points; 4 rows") describes a branch that no landing map
> realizes. Nothing here contradicts the sealed statements — the "iff"
> characterized what THIS packet's congruences force; the localization
> ledger forces more.
