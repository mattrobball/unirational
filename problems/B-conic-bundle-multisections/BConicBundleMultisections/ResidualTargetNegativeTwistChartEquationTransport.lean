/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveHypersurfaceChartTransition
public import BConicBundleMultisections.TargetRelationChartDomain

/-!
# Intrinsic target-chart transport for residual equations

This file compares the affine equations obtained from two standard charts of an irreducible
projective target relation.  The first projective chart is fixed throughout.  If a Cox
polynomial has target degree `e`, its two coefficient-polynomial representatives in the
intrinsic function field differ by the `e`-th power of the canonical target transition unit.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial

namespace BiprojectiveSpace

variable {k : Type u} [Field k]

attribute [local instance] MvPolynomial.gradedAlgebra

/-- Mapping a target-relation chart equation to any common coefficient ring amounts to
specializing the target coordinates there and then dehomogenizing in the fixed first chart. -/
theorem map_affineChartEquationOverTargetRelationBase_eq_intrinsicSpecialization
    {L : Type u} [CommRing L]
    (H : MvPolynomial (Fin 3) k) (a b : Fin 3)
    (P : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (phi : targetRelationBaseChartRing k H b →+* L) :
    MvPolynomial.map phi
        (affineChartEquationOverTargetRelationBase k H a b P) =
      ProjectiveSpace.chartDehomogenization 2 L a
        (specializeSecondCoordinates
          (fun l ↦ phi (targetRelationChartCoordinates b H l))
          (MvPolynomial.map (phi.comp
            (algebraMap k (targetRelationBaseChartRing k H b))) P)) := by
  let A := targetRelationBaseChartRing k H b
  let psi : k →+* L := phi.comp (algebraMap k A)
  letI : Algebra A L := phi.toAlgebra
  letI : Algebra k L := psi.toAlgebra
  rw [affineChartEquationOverTargetRelationBase_eq_chartDehomogenization]
  change MvPolynomial.map (algebraMap A L)
      (ProjectiveSpace.chartDehomogenization 2 A a
        (sndConicAt P (targetRelationChartCoordinates b H))) = _
  rw [← chartDehomogenization_map]
  rw [map_sndConicAt (algebraMap A L)]
  · rfl
  · rfl

/-- The image in the intrinsic target function field of the standard overlap transition
`X_{b'} / X_b`. -/
noncomputable def targetRelationIntrinsicTransition
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (b b' : ProjectiveSpace.NonemptyHypersurfaceChart H) :
    letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
      ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    (ProjectiveSpace.projectiveZeroLocus 2 k H).functionField := by
  letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
    ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  exact ProjectiveSpace.hypersurfaceOverlapToSchemeFunctionField
    H hH hd hHirr b b'
      (ProjectiveSpace.hypersurfaceTransition 2 k b.1 b'.1)

/-- The intrinsic transition is the image of the `b'`-th normalized coordinate on the
`b`-chart quotient. -/
theorem targetRelationIntrinsicTransition_eq_chartCoordinate
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (b b' : ProjectiveSpace.NonemptyHypersurfaceChart H) :
    letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
      ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    targetRelationIntrinsicTransition H hH hd hHirr b b' =
      ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
        H hH hd hHirr b (targetRelationChartCoordinates b.1 H b'.1) := by
  letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
    ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  change ProjectiveSpace.hypersurfaceOverlapToSchemeFunctionField
      H hH hd hHirr b b'
        (ProjectiveSpace.toOverlap 2 k b.1 b'.1
          (ProjectiveSpace.normalizedCoordinate 2 k b.1 b'.1)) = _
  change ((ProjectiveSpace.hypersurfaceOverlapToSchemeFunctionField
      H hH hd hHirr b b').comp
        (ProjectiveSpace.toOverlap 2 k b.1 b'.1))
      (ProjectiveSpace.normalizedCoordinate 2 k b.1 b'.1) = _
  rw [ProjectiveSpace.hypersurfaceOverlapToSchemeFunctionField_comp_toOverlap]
  rw [ProjectiveSpace.hypersurfaceStandardChartToSchemeFunctionField_normalizedCoordinate]
  rfl

/-- The image of the target transition remains a unit in the intrinsic function field. -/
theorem isUnit_targetRelationIntrinsicTransition
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (b b' : ProjectiveSpace.NonemptyHypersurfaceChart H) :
    letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
      ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    IsUnit (targetRelationIntrinsicTransition H hH hd hHirr b b') := by
  letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
    ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  exact IsUnit.map
    (ProjectiveSpace.hypersurfaceOverlapToSchemeFunctionField
      H hH hd hHirr b b')
    (ProjectiveSpace.isUnit_hypersurfaceTransition 2 k b.1 b'.1)

/-- Intrinsic normalized target coordinates on the `b`-chart are the transition unit times
the corresponding normalized coordinates on the `b'`-chart. -/
theorem targetRelationChartCoordinates_intrinsic_transition
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (b b' : ProjectiveSpace.NonemptyHypersurfaceChart H) (l : Fin 3) :
    letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
      ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
        H hH hd hHirr b (targetRelationChartCoordinates b.1 H l) =
      targetRelationIntrinsicTransition H hH hd hHirr b b' *
        ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
          H hH hd hHirr b' (targetRelationChartCoordinates b'.1 H l) := by
  letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
    ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  have h := ProjectiveSpace.hypersurfaceChartDehomogenization_intrinsic_transition_mul
    H hH hd hHirr b b' (MvPolynomial.X l)
      (MvPolynomial.isHomogeneous_X k l)
  rw [targetRelationIntrinsicTransition_eq_chartCoordinate H hH hd hHirr b b']
  simpa only [targetRelationChartCoordinates, pow_one] using h

/-- The two retained target charts induce the same base-field map to the intrinsic function
field. -/
theorem targetRelationBaseMapToSchemeFunctionField_eq
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (b b' : ProjectiveSpace.NonemptyHypersurfaceChart H) :
    letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
      ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    (ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
      H hH hd hHirr b).comp
        (algebraMap k (targetRelationBaseChartRing k H b.1)) =
      (ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
        H hH hd hHirr b').comp
          (algebraMap k (targetRelationBaseChartRing k H b'.1)) := by
  letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
    ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  ext c
  have h := ProjectiveSpace.hypersurfaceChartDehomogenization_intrinsic_transition_mul
    H hH hd hHirr b b' (MvPolynomial.C c)
      (MvPolynomial.isHomogeneous_C (Fin 3) c)
  simp only [ProjectiveSpace.chartDehomogenization, MvPolynomial.aeval_C,
    pow_zero, one_mul] at h
  change ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
      H hH hd hHirr b
        (algebraMap k (targetRelationBaseChartRing k H b.1) c) =
    ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
      H hH hd hHirr b'
        (algebraMap k (targetRelationBaseChartRing k H b'.1) c) at h
  simpa only [RingHom.comp_apply] using h

/-- With the first projective chart `a` fixed, changing the target chart from `b` to `b'`
multiplies a target-degree-`e` affine equation by the `e`-th power of the intrinsic transition.

Both sides are polynomials in the same first-chart affine variables with coefficients in the
intrinsic function field of `V(H)`. -/
theorem affineChartEquationOverTargetRelationBase_intrinsic_transition
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (b b' : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (a : Fin 3) {p e : ℕ}
    (P : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hP : IsBihomogeneousOfBidegree p e P) :
    letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
      ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    MvPolynomial.map
        (ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
          H hH hd hHirr b)
        (affineChartEquationOverTargetRelationBase k H a b.1 P) =
      MvPolynomial.C
          (targetRelationIntrinsicTransition H hH hd hHirr b b') ^ e *
        MvPolynomial.map
          (ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
            H hH hd hHirr b')
          (affineChartEquationOverTargetRelationBase k H a b'.1 P) := by
  letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
    ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  let K := (ProjectiveSpace.projectiveZeroLocus 2 k H).functionField
  let phi := ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
    H hH hd hHirr b
  let phi' := ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
    H hH hd hHirr b'
  let psi : k →+* K := phi.comp
    (algebraMap k (targetRelationBaseChartRing k H b.1))
  let psi' : k →+* K := phi'.comp
    (algebraMap k (targetRelationBaseChartRing k H b'.1))
  let y : Fin 3 → K := fun l ↦ phi (targetRelationChartCoordinates b.1 H l)
  let y' : Fin 3 → K := fun l ↦ phi' (targetRelationChartCoordinates b'.1 H l)
  let T : K := targetRelationIntrinsicTransition H hH hd hHirr b b'
  have hpsi : psi = psi' :=
    targetRelationBaseMapToSchemeFunctionField_eq H hH hd hHirr b b'
  have hy : y = T • y' := by
    funext l
    exact targetRelationChartCoordinates_intrinsic_transition
      H hH hd hHirr b b' l
  rw [map_affineChartEquationOverTargetRelationBase_eq_intrinsicSpecialization,
    map_affineChartEquationOverTargetRelationBase_eq_intrinsicSpecialization]
  change ProjectiveSpace.chartDehomogenization 2 K a
      (specializeSecondCoordinates y (MvPolynomial.map psi P)) =
    MvPolynomial.C T ^ e *
      ProjectiveSpace.chartDehomogenization 2 K a
        (specializeSecondCoordinates y' (MvPolynomial.map psi' P))
  rw [hpsi, hy]
  have hscale :=
    (hP.map_coefficients psi').specializeSecondCoordinates_smul T y'
  have hchart := congrArg
    (ProjectiveSpace.chartDehomogenization 2 K a) hscale
  simpa [ProjectiveSpace.chartDehomogenization] using hchart

end BiprojectiveSpace

end

end BConicBundleMultisections
