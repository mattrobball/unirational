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

/-- **The standard chart of `ℙⁿ_R` is dense**, for `R` a domain. -/
theorem ProjectiveSpace.isDominant_standardChartι
    (n : ℕ) (R : Type u) [CommRing R] [IsDomain R] (i : Fin (n + 1)) :
    IsDominant (ProjectiveSpace.standardChartι n R i) :=
  sorry

end BConicBundleMultisections
