/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.FieldTheory.IntermediateField.Adjoin.Basic
public import Mathlib.FieldTheory.SeparableClosure
public import Mathlib.RingTheory.Polynomial.SeparableDegree
public import BConicBundleMultisections.NeZeroTwoThree

/-!
# Low degree forces separability

Over a field `K` whose characteristic is either `0` or larger than `d`, every algebraic element of
degree at most `d` is separable.  This is the step that turns the project's characteristic
hypothesis `ringChar k ∤ 6` into a genuine separability statement: the singular point of a plane
cubic satisfies a nonzero form of degree `≤ 4`, and `p ∤ 6` says exactly that `p = 0` or `p ≥ 5`.

## The mechanism

Write `q` for the *exponential* characteristic of `K` (so `q = 1` in characteristic zero and
`q = p` in characteristic `p > 0`).  Mathlib's `Irreducible.hasSeparableContraction` writes an
irreducible `f` as `f = expand K (q ^ m) g` with `g` separable, whence

`f.natDegree = g.natDegree * q ^ m`.

If `f` is nonconstant then `g` is too, so `q ^ m ≤ f.natDegree`.  Therefore `f.natDegree ≤ d < q`
forces `m = 0`, i.e. `f = g` is separable.  Characteristic zero is not a separate case: there
`q = 1`, so `q ^ m = 1` outright.

The hypothesis is packaged as `∀ p : ℕ, p.Prime → p ≤ d → (p : K) ≠ 0`, which is what the
exponential characteristic actually consumes — the non-trivial branch of `ExpChar` hands over a
*prime* `q` with `(q : K) = 0`, so no separate appeal to primality of `ringChar` is needed.

## Main results

* `separable_of_irreducible_of_natDegree_le` — an irreducible polynomial of degree `≤ d` is
  separable.  (Generalises Mathlib's `Irreducible.separable`, which assumes `CharZero`.)
* `isSeparable_of_aeval_eq_zero_of_natDegree_le` — a root of a nonzero polynomial of degree `≤ d`
  is a separable element.
* `isSeparable_of_aeval_eq_zero_of_natDegree_le_four` — the specialisation to `d = 4` under
  `[NeZero (2 : K)] [NeZero (3 : K)]`, which is exactly `ringChar K ∤ 6`.
* `isSeparable_of_aeval_eq_zero_of_natDegree_le_two` — the specialisation to `d = 2` under
  `[NeZero (2 : K)]` alone.
* `mem_separableClosure_of_aeval_eq_zero_of_natDegree_le_four` and its `AlgebraicClosure`
  specialisation — the packaged form the consumer wants, obtained from `mem_separableClosure_iff`.
-/

@[expose] public section

namespace BConicBundleMultisections

open Polynomial IntermediateField

universe u v

variable {K : Type u} [Field K]

/-! ### The characteristic dichotomy -/

/-- If every prime `p ≤ d` is nonzero in `K`, then the exponential characteristic of `K` is either
`1` (characteristic zero) or strictly larger than `d`.

Only the primality supplied by `ExpChar` itself is used, so the caller never has to know that
`ringChar` of a field is `0` or prime. -/
theorem expChar_eq_one_or_lt (d q : ℕ) [hq : ExpChar K q]
    (hd : ∀ p : ℕ, p.Prime → p ≤ d → (p : K) ≠ 0) : q = 1 ∨ d < q := by
  cases hq with
  | zero => exact Or.inl rfl
  | prime hprime =>
    refine Or.inr (lt_of_not_ge fun hle => hd q hprime hle ?_)
    exact_mod_cast CharP.cast_eq_zero K q

/-! ### Irreducible polynomials of low degree -/

/-- An irreducible polynomial of degree at most `d` over a field in which every prime `p ≤ d` is
nonzero is separable.

This generalises Mathlib's `Irreducible.separable`, which carries `[CharZero F]`: characteristic
zero is the degenerate case `q = 1` of the argument below, not a separate one. -/
theorem separable_of_irreducible_of_natDegree_le {f : K[X]} {d : ℕ} (hf : Irreducible f)
    (hdeg : f.natDegree ≤ d) (hd : ∀ p : ℕ, p.Prime → p ≤ d → (p : K) ≠ 0) : f.Separable := by
  obtain ⟨q, _⟩ := ExpChar.exists K
  -- Write `f = expand K (q ^ m) g` with `g` separable.
  obtain ⟨g, hg, m, rfl⟩ := hf.hasSeparableContraction q
  -- The contraction is trivial: `q ^ m = 1`.
  have hqm : q ^ m = 1 := by
    rcases expChar_eq_one_or_lt (K := K) d q hd with rfl | hqd
    · exact one_pow m
    · by_contra hne
      have hm : m ≠ 0 := by rintro rfl; exact hne (pow_zero q)
      -- `f` is nonconstant, hence so is `g`.
      have hgpos : 0 < g.natDegree := by
        have h0 := hf.natDegree_pos
        rw [natDegree_expand] at h0
        exact Nat.pos_of_ne_zero fun h => by simp [h] at h0
      -- `q ≤ q ^ m ≤ g.natDegree * q ^ m = f.natDegree ≤ d < q`.
      have h1 : q ≤ q ^ m := Nat.le_self_pow hm q
      have h2 : q ^ m ≤ g.natDegree * q ^ m := Nat.le_mul_of_pos_left _ hgpos
      rw [natDegree_expand] at hdeg
      omega
  rw [hqm, expand_one]
  exact hg

/-! ### Separable elements of low degree -/

variable {L : Type v} [Field L] [Algebra K L]

/-- An element whose minimal polynomial has degree at most `d` is separable, provided every prime
`p ≤ d` is nonzero in `K`. -/
theorem isSeparable_of_natDegree_minpoly_le {z : L} {d : ℕ} (hz : IsIntegral K z)
    (hdeg : (minpoly K z).natDegree ≤ d)
    (hd : ∀ p : ℕ, p.Prime → p ≤ d → (p : K) ≠ 0) : IsSeparable K z :=
  separable_of_irreducible_of_natDegree_le (minpoly.irreducible hz) hdeg hd

/-- A root of a nonzero polynomial of degree at most `d` is separable over `K`, provided every
prime `p ≤ d` is nonzero in `K`.

This is the form the project consumes: the singular point of a plane cubic is produced as a root
of a resultant, not as an element of a named subfield. -/
theorem isSeparable_of_aeval_eq_zero_of_natDegree_le {z : L} {P : K[X]} {d : ℕ} (hP : P ≠ 0)
    (hroot : aeval z P = 0) (hdeg : P.natDegree ≤ d)
    (hd : ∀ p : ℕ, p.Prime → p ≤ d → (p : K) ≠ 0) : IsSeparable K z := by
  have halg : IsAlgebraic K z := ⟨P, hP, hroot⟩
  exact isSeparable_of_natDegree_minpoly_le halg.isIntegral
    ((natDegree_le_of_dvd (minpoly.dvd K z hroot) hP).trans hdeg) hd

/-- The `[K(z) : K] ≤ d` phrasing: an algebraic element generating an extension of degree at most
`d` is separable, provided every prime `p ≤ d` is nonzero in `K`. -/
theorem isSeparable_of_finrank_adjoin_le {z : L} {d : ℕ} (hz : IsIntegral K z)
    (hdeg : Module.finrank K K⟮z⟯ ≤ d)
    (hd : ∀ p : ℕ, p.Prime → p ≤ d → (p : K) ≠ 0) : IsSeparable K z :=
  isSeparable_of_natDegree_minpoly_le hz (by rwa [IntermediateField.adjoin.finrank hz] at hdeg) hd

/-! ### The two specialisations the project needs

`ringChar K ∤ 6` — that is, `[NeZero (2 : K)] [NeZero (3 : K)]` — says precisely that the
characteristic is `0` or at least `5`.  So it clears every prime `≤ 4`, and degree `≤ 4` suffices.
`[NeZero (2 : K)]` alone clears every prime `≤ 2`, enough for quadratics. -/

/-- Under `[NeZero (2 : K)]`, every prime `p ≤ 2` is nonzero in `K` — there is only `p = 2`. -/
theorem prime_ne_zero_of_le_two [NeZero (2 : K)] (p : ℕ) (hp : p.Prime) (hle : p ≤ 2) :
    (p : K) ≠ 0 := by
  have h2 := hp.two_le
  interval_cases p
  · simpa using (two_ne_zero : (2 : K) ≠ 0)

/-- Under `[NeZero (2 : K)] [NeZero (3 : K)]`, every prime `p ≤ 4` is nonzero in `K` — the only
such primes are `2` and `3`, and `4` is not prime. -/
theorem prime_ne_zero_of_le_four [NeZero (2 : K)] [NeZero (3 : K)] (p : ℕ) (hp : p.Prime)
    (hle : p ≤ 4) : (p : K) ≠ 0 := by
  have h2 := hp.two_le
  interval_cases p
  · simpa using (two_ne_zero : (2 : K) ≠ 0)
  · simpa using (three_ne_zero : (3 : K) ≠ 0)
  · exact absurd hp (by decide)

/-- A root of a nonzero quadratic (or linear) polynomial over a field in which `2 ≠ 0` is
separable. -/
theorem isSeparable_of_aeval_eq_zero_of_natDegree_le_two [NeZero (2 : K)] {z : L} {P : K[X]}
    (hP : P ≠ 0) (hroot : aeval z P = 0) (hdeg : P.natDegree ≤ 2) : IsSeparable K z :=
  isSeparable_of_aeval_eq_zero_of_natDegree_le hP hroot hdeg prime_ne_zero_of_le_two

/-- A root of a nonzero polynomial of degree at most `4` over a field in which `2 ≠ 0` and `3 ≠ 0`
is separable.  This is the statement that keeps the plane-cubic singular point separable away from
characteristics `2` and `3` — exactly the characteristics in which quasi-elliptic fibrations
exist. -/
theorem isSeparable_of_aeval_eq_zero_of_natDegree_le_four [NeZero (2 : K)] [NeZero (3 : K)]
    {z : L} {P : K[X]} (hP : P ≠ 0) (hroot : aeval z P = 0) (hdeg : P.natDegree ≤ 4) :
    IsSeparable K z :=
  isSeparable_of_aeval_eq_zero_of_natDegree_le hP hroot hdeg prime_ne_zero_of_le_four

/-! ### Membership in the separable closure

`mem_separableClosure_iff` is definitional, so these are `IsSeparable` with a different face. -/

/-- A root of a nonzero polynomial of degree at most `d` lies in the separable closure of `K` in
`L`, provided every prime `p ≤ d` is nonzero in `K`. -/
theorem mem_separableClosure_of_aeval_eq_zero_of_natDegree_le {z : L} {P : K[X]} {d : ℕ}
    (hP : P ≠ 0) (hroot : aeval z P = 0) (hdeg : P.natDegree ≤ d)
    (hd : ∀ p : ℕ, p.Prime → p ≤ d → (p : K) ≠ 0) : z ∈ separableClosure K L :=
  mem_separableClosure_iff.mpr (isSeparable_of_aeval_eq_zero_of_natDegree_le hP hroot hdeg hd)

/-- A root of a nonzero quadratic lies in the separable closure, when `2 ≠ 0` in `K`. -/
theorem mem_separableClosure_of_aeval_eq_zero_of_natDegree_le_two [NeZero (2 : K)] {z : L}
    {P : K[X]} (hP : P ≠ 0) (hroot : aeval z P = 0) (hdeg : P.natDegree ≤ 2) :
    z ∈ separableClosure K L :=
  mem_separableClosure_iff.mpr
    (isSeparable_of_aeval_eq_zero_of_natDegree_le_two hP hroot hdeg)

/-- A root of a nonzero polynomial of degree at most `4` lies in the separable closure, when
`2 ≠ 0` and `3 ≠ 0` in `K`. -/
theorem mem_separableClosure_of_aeval_eq_zero_of_natDegree_le_four [NeZero (2 : K)]
    [NeZero (3 : K)] {z : L} {P : K[X]} (hP : P ≠ 0) (hroot : aeval z P = 0)
    (hdeg : P.natDegree ≤ 4) : z ∈ separableClosure K L :=
  mem_separableClosure_iff.mpr
    (isSeparable_of_aeval_eq_zero_of_natDegree_le_four hP hroot hdeg)

/-- The consumer's one-liner: a root in `AlgebraicClosure K` of a nonzero polynomial of degree at
most `4` lies in `separableClosure K (AlgebraicClosure K)`. -/
theorem mem_separableClosure_algebraicClosure_of_natDegree_le_four [NeZero (2 : K)]
    [NeZero (3 : K)] {z : AlgebraicClosure K} {P : K[X]} (hP : P ≠ 0) (hroot : aeval z P = 0)
    (hdeg : P.natDegree ≤ 4) : z ∈ separableClosure K (AlgebraicClosure K) :=
  mem_separableClosure_of_aeval_eq_zero_of_natDegree_le_four hP hroot hdeg

/-- The degree-`2` companion over the algebraic closure. -/
theorem mem_separableClosure_algebraicClosure_of_natDegree_le_two [NeZero (2 : K)]
    {z : AlgebraicClosure K} {P : K[X]} (hP : P ≠ 0) (hroot : aeval z P = 0)
    (hdeg : P.natDegree ≤ 2) : z ∈ separableClosure K (AlgebraicClosure K) :=
  mem_separableClosure_of_aeval_eq_zero_of_natDegree_le_two hP hroot hdeg

end BConicBundleMultisections
