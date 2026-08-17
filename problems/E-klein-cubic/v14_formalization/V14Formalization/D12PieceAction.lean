/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12PolynomialEvaluation

/-!
# Structural simultaneous-character kernel for the D12 restriction

The numerical certificate only has to prove its splitting identities.  The
identification of the twenty-row block matrix with the simultaneous rotation
and reflection eigenspace is field-generic and proved once here.
-/

noncomputable section

open Matrix

namespace V14Formalization.D12PieceAction

/-- Vertical stack of `RM - r I` and `SM - s I`. -/
@[expose] public def characterStack {K : Type*} [Field K]
    (RM SM : Matrix (Fin 10) (Fin 10) K) (r s : K) :
    Matrix (Fin 20) (Fin 10) K :=
  Matrix.of fun i j =>
    Fin.addCases
      (fun a : Fin 10 => RM a j - if a = j then r else 0)
      (fun b : Fin 10 => SM b j - if b = j then s else 0)
      (i : Fin (10 + 10))

private theorem sum_delta_mul {K n : Type*} [Field K]
    [Fintype n] [DecidableEq n] (c : K) (m : n → K) (j : n) :
    (∑ k : n, (if j = k then c else 0) * m k) = c * m j := by
  rw [Finset.sum_eq_single j] <;> intros <;> simp_all [eq_comm]

theorem characterStack_row_rot {K : Type*} [Field K]
    (RM SM : Matrix (Fin 10) (Fin 10) K) (r s : K)
    (m : Fin 10 → K) (j : Fin 10) :
    (characterStack RM SM r s).mulVec m (Fin.castAdd 10 j) =
      RM.mulVec m j - r * m j := by
  dsimp [characterStack, Matrix.mulVec, dotProduct]
  simp only [Fin.addCases_left, sub_mul, Finset.sum_sub_distrib]
  rw [sum_delta_mul]

theorem characterStack_row_refl {K : Type*} [Field K]
    (RM SM : Matrix (Fin 10) (Fin 10) K) (r s : K)
    (m : Fin 10 → K) (j : Fin 10) :
    (characterStack RM SM r s).mulVec m (Fin.natAdd 10 j) =
      SM.mulVec m j - s * m j := by
  dsimp [characterStack, Matrix.mulVec, dotProduct]
  simp only [Fin.addCases_right, sub_mul, Finset.sum_sub_distrib]
  rw [sum_delta_mul]

private theorem castAdd_eq (i : Fin (10 + 10)) (hi : i.val < 10) :
    i = Fin.castAdd 10 ⟨i.val, hi⟩ := by
  ext
  rfl

private theorem natAdd_eq (i : Fin (10 + 10)) (hi : 10 ≤ i.val) :
    i = Fin.natAdd 10
      ⟨i.val - 10, Nat.sub_lt_left_of_lt_add hi i.isLt⟩ := by
  ext
  change i.val = 10 + (i.val - 10)
  exact (Nat.add_sub_of_le hi).symm

public theorem characterStack_mulVec_eq_zero_iff {K : Type*} [Field K]
    (RM SM : Matrix (Fin 10) (Fin 10) K) (r s : K)
    (m : Fin 10 → K) :
    (characterStack RM SM r s).mulVec m = 0 ↔
      RM.mulVec m = r • m ∧ SM.mulVec m = s • m := by
  constructor
  · intro hzero
    constructor
    · funext j
      have hrow := congrFun hzero (Fin.castAdd 10 j)
      rw [characterStack_row_rot] at hrow
      simpa [Pi.smul_apply, smul_eq_mul] using sub_eq_zero.mp hrow
    · funext j
      have hrow := congrFun hzero (Fin.natAdd 10 j)
      rw [characterStack_row_refl] at hrow
      simpa [Pi.smul_apply, smul_eq_mul] using sub_eq_zero.mp hrow
  · rintro ⟨hR, hS⟩
    funext i
    by_cases hi : i.val < 10
    · rw [castAdd_eq i hi, characterStack_row_rot]
      have h := congrFun hR ⟨i.val, hi⟩
      simpa [Pi.smul_apply, smul_eq_mul, h]
    · have hi' : 10 ≤ i.val := Nat.le_of_not_lt hi
      rw [natAdd_eq i hi', characterStack_row_refl]
      have h := congrFun hS
        ⟨i.val - 10, Nat.sub_lt_left_of_lt_add hi' i.isLt⟩
      simpa [Pi.smul_apply, smul_eq_mul, h]

end V14Formalization.D12PieceAction
