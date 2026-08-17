/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12SigmaPlusSegreCore
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusQuadric6
public import V14Formalization.V14FixedPointSegreBridge

/-!
# Point-level Segre geometry of the plus carrier
-/

noncomputable section

open Matrix
open V14Formalization.D12SigmaPlusQuadric6

namespace V14Formalization.D12SigmaPlusSegreCore

@[expose] public def Hrow (p : Fin 9) : Fin 6 → Ki := fun j => H p j

/-- `2 × 2` minor of `reshape(H u)` as a quadratic coefficient vector. -/
@[expose] public def minorCoeffsH (s : Fin 9) : Fin 21 → Ki :=
  let p := minorOrder s
  bilinearCoeffs (Hrow (crossIndex p.1 p.2.2.1))
      (Hrow (crossIndex p.2.1 p.2.2.2)) -
    bilinearCoeffs (Hrow (crossIndex p.1 p.2.2.2))
      (Hrow (crossIndex p.2.1 p.2.2.1))

theorem H_mulVec_row (u : Fin 6 → Ki) (p : Fin 9) :
    H.mulVec u p = dotProduct (Hrow p) u := rfl

theorem reshapeMinor_H_mulVec (u : Fin 6 → Ki) (s : Fin 9) :
    reshapeMinor (H.mulVec u) s = quadValue (minorCoeffsH s) u := by
  fin_cases s <;>
    simp [reshapeMinor, minorCoeffsH, minorOrder, reshape3_apply,
      H_mulVec_row, quadValue_sub, quadValue_bilinearCoeffs, crossIndex]

/-- The three bilinear equations cut out by `N`, as a `3 × 3` matrix in the
first Segre factor. -/
@[expose] public def bilinearN (a : Fin 3 → Ki) : Matrix (Fin 3) (Fin 3) Ki :=
  fun r j => ∑ i : Fin 3, N r (crossIndex i j) * a i

@[expose] public def segrVec (a b : Fin 3 → Ki) : Fin 9 → Ki :=
  fun p =>
    a ⟨p.val / 3, Nat.div_lt_of_lt_mul (by
      have := p.isLt
      omega)⟩ *
    b ⟨p.val % 3, Nat.mod_lt _ (by decide)⟩

public theorem N_mulVec_segrVec (a b : Fin 3 → Ki) :
    N.mulVec (segrVec a b) = (bilinearN a).mulVec b := by
  funext r
  simp [Matrix.mulVec, bilinearN, segrVec, dotProduct, Fin.sum_univ_succ,
    crossIndex]
  ring

theorem segrVec_ne_zero {a b : Fin 3 → Ki} (ha : a ≠ 0) (hb : b ≠ 0) :
    segrVec a b ≠ 0 := by
  intro hz
  obtain ⟨i, hi⟩ : ∃ i, a i ≠ 0 := by
    by_contra h; push Not at h; exact ha (funext h)
  obtain ⟨j, hj⟩ : ∃ j, b j ≠ 0 := by
    by_contra h; push Not at h; exact hb (funext h)
  have h0 : segrVec a b (crossIndex i j) = 0 := congrFun hz _
  have hdiv : (3 * i.val + j.val) / 3 = i.val := by
    rw [Nat.add_comm, Nat.add_mul_div_left j.val i.val (by decide),
      Nat.div_eq_of_lt j.isLt, zero_add]
  have hmod : (3 * i.val + j.val) % 3 = j.val := by
    rw [Nat.add_comm, Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt j.isLt]
  have hab : a i * b j = 0 := by
    simpa [segrVec, crossIndex, hdiv, hmod] using h0
  exact mul_ne_zero hi hj hab

end V14Formalization.D12SigmaPlusSegreCore
