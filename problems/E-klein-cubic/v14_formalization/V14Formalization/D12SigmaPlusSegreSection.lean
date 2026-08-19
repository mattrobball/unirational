/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12SigmaPlusSegreData
public import V14Formalization.D12SigmaPlusSegreTinv
public import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

/-!
# Left-inverse, annihilator, and `Nz = 0 → z = H(Lz)`
-/

noncomputable section

open Matrix

namespace V14Formalization.D12SigmaPlusSegreCore

theorem H_mulVec_injective :
    Function.Injective (H.mulVec : (Fin 6 → Ki) → Fin 9 → Ki) := by
  intro u v h
  have := congrArg L.mulVec h
  simpa [Matrix.mulVec_mulVec, D12SigmaPlusSegreData.L_mul_H] using this

theorem N_mulVec_H_mulVec (u : Fin 6 → Ki) :
    N.mulVec (H.mulVec u) = 0 := by
  simp [Matrix.mulVec_mulVec, D12SigmaPlusSegreData.N_mul_H]

theorem L_mulVec_H_mulVec (u : Fin 6 → Ki) :
    L.mulVec (H.mulVec u) = u := by
  simp [Matrix.mulVec_mulVec, D12SigmaPlusSegreData.L_mul_H]

private lemma fin3_of_ge {i : Fin 9} (h : ¬ i.val < 6) : i.val - 6 < 3 := by
  have : 6 ≤ i.val := Nat.not_lt.mp h
  have : i.val < 9 := i.isLt
  omega

/-- The stacked map `T = (L; N)`. -/
def plusT : Matrix (Fin 9) (Fin 9) Ki :=
  Matrix.of fun i j =>
    if h : i.val < 6 then L ⟨i.val, h⟩ j
    else N ⟨i.val - 6, fin3_of_ge h⟩ j

/-- `T⁻¹ = (H | K)`. -/
def plusTinv : Matrix (Fin 9) (Fin 9) Ki :=
  Matrix.of fun i j =>
    if h : j.val < 6 then H i ⟨j.val, h⟩
    else K i ⟨j.val - 6, fin3_of_ge h⟩

theorem plusT_mul_plusTinv : plusT * plusTinv = 1 := by
  ext i j
  by_cases hi : i.val < 6
  · by_cases hj : j.val < 6
    · have hsum :
          (plusT * plusTinv) i j = (L * H) ⟨i.val, hi⟩ ⟨j.val, hj⟩ := by
        simp [Matrix.mul_apply, plusT, plusTinv, Matrix.of_apply, hi, hj]
      rw [hsum, D12SigmaPlusSegreData.L_mul_H]
      simp [Matrix.one_apply, Fin.ext_iff]
    · have hsum :
          (plusT * plusTinv) i j =
            (L * K) ⟨i.val, hi⟩ ⟨j.val - 6, fin3_of_ge hj⟩ := by
        simp [Matrix.mul_apply, plusT, plusTinv, Matrix.of_apply, hi, hj]
      have hj6 : 6 ≤ j.val := Nat.not_lt.mp hj
      rw [hsum, D12SigmaPlusSegreData.L_mul_K]
      simp [Matrix.zero_apply, Matrix.one_apply, Fin.ext_iff]
      omega
  · by_cases hj : j.val < 6
    · have hsum :
          (plusT * plusTinv) i j =
            (N * H) ⟨i.val - 6, fin3_of_ge hi⟩ ⟨j.val, hj⟩ := by
        simp [Matrix.mul_apply, plusT, plusTinv, Matrix.of_apply, hi, hj]
      have hi6 : 6 ≤ i.val := Nat.not_lt.mp hi
      rw [hsum, D12SigmaPlusSegreData.N_mul_H]
      simp [Matrix.zero_apply, Matrix.one_apply, Fin.ext_iff]
      omega
    · have hsum :
          (plusT * plusTinv) i j =
            (N * K) ⟨i.val - 6, fin3_of_ge hi⟩ ⟨j.val - 6, fin3_of_ge hj⟩ := by
        simp [Matrix.mul_apply, plusT, plusTinv, Matrix.of_apply, hi, hj]
      have hi6 : 6 ≤ i.val := Nat.not_lt.mp hi
      have hj6 : 6 ≤ j.val := Nat.not_lt.mp hj
      rw [hsum, D12SigmaPlusSegreData.N_mul_K]
      simp [Matrix.one_apply]
      split_ifs with h1 h2 h2
      · rfl
      · omega
      · omega
      · rfl

theorem plusTinv_mul_plusT : plusTinv * plusT = 1 :=
  mul_eq_one_comm.2 plusT_mul_plusTinv

theorem L_mulVec_sub_H_L
    (z : Fin 9 → Ki) :
    L.mulVec (z - H.mulVec (L.mulVec z)) = 0 := by
  have hHL : L.mulVec (H.mulVec (L.mulVec z)) = L.mulVec z := by
    rw [mulVec_mulVec (L.mulVec z) L H, D12SigmaPlusSegreData.L_mul_H, one_mulVec]
  rw [← mulVecLin_apply, map_sub, mulVecLin_apply, mulVecLin_apply, hHL, sub_self]

theorem N_mulVec_sub_H_L
    (z : Fin 9 → Ki) (hN : N.mulVec z = 0) :
    N.mulVec (z - H.mulVec (L.mulVec z)) = 0 := by
  have hHL : N.mulVec (H.mulVec (L.mulVec z)) = 0 := by
    rw [mulVec_mulVec (L.mulVec z) N H, D12SigmaPlusSegreData.N_mul_H, zero_mulVec]
  rw [← mulVecLin_apply, map_sub, mulVecLin_apply, mulVecLin_apply, hN, hHL, sub_self]

theorem plusT_mulVec_of_ker
    (w : Fin 9 → Ki) (hL : L.mulVec w = 0) (hN : N.mulVec w = 0) :
    plusT.mulVec w = 0 := by
  funext i
  by_cases hi : i.val < 6
  · have hw := congrFun hL ⟨i.val, hi⟩
    simp [plusT, Matrix.of_apply, hi, Matrix.mulVec] at hw ⊢
    exact hw
  · have hw := congrFun hN ⟨i.val - 6, fin3_of_ge hi⟩
    simp [plusT, Matrix.of_apply, hi, Matrix.mulVec] at hw ⊢
    exact hw

public theorem eq_H_mulVec_L_of_N_mulVec
    (z : Fin 9 → Ki) (hN : N.mulVec z = 0) :
    z = H.mulVec (L.mulVec z) := by
  let w : Fin 9 → Ki := z - H.mulVec (L.mulVec z)
  have hTw : plusT.mulVec w = 0 :=
    plusT_mulVec_of_ker w (L_mulVec_sub_H_L z) (N_mulVec_sub_H_L z hN)
  have hw : w = plusTinv.mulVec (plusT.mulVec w) := by
    rw [Matrix.mulVec_mulVec (v := w) (M := plusTinv) (N := plusT),
      plusTinv_mul_plusT, one_mulVec]
  have : w = 0 := by simpa [hTw] using hw
  exact sub_eq_zero.mp this

/-! ### Over an arbitrary field receiving `Ki`

`H`, `L`, `N`, `K` have genuinely nonzero imaginary parts, so as matrices they
exist only over a ring containing a square root of `-1`.  What does generalize
is their image under an arbitrary ring map out of `Ki`: the four block
identities `L * H = 1`, `N * H = 0`, `L * K = 0`, `N * K = 1` are matrix
identities over `Ki`, hence survive `Matrix.map`, and with them the whole
section/annihilator package.  Nothing below asks anything of `F` beyond being a
field that receives `Ki`. -/

section OverField

variable {F : Type*} [Field F] (φ : Ki →+* F)

private lemma L_map_mul_H_map_aux : (L.map φ) * (H.map φ) = 1 := by
  rw [← Matrix.map_mul, D12SigmaPlusSegreData.L_mul_H]
  exact Matrix.map_one φ (map_zero φ) (map_one φ)

private lemma N_map_mul_H_map_aux : (N.map φ) * (H.map φ) = 0 := by
  rw [← Matrix.map_mul, D12SigmaPlusSegreData.N_mul_H]
  simp [Matrix.map_zero]

private lemma plusT_map_mul_plusTinv_map :
    (plusT.map φ) * (plusTinv.map φ) = 1 := by
  rw [← Matrix.map_mul, plusT_mul_plusTinv]
  exact Matrix.map_one φ (map_zero φ) (map_one φ)

private lemma plusTinv_map_mul_plusT_map :
    (plusTinv.map φ) * (plusT.map φ) = 1 :=
  mul_eq_one_comm.2 (plusT_map_mul_plusTinv_map φ)

private lemma L_map_mulVec_sub_H_L (z : Fin 9 → F) :
    (L.map φ).mulVec (z - (H.map φ).mulVec ((L.map φ).mulVec z)) = 0 := by
  have hHL :
      (L.map φ).mulVec ((H.map φ).mulVec ((L.map φ).mulVec z)) =
        (L.map φ).mulVec z := by
    rw [mulVec_mulVec ((L.map φ).mulVec z) (L.map φ) (H.map φ),
      L_map_mul_H_map_aux φ, one_mulVec]
  rw [← mulVecLin_apply, map_sub, mulVecLin_apply, mulVecLin_apply, hHL,
    sub_self]

private lemma N_map_mulVec_sub_H_L (z : Fin 9 → F)
    (hN : (N.map φ).mulVec z = 0) :
    (N.map φ).mulVec (z - (H.map φ).mulVec ((L.map φ).mulVec z)) = 0 := by
  have hHL :
      (N.map φ).mulVec ((H.map φ).mulVec ((L.map φ).mulVec z)) = 0 := by
    rw [mulVec_mulVec ((L.map φ).mulVec z) (N.map φ) (H.map φ),
      N_map_mul_H_map_aux φ, zero_mulVec]
  rw [← mulVecLin_apply, map_sub, mulVecLin_apply, mulVecLin_apply, hN, hHL,
    sub_self]

private lemma plusT_map_mulVec_of_ker (w : Fin 9 → F)
    (hL : (L.map φ).mulVec w = 0) (hN : (N.map φ).mulVec w = 0) :
    (plusT.map φ).mulVec w = 0 := by
  funext i
  by_cases hi : i.val < 6
  · have hw := congrFun hL ⟨i.val, hi⟩
    simp [plusT, Matrix.map_apply, Matrix.of_apply, hi, Matrix.mulVec] at hw ⊢
    exact hw
  · have hw := congrFun hN ⟨i.val - 6, fin3_of_ge hi⟩
    simp [plusT, Matrix.map_apply, Matrix.of_apply, hi, Matrix.mulVec] at hw ⊢
    exact hw

/-- `N`-annihilated vectors are exactly the image of `H`, over any field
receiving `Ki`.  The `Ki`-only `eq_H_mulVec_L_of_N_mulVec` is the
`RingHom.id Ki` case. -/
public theorem eq_H_mulVec_L_of_N_mulVec_map
    (z : Fin 9 → F) (hN : (N.map φ).mulVec z = 0) :
    z = (H.map φ).mulVec ((L.map φ).mulVec z) := by
  let w : Fin 9 → F := z - (H.map φ).mulVec ((L.map φ).mulVec z)
  have hTw : (plusT.map φ).mulVec w = 0 :=
    plusT_map_mulVec_of_ker φ w (L_map_mulVec_sub_H_L φ z)
      (N_map_mulVec_sub_H_L φ z hN)
  have hw : w = (plusTinv.map φ).mulVec ((plusT.map φ).mulVec w) := by
    rw [Matrix.mulVec_mulVec (v := w) (M := plusTinv.map φ) (N := plusT.map φ),
      plusTinv_map_mul_plusT_map φ, one_mulVec]
  have : w = 0 := by simpa [hTw] using hw
  exact sub_eq_zero.mp this

end OverField

end V14Formalization.D12SigmaPlusSegreCore
