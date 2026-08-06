# FIX-VII-XRING — REPORT

**Exit: `FIX-VII-XRING-ALLGREEN`.** 71/71 checks PASS at p=397 and p2=1321
(`results/checks.log`, 0 FAIL). Every banked dimension and ideal bound
confirmed. One protocol correction, below.

## Stage 1 — the group
`g11 = diag(ζ,ζ⁹,ζ⁴,ζ³,ζ⁵)`, `s5: (σv)_i = v_{i+1}`, Weil involution `S`; all
three already have det 1 and orders 11/5/2. Projective **and linear** closure
both stop at exactly 660, profile `{1:1, 2:55, 3:110, 5:264, 6:110, 11:120}` =
PSL(2,11). Normalising `S²=I, det S=1` reaches the genuine order-660 linear
group at both primes.

**Protocol correction (only deviation).** The brief's `b = (1,2,4,3,5)`
("exponents mod ±") and its 8 relabelings contain **no** solution — I searched
all 120 permutations × 32 sign patterns × t=1..5. The working labeling is the
Weil **square-root** one, `b_i² ≡ e_i mod 11`, i.e. `b = (1,3,2,5,4)`: the
odd-function basis `δ_b−δ_{−b}` on F₁₁ where the unipotent acts by ζ^{b²}.
Recipe, both primes: `M_{jk} = s_j s_k(ζ^{t b_j b_k} − ζ^{−t b_j b_k})`, `t=1`,
`s=(1,1,−1,1,1)`, rescaled to `S²=I, det=1`. Exactly 5 labelings work (the
u-orbit of `b`), each for all t=1..5 — `payload/S_family_analysis.json`.

## Stages 2–3 — ladders, Hessian curve, TRUE ideal multiplicities
`I_C = sat(H, ∂H)`: dim 1, deg 20, HP 20i−25, 15 minimal quartics, HF 35,55,75,…,215.
Tables identical at both primes; `ideal = dim − restriction rank`.
```
d               1  2  3  4  5  6  7  8  9 10 11 12
map dim (W̄)     1  0  0  2  1  2  4  5  6 10 12 16   = banked
map ideal       0  0  0  0  0  2  2  4  5  8 11 14   = banked bound
polar dim (W)   0  1  0  1  2  2  4  5  6 10 12 15   = banked
polar ideal     0  0  0  1  1  1  3  3  5  8 10 14   = banked bound
trivial dim     0  0  1  0  1  2  1  2  3  3  4  6   (d=3..7 = banked 1,0,1,2,1)
```
**The bounds are tight at every d = 1..12, both types** — not only at d=3..6
where the HF argument forces it; restriction is surjective onto the equivariant
part throughout. `conjugate_convention` PASS: tr ρ(g11) = λ = (−1+√−11)/2,
tr ρ̄(g11) = λ̄.

## Stage 4 — generators and identities
`F̌` (d=3 trivial, contragredient action) has the **same pentagonal shape**
`y0²y1+y1²y2+y2²y3+y3²y4+y4²y0`. New degree-6 invariant, ±1 coefficients, same
at both primes:
`J₆ = Σ_cyc ( x_i⁴x_{i+2}x_{i+3} + x_i³x_{i+1}x_{i+4}² − x_i²x_{i+1}x_{i+2}²x_{i+3} )`.

* polar d=2 = ⟨∇F⟩; polar d=4 = ⟨∇H⟩; map d=1 = ⟨x⟩. map d=4 (mult 2) = ⟨F·x, ∇F̌∘∇F⟩ — `dual_polar_composition` PASS, independent.
* polar d=5 (mult 2) = ⟨F·∇F, ∇J₆⟩, identity `HessF·(∇F̌∘∇F) = 10·F·∇F + 2·∇J₆`.
  `HessF·∇H`, `HessH·∇F` are **not** covariants (index-type mismatch) —
  membership genuinely fails, as the brief anticipated.
* map d=6 (mult 2, both in I_C) = ⟨H·x, F̌″(∇F,∇H)⟩; `adj(HessF)·∇F` is not new:
  `adj(HessF)·∇F = ½·H·x` (adjugate + Euler). Echelonised pair
  (`payload/pair_d6.json`): `e₀ = (5·H·x − F̌″(∇F,∇H))/64`, `e₁ = (3·H·x −
  F̌″(∇F,∇H))/64`. Both vanish on C structurally: `H = 0` and `∇H = 0` on Sing(H).

## Stage 5 + verifier
p2 = 1321 reproduces Stages 1–3 with zero differences, and (extra) Stage 4 with
identical identity coefficients over ℚ. `verifier.py` re-derives by other methods
— 660×660 multiplication-table closure; all dims via the Molien/character
projector with h_d read off 1/det(1−tg); pointwise equivariance of the d=6 pair
against all 660 elements; vanishing on C via membership in the *unsaturated*
Jacobian ideal (H,∂H)₆ (dim 75) — all PASS. Payload index: `payload/SUMMARY.json`.
