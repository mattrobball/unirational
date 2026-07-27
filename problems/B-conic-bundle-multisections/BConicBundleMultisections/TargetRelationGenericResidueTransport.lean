/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.TargetRelationGenericFiberGlobalCoprimality
public import BConicBundleMultisections.SndResidueFiberNonzero
public import Mathlib.AlgebraicGeometry.FunctionField

/-!
# The generic residue field of the first projective plane

This module identifies the residue field at the scheme-theoretic generic point of a projective
plane with the fraction field of any standard affine chart.  It then transports irreducibility
of homogeneous equations to that residue field.
-/

@[expose] public section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra
attribute [local instance] MvPolynomial.algebraMvPolynomial

/-- The explicit pure-transcendental irreducibility theorem is independent of the chosen
fraction-field implementation. -/
theorem MvPolynomial.irreducible_map_isFractionRing_mvPolynomial
    {k : Type u} {σ τ : Type*} {K : Type*}
    [Field k] [Field K]
    [Algebra (MvPolynomial σ k) K]
    [IsFractionRing (MvPolynomial σ k) K]
    [Algebra k K] [IsScalarTower k (MvPolynomial σ k) K]
    (H : MvPolynomial τ k) (hH : Irreducible H) :
    Irreducible (H.map (algebraMap k K)) := by
  let R := MvPolynomial σ k
  let K₀ := FractionRing R
  let e : K₀ ≃ₐ[R] K :=
    IsLocalization.algEquiv (nonZeroDivisors R) K₀ K
  have h₀ : Irreducible (H.map (algebraMap k K₀)) :=
    MvPolynomial.irreducible_map_fractionRing_mvPolynomial H hH
  have he : Irreducible
      ((H.map (algebraMap k K₀)).map e.toRingHom) :=
    by simpa using h₀.map (MvPolynomial.mapEquiv τ e.toRingEquiv)
  have hmap : (H.map (algebraMap k K₀)).map e.toRingHom =
      H.map (algebraMap k K) := by
    rw [MvPolynomial.map_map]
    apply congrArg (fun f : k →+* K ↦ H.map f)
    apply RingHom.ext
    intro a
    change e (algebraMap k K₀ a) = algebraMap k K a
    rw [IsScalarTower.algebraMap_apply k R K₀,
      IsScalarTower.algebraMap_apply k R K]
    exact e.commutes (algebraMap k R a)
  rwa [hmap] at he

namespace ProjectiveSpace

/-- The standard-chart coordinate ring embeds in the generic residue field as a field of
fractions. -/
theorem isFractionRing_standardChartResidue_generic
    (k : Type u) [Field k] (j : Fin 3) :
    let η := _root_.genericPoint (ProjectiveSpace 2 k)
    let hη : η ∈ standardChart 2 k j :=
      BiprojectiveSpace.schemeGenericPoint_mem_standardChart k j
    letI : Algebra (StandardChartRing 2 k j) ((ProjectiveSpace 2 k).residueField η) :=
      (standardChartResidueRingHom 2 k η j hη).toAlgebra
    IsFractionRing (StandardChartRing 2 k j)
      ((ProjectiveSpace 2 k).residueField η) := by
  let R := StandardChartRing 2 k j
  letI : IsDomain R := BiprojectiveSpace.isDomain_Away k j
  let X := ProjectiveSpace 2 k
  let U := Spec (.of R)
  let f : U ⟶ X := standardChartι 2 k j
  let x₀ : U := (⊥ : PrimeSpectrum R)
  let η := _root_.genericPoint X
  let hη : η ∈ standardChart 2 k j :=
    BiprojectiveSpace.schemeGenericPoint_mem_standardChart k j
  let K := X.residueField η
  let ρ : R →+* K := standardChartResidueRingHom 2 k η j hη
  letI : Algebra R K := ρ.toAlgebra
  have hx₀ : f x₀ = η := by
    have h := genericPoint_eq_of_isOpenImmersion f
    simpa [U, x₀, η, genericPoint_eq_bot_of_affine] using h
  let c : X.residueField η ≅ X.residueField (f x₀) :=
    X.residueFieldCongr hx₀.symm
  let r : X.residueField (f x₀) ≅ U.residueField x₀ :=
    asIso (f.residueFieldMap x₀)
  let eOpen : X.residueField η ≅ U.residueField x₀ := c ≪≫ r
  let eSpec : U.residueField x₀ ≅
      CommRingCat.of ((⊥ : Ideal R).ResidueField) :=
    Scheme.Spec.residueFieldIso (.of R) x₀
  let eRing : (⊥ : Ideal R).ResidueField ≃+* K :=
    (eSpec.symm ≪≫ eOpen.symm).commRingCatIsoToRingEquiv
  have heRing : eRing.toRingHom.comp
      (algebraMap R (⊥ : Ideal R).ResidueField) = ρ := by
    have hcat :
        CommRingCat.ofHom (eRing.toRingHom.comp
          (algebraMap R (⊥ : Ideal R).ResidueField)) =
            CommRingCat.ofHom ρ := by
      apply Spec.map_injective
      change Spec.map
          (CommRingCat.ofHom (algebraMap R (⊥ : Ideal R).ResidueField) ≫
            CommRingCat.ofHom eRing.toRingHom) =
        Spec.map (CommRingCat.ofHom ρ)
      rw [Spec.map_comp]
      dsimp only [eRing]
      change Spec.map ((eSpec.symm ≪≫ eOpen.symm).hom) ≫
          Spec.map (CommRingCat.ofHom (algebraMap R (⊥ : Ideal R).ResidueField)) =
        Spec.map (CommRingCat.ofHom ρ)
      change Spec.map (eSpec.inv ≫ eOpen.inv) ≫
          Spec.map (CommRingCat.ofHom (algebraMap R (⊥ : Ideal R).ResidueField)) =
        Spec.map (CommRingCat.ofHom ρ)
      rw [Spec.map_comp]
      rw [Category.assoc,
        Scheme.Spec.map_residueFieldIso_inv_eq_fromSpecResidueField]
      have hρ : Spec.map (CommRingCat.ofHom ρ) =
          standardChartResidueLift 2 k η j hη := by
        change Spec.map (CommRingCat.ofHom
            (Spec.preimage (standardChartResidueLift 2 k η j hη)).hom) = _
        exact Spec.map_preimage _
      rw [hρ]
      apply (cancel_mono f).mp
      rw [Category.assoc, standardChartResidueLift_standardChartι]
      rw [← Scheme.Hom.SpecMap_residueFieldMap_fromSpecResidueField f x₀]
      change Spec.map (r.inv ≫ c.inv) ≫ Spec.map r.hom ≫
          X.fromSpecResidueField (f x₀) = X.fromSpecResidueField η
      rw [Spec.map_comp]
      simp only [Category.assoc]
      rw [← Category.assoc (Spec.map r.inv) (Spec.map r.hom)]
      rw [← Spec.map_comp]
      simp only [Iso.hom_inv_id, Spec.map_id, Category.id_comp]
      exact Scheme.residueFieldCongr_fromSpecResidueField hx₀
    exact congrArg CommRingCat.Hom.hom hcat
  let eAlg : (⊥ : Ideal R).ResidueField ≃ₐ[R] K :=
    { eRing with commutes' := fun a ↦ DFunLike.congr_fun heRing a }
  exact IsFractionRing.of_algEquiv eAlg

/-- An irreducible polynomial over the ground field remains irreducible after mapping its
coefficients to the scheme-theoretic generic residue field of `ℙ²`. -/
theorem irreducible_map_residueCoefficientMap_generic
    (k : Type u) [Field k] {τ : Type*}
    (H : MvPolynomial τ k) (hH : Irreducible H) (j : Fin 3) :
    Irreducible
      (H.map (residueCoefficientMap 2 k
        (_root_.genericPoint (ProjectiveSpace 2 k)))) := by
  let R := StandardChartRing 2 k j
  let P := MvPolynomial (Fin 2) k
  let X := ProjectiveSpace 2 k
  let η := _root_.genericPoint X
  let hη : η ∈ standardChart 2 k j :=
    BiprojectiveSpace.schemeGenericPoint_mem_standardChart k j
  let K := X.residueField η
  let ρR : R →+* K := standardChartResidueRingHom 2 k η j hη
  letI : Algebra R K := ρR.toAlgebra
  letI : IsFractionRing R K :=
    isFractionRing_standardChartResidue_generic k j
  let E : R ≃ₐ[k] P := standardChartRingEquivMvPolynomial 2 k j
  let ρP : P →+* K := (algebraMap R K).comp E.symm.toRingHom
  letI : Algebra P K := ρP.toAlgebra
  letI : IsFractionRing P K := by
    exact (IsFractionRing.isFractionRing_iff_of_base_ringEquiv K E.toRingEquiv).mp
      inferInstance
  letI : Algebra k K := residueAlgebra 2 k η
  letI : IsScalarTower k P K := by
    apply IsScalarTower.of_algebraMap_eq'
    apply RingHom.ext
    intro a
    change residueCoefficientMap 2 k η a =
      ρR (E.symm (MvPolynomial.C a))
    rw [show E.symm (MvPolynomial.C a) = algebraMap k R a by
      exact E.symm.commutes a]
    exact (DFunLike.congr_fun
      (standardChartResidueRingHom_comp_standardChartRingHom
        2 k η j hη) a).symm
  change Irreducible (H.map (algebraMap k K))
  exact MvPolynomial.irreducible_map_isFractionRing_mvPolynomial
    (σ := Fin 2) H hH

end ProjectiveSpace

namespace BiprojectiveSpace

/-- A positive-degree homogeneous equation over the constant field cannot divide the cubic
first-projection fibre equation at the generic point.  Indeed, choose a nonzero projective zero
of the homogeneous equation.  Divisibility would force the corresponding specialization of
`F` to vanish at the generic point of the first projective plane, whereas smoothness rules out a
whole second fibre. -/
theorem not_dvd_fstResidueFiberPolynomial_generic_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hd : 0 < d) (hH : H.IsHomogeneous d) (i : Fin 3) :
    ¬ H.map (ProjectiveSpace.residueCoefficientMap 2 k
          (_root_.genericPoint (ProjectiveSpace 2 k))) ∣
        fstResidueFiberPolynomial F
          (_root_.genericPoint (ProjectiveSpace 2 k)) i
          (schemeGenericPoint_mem_standardChart k i) := by
  let η := _root_.genericPoint (ProjectiveSpace 2 k)
  let hη : η ∈ ProjectiveSpace.standardChart 2 k i :=
    schemeGenericPoint_mem_standardChart k i
  let K := (ProjectiveSpace 2 k).residueField η
  let φ : k →+* K := ProjectiveSpace.residueCoefficientMap 2 k η
  let xη : Fin 3 → K :=
    ProjectiveSpace.normalizedResidueCoordinates 2 k η i hη
  change ¬ H.map φ ∣ fstResidueFiberPolynomial F η i hη
  intro hdiv
  obtain ⟨A, hA⟩ := hdiv
  obtain ⟨y, hy0, hyH⟩ :=
    exists_nonzero_zero_of_homogeneous H hd hH (by decide)
  let yK : Fin 3 → K := fun l ↦ φ (y l)
  have hHyK : MvPolynomial.eval yK (H.map φ) = 0 := by
    rw [MvPolynomial.eval_map]
    have hcomp :
        MvPolynomial.eval₂ φ (fun l ↦ φ (y l)) H = φ (MvPolynomial.eval y H) :=
      (MvPolynomial.eval₂_comp φ y H).symm
    simpa [yK, hyH] using hcomp
  have hQyK :
      MvPolynomial.eval yK (fstResidueFiberPolynomial F η i hη) = 0 := by
    rw [hA, map_mul, hHyK, zero_mul]
  let c : MvPolynomial (Fin 3) k := specializeSecondCoordinates y F
  have hc0 : c ≠ 0 := by
    intro hc
    obtain ⟨j, hyj⟩ := exists_normalizing_coordinate y hy0
    let yn := normalizeCoordinateRepresentative y j
    have hynj : yn j = 1 := normalizeCoordinateRepresentative_apply y j hyj
    have hcyn : specializeSecondCoordinates (m := 2) yn F = 0 := by
      have hyn : yn = (y j)⁻¹ • y := rfl
      have hc' : specializeSecondCoordinates (m := 2) y F = 0 := by
        simpa only [c] using hc
      rw [hyn, hF.specializeSecondCoordinates_smul, hc', mul_zero]
    exact (not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23
      k F hF hF0 j yn hynj) hcyn
  have hgeneric :
      MvPolynomial.eval xη (c.map φ) ≠ 0 := by
    simpa only [η, hη, xη, φ] using
      (eval_normalizedResidue_generic_ne_zero k c 2
        (hF.specializeSecondCoordinates_isHomogeneous y) hc0 i)
  apply hgeneric
  have hcomm :
      MvPolynomial.eval xη (c.map φ) =
        MvPolynomial.eval yK (fstResidueFiberPolynomial F η i hη) := by
    dsimp only [c, fstResidueFiberPolynomial]
    rw [map_specializeSecondCoordinates,
      eval_specializeSecondCoordinates, eval_specializeFirstCoordinates]
  exact hcomm.trans hQyK

/-- Smoothness, positive homogeneity, and irreducibility over the constant field supply the
single global coprimality package for the target relation at the generic point. -/
theorem hasTargetRelationFstFiberGlobalCoprimality_generic_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hd : 0 < d) (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : Fin 3) :
    HasTargetRelationFstFiberGlobalCoprimality F H
      (_root_.genericPoint (ProjectiveSpace 2 k)) i
      (schemeGenericPoint_mem_standardChart k i) := by
  let η := _root_.genericPoint (ProjectiveSpace 2 k)
  let hη : η ∈ ProjectiveSpace.standardChart 2 k i :=
    schemeGenericPoint_mem_standardChart k i
  letI : Algebra k ((ProjectiveSpace 2 k).residueField η) :=
    ProjectiveSpace.residueAlgebra 2 k η
  change HasHomogeneousPlaneCurveGlobalCoprimality
    (fstResidueFiberPolynomial F η i hη)
    (H.map (ProjectiveSpace.residueCoefficientMap 2 k η))
  constructor
  · exact ProjectiveSpace.irreducible_map_residueCoefficientMap_generic
      k H hHirr i
  · exact not_dvd_fstResidueFiberPolynomial_generic_of_smooth
      F hF hF0 H hd hH i

/-- Consequently, the generic fibre of the target relation is locally Artinian. -/
theorem targetRelation_genericFiber_isLocallyArtinian_of_smooth_irreducible
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hd : 0 < d) (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : Fin 3) :
    IsLocallyArtinian
      ((targetRelationToFirst F H).fiber
        (_root_.genericPoint (ProjectiveSpace 2 k))) :=
  targetRelation_genericFiber_isLocallyArtinian_of_globalCoprimality
    F H hF hH i
      (hasTargetRelationFstFiberGlobalCoprimality_generic_of_smooth
        F hF hF0 H hd hH hHirr i)

end BiprojectiveSpace

end

end BConicBundleMultisections
