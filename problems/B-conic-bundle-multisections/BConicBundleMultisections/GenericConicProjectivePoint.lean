/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GenericConicBaseChange
public import BConicBundleMultisections.ResidualComponentHorizontality

/-!
# A common projective point on every chart of a nonsingular conic

This file packages the point used to prove geometric integrality of a smooth plane-conic fibre.
For a nonsingular homogeneous ternary quadratic `Q`, the homogeneous quotient is a domain.  Its
fraction field therefore supplies a point of `V(Q)` whose three homogeneous coordinates are all
nonzero.  The remaining lemmas identify algebra-valued projective points with residue-field
points and record that such a point lies in every corresponding standard chart.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace ProjectiveSpace

attribute [local instance] MvPolynomial.gradedAlgebra

/-- Algebra-valued standard-chart evaluation sends a normalized coordinate to its prescribed
value. -/
theorem standardChartEvalAlgebra_normalizedCoordinate
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S)
    (hxi : x i = 1) (l : Fin (n + 1)) :
    ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x
        (ProjectiveSpace.normalizedCoordinate n R i l) = x l := by
  rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
  · simp [hxi]
  · simp [ProjectiveSpace.standardChartEvalAlgebra,
      ProjectiveSpace.affineCoordinates]

set_option maxHeartbeats 2000000 in
-- The Proj basic-open normalization expands through homogeneous localizations.
/-- If an algebra-valued normalized coordinate is nonzero, the associated projective point lies
in that coordinate's standard chart. -/
theorem pointOfNormalizedCoordinatesAlgebra_mem_standardChart
    {R S : Type u} [CommRing R] [Field S] [Algebra R S]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S)
    (hxi : x i = 1) (l : Fin (n + 1)) (hxl : x l ≠ 0) :
    (ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) n i x).base
        (IsLocalRing.closedPoint S) ∈ ProjectiveSpace.standardChart n R l := by
  let e := ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x
  change (ProjectiveSpace.standardChartι n R i).base
      ((Spec.map (CommRingCat.ofHom e)).base (IsLocalRing.closedPoint S)) ∈
        ProjectiveSpace.standardChart n R l
  change (Spec.map (CommRingCat.ofHom e)).base (IsLocalRing.closedPoint S) ∈
    ProjectiveSpace.standardChartι n R i ⁻¹ᵁ ProjectiveSpace.standardChart n R l
  have hi : (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R) ∈
      MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 1 :=
    MvPolynomial.isHomogeneous_X R i
  have hl : (MvPolynomial.X l : MvPolynomial (Fin (n + 1)) R) ∈
      MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 1 :=
    MvPolynomial.isHomogeneous_X R l
  rw [show ProjectiveSpace.standardChartι n R i ⁻¹ᵁ
      ProjectiveSpace.standardChart n R l =
        PrimeSpectrum.basicOpen
          (HomogeneousLocalization.Away.isLocalizationElem hi hl) by
      exact Proj.awayι_preimage_basicOpen
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
        hi zero_lt_one hl zero_lt_one]
  let a : ProjectiveSpace.StandardChartRing n R i :=
    HomogeneousLocalization.Away.isLocalizationElem hi hl
  have ha : a = ProjectiveSpace.normalizedCoordinate n R i l := by
    rw [HomogeneousLocalization.ext_iff_val]
    simp [a, ProjectiveSpace.normalizedCoordinate,
      HomogeneousLocalization.Away.val_mk]
  have hmem : PrimeSpectrum.comap e (IsLocalRing.closedPoint S) ∈
      PrimeSpectrum.basicOpen a := by
    rw [PrimeSpectrum.mem_basicOpen]
    rw [PrimeSpectrum.comap_asIdeal, Ideal.mem_comap]
    have hnea : e a ≠ 0 := by
      rw [ha, standardChartEvalAlgebra_normalizedCoordinate n i x hxi l]
      exact hxl
    simpa [IsLocalRing.closedPoint, IsLocalRing.maximalIdeal_eq_bot] using hnea
  exact hmem

set_option maxHeartbeats 2000000 in
-- The fraction-field calculation normalizes three quotient coordinates symbolically.
/-- A nonsingular homogeneous ternary quadratic has a fraction-field point with every coordinate
nonzero, normalized at any chosen coordinate. -/
theorem exists_genericConicCoordinates
    {A : Type u} [Field A]
    (Q : MvPolynomial (Fin 3) A)
    [IsDomain (MvPolynomial (Fin 3) A ⧸ Ideal.span {Q})]
    (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (i : Fin 3) :
    let H := MvPolynomial (Fin 3) A ⧸ Ideal.span {Q}
    let L := FractionRing H
    ∃ x : Fin 3 → L,
      x i = 1 ∧ (∀ l, x l ≠ 0) ∧
        MvPolynomial.eval x (MvPolynomial.map (algebraMap A L) Q) = 0 := by
  let H := MvPolynomial (Fin 3) A ⧸ Ideal.span {Q}
  let L := FractionRing H
  let raw : Fin 3 → L := fun l ↦
    algebraMap H L (Ideal.Quotient.mk (Ideal.span {Q}) (MvPolynomial.X l))
  have hmk (l : Fin 3) :
      Ideal.Quotient.mk (Ideal.span {Q}) (MvPolynomial.X l) ≠ (0 : H) := by
    intro hz
    have hmem : (MvPolynomial.X l : MvPolynomial (Fin 3) A) ∈ Ideal.span {Q} :=
      Ideal.Quotient.eq_zero_iff_mem.mp hz
    obtain ⟨a, ha⟩ := Ideal.mem_span_singleton.mp hmem
    have ha_comm : MvPolynomial.X l = a * Q := ha.trans (mul_comm Q a)
    have ha0 : a ≠ 0 := by
      intro ha'
      rw [ha', zero_mul] at ha_comm
      exact MvPolynomial.X_ne_zero l ha_comm
    have htd := MvPolynomial.totalDegree_mul_of_isDomain ha0 hQ0
    rw [← ha_comm, MvPolynomial.totalDegree_X, hQ.totalDegree hQ0] at htd
    omega
  have hraw (l : Fin 3) : raw l ≠ 0 := by
    simpa [raw] using (IsFractionRing.injective H L).ne (hmk l)
  let x : Fin 3 → L := fun l ↦ raw l / raw i
  have hxi : x i = 1 := div_self (hraw i)
  have hx0 (l : Fin 3) : x l ≠ 0 := div_ne_zero (hraw l) (hraw i)
  have hrawQ : MvPolynomial.eval raw (MvPolynomial.map (algebraMap A L) Q) = 0 := by
    rw [MvPolynomial.eval_map, IsScalarTower.algebraMap_eq A H L]
    have heval :
        MvPolynomial.eval₂Hom ((algebraMap H L).comp (algebraMap A H)) raw =
          (algebraMap H L).comp (Ideal.Quotient.mk (Ideal.span {Q})) := by
      apply MvPolynomial.ringHom_ext
      · intro a
        simp only [MvPolynomial.eval₂Hom_C, RingHom.comp_apply]
        symm
        rw [← DFunLike.congr_fun (MvPolynomial.algebraMap_eq A (Fin 3)) a,
          Ideal.Quotient.mk_algebraMap]
      · intro l
        simp [raw]
    change MvPolynomial.eval₂Hom
        ((algebraMap H L).comp (algebraMap A H)) raw Q = 0
    rw [heval]
    change algebraMap H L (Ideal.Quotient.mk (Ideal.span {Q}) Q) = 0
    rw [Ideal.Quotient.mk_singleton_self, map_zero]
  have hxQ : MvPolynomial.eval x (MvPolynomial.map (algebraMap A L) Q) = 0 := by
    have hhom := hQ.map (algebraMap A L)
    change MvPolynomial.eval (fun l ↦ raw l / raw i)
      (MvPolynomial.map (algebraMap A L) Q) = 0
    simp only [div_eq_inv_mul]
    rw [eval_smul_point_of_isHomogeneous hhom]
    rw [hrawQ, mul_zero]
  exact ⟨x, hxi, hx0, hxQ⟩

set_option maxHeartbeats 1000000 in
-- Polynomial induction across the tensor-product chart evaluator is elaboration-heavy.
/-- Algebra-valued biprojective chart evaluation restricts to the first chart factor. -/
theorem biprojectiveChartEvalAlgebra_comp_includeLeft
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    (biprojectiveChartEvalAlgebra (R := R) m n i j x y).comp
        (Algebra.TensorProduct.includeLeftRingHom
          (R := R)
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)) =
      ProjectiveSpace.standardChartEvalAlgebra (R := R) m i x := by
  have hX : ∀ r : Fin m,
      (ProjectiveSpace.standardChartRingEquivMvPolynomial m R i).symm (MvPolynomial.X r)
        = ProjectiveSpace.normalizedCoordinate m R i (i.succAbove r) := by
    intro r
    rw [AlgEquiv.symm_apply_eq]
    exact (ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove
      m R i r).symm
  have key : ∀ p : MvPolynomial (Fin m) R,
      biprojectiveChartEvalAlgebra (R := R) m n i j x y
          ((ProjectiveSpace.standardChartRingEquivMvPolynomial m R i).symm p ⊗ₜ[R] 1)
        = ProjectiveSpace.standardChartEvalAlgebra (R := R) m i x
            ((ProjectiveSpace.standardChartRingEquivMvPolynomial m R i).symm p) := by
    intro p
    induction p using MvPolynomial.induction_on with
    | C a =>
        have h1 : (ProjectiveSpace.standardChartRingEquivMvPolynomial m R i).symm
            (MvPolynomial.C a) = algebraMap R (ProjectiveSpace.StandardChartRing m R i) a := by
          rw [AlgEquiv.symm_apply_eq]; simp
        have h2 :
            algebraMap R (ProjectiveSpace.StandardChartRing m R i) a ⊗ₜ[R]
                (1 : ProjectiveSpace.StandardChartRing n R j) =
              algebraMap R (BiprojectiveSpace.StandardChartRing m n R i j) a :=
          AlgHom.commutes (Algebra.TensorProduct.includeLeft
            (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
            (B := ProjectiveSpace.StandardChartRing n R j)) a
        rw [h1, h2]
        have hL : biprojectiveChartEvalAlgebra (R := R) m n i j x y
            (algebraMap R (BiprojectiveSpace.StandardChartRing m n R i j) a) =
              algebraMap R S a :=
          DFunLike.congr_fun
            (biprojectiveChartEvalAlgebra_comp_algebraMap (R := R) m n i j x y) a
        rw [hL]
        simp [ProjectiveSpace.standardChartEvalAlgebra, MvPolynomial.algebraMap_eq]
    | add p q hp hq =>
        simp only [map_add, TensorProduct.add_tmul, hp, hq]
    | mul_X p r hp =>
        rw [map_mul, hX r]
        rw [show
            ((ProjectiveSpace.standardChartRingEquivMvPolynomial m R i).symm p *
                ProjectiveSpace.normalizedCoordinate m R i (i.succAbove r)) ⊗ₜ[R]
                  (1 : ProjectiveSpace.StandardChartRing n R j) =
              ((ProjectiveSpace.standardChartRingEquivMvPolynomial m R i).symm p ⊗ₜ[R] 1) *
                (ProjectiveSpace.normalizedCoordinate m R i (i.succAbove r) ⊗ₜ[R] 1) by
          rw [Algebra.TensorProduct.tmul_mul_tmul, mul_one]]
        rw [map_mul, map_mul, hp]
        congr 1
        simp [biprojectiveChartEvalAlgebra, affineChartPoint,
          ProjectiveSpace.standardChartEvalAlgebra, ProjectiveSpace.affineCoordinates]
  ext z
  have hz := key ((ProjectiveSpace.standardChartRingEquivMvPolynomial m R i) z)
  simp only [AlgEquiv.symm_apply_apply] at hz
  exact hz

/-- Going through a biprojective chart and then the first projection is the projective point of
the first block of coordinates. -/
theorem biprojectiveChartPointOfNormalizedAlgebra_comp_standardChartι_fst
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    biprojectiveChartPointOfNormalizedAlgebra (R := R) m n i j x y ≫
        standardChartι m n R i j ≫ fst m n R =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) m i x := by
  rw [standardChartι_fst]
  unfold biprojectiveChartPointOfNormalizedAlgebra
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
  rw [Category.assoc, standardChartIsoSpec_inv_fst_assoc]
  rw [← Category.assoc (Spec.map _), ← Spec.map_comp]
  have hring := biprojectiveChartEvalAlgebra_comp_includeLeft
    (R := R) m n i j x y
  have hmor :
      CommRingCat.ofHom
            (Algebra.TensorProduct.includeLeftRingHom
              (R := R)
              (A := ProjectiveSpace.StandardChartRing m R i)
              (B := ProjectiveSpace.StandardChartRing n R j)) ≫
          CommRingCat.ofHom (biprojectiveChartEvalAlgebra (R := R) m n i j x y) =
        CommRingCat.ofHom (ProjectiveSpace.standardChartEvalAlgebra (R := R) m i x) := by
    rw [← CommRingCat.ofHom_comp]
    exact congrArg CommRingCat.ofHom hring
  rw [congrArg Spec.map hmor]

set_option maxHeartbeats 1000000 in
-- The chart-ring extensionality proof unfolds both polynomial and residue-field evaluators.
/-- Mapping the normalized residue coordinates into an extension field gives the composite of
the residue-field chart map with that field map. -/
theorem standardChartEvalAlgebra_mapped_normalizedResidueCoordinates
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ) (y : ProjectiveSpace n k) (j : Fin (n + 1))
    (hy : y ∈ ProjectiveSpace.standardChart n k j)
    (f : (ProjectiveSpace n k).residueField y →+* L)
    (hf : f.comp (ProjectiveSpace.residueCoefficientMap n k y) = algebraMap k L) :
    ProjectiveSpace.standardChartEvalAlgebra (R := k) n j
        (fun l ↦ f (ProjectiveSpace.normalizedResidueCoordinates n k y j hy l)) =
      f.comp (ProjectiveSpace.standardChartResidueRingHom n k y j hy) := by
  letI : Algebra k ((ProjectiveSpace n k).residueField y) :=
    ProjectiveSpace.residueAlgebra n k y
  let e := ProjectiveSpace.standardChartRingEquivMvPolynomial n k j
  have hX (r : Fin n) :
      e.symm (MvPolynomial.X r) =
        ProjectiveSpace.normalizedCoordinate n k j (j.succAbove r) := by
    dsimp only [e]
    rw [AlgEquiv.symm_apply_eq]
    exact (ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove
      n k j r).symm
  ext z
  obtain ⟨p, rfl⟩ := e.symm.surjective z
  change ((MvPolynomial.aeval
      (ProjectiveSpace.affineCoordinates j
        (fun l ↦ f (ProjectiveSpace.normalizedResidueCoordinates n k y j hy l))) :
          MvPolynomial (Fin n) k →ₐ[k] L) (e (e.symm p))) = _
  rw [e.apply_symm_apply]
  change MvPolynomial.aeval
      (ProjectiveSpace.affineCoordinates j
        (fun l ↦ f (ProjectiveSpace.normalizedResidueCoordinates n k y j hy l))) p =
    f (ProjectiveSpace.standardChartResidueRingHom n k y j hy (e.symm p))
  induction p using MvPolynomial.induction_on with
  | C a =>
      have hC : e.symm (MvPolynomial.C a) =
          algebraMap k (ProjectiveSpace.StandardChartRing n k j) a := by
        rw [AlgEquiv.symm_apply_eq]
        simp [e]
      rw [hC]
      have hres : ProjectiveSpace.standardChartResidueRingHom n k y j hy
          (algebraMap k (ProjectiveSpace.StandardChartRing n k j) a) =
          algebraMap k ((ProjectiveSpace n k).residueField y) a :=
        (ProjectiveSpace.standardChartResidueAlgHom n k y j hy).commutes a
      have hcoeff : f (algebraMap k ((ProjectiveSpace n k).residueField y) a) =
          algebraMap k L a := by
        have hcoeff' := DFunLike.congr_fun hf a
        simpa [ProjectiveSpace.residueAlgebra, RingHom.comp_apply] using hcoeff'
      simpa using ((congrArg f hres).trans hcoeff).symm
  | add p q hp hq =>
      simp only [map_add, hp, hq]
  | mul_X p r hp =>
      simp only [map_mul, hp, hX, MvPolynomial.aeval_X]
      rfl

set_option maxHeartbeats 1000000 in
-- Comparing the two projective points unfolds the residue lift and contravariant Spec maps.
/-- Reconstructing mapped normalized residue coordinates gives the canonical mapped
residue-field point. -/
theorem pointOfNormalizedCoordinatesAlgebra_mapped_normalizedResidueCoordinates
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ) (y : ProjectiveSpace n k) (j : Fin (n + 1))
    (hy : y ∈ ProjectiveSpace.standardChart n k j)
    (f : (ProjectiveSpace n k).residueField y →+* L)
    (hf : f.comp (ProjectiveSpace.residueCoefficientMap n k y) = algebraMap k L) :
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j
        (fun l ↦ f (ProjectiveSpace.normalizedResidueCoordinates n k y j hy l)) =
      Spec.map (CommRingCat.ofHom f) ≫ (ProjectiveSpace n k).fromSpecResidueField y := by
  letI : Algebra k ((ProjectiveSpace n k).residueField y) :=
    ProjectiveSpace.residueAlgebra n k y
  let yAlg := ProjectiveSpace.standardChartResidueAlgHom n k y j hy
  have hlift : Spec.map (CommRingCat.ofHom yAlg.toRingHom) =
      ProjectiveSpace.standardChartResidueLift n k y j hy := by
    have hpre : CommRingCat.ofHom yAlg.toRingHom =
        Spec.preimage (ProjectiveSpace.standardChartResidueLift n k y j hy) := by
      ext z
      rfl
    rw [hpre, Spec.map_preimage]
  unfold ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
  rw [← ProjectiveSpace.standardChartResidueLift_standardChartι n k y j hy]
  rw [← Category.assoc]
  apply (cancel_mono (ProjectiveSpace.standardChartι n k j)).mpr
  rw [← hlift, ← Spec.map_comp]
  have hring := standardChartEvalAlgebra_mapped_normalizedResidueCoordinates
    n y j hy f hf
  have hmor :
      CommRingCat.ofHom yAlg.toRingHom ≫ CommRingCat.ofHom f =
        CommRingCat.ofHom
          (ProjectiveSpace.standardChartEvalAlgebra (R := k) n j
            (fun l ↦ f (ProjectiveSpace.normalizedResidueCoordinates n k y j hy l))) := by
    rw [← CommRingCat.ofHom_comp]
    exact congrArg CommRingCat.ofHom hring.symm
  rw [hmor]

/-- A biprojective algebra-valued point with the indicated nonzero coordinates lies in the
corresponding standard product chart. -/
theorem biprojectiveChartPointOfNormalizedAlgebra_mem_standardChart
    {R S : Type u} [CommRing R] [Field S] [Algebra R S]
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (a : Fin (m + 1)) (b : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (hxa : x a ≠ 0) (hyb : y b ≠ 0) :
    (biprojectiveChartPointOfNormalizedAlgebra (R := R) m n i j x y ≫
      standardChartι m n R i j).base (IsLocalRing.closedPoint S) ∈
        Set.range (standardChartι m n R a b) := by
  have hRange : Set.range (standardChartι m n R a b) =
      fst m n R ⁻¹' Set.range (ProjectiveSpace.standardChartι m R a) ∩
        snd m n R ⁻¹' Set.range (ProjectiveSpace.standardChartι n R b) := by
    have h := Scheme.Pullback.range_map
      (ProjectiveSpace.standardChartι m R a ≫ ProjectiveSpace.toSpec m R)
      (ProjectiveSpace.standardChartι n R b ≫ ProjectiveSpace.toSpec n R)
      (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)
      (ProjectiveSpace.standardChartι m R a)
      (ProjectiveSpace.standardChartι n R b) (𝟙 _)
      (by simp) (by simp)
    convert h using 1
    dsimp only [BiprojectiveSpace.standardChartι,
      BiprojectiveSpace.standardOpenCover]
    simp only [Scheme.Pullback.openCoverOfLeftRight_f]
    rfl
  rw [hRange]
  constructor
  · change (fst m n R).base
        ((biprojectiveChartPointOfNormalizedAlgebra (R := R) m n i j x y ≫
          standardChartι m n R i j).base (IsLocalRing.closedPoint S)) ∈
      Set.range (ProjectiveSpace.standardChartι m R a).base
    rw [← Scheme.Hom.comp_apply, Category.assoc,
      biprojectiveChartPointOfNormalizedAlgebra_comp_standardChartι_fst,
      ← Scheme.Hom.coe_opensRange, ProjectiveSpace.opensRange_standardChartι]
    exact pointOfNormalizedCoordinatesAlgebra_mem_standardChart m i x hxi a hxa
  · change (snd m n R).base
        ((biprojectiveChartPointOfNormalizedAlgebra (R := R) m n i j x y ≫
          standardChartι m n R i j).base (IsLocalRing.closedPoint S)) ∈
      Set.range (ProjectiveSpace.standardChartι n R b).base
    rw [← Scheme.Hom.comp_apply, Category.assoc,
      biprojectiveChartPointOfNormalizedAlgebra_comp_standardChartι_snd,
      ← Scheme.Hom.coe_opensRange, ProjectiveSpace.opensRange_standardChartι]
    exact pointOfNormalizedCoordinatesAlgebra_mem_standardChart n j y hyj b hyb

end

end BConicBundleMultisections
