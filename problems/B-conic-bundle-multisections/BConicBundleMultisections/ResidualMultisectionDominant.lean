/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveFiberNonempty
public import BConicBundleMultisections.BiprojectiveProjectionDominant
public import BConicBundleMultisections.BiprojectiveZeroLocusClosedPoints
public import BConicBundleMultisections.MvPolynomialDimension
public import BConicBundleMultisections.MvPolynomialHomogeneousEvaluation
public import BConicBundleMultisections.ProjectiveCommonZero
public import BConicBundleMultisections.ProjectiveCoordinateNormalization
public import BConicBundleMultisections.ProjectiveSpaceClosedPoints
public import BConicBundleMultisections.ResidualImage
public import BConicBundleMultisections.UniversalResidualIdentity
public import Mathlib.Algebra.MvPolynomial.Eval
public import Mathlib.AlgebraicGeometry.Morphisms.Proper
public import Mathlib.AlgebraicGeometry.PullbackCarrier
public import Mathlib.RingTheory.Ideal.KrullsHeightTheorem
public import Mathlib.RingTheory.LocalProperties.Reduced
public import Mathlib.RingTheory.Nilpotent.Defs
public import Mathlib.RingTheory.Nullstellensatz

/-!
# Residual multisection dominance

Polynomial residual-image lifts of normalized (and closed) base points for smooth bidegree-`(2,3)`
hypersurfaces; properness and surjectivity of the residual multisection base map; scheme-theoretic
horizontality; and dominance of the residual base-change projection `X_T → X`.

The residual image hits every closed point of `ℙ²_y` by a Nullstellensatz/Krull common-zero lift of
the specialized conic against the residual linear form, followed by an ambient chart evaluation
lifted through the residual-image closed immersion.  Properness + Jacobson then give surjectivity
of `residualImageToBase`; pullback stability of surjections gives dominance of `baseChangeFst`.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry BiprojectiveSpace ResidualDivisor ProjectiveSpace
open UniversalResidual
open _root_.MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra

set_option backward.isDefEq.respectTransparency false

/-! ### Residual linear form -/

/-- Residual linear form in the first block. -/
def residualLinearForm
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (y : Fin 3 → R) :
    MvPolynomial (Fin 3) R :=
  C (y 0) * residualCoeffU_of F +
    C (y 1) * residualCoeffV_of F +
    C (y 2) * residualCoeffW_of F

theorem eval_residualLinearForm
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (x y : Fin 3 → R) :
    eval x (residualLinearForm F y) =
      eval x (residualCoeffU_of F) * y 0 +
        eval x (residualCoeffV_of F) * y 1 +
        eval x (residualCoeffW_of F) * y 2 := by
  simp [residualLinearForm, mul_comm]

theorem eval_residualEquation_eq_eval_residualLinearForm
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (x y : Fin 3 → R) :
    eval (Sum.elim x y) (residualEquation F) =
      eval x (residualLinearForm F y) := by
  rw [eval_residualEquation, eval_residualLinearForm]

/-! ### Multi-homogeneity of residual coefficient scalars (degree 5) -/

theorem residualCoeffU_smul {R : Type*} [CommRing R] (r a b c d e f hh i : R) :
    residualCoeffU (r * a) (r * b) (r * c) (r * d) (r * e) (r * f) (r * hh) (r * i) =
      r ^ 5 * residualCoeffU a b c d e f hh i := by
  simp only [residualCoeffU]
  ring

theorem residualCoeffV_smul {R : Type*} [CommRing R] (r a b c d e f hh j : R) :
    residualCoeffV (r * a) (r * b) (r * c) (r * d) (r * e) (r * f) (r * hh) (r * j) =
      r ^ 5 * residualCoeffV a b c d e f hh j := by
  simp only [residualCoeffV]
  ring

theorem residualCoeffW_smul {R : Type*} [CommRing R] (r a b c d e f hh k : R) :
    residualCoeffW (r * a) (r * b) (r * c) (r * d) (r * e) (r * f) (r * hh) (r * k) =
      r ^ 5 * residualCoeffW a b c d e f hh k := by
  simp only [residualCoeffW]
  ring

theorem eval_cubicCoefficients_smul_of_bidegree23
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (r : R) (x : Fin 3 → R) (i : Fin 10) :
    eval (r • x) (cubicCoefficients F i) =
      r ^ 2 * eval x (cubicCoefficients F i) := by
  have h := cubicCoefficients_isHomogeneous_of_bidegree23 hF i
  -- `eval_smul_point_of_isHomogeneous` scales pointwise by `r * ·`.
  simpa [Pi.smul_def, smul_eq_mul] using eval_smul_point_of_isHomogeneous h r x

theorem eval_residualCoeffU_of_smul_of_bidegree23
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (r : R) (x : Fin 3 → R) :
    eval (r • x) (residualCoeffU_of F) =
      r ^ 10 * eval x (residualCoeffU_of F) := by
  simp only [residualCoeffU_of, eval_residualCoeffU_poly]
  have hc (i : Fin 10) :
      eval (r • x) (cubicCoefficients F i) =
        r ^ 2 * eval x (cubicCoefficients F i) :=
    eval_cubicCoefficients_smul_of_bidegree23 hF r x i
  simp only [hc]
  -- residualCoeffU is multi-homogeneous of degree 5, so scaling inputs by `r^2`
  -- multiplies the value by `(r^2)^5 = r^10`.
  rw [residualCoeffU_smul (r ^ 2)
    (eval x (cubicCoefficients F ⟨0, by omega⟩))
    (eval x (cubicCoefficients F ⟨1, by omega⟩))
    (eval x (cubicCoefficients F ⟨2, by omega⟩))
    (eval x (cubicCoefficients F ⟨3, by omega⟩))
    (eval x (cubicCoefficients F ⟨4, by omega⟩))
    (eval x (cubicCoefficients F ⟨5, by omega⟩))
    (eval x (cubicCoefficients F ⟨6, by omega⟩))
    (eval x (cubicCoefficients F ⟨7, by omega⟩))]
  ring

theorem eval_residualCoeffV_of_smul_of_bidegree23
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (r : R) (x : Fin 3 → R) :
    eval (r • x) (residualCoeffV_of F) =
      r ^ 10 * eval x (residualCoeffV_of F) := by
  simp only [residualCoeffV_of, eval_residualCoeffV_poly]
  have hc (i : Fin 10) :
      eval (r • x) (cubicCoefficients F i) =
        r ^ 2 * eval x (cubicCoefficients F i) :=
    eval_cubicCoefficients_smul_of_bidegree23 hF r x i
  simp only [hc]
  rw [residualCoeffV_smul (r ^ 2)
    (eval x (cubicCoefficients F ⟨0, by omega⟩))
    (eval x (cubicCoefficients F ⟨1, by omega⟩))
    (eval x (cubicCoefficients F ⟨2, by omega⟩))
    (eval x (cubicCoefficients F ⟨3, by omega⟩))
    (eval x (cubicCoefficients F ⟨4, by omega⟩))
    (eval x (cubicCoefficients F ⟨5, by omega⟩))
    (eval x (cubicCoefficients F ⟨6, by omega⟩))
    (eval x (cubicCoefficients F ⟨8, by omega⟩))]
  ring

theorem eval_residualCoeffW_of_smul_of_bidegree23
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (r : R) (x : Fin 3 → R) :
    eval (r • x) (residualCoeffW_of F) =
      r ^ 10 * eval x (residualCoeffW_of F) := by
  simp only [residualCoeffW_of, eval_residualCoeffW_poly]
  have hc (i : Fin 10) :
      eval (r • x) (cubicCoefficients F i) =
        r ^ 2 * eval x (cubicCoefficients F i) :=
    eval_cubicCoefficients_smul_of_bidegree23 hF r x i
  simp only [hc]
  rw [residualCoeffW_smul (r ^ 2)
    (eval x (cubicCoefficients F ⟨0, by omega⟩))
    (eval x (cubicCoefficients F ⟨1, by omega⟩))
    (eval x (cubicCoefficients F ⟨2, by omega⟩))
    (eval x (cubicCoefficients F ⟨3, by omega⟩))
    (eval x (cubicCoefficients F ⟨4, by omega⟩))
    (eval x (cubicCoefficients F ⟨5, by omega⟩))
    (eval x (cubicCoefficients F ⟨6, by omega⟩))
    (eval x (cubicCoefficients F ⟨9, by omega⟩))]
  ring

theorem eval_residualLinearForm_smul_of_bidegree23
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (r : R) (x y : Fin 3 → R) :
    eval (r • x) (residualLinearForm F y) =
      r ^ 10 * eval x (residualLinearForm F y) := by
  simp only [eval_residualLinearForm, eval_residualCoeffU_of_smul_of_bidegree23 hF,
    eval_residualCoeffV_of_smul_of_bidegree23 hF,
    eval_residualCoeffW_of_smul_of_bidegree23 hF]
  ring

theorem eval_residualEquation_smul_first_of_bidegree23
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (r : R) (x y : Fin 3 → R) :
    eval (Sum.elim (r • x) y) (residualEquation F) =
      r ^ 10 * eval (Sum.elim x y) (residualEquation F) := by
  simp only [eval_residualEquation_eq_eval_residualLinearForm,
    eval_residualLinearForm_smul_of_bidegree23 hF]

theorem eval_residualEquation_normalize_eq_zero_of_bidegree23
    {R : Type u} [Field R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (x y : Fin 3 → R) (i : Fin 3)
    (hx : eval (Sum.elim x y) (residualEquation F) = 0) :
    eval (Sum.elim (normalizeCoordinateRepresentative x i) y) (residualEquation F) = 0 := by
  simp only [normalizeCoordinateRepresentative]
  rw [eval_residualEquation_smul_first_of_bidegree23 hF, hx, mul_zero]

/-! ### Common zeros via vanishing at the origin (no residual homogeneity) -/

/-- Fewer polynomials vanishing at the origin than coordinates have a common nonzero zero over an
algebraically closed field (Nullstellensatz + Krull height). -/
theorem exists_common_nonzero_zero_of_card_lt_of_eval_zero
    {K : Type u} {σ : Type*} [Field K] [IsAlgClosed K] [Finite σ]
    (s : Finset (MvPolynomial σ K))
    (hs0 : ∀ f ∈ s, eval (0 : σ → K) f = 0)
    (hcard : s.card < Nat.card σ) :
    ∃ x : σ → K, x ≠ 0 ∧ ∀ f ∈ s, eval x f = 0 := by
  classical
  by_contra h
  let I : Ideal (MvPolynomial σ K) := Ideal.span (s : Set (MvPolynomial σ K))
  have hzeroLocus : MvPolynomial.zeroLocus K I = {(0 : σ → K)} := by
    rw [MvPolynomial.zeroLocus_span]
    ext x
    constructor
    · intro hx
      have hxs : ∀ f ∈ s, eval x f = 0 := by
        intro f hf
        have := hx f hf
        simpa [MvPolynomial.aeval_def] using this
      have hx0 : x = 0 := by
        by_contra hx0
        exact h ⟨x, hx0, hxs⟩
      simp [hx0]
    · intro hx
      have hx0 : x = 0 := by simpa using hx
      subst x
      intro f hf
      have := hs0 f hf
      simpa [MvPolynomial.aeval_def] using this
  let P : Ideal (MvPolynomial σ K) :=
    MvPolynomial.vanishingIdeal K ({(0 : σ → K)} : Set (σ → K))
  have hradical : I.radical = P := by
    rw [← MvPolynomial.vanishingIdeal_zeroLocus_eq_radical (K := K), hzeroLocus]
  letI : P.IsMaximal := by
    dsimp only [P]
    infer_instance
  letI : P.IsPrime := (inferInstance : P.IsMaximal).isPrime
  have hPmin : P ∈ I.minimalPrimes := by
    rw [← Ideal.radical_minimalPrimes, hradical,
      Ideal.minimalPrimes_eq_subsingleton_self]
    simp
  have hheight : P.height ≤ s.card :=
    Ideal.height_le_card_of_mem_minimalPrimes_span_finset hPmin
  rw [MvPolynomial.height_eq_natCard_of_isMaximal] at hheight
  have hcard' : Nat.card σ ≤ s.card := by
    exact_mod_cast hheight
  exact (Nat.not_le_of_lt hcard) hcard'

/-- Two polynomials in ≥3 variables over an alg-closed field that vanish at the origin have a
nonzero common zero, provided the generating set is non-tautological for the height argument. -/
theorem exists_common_nonzero_zero_pair_of_eval_zero
    {K : Type u} {σ : Type*} [Field K] [IsAlgClosed K] [Finite σ]
    (f g : MvPolynomial σ K)
    (hf0 : eval (0 : σ → K) f = 0)
    (hg0 : eval (0 : σ → K) g = 0)
    (hσ : 3 ≤ Nat.card σ) :
    ∃ x : σ → K, x ≠ 0 ∧ eval x f = 0 ∧ eval x g = 0 := by
  classical
  obtain ⟨x, hx, hzero⟩ := exists_common_nonzero_zero_of_card_lt_of_eval_zero
    ({f, g} : Finset (MvPolynomial σ K))
    (by
      intro p hp
      simp only [Finset.mem_insert, Finset.mem_singleton] at hp
      rcases hp with rfl | rfl <;> assumption)
    (Finset.card_le_two.trans_lt (by omega))
  exact ⟨x, hx, hzero f (by simp), hzero g (by simp)⟩

/-- Cubic coefficients of a bidegree-`(2,3)` equation vanish at the origin. -/
theorem eval_zero_cubicCoefficients_of_bidegree23
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (i : Fin 10) :
    eval (0 : Fin 3 → R) (cubicCoefficients F i) = 0 := by
  have h := cubicCoefficients_isHomogeneous_of_bidegree23 hF i
  have hpos : (0 : ℕ) < 2 := by norm_num
  rw [eval_zero, constantCoeff_eq]
  exact h.coeff_eq_zero (by exact hpos.ne)

theorem eval_zero_residualCoeffU_of_bidegree23
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) :
    eval (0 : Fin 3 → R) (residualCoeffU_of F) = 0 := by
  rw [residualCoeffU_of, eval_residualCoeffU_poly]
  have hc (i : Fin 10) :
      eval (0 : Fin 3 → R) (cubicCoefficients F i) = 0 :=
    eval_zero_cubicCoefficients_of_bidegree23 hF i
  simp only [hc, residualCoeffU]
  ring

theorem eval_zero_residualCoeffV_of_bidegree23
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) :
    eval (0 : Fin 3 → R) (residualCoeffV_of F) = 0 := by
  rw [residualCoeffV_of, eval_residualCoeffV_poly]
  have hc (i : Fin 10) :
      eval (0 : Fin 3 → R) (cubicCoefficients F i) = 0 :=
    eval_zero_cubicCoefficients_of_bidegree23 hF i
  simp only [hc, residualCoeffV]
  ring

theorem eval_zero_residualCoeffW_of_bidegree23
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) :
    eval (0 : Fin 3 → R) (residualCoeffW_of F) = 0 := by
  rw [residualCoeffW_of, eval_residualCoeffW_poly]
  have hc (i : Fin 10) :
      eval (0 : Fin 3 → R) (cubicCoefficients F i) = 0 :=
    eval_zero_cubicCoefficients_of_bidegree23 hF i
  simp only [hc, residualCoeffW]
  ring

theorem eval_zero_residualLinearForm_of_bidegree23
    {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (y : Fin 3 → R) :
    eval (0 : Fin 3 → R) (residualLinearForm F y) = 0 := by
  rw [eval_residualLinearForm,
    eval_zero_residualCoeffU_of_bidegree23 hF,
    eval_zero_residualCoeffV_of_bidegree23 hF,
    eval_zero_residualCoeffW_of_bidegree23 hF]
  ring

/-- On a smooth nonzero bidegree-`(2,3)` threefold, every normalized base point admits a residual
image first-block lift. -/
theorem exists_residualImage_firstCoordinates_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (j : Fin 3) (y : Fin 3 → K) (hyj : y j = 1) :
    ∃ x : Fin 3 → K, x ≠ 0 ∧
      eval (Sum.elim x y) F = 0 ∧
      eval (Sum.elim x y) (residualEquation F) = 0 := by
  have hC0 :
      specializeSecondCoordinates (m := 2) y F ≠ 0 :=
    not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23 K F hF hF0 j y hyj
  have hChom :
      (specializeSecondCoordinates (m := 2) y F).IsHomogeneous 2 :=
    hF.specializeSecondCoordinates_isHomogeneous y
  set C := specializeSecondCoordinates (m := 2) y F with hCdef
  set L := residualLinearForm F y with hLdef
  have hC0' : eval (0 : Fin 3 → K) C = 0 := by
    have hpos : (0 : ℕ) < 2 := by norm_num
    dsimp [C]
    rw [eval_zero, constantCoeff_eq]
    exact hChom.coeff_eq_zero (by exact hpos.ne)
  have hL0' : eval (0 : Fin 3 → K) L = 0 :=
    eval_zero_residualLinearForm_of_bidegree23 hF y
  by_cases hL0 : L = 0
  · obtain ⟨x, hx, hxC⟩ := exists_nonzero_zero_of_isHomogeneous
      hChom (by norm_num : (0 : ℕ) < 2)
      (by simp [Nat.card_eq_fintype_card, Fintype.card_fin] : 1 < Nat.card (Fin 3))
    refine ⟨x, hx, ?_, ?_⟩
    · rwa [← eval_specializeSecondCoordinates]
    · rw [eval_residualEquation_eq_eval_residualLinearForm, ← hLdef, hL0, map_zero]
  · -- Both C and L vanish at 0; card {C,L} = 2 < 3.
    obtain ⟨x, hx, hxC, hxL⟩ := exists_common_nonzero_zero_pair_of_eval_zero
      C L hC0' hL0'
      (by simp [Nat.card_eq_fintype_card, Fintype.card_fin] : 3 ≤ Nat.card (Fin 3))
    refine ⟨x, hx, ?_, ?_⟩
    · rwa [← eval_specializeSecondCoordinates]
    · rwa [eval_residualEquation_eq_eval_residualLinearForm, ← hLdef]

/-- Normalized residual-image lift of a closed base point. -/
theorem exists_normalized_residualImage_lift_of_closedPoint
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (y : ProjectiveSpace 2 K) (hy : IsClosed {y}) :
    ∃ (i j : Fin 3) (x yCoords : Fin 3 → K) (hyj : y ∈ standardChart 2 K j),
      x i = 1 ∧ yCoords j = 1 ∧
        yCoords = closedPointNormalizedCoordinates 2 K y hy j hyj ∧
        IsResidualImagePoint F x yCoords := by
  obtain ⟨j, hyj⟩ := exists_mem_standardChart 2 K y
  let yCoords := closedPointNormalizedCoordinates 2 K y hy j hyj
  have hyj1 : yCoords j = 1 := closedPointNormalizedCoordinates_self 2 K y hy j hyj
  obtain ⟨x0, hx0, hxF, hxR⟩ :=
    exists_residualImage_firstCoordinates_of_smooth_bidegree23 K F hF hF0 j yCoords hyj1
  obtain ⟨i, hxi0⟩ := exists_normalizing_coordinate x0 hx0
  let x := normalizeCoordinateRepresentative x0 i
  have hxi1 : x i = 1 := normalizeCoordinateRepresentative_apply x0 i hxi0
  have hxF' : eval (Sum.elim x yCoords) F = 0 :=
    eval_normalize_first_eq_zero_of_isBihomogeneous hF x0 yCoords i hxF
  have hxR' : eval (Sum.elim x yCoords) (residualEquation F) = 0 :=
    eval_residualEquation_normalize_eq_zero_of_bidegree23 hF x0 yCoords i hxR
  exact ⟨i, j, x, yCoords, hyj, hxi1, hyj1, rfl, ⟨hxF', hxR'⟩⟩

/-! ### Properness -/

instance residualImageToBase_isProper
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    IsProper (residualImageToBase F) := by
  dsimp [residualImageToBase]
  infer_instance

instance residualMultisection_toBase_isProper
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    IsProper (residualMultisection F).toBase :=
  residualImageToBase_isProper F

/-! ### Scheme-level residual-image points and surjectivity of `toBase` -/

/-- Vanishing of a biprojective equation at a normalized coordinate tuple puts the ambient chart
evaluation point in the zero locus of that equation. -/
theorem biprojectiveZeroLocusIdeal_le_biprojectiveChartPoint_ker
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : eval (Sum.elim x y) F = 0) :
    biprojectiveZeroLocusIdeal m n R F ≤
      (biprojectiveChartPointOfNormalized m n R i j x y ≫
        standardChartι m n R i j).ker := by
  -- The ambient chart point factors through the chartwise zero locus of `F`.
  have hfac :=
    chartZeroLocusPointOfNormalized_subschemeι m n R i j x y hxi hyj F hF
  -- Global ideal ≤ chart ideal pushed to ambient.
  have hchart_le :
      biprojectiveZeroLocusIdeal m n R F ≤
        (chartIdealSheaf m n R i j F).map (standardChartι m n R i j) :=
    iInf_le _ (i, j)
  -- Chart ideal pushforward is the kernel of the chart immersion into ambient.
  have hker_chart :
      (chartIdealSheaf m n R i j F).map (standardChartι m n R i j) =
        ((chartIdealSheaf m n R i j F).subschemeι ≫
          standardChartι m n R i j).ker := by
    rw [Scheme.Hom.ker_comp, Scheme.IdealSheafData.ker_subschemeι]
  -- The chart immersion kernel is contained in the ambient evaluation kernel.
  have hle_amb :
      ((chartIdealSheaf m n R i j F).subschemeι ≫ standardChartι m n R i j).ker ≤
        (biprojectiveChartPointOfNormalized m n R i j x y ≫
          standardChartι m n R i j).ker := by
    rw [← hfac]
    exact Scheme.Hom.le_ker_comp _ _
  exact hchart_le.trans (hker_chart.le.trans hle_amb)

/-- Common vanishing of `F` and its residual equation puts the ambient chart evaluation point on
the residual image. -/
theorem residualImageIdeal_le_biprojectiveChartPoint_ker
    {R : Type u} [CommRing R]
    (i j : Fin 3) (x y : Fin 3 → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hF : eval (Sum.elim x y) F = 0)
    (hR : eval (Sum.elim x y) (residualEquation F) = 0) :
    residualImageIdeal F ≤
      (biprojectiveChartPointOfNormalized 2 2 R i j x y ≫
        standardChartι 2 2 R i j).ker := by
  refine sup_le ?_ ?_
  · exact biprojectiveZeroLocusIdeal_le_biprojectiveChartPoint_ker
      2 2 R i j x y hxi hyj F hF
  · exact biprojectiveZeroLocusIdeal_le_biprojectiveChartPoint_ker
      2 2 R i j x y hxi hyj (residualEquation F) hR

/-- Spec-point of the residual image attached to a normalized residual-image coordinate tuple. -/
def residualImagePointOfNormalized
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (i j : Fin 3) (x y : Fin 3 → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : eval (Sum.elim x y) F = 0)
    (hR : eval (Sum.elim x y) (residualEquation F) = 0) :
    Spec (.of R) ⟶ residualImage F :=
  IsClosedImmersion.lift
    (residualImageι F)
    (biprojectiveChartPointOfNormalized 2 2 R i j x y ≫ standardChartι 2 2 R i j)
    (by
      rw [ker_residualImageι]
      exact residualImageIdeal_le_biprojectiveChartPoint_ker i j x y hxi hyj F hF hR)

@[reassoc (attr := simp)]
theorem residualImagePointOfNormalized_ι
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (i j : Fin 3) (x y : Fin 3 → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : eval (Sum.elim x y) F = 0)
    (hR : eval (Sum.elim x y) (residualEquation F) = 0) :
    residualImagePointOfNormalized F i j x y hxi hyj hF hR ≫ residualImageι F =
      biprojectiveChartPointOfNormalized 2 2 R i j x y ≫ standardChartι 2 2 R i j :=
  IsClosedImmersion.lift_fac _ _ _

theorem residualImagePointOfNormalized_toBase
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (i j : Fin 3) (x y : Fin 3 → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : eval (Sum.elim x y) F = 0)
    (hR : eval (Sum.elim x y) (residualEquation F) = 0) :
    residualImagePointOfNormalized F i j x y hxi hyj hF hR ≫ residualImageToBase F =
      pointOfNormalizedCoordinates 2 R j y hyj := by
  unfold residualImageToBase
  rw [← Category.assoc, residualImagePointOfNormalized_ι]
  exact biprojectiveChartPointOfNormalized_comp_standardChartι_snd 2 2 R i j x y hyj

/-- Residual-image points of normalized coordinates are sections of the structure map to
`Spec R` (i.e. genuine `R`-points of residual image). -/
theorem residualImagePointOfNormalized_toSpec
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (i j : Fin 3) (x y : Fin 3 → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : eval (Sum.elim x y) F = 0)
    (hR : eval (Sum.elim x y) (residualEquation F) = 0) :
    residualImagePointOfNormalized F i j x y hxi hyj hF hR ≫ residualImageToSpec F =
      𝟙 (Spec (.of R)) := by
  have hbase := residualImagePointOfNormalized_toBase F i j x y hxi hyj hF hR
  have hyspec := pointOfNormalizedCoordinates_toSpec 2 R j y hyj
  have hdef : residualImageToSpec F =
      residualImageToBase F ≫ ProjectiveSpace.toSpec 2 R := by
    dsimp only [residualImageToSpec, residualImageToBase]
    rw [Category.assoc, BiprojectiveSpace.snd_toSpec]
  rw [hdef, ← Category.assoc, hbase, hyspec]

/-- Every closed point of the conic base lifts through the residual multisection base map. -/
theorem closedPoint_mem_range_residualImageToBase
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (y : ProjectiveSpace 2 K) (hy : IsClosed {y}) :
    y ∈ Set.range (residualImageToBase F) := by
  obtain ⟨i, j, x, yCoords, hyj, hxi, hyj1, hyCoords, hres⟩ :=
    exists_normalized_residualImage_lift_of_closedPoint K F hF hF0 y hy
  obtain ⟨hxF, hxR⟩ := hres
  let pt := residualImagePointOfNormalized F i j x yCoords hxi hyj1 hxF hxR
  refine ⟨pt (IsLocalRing.closedPoint K), ?_⟩
  have hcomp := residualImagePointOfNormalized_toBase F i j x yCoords hxi hyj1 hxF hxR
  have hy_pt :
      pointOfNormalizedCoordinates 2 K j yCoords hyj1
        (IsLocalRing.closedPoint K) = y := by
    subst hyCoords
    exact closedPoint_eq_pointOfNormalizedCoordinates_apply 2 K y hy j hyj
  exact
    (congrArg (fun f : Spec (.of K) ⟶ ProjectiveSpace 2 K =>
        f (IsLocalRing.closedPoint K)) hcomp).trans hy_pt

/-- Surjectivity of the residual multisection base map over a smooth nonzero bidegree-`(2,3)`
threefold (proper + Jacobson + closed-point lifts). -/
theorem surjective_residualImageToBase_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    Surjective (residualImageToBase F) :=
  Surjective.of_isProper_of_closedPoints _ fun y hy =>
    closedPoint_mem_range_residualImageToBase K F hF hF0 y hy

theorem isDominant_residualImageToBase_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    IsDominant (residualImageToBase F) := by
  haveI : Surjective (residualImageToBase F) :=
    surjective_residualImageToBase_of_smooth_bidegree23 K F hF hF0
  infer_instance

theorem surjective_residualMultisection_toBase_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    Surjective (residualMultisection F).toBase :=
  surjective_residualImageToBase_of_smooth_bidegree23 K F hF hF0

theorem isDominant_residualMultisection_toBase_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    IsDominant (residualMultisection F).toBase :=
  isDominant_residualImageToBase_of_smooth_bidegree23 K F hF hF0

/-- Standard chart rings of projective space over a reduced base are reduced
(they inject into a localization of a polynomial ring). -/
instance standardChartRing_isReduced
    (n : ℕ) (R : Type u) [CommRing R] [IsReduced R] (i : Fin (n + 1)) :
    IsReduced (ProjectiveSpace.StandardChartRing n R i) where
  eq_zero x hx := by
    classical
    let 𝒜 := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R
    let M : Submonoid (MvPolynomial (Fin (n + 1)) R) := .powers (MvPolynomial.X i)
    have hval_pow (k : ℕ) (z : HomogeneousLocalization 𝒜 M) :
        HomogeneousLocalization.val (z ^ k) =
          HomogeneousLocalization.val z ^ k := by
      induction k with
      | zero => simp [HomogeneousLocalization.val_one]
      | succ k ih =>
          rw [pow_succ, HomogeneousLocalization.val_mul, ih, pow_succ]
    apply HomogeneousLocalization.val_injective M
    rw [HomogeneousLocalization.val_zero]
    haveI : IsReduced (Localization M) := inferInstance
    refine IsReduced.eq_zero (HomogeneousLocalization.val x) ?_
    obtain ⟨k, hk⟩ := hx
    refine ⟨k, ?_⟩
    rw [← hval_pow, hk, HomogeneousLocalization.val_zero]

/-- Projective space over a reduced ring is reduced (affine standard-chart cover). -/
instance projectiveSpace_isReduced
    (n : ℕ) (R : Type u) [CommRing R] [IsReduced R] :
    IsReduced (ProjectiveSpace n R) := by
  haveI (i : Fin (n + 1)) :
      IsReduced ((ProjectiveSpace.standardAffineOpenCover n R).openCover.X i) := by
    change IsReduced (Spec (.of (ProjectiveSpace.StandardChartRing n R i)))
    infer_instance
  exact IsReduced.of_openCover (ProjectiveSpace n R)
    (ProjectiveSpace.standardAffineOpenCover n R).openCover

/-- Residual multisection is scheme-theoretically horizontal over a smooth nonzero bidegree-`(2,3)`
threefold (dominant + quasi-compact over reduced base). -/
theorem residualMultisection_isSchemeTheoreticallyHorizontal_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    (residualMultisection F).IsSchemeTheoreticallyHorizontal := by
  haveI : IsDominant (residualMultisection F).toBase :=
    isDominant_residualMultisection_toBase_of_smooth_bidegree23 K F hF hF0
  exact residualMultisection_isSchemeTheoreticallyHorizontal_of_isDominant F

/-- Surjectivity of the residual multisection base-change projection `X_T → X` (base change of a
surjective multisection base map). -/
theorem surjective_residualMultisection_baseChangeFst_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    Surjective (residualMultisection F).baseChangeFst := by
  haveI : Surjective (residualImageToBase F) :=
    surjective_residualImageToBase_of_smooth_bidegree23 K F hF hF0
  -- `baseChangeFst = pullback.fst π toBase`, surjective by base change of surjections.
  change Surjective
    (Limits.pullback.fst (biprojectiveZeroLocusSnd 2 2 K F) (residualImageToBase F))
  infer_instance

theorem isDominant_residualMultisection_baseChangeFst_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    IsDominant (residualMultisection F).baseChangeFst := by
  haveI : Surjective (residualMultisection F).baseChangeFst :=
    surjective_residualMultisection_baseChangeFst_of_smooth_bidegree23 K F hF hF0
  infer_instance

/-- Residual multisection package: proper/surjective base map, residual lifts, and dominant
base-change projection. -/
theorem residual_multisection_poly_package_summary
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    IsProper (residualMultisection F).toBase ∧
      Surjective (residualMultisection F).toBase ∧
      IsDominant (residualMultisection F).baseChangeFst ∧
      (∀ (j : Fin 3) (y : Fin 3 → K), y j = 1 →
        ∃ x : Fin 3 → K, x ≠ 0 ∧ IsResidualImagePoint F x y) ∧
      (∀ (y : ProjectiveSpace 2 K), IsClosed {y} →
        ∃ (i j : Fin 3) (x yCoords : Fin 3 → K) (_hyj : y ∈ standardChart 2 K j),
          x i = 1 ∧ yCoords j = 1 ∧ IsResidualImagePoint F x yCoords) := by
  refine ⟨inferInstance, ?_, ?_, ?_, ?_⟩
  · exact surjective_residualMultisection_toBase_of_smooth_bidegree23 K F hF hF0
  · exact isDominant_residualMultisection_baseChangeFst_of_smooth_bidegree23 K F hF hF0
  · intro j y hy
    obtain ⟨x, hx, hxF, hxR⟩ :=
      exists_residualImage_firstCoordinates_of_smooth_bidegree23 K F hF hF0 j y hy
    exact ⟨x, hx, ⟨hxF, hxR⟩⟩
  · intro y hy
    obtain ⟨i, j, x, yCoords, hyj, hxi, hyj1, _, hres⟩ :=
      exists_normalized_residualImage_lift_of_closedPoint K F hF hF0 y hy
    exact ⟨i, j, x, yCoords, hyj, hxi, hyj1, hres⟩

end

end BConicBundleMultisections
