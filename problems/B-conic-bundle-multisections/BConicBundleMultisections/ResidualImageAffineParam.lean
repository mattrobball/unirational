/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.AffineSpaceProduct
public import BConicBundleMultisections.BinaryCubicLineCoeff
public import BConicBundleMultisections.BinaryCubicResidual
public import BConicBundleMultisections.HomogeneousQuadraticEval
public import BConicBundleMultisections.PlaneCubicPartials
public import BConicBundleMultisections.PlaneCubicResidualIdentity
public import BConicBundleMultisections.PlaneCubicResidualVanishing
public import BConicBundleMultisections.ProjectiveLineRestriction
public import BConicBundleMultisections.ProjectiveTangentHyperplane
public import BConicBundleMultisections.ResidualBaseChangeUnirational
public import BConicBundleMultisections.ResidualDivisor
public import BConicBundleMultisections.ResidualImageAlgebraPoint
public import BConicBundleMultisections.ResidualMultisectionDominant
public import BConicBundleMultisections.VerticalSurface
public import Mathlib.Algebra.MvPolynomial.Funext
public import Mathlib.AlgebraicGeometry.AffineSpace

/-!
# Affine 2-space morphisms into residual image via normalized coordinates

Given residual-image coordinates over the affine plane ring
`affineTwoRing R = R[t,s]`,

`residualImagePointOfNormalized` supplies
`Spec R[t,s] → residualImage F` for an equation `F` over that ring.

Composing with `AffineSpace.SpecIso` yields a total morphism
`𝔸²_{Spec R} → residualImage F` with
`residualImageOfHomAffineTwo ≫ residualImageToSpec = SpecIso.hom`.

For a `k`-equation `F₀`, use `affineTwoPullback F₀ = map C F₀`. Classical residual-image
coordinates come from Tsen+stereo on the coordinate-line vertical surface followed by the
tangent-residual map; algebraic stereo is in `VerticalSurface`, residual-image point lifts
in `ResidualMultisectionDominant`.

The algebra-valued residual image point `residualImagePointOfNormalizedAlgebra` lands residual
coordinates over `k[t,s]` directly into `residualImage F` over `Spec k` (no pullback residual
image). Remaining for `HasResidualImageUnirationalParametrization2 F₀`:
1. chart-normalization of residual coords (or dense-open / function-field packaging);
2. dominance of the resulting map `𝔸² → residualImage F`.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry Scheme MvPolynomial BiprojectiveSpace ResidualDivisor
open _root_.MvPolynomial

/-- Coordinate ring of affine 2-space over a commutative ring. -/
abbrev affineTwoRing (R : Type u) [CommRing R] : Type u :=
  MvPolynomial (ULift.{u} (Fin 2)) R

/-- First affine coordinate of `𝔸²`. -/
def affineTwoCoord0 (R : Type u) [CommRing R] : affineTwoRing R :=
  X (ULift.up 0)

/-- Second affine coordinate of `𝔸²`. -/
def affineTwoCoord1 (R : Type u) [CommRing R] : affineTwoRing R :=
  X (ULift.up 1)

/-- Coordinate-line second-block representative `(1, t, 0)` over the affine plane. -/
def affineTwoCoordinateLineY (R : Type u) [CommRing R] : Fin 3 → affineTwoRing R :=
  ![1, affineTwoCoord0 R, 0]

@[simp] theorem affineTwoCoordinateLineY_zero (R : Type u) [CommRing R] :
    affineTwoCoordinateLineY R 0 = 1 := by simp [affineTwoCoordinateLineY]

@[simp] theorem affineTwoCoordinateLineY_one (R : Type u) [CommRing R] :
    affineTwoCoordinateLineY R 1 = affineTwoCoord0 R := by simp [affineTwoCoordinateLineY]

@[simp] theorem affineTwoCoordinateLineY_two (R : Type u) [CommRing R] :
    affineTwoCoordinateLineY R 2 = 0 := by simp [affineTwoCoordinateLineY]

/-- Coefficient pullback of a biprojective equation along `C : R → affineTwoRing R`. -/
def affineTwoPullback
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    MvPolynomial (BiprojectiveCoordinate 2 2) (affineTwoRing R) :=
  map (C : R →+* affineTwoRing R) F

/--
Total morphism `𝔸² → residualImage F` from residual-image coordinates over the
affine plane ring of the base ring `R`.

After composing with `residualImageToSpec`, this equals `SpecIso.hom`.
-/
def residualImageOfHomAffineTwo
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) (affineTwoRing R))
    (i j : Fin 3) (x y : Fin 3 → affineTwoRing R)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : eval (Sum.elim x y) F = 0)
    (hR : eval (Sum.elim x y) (residualEquation F) = 0) :
    𝔸(ULift.{u} (Fin 2); Spec (.of R)) ⟶ residualImage F :=
  (AffineSpace.SpecIso (ULift.{u} (Fin 2)) (CommRingCat.of R)).hom ≫
    residualImagePointOfNormalized F i j x y hxi hyj hF hR

/-- Structure of `residualImageOfHomAffineTwo` against residual-image structure to
`Spec (affineTwoRing R)`. -/
theorem residualImageOfHomAffineTwo_comp_residualImageToSpec
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) (affineTwoRing R))
    (i j : Fin 3) (x y : Fin 3 → affineTwoRing R)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : eval (Sum.elim x y) F = 0)
    (hR : eval (Sum.elim x y) (residualEquation F) = 0) :
    residualImageOfHomAffineTwo F i j x y hxi hyj hF hR ≫ residualImageToSpec F =
      (AffineSpace.SpecIso (ULift.{u} (Fin 2)) (CommRingCat.of R)).hom := by
  unfold residualImageOfHomAffineTwo
  rw [Category.assoc, residualImagePointOfNormalized_toSpec, Category.comp_id]

/-- Specialization to a base-ring equation pulled back to the affine plane ring. -/
def residualImageOfHomAffineTwo_of_pullback
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i j : Fin 3) (x y : Fin 3 → affineTwoRing k)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : eval (Sum.elim x y) (affineTwoPullback F) = 0)
    (hR : eval (Sum.elim x y) (residualEquation (affineTwoPullback F)) = 0) :
    𝔸(ULift.{u} (Fin 2); Spec (.of k)) ⟶ residualImage (affineTwoPullback F) :=
  residualImageOfHomAffineTwo (affineTwoPullback F) i j x y hxi hyj hF hR

theorem residualImageOfHomAffineTwo_of_pullback_comp_residualImageToSpec
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i j : Fin 3) (x y : Fin 3 → affineTwoRing k)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : eval (Sum.elim x y) (affineTwoPullback F) = 0)
    (hR : eval (Sum.elim x y) (residualEquation (affineTwoPullback F)) = 0) :
    residualImageOfHomAffineTwo_of_pullback F i j x y hxi hyj hF hR ≫
        residualImageToSpec (affineTwoPullback F) =
      (AffineSpace.SpecIso (ULift.{u} (Fin 2)) (CommRingCat.of k)).hom :=
  residualImageOfHomAffineTwo_comp_residualImageToSpec
    (affineTwoPullback F) i j x y hxi hyj hF hR

/-- `SpecIso.hom ≫ Spec.map C = 𝔸² ↘ Spec R`. -/
theorem SpecIso_hom_comp_map_C (R : CommRingCat.{u}) :
    (AffineSpace.SpecIso (ULift.{u} (Fin 2)) R).hom ≫
      Spec.map (CommRingCat.ofHom
        (C : (↑R : Type u) →+* MvPolynomial (ULift.{u} (Fin 2)) ↑R)) =
      𝔸(ULift.{u} (Fin 2); Spec R) ↘ Spec R := by
  have h := AffineSpace.SpecIso_inv_over (n := ULift.{u} (Fin 2)) R
  calc
    (AffineSpace.SpecIso (ULift.{u} (Fin 2)) R).hom ≫
        Spec.map (CommRingCat.ofHom
          (C : (↑R : Type u) →+* MvPolynomial (ULift.{u} (Fin 2)) ↑R))
        = (AffineSpace.SpecIso (ULift.{u} (Fin 2)) R).hom ≫
            ((AffineSpace.SpecIso (ULift.{u} (Fin 2)) R).inv ≫
              (𝔸(ULift.{u} (Fin 2); Spec R) ↘ Spec R)) := by
          rw [← h]
    _ = ((AffineSpace.SpecIso (ULift.{u} (Fin 2)) R).hom ≫
            (AffineSpace.SpecIso (ULift.{u} (Fin 2)) R).inv) ≫
          (𝔸(ULift.{u} (Fin 2); Spec R) ↘ Spec R) := by
          simp only [Category.assoc]
    _ = 𝟙 _ ≫ (𝔸(ULift.{u} (Fin 2); Spec R) ↘ Spec R) := by
          rw [Iso.hom_inv_id]
    _ = 𝔸(ULift.{u} (Fin 2); Spec R) ↘ Spec R := by
          simp only [Category.id_comp]

/-- Structure of residual-image ofHom of the pullback over `Spec k` (via `Spec.map C`). -/
theorem residualImageOfHomAffineTwo_of_pullback_over_spec
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i j : Fin 3) (x y : Fin 3 → affineTwoRing k)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : eval (Sum.elim x y) (affineTwoPullback F) = 0)
    (hR : eval (Sum.elim x y) (residualEquation (affineTwoPullback F)) = 0) :
    residualImageOfHomAffineTwo_of_pullback F i j x y hxi hyj hF hR ≫
        residualImageToSpec (affineTwoPullback F) ≫
          Spec.map (CommRingCat.ofHom (C : k →+* affineTwoRing k)) =
      𝔸(ULift.{u} (Fin 2); Spec (.of k)) ↘ Spec (.of k) := by
  rw [← Category.assoc, residualImageOfHomAffineTwo_of_pullback_comp_residualImageToSpec]
  exact SpecIso_hom_comp_map_C (CommRingCat.of k)

/-! ### Stereo polynomial coordinates on the vertical surface over the affine plane -/

/-- Lift a univariate polynomial in `t` to the affine plane ring via `t = affineTwoCoord0`. -/
def liftPolyT {k : Type u} [CommRing k] (p : Polynomial k) : affineTwoRing k :=
  p.eval₂ (C : k →+* affineTwoRing k) (affineTwoCoord0 k)

/-- Lift a Tsen section `v : Fin 3 → k[t]` to the affine plane ring. -/
def liftTsenSection {k : Type u} [CommRing k]
    (v : Fin 3 → Polynomial k) : Fin 3 → affineTwoRing k :=
  fun i => liftPolyT (v i)

/-- Free stereographic direction `(1, s, 0)` over the affine plane. -/
def affineTwoStereoDir {k : Type u} [CommRing k] : Fin 3 → affineTwoRing k :=
  ![1, affineTwoCoord1 k, 0]

/-- Specialized conic of the coefficient pullback along the coordinate line `Y = (1,t,0)`. -/
def specializedConicPullback {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial (Fin 3) (affineTwoRing k) :=
  specializeSecondCoordinates (m := 2) (affineTwoCoordinateLineY k) (affineTwoPullback F)

theorem eval_specializedConicPullback {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : Fin 3 → affineTwoRing k) :
    eval x (specializedConicPullback F) =
      eval (Sum.elim x (affineTwoCoordinateLineY k)) (affineTwoPullback F) :=
  eval_specializeSecondCoordinates (m := 2) x (affineTwoCoordinateLineY k)
    (affineTwoPullback F)

theorem specializedConicPullback_isHomogeneous {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    (specializedConicPullback F).IsHomogeneous 2 := by
  have hmap : IsBidegree23 (affineTwoPullback F) :=
    hF.map_coefficients (C : k →+* affineTwoRing k)
  exact hmap.specializeSecondCoordinates_isHomogeneous (affineTwoCoordinateLineY k)

/-- Ring-hom action on upper-triangular ternary quadratic coefficients. -/
theorem ternaryQuadraticCoeff_map
    {R S : Type u} [CommRing R] [CommRing S] (φ : R →+* S)
    (f : MvPolynomial (Fin 3) R) (i j : Fin 3) :
    ternaryQuadraticCoeff (map φ f) i j = φ (ternaryQuadraticCoeff f i j) := by
  simp only [ternaryQuadraticCoeff, coeff_map]
  split_ifs <;> simp

/-- Coefficient ring hom `k[t] → k[t,s]` sending `t ↦ affineTwoCoord0`. -/
def liftPolyTHom {k : Type u} [CommRing k] : Polynomial k →+* affineTwoRing k :=
  Polynomial.eval₂RingHom (C : k →+* affineTwoRing k) (affineTwoCoord0 k)

theorem liftPolyT_eq_hom {k : Type u} [CommRing k] (p : Polynomial k) :
    liftPolyT p = liftPolyTHom (k := k) p :=
  rfl

/-- The specialized conic over the affine plane is the coefficient pullback of the
polynomial specialized conic along `t ↦ affineTwoCoord0`. -/
theorem specializedConicPullback_eq_map_eval₂
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    map (liftPolyTHom (k := k)) (coordinateLineSpecializedConicPoly F) =
      specializedConicPullback F := by
  simp only [coordinateLineSpecializedConicPoly, specializedConicPullback,
    affineTwoPullback, specializeSecondCoordinates, coordinateLinePoint,
    affineTwoCoordinateLineY, liftPolyTHom]
  classical
  induction F using MvPolynomial.induction_on with
  | C a =>
      simp [map_C, Polynomial.eval₂_C]
  | add p q hp hq =>
      simp only [map_add]
      exact congrArg₂ (· + ·) hp hq
  | mul_X p z hp =>
      cases z with
      | inl i =>
          have hmul :=
            congrArg (fun g => g * (X i : MvPolynomial (Fin 3) (affineTwoRing k))) hp
          simpa [map_mul, aeval_X, map_X] using hmul
      | inr j =>
          fin_cases j
          · -- j = 0: second-block value is 1
            have hmul :=
              congrArg (fun g =>
                g * (C (1 : affineTwoRing k) : MvPolynomial (Fin 3) (affineTwoRing k))) hp
            simpa [map_mul, aeval_X, Matrix.cons_val_zero, map_C, Polynomial.eval₂_C] using hmul
          · -- j = 1: second-block value is the parameter `t`
            have hmul :=
              congrArg (fun g =>
                g * (C (affineTwoCoord0 k) : MvPolynomial (Fin 3) (affineTwoRing k))) hp
            simpa [map_mul, aeval_X, Matrix.cons_val_one, map_C, Polynomial.eval₂_X,
              affineTwoCoord0] using hmul
          · -- j = 2: second-block value is 0
            have hmul :=
              congrArg (fun g =>
                g * (C (0 : affineTwoRing k) : MvPolynomial (Fin 3) (affineTwoRing k))) hp
            convert hmul using 1 <;> simp [map_mul]

/-- Upper-triangular coeffs of the affine-plane specialized conic are lifts of the
polynomial specialized-conic coeffs. -/
theorem ternaryQuadraticCoeff_specializedConicPullback
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i j : Fin 3) :
    ternaryQuadraticCoeff (specializedConicPullback F) i j =
      liftPolyT (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j) := by
  rw [← specializedConicPullback_eq_map_eval₂, liftPolyT_eq_hom,
    ternaryQuadraticCoeff_map]

/-- Lifted Tsen section is isotropic for the specialized conic over the affine plane.

The specialized conic is homogeneous of degree 2; evaluating the coefficient form at the
lifted Tsen section recovers the lift of `TernaryQuadraticPoly.eval`, which vanishes. -/
theorem eval_liftTsenSection_specializedConicPullback
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    eval (liftTsenSection v) (specializedConicPullback F) = 0 := by
  have hf := specializedConicPullback_isHomogeneous F hF
  rw [eval_eq_ternaryQuadraticCoeff_sum hf (liftTsenSection v)]
  -- ∑∑ coeff(specialized) * lift(v) * lift(v)
  --   = ∑∑ liftHom(coeff(poly)) * liftHom(v) * liftHom(v)
  --   = liftHom(∑∑ coeff(poly) * v * v)
  --   = liftHom(0) = 0
  have hcoeff (i j : Fin 3) :
      ternaryQuadraticCoeff (specializedConicPullback F) i j =
        liftPolyTHom (k := k)
          (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j) := by
    simpa [liftPolyT_eq_hom] using ternaryQuadraticCoeff_specializedConicPullback F i j
  simp only [hcoeff, liftTsenSection, liftPolyT_eq_hom]
  calc
    (∑ i : Fin 3, ∑ j : Fin 3,
        liftPolyTHom (k := k)
            (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j) *
          liftPolyTHom (k := k) (v i) * liftPolyTHom (k := k) (v j)) =
        liftPolyTHom (k := k)
          (∑ i : Fin 3, ∑ j : Fin 3,
            ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j *
              v i * v j) := by
      simp only [map_sum, map_mul]
    _ = liftPolyTHom (k := k)
          (TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v) := by
      simp only [TernaryQuadraticPoly.eval, coordinateLineTernaryQuadraticPoly]
    _ = liftPolyTHom (k := k) 0 := by rw [hv]
    _ = 0 := map_zero _

/-- Stereographic first-block coordinates of the vertical surface over the affine plane,
from a Tsen isotropic section. -/
def stereoFirstCoords {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) : Fin 3 → affineTwoRing k :=
  stereoAlg (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir

/-- Stereo first-block coordinates lie on the specialized conic when the Tsen section is
isotropic. -/
theorem eval_stereoFirstCoords_specializedConic
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    eval (stereoFirstCoords F v) (specializedConicPullback F) = 0 :=
  stereoAlg_isotropic (specializedConicPullback F)
    (specializedConicPullback_isHomogeneous F hF) (liftTsenSection v) affineTwoStereoDir
    (eval_liftTsenSection_specializedConicPullback F hF v hv)

/-- Stereo first coords + coordinate-line Y vanish `F` after pullback. -/
theorem eval_stereoFirstCoords_F
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    eval (Sum.elim (stereoFirstCoords F v) (affineTwoCoordinateLineY k))
      (affineTwoPullback F) = 0 := by
  rw [← eval_specializedConicPullback]
  exact eval_stereoFirstCoords_specializedConic F hF v hv

/-! ### Residual y-coordinates via tangent residual of the cubic fiber -/

/-- Cubic fiber of the coefficient pullback at given first-block coordinates. -/
def cubicFiberPullback {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : Fin 3 → affineTwoRing k) :
    MvPolynomial (Fin 3) (affineTwoRing k) :=
  specializeFirstCoordinates (n := 2) x (affineTwoPullback F)

theorem eval_cubicFiberPullback {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x y : Fin 3 → affineTwoRing k) :
    eval y (cubicFiberPullback F x) =
      eval (Sum.elim x y) (affineTwoPullback F) :=
  eval_specializeFirstCoordinates (n := 2) x y (affineTwoPullback F)

/-- Cross product in three coordinates (complementary direction constructor). -/
def cross3 {R : Type u} [CommRing R] (a b : Fin 3 → R) : Fin 3 → R :=
  fun i =>
    match i with
    | ⟨0, _⟩ => a 1 * b 2 - a 2 * b 1
    | ⟨1, _⟩ => a 2 * b 0 - a 0 * b 2
    | ⟨2, _⟩ => a 0 * b 1 - a 1 * b 0

/-- Complementary tangent direction at a cubic point: `p × ∇F(p)`. -/
def complementaryTangentDir {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 3) R) (p : Fin 3 → R) : Fin 3 → R :=
  cross3 p (tangentGradient G p)

/-- Binary residual representative `[-d, c]` of a binary cubic (CommRing form). -/
def residualBinaryRep {R : Type u} [CommRing R]
    (f : MvPolynomial (Fin 2) R) : Fin 2 → R :=
  ![-coeff (binaryExponent 0 3) f, coeff (binaryExponent 1 2) f]

/-- Ambient residual representative along the line through `p` and `q`. -/
def residualAmbientRep {R : Type u} [CommRing R] {σ : Type*}
    (p q : σ → R) (f : MvPolynomial (Fin 2) R) : σ → R :=
  fun i => residualBinaryRep f 0 * p i + residualBinaryRep f 1 * q i

/-- Tangent-residual second-block coordinates of the stereo point on the vertical surface.

Classical residual map: from `(x, p)` on `S_L` with `p = (1,t,0)`, take the residual point
of the cubic fiber along the tangent line `span(p, p × ∇G(p))`. -/
def residualYCoords {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) : Fin 3 → affineTwoRing k :=
  let x := stereoFirstCoords F v
  let p := affineTwoCoordinateLineY k
  let G := cubicFiberPullback F x
  let q := complementaryTangentDir G p
  residualAmbientRep p q (binaryLineRestriction p q G)

/-- Residual-image first-block coordinates equal stereo first-block coordinates. -/
def residualImageXCoords {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) : Fin 3 → affineTwoRing k :=
  stereoFirstCoords F v

/-- The stereo point on `S_L` has cubic fiber vanishing at the coordinate-line point. -/
theorem eval_cubicFiber_coordinateLine_of_stereo
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    eval (affineTwoCoordinateLineY k)
      (cubicFiberPullback F (stereoFirstCoords F v)) = 0 := by
  rw [eval_cubicFiberPullback]
  exact eval_stereoFirstCoords_F F hF v hv

/-! ### Residual ambient representatives lie on the cubic -/

/-- Scalar triple product identity: `b · (a × b) = 0`. -/
theorem dot_cross3_right {R : Type u} [CommRing R] (a b : Fin 3 → R) :
    ∑ i : Fin 3, b i * cross3 a b i = 0 := by
  simp only [Fin.sum_univ_three, cross3]
  ring

/-- Complementary direction lies in the tangent hyperplane cone. -/
theorem complementaryTangentDir_mem_tangentHyperplaneCone
    {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 3) R) (p : Fin 3 → R) :
    complementaryTangentDir G p ∈ tangentHyperplaneCone G p := by
  simp only [complementaryTangentDir, mem_tangentHyperplaneCone,
    eval_tangentForm_eq_dotProduct, tangentGradient, dotProduct]
  -- ∑ grad_i * (p × grad)_i = 0
  exact dot_cross3_right p (fun i => eval p (pderiv i G))

/-- Residual binary representative vanishes on the residual linear form. -/
theorem eval_residualBinaryRep_residualLinearForm
    {R : Type u} [CommRing R] (f : MvPolynomial (Fin 2) R) :
    eval (residualBinaryRep f) (binaryCubicResidualLinearForm f) = 0 := by
  simp only [residualBinaryRep, binaryCubicResidualLinearForm, eval_add, eval_mul, eval_C,
    eval_X, Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-- Residual binary representative lies on a double-contact binary cubic. -/
theorem eval_residualBinaryRep_of_double_contact
    {R : Type u} [CommRing R]
    (f : MvPolynomial (Fin 2) R) (hf : f.IsHomogeneous 3)
    (hvalue : eval (binaryFirstEndpoint (R := R)) f = 0)
    (hderiv : eval (binaryFirstEndpoint (R := R)) (pderiv (1 : Fin 2) f) = 0) :
    eval (residualBinaryRep f) f = 0 := by
  have hfac := binaryCubic_eq_X_one_sq_mul_of_endpoint_vanishing f hf hvalue hderiv
  have h1 :
      eval (residualBinaryRep f) f =
        eval (residualBinaryRep f) (X 1 ^ 2 * binaryCubicResidualLinearForm f) :=
    congrArg (eval (residualBinaryRep f)) hfac
  rw [h1, map_mul, eval_residualBinaryRep_residualLinearForm, mul_zero]

/-- Evaluating the ambient cubic at the residual ambient representative equals evaluating the
binary restriction at the residual binary representative. -/
theorem eval_residualAmbientRep
    {R : Type u} [CommRing R] {σ : Type*}
    (G : MvPolynomial σ R) (p q : σ → R) (f : MvPolynomial (Fin 2) R) :
    eval (residualAmbientRep p q f) G =
      eval (residualBinaryRep f) (binaryLineRestriction p q G) := by
  rw [eval_binaryLineRestriction]
  apply congrArg (fun y : σ → R => eval y G)
  funext i
  simp only [residualAmbientRep, mul_comm]

/-- The ambient residual representative of a double-contact line restriction lies on the cubic. -/
theorem eval_residualAmbientRep_of_double_contact
    {R : Type u} [CommRing R] {σ : Type*} [Fintype σ]
    (G : MvPolynomial σ R) (hG : G.IsHomogeneous 3) (p q : σ → R)
    (hp : eval p G = 0) (hq : q ∈ tangentHyperplaneCone G p) :
    eval (residualAmbientRep p q (binaryLineRestriction p q G)) G = 0 := by
  have hcontact := binaryLineRestriction_double_contact_first G p q hp hq
  rw [eval_residualAmbientRep]
  exact eval_residualBinaryRep_of_double_contact
    (binaryLineRestriction p q G)
    (binaryLineRestriction_isHomogeneous hG p q) hcontact.1 hcontact.2

/-- Cubic fiber of a bidegree-`(2,3)` pullback is homogeneous of degree 3. -/
theorem cubicFiberPullback_isHomogeneous
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (x : Fin 3 → affineTwoRing k) :
    (cubicFiberPullback F x).IsHomogeneous 3 := by
  have hmap : IsBidegree23 (affineTwoPullback F) :=
    hF.map_coefficients (C : k →+* affineTwoRing k)
  exact hmap.specializeFirstCoordinates_isHomogeneous x

/-- Residual y-coordinates lie on the cubic fiber of the stereo first-block point. -/
theorem eval_residualYCoords_cubicFiber
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    eval (residualYCoords F v)
      (cubicFiberPullback F (residualImageXCoords F v)) = 0 := by
  let x := residualImageXCoords F v
  let p := affineTwoCoordinateLineY k
  let G := cubicFiberPullback F x
  let q := complementaryTangentDir G p
  have hp : eval p G = 0 := by
    simpa [x, G, residualImageXCoords] using
      eval_cubicFiber_coordinateLine_of_stereo F hF v hv
  have hq : q ∈ tangentHyperplaneCone G p :=
    complementaryTangentDir_mem_tangentHyperplaneCone G p
  have hG : G.IsHomogeneous 3 := cubicFiberPullback_isHomogeneous F hF x
  -- residualYCoords = residualAmbientRep p q (binaryLineRestriction p q G)
  simpa [residualYCoords, residualImageXCoords, x, p, G, q] using
    eval_residualAmbientRep_of_double_contact G hG p q hp hq

/-- Residual-image point: pullback `F` vanishes at stereo x and residual y. -/
theorem eval_residualImageCoords_F
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    eval (Sum.elim (residualImageXCoords F v) (residualYCoords F v))
      (affineTwoPullback F) = 0 := by
  rw [← eval_cubicFiberPullback]
  exact eval_residualYCoords_cubicFiber F hF v hv

/-- Residual equation of the pullback at residual-image coords equals residual linear form
of the cubic fiber at residual y. -/
theorem eval_residualImageCoords_residualEquation_eq_residualLinearForm
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) :
    eval (Sum.elim (residualImageXCoords F v) (residualYCoords F v))
        (residualEquation (affineTwoPullback F)) =
      eval (residualYCoords F v)
        (PlaneCubicResidual.residualLinearForm
          (cubicFiberPullback F (residualImageXCoords F v))) := by
  rw [eval_residualEquation_eq_residualLinear_specializeFirst,
    PlaneCubicResidual.eval_residualLinearForm]
  simp only [cubicFiberPullback, PlaneCubicResidual.coeffU3, PlaneCubicResidual.coeffU2V,
    PlaneCubicResidual.coeffUV2, PlaneCubicResidual.coeffV3,
    PlaneCubicResidual.coeffU2W, PlaneCubicResidual.coeffUVW,
    PlaneCubicResidual.coeffV2W, PlaneCubicResidual.coeffUW2,
    PlaneCubicResidual.coeffVW2, PlaneCubicResidual.coeffW3,
    PlaneCubicResidual.eU3, PlaneCubicResidual.eU2V, PlaneCubicResidual.eUV2,
    PlaneCubicResidual.eV3, PlaneCubicResidual.eU2W, PlaneCubicResidual.eUVW,
    PlaneCubicResidual.eV2W, PlaneCubicResidual.eUW2, PlaneCubicResidual.eVW2,
    PlaneCubicResidual.eW3]

open Polynomial

/-- The residual point of double contact on the coordinate line lies in the tangent hyperplane. -/
theorem residualAmbientRep_mem_tangentHyperplaneCone
    {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p q : Fin 3 → R) (hp : eval p G = 0) (hq : q ∈ tangentHyperplaneCone G p) :
    residualAmbientRep p q (binaryLineRestriction p q G) ∈
      tangentHyperplaneCone G p := by
  have hp_tan : eval p (tangentForm G p) = 0 :=
    eval_tangentForm_self_eq_zero hG hp
  simp only [mem_tangentHyperplaneCone, residualAmbientRep, eval_tangentForm]
  set α := residualBinaryRep (binaryLineRestriction p q G) 0
  set β := residualBinaryRep (binaryLineRestriction p q G) 1
  -- ∑ gradᵢ · (α pᵢ + β qᵢ) = α · (p · grad) + β · (q · grad)
  have hsum :
      (∑ i : Fin 3, eval p (pderiv i G) * (α * p i + β * q i)) =
        α * eval p (tangentForm G p) + β * eval q (tangentForm G p) := by
    simp only [eval_tangentForm, mul_add, Finset.sum_add_distrib]
    have hα : (∑ i : Fin 3, eval p (pderiv i G) * (α * p i)) =
        α * ∑ i : Fin 3, eval p (pderiv i G) * p i := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl fun i _ => by ring
    have hβ : (∑ i : Fin 3, eval p (pderiv i G) * (β * q i)) =
        β * ∑ i : Fin 3, eval p (pderiv i G) * q i := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl fun i _ => by ring
    rw [hα, hβ]
  rw [hsum, hp_tan, hq, mul_zero, mul_zero, add_zero]


/-- Residual linear form vanishes at the complementary residual ambient point of a
normalized line point `p = (1, t, 0)` on a homogeneous plane cubic.

This is the specialization of `UniversalResidual.residualLinear_complementary_eq_zero` to
`residualAmbientRep` along `p × ∇G(p)`. -/
theorem eval_residualAmbientRep_residualLinearForm
    {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0)
    (hp : eval p G = 0) :
    eval (residualAmbientRep p (complementaryTangentDir G p)
        (binaryLineRestriction p (complementaryTangentDir G p) G))
      (PlaneCubicResidual.residualLinearForm G) = 0 := by
  set t := p 1
  set a := PlaneCubicResidual.coeffU3 G
  set b := PlaneCubicResidual.coeffU2V G
  set c := PlaneCubicResidual.coeffUV2 G
  set d := PlaneCubicResidual.coeffV3 G
  set e := PlaneCubicResidual.coeffU2W G
  set f := PlaneCubicResidual.coeffUVW G
  set hh := PlaneCubicResidual.coeffV2W G
  set i := PlaneCubicResidual.coeffUW2 G
  set j := PlaneCubicResidual.coeffVW2 G
  set kk := PlaneCubicResidual.coeffW3 G
  set q := complementaryTangentDir G p
  set fbin := binaryLineRestriction p q G
  set y := residualAmbientRep p q fbin
  -- Line condition G(p) = 0 with p = (1, t, 0)
  have hline : a + b * t + c * t ^ 2 + d * t ^ 3 = 0 := by
    have hval := PlaneCubicResidual.eval_eq_planeCubicValue hG p
    simp only [hp, UniversalResidual.planeCubicValue, hp2, mul_zero, zero_mul, add_zero,
      hp0, mul_one] at hval
    -- hval : 0 = a + b*(p 1) + c*(p 1)^2 + d*(p 1)^3 after unfolding
    simpa [a, b, c, d, t, pow_two, pow_three] using hval.symm
  -- Gradient of G at p on the line
  obtain ⟨hg0, hg1, hg2⟩ := PlaneCubicResidual.eval_pderiv_on_line G hG p hp0 hp2
  -- Complementary direction q = p × ∇G(p)
  have hq0 : q 0 = t * (e + f * t + hh * t ^ 2) := by
    change q 0 = t * (e + f * t + hh * t ^ 2)
    simp only [q, complementaryTangentDir, cross3, tangentGradient]
    -- q 0 = p 1 * grad2 - p 2 * grad1 = t * hg2
    simp only [hg2, e, f, hh, t, hp2, mul_zero, sub_zero]
    ring
  have hq1 : q 1 = -(e + f * t + hh * t ^ 2) := by
    change q 1 = -(e + f * t + hh * t ^ 2)
    simp only [q, complementaryTangentDir, cross3, tangentGradient]
    simp only [hg2, e, f, hh, t, hp0, hp2, mul_zero, zero_sub, mul_one]
    ring
  have hq2 : q 2 =
      (b + 2 * c * t + 3 * d * t ^ 2) - t * (3 * a + 2 * b * t + c * t ^ 2) := by
    change q 2 = (b + 2 * c * t + 3 * d * t ^ 2) - t * (3 * a + 2 * b * t + c * t ^ 2)
    simp only [q, complementaryTangentDir, cross3, tangentGradient]
    simp only [hg0, hg1, a, b, c, d, t, hp0, mul_one]
    ring
  -- Binary residual coefficients
  have hα : residualBinaryRep fbin 0 = -eval q G := by
    unfold residualBinaryRep fbin
    simp only [Matrix.cons_val_zero]
    rw [coeff03_of_binaryLineRestriction G hG p q]
  have hβ : residualBinaryRep fbin 1 = eval p (tangentForm G q) := by
    have hrep : residualBinaryRep fbin 1 = coeff (binaryExponent 1 2) fbin := by
      simp [residualBinaryRep]
    rw [hrep, coeff12_of_binaryLineRestriction G hG p q, eval_tangentForm]
    apply Finset.sum_congr rfl
    intro idx _
    exact mul_comm (p idx) (eval q (pderiv idx G))
  -- G(q) and polar as monom expansions
  have hGq : eval q G =
      UniversalResidual.planeCubicValue a b c d e f hh i j kk (q 0) (q 1) (q 2) := by
    have h := PlaneCubicResidual.eval_eq_planeCubicValue hG q
    -- h : eval q G = planeCubicValue (coeffU3 G) ...
    convert h using 2 <;> simp only [a, b, c, d, e, f, hh, i, j, kk]
  have hpolar_pq : eval p (tangentForm G q) =
      (3 * a * q 0 ^ 2 + 2 * b * q 0 * q 1 + c * q 1 ^ 2 +
          q 2 * (2 * e * q 0 + f * q 1) + q 2 ^ 2 * i) +
        t * (b * q 0 ^ 2 + 2 * c * q 0 * q 1 + 3 * d * q 1 ^ 2 +
          q 2 * (f * q 0 + 2 * hh * q 1) + q 2 ^ 2 * j) := by
    simp only [eval_tangentForm, Fin.sum_univ_three, hp0, hp2, mul_zero, add_zero, mul_one, t]
    have h0 := PlaneCubicResidual.eval_pderiv0_planeCubic G hG q
    have h1 := PlaneCubicResidual.eval_pderiv1_planeCubic G hG q
    simp only [h0, h1, a, b, c, d, e, f, hh, i, j]
    ring
  -- Match residual ambient coords to complementary formula and apply universal identity
  rw [PlaneCubicResidual.eval_residualLinearForm]
  -- residualLinear a.. (y 0) (y 1) (y 2)
  have hy0 : y 0 =
      (-eval q G) + (eval p (tangentForm G q)) * q 0 := by
    simp only [y, residualAmbientRep, hα, hβ, hp0, mul_one]
  have hy1 : y 1 =
      (-eval q G) * t + (eval p (tangentForm G q)) * q 1 := by
    simp only [y, residualAmbientRep, hα, hβ, t]
  have hy2 : y 2 = (eval p (tangentForm G q)) * q 2 := by
    simp only [y, residualAmbientRep, hα, hβ, hp2, mul_zero, zero_add]
  -- Rewrite y coords and q coords to monom formulas, then apply complementary identity
  rw [hy0, hy1, hy2, hGq, hpolar_pq, hq0, hq1, hq2]
  -- Goal is residualLinear of the expanded complementary residual ambient
  -- which matches residualLinear_complementary_eq_zero after unfolding lets
  simpa [a, b, c, d, e, f, hh, i, j, kk, t, UniversalResidual.planeCubicValue] using
    (UniversalResidual.residualLinear_complementary_eq_zero a b c d e f hh i j kk t hline)

/-- Residual linear form of the cubic fiber vanishes at residual y-coordinates. -/
theorem eval_residualYCoords_residualLinearForm
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    eval (residualYCoords F v)
      (PlaneCubicResidual.residualLinearForm
        (cubicFiberPullback F (residualImageXCoords F v))) = 0 := by
  set x := residualImageXCoords F v
  set p := affineTwoCoordinateLineY k
  set G := cubicFiberPullback F x
  have hG : G.IsHomogeneous 3 := cubicFiberPullback_isHomogeneous F hF x
  have hp : eval p G = 0 := by
    simpa [x, G, residualImageXCoords] using
      eval_cubicFiber_coordinateLine_of_stereo F hF v hv
  have hp0 : p 0 = 1 := by simp [p, affineTwoCoordinateLineY]
  have hp2 : p 2 = 0 := by simp [p, affineTwoCoordinateLineY]
  simpa [residualYCoords, residualImageXCoords, x, p, G] using
    eval_residualAmbientRep_residualLinearForm G hG p hp0 hp2 hp

/-- Residual equation vanishes at residual-image coordinates. -/
theorem eval_residualImageCoords_residualEquation
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    eval (Sum.elim (residualImageXCoords F v) (residualYCoords F v))
      (residualEquation (affineTwoPullback F)) = 0 := by
  rw [eval_residualImageCoords_residualEquation_eq_residualLinearForm]
  exact eval_residualYCoords_residualLinearForm F hF v hv

/-! ### ofHom from residual-image coordinates into residual image of the pullback -/

/-- Total morphism `𝔸² → residualImage (affineTwoPullback F)` from residual-image coordinates
attached to a Tsen section, under chart-normalization hypotheses on those coordinates.

The structure identity
`residualImageOfHomFromCoords ≫ residualImageToSpec = SpecIso.hom`
holds by the general residual-image ofHom packaging.
-/
def residualImageOfHomFromCoords
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hxi : residualImageXCoords F v i = 1)
    (hyj : residualYCoords F v j = 1) :
    𝔸(ULift.{u} (Fin 2); Spec (.of k)) ⟶ residualImage (affineTwoPullback F) :=
  residualImageOfHomAffineTwo_of_pullback F i j
    (residualImageXCoords F v) (residualYCoords F v) hxi hyj
    (eval_residualImageCoords_F F hF v hv)
    (eval_residualImageCoords_residualEquation F hF v hv)

theorem residualImageOfHomFromCoords_comp_residualImageToSpec
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hxi : residualImageXCoords F v i = 1)
    (hyj : residualYCoords F v j = 1) :
    residualImageOfHomFromCoords F hF v hv i j hxi hyj ≫
        residualImageToSpec (affineTwoPullback F) =
      (AffineSpace.SpecIso (ULift.{u} (Fin 2)) (CommRingCat.of k)).hom :=
  residualImageOfHomAffineTwo_of_pullback_comp_residualImageToSpec F i j
    (residualImageXCoords F v) (residualYCoords F v) hxi hyj
    (eval_residualImageCoords_F F hF v hv)
    (eval_residualImageCoords_residualEquation F hF v hv)

/-- Structure of residual-image ofHom from coordinates over `Spec k` via `Spec.map C`. -/
theorem residualImageOfHomFromCoords_over_spec
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hxi : residualImageXCoords F v i = 1)
    (hyj : residualYCoords F v j = 1) :
    residualImageOfHomFromCoords F hF v hv i j hxi hyj ≫
        residualImageToSpec (affineTwoPullback F) ≫
          Spec.map (CommRingCat.ofHom (C : k →+* affineTwoRing k)) =
      𝔸(ULift.{u} (Fin 2); Spec (.of k)) ↘ Spec (.of k) :=
  residualImageOfHomAffineTwo_of_pullback_over_spec F i j
    (residualImageXCoords F v) (residualYCoords F v) hxi hyj
    (eval_residualImageCoords_F F hF v hv)
    (eval_residualImageCoords_residualEquation F hF v hv)

/-- Existence of a Tsen section yields residual-image coordinates with vanishing of `F` and the
residual equation on the pullback (input to ofHom after chart normalization). -/
theorem exists_residualImageCoords_of_tsen
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    ∃ v : Fin 3 → Polynomial k,
      v ≠ 0 ∧
        TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0 ∧
          eval (Sum.elim (residualImageXCoords F v) (residualYCoords F v))
              (affineTwoPullback F) = 0 ∧
            eval (Sum.elim (residualImageXCoords F v) (residualYCoords F v))
                (residualEquation (affineTwoPullback F)) = 0 := by
  obtain ⟨v, hv0, hv⟩ := exists_isotropic_coordinateLine_conic k F
  exact ⟨v, hv0, hv, eval_residualImageCoords_F F hF v hv,
    eval_residualImageCoords_residualEquation F hF v hv⟩

/--
Residual-image ofHom package summary: Tsen section + residual coords + chart normalization
⇒ total morphism `𝔸² → residualImage (pullback F)` over `Spec k` via `Spec.map C`.

Remaining for `HasResidualImageUnirationalParametrization2 F` (residual image over `Spec k`):
1. chart-normalization of residual coords (or rational-map packaging on a dense open);
2. base-change identification `residualImage (pullback F) → residualImage F`;
3. dominance of the resulting map.
-/
theorem residualImage_ofHom_package_summary
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    ∃ (v : Fin 3 → Polynomial k),
      v ≠ 0 ∧
        TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0 ∧
          eval (Sum.elim (residualImageXCoords F v) (residualYCoords F v))
              (affineTwoPullback F) = 0 ∧
            eval (Sum.elim (residualImageXCoords F v) (residualYCoords F v))
                (residualEquation (affineTwoPullback F)) = 0 :=
  exists_residualImageCoords_of_tsen F hF

/-! ### ofHom into residual image of `F` over `Spec k` (algebra-valued coordinates) -/

/-- Pullback vanishing of `F` is algebra evaluation of the original equation. -/
theorem aeval_residualImageCoords_F
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    aeval (Sum.elim (residualImageXCoords F v) (residualYCoords F v)) F = 0 := by
  -- `aeval f p = eval f (map C p)` for the `k`-algebra structure on `k[t,s]`
  rw [MvPolynomial.aeval_def, MvPolynomial.eval₂_eq_eval_map, MvPolynomial.algebraMap_eq]
  exact eval_residualImageCoords_F F hF v hv

/-- Pullback vanishing of the residual equation is algebra evaluation of `residualEquation F`. -/
theorem aeval_residualImageCoords_residualEquation
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    aeval (Sum.elim (residualImageXCoords F v) (residualYCoords F v))
      (residualEquation F) = 0 := by
  have hpull := eval_residualImageCoords_residualEquation F hF v hv
  have hmap := map_residualEquation (C : k →+* affineTwoRing k) F
  rw [MvPolynomial.aeval_def, MvPolynomial.eval₂_eq_eval_map, MvPolynomial.algebraMap_eq,
    ← hmap]
  exact hpull

/-- Spec-point of residual image over `k` from residual stereo coordinates over `k[t,s]`. -/
def residualImagePointOfCoords
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hxi : residualImageXCoords F v i = 1)
    (hyj : residualYCoords F v j = 1) :
    Spec (.of (affineTwoRing k)) ⟶ residualImage F :=
  residualImagePointOfNormalizedAlgebra F i j
    (residualImageXCoords F v) (residualYCoords F v) hxi hyj
    (aeval_residualImageCoords_F F hF v hv)
    (aeval_residualImageCoords_residualEquation F hF v hv)

/-- Total morphism `𝔸²_k → residualImage F` from residual stereo coordinates under chart
normalization.  This lands in the residual image over `Spec k`, not the coefficient pullback. -/
def residualImageOfHomFromCoordsToF
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hxi : residualImageXCoords F v i = 1)
    (hyj : residualYCoords F v j = 1) :
    𝔸(ULift.{u} (Fin 2); Spec (.of k)) ⟶ residualImage F :=
  (AffineSpace.SpecIso (ULift.{u} (Fin 2)) (CommRingCat.of k)).hom ≫
    residualImagePointOfCoords F hF v hv i j hxi hyj

/-- ofHom package into residual image of `F` over `Spec k` (under chart-normalization hyps).

Compared to `residualImageOfHomFromCoords`, the target is `residualImage F` rather than the
coefficient pullback.  Remaining: chart normalization and dominance.
-/
theorem residualImage_ofHom_toF_package_summary
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    ∃ (v : Fin 3 → Polynomial k),
      v ≠ 0 ∧
        TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0 ∧
          aeval (Sum.elim (residualImageXCoords F v) (residualYCoords F v)) F = 0 ∧
            aeval (Sum.elim (residualImageXCoords F v) (residualYCoords F v))
              (residualEquation F) = 0 := by
  obtain ⟨v, hv0, hv⟩ := exists_isotropic_coordinateLine_conic k F
  exact ⟨v, hv0, hv, aeval_residualImageCoords_F F hF v hv,
    aeval_residualImageCoords_residualEquation F hF v hv⟩

/-! ### Nonvanishing of residual binary / ambient / Y-coordinates -/

/-- If the residual binary representative vanishes under double contact, the binary cubic is
identically zero. -/
theorem eq_zero_of_residualBinaryRep_eq_zero_of_double_contact
    {R : Type u} [CommRing R]
    (f : MvPolynomial (Fin 2) R) (hf : f.IsHomogeneous 3)
    (hvalue : eval (binaryFirstEndpoint (R := R)) f = 0)
    (hderiv : eval (binaryFirstEndpoint (R := R)) (pderiv (1 : Fin 2) f) = 0)
    (hrep : residualBinaryRep f = 0) :
    f = 0 := by
  have hc : coeff (binaryExponent 1 2) f = 0 := by
    simpa [residualBinaryRep] using congrFun hrep (1 : Fin 2)
  have hd : coeff (binaryExponent 0 3) f = 0 := by
    have h0 := congrFun hrep (0 : Fin 2)
    simp only [residualBinaryRep, Matrix.cons_val_zero] at h0
    exact neg_eq_zero.mp h0
  have hresidual : binaryCubicResidualLinearForm f = 0 := by
    simp only [binaryCubicResidualLinearForm, hc, hd, map_zero, zero_mul, add_zero]
  rw [binaryCubic_eq_X_one_sq_mul_of_endpoint_vanishing f hf hvalue hderiv, hresidual, mul_zero]

/-- Restriction of a homogeneous cubic along a zero direction vanishes when `G(p) = 0`.
Requires an infinite coefficient ring so pointwise vanishing implies polynomial vanishing. -/
theorem binaryLineRestriction_eq_zero_of_dir_eq_zero
    {R : Type u} [CommRing R] [IsDomain R] [Infinite R] {σ : Type*}
    (G : MvPolynomial σ R) (hG : G.IsHomogeneous 3) (p : σ → R)
    (hp : eval p G = 0) :
    binaryLineRestriction p (0 : σ → R) G = 0 := by
  apply MvPolynomial.funext
  intro x
  have hx :
      eval x (binaryLineRestriction p (0 : σ → R) G) =
        eval (fun i => p i * x 0) G := by
    rw [eval_binaryLineRestriction]
    simp
  have hscale :
      eval (fun i => p i * x 0) G = (x 0) ^ 3 * eval p G := by
    simpa [Pi.smul_def, smul_eq_mul, mul_comm] using
      eval_smul_point_of_isHomogeneous hG (x 0) p
  rw [hx, hscale, hp, mul_zero, map_zero]

/-- Vanishing complementary direction and `G(p) = 0` force the line restriction to vanish. -/
theorem binaryLineRestriction_eq_zero_of_complementary_eq_zero
    {R : Type u} [CommRing R] [IsDomain R] [Infinite R]
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (p : Fin 3 → R)
    (hp : eval p G = 0) (hq : complementaryTangentDir G p = 0) :
    binaryLineRestriction p (complementaryTangentDir G p) G = 0 := by
  rw [hq]
  exact binaryLineRestriction_eq_zero_of_dir_eq_zero G hG p hp

/-- On the normalized line point `p = (1, t, 0)` with `1 + t²` a non-zero-divisor, ambient residual
vanishing forces the residual binary representative to vanish. -/
theorem residualBinaryRep_eq_zero_of_residualAmbientRep_eq_zero
    {R : Type u} [CommRing R] [IsDomain R] [Infinite R]
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0)
    (ht : 1 + p 1 ^ 2 ≠ 0)
    (hp : eval p G = 0)
    (hY : residualAmbientRep p (complementaryTangentDir G p)
        (binaryLineRestriction p (complementaryTangentDir G p) G) = 0) :
    residualBinaryRep (binaryLineRestriction p (complementaryTangentDir G p) G) = 0 := by
  set q := complementaryTangentDir G p
  set fbin := binaryLineRestriction p q G
  set α := residualBinaryRep fbin 0
  set β := residualBinaryRep fbin 1
  set g := tangentGradient G p
  have hy0 : α * p 0 + β * q 0 = 0 := by
    simpa [residualAmbientRep, α, β, fbin, q] using congrFun hY 0
  have hy1 : α * p 1 + β * q 1 = 0 := by
    simpa [residualAmbientRep, α, β, fbin, q] using congrFun hY 1
  have hy2 : α * p 2 + β * q 2 = 0 := by
    simpa [residualAmbientRep, α, β, fbin, q] using congrFun hY 2
  simp only [hp0, hp2, mul_one, mul_zero, zero_add] at hy0 hy2
  -- hy0: α + β q0 = 0; hy2: β q2 = 0
  have hq0 : q 0 = p 1 * g 2 := by
    change q 0 = p 1 * g 2
    simp only [q, complementaryTangentDir, cross3, g, tangentGradient, hp2]
    ring
  have hq1 : q 1 = -g 2 := by
    change q 1 = -g 2
    simp only [q, complementaryTangentDir, cross3, g, tangentGradient, hp0, hp2]
    ring
  have hq2 : q 2 = g 1 - p 1 * g 0 := by
    change q 2 = g 1 - p 1 * g 0
    simp only [q, complementaryTangentDir, cross3, g, tangentGradient, hp0]
    ring
  -- Eliminate α: β (q1 - p1 q0) = 0
  have hαeq : α = -β * q 0 := by linear_combination hy0
  have hβdiff : β * (q 1 - p 1 * q 0) = 0 := by
    have := hy1
    rw [hαeq] at this
    convert this using 1
    ring
  have hqdiff : q 1 - p 1 * q 0 = -g 2 * (1 + p 1 ^ 2) := by
    simp only [hq0, hq1, pow_two]
    ring
  have hβg2 : β * g 2 = 0 := by
    have h : β * (-g 2 * (1 + p 1 ^ 2)) = 0 := by
      simpa [hqdiff] using hβdiff
    have hneg : -(β * g 2 * (1 + p 1 ^ 2)) = 0 := by
      convert h using 1
      ring
    have h' : β * g 2 * (1 + p 1 ^ 2) = 0 := neg_eq_zero.mp hneg
    exact (mul_eq_zero.mp h').resolve_right ht
  -- Show q = 0 or β = 0; in either case residualBinaryRep = 0 after using f = 0 when q = 0
  by_cases hβ0 : β = 0
  · have hα0 : α = 0 := by simpa [hβ0] using hy0
    funext i
    fin_cases i
    · simpa [α, hα0]
    · simpa [β, hβ0]
  · have hg2 : g 2 = 0 := (mul_eq_zero.mp hβg2).resolve_left hβ0
    have hq2z : q 2 = 0 := (mul_eq_zero.mp hy2).resolve_left hβ0
    have hq0z : q 0 = 0 := by simp [hq0, hg2]
    have hq1z : q 1 = 0 := by simp [hq1, hg2]
    have hqz : q = 0 := by
      funext j; fin_cases j <;> simp [hq0z, hq1z, hq2z]
    have hf0 : fbin = 0 := by
      simpa [fbin, q] using
        binaryLineRestriction_eq_zero_of_complementary_eq_zero G hG p hp hqz
    have hrep0 : residualBinaryRep fbin = 0 := by
      funext i
      fin_cases i <;> simp [residualBinaryRep, hf0, MvPolynomial.coeff_zero]
    exact hrep0

/-- Ambient residual vanishing on the complementary tangent line forces the binary restriction
to vanish (normalized line point, domain, `1+t² ≠ 0`). -/
theorem binaryLineRestriction_eq_zero_of_residualAmbientRep_eq_zero
    {R : Type u} [CommRing R] [IsDomain R] [Infinite R]
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0)
    (ht : 1 + p 1 ^ 2 ≠ 0)
    (hp : eval p G = 0)
    (hY : residualAmbientRep p (complementaryTangentDir G p)
        (binaryLineRestriction p (complementaryTangentDir G p) G) = 0) :
    binaryLineRestriction p (complementaryTangentDir G p) G = 0 := by
  have hrep :=
    residualBinaryRep_eq_zero_of_residualAmbientRep_eq_zero G hG p hp0 hp2 ht hp hY
  set q := complementaryTangentDir G p
  have hcontact :=
    binaryLineRestriction_double_contact_first G p q hp
      (complementaryTangentDir_mem_tangentHyperplaneCone G p)
  exact eq_zero_of_residualBinaryRep_eq_zero_of_double_contact
    (binaryLineRestriction p q G)
    (binaryLineRestriction_isHomogeneous hG p q) hcontact.1 hcontact.2 hrep

/-- `1 + t² ≠ 0` as an element of the affine plane ring. -/
theorem one_add_affineTwoCoord0_sq_ne_zero (k : Type u) [Field k] :
    (1 + affineTwoCoord0 k ^ 2 : affineTwoRing k) ≠ 0 := by
  intro h
  set m : ULift.{u} (Fin 2) →₀ ℕ := Finsupp.single (ULift.up (0 : Fin 2)) 2
  have hne : (0 : ULift.{u} (Fin 2) →₀ ℕ) ≠ m := by
    intro heq
    have h0 : (0 : ULift.{u} (Fin 2) →₀ ℕ) (ULift.up (0 : Fin 2)) = 0 := rfl
    have hm : m (ULift.up (0 : Fin 2)) = 2 := by simp [m, Finsupp.single_apply]
    have := congrArg (fun z : ULift.{u} (Fin 2) →₀ ℕ => z (ULift.up (0 : Fin 2))) heq
    rw [h0, hm] at this
    exact (by decide : (2 : ℕ) ≠ 0) this.symm
  have hX : MvPolynomial.coeff m (affineTwoCoord0 k ^ 2) = (1 : k) := by
    simp only [affineTwoCoord0, m, MvPolynomial.coeff_X_pow, if_true]
  have h1 : MvPolynomial.coeff m (1 : affineTwoRing k) = (0 : k) := by
    rw [MvPolynomial.coeff_one, if_neg (Ne.symm hne).symm]
    -- `coeff_one`: if 0 = m then 1 else 0; need ¬ (0 = m) i.e. hne : 0 ≠ m
  have hcoeff : MvPolynomial.coeff m (1 + affineTwoCoord0 k ^ 2) = (1 : k) := by
    rw [MvPolynomial.coeff_add, h1, hX, zero_add]
  have h0 : MvPolynomial.coeff m (0 : affineTwoRing k) = (0 : k) :=
    MvPolynomial.coeff_zero _
  exact one_ne_zero (hcoeff.symm.trans (by rw [h]; exact h0))

/-- Residual Y-coordinates vanish if and only if the binary line restriction vanishes. -/
theorem residualYCoords_eq_zero_iff_binaryLineRestriction_eq_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    residualYCoords F v = 0 ↔
      let x := residualImageXCoords F v
      let p := affineTwoCoordinateLineY k
      let G := cubicFiberPullback F x
      let q := complementaryTangentDir G p
      binaryLineRestriction p q G = 0 := by
  set x := residualImageXCoords F v
  set p := affineTwoCoordinateLineY k
  set G := cubicFiberPullback F x
  set q := complementaryTangentDir G p
  set fbin := binaryLineRestriction p q G
  constructor
  · intro hY
    have hp : eval p G = 0 := by
      simpa [x, G, residualImageXCoords] using
        eval_cubicFiber_coordinateLine_of_stereo F hF v hv
    have hG : G.IsHomogeneous 3 := cubicFiberPullback_isHomogeneous F hF x
    have hp0 : p 0 = 1 := by simp [p, affineTwoCoordinateLineY]
    have hp2 : p 2 = 0 := by simp [p, affineTwoCoordinateLineY]
    have ht : (1 + p 1 ^ 2 : affineTwoRing k) ≠ 0 := by
      simpa [p, affineTwoCoordinateLineY, affineTwoCoord0] using
        one_add_affineTwoCoord0_sq_ne_zero k
    haveI : IsDomain (affineTwoRing k) := inferInstance
    have hAmb : residualAmbientRep p q fbin = 0 := by
      simpa [residualYCoords, residualImageXCoords, x, p, G, q, fbin] using hY
    exact binaryLineRestriction_eq_zero_of_residualAmbientRep_eq_zero
      G hG p hp0 hp2 ht hp (by simpa [q, fbin] using hAmb)
  · intro hf
    -- f = 0 ⇒ residualBinaryRep = 0 ⇒ residualAmbientRep = 0
    have hf' : fbin = 0 := by
      simpa [fbin, x, p, G, q] using hf
    have hrep : residualBinaryRep fbin = 0 := by
      funext i
      fin_cases i <;> simp [residualBinaryRep, hf', MvPolynomial.coeff_zero]
    have hY : residualAmbientRep p q fbin = 0 := by
      funext i
      have h0 : residualBinaryRep fbin 0 = 0 := congrFun hrep 0
      have h1 : residualBinaryRep fbin 1 = 0 := congrFun hrep 1
      change residualBinaryRep fbin 0 * p i + residualBinaryRep fbin 1 * q i = 0
      rw [h0, h1, zero_mul, zero_mul, add_zero]
    simpa [residualYCoords, residualImageXCoords, x, p, G, q, fbin] using hY

/-- Residual Y-coordinates are nonzero once the complementary binary line restriction is. -/
theorem residualYCoords_ne_zero_of_binaryLineRestriction_ne_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hrestr :
      let x := residualImageXCoords F v
      let p := affineTwoCoordinateLineY k
      let G := cubicFiberPullback F x
      let q := complementaryTangentDir G p
      binaryLineRestriction p q G ≠ 0) :
    residualYCoords F v ≠ 0 := by
  intro hY
  exact hrestr ((residualYCoords_eq_zero_iff_binaryLineRestriction_eq_zero F hF v hv).mp hY)

end

end BConicBundleMultisections
