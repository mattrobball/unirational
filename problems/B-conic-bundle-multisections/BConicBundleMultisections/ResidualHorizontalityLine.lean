/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.AlgebraicIndependenceJacobian
public import BConicBundleMultisections.JacobianCriterionCharFree
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

## What is reduced, and what is left

`eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous` is now **proved** from a single statement,
`det_residualYCoordsOn_ne_zero`: the `3 × 3` determinant whose rows are the residual
`Y`-coordinates and their derivatives with respect to the two parameters of `S_L` is nonzero.  The
reduction is `AlgebraicIndependenceJacobian.eq_zero_of_isHomogeneous_of_aeval_eq_zero`.  That
determinant is §4 of the source and is the frontier: the source's proof is Grothendieck–Lefschetz
plus a Picard computation, which this development does not have, and `PLAN.md` WP-1's proxy route
terminates at the same determinant.

## Two nondegeneracy hypotheses on the section are necessary

`hgood` alone is **not** enough, and the gap is not about `L`: it is about the Tsen section `v`,
which the statement quantifies over universally.  The stereo point is
`Q(w)·v − B_Q(v, w)·w` with `w = (1, s, 0)`.  Smoothness of `X` gives `Q(w) ≠ 0`
(`specializedConicFreeDirForm_ne_zero_of_smooth`) but says nothing about the polar form `B_Q(v, w)`,
and if that vanishes the stereographic parametrisation collapses: the first-block coordinates become
a scalar multiple of `v`, which depends on `t` alone
(`stereoFirstCoordsOn_eq_smul_of_lineStereoPolarForm_eq_zero`), the cubic fibre follows
(`cubicFiberPullback_stereoFirstCoordsOn_of_lineStereoPolarForm_eq_zero`), and the residual point
sweeps a curve rather than a surface.  Three polynomials in one variable always satisfy a nonzero
homogeneous relation, so the conclusion is then false regardless of `L`.

Independently, one must require `v 2 ≠ 0`.  If `v 2 = 0`, both `v` and every stereo direction
`w = (1,s,0)` lie on the fixed line `{x₂ = 0}`.  Over `k(t)` the restricted binary quadratic has
`v` as one root, so the stereo formula is a scalar multiple of its other root.  The residual point
is therefore projectively a function of `t` alone and its Jacobian determinant vanishes.  Polar
nonvanishing only prevents the produced vector from being zero; it does not prevent this collapse.

The source excludes this with its condition (1) on `L` — "`S_L` is integral and its generic conic
over `k(L)` is smooth" — which the previous statement of the theorem had dropped when it was lifted
from the coordinate line to a general one.  The formulas consume the two explicit conditions
`v 2 ≠ 0` and `lineStereoPolarForm … ≠ 0`; both are hypotheses below and both are supplied by
`exists_isotropic_line_stereoNondegenerate_of_disc_ne_zero`.
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

/-- **A constant residual line kills horizontality.**

If the residual line along `L` is, at the stereo point, a multiple of a linear form whose
coefficients are *constants* — no dependence on the parameters of `S_L` — then that form vanishes
identically on the residual `Y`-coordinates.  The degree-one case of horizontality then fails, and
with it horizontality.

This is why condition **G3** is a hypothesis of
`eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous` and not something to be derived: for a line
where the residual line does not move, the conclusion is false.  An earlier version of the plan
recorded G3 as "verified unnecessary"; this lemma is the standing refutation of that. -/
theorem sum_smul_residualYCoordsOn_eq_zero_of_constant_residualLine
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (h : affineTwoRing K) (hh : h ≠ 0) (c : Fin 3 → K)
    (hline : residualLinearFormOn (affineTwoLineFrame p₀ q₀ r) (N.map C)
          (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F v))
        = C h * ∑ a : Fin 3, C (C (c a)) * X a) :
    ∑ a : Fin 3, C (c a) * residualYCoordsOn p₀ q₀ r N F v a = 0 := by
  have hzero := eval_residualYCoordsOn_residualLinearFormOn p₀ q₀ r N hMN F hF v hv
  rw [hline] at hzero
  simp only [map_mul, map_sum, eval_C, eval_X] at hzero
  exact (mul_eq_zero.mp hzero).resolve_left hh

/-! ### Nondegeneracy of the stereographic parametrisation

The two parameters of `S_L` are `t = affineTwoCoord0`, running along `L`, and `s =
affineTwoCoord1`, running along the stereographic pencil.  The stereo point is

```
stereoAlg Q p w = Q(w) · p − B_Q(p, w) · w,   p = liftTsenSection v,  w = (1, s, 0),
```

with `B_Q` the polar form.  `Q(w) ≠ 0` is `specializedConicFreeDirForm_ne_zero_of_smooth` and
follows from smoothness of `X`.  The *other* factor, `B_Q(p, w)`, is what makes the stereo point
move with `s`, and it does **not** follow from smoothness — see
`stereoFirstCoordsOn_eq_smul_of_lineStereoPolarForm_eq_zero`. -/

/--
**The stereographic polar form along `L`**: `B_Q(v, (1, s, 0))`, where `Q` is the conic over the
point of `L` at parameter `t`, `v` the Tsen section, and `(1, s, 0)` the stereographic direction.

It is linear in `s`, so it is `A(t) + B(t)·s`, and it vanishes identically exactly when the polar
line of `v(t)` with respect to `Q_t` is the fixed coordinate line `{x₂ = 0} ⊂ ℙ²_x` for every `t` —
equivalently, when `Q_t` is singular with `v(t)` in its radical, or `Q_t` is smooth and tangent to
`{x₂ = 0}` at `v(t)`.
-/
def lineStereoPolarForm (p₀ q₀ : Fin 3 → K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (v : Fin 3 → Polynomial K) :
    affineTwoRing K :=
  polarEval (lineSpecializedConicPullback p₀ q₀ F) (liftTsenSection v) affineTwoStereoDir

/--
**Why the polar form has to be nonzero: otherwise the stereographic parametrisation collapses.**

If `lineStereoPolarForm` vanishes, the stereo point is a *scalar multiple of the Tsen section*, and
`liftTsenSection v` involves only the parameter `t`.  So the first-block coordinates of the
parametrisation are projectively independent of `s`: instead of sweeping out `ℙ²_x`, they sweep out
a curve.

Everything downstream inherits the collapse.  The cubic fibre is
`cubicFiberPullback F (α • p) = C (α²) · cubicFiberPullback F p` (bidegree `(2,3)`), the tangent
direction and the restricted binary cubic pick up further powers of `α`
(`residualAmbientRep_reparam`), and the residual point comes out as a scalar multiple of a vector
in `t` alone.  Three polynomials in one variable always satisfy a nonzero homogeneous relation, so
`eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous` is **false** in that situation, whatever `L`
does — in particular `hgood` cannot rescue it.

This is why `hpolar` is a hypothesis below and not something to be derived.  Only the first step is
formalised here; the rest is the scalar bookkeeping just described, and it is not needed unless
someone wants the falsity as a theorem.  See the `hpolar` discussion in
`eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous`.
-/
theorem stereoFirstCoordsOn_eq_smul_of_lineStereoPolarForm_eq_zero
    (p₀ q₀ : Fin 3 → K) (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) (h : lineStereoPolarForm p₀ q₀ F v = 0) :
    stereoFirstCoordsOn p₀ q₀ F v = fun i =>
      eval (affineTwoStereoDir (k := K)) (lineSpecializedConicPullback p₀ q₀ F)
        * liftTsenSection v i := by
  funext i
  rw [stereoFirstCoordsOn, stereoAlg, show
      polarEval (lineSpecializedConicPullback p₀ q₀ F) (liftTsenSection v)
        (affineTwoStereoDir (k := K)) = 0 from h, zero_mul, sub_zero]

/--
**The collapse reaches the cubic fibre.**

Continuing `stereoFirstCoordsOn_eq_smul_of_lineStereoPolarForm_eq_zero`: the plane cubic whose
tangent-residual point is taken is, up to the scalar `Q(w)²`, the cubic fibre over the Tsen section
itself — a cubic in the parameter `t` alone.  Since the residual construction is homogeneous in the
cubic and in the direction (`residualAmbientRep_reparam`), the residual point is then a scalar
multiple of a vector in `t` alone, and the residual `Y`-coordinates satisfy a nonzero homogeneous
relation.
-/
theorem cubicFiberPullback_stereoFirstCoordsOn_of_lineStereoPolarForm_eq_zero
    (p₀ q₀ : Fin 3 → K) (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K) (h : lineStereoPolarForm p₀ q₀ F v = 0) :
    cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F v)
      = C (eval (affineTwoStereoDir (k := K)) (lineSpecializedConicPullback p₀ q₀ F) ^ 2)
        * cubicFiberPullback F (liftTsenSection v) := by
  have hmap : IsBidegree23 (affineTwoPullback F) :=
    hF.map_coefficients (C : K →+* affineTwoRing K)
  have hsmul := hmap.specializeFirstCoordinates_smul
    (eval (affineTwoStereoDir (k := K)) (lineSpecializedConicPullback p₀ q₀ F))
    (liftTsenSection v)
  rw [cubicFiberPullback, stereoFirstCoordsOn_eq_smul_of_lineStereoPolarForm_eq_zero p₀ q₀ F v h]
  exact hsmul

/-! ### Obligation D: the Jacobian determinant -/

/--
**Obligation D.**  The `3 × 3` determinant whose rows are the residual `Y`-coordinates and their
two partial derivatives — with respect to `t = ULift.up 0`, the parameter along `L`, and
`s = ULift.up 1`, the stereographic parameter — is nonzero.

*What it says.*  Equivalently, the rational map `𝔸²_{t,s} ⇢ ℙ²_y` given by the residual point is
dominant: the residual surface `T_L` is not contained in a curve of `ℙ²_y`.  That is horizontality,
and by `eq_zero_of_isHomogeneous_of_aeval_eq_zero` it is *exactly* what
`eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous` needs — nothing else remains.

*Why it is true.*  `certificates/all_smooth_tangent_residual_theorem.md` §4.  Suppose the image were
a curve.  Grothendieck–Lefschetz for the smooth ample divisor `X` gives
`Pic(X) = ℤH_x ⊕ ℤH_y`; writing `[T_L] = aH_x + bH_y`, a general conic fibre over a point off the
image curve is disjoint from `T_L`, so `2a = 0`, and degree three over `ℙ²_x` gives `3b = 3`.  Hence
`[T_L] = H_y`, and the restriction sequence together with
`H¹(ℙ²×ℙ², O(-2,-2)) = 0` makes `T_L` the inverse image of a *constant* line `M ⊂ ℙ²_y`, so
`δ_{C_x}(L) = M` for every `x` — contradicting `hgood`.  §5 records the converse, that horizontality
is *equivalent* to nonconstancy of `δ_{C_x}(L)`, so this is the right implication.

*Status: `sorry`ed, and this is the frontier.*  The source's route needs Grothendieck–Lefschetz,
Picard groups of hypersurfaces, and the effective cone — none of which exist in Mathlib and none of
which this development has.  `PLAN.md` WP-1 records the proxy route (chart, ring-map injectivity,
Jacobian criterion); steps 1a–1c and the Jacobian criterion itself are all done, and the proxy route
*terminates here*, at this determinant.  So this is not a packaging problem that a different
reduction would dissolve: it is the mathematical content of §4.

*Reductions achieved (not a proof of the det).*
* Homogeneous vanishing ⟺ this det, via `eq_zero_of_isHomogeneous_of_aeval_eq_zero` (proved).
* Coordinate-line special case: `residualYCoordsOn_coordinateLine` identifies
  `residualYCoordsOn ![1,0,0] ![0,1,0] ![0,0,1] 1` with `residualYCoords`, so the coordinate-line
  det leaf `det_residualYCoords_ne_zero` is the same matrix; under G3, `v₂ ≠ 0`, and polar
  nonvanishing it follows from *this* theorem
  (`det_residualYCoords_ne_zero_of_residualLineNonconstant`).  Closing *this* statement
  still needs the geometric content of §4 (or an algebraic substitute).

*Hypotheses.*  `hgood` is necessary — `sum_smul_residualYCoordsOn_eq_zero_of_constant_residualLine`
is the standing refutation of dropping it.  Both `hv2` and `hpolar` are necessary section
nondegeneracy conditions; see the module discussion above and
`stereoFirstCoordsOn_eq_smul_of_lineStereoPolarForm_eq_zero`.  The source's conditions
(2) `C ∩ L` reduced and (3) `[-2]` injective on `C ∩ L` are deliberately *not* assumed: they make
`S_L ⇢ T_L` birational, which is what §5's degree bookkeeping needs, whereas horizontality only
needs the image to be two-dimensional.  If a proof turns out to need them, they must be added here
and supplied by a strengthened `exists_good_line`.
-/
theorem det_residualYCoordsOn_ne_zero
    [IsAlgClosed K] [CharZero K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (v : Fin 3 → Polynomial K) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0) :
    (Matrix.of ![residualYCoordsOn p₀ q₀ r N F v,
        fun a => pderiv (ULift.up 0) (residualYCoordsOn p₀ q₀ r N F v a),
        fun a => pderiv (ULift.up 1) (residualYCoordsOn p₀ q₀ r N F v a)]).det ≠ 0 :=
  sorry

/-- Horizontality in Jacobian form already guarantees that the residual point is a genuine
projective point: its coordinate triple cannot vanish identically. -/
theorem residualYCoordsOn_ne_zero_of_det
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K)
    (hdet :
      (Matrix.of ![residualYCoordsOn p₀ q₀ r N F v,
          fun a => pderiv (ULift.up 0) (residualYCoordsOn p₀ q₀ r N F v a),
          fun a => pderiv (ULift.up 1) (residualYCoordsOn p₀ q₀ r N F v a)]).det ≠ 0) :
    residualYCoordsOn p₀ q₀ r N F v ≠ 0 := by
  intro hzero
  apply hdet
  simp [hzero, Matrix.det_fin_three]

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

*The section hypotheses `hv2` and `hpolar` are not optional.*  They are conditions on the *Tsen
section* `v`, not on `L`, and they are independent of `hgood`: if the polar form
`lineStereoPolarForm` vanishes then the stereographic parametrisation collapses onto a curve
(`stereoFirstCoordsOn_eq_smul_of_lineStereoPolarForm_eq_zero`), the residual point becomes a scalar
multiple of a vector in `t` alone, and three polynomials in one variable always satisfy a nonzero
homogeneous relation — so the conclusion fails no matter how good `L` is.  The source excludes this
by its condition (1) on `L`, "`S_L` is integral and its generic conic over `k(L)` is smooth", which
the earlier statement of this theorem dropped.  `v` is *universally* quantified here, so a condition
on `v` is genuinely needed: even a line whose generic conic is smooth admits a bad section if the
coordinate line `{x₂ = 0} ⊂ ℙ²_x` happens to be tangent to every `Q_t` at `v(t)`.

If instead `v 2 = 0`, the section and the whole stereo pencil lie on that coordinate line.  The
stereo point, and hence the tangent-residual point, is projectively a function of `t` alone even
when the polar form is nonzero.  This is the distinct reason for the `hv2` hypothesis.

`hpolar` does **not** follow from smoothness of `X`.  Its sibling `Q(w) ≠ 0` does
(`specializedConicFreeDirForm_ne_zero_of_smooth`), because `Q(w) ≡ 0` says a whole line lies in the
conic; `B_Q(v, w) ≡ 0` says only that a polar line is in a special position, which is a condition on
the chosen stereographic pencil and on `v`.

*What is missing.*  Exactly one thing: `det_residualYCoordsOn_ne_zero`, the §4 statement.  Given it,
`eq_zero_of_isHomogeneous_of_aeval_eq_zero` finishes, and that is what the proof below does.
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
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) K) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) Ψ = 0) :
    Ψ = 0 :=
  eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField (residualYCoordsOn p₀ q₀ r N F v)
    (ULift.up 0) (ULift.up 1)
    (det_residualYCoordsOn_ne_zero
      p₀ q₀ r N hMN F hF hF0 hgood v hv0 hv hv2 hpolar) d Ψ hΨ hvan

/-- Horizontality in particular guarantees that the residual second-block coordinate triple is
not the zero vector.  This is the exact chart-existence consequence used by the arbitrary-line
component construction. -/
theorem residualYCoordsOn_ne_zero_of_good_line
    [IsAlgClosed K] [CharZero K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (v : Fin 3 → Polynomial K) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0) :
    residualYCoordsOn p₀ q₀ r N F v ≠ 0 := by
  intro hzero
  have hvan : aeval (residualYCoordsOn p₀ q₀ r N F v)
      (X (0 : Fin 3) : MvPolynomial (Fin 3) K) = 0 := by
    rw [hzero]
    simp
  have hXzero := eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous
    p₀ q₀ r N hMN F hF hF0 hgood v hv0 hv hv2 hpolar 1
    (X (0 : Fin 3)) (isHomogeneous_X K 0) hvan
  exact (X_ne_zero (R := K) (0 : Fin 3)) hXzero

end

end

end BConicBundleMultisections
