/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveFiberPolynomial
public import BConicBundleMultisections.BiprojectiveNoWholeFiber
public import BConicBundleMultisections.ProjectiveCommonZero

/-!
# Nonempty specialized fibers of a smooth `(2,3)` threefold

On a smooth nonzero bidegree-`(2,3)` hypersurface, specialized fibers of either projection are
nonzero positive-degree homogeneous forms, hence have a nonzero zero over an algebraically closed
field.  This is the polynomial substrate for projection surjectivity.
-/

@[expose] public section

open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

open _root_.MvPolynomial AlgebraicGeometry

universe u

namespace BiprojectiveSpace

/-- A positive-degree homogeneous form in at least two variables over an algebraically closed
field has a nonzero zero. -/
theorem exists_nonzero_zero_of_isHomogeneous
    {K : Type u} {σ : Type*} [Field K] [IsAlgClosed K] [Finite σ]
    {f : MvPolynomial σ K} {d : ℕ}
    (hf : f.IsHomogeneous d) (hd : 0 < d) (hσ : 1 < Nat.card σ) :
    ∃ x : σ → K, x ≠ 0 ∧ eval x f = 0 := by
  classical
  obtain ⟨x, hx, hxs⟩ := exists_common_nonzero_zero_of_card_lt
    ({f} : Finset (MvPolynomial σ K))
    (by
      intro g hg
      simp only [Finset.mem_singleton] at hg
      subst g
      exact ⟨d, hd, hf⟩)
    (by simpa using hσ)
  exact ⟨x, hx, hxs f (Finset.mem_singleton_self _)⟩

/-- On a smooth nonzero bidegree-`(2,3)` threefold, every normalized specialization of the first
coordinate block has a nonzero second-block zero of the equation. -/
theorem exists_secondCoordinates_zero_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (i : Fin 3) (x : Fin 3 → K) (hxi : x i = 1) :
    ∃ y : Fin 3 → K, y ≠ 0 ∧ eval (Sum.elim x y) F = 0 := by
  have hne :
      specializeFirstCoordinates (n := 2) x F ≠ 0 :=
    not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23
      K F hF hF0 i x hxi
  have hhom :
      (specializeFirstCoordinates (n := 2) x F).IsHomogeneous 3 :=
    hF.specializeFirstCoordinates_isHomogeneous x
  obtain ⟨y, hy, hyF⟩ := exists_nonzero_zero_of_isHomogeneous
    hhom (by norm_num : (0 : ℕ) < 3)
    (by simp [Nat.card_eq_fintype_card, Fintype.card_fin] : 1 < Nat.card (Fin 3))
  refine ⟨y, hy, ?_⟩
  rwa [← eval_specializeFirstCoordinates]

/-- On a smooth nonzero bidegree-`(2,3)` threefold, every normalized specialization of the second
coordinate block has a nonzero first-block zero of the equation. -/
theorem exists_firstCoordinates_zero_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (j : Fin 3) (y : Fin 3 → K) (hyj : y j = 1) :
    ∃ x : Fin 3 → K, x ≠ 0 ∧ eval (Sum.elim x y) F = 0 := by
  have hne :
      specializeSecondCoordinates (m := 2) y F ≠ 0 :=
    not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23
      K F hF hF0 j y hyj
  have hhom :
      (specializeSecondCoordinates (m := 2) y F).IsHomogeneous 2 :=
    hF.specializeSecondCoordinates_isHomogeneous y
  obtain ⟨x, hx, hxF⟩ := exists_nonzero_zero_of_isHomogeneous
    hhom (by norm_num : (0 : ℕ) < 2)
    (by simp [Nat.card_eq_fintype_card, Fintype.card_fin] : 1 < Nat.card (Fin 3))
  refine ⟨x, hx, ?_⟩
  rwa [← eval_specializeSecondCoordinates]

end BiprojectiveSpace

end

end BConicBundleMultisections
