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
theorem aeval_affineChartEquation_eq_eval_map
    {m n : ℕ} {K L : Type u} [Field K] [Field L] [Algebra K L]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (a : Fin m ⊕ Fin n → L) (p : MvPolynomial (BiprojectiveCoordinate m n) K) :
    MvPolynomial.aeval a (affineChartEquation m n K i j p)
      = MvPolynomial.eval a
        (affineChartEquation m n L i j (MvPolynomial.map (algebraMap K L) p)) := by
  rw [← map_affineChartEquation (algebraMap K L) i j p, MvPolynomial.eval_map,
    MvPolynomial.aeval_def]

/-- The same comparison for a partial derivative of the chart equation. -/
theorem aeval_pderiv_affineChartEquation_eq_eval_map
    {m n : ℕ} {K L : Type u} [Field K] [Field L] [Algebra K L]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (q : Fin m ⊕ Fin n)
    (a : Fin m ⊕ Fin n → L) (p : MvPolynomial (BiprojectiveCoordinate m n) K) :
    MvPolynomial.aeval a (MvPolynomial.pderiv q (affineChartEquation m n K i j p))
      = MvPolynomial.eval a (MvPolynomial.pderiv q
        (affineChartEquation m n L i j (MvPolynomial.map (algebraMap K L) p))) := by
  rw [← map_affineChartEquation (algebraMap K L) i j p, MvPolynomial.pderiv_map,
    MvPolynomial.eval_map, MvPolynomial.aeval_def]

/-- **No whole fiber over a point of an algebraically closed extension.**

The base field `K` is arbitrary and carries only the smoothness instance; the normalized point
`x` lives in an algebraically closed extension `L`.  This is the form the flatness and
Nullstellensatz arguments downstream need, since they run over `L`. -/
theorem not_specializeFirstCoordinates_map_eq_zero_of_global_smooth_of_geometric
    (m n : ℕ) (K : Type u) [Field K] {L : Type u} [Field L] [IsAlgClosed L] [Algebra K L]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0)
    (hd : 0 < d) (he : 0 < e) (hmn : m < n + 1)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)]
    (i : Fin (m + 1)) (x : Fin (m + 1) → L) (hxi : x i = 1) :
    specializeFirstCoordinates (n := n) x (MvPolynomial.map (algebraMap K L) F) ≠ 0 := by
  intro hzero
  obtain ⟨j, y, hyj, hval, hgrad⟩ :=
    exists_affineChart_singular_point_of_specializeFirst_eq_zero
      (hF.map_coefficients (algebraMap K L)) hd he i x hxi hzero hmn
  have hne : affineChartEquation m n K i j F ≠ 0 :=
    affineChartEquation_ne_zero m n K i j F hF hF0
  refine no_common_zero_affineChartEquation_and_pderiv_of_global_smooth_extension
    m n K L F hF i j hne (affineChartPoint i j x y) ⟨?_, ?_⟩
  · rw [aeval_affineChartEquation_eq_eval_map (L := L)]
    exact hval
  · intro q
    rw [aeval_pderiv_affineChartEquation_eq_eval_map (L := L)]
    exact hgrad q

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
  refine not_specializeFirstCoordinates_map_eq_zero_of_global_smooth_of_geometric
    (L := AlgebraicClosure K) m n K F hF hF0 hd he hmn i
    (fun l => algebraMap K (AlgebraicClosure K) (x l)) (by simp [hxi]) ?_
  rw [← map_specializeFirstCoordinates_general, hzero, map_zero]

/-- **No whole fiber of the second projection over a point of an algebraically closed
extension.**  Companion of the first-block statement. -/
theorem not_specializeSecondCoordinates_map_eq_zero_of_global_smooth_of_geometric
    (m n : ℕ) (K : Type u) [Field K] {L : Type u} [Field L] [IsAlgClosed L] [Algebra K L]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0)
    (hd : 0 < d) (he : 0 < e) (hnm : n < m + 1)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)]
    (j : Fin (n + 1)) (y : Fin (n + 1) → L) (hyj : y j = 1) :
    specializeSecondCoordinates (m := m) y (MvPolynomial.map (algebraMap K L) F) ≠ 0 := by
  intro hzero
  obtain ⟨i, x, hxi, hval, hgrad⟩ :=
    exists_affineChart_singular_point_of_specializeSecond_eq_zero
      (hF.map_coefficients (algebraMap K L)) hd he j y hyj hzero hnm
  have hne : affineChartEquation m n K i j F ≠ 0 :=
    affineChartEquation_ne_zero m n K i j F hF hF0
  refine no_common_zero_affineChartEquation_and_pderiv_of_global_smooth_extension
    m n K L F hF i j hne (affineChartPoint i j x y) ⟨?_, ?_⟩
  · rw [aeval_affineChartEquation_eq_eval_map (L := L)]
    exact hval
  · intro q
    rw [aeval_pderiv_affineChartEquation_eq_eval_map (L := L)]
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
  refine not_specializeSecondCoordinates_map_eq_zero_of_global_smooth_of_geometric
    (L := AlgebraicClosure K) m n K F hF hF0 hd he hnm j
    (fun l => algebraMap K (AlgebraicClosure K) (y l)) (by simp [hyj]) ?_
  rw [← map_specializeSecondCoordinates, hzero, map_zero]

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

/-- **On a smooth nonzero bidegree-`(2,3)` threefold no second-projection fiber over a nonzero
point of an algebraically closed extension is the whole first projective plane.**

This is the hypothesis `span_range_coeff_baseChangedChartEquation_id_eq_top_of_geometric` asks
for.  The point is not assumed normalized: bihomogeneity rescales it. -/
theorem not_specializeSecondCoordinates_map_eq_zero_of_smooth_bidegree23_of_geometric
    (K : Type u) [Field K] {L : Type u} [Field L] [IsAlgClosed L] [Algebra K L]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (y : Fin 3 → L) (hy : y ≠ 0) :
    specializeSecondCoordinates (m := 2) y (MvPolynomial.map (algebraMap K L) F) ≠ 0 := by
  intro hzero
  obtain ⟨j, hj⟩ := _root_.BConicBundleMultisections.exists_normalizing_coordinate y hy
  refine not_specializeSecondCoordinates_map_eq_zero_of_global_smooth_of_geometric
    (L := L) 2 2 K F hF hF0 (by norm_num) (by norm_num) (by norm_num) j
    (_root_.BConicBundleMultisections.normalizeCoordinateRepresentative y j)
    (_root_.BConicBundleMultisections.normalizeCoordinateRepresentative_apply y j hj) ?_
  have hsmul := (hF.map_coefficients (algebraMap K L)).specializeSecondCoordinates_smul
    (y j)⁻¹ y
  rw [_root_.BConicBundleMultisections.normalizeCoordinateRepresentative, hsmul, hzero, mul_zero]

/-- The first-block companion of the previous statement. -/
theorem not_specializeFirstCoordinates_map_eq_zero_of_smooth_bidegree23_of_geometric
    (K : Type u) [Field K] {L : Type u} [Field L] [IsAlgClosed L] [Algebra K L]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (x : Fin 3 → L) (hx : x ≠ 0) :
    specializeFirstCoordinates (n := 2) x (MvPolynomial.map (algebraMap K L) F) ≠ 0 := by
  intro hzero
  obtain ⟨i, hi⟩ := _root_.BConicBundleMultisections.exists_normalizing_coordinate x hx
  refine not_specializeFirstCoordinates_map_eq_zero_of_global_smooth_of_geometric
    (L := L) 2 2 K F hF hF0 (by norm_num) (by norm_num) (by norm_num) i
    (_root_.BConicBundleMultisections.normalizeCoordinateRepresentative x i)
    (_root_.BConicBundleMultisections.normalizeCoordinateRepresentative_apply x i hi) ?_
  have hsmul := (hF.map_coefficients (algebraMap K L)).specializeFirstCoordinates_smul
    (x i)⁻¹ x
  rw [_root_.BConicBundleMultisections.normalizeCoordinateRepresentative, hsmul, hzero, mul_zero]

end BiprojectiveSpace

end

end BConicBundleMultisections
