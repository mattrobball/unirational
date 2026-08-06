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

## 5. Correction to the FIX-H0 integration (director, 2026-08-05)

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

## 6. Results (packet FIX-H1, landed 2026-08-05; director-replayed, 43/43)

Packet `goal_runs_after_541e12f/FIX_H1_EQUALIZER/`, primary exit
`FIX-H1-PARTIAL`. The equalizer of §3 was derived to full rigor as
**Theorem H1-1** (`payloads/PAYLOAD_theorem.txt`): with `e := r − m` and
`V := Hom(Sym^m W⁻, W⁻)`, the leading line datum
`Λ ∈ H⁰(ℓ_V, O(d−r)) ⊗ V` of any equivariant dominant map (a) vanishes to
order `≥ 2e` at each of the three D12-points (via `Φ = (N₁N₂N₃)^e·Ψ`, the
mirror cubic carrying `sgn`), whence the **unconditional degree bound
`d ≥ 7r − 6m`** and *no line-degree-0 cell element is the leading datum of
any global map*; (b) `λ_{2e} ∈ V[sgn^e]`, one-dimensional; (c) order-`k`
conditions only at `k = 0, 1` — the equalizer is vacuous from order 2 on.
The transposition part is automatic (`K₁`-equivariance); the whole content
is the residual 3-cycle `ρ` — the piece no `N_G(V4)`-computation sees.

- `FIX-H1-EQ-M3-EMPTY` — the `D_B` branch fails order 0: the equalizer
  line pins `B_eff = (−5+ν)/6`, `c₂/c₁ = −B_eff²`, forcing
  `B³+B⁻³ = (5−√33)/6` against the trace curve's `κ₊+2` (both roots, all
  four Galois twists; exact). **Scope-corrected by §7 below.**
- `FIX-H1-EQ-M1-EMPTY` — the primitive Chebyshev branch as classified
  fails order 0: `τ` forces `Λ` diagonal, `ρ`-commutation forces
  `Λ_yy = Λ_zz ⟺ B5 = λ·B8`, which fails at all 27 witnesses
  (Nullstellensatz certificates; M2 unit ideal in all three blocks;
  closed form `B5 = B8 ⟺ 4(κ₊+2)²+27 = 0`, blocked by the Klein identity
  `(κ₊+2)(κ₋+2) = 27/4` — the equalizer is the collision of the two
  character surfaces and the identity itself prevents it).
- **No per-V4 freedom**: one `G`-class ⇒ one `A₄`-fixed stalk element
  propagates to all 55 lines; the residual `C₃` permutes the three
  D12-points; mixed assignments impossible.
- `FIX-H1-D12-IS-THE-CHEBYSHEV-POINT` — `c_σ = [1:β]`,
  `β³+3β²+κ₊ = 0`, `β = −(1+c)`: the concurrency point *is* the Chebyshev
  point of the trace curve.
- Holes (secondary task): `FIX-H1-HOLE-1EVEN-PARTIAL` — `(1,8)` at line
  degree 0 is 282/288 leaves char-0 EMPTY (three engines, zero
  disagreements); sharp partial theorem: **any plane-order-1 point of the
  `r = 8` cone needs both `B6, B9 ≠ 0`**; six hard 11-var/22-gen leaves
  undecided (runs adopted live). `FIX-H1-HOLE-16-PARTIAL` — `(1,6)` line
  degrees 3, 4, 5 forced-zero **mod `p = 100057` only** (8640 runs, zero
  `CAN-BE-NONZERO`; mod-`p` emptiness does not lift; char-0 upgrade
  specified in packet §6b); `n = 6` live; `≥ 7` untouched; stabilisation
  in `n` not proved.

## 7. Director correction H1-C (scope of the M3 kill), 2026-08-05

Conditions (b)/(c) of Theorem H1-1 constrain the jets `λ_{2e}, λ_{2e+1}`
**inclusively of zero**. For the `(3,6)` family `D_B(f·yz)` the order-0
jet at the D12-point `p_i` is built from `f(p_{i−1})³, f(p_{i+1})³`; the
packet handled the pure-term degenerations (one value zero — off the
line, dead) but **not the all-three-points case**: if `n₃ | f`
(`n₃` = the binary cubic cutting the D12-orbit, the `β`-cubic of §6),
then `λ_{2e} = λ_{2e+1} = 0` at every D12-point and the leading-layer
equalizer is satisfied vacuously. Corrected verdict:

> the `(3,6)` `D_B` family fails the leading-layer equalizer at every
> line degree **except the `n₃`-divisible sub-family**
> `{f ∈ n₃·H⁰(O(3μ−3))}` (forced `d − r ≥ 6e + 9` there), which this
> packet does **not** decide; it joins the positive-line-degree unknowns
> and awaits the deeper-layer equalizer (the same §3 localization applied
> to the higher `(y,z)`-order layers of the germ prescription).

The `m = 1` scoping needs no such correction (packet §4/§7 already state
the inclusive constraints `u_{2e} = v_{2e}`, `u_{2e+1}+v_{2e+1} = 0`).

## 8. Correction H1-D (2026-08-06, FIX-P2; director-adjudicated): the "at ALL THREE D12-points" clause of H1-1(a) is FALSE

The packet payload's clause *"hence, by the residual C3 … at ALL THREE
D12-points"* conflates transport of the statement with extra vanishing
of one datum: `θ` permutes the D12-points AND the three involutions'
leading data `Λ^{(i)}` by the same 3-cycle, so transport yields
`Λ^{(2)}` vanishing at `c₂` — not `Λ^{(1)}` vanishing at `c₂`. Measured
on FIX-P2's real `(1,6)` slice at two primes: `Λ^{(i)}` has order
exactly `2e` at its OWN D12-point and order ~1 at the foreign points.
**Corrected H1-1(a): own-point vanishing only; the degree bound is
`n ≥ 2e`, i.e. `d ≥ 3r − 2m` (plus the small measured foreign-point
vanishing), NOT `d ≥ 7r − 6m`.** This clause was prose, never
exercised by the packet verifier — the verifier-tested content
(own-point orders, (b), (c), the M3/M1 equalizer kills, "no
line-degree-0 germ") all SURVIVES; P2 independently machine-confirmed
the own-point local content on the slice. Downstream casualties
recorded in the notebook: P1's Theorem P1-A and its sweep list
(superseded by P2's corrected 357-row sweep: unconditional cutoff
`d ≤ 30`, first possibly-nonzero window `d = 34` via `(1,6)`),
Note II's map-relevant-`n` figures, Note V §2's window arithmetic,
and Correction H1-C's `6e+9` evasion bound (needs re-derivation
against own-point-only vanishing).
The classified-data kills (line degree 0 and `q^k`-translates) are
unaffected — those are doubly dead via H1-1(a). The degree bound
`d ≥ 7r−6m` is a `≥` and unaffected. General moral, recorded for every
future branch test: **the leading-layer equalizer punishes only
non-degenerate jets; high vanishing at the D12-orbit is a universal
evasion channel, at a degree cost, and closing it needs the layer-`k`
equalizers.**
