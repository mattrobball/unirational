/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryResultant

/-!
# Discriminant of a fixed-degree binary cubic

The classical discriminant formula for a homogeneous binary cubic, expressed via its
dehomogenization, together with coefficientwise homogeneity and the comparison with Mathlib's
univariate cubic discriminant under an exact-degree hypothesis.
-/

@[expose] public section

open MvPolynomial
open scoped Polynomial

namespace BConicBundleMultisections
namespace BinaryForm

noncomputable section

variable {R : Type*} [CommRing R]

/-- The discriminant formula of a fixed-degree binary cubic. -/
def cubicDiscriminant (F : Form R 3) : R :=
  let p := dehomogenize F
  p.coeff 2 ^ 2 * p.coeff 1 ^ 2
    - 4 * p.coeff 3 * p.coeff 1 ^ 3
    - 4 * p.coeff 2 ^ 3 * p.coeff 0
    - 27 * p.coeff 3 ^ 2 * p.coeff 0 ^ 2
    + 18 * p.coeff 3 * p.coeff 2 * p.coeff 1 * p.coeff 0

@[simp]
theorem cubicDiscriminant_map {S : Type*} [CommRing S]
    (phi : R →+* S) (F : Form R 3) :
    cubicDiscriminant (map phi F) = phi (cubicDiscriminant F) := by
  simp only [cubicDiscriminant, dehomogenize_map, Polynomial.coeff_map,
    map_sub, map_add, map_mul, map_pow, map_ofNat]

theorem cubicDiscriminant_eq_discr (F : Form R 3)
    (hdegree : (dehomogenize F).degree = 3) :
    cubicDiscriminant F = (dehomogenize F).discr := by
  simpa [cubicDiscriminant] using
    (Polynomial.discr_of_degree_eq_three hdegree).symm

variable {σ : Type*}

theorem cubicDiscriminant_isHomogeneous_of_coeff
    (F : Form (MvPolynomial σ R) 3)
    (hcoeff : ∀ i, ((dehomogenize F).coeff i).IsHomogeneous 1) :
    (cubicDiscriminant F).IsHomogeneous 4 := by
  let p := dehomogenize F
  have h0 := hcoeff 0
  have h1 := hcoeff 1
  have h2 := hcoeff 2
  have h3 := hcoeff 3
  have hC4 : IsHomogeneous (4 : MvPolynomial σ R) 0 := by
    rw [show (4 : MvPolynomial σ R) = C (4 : R) from (C_eq_coe_nat 4).symm]
    exact isHomogeneous_C _ _
  have hC27 : IsHomogeneous (27 : MvPolynomial σ R) 0 := by
    rw [show (27 : MvPolynomial σ R) = C (27 : R) from (C_eq_coe_nat 27).symm]
    exact isHomogeneous_C _ _
  have hC18 : IsHomogeneous (18 : MvPolynomial σ R) 0 := by
    rw [show (18 : MvPolynomial σ R) = C (18 : R) from (C_eq_coe_nat 18).symm]
    exact isHomogeneous_C _ _
  have ht1 : (p.coeff 2 ^ 2 * p.coeff 1 ^ 2).IsHomogeneous 4 := by
    simpa using (h2.pow 2).mul (h1.pow 2)
  have ht2 : (4 * p.coeff 3 * p.coeff 1 ^ 3).IsHomogeneous 4 := by
    simpa [mul_assoc] using (hC4.mul h3).mul (h1.pow 3)
  have ht3 : (4 * p.coeff 2 ^ 3 * p.coeff 0).IsHomogeneous 4 := by
    simpa [mul_assoc] using (hC4.mul (h2.pow 3)).mul h0
  have ht4 : (27 * p.coeff 3 ^ 2 * p.coeff 0 ^ 2).IsHomogeneous 4 := by
    simpa [mul_assoc] using (hC27.mul (h3.pow 2)).mul (h0.pow 2)
  have ht5 :
      (18 * p.coeff 3 * p.coeff 2 * p.coeff 1 * p.coeff 0).IsHomogeneous 4 := by
    simpa [mul_assoc] using (((hC18.mul h3).mul h2).mul h1).mul h0
  exact (((ht1.sub ht2).sub ht3).sub ht4).add ht5

end
end BinaryForm
end BConicBundleMultisections
