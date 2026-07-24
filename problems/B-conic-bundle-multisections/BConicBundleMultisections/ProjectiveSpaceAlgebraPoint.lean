/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualImageAlgebraPoint

/-!
# Algebra-valued points of projective space

`ProjectiveSpace.pointOfNormalizedCoordinates` builds a point `Spec R ⟶ ℙⁿ_R` from normalized
homogeneous coordinates over the *base* ring.  The residual construction needs the same thing for
coordinates in an `R`-algebra `S` — the residual `Y`-coordinates live in a localization of
`k[t,s]`, not in `k` — so this module supplies the algebra-valued analogue.

It mirrors `ProjectiveSpace.standardChartEval` and
`ProjectiveSpace.pointOfNormalizedCoordinates` with `aeval` in place of `eval`, exactly as
`biprojectiveChartEvalAlgebra` mirrors `biprojectiveChartEval`.

These are **definitions**, so they are built rather than assumed: a `sorry`ed theorem is honest, a
`sorry`ed definition would make everything downstream about the wrong object.

Used by WP-1 of `PLAN.md`: it is what lets the composite
`Spec (residualChartLoc) ⟶ residualImage ⟶ ℙ²_y` be described in coordinates, which reduces
horizontality to injectivity of a single explicit ring map.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace ProjectiveSpace
open _root_.MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra

variable {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]

namespace ProjectiveSpace

/-- Evaluation of the standard chart ring of `ℙⁿ_R` at algebra-valued normalized coordinates.

Algebra-valued analogue of `ProjectiveSpace.standardChartEval`, with `aeval` for `eval`. -/
def standardChartEvalAlgebra (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S) :
    StandardChartRing n R i →+* S :=
  (aeval (affineCoordinates i x) : MvPolynomial (Fin n) R →ₐ[R] S).toRingHom.comp
    (standardChartRingEquivMvPolynomial n R i).toRingHom

/-- The `Spec S`-point of `ℙⁿ_R` determined by algebra-valued normalized coordinates.

Algebra-valued analogue of `ProjectiveSpace.pointOfNormalizedCoordinates`; note the target is
`ℙⁿ` over the **base** ring `R`, while the coordinates live in `S`. -/
def pointOfNormalizedCoordinatesAlgebra (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S) :
    Spec (.of S) ⟶ ProjectiveSpace n R :=
  Spec.map (CommRingCat.ofHom (standardChartEvalAlgebra (R := R) n i x)) ≫ standardChartι n R i

end ProjectiveSpace

end

end BConicBundleMultisections
