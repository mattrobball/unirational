/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.MvPolynomialDimension
public import Mathlib.Algebra.MvPolynomial.Eval
public import Mathlib.RingTheory.Ideal.KrullsHeightTheorem
public import Mathlib.RingTheory.MvPolynomial.Homogeneous
public import Mathlib.RingTheory.Nullstellensatz

/-!
# Common projective zeroes of homogeneous polynomials

Over an algebraically closed field, fewer positive-degree homogeneous equations than homogeneous
coordinates have a common nonzero zero.  The proof is the projective dimension argument in affine
coordinates: if the origin were the only common zero, the Nullstellensatz would identify the
radical of the ideal of equations with the maximal ideal of the origin.  Krull's height theorem
bounds the height of that maximal ideal by the number of equations, whereas its height is the
number of coordinates.

The main theorem is stated for a finite family over an arbitrary finite coordinate type.  The
two-equation result needed for plane fibers is a direct corollary; no coordinate type is
specialized to a three-element type.

## Main results

* `exists_common_nonzero_zero_of_card_lt`: a finite family of positive-degree homogeneous
  polynomials has a common nonzero zero when its cardinality is smaller than the number of
  coordinates.
* `exists_common_nonzero_zero_pair`: two positive-degree homogeneous polynomials in at least
  three coordinates have a common nonzero zero.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open _root_.MvPolynomial

universe u v

variable {K : Type u} {σ : Type v} [Field K]

private theorem eval_zero_of_isHomogeneous_of_pos
    {f : MvPolynomial σ K} {d : ℕ} (hf : f.IsHomogeneous d) (hd : 0 < d) :
    eval (0 : σ → K) f = 0 := by
  rw [MvPolynomial.eval_zero, MvPolynomial.constantCoeff_eq]
  exact hf.coeff_eq_zero (by simpa using hd.ne)

variable [IsAlgClosed K] [Finite σ]

/-- Fewer positive-degree homogeneous equations than homogeneous coordinates have a common
nonzero zero over an algebraically closed field. -/
theorem exists_common_nonzero_zero_of_card_lt
    (s : Finset (MvPolynomial σ K))
    (hs : ∀ f ∈ s, ∃ d : ℕ, 0 < d ∧ f.IsHomogeneous d)
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
      obtain ⟨d, hd, hfd⟩ := hs f hf
      simpa [MvPolynomial.aeval_def] using
        eval_zero_of_isHomogeneous_of_pos hfd hd
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

/-- Two positive-degree homogeneous polynomials in at least three homogeneous coordinates have a
common nonzero zero over an algebraically closed field. -/
theorem exists_common_nonzero_zero_pair
    {f g : MvPolynomial σ K} {d e : ℕ}
    (hf : f.IsHomogeneous d) (hg : g.IsHomogeneous e)
    (hd : 0 < d) (he : 0 < e) (hσ : 3 ≤ Nat.card σ) :
    ∃ x : σ → K, x ≠ 0 ∧ eval x f = 0 ∧ eval x g = 0 := by
  classical
  obtain ⟨x, hx, hzero⟩ := exists_common_nonzero_zero_of_card_lt
    ({f, g} : Finset (MvPolynomial σ K))
    (by
      intro p hp
      simp only [Finset.mem_insert, Finset.mem_singleton] at hp
      rcases hp with rfl | rfl
      · exact ⟨d, hd, hf⟩
      · exact ⟨e, he, hg⟩)
    (Finset.card_le_two.trans_lt (by omega))
  exact ⟨x, hx, hzero f (by simp), hzero g (by simp)⟩

end

end BConicBundleMultisections
