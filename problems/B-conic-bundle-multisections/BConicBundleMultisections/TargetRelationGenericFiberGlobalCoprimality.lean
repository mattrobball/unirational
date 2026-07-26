/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.IrreducibleHomogeneousChart
public import BConicBundleMultisections.TargetRelationGenericFiberArtinian
public import Mathlib.RingTheory.MvPolynomial.Localization
public import Mathlib.RingTheory.Polynomial.GaussLemma
public import Mathlib.RingTheory.PrincipalIdealDomain

/-!
# A global coprimality input for target-relation generic fibres

This module supplies the coefficient-extension and localization algebra needed to replace six
ordered affine-chart hypotheses by a single homogeneous no-common-component statement over the
generic first function field.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u v w x

open AlgebraicGeometry
open MvPolynomial

attribute [local instance] MvPolynomial.algebraMvPolynomial

/-! ## Irreducibility over a purely transcendental extension -/

private theorem totalDegree_map_eq_of_injective
    {R : Type u} {S : Type v} {τ : Type w} [CommSemiring R] [CommSemiring S]
    (f : R →+* S) (hf : Function.Injective f) (p : MvPolynomial τ R) :
    (p.map f).totalDegree = p.totalDegree := by
  unfold MvPolynomial.totalDegree
  rw [MvPolynomial.support_map_of_injective p hf]

/-- Adjoining an arbitrary family of polynomial variables preserves primality of a
multivariate polynomial over a field. -/
theorem MvPolynomial.prime_map_C_of_prime
    {k : Type u} {σ : Type v} {τ : Type w} [Field k]
    {p : MvPolynomial τ k} (hp : Prime p) :
    Prime (p.map (MvPolynomial.C : k →+* MvPolynomial σ k)) := by
  let e : MvPolynomial σ (MvPolynomial τ k) ≃+*
      MvPolynomial τ (MvPolynomial σ k) :=
    (MvPolynomial.sumRingEquiv k σ τ).symm.trans
      ((MvPolynomial.renameEquiv k (Equiv.sumComm σ τ)).toRingEquiv.trans
        (MvPolynomial.sumRingEquiv k τ σ))
  have hCp : Prime (MvPolynomial.C p : MvPolynomial σ (MvPolynomial τ k)) :=
    (MvPolynomial.prime_C_iff σ).2 hp
  have heq : e (MvPolynomial.C p) =
      p.map (MvPolynomial.C : k →+* MvPolynomial σ k) := by
    have hehom : e.toRingHom.comp
          (MvPolynomial.C : MvPolynomial τ k →+* MvPolynomial σ (MvPolynomial τ k)) =
        (MvPolynomial.map (MvPolynomial.C : k →+* MvPolynomial σ k)) := by
      apply MvPolynomial.ringHom_ext
      · intro c
        simp [e]
      · intro i
        simp [e]
    exact DFunLike.congr_fun hehom p
  rw [← heq]
  exact (MulEquiv.prime_iff e.toMulEquiv).2 hCp

/-- An irreducible polynomial over a field stays irreducible after extending coefficients to a
purely transcendental function field.  The proof first adjoins the transcendence variables,
where primality is preserved, and then localizes their polynomial ring at all nonzero elements.
-/
theorem MvPolynomial.irreducible_map_fractionRing_mvPolynomial
    {k : Type u} {σ : Type v} {τ : Type w} [Field k]
    (H : MvPolynomial τ k) (hH : Irreducible H) :
    Irreducible
      (H.map (algebraMap k (FractionRing (MvPolynomial σ k)))) := by
  let R := MvPolynomial σ k
  let K := FractionRing R
  let A := MvPolynomial τ R
  let B := MvPolynomial τ K
  let H_R : A := H.map (MvPolynomial.C : k →+* R)
  let H_K : B := H.map (algebraMap k K)
  have hHprime : Prime H :=
    UniqueFactorizationMonoid.irreducible_iff_prime.mp hH
  have hHRprime : Prime H_R := by
    exact MvPolynomial.prime_map_C_of_prime hHprime
  have hHR0 : H_R ≠ 0 := hHRprime.ne_zero
  have hspanPrime : (Ideal.span ({H_R} : Set A)).IsPrime :=
    (Ideal.span_singleton_prime hHR0).2 hHRprime
  let M : Submonoid A :=
    (nonZeroDivisors R).map (MvPolynomial.C : R →+* A).toMonoidHom
  letI : IsLocalization M B := by
    dsimp only [M, A, B]
    exact MvPolynomial.isLocalization (nonZeroDivisors R) K
  have hdisjoint : Disjoint (M : Set A) (Ideal.span ({H_R} : Set A) : Set A) := by
    rw [Set.disjoint_left]
    intro q hqM hqSpan
    obtain ⟨r, hr, rfl⟩ := hqM
    have hr0 : r ≠ 0 := by
      exact mem_nonZeroDivisors_iff_ne_zero.mp hr
    have hdvd : H_R ∣ MvPolynomial.C r :=
      Ideal.mem_span_singleton.mp hqSpan
    have hdegHR : H_R.totalDegree = 0 := by
      apply Nat.eq_zero_of_le_zero
      simpa using MvPolynomial.totalDegree_le_of_dvd_of_isDomain hdvd (by simp [hr0])
    have hdegH : H.totalDegree = 0 := by
      rw [← totalDegree_map_eq_of_injective
        (MvPolynomial.C : k →+* R) (MvPolynomial.C_injective σ k) H]
      exact hdegHR
    have hHC : H = MvPolynomial.C (H.coeff 0) :=
      MvPolynomial.totalDegree_eq_zero_iff_eq_C.mp hdegH
    apply hH.not_isUnit
    rw [hHC]
    exact (isUnit_iff_ne_zero.mpr (by
      intro hz
      apply hH.ne_zero
      rw [hHC, hz, map_zero])) |>.map MvPolynomial.C
  have hlocalizedPrime :
      (Ideal.map (algebraMap A B) (Ideal.span ({H_R} : Set A))).IsPrime := by
    exact IsLocalization.isPrime_of_isPrime_disjoint M B _ hspanPrime hdisjoint
  have halgH : algebraMap A B H_R = H_K := by
    change MvPolynomial.map (algebraMap R K)
        (H.map (MvPolynomial.C : k →+* R)) = H.map (algebraMap k K)
    rw [MvPolynomial.map_map]
    congr 1
  have hspanK :
      Ideal.map (algebraMap A B) (Ideal.span ({H_R} : Set A)) =
        Ideal.span ({H_K} : Set B) := by
    rw [Ideal.map_span, Set.image_singleton, halgH]
  have hHKprime : Prime H_K := by
    have hHK0 : H_K ≠ 0 := by
      intro hz
      apply hH.ne_zero
      apply MvPolynomial.map_injective (algebraMap k K)
        (FaithfulSMul.algebraMap_injective k K)
      simpa only [map_zero] using hz
    exact (Ideal.span_singleton_prime hHK0).mp (hspanK ▸ hlocalizedPrime)
  exact UniqueFactorizationMonoid.irreducible_iff_prime.mpr hHKprime

/-! ## From one affine irreducible equation to ordered fraction-field coprimality -/

open PlaneCurveIntersectionArtinian

/-- If one affine plane equation is irreducible (or a unit) and does not divide the other, then
the two equations are coprime after viewing either chosen coordinate as the outer univariate
variable and passing to the fraction field of the other coordinate.

The nonconstant case is precisely Gauss's lemma.  If the chosen equation becomes constant in the
outer variable, irreducibility makes that coefficient nonzero, hence a unit after localization.
-/
theorem isCoprimeOverFractionFieldInOrder_of_irreducible_or_isUnit_of_not_dvd
    {K : Type u} [Field K]
    (h q : MvPolynomial (Fin 2) K) (e : Fin 2 ≃ Fin 2)
    (hirr : Irreducible h ∨ IsUnit h)
    (hnot : ¬ IsUnit h → ¬ h ∣ q) :
    IsCoprimeOverFractionFieldInOrder h q e := by
  let R := MvPolynomial (Fin 1) K
  let L := FractionRing R
  let E := orderedAffinePlaneEquiv (K := K) e
  let p : Polynomial R := E h
  let r : Polynomial R := E q
  let φ : R →+* L := algebraMap R L
  change IsCoprime (p.map φ) (r.map φ)
  rcases hirr with hirr | hunit
  · have hpirr : Irreducible p :=
      (MulEquiv.irreducible_iff E.toRingEquiv.toMulEquiv).2 hirr
    have hnotP : ¬ p ∣ r := by
      intro hdvd
      apply hnot hirr.not_isUnit
      obtain ⟨a, ha⟩ := hdvd
      refine ⟨E.symm a, ?_⟩
      apply E.injective
      simpa [p, r] using ha
    by_cases hpdeg : p.natDegree = 0
    · have hpcoeff0 : p.coeff 0 ≠ 0 := by
        intro hz
        apply hpirr.ne_zero
        rw [Polynomial.eq_C_of_natDegree_eq_zero hpdeg, hz, map_zero]
      have hcoeffUnit : IsUnit (φ (p.coeff 0)) :=
        isUnit_iff_ne_zero.mpr (by
          simpa only [map_zero] using (IsFractionRing.injective R L).ne hpcoeff0)
      have hpmapUnit : IsUnit (p.map φ) := by
        rw [Polynomial.eq_C_of_natDegree_eq_zero hpdeg, Polynomial.map_C]
        exact hcoeffUnit.map Polynomial.C
      simpa only [mul_one] using
        (isCoprime_mul_unit_left_left hpmapUnit 1 (r.map φ)).2 isCoprime_one_left
    · have hpprim : p.IsPrimitive := hpirr.isPrimitive hpdeg
      have hpmapirr : Irreducible (p.map φ) :=
        (hpprim.irreducible_iff_irreducible_map_fraction_map).1 hpirr
      apply hpmapirr.coprime_iff_not_dvd.mpr
      intro hdvd
      apply hnotP
      exact (hpprim.dvd_iff_fraction_map_dvd_fraction_map L).2 hdvd
  · have hpunit : IsUnit p := hunit.map E
    have hpmapUnit : IsUnit (p.map φ) := hpunit.map (Polynomial.mapRingHom φ)
    simpa only [mul_one] using
      (isCoprime_mul_unit_left_left hpmapUnit 1 (r.map φ)).2 isCoprime_one_left

/-- Homogeneous nondivisibility by an irreducible projective equation implies ordered
fraction-field coprimality on every affine chart.  Empty charts are handled by the unit branch;
on a nonempty chart, `not_dvd_chartDehomogenization_of_irreducible` descends the global
nondivisibility statement before Gauss's lemma is applied. -/
theorem chartDehomogenization_isCoprimeOverFractionFieldInOrder_of_irreducible_not_dvd
    {K : Type u} [Field K] {d e : ℕ}
    (H Q : MvPolynomial (Fin 3) K)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (hQ : Q.IsHomogeneous e) (hnot : ¬ H ∣ Q)
    (j : Fin 3) (order : Fin 2 ≃ Fin 2) :
    IsCoprimeOverFractionFieldInOrder
      (ProjectiveSpace.chartDehomogenization 2 K j H)
      (ProjectiveSpace.chartDehomogenization 2 K j Q) order := by
  let h := ProjectiveSpace.chartDehomogenization 2 K j H
  let q := ProjectiveSpace.chartDehomogenization 2 K j Q
  apply isCoprimeOverFractionFieldInOrder_of_irreducible_or_isUnit_of_not_dvd h q order
  · exact ProjectiveSpace.irreducible_or_isUnit_chartDehomogenization j H hH hHirr
  · intro hnonunit
    exact ProjectiveSpace.not_dvd_chartDehomogenization_of_irreducible
      j H Q hH hHirr hQ hnonunit hnot

/-- One homogeneous no-common-component condition over a field: the second equation is
irreducible and is not a component of the first equation.  There are no chartwise or
coordinate-order hypotheses in this package. -/
def HasHomogeneousPlaneCurveGlobalCoprimality
    {K : Type u} [Field K]
    (Q H : MvPolynomial (Fin 3) K) : Prop :=
  Irreducible H ∧ ¬ H ∣ Q

/-- The homogeneous global condition supplies the factor-theoretic alternative on all three
affine charts.  A chart missed by the irreducible projective curve has unit equation; on every
other chart its equation stays irreducible and cannot divide the first equation. -/
theorem threeChartIrreducibleSecondEquation_of_homogeneous_globalCoprimality
    {K : Type u} [Field K] {d e : ℕ}
    (Q H : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous e) (hH : H.IsHomogeneous d)
    (hglobal : HasHomogeneousPlaneCurveGlobalCoprimality Q H) :
    ∀ j : Fin 3,
      IsUnit (ProjectiveSpace.chartDehomogenization 2 K j H) ∨
        (Irreducible (ProjectiveSpace.chartDehomogenization 2 K j H) ∧
          ¬ ProjectiveSpace.chartDehomogenization 2 K j H ∣
            ProjectiveSpace.chartDehomogenization 2 K j Q) := by
  intro j
  rcases ProjectiveSpace.irreducible_or_isUnit_chartDehomogenization
      j H hH hglobal.1 with hirr | hunit
  · exact Or.inr ⟨hirr,
      ProjectiveSpace.not_dvd_chartDehomogenization_of_irreducible
        j H Q hH hglobal.1 hQ hirr.not_isUnit hglobal.2⟩
  · exact Or.inl hunit

namespace BiprojectiveSpace

/-- The single global factor-theoretic input for a target-relation fibre at a point of the
first projective plane.  It is stated before dehomogenization, over the point's residue field. -/
def HasTargetRelationFstFiberGlobalCoprimality
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i) : Prop :=
  letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
    ProjectiveSpace.residueAlgebra 2 k x
  HasHomogeneousPlaneCurveGlobalCoprimality
    (fstResidueFiberPolynomial F x i hx)
    (H.map (ProjectiveSpace.residueCoefficientMap 2 k x))

/-- A single homogeneous global coprimality statement implies the three chartwise
irreducible-or-unit/nondivisibility alternatives required by the factor-theoretic fibre
criterion. -/
theorem hasTargetRelationFstFiberIrreducibleChartEquation_of_globalCoprimality
    {k : Type u} [Field k] {dF eF dH : ℕ}
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hH : H.IsHomogeneous dH)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i)
    (hglobal : HasTargetRelationFstFiberGlobalCoprimality F H x i hx) :
    HasTargetRelationFstFiberIrreducibleChartEquation F H x i hx := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
    ProjectiveSpace.residueAlgebra 2 k x
  let Q := fstResidueFiberPolynomial F x i hx
  let P := H.map (ProjectiveSpace.residueCoefficientMap 2 k x)
  have hQ : Q.IsHomogeneous eF :=
    fstResidueFiberPolynomial_isHomogeneous hF x i hx
  have hP : P.IsHomogeneous dH :=
    hH.map (ProjectiveSpace.residueCoefficientMap 2 k x)
  have hcharts :=
    threeChartIrreducibleSecondEquation_of_homogeneous_globalCoprimality
      Q P hQ hP hglobal
  intro j
  rw [BConicBundleMultisections.fstBaseChangedChartEquation_eq_chartDehomogenization_fstResidue]
  rw [fstBaseChangedChartEquation_rename_inr]
  exact hcharts j

/-- Generic target-relation fibres are locally Artinian under the single global homogeneous
condition `Irreducible H_K ∧ ¬ H_K ∣ Q_K` over the generic first-plane residue field. -/
theorem targetRelation_genericFiber_isLocallyArtinian_of_globalCoprimality
    {k : Type u} [Field k] {dF eF dH : ℕ}
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hH : H.IsHomogeneous dH)
    (i : Fin 3)
    (hglobal : HasTargetRelationFstFiberGlobalCoprimality F H
      (genericPoint (ProjectiveSpace 2 k)) i
        (schemeGenericPoint_mem_standardChart k i)) :
    IsLocallyArtinian
      ((targetRelationToFirst F H).fiber
        (genericPoint (ProjectiveSpace 2 k))) :=
  targetRelation_genericFiber_isLocallyArtinian_of_irreducibleChartEquation
    F H hF hH i
      (hasTargetRelationFstFiberIrreducibleChartEquation_of_globalCoprimality
        F H hF hH (genericPoint (ProjectiveSpace 2 k)) i
          (schemeGenericPoint_mem_standardChart k i) hglobal)

end BiprojectiveSpace

end

end BConicBundleMultisections
