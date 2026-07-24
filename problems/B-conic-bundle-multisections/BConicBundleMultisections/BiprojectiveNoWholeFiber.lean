/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineJacobian
public import BConicBundleMultisections.BiprojectiveDehomogenization
public import BConicBundleMultisections.BiprojectiveWholeFiberGradient

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

/-- Under global smoothness, a nonzero bihomogeneous equation cannot vanish identically after
specializing the first coordinate block at a normalized point, provided there are fewer left
affine coordinates than right homogeneous coordinates. -/
theorem not_specializeFirstCoordinates_eq_zero_of_global_smooth
    (m n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0)
    (hd : 0 < d) (he : 0 < e) (hmn : m < n + 1)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)]
    (i : Fin (m + 1)) (x : Fin (m + 1) → K) (hxi : x i = 1) :
    specializeFirstCoordinates (n := n) x F ≠ 0 := by
  intro hzero
  obtain ⟨j, y, hyj, hval, hgrad⟩ :=
    exists_affineChart_singular_point_of_specializeFirst_eq_zero
      hF hd he i x hxi hzero hmn
  have hne : affineChartEquation m n K i j F ≠ 0 :=
    affineChartEquation_ne_zero m n K i j F hF hF0
  have hcontra :=
    no_common_zero_affineChartEquation_and_pderiv_of_global_smooth
      m n K F hF i j hne (affineChartPoint i j x y)
  refine hcontra ⟨?_, ?_⟩
  · simpa using hval
  · intro k
    simpa using hgrad k

/-- Under global smoothness, a nonzero bihomogeneous equation cannot vanish identically after
specializing the second coordinate block at a normalized point, provided there are fewer right
affine coordinates than left homogeneous coordinates. -/
theorem not_specializeSecondCoordinates_eq_zero_of_global_smooth
    (m n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0)
    (hd : 0 < d) (he : 0 < e) (hnm : n < m + 1)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)]
    (j : Fin (n + 1)) (y : Fin (n + 1) → K) (hyj : y j = 1) :
    specializeSecondCoordinates (m := m) y F ≠ 0 := by
  intro hzero
  obtain ⟨i, x, hxi, hval, hgrad⟩ :=
    exists_affineChart_singular_point_of_specializeSecond_eq_zero
      hF hd he j y hyj hzero hnm
  have hne : affineChartEquation m n K i j F ≠ 0 :=
    affineChartEquation_ne_zero m n K i j F hF hF0
  have hcontra :=
    no_common_zero_affineChartEquation_and_pderiv_of_global_smooth
      m n K F hF i j hne (affineChartPoint i j x y)
  refine hcontra ⟨?_, ?_⟩
  · simpa using hval
  · intro k
    simpa using hgrad k

/-- On a smooth nonzero bidegree-`(2,3)` threefold, no first-projection fiber is the whole
second projective plane. -/
theorem not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
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
    (K : Type u) [Field K] [IsAlgClosed K]
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
