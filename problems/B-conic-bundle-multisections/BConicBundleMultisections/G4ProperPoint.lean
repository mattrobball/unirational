/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GoodLineExistence
public import BConicBundleMultisections.PointedConicOpenDominance
public import BConicBundleMultisections.BiprojectiveZeroLocusClosedPoints
public import BConicBundleMultisections.GenericConicProjectivePoint
public import BConicBundleMultisections.SndConicDiscriminant
public import BConicBundleMultisections.ResidualRelationBigrading

/-!
# A smooth cubic fibre meeting the proper conic-discriminant open

This file isolates the point-existence input used by the discriminant-avoidance (`G4`) route.
For a smooth nonzero bidegree-`(2,3)` hypersurface, it constructs a smooth plane-cubic fibre and
a point of that fibre outside the discriminant of the conic projection.

The proof uses two nonempty opens of the integral total space.  The first is pulled back from a
homogeneous principal open on which the first-projection cubic is smooth; the second is pulled
back from the nonzero conic-discriminant principal open.  Irreducibility makes their intersection
nonempty, and Jacobson density supplies a closed point, hence a `k`-point over an algebraically
closed field.  The chart lemmas below turn that point back into homogeneous coordinates.
-/

@[expose] public section

open CategoryTheory Topology TopologicalSpace
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace ProjectiveSpace
open _root_.MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra

set_option backward.isDefEq.respectTransparency false

variable {k : Type u} [Field k]

namespace ProjectiveSpace

/-- Membership of a normalized projective point in a homogeneous basic open is detected by
ordinary evaluation of the homogeneous form. -/
theorem pointOfNormalizedCoordinates_mem_basicOpen_iff
    (n : ℕ) (R : Type u) [Field R]
    (i : Fin (n + 1)) (x : Fin (n + 1) → R) (hxi : x i = 1)
    (p : MvPolynomial (Fin (n + 1)) R) (d : ℕ)
    (hp : p.IsHomogeneous d) (hd : 0 < d) :
    (pointOfNormalizedCoordinates n R i x hxi).base (IsLocalRing.closedPoint R) ∈
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) p ↔
      eval x p ≠ 0 := by
  let e := standardChartEval n R i x
  change (standardChartι n R i).base
      ((Spec.map (CommRingCat.ofHom e)).base (IsLocalRing.closedPoint R)) ∈
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) p ↔ _
  change (Spec.map (CommRingCat.ofHom e)).base (IsLocalRing.closedPoint R) ∈
      standardChartι n R i ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) p ↔ _
  have hi : (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R) ∈
      MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 1 :=
    MvPolynomial.isHomogeneous_X R i
  have hp' : p ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R d := hp
  rw [show standardChartι n R i ⁻¹ᵁ
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) p =
        PrimeSpectrum.basicOpen
          (HomogeneousLocalization.Away.isLocalizationElem hi hp') by
      exact Proj.awayι_preimage_basicOpen
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
        hi zero_lt_one hp' hd]
  change PrimeSpectrum.comap e (IsLocalRing.closedPoint R) ∈
      PrimeSpectrum.basicOpen
        (HomogeneousLocalization.Away.isLocalizationElem hi hp') ↔ _
  rw [PrimeSpectrum.mem_basicOpen, PrimeSpectrum.comap_asIdeal, Ideal.mem_comap]
  simp only [IsLocalRing.closedPoint, IsLocalRing.maximalIdeal_eq_bot, Ideal.mem_bot,
    map_eq_zero]
  change e (HomogeneousLocalization.Away.isLocalizationElem hi hp') ≠ 0 ↔ _
  have haway :
      HomogeneousLocalization.Away.isLocalizationElem hi hp' =
        HomogeneousLocalization.Away.mk
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
          (MvPolynomial.isHomogeneous_X R i) d p (by simpa using hp') := by
    rw [HomogeneousLocalization.ext_iff_val]
    simp [HomogeneousLocalization.Away.val_mk]
  rw [haway]
  change eval (affineCoordinates i x)
      (standardChartRingEquivMvPolynomial n R i
        (HomogeneousLocalization.Away.mk
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
          (MvPolynomial.isHomogeneous_X R i) d p (by simpa using hp'))) ≠ 0 ↔ _
  rw [show standardChartRingEquivMvPolynomial n R i
      (HomogeneousLocalization.Away.mk
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
        (MvPolynomial.isHomogeneous_X R i) d p (by simpa using hp')) =
      chartDehomogenization n R i p by
        exact standardChartToMvPolynomial_away_mk n R i d p hp']
  change aeval (affineCoordinates i x)
      (aeval (i.succAboveCases 1 fun r ↦ X r) p) ≠ 0 ↔ eval x p ≠ 0
  rw [comp_aeval_apply]
  change eval
      (fun l ↦ eval (affineCoordinates i x) (i.succAboveCases 1 (fun r ↦ X r) l)) p ≠ 0 ↔
    eval x p ≠ 0
  have hcoords :
      (fun l ↦ eval (affineCoordinates i x)
        (i.succAboveCases 1 (fun r ↦ X r) l)) = x := by
    funext l
    rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
    · simpa [hxi]
    · simp [affineCoordinates]
  rw [hcoords]

end ProjectiveSpace

/-! ## A homogeneous smooth-fibre principal open -/

/-- The smooth-cubic-fibre locus contains a nonempty homogeneous principal open of positive
degree.  Multiplication by one coordinate makes the degree positive without changing the
implication from nonvanishing to smoothness. -/
theorem exists_positive_homogeneous_smoothCubicFiber_open [IsAlgClosed k]
    [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ (D : MvPolynomial (Fin 3) k) (d : ℕ),
      D ≠ 0 ∧ 0 < d ∧ D.IsHomogeneous d ∧
        (∃ x : Fin 3 → k, x ≠ 0 ∧ eval x D ≠ 0) ∧
        ∀ x : Fin 3 → k, eval x D ≠ 0 →
          Standard.IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F) := by
  obtain ⟨S, hShom, hS⟩ := exists_defining_set_nonsingular_cubicFiber_of_bidegree23 F hF
  obtain ⟨x₀, hx₀⟩ := exists_nonsingularCubicFiber_of_smooth F hF hF0
  obtain ⟨D₀, hD₀S, hxD₀⟩ := (hS x₀).mpr hx₀
  obtain ⟨d₀, hD₀hom⟩ := hShom D₀ hD₀S
  have hD₀0 : D₀ ≠ 0 := by
    intro hD
    rw [hD, map_zero] at hxD₀
    exact hxD₀ rfl
  have hx₀0 : x₀ ≠ 0 := by
    intro hxzero
    subst x₀
    have hns := hx₀ ![1, 0, 0] (by simp)
    have hzero : specializeFirstCoordinates (n := 2) (0 : Fin 3 → k) F = 0 :=
      specializeFirstCoordinates_zero_of_bidegree_pos hF (by omega)
    have hev : eval ![1, 0, 0]
        (specializeFirstCoordinates (n := 2) (0 : Fin 3 → k) F) = 0 := by
      rw [hzero, map_zero]
    obtain ⟨i, hi⟩ := hns hev
    simp [hzero] at hi
  obtain ⟨i, hxi⟩ := exists_normalizing_coordinate x₀ hx₀0
  let D := D₀ * X i
  refine ⟨D, d₀ + 1, mul_ne_zero hD₀0 (X_ne_zero i), by omega,
    hD₀hom.mul (isHomogeneous_X k i), ?_, ?_⟩
  · refine ⟨x₀, hx₀0, ?_⟩
    simp only [D, eval_mul, eval_X]
    exact mul_ne_zero hxD₀ hxi
  · intro x hxD
    have hxD₀' : eval x D₀ ≠ 0 := by
      intro hz
      apply hxD
      simp [D, hz]
    exact ⟨hF.specializeFirstCoordinates_isHomogeneous x,
      (hS x).mp ⟨D₀, hD₀S, hxD₀'⟩⟩

/-! ## The first projection of a normalized zero-locus point -/

/-- First-factor counterpart of `zeroLocusPointOfNormalized_snd`. -/
theorem zeroLocusPointOfNormalized_fst
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hFdeg : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : MvPolynomial.eval (Sum.elim x y) F = 0) :
    zeroLocusPointOfNormalized m n R F hFdeg i j x y hxi hyj hF ≫
        biprojectiveZeroLocusFst m n R F =
      pointOfNormalizedCoordinates m R i x hxi := by
  unfold zeroLocusPointOfNormalized biprojectiveZeroLocusFst
  rw [Category.assoc, chartZeroLocusToGlobal_ι_assoc]
  have himm :=
    chartZeroLocusPointOfNormalized_subschemeι m n R i j x y hxi hyj F hF
  simp only [← Category.assoc] at himm ⊢
  rw [himm]
  simp only [Category.assoc]
  have h :=
    biprojectiveChartPointOfNormalizedAlgebra_comp_standardChartι_fst
      (R := R) (S := R) m n i j x y
  unfold biprojectiveChartPointOfNormalized pointOfNormalizedCoordinates
  simpa [biprojectiveChartPointOfNormalizedAlgebra,
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra,
    biprojectiveChartEvalAlgebra, biprojectiveChartEval, affineChartEval,
    ProjectiveSpace.standardChartEvalAlgebra,
    ProjectiveSpace.standardChartEval] using h

/-! ## Coordinates of a closed point of the global zero locus -/

/-- A closed point of the global biprojective zero locus has normalized `k`-coordinates satisfying
the defining equation, and these coordinates recover both projected points. -/
theorem exists_normalized_coordinates_of_closedPoint_zeroLocus [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F)
    (z : biprojectiveZeroLocus 2 2 k F) (hz : IsClosed {z}) :
    ∃ (i j : Fin 3) (x y : Fin 3 → k)
      (hxi : x i = 1) (hyj : y j = 1),
      eval (Sum.elim x y) F = 0 ∧
        (pointOfNormalizedCoordinates 2 k i x hxi).base
            (IsLocalRing.closedPoint k) = biprojectiveZeroLocusFst 2 2 k F z ∧
        (pointOfNormalizedCoordinates 2 k j y hyj).base
            (IsLocalRing.closedPoint k) = biprojectiveZeroLocusSnd 2 2 k F z := by
  let X := biprojectiveZeroLocus 2 2 k F
  let p : Spec (.of k) ⟶ X :=
    pointOfClosedPoint (biprojectiveZeroLocusToSpec 2 2 k F) z hz
  have hzambient : (biprojectiveZeroLocusι 2 2 k F).base z ∈
      (⊤ : (BiprojectiveSpace 2 2 k).Opens) := trivial
  rw [← BiprojectiveSpace.iSup_standardChartAffineOpen 2 2 k] at hzambient
  simp only [TopologicalSpace.Opens.mem_iSup] at hzambient
  obtain ⟨⟨i, j⟩, hzij⟩ := hzambient
  have hzchart : z ∈
      (chartZeroLocusToGlobal 2 2 k F hF i j).opensRange := by
    rw [opensRange_chartZeroLocusToGlobal]
    exact hzij
  have hzrange : z ∈ Set.range
      (chartZeroLocusToGlobal 2 2 k F hF i j).base := by
    rw [← Scheme.Hom.coe_opensRange]
    exact hzchart
  have hpRange : Set.range p ⊆ Set.range
      (chartZeroLocusToGlobal 2 2 k F hF i j).base := by
    intro w hw
    obtain ⟨s, rfl⟩ := hw
    rw [show s = IsLocalRing.closedPoint k from Subsingleton.elim _ _]
    simpa [p, X] using hzrange
  let q := IsOpenImmersion.lift (chartZeroLocusToGlobal 2 2 k F hF i j) p hpRange
  let I : Ideal (MvPolynomial (Fin 2 ⊕ Fin 2) k) :=
    Ideal.span {affineChartEquation 2 2 k i j F}
  let A := MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸ I
  let qSpec : Spec (.of k) ⟶ Spec (.of A) :=
    q ≫ (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).hom
  let φ : A →+* k := (Spec.preimage qSpec).hom
  have hpBase : p ≫ biprojectiveZeroLocusToSpec 2 2 k F = 𝟙 _ := by
    simpa [p, X] using
      pointOfClosedPoint_comp (biprojectiveZeroLocusToSpec 2 2 k F) z hz
  have hqfac : q ≫ chartZeroLocusToGlobal 2 2 k F hF i j = p :=
    IsOpenImmersion.lift_fac _ _ _
  have hqSpecBase : qSpec ≫ affineChartQuotientToSpec 2 2 k i j F = 𝟙 _ := by
    dsimp only [qSpec]
    rw [Category.assoc,
      chartZeroLocusIsoSpecAffineQuotient_hom_toSpec 2 2 k F hF i j]
    unfold chartZeroLocusToSpec
    rw [← Category.assoc, hqfac, hpBase]
  have hφbase : φ.comp (algebraMap k A) = RingHom.id k := by
    have hpre := congrArg Spec.preimage hqSpecBase
    rw [Spec.preimage_comp] at hpre
    dsimp only [φ, A]
    ext a
    simpa [qSpec, affineChartQuotientToSpec, I] using
      congrArg (fun f : (CommRingCat.of k ⟶ CommRingCat.of k) ↦ f.hom a) hpre
  let x : Fin 3 → k := i.succAboveCases 1 fun r ↦
    φ (Ideal.Quotient.mk I (MvPolynomial.X (.inl r)))
  let y : Fin 3 → k := j.succAboveCases 1 fun r ↦
    φ (Ideal.Quotient.mk I (MvPolynomial.X (.inr r)))
  have hxi : x i = 1 := by simp [x]
  have hyj : y j = 1 := by simp [y]
  have hφmk : φ.comp (Ideal.Quotient.mk I) =
      MvPolynomial.eval (affineChartPoint i j x y) := by
    apply MvPolynomial.ringHom_ext
    · intro a
      simp only [RingHom.comp_apply, eval_C]
      have hCa : Ideal.Quotient.mk I (C a) = algebraMap k A a := by
        change Ideal.Quotient.mk I (C a) =
          Ideal.Quotient.mk I (algebraMap k (MvPolynomial (Fin 2 ⊕ Fin 2) k) a)
        rw [MvPolynomial.algebraMap_eq]
      rw [hCa]
      exact DFunLike.congr_fun hφbase a
    · intro s
      rcases s with r | r
      · simp [x, affineChartPoint]
        rfl
      · simp [y, affineChartPoint]
        rfl
  have haff : eval (affineChartPoint i j x y)
      (affineChartEquation 2 2 k i j F) = 0 := by
    rw [← DFunLike.congr_fun hφmk (affineChartEquation 2 2 k i j F)]
    change φ (Ideal.Quotient.mk I (affineChartEquation 2 2 k i j F)) = 0
    rw [Ideal.Quotient.eq_zero_iff_mem.mpr
      (Ideal.subset_span (Set.mem_singleton _)), map_zero]
  have hFxy : eval (Sum.elim x y) F = 0 := by
    rw [← eval_affineChartEquation_affineChartPoint 2 2 k i j x y hxi hyj F]
    exact haff
  have hφq : φ = affineChartQuotientEval 2 2 k i j x y hxi hyj F hFxy := by
    apply Ideal.Quotient.ringHom_ext
    exact hφmk.trans (by rfl)
  have hqpoint : q = chartZeroLocusPointOfNormalized 2 2 k i j x y hxi hyj F hFxy := by
    apply (cancel_mono (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).hom).mp
    unfold chartZeroLocusPointOfNormalized
    rw [Category.assoc, Iso.inv_hom_id, Category.comp_id]
    change qSpec = Spec.map (CommRingCat.ofHom
      (affineChartQuotientEval 2 2 k i j x y hxi hyj F hFxy))
    rw [← Spec.map_preimage qSpec]
    exact congrArg Spec.map (congrArg CommRingCat.ofHom hφq)
  have hpx : p ≫ biprojectiveZeroLocusFst 2 2 k F =
      pointOfNormalizedCoordinates 2 k i x hxi := by
    rw [← hqfac, hqpoint]
    simp only [Category.assoc]
    exact zeroLocusPointOfNormalized_fst 2 2 k F hF i j x y hxi hyj hFxy
  have hpy : p ≫ biprojectiveZeroLocusSnd 2 2 k F =
      pointOfNormalizedCoordinates 2 k j y hyj := by
    rw [← hqfac, hqpoint]
    simp only [Category.assoc]
    exact zeroLocusPointOfNormalized_snd 2 2 k F hF i j x y hxi hyj hFxy
  refine ⟨i, j, x, y, hxi, hyj, hFxy, ?_, ?_⟩
  · have := congrArg (fun f : Spec (.of k) ⟶ ProjectiveSpace 2 k ↦
        f (IsLocalRing.closedPoint k)) hpx
    simpa [p, X, Scheme.Hom.comp_apply] using this.symm
  · have := congrArg (fun f : Spec (.of k) ⟶ ProjectiveSpace 2 k ↦
        f (IsLocalRing.closedPoint k)) hpy
    simpa [p, X, Scheme.Hom.comp_apply] using this.symm

/-! ## Intersecting the two proper opens -/

/-- Normalizing the second homogeneous coordinate block preserves a bihomogeneous zero. -/
theorem eval_normalize_second_eq_zero_of_isBihomogeneous
    {m n d e : ℕ} {K : Type u} [Field K]
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x : Fin (m + 1) → K) (y : Fin (n + 1) → K)
    (j : Fin (n + 1)) (hxy : eval (Sum.elim x y) F = 0) :
    eval (Sum.elim x (normalizeCoordinateRepresentative y j)) F = 0 := by
  have hy : eval y (specializeFirstCoordinates (n := n) x F) = 0 := by
    rwa [eval_specializeFirstCoordinates]
  have hyn := eval_normalizeCoordinateRepresentative_eq_zero
    (hF.specializeFirstCoordinates_isHomogeneous x) y j hy
  rwa [eval_specializeFirstCoordinates] at hyn

/-- **G4 properness witness.**  Some smooth cubic fibre contains a point away from the conic
discriminant. -/
theorem exists_smoothCubicFiber_point_avoids_sndConicDiscriminant
    [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ x y : Fin 3 → k,
      x ≠ 0 ∧ y ≠ 0 ∧
        Standard.IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F) ∧
        eval y (specializeFirstCoordinates (n := 2) x F) = 0 ∧
        eval y (sndConicDiscriminant F) ≠ 0 := by
  obtain ⟨D, d, hD0, hd, hDhom, ⟨x₀, hx₀0, hx₀D⟩, hDsmooth⟩ :=
    exists_positive_homogeneous_smoothCubicFiber_open F hF hF0
  let Δ := sndConicDiscriminant F
  have hΔ0 : Δ ≠ 0 := sndConicDiscriminant_ne_zero_of_smooth F hF hF0
  have hΔhom : Δ.IsHomogeneous 9 := sndConicDiscriminant_isHomogeneous F hF
  let X := biprojectiveZeroLocus 2 2 k F
  let U : X.Opens := biprojectiveZeroLocusFst 2 2 k F ⁻¹ᵁ
    Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin 3) k) D
  let V : X.Opens := biprojectiveZeroLocusSnd 2 2 k F ⁻¹ᵁ
    Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin 3) k) Δ
  have hU : (U : Set X).Nonempty := by
    obtain ⟨i, hxi₀⟩ := exists_normalizing_coordinate x₀ hx₀0
    let x := normalizeCoordinateRepresentative x₀ i
    have hxi : x i = 1 := normalizeCoordinateRepresentative_apply x₀ i hxi₀
    have hxD : eval x D ≠ 0 := by
      rw [eval_normalizeCoordinateRepresentative_of_isHomogeneous hDhom]
      exact mul_ne_zero (pow_ne_zero d (inv_ne_zero hxi₀)) hx₀D
    obtain ⟨y₀, hy₀0, hxy₀⟩ :=
      exists_lift_firstProjection_of_smooth_bidegree23 k F hF hF0 i x hxi
    obtain ⟨j, hyj₀⟩ := exists_normalizing_coordinate y₀ hy₀0
    let y := normalizeCoordinateRepresentative y₀ j
    have hyj : y j = 1 := normalizeCoordinateRepresentative_apply y₀ j hyj₀
    have hxy : eval (Sum.elim x y) F = 0 :=
      eval_normalize_second_eq_zero_of_isBihomogeneous hF x y₀ j hxy₀
    let pt := zeroLocusPointOfNormalized 2 2 k F hF i j x y hxi hyj hxy
    refine ⟨pt (IsLocalRing.closedPoint k), ?_⟩
    change (pt ≫ biprojectiveZeroLocusFst 2 2 k F)
      (IsLocalRing.closedPoint k) ∈
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin 3) k) D
    rw [zeroLocusPointOfNormalized_fst 2 2 k F hF i j x y hxi hyj hxy]
    exact (ProjectiveSpace.pointOfNormalizedCoordinates_mem_basicOpen_iff
      2 k i x hxi D d hDhom hd).mpr hxD
  have hV : (V : Set X).Nonempty := by
    obtain ⟨y₀, hy₀Δ⟩ : ∃ y₀ : Fin 3 → k, eval y₀ Δ ≠ 0 := by
      by_contra h
      push_neg at h
      exact hΔ0 (hΔhom.eq_zero_of_forall_eval_eq_zero h)
    have hy₀0 : y₀ ≠ 0 := by
      intro hyzero
      subst y₀
      apply hy₀Δ
      have hscale := eval_smul_point_of_isHomogeneous hΔhom (0 : k)
        (fun _ : Fin 3 ↦ (1 : k))
      simpa using hscale
    obtain ⟨j, hyj₀⟩ := exists_normalizing_coordinate y₀ hy₀0
    let y := normalizeCoordinateRepresentative y₀ j
    have hyj : y j = 1 := normalizeCoordinateRepresentative_apply y₀ j hyj₀
    have hyΔ : eval y Δ ≠ 0 := by
      rw [eval_normalizeCoordinateRepresentative_of_isHomogeneous hΔhom]
      exact mul_ne_zero (pow_ne_zero 9 (inv_ne_zero hyj₀)) hy₀Δ
    obtain ⟨x₀, hx₀0, hxy₀⟩ :=
      exists_lift_secondProjection_of_smooth_bidegree23 k F hF hF0 j y hyj
    obtain ⟨i, hxi₀⟩ := exists_normalizing_coordinate x₀ hx₀0
    let x := normalizeCoordinateRepresentative x₀ i
    have hxi : x i = 1 := normalizeCoordinateRepresentative_apply x₀ i hxi₀
    have hxy : eval (Sum.elim x y) F = 0 :=
      eval_normalize_first_eq_zero_of_isBihomogeneous hF x₀ y i hxy₀
    let pt := zeroLocusPointOfNormalized 2 2 k F hF i j x y hxi hyj hxy
    refine ⟨pt (IsLocalRing.closedPoint k), ?_⟩
    change (pt ≫ biprojectiveZeroLocusSnd 2 2 k F)
      (IsLocalRing.closedPoint k) ∈
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin 3) k) Δ
    rw [zeroLocusPointOfNormalized_snd 2 2 k F hF i j x y hxi hyj hxy]
    exact (ProjectiveSpace.pointOfNormalizedCoordinates_mem_basicOpen_iff
      2 k j y hyj Δ 9 hΔhom (by omega)).mpr hyΔ
  letI : IsIntegral X :=
    isIntegral_biprojectiveZeroLocus_of_smooth_bidegree23 F hF hF0
  have hUV : ((U : Set X) ∩ (V : Set X)).Nonempty :=
    nonempty_preirreducible_inter U.isOpen V.isOpen hU hV
  letI : JacobsonSpace X :=
    LocallyOfFiniteType.jacobsonSpace (biprojectiveZeroLocusToSpec 2 2 k F)
  obtain ⟨z, hzUV, hzclosed⟩ := nonempty_inter_closedPoints hUV
    ((U.isOpen.inter V.isOpen).isLocallyClosed)
  obtain ⟨i, j, x, y, hxi, hyj, hxy, hxpoint, hypoint⟩ :=
    exists_normalized_coordinates_of_closedPoint_zeroLocus F hF z hzclosed
  have hxD : eval x D ≠ 0 := by
    apply (ProjectiveSpace.pointOfNormalizedCoordinates_mem_basicOpen_iff
      2 k i x hxi D d hDhom hd).mp
    rw [hxpoint]
    exact hzUV.1
  have hyΔ : eval y Δ ≠ 0 := by
    apply (ProjectiveSpace.pointOfNormalizedCoordinates_mem_basicOpen_iff
      2 k j y hyj Δ 9 hΔhom (by omega)).mp
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
  refine ⟨x, y, hx0, hy0, hDsmooth x hxD, ?_, ?_⟩
  · rwa [eval_specializeFirstCoordinates]
  · exact hyΔ

end

end BConicBundleMultisections
