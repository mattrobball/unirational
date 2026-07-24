/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualComponent

/-!
# Obligation 3: the base-changed conic bundle is pointed and rational

One of the four outstanding obligations of the unirationality proof; see
`ResidualComponentAssembly.lean` for the inventory and `PLAN.md` WP-D for the work package.

This is the largest of the four by volume, but classical throughout — the risk is effort, not
truth.  It is independent of the other three and shares no machinery with them.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/--
**Obligation 3.**  The conic bundle base-changed to the residual component is birational over that
component to relative affine `1`-space.

*Status.* Expected true, and classical: the multisection carries a tautological section, so the
generic fibre is a conic over the function field of `T_L` with a rational point, and a pointed
conic is birational to `ℙ¹` by stereographic projection.

*What is missing.*  `PointedConicRational.lean` proves the field-level algebra — the stereographic
second-intersection map, and that the model conic `X₀X₂ = X₁²` is the Veronese image of `ℙ¹`.
That is one model conic over one field.  The target `IsPointedConicRationalOver` unfolds to a
`BirationalOver` **in families over an arbitrary base**, with the section varying.  The distance
between those is the work.

*Recommended route (PLAN.md WP-D).*  Prove `IsIntegral (residualComponent …)` first — it is the
scheme-theoretic image of `Spec` of a localization of `MvPolynomial (Fin 2) k`, hence of a domain
when the chart denominator is nonzero — so that `Scheme.functionField` applies.  Then identify the
generic fibre as a nondegenerate plane conic over `K := k(T_L)`, note the tautological section
gives a `K`-point, and produce the birational equivalence.  **Prefer `conicParametrization`, which
is already proved and needs no normal form, over completing the form to `X₀X₂ − X₁²`**: Mathlib's
`LinearAlgebra/QuadraticForm/` has no Witt decomposition or hyperbolic plane at the pinned
revision, so the normal-form route would have to build that first.  Finally, spread the field-level
equivalence out to a `Scheme.PartialIso` over `T_L`.

Downstream of this obligation everything is already wired:
`hasUnirationalParametrization1_residualComponentBaseChangeSnd` consumes it directly.
-/
theorem isResidualComponentPointedConicRational_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0) :
    IsResidualComponentPointedConicRational F hF v hv i j :=
  sorry

end

end BConicBundleMultisections
