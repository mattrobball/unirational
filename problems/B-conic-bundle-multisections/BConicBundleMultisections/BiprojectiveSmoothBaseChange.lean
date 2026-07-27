/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveNoWholeFiber
public import BConicBundleMultisections.BiprojectiveSmoothCriterion

/-!
# Smoothness of a biprojective hypersurface is preserved by extension of the base field

`SmoothExtensionJacobian` says that the unit-ideal Jacobian certificate of a smooth affine chart
may be evaluated in any extension field, so a smooth hypersurface over `K` has no singular point
valued in an extension `L`.  Combined with the Jacobian criterion in the other direction — which
is available over `L` as soon as `L` is algebraically closed — this upgrades to a statement about
the base-changed scheme:

> `Smooth (biprojectiveZeroLocusToSpec m n K F)` implies
> `Smooth (biprojectiveZeroLocusToSpec m n L (map (algebraMap K L) F))`.

That is the tool that removes `[IsAlgClosed K]` from downstream statements of the form
"smoothness over `K` forces such-and-such a polynomial identity over `K`": run the closed-field
argument over `AlgebraicClosure K`, where this instance supplies the smoothness hypothesis, and
bring the identity home by injectivity of `MvPolynomial.map (algebraMap K L)`.

No scheme-level base-change isomorphism is constructed; everything goes through the Cox-coordinate
Jacobian conditions, which base change on the nose.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry
open _root_.MvPolynomial

namespace BiprojectiveSpace

/-- Evaluation under rescaling of the first homogeneous-coordinate block. -/
theorem eval_smul_first_of_bidegree
    {m n d e : ℕ} {R : Type u} [CommSemiring R]
    {G : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hG : IsBihomogeneousOfBidegree d e G) (a : R)
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    eval (Sum.elim (fun i => a * x i) y) G = a ^ d * eval (Sum.elim x y) G := by
  have hx : (fun i => a * x i) = (a • x : Fin (m + 1) → R) := by
    funext i
    simp [Pi.smul_apply, smul_eq_mul]
  have h := congrArg (eval y) (hG.specializeFirstCoordinates_smul a x)
  rw [eval_specializeFirstCoordinates, map_mul, eval_C,
    eval_specializeFirstCoordinates] at h
  rw [hx, h]

/-- Evaluation under rescaling of the second homogeneous-coordinate block. -/
theorem eval_smul_second_of_bidegree
    {m n d e : ℕ} {R : Type u} [CommSemiring R]
    {G : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hG : IsBihomogeneousOfBidegree d e G) (b : R)
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    eval (Sum.elim x (fun j => b * y j)) G = b ^ e * eval (Sum.elim x y) G := by
  have hy : (fun j => b * y j) = (b • y : Fin (n + 1) → R) := by
    funext j
    simp [Pi.smul_apply, smul_eq_mul]
  have h := congrArg (eval x) (hG.specializeSecondCoordinates_smul b y)
  rw [eval_specializeSecondCoordinates, map_mul, eval_C,
    eval_specializeSecondCoordinates] at h
  rw [hy, h]

/-- Evaluation under independent rescaling of both homogeneous-coordinate blocks. -/
theorem eval_smul_both_of_bidegree
    {m n d e : ℕ} {R : Type u} [CommSemiring R]
    {G : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hG : IsBihomogeneousOfBidegree d e G) (a b : R)
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    eval (Sum.elim (fun i => a * x i) (fun j => b * y j)) G =
      a ^ d * b ^ e * eval (Sum.elim x y) G := by
  rw [eval_smul_second_of_bidegree hG b (fun i => a * x i) y,
    eval_smul_first_of_bidegree hG a x y]
  ring

/-- **The Cox-coordinate Jacobian condition ascends to any extension field.**

A common zero of the base-changed equation and all of its base-changed Cox partials, valued in an
extension `L` of `K`, lies in one of the two forbidden coordinate subspaces.  Only smoothness over
`K` is used; `L` carries no hypothesis at all beyond being a field extension.

This is the geometric form of `GoodLineConic.gradient_condition_of_smooth`, and the reason it is
available is `SmoothExtensionJacobian`: the unit-ideal Jacobian certificate over `K` evaluates in
`L`. -/
theorem gradient_condition_of_smooth_of_geometric
    (m n : ℕ) (K : Type u) [Field K] {L : Type u} [Field L] [Algebra K L]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0) (hd : 0 < d) (he : 0 < e)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)] :
    ∀ (x : Fin (m + 1) → L) (y : Fin (n + 1) → L),
      eval (Sum.elim x y) (MvPolynomial.map (algebraMap K L) F) = 0 →
      (∀ z : BiprojectiveCoordinate m n,
        eval (Sum.elim x y)
          (MvPolynomial.pderiv z (MvPolynomial.map (algebraMap K L) F)) = 0) →
      x = 0 ∨ y = 0 := by
  classical
  intro x y hval hgrad
  by_cases hx : x = 0
  · exact Or.inl hx
  by_cases hy : y = 0
  · exact Or.inr hy
  exfalso
  obtain ⟨i, hi⟩ := exists_normalizing_coordinate x hx
  obtain ⟨j, hj⟩ := exists_normalizing_coordinate y hy
  set FL := MvPolynomial.map (algebraMap K L) F with hFL
  have hFLhom : IsBihomogeneousOfBidegree d e FL := hF.map_coefficients _
  set x₁ : Fin (m + 1) → L := fun l => (x i)⁻¹ * x l with hx₁
  set y₁ : Fin (n + 1) → L := fun l => (y j)⁻¹ * y l with hy₁
  have hxi : x₁ i = 1 := by simp [hx₁, hi]
  have hyj : y₁ j = 1 := by simp [hy₁, hj]
  have hval₁ : eval (Sum.elim x₁ y₁) FL = 0 := by
    rw [hx₁, hy₁, eval_smul_both_of_bidegree hFLhom, hval, mul_zero]
  have hgrad₁ : ∀ z : BiprojectiveCoordinate m n,
      eval (Sum.elim x₁ y₁) (MvPolynomial.pderiv z FL) = 0 := by
    rintro (l | l)
    · have hp : IsBihomogeneousOfBidegree (d - 1) e (MvPolynomial.pderiv (.inl l) FL) :=
        hFLhom.pderiv_inl hd l
      rw [hx₁, hy₁, eval_smul_both_of_bidegree hp, hgrad (.inl l), mul_zero]
    · have hp : IsBihomogeneousOfBidegree d (e - 1) (MvPolynomial.pderiv (.inr l) FL) :=
        hFLhom.pderiv_inr he l
      rw [hx₁, hy₁, eval_smul_both_of_bidegree hp, hgrad (.inr l), mul_zero]
  obtain ⟨hchart, hchartgrad⟩ :=
    affineChartEquation_vanishing_and_gradient_eq_zero m n L i j x₁ y₁ hxi hyj FL
      hval₁ hgrad₁
  have hne : affineChartEquation m n K i j F ≠ 0 :=
    affineChartEquation_ne_zero m n K i j F hF hF0
  refine no_common_zero_affineChartEquation_and_pderiv_of_global_smooth_extension
    m n K L F hF i j hne (affineChartPoint i j x₁ y₁) ⟨?_, ?_⟩
  · rw [aeval_affineChartEquation_eq_eval_map (L := L)]
    exact hchart
  · intro q
    rw [aeval_pderiv_affineChartEquation_eq_eval_map (L := L)]
    exact hchartgrad q

/-- **Smoothness of a nonzero biprojective hypersurface is preserved by base change to an
algebraically closed extension.**

The base field `K` is arbitrary.  This is the hypothesis that every closed-field argument
downstream is applied under, after replacing `K` by `AlgebraicClosure K`. -/
theorem smooth_biprojectiveZeroLocusToSpec_map_of_smooth
    (m n : ℕ) (K : Type u) [Field K] {L : Type u} [Field L] [IsAlgClosed L] [Algebra K L]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0) (hd : 0 < d) (he : 0 < e)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)] :
    Smooth (biprojectiveZeroLocusToSpec m n L (MvPolynomial.map (algebraMap K L) F)) :=
  smooth_biprojectiveZeroLocusToSpec_of_gradient m n L
    (MvPolynomial.map (algebraMap K L) F) (hF.map_coefficients _)
    (gradient_condition_of_smooth_of_geometric (L := L) m n K F hF hF0 hd he)

/-- The bidegree-`(2,3)` packaging of the base-change instance. -/
theorem smooth_biprojectiveZeroLocusToSpec_map_of_smooth_bidegree23
    (K : Type u) [Field K] {L : Type u} [Field L] [IsAlgClosed L] [Algebra K L]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    Smooth (biprojectiveZeroLocusToSpec 2 2 L (MvPolynomial.map (algebraMap K L) F)) :=
  smooth_biprojectiveZeroLocusToSpec_map_of_smooth 2 2 K F hF hF0
    (by norm_num) (by norm_num)

/-- **The Cox-coordinate Jacobian condition from smoothness, in the general bidegree.**

`GoodLineConic.gradient_condition_of_smooth` is this for bidegree `(2,3)`; the general form is
the `L = K` case of the geometric statement above. -/
theorem gradient_condition_of_smooth_general
    (m n : ℕ) (K : Type u) [Field K]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0) (hd : 0 < d) (he : 0 < e)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)] :
    ∀ (x : Fin (m + 1) → K) (y : Fin (n + 1) → K),
      eval (Sum.elim x y) F = 0 →
      (∀ z : BiprojectiveCoordinate m n, eval (Sum.elim x y) (MvPolynomial.pderiv z F) = 0) →
      x = 0 ∨ y = 0 := by
  have h := gradient_condition_of_smooth_of_geometric (L := K) m n K F hF hF0 hd he
  have hid : MvPolynomial.map (algebraMap K K) F = F := by
    simpa using MvPolynomial.map_id F
  rw [hid] at h
  exact h

/-- **Smoothness descends from an algebraically closed extension.**

The converse of `smooth_biprojectiveZeroLocusToSpec_map_of_smooth`.  Together the two say that
for a nonzero bihomogeneous equation smoothness of the biprojective zero locus is insensitive to
enlarging the base field. -/
theorem smooth_biprojectiveZeroLocusToSpec_of_smooth_map
    (m n : ℕ) (K : Type u) [Field K] {L : Type u} [Field L] [IsAlgClosed L] [Algebra K L]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0) (hd : 0 < d) (he : 0 < e)
    (h : Smooth (biprojectiveZeroLocusToSpec m n L (MvPolynomial.map (algebraMap K L) F))) :
    Smooth (biprojectiveZeroLocusToSpec m n K F) := by
  haveI := h
  refine smooth_biprojectiveZeroLocusToSpec_of_gradient_of_geometric (L := L) m n K F hF ?_
  have hF0L : MvPolynomial.map (algebraMap K L) F ≠ 0 := fun hz =>
    hF0 (MvPolynomial.map_injective _ (algebraMap K L).injective (by rw [hz, map_zero]))
  exact gradient_condition_of_smooth_general m n L
    (MvPolynomial.map (algebraMap K L) F) (hF.map_coefficients _) hF0L hd he

end BiprojectiveSpace

end

end BConicBundleMultisections
