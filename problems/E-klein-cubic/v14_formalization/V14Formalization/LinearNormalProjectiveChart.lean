/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.LinearNormalEquivariant
public import V14Formalization.BiprojectiveIntegral
public import V14Formalization.EllipticPolynomialConstancy
public import BConicBundleMultisections.BiprojectiveZeroLocus
public import BConicBundleMultisections.BiprojectiveAffineZeroLocus
public import BConicBundleMultisections.ProjectiveSpaceChartDominance
public import Mathlib.RingTheory.Localization.LocalizationLocalization
public import Mathlib.RingTheory.Localization.Algebra

/-!
# Explicit function-field charts for the normal divisor

This module identifies the explicit five-dimensional linear normal valuation
with the actual function fields of `P^5` and `P^2 × P^2`.  It imports the
projective and biprojective chart geometry from Problem B and proves both
base squares required by the equivariant specialization constructor.
-/

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

universe u

attribute [local instance] MvPolynomial.gradedAlgebra

/-! ## Canonical base map into a scheme function field -/

@[expose] public def functionFieldBaseRingHom
    (Omega : Type u) [Field Omega]
    (X : Scheme.{u}) [IsIntegral X]
    (f : X ⟶ Spec (.of Omega)) : Omega →+* X.functionField :=
  (X.presheaf.germ (⊤ : X.Opens) (genericPoint X) trivial).hom.comp
    (f.appTop.hom.comp (Scheme.ΓSpecIso (.of Omega)).inv.hom)

public theorem SpecMap_functionFieldBaseRingHom
    (Omega : Type u) [Field Omega]
    (X : Scheme.{u}) [IsIntegral X]
    (f : X ⟶ Spec (.of Omega)) :
    Spec.map (CommRingCat.ofHom (functionFieldBaseRingHom Omega X f)) =
      X.fromSpecStalk (genericPoint X) ≫ f := by
  have hf : f = X.toSpecΓ ≫ Spec.map f.appTop ≫
      Spec.map (Scheme.ΓSpecIso (.of Omega)).inv := by
    calc
      f = f ≫ 𝟙 _ := by simp
      _ = f ≫ ((Spec (.of Omega)).toSpecΓ ≫
          Spec.map (Scheme.ΓSpecIso (.of Omega)).inv) := by
        rw [toSpecΓ_SpecMap_ΓSpecIso_inv]
      _ = (f ≫ (Spec (.of Omega)).toSpecΓ) ≫
          Spec.map (Scheme.ΓSpecIso (.of Omega)).inv := by simp
      _ = (X.toSpecΓ ≫ Spec.map f.appTop) ≫
          Spec.map (Scheme.ΓSpecIso (.of Omega)).inv := by
        rw [Scheme.toSpecΓ_naturality]
  calc
    Spec.map (CommRingCat.ofHom (functionFieldBaseRingHom Omega X f)) =
        (Spec.map (X.presheaf.germ (⊤ : X.Opens) (genericPoint X) trivial) ≫
          Spec.map f.appTop) ≫
            Spec.map (Scheme.ΓSpecIso (.of Omega)).inv := by
      simp only [functionFieldBaseRingHom, ← Spec.map_comp]
      rfl
    _ = (X.fromSpecStalk (genericPoint X) ≫ X.toSpecΓ ≫
          Spec.map f.appTop) ≫
            Spec.map (Scheme.ΓSpecIso (.of Omega)).inv := by
      rw [← Scheme.fromSpecStalk_toSpecΓ]
      simp only [Category.assoc]
    _ = X.fromSpecStalk (genericPoint X) ≫
        (X.toSpecΓ ≫ Spec.map f.appTop ≫
          Spec.map (Scheme.ΓSpecIso (.of Omega)).inv) := by simp
    _ = X.fromSpecStalk (genericPoint X) ≫ f := by rw [← hf]

private theorem restrict_comp_ΓIsoTop_inv
    {X Y : Scheme.{u}} (f : X ⟶ Y) [IsOpenImmersion f] :
    Y.presheaf.map (homOfLE (show f.opensRange ≤ (⊤ : Y.Opens) from le_top)).op ≫
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

/-! ## The explicit five-dimensional ambient rational field -/

public abbrev ResidualPoly (Omega : Type u) [Field Omega] :=
  MvPolynomial (Fin 4) Omega

public abbrev ResidualFrac (Omega : Type u) [Field Omega] :=
  FractionRing (ResidualPoly Omega)

public abbrev AmbientPolyTower (Omega : Type u) [Field Omega] :=
  Polynomial (ResidualPoly Omega)

public abbrev AmbientPolyLocalized (Omega : Type u) [Field Omega] :=
  Polynomial (ResidualFrac Omega)

public abbrev AmbientFrac (Omega : Type u) [Field Omega] :=
  FractionRing (AmbientPolyTower Omega)

private abbrev ambientCoeffSubmonoid (Omega : Type u) [Field Omega] :
    Submonoid (AmbientPolyTower Omega) :=
  (nonZeroDivisors (ResidualPoly Omega)).map
    (Polynomial.C : ResidualPoly Omega →+* AmbientPolyTower Omega).toMonoidHom

private local instance (Omega : Type u) [Field Omega] :
    Algebra (AmbientPolyTower Omega) (AmbientPolyLocalized Omega) :=
  Polynomial.algebra (ResidualPoly Omega) (ResidualFrac Omega)

private local instance ambientPolyLocalization (Omega : Type u) [Field Omega] :
    IsLocalization (ambientCoeffSubmonoid Omega) (AmbientPolyLocalized Omega) :=
  Polynomial.isLocalization (nonZeroDivisors (ResidualPoly Omega))
    (ResidualFrac Omega)

private theorem ambientCoeffSubmonoid_le_nonZeroDivisors
    (Omega : Type u) [Field Omega] :
    ambientCoeffSubmonoid Omega ≤ nonZeroDivisors (AmbientPolyTower Omega) := by
  intro y hy
  rw [mem_nonZeroDivisors_iff_ne_zero]
  intro hy0
  rw [Submonoid.mem_map] at hy
  obtain ⟨a, ha, hay⟩ := hy
  have hCa : Polynomial.C a = 0 := hay.trans hy0
  have ha0 : a = 0 := Polynomial.C_injective (by simpa using hCa)
  exact (nonZeroDivisors.ne_zero ha) ha0

private noncomputable def ambientPolyLocalizedToFrac
    (Omega : Type u) [Field Omega] :
    AmbientPolyLocalized Omega →+* AmbientFrac Omega :=
  IsLocalization.lift (M := ambientCoeffSubmonoid Omega)
    (S := AmbientPolyLocalized Omega)
    (g := algebraMap (AmbientPolyTower Omega) (AmbientFrac Omega))
    (fun y ↦ IsLocalization.map_units (AmbientFrac Omega)
      ⟨y.1, ambientCoeffSubmonoid_le_nonZeroDivisors Omega y.2⟩)

private local instance (Omega : Type u) [Field Omega] :
    Algebra (AmbientPolyLocalized Omega) (AmbientFrac Omega) :=
  (ambientPolyLocalizedToFrac Omega).toAlgebra

private local instance (Omega : Type u) [Field Omega] :
    IsScalarTower (AmbientPolyTower Omega) (AmbientPolyLocalized Omega)
      (AmbientFrac Omega) :=
  IsScalarTower.of_algebraMap_eq (fun x ↦ by
    change algebraMap (AmbientPolyTower Omega) (AmbientFrac Omega) x =
      ambientPolyLocalizedToFrac Omega
        (algebraMap (AmbientPolyTower Omega) (AmbientPolyLocalized Omega) x)
    exact (IsLocalization.lift_eq (M := ambientCoeffSubmonoid Omega)
      (S := AmbientPolyLocalized Omega) (P := AmbientFrac Omega)
      (fun y ↦ IsLocalization.map_units (AmbientFrac Omega)
        ⟨y.1, ambientCoeffSubmonoid_le_nonZeroDivisors Omega y.2⟩) x).symm)

private local instance (Omega : Type u) [Field Omega] :
    IsScalarTower Omega (AmbientPolyLocalized Omega) (AmbientFrac Omega) := by
  apply IsScalarTower.of_algebraMap_eq
  intro a
  change algebraMap Omega (AmbientFrac Omega) a =
    ambientPolyLocalizedToFrac Omega
      (algebraMap Omega (AmbientPolyLocalized Omega) a)
  rw [show algebraMap Omega (AmbientPolyLocalized Omega) a =
      algebraMap (AmbientPolyTower Omega) (AmbientPolyLocalized Omega)
        (algebraMap Omega (AmbientPolyTower Omega) a) by
    exact IsScalarTower.algebraMap_apply Omega (AmbientPolyTower Omega)
      (AmbientPolyLocalized Omega) a]
  calc
    algebraMap Omega (AmbientFrac Omega) a =
        algebraMap (AmbientPolyTower Omega) (AmbientFrac Omega)
          (algebraMap Omega (AmbientPolyTower Omega) a) :=
      IsScalarTower.algebraMap_apply Omega (AmbientPolyTower Omega)
        (AmbientFrac Omega) a
    _ = ambientPolyLocalizedToFrac Omega
        (algebraMap (AmbientPolyTower Omega) (AmbientPolyLocalized Omega)
          (algebraMap Omega (AmbientPolyTower Omega) a)) :=
      (IsLocalization.lift_eq (M := ambientCoeffSubmonoid Omega)
        (S := AmbientPolyLocalized Omega) (P := AmbientFrac Omega)
        (fun y ↦ IsLocalization.map_units (AmbientFrac Omega)
          ⟨y.1, ambientCoeffSubmonoid_le_nonZeroDivisors Omega y.2⟩)
        (algebraMap Omega (AmbientPolyTower Omega) a)).symm

private local instance ambientPolyLocalizedFraction
    (Omega : Type u) [Field Omega] :
    IsFractionRing (AmbientPolyLocalized Omega) (AmbientFrac Omega) :=
  IsFractionRing.isFractionRing_of_isDomain_of_isLocalization
    (ambientCoeffSubmonoid Omega) (AmbientPolyLocalized Omega) (AmbientFrac Omega)

/-- `Omega(x₁,…,x₄)(T)` is the fraction field of a polynomial ring in five variables. -/
public noncomputable def linearNormalFractionAlgEquivMvPolynomialFive
    (Omega : Type u) [Field Omega] :
    LinearNormalFractionField 5 Omega ≃ₐ[Omega]
      FractionRing (MvPolynomial (Fin 5) Omega) :=
  ((RatFunc.toFractionRingAlgEquiv (ResidualFrac Omega) Omega).trans
      ((FractionRing.algEquiv (AmbientPolyLocalized Omega)
        (AmbientFrac Omega)).restrictScalars Omega)).trans
    (IsFractionRing.algEquivOfAlgEquiv
      (MvPolynomial.finSuccEquiv Omega 4)).symm

@[expose] public noncomputable def linearNormalFractionEquivMvPolynomialFive
    (Omega : Type u) [Field Omega] :
    LinearNormalFractionField 5 Omega ≃+*
      FractionRing (MvPolynomial (Fin 5) Omega) :=
  (linearNormalFractionAlgEquivMvPolynomialFive Omega).toRingEquiv

/-! ## Standard-chart function fields -/

public abbrev projectiveFiveChart
    (Omega : Type u) [Field Omega] :
    (ProjectiveSpace 5 Omega).Opens :=
  (ProjectiveSpace.standardChartι 5 Omega 0).opensRange

private instance projectiveFiveChart_nonempty
    (Omega : Type u) [Field Omega] :
    Nonempty (projectiveFiveChart Omega) := by
  refine ⟨⟨ProjectiveSpace.genericPoint 5 Omega,
    ?_⟩⟩
  simpa [projectiveFiveChart,
    ProjectiveSpace.opensRange_standardChartι] using
      ProjectiveSpace.genericPoint_mem_standardChart 5 Omega 0

@[expose] public noncomputable def projectiveFiveGammaEquivMvPolynomial
    (Omega : Type u) [Field Omega] :
    Γ(ProjectiveSpace 5 Omega, projectiveFiveChart Omega) ≃+*
      MvPolynomial (Fin 5) Omega :=
  (IsOpenImmersion.ΓIsoTop
      (ProjectiveSpace.standardChartι 5 Omega 0)).symm
    |>.commRingCatIsoToRingEquiv
    |>.trans ((Scheme.ΓSpecIso
      (.of (ProjectiveSpace.StandardChartRing 5 Omega 0)))
      |>.commRingCatIsoToRingEquiv)
    |>.trans (ProjectiveSpace.standardChartRingEquivMvPolynomial
      5 Omega 0).toRingEquiv

public def projectiveFiveBaseToFunctionField
    (Omega : Type u) [Field Omega] :
    Omega →+* (ProjectiveSpace 5 Omega).functionField :=
  ((ProjectiveSpace 5 Omega).germToFunctionField
      (projectiveFiveChart Omega)).hom.comp
    ((projectiveFiveGammaEquivMvPolynomial Omega).symm.toRingHom.comp
      (algebraMap Omega (MvPolynomial (Fin 5) Omega)))

public noncomputable local instance projectiveFiveFunctionFieldAlgebra
    (Omega : Type u) [Field Omega] :
    Algebra Omega (ProjectiveSpace 5 Omega).functionField :=
  (projectiveFiveBaseToFunctionField Omega).toAlgebra

/-- The actual function field of `P⁵` in its zero-th standard chart. -/
public noncomputable def projectiveFiveFunctionFieldAlgEquiv
    (Omega : Type u) [Field Omega] :
    FractionRing (MvPolynomial (Fin 5) Omega) ≃ₐ[Omega]
      (ProjectiveSpace 5 Omega).functionField := by
  let e := (projectiveFiveGammaEquivMvPolynomial Omega).symm
  let U := projectiveFiveChart Omega
  let X := ProjectiveSpace 5 Omega
  letI polyAlgebra : Algebra (MvPolynomial (Fin 5) Omega) X.functionField :=
    ((X.germToFunctionField U).hom.comp e.toRingHom).toAlgebra
  letI : IsScalarTower Omega (MvPolynomial (Fin 5) Omega) X.functionField :=
    IsScalarTower.of_algebraMap_eq fun a ↦ rfl
  letI : IsFractionRing Γ(X, U) X.functionField :=
    functionField_isFractionRing_of_isAffineOpen X U
      (isAffineOpen_opensRange (ProjectiveSpace.standardChartι 5 Omega 0))
  have hcompat (a : MvPolynomial (Fin 5) Omega) :
      algebraMap (MvPolynomial (Fin 5) Omega) X.functionField a =
        algebraMap Γ(X, U) X.functionField (e a) := by
    rfl
  letI : IsFractionRing (MvPolynomial (Fin 5) Omega) X.functionField :=
    IsFractionRing.of_ringEquiv_left e hcompat
  exact (FractionRing.algEquiv (MvPolynomial (Fin 5) Omega)
    X.functionField).restrictScalars Omega

@[expose] public noncomputable def projectiveFiveFunctionFieldEquiv
    (Omega : Type u) [Field Omega] :
    FractionRing (MvPolynomial (Fin 5) Omega) ≃+*
      (ProjectiveSpace 5 Omega).functionField :=
  (projectiveFiveFunctionFieldAlgEquiv Omega).toRingEquiv

/-- Actual ambient function-field identification used by the linear-normal package. -/
@[expose] public noncomputable def projectiveFiveLinearNormalFunctionFieldEquiv
    (Omega : Type u) [Field Omega] :
    LinearNormalFractionField 5 Omega ≃+*
      (ProjectiveSpace 5 Omega).functionField :=
  (linearNormalFractionEquivMvPolynomialFive Omega).trans
    (projectiveFiveFunctionFieldEquiv Omega)

theorem projectiveFiveFunctionFieldEquiv_base
    (Omega : Type u) [Field Omega] (a : Omega) :
    projectiveFiveFunctionFieldEquiv Omega
        (algebraMap Omega (FractionRing (MvPolynomial (Fin 5) Omega)) a) =
      projectiveFiveBaseToFunctionField Omega a := by
  exact (projectiveFiveFunctionFieldAlgEquiv Omega).commutes a

public theorem projectiveFiveBaseToFunctionField_eq
    (Omega : Type u) [Field Omega] :
    projectiveFiveBaseToFunctionField Omega =
      functionFieldBaseRingHom Omega (ProjectiveSpace 5 Omega)
        (ProjectiveSpace.toSpec 5 Omega) := by
  ext a
  let X := ProjectiveSpace 5 Omega
  let f := ProjectiveSpace.standardChartι 5 Omega 0
  let U := projectiveFiveChart Omega
  let e := ProjectiveSpace.standardChartRingEquivMvPolynomial 5 Omega 0
  have hsection :
      (projectiveFiveGammaEquivMvPolynomial Omega).symm (MvPolynomial.C a) =
        X.presheaf.map (homOfLE (show U ≤ (⊤ : X.Opens) from le_top)).op
          ((ProjectiveSpace.toSpec 5 Omega).appTop
            ((Scheme.ΓSpecIso (.of Omega)).inv a)) := by
    apply (projectiveFiveGammaEquivMvPolynomial Omega).injective
    rw [(projectiveFiveGammaEquivMvPolynomial Omega).apply_symm_apply]
    change MvPolynomial.C a = e
      ((Scheme.ΓSpecIso
        (.of (ProjectiveSpace.StandardChartRing 5 Omega 0))).hom
        ((IsOpenImmersion.ΓIsoTop f).inv
          (X.presheaf.map (homOfLE (show U ≤ (⊤ : X.Opens) from le_top)).op
            ((ProjectiveSpace.toSpec 5 Omega).appTop
              ((Scheme.ΓSpecIso (.of Omega)).inv a)))))
    rw [← CommRingCat.comp_apply, ← CommRingCat.comp_apply,
      ← Category.assoc, restrict_comp_ΓIsoTop_inv]
    have hcomp := congrArg Scheme.Hom.appTop
      (ProjectiveSpace.standardChartι_toSpec 5 Omega 0)
    rw [Scheme.Hom.comp_appTop] at hcomp
    have hbase : f.appTop
        ((ProjectiveSpace.toSpec 5 Omega).appTop
          ((Scheme.ΓSpecIso (.of Omega)).inv a)) =
      (Scheme.ΓSpecIso
        (.of (ProjectiveSpace.StandardChartRing 5 Omega 0))).inv
          (algebraMap Omega
            (ProjectiveSpace.StandardChartRing 5 Omega 0) a) := by
      dsimp [f]
      rw [← CommRingCat.comp_apply, hcomp]
      have hnat := Scheme.ΓSpecIso_inv_naturality
        (CommRingCat.ofHom
          (algebraMap Omega
            (ProjectiveSpace.StandardChartRing 5 Omega 0)))
      exact congrArg (fun q : CommRingCat.of Omega ⟶
        Γ(Spec (.of (ProjectiveSpace.StandardChartRing 5 Omega 0)), ⊤) ↦
          q.hom a) hnat.symm
    change MvPolynomial.C a = e
      ((Scheme.ΓSpecIso
        (.of (ProjectiveSpace.StandardChartRing 5 Omega 0))).hom
        (f.appTop ((ProjectiveSpace.toSpec 5 Omega).appTop
          ((Scheme.ΓSpecIso (.of Omega)).inv a))))
    rw [hbase, Iso.inv_hom_id_apply]
    exact (e.commutes a).symm
  change (CommRingCat.Hom.hom (X.germToFunctionField U))
      ((projectiveFiveGammaEquivMvPolynomial Omega).symm (MvPolynomial.C a)) =
    (CommRingCat.Hom.hom (X.presheaf.germ ⊤ (genericPoint X) trivial))
      ((ProjectiveSpace.toSpec 5 Omega).appTop
        ((Scheme.ΓSpecIso (.of Omega)).inv a))
  rw [hsection]
  exact X.presheaf.germ_res_apply
    (homOfLE (show U ≤ (⊤ : X.Opens) from le_top))
    (genericPoint X)
    (((genericPoint_spec X).mem_open_set_iff U.isOpen).mpr
      (by simpa using (inferInstance : Nonempty U)))
    _

theorem linearNormalFractionEquivMvPolynomialFive_base
    (Omega : Type u) [Field Omega] (a : Omega) :
    linearNormalFractionEquivMvPolynomialFive Omega
        (baseToLinearNormalFractionField 5 Omega a) =
      algebraMap Omega (FractionRing (MvPolynomial (Fin 5) Omega)) a := by
  exact (linearNormalFractionAlgEquivMvPolynomialFive Omega).commutes a

public abbrev biprojectiveTwoTwoChart
    (Omega : Type u) [Field Omega] :
    (BiprojectiveSpace 2 2 Omega).Opens :=
  (BiprojectiveSpace.standardChartι 2 2 Omega 0 0).opensRange

private instance biprojectiveTwoTwoChart_nonempty
    (Omega : Type u) [Field Omega] :
    Nonempty (biprojectiveTwoTwoChart Omega) := by
  let f := BiprojectiveSpace.standardChartι 2 2 Omega 0 0
  let e := BiprojectiveSpace.standardChartIsoSpec 2 2 Omega 0 0
  letI : IsDomain (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0) :=
    (BiprojectiveSpace.standardChartRingEquivMvPolynomial 2 2 Omega 0 0)
      |>.toRingEquiv.toMulEquiv.isDomain _
  have hs : Nonempty
      (Spec (.of (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0))) := by
    infer_instance
  let x := e.inv (Classical.choice hs)
  exact ⟨⟨f x, ⟨x, rfl⟩⟩⟩

@[expose] public noncomputable def biprojectiveTwoTwoGammaEquivMvPolynomial
    (Omega : Type u) [Field Omega] :
    Γ(BiprojectiveSpace 2 2 Omega, biprojectiveTwoTwoChart Omega) ≃+*
      MvPolynomial (Fin 4) Omega :=
  (IsOpenImmersion.ΓIsoTop
      (BiprojectiveSpace.standardChartι 2 2 Omega 0 0)).symm
    |>.commRingCatIsoToRingEquiv
    |>.trans ((BiprojectiveSpace.standardChartΓIso 2 2 Omega 0 0)
      |>.commRingCatIsoToRingEquiv)
    |>.trans (BiprojectiveSpace.standardChartRingEquivMvPolynomial
      2 2 Omega 0 0).toRingEquiv
    |>.trans (MvPolynomial.renameEquiv Omega
      (@finSumFinEquiv 2 2)).toRingEquiv

public def biprojectiveTwoTwoBaseToFunctionField
    (Omega : Type u) [Field Omega] :
    Omega →+* (BiprojectiveSpace 2 2 Omega).functionField :=
  ((BiprojectiveSpace 2 2 Omega).germToFunctionField
      (biprojectiveTwoTwoChart Omega)).hom.comp
    ((biprojectiveTwoTwoGammaEquivMvPolynomial Omega).symm.toRingHom.comp
      (algebraMap Omega (MvPolynomial (Fin 4) Omega)))

public noncomputable local instance biprojectiveTwoTwoFunctionFieldAlgebra
    (Omega : Type u) [Field Omega] :
    Algebra Omega (BiprojectiveSpace 2 2 Omega).functionField :=
  (biprojectiveTwoTwoBaseToFunctionField Omega).toAlgebra

/-- The actual function field of `P² × P²` in its `(0,0)` standard chart. -/
public noncomputable def biprojectiveTwoTwoFunctionFieldAlgEquiv
    (Omega : Type u) [Field Omega] :
    LinearExceptionalFunctionField 5 Omega ≃ₐ[Omega]
      (BiprojectiveSpace 2 2 Omega).functionField := by
  let e := (biprojectiveTwoTwoGammaEquivMvPolynomial Omega).symm
  let U := biprojectiveTwoTwoChart Omega
  let E := BiprojectiveSpace 2 2 Omega
  letI polyAlgebra : Algebra (MvPolynomial (Fin 4) Omega) E.functionField :=
    ((E.germToFunctionField U).hom.comp e.toRingHom).toAlgebra
  letI : IsScalarTower Omega (MvPolynomial (Fin 4) Omega) E.functionField :=
    IsScalarTower.of_algebraMap_eq fun a ↦ rfl
  letI : IsFractionRing Γ(E, U) E.functionField :=
    functionField_isFractionRing_of_isAffineOpen E U
      (isAffineOpen_opensRange
        (BiprojectiveSpace.standardChartι 2 2 Omega 0 0))
  have hcompat (a : MvPolynomial (Fin 4) Omega) :
      algebraMap (MvPolynomial (Fin 4) Omega) E.functionField a =
        algebraMap Γ(E, U) E.functionField (e a) := by
    rfl
  letI : IsFractionRing (MvPolynomial (Fin 4) Omega) E.functionField :=
    IsFractionRing.of_ringEquiv_left e hcompat
  exact (FractionRing.algEquiv (MvPolynomial (Fin 4) Omega)
    E.functionField).restrictScalars Omega

@[expose] public noncomputable def biprojectiveTwoTwoFunctionFieldEquiv
    (Omega : Type u) [Field Omega] :
    LinearExceptionalFunctionField 5 Omega ≃+*
      (BiprojectiveSpace 2 2 Omega).functionField :=
  (biprojectiveTwoTwoFunctionFieldAlgEquiv Omega).toRingEquiv

/-- Every point of a short-Weierstrass elliptic curve over the actual
function field of `P² × P²` descends to the algebraically closed base
field.  The function-field identification is the explicit standard-chart
equivalence constructed above. -/
public theorem shortWeierstrassPoint_baseChange_biprojectiveTwoTwo_surjective
    (Omega : Type u) [Field Omega] [IsAlgClosed Omega] [CharZero Omega]
    [DecidableEq Omega]
    [DecidableEq (BiprojectiveSpace 2 2 Omega).functionField]
    (W : WeierstrassCurve Omega) [W.IsShortNF] [W.IsElliptic] :
    Function.Surjective
      (WeierstrassCurve.Affine.Point.baseChange
        (W' := W.toAffine) Omega
        (BiprojectiveSpace 2 2 Omega).functionField) := by
  exact
    EllipticPolynomialConstancy.short_weierstrass_point_baseChange_of_fin4_algEquiv_surjective
      (biprojectiveTwoTwoFunctionFieldAlgEquiv Omega) W

theorem biprojectiveTwoTwoFunctionFieldEquiv_base
    (Omega : Type u) [Field Omega] (a : Omega) :
    biprojectiveTwoTwoFunctionFieldEquiv Omega
        (baseToResidualField 5 Omega a) =
      biprojectiveTwoTwoBaseToFunctionField Omega a := by
  exact (biprojectiveTwoTwoFunctionFieldAlgEquiv Omega).commutes a

theorem biprojectiveTwoTwoBaseToFunctionField_eq
    (Omega : Type u) [Field Omega] :
    biprojectiveTwoTwoBaseToFunctionField Omega =
      functionFieldBaseRingHom Omega (BiprojectiveSpace 2 2 Omega)
        (BiprojectiveSpace.toSpec 2 2 Omega) := by
  ext a
  let E := BiprojectiveSpace 2 2 Omega
  let f := BiprojectiveSpace.standardChartι 2 2 Omega 0 0
  let U := biprojectiveTwoTwoChart Omega
  let g := BiprojectiveSpace.standardChartΓIso 2 2 Omega 0 0
  let e := BiprojectiveSpace.standardChartRingEquivMvPolynomial
    2 2 Omega 0 0
  let r := MvPolynomial.renameEquiv Omega (@finSumFinEquiv 2 2)
  have hsection :
      (biprojectiveTwoTwoGammaEquivMvPolynomial Omega).symm
          (MvPolynomial.C a) =
        E.presheaf.map (homOfLE (show U ≤ (⊤ : E.Opens) from le_top)).op
          ((BiprojectiveSpace.toSpec 2 2 Omega).appTop
            ((Scheme.ΓSpecIso (.of Omega)).inv a)) := by
    apply (biprojectiveTwoTwoGammaEquivMvPolynomial Omega).injective
    rw [(biprojectiveTwoTwoGammaEquivMvPolynomial Omega).apply_symm_apply]
    change MvPolynomial.C a = r (e (g.hom
      ((IsOpenImmersion.ΓIsoTop f).inv
        (E.presheaf.map
          (homOfLE (show U ≤ (⊤ : E.Opens) from le_top)).op
          ((BiprojectiveSpace.toSpec 2 2 Omega).appTop
            ((Scheme.ΓSpecIso (.of Omega)).inv a))))))
    rw [← CommRingCat.comp_apply, ← CommRingCat.comp_apply,
      ← Category.assoc, restrict_comp_ΓIsoTop_inv]
    have hcomp := congrArg Scheme.Hom.appTop
      (BiprojectiveSpace.standardChartIsoSpec_hom_toSpec
        2 2 Omega 0 0)
    simp only [Scheme.Hom.comp_appTop] at hcomp
    have hbase : g.hom
        (f.appTop
          ((BiprojectiveSpace.toSpec 2 2 Omega).appTop
            ((Scheme.ΓSpecIso (.of Omega)).inv a))) =
      algebraMap Omega
        (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0) a := by
      change g.hom ((CommRingCat.Hom.hom
        ((BiprojectiveSpace.toSpec 2 2 Omega).appTop ≫ f.appTop))
          ((Scheme.ΓSpecIso (.of Omega)).inv a)) = _
      rw [← hcomp]
      dsimp [g]
      unfold BiprojectiveSpace.standardChartΓIso
      simp only [Iso.trans_hom, Iso.symm_hom, asIso_inv]
      rw [← Scheme.Γ_map_op, ← CommRingCat.comp_apply]
      have hcancel :
          Scheme.Γ.map
              (BiprojectiveSpace.standardChartIsoSpec
                2 2 Omega 0 0).hom.op ≫
              inv (Scheme.Γ.map
                (BiprojectiveSpace.standardChartIsoSpec
                  2 2 Omega 0 0).hom.op) ≫
              (Scheme.ΓSpecIso (.of
                (BiprojectiveSpace.StandardChartRing
                  2 2 Omega 0 0))).hom =
            (Scheme.ΓSpecIso (.of
              (BiprojectiveSpace.StandardChartRing
                2 2 Omega 0 0))).hom :=
        IsIso.hom_inv_id_assoc _ _
      have hcancel_apply := congrArg
        (fun q : Γ(Spec (.of
            (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0)), ⊤) ⟶
              CommRingCat.of
                (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0) ↦
          q.hom
            ((Spec.map (CommRingCat.ofHom (algebraMap Omega
              (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0))))
                |>.appTop
                ((Scheme.ΓSpecIso (.of Omega)).inv a))) hcancel
      have hnat := Scheme.ΓSpecIso_inv_naturality
        (CommRingCat.ofHom (algebraMap Omega
          (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0)))
      have hz := congrArg (fun q : CommRingCat.of Omega ⟶
        Γ(Spec (.of
          (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0)), ⊤) ↦
          q.hom a) hnat.symm
      have hz' :
          ((Spec.map (CommRingCat.ofHom (algebraMap Omega
              (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0)))).appTop
              ((Scheme.ΓSpecIso (.of Omega)).inv a)) =
            (Scheme.ΓSpecIso (.of
              (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0))).inv
              (algebraMap Omega
                (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0) a) := by
        rw [CommRingCat.comp_apply, CommRingCat.comp_apply] at hz
        exact hz
      have hzhom := congrArg
        (fun z : Γ(Spec (.of
            (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0)), ⊤) ↦
          (Scheme.ΓSpecIso (.of
            (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0))).hom z) hz'
      exact hcancel_apply.trans (hzhom.trans
        ((Scheme.ΓSpecIso (.of
          (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0)))
            |>.inv_hom_id_apply _))
    rw [CommRingCat.comp_apply, hbase]
    change MvPolynomial.C a = r (e
      (algebraMap Omega
        (BiprojectiveSpace.StandardChartRing 2 2 Omega 0 0) a))
    rw [e.commutes, r.commutes]
    rfl
  change (CommRingCat.Hom.hom (E.germToFunctionField U))
      ((biprojectiveTwoTwoGammaEquivMvPolynomial Omega).symm
        (MvPolynomial.C a)) =
    (CommRingCat.Hom.hom (E.presheaf.germ ⊤ (genericPoint E) trivial))
      ((BiprojectiveSpace.toSpec 2 2 Omega).appTop
        ((Scheme.ΓSpecIso (.of Omega)).inv a))
  rw [hsection]
  exact E.presheaf.germ_res_apply
    (homOfLE (show U ≤ (⊤ : E.Opens) from le_top))
    (genericPoint E)
    (((genericPoint_spec E).mem_open_set_iff U.isOpen).mpr
      (by simpa using (inferInstance : Nonempty U)))
    _

/-! ## Actual base squares for the two geometric carriers -/

public theorem projectiveFiveLinearNormalFunctionFieldEquiv_base
    (Omega : Type u) [Field Omega] (a : Omega) :
    projectiveFiveLinearNormalFunctionFieldEquiv Omega
        (baseToLinearNormalFractionField 5 Omega a) =
      projectiveFiveBaseToFunctionField Omega a := by
  change projectiveFiveFunctionFieldEquiv Omega
      (linearNormalFractionEquivMvPolynomialFive Omega
        (baseToLinearNormalFractionField 5 Omega a)) = _
  rw [linearNormalFractionEquivMvPolynomialFive_base]
  exact projectiveFiveFunctionFieldEquiv_base Omega a

public theorem projectiveFiveLinearNormal_generic_toBase
    (Omega : Type u) [Field Omega] :
    Spec.map (CommRingCat.ofHom
        (linearChartGenericHom 5 Omega (ProjectiveSpace 5 Omega)
          (projectiveFiveLinearNormalFunctionFieldEquiv Omega))) ≫
        linearNormalValuation_toBase 5 Omega =
      (ProjectiveSpace 5 Omega).fromSpecStalk _ ≫
        ProjectiveSpace.toSpec 5 Omega := by
  have hfield :
      (projectiveFiveLinearNormalFunctionFieldEquiv Omega).toRingHom.comp
          (baseToLinearNormalFractionField 5 Omega) =
        functionFieldBaseRingHom Omega (ProjectiveSpace 5 Omega)
          (ProjectiveSpace.toSpec 5 Omega) := by
    ext a
    rw [RingHom.comp_apply]
    change projectiveFiveLinearNormalFunctionFieldEquiv Omega
      (baseToLinearNormalFractionField 5 Omega a) = _
    rw [projectiveFiveLinearNormalFunctionFieldEquiv_base]
    exact DFunLike.congr_fun
      (projectiveFiveBaseToFunctionField_eq Omega) a
  calc
    Spec.map (CommRingCat.ofHom
          (linearChartGenericHom 5 Omega (ProjectiveSpace 5 Omega)
            (projectiveFiveLinearNormalFunctionFieldEquiv Omega))) ≫
          linearNormalValuation_toBase 5 Omega =
        (Spec.map (CommRingCat.ofHom
            (projectiveFiveLinearNormalFunctionFieldEquiv Omega).toRingHom) ≫
          linearNormalValuation_generic 5 Omega) ≫
            linearNormalValuation_toBase 5 Omega := by
      simp only [linearChartGenericHom, linearNormalValuation_generic,
        ← Spec.map_comp]
      rfl
    _ = Spec.map (CommRingCat.ofHom
          (projectiveFiveLinearNormalFunctionFieldEquiv Omega).toRingHom) ≫
        (linearNormalValuation_generic 5 Omega ≫
          linearNormalValuation_toBase 5 Omega) := by simp
    _ = Spec.map (CommRingCat.ofHom
          (projectiveFiveLinearNormalFunctionFieldEquiv Omega).toRingHom) ≫
        Spec.map (CommRingCat.ofHom
          (baseToLinearNormalFractionField 5 Omega)) := by
      rw [linearNormalValuation_generic_toBase]
    _ = Spec.map (CommRingCat.ofHom
          ((projectiveFiveLinearNormalFunctionFieldEquiv Omega).toRingHom.comp
            (baseToLinearNormalFractionField 5 Omega))) := by
      rw [← Spec.map_comp]
      rfl
    _ = Spec.map (CommRingCat.ofHom
          (functionFieldBaseRingHom Omega (ProjectiveSpace 5 Omega)
            (ProjectiveSpace.toSpec 5 Omega))) := by rw [hfield]
    _ = (ProjectiveSpace 5 Omega).fromSpecStalk _ ≫
        ProjectiveSpace.toSpec 5 Omega :=
      SpecMap_functionFieldBaseRingHom Omega (ProjectiveSpace 5 Omega)
        (ProjectiveSpace.toSpec 5 Omega)

public theorem biprojectiveTwoTwoLinearNormal_special_toBase
    (Omega : Type u) [Field Omega] :
    Spec.map (CommRingCat.ofHom
        (linearChartResidueHom 5 Omega (BiprojectiveSpace 2 2 Omega)
          (biprojectiveTwoTwoFunctionFieldEquiv Omega))) ≫
        linearNormalValuation_toBase 5 Omega =
      (BiprojectiveSpace 2 2 Omega).fromSpecStalk _ ≫
        BiprojectiveSpace.toSpec 2 2 Omega := by
  have hfield :
      (biprojectiveTwoTwoFunctionFieldEquiv Omega).toRingHom.comp
          (baseToResidualField 5 Omega) =
        functionFieldBaseRingHom Omega (BiprojectiveSpace 2 2 Omega)
          (BiprojectiveSpace.toSpec 2 2 Omega) := by
    ext a
    rw [RingHom.comp_apply]
    change biprojectiveTwoTwoFunctionFieldEquiv Omega
      (baseToResidualField 5 Omega a) = _
    rw [biprojectiveTwoTwoFunctionFieldEquiv_base]
    exact DFunLike.congr_fun
      (biprojectiveTwoTwoBaseToFunctionField_eq Omega) a
  calc
    Spec.map (CommRingCat.ofHom
          (linearChartResidueHom 5 Omega (BiprojectiveSpace 2 2 Omega)
            (biprojectiveTwoTwoFunctionFieldEquiv Omega))) ≫
          linearNormalValuation_toBase 5 Omega =
        (Spec.map (CommRingCat.ofHom
            (biprojectiveTwoTwoFunctionFieldEquiv Omega).toRingHom) ≫
          linearNormalValuation_special 5 Omega) ≫
            linearNormalValuation_toBase 5 Omega := by
      simp only [linearChartResidueHom, linearNormalValuation_special,
        ← Spec.map_comp]
      rfl
    _ = Spec.map (CommRingCat.ofHom
          (biprojectiveTwoTwoFunctionFieldEquiv Omega).toRingHom) ≫
        (linearNormalValuation_special 5 Omega ≫
          linearNormalValuation_toBase 5 Omega) := by simp
    _ = Spec.map (CommRingCat.ofHom
          (biprojectiveTwoTwoFunctionFieldEquiv Omega).toRingHom) ≫
        Spec.map (CommRingCat.ofHom (baseToResidualField 5 Omega)) := by
      rw [linearNormalValuation_special_toBase]
    _ = Spec.map (CommRingCat.ofHom
          ((biprojectiveTwoTwoFunctionFieldEquiv Omega).toRingHom.comp
            (baseToResidualField 5 Omega))) := by
      rw [← Spec.map_comp]
      rfl
    _ = Spec.map (CommRingCat.ofHom
          (functionFieldBaseRingHom Omega (BiprojectiveSpace 2 2 Omega)
            (BiprojectiveSpace.toSpec 2 2 Omega))) := by rw [hfield]
    _ = (BiprojectiveSpace 2 2 Omega).fromSpecStalk _ ≫
        BiprojectiveSpace.toSpec 2 2 Omega :=
      SpecMap_functionFieldBaseRingHom Omega (BiprojectiveSpace 2 2 Omega)
        (BiprojectiveSpace.toSpec 2 2 Omega)

/-! ## A constructor with the geometric carriers and base squares fixed -/

public abbrev projectiveFiveOver
    (Omega : Type u) [Field Omega] : Over (linearBase Omega) :=
  Over.mk (ProjectiveSpace.toSpec 5 Omega)

public abbrev biprojectiveTwoTwoOver
    (Omega : Type u) [Field Omega] : Over (linearBase Omega) :=
  Over.mk (BiprojectiveSpace.toSpec 2 2 Omega)

public abbrev projectiveFiveOverAction
    (Omega : Type u) [Field Omega]
    {N : Type v} [Monoid N]
    (rho : N →* End (projectiveFiveOver Omega)) :
    Action (Over (linearBase Omega)) N :=
  { V := projectiveFiveOver Omega
    ρ := rho }

public abbrev biprojectiveTwoTwoOverAction
    (Omega : Type u) [Field Omega]
    {N : Type v} [Monoid N]
    (rho : N →* End (biprojectiveTwoTwoOver Omega)) :
    Action (Over (linearBase Omega)) N :=
  { V := biprojectiveTwoTwoOver Omega
    ρ := rho }

@[expose] public instance projectiveFiveOverAction_isIntegral
    (Omega : Type u) [Field Omega]
    {N : Type v} [Monoid N]
    (rho : N →* End (projectiveFiveOver Omega)) :
    IsIntegral (projectiveFiveOverAction Omega rho).V.left := by
  change IsIntegral (ProjectiveSpace 5 Omega)
  infer_instance

@[expose] public instance biprojectiveTwoTwoOverAction_isIntegral
    (Omega : Type u) [Field Omega]
    {N : Type v} [Monoid N]
    (rho : N →* End (biprojectiveTwoTwoOver Omega)) :
    IsIntegral (biprojectiveTwoTwoOverAction Omega rho).V.left := by
  change IsIntegral (BiprojectiveSpace 2 2 Omega)
  infer_instance

/-- The chart equivalences and both base squares are now canonical.  The remaining
hypotheses are exactly the action identities required by
`linearNormalEquivariantDataOfChart`. -/
@[expose] public def linearNormalEquivariantDataOfProjectiveBiprojectiveCharts
    (Omega : Type u) [Field Omega]
    {N : Type v} [Group N]
    (sourceAction : N →* End (projectiveFiveOver Omega))
    (exceptionalAction : N →* End (biprojectiveTwoTwoOver Omega))
    (rAct : N →* (LinearNormalValuationRing 5 Omega ≃+*
      LinearNormalValuationRing 5 Omega))
    (kAct : N →* ((ProjectiveSpace 5 Omega).functionField ≃+*
      (ProjectiveSpace 5 Omega).functionField))
    (eAct : N →* ((BiprojectiveSpace 2 2 Omega).functionField ≃+*
      (BiprojectiveSpace 2 2 Omega).functionField))
    (fraction_ring : ∀ n,
      (kAct n).toRingHom.comp
          (linearChartGenericHom 5 Omega (ProjectiveSpace 5 Omega)
            (projectiveFiveLinearNormalFunctionFieldEquiv Omega)) =
        (linearChartGenericHom 5 Omega (ProjectiveSpace 5 Omega)
          (projectiveFiveLinearNormalFunctionFieldEquiv Omega)).comp
            (rAct n).toRingHom)
    (residue_ring : ∀ n,
      (eAct n).toRingHom.comp
          (linearChartResidueHom 5 Omega (BiprojectiveSpace 2 2 Omega)
            (biprojectiveTwoTwoFunctionFieldEquiv Omega)) =
        (linearChartResidueHom 5 Omega (BiprojectiveSpace 2 2 Omega)
          (biprojectiveTwoTwoFunctionFieldEquiv Omega)).comp
            (rAct n).toRingHom)
    (base_ring : ∀ n,
      (rAct n).toRingHom.comp (baseToLinearNormalRing 5 Omega) =
        baseToLinearNormalRing 5 Omega)
    (source_fromFunctionField : ∀ n {Z : Scheme.{u}}
      (q : (ProjectiveSpace 5 Omega) ⤏ Z),
      (actionPrecomp (projectiveFiveOverAction Omega sourceAction) n q).fromFunctionField =
        Spec.map (CommRingCat.ofHom (kAct n).toRingHom) ≫
          q.fromFunctionField)
    (exceptional_fromFunctionField : ∀ n {Z : Scheme.{u}}
      (q : (BiprojectiveSpace 2 2 Omega) ⤏ Z),
      (actionPrecomp (biprojectiveTwoTwoOverAction Omega exceptionalAction) n q).fromFunctionField =
        Spec.map (CommRingCat.ofHom (eAct n).toRingHom) ≫
          q.fromFunctionField) :
    EquivariantNormalValuationData
      (projectiveFiveOverAction Omega sourceAction)
      (biprojectiveTwoTwoOverAction Omega exceptionalAction) :=
  linearNormalEquivariantDataOfChart 5 Omega
    (projectiveFiveOverAction Omega sourceAction)
    (biprojectiveTwoTwoOverAction Omega exceptionalAction)
    (projectiveFiveLinearNormalFunctionFieldEquiv Omega)
    (biprojectiveTwoTwoFunctionFieldEquiv Omega)
    (projectiveFiveLinearNormal_generic_toBase Omega)
    (biprojectiveTwoTwoLinearNormal_special_toBase Omega)
    rAct kAct eAct fraction_ring residue_ring base_ring
    source_fromFunctionField exceptional_fromFunctionField


end V14Formalization.SchemeGeometry
