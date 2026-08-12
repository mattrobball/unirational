/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12CompoundRRow0
import V14Formalization.D12CompoundRRow1
import V14Formalization.D12CompoundRRow2
import V14Formalization.D12CompoundRRow3
import V14Formalization.D12CompoundRRow4
import V14Formalization.D12CompoundRRow5
import V14Formalization.D12CompoundRRow6
import V14Formalization.D12CompoundRRow7
import V14Formalization.D12CompoundRRow8
import V14Formalization.D12CompoundRRow9
import V14Formalization.D12CompoundRRow10
import V14Formalization.D12CompoundRRow11
import V14Formalization.D12CompoundRRow12
import V14Formalization.D12CompoundRRow13
import V14Formalization.D12CompoundRRow14
import V14Formalization.D12PolynomialRFull
import V14Formalization.GeometricV14Carrier

/-!
# The sealed rotation is the compound of the six-dimensional rotation

The generated row modules prove, one coordinate at a time, that the sealed
15-dimensional rotation matrix is the order-two compound matrix of the sealed
six-dimensional rotation, modulo the cyclotomic polynomial.  This module only
assembles those bounded certificates, evaluates them at `WeilRep.ζ`, and then
uses the structural exterior-power theorem to identify the result with the
actual geometric rotation.
-/

noncomputable section

open Matrix Polynomial exteriorPower

namespace V14Formalization.D12CompoundR

open D12PolynomialData D12PolynomialEvaluation D12U6PolynomialData
open Lambda2Coordinates

private theorem compound_sub_R_row (i j : Fin 15) :
    ∃ q : Polynomial ℚ,
      (PluckerNaturality.compound2Lex R6_poly) i j - RFull.R_poly i j =
        Phi11 * q := by
  fin_cases i
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow0.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow1.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow2.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow3.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow4.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow5.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow6.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow7.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow8.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow9.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow10.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow11.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow12.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow13.row_cert j
  · simpa [RFull.R_poly, Matrix.of_apply] using D12CompoundRRow14.row_cert j

/-- Entrywise evaluation commutes with the order-two compound construction. -/
theorem evalMatrixAt_compound2Lex
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

/-- The generated 15-dimensional rotation evaluates to the compound matrix of
the generated six-dimensional rotation. -/
theorem evalMatrixK_R_eq_compound_R6 :
    evalMatrixK RFull.R_poly =
      PluckerNaturality.compound2Lex (evalMatrixK R6_poly) := by
  apply Matrix.ext
  intro i j
  obtain ⟨q, hq⟩ := compound_sub_R_row i j
  have hq' := congrArg (evalPolyAt WeilRep.ζ) hq
  have hz :
      evalPolyAt WeilRep.ζ ((PluckerNaturality.compound2Lex R6_poly) i j) -
          evalPolyAt WeilRep.ζ (RFull.R_poly i j) = 0 := by
    simpa [map_sub, map_mul, D12U6PolynomialSeal.evalPhi11_ζ] using hq'
  calc
    evalMatrixK RFull.R_poly i j =
        evalPolyAt WeilRep.ζ (RFull.R_poly i j) := rfl
    _ = evalPolyAt WeilRep.ζ
        ((PluckerNaturality.compound2Lex R6_poly) i j) :=
      (sub_eq_zero.mp hz).symm
    _ = PluckerNaturality.compound2Lex (evalMatrixK R6_poly) i j := by
      have h := congrArg (fun M => M i j)
        (evalMatrixAt_compound2Lex WeilRep.ζ R6_poly)
      exact h

/-- The generated 15-dimensional rotation is the compound of the actual
six-dimensional Weil rotation. -/
theorem evalMatrixK_R_eq_compound_actualU6 :
    evalMatrixK RFull.R_poly =
      PluckerNaturality.compound2Lex D12U6Semantic.actualU6 := by
  rw [evalMatrixK_R_eq_compound_R6,
    D12U6PolynomialSeal.evalMatrixK_R6_eq_actualU6]

/-- The actual exterior-square rotation is structurally the compound matrix
of the actual six-dimensional Weil rotation. -/
theorem actualRot_eq_compound_actualU6 :
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

/-- The generated 15-dimensional rotation evaluates to the actual geometric
exterior-square rotation. -/
theorem evalMatrixK_R_eq_actualRot :
    evalMatrixK RFull.R_poly =
      (lambda2MatrixRepresentation.ρ
        (CentralizerN.rotGen : GeometricV14Carrier.PSL2F11) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) := by
  rw [evalMatrixK_R_eq_compound_actualU6,
    actualRot_eq_compound_actualU6]

end V14Formalization.D12CompoundR
