/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.LineCompletionChange
public import BConicBundleMultisections.ResidualLineBasePointFree
public import BConicBundleMultisections.ResidualEquationLine

/-!
# Condition G3 under a change of completion (Goal F-2, G3 half)

`LineCompletionChange` transported the residual-`Y` chain (condition G4) through a change of the
frame completion `r ↦ e•p + f•q + g•r`.  This module does the same for **G3**,
`ResidualLineNonconstantOn`, which — unlike the discriminant and the isotropy — really does mention
the frame.

## The law

The completion block `E = !![1,0,e; 0,1,f; 0,0,g]` acts on the second block by
`Y₀ ↦ Y₀ + e·Y₂`, `Y₁ ↦ Y₁ + f·Y₂`, `Y₂ ↦ g·Y₂`, i.e. it preserves the line `{Y₂ = 0}`.  The
residual equation is equivariant with a **pure unit scalar**:

```
residualEquation (secondBlockSubst E H) = C (g²) · secondBlockSubst E (residualEquation H)
```

and since the new inverse satisfies `E * N' = N`, the two substitutions cancel:

```
residualEquationOn (M*E) N' F = C (g²) · residualEquationOn M N F.
```

So the residual-line coefficient triple is multiplied by the single unit `g²` — an `x`-independent
scalar matrix — and the rank-`≤1` condition defining `ResidualLineConstantOn` is preserved in both
directions.  There is **no** matrix mixing of the triple: the `E`-twist on the coefficients and the
`E⁻¹`-twist on the substitution cancel exactly.

## Per-stage twists

| stage | twist |
|---|---|
| `coeffU3/U2V/UV2/V3` (the line-restricted binary cubic) | **unchanged** |
| `coeffU2W` | `3a·e + b·f + g·coeffU2W` |
| `coeffUVW` | `2b·e + 2c·f + g·coeffUVW` |
| `coeffV2W` | `c·e + 3d·f + g·coeffV2W` |
| `polarQuadA/B/C` | argument moves to `(U+eW, V+fW, gW)` |
| `residualCoeffU_of`, `residualCoeffV_of` | `C (g²) ·` |
| `residualCoeffW_of` | `C (g²)·(e·U + f·V + g·W)` |
| `residualEquationOn`, `residualLineCoeffOn` | `C (g²) ·` (the `E`/`E⁻¹` twists cancel) |

`IsBidegree23 F` is assumed throughout — it is what makes the generic fibre a homogeneous cubic.

## Route

The identity is proved on plane cubics and transported by the generic fibre.  On plane cubics it
comes from the universal residual identity `residual_identity_eval`
(`polarResultant + Δ·f = W²·q_f`), because

* `polarResultant` sees the cubic only through the three polar-quadratic coefficients
  `polarQuadA/B/C`, and those transform *exactly* as the polar of `E`-transformed argument;
* the value `f(y)` transforms by `eval y (f ∘ E) = eval (E *ᵥ y) f` for free.

Evaluating at `W = 1` removes the `W²` and three choices of `(U,V)` separate the three
coefficients.  The seven coefficients that enter `polarResultant` are read off by evaluating `f`
and its partials at `(1,0,0)`, `(0,1,0)`, `(1,1,0)` — all points of the line `{Y₂ = 0}`, which `E`
fixes.  No division by `2` or `3` occurs anywhere, so nothing is assumed about the characteristic.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial Finsupp
open _root_.MvPolynomial
open scoped _root_.Matrix

namespace PlaneCubicResidual

variable {R : Type u} [CommRing R]

/-! ### Reading the seven line-adapted coefficients off the line `{Y₂ = 0}`

All seven coefficients that enter `polarResultant` are integer combinations of values of `G` and
its three partials at the three points `(1,0,0)`, `(0,1,0)`, `(1,1,0)` of the line `{Y₂ = 0}`.
No division occurs, so the characteristic is unconstrained. -/

theorem coeffU3_eq_eval (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffU3 G = eval ![1, 0, 0] G := by
  rw [eval_eq_planeCubicValue hG]
  simp [UniversalResidual.planeCubicValue]

theorem coeffV3_eq_eval (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffV3 G = eval ![0, 1, 0] G := by
  rw [eval_eq_planeCubicValue hG]
  simp [UniversalResidual.planeCubicValue]

theorem eval_pderiv0_at_e0 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    eval ![1, 0, 0] (pderiv 0 G) = 3 * coeffU3 G := by
  rw [eval_pderiv0_planeCubic G hG]; simp

theorem eval_pderiv1_at_e0 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    eval ![1, 0, 0] (pderiv 1 G) = coeffU2V G := by
  rw [eval_pderiv1_planeCubic G hG]; simp

theorem eval_pderiv2_at_e0 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    eval ![1, 0, 0] (pderiv 2 G) = coeffU2W G := by
  rw [eval_pderiv2_planeCubic G hG]; simp

theorem eval_pderiv0_at_e1 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    eval ![0, 1, 0] (pderiv 0 G) = coeffUV2 G := by
  rw [eval_pderiv0_planeCubic G hG]; simp

theorem eval_pderiv1_at_e1 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    eval ![0, 1, 0] (pderiv 1 G) = 3 * coeffV3 G := by
  rw [eval_pderiv1_planeCubic G hG]; simp

theorem eval_pderiv2_at_e1 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    eval ![0, 1, 0] (pderiv 2 G) = coeffV2W G := by
  rw [eval_pderiv2_planeCubic G hG]; simp

theorem eval_pderiv0_at_e01 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    eval ![1, 1, 0] (pderiv 0 G) =
      3 * coeffU3 G + 2 * coeffU2V G + coeffUV2 G := by
  rw [eval_pderiv0_planeCubic G hG]; simp

theorem eval_pderiv1_at_e01 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    eval ![1, 1, 0] (pderiv 1 G) =
      coeffU2V G + 2 * coeffUV2 G + 3 * coeffV3 G := by
  rw [eval_pderiv1_planeCubic G hG]; simp

theorem eval_pderiv2_at_e01 (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    eval ![1, 1, 0] (pderiv 2 G) =
      coeffU2W G + coeffUVW G + coeffV2W G := by
  rw [eval_pderiv2_planeCubic G hG]; simp

/-! ### The seven coefficients under a completion substitution -/

/-- `E` fixes every point of the line `{Y₂ = 0}`. -/
theorem completionMatrix3_mulVec_of_last_zero (u w s a b : R) :
    completionMatrix3 u w s *ᵥ ![a, b, (0 : R)] = ![a, b, 0] := by
  rw [completionMatrix3_mulVec_vec]
  funext i
  fin_cases i <;> simp

/-- On the line `{Y₂ = 0}` the gradient of `G ∘ E` is `Eᵀ` applied to the gradient of `G`. -/
theorem tangentGradient_completion_of_last_zero
    (G : MvPolynomial (Fin 3) R) (u w s a b : R) :
    tangentGradient
        ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G) ![a, b, 0] =
      (completionMatrix3 u w s).transpose *ᵥ tangentGradient G ![a, b, (0 : R)] := by
  rw [tangentGradient_aeval_linearSubst, completionMatrix3_mulVec_of_last_zero]

variable (u w s : R)

theorem coeffU3_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffU3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
        MvPolynomial (Fin 3) R →ₐ[R] _) G) = coeffU3 G := by
  rw [coeffU3_eq_eval _ (isHomogeneous_aeval_linearSubst _ hG), eval_aeval_linearSubst,
    completionMatrix3_mulVec_of_last_zero, ← coeffU3_eq_eval G hG]

theorem coeffV3_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffV3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
        MvPolynomial (Fin 3) R →ₐ[R] _) G) = coeffV3 G := by
  rw [coeffV3_eq_eval _ (isHomogeneous_aeval_linearSubst _ hG), eval_aeval_linearSubst,
    completionMatrix3_mulVec_of_last_zero, ← coeffV3_eq_eval G hG]

theorem coeffU2V_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffU2V ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
        MvPolynomial (Fin 3) R →ₐ[R] _) G) = coeffU2V G := by
  have hG' : ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
      MvPolynomial (Fin 3) R →ₐ[R] _) G).IsHomogeneous 3 :=
    isHomogeneous_aeval_linearSubst _ hG
  have h := congrFun (tangentGradient_completion_of_last_zero G u w s 1 0) 1
  rw [completionMatrix3_transpose_mulVec] at h
  simp only [tangentGradient, Matrix.cons_val_one] at h
  rw [eval_pderiv1_at_e0 _ hG', eval_pderiv1_at_e0 G hG] at h
  exact h

theorem coeffUV2_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffUV2 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
        MvPolynomial (Fin 3) R →ₐ[R] _) G) = coeffUV2 G := by
  have hG' : ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
      MvPolynomial (Fin 3) R →ₐ[R] _) G).IsHomogeneous 3 :=
    isHomogeneous_aeval_linearSubst _ hG
  have h := congrFun (tangentGradient_completion_of_last_zero G u w s 0 1) 0
  rw [completionMatrix3_transpose_mulVec] at h
  simp only [tangentGradient, Matrix.cons_val_zero] at h
  rw [eval_pderiv0_at_e1 _ hG', eval_pderiv0_at_e1 G hG] at h
  exact h

theorem coeffU2W_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffU2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
        MvPolynomial (Fin 3) R →ₐ[R] _) G) =
      3 * coeffU3 G * u + coeffU2V G * w + s * coeffU2W G := by
  have h := congrFun (tangentGradient_completion_of_last_zero G u w s 1 0) 2
  rw [completionMatrix3_transpose_mulVec] at h
  simp only [tangentGradient, Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons] at h
  rw [eval_pderiv2_at_e0 _ (isHomogeneous_aeval_linearSubst (completionMatrix3 u w s) hG)] at h
  rw [eval_pderiv0_at_e0 G hG, eval_pderiv1_at_e0 G hG, eval_pderiv2_at_e0 G hG] at h
  rw [h]; ring

theorem coeffV2W_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffV2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
        MvPolynomial (Fin 3) R →ₐ[R] _) G) =
      coeffUV2 G * u + 3 * coeffV3 G * w + s * coeffV2W G := by
  have h := congrFun (tangentGradient_completion_of_last_zero G u w s 0 1) 2
  rw [completionMatrix3_transpose_mulVec] at h
  simp only [tangentGradient, Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons] at h
  rw [eval_pderiv2_at_e1 _ (isHomogeneous_aeval_linearSubst (completionMatrix3 u w s) hG)] at h
  rw [eval_pderiv0_at_e1 G hG, eval_pderiv1_at_e1 G hG, eval_pderiv2_at_e1 G hG] at h
  rw [h]; ring

theorem coeffUVW_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    coeffUVW ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
        MvPolynomial (Fin 3) R →ₐ[R] _) G) =
      2 * coeffU2V G * u + 2 * coeffUV2 G * w + s * coeffUVW G := by
  have hG' : ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
      MvPolynomial (Fin 3) R →ₐ[R] _) G).IsHomogeneous 3 :=
    isHomogeneous_aeval_linearSubst _ hG
  have h := congrFun (tangentGradient_completion_of_last_zero G u w s 1 1) 2
  rw [completionMatrix3_transpose_mulVec] at h
  simp only [tangentGradient, Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons] at h
  rw [eval_pderiv2_at_e01 _ hG'] at h
  rw [eval_pderiv0_at_e01 G hG, eval_pderiv1_at_e01 G hG, eval_pderiv2_at_e01 G hG] at h
  rw [coeffU2W_completion u w s G hG, coeffV2W_completion u w s G hG] at h
  linear_combination h

/-! ### The polar quadratic and the residual line -/

open UniversalResidual

/-- The polar-quadratic coefficients transform by transporting the argument point.  This is the
whole content of the completion equivariance: `polarResultant` sees the cubic only through
`polarQuadA/B/C`. -/
theorem polarQuadA_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (U V W : R) :
    polarQuadA (coeffU3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffU2V ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffU2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G)) U V W =
      polarQuadA (coeffU3 G) (coeffU2V G) (coeffU2W G) (U + u * W) (V + w * W) (s * W) := by
  rw [coeffU3_completion u w s G hG, coeffU2V_completion u w s G hG,
    coeffU2W_completion u w s G hG]
  simp only [polarQuadA]; ring

theorem polarQuadB_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (U V W : R) :
    polarQuadB (coeffU2V ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffUV2 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffUVW ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G)) U V W =
      polarQuadB (coeffU2V G) (coeffUV2 G) (coeffUVW G) (U + u * W) (V + w * W) (s * W) := by
  rw [coeffU2V_completion u w s G hG, coeffUV2_completion u w s G hG,
    coeffUVW_completion u w s G hG]
  simp only [polarQuadB]; ring

theorem polarQuadC_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (U V W : R) :
    polarQuadC (coeffUV2 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffV3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffV2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G)) U V W =
      polarQuadC (coeffUV2 G) (coeffV3 G) (coeffV2W G) (U + u * W) (V + w * W) (s * W) := by
  rw [coeffUV2_completion u w s G hG, coeffV3_completion u w s G hG,
    coeffV2W_completion u w s G hG]
  simp only [polarQuadC]; ring

/-- `polarResultant` depends on `(e,f,hh,U,V,W)` only through the three polar-quadratic
coefficients. -/
theorem polarResultant_congr (a b c d e f hh U V W e' f' hh' U' V' W' : R)
    (hA : polarQuadA a b e' U V W = polarQuadA a b e U' V' W')
    (hB : polarQuadB b c f' U V W = polarQuadB b c f U' V' W')
    (hC : polarQuadC c d hh' U V W = polarQuadC c d hh U' V' W') :
    polarResultant a b c d e' f' hh' U V W = polarResultant a b c d e f hh U' V' W' := by
  simp only [polarResultant, hA, hB, hC]

theorem polarResultant_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (U V W : R) :
    polarResultant (coeffU3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffU2V ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffUV2 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffV3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffU2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffUVW ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffV2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G)) U V W =
      polarResultant (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
        (coeffU2W G) (coeffUVW G) (coeffV2W G) (U + u * W) (V + w * W) (s * W) := by
  rw [coeffU3_completion u w s G hG, coeffU2V_completion u w s G hG,
    coeffUV2_completion u w s G hG, coeffV3_completion u w s G hG]
  refine polarResultant_congr _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ?_ ?_ ?_
  · have h := polarQuadA_completion u w s G hG U V W
    rwa [coeffU3_completion u w s G hG, coeffU2V_completion u w s G hG] at h
  · have h := polarQuadB_completion u w s G hG U V W
    rwa [coeffU2V_completion u w s G hG, coeffUV2_completion u w s G hG] at h
  · have h := polarQuadC_completion u w s G hG U V W
    rwa [coeffUV2_completion u w s G hG, coeffV3_completion u w s G hG] at h

/-- **Master evaluation law.**  Read on the affine chart `W = 1`, the residual linear form of
`G ∘ E` at `(U,V,1)` is `s²` times that of `G` at `E *ᵥ (U,V,1) = (U+u, V+w, s)`. -/
theorem eval_residualLinearForm_completion
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (U V : R) :
    eval ![U, V, 1] (residualLinearForm ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
        MvPolynomial (Fin 3) R →ₐ[R] _) G)) =
      s ^ 2 * eval ![U + u, V + w, s] (residualLinearForm G) := by
  have hG' : ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
      MvPolynomial (Fin 3) R →ₐ[R] _) G).IsHomogeneous 3 :=
    isHomogeneous_aeval_linearSubst _ hG
  have hpt : completionMatrix3 u w s *ᵥ ![U, V, (1 : R)] = ![U + u, V + w, s] := by
    rw [completionMatrix3_mulVec_vec]
    funext i
    fin_cases i <;> simp
  have hval : eval ![U, V, (1 : R)] ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
      MvPolynomial (Fin 3) R →ₐ[R] _) G) = eval ![U + u, V + w, s] G := by
    rw [eval_aeval_linearSubst, hpt]
  have h1 := residual_identity_eval hG' ![U, V, (1 : R)]
  have h2 := residual_identity_eval hG ![U + u, V + w, s]
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons] at h1 h2
  rw [hval] at h1
  have hPR := polarResultant_completion u w s G hG U V 1
  simp only [mul_one] at hPR
  rw [hPR, coeffU3_completion u w s G hG, coeffU2V_completion u w s G hG,
    coeffUV2_completion u w s G hG, coeffV3_completion u w s G hG] at h1
  rw [h2] at h1
  simpa using h1.symm

theorem residualCoeffU_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    residualCoeffU (coeffU3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffU2V ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffUV2 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffV3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffU2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffUVW ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffV2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffUW2 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G)) =
      s ^ 2 * residualCoeffU (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
        (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffUW2 G) := by
  have h00 := eval_residualLinearForm_completion u w s G hG 0 0
  have h10 := eval_residualLinearForm_completion u w s G hG 1 0
  simp only [eval_residualLinearForm, residualLinear, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons] at h00 h10
  linear_combination h10 - h00

theorem residualCoeffV_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    residualCoeffV (coeffU3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffU2V ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffUV2 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffV3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffU2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffUVW ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffV2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffVW2 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G)) =
      s ^ 2 * residualCoeffV (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
        (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffVW2 G) := by
  have h00 := eval_residualLinearForm_completion u w s G hG 0 0
  have h01 := eval_residualLinearForm_completion u w s G hG 0 1
  simp only [eval_residualLinearForm, residualLinear, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons] at h00 h01
  linear_combination h01 - h00

theorem residualCoeffW_completion (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) :
    residualCoeffW (coeffU3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffU2V ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffUV2 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffV3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffU2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffUVW ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffV2W ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G))
        (coeffW3 ((aeval (linearSubst 2 (completionMatrix3 u w s)) :
          MvPolynomial (Fin 3) R →ₐ[R] _) G)) =
      s ^ 2 * (u * residualCoeffU (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
            (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffUW2 G) +
          w * residualCoeffV (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
            (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffVW2 G) +
          s * residualCoeffW (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
            (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffW3 G)) := by
  have h00 := eval_residualLinearForm_completion u w s G hG 0 0
  simp only [eval_residualLinearForm, residualLinear, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons] at h00
  linear_combination h00

end PlaneCubicResidual

/-! ### From plane cubics to the biprojective residual equation -/

section Biprojective

open ResidualDivisor PlaneCubicResidual UniversalResidual

variable {R : Type u} [CommRing R]

/-- The **generic plane-cubic fibre**: specialise the first block at its own generic point.
It carries exactly the second-block coefficient data of `F`, with no loss. -/
def genericFiber (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    MvPolynomial (Fin 3) (MvPolynomial (Fin 3) R) :=
  specializeFirstCoordinates (n := 2) (fun i => (X i : MvPolynomial (Fin 3) R))
    (map (C : R →+* MvPolynomial (Fin 3) R) F)

private theorem eval_X_map_C (P : MvPolynomial (Fin 3) R) :
    eval (fun i => (X i : MvPolynomial (Fin 3) R))
      (map (C : R →+* MvPolynomial (Fin 3) R) P) = P := by
  induction P using MvPolynomial.induction_on with
  | C a => simp
  | add p q hp hq => simp [hp, hq]
  | mul_X p i hp => simp [hp]

/-- Second-block coefficients are the coefficients of the generic fibre. -/
theorem secondBlockCoeff_eq_coeff_genericFiber
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (m : Fin 3 →₀ ℕ) :
    secondBlockCoeff F m = coeff m (genericFiber F) := by
  rw [genericFiber, ← eval_secondBlockCoeff (map (C : R →+* MvPolynomial (Fin 3) R) F) m,
    map_secondBlockCoeff, eval_X_map_C]

theorem genericFiber_secondBlockSubst (M : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    genericFiber (secondBlockSubst M F) =
      (aeval (linearSubst 2 (M.map (C : R →+* MvPolynomial (Fin 3) R))) :
        MvPolynomial (Fin 3) (MvPolynomial (Fin 3) R) →ₐ[MvPolynomial (Fin 3) R] _)
        (genericFiber F) := by
  rw [genericFiber, map_secondBlockSubst_eq, specializeFirstCoordinates_secondBlockSubst,
    genericFiber]

theorem genericFiber_isHomogeneous (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hF : IsBidegree23 F) : (genericFiber F).IsHomogeneous 3 :=
  (hF.map_coefficients (C : R →+* MvPolynomial (Fin 3) R)).specializeFirstCoordinates_isHomogeneous
    _

theorem residualCoeffU_of_eq_genericFiber (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    residualCoeffU_of F =
      residualCoeffU (coeffU3 (genericFiber F)) (coeffU2V (genericFiber F))
        (coeffUV2 (genericFiber F)) (coeffV3 (genericFiber F)) (coeffU2W (genericFiber F))
        (coeffUVW (genericFiber F)) (coeffV2W (genericFiber F)) (coeffUW2 (genericFiber F)) := by
  simp only [residualCoeffU_of, cubicCoefficients, secondBlockCoeff_eq_coeff_genericFiber]
  rfl

theorem residualCoeffV_of_eq_genericFiber (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    residualCoeffV_of F =
      residualCoeffV (coeffU3 (genericFiber F)) (coeffU2V (genericFiber F))
        (coeffUV2 (genericFiber F)) (coeffV3 (genericFiber F)) (coeffU2W (genericFiber F))
        (coeffUVW (genericFiber F)) (coeffV2W (genericFiber F)) (coeffVW2 (genericFiber F)) := by
  simp only [residualCoeffV_of, cubicCoefficients, secondBlockCoeff_eq_coeff_genericFiber]
  rfl

theorem residualCoeffW_of_eq_genericFiber (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    residualCoeffW_of F =
      residualCoeffW (coeffU3 (genericFiber F)) (coeffU2V (genericFiber F))
        (coeffUV2 (genericFiber F)) (coeffV3 (genericFiber F)) (coeffU2W (genericFiber F))
        (coeffUVW (genericFiber F)) (coeffV2W (genericFiber F)) (coeffW3 (genericFiber F)) := by
  simp only [residualCoeffW_of, cubicCoefficients, secondBlockCoeff_eq_coeff_genericFiber]
  rfl

variable (e f g : R)

theorem residualCoeffU_of_completion (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hF : IsBidegree23 F) :
    residualCoeffU_of (secondBlockSubst (completionMatrix3 e f g) F) =
      C (g ^ 2) * residualCoeffU_of F := by
  rw [residualCoeffU_of_eq_genericFiber, residualCoeffU_of_eq_genericFiber,
    genericFiber_secondBlockSubst, completionMatrix3_map,
    PlaneCubicResidual.residualCoeffU_completion (C e) (C f) (C g) _
      (genericFiber_isHomogeneous F hF), map_pow]

theorem residualCoeffV_of_completion (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hF : IsBidegree23 F) :
    residualCoeffV_of (secondBlockSubst (completionMatrix3 e f g) F) =
      C (g ^ 2) * residualCoeffV_of F := by
  rw [residualCoeffV_of_eq_genericFiber, residualCoeffV_of_eq_genericFiber,
    genericFiber_secondBlockSubst, completionMatrix3_map,
    PlaneCubicResidual.residualCoeffV_completion (C e) (C f) (C g) _
      (genericFiber_isHomogeneous F hF), map_pow]

theorem residualCoeffW_of_completion (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hF : IsBidegree23 F) :
    residualCoeffW_of (secondBlockSubst (completionMatrix3 e f g) F) =
      C (g ^ 2) * (C e * residualCoeffU_of F + C f * residualCoeffV_of F +
        C g * residualCoeffW_of F) := by
  rw [residualCoeffW_of_eq_genericFiber, residualCoeffU_of_eq_genericFiber,
    residualCoeffV_of_eq_genericFiber, residualCoeffW_of_eq_genericFiber,
    genericFiber_secondBlockSubst, completionMatrix3_map,
    PlaneCubicResidual.residualCoeffW_completion (C e) (C f) (C g) _
      (genericFiber_isHomogeneous F hF), map_pow]

/-! ### The residual equation under a completion substitution -/

theorem secondBlockSubst_liftFirstBlock (M : Matrix (Fin 3) (Fin 3) R)
    (P : MvPolynomial (Fin 3) R) :
    secondBlockSubst M (liftFirstBlock P) = liftFirstBlock P := by
  have h : (secondBlockSubst M).comp
      (rename Sum.inl : MvPolynomial (Fin 3) R →ₐ[R] MvPolynomial (BiprojectiveCoordinate 2 2) R)
      = rename Sum.inl := by
    refine MvPolynomial.algHom_ext fun i => ?_
    simp
  exact DFunLike.congr_fun h P

theorem liftFirstBlock_C_mul (c : R) (P : MvPolynomial (Fin 3) R) :
    liftFirstBlock (C c * P) = C c * liftFirstBlock (R := R) P := by
  simp [liftFirstBlock]

theorem liftFirstBlock_add (P Q : MvPolynomial (Fin 3) R) :
    liftFirstBlock (P + Q) = liftFirstBlock (R := R) P + liftFirstBlock Q := by
  simp [liftFirstBlock]

theorem secondBlockSubst_completion_X_inr (j : Fin 3) :
    secondBlockSubst (completionMatrix3 e f g) (X (.inr j) :
        MvPolynomial (BiprojectiveCoordinate 2 2) R) =
      ![X (.inr 0) + C e * X (.inr 2), X (.inr 1) + C f * X (.inr 2),
        C g * X (.inr 2)] j := by
  rw [secondBlockSubst_X_inr]
  fin_cases j <;>
    simp [completionMatrix3, Fin.sum_univ_three]

/-- **The residual equation is equivariant with the unit scalar `g²`.** -/
theorem residualEquation_completion (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hF : IsBidegree23 F) :
    residualEquation (secondBlockSubst (completionMatrix3 e f g) F) =
      C (g ^ 2) * secondBlockSubst (completionMatrix3 e f g) (residualEquation F) := by
  simp only [residualEquation, liftSecondLinear, map_add, map_mul,
    residualCoeffU_of_completion e f g F hF, residualCoeffV_of_completion e f g F hF,
    residualCoeffW_of_completion e f g F hF, liftFirstBlock_C_mul, liftFirstBlock_add,
    secondBlockSubst_liftFirstBlock]
  rw [secondBlockSubst_completion_X_inr e f g 0, secondBlockSubst_completion_X_inr e f g 1,
    secondBlockSubst_completion_X_inr e f g 2]
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons]
  ring

end Biprojective

/-! ### Condition G3 along `L` under a completion change -/

section G3

open ResidualDivisor

variable {k : Type u} [Field k]

theorem secondBlockCoeff_C_mul (c : k) (P : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (m : Fin 3 →₀ ℕ) :
    secondBlockCoeff (C c * P) m = C c * secondBlockCoeff P m := by
  classical
  have hsupp : (C c * P).support ⊆ P.support := by
    intro d hd
    rw [MvPolynomial.mem_support_iff] at hd ⊢
    intro h0
    exact hd (by simp [coeff_C_mul, h0])
  have hbig : secondBlockCoeff (C c * P) m =
      ∑ d ∈ P.support,
        if secondPart d = m then monomial (firstPart d) ((C c * P).coeff d) else 0 := by
    simp only [secondBlockCoeff]
    refine Finset.sum_subset hsupp fun d _ hd => ?_
    rw [MvPolynomial.mem_support_iff, not_not] at hd
    simp [hd]
  rw [hbig]
  simp only [secondBlockCoeff, Finset.mul_sum]
  refine Finset.sum_congr rfl fun d _ => ?_
  split_ifs with h
  · rw [coeff_C_mul, ← C_mul_monomial]
  · rw [mul_zero]

/-- The completion block cancels against its own inverse in the residual equation along `L`. -/
theorem residualEquationOn_completion
    (M N N' : Matrix (Fin 3) (Fin 3) k) (e f g : k)
    (hEN : completionMatrix3 e f g * N' = N)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    residualEquationOn (M * completionMatrix3 e f g) N' F =
      C (g ^ 2) * residualEquationOn M N F := by
  rw [residualEquationOn, ← secondBlockSubst_secondBlockSubst,
    residualEquation_completion e f g _ (isBidegree23_secondBlockSubst _ hF), map_mul,
    secondBlockSubst_secondBlockSubst, hEN, residualEquationOn]
  congr 1
  simp

theorem residualLineCoeffOn_completion
    (M N N' : Matrix (Fin 3) (Fin 3) k) (e f g : k)
    (hEN : completionMatrix3 e f g * N' = N)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (a : Fin 3) :
    residualLineCoeffOn (M * completionMatrix3 e f g) N' F a =
      C (g ^ 2) * residualLineCoeffOn M N F a := by
  rw [residualLineCoeffOn, residualEquationOn_completion M N N' e f g hEN F hF,
    secondBlockCoeff_C_mul, residualLineCoeffOn]

/-- **G3 along `L` is invariant under a change of completion.** -/
theorem residualLineConstantOn_completion_iff
    (M N N' : Matrix (Fin 3) (Fin 3) k) (e f g : k) (hg : g ≠ 0)
    (hEN : completionMatrix3 e f g * N' = N)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    ResidualLineConstantOn (M * completionMatrix3 e f g) N' F ↔
      ResidualLineConstantOn M N F := by
  have hcoeff := residualLineCoeffOn_completion M N N' e f g hEN F hF
  have hg2 : (g ^ 2) ≠ 0 := pow_ne_zero 2 hg
  constructor
  · rintro ⟨G0, c, hc⟩
    refine ⟨G0, fun a => (g ^ 2)⁻¹ * c a, fun a => ?_⟩
    have h := hc a
    rw [hcoeff a] at h
    have : residualLineCoeffOn M N F a =
        C ((g ^ 2)⁻¹) * (C (g ^ 2) * residualLineCoeffOn M N F a) := by
      rw [← mul_assoc, ← C_mul, inv_mul_cancel₀ hg2, C_1, one_mul]
    rw [this, h, ← mul_assoc, ← C_mul]
  · rintro ⟨G0, c, hc⟩
    refine ⟨G0, fun a => g ^ 2 * c a, fun a => ?_⟩
    rw [hcoeff a, hc a, ← mul_assoc, ← C_mul]

theorem residualLineNonconstantOn_completion_iff
    (M N N' : Matrix (Fin 3) (Fin 3) k) (e f g : k) (hg : g ≠ 0)
    (hEN : completionMatrix3 e f g * N' = N)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    ResidualLineNonconstantOn (M * completionMatrix3 e f g) N' F ↔
      ResidualLineNonconstantOn M N F :=
  not_congr (residualLineConstantOn_completion_iff M N N' e f g hg hEN F hF)

/-- The new inverse is forced: `E * N' = N`. -/
theorem completion_mul_inv_eq
    (p q r : Fin 3 → k) (N N' : Matrix (Fin 3) (Fin 3) k) (e f g : k)
    (hMN : lineFrame p q r * N = 1)
    (hMN' : lineFrame p q (fun i => e * p i + f * q i + g * r i) * N' = 1) :
    completionMatrix3 e f g * N' = N := by
  have hNM : N * lineFrame p q r = 1 := mul_eq_one_comm.mp hMN
  rw [lineFrame_completion] at hMN'
  calc completionMatrix3 e f g * N'
      = (N * lineFrame p q r) * (completionMatrix3 e f g * N') := by rw [hNM, one_mul]
    _ = N * (lineFrame p q r * completionMatrix3 e f g * N') := by
        simp only [Matrix.mul_assoc]
    _ = N := by rw [hMN', mul_one]

/-- **F-2, G3 half: `ResidualLineNonconstantOn` is invariant under a change of completion.** -/
theorem residualLineNonconstantOn_completion_change
    (p q r : Fin 3 → k) (N N' : Matrix (Fin 3) (Fin 3) k) (e f g : k) (hg : g ≠ 0)
    (hMN : lineFrame p q r * N = 1)
    (hMN' : lineFrame p q (fun i => e * p i + f * q i + g * r i) * N' = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (h : ResidualLineNonconstantOn (lineFrame p q r) N F) :
    ResidualLineNonconstantOn
      (lineFrame p q (fun i => e * p i + f * q i + g * r i)) N' F := by
  rw [lineFrame_completion]
  exact (residualLineNonconstantOn_completion_iff (lineFrame p q r) N N' e f g hg
    (completion_mul_inv_eq p q r N N' e f g hMN hMN') F hF).mpr h

end G3

end

end BConicBundleMultisections
