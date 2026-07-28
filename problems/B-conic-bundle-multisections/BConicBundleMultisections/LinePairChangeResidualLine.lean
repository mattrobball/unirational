/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.LineCompletionResidualLine

/-!
# Condition G3 under a change of the spanning pair (Goal F-3)

`LinePresentationPairChange` (F-1) proved that `HasGoodLineSectionPartial` — the discriminant, the
isotropic section and condition G4 — survives every invertible change `(p,q) ↦ (a•p+b•q, c•p+d•q)`
of the pair spanning the multisection line `L`.  `LineCompletionResidualLine` (F-2) proved that
**G3**, `ResidualLineNonconstantOn`, survives a change of the frame *completion* `r`.  This module
supplies the missing half: **G3 under the `GL₂` pair change**.

## The block and the law

The pair change is the right multiplication of the frame by the `GL₂` block

```
E = gl2Matrix3 a c b d = !![a, c, 0; b, d, 0; 0, 0, 1],
    lineFrame (a•p+b•q) (c•p+d•q) r = lineFrame p q r * E,
```

which — unlike F-2's completion block — **moves the points of `L`**: the generic point `(1,t,0)`
is carried to another point of `{Y₂ = 0}`.  Nevertheless the law that comes out is again a **pure
unit scalar**, because the `E`-twist on the residual coefficients cancels the `E⁻¹`-twist on the
substitution back:

```
residualEquationOn (M * E) N' F = C ((a*d - b*c)^6) * residualEquationOn M N F,   E * N' = N.
```

The mixing is `x`-**independent** at every stage; there is no `x`-dependent term anywhere, so the
rank-`≤1` condition defining `ResidualLineConstantOn` transports in both directions.

## Where the mixing does show up

On a *plane cubic* the residual line genuinely mixes.  Writing `H_E` for `H ∘ E` and
`(q_U, q_V, q_W)` for the coefficient triple of `residualLinearForm`:

```
residualLinearForm H_E = C (det² ^ 3) * (residualLinearForm H) ∘ E,
```

i.e. the triple transforms by `q ↦ (det E₂)^6 · Eᵀ q` — the **dual** (`x`-independent, invertible)
action, times the unit `(det E₂)^6`.  The exponent `6` is the classical weight of a binary
invariant of a cubic: the discriminant `Δ` of the line-restricted binary cubic and the
`(3,2)`-resultant `polarResultant` both have weight `det^6`, and the certificate identity
`polarResultant + Δ·H = W²·q_H` forces the same weight on `q_H`.  When the triple is carried back
by `E⁻¹` (which is what `residualEquationOn` does) the `Eᵀ` disappears and only the unit survives.

| stage | mixing | unit |
|---|---|---|
| `coeffU3/U2V/UV2/V3` | binary cubic `∘ E₂` | — |
| `coeffU2W/UVW/V2W` | binary quadratic `∘ E₂` | — |
| `polarQuadA/B/C` | binary quadratic `∘ E₂`, point moved by `E` | — |
| `binaryCubicDiscr` | none | `det^6` |
| `polarResultant` | point moved by `E` | `det^6` |
| `residualCoeffU/V_of` | `Eᵀ` on `(q_U,q_V)` | `det^6` |
| `residualCoeffW_of` | none | `det^6` |
| `residualEquationOn`, `residualLineCoeffOn` | **none** (`E`/`E⁻¹` cancel) | `det^6` |

## Route

Exactly F-2's toolkit.  `polarResultant` sees the cubic only through the three polar-quadratic
coefficients (`polarResultantABC`); the seven relevant coefficients are read off `G` and its
partials at `(1,0,0)`, `(0,1,0)`, `(1,1,0)` — which the `GL₂` block moves to *other* points of the
same line `{Y₂ = 0}`, where `eval_pderiv0/1/2_planeCubic` still evaluate them.  The certificate
identity at `W = 1` then separates `q_U, q_V, q_W`, and the biprojective statement lifts through
`secondBlockCoeff_eq_coeff_genericFiber`.  Unlike F-1 there is no need to split into shear / scale
/ swap: the two scalar identities behind the law (`binaryCubicDiscr_gl2` and
`polarResultantABC_gl2`) hold for a general `2×2` block and are `ring` identities.  The three
generator laws are recorded below as corollaries.

No division occurs, so nothing is assumed about the characteristic.  `IsBidegree23 F` is assumed
where the generic fibre must be a homogeneous cubic.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial Finsupp
open _root_.MvPolynomial
open scoped _root_.Matrix

/-! ### The `GL₂` block -/

section GL2Matrix

variable {R : Type u} [CommRing R]

/-- The `GL₂` block `E = !![m00, m01, 0; m10, m11, 0; 0, 0, 1]`.  Its columns are
`p ↦ m00•p + m10•q`, `q ↦ m01•p + m11•q`, `r ↦ r`, matching the *column* convention of
`lineFrame`. -/
def gl2Matrix3 (m00 m01 m10 m11 : R) : Matrix (Fin 3) (Fin 3) R :=
  !![m00, m01, 0; m10, m11, 0; 0, 0, 1]

@[simp] theorem gl2Matrix3_map {S : Type u} [CommRing S] (φ : R →+* S) (m00 m01 m10 m11 : R) :
    (gl2Matrix3 m00 m01 m10 m11).map φ = gl2Matrix3 (φ m00) (φ m01) (φ m10) (φ m11) := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [gl2Matrix3]

theorem gl2Matrix3_mulVec_vec (m00 m01 m10 m11 x y z : R) :
    gl2Matrix3 m00 m01 m10 m11 *ᵥ ![x, y, z] =
      ![m00 * x + m01 * y, m10 * x + m11 * y, z] := by
  funext i
  fin_cases i <;>
    simp [gl2Matrix3, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-- **The block preserves the line `{Y₂ = 0}`** — as a set, not pointwise: this is the essential
difference from the completion block of F-2. -/
theorem gl2Matrix3_mulVec_line (m00 m01 m10 m11 x y : R) :
    gl2Matrix3 m00 m01 m10 m11 *ᵥ ![x, y, (0 : R)] =
      ![m00 * x + m01 * y, m10 * x + m11 * y, 0] :=
  gl2Matrix3_mulVec_vec _ _ _ _ _ _ _

theorem gl2Matrix3_transpose_mulVec (m00 m01 m10 m11 : R) (x : Fin 3 → R) :
    (gl2Matrix3 m00 m01 m10 m11).transpose *ᵥ x =
      ![m00 * x 0 + m10 * x 1, m01 * x 0 + m11 * x 1, x 2] := by
  funext i
  fin_cases i <;>
    simp [gl2Matrix3, Matrix.mulVec, Matrix.transpose, dotProduct, Fin.sum_univ_three]

/-- Changing the spanning pair multiplies the frame by the `GL₂` block on the right. -/
theorem lineFrame_gl2 (p q r : Fin 3 → R) (a b c d : R) :
    lineFrame (fun i => a * p i + b * q i) (fun i => c * p i + d * q i) r =
      lineFrame p q r * gl2Matrix3 a c b d := by
  ext i j
  fin_cases j <;>
    simp [lineFrame, gl2Matrix3, Matrix.mul_apply, Fin.sum_univ_three] <;> ring

/-- Pointwise form of `lineFrame_gl2`, so that a new pair given in any algebraically equal shape
(`q`, `p + β•q`, `α•p`, …) matches without a defeq problem. -/
theorem lineFrame_gl2_of_eq (p q r p' q' : Fin 3 → R) (a b c d : R)
    (hp' : ∀ i, p' i = a * p i + b * q i) (hq' : ∀ i, q' i = c * p i + d * q i) :
    lineFrame p' q' r = lineFrame p q r * gl2Matrix3 a c b d := by
  rw [show p' = fun i => a * p i + b * q i from funext hp',
    show q' = fun i => c * p i + d * q i from funext hq', lineFrame_gl2]

end GL2Matrix

section GL2Generators

variable {k : Type u} [Field k]

theorem shearFrame3_eq_gl2 (β : k) : shearFrame3 β = gl2Matrix3 1 0 β 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [shearFrame3, gl2Matrix3]

theorem scaleFrame3_eq_gl2 (α δ : k) : scaleFrame3 α δ = gl2Matrix3 α 0 0 δ := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [scaleFrame3, gl2Matrix3]

theorem swapFrame3_eq_gl2 : (swapFrame3 : Matrix (Fin 3) (Fin 3) k) = gl2Matrix3 0 1 1 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [swapFrame3, gl2Matrix3]

end GL2Generators

/-! ### The `(3,2)` resultant seen through the polar quadratic

`polarResultant` depends on the cubic only through `(a,b,c,d)` and the three coefficients of the
polar quadratic.  Naming that dependence is what makes the `GL₂` law a small `ring` identity. -/

namespace UniversalResidual

variable {R : Type u} [CommRing R]

/-- `polarResultant` with the polar-quadratic coefficients as explicit arguments. -/
def polarResultantABC (a b c d A B C : R) : R :=
  A ^ 3 * d ^ 2
    - A ^ 2 * B * c * d
    - 2 * A ^ 2 * C * b * d
    + A ^ 2 * C * c ^ 2
    + A * B ^ 2 * b * d
    + 3 * A * B * C * a * d
    - A * B * C * b * c
    - 2 * A * C ^ 2 * a * c
    + A * C ^ 2 * b ^ 2
    - B ^ 3 * a * d
    + B ^ 2 * C * a * c
    - B * C ^ 2 * a * b
    + C ^ 3 * a ^ 2

theorem polarResultant_eq_ABC (a b c d e f hh U V W : R) :
    polarResultant a b c d e f hh U V W =
      polarResultantABC a b c d (polarQuadA a b e U V W) (polarQuadB b c f U V W)
        (polarQuadC c d hh U V W) := rfl

/-- The four coefficients of the line-restricted binary cubic after the `GL₂` block. -/
def gl2CubicA (m00 m10 a b c d : R) : R :=
  a * m00 ^ 3 + b * m00 ^ 2 * m10 + c * m00 * m10 ^ 2 + d * m10 ^ 3

/-- Second coefficient of the transformed binary cubic. -/
def gl2CubicB (m00 m01 m10 m11 a b c d : R) : R :=
  m01 * (3 * a * m00 ^ 2 + 2 * b * m00 * m10 + c * m10 ^ 2) +
    m11 * (b * m00 ^ 2 + 2 * c * m00 * m10 + 3 * d * m10 ^ 2)

/-- **Weight `6` of the binary-cubic discriminant.**  A `ring` identity. -/
theorem binaryCubicDiscr_gl2 (m00 m01 m10 m11 a b c d : R) :
    binaryCubicDiscr (gl2CubicA m00 m10 a b c d) (gl2CubicB m00 m01 m10 m11 a b c d)
        (gl2CubicB m01 m00 m11 m10 a b c d) (gl2CubicA m01 m11 a b c d) =
      (m00 * m11 - m01 * m10) ^ 6 * binaryCubicDiscr a b c d := by
  simp only [binaryCubicDiscr, gl2CubicA, gl2CubicB]
  ring

/-- **Weight `6` of the `(3,2)` polar resultant.**  The cubic is substituted by the `GL₂` block and
the polar quadratic is substituted by the same block; the resultant picks up `det^6`.  A `ring`
identity — this is the whole arithmetic content of F-3. -/
theorem polarResultantABC_gl2 (m00 m01 m10 m11 a b c d A B C : R) :
    polarResultantABC (gl2CubicA m00 m10 a b c d) (gl2CubicB m00 m01 m10 m11 a b c d)
        (gl2CubicB m01 m00 m11 m10 a b c d) (gl2CubicA m01 m11 a b c d)
        (m00 ^ 2 * A + m00 * m10 * B + m10 ^ 2 * C)
        (2 * m00 * m01 * A + (m00 * m11 + m01 * m10) * B + 2 * m10 * m11 * C)
        (m01 ^ 2 * A + m01 * m11 * B + m11 ^ 2 * C) =
      (m00 * m11 - m01 * m10) ^ 6 * polarResultantABC a b c d A B C := by
  simp only [polarResultantABC, gl2CubicA, gl2CubicB]
  ring

end UniversalResidual

namespace PlaneCubicResidual

open UniversalResidual

variable {R : Type u} [CommRing R]

/-! ### The plane cubic under the `GL₂` block -/

/-- Substitution of a plane cubic by the `GL₂` block: `G ↦ G ∘ E`. -/
def gl2Subst (m00 m01 m10 m11 : R) :
    MvPolynomial (Fin 3) R →ₐ[R] MvPolynomial (Fin 3) R :=
  aeval (linearSubst 2 (gl2Matrix3 m00 m01 m10 m11))

variable (m00 m01 m10 m11 : R)

theorem eval_gl2Subst (G : MvPolynomial (Fin 3) R) (x : Fin 3 → R) :
    eval x (gl2Subst m00 m01 m10 m11 G) = eval (gl2Matrix3 m00 m01 m10 m11 *ᵥ x) G :=
  eval_aeval_linearSubst 2 _ G x

theorem isHomogeneous_gl2Subst {G : MvPolynomial (Fin 3) R} {d : ℕ} (hG : G.IsHomogeneous d) :
    (gl2Subst m00 m01 m10 m11 G).IsHomogeneous d :=
  isHomogeneous_aeval_linearSubst _ hG

/-- On the line `{Y₂ = 0}` the gradient of `G ∘ E` is `Eᵀ` applied to the gradient of `G` at the
*moved* point — the point moves inside the line. -/
theorem tangentGradient_gl2Subst_line (G : MvPolynomial (Fin 3) R) (x y : R) :
    tangentGradient (gl2Subst m00 m01 m10 m11 G) ![x, y, 0] =
      (gl2Matrix3 m00 m01 m10 m11).transpose *ᵥ
        tangentGradient G ![m00 * x + m01 * y, m10 * x + m11 * y, (0 : R)] := by
  rw [gl2Subst, tangentGradient_aeval_linearSubst, gl2Matrix3_mulVec_line]

/-! ### The seven line-adapted coefficients under the `GL₂` block -/

theorem coeffU3_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffU3 (gl2Subst m00 m01 m10 m11 G) =
      gl2CubicA m00 m10 (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G) := by
  rw [coeffU3_eq_eval _ (isHomogeneous_gl2Subst m00 m01 m10 m11 hG), eval_gl2Subst,
    gl2Matrix3_mulVec_vec, eval_eq_planeCubicValue hG]
  simp only [planeCubicValue, gl2CubicA, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons]
  ring

theorem coeffV3_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffV3 (gl2Subst m00 m01 m10 m11 G) =
      gl2CubicA m01 m11 (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G) := by
  rw [coeffV3_eq_eval _ (isHomogeneous_gl2Subst m00 m01 m10 m11 hG), eval_gl2Subst,
    gl2Matrix3_mulVec_vec, eval_eq_planeCubicValue hG]
  simp only [planeCubicValue, gl2CubicA, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons]
  ring

theorem coeffU2V_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffU2V (gl2Subst m00 m01 m10 m11 G) =
      gl2CubicB m00 m01 m10 m11 (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G) := by
  have h := congrFun (tangentGradient_gl2Subst_line m00 m01 m10 m11 G 1 0) 1
  rw [gl2Matrix3_transpose_mulVec] at h
  simp only [tangentGradient, Matrix.cons_val_one, Matrix.cons_val_zero] at h
  rw [eval_pderiv1_at_e0 _ (isHomogeneous_gl2Subst m00 m01 m10 m11 hG)] at h
  rw [eval_pderiv0_planeCubic G hG, eval_pderiv1_planeCubic G hG] at h
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons] at h
  rw [h, gl2CubicB]
  ring

theorem coeffUV2_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffUV2 (gl2Subst m00 m01 m10 m11 G) =
      gl2CubicB m01 m00 m11 m10 (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G) := by
  have h := congrFun (tangentGradient_gl2Subst_line m00 m01 m10 m11 G 0 1) 0
  rw [gl2Matrix3_transpose_mulVec] at h
  simp only [tangentGradient, Matrix.cons_val_zero] at h
  rw [eval_pderiv0_at_e1 _ (isHomogeneous_gl2Subst m00 m01 m10 m11 hG)] at h
  rw [eval_pderiv0_planeCubic G hG, eval_pderiv1_planeCubic G hG] at h
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons] at h
  rw [h, gl2CubicB]
  ring

theorem coeffU2W_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffU2W (gl2Subst m00 m01 m10 m11 G) =
      coeffU2W G * m00 ^ 2 + coeffUVW G * m00 * m10 + coeffV2W G * m10 ^ 2 := by
  have h := congrFun (tangentGradient_gl2Subst_line m00 m01 m10 m11 G 1 0) 2
  rw [gl2Matrix3_transpose_mulVec] at h
  simp only [tangentGradient, Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons] at h
  rw [eval_pderiv2_at_e0 _ (isHomogeneous_gl2Subst m00 m01 m10 m11 hG)] at h
  rw [eval_pderiv2_planeCubic G hG] at h
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons] at h
  rw [h]
  ring

theorem coeffV2W_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffV2W (gl2Subst m00 m01 m10 m11 G) =
      coeffU2W G * m01 ^ 2 + coeffUVW G * m01 * m11 + coeffV2W G * m11 ^ 2 := by
  have h := congrFun (tangentGradient_gl2Subst_line m00 m01 m10 m11 G 0 1) 2
  rw [gl2Matrix3_transpose_mulVec] at h
  simp only [tangentGradient, Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons] at h
  rw [eval_pderiv2_at_e1 _ (isHomogeneous_gl2Subst m00 m01 m10 m11 hG)] at h
  rw [eval_pderiv2_planeCubic G hG] at h
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons] at h
  rw [h]
  ring

theorem coeffUVW_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffUVW (gl2Subst m00 m01 m10 m11 G) =
      2 * coeffU2W G * m00 * m01 + coeffUVW G * (m00 * m11 + m01 * m10) +
        2 * coeffV2W G * m10 * m11 := by
  have h := congrFun (tangentGradient_gl2Subst_line m00 m01 m10 m11 G 1 1) 2
  rw [gl2Matrix3_transpose_mulVec] at h
  simp only [tangentGradient, Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons] at h
  rw [eval_pderiv2_at_e01 _ (isHomogeneous_gl2Subst m00 m01 m10 m11 hG)] at h
  rw [eval_pderiv2_planeCubic G hG] at h
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons] at h
  rw [coeffU2W_gl2 m00 m01 m10 m11 G hG, coeffV2W_gl2 m00 m01 m10 m11 G hG] at h
  linear_combination h

/-! ### The polar quadratic under the `GL₂` block

The three polar-quadratic coefficients transform by the *same* `GL₂` substitution acting on the
binary quadratic, with the evaluation point moved by the block. -/

theorem polarQuadA_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (U V W : R) :
    polarQuadA (coeffU3 (gl2Subst m00 m01 m10 m11 G))
        (coeffU2V (gl2Subst m00 m01 m10 m11 G))
        (coeffU2W (gl2Subst m00 m01 m10 m11 G)) U V W =
      m00 ^ 2 * polarQuadA (coeffU3 G) (coeffU2V G) (coeffU2W G)
          (m00 * U + m01 * V) (m10 * U + m11 * V) W +
        m00 * m10 * polarQuadB (coeffU2V G) (coeffUV2 G) (coeffUVW G)
          (m00 * U + m01 * V) (m10 * U + m11 * V) W +
        m10 ^ 2 * polarQuadC (coeffUV2 G) (coeffV3 G) (coeffV2W G)
          (m00 * U + m01 * V) (m10 * U + m11 * V) W := by
  rw [coeffU3_gl2 m00 m01 m10 m11 G hG, coeffU2V_gl2 m00 m01 m10 m11 G hG,
    coeffU2W_gl2 m00 m01 m10 m11 G hG]
  simp only [polarQuadA, polarQuadB, polarQuadC, gl2CubicA, gl2CubicB]
  ring

theorem polarQuadB_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (U V W : R) :
    polarQuadB (coeffU2V (gl2Subst m00 m01 m10 m11 G))
        (coeffUV2 (gl2Subst m00 m01 m10 m11 G))
        (coeffUVW (gl2Subst m00 m01 m10 m11 G)) U V W =
      2 * m00 * m01 * polarQuadA (coeffU3 G) (coeffU2V G) (coeffU2W G)
          (m00 * U + m01 * V) (m10 * U + m11 * V) W +
        (m00 * m11 + m01 * m10) * polarQuadB (coeffU2V G) (coeffUV2 G) (coeffUVW G)
          (m00 * U + m01 * V) (m10 * U + m11 * V) W +
        2 * m10 * m11 * polarQuadC (coeffUV2 G) (coeffV3 G) (coeffV2W G)
          (m00 * U + m01 * V) (m10 * U + m11 * V) W := by
  rw [coeffU2V_gl2 m00 m01 m10 m11 G hG, coeffUV2_gl2 m00 m01 m10 m11 G hG,
    coeffUVW_gl2 m00 m01 m10 m11 G hG]
  simp only [polarQuadA, polarQuadB, polarQuadC, gl2CubicB]
  ring

theorem polarQuadC_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (U V W : R) :
    polarQuadC (coeffUV2 (gl2Subst m00 m01 m10 m11 G))
        (coeffV3 (gl2Subst m00 m01 m10 m11 G))
        (coeffV2W (gl2Subst m00 m01 m10 m11 G)) U V W =
      m01 ^ 2 * polarQuadA (coeffU3 G) (coeffU2V G) (coeffU2W G)
          (m00 * U + m01 * V) (m10 * U + m11 * V) W +
        m01 * m11 * polarQuadB (coeffU2V G) (coeffUV2 G) (coeffUVW G)
          (m00 * U + m01 * V) (m10 * U + m11 * V) W +
        m11 ^ 2 * polarQuadC (coeffUV2 G) (coeffV3 G) (coeffV2W G)
          (m00 * U + m01 * V) (m10 * U + m11 * V) W := by
  rw [coeffUV2_gl2 m00 m01 m10 m11 G hG, coeffV3_gl2 m00 m01 m10 m11 G hG,
    coeffV2W_gl2 m00 m01 m10 m11 G hG]
  simp only [polarQuadA, polarQuadB, polarQuadC, gl2CubicA, gl2CubicB]
  ring

/-- **The polar resultant under the `GL₂` block**: unit `det^6`, point moved by the block. -/
theorem polarResultant_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (U V W : R) :
    polarResultant (coeffU3 (gl2Subst m00 m01 m10 m11 G))
        (coeffU2V (gl2Subst m00 m01 m10 m11 G))
        (coeffUV2 (gl2Subst m00 m01 m10 m11 G))
        (coeffV3 (gl2Subst m00 m01 m10 m11 G))
        (coeffU2W (gl2Subst m00 m01 m10 m11 G))
        (coeffUVW (gl2Subst m00 m01 m10 m11 G))
        (coeffV2W (gl2Subst m00 m01 m10 m11 G)) U V W =
      (m00 * m11 - m01 * m10) ^ 6 *
        polarResultant (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
          (coeffU2W G) (coeffUVW G) (coeffV2W G)
          (m00 * U + m01 * V) (m10 * U + m11 * V) W := by
  rw [polarResultant_eq_ABC, polarResultant_eq_ABC, polarQuadA_gl2 m00 m01 m10 m11 G hG,
    polarQuadB_gl2 m00 m01 m10 m11 G hG, polarQuadC_gl2 m00 m01 m10 m11 G hG,
    coeffU3_gl2 m00 m01 m10 m11 G hG, coeffU2V_gl2 m00 m01 m10 m11 G hG,
    coeffUV2_gl2 m00 m01 m10 m11 G hG, coeffV3_gl2 m00 m01 m10 m11 G hG]
  exact polarResultantABC_gl2 _ _ _ _ _ _ _ _ _ _ _

/-! ### The residual line of a plane cubic under the `GL₂` block -/

/-- **Master evaluation law.**  Read on the affine chart `W = 1`, the residual linear form of
`G ∘ E` at `(U,V,1)` is `det^6` times that of `G` at `E *ᵥ (U,V,1)`.  The evaluation point moves
inside the line — this is the `x`-independent mixing, and it is all there is. -/
theorem eval_residualLinearForm_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (U V : R) :
    eval ![U, V, 1] (residualLinearForm (gl2Subst m00 m01 m10 m11 G)) =
      (m00 * m11 - m01 * m10) ^ 6 *
        eval ![m00 * U + m01 * V, m10 * U + m11 * V, 1] (residualLinearForm G) := by
  have hG' : (gl2Subst m00 m01 m10 m11 G).IsHomogeneous 3 :=
    isHomogeneous_gl2Subst m00 m01 m10 m11 hG
  have hval : eval ![U, V, (1 : R)] (gl2Subst m00 m01 m10 m11 G) =
      eval ![m00 * U + m01 * V, m10 * U + m11 * V, 1] G := by
    rw [eval_gl2Subst, gl2Matrix3_mulVec_vec]
  have h1 := residual_identity_eval hG' ![U, V, (1 : R)]
  have h2 := residual_identity_eval hG ![m00 * U + m01 * V, m10 * U + m11 * V, (1 : R)]
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons] at h1 h2
  rw [hval] at h1
  rw [polarResultant_gl2 m00 m01 m10 m11 G hG U V 1] at h1
  rw [coeffU3_gl2 m00 m01 m10 m11 G hG, coeffU2V_gl2 m00 m01 m10 m11 G hG,
    coeffUV2_gl2 m00 m01 m10 m11 G hG, coeffV3_gl2 m00 m01 m10 m11 G hG,
    binaryCubicDiscr_gl2] at h1
  linear_combination (m00 * m11 - m01 * m10) ^ 6 * h2 - h1

theorem residualCoeffU_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    residualCoeffU (coeffU3 (gl2Subst m00 m01 m10 m11 G))
        (coeffU2V (gl2Subst m00 m01 m10 m11 G))
        (coeffUV2 (gl2Subst m00 m01 m10 m11 G))
        (coeffV3 (gl2Subst m00 m01 m10 m11 G))
        (coeffU2W (gl2Subst m00 m01 m10 m11 G))
        (coeffUVW (gl2Subst m00 m01 m10 m11 G))
        (coeffV2W (gl2Subst m00 m01 m10 m11 G))
        (coeffUW2 (gl2Subst m00 m01 m10 m11 G)) =
      (m00 * m11 - m01 * m10) ^ 6 *
        (m00 * residualCoeffU (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
              (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffUW2 G) +
          m10 * residualCoeffV (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
              (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffVW2 G)) := by
  have h00 := eval_residualLinearForm_gl2 m00 m01 m10 m11 G hG 0 0
  have h10 := eval_residualLinearForm_gl2 m00 m01 m10 m11 G hG 1 0
  simp only [eval_residualLinearForm, residualLinear, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons] at h00 h10
  linear_combination h10 - h00

theorem residualCoeffV_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    residualCoeffV (coeffU3 (gl2Subst m00 m01 m10 m11 G))
        (coeffU2V (gl2Subst m00 m01 m10 m11 G))
        (coeffUV2 (gl2Subst m00 m01 m10 m11 G))
        (coeffV3 (gl2Subst m00 m01 m10 m11 G))
        (coeffU2W (gl2Subst m00 m01 m10 m11 G))
        (coeffUVW (gl2Subst m00 m01 m10 m11 G))
        (coeffV2W (gl2Subst m00 m01 m10 m11 G))
        (coeffVW2 (gl2Subst m00 m01 m10 m11 G)) =
      (m00 * m11 - m01 * m10) ^ 6 *
        (m01 * residualCoeffU (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
              (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffUW2 G) +
          m11 * residualCoeffV (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
              (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffVW2 G)) := by
  have h00 := eval_residualLinearForm_gl2 m00 m01 m10 m11 G hG 0 0
  have h01 := eval_residualLinearForm_gl2 m00 m01 m10 m11 G hG 0 1
  simp only [eval_residualLinearForm, residualLinear, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons] at h00 h01
  linear_combination h01 - h00

theorem residualCoeffW_gl2 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    residualCoeffW (coeffU3 (gl2Subst m00 m01 m10 m11 G))
        (coeffU2V (gl2Subst m00 m01 m10 m11 G))
        (coeffUV2 (gl2Subst m00 m01 m10 m11 G))
        (coeffV3 (gl2Subst m00 m01 m10 m11 G))
        (coeffU2W (gl2Subst m00 m01 m10 m11 G))
        (coeffUVW (gl2Subst m00 m01 m10 m11 G))
        (coeffV2W (gl2Subst m00 m01 m10 m11 G))
        (coeffW3 (gl2Subst m00 m01 m10 m11 G)) =
      (m00 * m11 - m01 * m10) ^ 6 *
        residualCoeffW (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
          (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffW3 G) := by
  have h00 := eval_residualLinearForm_gl2 m00 m01 m10 m11 G hG 0 0
  simp only [eval_residualLinearForm, residualLinear, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons] at h00
  linear_combination h00

end PlaneCubicResidual

/-! ### From plane cubics to the biprojective residual equation -/

section Biprojective

open ResidualDivisor PlaneCubicResidual UniversalResidual

variable {R : Type u} [CommRing R]

/-- Pushing the determinant of the block through `C`. -/
private theorem C_det_pow (m00 m01 m10 m11 : R) :
    (C ((m00 * m11 - m01 * m10) ^ 6) : MvPolynomial (Fin 3) R) =
      (C m00 * C m11 - C m01 * C m10) ^ 6 := by
  rw [map_pow, map_sub, map_mul, map_mul]

variable (m00 m01 m10 m11 : R)

theorem residualCoeffU_of_gl2 (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hF : IsBidegree23 F) :
    residualCoeffU_of (secondBlockSubst (gl2Matrix3 m00 m01 m10 m11) F) =
      C ((m00 * m11 - m01 * m10) ^ 6) *
        (C m00 * residualCoeffU_of F + C m10 * residualCoeffV_of F) := by
  rw [residualCoeffU_of_eq_genericFiber, residualCoeffU_of_eq_genericFiber,
    residualCoeffV_of_eq_genericFiber, genericFiber_secondBlockSubst, gl2Matrix3_map,
    show (aeval (linearSubst 2 (gl2Matrix3 (C m00) (C m01) (C m10) (C m11))) :
        MvPolynomial (Fin 3) (MvPolynomial (Fin 3) R) →ₐ[MvPolynomial (Fin 3) R] _) =
      gl2Subst (C m00) (C m01) (C m10) (C m11) from rfl,
    PlaneCubicResidual.residualCoeffU_gl2 (C m00) (C m01) (C m10) (C m11) _
      (genericFiber_isHomogeneous F hF), C_det_pow]

theorem residualCoeffV_of_gl2 (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hF : IsBidegree23 F) :
    residualCoeffV_of (secondBlockSubst (gl2Matrix3 m00 m01 m10 m11) F) =
      C ((m00 * m11 - m01 * m10) ^ 6) *
        (C m01 * residualCoeffU_of F + C m11 * residualCoeffV_of F) := by
  rw [residualCoeffV_of_eq_genericFiber, residualCoeffU_of_eq_genericFiber,
    residualCoeffV_of_eq_genericFiber, genericFiber_secondBlockSubst, gl2Matrix3_map,
    show (aeval (linearSubst 2 (gl2Matrix3 (C m00) (C m01) (C m10) (C m11))) :
        MvPolynomial (Fin 3) (MvPolynomial (Fin 3) R) →ₐ[MvPolynomial (Fin 3) R] _) =
      gl2Subst (C m00) (C m01) (C m10) (C m11) from rfl,
    PlaneCubicResidual.residualCoeffV_gl2 (C m00) (C m01) (C m10) (C m11) _
      (genericFiber_isHomogeneous F hF), C_det_pow]

theorem residualCoeffW_of_gl2 (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hF : IsBidegree23 F) :
    residualCoeffW_of (secondBlockSubst (gl2Matrix3 m00 m01 m10 m11) F) =
      C ((m00 * m11 - m01 * m10) ^ 6) * residualCoeffW_of F := by
  rw [residualCoeffW_of_eq_genericFiber, residualCoeffW_of_eq_genericFiber,
    genericFiber_secondBlockSubst, gl2Matrix3_map,
    show (aeval (linearSubst 2 (gl2Matrix3 (C m00) (C m01) (C m10) (C m11))) :
        MvPolynomial (Fin 3) (MvPolynomial (Fin 3) R) →ₐ[MvPolynomial (Fin 3) R] _) =
      gl2Subst (C m00) (C m01) (C m10) (C m11) from rfl,
    PlaneCubicResidual.residualCoeffW_gl2 (C m00) (C m01) (C m10) (C m11) _
      (genericFiber_isHomogeneous F hF), C_det_pow]

theorem secondBlockSubst_gl2_X_inr (j : Fin 3) :
    secondBlockSubst (gl2Matrix3 m00 m01 m10 m11) (X (.inr j) :
        MvPolynomial (BiprojectiveCoordinate 2 2) R) =
      ![C m00 * X (.inr 0) + C m01 * X (.inr 1),
        C m10 * X (.inr 0) + C m11 * X (.inr 1), X (.inr 2)] j := by
  rw [secondBlockSubst_X_inr]
  fin_cases j <;>
    simp [gl2Matrix3, Fin.sum_univ_three]

/-- **The residual equation is equivariant with the unit scalar `det^6` and the block itself.**
The `Eᵀ` mixing of the coefficient triple is exactly cancelled by the block acting on the second
block of variables. -/
theorem residualEquation_gl2 (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hF : IsBidegree23 F) :
    residualEquation (secondBlockSubst (gl2Matrix3 m00 m01 m10 m11) F) =
      C ((m00 * m11 - m01 * m10) ^ 6) *
        secondBlockSubst (gl2Matrix3 m00 m01 m10 m11) (residualEquation F) := by
  simp only [residualEquation, liftSecondLinear, map_add, map_mul,
    residualCoeffU_of_gl2 m00 m01 m10 m11 F hF, residualCoeffV_of_gl2 m00 m01 m10 m11 F hF,
    residualCoeffW_of_gl2 m00 m01 m10 m11 F hF, liftFirstBlock_C_mul, liftFirstBlock_add,
    secondBlockSubst_liftFirstBlock]
  rw [secondBlockSubst_gl2_X_inr m00 m01 m10 m11 0, secondBlockSubst_gl2_X_inr m00 m01 m10 m11 1,
    secondBlockSubst_gl2_X_inr m00 m01 m10 m11 2]
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons]
  ring

end Biprojective

/-! ### Condition G3 along `L` under a change of the spanning pair -/

section G3

open ResidualDivisor

variable {k : Type u} [Field k]

/-- **The block cancels against its own inverse in the residual equation along `L`.**  Only the
unit `det^6` survives: the residual line along `L` is intrinsic up to a scalar. -/
theorem residualEquationOn_gl2
    (M N N' : Matrix (Fin 3) (Fin 3) k) (m00 m01 m10 m11 : k)
    (hEN : gl2Matrix3 m00 m01 m10 m11 * N' = N)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    residualEquationOn (M * gl2Matrix3 m00 m01 m10 m11) N' F =
      C ((m00 * m11 - m01 * m10) ^ 6) * residualEquationOn M N F := by
  rw [residualEquationOn, ← secondBlockSubst_secondBlockSubst,
    residualEquation_gl2 m00 m01 m10 m11 _ (isBidegree23_secondBlockSubst _ hF), map_mul,
    secondBlockSubst_secondBlockSubst, hEN, residualEquationOn]
  congr 1
  simp

theorem residualLineCoeffOn_gl2
    (M N N' : Matrix (Fin 3) (Fin 3) k) (m00 m01 m10 m11 : k)
    (hEN : gl2Matrix3 m00 m01 m10 m11 * N' = N)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (a : Fin 3) :
    residualLineCoeffOn (M * gl2Matrix3 m00 m01 m10 m11) N' F a =
      C ((m00 * m11 - m01 * m10) ^ 6) * residualLineCoeffOn M N F a := by
  rw [residualLineCoeffOn, residualEquationOn_gl2 M N N' m00 m01 m10 m11 hEN F hF,
    secondBlockCoeff_C_mul, residualLineCoeffOn]

/-- **G3 along `L` is invariant under a change of the spanning pair.**  The mixing is a pure unit
scalar — in particular `x`-independent — so the rank-`≤1` condition transports both ways. -/
theorem residualLineConstantOn_gl2_iff
    (M N N' : Matrix (Fin 3) (Fin 3) k) (m00 m01 m10 m11 : k)
    (hdet : m00 * m11 - m01 * m10 ≠ 0)
    (hEN : gl2Matrix3 m00 m01 m10 m11 * N' = N)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    ResidualLineConstantOn (M * gl2Matrix3 m00 m01 m10 m11) N' F ↔
      ResidualLineConstantOn M N F := by
  have hcoeff := residualLineCoeffOn_gl2 M N N' m00 m01 m10 m11 hEN F hF
  have hu : ((m00 * m11 - m01 * m10) ^ 6) ≠ 0 := pow_ne_zero 6 hdet
  constructor
  · rintro ⟨G0, c, hc⟩
    refine ⟨G0, fun a => ((m00 * m11 - m01 * m10) ^ 6)⁻¹ * c a, fun a => ?_⟩
    have h := hc a
    rw [hcoeff a] at h
    have hback : residualLineCoeffOn M N F a =
        C (((m00 * m11 - m01 * m10) ^ 6)⁻¹) *
          (C ((m00 * m11 - m01 * m10) ^ 6) * residualLineCoeffOn M N F a) := by
      rw [← mul_assoc, ← C_mul, inv_mul_cancel₀ hu, C_1, one_mul]
    rw [hback, h, ← mul_assoc, ← C_mul]
  · rintro ⟨G0, c, hc⟩
    refine ⟨G0, fun a => (m00 * m11 - m01 * m10) ^ 6 * c a, fun a => ?_⟩
    rw [hcoeff a, hc a, ← mul_assoc, ← C_mul]

theorem residualLineNonconstantOn_gl2_iff
    (M N N' : Matrix (Fin 3) (Fin 3) k) (m00 m01 m10 m11 : k)
    (hdet : m00 * m11 - m01 * m10 ≠ 0)
    (hEN : gl2Matrix3 m00 m01 m10 m11 * N' = N)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    ResidualLineNonconstantOn (M * gl2Matrix3 m00 m01 m10 m11) N' F ↔
      ResidualLineNonconstantOn M N F :=
  not_congr (residualLineConstantOn_gl2_iff M N N' m00 m01 m10 m11 hdet hEN F hF)

/-- The new inverse is forced: `E * N' = N`. -/
theorem gl2_mul_inv_eq
    (p q r p' q' : Fin 3 → k) (N N' : Matrix (Fin 3) (Fin 3) k) (a b c d : k)
    (hp' : ∀ i, p' i = a * p i + b * q i) (hq' : ∀ i, q' i = c * p i + d * q i)
    (hMN : lineFrame p q r * N = 1)
    (hMN' : lineFrame p' q' r * N' = 1) :
    gl2Matrix3 a c b d * N' = N := by
  have hNM : N * lineFrame p q r = 1 := mul_eq_one_comm.mp hMN
  rw [lineFrame_gl2_of_eq p q r p' q' a b c d hp' hq'] at hMN'
  calc gl2Matrix3 a c b d * N'
      = (N * lineFrame p q r) * (gl2Matrix3 a c b d * N') := by rw [hNM, one_mul]
    _ = N * (lineFrame p q r * gl2Matrix3 a c b d * N') := by simp only [Matrix.mul_assoc]
    _ = N := by rw [hMN', mul_one]

/-- **F-3 endpoint: `ResidualLineNonconstantOn` is invariant under an arbitrary invertible change
of the spanning pair of `L`.**  The completion `r` is unchanged; the inverse `N'` is any inverse of
the new frame (`E⁻¹ * N` is one).  Stated pointwise in `p'`, `q'` so that it applies verbatim to the
three elementary shapes. -/
theorem residualLineNonconstantOn_pair_change_of_eq
    (p q r p' q' : Fin 3 → k) (N N' : Matrix (Fin 3) (Fin 3) k) (a b c d : k)
    (hp' : ∀ i, p' i = a * p i + b * q i) (hq' : ∀ i, q' i = c * p i + d * q i)
    (hA : a * d - b * c ≠ 0)
    (hMN : lineFrame p q r * N = 1)
    (hMN' : lineFrame p' q' r * N' = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (h : ResidualLineNonconstantOn (lineFrame p q r) N F) :
    ResidualLineNonconstantOn (lineFrame p' q' r) N' F := by
  rw [lineFrame_gl2_of_eq p q r p' q' a b c d hp' hq']
  refine (residualLineNonconstantOn_gl2_iff (lineFrame p q r) N N' a c b d ?_
    (gl2_mul_inv_eq p q r p' q' N N' a b c d hp' hq' hMN hMN') F hF).mpr h
  intro h0
  exact hA (by linear_combination h0)

/-- **F-3 endpoint, literal form.** -/
theorem residualLineNonconstantOn_pair_change
    (p q r : Fin 3 → k) (N N' : Matrix (Fin 3) (Fin 3) k) (a b c d : k)
    (hA : a * d - b * c ≠ 0)
    (hMN : lineFrame p q r * N = 1)
    (hMN' : lineFrame (fun i => a * p i + b * q i) (fun i => c * p i + d * q i) r * N' = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (h : ResidualLineNonconstantOn (lineFrame p q r) N F) :
    ResidualLineNonconstantOn
      (lineFrame (fun i => a * p i + b * q i) (fun i => c * p i + d * q i) r) N' F :=
  residualLineNonconstantOn_pair_change_of_eq p q r _ _ N N' a b c d (fun _ => rfl) (fun _ => rfl)
    hA hMN hMN' F hF h

/-! ### The three generator laws

Recorded separately: they are the shape in which the transports compose with F-1's, and they make
the three units explicit.  `det` is `1`, `αδ` and `−1`, so the units are `1`, `(αδ)^6` and `1`:
only the scale move twists the residual-line coefficient triple at all. -/

/-- **Shear coefficient law**: unit `1^6 = 1`, no twist whatsoever. -/
theorem residualLineCoeffOn_shear
    (M N N' : Matrix (Fin 3) (Fin 3) k) (β : k)
    (hEN : shearFrame3 β * N' = N)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (a : Fin 3) :
    residualLineCoeffOn (M * shearFrame3 β) N' F a = residualLineCoeffOn M N F a := by
  rw [shearFrame3_eq_gl2] at hEN ⊢
  rw [residualLineCoeffOn_gl2 M N N' 1 0 β 1 hEN F hF a]
  norm_num

/-- **Scale coefficient law**: unit `(αδ)^6` — the only generator with a nontrivial twist. -/
theorem residualLineCoeffOn_scale
    (M N N' : Matrix (Fin 3) (Fin 3) k) (α δ : k)
    (hEN : scaleFrame3 α δ * N' = N)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (a : Fin 3) :
    residualLineCoeffOn (M * scaleFrame3 α δ) N' F a =
      C ((α * δ) ^ 6) * residualLineCoeffOn M N F a := by
  rw [scaleFrame3_eq_gl2] at hEN ⊢
  rw [residualLineCoeffOn_gl2 M N N' α 0 0 δ hEN F hF a]
  norm_num

/-- **Swap coefficient law**: unit `(−1)^6 = 1`; the block exchanges `(1,0,0)` and `(0,1,0)`, and
the exchange of `q_U` with `q_V` is undone by the inverse substitution. -/
theorem residualLineCoeffOn_swap
    (M N N' : Matrix (Fin 3) (Fin 3) k)
    (hEN : swapFrame3 * N' = N)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (a : Fin 3) :
    residualLineCoeffOn (M * swapFrame3) N' F a = residualLineCoeffOn M N F a := by
  rw [swapFrame3_eq_gl2] at hEN ⊢
  rw [residualLineCoeffOn_gl2 M N N' 0 1 1 0 hEN F hF a]
  norm_num

/-- **Shear** `(p,q) ↦ (p + β•q, q)`: block `!![1,0,0; β,1,0; 0,0,1]`, `det = 1`, unit `1`. -/
theorem residualLineNonconstantOn_shear
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (β : k)
    (hMN : lineFrame p q r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (h : ResidualLineNonconstantOn (lineFrame p q r) N F) :
    ResidualLineNonconstantOn (lineFrame (fun i => p i + β * q i) q r)
      (shearFrame3 (-β) * N) F :=
  residualLineNonconstantOn_pair_change_of_eq p q r _ _ N _ 1 β 0 1
    (fun i => by ring) (fun i => by ring) (by norm_num) hMN
    (lineFrame_mul_shear_inv p q r N β hMN) F hF h

/-- **Scale** `(p,q) ↦ (α•p, δ•q)`: block `!![α,0,0; 0,δ,0; 0,0,1]`, `det = αδ`, unit `(αδ)^6`. -/
theorem residualLineNonconstantOn_scale
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (α δ : k) (hα : α ≠ 0) (hδ : δ ≠ 0)
    (hMN : lineFrame p q r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (h : ResidualLineNonconstantOn (lineFrame p q r) N F) :
    ResidualLineNonconstantOn (lineFrame (fun i => α * p i) (fun i => δ * q i) r)
      (scaleFrame3 α⁻¹ δ⁻¹ * N) F :=
  residualLineNonconstantOn_pair_change_of_eq p q r _ _ N _ α 0 0 δ
    (fun i => by ring) (fun i => by ring) (by simpa using mul_ne_zero hα hδ) hMN
    (lineFrame_mul_scale_inv p q r N α δ hα hδ hMN) F hF h

/-- **Swap** `(p,q) ↦ (q,p)`: block `!![0,1,0; 1,0,0; 0,0,1]`, `det = -1`, unit `1`. -/
theorem residualLineNonconstantOn_swap
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p q r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (h : ResidualLineNonconstantOn (lineFrame p q r) N F) :
    ResidualLineNonconstantOn (lineFrame q p r) (swapFrame3 * N) F :=
  residualLineNonconstantOn_pair_change_of_eq p q r _ _ N _ 0 1 1 0
    (fun i => by ring) (fun i => by ring) (by norm_num) hMN
    (lineFrame_mul_swap_inv p q r N hMN) F hF h

end G3

/-! ### F-3 endpoint: the complete good-line package under a pair change

F-1 transported the discriminant, the isotropic section and G4; this module transported G3.  The
two transports use the *same* completion `r` and the *same* adjusted inverse `N'` for each
generator, so they compose with no extra work. -/

section FullBundle

variable {k : Type u} [Field k]

/-- `HasGoodLineWithSection` is the frame identity, G3, and F-1's partial package. -/
theorem hasGoodLineWithSection_iff
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (v : Fin 3 → Polynomial k) :
    Standard.HasGoodLineWithSection F p q r N v ↔
      lineFrame p q r * N = 1 ∧ ResidualLineNonconstantOn (lineFrame p q r) N F ∧
        HasGoodLineSectionPartial F p q r N v := Iff.rfl

/-- The complete good-line package, as a property of the pair `(p,q)` spanning `L`: the
completion, the frame inverse and the section are absorbed by the existential. -/
def GoodPairFull (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (p q : Fin 3 → k) : Prop :=
  ∃ (r' : Fin 3 → k) (N' : Matrix (Fin 3) (Fin 3) k) (v' : Fin 3 → Polynomial k),
    Standard.HasGoodLineWithSection F p q r' N' v'

/-- **Pair change of the full package.**  Combines F-1's three elementary transports with the
three G3 transports of this module. -/
theorem goodPairFull_pair_change
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (a b c d : k) (hA : a * d - b * c ≠ 0)
    (p q : Fin 3 → k) (h : GoodPairFull F p q) :
    GoodPairFull F (fun i => a * p i + b * q i) (fun i => c * p i + d * q i) := by
  refine pair_property_of_elemGL2_invariant (GoodPairFull F) ?_ ?_ ?_ a b c d hA p q h
  · rintro p0 q0 β ⟨r0, N0, v0, hpk⟩
    obtain ⟨hMN, hG3, hpart⟩ := (hasGoodLineWithSection_iff F p0 q0 r0 N0 v0).mp hpk
    exact ⟨r0, shearFrame3 (-β) * N0, _,
      (hasGoodLineWithSection_iff F _ _ _ _ _).mpr
        ⟨lineFrame_mul_shear_inv p0 q0 r0 N0 β hMN,
          residualLineNonconstantOn_shear p0 q0 r0 N0 β hMN F hF hG3,
          hasGoodLineSectionPartial_shear_auto F hF p0 q0 r0 N0 β hMN v0 hpart⟩⟩
  · rintro p0 q0 α δ hα hδ ⟨r0, N0, v0, hpk⟩
    obtain ⟨hMN, hG3, hpart⟩ := (hasGoodLineWithSection_iff F p0 q0 r0 N0 v0).mp hpk
    exact ⟨r0, scaleFrame3 α⁻¹ δ⁻¹ * N0, _,
      (hasGoodLineWithSection_iff F _ _ _ _ _).mpr
        ⟨lineFrame_mul_scale_inv p0 q0 r0 N0 α δ hα hδ hMN,
          residualLineNonconstantOn_scale p0 q0 r0 N0 α δ hα hδ hMN F hF hG3,
          hasGoodLineSectionPartial_scale_auto F hF p0 q0 r0 N0 α δ hα hδ hMN v0 hpart⟩⟩
  · rintro p0 q0 ⟨r0, N0, v0, hpk⟩
    obtain ⟨hMN, hG3, hpart⟩ := (hasGoodLineWithSection_iff F p0 q0 r0 N0 v0).mp hpk
    exact ⟨r0, swapFrame3 * N0, _,
      (hasGoodLineWithSection_iff F _ _ _ _ _).mpr
        ⟨lineFrame_mul_swap_inv p0 q0 r0 N0 hMN,
          residualLineNonconstantOn_swap p0 q0 r0 N0 hMN F hF hG3,
          hasGoodLineSectionPartial_swap_auto F hF p0 q0 r0 N0 hMN
            (Finset.univ.sup fun i : Fin 3 => (v0 i).natDegree) v0
            (fun i => Finset.le_sup (f := fun i : Fin 3 => (v0 i).natDegree)
              (Finset.mem_univ i)) hpart⟩⟩

/-- **F-3 full-bundle endpoint.**  The *complete* good-line package — frame identity, condition
G3, the line discriminant, the nonzero isotropic section and condition G4 — survives an arbitrary
invertible change of the pair spanning the multisection line `L`.  The completion, the frame
inverse and the section are absorbed by the existential, exactly as in F-1. -/
theorem hasGoodLineWithSection_pair_change
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (v : Fin 3 → Polynomial k)
    (a b c d : k) (hA : a * d - b * c ≠ 0)
    (h : Standard.HasGoodLineWithSection F p q r N v) :
    ∃ (r' : Fin 3 → k) (N' : Matrix (Fin 3) (Fin 3) k) (v' : Fin 3 → Polynomial k),
      Standard.HasGoodLineWithSection F (fun i => a * p i + b * q i)
        (fun i => c * p i + d * q i) r' N' v' :=
  goodPairFull_pair_change F hF a b c d hA p q ⟨r, N, v, h⟩

end FullBundle

end

end BConicBundleMultisections
