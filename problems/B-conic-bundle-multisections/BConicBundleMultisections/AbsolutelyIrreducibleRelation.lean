/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the LICENSE file.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HomogeneousFactor
public import Mathlib.LinearAlgebra.Dual.Lemmas

/-!
# A homogeneous relation of least degree is absolutely irreducible

Let `Y : σ → k[τ]` be a family of polynomials over a field `k`, thought of as a parametrization
`𝔸^τ → 𝔸^σ`, and let `H` be a **nonzero homogeneous relation of least positive degree**: `H(Y) = 0`
and no nonzero homogeneous relation of smaller positive degree exists.  Then `H` stays irreducible
over *every* extension field of `k`.

## Why this is the right hypothesis

The naive statement is false.  `Irreducible H` alone never ascends: over `ℝ`, the relation
`H = y₀² + y₁²` is irreducible, homogeneous, and vanishes on the constant family
`Y = (0, 0, 1)`, but factors over `ℂ`.  What repairs it is not the base field, and not any
geometric hypothesis on the parametrization — it is *minimality of the degree*.

The reason minimality works is a one-line dimension count that costs nothing.  For each `e`, the
map "coefficient vector of a degree-`e` form" `↦` "its value at `Y`" is `k`-**linear**, so its
kernel is a `k`-subspace whose formation commutes with extension of scalars.  Hence

> a nonzero homogeneous relation of degree `e` over `K` exists **iff** one exists over `k`.

Now if `H = G₁G₂` over `K` with both factors nonunits, both factors are homogeneous of positive
degree (`MvPolynomial.exists_isHomogeneous_of_mul_isHomogeneous`), `k[τ]` is a domain, so one of
`G₁(Y)`, `G₂(Y)` vanishes — a nonzero homogeneous relation over `K` of degree strictly less than
`deg H`.  Descending it contradicts minimality.

## What this replaces

The route one expects to need here is the geometric one: the residual target curve is dominated
by `𝔸²_k`, so its function field embeds in `k(t,s)`, `k` is relatively algebraically closed there
(`algebraicClosure_fractionRing_mvPolynomial_eq_bot`), the function field is a regular extension
of `k`, and therefore the curve is geometrically integral.  That argument is correct but needs
dominance of the parametrization onto `V(H)` — which is exactly what fails in the counterexample
above — and it needs separability of the function-field extension for the non-reduced geometric
factorizations `H = H₁^p`.  The minimal-degree argument needs neither, has no characteristic
hypothesis and no finiteness hypothesis, and is elementary.

## Contents

* `applyCoeffs` — apply a `k`-linear functional to the coefficients of a polynomial over `K`;
  the concrete substitute for "the kernel of a linear map commutes with base change".
* `exists_ne_zero_isHomogeneous_aeval_eq_zero_of_map` — relations descend along `k → K`.
* `IsAbsolutelyIrreducible` — irreducible after every extension of the coefficients.
* `isAbsolutelyIrreducible_of_minimal_homogeneous_relation` — the theorem above.
* `exists_isAbsolutelyIrreducible_homogeneous_aeval_eq_zero` — the packaged consumer form: from
  *any* nonzero homogeneous relation one extracts an absolutely irreducible one.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u v w

open _root_.MvPolynomial

/-! ### Applying a linear functional to the coefficients

`K` is a `k`-vector space, so a nonzero element of `K` is detected by some `k`-linear functional
`π : K →ₗ[k] k`.  Applying `π` coefficientwise is a `k`-linear retraction `K[σ] → k[σ]` of the
coefficient extension, and it is compatible with evaluation at a family defined over `k`.  That
compatibility is the whole content of "kernels commute with base change", in the only form this
file needs. -/

section ApplyCoeffs

variable {k : Type u} [Field k] {K : Type w} [Field K] [Algebra k K] {σ : Type v}

/-- Apply a `k`-linear functional on `K` to every coefficient of a polynomial over `K`. -/
def applyCoeffs (π : K →ₗ[k] k) (p : MvPolynomial σ K) : MvPolynomial σ k :=
  ∑ m ∈ p.support, monomial m (π (coeff m p))

theorem applyCoeffs_eq (π : K →ₗ[k] k) (p : MvPolynomial σ K) :
    applyCoeffs π p = ∑ m ∈ p.support, monomial m (π (coeff m p)) := rfl

@[simp]
theorem coeff_applyCoeffs (π : K →ₗ[k] k) (p : MvPolynomial σ K) (m : σ →₀ ℕ) :
    coeff m (applyCoeffs π p) = π (coeff m p) := by
  classical
  rw [applyCoeffs_eq, coeff_sum]
  simp only [coeff_monomial]
  by_cases hm : m ∈ p.support
  · rw [Finset.sum_eq_single m]
    · simp
    · intro b _ hb
      simp [hb]
    · intro hcon
      exact absurd hm hcon
  · rw [MvPolynomial.notMem_support_iff.mp hm, map_zero]
    refine Finset.sum_eq_zero fun b hb => ?_
    have hbm : b ≠ m := fun h => hm (h ▸ hb)
    simp [hbm]

theorem applyCoeffs_zero (π : K →ₗ[k] k) : applyCoeffs π (0 : MvPolynomial σ K) = 0 := by
  ext m
  simp

theorem applyCoeffs_add (π : K →ₗ[k] k) (p q : MvPolynomial σ K) :
    applyCoeffs π (p + q) = applyCoeffs π p + applyCoeffs π q := by
  ext m
  simp

theorem applyCoeffs_monomial (π : K →ₗ[k] k) (m : σ →₀ ℕ) (c : K) :
    applyCoeffs π (monomial m c) = monomial m (π c) := by
  classical
  ext n
  rw [coeff_applyCoeffs, coeff_monomial, coeff_monomial]
  split_ifs with h
  · rfl
  · exact map_zero π

/-- The key compatibility: `applyCoeffs π` intertwines multiplication by a scalar of `K` with
application of `π` to that scalar, on polynomials whose coefficients already lie in `k`. -/
theorem applyCoeffs_C_mul_map (π : K →ₗ[k] k) (c : K) (w : MvPolynomial σ k) :
    applyCoeffs π (C c * map (algebraMap k K) w) = C (π c) * w := by
  ext m
  rw [coeff_applyCoeffs, coeff_C_mul, coeff_map, coeff_C_mul]
  rw [show c * algebraMap k K (coeff m w) = coeff m w • c by
    rw [Algebra.smul_def, mul_comm]]
  rw [map_smul, smul_eq_mul, mul_comm]

/-- **Evaluation at a family defined over `k` commutes with the coefficient retraction.**

This is the statement that lets a `K`-relation be pushed down to a `k`-relation. -/
theorem applyCoeffs_aeval_map (π : K →ₗ[k] k) {τ : Type w} (Y : σ → MvPolynomial τ k)
    (P : MvPolynomial σ K) :
    applyCoeffs π (aeval (fun i => map (algebraMap k K) (Y i)) P) =
      aeval Y (applyCoeffs π P) := by
  induction P using MvPolynomial.induction_on' with
  | monomial m c =>
      rw [applyCoeffs_monomial, aeval_monomial, aeval_monomial]
      have hprod : (m.prod fun n e => (map (algebraMap k K) (Y n)) ^ e)
          = map (algebraMap k K) (m.prod fun n e => Y n ^ e) := by
        simp only [Finsupp.prod, map_prod, map_pow]
      rw [hprod]
      simp only [MvPolynomial.algebraMap_eq]
      exact applyCoeffs_C_mul_map π c _
  | add p q hp hq =>
      rw [map_add, applyCoeffs_add, applyCoeffs_add, map_add, hp, hq]

end ApplyCoeffs

/-! ### Relations of a fixed degree descend along a field extension -/

/-- **A homogeneous relation over an extension field produces one of the same degree over the
base field.**  The kernel of the `k`-linear map "coefficients of a degree-`e` form `↦` its value at
`Y`" does not grow under extension of scalars; concretely, apply a functional separating one
nonzero coefficient. -/
theorem exists_ne_zero_isHomogeneous_aeval_eq_zero_of_map
    {k : Type u} [Field k] {K : Type w} [Field K] [Algebra k K]
    {σ : Type v} {τ : Type w} (Y : σ → MvPolynomial τ k) {e : ℕ}
    {P : MvPolynomial σ K} (hP : P.IsHomogeneous e) (hP0 : P ≠ 0)
    (hvan : aeval (fun i => map (algebraMap k K) (Y i)) P = 0) :
    ∃ Q : MvPolynomial σ k, Q ≠ 0 ∧ Q.IsHomogeneous e ∧ aeval Y Q = 0 := by
  obtain ⟨m₀, hm₀⟩ : ∃ m : σ →₀ ℕ, coeff m P ≠ 0 := by
    by_contra hall
    push Not at hall
    exact hP0 (MvPolynomial.ext _ _ (by simpa using hall))
  obtain ⟨π, hπ⟩ := Module.Projective.exists_dual_ne_zero k hm₀
  refine ⟨applyCoeffs π P, ?_, ?_, ?_⟩
  · intro hzero
    apply hπ
    have h := congrArg (coeff m₀) hzero
    rwa [coeff_applyCoeffs, coeff_zero] at h
  · intro d hd
    refine hP ?_
    intro hzero
    exact hd (by rw [coeff_applyCoeffs, hzero, map_zero])
  · rw [← applyCoeffs_aeval_map π Y P, hvan, applyCoeffs_zero]

/-! ### Absolute irreducibility -/

/-- A polynomial that stays irreducible after **every** extension of the coefficient field.
Equivalently, for a homogeneous polynomial: the hypersurface it cuts out is geometrically
integral. -/
def IsAbsolutelyIrreducible {k : Type u} [Field k] {σ : Type v}
    (H : MvPolynomial σ k) : Prop :=
  ∀ (K : Type u) [Field K] [Algebra k K], Irreducible (map (algebraMap k K) H)

/-- Absolute irreducibility is irreducibility over the base field too. -/
theorem IsAbsolutelyIrreducible.irreducible
    {k : Type u} [Field k] {σ : Type v} {H : MvPolynomial σ k}
    (h : IsAbsolutelyIrreducible H) : Irreducible H := by
  have hk := h k
  rwa [Algebra.algebraMap_self, MvPolynomial.map_id] at hk

/-- **A nonzero homogeneous relation of least positive degree is absolutely irreducible.**

No hypothesis on the characteristic, on the cardinality of `k`, or on the geometry of the
parametrization `Y`.  Minimality of the degree is doing all the work: a factorization over `K`
would exhibit a relation of smaller positive degree over `K`, and relations of a fixed degree
descend to `k`. -/
theorem isAbsolutelyIrreducible_of_minimal_homogeneous_relation
    {k : Type u} [Field k] {σ : Type v} {τ : Type u}
    (Y : σ → MvPolynomial τ k) {d : ℕ} {H : MvPolynomial σ k}
    (hH : H.IsHomogeneous d) (hH0 : H ≠ 0) (hd : 0 < d)
    (hHvan : aeval Y H = 0)
    (hmin : ∀ e : ℕ, 0 < e → e < d → ∀ Q : MvPolynomial σ k,
      Q.IsHomogeneous e → aeval Y Q = 0 → Q = 0) :
    IsAbsolutelyIrreducible H := by
  intro K _ _
  set φ : k →+* K := algebraMap k K with hφ
  set YK : σ → MvPolynomial τ K := fun i => map φ (Y i) with hYK
  have hmap0 : map φ H ≠ 0 := fun h =>
    hH0 (MvPolynomial.map_injective φ φ.injective (by rw [h, map_zero]))
  have hmaphom : (map φ H).IsHomogeneous d := hH.map φ
  have hcomm : ∀ p : MvPolynomial σ k, aeval YK (map φ p) = map φ (aeval Y p) := by
    intro p
    rw [map_aeval, aeval_def, eval₂_map]
    simp only [coe_eval₂Hom, hYK]
    congr 1
    ext a
    simp [MvPolynomial.algebraMap_eq]
  have hvanK : aeval YK (map φ H) = 0 := by rw [hcomm, hHvan, map_zero]
  constructor
  · intro hunit
    have h0 := (MvPolynomial.isUnit_iff_totalDegree_of_isReduced.mp hunit).2
    have hdeg := hmaphom.totalDegree hmap0
    omega
  · intro G₁ G₂ hG
    have hG1 : G₁ ≠ 0 := by
      intro h
      exact hmap0 (by rw [hG, h, zero_mul])
    have hG2 : G₂ ≠ 0 := by
      intro h
      exact hmap0 (by rw [hG, h, mul_zero])
    obtain ⟨a, b, ha, hb, hab⟩ :=
      BConicBundleMultisections.MvPolynomial.exists_isHomogeneous_of_mul_isHomogeneous
        hG1 hG2 (hG ▸ hmaphom)
    rcases Nat.eq_zero_or_pos a with rfl | hapos
    · left
      rw [MvPolynomial.isUnit_iff_totalDegree_of_isReduced]
      refine ⟨?_, ha.totalDegree hG1⟩
      have hC : G₁ = C (coeff 0 G₁) := by
        calc G₁ = homogeneousComponent 0 G₁ := (homogeneousComponent_eq_self ha).symm
          _ = C (coeff 0 G₁) := homogeneousComponent_zero G₁
      refine isUnit_iff_ne_zero.mpr fun hzero => hG1 ?_
      rw [hC, hzero, map_zero]
    rcases Nat.eq_zero_or_pos b with rfl | hbpos
    · right
      rw [MvPolynomial.isUnit_iff_totalDegree_of_isReduced]
      refine ⟨?_, hb.totalDegree hG2⟩
      have hC : G₂ = C (coeff 0 G₂) := by
        calc G₂ = homogeneousComponent 0 G₂ := (homogeneousComponent_eq_self hb).symm
          _ = C (coeff 0 G₂) := homogeneousComponent_zero G₂
      refine isUnit_iff_ne_zero.mpr fun hzero => hG2 ?_
      rw [hC, hzero, map_zero]
    exfalso
    have hsplit : aeval YK G₁ * aeval YK G₂ = 0 := by
      rw [← map_mul, ← hG, hvanK]
    rcases mul_eq_zero.mp hsplit with h1 | h2
    · obtain ⟨Q, hQ0, hQhom, hQvan⟩ :=
        exists_ne_zero_isHomogeneous_aeval_eq_zero_of_map Y ha hG1 h1
      exact hQ0 (hmin a hapos (by omega) Q hQhom hQvan)
    · obtain ⟨Q, hQ0, hQhom, hQvan⟩ :=
        exists_ne_zero_isHomogeneous_aeval_eq_zero_of_map Y hb hG2 h2
      exact hQ0 (hmin b hbpos (by omega) Q hQhom hQvan)

/-! ### The consumer form -/

/-- **From any nonzero homogeneous relation, an absolutely irreducible one.**

The degrees carrying a nonzero homogeneous relation form a nonempty set of positive naturals;
its least element gives a relation which `isAbsolutelyIrreducible_of_minimal_homogeneous_relation`
makes absolutely irreducible.  This is the drop-in strengthening of
`MvPolynomial.exists_irreducible_isHomogeneous_dvd_aeval_eq_zero`: divisibility of the original
relation is lost, absolute irreducibility is gained, and every consumer in this development uses
only the latter. -/
theorem exists_isAbsolutelyIrreducible_homogeneous_aeval_eq_zero
    {k : Type u} [Field k] {σ : Type v} {τ : Type u}
    (Y : σ → MvPolynomial τ k) {n : ℕ} {Psi : MvPolynomial σ k}
    (hPsi : Psi.IsHomogeneous n) (hPsi0 : Psi ≠ 0) (hn : 0 < n)
    (hvan : aeval Y Psi = 0) :
    ∃ (H : MvPolynomial σ k) (d : ℕ), 0 < d ∧ d ≤ n ∧ H.IsHomogeneous d ∧ H ≠ 0 ∧
      aeval Y H = 0 ∧ IsAbsolutelyIrreducible H := by
  classical
  have hex : ∃ e : ℕ, 0 < e ∧ ∃ Q : MvPolynomial σ k,
      Q.IsHomogeneous e ∧ Q ≠ 0 ∧ aeval Y Q = 0 := ⟨n, hn, Psi, hPsi, hPsi0, hvan⟩
  set d := Nat.find hex with hdef
  obtain ⟨hdpos, H, hHhom, hH0, hHvan⟩ := Nat.find_spec hex
  have hdn : d ≤ n := Nat.find_le ⟨hn, Psi, hPsi, hPsi0, hvan⟩
  refine ⟨H, d, hdpos, hdn, hHhom, hH0, hHvan, ?_⟩
  refine isAbsolutelyIrreducible_of_minimal_homogeneous_relation
    Y hHhom hH0 hdpos hHvan ?_
  intro e hepos hed Q hQhom hQvan
  by_contra hQ0
  exact absurd ⟨hepos, Q, hQhom, hQ0, hQvan⟩ (Nat.find_min hex hed)

end

end BConicBundleMultisections

end
