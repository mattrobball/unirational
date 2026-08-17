/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Coeff
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Data.Rat.Denumerable
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

/-!
# Integer reflection for generated `Polynomial ℚ` certificates

The generated `D12SigmaPlusSegre*` certificate families prove thousands of
identities between explicit rational polynomials, each by pointwise
evaluation (`Polynomial.funext` + `simp [eval]` + `ring`), at roughly half a
second per product.  This module reflects such identities into integer
coefficient lists: a polynomial `p` is certified by `p = interpQ d zs` where
`zs` lists the numerators against a common positive denominator `d`, and the
ring operations become list convolutions and additions that `decide` checks
in the kernel at negligible cost.
-/

noncomputable section

namespace V14Formalization.D12PolyZReflection

open Polynomial

/-- Dense integer coefficient list; index = degree. -/
def toPolyZ : List Int → Polynomial ℚ
  | [] => 0
  | c :: cs => C (c : ℚ) + toPolyZ cs * X

/-- List convolution (polynomial multiplication on coefficients). -/
def convList : List Int → List Int → List Int
  | [], _ => []
  | _ :: _, [] => []
  | a :: as, bs =>
      let tail := convList as bs
      let head := (bs.map (a * ·))
      let rec addPad : List Int → List Int → List Int
        | xs, [] => xs
        | [], ys => ys
        | x :: xs, y :: ys => (x + y) :: addPad xs ys
      addPad head (0 :: tail)

/-- Pointwise addition with padding. -/
def addList : List Int → List Int → List Int
  | xs, [] => xs
  | [], ys => ys
  | x :: xs, y :: ys => (x + y) :: addList xs ys

def smulList (k : Int) (xs : List Int) : List Int := xs.map (k * ·)

def subList (xs ys : List Int) : List Int := addList xs (ys.map (- ·))

theorem toPolyZ_add (xs ys : List Int) :
    toPolyZ (addList xs ys) = toPolyZ xs + toPolyZ ys := by
  induction xs generalizing ys with
  | nil => cases ys <;> simp [toPolyZ, addList]
  | cons x xs ih =>
      cases ys with
      | nil => simp [toPolyZ, addList]
      | cons y ys =>
          simp [toPolyZ, addList, ih, Int.cast_add]
          ring

theorem toPolyZ_map_neg (xs : List Int) :
    toPolyZ (xs.map (- ·)) = - toPolyZ xs := by
  induction xs with
  | nil => simp [toPolyZ]
  | cons x xs ih => simp [toPolyZ, ih]; ring

theorem toPolyZ_sub (xs ys : List Int) :
    toPolyZ (subList xs ys) = toPolyZ xs - toPolyZ ys := by
  rw [subList, toPolyZ_add, toPolyZ_map_neg]; ring

theorem toPolyZ_map_mul (a : Int) (bs : List Int) :
    toPolyZ (bs.map (a * ·)) = C (a : ℚ) * toPolyZ bs := by
  induction bs with
  | nil => simp [toPolyZ]
  | cons b bs ih => simp [toPolyZ, ih, Int.cast_mul]; ring

theorem toPolyZ_smulList (k : Int) (xs : List Int) :
    toPolyZ (smulList k xs) = C (k : ℚ) * toPolyZ xs :=
  toPolyZ_map_mul k xs

theorem convList_addPad_eq (xs ys : List Int) :
    convList.addPad xs ys = addList xs ys := by
  induction xs generalizing ys with
  | nil => cases ys <;> rfl
  | cons x xs ih => cases ys <;> simp [convList.addPad, addList, ih]

theorem toPolyZ_conv (xs ys : List Int) :
    toPolyZ (convList xs ys) = toPolyZ xs * toPolyZ ys := by
  induction xs with
  | nil => simp [toPolyZ, convList]
  | cons x xs ih =>
      cases ys with
      | nil => simp [toPolyZ, convList]
      | cons y ys =>
          show toPolyZ (convList.addPad _ _) = _
          rw [convList_addPad_eq, toPolyZ_add, toPolyZ_map_mul]
          simp only [toPolyZ, ih, Int.cast_zero, map_zero, add_zero]
          ring

/-- `zs` lists the numerators of `p` against the positive denominator `d`. -/
def interpQ (d : ℕ) (zs : List Int) : Polynomial ℚ :=
  C ((d : ℚ)⁻¹) * toPolyZ zs

theorem interpQ_nil (d : ℕ) : interpQ d [] = 0 := by
  simp [interpQ, toPolyZ]

theorem interp_mul (d₁ d₂ : ℕ) (n₁ n₂ : List Int) :
    interpQ d₁ n₁ * interpQ d₂ n₂ = interpQ (d₁ * d₂) (convList n₁ n₂) := by
  simp only [interpQ, toPolyZ_conv]
  rw [show ((d₁ * d₂ : ℕ) : ℚ)⁻¹ = ((d₁ : ℚ))⁻¹ * ((d₂ : ℚ))⁻¹ by
    push_cast; rw [mul_inv]]
  rw [map_mul]
  ring

theorem interp_add (d : ℕ) (n₁ n₂ : List Int) :
    interpQ d n₁ + interpQ d n₂ = interpQ d (addList n₁ n₂) := by
  simp only [interpQ, toPolyZ_add]
  ring

theorem interp_sub (d : ℕ) (n₁ n₂ : List Int) :
    interpQ d n₁ - interpQ d n₂ = interpQ d (subList n₁ n₂) := by
  simp only [interpQ, toPolyZ_sub]
  ring

/-- Change of denominator: `n/d = (k·n)/(k·d)`. -/
theorem interp_up (k d : ℕ) (hk : k ≠ 0) (n : List Int) :
    interpQ d n = interpQ (k * d) (smulList (k : Int) n) := by
  have hkQ : (k : ℚ) ≠ 0 := Nat.cast_ne_zero.mpr hk
  have hs : ((d : ℚ))⁻¹ = (((k * d : ℕ) : ℚ))⁻¹ * (((k : ℤ) : ℚ)) := by
    push_cast
    rw [mul_inv, mul_comm ((k : ℚ))⁻¹ ((d : ℚ))⁻¹, mul_assoc,
      inv_mul_cancel₀ hkQ, mul_one]
  rw [interpQ, interpQ, toPolyZ_smulList, hs, map_mul, mul_assoc]

/-- Denominator-mixing addition; side conditions are literal `≠ 0` facts
    discharged by `decide`. -/
theorem interp_add_gen (d₁ d₂ : ℕ) (h₁ : d₁ ≠ 0) (h₂ : d₂ ≠ 0) (n₁ n₂ : List Int) :
    interpQ d₁ n₁ + interpQ d₂ n₂ =
      interpQ (d₁ * d₂) (addList (smulList (d₂ : Int) n₁) (smulList (d₁ : Int) n₂)) := by
  rw [interp_up d₂ d₁ h₂ n₁, interp_up d₁ d₂ h₁ n₂, mul_comm d₂ d₁]
  exact interp_add (d₁ * d₂) _ _

/-- Denominator-mixing subtraction. -/
theorem interp_sub_gen (d₁ d₂ : ℕ) (h₁ : d₁ ≠ 0) (h₂ : d₂ ≠ 0) (n₁ n₂ : List Int) :
    interpQ d₁ n₁ - interpQ d₂ n₂ =
      interpQ (d₁ * d₂) (subList (smulList (d₂ : Int) n₁) (smulList (d₁ : Int) n₂)) := by
  rw [interp_up d₂ d₁ h₂ n₁, interp_up d₁ d₂ h₁ n₂, mul_comm d₂ d₁]
  exact interp_sub (d₁ * d₂) _ _

theorem allZero_toPolyZ (xs : List Int) (h : xs.all (· == 0) = true) :
    toPolyZ xs = 0 := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
      rw [List.all_cons, Bool.and_eq_true] at h
      have hx : x = 0 := by exact_mod_cast beq_iff_eq.mp h.1
      rw [toPolyZ, ih h.2, hx]
      simp

/-- Two representations agree when the cross-multiplied difference vanishes
    coefficientwise (trailing zeros allowed on either side). -/
theorem interp_eq (d₁ d₂ : ℕ) (h₁ : d₁ ≠ 0) (h₂ : d₂ ≠ 0) (n₁ n₂ : List Int)
    (h : (subList (smulList (d₂ : Int) n₁) (smulList (d₁ : Int) n₂)).all
      (· == 0) = true) :
    interpQ d₁ n₁ = interpQ d₂ n₂ := by
  have hz : toPolyZ (smulList (d₂ : Int) n₁) = toPolyZ (smulList (d₁ : Int) n₂) := by
    have h0 := allZero_toPolyZ _ h
    rw [toPolyZ_sub] at h0
    exact sub_eq_zero.mp h0
  rw [interp_up d₂ d₁ h₂ n₁, interp_up d₁ d₂ h₁ n₂, mul_comm d₂ d₁]
  unfold interpQ
  rw [hz]

end V14Formalization.D12PolyZReflection
