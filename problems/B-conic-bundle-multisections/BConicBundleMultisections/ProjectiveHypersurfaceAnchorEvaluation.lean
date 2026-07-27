/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveHypersurfaceChartTransition
public import BConicBundleMultisections.GenericConicBaseChange
public import BConicBundleMultisections.HomogeneousJacobianChart
public import BConicBundleMultisections.MvPolynomialHomogeneousEvaluation

/-!
# Evaluating hypersurface charts in an anchor function field

For an irreducible projective plane hypersurface and a retained anchor chart `i`, this file
evaluates every other retained chart `b` in the explicit fraction field attached to `i`.  The
construction uses the homogeneous coordinates `X_l / X_i`, normalized by `X_b / X_i`.

The final theorem identifies this elementary evaluation map with the canonical map obtained by
passing through the intrinsic scheme-theoretic function field.  Thus the explicit cross-chart
transition is independent of the chosen presentation.
-/

@[expose] public section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial

namespace ProjectiveSpace

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k : Type u} [Field k]

/-- Homogeneous evaluation in the anchor function field is the image of ordinary
dehomogenization in the anchor chart quotient. -/
theorem homogeneousPolynomialToFunctionField_eq_algebraMap_mk_dehom
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (P : MvPolynomial (Fin 3) k) :
    hypersurfaceHomogeneousPolynomialToFunctionField H hH hHirr i P =
      algebraMap (HypersurfaceChartQuotient H i.1)
        (HypersurfaceFunctionField H i)
        (Ideal.Quotient.mk
          (Ideal.span {chartDehomogenization 2 k i.1 H})
          (chartDehomogenization 2 k i.1 P)) := by
  rw [
    hypersurfaceHomogeneousPolynomialToFunctionField_eq_algebraMap_chartDehomogenization]
  rfl

/-- The homogeneous coordinates `X_l / X_i` in the function field presented by anchor chart
`i`. -/
def anchorCoordinates
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    Fin 3 → HypersurfaceFunctionField H i :=
  hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i

/-- The defining equation vanishes at the anchor coordinates. -/
theorem eval₂_anchorCoordinates_eq_zero
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    MvPolynomial.eval₂
        (hypersurfaceBaseToFunctionField H hH hHirr i)
        (anchorCoordinates H hH hHirr i) H = 0 := by
  change hypersurfaceHomogeneousPolynomialToFunctionField
    H hH hHirr i H = 0
  rw [homogeneousPolynomialToFunctionField_eq_algebraMap_mk_dehom]
  simp

/-- Evaluate a retained chart of `V(H)` at the generic point represented in anchor chart `i`.

The `b`-chart affine coordinates are `X_l / X_b`, represented in the anchor field as
`(X_l / X_i) / (X_b / X_i)`. -/
def chartToAnchorFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i b : NonemptyHypersurfaceChart H) :
    HypersurfaceChartQuotient H b.1 →+* HypersurfaceFunctionField H i := by
  letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  have hb0 : anchorCoordinates H hH hHirr i b.1 ≠ 0 := by
    exact hypersurfaceNormalizedCoordinateInFunctionField_ne_zero
      H hH hHirr i b
  exact Ideal.Quotient.lift _
    (MvPolynomial.eval₂Hom
      (hypersurfaceBaseToFunctionField H hH hHirr i)
      (affineCoords (anchorCoordinates H hH hHirr i) b.1 hb0))
    (by
      intro P hP
      obtain ⟨A, rfl⟩ := Ideal.mem_span_singleton.mp hP
      rw [map_mul]
      suffices MvPolynomial.eval₂
          (hypersurfaceBaseToFunctionField H hH hHirr i)
          (affineCoords (anchorCoordinates H hH hHirr i) b.1 hb0)
          (chartDehomogenization 2 k b.1 H) = 0 by
        change (MvPolynomial.eval₂Hom
            (hypersurfaceBaseToFunctionField H hH hHirr i)
            (affineCoords (anchorCoordinates H hH hHirr i) b.1 hb0))
            (chartDehomogenization 2 k b.1 H) = 0 at this
        rw [this, zero_mul]
      let K := HypersurfaceFunctionField H i
      letI : Algebra k K :=
        (hypersurfaceBaseToFunctionField H hH hHirr i).toAlgebra
      have hmapH : MvPolynomial.eval
          (anchorCoordinates H hH hHirr i)
          (MvPolynomial.map (algebraMap k K) H) = 0 := by
        rw [← MvPolynomial.eval₂_eq_eval_map]
        exact eval₂_anchorCoordinates_eq_zero H hH hHirr i
      have hchart := eval_chartDehomogenization_eq_zero_of
        (MvPolynomial.map (algebraMap k K) H) d
        (hH.map (algebraMap k K))
        (anchorCoordinates H hH hHirr i) b.1 hb0 hmapH
      rw [chartDehomogenization_map] at hchart
      rw [MvPolynomial.eval₂_eq_eval_map]
      exact hchart)

/-- Evaluation in the anchor chart itself is the ordinary inclusion into its fraction field. -/
theorem chartToAnchorFunctionField_self
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    chartToAnchorFunctionField H hH hHirr i i =
      hypersurfaceChartQuotientToFunctionField H hH hHirr i := by
  letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  apply Ideal.Quotient.ringHom_ext
  apply MvPolynomial.ringHom_ext
  · intro c
    simp only [RingHom.comp_apply]
    unfold chartToAnchorFunctionField
    simp only [Ideal.Quotient.lift_mk]
    unfold hypersurfaceChartQuotientToFunctionField
    rw [MvPolynomial.eval₂Hom_C]
    change algebraMap k (HypersurfaceFunctionField H i) c =
      algebraMap (HypersurfaceChartQuotient H i.1)
        (HypersurfaceFunctionField H i)
        (Ideal.Quotient.mk _ (MvPolynomial.C c))
    rw [show MvPolynomial.C c =
        algebraMap k (MvPolynomial (Fin 2) k) c by rfl]
    rw [Ideal.Quotient.mk_algebraMap]
    exact (IsScalarTower.algebraMap_apply k
      (HypersurfaceChartQuotient H i.1)
      (HypersurfaceFunctionField H i) c).symm
  · intro r
    simp only [RingHom.comp_apply]
    unfold chartToAnchorFunctionField
    simp only [Ideal.Quotient.lift_mk]
    unfold hypersurfaceChartQuotientToFunctionField
    rw [MvPolynomial.eval₂Hom_X']
    change affineCoords (anchorCoordinates H hH hHirr i) i.1 _ r =
      algebraMap (HypersurfaceChartQuotient H i.1)
        (HypersurfaceFunctionField H i)
        (Ideal.Quotient.mk _ (MvPolynomial.X r))
    rw [show affineCoords (anchorCoordinates H hH hHirr i) i.1 _ r =
        anchorCoordinates H hH hHirr i (i.1.succAbove r) by
      simp [affineCoords, anchorCoordinates]]
    unfold anchorCoordinates
    rw [hypersurfaceNormalizedCoordinateInFunctionField_eq_algebraMap]
    rw [chartDehomogenization_X_succAbove]

/-- A homogeneous polynomial dehomogenized in chart `b` evaluates in the anchor field with the
expected homogeneous scaling factor `(X_b / X_i)⁻ᵉ`. -/
theorem chartToAnchorFunctionField_mk_chartDehomogenization
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i b : NonemptyHypersurfaceChart H)
    {e : ℕ} (P : MvPolynomial (Fin 3) k) (hP : P.IsHomogeneous e) :
    letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
      isDomain_chartDehomogenization_quotient_of_irreducible
        i.1 H hH hHirr i.2
    chartToAnchorFunctionField H hH hHirr i b
        (Ideal.Quotient.mk
          (Ideal.span {chartDehomogenization 2 k b.1 H})
          (chartDehomogenization 2 k b.1 P)) =
      (anchorCoordinates H hH hHirr i b.1)⁻¹ ^ e *
        hypersurfaceHomogeneousPolynomialToFunctionField
          H hH hHirr i P := by
  letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  let K := HypersurfaceFunctionField H i
  letI : Algebra k K :=
    (hypersurfaceBaseToFunctionField H hH hHirr i).toAlgebra
  unfold chartToAnchorFunctionField
  simp only [Ideal.Quotient.lift_mk]
  change MvPolynomial.eval₂
      (hypersurfaceBaseToFunctionField H hH hHirr i)
      (affineCoords (anchorCoordinates H hH hHirr i) b.1 _)
      (chartDehomogenization 2 k b.1 P) = _
  rw [MvPolynomial.eval₂_eq_eval_map]
  have hmap :
      MvPolynomial.map (hypersurfaceBaseToFunctionField H hH hHirr i)
          (chartDehomogenization 2 k b.1 P) =
        chartDehomogenization 2 K b.1
          (MvPolynomial.map
            (hypersurfaceBaseToFunctionField H hH hHirr i) P) := by
    exact (chartDehomogenization_map (K := k) (L := K) b.1 P).symm
  rw [hmap]
  rw [eval_chartDehomogenization]
  have hscale := eval_smul_point_of_isHomogeneous
    (hP.map (hypersurfaceBaseToFunctionField H hH hHirr i))
    (anchorCoordinates H hH hHirr i b.1)⁻¹
    (anchorCoordinates H hH hHirr i)
  change MvPolynomial.eval
      (fun j => anchorCoordinates H hH hHirr i j *
        (anchorCoordinates H hH hHirr i b.1)⁻¹)
      (MvPolynomial.map
        (hypersurfaceBaseToFunctionField H hH hHirr i) P) =
    (anchorCoordinates H hH hHirr i b.1)⁻¹ ^ e *
      MvPolynomial.eval₂
        (hypersurfaceBaseToFunctionField H hH hHirr i)
        (anchorCoordinates H hH hHirr i) P
  rw [MvPolynomial.eval₂_eq_eval_map]
  rw [show (fun j => anchorCoordinates H hH hHirr i j *
        (anchorCoordinates H hH hHirr i b.1)⁻¹) =
      fun j => (anchorCoordinates H hH hHirr i b.1)⁻¹ *
        anchorCoordinates H hH hHirr i j by
    funext j
    exact mul_comm _ _]
  exact hscale

/-- The intrinsic function-field comparison sends homogeneous anchor evaluation to the
corresponding dehomogenized class on the anchor chart. -/
theorem hypersurfaceFunctionFieldEquivSchemeFunctionField_homogeneousPolynomial
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) (P : MvPolynomial (Fin 3) k) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceFunctionFieldEquivSchemeFunctionField H hH hd hHirr i
        (hypersurfaceHomogeneousPolynomialToFunctionField H hH hHirr i P) =
      hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
        (Ideal.Quotient.mk
          (Ideal.span {chartDehomogenization 2 k i.1 H})
          (chartDehomogenization 2 k i.1 P)) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  rw [homogeneousPolynomialToFunctionField_eq_algebraMap_mk_dehom]
  rw [hypersurfaceFunctionFieldEquivSchemeFunctionField_algebraMap]

/-- Canonical cross-chart evaluation identity.

Transporting the intrinsic chart-`b` function-field map back through the canonical equivalence
attached to anchor chart `i` is exactly elementary evaluation at the anchor coordinates. -/
theorem hypersurfaceFunctionFieldEquivSchemeFunctionField_symm_comp_chart
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i b : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    (hypersurfaceFunctionFieldEquivSchemeFunctionField
        H hH hd hHirr i).symm.toRingHom.comp
      (hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr b) =
        chartToAnchorFunctionField H hH hHirr i b := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  let E := hypersurfaceFunctionFieldEquivSchemeFunctionField
    H hH hd hHirr i
  apply Ideal.Quotient.ringHom_ext
  apply MvPolynomial.ringHom_ext
  · intro c
    simp only [RingHom.comp_apply]
    have ht := hypersurfaceChartDehomogenization_intrinsic_transition_inv
      H hH hd hHirr i b (MvPolynomial.C c)
        (MvPolynomial.isHomogeneous_C (Fin 3) c)
    have ht' :
        hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr b
            (Ideal.Quotient.mk
              (Ideal.span {chartDehomogenization 2 k b.1 H})
              (MvPolynomial.C c)) =
          E (hypersurfaceHomogeneousPolynomialToFunctionField
            H hH hHirr i (MvPolynomial.C c)) := by
      rw [hypersurfaceFunctionFieldEquivSchemeFunctionField_homogeneousPolynomial]
      simpa using ht
    rw [ht']
    change E.symm
        (E (hypersurfaceHomogeneousPolynomialToFunctionField
          H hH hHirr i (MvPolynomial.C c))) = _
    rw [E.symm_apply_apply]
    symm
    simpa using chartToAnchorFunctionField_mk_chartDehomogenization
      H hH hHirr i b (MvPolynomial.C c)
        (MvPolynomial.isHomogeneous_C (Fin 3) c)
  · intro r
    simp only [RingHom.comp_apply]
    let l : Fin 3 := b.1.succAbove r
    have ht := hypersurfaceChartDehomogenization_intrinsic_transition_inv
      H hH hd hHirr i b (MvPolynomial.X l)
        (MvPolynomial.isHomogeneous_X k l)
    have ht' :
        hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr b
            (Ideal.Quotient.mk
              (Ideal.span {chartDehomogenization 2 k b.1 H})
              (MvPolynomial.X r)) =
          E ((anchorCoordinates H hH hHirr i b.1)⁻¹ *
            hypersurfaceHomogeneousPolynomialToFunctionField
              H hH hHirr i (MvPolynomial.X l)) := by
      rw [map_mul, map_inv₀]
      rw [hypersurfaceFunctionFieldEquivSchemeFunctionField_homogeneousPolynomial]
      change _ =
        (hypersurfaceFunctionFieldEquivSchemeFunctionField H hH hd hHirr i
          (hypersurfaceNormalizedCoordinateInFunctionField
            H hH hHirr i b.1))⁻¹ * _
      rw [show MvPolynomial.X r =
          chartDehomogenization 2 k b.1 (MvPolynomial.X l) by
        simp [l, chartDehomogenization_X_succAbove]]
      simpa only [pow_one] using ht
    rw [ht']
    change E.symm
        (E ((anchorCoordinates H hH hHirr i b.1)⁻¹ *
          hypersurfaceHomogeneousPolynomialToFunctionField
            H hH hHirr i (MvPolynomial.X l))) = _
    rw [E.symm_apply_apply]
    symm
    simpa [l, chartDehomogenization_X_succAbove] using
      chartToAnchorFunctionField_mk_chartDehomogenization
        H hH hHirr i b (MvPolynomial.X l)
          (MvPolynomial.isHomogeneous_X k l)

/-- Forward pointwise form of
`hypersurfaceFunctionFieldEquivSchemeFunctionField_symm_comp_chart`. -/
theorem hypersurfaceFunctionFieldEquivSchemeFunctionField_chartToAnchorFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i b : NonemptyHypersurfaceChart H)
    (x : HypersurfaceChartQuotient H b.1) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceFunctionFieldEquivSchemeFunctionField H hH hd hHirr i
        (chartToAnchorFunctionField H hH hHirr i b x) =
      hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr b x := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  let E := hypersurfaceFunctionFieldEquivSchemeFunctionField
    H hH hd hHirr i
  have hmap :=
    hypersurfaceFunctionFieldEquivSchemeFunctionField_symm_comp_chart
      H hH hd hHirr i b
  have hx := DFunLike.congr_fun hmap x
  change E.symm
      (hypersurfaceChartQuotientToSchemeFunctionField
        H hH hd hHirr b x) =
    chartToAnchorFunctionField H hH hHirr i b x at hx
  rw [← hx]
  exact E.apply_symm_apply _

end ProjectiveSpace

end

end BConicBundleMultisections
