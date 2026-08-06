# FIX VI — The split-discriminant Prym (item-2 investigation)

Opened 2026-08-06. DRAFT-FOR-DERIVATION — hand-work of exactly the
class that produced this session's seven corrections; nothing below
is to be consumed until the curve computations are machine-checked.

## 1. Setup

Projection of `X` from the V4-stable line `L_σ` is a conic bundle over
`P² = P(a,b,x)` with discriminant `Δ₅ = E_σ ∪ K_c` (sealed, C5-era):
`E_σ = {F₀ = C + Q₁x² = 0}` the arrangement elliptic (j = 8192/11,
non-CM), `K_c = {4Q₂Q₃ = c²x²}` a conic, meeting in 6 points.
Classically `J(X) ≅ Prym(Δ̃₅/Δ₅)` for the admissible double cover
`Δ̃₅` (two lines of each degenerate fiber); blowing up the rational
line does not change `J`.

## 2. The decomposition (hand-derived; all consistency checks pass)

- `p_a(Δ₅) = 1 + 0 + 6 − 1 = 6`; Prym dimension `6 − 1 = 5 = dim J(X)` ✓.
- The restricted covers: `Ẽ → E_σ` is branched exactly at the six
  points `E ∩ K_c` (the residue class `[Δ_c|_E]` — the same object as
  Thm 5.21's (D1) residue), so `g(Ẽ) = 4`. `K̃ → K_c ≅ P¹` is
  branched exactly at the six points `F₀|_{K_c} = 0` (the `Q₂`-point
  contributes evenly — the (D1) computation again), so `g(K̃) = 2`.
- Gluing: one point of `Δ̃` over each node; `p_a(Δ̃₅) = 4 + 2 + 6 − 1
  = 11 = 2p_a(Δ₅) − 1` ✓ (admissible-cover arithmetic).
- The dual-graph norm is an isomorphism on toric parts, so the compact
  Prym is isogenous to the product of the component pieces:

```
    J(X)  ~  Prym(Ẽ/E_σ)  ×  J(K̃_σ)         (3-dim)  ×  (2-dim),
```

**one such splitting for EACH of the 55 involutions**, each only
`C_G(σ) = D12`-covariant; `G` permutes the 55 splittings. Since
`H³(X) = W ⊕ W̄` is a sum of two irreducible `G`-representations,
no single splitting is `G`-stable — consistent, and the joint
compatibility of all 55 splittings is a strong new rigidity on the
`G`-isogeny type of `J(X)`.

## 3. Next steps (in order)

1. **Pin the two curves exactly** (small computation, frame data all
   banked): the binary sextic cutting `K̃` (parameterize `K_c ≅ P¹`,
   restrict `F₀`) and the six branch points on `E_σ`. Then: does
   `J(K̃)` split (Igusa invariants / automorphisms — the D12-symmetry
   makes a split `J(K̃) ~ E′ × E″` plausible)? If it does, `J(X)` is
   isogenous to `Prym₃ × E′ × E″` in 55 ways — very rigid.
2. Machine-verify §2's genus/branch arithmetic on the actual frame
   (the same slice machinery as C5/P2).
3. The twisted-torsor angle: the problem is a `K_proj`-point on the
   twisted `V(Φ)`; over such fields the intermediate-Jacobian TORSOR
   (Benoist–Wittenberg-flavored) is the natural invariant, and the 55
   explicit Prym presentations give it coordinates. Whether it
   obstructs points (not just rationality) over `K_proj` is the open
   question this investigation exists to answer.
