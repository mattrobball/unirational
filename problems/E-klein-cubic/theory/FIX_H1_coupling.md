# FIX H1 — The cross-V4 coupling localized at the D12-points

Program FIX ([E56]). Depends on [I], [II], [III] and the FIX-H0 packet
(Theorems H0-1, H0-2). DRAFT-FOR-DERIVATION. This note formulates the one
remaining constraint of the global problem and proves that, in the
large-degree regime, it localizes to a **finite S3-equivariant equalizer
at the 55 D12-points** — dissolving the no-degree-bound obstacle.

## 1. The σ-frame geometry (all facts packet-verified)

Fix an involution σ. Inside the plus-plane `P_σ = P(W⁺_σ) ≅ P²`:

- The three V4's containing σ contribute their triple lines
  `ℓ_{V,1}, ℓ_{V,2}, ℓ_{V,3} ⊂ P_σ` (since `W^{K_i} ⊂ W^{σ}`); these are
  the pairwise intersections `P_σ ∩ P_τ` of commuting planes (FIX-A0).
- **The three lines are concurrent at the D12-point**
  `c_σ = [triv] = Fix(S3, P_σ)`: their pairwise intersections are fixed by
  groups generating `D12`, whose unique fixed point in `P_σ` is `c_σ` —
  consistent with the verified arrangement data ("each D12-point lies on
  exactly 3 V4-lines", FIX-A0; "each `ℓ_V` carries exactly 3 D12-points",
  FIX-A1 — one per involution of its V4).
- The tangent space `T_{c_σ}P_σ = Hom(triv, std) = std` as an
  `S3`-representation, and each `ℓ_{V,i}` is stabilized by the residual
  transposition `t_i`: **the three triple lines are the three mirror lines
  of the standard S3-plane at `c_σ`**, cyclically rotated by `C3` and
  generating `S3` (FIX-H0's certified transposition data).
- `E_σ = X ∩ P_σ` (elliptic) and the type-II points (`= ℓ_{V,i} ∩ X`, three
  per line) also live here; `c_σ ∉ X`.

**Corollary 1.1 (forced base locus).** By H0-1, along `P_σ` both halves of
the germ vanish (`ord T⁻ = m ≥ 1` odd, `ord T⁺ ≥ m+1`), so **every
hypothetical map contains all 55 plus-planes in its base locus**; the
map's σ-local content is carried by the exceptional divisor
`D_σ = P_σ × P(W⁻_σ)` via the leading minus-term, which surjects onto
`L_σ` (H0-2).

## 2. The coupling as an equivariant interpolation problem on `P_σ`

The leading package along `P_σ` is the collection
`c_α ∈ H⁰(P_σ, O(d−m)) ⊗ W⁻` (`|α| = m`), `S3`-equivariant with the
σ-parity built in, plus the higher-order tail demanded by the working
order; the landing condition couples it to the even half order by order
(the ladder differential of [II]). The Note-II cell germ chosen for each
V4 (a stalk branch datum along `ℓ_{V,i}`) prescribes exactly the
restriction of this package to an infinitesimal thickening of `ℓ_{V,i}`,
in the `K_i`-frame. Hence:

**The cross-V4 coupling at σ** = existence of one `S3`-equivariant package
on `P_σ` (to the working order) restricting on the three thickened mirror
lines to the three transposition-twisted copies of the chosen branch germ,
compatible with landing and with dominance onto `L_σ`.

## 3. Localization at the D12-point

**Theorem 3.1 (large-`d` localization).** Fix a branch and a working order
`N`. For all sufficiently large `d`: the coupling at σ is solvable if and
only if the three mirror-line germ prescriptions admit a common
`S3`-equivariant jet at the concurrency point `c_σ` to order `N` (the
**S3-equalizer condition**), together with the branch-internal conditions
already classified in [II].

*Proof sketch (to be executed at full rigor in the packet's certificate):*
the prescriptions live on the closed subscheme `Z_N` = union of the three
`N`-thickened lines; the obstruction to extending a section of a coherent
sheaf from `Z_N` to `P²` in degree `d` dies for `d ≫ 0`
(`H¹(P², I_{Z_N}(d)) = 0` by Serre vanishing), and the restriction map to
`Z_N` is then surjective; `S3`-equivariance is preserved by Reynolds
averaging (char 0). The only non-free matching among the three lines is
along their scheme-theoretic pairwise intersections, which are supported
at the single point `c_σ`: the equalizer at `c_σ` is exactly the fibre
condition. Dominance onto `L_σ` is open and generic in the extension for
`d` large once the branch germ is nonconstant in the minus-direction —
which H0-2 already forces and every surviving branch satisfies. ∎

**Consequence.** The no-degree-bound problem dissolves: an equalizer
**failure at finite order kills the branch for every degree `d`**
(any map would supply the jet), unconditionally; equalizer success at all
computed orders yields candidate data (extension exists for large `d`),
with the usual §[III].3 semantics — candidates only, no map claimed.

## 4. The computation (packet FIX-H1)

For each surviving branch — the `(3,·)` `D_B`-family and the
`(1, odd r ≥ 7)` primitive Chebyshev branch, both uniformized on the one
trace curve (FIX-H0 task D) — transport the cell germ to the `c_σ`-frame:
`c_σ` is one of the three (exactly known) D12-points on `ℓ_V`, the germ's
binary parameter localizes there, and the three mirror copies are twisted
by the three transpositions. Decide the `S3`-equalizer at `c_σ` exactly,
order by order from the branches' leading orders up to the discriminating
order; report per branch:

- `EMPTY at order N₀` ⇒ that branch admits **no** global section —
  unconditional (kills all degrees at once);
- `NONEMPTY through order N` with the solution locus (on the trace curve).

If both branches die: combined with H0-1/H0-2 this closes every
*classified* stalk component, and the negative headline follows **modulo
the two remaining odd-row holes** — see the correction below.

## 5. Correction to the FIX-H0 integration (director, 2026-08-06)

The 08-05 notebook line "the `m = 1` classification holes cease to gate
anything" **overclaimed**. Correct statement: H0-1 excludes the *even-`m`*
row robustly, and the H0 theorems themselves do not depend on the holes;
but the two open odd-row cells — `(1,6)` above line degree 2, and
`(1, even r ≥ 8)` — have `m = 1` **odd** and therefore still gate a
final negative verdict (they could harbor additional surviving branches).
They do not affect a candidate (nonempty) outcome. The negative endgame
therefore requires: equalizer death of both known branches **plus**
closure of these two cells (assigned to the FIX-H1 packet as a secondary
task, attackable with the FIX-N2c machinery now that the msolve landmine
is documented).
