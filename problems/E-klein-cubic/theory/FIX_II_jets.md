# FIX II — The jet ladder along fixed strata

Program FIX ([E56]). Note II of the series; depends on [I] (`FIX_I_bcomplex.md`)
and the gate note ([T], `FIX_T_gate.md`). DRAFT-FOR-DERIVATION discipline as
in [I]. Purpose: the decoration layer past first order — the abstract home of
the repo's hand-built computations (the `(3m+1)/2` V4-line bounds, Theorem
2.12 of the V4 packet, Fable's `I^(m)/I^(m+2)` corrections and its
`e ↦ 3Φ(p,p,e)` operator), and the instrument for the strata the T5 witness
does not populate.

## 1. Multi-order filtration at an incidence flag

**Setting.** Work at a stratum `R` of the source complex with normal bundle
`N = ⊕_{i=1}^{k} N_i` decomposed by characters `χ_i` of `H = H_R`, and with
`R` contained in the hyperplane-type strata `P_1, …, P_k` where
`T P_i ⊇ T R` and `P_i`'s normal directions are `⊕_{j ≠ i} N_j` (the
representative Klein case: `R = ℓ_V`, `k = 3`, `H = V₄`, `P_i` the three
plus-planes with ideals `(y,z), (x,z), (x,y)` in normal coordinates
`x, y, z` of characters `χ₁, χ₂, χ₃`; residual `C₃ = A₄/V₄` permuting
everything cyclically).

A **local landing family** along `R` is a tuple of formal/polynomial
sections (the `W`-coordinates of a would-be equivariant map, restricted to
the formal neighborhood of `R`), `H`-equivariant for the prescribed
coordinate characters, satisfying the landing identity `F(p) = 0` (or
`≡ 0` to the working level). Its **multi-order** is the vector
`(ord_R; ord_{P_1}, …, ord_{P_k})` of adic orders, componentwise.

**Lemma 2.1 (order cone).** For any monomial `x₁^{α₁}⋯x_k^{α_k}` in the
normal coordinates,

```
Σ_{i=1}^{k} ord_{P_i} = (k−1) · ord_R ,
```

since the exponent `α_j` contributes to `ord_{P_i}` for exactly the
`k−1` indices `i ≠ j`. Consequently, for any nonzero section:
`Σ_i ord_{P_i} ≤ (k−1)·ord_R`, and if the common plane order is `≥ m`
then

```
ord_R ≥ ⌈ k·m / (k−1) ⌉   —   for k = 3:  ord_R ≥ ⌈3m/2⌉ = (3m+1)/2  (m odd).
```

*Proof.* The displayed identity per monomial; orders of sums are minima;
the bound follows. ∎

This **derives the repo's `(3m+1)/2` V4-line bound** as pure incidence
combinatorics of the order cone — no representation theory yet.

**Lemma 2.2 (parity refinement).** With `k = 3` and `χ₁χ₂χ₃ = triv`
(the V4 case), the `H`-character of a normal monomial is determined by the
exponent parities: `char = χ₁^{α+γ} χ₂^{β+γ}`. Hence for a component of
prescribed character:

- `triv` (the `a', b'` components): `α ≡ β ≡ γ (mod 2)` — so either all
  even (then every `ord_{P_i}` is even) or all odd (then `ord_R ≡ 3 (mod 2)`
  and every `ord_{P_i}` is even ≥ 2);
- `χ_i` (the `u_i'` components): exponent pattern (odd on `x_i`-slot, evens)
  or (even, odds) — so `ord_{P_i}` is **always even** on the component's own
  plane and **odd** on the other two, or the complementary pattern.

Consequently the extremal lattice points of the order cone can be
character-forbidden for the required tuple; when they are, the minimal
`ord_R` at common plane order `m` (odd) rises from `(3m+1)/2` to
`(3m+3)/2`. This is the previously observed "type-II delay" — now a
two-line consequence of the parity table. ∎

## 2. The ladder and its differential

Let `Φ` be the symmetric trilinear polarization of the Klein cubic
(`F(v) = Φ(v,v,v)`). Filter a landing family by `ord_R` (refined by the
cone bigrading) and write `p = p_0 + p_1 + ⋯` in graded pieces. The
landing identity decomposes level-by-level:

```
level ℓ:   Σ_{a+b+c = ℓ} Φ(p_a, p_b, p_c) = 0 .
```

**Definition 3.1 (ladder).** Given a solution to all levels `< ℓ`, the
level-`ℓ` equation is

```
3Φ(p_0, p_0, p_ℓ)  =  −(known lower-order terms) ,
```

so the **ladder differential** is the `H`- (and residually
`W(H,R)`-) equivariant graded operator `D_{p_0}: e ↦ 3Φ(p_0, p_0, e)`, and
the level-`ℓ` **obstruction** is the class of the known terms in
`coker D_{p_0}` on that graded piece — a finite equivariant linear-algebra
computation once `p_0` (the "boundary data") is fixed.

**This is Fable's correction operator** `e ↦ 3Φ(p,p,e)` and its
`I^(m)/I^(m+2)` computations, now placed: they are the ladder at the
55-plane arrangement's symbolic filtration, for one particular choice of
`p_0`. "Changed boundary data" — the escape hatch left open when the Fable
branch closed — is in ladder terms just *another choice of initial graded
solution `p_0`*: the ladder makes the boundary-data space enumerable
instead of anecdotal (it is the variety of solutions of the bottom cell,
which §4's classification pins).

**Blowup functoriality (statement).** Pulling a family back along a blowup
of the calculus re-grades the ladder by an explicit affine map on the order
cone (exceptional order = total normal order plus center corrections; the
toric transformation of `(ord_R; ord_{P_i})`). In particular ladder
emptiness/population statements are b-statements once quantified over the
cone — the form in which they enter the cosheaf. Full transformation
formulas: to be recorded when first consumed (Note III); the `k = 3`
representative case is classical toric bookkeeping.

## 3. Validation instances (both pass)

- **`(3m+1)/2` and `(3m+3)/2`:** Lemmas 2.1–2.2 above; matches the
  session-derived bounds and the packet's usage.
- **Theorem 2.12 of the V4 packet** (`m = 1`, exact triple order 3, all
  line degrees: empty): in ladder terms this is the statement that the
  bottom cell `(m, r) = (1, 3)` has empty solution variety for every line
  degree along `R`. The packet's proof — the unique `K`-equivariant
  pointwise form, the `L_i`-system, the resultant `64(κ₊−κ₋)³ ≠ 0` — is
  exactly the cell's obstruction computation with the residual
  `C₃`-equivariance imposed; verified in-repo (packet replayed; the
  resultant identity independently re-derived in [T], §T5 note). Instance
  confirmed.

## 4. The local cell classification at the V4-stratum

The ladder organizes the local question into cells `(m, r)` (common plane
order, triple-line order), each with a solution variety (per line degree,
per boundary datum). Current status, consolidating everything known:

**Lemma 2.3 (specialisation lemma — FIX-N2's instrument, adopted).** The
`t`-adic graded pieces of an `A₄`-equivariant family at a `C₃`-fixed point
of the triple line are `C₃`-equivariant *pointwise* tuples, and the bottom
piece is nonzero and satisfies `F = 0`. Hence all-line-degree emptiness at
a fixed `(m, r)` is a finite computation on a space of roughly a third the
cell dimension. (The packet's `[p:q]`-constancy argument is the `r = 3`
case and does not generalize; this does.)

**Lemma 2.4 (propagation).** If cell `(m, r)` is empty with `r ≤ 2m`, then
`(m+2, r+3)` is empty (multiply by `xyz`: plane orders `+2`, line order
`+3`; the cone bound keeps the hypothesis meaningful).

**Cell table — status after FIX-N2 (2026-08-05, director-replayed):**

| cell | status | source |
|---|---|---|
| `m = 1`, `r ≤ 1` | forbidden by the cone | Lemma 2.1 |
| `m = 1`, `r = 2` | **EMPTY, all line degrees** (shape `(0,0,Ayz,Bzx,Cxy)`; landing = `ABC = 0`; residual `C₃` kills it) | FIX-N2 |
| `m = 1`, `r = 3` | **EMPTY, all line degrees** (re-proved; strengthened to the whole `m ≥ 1` stratum) | V4 packet Thm 2.12 + FIX-N2 |
| `m = 1`, `r = 4, 5` | **EMPTY, all line degrees** — new theorems | FIX-N2 (three independent engines) |
| `m = 1`, `r = 6` | no plane-order-1 cone point (`r = 6` cone classified exactly in char 0: the `D_B(yz)`- and `xyz·D_B(x)`-line branches, `λ = 1` dead by `κ ≠ −4`); line degrees 0, 1, 2 excluded; **OPEN above line degree 2** | FIX-N2b |
| `m = 1`, `r = 7, 8, 9` | **OPEN — and Lemma 2.3 provably cannot decide them** (the cones are nontrivial); `(1,7)` carries the **ALARM**: modular-only evidence of plane-order-1 cone points at `p = 100057`, unconfirmed, promotion forbidden by the ledger rule — decider FIX-N2c | FIX-N2b / FIX-N2c |
| **`m = 2`, whole row** | **DECIDED**: `(2, 3..5)` empty; **`(2, r)` populated for every `r ≥ 6`** (Thm N2B-3; new families `e₂·D_B(x)`, `Δ·D_B(x)`, …) | FIX-N2 + FIX-N2b |
| even `m`, bottom cell `(m, 3m/2)` | **EMPTY, all line degrees, every even `m`** | FIX-N2 |
| `m = 3`, `r = 5` (type-II delay) | **EMPTY, all line degrees** | FIX-N2 |
| `m = 3`, `r = 6` (first layer) | POPULATED | V4 packet §4 (re-verified; residual scalar `λ = ω²` now exhibited) |
| odd `m ≥ 3`, above first layer | **POPULATED** — witnesses `(3,8)` imprimitive, `(3,9)` primitive | FIX-N2 finding |

**Structural finding (why `m = 1` is the hard row).** The generalized §4
construction (any character-`χ₁` form `X` of degree `δ` with
`Y = ψX, Z = ψ²X`) yields `A₄`-equivariant families of order `3δ` at line
degree 0, and invariant multiplication moves `m` by even steps: reachable
plane orders are `{2k} ∪ {m₀ + 2k : m₀ ≥ 3}` — **never `m = 1`** (invariants
have even `ord_{P_i}`, Lemma 2.2). An `m = 1` family must therefore be
genuinely primitive, unreachable from seeds by invariant multiplication.
The `m = 1` row is empty through `r = 5` and pinned at `r = 6` through
line degree 2; whether it is empty for all `r` is the remaining local
question. FIX-N2b crystallized it as the **stabilization conjecture
`FIX-N2B-STABILISATION`**: every `A₄`-equivariant landing family is
`G·D_B(X)` (or its mirror) with `G` an `A₄`-invariant and `X` of character
`χ₁` — Theorem N2B-2 (char-0) shows this construction reaches all line
degrees, and since `ord_{P_i}(G)` is even and `m(D_B(X)) ∈ {0} ∪ [3, ∞)`,
the conjecture implies the entire `m = 1` row is EMPTY. Evidence: exact
match at `r ≤ 6`; predicted members verified at `r = 7, 8, 9`. Standing
against it: the `(1,7)` modular alarm (above). Negative results recorded
so they are not re-attempted: FIX-N2's proposed `(1,6)` ladder step is
false (the kernel meets every eigenblock in plane-order-1 vectors); the
corrected uniform criterion is vacuous at plane order 2 for even `r`
(parity: every `U,V,W`-monomial of `F(T)` has even plane order, so
`J₅ = J₆`). Either answer shapes Note III's stalks: conjecture proved ⇒
packet-§6 exclusion (i) closes outright; alarm confirmed ⇒ a genuinely
primitive `m = 1` branch exists that no invariant-multiplication
construction predicts.

Even with the `m = 1` row open above `r = 5`, the stalk picture is already
substantially known: the populated branches at even `m` (new) and odd
`m ≥ 3` (first layer and above) fiber over explicit parameter varieties;
Note III can proceed with the `m = 1, r ≥ 6` cells carried as an explicit
unknown flag.

## 5. What the ladder does *not* claim

Population of a cell is a local statement; by the T5 gate item, no
configuration of local statements decides the headline. The ladder's
product is the *stalk data* — the cosheaf `𝒯` of Note III has, at each
stratum of the target arrangement, the solution varieties classified here,
with the transition maps given by the calculus regrading and the residual
actions; the headline-relevant object is `H⁰` of that global structure,
which no cell computes.
