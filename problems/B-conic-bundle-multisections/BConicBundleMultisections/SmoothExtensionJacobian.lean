/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineJacobian

/-!
# Smooth hypersurface Jacobian certificates over field extensions

Smoothness of a hypersurface quotient over a field says that the images of its partial
derivatives generate the unit ideal.  That certificate may be evaluated in any extension field,
so the equation and all its partials cannot acquire a common zero after extending scalars.

This avoids constructing a scheme-level base-change isomorphism when a generic-fibre argument
produces a point over a finite extension of a rational function field.
-/

@[expose] public section

namespace BConicBundleMultisections

open MvPolynomial

universe u v

namespace Hypersurface

/-- A nonzero smooth hypersurface equation has no singular point over any extension field.

The smoothness hypothesis is kept over `K`.  Its unit-ideal Jacobian certificate is evaluated
directly in `L`; no smoothness instance or zero-locus comparison over `L` is required. -/
theorem exists_pderiv_ne_zero_at_of_smooth_extension
    {K L : Type u} {σ : Type v} [Field K] [Field L] [Algebra K L] [Finite σ]
    (f : MvPolynomial σ K) (hf : f ≠ 0)
    (hsmooth : RingHom.Smooth
      (algebraMap K (MvPolynomial σ K ⧸ Ideal.span {f})))
    (a : σ → L) (ha : MvPolynomial.aeval a f = 0) :
    ∃ i : σ, MvPolynomial.aeval a (MvPolynomial.pderiv i f) ≠ 0 := by
  classical
  letI := Fintype.ofFinite σ
  by_contra h
  push Not at h
  have hspan := pderiv_span_eq_top_of_smooth f hf hsmooth
  have hI : ∀ p : MvPolynomial σ K, p ∈ Ideal.span {f} →
      MvPolynomial.aeval a p = 0 := by
    intro p hp
    obtain ⟨c, rfl⟩ := Ideal.mem_span_singleton'.mp hp
    rw [map_mul, ha, mul_zero]
  let ev : (MvPolynomial σ K ⧸ Ideal.span {f}) →ₐ[K] L :=
    Ideal.Quotient.liftₐ (Ideal.span {f}) (MvPolynomial.aeval a) hI
  have hone : (1 : MvPolynomial σ K ⧸ Ideal.span {f}) ∈
      Ideal.span (Set.range fun i : σ =>
        Ideal.Quotient.mk (Ideal.span {f}) (MvPolynomial.pderiv i f)) :=
    (Ideal.eq_top_iff_one _).mp hspan
  rw [Ideal.mem_span_range_iff_exists_fun] at hone
  obtain ⟨c, hc⟩ := hone
  have hc' := congrArg ev hc
  simp [ev, h] at hc'

end Hypersurface

open AlgebraicGeometry

namespace BiprojectiveSpace

/-- The affine-chart Jacobian criterion for a globally smooth biprojective hypersurface remains
valid at points valued in an arbitrary extension field. -/
theorem exists_affineChartEquation_pderiv_ne_zero_at_of_global_smooth_extension
    (m n : ℕ) (K L : Type u) [Field K] [Field L] [Algebra K L]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (hne : affineChartEquation m n K i j F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)]
    (a : (Fin m ⊕ Fin n) → L)
    (ha : MvPolynomial.aeval a (affineChartEquation m n K i j F) = 0) :
    ∃ q : Fin m ⊕ Fin n,
      MvPolynomial.aeval a
        (MvPolynomial.pderiv q (affineChartEquation m n K i j F)) ≠ 0 :=
  Hypersurface.exists_pderiv_ne_zero_at_of_smooth_extension
    (affineChartEquation m n K i j F) hne
    (affineChartQuotient_smooth_of_global m n K F hF i j) a ha

/-- Equivalently, a nonzero affine chart equation of a globally smooth biprojective hypersurface
and all its partial derivatives have no common zero over any field extension. -/
theorem no_common_zero_affineChartEquation_and_pderiv_of_global_smooth_extension
    (m n : ℕ) (K L : Type u) [Field K] [Field L] [Algebra K L]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (hne : affineChartEquation m n K i j F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)]
    (a : (Fin m ⊕ Fin n) → L) :
    ¬ (MvPolynomial.aeval a (affineChartEquation m n K i j F) = 0 ∧
      ∀ q : Fin m ⊕ Fin n,
        MvPolynomial.aeval a
          (MvPolynomial.pderiv q (affineChartEquation m n K i j F)) = 0) := by
  rintro ⟨ha, hpartial⟩
  obtain ⟨q, hq⟩ :=
    exists_affineChartEquation_pderiv_ne_zero_at_of_global_smooth_extension
      m n K L F hF i j hne a ha
  exact hq (hpartial q)

end BiprojectiveSpace

end BConicBundleMultisections
