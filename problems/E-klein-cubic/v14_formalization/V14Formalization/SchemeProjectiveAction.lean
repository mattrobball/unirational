/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.ProjNaturality
public import V14Formalization.SchemeEquivariant
public import Mathlib.CategoryTheory.Action.Basic
public import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs

/-!
# Projective scheme actions from matrix representations

This file uses Problem B's existing `Proj.map` construction for invertible
linear substitutions.  It packages those automorphisms as a genuine
categorical action on scheme-level projective space.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

universe u v

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k : Type u} [Field k] {G : Type v} [Group G]

/-- A matrix representation on the `n+1` homogeneous coordinates of
scheme-level projective `n`-space.  Faithfulness is not needed to construct
the induced projective action. -/
public abbrev MatrixRepresentation (n : ℕ) := G →* GL (Fin (n + 1)) k

/-- A faithful matrix representation on the `n+1` homogeneous coordinates of
scheme-level projective `n`-space. -/
public structure FaithfulMatrixRepresentation (n : ℕ) where
  ρ : MatrixRepresentation (k := k) (G := G) n
  faithful : Function.Injective ρ

private theorem projMap_congr (n : ℕ)
    {f g : (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) →+*ᵍ
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)}
    (h : f = g) (hf) (hg) : Proj.map f hf = Proj.map g hg := by
  subst h
  rfl

/-- The projective-scheme automorphism induced by one representation matrix. -/
@[expose] public def projectiveActionHom {n : ℕ}
    (R : MatrixRepresentation (k := k) (G := G) n) (g : G) :
    ProjectiveSpace n k ⟶ ProjectiveSpace n k :=
  mapLinearSubst n (↑(R g) : Matrix _ _ k) (↑((R g)⁻¹) : Matrix _ _ k) (by simp)

@[simp]
public theorem projectiveActionHom_one {n : ℕ}
    (R : MatrixRepresentation (k := k) (G := G) n) :
    projectiveActionHom R 1 = 𝟙 _ := by
  unfold projectiveActionHom mapLinearSubst
  have hc : linearSubstGradedRingHom n (↑(R 1) : Matrix _ _ k) =
      GradedRingHom.id _ := by
    simpa using (linearSubstGradedRingHom_one (k := k) n)
  exact (projMap_congr n hc _ _).trans Proj.map_id

public theorem projectiveActionHom_mul {n : ℕ}
    (R : MatrixRepresentation (k := k) (G := G) n) (g h : G) :
    projectiveActionHom R (g * h) =
      projectiveActionHom R h ≫ projectiveActionHom R g := by
  unfold projectiveActionHom mapLinearSubst
  have hc : linearSubstGradedRingHom n (↑(R (g * h)) : Matrix _ _ k) =
      (linearSubstGradedRingHom n (↑(R h) : Matrix _ _ k)).comp
        (linearSubstGradedRingHom n (↑(R g) : Matrix _ _ k)) := by
    rw [R.map_mul, Matrix.GeneralLinearGroup.coe_mul]
    exact (linearSubstGradedRingHom_comp n _ _).symm
  calc
    Proj.map (linearSubstGradedRingHom n (↑(R (g * h)) : Matrix _ _ k)) _ =
        Proj.map ((linearSubstGradedRingHom n (↑(R h) : Matrix _ _ k)).comp
          (linearSubstGradedRingHom n (↑(R g) : Matrix _ _ k))) _ :=
      projMap_congr n hc _ _
    _ = Proj.map (linearSubstGradedRingHom n (↑(R h) : Matrix _ _ k)) _ ≫
          Proj.map (linearSubstGradedRingHom n (↑(R g) : Matrix _ _ k)) _ :=
      Proj.map_comp _ _ _ _

/-- Scheme-level projective space equipped with the action induced by `R`. -/
@[expose] public def projectiveAction (n : ℕ)
    (R : MatrixRepresentation (k := k) (G := G) n) :
    Action Scheme G where
  V := ProjectiveSpace n k
  ρ :=
    { toFun := projectiveActionHom R
      map_one' := projectiveActionHom_one R
      map_mul' := projectiveActionHom_mul R }

/-- Each projective action morphism preserves the canonical structure map to
`Spec k`. -/
@[expose] public instance projectiveActionHom_isOver {n : ℕ}
    (R : MatrixRepresentation (k := k) (G := G) n) (g : G) :
    (projectiveActionHom R g).IsOver (Spec (.of k)) where
  comp_over := by
    change projectiveActionHom R g ≫ ProjectiveSpace.toSpec n k =
      ProjectiveSpace.toSpec n k
    exact mapLinearSubst_toSpec n
      (↑(R g) : Matrix _ _ k) (↑((R g)⁻¹) : Matrix _ _ k) (by simp)

/-- Scheme-level projective space with its matrix action, genuinely packaged
as a scheme over `Spec k`. -/
@[expose] public def projectiveActionOver (n : ℕ)
    (R : MatrixRepresentation (k := k) (G := G) n) :
    Action (Over (Spec (.of k))) G :=
  actionOverOfHoms (ProjectiveSpace n k) (projectiveActionHom R)
    (projectiveActionHom_one R) (projectiveActionHom_mul R)
    (fun _ ↦ inferInstance)

end SchemeGeometry
end V14Formalization
