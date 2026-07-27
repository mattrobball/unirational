/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.FieldTheory.AlgebraicClosure
public import Mathlib.FieldTheory.RatFunc.Basic
public import Mathlib.RingTheory.Polynomial.RationalRoot
public import Mathlib.RingTheory.Polynomial.UniqueFactorization
public import Mathlib.Algebra.MvPolynomial.Nilpotent

/-!
# A field is relatively algebraically closed in a purely transcendental extension

The headline statement is

```
algebraicClosure k (FractionRing (MvPolynomial σ k)) = ⊥
```

for an arbitrary field `k` and an arbitrary index type `σ`: an element of `k(t₁, …, tₙ)`
(or of `k(tᵢ : i ∈ σ)` for infinite `σ`) which is algebraic over `k` already lies in `k`.
There is **no characteristic hypothesis** and no finiteness hypothesis on `σ`.

## Route

The proof is uniform in `σ` — no reduction to one variable, no transcendence bases:

* `MvPolynomial σ k` is a unique factorization domain, hence integrally closed in its
  fraction field.  So an element of `k(σ)` integral over `k` is *a fortiori* integral over
  `MvPolynomial σ k`, hence is a polynomial (`IsIntegrallyClosed.isIntegral_iff`).
* A nonzero polynomial integral over the field `k` is a unit (`IsIntegral.isUnit_of_ne_zero`,
  from the nonvanishing constant coefficient of its minimal polynomial), and the units of
  `MvPolynomial σ k` are the nonzero constants
  (`MvPolynomial.isUnit_iff_eq_C_of_isReduced`).  So it is a constant.

Mathlib already knows the one-variable transcendence statement
`RatFunc.transcendental_of_ne_C`, but the multivariate statement — and the `= ⊥` /
`IsIntegrallyClosedIn` packagings — are not there, so they are built here from the criterion
`algebraicClosure_eq_bot_of_forall_isIntegral` below.

## Consumer-facing forms

Applications never see `FractionRing (MvPolynomial σ k)` on the nose; they see some `k`-algebra
`E` (a coordinate ring, or a ring of global sections) that *embeds* into it.  The lemmas
`exists_algebraMap_eq_of_isIntegral_of_injective`,
`algebraMap_bijective_of_isIntegral_of_injective` and
`ringHom_bijective_of_isIntegral_of_injective` package the conclusion for that situation; the
last is a drop-in replacement for `IsAlgClosed.ringHom_bijective_of_isIntegral` with
`[IsAlgClosed k]` weakened to "`k` is relatively algebraically closed in something `E` embeds
into".
-/

@[expose] public section

universe u v w

/-! ### A nonzero integral element of a domain over a field is a unit -/

/-- A nonzero element of a domain that is integral over a base field is a unit.  (The inverse is
read off from the nonzero constant coefficient of the minimal polynomial.) -/
theorem IsIntegral.isUnit_of_ne_zero {k A : Type*} [Field k] [CommRing A] [IsDomain A]
    [Algebra k A] {x : A} (hx : IsIntegral k x) (hx0 : x ≠ 0) : IsUnit x := by
  have h0 : (minpoly k x).coeff 0 ≠ 0 := minpoly.coeff_zero_ne_zero hx hx0
  have hev : Polynomial.aeval x (minpoly k x) = 0 := minpoly.aeval k x
  rw [← Polynomial.X_mul_divX_add (minpoly k x), map_add, map_mul, Polynomial.aeval_X,
    Polynomial.aeval_C] at hev
  have key : x * Polynomial.aeval x (minpoly k x).divX
      = -algebraMap k A ((minpoly k x).coeff 0) := eq_neg_of_add_eq_zero_left hev
  refine IsUnit.of_mul_eq_one
    (Polynomial.aeval x (minpoly k x).divX * algebraMap k A (-((minpoly k x).coeff 0)⁻¹)) ?_
  rw [← mul_assoc, key, ← map_neg, ← map_mul, neg_mul_neg, mul_inv_cancel₀ h0, map_one]

/-! ### Elements of a polynomial ring that are algebraic over the coefficient field -/

/-- A multivariate polynomial over a field which is integral over that field is a constant. -/
theorem MvPolynomial.exists_eq_C_of_isIntegral {k : Type u} [Field k] {σ : Type v}
    {p : MvPolynomial σ k} (hp : IsIntegral k p) : ∃ c : k, p = MvPolynomial.C c := by
  rcases eq_or_ne p 0 with rfl | hp0
  · exact ⟨0, by simp⟩
  · obtain ⟨c, -, hc⟩ :=
      MvPolynomial.isUnit_iff_eq_C_of_isReduced.mp (hp.isUnit_of_ne_zero hp0)
    exact ⟨c, hc⟩

/-- A multivariate polynomial over a field is integral over that field iff it is a constant. -/
theorem MvPolynomial.isIntegral_iff_exists_eq_C {k : Type u} [Field k] {σ : Type v}
    {p : MvPolynomial σ k} : IsIntegral k p ↔ ∃ c : k, p = MvPolynomial.C c :=
  ⟨MvPolynomial.exists_eq_C_of_isIntegral, by
    rintro ⟨c, rfl⟩
    rw [← MvPolynomial.algebraMap_eq]
    exact isIntegral_algebraMap⟩

/-- A univariate polynomial over a field which is integral over that field is a constant. -/
theorem Polynomial.exists_eq_C_of_isIntegral {k : Type u} [Field k] {p : Polynomial k}
    (hp : IsIntegral k p) : ∃ c : k, p = Polynomial.C c := by
  rcases eq_or_ne p 0 with rfl | hp0
  · exact ⟨0, by simp⟩
  · obtain ⟨c, -, hc⟩ := Polynomial.isUnit_iff.mp (hp.isUnit_of_ne_zero hp0)
    exact ⟨c, hc.symm⟩

/-! ### The general criterion -/

/-- **Relative algebraic closedness from integral closedness.**  Let `k` be a field, `R` an
integrally closed domain containing `k` and `K` its fraction field.  If every element of `R`
integral over `k` is a scalar, then `k` is relatively algebraically closed in `K`. -/
theorem algebraicClosure_eq_bot_of_forall_isIntegral
    {k : Type u} {R : Type v} {K : Type w} [Field k] [CommRing R] [IsDomain R]
    [IsIntegrallyClosed R] [Field K] [Algebra R K] [IsFractionRing R K]
    [Algebra k R] [Algebra k K] [IsScalarTower k R K]
    (h : ∀ p : R, IsIntegral k p → ∃ c : k, algebraMap k R c = p) :
    algebraicClosure k K = ⊥ := by
  refine bot_unique fun x hx => ?_
  have hxk : IsIntegral k x := mem_algebraicClosure_iff'.1 hx
  obtain ⟨y, hy⟩ := IsIntegrallyClosed.isIntegral_iff.1 (hxk.tower_top (A := R))
  have hyk : IsIntegral k y :=
    IsIntegral.tower_bot (IsFractionRing.injective R K) (by rw [hy]; exact hxk)
  obtain ⟨c, hc⟩ := h y hyk
  exact IntermediateField.mem_bot.2 ⟨c, by rw [IsScalarTower.algebraMap_apply k R K, hc, hy]⟩

/-! ### The main statements -/

/-- **A field is relatively algebraically closed in a purely transcendental extension.**
Stated for an arbitrary fraction field `K` of `MvPolynomial σ k`. -/
theorem algebraicClosure_eq_bot_of_isFractionRing_mvPolynomial
    {k : Type u} [Field k] (σ : Type v) (K : Type w) [Field K]
    [Algebra (MvPolynomial σ k) K] [IsFractionRing (MvPolynomial σ k) K]
    [Algebra k K] [IsScalarTower k (MvPolynomial σ k) K] :
    algebraicClosure k K = ⊥ :=
  algebraicClosure_eq_bot_of_forall_isIntegral (R := MvPolynomial σ k) fun p hp => by
    obtain ⟨c, hc⟩ := MvPolynomial.exists_eq_C_of_isIntegral hp
    exact ⟨c, by rw [MvPolynomial.algebraMap_eq]; exact hc.symm⟩

/-- **A field is relatively algebraically closed in a purely transcendental extension.**
An element of `k(tᵢ : i ∈ σ)` algebraic over `k` lies in `k`.  No hypothesis on the
characteristic of `k`, none on the cardinality of `σ`. -/
theorem algebraicClosure_fractionRing_mvPolynomial_eq_bot
    {k : Type u} [Field k] (σ : Type v) :
    algebraicClosure k (FractionRing (MvPolynomial σ k)) = ⊥ :=
  algebraicClosure_eq_bot_of_isFractionRing_mvPolynomial σ _

/-- The one-variable case, for an arbitrary fraction field of `k[X]`. -/
theorem algebraicClosure_eq_bot_of_isFractionRing_polynomial
    {k : Type u} [Field k] (K : Type v) [Field K]
    [Algebra (Polynomial k) K] [IsFractionRing (Polynomial k) K]
    [Algebra k K] [IsScalarTower k (Polynomial k) K] :
    algebraicClosure k K = ⊥ :=
  algebraicClosure_eq_bot_of_forall_isIntegral fun p hp => by
    obtain ⟨c, hc⟩ := Polynomial.exists_eq_C_of_isIntegral hp
    exact ⟨c, by rw [← Polynomial.C_eq_algebraMap] at *; exact hc.symm⟩

/-- The one-variable case for `RatFunc k`. -/
theorem algebraicClosure_ratFunc_eq_bot {k : Type u} [Field k] :
    algebraicClosure k (RatFunc k) = ⊥ :=
  algebraicClosure_eq_bot_of_isFractionRing_polynomial _

/-- The one-variable case for `FractionRing k[X]`. -/
theorem algebraicClosure_fractionRing_polynomial_eq_bot {k : Type u} [Field k] :
    algebraicClosure k (FractionRing (Polynomial k)) = ⊥ :=
  algebraicClosure_eq_bot_of_isFractionRing_polynomial _

/-! ### `IsIntegrallyClosedIn` phrasing -/

/-- For a field extension, relative algebraic closedness is exactly integral closedness. -/
theorem algebraicClosure_eq_bot_iff_isIntegrallyClosedIn
    {k K : Type*} [Field k] [Field K] [Algebra k K] :
    algebraicClosure k K = ⊥ ↔ IsIntegrallyClosedIn k K := by
  refine ⟨fun h => isIntegrallyClosedIn_iff.2 ⟨(algebraMap k K).injective, fun {x} hx => ?_⟩,
    fun h => bot_unique fun x hx => ?_⟩
  · exact IntermediateField.mem_bot.1 (h ▸ mem_algebraicClosure_iff'.2 hx)
  · exact IntermediateField.mem_bot.2
      (IsIntegrallyClosedIn.algebraMap_eq_of_integral (mem_algebraicClosure_iff'.1 hx))

/-- `k` is integrally closed in `k(tᵢ : i ∈ σ)`. -/
theorem isIntegrallyClosedIn_fractionRing_mvPolynomial
    {k : Type u} [Field k] (σ : Type v) :
    IsIntegrallyClosedIn k (FractionRing (MvPolynomial σ k)) :=
  algebraicClosure_eq_bot_iff_isIntegrallyClosedIn.1
    (algebraicClosure_fractionRing_mvPolynomial_eq_bot σ)

/-! ### Consumer-facing corollaries

These are the forms the project actually applies: the algebra of interest is not
`k(t₁, …, tₙ)` itself but a `k`-algebra that embeds into it. -/

/-- If `E` is a `k`-algebra admitting an injective `k`-algebra map into a field `K` in which `k`
is relatively algebraically closed, then every element of `E` integral over `k` is a scalar. -/
theorem exists_algebraMap_eq_of_isIntegral_of_injective
    {k E K : Type*} [Field k] [CommRing E] [Algebra k E] [Field K] [Algebra k K]
    (h : algebraicClosure k K = ⊥) (f : E →ₐ[k] K) (hf : Function.Injective f)
    {x : E} (hx : IsIntegral k x) : ∃ c : k, algebraMap k E c = x := by
  obtain ⟨c, hc⟩ :=
    IntermediateField.mem_bot.1 (h ▸ mem_algebraicClosure_iff'.2 (hx.map f))
  exact ⟨c, hf (by rw [AlgHom.commutes, hc])⟩

/-- The same conclusion phrased with `IsAlgebraic`. -/
theorem exists_algebraMap_eq_of_isAlgebraic_of_injective
    {k E K : Type*} [Field k] [CommRing E] [IsDomain E] [Algebra k E] [Field K] [Algebra k K]
    (h : algebraicClosure k K = ⊥) (f : E →ₐ[k] K) (hf : Function.Injective f)
    {x : E} (hx : IsAlgebraic k x) : ∃ c : k, algebraMap k E c = x :=
  exists_algebraMap_eq_of_isIntegral_of_injective h f hf hx.isIntegral

/-- Specialization of `exists_algebraMap_eq_of_isIntegral_of_injective` to a `k`-algebra `E`
embedded in a purely transcendental extension of `k`: **if `E` embeds in `k(tᵢ : i ∈ σ)`, every
element of `E` integral over `k` is a scalar.**  This is the form the project applies. -/
theorem exists_algebraMap_eq_of_isIntegral_of_algHom_isFractionRing_mvPolynomial
    {k E : Type*} [Field k] [CommRing E] [Algebra k E] (σ : Type*) {K : Type*} [Field K]
    [Algebra (MvPolynomial σ k) K] [IsFractionRing (MvPolynomial σ k) K]
    [Algebra k K] [IsScalarTower k (MvPolynomial σ k) K]
    (f : E →ₐ[k] K) (hf : Function.Injective f)
    {x : E} (hx : IsIntegral k x) : ∃ c : k, algebraMap k E c = x :=
  exists_algebraMap_eq_of_isIntegral_of_injective
    (algebraicClosure_eq_bot_of_isFractionRing_mvPolynomial σ K) f hf hx

/-- The same for `FractionRing (MvPolynomial σ k)` on the nose. -/
theorem exists_algebraMap_eq_of_isIntegral_of_algHom_fractionRing_mvPolynomial
    {k E : Type u} [Field k] [CommRing E] [Algebra k E] {σ : Type v}
    (f : E →ₐ[k] FractionRing (MvPolynomial σ k)) (hf : Function.Injective f)
    {x : E} (hx : IsIntegral k x) : ∃ c : k, algebraMap k E c = x :=
  exists_algebraMap_eq_of_isIntegral_of_algHom_isFractionRing_mvPolynomial σ f hf hx

/-- **Bijectivity form.**  If `E` is an integral `k`-algebra embedded in a field in which `k` is
relatively algebraically closed, then `k → E` is an isomorphism.  This is the conclusion of
`IsAlgClosed.algebraMap_bijective_of_isIntegral` under a strictly weaker hypothesis on `k`. -/
theorem algebraMap_bijective_of_isIntegral_of_injective
    {k E K : Type*} [Field k] [CommRing E] [Nontrivial E] [Algebra k E] [Algebra.IsIntegral k E]
    [Field K] [Algebra k K]
    (h : algebraicClosure k K = ⊥) (f : E →ₐ[k] K) (hf : Function.Injective f) :
    Function.Bijective (algebraMap k E) :=
  ⟨(algebraMap k E).injective, fun x =>
    exists_algebraMap_eq_of_isIntegral_of_injective h f hf (Algebra.IsIntegral.isIntegral x)⟩

/-- **`RingHom` form**, a drop-in replacement for `IsAlgClosed.ringHom_bijective_of_isIntegral`:
instead of assuming `k` algebraically closed, assume only that `K` embeds by `g` into a field `L`
in which `k` is relatively algebraically closed, compatibly with `f`. -/
theorem ringHom_bijective_of_isIntegral_of_injective
    {k K L : Type*} [Field k] [CommRing K] [IsDomain K] [Field L] [Algebra k L]
    (hL : algebraicClosure k L = ⊥) (f : k →+* K) (hf : f.IsIntegral)
    (g : K →+* L) (hg : Function.Injective g) (hgf : g.comp f = algebraMap k L) :
    Function.Bijective f := by
  letI : Algebra k K := f.toAlgebra
  have hfa : ∀ x : K, IsIntegral k x := hf
  let g' : K →ₐ[k] L :=
    { g with commutes' := fun r => RingHom.congr_fun hgf r }
  refine ⟨f.injective, fun x => ?_⟩
  exact exists_algebraMap_eq_of_isIntegral_of_injective hL g' hg (hfa x)

/-- The `RingHom` form specialized to a purely transcendental target. -/
theorem ringHom_bijective_of_isIntegral_of_ringHom_isFractionRing_mvPolynomial
    {k K : Type*} [Field k] [CommRing K] [IsDomain K] (σ : Type*) {L : Type*} [Field L]
    [Algebra (MvPolynomial σ k) L] [IsFractionRing (MvPolynomial σ k) L]
    [Algebra k L] [IsScalarTower k (MvPolynomial σ k) L]
    (f : k →+* K) (hf : f.IsIntegral)
    (g : K →+* L) (hg : Function.Injective g) (hgf : g.comp f = algebraMap k L) :
    Function.Bijective f :=
  ringHom_bijective_of_isIntegral_of_injective
    (algebraicClosure_eq_bot_of_isFractionRing_mvPolynomial σ L) f hf g hg hgf

/-- The `RingHom` form for `FractionRing (MvPolynomial σ k)` on the nose. -/
theorem ringHom_bijective_of_isIntegral_of_ringHom_fractionRing_mvPolynomial
    {k K : Type u} [Field k] [CommRing K] [IsDomain K] {σ : Type v}
    (f : k →+* K) (hf : f.IsIntegral)
    (g : K →+* FractionRing (MvPolynomial σ k)) (hg : Function.Injective g)
    (hgf : g.comp f = algebraMap k (FractionRing (MvPolynomial σ k))) :
    Function.Bijective f :=
  ringHom_bijective_of_isIntegral_of_ringHom_isFractionRing_mvPolynomial σ f hf g hg hgf

end
