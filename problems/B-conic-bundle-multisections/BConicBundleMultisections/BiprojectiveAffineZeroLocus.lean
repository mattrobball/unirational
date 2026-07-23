/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineChart
public import BConicBundleMultisections.BiprojectiveZeroLocusSmooth

/-!
# Affine quotient presentations of biprojective zero-locus charts

Each standard chart of a biprojective zero locus is identified with the spectrum of an ordinary
polynomial ring modulo its explicit affine chart equation. The final compatibility theorem shows
that this quotient presentation carries the same structure morphism as the corresponding open
subscheme of the globally descended zero locus.
-/

@[expose] public section


open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry

namespace BiprojectiveSpace

/-- The top affine open of a standard biprojective chart. It is kept as an abbreviation so its
underlying open is definitionally `⊤` in the subscheme-gluing comparison. -/
abbrev chartTopAffineOpen
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (standardChart m n R i j).affineOpens :=
  ⟨⊤, isAffineOpen_top (standardChart m n R i j)⟩

theorem chartIdealSheaf_ideal_chartTopAffineOpen
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (chartIdealSheaf m n R i j F).ideal
        (chartTopAffineOpen m n R i j) =
      chartIdealTop m n R i j F := by
  exact chartIdealSheaf_ideal_top m n R i j F

theorem map_chartIdealTop_standardChartRingEquivMvPolynomial
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    Ideal.map
        ((standardChartΓIso m n R i j).commRingCatIsoToRingEquiv.trans
          (standardChartRingEquivMvPolynomial m n R i j).toRingEquiv)
        (chartIdealTop m n R i j F) =
      Ideal.span {affineChartEquation m n R i j F} := by
  unfold chartIdealTop
  rw [Ideal.map_span, Set.image_singleton]
  exact congrArg (Ideal.span : Set (MvPolynomial (Fin m ⊕ Fin n) R) → _)
    (congrArg
      (fun x : MvPolynomial (Fin m ⊕ Fin n) R => ({x} : Set _)) <|
      congrArg (standardChartRingEquivMvPolynomial m n R i j)
        (standardChartΓIso_hom_chartEquationSection m n R i j F) |>.trans
          (standardChartRingEquivMvPolynomial_chartEquation m n R i j F))

/-- Global functions on a standard product chart, expressed as an ordinary affine polynomial
ring. -/
noncomputable def chartSectionsEquivMvPolynomial
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    Γ(standardChart m n R i j, ⊤) ≃+*
      MvPolynomial (Fin m ⊕ Fin n) R :=
  (standardChartΓIso m n R i j).commRingCatIsoToRingEquiv.trans
    (standardChartRingEquivMvPolynomial m n R i j).toRingEquiv

/-- The quotient of chart sections by the chart ideal is the ordinary affine polynomial quotient
by the transported chart equation. -/
noncomputable def chartIdealQuotientEquivMvPolynomial
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (Γ(standardChart m n R i j, ⊤) ⧸
      (chartIdealSheaf m n R i j F).ideal
        (chartTopAffineOpen m n R i j)) ≃+*
      (MvPolynomial (Fin m ⊕ Fin n) R ⧸
        Ideal.span {affineChartEquation m n R i j F}) :=
  Ideal.quotientEquiv
    ((chartIdealSheaf m n R i j F).ideal
      (chartTopAffineOpen m n R i j))
    (Ideal.span {affineChartEquation m n R i j F})
    (chartSectionsEquivMvPolynomial m n R i j)
    (by
      rw [chartIdealSheaf_ideal_chartTopAffineOpen]
      exact (map_chartIdealTop_standardChartRingEquivMvPolynomial
        m n R i j F).symm)

/-- The open immersion from the top member of the subscheme affine cover is an isomorphism. -/
instance chartSubschemeCoverTopIsIso
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    IsIso ((chartIdealSheaf m n R i j F).subschemeCover.f
      (chartTopAffineOpen m n R i j)) := by
  let q := (chartIdealSheaf m n R i j F).subschemeCover.f
    (chartTopAffineOpen m n R i j)
  letI : Epi q.base := by
    rw [TopCat.epi_iff_surjective]
    intro x
    rw [← Set.mem_range, ← Scheme.Hom.coe_opensRange]
    simp [q, chartTopAffineOpen]
  exact IsOpenImmersion.isIso q

/-- The chart zero locus is the spectrum of the ordinary affine polynomial ring
modulo the transported chart equation. -/
noncomputable def chartZeroLocusIsoSpecAffineQuotient
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (chartIdealSheaf m n R i j F).subscheme ≅
      Spec (.of (MvPolynomial (Fin m ⊕ Fin n) R ⧸
        Ideal.span {affineChartEquation m n R i j F})) :=
  (asIso ((chartIdealSheaf m n R i j F).subschemeCover.f
    (chartTopAffineOpen m n R i j))).symm ≪≫
    Scheme.Spec.mapIso
      (chartIdealQuotientEquivMvPolynomial m n R i j F).symm.toCommRingCatIso.op

theorem chartZeroLocusToSpec_eq
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    chartZeroLocusToSpec m n R F hF i j =
      (chartIdealSheaf m n R i j F).subschemeι ≫
        standardChartι m n R i j ≫ toSpec m n R := by
  unfold chartZeroLocusToSpec biprojectiveZeroLocusToSpec
  rw [← Category.assoc, chartZeroLocusToGlobal_ι]
  simp only [Category.assoc]

/-- The canonical structure morphism of the affine quotient chart. -/
def affineChartQuotientToSpec
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    Spec (.of (MvPolynomial (Fin m ⊕ Fin n) R ⧸
      Ideal.span {affineChartEquation m n R i j F})) ⟶ Spec (.of R) :=
  Spec.map (CommRingCat.ofHom (algebraMap R
    (MvPolynomial (Fin m ⊕ Fin n) R ⧸
      Ideal.span {affineChartEquation m n R i j F})))

set_option backward.isDefEq.respectTransparency false in
@[reassoc]
theorem chartSubschemeCover_comp_chartZeroLocusIsoSpecAffineQuotient
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (chartIdealSheaf m n R i j F).subschemeCover.f
        (chartTopAffineOpen m n R i j) ≫
      (chartZeroLocusIsoSpecAffineQuotient m n R i j F).hom =
    Spec.map
      (chartIdealQuotientEquivMvPolynomial m n R i j F).symm.toCommRingCatIso.hom := by
  unfold chartZeroLocusIsoSpecAffineQuotient
  simp

@[reassoc]
theorem standardChartIsoSpec_hom_toSpec
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (standardChartIsoSpec m n R i j).hom ≫
        Spec.map (CommRingCat.ofHom
          (algebraMap R (StandardChartRing m n R i j))) =
      standardChartι m n R i j ≫ toSpec m n R := by
  rw [← cancel_epi (standardChartIsoSpec m n R i j).inv]
  simp only [Iso.inv_hom_id_assoc]
  unfold toSpec
  simp only [standardChartι_fst_assoc,
    standardChartIsoSpec_inv_fst_assoc,
    ProjectiveSpace.standardChartι_toSpec, ← Spec.map_comp]
  congr 1

set_option backward.isDefEq.respectTransparency false in
@[reassoc]
theorem chartTopAffineOpen_fromSpec_comp_standardChartIsoSpec
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (chartTopAffineOpen m n R i j).2.fromSpec ≫
        (standardChartIsoSpec m n R i j).hom =
      Spec.map (standardChartΓIso m n R i j).inv := by
  change (isAffineOpen_top (standardChart m n R i j)).fromSpec ≫
      (standardChartIsoSpec m n R i j).hom = _
  rw [IsAffineOpen.fromSpec_top]
  rw [← Scheme.isoSpec_inv_naturality
    (standardChartIsoSpec m n R i j).hom]
  rw [Scheme.isoSpec_Spec_inv, ← Spec.map_comp]
  unfold standardChartΓIso
  simp only [Iso.trans_inv, Iso.symm_inv, asIso_hom]
  congr 1

set_option backward.isDefEq.respectTransparency false in
theorem chartZeroLocusIsoSpecAffineQuotient_hom_toSpec
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (chartZeroLocusIsoSpecAffineQuotient m n R i j F).hom ≫
        affineChartQuotientToSpec m n R i j F =
      chartZeroLocusToSpec m n R F hF i j := by
  rw [chartZeroLocusToSpec_eq]
  rw [← cancel_epi ((chartIdealSheaf m n R i j F).subschemeCover.f
    (chartTopAffineOpen m n R i j))]
  rw [← Category.assoc,
    chartSubschemeCover_comp_chartZeroLocusIsoSpecAffineQuotient]
  unfold affineChartQuotientToSpec
  rw [← Spec.map_comp]
  rw [← Category.assoc,
    Scheme.IdealSheafData.subschemeCover_map_subschemeι]
  rw [Scheme.IdealSheafData.glueDataObjι_ι]
  rw [← standardChartIsoSpec_hom_toSpec]
  simp only [Category.assoc]
  rw [chartTopAffineOpen_fromSpec_comp_standardChartIsoSpec_assoc]
  simp only [← Spec.map_comp]
  rw [Spec.map_injective.eq_iff]
  ext r
  change (chartIdealQuotientEquivMvPolynomial m n R i j F).symm
      ((algebraMap R (MvPolynomial (Fin m ⊕ Fin n) R ⧸
        Ideal.span {affineChartEquation m n R i j F})) r) =
    Ideal.Quotient.mk
      ((chartIdealSheaf m n R i j F).ideal (chartTopAffineOpen m n R i j))
      ((standardChartΓIso m n R i j).inv
        ((algebraMap R (StandardChartRing m n R i j)) r))
  apply (chartIdealQuotientEquivMvPolynomial m n R i j F).injective
  rw [RingEquiv.apply_symm_apply]
  unfold chartIdealQuotientEquivMvPolynomial
  rw [Ideal.quotientEquiv_mk]
  have h : chartSectionsEquivMvPolynomial m n R i j
      ((standardChartΓIso m n R i j).inv
        ((algebraMap R (StandardChartRing m n R i j)) r) ) =
      (algebraMap R (MvPolynomial (Fin m ⊕ Fin n) R)) r := by
    unfold chartSectionsEquivMvPolynomial
    change standardChartRingEquivMvPolynomial m n R i j
      ((standardChartΓIso m n R i j).hom
        ((standardChartΓIso m n R i j).inv
          ((algebraMap R (StandardChartRing m n R i j)) r))) = _
    rw [Iso.inv_hom_id_apply]
    exact (standardChartRingEquivMvPolynomial m n R i j).commutes r
  rw [h]
  exact
    (Ideal.Quotient.mk_algebraMap R
      (Ideal.span {affineChartEquation m n R i j F}) r).symm

end BiprojectiveSpace

end

end BConicBundleMultisections
