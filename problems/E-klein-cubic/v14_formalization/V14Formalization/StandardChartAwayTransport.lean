import V14Formalization.GenericCharts
import V14Formalization.ProjectiveFamilyNaturality

noncomputable section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u
variable {Omega : Type u} [Field Omega]

private abbrev standardA (r : ℕ) (Omega : Type u) [Field Omega] :=
  MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega

private abbrev standardS (r : ℕ) (Omega : Type u) [Field Omega] :
    MvPolynomial (Fin ((r + 1) + 1)) Omega :=
  MvPolynomial.X (0 : Fin ((r + 1) + 1))

set_option backward.isDefEq.respectTransparency false in
theorem standardChartGammaIsoTop_hom_GammaSpecIso_inv
    (r : ℕ) (z : ProjectiveSpace.StandardChartRing (r + 1) Omega 0) :
    let X := ProjectiveSpace (r + 1) Omega
    let f := ProjectiveSpace.standardChartι (r + 1) Omega 0
    let hU := ProjectiveSpace.opensRange_standardChartι
      (r + 1) Omega (0 : Fin ((r + 1) + 1))
    (IsOpenImmersion.ΓIsoTop f).hom
        ((Scheme.ΓSpecIso (.of
          (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).inv z) =
      X.presheaf.map (eqToHom hU).op
        ((AlgebraicGeometry.Proj.awayToSection
          (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1)))) z) := by
  dsimp only
  let U := AlgebraicGeometry.Proj.basicOpen
    (standardA r Omega) (standardS r Omega)
  let e := AlgebraicGeometry.Proj.basicOpenIsoSpec
    (standardA r Omega) (standardS r Omega)
    (MvPolynomial.isHomogeneous_X Omega 0) zero_lt_one
  let f := ProjectiveSpace.standardChartι (r + 1) Omega 0
  apply (ConcreteCategory.bijective_of_isIso
    (IsOpenImmersion.ΓIsoTop f).inv).1
  rw [Iso.hom_inv_id_apply]
  have hz :
      e.hom.appTop.hom
          ((Scheme.ΓSpecIso (.of
            (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).inv z) =
        U.topIso.inv.hom
          ((AlgebraicGeometry.Proj.awayToSection
            (standardA r Omega) (standardS r Omega)) z) := by
    dsimp only [e, U, standardS, standardA]
    rw [AlgebraicGeometry.Proj.basicOpenIsoSpec_hom]
    change ((AlgebraicGeometry.Proj.basicOpenToSpec
      (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
      (MvPolynomial.X (0 : Fin ((r + 1) + 1)))).app ⊤).hom _ = _
    rw [AlgebraicGeometry.Proj.basicOpenToSpec_app_top]
    simp only [CommRingCat.comp_apply, Iso.inv_hom_id_apply]
    rfl
  have hz' := congrArg (fun w => e.inv.appTop.hom w) hz
  simp only [← CommRingCat.comp_apply, ← Scheme.Hom.comp_appTop,
    e.inv_hom_id, Scheme.Hom.id_appTop, CommRingCat.id_apply] at hz'
  have hc := IsOpenImmersion.app_eq_appIso_inv_app_of_comp_eq
    e.inv U.ι f (by rfl) (⊤ : (U : Scheme).Opens)
  have hcz := congrArg (fun q => q.hom
    (U.topIso.inv.hom
      ((AlgebraicGeometry.Proj.awayToSection
        (standardA r Omega) (standardS r Omega)) z))) hc
  have hcz' :
      e.inv.appTop.hom
          (U.topIso.inv.hom
            ((AlgebraicGeometry.Proj.awayToSection
              (standardA r Omega) (standardS r Omega)) z)) =
        ((U.ι.appIso ⊤).inv ≫ f.app (U.ι ''ᵁ ⊤) ≫
          (Spec (.of (ProjectiveSpace.StandardChartRing
            (r + 1) Omega 0))).presheaf.map (eqToHom
              (IsOpenImmersion.app_eq_invApp_app_of_comp_eq_aux
                e.inv U.ι f (by rfl) ⊤)).op).hom
          (U.topIso.inv.hom
            ((AlgebraicGeometry.Proj.awayToSection
              (standardA r Omega) (standardS r Omega)) z)) := by
    exact hcz
  dsimp only [standardA, standardS, U, e, f] at *
  rw [hz', hcz']
  simp only [IsOpenImmersion.ΓIsoTop, Iso.trans_inv,
    Functor.mapIso_inv, Iso.op_inv, eqToIso.inv, eqToHom_op,
    Iso.symm_inv, Scheme.Hom.appIso_hom', Scheme.Hom.map_appLE,
    CommRingCat.comp_apply]
  simp [Scheme.Opens.ι_appIso, Scheme.Hom.appLE,
    Scheme.Opens.topIso_inv]
  have hR :
      (AlgebraicGeometry.Proj.basicOpen
        (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
        (MvPolynomial.X (0 : Fin ((r + 1) + 1)))).ι ''ᵁ ⊤ =
        (ProjectiveSpace.standardChartι (r + 1) Omega 0).opensRange := by
    rw [Scheme.Opens.ι_image_top,
      ProjectiveSpace.opensRange_standardChartι]
    rfl
  let B := AlgebraicGeometry.Proj.basicOpen
    (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
    (MvPolynomial.X (0 : Fin ((r + 1) + 1)))
  let X := ProjectiveSpace (r + 1) Omega
  let S := Spec (.of (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))
  let f0 := ProjectiveSpace.standardChartι (r + 1) Omega 0
  have hTop : B.ι ''ᵁ (⊤ : (B : Scheme).Opens) = B :=
    Scheme.Opens.ι_image_top B
  have hBW : B = f0.opensRange := hTop.symm.trans hR
  have haux := IsOpenImmersion.app_eq_invApp_app_of_comp_eq_aux
    (AlgebraicGeometry.Proj.basicOpenIsoSpec
      (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
      (MvPolynomial.X (0 : Fin ((r + 1) + 1)))
      (MvPolynomial.isHomogeneous_X Omega 0) zero_lt_one).inv
    B.ι f0 (by rfl) (⊤ : (B : Scheme).Opens)
  have hETop :
      (AlgebraicGeometry.Proj.basicOpenIsoSpec
        (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
        (MvPolynomial.X (0 : Fin ((r + 1) + 1)))
        (MvPolynomial.isHomogeneous_X Omega 0) zero_lt_one).inv ⁻¹ᵁ ⊤ =
        (⊤ : S.Opens) :=
    Scheme.Hom.preimage_top _
  have hpostEq : (⊤ : S.Opens) = f0 ⁻¹ᵁ (B.ι ''ᵁ ⊤) :=
    hETop.symm.trans haux
  let pre : CommRingCat.of (ProjectiveSpace.StandardChartRing
      (r + 1) Omega 0) ⟶ Γ(X, f0.opensRange) :=
    AlgebraicGeometry.Proj.awayToSection
        (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
        (MvPolynomial.X (0 : Fin ((r + 1) + 1))) ≫
      X.presheaf.map (eqToHom hBW.symm).op
  let post : Γ(S, f0 ⁻¹ᵁ (B.ι ''ᵁ ⊤)) ⟶ Γ(S, ⊤) :=
    S.presheaf.map (eqToHom hpostEq).op
  have hn := f0.naturality_assoc (eqToHom hR).op post
  have hnp := congrArg (fun q => pre ≫ q) hn
  have hpreL :
      X.presheaf.map (eqToHom hBW.symm).op ≫
          X.presheaf.map (eqToHom hR).op =
        X.presheaf.map (eqToHom hTop).op := by
    rw [← Functor.map_comp]
    exact congrArg X.presheaf.map (Subsingleton.elim _ _)
  have hStd : f0.opensRange = B :=
    ProjectiveSpace.opensRange_standardChartι
      (r + 1) Omega (0 : Fin ((r + 1) + 1))
  have hpreR :
      X.presheaf.map (eqToHom hBW.symm).op =
        X.presheaf.map (eqToHom hStd).op :=
    congrArg X.presheaf.map (Subsingleton.elim _ _)
  have hRangeTop : (⊤ : S.Opens) = f0 ⁻¹ᵁ f0.opensRange :=
    (Scheme.Hom.preimage_opensRange f0).symm
  have hpostR :
      S.presheaf.map
          (((Opens.map f0.base).map (eqToHom hR).op.unop).op) ≫
        S.presheaf.map (eqToHom hpostEq).op =
      S.presheaf.map (eqToHom hRangeTop).op := by
    rw [← Functor.map_comp]
    exact congrArg S.presheaf.map (Subsingleton.elim _ _)
  have hpostFinal :
      S.presheaf.map (homOfLE (le_of_eq hRangeTop)).op =
        S.presheaf.map (eqToHom hRangeTop).op :=
    congrArg S.presheaf.map (Subsingleton.elim _ _)
  dsimp only [pre, post, B, X, S, f0] at hnp hpreL
  have hpreL' := congrArg (fun q =>
    AlgebraicGeometry.Proj.awayToSection
        (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
        (MvPolynomial.X (0 : Fin ((r + 1) + 1))) ≫ q) hpreL
  have hpreL'' := congrArg (fun q => q ≫
    (ProjectiveSpace.standardChartι (r + 1) Omega 0).app
      ((AlgebraicGeometry.Proj.basicOpen
        (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
        (MvPolynomial.X (0 : Fin ((r + 1) + 1)))).ι ''ᵁ ⊤) ≫
    (Spec (.of (ProjectiveSpace.StandardChartRing
      (r + 1) Omega 0))).presheaf.map (eqToHom hpostEq).op) hpreL'
  simp only [Category.assoc] at hpreL' hpreL'' hnp
  have hnp' := hpreL''.symm.trans hnp
  dsimp only [B, X, S, f0] at hpostR hStd hRangeTop
  have hpostR' := congrArg (fun q =>
    AlgebraicGeometry.Proj.awayToSection
        (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
        (MvPolynomial.X (0 : Fin ((r + 1) + 1))) ≫
      (ProjectiveSpace (r + 1) Omega).presheaf.map
        (eqToHom hBW.symm).op ≫
      (ProjectiveSpace.standardChartι (r + 1) Omega 0).app
        (ProjectiveSpace.standardChartι (r + 1) Omega 0).opensRange ≫ q) hpostR
  have hnpClean := hnp'.trans hpostR'
  have hnpz := congrArg (fun q => q.hom z) hnpClean
  convert hnpz using 1
  · simp only [← CommRingCat.comp_apply]
    rw [← CommRingCat.comp_apply]
    congr 1
  · simp only [← CommRingCat.comp_apply]
    change ((Spec (.of (ProjectiveSpace.StandardChartRing
      (r + 1) Omega 0))).presheaf.map
        (homOfLE (le_of_eq hRangeTop)).op).hom
      (((ProjectiveSpace.standardChartι (r + 1) Omega 0).app
        (ProjectiveSpace.standardChartι (r + 1) Omega 0).opensRange).hom
      (((ProjectiveSpace (r + 1) Omega).presheaf.map
        (eqToHom hStd).op).hom
      ((AlgebraicGeometry.Proj.awayToSection
        (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
        (MvPolynomial.X (0 : Fin ((r + 1) + 1)))).hom z))) = _
    rw [hpostFinal]
    rw [← hpreR]
    dsimp only [S, X]
    rfl

end V14Formalization.SchemeGeometry
