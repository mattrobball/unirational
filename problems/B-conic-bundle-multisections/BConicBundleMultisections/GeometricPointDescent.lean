/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
public import BConicBundleMultisections.CubicFiberSingularLocus

/-!
# Descent: algebraic closure is a hypothesis about *points*, not about the base field

Every hypothesis in this development that mentions the base field is one of three kinds.  Two of
them are removable by base change, and this module carries out the removal on the hardest instance.

* **Conclusions that descend.**  A polynomial identity, a radical membership, a nonvanishing
  determinant — anything whose statement is about *coefficients* — may be proved after enlarging
  the field and then pulled back, because `algebraMap k K` is injective for a field `k`.
* **Hypotheses that ascend.**  A hypothesis of the form "no nonzero common zero" gets *stronger*
  as the field grows, so it has to be assumed over the big field; that strengthening is the whole
  cost of the descent.
* **Existence of a rational point.**  This is the irreducible use of algebraic closure, and no
  amount of base change removes it: it is a genuine input to the construction, not a convenience.

`exists_det_ne_zero_of_forall_ne_zero` in `CubicFiberSingularLocus` is the sharpest instance of the
first two, because its proof is precisely where the Nullstellensatz enters the development.  Its
statement over a non-closed field is *false*: over `ℝ`, the single form `x² + y²` has no nonzero
real zero, yet `ℝ[x,y]/(x² + y²)` is a domain, so no power of `x` lies in the ideal and no minor is
invertible.  What fails is the hypothesis, not the conclusion — `x² + y²` does have nonzero complex
zeros.  Quantifying the hypothesis over geometric points repairs it, and
`exists_det_ne_zero_of_forall_ne_zero_of_geometric` below is the repaired statement: the field the
coefficients live in carries no hypothesis beyond being a field, and algebraic closure is asked of
an extension.

## What this costs, and what it buys

Nothing, and one layer of the tower.  `elimCertificates_spec` already takes its coefficients in an
arbitrary commutative ring `A` and asks algebraic closure only of the field where the *points* are
taken, so the elimination theorem was stated in the descended form from the start.  The gap was one
level down, at the lemma feeding it, where the two fields had been identified.  Separating them
again is `famMatrix_map` plus injectivity, and that is all this file is.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

universe u v w

section GeometricPoints

variable {k : Type u} [Field k] {K : Type w} [Field K] [Algebra k K]
variable {σ : Type v} [Fintype σ] [DecidableEq σ] {m : ℕ}

/-- **The elimination certificate exists as soon as the forms have no nonzero geometric zero.**

This is `exists_det_ne_zero_of_forall_ne_zero` with algebraic closure moved off the field the
coefficients live in and onto the field the points are taken from.  The hypothesis is the stronger
one — no common zero over `K`, not merely over `k` — and that strengthening is forced, not
incidental: see the `ℝ` example in the module docstring.

The conclusion is the same nonzero determinant over `k`, so every consumer that reads only
certificates keeps working with `k` arbitrary. -/
theorem exists_det_ne_zero_of_forall_ne_zero_of_geometric [IsAlgClosed K] [Nonempty σ]
    {g : Fin m → MvPolynomial σ k} {d : Fin m → ℕ} (hg : ∀ i, (g i).IsHomogeneous (d i))
    (hns : ∀ r : σ → K, r ≠ 0 → ∃ i, eval r (map (algebraMap k K) (g i)) ≠ 0) :
    ∃ N : ℕ, (∀ i, d i ≤ N) ∧
      ∃ c : monomsOfDeg σ N → famIndex σ d N, (famMatrix g d N c).det ≠ 0 := by
  classical
  obtain ⟨N, hdN, c, hc⟩ :=
    exists_det_ne_zero_of_forall_ne_zero (k := K) (σ := σ)
      (g := fun i => map (algebraMap k K) (g i)) (d := d)
      (fun i => (hg i).map _) hns
  refine ⟨N, hdN, c, fun h => hc ?_⟩
  rw [← famMatrix_map, ← RingHom.mapMatrix_apply, ← RingHom.map_det, h, map_zero]

end GeometricPoints

/-! ### Polynomial identities descend

`MvPolynomial.funext` is the other place where a property of the field — infiniteness — is used to
prove something that cannot depend on it.  A polynomial identity over `k` may be checked at all
points of any field extension whatsoever, and no hypothesis on `k` survives.

In this development the point is presently moot, since an algebraically closed field is infinite.
It stops being moot the moment algebraic closure is weakened to the point-existence hypotheses it is
really standing in for, which is why the lemma is recorded here. -/

section Funext

variable {σ : Type v}

/-- **Polynomial identities may be checked over an extension.**

If two polynomials over `k` agree at every point of an infinite domain `K` receiving `k`
injectively, they are equal — with no hypothesis on `k` beyond being a commutative ring. -/
theorem funext_of_forall_eval_eq_of_injective {k : Type u} [CommRing k] {K : Type w} [CommRing K]
    [IsDomain K] [Infinite K] (φ : k →+* K) (hφ : Function.Injective φ)
    {p q : MvPolynomial σ k}
    (h : ∀ x : σ → K, eval x (map φ p) = eval x (map φ q)) : p = q :=
  map_injective φ hφ (MvPolynomial.funext h)

/-- The algebra-map form, for an extension field `K` of `k`. -/
theorem funext_of_forall_eval_eq {k : Type u} [Field k] {K : Type w} [Field K] [Algebra k K]
    [Infinite K] {p q : MvPolynomial σ k}
    (h : ∀ x : σ → K, eval x (map (algebraMap k K) p) = eval x (map (algebraMap k K) q)) :
    p = q :=
  funext_of_forall_eval_eq_of_injective _ (algebraMap k K).injective h

/-- **The ready form**: check the identity over the algebraic closure.

No hypothesis on `k` at all — not infinite, not perfect, not closed.  An algebraically closed field
is infinite, so `AlgebraicClosure k` always supplies what `MvPolynomial.funext` wants, and
injectivity brings the identity home.  This is the drop-in replacement for a site that currently
carries `[Infinite k]` only in order to call `MvPolynomial.funext`. -/
theorem funext_of_forall_eval_eq_algebraicClosure {k : Type u} [Field k] {p q : MvPolynomial σ k}
    (h : ∀ x : σ → AlgebraicClosure k,
      eval x (map (algebraMap k (AlgebraicClosure k)) p)
        = eval x (map (algebraMap k (AlgebraicClosure k)) q)) :
    p = q :=
  funext_of_forall_eval_eq h

end Funext

/-! ### The one piece of descent that is not formal

Seven of the eleven Nullstellensatz sites use the *radical-membership* direction — `f` vanishes on
the zero locus, therefore `f ∈ I.radical` — rather than the point-producing direction.  Descending
those needs

> `(I.map (algebraMap k K)).comap (algebraMap k K) = I`  for `I : Ideal (MvPolynomial σ k)`,

which is `Ideal.comap_map_eq_self_of_faithfullyFlat` applied to the extension
`MvPolynomial σ k → MvPolynomial σ K`.  Mathlib has that lemma, but not the instance: there is no
`Algebra (MvPolynomial σ k) (MvPolynomial σ K)` in scope, let alone `Module.FaithfullyFlat` for it,
so the chain does not fire.

The elementary route avoids flatness entirely.  `MvPolynomial σ K` is free over `MvPolynomial σ k`
on any `k`-basis of `K` containing `1`; an element of `I.map` is `∑ aᵢ gᵢ` with `gᵢ ∈ I ⊆
MvPolynomial σ k`, and expanding the `aᵢ` in that basis exhibits its `1`-component as a member of
`I`.  An element that already lies downstairs is its own `1`-component.

This is recorded rather than proved because it is a self-contained piece of commutative algebra of
its own size, and because nothing in the current tree consumes it yet — the four sites that reach
the main theorem go through `exists_det_ne_zero_of_forall_ne_zero_of_geometric` above. -/

end

end BConicBundleMultisections
