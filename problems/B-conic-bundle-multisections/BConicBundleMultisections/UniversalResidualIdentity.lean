/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.CubicQuadraticResultant

/-!
# Universal residual identity for plane cubics

For a plane cubic written in the form
`f = g(U,V) + W·h(U,V) + W²·(iU+jV) + k W³` with binary cubic `g` and binary quadratic `h`,
the fixed-degree `(3,2)` resultant of `g` against the dehomogenized first polar along the line
`W = 0`, plus the discriminant of `g` times `f`, is exactly `W²` times an explicit linear form
`q_f`.  Each coefficient of `q_f` is homogeneous of degree five in the ten coefficients of `f`.

This is the algebraic engine of the tangent-residual construction (certificate identity (2.1)).
The identity is proved by expanding Mathlib's Sylvester resultant via
`resultant_cubic_quadratic_explicit` and verifying the polynomial equation by `ring`.
-/

@[expose] public section

open Polynomial

namespace BConicBundleMultisections
namespace UniversalResidual

variable {R : Type*} [CommRing R]

/-- Dehomogenized polar quadratic leading coefficient. -/
def polarQuadA (a b e U V W : R) : R := 3 * a * U + b * V + e * W

/-- Dehomogenized polar quadratic middle coefficient. -/
def polarQuadB (b c f U V W : R) : R := 2 * b * U + 2 * c * V + f * W

/-- Dehomogenized polar quadratic constant coefficient. -/
def polarQuadC (c d hh U V W : R) : R := c * U + 3 * d * V + hh * W

/-- Explicit expansion of the `(3,2)` polar resultant (Mathlib Sylvester determinant). -/
def polarResultant (a b c d e f hh U V W : R) : R :=
  let A := polarQuadA a b e U V W
  let B := polarQuadB b c f U V W
  let C := polarQuadC c d hh U V W
  A ^ 3 * d ^ 2
    - A ^ 2 * B * c * d
    - 2 * A ^ 2 * C * b * d
    + A ^ 2 * C * c ^ 2
    + A * B ^ 2 * b * d
    + 3 * A * B * C * a * d
    - A * B * C * b * c
    - 2 * A * C ^ 2 * a * c
    + A * C ^ 2 * b ^ 2
    - B ^ 3 * a * d
    + B ^ 2 * C * a * c
    - B * C ^ 2 * a * b
    + C ^ 3 * a ^ 2

/-- The polar resultant agrees with Mathlib's fixed-degree `(3,2)` resultant. -/
theorem polarResultant_eq_resultant
    (a b c d e f hh U V W : R) :
    polarResultant a b c d e f hh U V W =
      resultant
          (C a * X ^ 3 + C b * X ^ 2 + C c * X + C d)
          (C (polarQuadA a b e U V W) * X ^ 2 +
            C (polarQuadB b c f U V W) * X +
            C (polarQuadC c d hh U V W)) 3 2 := by
  simpa [polarResultant] using
    (resultant_cubic_quadratic_explicit a b c d
      (polarQuadA a b e U V W)
      (polarQuadB b c f U V W)
      (polarQuadC c d hh U V W)).symm

/-- The universal residual coefficient of `U`. -/
def residualCoeffU (a b c d e f hh i : R) : R :=
  -3 * a ^ 2 * c * hh ^ 2 - 27 * a ^ 2 * d ^ 2 * i + 9 * a ^ 2 * d * f * hh +
    a * b ^ 2 * hh ^ 2 + 18 * a * b * c * d * i - a * b * c * f * hh -
    6 * a * b * d * e * hh - 3 * a * b * d * f ^ 2 - 4 * a * c ^ 3 * i +
    2 * a * c ^ 2 * e * hh + a * c ^ 2 * f ^ 2 - 3 * a * c * d * e * f +
    9 * a * d ^ 2 * e ^ 2 - 4 * b ^ 3 * d * i + b ^ 2 * c ^ 2 * i +
    4 * b ^ 2 * d * e * f - b * c ^ 2 * e * f - 4 * b * c * d * e ^ 2 +
    c ^ 3 * e ^ 2

/-- The universal residual coefficient of `V`. -/
def residualCoeffV (a b c d e f hh j : R) : R :=
  -27 * a ^ 2 * d ^ 2 * j + 9 * a ^ 2 * d * hh ^ 2 + 18 * a * b * c * d * j -
    4 * a * b * c * hh ^ 2 - 3 * a * b * d * f * hh - 4 * a * c ^ 3 * j +
    4 * a * c ^ 2 * f * hh - 6 * a * c * d * e * hh - 3 * a * c * d * f ^ 2 +
    9 * a * d ^ 2 * e * f - 4 * b ^ 3 * d * j + b ^ 3 * hh ^ 2 +
    b ^ 2 * c ^ 2 * j - b ^ 2 * c * f * hh + 2 * b ^ 2 * d * e * hh +
    b ^ 2 * d * f ^ 2 - b * c * d * e * f - 3 * b * d ^ 2 * e ^ 2 +
    c ^ 2 * d * e ^ 2

/-- The universal residual coefficient of `W`. -/
def residualCoeffW (a b c d e f hh k : R) : R :=
  -27 * a ^ 2 * d ^ 2 * k + a ^ 2 * hh ^ 3 + 18 * a * b * c * d * k -
    a * b * f * hh ^ 2 - 4 * a * c ^ 3 * k - 2 * a * c * e * hh ^ 2 +
    a * c * f ^ 2 * hh + 3 * a * d * e * f * hh - a * d * f ^ 3 -
    4 * b ^ 3 * d * k + b ^ 2 * c ^ 2 * k + b ^ 2 * e * hh ^ 2 -
    b * c * e * f * hh - 2 * b * d * e ^ 2 * hh + b * d * e * f ^ 2 +
    c ^ 2 * e ^ 2 * hh - c * d * e ^ 2 * f + d ^ 2 * e ^ 3

/-- The universal residual linear form. -/
def residualLinear (a b c d e f hh i j k U V W : R) : R :=
  residualCoeffU a b c d e f hh i * U +
    residualCoeffV a b c d e f hh j * V +
    residualCoeffW a b c d e f hh k * W

/-- Classical discriminant of the dehomogenized binary cubic. -/
def binaryCubicDiscr (a b c d : R) : R :=
  b ^ 2 * c ^ 2 - 4 * a * c ^ 3 - 4 * b ^ 3 * d - 27 * a ^ 2 * d ^ 2 +
    18 * a * b * c * d

/-- The universal plane cubic evaluated at `(U,V,W)`. -/
def planeCubicValue (a b c d e f hh i j k U V W : R) : R :=
  a * U ^ 3 + b * U ^ 2 * V + c * U * V ^ 2 + d * V ^ 3 +
    W * (e * U ^ 2 + f * U * V + hh * V ^ 2) +
    W ^ 2 * (i * U + j * V) + k * W ^ 3

/-- **Universal residual identity** (certificate (2.1), Mathlib resultant sign):
`Res(g,P) + Δ(g)·f = W²·q_f` with `q_f` the explicit residual linear form. -/
theorem residual_identity
    (a b c d e f hh i j k U V W : R) :
    polarResultant a b c d e f hh U V W +
        binaryCubicDiscr a b c d *
          planeCubicValue a b c d e f hh i j k U V W =
      W ^ 2 * residualLinear a b c d e f hh i j k U V W := by
  dsimp only [polarResultant, polarQuadA, polarQuadB, polarQuadC,
    binaryCubicDiscr, planeCubicValue, residualLinear,
    residualCoeffU, residualCoeffV, residualCoeffW]
  ring

/-- The residual linear form is homogeneous of degree one in `(U,V,W)`. -/
theorem residualLinear_smul
    (a b c d e f hh i j k : R) (r U V W : R) :
    residualLinear a b c d e f hh i j k (r * U) (r * V) (r * W) =
      r * residualLinear a b c d e f hh i j k U V W := by
  dsimp only [residualLinear]
  ring

set_option maxHeartbeats 8000000 in
-- Expanded residual polynomial identity after clearing the line condition is large; closes by `ring`.
/-- Residual linear form vanishes at the complementary residual ambient point of a line point
`(1, t, 0)` on the cubic.

Here the complementary direction is `p × ∇G(p)`, the binary residual representative is
`(-G(q), ∇G(q)·p)`, and the ambient residual is `-G(q) · p + (∇G(q)·p) · q`. -/
theorem residualLinear_complementary_eq_zero
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
       let dUq :=
         3 * a * q0 ^ 2 + 2 * b * q0 * q1 + c * q1 ^ 2 +
           q2 * (2 * e * q0 + f * q1) + q2 ^ 2 * i
       let dVq :=
         b * q0 ^ 2 + 2 * c * q0 * q1 + 3 * d * q1 ^ 2 +
           q2 * (f * q0 + 2 * hh * q1) + q2 ^ 2 * j
       let c12 := dUq + t * dVq
       c12 * q2) = 0 := by
  have ha : a = -(b * t + c * t ^ 2 + d * t ^ 3) := by
    have h' : a + (b * t + c * t ^ 2 + d * t ^ 3) = 0 := by
      simpa [add_assoc] using h
    exact eq_neg_of_add_eq_zero_left h'
  subst ha
  dsimp only [residualLinear, residualCoeffU, residualCoeffV, residualCoeffW]
  ring

end UniversalResidual
end BConicBundleMultisections
