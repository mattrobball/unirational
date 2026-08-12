/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12CompoundFRow0
import V14Formalization.D12CompoundFRow1
import V14Formalization.D12CompoundFRow2
import V14Formalization.D12CompoundFRow3
import V14Formalization.D12CompoundFRow4
import V14Formalization.D12CompoundFRow5
import V14Formalization.D12CompoundFRow6
import V14Formalization.D12CompoundFRow7
import V14Formalization.D12CompoundFRow8
import V14Formalization.D12CompoundFRow9
import V14Formalization.D12CompoundFRow10
import V14Formalization.D12CompoundFRow11
import V14Formalization.D12CompoundFRow12
import V14Formalization.D12CompoundFRow13
import V14Formalization.D12CompoundFRow14
import V14Formalization.D12PolynomialFFull
import V14Formalization.GeometricV14Carrier

/-!
# The sealed reflection is the compound of the six-dimensional reflection

The generated row modules prove, coordinate by coordinate, that the sealed
15-dimensional reflection matrix is the order-two compound matrix of the
sealed six-dimensional reflection, modulo the cyclotomic polynomial.  This
module assembles and evaluates those bounded certificates and identifies the
result with the actual geometric reflection.
-/

noncomputable section

open Matrix Polynomial exteriorPower

namespace V14Formalization.D12CompoundF

open D12PolynomialData D12PolynomialEvaluation D12F6PolynomialData
open Lambda2Coordinates

private theorem compound_sub_F_row (i j : Fin 15) :
    ∃ q : Polynomial ℚ,
      (PluckerNaturality.compound2Lex F6_poly) i j - FFull.F_poly i j =
        Phi11 * q := by
  fin_cases i
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow0.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow1.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow2.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow3.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow4.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow5.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow6.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow7.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow8.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow9.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow10.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow11.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow12.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow13.row_cert j
  · simpa [FFull.F_poly, Matrix.of_apply] using D12CompoundFRow14.row_cert j

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

/-- The generated 15-dimensional reflection evaluates to the compound matrix
of the generated six-dimensional reflection. -/
theorem evalMatrixK_F_eq_compound_F6 :
    evalMatrixK FFull.F_poly =
      PluckerNaturality.compound2Lex (evalMatrixK F6_poly) := by
  apply Matrix.ext
  intro i j
  obtain ⟨q, hq⟩ := compound_sub_F_row i j
  have hq' := congrArg (evalPolyAt WeilRep.ζ) hq
  have hz :
      evalPolyAt WeilRep.ζ ((PluckerNaturality.compound2Lex F6_poly) i j) -
          evalPolyAt WeilRep.ζ (FFull.F_poly i j) = 0 := by
    simpa [map_sub, map_mul, D12F6PolynomialSeal.evalPhi11_ζ] using hq'
  calc
    evalMatrixK FFull.F_poly i j =
        evalPolyAt WeilRep.ζ (FFull.F_poly i j) := rfl
    _ = evalPolyAt WeilRep.ζ
        ((PluckerNaturality.compound2Lex F6_poly) i j) :=
      (sub_eq_zero.mp hz).symm
    _ = PluckerNaturality.compound2Lex (evalMatrixK F6_poly) i j := by
      have h := congrArg (fun M => M i j)
        (evalMatrixAt_compound2Lex WeilRep.ζ F6_poly)
      exact h

/-- The generated 15-dimensional reflection is the compound of the actual
six-dimensional Weil reflection. -/
theorem evalMatrixK_F_eq_compound_actualF6 :
    evalMatrixK FFull.F_poly =
      PluckerNaturality.compound2Lex D12F6Semantic.actualF6 := by
  rw [evalMatrixK_F_eq_compound_F6,
    D12F6PolynomialSeal.evalMatrixK_F6_eq_actualF6]

/-- The actual exterior-square reflection is structurally the compound matrix
of the actual six-dimensional Weil reflection. -/
theorem actualRefl_eq_compound_actualF6 :
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

/-- The generated 15-dimensional reflection evaluates to the actual geometric
exterior-square reflection. -/
theorem evalMatrixK_F_eq_actualRefl :
    evalMatrixK FFull.F_poly =
      (lambda2MatrixRepresentation.ρ
        (CentralizerN.reflGen : GeometricV14Carrier.PSL2F11) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) := by
  rw [evalMatrixK_F_eq_compound_actualF6,
    actualRefl_eq_compound_actualF6]

end V14Formalization.D12CompoundF
