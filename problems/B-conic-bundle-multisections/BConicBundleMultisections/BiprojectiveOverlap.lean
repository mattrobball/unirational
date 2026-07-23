/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveChart
public import Mathlib.RingTheory.GradedAlgebra.HomogeneousLocalization
public import Mathlib.RingTheory.Ideal.Span
public import Mathlib.RingTheory.TensorProduct.Maps

/-!
# Bihomogeneous equations on biprojective chart overlaps

This file compares the equations obtained by dehomogenizing a bihomogeneous Cox polynomial on
two standard charts of `ProjectiveSpace m R ×[Spec R] ProjectiveSpace n R`.

For one projective-space factor, the common overlap of the charts indexed by `i` and `i'` is
modeled by the degree-zero homogeneous localization away from `Xᵢ * Xᵢ′`.  Mathlib's
`HomogeneousLocalization.awayMap` supplies the two restriction maps.  Their normalized
coordinates satisfy

`Xₗ / Xᵢ = (Xᵢ′ / Xᵢ) * (Xₗ / Xᵢ′)`.

Tensoring the overlap rings in the two factors gives a common target for two product charts.  A
polynomial of bidegree `(d, e)` then has chart equations related by the unit
`(Xᵢ′ / Xᵢ) ^ d * (Yⱼ′ / Yⱼ) ^ e`.  The final theorem states the resulting equality of
the extended principal ideals, which is the algebraic compatibility needed for gluing the local
zero loci.
-/

@[expose] public section

open scoped TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

attribute [local instance] MvPolynomial.gradedAlgebra

namespace ProjectiveSpace

/-- The degree-zero homogeneous localization modeling `D₊(Xᵢ) ∩ D₊(Xᵢ′)`. -/
abbrev OverlapRing (n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (n + 1)) : Type u :=
  HomogeneousLocalization.Away (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.X i * MvPolynomial.X i')

/-- The coefficient homomorphism from `R` to the overlap of the `i`- and `i'`-charts. -/
def overlapRingHom (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) :
    R →+* OverlapRing n R i i' :=
  (algebraMap (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)
    (OverlapRing n R i i')).comp
      (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0))

/-- The canonical `R`-algebra structure on a projective-space overlap ring. -/
instance overlapRingAlgebra (n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (n + 1)) : Algebra R (OverlapRing n R i i') where
  smul := (inferInstance : SMul R (OverlapRing n R i i')).smul
  algebraMap := overlapRingHom n R i i'
  commutes' _ _ := mul_comm _ _
  smul_def' r x := by
    apply HomogeneousLocalization.val_injective
    rw [HomogeneousLocalization.val_smul, HomogeneousLocalization.val_mul, Algebra.smul_def]
    rfl

/-- Restriction from the `i`-chart to the overlap of the `i`- and `i'`-charts. -/
def toOverlap (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) :
    StandardChartRing n R i →+* OverlapRing n R i i' :=
  HomogeneousLocalization.awayMap
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.isHomogeneous_X R i') rfl

/-- The restriction map from the first chart is Mathlib's homogeneous-localization map. -/
theorem toOverlap_eq_awayMap
    (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) :
    toOverlap n R i i' =
      HomogeneousLocalization.awayMap
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
        (MvPolynomial.isHomogeneous_X R i') rfl :=
  rfl

/-- The restriction from the `i`-chart to its overlap with the `i'`-chart preserves constants. -/
theorem toOverlap_algebraMap (n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (n + 1)) (r : R) :
    toOverlap n R i i' (algebraMap R (StandardChartRing n R i) r) =
      algebraMap R (OverlapRing n R i i') r := by
  change HomogeneousLocalization.awayMap _ _ _
      (HomogeneousLocalization.fromZeroRingHom _ _
        (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0) r)) = _
  rw [HomogeneousLocalization.awayMap_fromZeroRingHom]
  rfl

/-- The `R`-algebra homomorphism restricting the `i`-chart to the `i,i'` overlap. -/
def toOverlapAlgHom (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) :
    StandardChartRing n R i →ₐ[R] OverlapRing n R i i' where
  __ := toOverlap n R i i'
  commutes' := toOverlap_algebraMap n R i i'

/-- Restriction from the `i'`-chart to the overlap written as `D₊(XᵢXᵢ′)`. -/
def fromOtherToOverlap (n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (n + 1)) : StandardChartRing n R i' →+* OverlapRing n R i i' :=
  HomogeneousLocalization.awayMap
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.isHomogeneous_X R i) (mul_comm _ _)

/-- The restriction map from the second chart is Mathlib's homogeneous-localization map. -/
theorem fromOtherToOverlap_eq_awayMap
    (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) :
    fromOtherToOverlap n R i i' =
      HomogeneousLocalization.awayMap
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
        (MvPolynomial.isHomogeneous_X R i) (mul_comm _ _) :=
  rfl

/-- The transition coordinates `Xᵢ′ / Xᵢ` and `Xᵢ / Xᵢ′` are inverse on the overlap. -/
theorem transition_mul_reverse (n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (n + 1)) :
    toOverlap n R i i' (normalizedCoordinate n R i i') *
      fromOtherToOverlap n R i i' (normalizedCoordinate n R i' i) = 1 := by
  rw [HomogeneousLocalization.ext_iff_val]
  simp only [toOverlap, fromOtherToOverlap, normalizedCoordinate,
    HomogeneousLocalization.awayMap_mk, HomogeneousLocalization.val_mul,
    HomogeneousLocalization.Away.val_mk, HomogeneousLocalization.val_one,
    Localization.mk_mul]
  rw [← Localization.mk_one]
  rw [Localization.mk_eq_mk_iff, Localization.r_iff_exists]
  use 1
  simp
  ring

/-- On the `i,i'` overlap, `Xₗ / Xᵢ = (Xᵢ′ / Xᵢ) * (Xₗ / Xᵢ′)`. -/
theorem toOverlap_normalizedCoordinate
    (n : ℕ) (R : Type u) [CommRing R] (i i' l : Fin (n + 1)) :
    toOverlap n R i i' (normalizedCoordinate n R i l) =
      toOverlap n R i i' (normalizedCoordinate n R i i') *
        fromOtherToOverlap n R i i' (normalizedCoordinate n R i' l) := by
  rw [HomogeneousLocalization.ext_iff_val]
  simp only [toOverlap, fromOtherToOverlap, normalizedCoordinate,
    HomogeneousLocalization.awayMap_mk, HomogeneousLocalization.val_mul,
    HomogeneousLocalization.Away.val_mk, Localization.mk_mul]
  rw [Localization.mk_eq_mk_iff, Localization.r_iff_exists]
  use 1
  simp
  ring

/-- The transition coordinate `Xᵢ′ / Xᵢ` is a unit on the `i,i'` overlap. -/
theorem isUnit_toOverlap_normalizedCoordinate
    (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) :
    IsUnit (toOverlap n R i i' (normalizedCoordinate n R i i')) :=
  isUnit_iff_exists_inv'.2 ⟨_, by
    rw [mul_comm]
    exact transition_mul_reverse n R i i'⟩

/-- Restriction from the other chart to the overlap preserves constants. -/
theorem fromOtherToOverlap_algebraMap
    (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) (r : R) :
    fromOtherToOverlap n R i i' (algebraMap R (StandardChartRing n R i') r) =
      algebraMap R (OverlapRing n R i i') r := by
  change HomogeneousLocalization.awayMap _ _ _
      (HomogeneousLocalization.fromZeroRingHom _ _
        (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0) r)) = _
  rw [HomogeneousLocalization.awayMap_fromZeroRingHom]
  rfl

/-- The `R`-algebra homomorphism restricting the other chart to the overlap. -/
def fromOtherToOverlapAlgHom
    (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) :
    StandardChartRing n R i' →ₐ[R] OverlapRing n R i i' where
  __ := fromOtherToOverlap n R i i'
  commutes' := fromOtherToOverlap_algebraMap n R i i'

end ProjectiveSpace

namespace BiprojectiveSpace

/-- Products indexed by Cox monomials split according to their two bidegree components. -/
theorem bidegree_prod {S : Type*} [CommMonoid S]
    {m n : ℕ} (p : BiprojectiveCoordinate m n →₀ ℕ) (u v : S) :
    p.prod (fun x k => match x with
      | .inl _ => u ^ k
      | .inr _ => v ^ k) =
      u ^ (Finsupp.weight bidegreeWeight p).1 *
        v ^ (Finsupp.weight bidegreeWeight p).2 := by
  classical
  refine Finsupp.induction p ?_ ?_
  · simp [Finsupp.weight_apply]
  · intro a b m ha hb ih
    rw [Finsupp.prod_add_index]
    · rw [Finsupp.prod_single_index (by cases a <;> simp)]
      rw [map_add, Finsupp.weight_single, Prod.fst_add, Prod.snd_add]
      cases a <;> simp [bidegreeWeight, ih, pow_add] <;> ac_rfl
    · intro x hx
      split <;> simp
    · intro x hx b₁ b₂
      split <;> simp [pow_add]

/-- Scaling the two blocks of variables scales a monomial by its two weighted degrees. -/
theorem prod_scaled_variables {S : Type*} [CommMonoid S]
    {m n : ℕ} (p : BiprojectiveCoordinate m n →₀ ℕ)
    (x y : BiprojectiveCoordinate m n → S) (u v : S)
    (hx : ∀ l, x (.inl l) = u * y (.inl l))
    (hy : ∀ l, x (.inr l) = v * y (.inr l)) :
    p.prod (fun z k => x z ^ k) =
      u ^ (Finsupp.weight bidegreeWeight p).1 *
        v ^ (Finsupp.weight bidegreeWeight p).2 *
          p.prod (fun z k => y z ^ k) := by
  have hxy : x = fun z => match z with
      | .inl l => u * y (.inl l)
      | .inr l => v * y (.inr l) := by
    funext z
    cases z with
    | inl l => exact hx l
    | inr l => exact hy l
  rw [hxy]
  have hprod :
      p.prod (fun z k => (match z with
        | .inl l => u * y (.inl l)
        | .inr l => v * y (.inr l)) ^ k) =
      p.prod (fun z k =>
        (match z with | .inl _ => u ^ k | .inr _ => v ^ k) * y z ^ k) := by
    apply Finsupp.prod_congr
    intro z hz
    cases z <;> simp [mul_pow]
  rw [hprod, Finsupp.prod_mul, bidegree_prod]

/-- Evaluation of a bihomogeneous polynomial respects independent scaling of its two blocks. -/
theorem aeval_eq_pow_mul_aeval_of_isBihomogeneous
    {R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S]
    {m n d e : ℕ} {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x y : BiprojectiveCoordinate m n → S) (u v : S)
    (hx : ∀ l, x (.inl l) = u * y (.inl l))
    (hy : ∀ l, x (.inr l) = v * y (.inr l)) :
    MvPolynomial.aeval x F = u ^ d * v ^ e * MvPolynomial.aeval y F := by
  classical
  rw [F.as_sum]
  simp only [map_sum, MvPolynomial.aeval_monomial]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro m hm
  rw [prod_scaled_variables m x y u v hx hy]
  have hweight : Finsupp.weight bidegreeWeight m = (d, e) :=
    hF (MvPolynomial.mem_support_iff.mp hm)
  rw [hweight]
  simp only
  ring

/-- An algebra homomorphism commutes with evaluation of a Cox polynomial. -/
theorem map_aeval_algHom
    {R A S : Type*} [CommSemiring R] [CommSemiring A] [CommSemiring S]
    [Algebra R A] [Algebra R S] {m n : ℕ} (f : A →ₐ[R] S)
    (x : BiprojectiveCoordinate m n → A)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    f (MvPolynomial.aeval x F) = MvPolynomial.aeval (fun z => f (x z)) F := by
  change f.toRingHom (MvPolynomial.aeval x F) = _
  rw [MvPolynomial.map_aeval]
  rw [show f.toRingHom.comp (algebraMap R A) = algebraMap R S by
    ext r
    exact f.commutes r]
  rfl

/-- The tensor-product ring on the overlap of two standard biprojective charts. -/
abbrev OverlapRing (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) : Type u :=
  TensorProduct R (ProjectiveSpace.OverlapRing m R i i')
    (ProjectiveSpace.OverlapRing n R j j')

/-- Restriction from the `(i,j)` product chart to its overlap with the `(i',j')` chart. -/
def chartToOverlap (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    StandardChartRing m n R i j →ₐ[R] OverlapRing m n R i i' j j' :=
  Algebra.TensorProduct.map
    (ProjectiveSpace.toOverlapAlgHom m R i i')
    (ProjectiveSpace.toOverlapAlgHom n R j j')

/-- Restriction from the `(i',j')` product chart to its overlap with the `(i,j)` chart. -/
def otherChartToOverlap (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    StandardChartRing m n R i' j' →ₐ[R] OverlapRing m n R i i' j j' :=
  Algebra.TensorProduct.map
    (ProjectiveSpace.fromOtherToOverlapAlgHom m R i i')
    (ProjectiveSpace.fromOtherToOverlapAlgHom n R j j')

/-- Restriction to an overlap commutes with inclusion of the first tensor factor. -/
theorem chartToOverlap_comp_includeLeft
    (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    (chartToOverlap m n R i i' j j').toRingHom.comp
        Algebra.TensorProduct.includeLeftRingHom =
      Algebra.TensorProduct.includeLeftRingHom.comp
        (ProjectiveSpace.toOverlap m R i i') := by
  ext x
  simp [chartToOverlap, ProjectiveSpace.toOverlapAlgHom]

/-- Restriction to an overlap commutes with inclusion of the second tensor factor. -/
theorem chartToOverlap_comp_includeRight
    (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    (chartToOverlap m n R i i' j j').toRingHom.comp
        Algebra.TensorProduct.includeRight.toRingHom =
      Algebra.TensorProduct.includeRight.toRingHom.comp
        (ProjectiveSpace.toOverlap n R j j') := by
  ext x
  simp [chartToOverlap, ProjectiveSpace.toOverlapAlgHom]

/-- Restriction from the other chart commutes with inclusion of the first tensor factor. -/
theorem otherChartToOverlap_comp_includeLeft
    (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    (otherChartToOverlap m n R i i' j j').toRingHom.comp
        Algebra.TensorProduct.includeLeftRingHom =
      Algebra.TensorProduct.includeLeftRingHom.comp
        (ProjectiveSpace.fromOtherToOverlap m R i i') := by
  ext x
  simp [otherChartToOverlap, ProjectiveSpace.fromOtherToOverlapAlgHom]

/-- Restriction from the other chart commutes with inclusion of the second tensor factor. -/
theorem otherChartToOverlap_comp_includeRight
    (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    (otherChartToOverlap m n R i i' j j').toRingHom.comp
        Algebra.TensorProduct.includeRight.toRingHom =
      Algebra.TensorProduct.includeRight.toRingHom.comp
        (ProjectiveSpace.fromOtherToOverlap n R j j') := by
  ext x
  simp [otherChartToOverlap, ProjectiveSpace.fromOtherToOverlapAlgHom]

/-- The first-factor transition coordinate `Xᵢ′ / Xᵢ` on a product-chart overlap. -/
def leftTransition (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) : OverlapRing m n R i i' j j' :=
  ProjectiveSpace.toOverlap m R i i'
      (ProjectiveSpace.normalizedCoordinate m R i i') ⊗ₜ[R] 1

/-- The second-factor transition coordinate `Yⱼ′ / Yⱼ` on a product-chart overlap. -/
def rightTransition (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) : OverlapRing m n R i i' j j' :=
  1 ⊗ₜ[R] ProjectiveSpace.toOverlap n R j j'
      (ProjectiveSpace.normalizedCoordinate n R j j')

/-- The first-factor transition coordinate is a unit on the product-chart overlap. -/
theorem isUnit_leftTransition (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    IsUnit (leftTransition m n R i i' j j') := by
  exact (ProjectiveSpace.isUnit_toOverlap_normalizedCoordinate m R i i').map
    Algebra.TensorProduct.includeLeftRingHom

/-- The second-factor transition coordinate is a unit on the product-chart overlap. -/
theorem isUnit_rightTransition (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    IsUnit (rightTransition m n R i i' j j') := by
  exact (ProjectiveSpace.isUnit_toOverlap_normalizedCoordinate n R j j').map
    Algebra.TensorProduct.includeRight.toRingHom

/-- First-block chart coordinates differ by the first transition coordinate on an overlap. -/
theorem chartToOverlap_chartVariable_inl
    (m n : ℕ) (R : Type u) [CommRing R]
    (i i' l : Fin (m + 1)) (j j' : Fin (n + 1)) :
    chartToOverlap m n R i i' j j' (chartVariable m n R i j (.inl l)) =
      leftTransition m n R i i' j j' *
        otherChartToOverlap m n R i i' j j'
          (chartVariable m n R i' j' (.inl l)) := by
  calc
    _ = ProjectiveSpace.toOverlap m R i i'
          (ProjectiveSpace.normalizedCoordinate m R i l) ⊗ₜ[R]
            (1 : ProjectiveSpace.OverlapRing n R j j') := by
        simp [chartToOverlap, chartVariable, ProjectiveSpace.toOverlapAlgHom]
    _ = (ProjectiveSpace.toOverlap m R i i'
          (ProjectiveSpace.normalizedCoordinate m R i i') *
            ProjectiveSpace.fromOtherToOverlap m R i i'
              (ProjectiveSpace.normalizedCoordinate m R i' l)) ⊗ₜ[R]
                (1 : ProjectiveSpace.OverlapRing n R j j') := by
        rw [ProjectiveSpace.toOverlap_normalizedCoordinate]
    _ = _ := by
      simp [leftTransition, otherChartToOverlap, chartVariable,
        ProjectiveSpace.fromOtherToOverlapAlgHom]

/-- Second-block chart coordinates differ by the second transition coordinate on an overlap. -/
theorem chartToOverlap_chartVariable_inr
    (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' l : Fin (n + 1)) :
    chartToOverlap m n R i i' j j' (chartVariable m n R i j (.inr l)) =
      rightTransition m n R i i' j j' *
        otherChartToOverlap m n R i i' j j'
          (chartVariable m n R i' j' (.inr l)) := by
  calc
    _ = (1 : ProjectiveSpace.OverlapRing m R i i') ⊗ₜ[R]
        ProjectiveSpace.toOverlap n R j j'
          (ProjectiveSpace.normalizedCoordinate n R j l) := by
        simp [chartToOverlap, chartVariable, ProjectiveSpace.toOverlapAlgHom]
    _ = (1 : ProjectiveSpace.OverlapRing m R i i') ⊗ₜ[R]
        (ProjectiveSpace.toOverlap n R j j'
          (ProjectiveSpace.normalizedCoordinate n R j j') *
            ProjectiveSpace.fromOtherToOverlap n R j j'
              (ProjectiveSpace.normalizedCoordinate n R j' l)) := by
        rw [ProjectiveSpace.toOverlap_normalizedCoordinate]
    _ = _ := by
      simp [rightTransition, otherChartToOverlap, chartVariable,
        ProjectiveSpace.fromOtherToOverlapAlgHom]

/--
The two dehomogenizations of a bidegree `(d,e)` polynomial differ by the transition unit
`(Xᵢ′ / Xᵢ) ^ d * (Yⱼ′ / Yⱼ) ^ e` on a product-chart overlap.
-/
theorem chartEquation_overlap
    (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1))
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F) :
    chartToOverlap m n R i i' j j' (chartEquation m n R i j F) =
      leftTransition m n R i i' j j' ^ d * rightTransition m n R i i' j j' ^ e *
        otherChartToOverlap m n R i i' j j' (chartEquation m n R i' j' F) := by
  unfold chartEquation chartEvaluation
  rw [map_aeval_algHom, map_aeval_algHom]
  apply aeval_eq_pow_mul_aeval_of_isBihomogeneous hF
  · intro l
    exact chartToOverlap_chartVariable_inl m n R i i' l j j'
  · intro l
    exact chartToOverlap_chartVariable_inr m n R i i' j j' l

/-- The two restricted chart equations generate the same principal ideal on their overlap. -/
theorem span_chartEquation_overlap
    (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1))
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F) :
    Ideal.span {chartToOverlap m n R i i' j j' (chartEquation m n R i j F)} =
      Ideal.span
        {otherChartToOverlap m n R i i' j j' (chartEquation m n R i' j' F)} := by
  rw [chartEquation_overlap m n R i i' j j' F hF]
  exact Ideal.span_singleton_mul_left_unit
    ((isUnit_leftTransition m n R i i' j j').pow d |>.mul
      ((isUnit_rightTransition m n R i i' j j').pow e)) _

/-- The principal chart ideals have equal extensions to their common overlap ring. -/
theorem map_span_chartEquation_overlap
    (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1))
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F) :
    Ideal.map (chartToOverlap m n R i i' j j').toRingHom
        (Ideal.span {chartEquation m n R i j F}) =
      Ideal.map (otherChartToOverlap m n R i i' j j').toRingHom
        (Ideal.span {chartEquation m n R i' j' F}) := by
  rw [Ideal.map_span, Ideal.map_span, Set.image_singleton, Set.image_singleton]
  change Ideal.span
      {chartToOverlap m n R i i' j j' (chartEquation m n R i j F)} =
    Ideal.span
      {otherChartToOverlap m n R i i' j j' (chartEquation m n R i' j' F)}
  exact span_chartEquation_overlap m n R i i' j j' F hF

end BiprojectiveSpace

end

end BConicBundleMultisections
