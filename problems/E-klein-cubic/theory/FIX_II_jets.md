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

| cell | status | source |
|---|---|---|
| `m = 1`, `r ≤ 2` | forbidden by the cone (Lemma 2.1: `r ≥ 2`) + parity (Lemma 2.2) — only `r = 2` all-even patterns survive the cone; character table kills the required tuple: **to be pinned exactly** | FIX-N2 item 1 |
| `m = 1`, `r = 3` exact | **EMPTY, all line degrees** | V4 packet Thm 2.12 |
| `m = 1`, `r ≥ 4` | **OPEN — the principal target** | FIX-N2 item 2 |
| odd `m ≥ 3`, first layer `(xyz)^{r−1}(J₃)₆` | **POPULATED** (line degree 6, `A₄`-equivariant) | V4 packet §4 = T5 witness |
| odd `m ≥ 3`, above the first layer | OPEN | FIX-N2 item 3 |
| even `m` | outside the packet's odd-normal scope; parity table (Lemma 2.2) heavily constrains — **to be classified** | FIX-N2 item 4 |

If FIX-N2 closes `m = 1, r ≥ 4` (an all-line-degree emptiness in the style
of 2.12) and settles the even-`m` and above-first-layer questions, the
stalk of the compatibility cosheaf at the V4-stratum becomes a **known
object**: every local landing family lives in the populated branch, whose
solution variety §3 of the packet already fibers over the genus-2
reciprocal cover. That is the input Note III needs.

## 5. What the ladder does *not* claim

Population of a cell is a local statement; by the T5 gate item, no
configuration of local statements decides the headline. The ladder's
product is the *stalk data* — the cosheaf `𝒯` of Note III has, at each
stratum of the target arrangement, the solution varieties classified here,
with the transition maps given by the calculus regrading and the residual
actions; the headline-relevant object is `H⁰` of that global structure,
which no cell computes.
