import V14Formalization.GenericCharts
import V14Formalization.ProjectiveGeneralFunctionField
import V14Formalization.SchemeFunctionFieldNaturality
import V14Formalization.UniversalNormalDivisor

open CategoryTheory CategoryTheory.Limits TopologicalSpace
open scoped AlgebraicGeometry
open AlgebraicGeometry BConicBundleMultisections

noncomputable section
universe u

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

variable {Omega : Type u} [Field Omega]

theorem GammaIsoTop_inv_eq_appLE
    {X Y : Scheme.{u}} (j : X ⟶ Y) [IsOpenImmersion j] :
    (IsOpenImmersion.ΓIsoTop j).inv =
      j.appLE j.opensRange ⊤ (by simp) := by
  unfold IsOpenImmersion.ΓIsoTop
  simp only [Iso.trans_inv, Functor.mapIso_inv, Iso.op_inv, eqToIso.inv,
    eqToHom_op, Iso.symm_inv, Scheme.Hom.appIso_hom',
    Scheme.Hom.appLE]
  rw [j.naturality_assoc]
  rw [← Functor.map_comp]
  congr 1

theorem biprojectiveGeneralFunctionFieldEquiv_algebraMap
    (p q : ℕ) (P : MvPolynomial (Fin (p + q)) Omega) :
    biprojectiveGeneralFunctionFieldEquiv p q Omega
        (algebraMap (MvPolynomial (Fin (p + q)) Omega)
          (FractionRing (MvPolynomial (Fin (p + q)) Omega)) P) =
      (BiprojectiveSpace p q Omega).germToFunctionField
        ((BiprojectiveSpace.standardChartι p q Omega 0 0).opensRange)
        ((biprojectiveGeneralGammaEquivMvPolynomial p q Omega).symm P) := by
  let E := BiprojectiveSpace p q Omega
  let U := (BiprojectiveSpace.standardChartι p q Omega 0 0).opensRange
  let e := (biprojectiveGeneralGammaEquivMvPolynomial p q Omega).symm
  letI omegaAlgebra : Algebra Omega E.functionField :=
    (biprojectiveGeneralBaseToFunctionField p q Omega).toAlgebra
  letI polyAlgebra : Algebra (MvPolynomial (Fin (p + q)) Omega)
      E.functionField :=
    ((E.germToFunctionField U).hom.comp e.toRingHom).toAlgebra
  letI : IsScalarTower Omega (MvPolynomial (Fin (p + q)) Omega)
      E.functionField :=
    IsScalarTower.of_algebraMap_eq fun _ => rfl
  letI : IsFractionRing Γ(E, U) E.functionField :=
    functionField_isFractionRing_of_isAffineOpen E U
      (isAffineOpen_opensRange
        (BiprojectiveSpace.standardChartι p q Omega 0 0))
  have hcompat (a : MvPolynomial (Fin (p + q)) Omega) :
      algebraMap (MvPolynomial (Fin (p + q)) Omega) E.functionField a =
        algebraMap Γ(E, U) E.functionField (e a) := by rfl
  letI : IsFractionRing (MvPolynomial (Fin (p + q)) Omega)
      E.functionField := IsFractionRing.of_ringEquiv_left e hcompat
  change (FractionRing.algEquiv (MvPolynomial (Fin (p + q)) Omega)
      E.functionField)
        (algebraMap (MvPolynomial (Fin (p + q)) Omega)
          (FractionRing (MvPolynomial (Fin (p + q)) Omega)) P) = _
  rw [AlgEquiv.commutes]
  rfl

theorem biprojective_standardChart_fst_appTop
    (p q : ℕ) (z : ProjectiveSpace.StandardChartRing p Omega 0) :
    (BiprojectiveSpace.standardChartΓIso p q Omega 0 0).hom
        (((pullback.fst
          (ProjectiveSpace.standardChartι p Omega 0 ≫
            ProjectiveSpace.toSpec p Omega)
          (ProjectiveSpace.standardChartι q Omega 0 ≫
            ProjectiveSpace.toSpec q Omega)) :
              BiprojectiveSpace.standardChart p q Omega 0 0 ⟶
                Spec (.of (ProjectiveSpace.StandardChartRing p Omega 0))).appTop
          ((Scheme.ΓSpecIso
            (.of (ProjectiveSpace.StandardChartRing p Omega 0))).inv z)) =
      Algebra.TensorProduct.includeLeftRingHom z := by
  let e := BiprojectiveSpace.standardChartIsoSpec p q Omega 0 0
  let pr : BiprojectiveSpace.standardChart p q Omega 0 0 ⟶
      Spec (.of (ProjectiveSpace.StandardChartRing p Omega 0)) :=
    pullback.fst
      (ProjectiveSpace.standardChartι p Omega 0 ≫
        ProjectiveSpace.toSpec p Omega)
      (ProjectiveSpace.standardChartι q Omega 0 ≫
        ProjectiveSpace.toSpec q Omega)
  have hgeom :=
    BiprojectiveSpace.standardChartIsoSpec_inv_fst p q Omega 0 0
  change e.inv ≫ pr = _ at hgeom
  have hi : (asIso (Scheme.Γ.map e.hom.op)).inv =
      Scheme.Γ.map e.inv.op := by
    symm
    apply IsIso.eq_inv_of_hom_inv_id
    rw [← Functor.map_comp]
    simp
  have hcomp : pr.appTop ≫ (asIso (Scheme.Γ.map e.hom.op)).inv =
      (Spec.map (CommRingCat.ofHom
        (Algebra.TensorProduct.includeLeftRingHom
          (R := Omega)
          (A := ProjectiveSpace.StandardChartRing p Omega 0)
          (B := ProjectiveSpace.StandardChartRing q Omega 0)))).appTop := by
    have hcomp0 := congrArg Scheme.Hom.appTop hgeom
    rw [Scheme.Hom.comp_appTop] at hcomp0
    have hinvapp : e.inv.appTop =
        (asIso (Scheme.Γ.map e.hom.op)).inv := by
      rw [← Scheme.Γ_map_op, hi]
    rw [← hinvapp]
    exact hcomp0
  unfold BiprojectiveSpace.standardChartΓIso
  simp only [Iso.trans_hom, Iso.symm_hom]
  change (((Scheme.ΓSpecIso
      (.of (ProjectiveSpace.StandardChartRing p Omega 0))).inv ≫
      pr.appTop ≫ (asIso (Scheme.Γ.map e.hom.op)).inv ≫
      (Scheme.ΓSpecIso (.of
        (BiprojectiveSpace.StandardChartRing p q Omega 0 0))).hom).hom z) = _
  rw [← Category.assoc pr.appTop
    (asIso (Scheme.Γ.map e.hom.op)).inv, hcomp]
  have hfinal :
      (Scheme.ΓSpecIso
          (.of (ProjectiveSpace.StandardChartRing p Omega 0))).inv ≫
        (Spec.map (CommRingCat.ofHom
          (Algebra.TensorProduct.includeLeftRingHom
            (R := Omega)
            (A := ProjectiveSpace.StandardChartRing p Omega 0)
            (B := ProjectiveSpace.StandardChartRing q Omega 0)))).appTop ≫
        (Scheme.ΓSpecIso (.of
          (BiprojectiveSpace.StandardChartRing p q Omega 0 0))).hom =
        CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
          (R := Omega)
          (A := ProjectiveSpace.StandardChartRing p Omega 0)
          (B := ProjectiveSpace.StandardChartRing q Omega 0)) := by
    rw [← Category.assoc,
      ← Scheme.ΓSpecIso_inv_naturality]
    simp
  exact congrArg (fun f => f.hom z) hfinal

theorem biprojective_standardChart_snd_appTop
    (p q : ℕ) (z : ProjectiveSpace.StandardChartRing q Omega 0) :
    (BiprojectiveSpace.standardChartΓIso p q Omega 0 0).hom
        (((pullback.snd
          (ProjectiveSpace.standardChartι p Omega 0 ≫
            ProjectiveSpace.toSpec p Omega)
          (ProjectiveSpace.standardChartι q Omega 0 ≫
            ProjectiveSpace.toSpec q Omega)) :
              BiprojectiveSpace.standardChart p q Omega 0 0 ⟶
                Spec (.of (ProjectiveSpace.StandardChartRing q Omega 0))).appTop
          ((Scheme.ΓSpecIso
            (.of (ProjectiveSpace.StandardChartRing q Omega 0))).inv z)) =
      Algebra.TensorProduct.includeRight
        (R := Omega)
        (A := ProjectiveSpace.StandardChartRing p Omega 0)
        (B := ProjectiveSpace.StandardChartRing q Omega 0) z := by
  let e := BiprojectiveSpace.standardChartIsoSpec p q Omega 0 0
  let pr : BiprojectiveSpace.standardChart p q Omega 0 0 ⟶
      Spec (.of (ProjectiveSpace.StandardChartRing q Omega 0)) :=
    pullback.snd
      (ProjectiveSpace.standardChartι p Omega 0 ≫
        ProjectiveSpace.toSpec p Omega)
      (ProjectiveSpace.standardChartι q Omega 0 ≫
        ProjectiveSpace.toSpec q Omega)
  have hgeom :=
    BiprojectiveSpace.standardChartIsoSpec_inv_snd p q Omega 0 0
  change e.inv ≫ pr = _ at hgeom
  have hi : (asIso (Scheme.Γ.map e.hom.op)).inv =
      Scheme.Γ.map e.inv.op := by
    symm
    apply IsIso.eq_inv_of_hom_inv_id
    rw [← Functor.map_comp]
    simp
  have hcomp : pr.appTop ≫ (asIso (Scheme.Γ.map e.hom.op)).inv =
      (Spec.map (CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := Omega)
          (A := ProjectiveSpace.StandardChartRing p Omega 0)
          (B := ProjectiveSpace.StandardChartRing q Omega 0)).toRingHom)).appTop := by
    have hcomp0 := congrArg Scheme.Hom.appTop hgeom
    rw [Scheme.Hom.comp_appTop] at hcomp0
    have hinvapp : e.inv.appTop =
        (asIso (Scheme.Γ.map e.hom.op)).inv := by
      rw [← Scheme.Γ_map_op, hi]
    rw [← hinvapp]
    exact hcomp0
  unfold BiprojectiveSpace.standardChartΓIso
  simp only [Iso.trans_hom, Iso.symm_hom]
  change (((Scheme.ΓSpecIso
      (.of (ProjectiveSpace.StandardChartRing q Omega 0))).inv ≫
      pr.appTop ≫ (asIso (Scheme.Γ.map e.hom.op)).inv ≫
      (Scheme.ΓSpecIso (.of
        (BiprojectiveSpace.StandardChartRing p q Omega 0 0))).hom).hom z) = _
  rw [← Category.assoc pr.appTop
    (asIso (Scheme.Γ.map e.hom.op)).inv, hcomp]
  have hfinal :
      (Scheme.ΓSpecIso
          (.of (ProjectiveSpace.StandardChartRing q Omega 0))).inv ≫
        (Spec.map (CommRingCat.ofHom
          (Algebra.TensorProduct.includeRight
            (R := Omega)
            (A := ProjectiveSpace.StandardChartRing p Omega 0)
            (B := ProjectiveSpace.StandardChartRing q Omega 0)).toRingHom)).appTop ≫
        (Scheme.ΓSpecIso (.of
          (BiprojectiveSpace.StandardChartRing p q Omega 0 0))).hom =
        CommRingCat.ofHom (Algebra.TensorProduct.includeRight
          (R := Omega)
          (A := ProjectiveSpace.StandardChartRing p Omega 0)
          (B := ProjectiveSpace.StandardChartRing q Omega 0)).toRingHom := by
    rw [← Category.assoc,
      ← Scheme.ΓSpecIso_inv_naturality]
    simp
  exact congrArg (fun f => f.hom z) hfinal

theorem biprojectiveGeneralFunctionFieldEquiv_X_inl
    (r q : ℕ) (i : Fin (r + 1)) :
    (BiprojectiveSpace.fst (r + 1) q Omega).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
            (MvPolynomial.X i))) =
      biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega
        (algebraMap (MvPolynomial (Fin ((r + 1) + q)) Omega)
          (FractionRing (MvPolynomial (Fin ((r + 1) + q)) Omega))
          (MvPolynomial.X (finSumFinEquiv (r + 1) q (Sum.inl i)))) := by
  rw [projectiveGeneralFunctionFieldEquiv_algebraMap]
  rw [biprojectiveGeneralFunctionFieldEquiv_algebraMap]
  rw [Scheme.Hom.functionFieldMap_germToFunctionField]
  let f := BiprojectiveSpace.fst (r + 1) q Omega
  let jP := ProjectiveSpace.standardChartι (r + 1) Omega 0
  let jE := BiprojectiveSpace.standardChartι (r + 1) q Omega 0 0
  let U := jP.opensRange
  let W := jE.opensRange
  let pr : BiprojectiveSpace.standardChart (r + 1) q Omega 0 0 ⟶
      Spec (.of (ProjectiveSpace.StandardChartRing (r + 1) Omega 0)) :=
    pullback.fst
      (ProjectiveSpace.standardChartι (r + 1) Omega 0 ≫
        ProjectiveSpace.toSpec (r + 1) Omega)
      (ProjectiveSpace.standardChartι q Omega 0 ≫
        ProjectiveSpace.toSpec q Omega)
  have hWU : W ≤ f ⁻¹ᵁ U := by
    intro x hx
    change x ∈ Set.range jE at hx
    change f x ∈ Set.range jP
    obtain ⟨y, rfl⟩ := hx
    refine ⟨pr y, ?_⟩
    exact congrArg (fun g => g y)
      (BiprojectiveSpace.standardChartι_fst
        (r + 1) q Omega 0 0).symm
  have hlocal (s : Γ(ProjectiveSpace (r + 1) Omega, U)) :
      (IsOpenImmersion.ΓIsoTop jE).inv
          (f.appLE U W hWU s) =
        pr.appTop ((IsOpenImmersion.ΓIsoTop jP).inv s) := by
    have H : jE ≫ f = pr ≫ jP :=
      BiprojectiveSpace.standardChartι_fst
        (r + 1) q Omega 0 0
    rw [GammaIsoTop_inv_eq_appLE,
      GammaIsoTop_inv_eq_appLE]
    dsimp [U, W]
    rw [← CommRingCat.comp_apply, ← CommRingCat.comp_apply]
    change _ = ((jP.appLE jP.opensRange ⊤ _ ≫ pr.app ⊤) : _) s
    rw [← Scheme.Hom.appLE_eq_app]
    change ((f.appLE U W hWU ≫
      jE.appLE W ⊤ _) : _) s =
      ((jP.appLE U ⊤ _ ≫ pr.appLE ⊤ ⊤ _) : _) s
    rw [Scheme.Hom.appLE_comp_appLE,
      Scheme.Hom.appLE_comp_appLE]
    have hc := Scheme.Hom.congr_app H U
    change ((((jE ≫ f).app U) ≫ _) : _) s =
      ((((pr ≫ jP).app U) ≫ _) : _) s
    rw [hc, Category.assoc, ← Functor.map_comp]
    congr 1
  let sP := (projectiveGeneralGammaEquivMvPolynomial r Omega).symm
    (MvPolynomial.X i)
  let tE := (biprojectiveGeneralGammaEquivMvPolynomial (r + 1) q Omega).symm
    (MvPolynomial.X (finSumFinEquiv (r + 1) q (Sum.inl i)))
  have hetaW : genericPoint (BiprojectiveSpace (r + 1) q Omega) ∈ W :=
    ((genericPoint_spec (BiprojectiveSpace (r + 1) q Omega)).mem_open_set_iff
      W.isOpen).mpr (by simpa using (inferInstance : Nonempty W))
  have hetaPre : genericPoint (BiprojectiveSpace (r + 1) q Omega) ∈
      f ⁻¹ᵁ U := hWU hetaW
  have hres := (BiprojectiveSpace (r + 1) q Omega).presheaf.germ_res_apply
    (homOfLE hWU) (genericPoint (BiprojectiveSpace (r + 1) q Omega))
    hetaW (f.app U sP)
  change _ = (BiprojectiveSpace (r + 1) q Omega).presheaf.germ W
    (genericPoint (BiprojectiveSpace (r + 1) q Omega)) hetaW tE
  rw [← hres]
  apply congrArg ((BiprojectiveSpace (r + 1) q Omega).presheaf.germ W
    (genericPoint (BiprojectiveSpace (r + 1) q Omega)) hetaW)
  change f.appLE U W hWU sP = tE
  apply ((IsOpenImmersion.ΓIsoTop jE).symm
    |>.commRingCatIsoToRingEquiv).injective
  change (IsOpenImmersion.ΓIsoTop jE).inv
      (f.appLE U W hWU sP) =
    (IsOpenImmersion.ΓIsoTop jE).inv tE
  rw [hlocal]
  apply (BiprojectiveSpace.standardChartΓIso
    (r + 1) q Omega 0 0).commRingCatIsoToRingEquiv.injective
  have hsP : (IsOpenImmersion.ΓIsoTop jP).inv sP =
      (Scheme.ΓSpecIso (.of
        (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).inv
        (ProjectiveSpace.normalizedCoordinate (r + 1) Omega 0
          ((0 : Fin ((r + 1) + 1)).succAbove i)) := by
    apply (Scheme.ΓSpecIso (.of
      (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))
      |>.commRingCatIsoToRingEquiv).injective
    apply (ProjectiveSpace.standardChartRingEquivMvPolynomial
      (r + 1) Omega 0).injective
    change (projectiveGeneralGammaEquivMvPolynomial r Omega) sP = _
    rw [(projectiveGeneralGammaEquivMvPolynomial r Omega).apply_symm_apply]
    change MvPolynomial.X i =
      (ProjectiveSpace.standardChartRingEquivMvPolynomial
        (r + 1) Omega 0)
        ((Scheme.ΓSpecIso (.of
          (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).hom
          ((Scheme.ΓSpecIso (.of
            (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).inv
            (ProjectiveSpace.normalizedCoordinate (r + 1) Omega 0
              ((0 : Fin ((r + 1) + 1)).succAbove i))))
    rw [Iso.inv_hom_id_apply,
      ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
  rw [hsP]
  change (BiprojectiveSpace.standardChartΓIso
      (r + 1) q Omega 0 0).hom
      (pr.appTop ((Scheme.ΓSpecIso (.of
        (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).inv
        (ProjectiveSpace.normalizedCoordinate (r + 1) Omega 0
          ((0 : Fin ((r + 1) + 1)).succAbove i)))) =
    (BiprojectiveSpace.standardChartΓIso
      (r + 1) q Omega 0 0).hom
      ((IsOpenImmersion.ΓIsoTop jE).inv tE)
  rw [biprojective_standardChart_fst_appTop]
  apply (BiprojectiveSpace.standardChartRingEquivMvPolynomial
    (r + 1) q Omega 0 0).injective
  apply (MvPolynomial.renameEquiv Omega
    (@finSumFinEquiv (r + 1) q)).injective
  change _ = (biprojectiveGeneralGammaEquivMvPolynomial
    (r + 1) q Omega) tE
  rw [(biprojectiveGeneralGammaEquivMvPolynomial
    (r + 1) q Omega).apply_symm_apply]
  change (MvPolynomial.renameEquiv Omega
      (@finSumFinEquiv (r + 1) q))
      ((BiprojectiveSpace.standardChartRingEquivMvPolynomial
        (r + 1) q Omega 0 0)
        (ProjectiveSpace.normalizedCoordinate (r + 1) Omega 0
          ((0 : Fin ((r + 1) + 1)).succAbove i) ⊗ₜ[Omega] 1)) = _
  rw [BiprojectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_tmul_one]
  simp [MvPolynomial.renameEquiv]

theorem biprojectiveGeneralFunctionFieldEquiv_X_inr
    (p r : ℕ) (i : Fin (r + 1)) :
    (BiprojectiveSpace.snd p (r + 1) Omega).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
            (MvPolynomial.X i))) =
      biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega
        (algebraMap (MvPolynomial (Fin (p + (r + 1))) Omega)
          (FractionRing (MvPolynomial (Fin (p + (r + 1))) Omega))
          (MvPolynomial.X (finSumFinEquiv p (r + 1) (Sum.inr i)))) := by
  rw [projectiveGeneralFunctionFieldEquiv_algebraMap]
  rw [biprojectiveGeneralFunctionFieldEquiv_algebraMap]
  rw [Scheme.Hom.functionFieldMap_germToFunctionField]
  let f := BiprojectiveSpace.snd p (r + 1) Omega
  let jP := ProjectiveSpace.standardChartι (r + 1) Omega 0
  let jE := BiprojectiveSpace.standardChartι p (r + 1) Omega 0 0
  let U := jP.opensRange
  let W := jE.opensRange
  let pr : BiprojectiveSpace.standardChart p (r + 1) Omega 0 0 ⟶
      Spec (.of (ProjectiveSpace.StandardChartRing (r + 1) Omega 0)) :=
    pullback.snd
      (ProjectiveSpace.standardChartι p Omega 0 ≫
        ProjectiveSpace.toSpec p Omega)
      (ProjectiveSpace.standardChartι (r + 1) Omega 0 ≫
        ProjectiveSpace.toSpec (r + 1) Omega)
  have hWU : W ≤ f ⁻¹ᵁ U := by
    intro x hx
    change x ∈ Set.range jE at hx
    change f x ∈ Set.range jP
    obtain ⟨y, rfl⟩ := hx
    refine ⟨pr y, ?_⟩
    exact congrArg (fun g => g y)
      (BiprojectiveSpace.standardChartι_snd
        p (r + 1) Omega 0 0).symm
  have hlocal (s : Γ(ProjectiveSpace (r + 1) Omega, U)) :
      (IsOpenImmersion.ΓIsoTop jE).inv
          (f.appLE U W hWU s) =
        pr.appTop ((IsOpenImmersion.ΓIsoTop jP).inv s) := by
    have H : jE ≫ f = pr ≫ jP :=
      BiprojectiveSpace.standardChartι_snd
        p (r + 1) Omega 0 0
    rw [GammaIsoTop_inv_eq_appLE,
      GammaIsoTop_inv_eq_appLE]
    dsimp [U, W]
    rw [← CommRingCat.comp_apply, ← CommRingCat.comp_apply]
    change _ = ((jP.appLE jP.opensRange ⊤ _ ≫ pr.app ⊤) : _) s
    rw [← Scheme.Hom.appLE_eq_app]
    change ((f.appLE U W hWU ≫
      jE.appLE W ⊤ _) : _) s =
      ((jP.appLE U ⊤ _ ≫ pr.appLE ⊤ ⊤ _) : _) s
    rw [Scheme.Hom.appLE_comp_appLE,
      Scheme.Hom.appLE_comp_appLE]
    have hc := Scheme.Hom.congr_app H U
    change ((((jE ≫ f).app U) ≫ _) : _) s =
      ((((pr ≫ jP).app U) ≫ _) : _) s
    rw [hc, Category.assoc, ← Functor.map_comp]
    congr 1
  let sP := (projectiveGeneralGammaEquivMvPolynomial r Omega).symm
    (MvPolynomial.X i)
  let tE := (biprojectiveGeneralGammaEquivMvPolynomial p (r + 1) Omega).symm
    (MvPolynomial.X (finSumFinEquiv p (r + 1) (Sum.inr i)))
  have hetaW : genericPoint (BiprojectiveSpace p (r + 1) Omega) ∈ W :=
    ((genericPoint_spec (BiprojectiveSpace p (r + 1) Omega)).mem_open_set_iff
      W.isOpen).mpr (by simpa using (inferInstance : Nonempty W))
  have hetaPre : genericPoint (BiprojectiveSpace p (r + 1) Omega) ∈
      f ⁻¹ᵁ U := hWU hetaW
  have hres := (BiprojectiveSpace p (r + 1) Omega).presheaf.germ_res_apply
    (homOfLE hWU) (genericPoint (BiprojectiveSpace p (r + 1) Omega))
    hetaW (f.app U sP)
  change _ = (BiprojectiveSpace p (r + 1) Omega).presheaf.germ W
    (genericPoint (BiprojectiveSpace p (r + 1) Omega)) hetaW tE
  rw [← hres]
  apply congrArg ((BiprojectiveSpace p (r + 1) Omega).presheaf.germ W
    (genericPoint (BiprojectiveSpace p (r + 1) Omega)) hetaW)
  change f.appLE U W hWU sP = tE
  apply ((IsOpenImmersion.ΓIsoTop jE).symm
    |>.commRingCatIsoToRingEquiv).injective
  change (IsOpenImmersion.ΓIsoTop jE).inv
      (f.appLE U W hWU sP) =
    (IsOpenImmersion.ΓIsoTop jE).inv tE
  rw [hlocal]
  apply (BiprojectiveSpace.standardChartΓIso
    p (r + 1) Omega 0 0).commRingCatIsoToRingEquiv.injective
  have hsP : (IsOpenImmersion.ΓIsoTop jP).inv sP =
      (Scheme.ΓSpecIso (.of
        (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).inv
        (ProjectiveSpace.normalizedCoordinate (r + 1) Omega 0
          ((0 : Fin ((r + 1) + 1)).succAbove i)) := by
    apply (Scheme.ΓSpecIso (.of
      (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))
      |>.commRingCatIsoToRingEquiv).injective
    apply (ProjectiveSpace.standardChartRingEquivMvPolynomial
      (r + 1) Omega 0).injective
    change (projectiveGeneralGammaEquivMvPolynomial r Omega) sP = _
    rw [(projectiveGeneralGammaEquivMvPolynomial r Omega).apply_symm_apply]
    change MvPolynomial.X i =
      (ProjectiveSpace.standardChartRingEquivMvPolynomial
        (r + 1) Omega 0)
        ((Scheme.ΓSpecIso (.of
          (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).hom
          ((Scheme.ΓSpecIso (.of
            (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).inv
            (ProjectiveSpace.normalizedCoordinate (r + 1) Omega 0
              ((0 : Fin ((r + 1) + 1)).succAbove i))))
    rw [Iso.inv_hom_id_apply,
      ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
  rw [hsP]
  change (BiprojectiveSpace.standardChartΓIso
      p (r + 1) Omega 0 0).hom
      (pr.appTop ((Scheme.ΓSpecIso (.of
        (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).inv
        (ProjectiveSpace.normalizedCoordinate (r + 1) Omega 0
          ((0 : Fin ((r + 1) + 1)).succAbove i)))) =
    (BiprojectiveSpace.standardChartΓIso
      p (r + 1) Omega 0 0).hom
      ((IsOpenImmersion.ΓIsoTop jE).inv tE)
  rw [biprojective_standardChart_snd_appTop]
  apply (BiprojectiveSpace.standardChartRingEquivMvPolynomial
    p (r + 1) Omega 0 0).injective
  apply (MvPolynomial.renameEquiv Omega
    (@finSumFinEquiv p (r + 1))).injective
  change _ = (biprojectiveGeneralGammaEquivMvPolynomial
    p (r + 1) Omega) tE
  rw [(biprojectiveGeneralGammaEquivMvPolynomial
    p (r + 1) Omega).apply_symm_apply]
  change (MvPolynomial.renameEquiv Omega
      (@finSumFinEquiv p (r + 1)))
      ((BiprojectiveSpace.standardChartRingEquivMvPolynomial
        p (r + 1) Omega 0 0)
        (1 ⊗ₜ[Omega]
          ProjectiveSpace.normalizedCoordinate (r + 1) Omega 0
            ((0 : Fin ((r + 1) + 1)).succAbove i))) = _
  rw [BiprojectiveSpace.standardChartRingEquivMvPolynomial_one_tmul_normalizedCoordinate]
  simp [MvPolynomial.renameEquiv]

end V14Formalization.SchemeGeometry
