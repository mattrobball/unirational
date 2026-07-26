/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineChart
public import BConicBundleMultisections.BiprojectiveFiberEquationBaseChange
public import BConicBundleMultisections.BiprojectiveFiberPolynomial
public import BConicBundleMultisections.ProjectiveSpaceChartDominance
public import BConicBundleMultisections.ResidualDivisor
public import Mathlib.RingTheory.MvPolynomial.Homogeneous
public import Mathlib.RingTheory.Localization.Away.Basic
public import Mathlib.AlgebraicGeometry.FunctionField
public import Mathlib.AlgebraicGeometry.Morphisms.Basic

/-!
# Nonvanishing of the specialised second-projection fibre equation at the generic point

For a nonzero bidegree-`(2,3)` form `F`, the specialised equation
`sndResidueFiberPolynomial F η j _` at the generic point `η` of `ℙ²_y` is nonzero.

*Route.* Extract first-block coefficients of `F` (polynomials in the second Cox block).  For
bidegree `(2,3)` these are homogeneous of degree three.  A nonzero homogeneous form does not
vanish at the generic residue coordinates of `ℙ²` (standard-chart evaluation at the generic
point is injective on `Away X_j`).  Hence some coefficient of the specialised form is nonzero.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial HomogeneousLocalization IsLocalization
open ResidualDivisor
open Finsupp

attribute [local instance] MvPolynomial.gradedAlgebra

variable {R : Type*} [CommRing R]
variable {k : Type u} [Field k]

namespace BiprojectiveSpace

/-! ### Biprojective multi-index and first-block coefficients -/

/-- The biprojective multi-index with first block `n` and second block `m`. -/
def biIndex' (n m : Fin 3 →₀ ℕ) : BiprojectiveCoordinate 2 2 →₀ ℕ :=
  Finsupp.equivFunOnFinite.symm (Sum.elim ⇑n ⇑m)

@[simp] theorem biIndex'_apply_inl (n m : Fin 3 →₀ ℕ) (j : Fin 3) :
    biIndex' n m (.inl j) = n j := by simp [biIndex']

@[simp] theorem biIndex'_apply_inr (n m : Fin 3 →₀ ℕ) (j : Fin 3) :
    biIndex' n m (.inr j) = m j := by simp [biIndex']

@[simp] theorem firstPart_biIndex' (n m : Fin 3 →₀ ℕ) : firstPart (biIndex' n m) = n := by
  ext j; simp

@[simp] theorem secondPart_biIndex' (n m : Fin 3 →₀ ℕ) : secondPart (biIndex' n m) = m := by
  ext j; simp

theorem biIndex'_firstPart_secondPart (d : BiprojectiveCoordinate 2 2 →₀ ℕ) :
    biIndex' (firstPart d) (secondPart d) = d := by
  ext z; cases z <;> simp

theorem eq_biIndex'_iff (d : BiprojectiveCoordinate 2 2 →₀ ℕ) (n m : Fin 3 →₀ ℕ) :
    d = biIndex' n m ↔ secondPart d = m ∧ firstPart d = n := by
  constructor
  · rintro rfl; simp
  · rintro ⟨h1, h2⟩
    conv_lhs => rw [← biIndex'_firstPart_secondPart d]
    rw [h1, h2]

theorem biIndex'_eq_zero_iff (n m : Fin 3 →₀ ℕ) : biIndex' n m = 0 ↔ n = 0 ∧ m = 0 := by
  constructor
  · intro h
    refine ⟨Finsupp.ext fun i => ?_, Finsupp.ext fun j => ?_⟩
    · simpa using DFunLike.congr_fun h (Sum.inl i)
    · simpa using DFunLike.congr_fun h (Sum.inr j)
  · rintro ⟨rfl, rfl⟩
    ext z; cases z <;> simp

theorem biIndex'_sub_single_inr (n m : Fin 3 →₀ ℕ) (j : Fin 3) :
    biIndex' n m - Finsupp.single (Sum.inr j : BiprojectiveCoordinate 2 2) 1
      = biIndex' n (m - Finsupp.single j 1) := by
  ext z
  cases z with
  | inl i => simp [Finsupp.tsub_apply]
  | inr l => simp [Finsupp.tsub_apply, Finsupp.single_apply]

theorem biIndex'_sub_single_inl (n m : Fin 3 →₀ ℕ) (i : Fin 3) :
    biIndex' n m - Finsupp.single (Sum.inl i : BiprojectiveCoordinate 2 2) 1
      = biIndex' (n - Finsupp.single i 1) m := by
  ext z
  cases z with
  | inl l => simp [Finsupp.tsub_apply, Finsupp.single_apply]
  | inr j => simp [Finsupp.tsub_apply]

/-- Coefficient of a pure first-block monomial `x^n`, as a polynomial in the second block. -/
def firstBlockCoeff (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (n : Fin 3 →₀ ℕ) : MvPolynomial (Fin 3) R :=
  ∑ d ∈ F.support,
    if firstPart d = n then monomial (secondPart d) (coeff d F) else 0

theorem coeff_firstBlockCoeff (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (n m : Fin 3 →₀ ℕ) :
    coeff m (firstBlockCoeff F n) = coeff (biIndex' n m) F := by
  classical
  rw [firstBlockCoeff, coeff_sum]
  have h : ∀ d ∈ F.support,
      coeff m (if firstPart d = n then monomial (secondPart d) (coeff d F) else 0)
        = if d = biIndex' n m then coeff d F else 0 := by
    intro d _
    by_cases h1 : firstPart d = n
    · by_cases h2 : secondPart d = m
      · have hd : d = biIndex' n m := (eq_biIndex'_iff d n m).mpr ⟨h2, h1⟩
        rw [if_pos h1, coeff_monomial, if_pos h2, if_pos hd]
      · have hd : d ≠ biIndex' n m := fun h => h2 (by rw [h]; simp)
        rw [if_pos h1, coeff_monomial, if_neg h2, if_neg hd]
    · have hd : d ≠ biIndex' n m := fun h => h1 (by rw [h]; simp)
      rw [if_neg h1, coeff_zero, if_neg hd]
  rw [Finset.sum_congr rfl h,
    Finset.sum_ite_eq' F.support (biIndex' n m) fun d => coeff d F]
  split_ifs with hmem
  · rfl
  · exact (MvPolynomial.notMem_support_iff.mp hmem).symm

theorem firstBlockCoeff_add (F G : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (n : Fin 3 →₀ ℕ) :
    firstBlockCoeff (F + G) n = firstBlockCoeff F n + firstBlockCoeff G n := by
  ext m; simp [coeff_firstBlockCoeff]

theorem firstBlockCoeff_C (a : R) (n : Fin 3 →₀ ℕ) :
    firstBlockCoeff (C a : MvPolynomial (BiprojectiveCoordinate 2 2) R) n =
      if n = 0 then C a else 0 := by
  classical
  ext m
  have key : ((0 : BiprojectiveCoordinate 2 2 →₀ ℕ) = biIndex' n m) ↔ (n = 0 ∧ m = 0) := by
    rw [eq_comm, biIndex'_eq_zero_iff]
  rw [coeff_firstBlockCoeff, coeff_C, apply_ite (coeff m), coeff_C, coeff_zero]
  by_cases hn : n = 0
  · rw [if_pos hn]
    by_cases hm : (0 : Fin 3 →₀ ℕ) = m
    · rw [if_pos hm, if_pos (key.mpr ⟨hn, hm.symm⟩)]
    · rw [if_neg hm, if_neg fun hc => hm (key.mp hc).2.symm]
  · rw [if_neg hn, if_neg fun hc => hn (key.mp hc).1]

theorem firstBlockCoeff_mul_X_inl (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (i : Fin 3) (n : Fin 3 →₀ ℕ) :
    firstBlockCoeff (F * X (Sum.inl i)) n =
      if i ∈ n.support then firstBlockCoeff F (n - single i 1) else 0 := by
  classical
  ext m
  have hmem : ((Sum.inl i : BiprojectiveCoordinate 2 2) ∈ (biIndex' n m).support)
      ↔ i ∈ n.support := by simp [Finsupp.mem_support_iff]
  rw [coeff_firstBlockCoeff, coeff_mul_X', apply_ite (coeff m), coeff_zero]
  by_cases hi : i ∈ n.support
  · have hbi : biIndex' n m - single (Sum.inl i) 1 = biIndex' (n - single i 1) m :=
      biIndex'_sub_single_inl n m i
    rw [if_pos (hmem.mpr hi), if_pos hi, hbi, coeff_firstBlockCoeff]
  · rw [if_neg fun hc => hi (hmem.mp hc), if_neg hi]

theorem firstBlockCoeff_mul_X_inr (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (j : Fin 3) (n : Fin 3 →₀ ℕ) :
    firstBlockCoeff (F * X (Sum.inr j)) n = firstBlockCoeff F n * X j := by
  classical
  ext m
  have hmem : ((Sum.inr j : BiprojectiveCoordinate 2 2) ∈ (biIndex' n m).support)
      ↔ j ∈ m.support := by simp [Finsupp.mem_support_iff]
  rw [coeff_firstBlockCoeff, coeff_mul_X', coeff_mul_X']
  by_cases hj : j ∈ m.support
  · have hbi : biIndex' n m - single (Sum.inr j) 1 = biIndex' n (m - single j 1) :=
      biIndex'_sub_single_inr n m j
    rw [if_pos (hmem.mpr hj), if_pos hj, hbi, coeff_firstBlockCoeff]
  · rw [if_neg fun hc => hj (hmem.mp hc), if_neg hj]

theorem map_firstBlockCoeff {S : Type*} [CommRing S] (φ : R →+* S)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (n : Fin 3 →₀ ℕ) :
    firstBlockCoeff (map φ F) n = map φ (firstBlockCoeff F n) := by
  ext m
  simp [coeff_firstBlockCoeff, coeff_map]

/-- The `x^n` coefficient of the conic fibre over `y` is `firstBlockCoeff F n` at `y`. -/
theorem coeff_specializeSecondCoordinates (y : Fin 3 → R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (n : Fin 3 →₀ ℕ) :
    coeff n (specializeSecondCoordinates (m := 2) y F) = eval y (firstBlockCoeff F n) := by
  classical
  induction F using MvPolynomial.induction_on generalizing n with
  | C a =>
      rw [specializeSecondCoordinates_C, firstBlockCoeff_C]
      by_cases hn : n = 0
      · subst hn; simp
      · rw [if_neg hn, map_zero, coeff_C, if_neg (Ne.symm hn)]
  | add p q hp hq =>
      rw [map_add, coeff_add, hp, hq, firstBlockCoeff_add, map_add]
  | mul_X p z hp =>
      cases z with
      | inl i =>
          rw [map_mul, specializeSecondCoordinates_X_inl, coeff_mul_X',
            firstBlockCoeff_mul_X_inl, apply_ite (eval y), map_zero]
          by_cases hi : i ∈ n.support
          · rw [if_pos hi, if_pos hi, hp]
          · rw [if_neg hi, if_neg hi]
      | inr j =>
          have hcm : specializeSecondCoordinates (m := 2) y (p * X (Sum.inr j)) =
              C (y j) * specializeSecondCoordinates (m := 2) y p := by
            rw [map_mul, specializeSecondCoordinates_X_inr, mul_comm]
          rw [hcm, coeff_C_mul, hp, firstBlockCoeff_mul_X_inr, map_mul, eval_X]
          ring

theorem degree_secondPart (d : BiprojectiveCoordinate 2 2 →₀ ℕ) :
    (secondPart d).degree = weight rightDegreeWeight d := by
  classical
  calc (secondPart d).degree
      = ∑ j : Fin 3, secondPart d j := by simp [degree_eq_sum]
    _ = ∑ j : Fin 3, d (.inr j) := by simp
    _ = weight rightDegreeWeight d := by
        rw [weight_apply, Finsupp.sum]
        refine Eq.symm ?_
        have hzero (x : BiprojectiveCoordinate 2 2) (hx : x ∉ d.support) :
            d x • rightDegreeWeight x = 0 := by
          have : d x = 0 := Finsupp.notMem_support_iff.mp hx
          simp [this]
        have huniv :
            (∑ x ∈ d.support, d x • rightDegreeWeight x) =
              ∑ x : BiprojectiveCoordinate 2 2, d x • rightDegreeWeight x :=
          Finset.sum_subset (Finset.subset_univ _) (fun x _ hx => hzero x hx)
        rw [huniv, Fintype.sum_sum_type]
        simp [rightDegreeWeight]

theorem firstBlockCoeff_isHomogeneous_of_bidegree23
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (n : Fin 3 →₀ ℕ) :
    (firstBlockCoeff F n).IsHomogeneous 3 := by
  classical
  refine IsHomogeneous.sum _ _ _ fun d hd => ?_
  split_ifs with h
  · have hdc : coeff d F ≠ 0 := MvPolynomial.mem_support_iff.mp hd
    have hdeg : weight bidegreeWeight d = (2, 3) := hF hdc
    have hright : weight rightDegreeWeight d = 3 := by
      simpa [snd_weight_bidegreeWeight] using congrArg Prod.snd hdeg
    have hsec : (secondPart d).degree = 3 := by
      simpa [degree_secondPart] using hright
    exact isHomogeneous_monomial (coeff d F) hsec
  · exact isHomogeneous_zero (Fin 3) R 3

theorem exists_firstBlockCoeff_ne_zero
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R} (hF0 : F ≠ 0) :
    ∃ n : Fin 3 →₀ ℕ, firstBlockCoeff F n ≠ 0 := by
  classical
  obtain ⟨d, hd⟩ := exists_coeff_ne_zero hF0
  refine ⟨firstPart d, ?_⟩
  intro h0
  have : coeff (secondPart d) (firstBlockCoeff F (firstPart d)) = 0 := by simp [h0]
  rw [coeff_firstBlockCoeff] at this
  have hbi : d = biIndex' (firstPart d) (secondPart d) :=
    (eq_biIndex'_iff d (firstPart d) (secondPart d)).mpr ⟨rfl, rfl⟩
  rw [← hbi] at this
  exact hd this

/-! ### Nonvanishing of homogeneous forms at the generic point of `ℙ²` -/

theorem isDomain_Away (K : Type u) [Field K] (j : Fin 3) :
    IsDomain (HomogeneousLocalization.Away (homogeneousSubmodule (Fin 3) K) (X j)) := by
  haveI : IsDomain (MvPolynomial (Fin 3) K) := inferInstance
  have hnz : (X j : MvPolynomial (Fin 3) K) ≠ 0 := X_ne_zero j
  haveI : IsDomain (Localization.Away (X j : MvPolynomial (Fin 3) K)) :=
    IsLocalization.isDomain_of_le_nonZeroDivisors _
      (powers_le_nonZeroDivisors_of_noZeroDivisors hnz)
  exact Function.Injective.isDomain
    (algebraMap (HomogeneousLocalization.Away (homogeneousSubmodule (Fin 3) K) (X j))
      (Localization.Away (X j : MvPolynomial (Fin 3) K)))
    (HomogeneousLocalization.val_injective (Submonoid.powers (X j : MvPolynomial (Fin 3) K)))

theorem Away_mk_ne_zero (K : Type u) [Field K]
    (c : MvPolynomial (Fin 3) K) (d : ℕ) (hc : c.IsHomogeneous d) (hc0 : c ≠ 0)
    (j : Fin 3) :
    HomogeneousLocalization.Away.mk (homogeneousSubmodule (Fin 3) K)
      (isHomogeneous_X K j) d c (by simpa using hc) ≠ 0 := by
  intro h
  have hval := congrArg HomogeneousLocalization.val h
  rw [HomogeneousLocalization.Away.val_mk, HomogeneousLocalization.val_zero,
    Localization.mk_eq_mk'_apply] at hval
  haveI : IsDomain (MvPolynomial (Fin 3) K) := inferInstance
  rw [IsLocalization.mk'_eq_zero_iff] at hval
  obtain ⟨⟨s, hs⟩, hsc⟩ := hval
  obtain ⟨n, rfl⟩ := (Submonoid.mem_powers_iff s (X j)).mp hs
  change (X j : MvPolynomial (Fin 3) K) ^ n * c = 0 at hsc
  exact hc0 ((mul_eq_zero.mp hsc).resolve_left (pow_ne_zero n (X_ne_zero j)))

theorem aeval_normalizedCoordinate_eq_Away_mk (K : Type u) [Field K]
    (c : MvPolynomial (Fin 3) K) (d : ℕ) (hc : c.IsHomogeneous d) (j : Fin 3) :
    aeval (fun l => ProjectiveSpace.normalizedCoordinate 2 K j l) c =
      HomogeneousLocalization.Away.mk (homogeneousSubmodule (Fin 3) K)
        (isHomogeneous_X K j) d c (by simpa using hc) := by
  have h := ProjectiveSpace.mvPolynomialToStandardChart_chartDehomogenization_of_isHomogeneous
    2 K j hc
  have hcomp := ProjectiveSpace.mvPolynomialToStandardChart_comp_chartDehomogenization 2 K j
  have : aeval (fun l => ProjectiveSpace.normalizedCoordinate 2 K j l) c =
      ProjectiveSpace.mvPolynomialToStandardChart 2 K j
        (ProjectiveSpace.chartDehomogenization 2 K j c) := by
    rw [← AlgHom.comp_apply, hcomp]
  rw [this, h]

theorem eval_normalizedResidueCoordinates_map (K : Type u) [Field K]
    (c : MvPolynomial (Fin 3) K) (y : ProjectiveSpace 2 K) (j : Fin 3)
    (hy : y ∈ ProjectiveSpace.standardChart 2 K j) :
    eval (ProjectiveSpace.normalizedResidueCoordinates 2 K y j hy)
        (map (ProjectiveSpace.residueCoefficientMap 2 K y) c) =
      ProjectiveSpace.standardChartResidueRingHom 2 K y j hy
        (aeval (fun l => ProjectiveSpace.normalizedCoordinate 2 K j l) c) := by
  let ρ := ProjectiveSpace.standardChartResidueRingHom 2 K y j hy
  have hφ : ρ.comp (ProjectiveSpace.standardChartRingHom 2 K j) =
      ProjectiveSpace.residueCoefficientMap 2 K y :=
    ProjectiveSpace.standardChartResidueRingHom_comp_standardChartRingHom 2 K y j hy
  rw [eval_map]
  induction c using MvPolynomial.induction_on with
  | C r =>
      simp only [eval₂_C, aeval_C]
      exact (DFunLike.congr_fun hφ r).symm
  | add f g hf hg => simp only [eval₂_add, map_add, hf, hg]
  | mul_X p i hp => simp only [eval₂_mul, eval₂_X, map_mul, aeval_X, hp]; rfl

theorem genericPoint_mem_standardChart' (K : Type u) [Field K] (j : Fin 3) :
    genericPoint (ProjectiveSpace 2 K) ∈ ProjectiveSpace.standardChart 2 K j := by
  have hη_eq : ProjectiveSpace.genericPoint 2 K = genericPoint (ProjectiveSpace 2 K) := by
    refine ((genericPoint_spec (ProjectiveSpace 2 K)).eq ?_).symm
    rw [isGenericPoint_def, ← dense_iff_closure_eq]
    exact ProjectiveSpectrum.dense_singleton_genericPoint _
      (ProjectiveSpace.irrelevant_ne_bot 2 K)
  rw [← hη_eq]
  exact ProjectiveSpace.genericPoint_mem_standardChart 2 K j

theorem standardChartResidueRingHom_injective_generic (K : Type u) [Field K] (j : Fin 3) :
    Function.Injective
      (ProjectiveSpace.standardChartResidueRingHom 2 K (genericPoint (ProjectiveSpace 2 K)) j
        (genericPoint_mem_standardChart' K j)) := by
  set y := genericPoint (ProjectiveSpace 2 K)
  set hy : y ∈ ProjectiveSpace.standardChart 2 K j := genericPoint_mem_standardChart' K j
  set ρ := ProjectiveSpace.standardChartResidueRingHom 2 K y j hy
  haveI hDom : IsDomain (ProjectiveSpace.StandardChartRing 2 K j) := isDomain_Away K j
  haveI : IsIntegral (Spec (.of (ProjectiveSpace.StandardChartRing 2 K j))) :=
    (affine_isIntegral_iff _).mpr hDom
  haveI : IrreducibleSpace (Spec (.of (ProjectiveSpace.StandardChartRing 2 K j))) :=
    inferInstance
  haveI : IrreducibleSpace (ProjectiveSpace 2 K) := inferInstance
  have hgenι : (ProjectiveSpace.standardChartι 2 K j).base
      (genericPoint (Spec (.of (ProjectiveSpace.StandardChartRing 2 K j)))) =
      genericPoint (ProjectiveSpace 2 K) :=
    genericPoint_eq_of_isOpenImmersion (ProjectiveSpace.standardChartι 2 K j)
  have hlift_comp := ProjectiveSpace.standardChartResidueLift_standardChartι 2 K y j hy
  let pt : Spec ((ProjectiveSpace 2 K).residueField y) := IsLocalRing.closedPoint _
  have hlift_at : (ProjectiveSpace.standardChartι 2 K j).base
      ((ProjectiveSpace.standardChartResidueLift 2 K y j hy).base pt) =
      genericPoint (ProjectiveSpace 2 K) := by
    have himage :
        (ProjectiveSpace.standardChartResidueLift 2 K y j hy ≫
          ProjectiveSpace.standardChartι 2 K j) pt = y := by
      rw [hlift_comp]
      exact Scheme.fromSpecResidueField_apply y pt
    change (ProjectiveSpace.standardChartι 2 K j)
        ((ProjectiveSpace.standardChartResidueLift 2 K y j hy) pt) = y at himage
    exact himage
  have hpt_eq : (ProjectiveSpace.standardChartResidueLift 2 K y j hy).base pt =
      genericPoint (Spec (.of (ProjectiveSpace.StandardChartRing 2 K j))) := by
    apply (ProjectiveSpace.standardChartι 2 K j).isOpenEmbedding.injective
    rw [hlift_at, hgenι]
  have hlift_eq : ProjectiveSpace.standardChartResidueLift 2 K y j hy =
      Spec.map (CommRingCat.ofHom ρ) := by
    change ProjectiveSpace.standardChartResidueLift 2 K y j hy =
      Spec.map (CommRingCat.ofHom
        (Spec.preimage (ProjectiveSpace.standardChartResidueLift 2 K y j hy)).hom)
    exact (Spec.map_preimage _).symm
  have hbot : (pt : PrimeSpectrum ((ProjectiveSpace 2 K).residueField y)).asIdeal = ⊥ :=
    (IsSimpleOrder.eq_bot_or_eq_top _).resolve_right (Ideal.IsPrime.ne_top inferInstance)
  have hker_asIdeal :
      ((Spec.map (CommRingCat.ofHom ρ)).base pt).asIdeal = RingHom.ker ρ := by
    change (PrimeSpectrum.comap ρ pt).asIdeal = RingHom.ker ρ
    rw [PrimeSpectrum.comap_asIdeal, hbot, ← RingHom.ker_eq_comap_bot]
  have hker_bot : RingHom.ker ρ = ⊥ := by
    have himg : ((Spec.map (CommRingCat.ofHom ρ)).base pt).asIdeal =
        (genericPoint (Spec (.of (ProjectiveSpace.StandardChartRing 2 K j)))).asIdeal := by
      rw [← hlift_eq, hpt_eq]
    rw [← hker_asIdeal, himg, genericPoint_eq_bot_of_affine]
    rfl
  rwa [RingHom.injective_iff_ker_eq_bot]

/-- Nonzero homogeneous forms do not vanish at the generic point of `ℙ²`. -/
theorem eval_normalizedResidue_generic_ne_zero (K : Type u) [Field K]
    (c : MvPolynomial (Fin 3) K) (d : ℕ) (hc : c.IsHomogeneous d) (hc0 : c ≠ 0)
    (j : Fin 3) :
    eval (ProjectiveSpace.normalizedResidueCoordinates 2 K
        (genericPoint (ProjectiveSpace 2 K)) j (genericPoint_mem_standardChart' K j))
      (map (ProjectiveSpace.residueCoefficientMap 2 K
        (genericPoint (ProjectiveSpace 2 K))) c) ≠ 0 := by
  set y := genericPoint (ProjectiveSpace 2 K)
  set hy : y ∈ ProjectiveSpace.standardChart 2 K j := genericPoint_mem_standardChart' K j
  intro hzero
  have heq := eval_normalizedResidueCoordinates_map K c y j hy
  have haeval := aeval_normalizedCoordinate_eq_Away_mk K c d hc j
  have hAway0 := Away_mk_ne_zero K c d hc hc0 j
  have hρ0 : ProjectiveSpace.standardChartResidueRingHom 2 K y j hy
      (HomogeneousLocalization.Away.mk (homogeneousSubmodule (Fin 3) K)
        (isHomogeneous_X K j) d c (by simpa using hc)) = 0 := by
    rwa [← haeval, ← heq]
  exact hAway0 ((standardChartResidueRingHom_injective_generic K j).eq_iff.mp
    (by rw [hρ0, map_zero]))

/-! ### Main: `sndResidueFiberPolynomial` at the generic point -/

/-- The specialised second-projection fibre equation of a nonzero bidegree-`(2,3)` form is
nonzero at the generic point of `ℙ²_y`. -/
theorem sndResidueFiberPolynomial_ne_zero_at_generic (K : Type u) [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0) (j : Fin 3) :
    sndResidueFiberPolynomial F (genericPoint (ProjectiveSpace 2 K)) j
      (genericPoint_mem_standardChart' K j) ≠ 0 := by
  classical
  set y := genericPoint (ProjectiveSpace 2 K)
  set hy : y ∈ ProjectiveSpace.standardChart 2 K j := genericPoint_mem_standardChart' K j
  set φ := ProjectiveSpace.residueCoefficientMap 2 K y
  set Q := sndResidueFiberPolynomial F y j hy
  obtain ⟨n, hn0⟩ := exists_firstBlockCoeff_ne_zero (R := K) hF0
  have hhom := firstBlockCoeff_isHomogeneous_of_bidegree23 (R := K) hF n
  have hne := eval_normalizedResidue_generic_ne_zero K (firstBlockCoeff F n) 3 hhom hn0 j
  intro hQ0
  have hcoeff : coeff n Q = 0 := by simp [hQ0]
  have hrel :
      coeff n Q =
        eval (ProjectiveSpace.normalizedResidueCoordinates 2 K y j hy)
          (map φ (firstBlockCoeff F n)) := by
    dsimp [Q, sndResidueFiberPolynomial]
    rw [coeff_specializeSecondCoordinates, map_firstBlockCoeff]
  exact hne (hrel ▸ hcoeff)

end BiprojectiveSpace

end

end BConicBundleMultisections
