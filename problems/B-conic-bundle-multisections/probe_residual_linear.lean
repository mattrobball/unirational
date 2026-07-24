import BConicBundleMultisections.UniversalResidualIdentity
import Mathlib.Tactic.Ring
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Abel

open BConicBundleMultisections.UniversalResidual

variable {R : Type*} [CommRing R]

theorem residualLinear_complementary_residual_eq_zero
    (a b c d e f hh i j k t : R)
    (h : a + b * t + c * t ^ 2 + d * t ^ 3 = 0) :
    residualLinear a b c d e f hh i j k
      (let dU := 3 * a + 2 * b * t + c * t ^ 2
       let dV := b + 2 * c * t + 3 * d * t ^ 2
       let dW := e + f * t + hh * t ^ 2
       let q0 := t * dW
       let q1 := -dW
       let q2 := dV - t * dU
       let Gq :=
         a * q0 ^ 3 + b * q0 ^ 2 * q1 + c * q0 * q1 ^ 2 + d * q1 ^ 3 +
           q2 * (e * q0 ^ 2 + f * q0 * q1 + hh * q1 ^ 2) +
           q2 ^ 2 * (i * q0 + j * q1) + k * q2 ^ 3
       let dUq :=
         3 * a * q0 ^ 2 + 2 * b * q0 * q1 + c * q1 ^ 2 +
           q2 * (2 * e * q0 + f * q1) + q2 ^ 2 * i
       let dVq :=
         b * q0 ^ 2 + 2 * c * q0 * q1 + 3 * d * q1 ^ 2 +
           q2 * (f * q0 + 2 * hh * q1) + q2 ^ 2 * j
       let c12 := dUq + t * dVq
       (-Gq) + c12 * q0)
      (let dU := 3 * a + 2 * b * t + c * t ^ 2
       let dV := b + 2 * c * t + 3 * d * t ^ 2
       let dW := e + f * t + hh * t ^ 2
       let q0 := t * dW
       let q1 := -dW
       let q2 := dV - t * dU
       let Gq :=
         a * q0 ^ 3 + b * q0 ^ 2 * q1 + c * q0 * q1 ^ 2 + d * q1 ^ 3 +
           q2 * (e * q0 ^ 2 + f * q0 * q1 + hh * q1 ^ 2) +
           q2 ^ 2 * (i * q0 + j * q1) + k * q2 ^ 3
       let dUq :=
         3 * a * q0 ^ 2 + 2 * b * q0 * q1 + c * q1 ^ 2 +
           q2 * (2 * e * q0 + f * q1) + q2 ^ 2 * i
       let dVq :=
         b * q0 ^ 2 + 2 * c * q0 * q1 + 3 * d * q1 ^ 2 +
           q2 * (f * q0 + 2 * hh * q1) + q2 ^ 2 * j
       let c12 := dUq + t * dVq
       (-Gq) * t + c12 * q1)
      (let dU := 3 * a + 2 * b * t + c * t ^ 2
       let dV := b + 2 * c * t + 3 * d * t ^ 2
       let dW := e + f * t + hh * t ^ 2
       let q0 := t * dW
       let q1 := -dW
       let q2 := dV - t * dU
       let Gq :=
         a * q0 ^ 3 + b * q0 ^ 2 * q1 + c * q0 * q1 ^ 2 + d * q1 ^ 3 +
           q2 * (e * q0 ^ 2 + f * q0 * q1 + hh * q1 ^ 2) +
           q2 ^ 2 * (i * q0 + j * q1) + k * q2 ^ 3
       let dUq :=
         3 * a * q0 ^ 2 + 2 * b * q0 * q1 + c * q1 ^ 2 +
           q2 * (2 * e * q0 + f * q1) + q2 ^ 2 * i
       let dVq :=
         b * q0 ^ 2 + 2 * c * q0 * q1 + 3 * d * q1 ^ 2 +
           q2 * (f * q0 + 2 * hh * q1) + q2 ^ 2 * j
       let c12 := dUq + t * dVq
       c12 * q2) = 0 := by
  -- Clear `a` using the line condition, then expand.
  have ha : a = -(b * t + c * t ^ 2 + d * t ^ 3) := by linear_combination -h
  rw [ha]
  dsimp only [residualLinear, residualCoeffU, residualCoeffV, residualCoeffW]
  ring_nf
  -- Should be 0
  ring
