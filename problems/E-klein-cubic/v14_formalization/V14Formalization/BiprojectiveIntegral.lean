/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import BConicBundleMultisections.BiprojectiveAffineChart
public import BConicBundleMultisections.BiprojectiveOverlapScheme
public import BConicBundleMultisections.IntegralOpenCover

/-!
# Integrality of biprojective space

This file supplies the local glue from Problem B's imported affine-chart,
overlap, and integral-open-cover APIs to an `IsIntegral` instance for
biprojective space.  No Problem B source is copied into this project.
-/

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry TensorProduct

namespace BConicBundleMultisections

open AlgebraicGeometry

attribute [local instance] MvPolynomial.gradedAlgebra

universe u

/-- Evaluation at the all-ones point of a standard projective overlap. -/
def ProjectiveSpace.overlapEvalOne
    (n : ℕ) (k : Type u) [Field k] (i i' : Fin (n + 1)) :
    ProjectiveSpace.OverlapRing n k i i' →ₐ[k] k :=
  (IsLocalization.Away.liftAlgHom
    (S := Localization.Away
      (MvPolynomial.X i * MvPolynomial.X i' :
        MvPolynomial (Fin (n + 1)) k))
    (P := k)
    (MvPolynomial.X i * MvPolynomial.X i')
    (f := MvPolynomial.aeval (fun _ ↦ (1 : k))) (by simp)).comp
    { toFun := algebraMap
        (ProjectiveSpace.OverlapRing n k i i')
        (Localization.Away
          (MvPolynomial.X i * MvPolynomial.X i' :
            MvPolynomial (Fin (n + 1)) k))
      map_one' := by simp
      map_mul' := by simp
      map_zero' := by simp
      map_add' := by simp
      commutes' := by
        intro r
        change algebraMap
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k 0)
          (Localization.Away
            (MvPolynomial.X i * MvPolynomial.X i' :
              MvPolynomial (Fin (n + 1)) k))
          (algebraMap k
            (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k 0) r) = _
        rfl }

/-- Evaluation at the all-ones point of a standard biprojective overlap. -/
def BiprojectiveSpace.overlapEvalOne
    (m n : ℕ) (k : Type u) [Field k]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    BiprojectiveSpace.OverlapRing m n k i i' j j' →ₐ[k] k :=
  Algebra.TensorProduct.lift
    (ProjectiveSpace.overlapEvalOne m k i i')
    (ProjectiveSpace.overlapEvalOne n k j j')
    (fun _ _ ↦ Commute.all _ _)

@[expose] public instance BiprojectiveSpace.overlapRingNontrivial
    (m n : ℕ) (k : Type u) [Field k]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    Nontrivial (BiprojectiveSpace.OverlapRing m n k i i' j j') := by
  refine ⟨⟨0, 1, fun h ↦ ?_⟩⟩
  have := congrArg (BiprojectiveSpace.overlapEvalOne m n k i i' j j') h
  have h₀₁ : (0 : k) = 1 := by
    simpa only [map_zero, map_one] using this
  exact zero_ne_one h₀₁

/-- Every member of the imported standard affine cover is integral. -/
public theorem BiprojectiveSpace.standardChartIntegral
    (m n : ℕ) (k : Type u) [Field k]
    (ij : Fin (m + 1) × Fin (n + 1)) :
    IsIntegral ((BiprojectiveSpace.standardOpenCover m n k).X ij) := by
  let e := BiprojectiveSpace.standardChartRingEquivMvPolynomial
    m n k ij.1 ij.2
  letI : IsDomain
      (BiprojectiveSpace.StandardChartRing m n k ij.1 ij.2) :=
    e.injective.isDomain e.toRingHom
  haveI : IsIntegral
      (Spec (.of
        (BiprojectiveSpace.StandardChartRing m n k ij.1 ij.2))) := inferInstance
  exact IsIntegral.of_isIso
    (BiprojectiveSpace.standardOpenCoverObjIso m n k ij).inv

/-- The ranges in the imported standard affine cover meet pairwise. -/
public theorem BiprojectiveSpace.standardChartRanges_pairwise
    (m n : ℕ) (k : Type u) [Field k] :
    _root_.Pairwise
      (Function.onFun
        (fun U V : (BiprojectiveSpace m n k).Opens ↦ ¬ Disjoint U V)
        (fun ij ↦
          ((BiprojectiveSpace.standardOpenCover m n k).f ij).opensRange)) := by
  rintro ⟨i, j⟩ ⟨i', j'⟩ hne
  intro hdis
  let Z := BiprojectiveSpace.overlapScheme m n k i i' j j'
  let z : Z := Classical.choice (inferInstance : Nonempty Z)
  let x : BiprojectiveSpace m n k :=
    BiprojectiveSpace.overlapι m n k i i' j j' z
  have hx₁ : x ∈
      (BiprojectiveSpace.standardChartι m n k i j).opensRange := by
    rw [Scheme.Hom.mem_opensRange]
    refine ⟨BiprojectiveSpace.overlapToChart m n k i i' j j' z, ?_⟩
    exact congrArg (fun q ↦ q z)
      (BiprojectiveSpace.overlapToChart_standardChartι m n k i i' j j')
  have hx₂ : x ∈
      (BiprojectiveSpace.standardChartι m n k i' j').opensRange := by
    rw [Scheme.Hom.mem_opensRange]
    refine ⟨BiprojectiveSpace.overlapToOtherChart m n k i i' j j' z, ?_⟩
    exact congrArg (fun q ↦ q z)
      (BiprojectiveSpace.overlapToOtherChart_standardChartι m n k i i' j j')
  have hx : x ∈
      ((BiprojectiveSpace.standardOpenCover m n k).f (i, j)).opensRange ⊓
        ((BiprojectiveSpace.standardOpenCover m n k).f (i', j')).opensRange :=
    ⟨hx₁, hx₂⟩
  rw [disjoint_iff.mp hdis] at hx
  exact hx

/-- Biprojective space over a field is integral. -/
@[expose] public instance BiprojectiveSpace.isIntegral
    (m n : ℕ) (k : Type u) [Field k] :
    IsIntegral (BiprojectiveSpace m n k) := by
  let U := BiprojectiveSpace.standardOpenCover m n k
  letI hUi : ∀ ij, IsIntegral (U.X ij) := fun ij ↦
    BiprojectiveSpace.standardChartIntegral m n k ij
  let ij₀ : U.I₀ := by
    change Fin (m + 1) × Fin (n + 1)
    exact (0, 0)
  letI : Nonempty (BiprojectiveSpace m n k) :=
    Nonempty.map (U.f ij₀) (inferInstance : Nonempty (U.X ij₀))
  exact isIntegral_of_openCover_of_pairwise_nonempty U
    (BiprojectiveSpace.standardChartRanges_pairwise m n k)

end BConicBundleMultisections
