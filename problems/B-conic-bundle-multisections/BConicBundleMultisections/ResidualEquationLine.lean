/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveFiberPolynomial
public import BConicBundleMultisections.LinearSubstitution
public import BConicBundleMultisections.ResidualLineNonconstant

/-!
# The residual equation and condition G3 along an arbitrary line

`ResidualDivisor.residualEquation F` is the bidegree `(10, 1)` form whose second-block coefficients
are `§5`'s `q_U, q_V, q_W` — the residual line `δ_{C_x}(L)` as a function of `x`, for the one line
`L = {Y₂ = 0}`.  `ResidualLineNonconstant` (condition **G3**) is the statement that this line moves
with `x`, and it is a condition on the *choice* of `L`, which the source makes in §3.

This module states both for an arbitrary `L`, by the same transport used in
`PlaneCubicResidualTransport`: substitute the second block of `F` by the frame of `L`, take the
normalised residual equation there, and substitute back.

## Why the substitution is on the second block only

`L` is a line in `ℙ²_y`.  Changing coordinates to put it at `{W = 0}` touches the `y` block and
leaves `ℙ²_x` alone, so the operation is a linear substitution in the second block of a biprojective
polynomial.  The ambient scheme is never transported — see `PlaneCubicResidualTransport` for why
that matters.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial ResidualDivisor
open _root_.MvPolynomial
open scoped Matrix

variable {R : Type u} [CommRing R]

/-! ### Linear substitution in the second block -/

/-- Substitute `y_j ↦ ∑ l, M j l · y_l` in the second block, leaving the first block alone.

This is the biprojective counterpart of `linearSubst`: on values it is
`(x, z) ↦ F (x, M *ᵥ z)`. -/
def secondBlockSubst (M : Matrix (Fin 3) (Fin 3) R) :
    MvPolynomial (BiprojectiveCoordinate 2 2) R →ₐ[R]
      MvPolynomial (BiprojectiveCoordinate 2 2) R :=
  aeval fun z => match z with
    | .inl i => X (.inl i)
    | .inr j => ∑ l : Fin 3, C (M j l) * X (.inr l)

@[simp] theorem secondBlockSubst_X_inl (M : Matrix (Fin 3) (Fin 3) R) (i : Fin 3) :
    secondBlockSubst M (X (.inl i)) = X (.inl i) := by
  simp [secondBlockSubst]

@[simp] theorem secondBlockSubst_X_inr (M : Matrix (Fin 3) (Fin 3) R) (j : Fin 3) :
    secondBlockSubst M (X (.inr j)) = ∑ l : Fin 3, C (M j l) * X (.inr l) := by
  simp [secondBlockSubst]

/-- Substituting by the identity matrix does nothing. -/
@[simp] theorem secondBlockSubst_one :
    secondBlockSubst (1 : Matrix (Fin 3) (Fin 3) R) = AlgHom.id R _ := by
  refine MvPolynomial.algHom_ext fun z => ?_
  cases z with
  | inl i => simp
  | inr j =>
      rw [secondBlockSubst_X_inr, AlgHom.id_apply, Finset.sum_eq_single j]
      · simp [Matrix.one_apply]
      · intro l _ hl; simp [Matrix.one_apply, Ne.symm hl]
      · simp

/-- **Second-block substitution acts on the second block of a point.**

On values `secondBlockSubst M` is `(x, z) ↦ F (x, M *ᵥ z)`, which is what makes it the biprojective
counterpart of `linearSubst`. -/
theorem eval_secondBlockSubst (M : Matrix (Fin 3) (Fin 3) R) (x y : Fin 3 → R)
    (H : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    eval (Sum.elim x y) (secondBlockSubst M H) = eval (Sum.elim x (M *ᵥ y)) H := by
  classical
  suffices h : (aeval (Sum.elim x y) : MvPolynomial (BiprojectiveCoordinate 2 2) R →ₐ[R] R).comp
      (secondBlockSubst M)
      = (aeval (Sum.elim x (M *ᵥ y)) : MvPolynomial (BiprojectiveCoordinate 2 2) R →ₐ[R] R) from
    DFunLike.congr_fun h H
  refine MvPolynomial.algHom_ext fun z => ?_
  cases z with
  | inl i => simp
  | inr j =>
      simp only [AlgHom.comp_apply, secondBlockSubst_X_inr, map_sum, map_mul, aeval_C, aeval_X,
        Sum.elim_inr, MvPolynomial.algebraMap_eq]
      simp [Matrix.mulVec, dotProduct]

/-- **First-block specialization commutes with second-block substitution.**

They act on disjoint blocks, so the cubic fibre of the substituted `F` is the substituted cubic
fibre — which is exactly the cubic that `PlaneCubicResidualTransport` carries into the frame. -/
theorem specializeFirstCoordinates_secondBlockSubst (M : Matrix (Fin 3) (Fin 3) R)
    (x : Fin 3 → R) (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    specializeFirstCoordinates (n := 2) x (secondBlockSubst M F)
      = (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _)
          (specializeFirstCoordinates (n := 2) x F) := by
  classical
  suffices h : (specializeFirstCoordinates (n := 2) x).comp (secondBlockSubst M)
      = ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _).comp
          (specializeFirstCoordinates (n := 2) x)) from DFunLike.congr_fun h F
  refine MvPolynomial.algHom_ext fun z => ?_
  cases z with
  | inl i => simp [specializeFirstCoordinates]
  | inr j =>
      simp only [AlgHom.comp_apply, secondBlockSubst_X_inr, map_sum, map_mul,
        specializeFirstCoordinates_C, specializeFirstCoordinates_X_inr, aeval_X]
      simp [linearSubst, specializeFirstCoordinates]

/-! ### The residual equation along `L` -/

/-- **The residual equation along the line with frame `M` and inverse `N`.**

`residualEquation` computes `δ_{C_x}(L)` for `L = {Y₂ = 0}`.  Here the cubic is carried into the
frame of `L` first, and the resulting linear form in `y` is carried back. -/
def residualEquationOn (M N : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    MvPolynomial (BiprojectiveCoordinate 2 2) R :=
  secondBlockSubst N (residualEquation (secondBlockSubst M F))

/-- For the identity frame this is the residual equation the development already had. -/
@[simp] theorem residualEquationOn_one (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    residualEquationOn 1 1 F = residualEquation F := by
  rw [residualEquationOn, secondBlockSubst_one]
  simp

/-! ### Condition G3 along `L` -/

/-- The three coefficient forms `q_U, q_V, q_W` of the residual line along `L`. -/
def residualLineCoeffOn (M N : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (a : Fin 3) : MvPolynomial (Fin 3) R :=
  secondBlockCoeff (residualEquationOn M N F) (Finsupp.single a 1)

@[simp] theorem residualLineCoeffOn_one (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (a : Fin 3) : residualLineCoeffOn 1 1 F a = residualLineCoeff F a := by
  rw [residualLineCoeffOn, residualEquationOn_one, residualLineCoeff]

/-- **The residual line along `L` is constant**: as `x` varies the point
`[q_U(x) : q_V(x) : q_W(x)]` of `(ℙ²_y)^∨` does not move. -/
def ResidualLineConstantOn (M N : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) : Prop :=
  ∃ (g : MvPolynomial (Fin 3) R) (c : Fin 3 → R),
    ∀ a : Fin 3, residualLineCoeffOn M N F a = C (c a) * g

/-- **Condition G3 along `L`**: the residual line moves with `x`.

This is the source's requirement on the choice of `L` (§3), now a condition on the pair `(F, L)`
rather than on `F` alone.  `ResidualLineNonconstant` is the special case of the coordinate line. -/
def ResidualLineNonconstantOn (M N : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) : Prop :=
  ¬ ResidualLineConstantOn M N F

/-- The coordinate line is the identity frame, so the general condition restricts to the one
already stated. -/
theorem residualLineConstantOn_one (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    ResidualLineConstantOn 1 1 F ↔ ResidualLineConstant F := by
  constructor <;> rintro ⟨g, c, h⟩ <;> exact ⟨g, c, fun a => by simpa using h a⟩

theorem residualLineNonconstantOn_one (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    ResidualLineNonconstantOn 1 1 F ↔ ResidualLineNonconstant F :=
  not_congr (residualLineConstantOn_one F)

end

end BConicBundleMultisections
