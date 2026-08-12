/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.LinearAlgebra.Matrix.Swap
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.Tactic.LinearCombination
import V14Formalization.V14FixedPointSegreBridge

/-!
# Kernel lines of rank-two 3×3 matrices descend along field extension
-/

noncomputable section

open Matrix

namespace V14Formalization.KernelLineDescent

variable {K L : Type*} [Field K] [Field L] [Algebra K L]

/-- Cramer's rule for the first two rows when the top-left 2×2 block is
invertible: the kernel is the line `(-D⁻¹ b, 1)`. -/
theorem kernelLine_descends_of_topLeft_minor
    (M : Matrix (Fin 3) (Fin 3) K)
    (hmin : (M.submatrix ![0, 1] ![0, 1]).det ≠ 0)
    (v : Fin 3 → L) (hv : v ≠ 0)
    (hker : (M.map (algebraMap K L)).mulVec v = 0) :
    ∃ (v0 : Fin 3 → K) (c : L),
      v0 ≠ 0 ∧ c ≠ 0 ∧ v = c • fun i => algebraMap K L (v0 i) := by
  let D : Matrix (Fin 2) (Fin 2) K := M.submatrix ![0, 1] ![0, 1]
  let b : Fin 2 → K := ![M 0 2, M 1 2]
  let αβ : Fin 2 → K := (-D⁻¹) *ᵥ b
  let v0 : Fin 3 → K := ![αβ 0, αβ 1, 1]
  have hv0 : v0 ≠ 0 := by
    intro h0
    have := congrFun h0 (2 : Fin 3)
    simp [v0] at this
  have hrow0 := congrFun hker (0 : Fin 3)
  have hrow1 := congrFun hker (1 : Fin 3)
  have hsys : (D.map (algebraMap K L)).mulVec ![v 0, v 1] =
      - v 2 • (fun i => algebraMap K L (b i)) := by
    funext i
    fin_cases i
    · simp [Matrix.mulVec, dotProduct, Fin.sum_univ_succ, D, b,
        Pi.smul_apply, smul_eq_mul] at hrow0 ⊢
      linear_combination hrow0
    · simp [Matrix.mulVec, dotProduct, Fin.sum_univ_succ, D, b,
        Pi.smul_apply, smul_eq_mul] at hrow1 ⊢
      linear_combination hrow1
  have hDmap : (D.map (algebraMap K L)).det ≠ 0 := by
    have hmap : (D.map (algebraMap K L)).det = algebraMap K L D.det :=
      ((algebraMap K L).map_det D).symm
    rw [hmap]
    intro h0
    exact hmin
      ((map_eq_zero_iff (algebraMap K L) (algebraMap K L).injective).1 h0)
  have hv2 : v 2 ≠ 0 := by
    intro h2
    have : (D.map (algebraMap K L)).mulVec ![v 0, v 1] = 0 := by
      simpa [h2] using hsys
    have hinj := Matrix.mulVec_injective_of_isUnit
      ((Matrix.isUnit_iff_isUnit_det _).2 (isUnit_iff_ne_zero.mpr hDmap))
    have hv01 : ![v 0, v 1] = 0 := hinj.eq_iff.mp (by simpa using this)
    apply hv
    funext t
    fin_cases t
    · simpa using congrFun hv01 (0 : Fin 2)
    · simpa using congrFun hv01 (1 : Fin 2)
    · exact h2
  refine ⟨v0, v 2, hv0, hv2, ?_⟩
  have hinj := Matrix.mulVec_injective_of_isUnit
    ((Matrix.isUnit_iff_isUnit_det _).2 (isUnit_iff_ne_zero.mpr hDmap))
  have hα : ![v 0, v 1] = v 2 • (fun i => algebraMap K L (αβ i)) := by
    apply hinj.eq_iff.mp
    have hunit : IsUnit D.det := isUnit_iff_ne_zero.mpr hmin
    have hDα : D *ᵥ αβ = -b := by
      simp only [αβ]
      rw [Matrix.mulVec_mulVec, Matrix.mul_neg, Matrix.mul_nonsing_inv D hunit,
        Matrix.neg_mulVec, Matrix.one_mulVec]
    have hmapα :
        (D.map (algebraMap K L)).mulVec (fun j => algebraMap K L (αβ j)) =
          fun i => algebraMap K L ((D.mulVec αβ) i) := by
      ext i
      exact ((algebraMap K L).map_mulVec D αβ i).symm
    have hrhs :
        (D.map (algebraMap K L)).mulVec (v 2 • fun i => algebraMap K L (αβ i)) =
          -v 2 • fun i => algebraMap K L (b i) := by
      rw [Matrix.mulVec_smul, hmapα, hDα]
      ext i
      simp [Pi.smul_apply, Pi.neg_apply, map_neg, smul_eq_mul]
    rw [hsys, hrhs]
  funext t
  fin_cases t
  · simpa [v0, Pi.smul_apply, smul_eq_mul] using congrFun hα (0 : Fin 2)
  · simpa [v0, Pi.smul_apply, smul_eq_mul] using congrFun hα (1 : Fin 2)
  · simp [v0, Pi.smul_apply, smul_eq_mul]

private lemma det_topLeft (A : Matrix (Fin 3) (Fin 3) K) :
    (A.submatrix ![0, 1] ![0, 1]).det = A 0 0 * A 1 1 - A 0 1 * A 1 0 := by
  simp [Matrix.det_fin_two]

private def rowAlign (i j : Fin 3) : Matrix (Fin 3) (Fin 3) K :=
  swap K 1 (Equiv.swap 0 i j) * swap K 0 i

private def colAlign (k l : Fin 3) : Matrix (Fin 3) (Fin 3) K :=
  swap K 0 k * swap K 1 (Equiv.swap 0 k l)

private lemma swap0i_j_ne_zero {i j : Fin 3} (hij : i ≠ j) :
    Equiv.swap (0 : Fin 3) i j ≠ 0 := by
  intro h
  have : j = i := by
    simpa [Equiv.swap_apply_eq_iff, Equiv.swap_apply_left] using h
  exact hij this.symm

private lemma swap_swap_mul (i j : Fin 3) (A : Matrix (Fin 3) (Fin 3) K) :
    swap K i j * (swap K i j * A) = A := by
  rw [← mul_assoc, swap_mul_self, one_mul]

private lemma colAlign_mul_inv (k l : Fin 3) :
    colAlign (K := K) k l * (swap K 1 (Equiv.swap 0 k l) * swap K 0 k) = 1 := by
  unfold colAlign
  rw [mul_assoc, swap_swap_mul, swap_mul_self]

private lemma inv_mul_colAlign (k l : Fin 3) :
    (swap K 1 (Equiv.swap 0 k l) * swap K 0 k) * colAlign (K := K) k l = 1 := by
  unfold colAlign
  rw [mul_assoc, swap_swap_mul, swap_mul_self]

private lemma rowAlign_apply_zero (i j : Fin 3) (hij : i ≠ j)
    (A : Matrix (Fin 3) (Fin 3) K) (t : Fin 3) :
    (rowAlign (K := K) i j * A) 0 t = A i t := by
  unfold rowAlign
  rw [mul_assoc, swap_mul_of_ne (by decide : (0 : Fin 3) ≠ 1)
      (swap0i_j_ne_zero hij).symm]
  simp [swap_mul_apply_left]

private lemma rowAlign_apply_one (i j : Fin 3) (hij : i ≠ j)
    (A : Matrix (Fin 3) (Fin 3) K) (t : Fin 3) :
    (rowAlign (K := K) i j * A) 1 t = A j t := by
  unfold rowAlign
  rw [mul_assoc, swap_mul_apply_left]
  by_cases h0 : j = 0
  · subst j
    simp [swap_mul_apply_right]
  · by_cases hi : j = i
    · exact (hij hi.symm).elim
    · rw [Equiv.swap_apply_of_ne_of_ne h0 hi, swap_mul_of_ne h0 hi]

private lemma colAlign_apply_zero (k l : Fin 3) (hkl : k ≠ l)
    (A : Matrix (Fin 3) (Fin 3) K) (s : Fin 3) :
    (A * colAlign (K := K) k l) s 0 = A s k := by
  unfold colAlign
  rw [← mul_assoc, mul_swap_of_ne (by decide : (0 : Fin 3) ≠ 1)
      (swap0i_j_ne_zero hkl).symm]
  simp [mul_swap_apply_left]

private lemma colAlign_apply_one (k l : Fin 3) (hkl : k ≠ l)
    (A : Matrix (Fin 3) (Fin 3) K) (s : Fin 3) :
    (A * colAlign (K := K) k l) s 1 = A s l := by
  unfold colAlign
  rw [← mul_assoc, mul_swap_apply_left]
  by_cases h0 : l = 0
  · subst l
    simp [mul_swap_apply_right]
  · by_cases hk : l = k
    · exact (hkl hk.symm).elim
    · rw [Equiv.swap_apply_of_ne_of_ne h0 hk, mul_swap_of_ne h0 hk]

private lemma align_entries (i j k l : Fin 3) (hij : i ≠ j) (hkl : k ≠ l)
    (M : Matrix (Fin 3) (Fin 3) K) :
    (rowAlign (K := K) i j * M * colAlign (K := K) k l) 0 0 = M i k ∧
    (rowAlign (K := K) i j * M * colAlign (K := K) k l) 0 1 = M i l ∧
    (rowAlign (K := K) i j * M * colAlign (K := K) k l) 1 0 = M j k ∧
    (rowAlign (K := K) i j * M * colAlign (K := K) k l) 1 1 = M j l :=
  ⟨(colAlign_apply_zero (K := K) k l hkl (rowAlign (K := K) i j * M) 0).trans
      (rowAlign_apply_zero (K := K) i j hij M k),
    (colAlign_apply_one (K := K) k l hkl (rowAlign (K := K) i j * M) 0).trans
      (rowAlign_apply_zero (K := K) i j hij M l),
    (colAlign_apply_zero (K := K) k l hkl (rowAlign (K := K) i j * M) 1).trans
      (rowAlign_apply_one (K := K) i j hij M k),
    (colAlign_apply_one (K := K) k l hkl (rowAlign (K := K) i j * M) 1).trans
      (rowAlign_apply_one (K := K) i j hij M l)⟩

private lemma exists_nonzero_two_minor (M : Matrix (Fin 3) (Fin 3) K)
    (hM : M.rank = 2) :
    ∃ (i j k l : Fin 3), i ≠ j ∧ k ≠ l ∧
      M i k * M j l - M i l * M j k ≠ 0 := by
  have hMne : M ≠ 0 := by
    intro h0
    rw [h0, rank_zero] at hM
    exact (by decide : (2 : ℕ) ≠ 0) hM.symm
  by_contra h
  push Not at h
  have hminor : ∀ i i' k l, M i k * M i' l = M i l * M i' k := by
    intro i i' k l
    rcases eq_or_ne i i' with hi | hi
    · subst i'; ring
    rcases eq_or_ne k l with hk | hk
    · subst l; ring
    · exact sub_eq_zero.mp (h i i' k l hi hk)
  obtain ⟨a, b, -, -, hab⟩ :=
    exists_pureTensor_of_twoByTwoMinors_eq_zero M hMne hminor
  have hform : M = vecMulVec a b := by
    ext i j
    simpa [vecMulVec_apply] using hab i j
  have hr : M.rank ≤ 1 := by
    rw [hform]
    exact rank_vecMulVec_le a b
  exact Nat.not_succ_le_self 1 (hM.symm.trans_le hr)

/-- After field extension, a nonzero kernel vector of a rank-two `3×3`
matrix is a scalar multiple of a nonzero base-field kernel vector. -/
theorem kernelLine_descends_of_rank_eq_two
    (M : Matrix (Fin 3) (Fin 3) K) (hM : M.rank = 2)
    (v : Fin 3 → L) (hv : v ≠ 0)
    (hker : (M.map (algebraMap K L)).mulVec v = 0) :
    ∃ (v0 : Fin 3 → K) (c : L),
      v0 ≠ 0 ∧ c ≠ 0 ∧ v = c • fun i => algebraMap K L (v0 i) := by
  obtain ⟨i, j, k, l, hij, hkl, hmin0⟩ := exists_nonzero_two_minor M hM
  let P := rowAlign (K := K) i j
  let Q := colAlign (K := K) k l
  let Qinv := swap K 1 (Equiv.swap 0 k l) * swap K 0 k
  let M' := P * M * Q
  have hQQ : Q * Qinv = 1 := colAlign_mul_inv (K := K) k l
  have hQQinv : Qinv * Q = 1 := inv_mul_colAlign (K := K) k l
  have hent := align_entries (K := K) i j k l hij hkl M
  have hmin' : (M'.submatrix ![0, 1] ![0, 1]).det ≠ 0 := by
    rw [det_topLeft]
    dsimp [M', P, Q]
    rw [hent.1, hent.2.1, hent.2.2.1, hent.2.2.2]
    exact hmin0
  let v' : Fin 3 → L := (Qinv.map (algebraMap K L)).mulVec v
  have hQv : (Q.map (algebraMap K L)).mulVec v' = v := by
    simp only [v']
    rw [Matrix.mulVec_mulVec, ← Matrix.map_mul, hQQ]
    have : (1 : Matrix (Fin 3) (Fin 3) K).map (algebraMap K L) = 1 :=
      (algebraMap K L).mapMatrix.map_one
    rw [this, Matrix.one_mulVec]
  have hv' : v' ≠ 0 := by
    intro h0
    exact hv (by simpa [h0] using hQv.symm)
  have hker' : (M'.map (algebraMap K L)).mulVec v' = 0 := by
    have hmap : M'.map (algebraMap K L) =
        P.map (algebraMap K L) * M.map (algebraMap K L) *
          Q.map (algebraMap K L) := by
      simp [M', Matrix.map_mul]
    rw [hmap, ← Matrix.mulVec_mulVec, hQv, ← Matrix.mulVec_mulVec, hker,
      Matrix.mulVec_zero]
  obtain ⟨w0, c, hw0, hc, hw⟩ :=
    kernelLine_descends_of_topLeft_minor M' hmin' v' hv' hker'
  refine ⟨Q.mulVec w0, c, ?_, hc, ?_⟩
  · intro h0
    have : w0 = Qinv.mulVec (Q.mulVec w0) := by
      rw [Matrix.mulVec_mulVec, hQQinv, Matrix.one_mulVec]
    exact hw0 (by simpa [h0] using this)
  · rw [← hQv, hw, Matrix.mulVec_smul]
    ext t
    simp only [Pi.smul_apply, smul_eq_mul]
    congr 1
    exact ((algebraMap K L).map_mulVec Q w0 t).symm

end V14Formalization.KernelLineDescent
