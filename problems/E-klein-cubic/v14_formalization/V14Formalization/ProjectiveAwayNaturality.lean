/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.ProjectiveFamilyNaturality
public import BConicBundleMultisections.BiprojectiveAffineChart
public import BConicBundleMultisections.LinearCoordinateChange
public import BConicBundleMultisections.ProjectiveHypersurfaceScheme
public import BConicBundleMultisections.IdealSheafDescent
public import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Functor
public import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic
public import Mathlib.AlgebraicGeometry.IdealSheaf.Functorial
public import Mathlib.AlgebraicGeometry.OpenImmersion
public import Mathlib.RingTheory.Ideal.Span
public import Mathlib.Algebra.Ring.Int.Defs

/-!
# Away-chart restriction of projective zero-locus ideals

Closes restriction of `ProjectiveSpace.projectiveZeroLocusIdeal` to an arbitrary
homogeneous degree-one Proj Away open, and the affine `Away.map` naturality of
principal chart ideals, yielding unconditional naturality under
`mapLinearSubst`.

## Route

1. Algebraic identification of standard-chart equations with `Away.mk`.
2. Affine `ofIdealTop` naturality; linear `Away.map` chart-side half (`hchart`).
3. Overlap unit ratio on `Away (s · Xᵢ)`: generators `G·Xᵢ^d` and `G·s^d` span
   the same principal ideal.
4. Open cover of `Spec (Away s)` by `Spec.map (awayMap · Xᵢ)`; both global ideals
   restrict equally on each chart of the cover.
5. Conclude general Away restriction, then unconditional `mapLinearSubst` naturality.
-/

noncomputable section

universe u v

open CategoryTheory Limits
open scoped AlgebraicGeometry
open HomogeneousLocalization HomogeneousIdeal
open AlgebraicGeometry BConicBundleMultisections
open AlgebraicGeometry.Proj
open MvPolynomial
open V14Formalization.SchemeGeometry

attribute [local instance] MvPolynomial.gradedAlgebra

namespace V14Formalization
namespace SchemeGeometry

variable {R : Type u} [CommRing R]

/-! ## Affine `ofIdealTop` naturality -/

lemma ofIdealTop_ideal_top {X : Scheme.{u}} [IsAffine X]
    (I : Ideal Γ(X, ⊤)) :
    (Scheme.IdealSheafData.ofIdealTop I).ideal
      (⟨⊤, isAffineOpen_top X⟩ : X.affineOpens) = I := by
  simp [Scheme.IdealSheafData.ofIdealTop_ideal]

/-- Pullback of a global-sections ideal sheaf along a morphism of affine schemes is
the extended ideal. -/
theorem comap_ofIdealTop_eq_ofIdealTop_map
    {X Y : Scheme.{u}} [IsAffine X] [IsAffine Y]
    (I : Ideal Γ(Y, ⊤)) (f : X ⟶ Y) :
    (Scheme.IdealSheafData.ofIdealTop I).comap f =
      Scheme.IdealSheafData.ofIdealTop (Ideal.map f.appTop.hom I) := by
  apply le_antisymm
  · rw [← Scheme.IdealSheafData.le_map_iff_comap_le]
    refine Scheme.IdealSheafData.le_of_isAffine (X := Y) ?_
    conv_lhs => rw [ofIdealTop_ideal_top]
    rw [Scheme.IdealSheafData.ideal_map_of_isAffineHom]
    rw [Scheme.IdealSheafData.ofIdealTop_ideal]
    rw [← Ideal.map_le_iff_le_comap, Ideal.map_map]
    apply le_of_eq
    congr 1
    apply RingHom.ext
    intro x
    have hres :
        X.presheaf.map
          (homOfLE (le_top : (f ⁻¹ᵁ (⊤ : Y.Opens)) ≤ ⊤)).op =
            𝟙 _ := by
      rw [← X.presheaf.map_id]
      exact congrArg X.presheaf.map (Subsingleton.elim _ _)
    rw [hres]
    rfl
  · refine Scheme.IdealSheafData.le_of_isAffine (X := X) ?_
    conv_lhs => rw [ofIdealTop_ideal_top]
    rw [Scheme.IdealSheafData.comap]
    change Ideal.map f.appTop.hom I ≤
      (pullback.fst f
        (Scheme.IdealSheafData.ofIdealTop I).subschemeι).ker.ideal
          (⟨⊤, isAffineOpen_top X⟩ : X.affineOpens)
    rw [Scheme.Hom.ker_apply]
    rw [Ideal.map_le_iff_le_comap]
    intro x hx
    change (pullback.fst f
      (Scheme.IdealSheafData.ofIdealTop I).subschemeι).appTop.hom
        (f.appTop.hom x) = 0
    have hxker :
        (Scheme.IdealSheafData.ofIdealTop I).subschemeι.appTop.hom x = 0 := by
      rw [← RingHom.mem_ker]
      rw [show RingHom.ker
          (Scheme.IdealSheafData.ofIdealTop I).subschemeι.appTop.hom = I by
        have hker := congrArg
          (fun K : Y.IdealSheafData =>
            K.ideal (⟨⊤, isAffineOpen_top Y⟩ : Y.affineOpens))
          (Scheme.IdealSheafData.ker_subschemeι
            (Scheme.IdealSheafData.ofIdealTop I))
        rw [Scheme.Hom.ker_apply, ofIdealTop_ideal_top] at hker
        exact hker]
      exact hx
    have hsq := pullback.condition (f := f)
      (g := (Scheme.IdealSheafData.ofIdealTop I).subschemeι)
    have happ := congrArg Scheme.Hom.appTop hsq
    simpa only [Scheme.Hom.comp_appTop, CommRingCat.hom_comp,
      RingHom.coe_comp, Function.comp_apply, hxker, map_zero] using
      congrArg (fun q => q.hom x) happ

/-! ## Standard-chart algebraic bridge -/

/-- Evaluating a homogeneous form at normalized chart coordinates is `Away.mk`. -/
theorem aeval_normalizedCoordinate_eq_Away_mk
    (n : ℕ) (i : Fin (n + 1))
    {d : ℕ} (G : MvPolynomial (Fin (n + 1)) R) (hG : G.IsHomogeneous d) :
    (aeval (fun l => ProjectiveSpace.normalizedCoordinate n R i l) G) =
      HomogeneousLocalization.Away.mk (coordGraded (R := R) n)
        (MvPolynomial.isHomogeneous_X R i) d G (by simpa using hG) := by
  have hcomp :=
    ProjectiveSpace.mvPolynomialToStandardChart_comp_chartDehomogenization n R i
  have hmk :=
    ProjectiveSpace.mvPolynomialToStandardChart_chartDehomogenization_of_isHomogeneous
      n R i hG
  have : aeval (fun l => ProjectiveSpace.normalizedCoordinate n R i l) G =
      ProjectiveSpace.mvPolynomialToStandardChart n R i
        (ProjectiveSpace.chartDehomogenization n R i G) := by
    rw [← AlgHom.comp_apply, hcomp]
  rw [this, hmk]

theorem hypersurfaceChartEquation_eq_awayEquation
    (n : ℕ) (i : Fin (n + 1))
    {d : ℕ} (G : MvPolynomial (Fin (n + 1)) R) (hG : G.IsHomogeneous d) :
    ProjectiveSpace.hypersurfaceChartEquation n R i G =
      awayEquation (R := R) n (MvPolynomial.X i)
        (MvPolynomial.isHomogeneous_X R i) G hG := by
  simpa [awayEquation, ProjectiveSpace.hypersurfaceChartEquation] using
    aeval_normalizedCoordinate_eq_Away_mk n i G hG

theorem hypersurfaceChartEquationSection_eq_awayEquationSection
    (n : ℕ) (i : Fin (n + 1))
    {d : ℕ} (G : MvPolynomial (Fin (n + 1)) R) (hG : G.IsHomogeneous d) :
    ProjectiveSpace.hypersurfaceChartEquationSection n R i G =
      awayEquationSection (R := R) n (MvPolynomial.X i)
        (MvPolynomial.isHomogeneous_X R i) G hG := by
  simp only [ProjectiveSpace.hypersurfaceChartEquationSection, awayEquationSection,
    ProjectiveSpace.hypersurfaceChartΓIso, awayChartΓIso]
  congr 1
  exact hypersurfaceChartEquation_eq_awayEquation n i G hG

theorem hypersurfaceChartIdealTop_eq_away_span
    (n : ℕ) (i : Fin (n + 1))
    {d : ℕ} (G : MvPolynomial (Fin (n + 1)) R) (hG : G.IsHomogeneous d) :
    ProjectiveSpace.hypersurfaceChartIdealTop n R i G =
      Ideal.span
        {awayEquationSection (R := R) n (MvPolynomial.X i)
          (MvPolynomial.isHomogeneous_X R i) G hG} := by
  simp only [ProjectiveSpace.hypersurfaceChartIdealTop]
  rw [hypersurfaceChartEquationSection_eq_awayEquationSection n i G hG]

/-- Standard-chart principal ideal sheaf equals the Away hypersurface ideal sheaf. -/
theorem hypersurfaceChartIdealSheaf_eq_awayHypersurfaceIdealSheaf
    (n : ℕ) (i : Fin (n + 1))
    {d : ℕ} (G : MvPolynomial (Fin (n + 1)) R) (hG : G.IsHomogeneous d) :
    ProjectiveSpace.hypersurfaceChartIdealSheaf n R i G =
      awayHypersurfaceIdealSheaf (R := R) n (MvPolynomial.X i)
        (MvPolynomial.isHomogeneous_X R i) G hG := by
  simp only [ProjectiveSpace.hypersurfaceChartIdealSheaf, awayHypersurfaceIdealSheaf]
  congr 1
  exact hypersurfaceChartIdealTop_eq_away_span n i G hG

/-- **Away restriction on standard charts.**

`projectiveZeroLocusIdeal` restricts along `awayι (Xᵢ)` (i.e. `standardChartι`) to the
principal Away ideal of `G / Xᵢ^d`. -/
theorem projectiveZeroLocusIdeal_comap_awayι_X
    (n : ℕ) (i : Fin (n + 1))
    {d : ℕ} (G : MvPolynomial (Fin (n + 1)) R) (hG : G.IsHomogeneous d) :
    (ProjectiveSpace.projectiveZeroLocusIdeal n R G).comap
        (ProjectiveSpace.standardChartι n R i) =
      awayHypersurfaceIdealSheaf (R := R) n (MvPolynomial.X i)
        (MvPolynomial.isHomogeneous_X R i) G hG := by
  rw [ProjectiveSpace.projectiveZeroLocusIdeal_comap_standardChartι n R G hG i]
  exact hypersurfaceChartIdealSheaf_eq_awayHypersurfaceIdealSheaf n i G hG

/-- The Problem-B missing-prop instance for every standard chart. -/
theorem missing_projectiveZeroLocusIdeal_comap_awayι_X
    (n : ℕ) (i : Fin (n + 1))
    {d : ℕ} (G : MvPolynomial (Fin (n + 1)) R) (hG : G.IsHomogeneous d) :
    missing_projectiveZeroLocusIdeal_comap_awayι (R := R) n
      (MvPolynomial.X i) (MvPolynomial.isHomogeneous_X R i) G hG := by
  simpa [missing_projectiveZeroLocusIdeal_comap_awayι,
    ProjectiveSpace.standardChartι] using
    projectiveZeroLocusIdeal_comap_awayι_X n i G hG

/-! ## Affine `Away.map` naturality of principal chart ideals (`hchart`) -/

theorem map_appTop_ΓSpecIso_inv
    {A B : Type u} [CommRing A] [CommRing B] (φ : A →+* B) (a : A) :
    (Spec.map (CommRingCat.ofHom φ)).appTop.hom
        ((Scheme.ΓSpecIso (.of A)).inv a) =
      (Scheme.ΓSpecIso (.of B)).inv (φ a) := by
  have hnat := Scheme.ΓSpecIso_inv_naturality (CommRingCat.ofHom φ)
  have happ :=
    congrArg (fun f : CommRingCat.of A ⟶ Γ(Spec (.of B), ⊤) => f.hom a) hnat
  change
      (Scheme.ΓSpecIso (.of B)).inv.hom (φ a) =
        (Spec.map (CommRingCat.ofHom φ)).appTop.hom
          ((Scheme.ΓSpecIso (.of A)).inv.hom a) at happ
  exact happ.symm

theorem Ideal_map_span_ΓSpecIso_inv
    {A B : Type u} [CommRing A] [CommRing B] (φ : A →+* B) (a : A) :
    Ideal.map (Spec.map (CommRingCat.ofHom φ)).appTop.hom
        (Ideal.span {(Scheme.ΓSpecIso (.of A)).inv a}) =
      Ideal.span {(Scheme.ΓSpecIso (.of B)).inv (φ a)} := by
  rw [Ideal.map_span, Set.image_singleton, map_appTop_ΓSpecIso_inv]

/-- Principal chart ideal sheaves pull back along `Spec.map (Away.map f)` to the
Away hypersurface ideal of the image equation. -/
theorem hypersurfaceChartIdealSheaf_comap_Away_map
    (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (i : Fin (n + 1))
    {d : ℕ} (H : MvPolynomial (Fin (n + 1)) R) (hH : H.IsHomogeneous d) :
    (ProjectiveSpace.hypersurfaceChartIdealSheaf n R i H).comap
        (Spec.map (CommRingCat.ofHom
          (HomogeneousLocalization.Away.map
            (linearSubstGradedRingHom n M) (MvPolynomial.X i)))) =
      awayHypersurfaceIdealSheaf n
        (linearSubstGradedRingHom n M (MvPolynomial.X i))
        ((linearSubstGradedRingHom n M).map_mem
          (MvPolynomial.isHomogeneous_X R i))
        (linearSubstGradedRingHom n M H)
        ((linearSubstGradedRingHom n M).map_mem hH) := by
  let φ :=
    HomogeneousLocalization.Away.map (linearSubstGradedRingHom n M) (MvPolynomial.X i)
  let A := ProjectiveSpace.StandardChartRing n R i
  let B :=
    HomogeneousLocalization.Away (coordGraded (R := R) n)
      (linearSubstGradedRingHom n M (MvPolynomial.X i))
  simp only [ProjectiveSpace.hypersurfaceChartIdealSheaf,
    ProjectiveSpace.hypersurfaceChartIdealTop, awayHypersurfaceIdealSheaf]
  rw [comap_ofIdealTop_eq_ofIdealTop_map]
  apply congrArg Scheme.IdealSheafData.ofIdealTop
  -- `hypersurfaceChartEquationSection = ΓSpecIso.inv (equation)`
  have hsec :
      ProjectiveSpace.hypersurfaceChartEquationSection n R i H =
        (Scheme.ΓSpecIso (.of A)).inv
          (ProjectiveSpace.hypersurfaceChartEquation n R i H) :=
    rfl
  rw [hsec, Ideal_map_span_ΓSpecIso_inv φ]
  apply congrArg (fun t => Ideal.span {t})
  -- Map the chart equation through Away.map, identify with Away equation section.
  have heq := hypersurfaceChartEquation_eq_awayEquation n i H hH
  rw [heq, Away_map_awayEquation n M i H hH]
  rfl

/-- Alias matching the `hchart` hypothesis of
`projectiveZeroLocusIdeal_comap_linearAwayι_comp_mapLinearSubst_of_chart`. -/
theorem hypersurfaceChartIdealSheaf_comap_Away_map_linearSubst
    (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (i : Fin (n + 1))
    {d : ℕ} (H : MvPolynomial (Fin (n + 1)) R) (hH : H.IsHomogeneous d) :
    (ProjectiveSpace.hypersurfaceChartIdealSheaf n R i H).comap
        (Spec.map (CommRingCat.ofHom
          (HomogeneousLocalization.Away.map
            (linearSubstGradedRingHom n M) (MvPolynomial.X i)))) =
      awayHypersurfaceIdealSheaf n
        (linearSubstGradedRingHom n M (MvPolynomial.X i))
        ((linearSubstGradedRingHom n M).map_mem
          (MvPolynomial.isHomogeneous_X R i))
        (linearSubstGradedRingHom n M H)
        ((linearSubstGradedRingHom n M).map_mem hH) :=
  hypersurfaceChartIdealSheaf_comap_Away_map n M i H hH

/-- Chart-side half of naturality, now unconditional. -/
theorem projectiveZeroLocusIdeal_comap_linearAwayι_comp_mapLinearSubst
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {d : ℕ} (H : MvPolynomial (Fin (n + 1)) R) (hH : H.IsHomogeneous d)
    (i : Fin (n + 1)) :
    (ProjectiveSpace.projectiveZeroLocusIdeal n R H).comap
        (linearAwayι n M i ≫ mapLinearSubst n M N hNM) =
      awayHypersurfaceIdealSheaf n
        (linearSubstGradedRingHom n M (MvPolynomial.X i))
        ((linearSubstGradedRingHom n M).map_mem
          (MvPolynomial.isHomogeneous_X R i))
        (linearSubstGradedRingHom n M H)
        ((linearSubstGradedRingHom n M).map_mem hH) :=
  projectiveZeroLocusIdeal_comap_linearAwayι_comp_mapLinearSubst_of_chart n M N hNM H hH i
    (hypersurfaceChartIdealSheaf_comap_Away_map_linearSubst n M i H hH)

/-! ## Overlap algebra on `Away (s · Xᵢ)` -/

private theorem nsmul_two_eq (d : ℕ) : (d • 2 : ℕ) = d + d • 1 := by
  rw [nsmul_eq_mul (α := ℕ) d 2, nsmul_eq_mul (α := ℕ) d 1, mul_one]
  exact Nat.mul_two d

public theorem mem_coordGraded_X (n : ℕ) (i : Fin (n + 1)) :
    (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R) ∈ coordGraded (R := R) n 1 :=
  MvPolynomial.isHomogeneous_X R i

public theorem mem_coordGraded_s_mul_X
    (n : ℕ) {s : MvPolynomial (Fin (n + 1)) R}
    (hs : s ∈ coordGraded (R := R) n 1) (i : Fin (n + 1)) :
    s * MvPolynomial.X i ∈ coordGraded (R := R) n 2 := by
  change s * MvPolynomial.X i ∈ coordGraded (R := R) n (1 + 1)
  exact SetLike.mul_mem_graded hs (mem_coordGraded_X (R := R) n i)

public theorem mem_coordGraded_G_mul_s_pow
    (n : ℕ) {d : ℕ} {G : MvPolynomial (Fin (n + 1)) R}
    (hG : G ∈ coordGraded (R := R) n d)
    {s : MvPolynomial (Fin (n + 1)) R} (hs : s ∈ coordGraded (R := R) n 1) :
    G * s ^ d ∈ coordGraded (R := R) n (d • 2) := by
  rw [nsmul_two_eq d]
  exact SetLike.mul_mem_graded hG (SetLike.pow_mem_graded d hs)

public theorem mem_coordGraded_G_mul_X_pow
    (n : ℕ) {d : ℕ} {G : MvPolynomial (Fin (n + 1)) R}
    (hG : G ∈ coordGraded (R := R) n d) (i : Fin (n + 1)) :
    G * MvPolynomial.X i ^ d ∈ coordGraded (R := R) n (d • 2) := by
  rw [nsmul_two_eq d]
  exact SetLike.mul_mem_graded hG
    (SetLike.pow_mem_graded d (mem_coordGraded_X (R := R) n i))

/-- On `Away (s · Xᵢ)`, the element `Xᵢ² / (s · Xᵢ)` is a unit (inverse `s² / (s · Xᵢ)`). -/
theorem isUnit_Away_mk_X_sq
    (n : ℕ) (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1) (i : Fin (n + 1)) :
    IsUnit
      (HomogeneousLocalization.Away.mk (coordGraded (R := R) n)
        (mem_coordGraded_s_mul_X (R := R) n hs i) 1
        (MvPolynomial.X i ^ 2) (by
          simpa [one_nsmul, pow_two] using
            SetLike.mul_mem_graded (mem_coordGraded_X (R := R) n i)
              (mem_coordGraded_X (R := R) n i))) := by
  set x := s * MvPolynomial.X i
  have hx : x ∈ coordGraded (R := R) n 2 :=
    mem_coordGraded_s_mul_X (R := R) n hs i
  let v : HomogeneousLocalization.Away (coordGraded (R := R) n) x :=
    HomogeneousLocalization.Away.mk (coordGraded (R := R) n) hx 1 (s ^ 2) (by
      simpa [one_nsmul, pow_two] using SetLike.mul_mem_graded hs hs)
  refine isUnit_iff_exists_inv.mpr ⟨v, ?_⟩
  apply HomogeneousLocalization.val_injective (x := Submonoid.powers x)
  rw [HomogeneousLocalization.val_mul, HomogeneousLocalization.Away.val_mk,
    HomogeneousLocalization.Away.val_mk, HomogeneousLocalization.val_one,
    Localization.mk_mul]
  rw [show (MvPolynomial.X i ^ 2 * s ^ 2 : MvPolynomial (Fin (n + 1)) R) = x * x by
    change MvPolynomial.X i ^ 2 * s ^ 2 = (s * MvPolynomial.X i) * (s * MvPolynomial.X i)
    ring]
  rw [← Localization.mk_one]
  apply Localization.mk_eq_mk_iff.mpr
  refine Localization.r_iff_exists.mpr ⟨1, ?_⟩
  simp only [OneMemClass.coe_one, one_mul, mul_one, Submonoid.coe_mul]
  ring

/-- Principal generators `G · Xᵢ^d` and `G · s^d` in `Away (s · Xᵢ)` span the same ideal. -/
theorem span_Away_mk_G_X_eq_span_Away_mk_G_s
    (n : ℕ) (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1) (i : Fin (n + 1))
    {d : ℕ} (G : MvPolynomial (Fin (n + 1)) R)
    (hG : G ∈ coordGraded (R := R) n d) :
    Ideal.span
        {(HomogeneousLocalization.Away.mk (coordGraded (R := R) n)
          (mem_coordGraded_s_mul_X (R := R) n hs i) d
          (G * MvPolynomial.X i ^ d)
          (mem_coordGraded_G_mul_X_pow (R := R) n hG i))} =
      Ideal.span
        {(HomogeneousLocalization.Away.mk (coordGraded (R := R) n)
          (mem_coordGraded_s_mul_X (R := R) n hs i) d
          (G * s ^ d)
          (mem_coordGraded_G_mul_s_pow (R := R) n hG hs))} := by
  let hx := mem_coordGraded_s_mul_X (R := R) n hs i
  let u := HomogeneousLocalization.Away.mk (coordGraded (R := R) n) hx 1
    (MvPolynomial.X i ^ 2) (by
      simpa [one_nsmul, pow_two] using
        SetLike.mul_mem_graded (mem_coordGraded_X (R := R) n i)
          (mem_coordGraded_X (R := R) n i))
  have hu : IsUnit u := isUnit_Away_mk_X_sq (R := R) n s hs i
  let aX := HomogeneousLocalization.Away.mk (coordGraded (R := R) n) hx d
    (G * MvPolynomial.X i ^ d) (mem_coordGraded_G_mul_X_pow (R := R) n hG i)
  let aS := HomogeneousLocalization.Away.mk (coordGraded (R := R) n) hx d
    (G * s ^ d) (mem_coordGraded_G_mul_s_pow (R := R) n hG hs)
  have hrel : aX = u ^ d * aS := by
    apply HomogeneousLocalization.val_injective
      (x := Submonoid.powers (s * MvPolynomial.X i))
    rw [HomogeneousLocalization.val_mul, HomogeneousLocalization.val_pow]
    simp only [aX, aS, u, HomogeneousLocalization.Away.val_mk]
    rw [Localization.mk_pow, Localization.mk_mul]
    apply Localization.mk_eq_mk_iff.mpr
    refine Localization.r_iff_exists.mpr ⟨1, ?_⟩
    simp only [OneMemClass.coe_one, one_mul, Submonoid.coe_mul,
      SubmonoidClass.coe_pow]
    ring
  show Ideal.span {aX} = Ideal.span {aS}
  rw [hrel]
  exact Ideal.span_singleton_mul_left_unit (hu.pow d) aS

/-! ## Away overlap maps and open immersions -/

/-- Ring map `Away s → Away (s · Xᵢ)` from Mathlib's `awayMap`. -/
@[expose] public def awayMap_s_X (n : ℕ) (s : MvPolynomial (Fin (n + 1)) R)
    (_hs : s ∈ coordGraded (R := R) n 1) (i : Fin (n + 1)) :
    HomogeneousLocalization.Away (coordGraded (R := R) n) s →+*
      HomogeneousLocalization.Away (coordGraded (R := R) n) (s * MvPolynomial.X i) :=
  HomogeneousLocalization.awayMap (coordGraded (R := R) n)
    (mem_coordGraded_X (R := R) n i)
    (rfl : s * MvPolynomial.X i = s * MvPolynomial.X i)

/-- `Spec.map` of `awayMap_s_X` is an open immersion (pullback of `awayι`). -/
@[expose] public instance isOpenImmersion_SpecMap_awayMap_s_X
    (n : ℕ) (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1) (i : Fin (n + 1)) :
    IsOpenImmersion
      (Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs i))) := by
  have h := Proj.pullbackAwayιIso_inv_fst (coordGraded (R := R) n)
    hs zero_lt_one
    (mem_coordGraded_X (R := R) n i) zero_lt_one
    (rfl : s * MvPolynomial.X i = s * MvPolynomial.X i)
  dsimp [awayMap_s_X]
  exact h ▸ inferInstance

/-! ## General degree-one Away restriction -/

/-- Ring map `Away Xᵢ → Away (s · Xᵢ)` (right leg of the overlap square).

Matches Mathlib's `pullbackAwayιIso` right map: `awayMap` with roles of `s` and `Xᵢ`
swapped and `hx` transported by `mul_comm`. -/
@[expose] public def awayMap_X_s (n : ℕ) (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1) (i : Fin (n + 1)) :
    HomogeneousLocalization.Away (coordGraded (R := R) n) (MvPolynomial.X i) →+*
      HomogeneousLocalization.Away (coordGraded (R := R) n) (s * MvPolynomial.X i) :=
  HomogeneousLocalization.awayMap (coordGraded (R := R) n) hs
    (mul_comm s (MvPolynomial.X i))

public theorem awayMap_s_X_mk
    (n : ℕ) (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1) (i : Fin (n + 1))
    {d : ℕ} (G : MvPolynomial (Fin (n + 1)) R)
    (hG : G ∈ coordGraded (R := R) n d) :
    awayMap_s_X n s hs i (awayEquation (R := R) n s hs G hG) =
      HomogeneousLocalization.Away.mk (coordGraded (R := R) n)
        (mem_coordGraded_s_mul_X (R := R) n hs i) d
        (G * MvPolynomial.X i ^ d)
        (mem_coordGraded_G_mul_X_pow (R := R) n hG i) := by
  dsimp [awayMap_s_X, awayEquation]
  exact HomogeneousLocalization.awayMap_mk (coordGraded (R := R) n)
    (mem_coordGraded_X (R := R) n i)
    (rfl : s * MvPolynomial.X i = s * MvPolynomial.X i)
    (hf := hs) d G (by simpa [nsmul_one] using hG)

/- Module-system note: the `(by simpa using hG)` embedded in this STATEMENT
assigns the implicit degree metavariable of `awayEquation`. The exported
re-elaboration delays statement tactics on unassigned metavariables
(BuiltinTerm.lean:196, a private-data-leak guard), which makes it stuck.
The metavariable is the signature's own bound `d` — nothing private can
leak — so the backward flag safely restores the legacy behavior for this
one declaration. Statement unchanged. -/
set_option backward.proofsInPublic true in
public theorem awayMap_X_s_mk
    (n : ℕ) (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1) (i : Fin (n + 1))
    {d : ℕ} (G : MvPolynomial (Fin (n + 1)) R)
    (hG : G ∈ coordGraded (R := R) n d) :
    awayMap_X_s n s hs i
        (awayEquation (R := R) n (MvPolynomial.X i)
          (mem_coordGraded_X (R := R) n i) G (by simpa using hG)) =
      HomogeneousLocalization.Away.mk (coordGraded (R := R) n)
        (mem_coordGraded_s_mul_X (R := R) n hs i) d
        (G * s ^ d)
        (mem_coordGraded_G_mul_s_pow (R := R) n hG hs) := by
  dsimp [awayMap_X_s, awayEquation]
  exact HomogeneousLocalization.awayMap_mk (coordGraded (R := R) n) hs
    (mul_comm s (MvPolynomial.X i))
    (hf := mem_coordGraded_X (R := R) n i) d G (by simpa [nsmul_one] using hG)

/-- Overlap square: the two ways `Spec Away(s·Xᵢ) → Proj` agree. -/
public theorem awayMap_overlap_comp_eq
    (n : ℕ) (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1) (i : Fin (n + 1)) :
    Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs i)) ≫
        Proj.awayι (coordGraded (R := R) n) s hs zero_lt_one =
      Spec.map (CommRingCat.ofHom (awayMap_X_s n s hs i)) ≫
        ProjectiveSpace.standardChartι n R i := by
  -- Direct from Mathlib SpecMap_awayMap_awayι on each leg + mul_comm on the target.
  have hL := Proj.SpecMap_awayMap_awayι (coordGraded (R := R) n)
    hs zero_lt_one (mem_coordGraded_X (R := R) n i)
    (rfl : s * MvPolynomial.X i = s * MvPolynomial.X i)
  have hR := Proj.SpecMap_awayMap_awayι (coordGraded (R := R) n)
    (mem_coordGraded_X (R := R) n i) zero_lt_one hs
    (mul_comm s (MvPolynomial.X i))
  -- hL: Spec.map (awayMap_s_X) ≫ awayι s = awayι (s*Xi)
  -- hR: Spec.map (awayMap_X_s) ≫ awayι Xi = awayι (s*Xi)  (same x)
  -- standardChartι = awayι Xi
  dsimp [awayMap_s_X, awayMap_X_s] at *
  rw [hL, ProjectiveSpace.standardChartι, hR]

/-- Cover opens `D(Xᵢ/s) ⊆ Spec (Away s)` exhaust the Away chart. -/
theorem iSup_opensRange_awayMap_s_X
    (n : ℕ) (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1) :
    ⨆ i : Fin (n + 1),
      (Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs i))).opensRange = ⊤ := by
  let f := Proj.awayι (coordGraded (R := R) n) s hs zero_lt_one
  have hstd :
      ⨆ i : Fin (n + 1),
        (ProjectiveSpace.standardChartι n R i).opensRange = ⊤ :=
    (ProjectiveSpace.standardAffineOpenCover n R).openCover.iSup_opensRange
  have hpre :
      ⨆ i : Fin (n + 1),
        f ⁻¹ᵁ (ProjectiveSpace.standardChartι n R i).opensRange = ⊤ := by
    rw [← Scheme.Hom.preimage_iSup, hstd]
    simp
  have hcell : ∀ i : Fin (n + 1),
      (Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs i))).opensRange =
        f ⁻¹ᵁ (ProjectiveSpace.standardChartι n R i).opensRange := by
    intro i
    let e := Proj.pullbackAwayιIso (coordGraded (R := R) n)
      hs zero_lt_one (mem_coordGraded_X (R := R) n i) zero_lt_one
      (rfl : s * MvPolynomial.X i = s * MvPolynomial.X i)
    have hfst := Proj.pullbackAwayιIso_inv_fst (coordGraded (R := R) n)
      hs zero_lt_one (mem_coordGraded_X (R := R) n i) zero_lt_one
      (rfl : s * MvPolynomial.X i = s * MvPolynomial.X i)
    have hφ :
        Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs i)) =
          e.inv ≫ pullback.fst f (ProjectiveSpace.standardChartι n R i) := by
      dsimp [awayMap_s_X, e, f, ProjectiveSpace.standardChartι] at *
      exact hfst.symm
    -- Compare underlying ranges to avoid dependent `opensRange` rewrite
    apply TopologicalSpace.Opens.ext
    change Set.range
        (Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs i))).base =
      (f ⁻¹ᵁ (ProjectiveSpace.standardChartι n R i).opensRange).1
    have hbase :
        (Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs i))).base =
          (e.inv ≫ pullback.fst f (ProjectiveSpace.standardChartι n R i)).base :=
      by rw [hφ]
    rw [hbase, Scheme.Hom.comp_base, TopCat.coe_comp, Set.range_comp]
    have hsurj : Function.Surjective (e.inv).base :=
      e.inv.homeomorph.surjective
    rw [Set.range_eq_univ.mpr hsurj, Set.image_univ]
    -- range of pullback.fst = f ⁻¹ᵁ std.opensRange as sets
    have hr := Scheme.Hom.opensRange_pullbackFst
      (f := ProjectiveSpace.standardChartι n R i) (g := f)
    -- hr : opensRange (fst) = f ⁻¹ᵁ std.opensRange as Opens
    -- opensRange carrier = Set.range of base
    calc
      Set.range ⇑(pullback.fst f (ProjectiveSpace.standardChartι n R i)).base
          = (pullback.fst f (ProjectiveSpace.standardChartι n R i)).opensRange.carrier :=
            rfl
      _ = (f ⁻¹ᵁ (ProjectiveSpace.standardChartι n R i).opensRange).carrier :=
            congrArg TopologicalSpace.Opens.carrier hr
  simp_rw [hcell]
  exact hpre

/-- Principal chart ideal and Away hypersurface ideal agree after transport to
the overlap `Away (s · Xᵢ)`. -/
theorem awayHypersurface_comap_awayMap_eq_chart_comap
    (n : ℕ) (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1) (i : Fin (n + 1))
    {d : ℕ} (G : MvPolynomial (Fin (n + 1)) R)
    (hG : G ∈ coordGraded (R := R) n d) :
    (awayHypersurfaceIdealSheaf (R := R) n s hs G hG).comap
        (Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs i))) =
      (ProjectiveSpace.hypersurfaceChartIdealSheaf n R i G).comap
        (Spec.map (CommRingCat.ofHom (awayMap_X_s n s hs i))) := by
  simp only [awayHypersurfaceIdealSheaf, ProjectiveSpace.hypersurfaceChartIdealSheaf,
    ProjectiveSpace.hypersurfaceChartIdealTop]
  rw [comap_ofIdealTop_eq_ofIdealTop_map, comap_ofIdealTop_eq_ofIdealTop_map]
  apply congrArg Scheme.IdealSheafData.ofIdealTop
  have hsecS :
      awayEquationSection (R := R) n s hs G hG =
        (Scheme.ΓSpecIso
          (.of (HomogeneousLocalization.Away (coordGraded (R := R) n) s))).inv
          (awayEquation (R := R) n s hs G hG) :=
    rfl
  have hsecX :
      ProjectiveSpace.hypersurfaceChartEquationSection n R i G =
        (Scheme.ΓSpecIso
          (.of (ProjectiveSpace.StandardChartRing n R i))).inv
          (ProjectiveSpace.hypersurfaceChartEquation n R i G) :=
    rfl
  rw [hsecS, hsecX, Ideal_map_span_ΓSpecIso_inv (awayMap_s_X n s hs i),
    Ideal_map_span_ΓSpecIso_inv (awayMap_X_s n s hs i)]
  -- Now both are span {ΓSpecIso.inv (Away.mk ...)}
  have hL := awayMap_s_X_mk n s hs i G hG
  have hR : awayMap_X_s n s hs i
        (ProjectiveSpace.hypersurfaceChartEquation n R i G) =
      HomogeneousLocalization.Away.mk (coordGraded (R := R) n)
        (mem_coordGraded_s_mul_X (R := R) n hs i) d
        (G * s ^ d)
        (mem_coordGraded_G_mul_s_pow (R := R) n hG hs) := by
    rw [hypersurfaceChartEquation_eq_awayEquation n i G (by simpa using hG)]
    exact awayMap_X_s_mk n s hs i G hG
  -- Ideal.span of ΓSpecIso.inv of generators equals ofIdealTop-level comparison
  -- via injectivity of ΓSpecIso.inv as ring equiv and the unit span lemma
  have hspan := span_Away_mk_G_X_eq_span_Away_mk_G_s (R := R) n s hs i G hG
  rw [hL, hR]
  -- span {ΓSpec.inv a} = span {ΓSpec.inv b} if span {a} = span {b}, since ΓSpec.inv is iso
  let e := (Scheme.ΓSpecIso
    (.of (HomogeneousLocalization.Away (coordGraded (R := R) n)
      (s * MvPolynomial.X i)))).symm.commRingCatIsoToRingEquiv
  -- Actually ΓSpecIso : Γ(Spec A, ⊤) ≅ A, so .inv : A → Γ
  have hmap :
      Ideal.map
          (Scheme.ΓSpecIso
            (.of (HomogeneousLocalization.Away (coordGraded (R := R) n)
              (s * MvPolynomial.X i)))).inv.hom
          (Ideal.span
            {(HomogeneousLocalization.Away.mk (coordGraded (R := R) n)
              (mem_coordGraded_s_mul_X (R := R) n hs i) d
              (G * MvPolynomial.X i ^ d)
              (mem_coordGraded_G_mul_X_pow (R := R) n hG i))}) =
        Ideal.map
          (Scheme.ΓSpecIso
            (.of (HomogeneousLocalization.Away (coordGraded (R := R) n)
              (s * MvPolynomial.X i)))).inv.hom
          (Ideal.span
            {(HomogeneousLocalization.Away.mk (coordGraded (R := R) n)
              (mem_coordGraded_s_mul_X (R := R) n hs i) d
              (G * s ^ d)
              (mem_coordGraded_G_mul_s_pow (R := R) n hG hs))}) := by
    rw [hspan]
  simpa [Ideal.map_span, Set.image_singleton] using hmap

/-- Restriction of `projectiveZeroLocusIdeal` to an arbitrary homogeneous degree-one
Away open equals the principal Away hypersurface ideal. -/
public theorem projectiveZeroLocusIdeal_comap_awayι
    (n : ℕ) {d : ℕ}
    (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1)
    (G : MvPolynomial (Fin (n + 1)) R)
    (hG : G ∈ coordGraded (R := R) n d) :
    (ProjectiveSpace.projectiveZeroLocusIdeal n R G).comap
        (Proj.awayι (coordGraded (R := R) n) s hs zero_lt_one) =
      awayHypersurfaceIdealSheaf (R := R) n s hs G hG := by
  let I := ProjectiveSpace.projectiveZeroLocusIdeal n R G
  let f := Proj.awayι (coordGraded (R := R) n) s hs zero_lt_one
  let J := awayHypersurfaceIdealSheaf (R := R) n s hs G hG
  let coverY : Fin (n + 1) → Scheme.{u} := fun i =>
    Spec (.of (HomogeneousLocalization.Away (coordGraded (R := R) n)
      (s * MvPolynomial.X i)))
  let coverφ : ∀ i, coverY i ⟶
      Spec (.of (HomogeneousLocalization.Away (coordGraded (R := R) n) s)) :=
    fun i => Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs i))
  haveI : ∀ i, IsOpenImmersion (coverφ i) := fun i => by
    simpa [coverφ, awayMap_s_X] using isOpenImmersion_SpecMap_awayMap_s_X n s hs i
  haveI : ∀ i, IsAffine (coverY i) := fun _ => inferInstance
  refine idealSheafData_eq_of_comap_openImmersion_eq coverY coverφ
    (by simpa [coverφ] using iSup_opensRange_awayMap_s_X n s hs) ?_
  intro i
  -- (I.comap f).comap left = chartIdeal.comap right, by path equality
  have hpath := awayMap_overlap_comp_eq n s hs i
  have hI :
      (I.comap f).comap (coverφ i) =
        (I.comap (ProjectiveSpace.standardChartι n R i)).comap
          (Spec.map (CommRingCat.ofHom (awayMap_X_s n s hs i))) := by
    rw [← Scheme.IdealSheafData.comap_comp, ← Scheme.IdealSheafData.comap_comp]
    simpa [coverφ, f] using congrArg I.comap hpath
  rw [hI, ProjectiveSpace.projectiveZeroLocusIdeal_comap_standardChartι n R G
    (by simpa using hG) i]
  simpa [J, coverφ] using
    (awayHypersurface_comap_awayMap_eq_chart_comap n s hs i G hG).symm

/-- The missing-prop instance for every homogeneous degree-one Away open. -/
theorem missing_projectiveZeroLocusIdeal_comap_awayι_general
    (n : ℕ) {d : ℕ}
    (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1)
    (G : MvPolynomial (Fin (n + 1)) R)
    (hG : G ∈ coordGraded (R := R) n d) :
    missing_projectiveZeroLocusIdeal_comap_awayι (R := R) n s hs G hG :=
  projectiveZeroLocusIdeal_comap_awayι n s hs G hG

/-! ## Unconditional naturality under `mapLinearSubst` -/

theorem comap_linearAwayι_agree
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {d : ℕ} (H : MvPolynomial (Fin (n + 1)) R) (hH : H.IsHomogeneous d)
    (i : Fin (n + 1)) :
    ((ProjectiveSpace.projectiveZeroLocusIdeal n R H).comap
        (mapLinearSubst n M N hNM)).comap (linearAwayι n M i) =
      (ProjectiveSpace.projectiveZeroLocusIdeal n R
        (linearSubstGradedRingHom n M H)).comap (linearAwayι n M i) :=
  comap_linearAwayι_agree_of_chart_and_away n M N hNM H hH i
    (projectiveZeroLocusIdeal_comap_linearAwayι_comp_mapLinearSubst n M N hNM H hH i)
    (missing_projectiveZeroLocusIdeal_comap_awayι_general n
      (linearSubstGradedRingHom n M (MvPolynomial.X i))
      ((linearSubstGradedRingHom n M).map_mem (MvPolynomial.isHomogeneous_X R i))
      (linearSubstGradedRingHom n M H)
      ((linearSubstGradedRingHom n M).map_mem hH))

/-- Unconditional single-equation naturality under linear coordinate change. -/
public theorem projectiveZeroLocusIdeal_comap_mapLinearSubst
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {d : ℕ} (H : MvPolynomial (Fin (n + 1)) R) (hH : H.IsHomogeneous d) :
    (ProjectiveSpace.projectiveZeroLocusIdeal n R H).comap
        (mapLinearSubst n M N hNM) =
      ProjectiveSpace.projectiveZeroLocusIdeal n R
        (linearSubstGradedRingHom n M H) :=
  projectiveZeroLocusIdeal_comap_mapLinearSubst_of_away_restriction n M N hNM H hH
    (fun i => comap_linearAwayι_agree n M N hNM H hH i)

/-- Same with the `aeval` spelling of the transformed equation. -/
theorem projectiveZeroLocusIdeal_comap_mapLinearSubst_aeval
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {d : ℕ} (H : MvPolynomial (Fin (n + 1)) R) (hH : H.IsHomogeneous d) :
    (ProjectiveSpace.projectiveZeroLocusIdeal n R H).comap
        (mapLinearSubst n M N hNM) =
      ProjectiveSpace.projectiveZeroLocusIdeal n R
        ((aeval (linearSubst n M) : _ →ₐ[R] _) H) := by
  convert projectiveZeroLocusIdeal_comap_mapLinearSubst n M N hNM H hH using 2
  exact (linearSubstGradedRingHom_eq_aeval n M H).symm

/-- Unconditional naturality for a homogeneous family under a linear
coordinate change. -/
public theorem projectiveZeroLocusFamilyIdeal_comap_mapLinearSubst_aeval
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {ι : Type v} (F : ι → MvPolynomial (Fin (n + 1)) R)
    (d : ι → ℕ) (hF : ∀ j, (F j).IsHomogeneous (d j)) :
    (projectiveZeroLocusFamilyIdeal n R F).comap
        (mapLinearSubst n M N hNM) =
      projectiveZeroLocusFamilyIdeal n R
        (fun j ↦ (aeval (linearSubst n M) : _ →ₐ[R] _) (F j)) :=
  projectiveZeroLocusFamilyIdeal_comap_mapLinearSubst_aeval_of_single
    n M N hNM F (fun j ↦
      projectiveZeroLocusIdeal_comap_mapLinearSubst_aeval
        n M N hNM (F j) (hF j))

end SchemeGeometry
end V14Formalization
