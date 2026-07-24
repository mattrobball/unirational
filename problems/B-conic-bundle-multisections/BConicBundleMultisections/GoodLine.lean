/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.SpecializedConicFreeDir

/-!
# Genericity of the multisection line

Work package WP-G of `PLAN.md`.  The natural-language proof
(`certificates/all_smooth_tangent_residual_theorem.md`) **chooses** the multisection line `L`
subject to open conditions and normalises coordinates to `L = {W = 0}` only afterwards (§5); this
development hardcodes `L = {Y₂ = 0}` and had dropped the choice.  This module is where the missing
genericity is to be supplied.

## What is here

§1(b) of the source: **the embedded generic cubic is not constant**.  In coordinates this is the
statement that a smooth `F` does not factor as `Q(x) · f₀(y)`.  The source's argument is that such
an `F` has two components which meet, so `X` is singular; the formal proof below is the same fact
read off a specialization: a nonzero zero `x₀` of the quadratic form `Q` makes the whole cubic
fibre over `x₀` vanish, and a smooth `X` has no whole fibre.

This is the base of the chain that eventually produces a good line (§1(b) → Lemma 2.1 → Lemma 3.1),
and unlike the rest of that chain it needs no new machinery.
-/

@[expose] public section

open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

variable {k : Type u} [Field k]

/-! ### Specializing a split equation -/

/-- Specializing the first block of a polynomial pulled back from the first block alone gives the
constant value of that polynomial. -/
theorem specializeFirstCoordinates_rename_inl (x : Fin 3 → k) (Q : MvPolynomial (Fin 3) k) :
    specializeFirstCoordinates (m := 2) (n := 2) x (rename Sum.inl Q) = C (eval x Q) := by
  induction Q using MvPolynomial.induction_on with
  | C a => simp [specializeFirstCoordinates]
  | add p q hp hq => simp [hp, hq]
  | mul_X p i hp =>
      rw [map_mul, rename_X, map_mul, hp]
      simp [specializeFirstCoordinates]

/-- Specializing the first block leaves a polynomial pulled back from the second block alone
unchanged. -/
theorem specializeFirstCoordinates_rename_inr (x : Fin 3 → k) (f₀ : MvPolynomial (Fin 3) k) :
    specializeFirstCoordinates (m := 2) (n := 2) x (rename Sum.inr f₀) = f₀ := by
  induction f₀ using MvPolynomial.induction_on with
  | C a => simp [specializeFirstCoordinates]
  | add p q hp hq => simp [hp, hq]
  | mul_X p j hp =>
      rw [map_mul, rename_X, map_mul, hp]
      simp [specializeFirstCoordinates]

/-! ### §1(b): the embedded cubic is not constant -/

/--
**The generic embedded cubic of a smooth `(2,3)` hypersurface is not constant.**

Source: `certificates/all_smooth_tangent_residual_theorem.md` §1, second half.  There the argument
is that `F = Q(x) f₀(y)` describes two components which meet, so `X` is singular.  Here the same
obstruction is reached through the whole-fibre theorem: over an algebraically closed field the
quadratic form `Q` in three variables has a nonzero zero `x₀`, and then the entire cubic fibre over
`x₀` is contained in `X`, which `not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23`
forbids.

Note only homogeneity of `Q` is used; no hypothesis on `f₀` is needed.

This is the base case of the chain §1(b) → Lemma 2.1 → Lemma 3.1 that produces a line `L` with
nonconstant residual line, i.e. condition G3 of WP-G.
-/
theorem not_eq_rename_mul_rename_of_smooth [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (Q f₀ : MvPolynomial (Fin 3) k) (hQ : Q.IsHomogeneous 2) :
    F ≠ rename Sum.inl Q * rename Sum.inr f₀ := by
  intro hsplit
  have hQ0 : Q ≠ 0 := by
    intro h
    apply hF0
    rw [hsplit, h, map_zero, zero_mul]
  obtain ⟨x, hx0, hxQ⟩ :=
    exists_nonzero_zero_of_homogeneous Q (by norm_num) hQ (by simp)
  obtain ⟨i, hi⟩ := exists_normalizing_coordinate x hx0
  have hx1i : normalizeCoordinateRepresentative x i i = 1 :=
    normalizeCoordinateRepresentative_apply x i hi
  have hx1Q : eval (normalizeCoordinateRepresentative x i) Q = 0 :=
    eval_normalizeCoordinateRepresentative_eq_zero hQ x i hxQ
  refine not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23 k F hF hF0 i
    (normalizeCoordinateRepresentative x i) hx1i ?_
  rw [hsplit, map_mul, specializeFirstCoordinates_rename_inl,
    specializeFirstCoordinates_rename_inr, hx1Q, map_zero, zero_mul]

end

end BConicBundleMultisections
