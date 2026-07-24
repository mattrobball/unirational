/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveFiberPolynomial
public import BConicBundleMultisections.UniversalResidualIdentity
public import Mathlib.Data.Finsupp.Weight
public import Mathlib.RingTheory.MvPolynomial.Homogeneous
public import Mathlib.RingTheory.MvPolynomial.WeightedHomogeneous

/-!
# Residual divisor equation of bidegree `(10,1)`

For a bidegree-`(2,3)` equation `F`, view `F(x,-)` as a plane cubic in the second Cox block.
The universal residual linear form of that cubic has coefficients of degree five in the ten
cubic coefficients; each cubic coefficient is quadratic in `x`, so the residual coefficients
are of degree ten in `x`.  The resulting form is linear in the second block.
-/

@[expose] public section

open MvPolynomial

namespace BConicBundleMultisections
namespace ResidualDivisor

noncomputable section

variable {R : Type*} [CommRing R]

open UniversalResidual

/-- First-block multi-degree of a biprojective multi-index. -/
def firstPart (d : BiprojectiveCoordinate 2 2 →₀ ℕ) : Fin 3 →₀ ℕ :=
  Finsupp.equivFunOnFinite.symm fun j => d (.inl j)

/-- Second-block multi-degree of a biprojective multi-index. -/
def secondPart (d : BiprojectiveCoordinate 2 2 →₀ ℕ) : Fin 3 →₀ ℕ :=
  Finsupp.equivFunOnFinite.symm fun k => d (.inr k)

@[simp]
theorem firstPart_apply (d : BiprojectiveCoordinate 2 2 →₀ ℕ) (j : Fin 3) :
    firstPart d j = d (.inl j) := by
  simp [firstPart]

@[simp]
theorem secondPart_apply (d : BiprojectiveCoordinate 2 2 →₀ ℕ) (k : Fin 3) :
    secondPart d k = d (.inr k) := by
  simp [secondPart]

/-- Coefficient of a pure second-block monomial, returned as a polynomial in the first block. -/
def secondBlockCoeff (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (m : Fin 3 →₀ ℕ) : MvPolynomial (Fin 3) R :=
  ∑ d ∈ F.support,
    if secondPart d = m then monomial (firstPart d) (F.coeff d) else 0

/-- The ten second-block cubic coefficients of a biprojective polynomial. -/
def cubicCoefficients (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    Fin 10 → MvPolynomial (Fin 3) R
  | ⟨0, _⟩ => secondBlockCoeff F (Finsupp.single 0 3)
  | ⟨1, _⟩ => secondBlockCoeff F (Finsupp.single 0 2 + Finsupp.single 1 1)
  | ⟨2, _⟩ => secondBlockCoeff F (Finsupp.single 0 1 + Finsupp.single 1 2)
  | ⟨3, _⟩ => secondBlockCoeff F (Finsupp.single 1 3)
  | ⟨4, _⟩ => secondBlockCoeff F (Finsupp.single 0 2 + Finsupp.single 2 1)
  | ⟨5, _⟩ => secondBlockCoeff F
      (Finsupp.single 0 1 + Finsupp.single 1 1 + Finsupp.single 2 1)
  | ⟨6, _⟩ => secondBlockCoeff F (Finsupp.single 1 2 + Finsupp.single 2 1)
  | ⟨7, _⟩ => secondBlockCoeff F (Finsupp.single 0 1 + Finsupp.single 2 2)
  | ⟨8, _⟩ => secondBlockCoeff F (Finsupp.single 1 1 + Finsupp.single 2 2)
  | ⟨9, _⟩ => secondBlockCoeff F (Finsupp.single 2 3)

/-- Polynomial-ring form of `residualCoeffU`. -/
def residualCoeffU_poly (a b c d e f hh i : MvPolynomial (Fin 3) R) :
    MvPolynomial (Fin 3) R :=
  -3 * a ^ 2 * c * hh ^ 2 - 27 * a ^ 2 * d ^ 2 * i + 9 * a ^ 2 * d * f * hh +
    a * b ^ 2 * hh ^ 2 + 18 * a * b * c * d * i - a * b * c * f * hh -
    6 * a * b * d * e * hh - 3 * a * b * d * f ^ 2 - 4 * a * c ^ 3 * i +
    2 * a * c ^ 2 * e * hh + a * c ^ 2 * f ^ 2 - 3 * a * c * d * e * f +
    9 * a * d ^ 2 * e ^ 2 - 4 * b ^ 3 * d * i + b ^ 2 * c ^ 2 * i +
    4 * b ^ 2 * d * e * f - b * c ^ 2 * e * f - 4 * b * c * d * e ^ 2 +
    c ^ 3 * e ^ 2

/-- Polynomial-ring form of `residualCoeffV`. -/
def residualCoeffV_poly (a b c d e f hh j : MvPolynomial (Fin 3) R) :
    MvPolynomial (Fin 3) R :=
  -27 * a ^ 2 * d ^ 2 * j + 9 * a ^ 2 * d * hh ^ 2 + 18 * a * b * c * d * j -
    4 * a * b * c * hh ^ 2 - 3 * a * b * d * f * hh - 4 * a * c ^ 3 * j +
    4 * a * c ^ 2 * f * hh - 6 * a * c * d * e * hh - 3 * a * c * d * f ^ 2 +
    9 * a * d ^ 2 * e * f - 4 * b ^ 3 * d * j + b ^ 3 * hh ^ 2 +
    b ^ 2 * c ^ 2 * j - b ^ 2 * c * f * hh + 2 * b ^ 2 * d * e * hh +
    b ^ 2 * d * f ^ 2 - b * c * d * e * f - 3 * b * d ^ 2 * e ^ 2 +
    c ^ 2 * d * e ^ 2

/-- Polynomial-ring form of `residualCoeffW`. -/
def residualCoeffW_poly (a b c d e f hh k : MvPolynomial (Fin 3) R) :
    MvPolynomial (Fin 3) R :=
  -27 * a ^ 2 * d ^ 2 * k + a ^ 2 * hh ^ 3 + 18 * a * b * c * d * k -
    a * b * f * hh ^ 2 - 4 * a * c ^ 3 * k - 2 * a * c * e * hh ^ 2 +
    a * c * f ^ 2 * hh + 3 * a * d * e * f * hh - a * d * f ^ 3 -
    4 * b ^ 3 * d * k + b ^ 2 * c ^ 2 * k + b ^ 2 * e * hh ^ 2 -
    b * c * e * f * hh - 2 * b * d * e ^ 2 * hh + b * d * e * f ^ 2 +
    c ^ 2 * e ^ 2 * hh - c * d * e ^ 2 * f + d ^ 2 * e ^ 3

/-- Lift a first-block polynomial to biprojective coordinates. -/
def liftFirstBlock (p : MvPolynomial (Fin 3) R) :
    MvPolynomial (BiprojectiveCoordinate 2 2) R :=
  rename Sum.inl p

/-- Lift a first-block coefficient times a second-block variable. -/
def liftSecondLinear (p : MvPolynomial (Fin 3) R) (k : Fin 3) :
    MvPolynomial (BiprojectiveCoordinate 2 2) R :=
  liftFirstBlock p * X (.inr k)

/-- Residual coefficient of `Y₀` in the residual divisor equation of `F`. -/
def residualCoeffU_of (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    MvPolynomial (Fin 3) R :=
  let c := cubicCoefficients F
  residualCoeffU_poly (c ⟨0, by omega⟩) (c ⟨1, by omega⟩) (c ⟨2, by omega⟩)
    (c ⟨3, by omega⟩) (c ⟨4, by omega⟩) (c ⟨5, by omega⟩) (c ⟨6, by omega⟩) (c ⟨7, by omega⟩)

/-- Residual coefficient of `Y₁` in the residual divisor equation of `F`. -/
def residualCoeffV_of (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    MvPolynomial (Fin 3) R :=
  let c := cubicCoefficients F
  residualCoeffV_poly (c ⟨0, by omega⟩) (c ⟨1, by omega⟩) (c ⟨2, by omega⟩)
    (c ⟨3, by omega⟩) (c ⟨4, by omega⟩) (c ⟨5, by omega⟩) (c ⟨6, by omega⟩) (c ⟨8, by omega⟩)

/-- Residual coefficient of `Y₂` in the residual divisor equation of `F`. -/
def residualCoeffW_of (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    MvPolynomial (Fin 3) R :=
  let c := cubicCoefficients F
  residualCoeffW_poly (c ⟨0, by omega⟩) (c ⟨1, by omega⟩) (c ⟨2, by omega⟩)
    (c ⟨3, by omega⟩) (c ⟨4, by omega⟩) (c ⟨5, by omega⟩) (c ⟨6, by omega⟩) (c ⟨9, by omega⟩)

/-- The residual divisor equation attached to `F` on the coordinate line `Y₂ = 0`. -/
def residualEquation (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    MvPolynomial (BiprojectiveCoordinate 2 2) R :=
  liftSecondLinear (residualCoeffU_of F) 0 +
    liftSecondLinear (residualCoeffV_of F) 1 +
    liftSecondLinear (residualCoeffW_of F) 2

/-- Unfolded form of `residualEquation` matching the original coefficient-wise definition. -/
theorem residualEquation_eq (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    residualEquation F =
      (let c := cubicCoefficients F
      let qU := residualCoeffU_poly (c ⟨0, by omega⟩) (c ⟨1, by omega⟩) (c ⟨2, by omega⟩)
        (c ⟨3, by omega⟩) (c ⟨4, by omega⟩) (c ⟨5, by omega⟩) (c ⟨6, by omega⟩) (c ⟨7, by omega⟩)
      let qV := residualCoeffV_poly (c ⟨0, by omega⟩) (c ⟨1, by omega⟩) (c ⟨2, by omega⟩)
        (c ⟨3, by omega⟩) (c ⟨4, by omega⟩) (c ⟨5, by omega⟩) (c ⟨6, by omega⟩) (c ⟨8, by omega⟩)
      let qW := residualCoeffW_poly (c ⟨0, by omega⟩) (c ⟨1, by omega⟩) (c ⟨2, by omega⟩)
        (c ⟨3, by omega⟩) (c ⟨4, by omega⟩) (c ⟨5, by omega⟩) (c ⟨6, by omega⟩) (c ⟨9, by omega⟩)
      liftSecondLinear qU 0 + liftSecondLinear qV 1 + liftSecondLinear qW 2) := by
  rfl

/-- Evaluation of residual coefficient polynomials agrees with the scalar residual coefficients. -/
theorem eval_residualCoeffU_poly
    (a b c d e f hh i : MvPolynomial (Fin 3) R) (x : Fin 3 → R) :
    eval x (residualCoeffU_poly a b c d e f hh i) =
      residualCoeffU (eval x a) (eval x b) (eval x c) (eval x d)
        (eval x e) (eval x f) (eval x hh) (eval x i) := by
  simp [residualCoeffU_poly, residualCoeffU, map_add, map_sub, map_mul, map_pow,
    map_neg, map_ofNat]

theorem eval_residualCoeffV_poly
    (a b c d e f hh j : MvPolynomial (Fin 3) R) (x : Fin 3 → R) :
    eval x (residualCoeffV_poly a b c d e f hh j) =
      residualCoeffV (eval x a) (eval x b) (eval x c) (eval x d)
        (eval x e) (eval x f) (eval x hh) (eval x j) := by
  simp [residualCoeffV_poly, residualCoeffV, map_add, map_sub, map_mul, map_pow,
    map_neg, map_ofNat]

theorem eval_residualCoeffW_poly
    (a b c d e f hh k : MvPolynomial (Fin 3) R) (x : Fin 3 → R) :
    eval x (residualCoeffW_poly a b c d e f hh k) =
      residualCoeffW (eval x a) (eval x b) (eval x c) (eval x d)
        (eval x e) (eval x f) (eval x hh) (eval x k) := by
  simp [residualCoeffW_poly, residualCoeffW, map_add, map_sub, map_mul, map_pow,
    map_neg, map_ofNat]

/-- Evaluating a first-block lift only depends on the first coordinates. -/
theorem eval_liftFirstBlock (p : MvPolynomial (Fin 3) R) (x y : Fin 3 → R) :
    eval (Sum.elim x y) (liftFirstBlock p) = eval x p := by
  simp [liftFirstBlock, eval_rename, Function.comp_def]

/-- Evaluating a residual linear lift multiplies the first-block coefficient by a second-block
coordinate. -/
theorem eval_liftSecondLinear (p : MvPolynomial (Fin 3) R) (k : Fin 3) (x y : Fin 3 → R) :
    eval (Sum.elim x y) (liftSecondLinear p k) = eval x p * y k := by
  simp [liftSecondLinear, eval_liftFirstBlock]

/-- Pointwise evaluation of the residual divisor equation is the dual pairing of residual
coefficients with the second-block coordinates. -/
theorem eval_residualEquation
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (x y : Fin 3 → R) :
    eval (Sum.elim x y) (residualEquation F) =
      eval x (residualCoeffU_of F) * y 0 +
        eval x (residualCoeffV_of F) * y 1 +
        eval x (residualCoeffW_of F) * y 2 := by
  simp [residualEquation, eval_liftSecondLinear, mul_comm, add_assoc]

/-! ### Coefficient-ring functoriality of the residual equation -/

theorem map_secondBlockCoeff {S : Type*} [CommRing S] (φ : R →+* S)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (m : Fin 3 →₀ ℕ) :
    secondBlockCoeff (map φ F) m = map φ (secondBlockCoeff F m) := by
  classical
  simp only [secondBlockCoeff, map_sum]
  have hterm (d : BiprojectiveCoordinate 2 2 →₀ ℕ) :
      map φ (if secondPart d = m then monomial (firstPart d) (F.coeff d) else 0) =
        if secondPart d = m then monomial (firstPart d) (φ (F.coeff d)) else 0 := by
    split_ifs <;> simp [map_monomial]
  simp_rw [hterm]
  have hcoeff :
      (∑ d ∈ (map φ F).support,
          if secondPart d = m then monomial (firstPart d) ((map φ F).coeff d) else 0) =
        ∑ d ∈ (map φ F).support,
          if secondPart d = m then monomial (firstPart d) (φ (F.coeff d)) else 0 := by
    refine Finset.sum_congr rfl fun d _ => ?_
    split_ifs <;> simp [coeff_map]
  rw [hcoeff]
  refine Finset.sum_subset ?_ ?_
  · intro d hd
    have hne : (map φ F).coeff d ≠ 0 := by simpa [mem_support_iff] using hd
    rw [coeff_map] at hne
    exact mem_support_iff.mpr (fun h => hne (by simp [h]))
  · intro d _ hdmap
    have h0 : φ (F.coeff d) = 0 := by
      have : (map φ F).coeff d = 0 := by simpa [mem_support_iff] using hdmap
      rwa [coeff_map] at this
    split_ifs <;> simp [h0]

theorem map_cubicCoefficients {S : Type*} [CommRing S] (φ : R →+* S)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (i : Fin 10) :
    cubicCoefficients (map φ F) i = map φ (cubicCoefficients F i) := by
  fin_cases i <;> simp only [cubicCoefficients, map_secondBlockCoeff]

theorem map_residualCoeffU_poly {S : Type*} [CommRing S] (φ : R →+* S)
    (a b c d e f hh i : MvPolynomial (Fin 3) R) :
    residualCoeffU_poly (map φ a) (map φ b) (map φ c) (map φ d)
      (map φ e) (map φ f) (map φ hh) (map φ i) =
      map φ (residualCoeffU_poly a b c d e f hh i) := by
  simp [residualCoeffU_poly]

theorem map_residualCoeffV_poly {S : Type*} [CommRing S] (φ : R →+* S)
    (a b c d e f hh j : MvPolynomial (Fin 3) R) :
    residualCoeffV_poly (map φ a) (map φ b) (map φ c) (map φ d)
      (map φ e) (map φ f) (map φ hh) (map φ j) =
      map φ (residualCoeffV_poly a b c d e f hh j) := by
  simp [residualCoeffV_poly]

theorem map_residualCoeffW_poly {S : Type*} [CommRing S] (φ : R →+* S)
    (a b c d e f hh k : MvPolynomial (Fin 3) R) :
    residualCoeffW_poly (map φ a) (map φ b) (map φ c) (map φ d)
      (map φ e) (map φ f) (map φ hh) (map φ k) =
      map φ (residualCoeffW_poly a b c d e f hh k) := by
  simp [residualCoeffW_poly]

theorem map_liftFirstBlock {S : Type*} [CommRing S] (φ : R →+* S)
    (p : MvPolynomial (Fin 3) R) :
    liftFirstBlock (map φ p) = map φ (liftFirstBlock p) := by
  simp [liftFirstBlock, map_rename]

theorem map_liftSecondLinear {S : Type*} [CommRing S] (φ : R →+* S)
    (p : MvPolynomial (Fin 3) R) (k : Fin 3) :
    liftSecondLinear (map φ p) k = map φ (liftSecondLinear p k) := by
  simp [liftSecondLinear, map_liftFirstBlock]

/-- The residual divisor equation commutes with coefficient ring homomorphisms. -/
theorem map_residualEquation {S : Type*} [CommRing S] (φ : R →+* S)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    residualEquation (map φ F) = map φ (residualEquation F) := by
  simp only [residualEquation, residualCoeffU_of, residualCoeffV_of, residualCoeffW_of]
  have hc (i : Fin 10) : cubicCoefficients (map φ F) i = map φ (cubicCoefficients F i) :=
    map_cubicCoefficients φ F i
  simp only [hc, map_add, map_liftSecondLinear, map_residualCoeffU_poly,
    map_residualCoeffV_poly, map_residualCoeffW_poly]

/-- Polynomial-level residual image: common zeros of `F` and its residual divisor equation. -/
def IsResidualImagePoint
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (x y : Fin 3 → R) : Prop :=
  eval (Sum.elim x y) F = 0 ∧ eval (Sum.elim x y) (residualEquation F) = 0

/-- A residual image point lies on the hypersurface `{F = 0}`. -/
theorem IsResidualImagePoint.eval_F
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R} {x y : Fin 3 → R}
    (h : IsResidualImagePoint F x y) :
    eval (Sum.elim x y) F = 0 :=
  h.1

/-- A residual image point lies on the residual divisor. -/
theorem IsResidualImagePoint.eval_residual
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R} {x y : Fin 3 → R}
    (h : IsResidualImagePoint F x y) :
    eval (Sum.elim x y) (residualEquation F) = 0 :=
  h.2

/-- Residual image membership expands as vanishing of `F` and of the residual dual pairing. -/
theorem isResidualImagePoint_iff
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (x y : Fin 3 → R) :
    IsResidualImagePoint F x y ↔
      eval (Sum.elim x y) F = 0 ∧
        eval x (residualCoeffU_of F) * y 0 +
          eval x (residualCoeffV_of F) * y 1 +
          eval x (residualCoeffW_of F) * y 2 = 0 := by
  constructor
  · intro h
    exact ⟨h.1, by simpa [eval_residualEquation] using h.2⟩
  · intro h
    exact ⟨h.1, by simpa [eval_residualEquation] using h.2⟩

/-! ### Bidegree bookkeeping for residual coefficients -/

open Finsupp

/-- The ordinary degree of the first-block multi-index equals the left weighted degree. -/
theorem degree_firstPart (d : BiprojectiveCoordinate 2 2 →₀ ℕ) :
    (firstPart d).degree = weight leftDegreeWeight d := by
  classical
  -- Expand both sides as sums over the first Cox block.
  have hfp (i : Fin 3) : firstPart d i = d (.inl i) := by simp [firstPart]
  calc
    (firstPart d).degree
        = ∑ i : Fin 3, firstPart d i := by
          simp [degree_eq_sum]
    _ = ∑ i : Fin 3, d (.inl i) := by simp [hfp]
    _ = weight leftDegreeWeight d := by
          rw [weight_apply, Finsupp.sum]
          refine Eq.symm ?_
          have hzero (x : BiprojectiveCoordinate 2 2) (hx : x ∉ d.support) :
              d x • leftDegreeWeight x = 0 := by
            have : d x = 0 := notMem_support_iff.mp hx
            simp [this]
          have huniv :
              (∑ x ∈ d.support, d x • leftDegreeWeight x) =
                ∑ x : BiprojectiveCoordinate 2 2, d x • leftDegreeWeight x :=
            Finset.sum_subset (Finset.subset_univ _) (fun x _ hx => hzero x hx)
          rw [huniv, Fintype.sum_sum_type]
          simp [leftDegreeWeight]

/-- Second-block cubic coefficients of a bidegree-`(2,3)` polynomial are homogeneous of
degree two in the first block (or zero). -/
theorem secondBlockCoeff_isHomogeneous_of_bidegree23
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (m : Fin 3 →₀ ℕ) :
    (secondBlockCoeff F m).IsHomogeneous 2 := by
  classical
  refine IsHomogeneous.sum _ _ _ ?_
  intro d hd
  split_ifs with h
  · have hdc : coeff d F ≠ 0 := MvPolynomial.mem_support_iff.mp hd
    have hdeg : weight bidegreeWeight d = (2, 3) := hF hdc
    have hleft : weight leftDegreeWeight d = 2 := by
      simpa [fst_weight_bidegreeWeight] using congrArg Prod.fst hdeg
    have hfirst : (firstPart d).degree = 2 := by
      simpa [degree_firstPart] using hleft
    exact isHomogeneous_monomial (F.coeff d) hfirst
  · exact isHomogeneous_zero (Fin 3) R 2

/-- All ten cubic coefficient extractors of a bidegree-`(2,3)` polynomial are homogeneous of
degree two. -/
theorem cubicCoefficients_isHomogeneous_of_bidegree23
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (i : Fin 10) :
    (cubicCoefficients F i).IsHomogeneous 2 := by
  fin_cases i <;> exact secondBlockCoeff_isHomogeneous_of_bidegree23 hF _

/-! ### Second-block coefficients vs. specialized cubic fiber (pure R-level) -/

open Finsupp

private theorem firstPart_zero : firstPart (0 : BiprojectiveCoordinate 2 2 →₀ ℕ) = 0 := by
  ext; simp [firstPart]

private theorem secondPart_zero : secondPart (0 : BiprojectiveCoordinate 2 2 →₀ ℕ) = 0 := by
  ext; simp [secondPart]

private theorem firstPart_add (d₁ d₂ : BiprojectiveCoordinate 2 2 →₀ ℕ) :
    firstPart (d₁ + d₂) = firstPart d₁ + firstPart d₂ := by
  ext; simp [firstPart]

private theorem secondPart_add (d₁ d₂ : BiprojectiveCoordinate 2 2 →₀ ℕ) :
    secondPart (d₁ + d₂) = secondPart d₁ + secondPart d₂ := by
  ext; simp [secondPart]

private theorem firstPart_single_inl (i : Fin 3) (b : ℕ) :
    firstPart (single (.inl i) b) = single i b := by
  ext j; simp [firstPart, single_apply, Sum.inl.injEq]

private theorem firstPart_single_inr (j : Fin 3) (b : ℕ) :
    firstPart (single (.inr j) b) = 0 := by
  ext i; simp [firstPart]

private theorem secondPart_single_inl (i : Fin 3) (b : ℕ) :
    secondPart (single (.inl i) b) = 0 := by
  ext k; simp [secondPart]

private theorem secondPart_single_inr (j : Fin 3) (b : ℕ) :
    secondPart (single (.inr j) b) = single j b := by
  ext k; simp [secondPart, single_apply, Sum.inr.injEq]

/-- Substitution power map matching `specializeFirstCoordinates` output type `Fin (2+1)`. -/
private def substPow (x : Fin 3 → R) (z : BiprojectiveCoordinate 2 2) (e : ℕ) :
    MvPolynomial (Fin (2 + 1)) R :=
  (match z with
    | .inl i => (C (x i) : MvPolynomial (Fin (2 + 1)) R)
    | .inr j => X j) ^ e

private theorem substPow_zero (x : Fin 3 → R) (z : BiprojectiveCoordinate 2 2) :
    substPow x z 0 = 1 := by cases z <;> simp [substPow]

private theorem substPow_add (x : Fin 3 → R) (z : BiprojectiveCoordinate 2 2) (b₁ b₂ : ℕ) :
    substPow x z (b₁ + b₂) = substPow x z b₁ * substPow x z b₂ := by
  cases z <;> simp [substPow, pow_add]

private theorem substPow_inl (x : Fin 3 → R) (i : Fin 3) (e : ℕ) :
    substPow x (.inl i) e = (C (x i) : MvPolynomial (Fin (2 + 1)) R) ^ e := by
  simp [substPow]

private theorem substPow_inr (x : Fin 3 → R) (j : Fin 3) (e : ℕ) :
    substPow x (.inr j) e = (X j : MvPolynomial (Fin (2 + 1)) R) ^ e := by
  simp [substPow]

private theorem prod_single_pow (x : Fin 3 → R) (i : Fin 3) (b : ℕ) (g : Fin 3 →₀ ℕ) :
    ((single i b + g).prod fun j e => x j ^ e) =
      x i ^ b * g.prod fun j e => x j ^ e := by
  classical
  rw [prod_add_index (h_zero := fun a _ => pow_zero (x a))
    (h_add := fun a _ b₁ b₂ => pow_add (x a) b₁ b₂)]
  have hsi : (single i b).prod (fun j e => x j ^ e) = x i ^ b :=
    prod_single_index (a := i) (b := b) (h := fun j e => x j ^ e) (pow_zero (x i))
  rw [hsi]

/-- Coefficient of a product of substitution powers — pure R-level.
Parameterized by any `h` agreeing with the specializeFirst substitution on blocks,
so callers can pass the exact function arising from `aeval_monomial` without poly equality. -/
private theorem coeff_prod_subst
    (x : Fin 3 → R) (d : BiprojectiveCoordinate 2 2 →₀ ℕ) (m : Fin 3 →₀ ℕ)
    (h : BiprojectiveCoordinate 2 2 → ℕ → MvPolynomial (Fin (2 + 1)) R)
    (hinl : ∀ i e, h (.inl i) e = (C (x i) : MvPolynomial (Fin (2 + 1)) R) ^ e)
    (hinr : ∀ j e, h (.inr j) e = (X j : MvPolynomial (Fin (2 + 1)) R) ^ e)
    (h0 : ∀ z, h z 0 = 1)
    (hadd : ∀ z b₁ b₂, h z (b₁ + b₂) = h z b₁ * h z b₂) :
    (d.prod h).coeff m =
      if m = secondPart d then (firstPart d).prod fun i e => x i ^ e else 0 := by
  classical
  induction d using Finsupp.induction generalizing m with
  | zero =>
      simp only [prod_zero_index, firstPart_zero, secondPart_zero, prod_zero_index]
      simp [coeff_one, eq_comm]
  | single_add a b f ha hb ih =>
      have hpf :
          ((single a b + f).prod h) = h a b * f.prod h := by
        rw [prod_add_index (h_zero := fun z _ => h0 z)
          (h_add := fun z _ b₁ b₂ => hadd z b₁ b₂),
          prod_single_index (h0 a)]
      rw [hpf]
      cases a with
      | inl i =>
          rw [hinl i b]
          have hCb : ((C (x i) : MvPolynomial (Fin (2 + 1)) R) ^ b) = C (x i ^ b) :=
            (map_pow (C : R →+* MvPolynomial (Fin (2 + 1)) R) (x i) b).symm
          rw [hCb, coeff_C_mul, ih]
          have hsp : secondPart (single (.inl i) b + f) = secondPart f := by
            rw [secondPart_add, secondPart_single_inl, zero_add]
          have hfp : firstPart (single (.inl i) b + f) = single i b + firstPart f := by
            rw [firstPart_add, firstPart_single_inl]
          simp only [hsp, hfp]
          split_ifs with hm
          · exact (prod_single_pow x i b (firstPart f)).symm
          · rw [mul_zero]
      | inr j =>
          rw [hinr j b]
          have hX : (X j : MvPolynomial (Fin (2 + 1)) R) ^ b = monomial (single j b) 1 := by
            simp [X_pow_eq_monomial]
          rw [hX]
          have hsp : secondPart (single (.inr j) b + f) = single j b + secondPart f := by
            rw [secondPart_add, secondPart_single_inr]
          have hfp : firstPart (single (.inr j) b + f) = firstPart f := by
            rw [firstPart_add, firstPart_single_inr, zero_add]
          simp only [hsp, hfp]
          by_cases hle : single j b ≤ m
          · have hm' : m = single j b + (m - single j b) :=
              (add_tsub_cancel_of_le hle).symm
            have heq :
                (m - single j b = secondPart f) ↔
                  (single j b + (m - single j b) = single j b + secondPart f) := by
              constructor
              · intro h; rw [h]
              · intro h; exact add_left_cancel h
            rw [hm', coeff_monomial_mul, one_mul, ih]
            exact if_congr heq rfl rfl
          · have h0' :
                coeff m (monomial (single j b) (1 : R) * f.prod h) = 0 := by
              rw [coeff_mul, Finset.sum_eq_zero]
              intro ⟨u, v⟩ huv
              simp only [Finset.mem_antidiagonal] at huv
              simp only [coeff_monomial]
              split_ifs with hu'
              · exfalso
                exact hle (by rw [← huv, hu']; exact le_self_add)
              · simp
            rw [h0']
            have hne : m ≠ single j b + secondPart f := by
              intro heq; exact hle (by rw [heq]; exact le_self_add)
            simp [hne]

/-- Coefficient of `specializeFirst` of a mononial — pure R-level. -/
private theorem coeff_specializeFirst_monomial
    (x : Fin 3 → R) (d : BiprojectiveCoordinate 2 2 →₀ ℕ) (c : R) (m : Fin 3 →₀ ℕ) :
    (specializeFirstCoordinates (n := 2) x (monomial d c)).coeff m =
      if m = secondPart d then c * (firstPart d).prod fun i e => x i ^ e else 0 := by
  classical
  unfold specializeFirstCoordinates
  rw [aeval_monomial]
  have hC : (algebraMap R (MvPolynomial (Fin (2 + 1)) R)) c = C c := rfl
  rw [hC, coeff_C_mul]
  -- Apply coeff_prod_subst to a named match function, then convert across mul' opacity
  let hfn : BiprojectiveCoordinate 2 2 → ℕ → MvPolynomial (Fin (2 + 1)) R :=
    fun i k =>
      (match i with
        | .inl i => (C (x i) : MvPolynomial (Fin (2 + 1)) R)
        | .inr j => X j) ^ k
  have hcoeff :=
    coeff_prod_subst x d m hfn
      (fun i e => rfl) (fun j e => rfl)
      (fun z => by cases z <;> simp [hfn])
      (fun z b₁ b₂ => by cases z <;> simp [hfn, pow_add])
  -- hcoeff : coeff m (d.prod hfn) = if ...
  -- Goal: c * coeff m (d.prod aeval_match) = if c * ...
  -- Convert: the two d.prod terms differ only by non-exposed mul' inside Finsupp.prod
  have hmul := congrArg (fun t : R => c * t) hcoeff
  -- hmul : c * coeff m (d.prod hfn) = c * if ...
  convert hmul using 1
  · -- c * coeff m (d.prod aeval_match) = c * coeff m (d.prod hfn)
    refine congrArg (fun t : R => c * t) ?_
    refine congrArg (coeff m) ?_
    refine congrArg d.prod ?_
    funext z e
    -- hfn is defined as this match form; case-split for defeq
    dsimp only [hfn]
    cases z <;> rfl
  · -- c * if = if c * ...
    split_ifs <;> ring

/-- Evaluating a pure second-block coefficient polynomial at first-block values recovers the
corresponding coefficient of the specialized cubic fiber. -/
theorem eval_secondBlockCoeff
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (m : Fin 3 →₀ ℕ) (x : Fin 3 → R) :
    eval x (secondBlockCoeff F m) =
      (specializeFirstCoordinates (n := 2) x F).coeff m := by
  classical
  -- Expand both sides as sums over F.support mononials
  have hleft :
      eval x (secondBlockCoeff F m) =
        ∑ d ∈ F.support,
          if secondPart d = m then
            F.coeff d * (firstPart d).prod fun i e => x i ^ e
          else 0 := by
    simp only [secondBlockCoeff, map_sum]
    refine Finset.sum_congr rfl fun d _ => ?_
    split_ifs with hm
    · simp [eval_monomial, Finsupp.prod]
    · simp
  have hright :
      (specializeFirstCoordinates (n := 2) x F).coeff m =
        ∑ d ∈ F.support,
          if m = secondPart d then
            F.coeff d * (firstPart d).prod fun i e => x i ^ e
          else 0 := by
    have hsum :
        specializeFirstCoordinates (n := 2) x F =
          ∑ d ∈ F.support,
            specializeFirstCoordinates (n := 2) x (monomial d (F.coeff d)) := by
      simp only [specializeFirstCoordinates]
      conv_lhs => rw [F.as_sum]
      simp only [map_sum]
    rw [hsum, coeff_sum]
    refine Finset.sum_congr rfl fun d _ => ?_
    simpa [eq_comm] using coeff_specializeFirst_monomial x d (F.coeff d) m
  rw [hleft, hright]
  refine Finset.sum_congr rfl fun d _ => ?_
  split_ifs with h1 h2 h3
  · rfl
  · exact absurd h1.symm h2
  · exact absurd h3.symm h1
  · rfl

/-- Residual coefficient of `Y₀` at first-block values equals residual of the cubic fiber. -/
theorem eval_residualCoeffU_of
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (x : Fin 3 → R) :
    eval x (residualCoeffU_of F) =
      residualCoeffU
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 3))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 2 + single 1 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 1 + single 1 2))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 1 3))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 2 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff
          (single 0 1 + single 1 1 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 1 2 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 1 + single 2 2)) := by
  simp only [residualCoeffU_of, eval_residualCoeffU_poly, cubicCoefficients,
    eval_secondBlockCoeff]

theorem eval_residualCoeffV_of
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (x : Fin 3 → R) :
    eval x (residualCoeffV_of F) =
      residualCoeffV
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 3))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 2 + single 1 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 1 + single 1 2))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 1 3))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 2 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff
          (single 0 1 + single 1 1 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 1 2 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 1 1 + single 2 2)) := by
  simp only [residualCoeffV_of, eval_residualCoeffV_poly, cubicCoefficients,
    eval_secondBlockCoeff]

theorem eval_residualCoeffW_of
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (x : Fin 3 → R) :
    eval x (residualCoeffW_of F) =
      residualCoeffW
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 3))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 2 + single 1 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 1 + single 1 2))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 1 3))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 2 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff
          (single 0 1 + single 1 1 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 1 2 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 2 3)) := by
  simp only [residualCoeffW_of, eval_residualCoeffW_poly, cubicCoefficients,
    eval_secondBlockCoeff]

/-- Residual divisor equation evaluation equals the plane-cubic residual linear form of the
specialized cubic fiber. -/
theorem eval_residualEquation_eq_residualLinear_specializeFirst
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (x y : Fin 3 → R) :
    eval (Sum.elim x y) (residualEquation F) =
      residualLinear
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 3))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 2 + single 1 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 1 + single 1 2))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 1 3))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 2 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff
          (single 0 1 + single 1 1 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 1 2 + single 2 1))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 0 1 + single 2 2))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 1 1 + single 2 2))
        ((specializeFirstCoordinates (n := 2) x F).coeff (single 2 3))
        (y 0) (y 1) (y 2) := by
  rw [eval_residualEquation, eval_residualCoeffU_of, eval_residualCoeffV_of,
    eval_residualCoeffW_of]
  rfl

end
end ResidualDivisor
end BConicBundleMultisections
