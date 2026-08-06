# Status — FIX-U1-FIN7: the named computation FIN(7)

**Primary exit:** `FIX-U1-FIN7-NOT-FINITE-MOD-TORUS-DIM-GE-15`

**Problem E headline: OPEN.**

Answered in the **corrected** form of Note IV §5.9(d): not "is `PO₁(7)` finite"
(it trivially is not — the diagonal torus), but **"is `PO₁(7)` a finite union of
torus orbits?"** The answer is **no**, and the mod-torus dimension is `≥ 15`.

*Name map for the ledger:* in the original brief's naming this verdict is
`FIN7-INFINITE-DIM-17` (`dim PO₁(7) ≥ 17`, three components of dimension
exactly 17, no certified upper bound); in the corrected naming it is
`FIN7-NOT-FINITE-MOD-TORUS-DIM-GE-15`. Both refer to the same computation.

Producer terminal line `FIX_U1_FIN7_PRODUCE_OK` (0 failed checks, 3839 s);
verifier terminal line `FIX_U1_FIN7_VERIFY_OK` (104 checks, 0 failed, 215 s).

| scoped exit | content |
|---|---|
| `FIX-U1-FIN7-NOT-FINITE-MOD-TORUS` | **theorem, exact char 0** — `PO₁(7)` contains **three explicit projective linear components of dimension exactly 17**, i.e. **15 modulo the 2-torus**. They are `{a′ = b′ = u_i′ = 0}`, `i = 0,1,2` — precisely the maps whose whole image lies in one of the three target lines `L_σ ⊂ X` of Theorem 5.9(a). So the corrected Prop 5.3 hypothesis **fails on `PO₁(7)`** and can only be asked on a non-degenerate stratum. |
| `FIX-U1-FIN7-ESSENTIAL-TANGENT-2` | **theorem, exact char 0** — on the non-degenerate stratum, at all 27 classified Chebyshev points, the **tangent space** of `PO₁(7)` modulo the trivial directions (torus 2; the scalar is already projectivised away) has dimension **exactly 2** at the 24 points of Galois parts B, C, D, and **5** at the 3 part-A points — where the quadratic Kuranishi obstruction cuts the tangent **cone** down to a 5-dimensional linear space, i.e. essential `≤ 2` there too. Two engines. The essential *tangent* dimension is therefore `2` everywhere; the essential *local* dimension is certified only as `∈ [0,2]` (see the next row). |
| `FIX-U1-FIN7-UNOBSTRUCTED-BCD` | **modular evidence (Schwartz–Zippel, one split prime)** — at the 24 B/C/D points the level-0 Kuranishi map vanishes identically on the whole 5-dimensional kernel through order 10 (`Ob₂ ≡ Ob₃ ≡ 0` exactly/symbolically; 8 random rays per point lift to order 10; one ray lifts to order 26). The germ is therefore smooth of essential dimension exactly 2, so those points are **not rigid modulo the torus** either. Certified statement: essential local dimension `∈ [0,2]`; evidenced value `2`. |
| `FIX-U1-FIN7-TANGENT-EXACT` | **theorem** — exact tangent dimensions of `PO₁(7)` at all 27 classified points: **4** at the 24 points of Galois parts B, C, D (= 2 reparametrisation + 2 essential) and **7** at the 3 part-A `K`-rational points (= 2 reparametrisation + 5 essential). Two engines (own exact number-field linear algebra; Macaulay2 `toField`), plus three-prime modular lower bounds. |
| `FIX-U1-FIN7-EQUIVARIANT-SINGULAR-AT-A` | **new, refines FIX-N2C** — in the point's *own* `Θ`-eigenblock the corank is 1 at parts B/C/D (FIX-N2C's nine-point scheme is reduced there) but **2 at part A**: the equivariant `(1,7)` landing scheme is **singular** at the `K`-rational Chebyshev point. FIX-N2C's "reduced, degree 9" was computed after substituting nine linear relations, i.e. on a linear slice, and does not see this. It is the same point at which FIX-C1 found its kernel jump and its nonzero `Ob₂`. |
| `FIX-U1-FIN7-U0V0-NONVANISHING` | **theorem** — `u₀ + v₀ = Λ_yy + Λ_zz ≠ 0` at **all 27** classified points (exact, Nullstellensatz inverses exhibited in every residue field). The parameter exception in Prop 5.3 is **empty**; only the finiteness hypothesis fails. `u₀ − v₀ ≠ 0` is recomputed independently here, reconfirming `FIX-H1-EQ-M1-EMPTY`. |
| `FIX-U1-FIN7-GLOBAL-MAX-PARTIAL` | **not decided** — no upper bound on `dim PO₁(7)` was certified, so `≥ 17` (`≥ 15` mod torus) is a lower bound only. The linear-slice route (a single explicit codimension-`k` subspace missing the cone would give `dim ≤ k−1`; and since the slice is defined over `O_K` and `Proj` is proper over `Spec O_K`, one modular emptiness certificate would suffice) did not terminate: msolve stalls on 52 dense cubics in 20 variables, Macaulay2 stalls on the ungraded `gb` in 39 and in 17–21 variables, and the one sparse codim-18 slice that did finish **meets** the cone (it is not transverse, so it gives no bound). Timeout, not a verdict. `xyz_form.py` hands the follow-up a better formulation (§1.2). |

---

## 0. The verdict in one line

`PO₁(7)` is **not a finite union of torus orbits**: it is at least
15-dimensional modulo the torus, and even at the 27 classified Chebyshev
points — where the leading datum is forced to sit at the `C3`-fixed points of
`ℓ_V` — the germ has **2 essential directions** transverse to the torus orbit
(exact tangent; unobstructed through order 10 modularly at 24 of the 27).
**Proposition 5.3 does not fire, in either its original or its corrected
form**, so `[U1]` for the `(1, 7)` row is not closed by the constancy criterion
and needs the `D_B`-style shape-pinning route on the reachable-jet description.
The `u₀ + v₀` parameter check that Prop 5.3 also needs comes back **clean** (no
exceptional classified point), so that half of the proposition is banked for
whatever replaces the finiteness hypothesis.

### 0.1 The mod-torus accounting the director asked for

| locus | dim | − torus (2) + scalar (already projectivised) | **essential** |
|---|---|---|---|
| the three linear components `{a′=b′=u_i′=0}` (image inside a target line `L_σ`) | **17** | −2 | **15** |
| germ at the 24 classified points of parts B, C, D | `[2, 4]`, tangent `4` | −2 | tangent **2**, local `[0,2]`, evidenced **2** |
| germ at the 3 classified points of part A (`K`-rational) | `[2, 4]`, tangent `7`, tangent **cone** `≤ 4` | −2 | tangent `5`, tangent cone **≤ 2**, local `[0,2]` |

(`dim` and `tangent` are projective. The torus orbit through every classified
point is exactly 2-dimensional and lies in `PO₁(7)`; the global scalar is the
projectivisation and is already quotiented. There are **no other** trivial
directions: the only continuous symmetries are the global scalar and the
degree-1 `V4`-equivariant vector fields `V = (αx, βy, γz)`, i.e. the torus;
verified separately, the five slot-rescaling directions meet `ker J_p` in the
scalar alone at all 27 points.)

---

## 1. The object, exactly as Prop 5.3 names it

Ground field `K = QQ(om, kp)`, `om²+om+1 = 0`, `8kp²−13kp−4 = 0`
(`kp = κ₊`, `km = 13/8 − kp = κ₋`); Klein normal form (1.1)

```
F(a,b,u0,u1,u2) = kp a³ + km b³ + a(u0²+om u1²+om² u2²)
                              + b(u0²+om² u1²+om u2²) + u0u1u2 .
```

`x, y, z` are the normal coordinates of the `V4`-characters `B, C, D`; the
three plus-planes have ideals `(y,z), (x,z), (x,y)`, so for a monomial
`x^A y^B z^C` of degree `r`,
`ord_{P₁} = r − A`, `ord_{P₂} = r − B`, `ord_{P₃} = r − C`.

A pointwise cone element of order `r = 7` with all plane orders `≥ m = 1` is a
tuple `T = (a′,b′,u₀′,u₁′,u₂′)` of degree-7 forms, one `V4`-parity pattern per
slot, supported on monomials with `max(A,B,C) ≤ 6`, with `F(T) = 0`
identically. **No residual-`C3` relation is imposed.**

| slot | parity of `(A,B,C)` | #monomials | parameters |
|---|---|---|---|
| `a′` | (1,1,1) | 6 | `p0..p5` |
| `b′` | (1,1,1) | 6 | `q0..q5` |
| `u₀′` | (1,0,0) | 9 | `s0..s8` |
| `u₁′` | (0,1,0) | 9 | `t0..t8` |
| `u₂′` | (0,0,1) | 9 | `w0..w8` |

**39 parameters, 52 equations** (the coefficients of `F(T)`, which is
supported on the all-odd degree-21 monomials with `max ≤ 17 = 21 − 3m`;
`55 − 3 = 52`). Built two independent ways inside `fin7_lib.py` and a third
way in the verifier, agreeing coefficient by coefficient; and **restricted to
each of the three residual-`C3` eigenblocks it reproduces FIX-N2C's
`indep_r7` system exactly, 52 = 52, zero mismatches, in all three blocks.**

`PO₁(7)` is the projectivisation intersected with the three open conditions

```
ord_{P₁} = 1  ⟺  t0 = [x⁶y]u₁′ ≠ 0  or  w0 = [x⁶z]u₂′ ≠ 0
ord_{P₂} = 1  ⟺  s5 = [xy⁶]u₀′ ≠ 0  or  w6 = [y⁶z]u₂′ ≠ 0
ord_{P₃} = 1  ⟺  s8 = [xz⁶]u₀′ ≠ 0  or  t8 = [yz⁶]u₁′ ≠ 0
```

(`t0` and `w0` are exactly FIX-H1's `Λ_yy` and `Λ_zz`.)

### 1.1 A compact reformulation (used throughout, worth banking)

Writing `X = x², Y = y², Z = z²` and factoring out the forced monomials,

```
a′ = xyz·A ,  b′ = xyz·B ,  u₀′ = x·U₀ ,  u₁′ = y·U₁ ,  u₂′ = z·U₂
```

with `A, B` binary-free quadratics in `(X,Y,Z)` and `U₀, U₁, U₂` cubics in
`(X,Y,Z)` with **no `X³` / `Y³` / `Z³` term** respectively. Setting
`r₀ = A+B`, `r₁ = ωA+ω²B`, `r₂ = ω²A+ωB` (so `r₀+r₁+r₂ = 0`) and
`c = κ₊A³+κ₋B³`, the landing identity becomes the single degree-9 identity

```
   U₀U₁U₂ + r₀ X U₀² + r₁ Y U₁² + r₂ Z U₂² + c XYZ  =  0 ,          (★)
```

which is the degree-3 identity (2.4) of
`V4_SIMULTANEOUS_ODD_NORMALS_20260802/THEOREM.md` with the linear forms
promoted to cubics. The plane-order conditions read
`[X³]U₁ ≠ 0` or `[X³]U₂ ≠ 0`, etc. The reparametrisation torus is the
diagonal torus acting on `(X,Y,Z)`. `F(T) = xyz·G` is verified as an exact
identity in all 39 parameters (`xyz_form.py`).

### 1.2 Completing the square (banked for the global question)

`(A,B) ≠ (0,0)` forces some `r_i ≠ 0` (the map `(A,B) ↦ (r₀,r₁,r₂)` is
injective); after a `C3`-rotation take `r₀ ≠ 0`. Then, verified exactly in all
39 parameters (`xyz_form.py`),

```
   4 r₀ X · G  =  (2 r₀ X U₀ + U₁U₂)²
                  − [ U₁²U₂² − 4 r₀ X ( r₁ Y U₁² + r₂ Z U₂² + c XYZ ) ] .
```

So a cone point with `r₀ ≠ 0` is exactly: a choice of `(A,B,U₁,U₂)` (30
unknowns) making the explicit degree-14 form
`U₁²U₂² − 4r₀X(r₁YU₁² + r₂ZU₂² + cXYZ)` a **perfect square** `W²`, together
with `U₀ = (W − U₁U₂)/(2r₀X)` — at most two `U₀` per `W`, subject to
divisibility and `[X³]U₀ = 0`. This is the right formulation for a future
attempt at the global dimension: it removes 9 unknowns and replaces 52 cubics
by one "is a square" condition (codimension `120 − 36 = 84` for a generic
degree-14 ternary form).

---

## 2. The reparametrisation torus: the trivial directions

`(s,t,w)·T := T(sx, ty, wz)` preserves the slot parities, the degree, the
**monomial support** (hence every plane order exactly) and the landing
identity (`F(T)(sx,ty,wz) = F(T∘diag) = 0`). So `(C*)³` acts on `PO₁(7)`, and
each orbit is contained in it. Its infinitesimal generators are the weight
vectors `E_x, E_y, E_z` (with `E_x+E_y+E_z = 7·id`, the global scalar).

**Exact result (all 27 classified points, `produce_fin7.py` §3):**
`rank{E_x·p, E_y·p, E_z·p} = 3` (affine) and all three lie in `ker J_p`.
Hence through every classified point `PO₁(7)` contains a **2-dimensional
projective rational (toric) subvariety**. In particular

> `dim PO₁(7) ≥ 2`. This is the trivial infinitude of Note IV §5.9(d):
> `FIN(7)` in its original phrasing is vacuously "infinite", which is why the
> question is asked modulo the torus below.

Explicitly, `τ ↦ (1, τ, 1)·p` is a non-constant rational curve inside
`PO₁(7)` through `p`: the `y`-degrees occurring in `supp(p)` are
`{0,1,2,3,4,5,6}` at every one of the 27 points (`c3_and_curve.py`).

## 3. Three components of mod-torus dimension 15 (the real answer)

If `a′ = b′ = 0` then `F(T) = u₀′u₁′u₂′`, and the polynomial ring is a domain,
so one of the `u_i′` vanishes. Each of the three resulting **linear** spaces

```
    {a′ = b′ = 0, u₂′ = 0} ,  {a′ = b′ = 0, u₁′ = 0} ,  {a′ = b′ = 0, u₀′ = 0}
```

is 18-dimensional affine, lies entirely in the cone, and its generic member has
plane orders exactly `(1,1,1)` (e.g. for `u₂′ = 0` one needs
`[X³]U₁ ≠ 0`, `[Y³]U₀ ≠ 0` and `[Z³]U₀ ≠ 0` or `[Z³]U₁ ≠ 0`). At an explicit
`K`-rational member the **exact** corank of the `52 × 39` Jacobian is **18**,
so the component is exactly that linear space:

> three components of `PO₁(7)` of projective dimension **exactly 17**, on
> which the generic torus orbit is 2-dimensional (exact: the three weight
> vectors are independent at a `K`-rational member). So each contributes
> **15 dimensions modulo the torus**:
>
> **`PO₁(7)` is NOT a finite union of torus orbits; `dim PO₁(7)/torus ≥ 15`.**

Geometrically these are the tuples whose image is contained in one of the three
`V4`-stable lines `⟨u_j, u_k⟩ ⊂ X`. (A smooth cubic threefold contains no
2-plane, and the only `V4`-stable lines of `P(W)` inside `X` are these three —
`P(A)` and the mixed lines `⟨αa+βb, u_i⟩` are not contained in `X`.) A second,
smaller family is the imprimitive one: for any `V4`-invariant `G` of degree
`2k` with `ord_{P_i}G = 0` and any `T ∈ PO₁(7−2k)`, `F(G·T) = G³F(T) = 0` and
`ord_{P_i}(G·T) = 1`; with `k = 2` and the classified degree-3 family (2.7) of
the `V4` THEOREM this gives a `5 + 2 = 7`-dimensional family. The 27
classified points are **primitive** (FIX-N2C: unit gcd), so they lie on none of
these.

---

## 4. Exact tangent spaces at the 27 classified points

`Θ(T) := g^{-1}(ψ(T))`, `ψ:(x,y,z)→(y,z,x)`, `g = (a,b,u0,u1,u2) ↦
(ωa, ω²b, u1,u2,u0)`. `Θ³ = id`, `F(ΘT) = F(T)∘ψ`, so the cone is
`Θ`-stable, `39 = 13+13+13` splits into `Θ`-eigenspaces (= FIX-N2C's
eigenblocks), and `ker J_p` is `Θ`-stable. FIX-N2C's nine-point scheme in each
block splits Galois-stably as `1+2+2+4` (parts A, B, C, D; both defining
cubics are (linear over `K`)·(irreducible quadratic) — `FIX-C1-PARAMETER-SPLIT`,
re-derived here).

`corank` = `39 − rank J_p` = affine tangent dimension of the cone;
**projective tangent dimension of `PO₁(7)` = corank − 1**.

| block | part | pts | `[L:K]` | rank `J_p` | corank | `Θ`-block coranks `(V₁,V_ω,V_{ω²})` | proj. tangent | torus | essential |
|---|---|---|---|---|---|---|---|---|---|
| `λ=1` | A | 1 | 1 | **31** | 8 | (2,3,3) | **7** | 2 | 5 |
| `λ=1` | B | 2 | 2 | **34** | 5 | (1,2,2) | **4** | 2 | 2 |
| `λ=1` | C | 2 | 2 | **34** | 5 | (1,2,2) | **4** | 2 | 2 |
| `λ=1` | D | 4 | 4 | **34** | 5 | (1,2,2) | **4** | 2 | 2 |
| `λ=ω` | A | 1 | 1 | **31** | 8 | (3,2,3) | **7** | 2 | 5 |
| `λ=ω` | B/C | 2+2 | 2 | **34** | 5 | (2,1,2) | **4** | 2 | 2 |
| `λ=ω` | D | 4 | 4 | **34** | 5 | (2,1,2) | **4** | 2 | 2 |
| `λ=ω²` | A | 1 | 1 | **31** | 8 | (3,3,2) | **7** | 2 | 5 |
| `λ=ω²` | B/C | 2+2 | 2 | **34** | 5 | (2,2,1) | **4** | 2 | 2 |
| `λ=ω²` | D | 4 | 4 | **34** | 5 | (2,2,1) | **4** | 2 | 2 |

The `Θ`-block coranks are listed in the order `(V₁, V_ω, V_{ω²})`; the point's
**own** eigenblock is the `j`-th entry, and in every row it is the *smallest*
one — `1` at parts B/C/D, `2` at part A. The other two entries are `2` (resp.
`3`), of which one dimension in each is a torus direction: `Θ` permutes
`E_x·p → E_y·p → E_z·p` up to `λ`, so the 3-dimensional torus space contributes
exactly one dimension to each `Θ`-block. Hence the essential directions are
`0 + 1 + 1` at B/C/D and `1 + 2 + 2` at A.

Consequences.

* **Local dimension of `PO₁(7)` at the 24 points of parts B/C/D lies in
  `[2, 4]`**, with exactly **2** of the tangent directions being source
  reparametrisation (the torus) and **2 essential** — one in each of the two
  eigenblocks *other* than the point's own. At the 3 part-A points it lies in
  `[2, 7]`, with 5 essential directions.
* **The trivial directions are exactly the torus.** The only continuous
  symmetries available are: the global scalar, and the degree-1
  `V4`-equivariant vector fields `V = (αx, βy, γz)` — i.e. the torus. The
  diagonal automorphisms of `(W, F)` commuting with `V4` are only
  `scalars × V4`-signs (finite), and the five slot-rescaling directions span a
  5-dimensional space meeting `ker J_p` in the scalar alone (verified
  modularly at every point) — so no extra trivial direction is hiding there.
* **Comparison with FIX-C1** (`goal_runs_after_541e12f/FIX_C1_CHEBYSHEV_LADDER`).
  C1's *level-1* kernel — `A4`-equivariant deformations at the next graded
  order — is `3 = 1 trivial + 2 essential` at parts B/C/D and `4` at part A.
  The present *level-0, `V4`-only* kernel is `5 = 3 trivial + 2 essential`
  (affine) at B/C/D and `8 = 3 trivial + 5 essential` at part A. **The
  essential count `2` at B/C/D agrees**, and both computations see the same
  jump at part A. The two are genuinely different computations (different
  graded piece, different equivariance) — the agreement is a consistency
  signal, not a duplication.

### 4.1 The level-0 Kuranishi obstruction — is the essential dimension 0 or 2?

The germ of the cone at `p` is isomorphic to the germ at `0` of the Kuranishi
space `Kur(p) = {v ∈ ker J_p : Ob(v) = 0}`, `Ob = Ob₂ + Ob₃ + ⋯ : ker → coker`
(`w` normalised into the pivot complement). `TC_p ⊆ V(Ob₂)`. `dim coker = 18`
at B/C/D, `21` at A.

* **parts B, C, D (24 points).** `Ob₂ ≡ 0` **identically** on `ker J_p`
  (exact, `produce_fin7.py` §5: every `3Φ(p,v_i,v_j)` lies in `im J_p`), and
  `Ob₃ ≡ 0` **identically** as well (`kuranishi.py`, symbolic in the 5 kernel
  coordinates over `F_p`: 0 nonzero cubic components out of 18). A scan of 8
  random rays per point lifts to order 10 with no obstruction at any point of
  parts B, C, D in all three blocks (`arc_scan.py`), and one ray lifts to
  order 26 (`arc_pade.py`). By Schwartz–Zippel a nonzero `Ob_k`, `k ≤ 10`,
  would be detected with probability `≥ 1 − (10/100057)^8`. **So the germ is
  smooth of affine dimension 5 = projective 4, essential dimension 2** — these
  points are *not* rigid modulo the torus. (Modular evidence; the certified
  bracket remains `[0,2]`.)
* **part A (3 points).** `Ob₂ ≢ 0`, and `V(Ob₂) ⊂ ker ≅ A⁸` is a **linear
  subspace of dimension 5** (`M2`: `dim 5, degree 1`, radical generated by 3
  linear forms). So `TC_p` is contained in a 5-dimensional linear space and the
  essential tangent-**cone** dimension at part A is `≤ 2`, the same bound as at
  B/C/D — the `4 → 7` tangent jump is second-order noise. Rays inside `V(Ob₂)`
  are obstructed at order 3 (including the torus rays — as they must be, since
  the torus arcs are *curved* in the kernel coordinates), so `Kur(p)` is
  singular at `0` there; its dimension is bracketed `[3,5]` affine.
* The torus directions are unobstructed at every point (exact check), as they
  must be.

---

## 5. `(3a)` C3-sweep, `(3b)` rational curves

**(3a).** `Θ` is a monomial matrix that permutes the monomial weights by `ψ`
(verified exactly), whence the exact commutation

```
        Θ ∘ g_{s,t,w}  =  g_{w,s,t} ∘ Θ .
```

Therefore the torus orbit of a `Θ`-eigenvector `p` is `Θ`-stable: the
components of `PO₁(7)` through the 27 classified points **are** `C3`-stable.
And since each classified point is a `Θ`-eigenvector, its **projective
`C3` × scalar orbit is the point itself** — the orbits are contained in the
components trivially. (`c3_and_curve.py`.)

**(3b).** YES. `τ ↦ g_{1,τ,1}·p` is a non-constant rational curve inside
`PO₁(7)` through every classified point (§2), and the whole 2-dimensional
torus-orbit closure is a rational (toric) surface inside `PO₁(7)`. So the
*constancy* conclusion of Prop 5.3 is unavailable even locally at the
classified points, and unavailable for a reason that is intrinsic
(reparametrisation), not accidental.

A `C3`-equivariant `Λ: ℓ_V ≅ P¹ → PO₁(7)` must send the two `C3`-fixed points
of `ℓ_V` to `Θ`-fixed points of the target; inside a torus-orbit surface the
`Θ`-fixed locus is the classified point itself (`Θ` acts there by the cyclic
permutation `(s,t,w) ↦ (w,s,t)`), which is consistent with Lemma 5.2(i) and
leaves the intermediate motion unconstrained. **This is exactly the
obstruction Prop 5.3 needed to exclude and cannot.**

---

### 5.1 Theorem 5.9 (a)(b)(c) cross-checked against this build (`thm59_checks.py`)

* **(a) holds, by parity, exactly as stated.** On `{x = 0}` the slots
  `a′, b′, u₀′` vanish identically (every monomial of each has odd `x`-exponent
  `≥ 1`), so `T({x=0}) ⊆ L_{σ₁} = {a=b=u₀=0}`; cyclically for `y, z`.
* **(b) needs one refinement at `m ≥ 1`.** On the `m = 0` cone the vertex
  `[1:0:0]` is hit only by `x^r`, which lives only in `u₀′` — so it maps to the
  χ-vertex as stated. But `x^r` is **exactly** the monomial that
  `ord_{P₁} ≥ 1` forbids: on the plane-order-`≥1` cone **all five slots vanish
  at the vertex**, so each source vertex is a **base point** of the map (it is
  blown up), not a point mapping to the χ-vertex. The elliptic-funnel reading
  of (b) therefore applies to the `m = 0` cell, not to the `m ≥ 1` cells that
  `[U1]` concerns. *(Recorded as a correction to Note IV §5.9(b).)*
* **(c) holds.** The minimal `(x,y,z)`-exponents over the 52 equation monomials
  are `(1,1,1)`: `xyz | F(T)` identically, so the level-0 restriction of the
  landing system to each `{x_i = 0}` is vacuous — the line-restriction data is
  unconstrained at level 0, exactly as stated. The `(X,Y,Z)` form of §1.1 is
  the resulting level-`≥1` system in closed form.

## 6. The `u₀ + v₀` parameter check (Prop 5.3's second clause)

H1 frame (`FIX_H1_EQUALIZER/produce_h1_branch2.py`): `Λ` is diagonal and

```
      u₀ := Λ_yy = [x⁶y]u₁′ = t0 = λ^{-1} B8 ,
      v₀ := Λ_zz = [x⁶z]u₂′ = w0 = λ^{-2} B5 .
```

Both structural identities are re-verified exactly here. Closed forms on the
nine-point scheme of each block (normalisation `P0 = 1`):

| block | `u₀ + v₀` | `u₀ − v₀` (the FIX-H1 equalizer residual) |
|---|---|---|
| `λ = 1` | `−( (ω−1)·B2·P1 + 6 )/6` | `−( (ω+1)·B2·P1 + 4ω+2 )/2` |
| `λ = ω` | `( (ω−1)·B2·P1 − 3 )/3` | `2ω+1` |
| `λ = ω²` | `−( (ω−1)·B2·P1 − 12 )/6` | `(ω+1)·B2·P1/2` |

**Exact verdict: `u₀ + v₀ ≠ 0` at all 27 classified points** — an explicit
inverse (a Nullstellensatz certificate `1 = h·(u₀+v₀)`) is exhibited in each of
the twelve residue fields, and re-checked by `h·(u₀+v₀) = 1`. Likewise
`u₀ − v₀ ≠ 0` at all 27, an independent recomputation of `FIX-H1-EQ-M1-EMPTY`.

So the "finitely many parameter points to be checked" in Prop 5.3 is the
**empty** set: had `PO₁(7)` been finite, Prop 5.3 would have fired with no
exception.

---

## 7. What this activates in Note IV

1. **Proposition 5.3 does not apply at `r = 7`, in either form.** The note's
   own honest caveat (§5.3) and the §5.9(d) correction are both confirmed:
   `FIN(7)` returns *infinite*, and it stays infinite after quotienting by the
   torus (mod-torus dimension `≥ 15`). `[U1]` for the `(1, 7)` row is **not**
   closed by the constancy criterion and must go through the `D_B`-style
   shape-pinning on the reachable-jet description (`J(1,7) ∩ E(1,6)`), as §4
   item 2 anticipates.
2. **The corrected Prop 5.3 must be restricted twice, and even then it fails
   at `r = 7`.** (i) The 15 mod-torus dimensions live entirely on tuples whose
   image lies in one of the three `V4`-stable **lines** `L_σ ⊂ X` — Theorem
   5.9(a)'s target lines, objects that cannot be the leading datum of a
   dominant map — so the hypothesis has to be asked on the *non-degenerate*
   stratum (image not contained in a line). (ii) But even there it fails at the
   classified points: **2 essential directions**, unobstructed through order
   10. What survives for the proof is the *bound*: near a classified point the
   non-degenerate stratum of `PO₁(7)` has at most 2 essential moduli, so a
   non-constant `C3`-equivariant `Λ` through a classified point must move in a
   germ of essential dimension `≤ 2`, with the torus contributing the other 2.
   Pinning **those two directions** — they sit one in each `Θ`-eigenblock other
   than the point's own, and they are listed explicitly by `kuranishi.py`'s
   kernel basis — is the concrete residual task for the shape-pinning route.
3. **`u₀ + v₀ ≠ 0` is banked** for all 27 classified points. Whatever
   re-establishes constancy (or a weaker "the D12-jet is an `h`-multiple"
   statement), the jet-vanishing step of Prop 5.3 then goes through with **no
   parameter exception**.
4. **A distinguished bad point.** Part A — the `K`-rational Chebyshev point
   `c₀ = (4kp−1)/3`, `P1₀ = (4/3)ω^{j+1}c₀`, one per eigenblock — is where the
   equivariant landing scheme is *singular* (own-block corank 2, not 1), where
   the non-equivariant tangent jumps `4 → 7`, and where `Ob₂ ≠ 0`. FIX-C1
   found its obstruction at the same three points. Any shape-pinning argument
   must treat these three points separately; conversely, they are the natural
   place to look for the pinning to bite.
5. **Correction owed to Note IV §5.9(b).** At `m ≥ 1` the source vertices are
   **base points** of the map, not points mapping to the χ-vertices: the only
   monomial that could survive at `[1:0:0]` is `x^r ∈ u₀′`, and `x^r` is
   exactly what `ord_{P₁} ≥ 1` forbids. (a) and (c) hold verbatim (§5.1).
   The elliptic-funnel reading of (b) therefore lives on the `m = 0` cell.
6. **Input for [U2] in its §5.9 shape.** The `(X,Y,Z)` reformulation of §1.1
   is the `P² ⇢ X` picture in closed form for odd `r` (`a′ = xyz·A` etc., one
   degree-`3(r−1)/2` identity `(★)`), and §1.2's completing-the-square puts the
   non-degenerate stratum in the form "an explicit degree-`(2r)`-form is a
   perfect square". Both are exact identities in all 39 parameters and are
   `r`-uniform in shape — the natural starting point for the structure theorem
   that §5.9 asks for.
7. **Nothing here bears on the Problem E headline, which stays OPEN.**

---

## 8. Scope, and what is *not* decided

* **`dim PO₁(7)` from above is NOT DECIDED.** Certified: `≥ 17`, with three
  components of dimension exactly 17. The linear-slice route (one explicit
  codim-`k` subspace missing the cone ⇒ `dim ≤ k−1`; and, the slice being
  defined over `O_K`, a single modular emptiness certificate would suffice by
  properness of `Proj` over `Spec O_K`) did not terminate: msolve does not
  finish 52 dense cubics in 20 variables, `M2`'s `gb`/`dim` does not finish on
  the 39-variable ideal nor on 17–21-variable slices, and the one sparse
  codim-18 slice that did finish **meets** the cone in a positive-dimensional
  set (it is not transverse) and so yields no bound. **Timeout, not a verdict.**
* **The local dimension at the classified points is bracketed, not pinned:**
  `[2, 4]` at all 27 points (lower bound = the torus orbit, exact; upper bound
  = exact Jacobian corank at B/C/D, and the exact quadratic tangent cone at
  part A). Equivalently the **essential** local dimension is certified only as
  `[0, 2]`. `Ob₂ ≡ Ob₃ ≡ 0` and the order-10 / order-26 ray lifts make `2` the
  answer beyond reasonable doubt at B/C/D, but they are modular
  Schwartz–Zippel evidence and **no closed-form 2-parameter essential family
  was produced**, so `= 2` is not *claimed* as a theorem. Consequence for the
  headline verdict: the certified `NOT-FINITE-MOD-TORUS` rests on the three
  17-dimensional linear components (exact, char 0), not on the classified
  points.
* An attempt to recognise the essential arc as an algebraic curve by Padé /
  rational reconstruction failed: the span of the arc's coefficient vectors
  through order 16 has rank 17, so the arc is not a low-degree rational curve
  in these coordinates (it is a formal, not necessarily algebraic, arc inside a
  higher-dimensional germ).
* **Only `r = 7` is treated.** `FIN(9)` etc. are untouched (Lemma 2.1's
  `q`-tower monotonicity means the `q²`-translates of these 27 points give the
  same picture at `r = 11`, but that is not computed here).
* Modular runs are never verdicts here: they appear as cross-checks (three
  split primes, identical answers at all 27 points) or as certified LOWER
  bounds on ranks, always matched by an exact upper bound (an exhibited
  kernel) or by an exact recomputation.

---

## 9. Engines, controls, replay

| claim | engine 1 | engine 2 |
|---|---|---|
| the 52 equations | `fin7_lib.landing_equations` (sympy polynomial arithmetic in `x,y,z`) | `fin7_lib.landing_terms` (term-list expansion) — plus a third literal build in `verify_fin7.py`, and equality with FIX-N2C `indep_r7` on each eigenblock |
| exact ranks 31 / 34 | own exact linear algebra over `QQ[om,kp,B2,P1]/(4 rels)` (structure constants + exact inversion), all 12 (block, part) pairs | **Macaulay2** `rank` over `toField(QQ[om,kp,B2,P1]/(...))`, fed only raw data (`m2/rank_j*.m2`); 8 of the 12 pairs run (`0A 0B 0C 0D 1A 1D 2A 2D` — every part, every block for parts A and D), **all agreeing** |
| `V(Ob₂)` at part A is a 5-plane | own Gram-matrix/ray analysis (`partA_tc.py`) | **Macaulay2** `dim`, `degree`, `minimalPrimes` on the 17 quadrics in 8 variables: `dim 5, degree 1`, radical generated by 3 linear forms |
| ranks, cross-check | three split primes `p ≡ 1 (3)`, `33` a QR, both block cubics split | identical `(on-cone, rank, torus dim, torus-in-ker)` at all 27 points, all three primes |
| `u₀ ± v₀ ≠ 0` | exhibited inverse in each residue field, re-multiplied to `1` | closed-form reduction modulo the block ideal (sympy `reduced`, coprime leading monomials ⇒ Groebner) |
| plane orders `(1,1,1)` | invertibility of a witness per plane in the residue field | modular non-vanishing at three primes |

Controls: `exalg` unit (`1`, `om`) and non-unit (`0`) probes; rank controls on
identity / zero / rank-2 matrices, modular and exact; and in `verify_fin7.py`
five `ck_must_fail` controls that the harness must report **false** (`om−1 = 0`
in `K`; a singular 2×2 having rank 2; a perturbed equation matching; a point of
one eigenblock being an eigenvector of another; a random point lying on the
cone). All pass.

Replay: `REPLAY.md`. Producer terminal line `FIX_U1_FIN7_PRODUCE_OK`;
verifier terminal line `FIX_U1_FIN7_VERIFY_OK`.
