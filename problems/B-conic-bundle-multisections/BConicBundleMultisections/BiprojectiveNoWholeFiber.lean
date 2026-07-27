/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineJacobian
public import BConicBundleMultisections.BiprojectiveDehomogenization
public import BConicBundleMultisections.BiprojectiveWholeFiberGradient
public import BConicBundleMultisections.BiprojectiveFiberEquationBaseChange
public import BConicBundleMultisections.SmoothExtensionJacobian
public import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure

/-!
# No whole fibers on a smooth biprojective hypersurface

An identically zero specialized fiber of a bihomogeneous equation forces a singular affine
chart point.  Global smoothness of the biprojective zero locus therefore forbids such whole
fibers.  The statements are packaged for the `(2,3)` threefold and for the general dimensional
comparison `m < n + 1` (resp. `n < m + 1`) needed by the Euler/common-zero argument.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial

namespace BiprojectiveSpace

/-! ### Base change of the chart-point comparison

The singular point produced by the whole-fiber argument is only available over an algebraically
closed field, so the argument is run over `AlgebraicClosure K` and the contradiction is taken
with `SmoothExtensionJacobian`: a smooth hypersurface over `K` has no singular point valued in
*any* extension of `K`, which is exactly what makes the closure hypothesis on `K` unnecessary. -/

/-- Evaluating a `K`-chart equation at an `L`-point is evaluating its base change. -/
private theorem aeval_affineChartEquation_eq_eval_map
    {m n : ℕ} {K L : Type u} [Field K] [Field L] [Algebra K L]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (a : Fin m ⊕ Fin n → L) (p : MvPolynomial (BiprojectiveCoordinate m n) K) :
    MvPolynomial.aeval a (affineChartEquation m n K i j p)
      = MvPolynomial.eval a
        (affineChartEquation m n L i j (MvPolynomial.map (algebraMap K L) p)) := by
  rw [← map_affineChartEquation (algebraMap K L) i j p, MvPolynomial.eval_map,
    MvPolynomial.aeval_def]

/-- The same comparison for a partial derivative of the chart equation. -/
private theorem aeval_pderiv_affineChartEquation_eq_eval_map
    {m n : ℕ} {K L : Type u} [Field K] [Field L] [Algebra K L]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (q : Fin m ⊕ Fin n)
    (a : Fin m ⊕ Fin n → L) (p : MvPolynomial (BiprojectiveCoordinate m n) K) :
    MvPolynomial.aeval a (MvPolynomial.pderiv q (affineChartEquation m n K i j p))
      = MvPolynomial.eval a (MvPolynomial.pderiv q
        (affineChartEquation m n L i j (MvPolynomial.map (algebraMap K L) p))) := by
  rw [← map_affineChartEquation (algebraMap K L) i j p, MvPolynomial.pderiv_map,
    MvPolynomial.eval_map, MvPolynomial.aeval_def]

/-- Under global smoothness, a nonzero bihomogeneous equation cannot vanish identically after
specializing the first coordinate block at a normalized point, provided there are fewer left
affine coordinates than right homogeneous coordinates.

No closure hypothesis on `K`: the singular point forced by a whole fiber is produced over
`AlgebraicClosure K`, and smoothness over `K` already forbids singular points there. -/
theorem not_specializeFirstCoordinates_eq_zero_of_global_smooth
    (m n : ℕ) (K : Type u) [Field K]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0)
    (hd : 0 < d) (he : 0 < e) (hmn : m < n + 1)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)]
    (i : Fin (m + 1)) (x : Fin (m + 1) → K) (hxi : x i = 1) :
    specializeFirstCoordinates (n := n) x F ≠ 0 := by
  intro hzero
  set φ : K →+* AlgebraicClosure K := algebraMap K (AlgebraicClosure K) with hφ
  have hzeroL : specializeFirstCoordinates (n := n) (fun l => φ (x l))
      (MvPolynomial.map φ F) = 0 := by
    rw [← map_specializeFirstCoordinates_general, hzero, map_zero]
  obtain ⟨j, y, hyj, hval, hgrad⟩ :=
    exists_affineChart_singular_point_of_specializeFirst_eq_zero
      (hF.map_coefficients φ) hd he i (fun l => φ (x l)) (by simp [hxi]) hzeroL hmn
  have hne : affineChartEquation m n K i j F ≠ 0 :=
    affineChartEquation_ne_zero m n K i j F hF hF0
  refine no_common_zero_affineChartEquation_and_pderiv_of_global_smooth_extension
    m n K (AlgebraicClosure K) F hF i j hne
    (affineChartPoint i j (fun l => φ (x l)) y) ⟨?_, ?_⟩
  · rw [aeval_affineChartEquation_eq_eval_map (L := AlgebraicClosure K)]
    exact hval
  · intro q
    rw [aeval_pderiv_affineChartEquation_eq_eval_map
      (L := AlgebraicClosure K)]
    exact hgrad q

/-- Under global smoothness, a nonzero bihomogeneous equation cannot vanish identically after
specializing the second coordinate block at a normalized point, provided there are fewer right
affine coordinates than left homogeneous coordinates.

No closure hypothesis on `K`, for the same reason as the first-block statement. -/
theorem not_specializeSecondCoordinates_eq_zero_of_global_smooth
    (m n : ℕ) (K : Type u) [Field K]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0)
    (hd : 0 < d) (he : 0 < e) (hnm : n < m + 1)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)]
    (j : Fin (n + 1)) (y : Fin (n + 1) → K) (hyj : y j = 1) :
    specializeSecondCoordinates (m := m) y F ≠ 0 := by
  intro hzero
  set φ : K →+* AlgebraicClosure K := algebraMap K (AlgebraicClosure K) with hφ
  have hzeroL : specializeSecondCoordinates (m := m) (fun l => φ (y l))
      (MvPolynomial.map φ F) = 0 := by
    rw [← map_specializeSecondCoordinates, hzero, map_zero]
  obtain ⟨i, x, hxi, hval, hgrad⟩ :=
    exists_affineChart_singular_point_of_specializeSecond_eq_zero
      (hF.map_coefficients φ) hd he j (fun l => φ (y l)) (by simp [hyj]) hzeroL hnm
  have hne : affineChartEquation m n K i j F ≠ 0 :=
    affineChartEquation_ne_zero m n K i j F hF hF0
  refine no_common_zero_affineChartEquation_and_pderiv_of_global_smooth_extension
    m n K (AlgebraicClosure K) F hF i j hne
    (affineChartPoint i j x (fun l => φ (y l))) ⟨?_, ?_⟩
  · rw [aeval_affineChartEquation_eq_eval_map (L := AlgebraicClosure K)]
    exact hval
  · intro q
    rw [aeval_pderiv_affineChartEquation_eq_eval_map
      (L := AlgebraicClosure K)]
    exact hgrad q

/-- On a smooth nonzero bidegree-`(2,3)` threefold, no first-projection fiber is the whole
second projective plane. -/
theorem not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23
    (K : Type u) [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (i : Fin 3) (x : Fin 3 → K) (hxi : x i = 1) :
    specializeFirstCoordinates (n := 2) x F ≠ 0 :=
  not_specializeFirstCoordinates_eq_zero_of_global_smooth
    2 2 K F hF hF0 (by norm_num) (by norm_num) (by norm_num) i x hxi

/-- On a smooth nonzero bidegree-`(2,3)` threefold, no second-projection fiber is the whole
first projective plane. -/
theorem not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23
    (K : Type u) [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (j : Fin 3) (y : Fin 3 → K) (hyj : y j = 1) :
    specializeSecondCoordinates (m := 2) y F ≠ 0 :=
  not_specializeSecondCoordinates_eq_zero_of_global_smooth
    2 2 K F hF hF0 (by norm_num) (by norm_num) (by norm_num) j y hyj

end BiprojectiveSpace

end

end BConicBundleMultisections
