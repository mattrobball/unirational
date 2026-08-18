/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12ActionCoreCertificate
public import V14Formalization.D12PieceAPSplit
public import V14Formalization.D12PieceAPAction
public import V14Formalization.D12PieceAPPlucker

/-!
# The `(-,+)` D12 character-piece certificate

The generated shards prove the split identity in the bounded rational-vector
model.  `D12PieceAPPlucker` proves the normalized (factor-two corrected)
Plucker coefficient used to eliminate the remaining character line.
-/

noncomputable section

open Matrix

namespace V14Formalization.D12PieceAPCertificate

open D12Certificate D12CyclotomicVec D12PieceVecBase D12PieceAPData
open D12ActionCoreCertificate

public abbrev A : Matrix (Fin 20) (Fin 10) WeilRep.K :=
  D12PieceAction.characterStack actionCore.RM actionCore.SM (-1) 1

public abbrev K : Matrix (Fin 10) (Fin 1) WeilRep.K := evalMatrix KVec

public abbrev Y : Matrix (Fin 1) (Fin 10) WeilRep.K := evalMatrix YVec

public abbrev X : Matrix (Fin 10) (Fin 20) WeilRep.K := evalMatrix XVec

theorem evalMatrix_AVec_eq_A : evalMatrix AVec = A := by
  rw [D12PieceAPAction.action_matrix, eval_characterStackVec,
    evalMatrix_RMVec, evalMatrix_SMVec]
  simp only [map_one, map_neg]
  rfl

public theorem split_identity : X * A + K * Y = 1 := by
  have h := congrArg evalMatrix D12PieceAPSplit.split_identity
  simp only [evalMatrix_add, evalMatrix_mul, evalMatrix_one] at h
  rw [evalMatrix_AVec_eq_A] at h
  exact h

public theorem BK_eq :
    actionCore.B * K = evalMatrix D12PieceAPPlucker.BKVec := by
  change D12PolynomialEvaluation.evalMatrixK D12PolynomialData.B_poly *
      evalMatrix KVec = evalMatrix D12PieceAPPlucker.BKVec
  exact D12PieceAPPlucker.evalMatrix_BKVec.symm

public theorem plucker_empty :
    ∀ t : Fin 1 → WeilRep.K,
      (∀ q : Fin 15, pluckerValue ((actionCore.B * K).mulVec t) q = 0) →
        t = 0 := by
  refine plucker_empty_fin1_of_coeff (actionCore.B * K) 0
    (D12CyclotomicVec.eval D12PieceAPPlucker.deltaVec)
    D12PieceAPPlucker.delta_ne_zero ?_
  intro t
  rw [BK_eq]
  exact D12PieceAPPlucker.plucker_coefficient t

/-- The checked `(-,+)` simultaneous-character certificate over `WeilRep.K`. -/
@[expose] public def certificate : PieceCertificate actionCore.B actionCore.RM actionCore.SM
    (-1) 1 (Fin 1) where
  A := A
  K := K
  Y := Y
  X := X
  action_kernel := fun m ↦
    D12PieceAction.characterStack_mulVec_eq_zero_iff
      actionCore.RM actionCore.SM (-1) 1 m
  split_identity := split_identity
  plucker_empty := plucker_empty

end V14Formalization.D12PieceAPCertificate
