import V14Formalization.SemidirectChartIntegration

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

universe u

variable {Omega : Type u} [Field Omega]

abbrev pointwiseLinearSemidirectGroup (d : ℕ) :=
  (LinearResidualField d Omega)ˣ ⋊[
    ringAutUnitsAction (LinearResidualField d Omega)]
      (LinearResidualField d Omega ≃+* LinearResidualField d Omega)

noncomputable def conjugateRingEquiv
    {K L : Type u} [CommRing K] [CommRing L]
    (e : K ≃+* L) (t : K ≃+* K) : L ≃+* L :=
  e.symm.trans (t.trans e)

private theorem conjugateRingEquiv_natural
    {K L : Type u} [CommRing K] [CommRing L]
    (e : K ≃+* L) (t : K ≃+* K) :
    (conjugateRingEquiv e t).toRingHom.comp e.toRingHom =
      e.toRingHom.comp t.toRingHom := by
  ext x
  simp [conjugateRingEquiv]

noncomputable def pointwiseSemidirectValuationEquiv
    (d : ℕ) (g : pointwiseLinearSemidirectGroup (Omega := Omega) d) :
    LinearNormalValuationRing d Omega ≃+*
      LinearNormalValuationRing d Omega :=
  xAdicSemidirectValuationEquiv (LinearResidualField d Omega) g

noncomputable def pointwiseSemidirectSourceEquiv
    (d : ℕ) {X : Scheme.{u}} [IsIntegral X]
    (eK : LinearNormalFractionField d Omega ≃+* X.functionField)
    (g : pointwiseLinearSemidirectGroup (Omega := Omega) d) :
    X.functionField ≃+* X.functionField :=
  conjugateRingEquiv eK (xAdicSemidirectRatFuncAction
    (LinearResidualField d Omega) g)

/-- Embed the residue coefficient field into a source function field through
an explicit linear-normal chart. -/
noncomputable def linearNormalCoefficientEmbedding
    (d : ℕ) {X : Scheme.{u}} [IsIntegral X]
    (eK : LinearNormalFractionField d Omega ≃+* X.functionField) :
    LinearResidualField d Omega →+* X.functionField :=
  eK.toRingHom.comp
    ((algebraMap (Polynomial (LinearResidualField d Omega))
      (LinearNormalFractionField d Omega)).comp Polynomial.C)

/-- The image of the normal parameter in an explicit source chart. -/
noncomputable def linearNormalParameterElement
    (d : ℕ) {X : Scheme.{u}} [IsIntegral X]
    (eK : LinearNormalFractionField d Omega ≃+* X.functionField) :
    X.functionField :=
  eK (algebraMap (Polynomial (LinearResidualField d Omega))
    (LinearNormalFractionField d Omega)
    (@Polynomial.X (LinearResidualField d Omega) _))

/-- The chart image of a residue coefficient times the normal parameter. -/
noncomputable def linearNormalScaledParameterElement
    (d : ℕ) {X : Scheme.{u}} [IsIntegral X]
    (eK : LinearNormalFractionField d Omega ≃+* X.functionField)
    (u : LinearResidualField d Omega) : X.functionField :=
  eK (algebraMap (Polynomial (LinearResidualField d Omega))
    (LinearNormalFractionField d Omega)
    ((Polynomial.C u : Polynomial (LinearResidualField d Omega)) *
      (@Polynomial.X (LinearResidualField d Omega) _)))

noncomputable def pointwiseSemidirectExceptionalEquiv
    (d : ℕ) {E : Scheme.{u}} [IsIntegral E]
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.functionField)
    (g : pointwiseLinearSemidirectGroup (Omega := Omega) d) :
    E.functionField ≃+* E.functionField :=
  conjugateRingEquiv eE g.right

/-- The canonical generic-stalk pullback of one over-base action
automorphism fixes the embedded base field. -/
theorem actionFunctionFieldMap_fixes_base
    {N : Type u} [Group N]
    (X : Action (Over (Spec (.of Omega))) N)
    [IsIntegral X.V.left] (n : N) :
    (Scheme.actionFunctionFieldMap X n).hom.comp
        (functionFieldBaseRingHom Omega X.V.left X.V.hom) =
      functionFieldBaseRingHom Omega X.V.left X.V.hom := by
  let q := X.V.hom.toRationalMap
  have h := Scheme.actionPrecomp_fromFunctionField_generic X n q
  rw [actionPrecomp_overStructureMap] at h
  have hq : q.fromFunctionField =
      Spec.map (CommRingCat.ofHom
        (functionFieldBaseRingHom Omega X.V.left X.V.hom)) := by
    dsimp [q]
    rw [show X.V.hom.toPartialMap.fromFunctionField =
        X.V.left.fromSpecStalk _ ≫ X.V.hom by
      exact Scheme.PartialMap.fromSpecStalkOfMem_toPartialMap
        X.V.hom (genericPoint X.V.left)]
    exact (SpecMap_functionFieldBaseRingHom
      Omega X.V.left X.V.hom).symm
  rw [hq, ← Spec.map_comp] at h
  rw [Spec.map_injective.eq_iff] at h
  exact congrArg CommRingCat.Hom.hom h.symm

/-- A single action automorphism induces a ring equivalence of the function
field.  This is intentionally pointwise; pullback is contravariant. -/
noncomputable def actionFunctionFieldEquiv
    {N : Type u} [Group N]
    (X : Action (Over (linearBase Omega)) N)
    [IsIntegral X.V.left] (n : N) :
    X.V.left.functionField ≃+* X.V.left.functionField := by
  let e : X.V.left ≅ X.V.left :=
    (Over.forget (linearBase Omega)).mapIso (X.ρAut n)
  letI : IsIso (X.ρ n).left := by
    change IsIso e.hom
    infer_instance
  letI : IsDominant (X.ρ n).left := inferInstance
  haveI : IsIso (Scheme.actionFunctionFieldMap X n) := by
    dsimp [Scheme.actionFunctionFieldMap, Scheme.Hom.functionFieldMap]
    infer_instance
  exact RingEquiv.ofBijective (Scheme.actionFunctionFieldMap X n).hom
    (ConcreteCategory.bijective_of_isIso (Scheme.actionFunctionFieldMap X n))

@[simp]
theorem actionFunctionFieldEquiv_toRingHom
    {N : Type u} [Group N]
    (X : Action (Over (linearBase Omega)) N)
    [IsIntegral X.V.left] (n : N) :
    (actionFunctionFieldEquiv X n).toRingHom =
      (Scheme.actionFunctionFieldMap X n).hom := rfl

noncomputable def residualEquivOfAction
    {N : Type u} [Group N] (d : ℕ)
    (E : Action (Over (linearBase Omega)) N) [IsIntegral E.V.left]
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.V.left.functionField)
    (n : N) :
    LinearExceptionalFunctionField d Omega ≃+*
      LinearExceptionalFunctionField d Omega :=
  conjugateRingEquiv eE.symm (actionFunctionFieldEquiv E n)

/-- Conjugating a scheme action through a residue-field chart fixes the
embedded ground field whenever the chart identifies that embedding with the
canonical function-field base map. -/
theorem residualEquivOfAction_base
    {N : Type u} [Group N] (d : ℕ)
    (E : Action (Over (linearBase Omega)) N) [IsIntegral E.V.left]
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.V.left.functionField)
    (n : N)
    (hebase : ∀ c : Omega,
      eE (baseToResidualField d Omega c) =
        functionFieldBaseRingHom Omega E.V.left E.V.hom c)
    (c : Omega) :
    residualEquivOfAction d E eE n (baseToResidualField d Omega c) =
      baseToResidualField d Omega c := by
  apply eE.injective
  rw [show residualEquivOfAction d E eE n
      (baseToResidualField d Omega c) =
        eE.symm ((actionFunctionFieldEquiv E n)
          (eE (baseToResidualField d Omega c))) by rfl]
  rw [eE.apply_symm_apply, hebase]
  have hbase := congrArg (fun f => f c)
    (actionFunctionFieldMap_fixes_base E n)
  simp only [RingHom.comp_apply] at hbase
  change (Scheme.actionFunctionFieldMap E n).hom
      ((functionFieldBaseRingHom Omega E.V.left E.V.hom) c) = _
  exact hbase

noncomputable def semidirectElementOfExceptionalAction
    {N : Type u} [Group N] (d : ℕ)
    (E : Action (Over (linearBase Omega)) N) [IsIntegral E.V.left]
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.V.left.functionField)
    (normalMultiplier : N → (LinearExceptionalFunctionField d Omega)ˣ)
    (n : N) : pointwiseLinearSemidirectGroup (Omega := Omega) d :=
  ⟨normalMultiplier n, residualEquivOfAction d E eE n⟩

theorem semidirectElementOfExceptionalAction_exceptional_field_map
    {N : Type u} [Group N] (d : ℕ)
    (E : Action (Over (linearBase Omega)) N) [IsIntegral E.V.left]
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.V.left.functionField)
    (normalMultiplier : N → (LinearExceptionalFunctionField d Omega)ˣ)
    (n : N) :
    (pointwiseSemidirectExceptionalEquiv d eE
      (semidirectElementOfExceptionalAction d E eE normalMultiplier n)).toRingHom =
        (Scheme.actionFunctionFieldMap E n).hom := by
  apply RingHom.ext
  intro x
  change eE (eE.symm ((actionFunctionFieldEquiv E n)
    (eE (eE.symm x)))) = (Scheme.actionFunctionFieldMap E n).hom x
  rw [eE.apply_symm_apply, eE.apply_symm_apply]
  exact DFunLike.congr_fun (actionFunctionFieldEquiv_toRingHom E n) x

theorem residualEquivOfAction_eq_one
    {N : Type u} [Group N] (d : ℕ)
    (E : Action (Over (linearBase Omega)) N) [IsIntegral E.V.left]
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.V.left.functionField)
    (n : N) (h : actionFunctionFieldEquiv E n = 1) :
    residualEquivOfAction d E eE n = 1 := by
  ext x
  simp [residualEquivOfAction, conjugateRingEquiv, h]

theorem semidirectElementOfExceptionalAction_right_eq_one
    {N : Type u} [Group N] (d : ℕ)
    (E : Action (Over (linearBase Omega)) N) [IsIntegral E.V.left]
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.V.left.functionField)
    (normalMultiplier : N → (LinearExceptionalFunctionField d Omega)ˣ)
    (n : N) (h : actionFunctionFieldEquiv E n = 1) :
    (semidirectElementOfExceptionalAction d E eE normalMultiplier n).right = 1 :=
  residualEquivOfAction_eq_one d E eE n h

/-- Pointwise form of the linear-normal constructor.  No group law on the
chosen ring equivalences is needed by `EquivariantNormalValuationData`. -/
noncomputable def linearNormalEquivariantDataOfChartPointwise
    {N : Type u} [Group N] (d : ℕ)
    (X E : Action (Over (linearBase Omega)) N)
    [IsIntegral X.V.left] [IsIntegral E.V.left]
    (eK : LinearNormalFractionField d Omega ≃+* X.V.left.functionField)
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.V.left.functionField)
    (generic_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartGenericHom d Omega X.V.left eK)) ≫
          linearNormalValuation_toBase d Omega =
        X.V.left.fromSpecStalk _ ≫ X.V.hom)
    (special_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartResidueHom d Omega E.V.left eE)) ≫
          linearNormalValuation_toBase d Omega =
        E.V.left.fromSpecStalk _ ≫ E.V.hom)
    (rAct : N → (LinearNormalValuationRing d Omega ≃+*
      LinearNormalValuationRing d Omega))
    (kAct : N → (X.V.left.functionField ≃+* X.V.left.functionField))
    (eAct : N → (E.V.left.functionField ≃+* E.V.left.functionField))
    (fraction_ring : ∀ n,
      (kAct n).toRingHom.comp (linearChartGenericHom d Omega X.V.left eK) =
        (linearChartGenericHom d Omega X.V.left eK).comp
          (rAct n).toRingHom)
    (residue_ring : ∀ n,
      (eAct n).toRingHom.comp (linearChartResidueHom d Omega E.V.left eE) =
        (linearChartResidueHom d Omega E.V.left eE).comp
          (rAct n).toRingHom)
    (base_ring : ∀ n,
      (rAct n).toRingHom.comp (baseToLinearNormalRing d Omega) =
        baseToLinearNormalRing d Omega)
    (source_field_map : ∀ n,
      (kAct n).toRingHom = (Scheme.actionFunctionFieldMap X n).hom)
    (exceptional_field_map : ∀ n,
      (eAct n).toRingHom = (Scheme.actionFunctionFieldMap E n).hom) :
    EquivariantNormalValuationData X E := by
  exact linearNormalEquivariantDataOfChart_of_actionFunctionFieldMap
    d Omega X E eK eE generic_toBase special_toBase rAct kAct eAct
    fraction_ring residue_ring base_ring source_field_map exceptional_field_map

private theorem pointwiseSemidirect_fraction_ring
    (d : ℕ) {X : Scheme.{u}} [IsIntegral X]
    (eK : LinearNormalFractionField d Omega ≃+* X.functionField)
    (g : pointwiseLinearSemidirectGroup (Omega := Omega) d) :
    (pointwiseSemidirectSourceEquiv d eK g).toRingHom.comp
        (linearChartGenericHom d Omega X eK) =
      (linearChartGenericHom d Omega X eK).comp
        (pointwiseSemidirectValuationEquiv d g).toRingHom := by
  let i := algebraMap (LinearNormalValuationRing d Omega)
    (LinearNormalFractionField d Omega)
  let m := xAdicSemidirectRatFuncAction (LinearResidualField d Omega) g
  let r := pointwiseSemidirectValuationEquiv d g
  have hconj :
      (pointwiseSemidirectSourceEquiv d eK g).toRingHom.comp eK.toRingHom =
        eK.toRingHom.comp m.toRingHom :=
    conjugateRingEquiv_natural eK m
  have hfrac : m.toRingHom.comp i = i.comp r.toRingHom :=
    xAdicSemidirect_fraction_ring (LinearResidualField d Omega) g
  change (pointwiseSemidirectSourceEquiv d eK g).toRingHom.comp
      (eK.toRingHom.comp i) = (eK.toRingHom.comp i).comp r.toRingHom
  rw [← RingHom.comp_assoc, hconj, RingHom.comp_assoc, hfrac,
    ← RingHom.comp_assoc]

private theorem pointwiseSemidirect_residue_ring
    (d : ℕ) {E : Scheme.{u}} [IsIntegral E]
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.functionField)
    (g : pointwiseLinearSemidirectGroup (Omega := Omega) d) :
    (pointwiseSemidirectExceptionalEquiv d eE g).toRingHom.comp
        (linearChartResidueHom d Omega E eE) =
      (linearChartResidueHom d Omega E eE).comp
        (pointwiseSemidirectValuationEquiv d g).toRingHom := by
  let rho := linearNormalResidue d Omega
  let r := pointwiseSemidirectValuationEquiv d g
  have hconj :
      (pointwiseSemidirectExceptionalEquiv d eE g).toRingHom.comp eE.toRingHom =
        eE.toRingHom.comp g.right.toRingHom :=
    conjugateRingEquiv_natural eE g.right
  have hres : g.right.toRingHom.comp rho = rho.comp r.toRingHom :=
    xAdicSemidirect_residue_ring (LinearResidualField d Omega) g
  change (pointwiseSemidirectExceptionalEquiv d eE g).toRingHom.comp
      (eE.toRingHom.comp rho) = (eE.toRingHom.comp rho).comp r.toRingHom
  rw [← RingHom.comp_assoc, hconj, RingHom.comp_assoc, hres,
    ← RingHom.comp_assoc]

private theorem linearChartGenericHom_comp_base_pointwise
    (d : ℕ) (X : Scheme.{u}) [X.Over (linearBase Omega)] [IsIntegral X]
    (eK : LinearNormalFractionField d Omega ≃+* X.functionField)
    (generic_toBase :
      Spec.map (CommRingCat.ofHom (linearChartGenericHom d Omega X eK)) ≫
          linearNormalValuation_toBase d Omega =
        X.fromSpecStalk _ ≫ X ↘ linearBase Omega) :
    (linearChartGenericHom d Omega X eK).comp
        (baseToLinearNormalRing d Omega) =
      functionFieldBaseRingHom Omega X (X ↘ linearBase Omega) := by
  have hspec :
      Spec.map (CommRingCat.ofHom
        ((linearChartGenericHom d Omega X eK).comp
          (baseToLinearNormalRing d Omega))) =
      Spec.map (CommRingCat.ofHom
        (functionFieldBaseRingHom Omega X (X ↘ linearBase Omega))) := by
    calc
      Spec.map (CommRingCat.ofHom
          ((linearChartGenericHom d Omega X eK).comp
            (baseToLinearNormalRing d Omega))) =
        Spec.map (CommRingCat.ofHom (linearChartGenericHom d Omega X eK)) ≫
          linearNormalValuation_toBase d Omega := by
            simp only [linearNormalValuation_toBase, ← Spec.map_comp]
            rfl
      _ = X.fromSpecStalk _ ≫ X ↘ linearBase Omega := generic_toBase
      _ = Spec.map (CommRingCat.ofHom
          (functionFieldBaseRingHom Omega X (X ↘ linearBase Omega))) :=
        (SpecMap_functionFieldBaseRingHom Omega X
          (X ↘ linearBase Omega)).symm
  rw [Spec.map_injective.eq_iff] at hspec
  exact congrArg CommRingCat.Hom.hom hspec

private theorem pointwiseSemidirect_base_ring
    {N : Type u} [Group N] (d : ℕ)
    (X : Action (Over (linearBase Omega)) N) [IsIntegral X.V.left]
    (eK : LinearNormalFractionField d Omega ≃+* X.V.left.functionField)
    (generic_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartGenericHom d Omega X.V.left eK)) ≫
          linearNormalValuation_toBase d Omega =
        X.V.left.fromSpecStalk _ ≫ X.V.hom)
    (n : N) (g : pointwiseLinearSemidirectGroup (Omega := Omega) d)
    (source_field_map :
      (pointwiseSemidirectSourceEquiv d eK g).toRingHom =
        (Scheme.actionFunctionFieldMap X n).hom) :
    (pointwiseSemidirectValuationEquiv d g).toRingHom.comp
        (baseToLinearNormalRing d Omega) =
      baseToLinearNormalRing d Omega := by
  let k := pointwiseSemidirectSourceEquiv d eK g
  let j := linearChartGenericHom d Omega X.V.left eK
  let bR := baseToLinearNormalRing d Omega
  let bX := functionFieldBaseRingHom Omega X.V.left X.V.hom
  have hj : j.comp bR = bX :=
    linearChartGenericHom_comp_base_pointwise d X.V.left eK generic_toBase
  have hfix : k.toRingHom.comp bX = bX := by
    rw [source_field_map]
    exact actionFunctionFieldMap_fixes_base X n
  have hfrac : k.toRingHom.comp j =
      j.comp (pointwiseSemidirectValuationEquiv d g).toRingHom :=
    pointwiseSemidirect_fraction_ring d eK g
  ext z
  apply eK.injective
  have hfrac_z := congrArg
    (fun f : LinearNormalValuationRing d Omega →+* X.V.left.functionField ↦
      f (bR z)) hfrac
  have hfix_z := congrArg (fun f : Omega →+* X.V.left.functionField ↦ f z) hfix
  have hj_z := congrArg (fun f : Omega →+* X.V.left.functionField ↦ f z) hj
  simp only [RingHom.comp_apply] at hfrac_z hfix_z hj_z
  calc
    eK (pointwiseSemidirectValuationEquiv d g (bR z) :
        LinearNormalFractionField d Omega) =
      j (pointwiseSemidirectValuationEquiv d g (bR z)) := rfl
    _ = k (j (bR z)) := hfrac_z.symm
    _ = k (bX z) := by rw [hj_z]
    _ = bX z := hfix_z
    _ = j (bR z) := hj_z.symm
    _ = eK (bR z : LinearNormalFractionField d Omega) := rfl

/-- Pointwise semidirect action constructor.  The family `a` need not satisfy
a group homomorphism law. -/
noncomputable def linearEquivariantNormalDataOfPointwiseSemidirect
    {N : Type u} [Group N] (d : ℕ)
    (X E : Action (Over (linearBase Omega)) N)
    [IsIntegral X.V.left] [IsIntegral E.V.left]
    (eK : LinearNormalFractionField d Omega ≃+* X.V.left.functionField)
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.V.left.functionField)
    (generic_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartGenericHom d Omega X.V.left eK)) ≫
          linearNormalValuation_toBase d Omega =
        X.V.left.fromSpecStalk _ ≫ X.V.hom)
    (special_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartResidueHom d Omega E.V.left eE)) ≫
          linearNormalValuation_toBase d Omega =
        E.V.left.fromSpecStalk _ ≫ E.V.hom)
    (a : N → pointwiseLinearSemidirectGroup (Omega := Omega) d)
    (source_field_map : ∀ n,
      (pointwiseSemidirectSourceEquiv d eK (a n)).toRingHom =
        (Scheme.actionFunctionFieldMap X n).hom)
    (exceptional_field_map : ∀ n,
      (pointwiseSemidirectExceptionalEquiv d eE (a n)).toRingHom =
        (Scheme.actionFunctionFieldMap E n).hom) :
    EquivariantNormalValuationData X E := by
  apply linearNormalEquivariantDataOfChartPointwise
    d X E eK eE generic_toBase special_toBase
    (fun n ↦ pointwiseSemidirectValuationEquiv d (a n))
    (fun n ↦ pointwiseSemidirectSourceEquiv d eK (a n))
    (fun n ↦ pointwiseSemidirectExceptionalEquiv d eE (a n))
  · exact fun n ↦ pointwiseSemidirect_fraction_ring d eK (a n)
  · exact fun n ↦ pointwiseSemidirect_residue_ring d eE (a n)
  · exact fun n ↦ pointwiseSemidirect_base_ring
      d X eK generic_toBase n (a n) (source_field_map n)
  · exact source_field_map
  · exact exceptional_field_map

theorem pointwiseSemidirectExceptionalEquiv_eq_one_of_right_eq_one
    (d : ℕ) {E : Scheme.{u}} [IsIntegral E]
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.functionField)
    (g : pointwiseLinearSemidirectGroup (Omega := Omega) d)
    (h : g.right = 1) :
    pointwiseSemidirectExceptionalEquiv d eE g = 1 := by
  ext x
  simp [pointwiseSemidirectExceptionalEquiv, conjugateRingEquiv, h]

theorem linearEquivariantNormalDataOfPointwiseSemidirect_exceptional_identity
    {N : Type u} [Group N] (d : ℕ)
    (X E : Action (Over (linearBase Omega)) N)
    [IsIntegral X.V.left] [IsIntegral E.V.left]
    (eK : LinearNormalFractionField d Omega ≃+* X.V.left.functionField)
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.V.left.functionField)
    (generic_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartGenericHom d Omega X.V.left eK)) ≫
          linearNormalValuation_toBase d Omega =
        X.V.left.fromSpecStalk _ ≫ X.V.hom)
    (special_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartResidueHom d Omega E.V.left eE)) ≫
          linearNormalValuation_toBase d Omega =
        E.V.left.fromSpecStalk _ ≫ E.V.hom)
    (a : N → pointwiseLinearSemidirectGroup (Omega := Omega) d)
    (source_field_map : ∀ n,
      (pointwiseSemidirectSourceEquiv d eK (a n)).toRingHom =
        (Scheme.actionFunctionFieldMap X n).hom)
    (exceptional_field_map : ∀ n,
      (pointwiseSemidirectExceptionalEquiv d eE (a n)).toRingHom =
        (Scheme.actionFunctionFieldMap E n).hom)
    (n : N) (hright : (a n).right = 1) :
    (linearEquivariantNormalDataOfPointwiseSemidirect d X E eK eE
      generic_toBase special_toBase a source_field_map
      exceptional_field_map).exceptionalFunctionFieldAction n = 𝟙 _ := by
  change Spec.map (CommRingCat.ofHom
    ((pointwiseSemidirectExceptionalEquiv d eE (a n)).toRingHom)) = 𝟙 _
  rw [pointwiseSemidirectExceptionalEquiv_eq_one_of_right_eq_one
    d eE (a n) hright]
  change Spec.map (𝟙 _) = 𝟙 _
  simp

end V14Formalization.SchemeGeometry
