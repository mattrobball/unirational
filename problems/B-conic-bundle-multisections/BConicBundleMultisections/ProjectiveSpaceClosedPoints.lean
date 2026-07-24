/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineChart
public import BConicBundleMultisections.BiprojectiveFiberEquationBaseChange
public import BConicBundleMultisections.BiprojectiveSpaceProperties
public import Mathlib.AlgebraicGeometry.AlgClosed.Basic

/-!
# Closed points of projective space over an algebraically closed field

Over an algebraically closed field, closed points of `ℙⁿ` are identified with normalized
coordinate tuples via the standard affine charts.  This file builds the corresponding
`k`-points and recovers every closed point from its residue-field coordinates.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra

namespace ProjectiveSpace

/-- Affine coordinates of a normalized homogeneous representative on the `i`-th standard chart. -/
def affineCoordinates {n : ℕ} {R : Type u}
    (i : Fin (n + 1)) (x : Fin (n + 1) → R) : Fin n → R :=
  fun r ↦ x (i.succAbove r)

/-- Evaluation of the standard chart ring at a normalized homogeneous representative. -/
def standardChartEval
    (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) (x : Fin (n + 1) → R) :
    StandardChartRing n R i →+* R :=
  (eval (affineCoordinates i x)).comp
    (standardChartRingEquivMvPolynomial n R i).toRingHom

@[simp]
theorem standardChartEval_normalizedCoordinate_succAbove
    (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) (x : Fin (n + 1) → R) (r : Fin n) :
    standardChartEval n R i x (normalizedCoordinate n R i (i.succAbove r)) =
      x (i.succAbove r) := by
  simp [standardChartEval, affineCoordinates]

/-- The chart evaluation map is a section of the structure map `R → StandardChartRing`. -/
theorem standardChartEval_comp_standardChartRingHom
    (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) (x : Fin (n + 1) → R) :
    (standardChartEval n R i x).comp (standardChartRingHom n R i) = RingHom.id R := by
  ext r
  change standardChartEval n R i x (algebraMap R (StandardChartRing n R i) r) = r
  simp [standardChartEval, AlgEquiv.commutes]

private theorem standardChartEval_mvPolynomialToStandardChart
    (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) (x : Fin (n + 1) → R)
    (p : MvPolynomial (Fin n) R) :
    standardChartEval n R i x (mvPolynomialToStandardChart n R i p) =
      eval (affineCoordinates i x) p := by
  simp only [standardChartEval, RingHom.comp_apply]
  change eval (affineCoordinates i x)
      (standardChartRingEquivMvPolynomial n R i
        (mvPolynomialToStandardChart n R i p)) =
    eval (affineCoordinates i x) p
  have h :
      standardChartRingEquivMvPolynomial n R i
          (mvPolynomialToStandardChart n R i p) = p :=
    DFunLike.congr_fun
      (standardChartToMvPolynomial_comp_mvPolynomialToStandardChart n R i) p
  rw [h]

/-- The `R`-point of projective space associated with a normalized homogeneous representative. -/
def pointOfNormalizedCoordinates
    (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) (x : Fin (n + 1) → R) (_hxi : x i = 1) :
    Spec (.of R) ⟶ ProjectiveSpace n R :=
  Spec.map (CommRingCat.ofHom (standardChartEval n R i x)) ≫ standardChartι n R i

@[reassoc (attr := simp)]
theorem pointOfNormalizedCoordinates_toSpec
    (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) (x : Fin (n + 1) → R) (hxi : x i = 1) :
    pointOfNormalizedCoordinates n R i x hxi ≫ toSpec n R = 𝟙 _ := by
  unfold pointOfNormalizedCoordinates
  rw [Category.assoc, standardChartι_toSpec, ← Spec.map_comp, ← Spec.map_id]
  congr 1
  ext r
  exact DFunLike.congr_fun (standardChartEval_comp_standardChartRingHom n R i x) r

/-- Every point of projective space lies in some standard chart. -/
theorem exists_mem_standardChart
    (n : ℕ) (R : Type u) [CommRing R] (x : ProjectiveSpace n R) :
    ∃ i : Fin (n + 1), x ∈ standardChart n R i := by
  have htop :
      (⨆ i : Fin (n + 1), (standardChartι n R i).opensRange) = ⊤ :=
    (standardAffineOpenCover n R).openCover.iSup_opensRange
  have hx : x ∈ (⊤ : (ProjectiveSpace n R).Opens) := trivial
  rw [← htop] at hx
  obtain ⟨i, hi⟩ := TopologicalSpace.Opens.mem_iSup.mp hx
  refine ⟨i, ?_⟩
  rwa [opensRange_standardChartι] at hi

/-- Underlying ring homomorphism of the residue-field isomorphism with the base field. -/
def residueFieldIsoBaseHom
    (n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    (x : ProjectiveSpace n K) (hx : IsClosed {x}) :
    (ProjectiveSpace n K).residueField x →+* K :=
  (residueFieldIsoBase (toSpec n K) x hx).hom.hom

/-- Normalized `K`-coordinates of a closed point in a standard chart, transported along the
residue-field isomorphism with the algebraically closed base. -/
def closedPointNormalizedCoordinates
    (n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    (x : ProjectiveSpace n K) (hx : IsClosed {x})
    (i : Fin (n + 1)) (hxi : x ∈ standardChart n K i) :
    Fin (n + 1) → K :=
  fun l ↦ residueFieldIsoBaseHom n K x hx
    (normalizedResidueCoordinates n K x i hxi l)

@[simp]
theorem closedPointNormalizedCoordinates_self
    (n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    (x : ProjectiveSpace n K) (hx : IsClosed {x})
    (i : Fin (n + 1)) (hxi : x ∈ standardChart n K i) :
    closedPointNormalizedCoordinates n K x hx i hxi i = 1 := by
  simp [closedPointNormalizedCoordinates, residueFieldIsoBaseHom]

/-- Residue-field chart evaluation transported to the base field. -/
def closedPointChartEval
    (n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    (x : ProjectiveSpace n K) (hx : IsClosed {x})
    (i : Fin (n + 1)) (hxi : x ∈ standardChart n K i) :
    StandardChartRing n K i →+* K :=
  (residueFieldIsoBaseHom n K x hx).comp
    (standardChartResidueRingHom n K x i hxi)

/-- The residue-field isomorphism inverts the coefficient map from the base field. -/
theorem residueFieldIsoBaseHom_comp_residueCoefficientMap
    (n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    (x : ProjectiveSpace n K) (hx : IsClosed {x}) :
    (residueFieldIsoBaseHom n K x hx).comp (residueCoefficientMap n K x) =
      RingHom.id K := by
  -- `iso.inv = Spec.preimage (fromSpecResidueField ≫ toSpec)`
  have hinv :
      (residueFieldIsoBase (toSpec n K) x hx).inv =
        Spec.preimage
          ((ProjectiveSpace n K).fromSpecResidueField x ≫ toSpec n K) := by
    apply Spec.map_injective
    rw [SpecMap_residueFieldIsoBase_inv, Spec.map_preimage]
  have hinv_hom :
      (residueFieldIsoBase (toSpec n K) x hx).inv.hom =
        residueCoefficientMap n K x := by
    rw [hinv]
    rfl
  -- `inv ≫ hom = 𝟙` on `.of K`.
  ext b
  have hid :
      ((residueFieldIsoBase (toSpec n K) x hx).inv ≫
          (residueFieldIsoBase (toSpec n K) x hx).hom).hom b =
        b := by
    rw [Iso.inv_hom_id]
    rfl
  -- Expand the composite and substitute `inv.hom = residueCoefficientMap`.
  change residueFieldIsoBaseHom n K x hx (residueCoefficientMap n K x b) = b
  have hcomp :
      ((residueFieldIsoBase (toSpec n K) x hx).inv ≫
          (residueFieldIsoBase (toSpec n K) x hx).hom).hom b =
        (residueFieldIsoBase (toSpec n K) x hx).hom.hom
          ((residueFieldIsoBase (toSpec n K) x hx).inv.hom b) :=
    rfl
  rw [hcomp, hinv_hom] at hid
  exact hid

private theorem closedPointChartEval_mvPolynomialToStandardChart
    (n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    (x : ProjectiveSpace n K) (hx : IsClosed {x})
    (i : Fin (n + 1)) (hxi : x ∈ standardChart n K i)
    (p : MvPolynomial (Fin n) K) :
    closedPointChartEval n K x hx i hxi (mvPolynomialToStandardChart n K i p) =
      eval (affineCoordinates i
        (closedPointNormalizedCoordinates n K x hx i hxi)) p := by
  induction p using MvPolynomial.induction_on with
  | C a =>
      have hC :
          mvPolynomialToStandardChart n K i (C a) =
            algebraMap K (StandardChartRing n K i) a := by
        simp [mvPolynomialToStandardChart]
      rw [hC, eval_C]
      dsimp only [closedPointChartEval, RingHom.comp_apply]
      have hcomp :=
        DFunLike.congr_fun
          (standardChartResidueRingHom_comp_standardChartRingHom n K x i hxi) a
      -- hcomp : resHom (algebraMap a) = residueCoefficientMap a
      rw [show standardChartResidueRingHom n K x i hxi
            (algebraMap K (StandardChartRing n K i) a) =
          residueCoefficientMap n K x a from hcomp]
      exact DFunLike.congr_fun
        (residueFieldIsoBaseHom_comp_residueCoefficientMap n K x hx) a
  | add p q hp hq =>
      simp [map_add, hp, hq]
  | mul_X p r hp =>
      -- Chart evaluation of `p * X r` factors as a product of chart generators.
      have hmul :
          mvPolynomialToStandardChart n K i (p * X r) =
            mvPolynomialToStandardChart n K i p *
              normalizedCoordinate n K i (i.succAbove r) := by
        simp [mvPolynomialToStandardChart]
      rw [hmul, map_mul, eval_mul, eval_X, hp]
      -- Remaining factor is evaluation of a chart generator.
      simp [closedPointChartEval, closedPointNormalizedCoordinates,
        residueFieldIsoBaseHom, normalizedResidueCoordinates, affineCoordinates]

/-- Chart evaluation at closed-point coordinates agrees with residue-field evaluation. -/
theorem standardChartEval_closedPointNormalizedCoordinates
    (n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    (x : ProjectiveSpace n K) (hx : IsClosed {x})
    (i : Fin (n + 1)) (hxi : x ∈ standardChart n K i) :
    standardChartEval n K i (closedPointNormalizedCoordinates n K x hx i hxi) =
      closedPointChartEval n K x hx i hxi := by
  ext z
  have hz : z = mvPolynomialToStandardChart n K i
      (standardChartToMvPolynomial n K i z) :=
    (mvPolynomialToStandardChart_standardChartToMvPolynomial n K i z).symm
  rw [hz, standardChartEval_mvPolynomialToStandardChart]
  exact
    (closedPointChartEval_mvPolynomialToStandardChart n K x hx i hxi
      (standardChartToMvPolynomial n K i z)).symm

/-- Reconstructing a closed point from its normalized chart coordinates recovers the
canonical `k`-point of that closed point. -/
theorem pointOfNormalizedCoordinates_closedPointNormalizedCoordinates
    (n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    (x : ProjectiveSpace n K) (hx : IsClosed {x})
    (i : Fin (n + 1)) (hxi : x ∈ standardChart n K i) :
    pointOfNormalizedCoordinates n K i
        (closedPointNormalizedCoordinates n K x hx i hxi)
        (closedPointNormalizedCoordinates_self n K x hx i hxi) =
      pointOfClosedPoint (toSpec n K) x hx := by
  unfold pointOfNormalizedCoordinates pointOfClosedPoint
  rw [standardChartEval_closedPointNormalizedCoordinates]
  -- Rewrite `fromSpecResidueField` through the chart lift.
  have hfrom :
      (ProjectiveSpace n K).fromSpecResidueField x =
        standardChartResidueLift n K x i hxi ≫ standardChartι n K i :=
    (standardChartResidueLift_standardChartι n K x i hxi).symm
  rw [hfrom, ← Category.assoc]
  -- Identify the chart lift with Spec of its preimage ring map.
  have hlift :
      standardChartResidueLift n K x i hxi =
        Spec.map (Spec.preimage (standardChartResidueLift n K x i hxi)) :=
    (Spec.map_preimage _).symm
  rw [hlift, ← Spec.map_comp]
  -- Identify `closedPointChartEval` with `iso.hom ≫ preimage lift`.
  have hψ :
      CommRingCat.ofHom (closedPointChartEval n K x hx i hxi) =
        Spec.preimage (standardChartResidueLift n K x i hxi) ≫
          (residueFieldIsoBase (toSpec n K) x hx).hom := by
    ext z
    rfl
  rw [hψ]

/-- Every closed point of projective space over an algebraically closed field is the image of
the unique point of `Spec K` under the `k`-point built from its normalized coordinates. -/
theorem closedPoint_eq_pointOfNormalizedCoordinates_apply
    (n : ℕ) (K : Type u) [Field K] [IsAlgClosed K]
    (x : ProjectiveSpace n K) (hx : IsClosed {x})
    (i : Fin (n + 1)) (hxi : x ∈ standardChart n K i) :
    pointOfNormalizedCoordinates n K i
        (closedPointNormalizedCoordinates n K x hx i hxi)
        (closedPointNormalizedCoordinates_self n K x hx i hxi)
        (IsLocalRing.closedPoint K) = x := by
  rw [pointOfNormalizedCoordinates_closedPointNormalizedCoordinates]
  simp

end ProjectiveSpace

end

end BConicBundleMultisections
