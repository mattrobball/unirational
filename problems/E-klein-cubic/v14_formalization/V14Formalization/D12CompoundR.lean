/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12CompoundRRow0
public import V14Formalization.D12CompoundRRow1
public import V14Formalization.D12CompoundRRow2
public import V14Formalization.D12CompoundRRow3
public import V14Formalization.D12CompoundRRow4
public import V14Formalization.D12CompoundRRow5
public import V14Formalization.D12CompoundRRow6
public import V14Formalization.D12CompoundRRow7
public import V14Formalization.D12CompoundRRow8
public import V14Formalization.D12CompoundRRow9
public import V14Formalization.D12CompoundRRow10
public import V14Formalization.D12CompoundRRow11
public import V14Formalization.D12CompoundRRow12
public import V14Formalization.D12CompoundRRow13
public import V14Formalization.D12CompoundRRow14
public import V14Formalization.D12PolynomialEvaluation
public import V14Formalization.GeometricV14Carrier

/-!
# The ambient rotation restricts along `B`

The fifteen-dimensional ambient rotation is not tabulated: it *is* the
order-two compound `compound2Lex R6_poly` of the sealed six-dimensional Weil
rotation, and `PluckerNaturality` identifies that compound with the geometric
exterior-square action structurally, for every group element.

What the generated row modules certify is the one arithmetic fact the
`ActionCore` needs and structure cannot supply: that the compound restricts
along the sparse ten-column `B`, modulo the cyclotomic polynomial.  This
module assembles those bounded certificates, evaluates them at `WeilRep.ζ`,
and transports the result to the actual geometric rotation.
-/

noncomputable section

open Matrix Polynomial exteriorPower

namespace V14Formalization.D12CompoundR

open D12PolynomialData D12PolynomialEvaluation D12U6PolynomialData
open Lambda2Coordinates

private theorem restrict_sub_row (i : Fin 15) (j : Fin 10) :
    ∃ q : Polynomial ℚ,
      ((PluckerNaturality.compound2Lex R6_poly) * B_poly) i j -
          (B_poly * RM_poly) i j = Phi11 * q := by
  fin_cases i
  · exact D12CompoundRRow0.row_cert j
  · exact D12CompoundRRow1.row_cert j
  · exact D12CompoundRRow2.row_cert j
  · exact D12CompoundRRow3.row_cert j
  · exact D12CompoundRRow4.row_cert j
  · exact D12CompoundRRow5.row_cert j
  · exact D12CompoundRRow6.row_cert j
  · exact D12CompoundRRow7.row_cert j
  · exact D12CompoundRRow8.row_cert j
  · exact D12CompoundRRow9.row_cert j
  · exact D12CompoundRRow10.row_cert j
  · exact D12CompoundRRow11.row_cert j
  · exact D12CompoundRRow12.row_cert j
  · exact D12CompoundRRow13.row_cert j
  · exact D12CompoundRRow14.row_cert j

/-- Entrywise evaluation commutes with the order-two compound construction. -/
public theorem evalMatrixAt_compound2Lex
    {S : Type*} [CommRing S] [Algebra ℚ S] (z : S)
    (A : Matrix (Fin 6) (Fin 6) (Polynomial ℚ)) :
    evalMatrixAt z (PluckerNaturality.compound2Lex A) =
      PluckerNaturality.compound2Lex (evalMatrixAt z A) := by
  apply Matrix.ext
  intro i j
  simp only [evalMatrixAt, PluckerNaturality.compound2Lex,
    Matrix.map_apply, Matrix.of_apply]
  rw [RingHom.map_det]
  rfl

/-- The compound of the sealed six-dimensional rotation restricts along `B`
after evaluation in the cyclotomic field. -/
public theorem evalMatrixK_compound_R6_mul_B_eq_B_mul_RM :
    evalMatrixK (PluckerNaturality.compound2Lex R6_poly) * evalMatrixK B_poly =
      evalMatrixK B_poly * evalMatrixK RM_poly := by
  rw [← evalMatrixAt_mul, ← evalMatrixAt_mul]
  apply Matrix.ext
  intro i j
  obtain ⟨q, hq⟩ := restrict_sub_row i j
  have hq' := congrArg (evalPolyAt WeilRep.ζ) hq
  have hz :
      evalPolyAt WeilRep.ζ
          (((PluckerNaturality.compound2Lex R6_poly) * B_poly) i j) -
        evalPolyAt WeilRep.ζ ((B_poly * RM_poly) i j) = 0 := by
    simpa [map_sub, map_mul, D12U6PolynomialSeal.evalPhi11_ζ] using hq'
  exact sub_eq_zero.mp hz

/-- The actual exterior-square rotation is structurally the compound matrix
of the actual six-dimensional Weil rotation. -/
public theorem actualRot_eq_compound_actualU6 :
    (lambda2MatrixRepresentation.ρ
        (CentralizerN.rotGen : GeometricV14Carrier.PSL2F11) :
      Matrix (Fin 15) (Fin 15) WeilRep.K) =
      PluckerNaturality.compound2Lex D12U6Semantic.actualU6 := by
  calc
    (lambda2MatrixRepresentation.ρ
        (CentralizerN.rotGen : GeometricV14Carrier.PSL2F11) :
      Matrix (Fin 15) (Fin 15) WeilRep.K) =
        LinearMap.toMatrix lambda2Basis lambda2Basis
          (GeometricV14Carrier.ambientAct
            (CentralizerN.rotGen : GeometricV14Carrier.PSL2F11)) :=
      lambda2MatrixRepresentation_coe _
    _ = LinearMap.toMatrix lambda2Basis lambda2Basis
        (exteriorPower.map 2 GeometricV14Carrier.Rlin) :=
      congrArg
        (LinearMap.toMatrix lambda2Basis lambda2Basis)
        GeometricV14Carrier.ambientAct_rotGen_eq_map_Rlin
    _ = PluckerNaturality.compound2Lex D12U6Semantic.actualU6 := by
      simpa only [GeometricV14Carrier.Rlin,
        GeometricFanoCarrier.weilLambda2, D12U6Semantic.actualU6]
        using PluckerNaturality.weilLambda2_toMatrix_eq_compound2Lex
          (CentralizerN.mkRot CentralizerN.rotPt)

/-- The generated compound rotation evaluates to the actual geometric
exterior-square rotation. -/
public theorem evalMatrixK_compound_R6_eq_actualRot :
    evalMatrixK (PluckerNaturality.compound2Lex R6_poly) =
      (lambda2MatrixRepresentation.ρ
        (CentralizerN.rotGen : GeometricV14Carrier.PSL2F11) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) := by
  rw [actualRot_eq_compound_actualU6,
    ← D12U6PolynomialSeal.evalMatrixK_R6_eq_actualU6]
  exact evalMatrixAt_compound2Lex WeilRep.ζ R6_poly

/-- The actual geometric rotation restricts along the evaluated `B`. -/
public theorem actualRot_mul_B_eq_B_mul_RM :
    (lambda2MatrixRepresentation.ρ
          (CentralizerN.rotGen : GeometricV14Carrier.PSL2F11) :
        Matrix (Fin 15) (Fin 15) WeilRep.K) * evalMatrixK B_poly =
      evalMatrixK B_poly * evalMatrixK RM_poly := by
  rw [← evalMatrixK_compound_R6_eq_actualRot]
  exact evalMatrixK_compound_R6_mul_B_eq_B_mul_RM

/-- The rotation restriction after entrywise base change from `WeilRep.K`. -/
public theorem map_actualRot_mul_B_eq_B_mul_RM
    (Ω : Type*) [CommRing Ω] [Algebra ℚ Ω] [Algebra WeilRep.K Ω]
    [IsScalarTower ℚ WeilRep.K Ω] :
    ((lambda2MatrixRepresentation.ρ
            (CentralizerN.rotGen : GeometricV14Carrier.PSL2F11) :
          Matrix (Fin 15) (Fin 15) WeilRep.K)).map (algebraMap WeilRep.K Ω) *
        (evalMatrixK B_poly).map (algebraMap WeilRep.K Ω) =
      (evalMatrixK B_poly).map (algebraMap WeilRep.K Ω) *
        (evalMatrixK RM_poly).map (algebraMap WeilRep.K Ω) := by
  rw [← Matrix.map_mul, ← Matrix.map_mul, actualRot_mul_B_eq_B_mul_RM]

end V14Formalization.D12CompoundR
