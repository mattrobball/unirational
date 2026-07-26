/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.AlgebraicIndependenceJacobian
public import BConicBundleMultisections.HomogeneousQuadraticEval
public import Mathlib.Algebra.MvPolynomial.Nilpotent
public import Mathlib.LinearAlgebra.Dimension.Constructions
public import Mathlib.LinearAlgebra.FiniteDimensional.Basic
public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
public import Mathlib.RingTheory.Ideal.Quotient.Basic
public import Mathlib.RingTheory.MvPolynomial.IrreducibleQuadratic
public import Mathlib.RingTheory.Polynomial.UniqueFactorization
public import Mathlib.RingTheory.UniqueFactorizationDomain.Basic

/-!
# The gradient of a ternary quadratic is its polar form

`polarEval Q p w = Q(p + w) − Q(p) − Q(w)` is the polar of a ternary quadratic.  This module proves
the identity that makes it the *gradient*:

```
polarEval Q n w = ∑ i, w i * (∂Q/∂xᵢ)(n) ,
```

and in particular `(∂Q/∂xᵢ)(n) = polarEval Q n eᵢ`.  `HomogeneousQuadraticEval` has the value
formula `eval_eq_ternaryQuadraticCoeff_sum` and the polar formula `polarEval_eq_coeff_sum`, but no
gradient formula; this is the quadric analogue of `PlaneCubicPartials`, and it is what identifies a
kernel vector of the polar matrix with a *singular point* of the conic.

Nothing beyond a commutative ring is used for the gradient identity, so that statement is
upstreamable as it stands.

## Irreducibility of nonsingular ternary quadratics

Over a field, a nonzero homogeneous degree-2 polynomial in three variables with no nonzero common
zero of itself and its partials is irreducible (`irreducible_of_isHomogeneous_two_of_nonsingular`).
This is the algebraic half of “a smooth plane conic is integral”, filling the Mathlib TODO in
`RingTheory/MvPolynomial/IrreducibleQuadratic.lean` for the rank-3 / nonsingular ternary case.

## The proof (gradient)

Substituting `xⱼ ↦ C nⱼ + C wⱼ · X` into `Q` gives, by the two coefficient formulas, the univariate
quadratic

```
Q(n) + polarEval Q n w · X + Q(w) · X² ,
```

whose derivative at `X = 0` is `polarEval Q n w`.  By the multivariate chain rule `pderiv_aeval` of
`AlgebraicIndependenceJacobian.lean` that same derivative is `∑ i, wᵢ · (∂Q/∂xᵢ)(n)`.  So no case
analysis on monomials is needed: the coefficient formulas do the work.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial

variable {R : Type u} [CommRing R]

/-- Evaluating a substituted polynomial is evaluating at the evaluated substitutions. -/
private theorem eval_aeval_finOne (Y : Fin 3 → MvPolynomial (Fin 1) R) (x : Fin 1 → R)
    (p : MvPolynomial (Fin 3) R) :
    eval x ((aeval Y : MvPolynomial (Fin 3) R →ₐ[R] _) p)
      = eval (fun j => eval x (Y j)) p := by
  induction p using MvPolynomial.induction_on with
  | C a => simp
  | add p q hp hq => simp [hp, hq]
  | mul_X p j hp => simp [hp]

/-- A change of coefficient ring acts on the upper-triangular quadratic coefficients. -/
private theorem ternaryQuadraticCoeff_map' {S : Type u} [CommRing S] (φ : R →+* S)
    (f : MvPolynomial (Fin 3) R) (i j : Fin 3) :
    ternaryQuadraticCoeff (map φ f) i j = φ (ternaryQuadraticCoeff f i j) := by
  simp only [ternaryQuadraticCoeff, coeff_map]
  split_ifs <;> simp

/-- **The polar form is the gradient paired with the direction.** -/
theorem polarEval_eq_sum_pderiv {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (n w : Fin 3 → R) :
    polarEval Q n w = ∑ i : Fin 3, w i * eval n (pderiv i Q) := by
  classical
  set Y : Fin 3 → MvPolynomial (Fin 1) R := fun j => C (n j) + C (w j) * X 0 with hY
  set A := (aeval Y : MvPolynomial (Fin 3) R →ₐ[R] MvPolynomial (Fin 1) R) with hA
  -- the substituted polynomial is an explicit univariate quadratic
  have hsub : A Q = C (eval n Q) + C (polarEval Q n w) * X 0 + C (eval w Q) * X 0 ^ 2 := by
    have hae : A Q = eval Y (map (C : R →+* MvPolynomial (Fin 1) R) Q) := by
      rw [eval_map]
      rfl
    rw [hae, eval_eq_ternaryQuadraticCoeff_sum (hQ.map _)]
    simp only [ternaryQuadraticCoeff_map', hY]
    rw [eval_eq_ternaryQuadraticCoeff_sum hQ n, eval_eq_ternaryQuadraticCoeff_sum hQ w,
      polarEval_eq_coeff_sum Q hQ]
    simp only [Fin.sum_univ_three, map_add, map_mul]
    ring
  -- the chain rule for the same substitution
  have hchain : pderiv 0 (A Q) = ∑ a : Fin 3, A (pderiv a Q) * C (w a) := by
    rw [hA, pderiv_aeval Y 0 Q]
    refine Finset.sum_congr rfl fun a _ => ?_
    congr 1
    rw [hY]
    simp
  -- evaluating the substitution at `X = 0` returns to the point `n`
  have h0 : ∀ p : MvPolynomial (Fin 3) R,
      eval (fun _ : Fin 1 => (0 : R)) (A p) = eval n p := by
    have hpt : (fun j => eval (fun _ : Fin 1 => (0 : R)) (Y j)) = n := by
      funext j
      simp [hY]
    intro p
    rw [hA, eval_aeval_finOne, hpt]
  have hL : eval (fun _ : Fin 1 => (0 : R)) (pderiv 0 (A Q)) = polarEval Q n w := by
    rw [hsub]
    simp
  have hR : eval (fun _ : Fin 1 => (0 : R)) (∑ a : Fin 3, A (pderiv a Q) * C (w a))
      = ∑ a : Fin 3, eval n (pderiv a Q) * w a := by
    rw [map_sum]
    exact Finset.sum_congr rfl fun a _ => by rw [map_mul, h0, eval_C]
  rw [← hL, hchain, hR]
  exact Finset.sum_congr rfl fun a _ => mul_comm _ _

/-- **The gradient of a ternary quadratic**: the `i`-th partial derivative at `n` is the polar form
against the `i`-th basis vector. -/
theorem eval_pderiv_eq_polarEval_single {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (n : Fin 3 → R) (i : Fin 3) :
    eval n (pderiv i Q) = polarEval Q n (Pi.single i 1) := by
  classical
  rw [polarEval_eq_sum_pderiv hQ]
  rw [Finset.sum_eq_single i (fun b _ hb => by simp [hb]) (by simp)]
  simp

end

/-! ### Irreducibility of nonsingular homogeneous ternary quadratics over a field -/

namespace TernaryQuadratic

open MvPolynomial LinearMap

variable {K : Type u} [Field K]

/-- Every homogeneous degree-1 ternary polynomial is a linear form. -/
lemma eq_sum_C_mul_X_of_isHomogeneous_one (L : MvPolynomial (Fin 3) K)
    (hL : L.IsHomogeneous 1) :
    ∃ c : Fin 3 → K, L = ∑ i, C (c i) * X i := by
  have hmem : L ∈ homogeneousSubmodule (Fin 3) K 1 := hL
  rw [homogeneousSubmodule_one_eq_span_X] at hmem
  obtain ⟨c, hc⟩ := (Submodule.mem_span_range_iff_exists_fun K).mp hmem
  refine ⟨c, ?_⟩
  simpa [smul_eq_C_mul] using hc.symm

lemma eval_sum_C_mul_X (c : Fin 3 → K) (v : Fin 3 → K) :
    eval v (∑ i : Fin 3, C (c i) * X i) = ∑ i, c i * v i := by
  simp [eval_C, eval_X, mul_comm]

/-- The linear map `v ↦ ∑ cᵢ vᵢ` associated with coefficients of a linear form. -/
noncomputable def linearFormMap (c : Fin 3 → K) : (Fin 3 → K) →ₗ[K] K where
  toFun := fun v => ∑ i, c i * v i
  map_add' := fun x y => by
    simp only [Pi.add_apply, mul_add, Finset.sum_add_distrib]
  map_smul' := fun r x => by
    simp only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply, Finset.mul_sum]
    exact Finset.sum_congr rfl fun i _ => by ring

/-- A nonzero homogeneous linear form on `K³` has a nonzero zero. -/
theorem exists_ne_zero_eval_eq_zero_of_isHomogeneous_one
    (L : MvPolynomial (Fin 3) K) (hL : L.IsHomogeneous 1) (hL0 : L ≠ 0) :
    ∃ v : Fin 3 → K, v ≠ 0 ∧ eval v L = 0 := by
  obtain ⟨c, rfl⟩ := eq_sum_C_mul_X_of_isHomogeneous_one L hL
  have hc0 : c ≠ 0 := by
    intro h; apply hL0; simp [h]
  have hker : ker (linearFormMap c) ≠ ⊥ :=
    ker_ne_bot_of_finrank_lt (by simp [Module.finrank_self])
  obtain ⟨v, hvmem, hvne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hker
  refine ⟨v, hvne, ?_⟩
  have : linearFormMap c v = 0 := mem_ker.mp hvmem
  rwa [eval_sum_C_mul_X]

lemma pderiv_sum_C_mul_X (c : Fin 3 → K) (i : Fin 3) :
    pderiv i (∑ j : Fin 3, C (c j) * X j) = C (c i) := by
  classical
  simp only [map_sum, pderiv_C_mul, pderiv_X]
  rw [Finset.sum_eq_single i] <;> simp +contextual

/-- Two linear forms on `K³` have a common nonzero zero (rank-nullity: map to `K × K`). -/
lemma exists_common_kernel (c1 c2 : Fin 3 → K) :
    ∃ v : Fin 3 → K, v ≠ 0 ∧ linearFormMap c1 v = 0 ∧ linearFormMap c2 v = 0 := by
  let F : (Fin 3 → K) →ₗ[K] (K × K) :=
    { toFun := fun v => (linearFormMap c1 v, linearFormMap c2 v)
      map_add' := fun _ _ => by simp [map_add]
      map_smul' := fun _ _ => by simp [map_smul] }
  have hkerF : ker F ≠ ⊥ := by
    apply ker_ne_bot_of_finrank_lt
    have : Module.finrank K (Fin 3 → K) = 3 := Module.finrank_fin_fun K
    have : Module.finrank K (K × K) = 2 := by
      simp [Module.finrank_prod, Module.finrank_self]
    omega
  obtain ⟨v, hvmem, hvne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hkerF
  have hv : F v = 0 := mem_ker.mp hvmem
  exact ⟨v, hvne, (Prod.ext_iff.mp hv).1, (Prod.ext_iff.mp hv).2⟩

/-- Product of two nonzero homogeneous linear forms is a singular plane conic. -/
theorem exists_singular_point_of_mul_homog_one
    (L₁ L₂ : MvPolynomial (Fin 3) K)
    (h1 : L₁.IsHomogeneous 1) (h2 : L₂.IsHomogeneous 1)
    (_h10 : L₁ ≠ 0) (_h20 : L₂ ≠ 0) :
    ∃ v : Fin 3 → K, v ≠ 0 ∧
      eval v (L₁ * L₂) = 0 ∧ ∀ i, eval v (pderiv i (L₁ * L₂)) = 0 := by
  obtain ⟨c1, rfl⟩ := eq_sum_C_mul_X_of_isHomogeneous_one L₁ h1
  obtain ⟨c2, rfl⟩ := eq_sum_C_mul_X_of_isHomogeneous_one L₂ h2
  obtain ⟨v, hvne, hv1, hv2⟩ := exists_common_kernel c1 c2
  refine ⟨v, hvne, ?_, fun i => ?_⟩
  · rw [eval_mul, eval_sum_C_mul_X, eval_sum_C_mul_X]
    change linearFormMap c1 v * linearFormMap c2 v = 0
    rw [hv1, hv2, mul_zero]
  · rw [pderiv_mul, map_add, eval_mul, eval_mul, pderiv_sum_C_mul_X, pderiv_sum_C_mul_X,
      eval_C, eval_C, eval_sum_C_mul_X, eval_sum_C_mul_X]
    change c1 i * linearFormMap c2 v + linearFormMap c1 v * c2 i = 0
    rw [hv1, hv2]; ring

/-- Total-degree decomposition of a degree-1 polynomial into components 0 and 1. -/
lemma eq_homog_zero_add_one_of_totalDegree_eq_one
    {p : MvPolynomial (Fin 3) K} (hp : p.totalDegree = 1) :
    p = homogeneousComponent 0 p + homogeneousComponent 1 p := by
  have h := sum_homogeneousComponent (φ := p)
  simp only [hp, Nat.reduceAdd] at h
  rw [Finset.range_add_one, Finset.sum_insert (by simp), Finset.range_one,
    Finset.sum_singleton, add_comm] at h
  exact h.symm

/-- Degree-1 factors of a homogeneous degree-2 product are themselves homogeneous of degree 1. -/
theorem isHomogeneous_one_of_mul_eq_homog_two
    {a b Q : MvPolynomial (Fin 3) K}
    (hQ : Q.IsHomogeneous 2) (hab : Q = a * b)
    (ha0ne : a ≠ 0) (hb0ne : b ≠ 0)
    (ha : a.totalDegree = 1) (hb : b.totalDegree = 1) :
    a.IsHomogeneous 1 ∧ b.IsHomogeneous 1 := by
  have ha_eq : a = homogeneousComponent 0 a + homogeneousComponent 1 a :=
    eq_homog_zero_add_one_of_totalDegree_eq_one ha
  have hb_eq : b = homogeneousComponent 0 b + homogeneousComponent 1 b :=
    eq_homog_zero_add_one_of_totalDegree_eq_one hb
  set a0 := homogeneousComponent 0 a
  set a1 := homogeneousComponent 1 a
  set b0 := homogeneousComponent 0 b
  set b1 := homogeneousComponent 1 b
  have ha0h : a0.IsHomogeneous 0 := homogeneousComponent_isHomogeneous 0 a
  have ha1h : a1.IsHomogeneous 1 := homogeneousComponent_isHomogeneous 1 a
  have hb0h : b0.IsHomogeneous 0 := homogeneousComponent_isHomogeneous 0 b
  have hb1h : b1.IsHomogeneous 1 := homogeneousComponent_isHomogeneous 1 b
  have hab_exp : Q = a0 * b0 + a0 * b1 + a1 * b0 + a1 * b1 := by
    rw [hab, ha_eq, hb_eq]; ring
  have hQ0 : homogeneousComponent 0 Q = 0 := by
    rw [homogeneousComponent_of_mem hQ]; simp
  have hQ1 : homogeneousComponent 1 Q = 0 := by
    rw [homogeneousComponent_of_mem hQ]; simp
  have hhom00 : (a0 * b0).IsHomogeneous 0 := ha0h.mul hb0h
  have hhom01 : (a0 * b1).IsHomogeneous 1 := by simpa using ha0h.mul hb1h
  have hhom10 : (a1 * b0).IsHomogeneous 1 := ha1h.mul hb0h
  have hhom11 : (a1 * b1).IsHomogeneous 2 := ha1h.mul hb1h
  have h00 : a0 * b0 = 0 := by
    have hcomp := congrArg (homogeneousComponent 0) hab_exp
    rw [map_add, map_add, map_add, hQ0,
      homogeneousComponent_of_mem hhom00, if_pos rfl,
      homogeneousComponent_of_mem hhom01, if_neg (by norm_num),
      homogeneousComponent_of_mem hhom10, if_neg (by norm_num),
      homogeneousComponent_of_mem hhom11, if_neg (by norm_num)] at hcomp
    simpa using hcomp.symm
  have ha0_eq0 : a0 = 0 := by
    by_contra hne
    have hb0_eq0 : b0 = 0 := (mul_eq_zero.mp h00).resolve_left hne
    have hcomp := congrArg (homogeneousComponent 1) hab_exp
    rw [map_add, map_add, map_add, hQ1,
      homogeneousComponent_of_mem hhom00, if_neg (by norm_num),
      homogeneousComponent_of_mem hhom01, if_pos rfl,
      homogeneousComponent_of_mem hhom10, if_pos rfl,
      homogeneousComponent_of_mem hhom11, if_neg (by norm_num)] at hcomp
    simp only [zero_add, add_zero] at hcomp
    have : a0 * b1 = 0 := by
      rw [hb0_eq0, mul_zero, add_zero] at hcomp; exact hcomp.symm
    have hb1_eq0 : b1 = 0 := (mul_eq_zero.mp this).resolve_left hne
    exact hb0ne (by rw [hb_eq, hb0_eq0, hb1_eq0, zero_add])
  have hb0_eq0 : b0 = 0 := by
    by_contra hne
    have ha0' : a0 = 0 := (mul_eq_zero.mp h00).resolve_right hne
    have hcomp := congrArg (homogeneousComponent 1) hab_exp
    rw [map_add, map_add, map_add, hQ1,
      homogeneousComponent_of_mem hhom00, if_neg (by norm_num),
      homogeneousComponent_of_mem hhom01, if_pos rfl,
      homogeneousComponent_of_mem hhom10, if_pos rfl,
      homogeneousComponent_of_mem hhom11, if_neg (by norm_num)] at hcomp
    simp only [zero_add, add_zero] at hcomp
    have : a1 * b0 = 0 := by
      rw [ha0', zero_mul, zero_add] at hcomp; exact hcomp.symm
    have ha1_eq0 : a1 = 0 := (mul_eq_zero.mp this).resolve_right hne
    exact ha0ne (by rw [ha_eq, ha0', ha1_eq0, zero_add])
  constructor
  · convert ha1h; rw [ha_eq, ha0_eq0, zero_add]
  · convert hb1h; rw [hb_eq, hb0_eq0, zero_add]

lemma isUnit_of_totalDegree_eq_zero {p : MvPolynomial (Fin 3) K}
    (hp : p.totalDegree = 0) (hp0 : p ≠ 0) : IsUnit p := by
  rw [isUnit_iff_totalDegree_of_isReduced]
  refine ⟨?_, hp⟩
  have : p = C (coeff 0 p) := totalDegree_eq_zero_iff_eq_C.mp hp
  have hne : coeff 0 p ≠ 0 := by
    intro h; apply hp0; rw [this, h, map_zero]
  exact isUnit_iff_ne_zero.mpr hne

/-- **A nonsingular homogeneous ternary quadratic over a field is irreducible.**

If `Q` is homogeneous of degree 2, nonzero, and has no nonzero common zero with all its partials
(Jacobian nonsingularity), then `Q` is irreducible in `K[X₀,X₁,X₂]`.

*Route.* Total-degree bookkeeping forces any nontrivial factorization to be degree `1+1`.  Such
factors of a homogeneous product are themselves homogeneous of degree 1.  Product of two
homogeneous linear forms is always singular (common zero of the two forms kills `Q` and all
partials by the product rule).  Contradiction. -/
theorem irreducible_of_isHomogeneous_two_of_nonsingular
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hnonsing : ∀ v : Fin 3 → K, v ≠ 0 → eval v Q = 0 →
      ∃ i, eval v (pderiv i Q) ≠ 0) :
    Irreducible Q := by
  refine (irreducible_iff).mpr ⟨?_, ?_⟩
  · intro hu
    have hdeg := (isUnit_iff_totalDegree_of_isReduced (P := Q)).mp hu
    have := hQ.totalDegree hQ0
    omega
  · intro a b hab
    obtain rfl | ha0 := eq_or_ne a 0
    · simp only [zero_mul] at hab; exact absurd hab hQ0
    obtain rfl | hb0 := eq_or_ne b 0
    · simp only [mul_zero] at hab; exact absurd hab hQ0
    have hdegQ : Q.totalDegree = 2 := hQ.totalDegree hQ0
    have hsum : a.totalDegree + b.totalDegree = 2 := by
      rw [← totalDegree_mul_of_isDomain ha0 hb0, ← hab, hdegQ]
    by_cases haU : IsUnit a
    · exact Or.inl haU
    by_cases hbU : IsUnit b
    · exact Or.inr hbU
    have ha1 : a.totalDegree = 1 := by
      have ha_pos : 1 ≤ a.totalDegree := by
        by_contra h
        have : a.totalDegree = 0 := by omega
        exact haU (isUnit_of_totalDegree_eq_zero this ha0)
      have hb_pos : 1 ≤ b.totalDegree := by
        by_contra h
        have : b.totalDegree = 0 := by omega
        exact hbU (isUnit_of_totalDegree_eq_zero this hb0)
      omega
    have hb1 : b.totalDegree = 1 := by omega
    obtain ⟨haH, hbH⟩ := isHomogeneous_one_of_mul_eq_homog_two hQ hab ha0 hb0 ha1 hb1
    obtain ⟨v, hv0, hQv, hpv⟩ := exists_singular_point_of_mul_homog_one a b haH hbH ha0 hb0
    rw [← hab] at hQv hpv
    obtain ⟨i, hi⟩ := hnonsing v hv0 hQv
    exact absurd (hpv i) hi

/-- The quotient by a nonsingular homogeneous ternary quadratic is a domain. -/
theorem isDomain_quotient_of_isHomogeneous_two_of_nonsingular
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hnonsing : ∀ v : Fin 3 → K, v ≠ 0 → eval v Q = 0 →
      ∃ i, eval v (pderiv i Q) ≠ 0) :
    IsDomain (MvPolynomial (Fin 3) K ⧸ Ideal.span {Q}) := by
  have hirr := irreducible_of_isHomogeneous_two_of_nonsingular Q hQ hQ0 hnonsing
  have hprime : Prime Q := hirr.prime
  haveI : (Ideal.span {Q}).IsPrime := (Ideal.span_singleton_prime hQ0).mpr hprime
  infer_instance

end TernaryQuadratic

end BConicBundleMultisections
