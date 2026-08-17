/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.MultiProjectiveZeroLocus
public import V14Formalization.ProjNaturality
public import V14Formalization.InvariantSubschemeAction
public import BConicBundleMultisections.LinearCoordinateChange
public import BConicBundleMultisections.ProjectiveHypersurfaceScheme
public import BConicBundleMultisections.IdealSheafDescent
public import BConicBundleMultisections.ChartHomogenization
public import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Functor
public import Mathlib.AlgebraicGeometry.IdealSheaf.Functorial
public import Mathlib.AlgebraicGeometry.OpenImmersion

/-!
# Naturality of projective zero-locus ideals under linear coordinate change

Infrastructure for scheme-theoretic naturality of Problem B's projective
zero-locus ideal under Problem B's projective linear coordinate change.

## Direction (verified)

`mapLinearSubst n M N h = Proj.map (linearSubstGradedRingHom n M) _`.
By `linearSubstGradedRingHom_apply`, the graded map acts by
`aeval (linearSubst n M)`.  The transformed equation is therefore
`aeval (linearSubst n M) H`.

## Status

Proved: family ideal comparison from homogeneous spans; the linear Away cover of
`Proj`; the `awayι`/`Proj.map` pullback square; reduction of single-equation
naturality to Away-chart restriction; family lift and invariance packaging from
naturality + span inclusion.

Two Mathlib/B gates remain.  First, restriction of
`projectiveZeroLocusIdeal G` to a general degree-one Away chart must equal the
principal Away ideal of `G/s^d`; its precise type is recorded below.  The
special case `s = X i` is already
`projectiveZeroLocusIdeal_comap_standardChartι`.  Second, the principal affine
chart ideal must be pulled back along `Spec.map (Away.map ...)`; this is the
explicit `hchart` hypothesis of the chart-side theorem below.
-/

noncomputable section

universe u v

open CategoryTheory Limits
open scoped AlgebraicGeometry
open HomogeneousLocalization HomogeneousIdeal

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open AlgebraicGeometry.Proj
open MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra

variable {R : Type u} [CommRing R]

/-! ## Chart determination of ideal sheaves on projective space -/

def standardChartAffineOpen (n : ℕ) (i : Fin (n + 1)) :
    (ProjectiveSpace n R).affineOpens :=
  ⟨(ProjectiveSpace.standardChartι n R i).opensRange,
    isAffineOpen_opensRange (ProjectiveSpace.standardChartι n R i)⟩

theorem iSup_standardChartAffineOpen (n : ℕ) :
    ⨆ i : Fin (n + 1), (standardChartAffineOpen (R := R) n i).1 = ⊤ :=
  (ProjectiveSpace.standardAffineOpenCover n R).openCover.iSup_opensRange

theorem idealSheafData_eq_of_comap_standardChartι_eq (n : ℕ)
    {I J : (ProjectiveSpace n R).IdealSheafData}
    (H : ∀ i : Fin (n + 1),
      I.comap (ProjectiveSpace.standardChartι n R i) =
        J.comap (ProjectiveSpace.standardChartι n R i)) :
    I = J := by
  apply Scheme.IdealSheafData.ext_of_iSup_eq_top
    (standardChartAffineOpen (R := R) n) (iSup_standardChartAffineOpen n)
  intro i
  let f := ProjectiveSpace.standardChartι n R i
  let U : (Spec (.of (ProjectiveSpace.StandardChartRing n R i))).affineOpens :=
    ⟨⊤, isAffineOpen_top _⟩
  have h := congrArg (fun K => K.ideal U) (H i)
  rw [Scheme.IdealSheafData.ideal_comap_of_isOpenImmersion,
    Scheme.IdealSheafData.ideal_comap_of_isOpenImmersion] at h
  have h' := Ideal.comap_injective_of_surjective
    (f.appIso U).inv.hom
    (ConcreteCategory.bijective_of_isIso (f.appIso U).inv).2 h
  let V : (ProjectiveSpace n R).affineOpens :=
    ⟨f ''ᵁ U, U.2.image_of_isOpenImmersion f⟩
  have hV : standardChartAffineOpen (R := R) n i = V := by
    apply Subtype.ext
    exact (Scheme.Hom.image_top_eq_opensRange f).symm
  rw [hV]
  exact h'

theorem idealSheafData_le_of_comap_standardChartι_le (n : ℕ)
    {I J : (ProjectiveSpace n R).IdealSheafData}
    (H : ∀ i : Fin (n + 1),
      I.comap (ProjectiveSpace.standardChartι n R i) ≤
        J.comap (ProjectiveSpace.standardChartι n R i)) :
    I ≤ J := by
  apply sup_eq_right.mp
  apply idealSheafData_eq_of_comap_standardChartι_eq n
  intro i
  rw [Scheme.IdealSheafData.comap_sup]
  exact sup_eq_right.mpr (H i)

/-! ## Family ideals on charts -/

theorem familyIdeal_comap_standardChartι (n : ℕ)
    {ι : Type v} (F : ι → MvPolynomial (Fin (n + 1)) R)
    (d : ι → ℕ) (hF : ∀ j, (F j).IsHomogeneous (d j))
    (i : Fin (n + 1)) :
    (projectiveZeroLocusFamilyIdeal n R F).comap
        (ProjectiveSpace.standardChartι n R i) =
      ⨆ j, ProjectiveSpace.hypersurfaceChartIdealSheaf n R i (F j) := by
  rw [projectiveZeroLocusFamilyIdeal,
    (Scheme.IdealSheafData.map_gc
      (ProjectiveSpace.standardChartι n R i)).l_iSup]
  apply congrArg iSup
  funext j
  exact ProjectiveSpace.projectiveZeroLocusIdeal_comap_standardChartι
    n R (F j) (hF j) i

@[expose] public def chartSectionRingHom (n : ℕ) (i : Fin (n + 1)) :
    MvPolynomial (Fin (n + 1)) R →+*
      Γ(Spec (.of (ProjectiveSpace.StandardChartRing n R i)), ⊤) :=
  (ProjectiveSpace.hypersurfaceChartΓIso n R i).inv.hom.comp
    (MvPolynomial.aeval
      (fun l ↦ ProjectiveSpace.normalizedCoordinate n R i l)).toRingHom

@[simp] public theorem chartSectionRingHom_apply (n : ℕ) (i : Fin (n + 1))
    (H : MvPolynomial (Fin (n + 1)) R) :
    chartSectionRingHom n i H =
      ProjectiveSpace.hypersurfaceChartEquationSection n R i H :=
  rfl

theorem map_span_range_chartSection (n : ℕ)
    {ι : Type v} (F : ι → MvPolynomial (Fin (n + 1)) R)
    (i : Fin (n + 1)) :
    Ideal.map (chartSectionRingHom (R := R) n i)
        (Ideal.span (Set.range F)) =
      Ideal.span (Set.range
        (fun j ↦ ProjectiveSpace.hypersurfaceChartEquationSection n R i (F j))) := by
  rw [Ideal.map_span]
  congr 1
  ext x
  constructor
  · rintro ⟨_, ⟨j, rfl⟩, rfl⟩
    exact ⟨j, by simp⟩
  · rintro ⟨j, rfl⟩
    exact ⟨F j, ⟨j, rfl⟩, by simp⟩

theorem iSup_chartIdealSheaf_eq_of_span_eq (n : ℕ)
    {ι κ : Type v}
    (F : ι → MvPolynomial (Fin (n + 1)) R)
    (G : κ → MvPolynomial (Fin (n + 1)) R)
    (hspan : Ideal.span (Set.range F) = Ideal.span (Set.range G))
    (i : Fin (n + 1)) :
    (⨆ j, ProjectiveSpace.hypersurfaceChartIdealSheaf n R i (F j)) =
      ⨆ l, ProjectiveSpace.hypersurfaceChartIdealSheaf n R i (G l) := by
  apply Scheme.IdealSheafData.ext_of_isAffine
  rw [Scheme.IdealSheafData.ideal_iSup, Scheme.IdealSheafData.ideal_iSup]
  simp only [iSup_apply,
    ProjectiveSpace.hypersurfaceChartIdealSheaf_ideal_top]
  unfold ProjectiveSpace.hypersurfaceChartIdealTop
  rw [← Ideal.span_range_eq_iSup, ← Ideal.span_range_eq_iSup,
    ← map_span_range_chartSection (R := R) n F i,
    ← map_span_range_chartSection (R := R) n G i, hspan]

theorem iSup_chartIdealSheaf_le_of_span_le (n : ℕ)
    {ι κ : Type v}
    (F : ι → MvPolynomial (Fin (n + 1)) R)
    (G : κ → MvPolynomial (Fin (n + 1)) R)
    (hspan : Ideal.span (Set.range F) ≤ Ideal.span (Set.range G))
    (i : Fin (n + 1)) :
    (⨆ j, ProjectiveSpace.hypersurfaceChartIdealSheaf n R i (F j)) ≤
      ⨆ l, ProjectiveSpace.hypersurfaceChartIdealSheaf n R i (G l) := by
  apply (Scheme.IdealSheafData.equivOfIsAffine.toOrderIso.le_iff_le).mp
  change
    ((⨆ j, ProjectiveSpace.hypersurfaceChartIdealSheaf n R i (F j)).ideal
      ⟨⊤, isAffineOpen_top _⟩) ≤
    ((⨆ l, ProjectiveSpace.hypersurfaceChartIdealSheaf n R i (G l)).ideal
      ⟨⊤, isAffineOpen_top _⟩)
  rw [Scheme.IdealSheafData.ideal_iSup, Scheme.IdealSheafData.ideal_iSup]
  simp only [iSup_apply,
    ProjectiveSpace.hypersurfaceChartIdealSheaf_ideal_top]
  unfold ProjectiveSpace.hypersurfaceChartIdealTop
  rw [← Ideal.span_range_eq_iSup, ← Ideal.span_range_eq_iSup,
    ← map_span_range_chartSection (R := R) n F i,
    ← map_span_range_chartSection (R := R) n G i]
  exact Ideal.map_mono hspan

public theorem familyIdeal_eq_of_span_eq (n : ℕ)
    {ι κ : Type v}
    (F : ι → MvPolynomial (Fin (n + 1)) R)
    (G : κ → MvPolynomial (Fin (n + 1)) R)
    (dF : ι → ℕ) (hF : ∀ j, (F j).IsHomogeneous (dF j))
    (dG : κ → ℕ) (hG : ∀ l, (G l).IsHomogeneous (dG l))
    (hspan : Ideal.span (Set.range F) = Ideal.span (Set.range G)) :
    projectiveZeroLocusFamilyIdeal n R F =
      projectiveZeroLocusFamilyIdeal n R G := by
  apply idealSheafData_eq_of_comap_standardChartι_eq n
  intro i
  rw [familyIdeal_comap_standardChartι n F dF hF i,
    familyIdeal_comap_standardChartι n G dG hG i]
  exact iSup_chartIdealSheaf_eq_of_span_eq n F G hspan i

theorem familyIdeal_le_of_span_le (n : ℕ)
    {ι κ : Type v}
    (F : ι → MvPolynomial (Fin (n + 1)) R)
    (G : κ → MvPolynomial (Fin (n + 1)) R)
    (dF : ι → ℕ) (hF : ∀ j, (F j).IsHomogeneous (dF j))
    (dG : κ → ℕ) (hG : ∀ l, (G l).IsHomogeneous (dG l))
    (hspan : Ideal.span (Set.range F) ≤ Ideal.span (Set.range G)) :
    projectiveZeroLocusFamilyIdeal n R F ≤
      projectiveZeroLocusFamilyIdeal n R G := by
  apply idealSheafData_le_of_comap_standardChartι_le n
  intro i
  rw [familyIdeal_comap_standardChartι n F dF hF i,
    familyIdeal_comap_standardChartι n G dG hG i]
  exact iSup_chartIdealSheaf_le_of_span_le n F G hspan i

/-! ## Linear Away charts and the Proj pullback square -/

public abbrev coordGraded (n : ℕ) :=
  MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R

public theorem linearSubstGradedRingHom_X (n : ℕ)
    (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (i : Fin (n + 1)) :
    (linearSubstGradedRingHom n M) (MvPolynomial.X i) = linearSubst n M i := by
  simp [linearSubstGradedRingHom_apply]

public theorem linearSubstGradedRingHom_eq_aeval (n : ℕ)
    (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (H : MvPolynomial (Fin (n + 1)) R) :
    (linearSubstGradedRingHom n M) H =
      (aeval (linearSubst n M) : _ →ₐ[R] _) H :=
  linearSubstGradedRingHom_apply n M H

/-- Away immersion for `D(f(Xᵢ))` under a linear graded map `f`.

Kept as an `abbrev` so open-immersion instances on `Proj.awayι` apply. -/
public abbrev linearAwayι (n : ℕ)
    (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (i : Fin (n + 1)) :
    Spec (.of (HomogeneousLocalization.Away (coordGraded (R := R) n)
      (linearSubstGradedRingHom n M (MvPolynomial.X i)))) ⟶
      ProjectiveSpace n R :=
  Proj.awayι (coordGraded (R := R) n)
    (linearSubstGradedRingHom n M (MvPolynomial.X i))
    ((linearSubstGradedRingHom n M).map_mem (MvPolynomial.isHomogeneous_X R i))
    zero_lt_one

public theorem linearAwayι_comp_mapLinearSubst (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    (i : Fin (n + 1)) :
    linearAwayι n M i ≫ mapLinearSubst n M N hNM =
      Spec.map (CommRingCat.ofHom
        (HomogeneousLocalization.Away.map
          (linearSubstGradedRingHom n M) (MvPolynomial.X i))) ≫
        ProjectiveSpace.standardChartι n R i := by
  unfold linearAwayι mapLinearSubst ProjectiveSpace.standardChartι
  exact Proj.awayι_comp_map (linearSubstGradedRingHom n M)
    (irrelevant_le_map_linearSubst n M N hNM)
    (s := MvPolynomial.X i) (hs := MvPolynomial.isHomogeneous_X R i)
    (hi := zero_lt_one)

public theorem opensRange_linearAwayι (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    (i : Fin (n + 1)) :
    (linearAwayι (R := R) n M i).opensRange =
      mapLinearSubst n M N hNM ⁻¹ᵁ
        (ProjectiveSpace.standardChartι n R i).opensRange := by
  unfold linearAwayι mapLinearSubst
  rw [Proj.opensRange_awayι, ProjectiveSpace.opensRange_standardChartι]
  unfold ProjectiveSpace.standardChart
  exact (Proj.map_preimage_basicOpen (linearSubstGradedRingHom n M)
    (irrelevant_le_map_linearSubst n M N hNM) (MvPolynomial.X i)).symm

theorem isPullback_linearAwayι_mapLinearSubst (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    (i : Fin (n + 1)) :
    IsPullback
      (Spec.map (CommRingCat.ofHom
        (HomogeneousLocalization.Away.map
          (linearSubstGradedRingHom n M) (MvPolynomial.X i))))
      (linearAwayι n M i)
      (ProjectiveSpace.standardChartι n R i)
      (mapLinearSubst n M N hNM) := by
  refine IsOpenImmersion.isPullback _ _ _ _
    (linearAwayι_comp_mapLinearSubst n M N hNM i) ?_
  exact (opensRange_linearAwayι n M N hNM i).symm

theorem iSup_opensRange_linearAwayι (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1) :
    ⨆ i : Fin (n + 1), (linearAwayι (R := R) n M i).opensRange = ⊤ := by
  have hstd :
      ⨆ i : Fin (n + 1), (ProjectiveSpace.standardChartι n R i).opensRange = ⊤ :=
    (ProjectiveSpace.standardAffineOpenCover n R).openCover.iSup_opensRange
  have hpre :
      ⨆ i : Fin (n + 1),
          mapLinearSubst n M N hNM ⁻¹ᵁ
            (ProjectiveSpace.standardChartι n R i).opensRange = ⊤ := by
    rw [← Scheme.Hom.preimage_iSup, hstd]
    simp
  simp_rw [opensRange_linearAwayι n M N hNM]
  exact hpre

/-! ## Away principal ideals -/

@[expose] public def awayChartΓIso (n : ℕ)
    (s : MvPolynomial (Fin (n + 1)) R) :
    Γ(Spec (.of (HomogeneousLocalization.Away (coordGraded (R := R) n) s)), ⊤) ≅
      .of (HomogeneousLocalization.Away (coordGraded (R := R) n) s) :=
  Scheme.ΓSpecIso _

/-- Degree-zero form `H / s^d` in an Away chart. -/
@[expose] public def awayEquation (n : ℕ)
    {d : ℕ} (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1)
    (H : MvPolynomial (Fin (n + 1)) R) (hH : H ∈ coordGraded (R := R) n d) :
    HomogeneousLocalization.Away (coordGraded (R := R) n) s :=
  HomogeneousLocalization.Away.mk (coordGraded (R := R) n) hs d H (by
    simpa [nsmul_one] using hH)

@[expose] public def awayEquationSection (n : ℕ)
    {d : ℕ} (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1)
    (H : MvPolynomial (Fin (n + 1)) R) (hH : H ∈ coordGraded (R := R) n d) :
    Γ(Spec (.of (HomogeneousLocalization.Away (coordGraded (R := R) n) s)), ⊤) :=
  (awayChartΓIso n s).inv (awayEquation n s hs H hH)

@[expose] public def awayHypersurfaceIdealSheaf (n : ℕ)
    {d : ℕ} (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1)
    (H : MvPolynomial (Fin (n + 1)) R) (hH : H ∈ coordGraded (R := R) n d) :
    (Spec (.of (HomogeneousLocalization.Away (coordGraded (R := R) n) s))).IdealSheafData :=
  Scheme.IdealSheafData.ofIdealTop (Ideal.span {awayEquationSection n s hs H hH})

public theorem Away_map_awayEquation (n : ℕ)
    (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (i : Fin (n + 1))
    {d : ℕ} (H : MvPolynomial (Fin (n + 1)) R)
    (hH : H ∈ coordGraded (R := R) n d) :
    HomogeneousLocalization.Away.map (linearSubstGradedRingHom n M) (MvPolynomial.X i)
        (awayEquation n (MvPolynomial.X i) (MvPolynomial.isHomogeneous_X R i) H hH) =
      awayEquation n
        (linearSubstGradedRingHom n M (MvPolynomial.X i))
        ((linearSubstGradedRingHom n M).map_mem (MvPolynomial.isHomogeneous_X R i))
        (linearSubstGradedRingHom n M H)
        ((linearSubstGradedRingHom n M).map_mem hH) := by
  simp only [awayEquation, HomogeneousLocalization.Away.map_mk]

/-! ## Missing gates and conditional naturality -/

/-- **Missing Mathlib/B theorem (precise statement).**

For `s` homogeneous of degree one and `G` homogeneous of degree `d`,

```
(ProjectiveSpace.projectiveZeroLocusIdeal n R G).comap
    (Proj.awayι (coordGraded n) s hs zero_lt_one)
  = awayHypersurfaceIdealSheaf n s hs G hG
```

as `IdealSheafData` on `Spec (Away s)`.

Known special case: `s = X i` is essentially
`projectiveZeroLocusIdeal_comap_standardChartι` once the chart equation is
identified with `Away.mk G (X i) d`.  The linear images
`s = linearSubstGradedRingHom M (X i)` are the instances needed for naturality
under `mapLinearSubst`.
-/
@[expose] public def missing_projectiveZeroLocusIdeal_comap_awayι
    (n : ℕ) {d : ℕ}
    (s : MvPolynomial (Fin (n + 1)) R)
    (hs : s ∈ coordGraded (R := R) n 1)
    (G : MvPolynomial (Fin (n + 1)) R)
    (hG : G ∈ coordGraded (R := R) n d) : Prop :=
  (ProjectiveSpace.projectiveZeroLocusIdeal n R G).comap
      (Proj.awayι (coordGraded (R := R) n) s hs zero_lt_one) =
    awayHypersurfaceIdealSheaf n s hs G hG

/-- Chart-side half of naturality, conditional on affine `Away.map` naturality of
the principal chart ideal. -/
public theorem projectiveZeroLocusIdeal_comap_linearAwayι_comp_mapLinearSubst_of_chart
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {d : ℕ} (H : MvPolynomial (Fin (n + 1)) R) (hH : H.IsHomogeneous d)
    (i : Fin (n + 1))
    (hchart :
      (ProjectiveSpace.hypersurfaceChartIdealSheaf n R i H).comap
          (Spec.map (CommRingCat.ofHom
            (HomogeneousLocalization.Away.map
              (linearSubstGradedRingHom n M) (MvPolynomial.X i)))) =
        awayHypersurfaceIdealSheaf n
          (linearSubstGradedRingHom n M (MvPolynomial.X i))
          ((linearSubstGradedRingHom n M).map_mem
            (MvPolynomial.isHomogeneous_X R i))
          (linearSubstGradedRingHom n M H)
          ((linearSubstGradedRingHom n M).map_mem hH)) :
    (ProjectiveSpace.projectiveZeroLocusIdeal n R H).comap
        (linearAwayι n M i ≫ mapLinearSubst n M N hNM) =
      awayHypersurfaceIdealSheaf n
        (linearSubstGradedRingHom n M (MvPolynomial.X i))
        ((linearSubstGradedRingHom n M).map_mem
          (MvPolynomial.isHomogeneous_X R i))
        (linearSubstGradedRingHom n M H)
        ((linearSubstGradedRingHom n M).map_mem hH) := by
  rw [linearAwayι_comp_mapLinearSubst n M N hNM i,
    Scheme.IdealSheafData.comap_comp,
    ProjectiveSpace.projectiveZeroLocusIdeal_comap_standardChartι n R H hH i]
  exact hchart

/-- Ideal sheaves on a scheme are determined by comap along a covering family of
open immersions from affine schemes. -/
public theorem idealSheafData_eq_of_comap_openImmersion_eq
    {X : Scheme.{u}} {ι : Type v}
    (Y : ι → Scheme.{u}) (f : ∀ i, Y i ⟶ X)
    [∀ i, IsOpenImmersion (f i)] [∀ i, IsAffine (Y i)]
    (hcover : ⨆ i, (f i).opensRange = ⊤)
    {I J : X.IdealSheafData}
    (H : ∀ i, I.comap (f i) = J.comap (f i)) :
    I = J := by
  let U : ι → X.affineOpens := fun i =>
    ⟨(f i).opensRange, isAffineOpen_opensRange (f i)⟩
  apply Scheme.IdealSheafData.ext_of_iSup_eq_top U hcover
  intro i
  let W : (Y i).affineOpens := ⟨⊤, isAffineOpen_top _⟩
  have h := congrArg (fun K => K.ideal W) (H i)
  rw [Scheme.IdealSheafData.ideal_comap_of_isOpenImmersion,
    Scheme.IdealSheafData.ideal_comap_of_isOpenImmersion] at h
  have h' := Ideal.comap_injective_of_surjective
    ((f i).appIso W).inv.hom
    (ConcreteCategory.bijective_of_isIso ((f i).appIso W).inv).2 h
  let V : X.affineOpens :=
    ⟨(f i) ''ᵁ W, W.2.image_of_isOpenImmersion (f i)⟩
  have hV : U i = V := by
    apply Subtype.ext
    exact (Scheme.Hom.image_top_eq_opensRange (f i)).symm
  rw [hV]
  exact h'

/-- Conditional single-equation naturality under linear coordinate change.

If both sides restrict along each linear Away chart `D(f(Xᵢ))` to the same
ideal sheaf, then they agree globally by the linear Away cover. -/
public theorem projectiveZeroLocusIdeal_comap_mapLinearSubst_of_away_restriction
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {d : ℕ} (H : MvPolynomial (Fin (n + 1)) R) (_hH : H.IsHomogeneous d)
    (hagree : ∀ i : Fin (n + 1),
      ((ProjectiveSpace.projectiveZeroLocusIdeal n R H).comap
          (mapLinearSubst n M N hNM)).comap (linearAwayι n M i) =
        (ProjectiveSpace.projectiveZeroLocusIdeal n R
          (linearSubstGradedRingHom n M H)).comap (linearAwayι n M i)) :
    (ProjectiveSpace.projectiveZeroLocusIdeal n R H).comap
        (mapLinearSubst n M N hNM) =
      ProjectiveSpace.projectiveZeroLocusIdeal n R
        (linearSubstGradedRingHom n M H) :=
  idealSheafData_eq_of_comap_openImmersion_eq
    (fun i : Fin (n + 1) =>
      Spec (.of (HomogeneousLocalization.Away (coordGraded (R := R) n)
        (linearSubstGradedRingHom n M (MvPolynomial.X i)))))
    (fun i => linearAwayι (R := R) n M i)
    (iSup_opensRange_linearAwayι n M N hNM)
    hagree

/-- Package chart-side naturality and Away-restriction into the agreement
hypothesis of the previous theorem. -/
public theorem comap_linearAwayι_agree_of_chart_and_away
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {d : ℕ} (H : MvPolynomial (Fin (n + 1)) R) (hH : H.IsHomogeneous d)
    (i : Fin (n + 1))
    (hchart :
      (ProjectiveSpace.projectiveZeroLocusIdeal n R H).comap
          (linearAwayι n M i ≫ mapLinearSubst n M N hNM) =
        awayHypersurfaceIdealSheaf n
          (linearSubstGradedRingHom n M (MvPolynomial.X i))
          ((linearSubstGradedRingHom n M).map_mem
            (MvPolynomial.isHomogeneous_X R i))
          (linearSubstGradedRingHom n M H)
          ((linearSubstGradedRingHom n M).map_mem hH))
    (haway :
      missing_projectiveZeroLocusIdeal_comap_awayι n
        (linearSubstGradedRingHom n M (MvPolynomial.X i))
        ((linearSubstGradedRingHom n M).map_mem
          (MvPolynomial.isHomogeneous_X R i))
        (linearSubstGradedRingHom n M H)
        ((linearSubstGradedRingHom n M).map_mem hH)) :
    ((ProjectiveSpace.projectiveZeroLocusIdeal n R H).comap
        (mapLinearSubst n M N hNM)).comap (linearAwayι n M i) =
      (ProjectiveSpace.projectiveZeroLocusIdeal n R
        (linearSubstGradedRingHom n M H)).comap (linearAwayι n M i) := by
  rw [← Scheme.IdealSheafData.comap_comp]
  rw [hchart]
  simpa [missing_projectiveZeroLocusIdeal_comap_awayι, linearAwayι] using haway.symm

/-! ## Family naturality from single-equation naturality -/

theorem projectiveZeroLocusFamilyIdeal_comap_mapLinearSubst_of_single (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {ι : Type v} (F : ι → MvPolynomial (Fin (n + 1)) R)
    (hsingle : ∀ j,
      (ProjectiveSpace.projectiveZeroLocusIdeal n R (F j)).comap
          (mapLinearSubst n M N hNM) =
        ProjectiveSpace.projectiveZeroLocusIdeal n R
          (linearSubstGradedRingHom n M (F j))) :
    (projectiveZeroLocusFamilyIdeal n R F).comap
        (mapLinearSubst n M N hNM) =
      projectiveZeroLocusFamilyIdeal n R
        (fun j ↦ linearSubstGradedRingHom n M (F j)) := by
  rw [projectiveZeroLocusFamilyIdeal, projectiveZeroLocusFamilyIdeal]
  rw [(Scheme.IdealSheafData.map_gc (mapLinearSubst n M N hNM)).l_iSup]
  apply congrArg iSup
  funext j
  exact hsingle j

/-- Family form with the `aeval` spelling of the transformed equations. -/
public theorem projectiveZeroLocusFamilyIdeal_comap_mapLinearSubst_aeval_of_single
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {ι : Type v} (F : ι → MvPolynomial (Fin (n + 1)) R)
    (hsingle : ∀ j,
      (ProjectiveSpace.projectiveZeroLocusIdeal n R (F j)).comap
          (mapLinearSubst n M N hNM) =
        ProjectiveSpace.projectiveZeroLocusIdeal n R
          ((aeval (linearSubst n M) : _ →ₐ[R] _) (F j))) :
    (projectiveZeroLocusFamilyIdeal n R F).comap
        (mapLinearSubst n M N hNM) =
      projectiveZeroLocusFamilyIdeal n R
        (fun j ↦ (aeval (linearSubst n M) : _ →ₐ[R] _) (F j)) := by
  convert projectiveZeroLocusFamilyIdeal_comap_mapLinearSubst_of_single n M N hNM F
    (fun j => by
      simpa [linearSubstGradedRingHom_eq_aeval] using hsingle j) using 2
  · funext j
    exact (linearSubstGradedRingHom_eq_aeval n M (F j)).symm

/-! ## Invariance endpoint -/

theorem familyIdeal_comap_mapLinearSubst_le_of_span_le (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {ι : Type v} (F : ι → MvPolynomial (Fin (n + 1)) R)
    (d : ι → ℕ) (hF : ∀ j, (F j).IsHomogeneous (d j))
    (hnat :
      (projectiveZeroLocusFamilyIdeal n R F).comap
          (mapLinearSubst n M N hNM) =
        projectiveZeroLocusFamilyIdeal n R
          (fun j ↦ (aeval (linearSubst n M) : _ →ₐ[R] _) (F j)))
    (hspan :
      Ideal.span (Set.range
          (fun j ↦ (aeval (linearSubst n M) : _ →ₐ[R] _) (F j))) ≤
        Ideal.span (Set.range F)) :
    (projectiveZeroLocusFamilyIdeal n R F).comap
        (mapLinearSubst n M N hNM) ≤
      projectiveZeroLocusFamilyIdeal n R F := by
  rw [hnat]
  have hFM : ∀ j,
      ((aeval (linearSubst n M) : _ →ₐ[R] _) (F j)).IsHomogeneous (d j) :=
    fun j ↦ isHomogeneous_aeval_linearSubst M (hF j)
  exact familyIdeal_le_of_span_le n
    (fun j ↦ (aeval (linearSubst n M) : _ →ₐ[R] _) (F j)) F
    d hFM d hF hspan

/-- Direct `of_comap_le` input: naturality plus span inclusion of the transformed
family yields pullback containment, which is the hypothesis of
`IsInvariantIdeal.of_comap_le`. -/
public theorem comap_le_projectiveZeroLocusFamilyIdeal_of_span_le (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hNM : N * M = 1)
    {ι : Type v} (F : ι → MvPolynomial (Fin (n + 1)) R)
    (d : ι → ℕ) (hF : ∀ j, (F j).IsHomogeneous (d j))
    (hnat :
      (projectiveZeroLocusFamilyIdeal n R F).comap
          (mapLinearSubst n M N hNM) =
        projectiveZeroLocusFamilyIdeal n R
          (fun j ↦ (aeval (linearSubst n M) : _ →ₐ[R] _) (F j)))
    (hspan :
      Ideal.span (Set.range
          (fun j ↦ (aeval (linearSubst n M) : _ →ₐ[R] _) (F j))) ≤
        Ideal.span (Set.range F)) :
    (projectiveZeroLocusFamilyIdeal n R F).comap (mapLinearSubst n M N hNM) ≤
      projectiveZeroLocusFamilyIdeal n R F :=
  familyIdeal_comap_mapLinearSubst_le_of_span_le n M N hNM F d hF hnat hspan

/-- Groupwise form of the `of_comap_le` hypothesis for a matrix action. -/
public theorem comap_le_projectiveZeroLocusFamilyIdeal_forall_of_span_le
    {G : Type v} [Group G] (n : ℕ)
    (ρ : G → Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (ρinv : G → Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (hρ : ∀ g, ρinv g * ρ g = 1)
    {ι : Type v} (F : ι → MvPolynomial (Fin (n + 1)) R)
    (d : ι → ℕ) (hF : ∀ j, (F j).IsHomogeneous (d j))
    (hnat : ∀ g,
      (projectiveZeroLocusFamilyIdeal n R F).comap
          (mapLinearSubst n (ρ g) (ρinv g) (hρ g)) =
        projectiveZeroLocusFamilyIdeal n R
          (fun j ↦ (aeval (linearSubst n (ρ g)) : _ →ₐ[R] _) (F j)))
    (hspan : ∀ g,
      Ideal.span (Set.range
          (fun j ↦ (aeval (linearSubst n (ρ g)) : _ →ₐ[R] _) (F j))) ≤
        Ideal.span (Set.range F)) :
    ∀ g : G,
      (projectiveZeroLocusFamilyIdeal n R F).comap
          (mapLinearSubst n (ρ g) (ρinv g) (hρ g)) ≤
        projectiveZeroLocusFamilyIdeal n R F :=
  fun g => comap_le_projectiveZeroLocusFamilyIdeal_of_span_le n
    (ρ g) (ρinv g) (hρ g) F d hF (hnat g) (hspan g)

/-- Re-export of `IsInvariantIdeal.of_comap_le` for discoverability: once
`comap_le_projectiveZeroLocusFamilyIdeal_forall_of_span_le` (or any other proof
of the `comap ≤` condition) is available for an ambient action, invariance
follows. -/
public theorem isInvariantIdeal_of_comap_le
    {G : Type v} [Group G]
    (A : Action Scheme G)
    (I : A.V.IdealSheafData)
    (h : ∀ g : G, I.comap (A.ρ g) ≤ I) :
    IsInvariantIdeal A I :=
  IsInvariantIdeal.of_comap_le h

end SchemeGeometry
end V14Formalization
