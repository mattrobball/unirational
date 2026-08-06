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

**Lemma 2.1 (q-tower jet invariance — proved here).** Multiplication by
`q = x² + y² + z²` maps the `(m, r)` cell to the `(m, r+2)` cell and
FIXES the leading line jet: `j(qT) = j(T)`. *Proof.* The
`(y,z)`-order-`m` part of `(qT)⁻` is `q · [(T⁻)_{(m)}]`; writing
`(T⁻)_{(m)} = x^e · Λ ⊕ (higher x-order)`, the `x²`-term of `q`
contributes `x^{e+2} Λ` while `(y²+z²)·(T⁻)_{(m)}` has `(y,z)`-order
`m + 2`; normalizing by `x^{e+2}` returns the same `Λ` along `ℓ_V`. ∎
Hence `J(m, r) ⊆ J(m, r+2)`: the reachable sets are increasing along
each parity class of `r`, and the genuinely new content at each `r` is
the primitive (non-`q`-divisible) part.

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
value at `c_σ` is forced onto an explicit hyperplane.** The condition
TRANSFERS rather than kills; `I₁` then binds the transferred constraint
against `Θ⁽¹⁾, Φ⁽¹⁾` — the genuine [L]-ladder, now with its first rung
in closed form. Bookkeeping owed: escape at order exactly `2e+2`, and
unequal line-wise orders; same method.

**Named computation FIX-L1** (proof-named, small): exact σ-frame values
of `α, β`; the generator `γ` of `V₁[sgn^{e+1}]` (both parities of `e`)
and of `V₃[sgn^{e+1}]`; the isotypic components `(γ⊗γ)_t, (γ⊗γ)_s`;
nondegeneracy of the transfer hyperplane
(`(α(γ⊗γ)_t, β(γ⊗γ)_s) ≠ (0,0)`); the analogous data at `m = 3`. Pure
frame constants; the [L] continuation consumes them.
