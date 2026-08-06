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
