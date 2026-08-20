/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14FixedFieldPointDescentOverField
public import V14Formalization.V14FixedRationalConstancy
public import V14Formalization.SchemeBaseChangeFixed
public import V14Formalization.FaithfulHeadlineOverField

/-!
# Hypothesis (a) over an arbitrary base field

`V14FixedRationalConstancy.rationalMapIsConstantOver_v14FixedBy` proves that an
over-base rational map from a biprojective space to the `σ`-fixed locus of the
coordinate `V₁₄` is constant, over `k = ℚ(ζ₁₁)`.  This file proves the same
over every field `F` over `ℚ(ζ₁₁)`, against the base-changed target — which is
exactly `SchemeGeometry.HypothesisAOver F`, the last hypothesis the
general-field headline carried.

The argument is unchanged.  Only two things move:

* the point produced by the descent is an `F`-point rather than a `k`-point,
  which is `V14FixedFieldPointDescentOverField`;
* `RationalMapIsConstantOver` at base `F` wants a section of the *base change*,
  so the `F`-point is lifted along `pullback.lift` against `𝟙 (Spec F)`.  The
  opposite transfer — a fixed section of the base change gives a fixed point
  upstairs — is `SchemeBaseChangeFixed`.
-/

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open GeometricV14Carrier
open EllipticPolynomialConstancy

/-! ## Constancy from a descended generic point, over any base -/

/-- `rationalMapIsConstantOver_fixedBy_of_comp_descends_over` with the base
field a parameter rather than `ℚ(ζ₁₁)`.  Only the underlying scheme over the
base appears in the generic-point comparison. -/
public theorem rationalMapIsConstantOver_fixedBy_of_comp_descends_base
    {Omega : Type} [Field Omega] {G : Type*} [Group G]
    (Y : Action (Over (Spec (.of Omega))) G) (σ : G)
    [IsSeparated Y.V.hom]
    {E : Over (Spec (.of Omega))} [IsIntegral E.left]
    (q : Scheme.RationalMap E.left (FixedBy Y σ).left)
    (y : Spec (.of Omega) ⟶ Y.V.left)
    (hybase : y ≫ Y.V.hom = 𝟙 _)
    (hyfixed : y ≫ (Y.ρ σ).left = y)
    (hgeneric :
      q.fromFunctionField ≫ (fixedByι Y σ).left =
        (E.left.fromSpecStalk (genericPoint E.left) ≫ E.hom) ≫ y) :
    RationalMapIsConstantOver (E := E) (Z := FixedBy Y σ) q := by
  haveI : IsClosedImmersion (fixedByι Y σ).left := inferInstance
  let yOver : Over.mk (𝟙 (Spec (.of Omega))) ⟶ Y.V :=
    Over.homMk y (by
      change y ≫ Y.V.hom = 𝟙 _
      exact hybase)
  have hyfixedOver : yOver ≫ Y.ρ σ = yOver := by
    apply Over.OverMorphism.ext
    exact hyfixed
  let zOver := fixedByLift Y σ yOver hyfixedOver
  let z : Spec (.of Omega) ⟶ (FixedBy Y σ).left := zOver.left
  have hz' : z ≫ (fixedByι Y σ).left = y :=
    congrArg Over.Hom.left (fixedByLift_ι Y σ yOver hyfixedOver)
  have hff : q.fromFunctionField =
      (E.left.fromSpecStalk (genericPoint E.left) ≫ E.hom) ≫ z := by
    apply (cancel_mono (fixedByι Y σ).left).1
    calc
      q.fromFunctionField ≫ (fixedByι Y σ).left =
          (E.left.fromSpecStalk (genericPoint E.left) ≫ E.hom) ≫ y := hgeneric
      _ = (E.left.fromSpecStalk (genericPoint E.left) ≫ E.hom) ≫
          (z ≫ (fixedByι Y σ).left) := by rw [hz']
      _ = ((E.left.fromSpecStalk (genericPoint E.left) ≫ E.hom) ≫ z) ≫
          (fixedByι Y σ).left := (Category.assoc _ _ _).symm
  unfold RationalMapIsConstantOver
  refine ⟨z, Scheme.RationalMap.eq_of_fromFunctionField_eq _ _ ?_⟩
  rw [Scheme.RationalMap.fromFunctionField_toRationalMap]
  simpa only [Scheme.PartialMap.fromSpecStalkOfMem_toPartialMap,
    Category.assoc] using hff

/-! ## Hypothesis (a) over `F` -/

section OverField

open V14SchemeModel (k)

variable (F : Type) [Field F] [Algebra k F]

/-- **Hypothesis (a) over every field over `ℚ(ζ₁₁)`.**

Every rational map over `Spec F` from a biprojective space to the `σ`-fixed
locus of the base-changed coordinate `V₁₄` is constant.  Over `k` this is
`rationalMapIsConstantOver_v14FixedBy`; this is the same statement with the
base field released, and it is what `FaithfulHeadlineOverField` names
`HypothesisAOver`. -/
public theorem hypothesisAOver : HypothesisAOver F := by
  haveI : CharZero F := BaseField.charZero_of_algebra F
  intro p q z hz
  let t : Spec (.of F) ⟶ Spec (.of k) :=
    Spec.map (CommRingCat.ofHom (algebraMap k F))
  let B : Action (Over (Spec (.of F))) V14SchemeModel.G :=
    V14SchemeModel.actionOverBaseChange F
  let Esch := BiprojectiveSpace p q F
  let L := Esch.functionField
  letI : Algebra F L := (biprojectiveGeneralBaseToFunctionField p q F).toAlgebra
  letI : Algebra k L :=
    ((biprojectiveGeneralBaseToFunctionField p q F).comp
      (algebraMap k F)).toAlgebra
  haveI : IsScalarTower k F L := IsScalarTower.of_algebraMap_eq fun _ => rfl
  haveI : CharZero L :=
    charZero_of_injective_algebraMap (FaithfulSMul.algebraMap_injective F L)
  haveI : NeZero (2 : L) := inferInstance
  haveI : IsIntegral Esch := inferInstance
  haveI : IsIntegral (Over.mk (BiprojectiveSpace.toSpec p q F)).left := by
    change IsIntegral (BiprojectiveSpace p q F)
    infer_instance
  haveI : IsSeparated B.V.hom := inferInstance
  haveI : IsClosedImmersion (fixedByι B sigma).left := inferInstance
  haveI : LocallyOfFiniteType (FixedBy B sigma).hom := by
    have hhom : (FixedBy B sigma).hom =
        (fixedByι B sigma).left ≫ B.V.hom :=
      (Over.w (fixedByι B sigma)).symm
    rw [hhom]
    infer_instance
  haveI : LocallyOfFiniteType ((FixedBy B sigma).left ↘ Spec (.of F)) := by
    change LocallyOfFiniteType (FixedBy B sigma).hom
    infer_instance
  let e0 := biprojectiveGeneralFunctionFieldEquiv p q F
  let e : MvFrac F (p + q) ≃ₐ[F] L :=
    AlgEquiv.ofRingEquiv (f := e0) fun a => by
      have hcomm := biprojectiveGeneralFunctionFieldEquiv_base p q F a
      have halg : algebraMap F L a =
          biprojectiveGeneralBaseToFunctionField p q F a := rfl
      have hres : algebraMap F (MvFrac F (p + q)) a =
          baseToResidualField ((p + q) + 1) F a := rfl
      rw [halg, hres]
      exact hcomm
  -- the generic point of the source, as a morphism over `Spec F`
  let qffOver :=
    (Scheme.RationalMap.equivFunctionFieldOver (S := Spec (.of F))).symm
      (⟨z, hz⟩ :
        {w : Scheme.RationalMap Esch (FixedBy B sigma).left //
          w.IsOver (Spec (.of F))})
  letI : z.fromFunctionField.IsOver (Spec (.of F)) := qffOver.2
  have hover :
      z.fromFunctionField ≫ (FixedBy B sigma).hom =
        Esch.fromSpecStalk (genericPoint Esch) ≫
          BiprojectiveSpace.toSpec p q F :=
    (Scheme.Hom.isOver_iff (Spec (.of F))).mp
      (show z.fromFunctionField.IsOver (Spec (.of F)) by infer_instance)
  have hSpec :
      Spec.map (CommRingCat.ofHom (algebraMap F L)) =
        Esch.fromSpecStalk (genericPoint Esch) ≫
          BiprojectiveSpace.toSpec p q F := by
    have hff : algebraMap F L =
        functionFieldBaseRingHom F Esch (BiprojectiveSpace.toSpec p q F) :=
      RingHom.ext fun a =>
        DFunLike.congr_fun (biprojectiveGeneralBaseToFunctionField_eq p q F) a
    rw [hff]
    exact SpecMap_functionFieldBaseRingHom F Esch
      (BiprojectiveSpace.toSpec p q F)
  -- the two projections out of the base change
  have hfst : ((B.ρ sigma).left ≫
        pullback.fst V14SchemeModel.actionOver.V.hom t) =
      pullback.fst V14SchemeModel.actionOver.V.hom t ≫
        (V14SchemeModel.actionOver.ρ sigma).left :=
    baseChangeAction_ρ_left_fst t V14SchemeModel.actionOver sigma
  have hcond : pullback.fst V14SchemeModel.actionOver.V.hom t ≫
      V14SchemeModel.actionOver.V.hom =
    pullback.snd V14SchemeModel.actionOver.V.hom t ≫ t := pullback.condition
  -- push the generic point into the `k`-model along `pullback.fst`
  let w0 : Spec (.of L) ⟶ pullback V14SchemeModel.actionOver.V.hom t :=
    z.fromFunctionField ≫ (fixedByι B sigma).left
  have hw0snd : w0 ≫ pullback.snd V14SchemeModel.actionOver.V.hom t =
      Spec.map (CommRingCat.ofHom (algebraMap F L)) := by
    have hι : (fixedByι B sigma).left ≫ B.V.hom = (FixedBy B sigma).hom :=
      Over.w (fixedByι B sigma)
    calc w0 ≫ pullback.snd V14SchemeModel.actionOver.V.hom t
        = z.fromFunctionField ≫ ((fixedByι B sigma).left ≫ B.V.hom) :=
          Category.assoc _ _ _
      _ = z.fromFunctionField ≫ (FixedBy B sigma).hom :=
          congrArg (z.fromFunctionField ≫ ·) hι
      _ = Spec.map (CommRingCat.ofHom (algebraMap F L)) := by
          rw [hover, hSpec]
  have hw0fixed : w0 ≫ (B.ρ sigma).left = w0 := by
    have h : (fixedByι B sigma).left ≫ (B.ρ sigma).left =
        (fixedByι B sigma).left :=
      congrArg Over.Hom.left (fixedByι_comp_action B sigma)
    calc w0 ≫ (B.ρ sigma).left
        = z.fromFunctionField ≫ ((fixedByι B sigma).left ≫ (B.ρ sigma).left) :=
          Category.assoc _ _ _
      _ = z.fromFunctionField ≫ (fixedByι B sigma).left :=
          congrArg (z.fromFunctionField ≫ ·) h
  let w : Spec (.of L) ⟶ V14SchemeModel.v14Scheme :=
    w0 ≫ pullback.fst V14SchemeModel.actionOver.V.hom t
  have hwbase : w ≫ V14SchemeModel.actionOver.V.hom =
      Spec.map (CommRingCat.ofHom (algebraMap k L)) := by
    have hstep : w ≫ V14SchemeModel.actionOver.V.hom =
        Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫ t :=
      calc w ≫ V14SchemeModel.actionOver.V.hom
          = w0 ≫ (pullback.fst V14SchemeModel.actionOver.V.hom t ≫
              V14SchemeModel.actionOver.V.hom) := Category.assoc _ _ _
        _ = w0 ≫ (pullback.snd V14SchemeModel.actionOver.V.hom t ≫ t) :=
            congrArg (w0 ≫ ·) hcond
        _ = (w0 ≫ pullback.snd V14SchemeModel.actionOver.V.hom t) ≫ t :=
            (Category.assoc _ _ _).symm
        _ = Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫ t :=
            congrArg (· ≫ t) hw0snd
    rw [hstep]
    show Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫
        Spec.map (CommRingCat.ofHom (algebraMap k F)) = _
    rw [← Spec.map_comp]
    rfl
  have hwfixed : w ≫ (V14SchemeModel.actionOver.ρ sigma).left = w :=
    calc w ≫ (V14SchemeModel.actionOver.ρ sigma).left
        = w0 ≫ (pullback.fst V14SchemeModel.actionOver.V.hom t ≫
            (V14SchemeModel.actionOver.ρ sigma).left) := Category.assoc _ _ _
      _ = w0 ≫ ((B.ρ sigma).left ≫
            pullback.fst V14SchemeModel.actionOver.V.hom t) :=
          congrArg (w0 ≫ ·) hfst.symm
      _ = (w0 ≫ (B.ρ sigma).left) ≫
            pullback.fst V14SchemeModel.actionOver.V.hom t :=
          (Category.assoc _ _ _).symm
      _ = w := congrArg (· ≫ pullback.fst V14SchemeModel.actionOver.V.hom t)
            hw0fixed
  -- the resulting `L`-point of the `k`-model, and its descent to `F`
  let p₀ : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma :=
    fixedByLift V14SchemeModel.actionOver sigma
      (Over.homMk w hwbase : v14FieldPointOver L ⟶ V14SchemeModel.actionOver.V)
      (by
        apply Over.OverMorphism.ext
        exact hwfixed)
  have hp₀ : p₀.left ≫
      (fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).left = w :=
    congrArg Over.Hom.left
      (fixedByLift_ι V14SchemeModel.actionOver sigma _ _)
  obtain ⟨y, hybase, hyfixed, hycomp⟩ :=
    v14FixedFieldPoint_descends_of_mvfrac_over F (p + q) L e p₀
  rw [hp₀] at hycomp
  -- lift the `F`-point into the base change
  let yb : Spec (.of F) ⟶ pullback V14SchemeModel.actionOver.V.hom t :=
    pullback.lift y (𝟙 _) (by rw [Category.id_comp]; exact hybase)
  have hybfst : yb ≫ pullback.fst V14SchemeModel.actionOver.V.hom t = y :=
    pullback.lift_fst _ _ _
  have hybsnd : yb ≫ pullback.snd V14SchemeModel.actionOver.V.hom t = 𝟙 _ :=
    pullback.lift_snd _ _ _
  have hybbase : yb ≫ B.V.hom = 𝟙 _ := hybsnd
  have hybfixed : yb ≫ (B.ρ sigma).left = yb := by
    apply pullback.hom_ext
    · exact (Category.assoc _ _ _).trans
        ((congrArg (yb ≫ ·) hfst).trans
          ((Category.assoc _ _ _).symm.trans
            ((congrArg (· ≫ (V14SchemeModel.actionOver.ρ sigma).left) hybfst).trans
              (hyfixed.trans hybfst.symm))))
    · exact (Category.assoc _ _ _).trans
        (congrArg (yb ≫ ·) (Over.w (B.ρ sigma)))
  -- the generic-point comparison
  have hgeneric :
      z.fromFunctionField ≫ (fixedByι B sigma).left =
        (Esch.fromSpecStalk (genericPoint Esch) ≫
          BiprojectiveSpace.toSpec p q F) ≫ yb := by
    rw [← hSpec]
    show w0 = Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫ yb
    have hrhsf : (Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫ yb) ≫
          pullback.fst V14SchemeModel.actionOver.V.hom t =
        Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫ y :=
      (Category.assoc _ _ _).trans
        (congrArg (Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫ ·) hybfst)
    have hrhss : (Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫ yb) ≫
          pullback.snd V14SchemeModel.actionOver.V.hom t =
        Spec.map (CommRingCat.ofHom (algebraMap F L)) :=
      (Category.assoc _ _ _).trans
        ((congrArg (Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫ ·) hybsnd).trans
          (Category.comp_id _))
    apply pullback.hom_ext
    · exact hycomp.trans hrhsf.symm
    · exact hw0snd.trans hrhss.symm
  exact rationalMapIsConstantOver_fixedBy_of_comp_descends_base
    (E := Over.mk (BiprojectiveSpace.toSpec p q F)) B sigma z yb hybbase
    hybfixed hgeneric

end OverField

end V14Formalization.SchemeGeometry
