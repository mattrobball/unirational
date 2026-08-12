import V14Formalization.PointwiseSemidirect
import V14Formalization.PlusMinusBlockMatrix

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

universe u

variable {Omega : Type u} [Field Omega]
  {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module Omega V]

abbrev correctedOrderedPlusMinusSourceAction
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    Action (Over (linearBase Omega)) (centralizer sigma) :=
  (Action.res (Over (linearBase Omega))
    (Subgroup.subtype (centralizer sigma))).obj
      (ambientProjectiveActionOver R (p + q + 1)
        (plusMinusAmbientBasis R sigma hsigma p q bp bm))

abbrev correctedOrderedPlusMinusExceptionalAction
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    Action (Over (linearBase Omega)) (centralizer sigma) :=
  normalDivisorActionOver R sigma p q bp bm

/-- Corrected headline-shaped pointwise constructor.  The chart inputs must
be the blowup-aligned coordinates
`u_i = x_i/x_0`, `T = y_0/x_0`, `v_j = y_j/y_0`; no claim is made for the
old `finSuccEquiv` chart. -/
noncomputable def orderedPlusMinusEquivariantNormalDataOfPointwiseSemidirect
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (eK : LinearNormalFractionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusSourceAction
        R sigma hsigma p q bp bm).V.left.functionField)
    (eE : LinearExceptionalFunctionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusExceptionalAction
        R sigma p q bp bm).V.left.functionField)
    (generic_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartGenericHom (p + q + 1) Omega
            (correctedOrderedPlusMinusSourceAction
              R sigma hsigma p q bp bm).V.left eK)) ≫
          linearNormalValuation_toBase (p + q + 1) Omega =
        (correctedOrderedPlusMinusSourceAction
          R sigma hsigma p q bp bm).V.left.fromSpecStalk _ ≫
          (correctedOrderedPlusMinusSourceAction
            R sigma hsigma p q bp bm).V.hom)
    (special_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartResidueHom (p + q + 1) Omega
            (correctedOrderedPlusMinusExceptionalAction
              R sigma p q bp bm).V.left eE)) ≫
          linearNormalValuation_toBase (p + q + 1) Omega =
        (correctedOrderedPlusMinusExceptionalAction
          R sigma p q bp bm).V.left.fromSpecStalk _ ≫
          (correctedOrderedPlusMinusExceptionalAction
            R sigma p q bp bm).V.hom)
    (a : centralizer sigma →
      pointwiseLinearSemidirectGroup (Omega := Omega) (p + q + 1))
    (source_field_map : ∀ n,
      (pointwiseSemidirectSourceEquiv (p + q + 1) eK (a n)).toRingHom =
        (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction
            R sigma hsigma p q bp bm) n).hom)
    (exceptional_field_map : ∀ n,
      (pointwiseSemidirectExceptionalEquiv (p + q + 1) eE (a n)).toRingHom =
        (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusExceptionalAction
            R sigma p q bp bm) n).hom) :
    EquivariantNormalValuationData
      (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm)
      (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm) :=
  linearEquivariantNormalDataOfPointwiseSemidirect (p + q + 1)
    (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm)
    (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm)
    eK eE generic_toBase special_toBase a source_field_map exceptional_field_map

/-- Choose the residual component of each semidirect element canonically
from the actual exceptional action.  This discharges the exceptional
function-field comparison definitionally; only the normal multiplier and
the corrected source chart formula remain. -/
noncomputable def orderedPlusMinusEquivariantNormalDataOfNormalMultiplier
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (eK : LinearNormalFractionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusSourceAction
        R sigma hsigma p q bp bm).V.left.functionField)
    (eE : LinearExceptionalFunctionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusExceptionalAction
        R sigma p q bp bm).V.left.functionField)
    (generic_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartGenericHom (p + q + 1) Omega
            (correctedOrderedPlusMinusSourceAction
              R sigma hsigma p q bp bm).V.left eK)) ≫
          linearNormalValuation_toBase (p + q + 1) Omega =
        (correctedOrderedPlusMinusSourceAction
          R sigma hsigma p q bp bm).V.left.fromSpecStalk _ ≫
          (correctedOrderedPlusMinusSourceAction
            R sigma hsigma p q bp bm).V.hom)
    (special_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartResidueHom (p + q + 1) Omega
            (correctedOrderedPlusMinusExceptionalAction
              R sigma p q bp bm).V.left eE)) ≫
          linearNormalValuation_toBase (p + q + 1) Omega =
        (correctedOrderedPlusMinusExceptionalAction
          R sigma p q bp bm).V.left.fromSpecStalk _ ≫
          (correctedOrderedPlusMinusExceptionalAction
            R sigma p q bp bm).V.hom)
    (normalMultiplier : centralizer sigma →
      (LinearExceptionalFunctionField (p + q + 1) Omega)ˣ)
    (source_field_map : ∀ n,
      (pointwiseSemidirectSourceEquiv (p + q + 1) eK
        (semidirectElementOfExceptionalAction (p + q + 1)
          (correctedOrderedPlusMinusExceptionalAction
            R sigma p q bp bm) eE normalMultiplier n)).toRingHom =
        (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction
            R sigma hsigma p q bp bm) n).hom) :
    EquivariantNormalValuationData
      (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm)
      (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm) :=
  orderedPlusMinusEquivariantNormalDataOfPointwiseSemidirect
    R sigma hsigma p q bp bm eK eE generic_toBase special_toBase
    (fun n ↦ semidirectElementOfExceptionalAction (p + q + 1)
      (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm)
      eE normalMultiplier n)
    source_field_map
    (semidirectElementOfExceptionalAction_exceptional_field_map
      (p + q + 1)
      (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm)
      eE normalMultiplier)

theorem orderedPlusMinusEquivariantNormalDataOfPointwiseSemidirect_sigma
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (eK : LinearNormalFractionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusSourceAction
        R sigma hsigma p q bp bm).V.left.functionField)
    (eE : LinearExceptionalFunctionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusExceptionalAction
        R sigma p q bp bm).V.left.functionField)
    (generic_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartGenericHom (p + q + 1) Omega
            (correctedOrderedPlusMinusSourceAction
              R sigma hsigma p q bp bm).V.left eK)) ≫
          linearNormalValuation_toBase (p + q + 1) Omega =
        (correctedOrderedPlusMinusSourceAction
          R sigma hsigma p q bp bm).V.left.fromSpecStalk _ ≫
          (correctedOrderedPlusMinusSourceAction
            R sigma hsigma p q bp bm).V.hom)
    (special_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartResidueHom (p + q + 1) Omega
            (correctedOrderedPlusMinusExceptionalAction
              R sigma p q bp bm).V.left eE)) ≫
          linearNormalValuation_toBase (p + q + 1) Omega =
        (correctedOrderedPlusMinusExceptionalAction
          R sigma p q bp bm).V.left.fromSpecStalk _ ≫
          (correctedOrderedPlusMinusExceptionalAction
            R sigma p q bp bm).V.hom)
    (a : centralizer sigma →
      pointwiseLinearSemidirectGroup (Omega := Omega) (p + q + 1))
    (source_field_map : ∀ n,
      (pointwiseSemidirectSourceEquiv (p + q + 1) eK (a n)).toRingHom =
        (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction
            R sigma hsigma p q bp bm) n).hom)
    (exceptional_field_map : ∀ n,
      (pointwiseSemidirectExceptionalEquiv (p + q + 1) eE (a n)).toRingHom =
        (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusExceptionalAction
            R sigma p q bp bm) n).hom)
    (hright : (a (sigmaCentralizer sigma)).right = 1) :
    (orderedPlusMinusEquivariantNormalDataOfPointwiseSemidirect
      R sigma hsigma p q bp bm eK eE generic_toBase special_toBase
      a source_field_map exceptional_field_map).exceptionalFunctionFieldAction
        (sigmaCentralizer sigma) = 𝟙 _ :=
  linearEquivariantNormalDataOfPointwiseSemidirect_exceptional_identity
    (p + q + 1)
    (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm)
    (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm)
    eK eE generic_toBase special_toBase a source_field_map exceptional_field_map
    (sigmaCentralizer sigma) hright

end V14Formalization.SchemeGeometry
