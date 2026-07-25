/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveSpace
public import BConicBundleMultisections.Standard.GenericPoint
public import Mathlib.AlgebraicGeometry.Morphisms.UnderlyingMap

/-!
# Density of the standard charts of `ℙⁿ`

`ProjectiveSpace.standardChartι n R i` is the inclusion of the chart `{X_i ≠ 0}`.  Over a domain it
is dense, which is what lets a rational map defined on one chart be tested for dominance there.

This is a general statement about `ℙⁿ`, with no reference to the tangent-residual construction; it
is separated from `ResidualComponentHorizontality` for that reason.  `PLAN.md` WP-1 consumes it.

## Route

`standardChartι` is an open immersion (instance present), so `IsOpen.dense` reduces the claim to
`IrreducibleSpace (ProjectiveSpace n R)`.

Get that from the **generic point**, not from a chart cover.  `ProjectiveSpectrum` of a graded
domain carries the point `⊥`: homogeneous, prime because `MvPolynomial` over a domain is a domain,
and not containing the irrelevant ideal since `X_j ≠ 0`.  Its closure is `zeroLocus ⊥ = univ`, so it
is dense, and `Standard.irreducibleSpace_of_dense_singleton` (**proved**,
`Standard/GenericPoint.lean`) concludes.

What remains is constructing the `⊥` point of `ProjectiveSpectrum` and transporting irreducibility
from `ProjectiveSpectrum` to the scheme `Proj`.  `HomogeneousIdeal` API; no mathematics.

An earlier docstring proposed covering `ℙⁿ` by irreducible charts instead.  That needs a topology
lemma Mathlib lacks *and* a projective chart cover that does not exist in this tree — only the
biprojective `iSup_standardChartAffineOpen`.  The generic point avoids both.
-/

@[expose] public section

namespace BConicBundleMultisections

open CategoryTheory
open scoped AlgebraicGeometry
open AlgebraicGeometry

universe u

section GradedRing

variable {σ A : Type*} [CommRing A] [SetLike σ A] [AddSubmonoidClass σ A]
variable (𝒜 : ℕ → σ) [GradedRing 𝒜]

/-- **The generic point of the projective spectrum of a graded domain**: the zero ideal.

It is homogeneous, it is prime because `A` is a domain, and it is a legitimate point of
`ProjectiveSpectrum 𝒜` precisely when the irrelevant ideal is not the zero ideal, which is the
hypothesis `h`. -/
def ProjectiveSpectrum.genericPoint [IsDomain A]
    (h : ¬ HomogeneousIdeal.irrelevant 𝒜 ≤ ⊥) : ProjectiveSpectrum 𝒜 where
  asHomogeneousIdeal := ⊥
  isPrime := by
    rw [HomogeneousIdeal.toIdeal_bot]
    exact Ideal.isPrime_bot
  not_irrelevant_le := h

@[simp]
theorem ProjectiveSpectrum.asHomogeneousIdeal_genericPoint [IsDomain A]
    (h : ¬ HomogeneousIdeal.irrelevant 𝒜 ≤ ⊥) :
    (ProjectiveSpectrum.genericPoint 𝒜 h).asHomogeneousIdeal = ⊥ :=
  rfl

/-- **The generic point is dense**: every homogeneous relevant prime contains `⊥`, and on
`ProjectiveSpectrum` the specialization order is containment of the defining ideals. -/
theorem ProjectiveSpectrum.dense_singleton_genericPoint [IsDomain A]
    (h : ¬ HomogeneousIdeal.irrelevant 𝒜 ≤ ⊥) :
    Dense ({ProjectiveSpectrum.genericPoint 𝒜 h} : Set (ProjectiveSpectrum 𝒜)) := fun y ↦
  (_root_.ProjectiveSpectrum.le_iff_mem_closure 𝒜 _ y).mp
    (show (⊥ : HomogeneousIdeal 𝒜) ≤ y.asHomogeneousIdeal from bot_le)

/-- **The projective spectrum of a graded domain is irreducible**, provided it is nonempty, i.e.
provided the irrelevant ideal is nonzero.  The generic point `⊥` is dense. -/
theorem ProjectiveSpectrum.irreducibleSpace [IsDomain A]
    (h : ¬ HomogeneousIdeal.irrelevant 𝒜 ≤ ⊥) : IrreducibleSpace (ProjectiveSpectrum 𝒜) :=
  Standard.irreducibleSpace_of_dense_singleton _ (dense_singleton_genericPoint 𝒜 h)

end GradedRing

section Proj

variable {σ A : Type*} [CommRing A] [SetLike σ A] [AddSubgroupClass σ A]
variable (𝒜 : ℕ → σ) [GradedRing 𝒜]

/-- **`Proj` of a graded domain is irreducible**, provided its irrelevant ideal is nonzero.  The
underlying topological space of `Proj 𝒜` is `ProjectiveSpectrum 𝒜`, so this is
`ProjectiveSpectrum.irreducibleSpace` transported along a definitional equality. -/
theorem Proj.irreducibleSpace [IsDomain A]
    (h : ¬ HomogeneousIdeal.irrelevant 𝒜 ≤ ⊥) : IrreducibleSpace (Proj 𝒜) :=
  ProjectiveSpectrum.irreducibleSpace 𝒜 h

end Proj

noncomputable section

attribute [local instance] MvPolynomial.gradedAlgebra

namespace ProjectiveSpace

/-- **The irrelevant ideal of `R[X₀, …, Xₙ]` is nonzero** whenever `R` is nontrivial: it contains
the variable `X 0`, which is homogeneous of degree `1 > 0` and nonzero.

This is exactly the hypothesis needed to make `⊥` a point of `ℙⁿ_R`. -/
theorem not_irrelevant_le_bot (n : ℕ) (R : Type u) [CommRing R] [Nontrivial R] :
    ¬ HomogeneousIdeal.irrelevant (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) ≤ ⊥ := by
  intro h
  have hX : (MvPolynomial.X 0 : MvPolynomial (Fin (n + 1)) R) ∈
      HomogeneousIdeal.irrelevant (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) :=
    HomogeneousIdeal.mem_irrelevant_of_mem _ Nat.one_pos
      ((MvPolynomial.mem_homogeneousSubmodule 1 _).mpr (MvPolynomial.isHomogeneous_X R 0))
  exact MvPolynomial.X_ne_zero 0 (Ideal.mem_bot.mp (HomogeneousIdeal.mem_iff.mpr (h hX)))

/-- **The generic point of `ℙⁿ_R`** for `R` a domain: the zero ideal of `R[X₀, …, Xₙ]`, which is
homogeneous, prime, and does not contain the irrelevant ideal. -/
def genericPoint (n : ℕ) (R : Type u) [CommRing R] [IsDomain R] : ProjectiveSpace n R :=
  ProjectiveSpectrum.genericPoint _ (not_irrelevant_le_bot n R)

/-- The generic point lies in every standard chart: it is cut out by `X i ∉ ⊥`, i.e. `X i ≠ 0`. -/
theorem genericPoint_mem_standardChart (n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (n + 1)) : genericPoint n R ∈ standardChart n R i := by
  rw [standardChart, Proj.mem_basicOpen]
  intro hmem
  exact MvPolynomial.X_ne_zero i (Ideal.mem_bot.mp (HomogeneousIdeal.mem_iff.mpr hmem))

/-- **`ℙⁿ_R` is irreducible** for `R` a domain: the generic point `⊥` is dense. -/
instance irreducibleSpace (n : ℕ) (R : Type u) [CommRing R] [IsDomain R] :
    IrreducibleSpace (ProjectiveSpace n R) :=
  Proj.irreducibleSpace _ (not_irrelevant_le_bot n R)

/-- **The standard chart of `ℙⁿ_R` is dense**, for `R` a domain. -/
theorem isDominant_standardChartι
    (n : ℕ) (R : Type u) [CommRing R] [IsDomain R] (i : Fin (n + 1)) :
    IsDominant (ProjectiveSpace.standardChartι n R i) := by
  refine ⟨?_⟩
  have hrange : Set.range ⇑(standardChartι n R i) =
      (standardChart n R i : Set (ProjectiveSpace n R)) := by
    rw [← opensRange_standardChartι n R i]
    rfl
  rw [DenseRange, hrange]
  exact (standardChart n R i).isOpen.dense
    ⟨genericPoint n R, genericPoint_mem_standardChart n R i⟩

end ProjectiveSpace

end

end BConicBundleMultisections
