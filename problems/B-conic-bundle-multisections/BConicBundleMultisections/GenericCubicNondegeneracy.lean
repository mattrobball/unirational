/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineChartJacobian
public import BConicBundleMultisections.CubicFiberSingularLocus
public import BConicBundleMultisections.HomogeneousJacobianChart
public import BConicBundleMultisections.SmoothExtensionJacobian
public import Mathlib.FieldTheory.Differential.Basic
public import Mathlib.RingTheory.Etale.Kaehler
public import Mathlib.RingTheory.Kaehler.Polynomial

/-!
# Coordinate derivations on a rational function field

This file supplies the derivation-localization brick needed for the explicit first-projection
Jacobian argument.  It does **not** yet assert generic nondegeneracy of the cubic fibre.

For `A = k[X_i]` and `K = Frac(A)`, `coordinateDerivation i` is the unique extension of
`MvPolynomial.pderiv i` to `K`.  The construction uses the localization formula for Kahler
differentials rather than a quotient-rule calculation.  We also package the derivation as a
`Differential` and verify that Mathlib's finite-extension differential still has the expected
value on polynomials from `A`.
-/

@[expose] public section

open scoped BigOperators Differential TensorProduct

namespace BConicBundleMultisections

noncomputable section

namespace MvPolynomialFractionRing

universe u v w

variable {k : Type u} {sigma : Type v} [Field k]

/-! ## A constant-coefficient multivariate chain rule -/

/-- Chain rule for a multivariate polynomial whose scalar coefficients are constants for the
chosen differential on the target field. -/
theorem deriv_eval₂_of_constants
    {tau : Type*} [Fintype tau]
    {F : Type u} {E : Type v} [Field F] [Field E] [Algebra F E]
    [Differential E]
    (hconst : ∀ a : F, (algebraMap F E a)′ = 0)
    (G : MvPolynomial tau F) (p : tau → E) :
    (MvPolynomial.eval₂ (algebraMap F E) p G)′ =
      ∑ i : tau, (p i)′ *
        MvPolynomial.eval₂ (algebraMap F E) p (MvPolynomial.pderiv i G) := by
  classical
  induction G using MvPolynomial.induction_on with
  | C a =>
      simp only [MvPolynomial.eval₂_C, hconst, MvPolynomial.pderiv_C,
        MvPolynomial.eval₂_zero, mul_zero, Finset.sum_const_zero]
  | add f g hf hg =>
      rw [MvPolynomial.eval₂_add, Differential.deriv.map_add, hf, hg]
      simp only [map_add, MvPolynomial.eval₂_add, mul_add, Finset.sum_add_distrib]
  | mul_X f j hf =>
      set ef : E := MvPolynomial.eval₂ (algebraMap F E) p f
      have hevalX :
          MvPolynomial.eval₂ (algebraMap F E) p (f * MvPolynomial.X j) =
            ef * p j := by
        simp only [ef, MvPolynomial.eval₂_mul, MvPolynomial.eval₂_X]
      have hpd (i : tau) :
          MvPolynomial.pderiv i (f * MvPolynomial.X j) =
            MvPolynomial.pderiv i f * MvPolynomial.X j + (if i = j then f else 0) := by
        rw [Derivation.leibniz (MvPolynomial.pderiv i) f (MvPolynomial.X j),
          MvPolynomial.pderiv_X]
        by_cases hij : i = j
        · subst hij
          simp only [Pi.single_eq_same, smul_eq_mul, mul_one, mul_comm, add_comm, ↓reduceIte]
        · simp only [Pi.single_eq_of_ne (Ne.symm hij), smul_eq_mul, mul_zero,
            zero_add, add_zero, if_neg hij, mul_comm]
      have hterm (i : tau) :
          MvPolynomial.eval₂ (algebraMap F E) p
                (MvPolynomial.pderiv i (f * MvPolynomial.X j)) =
            MvPolynomial.eval₂ (algebraMap F E) p (MvPolynomial.pderiv i f) * p j +
              (if i = j then ef else 0) := by
        rw [hpd, MvPolynomial.eval₂_add, MvPolynomial.eval₂_mul, MvPolynomial.eval₂_X]
        split_ifs with hij
        · subst hij; rfl
        · simp only [MvPolynomial.eval₂_zero, add_zero]
      have hsum :
          (∑ i : tau, (p i)′ *
              MvPolynomial.eval₂ (algebraMap F E) p
                (MvPolynomial.pderiv i (f * MvPolynomial.X j))) =
            (∑ i : tau, (p i)′ *
                MvPolynomial.eval₂ (algebraMap F E) p (MvPolynomial.pderiv i f)) * p j +
              (p j)′ * ef := by
        simp only [hterm, mul_add, Finset.sum_add_distrib]
        have h₁ :
            (∑ i : tau, (p i)′ *
                (MvPolynomial.eval₂ (algebraMap F E) p (MvPolynomial.pderiv i f) * p j)) =
              (∑ i : tau, (p i)′ *
                  MvPolynomial.eval₂ (algebraMap F E) p (MvPolynomial.pderiv i f)) * p j := by
          simp_rw [← mul_assoc]
          exact (Finset.sum_mul _ _ _).symm
        have h₂ :
            (∑ i : tau, (p i)′ * (if i = j then ef else 0)) = (p j)′ * ef := by
          rw [Finset.sum_eq_single j]
          · simp only [↓reduceIte]
          · intro i _ hij; simp only [hij, ↓reduceIte, mul_zero]
          · intro hj; exact (hj (Finset.mem_univ j)).elim
        rw [h₁, h₂]
      rw [hevalX, Differential.deriv.leibniz, hf, hsum]
      ring

/-- The polynomial ring whose fraction field carries the coordinate derivations below. -/
abbrev PolynomialRing := MvPolynomial sigma k

/-- The rational function field in the variables indexed by `sigma`. -/
abbrev FunctionField := FractionRing (PolynomialRing (k := k) (sigma := sigma))

/-! ## The generic first-projection cubic on a standard base chart -/

/-- The affine coordinate ring of a standard chart in the first projective plane. -/
abbrev FstChartRing := PolynomialRing (k := k) (sigma := Fin 2)

/-- Its rational function field. -/
abbrev FstFunctionField := FunctionField (k := k) (sigma := Fin 2)

/-- The first-projection cubic over the affine coordinate ring of the `i`-th standard chart. -/
def genericFstCubicChart
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3) :
    MvPolynomial (Fin 3) (FstChartRing (k := k)) :=
  specializeFirstCoordinates (n := 2) (chartSubst (K := k) i)
    (MvPolynomial.map (MvPolynomial.C : k →+* FstChartRing (k := k)) F)

/-- The first-projection cubic over the rational function field of the `i`-th base chart. -/
def genericFstCubic
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3) :
    MvPolynomial (Fin 3) (FstFunctionField (k := k)) :=
  MvPolynomial.map
    (algebraMap (FstChartRing (k := k)) (FstFunctionField (k := k)))
    (genericFstCubicChart F i)

/-- Bidegree `(2,3)` makes the generic first-projection fibre a ternary cubic. -/
theorem genericFstCubic_isHomogeneous
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    (hF : IsBidegree23 F) (i : Fin 3) :
    (genericFstCubic F i).IsHomogeneous 3 := by
  have h := hF.map_coefficients
    (MvPolynomial.C : k →+* FstChartRing (k := k))
  exact (h.specializeFirstCoordinates_isHomogeneous _).map _

/-- Base change of the generic chart cubic is specialization at the transported generic point. -/
theorem map_genericFstCubicChart
    {S : Type w} [CommRing S]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3)
    (φ : FstChartRing (k := k) →+* S) :
    MvPolynomial.map φ (genericFstCubicChart F i) =
      specializeFirstCoordinates (n := 2)
        (fun l ↦ φ (chartSubst (K := k) i l))
        (MvPolynomial.map
          (φ.comp (MvPolynomial.C : k →+* FstChartRing (k := k))) F) := by
  rw [genericFstCubicChart, map_specializeFirstCoordinates_general, MvPolynomial.map_map]

/-- After extending the rational function field, the generic first-projection cubic is the
original Cox polynomial evaluated at the transported generic point of the chosen base chart. -/
theorem map_genericFstCubic
    {L : Type w} [Field L]
    [Algebra k L]
    [Algebra (FstFunctionField (k := k)) L]
    [IsScalarTower k (FstFunctionField (k := k)) L]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3) :
    MvPolynomial.map
        (algebraMap (FstFunctionField (k := k)) L)
        (genericFstCubic F i) =
      specializeFirstCoordinates (n := 2)
        (fun l ↦ algebraMap (FstFunctionField (k := k)) L
          (algebraMap (FstChartRing (k := k)) (FstFunctionField (k := k))
            (chartSubst (K := k) i l)))
        (MvPolynomial.map (algebraMap k L) F) := by
  rw [genericFstCubic, MvPolynomial.map_map, map_genericFstCubicChart]
  have hcoeff :
      ((algebraMap (FstFunctionField (k := k)) L).comp
          (algebraMap (FstChartRing (k := k)) (FstFunctionField (k := k)))).comp
          (MvPolynomial.C : k →+* FstChartRing (k := k)) =
        algebraMap k L := by
    ext c
    change algebraMap (FstFunctionField (k := k)) L
        (algebraMap (FstChartRing (k := k)) (FstFunctionField (k := k))
          (MvPolynomial.C c)) = algebraMap k L c
    rw [show MvPolynomial.C c =
        algebraMap k (FstChartRing (k := k)) c from rfl,
      ← IsScalarTower.algebraMap_apply k (FstChartRing (k := k))
        (FstFunctionField (k := k)),
      ← IsScalarTower.algebraMap_apply k (FstFunctionField (k := k)) L]
  rw [hcoeff]
  rfl

/-- Formation of an explicit affine biprojective chart equation commutes with changing the
coefficient ring. -/
theorem map_affineChartEquation
    {m n : ℕ} {R : Type u} {S : Type w} [CommRing R] [CommRing S]
    (φ : R →+* S) (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    MvPolynomial.map φ (BiprojectiveSpace.affineChartEquation m n R i j F) =
      BiprojectiveSpace.affineChartEquation m n S i j (MvPolynomial.map φ F) := by
  unfold BiprojectiveSpace.affineChartEquation BiprojectiveSpace.affineChartEvaluation
  induction F using MvPolynomial.induction_on with
  | C a => simp
  | add f g hf hg => simp_all
  | mul_X f z hf =>
      cases z with
      | inl l =>
          simp only [map_mul, MvPolynomial.map_X, MvPolynomial.aeval_X, hf]
          rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩ <;>
            simp [BiprojectiveSpace.affineChartVariable]
      | inr l =>
          simp only [map_mul, MvPolynomial.map_X, MvPolynomial.aeval_X, hf]
          rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨r, rfl⟩ <;>
            simp [BiprojectiveSpace.affineChartVariable]

/-- Evaluation of a chart equation at an extension-field chart point equals homogeneous
evaluation of the base-changed Cox polynomial. -/
theorem aeval_affineChartEquation_affineChartPoint_extension
    {m n : ℕ} {R : Type u} {S : Type w} [CommRing R] [CommRing S] [Algebra R S]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    MvPolynomial.aeval (BiprojectiveSpace.affineChartPoint i j x y)
        (BiprojectiveSpace.affineChartEquation m n R i j F) =
      MvPolynomial.eval (Sum.elim x y) (MvPolynomial.map (algebraMap R S) F) := by
  rw [MvPolynomial.aeval_def, ← MvPolynomial.eval_map,
    map_affineChartEquation]
  exact BiprojectiveSpace.eval_affineChartEquation_affineChartPoint
    m n S i j x y hxi hyj _

/-- The coordinate functional on the Kahler differentials of a polynomial ring, with values
embedded in its fraction field. -/
noncomputable def coordinateFunctional (i : sigma) :
    Ω[PolynomialRing (k := k) (sigma := sigma)⁄k] →ₗ[PolynomialRing (k := k) (sigma := sigma)]
      FunctionField (k := k) (sigma := sigma) :=
  (Algebra.linearMap
      (PolynomialRing (k := k) (sigma := sigma))
      (FunctionField (k := k) (sigma := sigma))).comp
    ((Finsupp.lapply i).comp
      (KaehlerDifferential.mvPolynomialBasis k sigma).repr.toLinearMap)

/-- The `i`-th coordinate derivation on the rational function field `k(X_sigma)`.

The formally-etale localization equivalence identifies the differentials of the fraction field
with the base change of the differentials of the polynomial ring. -/
noncomputable def coordinateDerivation (i : sigma) :
    Derivation k
      (FunctionField (k := k) (sigma := sigma))
      (FunctionField (k := k) (sigma := sigma)) := by
  letI : Algebra.FormallyEtale
      (PolynomialRing (k := k) (sigma := sigma))
      (FunctionField (k := k) (sigma := sigma)) :=
    Algebra.FormallyEtale.of_isLocalization
      (nonZeroDivisors (PolynomialRing (k := k) (sigma := sigma)))
  exact
    (((coordinateFunctional (k := k) i).liftBaseChange
          (FunctionField (k := k) (sigma := sigma))).comp
      (KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale
        k
        (PolynomialRing (k := k) (sigma := sigma))
        (FunctionField (k := k) (sigma := sigma))).symm.toLinearMap).compDer
      (KaehlerDifferential.D k (FunctionField (k := k) (sigma := sigma)))

/-- On the polynomial subring, the rational-function-field coordinate derivation is exactly
`MvPolynomial.pderiv`. -/
theorem coordinateDerivation_algebraMap (i : sigma)
    (p : PolynomialRing (k := k) (sigma := sigma)) :
    coordinateDerivation (k := k) i
        (algebraMap
          (PolynomialRing (k := k) (sigma := sigma))
          (FunctionField (k := k) (sigma := sigma)) p) =
      algebraMap
        (PolynomialRing (k := k) (sigma := sigma))
        (FunctionField (k := k) (sigma := sigma))
        (MvPolynomial.pderiv i p) := by
  unfold coordinateDerivation coordinateFunctional
  simp [KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale_symm_D_algebraMap,
    KaehlerDifferential.mvPolynomialBasis_repr_apply]

/-- Package a derivation of a field over a subfield as a `Differential` on the larger field.

Writing this constructor directly avoids competing `Algebra Int E` instances for concrete
localization types. -/
@[reducible]
def differentialOfDerivation {F : Type u} {E : Type v}
    [Field F] [Field E] [Algebra F E] (d : Derivation F E E) : Differential E where
  deriv :=
    { toFun := d
      map_add' := fun x y => d.map_add x y
      map_smul' := fun n x => map_zsmul d n x
      map_one_eq_zero' := d.map_one_eq_zero
      leibniz' := fun x y => d.leibniz x y }

/-- The differential on `k(X_sigma)` induced by the `i`-th coordinate derivation. -/
@[reducible]
noncomputable def coordinateDifferential (i : sigma) :
    Differential (FunctionField (k := k) (sigma := sigma)) :=
  differentialOfDerivation (coordinateDerivation (k := k) i)

/-- Mathlib's canonical extension of the coordinate differential to a finite field extension has
the expected base differential. -/
@[reducible]
noncomputable def finiteExtensionCoordinateDifferential
    [NeZero (2 : k)] [NeZero (3 : k)]
    (i : sigma)
    (L : Type w) [Field L]
    [Algebra (FunctionField (k := k) (sigma := sigma)) L]
    [FiniteDimensional (FunctionField (k := k) (sigma := sigma)) L] :
    Differential L := by
  letI : Differential (FunctionField (k := k) (sigma := sigma)) :=
    coordinateDifferential (k := k) i
  exact Differential.differentialFiniteDimensional
    (FunctionField (k := k) (sigma := sigma)) L

/-- The finite-extension differential is a differential algebra over the coordinate differential
on the rational function field. -/
theorem finiteExtensionCoordinateDifferentialAlgebra
    [NeZero (2 : k)] [NeZero (3 : k)]
    (i : sigma)
    (L : Type w) [Field L]
    [Algebra (FunctionField (k := k) (sigma := sigma)) L]
    [FiniteDimensional (FunctionField (k := k) (sigma := sigma)) L] :
    @DifferentialAlgebra
      (FunctionField (k := k) (sigma := sigma)) L _ _ _
      (coordinateDifferential (k := k) i)
      (finiteExtensionCoordinateDifferential (k := k) i L) := by
  letI : Differential (FunctionField (k := k) (sigma := sigma)) :=
    coordinateDifferential (k := k) i
  letI : Differential L := finiteExtensionCoordinateDifferential (k := k) i L
  exact Differential.differentialAlgebraFiniteDimensional

/-- Mathlib's canonical extension of the coordinate differential to a finite field extension has
the expected value on every polynomial from `k[X_sigma]`. -/
theorem finiteExtension_deriv_algebraMap
    [NeZero (2 : k)] [NeZero (3 : k)]
    (i : sigma)
    {L : Type w} [Field L]
    [Algebra (FunctionField (k := k) (sigma := sigma)) L]
    [FiniteDimensional (FunctionField (k := k) (sigma := sigma)) L]
    (p : PolynomialRing (k := k) (sigma := sigma)) :
    @Differential.deriv L _
      (finiteExtensionCoordinateDifferential (k := k) i L)
      (algebraMap (FunctionField (k := k) (sigma := sigma)) L
      (algebraMap
        (PolynomialRing (k := k) (sigma := sigma))
        (FunctionField (k := k) (sigma := sigma)) p)) =
      algebraMap (FunctionField (k := k) (sigma := sigma)) L
        (algebraMap
          (PolynomialRing (k := k) (sigma := sigma))
          (FunctionField (k := k) (sigma := sigma))
          (MvPolynomial.pderiv i p)) := by
  letI : Differential (FunctionField (k := k) (sigma := sigma)) :=
    coordinateDifferential (k := k) i
  letI : Differential L := finiteExtensionCoordinateDifferential (k := k) i L
  letI : DifferentialAlgebra (FunctionField (k := k) (sigma := sigma)) L :=
    finiteExtensionCoordinateDifferentialAlgebra (k := k) i L
  rw [deriv_algebraMap]
  change algebraMap (FunctionField (k := k) (sigma := sigma)) L
      (coordinateDerivation (k := k) i
        (algebraMap
          (PolynomialRing (k := k) (sigma := sigma))
          (FunctionField (k := k) (sigma := sigma)) p)) = _
  rw [coordinateDerivation_algebraMap]

end MvPolynomialFractionRing

end

end BConicBundleMultisections
