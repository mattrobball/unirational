/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ConicFlatnessBricks
public import BConicBundleMultisections.PrimitiveHypersurfaceFlatness
public import BConicBundleMultisections.PointedConicChartBaseChange
public import BConicBundleMultisections.BiprojectiveSmoothCriterion
public import BConicBundleMultisections.BiprojectiveNoWholeFiber
public import BConicBundleMultisections.HomogeneousJacobianChart
public import Mathlib.RingTheory.Nullstellensatz

/-!
# Flatness assembly for the conic projection

This file isolates the scheme-theoretic assembly step for flatness of the second projection of a
biprojective zero locus.  The standard affine chart presentation already identifies its ring map
to the second projective factor as `affineChartQuotientYHom`.  Since flatness is Zariski-local at
the source, flatness of those explicit ring maps implies flatness of the global projection.

For a smooth nonzero bidegree-`(2,3)` hypersurface, the remaining input is therefore purely
commutative algebra: prove the six-by-six family of explicit chart quotient maps flat.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry
open PrimitiveHypersurfaceFlatness

attribute [local instance] MvPolynomial.gradedAlgebra

namespace BiprojectiveSpace

/-- Substituting a point of the second standard chart and then passing to affine coordinates in
the first factor is the ordinary dehomogenization of the specialized homogeneous equation. -/
theorem baseChangedChartEquation_eq_chartDehomogenization
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (j i : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A) :
    baseChangedChartEquation (i := i) y F =
      ProjectiveSpace.chartDehomogenization 2 A i
        (specializeSecondCoordinates (secondNormalizedCoordinates y)
          (F.map (algebraMap k A))) := by
  change tensorStandardChartEquivMvPolynomial 2 k A i
      (sndFiberChartMap (i := i) y (chartEquation 2 2 k i j F)) = _
  rw [sndFiberChartMap_chartEquation]
  let φ : Fin 3 → A ⊗[k] ProjectiveSpace.StandardChartRing 2 k i := fun l ↦
    Algebra.TensorProduct.includeRight
      (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i)
      (ProjectiveSpace.normalizedCoordinate 2 k i l)
  have hX (l : Fin 3) :
      tensorStandardChartEquivMvPolynomial 2 k A i (φ l) =
        ProjectiveSpace.chartDehomogenization 2 A i (MvPolynomial.X l) := by
    dsimp [φ]
    by_cases hl : l = i
    · rw [hl, ProjectiveSpace.normalizedCoordinate_self,
        ProjectiveSpace.chartDehomogenization_X_self]
      have h1 : ((1 : A) ⊗ₜ[k] (1 : ProjectiveSpace.StandardChartRing 2 k i)) =
          algebraMap A (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k i) 1 := by
        rw [Algebra.TensorProduct.algebraMap_apply]
        simp
      rw [h1, AlgEquiv.commutes, map_one]
    · obtain ⟨r, hr⟩ := Fin.exists_succAbove_eq hl
      rw [← hr, ProjectiveSpace.chartDehomogenization_X_succAbove]
      change (MvPolynomial.algebraTensorAlgEquiv k A)
          ((Algebra.TensorProduct.congr (AlgEquiv.refl (R := k) (A₁ := A))
            (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i))
            ((1 : A) ⊗ₜ[k]
              ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r))) = MvPolynomial.X r
      rw [Algebra.TensorProduct.congr_apply, Algebra.TensorProduct.map_tmul]
      convert MvPolynomial.algebraTensorAlgEquiv_tmul (R := k) (A := A) (1 : A)
        (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i
          (ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r))) using 2
      · simp
      · rw [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
        simp [MvPolynomial.map_X, one_smul]
  have hagree :
      (tensorStandardChartEquivMvPolynomial 2 k A i).toAlgHom.comp
          (MvPolynomial.aeval φ) =
        ProjectiveSpace.chartDehomogenization 2 A i := by
    refine MvPolynomial.algHom_ext fun l ↦ ?_
    simp only [AlgHom.comp_apply, MvPolynomial.aeval_X]
    exact hX l
  exact congrArg
    (fun ψ : MvPolynomial (Fin 3) A →ₐ[A] MvPolynomial (Fin 2) A ↦
      ψ (specializeSecondCoordinates (secondNormalizedCoordinates y)
        (F.map (algebraMap k A)))) hagree

/-- On every product chart, the coefficients (over the base chart ring) of the affine conic
equation generate the unit ideal.  Otherwise the Nullstellensatz produces a base point at which
that whole conic chart, hence the homogeneous conic, vanishes. -/
theorem span_range_coeff_baseChangedChartEquation_id_eq_top
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i j : Fin 3) :
    Ideal.span (Set.range fun d ↦
      (baseChangedChartEquation (i := i) (j := j)
        (AlgHom.id k (ProjectiveSpace.StandardChartRing 2 k j)) F).coeff d) = ⊤ := by
  classical
  let A := ProjectiveSpace.StandardChartRing 2 k j
  let g : MvPolynomial (Fin 2) A :=
    baseChangedChartEquation (i := i) (j := j) (AlgHom.id k A) F
  let I : Ideal A := Ideal.span (Set.range fun d ↦ g.coeff d)
  let e := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
  let J : Ideal (MvPolynomial (Fin 2) k) := Ideal.map e.toRingEquiv I
  change I = ⊤
  by_contra hI
  have hJ : J ≠ ⊤ := by
    intro hJtop
    apply hI
    apply (e.toRingEquiv.idealComapOrderIso.symm).injective
    rw [RingEquiv.idealComapOrderIso_symm_apply]
    simpa [J] using hJtop
  have hzeroLocus : MvPolynomial.zeroLocus k J ≠ ∅ := by
    intro hz
    have hrad := MvPolynomial.vanishingIdeal_zeroLocus_eq_radical (K := k) J
    rw [hz, MvPolynomial.vanishingIdeal_empty] at hrad
    exact hJ (Ideal.radical_eq_top.mp hrad.symm)
  obtain ⟨v, hv⟩ := Set.nonempty_iff_ne_empty.mpr hzeroLocus
  let ev : A →ₐ[k] k := (MvPolynomial.aeval v).comp e.toAlgHom
  have hev_coeff (d : Fin 2 →₀ ℕ) : ev (g.coeff d) = 0 := by
    change MvPolynomial.aeval v (e (g.coeff d)) = 0
    apply hv
    change e (g.coeff d) ∈ J
    dsimp only [J]
    exact Ideal.mem_map_of_mem e.toRingEquiv
      (Ideal.subset_span (Set.mem_range_self d))
  have hmapg : MvPolynomial.map ev.toRingHom g = 0 := by
    ext d
    rw [MvPolynomial.coeff_map]
    exact hev_coeff d
  have hg : g = ProjectiveSpace.chartDehomogenization 2 A i
      (specializeSecondCoordinates
        (secondNormalizedCoordinates (AlgHom.id k A))
        (F.map (algebraMap k A))) :=
    baseChangedChartEquation_eq_chartDehomogenization F j i (AlgHom.id k A)
  have hdeh : ProjectiveSpace.chartDehomogenization 2 k i
      (specializeSecondCoordinates (secondNormalizedCoordinates ev) F) = 0 := by
    rw [hg] at hmapg
    letI : Algebra A k := RingHom.toAlgebra ev.toRingHom
    change MvPolynomial.map (algebraMap A k)
      (ProjectiveSpace.chartDehomogenization 2 A i
        (specializeSecondCoordinates
          (secondNormalizedCoordinates (AlgHom.id k A))
          (F.map (algebraMap k A)))) = 0 at hmapg
    rw [← chartDehomogenization_map] at hmapg
    rw [map_specializeSecondCoordinates, MvPolynomial.map_map] at hmapg
    have hcoeff : ev.toRingHom.comp (algebraMap k A) = RingHom.id k := by
      ext a
      simp [ev]
    have halg : algebraMap A k = ev.toRingHom := rfl
    rw [halg, hcoeff, MvPolynomial.map_id] at hmapg
    have hcoords :
        (fun l ↦ ev.toRingHom (secondNormalizedCoordinates (AlgHom.id k A) l)) =
          secondNormalizedCoordinates ev := by
      funext l
      rfl
    rw [hcoords] at hmapg
    exact hmapg
  have hQ0 : specializeSecondCoordinates (secondNormalizedCoordinates ev) F ≠ 0 :=
    not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23
      k F hF hF0 j (secondNormalizedCoordinates ev)
        (secondNormalizedCoordinates_self ev)
  exact (chartDehomogenization_ne_zero_of_isHomogeneous
    (specializeSecondCoordinates (secondNormalizedCoordinates ev) F) 2
    (hF.specializeSecondCoordinates_isHomogeneous _) hQ0 i) hdeh

/-! ### The same unit-ideal statement with algebraic closure moved onto the points

The base field is arbitrary.  Two things happen to the argument.  The Nullstellensatz is run over
an algebraically closed extension `L`, so the proper ideal has to be pushed up first and the unit
ideal pulled back afterwards — that is `ideal_eq_top_of_map_eq_top`, the third row of the descent
table.  And the geometric input, "no fibre of the second projection is the whole first plane",
becomes a hypothesis about `L`-points, because that is the form in which it ascends. -/

/-- **On every product chart the coefficients of the affine conic equation generate the unit
ideal**, given that no fibre of the second projection over an `L`-point is the whole plane.

`k` carries no closure hypothesis; `L` is any algebraically closed extension of it. -/
theorem span_range_coeff_baseChangedChartEquation_id_eq_top_of_geometric
    {k : Type u} [Field k] {L : Type u} [Field L] [IsAlgClosed L] [Algebra k L]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (i j : Fin 3)
    (hfib : ∀ y : Fin 3 → L, y ≠ 0 →
      specializeSecondCoordinates (m := 2) y (F.map (algebraMap k L)) ≠ 0) :
    Ideal.span (Set.range fun d ↦
      (baseChangedChartEquation (i := i) (j := j)
        (AlgHom.id k (ProjectiveSpace.StandardChartRing 2 k j)) F).coeff d) = ⊤ := by
  classical
  let A := ProjectiveSpace.StandardChartRing 2 k j
  let g : MvPolynomial (Fin 2) A :=
    baseChangedChartEquation (i := i) (j := j) (AlgHom.id k A) F
  let I : Ideal A := Ideal.span (Set.range fun d ↦ g.coeff d)
  let e := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
  let J : Ideal (MvPolynomial (Fin 2) k) := Ideal.map e.toRingEquiv I
  change I = ⊤
  by_contra hI
  have hJ : J ≠ ⊤ := by
    intro hJtop
    apply hI
    apply (e.toRingEquiv.idealComapOrderIso.symm).injective
    rw [RingEquiv.idealComapOrderIso_symm_apply]
    simpa [J] using hJtop
  -- The proper ideal stays proper upstairs, by the elementary coefficient retraction.
  have hJL : J.map (MvPolynomial.map (algebraMap k L)) ≠ ⊤ := fun h =>
    hJ (ideal_eq_top_of_map_eq_top h)
  have hzeroLocus :
      MvPolynomial.zeroLocus L (J.map (MvPolynomial.map (algebraMap k L))) ≠ ∅ := by
    intro hz
    have hrad := MvPolynomial.vanishingIdeal_zeroLocus_eq_radical (K := L)
      (J.map (MvPolynomial.map (algebraMap k L)))
    rw [hz, MvPolynomial.vanishingIdeal_empty] at hrad
    exact hJL (Ideal.radical_eq_top.mp hrad.symm)
  obtain ⟨v, hv⟩ := Set.nonempty_iff_ne_empty.mpr hzeroLocus
  have haeval : ∀ p : MvPolynomial (Fin 2) k,
      (MvPolynomial.aeval v : MvPolynomial (Fin 2) L →ₐ[L] L)
          (MvPolynomial.map (algebraMap k L) p)
        = (MvPolynomial.aeval v : MvPolynomial (Fin 2) k →ₐ[k] L) p := by
    intro p
    rw [MvPolynomial.aeval_def, MvPolynomial.aeval_def, MvPolynomial.eval₂_map]
    simp
  let ev : A →ₐ[k] L := (MvPolynomial.aeval v).comp e.toAlgHom
  have hev_coeff (d : Fin 2 →₀ ℕ) : ev (g.coeff d) = 0 := by
    change (MvPolynomial.aeval v : MvPolynomial (Fin 2) k →ₐ[k] L) (e (g.coeff d)) = 0
    rw [← haeval]
    refine hv _ (Ideal.mem_map_of_mem _ ?_)
    change e (g.coeff d) ∈ J
    dsimp only [J]
    exact Ideal.mem_map_of_mem e.toRingEquiv
      (Ideal.subset_span (Set.mem_range_self d))
  have hmapg : MvPolynomial.map ev.toRingHom g = 0 := by
    ext d
    rw [MvPolynomial.coeff_map]
    exact hev_coeff d
  have hg : g = ProjectiveSpace.chartDehomogenization 2 A i
      (specializeSecondCoordinates
        (secondNormalizedCoordinates (AlgHom.id k A))
        (F.map (algebraMap k A))) :=
    baseChangedChartEquation_eq_chartDehomogenization F j i (AlgHom.id k A)
  have hdeh : ProjectiveSpace.chartDehomogenization 2 L i
      (specializeSecondCoordinates (secondNormalizedCoordinates ev)
        (F.map (algebraMap k L))) = 0 := by
    rw [hg] at hmapg
    letI : Algebra A L := RingHom.toAlgebra ev.toRingHom
    change MvPolynomial.map (algebraMap A L)
      (ProjectiveSpace.chartDehomogenization 2 A i
        (specializeSecondCoordinates
          (secondNormalizedCoordinates (AlgHom.id k A))
          (F.map (algebraMap k A)))) = 0 at hmapg
    rw [← chartDehomogenization_map] at hmapg
    rw [map_specializeSecondCoordinates, MvPolynomial.map_map] at hmapg
    have hcoeff : ev.toRingHom.comp (algebraMap k A) = algebraMap k L := by
      ext a
      simp [ev]
    have halg : algebraMap A L = ev.toRingHom := rfl
    rw [halg, hcoeff] at hmapg
    have hcoords :
        (fun l ↦ ev.toRingHom (secondNormalizedCoordinates (AlgHom.id k A) l)) =
          secondNormalizedCoordinates ev := by
      funext l
      rfl
    rw [hcoords] at hmapg
    exact hmapg
  have hy0 : secondNormalizedCoordinates ev ≠ 0 := by
    intro h
    have := congrFun h j
    rw [secondNormalizedCoordinates_self ev] at this
    exact one_ne_zero this
  exact (chartDehomogenization_ne_zero_of_isHomogeneous
    (specializeSecondCoordinates (secondNormalizedCoordinates ev) (F.map (algebraMap k L))) 2
    ((hF.map_coefficients (algebraMap k L)).specializeSecondCoordinates_isHomogeneous _)
    (hfib _ hy0) i) hdeh

/-- With the identity point of the base chart, `sndFiberChartMap` is tensor-factor commutation. -/
theorem sndFiberChartMap_id_eq_comm
    {k : Type u} [CommRing k] (i j : Fin 3)
    (z : StandardChartRing 2 2 k i j) :
    sndFiberChartMap (i := i)
        (AlgHom.id k (ProjectiveSpace.StandardChartRing 2 k j)) z =
      Algebra.TensorProduct.comm k
        (ProjectiveSpace.StandardChartRing 2 k i)
        (ProjectiveSpace.StandardChartRing 2 k j) z := by
  refine TensorProduct.induction_on z ?_ ?_ ?_
  · simp
  · intro a b
    rw [sndFiberChartMap_tmul, AlgHom.id_apply, Algebra.TensorProduct.comm_tmul]
  · intro x y hx hy
    simp only [map_add, hx, hy]

set_option backward.isDefEq.respectTransparency false in
/-- Flatness of one explicit standard-chart quotient map, from the unit-ideal statement alone.

No hypothesis on `k` beyond being a field, and none on `F`: everything geometric has been absorbed
into `hgspan`.  Both the closed-field and the geometric criteria below are instances. -/
theorem flat_affineChartQuotientYHom_of_span_range_coeff_eq_top
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i j : Fin 3)
    (hgspan : Ideal.span (Set.range fun d ↦
      (baseChangedChartEquation (i := i) (j := j)
        (AlgHom.id k (ProjectiveSpace.StandardChartRing 2 k j)) F).coeff d) = ⊤) :
    (affineChartQuotientYHom 2 2 k i j F).Flat := by
  let A := ProjectiveSpace.StandardChartRing 2 k j
  let B := ProjectiveSpace.StandardChartRing 2 k i
  let q : B ⊗[k] A := chartEquation 2 2 k i j F
  let c : B ⊗[k] A ≃ₐ[k] A ⊗[k] B := Algebra.TensorProduct.comm k B A
  let cR : B ⊗[k] A ≃+* A ⊗[k] B :=
    RingEquiv.ofBijective c.toRingHom c.bijective
  let y₀ : A →ₐ[k] A := AlgHom.id k A
  let q' : A ⊗[k] B := cR q
  let g : MvPolynomial (Fin 2) A :=
    tensorStandardChartEquivMvPolynomial 2 k A i q'
  let Q₀ := (B ⊗[k] A) ⧸ Ideal.span ({q} : Set (B ⊗[k] A))
  let Q₁ := (A ⊗[k] B) ⧸ Ideal.span ({q'} : Set (A ⊗[k] B))
  let P := MvPolynomial (Fin 2) A ⧸
    Ideal.span ({g} : Set (MvPolynomial (Fin 2) A))
  have hg : Ideal.span (Set.range fun d ↦ g.coeff d) = ⊤ := by
    have hcomm := sndFiberChartMap_id_eq_comm i j q
    simpa [g, q', q, cR, c, A, B, y₀, baseChangedChartEquation, hcomm] using hgspan
  letI : Module.Flat A P :=
    flat_mvPolynomial_quotient_span_singleton_of_span_range_coeff_eq_top g hg
  have hP : (algebraMap A P).Flat := RingHom.flat_algebraMap_iff.mpr inferInstance
  let e₁ : Q₀ ≃+* Q₁ := Ideal.quotientEquiv _ _ cR (by
    rw [Ideal.map_span, Set.image_singleton]
    rfl)
  let e₂ : Q₁ ≃ₐ[A] P :=
    conicChartQuotientEquivMvPolynomial 2 k A i q'
  let f₀ : A →+* Q₀ :=
    (Ideal.Quotient.mk (Ideal.span ({q} : Set (B ⊗[k] A)))).comp
      (Algebra.TensorProduct.includeRight
        (R := k) (A := B) (B := A)).toRingHom
  have he₁_mk (z : B ⊗[k] A) :
      e₁ (Ideal.Quotient.mk (Ideal.span ({q} : Set (B ⊗[k] A))) z) =
        Ideal.Quotient.mk (Ideal.span ({q'} : Set (A ⊗[k] B))) (cR z) := by
    dsimp only [e₁]
    rw [Ideal.quotientEquiv_mk]
  have he₂_mk (z : A ⊗[k] B) :
      e₂ (Ideal.Quotient.mk (Ideal.span ({q'} : Set (A ⊗[k] B))) z) =
        Ideal.Quotient.mk (Ideal.span ({g} : Set (MvPolynomial (Fin 2) A)))
          (tensorStandardChartEquivMvPolynomial 2 k A i z) := by
    dsimp only [e₂, conicChartQuotientEquivMvPolynomial]
    rw [Ideal.quotientEquivAlg_mk]
  have htransport : e₂.toRingHom.comp (e₁.toRingHom.comp f₀) = algebraMap A P := by
    ext a
    change e₂ (e₁ (Ideal.Quotient.mk _
      (Algebra.TensorProduct.includeRight a))) = _
    rw [he₁_mk, he₂_mk]
    change Ideal.Quotient.mk _
      (tensorStandardChartEquivMvPolynomial 2 k A i
        (cR ((1 : B) ⊗ₜ[k] a))) = _
    change Ideal.Quotient.mk _
      (tensorStandardChartEquivMvPolynomial 2 k A i
        (c ((1 : B) ⊗ₜ[k] a))) = _
    rw [Algebra.TensorProduct.comm_tmul]
    exact (conicChartQuotientEquivMvPolynomial 2 k A i q').commutes a
  have hf₀ : f₀.Flat := by
    have hcomp :
        (e₂.toRingHom.comp (e₁.toRingHom.comp f₀)).Flat := by
      rw [htransport]
      exact hP
    have he₁ : (e₁.toRingHom.comp f₀).Flat :=
      (RingHom.Flat.comp_iff_of_bijective_left e₂.bijective).mp hcomp
    exact (RingHom.Flat.comp_iff_of_bijective_left e₁.bijective).mp he₁
  rw [affineChartQuotientYHom_eq_equiv_comp_includeRight_mk]
  exact (RingHom.Flat.comp_iff_of_bijective_left
    (standardChartQuotientEquivAffineQuotient
      (R := k) (i := i) (j := j) F).bijective).mpr hf₀

/-- The chart quotient map is flat over an arbitrary base field, from the geometric
no-whole-fibre hypothesis. -/
theorem flat_affineChartQuotientYHom_of_geometric
    {k : Type u} [Field k] {L : Type u} [Field L] [IsAlgClosed L] [Algebra k L]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F)
    (hfib : ∀ y : Fin 3 → L, y ≠ 0 →
      specializeSecondCoordinates (m := 2) y (F.map (algebraMap k L)) ≠ 0)
    (i j : Fin 3) :
    (affineChartQuotientYHom 2 2 k i j F).Flat :=
  flat_affineChartQuotientYHom_of_span_range_coeff_eq_top F i j
    (span_range_coeff_baseChangedChartEquation_id_eq_top_of_geometric (L := L) F hF i j hfib)

/-- Every explicit standard-chart quotient map for the second projection of a smooth nonzero
bidegree-`(2,3)` hypersurface is flat.  No closure hypothesis on `k`: the whole-fibre exclusion
is taken over `AlgebraicClosure k`, where smoothness over `k` already supplies it. -/
theorem flat_affineChartQuotientYHom_of_smooth_bidegree23
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i j : Fin 3) :
    (affineChartQuotientYHom 2 2 k i j F).Flat :=
  flat_affineChartQuotientYHom_of_geometric (L := AlgebraicClosure k) F hF
    (fun y hy =>
      not_specializeSecondCoordinates_map_eq_zero_of_smooth_bidegree23_of_geometric
        k F hF hF0 y hy)
    i j

/-- Flatness of all explicit affine chart quotient maps assembles to flatness of the second
projection of the global biprojective zero locus. -/
theorem flat_biprojectiveZeroLocusSnd_of_flat_affineChartQuotientYHom
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (hflat : ∀ (i : Fin (m + 1)) (j : Fin (n + 1)),
      (affineChartQuotientYHom m n R i j F).Flat) :
    Flat (biprojectiveZeroLocusSnd m n R F) := by
  refine IsZariskiLocalAtSource.of_iSup_eq_top
    (fun ij : Fin (m + 1) × Fin (n + 1) =>
      biprojectiveZeroLocusι m n R F ⁻¹ᵁ (standardChartAffineOpen m n R ij.1 ij.2).1)
    ?_ ?_
  · rw [eq_top_iff]
    rintro z -
    simp only [TopologicalSpace.Opens.mem_iSup]
    have hz : (biprojectiveZeroLocusι m n R F).base z ∈
        (⊤ : (BiprojectiveSpace m n R).Opens) := trivial
    rw [← iSup_standardChartAffineOpen m n R] at hz
    simp only [TopologicalSpace.Opens.mem_iSup] at hz
    exact hz
  · rintro ⟨i, j⟩
    have hr : Set.range (chartZeroLocusToGlobal m n R F hF i j).base =
        Set.range (biprojectiveZeroLocusι m n R F ⁻¹ᵁ
          (standardChartAffineOpen m n R i j).1).ι.base := by
      rw [Scheme.Opens.range_ι]
      exact congrArg (fun U : (biprojectiveZeroLocus m n R F).Opens ↦ U.1)
        (opensRange_chartZeroLocusToGlobal m n R F hF i j)
    let ι := IsOpenImmersion.isoOfRangeEq (chartZeroLocusToGlobal m n R F hF i j)
      (biprojectiveZeroLocusι m n R F ⁻¹ᵁ (standardChartAffineOpen m n R i j).1).ι hr
    rw [← MorphismProperty.cancel_left_of_respectsIso @Flat ι.hom]
    rw [← Category.assoc, IsOpenImmersion.isoOfRangeEq_hom_fac]
    rw [← chartZeroLocusIsoSpecAffineQuotient_hom_snd m n R F hF i j]
    haveI : Flat (Spec.map
        (CommRingCat.ofHom (affineChartQuotientYHom m n R i j F))) :=
      Flat.SpecMap_iff.mpr (hflat i j)
    infer_instance

/-- **The second projection is flat over an arbitrary base field**, given that no fibre of the
second projection over a nonzero `L`-point of the second plane is the whole first plane. -/
theorem flat_biprojectiveZeroLocusSnd_of_geometric
    {k : Type u} [Field k] {L : Type u} [Field L] [IsAlgClosed L] [Algebra k L]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F)
    (hfib : ∀ y : Fin 3 → L, y ≠ 0 →
      specializeSecondCoordinates (m := 2) y (F.map (algebraMap k L)) ≠ 0) :
    Flat (biprojectiveZeroLocusSnd 2 2 k F) := by
  apply flat_biprojectiveZeroLocusSnd_of_flat_affineChartQuotientYHom
    2 2 k F hF
  intro i j
  exact flat_affineChartQuotientYHom_of_geometric (L := L) F hF hfib i j

/-- The second projection of a smooth nonzero bidegree-`(2,3)` hypersurface
is flat.  No closure hypothesis on `k`. -/
theorem flat_biprojectiveZeroLocusSnd_of_smooth_bidegree23
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    Flat (biprojectiveZeroLocusSnd 2 2 k F) := by
  apply flat_biprojectiveZeroLocusSnd_of_flat_affineChartQuotientYHom
    2 2 k F hF
  intro i j
  exact flat_affineChartQuotientYHom_of_smooth_bidegree23 F hF hF0 i j

end BiprojectiveSpace

end

end BConicBundleMultisections
