/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicResidualTransport
public import BConicBundleMultisections.ResidualEquationLine

/-!
# Horizontality along an arbitrary multisection line

`ResidualComponentHorizontality.eq_zero_of_aeval_residualYCoords_of_isHomogeneous` states the
concrete content of horizontality — *no nonzero form vanishes on the residual `Y`-coordinates* —
for the hardcoded line `{Y₂ = 0}` and with no hypothesis on that line.

That statement is **suspect**: `certificates/all_smooth_tangent_residual_theorem.md` §4 proves
horizontality by a contradiction ending *"contrary to the choice of `L`"*, and §5 records that
horizontality is *equivalent* to nonconstancy of `δ_C(L)`.  For a line where nonconstancy fails,
horizontality is false — so the statement without a hypothesis on `L` cannot be provable.

This module restates it for an arbitrary line, with condition **G3** as an explicit hypothesis, and
supplies the identity that connects the two sides: the residual equation along `L`, evaluated at a
point, is the residual line along `L` of the cubic fibre there.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open CategoryTheory
open scoped AlgebraicGeometry
open AlgebraicGeometry MvPolynomial BiprojectiveSpace ResidualDivisor
open _root_.MvPolynomial
open scoped Matrix

variable {R : Type u} [CommRing R]

/-! ### The residual equation is the residual line of the cubic fibre -/

/-- **The residual equation, evaluated at `(x, y)`, is the residual line of the cubic fibre over
`x`, evaluated at `y`.**

This is `eval_residualEquation_eq_residualLinear_specializeFirst` with both sides packaged as
`residualLinearForm`; it is frame-independent, and is the coordinate-line case of
`eval_residualEquationOn` below. -/
theorem eval_residualEquation_eq_eval_planeCubicResidualLinearForm
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (x y : Fin 3 → R) :
    eval (Sum.elim x y) (residualEquation F)
      = eval y (PlaneCubicResidual.residualLinearForm
          (specializeFirstCoordinates (n := 2) x F)) := by
  rw [eval_residualEquation_eq_residualLinear_specializeFirst,
    PlaneCubicResidual.eval_residualLinearForm]
  simp only [PlaneCubicResidual.coeffU3, PlaneCubicResidual.coeffU2V,
    PlaneCubicResidual.coeffUV2, PlaneCubicResidual.coeffV3,
    PlaneCubicResidual.coeffU2W, PlaneCubicResidual.coeffUVW,
    PlaneCubicResidual.coeffV2W, PlaneCubicResidual.coeffUW2,
    PlaneCubicResidual.coeffVW2, PlaneCubicResidual.coeffW3,
    PlaneCubicResidual.eU3, PlaneCubicResidual.eU2V, PlaneCubicResidual.eUV2,
    PlaneCubicResidual.eV3, PlaneCubicResidual.eU2W, PlaneCubicResidual.eUVW,
    PlaneCubicResidual.eV2W, PlaneCubicResidual.eUW2, PlaneCubicResidual.eVW2,
    PlaneCubicResidual.eW3]

/-- **The same, along an arbitrary line.**

The three commutations do the work: `eval_secondBlockSubst` moves the outer substitution onto the
point, `specializeFirstCoordinates_secondBlockSubst` turns the cubic fibre of the substituted `F`
into the substituted cubic fibre, and `eval_residualLinearFormOn` recognises the result as the
residual line along `L`.

This is the identity that makes condition **G3** and horizontality talk about the same object. -/
theorem eval_residualEquationOn (M N : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (x y : Fin 3 → R) :
    eval (Sum.elim x y) (residualEquationOn M N F)
      = eval y (residualLinearFormOn M N (specializeFirstCoordinates (n := 2) x F)) := by
  rw [residualEquationOn, eval_secondBlockSubst,
    eval_residualEquation_eq_eval_planeCubicResidualLinearForm,
    specializeFirstCoordinates_secondBlockSubst, eval_residualLinearFormOn]

/-! ### The obligation, restated for an arbitrary line -/

section

variable {K : Type u} [Field K]

/--
**No nonzero form vanishes on the residual `Y`-coordinates along `L`.**

*What it says.*  `residualYCoordsOn p₀ q₀ r N F v : Fin 3 → k[t,s]` are the homogeneous coordinates
of the tangent-residual point of the plane cubic fibre, as a function of the two parameters of the
vertical surface `S_L`: one runs along `L`, the other along the stereographic parametrisation of
the conic over it.  The claim is that these three polynomials satisfy no homogeneous relation over
`k` in any degree — equivalently that the two ratios are algebraically independent in `k(t,s)`,
equivalently that the residual surface `T_L` is not contained in a curve of `ℙ²_y`.  That is the
concrete content of horizontality.

*Why the hypothesis on `L` is there.*  It is not optional.  If `hgood` fails — if the residual line
`δ_{C_x}(L)` does not move with `x` — then by `eval_residualEquationOn` every residual point lies
on one fixed line of `ℙ²_y`, so the degree-one case already fails.  §4's proof ends *"contrary to
the choice of `L`"* and §5 states the equivalence outright.  The coordinate-line version in
`ResidualComponentHorizontality`, which carries no hypothesis on `L`, is unprovable for that
reason, and this statement supersedes it.

*What is missing.*  The converse direction, G3 ⟹ horizontality, which is §4.  The source proves it
with Grothendieck–Lefschetz and a Picard-group computation; `PLAN.md` WP-1 records the concrete
proxy route instead — factor through the standard chart of `ℙ²_y`, reduce to injectivity of a ring
map, and settle that by the characteristic-zero Jacobian criterion.  The two inputs that route
needs are `ProjectiveSpace.isDominant_standardChartι` and the algebraic independence.
-/
theorem eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous
    [IsAlgClosed K] [CharZero K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (v : Fin 3 → Polynomial K) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) K) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) Ψ = 0) :
    Ψ = 0 :=
  sorry

end

end

end BConicBundleMultisections
