/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineJacobian
public import BConicBundleMultisections.BiprojectiveFiberPolynomial
public import BConicBundleMultisections.ProjectiveCommonZero
public import BConicBundleMultisections.ProjectiveCoordinateNormalization

/-!
# Singular coordinate points forced by an identically zero biprojective fiber

If a bihomogeneous equation vanishes identically after one coordinate block is fixed, all
partials in the other block vanish identically.  Euler's identity makes one partial in the fixed
block dependent on the others.  When there are fewer remaining partial equations than opposite
homogeneous coordinates, the projective common-zero theorem therefore supplies a nonzero point
where the entire coordinate gradient vanishes.

This is a polynomial theorem.  The later Jacobian comparison turns the resulting coordinate
point into a contradiction with scheme-theoretic smoothness.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open _root_.MvPolynomial

universe u

/-- An identically zero fiber after fixing the first coordinate block forces a nonzero point in
the second block at which the equation and every coordinate partial vanish. -/
theorem exists_nonzero_secondCoordinates_gradient_eq_zero_of_specializeFirst_eq_zero
    {m n d e : ℕ} {K : Type u} [Field K] [IsAlgClosed K]
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F) (hd : 0 < d) (he : 0 < e)
    (i : Fin (m + 1)) (x : Fin (m + 1) → K) (hxi : x i = 1)
    (hzero : specializeFirstCoordinates (n := n) x F = 0)
    (hmn : m < n + 1) :
    ∃ y : Fin (n + 1) → K, y ≠ 0 ∧
      eval (Sum.elim x y) F = 0 ∧
      ∀ z : BiprojectiveCoordinate m n,
        eval (Sum.elim x y) (pderiv z F) = 0 := by
  classical
  let s : Finset (MvPolynomial (Fin (n + 1)) K) :=
    Finset.univ.image fun r : Fin m ↦
      specializeFirstCoordinates (n := n) x
        (pderiv (.inl (i.succAbove r)) F)
  have hs : ∀ p ∈ s, ∃ q : ℕ, 0 < q ∧ p.IsHomogeneous q := by
    intro p hp
    obtain ⟨r, -, rfl⟩ := Finset.mem_image.mp hp
    exact ⟨e, he,
      hF.specializeFirstCoordinates_pderiv_inl_isHomogeneous hd x
        (i.succAbove r)⟩
  have hcard : s.card < Nat.card (Fin (n + 1)) := by
    calc
      s.card ≤ Finset.univ.card := Finset.card_image_le
      _ = m := Fintype.card_fin m
      _ < Nat.card (Fin (n + 1)) := by simpa using hmn
  obtain ⟨y, hy, hys⟩ :=
    exists_common_nonzero_zero_of_card_lt s hs hcard
  refine ⟨y, hy, ?_, ?_⟩
  · rw [← eval_specializeFirstCoordinates, hzero, map_zero]
  · rintro (l | l)
    · rw [← eval_specializeFirstCoordinates]
      rcases Fin.eq_self_or_eq_succAbove i l with hli | ⟨r, hlr⟩
      · subst l
        apply hF.eval_specializeFirstCoordinates_pderiv_inl_eq_zero
          x i hxi hzero y
        intro l hli
        rcases Fin.eq_self_or_eq_succAbove i l with hli' | ⟨r, hlr⟩
        · exact (hli hli').elim
        · subst l
          exact hys _ (Finset.mem_image.mpr ⟨r, Finset.mem_univ _, rfl⟩)
      · subst l
        exact hys _ (Finset.mem_image.mpr ⟨r, Finset.mem_univ _, rfl⟩)
    · rw [← eval_specializeFirstCoordinates,
        specializeFirstCoordinates_pderiv_inr_eq_zero x hzero l, map_zero]

/-- The singular second-block point forced by an identically zero first-projection fiber may be
chosen with one homogeneous coordinate normalized to one. -/
theorem exists_normalized_secondCoordinates_gradient_eq_zero_of_specializeFirst_eq_zero
    {m n d e : ℕ} {K : Type u} [Field K] [IsAlgClosed K]
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F) (hd : 0 < d) (he : 0 < e)
    (i : Fin (m + 1)) (x : Fin (m + 1) → K) (hxi : x i = 1)
    (hzero : specializeFirstCoordinates (n := n) x F = 0)
    (hmn : m < n + 1) :
    ∃ (j : Fin (n + 1)) (y : Fin (n + 1) → K),
      y ≠ 0 ∧ y j = 1 ∧ eval (Sum.elim x y) F = 0 ∧
        ∀ z : BiprojectiveCoordinate m n,
          eval (Sum.elim x y) (pderiv z F) = 0 := by
  obtain ⟨y₀, hy₀, hF₀, hgrad₀⟩ :=
    exists_nonzero_secondCoordinates_gradient_eq_zero_of_specializeFirst_eq_zero
      hF hd he i x hxi hzero hmn
  obtain ⟨j, hy₀j⟩ := exists_normalizing_coordinate y₀ hy₀
  let y := normalizeCoordinateRepresentative y₀ j
  have hy : y ≠ 0 := normalizeCoordinateRepresentative_ne_zero y₀ j hy₀ hy₀j
  have hyj : y j = 1 := normalizeCoordinateRepresentative_apply y₀ j hy₀j
  refine ⟨j, y, hy, hyj, ?_, ?_⟩
  · rw [← eval_specializeFirstCoordinates]
    apply eval_normalizeCoordinateRepresentative_eq_zero
      (hF.specializeFirstCoordinates_isHomogeneous x) y₀ j
    rwa [eval_specializeFirstCoordinates]
  · rintro (l | l)
    · rw [← eval_specializeFirstCoordinates]
      apply eval_normalizeCoordinateRepresentative_eq_zero
        (hF.specializeFirstCoordinates_pderiv_inl_isHomogeneous hd x l) y₀ j
      rw [eval_specializeFirstCoordinates]
      exact hgrad₀ (.inl l)
    · rw [← eval_specializeFirstCoordinates]
      apply eval_normalizeCoordinateRepresentative_eq_zero
        ((hF.pderiv_inr he l).specializeFirstCoordinates_isHomogeneous x) y₀ j
      rw [eval_specializeFirstCoordinates]
      exact hgrad₀ (.inr l)

/-- An identically zero first-projection fiber produces a singular point of an explicit affine
chart equation. -/
theorem exists_affineChart_singular_point_of_specializeFirst_eq_zero
    {m n d e : ℕ} {K : Type u} [Field K] [IsAlgClosed K]
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F) (hd : 0 < d) (he : 0 < e)
    (i : Fin (m + 1)) (x : Fin (m + 1) → K) (hxi : x i = 1)
    (hzero : specializeFirstCoordinates (n := n) x F = 0)
    (hmn : m < n + 1) :
    ∃ (j : Fin (n + 1)) (y : Fin (n + 1) → K), y j = 1 ∧
      eval (BiprojectiveSpace.affineChartPoint i j x y)
          (BiprojectiveSpace.affineChartEquation m n K i j F) = 0 ∧
        ∀ q : Fin m ⊕ Fin n,
          eval (BiprojectiveSpace.affineChartPoint i j x y)
            (pderiv q (BiprojectiveSpace.affineChartEquation m n K i j F)) = 0 := by
  obtain ⟨j, y, -, hyj, hvalue, hgradient⟩ :=
    exists_normalized_secondCoordinates_gradient_eq_zero_of_specializeFirst_eq_zero
      hF hd he i x hxi hzero hmn
  exact ⟨j, y, hyj,
    BiprojectiveSpace.affineChartEquation_vanishing_and_gradient_eq_zero
      m n K i j x y hxi hyj F hvalue hgradient⟩

/-- An identically zero fiber after fixing the second coordinate block forces a nonzero point in
the first block at which the equation and every coordinate partial vanish. -/
theorem exists_nonzero_firstCoordinates_gradient_eq_zero_of_specializeSecond_eq_zero
    {m n d e : ℕ} {K : Type u} [Field K] [IsAlgClosed K]
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F) (hd : 0 < d) (he : 0 < e)
    (j : Fin (n + 1)) (y : Fin (n + 1) → K) (hyj : y j = 1)
    (hzero : specializeSecondCoordinates (m := m) y F = 0)
    (hnm : n < m + 1) :
    ∃ x : Fin (m + 1) → K, x ≠ 0 ∧
      eval (Sum.elim x y) F = 0 ∧
      ∀ z : BiprojectiveCoordinate m n,
        eval (Sum.elim x y) (pderiv z F) = 0 := by
  classical
  let s : Finset (MvPolynomial (Fin (m + 1)) K) :=
    Finset.univ.image fun r : Fin n ↦
      specializeSecondCoordinates (m := m) y
        (pderiv (.inr (j.succAbove r)) F)
  have hs : ∀ p ∈ s, ∃ q : ℕ, 0 < q ∧ p.IsHomogeneous q := by
    intro p hp
    obtain ⟨r, -, rfl⟩ := Finset.mem_image.mp hp
    exact ⟨d, hd,
      hF.specializeSecondCoordinates_pderiv_inr_isHomogeneous he y
        (j.succAbove r)⟩
  have hcard : s.card < Nat.card (Fin (m + 1)) := by
    calc
      s.card ≤ Finset.univ.card := Finset.card_image_le
      _ = n := Fintype.card_fin n
      _ < Nat.card (Fin (m + 1)) := by simpa using hnm
  obtain ⟨x, hx, hxs⟩ :=
    exists_common_nonzero_zero_of_card_lt s hs hcard
  refine ⟨x, hx, ?_, ?_⟩
  · rw [← eval_specializeSecondCoordinates, hzero, map_zero]
  · rintro (l | l)
    · rw [← eval_specializeSecondCoordinates,
        specializeSecondCoordinates_pderiv_inl_eq_zero y hzero l, map_zero]
    · rw [← eval_specializeSecondCoordinates]
      rcases Fin.eq_self_or_eq_succAbove j l with hlj | ⟨r, hlr⟩
      · subst l
        apply hF.eval_specializeSecondCoordinates_pderiv_inr_eq_zero
          y j hyj hzero x
        intro l hlj
        rcases Fin.eq_self_or_eq_succAbove j l with hlj' | ⟨r, hlr⟩
        · exact (hlj hlj').elim
        · subst l
          exact hxs _ (Finset.mem_image.mpr ⟨r, Finset.mem_univ _, rfl⟩)
      · subst l
        exact hxs _ (Finset.mem_image.mpr ⟨r, Finset.mem_univ _, rfl⟩)

/-- The singular first-block point forced by an identically zero second-projection fiber may be
chosen with one homogeneous coordinate normalized to one. -/
theorem exists_normalized_firstCoordinates_gradient_eq_zero_of_specializeSecond_eq_zero
    {m n d e : ℕ} {K : Type u} [Field K] [IsAlgClosed K]
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F) (hd : 0 < d) (he : 0 < e)
    (j : Fin (n + 1)) (y : Fin (n + 1) → K) (hyj : y j = 1)
    (hzero : specializeSecondCoordinates (m := m) y F = 0)
    (hnm : n < m + 1) :
    ∃ (i : Fin (m + 1)) (x : Fin (m + 1) → K),
      x ≠ 0 ∧ x i = 1 ∧ eval (Sum.elim x y) F = 0 ∧
        ∀ z : BiprojectiveCoordinate m n,
          eval (Sum.elim x y) (pderiv z F) = 0 := by
  obtain ⟨x₀, hx₀, hF₀, hgrad₀⟩ :=
    exists_nonzero_firstCoordinates_gradient_eq_zero_of_specializeSecond_eq_zero
      hF hd he j y hyj hzero hnm
  obtain ⟨i, hx₀i⟩ := exists_normalizing_coordinate x₀ hx₀
  let x := normalizeCoordinateRepresentative x₀ i
  have hx : x ≠ 0 := normalizeCoordinateRepresentative_ne_zero x₀ i hx₀ hx₀i
  have hxi : x i = 1 := normalizeCoordinateRepresentative_apply x₀ i hx₀i
  refine ⟨i, x, hx, hxi, ?_, ?_⟩
  · rw [← eval_specializeSecondCoordinates]
    apply eval_normalizeCoordinateRepresentative_eq_zero
      (hF.specializeSecondCoordinates_isHomogeneous y) x₀ i
    rwa [eval_specializeSecondCoordinates]
  · rintro (l | l)
    · rw [← eval_specializeSecondCoordinates]
      apply eval_normalizeCoordinateRepresentative_eq_zero
        ((hF.pderiv_inl hd l).specializeSecondCoordinates_isHomogeneous y) x₀ i
      rw [eval_specializeSecondCoordinates]
      exact hgrad₀ (.inl l)
    · rw [← eval_specializeSecondCoordinates]
      apply eval_normalizeCoordinateRepresentative_eq_zero
        (hF.specializeSecondCoordinates_pderiv_inr_isHomogeneous he y l) x₀ i
      rw [eval_specializeSecondCoordinates]
      exact hgrad₀ (.inr l)

/-- An identically zero second-projection fiber produces a singular point of an explicit affine
chart equation. -/
theorem exists_affineChart_singular_point_of_specializeSecond_eq_zero
    {m n d e : ℕ} {K : Type u} [Field K] [IsAlgClosed K]
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F) (hd : 0 < d) (he : 0 < e)
    (j : Fin (n + 1)) (y : Fin (n + 1) → K) (hyj : y j = 1)
    (hzero : specializeSecondCoordinates (m := m) y F = 0)
    (hnm : n < m + 1) :
    ∃ (i : Fin (m + 1)) (x : Fin (m + 1) → K), x i = 1 ∧
      eval (BiprojectiveSpace.affineChartPoint i j x y)
          (BiprojectiveSpace.affineChartEquation m n K i j F) = 0 ∧
        ∀ q : Fin m ⊕ Fin n,
          eval (BiprojectiveSpace.affineChartPoint i j x y)
            (pderiv q (BiprojectiveSpace.affineChartEquation m n K i j F)) = 0 := by
  obtain ⟨i, x, -, hxi, hvalue, hgradient⟩ :=
    exists_normalized_firstCoordinates_gradient_eq_zero_of_specializeSecond_eq_zero
      hF hd he j y hyj hzero hnm
  exact ⟨i, x, hxi,
    BiprojectiveSpace.affineChartEquation_vanishing_and_gradient_eq_zero
      m n K i j x y hxi hyj F hvalue hgradient⟩

end

end BConicBundleMultisections
