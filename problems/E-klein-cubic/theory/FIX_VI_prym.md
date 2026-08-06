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

## 2.5 The genus-2 factor splits with CM by Q(√−11) (director probes, 2026-08-06; exact at the final step)

Computed in the explicit normal form
`F = κ₊a³ + κ₋b³ + (a+b)x² + (ωa+ω²b)y² + (ω²a+ωb)z² + xyz`:

- The conic is `x² = 4(a²−ab+b²)`, and the branch locus of `K̃`
  restricts EXACTLY: `F₀|_{K_c} = (κ₊+4)a³ + (κ₋+4)b³` (the identity
  `(a+b)(a²−ab+b²) = a³+b³` does it), with
  `(κ₊+4)(κ₋+4) = 22 = 2·11` from the sealed trace relations — the
  six branch points are three antipodal pairs on the conic.
- The conic involution in the parameterizing coordinate is
  `τ(t) = (−t−4)/(t+1)`; conjugated to `s ↦ −s` the branch sextic is
  EXACTLY even (all odd coefficients vanish symbolically), so `K̃` is
  bielliptic and `J(K̃) ~ E₊ × E₋`.
- **`j(E₊) = j(E₋) = −32768 = −2¹⁵ EXACTLY, both symbolically over
  the exact field** (probes `prym_exact.py`, `prym_exact2.py`; the
  `E₋` model is the quartic `v² = u·c(u)`): **both quotients are the
  elliptic curve with complex multiplication by `Q(√−11)`** — the
  same field that defines the Weil representation. Hence, modulo
  the standard bielliptic bookkeeping to be machine-sealed:

```
    J(X)  ~  Prym₃(Ẽ/E_σ)  ×  E_{−11}  ×  E_{−11}     (per involution).
```

## 2.6 Literature anchor (Roulleau, Adler) — and what is new here

Roulleau, "The Fano surface of the Klein cubic threefold"
(arXiv:1001.4853; J. Math. Kyoto Univ. 49 (2009) 113–129; PDF
archived at `external_docs/roulleau_fano_klein_cubic_arxiv1001.4853.pdf`):
with `ν = (−1+i√11)/2` and `E := C/Z[ν]` (this IS the `j = −32768`
CM curve), his Theorem 2 computes the period lattice of `J(X)` as an
explicit `Z[ν]`-lattice `Λ` of rank 5 (two summands scaled by
`1/(1+2ν) = 1/i√11`, three free), with `NS` of the Fano surface of
maximal rank `25 = h^{1,1}` and discriminant `11¹⁰`; and he remarks
`J(X) ≅ E⁵` as abelian varieties (NOT as ppav's), first proved by
Adler, "On the automorphism group of certain hypersurfaces",
J. Algebra 72 (1981) 146–165. Beauville's "Les singularités du
diviseur Θ…" (LNM 947) is the admissible-cover/Prym mechanism §2
uses.

Consequences and placement of our result:

- **Consistency/validation.** Our exact `j = −32768` on both
  quotients re-derives two of Adler–Roulleau's five CM factors by a
  completely different route (degeneration of the Clemens–Griffiths
  conic-bundle Prym, not the Fano surface). Hitting the CM(−11)
  invariant twice, exactly, is a strong end-to-end check of the whole
  Note VI construction (normal form → split discriminant → cover
  bookkeeping).
- **`Prym₃ ~ E_{−11}³` is now FORCED**, no computation needed: by
  `J(X) ≅ E⁵` and Poincaré reducibility, every 3-dimensional isogeny
  factor of `J(X)` is `~ E³`. (Corollary: the genus-4 curve `Ẽ` has
  `J(Ẽ) ~ E_σ × E_{−11}³` — the non-CM arrangement elliptic
  `j = 8192/11` rides with a CM cube.)
- **What is new relative to the literature:** (i) the geometric
  LOCALIZATION — the CM factors appear on the conic component of the
  SPLIT discriminant `Δ₅ = E_σ ∪ K_c`, a degeneration generic cubics
  do not have; (ii) the 55 D12-covariant such splittings permuted by
  `G`; (iii) the equivariant upgrade: `H₁(J(X), Q) ≅ W` as a
  `G`-representation over `Q(√−11)` — i.e. `Λ` is a rank-5
  `Z[ν][G]`-lattice realizing the Weil representation over its own
  character field, and `J(X)` is the arithmetic avatar of `W`. The
  `O = Z[ν]`-multiplication commutes with `G`.

## 3. Next steps (in order)

1. ~~Pin the two curves exactly~~ DONE (§2.5–2.6): `K̃`-side fully
   pinned with CM identification; `Prym₃ ~ E³` forced by the
   literature anchor; `J(X) ~ E_{−11}⁵` in 55 D12-covariant ways.
2. Machine-verify §2's genus/branch arithmetic and §2.5's exact
   claims (restriction identity, evenness, both j-invariants) as a
   sealed packet with an independent verifier (the H1-D trust rule).
3. The twisted-torsor angle — NOW THE ACTIVE QUESTION: the headline
   is equivalent to a `K_proj`-point on the twisted cubic `V(Φ)`
   (sealed, E16/E37; by Kollár's cubic-hypersurface theorem, point ⟺
   unirational over the field, which is why the five-way reduction
   closes). The intermediate Jacobian of the twist is the
   `Gal`-twist of the Weil abelian fivefold `E_{−11}⁵` by a cocycle
   in `Aut(J, Θ) ⊇ ±G`; obstruction theory for points
   (Benoist–Wittenberg CH²-torsors, elementary obstruction, index —
   note a cubic threefold always has index | 3 via its lines) then
   lives in Galois cohomology of a CM abelian variety over
   `K_proj`, a C₄ field (trdeg 4 over C; Tsen–Lang would need
   `n ≥ 3⁴ = 81`, so no free points) — class number 1, everything
   in principle computable. First derivation pass (2026-08-06)
   spun off the unconditional geometric shadow of this circle as
   its own note: `FIX_VII_carrier.md` (the W-carrier condition).
   The elementary obstruction vanishes (`O(1)` is `K_proj`-rational
   since `V(Φ)` is given as a hypersurface), and `h²` makes
   `3·[T₁] = 0` for the BW degree-1 torsor, so any torsor-side
   obstruction to POINTS is 3-primary and finer than the classical
   layer — parked pending Note VII's development. Whether any such invariant can obstruct POINTS (not
   just rationality) over `K_proj` is the open question this
   investigation exists to answer.
