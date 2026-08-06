# FIX IV — The conditional closure theorem (the assembly, stated before the grind)

Program FIX ([E56]). DRAFT-FOR-DERIVATION, opened 2026-08-06 on the
user's reorder directive: *prove that completing the computations would
close the result before performing them*. This note states the closure
theorem with named hypotheses, records which are proved, and reduces the
endgame to the unproved ones. Compute is downstream of this note from
now on: a computation runs only when a hypothesis below names its
verdict as a required clause.

Naming note: an earlier conversation floated "Note IV" for an
equivariant algebraization theorem (the constructive keystone). That
item is positive-route, unstaffed under the 2026-08-05 effort directive,
and unwritten; the name is reassigned here. Glossary rules E-numbers
canonical; no collision.

## 1. Proved inputs (all director-replayed; references)

- **(P1) Reduction.** Non-unirationality ⟺ no equivariant dominant
  `f: P(W) ⇢ X` in any degree ⟺ `V(Φ)(K_proj) = ∅` ([E16]/[E37]).
- **(P2) Parity.** Any such `f` has germ multi-order `(r; m,m,m)` at the
  V4-lines with `m` odd, minus-half leading (H0-1); all 55 plus-planes
  lie in the base locus.
- **(P3) Sweep.** The σ-exceptional datum surjects onto `L_σ` for every
  σ: the line sites carry nonzero germ data for every map (H0-2); in
  particular the leading line datum `Λ ≠ 0` (as a section along `ℓ_V`).
- **(P4) Localization.** Theorem H1-1: `Λ ∈ H⁰(ℓ_V, O(n)) ⊗ V_m`,
  `V_m := Hom(Sym^m W⁻, W⁻)`, `n = d − r ≥ 6e`, `e = r − m`; `Λ`
  vanishes to order `≥ 2e` at each of the three D12-points; the
  cross-V4 compatibility is exactly: at each D12-point,
  `λ_{2e} ∈ V_m[sgn^e]` (one-dimensional) and
  `λ_{2e+1} ∈ Im(ev_{v₀})`, with NO conditions at higher orders on the
  leading layer. Conditions are inclusive of zero.
- **(P5) Cone bound.** `r ≥ (3m+1)/2` (Note II, Lemma 2.1).
- **(P6) Section-from-map.** Every `f` induces a solution of the Note
  III CSP, constraint by constraint (Thm 5.1); `H⁰ = ∅ ⇒` no `f`.
- **(P7) Killed shapes.** The `D_B`-structured `(3,6)` family fails the
  order-0 equalizer at every line degree except the `n₃`-divisible
  sub-family (H1 + Correction H1-C); the classified `(1, odd r)`
  Chebyshev data fail it at all 27 points; the three K-rational seeds
  are Kuranishi-obstructed at every line degree (C1).

## 2. The reachable-jet sets

Fix `m` odd and `r ≥ (3m+1)/2`, set `e = r − m`. For an A₄-equivariant
landing family `T` of cone order `r`, plane orders `(m,m,m)`, and ANY
line degree `n`, let

```
    j(T)  :=  ( λ_{2e}(p_i), λ_{2e+1}(p_i) )_{i=1,2,3}
```

be the pair of Taylor coefficients of its leading line datum at the
three D12-points `p_1, p_2, p_3` of `ℓ_V` (a point of the fixed
finite-dimensional space `J_{m} := (V_m ⊕ V_m)^{⊕3}`, which depends on
`m` alone). Define the **reachable-jet set**

```
    J(m, r)  :=  { j(T) : T as above, some n ≥ 0 }  ⊆  J_m ,
```

and the **equalizer locus** `E(m, e) ⊆ J_m` cut by (P4)'s conditions at
each of the three points (it depends on `m` and on `e mod 2` only,
through `sgn^e`). By (P4), the leading-layer data of any global map lie
in `J(m,r) ∩ E(m,e)`.

**Lemma 2.1 (q-tower SECTION invariance — proved; corollary corrected
2026-08-06).** Multiplication by `q = x² + y² + z²` maps the `(m, r)`
cell to the `(m, r+2)` cell and FIXES the leading line datum as a
SECTION: `Λ_{qT} = Λ_T` along `ℓ_V`. *Proof.* The `(y,z)`-order-`m`
part of `(qT)⁻` is `q·[(T⁻)_{(m)}]`; the `x²`-term contributes
`x^{e+2}Λ` while `(y²+z²)·(T⁻)_{(m)}` has `(y,z)`-order `m+2`;
normalizing by `x^{e+2}` returns the same `Λ`. ∎

> **Correction IV-a (director, self-caught).** The original corollary
> `j(qT) = j(T)` and `J(m,r) ⊆ J(m,r+2)` CONFLATED orders: the cell
> `(m, r+2)` reads its jets at orders `2e+4, 2e+5` of the SAME section,
> not at `2e, 2e+1` — so the q-tower contributes *deeper Taylor data of
> unchanged sections*, not repeated jets. The corollary is withdrawn;
> [U2]'s framing via monotone jet sets with it. What survives and
> matters: a map germ lives at ONE `(m, r)` (the multi-order is a
> single global invariant), so [U2]'s true content is uniformity of the
> per-`r` kills, and Lemma 2.1's section-invariance remains the
> transport tool between them. The corrected [U2] formulation is §5.9.

## 3. The conditional closure theorem

**Hypotheses (the complete unproved list).**

- **[U1] (shape uniformity in `n`).** For each `(m, r)` in the residual
  range (see [U2], [U3]), `J(m,r) ∩ E(m,e) ⊆ {jets vanishing at both
  orders at all three points}`. (Model case proved: the `D_B` `(3,6)`
  shape argument of H1 is exactly this statement for its branch, all
  `n` at once. The Chebyshev kill is the `n = 0` stratum of its cell's
  version.)
- **[U2] (`r`-tower reduction).** For each odd `m`, there is `r₀(m)`
  such that: for `r ≥ r₀(m)`, every element of `J(m,r)` is either in
  `J(m, r-2)` (q-tower, Lemma 2.1) or has jet already covered by [U1]'s
  verified range — equivalently, the primitive contribution to the
  reachable-jet set stabilizes. (Open. The one structural fact banked:
  Lemma 2.1 gives monotonicity; needed is a bound on NEW jets from
  primitive families.)
- **[U3] (deep plane orders).** No germ with `m ≥ 5` odd passes the
  order-0/1 equalizer with nonvanishing jet — OR the `m ≥ 5` reachable
  sets are empty of new content (e.g. every `m ≥ 5` family is an
  invariant multiple of lower-`m` data along the leading layer). (Open.
  Note `dim V_m = 2(m+1)` and `E(m,e)` is computable for all `m` by the
  same S3 representation count as H1 — a finite rep-theory lemma per
  `m`, but [U3] must be uniform.)
- **[L] (the layered tower is exhaustive).** Extend (P4) to the layer
  filtration: for `k ≥ 1` the layer-`k` datum of a germ whose layers
  `< k` vanish at the D12-orbit satisfies the analogous localized
  equalizer; and simultaneous vanishing of ALL layers at the D12-orbit
  forces `T ≡ 0` along `ℓ_V`, contradicting (P3). (Open; the
  localization mechanism of H1 §3 is expected to apply verbatim per
  layer. This closes the zero-jet evasion channel — the `n₃`-divisible
  sub-family of H1-C is its first instance.)
- **[Ledger] (finite clauses).** The finitely many base verdicts the
  reductions above bottom out on — to be enumerated by [U1]–[U3]'s
  proofs, NOT computed in advance. Currently banked and certainly
  usable: the `(1, r ≤ 6)` and `(1,8)`-`n=0` emptiness, the `(2,·)` and
  even-`m` exclusions, the `(3,5)` emptiness, the three branch kills
  (P7).

**Theorem 3.1 (conditional closure).** Assume (P1)–(P7) and
[U1], [U2], [U3], [L]. Then `H⁰ = ∅`, hence no equivariant dominant
`f: P(W) ⇢ X` exists in any degree, hence `X` is not
PSL(2,11)-unirational.

*Proof, modulo the hypotheses.* Let `f` exist, of degree `d`, with germ
invariants `(r; m, m, m)`. By (P2), `m` is odd; by (P5),
`r ≥ (3m+1)/2`; by (P4), its leading jets lie in `J(m,r) ∩ E(m,e)`.
By [U3] reduce to `m ∈ {1, 3}`; by [U2] reduce to the finitely many
`(m, r)` below `r₀(m)`; by [U1] (with (P7) and [Ledger] supplying the
verified shapes) the jets vanish at both orders at all three points.
Then the germ enters the layer tower with vanishing leading layer; by
[L], induction over layers forces every layer's D12-jet to vanish, and
exhaustiveness forces `T ≡ 0` along `ℓ_V` — contradicting the sweep
(P3). So no `f` exists; (P1) converts this to the headline; (P6) is the
formal channel making the germ-to-CSP passage rigorous. ∎

## 4. What this buys, and the derivation queue

The theorem converts the endgame from "infinitely many computations"
into four named statements. Their current status, hardest first:

1. **[U2]** — the true keystone. Attack via Lemma 2.1 + the primitive
   structure theory (invariant multiplication reaches `{2k} ∪
   {m₀ + 2k}`, never `m = 1`; the `m = 1` primitive branch is
   uniformized on the trace curve). Target statement: the primitive
   reachable jets at `(1, r)` stabilize in `r` (the Chebyshev tower's
   jets are LITERALLY constant in `r` by Lemma 2.1 — what needs ruling
   out is a second, non-Chebyshev primitive tower with unbounded new
   jets).
2. **[U1]** — per-`(m,r)` shape arguments in the fixed space `J_m`; the
   `D_B` kill is the template (pin the shape family, intersect with the
   equalizer line, contradict branch arithmetic). Aim: run the template
   on the reachable-set DESCRIPTION rather than per-`n` families.
3. **[L]** — extend H1 §3's Serre-vanishing localization layer by
   layer; then the tower-exhaustiveness argument (a germ with all
   layers vanishing at the D12-orbit is divisible by the orbit ideal to
   all orders along `ℓ_V`, hence zero along it).
4. **[U3]** — first try: the leading-layer factorization forces `m ≥ 5`
   germs to be `q`- or `(xyz)`-divisible modulo lower cells (the
   invariant-multiplication structure theorem run in reverse); if that
   closes, [U3] reduces to [U1]/[U2] at `m ∈ {1,3}`.

No computation fires until one of these proofs names its base clauses.

## 5. Derivation log (director)

### 5.1 The equalizer multiplicity formula, and a strategy correction for [U3]

**Lemma 5.1 (proved by hand, character arithmetic).** For `V_m =
Hom(Sym^m std, std)` over `S3`:
```
  dim V_m[triv] = dim V_m[sgn] = ( (m+1) − χ_{Sym^m std}(ρ) ) / 3 ,
  χ_{Sym^m std}(ρ) = 1, −1, 0   for m ≡ 0, 1, 2 (mod 3).
```
*Proof.* `χ_{V_m}(τ) = χ_{Sym^m}(τ)·χ_{std}(τ) = 0` since
`χ_{std}(τ) = 0`, so the τ-term drops from both inner products and
`⟨χ_{V_m}, triv⟩ = ⟨χ_{V_m}, sgn⟩ = (1/6)[2(m+1) + 2·(−χ_{Sym^m}(ρ))]`;
the 3-cycle values of `Sym^m std` (eigenvalues `ω, ω²`) have period 3 as
stated. ∎ Checks: `m = 1`: dim 1 (H1's `V[triv]` = scalars ✓);
`m = 3`: dim 1 (H1's `V[sgn]` line ✓); `m = 5`: dim 2; `m = 7`: 3.

**Consequence (strategy correction).** The equalizer target space GROWS
linearly in `m`: the 1-dimensionality that made the `m ∈ {1,3}` kills
rigid is special to small `m`. Therefore [U3] cannot be proved by
equalizer-pinning at large `m`; it must go through the DIVISIBILITY
route — every `m ≥ 5` germ is an invariant multiple of lower-`m` data
along its leading layer (invariant-multiplication structure run in
reverse), folding [U3] into [U1]/[U2] at `m ∈ {1,3}`. The note's §4
queue is corrected accordingly.

### 5.2 The family structure of a positive-`n` leading datum

Fix `(1, r)`, `r` odd. The leading datum is a `V_1`-valued binary form,
equivalently a morphism `Λ: ℓ_V ≅ P¹ → (cone space)`; A₄-equivariance
makes it `C₃`-equivariant for the `C₃`-action on `ℓ_V` (D12-points = one
free orbit; exactly TWO `C₃`-fixed points).

**Lemma 5.2.** (i) At each of the two `C₃`-fixed points of `ℓ_V`, the
fiber of any landing family lies in the CLASSIFIED equivariant pointwise
locus (Specialisation Lemma [II, 2.3]): for `r = 7`, in the 27-point
Chebyshev set ∪ its degenerations ∪ {0}, eigenblock by eigenblock.
(ii) At every other point the fiber lies in the NON-equivariant
pointwise `r`-cone's plane-order-`≥1` locus. (iii) The three D12-jets
are `ρ`-translates of one another; the equalizer is the condition of
§H1 at any one of them. *Proof.* (i) is [II, 2.3] verbatim; (ii) is
specialisation without the eigenblock structure; (iii) is H1 §5. ∎

### 5.3 A constancy criterion reducing [U1] per row to a named computation

**Proposition 5.3.** Fix `(1, r)`. Suppose the pointwise
(non-equivariant) plane-order-exactly-1 locus of the projectivized
`r`-cone — call it `PO₁(r)` — is FINITE. Then every landing family's
leading datum is constant as a map to the projectivized cone, hence has
line degree 0 up to a scalar binary form `h`; its D12-jets are
`h`-multiples of a classified pointwise datum, and (P4) + the classified
kills (P7) force the jets to vanish: [U1] holds for the `(1, r)` row.
*Proof.* A morphism `P¹ → PO₁(r) ∪ (higher-order locus)` with finite
`PO₁(r)`: the preimage of the higher-order locus is closed and proper
(else plane order jumps globally, changing `m`), so `Λ` maps a dense
open into a finite set, hence is constant into it; `Λ = h·Λ₀` follows,
and the jet computation is H1 §4's (`u = h u₀, v = h v₀` with
`u₀ ≠ v₀` off the equalizer: order-`2e` condition forces `h_{2e} = 0`,
order-`2e+1` forces `h_{2e+1}(u₀+v₀) = 0`; if also `u₀ + v₀ ≠ 0` the
jets vanish; the locus `u₀ + v₀ = 0` is finitely many parameter points
to be checked as part of the named computation). ∎

**Named computation FIN(r)** (the first base clause named by a proof,
eligible to run under the reorder): decide whether `PO₁(7)` is finite;
if not, compute its dimension, its `C₃`-sweep structure, and whether a
rational curve inside it can pass through the classified equivariant
points compatibly (the actual obstruction to constancy). `FIN(9)` etc.
follow the same pipeline; their `r`-uniformity is [U2]'s business via
Lemma 2.1's monotonicity.

*Honest caveat.* `PO₁(6)`'s full-space analogue is KNOWN nonempty and
positive-dimensional in spirit (H1 §6b's remark), so `FIN(7)` may well
return "infinite" — in which case Prop 5.3 does not apply and [U1] for
the row needs the `D_B`-style shape-pinning on the reachable-jet
description instead. Either outcome of `FIN(7)` directs the proof; that
is what makes it a legitimate downstream computation.

### 5.4 Groundwork correction for [L]

The naive layer tower (the `(y,z)`-degree-`(m+2k)` packages `Φ_k`) has
divisorial vanishing only `e − 2k` along the mirror lines: the
kinematic (equivariance-only) equalizer conditions THIN OUT and vanish
for `k ≥ e/2`. So [L] cannot be pure kinematics like (P4); the layer
conditions must come from the LANDING COUPLING (the [II] ladder
differential linking `Φ_k` to `Φ_{<k}` through `F`). The correct [L]
statement to prove: *given layers `< k` vanishing at the D12-orbit to
their tested orders, the level-`k` landing equations localize a
condition on `Φ_k` at `c_σ`* — an equalizer-of-the-ladder, not of the
representation. This is the same mechanism as Fable's `I^{(m)}`
correction tower, localized at the D12-points; deriving it is the next
item after `FIN(7)` returns.

### 5.5 The concurrency amplification lemma (proved)

**Lemma 5.5.** Let `Ψ` be a `V`-valued germ at `c_σ` on `P_σ` whose
restrictions to the three mirror lines vanish to order `≥ t` at `c_σ`.
Then for every `k < t` the order-`k` Taylor term of `Ψ` lies in
`D_T · Sym^{k−3}(T*) ⊗ V`; in particular `term_1 = term_2 = 0` (a
linear form on a 2-dim space cannot vanish on three distinct
directions; a binary quadric cannot have three roots), so line-wise
order 2 forces full order 3, and the first potentially nonzero jet is
`term_3 = D_T ⊗ w₁` with `w₁ ∈ V[sgn^{e+1}]` (the D12-fibre argument of
H1 §3 applied to the `sgn`-twist carried by `D`). *Proof.* A degree-`k`
binary form vanishing at the three mirror directions is divisible by
the mirror cubic; apply componentwise; the twist bookkeeping is (2.1)
of H1 with one extra `sgn`. ∎

### 5.6 The kinematic tower terminates (proved)

**Lemma 5.6.** For a germ whose leading line datum hyper-vanishes at
the D12-orbit, S3-equivariance of `Φ⁽⁰⁾` imposes NO further condition
at any order past `2e+1`: by H1's own codimension count,
`Im(ev_{v₀}) = V` on `Sym^t` for `t ≥ 2`, so the first escaping jet is
kinematically free. *Consequence:* [L] is not representation theory;
the evasion channel dies, if it dies, through the landing coupling. ∎

### 5.7 The coupled tower in exact form (from certified A3)

By certificate A3, `F(w + y) = F₀(w) + Q(w; y, y)`: `F₀` cubic on
`W⁺`, `Q` linear in `W⁺` and quadratic in `W⁻`, nothing else. With the
normal expansions `T⁺ = Θ⁽⁰⁾ + Θ⁽¹⁾ + ⋯` (orders `m+1, m+3, …`) and
`T⁻ = Φ⁽⁰⁾ + Φ⁽¹⁾ + ⋯` (orders `m, m+2, …`), the landing identity
splits into level identities on `P_σ`:

```
I₀ (level 3m+1):  Q(Θ⁽⁰⁾; Φ⁽⁰⁾, Φ⁽⁰⁾) ≡ 0
I₁ (level 3m+3):  2Q(Θ⁽⁰⁾; Φ⁽⁰⁾, Φ⁽¹⁾) + Q(Θ⁽¹⁾; Φ⁽⁰⁾, Φ⁽⁰⁾)
                   + F₀(Θ⁽⁰⁾) ≡ 0
```

`I₀` is a NEW global identity coupling the plus- and minus-leading
packages, used by neither H0 nor H1. Isotypically (`W⁺ = triv ⊕ std`,
`Sym²W⁻ = triv ⊕ std`, `Q` S3-invariant):
`Q(w; y²) = α·w_t·(y²)_t + β·⟨w_s, (y²)_s⟩` — two frame constants,
EXACT in the affine chart at `c_σ` because `Q` is linear in `w` and
`c_σ` spans the `triv`-line of `W⁺` (the chart's coordinates ARE the
std-part).

### 5.8 The first transfer condition on the evasion channel (proved modulo stated bookkeeping)

Maximal evasion case at `m = 1`: leading jets vanish through the tested
orders, first escape `term_3 = D ⊗ w₁`, `w₁ = c·γ`, `γ` spanning the
1-dimensional `V₁[sgn^{e+1}]` (Lemma 5.1). Factor `Φ⁽⁰⁾ = D^e Ψ`,
divide `I₀` by `D^{2e}`:
`α Θ⁽⁰⁾_t (Ψ⊗Ψ)_t + β ⟨Θ⁽⁰⁾_s, (Ψ⊗Ψ)_s⟩ ≡ 0`. Its order-6 jet at
`c_σ` isolates `D²·(w₁⊗w₁)` (all lower `Ψ`-jets die by Lemma 5.5), and
`D² ≠ 0` as a form, so:

```
    c² · [ α θ_t (γ⊗γ)_t + β ⟨θ_s, (γ⊗γ)_s⟩ ]  =  0 ,
    (θ_t, θ_s) := Θ⁽⁰⁾(c_σ) ∈ Hom(Sym²std, triv ⊕ std)^{S3} ≅ C² (Schur).
```

**Either the evasion coefficient dies (`c = 0`), or the plus-package
value at `c_σ` is forced onto an explicit PROPER subspace — codim 1 at
`m = 1`, codim 2 at `m = 3`** (FIX-L1's correction: the displayed
`≅ C²` is the `m = 1` case; at `m = 3`, `Sym⁴std = triv ⊕ 2·std` makes
the `Θ`-space 3-dimensional and the transfer rank 2). The condition
TRANSFERS rather than kills; `I₁` then binds the transferred constraint
against `Θ⁽¹⁾, Φ⁽¹⁾` — the genuine [L]-ladder, now with its first rung
in closed form. Bookkeeping owed: escape at order exactly `2e+2`, and
unequal line-wise orders (same method; the Thm 5.15 budget is
order-pattern-independent); plus FIX-L1's flagged item — possible
forced `D`-divisibility of `Θ⁽⁰⁾` at `c_σ`, which would shift rung
orders without affecting the budget (feeds (C2′)'s jet bookkeeping).

**FIX-L1 verdicts (landed 2026-08-06, director-replayed 272/272,
`FIX_L1_VERIFY_OK`):** `α = 3(3+√33) = 12c ≠ 0`, and `F(c_σ) = c³`, so
**`α = 0 ⟺ F(c_σ) = 0`: the t-channel nondegeneracy IS the certified
fact "`c_σ` off `X`" — it can never degenerate for this cubic.**
`β = 1` (it IS the `xyz`-coefficient; the std-block is the perfect
pairing `[[24δ, 0], [0, 1]]`). Transfer condition NONVACUOUS in all
four `(m, twist)` cases, solution space 1-dimensional in each. All
four `V_m[twist]` generators in closed form (`V₃[sgn]` matches H1's
payload); `ρ|_{W⁺}` in normal-form coordinates delivered; `Q` is an
isomorphism `W⁺ ≅ (Sym²W⁻)*`. **(C2) DISCHARGED — nondegeneracy not
merely verified but explained.**

**Named computation FIX-L1** (proof-named, small): exact σ-frame values
of `α, β`; the generator `γ` of `V₁[sgn^{e+1}]` (both parities of `e`)
and of `V₃[sgn^{e+1}]`; the isotypic components `(γ⊗γ)_t, (γ⊗γ)_s`;
nondegeneracy of the transfer hyperplane
(`(α(γ⊗γ)_t, β(γ⊗γ)_s) ≠ (0,0)`); the analogous data at `m = 3`. Pure
frame constants; the [L] continuation consumes them.

### 5.9 The recursion principle (proved), the torus correction to Prop 5.3, and [U2] reframed

**Theorem 5.9 (pointwise cells are equivariant maps one dimension
down).** A pointwise element of the `(·, r)` cone — a degree-`r` tuple
`T(x,y,z)` in the V4-parity slots with `F(T) ≡ 0` — is precisely a
**V4-equivariant rational map `P² ⇢ X`** of degree `r`, V4 acting on
the source `P²` by the sign characters and on the target through
`W|_{V4}`. Under this identification, for `r` ODD:

- **(a) Lines land on lines, by parity alone.** On the source fixed
  line `{x = 0}` (σ₁-fixed in `P²`), the slots `a', b', u₀'` vanish
  IDENTICALLY: their parity classes require `(0, j, k)` patterns with
  `j + k = r` that violate the class parities (all-even/all-odd for
  `a, b`; both χ₁-classes for `u₀'` — checked; cyclic for the other
  lines). Hence `T({x = 0}) ⊆ {a = b = x = 0} = L_{σ₁}`: **each source
  V4-line maps into the corresponding target 55-line**; the elliptic
  option is parity-forbidden at odd `r`.
- **(b) Vertices land on `X^{V4}` — six points.** `X^{V4}` = the three
  type-II points (`ℓ_V ∩ X`) plus the three χ-vertices (on `X` because
  no `x_i³` monomial is V4-invariant). At odd `r` the source vertex
  maps to its χ-vertex (pure `x^r` lives only in `u₀'`), which lies on
  `E_{σ₁} = X ∩ P_{σ₁}` — a POINT of the elliptic, exactly as the
  rational-to-elliptic funnel demands.
- **(c) Line-restrictions are unconstrained at level zero.** On
  `{x = 0}` the landing identity reads `F|_{L₁}(u₁', u₂') ≡ 0` —
  automatic since `L₁ ⊂ X` (certificate A2). The line-maps
  `{x = 0} → L₁` acquire constraints only through the HIGHER `x`-levels
  of `F(T) ≡ 0` — the source-side analogues of §5.7's `I_k`
  identities (the same `F₀ + Q` split, per source involution).
- **(d) The 2-torus, and the correction to Prop 5.3.** The diagonal
  torus `diag(λ, μ, ν)` commutes with V4 and acts on every pointwise
  cone preserving all orders — so no stratum with trivial
  torus-stabilizer is literally finite, and `FIN(r)` as first phrased
  was trivially infinite (caught before the verdict; worker
  redirected). **Prop 5.3's hypothesis is corrected to "finitely many
  torus orbits"; its conclusion survives**: a morphism from `P¹` into a
  finite union of locally closed torus orbits is constant on the open
  stratum (a complete rational curve in `(C*)^k` is constant), so the
  constancy criterion stands in the corrected form.

**[U2] reframed (the keystone in its true shape).** Classify
V4-equivariant maps `P² ⇢ X` — landing type forced by (a)/(b) at odd
`r`, line-moduli entering only through (c)'s coupled tower, modulo
(d)'s torus — **uniformly in `r`**. The discrete landing data is
degree-independent, and the surface-level machinery (the T2.2 chains =
Duncan's fabulous crossings, at source vertices whose stabilizer is the
full V4 — non-cyclic, unbreakable) applies to these maps exactly as the
top level applies to `P⁴ ⇢ X`: **the program recurses onto its own
surface case** — the very setting of the collaborators' original
observation. One structure theorem about `P² ⇢ X` under V4 replaces
the infinite tower of per-`r` computations; that theorem is now the
sharpest formulation of [U2].

### 5.10 The source-side ladder: closed form, and the squareness lemma (proved)

Work at one source line `{x = 0}` of a pointwise `(1, r)` element,
`r = 2s + 1` odd. By §5.9 the line data is
`u₁'|₀ = y·P(u, v)`, `u₂'|₀ = z·Q(u, v)` with `(u, v) := (y², z²)` and
`P, Q` of degree `s` — the equivariant odd self-map of the target line
`L₁`, vertices to vertices. The first normal data along the line has
the forced parity shapes `a₁ = yz·A(u,v)`, `b₁ = yz·B(u,v)` (degree
`s−1`) and `u₀'₁ = U(u,v)` (degree `s`).

**Level-1 identity (closed form).** The `x¹`-coefficient of
`F(T) ≡ 0` along the line, after dividing the forced `yz`, is the
degree-`3s` identity in `(u, v)`:

```
  (Q₂ₐ u P² + Q₃ₐ v Q²)·A + (Q₂ᵦ u P² + Q₃ᵦ v Q²)·B + c·P Q·U ≡ 0 ,
```

where `Q₂, Q₃` are the linear forms and `c` the `xyz`-constant of the
V4-normal form `F = C(a,b) + Σ Qᵢ(a,b)xᵢ² + c·xyz`, and subscripts
denote the (constant) `a`/`b`-coefficients. *Derivation:* `dF` at a
point `(0,0,0, y₀, z₀)` of `L₁` has slots
`(Q₂ₐy₀² + Q₃ₐz₀², Q₂ᵦy₀² + Q₃ᵦz₀², c·y₀z₀, 0, 0)` — the `y, z`
partials vanish on the line (it lies on `X`), so the minus-side normal
data is level-1-free, and the plus-side data enters linearly. ∎

**Lemma 5.10 (squareness, uniform in `r`).** The level-1 identity is a
SQUARE linear system for the plus-normal data at every odd `r`:
`3s + 1` coefficient equations in `3s + 1` unknowns
(`A: s`, `B: s`, `U: s + 1`). Hence there is a UNIVERSAL square matrix
`M(P, Q)` — polynomial in the line-map coefficients, of fixed shape for
all `r` — with: `det M(P,Q) ≠ 0` ⟹ the first normal layer is uniquely
determined by the line map; the branch/moduli phenomena are confined to
the hypersurface `det M = 0` and to the CONSISTENCY conditions that
levels `≥ 2` impose back on `(P, Q)`. ∎ (Counting: identity degree
`1 + 2s + (s−1) = 3s`, so `3s+1` coefficients; unknowns
`s + s + (s+1)`.)

**Consequences and the [U2] proof plan it dictates.** (i) Generic line
maps determine the whole first layer rigidly; the classification of
pointwise `(1, r)` elements is governed by the pair
(`det M`-locus, level-2 consistency resultants) — POLYNOMIAL objects of
degree-independent shape in the line-map coefficients. (ii) The
`n = 0` finiteness phenomena (the 27 points) and the FIN(7) worker's
redirected computation measure exactly this: the essential transverse
dimension at a witness is the kernel of this square system plus the
level-2 conditions — the running computation and the derivation have
converged on the same object from two sides. (iii) [U2]'s structure
theorem now has a concrete proof shape: show the consistency locus in
`(P, Q)`-space is a finite union of torus orbits of the known branch
shapes, by analyzing the universal resultants — one argument for all
odd `r`. The same construction at even `r` (type-II vertex anchors,
per §5.9(b)'s parity flip) is the even-row analogue.

### 5.11 The rigidity theorem for the source ladder (proved)

**Theorem 5.11.** Fix `r = 2s+1` odd and a pointwise `(1, r)` element,
restricted to a source line as in §5.10. Then:

**(i) (Strict parity alternation.)** At odd `r`, the minus slots
`u₁', u₂'` contain ONLY even `x`-degrees and the plus slots
`a', b', u₀'` ONLY odd `x`-degrees (per slot, one V4-parity class is
empty because `i + j + k = r` fixes the total parity). The normal
expansion along a source line therefore alternates strictly:
level 0 minus (the line map), level 1 plus, level 2 minus, level 3
plus, ….

**(ii) (Level 2 is vacuous.)** On the line, ALL second derivatives of
`F` in plus⊗plus directions vanish (`C` is cubic in `(a,b)` and
`a = b = 0` there; `∂²F/∂x² = 2Q₁(0,0) = 0`; mixed `a,x` terms carry a
factor `x`), and `dF` annihilates minus-vectors (the line lies on `X`).
Since level-2 data is pure minus by (i), the `x²`-identity reads
`dF·T₂ + ½d²F(T₁,T₁) = 0 + 0`: **automatically satisfied**. The
level-2 minus data `(R, S)` is locally free; the first genuine
consistency conditions on the line map live at level `≥ 3`.

**(iii) (Rigidity off the degeneration strata.)** After the invertible
change of unknowns by the constant matrix
`𝔔 = [[Q₂ₐ, Q₃ₐ], [Q₂ᵦ, Q₃ᵦ]]` (nondegeneracy `det 𝔔 ≠ 0` and
`c ≠ 0` are frame facts, FIX-L1-adjacent), the level-1 system is
`Ã·uP² + B̃·vQ² + U·PQ ≡ 0`. **If `gcd(P,Q) = 1`, `u ∤ Q`, and
`v ∤ P`, the only solution in the critical degrees is zero** — i.e.
`det M(P,Q) ≠ 0` and the first plus-layer is UNIQUELY determined by
the line map, for every odd `r` at once. *Proof.* `Q | Ã·u·P²` with
`gcd(Q, P) = 1` gives `Q | Ãu`; `u` is prime in `k[u,v]` and `u ∤ Q`,
so `Q | Ã`; `deg Ã = s−1 < s = deg Q` forces `Ã = 0`. Then
`B̃vQ = −UP`, so `P | B̃v`, `v ∤ P` gives `P | B̃`, degree forces
`B̃ = 0`, then `U = 0` (`c ≠ 0`). ∎

**(iv) (The degeneration strata are geometric, and inductive.)** The
three excluded loci are exactly: `gcd(P, Q) ≠ 1` — base points of the
line map on the source line, i.e. DEGREE DROP (the reduced map has
smaller `s`: downward induction available); `u | Q` and `v | P` —
base-point degenerations AT THE VERTICES, which the plane-order-1
nondegeneracy partially forbids outright (the vertex conditions force
the complementary slot values nonzero). So the entire `(1, odd r)` row
splits into: the RIGID stratum (layer 1 determined; consistency
analysis at levels `≥ 3` on `(P,Q)` alone), and degeneration strata
handled by induction on `s` — the descending structure [U2]'s
uniformity argument wanted.

**Where the consistency begins.** By (i)+(ii) the ladder's unknowns
arrive: level 1 plus (`3s+1`, exactly consumed by the square system on
the rigid stratum), level 2 minus (`2s`, free at level 2), level 3
plus (`3s−2`), … while each level-`ℓ` identity has `~3s+1−ℓ`
coefficients; cumulative equations overtake cumulative unknowns at a
computable level `ℓ*(s)` — computed exactly in §5.12.

### 5.12 The balance theorem (proved): the ladder is exactly balanced to level `r`, then `s·r` pure consistency equations

**Theorem 5.12.** For the source ladder of a pointwise `(1, 2s+1)`
element:

**(o) All even levels are EMPTY by parity.** `F(T)` is V4-invariant, so
its monomials `x^ℓ y^j z^k` have `(ℓ,j,k) ≡ (0,0,0)` or `(1,1,1)`
mod 2; total degree `3r = 6s+3` is odd, forcing the all-odd class:
`ℓ` odd. (This subsumes Thm 5.11(ii)'s Hessian computation by pure
parity, and holds at ALL levels, not just level 2.)

**(a) Counts.** At odd level `ℓ = 2t+1`: equations `E_t = 3s+1−t`;
new plus-unknowns `N_{2t+1} = 3(s−t)+1` (for `t ≤ s`). At even level
`2t` (`1 ≤ t ≤ s`): new minus-unknowns `N_{2t} = 2(s+1−t)`; zero
equations. Slots end at `x`-degree `r`, so unknowns stop at level
`r = 2s+1`; the identity continues to level `3r`.

**(b) Exact balance.** The cumulative deficit through level `2T+1` is

```
    D(2T+1) = 2T(T − s) :
```

zero at `T = 0` (Lemma 5.10's squareness), strictly negative through
the middle (`0 < T < s`: the ladder stays locally solvable with free
minus-parameters), and **exactly zero again at `T = s`, the last
unknown level** — the source ladder is precisely critical, with not
one equation to spare through level `r`.

**(c) The tail.** Levels `r+2, r+4, …, 3r` carry NO new unknowns and

```
    Σ_{t=s+1}^{3s+1} (3s+1−t)  =  s(2s+1)  =  s·r
```

pure consistency equations on the level-`≤ r` solution — i.e., after
the rigid-stratum elimination (Thm 5.11(iii) plus the level-by-level
solvability of (b)), **`s·r` polynomial conditions on the `2s+2`
line-map coefficients, of which `2s−1` are essential mod torus and
scalar.** The overdetermination margin `s·r − (2s−1) = 2s²−s+1` grows
quadratically in `s`.

**Consequences.** `ℓ* = r+2` for every `s`; the "leading consistency
resultant" of §5.11 is the level-`(r+2)` identity evaluated on the
solved ladder; and the expected dimension of the rigid-stratum
consistency variety is `(2s−1) − s·r < 0` with quadratically growing
margin — the correct *shape* for uniform mod-torus finiteness, though
shape is not yet proof (the equations are specific, not generic; see
§5.14 item (T1)).

### 5.13 [U3] folds into the master ladder (proved modulo a bookkeeping dictionary)

The slot parity classes are independent of `m`; hence Theorem 5.11(i)
(alternation), 5.9(a) (lines land on lines at odd `r`), and the entire
level structure of §5.10–5.12 hold VERBATIM for every odd `m` — the
plane order enters the pointwise problem ONLY through vanishing-order
boundary conditions at the two vertices of each source line (the
endpoint orders of the binary forms in the ladder). Therefore the
pointwise `(m, r)` loci for ALL odd `m` are the strata of ONE master
consistency variety, filtered by endpoint vanishing orders — and the
deep-`m` strata are exactly the vertex-degenerate strata of
Thm 5.11(iv), already inside the degree-drop induction. **[U3] is
hereby merged into [U1]/[U2]: it is no longer a separate hypothesis.**
(Owed: the half-page endpoint-order dictionary `m ↔` vanishing
pattern, to be written when the master analysis is finalized; no new
mechanism is involved.)

### 5.14 Reduction status: what is CAS, what is still theorem

Everything the closure theorem needs now sorts into exactly two
remaining THEOREMS and a short list of UNAVOIDABLE CAS calls.

**Remaining theorems (derivation, not computation):**

- **(T1) Tail uniformity.** The rigid-stratum consistency variety
  (§5.12(c)) is a finite union of torus orbits, uniformly in `s`.
  Route: downward induction via the degeneration strata (degree drop
  in `s`, base cases = the SEALED `(1, r ≤ 5)` emptiness ledger)
  plus an argument on the rigid part — either transversality of the
  tail system or a structural factorization of the level-`(r+2)`
  resultant. This is the keystone's final form; it could still
  produce a genuine obstruction (an unexplained resultant component =
  a candidate branch).
- **(T2) [L] completion.** Rung 2 (binding the §5.8 transfer through
  `I₁`), the non-maximal-evasion bookkeeping, and exhaustiveness
  (all layers vanishing at the D12-orbit forces `T ≡ 0` along `ℓ_V`,
  against the sweep (P3)). Blocked only on the FIX-L1 constants for
  its nondegeneracy inputs; the mechanism is §5.7's.

**Unavoidable CAS calls (each named by a proof):**

- **(C1)** FIN(7), redirected form — mod-torus essential dimension at
  the 27 witnesses + component sweep + the `u₀+v₀` finite check.
  IN FLIGHT. (Empirically tests Thm 5.11(iii)'s rigidity and
  Prop 5.3's hypothesis at the base `r`.)
- **(C2)** FIX-L1 — the frame constants `α, β, γ, (γ⊗γ)_iso` and
  nondegeneracy. IN FLIGHT. (Feeds (T2).)
- **(C3)** The tail resultant at `s = 3`: compute the level-9 (and if
  needed 11, 13) consistency polynomials on the rigid stratum at
  `r = 7`, verify the vanishing locus equals the 27 witnesses' torus
  orbits. (The `s ≤ 2` base cases are ALREADY BANKED: `(1,3)`,
  `(1,5)` EMPTY, sealed.) TO FIRE when (T1)'s induction states its
  exact base requirement.
- **(C4)** The even-`r` master base cases — ALREADY BANKED
  (`(1,6)` through `n = 3` char-0; `(1,8)` at `n = 0` sealed
  two-path); the even-`r` ladder derivation (type-II anchor flip of
  §5.9(b)) reuses the odd-`r` method and names any residual runs.

Assembly and the full independent audit close the program once (T1)
and (T2) land. Nothing else remains.

### 5.15 (T2) executed: the finite-rung theorem, and [L] reduced to (T1) plus two finite checks

**Theorem 5.15 (exhaustiveness in the constancy regime — proved).**
Assume the row's constancy conclusion (Prop 5.3's corrected form, i.e.
what (T1) delivers): the top-level leading datum is `Λ = h·Λ₀` with
`Λ₀` a fixed pointwise branch datum and `h` a binary form of degree
`n = d − r`. Then the [L]-tower is FINITE with an explicit bound:
the rungs test successive Taylor coefficients of `h` at the three
D12-points; if every rung kills its coefficient, then `h` vanishes to
total order `> n` across the orbit, forcing `h ≡ 0`, hence `Λ ≡ 0` —
contradicting the sweep (P3). So at most `⌈n/3⌉ + 1` rungs are ever
needed, and "all layers vanish" is impossible for a genuine map.
*Proof.* A nonzero binary form of degree `n` has at most `n` zeros
counted with multiplicity; three points with vanishing order
`> n/3` each exceed the budget. ∎

**Reduction 5.15′ ([L] modulo (T1) — proved).** Each rung either kills
its `h`-coefficient outright (when the transfer pairing is
nondegenerate and the `Θ`-side is unconstrained) or imposes one linear
condition on the finite-dimensional jet space of `Θ⁽⁰⁾` at `c_σ`
(dimension `2·dim(jets to the tested order)`, explicit). Hence [L]
holds as soon as: **(C2)** the frame constants are nondegenerate
(in flight), and **(C2′)** the successive rung conditions are linearly
independent on the `Θ`-jet space through the budget of Theorem 5.15 —
a single finite linear-algebra check per `m ∈ {1, 3}`, named here as a
CAS call. With (T1), (C2), (C2′): **[L] is proved.** The owed §5.8
case bookkeeping (non-maximal evasion) is subsumed: unequal or shifted
vanishing orders only re-index which `h`-coefficients the rungs test;
the budget argument is order-pattern-independent.

### 5.16 The division question, and a new recursion floor (executed to structure)

The degree-drop induction (Thm 5.11(iv)) needs a DIVISION LEMMA: does
a common factor `g` of the line-maps extend to a factorization of the
whole tuple? Executed analysis for the main stratum `g = u + v`
(equivalently `q|_{line}`, the case containing the `q`-tower):

**Theorem 5.16 (dichotomy on the `u+v` stratum — proved).** Let `T` be
a pointwise element whose three line-restrictions are divisible by
`u + v`. Then either `q | T` (all slots) — and `T = q·T′` descends the
tower with `r ↦ r−2` — or the restriction `T̄ := T|_{q=0}` to the
invariant conic is a NONZERO **V4-equivariant landing datum on the
conic**: a V4-equivariant `P¹ ⇢ X` (the conic is V4-stable and
rational) of degree `≤ 2r` whose values on the six points
`conic ∩ (source lines)` vanish. *Proof.* `q | T` iff `T̄ = 0`;
`F(T̄) = 0` and equivariance restrict; the line-divisibility hypothesis
is exactly the vanishing at the six intersection points. ∎

So the induction's obstruction is a NEW, one-dimension-lower
recursion floor: **V4-equivariant rational curves on `X`** (the
conic-supported data). This is classical-adjacent geometry — the
V4-stable rational curves on a cubic threefold with prescribed
equivariance and six-point vanishing — finite-dimensional per degree,
and the natural target of the same parity/funnel analysis (a V4-stable
rational curve meets `X^{V4}` — six points — or the involution loci,
and the elliptic components again receive only points). Its
classification is named **(T1b)** below. Note the satisfying
structure: the program now recurses `P⁴ → P² → P¹`, one source
dimension per floor, each floor's degenerations living on the next.

### 5.17 (T1) decomposed to its irreducible core

- **(T1a) Rigid-tail orbit finiteness** — on the rigid stratum
  (Thm 5.11(iii)), the `s·r` tail equations cut finitely many torus
  orbits, uniformly in `s`. OPEN — this is the single remaining core
  of the negative program. Sharpest attack surface: the level-`(r+2)`
  resultant's structure, plus the C3-stable-curve refinement (a
  family's image is a C3-stable rational curve in the locus, so
  positive-dimensional NON-C3-stable moduli would still not defeat
  constancy — the needed statement is strictly weaker than literal
  orbit-finiteness).
- **(T1b) The conic floor** — classify V4-equivariant conic-supported
  data (Thm 5.16's second branch). NEW but structured; expected
  finite by the recursion's own funnel arguments.
- **(T1c) Vertex-degenerate strata** — the endpoint-order bookkeeping
  (subsumes old [U3]); mechanical, the dictionary owed from §5.13.

**Program state after this section.** PROVED tonight: 5.15, 5.15′,
5.16 (plus 5.12–5.14 earlier). The ENTIRE negative headline now rests
on: **(T1a)** and **(T1b)** as theorems; **(C1), (C2), (C2′), (C3)**
as named finite computations (two in flight); (T1c) as bookkeeping;
then assembly + audit. Nothing else. If (T1a) fails structurally —
an unexplained resultant component — that component is an explicit
candidate branch, and the program's honest output changes sign
accordingly.

### 5.18 (T1a) attacked: the tail is the vertex-jet system, and the double-projection reformulation

**Correction IV-b (self-caught mid-derivation).** A first computation
of the top tail level read `c·P0·β₁β₂ = 0`; it MISSED the
`Q₁(a',b')·u₀'²` contribution at the same level. The correct top tail
equation is

```
    P0 · Q₁(α_a, α_b) + c · β₁β₂ = 0
```

— and this is precisely the SECOND FUNDAMENTAL FORM of `X` at the
χ₁-vertex (local model `Q₁(a,b) + c·yz + h.o.t. = 0`: the hyperbolic
form `c·yz` corrected by the graph terms) applied to the map's 2-jet.
The error and its repair reveal the right identification:

**Theorem 5.18-A (the tail is the vertex-jet landing system —
proved).** Under `ℓ ↔ (y,z)`-degree `3r − ℓ`, the tail levels
`r+2 ≤ ℓ ≤ 3r` are EXACTLY the conditions that the extended tuple's
jet AT THE VERTEX lands on `X` through `(y,z)`-order `2r − 2`, while
the solved levels `ℓ ≤ r` are the line-jet conditions. The consistency
variety of §5.12(c) is therefore: **line data whose unique rigid
extension lands on `X` to vertex-order `2r−2`** — the
overdetermination is the classical two-boundary problem (line boundary
vs vertex jet), and the top equations are the vertex's differential
geometry (second fundamental form first, then the higher fundamental
forms in order). ∎ (Immediate check: the hyperbolic form `yz` at the
vertex is the source of the `c`-coupling throughout.)

**Theorem 5.18-B (double-projection reformulation — proved at the
stated scope).** The χ₁-vertex `v` LIES ON `X` and on the two lines
`L₂, L₃` of its own V4-triangle. Projection from `v` is a
V4-equivariant rational map `π_v : X ⇢ P³` of degree 2 (a line
through a point of a cubic meets two residual points), branched over a
quartic surface `Δ_v ⊂ P³` (the discriminant of the residual
quadratic), with the lines of `X` through `v` contracted. Hence a
V4-map `T: P² ⇢ X` with vertex value `v` is equivalent to: a V4-map
`h = π_v ∘ T : P² ⇢ P³` together with a SHEET DATUM, and the
existence of the lift is governed by the DISCRETE condition
`h*(Δ_v) ∈ 2·Div` (evenness of the pulled-back branch divisor, in the
V4-equivariant sense), plus the bookkeeping of the contracted lines
and the indeterminacy at `v`. **The landing condition becomes a
divisibility condition over a FREE mapping space** — the kind of
discrete, degree-uniform statement that uniform theorems are made of.
∎ (scope: the 2:1 structure and branch-quartic statement are classical
projection geometry, asserted here with the V4-equivariance which is
immediate since `v` is V4-fixed; the equivariant lifting criterion in
the presence of the contracted lines is the named remaining work.)

**Named remaining work for (T1a), after this section:** (i) the
equivariant lifting/divisibility criterion over the contracted-line
locus (derivation); (ii) **(C5)** compute `Δ_v` and its V4-structure
explicitly in the frame (small CAS, named now); (iii) conclude
orbit-finiteness from the divisibility: the parity of `h*(Δ_v)`
stratifies the free mapping space into DISCRETE classes, and within a
class the sheet data is rigid — the finiteness question becomes the
finiteness of admissible parity classes, a cohomological count. This
is the route; (T1a) is NOT closed tonight and is stated so.

### 5.19 The branch quartic in closed form, the γ-criterion, and what the projection does and does not buy

**Δ_v by hand (with a built-in consistency check).** Recentering
`F` at the χ₁-vertex (`x = 1 + x′`) gives `ℓ = Q₁(a,b)`,
`q = 2Q₁x′ + c·yz`, `k = C + Q₁x′² + Q₂y² + Q₃z² + cx′yz`, and in
`Δ_v = q² − 4ℓk` every `x′`-term CANCELS (as it must — the
discriminant lives on the projection base `P³`):

```
    Δ_v  =  c²y²z² − 4·Q₁(a,b)·[ Q₂(a,b)y² + Q₃(a,b)z² + C(a,b) ] .
```

(C5)'s job shrinks to the geometry: irreducibility, singular locus,
V4-orbit structure, and the census of `X`-lines through each χ-vertex
(the contracted locus; `L₂, L₃` are already known members).

**The γ-criterion (proved).** `Δ_v ≡ (cyz)²` modulo `Q₁`, so a
pullback `h*Δ_v` is a perfect square iff the square root has the form
`g = cYZ − 2Lγ`, which unwinds to: **`h` lifts to `X` iff there is a
form `γ` (of character `χ₁`) with**

```
    Q₂(A,B)Y² + Q₃(A,B)Z² + C(A,B)  =  γ·( c·YZ − Q₁(A,B)·γ ) .
```

**Honest scope (recorded so nobody over-reads 5.18-B).** Pointwise,
substituting the parity shapes (`A = xyz·Ã(t,v,w)` etc.,
`γ = x·γ̃`, `(t,v,w) = (x²,y²,z²)`) turns this into the SINGLE
degree-`3s` identity in the invariant variables

```
  Q₂(Ã,B̃)vỸ² + Q₃(Ã,B̃)wZ̃² + tvw·C(Ã,B̃) + t·Q₁(Ã,B̃)γ̃²
      − c·γ̃ỸZ̃ = 0 ,
```

which is `F(T) ≡ 0` verbatim under `u₀′ = xγ̃` — the projection is a
REWRITING at the pointwise level, not new content. Its genuine
value: (a) COMPUTATIONAL — the 52-equation slot systems collapse to
one identity in three invariant variables with unknown degrees
`(s−1, s−1, s, s, s)`; (C3)-type runs should use this presentation;
(b) **FAMILY-LEVEL MONODROMY (new content, proved):** for a FAMILY of
pointwise elements over a base curve, the sheet datum is a 2-torsion
(square-root) choice; over `ℓ_V ≅ P¹` double covers are classified by
finite branch-parity data, so **the lifting data of any `P¹`-family is
FINITE, and family moduli = (free `h`-family moduli) × (finite
2-torsion data) intersected with the fiberwise γ-criterion.** This is
the discrete stratification the parity-count route runs on; the core
finiteness still requires the tail/vertex-jet analysis of 5.18-A —
(T1a) remains the one open theorem, now attackable in the smallest
coordinates it has ever had.

### 5.20 The conic-bundle reformulation, the factored discriminant, and (T1a) split into parity + height

**Theorem 5.20 (proved).** Project instead from the LINE `L₁ ⊂ X`
(V4-stable): `π_{L₁}: X ⇢ P² = P(a,b,x)` is the classical conic
bundle, V4-equivariantly. Then:

**(a) The landing identity is QUADRATIC in the minus data.** In the
invariant presentation, `E` reads `q_φ(Ỹ, Z̃) = m_φ` with

```
  q_φ = [[ v·Q₂(Ã,B̃), −c·γ̃/2 ], [ −c·γ̃/2, w·Q₃(Ã,B̃) ]] ,
  m_φ = −t·( vw·C(Ã,B̃) + Q₁(Ã,B̃)·γ̃² ) ,
```

where `φ = (yzÃ : yzB̃ : γ̃)` is the composed V4-map
`π_{L₁} ∘ T : P² ⇢ P²` (the plus-part of the tuple). A pointwise
element = a base map `φ` together with a SECTION of the pulled-back
conic bundle of the prescribed degree.

**(b) The discriminant FACTORS, and one factor is the arrangement's
elliptic curve.** Parameterizing the plane `⟨L₁, (a:b:x)⟩` by
`(μ; y, z)`: `F = μ·[ F₀(a,b,x)·μ² + Q₂y² + Q₃z² + c·x·yz ]` exactly
(the `μ`-factor is `L₁ ⊂ X`), so the residual conic has Gram
`diag(F₀) ⊕ [[Q₂, cx/2],[cx/2, Q₃]]` and the discriminant curve of
the conic bundle is

```
    Δ₅  =  F₀(a,b,x) · ( 4·Q₂(a,b)·Q₃(a,b) − c²x² )   —   REDUCIBLE:
    Δ₅  =  E_{σ₁}  ∪  (a V4-conic) ,
```

since `F₀ = F|_{P_{σ₁}}` cuts exactly `E_{σ₁} = X ∩ P_{σ₁}`. For a
GENERIC cubic threefold the quintic discriminant is irreducible; the
V4-symmetric line splits it, and **the arrangement's elliptic curve
IS a discriminant component of the classical conic-bundle
structure** — the FIX geometry and the Clemens–Griffiths geometry are
one object. ∎ (Derivation exact by inspection of the displayed
`μ`-factorization; a CAS re-check rides along with (C5).)

**(c) (T1a) splits into a parity half and a height half.**
- **Parity half:** `φ` admits ANY section over the function field iff
  the conic `q_φ = m_φ` is solvable over `k(P²)` iff the 2-torsion
  Brauer class `φ*β` vanishes, where `β` is ramified along the TWO
  components of `Δ₅`. Residues decompose along `φ*(E_{σ₁})` and
  `φ*(conic)`: a DISCRETE, degree-uniform parity condition —
  provable by residue calculus against the factored discriminant.
  Named derivation **(D1)**; mechanical, near-term.
- **Height half:** on the parity-admissible locus, the sections of
  the prescribed polynomial degree `s` must be finite mod torus.
  Because the discriminant contains the ELLIPTIC component, the
  associated 2-cover geometry is elliptic, and the section spaces
  land in the arena of **function-field Mordell–Weil / Lang–Néron
  finite generation** — the first time (T1a)'s finiteness has a
  classical finiteness THEOREM to run on rather than a counting
  heuristic. Named derivation **(D2)**: set up the Lang–Néron
  application (the trace/torus quotient is exactly the mod-torus
  statement) and extract the degree-`s` bound. This is the last
  substantive analytic step of the negative program.

**Status after this section.** (T1a) = (D1) + (D2); NOT closed here,
and stated so. Everything upstream of it is proved or named-finite;
(D1) is residue bookkeeping; (D2) is real mathematics with the right
classical tool now identified and the object (the elliptic
discriminant component) already sitting inside the verified
arrangement.

### 5.21 (D1) CLOSED: the Brauer-parity criterion (proved)

**The class.** Diagonalizing the residual conic
`⟨F₀⟩ ⊕ [[Q₂, cx/2],[cx/2, Q₃]]` and discarding split factors
`(u, −u)`:

```
    β  =  ( −F₀·Q₂ ,  Δ_c )  ∈  Br(k(a,b,x))[2] ,
    Δ_c := 4Q₂Q₃ − c²x² .
```

Tame-symbol residues: along `E = {F₀ = 0}` the residue is
`[Δ_c|_E] ∈ k(E)*/2` — the class of the double cover `Ẽ → E`
branched on `E ∩ K_c`; along `K_c = {Δ_c = 0}` it is `[F₀·Q₂|_{K_c}]`;
along `{Q₂ = 0}` the potential residue is `Δ_c|_{Q₂=0} = −(cx)²` —
a square over `C` — so `{Q₂ = 0}` carries NO ramification (as it
must: it is not in `Δ₅`). Moreover on the conic side,
`K_c ∩ {Q₂ = 0}` is the single point `{Q₂ = 0, x = 0}` with EVEN
multiplicity (`Δ_c|_{Q₂=0} = −c²x²` vanishes doubly), so the
`Q₂`-factor contributes evenly and **both residue classes are
controlled by the same six-point divisor `E ∩ K_c`** (`Ẽ`'s branch
points; and `F₀|_{K_c}`'s odd part). Whether those six points are
distinct or collapse into tangencies is exactly the singular-locus
geometry (C5) is computing — either answer feeds the criterion, and
neither changes its shape.

**Well-definedness across the source lines (proved).** For our maps,
`φ = (A : B : u₀′) = (xyzÃ : xyzB̃ : xγ̃) = (yzÃ : yzB̃ : γ̃)`:
the common `x` cancels, so `φ` EXTENDS across the source lines
(generically) — the feared indeterminacy bookkeeping over the
boundary largely evaporates, and `φ(source line)` is an honest curve
in the base.

**Theorem 5.21 ((D1), proved).** Let `φ : P² ⇢ P²` be any rational
map (in particular our V4-maps). Then the pulled-back class
`φ*β ∈ Br(k(P²))[2]` vanishes if and only if, on a resolution of
`φ`, for every irreducible curve `D`:

1. `D` dominating a component of `φ⁻¹(E)`: the induced `D → E` lifts
   to the double cover `Ẽ → E` (equivalently
   `(φ|_D)*[Δ_c|_E] = 1 ∈ k(D)*/2`);
2. `D` dominating a component of `φ⁻¹(K_c)`: `(φ|_D)*[F₀·Q₂|_{K_c}]
   = 1` — for RATIONAL `D` this is pure intersection parity: every
   point of `D` meets the pulled-back six-point divisor with EVEN
   multiplicity (over `C`, a function on `P¹` is a square iff its
   divisor is even);
3. all other curves (including exceptional ones): no condition, by
   the residue computations above and `(u, −u) = 1`.

*Proof.* Over `C`, `Br` of a rational surface is trivial and the
Faddeev residue sequence is exact: a 2-torsion class over `k(P²)`
vanishes iff all its tame residues vanish. The residues of
`(φ*(−F₀Q₂), φ*Δ_c)` along any `D` are the pullbacks of `β`'s
residues when `D` dominates a discriminant preimage, and otherwise
involve only the split corner classes computed above (the `−(cx)²`
square; components inside intersections are handled on the
resolution by the same two computations, since every branch through
a corner carries one of the two residue classes composed with a
square). Conditions 1–2 are exactly residue-vanishing; 3 is their
absence. ∎

**What (D1) delivers to the program.** Admissibility of `φ` — the
existence of ANY function-field section — is now a finite list of
DISCRETE conditions: lifting to one fixed elliptic double cover along
the `E`-components, and even tangency against one fixed six-point
divisor along the `K_c`-components. Both are degree-uniform (they are
per-component conditions of bounded type, not per-degree systems).
The stratification of the free mapping space that (D2)'s height
argument runs on is therefore PROVED discrete and finite-type.
Remaining inside (T1a): only (D2). The six-point geometry
(distinct vs tangent; the 2-torsion datum if tangent) rides in with
(C5).

### 5.22 FIN(7) integrated: Correction IV-c, the death of the constancy route, and the surviving structure

**FIN(7) verdict (director-replayed, 104/104):**
`FIX-U1-FIN7-NOT-FINITE-MOD-TORUS-DIM-GE-15`. `PO₁(7)` contains three
LINEAR components of projective dimension exactly 17 (≥ 15 mod torus)
— the maps whose image lies in one of the three V4-stable lines
`L_σ ⊂ X` (plus-part ≡ 0; landing automatic since `L ⊂ X`). At the 27
Chebyshev witnesses: essential tangent dimension 2 at parts B/C/D
(corank 5 − 3 torus/scalar), bracket `[0,2]` certified with `= 2`
evidenced (`Ob₂ ≡ 0` exactly, `Ob₃ ≡ 0` symbolically, random rays
lift to order 10–26); at part A essential ≤ 2 after the Kuranishi
cut. `u₀ + v₀ ≠ 0` at all 27 points (exact, Nullstellensatz) — the
§5.3 parameter check DISCHARGED; `u₀ − v₀ ≠ 0` reconfirms
`FIX-H1-EQ-M1-EMPTY` independently.

**Consequences, honestly drawn:**
- **The constancy route (Prop 5.3) is DEAD at `r = 7`** — the locus
  is nowhere near orbit-finite. [U1] for the row goes through the
  conic-bundle/Brauer machinery of §§5.20–5.21 (unaffected by this
  verdict: the linear components are the `φ`-degenerate stratum,
  where `φ ≡ (0:0:0)` fails to be defined — they need their own
  DIRECT jet analysis, which is LINEAR and exact; named **(D3)**,
  small: the equalizer/H1-1 analysis of image-in-line leading data,
  a finite computation on a linear family).
- **Correction IV-c (the recurring error class, third instance).**
  §5.9(b) is WRONG for `m ≥ 1`: `x^r` in any slot has `(y,z)`-order
  0 < m, so the source vertices are BASE POINTS of the map, not
  points mapping to χ-vertices (the χ-vertex-anchor story transfers
  to the exceptional data of the vertex blowup). Same mistake-class
  as the `r = 8` type-II anchor and the torus omission: SUPPORT
  BOUNDS FROM PLANE ORDER, forgotten at the moment of geometric
  interpretation. §5.9(a)/(c) hold verbatim (worker-verified).
  Downstream: §5.18's DISPLAYED top-tail equations assumed
  `P0 = u₀'_{x^r} ≠ 0` and are m-naive; for `m = 1` the top tail
  levels are vacuous by support and the first live tail level sits
  lower — the STRUCTURAL theorem 5.18-A (tail = vertex-jet/base-point
  conditions) survives, its explicit equations to be re-derived with
  corrected supports (owed).
- **N2C refinement:** the nine-point scheme is SINGULAR at part A
  (own-block corank 2); its `dim 0, degree 9` was a linear-slice
  statement — consistent with C1's kernel jump, now sharper.
- **Banked for [U2]:** the worker's exact identity `F(T) = xyz·G`,
  `G = U₀U₁U₂ + r₀XU₀² + r₁YU₁² + r₂ZU₂² + cXYZ` in
  `(X,Y,Z) = (x²,y²,z²)`, and the completing-the-square normal form
  `4r₀X·G = W² − Δ` — converging with §5.19's presentation and
  putting the non-degenerate stratum in the form "an explicit
  degree-14 form is a perfect square in 30 unknowns" at `r = 7`
  (the concrete (C3)-object).
- **Honest gap:** no upper bound on `dim PO₁(7)` was certified
  (slice computations timed out) — components through neither the
  witnesses nor the linear families are not excluded; they are,
  however, subject to the same §5.21 criterion, which is
  component-agnostic.

### 5.23 (D2) resolved by boundary rigidity: the interior moduli are invisible to the equalizer

The height half was set up as a finiteness problem (Lang–Néron on the
section moduli). It dissolves instead: **the equalizer never sees the
section moduli at all.**

**Theorem 5.23 (boundary rigidity — proved).**
**(i) The line data is a branch choice, not a modulus.** The
inhomogeneity `m_φ = −t·(vw·C + Q₁γ̃²)` VANISHES on each source line
(`t = x² = 0`; symmetrically per line in each line-adapted
presentation). Hence on a source line the section satisfies
`q_φ(Y, Z)|_line = 0`: its boundary value is an ISOTROPIC vector of
the binary form `q_φ|_line` — one of TWO discrete root-branches. The
line-map `(P, Q)` is therefore a discrete function of `φ|_line`
(coefficients `vQ₂(Ã,B̃), cγ̃, wQ₃` restricted to the line) together
with a branch bit — `(P:Q) = [2·root of q_φ|_line]`, explicitly
`(cγ̃ ± √Δ_q)/(2vQ₂)`-type with `Δ_q = c²γ̃² − 4vw·Q₂Q₃(Ã,B̃)`.
**(ii) Section deformations fix the boundary.** A tangent vector to
the section space at `ζ = Y + θZ` has the form `ζ′ = ζ·ρ·√Δ_q/m_φ`
(anti-invariant multiplier). Since `m_φ` vanishes on the lines while
`ζ′` must remain polynomial, `ζ′|_line` is forced into the isotropic
direction already occupied: deformations move the INTERIOR of the
section and cannot change the line data or its jets (generic
statement; the strata where `ζ|_line` degenerates — zeros of `P, Q` at
special points — belong to the vertex/degeneration bookkeeping
(T1c)).
**(iii) Consequently:** the leading-layer jets at the D12-points —
the ONLY data the equalizer (P4) consumes — depend on nothing but
`φ`'s boundary jets and the branch bit. FIN(7)'s essential moduli,
the Pell/unit structure of the section torsor, and any unbounded
components of the pointwise locus are ALL invisible to [U1]: no
global finiteness statement is needed. Lang–Néron exits the program.
**(iv) (D2) reduces to a finite boundary-jet computation.** [U1]
becomes: over the §5.21-admissible `φ`-boundary space, the equalizer
conditions (orders `2e, 2e+1` at the three D12-points) on the
branch-root jets force vanishing. The root's jets are algebraic in
`φ`'s jets through `√Δ_q`, so **the equalizer death is a parity/jet
condition on `Δ_q(φ)` at the D12-points — the same
branch-divisor-parity calculus as (D1)**, now at three marked points
of the line. This is finite-dimensional, uniform in degree
(conditions at fixed orders at three points), and is named
**(C6)/(D2′)**: the explicit branch-root-jet equalizer computation.
∎ (i)–(iii); (iv) is the reduction statement.

**Program consequence.** The closure chain's [U1] is now:
(D1 — CLOSED) + (D2′ — the finite boundary-jet computation) +
(D3 — the linear image-in-line components) + (T1c strata). The last
conceptual obstacle in (T1a) is gone; everything remaining is finite,
explicit, and named.

### 5.24 Correction IV-d, the product pinning, (D3) closed, and the TERMINAL SYSTEM

**Correction IV-d (fourth self-caught; conceptual).** 5.23(iii)
overclaimed: the equalizer consumes the fibers' VERTEX-side data
(`Λ(λ) = diag(β₁, β₂)` with `β_i` = the `x^{r−1}y/z`-coefficients =
the section evaluated at the fiber vertex `(t:v:w) = (1:0:0)`), NOT
the source-line data whose rigidity (i)–(ii) proved. The line-data
rigidity stands but is not the consumed boundary; interior moduli CAN
reach the vertex values. What replaces the overclaim is stronger:

**Theorem 5.24-A (the product pinning — proved).** Evaluating the
conic identity at the fiber vertex (where `vQ₂, wQ₃ → 0`):
`c·Ỹ₀Z̃₀ = Q₁(Ã₀,B̃₀)·γ̃₀`, i.e. **the PRODUCT `β₁β₂ = u·v` of the
equalizer entries is pinned to an explicit plus-side (Θ) function
`g(λ)` along `ℓ_V`** (`= Q₁γ̃/c` at the vertex; if `γ̃₀ = 0` the
pinning reads `Ỹ₀Z̃₀ = 0` — still a pinning). Only the RATIO
`β₁/β₂` is an interior modulus. ∎ (This is IV-b's second-fundamental-
form equation reborn at the right boundary.)

**Theorem 5.24-B (square-root structure of equalizer-passing jets —
proved).** With `u_{2e} = v_{2e} = w` (the order-0 equalizer for
`m = 1`) and `u, v` vanishing to order `≥ 2e` at `p_i`:
`(uv)_{4e} = u_{2e}v_{2e} = w²`, so `w² = g_{4e}(p_i)`: **the
equalizer-passing jets are square roots of the Θ-side function's
jets.** The nonvanishing branch (`w ≠ 0`) therefore requires
`g`'s `4e`-jet ≠ 0 at the D12-points — the buck passes entirely to
the plus-side jets at `c_σ`, exactly where the I₀/I₁ machinery
(§§5.7–5.8, FIX-L1 constants) lives: **[U1] and [L] merge into one
coupled jet problem at `c_σ`.** ∎

**Theorem 5.24-C ((D3) closed — proved).** On the image-in-line
components the plus-part is IDENTICALLY zero, so `g ≡ 0`, so
`w² = 0`, so `w = 0`: **the equalizer-passing jets vanish on all
three linear components, in every degree.** ∎ (One line, from the
product pinning.)

**The TERMINAL SYSTEM (D2″).** The nonvanishing branch (`w ≠ 0`) of
[U1] survives iff the following finite jet system at `c_σ` is
solvable: (a) `λ_{2e} = w·id`, `w² = g_{4e}(c_σ)` (5.24-B);
(b) H1-1's order-1 condition `u_{2e+1} + v_{2e+1} = 0`; (c) the
I₀-identity's leading jet: `w²·[α·θ_t·κ_t + β·⟨θ_s, κ_s⟩] = 0` with
`(κ_t, κ_s)` the isotypic components of `id⊗id` (FIX-L1's constants:
`α = 12c ≠ 0`, `β = 1`; the bracket's nondegeneracy is L1-checkable),
forcing `w = 0` or `θ` onto the transfer subspace; (d) `g`'s jet
re-expressed in the SAME `θ`-variables (`g = Q₁γ̃/c` is quadratic in
the plus-data), closing the loop; (e) I₁ binding one order deeper.
Deciding this system — finitely many jet variables, all constants
banked — is **(D2″): ONE exact finite computation.** If inconsistent
for `w ≠ 0`: [U1] holds and every germ enters the `w = 0` evasion
channel, killed by [L] (= Thm 5.15's budget + (C2) discharged +
(C2′)).

**Supersessions (recorded with justification).** The terminal-system
route is COMPONENT-AGNOSTIC: it uses only the germ structure
(P2)–(P4), the vertex conic relation (from `F`'s invariant shape,
always valid), I₀/I₁, and the L1 constants — never the pointwise
classification. Consequently **(T1b) (conic floor), (T1c) (endpoint
dictionary), and (C3) (tail resultant) RETIRE as superseded**: they
belonged to the abandoned finiteness route. Degenerate vertex cases
(`γ̃₀ = 0` at special `λ`) are inside 5.24-A's pinning and the jet
bookkeeping, not separate strata.

**The complete remaining ledger for the negative headline:**
**(D2″)** the terminal system (one finite exact computation, all
inputs banked) and **(C2′)** the rung-independence check (one finite
linear-algebra computation) — then assembly of Theorem 3.1 and the
full independent audit. Nothing else remains anywhere in the
program.
