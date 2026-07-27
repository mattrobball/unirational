/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GenericConicNondegeneracy
public import BConicBundleMultisections.GoodLineConic
public import BConicBundleMultisections.IntegralOpenCover
public import BConicBundleMultisections.FirstProjectionJacobian
public import BConicBundleMultisections.PointedConicOpenConsumer
public import Mathlib.RingTheory.Nullstellensatz

/-!
# Direct dominance of the stereographic open

This file isolates the route from the explicit stereographic chart to dominance of the total
biprojective hypersurface.  It deliberately uses neither flatness nor integrality of the whole
pullback.

There are two independent ingredients.

* On affine spectra, an injective coordinate-ring map is dominant.  Thus, once the map from the
  stereographic source factors through a dominant affine target chart and its ring map is
  injective, `PointedConicOpenChartData.Dominates` follows by composition.
* The universal conic over the generic point of a dominant base chart is nonsingular, and every
  affine dehomogenization of it has a domain coordinate ring.  This is the flatness-free generic
  conic input used to prove the required ring-map injection.

The global target-chart density step is closed below.  The remaining integration boundary is to
expose the source-to-chart factorization implicit in `exists_chartQuotient_openImmersion` and prove
that the induced map from the universal chart quotient to the stereographic line-chart ring is
injective.  The raw affine base change may contain vertical scalar factors, so this route does not
replace that injection with integrality of the whole affine conic.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry Matrix TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace

attribute [local instance] MvPolynomial.gradedAlgebra

/-! ## The universal conic on an arbitrary base chart -/

/-- The universal ternary conic over the second-factor chart `Y_j ≠ 0`.  The existing
`genericSndConicChartZero` is the case `j = 0`; keeping `j` explicit is what makes the finite
product-chart cover available. -/
def genericSndConicChart
    {k : Type u} [Field k] (j : Fin 3)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial (Fin 3) (ProjectiveSpace.StandardChartRing 2 k j) :=
  specializeSecondCoordinates
    (fun l => ProjectiveSpace.normalizedCoordinate 2 k j l)
    (MvPolynomial.map
      (algebraMap k (ProjectiveSpace.StandardChartRing 2 k j)) F)

/-- Evaluate the chart `Y_j ≠ 0` along a parametrized line `p + t q` whose `j`-th
coordinate is identically one. -/
def lineChartEval
    {k : Type u} [Field k] (j : Fin 3) (p q : Fin 3 → k) :
    ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] Polynomial k :=
  (MvPolynomial.aeval (fun r : Fin 2 =>
      Polynomial.C (p (j.succAbove r)) +
        Polynomial.X * Polynomial.C (q (j.succAbove r)))).comp
    (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j).toAlgHom

@[simp]
theorem lineChartEval_normalizedCoordinate
    {k : Type u} [Field k] (j : Fin 3) (p q : Fin 3 → k)
    (hp : p j = 1) (hq : q j = 0) (l : Fin 3) :
    lineChartEval j p q (ProjectiveSpace.normalizedCoordinate 2 k j l) =
      linePointOf (fun a => Polynomial.C (p a))
        (fun a => Polynomial.C (q a)) Polynomial.X l := by
  rcases Fin.eq_self_or_eq_succAbove j l with h | ⟨r, h⟩
  · subst h
    simp [lineChartEval, linePointOf, hp, hq]
  · subst h
    unfold lineChartEval
    rw [AlgHom.comp_apply]
    change MvPolynomial.aeval (fun r : Fin 2 =>
      Polynomial.C (p (j.succAbove r)) +
        Polynomial.X * Polynomial.C (q (j.succAbove r)))
      ((ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j)
        (ProjectiveSpace.normalizedCoordinate 2 k j (j.succAbove r))) = _
    rw [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
    simp [linePointOf]

/-- Restricting the universal conic on `Y_j ≠ 0` to the line `p + t q` gives the ordinary
line-specialized conic. -/
theorem map_genericSndConicChart_line
    {k : Type u} [Field k] (j : Fin 3) (p q : Fin 3 → k)
    (hp : p j = 1) (hq : q j = 0)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial.map (lineChartEval j p q).toRingHom
        (genericSndConicChart j F) =
      lineSpecializedConicPoly p q F := by
  rw [genericSndConicChart, lineSpecializedConicPoly,
    map_specializeSecondCoordinates, MvPolynomial.map_map]
  have hcoeff : (lineChartEval j p q).toRingHom.comp
      (algebraMap k (ProjectiveSpace.StandardChartRing 2 k j)) =
        Polynomial.C := by
    ext a
    simp [lineChartEval]
  rw [hcoeff]
  have hcoords :
      (fun l => (lineChartEval j p q).toRingHom
        (ProjectiveSpace.normalizedCoordinate 2 k j l)) =
      linePointOf (fun a => Polynomial.C (p a))
        (fun a => Polynomial.C (q a)) Polynomial.X := by
    funext l
    exact lineChartEval_normalizedCoordinate j p q hp hq l
  rw [hcoords]

/-- A genuine line contained in `Y_j ≠ 0` detects that the polar determinant of the universal
chart conic is nonzero. -/
theorem det_polarMatrix_genericSndConicChart_ne_zero_of_line
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (j : Fin 3) (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p q r * N = 1) (hp : p j = 1) (hq : q j = 0)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    (polarMatrix (genericSndConicChart j F)).det ≠ 0 := by
  intro hdet
  have hmapQ := map_genericSndConicChart_line j p q hp hq F
  have hmapM :
      polarMatrix (lineSpecializedConicPoly p q F) =
        (polarMatrix (genericSndConicChart j F)).map
          (lineChartEval j p q).toRingHom := by
    rw [← hmapQ]
    apply Matrix.ext
    intro a b
    simp only [polarMatrix_apply, Matrix.map_apply]
    have hsingle (c : Fin 3) :
        (fun d : Fin 3 => lineChartEval j p q
          ((Pi.single c
            (1 : ProjectiveSpace.StandardChartRing 2 k j) :
              Fin 3 → ProjectiveSpace.StandardChartRing 2 k j) d)) =
          (Pi.single c (1 : Polynomial k) : Fin 3 → Polynomial k) := by
      funext d
      by_cases hdc : d = c
      · subst hdc
        simp [Pi.single_eq_same]
      · simp [Pi.single_eq_of_ne hdc]
    have h := polarEval_map (lineChartEval j p q).toRingHom
      (genericSndConicChart j F) (Pi.single a 1) (Pi.single b 1)
    rw [← hsingle a, ← hsingle b]
    exact h
  apply lineConicDiscriminant_ne_zero_of_smooth p q r N hMN F hF hF0
  rw [lineConicDiscriminant, hmapM]
  have hmatrix :
      (polarMatrix (genericSndConicChart j F)).map
          (lineChartEval j p q).toRingHom =
        (lineChartEval j p q).toRingHom.mapMatrix
          (polarMatrix (genericSndConicChart j F)) := by
    rfl
  rw [hmatrix, ← RingHom.map_det, hdet, map_zero]

/-- The universal conic has nonzero polar determinant on every second-factor standard chart. -/
theorem det_polarMatrix_genericSndConicChart_ne_zero_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (j : Fin 3) :
    (polarMatrix (genericSndConicChart j F)).det ≠ 0 := by
  fin_cases j
  · refine det_polarMatrix_genericSndConicChart_ne_zero_of_line 0
      ![1, 0, 0] ![0, 1, 0] ![0, 0, 1]
      (1 : Matrix (Fin 3) (Fin 3) k) ?_ ?_ ?_ F hF hF0
    · simpa using (lineFrame_coordinate (R := k))
    · simp
    · simp
  · let p : Fin 3 → k := ![0, 1, 0]
    let q : Fin 3 → k := ![1, 0, 0]
    let r : Fin 3 → k := ![0, 0, 1]
    let N : Matrix (Fin 3) (Fin 3) k := Matrix.transpose (lineFrame p q r)
    refine det_polarMatrix_genericSndConicChart_ne_zero_of_line 1 p q r N ?_ ?_ ?_
      F hF hF0
    · ext a b
      fin_cases a <;> fin_cases b <;>
        simp [p, q, r, N, Matrix.mul_apply, lineFrame, Fin.sum_univ_three]
    · simp [p]
    · simp [q]
  · let p : Fin 3 → k := ![0, 0, 1]
    let q : Fin 3 → k := ![1, 0, 0]
    let r : Fin 3 → k := ![0, 1, 0]
    let N : Matrix (Fin 3) (Fin 3) k := Matrix.transpose (lineFrame p q r)
    refine det_polarMatrix_genericSndConicChart_ne_zero_of_line 2 p q r N ?_ ?_ ?_
      F hF hF0
    · ext a b
      fin_cases a <;> fin_cases b <;>
        simp [p, q, r, N, Matrix.mul_apply, lineFrame, Fin.sum_univ_three]
    · simp [p]
    · simp [q]

/-- Mapping the universal conic on an arbitrary base chart gives the usual specialized fibre
quadratic. -/
theorem map_genericSndConicChart
    {k K : Type u} [Field k] [CommRing K] [Algebra k K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (j : Fin 3)
    (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] K) :
    MvPolynomial.map y.toRingHom (genericSndConicChart j F) =
      specializeSecondCoordinates (secondNormalizedCoordinates y)
        (MvPolynomial.map (algebraMap k K) F) := by
  rw [genericSndConicChart, map_specializeSecondCoordinates, MvPolynomial.map_map]
  have hcoeff : y.toRingHom.comp
      (algebraMap k (ProjectiveSpace.StandardChartRing 2 k j)) = algebraMap k K := by
    ext a
    exact y.commutes a
  rw [hcoeff]
  rfl

/-- The base-changed affine equation over `Y_j ≠ 0` is the dehomogenization of the mapped
universal ternary conic. -/
theorem baseChangedChartEquation_eq_chartDehomogenization_genericChart
    {k K : Type u} [Field k] [CommRing K] [Algebra k K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] K) :
    baseChangedChartEquation (i := i) (j := j) y F =
      ProjectiveSpace.chartDehomogenization 2 K i
        (MvPolynomial.map y.toRingHom (genericSndConicChart j F)) := by
  change tensorStandardChartEquivMvPolynomial 2 k K i
      (sndFiberChartMap (i := i) y (chartEquation 2 2 k i j F)) =
    ProjectiveSpace.chartDehomogenization 2 K i
      (MvPolynomial.map y.toRingHom (genericSndConicChart j F))
  have hmap := sndFiberChartMap_chartEquation (i := i) y F
  rw [hmap]
  let φ : Fin 3 → K ⊗[k] ProjectiveSpace.StandardChartRing 2 k i := fun l =>
    Algebra.TensorProduct.includeRight
      (R := k) (A := K) (B := ProjectiveSpace.StandardChartRing 2 k i)
      (ProjectiveSpace.normalizedCoordinate 2 k i l)
  have hX (l : Fin 3) :
      tensorStandardChartEquivMvPolynomial 2 k K i (φ l) =
        ProjectiveSpace.chartDehomogenization 2 K i (MvPolynomial.X l) := by
    dsimp [φ]
    by_cases hl : l = i
    · rw [hl, ProjectiveSpace.normalizedCoordinate_self,
        ProjectiveSpace.chartDehomogenization_X_self]
      have h1 : ((1 : K) ⊗ₜ[k] (1 : ProjectiveSpace.StandardChartRing 2 k i)) =
          algebraMap K (K ⊗[k] ProjectiveSpace.StandardChartRing 2 k i) 1 := by
        rw [Algebra.TensorProduct.algebraMap_apply]
        simp
      rw [h1, AlgEquiv.commutes, map_one]
    · obtain ⟨r, hr⟩ := Fin.exists_succAbove_eq hl
      rw [← hr, ProjectiveSpace.chartDehomogenization_X_succAbove]
      change (MvPolynomial.algebraTensorAlgEquiv k K)
          ((Algebra.TensorProduct.congr (AlgEquiv.refl (R := k) (A₁ := K))
            (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i))
            ((1 : K) ⊗ₜ[k]
              ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r))) = MvPolynomial.X r
      rw [Algebra.TensorProduct.congr_apply, Algebra.TensorProduct.map_tmul]
      convert MvPolynomial.algebraTensorAlgEquiv_tmul (R := k) (A := K) (1 : K)
        (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i
          (ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r))) using 2
      · simp
      · rw [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
        simp [MvPolynomial.map_X, one_smul]
  have hagree :
      (tensorStandardChartEquivMvPolynomial 2 k K i).toAlgHom.comp
          (MvPolynomial.aeval φ) =
        ProjectiveSpace.chartDehomogenization 2 K i := by
    refine MvPolynomial.algHom_ext fun l => ?_
    simp only [AlgHom.comp_apply, MvPolynomial.aeval_X]
    exact hX l
  have hφ : (fun l =>
      Algebra.TensorProduct.includeRight
        (R := k) (A := K) (B := ProjectiveSpace.StandardChartRing 2 k i)
        (ProjectiveSpace.normalizedCoordinate 2 k i l)) = φ := rfl
  rw [hφ, ← map_genericSndConicChart F j y]
  exact congrArg
    (fun ψ : MvPolynomial (Fin 3) K →ₐ[K] MvPolynomial (Fin 2) K =>
      ψ (MvPolynomial.map y.toRingHom (genericSndConicChart j F))) hagree

/-- A dominant map out of any second-factor chart preserves the nonzero polar determinant. -/
theorem det_polarMatrix_map_genericSndConicChart_ne_zero
    {k A : Type u} [Field k] [CommRing A] [IsDomain A] [Algebra k A]
    [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (j : Fin 3)
    (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
    [IsDominant (Spec.map (CommRingCat.ofHom y.toRingHom))] :
    (polarMatrix (MvPolynomial.map y.toRingHom (genericSndConicChart j F))).det ≠ 0 := by
  have hy : Function.Injective y.toRingHom := by
    have hd : DenseRange (PrimeSpectrum.comap y.toRingHom) :=
      IsDominant.denseRange (f := Spec.map (CommRingCat.ofHom y.toRingHom))
    have hker : RingHom.ker y.toRingHom ≤
        _root_.nilradical (ProjectiveSpace.StandardChartRing 2 k j) :=
      (PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical y.toRingHom).mp hd
    rw [nilradical_eq_zero] at hker
    exact (RingHom.injective_iff_ker_eq_bot y.toRingHom).mpr
      (le_antisymm hker bot_le)
  have hmapM :
      polarMatrix (MvPolynomial.map y.toRingHom (genericSndConicChart j F)) =
        (polarMatrix (genericSndConicChart j F)).map y.toRingHom := by
    apply Matrix.ext
    intro a b
    simp only [polarMatrix_apply, Matrix.map_apply]
    have hsingle (c : Fin 3) :
        (fun d : Fin 3 => y
          ((Pi.single c
            (1 : ProjectiveSpace.StandardChartRing 2 k j) :
              Fin 3 → ProjectiveSpace.StandardChartRing 2 k j) d)) =
          (Pi.single c (1 : A) : Fin 3 → A) := by
      funext d
      by_cases hdc : d = c
      · subst hdc
        simp [Pi.single_eq_same]
      · simp [Pi.single_eq_of_ne hdc]
    have h := polarEval_map y.toRingHom (genericSndConicChart j F)
      (Pi.single a 1) (Pi.single b 1)
    rw [← hsingle a, ← hsingle b]
    exact h
  rw [hmapM]
  have hmatrix :
      (polarMatrix (genericSndConicChart j F)).map y.toRingHom =
        y.toRingHom.mapMatrix (polarMatrix (genericSndConicChart j F)) := by
    rfl
  rw [hmatrix, ← RingHom.map_det]
  intro hz
  apply det_polarMatrix_genericSndConicChart_ne_zero_of_smooth F hF hF0 j
  exact hy (by simpa using hz)

/-- A dominant map of affine spectra has injective coordinate map when the source ring is
reduced.  This is the ring-theoretic form used for the dominant affine base chart. -/
theorem injective_of_isDominant_specMap
    {R A : Type u} [CommRing R] [CommRing A] [IsReduced R]
    (f : R →+* A) [IsDominant (Spec.map (CommRingCat.ofHom f))] :
    Function.Injective f := by
  have hdense : DenseRange (PrimeSpectrum.comap f) :=
    IsDominant.denseRange (f := Spec.map (CommRingCat.ofHom f))
  have hker : RingHom.ker f ≤ _root_.nilradical R :=
    (PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical f).mp hdense
  rw [nilradical_eq_zero] at hker
  exact (RingHom.injective_iff_ker_eq_bot f).mpr (le_antisymm hker bot_le)

/-- An injective coordinate map induces a dominant map of affine spectra. -/
theorem isDominant_specMap_of_injective
    {R A : Type u} [CommRing R] [CommRing A]
    (f : R →+* A) (hf : Function.Injective f) :
    IsDominant (Spec.map (CommRingCat.ofHom f)) := by
  rw [isDominant_iff]
  refine (PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical f).mpr ?_
  intro x hx
  have hx0 : x = 0 := hf (by simpa [RingHom.mem_ker] using hx)
  simp [hx0]

/-- A nonunit multivariable polynomial over an algebraically closed field has a zero.  This
small Nullstellensatz corollary is useful for excluding coefficient-only factors of a family. -/
theorem exists_eval_eq_zero_of_not_isUnit
    {K σ : Type*} [Field K] [IsAlgClosed K] [Finite σ]
    (p : MvPolynomial σ K) (hp : ¬ IsUnit p) :
    ∃ x : σ → K, MvPolynomial.eval x p = 0 := by
  by_contra h
  push Not at h
  have hz : MvPolynomial.zeroLocus K (Ideal.span {p}) = ∅ := by
    ext x
    simp [MvPolynomial.zeroLocus_span, h x]
  have hrad : (Ideal.span {p}).radical = ⊤ := by
    rw [← MvPolynomial.vanishingIdeal_zeroLocus_eq_radical (k := K) (K := K)]
    rw [hz]
    exact MvPolynomial.vanishingIdeal_empty
  have htop : Ideal.span ({p} : Set (MvPolynomial σ K)) = ⊤ :=
    Ideal.radical_eq_top.mp hrad
  exact hp (Ideal.span_singleton_eq_top.mp htop)

/-- Gauss descent for a multivariable polynomial in the exact form needed here.  If the
polynomial becomes irreducible over the fraction field and every coefficient-ring scalar factor
is already a unit, then it is irreducible over the original domain.

Unlike the univariate Gauss lemma, this statement does not require choosing an iterated
polynomial presentation: a factor which becomes a unit over the fraction field has total degree
zero, hence is a scalar, and `hscalar` handles precisely those factors. -/
theorem irreducible_mvPolynomial_of_fractionMap_of_scalar_factors
    {R σ : Type*} [CommRing R] [IsDomain R]
    (g : MvPolynomial σ R)
    (hirr : Irreducible
      (MvPolynomial.map (algebraMap R (FractionRing R)) g))
    (hscalar : ∀ r : R, MvPolynomial.C r ∣ g → IsUnit r) :
    Irreducible g := by
  let ι : R →+* FractionRing R := algebraMap R (FractionRing R)
  have hι : Function.Injective ι := IsFractionRing.injective R (FractionRing R)
  have hconst (a : MvPolynomial σ R)
      (ha : IsUnit (MvPolynomial.map ι a)) :
      ∃ r : R, a = MvPolynomial.C r := by
    have hdeg : (MvPolynomial.map ι a).totalDegree = 0 :=
      (MvPolynomial.isUnit_iff_totalDegree_of_isReduced.mp ha).2
    have hmapconst : MvPolynomial.map ι a =
        MvPolynomial.C ((MvPolynomial.map ι a).coeff 0) :=
      MvPolynomial.totalDegree_eq_zero_iff_eq_C.mp hdeg
    refine ⟨a.coeff 0, ?_⟩
    apply MvPolynomial.map_injective ι hι
    rw [hmapconst, MvPolynomial.map_C, MvPolynomial.coeff_map]
  refine (irreducible_iff).mpr ⟨?_, ?_⟩
  · intro hunit
    exact hirr.not_isUnit (hunit.map (MvPolynomial.map ι))
  · intro a b hab
    have habK : MvPolynomial.map ι g =
        MvPolynomial.map ι a * MvPolynomial.map ι b := by
      rw [hab, map_mul]
    rcases (irreducible_iff.mp hirr).2 habK with ha | hb
    · left
      obtain ⟨r, har⟩ := hconst a ha
      have hr : IsUnit r := hscalar r ⟨b, by rw [← har, ← hab]⟩
      rw [har]
      exact hr.map MvPolynomial.C
    · right
      obtain ⟨r, hbr⟩ := hconst b hb
      have hr : IsUnit r := hscalar r ⟨a, by rw [mul_comm, ← hbr, ← hab]⟩
      rw [hbr]
      exact hr.map MvPolynomial.C

namespace PointedConicOpenChartData

variable {k : Type u} [Field k]
variable {F : MvPolynomial (BiprojectiveCoordinate 2 2) k}
variable {T : Scheme.{u}} {t : T ⟶ ProjectiveSpace 2 k}

/-- Direct target-chart criterion for the open-chart obligation.  No property of the whole
pullback occurs: dominance is checked on one dominant affine open of the global target. -/
theorem dominates_of_affine_target_chart
    (D : PointedConicOpenChartData F t)
    {R : Type u} [CommRing R]
    (c : Spec (CommRingCat.of R) ⟶ biprojectiveZeroLocus 2 2 k F)
    (hc : IsDominant c)
    (q : D.source ⟶ Spec (CommRingCat.of R))
    (hq : IsDominant q)
    (hfac : D.toTotal = q ≫ c) :
    D.Dominates := by
  haveI : IsDominant c := hc
  haveI : IsDominant q := hq
  rw [Dominates, hfac]
  infer_instance

/-- Ring-map form of `dominates_of_affine_target_chart`.  This is the form consumed by an
explicit stereographic coordinate map. -/
theorem dominates_of_affine_target_chart_of_injective
    (D : PointedConicOpenChartData F t)
    {R S : Type u} [CommRing R] [CommRing S]
    (c : Spec (CommRingCat.of R) ⟶ biprojectiveZeroLocus 2 2 k F)
    (hc : IsDominant c)
    (f : R →+* S)
    (hf : Function.Injective f)
    (hsource : D.source = Spec (CommRingCat.of S))
    (hfac : D.toTotal = eqToHom hsource ≫ Spec.map (CommRingCat.ofHom f) ≫ c) :
    D.Dominates := by
  have hq : IsDominant (eqToHom hsource ≫ Spec.map (CommRingCat.ofHom f)) := by
    haveI : IsDominant (Spec.map (CommRingCat.ofHom f)) :=
      isDominant_specMap_of_injective f hf
    infer_instance
  exact D.dominates_of_affine_target_chart c hc
    (eqToHom hsource ≫ Spec.map (CommRingCat.ofHom f)) hq hfac

end PointedConicOpenChartData

/-! ## The generic conic chart over the fraction field -/

/-- Every affine chart of the conic obtained over the fraction field of a dominant affine base
chart has a domain coordinate ring.

This is the algebraic generic-fibre statement needed by the direct dominance route.  The proof
uses only injectivity of the dominant base-chart map and the explicit nonzero polar determinant
from `GenericConicNondegeneracy`; there is no flatness or whole-pullback integrality hypothesis. -/
theorem isDomain_fractionRing_genericConicAffineChart
    {k A : Type u} [Field k] [CommRing A] [IsDomain A] [Algebra k A]
    [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (y : ProjectiveSpace.StandardChartRing 2 k 0 →ₐ[k] A)
    [IsDominant (Spec.map (CommRingCat.ofHom y.toRingHom))]
    (i : Fin 3) :
    IsDomain
      (MvPolynomial (Fin 2) (FractionRing A) ⧸
        Ideal.span
          {MvPolynomial.map (algebraMap A (FractionRing A))
            (baseChangedChartEquation (i := i) (j := 0) y F)}) := by
  let K := FractionRing A
  let ι : A →+* K := algebraMap A K
  let yK : ProjectiveSpace.StandardChartRing 2 k 0 →ₐ[k] K :=
    (IsScalarTower.toAlgHom k A K).comp y
  have hy : Function.Injective y.toRingHom := injective_of_isDominant_specMap y.toRingHom
  have hyK : Function.Injective yK.toRingHom := by
    exact (IsFractionRing.injective A K).comp hy
  letI : IsDominant (Spec.map (CommRingCat.ofHom yK.toRingHom)) :=
    isDominant_specMap_of_injective yK.toRingHom hyK
  let Q : MvPolynomial (Fin 3) K :=
    MvPolynomial.map yK.toRingHom (genericSndConicChartZero F)
  have hQhom : Q.IsHomogeneous 2 := by
    rw [show Q = specializeSecondCoordinates (secondNormalizedCoordinates yK)
      (MvPolynomial.map (algebraMap k K) F) from map_genericSndConicChartZero F yK]
    exact (hF.map_coefficients (algebraMap k K)).specializeSecondCoordinates_isHomogeneous
      (secondNormalizedCoordinates yK)
  have hdet : (polarMatrix Q).det ≠ 0 :=
    det_polarMatrix_map_genericSndConicChartZero_ne_zero F hF hF0 yK
  have hQ0 : Q ≠ 0 := by
    intro hzero
    apply hdet
    rw [hzero]
    have hz : polarMatrix (0 : MvPolynomial (Fin 3) K) = 0 := by
      ext a b
      simp [polarMatrix, polarEval]
    rw [hz, Matrix.det_zero]
  have hnonsing :
      ∀ v : Fin 3 → K, v ≠ 0 → MvPolynomial.eval v Q = 0 →
        ∃ j, MvPolynomial.eval v (MvPolynomial.pderiv j Q) ≠ 0 := by
    intro v hv _
    exact exists_eval_pderiv_ne_zero_of_det_polarMatrix_ne_zero Q hQhom hdet v hv
  have hg :
      MvPolynomial.map ι
          (baseChangedChartEquation (i := i) (j := 0) y F) =
        ProjectiveSpace.chartDehomogenization 2 K i Q := by
    have hbase := baseChangedChartEquation_eq_chartDehomogenization_generic F i y
    rw [hbase]
    have hQdef : Q = MvPolynomial.map ι
        (MvPolynomial.map y.toRingHom (genericSndConicChartZero F)) := by
      dsimp only [Q, yK]
      rw [MvPolynomial.map_map]
      congr 1
    rw [hQdef]
    exact (chartDehomogenization_map i
      (MvPolynomial.map y.toRingHom (genericSndConicChartZero F))).symm
  rw [hg]
  exact isDomain_chartDehomogenization_quotient_of_nonsingular
    i Q hQhom hQ0 hnonsing

/-- Arbitrary-base-chart form of `isDomain_fractionRing_genericConicAffineChart`. -/
theorem isDomain_fractionRing_genericConicAffineChart_of_chart
    {k A : Type u} [Field k] [CommRing A] [IsDomain A] [Algebra k A]
    [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (j : Fin 3)
    (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
    [IsDominant (Spec.map (CommRingCat.ofHom y.toRingHom))]
    (i : Fin 3) :
    IsDomain
      (MvPolynomial (Fin 2) (FractionRing A) ⧸
        Ideal.span
          {MvPolynomial.map (algebraMap A (FractionRing A))
            (baseChangedChartEquation (i := i) (j := j) y F)}) := by
  let K := FractionRing A
  let ι : A →+* K := algebraMap A K
  let yK : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] K :=
    (IsScalarTower.toAlgHom k A K).comp y
  have hy : Function.Injective y.toRingHom :=
    injective_of_isDominant_specMap y.toRingHom
  have hyK : Function.Injective yK.toRingHom :=
    (IsFractionRing.injective A K).comp hy
  letI : IsDominant (Spec.map (CommRingCat.ofHom yK.toRingHom)) :=
    isDominant_specMap_of_injective yK.toRingHom hyK
  let Q : MvPolynomial (Fin 3) K :=
    MvPolynomial.map yK.toRingHom (genericSndConicChart j F)
  have hQhom : Q.IsHomogeneous 2 := by
    rw [show Q = specializeSecondCoordinates (secondNormalizedCoordinates yK)
      (MvPolynomial.map (algebraMap k K) F) from map_genericSndConicChart F j yK]
    exact (hF.map_coefficients (algebraMap k K)).specializeSecondCoordinates_isHomogeneous
      (secondNormalizedCoordinates yK)
  have hdet : (polarMatrix Q).det ≠ 0 :=
    det_polarMatrix_map_genericSndConicChart_ne_zero F hF hF0 j yK
  have hQ0 : Q ≠ 0 := by
    intro hzero
    apply hdet
    rw [hzero]
    have hz : polarMatrix (0 : MvPolynomial (Fin 3) K) = 0 := by
      ext a b
      simp [polarMatrix, polarEval]
    rw [hz, Matrix.det_zero]
  have hnonsing :
      ∀ v : Fin 3 → K, v ≠ 0 → MvPolynomial.eval v Q = 0 →
        ∃ l, MvPolynomial.eval v (MvPolynomial.pderiv l Q) ≠ 0 := by
    intro v hv _
    exact exists_eval_pderiv_ne_zero_of_det_polarMatrix_ne_zero Q hQhom hdet v hv
  have hg :
      MvPolynomial.map ι
          (baseChangedChartEquation (i := i) (j := j) y F) =
        ProjectiveSpace.chartDehomogenization 2 K i Q := by
    have hbase :=
      baseChangedChartEquation_eq_chartDehomogenization_genericChart F i j y
    rw [hbase]
    have hQdef : Q = MvPolynomial.map ι
        (MvPolynomial.map y.toRingHom (genericSndConicChart j F)) := by
      dsimp only [Q, yK]
      rw [MvPolynomial.map_map]
      congr 1
    rw [hQdef]
    exact (chartDehomogenization_map i
      (MvPolynomial.map y.toRingHom (genericSndConicChart j F))).symm
  rw [hg]
  exact isDomain_chartDehomogenization_quotient_of_nonsingular
    i Q hQhom hQ0 hnonsing

/-- The universal affine conic chart has no nonunit factor coming solely from the base chart.

Indeed, a nonunit regular function on the affine base chart has a closed zero by the
Nullstellensatz.  If it divided the whole conic equation, specialization at that zero would make
the projective conic equation identically zero, contradicting the no-whole-fibre consequence of
smoothness. -/
theorem isUnit_of_C_dvd_genericConicAffineChart
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i : Fin 3)
    (r : ProjectiveSpace.StandardChartRing 2 k 0)
    (hr : MvPolynomial.C r ∣
      ProjectiveSpace.chartDehomogenization 2
        (ProjectiveSpace.StandardChartRing 2 k 0) i
        (genericSndConicChartZero F)) :
    IsUnit r := by
  by_contra hrun
  let e := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k 0
  have herun : ¬ IsUnit (e r) := by
    intro her
    apply hrun
    have her' : IsUnit (e.symm (e r)) := her.map e.symm
    simpa using her'
  obtain ⟨v, hv⟩ := exists_eval_eq_zero_of_not_isUnit (e r) herun
  let ev : ProjectiveSpace.StandardChartRing 2 k 0 →ₐ[k] k :=
    (MvPolynomial.aeval v).comp e.toAlgHom
  have hevr : ev r = 0 := by
    change MvPolynomial.aeval v (e r) = 0
    simpa using hv
  let Q : MvPolynomial (Fin 3) (ProjectiveSpace.StandardChartRing 2 k 0) :=
    genericSndConicChartZero F
  let g : MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k 0) :=
    ProjectiveSpace.chartDehomogenization 2
      (ProjectiveSpace.StandardChartRing 2 k 0) i Q
  obtain ⟨a, ha⟩ := hr
  have hmapg : MvPolynomial.map ev.toRingHom g = 0 := by
    rw [show g = MvPolynomial.C r * a by simpa [g, Q] using ha]
    simp [hevr]
  letI algChartK : Algebra (ProjectiveSpace.StandardChartRing 2 k 0) k :=
    RingHom.toAlgebra ev.toRingHom
  have halg : algebraMap (ProjectiveSpace.StandardChartRing 2 k 0) k = ev.toRingHom := rfl
  have hdeh : ProjectiveSpace.chartDehomogenization 2 k i
      (MvPolynomial.map ev.toRingHom Q) = 0 := by
    have hmapg' : MvPolynomial.map
        (algebraMap (ProjectiveSpace.StandardChartRing 2 k 0) k) g = 0 := by
      rwa [halg]
    rw [show ev.toRingHom =
      algebraMap (ProjectiveSpace.StandardChartRing 2 k 0) k from halg.symm]
    rw [chartDehomogenization_map i Q]
    simpa [g] using hmapg'
  have hQhom : Q.IsHomogeneous 2 := by
    dsimp only [Q]
    rw [genericSndConicChartZero]
    exact (hF.map_coefficients
      (algebraMap k (ProjectiveSpace.StandardChartRing 2 k 0)))
        |>.specializeSecondCoordinates_isHomogeneous _
  have hmapQhom : (MvPolynomial.map ev.toRingHom Q).IsHomogeneous 2 :=
    hQhom.map ev.toRingHom
  have hmapQzero : MvPolynomial.map ev.toRingHom Q = 0 :=
    ProjectiveSpace.chartDehomogenization_eq_zero_of_isHomogeneous
      2 i 2 (MvPolynomial.map ev.toRingHom Q) hmapQhom hdeh
  have hcompare := map_genericSndConicChartZero F ev
  have hspecialize :
      specializeSecondCoordinates (secondNormalizedCoordinates ev) F = 0 := by
    rw [hcompare] at hmapQzero
    have hself : algebraMap k k = RingHom.id k := by
      ext x
      simp
    rw [hself, MvPolynomial.map_id] at hmapQzero
    simpa [Q] using hmapQzero
  exact BiprojectiveSpace.not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23
    k F hF hF0 0 (secondNormalizedCoordinates ev)
      (secondNormalizedCoordinates_self ev) hspecialize

/-- Arbitrary-base-chart form of `isUnit_of_C_dvd_genericConicAffineChart`. -/
theorem isUnit_of_C_dvd_genericConicAffineChart_of_chart
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (i j : Fin 3)
    (r : ProjectiveSpace.StandardChartRing 2 k j)
    (hr : MvPolynomial.C r ∣
      ProjectiveSpace.chartDehomogenization 2
        (ProjectiveSpace.StandardChartRing 2 k j) i
        (genericSndConicChart j F)) :
    IsUnit r := by
  by_contra hrun
  let e := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
  have herun : ¬ IsUnit (e r) := by
    intro her
    apply hrun
    have her' : IsUnit (e.symm (e r)) := her.map e.symm
    simpa using her'
  obtain ⟨v, hv⟩ := exists_eval_eq_zero_of_not_isUnit (e r) herun
  let ev : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] k :=
    (MvPolynomial.aeval v).comp e.toAlgHom
  have hevr : ev r = 0 := by
    change MvPolynomial.aeval v (e r) = 0
    simpa using hv
  let Q : MvPolynomial (Fin 3) (ProjectiveSpace.StandardChartRing 2 k j) :=
    genericSndConicChart j F
  let g : MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j) :=
    ProjectiveSpace.chartDehomogenization 2
      (ProjectiveSpace.StandardChartRing 2 k j) i Q
  obtain ⟨a, ha⟩ := hr
  have hmapg : MvPolynomial.map ev.toRingHom g = 0 := by
    rw [show g = MvPolynomial.C r * a by simpa [g, Q] using ha]
    simp [hevr]
  letI algChartK : Algebra (ProjectiveSpace.StandardChartRing 2 k j) k :=
    RingHom.toAlgebra ev.toRingHom
  have halg : algebraMap (ProjectiveSpace.StandardChartRing 2 k j) k =
      ev.toRingHom := rfl
  have hdeh : ProjectiveSpace.chartDehomogenization 2 k i
      (MvPolynomial.map ev.toRingHom Q) = 0 := by
    have hmapg' : MvPolynomial.map
        (algebraMap (ProjectiveSpace.StandardChartRing 2 k j) k) g = 0 := by
      rwa [halg]
    rw [show ev.toRingHom =
      algebraMap (ProjectiveSpace.StandardChartRing 2 k j) k from halg.symm]
    rw [chartDehomogenization_map i Q]
    simpa [g] using hmapg'
  have hQhom : Q.IsHomogeneous 2 := by
    dsimp only [Q]
    rw [genericSndConicChart]
    exact (hF.map_coefficients
      (algebraMap k (ProjectiveSpace.StandardChartRing 2 k j)))
        |>.specializeSecondCoordinates_isHomogeneous _
  have hmapQhom : (MvPolynomial.map ev.toRingHom Q).IsHomogeneous 2 :=
    hQhom.map ev.toRingHom
  have hmapQzero : MvPolynomial.map ev.toRingHom Q = 0 :=
    ProjectiveSpace.chartDehomogenization_eq_zero_of_isHomogeneous
      2 i 2 (MvPolynomial.map ev.toRingHom Q) hmapQhom hdeh
  have hcompare := map_genericSndConicChart F j ev
  have hspecialize :
      specializeSecondCoordinates (secondNormalizedCoordinates ev) F = 0 := by
    rw [hcompare] at hmapQzero
    have hself : algebraMap k k = RingHom.id k := by
      ext x
      simp
    rw [hself, MvPolynomial.map_id] at hmapQzero
    simpa [Q] using hmapQzero
  exact BiprojectiveSpace.not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23
    k F hF hF0 j (secondNormalizedCoordinates ev)
      (secondNormalizedCoordinates_self ev) hspecialize

/-- The universal affine conic equation on `Y₀ ≠ 0` is irreducible over the whole affine
base chart, not merely over its fraction field.

Generic irreducibility comes from the nonzero polar determinant.  The only possible obstruction
to descending irreducibility from the fraction field is a scalar factor in the base ring, and
`isUnit_of_C_dvd_genericConicAffineChart` excludes exactly that obstruction using smoothness. -/
theorem irreducible_genericConicAffineChart
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i : Fin 3) :
    Irreducible
      (ProjectiveSpace.chartDehomogenization 2
        (ProjectiveSpace.StandardChartRing 2 k 0) i
        (genericSndConicChartZero F)) := by
  let R := ProjectiveSpace.StandardChartRing 2 k 0
  let eR := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k 0
  letI : IsDomain R := eR.toRingEquiv.toMulEquiv.isDomain _
  letI : UniqueFactorizationMonoid R :=
    eR.toRingEquiv.toMulEquiv.symm.uniqueFactorizationMonoid inferInstance
  let Q : MvPolynomial (Fin 3) R := genericSndConicChartZero F
  let g : MvPolynomial (Fin 2) R :=
    ProjectiveSpace.chartDehomogenization 2 R i Q
  let y0 : R →ₐ[k] R := AlgHom.id k R
  have hy0 : Function.Injective y0.toRingHom := fun _ _ h ↦ h
  letI : IsDominant (Spec.map (CommRingCat.ofHom y0.toRingHom)) :=
    isDominant_specMap_of_injective y0.toRingHom hy0
  have hbase : baseChangedChartEquation (i := i) (j := 0) y0 F = g := by
    rw [baseChangedChartEquation_eq_chartDehomogenization_generic F i y0]
    change ProjectiveSpace.chartDehomogenization 2 R i
      (MvPolynomial.map y0.toRingHom (genericSndConicChartZero F)) = g
    have hyid : y0.toRingHom = RingHom.id R := rfl
    rw [hyid, MvPolynomial.map_id]
  haveI hgenericDomain : IsDomain
      (MvPolynomial (Fin 2) (FractionRing R) ⧸
        Ideal.span {MvPolynomial.map (algebraMap R (FractionRing R)) g}) := by
    have h := isDomain_fractionRing_genericConicAffineChart F hF hF0 y0 i
    rwa [hbase] at h
  have hscalar : ∀ r : R, MvPolynomial.C r ∣ g → IsUnit r := by
    intro r hr
    exact isUnit_of_C_dvd_genericConicAffineChart F hF hF0 i r (by
      simpa [g, Q] using hr)
  have hg0 : g ≠ 0 := by
    intro hg
    have hzero : MvPolynomial.C (0 : R) ∣ g := by
      rw [hg]
      exact ⟨0, by simp⟩
    exact (hscalar 0 hzero).ne_zero rfl
  have hmapg0 : MvPolynomial.map (algebraMap R (FractionRing R)) g ≠ 0 :=
    by
      simpa using
        (MvPolynomial.map_injective _ (IsFractionRing.injective R (FractionRing R))).ne hg0
  have hprimeIdeal :
      (Ideal.span
        {MvPolynomial.map (algebraMap R (FractionRing R)) g}).IsPrime :=
    (Ideal.Quotient.isDomain_iff_prime _).mp inferInstance
  have hprime : Prime (MvPolynomial.map (algebraMap R (FractionRing R)) g) :=
    (Ideal.span_singleton_prime hmapg0).mp hprimeIdeal
  have hirrK : Irreducible
      (MvPolynomial.map (algebraMap R (FractionRing R)) g) := hprime.irreducible
  simpa [g, Q] using
    (irreducible_mvPolynomial_of_fractionMap_of_scalar_factors g hirrK hscalar)

/-- Consequently every first-factor affine chart of the universal conic over `Y₀ ≠ 0` has
a domain coordinate ring.  This is the affine target-chart integrality needed by the direct
stereographic dominance argument, proved without flatness. -/
theorem isDomain_genericConicAffineChart
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i : Fin 3) :
    IsDomain
      (MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k 0) ⧸
        Ideal.span
          {ProjectiveSpace.chartDehomogenization 2
            (ProjectiveSpace.StandardChartRing 2 k 0) i
            (genericSndConicChartZero F)}) := by
  let g : MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k 0) :=
    ProjectiveSpace.chartDehomogenization 2
      (ProjectiveSpace.StandardChartRing 2 k 0) i
      (genericSndConicChartZero F)
  let eR := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k 0
  letI : UniqueFactorizationMonoid (ProjectiveSpace.StandardChartRing 2 k 0) :=
    eR.toRingEquiv.toMulEquiv.symm.uniqueFactorizationMonoid inferInstance
  have hg : Irreducible g := irreducible_genericConicAffineChart F hF hF0 i
  have hg0 : g ≠ 0 := hg.ne_zero
  haveI : (Ideal.span {g}).IsPrime :=
    (Ideal.span_singleton_prime hg0).mpr hg.prime
  exact inferInstance

/-- Every affine chart of the universal conic, over every second-factor standard chart, has an
irreducible defining equation. -/
theorem irreducible_genericConicAffineChart_of_chart
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (i j : Fin 3) :
    Irreducible
      (ProjectiveSpace.chartDehomogenization 2
        (ProjectiveSpace.StandardChartRing 2 k j) i
        (genericSndConicChart j F)) := by
  let R := ProjectiveSpace.StandardChartRing 2 k j
  let eR := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
  letI : IsDomain R := eR.toRingEquiv.toMulEquiv.isDomain _
  letI : UniqueFactorizationMonoid R :=
    eR.toRingEquiv.toMulEquiv.symm.uniqueFactorizationMonoid inferInstance
  let Q : MvPolynomial (Fin 3) R := genericSndConicChart j F
  let g : MvPolynomial (Fin 2) R :=
    ProjectiveSpace.chartDehomogenization 2 R i Q
  let yj : R →ₐ[k] R := AlgHom.id k R
  have hyj : Function.Injective yj.toRingHom := fun _ _ h ↦ h
  letI : IsDominant (Spec.map (CommRingCat.ofHom yj.toRingHom)) :=
    isDominant_specMap_of_injective yj.toRingHom hyj
  have hbase : baseChangedChartEquation (i := i) (j := j) yj F = g := by
    rw [baseChangedChartEquation_eq_chartDehomogenization_genericChart F i j yj]
    change ProjectiveSpace.chartDehomogenization 2 R i
      (MvPolynomial.map yj.toRingHom (genericSndConicChart j F)) = g
    have hyid : yj.toRingHom = RingHom.id R := rfl
    rw [hyid, MvPolynomial.map_id]
  haveI hgenericDomain : IsDomain
      (MvPolynomial (Fin 2) (FractionRing R) ⧸
        Ideal.span {MvPolynomial.map (algebraMap R (FractionRing R)) g}) := by
    have h := isDomain_fractionRing_genericConicAffineChart_of_chart
      F hF hF0 j yj i
    rwa [hbase] at h
  have hscalar : ∀ r : R, MvPolynomial.C r ∣ g → IsUnit r := by
    intro r hr
    exact isUnit_of_C_dvd_genericConicAffineChart_of_chart F hF hF0 i j r (by
      simpa [g, Q] using hr)
  have hg0 : g ≠ 0 := by
    intro hg
    have hzero : MvPolynomial.C (0 : R) ∣ g := by
      rw [hg]
      exact ⟨0, by simp⟩
    exact (hscalar 0 hzero).ne_zero rfl
  have hmapg0 : MvPolynomial.map (algebraMap R (FractionRing R)) g ≠ 0 := by
    simpa using
      (MvPolynomial.map_injective _
        (IsFractionRing.injective R (FractionRing R))).ne hg0
  have hprimeIdeal :
      (Ideal.span
        {MvPolynomial.map (algebraMap R (FractionRing R)) g}).IsPrime :=
    (Ideal.Quotient.isDomain_iff_prime _).mp inferInstance
  have hprime : Prime (MvPolynomial.map (algebraMap R (FractionRing R)) g) :=
    (Ideal.span_singleton_prime hmapg0).mp hprimeIdeal
  have hirrK : Irreducible
      (MvPolynomial.map (algebraMap R (FractionRing R)) g) := hprime.irreducible
  simpa [g, Q] using
    (irreducible_mvPolynomial_of_fractionMap_of_scalar_factors g hirrK hscalar)

/-- All nine affine product charts of the universal hypersurface have domain coordinate rings,
proved directly from the generic conic rather than from flatness of the global pullback. -/
theorem isDomain_genericConicAffineChart_of_chart
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (i j : Fin 3) :
    IsDomain
      (MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j) ⧸
        Ideal.span
          {ProjectiveSpace.chartDehomogenization 2
            (ProjectiveSpace.StandardChartRing 2 k j) i
            (genericSndConicChart j F)}) := by
  let g : MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j) :=
    ProjectiveSpace.chartDehomogenization 2
      (ProjectiveSpace.StandardChartRing 2 k j) i
      (genericSndConicChart j F)
  let eR := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
  letI : UniqueFactorizationMonoid (ProjectiveSpace.StandardChartRing 2 k j) :=
    eR.toRingEquiv.toMulEquiv.symm.uniqueFactorizationMonoid inferInstance
  have hg : Irreducible g :=
    irreducible_genericConicAffineChart_of_chart F hF hF0 i j
  have hg0 : g ≠ 0 := hg.ne_zero
  haveI : (Ideal.span {g}).IsPrime :=
    (Ideal.span_singleton_prime hg0).mpr hg.prime
  exact inferInstance

/-! ### Nonvanishing of transition coordinates -/

/-- On an affine chart of a nonsingular projective conic, neither affine coordinate vanishes at
the generic point.  Algebraically, its class in the irreducible chart quotient is nonzero.

The slightly stronger homogeneous argument is useful here: if the irreducible dehomogenization
were associated to one affine variable, homogenizing would factor the original ternary quadratic
as the product of two nonunits. -/
theorem quotient_chart_variable_ne_zero_of_nonsingular
    {K : Type u} [Field K] (i : Fin 3) (r : Fin 2)
    (Q : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hnonsing : ∀ v : Fin 3 → K, v ≠ 0 → MvPolynomial.eval v Q = 0 →
      ∃ j, MvPolynomial.eval v (MvPolynomial.pderiv j Q) ≠ 0) :
    Ideal.Quotient.mk
        (Ideal.span {ProjectiveSpace.chartDehomogenization 2 K i Q})
        (MvPolynomial.X r) ≠ 0 := by
  let g := ProjectiveSpace.chartDehomogenization 2 K i Q
  have hirrQ :=
    TernaryQuadratic.irreducible_of_isHomogeneous_two_of_nonsingular Q hQ hQ0 hnonsing
  have hirrg := irreducible_chartDehomogenization_of_irreducible_homogeneous_two
    i Q hQ hQ0 hirrQ
  intro hz
  have hdiv : g ∣ MvPolynomial.X r := by
    rw [← Ideal.mem_span_singleton]
    exact Ideal.Quotient.eq_zero_iff_mem.mp hz
  have hassoc : Associated g (MvPolynomial.X r) :=
    hirrg.associated_of_dvd MvPolynomial.X_prime.irreducible hdiv
  obtain ⟨u, hu⟩ := hassoc
  have huC : ∃ c : K, IsUnit c ∧ (u : MvPolynomial (Fin 2) K) = MvPolynomial.C c :=
    (MvPolynomial.isUnit_iff_eq_C_of_isReduced.mp u.isUnit)
  obtain ⟨c, hc, huc⟩ := huC
  have hc0 : c ≠ 0 := IsUnit.ne_zero hc
  have hg : g = MvPolynomial.C c⁻¹ * MvPolynomial.X r := by
    have hu' : g * MvPolynomial.C c = MvPolynomial.X r := by simpa [huc] using hu
    calc
      g = g * 1 := by rw [mul_one]
      _ = g * (MvPolynomial.C c * MvPolynomial.C c⁻¹) := by
        rw [← MvPolynomial.C_mul, mul_inv_cancel₀ hc0, MvPolynomial.C_1]
      _ = (g * MvPolynomial.C c) * MvPolynomial.C c⁻¹ := by rw [mul_assoc]
      _ = MvPolynomial.X r * MvPolynomial.C c⁻¹ := by rw [hu']
      _ = MvPolynomial.C c⁻¹ * MvPolynomial.X r := by rw [mul_comm]
  have hhomX : ProjectiveSpace.chartHomogenization (R := K) i 1
      (MvPolynomial.X r) = MvPolynomial.X (i.succAbove r) := by
    simpa using
      (ProjectiveSpace.chartHomogenization_chartDehomogenization
        i 1 (MvPolynomial.X (i.succAbove r) : MvPolynomial (Fin 3) K)
          (MvPolynomial.isHomogeneous_X K (i.succAbove r)))
  have hQeq : Q = MvPolynomial.X i * MvPolynomial.C c⁻¹ *
      MvPolynomial.X (i.succAbove r) := by
    rw [← ProjectiveSpace.chartHomogenization_chartDehomogenization i 2 Q hQ]
    change ProjectiveSpace.chartHomogenization (R := K) i 2 g = _
    rw [hg, ProjectiveSpace.chartHomogenization_mul i 1 1
      (MvPolynomial.C c⁻¹) (MvPolynomial.X r) (by simp) (by simp),
      ProjectiveSpace.chartHomogenization_C, hhomX]
    ring
  have hXi : ¬ IsUnit (MvPolynomial.X i : MvPolynomial (Fin 3) K) :=
    MvPolynomial.X_prime.irreducible.not_isUnit
  have hXj : ¬ IsUnit
      (MvPolynomial.C c⁻¹ * MvPolynomial.X (i.succAbove r) :
        MvPolynomial (Fin 3) K) := by
    intro hh
    have : IsUnit (MvPolynomial.X (i.succAbove r) : MvPolynomial (Fin 3) K) :=
      (IsUnit.mul_iff.mp hh).2
    exact MvPolynomial.X_prime.irreducible.not_isUnit this
  have hfac : Q = MvPolynomial.X i *
      (MvPolynomial.C c⁻¹ * MvPolynomial.X (i.succAbove r)) := by
    simpa [mul_assoc] using hQeq
  obtain hu1 | hu2 := hirrQ.isUnit_or_isUnit hfac
  · exact hXi hu1
  · exact hXj hu2

/-- Fraction-field form of transition-coordinate nonvanishing.  This lets us prove a statement
over a polynomial coefficient ring while doing the conic geometry over its fraction field. -/
theorem quotient_chart_variable_ne_zero_of_fraction_det
    {R : Type u} [CommRing R] [IsDomain R]
    (i : Fin 3) (r : Fin 2) (Q : MvPolynomial (Fin 3) R)
    (hQ : Q.IsHomogeneous 2)
    (hdet : (polarMatrix
      (MvPolynomial.map (algebraMap R (FractionRing R)) Q)).det ≠ 0) :
    Ideal.Quotient.mk
        (Ideal.span {ProjectiveSpace.chartDehomogenization 2 R i Q})
        (MvPolynomial.X r) ≠ 0 := by
  let K := FractionRing R
  let ι : R →+* K := algebraMap R K
  let QK : MvPolynomial (Fin 3) K := MvPolynomial.map ι Q
  have hQK : QK.IsHomogeneous 2 := hQ.map ι
  have hQK0 : QK ≠ 0 := by
    intro hzero
    apply hdet
    rw [show MvPolynomial.map (algebraMap R (FractionRing R)) Q = QK from rfl,
      hzero]
    have hz : polarMatrix (0 : MvPolynomial (Fin 3) K) = 0 := by
      ext a b
      simp [polarMatrix, polarEval]
    rw [hz, Matrix.det_zero]
  have hnonsing :
      ∀ v : Fin 3 → K, v ≠ 0 → MvPolynomial.eval v QK = 0 →
        ∃ l, MvPolynomial.eval v (MvPolynomial.pderiv l QK) ≠ 0 := by
    intro v hv _
    exact exists_eval_pderiv_ne_zero_of_det_polarMatrix_ne_zero QK hQK hdet v hv
  intro hz
  have hdiv : ProjectiveSpace.chartDehomogenization 2 R i Q ∣
      MvPolynomial.X r := by
    rw [← Ideal.mem_span_singleton]
    exact Ideal.Quotient.eq_zero_iff_mem.mp hz
  obtain ⟨a, ha⟩ := hdiv
  have hdivK : ProjectiveSpace.chartDehomogenization 2 K i QK ∣
      MvPolynomial.X r := by
    refine ⟨MvPolynomial.map ι a, ?_⟩
    calc
      MvPolynomial.X r = MvPolynomial.map ι (MvPolynomial.X r) := by
        rw [MvPolynomial.map_X]
      _ = MvPolynomial.map ι
          (ProjectiveSpace.chartDehomogenization 2 R i Q * a) :=
        congrArg (MvPolynomial.map ι) ha
      _ = MvPolynomial.map ι
            (ProjectiveSpace.chartDehomogenization 2 R i Q) *
          MvPolynomial.map ι a := by rw [map_mul]
      _ = ProjectiveSpace.chartDehomogenization 2 K i QK *
          MvPolynomial.map ι a := by
        change MvPolynomial.map ι
            (ProjectiveSpace.chartDehomogenization 2 R i Q) *
          MvPolynomial.map ι a =
            ProjectiveSpace.chartDehomogenization 2 K i
              (MvPolynomial.map ι Q) * MvPolynomial.map ι a
        rw [chartDehomogenization_map]
  exact quotient_chart_variable_ne_zero_of_nonsingular i r QK hQK hQK0 hnonsing
    (Ideal.Quotient.eq_zero_iff_mem.mpr
      (Ideal.mem_span_singleton.mpr hdivK))

/-- A nonzero scalar from a domain remains nonzero modulo `g` whenever `g` stays irreducible
after passage to the fraction field. -/
theorem quotient_C_ne_zero_of_fraction_irreducible
    {R σ : Type*} [CommRing R] [IsDomain R]
    (g : MvPolynomial σ R)
    (hirr : Irreducible
      (MvPolynomial.map (algebraMap R (FractionRing R)) g))
    (s : R) (hs : s ≠ 0) :
    Ideal.Quotient.mk (Ideal.span {g}) (MvPolynomial.C s) ≠ 0 := by
  let ι : R →+* FractionRing R := algebraMap R (FractionRing R)
  intro hz
  have hdiv : g ∣ MvPolynomial.C s := by
    rw [← Ideal.mem_span_singleton]
    exact Ideal.Quotient.eq_zero_iff_mem.mp hz
  obtain ⟨a, ha⟩ := hdiv
  have hdivK : MvPolynomial.map ι g ∣ MvPolynomial.C (ι s) := by
    refine ⟨MvPolynomial.map ι a, ?_⟩
    calc
      MvPolynomial.C (ι s) = MvPolynomial.map ι (MvPolynomial.C s) := by
        rw [MvPolynomial.map_C]
      _ = MvPolynomial.map ι (g * a) := congrArg (MvPolynomial.map ι) ha
      _ = MvPolynomial.map ι g * MvPolynomial.map ι a := by rw [map_mul]
  have hιs : ι s ≠ 0 := by
    have := (IsFractionRing.injective R (FractionRing R)).ne hs
    simpa [ι] using this
  have hunit : IsUnit (MvPolynomial.C (ι s) : MvPolynomial σ (FractionRing R)) :=
    ((isUnit_iff_ne_zero.mpr hιs).map MvPolynomial.C)
  exact hirr.not_isUnit (isUnit_of_dvd_unit hdivK hunit)

/-- The polar determinant of the universal chart conic stays nonzero over the fraction field of
the base chart. -/
theorem det_polarMatrix_fraction_genericSndConicChart_ne_zero
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (j : Fin 3) :
    (polarMatrix (MvPolynomial.map
      (algebraMap (ProjectiveSpace.StandardChartRing 2 k j)
        (FractionRing (ProjectiveSpace.StandardChartRing 2 k j)))
      (genericSndConicChart j F))).det ≠ 0 := by
  let R := ProjectiveSpace.StandardChartRing 2 k j
  let eR := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
  letI : IsDomain R := eR.toRingEquiv.toMulEquiv.isDomain _
  let K := FractionRing R
  let yK : R →ₐ[k] K := IsScalarTower.toAlgHom k R K
  have hyK : Function.Injective yK.toRingHom := by
    exact IsFractionRing.injective R K
  letI : IsDominant (Spec.map (CommRingCat.ofHom yK.toRingHom)) :=
    isDominant_specMap_of_injective yK.toRingHom hyK
  have hdet := det_polarMatrix_map_genericSndConicChart_ne_zero
    F hF hF0 j yK
  simpa [R, K, yK] using hdet

/-- The fraction-field affine equation of every universal conic chart is irreducible. -/
theorem irreducible_fraction_genericConicAffineChart_of_chart
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (i j : Fin 3) :
    Irreducible
      (MvPolynomial.map
        (algebraMap (ProjectiveSpace.StandardChartRing 2 k j)
          (FractionRing (ProjectiveSpace.StandardChartRing 2 k j)))
        (ProjectiveSpace.chartDehomogenization 2
          (ProjectiveSpace.StandardChartRing 2 k j) i
          (genericSndConicChart j F))) := by
  let R := ProjectiveSpace.StandardChartRing 2 k j
  let eR := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
  letI : IsDomain R := eR.toRingEquiv.toMulEquiv.isDomain _
  let K := FractionRing R
  let ι : R →+* K := algebraMap R K
  let QK : MvPolynomial (Fin 3) K :=
    MvPolynomial.map ι (genericSndConicChart j F)
  have hQ : (genericSndConicChart j F).IsHomogeneous 2 := by
    rw [genericSndConicChart]
    exact (hF.map_coefficients (algebraMap k R))
      |>.specializeSecondCoordinates_isHomogeneous _
  have hQK : QK.IsHomogeneous 2 := hQ.map ι
  have hdet : (polarMatrix QK).det ≠ 0 := by
    exact det_polarMatrix_fraction_genericSndConicChart_ne_zero F hF hF0 j
  have hQK0 : QK ≠ 0 := by
    intro hzero
    apply hdet
    rw [hzero]
    have hz : polarMatrix (0 : MvPolynomial (Fin 3) K) = 0 := by
      ext a b
      simp [polarMatrix, polarEval]
    rw [hz, Matrix.det_zero]
  have hnonsing :
      ∀ v : Fin 3 → K, v ≠ 0 → MvPolynomial.eval v QK = 0 →
        ∃ l, MvPolynomial.eval v (MvPolynomial.pderiv l QK) ≠ 0 := by
    intro v hv _
    exact exists_eval_pderiv_ne_zero_of_det_polarMatrix_ne_zero QK hQK hdet v hv
  have hirrQ :=
    TernaryQuadratic.irreducible_of_isHomogeneous_two_of_nonsingular
      QK hQK hQK0 hnonsing
  change Irreducible (MvPolynomial.map ι
    (ProjectiveSpace.chartDehomogenization 2 R i (genericSndConicChart j F)))
  rw [← chartDehomogenization_map]
  change Irreducible (ProjectiveSpace.chartDehomogenization 2 K i QK)
  exact irreducible_chartDehomogenization_of_irreducible_homogeneous_two
    i QK hQK hQK0 hirrQ

/-- Every first-block transition coordinate is nonzero in the universal affine chart quotient. -/
theorem quotient_genericConicChart_X_ne_zero
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i j : Fin 3) (r : Fin 2) :
    Ideal.Quotient.mk
      (Ideal.span
        {ProjectiveSpace.chartDehomogenization 2
          (ProjectiveSpace.StandardChartRing 2 k j) i
          (genericSndConicChart j F)})
      (MvPolynomial.X r) ≠ 0 := by
  let R := ProjectiveSpace.StandardChartRing 2 k j
  let eR := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
  letI : IsDomain R := eR.toRingEquiv.toMulEquiv.isDomain _
  have hQ : (genericSndConicChart j F).IsHomogeneous 2 := by
    rw [genericSndConicChart]
    exact (hF.map_coefficients (algebraMap k R))
      |>.specializeSecondCoordinates_isHomogeneous _
  exact quotient_chart_variable_ne_zero_of_fraction_det i r
    (genericSndConicChart j F) hQ
      (det_polarMatrix_fraction_genericSndConicChart_ne_zero F hF hF0 j)

/-- Every normalized base coordinate is nonzero in its standard-chart coordinate ring. -/
theorem normalizedCoordinate_ne_zero
    {k : Type u} [Field k] (j l : Fin 3) :
    ProjectiveSpace.normalizedCoordinate 2 k j l ≠ 0 := by
  rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨r, rfl⟩
  · intro hz
    have h := congrArg
      (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k l) hz
    have h10 : (1 : MvPolynomial (Fin 2) k) = 0 := by simpa using h
    exact one_ne_zero h10
  · intro hz
    have h := congrArg
      (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j) hz
    have hX0 : (MvPolynomial.X r : MvPolynomial (Fin 2) k) = 0 := by
      simpa using h
    exact MvPolynomial.X_ne_zero r hX0

/-- Every second-block transition coordinate is nonzero in the universal affine chart quotient. -/
theorem quotient_genericConicChart_C_normalizedCoordinate_ne_zero
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i j l : Fin 3) :
    Ideal.Quotient.mk
      (Ideal.span
        {ProjectiveSpace.chartDehomogenization 2
          (ProjectiveSpace.StandardChartRing 2 k j) i
          (genericSndConicChart j F)})
      (MvPolynomial.C
        (ProjectiveSpace.normalizedCoordinate 2 k j l)) ≠ 0 := by
  let R := ProjectiveSpace.StandardChartRing 2 k j
  let eR := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
  letI : IsDomain R := eR.toRingEquiv.toMulEquiv.isDomain _
  exact quotient_C_ne_zero_of_fraction_irreducible
    (ProjectiveSpace.chartDehomogenization 2 R i (genericSndConicChart j F))
    (irreducible_fraction_genericConicAffineChart_of_chart F hF hF0 i j)
    (ProjectiveSpace.normalizedCoordinate 2 k j l)
    (normalizedCoordinate_ne_zero j l)

/-! ### Comparison with the four-variable affine product chart -/

/-- Split the four affine product-chart variables into the two conic variables over the
two-variable second-chart coefficient ring. -/
noncomputable def affineChartEquivConicChart
    (k : Type u) [Field k] (j : Fin 3) :
    MvPolynomial (Fin 2 ⊕ Fin 2) k ≃ₐ[k]
      MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j) :=
  (MvPolynomial.sumAlgEquiv k (Fin 2) (Fin 2)).trans
    (MvPolynomial.mapAlgEquiv (Fin 2)
      (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j).symm)

@[simp]
theorem affineChartEquivConicChart_X_inl
    {k : Type u} [Field k] (j : Fin 3) (r : Fin 2) :
    affineChartEquivConicChart k j (MvPolynomial.X (.inl r)) =
      MvPolynomial.X r := by
  simp [affineChartEquivConicChart]

@[simp]
theorem affineChartEquivConicChart_X_inr
    {k : Type u} [Field k] (j : Fin 3) (r : Fin 2) :
    affineChartEquivConicChart k j (MvPolynomial.X (.inr r)) =
      MvPolynomial.C (ProjectiveSpace.normalizedCoordinate 2 k j (j.succAbove r)) := by
  simp only [affineChartEquivConicChart, AlgEquiv.trans_apply,
    MvPolynomial.sumAlgEquiv_X_inr, MvPolynomial.mapAlgEquiv_apply,
    MvPolynomial.map_C]
  congr 1
  change (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j).symm
      (MvPolynomial.X r) = _
  simpa only
      [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
    using (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j).symm_apply_apply
      (ProjectiveSpace.normalizedCoordinate 2 k j (j.succAbove r))

/-- The Cox coordinates in the iterated affine presentation. -/
def conicAffineChartVariable
    {k : Type u} [Field k] (i j : Fin 3) :
    BiprojectiveCoordinate 2 2 →
      MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j)
  | .inl l => i.succAboveCases 1 (fun r => MvPolynomial.X r) l
  | .inr l => MvPolynomial.C (ProjectiveSpace.normalizedCoordinate 2 k j l)

theorem affineChartEquivConicChart_affineChartVariable
    {k : Type u} [Field k] (i j : Fin 3)
    (z : BiprojectiveCoordinate 2 2) :
    affineChartEquivConicChart k j
        (affineChartVariable 2 2 k i j z) =
      conicAffineChartVariable i j z := by
  rcases z with l | l
  · rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
    · simp [affineChartVariable, conicAffineChartVariable]
    · simp [affineChartVariable, conicAffineChartVariable]
  · rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨r, rfl⟩
    · simp [affineChartVariable, conicAffineChartVariable]
    · simp [affineChartVariable, conicAffineChartVariable]

/-- An algebra homomorphism commutes with multivariable evaluation. -/
theorem map_aeval_algHom_general
    {R A S σ : Type*} [CommSemiring R] [CommSemiring A] [CommSemiring S]
    [Algebra R A] [Algebra R S] (f : A →ₐ[R] S) (x : σ → A)
    (p : MvPolynomial σ R) :
    f (MvPolynomial.aeval x p) =
      MvPolynomial.aeval (fun z => f (x z)) p := by
  change f.toRingHom (MvPolynomial.aeval x p) = _
  rw [MvPolynomial.map_aeval]
  rw [show f.toRingHom.comp (algebraMap R A) = algebraMap R S by
    ext r
    exact f.commutes r]
  rfl

/-- The ordinary four-variable affine chart equation becomes the iterated universal conic
chart equation under `affineChartEquivConicChart`. -/
theorem affineChartEquivConicChart_affineChartEquation
    {k : Type u} [Field k] (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i j : Fin 3) :
    affineChartEquivConicChart k j (affineChartEquation 2 2 k i j F) =
      ProjectiveSpace.chartDehomogenization 2
        (ProjectiveSpace.StandardChartRing 2 k j) i
        (genericSndConicChart j F) := by
  have hleft :
      affineChartEquivConicChart k j (affineChartEquation 2 2 k i j F) =
        MvPolynomial.aeval (conicAffineChartVariable i j) F := by
    rw [affineChartEquation, affineChartEvaluation]
    exact map_aeval_algHom_general (affineChartEquivConicChart k j).toAlgHom
      (affineChartVariable 2 2 k i j) F |>.trans (by
        apply congrArg (fun φ : MvPolynomial (BiprojectiveCoordinate 2 2) k →ₐ[k]
          MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j) => φ F)
        apply MvPolynomial.algHom_ext
        intro z
        simp only [MvPolynomial.aeval_X]
        exact affineChartEquivConicChart_affineChartVariable i j z)
  rw [hleft, genericSndConicChart, specializeSecondCoordinates]
  rw [map_aeval_algHom_general
    (ProjectiveSpace.chartDehomogenization 2
      (ProjectiveSpace.StandardChartRing 2 k j) i)]
  rw [MvPolynomial.aeval_map_algebraMap]
  apply congrArg (fun φ : MvPolynomial (BiprojectiveCoordinate 2 2) k →ₐ[k]
    MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j) => φ F)
  apply MvPolynomial.algHom_ext
  intro z
  simp only [MvPolynomial.aeval_X]
  rcases z with l | l
  · rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
    · simp [conicAffineChartVariable]
    · simp [conicAffineChartVariable]
  · simp [conicAffineChartVariable]

/-- Quotient-level comparison between the ordinary four-variable product chart and the iterated
conic chart. -/
noncomputable def affineChartQuotientEquivConicChart
    {k : Type u} [Field k] (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i j : Fin 3) :
    (MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸
      Ideal.span {affineChartEquation 2 2 k i j F}) ≃+*
    (MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j) ⧸
      Ideal.span
        {ProjectiveSpace.chartDehomogenization 2
          (ProjectiveSpace.StandardChartRing 2 k j) i
          (genericSndConicChart j F)}) :=
  Ideal.quotientEquiv _ _ (affineChartEquivConicChart k j).toRingEquiv (by
    rw [Ideal.map_span, Set.image_singleton]
    exact congrArg (fun g => Ideal.span ({g} : Set _))
      (affineChartEquivConicChart_affineChartEquation F i j).symm)

/-- Every normalized homogeneous coordinate is nonzero at the generic point of the iterated
conic-chart quotient. -/
theorem quotient_conicAffineChartVariable_ne_zero
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i j : Fin 3) (z : BiprojectiveCoordinate 2 2) :
    Ideal.Quotient.mk
      (Ideal.span
        {ProjectiveSpace.chartDehomogenization 2
          (ProjectiveSpace.StandardChartRing 2 k j) i
          (genericSndConicChart j F)})
      (conicAffineChartVariable i j z) ≠ 0 := by
  letI : IsDomain
      (MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j) ⧸
        Ideal.span
          {ProjectiveSpace.chartDehomogenization 2
            (ProjectiveSpace.StandardChartRing 2 k j) i
            (genericSndConicChart j F)}) :=
    isDomain_genericConicAffineChart_of_chart F hF hF0 i j
  rcases z with l | l
  · rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
    · simpa [conicAffineChartVariable] using
        (one_ne_zero : (1 :
          MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j) ⧸
            Ideal.span
              {ProjectiveSpace.chartDehomogenization 2
                (ProjectiveSpace.StandardChartRing 2 k j) i
                (genericSndConicChart j F)}) ≠ 0)
    · simpa [conicAffineChartVariable] using
        quotient_genericConicChart_X_ne_zero F hF hF0 i j r
  · simpa [conicAffineChartVariable] using
      quotient_genericConicChart_C_normalizedCoordinate_ne_zero
        F hF hF0 i j l

/-- Every normalized homogeneous coordinate is nonzero in the ordinary four-variable product
chart quotient.  Equivalently, the generic point of one zero-locus chart lies in every ambient
standard product chart. -/
theorem quotient_affineChartVariable_ne_zero
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i j : Fin 3) (z : BiprojectiveCoordinate 2 2) :
    Ideal.Quotient.mk
      (Ideal.span {affineChartEquation 2 2 k i j F})
      (affineChartVariable 2 2 k i j z) ≠ 0 := by
  intro hz
  have hmap := congrArg (affineChartQuotientEquivConicChart F i j) hz
  rw [map_zero] at hmap
  have hmk :
      affineChartQuotientEquivConicChart F i j
        (Ideal.Quotient.mk
          (Ideal.span {affineChartEquation 2 2 k i j F})
          (affineChartVariable 2 2 k i j z)) =
        Ideal.Quotient.mk
          (Ideal.span
            {ProjectiveSpace.chartDehomogenization 2
              (ProjectiveSpace.StandardChartRing 2 k j) i
              (genericSndConicChart j F)})
          (conicAffineChartVariable i j z) := by
    unfold affineChartQuotientEquivConicChart
    rw [Ideal.quotientEquiv_mk]
    exact congrArg (Ideal.Quotient.mk _)
      (affineChartEquivConicChart_affineChartVariable i j z)
  rw [hmk] at hmap
  exact quotient_conicAffineChartVariable_ne_zero F hF hF0 i j z hmap

/-- Coordinate-ring map of the closed affine hypersurface chart into its ambient product chart. -/
def affineChartQuotientMap
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i j : Fin 3) :
    BiprojectiveSpace.StandardChartRing 2 2 k i j →+*
      (MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸
        Ideal.span {affineChartEquation 2 2 k i j F}) :=
  (Ideal.Quotient.mk _).comp
    (BiprojectiveSpace.standardChartRingEquivMvPolynomial 2 2 k i j).toRingHom

@[simp]
theorem affineChartQuotientMap_chartVariable
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i j : Fin 3) (z : BiprojectiveCoordinate 2 2) :
    affineChartQuotientMap F i j (BiprojectiveSpace.chartVariable 2 2 k i j z) =
      Ideal.Quotient.mk (Ideal.span {affineChartEquation 2 2 k i j F})
        (affineChartVariable 2 2 k i j z) := by
  change Ideal.Quotient.mk _
      (BiprojectiveSpace.standardChartRingEquivMvPolynomial 2 2 k i j
        (BiprojectiveSpace.chartVariable 2 2 k i j z)) = _
  rw [BiprojectiveSpace.standardChartRingEquivMvPolynomial_chartVariable]

/-- The explicit affine quotient mapped into its ambient standard product chart. -/
def affineChartQuotientToStandardChart
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i j : Fin 3) :
    Spec (.of (MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸
      Ideal.span {affineChartEquation 2 2 k i j F})) ⟶
        BiprojectiveSpace.standardChart 2 2 k i j :=
  Spec.map (CommRingCat.ofHom (affineChartQuotientMap F i j)) ≫
    (BiprojectiveSpace.standardChartIsoSpec 2 2 k i j).inv

/-- `Away.isLocalizationElem` for two projective variables is the normalized coordinate. -/
theorem away_isLocalizationElem_X_eq_normalizedCoordinate
    {k : Type u} [Field k] (i l : Fin 3) :
    HomogeneousLocalization.Away.isLocalizationElem
      (MvPolynomial.isHomogeneous_X k i) (MvPolynomial.isHomogeneous_X k l) =
      ProjectiveSpace.normalizedCoordinate 2 k i l := by
  unfold ProjectiveSpace.normalizedCoordinate
  change HomogeneousLocalization.Away.mk _ _ 1 (MvPolynomial.X l ^ 1) _ = _
  simp only [pow_one]

/-- The explicit coordinate ring of every affine product chart of the hypersurface is a domain. -/
theorem isDomain_affineChartQuotient
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (i j : Fin 3) :
    IsDomain
      (MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸
        Ideal.span {affineChartEquation 2 2 k i j F}) := by
  letI : IsDomain
      (MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j) ⧸
        Ideal.span
          {ProjectiveSpace.chartDehomogenization 2
            (ProjectiveSpace.StandardChartRing 2 k j) i
            (genericSndConicChart j F)}) :=
    isDomain_genericConicAffineChart_of_chart F hF hF0 i j
  exact (affineChartQuotientEquivConicChart F i j).toMulEquiv.isDomain _

/-- The generic point of an explicit affine zero-locus chart.  The domain instance is constructed
internally from the generic-conic argument, so downstream statements do not need to carry it as
an extra parameter. -/
noncomputable def affineChartGenericPoint
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i j : Fin 3) :
    Spec (.of (MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸
      Ideal.span {affineChartEquation 2 2 k i j F})) := by
  letI : IsDomain
      (MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸
        Ideal.span {affineChartEquation 2 2 k i j F}) :=
    isDomain_affineChartQuotient F hF hF0 i j
  exact genericPoint _

/-- Under the first-factor chart map, the affine chart's generic point lies in every projective
standard chart. -/
theorem affineChartGenericPoint_fst_mem_standardChart_range
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i j i' : Fin 3) :
    (ProjectiveSpace.standardChartι 2 k i).base
      ((Spec.map (CommRingCat.ofHom
        (affineChartQuotientXHom 2 2 k i j F))).base
          (affineChartGenericPoint F hF hF0 i j)) ∈
      Set.range (ProjectiveSpace.standardChartι 2 k i') := by
  let A := MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸
    Ideal.span {affineChartEquation 2 2 k i j F}
  letI : IsDomain A := isDomain_affineChartQuotient F hF hF0 i j
  let φ : ProjectiveSpace.StandardChartRing 2 k i →+* A :=
    affineChartQuotientXHom 2 2 k i j F
  let η := affineChartGenericPoint F hF hF0 i j
  change (ProjectiveSpace.standardChartι 2 k i).base
      ((Spec.map (CommRingCat.ofHom φ)).base η) ∈ _
  rw [← Scheme.Hom.coe_opensRange,
    ProjectiveSpace.opensRange_standardChartι]
  change (Spec.map (CommRingCat.ofHom φ)).base η ∈
    ((ProjectiveSpace.standardChartι 2 k i) ⁻¹ᵁ
      ProjectiveSpace.standardChart 2 k i' :
        (Spec (.of (ProjectiveSpace.StandardChartRing 2 k i))).Opens)
  change (Spec.map (CommRingCat.ofHom φ)).base η ∈
    (Proj.awayι _ (MvPolynomial.X i) (MvPolynomial.isHomogeneous_X k i) zero_lt_one ⁻¹ᵁ
      Proj.basicOpen _ (MvPolynomial.X i'))
  have hXi : MvPolynomial.X i ∈
      MvPolynomial.homogeneousSubmodule (Fin 3) k 1 := by
    simpa using MvPolynomial.isHomogeneous_X k i
  have hXi' : MvPolynomial.X i' ∈
      MvPolynomial.homogeneousSubmodule (Fin 3) k 1 := by
    simpa using MvPolynomial.isHomogeneous_X k i'
  rw [Proj.awayι_preimage_basicOpen
    (MvPolynomial.homogeneousSubmodule (Fin 3) k) hXi zero_lt_one hXi' zero_lt_one]
  change PrimeSpectrum.comap φ η ∈
    PrimeSpectrum.basicOpen
      (HomogeneousLocalization.Away.isLocalizationElem hXi hXi')
  rw [PrimeSpectrum.mem_basicOpen]
  have htransition :
      HomogeneousLocalization.Away.isLocalizationElem hXi hXi' =
        ProjectiveSpace.normalizedCoordinate 2 k i i' := by
    unfold ProjectiveSpace.normalizedCoordinate
    change HomogeneousLocalization.Away.mk _ _ 1 (MvPolynomial.X i' ^ 1) _ = _
    simp only [pow_one]
  rw [htransition]
  intro hmem
  rw [PrimeSpectrum.comap_asIdeal] at hmem
  have hη : η = (⊥ : PrimeSpectrum A) := by
    change affineChartGenericPoint F hF hF0 i j = _
    unfold affineChartGenericPoint
    exact genericPoint_eq_bot_of_affine (.of A)
  have heqzero : φ (ProjectiveSpace.normalizedCoordinate 2 k i i') = 0 := by
    simpa [hη] using hmem
  have hcoord :
      φ (ProjectiveSpace.normalizedCoordinate 2 k i i') =
        Ideal.Quotient.mk
          (Ideal.span {affineChartEquation 2 2 k i j F})
          (affineChartVariable 2 2 k i j (.inl i')) := by
    change affineChartQuotientMap F i j
      (ProjectiveSpace.normalizedCoordinate 2 k i i' ⊗ₜ[k] 1) = _
    rw [← BiprojectiveSpace.chartVariable_inl,
      affineChartQuotientMap_chartVariable]
  rw [hcoord] at heqzero
  exact quotient_affineChartVariable_ne_zero F hF hF0 i j (.inl i') heqzero

/-- Under the second-factor chart map, the affine chart's generic point lies in every projective
standard chart. -/
theorem affineChartGenericPoint_snd_mem_standardChart_range
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i j j' : Fin 3) :
    (ProjectiveSpace.standardChartι 2 k j).base
      ((Spec.map (CommRingCat.ofHom
        (affineChartQuotientYHom 2 2 k i j F))).base
          (affineChartGenericPoint F hF hF0 i j)) ∈
      Set.range (ProjectiveSpace.standardChartι 2 k j') := by
  let A := MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸
    Ideal.span {affineChartEquation 2 2 k i j F}
  letI : IsDomain A := isDomain_affineChartQuotient F hF hF0 i j
  let φ : ProjectiveSpace.StandardChartRing 2 k j →+* A :=
    affineChartQuotientYHom 2 2 k i j F
  let η := affineChartGenericPoint F hF hF0 i j
  change (ProjectiveSpace.standardChartι 2 k j).base
      ((Spec.map (CommRingCat.ofHom φ)).base η) ∈ _
  rw [← Scheme.Hom.coe_opensRange,
    ProjectiveSpace.opensRange_standardChartι]
  change (Spec.map (CommRingCat.ofHom φ)).base η ∈
    ((ProjectiveSpace.standardChartι 2 k j) ⁻¹ᵁ
      ProjectiveSpace.standardChart 2 k j' :
        (Spec (.of (ProjectiveSpace.StandardChartRing 2 k j))).Opens)
  change (Spec.map (CommRingCat.ofHom φ)).base η ∈
    (Proj.awayι _ (MvPolynomial.X j) (MvPolynomial.isHomogeneous_X k j) zero_lt_one ⁻¹ᵁ
      Proj.basicOpen _ (MvPolynomial.X j'))
  have hXj : MvPolynomial.X j ∈
      MvPolynomial.homogeneousSubmodule (Fin 3) k 1 := by
    simpa using MvPolynomial.isHomogeneous_X k j
  have hXj' : MvPolynomial.X j' ∈
      MvPolynomial.homogeneousSubmodule (Fin 3) k 1 := by
    simpa using MvPolynomial.isHomogeneous_X k j'
  rw [Proj.awayι_preimage_basicOpen
    (MvPolynomial.homogeneousSubmodule (Fin 3) k) hXj zero_lt_one hXj' zero_lt_one]
  change PrimeSpectrum.comap φ η ∈
    PrimeSpectrum.basicOpen
      (HomogeneousLocalization.Away.isLocalizationElem hXj hXj')
  rw [PrimeSpectrum.mem_basicOpen]
  have htransition :
      HomogeneousLocalization.Away.isLocalizationElem hXj hXj' =
        ProjectiveSpace.normalizedCoordinate 2 k j j' := by
    unfold ProjectiveSpace.normalizedCoordinate
    change HomogeneousLocalization.Away.mk _ _ 1 (MvPolynomial.X j' ^ 1) _ = _
    simp only [pow_one]
  rw [htransition]
  intro hmem
  rw [PrimeSpectrum.comap_asIdeal] at hmem
  have hη : η = (⊥ : PrimeSpectrum A) := by
    change affineChartGenericPoint F hF hF0 i j = _
    unfold affineChartGenericPoint
    exact genericPoint_eq_bot_of_affine (.of A)
  have heqzero : φ (ProjectiveSpace.normalizedCoordinate 2 k j j') = 0 := by
    simpa [hη] using hmem
  have hcoord :
      φ (ProjectiveSpace.normalizedCoordinate 2 k j j') =
        Ideal.Quotient.mk
          (Ideal.span {affineChartEquation 2 2 k i j F})
          (affineChartVariable 2 2 k i j (.inr j')) := by
    change affineChartQuotientMap F i j
      (1 ⊗ₜ[k] ProjectiveSpace.normalizedCoordinate 2 k j j') = _
    rw [← BiprojectiveSpace.chartVariable_inr,
      affineChartQuotientMap_chartVariable]
  rw [hcoord] at heqzero
  exact quotient_affineChartVariable_ne_zero F hF hF0 i j (.inr j') heqzero

/-- The image in the global biprojective zero locus of the generic point of one affine chart. -/
noncomputable def globalChartGenericPoint
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i j : Fin 3) : biprojectiveZeroLocus 2 2 k F :=
  (chartZeroLocusToGlobal 2 2 k F hF i j).base
    ((chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv.base
      (affineChartGenericPoint F hF hF0 i j))

/-- The generic point coming from any one affine chart belongs to every one of the nine global
chart opens.  This is the pairwise-overlap witness needed by the integral-open-cover argument. -/
theorem globalChartGenericPoint_mem_chart_range
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i j i' j' : Fin 3) :
    globalChartGenericPoint F hF hF0 i j ∈
      Set.range (chartZeroLocusToGlobal 2 2 k F hF i' j') := by
  rw [← Scheme.Hom.coe_opensRange, opensRange_chartZeroLocusToGlobal]
  change (biprojectiveZeroLocusι 2 2 k F).base
      (globalChartGenericPoint F hF hF0 i j) ∈
    ((standardChartAffineOpen 2 2 k i' j').1 : Set _)
  have hstd : ((standardChartAffineOpen 2 2 k i' j').1 : Set _) =
      Set.range (standardChartι 2 2 k i' j') := by
    simp [standardChartAffineOpen, Scheme.Hom.coe_opensRange]
  rw [hstd, range_standardChartι]
  refine ⟨?_, ?_⟩
  · change (biprojectiveZeroLocusFst 2 2 k F).base
        (globalChartGenericPoint F hF hF0 i j) ∈
      Set.range (ProjectiveSpace.standardChartι 2 k i')
    let η := affineChartGenericPoint F hF hF0 i j
    let ξ := (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv.base η
    have heq := congrArg
      (fun f :
        (chartIdealSheaf 2 2 k i j F).subscheme ⟶ ProjectiveSpace 2 k =>
          f.base ξ)
      (BiprojectiveSpace.chartZeroLocusIsoSpecAffineQuotient_hom_fst
        2 2 k F hF i j)
    have hproj :
        (biprojectiveZeroLocusFst 2 2 k F).base
          (globalChartGenericPoint F hF hF0 i j) =
        (ProjectiveSpace.standardChartι 2 k i).base
          ((Spec.map (CommRingCat.ofHom
            (BiprojectiveSpace.affineChartQuotientXHom 2 2 k i j F))).base η) := by
      simpa [globalChartGenericPoint, η, ξ, Scheme.Hom.comp_apply] using heq.symm
    rw [hproj]
    exact affineChartGenericPoint_fst_mem_standardChart_range F hF hF0 i j i'
  · change (biprojectiveZeroLocusSnd 2 2 k F).base
        (globalChartGenericPoint F hF hF0 i j) ∈
      Set.range (ProjectiveSpace.standardChartι 2 k j')
    let η := affineChartGenericPoint F hF hF0 i j
    let ξ := (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv.base η
    have heq := congrArg
      (fun f :
        (chartIdealSheaf 2 2 k i j F).subscheme ⟶ ProjectiveSpace 2 k =>
          f.base ξ)
      (BiprojectiveSpace.chartZeroLocusIsoSpecAffineQuotient_hom_snd
        2 2 k F hF i j)
    have hproj :
        (biprojectiveZeroLocusSnd 2 2 k F).base
          (globalChartGenericPoint F hF hF0 i j) =
        (ProjectiveSpace.standardChartι 2 k j).base
          ((Spec.map (CommRingCat.ofHom
            (BiprojectiveSpace.affineChartQuotientYHom 2 2 k i j F))).base η) := by
      simpa [globalChartGenericPoint, η, ξ, Scheme.Hom.comp_apply] using heq.symm
    rw [hproj]
    exact affineChartGenericPoint_snd_mem_standardChart_range F hF hF0 i j j'

/-- The nine standard affine zero-locus charts as an actual scheme open cover. -/
noncomputable def zeroLocusStandardOpenCover
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) :
    (biprojectiveZeroLocus 2 2 k F).OpenCover :=
  Scheme.Cover.mkOfCovers (Fin 3 × Fin 3)
    (fun ij => (chartIdealSheaf 2 2 k ij.1 ij.2 F).subscheme)
    (fun ij => chartZeroLocusToGlobal 2 2 k F hF ij.1 ij.2)
    (fun x => by
      have hx : (biprojectiveZeroLocusι 2 2 k F).base x ∈
          (⊤ : (BiprojectiveSpace 2 2 k).Opens) := trivial
      rw [← BiprojectiveSpace.iSup_standardChartAffineOpen 2 2 k] at hx
      simp only [TopologicalSpace.Opens.mem_iSup] at hx
      obtain ⟨ij, hij⟩ := hx
      have hxchart : x ∈
          (chartZeroLocusToGlobal 2 2 k F hF ij.1 ij.2).opensRange := by
        rw [opensRange_chartZeroLocusToGlobal]
        exact hij
      have hxrange : x ∈ Set.range
          (chartZeroLocusToGlobal 2 2 k F hF ij.1 ij.2).base := by
        rw [← Scheme.Hom.coe_opensRange]
        exact hxchart
      obtain ⟨y, hy⟩ := hxrange
      exact ⟨ij, y, hy⟩)

/-- Every chartwise zero locus in the standard nine-chart cover is integral. -/
theorem isIntegral_chartZeroLocus
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (i j : Fin 3) :
    IsIntegral ((chartIdealSheaf 2 2 k i j F).subscheme) := by
  letI : IsDomain
      (MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸
        Ideal.span {affineChartEquation 2 2 k i j F}) :=
    isDomain_affineChartQuotient F hF hF0 i j
  exact IsIntegral.of_isIso
    (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv

/-- A smooth bidegree `(2,3)` hypersurface in `ℙ² × ℙ²` is integral.  The proof is
flatness-free: the nine affine charts are domains, and their generic points give explicit
witnesses that every pair of chart opens meets. -/
theorem isIntegral_biprojectiveZeroLocus_of_smooth_bidegree23
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    IsIntegral (biprojectiveZeroLocus 2 2 k F) := by
  let U := zeroLocusStandardOpenCover F hF
  letI : Nonempty (biprojectiveZeroLocus 2 2 k F) :=
    ⟨globalChartGenericPoint F hF hF0 0 0⟩
  haveI hUi (ij : U.I₀) : IsIntegral (U.X ij) := by
    change IsIntegral ((chartIdealSheaf 2 2 k ij.1 ij.2 F).subscheme)
    exact isIntegral_chartZeroLocus F hF hF0 ij.1 ij.2
  apply isIntegral_of_openCover_of_pairwise_nonempty U
  intro a b _hab
  change Fin 3 × Fin 3 at a b
  intro hdis
  let x := globalChartGenericPoint F hF hF0 a.1 a.2
  have hxa : x ∈ (U.f a).opensRange := by
    have hrange := globalChartGenericPoint_mem_chart_range
      F hF hF0 a.1 a.2 a.1 a.2
    change x ∈ (chartZeroLocusToGlobal 2 2 k F hF a.1 a.2).opensRange
    exact (show x ∈ Set.range
      (chartZeroLocusToGlobal 2 2 k F hF a.1 a.2).base from hrange)
  have hxb : x ∈ (U.f b).opensRange := by
    have hrange := globalChartGenericPoint_mem_chart_range
      F hF hF0 a.1 a.2 b.1 b.2
    change x ∈ (chartZeroLocusToGlobal 2 2 k F hF b.1 b.2).opensRange
    exact (show x ∈ Set.range
      (chartZeroLocusToGlobal 2 2 k F hF b.1 b.2).base from hrange)
  have hxbot : x ∈
      (⊥ : (biprojectiveZeroLocus 2 2 k F).Opens) :=
    hdis.le_bot ⟨hxa, hxb⟩
  exact hxbot

/-! ## The global density boundary -/

/-- A nonempty product-chart open of a preirreducible global zero locus is dominant.  Thus the
global target-chart density step reduces exactly to preirreducibility of the smooth
biprojective hypersurface (or to a direct proof of the same density statement). -/
theorem isDominant_chartZeroLocusToGlobal_of_preirreducible
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (i j : Fin 3)
    [PreirreducibleSpace (biprojectiveZeroLocus 2 2 k F)]
    [Nonempty ((chartIdealSheaf 2 2 k i j F).subscheme)] :
    IsDominant (chartZeroLocusToGlobal 2 2 k F hF i j) := by
  refine ⟨?_⟩
  exact ((Scheme.Hom.isOpenEmbedding
    (chartZeroLocusToGlobal 2 2 k F hF i j)).isOpen_range).dense
      (Set.range_nonempty _)

/-- Every standard zero-locus chart is dominant in a smooth nonzero bidegree `(2,3)`
hypersurface.  This is the global target-chart density theorem needed by the direct
stereographic-open route. -/
theorem isDominant_chartZeroLocusToGlobal_of_smooth_bidegree23
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (i j : Fin 3) :
    IsDominant (chartZeroLocusToGlobal 2 2 k F hF i j) := by
  letI : IsIntegral (biprojectiveZeroLocus 2 2 k F) :=
    isIntegral_biprojectiveZeroLocus_of_smooth_bidegree23 F hF hF0
  letI : IsIntegral ((chartIdealSheaf 2 2 k i j F).subscheme) :=
    isIntegral_chartZeroLocus F hF hF0 i j
  exact isDominant_chartZeroLocusToGlobal_of_preirreducible F hF i j

end

end BConicBundleMultisections
