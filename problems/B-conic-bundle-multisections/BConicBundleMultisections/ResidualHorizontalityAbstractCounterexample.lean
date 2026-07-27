/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.AlgebraicIndependenceJacobian
public import BConicBundleMultisections.ResidualImageAffineParam

/-!
# Why moving residual lines and a dominant source do not formally imply horizontality

This is an abstract incidence counterexample, not a counterexample to the geometric theorem about
smooth bidegree-`(2,3)` hypersurfaces.  It records why a proof of that theorem must use the geometry
of the hypersurface (divisor rigidity, or an algebraic substitute for it).

On the parameter plane with coordinates `(t,s)`, put

```
x = [1, s, -t^3-s*t],   y = [1,t,t^3],   q = [-t^3-s*t,s,1].
```

Then `x` is dominant, the line `q` moves dominantly in the dual plane, and `q.y=0`.  Moreover the
map to `x` is generically cubic: writing `x=[1,a,b]` leaves `t^3+a*t+b=0`.  Nevertheless `y`
depends only on `t`, so its projective Jacobian is zero.  Thus neither the degree-three function
field correspondence nor the moving-line identity can replace the vertical-divisor exclusion.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial
open _root_.MvPolynomial
open scoped Matrix

abbrev abstractHorizRing := affineTwoRing ℚ

def abstractHorizT : abstractHorizRing := affineTwoCoord0 ℚ

def abstractHorizS : abstractHorizRing := affineTwoCoord1 ℚ

def abstractHorizX : Fin 3 → abstractHorizRing :=
  ![1, abstractHorizS, -(abstractHorizT ^ 3 + abstractHorizS * abstractHorizT)]

def abstractHorizY : Fin 3 → abstractHorizRing :=
  ![1, abstractHorizT, abstractHorizT ^ 3]

def abstractHorizLine : Fin 3 → abstractHorizRing :=
  ![-(abstractHorizT ^ 3 + abstractHorizS * abstractHorizT), abstractHorizS, 1]

/-- The fixed cubic containing the target point. -/
def abstractHorizTargetRelation : MvPolynomial (Fin 3) ℚ :=
  X 2 * X 0 ^ 2 - X 1 ^ 3

/-- In source coordinates the moving line is simply `[x₂,x₁,x₀]`. -/
theorem abstractHorizLine_eq_reverse_source :
    abstractHorizLine = ![abstractHorizX 2, abstractHorizX 1, abstractHorizX 0] := by
  funext i
  fin_cases i <;> simp [abstractHorizLine, abstractHorizX]

/-- The parameter `t` is integral of degree at most three over the affine source coordinates.
This is the exact generic-cubic equation `t^3 + a*t + b = 0`, with
`a = x_1/x_0` and `b = x_2/x_0`. -/
theorem abstractHoriz_source_cubic_equation :
    abstractHorizT ^ 3 + abstractHorizX 1 * abstractHorizT + abstractHorizX 2 = 0 := by
  simp [abstractHorizX, abstractHorizT, abstractHorizS]

/-- The fixed target relation really is a projective cubic. -/
theorem abstractHorizTargetRelation_isHomogeneous :
    abstractHorizTargetRelation.IsHomogeneous 3 := by
  have h20 : (X (2 : Fin 3) * X 0 ^ 2 : MvPolynomial (Fin 3) ℚ).IsHomogeneous 3 := by
    simpa using (isHomogeneous_X ℚ (2 : Fin 3)).mul ((isHomogeneous_X ℚ (0 : Fin 3)).pow 2)
  have h13 : (X (1 : Fin 3) ^ 3 : MvPolynomial (Fin 3) ℚ).IsHomogeneous 3 := by
    simpa using (isHomogeneous_X ℚ (1 : Fin 3)).pow 3
  exact h20.sub h13

/-- The target triple satisfies the fixed homogeneous cubic relation
`Y₂ Y₀² - Y₁³ = 0`. -/
theorem abstractHoriz_target_relation :
    aeval abstractHorizY abstractHorizTargetRelation = 0 := by
  simp [abstractHorizTargetRelation, abstractHorizY, abstractHorizT]

/-- The displayed target relation is genuinely nonzero. -/
theorem abstractHorizTargetRelation_ne_zero : abstractHorizTargetRelation ≠ 0 := by
  intro h
  have heval := congrArg (eval ![1, 0, 1]) h
  have : (1 : ℚ) = 0 := by
    simpa [abstractHorizTargetRelation] using heval
  exact one_ne_zero this

/-- The curve-valued point lies on the moving line. -/
theorem abstractHoriz_incidence :
    ∑ i : Fin 3, abstractHorizLine i * abstractHorizY i = 0 := by
  simp [abstractHorizLine, abstractHorizY, abstractHorizT, abstractHorizS,
    Fin.sum_univ_three]

/-- The projective Jacobian of a homogeneous triple. -/
def abstractProjectiveJacobian (z : Fin 3 → abstractHorizRing) : abstractHorizRing :=
  (Matrix.of ![z, fun a => pderiv (ULift.up 0) (z a),
    fun a => pderiv (ULift.up 1) (z a)]).det

theorem abstractProjectiveJacobian_x :
    abstractProjectiveJacobian abstractHorizX =
      3 * abstractHorizT ^ 2 + abstractHorizS := by
  simp [abstractProjectiveJacobian, abstractHorizX, abstractHorizT, abstractHorizS,
    Matrix.det_fin_three, affineTwoCoord0, affineTwoCoord1, pderiv_X]

theorem abstractProjectiveJacobian_line :
    abstractProjectiveJacobian abstractHorizLine =
      -(3 * abstractHorizT ^ 2 + abstractHorizS) := by
  simp [abstractProjectiveJacobian, abstractHorizLine, abstractHorizT, abstractHorizS,
    Matrix.det_fin_three, affineTwoCoord0, affineTwoCoord1, pderiv_X]

theorem three_mul_abstractHorizT_sq_add_s_ne_zero :
    3 * abstractHorizT ^ 2 + abstractHorizS ≠ 0 := by
  intro h
  let point : ULift (Fin 2) → ℚ := fun i => ![0, 1] i.down
  have he := congrArg (eval point) h
  norm_num [abstractHorizT, abstractHorizS, affineTwoCoord0, affineTwoCoord1,
    point] at he

/-- Both the source projection and the line map are dominant in Jacobian form. -/
theorem abstractHoriz_source_and_line_jacobians_ne_zero :
    abstractProjectiveJacobian abstractHorizX ≠ 0 ∧
      abstractProjectiveJacobian abstractHorizLine ≠ 0 := by
  rw [abstractProjectiveJacobian_x, abstractProjectiveJacobian_line]
  exact ⟨three_mul_abstractHorizT_sq_add_s_ne_zero,
    neg_ne_zero.mpr three_mul_abstractHorizT_sq_add_s_ne_zero⟩

/-- The target still sweeps only the fixed cubic curve `[1:t:t^3]`. -/
theorem abstractProjectiveJacobian_y :
    abstractProjectiveJacobian abstractHorizY = 0 := by
  simp [abstractProjectiveJacobian, abstractHorizY, abstractHorizT,
    Matrix.det_fin_three, affineTwoCoord0, pderiv_X]

end

end BConicBundleMultisections
