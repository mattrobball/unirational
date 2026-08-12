import V14Formalization.BlockNormalSigma
import V14Formalization.V14D12CertificateExclusion

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry
open AlgebraicGeometry GeometricV14Carrier Module

private abbrev k := V14SchemeModel.k
private abbrev G := V14SchemeModel.G

private abbrev v14FixedAction :=
  fixedByCentralizerAction V14SchemeModel.actionOver sigma

private abbrev exceptionalFor
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :=
  normalDivisorActionOver R sigma p q bp bm

private abbrev ambientFor
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :=
  ambientProjectiveActionOver R (p + q + 1)
    (plusMinusAmbientBasis R sigma sigma_isInvolution p q bp bm)

/-- For every faithful representation with chosen plus/minus coordinates, the
actual corrected normal valuation reduces the genuine scheme-level no-map
statement to rational-map constancy on its biprojective exceptional divisor. -/
theorem noEquivariantRationalMap_from_ambient_of_constancy
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma))
    (hconst : ∀ z : Scheme.RationalMap
        (exceptionalFor R p q bp bm).V.left v14FixedAction.V.left,
      z.IsOver (Spec (.of k)) →
        RationalMapIsConstantOver
          (E := (exceptionalFor R p q bp bm).V)
          (Z := v14FixedAction.V) z) :
    ¬ HasEquivariantRationalMap (ambientFor R p q bp bm)
      V14SchemeModel.actionOver := by
  let X := ambientFor R p q bp bm
  let E := exceptionalFor R p q bp bm
  let D := orderedPlusMinusEquivariantNormalDataOfCorrectedChartActual
    R sigma sigma_isInvolution p q bp bm
  apply noEquivariantRationalMap_of_normal_specialization X D
  · change D.exceptionalFunctionFieldAction (sigmaInCentralizer sigma) = 𝟙 _
    have hs := orderedPlusMinusEquivariantNormalDataOfCorrectedChartActual_sigma
      R sigma sigma_isInvolution p q bp bm
    have helem : sigmaInCentralizer sigma = sigmaCentralizer sigma :=
      Subtype.ext rfl
    rw [helem]
    exact hs
  · exact hconst

end V14Formalization.SchemeGeometry
