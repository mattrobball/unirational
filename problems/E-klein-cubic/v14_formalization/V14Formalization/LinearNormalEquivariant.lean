/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.LinearNormalValuation
public import V14Formalization.SchemeEquivariantSpecialization
public import V14Formalization.SchemeFunctionFieldPrecomp

/-!
# Equivariant linear-normal chart package

This file transports the explicit `X`-adic valuation constructed in
`LinearNormalValuation` to actual source and exceptional-divisor function
fields.  The geometric exceptional divisor is supplied as an arbitrary
integral scheme with an action; in the headline application it is
`P(V₊) × P(V₋)`, not the auxiliary rational model `P^(d-1)`.

All chart compatibilities are explicit hypotheses.  In particular, this file
does not assert that the required projective and biprojective charts have
already been constructed.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry

universe u v

/-- The chart identification transports the explicit `X`-adic inclusion to
the actual function field of the source. -/
@[expose] public def linearChartGenericHom
    (d : ℕ) (Omega : Type u) [Field Omega]
    (X : Scheme.{u}) [IsIntegral X]
    (eK : LinearNormalFractionField d Omega ≃+* X.functionField) :
    LinearNormalValuationRing d Omega →+* X.functionField :=
  eK.toRingHom.comp
    (algebraMap (LinearNormalValuationRing d Omega)
      (LinearNormalFractionField d Omega))

/-- The exceptional chart identification transports evaluation at `X = 0`
to the actual function field of the exceptional divisor. -/
@[expose] public def linearChartResidueHom
    (d : ℕ) (Omega : Type u) [Field Omega]
    (E : Scheme.{u}) [IsIntegral E]
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.functionField) :
    LinearNormalValuationRing d Omega →+* E.functionField :=
  eE.toRingHom.comp (linearNormalResidue d Omega)

/-- Transport the explicit `X`-adic valuation package across source and
exceptional function-field charts. -/
@[expose] public def linearNormalDataOfChart
    (d : ℕ) (Omega : Type u) [Field Omega]
    (X E : Scheme.{u})
    [X.Over (linearBase Omega)] [E.Over (linearBase Omega)]
    [IsIntegral X] [IsIntegral E]
    (eK : LinearNormalFractionField d Omega ≃+* X.functionField)
    (eE : LinearExceptionalFunctionField d Omega ≃+* E.functionField)
    (generic_toBase :
      Spec.map (CommRingCat.ofHom (linearChartGenericHom d Omega X eK)) ≫
          linearNormalValuation_toBase d Omega =
        X.fromSpecStalk _ ≫ X ↘ linearBase Omega)
    (special_toBase :
      Spec.map (CommRingCat.ofHom (linearChartResidueHom d Omega E eE)) ≫
          linearNormalValuation_toBase d Omega =
        E.fromSpecStalk _ ≫ E ↘ linearBase Omega) :
    NormalValuationData (linearBase Omega) X E := by
  letI : Algebra (LinearNormalValuationRing d Omega) X.functionField :=
    (linearChartGenericHom d Omega X eK).toAlgebra
  let eKa : LinearNormalFractionField d Omega ≃ₐ[LinearNormalValuationRing d Omega]
      X.functionField :=
    { eK with commutes' := fun _ ↦ rfl }
  letI : IsFractionRing (LinearNormalValuationRing d Omega) X.functionField :=
    IsFractionRing.of_algEquiv eKa
  refine
    { R := LinearNormalValuationRing d Omega
      toBase := linearNormalValuation_toBase d Omega
      generic_toBase := generic_toBase
      residue := linearChartResidueHom d Omega E eE
      residue_surjective :=
        eE.surjective.comp (linearNormalResidue_surjective d Omega)
      residue_ker := ?_
      special_toBase := special_toBase }
  exact (RingHom.ker_comp_of_injective _ eE.injective).trans
    (linearNormalResidue_ker d Omega)

public theorem spec_fraction_natural_of_ring
    {R K : Type u} [CommRing R] [CommRing K]
    (i : R →+* K) (r : R →+* R) (k : K →+* K)
    (h : k.comp i = i.comp r) :
    Spec.map (CommRingCat.ofHom k) ≫ Spec.map (CommRingCat.ofHom i) =
      Spec.map (CommRingCat.ofHom i) ≫ Spec.map (CommRingCat.ofHom r) := by
  rw [← Spec.map_comp, ← Spec.map_comp]
  rw [show CommRingCat.ofHom i ≫ CommRingCat.ofHom k =
      CommRingCat.ofHom (k.comp i) by rfl]
  rw [show CommRingCat.ofHom r ≫ CommRingCat.ofHom i =
      CommRingCat.ofHom (i.comp r) by rfl]
  rw [h]

public theorem spec_base_natural_of_ring
    {R Omega : Type u} [CommRing R] [CommRing Omega]
    (b : Omega →+* R) (r : R →+* R)
    (h : r.comp b = b) :
    Spec.map (CommRingCat.ofHom r) ≫ Spec.map (CommRingCat.ofHom b) =
      Spec.map (CommRingCat.ofHom b) := by
  rw [← Spec.map_comp]
  rw [show CommRingCat.ofHom b ≫ CommRingCat.ofHom r =
      CommRingCat.ofHom (r.comp b) by rfl]
  rw [h]

/-- Stock-limit constructor for the equivariant normal valuation from exact
source/exceptional charts and ring-level action identities.

The two `*_fromFunctionField` hypotheses are deliberately explicit until a
general stock-limit theorem for function-field pullback along a scheme
automorphism is available.  The three families of ring equivalences are only
required pointwise: `EquivariantNormalValuationData` uses one group element at
a time, and pullback on function fields is contravariant, so imposing an
unnecessary `N →* RingEquiv` structure would give the wrong orientation. -/
@[expose] public def linearNormalEquivariantDataOfChart
    (d : ℕ) (Omega : Type u) [Field Omega]
    {N : Type v} [Group N]
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
    (source_fromFunctionField : ∀ n {Z : Scheme.{u}}
      (q : X.V.left ⤏ Z),
      (actionPrecomp X n q).fromFunctionField =
        Spec.map (CommRingCat.ofHom (kAct n).toRingHom) ≫
          q.fromFunctionField)
    (exceptional_fromFunctionField : ∀ n {Z : Scheme.{u}}
      (q : E.V.left ⤏ Z),
      (actionPrecomp E n q).fromFunctionField =
        Spec.map (CommRingCat.ofHom (eAct n).toRingHom) ≫
          q.fromFunctionField) :
    EquivariantNormalValuationData X E := by
  let D := linearNormalDataOfChart d Omega X.V.left E.V.left eK eE
    generic_toBase special_toBase
  refine
    { normal := D
      ringAction := fun n ↦ Spec.map (CommRingCat.ofHom (rAct n).toRingHom)
      sourceFunctionFieldAction := fun n ↦
        Spec.map (CommRingCat.ofHom (kAct n).toRingHom)
      exceptionalFunctionFieldAction := fun n ↦
        Spec.map (CommRingCat.ofHom (eAct n).toRingHom)
      fraction_natural := fun n ↦ ?_
      residue_natural := fun n ↦ ?_
      ring_over := fun n ↦ ?_
      source_fromFunctionField := source_fromFunctionField
      exceptional_fromFunctionField := exceptional_fromFunctionField }
  · change Spec.map (CommRingCat.ofHom (kAct n).toRingHom) ≫
        Spec.map (CommRingCat.ofHom
          (linearChartGenericHom d Omega X.V.left eK)) =
      Spec.map (CommRingCat.ofHom
          (linearChartGenericHom d Omega X.V.left eK)) ≫
        Spec.map (CommRingCat.ofHom (rAct n).toRingHom)
    exact spec_fraction_natural_of_ring _ _ _ (fraction_ring n)
  · change Spec.map (CommRingCat.ofHom (eAct n).toRingHom) ≫
        Spec.map (CommRingCat.ofHom
          (linearChartResidueHom d Omega E.V.left eE)) =
      Spec.map (CommRingCat.ofHom
          (linearChartResidueHom d Omega E.V.left eE)) ≫
        Spec.map (CommRingCat.ofHom (rAct n).toRingHom)
    exact spec_fraction_natural_of_ring _ _ _ (residue_ring n)
  · change Spec.map (CommRingCat.ofHom (rAct n).toRingHom) ≫
        linearNormalValuation_toBase d Omega =
      linearNormalValuation_toBase d Omega
    exact spec_base_natural_of_ring _ _ (base_ring n)

/-- Variant of `linearNormalEquivariantDataOfChart` using the canonical
generic-stalk pullback induced by each action automorphism.  The general
function-field precomposition theorem discharges the two quantified
rational-map compatibility fields. -/
@[expose] public def linearNormalEquivariantDataOfChart_of_actionFunctionFieldMap
    (d : ℕ) (Omega : Type u) [Field Omega]
    {N : Type v} [Group N]
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
  apply linearNormalEquivariantDataOfChart d Omega X E eK eE
    generic_toBase special_toBase rAct kAct eAct fraction_ring residue_ring
    base_ring
  · intro n Z q
    rw [source_field_map n]
    exact Scheme.actionPrecomp_fromFunctionField_generic X n q
  · intro n Z q
    rw [exceptional_field_map n]
    exact Scheme.actionPrecomp_fromFunctionField_generic E n q

end SchemeGeometry
end V14Formalization
