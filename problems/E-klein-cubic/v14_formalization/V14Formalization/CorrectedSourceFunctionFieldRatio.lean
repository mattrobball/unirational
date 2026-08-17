module

public import V14Formalization.ProjectiveActionFunctionFieldRatio
public import V14Formalization.CorrectedOrderedConstructor
public import V14Formalization.CorrectedOrderedProjectiveChart

noncomputable section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

attribute [local instance] MvPolynomial.gradedAlgebra

universe u
variable {Omega : Type u} [Field Omega]
  {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module Omega V]

/-- The actual corrected ordered source action has the canonical projective
row-ratio formula on every ambient affine generator. -/
public theorem correctedOrderedPlusMinusSource_actionFunctionFieldMap_X
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (n : centralizer sigma) (j : Fin ((p + q) + 1)) :
    let e := projectiveGeneralFunctionFieldEquiv (p + q) Omega
    let K := FractionRing (MvPolynomial (Fin ((p + q) + 1)) Omega)
    let M := (↑(ambientMatrixRepresentation R (p + q + 1)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm) (n : G)) :
        Matrix (Fin (((p + q) + 1) + 1))
          (Fin (((p + q) + 1) + 1)) Omega)
    (Scheme.actionFunctionFieldMap
        (correctedOrderedPlusMinusSourceAction
          R sigma hsigma p q bp bm) n).hom
        (e (algebraMap (MvPolynomial (Fin ((p + q) + 1)) Omega) K
          (MvPolynomial.X j))) =
      e (algebraMap (MvPolynomial (Fin ((p + q) + 1)) Omega) K
          (ProjectiveSpace.chartDehomogenization (p + q + 1) Omega 0
            (linearSubst (p + q + 1) M
              ((0 : Fin (((p + q) + 1) + 1)).succAbove j)))) /
        e (algebraMap (MvPolynomial (Fin ((p + q) + 1)) Omega) K
          (ProjectiveSpace.chartDehomogenization (p + q + 1) Omega 0
            (linearSubst (p + q + 1) M 0))) := by
  have haction :
      Scheme.actionFunctionFieldMap
          ((Action.res (Over (linearBase Omega))
            (Subgroup.subtype (centralizer sigma))).obj
              (ambientProjectiveActionOver R (p + q + 1)
                (plusMinusAmbientBasis R sigma hsigma p q bp bm))) n =
        Scheme.actionFunctionFieldMap
          (ambientProjectiveActionOver R (p + q + 1)
            (plusMinusAmbientBasis R sigma hsigma p q bp bm)) (n : G) := by
    rfl
  rw [haction]
  change (Scheme.actionFunctionFieldMap
      (ambientProjectiveActionOver R (p + q + 1)
        (plusMinusAmbientBasis R sigma hsigma p q bp bm)) (n : G)).hom
      (projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (MvPolynomial (Fin ((p + q) + 1)) Omega)
          (FractionRing (MvPolynomial (Fin ((p + q) + 1)) Omega))
          (MvPolynomial.X j))) = _
  convert projectiveActionOver_actionFunctionFieldMap_X (p + q)
    (ambientMatrixRepresentation R (p + q + 1)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm))
    (n : G) j using 1
  rfl

/-- The actual corrected source action fixes ground-field constants in the
normal function field.  This discharges the constant part of the finite
generator comparison without unfolding the ordered birational chart. -/
public theorem correctedSource_actionFunctionFieldMap_C_base
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (n : centralizer sigma) (c : Omega) :
    let eK := correctedOrderedLinearNormalFunctionFieldEquiv
      (Omega := Omega) p q
    (Scheme.actionFunctionFieldMap
        (correctedOrderedPlusMinusSourceAction
          R sigma hsigma p q bp bm) n).hom
      (eK (algebraMap
        (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
        (LinearNormalFractionField (Nat.succ (p + q)) Omega)
        (Polynomial.C (algebraMap
          (MvPolynomial (Fin (p + q)) Omega)
          (FractionRing (MvPolynomial (Fin (p + q)) Omega))
          (MvPolynomial.C c))))) =
    eK (algebraMap
      (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
      (LinearNormalFractionField (Nat.succ (p + q)) Omega)
      (Polynomial.C (algebraMap
        (MvPolynomial (Fin (p + q)) Omega)
        (FractionRing (MvPolynomial (Fin (p + q)) Omega))
        (MvPolynomial.C c)))) := by
  let X := correctedOrderedPlusMinusSourceAction
    R sigma hsigma p q bp bm
  dsimp only
  change (Scheme.actionFunctionFieldMap X n).hom
      ((correctedOrderedLinearNormalFunctionFieldEquiv p q)
        (baseToLinearNormalFractionField (Nat.succ (p + q)) Omega c)) =
    (correctedOrderedLinearNormalFunctionFieldEquiv p q)
      (baseToLinearNormalFractionField (Nat.succ (p + q)) Omega c)
  have hbase := congrArg (fun f => f c)
    (actionFunctionFieldMap_fixes_base X n)
  simp only [RingHom.comp_apply] at hbase
  rw [correctedOrderedLinearNormalFunctionFieldEquiv_base]
  exact hbase

end V14Formalization.SchemeGeometry
