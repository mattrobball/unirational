/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
public import Mathlib.RingTheory.Flat.FaithfullyFlat.Algebra
public import BConicBundleMultisections.CubicFiberSingularLocus

/-!
# Descent: algebraic closure is a hypothesis about *points*, not about the coefficients

Every hypothesis in this development that mentions the base field is one of three kinds.  Two of
them are removable by base change, and this module carries out the removal.

* **Conclusions that descend.**  A polynomial identity, a radical membership, a nonvanishing
  determinant — anything whose statement is about *coefficients* — may be proved after enlarging
  the coefficients and then pulled back.
* **Hypotheses that ascend.**  A hypothesis of the form "no nonzero common zero" gets *stronger*
  as the ring grows, so it has to be assumed upstairs; that strengthening is the whole cost.
* **Existence of a rational point.**  The irreducible use of algebraic closure.  No base change
  removes it: it is a genuine input to the construction, not a convenience.

## What each descent actually costs

The three conclusions that come up need three different strengths of hypothesis on the coefficient
map `φ : A →+* B`, and it is worth keeping them apart rather than assuming a field extension
everywhere out of habit.

| conclusion | what it needs of `φ` |
| --- | --- |
| `a ≠ 0` from `φ a ≠ 0` | nothing — any ring hom |
| `p = q` from `φ p = φ q` | injectivity, and nothing more |
| `x ∈ I` from `φ x ∈ I.map φ` | faithful flatness (a sufficient condition, not a necessary one) |

Only the middle row is a genuine hypothesis in the usual sense, and injectivity is minimal for it.
A field extension gives it for free, which is why it is easy to overlook; over a general
commutative ring it has to be supplied, and `Module.FaithfullyFlat` is the standard sufficient
condition — it yields `FaithfulSMul` by instance, hence `FaithfulSMul.algebraMap_injective`.

## The instance in this development

`exists_det_ne_zero_of_forall_ne_zero` in `CubicFiberSingularLocus` is where the Nullstellensatz
enters, and it had the coefficient ring and the point field identified.  Its statement over a
non-closed field is *false*: over `ℝ` the single form `x² + y²` has no nonzero real zero, yet
`ℝ[x,y]/(x² + y²)` is a domain, so no power of `x` lies in the ideal and no minor is invertible.
What fails is the hypothesis, not the conclusion — `x² + y²` does have nonzero complex zeros.
Quantifying over geometric points repairs it, and by the first row of the table the coefficients
then need no hypothesis at all: `exists_det_ne_zero_of_forall_ne_zero_of_geometric` below takes
them in an arbitrary commutative ring, along an arbitrary ring hom.

`elimCertificates_spec` and `exists_defining_set_forms_no_common_zero` above it already took
coefficients in an arbitrary commutative ring, so the elimination theorem was stated in the
descended form from the start.  The gap was one level down.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

universe u v w

/-! ### Nonvanishing reflects along any ring hom

The weakest of the three: a determinant that survives upstairs was already nonzero downstairs, and
the map need not be injective, flat, or anything else. -/

section GeometricPoints

variable {A : Type u} [CommRing A] {K : Type w} [Field K]
variable {σ : Type v} [Fintype σ] [DecidableEq σ] {m : ℕ}

/-- **The elimination certificate exists as soon as the forms have no nonzero geometric zero.**

This is `exists_det_ne_zero_of_forall_ne_zero` with algebraic closure moved off the coefficients and
onto the field the points are taken from.  The hypothesis is the stronger one — no common zero over
`K`, not merely over `A` — and that strengthening is forced, not incidental: see the `ℝ` example in
the module docstring.

The coefficients carry no hypothesis beyond `CommRing`, and `φ` no hypothesis at all.  Injectivity
would be needed to descend an *equality*; here the conclusion is a nonvanishing, which reflects
along any ring hom. -/
theorem exists_det_ne_zero_of_forall_ne_zero_of_geometric [IsAlgClosed K] [Nonempty σ]
    (φ : A →+* K) {g : Fin m → MvPolynomial σ A} {d : Fin m → ℕ}
    (hg : ∀ i, (g i).IsHomogeneous (d i))
    (hns : ∀ r : σ → K, r ≠ 0 → ∃ i, eval r (map φ (g i)) ≠ 0) :
    ∃ N : ℕ, (∀ i, d i ≤ N) ∧
      ∃ c : monomsOfDeg σ N → famIndex σ d N, (famMatrix g d N c).det ≠ 0 := by
  classical
  obtain ⟨N, hdN, c, hc⟩ :=
    exists_det_ne_zero_of_forall_ne_zero (k := K) (σ := σ)
      (g := fun i => map φ (g i)) (d := d) (fun i => (hg i).map _) hns
  refine ⟨N, hdN, c, fun h => hc ?_⟩
  rw [← famMatrix_map, ← RingHom.mapMatrix_apply, ← RingHom.map_det, h, map_zero]

end GeometricPoints

/-! ### Polynomial identities descend along an injective map

`MvPolynomial.funext` is the other place where a property of the coefficients — infiniteness — is
used to prove something that cannot depend on it.  A polynomial identity may be checked after any
injective enlargement of the coefficients, and nothing survives on the source ring.

Injectivity is minimal here, and it is exactly what a field extension supplies for free.  Over a
general commutative ring it is a real hypothesis; `Module.FaithfullyFlat` is the standard
sufficient condition, and the corollary below is stated so that a faithfully flat algebra
discharges it by instance search.

In this development the point is presently moot, since an algebraically closed field is infinite.
It stops being moot the moment algebraic closure is weakened to the point-existence hypotheses it is
really standing in for. -/

section Funext

variable {σ : Type v}

/-- **Polynomial identities may be checked after an injective enlargement of the coefficients.**

The source is an arbitrary commutative ring and the only hypothesis on the map is injectivity —
which is minimal, since a noninjective `φ` kills the polynomials it kills. -/
theorem funext_of_forall_eval_eq_of_injective {A : Type u} [CommRing A] {B : Type w} [CommRing B]
    [IsDomain B] [Infinite B] (φ : A →+* B) (hφ : Function.Injective φ)
    {p q : MvPolynomial σ A}
    (h : ∀ x : σ → B, eval x (map φ p) = eval x (map φ q)) : p = q :=
  map_injective φ hφ (MvPolynomial.funext h)

/-- **Faithful flatness is a sufficient condition**, and the common one beyond fields.

`Module.FaithfullyFlat A B` supplies `FaithfulSMul A B` by instance, hence injectivity of
`algebraMap A B`, so a faithfully flat algebra discharges the hypothesis of
`funext_of_forall_eval_eq_of_injective` without further argument. -/
theorem funext_of_forall_eval_eq_of_faithfulSMul {A : Type u} [CommRing A] {B : Type w}
    [CommRing B] [IsDomain B] [Infinite B] [Algebra A B] [FaithfulSMul A B]
    {p q : MvPolynomial σ A}
    (h : ∀ x : σ → B, eval x (map (algebraMap A B) p) = eval x (map (algebraMap A B) q)) :
    p = q :=
  funext_of_forall_eval_eq_of_injective _ (FaithfulSMul.algebraMap_injective A B) h

/-- The field-extension form, where injectivity is automatic. -/
theorem funext_of_forall_eval_eq {k : Type u} [Field k] {K : Type w} [Field K] [Algebra k K]
    [Infinite K] {p q : MvPolynomial σ k}
    (h : ∀ x : σ → K, eval x (map (algebraMap k K) p) = eval x (map (algebraMap k K) q)) :
    p = q :=
  funext_of_forall_eval_eq_of_injective _ (algebraMap k K).injective h

/-- **The ready form**: check the identity over the algebraic closure.

No hypothesis on `k` at all — not infinite, not perfect, not closed.  An algebraically closed field
is infinite, so `AlgebraicClosure k` always supplies what `MvPolynomial.funext` wants, and
injectivity brings the identity home.  This is the drop-in replacement for a site that carries
`[Infinite k]` only in order to call `MvPolynomial.funext`. -/
theorem funext_of_forall_eval_eq_algebraicClosure {k : Type u} [Field k] {p q : MvPolynomial σ k}
    (h : ∀ x : σ → AlgebraicClosure k,
      eval x (map (algebraMap k (AlgebraicClosure k)) p)
        = eval x (map (algebraMap k (AlgebraicClosure k)) q)) :
    p = q :=
  funext_of_forall_eval_eq h

end Funext

/-! ### The third row of the table

Several of the Nullstellensatz sites conclude `1 ∈ J` for an ideal `J` of a polynomial ring, having
proved it after enlarging the coefficient field.  That is an ideal-theoretic conclusion, so
injectivity is not enough; what descends it is

> `(I.map (algebraMap A B)).comap (algebraMap A B) = I`,

which is `Ideal.comap_map_eq_self_of_faithfullyFlat` under `Module.FaithfullyFlat A B`.  Mathlib has
that lemma, and it is exactly the third row of the table above.  What is missing is the instance for
the case wanted here: there is no `Algebra (MvPolynomial σ k) (MvPolynomial σ K)` in scope, let
alone `Module.FaithfullyFlat` for it, so the chain does not fire.

The route taken below avoids flatness, and is cheaper than either exhibiting the free basis or
building the missing instances.  Faithful flatness is only ever used through the existence of a
`MvPolynomial σ k`-linear **retraction** of the coefficient extension, and one such retraction is
completely explicit: choose a `k`-linear `π : K → k` with `π 1 = 1` — which exists because `K` is a
`k`-vector space and `k → K` is a split injection of vector spaces — and apply it to every
coefficient.  The resulting `coeffProj π` is not a ring map, but it satisfies the projection formula
`coeffProj π (map φ a * q) = a * coeffProj π q`, which is all that a descent of ideal membership
needs, and it fixes `MvPolynomial σ k` pointwise.  No basis is chosen, no freeness is proved, and
the full `comap ∘ map = id` identity comes out, not merely the `1 ∈ I` case. -/

section IdealDescent

variable {k : Type u} [Field k] {K : Type w} [Field K] [Algebra k K] {σ : Type v}

/-- Apply a `k`-linear functional to every coefficient of a polynomial over `K`.

This is `MvPolynomial.map` for a map that is only linear, not multiplicative; it is a homomorphism
of additive groups and of `MvPolynomial σ k`-modules, which is what the descent below consumes. -/
noncomputable def coeffProj (π : K →ₗ[k] k) (p : MvPolynomial σ K) : MvPolynomial σ k :=
  ∑ d ∈ p.support, MvPolynomial.monomial d (π (p.coeff d))

@[simp] theorem coeff_coeffProj (π : K →ₗ[k] k) (p : MvPolynomial σ K) (e : σ →₀ ℕ) :
    (coeffProj π p).coeff e = π (p.coeff e) := by
  classical
  rw [coeffProj, MvPolynomial.coeff_sum]
  by_cases h : e ∈ p.support
  · refine (Finset.sum_eq_single e ?_ ?_).trans ?_
    · intro d _ hd
      rw [MvPolynomial.coeff_monomial, if_neg hd]
    · intro hne
      exact absurd h hne
    · rw [MvPolynomial.coeff_monomial, if_pos rfl]
  · refine (Finset.sum_eq_zero ?_).trans ?_
    · intro d hd
      rw [MvPolynomial.coeff_monomial, if_neg]
      rintro rfl
      exact h hd
    · rw [MvPolynomial.notMem_support_iff.mp h, map_zero]

theorem coeffProj_zero (π : K →ₗ[k] k) : coeffProj π (0 : MvPolynomial σ K) = 0 := by
  ext e; simp

theorem coeffProj_add (π : K →ₗ[k] k) (p q : MvPolynomial σ K) :
    coeffProj π (p + q) = coeffProj π p + coeffProj π q := by
  ext e; simp

/-- `coeffProj π` fixes the coefficient subring, provided `π` retracts `k → K`. -/
theorem coeffProj_one (π : K →ₗ[k] k) (hπ : π (1 : K) = 1) :
    coeffProj π (1 : MvPolynomial σ K) = 1 := by
  classical
  ext e
  rw [coeff_coeffProj, MvPolynomial.coeff_one, MvPolynomial.coeff_one]
  split_ifs with h
  · exact hπ
  · exact map_zero π

/-- **The projection formula.**  `coeffProj π` is `MvPolynomial σ k`-linear when the base ring acts
through the coefficient extension.  No hypothesis on `π` beyond `k`-linearity. -/
theorem coeffProj_map_mul (π : K →ₗ[k] k) (a : MvPolynomial σ k) (q : MvPolynomial σ K) :
    coeffProj π (MvPolynomial.map (algebraMap k K) a * q) = a * coeffProj π q := by
  classical
  ext e
  rw [coeff_coeffProj, MvPolynomial.coeff_mul, MvPolynomial.coeff_mul, map_sum]
  refine Finset.sum_congr rfl fun x _ => ?_
  rw [MvPolynomial.coeff_map, coeff_coeffProj, ← Algebra.smul_def, map_smul, smul_eq_mul]

/-- **Ideal membership descends along a coefficient field extension.**

This is the third row of the table, proved without flatness: the elementary retraction above is
enough.  Compare `Ideal.comap_map_eq_self_of_faithfullyFlat`, which would give the same conclusion
from `Module.FaithfullyFlat (MvPolynomial σ k) (MvPolynomial σ K)` — an instance Mathlib does not
have, and which cannot even be stated without first supplying the missing `Algebra`. -/
theorem comap_map_mvPolynomial_eq_self (I : Ideal (MvPolynomial σ k)) :
    (I.map (MvPolynomial.map (algebraMap k K))).comap (MvPolynomial.map (algebraMap k K)) = I := by
  classical
  refine le_antisymm ?_ Ideal.le_comap_map
  obtain ⟨π, hπ⟩ := (Algebra.linearMap k K).exists_leftInverse_of_injective
    (LinearMap.ker_eq_bot.mpr (algebraMap k K).injective)
  have hπ1 : π (1 : K) = 1 := by
    have h := congrArg (fun f : k →ₗ[k] k => f 1) hπ
    simpa using h
  -- The elements whose every multiple projects into `I`.  This is an ideal upstairs, and it
  -- contains the image of `I`, hence the whole extension of `I`.
  set J : Ideal (MvPolynomial σ K) :=
    { carrier := {p | ∀ a : MvPolynomial σ K, coeffProj π (a * p) ∈ I}
      add_mem' := by
        intro p q hp hq a
        rw [mul_add, coeffProj_add]
        exact I.add_mem (hp a) (hq a)
      zero_mem' := by
        intro a
        rw [mul_zero, coeffProj_zero]
        exact I.zero_mem
      smul_mem' := by
        intro c p hp a
        rw [smul_eq_mul, ← mul_assoc]
        exact hp _ } with hJ
  have hle : I.map (MvPolynomial.map (algebraMap k K)) ≤ J := by
    rw [Ideal.map_le_iff_le_comap]
    intro g hg a
    rw [mul_comm, coeffProj_map_mul]
    exact I.mul_mem_right _ hg
  intro y hy
  have hyJ : MvPolynomial.map (algebraMap k K) y ∈ J := hle hy
  have h1 := hyJ 1
  rw [one_mul] at h1
  rwa [show MvPolynomial.map (algebraMap k K) y
        = MvPolynomial.map (algebraMap k K) y * 1 from (mul_one _).symm,
    coeffProj_map_mul, coeffProj_one π hπ1, mul_one] at h1

/-- The `1 ∈ I` case, which is what the Nullstellensatz sites need: a polynomial ideal that becomes
the unit ideal after a coefficient field extension was already the unit ideal. -/
theorem ideal_eq_top_of_map_eq_top {I : Ideal (MvPolynomial σ k)}
    (h : I.map (MvPolynomial.map (algebraMap k K)) = ⊤) : I = ⊤ := by
  refine (Ideal.eq_top_iff_one _).mpr ?_
  have h1 : (1 : MvPolynomial σ K) ∈ I.map (MvPolynomial.map (algebraMap k K)) := by
    rw [h]; trivial
  have := (comap_map_mvPolynomial_eq_self (K := K) I).le (show (1 : MvPolynomial σ k) ∈ _ by
    simpa using h1)
  exact this

end IdealDescent

end

end BConicBundleMultisections
