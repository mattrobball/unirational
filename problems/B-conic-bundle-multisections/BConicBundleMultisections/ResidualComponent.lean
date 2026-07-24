/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualImageRationalParam

/-!
# The residual component `T_L` as a scheme-theoretic image

`residualImage F` is cut out by `F` together with the residual-line covariant
`residualEquation F`, i.e. it is the complete intersection `V(F) ∩ V(q_F)`.  Over a
general `x` its fibre is the three points `C_x ∩ {q_F = 0}`, which are exactly the three
residual points, so generically it *is* the residual surface.  But the coefficients of
`q_F` are the degree-ten forms in `x`, and when they acquire a common factor `V(q_F)`
picks up a vertical divisor over that factor's zero locus.  `residualImage F` then has
components lying over curves in `P²_x` that the residual map never meets.

That is fatal for `HasUnirationalParametrization 2 (residualImageToSpec F)`: affine space
is irreducible, so the closure of its image under any rational map is irreducible, and a
dominant rational map onto a reducible target cannot exist.  The statement is not merely
hard in that case, it is false — and the main theorem quantifies over *all* smooth `F`, so
the general case is not available.  (The paper-level argument anticipates this: the class
`aH_x + H_y` is taken only "after removing their common factor and any components over
special x-curves".)

The fix is to name the component that the residual map actually dominates, namely the
scheme-theoretic image of the localized residual chart map.  Dominance onto it is then
supplied by Mathlib's `IsDominant f.toImage` instance rather than proved, and the
reducedness question disappears with it.  Only *some* rational horizontal multisection is
needed downstream, and this is one.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace ResidualDivisor
open _root_.MvPolynomial

variable {k : Type u} [Field k]
  (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
  (v : Fin 3 → Polynomial k)
  (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
  (i j : Fin 3)

/-! ### The component -/

/-- The residual component `T_L`: the scheme-theoretic image of the localized residual
chart map inside `residualImage F`.  This, rather than `residualImage F` itself, is the
surface the residual map dominates. -/
def residualComponent : Scheme.{u} :=
  (residualImagePointOfNormalizedLoc F hF v hv i j).image

/-- The closed immersion of the residual component into `residualImage F`. -/
def residualComponentι :
    residualComponent F hF v hv i j ⟶ residualImage F :=
  (residualImagePointOfNormalizedLoc F hF v hv i j).imageι

/-- Structure morphism of the residual component over `Spec k`. -/
def residualComponentToSpec :
    residualComponent F hF v hv i j ⟶ Spec (.of k) :=
  residualComponentι F hF v hv i j ≫ residualImageToSpec F

/-- The localized residual chart map, corestricted to the component it dominates. -/
def residualComponentPoint :
    Spec (.of (residualChartLoc F v i j)) ⟶ residualComponent F hF v hv i j :=
  (residualImagePointOfNormalizedLoc F hF v hv i j).toImage

/-! ### Dominance, for free -/

/-- Dominance of the corestricted residual map.  This is Mathlib's
`IsDominant f.toImage` for quasi-compact `f`; the source here is affine.  It replaces the
`WP10-dense` / `loc-dom` obligations, which targeted `residualImage F` and were therefore
attempts to prove a statement that is false whenever that scheme is reducible. -/
instance residualComponentPoint_isDominant :
    IsDominant (residualComponentPoint F hF v hv i j) :=
  inferInstanceAs (IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j).toImage)

instance residualComponentPoint_quasiCompact :
    QuasiCompact (residualComponentPoint F hF v hv i j) :=
  inferInstanceAs (QuasiCompact (residualImagePointOfNormalizedLoc F hF v hv i j).toImage)

/-! ### Compatibilities -/

/-- The corestriction composed with the closed immersion is the original residual map. -/
@[reassoc (attr := simp)]
theorem residualComponentPoint_ι :
    residualComponentPoint F hF v hv i j ≫ residualComponentι F hF v hv i j =
      residualImagePointOfNormalizedLoc F hF v hv i j :=
  Scheme.Hom.toImage_imageι _

/-- The component's structure morphism is compatible with the residual map: going down to
`Spec k` through the component agrees with going through `residualImage F`. -/
@[reassoc]
theorem residualComponentPoint_toSpec :
    residualComponentPoint F hF v hv i j ≫ residualComponentToSpec F hF v hv i j =
      residualImagePointOfNormalizedLoc F hF v hv i j ≫ residualImageToSpec F := by
  rw [residualComponentToSpec, ← Category.assoc, residualComponentPoint_ι]

/-- The component maps to the conic-bundle base through `residualImage F`. -/
def residualComponentToBase :
    residualComponent F hF v hv i j ⟶ ProjectiveSpace 2 k :=
  residualComponentι F hF v hv i j ≫ residualImageToBase F

end

end BConicBundleMultisections
