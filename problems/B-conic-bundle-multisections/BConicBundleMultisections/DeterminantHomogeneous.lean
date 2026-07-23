/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
public import Mathlib.RingTheory.MvPolynomial.Homogeneous

/-!
# Homogeneity of polynomial-valued determinants

A determinant whose entries are homogeneous polynomials of one fixed degree is homogeneous of
that degree times the size of the matrix. This is the degree-counting lemma needed for the
Sylvester determinant in the tangent-residual construction.
-/

@[expose] public section

open MvPolynomial

namespace BConicBundleMultisections

variable {ι σ R : Type*} [Fintype ι] [DecidableEq ι] [CommRing R]

/-- The determinant of an `r × r` matrix of homogeneous degree-`d` polynomials is homogeneous
of degree `r * d`. -/
theorem Matrix.det_isHomogeneous
    (A : Matrix ι ι (MvPolynomial σ R)) (d : ℕ)
    (hA : ∀ i j, (A i j).IsHomogeneous d) :
    A.det.IsHomogeneous (Fintype.card ι * d) := by
  classical
  rw [Matrix.det_apply']
  apply IsHomogeneous.sum
  intro π hπ
  have hprod : (∏ i, A (π i) i).IsHomogeneous (∑ _i : ι, d) :=
    IsHomogeneous.prod Finset.univ (fun i ↦ A (π i) i) (fun _ ↦ d)
      (fun i hi ↦ hA (π i) i)
  rw [Finset.sum_const, Finset.card_univ, nsmul_eq_mul] at hprod
  change (C (((Equiv.Perm.sign π : ℤ) : R)) * ∏ i, A (π i) i).IsHomogeneous
    (Fintype.card ι * d)
  exact hprod.C_mul _

end BConicBundleMultisections
