/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineChart

/-!
# Degree bounds for affine biprojective chart equations

Dehomogenizing a bihomogeneous equation lowers, but never raises, its degree in either coordinate
block. This file packages the support-wise weighted-degree bound needed to state that fact over an
arbitrary commutative coefficient ring, then applies it to every generic standard product chart.
-/

@[expose] public section


namespace MvPolynomial

open Finsupp

variable {σ τ R S : Type*} [CommSemiring R] [CommSemiring S]

/-- Every monomial occurring in `p` has `w`-weighted degree at most `d`. Unlike weighted
homogeneity, this predicate allows monomials of different degrees. -/
def HasWeightedDegreeLE (p : MvPolynomial σ R) (w : σ → ℕ) (d : ℕ) : Prop :=
  ∀ ⦃s : σ →₀ ℕ⦄, coeff s p ≠ 0 → weight w s ≤ d

namespace HasWeightedDegreeLE

theorem mono {p : MvPolynomial σ R} {w : σ → ℕ} {d e : ℕ}
    (hp : p.HasWeightedDegreeLE w d) (hde : d ≤ e) :
    p.HasWeightedDegreeLE w e := by
  intro s hs
  exact (hp hs).trans hde

theorem weightedTotalDegree_le {p : MvPolynomial σ R} {w : σ → ℕ} {d : ℕ}
    (hp : p.HasWeightedDegreeLE w d) : p.weightedTotalDegree w ≤ d := by
  rw [weightedTotalDegree, Finset.sup_le_iff]
  intro s hs
  exact hp (mem_support_iff.mp hs)

theorem zero (w : σ → ℕ) (d : ℕ) :
    HasWeightedDegreeLE (0 : MvPolynomial σ R) w d := by
  intro s hs
  exact False.elim (hs (coeff_zero s))

theorem C (w : σ → ℕ) (r : R) :
    HasWeightedDegreeLE (MvPolynomial.C r : MvPolynomial σ R) w 0 := by
  classical
  intro s hs
  have hs0 : s = 0 := by
    by_contra h
    have h' : ¬(0 = s) := by simpa [eq_comm] using h
    apply hs
    simp [coeff_C, h']
  subst s
  simp [Finsupp.weight]

theorem add {p q : MvPolynomial σ R} {w : σ → ℕ} {d : ℕ}
    (hp : p.HasWeightedDegreeLE w d) (hq : q.HasWeightedDegreeLE w d) :
    (p + q).HasWeightedDegreeLE w d := by
  intro s hs
  rw [coeff_add] at hs
  by_cases hps : coeff s p = 0
  · exact hq (by simpa [hps] using hs)
  · exact hp hps

theorem mul {p q : MvPolynomial σ R} {w : σ → ℕ} {d e : ℕ}
    (hp : p.HasWeightedDegreeLE w d) (hq : q.HasWeightedDegreeLE w e) :
    (p * q).HasWeightedDegreeLE w (d + e) := by
  classical
  intro s hs
  rw [coeff_mul] at hs
  obtain ⟨⟨a, b⟩, hab, hprod⟩ := Finset.exists_ne_zero_of_sum_ne_zero hs
  have ha : coeff a p ≠ 0 := left_ne_zero_of_mul hprod
  have hb : coeff b q ≠ 0 := right_ne_zero_of_mul hprod
  rw [← Finset.mem_antidiagonal.mp hab, map_add]
  exact Nat.add_le_add (hp ha) (hq hb)

theorem pow {p : MvPolynomial σ R} {w : σ → ℕ} {d : ℕ}
    (hp : p.HasWeightedDegreeLE w d) (k : ℕ) :
    (p ^ k).HasWeightedDegreeLE w (k * d) := by
  induction k with
  | zero => simpa using C (R := R) w 1
  | succ k ih =>
      rw [pow_succ, Nat.succ_mul]
      exact ih.mul hp

theorem prod {ι : Type*} (s : Finset ι) (p : ι → MvPolynomial σ R)
    (w : σ → ℕ) (d : ι → ℕ)
    (hp : ∀ i ∈ s, (p i).HasWeightedDegreeLE w (d i)) :
    (∏ i ∈ s, p i).HasWeightedDegreeLE w (∑ i ∈ s, d i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simpa using C (R := R) w 1
  | @insert i s hi ih =>
      simp only [Finset.prod_insert hi, Finset.sum_insert hi]
      exact (hp i (Finset.mem_insert_self i s)).mul
        (ih fun j hj ↦ hp j (Finset.mem_insert_of_mem hj))

end HasWeightedDegreeLE

theorem IsWeightedHomogeneous.hasWeightedDegreeLE
    {p : MvPolynomial σ R} {w : σ → ℕ} {d : ℕ}
    (hp : p.IsWeightedHomogeneous w d) : p.HasWeightedDegreeLE w d := by
  intro s hs
  exact (hp hs).le

theorem IsWeightedHomogeneous.aeval_hasWeightedDegreeLE
    {p : MvPolynomial σ R} {w : σ → ℕ} {d : ℕ}
    (hp : p.IsWeightedHomogeneous w d) [Algebra R S]
    (v : τ → ℕ) (g : σ → MvPolynomial τ S)
    (hg : ∀ i, (g i).HasWeightedDegreeLE v (w i)) :
    (aeval g p).HasWeightedDegreeLE v d := by
  induction hp using IsWeightedHomogeneous.induction_on with
  | zero => exact HasWeightedDegreeLE.zero _ _
  | add p q hp hq ihp ihq => simpa only [map_add] using ihp.add ihq
  | monomial s r hr =>
      rw [aeval_monomial]
      have hprod :
          (s.prod fun i k ↦ g i ^ k).HasWeightedDegreeLE v
            (∑ i ∈ s.support, s i * w i) := by
        apply HasWeightedDegreeLE.prod s.support (fun i ↦ g i ^ s i)
          v (fun i ↦ s i * w i)
        intro i hi
        exact (hg i).pow (s i)
      have hdeg : ∑ i ∈ s.support, s i * w i = d := by
        rw [← hr, weight_apply]
        change (∑ i ∈ s.support, s i * w i) =
          ∑ i ∈ s.support, s i * w i
        rfl
      have h :=
        (HasWeightedDegreeLE.C (σ := τ) v (algebraMap R S r)).mul hprod
      rw [zero_add, hdeg] at h
      simpa using h

end MvPolynomial

namespace BConicBundleMultisections

noncomputable section

universe u

/-- The total degree in the affine variables belonging to the first projective factor. -/
def affineLeftDegreeWeight {m n : ℕ} : Fin m ⊕ Fin n → ℕ
  | .inl _ => 1
  | .inr _ => 0

/-- The total degree in the affine variables belonging to the second projective factor. -/
def affineRightDegreeWeight {m n : ℕ} : Fin m ⊕ Fin n → ℕ
  | .inl _ => 0
  | .inr _ => 1

namespace BiprojectiveSpace

theorem affineChartVariable_hasWeightedDegreeLE_left
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (l : BiprojectiveCoordinate m n) :
    (affineChartVariable m n R i j l).HasWeightedDegreeLE
      affineLeftDegreeWeight (leftDegreeWeight l) := by
  rcases l with l | l
  · rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
    · simpa [affineChartVariable, leftDegreeWeight, affineLeftDegreeWeight] using
        (MvPolynomial.HasWeightedDegreeLE.C
          (σ := Fin m ⊕ Fin n) affineLeftDegreeWeight (1 : R)).mono (Nat.zero_le 1)
    · simpa [affineChartVariable, leftDegreeWeight, affineLeftDegreeWeight] using
        (MvPolynomial.isWeightedHomogeneous_X R affineLeftDegreeWeight
          (Sum.inl r)).hasWeightedDegreeLE
  · rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨r, rfl⟩
    · simpa [affineChartVariable, leftDegreeWeight, affineLeftDegreeWeight] using
        MvPolynomial.HasWeightedDegreeLE.C
          (σ := Fin m ⊕ Fin n) affineLeftDegreeWeight (1 : R)
    · simpa [affineChartVariable, leftDegreeWeight, affineLeftDegreeWeight] using
        (MvPolynomial.isWeightedHomogeneous_X R affineLeftDegreeWeight
          (Sum.inr r)).hasWeightedDegreeLE

theorem affineChartVariable_hasWeightedDegreeLE_right
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (l : BiprojectiveCoordinate m n) :
    (affineChartVariable m n R i j l).HasWeightedDegreeLE
      affineRightDegreeWeight (rightDegreeWeight l) := by
  rcases l with l | l
  · rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
    · simpa [affineChartVariable, rightDegreeWeight, affineRightDegreeWeight] using
        MvPolynomial.HasWeightedDegreeLE.C
          (σ := Fin m ⊕ Fin n) affineRightDegreeWeight (1 : R)
    · simpa [affineChartVariable, rightDegreeWeight, affineRightDegreeWeight] using
        (MvPolynomial.isWeightedHomogeneous_X R affineRightDegreeWeight
          (Sum.inl r)).hasWeightedDegreeLE
  · rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨r, rfl⟩
    · simpa [affineChartVariable, rightDegreeWeight, affineRightDegreeWeight] using
        (MvPolynomial.HasWeightedDegreeLE.C
          (σ := Fin m ⊕ Fin n) affineRightDegreeWeight (1 : R)).mono (Nat.zero_le 1)
    · simpa [affineChartVariable, rightDegreeWeight, affineRightDegreeWeight] using
        (MvPolynomial.isWeightedHomogeneous_X R affineRightDegreeWeight
          (Sum.inr r)).hasWeightedDegreeLE

end BiprojectiveSpace

theorem IsBihomogeneousOfBidegree.affineChartEquation_hasWeightedDegreeLE_left
    {m n d e : ℕ} {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (BiprojectiveSpace.affineChartEquation m n R i j F).HasWeightedDegreeLE
      affineLeftDegreeWeight d := by
  apply hF.isWeightedHomogeneous_left.aeval_hasWeightedDegreeLE
  exact BiprojectiveSpace.affineChartVariable_hasWeightedDegreeLE_left m n R i j

theorem IsBihomogeneousOfBidegree.affineChartEquation_hasWeightedDegreeLE_right
    {m n d e : ℕ} {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (BiprojectiveSpace.affineChartEquation m n R i j F).HasWeightedDegreeLE
      affineRightDegreeWeight e := by
  apply hF.isWeightedHomogeneous_right.aeval_hasWeightedDegreeLE
  exact BiprojectiveSpace.affineChartVariable_hasWeightedDegreeLE_right m n R i j

theorem IsBihomogeneousOfBidegree.affineChartEquation_leftDegree_le
    {m n d e : ℕ} {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (BiprojectiveSpace.affineChartEquation m n R i j F).weightedTotalDegree
      affineLeftDegreeWeight ≤ d :=
  (hF.affineChartEquation_hasWeightedDegreeLE_left i j).weightedTotalDegree_le

theorem IsBihomogeneousOfBidegree.affineChartEquation_rightDegree_le
    {m n d e : ℕ} {R : Type u} [CommRing R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (BiprojectiveSpace.affineChartEquation m n R i j F).weightedTotalDegree
      affineRightDegreeWeight ≤ e :=
  (hF.affineChartEquation_hasWeightedDegreeLE_right i j).weightedTotalDegree_le

end

end BConicBundleMultisections
