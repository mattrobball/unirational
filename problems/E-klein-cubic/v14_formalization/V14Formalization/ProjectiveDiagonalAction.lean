/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.ProjectiveFamilyNaturality
import BConicBundleMultisections.GenericConicProjectivePoint

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

universe u

open AlgebraicGeometry BConicBundleMultisections
open HomogeneousLocalization MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k : Type u} [Field k]

theorem linearSubst_diagonal (n : ℕ) (d : Fin (n + 1) → k)
    (j : Fin (n + 1)) :
    linearSubst n (Matrix.diagonal d) j = C (d j) * X j := by
  classical
  rw [linearSubst, Finset.sum_eq_single j]
  · simp
  · intro b _ hbj
    simp [Ne.symm hbj]
  · simp

def scaleAway (n : ℕ) (i : Fin (n + 1)) (c : k) :
    ProjectiveSpace.StandardChartRing n k i →+*
      Away (coordGraded (R := k) n) (C c * X i) :=
  awayMap (coordGraded (R := k) n)
    (MvPolynomial.isHomogeneous_C (Fin (n + 1)) c)
    (mul_comm (C c) (X i))

def unscaleAway (n : ℕ) (i : Fin (n + 1)) (c : k) (hc : c ≠ 0) :
    Away (coordGraded (R := k) n) (C c * X i) →+*
      ProjectiveSpace.StandardChartRing n k i :=
  awayMap (coordGraded (R := k) n)
    (MvPolynomial.isHomogeneous_C (Fin (n + 1)) c⁻¹)
    (show X i = (C c * X i) * C c⁻¹ by
      symm
      calc
        (C c * X i) * C c⁻¹ = (C c * C c⁻¹) * X i := by ac_rfl
        _ = X i := by rw [← C_mul, mul_inv_cancel₀ hc, C_1, one_mul])

theorem unscaleAway_comp_scaleAway (n : ℕ) (i : Fin (n + 1))
    (c : k) (hc : c ≠ 0) :
    (unscaleAway n i c hc).comp (scaleAway n i c) = RingHom.id _ := by
  apply RingHom.ext
  intro z
  obtain ⟨q, a, ha, rfl⟩ := Away.mk_surjective
    (coordGraded (R := k) n) (MvPolynomial.isHomogeneous_X k i) z
  rw [RingHom.comp_apply]
  simp only [scaleAway, unscaleAway, awayMap_mk]
  rw [HomogeneousLocalization.ext_iff_val]
  simp only [Away.val_mk, RingHom.id_apply]
  congr 1
  rw [mul_assoc, ← mul_pow, ← map_mul, mul_inv_cancel₀ hc, map_one, one_pow, mul_one]

theorem scaleAway_comp_unscaleAway (n : ℕ) (i : Fin (n + 1))
    (c : k) (hc : c ≠ 0) :
    (scaleAway n i c).comp (unscaleAway n i c hc) = RingHom.id _ := by
  apply RingHom.ext
  intro z
  have hscaled : C c * X i ∈ coordGraded (R := k) n 1 := by
    have hC : C c ∈ coordGraded (R := k) n 0 :=
      MvPolynomial.isHomogeneous_C (Fin (n + 1)) c
    have hX : X i ∈ coordGraded (R := k) n 1 :=
      MvPolynomial.isHomogeneous_X k i
    simpa using SetLike.mul_mem_graded hC hX
  obtain ⟨q, a, ha, rfl⟩ := Away.mk_surjective
    (coordGraded (R := k) n) hscaled z
  rw [RingHom.comp_apply]
  simp only [scaleAway, unscaleAway, awayMap_mk]
  rw [HomogeneousLocalization.ext_iff_val]
  simp only [Away.val_mk, RingHom.id_apply]
  congr 1
  rw [mul_assoc, ← mul_pow, ← map_mul, inv_mul_cancel₀ hc, map_one, one_pow, mul_one]

def scaleAwayEquiv (n : ℕ) (i : Fin (n + 1)) (c : k) (hc : c ≠ 0) :
    ProjectiveSpace.StandardChartRing n k i ≃+*
      Away (coordGraded (R := k) n) (C c * X i) :=
  RingEquiv.ofRingHom (scaleAway n i c) (unscaleAway n i c hc)
    (scaleAway_comp_unscaleAway n i c hc)
    (unscaleAway_comp_scaleAway n i c hc)

private theorem specMap_awayMap_zeroDegree_comp_awayι
    {A σ : Type u} [CommRing A] [SetLike σ A] [AddSubgroupClass σ A]
    {𝒶 : ℕ → σ} [GradedRing 𝒶]
    {f g x : A} {m : ℕ}
    (f_deg : f ∈ 𝒶 m) (hm : 0 < m) (g_deg : g ∈ 𝒶 0)
    (hx : x = f * g) :
    Spec.map (CommRingCat.ofHom (awayMap 𝒶 g_deg hx)) ≫
      AlgebraicGeometry.Proj.awayι 𝒶 f f_deg hm =
    AlgebraicGeometry.Proj.awayι 𝒶 x
      (hx ▸ SetLike.mul_mem_graded f_deg g_deg) (by simpa using hm) := by
  rw [AlgebraicGeometry.Proj.awayι, AlgebraicGeometry.Proj.awayι,
    Iso.eq_inv_comp, AlgebraicGeometry.Proj.basicOpenIsoSpec_hom,
    AlgebraicGeometry.Proj.basicOpenToSpec_SpecMap_awayMap_assoc,
    ← AlgebraicGeometry.Proj.basicOpenIsoSpec_hom _ _ f_deg hm,
    Iso.hom_inv_id_assoc, Scheme.homOfLE_ι]

def diagonalScaleAway (n : ℕ) (d : Fin (n + 1) → k)
    (i : Fin (n + 1)) :
    ProjectiveSpace.StandardChartRing n k i →+*
      Away (coordGraded (R := k) n)
        ((linearSubstGradedRingHom n (Matrix.diagonal d)) (X i)) := by
  exact awayMap (coordGraded (R := k) n)
    (MvPolynomial.isHomogeneous_C (Fin (n + 1)) (d i))
    (show (linearSubstGradedRingHom n (Matrix.diagonal d)) (X i) =
        X i * C (d i) by
      rw [V14Formalization.SchemeGeometry.linearSubstGradedRingHom_X,
        linearSubst_diagonal]
      ac_rfl)

def diagonalUnscaleAway (n : ℕ) (d : Fin (n + 1) → k)
    (i : Fin (n + 1)) (hdi : d i ≠ 0) :
    Away (coordGraded (R := k) n)
        ((linearSubstGradedRingHom n (Matrix.diagonal d)) (X i)) →+*
      ProjectiveSpace.StandardChartRing n k i := by
  exact awayMap (coordGraded (R := k) n)
    (MvPolynomial.isHomogeneous_C (Fin (n + 1)) (d i)⁻¹)
    (show X i =
        (linearSubstGradedRingHom n (Matrix.diagonal d)) (X i) * C (d i)⁻¹ by
      rw [V14Formalization.SchemeGeometry.linearSubstGradedRingHom_X,
        linearSubst_diagonal]
      symm
      calc
        (C (d i) * X i) * C (d i)⁻¹ =
            (C (d i) * C (d i)⁻¹) * X i := by ac_rfl
        _ = X i := by
          rw [← C_mul, mul_inv_cancel₀ hdi, C_1, one_mul])

theorem diagonalScaleAway_comp_diagonalUnscaleAway
    (n : ℕ) (d : Fin (n + 1) → k)
    (i : Fin (n + 1)) (hdi : d i ≠ 0) :
    (diagonalScaleAway n d i).comp (diagonalUnscaleAway n d i hdi) =
      RingHom.id _ := by
  apply RingHom.ext
  intro z
  have hscaled :
      (linearSubstGradedRingHom n (Matrix.diagonal d)) (X i) ∈
        coordGraded (R := k) n 1 :=
    (linearSubstGradedRingHom n (Matrix.diagonal d)).map_mem
      (MvPolynomial.isHomogeneous_X k i)
  obtain ⟨q, a, ha, rfl⟩ := Away.mk_surjective
    (coordGraded (R := k) n) hscaled z
  rw [RingHom.comp_apply]
  simp only [diagonalScaleAway, diagonalUnscaleAway, awayMap_mk]
  rw [HomogeneousLocalization.ext_iff_val]
  simp only [Away.val_mk, RingHom.id_apply]
  congr 1
  rw [mul_assoc, ← mul_pow, ← map_mul, inv_mul_cancel₀ hdi,
    map_one, one_pow, mul_one]

theorem diagonalUnscaleAway_comp_diagonalScaleAway
    (n : ℕ) (d : Fin (n + 1) → k)
    (i : Fin (n + 1)) (hdi : d i ≠ 0) :
    (diagonalUnscaleAway n d i hdi).comp (diagonalScaleAway n d i) =
      RingHom.id _ := by
  apply RingHom.ext
  intro z
  obtain ⟨q, a, ha, rfl⟩ := Away.mk_surjective
    (coordGraded (R := k) n) (MvPolynomial.isHomogeneous_X k i) z
  rw [RingHom.comp_apply]
  simp only [diagonalScaleAway, diagonalUnscaleAway, awayMap_mk]
  rw [HomogeneousLocalization.ext_iff_val]
  simp only [Away.val_mk, RingHom.id_apply]
  congr 1
  rw [mul_assoc, ← mul_pow, ← map_mul, mul_inv_cancel₀ hdi,
    map_one, one_pow, mul_one]

def diagonalChartHom (n : ℕ) (d : Fin (n + 1) → k)
    (i : Fin (n + 1)) (hdi : d i ≠ 0) :
    ProjectiveSpace.StandardChartRing n k i →+*
      ProjectiveSpace.StandardChartRing n k i :=
  (diagonalUnscaleAway n d i hdi).comp
    (Away.map (linearSubstGradedRingHom n (Matrix.diagonal d)) (X i))

theorem diagonalChartHom_normalizedCoordinate_eq_self_of_eq
    (n : ℕ) (d : Fin (n + 1) → k)
    (i : Fin (n + 1)) (hdi : d i ≠ 0) (l : Fin (n + 1))
    (hli : d l = d i) :
    diagonalChartHom n d i hdi
        (ProjectiveSpace.normalizedCoordinate n k i l) =
      ProjectiveSpace.normalizedCoordinate n k i l := by
  classical
  unfold diagonalChartHom ProjectiveSpace.normalizedCoordinate
  rw [RingHom.comp_apply, Away.map_mk]
  simp only [diagonalUnscaleAway, awayMap_mk]
  rw [HomogeneousLocalization.ext_iff_val]
  simp only [Away.val_mk]
  rw [V14Formalization.SchemeGeometry.linearSubstGradedRingHom_X,
    linearSubst_diagonal, hli]
  rw [pow_one]
  congr 1
  calc
    C (d i) * X l * C (d i)⁻¹ = (C (d i) * C (d i)⁻¹) * X l := by ring
    _ = X l := by rw [← C_mul, mul_inv_cancel₀ hdi, C_1, one_mul]

theorem diagonalChartHom_normalizedCoordinate_eq_neg_of_eq_neg
    (n : ℕ) (d : Fin (n + 1) → k)
    (i : Fin (n + 1)) (hdi : d i ≠ 0) (l : Fin (n + 1))
    (hli : d l = -d i) :
    diagonalChartHom n d i hdi
        (ProjectiveSpace.normalizedCoordinate n k i l) =
      -ProjectiveSpace.normalizedCoordinate n k i l := by
  classical
  unfold diagonalChartHom ProjectiveSpace.normalizedCoordinate
  rw [RingHom.comp_apply, Away.map_mk]
  simp only [diagonalUnscaleAway, awayMap_mk]
  rw [HomogeneousLocalization.ext_iff_val]
  simp only [Away.val_mk, HomogeneousLocalization.val_neg]
  rw [V14Formalization.SchemeGeometry.linearSubstGradedRingHom_X,
    linearSubst_diagonal, hli]
  rw [Localization.neg_mk]
  congr 1
  rw [map_neg, pow_one]
  calc
    -C (d i) * X l * C (d i)⁻¹ = -(C (d i) * C (d i)⁻¹) * X l := by ring
    _ = -X l := by rw [← C_mul, mul_inv_cancel₀ hdi, C_1, neg_one_mul]

theorem SpecMap_unscaleAway_comp_linearAwayι_diagonal
    (n : ℕ) (d : Fin (n + 1) → k)
    (i : Fin (n + 1)) (hdi : d i ≠ 0) :
    Spec.map (CommRingCat.ofHom (diagonalUnscaleAway n d i hdi)) ≫
        linearAwayι n (Matrix.diagonal d) i =
      ProjectiveSpace.standardChartι n k i := by
  have hscale :
      Spec.map (CommRingCat.ofHom (diagonalScaleAway n d i)) ≫
          ProjectiveSpace.standardChartι n k i =
        linearAwayι n (Matrix.diagonal d) i := by
    unfold linearAwayι ProjectiveSpace.standardChartι
    simpa only [diagonalScaleAway] using
      specMap_awayMap_zeroDegree_comp_awayι
        (MvPolynomial.isHomogeneous_X k i) zero_lt_one
        (MvPolynomial.isHomogeneous_C (Fin (n + 1)) (d i))
        (show (linearSubstGradedRingHom n (Matrix.diagonal d)) (X i) =
            X i * C (d i) by
          rw [V14Formalization.SchemeGeometry.linearSubstGradedRingHom_X,
            linearSubst_diagonal]
          ac_rfl)
  rw [← hscale, ← Category.assoc, ← Spec.map_comp]
  have hcomp :
      CommRingCat.ofHom (diagonalScaleAway n d i) ≫
          CommRingCat.ofHom (diagonalUnscaleAway n d i hdi) =
        𝟙 _ := by
    rw [← CommRingCat.ofHom_comp]
    exact congrArg CommRingCat.ofHom
      (diagonalUnscaleAway_comp_diagonalScaleAway n d i hdi)
  rw [hcomp]
  simpa using Category.id_comp
    (ProjectiveSpace.standardChartι n k i)

theorem standardChartι_comp_mapLinearSubst_diagonal
    (n : ℕ) (d : Fin (n + 1) → k) (hd : ∀ i, d i ≠ 0)
    (i : Fin (n + 1)) :
    ProjectiveSpace.standardChartι n k i ≫
        mapLinearSubst n (Matrix.diagonal d)
          (Matrix.diagonal fun j ↦ (d j)⁻¹)
          (by
            rw [Matrix.diagonal_mul_diagonal]
            simp [hd]) =
      Spec.map (CommRingCat.ofHom (diagonalChartHom n d i (hd i))) ≫
        ProjectiveSpace.standardChartι n k i := by
  let hInv : Matrix.diagonal (fun j ↦ (d j)⁻¹) * Matrix.diagonal d = 1 := by
    rw [Matrix.diagonal_mul_diagonal]
    simp [hd]
  let f := linearSubstGradedRingHom n (Matrix.diagonal d)
  calc
    ProjectiveSpace.standardChartι n k i ≫
        mapLinearSubst n (Matrix.diagonal d) (Matrix.diagonal fun j ↦ (d j)⁻¹) _ =
      (Spec.map (CommRingCat.ofHom (diagonalUnscaleAway n d i (hd i))) ≫
        linearAwayι n (Matrix.diagonal d) i) ≫
          mapLinearSubst n (Matrix.diagonal d)
            (Matrix.diagonal fun j ↦ (d j)⁻¹) hInv := by
        rw [SpecMap_unscaleAway_comp_linearAwayι_diagonal]
    _ = Spec.map (CommRingCat.ofHom (diagonalUnscaleAway n d i (hd i))) ≫
          (linearAwayι n (Matrix.diagonal d) i ≫
            mapLinearSubst n (Matrix.diagonal d)
              (Matrix.diagonal fun j ↦ (d j)⁻¹) hInv) := by
        rw [Category.assoc]
    _ = Spec.map (CommRingCat.ofHom (diagonalUnscaleAway n d i (hd i))) ≫
          Spec.map (CommRingCat.ofHom (Away.map f (X i))) ≫
            ProjectiveSpace.standardChartι n k i := by
        rw [linearAwayι_comp_mapLinearSubst]
    _ = Spec.map (CommRingCat.ofHom (diagonalChartHom n d i (hd i))) ≫
          ProjectiveSpace.standardChartι n k i := by
        rw [← Category.assoc, ← Spec.map_comp]
        congr 2

end V14Formalization.SchemeGeometry

