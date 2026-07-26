/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HomogeneousJacobianChart
public import BConicBundleMultisections.ResidualTargetNegativeTwistLocal
public import BConicBundleMultisections.ResidualTargetRelationNullstellensatz

/-!
# From chartwise vanishing on a projective target curve to a vertical Cox relation

The negative-twist argument naturally concludes that the residual equation restricts to zero on
each nonempty affine chart of the projective curve `V(H)`.  This file turns exactly that
projective statement into the global Cox-ideal membership needed by the elementary bidegree
argument.

Crucially, Nullstellensatz is applied only to the principal vertical ideal `(H(y))`.  For
irreducible `H` this cone ideal is prime.  No primeness or radicality assertion is made about the
complete-intersection cone `(F,H(y))`, whose irrelevant vertex is the source of the saturation
problem in the discarded route.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open _root_.MvPolynomial

universe u

/-! ## Evaluation after independent projective rescaling -/

/-- Evaluation of a bihomogeneous form after rescaling the first coordinate block. -/
theorem IsBihomogeneousOfBidegree.eval_smul_first
    {m n : ℕ} {K : Type u} [Field K]
    {d e : ℕ} {P : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hP : IsBihomogeneousOfBidegree d e P)
    (a : K) (x : Fin (m + 1) → K) (y : Fin (n + 1) → K) :
    eval (Sum.elim (fun i ↦ a * x i) y) P =
      a ^ d * eval (Sum.elim x y) P := by
  have hx : (fun i ↦ a * x i) = (a • x : Fin (m + 1) → K) := by
    funext i
    simp [Pi.smul_apply, smul_eq_mul]
  have h := congrArg (eval y) (hP.specializeFirstCoordinates_smul a x)
  rw [eval_specializeFirstCoordinates, map_mul, eval_C,
    eval_specializeFirstCoordinates] at h
  rw [hx, h]

/-- Evaluation of a bihomogeneous form after rescaling the second coordinate block. -/
theorem IsBihomogeneousOfBidegree.eval_smul_second
    {m n : ℕ} {K : Type u} [Field K]
    {d e : ℕ} {P : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hP : IsBihomogeneousOfBidegree d e P)
    (b : K) (x : Fin (m + 1) → K) (y : Fin (n + 1) → K) :
    eval (Sum.elim x (fun j ↦ b * y j)) P =
      b ^ e * eval (Sum.elim x y) P := by
  have hy : (fun j ↦ b * y j) = (b • y : Fin (n + 1) → K) := by
    funext j
    simp [Pi.smul_apply, smul_eq_mul]
  have h := congrArg (eval x) (hP.specializeSecondCoordinates_smul b y)
  rw [eval_specializeSecondCoordinates, map_mul, eval_C,
    eval_specializeSecondCoordinates] at h
  rw [hy, h]

/-- Evaluation after independent rescaling of the two homogeneous coordinate blocks. -/
theorem IsBihomogeneousOfBidegree.eval_smul_both
    {m n : ℕ} {K : Type u} [Field K]
    {d e : ℕ} {P : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hP : IsBihomogeneousOfBidegree d e P)
    (a b : K) (x : Fin (m + 1) → K) (y : Fin (n + 1) → K) :
    eval (Sum.elim (fun i ↦ a * x i) (fun j ↦ b * y j)) P =
      a ^ d * b ^ e * eval (Sum.elim x y) P := by
  rw [hP.eval_smul_second b (fun i ↦ a * x i) y,
    hP.eval_smul_first a x y]
  ring

namespace BiprojectiveSpace

/-! ## Evaluating the target-curve chart quotient -/

/-- Evaluation of a target-curve affine chart quotient at a homogeneous point on `V(H)`. -/
def targetRelationBaseChartEval
    {K : Type u} [Field K]
    {d : ℕ} (H : MvPolynomial (Fin 3) K) (hH : H.IsHomogeneous d)
    (y : Fin 3 → K) (b : Fin 3) (hyb : y b ≠ 0) (hHy : eval y H = 0) :
    targetRelationBaseChartRing K H b →+* K :=
  Ideal.Quotient.lift _ (eval (affineCoords y b hyb))
    (by
      intro P hP
      obtain ⟨A, hA⟩ := Ideal.mem_span_singleton.mp hP
      have hchart :
          eval (affineCoords y b hyb)
              (ProjectiveSpace.chartDehomogenization 2 K b H) = 0 :=
        eval_chartDehomogenization_eq_zero_of
          H d hH y b hyb hHy
      rw [hA, map_mul, hchart, zero_mul])

@[simp]
theorem targetRelationBaseChartEval_mk_X
    {K : Type u} [Field K]
    {d : ℕ} (H : MvPolynomial (Fin 3) K) (hH : H.IsHomogeneous d)
    (y : Fin 3 → K) (b : Fin 3) (hyb : y b ≠ 0) (hHy : eval y H = 0)
    (s : Fin 2) :
    targetRelationBaseChartEval H hH y b hyb hHy
      (Ideal.Quotient.mk
          (Ideal.span {ProjectiveSpace.chartDehomogenization 2 K b H}) (X s)) =
      affineCoords y b hyb s := by
  simp [targetRelationBaseChartEval]

@[simp]
theorem targetRelationBaseChartEval_algebraMap
    {K : Type u} [Field K]
    {d : ℕ} (H : MvPolynomial (Fin 3) K) (hH : H.IsHomogeneous d)
    (y : Fin 3 → K) (b : Fin 3) (hyb : y b ≠ 0) (hHy : eval y H = 0)
    (c : K) :
    targetRelationBaseChartEval H hH y b hyb hHy
        (algebraMap K (targetRelationBaseChartRing K H b) c) = c := by
  rw [← Ideal.Quotient.mk_algebraMap]
  simp [targetRelationBaseChartEval]

/-- Restriction to the target-curve quotient followed by evaluation agrees with ordinary
evaluation at the two affine coordinate blocks. -/
theorem eval_map_targetRelationBaseChartEval_affineChartToTargetRelationBase
    {K : Type u} [Field K]
    {d : ℕ} (H : MvPolynomial (Fin 3) K) (hH : H.IsHomogeneous d)
    (y : Fin 3 → K) (b : Fin 3) (hyb : y b ≠ 0) (hHy : eval y H = 0)
    (xaff : Fin 2 → K) (P : MvPolynomial (Fin 2 ⊕ Fin 2) K) :
    eval xaff
        (map (targetRelationBaseChartEval H hH y b hyb hHy)
          (affineChartToTargetRelationBase K H b P)) =
      eval (Sum.elim xaff (affineCoords y b hyb)) P := by
  induction P using MvPolynomial.induction_on with
  | C c =>
      simp [affineChartToTargetRelationBase,
        targetRelationBaseChartEval_algebraMap]
  | add P Q hP hQ =>
      simpa only [map_add] using congrArg₂ (fun p q ↦ p + q) hP hQ
  | mul_X P z hP =>
      rw [map_mul, map_mul, map_mul, hP]
      rcases z with r | s
      · simp [affineChartToTargetRelationBase]
      · simp [affineChartToTargetRelationBase,
          targetRelationBaseChartEval_mk_X]

/-! ## Projective chart vanishing implies global vertical membership -/

/-- Renaming an irreducible polynomial into the second Cox block remains prime. -/
theorem prime_rename_inr_of_irreducible
    {K : Type u} [Field K]
    (H : MvPolynomial (Fin 3) K) (hH : Irreducible H) :
    Prime (rename (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H) := by
  let e := (MvPolynomial.sumAlgEquiv K (Fin 3) (Fin 3)).toRingEquiv
  have heq : e (rename (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H) =
      C H := by
    have h := DFunLike.congr_fun
      (MvPolynomial.sumAlgEquiv_comp_rename_inr
        (R := K) (S₁ := Fin 3) (S₂ := Fin 3)) H
    simpa [e] using h
  have hC : Prime (C H : MvPolynomial (Fin 3) (MvPolynomial (Fin 3) K)) :=
    (MvPolynomial.prime_C_iff (Fin 3)).2 hH.prime
  have heprime : Prime
      (e (rename (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H)) := by
    rwa [heq]
  exact (MulEquiv.prime_iff e.toMulEquiv).mp heprime

/-- If a bihomogeneous equation restricts to zero on every nonempty target-curve chart, then it
belongs to the principal vertical Cox ideal generated by `H`.

The hypothesis is deliberately conditional on the chart equation of `H` being a nonunit.  Empty
standard charts contain no projective point and impose no condition. -/
theorem mem_span_zero_rename_inr_of_targetRelation_chart_zero
    {K : Type u} [Field K] [IsAlgClosed K]
    {aq bq d : ℕ}
    (Q : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hQ : IsBihomogeneousOfBidegree aq bq Q) (haq : 0 < aq) (hbq : 0 < bq)
    (H : MvPolynomial (Fin 3) K) (hH : H.IsHomogeneous d)
    (hHirr : Irreducible H)
    (hzero : ∀ (a b : Fin 3),
      ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 K b H) →
        affineChartEquationOverTargetRelationBase K H a b Q = 0) :
    Q ∈ Ideal.span
      {(0 : MvPolynomial (BiprojectiveCoordinate 2 2) K), rename Sum.inr H} := by
  have hrenamePrime : Prime
      (rename (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H) :=
    prime_rename_inr_of_irreducible H hHirr
  have hprincipal :
      (Ideal.span
        {rename (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H}).IsPrime :=
    (Ideal.span_singleton_prime hrenamePrime.ne_zero).2 hrenamePrime
  have hpairPrime :
      (Ideal.span
        {(0 : MvPolynomial (BiprojectiveCoordinate 2 2) K), rename Sum.inr H}).IsPrime := by
    rw [Ideal.span_pair_comm, Ideal.span_pair_zero]
    exact hprincipal
  apply mem_span_F_rename_inr_of_projective_vanishing
    hQ haq hbq hpairPrime
  intro x y hx hy _hzero hHy
  obtain ⟨a, hxa⟩ : ∃ a : Fin 3, x a ≠ 0 := by
    by_contra hnone
    apply hx
    funext a
    by_contra hxa
    exact hnone ⟨a, hxa⟩
  obtain ⟨b, hyb⟩ : ∃ b : Fin 3, y b ≠ 0 := by
    by_contra hnone
    apply hy
    funext b
    by_contra hyb
    exact hnone ⟨b, hyb⟩
  let xn : Fin 3 → K := fun i ↦ (x a)⁻¹ * x i
  let yn : Fin 3 → K := fun j ↦ (y b)⁻¹ * y j
  have hxna : xn a = 1 := by simp [xn, hxa]
  have hynb : yn b = 1 := by simp [yn, hyb]
  have hchartH :
      eval (affineCoords y b hyb)
          (ProjectiveSpace.chartDehomogenization 2 K b H) = 0 :=
    eval_chartDehomogenization_eq_zero_of
      H d hH y b hyb hHy
  have hbnonunit :
      ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 K b H) := by
    intro hunit
    have hmapped := hunit.map (eval (affineCoords y b hyb))
    rw [hchartH] at hmapped
    exact not_isUnit_zero hmapped
  have hrestricted := hzero a b hbnonunit
  have hmapped := congrArg
    (map (targetRelationBaseChartEval H hH y b hyb hHy)) hrestricted
  have heval := congrArg (eval (affineCoords x a hxa)) hmapped
  simp only [map_zero] at heval
  have haffzero :
      eval
          (Sum.elim (affineCoords x a hxa)
            (affineCoords y b hyb))
          (affineChartEquation 2 2 K a b Q) = 0 := by
    rw [← eval_map_targetRelationBaseChartEval_affineChartToTargetRelationBase
      H hH y b hyb hHy]
    exact heval
  have haffpoint :
      affineChartPoint a b xn yn =
        Sum.elim (affineCoords x a hxa)
          (affineCoords y b hyb) := by
    funext z
    rcases z with r | s
    · simp [affineChartPoint, affineCoords, xn, mul_comm]
    · simp [affineChartPoint, affineCoords, yn, mul_comm]
  have hnormalized : eval (Sum.elim xn yn) Q = 0 := by
    rw [← eval_affineChartEquation_affineChartPoint
      2 2 K a b xn yn hxna hynb Q]
    rw [haffpoint]
    exact haffzero
  have hxrecover : (fun i ↦ x a * xn i) = x := by
    funext i
    simp [xn, hxa]
  have hyrecover : (fun j ↦ y b * yn j) = y := by
    funext j
    simp [yn, hyb]
  have hscale := hQ.eval_smul_both (x a) (y b) xn yn
  rw [hxrecover, hyrecover, hnormalized, mul_zero] at hscale
  exact hscale

end BiprojectiveSpace

end

end BConicBundleMultisections

end
