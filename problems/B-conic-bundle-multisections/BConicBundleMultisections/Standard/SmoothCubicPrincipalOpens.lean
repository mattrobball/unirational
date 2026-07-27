/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.TangentResidualAvoidance
public import BConicBundleMultisections.TernaryQuadraticGradient
public import BConicBundleMultisections.TsenConic
public import BConicBundleMultisections.HomogeneousFactor
public import Mathlib.RingTheory.Nullstellensatz

/-!
# Principal opens on a smooth plane cubic

This file supplies the elementary algebraic replacement for using the scheme morphism
`[-2] : C → C` merely to intersect two nonempty opens.  A smooth homogeneous ternary cubic is
irreducible: in a nontrivial factorization its factors have degrees one and two, and a line and a
conic in the projective plane over an algebraically closed field have a common point, which would
be singular on their product.  Consequently its principal ideal is prime, and affine
Nullstellensatz shows that finitely many nonempty positive-degree homogeneous principal opens on
the cubic meet.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

open MvPolynomial
open _root_.MvPolynomial

universe u

variable {K : Type u} [Field K]

/-! ## A line and a conic in the projective plane meet -/

/-- A nonzero linear form on `K³` has two linearly independent zeros. -/
theorem exists_linearIndependent_pair_eval_eq_zero_of_isHomogeneous_one
    (L : MvPolynomial (Fin 3) K) (hL : L.IsHomogeneous 1) (hL0 : L ≠ 0) :
    ∃ p q : Fin 3 → K,
      LinearIndependent K ![p, q] ∧ eval p L = 0 ∧ eval q L = 0 := by
  obtain ⟨c, rfl⟩ :=
    TernaryQuadratic.eq_sum_C_mul_X_of_isHomogeneous_one L hL
  let φ : (Fin 3 → K) →ₗ[K] K := TernaryQuadratic.linearFormMap c
  have hc0 : c ≠ 0 := by
    intro hc
    apply hL0
    simp [hc]
  have hφ : φ ≠ 0 := by
    intro hzero
    apply hc0
    funext i
    have hi := congrArg (fun f : (Fin 3 → K) →ₗ[K] K ↦ f (Pi.single i 1)) hzero
    fin_cases i <;>
      simpa [φ, TernaryQuadratic.linearFormMap, Fin.sum_univ_three] using hi
  have hfin : Module.finrank K (LinearMap.ker φ) = 2 := by
    have h := Module.Dual.finrank_ker_add_one_of_ne_zero hφ
    have hV : Module.finrank K (Fin 3 → K) = 3 := Module.finrank_fintype_fun_eq_card K
    omega
  have hker : LinearMap.ker φ ≠ ⊥ := by
    intro hbot
    rw [hbot, finrank_bot] at hfin
    omega
  obtain ⟨p, hpker, hp0⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hker
  let pker : LinearMap.ker φ := ⟨p, hpker⟩
  have hpker0 : pker ≠ 0 := by
    intro hp
    exact hp0 (congrArg Subtype.val hp)
  have hlt :
      Module.finrank K (K ∙ pker) < Module.finrank K (LinearMap.ker φ) := by
    rw [finrank_span_singleton hpker0, hfin]
    norm_num
  obtain ⟨qker, hqker⟩ :=
    Submodule.exists_of_finrank_lt (K ∙ pker) hlt
  let q : Fin 3 → K := qker
  have hpq : LinearIndependent K ![p, q] := by
    rw [LinearIndependent.pair_iff]
    intro a b hab
    have habker : a • pker + b • qker = 0 :=
      Subtype.ext (by simpa [pker, q] using hab)
    by_cases hb : b = 0
    · subst hb
      simp only [zero_smul, add_zero] at habker
      have ha : a = 0 := by
        have hval := congrArg Subtype.val habker
        change a • p = 0 at hval
        exact (smul_eq_zero.mp hval).resolve_right hp0
      exact ⟨ha, rfl⟩
    · have hba : b • qker = -(a • pker) :=
        eq_neg_of_add_eq_zero_right habker
      have hmem : qker ∈ K ∙ pker := by
        have hsol : qker = (b⁻¹ * -a) • pker := by
          apply (smul_right_injective (LinearMap.ker φ) hb).eq_iff.1
          calc
            b • qker = -(a • pker) := hba
            _ = (-a) • pker := by rw [neg_smul]
            _ = (b * (b⁻¹ * -a)) • pker := by field_simp [hb]
            _ = b • ((b⁻¹ * -a) • pker) := by rw [smul_smul]
        rw [hsol]
        exact Submodule.smul_mem _ _ (Submodule.mem_span_singleton_self _)
      exact absurd (by simpa using hmem) (hqker (1 : K) one_ne_zero)
  refine ⟨p, q, hpq, ?_, ?_⟩
  · rw [TernaryQuadratic.eval_sum_C_mul_X]
    exact LinearMap.mem_ker.mp hpker
  · rw [TernaryQuadratic.eval_sum_C_mul_X]
    exact LinearMap.mem_ker.mp qker.property

/-- A nonzero projective line and a projective conic meet over an algebraically closed field. -/
theorem exists_common_projective_zero_of_homogeneous_one_two [IsAlgClosed K]
    (L Q : MvPolynomial (Fin 3) K)
    (hL : L.IsHomogeneous 1) (hQ : Q.IsHomogeneous 2) (hL0 : L ≠ 0) :
    ∃ v : Fin 3 → K, v ≠ 0 ∧ eval v L = 0 ∧ eval v Q = 0 := by
  obtain ⟨p, q, hpq, hpL, hqL⟩ :=
    exists_linearIndependent_pair_eval_eq_zero_of_isHomogeneous_one L hL hL0
  let B : MvPolynomial (Fin 2) K := binaryLineRestriction p q Q
  have hB : B.IsHomogeneous 2 := binaryLineRestriction_isHomogeneous hQ p q
  obtain ⟨z, hz0, hzB⟩ :=
    exists_nonzero_zero_binary_homogeneous B (by norm_num) hB
  let v : Fin 3 → K := binarySpanLinearMap p q z
  have hv0 : v ≠ 0 :=
    binarySpanLinearMap_ne_zero_of_linearIndependent hpq hz0
  refine ⟨v, hv0, ?_, ?_⟩
  · have hline : binaryLineRestriction p q L = 0 := by
      obtain ⟨c, hLc⟩ :=
        TernaryQuadratic.eq_sum_C_mul_X_of_isHomogeneous_one L hL
      have hpL' : ∑ i : Fin 3, c i * p i = 0 := by
        rw [← TernaryQuadratic.eval_sum_C_mul_X, ← hLc]
        exact hpL
      have hqL' : ∑ i : Fin 3, c i * q i = 0 := by
        rw [← TernaryQuadratic.eval_sum_C_mul_X, ← hLc]
        exact hqL
      apply MvPolynomial.funext
      intro z'
      change eval z' (binaryLineRestriction p q L) = 0
      rw [eval_binaryLineRestriction]
      rw [hLc, TernaryQuadratic.eval_sum_C_mul_X]
      simp only [Fin.sum_univ_three] at hpL' hqL' ⊢
      linear_combination (z' 0) * hpL' + (z' 1) * hqL'
    rw [eval_binarySpanLinearMap_eq_eval_binaryLineRestriction, hline, map_zero]
  · rw [eval_binarySpanLinearMap_eq_eval_binaryLineRestriction]
    exact hzB

/-- A product of a nonzero homogeneous line and a homogeneous conic is singular. -/
theorem exists_singular_point_of_mul_homogeneous_one_two [IsAlgClosed K]
    (L Q : MvPolynomial (Fin 3) K)
    (hL : L.IsHomogeneous 1) (hQ : Q.IsHomogeneous 2)
    (hL0 : L ≠ 0) :
    ∃ v : Fin 3 → K, v ≠ 0 ∧
      eval v (L * Q) = 0 ∧ ∀ i, eval v (pderiv i (L * Q)) = 0 := by
  obtain ⟨v, hv0, hvL, hvQ⟩ :=
    exists_common_projective_zero_of_homogeneous_one_two L Q hL hQ hL0
  refine ⟨v, hv0, ?_, fun i ↦ ?_⟩
  · rw [eval_mul, hvL, zero_mul]
  · rw [pderiv_mul, map_add, eval_mul, eval_mul, hvL, hvQ]
    ring

/-! ## Smooth cubics are irreducible -/

/-- A nonzero homogeneous polynomial of degree zero over a field is a unit. -/
theorem isUnit_of_isHomogeneous_zero
    {f : MvPolynomial (Fin 3) K} (hf : f.IsHomogeneous 0) (hf0 : f ≠ 0) :
    IsUnit f := by
  exact TernaryQuadratic.isUnit_of_totalDegree_eq_zero (hf.totalDegree hf0) hf0

/-- A smooth homogeneous ternary cubic over an algebraically closed field is irreducible. -/
theorem irreducible_of_isSmoothPlaneCubic [IsAlgClosed K]
    (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g) :
    Irreducible g := by
  have hg0 : g ≠ 0 := by
    intro hg
    have hsing := hsmooth.2 ![1, 0, 0] (by simp) (by simp [hg])
    obtain ⟨i, hi⟩ := hsing
    simp [hg] at hi
  refine (irreducible_iff).mpr ⟨?_, ?_⟩
  · intro hunit
    have hdeg0 := (MvPolynomial.isUnit_iff_totalDegree_of_isReduced.mp hunit).2
    have hdeg3 := hsmooth.1.totalDegree hg0
    omega
  · intro a b hab
    by_cases ha0 : a = 0
    · subst a
      simp only [zero_mul] at hab
      exact absurd hab hg0
    by_cases hb0 : b = 0
    · subst b
      simp only [mul_zero] at hab
      exact absurd hab hg0
    have hproduct : (a * b).IsHomogeneous 3 := by
      rw [← hab]
      exact hsmooth.1
    obtain ⟨da, db, haHom, hbHom, hd⟩ :=
      MvPolynomial.exists_isHomogeneous_of_mul_isHomogeneous ha0 hb0 hproduct
    by_cases hda : da = 0
    · exact Or.inl (isUnit_of_isHomogeneous_zero (hda ▸ haHom) ha0)
    by_cases hdb : db = 0
    · exact Or.inr (isUnit_of_isHomogeneous_zero (hdb ▸ hbHom) hb0)
    have hdegrees : (da = 1 ∧ db = 2) ∨ (da = 2 ∧ db = 1) := by omega
    rcases hdegrees with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    · obtain ⟨v, hv0, hprod0, hgrad0⟩ :=
        exists_singular_point_of_mul_homogeneous_one_two a b haHom hbHom ha0
      rw [← hab] at hprod0 hgrad0
      obtain ⟨i, hi⟩ := hsmooth.2 v hv0 hprod0
      exact absurd (hgrad0 i) hi
    · obtain ⟨v, hv0, hprod0, hgrad0⟩ :=
        exists_singular_point_of_mul_homogeneous_one_two b a hbHom haHom hb0
      rw [mul_comm, ← hab] at hprod0 hgrad0
      obtain ⟨i, hi⟩ := hsmooth.2 v hv0 hprod0
      exact absurd (hgrad0 i) hi

/-- The principal ideal of a smooth plane cubic is prime. -/
theorem isPrime_span_singleton_of_isSmoothPlaneCubic [IsAlgClosed K]
    (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g) :
    (Ideal.span ({g} : Set (MvPolynomial (Fin 3) K))).IsPrime := by
  have hirr := irreducible_of_isSmoothPlaneCubic g hsmooth
  exact (Ideal.span_singleton_prime hirr.ne_zero).mpr hirr.prime

/-! ## Intersecting principal opens -/

/-- Two nonempty positive-degree homogeneous principal opens on a smooth cubic meet. -/
theorem exists_projective_point_off_two_targets_of_isSmoothPlaneCubic [IsAlgClosed K]
    (g H₁ H₂ : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g)
    {d₁ d₂ : ℕ} (hH₁ : H₁.IsHomogeneous d₁) (hH₂ : H₂.IsHomogeneous d₂)
    (hd₁ : 0 < d₁) (hd₂ : 0 < d₂)
    (h₁ : ∃ x : Fin 3 → K, x ≠ 0 ∧ eval x g = 0 ∧ eval x H₁ ≠ 0)
    (h₂ : ∃ x : Fin 3 → K, x ≠ 0 ∧ eval x g = 0 ∧ eval x H₂ ≠ 0) :
    ∃ x : Fin 3 → K, x ≠ 0 ∧ eval x g = 0 ∧
      eval x H₁ ≠ 0 ∧ eval x H₂ ≠ 0 := by
  let I : Ideal (MvPolynomial (Fin 3) K) := Ideal.span ({g} : Set _)
  have hprime : I.IsPrime := isPrime_span_singleton_of_isSmoothPlaneCubic g hsmooth
  have hH₁not : H₁ ∉ I := by
    rintro hmem
    obtain ⟨x, _hx0, hxg, hxH₁⟩ := h₁
    obtain ⟨a, ha⟩ := Ideal.mem_span_singleton.mp hmem
    apply hxH₁
    rw [ha, eval_mul, hxg, zero_mul]
  have hH₂not : H₂ ∉ I := by
    rintro hmem
    obtain ⟨x, _hx0, hxg, hxH₂⟩ := h₂
    obtain ⟨a, ha⟩ := Ideal.mem_span_singleton.mp hmem
    apply hxH₂
    rw [ha, eval_mul, hxg, zero_mul]
  have hprodNot : H₁ * H₂ ∉ I := by
    intro hmem
    exact (hprime.mem_or_mem hmem).elim hH₁not hH₂not
  have hprodNotRad : H₁ * H₂ ∉ I.radical := by
    simpa [hprime.radical] using hprodNot
  have hexists : ∃ x : Fin 3 → K, x ≠ 0 ∧ eval x g = 0 ∧
      eval x (H₁ * H₂) ≠ 0 := by
    by_contra hex
    apply hprodNotRad
    rw [← MvPolynomial.vanishingIdeal_zeroLocus_eq_radical (K := K)]
    rw [MvPolynomial.mem_vanishingIdeal_iff]
    intro x hx
    rw [MvPolynomial.mem_zeroLocus_iff] at hx
    have hxg : eval x g = 0 := hx g (Ideal.subset_span (by simp))
    by_cases hx0 : x = 0
    · subst x
      have hhom := hH₁.mul hH₂
      have hscale := eval_smul_point_of_isHomogeneous hhom (0 : K) (0 : Fin 3 → K)
      simpa [zero_pow (by omega : d₁ + d₂ ≠ 0)] using hscale
    · by_contra hxprod
      exact hex ⟨x, hx0, hxg, hxprod⟩
  obtain ⟨x, hx0, hxg, hxprod⟩ := hexists
  rw [eval_mul, mul_ne_zero_iff] at hxprod
  exact ⟨x, hx0, hxg, hxprod.1, hxprod.2⟩

/-! ## Polynomial charts for the tangent-residual map -/

/-- On the chart `p i ≠ 0`, cross the gradient with the `i`-th coordinate vector to obtain a
polynomial tangent direction. -/
def chartTangentDir (i : Fin 3) (g : MvPolynomial (Fin 3) K) (p : Fin 3 → K) :
    Fin 3 → K :=
  cross3 (Pi.single i 1) (tangentGradient g p)

/-- The symbolic chart tangent direction, as three quadratic polynomials in the base point. -/
def chartTangentDirPolynomial (i : Fin 3) (g : MvPolynomial (Fin 3) K) :
    Fin 3 → MvPolynomial (Fin 3) K :=
  cross3 (Pi.single i 1) (fun j ↦ pderiv j g)

/-- The symbolic tangent-residual representative on a coordinate chart.

For a cubic `g`, `alpha = -g(q)` and
`beta = ∑_j X_j (∂_j g)(q)` are the two residual binary coefficients.  Thus
`alpha * X + beta * q` is exactly `residualAmbientRep`; both summands have degree seven in the
base point. -/
def chartTangentResidualPolynomial (i : Fin 3) (g : MvPolynomial (Fin 3) K) :
    Fin 3 → MvPolynomial (Fin 3) K :=
  let q := chartTangentDirPolynomial i g
  let alpha := -aeval q g
  let beta := ∑ j : Fin 3, X j * aeval q (pderiv j g)
  fun j ↦ alpha * X j + beta * q j

/-- Pull a homogeneous target back along the chart tangent-residual representative. -/
def chartTangentResidualPullback (i : Fin 3)
    (g H : MvPolynomial (Fin 3) K) : MvPolynomial (Fin 3) K :=
  aeval (chartTangentResidualPolynomial i g) H

@[simp]
theorem chartTangentDir_apply_self
    (i : Fin 3) (g : MvPolynomial (Fin 3) K) (p : Fin 3 → K) :
    chartTangentDir i g p i = 0 := by
  fin_cases i <;> simp [chartTangentDir, cross3]

/-- Evaluating the symbolic direction gives the pointwise chart direction. -/
theorem eval_chartTangentDirPolynomial
    (i j : Fin 3) (g : MvPolynomial (Fin 3) K) (p : Fin 3 → K) :
    eval p (chartTangentDirPolynomial i g j) = chartTangentDir i g p j := by
  fin_cases i <;> fin_cases j <;>
    simp [chartTangentDirPolynomial, chartTangentDir, cross3, tangentGradient]

/-- The symbolic chart direction is homogeneous quadratic for a cubic equation. -/
theorem chartTangentDirPolynomial_isHomogeneous
    (i j : Fin 3) (g : MvPolynomial (Fin 3) K) (hg : g.IsHomogeneous 3) :
    (chartTangentDirPolynomial i g j).IsHomogeneous 2 := by
  have hderiv (a : Fin 3) : (pderiv a g).IsHomogeneous 2 := by
    simpa using hg.pderiv (i := a)
  fin_cases i <;> fin_cases j <;>
    simp [chartTangentDirPolynomial, cross3] <;>
    first
    | exact isHomogeneous_zero (R := K) (σ := Fin 3) 2
    | exact (hderiv _).neg
    | exact hderiv _

/-- Evaluating the symbolic residual triple gives the ordinary binary-line residual
representative. -/
theorem eval_chartTangentResidualPolynomial
    (i : Fin 3) (g : MvPolynomial (Fin 3) K) (hg : g.IsHomogeneous 3)
    (p : Fin 3 → K) :
    (fun j ↦ eval p (chartTangentResidualPolynomial i g j)) =
      residualAmbientRep p (chartTangentDir i g p)
        (binaryLineRestriction p (chartTangentDir i g p) g) := by
  let qP := chartTangentDirPolynomial i g
  let q := chartTangentDir i g p
  let f := binaryLineRestriction p q g
  have hqeval : (fun j ↦ eval p (qP j)) = q := by
    funext j
    exact eval_chartTangentDirPolynomial i j g p
  have halpha : residualBinaryRep f 0 = -eval q g := by
    simp only [residualBinaryRep, Matrix.cons_val_zero]
    rw [coeff03_of_binaryLineRestriction g hg p q]
  have hbeta : residualBinaryRep f 1 = ∑ j : Fin 3, p j * eval q (pderiv j g) := by
    have hrep : residualBinaryRep f 1 = coeff (binaryExponent 1 2) f := by
      simp [residualBinaryRep]
    rw [hrep, coeff12_of_binaryLineRestriction g hg p q]
  have hevalA (P : MvPolynomial (Fin 3) K) :
      eval p (aeval qP P) = eval (fun a ↦ eval p (qP a)) P := by
    change aeval p (aeval qP P) = _
    rw [comp_aeval_apply]
    change eval (fun a ↦ eval p (qP a)) P = _
    rfl
  funext j
  simp only [chartTangentResidualPolynomial, eval_add, eval_mul, eval_neg, eval_X]
  rw [hevalA]
  change -(eval (fun a ↦ eval p (qP a)) g) * p j +
      eval p (∑ a : Fin 3, X a * aeval qP (pderiv a g)) * eval p (qP j) = _
  rw [hqeval]
  simp only [map_sum, eval_mul, eval_X]
  simp_rw [hevalA]
  rw [show eval p (qP j) = q j from congrFun hqeval j]
  change -eval q g * p j +
      (∑ a : Fin 3, p a * eval (fun b ↦ eval p (qP b)) (pderiv a g)) * q j = _
  rw [hqeval]
  change -eval q g * p j + (∑ a : Fin 3, p a * eval q (pderiv a g)) * q j =
    residualBinaryRep f 0 * p j + residualBinaryRep f 1 * q j
  rw [halpha, hbeta]

/-- Each coordinate of the chart tangent-residual representative is homogeneous of degree
seven. -/
theorem chartTangentResidualPolynomial_isHomogeneous
    (i j : Fin 3) (g : MvPolynomial (Fin 3) K) (hg : g.IsHomogeneous 3) :
    (chartTangentResidualPolynomial i g j).IsHomogeneous 7 := by
  let q := chartTangentDirPolynomial i g
  have hq (a : Fin 3) : (q a).IsHomogeneous 2 :=
    chartTangentDirPolynomial_isHomogeneous i a g hg
  have halpha : (-aeval q g).IsHomogeneous 6 := by
    have h := IsHomogeneous.aeval (S := K) (τ := Fin 3) (m := 3) (n := 2) hg q hq
    simpa using h.neg
  have hpderiv (a : Fin 3) : (pderiv a g).IsHomogeneous 2 := by
    simpa using hg.pderiv (i := a)
  have hevalDeriv (a : Fin 3) : (aeval q (pderiv a g)).IsHomogeneous 4 := by
    have h := IsHomogeneous.aeval (S := K) (τ := Fin 3) (m := 2) (n := 2)
      (hpderiv a) q hq
    simpa using h
  have hbeta : (∑ a : Fin 3, X a * aeval q (pderiv a g)).IsHomogeneous 5 := by
    apply IsHomogeneous.sum
    intro a _ha
    simpa using (isHomogeneous_X K a).mul (hevalDeriv a)
  exact (halpha.mul (isHomogeneous_X K j)).add (hbeta.mul (hq j))

/-- The pullback of a degree-`d` homogeneous target has degree `7d`. -/
theorem chartTangentResidualPullback_isHomogeneous
    (i : Fin 3) (g H : MvPolynomial (Fin 3) K) (hg : g.IsHomogeneous 3)
    {d : ℕ} (hH : H.IsHomogeneous d) :
    (chartTangentResidualPullback i g H).IsHomogeneous (7 * d) := by
  exact IsHomogeneous.aeval (S := K) (τ := Fin 3) (m := d) (n := 7) hH
    (chartTangentResidualPolynomial i g)
    (fun j ↦ chartTangentResidualPolynomial_isHomogeneous i j g hg)

/-- Evaluation of the pullback is evaluation of the target at the pointwise tangent residual. -/
theorem eval_chartTangentResidualPullback
    (i : Fin 3) (g H : MvPolynomial (Fin 3) K) (hg : g.IsHomogeneous 3)
    (p : Fin 3 → K) :
    eval p (chartTangentResidualPullback i g H) =
      eval
        (residualAmbientRep p (chartTangentDir i g p)
          (binaryLineRestriction p (chartTangentDir i g p) g)) H := by
  rw [chartTangentResidualPullback]
  change aeval p (aeval (chartTangentResidualPolynomial i g) H) = _
  rw [comp_aeval_apply]
  change eval (fun j ↦ eval p (chartTangentResidualPolynomial i g j)) H = _
  rw [eval_chartTangentResidualPolynomial i g hg p]

/-! ## The chart direction spans the tangent line -/

/-- If `e_i × v = 0`, then `v` is supported only in coordinate `i`. -/
theorem eq_smul_single_of_cross3_single_eq_zero
    (i : Fin 3) (v : Fin 3 → K)
    (h : cross3 (Pi.single i 1) v = 0) :
    v = v i • Pi.single i 1 := by
  have h0 := congrFun h (0 : Fin 3)
  have h1 := congrFun h (1 : Fin 3)
  have h2 := congrFun h (2 : Fin 3)
  funext j
  fin_cases i <;> fin_cases j <;>
    simp [cross3, Pi.smul_apply, smul_eq_mul] at h0 h1 h2 ⊢ <;>
    assumption

/-- The chart direction is tangent. -/
theorem chartTangentDir_mem_tangentHyperplaneCone
    (i : Fin 3) (g : MvPolynomial (Fin 3) K) (p : Fin 3 → K) :
    chartTangentDir i g p ∈ tangentHyperplaneCone g p := by
  rw [mem_tangentHyperplaneCone, eval_tangentForm_eq_dotProduct]
  exact dot_cross3_right (Pi.single i 1) (tangentGradient g p)

/-- At a smooth cubic point in the `i`-th coordinate chart, the polynomial chart direction is
nonzero. -/
theorem chartTangentDir_ne_zero_of_isSmoothPlaneCubic
    (i : Fin 3) (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g)
    (p : Fin 3 → K) (hp : eval p g = 0) (hpi : p i ≠ 0) :
    chartTangentDir i g p ≠ 0 := by
  intro hq
  have hgradSupport : tangentGradient g p =
      tangentGradient g p i • Pi.single i 1 :=
    eq_smul_single_of_cross3_single_eq_zero i (tangentGradient g p) hq
  have heuler : tangentGradient g p ⬝ᵥ p = 0 := by
    rw [← eval_tangentForm_eq_dotProduct]
    exact eval_tangentForm_self_eq_zero hsmooth.1 hp
  have hgiMul : tangentGradient g p i * p i = 0 := by
    rw [hgradSupport] at heuler
    simpa [smul_eq_mul] using heuler
  have hgi : tangentGradient g p i = 0 :=
    (mul_eq_zero.mp hgiMul).resolve_right hpi
  have hgrad0 : tangentGradient g p = 0 := by
    rw [hgradSupport, hgi, zero_smul]
  obtain ⟨j, hj⟩ := hsmooth.2 p (fun hp0 ↦ hpi (congrFun hp0 i)) hp
  exact hj (congrFun hgrad0 j)

/-- The base point and chart tangent direction are linearly independent on the chart. -/
theorem linearIndependent_pair_chartTangentDir_of_isSmoothPlaneCubic
    (i : Fin 3) (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g)
    (p : Fin 3 → K) (hp : eval p g = 0) (hpi : p i ≠ 0) :
    LinearIndependent K ![p, chartTangentDir i g p] := by
  let q := chartTangentDir i g p
  have hq0 : q ≠ 0 :=
    chartTangentDir_ne_zero_of_isSmoothPlaneCubic i g hsmooth p hp hpi
  have hqi : q i = 0 := chartTangentDir_apply_self i g p
  rw [LinearIndependent.pair_iff]
  intro a b hab
  have hi := congrFun hab i
  have ha : a = 0 := by
    change a * p i + b * q i = 0 at hi
    rw [hqi, mul_zero, add_zero] at hi
    exact (mul_eq_zero.mp hi).resolve_right hpi
  have hbq : b • q = 0 := by simpa [ha] using hab
  have hb : b = 0 := (smul_eq_zero.mp hbq).resolve_right hq0
  exact ⟨ha, hb⟩

/-- Any complementary tangent direction differs from the chart direction by a nonzero scaling
modulo the base point. -/
theorem exists_chartTangentDir_eq_reparam_of_isSmoothPlaneCubic
    (i : Fin 3) (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g)
    (p q : Fin 3 → K) (hp : eval p g = 0) (hpi : p i ≠ 0)
    (hpq : LinearIndependent K ![p, q])
    (hq : q ∈ tangentHyperplaneCone g p) :
    ∃ alpha beta : K, alpha ≠ 0 ∧
      chartTangentDir i g p = fun j ↦ alpha * q j + beta * p j := by
  let grad := tangentGradient g p
  let phi : Module.Dual K (Fin 3 → K) := coordDual grad
  have hgrad : grad ≠ 0 := by
    intro hzero
    have hp0 : p ≠ 0 := fun hpzero ↦ hpi (congrFun hpzero i)
    obtain ⟨j, hj⟩ := hsmooth.2 p hp0 hp
    exact hj (congrFun hzero j)
  have hphi : phi ≠ 0 := by
    intro hzero
    exact hgrad ((coordDual_eq_zero_iff grad).mp hzero)
  have hkerFin : Module.finrank K (LinearMap.ker phi) = 2 := by
    have h := Module.Dual.finrank_ker_add_one_of_ne_zero hphi
    have hV : Module.finrank K (Fin 3 → K) = 3 := Module.finrank_fintype_fun_eq_card K
    omega
  let S : Submodule K (Fin 3 → K) := Submodule.span K ({p, q} : Set _)
  have hpker : p ∈ LinearMap.ker phi := by
    rw [LinearMap.mem_ker, coordDual_eq_eval_tangentForm]
    exact eval_tangentForm_self_eq_zero hsmooth.1 hp
  have hqker : q ∈ LinearMap.ker phi := by
    rw [LinearMap.mem_ker, coordDual_eq_eval_tangentForm]
    exact hq
  have hSle : S ≤ LinearMap.ker phi := by
    apply Submodule.span_le.mpr
    rw [Set.pair_subset_iff]
    exact ⟨hpker, hqker⟩
  have hrange : Set.range (![p, q] : Fin 2 → (Fin 3 → K)) = {p, q} := by
    ext x
    constructor
    · rintro ⟨j, rfl⟩
      fin_cases j <;> simp
    · intro hx
      simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hx
      rcases hx with rfl | rfl
      · exact ⟨0, by simp⟩
      · exact ⟨1, by simp⟩
  have hSFin : Module.finrank K S = 2 := by
    have hspan :
        Submodule.span K (Set.range (![p, q] : Fin 2 → (Fin 3 → K))) = S := by
      rw [hrange]
    rw [← hspan]
    simpa using (finrank_span_eq_card hpq)
  have hSeq : S = LinearMap.ker phi :=
    Submodule.eq_of_le_of_finrank_eq hSle (hSFin.trans hkerFin.symm)
  let qchart := chartTangentDir i g p
  have hqchartKer : qchart ∈ LinearMap.ker phi := by
    rw [LinearMap.mem_ker, coordDual_eq_eval_tangentForm]
    exact chartTangentDir_mem_tangentHyperplaneCone i g p
  have hqchartS : qchart ∈ S := by
    rw [hSeq]
    exact hqchartKer
  obtain ⟨beta, alpha, hcomb⟩ := Submodule.mem_span_pair.mp hqchartS
  have hpqchart : LinearIndependent K ![p, qchart] :=
    linearIndependent_pair_chartTangentDir_of_isSmoothPlaneCubic i g hsmooth p hp hpi
  have halpha : alpha ≠ 0 := by
    intro ha
    subst alpha
    simp only [zero_smul, add_zero] at hcomb
    have hlin : (-beta) • p + (1 : K) • qchart = 0 := by
      rw [one_smul, ← hcomb]
      simp
    have := (LinearIndependent.pair_iff.mp hpqchart) (-beta) 1 hlin
    exact one_ne_zero this.2
  refine ⟨alpha, beta, halpha, ?_⟩
  funext j
  have hj := congrFun hcomb j
  simpa [qchart, Pi.smul_apply, smul_eq_mul, add_comm] using hj.symm

/-- Replacing an arbitrary complementary tangent direction by the polynomial chart direction
preserves avoidance of a homogeneous target. -/
theorem eval_chartTangentResidual_ne_zero_of_isSmoothPlaneCubic
    (i : Fin 3) (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g)
    (p q : Fin 3 → K) (hp : eval p g = 0) (hpi : p i ≠ 0)
    (hpq : LinearIndependent K ![p, q])
    (hq : q ∈ tangentHyperplaneCone g p)
    (H : MvPolynomial (Fin 3) K) {d : ℕ} (hH : H.IsHomogeneous d)
    (havoid : eval
      (residualAmbientRep p q (binaryLineRestriction p q g)) H ≠ 0) :
    eval
      (residualAmbientRep p (chartTangentDir i g p)
        (binaryLineRestriction p (chartTangentDir i g p) g)) H ≠ 0 := by
  obtain ⟨alpha, beta, halpha, hdir⟩ :=
    exists_chartTangentDir_eq_reparam_of_isSmoothPlaneCubic
      i g hsmooth p q hp hpi hpq hq
  let f := binaryLineRestriction p q g
  obtain ⟨h30, h21⟩ :=
    coeff_binaryLineRestriction_double_contact g hsmooth.1 p q hp hq
  have hres :
      residualAmbientRep p (chartTangentDir i g p)
          (binaryLineRestriction p (chartTangentDir i g p) g) =
        fun j ↦ alpha ^ 3 * residualAmbientRep p q f j := by
    rw [hdir, binaryLineRestriction_reparam]
    exact residualAmbientRep_reparam p q alpha beta f
      (binaryLineRestriction_isHomogeneous hsmooth.1 p q) h30 h21
  rw [hres, eval_smul_point_of_isHomogeneous hH]
  exact mul_ne_zero (pow_ne_zero d (pow_ne_zero 3 halpha)) havoid

/-! ## Simultaneous avoidance at a tangent base point and its residual image -/

/-- **A smooth cubic has a tangent whose base point and residual point both avoid a proper
homogeneous target.**

The first use of tangent-residual surjectivity supplies one chart on which the pullback of the
target is nonzero.  The principal-open intersection theorem then moves the base point inside that
chart while simultaneously keeping both the original target and its residual pullback nonzero.
Thus the two avoidance conditions hold at one and the same tangent base point. -/
theorem exists_tangentResidual_base_and_image_avoid_homogeneous_target
    [NeZero (2 : K)] [NeZero (3 : K)] [IsAlgClosed K]
    (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g)
    (H : MvPolynomial (Fin 3) K) {d : ℕ} (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hproper : ∃ y : Fin 3 → K, y ≠ 0 ∧ eval y g = 0 ∧ eval y H ≠ 0) :
    ∃ p q : Fin 3 → K,
      p ≠ 0 ∧
      eval p g = 0 ∧
      eval p H ≠ 0 ∧
      LinearIndependent K ![p, q] ∧
      q ∈ tangentHyperplaneCone g p ∧
      eval (residualAmbientRep p q (binaryLineRestriction p q g)) H ≠ 0 := by
  obtain ⟨p₀, q₀, hp₀0, hp₀g, hp₀q₀, hq₀, hp₀res⟩ :=
    exists_tangentResidualRep_avoids_homogeneous_target_of_isSmoothPlaneCubic
      g hsmooth H hH hproper
  obtain ⟨i, hp₀i⟩ := exists_normalizing_coordinate p₀ hp₀0
  let P := chartTangentResidualPullback i g H
  have hp₀chart :
      eval
        (residualAmbientRep p₀ (chartTangentDir i g p₀)
          (binaryLineRestriction p₀ (chartTangentDir i g p₀) g)) H ≠ 0 :=
    eval_chartTangentResidual_ne_zero_of_isSmoothPlaneCubic
      i g hsmooth p₀ q₀ hp₀g hp₀i hp₀q₀ hq₀ H hH hp₀res
  have hP : P.IsHomogeneous (7 * d) := by
    exact chartTangentResidualPullback_isHomogeneous i g H hsmooth.1 hH
  have hXP : (X i * P).IsHomogeneous (1 + 7 * d) :=
    (isHomogeneous_X K i).mul hP
  have hXPproper :
      ∃ x : Fin 3 → K, x ≠ 0 ∧ eval x g = 0 ∧ eval x (X i * P) ≠ 0 := by
    refine ⟨p₀, hp₀0, hp₀g, ?_⟩
    rw [eval_mul, eval_X]
    apply mul_ne_zero hp₀i
    rw [show P = chartTangentResidualPullback i g H from rfl]
    rw [eval_chartTangentResidualPullback i g H hsmooth.1]
    exact hp₀chart
  obtain ⟨p, hp0, hpg, hpH, hpXP⟩ :=
    exists_projective_point_off_two_targets_of_isSmoothPlaneCubic
      g H (X i * P) hsmooth hH hXP hd (by omega) hproper hXPproper
  have hpi : p i ≠ 0 := by
    intro hzero
    apply hpXP
    rw [eval_mul, eval_X, hzero, zero_mul]
  have hpP : eval p P ≠ 0 := by
    rw [eval_mul, eval_X, mul_ne_zero_iff] at hpXP
    exact hpXP.2
  let q := chartTangentDir i g p
  have hpq : LinearIndependent K ![p, q] :=
    linearIndependent_pair_chartTangentDir_of_isSmoothPlaneCubic i g hsmooth p hpg hpi
  have hq : q ∈ tangentHyperplaneCone g p :=
    chartTangentDir_mem_tangentHyperplaneCone i g p
  have hpres : eval (residualAmbientRep p q (binaryLineRestriction p q g)) H ≠ 0 := by
    rw [show q = chartTangentDir i g p from rfl]
    rw [← eval_chartTangentResidualPullback i g H hsmooth.1]
    exact hpP
  exact ⟨p, q, hp0, hpg, hpH, hpq, hq, hpres⟩

end

end BConicBundleMultisections.Standard
