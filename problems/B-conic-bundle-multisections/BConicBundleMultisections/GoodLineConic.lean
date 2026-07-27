/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GoodLineCondition
public import BConicBundleMultisections.PlaneCubicResidualTransport
public import BConicBundleMultisections.ResidualEquationLine
public import BConicBundleMultisections.AlgebraicIndependenceJacobian
public import BConicBundleMultisections.BiprojectiveSmoothBaseChange

/-!
# The conic discriminant along an arbitrary line

The source proof chooses a line `L` and only afterwards puts it in the coordinate position
`{Y₂ = 0}`.  `GoodLineCondition` proves nonvanishing of the generic-conic discriminant only in
that coordinate position.  This file introduces the corresponding polynomial for the line
parametrised by `p₀ + t q₀` and records the exact polynomial transport to the coordinate-line
construction.

No scheme-level invariance of smoothness is asserted here.  The transport theorem below assumes
smoothness of the substituted equation explicitly; removing that extra instance requires an
isomorphism (or a Jacobian-criterion transport) for the biprojective zero locus.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial
open scoped Matrix

variable {k : Type u} [Field k]

/-! ### Bidegree and invertibility of second-block substitution -/

/-- Weighted-homogeneous substitution by forms of the same weights preserves weighted degree. -/
private theorem IsWeightedHomogeneous.aeval_sameWeight
    {R : Type u} [CommSemiring R] {σ : Type*} {w : σ → ℕ × ℕ}
    {P : MvPolynomial σ R} {d : ℕ × ℕ}
    (hP : P.IsWeightedHomogeneous w d) (g : σ → MvPolynomial σ R)
    (hg : ∀ i, (g i).IsWeightedHomogeneous w (w i)) :
    (aeval g P).IsWeightedHomogeneous w d := by
  rw [aeval_def]
  apply IsWeightedHomogeneous.sum
  intro s hs
  rw [← zero_add d]
  apply (isWeightedHomogeneous_C w _).mul
  convert IsWeightedHomogeneous.prod s.support (fun i => g i ^ s i)
      (fun i => s i • w i) (fun i _ => (hg i).pow (s i)) using 1
  · simp only [Finsupp.prod]
  · rw [← hP (mem_support_iff.mp hs), Finsupp.weight_apply]
    simp only [Finsupp.sum]

/-- A linear substitution inside the second block preserves the bidegree. -/
theorem isBidegree23_secondBlockSubst
    (M : Matrix (Fin 3) (Fin 3) k)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) k} (hF : IsBidegree23 F) :
    IsBidegree23 (secondBlockSubst M F) := by
  unfold secondBlockSubst
  apply IsWeightedHomogeneous.aeval_sameWeight hF
  rintro (i | j)
  · exact isWeightedHomogeneous_X k
      (bidegreeWeight : BiprojectiveCoordinate 2 2 → ℕ × ℕ) (.inl i)
  · refine IsWeightedHomogeneous.sum Finset.univ _ _ fun l _ => ?_
    simpa [bidegreeWeight] using
      (isWeightedHomogeneous_C bidegreeWeight (M j l)).mul
        (isWeightedHomogeneous_X k bidegreeWeight (.inr l))

/-- Composing two second-block substitutions multiplies their matrices in the expected order. -/
theorem secondBlockSubst_secondBlockSubst
    (M N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    secondBlockSubst N (secondBlockSubst M F) = secondBlockSubst (M * N) F := by
  classical
  suffices h : (secondBlockSubst N).comp (secondBlockSubst M) = secondBlockSubst (M * N) from
    DFunLike.congr_fun h F
  refine MvPolynomial.algHom_ext fun z => ?_
  rcases z with i | j
  · simp
  · have hC (a : k) : secondBlockSubst N (C a) = C a := by simp [secondBlockSubst]
    simp only [AlgHom.comp_apply, secondBlockSubst_X_inr, map_sum, map_mul, hC]
    have hentry (a : Fin 3) :
        (C ((M * N) j a) : MvPolynomial (BiprojectiveCoordinate 2 2) k) =
          ∑ l : Fin 3, C (M j l) * C (N l a) := by
      rw [Matrix.mul_apply, map_sum]
      exact Finset.sum_congr rfl fun l _ => by rw [map_mul]
    simp_rw [hentry]
    simp_rw [Finset.mul_sum]
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun a _ => ?_
    rw [Finset.sum_mul]
    exact Finset.sum_congr rfl fun l _ => by simp [mul_assoc]

/-- An invertible second-block substitution cannot kill a nonzero equation. -/
theorem secondBlockSubst_ne_zero_of_inverse
    (M N : Matrix (Fin 3) (Fin 3) k) (hMN : M * N = 1)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) k} (hF0 : F ≠ 0) :
    secondBlockSubst M F ≠ 0 := by
  intro hzero
  have h := congrArg (secondBlockSubst N) hzero
  rw [map_zero, secondBlockSubst_secondBlockSubst, hMN, secondBlockSubst_one,
    AlgHom.id_apply] at h
  exact hF0 h

/-- A second-block substitution commutes with differentiation in the first block. -/
theorem pderiv_inl_secondBlockSubst
    (M : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3) :
    pderiv (.inl i) (secondBlockSubst M F) =
      secondBlockSubst M (pderiv (.inl i) F) := by
  classical
  rw [secondBlockSubst, pderiv_aeval, Fintype.sum_sum_type]
  simp [Pi.single_apply]

/-- The second-block gradient transforms by the transpose matrix. -/
theorem pderiv_inr_secondBlockSubst
    (M : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3) :
    pderiv (.inr i) (secondBlockSubst M F) =
      ∑ a : Fin 3, secondBlockSubst M (pderiv (.inr a) F) * C (M a i) := by
  classical
  rw [secondBlockSubst, pderiv_aeval, Fintype.sum_sum_type]
  simp [Pi.single_apply]

/-- Evaluation under rescaling of the first homogeneous-coordinate block. -/
private theorem eval_smul_first_bidegree
    {d e : ℕ} {G : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    (hG : IsBihomogeneousOfBidegree d e G) (a : k) (x y : Fin 3 → k) :
    eval (Sum.elim (fun i => a * x i) y) G =
      a ^ d * eval (Sum.elim x y) G := by
  have hx : (fun i => a * x i) = (a • x : Fin 3 → k) := by
    funext i
    simp [Pi.smul_apply, smul_eq_mul]
  have h := congrArg (eval y) (hG.specializeFirstCoordinates_smul a x)
  rw [eval_specializeFirstCoordinates, map_mul, eval_C,
    eval_specializeFirstCoordinates] at h
  rw [hx, h]

/-- Evaluation under rescaling of the second homogeneous-coordinate block. -/
private theorem eval_smul_second_bidegree
    {d e : ℕ} {G : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    (hG : IsBihomogeneousOfBidegree d e G) (b : k) (x y : Fin 3 → k) :
    eval (Sum.elim x (fun j => b * y j)) G =
      b ^ e * eval (Sum.elim x y) G := by
  have hy : (fun j => b * y j) = (b • y : Fin 3 → k) := by
    funext j
    simp [Pi.smul_apply, smul_eq_mul]
  have h := congrArg (eval x) (hG.specializeSecondCoordinates_smul b y)
  rw [eval_specializeSecondCoordinates, map_mul, eval_C,
    eval_specializeSecondCoordinates] at h
  rw [hy, h]

/-- Evaluation under independent rescaling of both homogeneous-coordinate blocks. -/
private theorem eval_smul_both_bidegree
    {d e : ℕ} {G : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    (hG : IsBihomogeneousOfBidegree d e G) (a b : k) (x y : Fin 3 → k) :
    eval (Sum.elim (fun i => a * x i) (fun j => b * y j)) G =
      a ^ d * b ^ e * eval (Sum.elim x y) G := by
  rw [eval_smul_second_bidegree hG b (fun i => a * x i) y,
    eval_smul_first_bidegree hG a x y]
  ring

/-- The discriminant of the generic conic over the line `p₀ + t q₀`. -/
def lineConicDiscriminant (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Polynomial k :=
  (polarMatrix (lineSpecializedConicPoly p₀ q₀ F)).det

/-- The new discriminant specializes to the old one on the coordinate line. -/
@[simp] theorem lineConicDiscriminant_coordinate
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    lineConicDiscriminant ![1, 0, 0] ![0, 1, 0] F = coordinateLineConicDiscriminant F := by
  rw [lineConicDiscriminant, coordinateLineConicDiscriminant,
    ← coordinateLineSpecializedConicPoly_eq]

/-! ### Polynomial transport into the frame of the line -/

/-- Specializing the second block after carrying it into the frame of `L` is specializing the
original equation along `L`.  This is purely a polynomial identity. -/
theorem lineSpecializedConicPoly_eq_coordinateLine_secondBlockSubst
    (p₀ q₀ r : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    lineSpecializedConicPoly p₀ q₀ F =
      coordinateLineSpecializedConicPoly (secondBlockSubst (lineFrame p₀ q₀ r) F) := by
  classical
  let φ : MvPolynomial (BiprojectiveCoordinate 2 2) k →+*
      MvPolynomial (Fin 3) (Polynomial k) :=
    (specializeSecondCoordinates (m := 2)
      (linePointOf (fun a => Polynomial.C (p₀ a)) (fun a => Polynomial.C (q₀ a))
        Polynomial.X)).toRingHom.comp (map (Polynomial.C : k →+* Polynomial k))
  let ψ : MvPolynomial (BiprojectiveCoordinate 2 2) k →+*
      MvPolynomial (Fin 3) (Polynomial k) :=
    ((specializeSecondCoordinates (m := 2)
      (coordinateLinePoint (Polynomial k) Polynomial.X)).toRingHom.comp
        (map (Polynomial.C : k →+* Polynomial k))).comp
      (secondBlockSubst (lineFrame p₀ q₀ r)).toRingHom
  change φ F = ψ F
  have hφψ : φ = ψ := by
    refine MvPolynomial.ringHom_ext (fun a => ?_) (fun z => ?_)
    · simp [φ, ψ]
    · rcases z with i | j
      · simp [φ, ψ]
      · simp [φ, ψ, secondBlockSubst_X_inr, linePointOf, coordinateLinePoint,
          lineFrame, Fin.sum_univ_three]
  rw [hφψ]

/-- Consequently the arbitrary-line discriminant is the coordinate-line discriminant of the
equation carried into the frame of the line. -/
theorem lineConicDiscriminant_eq_coordinateLine_secondBlockSubst
    (p₀ q₀ r : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    lineConicDiscriminant p₀ q₀ F =
      coordinateLineConicDiscriminant (secondBlockSubst (lineFrame p₀ q₀ r) F) := by
  rw [lineConicDiscriminant, coordinateLineConicDiscriminant,
    lineSpecializedConicPoly_eq_coordinateLine_secondBlockSubst]

/-! ### The Tsen section from a nonzero arbitrary-line discriminant -/

/-- Isotropy in the matrix form used by Tsen is evaluation on the arbitrary-line conic. -/
theorem ternaryQuadraticPoly_eval_line
    (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) :
    TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v =
      eval v (lineSpecializedConicPoly p₀ q₀ F) := by
  rw [eval_eq_ternaryQuadraticCoeff_sum (lineSpecializedConicPoly_isHomogeneous p₀ q₀ hF)]
  rfl

/-- A nonzero polar against `e₀` or `e₁` remains nonzero after passage from `k[t]` to the
affine-plane ring and pairing with the stereo direction `(1,s,0)`. -/
theorem polarEval_lineStereoDir_ne_zero_of_polarEval_ne_zero [Infinite k]
    (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (h : polarEval (lineSpecializedConicPoly p₀ q₀ F) v (Pi.single 0 1) ≠ 0 ∨
      polarEval (lineSpecializedConicPoly p₀ q₀ F) v (Pi.single 1 1) ≠ 0) :
    polarEval (lineSpecializedConicPullback p₀ q₀ F)
      (liftTsenSection v) affineTwoStereoDir ≠ 0 := by
  classical
  set Q := lineSpecializedConicPoly p₀ q₀ F with hQdef
  set φ := (liftPolyTHom : Polynomial k →+* affineTwoRing k) with hφ
  have hQhom : Q.IsHomogeneous 2 := lineSpecializedConicPoly_isHomogeneous p₀ q₀ hF
  have hpull : lineSpecializedConicPullback p₀ q₀ F = map φ Q := by
    simpa [Q, φ] using lineSpecializedConicPullback_eq_map p₀ q₀ F
  have hlift : liftTsenSection v = fun i => φ (v i) := rfl
  have hdir : (affineTwoStereoDir : Fin 3 → affineTwoRing k) =
      fun i => 1 * (fun j => φ ((Pi.single 0 1 : Fin 3 → Polynomial k) j)) i +
        affineTwoCoord1 k * (fun j => φ ((Pi.single 1 1 : Fin 3 → Polynomial k) j)) i := by
    funext i
    fin_cases i <;> simp [affineTwoStereoDir, hφ, liftPolyTHom]
  have hexp :
      polarEval (lineSpecializedConicPullback p₀ q₀ F)
          (liftTsenSection v) affineTwoStereoDir =
        φ (polarEval Q v (Pi.single 0 1)) +
          affineTwoCoord1 k * φ (polarEval Q v (Pi.single 1 1)) := by
    rw [hpull, hlift, hdir, polarEval_linear_right (Q := map φ Q) (hQhom.map φ),
      polarEval_map, polarEval_map, one_mul]
  rw [hexp]
  intro hzero
  have hval : ∀ t₀ s₀ : k,
      Polynomial.eval t₀ (polarEval Q v (Pi.single 0 1)) +
        s₀ * Polynomial.eval t₀ (polarEval Q v (Pi.single 1 1)) = 0 := by
    intro t₀ s₀
    have hs1 : evalAffineTwoPoint t₀ s₀ (affineTwoCoord1 k) = s₀ := by
      simp [evalAffineTwoPoint, affineTwoCoord1]
    have hz := congrArg (evalAffineTwoPoint t₀ s₀) hzero
    simpa [hφ, map_add, map_mul, ← liftPolyT_eq_hom, evalAffineTwoPoint_liftPolyT, hs1]
      using hz
  have h0 : polarEval Q v (Pi.single 0 1) = 0 := by
    refine Polynomial.funext fun t₀ => ?_
    simpa using hval t₀ 0
  have h1 : polarEval Q v (Pi.single 1 1) = 0 := by
    refine Polynomial.funext fun t₀ => ?_
    have hz := hval t₀ 1
    rw [h0] at hz
    simpa using hz
  rcases h with h | h
  · exact h (by simpa [Q] using h0)
  · exact h (by simpa [Q] using h1)

/-! ### Smoothness transport for an invertible line frame -/

/-- Second-block linear substitution commutes with a change of coefficient ring. -/
theorem secondBlockSubst_map
    {R S : Type u} [CommRing R] [CommRing S] (φ : R →+* S)
    (M : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    MvPolynomial.map φ (secondBlockSubst M F) = secondBlockSubst (M.map φ) (MvPolynomial.map φ F) := by
  induction F using MvPolynomial.induction_on with
  | C a => simp [secondBlockSubst]
  | add P Q hP hQ => simp [map_add, hP, hQ]
  | mul_X P z hP =>
      cases z with
      | inl i => simp [map_mul, hP]
      | inr j =>
          simp only [map_mul, hP, secondBlockSubst_X_inr, map_sum, map_C, map_X,
            Matrix.map_apply]

/-- Smoothness of a nonzero bihomogeneous hypersurface gives the global Cox-coordinate Jacobian
condition: a common zero of the equation and all partials lies in one of the two irrelevant
coordinate subspaces. -/
theorem gradient_condition_of_smooth
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∀ x y : Fin 3 → k,
      eval (Sum.elim x y) F = 0 →
      (∀ z : BiprojectiveCoordinate 2 2, eval (Sum.elim x y) (pderiv z F) = 0) →
      x = 0 ∨ y = 0 := by
  classical
  intro x y hFxy hgrad
  by_cases hx : x = 0
  · exact Or.inl hx
  by_cases hy : y = 0
  · exact Or.inr hy
  exfalso
  obtain ⟨i, hi⟩ : ∃ i : Fin 3, x i ≠ 0 := by
    by_contra h
    push Not at h
    exact hx (funext h)
  obtain ⟨j, hj⟩ : ∃ j : Fin 3, y j ≠ 0 := by
    by_contra h
    push Not at h
    exact hy (funext h)
  set a : k := (x i)⁻¹
  set b : k := (y j)⁻¹
  set x₁ : Fin 3 → k := fun l => a * x l
  set y₁ : Fin 3 → k := fun l => b * y l
  have hxi : x₁ i = 1 := by simp [x₁, a, hi]
  have hyj : y₁ j = 1 := by simp [y₁, b, hj]
  have hF₁ : eval (Sum.elim x₁ y₁) F = 0 := by
    have h := eval_smul_both_bidegree hF a b x y
    simpa [x₁, y₁, hFxy] using h
  have hchart : affineChartEquation 2 2 k i j F ≠ 0 :=
    BiprojectiveSpace.affineChartEquation_ne_zero 2 2 k i j F hF hF0
  obtain ⟨z, hz⟩ :=
    BiprojectiveSpace.exists_pderiv_ne_zero_of_smooth
      2 2 k F hF i j hchart x₁ y₁ hxi hyj hF₁
  apply hz
  rcases z with l | l
  · have hp : IsBihomogeneousOfBidegree 1 3 (pderiv (.inl l) F) :=
      hF.pderiv_inl (by decide) l
    have h := eval_smul_both_bidegree hp a b x y
    simpa [x₁, y₁, hgrad (.inl l)] using h
  · have hp : IsBihomogeneousOfBidegree 2 2 (pderiv (.inr l) F) :=
      hF.pderiv_inr (by decide) l
    have h := eval_smul_both_bidegree hp a b x y
    simpa [x₁, y₁, hgrad (.inr l)] using h

/-- An invertible linear change in the second projective block preserves smoothness of the
biprojective hypersurface.  The proof uses the homogeneous Jacobian criterion, so no unproved
scheme-level invariance is hidden here. -/
theorem smooth_secondBlockSubst_of_smooth
    (M N : Matrix (Fin 3) (Fin 3) k) (hMN : M * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    Smooth (biprojectiveZeroLocusToSpec 2 2 k (secondBlockSubst M F)) := by
  classical
  have hFM : IsBidegree23 (secondBlockSubst M F) := isBidegree23_secondBlockSubst M hF
  set φ : k →+* AlgebraicClosure k := algebraMap k (AlgebraicClosure k) with hφ
  refine BiprojectiveSpace.smooth_biprojectiveZeroLocusToSpec_of_gradient_of_geometric
    (L := AlgebraicClosure k) 2 2 k (secondBlockSubst M F) hFM ?_
  intro x y hzero hgrad
  rw [secondBlockSubst_map φ M F] at hzero hgrad
  set M' : Matrix (Fin 3) (Fin 3) (AlgebraicClosure k) := M.map φ with hM'
  set N' : Matrix (Fin 3) (Fin 3) (AlgebraicClosure k) := N.map φ with hN'
  have hMN' : M' * N' = 1 := by
    rw [hM', hN', ← Matrix.map_mul, hMN]
    ext a b
    by_cases hab : a = b <;> simp [Matrix.one_apply, hab]
  have hzeroF : eval (Sum.elim x (M' *ᵥ y)) (MvPolynomial.map φ F) = 0 := by
    rw [← eval_secondBlockSubst]
    exact hzero
  have hxinl (i : Fin 3) :
      eval (Sum.elim x (M' *ᵥ y)) (pderiv (.inl i) (MvPolynomial.map φ F)) = 0 := by
    have h := hgrad (.inl i)
    rw [pderiv_inl_secondBlockSubst, eval_secondBlockSubst] at h
    exact h
  set w : Fin 3 → AlgebraicClosure k :=
    fun a => eval (Sum.elim x (M' *ᵥ y)) (pderiv (.inr a) (MvPolynomial.map φ F))
  have hMtw : M'ᵀ *ᵥ w = 0 := by
    funext i
    have h := hgrad (.inr i)
    rw [pderiv_inr_secondBlockSubst, map_sum] at h
    simpa [Matrix.mulVec, dotProduct, w, eval_secondBlockSubst, mul_comm] using h
  have htrans : N'ᵀ * M'ᵀ = 1 := by
    rw [← Matrix.transpose_mul, hMN', Matrix.transpose_one]
  have hw : w = 0 := by
    have h := congrArg (fun v => N'ᵀ *ᵥ v) hMtw
    rwa [Matrix.mulVec_mulVec, htrans, Matrix.one_mulVec, Matrix.mulVec_zero] at h
  have hyinr (a : Fin 3) :
      eval (Sum.elim x (M' *ᵥ y)) (pderiv (.inr a) (MvPolynomial.map φ F)) = 0 := by
    simpa [w] using congrFun hw a
  have hgradF : ∀ z : BiprojectiveCoordinate 2 2,
      eval (Sum.elim x (M' *ᵥ y)) (pderiv z (MvPolynomial.map φ F)) = 0 := by
    rintro (i | a)
    · exact hxinl i
    · exact hyinr a
  rcases BiprojectiveSpace.gradient_condition_of_smooth_of_geometric
    (L := AlgebraicClosure k) 2 2 k F hF hF0 (by norm_num) (by norm_num)
    x (M' *ᵥ y) hzeroF hgradF with hx | hMy
  · exact Or.inl hx
  · right
    have hNM : N' * M' = 1 := mul_eq_one_comm.mp hMN'
    have h := congrArg (fun v => N' *ᵥ v) hMy
    rwa [Matrix.mulVec_mulVec, hNM, Matrix.one_mulVec, Matrix.mulVec_zero] at h

/-- A nonzero arbitrary-line discriminant gives a polynomial Tsen section which is isotropic,
lies off `{x₂ = 0}`, and is nondegenerate for the stereo pencil. -/
theorem exists_isotropic_line_stereoNondegenerate_of_disc_ne_zero [IsAlgClosed k]
    (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hdisc : lineConicDiscriminant p₀ q₀ F ≠ 0) :
    ∃ v : Fin 3 → Polynomial k, v ≠ 0 ∧
      TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0 ∧
      v 2 ≠ 0 ∧
      polarEval (lineSpecializedConicPullback p₀ q₀ F)
        (liftTsenSection v) affineTwoStereoDir ≠ 0 := by
  classical
  obtain ⟨v₀, hv₀0, hv₀⟩ := exists_isotropic_line_conic k p₀ q₀ F
  have hQhom : (lineSpecializedConicPoly p₀ q₀ F).IsHomogeneous 2 :=
    lineSpecializedConicPoly_isHomogeneous p₀ q₀ hF
  have hv₀' : eval v₀ (lineSpecializedConicPoly p₀ q₀ F) = 0 := by
    rw [← ternaryQuadraticPoly_eval_line p₀ q₀ F hF]
    exact hv₀
  obtain ⟨v, hv0, hviso, hv2, hvpolar⟩ :=
    exists_isotropic_polarEval_ne_zero hQhom hdisc hv₀0 hv₀'
  refine ⟨v, hv0, ?_, hv2,
    polarEval_lineStereoDir_ne_zero_of_polarEval_ne_zero p₀ q₀ F hF v hvpolar⟩
  rw [ternaryQuadraticPoly_eval_line p₀ q₀ F hF]
  exact hviso

variable [NeZero (2 : k)] [NeZero (3 : k)]

/-- The arbitrary-line nonvanishing theorem once smoothness of the equation transported into the
line frame has been supplied.  This statement deliberately keeps that scheme-level transport
visible rather than silently assuming it. -/
theorem lineConicDiscriminant_ne_zero_of_smooth_secondBlockSubst
    (p₀ q₀ r : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hFM : IsBidegree23 (secondBlockSubst (lineFrame p₀ q₀ r) F))
    (hFM0 : secondBlockSubst (lineFrame p₀ q₀ r) F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k
      (secondBlockSubst (lineFrame p₀ q₀ r) F))] :
    lineConicDiscriminant p₀ q₀ F ≠ 0 := by
  rw [lineConicDiscriminant_eq_coordinateLine_secondBlockSubst]
  exact coordinateLineConicDiscriminant_ne_zero_of_smooth _ hFM hFM0

/-- **The generic conic along every genuine line is smooth.**

For an invertible frame with first two columns `p₀,q₀`, smoothness of the original total
`(2,3)` hypersurface forces the arbitrary-line conic discriminant to be nonzero.  The proof
transports the total equation by the frame, proves smoothness of that transformed equation by the
Jacobian criterion, and then applies the coordinate-line theorem. -/
theorem lineConicDiscriminant_ne_zero_of_smooth
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    lineConicDiscriminant p₀ q₀ F ≠ 0 := by
  letI : Smooth (biprojectiveZeroLocusToSpec 2 2 k
      (secondBlockSubst (lineFrame p₀ q₀ r) F)) :=
    smooth_secondBlockSubst_of_smooth (lineFrame p₀ q₀ r) N hMN F hF hF0
  exact lineConicDiscriminant_ne_zero_of_smooth_secondBlockSubst p₀ q₀ r F
    (isBidegree23_secondBlockSubst _ hF)
    (secondBlockSubst_ne_zero_of_inverse _ N hMN hF0)

/-- The chosen arbitrary-line Tsen section, with all stereo nondegeneracy properties, follows
unconditionally from smoothness of the total hypersurface and invertibility of the line frame. -/
theorem exists_isotropic_line_stereoNondegenerate_of_smooth [IsAlgClosed k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ v : Fin 3 → Polynomial k, v ≠ 0 ∧
      TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0 ∧
      v 2 ≠ 0 ∧
      polarEval (lineSpecializedConicPullback p₀ q₀ F)
        (liftTsenSection v) affineTwoStereoDir ≠ 0 :=
  exists_isotropic_line_stereoNondegenerate_of_disc_ne_zero p₀ q₀ F hF
    (lineConicDiscriminant_ne_zero_of_smooth p₀ q₀ r N hMN F hF hF0)

end

end BConicBundleMultisections
