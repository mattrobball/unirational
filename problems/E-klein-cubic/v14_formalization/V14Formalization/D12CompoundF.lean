/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12CompoundFRow0
public import V14Formalization.D12CompoundFRow1
public import V14Formalization.D12CompoundFRow2
public import V14Formalization.D12CompoundFRow3
public import V14Formalization.D12CompoundFRow4
public import V14Formalization.D12CompoundFRow5
public import V14Formalization.D12CompoundFRow6
public import V14Formalization.D12CompoundFRow7
public import V14Formalization.D12CompoundFRow8
public import V14Formalization.D12CompoundFRow9
public import V14Formalization.D12CompoundFRow10
public import V14Formalization.D12CompoundFRow11
public import V14Formalization.D12CompoundFRow12
public import V14Formalization.D12CompoundFRow13
public import V14Formalization.D12CompoundFRow14
public import V14Formalization.D12PolynomialEvaluation
public import V14Formalization.D12CompoundR
public import V14Formalization.GeometricV14Carrier

/-!
# The ambient reflection restricts along `B`

The fifteen-dimensional ambient reflection is the order-two compound
`compound2Lex F6_poly` of the sealed six-dimensional Weil reflection;
`PluckerNaturality` identifies that compound with the geometric
exterior-square action structurally.  The generated row modules certify the
one arithmetic fact structure does not supply — that the compound restricts
along the sparse ten-column `B`, modulo the cyclotomic polynomial — and this
module assembles, evaluates, and transports them.
-/

noncomputable section

open Matrix Polynomial exteriorPower

namespace V14Formalization.D12CompoundF

open D12PolynomialData D12PolynomialEvaluation D12F6PolynomialData
open Lambda2Coordinates

private theorem restrict_sub_row (i : Fin 15) (j : Fin 10) :
    ∃ q : Polynomial ℚ,
      ((PluckerNaturality.compound2Lex F6_poly) * B_poly) i j -
          (B_poly * SM_poly) i j = Phi11 * q := by
  fin_cases i
  · exact D12CompoundFRow0.row_cert j
  · exact D12CompoundFRow1.row_cert j
  · exact D12CompoundFRow2.row_cert j
  · exact D12CompoundFRow3.row_cert j
  · exact D12CompoundFRow4.row_cert j
  · exact D12CompoundFRow5.row_cert j
  · exact D12CompoundFRow6.row_cert j
  · exact D12CompoundFRow7.row_cert j
  · exact D12CompoundFRow8.row_cert j
  · exact D12CompoundFRow9.row_cert j
  · exact D12CompoundFRow10.row_cert j
  · exact D12CompoundFRow11.row_cert j
  · exact D12CompoundFRow12.row_cert j
  · exact D12CompoundFRow13.row_cert j
  · exact D12CompoundFRow14.row_cert j

/-- The compound of the sealed six-dimensional reflection restricts along `B`
after evaluation in the cyclotomic field. -/
public theorem evalMatrixK_compound_F6_mul_B_eq_B_mul_SM :
    evalMatrixK (PluckerNaturality.compound2Lex F6_poly) * evalMatrixK B_poly =
      evalMatrixK B_poly * evalMatrixK SM_poly := by
  rw [← evalMatrixAt_mul, ← evalMatrixAt_mul]
  apply Matrix.ext
  intro i j
  obtain ⟨q, hq⟩ := restrict_sub_row i j
  have hq' := congrArg (evalPolyAt (WeilRep.ζ : WeilRep.K)) hq
  have hz :
      evalPolyAt (WeilRep.ζ : WeilRep.K)
          (((PluckerNaturality.compound2Lex F6_poly) * B_poly) i j) -
        evalPolyAt WeilRep.ζ ((B_poly * SM_poly) i j) = 0 := by
    simpa [map_sub, map_mul, D12U6PolynomialSeal.evalPhi11_ζ] using hq'
  exact sub_eq_zero.mp hz

/-- The actual exterior-square reflection is structurally the compound matrix
of the actual six-dimensional Weil reflection. -/
public theorem actualRefl_eq_compound_actualF6 :
    (lambda2MatrixRepresentation.ρ
        (CentralizerN.reflGen : GeometricV14Carrier.PSL2F11) :
      Matrix (Fin 15) (Fin 15) WeilRep.K) =
      PluckerNaturality.compound2Lex D12F6Semantic.actualF6 := by
  calc
    (lambda2MatrixRepresentation.ρ
        (CentralizerN.reflGen : GeometricV14Carrier.PSL2F11) :
      Matrix (Fin 15) (Fin 15) WeilRep.K) =
        LinearMap.toMatrix lambda2Basis lambda2Basis
          (GeometricV14Carrier.ambientAct
            (CentralizerN.reflGen : GeometricV14Carrier.PSL2F11)) :=
      lambda2MatrixRepresentation_coe _
    _ = LinearMap.toMatrix lambda2Basis lambda2Basis
        (GeometricFanoCarrier.weilLambda2
          (CentralizerN.mkRefl CentralizerN.reflPt)) := by
      congr 1
    _ = PluckerNaturality.compound2Lex D12F6Semantic.actualF6 := by
      simpa only [D12F6Semantic.actualF6] using
        PluckerNaturality.weilLambda2_toMatrix_eq_compound2Lex
          (CentralizerN.mkRefl CentralizerN.reflPt)

/-- The generated compound reflection evaluates to the actual geometric
exterior-square reflection. -/
public theorem evalMatrixK_compound_F6_eq_actualRefl :
    evalMatrixK (PluckerNaturality.compound2Lex F6_poly) =
      (lambda2MatrixRepresentation.ρ
        (CentralizerN.reflGen : GeometricV14Carrier.PSL2F11) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) := by
  rw [actualRefl_eq_compound_actualF6,
    ← D12F6PolynomialSeal.evalMatrixK_F6_eq_actualF6]
  exact D12CompoundR.evalMatrixAt_compound2Lex WeilRep.ζ F6_poly

/-- The actual geometric reflection restricts along the evaluated `B`. -/
public theorem actualRefl_mul_B_eq_B_mul_SM :
    (lambda2MatrixRepresentation.ρ
          (CentralizerN.reflGen : GeometricV14Carrier.PSL2F11) :
        Matrix (Fin 15) (Fin 15) WeilRep.K) * evalMatrixK B_poly =
      evalMatrixK B_poly * evalMatrixK SM_poly := by
  rw [← evalMatrixK_compound_F6_eq_actualRefl]
  exact evalMatrixK_compound_F6_mul_B_eq_B_mul_SM

/-- The reflection restriction after entrywise base change from `WeilRep.K`. -/
public theorem map_actualRefl_mul_B_eq_B_mul_SM
    (Ω : Type*) [CommRing Ω] [Algebra ℚ Ω] [Algebra WeilRep.K Ω]
    [IsScalarTower ℚ WeilRep.K Ω] :
    ((lambda2MatrixRepresentation.ρ
            (CentralizerN.reflGen : GeometricV14Carrier.PSL2F11) :
          Matrix (Fin 15) (Fin 15) WeilRep.K)).map (algebraMap WeilRep.K Ω) *
        (evalMatrixK B_poly).map (algebraMap WeilRep.K Ω) =
      (evalMatrixK B_poly).map (algebraMap WeilRep.K Ω) *
        (evalMatrixK SM_poly).map (algebraMap WeilRep.K Ω) := by
  rw [← Matrix.map_mul, ← Matrix.map_mul, actualRefl_mul_B_eq_B_mul_SM]

end V14Formalization.D12CompoundF
