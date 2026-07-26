/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.IrreducibleProjectiveHypersurfaceIntegral
public import BConicBundleMultisections.ProperIntegralGlobalSections
public import Mathlib.RingTheory.MvPolynomial.IrreducibleQuadratic

/-!
# Negative twists on an irreducible projective plane hypersurface

This file isolates the algebraic core of the negative-twist argument on the integral projective
curve `V(H)`.  On a retained standard chart, the fraction field contains the normalized
coordinates `X_j / X_i`.  At least one of the two affine coordinates is not a scalar.  The proof
uses only homogeneous divisibility: if both were scalars, `H` would divide two nonassociated
linear forms.

The final field lemma says that a rational element whose multiples by `X_i^2` and `X_i X_j`
are scalar must vanish whenever `X_j / X_i` is not scalar.  Later sheaf code only has to show
that those two quadratic multiples extend to global regular functions; properness then turns
the global functions into scalars.
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

/-! ## Linear forms detected by normalized coordinates -/

/-- A linear form with coefficient one on `X_j` is irreducible. -/
theorem irreducible_X_sub_C_mul_X
    (i j : Fin 3) (hji : j ≠ i) (c : k) :
    Irreducible
      (MvPolynomial.X j - MvPolynomial.C c * MvPolynomial.X i :
        MvPolynomial (Fin 3) k) := by
  let D := MvPolynomial.X j - MvPolynomial.C c * MvPolynomial.X i
  have hDhom : D.IsHomogeneous 1 := by
    exact (MvPolynomial.isHomogeneous_X k j).sub
      (MvPolynomial.isHomogeneous_C_mul_X c i)
  have hD0 : D ≠ 0 := by
    intro hzero
    have hcoeff := congrArg (MvPolynomial.coeff (Finsupp.single j 1)) hzero
    simp [D, Ne.symm hji] at hcoeff
  apply MvPolynomial.irreducible_of_totalDegree_eq_one (hDhom.totalDegree hD0)
  intro x hx
  have hxone : x ∣ (1 : k) := by
    simpa [D, Ne.symm hji] using hx (Finsupp.single j 1)
  exact isUnit_iff_dvd_one.mpr hxone

/-- Linear forms with coefficient one on two different non-chart variables are not associated. -/
theorem not_associated_X_sub_C_mul_X
    (i j l : Fin 3) (_hji : j ≠ i) (hli : l ≠ i) (hjl : j ≠ l)
    (c e : k) :
    ¬ Associated
      (MvPolynomial.X j - MvPolynomial.C c * MvPolynomial.X i :
        MvPolynomial (Fin 3) k)
      (MvPolynomial.X l - MvPolynomial.C e * MvPolynomial.X i) := by
  intro hassoc
  obtain ⟨v, hv⟩ := hassoc
  have heval := congrArg
    (MvPolynomial.eval fun r : Fin 3 ↦ if r = l then (1 : k) else 0) hv
  simp [hjl, Ne.symm hli] at heval

/-- Explicit quotient-ring formula for a normalized coordinate in the chosen chart function
field. -/
theorem hypersurfaceNormalizedCoordinateInFunctionField_eq_algebraMap
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) (j : Fin 3) :
    hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j =
      algebraMap (HypersurfaceChartQuotient H i.1)
        (HypersurfaceFunctionField H i)
        (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
          (chartDehomogenization 2 k i.1 (MvPolynomial.X j))) := by
  letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  unfold hypersurfaceNormalizedCoordinateInFunctionField
  unfold hypersurfaceStandardChartToFunctionField
  unfold hypersurfaceChartQuotientToFunctionField
  simp only [RingHom.comp_apply]
  unfold hypersurfaceAffineChartQuotientMap
  change algebraMap (HypersurfaceChartQuotient H i.1)
      (HypersurfaceFunctionField H i)
      (Ideal.Quotient.mk _
        (standardChartRingEquivMvPolynomial 2 k i.1
          (normalizedCoordinate 2 k i.1 j))) = _
  rw [standardChartRingEquivMvPolynomial_normalizedCoordinate_eq_chartDehomogenization_X]

/-- The normalized coordinate of the chosen chart variable is one. -/
@[simp]
theorem hypersurfaceNormalizedCoordinateInFunctionField_self
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i i.1 = 1 := by
  unfold hypersurfaceNormalizedCoordinateInFunctionField
  rw [normalizedCoordinate_self, map_one]

/-- The base field maps to the chart presentation of the hypersurface function field.  This is
named explicitly because the domain instance for the chart quotient depends on the hypotheses
that `H` is irreducible and that the chart is retained. -/
def hypersurfaceBaseToFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (_hH : H.IsHomogeneous d) (_hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    k →+* HypersurfaceFunctionField H i := by
  letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H _hH _hHirr i.2
  exact algebraMap k (HypersurfaceFunctionField H i)

/-- Evaluate a homogeneous-coordinate polynomial in the function field by sending `X_l` to the
normalized coordinate `X_l / X_i`. -/
def hypersurfaceHomogeneousPolynomialToFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    MvPolynomial (Fin 3) k →+* HypersurfaceFunctionField H i :=
  MvPolynomial.eval₂Hom (hypersurfaceBaseToFunctionField H hH hHirr i)
    (hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i)

@[simp]
theorem hypersurfaceHomogeneousPolynomialToFunctionField_X
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) (j : Fin 3) :
    hypersurfaceHomogeneousPolynomialToFunctionField H hH hHirr i
        (MvPolynomial.X j) =
      hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j := by
  simp [hypersurfaceHomogeneousPolynomialToFunctionField]

@[simp]
theorem hypersurfaceHomogeneousPolynomialToFunctionField_X_self_sq
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    hypersurfaceHomogeneousPolynomialToFunctionField H hH hHirr i
        (MvPolynomial.X i.1 ^ 2) = 1 := by
  simp

@[simp]
theorem hypersurfaceHomogeneousPolynomialToFunctionField_X_self_mul_X
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) (j : Fin 3) :
    hypersurfaceHomogeneousPolynomialToFunctionField H hH hHirr i
        (MvPolynomial.X i.1 * MvPolynomial.X j) =
      hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j := by
  simp

/-- Evaluation of a homogeneous-coordinate polynomial in a retained chart function field is
the fraction-field image of its ordinary chart dehomogenization modulo the hypersurface
equation.  Homogeneity is not needed for this chartwise identity. -/
theorem hypersurfaceHomogeneousPolynomialToFunctionField_eq_algebraMap_chartDehomogenization
    (H P : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    hypersurfaceHomogeneousPolynomialToFunctionField H hH hHirr i P =
      hypersurfaceChartQuotientToFunctionField H hH hHirr i
        (Ideal.Quotient.mk
          (Ideal.span {chartDehomogenization 2 k i.1 H})
          (chartDehomogenization 2 k i.1 P)) := by
  let A := HypersurfaceChartQuotient H i.1
  let K := HypersurfaceFunctionField H i
  letI : IsDomain A :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  let f := hypersurfaceHomogeneousPolynomialToFunctionField H hH hHirr i
  let g : MvPolynomial (Fin 3) k →+* K :=
    (hypersurfaceChartQuotientToFunctionField H hH hHirr i).comp
      ((Ideal.Quotient.mk
        (Ideal.span {chartDehomogenization 2 k i.1 H})).comp
          (chartDehomogenization 2 k i.1).toRingHom)
  change f P = g P
  have hfg : f = g := by
    apply MvPolynomial.ringHom_ext
    · intro c
      dsimp only [f, g]
      simp [hypersurfaceHomogeneousPolynomialToFunctionField,
        hypersurfaceBaseToFunctionField,
        hypersurfaceChartQuotientToFunctionField]
      rw [show Ideal.Quotient.mk
          (Ideal.span {chartDehomogenization 2 k i.1 H})
          (MvPolynomial.C c) = algebraMap k A c by
        simpa only [MvPolynomial.C_eq_algebraMap] using
          (Ideal.Quotient.mk_algebraMap k
            (Ideal.span {chartDehomogenization 2 k i.1 H}) c)]
      exact IsScalarTower.algebraMap_apply k A K c
    · intro j
      dsimp only [f, g]
      rw [hypersurfaceHomogeneousPolynomialToFunctionField_X]
      rw [hypersurfaceNormalizedCoordinateInFunctionField_eq_algebraMap]
      rfl
  exact DFunLike.congr_fun hfg P

/-- If a normalized coordinate is a base-field scalar in the chart fraction field, the
corresponding homogeneous linear form is divisible by the hypersurface equation. -/
theorem dvd_X_sub_C_mul_X_of_normalizedCoordinate_eq_algebraMap
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) (j : Fin 3) (c : k)
    (hscalar :
      hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j =
        hypersurfaceBaseToFunctionField H hH hHirr i c) :
    H ∣ (MvPolynomial.X j - MvPolynomial.C c * MvPolynomial.X i.1 :
      MvPolynomial (Fin 3) k) := by
  let A := HypersurfaceChartQuotient H i.1
  let K := HypersurfaceFunctionField H i
  let D : MvPolynomial (Fin 3) k :=
    MvPolynomial.X j - MvPolynomial.C c * MvPolynomial.X i.1
  letI : IsDomain A :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  have hDhom : D.IsHomogeneous 1 := by
    exact (MvPolynomial.isHomogeneous_X k j).sub
      (MvPolynomial.isHomogeneous_C_mul_X c i.1)
  by_contra hnot
  have hnonzero :
      Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
          (chartDehomogenization 2 k i.1 D) ≠ 0 :=
    quotient_mk_chartDehomogenization_ne_zero_of_not_dvd
      i.1 H D hH hHirr hDhom i.2 hnot
  apply hnonzero
  apply IsFractionRing.injective A K
  rw [map_zero]
  have hbase :
      algebraMap A K
          (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
            (MvPolynomial.C c)) =
        hypersurfaceBaseToFunctionField H hH hHirr i c := by
    change algebraMap A K (algebraMap k A c) = algebraMap k K c
    exact IsScalarTower.algebraMap_apply k A K c
  have hC : chartDehomogenization 2 k i.1 (MvPolynomial.C c) =
      MvPolynomial.C c := by
    simpa only [MvPolynomial.C_eq_algebraMap] using
      (chartDehomogenization 2 k i.1).commutes c
  calc
    algebraMap A K
        (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
          (chartDehomogenization 2 k i.1 D)) =
          hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j -
          hypersurfaceBaseToFunctionField H hH hHirr i c := by
      rw [show chartDehomogenization 2 k i.1 D =
          chartDehomogenization 2 k i.1 (MvPolynomial.X j) -
            MvPolynomial.C c by
        dsimp only [D]
        rw [map_sub, map_mul, hC,
          chartDehomogenization_X_self, mul_one]]
      simp only [map_sub]
      rw [hypersurfaceNormalizedCoordinateInFunctionField_eq_algebraMap
        H hH hHirr i j, hbase]
    _ = 0 := sub_eq_zero.mpr hscalar

/-! ## A non-scalar affine coordinate -/

/-- On a retained standard chart of an irreducible positive-degree plane hypersurface, at least
one of the other two normalized coordinates is not a base-field scalar.

Indeed, scalarity of `X_j / X_i` makes `H` divide `X_j - c X_i`.  If both other
coordinates were scalar, irreducibility would make those two visibly nonassociated linear forms
associated to one another. -/
theorem exists_normalizedCoordinate_not_baseScalar
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (_hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    ∃ j : Fin 3, j ≠ i.1 ∧
      ¬ ∃ c : k,
        hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j =
          hypersurfaceBaseToFunctionField H hH hHirr i c := by
  let j : Fin 3 := i.1.succAbove (0 : Fin 2)
  let l : Fin 3 := i.1.succAbove (1 : Fin 2)
  have hji : j ≠ i.1 := Fin.succAbove_ne i.1 0
  have hli : l ≠ i.1 := Fin.succAbove_ne i.1 1
  have hjl : j ≠ l := by
    intro heq
    have : (0 : Fin 2) = 1 := Fin.succAbove_right_injective heq
    omega
  by_cases hjscalar : ∃ c : k,
      hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j =
        hypersurfaceBaseToFunctionField H hH hHirr i c
  · by_cases hlscalar : ∃ e : k,
        hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i l =
          hypersurfaceBaseToFunctionField H hH hHirr i e
    · obtain ⟨c, hc⟩ := hjscalar
      obtain ⟨e, he⟩ := hlscalar
      have hdivj : H ∣
          (MvPolynomial.X j - MvPolynomial.C c * MvPolynomial.X i.1 :
            MvPolynomial (Fin 3) k) :=
        dvd_X_sub_C_mul_X_of_normalizedCoordinate_eq_algebraMap
          H hH hHirr i j c hc
      have hdivl : H ∣
          (MvPolynomial.X l - MvPolynomial.C e * MvPolynomial.X i.1 :
            MvPolynomial (Fin 3) k) :=
        dvd_X_sub_C_mul_X_of_normalizedCoordinate_eq_algebraMap
          H hH hHirr i l e he
      have hassocj : Associated H
          (MvPolynomial.X j - MvPolynomial.C c * MvPolynomial.X i.1 :
            MvPolynomial (Fin 3) k) :=
        hHirr.associated_of_dvd
          (irreducible_X_sub_C_mul_X i.1 j hji c) hdivj
      have hassocl : Associated H
          (MvPolynomial.X l - MvPolynomial.C e * MvPolynomial.X i.1 :
            MvPolynomial (Fin 3) k) :=
        hHirr.associated_of_dvd
          (irreducible_X_sub_C_mul_X i.1 l hli e) hdivl
      exact False.elim
        (not_associated_X_sub_C_mul_X i.1 j l hji hli hjl c e
          (hassocj.symm.trans hassocl))
    · exact ⟨l, hli, hlscalar⟩
  · exact ⟨j, hji, hjscalar⟩

/-! ## The field-level negative-twist contradiction -/

/-- A chart-function-field element is a scalar if it lies in the image of the named base map. -/
def IsHypersurfaceBaseScalar
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (z : HypersurfaceFunctionField H i) : Prop :=
  ∃ c : k, z = hypersurfaceBaseToFunctionField H hH hHirr i c

/-- If `s` is scalar and `z * s` is scalar while `z` is not, then `s = 0`.

This is the exact field-theoretic last step of the negative-twist argument. -/
theorem eq_zero_of_isHypersurfaceBaseScalar_of_mul
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (z s : HypersurfaceFunctionField H i)
    (hz : ¬ IsHypersurfaceBaseScalar H hH hHirr i z)
    (hs : IsHypersurfaceBaseScalar H hH hHirr i s)
    (hzs : IsHypersurfaceBaseScalar H hH hHirr i (z * s)) :
    s = 0 := by
  let A := HypersurfaceChartQuotient H i.1
  let K := HypersurfaceFunctionField H i
  letI : IsDomain A :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  obtain ⟨a, ha⟩ := hs
  obtain ⟨b, hb⟩ := hzs
  by_contra hs0
  have hφa0 : hypersurfaceBaseToFunctionField H hH hHirr i a ≠ 0 := by
    rwa [← ha]
  have ha0 : a ≠ 0 := by
    intro ha0
    apply hφa0
    simp [ha0]
  apply hz
  refine ⟨b * a⁻¹, ?_⟩
  apply mul_right_cancel₀ hφa0
  calc
    z * hypersurfaceBaseToFunctionField H hH hHirr i a = z * s := by rw [ha]
    _ = hypersurfaceBaseToFunctionField H hH hHirr i b := hb
    _ = hypersurfaceBaseToFunctionField H hH hHirr i (b * a⁻¹) *
        hypersurfaceBaseToFunctionField H hH hHirr i a := by
      simp [map_mul, ha0]

/-- Projective-specific form: scalarity of the `X_i²` and `X_i X_j` multiples forces the
underlying rational element to vanish, once `X_j / X_i` is known to be nonscalar.  On chart `i`,
these two multiples are represented respectively by `s` and `(X_j / X_i) * s`. -/
theorem hypersurfaceFunctionField_eq_zero_of_quadraticMultiples_scalar
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) (j : Fin 3)
    (hj : ¬ IsHypersurfaceBaseScalar H hH hHirr i
      (hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j))
    (s : HypersurfaceFunctionField H i)
    (hXiSq : IsHypersurfaceBaseScalar H hH hHirr i s)
    (hXiXj : IsHypersurfaceBaseScalar H hH hHirr i
      (hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j * s)) :
    s = 0 :=
  eq_zero_of_isHypersurfaceBaseScalar_of_mul H hH hHirr i
    (hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j) s
    hj hXiSq hXiXj

/-- Uniform form of the algebraic core.  It is enough that the chart-square multiple `s` and
every mixed multiple `(X_j / X_i) * s` are scalar.  The theorem chooses a nonscalar normalized
coordinate automatically. -/
theorem hypersurfaceFunctionField_eq_zero_of_all_quadraticMultiples_scalar
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (s : HypersurfaceFunctionField H i)
    (hXiSq : IsHypersurfaceBaseScalar H hH hHirr i s)
    (hmixed : ∀ j : Fin 3, j ≠ i.1 →
      IsHypersurfaceBaseScalar H hH hHirr i
        (hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j * s)) :
    s = 0 := by
  obtain ⟨j, hji, hj⟩ :=
    exists_normalizedCoordinate_not_baseScalar H hH hd hHirr i
  change ¬ IsHypersurfaceBaseScalar H hH hHirr i
    (hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j) at hj
  exact hypersurfaceFunctionField_eq_zero_of_quadraticMultiples_scalar
    H hH hHirr i j hj s hXiSq (hmixed j hji)

/-! ## Proper global sections and the exact gluing/comparison interface -/

/-- The structural morphism of the projective hypersurface. -/
def projectiveZeroLocusToSpec
    (H : MvPolynomial (Fin 3) k) :
    projectiveZeroLocus 2 k H ⟶ Spec (.of k) :=
  projectiveZeroLocusι 2 k H ≫ ProjectiveSpace.toSpec 2 k

/-- A projective hypersurface is proper over the base. -/
instance (H : MvPolynomial (Fin 3) k) :
    IsProper (projectiveZeroLocusToSpec H) := by
  unfold projectiveZeroLocusToSpec
  infer_instance

/-- Every global function on an irreducible positive-degree projective plane hypersurface over
an algebraically closed field comes from the base field. -/
theorem exists_scalar_eq_projectiveZeroLocus_globalSection
    [IsAlgClosed k]
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (t : Γ(projectiveZeroLocus 2 k H, ⊤)) :
    ∃ c : k, globalSectionsMapFromBase k (projectiveZeroLocusToSpec H) c = t := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  exact exists_scalar_eq_globalSection_of_isIntegral_of_universallyClosed
    k (projectiveZeroLocusToSpec H) t

/-- The minimal comparison datum between global sections of the projective model and the
explicit chart presentation of its function field.

The intended `toFunctionField` is restriction to the generic point followed by the canonical
identification with the fraction field of the chosen affine chart.  The scalar compatibility is
spelled out because it is exactly what the proper-global-functions argument consumes. -/
structure GlobalSectionsToHypersurfaceFunctionFieldComparison
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) where
  toFunctionField :
    Γ(projectiveZeroLocus 2 k H, ⊤) →+* HypersurfaceFunctionField H i
  map_base (c : k) :
    toFunctionField (globalSectionsMapFromBase k (projectiveZeroLocusToSpec H) c) =
      hypersurfaceBaseToFunctionField H hH hHirr i c

/-- Every homogeneous quadratic multiple of `s` extends to a global regular function on the
projective hypersurface.  This is the invariant negative-twist regularity condition: a local
section of `O(-2)` becomes a global function after multiplication by any quadratic form. -/
def HomogeneousQuadraticMultiplesExtendToGlobal
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (comparison :
      GlobalSectionsToHypersurfaceFunctionFieldComparison H hH hHirr i)
    (s : HypersurfaceFunctionField H i) : Prop :=
  ∀ P : MvPolynomial (Fin 3) k, P.IsHomogeneous 2 →
    ∃ t : Γ(projectiveZeroLocus 2 k H, ⊤),
      comparison.toFunctionField t =
        hypersurfaceHomogeneousPolynomialToFunctionField H hH hHirr i P * s

/-- The two kinds of quadratic multiples needed by the negative-twist argument extend to global
regular functions.  The chart-square `X_i² s` is `s` in normalized coordinates; the mixed
quadratic `X_i X_j s` is `(X_j / X_i) s`.

This predicate is the precise projective-specific boundary left to local quotient compatibility
and sheaf gluing.  It makes no assertion that an ambient Cox polynomial vanishes: the conclusion
below is only vanishing in the function field of `V(H)`, equivalently modulo `H` on the curve. -/
def QuadraticMultiplesExtendToGlobal
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (comparison :
      GlobalSectionsToHypersurfaceFunctionFieldComparison H hH hHirr i)
    (s : HypersurfaceFunctionField H i) : Prop :=
  (∃ t : Γ(projectiveZeroLocus 2 k H, ⊤),
      comparison.toFunctionField t = s) ∧
    ∀ j : Fin 3, j ≠ i.1 →
      ∃ t : Γ(projectiveZeroLocus 2 k H, ⊤),
        comparison.toFunctionField t =
          hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i j * s

/-- Faithful negative-twist endpoint on the irreducible projective curve.

Once the explicit comparison and the global extension of the quadratic multiples are supplied,
properness makes all those global functions scalar.  A nonscalar normalized coordinate then
forces `s = 0` in the curve's function field. -/
theorem hypersurfaceFunctionField_eq_zero_of_quadraticMultiples_extendToGlobal
    [IsAlgClosed k]
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (comparison :
      GlobalSectionsToHypersurfaceFunctionFieldComparison H hH hHirr i)
    (s : HypersurfaceFunctionField H i)
    (hext : QuadraticMultiplesExtendToGlobal H hH hHirr i comparison s) :
    s = 0 := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  apply hypersurfaceFunctionField_eq_zero_of_all_quadraticMultiples_scalar
    H hH hd hHirr i s
  · obtain ⟨t, ht⟩ := hext.1
    obtain ⟨c, hc⟩ :=
      exists_scalar_eq_projectiveZeroLocus_globalSection H hH hd hHirr t
    refine ⟨c, ?_⟩
    rw [← ht, ← hc]
    exact comparison.map_base c
  · intro j hji
    obtain ⟨t, ht⟩ := hext.2 j hji
    obtain ⟨c, hc⟩ :=
      exists_scalar_eq_projectiveZeroLocus_globalSection H hH hd hHirr t
    refine ⟨c, ?_⟩
    rw [← ht, ← hc]
    exact comparison.map_base c

/-- Invariant negative-twist vanishing theorem.  If all homogeneous quadratic multiples of `s`
extend globally, then `s` vanishes in the function field of the projective curve. -/
theorem hypersurfaceFunctionField_eq_zero_of_homogeneousQuadraticMultiples_extendToGlobal
    [IsAlgClosed k]
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (comparison :
      GlobalSectionsToHypersurfaceFunctionFieldComparison H hH hHirr i)
    (s : HypersurfaceFunctionField H i)
    (hext :
      HomogeneousQuadraticMultiplesExtendToGlobal H hH hHirr i comparison s) :
    s = 0 := by
  apply hypersurfaceFunctionField_eq_zero_of_quadraticMultiples_extendToGlobal
    H hH hd hHirr i comparison s
  constructor
  · have hhom : (MvPolynomial.X i.1 ^ 2 : MvPolynomial (Fin 3) k).IsHomogeneous 2 := by
      simpa using (MvPolynomial.isHomogeneous_X k i.1).pow 2
    obtain ⟨t, ht⟩ := hext (MvPolynomial.X i.1 ^ 2) hhom
    refine ⟨t, ?_⟩
    simpa using ht
  · intro j _hji
    have hhom : (MvPolynomial.X i.1 * MvPolynomial.X j :
        MvPolynomial (Fin 3) k).IsHomogeneous 2 := by
      simpa using
        (MvPolynomial.isHomogeneous_X k i.1).mul
          (MvPolynomial.isHomogeneous_X k j)
    obtain ⟨t, ht⟩ := hext (MvPolynomial.X i.1 * MvPolynomial.X j) hhom
    refine ⟨t, ?_⟩
    simpa using ht

end ProjectiveSpace

end

end BConicBundleMultisections

end
