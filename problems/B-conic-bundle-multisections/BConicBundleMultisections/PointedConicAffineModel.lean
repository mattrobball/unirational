/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.AffineSpace
public import Mathlib.AlgebraicGeometry.Birational.Birational
public import Mathlib.RingTheory.Localization.Away.Basic
public import Mathlib.RingTheory.MvPolynomial.Basic

/-!
# The pointed affine conic and its stereographic parametrization

Stereographic projection for a *family* of conics, done where it is an explicit formula: over an
arbitrary commutative base ring `A`.  This is the algebraic core of obligation 3 (`PLAN.md` WP-3d,
source §4–§5): the base-changed conic bundle acquires a section, and a pointed conic is rational
over its base.

## The model

Translating the section to the origin, a plane affine conic through a marked point is

`f = a x² + b x y + c y² + d x + e y`,

with the marked point `(0,0)`.  Restricting to the line `y = z x` through the origin gives the
*line expansion*

`f (x, z x) = x² · Q(z) + x · L(z)`,   `Q(z) = a + b z + c z²`,  `L(z) = d + e z`,

which is `quadratic_line_expansion` of `PointedConicRational.lean` in affine coordinates: the line
meets the conic at the origin `x = 0` and at the *second* intersection `x = −L(z)/Q(z)`.  That
second intersection is the stereographic parametrization, and it is invertible by `z = y/x`.

## What is proved here

The parametrization is an isomorphism between explicit *localizations*:

`(A[x,y]/(f))` away from `x · (d x + e y)`   ≅   `A[z]` away from `Q(z) · L(z)`.

Both localizations are exactly what the formulas need: `x` and `Q(z)` must be invertible to write
`z = y/x` and `x = −L(z)/Q(z)`, and on the conic `d x + e y = −(a x² + b x y + c y²) = −x² Q(y/x)`,
so inverting `x · (d x + e y)` inverts `x`, `L(y/x)` and `Q(y/x)` at once.

Geometrically this says that a dense open of the pointed conic over `Spec A` is isomorphic, over
`Spec A`, to a dense open of `𝔸¹_{Spec A}` — which is the `BirationalOver` statement the
multisection principle consumes, once the abstract conic bundle has been identified with this
model.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections.PointedConic

noncomputable section

universe u

open MvPolynomial

variable {A : Type u} [CommRing A]

/-! ### The conic and its slope polynomials -/

/-- The general plane affine conic through the origin,
`a x² + b x y + c y² + d x + e y`, in the variables `X 0 = x` and `X 1 = y`.

Every conic with a marked rational point is of this shape after translating the point to the
origin; the marked point is `(0,0)` and the tangent line there is `d x + e y = 0`. -/
def conicPoly (a b c d e : A) : MvPolynomial (Fin 2) A :=
  C a * X 0 ^ 2 + C b * (X 0 * X 1) + C c * X 1 ^ 2 + C d * X 0 + C e * X 1

/-- `Q(z) = a + b z + c z²`: the quadratic part of the conic read along the line `y = z x`.

It is the leading coefficient of the restriction of the conic to that line; `Q(z) = 0` says the
line meets the conic doubly at the origin, i.e. `z` is an asymptotic direction. -/
def slopeQuad (a b c : A) : Polynomial A :=
  Polynomial.C a + Polynomial.C b * Polynomial.X + Polynomial.C c * Polynomial.X ^ 2

/-- `L(z) = d + e z`: the linear part of the conic read along the line `y = z x`.

`L(z) = 0` says the line `y = z x` is the tangent to the conic at the origin, so the second
intersection point degenerates back to the origin. -/
def slopeLin (d e : A) : Polynomial A :=
  Polynomial.C d + Polynomial.C e * Polynomial.X

/-- **The line expansion.**  Restricting the conic to the line `y = z x` gives
`f (x, z x) = x² Q(z) + x L(z)`.

This is `quadratic_line_expansion` (`PointedConicRational.lean`) in affine coordinates, and it is
the only computation stereographic projection needs: the two roots in `x` are `x = 0` (the marked
point) and `x = −L(z)/Q(z)` (the second intersection). -/
theorem eval₂_conicPoly_line {B : Type*} [CommRing B] (ψ : A →+* B) (a b c d e : A) (x z : B) :
    eval₂ ψ ![x, z * x] (conicPoly a b c d e) =
      x ^ 2 * Polynomial.eval₂ ψ z (slopeQuad a b c) +
        x * Polynomial.eval₂ ψ z (slopeLin d e) := by
  simp only [conicPoly, slopeQuad, slopeLin, eval₂_add, eval₂_mul, eval₂_pow, eval₂_C, eval₂_X,
    Polynomial.eval₂_add, Polynomial.eval₂_mul, Polynomial.eval₂_pow, Polynomial.eval₂_C,
    Polynomial.eval₂_X, Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-- The tangent form `d x + e y` at the marked point, whose vanishing locus is the tangent line
there.  Inverting it, together with `x`, is what makes the stereographic formulas invertible. -/
def conicTangentForm (d e : A) : MvPolynomial (Fin 2) A :=
  C d * X 0 + C e * X 1

/-- The chart denominator `x · (d x + e y)` of the stereographic chart on the conic.

Away from it, `x` is invertible (so `z = y/x` makes sense) and — using the conic relation, which
turns `d x + e y` into `−(a x² + b x y + c y²)` — so are `L(y/x) = (d x + e y)/x` and
`Q(y/x) = (a x² + b x y + c y²)/x²`. -/
def conicChartDenom (d e : A) : MvPolynomial (Fin 2) A :=
  X 0 * conicTangentForm d e

/-- Along the line `y = z x` the tangent form is `x · L(z)`. -/
theorem eval₂_conicTangentForm_line {B : Type*} [CommRing B] (ψ : A →+* B) (d e : A) (x z : B) :
    eval₂ ψ ![x, z * x] (conicTangentForm d e) = x * Polynomial.eval₂ ψ z (slopeLin d e) := by
  simp only [conicTangentForm, slopeLin, eval₂_add, eval₂_mul, eval₂_C, eval₂_X,
    Polynomial.eval₂_add, Polynomial.eval₂_mul, Polynomial.eval₂_C, Polynomial.eval₂_X,
    Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-! ### The line chart `A[z]` away from `Q(z) L(z)` -/

variable (a b c d e : A)

/-- The **line chart**: `A[z]` localized away from `Q(z) · L(z)`.

`Q(z)` must be inverted for the second intersection `x = −L(z)/Q(z)` to exist, and `L(z)` for it to
be different from the marked point (equivalently, for `x` to be invertible so that `z = y/x` can be
recovered). -/
abbrev lineChart : Type u := Localization.Away (slopeQuad a b c * slopeLin d e)

/-- The structure map `A → A[z]_{QL}`. -/
def lineC : A →+* lineChart a b c d e :=
  (algebraMap (Polynomial A) (lineChart a b c d e)).comp Polynomial.C

/-- The coordinate `z` of the line chart. -/
def lineZ : lineChart a b c d e := algebraMap (Polynomial A) _ Polynomial.X

/-- Evaluating a polynomial at `z` in the line chart is the structure map. -/
theorem eval₂_lineC_lineZ (p : Polynomial A) :
    Polynomial.eval₂ (lineC a b c d e) (lineZ a b c d e) p =
      algebraMap (Polynomial A) (lineChart a b c d e) p := by
  have h : (Polynomial.eval₂RingHom (lineC a b c d e) (lineZ a b c d e)) =
      algebraMap (Polynomial A) (lineChart a b c d e) :=
    Polynomial.ringHom_ext (fun r => by simp [lineC]) (by simp [lineZ])
  exact congrArg (fun (φ : Polynomial A →+* lineChart a b c d e) => φ p) h

/-- `Q(z)` in the line chart. -/
def lineQ : lineChart a b c d e := algebraMap (Polynomial A) _ (slopeQuad a b c)

/-- `L(z)` in the line chart. -/
def lineL : lineChart a b c d e := algebraMap (Polynomial A) _ (slopeLin d e)

theorem isUnit_lineQ_mul_lineL : IsUnit (lineQ a b c d e * lineL a b c d e) := by
  have h := IsLocalization.Away.algebraMap_isUnit
    (S := lineChart a b c d e) (slopeQuad a b c * slopeLin d e)
  rwa [map_mul] at h

theorem isUnit_lineQ : IsUnit (lineQ a b c d e) :=
  isUnit_of_mul_isUnit_left (isUnit_lineQ_mul_lineL a b c d e)

theorem isUnit_lineL : IsUnit (lineL a b c d e) :=
  isUnit_of_mul_isUnit_right (isUnit_lineQ_mul_lineL a b c d e)

/-- The inverse of `Q(z)` in the line chart. -/
def lineQinv : lineChart a b c d e := ↑(isUnit_lineQ a b c d e).unit⁻¹

@[simp]
theorem lineQ_mul_lineQinv : lineQ a b c d e * lineQinv a b c d e = 1 :=
  (isUnit_lineQ a b c d e).mul_val_inv

/-- **The stereographic second intersection** `x = −L(z)/Q(z)`: the `x`-coordinate of the point
where the line `y = z x` meets the conic away from the marked point. -/
def lineX : lineChart a b c d e := -(lineL a b c d e * lineQinv a b c d e)

/-- `x · Q(z) = −L(z)`: the defining property of the second intersection. -/
theorem lineX_mul_lineQ : lineX a b c d e * lineQ a b c d e = -lineL a b c d e := by
  rw [lineX, neg_mul, mul_assoc, mul_comm (lineQinv a b c d e), lineQ_mul_lineQinv, mul_one]

/-- **The stereographic point lies on the conic.**  This is the family version of
`conicParametrization_is_isotropic`, and the reason the parametrization is well defined. -/
theorem eval₂_conicPoly_lineX :
    eval₂ (lineC a b c d e) ![lineX a b c d e, lineZ a b c d e * lineX a b c d e]
      (conicPoly a b c d e) = 0 := by
  rw [eval₂_conicPoly_line, eval₂_lineC_lineZ, eval₂_lineC_lineZ]
  change lineX a b c d e ^ 2 * lineQ a b c d e + lineX a b c d e * lineL a b c d e = 0
  have h : lineX a b c d e ^ 2 * lineQ a b c d e =
      lineX a b c d e * (lineX a b c d e * lineQ a b c d e) := by ring
  rw [h, lineX_mul_lineQ]
  ring

theorem isUnit_lineX : IsUnit (lineX a b c d e) :=
  ((isUnit_lineL a b c d e).mul (isUnit_lineQ a b c d e).unit⁻¹.isUnit).neg

/-! ### The conic chart -/

/-- The quadratic part `a x² + b x y + c y²` of the conic. -/
def conicQuadForm (a b c : A) : MvPolynomial (Fin 2) A :=
  C a * X 0 ^ 2 + C b * (X 0 * X 1) + C c * X 1 ^ 2

/-- The conic is its quadratic part plus its tangent form:
`f = (a x² + b x y + c y²) + (d x + e y)`.  On the conic itself the two are therefore negatives
of each other, which is what makes inverting `x · (d x + e y)` also invert the quadratic part. -/
theorem conicPoly_eq_add : conicPoly a b c d e = conicQuadForm a b c + conicTangentForm d e := by
  simp only [conicPoly, conicQuadForm, conicTangentForm]
  ring

/-- The coordinate ring of the pointed affine conic `a x² + b x y + c y² + d x + e y = 0`. -/
abbrev conicRing : Type u := MvPolynomial (Fin 2) A ⧸ Ideal.span {conicPoly a b c d e}

/-- Reduction from the polynomial ring to the conic ring. -/
def conicMk : MvPolynomial (Fin 2) A →+* conicRing a b c d e := Ideal.Quotient.mk _

theorem conicMk_conicPoly : conicMk a b c d e (conicPoly a b c d e) = 0 :=
  Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.subset_span rfl)

/-- The **conic chart**: the conic ring localized away from `x · (d x + e y)`. -/
abbrev conicChart : Type u := Localization.Away (conicMk a b c d e (conicChartDenom d e))

/-- Evaluation of a plane polynomial in the conic chart. -/
def conicEval : MvPolynomial (Fin 2) A →+* conicChart a b c d e :=
  (algebraMap (conicRing a b c d e) (conicChart a b c d e)).comp (conicMk a b c d e)

/-- The structure map `A → conic chart`. -/
def conicC : A →+* conicChart a b c d e := (conicEval a b c d e).comp MvPolynomial.C

/-- The coordinate `x` in the conic chart. -/
def conicX : conicChart a b c d e := conicEval a b c d e (X 0)

/-- The coordinate `y` in the conic chart. -/
def conicY : conicChart a b c d e := conicEval a b c d e (X 1)

/-- The tangent form `d x + e y` in the conic chart. -/
def conicT : conicChart a b c d e := conicEval a b c d e (conicTangentForm d e)

/-- Evaluation in the conic chart is evaluation at the coordinates. -/
theorem eval₂_conicC_coords (p : MvPolynomial (Fin 2) A) :
    eval₂ (conicC a b c d e) ![conicX a b c d e, conicY a b c d e] p = conicEval a b c d e p := by
  have h : (eval₂Hom (conicC a b c d e) ![conicX a b c d e, conicY a b c d e]) =
      conicEval a b c d e := by
    refine MvPolynomial.ringHom_ext (fun r => by simp [conicC]) (fun i => ?_)
    fin_cases i <;> simp [conicX, conicY]
  exact congrArg (fun (φ : MvPolynomial (Fin 2) A →+* conicChart a b c d e) => φ p) h

theorem conicEval_conicPoly : conicEval a b c d e (conicPoly a b c d e) = 0 := by
  rw [conicEval, RingHom.comp_apply, conicMk_conicPoly, map_zero]

/-- On the conic, the quadratic part is minus the tangent form. -/
theorem conicEval_conicQuadForm_eq_neg :
    conicEval a b c d e (conicQuadForm a b c) = -conicT a b c d e := by
  have hsum : conicQuadForm a b c + conicTangentForm d e = conicPoly a b c d e :=
    (conicPoly_eq_add a b c d e).symm
  have h0 : conicEval a b c d e (conicQuadForm a b c + conicTangentForm d e) = 0 := by
    rw [hsum]
    exact conicEval_conicPoly a b c d e
  rw [map_add] at h0
  exact eq_neg_of_add_eq_zero_left h0

theorem isUnit_conicX_mul_conicT :
    IsUnit (conicX a b c d e * conicT a b c d e) := by
  have h := IsLocalization.Away.algebraMap_isUnit
    (S := conicChart a b c d e) (conicMk a b c d e (conicChartDenom d e))
  have hEq : (algebraMap (conicRing a b c d e) (conicChart a b c d e))
      (conicMk a b c d e (conicChartDenom d e)) =
      conicX a b c d e * conicT a b c d e := by
    rw [conicX, conicT, ← map_mul]
    rfl
  rwa [hEq] at h

theorem isUnit_conicX : IsUnit (conicX a b c d e) :=
  isUnit_of_mul_isUnit_left (isUnit_conicX_mul_conicT a b c d e)

theorem isUnit_conicT : IsUnit (conicT a b c d e) :=
  isUnit_of_mul_isUnit_right (isUnit_conicX_mul_conicT a b c d e)

/-- The inverse of `x` in the conic chart. -/
def conicXinv : conicChart a b c d e := ↑(isUnit_conicX a b c d e).unit⁻¹

@[simp]
theorem conicX_mul_conicXinv : conicX a b c d e * conicXinv a b c d e = 1 :=
  (isUnit_conicX a b c d e).mul_val_inv

/-- **The stereographic coordinate** `z = y / x` on the conic chart. -/
def conicZ : conicChart a b c d e := conicY a b c d e * conicXinv a b c d e

/-! ### The stereographic parametrization `line chart → conic chart` -/

/-- Stereographic parametrization at the level of the polynomial ring:
`x ↦ −L(z)/Q(z)`, `y ↦ z · (−L(z)/Q(z))`. -/
def lineParamHom : MvPolynomial (Fin 2) A →+* lineChart a b c d e :=
  eval₂Hom (lineC a b c d e) ![lineX a b c d e, lineZ a b c d e * lineX a b c d e]

@[simp]
theorem lineParamHom_X_zero : lineParamHom a b c d e (X 0) = lineX a b c d e := by
  simp [lineParamHom]

@[simp]
theorem lineParamHom_X_one :
    lineParamHom a b c d e (X 1) = lineZ a b c d e * lineX a b c d e := by
  simp [lineParamHom]

theorem lineParamHom_conicPoly : lineParamHom a b c d e (conicPoly a b c d e) = 0 :=
  eval₂_conicPoly_lineX a b c d e

theorem lineParamHom_conicTangentForm :
    lineParamHom a b c d e (conicTangentForm d e) = lineX a b c d e * lineL a b c d e := by
  change eval₂ (lineC a b c d e) ![lineX a b c d e, lineZ a b c d e * lineX a b c d e]
      (conicTangentForm d e) = _
  rw [eval₂_conicTangentForm_line, eval₂_lineC_lineZ]
  rfl

/-- Stereographic parametrization, factored through the conic ring: legitimate because the
parametrized point lies on the conic (`eval₂_conicPoly_lineX`). -/
def conicRingToLine : conicRing a b c d e →+* lineChart a b c d e :=
  Ideal.Quotient.lift _ (lineParamHom a b c d e) (by
    intro p hp
    rw [Ideal.mem_span_singleton] at hp
    obtain ⟨q, rfl⟩ := hp
    rw [map_mul, lineParamHom_conicPoly, zero_mul])

@[simp]
theorem conicRingToLine_mk (p : MvPolynomial (Fin 2) A) :
    conicRingToLine a b c d e (conicMk a b c d e p) = lineParamHom a b c d e p := rfl

theorem isUnit_conicRingToLine_chartDenom :
    IsUnit (conicRingToLine a b c d e (conicMk a b c d e (conicChartDenom d e))) := by
  rw [conicRingToLine_mk, conicChartDenom, map_mul, lineParamHom_X_zero,
    lineParamHom_conicTangentForm]
  exact (isUnit_lineX a b c d e).mul ((isUnit_lineX a b c d e).mul (isUnit_lineL a b c d e))

/-- **Stereographic projection**, as a ring map from the conic chart to the line chart. -/
def conicToLine : conicChart a b c d e →+* lineChart a b c d e :=
  IsLocalization.Away.lift (g := conicRingToLine a b c d e) _
    (isUnit_conicRingToLine_chartDenom a b c d e)

@[simp]
theorem conicToLine_conicEval (p : MvPolynomial (Fin 2) A) :
    conicToLine a b c d e (conicEval a b c d e p) = lineParamHom a b c d e p := by
  rw [conicEval, RingHom.comp_apply, conicToLine, IsLocalization.Away.lift_eq,
    conicRingToLine_mk]

/-! ### The inverse `line chart → conic chart` -/

/-- The inverse parametrization at the level of `A[z]`: `z ↦ y/x`. -/
def conicParamHom : Polynomial A →+* conicChart a b c d e :=
  Polynomial.eval₂RingHom (conicC a b c d e) (conicZ a b c d e)

theorem conicEval_conicQuadForm_expand :
    conicEval a b c d e (conicQuadForm a b c) =
      conicC a b c d e a * conicX a b c d e ^ 2 +
        conicC a b c d e b * (conicX a b c d e * conicY a b c d e) +
        conicC a b c d e c * conicY a b c d e ^ 2 := by
  rw [← eval₂_conicC_coords]
  simp [conicQuadForm]

theorem conicEval_conicTangentForm_expand :
    conicT a b c d e =
      conicC a b c d e d * conicX a b c d e + conicC a b c d e e * conicY a b c d e := by
  rw [conicT, ← eval₂_conicC_coords]
  simp [conicTangentForm]

theorem conicParamHom_slopeQuad :
    conicParamHom a b c d e (slopeQuad a b c) =
      conicEval a b c d e (conicQuadForm a b c) * conicXinv a b c d e ^ 2 := by
  have hx := conicX_mul_conicXinv a b c d e
  have hlhs : conicParamHom a b c d e (slopeQuad a b c) =
      conicC a b c d e a + conicC a b c d e b * conicZ a b c d e +
        conicC a b c d e c * conicZ a b c d e ^ 2 := by
    change Polynomial.eval₂ (conicC a b c d e) (conicZ a b c d e) (slopeQuad a b c) = _
    simp [slopeQuad]
  rw [hlhs, conicEval_conicQuadForm_expand, conicZ]
  calc
    conicC a b c d e a + conicC a b c d e b * (conicY a b c d e * conicXinv a b c d e) +
        conicC a b c d e c * (conicY a b c d e * conicXinv a b c d e) ^ 2
        = conicC a b c d e a * (conicX a b c d e * conicXinv a b c d e) ^ 2 +
          conicC a b c d e b *
            ((conicX a b c d e * conicXinv a b c d e) *
              (conicY a b c d e * conicXinv a b c d e)) +
          conicC a b c d e c * (conicY a b c d e * conicXinv a b c d e) ^ 2 := by
          rw [hx]; ring
    _ = _ := by ring

theorem conicParamHom_slopeLin :
    conicParamHom a b c d e (slopeLin d e) = conicT a b c d e * conicXinv a b c d e := by
  have hx := conicX_mul_conicXinv a b c d e
  have hlhs : conicParamHom a b c d e (slopeLin d e) =
      conicC a b c d e d + conicC a b c d e e * conicZ a b c d e := by
    change Polynomial.eval₂ (conicC a b c d e) (conicZ a b c d e) (slopeLin d e) = _
    simp [slopeLin]
  rw [hlhs, conicEval_conicTangentForm_expand, conicZ]
  calc
    conicC a b c d e d + conicC a b c d e e * (conicY a b c d e * conicXinv a b c d e)
        = conicC a b c d e d * (conicX a b c d e * conicXinv a b c d e) +
          conicC a b c d e e * (conicY a b c d e * conicXinv a b c d e) := by rw [hx]; ring
    _ = _ := by ring

theorem isUnit_conicXinv : IsUnit (conicXinv a b c d e) :=
  (isUnit_conicX a b c d e).unit⁻¹.isUnit

theorem isUnit_conicParamHom_slope :
    IsUnit (conicParamHom a b c d e (slopeQuad a b c * slopeLin d e)) := by
  rw [map_mul, conicParamHom_slopeQuad, conicParamHom_slopeLin,
    conicEval_conicQuadForm_eq_neg]
  exact (((isUnit_conicT a b c d e).neg).mul
      ((isUnit_conicXinv a b c d e).pow 2)).mul
    ((isUnit_conicT a b c d e).mul (isUnit_conicXinv a b c d e))

/-- **The inverse of stereographic projection**, as a ring map from the line chart to the conic
chart: `z ↦ y/x`. -/
def lineToConic : lineChart a b c d e →+* conicChart a b c d e :=
  IsLocalization.Away.lift (g := conicParamHom a b c d e) _
    (isUnit_conicParamHom_slope a b c d e)

@[simp]
theorem lineToConic_algebraMap (p : Polynomial A) :
    lineToConic a b c d e (algebraMap (Polynomial A) (lineChart a b c d e) p) =
      conicParamHom a b c d e p :=
  IsLocalization.Away.lift_eq _ _ _

/-! ### The two maps are mutually inverse -/

@[simp]
theorem conicToLine_conicX : conicToLine a b c d e (conicX a b c d e) = lineX a b c d e := by
  rw [conicX, conicToLine_conicEval, lineParamHom_X_zero]

@[simp]
theorem conicToLine_conicY :
    conicToLine a b c d e (conicY a b c d e) = lineZ a b c d e * lineX a b c d e := by
  rw [conicY, conicToLine_conicEval, lineParamHom_X_one]

@[simp]
theorem conicToLine_conicC (r : A) :
    conicToLine a b c d e (conicC a b c d e r) = lineC a b c d e r := by
  rw [conicC, RingHom.comp_apply, conicToLine_conicEval]
  simp [lineParamHom]

/-- Stereographic projection recovers the slope: `y/x ↦ z`. -/
@[simp]
theorem conicToLine_conicZ : conicToLine a b c d e (conicZ a b c d e) = lineZ a b c d e := by
  have hinv : lineX a b c d e * conicToLine a b c d e (conicXinv a b c d e) = 1 := by
    rw [← conicToLine_conicX, ← map_mul, conicX_mul_conicXinv, map_one]
  rw [conicZ, map_mul, conicToLine_conicY, mul_assoc, hinv, mul_one]

@[simp]
theorem lineToConic_lineC (r : A) :
    lineToConic a b c d e (lineC a b c d e r) = conicC a b c d e r := by
  rw [lineC, RingHom.comp_apply, lineToConic_algebraMap]
  change Polynomial.eval₂ (conicC a b c d e) (conicZ a b c d e) (Polynomial.C r) = _
  simp

@[simp]
theorem lineToConic_lineZ : lineToConic a b c d e (lineZ a b c d e) = conicZ a b c d e := by
  rw [lineZ, lineToConic_algebraMap]
  change Polynomial.eval₂ (conicC a b c d e) (conicZ a b c d e) Polynomial.X = _
  simp

theorem lineToConic_lineQ :
    lineToConic a b c d e (lineQ a b c d e) =
      -conicT a b c d e * conicXinv a b c d e ^ 2 := by
  rw [lineQ, lineToConic_algebraMap, conicParamHom_slopeQuad, conicEval_conicQuadForm_eq_neg]

theorem lineToConic_lineL :
    lineToConic a b c d e (lineL a b c d e) = conicT a b c d e * conicXinv a b c d e := by
  rw [lineL, lineToConic_algebraMap, conicParamHom_slopeLin]

/-- The inverse parametrization recovers the `x`-coordinate: `−L(z)/Q(z) ↦ x`. -/
@[simp]
theorem lineToConic_lineX : lineToConic a b c d e (lineX a b c d e) = conicX a b c d e := by
  set u : conicChart a b c d e := -conicT a b c d e * conicXinv a b c d e ^ 2 with hu_def
  have hu : IsUnit u := by
    rw [hu_def]
    exact ((isUnit_conicT a b c d e).neg).mul ((isUnit_conicXinv a b c d e).pow 2)
  have hprod : u * lineToConic a b c d e (lineQinv a b c d e) = 1 := by
    rw [hu_def, ← lineToConic_lineQ, ← map_mul, lineQ_mul_lineQinv, map_one]
  refine hu.mul_left_cancel ?_
  rw [lineX, map_neg, map_mul, lineToConic_lineL]
  have hx := conicX_mul_conicXinv a b c d e
  calc
    u * -(conicT a b c d e * conicXinv a b c d e *
        lineToConic a b c d e (lineQinv a b c d e))
        = -(conicT a b c d e * conicXinv a b c d e) *
            (u * lineToConic a b c d e (lineQinv a b c d e)) := by ring
    _ = -(conicT a b c d e * conicXinv a b c d e) := by rw [hprod, mul_one]
    _ = -conicT a b c d e * conicXinv a b c d e *
          (conicX a b c d e * conicXinv a b c d e) := by rw [hx]; ring
    _ = u * conicX a b c d e := by rw [hu_def]; ring

/-- **Stereographic projection is a two-sided inverse**, first composite. -/
theorem conicToLine_comp_lineToConic :
    (conicToLine a b c d e).comp (lineToConic a b c d e) =
      RingHom.id (lineChart a b c d e) := by
  refine IsLocalization.ringHom_ext (Submonoid.powers (slopeQuad a b c * slopeLin d e)) ?_
  refine Polynomial.ringHom_ext (fun r => ?_) ?_
  · change conicToLine a b c d e (lineToConic a b c d e (lineC a b c d e r)) = lineC a b c d e r
    rw [lineToConic_lineC, conicToLine_conicC]
  · change conicToLine a b c d e (lineToConic a b c d e (lineZ a b c d e)) = lineZ a b c d e
    rw [lineToConic_lineZ, conicToLine_conicZ]

/-- The inverse parametrization undoes stereographic projection on the polynomial generators. -/
theorem lineToConic_conicToLine_conicEval (p : MvPolynomial (Fin 2) A) :
    lineToConic a b c d e (conicToLine a b c d e (conicEval a b c d e p)) =
      conicEval a b c d e p := by
  have h : ((lineToConic a b c d e).comp (conicToLine a b c d e)).comp (conicEval a b c d e) =
      conicEval a b c d e := by
    refine MvPolynomial.ringHom_ext (fun r => ?_) ?_
    · change lineToConic a b c d e (conicToLine a b c d e (conicC a b c d e r)) =
        conicC a b c d e r
      rw [conicToLine_conicC, lineToConic_lineC]
    · rw [Fin.forall_fin_two]
      refine ⟨?_, ?_⟩
      · change lineToConic a b c d e (conicToLine a b c d e (conicX a b c d e)) =
          conicX a b c d e
        rw [conicToLine_conicX, lineToConic_lineX]
      · change lineToConic a b c d e (conicToLine a b c d e (conicY a b c d e)) =
          conicY a b c d e
        rw [conicToLine_conicY, map_mul, lineToConic_lineZ, lineToConic_lineX,
          conicZ, mul_assoc, mul_comm (conicXinv a b c d e), conicX_mul_conicXinv, mul_one]
  exact congrArg (fun (φ : MvPolynomial (Fin 2) A →+* conicChart a b c d e) => φ p) h

/-- **Stereographic projection is a two-sided inverse**, second composite. -/
theorem lineToConic_comp_conicToLine :
    (lineToConic a b c d e).comp (conicToLine a b c d e) =
      RingHom.id (conicChart a b c d e) := by
  refine IsLocalization.ringHom_ext
    (Submonoid.powers (conicMk a b c d e (conicChartDenom d e))) ?_
  refine RingHom.ext fun r => ?_
  obtain ⟨p, rfl⟩ :=
    Ideal.Quotient.mk_surjective (I := Ideal.span {conicPoly a b c d e}) r
  exact lineToConic_conicToLine_conicEval a b c d e p

/-- **The stereographic parametrization is an isomorphism of charts.**

`A[x,y]/(a x² + b x y + c y² + d x + e y)` away from `x (d x + e y)` is isomorphic to `A[z]` away
from `Q(z) L(z)`.  This is the relative form of "a conic with a rational point is rational"
(source §4–§5), with the marked point at the origin and the parameter `z = y/x` the slope of the
line through it. -/
def conicChartEquivLineChart : conicChart a b c d e ≃+* lineChart a b c d e :=
  RingEquiv.ofRingHom (conicToLine a b c d e) (lineToConic a b c d e)
    (conicToLine_comp_lineToConic a b c d e) (lineToConic_comp_conicToLine a b c d e)

/-- `A`-linearity of the stereographic parametrization. -/
theorem lineToConic_comp_lineC :
    (lineToConic a b c d e).comp (lineC a b c d e) = conicC a b c d e :=
  RingHom.ext (lineToConic_lineC a b c d e)

/-- The chart isomorphism, read as an isomorphism `line chart ≅ conic chart` in `CommRingCat`;
`Spec` of it is the scheme-level stereographic parametrization. -/
def lineChartIsoConicChart :
    CommRingCat.of (lineChart a b c d e) ≅ CommRingCat.of (conicChart a b c d e) where
  hom := CommRingCat.ofHom (lineToConic a b c d e)
  inv := CommRingCat.ofHom (conicToLine a b c d e)
  hom_inv_id := by
    rw [← CommRingCat.ofHom_comp, conicToLine_comp_lineToConic]; rfl
  inv_hom_id := by
    rw [← CommRingCat.ofHom_comp, lineToConic_comp_conicToLine]; rfl

/-! ### Scheme-level packaging

A basic open of the spectrum of a domain is dense, so the chart isomorphism is a
`Scheme.PartialIso` between the pointed conic and the affine line over `Spec A`, and it is a map
over `Spec A` because the chart isomorphism is `A`-linear (`lineToConic_lineC`).
-/

open AlgebraicGeometry

/-- A nonempty basic open of the spectrum of a domain is dense. -/
theorem dense_basicOpen {R : Type u} [CommRing R] [IsDomain R] {g : R} (hg : g ≠ 0) :
    Dense (SetLike.coe (PrimeSpectrum.basicOpen g) : Set (Spec (CommRingCat.of R))) := by
  haveI : IrreducibleSpace (Spec (CommRingCat.of R)) := inferInstance
  haveI : PreirreducibleSpace (Spec (CommRingCat.of R)) :=
    (inferInstance : IrreducibleSpace _).toPreirreducibleSpace
  have hne : PrimeSpectrum.basicOpen g ≠ ⊥ :=
    mt (PrimeSpectrum.basicOpen_eq_bot_iff _).mp (fun h => hg h.eq_zero)
  have hnonempty :
      (SetLike.coe (PrimeSpectrum.basicOpen g) : Set (PrimeSpectrum R)).Nonempty := by
    rw [Set.nonempty_iff_ne_empty]
    exact fun hempty => hne (TopologicalSpace.Opens.ext hempty)
  exact (PrimeSpectrum.basicOpen g).isOpen.dense hnonempty

/-- The pointed affine conic as a scheme over `Spec A`. -/
abbrev conicScheme : Scheme.{u} := Spec (CommRingCat.of (conicRing a b c d e))

/-- Structure morphism of the pointed affine conic over `Spec A`. -/
def conicSchemeToSpec : conicScheme a b c d e ⟶ Spec (CommRingCat.of A) :=
  Spec.map (CommRingCat.ofHom ((conicMk a b c d e).comp MvPolynomial.C))

/-- Structure morphism of the affine line `Spec A[z]` over `Spec A`. -/
def lineSchemeToSpec : Spec (CommRingCat.of (Polynomial A)) ⟶ Spec (CommRingCat.of A) :=
  Spec.map (CommRingCat.ofHom (Polynomial.C : A →+* Polynomial A))

/-- The stereographic chart isomorphism, as an isomorphism of open subschemes:
`D(x (d x + e y)) ⊆ conic` is isomorphic to `D(Q(z) L(z)) ⊆ 𝔸¹`. -/
def specLineChartIso :
    Spec (CommRingCat.of (conicChart a b c d e)) ≅
      Spec (CommRingCat.of (lineChart a b c d e)) where
  hom := Spec.map (lineChartIsoConicChart a b c d e).hom
  inv := Spec.map (lineChartIsoConicChart a b c d e).inv
  hom_inv_id := by rw [← Spec.map_comp, Iso.inv_hom_id, Spec.map_id]
  inv_hom_id := by rw [← Spec.map_comp, Iso.hom_inv_id, Spec.map_id]

/-- The stereographic chart isomorphism, as an isomorphism of open subschemes:
`D(x (d x + e y))` inside the conic is isomorphic to `D(Q(z) L(z))` inside `𝔸¹`. -/
def conicPartialIso :
    Scheme.Opens.toScheme (X := conicScheme a b c d e)
        (PrimeSpectrum.basicOpen (conicMk a b c d e (conicChartDenom d e))) ≅
      Scheme.Opens.toScheme (X := Spec (CommRingCat.of (Polynomial A)))
        (PrimeSpectrum.basicOpen (slopeQuad a b c * slopeLin d e)) :=
  basicOpenIsoSpecAway (R := CommRingCat.of (conicRing a b c d e))
      (conicMk a b c d e (conicChartDenom d e)) ≪≫
    specLineChartIso a b c d e ≪≫
    (basicOpenIsoSpecAway (R := CommRingCat.of (Polynomial A))
      (slopeQuad a b c * slopeLin d e)).symm

/-- The chart isomorphism is a map over `Spec A`: this is `A`-linearity of the stereographic
formulas, `lineToConic_lineC`. -/
theorem conicPartialIso_isOver :
    (conicPartialIso a b c d e).hom ≫
        (Scheme.Opens.ι (X := Spec (CommRingCat.of (Polynomial A)))
          (PrimeSpectrum.basicOpen (slopeQuad a b c * slopeLin d e))) ≫
          lineSchemeToSpec (A := A) =
      (Scheme.Opens.ι (X := conicScheme a b c d e)
        (PrimeSpectrum.basicOpen (conicMk a b c d e (conicChartDenom d e)))) ≫
        conicSchemeToSpec a b c d e := by
  have hline :
      (Scheme.Opens.ι (X := Spec (CommRingCat.of (Polynomial A)))
          (PrimeSpectrum.basicOpen (slopeQuad a b c * slopeLin d e))) =
        (basicOpenIsoSpecAway (R := CommRingCat.of (Polynomial A))
            (slopeQuad a b c * slopeLin d e)).hom ≫
          Spec.map (CommRingCat.ofHom
            (algebraMap (Polynomial A) (lineChart a b c d e))) :=
    (basicOpenIsoSpecAway_hom_SpecMap _).symm
  have hconic :
      (Scheme.Opens.ι (X := conicScheme a b c d e)
          (PrimeSpectrum.basicOpen (conicMk a b c d e (conicChartDenom d e)))) =
        (basicOpenIsoSpecAway (R := CommRingCat.of (conicRing a b c d e))
            (conicMk a b c d e (conicChartDenom d e))).hom ≫
          Spec.map (CommRingCat.ofHom
            (algebraMap (conicRing a b c d e) (conicChart a b c d e))) :=
    (basicOpenIsoSpecAway_hom_SpecMap _).symm
  rw [hline, hconic, conicPartialIso]
  simp only [Iso.trans_hom, Iso.symm_hom, Category.assoc, Iso.inv_hom_id_assoc,
    lineSchemeToSpec, conicSchemeToSpec, specLineChartIso, lineChartIsoConicChart]
  simp only [← Spec.map_comp, ← CommRingCat.ofHom_comp]
  rw [show (lineToConic a b c d e).comp
        ((algebraMap (Polynomial A) (lineChart a b c d e)).comp Polynomial.C) =
      conicC a b c d e from lineToConic_comp_lineC a b c d e]
  rfl

/-- **A pointed affine conic over a domain is relatively rational** (source §4–§5).

For a domain `A`, an integral conic `a x² + b x y + c y² + d x + e y = 0` whose slope polynomials
`Q(z) = a + bz + cz²` and `L(z) = d + ez` are nonzero and whose stereographic chart is nonempty is
`Spec A`-birational to the affine line `Spec A[z]`.

This is the family form of "a conic with a rational point is rational": the marked point is the
origin, and the birational map is projection from it. -/
theorem birationalOver_conicScheme [IsDomain A] [IsDomain (conicRing a b c d e)]
    (hQ : slopeQuad a b c ≠ 0) (hL : slopeLin d e ≠ 0)
    (hden : conicMk a b c d e (conicChartDenom d e) ≠ 0) :
    Scheme.BirationalOver (conicSchemeToSpec a b c d e) (lineSchemeToSpec (A := A)) :=
  ⟨{ source := PrimeSpectrum.basicOpen (conicMk a b c d e (conicChartDenom d e))
     dense_source := dense_basicOpen hden
     target := PrimeSpectrum.basicOpen (slopeQuad a b c * slopeLin d e)
     dense_target := dense_basicOpen (mul_ne_zero hQ hL)
     iso := conicPartialIso a b c d e },
   conicPartialIso_isOver a b c d e⟩

/-! ### Landing on relative affine `1`-space

`IsPointedConicRationalOver` is stated against `𝔸(ULift (Fin 1); -)`, so the last step is the
(purely formal) identification `Spec A[z] ≅ 𝔸(ULift (Fin 1); Spec A)` over `Spec A`.
-/

/-- `A[z] ≅ A[ULift (Fin 1)]`: the index type has exactly one element. -/
def uniqueMvPolynomialEquiv :
    MvPolynomial (ULift.{u} (Fin 1)) A →+* Polynomial A :=
  (MvPolynomial.uniqueAlgEquiv A (ULift.{u} (Fin 1))).toRingEquiv.toRingHom

theorem uniqueMvPolynomialEquiv_comp_C :
    (uniqueMvPolynomialEquiv (A := A)).comp (MvPolynomial.C : A →+* _) =
      (Polynomial.C : A →+* Polynomial A) := by
  refine RingHom.ext fun r => ?_
  exact (MvPolynomial.uniqueAlgEquiv A (ULift.{u} (Fin 1))).commutes r

/-- `Spec A[z]` is isomorphic to relative affine `1`-space over `Spec A`. -/
def lineSchemeIsoAffineSpace :
    Spec (CommRingCat.of (Polynomial A)) ≅ 𝔸(ULift.{u} (Fin 1); Spec (CommRingCat.of A)) :=
  { hom := Spec.map (CommRingCat.ofHom (uniqueMvPolynomialEquiv (A := A))) ≫
      (AffineSpace.SpecIso (ULift.{u} (Fin 1)) (CommRingCat.of A)).inv
    inv := (AffineSpace.SpecIso (ULift.{u} (Fin 1)) (CommRingCat.of A)).hom ≫
      Spec.map (CommRingCat.ofHom
        ((MvPolynomial.uniqueAlgEquiv A (ULift.{u} (Fin 1))).toRingEquiv.symm.toRingHom))
    hom_inv_id := by
      simp only [Category.assoc, Iso.inv_hom_id_assoc, ← Spec.map_comp,
        ← CommRingCat.ofHom_comp]
      rw [show (uniqueMvPolynomialEquiv (A := A)).comp
          ((MvPolynomial.uniqueAlgEquiv A (ULift.{u} (Fin 1))).toRingEquiv.symm.toRingHom) =
          RingHom.id _ from
        RingHom.ext fun p => (MvPolynomial.uniqueAlgEquiv A (ULift.{u} (Fin 1))).apply_symm_apply p]
      simp
    inv_hom_id := by
      simp only [Category.assoc, ← Spec.map_comp_assoc, ← CommRingCat.ofHom_comp]
      rw [show ((MvPolynomial.uniqueAlgEquiv A (ULift.{u} (Fin 1))).toRingEquiv.symm.toRingHom).comp
          (uniqueMvPolynomialEquiv (A := A)) = RingHom.id _ from
        RingHom.ext fun p => (MvPolynomial.uniqueAlgEquiv A (ULift.{u} (Fin 1))).symm_apply_apply p]
      simp }

theorem lineSchemeIsoAffineSpace_hom_over :
    (lineSchemeIsoAffineSpace (A := A)).hom ≫
        (𝔸(ULift.{u} (Fin 1); Spec (CommRingCat.of A)) ↘ Spec (CommRingCat.of A)) =
      lineSchemeToSpec (A := A) := by
  rw [lineSchemeIsoAffineSpace, Category.assoc, AffineSpace.SpecIso_inv_over, lineSchemeToSpec,
    ← Spec.map_comp, ← CommRingCat.ofHom_comp, uniqueMvPolynomialEquiv_comp_C]

/-- **A pointed affine conic over a domain is relatively rational**, in the form the multisection
principle consumes: `Spec A`-birational to relative affine `1`-space.

This is the complete classical input of obligation 3 (source §4–§5, `PLAN.md` WP-3d), for an
arbitrary base ring: what remains of the obligation is only the *identification* of the abstract
conic bundle with a model of this shape. -/
theorem birationalOver_conicScheme_affineSpace [IsDomain A] [IsDomain (conicRing a b c d e)]
    (hQ : slopeQuad a b c ≠ 0) (hL : slopeLin d e ≠ 0)
    (hden : conicMk a b c d e (conicChartDenom d e) ≠ 0) :
    Scheme.BirationalOver (conicSchemeToSpec a b c d e)
      (𝔸(ULift.{u} (Fin 1); Spec (CommRingCat.of A)) ↘ Spec (CommRingCat.of A)) :=
  (birationalOver_conicScheme a b c d e hQ hL hden).trans
    (Scheme.Hom.birationalOver (lineSchemeIsoAffineSpace (A := A)).hom _ _
      (lineSchemeIsoAffineSpace_hom_over (A := A)))

end

end BConicBundleMultisections.PointedConic
