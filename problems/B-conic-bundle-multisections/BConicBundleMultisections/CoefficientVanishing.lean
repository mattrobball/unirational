/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.Algebra.Polynomial.Roots

/-!
# A polynomial function that vanishes identically has vanishing coefficients

Over an **infinite** integral domain, a polynomial *function* determines its coefficients.  This
file records that fact in the unrolled degree-`8` form the residual-rigidity certificates need.

## Why not interpolate?

The obvious proof of "if `∑ aᵢ xⁱ = 0` for all `x` then every `aᵢ = 0`" is to evaluate at
`x = 0, 1, …, 8` and invert the Vandermonde matrix.  That is what this project used to do, and it
is why the projective Hesse rigidity certificate divided by `8! = 40320`: the inverse Vandermonde
matrix on the points `0, …, 8` has denominators with prime factors `2, 3, 5, 7`.  A certificate
like that is only valid when the characteristic avoids all four primes, which is strictly stronger
than the `ringChar ∤ 6` the rest of the development needs — and it is stronger than the statement
itself requires, because the statement is true over *any* infinite domain.

`Polynomial.funext` gives the honest proof: the hypothesis says two polynomials have equal
evaluation functions, so over an infinite domain they are equal, and equal polynomials have equal
coefficients.  No division whatsoever, hence no constraint on the characteristic.
-/

@[expose] public section

namespace BConicBundleMultisections

open Polynomial

/-- **Coefficients of a vanishing polynomial function of degree at most `8`.**

Over an infinite integral domain, if `a₀ + a₁x + ⋯ + a₈x⁸` vanishes for every `x`, then every
`aᵢ` is zero.  Characteristic-free: the proof divides by nothing. -/
theorem coeffs8_eq_zero {R : Type*} [CommRing R] [IsDomain R] [Infinite R]
    (a0 a1 a2 a3 a4 a5 a6 a7 a8 : R)
    (h : ∀ x : R, a0 + a1 * x + a2 * x ^ 2 + a3 * x ^ 3 + a4 * x ^ 4 + a5 * x ^ 5 + a6 * x ^ 6
      + a7 * x ^ 7 + a8 * x ^ 8 = 0) :
    a0 = 0 ∧ a1 = 0 ∧ a2 = 0 ∧ a3 = 0 ∧ a4 = 0 ∧ a5 = 0 ∧ a6 = 0 ∧ a7 = 0 ∧ a8 = 0 := by
  have hp : (C a0 + C a1 * X + C a2 * X ^ 2 + C a3 * X ^ 3 + C a4 * X ^ 4 + C a5 * X ^ 5
      + C a6 * X ^ 6 + C a7 * X ^ 7 + C a8 * X ^ 8 : R[X]) = 0 := by
    apply Polynomial.funext
    intro r
    simpa using h r
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    [ have := congrArg (fun p => Polynomial.coeff p 0) hp;
      have := congrArg (fun p => Polynomial.coeff p 1) hp;
      have := congrArg (fun p => Polynomial.coeff p 2) hp;
      have := congrArg (fun p => Polynomial.coeff p 3) hp;
      have := congrArg (fun p => Polynomial.coeff p 4) hp;
      have := congrArg (fun p => Polynomial.coeff p 5) hp;
      have := congrArg (fun p => Polynomial.coeff p 6) hp;
      have := congrArg (fun p => Polynomial.coeff p 7) hp;
      have := congrArg (fun p => Polynomial.coeff p 8) hp] <;>
    simpa using this

end BConicBundleMultisections
