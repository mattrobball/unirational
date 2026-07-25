/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.LinearSubstitution
public import BConicBundleMultisections.ProjectiveSpaceCoeffMap
public import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

/-!
# Linear changes of homogeneous coordinates

Foundation for work package WP-5 of `PLAN.md`.  The source proof **chooses** the multisection line
`L` outside an explicit bad locus and only afterwards normalises coordinates so that
`L = {W = 0}` (§5); this development hardcodes the normalisation.  Recovering the choice means
being able to move `L` into coordinate position, i.e. acting on `ℙ²_y` by `PGL₃`.

This module supplies the first half: a linear substitution `X j ↦ ∑ l, M j l · X l` as a **graded**
ring homomorphism of the homogeneous coordinate ring, and the `Proj.map` hypothesis it needs.  The
construction mirrors `ProjectiveSpaceCoeffMap.lean`, which does the same for a coefficient ring
homomorphism; only the ring map changes.

Substitution by linear forms preserves homogeneity by `MvPolynomial.IsHomogeneous.aeval` with
`n = 1`, and an invertible matrix hits the irrelevant ideal because each `X i` is the image of the
linear form built from the inverse matrix.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open CategoryTheory
open AlgebraicGeometry HomogeneousIdeal MvPolynomial ProjectiveSpace

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k : Type u} [CommRing k]

/-- A linear change of homogeneous coordinates, as a graded ring homomorphism.

Homogeneity is preserved because substituting degree-one forms multiplies degrees by one
(`MvPolynomial.IsHomogeneous.aeval`). -/
def linearSubstGradedRingHom (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) k) :
    (homogeneousSubmodule (Fin (n + 1)) k) →+*ᵍ (homogeneousSubmodule (Fin (n + 1)) k) where
  toRingHom :=
    (aeval (linearSubst n M) :
      MvPolynomial (Fin (n + 1)) k →ₐ[k] MvPolynomial (Fin (n + 1)) k).toRingHom
  map_mem {i} {a} ha := by
    have h := (ha : a.IsHomogeneous i).aeval (linearSubst n M) (isHomogeneous_linearSubst n M)
    simpa using h

@[simp]
theorem linearSubstGradedRingHom_apply (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (p : MvPolynomial (Fin (n + 1)) k) :
    linearSubstGradedRingHom n M p
      = (aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) k →ₐ[k] _) p := rfl

@[simp]
theorem linearSubstGradedRingHom_X (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (j : Fin (n + 1)) :
    (linearSubstGradedRingHom n M).toRingHom (X j) = linearSubst n M j := by
  simp [linearSubstGradedRingHom]

/-- The graded ring hom of the identity matrix is the identity. -/
@[simp]
theorem linearSubstGradedRingHom_one (n : ℕ) :
    linearSubstGradedRingHom n (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
      = GradedRingHom.id _ := by
  refine GradedRingHom.ext fun p => ?_
  simp only [linearSubstGradedRingHom_apply, GradedRingHom.id_apply, linearSubst_one]
  exact MvPolynomial.aeval_X_left_apply p

/-- Composing linear coordinate changes multiplies the matrices. -/
theorem linearSubstGradedRingHom_comp (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k) :
    (linearSubstGradedRingHom n M).comp (linearSubstGradedRingHom n N)
      = linearSubstGradedRingHom n (N * M) := by
  refine GradedRingHom.ext fun p => ?_
  simp only [GradedRingHom.comp_apply, linearSubstGradedRingHom_apply]
  induction p using MvPolynomial.induction_on with
  | C a => simp
  | add p q hp hq => simp [hp, hq]
  | mul_X p j hp =>
      simp only [map_mul, aeval_X, hp, aeval_linearSubst_linearSubst]

/-- An invertible linear substitution satisfies the hypothesis `Proj.map` requires: the irrelevant
ideal is contained in the image of the irrelevant ideal. -/
theorem irrelevant_le_map_linearSubst (n : ℕ) (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (h : N * M = 1) :
    (homogeneousSubmodule (Fin (n + 1)) k)₊ ≤
      ((homogeneousSubmodule (Fin (n + 1)) k)₊).map (linearSubstGradedRingHom n M) := by
  rw [← toIdeal_le_toIdeal_iff]
  intro x hx
  have hxspan : x ∈ Ideal.span (Set.range (X : Fin (n + 1) → MvPolynomial (Fin (n + 1)) k)) :=
    ProjectiveSpace.irrelevant_le_span_X n k hx
  have hgen :
      Ideal.span (Set.range (X : Fin (n + 1) → MvPolynomial (Fin (n + 1)) k)) ≤
        Ideal.map (linearSubstGradedRingHom n M).toRingHom
          ((homogeneousSubmodule (Fin (n + 1)) k)₊).toIdeal := by
    apply Ideal.span_le.mpr
    rintro z ⟨i, rfl⟩
    have hpre : ((∑ j : Fin (n + 1), C (N i j) * X j) : MvPolynomial (Fin (n + 1)) k) ∈
        ((homogeneousSubmodule (Fin (n + 1)) k)₊).toIdeal := by
      refine mem_irrelevant_of_mem (𝒜 := homogeneousSubmodule (Fin (n + 1)) k)
        (by decide : (0 : ℕ) < 1) ?_
      exact isHomogeneous_linearSubst n N i
    have hX : (X i : MvPolynomial (Fin (n + 1)) k) =
        (linearSubstGradedRingHom n M).toRingHom (∑ j : Fin (n + 1), C (N i j) * X j) :=
      (aeval_linearSubst_inverse_row n M N h i).symm
    rw [hX]
    exact Ideal.mem_map_of_mem _ hpre
  exact hgen hxspan

/-- The automorphism of `ℙⁿ_k` induced by an invertible linear change of homogeneous
coordinates. -/
def mapLinearSubst (n : ℕ) (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k) (h : N * M = 1) :
    ProjectiveSpace n k ⟶ ProjectiveSpace n k :=
  Proj.map (linearSubstGradedRingHom n M) (irrelevant_le_map_linearSubst n M N h)

/-- `Proj.map` depends on its hypothesis only through proof irrelevance, so equal graded ring homs
give equal morphisms.  `rw` cannot see this — the hypothesis argument is dependent — so the
triangle identities below go through this helper. -/
private theorem proj_map_congr (n : ℕ)
    {f g : (homogeneousSubmodule (Fin (n + 1)) k) →+*ᵍ (homogeneousSubmodule (Fin (n + 1)) k)}
    (h : f = g) (hf) (hg) : Proj.map f hf = Proj.map g hg := by
  subst h; rfl

/-- **An invertible linear change of coordinates is an automorphism of `ℙⁿ_k`.**

The triangle identities come from Mathlib's `Proj.map_comp` and `Proj.map_id` together with the
composition law `linearSubstGradedRingHom_comp` and the identity `linearSubstGradedRingHom_one`. -/
def mapLinearSubstIso (n : ℕ) (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (h1 : N * M = 1) (h2 : M * N = 1) :
    ProjectiveSpace n k ≅ ProjectiveSpace n k where
  hom := mapLinearSubst n M N h1
  inv := mapLinearSubst n N M h2
  hom_inv_id := by
    have hc : (linearSubstGradedRingHom n M).comp (linearSubstGradedRingHom n N)
        = GradedRingHom.id _ := by
      rw [linearSubstGradedRingHom_comp, h1, linearSubstGradedRingHom_one]
    rw [mapLinearSubst, mapLinearSubst, ← Proj.map_comp,
      proj_map_congr n hc _ (by simp), Proj.map_id]
  inv_hom_id := by
    have hc : (linearSubstGradedRingHom n N).comp (linearSubstGradedRingHom n M)
        = GradedRingHom.id _ := by
      rw [linearSubstGradedRingHom_comp, h2, linearSubstGradedRingHom_one]
    rw [mapLinearSubst, mapLinearSubst, ← Proj.map_comp,
      proj_map_congr n hc _ (by simp), Proj.map_id]

end

end BConicBundleMultisections
