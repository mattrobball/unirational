/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12ActionCoreCertificate
public import V14Formalization.D12PiecePPSplit
public import V14Formalization.D12PiecePPAction
public import V14Formalization.D12PiecePPPlucker

/-! # The `(+,+)` D12 character-piece certificate. -/

noncomputable section

open Matrix

namespace V14Formalization.D12PiecePPCertificate

open D12Certificate D12CyclotomicVec D12PieceVecBase D12PiecePPData
open D12ActionCoreCertificate

public abbrev A : Matrix (Fin 20) (Fin 10) WeilRep.K :=
  D12PieceAction.characterStack actionCore.RM actionCore.SM 1 1

public abbrev K : Matrix (Fin 10) (Fin 2) WeilRep.K := evalMatrix KVec

public abbrev Y : Matrix (Fin 2) (Fin 10) WeilRep.K := evalMatrix YVec

public abbrev X : Matrix (Fin 10) (Fin 20) WeilRep.K := evalMatrix XVec

theorem evalMatrix_AVec_eq_A : evalMatrix AVec = A := by
  rw [D12PiecePPAction.action_matrix, eval_characterStackVec,
    evalMatrix_RMVec, evalMatrix_SMVec]
  simp only [map_one]
  rfl

public theorem split_identity : X * A + K * Y = 1 := by
  have h := congrArg evalMatrix D12PiecePPSplit.split_identity
  simp only [evalMatrix_add, evalMatrix_mul, evalMatrix_one] at h
  rw [evalMatrix_AVec_eq_A] at h
  exact h

theorem BK_eq :
    actionCore.B * K = evalMatrix D12PiecePPPluckerBase.BKVec := by
  change D12PolynomialEvaluation.evalMatrixK D12PolynomialData.B_poly *
      evalMatrix KVec = evalMatrix D12PiecePPPluckerBase.BKVec
  exact D12PiecePPPluckerBase.evalMatrix_BKVec.symm

public theorem plucker_empty :
    ∀ t : Fin 2 → WeilRep.K,
      (∀ q : Fin 15, pluckerValue ((actionCore.B * K).mulVec t) q = 0) →
        t = 0 := by
  refine plucker_empty_fin2_of_coeff (actionCore.B * K)
    D12PiecePPPlucker.C D12PiecePPPlucker.det_ne_zero ?_
  intro t
  rw [BK_eq]
  exact D12PiecePPPlucker.coefficient_identity t

/-- The checked `(+,+)` simultaneous-character certificate over `WeilRep.K`. -/
@[expose] public def certificate : PieceCertificate actionCore.B actionCore.RM actionCore.SM
    1 1 (Fin 2) where
  A := A
  K := K
  Y := Y
  X := X
  action_kernel := fun m ↦
    D12PieceAction.characterStack_mulVec_eq_zero_iff
      actionCore.RM actionCore.SM 1 1 m
  split_identity := split_identity
  plucker_empty := plucker_empty

end V14Formalization.D12PiecePPCertificate
