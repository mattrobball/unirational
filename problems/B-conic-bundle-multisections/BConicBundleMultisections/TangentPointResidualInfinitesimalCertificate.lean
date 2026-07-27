/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.WeierstrassResidualInfinitesimalCertificate
public import BConicBundleMultisections.NeZeroTwoThree

/-!
# Infinitesimal residual rigidity in nonflex tangent-point normal form

At a nonflex smooth point, projective coordinates can put a plane cubic in the form

`U^2 V + V^2 W + P U W^2 + Q V W^2 + S W^3`.

This file records the finite linear-algebra certificate for that form.  Thirteen coefficients of
the three residual-quartic cross-products force a projectively normalized tangent cubic to vanish.
The displayed discriminant is the discriminant, up to a nonzero scalar, of the quartic obtained by
completing the square in `V`.

The coordinate normalization and the extraction of these thirteen equations are deliberately not
asserted here.  The exact extraction is reproduced by
`certificates/tangent_point_residual_infinitesimal_probe.py --nonflex-normal --cover-minors`.
-/

@[expose] public section

namespace BConicBundleMultisections.TangentPointResidualInfinitesimalCertificate

universe u

variable {K : Type u} [Field K] [NeZero (2 : K)] [NeZero (3 : K)]

/-- Smoothness factor for
`U^2 V + V^2 W + P U W^2 + Q V W^2 + S W^3`. -/
abbrev nonflexDiscr (P Q S : K) : K :=
  27 * P ^ 4 - 16 * P ^ 2 * Q ^ 3 + 72 * P ^ 2 * Q * S -
    16 * Q ^ 2 * S ^ 2 + 64 * S ^ 3

/-- The identity which closes the exceptional chart of the rank certificate. -/
theorem three_mul_nonflexDiscr (P Q S : K) :
    3 * nonflexDiscr P Q S =
      (9 * P ^ 2 + 4 * Q * S) ^ 2 +
        (48 * S - 16 * Q ^ 2) * (3 * P ^ 2 * Q + 4 * S ^ 2) := by
  ring

/--
Thirteen sparse coefficients of the residual cross-products give full projective infinitesimal
rigidity in nonflex tangent-point normal form.  The variables `xa,...,xk` are the nine tangent
coefficients left after subtracting the scalar tangent and thereby normalizing the variation of
the `V^2 W` coefficient to zero.
-/
theorem normalized_tangent_eq_zero_of_cross_equations
    (P Q S xa xb xc xd xe xf xi xj xk : K)
    (hdisc : nonflexDiscr P Q S ≠ 0)
    (h00 : -xa + 4 * P * xd = 0)
    (h200 : -4 * S * xd + xe = 0)
    (h010 : -2 * P * xc + 8 * S * xd = 0)
    (h001 : -4 * Q * xa + 16 * P * Q * xd + 4 * xi = 0)
    (h020 : -4 * Q * xa - 4 * S * xc + 4 * P * Q * xd = 0)
    (h210 : -2 * Q * xa - 2 * P * xb + 2 * S * xc + 8 * P * Q * xd + 2 * xi = 0)
    (h201 : -2 * P * xa - 16 * Q * S * xd + 4 * Q * xe - 4 * xk = 0)
    (h011 : -4 * P * Q * xc + 16 * (P ^ 2 + 2 * Q * S) * xd - 8 * Q * xe -
      6 * P * xf + 8 * xk = 0)
    (h002 : -4 * (Q ^ 2 + S) * xa + 6 * P ^ 2 * xc +
      8 * P * (2 * Q ^ 2 + 3 * S) * xd - 12 * P * xe + 4 * Q * xi + 4 * P * xj = 0)
    (h220 : 6 * P * xa - 4 * S * xb - 4 * P * Q * xc -
      4 * (4 * P ^ 2 + Q * S) * xd - 3 * P * xf + 4 * xk = 0)
    (h021 : -4 * Q ^ 2 * xa + 12 * P * Q * xb - 8 * Q * S * xc +
      4 * P * (4 * Q ^ 2 + 9 * S) * xd + 24 * P * xe - 8 * S * xf +
      4 * Q * xi - 12 * P * xj = 0)
    (h202 : -8 * P * Q * xa - 6 * P * S * xc -
      8 * S * (2 * Q ^ 2 + 3 * S) * xd + 4 * (Q ^ 2 + 2 * S) * xe -
      4 * S * xj - 4 * Q * xk = 0)
    (h030 : 8 * P * xa - 2 * P * Q * xc - 2 * (7 * P ^ 2 - 8 * Q * S) * xd = 0) :
    xa = 0 ∧ xb = 0 ∧ xc = 0 ∧ xd = 0 ∧ xe = 0 ∧ xf = 0 ∧
      xi = 0 ∧ xj = 0 ∧ xk = 0 := by
  by_cases hP : P = 0
  · have hS : S ≠ 0 := by
      intro hS
      apply hdisc
      simp [nonflexDiscr, hP, hS]
    have hxa : xa = 0 := by
      have h00' : -xa = 0 := by simpa [hP] using h00
      linear_combination -h00'
    have hSxd : 8 * S * xd = 0 := by
      simpa [hP] using h010
    have hxd : xd = 0 :=
      (mul_eq_zero.mp hSxd).resolve_left (mul_ne_zero eight_ne_zero' hS)
    have hxe : xe = 0 := by
      rw [hxd] at h200
      linear_combination h200
    have hxc : xc = 0 := by
      rw [hP, hxa, hxd] at h020
      have hSxc : (-4 * S) * xc = 0 := by linear_combination h020
      exact (mul_eq_zero.mp hSxc).resolve_left
        (mul_ne_zero (neg_ne_zero.mpr four_ne_zero') hS)
    have hxi : xi = 0 := by
      rw [hP, hxa, hxd] at h001
      linear_combination₆ (4 : K)⁻¹ * h001
    have hxk : xk = 0 := by
      rw [hP, hxa, hxd, hxe] at h201
      linear_combination₆ (-4 : K)⁻¹ * h201
    have hxb : xb = 0 := by
      rw [hP, hxa, hxc, hxd, hxk] at h220
      have hSxb : (-4 * S) * xb = 0 := by linear_combination h220
      exact (mul_eq_zero.mp hSxb).resolve_left
        (mul_ne_zero (neg_ne_zero.mpr four_ne_zero') hS)
    have hxf : xf = 0 := by
      rw [hP, hxa, hxb, hxc, hxd, hxe, hxi] at h021
      have hSxf : (-8 * S) * xf = 0 := by linear_combination h021
      exact (mul_eq_zero.mp hSxf).resolve_left
        (mul_ne_zero (neg_ne_zero.mpr eight_ne_zero') hS)
    have hxj : xj = 0 := by
      rw [hP, hxa, hxc, hxd, hxe, hxk] at h202
      have hSxj : (-4 * S) * xj = 0 := by linear_combination h202
      exact (mul_eq_zero.mp hSxj).resolve_left
        (mul_ne_zero (neg_ne_zero.mpr four_ne_zero') hS)
    exact by simp [hxa, hxb, hxc, hxd, hxe, hxf, hxi, hxj, hxk]
  · by_cases hE : 3 * P ^ 2 * Q + 4 * S ^ 2 = 0
    · have hG : 9 * P ^ 2 + 4 * Q * S ≠ 0 := by
        intro hG
        apply hdisc
        have hthree : (3 : K) ≠ 0 := three_ne_zero
        apply (mul_eq_zero.mp ?_).resolve_left hthree
        calc
          3 * nonflexDiscr P Q S =
              (9 * P ^ 2 + 4 * Q * S) ^ 2 +
                (48 * S - 16 * Q ^ 2) * (3 * P ^ 2 * Q + 4 * S ^ 2) :=
            three_mul_nonflexDiscr P Q S
          _ = 0 := by rw [hG, hE]; ring
      have hGxd : 2 * (9 * P ^ 2 + 4 * Q * S) * xd = 0 := by
        linear_combination h030 + 8 * P * h00 - Q * h010
      have hxd : xd = 0 :=
        (mul_eq_zero.mp hGxd).resolve_left (mul_ne_zero two_ne_zero hG)
      have hxa : xa = 0 := by
        rw [hxd] at h00
        linear_combination -h00
      have hxe : xe = 0 := by
        rw [hxd] at h200
        linear_combination h200
      have hxc : xc = 0 := by
        rw [hxd] at h010
        have hPxc : (-2 * P) * xc = 0 := by linear_combination h010
        exact (mul_eq_zero.mp hPxc).resolve_left
          (mul_ne_zero (neg_ne_zero.mpr two_ne_zero) hP)
      have hxi : xi = 0 := by
        rw [hxa, hxd] at h001
        linear_combination₆ (4 : K)⁻¹ * h001
      have hxb : xb = 0 := by
        rw [hxa, hxc, hxd, hxi] at h210
        have hPxb : (-2 * P) * xb = 0 := by linear_combination h210
        exact (mul_eq_zero.mp hPxb).resolve_left
          (mul_ne_zero (neg_ne_zero.mpr two_ne_zero) hP)
      have hxk : xk = 0 := by
        rw [hxa, hxd, hxe] at h201
        linear_combination₆ (-4 : K)⁻¹ * h201
      have hxf : xf = 0 := by
        rw [hxc, hxd, hxe, hxk] at h011
        have hPxf : (-6 * P) * xf = 0 := by linear_combination h011
        exact (mul_eq_zero.mp hPxf).resolve_left
          (mul_ne_zero (neg_ne_zero.mpr six_ne_zero') hP)
      have hxj : xj = 0 := by
        rw [hxa, hxc, hxd, hxe, hxi] at h002
        have hPxj : (4 * P) * xj = 0 := by linear_combination h002
        exact (mul_eq_zero.mp hPxj).resolve_left (mul_ne_zero four_ne_zero' hP)
      exact by simp [hxa, hxb, hxc, hxd, hxe, hxf, hxi, hxj, hxk]
    · have hExd : -4 * (3 * P ^ 2 * Q + 4 * S ^ 2) * xd = 0 := by
        linear_combination P * h020 - 4 * P * Q * h00 - 2 * S * h010
      have hxd : xd = 0 :=
        (mul_eq_zero.mp hExd).resolve_left
          (mul_ne_zero (neg_ne_zero.mpr four_ne_zero') hE)
      have hxa : xa = 0 := by
        rw [hxd] at h00
        linear_combination -h00
      have hxe : xe = 0 := by
        rw [hxd] at h200
        linear_combination h200
      have hxc : xc = 0 := by
        rw [hxd] at h010
        have hPxc : (-2 * P) * xc = 0 := by linear_combination h010
        exact (mul_eq_zero.mp hPxc).resolve_left
          (mul_ne_zero (neg_ne_zero.mpr two_ne_zero) hP)
      have hxi : xi = 0 := by
        rw [hxa, hxd] at h001
        linear_combination₆ (4 : K)⁻¹ * h001
      have hxb : xb = 0 := by
        rw [hxa, hxc, hxd, hxi] at h210
        have hPxb : (-2 * P) * xb = 0 := by linear_combination h210
        exact (mul_eq_zero.mp hPxb).resolve_left
          (mul_ne_zero (neg_ne_zero.mpr two_ne_zero) hP)
      have hxk : xk = 0 := by
        rw [hxa, hxd, hxe] at h201
        linear_combination₆ (-4 : K)⁻¹ * h201
      have hxf : xf = 0 := by
        rw [hxc, hxd, hxe, hxk] at h011
        have hPxf : (-6 * P) * xf = 0 := by linear_combination h011
        exact (mul_eq_zero.mp hPxf).resolve_left
          (mul_ne_zero (neg_ne_zero.mpr six_ne_zero') hP)
      have hxj : xj = 0 := by
        rw [hxa, hxc, hxd, hxe, hxi] at h002
        have hPxj : (4 * P) * xj = 0 := by linear_combination h002
        exact (mul_eq_zero.mp hPxj).resolve_left (mul_ne_zero four_ne_zero' hP)
      exact by simp [hxa, hxb, hxc, hxd, hxe, hxf, hxi, hxj, hxk]

end BConicBundleMultisections.TangentPointResidualInfinitesimalCertificate
