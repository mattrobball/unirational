# Status — FIX-H1, the S3-equalizer at the D12-points

**Primary exit:** `FIX-H1-PARTIAL`

The *primary task* — the S3-equalizer — is a clean **PASS**: both surviving
branches are killed, unconditionally in `d`, at order 0. The packet is
`PARTIAL` because of the *secondary* task: **neither odd-row hole is closed**.
`(1,8)` is 282/288 leaves characteristic-0 certified (with a precise partial
theorem: any plane-order-1 point needs *both* plane-order-1 coefficients
nonzero), and `(1,6)` above line degree 2 is a modular finding only.

**Problem E headline: OPEN.**

Packet: `goal_runs_after_541e12f/FIX_H1_EQUALIZER/`.
Frame: `theory/FIX_H1_coupling.md` §4/§5; `theory/FIX_III_cosheaf.md` §6.
Predecessors: FIX-H0 (`goal_runs_after_6519c0b`), FIX-N2C
(`goal_runs_after_a90dbe1`), FIX-N2B (`goal_runs_after_fa02f05`), V4 packet
(`goal_runs_after_f1f0be`).
Verification class: **ALGEBRAIC-RECOMPUTE** (`verify_h1.py`, 43 checks,
0 failures, harness self-test included; terminal marker `FIX_H1_VERIFY_OK`).
Toolchain: `python3`/sympy exact, a self-contained exact `QQ(ω,√−11)` engine
(`k0.py`), Macaulay2, msolve (parenthesis-free, bare-integer inputs only).
No GAP/Sage/Magma/PARI.

---

## 0. The four scoped exits

| scoped exit | content |
|---|---|
| `FIX-H1-EQ-M3-EMPTY` | **theorem** — no member of the `(3,·)` `D_B` branch satisfies the order-0 S3-equalizer at `c_σ`: not for any `B` on the trace curve, not at any line degree, not in any degeneration, and not under any Galois twist of the conventions. |
| `FIX-H1-EQ-M1-EMPTY` | **theorem, on the classified branch** — none of the 27 primitive Chebyshev `(1,7)` witnesses (nor any `q^k`-translate) satisfies the order-0 equalizer; the residual is invertible modulo each block ideal (exact Nullstellensatz certificates) and Macaulay2 returns the unit ideal in all three eigenblocks. |
| `FIX-H1-HOLE-1EVEN-PARTIAL` | **282 of 288 leaves** of the `(1,8)` line-degree-0 problem are characteristic-0 certified EMPTY (three eigenblocks). Fully certified: the strata `{B6≠0, B9=0}` and `{B6=0, B9≠0}` — so **any plane-order-1 point of the `r=8` cone must have BOTH plane-order-1 coefficients nonzero**. The 6 remaining leaves (one 11-variable / 22-generator generic leaf per block per chart) were still computing at close. §6a. |
| `FIX-H1-HOLE-16-PARTIAL` | **finding, not a verdict** — at line degrees 3, 4, 5 every plane-order-1 coordinate of every `T_j` is forced to zero over all 144 cone-line pairs (8640 msolve runs, zero `CAN-BE-NONZERO`), but **modulo `p = 100057` only**, and mod-`p` emptiness does not lift. Line degree 6 was launched and had not returned at close; `≥ 7` untouched. The characteristic-0 upgrade is specified exactly. §6b. |

Two further results of independent interest:

| exit | content |
|---|---|
| `FIX-H1-LOCALIZATION-THEOREM` | **Theorem H1-1** — the cross-V4 coupling localises at `c_σ` to a *finite, explicit, unconditional* criterion; §1. Corollary: the line degree of any global map obeys `d − r ≥ 6(r−m)`, i.e. **`d ≥ 7r − 6m`** — a new unconditional degree lower bound (`d ≥ 24` for `m=3, r=6`; `d ≥ 43` for `m=1, r=7`), and **no line-degree-0 cell element can be the germ of a global map**. |
| `FIX-H1-D12-IS-THE-CHEBYSHEV-POINT` | **finding** — the D12-point of `ℓ_V` has `(b/a)`-coordinate `β` with `β³ + 3β² + κ₊ = 0`, i.e. `β = −(1+c)` with `c³ − 3c = κ₊+2`. The concurrency point of the three mirror lines *is* the Chebyshev point of FIX-H0's trace curve. §2. |

---

## 1. Theorem H1-1 — the equalizer criterion (unconditional)

Full derivation in `payloads/PAYLOAD_theorem.txt`. Statement:

Let `f` be `G`-equivariant, dominant, of degree `d`, with germ multi-order
`(r; m,m,m)`, `m` odd (H0-1). Let `V := Hom(Sym^m W⁻_σ, W⁻_σ)` with the
residual-`S3` action, `e := r − m`, and let

```
Λ  :=  ( the (y,z)-degree-m part of T⁻ ) / x^e   ∈  H⁰(ℓ_V, O(d−r)) ⊗ V
```

be the **leading line datum** — for a Note-II cell germ this is literally the
cell element's leading `(m,r)`-datum. Then:

**(a)** `Λ` vanishes to order `≥ 2e` at **each of the three D12-points** of
`ℓ_V`; hence `d − r ≥ 6e`, i.e. `d ≥ 7r − 6m`.

*(Precisely: put `e' := ord_{ℓ_V}(Φ) ≥ r − m`, with equality iff the leading
graded piece `T_r` — the Note-II cell datum — attains the plane order `m`,
which is the case for every classified witness. Everything below is stated
with `e = e'`; unconditionally `d ≥ m + 7e' ≥ 7r − 6m`.)*

**(b)** its order-`2e` Taylor coefficient `λ_{2e}` at `c_σ` lies in the
**one-dimensional** space
`V[sgn^e] = {L : ρ.L = L, τ.L = sgn(τ)^e L}`.

**(c)** the order-`k` conditions (`k ≥ 1`) read
`λ_{2e+k} ∈ Im(ev_{v₀} : (Sym^k(std*) ⊗ V ⊗ sgn^e)^{S3} → V)`.

*Proof skeleton.* The leading package `Φ ∈ H⁰(P_σ,O(d−m)) ⊗ V` is
`S3`-equivariant (σ acts trivially on `V` for `m` odd) and vanishes to order
`≥ e` along **each** of the three mirror lines, because `ord_{ℓ_{V,i}}T = r`
for all three (one `G`-class of V4's). The three lines are distinct, so
`Φ = D^e Ψ` with `D = N₁N₂N₃` the mirror cubic; `D` carries the **sgn**
character (verified exactly from the frame matrices, verifier check V3), so
`g.Ψ = sgn(g)^e Ψ`. `c_σ` spans `W^{D12}`, so `D12` acts trivially on the
fibre of `O(k)` there: `Ψ(c_σ) ∈ V[sgn^e]`. Restricting to `ℓ_{V,1}` and
dividing by `N₁^e` gives `Λ = const·(N₂N₃)^e|_{ℓ_V}·Ψ|_{ℓ_V}`, and
`(N₂N₃)|_{ℓ_V}` vanishes to order exactly 2 at `c_σ`. ∎

**Two structural facts that make the criterion sharp.**

1. **The transposition twist is automatic.** `τ` is the residual image of an
   involution *of `K₁` itself*, and the cell germ is `A₄`- hence
   `K₁`-equivariant, so `τ.Λ = sgn(τ)^e Λ` holds identically. Machine-verified
   for every branch member. **The entire content of the equalizer is the
   `ρ`-part** — the residual 3-cycle of `C_G(σ)`, which lies in no `N_G(V4)`
   and which therefore no cell computation has ever seen. This is exactly
   FIX-H0 §4b's "cross-V4 coupling", now reduced to a `2×2` matrix condition.
2. **Order-by-order the equalizer is discriminating only at orders 0 and 1**
   (exact codimension count, `produce_h1_equalizer.py`):

   | branch | `dim V` | `dim V^{τ,sgn^e}` | k=0 | k=1 | k=2 | k=3 | k=4 |
   |---|---|---|---|---|---|---|---|
   | (i) `m=3, e=3` | 8 | 4 | **3** | **1** | 0 | 0 | 0 |
   | (ii) `m=1, e=6` | 4 | 2 | **1** | **1** | 0 | 0 | 0 |

   (entries = number of independent conditions). **Order reached: 4** — four
   orders past the first order at which the three jets interact. Both verdicts
   below already fire at order 0, so the higher orders are not needed.

   The order-1 conditions are computed explicitly too. For `m = 1`:
   `Im(ev_{v₀})` is spanned by `diag(1,−1)`, so the **complete** equalizer at
   `c_σ` for the `m = 1` row is the pair of scalar conditions
   `u_{2e} = v_{2e}` (order 0: `λ_{2e}` scalar) **and**
   `u_{2e+1} + v_{2e+1} = 0` (order 1: `λ_{2e+1}` traceless), where
   `Λ = diag(u,v)`; from order 2 on there is nothing. That is the exact
   residual constraint on the unclassified positive-line-degree `(1, odd r)`
   cell — see `payloads/PAYLOAD_theorem.txt` §8–§9.

---

## 2. The exact geometry at `c_σ` (all recomputed from generators)

`produce_h1_frame.py` rebuilds `PSL(2,11)` in the 5-dimensional Weil
representation over `Q(ζ₁₁)`, picks an involution `σ`, and constructs the
`A₄`-adapted frame in which `F` is **exactly** the V4-packet normal form (1.1).

* `σ` lies in exactly 3 V4's; their triple lines lie in `P_σ` and are
  **concurrent at `c_σ`**; `F(c_σ) ≠ 0`.
* `ℓ_V` carries exactly 3 D12-points, one per involution of `K₁`; they form
  **one free `C₃`-orbit** (same `(b/a)³`), so **one computation serves all
  three** — and, all 55 V4's being one `G`-class, all `55×3` sites.
* `κ₊ + κ₋ = 13/8`, `κ₊κ₋ = −1/2`, with `κ₊ = (13+3√33)/16` in the packet
  frame (which root the `ω`-labelled row carries depends on the choice of the
  order-3 generator of `A₄`; **all verdicts below are tested against both
  roots and all four `ω↔ω²`, `ν↔−ν` twists**).
* `ρ|_{W⁻} = [[−1/2, (1−ν)/4], [(−1−ν)/4, −1/2]]`, `ν = √−11`
  (trace −1, det 1, off-diagonal **nonzero**: `W⁻` is `D12`-irreducible);
  `τ|_{W⁻} = diag(1,−1)`.
* **`c_σ = [a:b] = [1 : β]` with `β³ + 3β² + κ₊ = 0`, i.e. `β = −(1+c)`,
  `c³ − 3c = κ₊+2`.** The D12-point is the Chebyshev point of the trace curve.

---

## 3. Branch (i) — the `(3,·)` `D_B` family: `FIX-H1-EQ-M3-EMPTY`

`V = Hom(Sym³W⁻, W⁻)` is 8-dimensional, `e = 3` is odd, `dim V[sgn] = 1`,
spanned exactly by

```
z³E_y + ((−5+ν)/6) y²z E_y + ((5−ν)/6) yz² E_z + ((−7+5ν)/18) y³E_z .
```

The leading datum of `D_B(yz)` (the T5 witness, `λ = ω²`) is
`Λ₀ = ω(z³+B y²z)E_y + ω²(y³+B⁻¹yz²)E_z`. At line degree `3μ` the `(3,6)`
`D_B` family is `D_B(f·yz)` — `yz` is the **only** degree-2 `χ_x` form, so `X`
is forced — and then

```
Λ(s,t) = ω g₁³ (z³ + B_eff y²z) E_y + ω² g₂³ (y³ + B_eff⁻¹ yz²) E_z ,
g₁ = Θf, g₂ = Θ²f, B_eff = B (g₂/g₁)² .
```

So every possible `λ_{2e}` lies in the Zariski closure

```
S_DB = { (c₁z³+d₁y²z)E_y + (c₂y³+d₂yz²)E_z  :  d₁d₂ = c₁c₂ } ,
```

a quadric cone in a 4-dimensional coordinate subspace of `V`. **The equalizer
line lies inside that subspace and on the quadric** — so the order-0 condition
does not fail for shape reasons; instead it pins the shape parameters
*uniquely*:

```
B_eff = (−5+ν)/6 ,   c₂/c₁ = (−7+5ν)/18 = −B_eff² .
```

Eliminating `t = g₂/g₁` from `c₂/c₁ = ω t³`, `t² = B_eff/B` gives the branch's
own exact constraint `(c₂/c₁)² B³ = ω² B_eff³`, which **forces**

```
B³ + B⁻³  =  (5 − √33)/6  =  −0.1240937744230047766…
```

whereas the trace curve demands `B³+B⁻³ = κ₊+2 = 3.889605496…` (or, on the
conjugate branch, `κ₋+2 = 1.735394503…`). **No match** — exactly, at 60
digits, and under every one of the four Galois twists. The degenerate limits
`ord(g₁) ≠ ord(g₂)` give `λ_{2e} = ω g₁³ z³E_y` or `ω² g₂³ y³E_z`, which are
off the equalizer line because its generator has **both** `c₁ ≠ 0` and
`c₂ ≠ 0`.

Run on every classified odd-`m` `D_B` member of the FIX-H0 branch table
(`produce_h1_branch1.py`):

| member | `(m,r)` | `e` | order-0 equalizer |
|---|---|---|---|
| `D_B(yz)` (T5 witness) | (3,6) | 3 | **EMPTY** (every line degree) |
| `q·D_B(yz)` | (3,8) | 5 | **EMPTY** |
| `D_B(xy²)` primitive | (3,9) | 6 | **EMPTY** |
| `D_B(xz²)` | (3,9) | 6 | **EMPTY** |
| `(xyz)²·D_B(yz)` | (7,12) | 5 | **EMPTY** |
| `D_B(x³)` — positive control | (0,9) | 9 | already excluded by **H0-1** (plus half leads) |

**Scope.** EMPTY holds for the `D_B` branch at *every* line degree (the `(3,6)`
case; the others at line degree 0, which is all that is classified). A
hypothetical **non-`D_B`** `(3,6)` family at positive line degree would be a
*new, unclassified* branch — the same class of unknown as the odd-row holes,
not a gap in this computation.

---

## 4. Branch (ii) — the primitive Chebyshev branch: `FIX-H1-EQ-M1-EMPTY`

`V = End(W⁻)` is 4-dimensional, `e = 6` is even, so the twist is trivial and
`V[triv] =` the **scalars** (Schur; `W⁻` is `S3`-irreducible). `τ|_{W⁻} =
diag(1,−1)` forces `Λ` **diagonal** (automatic), and `ρ|_{W⁻}` has nonzero
off-diagonal entries, so a diagonal `Λ` commutes with `ρ` iff its two diagonal
entries are equal:

```
ORDER-0 EQUALIZER (branch ii):   Λ_yy = Λ_zz ,
Λ_yy = [x⁶y] u₁' ,  Λ_zz = [x⁶z] u₂' .
```

The residual-`C₃` relation `ψ(T) = λ g(T)` gives `u₁' = λ⁻¹ u₀'∘S`,
`u₂' = λ⁻² u₀'∘S²`, hence `Λ_yy = λ⁻¹B8`, `Λ_zz = λ⁻²B5`, i.e. the condition
is exactly **`B5 = λ·B8`** — a relation between FIX-N2C's two plane-order-1
parameters. Both readings (structural, and literal expansion of the three
exact witnesses) agree; all 52 landing equations were re-verified as part of
the rebuild.

Exact residuals, reduced modulo each block ideal:

| block | `Λ_yy − Λ_zz` | decision |
|---|---|---|
| `λ = 1` | `−(P1·c·ω − P1·c + 4ω + 2)/2` | invertible mod `I` (explicit `h` with `Dh = 1`) |
| `λ = ω` | `2ω + 1 = δ` — a **nonzero constant** | trivially invertible |
| `λ = ω²` | `(ω+1)·B2·P1/2` | invertible mod `I` (explicit `h`) |

So `Λ_yy − Λ_zz` vanishes at **0 of the 27 points**. Confirmed independently
by **Macaulay2** over `toField(QQ[om,kp]/(om²+om+1, 8kp²−13kp−4))`:
`dim I = 1` (in the 3-variable ambient), `degree I = 9`, and
`1 % (I + (Λ_yy−Λ_zz)) == 0` — the **unit ideal** — in all three eigenblocks;
and by **40-digit numerics at all 27 points**.

**Closed form (`λ = 1`).**

```
B5 = B8  ⟺  P1·c = 2ω  ⟹  4κ² + 27 = 0   (κ = κ₊+2)
```

— i.e. exactly the degeneration `κ² = −27/4` of the **second** Chebyshev cubic
`v³ − 3v = −27/(4κ)` of FIX-H0's finding D-2. It fails because `κ = κ₊+2` is
real: reduced modulo `8κ₊²−13κ₊−4` one gets `4κ²+27 = 45(κ₊+2)/2 = 87.5161…`.

> The equalizer for the `m = 1` branch is therefore *precisely* the collision
> of the two character surfaces `S_{κ₊}`, `S_{κ₋}` of the Klein identity
> `(κ₊+2)(κ₋+2) = 27/4`, and the identity itself is what prevents it.

**Scope.** This is the branch **as classified**: the 27 line-degree-0
witnesses and their `q^k`-translates (which have the *same* leading datum),
i.e. everything FIX-N2C and FIX-H0's branch table contain. Positive-line-degree
elements of the `(1, odd r)` cell have never been classified anywhere in the
FIX chain; they are carried here as an **explicit unknown of the same class as
the two odd-row holes**. Note, though, that **Theorem H1-1(a) excludes line
degree 0 outright** for *every* branch, so the classified branch is dead twice
over.

---

## 5. Mixed assignments and the remaining parameter freedom

> **There is no per-V4 freedom. The branch parameter is global, and one
> computation at one D12-point of one V4 decides all `55 × 3` sites.**

Precisely:

1. The 55 V4's form one `G`-class and the 55 involutions form one `G`-class,
   so `(m,r)` is a single global invariant (FIX-H0, sharpening 1) and `𝒜/G`
   has one V4-line orbit.
2. A `G`-equivariant section is a `Stab`-fixed stalk element at one
   representative, `Stab_G(ℓ_V) = N_G(K₁) = A₄`. A Note-II cell datum is
   `A₄`-equivariant **by definition** (residual scalar `λ ∈ μ₃`), so a cell
   point *is* an `A₄`-fixed stalk element and the other 54 lines carry its
   `G`-translates. Mixed assignments — different `B`, or different Chebyshev
   points, at different V4's — are therefore **impossible**; there is no
   stabiliser-twisted freedom for a set-valued stalk (FIX-H0 §5).
3. What freedom remains is exactly: the eigenblock `λ ∈ μ₃`; the branch
   parameter (`B` among the 6 roots of `B⁶−(κ₊+2)B³+1 = 0` for the `D_B`
   branch, or one of the 9 points per block for the Chebyshev branch); and the
   line-degree datum `f`. The residual `C₃ = A₄/K₁` acts on this data by the
   `λ = ω²` mechanics — `Θ` multiplies the `D_B` tuple by `ω²` and rotates
   `(x,y,z)`, fixing `B` and cyclically permuting the three planes `P₁,P₂,P₃`
   **and** the three D12-points of `ℓ_V` simultaneously. The quotient is
   therefore taken by identifying the three D12-points, which is exactly why
   one D12-point suffices; and the tests above run over **all** values of the
   surviving parameters (all 6 roots `B`, both roots `κ±`, all 4 Galois twists,
   all 27 Chebyshev points, all three eigenblocks).
4. At `c_σ` the three mirror lines carry the **same** branch germ, twisted by
   the three transpositions — and §1's fact 1 shows that twist is automatic.
   The only genuine cross-V4 content is the residual 3-cycle `ρ`, i.e. the
   condition computed here.

---

## 6. Secondary task — the two odd-row holes

Full account in `payloads/HOLES_REPORT.md`; scripts `holes_*.py`.

### 6a. `FIX-H1-HOLE-1EVEN-PARTIAL` — `(1,8)` at line degree 0

> **Correction, recorded deliberately.** An interim pass of this computation
> read as a clean `EMPTY`, and `payloads/HOLES_REPORT.md` §3 is written in
> those terms. The completed accounting is weaker and is what stands:
> **282 of the 288 leaves** are characteristic-0 certified EMPTY; **6 are
> not decided** (one 11-variable / 22-generator generic leaf per eigenblock
> per chart, i.e. `B_43` and `D_41` in each of `λ = 1, ω, ω²` — logs
> `HARD6.log`, `HARD6b.log`). `HOLES_REPORT.md` §3 is superseded by this
> subsection.
>
> These six are genuinely hard, not merely queued: the exact reducer cannot
> split them (`harder reduce -> 1 subleaves: [(11, 22)]`), and even the
> **modular** probe on `λ = 1`, `B_43` returned `mod-p ERR` after 1500 s
> (`HARD6b.log`). Per this packet's own discipline an `ERR` is an error, never
> a verdict. Closing them needs a better route into these two charts — e.g.
> exploiting that on them *both* `B6 ≠ 0` and `B9 ≠ 0`, which the four-strata
> argument has not yet been pushed to use.

What **is** established in characteristic zero: the strata `{B6 ≠ 0, B9 = 0}`
and `{B6 = 0, B9 ≠ 0}` are **fully certified empty**, hence

> **any plane-order-1 point of the `r = 8` cone must have BOTH plane-order-1
> coefficients `B6` and `B9` nonzero.**

The undecided residue is exactly the two "both nonzero" charts. So the even-`r`
alarm is **not** confirmed, but it is also **not** refuted.

*Method (unchanged, and it is what makes the residue so small).* The
plane-adic filtration at even `r` is the filtration by
`U`-degree (`U = x²`), and the top-`U` component of the landing polynomial is a
quadratic form in `V, W` whose three coefficients give the two sparse
generators `X0·B6² = 0`, `Y1·B9² = 0` (`X = ω²P+ωR`, `Y = ωP+ω²R`; `B6, B9`
are exactly the two plane-order-1 parameters). Since the cone is homogeneous,
`{m = 1}` decomposes into **four honest strata** — `{B6=1,B9=0}`,
`{B6=1,Y1=0}`, `{B9=1,B6=0}`, `{B9=1,X0=0}` — with no saturation and no
Rabinowitsch slack. Exact branch-and-reduce (linear elimination, monomial
splitting, and exact factorisation over `K = QQ(√−3,√33)` — the last is what
cracks the perfect-cube generators) leaves small leaves, and **every leaf is
decided by three independent characteristic-0 engines**: msolve over `QQ` with
`ω, κ₊` adjoined as variables plus their minimal polynomials (rigorous by
Galois transitivity), Macaulay2 over
`toField(QQ[om,kp]/(om²+om+1, 8kp²−13kp−4))`, and a sympy Gröbner basis — plus
a three-prime modular cross-check as a finding. Every **decided** leaf reports
`100057:UNIT,100153:UNIT,1048609:UNIT | qq=True | M2=True | sympy=True | EMPTY`
(`logs/C2_R8_{one,om,om2}.log`, `logs/PAR_R8.log`); 40 leaves also carry a
Macaulay2 verdict and 48 carry all three engines, with **zero disagreements**
anywhere. `logs/M2PASS_R8.log` ends in a `BrokenPipeError` (a multiprocessing
crash, not a mathematical failure) — the M2 pass it was driving is therefore
incomplete, which is part of why 6 leaves remain.

*Independent confirmations.* (i) The equations were rebuilt from scratch in
sympy from the raw Klein normal form: **82 = 82** coefficient equations, **0
mismatches**, same parameter plane orders, same plane-order-1 set `{B6,B9}`
(`logs/INDEP_R8.log`). (ii) The identical pipeline run at `r = 6`, where
Theorem N2B-1 already gives the char-0 answer, **reproduces it**. (iii) Both
char-0 engines were controlled in *both* directions, including on `K`-specific
inputs (`logs/ctrl_*.log`).

*Toolchain finding — recommend adding to FIX-N2C's `MSOLVE_PARSER.md`.* msolve's `-g` output
begins with a `#` comment header, so a naive `startswith('[1]')` unit-ideal test
reports **every** run as non-unit. That bug was live for one round inside this
packet and produced a spurious "the `r=8` cone has plane-order-1 points"
reading; it is now `body in ('1','-1')` after stripping the header, matched to
FIX-N2B's parser and self-tested against unit and non-unit controls.

*Scope and the general even-`r` pattern.* Everything here is at **line degree
0** (what the brief asked); positive line degree at even `r` is untouched.
There is **no automatic propagation**: `q = x²+y²+z²`
has degree 2, so the `q`-orbit of the `r = 7` witness never reaches an even
`r`, and Lemma 2.4 needs `r ≤ 2m = 2` and is vacuous — the parity of `r` is a
genuine obstruction to transporting the primitive `m = 1` branch from odd to
even `r`, and emptiness at `r = 8` says nothing about `r = 10`. What *is*
uniform is the **structure**: the two sparse leading generators, hence the
four-strata decomposition, exist verbatim at every even `r ≥ 6`, so the same
solver applies. `r = 10` was launched on the same pipeline (leaf counts 54/120/56/122 per
block; 2 leaves certified by two char-0 engines, then stopped for CPU —
`logs/C2_R10_one.log`, `logs/PAR_R10.log`). A partial finding, not a verdict.

### 6b. `FIX-H1-HOLE-16-PARTIAL` — `(1,6)` above line degree 2

Line degrees `0,1,2` were already EMPTY in characteristic 0 (FIX-N2B §2.4).
This packet re-derived the line-degree bookkeeping independently — the
eigenblock indexing `T_j ∈ E_{λω^{−(n+j)}}` reproduces FIX-N2B's — and added
the reduction that makes the search finite: if `T_0 = 0` (resp. `T_n = 0`) then
`t` (resp. `s`) divides `T` and the family drops to line degree `n−1` without
changing `r` or the plane orders, so only `T_0 ≠ 0 ≠ T_n` need be treated; and
since `E_1`'s `r=6` cone is `{0}`, each `n` admits only one or two `λ`. The
endpoints then run over the **144 ordered pairs** of the 24 exact `r=6` cone
lines (12 in `E_ω`, 12 in `E_{ω²}`, rebuilt and re-checked here — Theorem
N2B-1 reproduced).

**Result — a FINDING, not a verdict.**

| line degree `n` | `λ` | pairs | outcome |
|---|---|---|---|
| 3 | `ω`, `ω²` | 144 + 144 | every plane-order-1 coordinate of every `T_j` **forced zero mod `p = 100057`** (103 s + 99 s) |
| 4 | `1` | 144 | same, **forced zero mod `p`** (944 s) |
| 5 | `1` | 144 | same, **forced zero mod `p`** (3433 s) |
| 6 | `ω`, `ω²` | 144 + 144 | run launched, **not returned at close** |
| ≥ 7 | — | — | untouched |

(`logs/TASK5_n{3,4,5,6}.log`; `n=6` is empty at close with its process still
live — re-running `holes_task5.py 6 om,om2` completes it. 8640 msolve runs in
all, **zero** `CAN-BE-NONZERO`.)

The decisive step is *unit-ideal-ness of a Rabinowitsch system mod p*, and
**mod-`p` emptiness does not lift** — a bad prime can destroy solutions. The
full-column-rank lifting principle FIX-N2B used at `n = 2` is unavailable here
because the decisive statement is not a rank statement: level 1 alone leaves a
3–5 dimensional kernel that **does** meet the plane-order-1 locus at every cone
point (FIX-N2B §2.3's refutation of the one-step ladder, reproduced), so the
nonlinear levels are genuinely needed.

*The upgrade path, precisely.* Replace the 144 pairs by **4 runs per `(n,λ)`**
— branch of `T_0` × branch of `T_n` — over `QQ` with `ω, κ₊, B_0, B_n` as
variables and their minimal polynomials (`B⁶−(κ₊+2)B³+1`) adjoined; each run is
then rigorous in characteristic 0 by the same Galois-transitivity argument used
for `(1,8)`. (Or Macaulay2 over `toField(QQ[om,kp,B]/(…))` per pair.) Both were
set up; neither was run to completion inside this packet's budget.

*Stabilisation in `n`: NOT proved.* The **shape** of the obstruction is
`n`-independent (the same two-sided ladder, `ker D_{T_0}` from below and
`ker D_{T_n}` from above, with the same cone-line endpoints), but the number of
free middle blocks grows linearly in `n`. `HOLES_REPORT.md` §5.4 records the
one structural fact a future uniform proof should start from — the leading
plane-adic relations hold verbatim for a *family* over the domain `k[s,t]`, and
every `r=6` cone line has `a' = −c(xyz)²`, `b' = 0` (or the mirror), forcing
four of the binary forms to be divisible by `st` — together with the reason the
naive descent to `k(s,t)` fails (the `C₃`-eigenvalue `μ_j` varies with `j`) and
the reason dropping `C₃`-equivariance cannot work (the full-space `r=6` cone
visibly has plane-order-1 points).

---

## 7. Consequence

**The two classified branches are dead at the equalizer, but the negative
endgame does not yet follow.** Precisely:

* Both surviving stalk branches of FIX-H0 fail the cross-V4 coupling at
  `c_σ` — `FIX-H1-EQ-M3-EMPTY` (the `D_B` branch, at **every** line degree)
  and `FIX-H1-EQ-M1-EMPTY` (the primitive Chebyshev branch, on the classified
  branch). By the localization theorem of `theory/FIX_H1_coupling.md` §3 an
  equalizer failure at finite order kills a branch **for every degree `d` at
  once**, so the no-degree-bound obstacle really is dissolved for these two.
* Of the two odd-row holes that FIX-H1 §5 says still gate a negative verdict,
  **neither is closed.** `(1,8)` at line degree 0 is 282/288 leaves
  characteristic-0 certified, with the sharp partial theorem that a
  plane-order-1 point would need *both* plane-order-1 coefficients nonzero;
  `(1,6)` above line degree 2 is a modular finding only.
* Three unclassified components therefore remain, and they are of one kind —
  *positive line degree*:
  1. `(1,6)` at line degrees `≥ 3` (findings at `n = 3, 4, 5`; char-0 upgrade
     specified in §6b);
  2. `(1, even r ≥ 8)`: at line degree 0, the 6 residual `r=8` leaves (the
     "both coefficients nonzero" charts); at positive line degree, everything;
     `r = 10` only started;
  3. the `(1, odd r ≥ 7)` cell at positive line degree — the scope gap of
     `FIX-H1-EQ-M1-EMPTY`. For this one the residual constraint is now
     **explicit and finite**: `Λ = diag(u,v)` must vanish to order `≥ 12` at
     each of the three D12-points of `ℓ_V` (so `d ≥ 43`), and then
     `u_{12} = v_{12}` and `u_{13} + v_{13} = 0`; from order 2 on there is no
     further condition.

**Therefore: NOT all classified and hole components are excluded, and the
negative headline does not follow from the FIX chain as it stands.** What
would close it is exactly items 1–3 above; item 2's line-degree-0 part is
6 Gröbner computations away.

**Problem E headline: OPEN.**

---

## 8. Deliverables and timings

| file | role | wall |
|---|---|---|
| `produce_h1_frame.py` | Part A — the exact σ-frame at `c_σ` | 2 s |
| `produce_h1_equalizer.py` | Part B — `V[sgn^e]`, the `D_B` quadric, the order pattern | 3 s |
| `produce_h1_branch1.py` | Part D — branch (i), every classified odd-`m` `D_B` member | 1 s |
| `produce_h1_branch2.py` | Part C — branch (ii), all three eigenblocks + Nullstellensatz certificates | 69 s |
| `verify_h1.py` | independent verifier — 43 checks, 0 failures | 3 s |
| `k0.py` | self-contained exact `QQ(ω,√−11)` engine (second engine) | — |
| `payloads/PAYLOAD_theorem.txt` | the derivation of Theorem H1-1 and both verdicts | |
| `payloads/PAYLOAD_frame.txt`, `PAYLOAD_equalizer.txt`, `PAYLOAD_branch1.txt`, `PAYLOAD_branch2.txt` | transcripts | |
| `payloads/h1_*.json` | machine-readable payloads | |
| `m2/branch2_equalizer.m2`, `logs/M2_BRANCH2.log` | the Macaulay2 confirmation | |
| `REPLAY.md` | replay instructions and markers | |

No git commits were made and nothing outside this packet was written. Sibling
packets were read-only.
