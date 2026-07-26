/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineChart
public import BConicBundleMultisections.BiprojectiveAffineJacobian
public import BConicBundleMultisections.ChartHomogenization
public import BConicBundleMultisections.MvPolynomialHomogeneousEvaluation
public import BConicBundleMultisections.TernaryQuadraticGradient
public import Mathlib.Algebra.MvPolynomial.Nilpotent
public import Mathlib.Algebra.MvPolynomial.NoZeroDivisors
public import Mathlib.Algebra.MvPolynomial.PDeriv
public import Mathlib.RingTheory.Ideal.Maximal
public import Mathlib.RingTheory.Ideal.Quotient.Basic
public import Mathlib.RingTheory.Localization.Away.Basic
public import Mathlib.RingTheory.MvPolynomial.Homogeneous

/-!
# Jacobian nonsingularity via dehomogenized charts

Algebraic half of I1-nonsing: if every standard-chart dehomogenization of a nonzero homogeneous
ternary quadratic is a smooth hypersurface over `K`, then the form is Jacobian-nonsingular.
-/

@[expose] public section

open MvPolynomial
open HomogeneousLocalization IsLocalization

namespace BConicBundleMultisections

noncomputable section

universe u

open ProjectiveSpace Hypersurface

variable {K : Type u} [Field K]

attribute [local instance] MvPolynomial.gradedAlgebra

/-- Affine coordinates of a nonzero vector in the chart where coordinate `i` is nonzero. -/
def affineCoords (v : Fin 3 → K) (i : Fin 3) (_hvi : v i ≠ 0) : Fin 2 → K :=
  fun r => v (i.succAbove r) * (v i)⁻¹

/-- Evaluating an `aeval` then `eval` is evaluating at the composed values. -/
theorem eval_aeval_eq_eval_comp
    (a : Fin 2 → K) (φ : Fin 3 → MvPolynomial (Fin 2) K) (Q : MvPolynomial (Fin 3) K) :
    eval a (aeval φ Q) = eval (fun j => eval a (φ j)) Q := by
  induction Q using MvPolynomial.induction_on with
  | C r => simp
  | add p q hp hq => rw [map_add, map_add, map_add, hp, hq]
  | mul_X p j hp =>
      rw [map_mul, aeval_X, map_mul, map_mul, eval_X, hp]

/-- Constant-type chart substitution (non-dependent `insertNth`). -/
noncomputable def chartSubst (i : Fin 3) : Fin 3 → MvPolynomial (Fin 2) K :=
  Fin.insertNth (α := fun _ => MvPolynomial (Fin 2) K) i 1 fun r => X r

@[simp] theorem chartSubst_self (i : Fin 3) : chartSubst (K := K) i i = 1 :=
  Fin.insertNth_apply_same (α := fun _ => MvPolynomial (Fin 2) K) i 1 _

@[simp] theorem chartSubst_succAbove (i : Fin 3) (r : Fin 2) :
    chartSubst (K := K) i (i.succAbove r) = X r :=
  Fin.insertNth_apply_succAbove (α := fun _ => MvPolynomial (Fin 2) K) i 1 _ r

theorem chartDehomogenization_eq_aeval_chartSubst (i : Fin 3) :
    chartDehomogenization 2 K i = aeval (chartSubst (K := K) i) := by
  ext Q
  simp only [chartDehomogenization, chartSubst, Fin.succAbove_cases_eq_insertNth]

theorem eval_chartSubst
    (v : Fin 3 → K) (i : Fin 3) (hvi : v i ≠ 0) (j : Fin 3) :
    eval (affineCoords v i hvi) (chartSubst (K := K) i j) = v j * (v i)⁻¹ := by
  by_cases hj : j = i
  · subst hj; simp [hvi]
  · obtain ⟨r, rfl⟩ := Fin.exists_succAbove_eq hj
    simp [affineCoords]

/-- Evaluation after dehomogenization equals evaluation at the rescaled vector. -/
theorem eval_chartDehomogenization
    (Q : MvPolynomial (Fin 3) K) (v : Fin 3 → K) (i : Fin 3) (hvi : v i ≠ 0) :
    eval (affineCoords v i hvi) (chartDehomogenization 2 K i Q) =
      eval (fun j => v j * (v i)⁻¹) Q := by
  rw [chartDehomogenization_eq_aeval_chartSubst, eval_aeval_eq_eval_comp]
  refine congrArg (fun w => eval w Q) ?_
  funext j
  exact eval_chartSubst v i hvi j

/-- If a homogeneous form vanishes at `v` with `v i ≠ 0`, the dehomogenization vanishes. -/
theorem eval_chartDehomogenization_eq_zero_of
    (Q : MvPolynomial (Fin 3) K) (d : ℕ) (hQ : Q.IsHomogeneous d)
    (v : Fin 3 → K) (i : Fin 3) (hvi : v i ≠ 0) (hQv : eval v Q = 0) :
    eval (affineCoords v i hvi) (chartDehomogenization 2 K i Q) = 0 := by
  rw [eval_chartDehomogenization]
  have h := eval_smul_point_of_isHomogeneous hQ (v i)⁻¹ v
  have hv : (fun j => (v i)⁻¹ * v j) = fun j => v j * (v i)⁻¹ := by
    funext j; ring
  rw [hv] at h
  rw [h, hQv, mul_zero]

/-- Dehomogenization of a nonzero homogeneous form is nonzero. -/
theorem chartDehomogenization_ne_zero_of_isHomogeneous
    (Q : MvPolynomial (Fin 3) K) (d : ℕ) (hQ : Q.IsHomogeneous d) (hQ0 : Q ≠ 0)
    (i : Fin 3) :
    chartDehomogenization 2 K i Q ≠ 0 := by
  intro hf
  have hAway :=
    mvPolynomialToStandardChart_chartDehomogenization_of_isHomogeneous 2 K i hQ
  rw [hf, map_zero] at hAway
  have hmk0 :
      Away.mk (homogeneousSubmodule (Fin 3) K) (isHomogeneous_X K i) d Q
        (by simpa using hQ) = 0 := by
    rw [← hAway]
  have hval := congrArg HomogeneousLocalization.val hmk0
  rw [Away.val_mk, val_zero, Localization.mk_eq_mk'_apply] at hval
  haveI : IsDomain (MvPolynomial (Fin 3) K) := inferInstance
  rw [mk'_eq_zero_iff] at hval
  obtain ⟨⟨s, hs⟩, hsc⟩ := hval
  obtain ⟨n, rfl⟩ := (Submonoid.mem_powers_iff s (X i)).mp hs
  change (X i : MvPolynomial (Fin 3) K) ^ n * Q = 0 at hsc
  exact hQ0 ((mul_eq_zero.mp hsc).resolve_left (pow_ne_zero n (X_ne_zero i)))

/-- Partials of the chart substitution: only the free variable `X r` contributes. -/
theorem pderiv_chartSubst (i : Fin 3) (r : Fin 2) (j : Fin 3) :
    pderiv r (chartSubst (K := K) i j) =
      if j = i.succAbove r then (1 : MvPolynomial (Fin 2) K) else 0 := by
  classical
  by_cases hj : j = i
  · have hne : j ≠ i.succAbove r := by
      rw [hj]; exact (Fin.succAbove_ne i r).symm
    simp [hj, chartSubst_self]
  · obtain ⟨s, rfl⟩ := Fin.exists_succAbove_eq hj
    rw [chartSubst_succAbove, pderiv_X]
    by_cases hsr : s = r
    · subst hsr
      simp [Pi.single_eq_same]
    · have hne : i.succAbove s ≠ i.succAbove r :=
        (Fin.succAbove_right_injective (p := i)).ne_iff.mpr hsr
      simp [Pi.single_eq_of_ne hsr, hne]

/-- Free-direction partials of the dehomogenization equal dehomogenized partials of `Q`
(polynomial identity; proved by induction on `Q`). -/
theorem pderiv_chartDehomogenization
    (Q : MvPolynomial (Fin 3) K) (i : Fin 3) (r : Fin 2) :
    pderiv r (chartDehomogenization 2 K i Q) =
      chartDehomogenization 2 K i (pderiv (i.succAbove r) Q) := by
  classical
  rw [chartDehomogenization_eq_aeval_chartSubst]
  set φ : Fin 3 → MvPolynomial (Fin 2) K := chartSubst (K := K) i
  change pderiv r (aeval φ Q) = aeval φ (pderiv (i.succAbove r) Q)
  induction Q using MvPolynomial.induction_on with
  | C a =>
      simp only [aeval_C, pderiv_C]
      change pderiv r (C a) = 0
      exact pderiv_C
  | add f g hf hg =>
      rw [map_add, Derivation.map_add (pderiv r),
        Derivation.map_add (pderiv (i.succAbove r)), map_add, hf, hg]
  | mul_X f j hf =>
      rw [map_mul, aeval_X, pderiv_mul, pderiv_mul, map_add, map_mul, map_mul, aeval_X, hf]
      congr 1
      have hφ : pderiv r (φ j) =
          if j = i.succAbove r then (1 : MvPolynomial (Fin 2) K) else 0 :=
        pderiv_chartSubst i r j
      have hX :
          aeval φ (pderiv (i.succAbove r) (X j : MvPolynomial (Fin 3) K)) =
            if j = i.succAbove r then (1 : MvPolynomial (Fin 2) K) else 0 := by
        rw [pderiv_X]
        by_cases hj : j = i.succAbove r
        · simp [hj, Pi.single_eq_same]
        · simp [hj]
      rw [hφ, hX]

/-- Evaluation of free partials of the dehomogenization recovers scaled partials of `Q`. -/
theorem eval_pderiv_chartDehomogenization
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (v : Fin 3 → K) (i : Fin 3) (hvi : v i ≠ 0) (r : Fin 2) :
    eval (affineCoords v i hvi) (pderiv r (chartDehomogenization 2 K i Q)) =
      eval v (pderiv (i.succAbove r) Q) * (v i)⁻¹ := by
  rw [pderiv_chartDehomogenization, eval_chartDehomogenization]
  have hp : (pderiv (i.succAbove r) Q).IsHomogeneous 1 := hQ.pderiv
  have h := eval_smul_point_of_isHomogeneous hp (v i)⁻¹ v
  have hv : (fun j => (v i)⁻¹ * v j) = fun j => v j * (v i)⁻¹ := by
    funext j; ring
  rw [hv] at h
  rw [h, pow_one]
  ring

/-- **Algebraic core, assuming Smooth chart quotients.**

Remaining input for I1-nonsing: prove each dehomogenized chart quotient is Smooth over the
residue field, from Smooth of the projective fibre.
-/
theorem nonsingular_of_smooth_dehomogenized_charts
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hsm : ∀ i : Fin 3,
      RingHom.Smooth
        (algebraMap K
          (MvPolynomial (Fin 2) K ⧸
            Ideal.span {chartDehomogenization 2 K i Q})))
    (v : Fin 3 → K) (hv0 : v ≠ 0) (hQv : eval v Q = 0) :
    ∃ j : Fin 3, eval v (pderiv j Q) ≠ 0 := by
  classical
  obtain ⟨i, hvi⟩ : ∃ i, v i ≠ 0 := by
    by_contra h; push Not at h; exact hv0 (funext h)
  set f := chartDehomogenization 2 K i Q
  have hf0 : f ≠ 0 := chartDehomogenization_ne_zero_of_isHomogeneous Q 2 hQ hQ0 i
  have ha : aeval (affineCoords v i hvi) f = 0 := by
    have := eval_chartDehomogenization_eq_zero_of Q 2 hQ v i hvi hQv
    simpa [aeval_def] using this
  obtain ⟨r, hr⟩ := exists_pderiv_ne_zero_at_of_smooth f hf0 (hsm i)
    (affineCoords v i hvi) ha
  refine ⟨i.succAbove r, ?_⟩
  intro hzero
  have hrel := eval_pderiv_chartDehomogenization Q hQ v i hvi r
  have hvan : eval (affineCoords v i hvi) (pderiv r f) = 0 := by
    rw [hrel, hzero, zero_mul]
  have hr' : eval (affineCoords v i hvi) (pderiv r f) ≠ 0 := by
    simpa [aeval_def] using hr
  exact hr' hvan

/-! ### Chart-ring domain from nonsingular ternary quadratics (I1-GI route B) -/

private theorem not_isUnit_of_totalDegree_pos {σ : Type*} (p : MvPolynomial σ K)
    (h : 0 < p.totalDegree) : ¬IsUnit p := by
  intro hu
  have := (isUnit_iff_totalDegree_of_isReduced (P := p)).mp hu |>.2
  omega

private theorem isUnit_of_totalDegree_eq_zero {σ : Type*} (p : MvPolynomial σ K)
    (hp0 : p ≠ 0) (htd : p.totalDegree = 0) : IsUnit p := by
  rw [isUnit_iff_eq_C_of_isReduced]
  have heq : p = C (p.coeff 0) := (totalDegree_eq_zero_iff_eq_C (p := p)).mp htd
  refine ⟨p.coeff 0, ?_, heq⟩
  refine isUnit_iff_ne_zero.mpr ?_
  intro hc
  exact hp0 (by rw [heq, hc, map_zero])

/-- Dehomogenization of an irreducible homogeneous ternary quadratic is irreducible. -/
theorem irreducible_chartDehomogenization_of_irreducible_homogeneous_two
    (i : Fin 3) (Q : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0) (hirr : Irreducible Q) :
    Irreducible (chartDehomogenization 2 K i Q) := by
  set g := chartDehomogenization 2 K i Q
  have hg0 : g ≠ 0 := chartDehomogenization_ne_zero_of_isHomogeneous Q 2 hQ hQ0 i
  have hrec : chartHomogenization (R := K) i 2 g = Q :=
    chartHomogenization_chartDehomogenization i 2 Q hQ
  have hg_td : g.totalDegree ≤ 2 :=
    totalDegree_chartDehomogenization_of_isHomogeneous i 2 Q hQ
  refine (irreducible_iff).mpr ⟨?notUnit, ?factor⟩
  · intro hu
    obtain ⟨r, hrU, hr⟩ := (isUnit_iff_eq_C_of_isReduced (P := g)).mp hu
    have hQeq : Q = (X i : MvPolynomial (Fin 3) K) ^ 2 * C r := by
      rw [← hrec, hr, chartHomogenization_C]
    have hfac : Q = X i * (X i * C r) := by
      rw [hQeq]; ring
    have hXu : ¬IsUnit (X i : MvPolynomial (Fin 3) K) :=
      not_isUnit_of_totalDegree_pos _ (by simp [totalDegree_X])
    have hr0 : r ≠ 0 := isUnit_iff_ne_zero.mp hrU
    have hXu2 : ¬IsUnit ((X i : MvPolynomial (Fin 3) K) * C r) := by
      have hneC : (C r : MvPolynomial (Fin 3) K) ≠ 0 :=
        (C_eq_zero (a := r)).not.mpr hr0
      have htd' := totalDegree_mul_of_isDomain (X_ne_zero i) hneC
      have : 0 < ((X i : MvPolynomial (Fin 3) K) * C r).totalDegree := by
        simp [htd', totalDegree_X, totalDegree_C]
      exact not_isUnit_of_totalDegree_pos _ this
    obtain ⟨_, hfact⟩ := (irreducible_iff).mp hirr
    exact (hfact hfac).elim hXu hXu2
  · intro a b hab
    have ha0 : a ≠ 0 := fun h => by rw [h, zero_mul] at hab; exact hg0 hab
    have hb0 : b ≠ 0 := fun h => by rw [h, mul_zero] at hab; exact hg0 hab
    by_cases haU : IsUnit a
    · exact Or.inl haU
    by_cases hbU : IsUnit b
    · exact Or.inr hbU
    have htd_eq : g.totalDegree = a.totalDegree + b.totalDegree := by
      rw [hab]; exact totalDegree_mul_of_isDomain ha0 hb0
    have hsuma : a.totalDegree + b.totalDegree ≤ 2 := by
      rw [← htd_eq]; exact hg_td
    have htda : 1 ≤ a.totalDegree := by
      by_contra h
      have htd0 : a.totalDegree = 0 := by omega
      exact haU (isUnit_of_totalDegree_eq_zero a ha0 htd0)
    have htdb : 1 ≤ b.totalDegree := by
      by_contra h
      have htd0 : b.totalDegree = 0 := by omega
      exact hbU (isUnit_of_totalDegree_eq_zero b hb0 htd0)
    have htda1 : a.totalDegree = 1 := by omega
    have htdb1 : b.totalDegree = 1 := by omega
    have hQfac : Q =
        chartHomogenization (R := K) i 1 a *
          chartHomogenization (R := K) i 1 b := by
      rw [← hrec, hab]
      exact chartHomogenization_mul i 1 1 a b htda1.le htdb1.le
    have hAu : ¬IsUnit (chartHomogenization (R := K) i 1 a) := by
      have hne : chartHomogenization (R := K) i 1 a ≠ 0 := by
        intro hz
        have := eq_zero_of_chartHomogenization_eq_zero i 1 a htda1.le hz
        have : a.totalDegree = 0 := by rw [this]; exact totalDegree_zero
        omega
      have hhom : (chartHomogenization (R := K) i 1 a).IsHomogeneous 1 :=
        chartHomogenization_isHomogeneous i 1 a
      have : (chartHomogenization (R := K) i 1 a).totalDegree = 1 :=
        hhom.totalDegree hne
      exact not_isUnit_of_totalDegree_pos _ (by omega)
    have hBu : ¬IsUnit (chartHomogenization (R := K) i 1 b) := by
      have hne : chartHomogenization (R := K) i 1 b ≠ 0 := by
        intro hz
        have := eq_zero_of_chartHomogenization_eq_zero i 1 b htdb1.le hz
        have : b.totalDegree = 0 := by rw [this]; exact totalDegree_zero
        omega
      have hhom : (chartHomogenization (R := K) i 1 b).IsHomogeneous 1 :=
        chartHomogenization_isHomogeneous i 1 b
      have : (chartHomogenization (R := K) i 1 b).totalDegree = 1 :=
        hhom.totalDegree hne
      exact not_isUnit_of_totalDegree_pos _ (by omega)
    obtain ⟨_, hfact⟩ := (irreducible_iff).mp hirr
    exact False.elim ((hfact hQfac).elim hAu hBu)

/-- **I1-GI brick:** the dehomogenized chart ring of a nonsingular ternary quadratic is a domain.

`K[u,v] / (chartDehomogenization Q)` is a domain when `Q` is a nonsingular homogeneous ternary
quadratic.  Combines absolute irreducibility of `Q` (TernaryQuadratic) with recovery of `Q` from
its dehomogenization (so a factorization of the chart equation would lift to a factorization of
`Q`). -/
theorem isDomain_chartDehomogenization_quotient_of_nonsingular
    (i : Fin 3) (Q : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hnonsing : ∀ v : Fin 3 → K, v ≠ 0 → eval v Q = 0 →
      ∃ j, eval v (pderiv j Q) ≠ 0) :
    IsDomain (MvPolynomial (Fin 2) K ⧸ Ideal.span {chartDehomogenization 2 K i Q}) := by
  have hirrQ :=
    TernaryQuadratic.irreducible_of_isHomogeneous_two_of_nonsingular Q hQ hQ0 hnonsing
  have hirr := irreducible_chartDehomogenization_of_irreducible_homogeneous_two
    i Q hQ hQ0 hirrQ
  have hg0 : chartDehomogenization 2 K i Q ≠ 0 :=
    chartDehomogenization_ne_zero_of_isHomogeneous Q 2 hQ hQ0 i
  have hprime : Prime (chartDehomogenization 2 K i Q) := hirr.prime
  haveI : (Ideal.span {chartDehomogenization 2 K i Q}).IsPrime :=
    (Ideal.span_singleton_prime hg0).mpr hprime
  infer_instance

end

end BConicBundleMultisections
