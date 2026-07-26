/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualRelationBigrading
public import BConicBundleMultisections.HomogeneousFactor
public import Mathlib.Algebra.GCDMonoid.Basic
public import Mathlib.Algebra.Polynomial.Degree.TrailingDegree
public import Mathlib.RingTheory.Polynomial.UniqueFactorization

/-!
# Removing first-block content from a residual equation

This file isolates the elementary content-removal algebra for a Cox polynomial which is linear in
the second block.  The coefficients form a finite tuple of ordinary first-block polynomials, so
their gcd can be divided out and the resulting linear equation is primitive with respect to
right-degree-zero factors.
-/

@[expose] public section

namespace BConicBundleMultisections
namespace ResidualPrimitiveEquation

noncomputable section

open MvPolynomial
open ResidualDivisor

universe u

variable {K : Type u} [Field K]

local instance : GCDMonoid (MvPolynomial (Fin 3) K) :=
  UniqueFactorizationMonoid.toGCDMonoid _

/-! ### Coefficient bookkeeping for the two Cox blocks -/

/-- The biprojective multi-index with prescribed first and second parts. -/
private def localBiIndex (n m : Fin 3 →₀ ℕ) : BiprojectiveCoordinate 2 2 →₀ ℕ :=
  Finsupp.equivFunOnFinite.symm (Sum.elim ⇑n ⇑m)

@[simp] private theorem localBiIndex_apply_inl (n m : Fin 3 →₀ ℕ) (j : Fin 3) :
    localBiIndex n m (.inl j) = n j := by simp [localBiIndex]

@[simp] private theorem localBiIndex_apply_inr (n m : Fin 3 →₀ ℕ) (j : Fin 3) :
    localBiIndex n m (.inr j) = m j := by simp [localBiIndex]

@[simp] private theorem firstPart_localBiIndex (n m : Fin 3 →₀ ℕ) :
    firstPart (localBiIndex n m) = n := by
  ext j
  simp

@[simp] private theorem secondPart_localBiIndex (n m : Fin 3 →₀ ℕ) :
    secondPart (localBiIndex n m) = m := by
  ext j
  simp

private theorem localBiIndex_firstPart_secondPart
    (d : BiprojectiveCoordinate 2 2 →₀ ℕ) :
    localBiIndex (firstPart d) (secondPart d) = d := by
  ext z
  cases z <;> simp

private theorem eq_localBiIndex_iff
    (d : BiprojectiveCoordinate 2 2 →₀ ℕ) (n m : Fin 3 →₀ ℕ) :
    d = localBiIndex n m ↔ secondPart d = m ∧ firstPart d = n := by
  constructor
  · rintro rfl
    simp
  · rintro ⟨h1, h2⟩
    conv_lhs => rw [← localBiIndex_firstPart_secondPart d]
    rw [h1, h2]

private theorem coeff_secondBlockCoeff_local
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (m n : Fin 3 →₀ ℕ) :
    MvPolynomial.coeff n (secondBlockCoeff F m) =
      MvPolynomial.coeff (localBiIndex n m) F := by
  classical
  rw [secondBlockCoeff, MvPolynomial.coeff_sum]
  have h : ∀ d ∈ F.support,
      MvPolynomial.coeff n
          (if secondPart d = m then
            MvPolynomial.monomial (firstPart d) (MvPolynomial.coeff d F) else 0) =
        if d = localBiIndex n m then MvPolynomial.coeff d F else 0 := by
    intro d _
    by_cases h1 : secondPart d = m
    · by_cases h2 : firstPart d = n
      · have hd : d = localBiIndex n m := (eq_localBiIndex_iff d n m).mpr ⟨h1, h2⟩
        rw [if_pos h1, MvPolynomial.coeff_monomial, if_pos h2, if_pos hd]
      · have hd : d ≠ localBiIndex n m := fun h => h2 (by rw [h]; simp)
        rw [if_pos h1, MvPolynomial.coeff_monomial, if_neg h2, if_neg hd]
    · have hd : d ≠ localBiIndex n m := fun h => h1 (by rw [h]; simp)
      rw [if_neg h1, MvPolynomial.coeff_zero, if_neg hd]
  rw [Finset.sum_congr rfl h,
    Finset.sum_ite_eq' F.support (localBiIndex n m) fun d => MvPolynomial.coeff d F]
  split_ifs with hmem
  · rfl
  · exact (MvPolynomial.notMem_support_iff.mp hmem).symm

private theorem localBiIndex_zero_right (n : Fin 3 →₀ ℕ) :
    localBiIndex n 0 =
      Finsupp.mapDomain (Sum.inl : Fin 3 → BiprojectiveCoordinate 2 2) n := by
  ext z
  cases z with
  | inl i => simp [Finsupp.mapDomain_apply Sum.inl_injective]
  | inr l => simp [Finsupp.mapDomain_notin_range]

private theorem localBiIndex_sub_single_inr
    (n m : Fin 3 →₀ ℕ) (j : Fin 3) :
    localBiIndex n m -
        Finsupp.single (Sum.inr j : BiprojectiveCoordinate 2 2) 1 =
      localBiIndex n (m - Finsupp.single j 1) := by
  ext z
  cases z with
  | inl i => simp [Finsupp.tsub_apply]
  | inr l => simp [Finsupp.tsub_apply, Finsupp.single_apply]

private theorem secondBlockCoeff_sum_local
    {ι : Type*} (s : Finset ι)
    (F : ι → MvPolynomial (BiprojectiveCoordinate 2 2) K) (m : Fin 3 →₀ ℕ) :
    secondBlockCoeff (∑ i ∈ s, F i) m = ∑ i ∈ s, secondBlockCoeff (F i) m := by
  ext n
  simp [coeff_secondBlockCoeff_local, MvPolynomial.coeff_sum]

private theorem secondBlockCoeff_liftSecondLinear_local
    (p : MvPolynomial (Fin 3) K) (j : Fin 3) (m : Fin 3 →₀ ℕ) :
    secondBlockCoeff (liftSecondLinear p j) m =
      if m = Finsupp.single j 1 then p else 0 := by
  classical
  by_cases hm : m = Finsupp.single j 1
  · subst hm
    rw [if_pos rfl]
    ext n
    rw [coeff_secondBlockCoeff_local, liftSecondLinear, liftFirstBlock,
      MvPolynomial.coeff_mul_X', if_pos, localBiIndex_sub_single_inr, tsub_self,
      localBiIndex_zero_right,
      MvPolynomial.coeff_rename_mapDomain _ Sum.inl_injective]
    simp [Finsupp.mem_support_iff]
  · rw [if_neg hm]
    ext n
    rw [coeff_secondBlockCoeff_local, MvPolynomial.coeff_zero, liftSecondLinear,
      liftFirstBlock, MvPolynomial.coeff_mul_X']
    split_ifs with hmem
    · have hmj : m j ≠ 0 := by simpa [Finsupp.mem_support_iff] using hmem
      have hne : m - Finsupp.single j 1 ≠ 0 := by
        intro h0
        refine hm (Finsupp.ext fun i => ?_)
        have hi := DFunLike.congr_fun h0 i
        rw [Finsupp.tsub_apply] at hi
        simp only [Finsupp.coe_zero, Pi.zero_apply] at hi
        rcases eq_or_ne i j with rfl | hij
        · rw [Finsupp.single_eq_same] at hi ⊢
          omega
        · rw [Finsupp.single_eq_of_ne hij] at hi ⊢
          omega
      obtain ⟨l, hl⟩ := Finsupp.ne_iff.mp hne
      rw [localBiIndex_sub_single_inr]
      refine MvPolynomial.coeff_rename_eq_zero _ _ _ fun u hu => ?_
      exfalso
      have hval := DFunLike.congr_fun hu (Sum.inr l)
      rw [Finsupp.mapDomain_notin_range u (Sum.inr l) (by simp),
        localBiIndex_apply_inr] at hval
      exact hl (by simpa using hval.symm)
    · rfl

/-- Right degree is the sum of the exponents in the second Cox block. -/
private theorem weight_rightDegree_eq_sum
    (s : BiprojectiveCoordinate 2 2 →₀ ℕ) :
    Finsupp.weight (rightDegreeWeight (m := 2) (n := 2)) s =
      ∑ j : Fin 3, s (.inr j) := by
  classical
  simp only [Finsupp.weight_apply, rightDegreeWeight]
  rw [Finsupp.sum_fintype _ _ (by intro; simp)]
  simp [Fintype.sum_sum_type]

/-- A right-degree-zero multi-index has no exponent in the second block. -/
private theorem secondPart_eq_zero_of_weight_rightDegree_eq_zero
    {s : BiprojectiveCoordinate 2 2 →₀ ℕ}
    (hs : Finsupp.weight (rightDegreeWeight (m := 2) (n := 2)) s = 0) :
    secondPart s = 0 := by
  rw [weight_rightDegree_eq_sum, Fin.sum_univ_three] at hs
  ext j
  fin_cases j <;> simp [secondPart] <;> omega

/-- A Cox polynomial of right degree zero is exactly the lift of its constant second-block
coefficient. -/
theorem eq_liftFirstBlock_secondBlockCoeff_zero
    (B : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hB : B.IsWeightedHomogeneous (rightDegreeWeight (m := 2) (n := 2)) 0) :
    B = liftFirstBlock (secondBlockCoeff B 0) := by
  classical
  ext d
  by_cases hd : MvPolynomial.coeff d B = 0
  · rw [hd]
    apply Eq.symm
    apply MvPolynomial.coeff_rename_eq_zero
    intro n hn
    rw [coeff_secondBlockCoeff_local]
    have hindex : localBiIndex n 0 = d := by
      rw [localBiIndex_zero_right]
      exact hn
    simp [hindex, hd]
  · have hsecond : secondPart d = 0 :=
      secondPart_eq_zero_of_weight_rightDegree_eq_zero (hB hd)
    have hdindex : localBiIndex (firstPart d) 0 = d := by
      rw [← hsecond]
      exact localBiIndex_firstPart_secondPart d
    rw [liftFirstBlock, ← hdindex, localBiIndex_zero_right,
      MvPolynomial.coeff_rename_mapDomain _ Sum.inl_injective,
      coeff_secondBlockCoeff_local]
    rw [localBiIndex_zero_right]

/-- Specializing a lifted first-block polynomial in the second coordinates does nothing. -/
@[simp]
theorem specializeSecondCoordinates_liftFirstBlock
    (y : Fin 3 → K) (p : MvPolynomial (Fin 3) K) :
    specializeSecondCoordinates (m := 2) y (liftFirstBlock p) = p := by
  induction p using MvPolynomial.induction_on with
  | C r => simp [liftFirstBlock, specializeSecondCoordinates]
  | add p q hp hq =>
      rw [show liftFirstBlock (p + q) = liftFirstBlock p + liftFirstBlock q by
        simp [liftFirstBlock], map_add, hp, hq]
  | mul_X p j hp =>
      rw [show liftFirstBlock (p * MvPolynomial.X j) =
          liftFirstBlock p * MvPolynomial.X (.inl j) by
        simp [liftFirstBlock], map_mul, hp]
      simp

/-- A first-block lift is a unit exactly when the original polynomial is a unit. -/
theorem isUnit_liftFirstBlock_iff (p : MvPolynomial (Fin 3) K) :
    IsUnit (liftFirstBlock p) ↔ IsUnit p := by
  constructor
  · intro hp
    simpa using hp.map
      (specializeSecondCoordinates (m := 2) (0 : Fin 3 → K)).toMonoidHom
  · intro hp
    exact hp.map (MvPolynomial.rename Sum.inl).toMonoidHom

/-- The coordinate vector used to read off one coefficient of a second-block-linear form. -/
private def secondBasis (j : Fin 3) : Fin 3 → K :=
  fun l => if l = j then 1 else 0

@[simp]
private theorem secondBasis_apply (j l : Fin 3) :
    secondBasis (K := K) j l = if l = j then 1 else 0 := rfl

/-- Specializing a lifted linear summand at a coordinate vector selects that summand. -/
private theorem specializeSecondCoordinates_liftSecondLinear_secondBasis
    (p : MvPolynomial (Fin 3) K) (j l : Fin 3) :
    specializeSecondCoordinates (m := 2) (secondBasis (K := K) j)
        (liftSecondLinear p l) = if l = j then p else 0 := by
  rw [liftSecondLinear, map_mul, specializeSecondCoordinates_liftFirstBlock]
  simp [secondBasis]

/-- Coordinate specialization extracts the corresponding coefficient from a displayed linear
form. -/
private theorem specializeSecondCoordinates_sum_liftSecondLinear
    (p : Fin 3 → MvPolynomial (Fin 3) K) (j : Fin 3) :
    specializeSecondCoordinates (m := 2) (secondBasis (K := K) j)
        (∑ l : Fin 3, liftSecondLinear (p l) l) = p j := by
  rw [map_sum]
  simp only [specializeSecondCoordinates_liftSecondLinear_secondBasis]
  rw [Finset.sum_ite_eq' Finset.univ j]
  simp

/-- A linear form whose three coefficients have no nonunit common divisor is primitive over the
first block. -/
theorem isPrimitive_sum_liftSecondLinear_of_common_dvd_isUnit
    (p : Fin 3 → MvPolynomial (Fin 3) K)
    (hcoprime : ∀ b : MvPolynomial (Fin 3) K,
      (∀ j : Fin 3, b ∣ p j) → IsUnit b) :
    IsPrimitiveOverFirstBlock (∑ j : Fin 3, liftSecondLinear (p j) j) := by
  intro B Q hB hfactor
  let b := secondBlockCoeff B 0
  have hBeq : B = liftFirstBlock b :=
    eq_liftFirstBlock_secondBlockCoeff_zero B hB
  have hbdiv : ∀ j : Fin 3, b ∣ p j := by
    intro j
    refine ⟨specializeSecondCoordinates (m := 2) (secondBasis (K := K) j) Q, ?_⟩
    have hspec := congrArg
      (specializeSecondCoordinates (m := 2) (secondBasis (K := K) j)) hfactor
    rw [specializeSecondCoordinates_sum_liftSecondLinear, map_mul, hBeq,
      specializeSecondCoordinates_liftFirstBlock] at hspec
    exact hspec
  rw [hBeq, isUnit_liftFirstBlock_iff]
  exact hcoprime b hbdiv

/-- The gcd of the three first-block coefficients of a linear form. -/
def firstBlockContent (p : Fin 3 → MvPolynomial (Fin 3) K) :
    MvPolynomial (Fin 3) K :=
  gcd (p 0) (gcd (p 1) (p 2))

theorem firstBlockContent_dvd (p : Fin 3 → MvPolynomial (Fin 3) K) (j : Fin 3) :
    firstBlockContent p ∣ p j := by
  fin_cases j
  · exact gcd_dvd_left _ _
  · exact (gcd_dvd_right _ _).trans (gcd_dvd_left _ _)
  · exact (gcd_dvd_right _ _).trans (gcd_dvd_right _ _)

/-- The coefficient tuple after dividing out `firstBlockContent`. -/
def primitiveCoefficient (p : Fin 3 → MvPolynomial (Fin 3) K) (j : Fin 3) :
    MvPolynomial (Fin 3) K :=
  Classical.choose (firstBlockContent_dvd p j)

theorem firstBlockContent_mul_primitiveCoefficient
    (p : Fin 3 → MvPolynomial (Fin 3) K) (j : Fin 3) :
    firstBlockContent p * primitiveCoefficient p j = p j := by
  exact (Classical.choose_spec (firstBlockContent_dvd p j)).symm

theorem firstBlockContent_ne_zero
    {p : Fin 3 → MvPolynomial (Fin 3) K} (hp : ∃ j, p j ≠ 0) :
    firstBlockContent p ≠ 0 := by
  intro hzero
  rw [firstBlockContent, gcd_eq_zero_iff, gcd_eq_zero_iff] at hzero
  obtain ⟨j, hj⟩ := hp
  fin_cases j <;> simp_all

/-- After dividing by the three-coefficient gcd, every common divisor is a unit. -/
theorem common_dvd_primitiveCoefficient_isUnit
    {p : Fin 3 → MvPolynomial (Fin 3) K} (hp : ∃ j, p j ≠ 0)
    (b : MvPolynomial (Fin 3) K)
    (hb : ∀ j : Fin 3, b ∣ primitiveCoefficient p j) :
    IsUnit b := by
  have hcontent : firstBlockContent p ≠ 0 := firstBlockContent_ne_zero hp
  have hcommon : ∀ j : Fin 3, firstBlockContent p * b ∣ p j := by
    intro j
    obtain ⟨s, hs⟩ := hb j
    refine ⟨s, ?_⟩
    rw [← firstBlockContent_mul_primitiveCoefficient p j, hs]
    ring
  have hdiv : firstBlockContent p * b ∣ firstBlockContent p := by
    simpa only [firstBlockContent] using
      (dvd_gcd (hcommon 0) (dvd_gcd (hcommon 1) (hcommon 2)))
  apply isUnit_iff_dvd_one.mpr
  rw [← mul_dvd_mul_iff_left hcontent, mul_one]
  exact hdiv

/-- The displayed linear form obtained after content removal is primitive. -/
theorem primitiveLinearEquation_isPrimitive
    {p : Fin 3 → MvPolynomial (Fin 3) K} (hp : ∃ j, p j ≠ 0) :
    IsPrimitiveOverFirstBlock
      (∑ j : Fin 3, liftSecondLinear (primitiveCoefficient p j) j) := by
  apply isPrimitive_sum_liftSecondLinear_of_common_dvd_isUnit
  exact common_dvd_primitiveCoefficient_isUnit hp

theorem liftFirstBlock_mul_liftSecondLinear
    (b p : MvPolynomial (Fin 3) K) (j : Fin 3) :
    liftFirstBlock b * liftSecondLinear p j = liftSecondLinear (b * p) j := by
  simp [liftFirstBlock, liftSecondLinear, map_mul, mul_assoc]

/-- Content removal factors the original displayed linear equation. -/
theorem sum_liftSecondLinear_factor_firstBlockContent
    (p : Fin 3 → MvPolynomial (Fin 3) K) :
    (∑ j : Fin 3, liftSecondLinear (p j) j) =
      liftFirstBlock (firstBlockContent p) *
        ∑ j : Fin 3, liftSecondLinear (primitiveCoefficient p j) j := by
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  rw [liftFirstBlock_mul_liftSecondLinear,
    firstBlockContent_mul_primitiveCoefficient]

/-- If a nonzero coefficient tuple is homogeneous in one common degree, then its content and all
primitive coefficients are homogeneous, with complementary degrees. -/
theorem exists_homogeneous_firstBlockContent_primitiveCoefficient
    {p : Fin 3 → MvPolynomial (Fin 3) K} {n : ℕ}
    (hp0 : ∃ j : Fin 3, p j ≠ 0)
    (hpdeg : ∀ j : Fin 3, (p j).IsHomogeneous n) :
    ∃ a b : ℕ,
      (firstBlockContent p).IsHomogeneous a ∧
        (∀ j : Fin 3, (primitiveCoefficient p j).IsHomogeneous b) ∧
        a + b = n := by
  have hcontent0 : firstBlockContent p ≠ 0 := firstBlockContent_ne_zero hp0
  obtain ⟨j, hj0⟩ := hp0
  have hprimitive0 : primitiveCoefficient p j ≠ 0 := by
    intro hzero
    apply hj0
    rw [← firstBlockContent_mul_primitiveCoefficient p j, hzero, mul_zero]
  have hproduct :
      (firstBlockContent p * primitiveCoefficient p j).IsHomogeneous n := by
    rw [firstBlockContent_mul_primitiveCoefficient]
    exact hpdeg j
  obtain ⟨a, b, hcontent, hprimitive, hab⟩ :=
    MvPolynomial.exists_isHomogeneous_of_mul_isHomogeneous
      hcontent0 hprimitive0 hproduct
  refine ⟨a, b, hcontent, ?_, hab⟩
  intro l
  by_cases hl0 : p l = 0
  · have hprimitive_l_zero : primitiveCoefficient p l = 0 := by
      have hmul : firstBlockContent p * primitiveCoefficient p l = 0 := by
        rw [firstBlockContent_mul_primitiveCoefficient, hl0]
      exact (mul_eq_zero.mp hmul).resolve_left hcontent0
    rw [hprimitive_l_zero]
    exact MvPolynomial.isHomogeneous_zero (Fin 3) K b
  · have hprimitive_l0 : primitiveCoefficient p l ≠ 0 := by
      intro hzero
      apply hl0
      rw [← firstBlockContent_mul_primitiveCoefficient p l, hzero, mul_zero]
    have hproduct_l :
        (firstBlockContent p * primitiveCoefficient p l).IsHomogeneous n := by
      rw [firstBlockContent_mul_primitiveCoefficient]
      exact hpdeg l
    obtain ⟨a', b', hcontent', hprimitive', hab'⟩ :=
      MvPolynomial.exists_isHomogeneous_of_mul_isHomogeneous
        hcontent0 hprimitive_l0 hproduct_l
    have haa : a = a' := hcontent.inj_right hcontent' hcontent0
    have hbb : b' = b := by omega
    rwa [hbb] at hprimitive'

/-- A first-block lift has right degree zero, without any homogeneity assumption on the lifted
polynomial. -/
theorem liftFirstBlock_isWeightedHomogeneous_right_zero
    (p : MvPolynomial (Fin 3) K) :
    (liftFirstBlock p).IsWeightedHomogeneous
      (rightDegreeWeight (m := 2) (n := 2)) 0 := by
  induction p using MvPolynomial.induction_on with
  | C r => simpa [liftFirstBlock] using
      (MvPolynomial.isWeightedHomogeneous_C (rightDegreeWeight (m := 2) (n := 2)) r)
  | add p q hp hq =>
      rw [show liftFirstBlock (p + q) = liftFirstBlock p + liftFirstBlock q by
        simp [liftFirstBlock]]
      exact hp.add hq
  | mul_X p j hp =>
      rw [show liftFirstBlock (p * MvPolynomial.X j) =
          liftFirstBlock p * MvPolynomial.X (.inl j) by simp [liftFirstBlock]]
      simpa [rightDegreeWeight] using hp.mul
        (MvPolynomial.isWeightedHomogeneous_X K
          (rightDegreeWeight (m := 2) (n := 2)) (.inl j))

/-- A lifted second-block-linear summand has right degree one. -/
theorem liftSecondLinear_isWeightedHomogeneous_right_one
    (p : MvPolynomial (Fin 3) K) (j : Fin 3) :
    (liftSecondLinear p j).IsWeightedHomogeneous
      (rightDegreeWeight (m := 2) (n := 2)) 1 := by
  unfold liftSecondLinear
  simpa [rightDegreeWeight] using
    (liftFirstBlock_isWeightedHomogeneous_right_zero p).mul
      (MvPolynomial.isWeightedHomogeneous_X K
        (rightDegreeWeight (m := 2) (n := 2)) (.inr j))

/-- A displayed linear form has right degree one. -/
theorem sum_liftSecondLinear_isWeightedHomogeneous_right_one
    (p : Fin 3 → MvPolynomial (Fin 3) K) :
    (∑ j : Fin 3, liftSecondLinear (p j) j).IsWeightedHomogeneous
      (rightDegreeWeight (m := 2) (n := 2)) 1 := by
  exact MvPolynomial.IsWeightedHomogeneous.sum Finset.univ _ _ fun j _ =>
    liftSecondLinear_isWeightedHomogeneous_right_one (p j) j

/-- Every nonzero displayed second-block-linear equation admits a right-degree-zero content factor
and a primitive right-degree-one quotient. -/
theorem exists_primitive_factorization_of_eq_sum
    {q : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hq0 : q ≠ 0)
    (p : Fin 3 → MvPolynomial (Fin 3) K)
    (hq : q = ∑ j : Fin 3, liftSecondLinear (p j) j) :
    ∃ B qprim : MvPolynomial (BiprojectiveCoordinate 2 2) K,
      B.IsWeightedHomogeneous (rightDegreeWeight (m := 2) (n := 2)) 0 ∧
        qprim.IsWeightedHomogeneous (rightDegreeWeight (m := 2) (n := 2)) 1 ∧
        IsPrimitiveOverFirstBlock qprim ∧ q = B * qprim := by
  have hp : ∃ j : Fin 3, p j ≠ 0 := by
    by_contra hp
    push Not at hp
    apply hq0
    rw [hq]
    apply Finset.sum_eq_zero
    intro j _
    simp [hp j, liftSecondLinear, liftFirstBlock]
  refine ⟨liftFirstBlock (firstBlockContent p),
    ∑ j : Fin 3, liftSecondLinear (primitiveCoefficient p j) j,
    liftFirstBlock_isWeightedHomogeneous_right_zero _,
    sum_liftSecondLinear_isWeightedHomogeneous_right_one _,
    primitiveLinearEquation_isPrimitive hp, ?_⟩
  rw [hq, sum_liftSecondLinear_factor_firstBlockContent]

/-! ### The residual equation is a displayed linear form -/

private theorem secondBlockSubst_liftFirstBlock
    (N : Matrix (Fin 3) (Fin 3) K) (p : MvPolynomial (Fin 3) K) :
    secondBlockSubst N (liftFirstBlock p) = liftFirstBlock p := by
  induction p using MvPolynomial.induction_on with
  | C a => simp [liftFirstBlock, secondBlockSubst]
  | add p q hp hq =>
      rw [show liftFirstBlock (p + q) = liftFirstBlock p + liftFirstBlock q by
        simp [liftFirstBlock], map_add, hp, hq]
  | mul_X p i hp =>
      rw [show liftFirstBlock (p * MvPolynomial.X i) =
          liftFirstBlock p * MvPolynomial.X (.inl i) by simp [liftFirstBlock],
        map_mul, hp, secondBlockSubst_X_inl]

private theorem liftSecondLinear_finsetSum
    {ι : Type*} (s : Finset ι) (p : ι → MvPolynomial (Fin 3) K) (l : Fin 3) :
    liftSecondLinear (∑ i ∈ s, p i) l =
      ∑ i ∈ s, liftSecondLinear (p i) l := by
  simp [liftSecondLinear, liftFirstBlock, map_sum, Finset.sum_mul]

/-- The arbitrary-frame residual equation is linear in the second block. -/
theorem exists_residualEquationOn_eq_sum_local
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) :
    ∃ p : Fin 3 → MvPolynomial (Fin 3) K,
      residualEquationOn M N F = ∑ l : Fin 3, liftSecondLinear (p l) l := by
  classical
  set G := secondBlockSubst M F with hG
  set q : Fin 3 → MvPolynomial (Fin 3) K :=
    ![residualCoeffU_of G, residualCoeffV_of G, residualCoeffW_of G] with hq
  refine ⟨fun l => ∑ j : Fin 3, MvPolynomial.C (N j l) * q j, ?_⟩
  have hres : residualEquation G = ∑ j : Fin 3, liftSecondLinear (q j) j := by
    rw [residualEquation, Fin.sum_univ_three]
    simp [hq]
  have hstep : ∀ j : Fin 3, secondBlockSubst N (liftSecondLinear (q j) j) =
      ∑ l : Fin 3, liftSecondLinear (MvPolynomial.C (N j l) * q j) l := by
    intro j
    rw [liftSecondLinear, map_mul, secondBlockSubst_liftFirstBlock,
      secondBlockSubst_X_inr, Finset.mul_sum]
    refine Finset.sum_congr rfl fun l _ => ?_
    rw [liftSecondLinear]
    change liftFirstBlock (q j) *
        (MvPolynomial.C (N j l) * MvPolynomial.X (.inr l)) =
      liftFirstBlock (MvPolynomial.C (N j l) * q j) * MvPolynomial.X (.inr l)
    rw [show liftFirstBlock (MvPolynomial.C (N j l) * q j) =
        MvPolynomial.C (N j l) * liftFirstBlock (q j) by simp [liftFirstBlock]]
    ring
  rw [residualEquationOn, ← hG, hres, map_sum,
    Finset.sum_congr rfl fun j _ => hstep j, Finset.sum_comm]
  exact Finset.sum_congr rfl fun l _ => (liftSecondLinear_finsetSum _ _ l).symm

/-- The coefficients in the displayed residual equation are the declared residual-line
coefficients. -/
theorem residualLineCoeffOn_eq_of_eq_sum_local
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (p : Fin 3 → MvPolynomial (Fin 3) K)
    (h : residualEquationOn M N F =
      ∑ l : Fin 3, liftSecondLinear (p l) l) (a : Fin 3) :
    residualLineCoeffOn M N F a = p a := by
  classical
  have hiff : ∀ l : Fin 3,
      ((Finsupp.single a 1 : Fin 3 →₀ ℕ) = Finsupp.single l 1) ↔ a = l := by
    intro l
    exact ⟨fun hsingle => Finsupp.single_left_injective one_ne_zero hsingle,
      fun hal => by rw [hal]⟩
  rw [residualLineCoeffOn, h, secondBlockCoeff_sum_local,
    Finset.sum_congr rfl fun l _ =>
      secondBlockCoeff_liftSecondLinear_local (p l) l _]
  simp only [hiff]
  rw [Finset.sum_ite_eq Finset.univ a p]
  simp

/-- Nonconstancy excludes the vacuous zero residual equation. -/
theorem residualEquationOn_ne_zero_of_nonconstant
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hgood : ResidualLineNonconstantOn M N F) :
    residualEquationOn M N F ≠ 0 := by
  intro hzero
  apply hgood
  refine ⟨0, 0, fun j => ?_⟩
  simp [residualLineCoeffOn, hzero, secondBlockCoeff]

/-- Content removal for the residual equation under the moving-line hypothesis. -/
theorem exists_primitive_residualEquationOn_factorization
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hgood : ResidualLineNonconstantOn M N F) :
    ∃ B qprim : MvPolynomial (BiprojectiveCoordinate 2 2) K,
      B.IsWeightedHomogeneous (rightDegreeWeight (m := 2) (n := 2)) 0 ∧
        qprim.IsWeightedHomogeneous (rightDegreeWeight (m := 2) (n := 2)) 1 ∧
        IsPrimitiveOverFirstBlock qprim ∧
        residualEquationOn M N F = B * qprim := by
  obtain ⟨p, hp⟩ := exists_residualEquationOn_eq_sum_local M N F
  exact exists_primitive_factorization_of_eq_sum
    (residualEquationOn_ne_zero_of_nonconstant M N F hgood) p hp

/-- If the explicitly constructed primitive quotient is bihomogeneous of bidegree `(a,1)`, the
moving-line hypothesis forces `a` to be positive.  This isolates the positivity argument from the
separate homogeneous-factor theorem needed to manufacture `a`. -/
theorem primitiveCoefficient_firstDegree_pos_of_bihomogeneous
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hgood : ResidualLineNonconstantOn M N F)
    (p : Fin 3 → MvPolynomial (Fin 3) K)
    (hp : residualEquationOn M N F =
      ∑ j : Fin 3, liftSecondLinear (p j) j)
    (a : ℕ)
    (hprimdeg : IsBihomogeneousOfBidegree a 1
      (∑ j : Fin 3, liftSecondLinear (primitiveCoefficient p j) j)) :
    0 < a := by
  by_contra ha
  have ha0 : a = 0 := Nat.eq_zero_of_not_pos ha
  subst a
  apply hgood
  refine ⟨firstBlockContent p,
    fun j => MvPolynomial.coeff 0 (primitiveCoefficient p j), fun j => ?_⟩
  rw [residualLineCoeffOn_eq_of_eq_sum_local M N F p hp j,
    ← firstBlockContent_mul_primitiveCoefficient p j]
  have hjhom : (primitiveCoefficient p j).IsHomogeneous 0 := by
    have hspec := hprimdeg.specializeSecondCoordinates_isHomogeneous
      (secondBasis (K := K) j)
    rwa [specializeSecondCoordinates_sum_liftSecondLinear] at hspec
  have hjC : primitiveCoefficient p j =
      MvPolynomial.C (MvPolynomial.coeff 0 (primitiveCoefficient p j)) := by
    calc
      primitiveCoefficient p j =
          MvPolynomial.homogeneousComponent 0 (primitiveCoefficient p j) :=
        (MvPolynomial.homogeneousComponent_eq_self hjhom).symm
      _ = MvPolynomial.C (MvPolynomial.coeff 0 (primitiveCoefficient p j)) :=
        MvPolynomial.homogeneousComponent_zero _
  rw [hjC]
  ring

/-- Residual content removal, together with the sharp conditional positivity statement for the
first degree of the primitive quotient. -/
theorem exists_primitive_residualEquationOn_factorization_with_degree_control
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hgood : ResidualLineNonconstantOn M N F) :
    ∃ B qprim : MvPolynomial (BiprojectiveCoordinate 2 2) K,
      B.IsWeightedHomogeneous (rightDegreeWeight (m := 2) (n := 2)) 0 ∧
        qprim.IsWeightedHomogeneous (rightDegreeWeight (m := 2) (n := 2)) 1 ∧
        IsPrimitiveOverFirstBlock qprim ∧
        residualEquationOn M N F = B * qprim ∧
        ∀ a : ℕ, IsBihomogeneousOfBidegree a 1 qprim → 0 < a := by
  obtain ⟨p, hp⟩ := exists_residualEquationOn_eq_sum_local M N F
  have hq0 := residualEquationOn_ne_zero_of_nonconstant M N F hgood
  have hp0 : ∃ j : Fin 3, p j ≠ 0 := by
    by_contra hpzero
    push Not at hpzero
    apply hq0
    rw [hp]
    apply Finset.sum_eq_zero
    intro j _
    simp [hpzero j, liftSecondLinear, liftFirstBlock]
  refine ⟨liftFirstBlock (firstBlockContent p),
    ∑ j : Fin 3, liftSecondLinear (primitiveCoefficient p j) j,
    liftFirstBlock_isWeightedHomogeneous_right_zero _,
    sum_liftSecondLinear_isWeightedHomogeneous_right_one _,
    primitiveLinearEquation_isPrimitive hp0, ?_, ?_⟩
  · rw [hp, sum_liftSecondLinear_factor_firstBlockContent]
  · intro a ha
    exact primitiveCoefficient_firstDegree_pos_of_bihomogeneous
      M N F hgood p hp a ha

/-- For a bidegree-`(2,3)` equation, content removal produces an honestly bihomogeneous primitive
quotient.  Its first degree is positive under the moving-line hypothesis, and the two first
degrees add to the residual equation's degree ten. -/
theorem exists_bihomogeneous_primitive_residualEquationOn_factorization
    [Infinite K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F)
    (hgood : ResidualLineNonconstantOn M N F) :
    ∃ a b : ℕ, ∃ B qprim : MvPolynomial (BiprojectiveCoordinate 2 2) K,
      a + b = 10 ∧ 0 < b ∧
        IsBihomogeneousOfBidegree a 0 B ∧
        IsBihomogeneousOfBidegree b 1 qprim ∧
        IsPrimitiveOverFirstBlock qprim ∧
        residualEquationOn M N F = B * qprim := by
  obtain ⟨p, hp⟩ := exists_residualEquationOn_eq_sum_local M N F
  have hq0 := residualEquationOn_ne_zero_of_nonconstant M N F hgood
  have hp0 : ∃ j : Fin 3, p j ≠ 0 := by
    by_contra hpzero
    push Not at hpzero
    apply hq0
    rw [hp]
    apply Finset.sum_eq_zero
    intro j _
    simp [hpzero j, liftSecondLinear, liftFirstBlock]
  have hpdeg : ∀ j : Fin 3, (p j).IsHomogeneous 10 := by
    intro j
    have hres := ResidualDivisor.residualEquationOn_isBihomogeneous M N hF
    have hspec := hres.specializeSecondCoordinates_isHomogeneous (secondBasis (K := K) j)
    rwa [hp, specializeSecondCoordinates_sum_liftSecondLinear] at hspec
  obtain ⟨a, b, hcontentDegree, hprimitiveDegree, hab⟩ :=
    exists_homogeneous_firstBlockContent_primitiveCoefficient hp0 hpdeg
  let B := liftFirstBlock (firstBlockContent p)
  let qprim := ∑ j : Fin 3, liftSecondLinear (primitiveCoefficient p j) j
  have hBdegree : IsBihomogeneousOfBidegree a 0 B := by
    exact ResidualDivisor.liftFirstBlock_isBihomogeneous hcontentDegree
  have hqprimDegree : IsBihomogeneousOfBidegree b 1 qprim := by
    exact MvPolynomial.IsWeightedHomogeneous.sum Finset.univ _ _ fun j _ =>
      ResidualDivisor.liftSecondLinear_isBihomogeneous (hprimitiveDegree j) j
  have hbpos : 0 < b :=
    primitiveCoefficient_firstDegree_pos_of_bihomogeneous
      M N F hgood p hp b hqprimDegree
  refine ⟨a, b, B, qprim, hab, hbpos, hBdegree, hqprimDegree,
    primitiveLinearEquation_isPrimitive hp0, ?_⟩
  rw [hp, sum_liftSecondLinear_factor_firstBlockContent]

end

end ResidualPrimitiveEquation
end BConicBundleMultisections
