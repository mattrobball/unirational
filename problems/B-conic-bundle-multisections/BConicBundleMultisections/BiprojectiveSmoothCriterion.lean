/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineChartJacobian
public import BConicBundleMultisections.BiprojectiveAffineJacobian
public import BConicBundleMultisections.GenericCubicNondegeneracy
public import BConicBundleMultisections.GeometricPointDescent
public import Mathlib.RingTheory.Nullstellensatz

/-!
# A Jacobian criterion producing smoothness of a biprojective zero locus

`BiprojectiveZeroLocusSmooth.lean` and `BiprojectiveAffineJacobian.lean` go one way: from
`Smooth (biprojectiveZeroLocusToSpec m n K F)` they extract nonvanishing of some partial
derivative at every point of every affine chart.  This file proves the **converse**, which is
what is needed to exhibit an example: a bihomogeneous `F` whose Cox-coordinate gradient vanishes
only on the two forbidden coordinate subspaces defines a smooth biprojective zero locus.

The chain of reductions is

* `Hypersurface.formallySmooth_of_pderiv_span_eq_top` — if the classes of the partial derivatives
  of a nonzero `f` generate the unit ideal of `K[X] ⧸ (f)`, that quotient is formally smooth over
  `K`.  This is the exact converse of `Hypersurface.pderiv_span_eq_top_of_smooth`, obtained by
  *constructing* the retraction of the cotangent complex which that proof consumed.
* `Hypersurface.smooth_of_exists_pderiv_ne_zero` — over an algebraically closed field the unit
  ideal condition follows from "no common zero of `f` and its partials", by the Nullstellensatz.
* `BiprojectiveSpace.smooth_chartZeroLocusToSpec_of_exists_pderiv_ne_zero` — transported to one
  standard affine chart of a biprojective zero locus.
* `BiprojectiveSpace.smooth_biprojectiveZeroLocusToSpec_of_chartSmooth` — smoothness is Zariski
  local at the source and the chartwise zero loci form an open cover.
* `BiprojectiveSpace.smooth_biprojectiveZeroLocusToSpec_of_gradient` — the final, homogeneous
  form of the criterion.  Its hypothesis is stated directly in Cox coordinates; Euler's identity
  supplies the two partial derivatives that a chart drops.

The homogeneous criterion is the usable one: verifying it for a concrete `F` is an ordinary
algebraic computation in the Cox coordinates, with no chart bookkeeping.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u v

open AlgebraicGeometry MvPolynomial

namespace Hypersurface

variable {K : Type u} [Field K] {σ : Type v}

attribute [local instance] cotangentSpaceModule

/-- If the classes of the partial derivatives of a nonzero `f` generate the unit ideal in
`K[X] ⧸ (f)`, then that quotient is formally smooth over `K`.

This is the converse of `Hypersurface.pderiv_span_eq_top_of_smooth`.  Formal smoothness is
equivalent to the cotangent complex `I/I² → A ⊗ Ω` being split injective; the conormal module
`I/I²` is free of rank one on the class of `f` (`principalConormalEquiv`) and the complex sends
its generator to the gradient of `f`, so a retraction is exactly a linear form taking the value
`1` on the gradient — which is what a unit-ideal relation `∑ cᵢ ∂ᵢf = 1` provides. -/
theorem formallySmooth_of_pderiv_span_eq_top
    [Finite σ] (f : MvPolynomial σ K) (hf : f ≠ 0)
    (hspan : Ideal.span (Set.range fun i : σ =>
      Ideal.Quotient.mk (Ideal.span {f}) (MvPolynomial.pderiv i f)) = ⊤) :
    Algebra.FormallySmooth K (MvPolynomial σ K ⧸ Ideal.span {f}) := by
  classical
  letI := Fintype.ofFinite σ
  obtain ⟨c, hc⟩ := Ideal.mem_span_range_iff_exists_fun.mp ((Ideal.eq_top_iff_one _).mp hspan)
  let e := principalConormalEquiv f hf
  let b := cotangentSpaceBasis f
  let q : (extension f).CotangentSpace →ₗ[MvPolynomial σ K ⧸ Ideal.span {f}]
      (MvPolynomial σ K ⧸ Ideal.span {f}) :=
    (Finsupp.linearCombination (MvPolynomial σ K ⧸ Ideal.span {f}) c).comp b.repr.toLinearMap
  let u : (extension f).CotangentSpace :=
    1 ⊗ₜ[MvPolynomial σ K] KaehlerDifferential.D K (MvPolynomial σ K) f
  have he : (extension f).cotangentComplex (e 1) = u := by
    change (extension f).cotangentComplex
      (e (Ideal.Quotient.mk (Ideal.span {f}) 1)) = u
    rw [principalConormalEquiv_mk, Algebra.Extension.cotangentComplex_mk]
    simp only [one_mul, u]
  have hqu : q u = 1 := by
    have hrepr : ∀ i : σ, b.repr u i =
        Ideal.Quotient.mk (Ideal.span {f}) (MvPolynomial.pderiv i f) := fun i =>
      cotangentSpaceBasis_repr_D f i
    simp only [q, LinearMap.comp_apply, LinearEquiv.coe_coe,
      Finsupp.linearCombination_apply]
    rw [Finsupp.sum_fintype _ _ (by simp)]
    calc ∑ i : σ, b.repr u i • c i
        = ∑ i : σ, c i * Ideal.Quotient.mk (Ideal.span {f}) (MvPolynomial.pderiv i f) := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [hrepr i, smul_eq_mul, mul_comm]
      _ = 1 := hc
  refine (extension f).formallySmooth_iff_split_injection.mpr
    ⟨e.toLinearMap.comp q, LinearMap.ext fun z => ?_⟩
  obtain ⟨a, rfl⟩ := e.surjective z
  have hsmul : e a = a • e 1 := by
    rw [← LinearEquiv.map_smul, smul_eq_mul, mul_one]
  simp only [LinearMap.comp_apply, LinearMap.id_apply, LinearEquiv.coe_coe]
  rw [hsmul, map_smul, he, map_smul, hqu, smul_eq_mul, mul_one, ← hsmul]

/-- If the classes of the partial derivatives of a nonzero `f` generate the unit ideal in
`K[X] ⧸ (f)`, the hypersurface quotient is a smooth `K`-algebra. -/
theorem smooth_of_pderiv_span_eq_top
    [Finite σ] (f : MvPolynomial σ K) (hf : f ≠ 0)
    (hspan : Ideal.span (Set.range fun i : σ =>
      Ideal.Quotient.mk (Ideal.span {f}) (MvPolynomial.pderiv i f)) = ⊤) :
    RingHom.Smooth
      (algebraMap K (MvPolynomial σ K ⧸ Ideal.span {f})) := by
  letI := Fintype.ofFinite σ
  rw [RingHom.smooth_algebraMap]
  exact
    { formallySmooth := formallySmooth_of_pderiv_span_eq_top f hf hspan
      finitePresentation :=
        Algebra.FinitePresentation.quotient
          (Ideal.fg_of_isNoetherianRing (Ideal.span {f})) }

/-- A polynomial whose zeros all carry a nonvanishing partial derivative is itself nonzero.
The zero polynomial vanishes at the origin together with all of its partial derivatives. -/
theorem ne_zero_of_exists_pderiv_ne_zero
    (f : MvPolynomial σ K)
    (h : ∀ a : σ → K, MvPolynomial.aeval a f = 0 →
      ∃ i : σ, MvPolynomial.aeval a (MvPolynomial.pderiv i f) ≠ 0) :
    f ≠ 0 := by
  rintro rfl
  obtain ⟨i, hi⟩ := h 0 (by simp)
  exact hi (by simp)

/-- The unit-ideal condition upstairs, repackaged in the hypersurface quotient.

No hypothesis on `K` beyond being a field: this is the purely formal half of
`pderiv_span_eq_top_of_exists_pderiv_ne_zero`, separated so that the Nullstellensatz half can be
performed over a larger field and the conclusion brought back down. -/
theorem pderiv_span_eq_top_of_sup_span_eq_top (f : MvPolynomial σ K)
    (hJ : Ideal.span (Set.range fun i : σ => MvPolynomial.pderiv i f) ⊔ Ideal.span {f} = ⊤) :
    Ideal.span (Set.range fun i : σ =>
      Ideal.Quotient.mk (Ideal.span {f}) (MvPolynomial.pderiv i f)) = ⊤ := by
  classical
  have h1 : (1 : MvPolynomial σ K) ∈
      Ideal.span (Set.range fun i : σ => MvPolynomial.pderiv i f) ⊔ Ideal.span {f} :=
    (Ideal.eq_top_iff_one _).mp hJ
  have hmap := Ideal.mem_map_of_mem (Ideal.Quotient.mk (Ideal.span {f})) h1
  rw [Ideal.map_sup, Ideal.map_span, Ideal.map_span] at hmap
  have hzero : Ideal.span
      ((Ideal.Quotient.mk (Ideal.span {f})) '' ({f} : Set (MvPolynomial σ K))) = ⊥ := by
    rw [Set.image_singleton]
    have : Ideal.Quotient.mk (Ideal.span {f}) f = 0 :=
      Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_span_singleton_self f)
    rw [this, Ideal.span_singleton_eq_bot.mpr rfl]
  have himg :
      (Ideal.Quotient.mk (Ideal.span {f})) ''
          (Set.range fun i : σ => MvPolynomial.pderiv i f) =
        Set.range fun i : σ =>
          Ideal.Quotient.mk (Ideal.span {f}) (MvPolynomial.pderiv i f) :=
    (Set.range_comp _ _).symm
  rw [hzero, sup_bot_eq, himg] at hmap
  exact (Ideal.eq_top_iff_one _).mpr hmap

/-- Over an algebraically closed field, `f` and its partials generate the unit ideal as soon as
they have no common zero.  This is the weak Nullstellensatz: the ideal they generate has empty
zero locus, hence equals its own radical's ambient ring. -/
theorem sup_span_pderiv_eq_top_of_exists_pderiv_ne_zero
    [Finite σ] [IsAlgClosed K] (f : MvPolynomial σ K)
    (h : ∀ a : σ → K, MvPolynomial.aeval a f = 0 →
      ∃ i : σ, MvPolynomial.aeval a (MvPolynomial.pderiv i f) ≠ 0) :
    Ideal.span (Set.range fun i : σ => MvPolynomial.pderiv i f) ⊔ Ideal.span {f} = ⊤ := by
  classical
  set J : Ideal (MvPolynomial σ K) :=
    Ideal.span (Set.range fun i : σ => MvPolynomial.pderiv i f) ⊔ Ideal.span {f} with hJdef
  have hfJ : f ∈ J := (le_sup_right : Ideal.span {f} ≤ J) (Ideal.subset_span rfl)
  have hdJ : ∀ i : σ, MvPolynomial.pderiv i f ∈ J := fun i =>
    (le_sup_left : Ideal.span (Set.range fun i : σ => MvPolynomial.pderiv i f) ≤ J)
      (Ideal.subset_span ⟨i, rfl⟩)
  have hzl : MvPolynomial.zeroLocus K J = ∅ := by
    ext a
    simp only [Set.mem_empty_iff_false, iff_false, MvPolynomial.mem_zeroLocus_iff]
    intro ha
    obtain ⟨i, hi⟩ := h a (ha f hfJ)
    exact hi (ha _ (hdJ i))
  have hrad := MvPolynomial.vanishingIdeal_zeroLocus_eq_radical (K := K) J
  rw [hzl, MvPolynomial.vanishingIdeal_empty] at hrad
  exact Ideal.radical_eq_top.mp hrad.symm

/-- Over an algebraically closed field, if `f` and all of its partial derivatives have no common
zero, then the classes of the partial derivatives generate the unit ideal in `K[X] ⧸ (f)`. -/
theorem pderiv_span_eq_top_of_exists_pderiv_ne_zero
    [Finite σ] [IsAlgClosed K] (f : MvPolynomial σ K)
    (h : ∀ a : σ → K, MvPolynomial.aeval a f = 0 →
      ∃ i : σ, MvPolynomial.aeval a (MvPolynomial.pderiv i f) ≠ 0) :
    Ideal.span (Set.range fun i : σ =>
      Ideal.Quotient.mk (Ideal.span {f}) (MvPolynomial.pderiv i f)) = ⊤ :=
  pderiv_span_eq_top_of_sup_span_eq_top f
    (sup_span_pderiv_eq_top_of_exists_pderiv_ne_zero f h)

/-! ### The same criterion with algebraic closure moved onto the points

`K` becomes an arbitrary field and the nonsingularity hypothesis is taken over an algebraically
closed extension `L`.  That strengthening of the hypothesis is forced, not incidental.  Over
`K = ℝ` take `f = y² - (x² + 1)²`: its real zeros are the two smooth branches `y = ±(x² + 1)`, on
which `∂_y f = 2y ≠ 0`, so the `ℝ`-hypothesis holds; but `f`, `∂_x f = -4x(x² + 1)` and
`∂_y f = 2y` all lie in `(y, x² + 1)`, a proper ideal, so the conclusion fails.  What the
`ℝ`-hypothesis misses is precisely the pair of singular points `(±i, 0)`.

The conclusion is an ideal membership, the third row of the descent table in
`GeometricPointDescent`; `ideal_eq_top_of_map_eq_top` brings it back down. -/

/-- The nonsingularity hypothesis over any extension already forces `f ≠ 0`. -/
theorem ne_zero_of_exists_pderiv_ne_zero_of_geometric
    {L : Type*} [Field L] [Algebra K L] (f : MvPolynomial σ K)
    (h : ∀ a : σ → L, MvPolynomial.aeval a (MvPolynomial.map (algebraMap K L) f) = 0 →
      ∃ i : σ, MvPolynomial.aeval a
        (MvPolynomial.map (algebraMap K L) (MvPolynomial.pderiv i f)) ≠ 0) :
    f ≠ 0 := by
  rintro rfl
  obtain ⟨i, hi⟩ := h 0 (by simp)
  exact hi (by simp)

/-- **`f` and its partials generate the unit ideal over `K` as soon as they have no common zero
over an algebraically closed extension `L`.** -/
theorem sup_span_pderiv_eq_top_of_exists_pderiv_ne_zero_of_geometric
    [Finite σ] {L : Type*} [Field L] [IsAlgClosed L] [Algebra K L] (f : MvPolynomial σ K)
    (h : ∀ a : σ → L, MvPolynomial.aeval a (MvPolynomial.map (algebraMap K L) f) = 0 →
      ∃ i : σ, MvPolynomial.aeval a
        (MvPolynomial.map (algebraMap K L) (MvPolynomial.pderiv i f)) ≠ 0) :
    Ideal.span (Set.range fun i : σ => MvPolynomial.pderiv i f) ⊔ Ideal.span {f} = ⊤ := by
  classical
  refine ideal_eq_top_of_map_eq_top (K := L) ?_
  have hup := sup_span_pderiv_eq_top_of_exists_pderiv_ne_zero
    (K := L) (MvPolynomial.map (algebraMap K L) f) (by
      intro a ha
      obtain ⟨i, hi⟩ := h a ha
      exact ⟨i, by rwa [MvPolynomial.pderiv_map]⟩)
  have hfun : (MvPolynomial.map (algebraMap K L)) ∘ (fun i : σ => MvPolynomial.pderiv i f)
      = fun i : σ => MvPolynomial.pderiv i (MvPolynomial.map (algebraMap K L) f) :=
    funext fun _ => MvPolynomial.pderiv_map.symm
  rw [Ideal.map_sup, Ideal.map_span, Ideal.map_span, Set.image_singleton,
    ← Set.range_comp, hfun]
  exact hup

/-- **Smoothness of the hypersurface quotient from nonsingularity over an algebraically closed
extension.**  `K` carries no closure hypothesis. -/
theorem smooth_of_exists_pderiv_ne_zero_of_geometric
    [Finite σ] {L : Type*} [Field L] [IsAlgClosed L] [Algebra K L] (f : MvPolynomial σ K)
    (h : ∀ a : σ → L, MvPolynomial.aeval a (MvPolynomial.map (algebraMap K L) f) = 0 →
      ∃ i : σ, MvPolynomial.aeval a
        (MvPolynomial.map (algebraMap K L) (MvPolynomial.pderiv i f)) ≠ 0) :
    RingHom.Smooth
      (algebraMap K (MvPolynomial σ K ⧸ Ideal.span {f})) :=
  smooth_of_pderiv_span_eq_top f (ne_zero_of_exists_pderiv_ne_zero_of_geometric f h)
    (pderiv_span_eq_top_of_sup_span_eq_top f
      (sup_span_pderiv_eq_top_of_exists_pderiv_ne_zero_of_geometric f h))

/-- Over an algebraically closed field, a polynomial whose zeros all carry a nonvanishing partial
derivative presents a smooth hypersurface quotient.  This is the converse of
`Hypersurface.exists_pderiv_ne_zero_at_of_smooth`. -/
theorem smooth_of_exists_pderiv_ne_zero
    [Finite σ] [IsAlgClosed K] (f : MvPolynomial σ K)
    (h : ∀ a : σ → K, MvPolynomial.aeval a f = 0 →
      ∃ i : σ, MvPolynomial.aeval a (MvPolynomial.pderiv i f) ≠ 0) :
    RingHom.Smooth
      (algebraMap K (MvPolynomial σ K ⧸ Ideal.span {f})) :=
  smooth_of_pderiv_span_eq_top f (ne_zero_of_exists_pderiv_ne_zero f h)
    (pderiv_span_eq_top_of_exists_pderiv_ne_zero f h)

end Hypersurface

namespace BiprojectiveSpace

/-- Chartwise Jacobian nonvanishing makes one standard chart of a biprojective zero locus smooth
over the base.  Converse of `affineChartQuotient_smooth_of_global`. -/
theorem smooth_chartZeroLocusToSpec_of_exists_pderiv_ne_zero
    (m n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (h : ∀ a : Fin m ⊕ Fin n → K,
      MvPolynomial.aeval a (affineChartEquation m n K i j F) = 0 →
      ∃ q : Fin m ⊕ Fin n,
        MvPolynomial.aeval a
          (MvPolynomial.pderiv q (affineChartEquation m n K i j F)) ≠ 0) :
    Smooth (chartZeroLocusToSpec m n K F hF i j) := by
  have hsm : RingHom.Smooth
      (algebraMap K (MvPolynomial (Fin m ⊕ Fin n) K ⧸
        Ideal.span {affineChartEquation m n K i j F})) :=
    Hypersurface.smooth_of_exists_pderiv_ne_zero _ h
  have hspec : Smooth (affineChartQuotientToSpec m n K i j F) := by
    let φ := CommRingCat.ofHom
      (algebraMap K (MvPolynomial (Fin m ⊕ Fin n) K ⧸
        Ideal.span {affineChartEquation m n K i j F}))
    have : Smooth (Spec.map φ) :=
      (HasRingHomProperty.Spec_iff (P := @Smooth) (φ := φ)).mpr hsm
    exact this
  rw [← chartZeroLocusIsoSpecAffineQuotient_hom_toSpec m n K F hF i j]
  infer_instance

/-- The chartwise zero loci of a bihomogeneous `F` have the expected ranges inside the global
zero locus: the preimages of the standard affine charts of the ambient biprojective space. -/
theorem opensRange_chartZeroLocusToGlobal
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (chartZeroLocusToGlobal m n R F hF i j).opensRange =
      biprojectiveZeroLocusι m n R F ⁻¹ᵁ
        (standardChartAffineOpen m n R i j).1 := by
  change (chartZeroLocusToGlobal m n R F hF i j).opensRange =
    biprojectiveZeroLocusι m n R F ⁻¹ᵁ (standardChartι m n R i j).opensRange
  rw [← Scheme.Hom.opensRange_pullbackSnd (standardChartι m n R i j)
    (biprojectiveZeroLocusι m n R F)]
  apply TopologicalSpace.Opens.ext
  change Set.range (chartZeroLocusToGlobal m n R F hF i j).base = _
  unfold chartZeroLocusToGlobal
  rw [Scheme.Hom.comp_base, TopCat.coe_comp, Set.range_comp,
    Set.range_eq_univ.mpr
      ((chartZeroLocusIsoPullback m n R F hF i j).hom.surjective), Set.image_univ]
  rfl

/-- Smoothness of every chartwise zero locus over the base gives smoothness of the global
biprojective zero locus: smoothness is Zariski local at the source and the chartwise zero loci
form an open cover. -/
theorem smooth_biprojectiveZeroLocusToSpec_of_chartSmooth
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (H : ∀ (i : Fin (m + 1)) (j : Fin (n + 1)),
      Smooth (chartZeroLocusToSpec m n R F hF i j)) :
    Smooth (biprojectiveZeroLocusToSpec m n R F) := by
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
      exact congrArg (fun U : (biprojectiveZeroLocus m n R F).Opens => U.1)
        (opensRange_chartZeroLocusToGlobal m n R F hF i j)
    let ι := IsOpenImmersion.isoOfRangeEq (chartZeroLocusToGlobal m n R F hF i j)
      (biprojectiveZeroLocusι m n R F ⁻¹ᵁ (standardChartAffineOpen m n R i j).1).ι hr
    rw [← MorphismProperty.cancel_left_of_respectsIso @Smooth ι.hom]
    rw [← Category.assoc, IsOpenImmersion.isoOfRangeEq_hom_fac]
    exact H i j

/-- **Jacobian criterion for smoothness of a biprojective hypersurface.**

Let `K` be algebraically closed and let `F` be bihomogeneous of bidegree `(d, e)` in the Cox
coordinates of `ℙᵐ × ℙⁿ`.  If at every pair of coordinate vectors `(x, y)` at which `F` and all
of its Cox partial derivatives vanish one of the two vectors is zero — that is, if the affine
cone over the zero locus is singular only along the two forbidden coordinate subspaces — then
the biprojective zero locus of `F` is smooth over `Spec K`.

The chart criterion asks for a nonvanishing partial derivative among the `m + n` *affine* chart
coordinates, which omit the two normalized coordinates `x i` and `y j`; Euler's identity for the
two blocks recovers those two homogeneous partials from the others, so the homogeneous hypothesis
stated here is enough. -/
theorem exists_chart_pderiv_ne_zero_of_gradient
    (m n : ℕ) (K : Type u) [Field K]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F)
    (hgrad : ∀ x : Fin (m + 1) → K, ∀ y : Fin (n + 1) → K,
      MvPolynomial.eval (Sum.elim x y) F = 0 →
      (∀ z : BiprojectiveCoordinate m n,
        MvPolynomial.eval (Sum.elim x y) (MvPolynomial.pderiv z F) = 0) →
      x = 0 ∨ y = 0)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    ∀ a : Fin m ⊕ Fin n → K,
      MvPolynomial.aeval a (affineChartEquation m n K i j F) = 0 →
      ∃ q : Fin m ⊕ Fin n,
        MvPolynomial.aeval a
          (MvPolynomial.pderiv q (affineChartEquation m n K i j F)) ≠ 0 := by
  intro a ha
  by_contra hcon
  push Not at hcon
  -- Homogeneous representatives normalized at `i` and `j`.
  set x : Fin (m + 1) → K := i.insertNth 1 (fun r : Fin m => a (.inl r)) with hxdef
  set y : Fin (n + 1) → K := j.insertNth 1 (fun s : Fin n => a (.inr s)) with hydef
  have hxi : x i = 1 := by simp [hxdef]
  have hyj : y j = 1 := by simp [hydef]
  have hxs : ∀ r : Fin m, x (i.succAbove r) = a (.inl r) := by
    intro r; simp [hxdef]
  have hys : ∀ s : Fin n, y (j.succAbove s) = a (.inr s) := by
    intro s; simp [hydef]
  have hpt : affineChartPoint i j x y = a := by
    funext z
    rcases z with r | s
    · exact hxs r
    · exact hys s
  -- The chart equation vanishes, hence so does `F` at the homogeneous representatives.
  have hFxy : MvPolynomial.eval (Sum.elim x y) F = 0 := by
    rw [← eval_affineChartEquation_affineChartPoint m n K i j x y hxi hyj F, hpt]
    simpa using ha
  -- All affine chart partials vanish, hence all homogeneous partials off `i` and `j` do.
  have hcon' : ∀ q : Fin m ⊕ Fin n,
      MvPolynomial.eval a (MvPolynomial.pderiv q (affineChartEquation m n K i j F)) = 0 := by
    intro q; simpa using hcon q
  have hinl : ∀ l : Fin (m + 1), l ≠ i →
      MvPolynomial.eval (Sum.elim x y) (MvPolynomial.pderiv (.inl l) F) = 0 := by
    intro l hl
    obtain ⟨r, rfl⟩ := (Fin.eq_self_or_eq_succAbove i l).resolve_left hl
    rw [← eval_pderiv_affineChartEquation_inl_affineChartPoint m n K i j r x y hxi hyj F, hpt]
    exact hcon' (.inl r)
  have hinr : ∀ l : Fin (n + 1), l ≠ j →
      MvPolynomial.eval (Sum.elim x y) (MvPolynomial.pderiv (.inr l) F) = 0 := by
    intro l hl
    obtain ⟨s, rfl⟩ := (Fin.eq_self_or_eq_succAbove j l).resolve_left hl
    rw [← eval_pderiv_affineChartEquation_inr_affineChartPoint m n K i j s x y hxi hyj F, hpt]
    exact hcon' (.inr s)
  -- Euler's identity supplies the two missing homogeneous partials.
  have hinl_i : MvPolynomial.eval (Sum.elim x y) (MvPolynomial.pderiv (.inl i) F) = 0 := by
    have hEuler := congrArg (MvPolynomial.eval (Sum.elim x y)) hF.sum_inl_X_mul_pderiv
    rw [map_sum] at hEuler
    rw [Finset.sum_eq_single i] at hEuler
    · simpa [hxi, hFxy] using hEuler
    · intro l _ hl
      simp [hinl l hl]
    · simp
  have hinr_j : MvPolynomial.eval (Sum.elim x y) (MvPolynomial.pderiv (.inr j) F) = 0 := by
    have hEuler := congrArg (MvPolynomial.eval (Sum.elim x y)) hF.sum_inr_X_mul_pderiv
    rw [map_sum] at hEuler
    rw [Finset.sum_eq_single j] at hEuler
    · simpa [hyj, hFxy] using hEuler
    · intro l _ hl
      simp [hinr l hl]
    · simp
  have hall : ∀ z : BiprojectiveCoordinate m n,
      MvPolynomial.eval (Sum.elim x y) (MvPolynomial.pderiv z F) = 0 := by
    rintro (l | l)
    · rcases eq_or_ne l i with rfl | hl
      · exact hinl_i
      · exact hinl l hl
    · rcases eq_or_ne l j with rfl | hl
      · exact hinr_j
      · exact hinr l hl
  -- But then one of the two coordinate vectors is zero, contradicting normalization.
  rcases hgrad x y hFxy hall with hx0 | hy0
  · exact one_ne_zero (hxi ▸ congrFun hx0 i)
  · exact one_ne_zero (hyj ▸ congrFun hy0 j)

theorem smooth_biprojectiveZeroLocusToSpec_of_gradient
    (m n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F)
    (hgrad : ∀ x : Fin (m + 1) → K, ∀ y : Fin (n + 1) → K,
      MvPolynomial.eval (Sum.elim x y) F = 0 →
      (∀ z : BiprojectiveCoordinate m n,
        MvPolynomial.eval (Sum.elim x y) (MvPolynomial.pderiv z F) = 0) →
      x = 0 ∨ y = 0) :
    Smooth (biprojectiveZeroLocusToSpec m n K F) :=
  smooth_biprojectiveZeroLocusToSpec_of_chartSmooth m n K F hF fun i j =>
    smooth_chartZeroLocusToSpec_of_exists_pderiv_ne_zero m n K F hF i j
      (exists_chart_pderiv_ne_zero_of_gradient m n K F hF hgrad i j)

/-! ### The Jacobian criterion with algebraic closure moved onto the points

The base field is arbitrary; the singular points are looked for over an algebraically closed
extension `L`.  This is where `Smooth` pays for the strengthening: the hypothesis one really has
in practice is smoothness of the geometric fibre, and *that* is a statement about `L`-points. -/

/-- One standard chart, with the nonsingularity hypothesis taken over an algebraically closed
extension of the base field. -/
theorem smooth_chartZeroLocusToSpec_of_exists_pderiv_ne_zero_of_geometric
    (m n : ℕ) (K : Type u) [Field K] {L : Type u} [Field L] [IsAlgClosed L] [Algebra K L]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (h : ∀ a : Fin m ⊕ Fin n → L,
      MvPolynomial.aeval a
          (MvPolynomial.map (algebraMap K L) (affineChartEquation m n K i j F)) = 0 →
      ∃ q : Fin m ⊕ Fin n,
        MvPolynomial.aeval a
          (MvPolynomial.map (algebraMap K L)
            (MvPolynomial.pderiv q (affineChartEquation m n K i j F))) ≠ 0) :
    Smooth (chartZeroLocusToSpec m n K F hF i j) := by
  have hsm : RingHom.Smooth
      (algebraMap K (MvPolynomial (Fin m ⊕ Fin n) K ⧸
        Ideal.span {affineChartEquation m n K i j F})) :=
    Hypersurface.smooth_of_exists_pderiv_ne_zero_of_geometric (L := L) _ h
  have hspec : Smooth (affineChartQuotientToSpec m n K i j F) := by
    let φ := CommRingCat.ofHom
      (algebraMap K (MvPolynomial (Fin m ⊕ Fin n) K ⧸
        Ideal.span {affineChartEquation m n K i j F}))
    have : Smooth (Spec.map φ) :=
      (HasRingHomProperty.Spec_iff (P := @Smooth) (φ := φ)).mpr hsm
    exact this
  rw [← chartZeroLocusIsoSpecAffineQuotient_hom_toSpec m n K F hF i j]
  infer_instance

/-- **Jacobian criterion for smoothness of a biprojective hypersurface over an arbitrary field.**

The Cox-coordinate hypothesis is imposed on points of an algebraically closed extension `L`, which
is what "the singular locus of the geometric fibre is contained in the two forbidden coordinate
subspaces" actually says.  The conclusion is smoothness over `Spec K` itself. -/
theorem smooth_biprojectiveZeroLocusToSpec_of_gradient_of_geometric
    (m n : ℕ) (K : Type u) [Field K] {L : Type u} [Field L] [IsAlgClosed L] [Algebra K L]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F)
    (hgrad : ∀ x : Fin (m + 1) → L, ∀ y : Fin (n + 1) → L,
      MvPolynomial.eval (Sum.elim x y) (MvPolynomial.map (algebraMap K L) F) = 0 →
      (∀ z : BiprojectiveCoordinate m n,
        MvPolynomial.eval (Sum.elim x y)
          (MvPolynomial.pderiv z (MvPolynomial.map (algebraMap K L) F)) = 0) →
      x = 0 ∨ y = 0) :
    Smooth (biprojectiveZeroLocusToSpec m n K F) := by
  refine smooth_biprojectiveZeroLocusToSpec_of_chartSmooth m n K F hF fun i j => ?_
  refine smooth_chartZeroLocusToSpec_of_exists_pderiv_ne_zero_of_geometric
    (L := L) m n K F hF i j ?_
  intro a ha
  obtain ⟨q, hq⟩ := exists_chart_pderiv_ne_zero_of_gradient m n L
    (MvPolynomial.map (algebraMap K L) F) (hF.map_coefficients _) hgrad i j a
    (by rwa [MvPolynomialFractionRing.map_affineChartEquation] at ha)
  exact ⟨q, by
    rwa [← MvPolynomial.pderiv_map, MvPolynomialFractionRing.map_affineChartEquation]⟩

/-- A chart equation is nonzero as soon as the homogeneous equation is nonzero at some pair of
representatives normalized for that chart. -/
theorem affineChartEquation_ne_zero_of_eval_ne_zero
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (hne : MvPolynomial.eval (Sum.elim x y) F ≠ 0) :
    affineChartEquation m n R i j F ≠ 0 := by
  intro h
  apply hne
  rw [← eval_affineChartEquation_affineChartPoint m n R i j x y hxi hyj F, h, map_zero]

/-- **Converse of the Jacobian criterion, in homogeneous form.**

If the biprojective zero locus of `F` is smooth, then at every zero of `F` given by
representatives *already normalized* for some standard chart, some Cox partial derivative of `F`
is nonzero.  This is the direction opposite to
`smooth_biprojectiveZeroLocusToSpec_of_gradient`, restricted to normalized representatives —
which is all a single chart sees.  It is the form used to certify that a candidate equation is
*not* smooth.

The chart hypothesis `hne` is genuine: on a chart where `F` restricts to `0` the chart zero locus
is the whole affine chart, which is smooth over the base, so the chart imposes no gradient
condition at all. -/
theorem exists_pderiv_ne_zero_of_smooth
    (m n : ℕ) (K : Type u) [Field K]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) K)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (hne : affineChartEquation m n K i j F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec m n K F)]
    (x : Fin (m + 1) → K) (y : Fin (n + 1) → K)
    (hxi : x i = 1) (hyj : y j = 1)
    (hFxy : MvPolynomial.eval (Sum.elim x y) F = 0) :
    ∃ z : BiprojectiveCoordinate m n,
      MvPolynomial.eval (Sum.elim x y) (MvPolynomial.pderiv z F) ≠ 0 := by
  have ha : MvPolynomial.aeval (affineChartPoint i j x y)
      (affineChartEquation m n K i j F) = 0 := by
    have := eval_affineChartEquation_affineChartPoint m n K i j x y hxi hyj F
    simpa [this] using hFxy
  obtain ⟨q, hq⟩ := exists_affineChartEquation_pderiv_ne_zero_at_of_global_smooth
    m n K F hF i j hne (affineChartPoint i j x y) ha
  rcases q with r | s
  · refine ⟨.inl (i.succAbove r), ?_⟩
    rw [← eval_pderiv_affineChartEquation_inl_affineChartPoint m n K i j r x y hxi hyj F]
    simpa using hq
  · refine ⟨.inr (j.succAbove s), ?_⟩
    rw [← eval_pderiv_affineChartEquation_inr_affineChartPoint m n K i j s x y hxi hyj F]
    simpa using hq

end BiprojectiveSpace

end

end BConicBundleMultisections
