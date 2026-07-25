/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
public import Mathlib.Algebra.Polynomial.FieldDivision

/-!
# A kernel section with no common root

A square matrix of univariate polynomials with vanishing determinant has a nonzero kernel vector
over `k[t]`; this module produces one whose entries have **no common root**, so that it defines a
point of projective space over *every* parameter value.

That last property is what the conic-discriminant argument needs
(`GoodLineCondition.coordinateLineConicDiscriminant_ne_zero_of_smooth`): the vertex of the singular
conic `Q_t` has to be a genuine point for every `t`, or the singular point of `X` it produces is not
a point at all.

## Degree minimality instead of gcd

The usual construction divides a kernel vector by the gcd of its entries.  Here it is cheaper to
take a nonzero kernel vector of **minimal total degree**: if all entries vanished at `t₀`, dividing
through by `X - C t₀` would give a nonzero kernel vector of smaller total degree.  This avoids the
`GCDMonoid` API entirely — all it uses is that `k[t]` is a domain in which `X - C t₀` divides
exactly the polynomials with root `t₀`.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

/-- **A kernel section with no common root.**

If the determinant vanishes, there is a nonzero vector in the kernel whose entries have no common
root — so at every parameter value it is a nonzero vector, hence a point of projective space.

Stated for any square size and any field; nothing is special to `3 × 3`. -/
theorem exists_kernel_vector_no_common_root {k : Type u} [Field k] {m : ℕ}
    (M : Matrix (Fin m) (Fin m) (Polynomial k)) (hdet : M.det = 0) :
    ∃ n : Fin m → Polynomial k, n ≠ 0 ∧ M.mulVec n = 0 ∧
      ∀ t : k, ∃ i : Fin m, (n i).eval t ≠ 0 := by
  classical
  -- the total degrees of nonzero kernel vectors form a nonempty set of naturals
  have hex : ∃ d : ℕ, ∃ n : Fin m → Polynomial k, n ≠ 0 ∧ M.mulVec n = 0 ∧
      (∑ i, (n i).natDegree) = d := by
    obtain ⟨n, hn0, hn⟩ := Matrix.exists_mulVec_eq_zero_iff.mpr hdet
    exact ⟨_, n, hn0, hn, rfl⟩
  obtain ⟨n, hn0, hker, hdeg⟩ := Nat.find_spec hex
  refine ⟨n, hn0, hker, fun t => ?_⟩
  by_contra hall
  push Not at hall
  -- every entry has `t` as a root, so `X - C t` divides through
  set q : Polynomial k := Polynomial.X - Polynomial.C t with hq
  have hq0 : q ≠ 0 := Polynomial.X_sub_C_ne_zero t
  have hqdeg : q.natDegree = 1 := Polynomial.natDegree_X_sub_C t
  have hdvd : ∀ i, q ∣ n i := fun i => Polynomial.dvd_iff_isRoot.mpr (hall i)
  choose w hw using hdvd
  -- the quotient is again a kernel vector, and it is nonzero
  have hwker : M.mulVec w = 0 := by
    have hsmul : q • (M.mulVec w) = 0 := by
      rw [← Matrix.mulVec_smul]
      have hqw : (q • w) = n := by
        funext i
        rw [Pi.smul_apply, smul_eq_mul, ← hw i]
      rw [hqw, hker]
    funext i
    have hi := congrFun hsmul i
    simp only [Pi.smul_apply, smul_eq_mul, Pi.zero_apply] at hi
    exact (mul_eq_zero.mp hi).resolve_left hq0
  have hw0 : w ≠ 0 := by
    intro h
    refine hn0 (funext fun i => ?_)
    rw [hw i, h]
    simp
  -- and its total degree is strictly smaller
  obtain ⟨i₀, hi₀⟩ : ∃ i, n i ≠ 0 := by
    by_contra hzero
    push Not at hzero
    exact hn0 (funext hzero)
  have hstep : ∀ i, (w i).natDegree ≤ (n i).natDegree ∧
      (n i ≠ 0 → (w i).natDegree < (n i).natDegree) := by
    intro i
    by_cases hni : n i = 0
    · have hwi : w i = 0 := by
        have hi := hw i
        rw [hni] at hi
        exact (mul_eq_zero.mp hi.symm).resolve_left hq0
      simp [hni, hwi]
    · have hwi : w i ≠ 0 := by
        intro h
        exact hni (by rw [hw i, h, mul_zero])
      have hmul : (n i).natDegree = q.natDegree + (w i).natDegree := by
        rw [hw i, Polynomial.natDegree_mul hq0 hwi]
      rw [hqdeg] at hmul
      omega
  have hdrop : (∑ i, (w i).natDegree) < ∑ i, (n i).natDegree :=
    Finset.sum_lt_sum (fun i _ => (hstep i).1)
      ⟨i₀, Finset.mem_univ i₀, (hstep i₀).2 hi₀⟩
  rw [hdeg] at hdrop
  exact Nat.find_min hex hdrop ⟨w, hw0, hwker, rfl⟩

end

end BConicBundleMultisections
