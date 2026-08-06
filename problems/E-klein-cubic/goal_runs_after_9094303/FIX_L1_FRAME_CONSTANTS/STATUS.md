# FIX-L1 — exact σ-frame constants for the [L] transfer condition

**Packet:** `goal_runs_after_9094303/FIX_L1_FRAME_CONSTANTS/`
**Program:** FIX ([E56]). **Named by:** `theory/FIX_IV_closure.md` §5.8
("Named computation FIX-L1"), consuming §5.7 (certificate A3), §5.5 (Lemma 5.5),
§5.1 (Lemma 5.1). **Date:** 2026-08-06.
**σ-frame reused (not rebuilt from conventions):** packet
`goal_runs_after_541e12f/FIX_H1_EQUALIZER/` — `produce_h1_frame.py`,
`payloads/PAYLOAD_frame.txt`, `payloads/PAYLOAD_theorem.txt`.

**Primary exit:**

```text
FIX-L1-CONSTANTS-OK
```

**Problem E headline: OPEN.**

No degeneracy was found. Every constant named by §5.8 is nonzero and the
transfer condition is a proper, nonvacuous linear condition in all four
`(m, twist)` cases computed. One **correction to §5.8's bookkeeping** is
recorded in §6 below (the "≅ C² by Schur" is an `m = 1` statement; at `m = 3`
the target space is 3-dimensional and the transfer condition has codimension 2).

---

## 1. Conventions (everything below is stated in these, and only these)

Field `K = Q(ω, ν)`, `ω² + ω + 1 = 0`, `ν² = −11`; `δ := ω − ω²` (`δ² = −3`);
`√33 := −ν·δ` — the **positive real** root in the standard embedding
`ζ₁₁ = e^{2πi/11}`, `ω = e^{2πi/3}`, `ν = +i√11` (this is the sign convention
of the H1 frame; verified numerically to 40 digits).

The H1 σ-frame `(E_a, E_b, E_x | E_y, E_z)`: `W⁺ = ⟨E_a,E_b,E_x⟩`,
`W⁻ = ⟨E_y,E_z⟩`, in which `F` is **exactly** the V4-packet normal form (1.1)

```
F = kp·a³ + km·b³ + a(x² + ω y² + ω² z²) + b(x² + ω² y² + ω z²) + xyz ,
```

with the certified residual-S3 data
`ρ|_{W⁻} = [[−1/2,(1−ν)/4],[(−1−ν)/4,−1/2]]`, `τ|_{W⁻} = diag(1,−1)`,
`τ|_{W⁺} = diag(1,1,−1)`.
`Sym²W⁻` is modelled by symmetric 2×2 matrices `S = [S₁₁,S₁₂,S₂₂]` with
`y⊗y = [y², yz, z²]` and `g·S = M S Mᵀ`.

**`ρ|_{W⁺}` in these normal-form coordinates** (new here; the H1 payload printed
it in the *raw* frame, before the diagonal rescaling to (1.1)):

```
  [  1/4 − √33/12      −5/8 + √33/24      1/24 + ω/12 + ν/8 ]
  [ −5/8 − √33/24       1/4 + √33/12     −1/24 − ω/12 + ν/8 ]
  [  1/4 + ω/2 + ν/4   −1/4 − ω/2 + ν/4        −1/2         ]
```

All entries lie in `Q(ω,ν)`. (Independently re-derived by the verifier from
`ρ|_{W⁻}` alone — see §5.)

**Normalisations.** `α` and `β` are each defined only up to a scalar (the
choice of the isotypic generators and of the invariant std-pairing); what is
intrinsic is "= 0 or ≠ 0". The choices fixed here:

| object | generator |
|---|---|
| `(W⁺)[triv]` | `c_σ = E_a + β_{c_σ} E_b` (a-coordinate 1) |
| `(Sym²W⁻)[triv]` | `Ω = diag(1−ν, 1+ν)` |
| invariant quadratic form on `W⁻` | `q₀ = (1+ν)y² + (1−ν)z²`, `⟨q₀,Ω⟩ = 24`, `π_t(S) = ((1+ν)S₁₁+(1−ν)S₂₂)/24` |
| `(W⁺)[std]` | `u₊ = (1+√33)E_a + (√33−1)E_b` (τ = +1), `u₋ = E_x` (τ = −1) |
| `(Sym²W⁻)[std]` | `v₊ = diag(1−ν, −(1+ν))` (τ = +1), `v₋ = E_y⊗E_z+E_z⊗E_y` (τ = −1) |
| std-pairing | `⟨u₋,v₋⟩ := 1` (invariance then forces `⟨u₊,v₊⟩ = 24δ`) |
| `α` | `:= Q(c_σ; Ω)` |
| `β` | `:= Q(u₋; v₋)/⟨u₋,v₋⟩` |

With these, `Q(w; y⊗y) = α·w_t·(y²)_t + β·⟨w_s, (y²)_s⟩` holds **exactly**
(`w = w_t c_σ + w_s`, `y⊗y = (y²)_t Ω + (y²)_s`) — Schur cross-checks
`Q(c_σ; std) = 0` and `Q(std; Ω) = 0` verified.

---

## 2. Task 1 — the A3 decomposition, and `F₀(c_σ) ≠ 0`

Certificate A3's shape is verified *directly on the normal form*: the
`(y,z)`-degrees occurring in `F` are exactly `{0, 2}` — no degree-1 and no
degree-3 terms — so

```
F(w+y) = F₀(w) + Q(w; y, y)   exactly, with
F₀(a,b,x) = kp a³ + km b³ + (a+b) x²                    (cubic on W⁺)
Q(w; S)   = a(ω S₁₁ + ω² S₂₂) + b(ω² S₁₁ + ω S₂₂) + x S₁₂
            (linear in W⁺, quadratic in W⁻; S = y⊗y gives a(ωy²+ω²z²)+b(ω²y²+ωz²)+xyz)
```

`F`, `F₀` and `Q` are each **exactly** `ρ`- and `τ`-invariant in the
normal-form frame (checked as polynomial identities).

Because `c_σ ∈ W⁺` (`y = z = 0`), `F(c_σ) = F₀(c_σ)`:

```
F₀(c_σ) = kp + km·β_{c_σ}³ = (81 + 15√33)/16 = 10.4480274811294018686… ≠ 0
```

which **is** the H1 frame fact `F(c_σ) ≠ 0` (`c_σ` off `X`), now inside the A3
split. Cross-checked against the raw-frame `klein_eval(c_σ) ≠ 0`.

---

## 3. Task 2 — the isotypic split and the constants `α, β`

`W⁺ = triv ⊕ std` with `triv = ⟨c_σ⟩`; `Sym²W⁻ = triv ⊕ std` with
`triv = ⟨Ω⟩`. Explicit bases as in the table of §1. The std split of `W⁺` is
obtained *canonically* as `ker(ℓ)` where `ℓ := Q(·;Ω) ∈ (W⁺)*` is the
invariant functional:

```
ℓ = (√33 − 1) a − (1 + √33) b          (x-coefficient 0)
```

### The constants table

| constant | closed form | numeric (40 digits in `payloads/PAYLOAD_VERIFY.txt`) |
|---|---|---|
| `kp` | `(13 + 3√33)/16` | `1.889605496225880373721989650291049247166` |
| `km` | `(13 − 3√33)/16` | `−0.2646054962258803737219896502910492471663` |
| `β_{c_σ}` (`c_σ = [1:β:0]`) | `−(7 + √33)/4` | `−3.186140661634507164962652867054732329555` |
| `c = −(1+β)` (Chebyshev) | `(3 + √33)/4` | `2.186140661634507164962652867054732329555` |
| `F(c_σ) = F₀(c_σ)` | `(81 + 15√33)/16` | `10.44802748112940186860994825145524623583` |
| **`α = Q(c_σ; Ω)`** | **`9 + 3√33 = 3(3+√33)`** | `26.23368793961408597955183440465678795466` |
| **`β = Q(u₋;v₋)/⟨u₋,v₋⟩`** | **`1`** | `1` |
| std-block of `Q` | `[[24δ, 0],[0, 1]]`, `det = 24δ ≠ 0` | — |

### NONDEGENERACY VERDICTS

* **`α ≠ 0` — YES.** `α = 9 + 3√33 = 3(3+√33)`; `3+√33 > 0` in the real
  embedding, and `N_{Q(√33)/Q}(α) = 81 − 9·33 = −216 ≠ 0`.
* **`β ≠ 0` — YES.** `β = 1`: it *is* the `xyz`-coefficient of the normal form
  (1.1). More strongly, `Q` restricted to `(W⁺)[std] × (Sym²W⁻)[std]` is a
  **perfect** pairing (`det = 24δ ≠ 0`), so the whole std channel is
  nondegenerate, not merely nonzero.

### Structural identities (exact, and frame-independent)

```
α = 12·c ,      α = 16·kp − 4 ,      F(c_σ) = c³ ,      α³ = 1728·F(c_σ)
```

where `c` is **exactly** FIX-H1's Chebyshev uniformiser of the D12-point
(finding H1-D12: `c³ − 3c = kp + 2`, `c_σ = [1 : −(1+c)]`). Consequently

> **`α = 0` ⟺ `c = 0` ⟺ `F(c_σ) = 0`.**

The nondegeneracy of the t-channel constant is therefore *identical* to the
certified frame fact "`c_σ` lies off `X`" (FIX-H1 A1). The transfer condition
inherits its nonvacuity from that piece of geometry — it is not an accident of
the arithmetic.

---

## 4. Task 3 — the generators `γ`

`V_m := Hom(Sym^m W⁻, W⁻)` with the action `(g·L)(y) = g·L(g⁻¹y)`; an element
is a pair `(P,R)` of degree-`m` binary forms, `L(y) = P(y,z)E_y + R(y,z)E_z`.
Note IV Lemma 5.1 predicts `dim V_m[triv] = dim V_m[sgn] = 1` for `m = 1, 3`;
**machine-confirmed, all four spaces are exactly 1-dimensional.**

| space | generator |
|---|---|
| `V₁[triv]` | `y·E_y + z·E_z` = **`id_{W⁻}`** (the scalars; Schur) |
| `V₁[sgn]` | `z·E_y + ((5−ν)/6)·y·E_z`, i.e. the matrix `[[0, 1],[(5−ν)/6, 0]]` — **strictly off-diagonal** |
| `V₃[triv]` | `(y³ − ((5+ν)/6)yz²)·E_y + (y²z − ((5+ν)/6)z³)·E_z` |
| `V₃[sgn]` | `(z³ + ((−5+ν)/6)y²z)·E_y + (((5−ν)/6)yz² + ((−7+5ν)/18)y³)·E_z` |

* **`V₃[sgn]` regression:** proportional (hence equal after adopting H1's
  normalisation) to the generator printed in
  `FIX_H1_EQUALIZER/payloads/PAYLOAD_theorem.txt` §5. **MATCH.**
* **"which is which"** (brief's question about H1's `Im(ev)` analysis): the
  `diag(1,−1)`-type element appearing at order 1 in `PAYLOAD_theorem.txt` §9 is
  **neither** `V₁[triv]` (`= ⟨id⟩`) **nor** `V₁[sgn]` (off-diagonal). Under
  `V₁ = End(std) = triv ⊕ sgn ⊕ std`, `diag(1,−1)` spans the `τ = +1` line of
  the **std** isotypic piece. The `τ`-invariant (diagonal) subspace of `V₁` is
  `triv ⊕ std^{τ=+1} = ⟨id, diag(1,−1)⟩`, which is what H1's order-0/order-1
  `Im(ev_{v₀})` filtration walks through; `V₁[sgn]` is transverse to it.
* **e-parity selector** (Lemma 5.5: `w₁ ∈ V_m[sgn^{e+1}]`):
  `e` **even** ⇒ `V_m[sgn]` (H1 branch (ii): `m=1, r=7, e=6`);
  `e` **odd** ⇒ `V_m[triv]` (H1 branch (i): `m=3, r=6, e=3`).
  Both twists are computed for both `m`, so either parity is served.

---

## 5. Task 4 — the transfer pairings and the transfer condition

### Where each object lives (the bookkeeping the director asked for)

* `γ ∈ V_m = Hom(Sym^m W⁻, W⁻)`, so `γ(y^m) ∈ Sym^m(W⁻)* ⊗ W⁻`.
* `γ(y^m) ⊗ γ(y^m) = [P², PR, R²] ∈ Sym^{2m}(W⁻)* ⊗ Sym²W⁻` — a degree-`2m`
  binary form with values in `Sym²W⁻`.
* `(γ⊗γ)_t := π_t(γ(y^m)⊗γ(y^m)) ∈ Sym^{2m}(W⁻)*` — a scalar-valued degree-`2m`
  binary form (the coefficient of `Ω`).
* `(γ⊗γ)_s ∈ Sym^{2m}(W⁻)* ⊗ (Sym²W⁻)[std]` — written below in the basis
  `(v₊, v₋)`.
* `Θ := Θ⁽⁰⁾(c_σ) ∈ Hom(Sym^{m+1}W⁻, W⁺)^{S3}` — the plus-package value at `c_σ`.
* The transfer identity is an identity of binary forms of degree `3m+1`:

```
    c² · Q( Θ(y^{m+1}) ; γ(y^m) ⊗ γ(y^m) )  ≡  0     in Sym^{3m+1}(W⁻)* .
```

### The canonical adapted basis of `Hom(Sym^{m+1}W⁻, W⁺)^{S3}`

* **t-channel**: `Θ_t = f(y)·c_σ`, `f` an S3-invariant binary form of degree
  `m+1`. Then, **exactly**, `Q(Θ_t(y^{m+1}); γ⊗γ) = α · f(y) · (γ⊗γ)_t(y)`.
* **s-channel**: `Θ_s` with image in `(W⁺)[std] = ker(ℓ)`, i.e.
  `Θ_s(y^{m+1}) = A₊(y)u₊ + A₋(y)u₋`. Then, **exactly**,
  `Q(Θ_s(y^{m+1}); γ⊗γ) = β · [ 24δ·A₊(y)·(γ⊗γ)_{s,v₊}(y) + A₋(y)·(γ⊗γ)_{s,v₋}(y) ]`.

Both identities are machine-verified in every case. **This is precisely §5.8's
`α θ_t (γ⊗γ)_t + β⟨θ_s, (γ⊗γ)_s⟩`**, with `θ_t`, `θ_s` the coordinates in the
adapted basis.

### The data, per `(m, twist)`

The S3-invariant forms `f` used for the t-channel:
`m+1 = 2`: `f = ((−5+ν)/6)y² + z²`;
`m+1 = 4`: `f = ((7−5ν)/18)y⁴ + ((−5+ν)/3)y²z² + z⁴` (each unique up to scalar).

| `(m, twist)` | `(γ⊗γ)_t` (degree `2m`) | `(γ⊗γ)_s` (degree `2m`, in `v₊, v₋`) |
|---|---|---|
| `(1,triv)` | `((1+ν)/24)y² + ((1−ν)/24)z²` | `[((1+ν)/24)y² + ((−1+ν)/24)z²]v₊ + [yz]v₋` |
| `(1,sgn)` | `(−1/9 − ν/36)y² + ((1+ν)/24)z²` | `[(1/9 + ν/36)y² + ((1+ν)/24)z²]v₊ + [((5−ν)/6)yz]v₋` |
| `(3,triv)` | `((1+ν)/24)y⁶ + ((1−ν)/8)y⁴z² + (−1/3+ν/12)y²z⁴ + ((31−ν)/216)z⁶` | `[((1+ν)/24)y⁶ + ((1−ν)/24)y⁴z² + (1/9−ν/36)y²z⁴ + ((−31+ν)/216)z⁶]v₊ + [y⁵z + (−5/3−ν/3)y³z³ + ((7+5ν)/18)yz⁵]v₋` |
| `(3,sgn)` | `((−83+13ν)/648)y⁶ + ((31+ν)/72)y⁴z² + (−1/3−ν/12)y²z⁴ + ((1+ν)/24)z⁶` | `[((83−13ν)/648)y⁶ + ((−31−ν)/216)y⁴z² + (−1/9−ν/36)y²z⁴ + ((1+ν)/24)z⁶]v₊ + [(−5/27−8ν/27)y⁵z + ((−7+5ν)/9)y³z³ + ((5−ν)/6)yz⁵]v₋` |

(The `α·(γ⊗γ)_t` and `β·(γ⊗γ)_s` vectors are printed in full in
`payloads/PAYLOAD_L1.txt` part E; since `β = 1`, `β·(γ⊗γ)_s = (γ⊗γ)_s`.)

### TRANSFER VERDICTS

```
 (m, twist)   dim Hom(Sym^{m+1}W⁻,W⁺)^{S3}   rank   codim   solution dim   verdict
 (1, triv)                2                   1       1          1        NONVACUOUS (proper hyperplane)
 (1, sgn )                2                   1       1          1        NONVACUOUS (proper hyperplane)
 (3, triv)                3                   2       2          1        NONVACUOUS (codimension 2)
 (3, sgn )                3                   2       2          1        NONVACUOUS (codimension 2)
```

* **In all four cases the coefficient vector `(α·(γ⊗γ)_t , β·(γ⊗γ)_s)` is
  nonzero, and both of its parts are nonzero separately.**
  The transfer locus is a **proper** linear subspace — a hyperplane at `m = 1`,
  codimension 2 at `m = 3` — so the transfer condition is **NONVACUOUS**.
  No degeneracy anywhere.
* Rank is never 0 (would mean "no condition") and never full (would mean
  "`Θ⁽⁰⁾(c_σ) = 0` forced"), so the condition genuinely *transfers* rather than
  kills, exactly as §5.8 predicts for `m = 1`.
* The solution space is 1-dimensional in every case; its coordinate vectors in
  the adapted `(θ_t; θ_s)` basis are in `payloads/PAYLOAD_L1.txt` part F and in
  the JSON (`transfer.*.kernel`).

---

## 6. Findings and one correction owed back to §5.8

1. **`α = 12c` and `F(c_σ) = c³`.** The t-channel constant is 12× the
   Chebyshev coordinate of the D12-point. Hence `α ≠ 0` **is** the statement
   `c_σ ∉ X` — a certified frame fact, not a coincidence. Any future frame
   (any σ, any V4) obeys the same identity, so the transfer condition can never
   degenerate on the t-channel for *this* cubic.
2. **`β = 1` is the `xyz`-coefficient.** The std channel is nondegenerate for a
   structural reason: `Q` identifies `W⁺ ≅ (Sym²W⁻)*` (the induced 3×3 matrix
   has determinant `δ ≠ 0`), so `Q` is nondegenerate *as a whole*, not just on
   one isotype. This is also what lets the verifier derive `ρ|_{W⁺}` from
   `ρ|_{W⁻}` (§1 of `payloads/PAYLOAD_VERIFY.txt`).
3. **CORRECTION to §5.8's parenthetical.** The note writes
   `(θ_t, θ_s) := Θ⁽⁰⁾(c_σ) ∈ Hom(Sym²std, triv ⊕ std)^{S3} ≅ C² (Schur)`.
   That is an **`m = 1`** statement. For general odd `m`, `Sym^{m+1}std`
   decomposes with multiplicity: `Sym⁴std = triv ⊕ 2·std`, so at `m = 3`
   ```
   dim Hom(Sym⁴W⁻, W⁺)^{S3} = 1 (t) + 2 (s) = 3 ,
   ```
   and the computed transfer condition there has **codimension 2**, i.e. it is
   *stronger* than a hyperplane: it cuts the 3-dimensional space of admissible
   `Θ⁽⁰⁾(c_σ)` down to a line. The §5.8 sentence "the plus-package value at
   `c_σ` is forced onto an explicit hyperplane" should read "onto an explicit
   proper linear subspace, of codimension 1 at `m=1` and codimension 2 at
   `m=3`". This strengthens the [L] rung rather than weakening it.
4. **Bookkeeping still owed by the derivation (not decided here).** §5.8 itself
   flags "escape at order exactly `2e+2`, and unequal line-wise orders". One
   further item the director should pin before consuming the I₁ rung: whether
   `Θ⁽⁰⁾` is itself forced to vanish at `c_σ` (e.g. by a `D`-divisibility of
   the plus-package analogous to `Φ⁽⁰⁾ = D^e Ψ`). If it were, the transfer
   condition would be satisfied vacuously by `Θ⁽⁰⁾(c_σ) = 0` and the content
   would move one order up. This packet computes the condition *on the datum
   `Θ⁽⁰⁾(c_σ)` as a free element of `Hom(Sym^{m+1}W⁻,W⁺)^{S3}`*, which is what
   §5.8 asks for; it does not adjudicate the vanishing question.
5. **Frame independence.** 11 different `(σ, V4)` choices were rebuilt from the
   group. With the intrinsic normalisation
   `ν̃ := (Ω₂₂−Ω₁₁)/(Ω₂₂+Ω₁₁)`, `s̃ := −ν̃δ`, `Ω̃ := diag(1−ν̃, 1+ν̃)`, **every**
   one satisfies the *same* closed forms
   ```
   kp = (13+3s̃)/16 ,  β_{c_σ} = −(7+s̃)/4 ,  α = 9+3s̃ ,  β = 1 ,
   ```
   with `s̃ = +√33` on the reference labelling and `s̃ = −√33` on the Galois-
   conjugate labelling (which swaps `kp ↔ km`). `α ≠ 0` and `β ≠ 0` in every
   frame tested. The constants are not artefacts of the H1 representative.

---

## 7. Cross-checks actually run

| check | route | result |
|---|---|---|
| frame regression | producer rebuilds PSL(2,11) from Weil generators, reproduces H1's `σ = g[1]`, `K₁ = (1,385,454)`, `kp`, `β`, `ρ\|_{W⁻}`, `τ\|_{W⁻}` closed forms | MATCH |
| normal form | raw-frame `F` rescaled by the explicit diagonal rescaling equals (1.1) exactly | MATCH |
| `S3`-invariance | `F`, `F₀`, `Q` invariant under `ρ`, `τ` in normal-form coordinates, as polynomial identities | PASS |
| Lemma 5.1 | `dim V_m[triv] = dim V_m[sgn] = ((m+1) − χ_{Sym^m std}(ρ))/3 = 1` for `m = 1,3` | PASS |
| H1 `V₃[sgn]` generator | proportional to `PAYLOAD_theorem.txt` §5 | MATCH |
| §5.8 t-channel identity | `Q(f·c_σ; γ⊗γ) = α·f·(γ⊗γ)_t` for every invariant `f` | PASS (all 4) |
| §5.8 s-channel identity | `Q(Θ_s; γ⊗γ) = β·[24δ A₊(γ⊗γ)_{v₊} + A₋(γ⊗γ)_{v₋}]` | PASS (all 4) |
| Schur | `Q(c_σ; std) = 0`, `Q(std; Ω) = 0` | PASS |
| **independent recompute** | `verify_l1.py`: own exact field `Q(ω,ν)` written from scratch; **no group theory at all**; `ρ\|_{W⁺}` *derived* from `ρ\|_{W⁻}` via the isomorphism `Q : W⁺ → (Sym²W⁻)*`; `β_{c_σ}` *derived* as the S3-fixed point of `W⁺`; `(kp,km)` *derived* from S3-invariance of `F₀`; then every payload number compared | **272 exact checks, 0 failures** |
| 40-digit numerics | `mpmath`, `dps = 40`, all closed forms to `< 1e−35` | PASS |
| frame independence | 11 `(σ, V4)` rebuilds | PASS |

Exact arithmetic only; no floating point enters any decision (the numerics are a
printed sanity layer). No `git` operations; nothing written outside the packet.

---

## 8. Files

```
produce_l1.py                 producer (Q(zeta_33), group rebuilt from generators)
verify_l1.py                  INDEPENDENT verifier (own Q(om,nu), no group, self-tests)
payloads/PAYLOAD_CONSTANTS.txt   the constants table + verdicts (compact)
payloads/PAYLOAD_L1.txt          full producer log (parts A–G)
payloads/l1_constants.json       machine-readable: every constant in three encodings
                                 (Q(zeta_33) vector, Q(om,nu)/sqrt33 coordinates,
                                 numeric) + all verdicts
payloads/PAYLOAD_VERIFY.txt      full verifier log (the 40-digit numerics live here;
                                 *.log is gitignored repo-wide, so logs/ is a local mirror)
logs/PRODUCE.log , logs/VERIFY.log   local mirrors (untracked)
REPLAY.md
```
