FIX-A0-ARRANGEMENT-PASS

- `FIX-A0-C1-INVOLUTION-SPLIT-PASS` — exactly 55 involutions, one conjugacy class; every lift to `W` has trace `1`; every eigensplit is `dim W⁺ = 3`, `dim W⁻ = 2`.
- `FIX-A0-C2-LINE-IN-X-PASS` — `F|_{W⁻_σ} ≡ 0` identically (symbolic, all 55), so `L_σ = P(W⁻_σ) ⊂ X` for all 55 involutions.
- `FIX-A0-C3-ELLIPTIC-J-PASS` — `E_σ = X ∩ P(W⁺_σ)` is a smooth plane cubic; `j(E_σ) = 8192/11` exactly, for **all 55** involutions, by **two independent char-0 routes**. Non-CM corollary confirmed: `j ∉ Z`.
- `FIX-A0-C4-NORMAL-TYPES-PASS` — at every point of `L_σ` and of `E_σ`: `T_pP⁴ = (+1)¹⊕(−1)³` resp. `(+1)²⊕(−1)²`, `T_pX = (+1)¹⊕(−1)²` in both cases, `N_{L_σ/X} = N_{E_σ/X} = (−1)^{⊕2}`.
- `FIX-A0-C5-D12-RESIDUAL-S3-PASS` — `|C_G(σ)| = 12`, `C_G(σ) ≅ D12 ≅ Z/2 × S3` with `Z(C_G(σ)) = ⟨σ⟩`; residual `S3 = C_G(σ)/⟨σ⟩` acts on `L_σ = P(W⁻)` through the **standard 2-dimensional irrep** (character `2, 0, −1`), faithfully on `P¹`, and on `W⁺` through `triv ⊕ std` (character `3, 1, 0`).
- `FIX-A0-C6-ARRANGEMENT-PASS-WITH-FINDING` — all pairwise incidences computed exactly for all 55×55 pairs; the `V4`, `D12` and `D10` strata located. **FINDING (6a): no line `L_τ` lies in any plane `P_σ` for `τ ≠ σ`** — the plane–line incidence is always `dim(W⁺_σ ∩ W⁻_τ) ≤ 1`, never `2`.

Problem E headline: OPEN

---

## 0. Scope and method

Characteristic 0 throughout. The field is `Q(ζ₁₁)` (and `Q(ζ₁₁, ω) = Q(ζ₃₃)` where a
cube root of unity is needed), implemented as exact integer-numerator /
integer-denominator vectors modulo `Φ₁₁`. **No floating point is used anywhere.**
The 660-element group is rebuilt by BFS from the generators `S, T` of the
5-dimensional Weil representation and certified against an independent model of
`PSL(2,11)` (exact Cayley-graph consistency with `2×2` matrices over `F₁₁`, all
660 elements). `F = x₀²x₁ + x₁²x₂ + x₂²x₃ + x₃²x₄ + x₄²x₀`; `F(Sx) = F(Tx) = F(x)`
is verified as a polynomial identity over `Q(ζ₁₁)` (smoke test), which proves
`G`-invariance for the whole group. Nothing is read from `certificates/`.

Element-order profile of the rebuilt group: `{1:1, 2:55, 3:110, 5:264, 6:110, 11:120}`
(sums to 660).

`X = V(F)` is smooth: the elementary certificate is that `∂F/∂x_k = 2x_kx_{k+1} + x_{k-1}²`,
so (a) if some `x_k = 0` then `x_{k-1} = 0` and inductively all coordinates vanish;
(b) if all `x_i ≠ 0` then multiplying `x_{k-1}² = −2x_kx_{k+1}` over `k` gives
`(∏x)² = (−2)⁵(∏x)²`, i.e. `1 = −32`, absurd. Independently machine-checked in
Macaulay2 over `Q` (`verify_klein_smooth.m2`: `dim(Jacobian ideal) = 0`,
`radical = (x₀,…,x₄)`).

## 1. Claim 1 — 55 involutions, trace 1, split (3,2) — PASS

55 elements of order 2, forming a single conjugacy class (verified by conjugating
one of them by all 660 elements). Trace of every involution on `W` is exactly `1`
(as an element of `Q(ζ₁₁)`, not merely numerically). Hence `dim W⁺ = 3`,
`dim W⁻ = 2`; recomputed twice, once as `ker(M ∓ I)` (producer) and once as the
image of the projector `(I ± M)/2` (verifier), with the eigenvector property
`Mv = ±v` re-checked on every basis vector.

## 2. Claim 2 — `L_σ = P(W⁻_σ) ⊂ X` — PASS

`F` restricted to `W⁻_σ` is expanded symbolically as a binary cubic over
`Q(ζ₁₁)` and is identically zero for all 55 involutions. Recertified in the
verifier by a different argument: `F` vanishes at 5 distinct points of each line,
and a binary cubic has only 4 coefficients, so it is the zero form.

## 3. Claim 3 — `E_σ` smooth plane cubic, `j = 8192/11` — PASS

**Exact value: `j(E_σ) = 8192/11 = 2¹³/11`, identical for all 55 involutions.**
This confirms the session-claimed value.

Two fully independent characteristic-0 computations, each performed for all 55:

* **Route A (Hesse normal form).** The residual `C3 ⊂ C_G(σ)` acts on `W⁺` with
  the three distinct characters `1, ω, ω²` (verified: trace of an order-3 element
  is `0` on `W⁺` and `−1` on `W⁻`). Diagonalising over `Q(ζ₁₁, ω)` puts the
  ternary cubic in the shape `a x³ + b y³ + c z³ + d xyz` — this shape is itself a
  strong structural check and holds exactly in all 55 cases. Then
  `t := μ³ = −d³/(27abc) = −16/11` (a rational number, the same for all 55) and
  `j = 27 t (t+8)³/(t−1)³ = 8192/11`.
* **Route B (projection from a rational point).** Stays over `Q(ζ₁₁)`, uses no
  field extension and no eigenbasis. Each plane `P_σ` carries 3 exact
  `Q(ζ₁₁)`-rational points of `E_σ` (the `V4` vertices, §6). Projecting the plane
  cubic from such a point gives a degree-2 map to `P¹` whose branch divisor is the
  binary quartic `Q₂² − 4LC₃`; its classical invariants `I, J` give
  `j = 6912 I³/(4I³ − J²) = 8192/11`. Done from all 3 points, all 55 planes.

Both j-formulas are themselves **derived from scratch, symbolically and exactly**,
in `verify_j_formulas.py` (17 checks): formula A by an explicit projective change
of coordinates sending the flex `(1:−1:0)` of `x³+y³+z³−3μxyz` to `(0:1:0)` with
tangent `Z = 0`, followed by Weierstrass reduction and `j = c₄³/Δ`; formula B from
the `SL(2)`-invariance of `I` (weight 4) and `J` (weight 6) plus agreement with
the Weierstrass `j` on the slice `a = 0`.

**Smoothness of `E_σ`**, two independent exact certificates:

1. For `a x³+b y³+c z³+d xyz` with `a,b,c,d ≠ 0` (verified exactly), a singular
   point forces `a x³ = b y³ = c z³ = −dxyz/3`. If `xyz ≠ 0`, multiplying gives
   `27abc + d³ = 0`, i.e. `t = 1`; if some coordinate vanishes the partials force
   all of them to vanish. Since `t = −16/11 ≠ 1`, `E_σ` is smooth.
2. Route B produces a Weierstrass model with `4I³ − J² ≠ 0` (verified exactly), so
   the branch divisor is reduced and the curve has geometric genus 1 — an
   irreducible plane cubic with a singular point would have geometric genus 0.

**Non-CM corollary (explicit).** `j(E_σ) = 8192/11` has denominator 11, so it is
**not an algebraic integer**. Every CM elliptic curve has an integral
`j`-invariant. Therefore `E_σ` has **no complex multiplication**. (This is
independent of, and consistent with, the CM-ness of `J(X) ≅ E₋₁₁⁵`.)

## 4. Claim 4 — normal types — PASS

For an involution `σ`, `F` is `σ`-invariant and homogeneous of degree 3, so
`∇F(v)ᵀσ = ∇F(v)ᵀ` for `v` in either eigenspace: `∇F(v)` is a `σ`-invariant
covector and therefore annihilates `W⁻`. This identity is verified **symbolically
at the generic point** of both strata (as a polynomial identity in 2 resp. 3
variables, exactly, for all 55 involutions), not merely at samples.

* **Along `L_σ`.** `F|_L ≡ 0` and `∇F(v)·W⁻ ≡ 0` identically in the line parameter
  `(s:t)`. The three components of `∇F(v)|_{W⁺}` are binary quadratics whose
  pairwise Sylvester resultants are all nonzero (exact), so they have no common
  projective zero: `∇F(v) ≠ 0` for every `v ≠ 0` in `W⁻`, i.e. `X` is smooth along
  `L_σ` and `ker ∇F(v) = W⁻ ⊕ K` with `K ⊂ W⁺` of dimension 2. Twisting by the
  character of `⟨v⟩` (which is `−1`):

  `T_pP⁴ = (+1)¹ ⊕ (−1)³` (the `+1` is `T_pL_σ`) ; `T_pX = (+1)¹ ⊕ (−1)²` ; **`N_{L_σ/X} = (−1)^{⊕2}`**.

* **Along `E_σ`.** `∇F(u)·W⁻ ≡ 0` identically for `u ∈ W⁺`, and `∇F(u)|_{W⁺} = ∇C(u) ≠ 0`
  on `E_σ` by smoothness of `C`. So `ker ∇F(u) = W⁻ ⊕ K'`, `K' ⊂ W⁺` of dimension 2,
  containing `u`; the twist is by `+1`:

  `T_qP⁴ = (+1)² ⊕ (−1)²` ; `T_qX = (+1)¹ ⊕ (−1)²` ; `T_qE_σ = (+1)¹` ; **`N_{E_σ/X} = (−1)^{⊕2}`**.

Machine-checked at exact points as well: 3 exact points per line (`(1:0)`, `(0:1)`,
`(1:1)` in the eigenbasis) and all 3 exact `Q(ζ₁₁)`-points of each `E_σ`, i.e.
`6 × 55 = 330` exact tangent-space computations, each confirming
`dim ker ∇F = 4`, `dim(ker ∩ W⁺) = dim(ker ∩ W⁻) = 2`, `T_pX = (+1)¹ ⊕ (−1)²`.
(The trivial character does not occur in either normal type — consistent with
Definition 1.1 of Note I.)

## 5. Claim 5 — `C_G(σ) ≅ D12`, residual `S3` — PASS

`|C_G(σ)| = 12` for all 55 involutions, with element-order profile
`{1:1, 2:7, 3:2, 6:2}` and centre exactly `⟨σ⟩`. That profile already excludes
`A4` (3 involutions) and `Dic3` (1 involution), leaving the dihedral group of
order 12. Two independent explicit identifications:

* producer: `C_G(σ) = ⟨σ⟩ × H` with `H` of order 6 non-abelian, `H ∩ ⟨σ⟩ = 1`,
  `H·⟨σ⟩ = C_G(σ)` — so `C_G(σ) ≅ Z/2 × S3 ≅ D12`, and the residual group
  `C_G(σ)/⟨σ⟩ ≅ H ≅ S3`;
* verifier: `C_G(σ) = ⟨r, s⟩` with `r` of order 6, `s` an involution and `srs = r⁻¹`
  — the dihedral presentation of `D12` directly.

**Residual `S3`-action on `L_σ = P(W⁻)`.** `σ` acts on `W⁻` by `−I₂`, so the
`C_G(σ)`-action descends to `P(W⁻) = P¹`. The `2×2` matrices of all 6 residual
elements are recorded exactly in `payload_involutions.json`
(`residual_actions[σ].H_elements[*].M_on_Wminus`). Their character is

| class of the residual `S3` | `1` | transposition | 3-cycle |
|---|---|---|---|
| `χ_{W⁻}` | 2 | 0 | −1 |
| `χ_{W⁺}` | 3 | 1 | 0 |

so `W⁻|_{S3} ≅ std` (the standard 2-dimensional irrep) and `W⁺|_{S3} ≅ triv ⊕ std`.
No non-identity residual element acts by a scalar on `W⁻`, so `S3 ↪ PGL(W⁻) = PGL₂`
is **faithful** — the classical `S3`-action on `P¹`. As a `C_G(σ)`-representation
`W⁻` has character `(1 ↦ 2, σ ↦ −2, order 3 ↦ −1, order 6 ↦ 1, other involutions ↦ 0)`,
i.e. `W⁻ ≅ ε ⊗ std` with `ε(σ) = −1`, and `W⁺` has character
`(1 ↦ 3, σ ↦ 3, order 3 ↦ 0, order 6 ↦ 0, other involutions ↦ 1)`.

The residual `S3` also acts on `E_σ` (it preserves `W⁺`, hence `P(W⁺)` and
`X ∩ P(W⁺)`).

## 6. Claim 6 — consolidated arrangement tables — PASS, with one FINDING

The 55 lines `L_σ`, the 55 planes `P_σ` and the 55 `V4`-lines are each pairwise
distinct, and no `V4`-line is one of the `L_σ`. All 55×55 intersection dimensions
were computed exactly, twice, by two different algorithms (double annihilators in
the producer; `dim(U∩V) = dim U + dim V − rank[U;V]` in the verifier), with
identical results.

**(a) Lines inside planes — FINDING.** `dim(W⁺_σ ∩ W⁻_τ) ∈ {0, 1}` for every
ordered pair with `τ ≠ σ`; the value `2` never occurs. **No line of the
55-line configuration lies inside any of the 55 planes.** The prediction sheet
asked "which lines lie in which planes"; the exact answer is *none*. What does
happen is:

`dim(W⁺_σ ∩ W⁻_τ) = 1  ⟺  σ and τ commute (⟨σ,τ⟩ ≅ V4)`, and `= 0` otherwise
(330 ordered incident pairs, 2640 disjoint pairs). The 6 commuting `τ` give only
**3 distinct points** on `P_σ`, because `τ` and `στ` cut `P_σ` in the same point.
Those 3 points lie on `X`, hence on `E_σ`; they are the exact rational points used
by route B in claim 3.

**(b) Line–line.** `dim(W⁻_σ ∩ W⁻_τ) = 1` for exactly the 330 ordered
(= 165 unordered) commuting pairs, and `0` otherwise. So

> `L_σ ∩ L_τ ≠ ∅  ⟺  ⟨σ,τ⟩ ≅ V4`, and then they meet in exactly one point.

This is the predicted `V4`-vertex behaviour: PASS. There are 55 `V4` subgroups,
each contributing 3 vertices, giving **165 distinct vertices**; each vertex lies on
exactly **2** of the 55 lines and exactly **1** of the 55 planes, and **all 165 lie
on `X`**. Dually, each line carries 6 vertices and each plane carries 3.

**(c) Plane–plane and plane–line.** `dim(W⁺_σ ∩ W⁺_τ) = 2` (they meet in a *line*)
exactly for the 165 commuting pairs, and `= 1` (a point) for the other 1320 pairs.
For a `V4 = {1,σ,τ,στ}` the three planes `P_σ, P_τ, P_{στ}` all contain the same
line, and it equals `P(W^{V4})`, the pointwise `V4`-fixed line
(`dim W^{V4} = 2` for all 55 `V4`s — the `W|_{V4} = triv² ⊕ χ₁ ⊕ χ₂ ⊕ χ₃`
decomposition of FIX-A1, confirmed here from the incidence side). `F` restricted
to a `V4`-line is **not** identically zero and has nonzero discriminant, so each
`V4`-line meets `X` in **3 distinct points** (the "type II" points), which
therefore lie on all three elliptic curves of that `V4`. No `V4`-line meets any
of the 55 lines `L_σ`. Plane–line data as in (a).

**(d) `D12`- and `D10`-fixed point strata.**

| stratum | count | planes `P_σ` through each | lines `L_σ` through each | `V4`-lines through each | on `X`? |
|---|---|---|---|---|---|
| `D12` (= `C_G(σ)`, 55 subgroups) | **55** | 7 | 0 | 3 | no |
| `D10` (= `N_G(C5)`, 66 subgroups, all of order 10) | **66** | 5 | 0 | 0 | no |
| `V4` vertices | **165** | 1 | 2 | — | yes |

Each `D12`/`D10` subgroup has a 1-dimensional fixed space in `W`, i.e. exactly one
fixed point in `P⁴`. Dually each plane carries 7 `D12`-points and 6 `D10`-points.
The `7` and `5` are exactly the numbers of involutions inside `D12` and `D10`.

**Residual `S3` on the marked points of `L_σ`.** The 6 `V4`-vertices on each line
form **two orbits of size 3** under the residual `S3` (all 55 lines) — the two
special 3-point orbits of the standard `S3 ⊂ PGL₂` action on `P¹`.

## 7. Cross-reference with `certificates/strata/` — NO DISCREPANCY

Everything below was **recomputed from generators**, not read; the comparison was
made only after the fact.

| `certificates/strata/incidence_exact.json` | this packet |
|---|---|
| `arrangement_points_off_X.D12 = {count 55, planes_through_each 7, V4_lines_through_each 3}` | identical |
| `arrangement_points_off_X.D10 = {count 66, planes_through_each 5}` | identical |
| `double_count_planes_vs_D10`: 55 planes × 6 = 66 × 5 = 330 | identical (6 `D10`-points per plane recomputed) |
| `triangle_vertices_type_I`: each on 1 elliptic and 2 minus-lines | identical (1 plane, 2 lines, all on `X`) |
| `type_II_points_R`: 3 per `V4`, on all 3 elliptics, on no triangle line | identical (`F` on the `V4`-line has nonzero discriminant ⇒ 3 distinct points; the `V4`-line lies in all 3 planes and meets no `L_σ`) |
| `type_I_points`: 165 | identical (165 distinct vertices) |
| `type_I_type_II_verdict`: positive-dimensional fixed-locus closures meet at type-II points as well | consistent — `P_σ ∩ P_τ` is the `V4`-line for commuting pairs, and `E_σ ∩ E_τ` contains its 3 points on `X` |

Also cross-checked against `certificates/strata/normal_characters.json`:

* `regressions.involution_dims_Eplus_Eminus = [3,2]`, `trace(t) = 1` — identical.
* `regressions.V4_joint_character_dims = {A_triv 2, B 1, C 1, D 1}` — identical
  (`dim W^{V4} = 2` and three 1-dimensional nontrivial characters), i.e. the
  FIX-A1 ground truth `W|_{V4} = triv² ⊕ χ₁ ⊕ χ₂ ⊕ χ₃` reconfirmed from the
  incidence side.
* `regressions.D10_D12_A4_off_X` — identical (both point strata off `X`).
* `strata.C2_line.normal_bundle_fiber_as_H_module` (rank 3, "overall sign") and
  `strata.C2_plane.normal_bundle_fiber_as_H_module` (`sign ⊕ sign`, rank 2) —
  identical to `T_pP⁴ = (+1)¹⊕(−1)³` and `N_{P(W⁺)/P⁴} = (−1)²`.
* **Ambiguity resolved, not a discrepancy:** the free text of
  `strata.C2_line.tangent_T_yY_generic` visibly hesitates over the sign
  convention ("... = -1? Convention recorded in fiber note"). The exact
  computation here settles it: `T_pP⁴|_{L_σ} = (+1)¹ ⊕ (−1)³` with the `(+1)`
  being `T_pL_σ`. The certificate also records only `rank 2` for `N_{L_σ/X}`
  without its character; this packet supplies it: `(−1)^{⊕2}`.

The `certificates/hodge_centers/` session claim `j(E_t) = 8192/11`, non-CM, is
**confirmed** (§3). No claim in `certificates/strata/` was contradicted.

## 8. Consequence for Note I

The boundary condition of Note I §5.1 is now machine-certified in characteristic 0:
`X^σ = E_σ ⊔ L_σ` with `E_σ` a smooth non-CM elliptic curve of `j = 8192/11`,
`L_σ ≅ P¹`, and both normal types `(−1)^{⊕2}`. Corollary 4.4 therefore funnels
every fixed stratum of every model of `P(W)` into the 55-line/point part of the
arrangement, with the 55 elliptic curves receiving points only. The two loci are
disjoint (`W⁺ ∩ W⁻ = 0`), so `X^σ` really is a disjoint union of one rational and
one genus-1 component, as Note I assumes.

Nothing in this packet bears on the Problem E headline.

## 9. Verification class

`ALGEBRAIC-RECOMPUTE`. `verify_fix_a0.py` rebuilds the group from `S, T`,
certifies it against `PSL(2,11)` over `F₁₁`, recomputes every eigenspace,
restriction, `j`-invariant, normal type and incidence table using algorithms
different from the producer's, and only then compares with the payload JSONs.
There is no hash-only or field-read-only check anywhere. `verify_j_formulas.py`
derives the two `j` formulas symbolically. `verify_klein_smooth.m2` re-proves
smoothness of `X` in Macaulay2. `extra_modular_crosscheck.py` (an *extra*, not
the certificate) rebuilds everything over `F₂₃`, `F₆₇`, `F₈₉` and recomputes `j`
by a **third** algorithm (brute-force flex search + Weierstrass reduction),
matching `8192/11 mod p` in every case.
