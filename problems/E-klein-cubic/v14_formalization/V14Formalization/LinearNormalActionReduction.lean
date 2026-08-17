/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.LinearNormalProjectiveChart
public import V14Formalization.UniversalNormalDivisor

/-!
# Transporting normal-valuation actions to projective charts

This module reduces equivariant normal specialization to explicit actions on
the source and exceptional function fields and preservation of the X-adic
chart. No projective-coordinate compatibility is assumed implicitly.
-/

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry
open Polynomial IsLocalRing IsDedekindDomain

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

universe u v

/-! ## Restricting a function-field action to the X-adic valuation ring -/

public abbrev xAdicSubring (κ : Type u) [Field κ] : ValuationSubring (RatFunc κ) :=
  ((idealX κ).valuation (RatFunc κ)).valuationSubring

@[expose] public noncomputable def xAdicRestrictEquiv
    (κ : Type u) [Field κ]
    (e : RatFunc κ ≃+* RatFunc κ)
    (hpres : ∀ x : RatFunc κ, x ∈ xAdicSubring κ ↔ e x ∈ xAdicSubring κ) :
    XAdicIntegers κ ≃+* XAdicIntegers κ where
  toFun x := ⟨e x, (hpres x).mp x.property⟩
  invFun x := ⟨e.symm x, (hpres (e.symm x)).mpr (by simpa using x.property)⟩
  left_inv x := Subtype.ext (e.symm_apply_apply x)
  right_inv x := Subtype.ext (e.apply_symm_apply x)
  map_mul' x y := Subtype.ext (e.map_mul x y)
  map_add' x y := Subtype.ext (e.map_add x y)

@[expose] public noncomputable def xAdicRestrictAction
    (κ : Type u) [Field κ]
    {N : Type v} [Group N]
    (kAct : N →* (RatFunc κ ≃+* RatFunc κ))
    (hpres : ∀ n x, x ∈ xAdicSubring κ ↔ kAct n x ∈ xAdicSubring κ) :
    N →* (XAdicIntegers κ ≃+* XAdicIntegers κ) where
  toFun n := xAdicRestrictEquiv κ (kAct n) (hpres n)
  map_one' := by
    ext x
    simp [xAdicRestrictEquiv]
  map_mul' n m := by
    ext x
    simp [xAdicRestrictEquiv]

theorem xAdicRestrictAction_fraction_ring
    (κ : Type u) [Field κ]
    {N : Type v} [Group N]
    (kAct : N →* (RatFunc κ ≃+* RatFunc κ))
    (hpres : ∀ n x, x ∈ xAdicSubring κ ↔ kAct n x ∈ xAdicSubring κ)
    (n : N) :
    (kAct n).toRingHom.comp (algebraMap (XAdicIntegers κ) (RatFunc κ)) =
      (algebraMap (XAdicIntegers κ) (RatFunc κ)).comp
        ((xAdicRestrictAction κ kAct hpres n).toRingHom) := by
  ext x
  rfl

theorem xAdicRestrictAction_residue_ring
    (κ : Type u) [Field κ]
    {N : Type v} [Group N]
    (kAct : N →* (RatFunc κ ≃+* RatFunc κ))
    (eAct : N →* (κ ≃+* κ))
    (hpres : ∀ n x, x ∈ xAdicSubring κ ↔ kAct n x ∈ xAdicSubring κ)
    (hresidue : ∀ n x,
      eAct n (xAdicResidue κ x) =
        xAdicResidue κ (xAdicRestrictAction κ kAct hpres n x))
    (n : N) :
    (eAct n).toRingHom.comp (xAdicResidue κ) =
      (xAdicResidue κ).comp
        ((xAdicRestrictAction κ kAct hpres n).toRingHom) := by
  ext x
  exact hresidue n x

/-- Once a function-field automorphism preserves the X-adic valuation ring,
its residue action is forced by its action on constants. -/
theorem xAdicRestrictEquiv_residue_of_constants
    (κ : Type u) [Field κ]
    (e : RatFunc κ ≃+* RatFunc κ)
    (tau : κ ≃+* κ)
    (hpres : ∀ x : RatFunc κ,
      x ∈ xAdicSubring κ ↔ e x ∈ xAdicSubring κ)
    (hconst : ∀ a : κ,
      e (algebraMap κ[X] (RatFunc κ) (C a)) =
        algebraMap κ[X] (RatFunc κ) (C (tau a)))
    (x : XAdicIntegers κ) :
    tau (xAdicResidue κ x) =
      xAdicResidue κ (xAdicRestrictEquiv κ e hpres x) := by
  let er := xAdicRestrictEquiv κ e hpres
  let a := xAdicResidue κ x
  have hx : x - constToXAdic κ a ∈ maximalIdeal (XAdicIntegers κ) := by
    rw [← xAdicResidue_ker]
    simp [a, xAdicResidue_const]
  have himage : er (x - constToXAdic κ a) ∈
      maximalIdeal (XAdicIntegers κ) := by
    rw [← IsLocalRing.map_ringEquiv_maximalIdeal er]
    exact Ideal.mem_map_of_mem er.toRingHom hx
  have hconst' : er (constToXAdic κ a) = constToXAdic κ (tau a) := by
    apply Subtype.ext
    exact hconst a
  rw [map_sub, hconst', ← xAdicResidue_ker] at himage
  change tau (xAdicResidue κ x) = xAdicResidue κ (er x)
  exact (sub_eq_zero.mp (by
    simpa [a, map_sub, xAdicResidue_const] using himage)).symm

public theorem xAdicRestrictAction_residue_ring_of_constants
    (κ : Type u) [Field κ]
    {N : Type v} [Group N]
    (kAct : N →* (RatFunc κ ≃+* RatFunc κ))
    (eAct : N →* (κ ≃+* κ))
    (hpres : ∀ n x,
      x ∈ xAdicSubring κ ↔ kAct n x ∈ xAdicSubring κ)
    (hconst : ∀ n a,
      kAct n (algebraMap κ[X] (RatFunc κ) (C a)) =
        algebraMap κ[X] (RatFunc κ) (C (eAct n a)))
    (n : N) :
    (eAct n).toRingHom.comp (xAdicResidue κ) =
      (xAdicResidue κ).comp
        ((xAdicRestrictAction κ kAct hpres n).toRingHom) := by
  ext x
  exact xAdicRestrictEquiv_residue_of_constants κ
    (kAct n) (eAct n) (hpres n) (hconst n) x

theorem linearNormalRestrictAction_base_ring
    (Omega : Type u) [Field Omega]
    {N : Type v} [Group N]
    (kAct : N →* (LinearNormalFractionField 5 Omega ≃+*
      LinearNormalFractionField 5 Omega))
    (hpres : ∀ n x,
      x ∈ xAdicSubring (LinearResidualField 5 Omega) ↔
        kAct n x ∈ xAdicSubring (LinearResidualField 5 Omega))
    (hbase : ∀ n a,
      kAct n (baseToLinearNormalFractionField 5 Omega a) =
        baseToLinearNormalFractionField 5 Omega a)
    (n : N) :
    ((xAdicRestrictAction (LinearResidualField 5 Omega) kAct hpres n).toRingHom).comp
        (baseToLinearNormalRing 5 Omega) =
      baseToLinearNormalRing 5 Omega := by
  ext a
  change kAct n (baseToLinearNormalFractionField 5 Omega a) =
    baseToLinearNormalFractionField 5 Omega a
  exact hbase n a

/-! ## Transport through the checked source and exceptional charts -/

@[expose] public noncomputable def conjugateRingAction
    {K L : Type u} [CommRing K] [CommRing L]
    {N : Type v} [Group N]
    (e : K ≃+* L) (a : N →* (L ≃+* L)) :
    N →* (K ≃+* K) where
  toFun n := e.trans ((a n).trans e.symm)
  map_one' := by
    ext x
    simp
  map_mul' n m := by
    ext x
    simp

theorem transported_xAdic_fraction_ring
    (κ L : Type u) [Field κ] [Field L]
    {N : Type v} [Group N]
    (e : RatFunc κ ≃+* L)
    (a : N →* (L ≃+* L))
    (hpres : ∀ n x,
      x ∈ xAdicSubring κ ↔ conjugateRingAction e a n x ∈ xAdicSubring κ)
    (n : N) :
    (a n).toRingHom.comp
        (e.toRingHom.comp (algebraMap (XAdicIntegers κ) (RatFunc κ))) =
      (e.toRingHom.comp (algebraMap (XAdicIntegers κ) (RatFunc κ))).comp
        ((xAdicRestrictAction κ (conjugateRingAction e a) hpres n).toRingHom) := by
  ext x
  change a n (e x) = e (conjugateRingAction e a n x)
  simp [conjugateRingAction]

theorem transported_xAdic_residue_ring
    (κ L E : Type u) [Field κ] [Field L] [Field E]
    {N : Type v} [Group N]
    (eK : RatFunc κ ≃+* L)
    (eE : κ ≃+* E)
    (kAct : N →* (L ≃+* L))
    (eAct : N →* (E ≃+* E))
    (hpres : ∀ n x,
      x ∈ xAdicSubring κ ↔
        conjugateRingAction eK kAct n x ∈ xAdicSubring κ)
    (hresidue : ∀ n x,
      conjugateRingAction eE eAct n (xAdicResidue κ x) =
        xAdicResidue κ
          (xAdicRestrictAction κ
            (conjugateRingAction eK kAct) hpres n x))
    (n : N) :
    (eAct n).toRingHom.comp (eE.toRingHom.comp (xAdicResidue κ)) =
      (eE.toRingHom.comp (xAdicResidue κ)).comp
        ((xAdicRestrictAction κ
          (conjugateRingAction eK kAct) hpres n).toRingHom) := by
  ext x
  apply eE.symm.injective
  simpa [conjugateRingAction] using hresidue n x

public theorem actionPrecomp_overStructureMap
    {S : Scheme.{u}} {N : Type v} [Group N]
    (X : Action (Over S) N) [IrreducibleSpace X.V.left]
    (n : N) :
    actionPrecomp X n X.V.hom.toRationalMap =
      X.V.hom.toRationalMap := by
  let e : X.V.left ≅ X.V.left := (Over.forget S).mapIso (X.ρAut n)
  letI : IsIso (X.ρ n).left := by
    change IsIso e.hom
    infer_instance
  letI : IsDominant (X.ρ n).left := inferInstance
  letI : ((X.ρ n).left.toRationalMap).IsDominant := inferInstance
  change ((X.ρ n).left.toRationalMap.comp
    X.V.hom.toRationalMap) = X.V.hom.toRationalMap
  rw [Scheme.RationalMap.comp_toRationalMap]
  exact congrArg Scheme.Hom.toRationalMap (X.ρ n).w

public theorem functionFieldAction_fixes_base_of_fromFunctionField
    (Omega : Type u) [Field Omega]
    {N : Type v} [Group N]
    (X : Action (Over (Spec (.of Omega))) N)
    [IsIntegral X.V.left]
    (kAct : N →* (X.V.left.functionField ≃+* X.V.left.functionField))
    (hfrom : ∀ n {Z : Scheme.{u}} (q : X.V.left ⤏ Z),
      (actionPrecomp X n q).fromFunctionField =
        Spec.map (CommRingCat.ofHom (kAct n).toRingHom) ≫
          q.fromFunctionField)
    (n : N) :
    (kAct n).toRingHom.comp
        (functionFieldBaseRingHom Omega X.V.left X.V.hom) =
      functionFieldBaseRingHom Omega X.V.left X.V.hom := by
  let q := X.V.hom.toRationalMap
  have h := hfrom n q
  rw [actionPrecomp_overStructureMap] at h
  have hq : q.fromFunctionField =
      Spec.map (CommRingCat.ofHom
        (functionFieldBaseRingHom Omega X.V.left X.V.hom)) := by
    dsimp [q]
    rw [show X.V.hom.toPartialMap.fromFunctionField =
        X.V.left.fromSpecStalk (genericPoint X.V.left) ≫ X.V.hom by
      exact Scheme.PartialMap.fromSpecStalkOfMem_toPartialMap
        X.V.hom (genericPoint X.V.left)]
    exact (SpecMap_functionFieldBaseRingHom Omega X.V.left X.V.hom).symm
  rw [hq, ← Spec.map_comp] at h
  rw [Spec.map_injective.eq_iff] at h
  exact congrArg CommRingCat.Hom.hom h.symm

/-- The canonical generic-stalk pullback of an over-base action fixes the
embedded base field. -/
public theorem functionFieldAction_fixes_base
    (Omega : Type u) [Field Omega]
    {N : Type v} [Group N]
    (X : Action (Over (Spec (.of Omega))) N)
    [IsIntegral X.V.left]
    (kAct : N →* (X.V.left.functionField ≃+* X.V.left.functionField))
    (hmap : ∀ n,
      (kAct n).toRingHom = (Scheme.actionFunctionFieldMap X n).hom)
    (n : N) :
    (kAct n).toRingHom.comp
        (functionFieldBaseRingHom Omega X.V.left X.V.hom) =
      functionFieldBaseRingHom Omega X.V.left X.V.hom := by
  apply functionFieldAction_fixes_base_of_fromFunctionField Omega X kAct
  intro m Z q
  rw [hmap m]
  exact Scheme.actionPrecomp_fromFunctionField_generic X m q

/-! ## The actual ordered plus/minus centralizer carriers -/

variable {Omega : Type u} [Field Omega]
  {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module Omega V]

public abbrev orderedPlusMinusSourceAction
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma)
    (bp : Basis (Fin 3) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin 3) Omega (R.minusEigenspace sigma)) :
    Action (Over (Spec (.of Omega))) (centralizer sigma) :=
  (Action.res (Over (Spec (.of Omega)))
    (Subgroup.subtype (centralizer sigma))).obj
      (ambientProjectiveActionOver R 5
        (plusMinusAmbientBasis R sigma hsigma 2 2 bp bm))

public abbrev orderedPlusMinusExceptionalAction
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (bp : Basis (Fin 3) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin 3) Omega (R.minusEigenspace sigma)) :
    Action (Over (Spec (.of Omega))) (centralizer sigma) :=
  normalDivisorActionOver R sigma 2 2 bp bm

@[simp]
theorem orderedPlusMinusSourceAction_carrier
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma)
    (bp : Basis (Fin 3) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin 3) Omega (R.minusEigenspace sigma)) :
    (orderedPlusMinusSourceAction R sigma hsigma bp bm).V.left =
      ProjectiveSpace 5 Omega := rfl

@[simp]
theorem orderedPlusMinusSourceAction_toSpec
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma)
    (bp : Basis (Fin 3) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin 3) Omega (R.minusEigenspace sigma)) :
    (orderedPlusMinusSourceAction R sigma hsigma bp bm).V.hom =
      ProjectiveSpace.toSpec 5 Omega := rfl

theorem orderedPlusMinusExceptionalAction_carrier
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (bp : Basis (Fin 3) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin 3) Omega (R.minusEigenspace sigma)) :
    (orderedPlusMinusExceptionalAction R sigma bp bm).V.left =
      BiprojectiveSpace 2 2 Omega := rfl

/-! The checked chart equivalences turn arbitrary function-field actions on the
two actual carriers into actions on the explicit normal model. -/

public noncomputable abbrev projectiveFiveChartModelAction
    {N : Type v} [Group N]
    (kAct : N →* ((ProjectiveSpace 5 Omega).functionField ≃+*
      (ProjectiveSpace 5 Omega).functionField)) :
    N →* (LinearNormalFractionField 5 Omega ≃+*
      LinearNormalFractionField 5 Omega) :=
  conjugateRingAction
    (projectiveFiveLinearNormalFunctionFieldEquiv Omega) kAct

public noncomputable abbrev biprojectiveTwoTwoChartModelAction
    {N : Type v} [Group N]
    (eAct : N →* ((BiprojectiveSpace 2 2 Omega).functionField ≃+*
      (BiprojectiveSpace 2 2 Omega).functionField)) :
    N →* (LinearExceptionalFunctionField 5 Omega ≃+*
      LinearExceptionalFunctionField 5 Omega) :=
  conjugateRingAction
    (biprojectiveTwoTwoFunctionFieldEquiv Omega) eAct

@[expose] public noncomputable def projectiveFiveChartValuationAction
    {N : Type v} [Group N]
    (kAct : N →* ((ProjectiveSpace 5 Omega).functionField ≃+*
      (ProjectiveSpace 5 Omega).functionField))
    (hpres : ∀ n x,
      x ∈ xAdicSubring (LinearResidualField 5 Omega) ↔
        projectiveFiveChartModelAction kAct n x ∈
          xAdicSubring (LinearResidualField 5 Omega)) :
    N →* (LinearNormalValuationRing 5 Omega ≃+*
      LinearNormalValuationRing 5 Omega) :=
  xAdicRestrictAction (LinearResidualField 5 Omega)
    (projectiveFiveChartModelAction kAct) hpres

public theorem projectiveFiveChart_fraction_ring
    {N : Type v} [Group N]
    (kAct : N →* ((ProjectiveSpace 5 Omega).functionField ≃+*
      (ProjectiveSpace 5 Omega).functionField))
    (hpres : ∀ n x,
      x ∈ xAdicSubring (LinearResidualField 5 Omega) ↔
        projectiveFiveChartModelAction kAct n x ∈
          xAdicSubring (LinearResidualField 5 Omega))
    (n : N) :
    (kAct n).toRingHom.comp
        (linearChartGenericHom 5 Omega (ProjectiveSpace 5 Omega)
          (projectiveFiveLinearNormalFunctionFieldEquiv Omega)) =
      (linearChartGenericHom 5 Omega (ProjectiveSpace 5 Omega)
        (projectiveFiveLinearNormalFunctionFieldEquiv Omega)).comp
          (projectiveFiveChartValuationAction kAct hpres n).toRingHom := by
  exact transported_xAdic_fraction_ring
    (LinearResidualField 5 Omega)
    (ProjectiveSpace 5 Omega).functionField
    (projectiveFiveLinearNormalFunctionFieldEquiv Omega)
    kAct hpres n

public theorem biprojectiveTwoTwoChart_residue_ring
    {N : Type v} [Group N]
    (kAct : N →* ((ProjectiveSpace 5 Omega).functionField ≃+*
      (ProjectiveSpace 5 Omega).functionField))
    (eAct : N →* ((BiprojectiveSpace 2 2 Omega).functionField ≃+*
      (BiprojectiveSpace 2 2 Omega).functionField))
    (hpres : ∀ n x,
      x ∈ xAdicSubring (LinearResidualField 5 Omega) ↔
        projectiveFiveChartModelAction kAct n x ∈
          xAdicSubring (LinearResidualField 5 Omega))
    (hresidue : ∀ n x,
      biprojectiveTwoTwoChartModelAction eAct n
          (linearNormalResidue 5 Omega x) =
        linearNormalResidue 5 Omega
          (projectiveFiveChartValuationAction kAct hpres n x))
    (n : N) :
    (eAct n).toRingHom.comp
        (linearChartResidueHom 5 Omega (BiprojectiveSpace 2 2 Omega)
          (biprojectiveTwoTwoFunctionFieldEquiv Omega)) =
      (linearChartResidueHom 5 Omega (BiprojectiveSpace 2 2 Omega)
        (biprojectiveTwoTwoFunctionFieldEquiv Omega)).comp
          (projectiveFiveChartValuationAction kAct hpres n).toRingHom := by
  ext x
  apply (biprojectiveTwoTwoFunctionFieldEquiv Omega).symm.injective
  simpa [linearChartResidueHom, biprojectiveTwoTwoChartModelAction,
    conjugateRingAction, projectiveFiveChartValuationAction] using
      hresidue n x

public theorem projectiveFiveChart_base_ring
    {N : Type v} [Group N]
    (kAct : N →* ((ProjectiveSpace 5 Omega).functionField ≃+*
      (ProjectiveSpace 5 Omega).functionField))
    (hpres : ∀ n x,
      x ∈ xAdicSubring (LinearResidualField 5 Omega) ↔
        projectiveFiveChartModelAction kAct n x ∈
          xAdicSubring (LinearResidualField 5 Omega))
    (hbase : ∀ n a,
      projectiveFiveChartModelAction kAct n
          (baseToLinearNormalFractionField 5 Omega a) =
        baseToLinearNormalFractionField 5 Omega a)
    (n : N) :
    (projectiveFiveChartValuationAction kAct hpres n).toRingHom.comp
        (baseToLinearNormalRing 5 Omega) =
      baseToLinearNormalRing 5 Omega :=
  linearNormalRestrictAction_base_ring Omega
    (projectiveFiveChartModelAction kAct) hpres hbase n

public theorem orderedPlusMinusChartModelAction_fixes_base
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma)
    (bp : Basis (Fin 3) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin 3) Omega (R.minusEigenspace sigma))
    (kAct : centralizer sigma →*
      ((ProjectiveSpace 5 Omega).functionField ≃+*
        (ProjectiveSpace 5 Omega).functionField))
    (source_field_map : ∀ n,
      (kAct n).toRingHom =
        (Scheme.actionFunctionFieldMap
          (orderedPlusMinusSourceAction R sigma hsigma bp bm) n).hom)
    (n : centralizer sigma) (a : Omega) :
    projectiveFiveChartModelAction kAct n
        (baseToLinearNormalFractionField 5 Omega a) =
      baseToLinearNormalFractionField 5 Omega a := by
  have hk := congrArg (fun f : Omega →+*
      (ProjectiveSpace 5 Omega).functionField ↦ f a)
    (functionFieldAction_fixes_base Omega
      (orderedPlusMinusSourceAction R sigma hsigma bp bm)
      kAct source_field_map n)
  change kAct n
      (functionFieldBaseRingHom Omega (ProjectiveSpace 5 Omega)
        (ProjectiveSpace.toSpec 5 Omega) a) =
    functionFieldBaseRingHom Omega (ProjectiveSpace 5 Omega)
      (ProjectiveSpace.toSpec 5 Omega) a at hk
  change (projectiveFiveLinearNormalFunctionFieldEquiv Omega).symm
      (kAct n (projectiveFiveLinearNormalFunctionFieldEquiv Omega
        (baseToLinearNormalFractionField 5 Omega a))) =
    baseToLinearNormalFractionField 5 Omega a
  apply (projectiveFiveLinearNormalFunctionFieldEquiv Omega).injective
  simp only [RingEquiv.apply_symm_apply]
  rw [projectiveFiveLinearNormalFunctionFieldEquiv_base,
    projectiveFiveBaseToFunctionField_eq]
  exact hk

/-- For the actual ordered plus/minus centralizer actions, the three ring
naturality hypotheses are consequences of preservation of the X-adic subring,
compatibility with residue, and preservation of base constants. -/
@[expose] public noncomputable def orderedPlusMinusEquivariantNormalData
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma)
    (bp : Basis (Fin 3) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin 3) Omega (R.minusEigenspace sigma))
    (kAct : centralizer sigma →*
      ((ProjectiveSpace 5 Omega).functionField ≃+*
        (ProjectiveSpace 5 Omega).functionField))
    (eAct : centralizer sigma →*
      ((BiprojectiveSpace 2 2 Omega).functionField ≃+*
        (BiprojectiveSpace 2 2 Omega).functionField))
    (hpres : ∀ n x,
      x ∈ xAdicSubring (LinearResidualField 5 Omega) ↔
        projectiveFiveChartModelAction kAct n x ∈
          xAdicSubring (LinearResidualField 5 Omega))
    (hresidue : ∀ n x,
      biprojectiveTwoTwoChartModelAction eAct n
          (linearNormalResidue 5 Omega x) =
        linearNormalResidue 5 Omega
          (projectiveFiveChartValuationAction kAct hpres n x))
    (source_field_map : ∀ n,
      (kAct n).toRingHom =
        (Scheme.actionFunctionFieldMap
          (orderedPlusMinusSourceAction R sigma hsigma bp bm) n).hom)
    (exceptional_field_map : ∀ n,
      (eAct n).toRingHom =
        (Scheme.actionFunctionFieldMap
          (orderedPlusMinusExceptionalAction R sigma bp bm) n).hom) :
    EquivariantNormalValuationData
      (orderedPlusMinusSourceAction R sigma hsigma bp bm)
      (orderedPlusMinusExceptionalAction R sigma bp bm) := by
  apply linearNormalEquivariantDataOfChart_of_actionFunctionFieldMap 5 Omega
    (orderedPlusMinusSourceAction R sigma hsigma bp bm)
    (orderedPlusMinusExceptionalAction R sigma bp bm)
    (projectiveFiveLinearNormalFunctionFieldEquiv Omega)
    (biprojectiveTwoTwoFunctionFieldEquiv Omega)
    (projectiveFiveLinearNormal_generic_toBase Omega)
    (biprojectiveTwoTwoLinearNormal_special_toBase Omega)
    (projectiveFiveChartValuationAction kAct hpres)
    kAct eAct
  · exact fun n ↦ projectiveFiveChart_fraction_ring kAct hpres n
  · exact fun n ↦
      biprojectiveTwoTwoChart_residue_ring kAct eAct hpres hresidue n
  · exact fun n ↦ projectiveFiveChart_base_ring kAct hpres
      (orderedPlusMinusChartModelAction_fixes_base
        R sigma hsigma bp bm kAct source_field_map) n
  · exact source_field_map
  · exact exceptional_field_map

end V14Formalization.SchemeGeometry
