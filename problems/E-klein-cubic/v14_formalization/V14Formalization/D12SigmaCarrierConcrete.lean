/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12SigmaCarrierBridgeRow0
public import V14Formalization.D12SigmaCarrierBridgeRow1
public import V14Formalization.D12SigmaCarrierBridgeRow2
public import V14Formalization.D12SigmaCarrierBridgeRow3
public import V14Formalization.D12SigmaCarrierBridgeRow4
public import V14Formalization.D12SigmaCarrierBridgeRow5
public import V14Formalization.D12SigmaCarrierBridgeRow6
public import V14Formalization.D12SigmaCarrierBridgeRow7
public import V14Formalization.D12SigmaCarrierBridgeRow8
public import V14Formalization.D12SigmaCarrierBridgeRow9
public import V14Formalization.D12SigmaCarrierPlusCol0
public import V14Formalization.D12SigmaCarrierPlusCol1
public import V14Formalization.D12SigmaCarrierPlusCol2
public import V14Formalization.D12SigmaCarrierPlusCol3
public import V14Formalization.D12SigmaCarrierPlusCol4
public import V14Formalization.D12SigmaCarrierPlusCol5
public import V14Formalization.D12SigmaCarrierMinusCol0
public import V14Formalization.D12SigmaCarrierMinusCol1
public import V14Formalization.D12SigmaCarrierMinusCol2
public import V14Formalization.D12SigmaCarrierMinusCol3

/-!
# Concrete sigma carriers

This module only assembles the bounded polynomial shards. All dense
cyclotomic arithmetic remains in the independently checked row and column
modules; the declarations here perform finite dispatch and structural matrix
rewriting.
-/

noncomputable section

open Matrix

namespace V14Formalization.D12SigmaCarrierConcrete

open D12PolynomialData D12PolynomialEvaluation
open D12GeneratorPolynomialCore D12GeneratorInvariance
open D12SigmaCarrier D12SigmaCarrierPolynomial

public theorem evalMatrixK_Srestricted_reduced_poly :
    evalMatrixK Srestricted_reduced_poly = SrestrictedAction := by
  rw [← evalMatrixK_Srestricted_poly]
  symm
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact D12SigmaCarrierBridgeRow0.eval_row j
  · exact D12SigmaCarrierBridgeRow1.eval_row j
  · exact D12SigmaCarrierBridgeRow2.eval_row j
  · exact D12SigmaCarrierBridgeRow3.eval_row j
  · exact D12SigmaCarrierBridgeRow4.eval_row j
  · exact D12SigmaCarrierBridgeRow5.eval_row j
  · exact D12SigmaCarrierBridgeRow6.eval_row j
  · exact D12SigmaCarrierBridgeRow7.eval_row j
  · exact D12SigmaCarrierBridgeRow8.eval_row j
  · exact D12SigmaCarrierBridgeRow9.eval_row j

public theorem plus_eigen_eval :
    evalMatrixK Srestricted_reduced_poly * evalMatrixK Kplus_poly =
      evalMatrixK Kplus_poly := by
  apply Matrix.ext
  intro i j
  fin_cases j
  · exact D12SigmaCarrierPlusCol0.eval_column WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ i
  · exact D12SigmaCarrierPlusCol1.eval_column WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ i
  · exact D12SigmaCarrierPlusCol2.eval_column WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ i
  · exact D12SigmaCarrierPlusCol3.eval_column WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ i
  · exact D12SigmaCarrierPlusCol4.eval_column WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ i
  · exact D12SigmaCarrierPlusCol5.eval_column WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ i

public theorem minus_eigen_eval :
    evalMatrixK Srestricted_reduced_poly * evalMatrixK Kminus_poly =
      -evalMatrixK Kminus_poly := by
  apply Matrix.ext
  intro i j
  simp only [Matrix.neg_apply]
  fin_cases j
  · exact D12SigmaCarrierMinusCol0.eval_column WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ i
  · exact D12SigmaCarrierMinusCol1.eval_column WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ i
  · exact D12SigmaCarrierMinusCol2.eval_column WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ i
  · exact D12SigmaCarrierMinusCol3.eval_column WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ i

private theorem plusTopRow0 (j : Fin 6) :
    (selectPlus * evalMatrixK Kplus_poly) 0 j =
      (1 : Matrix (Fin 6) (Fin 6) K) 0 j := by
  fin_cases j <;> norm_num [selectPlus, evalMatrixK, evalMatrixAt, Kplus_poly,
    Kplus_poly_row0, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply] <;> decide

private theorem plusTopRow1 (j : Fin 6) :
    (selectPlus * evalMatrixK Kplus_poly) 1 j =
      (1 : Matrix (Fin 6) (Fin 6) K) 1 j := by
  fin_cases j <;> norm_num [selectPlus, evalMatrixK, evalMatrixAt, Kplus_poly,
    Kplus_poly_row1, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply] <;> decide

private theorem plusTopRow2 (j : Fin 6) :
    (selectPlus * evalMatrixK Kplus_poly) 2 j =
      (1 : Matrix (Fin 6) (Fin 6) K) 2 j := by
  fin_cases j <;> norm_num [selectPlus, evalMatrixK, evalMatrixAt, Kplus_poly,
    Kplus_poly_row2, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply] <;> decide

private theorem plusTopRow3 (j : Fin 6) :
    (selectPlus * evalMatrixK Kplus_poly) 3 j =
      (1 : Matrix (Fin 6) (Fin 6) K) 3 j := by
  fin_cases j <;> norm_num [selectPlus, evalMatrixK, evalMatrixAt, Kplus_poly,
    Kplus_poly_row3, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply] <;> decide

private theorem plusTopRow4 (j : Fin 6) :
    (selectPlus * evalMatrixK Kplus_poly) 4 j =
      (1 : Matrix (Fin 6) (Fin 6) K) 4 j := by
  fin_cases j <;> norm_num [selectPlus, evalMatrixK, evalMatrixAt, Kplus_poly,
    Kplus_poly_row4, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply] <;> decide

private theorem plusTopRow5 (j : Fin 6) :
    (selectPlus * evalMatrixK Kplus_poly) 5 j =
      (1 : Matrix (Fin 6) (Fin 6) K) 5 j := by
  fin_cases j <;> norm_num [selectPlus, evalMatrixK, evalMatrixAt, Kplus_poly,
    Kplus_poly_row5, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply] <;> decide

public theorem plus_top : selectPlus * evalMatrixK Kplus_poly = 1 := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact plusTopRow0 j
  · exact plusTopRow1 j
  · exact plusTopRow2 j
  · exact plusTopRow3 j
  · exact plusTopRow4 j
  · exact plusTopRow5 j

private theorem minusTopRow0 (j : Fin 4) :
    (selectMinus * evalMatrixK Kminus_poly) 0 j =
      (1 : Matrix (Fin 4) (Fin 4) K) 0 j := by
  fin_cases j <;> norm_num [selectMinus, evalMatrixK, evalMatrixAt, Kminus_poly,
    Kminus_poly_row0, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply] <;> decide

private theorem minusTopRow1 (j : Fin 4) :
    (selectMinus * evalMatrixK Kminus_poly) 1 j =
      (1 : Matrix (Fin 4) (Fin 4) K) 1 j := by
  fin_cases j <;> norm_num [selectMinus, evalMatrixK, evalMatrixAt, Kminus_poly,
    Kminus_poly_row1, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply] <;> decide

private theorem minusTopRow2 (j : Fin 4) :
    (selectMinus * evalMatrixK Kminus_poly) 2 j =
      (1 : Matrix (Fin 4) (Fin 4) K) 2 j := by
  fin_cases j <;> norm_num [selectMinus, evalMatrixK, evalMatrixAt, Kminus_poly,
    Kminus_poly_row2, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply] <;> decide

private theorem minusTopRow3 (j : Fin 4) :
    (selectMinus * evalMatrixK Kminus_poly) 3 j =
      (1 : Matrix (Fin 4) (Fin 4) K) 3 j := by
  fin_cases j <;> norm_num [selectMinus, evalMatrixK, evalMatrixAt, Kminus_poly,
    Kminus_poly_row3, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply] <;> decide

public theorem minus_top : selectMinus * evalMatrixK Kminus_poly = 1 := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact minusTopRow0 j
  · exact minusTopRow1 j
  · exact minusTopRow2 j
  · exact minusTopRow3 j

/-- The concrete, kernel-checked plus/minus sigma carriers. -/
@[expose] public def core : D12SigmaCarrier.Core where
  Kplus := evalMatrixK Kplus_poly
  Kminus := evalMatrixK Kminus_poly
  plus_top := plus_top
  minus_top := minus_top
  plus_eigen := by
    rw [← evalMatrixK_Srestricted_reduced_poly]
    exact plus_eigen_eval
  minus_eigen := by
    rw [← evalMatrixK_Srestricted_reduced_poly]
    exact minus_eigen_eval

end V14Formalization.D12SigmaCarrierConcrete
