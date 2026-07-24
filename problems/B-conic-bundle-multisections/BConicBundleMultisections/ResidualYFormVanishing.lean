/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ChartHomogenization
public import BConicBundleMultisections.ProjectiveSpaceAlgebraPoint
public import BConicBundleMultisections.ResidualImageRationalParam

/-!
# Forms vanishing on the residual `Y`-coordinates

The residual `Y`-coordinates `residualYCoords F v : Fin 3 → k[t,s]` are the homogeneous
coordinates of the tangent-residual point, as a function of the two parameters of the vertical
surface `S_L`.  Whether the residual surface dominates the conic-bundle base `ℙ²_y` is exactly the
question of whether some nonzero **form** in three variables vanishes on them.

This module contains the mechanical half of that translation, with the geometric statement left as
a hypothesis `hcore`:

* `aeval_residualYCoordsLoc` — evaluation at the localized coordinates is the localization of
  evaluation over `k[t,s]`;
* `eq_zero_of_aeval_residualYCoordsNorm_of_isHomogeneous` — chart normalization (dividing by the
  `j`-th coordinate in `Away (residualChartDenom …)`) creates no new relations among forms, because
  a degree-`d` form only picks up the `d`-th power of the unit scaling factor and the localization
  map of a domain away from a nonzero element is injective;
* `injective_standardChartEvalAlgebra_residualYCoordsNorm` — combined with
  `ProjectiveSpace.injective_aeval_affineCoordinates`, "no nonzero form vanishes" upgrades to
  injectivity of the whole chart evaluation `StandardChartRing 2 k j →+* Away (…)`.

The consumer is `ResidualComponentHorizontality`, where `hcore` is the outstanding obligation.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k : Type u} [Field k]

/-- Algebra evaluation of a `Y`-form at the localized residual `Y`-coordinates is the image, under
the localization map, of its evaluation over `k[t,s]`.

Same induction as `aeval_comp_algebraMap_residualCoords`, for the second block alone. -/
theorem aeval_residualYCoordsLoc
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) (Ψ : MvPolynomial (Fin 3) k) :
    aeval (residualYCoordsLoc F v i j) Ψ =
      algebraMap (affineTwoRing k) (residualChartLoc F v i j)
        (aeval (residualYCoords F v) Ψ) := by
  induction Ψ using MvPolynomial.induction_on with
  | C a =>
      simp only [aeval_C, algebraMap_k_residualChartLoc, algebraMap_eq]
  | add p q hp hq =>
      simp only [map_add, hp, hq]
  | mul_X p z hp =>
      simp only [map_mul, aeval_X, hp, residualYCoordsLoc]

/--
**Chart normalization creates no relations.**

If no nonzero form vanishes on the residual `Y`-coordinates over `k[t,s]`, then none vanishes on
their chart-normalized images in `Away (residualChartDenom F v i j)`.

Two ingredients: a degree-`d` form evaluated at a uniformly rescaled point picks up the `d`-th power
of the scaling factor, which here is a unit; and `k[t,s]` is a domain, so localizing away from the
nonzero `residualChartDenom` is injective.
-/
theorem eq_zero_of_aeval_residualYCoordsNorm_of_isHomogeneous
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0)
    (hcore : ∀ (d : ℕ) (Ψ : MvPolynomial (Fin 3) k), Ψ.IsHomogeneous d →
      aeval (residualYCoords F v) Ψ = 0 → Ψ = 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) k) (hΨ : Ψ.IsHomogeneous d)
    (h : aeval (residualYCoordsNorm F v i j) Ψ = 0) :
    Ψ = 0 := by
  have hunit := isUnit_residualYCoordsLoc F v i j
  have hnorm : residualYCoordsNorm F v i j =
      fun t => (↑hunit.unit⁻¹ : residualChartLoc F v i j) * residualYCoordsLoc F v i j t := rfl
  rw [hnorm, aeval_smul_point_of_isHomogeneous hΨ, aeval_residualYCoordsLoc] at h
  have hcd : IsUnit ((↑hunit.unit⁻¹ : residualChartLoc F v i j) ^ d) :=
    (Units.isUnit hunit.unit⁻¹).pow d
  have h0 : algebraMap (affineTwoRing k) (residualChartLoc F v i j)
      (aeval (residualYCoords F v) Ψ) = 0 := (hcd.mul_right_eq_zero).mp h
  have hinj : Function.Injective
      (algebraMap (affineTwoRing k) (residualChartLoc F v i j)) :=
    IsLocalization.injective (M := Submonoid.powers (residualChartDenom F v i j))
      (residualChartLoc F v i j)
      (powers_le_nonZeroDivisors_of_noZeroDivisors hdenom)
  exact hcore d Ψ hΨ (hinj (by rw [h0, map_zero]))

/--
**The chart evaluation at the normalized residual `Y`-coordinates is injective.**

This is obligation 2 in ring-theoretic form: the chart ring of `ℙ²_y` at `j` injects into the
residual chart ring `Away (residualChartDenom F v i j)`.

It follows from `hcore` — no nonzero form vanishes on the residual `Y`-coordinates — by
homogenizing (`ProjectiveSpace.injective_aeval_affineCoordinates`) and then normalizing
(`eq_zero_of_aeval_residualYCoordsNorm_of_isHomogeneous`).  `standardChartEvalAlgebra` is
`aeval` at the affine coordinates precomposed with a ring **equivalence**, so nothing else is left.
-/
theorem injective_standardChartEvalAlgebra_residualYCoordsNorm
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0)
    (hcore : ∀ (d : ℕ) (Ψ : MvPolynomial (Fin 3) k), Ψ.IsHomogeneous d →
      aeval (residualYCoords F v) Ψ = 0 → Ψ = 0) :
    Function.Injective
      (ProjectiveSpace.standardChartEvalAlgebra (R := k) 2 j (residualYCoordsNorm F v i j)) := by
  have haff : Function.Injective
      (aeval (ProjectiveSpace.affineCoordinates j (residualYCoordsNorm F v i j)) :
        MvPolynomial (Fin 2) k →ₐ[k] residualChartLoc F v i j) :=
    ProjectiveSpace.injective_aeval_affineCoordinates (R := k) j
      (residualYCoordsNorm F v i j) (residualYCoordsNorm_apply F v i j)
      (fun d Ψ hΨ hvan =>
        eq_zero_of_aeval_residualYCoordsNorm_of_isHomogeneous F v i j hdenom hcore d Ψ hΨ hvan)
  intro a b hab
  exact (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j).injective (haff hab)

end

end BConicBundleMultisections
