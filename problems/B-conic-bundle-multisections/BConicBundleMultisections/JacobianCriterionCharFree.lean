/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.FieldTheory.IsAlgClosed.Basic
public import Mathlib.FieldTheory.Perfect
public import Mathlib.FieldTheory.PerfectClosure
public import Mathlib.RingTheory.MvPolynomial.Expand
public import Mathlib.RingTheory.SimpleRing.Basic
public import BConicBundleMultisections.AlgebraicIndependenceJacobian

/-!
# The Jacobian criterion for homogeneous relations, without `CharZero`

`AlgebraicIndependenceJacobian.lean` proves that a nonzero `3 × 3` Jacobian determinant rules out
nonzero homogeneous relations among `Y₀, Y₁, Y₂`, but only over a domain of characteristic zero.
This file removes that hypothesis: the criterion holds over an arbitrary field.

## Why the characteristic-zero proof breaks, and what replaces it

Both proofs begin the same way: a nonzero determinant forces every evaluated partial
`(∂Ψ/∂X_a)(Y)` to vanish (`aeval_pderiv_eq_zero`, characteristic-free), and induction on the degree
then gives `pderiv a Ψ = 0` for all `a`.  In characteristic zero Euler's identity turns that into
`d • Ψ = 0` and one is done.  In characteristic `p` it does not: a `p`-th power has all partials
zero without being constant, and `d • Ψ = 0` only says `p ∣ d`.

The fix is to descend instead of stopping.  All partials vanishing means every exponent occurring
in `Ψ` is divisible by `p` (`exists_expand_eq_of_forall_pderiv_eq_zero`), so `Ψ = expand p Φ`; over
a perfect field one may extract `p`-th roots of the coefficients, so `Ψ = Θ ^ p`
(`expand_eq_map_frobeniusEquiv_symm_pow`).  Then `Θ` is homogeneous of degree `d / p < d` and
`Θ(Y) ^ p = Ψ(Y) = 0` forces `Θ(Y) = 0`, so the *same* strong induction that supplied
`pderiv a Ψ = 0` also supplies `Θ = 0`, hence `Ψ = 0`.  No separate minimal counterexample is
needed: one strong induction on the degree serves both descents.

Perfectness is used only inside that positive-characteristic descent.  Over a general field one
base-changes to the perfect closure (`PerfectClosure k p`): every hypothesis ascends along
`MvPolynomial.map (PerfectClosure.of k p)`, the perfect-field argument applies upstairs, and the
conclusion `Ψ = 0` descends by injectivity of the coefficient map (row 2 of the
`GeometricPointDescent` trichotomy).

## Main results

* `MvPolynomial.exists_expand_eq_of_forall_pderiv_eq_zero`: in characteristic `p`, a polynomial all
  of whose partial derivatives vanish is in the range of `MvPolynomial.expand p`.
* `MvPolynomial.expand_eq_map_frobeniusEquiv_symm_pow`: over a perfect ring, `expand p` lands in
  `p`-th powers.  This is the multivariate analogue of `PerfectRing.polynomial_expand_eq`.
* `BConicBundleMultisections.eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField`: the
  headline statement, over an arbitrary field (perfectness is intermediate, not a hypothesis).

Neither of the two `MvPolynomial` lemmas is in Mathlib; both are stated in the generality they
deserve, so that they could be upstreamed as they stand.
-/

@[expose] public section

namespace MvPolynomial

open Finsupp

variable {σ : Type*}

/-! ### Homogeneity in terms of `Finsupp.degree` -/

/-- `Finsupp.weight 1` is `Finsupp.degree`, applied form.  Mathlib has the unapplied
`Finsupp.degree_eq_weight_one`, which does not rewrite through `MvPolynomial.IsHomogeneous`
because the latter mentions `(1 : σ → ℕ)` rather than `fun _ ↦ 1`. -/
theorem weight_one_eq_degree (m : σ →₀ ℕ) : Finsupp.weight (1 : σ → ℕ) m = m.degree := by
  simp [Finsupp.weight_apply, Finsupp.degree_apply, Finsupp.sum]

/-- A polynomial all of whose support exponents have degree `n` is homogeneous of degree `n`. -/
theorem isHomogeneous_of_forall_degree_eq {R : Type*} [CommSemiring R] {φ : MvPolynomial σ R}
    {n : ℕ} (h : ∀ m ∈ φ.support, m.degree = n) : φ.IsHomogeneous n := fun m hm => by
  rw [weight_one_eq_degree]
  exact h m (mem_support_iff.mpr hm)

/-- The degree of a support exponent of a homogeneous polynomial. -/
theorem IsHomogeneous.degree_eq {R : Type*} [CommSemiring R] {φ : MvPolynomial σ R} {n : ℕ}
    (h : φ.IsHomogeneous n) {m : σ →₀ ℕ} (hm : coeff m φ ≠ 0) : m.degree = n := by
  rw [← weight_one_eq_degree]
  exact h hm

/-! ### Polynomials with vanishing derivatives are expansions -/

section CharP

variable {R : Type*} [CommRing R] (p : ℕ) [Fact p.Prime] [CharP R p]

/-- In a commutative ring of prime characteristic `p`, a natural number not divisible by `p` casts
to a unit: the cast factors through the field `ZMod p`, where the class of `n` is invertible.

No reducedness or domain hypothesis is needed. -/
theorem isUnit_natCast_of_not_dvd {n : ℕ} (hn : ¬ p ∣ n) : IsUnit (n : R) := by
  have h : IsUnit ((n : ZMod p)) :=
    (ZMod.isUnit_iff_coprime n p).mpr ((Fact.out : p.Prime).coprime_iff_not_dvd.mpr hn).symm
  simpa using h.map (ZMod.castHom (dvd_refl p) R)

/-- If every partial derivative of `Ψ` vanishes then, in characteristic `p`, every exponent
occurring in `Ψ` is a multiple of `p`. -/
theorem dvd_of_forall_pderiv_eq_zero {Ψ : MvPolynomial σ R}
    (h : ∀ i : σ, pderiv i Ψ = 0) {m : σ →₀ ℕ} (hm : coeff m Ψ ≠ 0) (i : σ) : p ∣ m i := by
  by_contra hdvd
  -- `p ∤ m i` forces in particular `m i ≠ 0`, so `m = (m - single i 1) + single i 1`.
  have hmi : m i ≠ 0 := fun h0 => hdvd (h0 ▸ dvd_zero p)
  have hsub : m - single i 1 + single i 1 = m := Finsupp.sub_add_single_one_cancel hmi
  have happ : (m - single i 1 : σ →₀ ℕ) i = m i - 1 := by simp
  -- Read off the `(m - single i 1)`-coefficient of `pderiv i Ψ = 0`.
  have hco := coeff_pderiv (i := i) Ψ (m - single i 1)
  rw [h i, coeff_zero, hsub, happ] at hco
  -- `((m i - 1 : ℕ) : R) + 1 = ((m i : ℕ) : R)` because `m i ≠ 0`.
  have hcast : ((m i - 1 : ℕ) : R) + 1 = ((m i : ℕ) : R) := by
    obtain ⟨j, hj⟩ := Nat.exists_eq_succ_of_ne_zero hmi
    simp [hj]
  rw [hcast] at hco
  exact hm ((isUnit_natCast_of_not_dvd p hdvd).mul_left_eq_zero.mp hco.symm)

/-- **A polynomial with vanishing partial derivatives is an expansion.**

In characteristic `p` prime, if `pderiv i Ψ = 0` for every variable `i`, then `Ψ = expand p Φ` for
some `Φ`.  Mathlib has `MvPolynomial.expand` but no description of its range; this is that
description, in the direction that has content. -/
theorem exists_expand_eq_of_forall_pderiv_eq_zero {Ψ : MvPolynomial σ R}
    (h : ∀ i : σ, pderiv i Ψ = 0) : ∃ Φ : MvPolynomial σ R, expand p Φ = Ψ := by
  classical
  refine ⟨∑ m ∈ Ψ.support,
    monomial (Finsupp.mapRange (fun x : ℕ => x / p) (Nat.zero_div p) m) (coeff m Ψ), ?_⟩
  rw [map_sum]
  refine (Finset.sum_congr rfl fun m hm => ?_).trans (support_sum_monomial_coeff Ψ)
  rw [expand_monomial]
  have hexp : p • Finsupp.mapRange (fun x : ℕ => x / p) (Nat.zero_div p) m = m := by
    refine Finsupp.ext fun i => ?_
    rw [Finsupp.smul_apply, smul_eq_mul, Finsupp.mapRange_apply]
    exact Nat.mul_div_cancel' (dvd_of_forall_pderiv_eq_zero p h (mem_support_iff.mp hm) i)
  rw [hexp]

end CharP

/-! ### Expansions are `p`-th powers over a perfect ring -/

/-- **Over a perfect ring, `expand p` lands in `p`-th powers.**

This is the multivariate analogue of `PerfectRing.polynomial_expand_eq`, which Mathlib has only for
`Polynomial`.  The `p`-th root is obtained by taking `p`-th roots of the coefficients. -/
theorem expand_eq_map_frobeniusEquiv_symm_pow {R : Type*} [CommSemiring R] (p : ℕ) [ExpChar R p]
    [PerfectRing R p] (f : MvPolynomial σ R) :
    expand p f = (f.map (frobeniusEquiv R p).symm) ^ p := by
  rw [← map_frobenius_expand (R := R) p (f := f.map (frobeniusEquiv R p).symm), map_expand,
    map_map, frobenius_comp_frobeniusEquiv_symm, map_id]

/-! ### Homogeneous `p`-th roots -/

/-- **Homogeneous `p`-th root.**

Over a perfect ring of prime characteristic `p`, a nonzero homogeneous form of degree `d` all of
whose partial derivatives vanish is the `p`-th power of a homogeneous form of degree `d / p`.  This
is the whole of the positive-characteristic descent step. -/
theorem exists_isHomogeneous_pow_eq_of_forall_pderiv_eq_zero {R : Type*} [CommRing R] (p : ℕ)
    [Fact p.Prime] [CharP R p] [PerfectRing R p] {Ψ : MvPolynomial σ R} {d : ℕ}
    (hΨ : Ψ.IsHomogeneous d) (hne : Ψ ≠ 0) (h : ∀ i : σ, pderiv i Ψ = 0) :
    ∃ (e : ℕ) (Θ : MvPolynomial σ R), p * e = d ∧ Θ.IsHomogeneous e ∧ Θ ^ p = Ψ := by
  classical
  have hp : 0 < p := (Fact.out : p.Prime).pos
  obtain ⟨Φ, hΦ⟩ := exists_expand_eq_of_forall_pderiv_eq_zero p h
  have hΦne : Φ ≠ 0 := fun h0 => hne (by rw [← hΦ, h0, map_zero])
  -- Every exponent of `Φ` is scaled by `p` inside `Ψ`, so all of them have the same degree.
  have hdeg : ∀ m ∈ Φ.support, p * m.degree = d := by
    intro m hm
    have hco : coeff (p • m) Ψ ≠ 0 := by
      rw [← hΦ, coeff_expand_smul p hp.ne' Φ m]; exact mem_support_iff.mp hm
    have := hΨ.degree_eq hco
    rwa [map_nsmul, smul_eq_mul] at this
  obtain ⟨m₀, hm₀⟩ := support_nonempty.mpr hΦne
  refine ⟨m₀.degree, Φ.map (frobeniusEquiv R p).symm, hdeg m₀ hm₀, ?_, ?_⟩
  · refine IsHomogeneous.map (isHomogeneous_of_forall_degree_eq fun m hm => ?_) _
    exact Nat.eq_of_mul_eq_mul_left hp ((hdeg m hm).trans (hdeg m₀ hm₀).symm)
  · rw [← expand_eq_map_frobeniusEquiv_symm_pow, hΦ]

end MvPolynomial

namespace BConicBundleMultisections

open MvPolynomial
open scoped Matrix

universe u v

/-- **The evaluated partials vanish.**

The characteristic-free half of the Jacobian criterion: if `Ψ` is homogeneous and vanishes on `Y`,
then a nonzero Jacobian determinant forces each `(∂Ψ/∂X_a)(Y)` to vanish too.

Euler's identity supplies the first of the three linear relations satisfied by the vector of
evaluated partials, the chain rule `pderiv_aeval` the other two; `Matrix.adjugate` then kills the
vector.  This is exactly the first half of `eq_zero_of_isHomogeneous_of_aeval_eq_zero`, extracted so
that it can be reused. -/
theorem aeval_pderiv_eq_zero {k : Type u} [CommRing k] [IsDomain k]
    {τ : Type v} [Fintype τ] [DecidableEq τ]
    (Y : Fin 3 → MvPolynomial τ k) (i₁ i₂ : τ)
    (hdet : (Matrix.of ![Y, fun a => pderiv i₁ (Y a), fun a => pderiv i₂ (Y a)]).det ≠ 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) k) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval Y Ψ = 0) (a : Fin 3) : aeval Y (pderiv a Ψ) = 0 := by
  classical
  set M := Matrix.of ![Y, fun a => pderiv i₁ (Y a), fun a => pderiv i₂ (Y a)] with hM
  let v : Fin 3 → MvPolynomial τ k := fun a => aeval Y (pderiv a Ψ)
  -- The three relations satisfied by the evaluated partials.
  have hrow0 : ∑ a : Fin 3, Y a * v a = 0 := by
    have h := congrArg (aeval Y) hΨ.sum_X_mul_pderiv
    rw [map_sum, map_nsmul, hvan, smul_zero] at h
    rw [← h]
    exact Finset.sum_congr rfl fun a _ => by rw [map_mul, aeval_X]
  have hrow1 : ∑ a : Fin 3, pderiv i₁ (Y a) * v a = 0 := by
    have h := pderiv_aeval Y i₁ Ψ
    rw [hvan, map_zero] at h
    rw [show (∑ a : Fin 3, pderiv i₁ (Y a) * v a)
        = ∑ a : Fin 3, v a * pderiv i₁ (Y a) from
      Finset.sum_congr rfl fun a _ => mul_comm _ _]
    exact h.symm
  have hrow2 : ∑ a : Fin 3, pderiv i₂ (Y a) * v a = 0 := by
    have h := pderiv_aeval Y i₂ Ψ
    rw [hvan, map_zero] at h
    rw [show (∑ a : Fin 3, pderiv i₂ (Y a) * v a)
        = ∑ a : Fin 3, v a * pderiv i₂ (Y a) from
      Finset.sum_congr rfl fun a _ => mul_comm _ _]
    exact h.symm
  have hMv : M *ᵥ v = 0 := by
    funext r
    fin_cases r <;>
      simp only [hM, Matrix.mulVec, dotProduct, Matrix.of_apply, Pi.zero_apply]
    · exact hrow0
    · exact hrow1
    · exact hrow2
  -- A nonzero determinant kills `v`.
  have hadj : (M.det) • v = 0 := by
    have h := congrArg (fun w => M.adjugate *ᵥ w) hMv
    simp only [Matrix.mulVec_mulVec, Matrix.adjugate_mul, Matrix.mulVec_zero] at h
    rwa [Matrix.smul_mulVec, Matrix.one_mulVec] at h
  have hcomp := congrFun hadj a
  simp only [Pi.smul_apply, Pi.zero_apply, smul_eq_mul] at hcomp
  exact (mul_eq_zero.mp hcomp).resolve_left hdet

/-- **A nonzero Jacobian determinant rules out homogeneous relations, over any perfect field.**

Internal engine: perfectness is used through
`MvPolynomial.exists_isHomogeneous_pow_eq_of_forall_pderiv_eq_zero`, where `p`-th roots of the
coefficients of `Ψ` are taken.  The public statement
`eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField` removes this hypothesis by
base-changing to a perfect closure. -/
theorem eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField_of_perfect
    {k : Type u} [Field k] [PerfectField k] {τ : Type v} [Fintype τ] [DecidableEq τ]
    (Y : Fin 3 → MvPolynomial τ k) (i₁ i₂ : τ)
    (hdet : (Matrix.of ![Y, fun a => pderiv i₁ (Y a), fun a => pderiv i₂ (Y a)]).det ≠ 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) k) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval Y Ψ = 0) : Ψ = 0 := by
  classical
  induction d using Nat.strong_induction_on generalizing Ψ with
  | _ d ih =>
    have hvzero : ∀ a : Fin 3, aeval Y (pderiv a Ψ) = 0 :=
      aeval_pderiv_eq_zero Y i₁ i₂ hdet d Ψ hΨ hvan
    rcases Nat.eq_zero_or_pos d with hd | hd
    · -- Degree zero: `Ψ` is a constant, and it evaluates to zero.
      subst hd
      rw [← totalDegree_zero_iff_isHomogeneous, totalDegree_eq_zero_iff_eq_C] at hΨ
      rw [hΨ] at hvan ⊢
      simpa using hvan
    -- Every partial vanishes on `Y` and has degree `d - 1`, so induction kills it.
    have hpart : ∀ a : Fin 3, pderiv a Ψ = 0 := fun a =>
      ih (d - 1) (by omega) _ hΨ.pderiv (hvzero a)
    by_contra hne
    obtain ⟨q, hq⟩ := CharP.exists k
    rcases CharP.char_is_prime_or_zero k q with hqprime | hq0
    · -- Characteristic `q` prime: take a `q`-th root and descend.
      haveI : Fact q.Prime := ⟨hqprime⟩
      obtain ⟨e, Θ, hqe, hΘhom, hΘpow⟩ :=
        exists_isHomogeneous_pow_eq_of_forall_pderiv_eq_zero q hΨ hne hpart
      have hΘne : Θ ≠ 0 := fun h0 => hne (by rw [← hΘpow, h0, zero_pow hqprime.ne_zero])
      have hΘvan : aeval Y Θ = 0 := by
        have hpow : (aeval Y Θ) ^ q = 0 := by rw [← map_pow, hΘpow, hvan]
        exact (pow_eq_zero_iff hqprime.ne_zero).mp hpow
      have he : 0 < e := by
        rcases Nat.eq_zero_or_pos e with h0 | h0
        · rw [h0, Nat.mul_zero] at hqe; omega
        · exact h0
      have hlt : e < d := by
        calc e < 2 * e := by omega
          _ ≤ q * e := Nat.mul_le_mul hqprime.two_le le_rfl
          _ = d := hqe
      exact hΘne (ih e hlt Θ hΘhom hΘvan)
    · -- Characteristic zero: Euler's identity gives `d • Ψ = 0`.
      subst hq0
      haveI : CharZero k := CharP.charP_to_charZero k
      have h := hΨ.sum_X_mul_pderiv
      simp only [hpart, mul_zero, Finset.sum_const_zero] at h
      have hcast : (d : MvPolynomial (Fin 3) k) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
      rw [nsmul_eq_mul] at h
      exact hne ((mul_eq_zero.mp h.symm).resolve_left hcast)

/-- **A nonzero Jacobian determinant rules out homogeneous relations, over any field.**

This is `eq_zero_of_isHomogeneous_of_aeval_eq_zero` of `AlgebraicIndependenceJacobian.lean` with
`[CharZero k]` deleted entirely.  Perfectness is intermediate, not a hypothesis: in characteristic
zero every field is perfect (`PerfectField.ofCharZero`); in characteristic `p` one base-changes to
the perfect closure `PerfectClosure k p`, applies the perfect-field criterion upstairs, and
descends the vanishing of `Ψ` by injectivity of the coefficient map.

The historical name keeps every existing call site valid. -/
theorem eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField
    {k : Type u} [Field k] {τ : Type v} [Fintype τ] [DecidableEq τ]
    (Y : Fin 3 → MvPolynomial τ k) (i₁ i₂ : τ)
    (hdet : (Matrix.of ![Y, fun a => pderiv i₁ (Y a), fun a => pderiv i₂ (Y a)]).det ≠ 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) k) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval Y Ψ = 0) : Ψ = 0 := by
  classical
  obtain ⟨p, hp⟩ := CharP.exists k
  rcases CharP.char_is_prime_or_zero k p with hpprime | hp0
  · -- Characteristic `p` prime: base-change to the perfect closure.
    haveI : Fact p.Prime := ⟨hpprime⟩
    let L := PerfectClosure k p
    let φ : k →+* L := PerfectClosure.of k p
    have hφ : Function.Injective φ := RingHom.injective φ
    set YL : Fin 3 → MvPolynomial τ L := fun a => map φ (Y a) with hYL
    set M := Matrix.of ![Y, fun a => pderiv i₁ (Y a), fun a => pderiv i₂ (Y a)] with hM
    set ML := Matrix.of ![YL, fun a => pderiv i₁ (YL a), fun a => pderiv i₂ (YL a)] with hML
    have hMmap : ML = M.map (map φ) := by
      ext i j
      fin_cases i <;>
        simp [hML, hM, hYL, Matrix.map_apply, Matrix.of_apply, pderiv_map]
    have hdetL : ML.det ≠ 0 := by
      intro h0
      have hmap0 : map φ M.det = 0 := by
        rw [RingHom.map_det, RingHom.mapMatrix_apply, ← hMmap, h0]
      exact hdet ((map_eq_zero_iff _ (map_injective φ hφ)).mp hmap0)
    have hΨL : (map φ Ψ).IsHomogeneous d := hΨ.map φ
    have hvanL : aeval YL (map φ Ψ) = 0 := by
      have hcomm : aeval YL (map φ Ψ) = map φ (aeval Y Ψ) := by
        rw [map_aeval, aeval_def, eval₂_map]
        simp only [coe_eval₂Hom, hYL]
        congr 1
        ext a
        simp [MvPolynomial.algebraMap_eq]
      rw [hcomm, hvan, map_zero]
    have hmap0 : map φ Ψ = 0 :=
      eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField_of_perfect
        YL i₁ i₂ hdetL d (map φ Ψ) hΨL hvanL
    exact (map_eq_zero_iff _ (map_injective φ hφ)).mp hmap0
  · -- Characteristic zero: every field is perfect.
    subst hp0
    haveI : CharZero k := CharP.charP_to_charZero k
    haveI : PerfectField k := PerfectField.ofCharZero
    exact eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField_of_perfect
      Y i₁ i₂ hdet d Ψ hΨ hvan

/-- Over an algebraically closed field the theorem above is a literal drop-in replacement for
`eq_zero_of_isHomogeneous_of_aeval_eq_zero` at every call site — with `[CharZero k]` simply
deleted from the hypotheses. -/
example {k : Type u} [Field k] [IsAlgClosed k] {τ : Type v} [Fintype τ] [DecidableEq τ]
    (Y : Fin 3 → MvPolynomial τ k) (i₁ i₂ : τ)
    (hdet : (Matrix.of ![Y, fun a => pderiv i₁ (Y a), fun a => pderiv i₂ (Y a)]).det ≠ 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) k) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval Y Ψ = 0) : Ψ = 0 :=
  eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField Y i₁ i₂ hdet d Ψ hΨ hvan

end BConicBundleMultisections

