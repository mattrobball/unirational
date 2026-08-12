import V14Formalization.LinearNormalProjectiveChart

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

universe u

attribute [local instance] MvPolynomial.gradedAlgebra

private abbrev GeneralResidualPoly (r : ℕ) (Omega : Type u) [Field Omega] :=
  MvPolynomial (Fin r) Omega

private abbrev GeneralResidualFrac (r : ℕ) (Omega : Type u) [Field Omega] :=
  FractionRing (GeneralResidualPoly r Omega)

private abbrev GeneralAmbientPolyTower (r : ℕ)
    (Omega : Type u) [Field Omega] :=
  Polynomial (GeneralResidualPoly r Omega)

private abbrev GeneralAmbientPolyLocalized (r : ℕ)
    (Omega : Type u) [Field Omega] :=
  Polynomial (GeneralResidualFrac r Omega)

private abbrev GeneralAmbientFrac (r : ℕ) (Omega : Type u) [Field Omega] :=
  FractionRing (GeneralAmbientPolyTower r Omega)

private abbrev generalAmbientCoeffSubmonoid (r : ℕ)
    (Omega : Type u) [Field Omega] :
    Submonoid (GeneralAmbientPolyTower r Omega) :=
  (nonZeroDivisors (GeneralResidualPoly r Omega)).map
    (Polynomial.C : GeneralResidualPoly r Omega →+*
      GeneralAmbientPolyTower r Omega).toMonoidHom

private local instance (r : ℕ) (Omega : Type u) [Field Omega] :
    Algebra (GeneralAmbientPolyTower r Omega)
      (GeneralAmbientPolyLocalized r Omega) :=
  Polynomial.algebra (GeneralResidualPoly r Omega)
    (GeneralResidualFrac r Omega)

private local instance generalAmbientPolyLocalization
    (r : ℕ) (Omega : Type u) [Field Omega] :
    IsLocalization (generalAmbientCoeffSubmonoid r Omega)
      (GeneralAmbientPolyLocalized r Omega) :=
  Polynomial.isLocalization (nonZeroDivisors (GeneralResidualPoly r Omega))
    (GeneralResidualFrac r Omega)

private theorem generalAmbientCoeffSubmonoid_le_nonZeroDivisors
    (r : ℕ) (Omega : Type u) [Field Omega] :
    generalAmbientCoeffSubmonoid r Omega ≤
      nonZeroDivisors (GeneralAmbientPolyTower r Omega) := by
  intro y hy
  rw [mem_nonZeroDivisors_iff_ne_zero]
  intro hy0
  rw [Submonoid.mem_map] at hy
  obtain ⟨a, ha, hay⟩ := hy
  have hCa : Polynomial.C a = 0 := hay.trans hy0
  have ha0 : a = 0 := Polynomial.C_injective (by simpa using hCa)
  exact (nonZeroDivisors.ne_zero ha) ha0

private noncomputable def generalAmbientPolyLocalizedToFrac
    (r : ℕ) (Omega : Type u) [Field Omega] :
    GeneralAmbientPolyLocalized r Omega →+* GeneralAmbientFrac r Omega :=
  IsLocalization.lift (M := generalAmbientCoeffSubmonoid r Omega)
    (S := GeneralAmbientPolyLocalized r Omega)
    (g := algebraMap (GeneralAmbientPolyTower r Omega)
      (GeneralAmbientFrac r Omega))
    (fun y ↦ IsLocalization.map_units (GeneralAmbientFrac r Omega)
      ⟨y.1, generalAmbientCoeffSubmonoid_le_nonZeroDivisors r Omega y.2⟩)

private local instance (r : ℕ) (Omega : Type u) [Field Omega] :
    Algebra (GeneralAmbientPolyLocalized r Omega)
      (GeneralAmbientFrac r Omega) :=
  (generalAmbientPolyLocalizedToFrac r Omega).toAlgebra

private local instance (r : ℕ) (Omega : Type u) [Field Omega] :
    IsScalarTower (GeneralAmbientPolyTower r Omega)
      (GeneralAmbientPolyLocalized r Omega) (GeneralAmbientFrac r Omega) :=
  IsScalarTower.of_algebraMap_eq (fun x ↦ by
    change algebraMap (GeneralAmbientPolyTower r Omega)
        (GeneralAmbientFrac r Omega) x =
      generalAmbientPolyLocalizedToFrac r Omega
        (algebraMap (GeneralAmbientPolyTower r Omega)
          (GeneralAmbientPolyLocalized r Omega) x)
    exact (IsLocalization.lift_eq (M := generalAmbientCoeffSubmonoid r Omega)
      (S := GeneralAmbientPolyLocalized r Omega)
      (P := GeneralAmbientFrac r Omega)
      (fun y ↦ IsLocalization.map_units (GeneralAmbientFrac r Omega)
        ⟨y.1, generalAmbientCoeffSubmonoid_le_nonZeroDivisors r Omega y.2⟩)
      x).symm)

private local instance (r : ℕ) (Omega : Type u) [Field Omega] :
    IsScalarTower Omega (GeneralAmbientPolyLocalized r Omega)
      (GeneralAmbientFrac r Omega) := by
  apply IsScalarTower.of_algebraMap_eq
  intro a
  change algebraMap Omega (GeneralAmbientFrac r Omega) a =
    generalAmbientPolyLocalizedToFrac r Omega
      (algebraMap Omega (GeneralAmbientPolyLocalized r Omega) a)
  rw [show algebraMap Omega (GeneralAmbientPolyLocalized r Omega) a =
      algebraMap (GeneralAmbientPolyTower r Omega)
        (GeneralAmbientPolyLocalized r Omega)
        (algebraMap Omega (GeneralAmbientPolyTower r Omega) a) by
    exact IsScalarTower.algebraMap_apply Omega
      (GeneralAmbientPolyTower r Omega)
      (GeneralAmbientPolyLocalized r Omega) a]
  calc
    algebraMap Omega (GeneralAmbientFrac r Omega) a =
        algebraMap (GeneralAmbientPolyTower r Omega)
          (GeneralAmbientFrac r Omega)
          (algebraMap Omega (GeneralAmbientPolyTower r Omega) a) :=
      IsScalarTower.algebraMap_apply Omega (GeneralAmbientPolyTower r Omega)
        (GeneralAmbientFrac r Omega) a
    _ = generalAmbientPolyLocalizedToFrac r Omega
        (algebraMap (GeneralAmbientPolyTower r Omega)
          (GeneralAmbientPolyLocalized r Omega)
          (algebraMap Omega (GeneralAmbientPolyTower r Omega) a)) :=
      (IsLocalization.lift_eq (M := generalAmbientCoeffSubmonoid r Omega)
        (S := GeneralAmbientPolyLocalized r Omega)
        (P := GeneralAmbientFrac r Omega)
        (fun y ↦ IsLocalization.map_units (GeneralAmbientFrac r Omega)
          ⟨y.1, generalAmbientCoeffSubmonoid_le_nonZeroDivisors r Omega y.2⟩)
        (algebraMap Omega (GeneralAmbientPolyTower r Omega) a)).symm

private local instance generalAmbientPolyLocalizedFraction
    (r : ℕ) (Omega : Type u) [Field Omega] :
    IsFractionRing (GeneralAmbientPolyLocalized r Omega)
      (GeneralAmbientFrac r Omega) :=
  IsFractionRing.isFractionRing_of_isDomain_of_isLocalization
    (generalAmbientCoeffSubmonoid r Omega)
    (GeneralAmbientPolyLocalized r Omega) (GeneralAmbientFrac r Omega)

noncomputable def linearNormalFractionAlgEquivMvPolynomial
    (r : ℕ) (Omega : Type u) [Field Omega] :
    LinearNormalFractionField (r + 1) Omega ≃ₐ[Omega]
      FractionRing (MvPolynomial (Fin (r + 1)) Omega) :=
  ((RatFunc.toFractionRingAlgEquiv (GeneralResidualFrac r Omega) Omega).trans
      ((FractionRing.algEquiv (GeneralAmbientPolyLocalized r Omega)
        (GeneralAmbientFrac r Omega)).restrictScalars Omega)).trans
    (IsFractionRing.algEquivOfAlgEquiv
      (MvPolynomial.finSuccEquiv Omega r)).symm

noncomputable def linearNormalFractionEquivMvPolynomial
    (r : ℕ) (Omega : Type u) [Field Omega] :
    LinearNormalFractionField (r + 1) Omega ≃+*
      FractionRing (MvPolynomial (Fin (r + 1)) Omega) :=
  (linearNormalFractionAlgEquivMvPolynomial r Omega).toRingEquiv

theorem linearNormalFractionEquivMvPolynomial_base
    (r : ℕ) (Omega : Type u) [Field Omega] (a : Omega) :
    linearNormalFractionEquivMvPolynomial r Omega
        (baseToLinearNormalFractionField (r + 1) Omega a) =
      algebraMap Omega (FractionRing (MvPolynomial (Fin (r + 1)) Omega)) a := by
  exact (linearNormalFractionAlgEquivMvPolynomial r Omega).commutes a

private theorem general_restrict_comp_GammaIsoTop_inv
    {X Y : Scheme.{u}} (f : X ⟶ Y) [IsOpenImmersion f] :
    Y.presheaf.map
        (homOfLE (show f.opensRange ≤ (⊤ : Y.Opens) from le_top)).op ≫
        (IsOpenImmersion.ΓIsoTop f).inv =
      f.appTop := by
  simp only [IsOpenImmersion.ΓIsoTop, Iso.trans_inv,
    Functor.mapIso_inv, Iso.op_inv, eqToIso.inv, eqToHom_op,
    Iso.symm_inv, Scheme.Hom.appIso_hom', Scheme.Hom.map_appLE]
  unfold Scheme.Hom.appLE
  change f.appTop ≫ _ = f.appTop
  rw [← Category.comp_id f.appTop]
  congr 1
  rw [← X.presheaf.map_id]
  exact congrArg X.presheaf.map (Subsingleton.elim _ _)

private abbrev projectiveGeneralChart
    (r : ℕ) (Omega : Type u) [Field Omega] :
    (ProjectiveSpace (r + 1) Omega).Opens :=
  (ProjectiveSpace.standardChartι (r + 1) Omega 0).opensRange

private instance projectiveGeneralChart_nonempty
    (r : ℕ) (Omega : Type u) [Field Omega] :
    Nonempty (projectiveGeneralChart r Omega) := by
  refine ⟨⟨ProjectiveSpace.genericPoint (r + 1) Omega, ?_⟩⟩
  simpa [projectiveGeneralChart,
    ProjectiveSpace.opensRange_standardChartι] using
      ProjectiveSpace.genericPoint_mem_standardChart (r + 1) Omega 0

noncomputable def projectiveGeneralGammaEquivMvPolynomial
    (r : ℕ) (Omega : Type u) [Field Omega] :
    Γ(ProjectiveSpace (r + 1) Omega, projectiveGeneralChart r Omega) ≃+*
      MvPolynomial (Fin (r + 1)) Omega :=
  (IsOpenImmersion.ΓIsoTop
      (ProjectiveSpace.standardChartι (r + 1) Omega 0)).symm
    |>.commRingCatIsoToRingEquiv
    |>.trans ((Scheme.ΓSpecIso
      (.of (ProjectiveSpace.StandardChartRing (r + 1) Omega 0)))
      |>.commRingCatIsoToRingEquiv)
    |>.trans (ProjectiveSpace.standardChartRingEquivMvPolynomial
      (r + 1) Omega 0).toRingEquiv

def projectiveGeneralBaseToFunctionField
    (r : ℕ) (Omega : Type u) [Field Omega] :
    Omega →+* (ProjectiveSpace (r + 1) Omega).functionField :=
  ((ProjectiveSpace (r + 1) Omega).germToFunctionField
      (projectiveGeneralChart r Omega)).hom.comp
    ((projectiveGeneralGammaEquivMvPolynomial r Omega).symm.toRingHom.comp
      (algebraMap Omega (MvPolynomial (Fin (r + 1)) Omega)))

private noncomputable local instance projectiveGeneralFunctionFieldAlgebra
    (r : ℕ) (Omega : Type u) [Field Omega] :
    Algebra Omega (ProjectiveSpace (r + 1) Omega).functionField :=
  (projectiveGeneralBaseToFunctionField r Omega).toAlgebra

noncomputable def projectiveGeneralFunctionFieldAlgEquiv
    (r : ℕ) (Omega : Type u) [Field Omega] :
    FractionRing (MvPolynomial (Fin (r + 1)) Omega) ≃ₐ[Omega]
      (ProjectiveSpace (r + 1) Omega).functionField := by
  let e := (projectiveGeneralGammaEquivMvPolynomial r Omega).symm
  let U := projectiveGeneralChart r Omega
  let X := ProjectiveSpace (r + 1) Omega
  letI polyAlgebra : Algebra (MvPolynomial (Fin (r + 1)) Omega)
      X.functionField :=
    ((X.germToFunctionField U).hom.comp e.toRingHom).toAlgebra
  letI : IsScalarTower Omega (MvPolynomial (Fin (r + 1)) Omega)
      X.functionField :=
    IsScalarTower.of_algebraMap_eq fun a ↦ rfl
  letI : IsFractionRing Γ(X, U) X.functionField :=
    functionField_isFractionRing_of_isAffineOpen X U
      (isAffineOpen_opensRange
        (ProjectiveSpace.standardChartι (r + 1) Omega 0))
  have hcompat (a : MvPolynomial (Fin (r + 1)) Omega) :
      algebraMap (MvPolynomial (Fin (r + 1)) Omega) X.functionField a =
        algebraMap Γ(X, U) X.functionField (e a) := by
    rfl
  letI : IsFractionRing (MvPolynomial (Fin (r + 1)) Omega)
      X.functionField :=
    IsFractionRing.of_ringEquiv_left e hcompat
  exact (FractionRing.algEquiv (MvPolynomial (Fin (r + 1)) Omega)
    X.functionField).restrictScalars Omega

noncomputable def projectiveGeneralFunctionFieldEquiv
    (r : ℕ) (Omega : Type u) [Field Omega] :
    FractionRing (MvPolynomial (Fin (r + 1)) Omega) ≃+*
      (ProjectiveSpace (r + 1) Omega).functionField :=
  (projectiveGeneralFunctionFieldAlgEquiv r Omega).toRingEquiv

theorem projectiveGeneralFunctionFieldEquiv_base
    (r : ℕ) (Omega : Type u) [Field Omega] (a : Omega) :
    projectiveGeneralFunctionFieldEquiv r Omega
        (algebraMap Omega
          (FractionRing (MvPolynomial (Fin (r + 1)) Omega)) a) =
      projectiveGeneralBaseToFunctionField r Omega a := by
  exact (projectiveGeneralFunctionFieldAlgEquiv r Omega).commutes a

theorem projectiveGeneralBaseToFunctionField_eq
    (r : ℕ) (Omega : Type u) [Field Omega] :
    projectiveGeneralBaseToFunctionField r Omega =
      functionFieldBaseRingHom Omega (ProjectiveSpace (r + 1) Omega)
        (ProjectiveSpace.toSpec (r + 1) Omega) := by
  ext a
  let X := ProjectiveSpace (r + 1) Omega
  let f := ProjectiveSpace.standardChartι (r + 1) Omega 0
  let U := projectiveGeneralChart r Omega
  let e := ProjectiveSpace.standardChartRingEquivMvPolynomial
    (r + 1) Omega 0
  have hsection :
      (projectiveGeneralGammaEquivMvPolynomial r Omega).symm
          (MvPolynomial.C a) =
        X.presheaf.map (homOfLE (show U ≤ (⊤ : X.Opens) from le_top)).op
          ((ProjectiveSpace.toSpec (r + 1) Omega).appTop
            ((Scheme.ΓSpecIso (.of Omega)).inv a)) := by
    apply (projectiveGeneralGammaEquivMvPolynomial r Omega).injective
    rw [(projectiveGeneralGammaEquivMvPolynomial r Omega).apply_symm_apply]
    change MvPolynomial.C a = e
      ((Scheme.ΓSpecIso
        (.of (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).hom
        ((IsOpenImmersion.ΓIsoTop f).inv
          (X.presheaf.map (homOfLE (show U ≤ (⊤ : X.Opens) from le_top)).op
            ((ProjectiveSpace.toSpec (r + 1) Omega).appTop
              ((Scheme.ΓSpecIso (.of Omega)).inv a)))))
    rw [← CommRingCat.comp_apply, ← CommRingCat.comp_apply,
      ← Category.assoc, general_restrict_comp_GammaIsoTop_inv]
    have hcomp := congrArg Scheme.Hom.appTop
      (ProjectiveSpace.standardChartι_toSpec (r + 1) Omega 0)
    rw [Scheme.Hom.comp_appTop] at hcomp
    have hbase : f.appTop
        ((ProjectiveSpace.toSpec (r + 1) Omega).appTop
          ((Scheme.ΓSpecIso (.of Omega)).inv a)) =
      (Scheme.ΓSpecIso
        (.of (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).inv
          (algebraMap Omega
            (ProjectiveSpace.StandardChartRing (r + 1) Omega 0) a) := by
      dsimp [f]
      rw [← CommRingCat.comp_apply, hcomp]
      have hnat := Scheme.ΓSpecIso_inv_naturality
        (CommRingCat.ofHom
          (algebraMap Omega
            (ProjectiveSpace.StandardChartRing (r + 1) Omega 0)))
      exact congrArg (fun q : CommRingCat.of Omega ⟶
        Γ(Spec (.of (ProjectiveSpace.StandardChartRing
          (r + 1) Omega 0)), ⊤) ↦ q.hom a) hnat.symm
    change MvPolynomial.C a = e
      ((Scheme.ΓSpecIso
        (.of (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).hom
        (f.appTop ((ProjectiveSpace.toSpec (r + 1) Omega).appTop
          ((Scheme.ΓSpecIso (.of Omega)).inv a))))
    rw [hbase, Iso.inv_hom_id_apply]
    exact (e.commutes a).symm
  change (CommRingCat.Hom.hom (X.germToFunctionField U))
      ((projectiveGeneralGammaEquivMvPolynomial r Omega).symm
        (MvPolynomial.C a)) =
    (CommRingCat.Hom.hom (X.presheaf.germ ⊤ (genericPoint X) trivial))
      ((ProjectiveSpace.toSpec (r + 1) Omega).appTop
        ((Scheme.ΓSpecIso (.of Omega)).inv a))
  rw [hsection]
  exact X.presheaf.germ_res_apply
    (homOfLE (show U ≤ (⊤ : X.Opens) from le_top))
    (genericPoint X)
    (((genericPoint_spec X).mem_open_set_iff U.isOpen).mpr
      (by simpa using (inferInstance : Nonempty U))) _

private abbrev biprojectiveGeneralChart
    (p q : ℕ) (Omega : Type u) [Field Omega] :
    (BiprojectiveSpace p q Omega).Opens :=
  (BiprojectiveSpace.standardChartι p q Omega 0 0).opensRange

private instance biprojectiveGeneralChart_nonempty
    (p q : ℕ) (Omega : Type u) [Field Omega] :
    Nonempty (biprojectiveGeneralChart p q Omega) := by
  let f := BiprojectiveSpace.standardChartι p q Omega 0 0
  let e := BiprojectiveSpace.standardChartIsoSpec p q Omega 0 0
  letI : IsDomain (BiprojectiveSpace.StandardChartRing p q Omega 0 0) :=
    (BiprojectiveSpace.standardChartRingEquivMvPolynomial p q Omega 0 0)
      |>.toRingEquiv.toMulEquiv.isDomain _
  have hs : Nonempty
      (Spec (.of (BiprojectiveSpace.StandardChartRing p q Omega 0 0))) := by
    infer_instance
  let x := e.inv (Classical.choice hs)
  exact ⟨⟨f x, ⟨x, rfl⟩⟩⟩

noncomputable def biprojectiveGeneralGammaEquivMvPolynomial
    (p q : ℕ) (Omega : Type u) [Field Omega] :
    Γ(BiprojectiveSpace p q Omega, biprojectiveGeneralChart p q Omega) ≃+*
      MvPolynomial (Fin (p + q)) Omega :=
  (IsOpenImmersion.ΓIsoTop
      (BiprojectiveSpace.standardChartι p q Omega 0 0)).symm
    |>.commRingCatIsoToRingEquiv
    |>.trans ((BiprojectiveSpace.standardChartΓIso p q Omega 0 0)
      |>.commRingCatIsoToRingEquiv)
    |>.trans (BiprojectiveSpace.standardChartRingEquivMvPolynomial
      p q Omega 0 0).toRingEquiv
    |>.trans (MvPolynomial.renameEquiv Omega
      (@finSumFinEquiv p q)).toRingEquiv

def biprojectiveGeneralBaseToFunctionField
    (p q : ℕ) (Omega : Type u) [Field Omega] :
    Omega →+* (BiprojectiveSpace p q Omega).functionField :=
  ((BiprojectiveSpace p q Omega).germToFunctionField
      (biprojectiveGeneralChart p q Omega)).hom.comp
    ((biprojectiveGeneralGammaEquivMvPolynomial p q Omega).symm.toRingHom.comp
      (algebraMap Omega (MvPolynomial (Fin (p + q)) Omega)))

private noncomputable local instance biprojectiveGeneralFunctionFieldAlgebra
    (p q : ℕ) (Omega : Type u) [Field Omega] :
    Algebra Omega (BiprojectiveSpace p q Omega).functionField :=
  (biprojectiveGeneralBaseToFunctionField p q Omega).toAlgebra

noncomputable def biprojectiveGeneralFunctionFieldAlgEquiv
    (p q : ℕ) (Omega : Type u) [Field Omega] :
    LinearExceptionalFunctionField ((p + q) + 1) Omega ≃ₐ[Omega]
      (BiprojectiveSpace p q Omega).functionField := by
  let e := (biprojectiveGeneralGammaEquivMvPolynomial p q Omega).symm
  let U := biprojectiveGeneralChart p q Omega
  let E := BiprojectiveSpace p q Omega
  letI polyAlgebra : Algebra (MvPolynomial (Fin (p + q)) Omega)
      E.functionField :=
    ((E.germToFunctionField U).hom.comp e.toRingHom).toAlgebra
  letI : IsScalarTower Omega (MvPolynomial (Fin (p + q)) Omega)
      E.functionField :=
    IsScalarTower.of_algebraMap_eq fun a ↦ rfl
  letI : IsFractionRing Γ(E, U) E.functionField :=
    functionField_isFractionRing_of_isAffineOpen E U
      (isAffineOpen_opensRange
        (BiprojectiveSpace.standardChartι p q Omega 0 0))
  have hcompat (a : MvPolynomial (Fin (p + q)) Omega) :
      algebraMap (MvPolynomial (Fin (p + q)) Omega) E.functionField a =
        algebraMap Γ(E, U) E.functionField (e a) := by
    rfl
  letI : IsFractionRing (MvPolynomial (Fin (p + q)) Omega)
      E.functionField :=
    IsFractionRing.of_ringEquiv_left e hcompat
  exact (FractionRing.algEquiv (MvPolynomial (Fin (p + q)) Omega)
    E.functionField).restrictScalars Omega

noncomputable def biprojectiveGeneralFunctionFieldEquiv
    (p q : ℕ) (Omega : Type u) [Field Omega] :
    LinearExceptionalFunctionField ((p + q) + 1) Omega ≃+*
      (BiprojectiveSpace p q Omega).functionField :=
  (biprojectiveGeneralFunctionFieldAlgEquiv p q Omega).toRingEquiv

theorem biprojectiveGeneralFunctionFieldEquiv_base
    (p q : ℕ) (Omega : Type u) [Field Omega] (a : Omega) :
    biprojectiveGeneralFunctionFieldEquiv p q Omega
        (baseToResidualField ((p + q) + 1) Omega a) =
      biprojectiveGeneralBaseToFunctionField p q Omega a := by
  exact (biprojectiveGeneralFunctionFieldAlgEquiv p q Omega).commutes a

theorem biprojectiveGeneralBaseToFunctionField_eq
    (p q : ℕ) (Omega : Type u) [Field Omega] :
    biprojectiveGeneralBaseToFunctionField p q Omega =
      functionFieldBaseRingHom Omega (BiprojectiveSpace p q Omega)
        (BiprojectiveSpace.toSpec p q Omega) := by
  ext a
  let E := BiprojectiveSpace p q Omega
  let f := BiprojectiveSpace.standardChartι p q Omega 0 0
  let U := biprojectiveGeneralChart p q Omega
  let g := BiprojectiveSpace.standardChartΓIso p q Omega 0 0
  let e := BiprojectiveSpace.standardChartRingEquivMvPolynomial
    p q Omega 0 0
  let r := MvPolynomial.renameEquiv Omega (@finSumFinEquiv p q)
  have hsection :
      (biprojectiveGeneralGammaEquivMvPolynomial p q Omega).symm
          (MvPolynomial.C a) =
        E.presheaf.map (homOfLE (show U ≤ (⊤ : E.Opens) from le_top)).op
          ((BiprojectiveSpace.toSpec p q Omega).appTop
            ((Scheme.ΓSpecIso (.of Omega)).inv a)) := by
    apply (biprojectiveGeneralGammaEquivMvPolynomial p q Omega).injective
    rw [(biprojectiveGeneralGammaEquivMvPolynomial p q Omega).apply_symm_apply]
    change MvPolynomial.C a = r (e (g.hom
      ((IsOpenImmersion.ΓIsoTop f).inv
        (E.presheaf.map
          (homOfLE (show U ≤ (⊤ : E.Opens) from le_top)).op
          ((BiprojectiveSpace.toSpec p q Omega).appTop
            ((Scheme.ΓSpecIso (.of Omega)).inv a))))))
    rw [← CommRingCat.comp_apply, ← CommRingCat.comp_apply,
      ← Category.assoc, general_restrict_comp_GammaIsoTop_inv]
    have hcomp := congrArg Scheme.Hom.appTop
      (BiprojectiveSpace.standardChartIsoSpec_hom_toSpec
        p q Omega 0 0)
    simp only [Scheme.Hom.comp_appTop] at hcomp
    have hbase : g.hom
        (f.appTop
          ((BiprojectiveSpace.toSpec p q Omega).appTop
            ((Scheme.ΓSpecIso (.of Omega)).inv a))) =
      algebraMap Omega
        (BiprojectiveSpace.StandardChartRing p q Omega 0 0) a := by
      change g.hom ((CommRingCat.Hom.hom
        ((BiprojectiveSpace.toSpec p q Omega).appTop ≫ f.appTop))
          ((Scheme.ΓSpecIso (.of Omega)).inv a)) = _
      rw [← hcomp]
      dsimp [g]
      unfold BiprojectiveSpace.standardChartΓIso
      simp only [Iso.trans_hom, Iso.symm_hom, asIso_inv]
      rw [← Scheme.Γ_map_op, ← CommRingCat.comp_apply]
      have hcancel :
          Scheme.Γ.map
              (BiprojectiveSpace.standardChartIsoSpec
                p q Omega 0 0).hom.op ≫
              inv (Scheme.Γ.map
                (BiprojectiveSpace.standardChartIsoSpec
                  p q Omega 0 0).hom.op) ≫
              (Scheme.ΓSpecIso (.of
                (BiprojectiveSpace.StandardChartRing
                  p q Omega 0 0))).hom =
            (Scheme.ΓSpecIso (.of
              (BiprojectiveSpace.StandardChartRing
                p q Omega 0 0))).hom :=
        IsIso.hom_inv_id_assoc _ _
      have hcancel_apply := congrArg
        (fun q' : Γ(Spec (.of
            (BiprojectiveSpace.StandardChartRing p q Omega 0 0)), ⊤) ⟶
              CommRingCat.of
                (BiprojectiveSpace.StandardChartRing p q Omega 0 0) ↦
          q'.hom
            ((Spec.map (CommRingCat.ofHom (algebraMap Omega
              (BiprojectiveSpace.StandardChartRing p q Omega 0 0))))
                |>.appTop
                ((Scheme.ΓSpecIso (.of Omega)).inv a))) hcancel
      have hnat := Scheme.ΓSpecIso_inv_naturality
        (CommRingCat.ofHom (algebraMap Omega
          (BiprojectiveSpace.StandardChartRing p q Omega 0 0)))
      have hz := congrArg (fun q' : CommRingCat.of Omega ⟶
        Γ(Spec (.of
          (BiprojectiveSpace.StandardChartRing p q Omega 0 0)), ⊤) ↦
          q'.hom a) hnat.symm
      have hz' :
          ((Spec.map (CommRingCat.ofHom (algebraMap Omega
              (BiprojectiveSpace.StandardChartRing p q Omega 0 0)))).appTop
              ((Scheme.ΓSpecIso (.of Omega)).inv a)) =
            (Scheme.ΓSpecIso (.of
              (BiprojectiveSpace.StandardChartRing p q Omega 0 0))).inv
              (algebraMap Omega
                (BiprojectiveSpace.StandardChartRing p q Omega 0 0) a) := by
        rw [CommRingCat.comp_apply, CommRingCat.comp_apply] at hz
        exact hz
      have hzhom := congrArg
        (fun z : Γ(Spec (.of
            (BiprojectiveSpace.StandardChartRing p q Omega 0 0)), ⊤) ↦
          (Scheme.ΓSpecIso (.of
            (BiprojectiveSpace.StandardChartRing p q Omega 0 0))).hom z) hz'
      exact hcancel_apply.trans (hzhom.trans
        ((Scheme.ΓSpecIso (.of
          (BiprojectiveSpace.StandardChartRing p q Omega 0 0)))
            |>.inv_hom_id_apply _))
    rw [CommRingCat.comp_apply, hbase]
    change MvPolynomial.C a = r (e
      (algebraMap Omega
        (BiprojectiveSpace.StandardChartRing p q Omega 0 0) a))
    rw [e.commutes, r.commutes]
    rfl
  change (CommRingCat.Hom.hom (E.germToFunctionField U))
      ((biprojectiveGeneralGammaEquivMvPolynomial p q Omega).symm
        (MvPolynomial.C a)) =
    (CommRingCat.Hom.hom (E.presheaf.germ ⊤ (genericPoint E) trivial))
      ((BiprojectiveSpace.toSpec p q Omega).appTop
        ((Scheme.ΓSpecIso (.of Omega)).inv a))
  rw [hsection]
  exact E.presheaf.germ_res_apply
    (homOfLE (show U ≤ (⊤ : E.Opens) from le_top))
    (genericPoint E)
    (((genericPoint_spec E).mem_open_set_iff U.isOpen).mpr
      (by simpa using (inferInstance : Nonempty U))) _

theorem biprojectiveLinearNormal_special_toBase
    (p q : ℕ) (Omega : Type u) [Field Omega] :
    Spec.map (CommRingCat.ofHom
        (linearChartResidueHom ((p + q) + 1) Omega
          (BiprojectiveSpace p q Omega)
          (biprojectiveGeneralFunctionFieldEquiv p q Omega))) ≫
        linearNormalValuation_toBase ((p + q) + 1) Omega =
      (BiprojectiveSpace p q Omega).fromSpecStalk _ ≫
        BiprojectiveSpace.toSpec p q Omega := by
  have hfield :
      (biprojectiveGeneralFunctionFieldEquiv p q Omega).toRingHom.comp
          (baseToResidualField ((p + q) + 1) Omega) =
        functionFieldBaseRingHom Omega (BiprojectiveSpace p q Omega)
          (BiprojectiveSpace.toSpec p q Omega) := by
    ext a
    rw [RingHom.comp_apply]
    change biprojectiveGeneralFunctionFieldEquiv p q Omega
      (baseToResidualField ((p + q) + 1) Omega a) = _
    rw [biprojectiveGeneralFunctionFieldEquiv_base]
    exact DFunLike.congr_fun
      (biprojectiveGeneralBaseToFunctionField_eq p q Omega) a
  calc
    Spec.map (CommRingCat.ofHom
          (linearChartResidueHom ((p + q) + 1) Omega
            (BiprojectiveSpace p q Omega)
            (biprojectiveGeneralFunctionFieldEquiv p q Omega))) ≫
          linearNormalValuation_toBase ((p + q) + 1) Omega =
        (Spec.map (CommRingCat.ofHom
            (biprojectiveGeneralFunctionFieldEquiv p q Omega).toRingHom) ≫
          linearNormalValuation_special ((p + q) + 1) Omega) ≫
            linearNormalValuation_toBase ((p + q) + 1) Omega := by
      simp only [linearChartResidueHom, linearNormalValuation_special,
        ← Spec.map_comp]
      rfl
    _ = Spec.map (CommRingCat.ofHom
          (biprojectiveGeneralFunctionFieldEquiv p q Omega).toRingHom) ≫
        (linearNormalValuation_special ((p + q) + 1) Omega ≫
          linearNormalValuation_toBase ((p + q) + 1) Omega) := by simp
    _ = Spec.map (CommRingCat.ofHom
          (biprojectiveGeneralFunctionFieldEquiv p q Omega).toRingHom) ≫
        Spec.map (CommRingCat.ofHom
          (baseToResidualField ((p + q) + 1) Omega)) := by
      rw [linearNormalValuation_special_toBase]
    _ = Spec.map (CommRingCat.ofHom
          ((biprojectiveGeneralFunctionFieldEquiv p q Omega).toRingHom.comp
            (baseToResidualField ((p + q) + 1) Omega))) := by
      rw [← Spec.map_comp]
      rfl
    _ = Spec.map (CommRingCat.ofHom
          (functionFieldBaseRingHom Omega (BiprojectiveSpace p q Omega)
            (BiprojectiveSpace.toSpec p q Omega))) := by rw [hfield]
    _ = (BiprojectiveSpace p q Omega).fromSpecStalk _ ≫
        BiprojectiveSpace.toSpec p q Omega :=
      SpecMap_functionFieldBaseRingHom Omega (BiprojectiveSpace p q Omega)
        (BiprojectiveSpace.toSpec p q Omega)

end V14Formalization.SchemeGeometry
