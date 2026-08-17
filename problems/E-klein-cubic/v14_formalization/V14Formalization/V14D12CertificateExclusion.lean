/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12CertificateK
import V14Formalization.V14D12FixedPointExclusion
import V14Formalization.SchemeModelAliases

/-!
# The concrete D12 fixed-point exclusion

This module discharges all finite matrix-certificate inputs in the
scheme-theoretic V14 exclusion theorem.  The remaining inputs are exactly the
normal-specialization datum and rational-map constancy on its exceptional
divisor.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry GeometricV14Carrier


/-- The checked four-piece certificate eliminates the matrix hypotheses from
the V14 rational-map obstruction. -/
theorem noEquivariantRationalMap_of_normal_specialization
    (X : Action (Over (Spec (.of V14SchemeModel.k))) G)
    [IsIntegral X.V.left]
    {E : Action (Over (Spec (.of V14SchemeModel.k)))
      (Subgroup.centralizer ({sigma} : Set G))}
    [IsIntegral E.V.left]
    (D : EquivariantNormalValuationData
      ((Action.res (Over (Spec (.of V14SchemeModel.k)))
        (Subgroup.subtype _)).obj X) E)
    (hsigma : D.exceptionalFunctionFieldAction (sigmaInCentralizer sigma) =
      𝟙 (Spec (.of E.V.left.functionField)))
    (hconst : ∀ q : Scheme.RationalMap E.V.left
        (fixedByCentralizerAction V14SchemeModel.actionOver sigma).V.left,
      q.IsOver (Spec (.of V14SchemeModel.k)) →
        RationalMapIsConstantOver (E := E.V)
          (Z := (fixedByCentralizerAction
            V14SchemeModel.actionOver sigma).V) q) :
    ¬ HasEquivariantRationalMap X V14SchemeModel.actionOver := by
  exact noEquivariantRationalMap_of_d12_certificate
    (E := E) X D hsigma hconst D12CertificateK.certificate
      D12CertificateK.certificate_P
      D12CertificateK.certificate_R
      D12CertificateK.certificate_F

end V14Formalization.SchemeGeometry
