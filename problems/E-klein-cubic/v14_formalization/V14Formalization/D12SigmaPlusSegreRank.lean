/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import Mathlib.LinearAlgebra.Matrix.Adjugate
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
import V14Formalization.D12SigmaPlusSegreFplusDet
import V14Formalization.D12SigmaPlusSegreSmooth

/-!
# Rank of the plus determinantal matrix

A vanishing determinant forces rank at most two.  Rank at most one makes the
adjugate vanish; smoothness of `Fplus` then rules that case out once the
partials are identified with the adjugate contraction.
-/

noncomputable section

open Matrix
open V14Formalization.D12SigmaPlusQuadric6

namespace V14Formalization.D12SigmaPlusSegreCore

variable {K : Type*} [Field K]

theorem det_eq_zero_of_rank_lt_card
    {n : Type*} [Fintype n] [DecidableEq n]
    (A : Matrix n n K) (h : A.rank < Fintype.card n) : A.det = 0 := by
  by_contra hne
  have hunit : IsUnit A :=
    (isUnit_iff_isUnit_det A).mpr (isUnit_iff_ne_zero.mpr hne)
  exact h.not_ge (rank_of_isUnit A hunit).ge

theorem adjugate_eq_zero_of_rank_le_one
    (A : Matrix (Fin 3) (Fin 3) K) (h : A.rank ≤ 1) :
    A.adjugate = 0 := by
  ext i j
  have hB :
      (A.submatrix (Fin.succAbove j) (Fin.succAbove i)).rank ≤ 1 :=
    (rank_submatrix_le A (Fin.succAbove j) (Fin.succAbove i)).trans h
  have hdet :
      (A.submatrix (Fin.succAbove j) (Fin.succAbove i)).det = 0 :=
    det_eq_zero_of_rank_lt_card _ (lt_of_le_of_lt hB (by decide))
  rw [adjugate_fin_succ_eq_det_submatrix, hdet, mul_zero]
  simp

theorem det_add_smul_expansion {R : Type*} [CommRing R]
    (M B : Matrix (Fin 3) (Fin 3) R) (t : R) :
    det (M + t • B) =
      det M + t * ∑ i : Fin 3, ∑ j : Fin 3, adjugate M j i * B i j +
        t ^ 2 * ∑ i : Fin 3, ∑ j : Fin 3, adjugate B j i * M i j +
          t ^ 3 * det B := by
  simp [det_fin_three, adjugate_fin_three, Matrix.add_apply, Matrix.smul_apply,
    Fin.sum_univ_succ]
  ring

theorem bilinearN_add (a b : Fin 3 → Ki) :
    bilinearN (a + b) = bilinearN a + bilinearN b := by
  ext r j
  simp [bilinearN, Pi.add_apply, mul_add, Finset.sum_add_distrib]

theorem bilinearN_smul (c : Ki) (a : Fin 3 → Ki) :
    bilinearN (c • a) = c • bilinearN a := by
  ext r j
  simp [bilinearN, Pi.smul_apply, smul_eq_mul, mul_left_comm, Finset.mul_sum]

theorem eval_Fplus_add_smul (a d : Fin 3 → Ki) (t : Ki) :
    MvPolynomial.eval (a + t • d) Fplus =
      det (bilinearN a + t • bilinearN d) := by
  rw [eval_Fplus_eq_det, bilinearN_add, bilinearN_smul]

theorem rank_le_two_of_det_eq_zero
    (A : Matrix (Fin 3) (Fin 3) K) (hdet : A.det = 0) :
    A.rank ≤ 2 := by
  obtain ⟨v, hv, hkv⟩ := (exists_mulVec_eq_zero_iff (M := A)).mpr hdet
  haveI : Nontrivial (LinearMap.ker A.mulVecLin) := by
    refine ⟨⟨v, ?mem⟩, 0, ?ne⟩
    · simpa [LinearMap.mem_ker, Matrix.mulVecLin_apply] using hkv
    · intro h0
      exact hv (by simpa using congrArg Subtype.val h0)
  have hpos : 0 < Module.finrank K (LinearMap.ker A.mulVecLin) :=
    Module.finrank_pos_iff.mpr ‹_›
  have hsum := LinearMap.finrank_range_add_finrank_ker A.mulVecLin
  have hdom : Module.finrank K (Fin 3 → K) = 3 := Module.finrank_fintype_fun_eq_card K
  have : A.rank + Module.finrank K (LinearMap.ker A.mulVecLin) = 3 := by
    simpa [Matrix.rank, hdom] using hsum
  omega

theorem rank_le_two_of_Fplus
    (a : Fin 3 → Ki) (hF : MvPolynomial.eval a Fplus = 0) :
    (bilinearN a).rank ≤ 2 :=
  rank_le_two_of_det_eq_zero _ ((eval_Fplus_eq_det a).symm.trans hF)

end V14Formalization.D12SigmaPlusSegreCore
