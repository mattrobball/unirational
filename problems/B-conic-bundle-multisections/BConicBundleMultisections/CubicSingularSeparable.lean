/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ConicResultant
public import BConicBundleMultisections.SeparableLowDegree
public import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
public import Mathlib.RingTheory.MvPolynomial.EulerIdentity

/-!
# A singular point of a plane cubic, over the separable closure

Let `K` be a field with `2 ≠ 0` and `3 ≠ 0` — that is, `ringChar K ∤ 6` — and let `G` be a ternary
cubic form over `K` with a singular point over `Ω = AlgebraicClosure K`.  This file produces a
singular point over `separableClosure K Ω`.

That is exactly what the derivation argument of `FirstProjectionSmoothFiber` needs: derivations
extend along separable extensions and along nothing wider, so the elimination certificate — which
lives over `Ω` — has to be moved into the separable closure before it can be differentiated.

The hypothesis `ringChar K ∤ 6` is not removable.  Quasi-elliptic fibrations live exactly in
characteristics `2` and `3`: their generic fibre is a plane cubic that is regular over `K` but not
smooth, and its unique geometric singular point is purely inseparable over `K`.

## The argument

Write `qⱼ = ∂ⱼG`, three conics, and `Z = V(q₀, q₁, q₂)`.  Euler's identity `3 G = Σ Xⱼ ∂ⱼG` and
`3 ≠ 0` make `G` redundant: a common zero of the three partials is automatically a zero of `G`.  So
the whole problem is to put a point of `Z` into the separable closure, and the point produced need
not be the given one — any point of `Z` will do, which is what makes the degenerate branches
tractable.

**The reduction.**  `separableClosure K Ω` is separably closed and `2 ≠ 0`, so *one* coordinate
ratio suffices: normalise `v = 1` with `u ∈ Ksep`; the remaining coordinate `t` is a root of the
quadratic `qⱼ(T, u, 1) ∈ Ksep[T]`.  If some `j` makes that quadratic nonzero, `t` is separable over
a separably closed field, hence already in it.  If all three vanish identically, `(0, u, 1)` is
itself a common zero, and it lies in `Ksep³` already.  This is
`exists_separableClosure_common_zero_of_ratio`, and it means only **one** degree bound is ever
needed.

**Main branch.**  If two of the `qⱼ` are relatively prime, then
`exists_polynomial_ne_zero_natDegree_le_four`
of `ConicResultant` makes `y₁/y₂` a root of a nonzero polynomial of degree `≤ 4` over `K`, and
`mem_separableClosure_algebraicClosure_of_natDegree_le_four` of `SeparableLowDegree` puts it in the
separable closure.  The chart where `y₂ = 0` needs no resultant at all: there the last two
coordinates normalise to `(1, 0)` or the point is `(1 : 0 : 0)`, already rational.

**Degenerate branch: no pair relatively prime.**  Then every pair has a common irreducible factor,
homogeneous of degree `1` or `2`.  Two cases, resolved by two geometric lemmas:

* a factor `h` common to all three, so `V(h) ⊆ Z`.  If `deg h = 2`, then
  `exists_separableClosure_zero_of_isHomogeneous_two` finds a point of `V(h)` over the separable
  closure — restrict to the line `X₂ = 0` and take a root of the resulting quadratic, or, when that
  quadratic degenerates, take the centre of projection `(1 : 0 : 0)`, which is then already on
  `V(h)`.  If `deg h = 1` use the next case with `ℓ = ℓ' = h`.
* pairwise shared factors but no common one — this case is real, e.g. the triangle `G = y₀y₁y₂`,
  whose partials `y₁y₂, y₀y₂, y₀y₁` are pairwise non-coprime with trivial triple gcd.  Take `h₀₁`
  common to `q₀, q₁` and `h₀₂` common to `q₀, q₂`; if `h₀₁ ∤ q₂` then `h₀₁` and `h₀₂` are relatively
  prime, so their product divides the conic `q₀` and both are linear.  Every `qⱼ` is then divisible
  by `h₀₁` or by `h₀₂`, so `V(h₀₁) ∩ V(h₀₂) ⊆ Z`, and two linear forms in three variables always
  have a nonzero common zero already over `K` — a rank count,
  `exists_ne_zero_common_zero_of_linear`.

Note that the degenerate branch never uses the given point: it constructs a point of `Z` from
scratch.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial
open _root_.MvPolynomial

universe u v w

/-! ### Moving evaluations along algebra maps -/

section Transfer

variable {K : Type u} [Field K]

/-- Evaluating at a `K`-rational point commutes with the structure map. -/
theorem aeval_algebraMap_point {L : Type v} [CommRing L] [Algebra K L] {σ : Type w}
    (c : σ → K) (p : MvPolynomial σ K) :
    MvPolynomial.aeval (fun i => algebraMap K L (c i)) p =
      algebraMap K L (MvPolynomial.eval c p) := by
  induction p using MvPolynomial.induction_on with
  | C a => simp
  | add p q hp hq => simp [hp, hq]
  | mul_X p i hp => simp [hp]

/-- Evaluation commutes with the structure map of a tower. -/
theorem algebraMap_aeval {L : Type v} [CommRing L] [Algebra K L] {M : Type w} [CommRing M]
    [Algebra K M] [Algebra L M] [IsScalarTower K L M] {σ : Type*} (z : σ → L)
    (p : MvPolynomial σ K) :
    algebraMap L M (MvPolynomial.aeval z p) =
      MvPolynomial.aeval (fun i => algebraMap L M (z i)) p := by
  induction p using MvPolynomial.induction_on with
  | C a => simp [IsScalarTower.algebraMap_apply K L M]
  | add p q hp hq => simp [hp, hq]
  | mul_X p i hp => simp [hp]

/-- `eval` of a mapped polynomial is `aeval`. -/
theorem eval_map_eq_aeval {L : Type v} [CommRing L] [Algebra K L] {σ : Type w} (z : σ → L)
    (p : MvPolynomial σ K) :
    MvPolynomial.eval z (MvPolynomial.map (algebraMap K L) p) = MvPolynomial.aeval z p := by
  rw [MvPolynomial.eval_map, MvPolynomial.aeval_def]

end Transfer

/-! ### Linear forms in three variables

Euler's identity in degree `1` extracts the coefficient vector of a linear form: its partial
derivatives are homogeneous of degree `0`, hence constants. -/

section LinearForms

variable {K : Type u} [Field K]

/-- The coefficient vector of a linear form. -/
def linearCoeff (p : MvPolynomial (Fin 3) K) (i : Fin 3) : K :=
  MvPolynomial.coeff 0 (pderiv i p)

/-- **A linear form is its coefficient vector.**  Euler's identity in degree `1`, together with the
fact that a homogeneous polynomial of degree `0` is a constant. -/
theorem eq_sum_linearCoeff {p : MvPolynomial (Fin 3) K} (hp : p.IsHomogeneous 1) :
    p = ∑ i : Fin 3, MvPolynomial.X i * MvPolynomial.C (linearCoeff p i) := by
  have heuler := hp.sum_X_mul_pderiv
  rw [one_smul] at heuler
  conv_lhs => rw [← heuler]
  refine Finset.sum_congr rfl fun i _ => ?_
  congr 1
  have h0 : (pderiv i p).IsHomogeneous 0 := by simpa using hp.pderiv (i := i)
  exact eq_C_of_isHomogeneous_zero h0

/-- The value of a linear form is the dot product with its coefficient vector. -/
theorem eval_eq_sum_linearCoeff {p : MvPolynomial (Fin 3) K} (hp : p.IsHomogeneous 1)
    (z : Fin 3 → K) :
    MvPolynomial.eval z p = ∑ i : Fin 3, z i * linearCoeff p i := by
  conv_lhs => rw [eq_sum_linearCoeff hp]
  simp

/-- **Two linear forms in three variables have a nonzero common zero over `K`.**  A rank count: a
linear map `K³ → K²` cannot be injective. -/
theorem exists_ne_zero_common_zero_of_linear {ℓ ℓ' : MvPolynomial (Fin 3) K}
    (hℓ : ℓ.IsHomogeneous 1) (hℓ' : ℓ'.IsHomogeneous 1) :
    ∃ z : Fin 3 → K, z ≠ 0 ∧ MvPolynomial.eval z ℓ = 0 ∧ MvPolynomial.eval z ℓ' = 0 := by
  classical
  set a : Fin 3 → K := linearCoeff ℓ with ha
  set b : Fin 3 → K := linearCoeff ℓ' with hb
  let φ : (Fin 3 → K) →ₗ[K] (Fin 2 → K) :=
    { toFun := fun z => ![∑ i : Fin 3, z i * a i, ∑ i : Fin 3, z i * b i]
      map_add' := by
        intro x y
        funext j
        fin_cases j <;>
          simp [← Finset.sum_add_distrib, add_mul]
      map_smul' := by
        intro c x
        funext j
        fin_cases j <;>
          simp [Finset.mul_sum, mul_assoc] }
  have hnotinj : ¬ Function.Injective φ := by
    intro hinj
    have hle := LinearMap.finrank_le_finrank_of_injective (f := φ) hinj
    simp at hle
  have hker : LinearMap.ker φ ≠ ⊥ := fun h => hnotinj (LinearMap.ker_eq_bot.mp h)
  obtain ⟨z, hzmem, hz0⟩ := Submodule.ne_bot_iff _ |>.mp hker
  have hφ : φ z = 0 := hzmem
  refine ⟨z, hz0, ?_, ?_⟩
  · rw [eval_eq_sum_linearCoeff hℓ z, ← ha]
    simpa [φ] using congrFun hφ 0
  · rw [eval_eq_sum_linearCoeff hℓ' z, ← hb]
    simpa [φ] using congrFun hφ 1

end LinearForms

/-! ### Restricting a conic to a line through the centre of projection -/

section LineRestriction

variable {K : Type u} [Field K]

/-- The restriction of a ternary quadratic form to the affine line `T ↦ (T, u, v)`, as a univariate
quadratic. -/
def conicLineRestriction {L : Type v} [CommRing L] [Algebra K L] (q : MvPolynomial (Fin 3) K)
    (u v : L) : Polynomial L :=
  Polynomial.C (MvPolynomial.aeval ![u, v] (ternaryCoeff q 2)) * Polynomial.X ^ 2 +
    Polynomial.C (MvPolynomial.aeval ![u, v] (ternaryCoeff q 1)) * Polynomial.X +
    Polynomial.C (MvPolynomial.aeval ![u, v] (ternaryCoeff q 0))

theorem natDegree_conicLineRestriction_le {L : Type v} [CommRing L] [Algebra K L]
    (q : MvPolynomial (Fin 3) K) (u v : L) : (conicLineRestriction q u v).natDegree ≤ 2 :=
  Polynomial.natDegree_quadratic_le

/-- The restriction really is the restriction: it evaluates to the value of the form on the line,
even after moving up a tower. -/
theorem aeval_conicLineRestriction {L : Type v} [CommRing L] [Algebra K L] {M : Type w}
    [CommRing M] [Algebra K M] [Algebra L M] [IsScalarTower K L M]
    {q : MvPolynomial (Fin 3) K} (hq : q.IsHomogeneous 2) (u v : L) (t : M) :
    Polynomial.aeval t (conicLineRestriction q u v) =
      MvPolynomial.aeval ![t, algebraMap L M u, algebraMap L M v] q := by
  have hpt : (fun i => algebraMap L M ((![u, v] : Fin 2 → L) i)) =
      (![algebraMap L M u, algebraMap L M v] : Fin 2 → M) := by
    funext i
    fin_cases i <;> simp
  rw [aeval_ternary_decomposition hq t (algebraMap L M u) (algebraMap L M v)]
  simp only [conicLineRestriction, map_add, map_mul, map_pow, Polynomial.aeval_C,
    Polynomial.aeval_X]
  rw [algebraMap_aeval (M := M) (![u, v] : Fin 2 → L) (ternaryCoeff q 2),
    algebraMap_aeval (M := M) (![u, v] : Fin 2 → L) (ternaryCoeff q 1),
    algebraMap_aeval (M := M) (![u, v] : Fin 2 → L) (ternaryCoeff q 0), hpt]

end LineRestriction

/-! ### The descent: one ratio in the separable closure suffices -/

section Descent

variable {K : Type u} [Field K]

/-- `2 ≠ 0` passes to the separable closure. -/
instance neZeroTwoSeparableClosure [NeZero (2 : K)] :
    NeZero (2 : ↥(separableClosure K (AlgebraicClosure K))) :=
  neZero_two_of_injective_algebraMap
    (algebraMap K ↥(separableClosure K (AlgebraicClosure K))).injective

/-- `3 ≠ 0` passes to the separable closure. -/
instance neZeroThreeSeparableClosure [NeZero (3 : K)] :
    NeZero (3 : ↥(separableClosure K (AlgebraicClosure K))) :=
  neZero_three_of_injective_algebraMap
    (algebraMap K ↥(separableClosure K (AlgebraicClosure K))).injective

/-- An element of the algebraic closure that is separable over the separable closure of `K` already
lies in it: the separable closure is separably closed. -/
theorem mem_separableClosure_of_isSeparable_separableClosure
    {t : AlgebraicClosure K}
    (h : IsSeparable ↥(separableClosure K (AlgebraicClosure K)) t) :
    t ∈ separableClosure K (AlgebraicClosure K) :=
  mem_separableClosure_iff.mpr
    (IsSeparable.of_algebra_isSeparable_of_isSeparable
      (E := ↥(separableClosure K (AlgebraicClosure K))) K h)

/-- **The descent step.**  If a common zero of three conics has its last two coordinates in the
separable closure, not both zero, then the three conics have a nonzero common zero over the
separable closure.

Only `2 ≠ 0` is needed: the free coordinate is a root of a quadratic over the separable closure,
and that field is separably closed. -/
theorem exists_separableClosure_common_zero_of_ratio [NeZero (2 : K)]
    {q : Fin 3 → MvPolynomial (Fin 3) K} (hq : ∀ j, (q j).IsHomogeneous 2)
    (u v : ↥(separableClosure K (AlgebraicClosure K))) (huv : ¬ (u = 0 ∧ v = 0))
    (t : AlgebraicClosure K)
    (hzero : ∀ j, MvPolynomial.aeval
      ![t, algebraMap _ (AlgebraicClosure K) u, algebraMap _ (AlgebraicClosure K) v] (q j) = 0) :
    ∃ z : Fin 3 → ↥(separableClosure K (AlgebraicClosure K)), z ≠ 0 ∧
      ∀ j, MvPolynomial.aeval z (q j) = 0 := by
  classical
  by_cases hall : ∀ j, conicLineRestriction (q j) u v = 0
  · -- every restriction vanishes identically: `(0, u, v)` is already a common zero
    refine ⟨![0, u, v], ?_, fun j => ?_⟩
    · intro h
      exact huv ⟨by simpa using congrFun h 1, by simpa using congrFun h 2⟩
    · have h := aeval_conicLineRestriction
        (M := ↥(separableClosure K (AlgebraicClosure K))) (hq j) u v 0
      rw [hall j] at h
      simpa using h.symm
  · -- some restriction is a nonzero quadratic: the free coordinate is separable
    push Not at hall
    obtain ⟨j₀, hj₀⟩ := hall
    have hroot : Polynomial.aeval t (conicLineRestriction (q j₀) u v) = 0 := by
      rw [aeval_conicLineRestriction (hq j₀) u v t]
      exact hzero j₀
    have hsep : IsSeparable ↥(separableClosure K (AlgebraicClosure K)) t :=
      isSeparable_of_aeval_eq_zero_of_natDegree_le_two hj₀ hroot
        (natDegree_conicLineRestriction_le _ _ _)
    have hmem : t ∈ separableClosure K (AlgebraicClosure K) :=
      mem_separableClosure_of_isSeparable_separableClosure hsep
    refine ⟨![⟨t, hmem⟩, u, v], ?_, fun j => ?_⟩
    · intro h
      exact huv ⟨by simpa using congrFun h 1, by simpa using congrFun h 2⟩
    · refine (algebraMap ↥(separableClosure K (AlgebraicClosure K))
        (AlgebraicClosure K)).injective ?_
      rw [map_zero, algebraMap_aeval (M := AlgebraicClosure K)]
      have hpt : (fun i => algebraMap ↥(separableClosure K (AlgebraicClosure K))
          (AlgebraicClosure K) ((![⟨t, hmem⟩, u, v] : Fin 3 →
            ↥(separableClosure K (AlgebraicClosure K))) i)) =
          ![t, algebraMap _ (AlgebraicClosure K) u, algebraMap _ (AlgebraicClosure K) v] := by
        funext i
        fin_cases i <;> simp
      rw [hpt]
      exact hzero j

end Descent

/-! ### A point on a conic, over the separable closure -/

section ConicPoint

variable {K : Type u} [Field K]

/-- **A conic over `K` has a point over the separable closure**, provided `2 ≠ 0`.

Restrict to the line `X₂ = 0`.  If the value at the centre of projection `(1 : 0 : 0)` is nonzero,
the restriction is a genuine quadratic, and its root in the algebraic closure has degree `≤ 2` over
`K`, hence is separable.  Otherwise the centre of projection is itself on the conic. -/
theorem exists_separableClosure_zero_of_isHomogeneous_two [NeZero (2 : K)]
    {f : MvPolynomial (Fin 3) K} (hf : f.IsHomogeneous 2) :
    ∃ z : Fin 3 → ↥(separableClosure K (AlgebraicClosure K)), z ≠ 0 ∧
      MvPolynomial.aeval z f = 0 := by
  classical
  by_cases hc : MvPolynomial.eval ![1, 0, 0] f = 0
  · -- the centre of projection is on the conic
    refine ⟨![1, 0, 0], ?_, ?_⟩
    · intro h
      have := congrFun h 0
      simp at this
    · have hpt : (![1, 0, 0] : Fin 3 → ↥(separableClosure K (AlgebraicClosure K))) =
          fun i => algebraMap K _ ((![1, 0, 0] : Fin 3 → K) i) := by
        funext i
        fin_cases i <;> simp
      rw [hpt, aeval_algebraMap_point, hc, map_zero]
  · -- a genuine quadratic on the line `X₂ = 0`
    set P : Polynomial K := conicLineRestriction f (1 : K) (0 : K) with hP
    have hlead : MvPolynomial.aeval (![(1 : K), 0]) (ternaryCoeff f 2) =
        MvPolynomial.eval ![1, 0, 0] f := by
      rw [ternaryCoeff_two_eq_C hf]
      simp
    have hdeg : P.natDegree = 2 := by
      rw [hP, conicLineRestriction]
      exact Polynomial.natDegree_quadratic (by rw [hlead]; exact hc)
    have hP0 : P ≠ 0 := by
      intro h
      rw [h] at hdeg
      simp at hdeg
    have hdegne : P.degree ≠ 0 := by
      rw [Polynomial.degree_eq_natDegree hP0, hdeg]
      exact by decide
    obtain ⟨r, hr⟩ := IsAlgClosed.exists_aeval_eq_zero (AlgebraicClosure K) P hdegne
    have hmem : r ∈ separableClosure K (AlgebraicClosure K) :=
      mem_separableClosure_algebraicClosure_of_natDegree_le_two hP0 hr (le_of_eq hdeg)
    refine ⟨![⟨r, hmem⟩, 1, 0], ?_, ?_⟩
    · intro h
      have := congrFun h 1
      simp at this
    · refine (algebraMap ↥(separableClosure K (AlgebraicClosure K))
        (AlgebraicClosure K)).injective ?_
      rw [map_zero, algebraMap_aeval (M := AlgebraicClosure K)]
      have hpt : (fun i => algebraMap ↥(separableClosure K (AlgebraicClosure K))
          (AlgebraicClosure K) ((![⟨r, hmem⟩, 1, 0] : Fin 3 →
            ↥(separableClosure K (AlgebraicClosure K))) i)) =
          (![r, algebraMap K (AlgebraicClosure K) 1, algebraMap K (AlgebraicClosure K) 0] :
            Fin 3 → AlgebraicClosure K) := by
        funext i
        fin_cases i <;> simp
      rw [hpt, ← aeval_conicLineRestriction (M := AlgebraicClosure K) hf (1 : K) (0 : K) r]
      exact hr

end ConicPoint

/-! ### The degenerate branch: no pair of partials is relatively prime -/

section Degenerate

variable {K : Type u} [Field K]

/-- Two elements that are not relatively prime, and are not both zero, have a common irreducible
factor. -/
theorem exists_irreducible_common_factor {p p' : MvPolynomial (Fin 3) K}
    (hrel : ¬ IsRelPrime p p') (hne : ¬ (p = 0 ∧ p' = 0)) :
    ∃ h : MvPolynomial (Fin 3) K, Irreducible h ∧ h ∣ p ∧ h ∣ p' := by
  classical
  obtain ⟨d, hdp, hdp', hdu⟩ : ∃ d, d ∣ p ∧ d ∣ p' ∧ ¬ IsUnit d := by
    by_contra hcon
    push Not at hcon
    exact hrel fun d hd hd' => hcon d hd hd'
  have hd0 : d ≠ 0 := by
    rintro rfl
    exact hne ⟨zero_dvd_iff.mp hdp, zero_dvd_iff.mp hdp'⟩
  obtain ⟨h, hirr, hdvd⟩ := WfDvdMonoid.exists_irreducible_factor hdu hd0
  exact ⟨h, hirr, hdvd.trans hdp, hdvd.trans hdp'⟩

/-- An irreducible homogeneous polynomial has positive degree. -/
theorem ne_zero_of_irreducible_isHomogeneous {h : MvPolynomial (Fin 3) K} {m : ℕ}
    (hirr : Irreducible h) (hh : h.IsHomogeneous m) : m ≠ 0 := by
  rintro rfl
  refine hirr.not_isUnit ?_
  rw [MvPolynomial.isUnit_iff_eq_C_of_isReduced]
  refine ⟨MvPolynomial.coeff 0 h, isUnit_iff_ne_zero.mpr ?_, eq_C_of_isHomogeneous_zero hh⟩
  intro hz
  exact hirr.ne_zero (by rw [eq_C_of_isHomogeneous_zero hh, hz, map_zero])

/-- A `K`-rational common zero of a divisor family gives a common zero over the separable
closure. -/
private theorem exists_separableClosure_of_rational_zero
    {q : Fin 3 → MvPolynomial (Fin 3) K} {z : Fin 3 → K} (hz : z ≠ 0)
    (hzero : ∀ j, MvPolynomial.eval z (q j) = 0) :
    ∃ w : Fin 3 → ↥(separableClosure K (AlgebraicClosure K)), w ≠ 0 ∧
      ∀ j, MvPolynomial.aeval w (q j) = 0 := by
  refine ⟨fun i => algebraMap K _ (z i), ?_, fun j => ?_⟩
  · intro h
    refine hz (funext fun i => ?_)
    have := congrFun h i
    exact (algebraMap K ↥(separableClosure K (AlgebraicClosure K))).injective
      (by simpa using this)
  · rw [aeval_algebraMap_point, hzero j, map_zero]

/-- **The two-lines case.**  If every one of the three conics is divisible by one of two linear
forms, then they have a nonzero common zero over `K`, hence over the separable closure. -/
theorem exists_separableClosure_common_zero_of_linear_divisors
    {q : Fin 3 → MvPolynomial (Fin 3) K} {ℓ ℓ' : MvPolynomial (Fin 3) K}
    (hℓ : ℓ.IsHomogeneous 1) (hℓ' : ℓ'.IsHomogeneous 1)
    (hdvd : ∀ j, ℓ ∣ q j ∨ ℓ' ∣ q j) :
    ∃ z : Fin 3 → ↥(separableClosure K (AlgebraicClosure K)), z ≠ 0 ∧
      ∀ j, MvPolynomial.aeval z (q j) = 0 := by
  obtain ⟨z, hz0, hzℓ, hzℓ'⟩ := exists_ne_zero_common_zero_of_linear hℓ hℓ'
  refine exists_separableClosure_of_rational_zero hz0 fun j => ?_
  rcases hdvd j with ⟨r, hr⟩ | ⟨r, hr⟩
  · rw [hr, map_mul, hzℓ, zero_mul]
  · rw [hr, map_mul, hzℓ', zero_mul]

/-- **The common-factor case.**  An irreducible factor common to all three conics cuts out a curve
inside their common zero locus, and that curve has a point over the separable closure. -/
theorem exists_separableClosure_common_zero_of_common_factor [NeZero (2 : K)]
    {q : Fin 3 → MvPolynomial (Fin 3) K} (hq : ∀ j, (q j).IsHomogeneous 2)
    {h : MvPolynomial (Fin 3) K} (hirr : Irreducible h) (hdvd : ∀ j, h ∣ q j)
    {j₀ : Fin 3} (hj₀ : q j₀ ≠ 0) :
    ∃ z : Fin 3 → ↥(separableClosure K (AlgebraicClosure K)), z ≠ 0 ∧
      ∀ j, MvPolynomial.aeval z (q j) = 0 := by
  obtain ⟨m, hm, hmle⟩ :=
    MvPolynomial.exists_isHomogeneous_of_dvd_isHomogeneous (hq j₀) hj₀ (hdvd j₀)
  have hm0 : m ≠ 0 := ne_zero_of_irreducible_isHomogeneous hirr hm
  have hcase : m = 1 ∨ m = 2 := by omega
  rcases hcase with rfl | rfl
  · -- a common line
    exact exists_separableClosure_common_zero_of_linear_divisors hm hm fun j => Or.inl (hdvd j)
  · -- a common conic
    obtain ⟨z, hz0, hz⟩ := exists_separableClosure_zero_of_isHomogeneous_two hm
    refine ⟨z, hz0, fun j => ?_⟩
    obtain ⟨r, hr⟩ := hdvd j
    rw [hr, map_mul, hz, zero_mul]

/-- **The degenerate branch.**  Three conics no two of which are relatively prime have a nonzero
common zero over the separable closure. -/
theorem exists_separableClosure_common_zero_of_not_isRelPrime [NeZero (2 : K)]
    {q : Fin 3 → MvPolynomial (Fin 3) K} (hq : ∀ j, (q j).IsHomogeneous 2)
    (hnrp : ∀ i j : Fin 3, i ≠ j → ¬ IsRelPrime (q i) (q j)) :
    ∃ z : Fin 3 → ↥(separableClosure K (AlgebraicClosure K)), z ≠ 0 ∧
      ∀ j, MvPolynomial.aeval z (q j) = 0 := by
  classical
  by_cases hq0 : q 0 = 0
  · by_cases hq12 : q 1 = 0 ∧ q 2 = 0
    · -- all three vanish: any point does
      have hzq : ∀ j : Fin 3, q j = 0 := by
        intro j
        fin_cases j
        · exact hq0
        · exact hq12.1
        · exact hq12.2
      refine ⟨![1, 0, 0], ?_, fun j => ?_⟩
      · intro h
        simpa using congrFun h 0
      · rw [hzq j, map_zero]
    · obtain ⟨h, hirr, hd1, hd2⟩ :=
        exists_irreducible_common_factor (hnrp 1 2 (by decide)) hq12
      have hd0 : h ∣ q 0 := by rw [hq0]; exact dvd_zero h
      have hdvd : ∀ j : Fin 3, h ∣ q j := by
        intro j
        fin_cases j
        · exact hd0
        · exact hd1
        · exact hd2
      obtain ⟨j₀, hj₀⟩ : ∃ j₀ : Fin 3, q j₀ ≠ 0 := by
        rcases not_and_or.mp hq12 with h | h
        · exact ⟨1, h⟩
        · exact ⟨2, h⟩
      exact exists_separableClosure_common_zero_of_common_factor hq hirr hdvd hj₀
  · obtain ⟨h₁, hirr₁, hd₁₀, hd₁₁⟩ :=
      exists_irreducible_common_factor (hnrp 0 1 (by decide)) (fun hz => hq0 hz.1)
    obtain ⟨h₂, hirr₂, hd₂₀, hd₂₂⟩ :=
      exists_irreducible_common_factor (hnrp 0 2 (by decide)) (fun hz => hq0 hz.1)
    by_cases hcom : h₁ ∣ q 2
    · have hdvd : ∀ j : Fin 3, h₁ ∣ q j := by
        intro j
        fin_cases j
        · exact hd₁₀
        · exact hd₁₁
        · exact hcom
      exact exists_separableClosure_common_zero_of_common_factor hq hirr₁ hdvd hq0
    · -- `h₁` and `h₂` are relatively prime, so both are linear
      have hrel : IsRelPrime h₁ h₂ :=
        hirr₁.isRelPrime_iff_not_dvd.mpr fun hdd => hcom (hdd.trans hd₂₂)
      have hmul : h₁ * h₂ ∣ q 0 := hrel.mul_dvd hd₁₀ hd₂₀
      obtain ⟨m₁, hm₁, -⟩ :=
        MvPolynomial.exists_isHomogeneous_of_dvd_isHomogeneous (hq 0) hq0 hd₁₀
      obtain ⟨m₂, hm₂, -⟩ :=
        MvPolynomial.exists_isHomogeneous_of_dvd_isHomogeneous (hq 0) hq0 hd₂₀
      have hprod0 : h₁ * h₂ ≠ 0 := mul_ne_zero hirr₁.ne_zero hirr₂.ne_zero
      have hsum : m₁ + m₂ ≤ 2 := by
        have hle := MvPolynomial.totalDegree_le_of_dvd_of_isDomain hmul hq0
        rwa [(hm₁.mul hm₂).totalDegree hprod0, (hq 0).totalDegree hq0] at hle
      have hm₁0 : m₁ ≠ 0 := ne_zero_of_irreducible_isHomogeneous hirr₁ hm₁
      have hm₂0 : m₂ ≠ 0 := ne_zero_of_irreducible_isHomogeneous hirr₂ hm₂
      have he₁ : m₁ = 1 := by omega
      have he₂ : m₂ = 1 := by omega
      subst he₁
      subst he₂
      refine exists_separableClosure_common_zero_of_linear_divisors hm₁ hm₂ fun j => ?_
      fin_cases j
      · exact Or.inl hd₁₀
      · exact Or.inl hd₁₁
      · exact Or.inr hd₂₂

end Degenerate

/-! ### The main branch and the assembly -/

section Main

variable {K : Type u} [Field K]

/-- **A nonzero common zero of the three partials, over the separable closure.**

The main branch: if two of the conics are relatively prime, `ConicResultant` produces a nonzero
form of degree `≤ 4` over `K` killing the coordinate ratio, and `SeparableLowDegree` makes that
ratio separable.  The chart `y₂ = 0` needs no elimination at all. -/
theorem exists_separableClosure_common_zero_of_conics [NeZero (2 : K)] [NeZero (3 : K)]
    {q : Fin 3 → MvPolynomial (Fin 3) K} (hq : ∀ j, (q j).IsHomogeneous 2)
    (y : Fin 3 → AlgebraicClosure K) (hy0 : y ≠ 0)
    (hzero : ∀ j, MvPolynomial.aeval y (q j) = 0) :
    ∃ z : Fin 3 → ↥(separableClosure K (AlgebraicClosure K)), z ≠ 0 ∧
      ∀ j, MvPolynomial.aeval z (q j) = 0 := by
  classical
  -- rescaling a common zero keeps it a common zero
  have hscale : ∀ (c : AlgebraicClosure K) (j : Fin 3),
      MvPolynomial.aeval (fun i => c * y i) (q j) = 0 := by
    intro c j
    rw [aeval_smul_point_of_isHomogeneous (S := AlgebraicClosure K) (hq j) c y, hzero j, mul_zero]
  by_cases hy2 : y 2 = 0
  · by_cases hy1 : y 1 = 0
    · -- the point is `(1 : 0 : 0)`, already rational
      have hy00 : y 0 ≠ 0 := by
        intro h
        exact hy0 (funext fun i => by fin_cases i <;> simp [h, hy1, hy2])
      have hz0 : (![1, 0, 0] : Fin 3 → K) ≠ 0 := by
        intro h
        simpa using congrFun h 0
      refine exists_separableClosure_of_rational_zero hz0 fun j => ?_
      have hpt : (fun i => (y 0)⁻¹ * y i) =
          fun i => algebraMap K (AlgebraicClosure K) ((![1, 0, 0] : Fin 3 → K) i) := by
        funext i
        fin_cases i <;> simp [hy1, hy2, inv_mul_cancel₀ hy00]
      have h := hscale (y 0)⁻¹ j
      rw [hpt, aeval_algebraMap_point] at h
      exact (algebraMap K (AlgebraicClosure K)).injective (by simpa using h)
    · -- the last two coordinates normalise to `(1, 0)`
      have hone : ¬ ((1 : ↥(separableClosure K (AlgebraicClosure K))) = 0 ∧
          (0 : ↥(separableClosure K (AlgebraicClosure K))) = 0) := by
        rintro ⟨h1, -⟩
        exact one_ne_zero h1
      refine exists_separableClosure_common_zero_of_ratio hq 1 0 hone ((y 1)⁻¹ * y 0) fun j => ?_
      have hpt : (fun i => (y 1)⁻¹ * y i) =
          ![(y 1)⁻¹ * y 0,
            algebraMap ↥(separableClosure K (AlgebraicClosure K)) (AlgebraicClosure K) 1,
            algebraMap ↥(separableClosure K (AlgebraicClosure K)) (AlgebraicClosure K) 0] := by
        funext i
        fin_cases i <;> simp [hy2, inv_mul_cancel₀ hy1]
      have h := hscale (y 1)⁻¹ j
      rwa [hpt] at h
  · -- the interesting chart
    by_cases hrp : ∃ i j : Fin 3, i ≠ j ∧ IsRelPrime (q i) (q j)
    · obtain ⟨i, j, -, hrel⟩ := hrp
      have hy : (![y 0, y 1, y 2] : Fin 3 → AlgebraicClosure K) = y := by
        funext k
        fin_cases k <;> rfl
      obtain ⟨f, hf0, hfd, hfz⟩ :=
        exists_polynomial_ne_zero_natDegree_le_four (hq i) (hq j) hrel
          (by rw [hy]; exact hzero i) (by rw [hy]; exact hzero j) hy2
      have hmem : y 1 / y 2 ∈ separableClosure K (AlgebraicClosure K) :=
        mem_separableClosure_algebraicClosure_of_natDegree_le_four hf0 hfz hfd
      have hone : ¬ ((⟨y 1 / y 2, hmem⟩ : ↥(separableClosure K (AlgebraicClosure K))) = 0 ∧
          (1 : ↥(separableClosure K (AlgebraicClosure K))) = 0) := by
        rintro ⟨-, h1⟩
        exact one_ne_zero h1
      refine exists_separableClosure_common_zero_of_ratio hq ⟨y 1 / y 2, hmem⟩ 1 hone
        ((y 2)⁻¹ * y 0) fun k => ?_
      have hpt : (fun i => (y 2)⁻¹ * y i) =
          ![(y 2)⁻¹ * y 0,
            algebraMap ↥(separableClosure K (AlgebraicClosure K)) (AlgebraicClosure K)
              ⟨y 1 / y 2, hmem⟩,
            algebraMap ↥(separableClosure K (AlgebraicClosure K)) (AlgebraicClosure K) 1] := by
        funext i
        fin_cases i
        · rfl
        · change (y 2)⁻¹ * y 1 = y 1 / y 2
          rw [div_eq_inv_mul]
        · change (y 2)⁻¹ * y 2 = 1
          rw [inv_mul_cancel₀ hy2]
      have h := hscale (y 2)⁻¹ k
      rwa [hpt] at h
    · push Not at hrp
      exact exists_separableClosure_common_zero_of_not_isRelPrime hq
        fun i j hij => hrp i j hij

/-- **A singular point of a plane cubic can be taken separable over the base field.**

Proved whenever `2 ≠ 0` and `3 ≠ 0` in `K`, that is, whenever `ringChar K ∤ 6`.  Characteristics
`2` and `3` are genuine counterexamples: quasi-elliptic fibrations live exactly there. -/
theorem exists_separableClosure_singularPoint_of_cubic
    [NeZero (2 : K)] [NeZero (3 : K)]
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (y : Fin 3 → AlgebraicClosure K) (hy0 : y ≠ 0)
    (_hval : MvPolynomial.eval y
      (MvPolynomial.map (algebraMap K (AlgebraicClosure K)) G) = 0)
    (hgrad : ∀ j : Fin 3, MvPolynomial.eval y
      (MvPolynomial.map (algebraMap K (AlgebraicClosure K)) (pderiv j G)) = 0) :
    ∃ z : Fin 3 → ↥(separableClosure K (AlgebraicClosure K)), z ≠ 0 ∧
      MvPolynomial.eval z (MvPolynomial.map (algebraMap K
        ↥(separableClosure K (AlgebraicClosure K))) G) = 0 ∧
      ∀ j : Fin 3, MvPolynomial.eval z (MvPolynomial.map (algebraMap K
        ↥(separableClosure K (AlgebraicClosure K))) (pderiv j G)) = 0 := by
  classical
  have hq : ∀ j : Fin 3, (pderiv j G).IsHomogeneous 2 := fun j => by
    simpa using hG.pderiv (i := j)
  obtain ⟨z, hz0, hz⟩ :=
    exists_separableClosure_common_zero_of_conics (q := fun j => pderiv j G) hq y hy0
      fun j => by rw [← eval_map_eq_aeval]; exact hgrad j
  refine ⟨z, hz0, ?_, fun j => by rw [eval_map_eq_aeval]; exact hz j⟩
  -- Euler's identity: `3 ≠ 0` makes `G` redundant
  rw [eval_map_eq_aeval]
  have heuler := congrArg (fun p => MvPolynomial.aeval z p) hG.sum_X_mul_pderiv
  simp only [map_sum, map_mul, MvPolynomial.aeval_X, map_nsmul] at heuler
  have hz' : ∑ i : Fin 3, z i * MvPolynomial.aeval z (pderiv i G) = 0 :=
    Finset.sum_eq_zero fun i _ => by rw [hz i, mul_zero]
  rw [hz'] at heuler
  have h3 : (3 : ↥(separableClosure K (AlgebraicClosure K))) ≠ 0 := three_ne_zero
  have hfin := heuler.symm
  rw [nsmul_eq_mul] at hfin
  simpa [h3] using hfin

end Main

end

end BConicBundleMultisections
