/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryResultant
public import BConicBundleMultisections.DeterminantHomogeneous

/-!
# Homogeneity of fixed-degree binary resultants

When every coefficient of two fixed-degree binary forms is homogeneous of one common degree,
their Sylvester resultant is homogeneous of that degree times the size of the Sylvester matrix.
This gives the coefficient-degree calculation used by the universal tangent-residual resultant.
-/

@[expose] public section

open MvPolynomial

namespace BConicBundleMultisections
namespace BinaryForm

variable {σ R : Type*} [CommRing R]

/-- If all coefficients of two binary forms are homogeneous of degree `d`, their fixed-degree
resultant is homogeneous of degree `(m + n) * d`. -/
theorem resultant_isHomogeneous_of_coeff
    {m n d : ℕ} (F : Form (MvPolynomial σ R) m)
    (G : Form (MvPolynomial σ R) n)
    (hF : ∀ i, ((dehomogenize F).coeff i).IsHomogeneous d)
    (hG : ∀ i, ((dehomogenize G).coeff i).IsHomogeneous d) :
    (resultant F G).IsHomogeneous ((m + n) * d) := by
  classical
  unfold resultant Polynomial.resultant
  have hentries : ∀ i j,
      ((dehomogenize F).sylvester (dehomogenize G) m n i j).IsHomogeneous d := by
    intro i j
    induction j using Fin.addCases with
    | left j =>
        simp only [Polynomial.sylvester, Matrix.of_apply, Fin.addCases_left]
        split_ifs
        · exact hG _
        · exact isHomogeneous_zero σ R d
    | right j =>
        simp only [Polynomial.sylvester, Matrix.of_apply, Fin.addCases_right]
        split_ifs
        · exact hF _
        · exact isHomogeneous_zero σ R d
  simpa using Matrix.det_isHomogeneous
    ((dehomogenize F).sylvester (dehomogenize G) m n) d hentries

end BinaryForm
end BConicBundleMultisections
