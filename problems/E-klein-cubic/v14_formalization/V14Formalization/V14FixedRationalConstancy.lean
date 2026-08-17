/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.V14FixedFieldPointDescent
import V14Formalization.SchemeRationalConstancy
import V14Formalization.GenericCharts
import V14Formalization.UniversalNormalDivisor
import V14Formalization.V14SchemeBaseChange
import V14Formalization.SchemeModelAliases

/-!
# Constancy of an over-base rational map from the exceptional divisor
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open GeometricV14Carrier
open EllipticPolynomialConstancy


/-- The `Action` wrapper is not needed: only the underlying scheme over the
base appears in the generic-point comparison. -/
theorem rationalMapIsConstantOver_fixedBy_of_comp_descends_over
    {G : Type*} [Group G]
    (Y : Action (Over (Spec (.of k))) G) (σ : G)
    [IsSeparated Y.V.hom]
    {E : Over (Spec (.of k))}
    [IsIntegral E.left]
    (q : Scheme.RationalMap E.left (FixedBy Y σ).left)
    (y : Spec (.of k) ⟶ Y.V.left)
    (hybase : y ≫ Y.V.hom = 𝟙 _)
    (hyfixed : y ≫ (Y.ρ σ).left = y)
    (hgeneric :
      q.fromFunctionField ≫ (fixedByι Y σ).left =
        (E.left.fromSpecStalk (genericPoint E.left) ≫ E.hom) ≫ y) :
    RationalMapIsConstantOver (E := E) (Z := FixedBy Y σ) q := by
  haveI : IsClosedImmersion (fixedByι Y σ).left := inferInstance
  let yOver : Over.mk (𝟙 (Spec (.of k))) ⟶ Y.V :=
    Over.homMk y (by
      change y ≫ Y.V.hom = 𝟙 _
      exact hybase)
  have hyfixedOver : yOver ≫ Y.ρ σ = yOver := by
    apply Over.OverMorphism.ext
    exact hyfixed
  let zOver := fixedByLift Y σ yOver hyfixedOver
  let z : Spec (.of k) ⟶ (FixedBy Y σ).left := zOver.left
  have hz' : z ≫ (fixedByι Y σ).left = y := by
    exact congrArg Over.Hom.left (fixedByLift_ι Y σ yOver hyfixedOver)
  have hff : q.fromFunctionField =
      (E.left.fromSpecStalk (genericPoint E.left) ≫ E.hom) ≫ z := by
    apply (cancel_mono (fixedByι Y σ).left).1
    calc
      q.fromFunctionField ≫ (fixedByι Y σ).left =
          (E.left.fromSpecStalk (genericPoint E.left) ≫ E.hom) ≫ y :=
        hgeneric
      _ = (E.left.fromSpecStalk (genericPoint E.left) ≫ E.hom) ≫
          (z ≫ (fixedByι Y σ).left) := by rw [hz']
      _ = ((E.left.fromSpecStalk (genericPoint E.left) ≫ E.hom) ≫ z) ≫
          (fixedByι Y σ).left := (Category.assoc _ _ _).symm
  unfold RationalMapIsConstantOver
  refine ⟨z, Scheme.RationalMap.eq_of_fromFunctionField_eq _ _ ?_⟩
  rw [Scheme.RationalMap.fromFunctionField_toRationalMap]
  simpa only [Scheme.PartialMap.fromSpecStalkOfMem_toPartialMap,
    Category.assoc] using hff

/-- An over-base rational map from the biprojective exceptional divisor to
the scheme-theoretic sigma-fixed locus is constant. -/
theorem rationalMapIsConstantOver_v14FixedBy
    (p q : ℕ)
    (z : Scheme.RationalMap
      (BiprojectiveSpace p q k)
      (FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma).left)
    (hz : z.IsOver (Spec (.of k))) :
    RationalMapIsConstantOver
      (E := Over.mk (BiprojectiveSpace.toSpec p q k))
      (Z := FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma) z := by
  let Esch := BiprojectiveSpace p q k
  let L := Esch.functionField
  letI : Algebra k L :=
    (biprojectiveGeneralBaseToFunctionField p q k).toAlgebra
  haveI : CharZero L := by
    refine ⟨fun m n hmn => ?_⟩
    have : algebraMap k L (m : k) = algebraMap k L (n : k) := by
      simpa [map_natCast] using hmn
    exact CharZero.cast_injective ((algebraMap k L).injective this)
  haveI : NeZero (2 : L) := inferInstance
  haveI : IsIntegral Esch := inferInstance
  haveI : IsIntegral (Over.mk (BiprojectiveSpace.toSpec p q k)).left := by
    change IsIntegral (BiprojectiveSpace p q k)
    infer_instance
  haveI : IsSeparated V14SchemeModel.actionOver.V.hom := inferInstance
  haveI : IsClosedImmersion
      (fixedByι V14SchemeModel.actionOver sigma).left := inferInstance
  haveI : LocallyOfFiniteType
      (FixedBy V14SchemeModel.actionOver sigma).hom := by
    have hhom :
        (FixedBy V14SchemeModel.actionOver sigma).hom =
          (fixedByι V14SchemeModel.actionOver sigma).left ≫
            V14SchemeModel.actionOver.V.hom :=
      (Over.w (fixedByι V14SchemeModel.actionOver sigma)).symm
    rw [hhom]
    infer_instance
  haveI : LocallyOfFiniteType
      ((FixedBy V14SchemeModel.actionOver sigma).left ↘ Spec (.of k)) := by
    change LocallyOfFiniteType
      (FixedBy V14SchemeModel.actionOver sigma).hom
    infer_instance
  letI specL_over : (Spec (.of L)).Over (Spec (.of k)) :=
    ⟨Esch.fromSpecStalk (genericPoint Esch) ≫
      BiprojectiveSpace.toSpec p q k⟩
  let e0 := biprojectiveGeneralFunctionFieldEquiv p q k
  let e : MvFrac k (p + q) ≃ₐ[k] L :=
    AlgEquiv.ofRingEquiv (f := e0) fun a => by
      have hcomm := biprojectiveGeneralFunctionFieldEquiv_base p q k a
      have halg : algebraMap k L a =
          biprojectiveGeneralBaseToFunctionField p q k a := rfl
      have hres : algebraMap k (MvFrac k (p + q)) a =
          baseToResidualField ((p + q) + 1) k a := rfl
      rw [halg, hres]
      exact hcomm
  let qffOver :=
    (Scheme.RationalMap.equivFunctionFieldOver
      (S := Spec (.of k))).symm
      (⟨z, hz⟩ :
        {q : Scheme.RationalMap Esch
          (FixedBy V14SchemeModel.actionOver sigma).left //
          q.IsOver (Spec (.of k))})
  letI : z.fromFunctionField.IsOver (Spec (.of k)) := qffOver.2
  have hover :
      z.fromFunctionField ≫
          (FixedBy V14SchemeModel.actionOver sigma).hom =
        Esch.fromSpecStalk (genericPoint Esch) ≫
          BiprojectiveSpace.toSpec p q k :=
    (Scheme.Hom.isOver_iff (Spec (.of k))).mp
      (show z.fromFunctionField.IsOver (Spec (.of k)) by infer_instance)
  have hSpec :
      Spec.map (CommRingCat.ofHom (algebraMap k L)) =
        Esch.fromSpecStalk (genericPoint Esch) ≫
          BiprojectiveSpace.toSpec p q k := by
    have hff :
        algebraMap k L = functionFieldBaseRingHom k Esch
          (BiprojectiveSpace.toSpec p q k) :=
      RingHom.ext fun a =>
        DFunLike.congr_fun
          (biprojectiveGeneralBaseToFunctionField_eq p q k) a
    rw [hff]
    exact SpecMap_functionFieldBaseRingHom k Esch
      (BiprojectiveSpace.toSpec p q k)
  let pOver : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver sigma :=
    Over.homMk z.fromFunctionField (by
      change z.fromFunctionField ≫
          (FixedBy V14SchemeModel.actionOver sigma).hom =
        Spec.map (CommRingCat.ofHom (algebraMap k L))
      rw [hover, hSpec])
  obtain ⟨y, hybase, hyfixed, hcomp⟩ :=
    v14FixedFieldPoint_descends_of_mvfrac (p + q) L e pOver
  refine rationalMapIsConstantOver_fixedBy_of_comp_descends_over
      (E := Over.mk (BiprojectiveSpace.toSpec p q k))
      V14SchemeModel.actionOver sigma z y hybase hyfixed ?_
  change z.fromFunctionField ≫
      (fixedByι V14SchemeModel.actionOver sigma).left =
    (Esch.fromSpecStalk (genericPoint Esch) ≫
      BiprojectiveSpace.toSpec p q k) ≫ y
  have hp : pOver.left = z.fromFunctionField := rfl
  rw [← hp, ← hSpec]
  exact hcomp

end V14Formalization.SchemeGeometry
