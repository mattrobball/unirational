/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveFiberNonempty
public import BConicBundleMultisections.BiprojectiveSpaceProperties
public import BConicBundleMultisections.BiprojectiveZeroLocus
public import Mathlib.AlgebraicGeometry.Morphisms.FiniteType
public import Mathlib.AlgebraicGeometry.Morphisms.UniversallyClosed
public import Mathlib.Topology.JacobsonSpace

/-!
# Dominance and surjectivity of biprojective projections (WP2)

A universally closed morphism to a Jacobson space is surjective once every closed point of the
target lies in the image.  Over a field, projective space is Jacobson, and the zero-locus
projections are proper.  Polynomial fiber nonemptiness for smooth bidegree-`(2,3)` hypersurfaces
supplies the k-point lifting of every normalized coordinate tuple.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace AlgebraicGeometry

variable {X Y : Scheme.{u}} (f : X ⟶ Y)

/-- A universally closed morphism to a Jacobson space is surjective once every closed point of the
target lies in its image.

The image is closed, contains the closed points, and therefore contains their closure, which is
the whole space.
-/
theorem Surjective.of_universallyClosed_of_closedPoints
    [UniversallyClosed f] [JacobsonSpace Y]
    (h : closedPoints Y ⊆ Set.range f) : Surjective f := by
  rw [surjective_iff, ← Set.range_eq_univ]
  have hcl : IsClosed (Set.range f) := f.isClosedMap.isClosed_range
  have hdense : closure (closedPoints Y) = (Set.univ : Set Y) :=
    closure_closedPoints
  have hsub : Set.univ ⊆ Set.range f := by
    rw [← hdense]
    exact hcl.closure_subset_iff.mpr h
  exact Set.univ_subset_iff.mp hsub

/-- Proper morphisms to Jacobson spaces are surjective once closed points of the target are hit. -/
theorem Surjective.of_isProper_of_closedPoints
    [IsProper f] [JacobsonSpace Y]
    (h : closedPoints Y ⊆ Set.range f) : Surjective f :=
  Surjective.of_universallyClosed_of_closedPoints f h

end AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry BiprojectiveSpace ProjectiveSpace

attribute [local instance] MvPolynomial.gradedAlgebra

/-! ### Jacobson ambient space -/

/-- Projective space over a field is Jacobson (locally of finite type over a field). -/
instance (n : ℕ) (k : Type u) [Field k] :
    JacobsonSpace (ProjectiveSpace n k) :=
  LocallyOfFiniteType.jacobsonSpace (toSpec n k)

/-! ### Polynomial-level k-point surjectivity (smooth `(2,3)`) -/

/-- **k-point surjectivity of the second projection (polynomial form).**

Every normalized `k`-point of `ℙ²_y` lifts through a smooth nonzero bidegree-`(2,3)` equation.
This is the classical surjectivity of the conic fibration on rational points.
-/
theorem exists_lift_secondProjection_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (j : Fin 3) (y : Fin 3 → K) (hyj : y j = 1) :
    ∃ x : Fin 3 → K, x ≠ 0 ∧ MvPolynomial.eval (Sum.elim x y) F = 0 :=
  exists_firstCoordinates_zero_of_smooth_bidegree23 K F hF hF0 j y hyj

/-- **k-point surjectivity of the first projection (polynomial form).** -/
theorem exists_lift_firstProjection_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (i : Fin 3) (x : Fin 3 → K) (hxi : x i = 1) :
    ∃ y : Fin 3 → K, y ≠ 0 ∧ MvPolynomial.eval (Sum.elim x y) F = 0 :=
  exists_secondCoordinates_zero_of_smooth_bidegree23 K F hF hF0 i x hxi

/-! ### Scheme-level criterion for the zero-locus projections -/

/-- Surjectivity of the conic projection reduces to closed-point membership of the image, by the
proper/Jacobson criterion. -/
theorem surjective_biprojectiveZeroLocusSnd_of_closedPoints
    (K : Type u) [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (h : closedPoints (ProjectiveSpace 2 K) ⊆
      Set.range (biprojectiveZeroLocusSnd 2 2 K F)) :
    Surjective (biprojectiveZeroLocusSnd 2 2 K F) :=
  Surjective.of_isProper_of_closedPoints _ h

/-- Surjectivity of the cubic projection reduces to closed-point membership of the image. -/
theorem surjective_biprojectiveZeroLocusFst_of_closedPoints
    (K : Type u) [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (h : closedPoints (ProjectiveSpace 2 K) ⊆
      Set.range (biprojectiveZeroLocusFst 2 2 K F)) :
    Surjective (biprojectiveZeroLocusFst 2 2 K F) :=
  Surjective.of_isProper_of_closedPoints _ h

/-- Dominance follows from surjectivity of the conic projection. -/
theorem isDominant_biprojectiveZeroLocusSnd_of_surjective
    (K : Type u) [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    [Surjective (biprojectiveZeroLocusSnd 2 2 K F)] :
    IsDominant (biprojectiveZeroLocusSnd 2 2 K F) :=
  inferInstance

/-- Dominance follows from surjectivity of the cubic projection. -/
theorem isDominant_biprojectiveZeroLocusFst_of_surjective
    (K : Type u) [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    [Surjective (biprojectiveZeroLocusFst 2 2 K F)] :
    IsDominant (biprojectiveZeroLocusFst 2 2 K F) :=
  inferInstance

/--
**WP2 package for smooth bidegree-`(2,3)` projections.**

1. Zero-locus projections are proper (hence universally closed).
2. The target projective space is Jacobson over a field.
3. Polynomial fiber nonemptiness gives k-point lifting of every normalized coordinate tuple
   (no whole fibers + alg-closed zeros of positive-degree forms).
4. Scheme-level surjectivity of the conic projection for smooth nonzero bidegree-`(2,3)` is
   obtained in `BiprojectiveZeroLocusClosedPoints` by lifting every closed point through chart
   evaluation and applying the closed-point criterion above.  See
   `surjective_biprojectiveZeroLocusSnd_of_smooth_bidegree23` and
   `isDominant_biprojectiveZeroLocusSnd_of_smooth_bidegree23`.
-/
theorem wp2_projection_package_summary
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    IsProper (biprojectiveZeroLocusSnd 2 2 K F) ∧
      IsProper (biprojectiveZeroLocusFst 2 2 K F) ∧
      JacobsonSpace (ProjectiveSpace 2 K) ∧
      (∀ (j : Fin 3) (y : Fin 3 → K), y j = 1 →
        ∃ x : Fin 3 → K, x ≠ 0 ∧ MvPolynomial.eval (Sum.elim x y) F = 0) ∧
      (∀ (i : Fin 3) (x : Fin 3 → K), x i = 1 →
        ∃ y : Fin 3 → K, y ≠ 0 ∧ MvPolynomial.eval (Sum.elim x y) F = 0) := by
  refine ⟨inferInstance, inferInstance, inferInstance, ?_, ?_⟩
  · intro j y hy
    exact exists_lift_secondProjection_of_smooth_bidegree23 K F hF hF0 j y hy
  · intro i x hx
    exact exists_lift_firstProjection_of_smooth_bidegree23 K F hF hF0 i x hx

end

end BConicBundleMultisections
