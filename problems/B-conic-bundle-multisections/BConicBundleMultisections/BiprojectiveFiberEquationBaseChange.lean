/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveFiberPolynomial
public import BConicBundleMultisections.BiprojectiveProjectionFiber

/-!
# Equations on affine charts of biprojective fibers

This file supplies the algebraic base-change comparison needed to identify the equation on a
fiber of a biprojective hypersurface.  A scheme point of projective space does not carry a
canonical tuple of homogeneous coordinates.  After choosing a standard chart containing the
point, however, its canonical map from its residue field factors through that chart and gives a
normalized tuple of coordinates in the residue field.

The first part of the file proves the comparison over an arbitrary `R`-algebra `K` and an
arbitrary `K`-valued point of a standard chart.  The target rings

* `K ⊗[R] ProjectiveSpace.StandardChartRing n R j`, and
* `K ⊗[R] ProjectiveSpace.StandardChartRing m R i`

are exactly the affine coordinate rings occurring after base change of the opposite standard
projective chart.  The final part specializes this construction to the residue field of a
scheme point.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra

namespace ProjectiveSpace

section ResidueCoordinates

variable (n : ℕ) (R : Type u) [CommRing R]

/-- The coefficient homomorphism from the base ring to the residue field of a point of
projective space.  It is induced by the composite from the point's residue spectrum to
`Spec R`. -/
def residueCoefficientMap (x : ProjectiveSpace n R) :
    R →+* (ProjectiveSpace n R).residueField x :=
  (Spec.preimage
    ((ProjectiveSpace n R).fromSpecResidueField x ≫ toSpec n R)).hom

/-- The `R`-algebra structure on the residue field induced by the projective-space structure
morphism.  It is kept as an explicit definition because the residue field has no canonical
global `R`-algebra instance independent of the chosen point and structure morphism. -/
@[implicit_reducible]
def residueAlgebra (x : ProjectiveSpace n R) :
    Algebra R ((ProjectiveSpace n R).residueField x) :=
  (residueCoefficientMap n R x).toAlgebra

@[simp]
theorem algebraMap_residueAlgebra (x : ProjectiveSpace n R) :
    letI : Algebra R ((ProjectiveSpace n R).residueField x) := residueAlgebra n R x
    algebraMap R ((ProjectiveSpace n R).residueField x) =
      residueCoefficientMap n R x :=
  rfl

/-- If `x` lies in the `i`-th standard chart, its canonical residue-field point factors through
the affine scheme underlying that chart. -/
def standardChartResidueLift (x : ProjectiveSpace n R) (i : Fin (n + 1))
    (hx : x ∈ standardChart n R i) :
    Spec ((ProjectiveSpace n R).residueField x) ⟶
      Spec (.of (StandardChartRing n R i)) :=
  IsOpenImmersion.lift (standardChartι n R i)
    ((ProjectiveSpace n R).fromSpecResidueField x) (by
      rw [Scheme.range_fromSpecResidueField, ← Scheme.Hom.coe_opensRange,
        opensRange_standardChartι]
      exact Set.singleton_subset_iff.mpr hx)

@[reassoc (attr := simp)]
theorem standardChartResidueLift_standardChartι
    (x : ProjectiveSpace n R) (i : Fin (n + 1))
    (hx : x ∈ standardChart n R i) :
    standardChartResidueLift n R x i hx ≫ standardChartι n R i =
      (ProjectiveSpace n R).fromSpecResidueField x :=
  IsOpenImmersion.lift_fac _ _ _

/-- Evaluation of functions on a standard chart at the residue-field point `x`. -/
def standardChartResidueRingHom (x : ProjectiveSpace n R) (i : Fin (n + 1))
    (hx : x ∈ standardChart n R i) :
    StandardChartRing n R i →+* (ProjectiveSpace n R).residueField x :=
  (Spec.preimage (standardChartResidueLift n R x i hx)).hom

/-- Chart evaluation respects the coefficient map from the base ring. -/
theorem standardChartResidueRingHom_comp_standardChartRingHom
    (x : ProjectiveSpace n R) (i : Fin (n + 1))
    (hx : x ∈ standardChart n R i) :
    (standardChartResidueRingHom n R x i hx).comp
        (standardChartRingHom n R i) =
      residueCoefficientMap n R x := by
  have hmor :
      standardChartResidueLift n R x i hx ≫
          Spec.map (CommRingCat.ofHom (standardChartRingHom n R i)) =
        (ProjectiveSpace n R).fromSpecResidueField x ≫ toSpec n R := by
    rw [← standardChartι_toSpec n R i, ← Category.assoc,
      standardChartResidueLift_standardChartι]
  have h := congrArg Spec.preimage hmor
  simpa [standardChartResidueRingHom, residueCoefficientMap,
    Spec.preimage_comp] using congrArg CommRingCat.Hom.hom h

/-- The standard-chart evaluation map as an `R`-algebra homomorphism, using the explicitly
defined residue-field algebra structure. -/
def standardChartResidueAlgHom (x : ProjectiveSpace n R) (i : Fin (n + 1))
    (hx : x ∈ standardChart n R i) :
    letI : Algebra R ((ProjectiveSpace n R).residueField x) := residueAlgebra n R x
    StandardChartRing n R i →ₐ[R] (ProjectiveSpace n R).residueField x := by
  letI : Algebra R ((ProjectiveSpace n R).residueField x) := residueAlgebra n R x
  exact
    { standardChartResidueRingHom n R x i hx with
      commutes' := fun r ↦ by
        change standardChartResidueRingHom n R x i hx
            (standardChartRingHom n R i r) =
          residueCoefficientMap n R x r
        exact DFunLike.congr_fun
          (standardChartResidueRingHom_comp_standardChartRingHom n R x i hx) r }

/-- The normalized homogeneous-coordinate representative of `x` determined by a standard
chart containing it. -/
def normalizedResidueCoordinates (x : ProjectiveSpace n R) (i : Fin (n + 1))
    (hx : x ∈ standardChart n R i) :
    Fin (n + 1) → (ProjectiveSpace n R).residueField x :=
  fun l ↦ standardChartResidueRingHom n R x i hx
    (normalizedCoordinate n R i l)

@[simp]
theorem normalizedResidueCoordinates_self
    (x : ProjectiveSpace n R) (i : Fin (n + 1))
    (hx : x ∈ standardChart n R i) :
    normalizedResidueCoordinates n R x i hx i = 1 := by
  simp [normalizedResidueCoordinates]

end ResidueCoordinates

end ProjectiveSpace

/-- Mapping coefficients preserves a specified bidegree. -/
theorem IsBihomogeneousOfBidegree.map_coefficients
    {m n d e : ℕ} {R K : Type*} [CommSemiring R] [CommSemiring K]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F) (f : R →+* K) :
    IsBihomogeneousOfBidegree d e (F.map f) := by
  intro s hs
  apply hF
  intro hzero
  apply hs
  rw [MvPolynomial.coeff_map, hzero, map_zero]

namespace BiprojectiveSpace

section AlgebraicComparison

variable {m n : ℕ} {R K : Type u} [CommRing R] [CommRing K] [Algebra R K]
variable {i : Fin (m + 1)} {j : Fin (n + 1)}

/-- Evaluate the first standard-chart factor at a `K`-valued point and base change the second
factor.  Its target is the coordinate ring of the corresponding affine chart in the first
projection's base change to `K`. -/
def fstFiberChartMap
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K) :
    StandardChartRing m n R i j →ₐ[R]
      K ⊗[R] ProjectiveSpace.StandardChartRing n R j :=
  Algebra.TensorProduct.lift
    ((Algebra.TensorProduct.includeLeft : K →ₐ[R]
      K ⊗[R] ProjectiveSpace.StandardChartRing n R j).comp x)
    (Algebra.TensorProduct.includeRight : ProjectiveSpace.StandardChartRing n R j →ₐ[R]
      K ⊗[R] ProjectiveSpace.StandardChartRing n R j)
    (fun _ _ ↦ Commute.all _ _)

@[simp]
theorem fstFiberChartMap_tmul
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K)
    (a : ProjectiveSpace.StandardChartRing m R i)
    (b : ProjectiveSpace.StandardChartRing n R j) :
    fstFiberChartMap x (a ⊗ₜ[R] b) = x a ⊗ₜ[R] b := by
  simp [fstFiberChartMap]

/-- The normalized homogeneous coordinates supplied by a `K`-valued point of the `i`-th
standard chart. -/
def firstNormalizedCoordinates
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K) :
    Fin (m + 1) → K :=
  fun l ↦ x (ProjectiveSpace.normalizedCoordinate m R i l)

@[simp]
theorem firstNormalizedCoordinates_self
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K) :
    firstNormalizedCoordinates x i = 1 := by
  simp [firstNormalizedCoordinates]

/-- On a standard chart of the first base-changed fiber, the pulled-back biprojective chart
equation is the equation obtained by mapping coefficients to `K`, substituting the normalized
first coordinates, and evaluating the remaining homogeneous coordinates on the second chart.

No homogeneity hypothesis is needed for this algebraic identity. -/
theorem fstFiberChartMap_chartEquation
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    fstFiberChartMap x (chartEquation m n R i j F) =
      MvPolynomial.aeval
        (fun l ↦
          (Algebra.TensorProduct.includeRight :
            ProjectiveSpace.StandardChartRing n R j →ₐ[R]
              K ⊗[R] ProjectiveSpace.StandardChartRing n R j)
            (ProjectiveSpace.normalizedCoordinate n R j l))
        (specializeFirstCoordinates (firstNormalizedCoordinates x)
          (F.map (algebraMap R K))) := by
  induction F using MvPolynomial.induction_on with
  | C r => simp [chartEquation, chartEvaluation, specializeFirstCoordinates]
  | add p q hp hq =>
      rw [show chartEquation m n R i j (p + q) =
        chartEquation m n R i j p + chartEquation m n R i j q by
          simp [chartEquation]]
      rw [map_add]
      simpa only [map_add] using congrArg₂ (fun a b ↦ a + b) hp hq
  | mul_X p z hp =>
      cases z with
      | inl l =>
          simpa [chartEquation, chartEvaluation, firstNormalizedCoordinates,
            specializeFirstCoordinates] using
              congrArg (fun q ↦ q * (x
                (ProjectiveSpace.normalizedCoordinate m R i l) ⊗ₜ[R] 1)) hp
      | inr l =>
          simpa [chartEquation, chartEvaluation, specializeFirstCoordinates] using
            congrArg (fun q ↦ q * (1 ⊗ₜ[R]
              ProjectiveSpace.normalizedCoordinate n R j l)) hp

/-- The corresponding equality of concrete principal ideals on the base-changed affine chart. -/
theorem map_span_chartEquation_fstFiberChartMap
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    Ideal.map (fstFiberChartMap x).toRingHom
        (Ideal.span {chartEquation m n R i j F}) =
      Ideal.span
        {MvPolynomial.aeval
          (fun l ↦
            (Algebra.TensorProduct.includeRight :
              ProjectiveSpace.StandardChartRing n R j →ₐ[R]
                K ⊗[R] ProjectiveSpace.StandardChartRing n R j)
              (ProjectiveSpace.normalizedCoordinate n R j l))
          (specializeFirstCoordinates (firstNormalizedCoordinates x)
            (F.map (algebraMap R K)))} := by
  rw [Ideal.map_span, Set.image_singleton]
  change Ideal.span {fstFiberChartMap x (chartEquation m n R i j F)} = _
  exact congrArg (fun z ↦ Ideal.span {z}) (fstFiberChartMap_chartEquation x F)

/-- Evaluate the second standard-chart factor at a `K`-valued point and base change the first
factor.  Its target is the coordinate ring of the corresponding affine chart in the second
projection's base change to `K`. -/
def sndFiberChartMap
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K) :
    StandardChartRing m n R i j →ₐ[R]
      K ⊗[R] ProjectiveSpace.StandardChartRing m R i :=
  Algebra.TensorProduct.lift
    (Algebra.TensorProduct.includeRight : ProjectiveSpace.StandardChartRing m R i →ₐ[R]
      K ⊗[R] ProjectiveSpace.StandardChartRing m R i)
    ((Algebra.TensorProduct.includeLeft : K →ₐ[R]
      K ⊗[R] ProjectiveSpace.StandardChartRing m R i).comp y)
    (fun _ _ ↦ Commute.all _ _)

@[simp]
theorem sndFiberChartMap_tmul
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K)
    (a : ProjectiveSpace.StandardChartRing m R i)
    (b : ProjectiveSpace.StandardChartRing n R j) :
    sndFiberChartMap y (a ⊗ₜ[R] b) = y b ⊗ₜ[R] a := by
  simp [sndFiberChartMap]

/-- The normalized homogeneous coordinates supplied by a `K`-valued point of the `j`-th
standard chart. -/
def secondNormalizedCoordinates
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K) :
    Fin (n + 1) → K :=
  fun l ↦ y (ProjectiveSpace.normalizedCoordinate n R j l)

@[simp]
theorem secondNormalizedCoordinates_self
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K) :
    secondNormalizedCoordinates y j = 1 := by
  simp [secondNormalizedCoordinates]

/-- The chartwise equation comparison for the second projection. -/
theorem sndFiberChartMap_chartEquation
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    sndFiberChartMap y (chartEquation m n R i j F) =
      MvPolynomial.aeval
        (fun l ↦
          (Algebra.TensorProduct.includeRight :
            ProjectiveSpace.StandardChartRing m R i →ₐ[R]
              K ⊗[R] ProjectiveSpace.StandardChartRing m R i)
            (ProjectiveSpace.normalizedCoordinate m R i l))
        (specializeSecondCoordinates (secondNormalizedCoordinates y)
          (F.map (algebraMap R K))) := by
  induction F using MvPolynomial.induction_on with
  | C r =>
      simp only [chartEquation, chartEvaluation, map_C, AlgHom.commutes,
        specializeSecondCoordinates_C, map_C, aeval_C]
      exact IsScalarTower.algebraMap_apply R K
        (K ⊗[R] ProjectiveSpace.StandardChartRing m R i) r
  | add p q hp hq =>
      rw [show chartEquation m n R i j (p + q) =
        chartEquation m n R i j p + chartEquation m n R i j q by
          simp [chartEquation]]
      rw [map_add]
      simpa only [map_add] using congrArg₂ (fun a b ↦ a + b) hp hq
  | mul_X p z hp =>
      cases z with
      | inl l =>
          simpa [chartEquation, chartEvaluation, specializeSecondCoordinates] using
            congrArg (fun q ↦ q * (1 ⊗ₜ[R]
              ProjectiveSpace.normalizedCoordinate m R i l)) hp
      | inr l =>
          simpa [chartEquation, chartEvaluation, secondNormalizedCoordinates,
            specializeSecondCoordinates] using
              congrArg (fun q ↦ q * (y
                (ProjectiveSpace.normalizedCoordinate n R j l) ⊗ₜ[R] 1)) hp

/-- The corresponding equality of concrete principal ideals for the second projection. -/
theorem map_span_chartEquation_sndFiberChartMap
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    Ideal.map (sndFiberChartMap y).toRingHom
        (Ideal.span {chartEquation m n R i j F}) =
      Ideal.span
        {MvPolynomial.aeval
          (fun l ↦
            (Algebra.TensorProduct.includeRight :
              ProjectiveSpace.StandardChartRing m R i →ₐ[R]
                K ⊗[R] ProjectiveSpace.StandardChartRing m R i)
              (ProjectiveSpace.normalizedCoordinate m R i l))
          (specializeSecondCoordinates (secondNormalizedCoordinates y)
            (F.map (algebraMap R K)))} := by
  rw [Ideal.map_span, Set.image_singleton]
  change Ideal.span {sndFiberChartMap y (chartEquation m n R i j F)} = _
  exact congrArg (fun z ↦ Ideal.span {z}) (sndFiberChartMap_chartEquation y F)

end AlgebraicComparison

section ResidueFieldComparison

variable {m n d e : ℕ} {R : Type u} [CommRing R]

@[simp]
theorem firstNormalizedCoordinates_standardChartResidueAlgHom
    (x : ProjectiveSpace m R) (i : Fin (m + 1))
    (hx : x ∈ ProjectiveSpace.standardChart m R i) :
    letI : Algebra R ((ProjectiveSpace m R).residueField x) :=
      ProjectiveSpace.residueAlgebra m R x
    firstNormalizedCoordinates
        (ProjectiveSpace.standardChartResidueAlgHom m R x i hx) =
      ProjectiveSpace.normalizedResidueCoordinates m R x i hx := by
  letI : Algebra R ((ProjectiveSpace m R).residueField x) :=
    ProjectiveSpace.residueAlgebra m R x
  funext l
  rfl

@[simp]
theorem secondNormalizedCoordinates_standardChartResidueAlgHom
    (y : ProjectiveSpace n R) (j : Fin (n + 1))
    (hy : y ∈ ProjectiveSpace.standardChart n R j) :
    letI : Algebra R ((ProjectiveSpace n R).residueField y) :=
      ProjectiveSpace.residueAlgebra n R y
    secondNormalizedCoordinates
        (ProjectiveSpace.standardChartResidueAlgHom n R y j hy) =
      ProjectiveSpace.normalizedResidueCoordinates n R y j hy := by
  letI : Algebra R ((ProjectiveSpace n R).residueField y) :=
    ProjectiveSpace.residueAlgebra n R y
  funext l
  rfl

/-- The homogeneous polynomial over `κ(x)` obtained by mapping coefficients to the residue
field and substituting the normalized first coordinates determined by a chart containing `x`.
The choice of chart is part of the data; changing it rescales the polynomial by the expected
power for a bihomogeneous equation. -/
def fstResidueFiberPolynomial
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (x : ProjectiveSpace m R) (i : Fin (m + 1))
    (hx : x ∈ ProjectiveSpace.standardChart m R i) :
    MvPolynomial (Fin (n + 1)) ((ProjectiveSpace m R).residueField x) :=
  specializeFirstCoordinates
    (ProjectiveSpace.normalizedResidueCoordinates m R x i hx)
    (F.map (ProjectiveSpace.residueCoefficientMap m R x))

/-- A bidegree-`(d,e)` equation gives a degree-`e` homogeneous equation on a first-projection
fiber over the residue field. -/
theorem fstResidueFiberPolynomial_isHomogeneous
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x : ProjectiveSpace m R) (i : Fin (m + 1))
    (hx : x ∈ ProjectiveSpace.standardChart m R i) :
    (fstResidueFiberPolynomial F x i hx).IsHomogeneous e :=
  IsBihomogeneousOfBidegree.specializeFirstCoordinates_isHomogeneous
    (hF.map_coefficients (ProjectiveSpace.residueCoefficientMap m R x))
    (ProjectiveSpace.normalizedResidueCoordinates m R x i hx)

/-- The analogous residue-field equation for a fiber of the second projection. -/
def sndResidueFiberPolynomial
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (y : ProjectiveSpace n R) (j : Fin (n + 1))
    (hy : y ∈ ProjectiveSpace.standardChart n R j) :
    MvPolynomial (Fin (m + 1)) ((ProjectiveSpace n R).residueField y) :=
  specializeSecondCoordinates
    (ProjectiveSpace.normalizedResidueCoordinates n R y j hy)
    (F.map (ProjectiveSpace.residueCoefficientMap n R y))

/-- A bidegree-`(d,e)` equation gives a degree-`d` homogeneous equation on a second-projection
fiber over the residue field. -/
theorem sndResidueFiberPolynomial_isHomogeneous
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (y : ProjectiveSpace n R) (j : Fin (n + 1))
    (hy : y ∈ ProjectiveSpace.standardChart n R j) :
    (sndResidueFiberPolynomial F y j hy).IsHomogeneous d :=
  IsBihomogeneousOfBidegree.specializeSecondCoordinates_isHomogeneous
    (hF.map_coefficients (ProjectiveSpace.residueCoefficientMap n R y))
    (ProjectiveSpace.normalizedResidueCoordinates n R y j hy)

/-- The exact chartwise equation comparison at a scheme point of the first projective factor.
The target is the tensor-product coordinate ring of the `j`-th projective chart after base
change to `κ(x)`. -/
theorem fstResidueFiberChartMap_chartEquation
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (x : ProjectiveSpace m R) (i : Fin (m + 1))
    (hx : x ∈ ProjectiveSpace.standardChart m R i)
    (j : Fin (n + 1)) :
    letI : Algebra R ((ProjectiveSpace m R).residueField x) :=
      ProjectiveSpace.residueAlgebra m R x
    fstFiberChartMap
        (ProjectiveSpace.standardChartResidueAlgHom m R x i hx)
        (chartEquation m n R i j F) =
      MvPolynomial.aeval
        (fun l ↦
          (Algebra.TensorProduct.includeRight :
            ProjectiveSpace.StandardChartRing n R j →ₐ[R]
              (ProjectiveSpace m R).residueField x ⊗[R]
                ProjectiveSpace.StandardChartRing n R j)
            (ProjectiveSpace.normalizedCoordinate n R j l))
        (fstResidueFiberPolynomial F x i hx) := by
  letI : Algebra R ((ProjectiveSpace m R).residueField x) :=
    ProjectiveSpace.residueAlgebra m R x
  simpa only [fstResidueFiberPolynomial,
    firstNormalizedCoordinates_standardChartResidueAlgHom,
    ProjectiveSpace.algebraMap_residueAlgebra] using
      fstFiberChartMap_chartEquation
        (ProjectiveSpace.standardChartResidueAlgHom m R x i hx) F

/-- Ideal-level form of `fstResidueFiberChartMap_chartEquation`: the extended principal ideal
on the residue-field fiber chart is generated by the specialized fiber equation. -/
theorem map_span_chartEquation_fstResidueFiber
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (x : ProjectiveSpace m R) (i : Fin (m + 1))
    (hx : x ∈ ProjectiveSpace.standardChart m R i)
    (j : Fin (n + 1)) :
    letI : Algebra R ((ProjectiveSpace m R).residueField x) :=
      ProjectiveSpace.residueAlgebra m R x
    Ideal.map
        (fstFiberChartMap
          (ProjectiveSpace.standardChartResidueAlgHom m R x i hx)).toRingHom
        (Ideal.span {chartEquation m n R i j F}) =
      Ideal.span
        {MvPolynomial.aeval
          (fun l ↦
            (Algebra.TensorProduct.includeRight :
              ProjectiveSpace.StandardChartRing n R j →ₐ[R]
                (ProjectiveSpace m R).residueField x ⊗[R]
                  ProjectiveSpace.StandardChartRing n R j)
              (ProjectiveSpace.normalizedCoordinate n R j l))
          (fstResidueFiberPolynomial F x i hx)} := by
  letI : Algebra R ((ProjectiveSpace m R).residueField x) :=
    ProjectiveSpace.residueAlgebra m R x
  rw [Ideal.map_span, Set.image_singleton]
  change Ideal.span
    {fstFiberChartMap (ProjectiveSpace.standardChartResidueAlgHom m R x i hx)
      (chartEquation m n R i j F)} = _
  exact congrArg (fun z ↦ Ideal.span {z})
    (fstResidueFiberChartMap_chartEquation F x i hx j)

/-- The exact chartwise equation comparison at a scheme point of the second projective factor. -/
theorem sndResidueFiberChartMap_chartEquation
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (y : ProjectiveSpace n R) (j : Fin (n + 1))
    (hy : y ∈ ProjectiveSpace.standardChart n R j)
    (i : Fin (m + 1)) :
    letI : Algebra R ((ProjectiveSpace n R).residueField y) :=
      ProjectiveSpace.residueAlgebra n R y
    sndFiberChartMap
        (ProjectiveSpace.standardChartResidueAlgHom n R y j hy)
        (chartEquation m n R i j F) =
      MvPolynomial.aeval
        (fun l ↦
          (Algebra.TensorProduct.includeRight :
            ProjectiveSpace.StandardChartRing m R i →ₐ[R]
              (ProjectiveSpace n R).residueField y ⊗[R]
                ProjectiveSpace.StandardChartRing m R i)
            (ProjectiveSpace.normalizedCoordinate m R i l))
        (sndResidueFiberPolynomial F y j hy) := by
  letI : Algebra R ((ProjectiveSpace n R).residueField y) :=
    ProjectiveSpace.residueAlgebra n R y
  simpa only [sndResidueFiberPolynomial,
    secondNormalizedCoordinates_standardChartResidueAlgHom,
    ProjectiveSpace.algebraMap_residueAlgebra] using
      sndFiberChartMap_chartEquation
        (ProjectiveSpace.standardChartResidueAlgHom n R y j hy) F

/-- Ideal-level form of `sndResidueFiberChartMap_chartEquation`. -/
theorem map_span_chartEquation_sndResidueFiber
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (y : ProjectiveSpace n R) (j : Fin (n + 1))
    (hy : y ∈ ProjectiveSpace.standardChart n R j)
    (i : Fin (m + 1)) :
    letI : Algebra R ((ProjectiveSpace n R).residueField y) :=
      ProjectiveSpace.residueAlgebra n R y
    Ideal.map
        (sndFiberChartMap
          (ProjectiveSpace.standardChartResidueAlgHom n R y j hy)).toRingHom
        (Ideal.span {chartEquation m n R i j F}) =
      Ideal.span
        {MvPolynomial.aeval
          (fun l ↦
            (Algebra.TensorProduct.includeRight :
              ProjectiveSpace.StandardChartRing m R i →ₐ[R]
                (ProjectiveSpace n R).residueField y ⊗[R]
                  ProjectiveSpace.StandardChartRing m R i)
              (ProjectiveSpace.normalizedCoordinate m R i l))
          (sndResidueFiberPolynomial F y j hy)} := by
  letI : Algebra R ((ProjectiveSpace n R).residueField y) :=
    ProjectiveSpace.residueAlgebra n R y
  rw [Ideal.map_span, Set.image_singleton]
  change Ideal.span
    {sndFiberChartMap (ProjectiveSpace.standardChartResidueAlgHom n R y j hy)
      (chartEquation m n R i j F)} = _
  exact congrArg (fun z ↦ Ideal.span {z})
    (sndResidueFiberChartMap_chartEquation F y j hy i)

end ResidueFieldComparison

end BiprojectiveSpace

end

end BConicBundleMultisections
