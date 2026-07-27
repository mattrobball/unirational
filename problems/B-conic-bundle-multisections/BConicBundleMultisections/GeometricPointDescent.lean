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

/-! ### The third row of the table, which is not formal

Seven of the eleven Nullstellensatz sites use the *radical-membership* direction — `f` vanishes on
the zero locus, therefore `f ∈ I.radical` — rather than the point-producing direction.  That is an
ideal-theoretic conclusion, so injectivity is not enough; what descends it is

> `(I.map (algebraMap A B)).comap (algebraMap A B) = I`,

which is `Ideal.comap_map_eq_self_of_faithfullyFlat` under `Module.FaithfullyFlat A B`.  Mathlib has
that lemma, and it is exactly the third row of the table above.  What is missing is the instance for
the case wanted here: there is no `Algebra (MvPolynomial σ k) (MvPolynomial σ K)` in scope, let
alone `Module.FaithfullyFlat` for it, so the chain does not fire.

The elementary route avoids flatness.  `MvPolynomial σ K` is free over `MvPolynomial σ k` on any
`k`-basis of `K` containing `1`; an element of `I.map` is `∑ aᵢ gᵢ` with `gᵢ` drawn from
`I ⊆ MvPolynomial σ k`, and expanding the `aᵢ` in that basis exhibits its `1`-component as a member
of `I`.  An element that already lies downstairs is its own `1`-component.

Recorded rather than proved, because it is a self-contained piece of commutative algebra of its own
size and nothing in the current tree consumes it: the sites reaching the main theorem go through
`exists_det_ne_zero_of_forall_ne_zero_of_geometric` above, which needs nothing of the map. -/

end

end BConicBundleMultisections
