module

public import BConicBundleMultisections.SndResidueFiberNonzero
public import Mathlib.AlgebraicGeometry.FunctionField

@[expose] public section

open CategoryTheory TopologicalSpace
open AlgebraicGeometry CommRingCat

namespace BConicBundleMultisections.BiprojectiveSpace

noncomputable section
universe u

attribute [local instance] MvPolynomial.gradedAlgebra

/-- At the generic point of projective space, the map from any standard affine
chart ring to the residue field exhibits that field as the fraction field of
the chart ring. -/
theorem standardChartResidueRingHom_isFractionRing_generic
    (k : Type u) [Field k] (i : Fin 3) :
    let Y := ProjectiveSpace 2 k
    let y := _root_.genericPoint Y
    let hy := genericPoint_mem_standardChart' k i
    let R := ProjectiveSpace.StandardChartRing 2 k i
    let ρ := ProjectiveSpace.standardChartResidueRingHom 2 k y i hy
    letI : Algebra R (Y.residueField y) := ρ.toAlgebra
    IsFractionRing R (Y.residueField y) := by
  dsimp only
  let Y := ProjectiveSpace 2 k
  let y := _root_.genericPoint Y
  let hy := genericPoint_mem_standardChart' k i
  let R := ProjectiveSpace.StandardChartRing 2 k i
  let ρ := ProjectiveSpace.standardChartResidueRingHom 2 k y i hy
  letI : Algebra R (Y.residueField y) := ρ.toAlgebra
  haveI : IsDomain R := isDomain_Away k i
  let X := Spec (.of R)
  haveI : IsIntegral X := (affine_isIntegral_iff _).mpr inferInstance
  haveI : IrreducibleSpace X := inferInstance
  haveI : IrreducibleSpace Y := inferInstance
  let x := _root_.genericPoint X
  letI : Algebra R X.functionField :=
    AlgebraicGeometry.instAlgebraCarrierFunctionFieldSpec (.of R)
  haveI : IsFractionRing R X.functionField := by
    exact functionField_isFractionRing_of_affine (.of R)
  let ρX : R →+* X.residueField x :=
    (Spec.preimage (X.fromSpecResidueField x)).hom
  letI : Algebra R (X.residueField x) := ρX.toAlgebra
  have hρX : ρX =
      (X.residue x).hom.comp (algebraMap R X.functionField) := by
    ext a
    simp [ρX, Scheme.fromSpecResidueField, Spec.preimage_comp,
      Spec.fromSpecStalk_eq', X]
    change X.residue x
        ((Spec.preimage (Spec.map (ofHom (algebraMap R X.functionField)))).hom a) = _
    rw [Spec.preimage_map]
    rfl
  let eResRing : X.functionField ≃+* X.residueField x :=
    RingEquiv.ofBijective (X.residue x).hom
      ⟨RingHom.injective (X.residue x).hom, X.residue_surjective x⟩
  let eRes : X.functionField ≃ₐ[R] X.residueField x :=
    AlgEquiv.ofRingEquiv (f := eResRing) (fun a ↦ by
      change X.residue x (algebraMap R X.functionField a) = ρX a
      rw [hρX]
      rfl)
  haveI : IsFractionRing R (X.residueField x) :=
    IsFractionRing.of_algEquiv eRes
  have hxy : (ProjectiveSpace.standardChartι 2 k i).base x = y := by
    simpa [X, x, Y, y, R] using
      genericPoint_eq_of_isOpenImmersion (ProjectiveSpace.standardChartι 2 k i)
  let c : Y.residueField y ≅
      Y.residueField ((ProjectiveSpace.standardChartι 2 k i) x) :=
    Y.residueFieldCongr hxy.symm
  let r : Y.residueField ((ProjectiveSpace.standardChartι 2 k i) x) ≅
      X.residueField x :=
    asIso ((ProjectiveSpace.standardChartι 2 k i).residueFieldMap x)
  let eRing : X.residueField x ≃+* Y.residueField y :=
    (r.symm ≪≫ c.symm).commRingCatIsoToRingEquiv
  have hecomp : eRing.toRingHom.comp ρX = ρ := by
    apply_fun (fun f : R →+* Y.residueField y ↦ Spec.map (ofHom f)) using by
      intro f g hfg
      exact congrArg CommRingCat.Hom.hom (Spec.map_injective hfg)
    change Spec.map (ofHom (eRing.toRingHom.comp ρX)) = Spec.map (ofHom ρ)
    have hlift : ProjectiveSpace.standardChartResidueLift 2 k y i hy =
        Spec.map (ofHom ρ) := (Spec.map_preimage _).symm
    rw [← hlift]
    apply (IsOpenImmersion.lift_uniq
      (f := ProjectiveSpace.standardChartι 2 k i)
      (g := Y.fromSpecResidueField y)
      (by
        rw [Scheme.range_fromSpecResidueField, ← Scheme.Hom.coe_opensRange,
          ProjectiveSpace.opensRange_standardChartι]
        exact Set.singleton_subset_iff.mpr hy)
      (Spec.map (ofHom (eRing.toRingHom.comp ρX))) ?_)
    have hspeccomp : Spec.map (ofHom (eRing.toRingHom.comp ρX)) =
        Spec.map (ofHom eRing.toRingHom) ≫ Spec.map (ofHom ρX) := by
      rw [← Spec.map_comp]
      rfl
    calc
      Spec.map (ofHom (eRing.toRingHom.comp ρX)) ≫
          ProjectiveSpace.standardChartι 2 k i =
        (Spec.map (ofHom eRing.toRingHom) ≫ Spec.map (ofHom ρX)) ≫
          ProjectiveSpace.standardChartι 2 k i :=
            congrArg (· ≫ ProjectiveSpace.standardChartι 2 k i) hspeccomp
      _ = Spec.map (ofHom eRing.toRingHom) ≫
          X.fromSpecResidueField x ≫ ProjectiveSpace.standardChartι 2 k i := by
            rw [Category.assoc, show Spec.map (ofHom ρX) = X.fromSpecResidueField x by
              exact Spec.map_preimage _]
      _ = Y.fromSpecResidueField y := by
        have heRingHom : ofHom eRing.toRingHom = r.inv ≫ c.inv := by
          rfl
        have hmap_eRing : Spec.map (ofHom eRing.toRingHom) =
            Spec.map c.inv ≫ Spec.map r.inv := by
          rw [heRingHom, Spec.map_comp]
        have hr : Spec.map r.inv ≫
              (X.fromSpecResidueField x ≫ ProjectiveSpace.standardChartι 2 k i) =
            Y.fromSpecResidueField
              ((ProjectiveSpace.standardChartι 2 k i) x) := by
          have hres : Spec.map r.hom ≫
                Y.fromSpecResidueField
                  ((ProjectiveSpace.standardChartι 2 k i) x) =
              X.fromSpecResidueField x ≫ ProjectiveSpace.standardChartι 2 k i := by
            exact Scheme.Hom.SpecMap_residueFieldMap_fromSpecResidueField
              (f := ProjectiveSpace.standardChartι 2 k i) x
          calc
            Spec.map r.inv ≫
                (X.fromSpecResidueField x ≫ ProjectiveSpace.standardChartι 2 k i) =
              Spec.map r.inv ≫ (Spec.map r.hom ≫
                Y.fromSpecResidueField
                  ((ProjectiveSpace.standardChartι 2 k i) x)) :=
                congrArg (Spec.map r.inv ≫ ·) hres.symm
            _ = Y.fromSpecResidueField
                ((ProjectiveSpace.standardChartι 2 k i) x) := by
              rw [← Category.assoc, ← Spec.map_comp]
              simp
        have hc : Spec.map c.inv ≫
              Y.fromSpecResidueField
                ((ProjectiveSpace.standardChartι 2 k i) x) =
            Y.fromSpecResidueField y := by
          simpa [c] using Y.residueFieldCongr_fromSpecResidueField hxy
        rw [hmap_eRing]
        simp only [Category.assoc]
        rw [hr, hc]
  let e : X.residueField x ≃ₐ[R] Y.residueField y :=
    AlgEquiv.ofRingEquiv (f := eRing) (fun a ↦ by
      change eRing (ρX a) = ρ a
      exact DFunLike.congr_fun hecomp a)
  exact IsFractionRing.of_algEquiv e

end
end BConicBundleMultisections.BiprojectiveSpace
