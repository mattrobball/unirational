# FIX-C5 — the branch quartic `Δ_v` of the χ₁-vertex projection

**Packet:** `goal_runs_after_9094303/FIX_C5_BRANCH_QUARTIC/`
**Program:** FIX ([E56]). **Named by:** `theory/FIX_IV_closure.md` §5.18
("Named remaining work for (T1a) … (ii) **(C5)** compute `Δ_v` and its
V4-structure explicitly in the frame") and §5.19 (the hand-derived closed form,
the γ-criterion). **Date:** 2026-08-06.
**σ-frame reused (not rebuilt):** `goal_runs_after_9094303/FIX_L1_FRAME_CONSTANTS`
(itself reusing `goal_runs_after_541e12f/FIX_H1_EQUALIZER`).

**Primary exit:**

```text
FIX-C5-GEOMETRY-OK
```

**Problem E headline: OPEN.**

The §5.19 hand derivation is **correct** and is verified here by three
independent bookkeepings. `Δ_v` is **irreducible** — over the frame field and
over `C` — so the parity analysis of §5.18-B stays **single-channel**. Its
singular locus is **exactly** the six contracted lines' images: six ordinary
nodes, all lying on the single plane `{Q₁ = 0}` that the γ-criterion already
reduces modulo. Two findings are recorded in §7 (one of them a sign correction
owed back to §5.19).

---

## 1. Conventions

Everything is stated in the FIX-L1 certified frame and in nothing else. `K = Q(ω,ν)`,
`ω²+ω+1 = 0`, `ν² = −11`, `δ := ω−ω² = 2ω+1` (`δ² = −3`), `√33 := −νδ`.
`K = Q(√−3, √−11)` is biquadratic over `Q`, hence **its own Galois closure**.

```
F = C(a,b) + Q₁(a,b)x² + Q₂(a,b)y² + Q₃(a,b)z² + c·xyz        on P⁴ = P(a,b,x,y,z)
C  = kp a³ + km b³      kp = (13+3√33)/16 ,  km = (13−3√33)/16
Q₁ = a+b ,  Q₂ = ωa+ω²b ,  Q₃ = ω²a+ωb ,   c = 1
```

> **Name-clash warning.** FIX-L1's STATUS uses `c` for the **Chebyshev**
> uniformiser `(3+√33)/4`. Note IV §5.19 uses `c` for the **xyz-coefficient**.
> This packet follows §5.19: **`c = 1`** here (FIX-L1's `β = 1`); the Chebyshev
> constant is written `c_cheb`.

V4 acts diagonally by the sign patterns `(ε₁,ε₂,ε₃)` with `ε₁ε₂ε₃ = 1`
(`σ₁ = (+,−,−)`, `σ₂ = (−,+,−)`, `σ₃ = (−,−,+)`); `a,b` are `χ₀`, `x` is `χ₁`,
`y` is `χ₂`, `z` is `χ₃`. The **χ₁-vertex** is `v = [0:0:1:0:0] = E_x`; it is
V4-fixed and lies on `X` (no `x³` monomial is V4-invariant; also checked
directly on the RAW Klein cubic `Σ xᵢ²x_{i+1}` via `klein_eval(E_x) = 0`).

---

## 2. Task 1 — the hand derivation of `Δ_v` is VERIFIED

`π_v : [a:b:x:y:z] ↦ [a:b:y:z]` simply **eliminates `x`**, and `F` is a
**quadratic in `x`**:

```
F  =  Q₁(a,b) x²  +  (c·yz) x  +  [ C + Q₂y² + Q₃z² ] .
```

So `π_v` is 2:1 (a general fibre is the two-element root set) and its branch
locus is the discriminant. Three independent bookkeepings agree:

| route | what it is | verdict |
|---|---|---|
| (i) | §5.19 **verbatim**: the binary cubic `ℓ s²t + q st² + k t³` obtained by restricting `F` to `{s·v + t·p}`, `p = (a,b,x′,y,z)` | `ℓ = Q₁`, `q = 2Q₁x′ + c·yz`, `k = C + Q₁x′² + Q₂y² + Q₃z² + c x′yz` — **all three confirmed**; `q²−4ℓk` is **free of `x′`** |
| (ii) | `F` as a quadratic in the eliminated slot `x`; discriminant | same `Δ_v` |
| (iii) | Sylvester resultant `Res_x(F, ∂F/∂x)` (3×3 determinant) | `= −Q₁·Δ_v` |

```
    Δ_v  =  c²y²z²  −  4·Q₁(a,b)·[ Q₂(a,b)y² + Q₃(a,b)z² + C(a,b) ]
```

and, in the certified frame (`c = 1`), expanded:

```
    Δ_v = y²z² − 4[ kp a⁴ + kp a³b + km ab³ + km b⁴
                    + (ω a² − ab + ω² b²) y²
                    + (ω² a² − ab + ω b²) z² ] .
```

* **`x′`-cancellation: CONFIRMED**, generically in `(kp, km, c, ω)` — not only
  in the specialised frame.
* **`Δ_v ≡ (c y z)² mod Q₁`: CONFIRMED.** Consequently
  `Δ_v|_{Q₁=0} = 2·{y=0} + 2·{z=0}`: the plane `{Q₁ = 0}` is tangent to `Δ_v`
  along **both** lines.
* `Δ_v` is **V4-invariant** (character `χ₀`: every monomial is even in `y` and
  even in `z`), checked on all four group elements.

---

## 3. Task 2 — IRREDUCIBILITY: `Δ_v` does **not** factor

> **VERDICT.** `Δ_v` is **irreducible over the frame field `K`** and **remains
> irreducible over `K̄ = C`** (absolutely irreducible), and it is **reduced**.
> `K` is its own Galois closure, so there is no larger "Galois-closure field"
> over which a factorisation could appear.

Three routes:

1. **Lemma C5-I (proof, the primary route).** *A nonzero form `G` of degree
   `≥ 2` on `Pⁿ`, `n ≥ 3`, with `dim Sing V(G) = 0`, is reduced and absolutely
   irreducible.* Proof: a repeated factor puts a whole hypersurface into
   `Sing`; two distinct factors put their intersection — of dimension
   `≥ n−2 ≥ 1` in `Pⁿ` — into `Sing`. Either way `dim Sing ≥ 1`. ∎
   §4 below establishes `dim Sing(Δ_v) = 0` by an exact case analysis (no
   Gröbner basis), so Lemma C5-I applies.
2. **OSCAR/Hecke** `factor` over `K = Q(u)`, `u⁴+28u²+64 = 0`: **one** factor,
   multiplicity 1. Controls: a deliberately reducible quartic returns 2
   factors, a square returns multiplicity 2.
3. **sympy** `factor_list` over `Q(√33, √−3) = K`: **one** factor of degree 4,
   multiplicity 1, recomposing exactly.

**Why this matters (the brief's "finding of first importance" check).** A
factored branch quartic would have turned §5.18-B's evenness condition
`h*(Δ_v) ∈ 2·Div` into a **vector** of parities, one per component, and would
have made the sheet datum reducible. It does not factor: the parity condition
stays a **single** channel.

**Galois structure (machine-checked).** `Gal(K/Q) = (Z/2)²` acts on `Δ_v`
through the Klein four-group of **coordinate swaps** `⟨(a b), (y z)⟩ ⊂ PGL₄`:

| element | action on constants | action on `Δ_v` |
|---|---|---|
| `σ_ω : ω↦ω², ν↦ν` | `√33 ↦ −√33`, `kp ↔ km`, `Q₂ ↔ Q₃` | `a ↔ b` |
| `σ_ν : ν↦−ν` | `√33 ↦ −√33`, `kp ↔ km` | `a ↔ b , y ↔ z` |
| `σ_ω σ_ν` | `√33` fixed, `Q₂ ↔ Q₃` | `y ↔ z` |

This group **commutes with** the V4-sign action but is **not contained** in it.

---

## 4. Task 3 — the SINGULAR LOCUS, exactly

> **Theorem C5-S.** `Sing(Δ_v)` is **zero-dimensional of degree 6, reduced**,
> and consists of **six ordinary nodes (`A₁`)**. All six lie on the plane
> `{Q₁ = a+b = 0}`.

### The table

| node | point `[a:b:y:z]` | field of definition | on | V4-stabiliser | `det Hess` |
|---|---|---|---|---|---|
| `P_y` | `[0:0:1:0]` | `K` | `{Q₁=0, z=0}` | **V4** (isolated fixed point) | `96` |
| `P_z` | `[0:0:0:1]` | `K` | `{Q₁=0, y=0}` | **V4** (isolated fixed point) | `96` |
| `N_y±` | `[1:−1:±r₀:0]` | `K(r₀)`, `8r₀² = 3ν` | `{Q₁=0, z=0}` | `⟨σ₂⟩` | `−594` |
| `N_z±` | `[1:−1:0:±i r₀]` | `K(i r₀)` | `{Q₁=0, y=0}` | `⟨σ₃⟩` | `−594` |

`64 r₀⁴ + 99 = 0` (degree 8 over `Q`). **`3ν/8` and `−3ν/8` are NONSQUARES in
`K`** — proved from scratch in the verifier via the tower
`K = Q(ν)(δ)` (controls: `4`, `−3`, `−11` *are* squares in `K`, `2` is not) —
so each `N`-pair is a single `K`-prime component.

`K`-decomposition of `Sing`: **`1 + 1 + 2 + 2 = 6`** (two `K`-rational points
plus two conjugate pairs). All four components are prime and the ideal is
radical.

### How it was established — four routes

* **Exact case analysis (no Gröbner).** Euler gives `Sing = V(∂_a,∂_b,∂_y,∂_z)`.
  `∂_y = 2y(c²z² − 4Q₁Q₂)`, `∂_z = 2z(c²y² − 4Q₁Q₃)`.
  * **Case I, `Q₁ = 0`:** the system collapses to `{yz = 0, k = 0}`, which
    **is** the line-incidence system of §5 — six points.
  * **Case II, `Q₁ ≠ 0`:** four subcases, all empty.
    `(a) y=z=0` → Euler forces `C = 0`, then `a = b = 0`.
    `(b) y=0, z≠0` → `Q₃ = 0`, `b = −ωa`, `C = (kp−km)a³`, `Δ_v = −4Q₁C` → `a = 0`.
    `(c) z=0, y≠0` → symmetric.
    `(d) y,z ≠ 0` → substituting `c²y² = 4Q₁Q₃`, `c²z² = 4Q₁Q₂` and `Δ_v = 0`
    makes the two remaining equations **collapse** to
    ```
        ∂_a = −4 Q₁ (12 + 3kp) a² ,      ∂_b = −4 Q₁ (12 + 3km) b² ,
    ```
    and `(4+kp)(4+km) = 22 ≠ 0`, so `a = b = 0` — contradiction.
    *(This collapse is the whole content of "six nodes and nothing more".)*
* **Macaulay2** over `toField(QQ[om,s]/(om²+om+1, s²−33))`: `dim = 0`,
  `degree = 6`, `Q₁ ∈ Js`, `intersect(P_y,P_z,N_y,N_z) == Js`.
* **OSCAR** over `Q(u)`: `dim = 0`, `degree = 6`, `Js` **radical**,
  `primary_decomposition` = 4 components of degrees `2,1,2,1`, each primary
  equal to its prime.
* **Independent verifier** (own exact `K`-arithmetic, no sympy, no Gröbner):
  the same case analysis re-derived, plus the vanishing of `Δ_v` and all four
  partials at each node and the `3×3` Hessian determinant at each node.

**Node type.** `det Hess ≠ 0` in the affine chart at every one of the six
points ⇒ every singularity is an **ordinary double point**. `Δ_v` is therefore
a **6-nodal quartic surface** — a nodal K3 — and `Bl_v X → P³` is the small
resolution of the double solid `w² = Δ_v`.

### Geometric identification of the components

* `Δ_v ∩ {Q₁=0} = 2·{y=0} + 2·{z=0}` (the perfect square `(cyz)²`); the six
  nodes are `3 + 3` on those two lines.
* `Δ_v|_{y=0} = −4 Q₁ (Q₃ z² + C)` — a **line plus a plane cubic**;
  `Δ_v|_{z=0} = −4 Q₁ (Q₂ y² + C)` likewise.
* `Δ_v|_{y=z=0} = −4 Q₁ C` — **four points** on the V4-fixed line
  `ℓ₀ = P(⟨a,b⟩) = π_v(P(W⁺))`. These are exactly the branch points of
  `E_{σ₁} = X ∩ P(W⁺) → ℓ₀ ≅ P¹` (Riemann–Hurwitz `2g−2 = 2(−2)+4 = 0`,
  `g = 1`) — the §5.9(b) "χ-vertex lies on the fixed elliptic" picture seen from
  the projection side. **None of these four is singular on `Δ_v`.**

---

## 5. Task 4 — the CONTRACTED-LINE CENSUS

A line through `v` is `span(v, w)`, `w = (a,b,0,y,z)`; the binary cubic of §2
shows `span(v,w) ⊂ X` iff `[a:b:y:z]` solves the **incidence system**

```
   (L1) Q₁(a,b) = a + b            = 0
   (L2) c · y z                    = 0
   (L3) C(a,b) + Q₂ y² + Q₃ z²     = 0            ( = { ℓ = q = k = 0 } )
```

Solving exactly: `b = −a` makes `Q₂ = δa`, `Q₃ = −δa`, `C = (kp−km)a³`, and
(L3) factors as `a·[(kp−km)a² ∓ δ·(z² or −y²)]` on each branch of (L2).

> **EXACTLY SIX LINES**, all distinct and reduced (Bézout `1·2·3 = 6`; M2 and
> OSCAR both return `dim 0, degree 6` for the incidence ideal). Six is the
> classical count of lines through a *general* point of a smooth cubic
> threefold, so `v` — though V4-fixed — is generic for this purpose.

| line | spanned by `v` and | image in `P³` | V4-orbit | stabiliser | one of the 55? |
|---|---|---|---|---|---|
| `L₂` | `E_y` | `[0:0:1:0]` | `{L₂}` | `V4` | **YES** `= ℓ_{σ₃}` |
| `L₃` | `E_z` | `[0:0:0:1]` | `{L₃}` | `V4` | **YES** `= ℓ_{σ₂}` |
| `M_y±` | `(1,−1,0,±r₀,0)` | `[1:−1:±r₀:0]` | `{M_y+, M_y−}` | `⟨σ₂⟩` | **NO** |
| `M_z±` | `(1,−1,0,0,±i r₀)` | `[1:−1:0:±i r₀]` | `{M_z+, M_z−}` | `⟨σ₃⟩` | **NO** |

`F` vanishes **identically** on each of the six lines (checked as a polynomial
identity in the line parameters, over `K` and over `K(r₀)`). The V4-orbit table
was computed by the machine from the group action, not asserted.

### 55-membership, decided

The 55 arrangement lines are the `(−1)`-eigenlines `ℓ_t = P(ker(t+1))` of the
55 involutions `t ∈ PSL(2,11)`. A line through `v` is one of them iff
`t·E_x = −E_x`. Enumerating all 55 involutions in the rebuilt Weil
representation:

* exactly **two** involutions negate `E_x` (indices `385`, `454`), **both in the
  frame V4**, and their second negated frame vector is `E_z` resp. `E_y`, so
  `ℓ_{385} = ⟨E_x,E_z⟩ = L₃` and `ℓ_{454} = ⟨E_x,E_y⟩ = L₂`. §5.18-B's "`L₂, L₃`
  are already known members" is **VERIFIED**, by identification and not merely
  by a count.
* **Cross-check:** the full projective stabiliser `Stab_{PSL(2,11)}(v)` is
  computed to be **exactly the frame V4** (order 4, elements `{0,1,385,454}`).
  Since an arrangement line through `v` forces its involution into `Stab(v)`,
  the count 2 is forced by this alone.
* Hence the other **four** lines are **NOT** arrangement lines. They are
  genuinely new lines of `X`, defined over quadratic extensions `K(r₀)`,
  `K(i r₀)` of the frame field (degree 8 over `Q`), whereas `L₂, L₃` are
  `K`-rational.

---

## 6. Task 5 — the V4-action, and what the incidence buys

### Characters and fixed structure

`W/⟨v⟩ = ⟨a,b⟩⊗χ₀ ⊕ ⟨y⟩⊗χ₂ ⊕ ⟨z⟩⊗χ₃`, so on `P³` the coordinate characters are
`a,b : χ₀`, `y : χ₂`, `z : χ₃`, and `V4 → PGL₄` is **faithful**
(`σ₁ = diag(1,1,−1,−1)`, `σ₂ = diag(1,1,1,−1)`, `σ₃ = diag(1,1,−1,1)`).
`Δ_v` has character `χ₀`.

`Fix(V4) ⊂ P³` = the line `ℓ₀ = {y=z=0}` (pointwise fixed) **plus** the two
isolated points `[0:0:1:0]`, `[0:0:0:1]`. **The two isolated fixed points are
exactly two of the six nodes** (`P_y`, `P_z` = the images of `L₂, L₃`), and the
fixed line meets `Δ_v` in four *smooth* points.

### *** THE HEADLINE INCIDENCE ***

```
        π_v( contracted lines )   =   Sing(Δ_v)
```

as **schemes** (M2 and OSCAR both verify the two saturated ideals are **equal**,
not merely that the sets agree), bijectively `6 ↔ 6`, V4-equivariantly, with
matching orbit types `1 + 1 + 2 + 2`. There is **no node off the contracted
locus** and **no contracted line whose image is a smooth point**.

**What this buys for §5.18-B(i) (the equivariant lifting criterion over the
contracted locus):**

1. The bookkeeping is closed: the contracted locus contributes exactly the six
   nodes and nothing else, so the criterion has no "extra" branch singularity
   to account for.
2. **All six nodes lie on the single plane `{Q₁ = 0}`** — precisely the plane
   the γ-criterion already works modulo (`Δ_v ≡ (cyz)² mod Q₁`). The entire
   contracted-locus correction is therefore concentrated on the γ-criterion's
   own modulus.
3. `Δ_v` irreducible ⇒ the parity condition `h*(Δ_v) ∈ 2·Div` is **one**
   condition, not a component-wise vector.
4. Only `2` of the `6` contracted lines are arrangement lines. By (P2) those
   two are base components of every equivariant map; the other four carry no
   such automatic vanishing, so the criterion must treat the two orbit types
   `{L₂},{L₃}` and `{M_y±},{M_z±}` **separately**.
5. *(Structural remark, classical, not machine-checked here.)* `Bl_v X → P³` is
   a **projective small resolution** of the 6-nodal double solid `w² = Δ_v`;
   `rk Pic(Bl_v X) = 2` while the double solid has rank 1, so the double solid
   is non-factorial with defect 1. That non-factoriality is the geometric home
   of §5.19(b)'s 2-torsion "sheet datum".

### The quotient `Δ_v / V4` (illuminating)

Invariants are `a, b, Y = y², Z = z²`, so `P³/V4 = P(1,1,2,2)` and

```
   Δ̄ :  Y Z = 4 Q₁ ( Q₂ Y + Q₃ Z + C )
      ⟺ (Y − 4Q₁Q₃)(Z − 4Q₁Q₂) = 4 Q₁ [ (4+kp) a³ + (4+km) b³ ] ,
```

using `Q₁Q₂Q₃ = a³+b³`. Solving for `Z` exhibits `Δ̄` as the **graph of a
rational function of `(a,b,Y)`**: `Δ_v/V4` is a **rational** surface, fibred
over `P¹_{[a:b]}` in rational curves, degenerating over exactly four points
(`Q₁ = 0` and the cubic `(4+kp)a³+(4+km)b³ = 0`, honest because
`(4+kp)(4+km) = 22 ≠ 0`). `Δ_v` itself is the `(Z/2)²`-cover of this rational
surface branched over `{y=0} ∪ {z=0}`, and the six nodes all sit over `Q₁ = 0`.

*(The three χ-vertices are permuted by the residual `C₃ = A₄/V4`, so the branch
quartics at the other two are projectively equivalent to this one; only the
χ₁-vertex was computed.)*

---

## 7. Task 6 (secondary) — the γ-criterion SMOKE TEST, and two findings

Run against the **sealed** FIX-N2C witness (`goal_runs_after_a90dbe1/
FIX_N2C_R7_DECISION`, the `λ = 1`, `(m,r) = (1,7)` Chebyshev point, read-only;
its own 52-equation check was re-run in place and passes).

* **Parity shapes confirmed.** `a' = xyz·Ã`, `b' = xyz·B̃`, `u₀' = x·γ̃`,
  `u₁' = y·Ỹ`, `u₂' = z·Z̃` with `Ã,B̃,γ̃,Ỹ,Z̃ ∈ K[t,v,w]`, `(t,v,w) = (x²,y²,z²)`,
  of degrees `(2,2,3,3,3)` — exactly §5.19's `(s−1,s−1,s,s,s)` with `s = 3`.

> **FINDING C5-1 (a sign correction owed back to §5.19).** §5.19 says the
> invariant identity "is `F(T) ≡ 0` verbatim under `u₀′ = xγ̃`". Machine
> verdict on the witness:
> * with `γ̃ := +u₀′/x` and the printed `− c·γ̃ỸZ̃` term: **NONZERO** (52 monomials);
> * with `γ̃ := −u₀′/x` and the printed `− c·γ̃ỸZ̃`: **ZERO**;
> * with `γ̃ := +u₀′/x` and `+ c·γ̃ỸZ̃`: **ZERO**.
>
> The criterion's own derivation confirms the machine: writing the square root
> as `g = cYZ − 2Q₁γ` gives `u₀′ = (−cYZ + g)/(2Q₁) = −γ`. So the dictionary is
> **`γ = −u₀′`**, i.e. §5.19's sentence should read "under `u₀′ = −xγ̃`".
> **The criterion itself is unaffected** (`γ` ranges over all `χ₁`-forms and
> `γ ↦ −γ` is a bijection of that space); only the dictionary carries the sign.
> Anyone consuming §5.19 to *build* a `u₀′` from a `γ` must use the minus.

> **FINDING C5-2 (the "collapse" of §5.19(a), measured).** For this cell the
> raw FIX-N2C slot system has **52** equations; the invariant identity has
> degree `3s = 9` in `(t,v,w)`, i.e. at most `C(11,2) = 55` coefficients, of
> which exactly **52 are occupied**. The two counts are **equal**: the
> "collapse to one identity" is a faithful **reindexing** of the same
> conditions, not a reduction in their number. The genuine gain is in the
> *variables* (3 invariant variables instead of 5 slot tuples in `(x,y,z)`) and
> in the *degree* (`3s` instead of `3r`). This is exactly what §5.19's "honest
> scope" paragraph asserts qualitatively — it is now measured.

---

## 8. Honest scope — what is NOT claimed

* The **equivariant lifting/divisibility criterion over the contracted locus**
  (§5.18-B named work (i)) is **not derived here**. This packet supplies its
  geometric input only.
* (T1a) is not closed; **Problem E headline: OPEN.**
* Only the **χ₁-vertex** was computed. The other two χ-vertices are `ρ`-conjugate
  (residual `C₃ = A₄/V4`); that they are projectively equivalent is stated, not
  separately recomputed.
* The **55-membership** verdict rests on the rebuilt `PSL(2,11)` Weil
  representation of `klein_exact.py` (one toolchain: python). It is
  cross-checked *internally* two ways (explicit eigenline identification, and
  the full projective stabiliser of `v`), but not by a second CAS.
* The **defect-1 / small-resolution** remark in §6.5 is classical bookkeeping
  recorded for the parity route, not a machine result of this packet.
* No `git` operations were performed; nothing was written outside this packet.

---

## 9. Cross-checks actually run

| claim | route 1 | route 2 | route 3 | verdict |
|---|---|---|---|---|
| §5.19 `(ℓ,q,k)` and the `x′`-cancellation | §5.19 binary-cubic route (sympy, generic `kp,km,c,ω`) | `F` as a quadratic in `x` | Sylvester `Res_x(F,∂F/∂x) = −Q₁Δ_v` (verifier, own arithmetic) | **VERIFIED** |
| `Δ_v ≡ (cyz)² mod Q₁` | producer | verifier | M2 (`(Δ_v − y²z²) % (Q₁) == 0`) | **VERIFIED** |
| `Δ_v` irreducible over `K` | OSCAR `factor` (+ 2 controls) | sympy `factor_list` | Lemma C5-I from `dim Sing = 0` | **IRREDUCIBLE** |
| `Δ_v` absolutely irreducible | Lemma C5-I | — | — | **YES** |
| `dim Sing = 0`, `deg = 6` | M2 (+ 3 controls: reducible ⇒ 1, square ⇒ 2, smooth ⇒ unit) | OSCAR (+ radical + primary decomposition) | exact 8-case analysis, twice (producer, verifier) | **CONFIRMED** |
| `Sing` radical / components `1+1+2+2` | OSCAR `primary_decomposition` | M2 `intersect(P_y,P_z,N_y,N_z) == Js` | verifier's nonsquare proof for `±3ν/8` (+ 4 controls) | **CONFIRMED** |
| six nodes are `A₁` | producer Hessian `det ∈ {96, −594}` | verifier Hessian, own arithmetic | — | **CONFIRMED** |
| 6 lines through `v` | exact solve (producer) | exact solve (verifier, `K(ρ)` arithmetic) | M2 + OSCAR: incidence ideal `dim 0, deg 6` | **EXACTLY 6** |
| contracted locus `=` `Sing(Δ_v)` | M2 ideal equality | OSCAR ideal equality | point-by-point (producer, verifier) | **EQUAL AS SCHEMES** |
| V4-orbits of the 6 lines | machine orbit computation | hand table | — | `1+1+2+2` |
| exactly 2 arrangement lines through `v` | enumeration of all 55 involutions | explicit eigenline identification | `Stab_{PSL(2,11)}(v) = V4` | **2** |
| Galois action `= ⟨(a b),(y z)⟩` | producer | verifier | — | **CONFIRMED** |
| quotient `Δ̄`, hyperbola form, `(4+kp)(4+km)=22` | producer | verifier | OSCAR | **CONFIRMED** |
| γ-criterion identity | smoke test on the sealed FIX-N2C witness | FIX-N2C's own 52-equation check re-run in place | — | **OK, with FINDING C5-1** |

Exact characteristic-zero arithmetic only; no floating point enters any
decision (the 40-digit `mpmath` block in the verifier is a printed sanity
layer). Check counts: producer **139**, verifier **180**, smoke test **61**.

---

## 10. Files

```
produce_c5.py               producer (sympy over Q(om,nu); imports klein_exact +
                            FIX-L1's build_frame ONLY for the 55-line question)
verify_c5.py                INDEPENDENT verifier: own exact K = Q(om,nu), own
                            quadratic extensions, own polynomial arithmetic;
                            no sympy, no group theory; self-tests + 180 checks
smoke_gamma.py              the sec.5.19 gamma-criterion smoke test on the
                            sealed FIX-N2C lam = 1 witness (read-only)
m2/c5_sing.m2               Macaulay2 route (dim/degree/components + 4 controls)
oscar/c5_oscar.jl           OSCAR route (factor + primary decomposition + controls)
payloads/PAYLOAD_GEOMETRY.txt   THE COMPACT SHEET: closed forms + both tables
payloads/PAYLOAD_C5.txt         full producer log (parts A-F)
payloads/PAYLOAD_VERIFY.txt     full verifier log
payloads/PAYLOAD_SMOKE.txt      full smoke-test log
payloads/PAYLOAD_M2.txt         Macaulay2 transcript
payloads/PAYLOAD_OSCAR.txt      OSCAR transcript
payloads/c5_data.json           machine-readable: closed forms, node table,
                                line census, orbits, verdicts
logs/                           local mirrors (*.log is gitignored repo-wide)
REPLAY.md
```
