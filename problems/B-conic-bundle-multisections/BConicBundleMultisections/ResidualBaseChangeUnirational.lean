/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.AffineSpaceProduct
public import BConicBundleMultisections.BiprojectiveNoWholeFiber
public import BConicBundleMultisections.HomogeneousQuadraticEval
public import BConicBundleMultisections.MultisectionPrinciple
public import BConicBundleMultisections.PointedConicRational
public import BConicBundleMultisections.ResidualMultisectionDominant
public import BConicBundleMultisections.TsenConic
public import BConicBundleMultisections.Unirationality
public import Mathlib.AlgebraicGeometry.AffineSpace
public import Mathlib.AlgebraicGeometry.PullbackCarrier

/-!
# Residual base-change unirationality (dimension 3)

Packages residual multisection base-change targets and Tsen input along the coordinate line
`Y₂ = 0`.  The remaining geometric steps for a dim-3 unirational parametrization of the residual
base change are:

1. Tsen section + stereographic ⇒ dominant rational map `𝔸² ⤏ S_L` (vertical surface),
2. residual map `S_L ⤏` residual image (birational),
3. pointed-conic rationality of `X_T` over residual image,
4. composition ⇒ `HasResidualBaseChangeUnirationalParametrization3`.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry Scheme MvPolynomial BiprojectiveSpace ResidualDivisor
open _root_.MvPolynomial

/-! ### Affine space unirationality -/

theorem hasUnirationalParametrization_affineSpace
    (S : Scheme.{u}) (n : ℕ) :
    HasUnirationalParametrization n (𝔸(ULift.{u} (Fin n); S) ↘ S) := by
  let f : 𝔸(ULift.{u} (Fin n); S) ⟶ 𝔸(ULift.{u} (Fin n); S) := 𝟙 _
  haveI : IsDominant f := inferInstance
  exact ⟨UnirationalParametrization.ofHom f (Category.id_comp _)⟩

theorem hasUnirationalParametrization_affineSpace_spec
    (k : Type u) [CommRing k] (n : ℕ) :
    HasUnirationalParametrization n
      (𝔸(ULift.{u} (Fin n); Spec (.of k)) ↘ Spec (.of k)) :=
  hasUnirationalParametrization_affineSpace _ n

/-! ### Coordinate-line specialized conic -/

def coordinateLinePoint (R : Type u) [CommRing R] (t : R) : Fin 3 → R :=
  ![1, t, 0]

@[simp] theorem coordinateLinePoint_zero (R : Type u) [CommRing R] (t : R) :
    coordinateLinePoint R t 0 = 1 := by simp [coordinateLinePoint]
@[simp] theorem coordinateLinePoint_one (R : Type u) [CommRing R] (t : R) :
    coordinateLinePoint R t 1 = t := by simp [coordinateLinePoint]
@[simp] theorem coordinateLinePoint_two (R : Type u) [CommRing R] (t : R) :
    coordinateLinePoint R t 2 = 0 := by simp [coordinateLinePoint]

theorem coordinateLinePoint_ne_zero
    (R : Type u) [CommRing R] [Nontrivial R] (t : R) :
    coordinateLinePoint R t ≠ 0 := by
  intro h; have := congr_fun h 0; simp [coordinateLinePoint] at this

def coordinateLineSpecializedConic
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (t : R) :
    MvPolynomial (Fin 3) R :=
  specializeSecondCoordinates (m := 2) (coordinateLinePoint R t) F

theorem coordinateLineSpecializedConic_isHomogeneous
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (t : R) :
    (coordinateLineSpecializedConic F t).IsHomogeneous 2 :=
  hF.specializeSecondCoordinates_isHomogeneous (coordinateLinePoint R t)

/-- Evaluation of the specialized conic equals its upper-triangular coefficient pairing. -/
theorem coordinateLineSpecializedConic_eval_eq
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (t : R) (x : Fin 3 → R) :
    eval x (coordinateLineSpecializedConic F t) =
      ∑ i : Fin 3, ∑ j : Fin 3,
        ternaryQuadraticCoeff (coordinateLineSpecializedConic F t) i j * x i * x j :=
  eval_eq_ternaryQuadraticCoeff_sum (coordinateLineSpecializedConic_isHomogeneous hF t) x

def coordinateLineSpecializedConicPoly
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) :
    MvPolynomial (Fin 3) (Polynomial K) :=
  specializeSecondCoordinates (m := 2)
    (coordinateLinePoint (Polynomial K) Polynomial.X)
    (map (Polynomial.C : K →+* Polynomial K) F)

theorem coordinateLineSpecializedConicPoly_isHomogeneous
    {K : Type u} [Field K]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K}
    (hF : IsBidegree23 F) :
    (coordinateLineSpecializedConicPoly F).IsHomogeneous 2 := by
  have hmap :
      IsBidegree23 (map (Polynomial.C : K →+* Polynomial K) F) :=
    hF.map_coefficients (Polynomial.C : K →+* Polynomial K)
  exact hmap.specializeSecondCoordinates_isHomogeneous
    (coordinateLinePoint (Polynomial K) Polynomial.X)

def coordinateLineTernaryQuadraticPoly
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) :
    @TernaryQuadraticPoly K _ :=
  fun i j => ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j

theorem exists_isotropic_coordinateLine_conic
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) :
    ∃ v : Fin 3 → Polynomial K, v ≠ 0 ∧
      TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0 :=
  exists_isotropic_ternary_quadratic_poly (coordinateLineTernaryQuadraticPoly F)

theorem coordinateLineSpecializedConic_ne_zero_of_smooth
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (t : K) :
    coordinateLineSpecializedConic F t ≠ 0 :=
  not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23 K F hF hF0 0
    (coordinateLinePoint K t) (by simp [coordinateLinePoint])

/-- Specializing a matrix-valued ternary quadratic at `t` recovers the numerical double sum. -/
theorem TernaryQuadraticPoly.eval_eval
    {K : Type u} [Field K] (Q : @TernaryQuadraticPoly K _)
    (v : Fin 3 → Polynomial K) (t : K) :
    Polynomial.eval t (TernaryQuadraticPoly.eval Q v) =
      ∑ i : Fin 3, ∑ j : Fin 3,
        Polynomial.eval t (Q i j) * Polynomial.eval t (v i) * Polynomial.eval t (v j) := by
  simp only [TernaryQuadraticPoly.eval, Polynomial.eval_finsetSum, Polynomial.eval_mul]

/-! ### Residual base-change targets -/

abbrev residualBaseChangeToSpec
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    (residualMultisection F).baseChange ⟶ Spec (.of k) :=
  (residualMultisection F).baseChangeFst ≫ biprojectiveZeroLocusToSpec 2 2 k F

def IsResidualPointedConicRational
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  IsPointedConicRationalOver
    (biprojectiveZeroLocusSnd 2 2 k F)
    (residualImageToBase F)
    (residualMultisection F).tautologicalPullbackSection

def HasResidualImageUnirationalParametrization2
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  HasUnirationalParametrization 2 (residualImageToSpec F)

def HasResidualBaseChangeUnirationalParametrization3
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  HasUnirationalParametrization 3 (residualBaseChangeToSpec F)

/-- Pointed-conic rationality of the residual base change supplies a dim-1 unirational
parametrization over the residual image. -/
theorem hasUnirationalParametrization_one_of_IsResidualPointedConicRational
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (h : IsResidualPointedConicRational F) :
    HasUnirationalParametrization 1 (residualMultisection F).baseChangeSnd :=
  ⟨UnirationalParametrization.ofBirationalOverAffine h⟩

/-- Residual base-change dim-3 unirationality from birationality to affine 3-space. -/
theorem hasResidualBaseChangeUnirationalParametrization3_of_birational
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (h : BirationalOver (residualBaseChangeToSpec F)
      (𝔸(ULift.{u} (Fin 3); Spec (.of k)) ↘ Spec (.of k))) :
    HasResidualBaseChangeUnirationalParametrization3 F :=
  ⟨UnirationalParametrization.ofBirationalOverAffine h⟩

/-- Structure maps of residual base change and residual image to `Spec k` agree after composing
with the residual multisection projections. -/
theorem residualMultisection_baseChangeSnd_comp_residualImageToSpec
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    (residualMultisection F).baseChangeSnd ≫ residualImageToSpec F =
      residualBaseChangeToSpec F := by
  have hw := (residualMultisection F).baseChange_isPullback.w
  have hπ := biprojectiveZeroLocusSnd_toSpec 2 2 k F
  have hT : (residualMultisection F).toBase ≫ ProjectiveSpace.toSpec 2 k =
      residualImageToSpec F := by
    rw [residualMultisection_toBase]
    dsimp [residualImageToBase, residualImageToSpec]
    rw [Category.assoc, BiprojectiveSpace.snd_toSpec]
  dsimp [residualBaseChangeToSpec]
  calc
    (residualMultisection F).baseChangeSnd ≫ residualImageToSpec F
        = (residualMultisection F).baseChangeSnd ≫
            ((residualMultisection F).toBase ≫ ProjectiveSpace.toSpec 2 k) := by
          rw [← hT]
    _ = ((residualMultisection F).baseChangeSnd ≫ (residualMultisection F).toBase) ≫
          ProjectiveSpace.toSpec 2 k := by
          simp only [Category.assoc]
    _ = ((residualMultisection F).baseChangeFst ≫ biprojectiveZeroLocusSnd 2 2 k F) ≫
          ProjectiveSpace.toSpec 2 k := by
          rw [← hw]
    _ = (residualMultisection F).baseChangeFst ≫
          (biprojectiveZeroLocusSnd 2 2 k F ≫ ProjectiveSpace.toSpec 2 k) := by
          simp only [Category.assoc]
    _ = (residualMultisection F).baseChangeFst ≫ biprojectiveZeroLocusToSpec 2 2 k F := by
          rw [hπ]

/-- Affine-space base change preserves dominance: if `f` is dominant then so is
`AffineSpace.map n f`. -/
theorem isDominant_affineSpace_map {S T : Scheme.{u}} (n : Type u) (f : S ⟶ T)
    [IsDominant f] : IsDominant (AffineSpace.map n f) := by
  have hpb := AffineSpace.isPullback_map (n := n) f
  have hfst := hpb.isoPullback_hom_fst
  have hrange :
      Set.range (⇑(AffineSpace.map n f)) =
        ⇑(𝔸(n; T) ↘ T) ⁻¹' Set.range (⇑f) := by
    have hr := Scheme.Pullback.range_fst (𝔸(n; T) ↘ T) f
    have hfun :
        (⇑(AffineSpace.map n f) : _) =
          (⇑(Limits.pullback.fst (𝔸(n; T) ↘ T) f) : _) ∘
            (⇑hpb.isoPullback.hom : _) := by
      funext y
      have h :=
        congr_arg (fun (φ : 𝔸(n; S) ⟶ 𝔸(n; T)) => (φ : _) y) hfst.symm
      simpa only [Scheme.Hom.comp_apply, Function.comp_apply] using h
    have hsurj : Function.Surjective (⇑hpb.isoPullback.hom) :=
      (inferInstance : Surjective hpb.isoPullback.hom).1
    rw [hfun, Set.range_comp, Set.range_eq_univ.mpr hsurj, Set.image_univ, hr]
  refine ⟨?_⟩
  rw [denseRange_iff_closure_range, hrange]
  have hopen : IsOpenMap (⇑(𝔸(n; T) ↘ T)) := AffineSpace.isOpenMap_over (n := n) (S := T)
  have hdf : Dense (Set.range (⇑f)) := (Scheme.Hom.denseRange f :)
  exact dense_iff_closure_eq.mp (hdf.preimage hopen)

/--
Compose total dominant morphisms
`𝔸² → residual image` and `𝔸¹_{residual image} → residual base change`
into a dim-3 unirational parametrization of residual base change over `Spec k`.

Uses `AffineSpaceProduct.affineOneOverAffineTwoIso` (`𝔸¹_{𝔸²} ≃ 𝔸³`).
-/
theorem hasResidualBaseChangeUnirationalParametrization3_ofHom
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (f : 𝔸(ULift.{u} (Fin 2); Spec (.of k)) ⟶ residualImage F)
    [IsDominant f]
    (hf : f ≫ residualImageToSpec F =
      𝔸(ULift.{u} (Fin 2); Spec (.of k)) ↘ Spec (.of k))
    (g : 𝔸(ULift.{u} (Fin 1); residualImage F) ⟶ (residualMultisection F).baseChange)
    [IsDominant g]
    (hg : g ≫ (residualMultisection F).baseChangeSnd =
      𝔸(ULift.{u} (Fin 1); residualImage F) ↘ residualImage F) :
    HasResidualBaseChangeUnirationalParametrization3 F := by
  let mapf := AffineSpace.map (ULift.{u} (Fin 1)) f
  let g' := mapf ≫ g
  let e := AffineSpaceProduct.affineOneOverAffineTwoIso (CommRingCat.of k)
  let φ := e.inv ≫ g'
  haveI : IsDominant mapf := isDominant_affineSpace_map (ULift.{u} (Fin 1)) f
  haveI : IsDominant g' := inferInstance
  haveI : IsDominant φ := inferInstance
  refine ⟨UnirationalParametrization.ofHom φ ?_⟩
  -- φ ≫ residualBaseChangeToSpec = e.inv ≫ (A1_A2 ↘ Spec) = A3 ↘ Spec
  have hg_spec :
      g ≫ residualBaseChangeToSpec F =
        (𝔸(ULift.{u} (Fin 1); residualImage F) ↘ residualImage F) ≫
          residualImageToSpec F := by
    have h := congrArg (fun φ => φ ≫ residualImageToSpec F) hg
    refine Eq.trans ?step h
    case step =>
      have hb := residualMultisection_baseChangeSnd_comp_residualImageToSpec F
      have h1 : g ≫ residualBaseChangeToSpec F =
          g ≫ ((residualMultisection F).baseChangeSnd ≫ residualImageToSpec F) := by
        rw [hb]
      exact h1.trans (Category.assoc g _ _).symm
  have hcomp :
      g' ≫ residualBaseChangeToSpec F =
        𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin 2); Spec (.of k))) ↘ Spec (.of k) := by
    dsimp only [g']
    have hmap := AffineSpace.map_over (n := ULift.{u} (Fin 1)) f
    calc
      (mapf ≫ g) ≫ residualBaseChangeToSpec F
          = mapf ≫ g ≫ residualBaseChangeToSpec F := by
            simp only [Category.assoc]
      _ = mapf ≫ (𝔸(ULift.{u} (Fin 1); residualImage F) ↘ residualImage F) ≫
            residualImageToSpec F := by
            rw [hg_spec]
      _ = (mapf ≫ (𝔸(ULift.{u} (Fin 1); residualImage F) ↘ residualImage F)) ≫
            residualImageToSpec F := by
            simp only [Category.assoc]
      _ = ((𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin 2); Spec (.of k))) ↘
              𝔸(ULift.{u} (Fin 2); Spec (.of k))) ≫ f) ≫ residualImageToSpec F := by
            rw [hmap]
      _ = (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin 2); Spec (.of k))) ↘
              𝔸(ULift.{u} (Fin 2); Spec (.of k))) ≫ (f ≫ residualImageToSpec F) := by
            simp only [Category.assoc]
      _ = (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin 2); Spec (.of k))) ↘
              𝔸(ULift.{u} (Fin 2); Spec (.of k))) ≫
            (𝔸(ULift.{u} (Fin 2); Spec (.of k)) ↘ Spec (.of k)) := by
            rw [hf]
      _ = 𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin 2); Spec (.of k))) ↘ Spec (.of k) := rfl
  change e.inv ≫ g' ≫ residualBaseChangeToSpec F =
    𝔸(ULift.{u} (Fin 3); Spec (.of k)) ↘ Spec (.of k)
  rw [hcomp]
  exact AffineSpaceProduct.affineOneOverAffineTwoIso_inv_over (CommRingCat.of k)

theorem residual_baseChange_package_summary
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    IsDominant (residualMultisection F).baseChangeFst ∧
      (∃ v : Fin 3 → Polynomial K, v ≠ 0 ∧
        TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) ∧
      (∀ t : K, coordinateLineSpecializedConic F t ≠ 0) := by
  refine ⟨?_, ?_, ?_⟩
  · exact isDominant_residualMultisection_baseChangeFst_of_smooth_bidegree23 K F hF hF0
  · exact exists_isotropic_coordinateLine_conic K F
  · intro t
    exact coordinateLineSpecializedConic_ne_zero_of_smooth K F hF hF0 t

/-- Free stereographic direction (parameter `s`). -/
def stereographicDirection {R : Type u} [CommRing R] (s : R) : Fin 3 → R :=
  ![1, s, 0]

/-- Evaluate a polynomial section at a field element. -/
def evalPolySection
    {K : Type u} [Field K] (v : Fin 3 → Polynomial K) (t : K) : Fin 3 → K :=
  fun i => Polynomial.eval t (v i)

/-- The Tsen isotropic section specializes to an isotropic point of a homogeneous ternary quadratic
whose upper-triangular coefficients match the specialized matrix of `Q`. -/
theorem evalPolySection_isotropic_of_TernaryQuadraticPoly
    {K : Type u} [Field K]
    (Q : @TernaryQuadraticPoly K _) (v : Fin 3 → Polynomial K)
    (hv : TernaryQuadraticPoly.eval Q v = 0) (t : K)
    (f : MvPolynomial (Fin 3) K)
    (hf : f.IsHomogeneous 2)
    (hQ : ∀ i j, Polynomial.eval t (Q i j) = ternaryQuadraticCoeff f i j) :
    eval (evalPolySection v t) f = 0 := by
  have hsum := eval_eq_ternaryQuadraticCoeff_sum hf (evalPolySection v t)
  rw [hsum]
  have hQeval := TernaryQuadraticPoly.eval_eval Q v t
  simp only [hv, Polynomial.eval_zero] at hQeval
  -- hQeval : 0 = ∑ ∑ eval(Q) * eval(v) * eval(v)
  simp only [evalPolySection]
  have hcoeff :
      (∑ i : Fin 3, ∑ j : Fin 3,
          ternaryQuadraticCoeff f i j * Polynomial.eval t (v i) * Polynomial.eval t (v j)) =
        ∑ i : Fin 3, ∑ j : Fin 3,
          Polynomial.eval t (Q i j) * Polynomial.eval t (v i) * Polynomial.eval t (v j) := by
    refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
    rw [hQ]
  exact hcoeff.trans hQeval.symm

/-- Coefficient specialization of the polynomial specialized conic. -/
theorem ternaryQuadraticCoeff_map_eval
    {K : Type u} [Field K]
    (f : MvPolynomial (Fin 3) (Polynomial K)) (t : K) (i j : Fin 3) :
    Polynomial.eval t (ternaryQuadraticCoeff f i j) =
      ternaryQuadraticCoeff (map (Polynomial.evalRingHom t) f) i j := by
  simp only [ternaryQuadraticCoeff, coeff_map]
  split_ifs <;> simp

/-- Evaluating the polynomial specialized conic at `t` recovers the numerical specialized conic. -/
theorem map_eval_coordinateLineSpecializedConicPoly
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (t : K) :
    map (Polynomial.evalRingHom t) (coordinateLineSpecializedConicPoly F) =
      coordinateLineSpecializedConic F t := by
  simp only [coordinateLineSpecializedConicPoly, coordinateLineSpecializedConic,
    specializeSecondCoordinates, coordinateLinePoint]
  classical
  induction F using MvPolynomial.induction_on with
  | C a =>
      simp [map_C, Polynomial.eval_C]
  | add p q hp hq =>
      simp only [map_add]
      exact congrArg₂ (· + ·) hp hq
  | mul_X p z hp =>
      cases z with
      | inl i =>
          -- map(aeval(p * X i)) = map(aeval p) * X i = aeval p * X i = aeval(p * X i)
          have hmul :=
            congrArg (fun g => g * (X i : MvPolynomial (Fin 3) K)) hp
          simpa [map_mul, aeval_X, map_X] using hmul
      | inr j =>
          fin_cases j
          · -- j = 0: second-block value is 1
            have hmul :=
              congrArg (fun g => g * (C (1 : K) : MvPolynomial (Fin 3) K)) hp
            simpa [map_mul, aeval_X, Matrix.cons_val_zero, map_C, Polynomial.eval_C] using hmul
          · -- j = 1: second-block value is the parameter
            have hmul :=
              congrArg (fun g => g * (C t : MvPolynomial (Fin 3) K)) hp
            simpa [map_mul, aeval_X, Matrix.cons_val_one, map_C, Polynomial.eval_X] using hmul
          · -- j = 2: second-block value is 0
            have hmul :=
              congrArg (fun g => g * (C (0 : K) : MvPolynomial (Fin 3) K)) hp
            convert hmul using 1 <;> simp [map_mul]

/-- Tsen section specialization is isotropic for the numerical specialized conic. -/
theorem evalPolySection_isotropic_coordinateLineSpecializedConic
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (t : K) :
    eval (evalPolySection v t) (coordinateLineSpecializedConic F t) = 0 := by
  refine evalPolySection_isotropic_of_TernaryQuadraticPoly
    (coordinateLineTernaryQuadraticPoly F) v hv t
    (coordinateLineSpecializedConic F t)
    (coordinateLineSpecializedConic_isHomogeneous hF t) ?_
  intro i j
  -- eval t of poly-coeff = coeff of map-eval poly = coeff of specialized conic
  calc
    Polynomial.eval t (coordinateLineTernaryQuadraticPoly F i j)
        = ternaryQuadraticCoeff
            (map (Polynomial.evalRingHom t) (coordinateLineSpecializedConicPoly F)) i j := by
          simpa [coordinateLineTernaryQuadraticPoly] using
            ternaryQuadraticCoeff_map_eval (coordinateLineSpecializedConicPoly F) t i j
    _ = ternaryQuadraticCoeff (coordinateLineSpecializedConic F t) i j := by
          rw [map_eval_coordinateLineSpecializedConicPoly]

end

end BConicBundleMultisections
