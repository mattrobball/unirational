/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12ActionCoreCertificate
public import V14Formalization.D12PiecePASplit
public import V14Formalization.D12PiecePAAction

/-!
# The `(+,-)` D12 character-piece certificate

This packages the generated bounded rational-vector identity for the
zero-dimensional simultaneous character space.  Arithmetic is proved in the
entry shards imported by `D12PiecePASplit`; this module is structural only.
-/

noncomputable section

open Matrix

namespace V14Formalization.D12PiecePACertificate

open D12Certificate D12CyclotomicVec D12PieceVecBase D12PiecePAData
open D12ActionCoreCertificate

public abbrev A : Matrix (Fin 20) (Fin 10) WeilRep.K :=
  D12PieceAction.characterStack actionCore.RM actionCore.SM 1 (-1)

public abbrev K : Matrix (Fin 10) (Fin 0) WeilRep.K := 0

public abbrev Y : Matrix (Fin 0) (Fin 10) WeilRep.K := 0

public abbrev X : Matrix (Fin 10) (Fin 20) WeilRep.K := evalMatrix XVec

theorem evalMatrix_AVec_eq_A : evalMatrix AVec = A := by
  rw [D12PiecePAAction.action_matrix, eval_characterStackVec,
    evalMatrix_RMVec, evalMatrix_SMVec]
  simp only [map_one, map_neg]
  rfl

public theorem split_identity : X * A + K * Y = 1 := by
  have h := congrArg evalMatrix D12PiecePASplit.split_identity
  rw [evalMatrix_mul, evalMatrix_one, evalMatrix_AVec_eq_A] at h
  simpa using h

/-- The checked `(+,-)` simultaneous-character certificate over `WeilRep.K`. -/
@[expose] public def certificate : PieceCertificate actionCore.B actionCore.RM actionCore.SM
    1 (-1) (Fin 0) where
  A := A
  K := K
  Y := Y
  X := X
  action_kernel := fun m =>
    D12PieceAction.characterStack_mulVec_eq_zero_iff
      actionCore.RM actionCore.SM 1 (-1) m
  split_identity := split_identity
  plucker_empty := D12Certificate.plucker_empty_fin0 _

end V14Formalization.D12PiecePACertificate
