/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.IntegralOpenCover
public import BConicBundleMultisections.IrreducibleHomogeneousChart
public import BConicBundleMultisections.ProjectiveHypersurfaceScheme
public import Mathlib.AlgebraicGeometry.FunctionField

/-!
# Integral projective hypersurfaces from irreducible homogeneous equations

For an irreducible positive-degree homogeneous equation in three variables, this file proves that
the scheme-theoretic projective zero locus constructed in `ProjectiveHypersurfaceScheme` is
integral.  Empty standard charts are discarded algebraically: the retained chart indices are
exactly those for which the dehomogenized equation is not a unit.  Every retained affine chart is
the spectrum of a domain, and its generic point lies in every other retained chart.  The
overlapping-chart criterion then gives global integrality.

The final section exposes the chart quotient and its fraction field as named objects.  These are
the function-field interfaces used by later arguments that compare rational functions written on
different standard charts.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial

namespace ProjectiveSpace

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k : Type u} [Field k]

/-! ## Nonempty affine charts -/

/-- The affine quotient ring on the `i`-th chart of the plane hypersurface `V(H)`. -/
abbrev HypersurfaceChartQuotient
    (H : MvPolynomial (Fin 3) k) (i : Fin 3) :=
  MvPolynomial (Fin 2) k ⧸ Ideal.span {chartDehomogenization 2 k i H}

/-- Standard-chart indices on which the dehomogenized equation is not a unit. -/
def NonemptyHypersurfaceChart
    (H : MvPolynomial (Fin 3) k) :=
  {i : Fin 3 // ¬ IsUnit (chartDehomogenization 2 k i H)}

/-- If a chart equation is a unit, its variable divides the original homogeneous equation. -/
theorem X_dvd_of_isUnit_chartDehomogenization
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (i : Fin 3)
    (hi : IsUnit (chartDehomogenization 2 k i H)) :
    MvPolynomial.X i ∣ H := by
  let g := chartDehomogenization 2 k i H
  have hgdeg : g.totalDegree = 0 :=
    (isUnit_iff_totalDegree_of_isReduced.mp hi).2
  have hrec : chartHomogenization (R := k) i d g = H :=
    chartHomogenization_chartDehomogenization i d H hH
  have hfac : H = MvPolynomial.X i ^ d *
      chartHomogenization (R := k) i 0 g := by
    rw [← hrec]
    simpa [hgdeg] using
      chartHomogenization_degree_change i 0 d g (Nat.zero_le d)
        (by simp [hgdeg])
  obtain ⟨e, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hd.ne'
  refine ⟨MvPolynomial.X i ^ e * chartHomogenization (R := k) i 0 g, ?_⟩
  rw [hfac, pow_succ]
  ac_rfl

/-- A unit chart equation forces the irreducible equation to divide that chart variable. -/
theorem dvd_X_of_isUnit_chartDehomogenization_of_irreducible
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : Fin 3) (hi : IsUnit (chartDehomogenization 2 k i H)) :
    H ∣ MvPolynomial.X i := by
  exact MvPolynomial.X_prime.irreducible.dvd_symm hHirr
    (X_dvd_of_isUnit_chartDehomogenization H hH hd i hi)

/-- On a nonempty chart, the irreducible homogeneous equation cannot divide the chart variable. -/
theorem not_dvd_X_of_not_isUnit_chartDehomogenization
    (H : MvPolynomial (Fin 3) k) (_hHirr : Irreducible H)
    (i : Fin 3) (hi : ¬ IsUnit (chartDehomogenization 2 k i H)) :
    ¬ H ∣ MvPolynomial.X i := by
  intro hdiv
  obtain ⟨q, hq⟩ := hdiv
  apply hi
  apply IsUnit.of_mul_eq_one (chartDehomogenization 2 k i q)
  have hmapped := congrArg (chartDehomogenization 2 k i) hq
  simpa only [map_mul, chartDehomogenization_X_self] using hmapped.symm

/-- An irreducible positive-degree ternary form has at least one nonempty standard chart. -/
theorem nonempty_nonemptyHypersurfaceChart
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H) :
    Nonempty (NonemptyHypersurfaceChart H) := by
  by_contra hempty
  have hall (i : Fin 3) : IsUnit (chartDehomogenization 2 k i H) := by
    by_contra hi
    exact hempty ⟨⟨i, hi⟩⟩
  have hX0H : MvPolynomial.X (0 : Fin 3) ∣ H :=
    X_dvd_of_isUnit_chartDehomogenization H hH hd 0 (hall 0)
  have hHX1 : H ∣ MvPolynomial.X (1 : Fin 3) :=
    dvd_X_of_isUnit_chartDehomogenization_of_irreducible
      H hH hd hHirr 1 (hall 1)
  have hX0X1 : MvPolynomial.X (0 : Fin 3) ∣
      MvPolynomial.X (1 : Fin 3) := dvd_trans hX0H hHX1
  have h01 : (0 : Fin 3) = 1 := MvPolynomial.X_dvd_X.mp hX0X1
  omega

/-- A point on a chartwise zero locus certifies that the chart equation is not a unit. -/
theorem not_isUnit_chartDehomogenization_of_chartPoint
    (H : MvPolynomial (Fin 3) k) (i : Fin 3)
    (z : (hypersurfaceChartIdealSheaf 2 k i H).subscheme) :
    ¬ IsUnit (chartDehomogenization 2 k i H) := by
  intro hi
  let A := HypersurfaceChartQuotient H i
  letI : Subsingleton A := Ideal.Quotient.subsingleton_iff.mpr
    (Ideal.span_singleton_eq_top.mpr hi)
  have hempty : IsEmpty (PrimeSpectrum A) :=
    PrimeSpectrum.isEmpty_iff_subsingleton.mpr inferInstance
  exact hempty.false
    ((hypersurfaceChartIsoSpecAffineQuotient 2 k i H).hom.base z)

/-! ## The integral chart cover -/

/-- The nonempty standard charts form an actual open cover of the projective hypersurface. -/
noncomputable def nonemptyHypersurfaceOpenCover
    (H : MvPolynomial (Fin 3) k) {d : ℕ} (hH : H.IsHomogeneous d) :
    (projectiveZeroLocus 2 k H).OpenCover :=
  Scheme.Cover.mkOfCovers (NonemptyHypersurfaceChart H)
    (fun i ↦ (hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme)
    (fun i ↦ hypersurfaceChartToGlobal 2 k H hH i.1)
    (fun x ↦ by
      have hx : (projectiveZeroLocusι 2 k H).base x ∈
          (⊤ : (ProjectiveSpace 2 k).Opens) := trivial
      rw [← (standardAffineOpenCover 2 k).openCover.iSup_opensRange] at hx
      obtain ⟨i, hi⟩ := TopologicalSpace.Opens.mem_iSup.mp hx
      have hi' : (projectiveZeroLocusι 2 k H).base x ∈ standardChart 2 k i := by
        change (projectiveZeroLocusι 2 k H).base x ∈
          (standardChartι 2 k i).opensRange at hi
        rwa [opensRange_standardChartι] at hi
      have hxchart : x ∈ (hypersurfaceChartToGlobal 2 k H hH i).opensRange := by
        rw [opensRange_hypersurfaceChartToGlobal]
        exact hi'
      have hxrange : x ∈ Set.range
          (hypersurfaceChartToGlobal 2 k H hH i).base := by
        rw [← Scheme.Hom.coe_opensRange]
        exact hxchart
      obtain ⟨z, hz⟩ := hxrange
      let ii : NonemptyHypersurfaceChart H :=
        ⟨i, not_isUnit_chartDehomogenization_of_chartPoint H i z⟩
      exact ⟨ii, z, hz⟩)

/-- Every retained standard chart of an irreducible hypersurface is integral. -/
theorem isIntegral_hypersurfaceChart_of_irreducible
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    IsIntegral ((hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme) := by
  letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  exact IsIntegral.of_isIso
    (hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H).inv

/-- The generic point of the explicit affine quotient on a retained hypersurface chart. -/
noncomputable def hypersurfaceAffineChartGenericPoint
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    Spec (.of (HypersurfaceChartQuotient H i.1)) := by
  letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  exact genericPoint _

/-- The image in the global projective hypersurface of a retained affine chart's generic point. -/
noncomputable def hypersurfaceGlobalChartGenericPoint
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    projectiveZeroLocus 2 k H :=
  (hypersurfaceChartToGlobal 2 k H hH i.1).base
    ((hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H).inv.base
      (hypersurfaceAffineChartGenericPoint H hH hHirr i))

/-! ## Generic points meet all retained charts -/

/-- The ambient image of one retained chart's generic point lies in every other retained
projective standard chart. -/
theorem hypersurfaceAffineChartGenericPoint_mem_standardChart_range
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i j : NonemptyHypersurfaceChart H) :
    (standardChartι 2 k i.1).base
        ((Spec.map (CommRingCat.ofHom
          (hypersurfaceAffineChartQuotientMap 2 k i.1 H))).base
            (hypersurfaceAffineChartGenericPoint H hH hHirr i)) ∈
      Set.range (standardChartι 2 k j.1) := by
  let A := HypersurfaceChartQuotient H i.1
  letI : IsDomain A :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  let φ : StandardChartRing 2 k i.1 →+* A :=
    hypersurfaceAffineChartQuotientMap 2 k i.1 H
  let η := hypersurfaceAffineChartGenericPoint H hH hHirr i
  change (standardChartι 2 k i.1).base
      ((Spec.map (CommRingCat.ofHom φ)).base η) ∈ _
  rw [← Scheme.Hom.coe_opensRange, opensRange_standardChartι]
  change (Spec.map (CommRingCat.ofHom φ)).base η ∈
    ((standardChartι 2 k i.1) ⁻¹ᵁ standardChart 2 k j.1 :
      (Spec (.of (StandardChartRing 2 k i.1))).Opens)
  change (Spec.map (CommRingCat.ofHom φ)).base η ∈
    (Proj.awayι _ (MvPolynomial.X i.1)
        (MvPolynomial.isHomogeneous_X k i.1) zero_lt_one ⁻¹ᵁ
      Proj.basicOpen _ (MvPolynomial.X j.1))
  have hXi : MvPolynomial.X i.1 ∈
      MvPolynomial.homogeneousSubmodule (Fin 3) k 1 := by
    simpa using MvPolynomial.isHomogeneous_X k i.1
  have hXj : MvPolynomial.X j.1 ∈
      MvPolynomial.homogeneousSubmodule (Fin 3) k 1 := by
    simpa using MvPolynomial.isHomogeneous_X k j.1
  rw [Proj.awayι_preimage_basicOpen
    (MvPolynomial.homogeneousSubmodule (Fin 3) k)
    hXi zero_lt_one hXj zero_lt_one]
  change PrimeSpectrum.comap φ η ∈
    PrimeSpectrum.basicOpen
      (HomogeneousLocalization.Away.isLocalizationElem hXi hXj)
  rw [PrimeSpectrum.mem_basicOpen]
  have htransition :
      HomogeneousLocalization.Away.isLocalizationElem hXi hXj =
        normalizedCoordinate 2 k i.1 j.1 := by
    unfold normalizedCoordinate
    change HomogeneousLocalization.Away.mk _ _ 1 (MvPolynomial.X j.1 ^ 1) _ = _
    simp only [pow_one]
  rw [htransition]
  intro hmem
  rw [PrimeSpectrum.comap_asIdeal] at hmem
  have hη : η = (⊥ : PrimeSpectrum A) := by
    change hypersurfaceAffineChartGenericPoint H hH hHirr i = _
    unfold hypersurfaceAffineChartGenericPoint
    exact genericPoint_eq_bot_of_affine (.of A)
  have heqzero : φ (normalizedCoordinate 2 k i.1 j.1) = 0 := by
    simpa [hη] using hmem
  have hcoord : φ (normalizedCoordinate 2 k i.1 j.1) =
      Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
        (chartDehomogenization 2 k i.1 (MvPolynomial.X j.1)) := by
    unfold φ hypersurfaceAffineChartQuotientMap
    change Ideal.Quotient.mk _
        (standardChartRingEquivMvPolynomial 2 k i.1
          (normalizedCoordinate 2 k i.1 j.1)) = _
    rw [standardChartRingEquivMvPolynomial_normalizedCoordinate_eq_chartDehomogenization_X]
  rw [hcoord] at heqzero
  exact quotient_mk_chartDehomogenization_ne_zero_of_not_dvd
    i.1 H (MvPolynomial.X j.1) hH hHirr
    (MvPolynomial.isHomogeneous_X k j.1) i.2
    (not_dvd_X_of_not_isUnit_chartDehomogenization H hHirr j.1 j.2) heqzero

/-- A retained chart's global generic point belongs to every retained hypersurface chart. -/
theorem hypersurfaceGlobalChartGenericPoint_mem_chart_range
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i j : NonemptyHypersurfaceChart H) :
    hypersurfaceGlobalChartGenericPoint H hH hHirr i ∈
      Set.range (hypersurfaceChartToGlobal 2 k H hH j.1).base := by
  let η := hypersurfaceAffineChartGenericPoint H hH hHirr i
  let ξ := (hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H).inv.base η
  have heq := congrArg
    (fun f : (hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme ⟶
        ProjectiveSpace 2 k ↦ f.base ξ)
    (hypersurfaceChartToGlobal_ι 2 k H hH i.1)
  have heq' := congrArg
    (fun f : (hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme ⟶
        Spec (.of (StandardChartRing 2 k i.1)) ↦ f.base ξ)
    (hypersurfaceChartIsoSpecAffineQuotient_hom_subschemeι 2 k i.1 H)
  have heqglobal :
      (projectiveZeroLocusι 2 k H).base
          (hypersurfaceGlobalChartGenericPoint H hH hHirr i) =
        (standardChartι 2 k i.1).base
          ((hypersurfaceChartIdealSheaf 2 k i.1 H).subschemeι.base ξ) := by
    simpa [hypersurfaceGlobalChartGenericPoint, η, ξ,
      Scheme.Hom.comp_apply] using heq
  have heqchart :
      (hypersurfaceChartIdealSheaf 2 k i.1 H).subschemeι.base ξ =
        (Spec.map (CommRingCat.ofHom
          (hypersurfaceAffineChartQuotientMap 2 k i.1 H))).base η := by
    simpa [η, ξ, Scheme.Hom.comp_apply] using heq'.symm
  have hambient :
      (projectiveZeroLocusι 2 k H).base
          (hypersurfaceGlobalChartGenericPoint H hH hHirr i) =
        (standardChartι 2 k i.1).base
          ((Spec.map (CommRingCat.ofHom
            (hypersurfaceAffineChartQuotientMap 2 k i.1 H))).base η) := by
    rw [heqglobal, heqchart]
  have hjambient :
      (projectiveZeroLocusι 2 k H).base
          (hypersurfaceGlobalChartGenericPoint H hH hHirr i) ∈
        standardChart 2 k j.1 := by
    rw [hambient]
    rw [← opensRange_standardChartι]
    exact (show _ ∈ Set.range (standardChartι 2 k j.1).base from
      hypersurfaceAffineChartGenericPoint_mem_standardChart_range
        H hH hHirr i j)
  have hjopen : hypersurfaceGlobalChartGenericPoint H hH hHirr i ∈
      (hypersurfaceChartToGlobal 2 k H hH j.1).opensRange := by
    rw [opensRange_hypersurfaceChartToGlobal]
    exact hjambient
  exact (show _ ∈ Set.range
    (hypersurfaceChartToGlobal 2 k H hH j.1).base from hjopen)

/-! ## Global integrality -/

/-- The scheme-theoretic projective zero locus of an irreducible positive-degree ternary
homogeneous polynomial is integral. -/
theorem isIntegral_projectiveZeroLocus_of_irreducible
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H) :
    IsIntegral (projectiveZeroLocus 2 k H) := by
  let U := nonemptyHypersurfaceOpenCover H hH
  letI : Nonempty (NonemptyHypersurfaceChart H) :=
    nonempty_nonemptyHypersurfaceChart H hH hd hHirr
  let i₀ : NonemptyHypersurfaceChart H := Nonempty.some inferInstance
  letI : Nonempty (projectiveZeroLocus 2 k H) :=
    ⟨hypersurfaceGlobalChartGenericPoint H hH hHirr i₀⟩
  haveI hUi (i : U.I₀) : IsIntegral (U.X i) := by
    change IsIntegral ((hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme)
    exact isIntegral_hypersurfaceChart_of_irreducible H hH hHirr i
  apply isIntegral_of_openCover_of_pairwise_nonempty U
  intro a b _hab
  change NonemptyHypersurfaceChart H at a b
  intro hdis
  let x := hypersurfaceGlobalChartGenericPoint H hH hHirr a
  have hxa : x ∈ (U.f a).opensRange := by
    change x ∈ (hypersurfaceChartToGlobal 2 k H hH a.1).opensRange
    exact (show x ∈ Set.range
      (hypersurfaceChartToGlobal 2 k H hH a.1).base from
        hypersurfaceGlobalChartGenericPoint_mem_chart_range
          H hH hHirr a a)
  have hxb : x ∈ (U.f b).opensRange := by
    change x ∈ (hypersurfaceChartToGlobal 2 k H hH b.1).opensRange
    exact (show x ∈ Set.range
      (hypersurfaceChartToGlobal 2 k H hH b.1).base from
        hypersurfaceGlobalChartGenericPoint_mem_chart_range
          H hH hHirr a b)
  have hxbot : x ∈ (⊥ : (projectiveZeroLocus 2 k H).Opens) :=
    hdis.le_bot ⟨hxa, hxb⟩
  exact hxbot

/-! ## Function-field chart interface -/

/-- The function field presented from a chosen nonempty standard chart. -/
abbrev HypersurfaceFunctionField
    (H : MvPolynomial (Fin 3) k) (i : NonemptyHypersurfaceChart H) :=
  FractionRing (HypersurfaceChartQuotient H i.1)

/-- The chosen affine chart quotient maps canonically to its fraction field. -/
def hypersurfaceChartQuotientToFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (_hH : H.IsHomogeneous d) (_hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    HypersurfaceChartQuotient H i.1 →+* HypersurfaceFunctionField H i := by
  letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H _hH _hHirr i.2
  exact algebraMap _ _

/-- The ambient standard-chart ring maps to the hypersurface function field through its affine
quotient. -/
def hypersurfaceStandardChartToFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    StandardChartRing 2 k i.1 →+* HypersurfaceFunctionField H i :=
  (hypersurfaceChartQuotientToFunctionField H hH hHirr i).comp
    (hypersurfaceAffineChartQuotientMap 2 k i.1 H)

/-- The homogeneous coordinate `X_l/X_i` in the function field presented from chart `i`. -/
def hypersurfaceNormalizedCoordinateInFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) (l : Fin 3) :
    HypersurfaceFunctionField H i :=
  hypersurfaceStandardChartToFunctionField H hH hHirr i
    (normalizedCoordinate 2 k i.1 l)

theorem hypersurfaceNormalizedCoordinateInFunctionField_ne_zero
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i j : NonemptyHypersurfaceChart H) :
    hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j.1 ≠ 0 := by
  letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  unfold hypersurfaceNormalizedCoordinateInFunctionField
  unfold hypersurfaceStandardChartToFunctionField
  unfold hypersurfaceChartQuotientToFunctionField
  simp only [RingHom.comp_apply]
  rw [← map_zero (algebraMap (HypersurfaceChartQuotient H i.1)
    (HypersurfaceFunctionField H i))]
  apply (IsFractionRing.injective
    (HypersurfaceChartQuotient H i.1) (HypersurfaceFunctionField H i)).ne
  unfold hypersurfaceAffineChartQuotientMap
  change Ideal.Quotient.mk _
      (standardChartRingEquivMvPolynomial 2 k i.1
        (normalizedCoordinate 2 k i.1 j.1)) ≠ 0
  rw [standardChartRingEquivMvPolynomial_normalizedCoordinate_eq_chartDehomogenization_X]
  exact quotient_mk_chartDehomogenization_ne_zero_of_not_dvd
    i.1 H (MvPolynomial.X j.1) hH hHirr
    (MvPolynomial.isHomogeneous_X k j.1) i.2
    (not_dvd_X_of_not_isUnit_chartDehomogenization H hHirr j.1 j.2)

end ProjectiveSpace

end

end BConicBundleMultisections

end
