/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveSpace
public import BConicBundleMultisections.Standard.GenericPoint
public import Mathlib.AlgebraicGeometry.Morphisms.UnderlyingMap
public import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.StructureSheaf
public import Mathlib.AlgebraicGeometry.Properties
public import Mathlib.RingTheory.GradedAlgebra.HomogeneousLocalization
public import Mathlib.RingTheory.Localization.AtPrime.Basic

/-!
# Density of the standard charts of `ℙⁿ`

`ProjectiveSpace.standardChartι n R i` is the inclusion of the chart `{X_i ≠ 0}`.  Over a domain it
is dense, which is what lets a rational map defined on one chart be tested for dominance there.

This is a general statement about `ℙⁿ`, with no reference to the tangent-residual construction; it
is separated from `ResidualComponentHorizontality` for that reason.  `PLAN.md` WP-1 consumes it.

## Main results

* `ProjectiveSpectrum.genericPoint`: for an `ℕ`-graded domain `𝒜` with nonzero irrelevant ideal,
  the zero ideal is a point of `ProjectiveSpectrum 𝒜`, and it is dense.
* `ProjectiveSpectrum.irreducibleSpace`, `Proj.irreducibleSpace`: such a projective spectrum, and
  hence `Proj 𝒜`, is an irreducible space.
* `ProjectiveSpace.irreducibleSpace`: `ℙⁿ_R` is irreducible for `R` a domain.
* `ProjectiveSpace.isDominant_standardChartι`: the standard charts of `ℙⁿ_R` are dense.

## Route

`standardChartι` is an open immersion (instance present), so `IsOpen.dense` reduces the claim to
`IrreducibleSpace (ProjectiveSpace n R)` together with the chart being nonempty.

Irreducibility comes from the **generic point**, not from a chart cover.  `ProjectiveSpectrum` of a
graded domain carries the point `⊥`: it is homogeneous, it is prime because the ring is a domain,
and it does not contain the irrelevant ideal — which is nonzero because `X_j ≠ 0`.  Every point is
a specialization of it, since on `ProjectiveSpectrum` the specialization order is inclusion of the
defining ideals (`ProjectiveSpectrum.le_iff_mem_closure`); so `{⊥}` is dense and
`Standard.irreducibleSpace_of_dense_singleton` (**proved**, `Standard/GenericPoint.lean`)
concludes.  The very same point witnesses that each standard chart is nonempty.

Transport from `ProjectiveSpectrum 𝒜` to the scheme `Proj 𝒜` is definitional: the carrier of
`Proj 𝒜` is `TopCat.of (ProjectiveSpectrum 𝒜)`.

An earlier docstring proposed covering `ℙⁿ` by irreducible charts instead.  That needs a topology
lemma Mathlib lacks *and* a projective chart cover that does not exist in this tree — only the
biprojective `iSup_standardChartAffineOpen`.  The generic point avoids both.

## Mathlib

Everything stated before the `ProjectiveSpace` namespace below holds for an arbitrary `ℕ`-graded
domain and should eventually move to `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Topology.lean`
(the `ProjectiveSpectrum` results) and `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean`
(the `Proj` result).  Mathlib has `PrimeSpectrum.irreducibleSpace` for a domain but no projective
analogue.
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

It is homogeneous, and it is prime because `A` is a domain.  It is a legitimate point of
`ProjectiveSpectrum 𝒜` — i.e. it does not contain the irrelevant ideal — exactly when the
irrelevant ideal is nonzero, which is the hypothesis `h`. -/
def ProjectiveSpectrum.genericPoint [IsDomain A]
    (h : HomogeneousIdeal.irrelevant 𝒜 ≠ ⊥) : ProjectiveSpectrum 𝒜 where
  asHomogeneousIdeal := ⊥
  isPrime := by
    rw [HomogeneousIdeal.toIdeal_bot]
    exact Ideal.isPrime_bot
  not_irrelevant_le hle := h (le_bot_iff.mp hle)

@[simp]
theorem ProjectiveSpectrum.asHomogeneousIdeal_genericPoint [IsDomain A]
    (h : HomogeneousIdeal.irrelevant 𝒜 ≠ ⊥) :
    (ProjectiveSpectrum.genericPoint 𝒜 h).asHomogeneousIdeal = ⊥ :=
  rfl

/-- **The generic point of a graded domain is dense**: every relevant homogeneous prime contains
`⊥`, and on `ProjectiveSpectrum` containment of the defining ideals is exactly specialization
(`ProjectiveSpectrum.le_iff_mem_closure`). -/
theorem ProjectiveSpectrum.dense_singleton_genericPoint [IsDomain A]
    (h : HomogeneousIdeal.irrelevant 𝒜 ≠ ⊥) :
    Dense ({ProjectiveSpectrum.genericPoint 𝒜 h} : Set (ProjectiveSpectrum 𝒜)) := fun y ↦
  (_root_.ProjectiveSpectrum.le_iff_mem_closure 𝒜 _ y).mp
    (show (⊥ : HomogeneousIdeal 𝒜) ≤ y.asHomogeneousIdeal from bot_le)

/-- **The projective spectrum of a graded domain is irreducible**, provided it is nonempty — which
for a graded domain is exactly the condition that the irrelevant ideal be nonzero.  The generic
point `⊥` is dense. -/
theorem ProjectiveSpectrum.irreducibleSpace [IsDomain A]
    (h : HomogeneousIdeal.irrelevant 𝒜 ≠ ⊥) : IrreducibleSpace (ProjectiveSpectrum 𝒜) :=
  Standard.irreducibleSpace_of_dense_singleton _ (dense_singleton_genericPoint 𝒜 h)

end GradedRing

section Proj

variable {σ A : Type*} [CommRing A] [SetLike σ A] [AddSubgroupClass σ A]
variable (𝒜 : ℕ → σ) [GradedRing 𝒜]

/-- **`Proj` of a graded domain is irreducible**, provided its irrelevant ideal is nonzero.

The carrier of `Proj 𝒜` is `TopCat.of (ProjectiveSpectrum 𝒜)`, so this is
`ProjectiveSpectrum.irreducibleSpace` transported along a definitional equality. -/
theorem Proj.irreducibleSpace [IsDomain A]
    (h : HomogeneousIdeal.irrelevant 𝒜 ≠ ⊥) : IrreducibleSpace (Proj 𝒜) :=
  ProjectiveSpectrum.irreducibleSpace 𝒜 h

/-- Homogeneous localization of a domain at a prime is a domain: it injects into the ordinary
localization at that prime, which is a domain. -/
instance Proj.isDomain_homogeneousLocalization_atPrime [IsDomain A]
    (𝔭 : Ideal A) [𝔭.IsPrime] :
    IsDomain (HomogeneousLocalization.AtPrime 𝒜 𝔭) := by
  haveI : IsDomain (Localization.AtPrime 𝔭) := inferInstance
  exact Function.Injective.isDomain
    (algebraMap (HomogeneousLocalization.AtPrime 𝒜 𝔭) (Localization.AtPrime 𝔭))
    (HomogeneousLocalization.val_injective 𝔭.primeCompl)

/-- Stalks of `Proj` of a graded domain are domains (via `Proj.stalkIso'`). -/
instance Proj.isDomain_stalk [IsDomain A] (x : Proj 𝒜) :
    IsDomain ↑((Proj 𝒜).presheaf.stalk x) := by
  have e := Proj.stalkIso' 𝒜 x
  haveI : IsDomain (HomogeneousLocalization.AtPrime 𝒜 x.asHomogeneousIdeal.toIdeal) :=
    Proj.isDomain_homogeneousLocalization_atPrime 𝒜 _
  exact e.toMulEquiv.isDomain _

/-- **`Proj` of a graded domain is reduced.**  Stalks are domains, hence reduced. -/
theorem Proj.isReduced [IsDomain A] : IsReduced (Proj 𝒜) :=
  isReduced_of_isReduced_stalk _

/-- **`Proj` of a graded domain is an integral scheme**, provided its irrelevant ideal is nonzero.

Combines `Proj.irreducibleSpace` with `Proj.isReduced`. -/
theorem Proj.isIntegral [IsDomain A]
    (h : HomogeneousIdeal.irrelevant 𝒜 ≠ ⊥) : IsIntegral (Proj 𝒜) := by
  haveI : IrreducibleSpace (Proj 𝒜) := Proj.irreducibleSpace 𝒜 h
  haveI : IsReduced (Proj 𝒜) := Proj.isReduced 𝒜
  exact isIntegral_of_irreducibleSpace_of_isReduced _

end Proj

noncomputable section

attribute [local instance] MvPolynomial.gradedAlgebra

namespace ProjectiveSpace

/-- **The irrelevant ideal of `R[X₀, …, Xₙ]` is nonzero** whenever `R` is nontrivial: it contains
the variable `X 0`, which is homogeneous of degree `1 > 0` and is nonzero.

This is exactly the hypothesis that makes `⊥` a point of `ℙⁿ_R`. -/
theorem irrelevant_ne_bot (n : ℕ) (R : Type u) [CommRing R] [Nontrivial R] :
    HomogeneousIdeal.irrelevant (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) ≠ ⊥ := by
  intro h
  have hX : (MvPolynomial.X 0 : MvPolynomial (Fin (n + 1)) R) ∈
      HomogeneousIdeal.irrelevant (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) :=
    HomogeneousIdeal.mem_irrelevant_of_mem _ Nat.one_pos
      ((MvPolynomial.mem_homogeneousSubmodule 1 _).mpr (MvPolynomial.isHomogeneous_X R 0))
  rw [h] at hX
  exact MvPolynomial.X_ne_zero 0 (Ideal.mem_bot.mp (HomogeneousIdeal.mem_iff.mpr hX))

/-- **The generic point of `ℙⁿ_R`** for `R` a domain: the zero ideal of `R[X₀, …, Xₙ]`, which is
homogeneous, prime, and does not contain the irrelevant ideal. -/
def genericPoint (n : ℕ) (R : Type u) [CommRing R] [IsDomain R] : ProjectiveSpace n R :=
  ProjectiveSpectrum.genericPoint _ (irrelevant_ne_bot n R)

/-- The generic point lies in every standard chart: membership in `D₊(Xᵢ)` says `X i ∉ ⊥`, i.e.
`X i ≠ 0`. -/
theorem genericPoint_mem_standardChart (n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (n + 1)) : genericPoint n R ∈ standardChart n R i := by
  rw [standardChart, Proj.mem_basicOpen]
  intro hmem
  exact MvPolynomial.X_ne_zero i (Ideal.mem_bot.mp (HomogeneousIdeal.mem_iff.mpr hmem))

/-- **`ℙⁿ_R` is irreducible** for `R` a domain: the generic point `⊥` is dense. -/
instance irreducibleSpace (n : ℕ) (R : Type u) [CommRing R] [IsDomain R] :
    IrreducibleSpace (ProjectiveSpace n R) :=
  Proj.irreducibleSpace _ (irrelevant_ne_bot n R)

/-- **`ℙⁿ_R` is reduced** for `R` a domain. -/
instance isReduced (n : ℕ) (R : Type u) [CommRing R] [IsDomain R] :
    IsReduced (ProjectiveSpace n R) :=
  Proj.isReduced _

/-- **`ℙⁿ_R` is an integral scheme** for `R` a domain. -/
instance isIntegral (n : ℕ) (R : Type u) [CommRing R] [IsDomain R] :
    IsIntegral (ProjectiveSpace n R) :=
  Proj.isIntegral _ (irrelevant_ne_bot n R)

/-- **The standard chart of `ℙⁿ_R` is dense**, for `R` a domain.

Its range is the open set `D₊(Xᵢ)`, which is nonempty — it contains the generic point — and a
nonempty open subset of an irreducible space is dense. -/
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
