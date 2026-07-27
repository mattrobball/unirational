/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.G4StereoCertificateOpenness
public import BConicBundleMultisections.Standard.SmoothCubicPrincipalOpens
public import BConicBundleMultisections.ResidualDiscriminantGenericConic

/-!
# The nonsingular common-line boundary for G3 and G4

The tangent direction used by the residual construction is `frameTangentDir`; it is separate from
the direction spanning the chosen vertical line.  This file therefore states pointwise G4 for an
arbitrary invertibly framed line, rather than requiring the vertical line itself to be tangent to
the selected cubic fibre.

Everything after selection of the frame is proved here.  The remaining selection input is isolated
as a principal-open intersection on the irreducible variety of invertible `3 x 3` frames: the G3
minor is a nonempty open in frame space, while the first-column conditions form another nonempty
open.  This is the faithful incidence argument behind the informal phrase "choose a sufficiently
general line through the point".
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open CategoryTheory Topology TopologicalSpace ProjectiveSpace
open _root_.MvPolynomial
open scoped Matrix

attribute [local instance] MvPolynomial.gradedAlgebra

set_option backward.isDefEq.respectTransparency false

/-- Multiplying a cubic equation by a scalar multiplies its frame-defined tangent direction by
the same scalar. -/
theorem frameTangentDir_C_mul
    {K : Type u} [Field K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    (G : MvPolynomial (Fin 3) K) (p : Fin 3 → K) (c : K) :
    frameTangentDir M N (C c * G) p =
      fun i ↦ c * frameTangentDir M N G p i := by
  unfold frameTangentDir complementaryTangentDir tangentGradient
  funext i
  simp only [map_mul, Matrix.mulVec, dotProduct, Finset.mul_sum]
  fin_cases i <;> simp [Fin.sum_univ_three, cross3] <;> ring

/-- The direction defined from an invertible frame belongs to the tangent hyperplane at the
frame's first point. -/
theorem frameTangentDir_mem_tangentHyperplaneCone
    {K : Type u} [Field K]
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (G : MvPolynomial (Fin 3) K) :
    frameTangentDir (lineFrame p q r) N G p ∈ tangentHyperplaneCone G p := by
  let M := lineFrame p q r
  let z : Fin 3 → K := ![1, 0, 0]
  let Gb :=
    (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) G
  have hNp : Matrix.mulVec N p = z := by
    simpa [z] using mulVec_inverse_linePointOf p q r N hMN 0
  have hMp : Matrix.mulVec M (Matrix.mulVec N p) = p := by
    rw [Matrix.mulVec_mulVec, hMN, Matrix.one_mulVec]
  have hgrad : tangentGradient Gb (Matrix.mulVec N p) =
      Matrix.mulVec M.transpose (tangentGradient G p) := by
    have h := gradient_aeval_linearSubst 2 M G (Matrix.mulVec N p)
    rw [hMp] at h
    exact h
  rw [mem_tangentHyperplaneCone, eval_tangentForm_eq_dotProduct]
  change tangentGradient G p ⬝ᵥ
      (Matrix.mulVec M (complementaryTangentDir Gb (Matrix.mulVec N p))) = 0
  calc
    _ = complementaryTangentDir Gb (Matrix.mulVec N p) ⬝ᵥ
        Matrix.mulVec M.transpose (tangentGradient G p) := by
      simpa using Matrix.dotProduct_transpose_mulVec
        (A := M.transpose) (x := tangentGradient G p)
        (y := complementaryTangentDir Gb (Matrix.mulVec N p))
    _ = complementaryTangentDir Gb (Matrix.mulVec N p) ⬝ᵥ
        tangentGradient Gb (Matrix.mulVec N p) := by rw [hgrad]
    _ = 0 := by
      rw [dotProduct_comm]
      exact dot_cross3_right (Matrix.mulVec N p) (tangentGradient Gb (Matrix.mulVec N p))

/-- At a smooth cubic point, the base point and its frame-defined tangent direction are linearly
independent. -/
theorem linearIndependent_pair_frameTangentDir_of_isSmoothPlaneCubic
    {K : Type u} [Field K]
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (G : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic G)
    (hp : eval p G = 0) :
    LinearIndependent K
      ![p, frameTangentDir (lineFrame p q r) N G p] := by
  let M := lineFrame p q r
  let z : Fin 3 → K := ![1, 0, 0]
  let Gb :=
    (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) G
  let dₑ := complementaryTangentDir Gb z
  have hNp : Matrix.mulVec N p = z := by
    simpa [z] using mulVec_inverse_linePointOf p q r N hMN 0
  have hMz : Matrix.mulVec M z = p := by
    simp [M, z]
  have hzGb : eval z Gb = 0 := by
    change eval z
      ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) G) = 0
    rw [eval_aeval_linearSubst, hMz, hp]
  have hsmoothGb : IsSmoothPlaneCubic Gb :=
    isSmoothPlaneCubicSubstInvariant K M N hMN G hsmooth
  have hzsingle : z = Pi.single (0 : Fin 3) 1 := by
    funext j
    fin_cases j <;> simp [z]
  have hzdₑ : LinearIndependent K ![z, dₑ] := by
    simpa [dₑ, hzsingle, chartTangentDir, complementaryTangentDir] using
      linearIndependent_pair_chartTangentDir_of_isSmoothPlaneCubic
        (0 : Fin 3) Gb hsmoothGb z hzGb (by simp [z])
  have hNM : N * M = 1 := mul_eq_one_comm.mp hMN
  have hNd : Matrix.mulVec N
      (frameTangentDir (lineFrame p q r) N G p) = dₑ := by
    rw [frameTangentDir, hNp, Matrix.mulVec_mulVec, hNM, Matrix.one_mulVec]
  rw [LinearIndependent.pair_iff]
  intro a b hab
  have hab' := congrArg (Matrix.mulVec N) hab
  simp only [Matrix.mulVec_add, Matrix.mulVec_smul, Matrix.mulVec_zero, hNp, hNd] at hab'
  exact (LinearIndependent.pair_iff.mp hzdₑ) a b hab'

/-- Avoidance computed with a polynomial chart tangent direction transfers back to the exact
frame-defined tangent direction used by `residualYCoordsOn`. -/
theorem eval_frameTangentResidual_ne_zero_of_chartTangent
    {K : Type u} [Field K]
    (i : Fin 3)
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (G : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic G)
    (hp : eval p G = 0) (hpi : p i ≠ 0)
    (H : MvPolynomial (Fin 3) K) {e : ℕ} (hH : H.IsHomogeneous e)
    (havoid : eval
      (residualAmbientRep p (chartTangentDir i G p)
        (binaryLineRestriction p (chartTangentDir i G p) G)) H ≠ 0) :
    eval
      (residualAmbientRep p
        (frameTangentDir (lineFrame p q r) N G p)
        (binaryLineRestriction p
          (frameTangentDir (lineFrame p q r) N G p) G)) H ≠ 0 := by
  let d := frameTangentDir (lineFrame p q r) N G p
  have hpd : LinearIndependent K ![p, d] :=
    linearIndependent_pair_frameTangentDir_of_isSmoothPlaneCubic
      p q r N hMN G hsmooth hp
  have hdmem : d ∈ tangentHyperplaneCone G p :=
    frameTangentDir_mem_tangentHyperplaneCone p q r N hMN G
  obtain ⟨alpha, beta, halpha, hdir⟩ :=
    exists_chartTangentDir_eq_reparam_of_isSmoothPlaneCubic
      i G hsmooth p d hp hpi hpd hdmem
  let f := binaryLineRestriction p d G
  have hfhom : f.IsHomogeneous 3 := binaryLineRestriction_isHomogeneous hsmooth.1 p d
  obtain ⟨h30, h21⟩ :=
    coeff_binaryLineRestriction_double_contact G hsmooth.1 p d hp hdmem
  have hres :
      residualAmbientRep p (chartTangentDir i G p)
          (binaryLineRestriction p (chartTangentDir i G p) G) =
        fun j ↦ alpha ^ 3 * residualAmbientRep p d f j := by
    rw [hdir, binaryLineRestriction_reparam]
    exact residualAmbientRep_reparam p d alpha beta f hfhom h30 h21
  rw [hres, eval_smul_point_of_isHomogeneous hH] at havoid
  exact (mul_ne_zero_iff.mp havoid).2

/-- Scaling a cubic equation by `c` scales its frame-tangent residual representative by `c⁴`.
The fourth power is the product of the scalar in the equation and the cubic dependence on the
tangent direction. -/
theorem frameTangentResidual_C_mul
    {K : Type u} [Field K]
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (hp : eval p G = 0) (c : K) :
    residualAmbientRep p
        (frameTangentDir (lineFrame p q r) N (C c * G) p)
        (binaryLineRestriction p
          (frameTangentDir (lineFrame p q r) N (C c * G) p) (C c * G)) =
      fun i ↦ c ^ 4 *
        residualAmbientRep p
          (frameTangentDir (lineFrame p q r) N G p)
          (binaryLineRestriction p
            (frameTangentDir (lineFrame p q r) N G p) G) i := by
  let d := frameTangentDir (lineFrame p q r) N G p
  let f := binaryLineRestriction p d G
  have hdmem : d ∈ tangentHyperplaneCone G p :=
    frameTangentDir_mem_tangentHyperplaneCone p q r N hMN G
  have hfhom : f.IsHomogeneous 3 := binaryLineRestriction_isHomogeneous hG p d
  obtain ⟨h30, h21⟩ := coeff_binaryLineRestriction_double_contact G hG p d hp hdmem
  have hdC : frameTangentDir (lineFrame p q r) N (C c * G) p =
      fun i ↦ c * d i + 0 * p i := by
    simpa [d] using
      frameTangentDir_C_mul (lineFrame p q r) N G p c
  rw [hdC, binaryLineRestriction_C_mul, residualAmbientRep_C_mul,
    binaryLineRestriction_reparam]
  rw [residualAmbientRep_reparam p d c 0 f hfhom h30 h21]
  funext i
  ring

/-- Consequently, avoidance of a homogeneous target is unchanged by a nonzero rescaling of the
cubic equation, without requiring the chosen vertical line itself to be tangent. -/
theorem eval_frameTangentResidual_C_mul_ne_zero
    {K : Type u} [Field K]
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (hp : eval p G = 0)
    (H : MvPolynomial (Fin 3) K) (d : ℕ) (hH : H.IsHomogeneous d)
    (havoid : eval
      (residualAmbientRep p (frameTangentDir (lineFrame p q r) N G p)
        (binaryLineRestriction p (frameTangentDir (lineFrame p q r) N G p) G)) H ≠ 0)
    (c : K) (hc : c ≠ 0) :
    eval
      (residualAmbientRep p
        (frameTangentDir (lineFrame p q r) N (C c * G) p)
        (binaryLineRestriction p
          (frameTangentDir (lineFrame p q r) N (C c * G) p) (C c * G))) H ≠ 0 := by
  rw [frameTangentResidual_C_mul p q r N hMN G hG hp c,
    eval_smul_point_of_isHomogeneous hH]
  exact mul_ne_zero (pow_ne_zero d (pow_ne_zero 4 hc)) havoid

/-- Avoiding the second-conic discriminant at the first point of a framed line makes the
specialized first-block conic nonsingular. -/
theorem lineSpecializedConic_zero_nonsingular_of_sndConicDiscriminant_ne_zero
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (p q : Fin 3 → K)
    (hdisc : eval p (sndConicDiscriminant F) ≠ 0) :
    ∀ y : Fin 3 → K, y ≠ 0 → eval y (lineSpecializedConic p q F 0) = 0 →
      ∃ i : Fin 3, eval y (pderiv i (lineSpecializedConic p q F 0)) ≠ 0 := by
  have hQhom : (lineSpecializedConic p q F 0).IsHomogeneous 2 :=
    lineSpecializedConic_isHomogeneous p q hF 0
  have hQ : lineSpecializedConic p q F 0 = sndConicAt F p := by
    have halg : algebraMap K K = RingHom.id K := by ext; simp
    rw [lineSpecializedConic, sndConicAt, halg, map_id]
    simp
  have hdet : (polarMatrix (lineSpecializedConic p q F 0)).det ≠ 0 := by
    rw [hQ, det_polarMatrix_sndConicAt]
    change eval p (sndConicDiscriminant F) ≠ 0
    exact hdisc
  intro y hy _hyQ
  exact exists_eval_pderiv_ne_zero_of_det_polarMatrix_ne_zero
    (lineSpecializedConic p q F 0) hQhom hdet y hy

/-! ## A proper G4 point in the fixed stereographic chart -/

/-- The proper-point theorem can be strengthened so that the smooth cubic parameter has nonzero
zeroth coordinate.  In the total-space proof, replace the smooth-fibre principal open `D` by the
still nonempty principal open `D * X₀` before intersecting it with the conic-discriminant open. -/
theorem exists_smoothCubicFiber_in_stereoChart_point_avoids_sndConicDiscriminant
    {K : Type u} [Field K] [IsAlgClosed K] [CharZero K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    ∃ x y : Fin 3 → K,
      x ≠ 0 ∧ y ≠ 0 ∧ x 0 ≠ 0 ∧
        IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F) ∧
        eval y (specializeFirstCoordinates (n := 2) x F) = 0 ∧
        eval y (sndConicDiscriminant F) ≠ 0 := by
  obtain ⟨D, d, hD0, hd, hDhom, _hDnonempty, hDsmooth⟩ :=
    exists_positive_homogeneous_smoothCubicFiber_open F hF hF0
  let A : MvPolynomial (Fin 3) K := D * X 0
  have hA0 : A ≠ 0 := mul_ne_zero hD0 (X_ne_zero (R := K) (0 : Fin 3))
  have hAhom : A.IsHomogeneous (d + 1) := by
    exact hDhom.mul (isHomogeneous_X K (0 : Fin 3))
  have hdA : 0 < d + 1 := by omega
  let Δ := sndConicDiscriminant F
  have hΔ0 : Δ ≠ 0 := sndConicDiscriminant_ne_zero_of_smooth F hF hF0
  have hΔhom : Δ.IsHomogeneous 9 := sndConicDiscriminant_isHomogeneous F hF
  let X := biprojectiveZeroLocus 2 2 K F
  let U : X.Opens := biprojectiveZeroLocusFst 2 2 K F ⁻¹ᵁ
    Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin 3) K) A
  let V : X.Opens := biprojectiveZeroLocusSnd 2 2 K F ⁻¹ᵁ
    Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin 3) K) Δ
  have hU : (U : Set X).Nonempty := by
    obtain ⟨x₀, hx₀A⟩ : ∃ x₀ : Fin 3 → K, eval x₀ A ≠ 0 := by
      by_contra h
      push Not at h
      exact hA0 (hAhom.eq_zero_of_forall_eval_eq_zero h)
    have hx₀0 : x₀ ≠ 0 := by
      intro hxzero
      subst x₀
      apply hx₀A
      have hscale := eval_smul_point_of_isHomogeneous hAhom (0 : K)
        (fun _ : Fin 3 ↦ (1 : K))
      simpa [zero_pow (by omega : d + 1 ≠ 0)] using hscale
    obtain ⟨i, hxi₀⟩ := exists_normalizing_coordinate x₀ hx₀0
    let x := normalizeCoordinateRepresentative x₀ i
    have hxi : x i = 1 := normalizeCoordinateRepresentative_apply x₀ i hxi₀
    have hxA : eval x A ≠ 0 := by
      rw [eval_normalizeCoordinateRepresentative_of_isHomogeneous hAhom]
      exact mul_ne_zero (pow_ne_zero (d + 1) (inv_ne_zero hxi₀)) hx₀A
    obtain ⟨y₀, hy₀0, hxy₀⟩ :=
      exists_lift_firstProjection_of_smooth_bidegree23 K F hF hF0 i x hxi
    obtain ⟨j, hyj₀⟩ := exists_normalizing_coordinate y₀ hy₀0
    let y := normalizeCoordinateRepresentative y₀ j
    have hyj : y j = 1 := normalizeCoordinateRepresentative_apply y₀ j hyj₀
    have hxy : eval (Sum.elim x y) F = 0 :=
      eval_normalize_second_eq_zero_of_isBihomogeneous hF x y₀ j hxy₀
    let pt := zeroLocusPointOfNormalized 2 2 K F hF i j x y hxi hyj hxy
    refine ⟨pt (IsLocalRing.closedPoint K), ?_⟩
    change (pt ≫ biprojectiveZeroLocusFst 2 2 K F)
      (IsLocalRing.closedPoint K) ∈
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin 3) K) A
    rw [zeroLocusPointOfNormalized_fst 2 2 K F hF i j x y hxi hyj hxy]
    exact (ProjectiveSpace.pointOfNormalizedCoordinates_mem_basicOpen_iff
      2 K i x hxi A (d + 1) hAhom hdA).mpr hxA
  have hV : (V : Set X).Nonempty := by
    obtain ⟨y₀, hy₀Δ⟩ : ∃ y₀ : Fin 3 → K, eval y₀ Δ ≠ 0 := by
      by_contra h
      push Not at h
      exact hΔ0 (hΔhom.eq_zero_of_forall_eval_eq_zero h)
    have hy₀0 : y₀ ≠ 0 := by
      intro hyzero
      subst y₀
      apply hy₀Δ
      have hscale := eval_smul_point_of_isHomogeneous hΔhom (0 : K)
        (fun _ : Fin 3 ↦ (1 : K))
      simpa using hscale
    obtain ⟨j, hyj₀⟩ := exists_normalizing_coordinate y₀ hy₀0
    let y := normalizeCoordinateRepresentative y₀ j
    have hyj : y j = 1 := normalizeCoordinateRepresentative_apply y₀ j hyj₀
    have hyΔ : eval y Δ ≠ 0 := by
      rw [eval_normalizeCoordinateRepresentative_of_isHomogeneous hΔhom]
      exact mul_ne_zero (pow_ne_zero 9 (inv_ne_zero hyj₀)) hy₀Δ
    obtain ⟨x₀, hx₀0, hxy₀⟩ :=
      exists_lift_secondProjection_of_smooth_bidegree23 K F hF hF0 j y hyj
    obtain ⟨i, hxi₀⟩ := exists_normalizing_coordinate x₀ hx₀0
    let x := normalizeCoordinateRepresentative x₀ i
    have hxi : x i = 1 := normalizeCoordinateRepresentative_apply x₀ i hxi₀
    have hxy : eval (Sum.elim x y) F = 0 :=
      eval_normalize_first_eq_zero_of_isBihomogeneous hF x₀ y i hxy₀
    let pt := zeroLocusPointOfNormalized 2 2 K F hF i j x y hxi hyj hxy
    refine ⟨pt (IsLocalRing.closedPoint K), ?_⟩
    change (pt ≫ biprojectiveZeroLocusSnd 2 2 K F)
      (IsLocalRing.closedPoint K) ∈
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin 3) K) Δ
    rw [zeroLocusPointOfNormalized_snd 2 2 K F hF i j x y hxi hyj hxy]
    exact (ProjectiveSpace.pointOfNormalizedCoordinates_mem_basicOpen_iff
      2 K j y hyj Δ 9 hΔhom (by omega)).mpr hyΔ
  letI : IsIntegral X :=
    isIntegral_biprojectiveZeroLocus_of_smooth_bidegree23 F hF hF0
  have hUV : ((U : Set X) ∩ (V : Set X)).Nonempty :=
    nonempty_preirreducible_inter U.isOpen V.isOpen hU hV
  letI : JacobsonSpace X :=
    LocallyOfFiniteType.jacobsonSpace (biprojectiveZeroLocusToSpec 2 2 K F)
  obtain ⟨z, hzUV, hzclosed⟩ := nonempty_inter_closedPoints hUV
    ((U.isOpen.inter V.isOpen).isLocallyClosed)
  obtain ⟨i, j, x, y, hxi, hyj, hxy, hxpoint, hypoint⟩ :=
    exists_normalized_coordinates_of_closedPoint_zeroLocus F hF z hzclosed
  have hxA : eval x A ≠ 0 := by
    apply (ProjectiveSpace.pointOfNormalizedCoordinates_mem_basicOpen_iff
      2 K i x hxi A (d + 1) hAhom hdA).mp
    rw [hxpoint]
    exact hzUV.1
  have hxD : eval x D ≠ 0 := by
    exact (mul_ne_zero_iff.mp (by simpa [A] using hxA)).1
  have hxcoord : x 0 ≠ 0 := by
    exact (mul_ne_zero_iff.mp (by simpa [A] using hxA)).2
  have hyΔ : eval y Δ ≠ 0 := by
    apply (ProjectiveSpace.pointOfNormalizedCoordinates_mem_basicOpen_iff
      2 K j y hyj Δ 9 hΔhom (by omega)).mp
    rw [hypoint]
    exact hzUV.2
  have hx0 : x ≠ 0 := by
    intro hxzero
    have := congrFun hxzero i
    simp [hxi] at this
  have hy0 : y ≠ 0 := by
    intro hyzero
    have := congrFun hyzero j
    simp [hyj] at this
  refine ⟨x, y, hx0, hy0, hxcoord, hDsmooth x hxD, ?_, hyΔ⟩
  rwa [eval_specializeFirstCoordinates]

/-- On one smooth cubic fibre in the fixed inverse-stereo chart, a point can simultaneously avoid
the conic discriminant and have tangent residual avoiding that discriminant.  The tangent residual
is expressed by one of the polynomial coordinate-chart directions, so both conditions are honest
homogeneous principal opens on the smooth cubic. -/
theorem exists_smoothCubicFiber_chartTangent_point_avoids_two_discriminants
    {K : Type u} [Field K] [IsAlgClosed K] [CharZero K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    ∃ (x : Fin 3 → K) (i : Fin 3) (p : Fin 3 → K),
      x ≠ 0 ∧ x 0 ≠ 0 ∧
      IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F) ∧
      p ≠ 0 ∧ p i ≠ 0 ∧
      eval p (specializeFirstCoordinates (n := 2) x F) = 0 ∧
      eval p (sndConicDiscriminant F) ≠ 0 ∧
      eval
        (residualAmbientRep p
          (chartTangentDir i (specializeFirstCoordinates (n := 2) x F) p)
          (binaryLineRestriction p
            (chartTangentDir i (specializeFirstCoordinates (n := 2) x F) p)
            (specializeFirstCoordinates (n := 2) x F)))
        (sndConicDiscriminant F) ≠ 0 := by
  obtain ⟨x, y, hx0, hy0, hxcoord, hsmooth, hycurve, hyΔ⟩ :=
    exists_smoothCubicFiber_in_stereoChart_point_avoids_sndConicDiscriminant
      F hF hF0
  let g := specializeFirstCoordinates (n := 2) x F
  let Δ := sndConicDiscriminant F
  have hΔhom : Δ.IsHomogeneous 9 := sndConicDiscriminant_isHomogeneous F hF
  obtain ⟨p₀, q₀, hp₀0, hp₀curve, hp₀q₀, hq₀tan, hp₀avoid⟩ :=
    exists_tangentResidualRep_avoids_homogeneous_target_of_isSmoothPlaneCubic
      g hsmooth Δ hΔhom ⟨y, hy0, hycurve, hyΔ⟩
  obtain ⟨i, hp₀i⟩ := exists_normalizing_coordinate p₀ hp₀0
  have hp₀chartAvoid : eval
      (residualAmbientRep p₀ (chartTangentDir i g p₀)
        (binaryLineRestriction p₀ (chartTangentDir i g p₀) g)) Δ ≠ 0 :=
    eval_chartTangentResidual_ne_zero_of_isSmoothPlaneCubic
      i g hsmooth p₀ q₀ hp₀curve hp₀i hp₀q₀ hq₀tan Δ hΔhom hp₀avoid
  let T := chartTangentResidualPullback i g Δ
  have hThom : T.IsHomogeneous (7 * 9) :=
    chartTangentResidualPullback_isHomogeneous i g Δ hsmooth.1 hΔhom
  let Ti := T * X i
  have hTihom : Ti.IsHomogeneous (7 * 9 + 1) :=
    hThom.mul (isHomogeneous_X K i)
  have hp₀T : eval p₀ T ≠ 0 := by
    rw [eval_chartTangentResidualPullback i g Δ hsmooth.1 p₀]
    exact hp₀chartAvoid
  have hp₀Ti : eval p₀ Ti ≠ 0 := by
    simpa [Ti] using mul_ne_zero hp₀T hp₀i
  obtain ⟨p, hp0, hpcurve, hpΔ, hpTi⟩ :=
    exists_projective_point_off_two_targets_of_isSmoothPlaneCubic
      g Δ Ti hsmooth hΔhom hTihom (by norm_num) (by norm_num)
      ⟨y, hy0, hycurve, hyΔ⟩ ⟨p₀, hp₀0, hp₀curve, hp₀Ti⟩
  have hpTi' : eval p T * p i ≠ 0 := by simpa [Ti] using hpTi
  have hpT : eval p T ≠ 0 := (mul_ne_zero_iff.mp hpTi').1
  have hpi : p i ≠ 0 := (mul_ne_zero_iff.mp hpTi').2
  have hpavoid : eval
      (residualAmbientRep p (chartTangentDir i g p)
        (binaryLineRestriction p (chartTangentDir i g p) g)) Δ ≠ 0 := by
    rw [← eval_chartTangentResidualPullback i g Δ hsmooth.1 p]
    exact hpT
  exact ⟨x, i, p, hx0, hxcoord, hsmooth, hp0, hpi, hpcurve, hpΔ, hpavoid⟩

/-! ## Correct arbitrary-frame pointwise witness -/

/-- Pointwise G4 for an arbitrary framed vertical line.

The vector `q` spans the vertical line with `p`; it is not required to be tangent to the selected
cubic.  The construction's separate tangent direction is `frameTangentDir`.  The final two open
conditions are exactly those needed for the local conic-center construction: the conic over `p`
is nonsingular because `sndConicDiscriminant F` does not vanish at `p`, and the target avoids the
one fixed omitted first-coordinate point. -/
def HasNonsingularFramedPointwiseG4Witness
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K) : Prop :=
  ∃ x : Fin 3 → K,
    x ≠ 0 ∧
    IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F) ∧
    p ≠ 0 ∧
    eval p (specializeFirstCoordinates (n := 2) x F) = 0 ∧
    eval
        (residualAmbientRep p
          (frameTangentDir (lineFrame p q r) N
            (specializeFirstCoordinates (n := 2) x F) p)
          (binaryLineRestriction p
            (frameTangentDir (lineFrame p q r) N
              (specializeFirstCoordinates (n := 2) x F) p)
            (specializeFirstCoordinates (n := 2) x F)))
        (sndConicDiscriminant F) ≠ 0 ∧
    eval p (sndConicDiscriminant F) ≠ 0 ∧
    (x 0 ≠ 0 ∨ x 2 ≠ 0)

/-- The sole remaining line-selection principle, stated as the natural incidence-open theorem.

For every nonempty homogeneous principal open on a smooth plane cubic, some invertibly framed G3
line has its first point in that open.  Geometrically, this follows by intersecting two nonempty
opens on the irreducible incidence variety of points of the cubic and lines through them: G3 is a
nonempty open on the line/frame factor, and the displayed principal open is nonempty on the cubic
factor.  Formalizing that incidence variety (or equivalently clearing adjugate denominators in
frame coordinates) is the only statement left unproved in this module. -/
def G3FrameMeetsEveryNonemptyPrincipalOpenOnSmoothCubic
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) : Prop :=
  ∀ (g H : MvPolynomial (Fin 3) K) (d : ℕ),
    IsSmoothPlaneCubic g → H.IsHomogeneous d → 0 < d →
    (∃ p : Fin 3 → K, p ≠ 0 ∧ eval p g = 0 ∧ eval p H ≠ 0) →
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
      lineFrame p q r * N = 1 ∧
      ResidualLineNonconstantOn (lineFrame p q r) N F ∧
      p ≠ 0 ∧ eval p g = 0 ∧ eval p H ≠ 0

/-- The incidence-open principle produces exactly the corrected common-line witness. -/
theorem exists_G3_nonsingularFramedPointwiseG4Witness_of_incidenceOpen
    {K : Type u} [Field K] [IsAlgClosed K] [CharZero K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (hinc : G3FrameMeetsEveryNonemptyPrincipalOpenOnSmoothCubic F) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
      lineFrame p q r * N = 1 ∧
      ResidualLineNonconstantOn (lineFrame p q r) N F ∧
      HasNonsingularFramedPointwiseG4Witness F p q r N := by
  obtain ⟨x, i, p₀, hx0, hxcoord, hsmooth, hp₀0, hp₀i, hp₀curve, hp₀Δ,
      hp₀avoid⟩ :=
    exists_smoothCubicFiber_chartTangent_point_avoids_two_discriminants
      F hF hF0
  let g := specializeFirstCoordinates (n := 2) x F
  let Δ := sndConicDiscriminant F
  let T := chartTangentResidualPullback i g Δ
  let H := Δ * T * X i
  have hΔhom : Δ.IsHomogeneous 9 := sndConicDiscriminant_isHomogeneous F hF
  have hThom : T.IsHomogeneous (7 * 9) :=
    chartTangentResidualPullback_isHomogeneous i g Δ hsmooth.1 hΔhom
  have hHhom : H.IsHomogeneous (9 + 7 * 9 + 1) :=
    (hΔhom.mul hThom).mul (isHomogeneous_X K i)
  have hp₀T : eval p₀ T ≠ 0 := by
    rw [eval_chartTangentResidualPullback i g Δ hsmooth.1 p₀]
    exact hp₀avoid
  have hp₀H : eval p₀ H ≠ 0 := by
    simpa [H] using mul_ne_zero (mul_ne_zero hp₀Δ hp₀T) hp₀i
  obtain ⟨p, q, r, N, hMN, hG3, hp0, hpcurve, hpH⟩ :=
    hinc g H (9 + 7 * 9 + 1) hsmooth hHhom (by norm_num)
      ⟨p₀, hp₀0, hp₀curve, hp₀H⟩
  have hpΔTi : eval p Δ * eval p T * p i ≠ 0 := by
    simpa [H] using hpH
  have hpΔT : eval p Δ * eval p T ≠ 0 := (mul_ne_zero_iff.mp hpΔTi).1
  have hpi : p i ≠ 0 := (mul_ne_zero_iff.mp hpΔTi).2
  have hpΔ : eval p Δ ≠ 0 := (mul_ne_zero_iff.mp hpΔT).1
  have hpT : eval p T ≠ 0 := (mul_ne_zero_iff.mp hpΔT).2
  have hpChartAvoid : eval
      (residualAmbientRep p (chartTangentDir i g p)
        (binaryLineRestriction p (chartTangentDir i g p) g)) Δ ≠ 0 := by
    rw [← eval_chartTangentResidualPullback i g Δ hsmooth.1 p]
    exact hpT
  have hpFrameAvoid : eval
      (residualAmbientRep p (frameTangentDir (lineFrame p q r) N g p)
        (binaryLineRestriction p (frameTangentDir (lineFrame p q r) N g p) g)) Δ ≠ 0 :=
    eval_frameTangentResidual_ne_zero_of_chartTangent
      i p q r N hMN g hsmooth hpcurve hpi Δ hΔhom hpChartAvoid
  refine ⟨p, q, r, N, hMN, hG3, x, hx0, hsmooth, hp0, hpcurve, ?_, hpΔ, Or.inl hxcoord⟩
  exact hpFrameAvoid

/-- The nonsingular frame-tangent G4 open is nonempty on every smooth cubic on which the conic
discriminant is pointwise proper.

For this one witness we may take the second frame column to be the tangent direction supplied by
tangent-residual surjectivity.  The point is only to prove nonemptiness; the definition above and
the common-open argument impose no tangency condition on a general vertical line. -/
theorem exists_nonsingularFramedPointwiseG4Witness_on_smooth_cubic
    {K : Type u} [Field K] [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (x : Fin 3 → K) (hx0 : x ≠ 0)
    (hsmooth : IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F))
    (hxcoord : x 0 ≠ 0 ∨ x 2 ≠ 0)
    (hproper : ∃ y : Fin 3 → K,
      y ≠ 0 ∧
      eval y (specializeFirstCoordinates (n := 2) x F) = 0 ∧
      eval y (sndConicDiscriminant F) ≠ 0) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
      lineFrame p q r * N = 1 ∧
      HasNonsingularFramedPointwiseG4Witness F p q r N := by
  let G := specializeFirstCoordinates (n := 2) x F
  obtain ⟨p, q, hp0, hp, hpdisc, hpq, hq, hresdisc⟩ :=
    exists_tangentResidual_base_and_image_avoid_homogeneous_target
      G hsmooth (sndConicDiscriminant F)
      (sndConicDiscriminant_isHomogeneous F hF) (by norm_num) hproper
  obtain ⟨r, N, hMN⟩ := exists_lineFrame_inverse_of_pair_linearIndependent p q hpq
  have hframeDisc :
      eval
        (residualAmbientRep p
          (frameTangentDir (lineFrame p q r) N G p)
          (binaryLineRestriction p (frameTangentDir (lineFrame p q r) N G p) G))
        (sndConicDiscriminant F) ≠ 0 := by
    exact eval_frameTangentResidual_ne_zero_of_smooth_tangent
      p q r N hMN G hsmooth hp hq
      (sndConicDiscriminant F) 9 (sndConicDiscriminant_isHomogeneous F hF) hresdisc
  refine ⟨p, q, r, N, hMN, x, hx0, hsmooth, hp0, hp, hframeDisc, hpdisc, hxcoord⟩

/-- Under global smoothness, the corrected nonsingular framed pointwise-G4 open is nonempty.
The preceding proper-point theorem supplies a smooth cubic in the fixed stereographic chart, and
simultaneous principal-open avoidance supplies the framed tangent-residual witness on it. -/
theorem exists_nonsingularFramedPointwiseG4Witness_of_smooth
    {K : Type u} [Field K] [IsAlgClosed K] [CharZero K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
      lineFrame p q r * N = 1 ∧
      HasNonsingularFramedPointwiseG4Witness F p q r N := by
  obtain ⟨x, y, hx0, hy0, hxcoord, hsmooth, hy, hyΔ⟩ :=
    exists_smoothCubicFiber_in_stereoChart_point_avoids_sndConicDiscriminant
      F hF hF0
  exact exists_nonsingularFramedPointwiseG4Witness_on_smooth_cubic
    F hF x hx0 hsmooth (Or.inl hxcoord) ⟨y, hy0, hy, hyΔ⟩

/-- A framed G3 line carrying the corrected nonsingular pointwise-G4 witness admits one
polynomial Tsen section satisfying the actual G3 and polynomial G4 predicates on that same line.

No tangency condition is imposed on the vertical line: only its frame-defined tangent direction
appears in the avoidance hypothesis. -/
theorem exists_actualG3G4LineSection_of_G3_of_nonsingularFramedPointwiseG4Witness
    {K : Type u} [Field K] [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [AlgebraicGeometry.Smooth
      (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 K F)]
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (hG3 : ResidualLineNonconstantOn (lineFrame p q r) N F)
    (hpoint : HasNonsingularFramedPointwiseG4Witness F p q r N) :
    ∃ (x : Fin 3 → K) (v : Fin 3 → Polynomial K) (u : Fin 3 → K),
      HasActualG3G4LineSection F p q r N v ∧
      TsenSectionRealizesCenterAt v 0 u ∧
      pointwiseG4StereoCertificateAt p q F v 0 x ≠ 0 ∧
      pointwiseG4StereoCertificatePoly p q F v x ≠ 0 := by
  classical
  obtain ⟨x, hx0, hsmooth, hp0, hp, havoid, hpdisc, hxcoord⟩ := hpoint
  obtain ⟨v₀, hv₀0, hv₀⟩ := exists_isotropic_line_conic K p q F
  have hQhom : (lineSpecializedConicPoly p q F).IsHomogeneous 2 :=
    lineSpecializedConicPoly_isHomogeneous p q hF
  have hv₀' : eval v₀ (lineSpecializedConicPoly p q F) = 0 := by
    rw [← ternaryQuadraticPoly_eval_line p q F hF]
    exact hv₀
  have hnonsing : ∀ y : Fin 3 → K, y ≠ 0 →
      eval y (map (Polynomial.evalRingHom 0) (lineSpecializedConicPoly p q F)) = 0 →
      ∃ i : Fin 3,
        eval y (pderiv i
          (map (Polynomial.evalRingHom 0) (lineSpecializedConicPoly p q F))) ≠ 0 := by
    simpa only [map_eval_lineSpecializedConicPoly] using
      lineSpecializedConic_zero_nonsingular_of_sndConicDiscriminant_ne_zero
        F hF p q hpdisc
  have hx : eval x
      (map (Polynomial.evalRingHom 0) (lineSpecializedConicPoly p q F)) = 0 := by
    rw [map_eval_lineSpecializedConicPoly]
    simpa [lineSpecializedConic] using hp
  obtain ⟨v, u, hv0, hviso, hu0, hu, hu2, hB, hw0, hrealize⟩ :=
    exists_isotropic_section_realizing_inverseStereo_center_at_zero
      (lineSpecializedConicPoly p q F) hQhom v₀ hv₀0 hv₀'
      hnonsing x hx0 hx hxcoord
  have hviso' : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0 := by
    rw [ternaryQuadraticPoly_eval_line p q F hF]
    exact hviso
  have hB' : polarEval (lineSpecializedConic p q F 0) u
      (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) ≠ 0 := by
    simpa only [map_eval_lineSpecializedConicPoly] using hB
  have hcert : pointwiseG4StereoCertificateAt p q F v 0 x ≠ 0 :=
    pointwiseG4StereoCertificateAt_ne_zero_of_realizes_center
      p q F hF v 0 x u hu2 hB' hw0 hrealize
  have hv2 : v 2 ≠ 0 := by
    intro hv2zero
    obtain ⟨c, hc, hvc⟩ := hrealize
    have hcu : c * u 2 = 0 := by
      have hcoord := congrFun hvc 2
      simpa [evalPolySection, hv2zero, Pi.smul_apply, smul_eq_mul] using hcoord.symm
    exact hu2 ((mul_eq_zero.mp hcu).resolve_left hc)
  have hlineDisc : lineConicDiscriminant p q F ≠ 0 :=
    lineConicDiscriminant_ne_zero_of_smooth p q r N hMN F hF hF0
  have hpolar0 := polarEval_ne_zero_of_isotropic_of_third_ne_zero
    hQhom hlineDisc hviso hv2
  have hpolar : lineStereoPolarForm p q F v ≠ 0 :=
    polarEval_lineStereoDir_ne_zero_of_polarEval_ne_zero p q F hF v hpolar0
  have hsection : HasNondegenerateLineStereoSection F p q v :=
    ⟨hv0, hviso', hv2, hpolar⟩
  have hactualG4 : ResidualAvoidsConicDiscriminantOn p q r N F v := by
    obtain ⟨hv20, hB0, hw00⟩ :=
      inverseStereo_open_of_pointwiseG4StereoCertificateAt_ne_zero
        p q F hF v 0 x hcert
    have hxQ : eval x (lineSpecializedConic p q F 0) = 0 := by
      simpa [lineSpecializedConic] using hp
    obtain ⟨s, a, ha, hstereo⟩ :=
      exists_evalAffineTwoPoint_stereoFirstCoordsOn_eq_smul
        p q F hF v hviso' 0 x hv20 hxQ hB0 hw00
    apply residualAvoidsConicDiscriminantOn_of_specialized_frameTangentResidual
      p q r N F v 0 s
    simp only [hstereo, linePointOf_zero]
    rw [hF.specializeFirstCoordinates_smul]
    exact eval_frameTangentResidual_C_mul_ne_zero
      p q r N hMN (specializeFirstCoordinates (n := 2) x F) hsmooth.1 hp
      (sndConicDiscriminant F) 9 (sndConicDiscriminant_isHomogeneous F hF)
      havoid (a ^ 2) (pow_ne_zero 2 ha)
  have hactual : HasActualG3G4LineSection F p q r N v :=
    ⟨hMN, hG3, hsection, hactualG4⟩
  have hcertPoly : pointwiseG4StereoCertificatePoly p q F v x ≠ 0 :=
    pointwiseG4StereoCertificatePoly_ne_zero_of_realizes_center
      p q F hF v 0 x u hu2 hB' hw0 hrealize
  exact ⟨x, v, u, hactual, hrealize, hcert, hcertPoly⟩

/-! ## The remaining frame-space intersection -/

/-- The exact common principal-open condition left on the invertible-frame incidence over one
fixed smooth cubic.

The equation `eval p G = 0` cuts out the incidence over the cubic.  On that incidence the final
three conditions are the G3 open, the smooth-conic-fibre open `Δ(p) ≠ 0`, and the frame-tangent
residual open `Δ(res) ≠ 0`.  Writing the inverse matrix `N` explicitly keeps invertibility
polynomial and avoids any hidden division. -/
def HasG3NonsingularFrameIntersectionAt
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (x : Fin 3 → K) : Prop :=
  ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
    lineFrame p q r * N = 1 ∧
    ResidualLineNonconstantOn (lineFrame p q r) N F ∧
    p ≠ 0 ∧
    eval p (specializeFirstCoordinates (n := 2) x F) = 0 ∧
    eval p (sndConicDiscriminant F) ≠ 0 ∧
    eval
      (residualAmbientRep p
        (frameTangentDir (lineFrame p q r) N
          (specializeFirstCoordinates (n := 2) x F) p)
        (binaryLineRestriction p
          (frameTangentDir (lineFrame p q r) N
            (specializeFirstCoordinates (n := 2) x F) p)
          (specializeFirstCoordinates (n := 2) x F)))
      (sndConicDiscriminant F) ≠ 0

/-- Once the displayed frame-space principal opens meet on a suitable smooth cubic, the requested
actual G3--G4 line and polynomial Tsen section follow with no further geometric or interpolation
input. -/
theorem exists_actualG3G4LineSection_of_hasG3NonsingularFrameIntersectionAt
    {K : Type u} [Field K] [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [AlgebraicGeometry.Smooth
      (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 K F)]
    (x : Fin 3 → K) (hx0 : x ≠ 0)
    (hsmooth : IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F))
    (hxcoord : x 0 ≠ 0 ∨ x 2 ≠ 0)
    (hinter : HasG3NonsingularFrameIntersectionAt F x) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
        (v : Fin 3 → Polynomial K),
      HasActualG3G4LineSection F p q r N v := by
  obtain ⟨p, q, r, N, hMN, hG3, hp0, hp, hpdisc, hresdisc⟩ := hinter
  have hpoint : HasNonsingularFramedPointwiseG4Witness F p q r N :=
    ⟨x, hx0, hsmooth, hp0, hp, hresdisc, hpdisc, hxcoord⟩
  obtain ⟨_x, v, _u, hactual, _⟩ :=
    exists_actualG3G4LineSection_of_G3_of_nonsingularFramedPointwiseG4Witness
      F hF hF0 p q r N hMN hG3 hpoint
  exact ⟨p, q, r, N, v, hactual⟩

end

end BConicBundleMultisections.Standard
