module

public import V14Formalization.ProjectiveGermRatio

noncomputable section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u
variable {Omega : Type u} [Field Omega]

set_option backward.isDefEq.respectTransparency false in
/-- The projective standard-chart function-field equivalence sends a chart
ring element to the germ of its canonical `Proj.awayToSection`. -/
theorem projectiveGeneralFunctionFieldEquiv_standardChartRing
    (r : ℕ) (z : ProjectiveSpace.StandardChartRing (r + 1) Omega 0) :
    projectiveGeneralFunctionFieldEquiv r Omega
        (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
          (ProjectiveSpace.standardChartRingEquivMvPolynomial
            (r + 1) Omega 0 z)) =
      (ProjectiveSpace (r + 1) Omega).presheaf.germ
        (AlgebraicGeometry.Proj.basicOpen
          (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
        (genericPoint (ProjectiveSpace (r + 1) Omega))
        (by
          exact ((genericPoint_spec
            (ProjectiveSpace (r + 1) Omega)).mem_open_set_iff
              (ProjectiveSpace.standardChart (r + 1) Omega 0).isOpen).mpr
            ⟨ProjectiveSpace.genericPoint (r + 1) Omega,
              ⟨Set.mem_univ _, ProjectiveSpace.genericPoint_mem_standardChart
                (r + 1) Omega 0⟩⟩)
        ((AlgebraicGeometry.Proj.awayToSection
          (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1)))) z) := by
  rw [projectiveGeneralFunctionFieldEquiv_algebraMap]
  let X := ProjectiveSpace (r + 1) Omega
  let U := (ProjectiveSpace.standardChartι (r + 1) Omega 0).opensRange
  let B := ProjectiveSpace.standardChart (r + 1) Omega 0
  have hUB : U = B := ProjectiveSpace.opensRange_standardChartι
    (r + 1) Omega (0 : Fin ((r + 1) + 1))
  let P := ProjectiveSpace.standardChartRingEquivMvPolynomial
    (r + 1) Omega 0 z
  rw [projectiveGeneralGammaEquivMvPolynomial_symm_eq_awayToSection]
  have hetaU : genericPoint X ∈ U :=
    ((genericPoint_spec X).mem_open_set_iff U.isOpen).mpr
      (by simpa using (inferInstance : Nonempty U))
  have hetaB : genericPoint X ∈ B :=
    ((genericPoint_spec X).mem_open_set_iff B.isOpen).mpr
      ⟨ProjectiveSpace.genericPoint (r + 1) Omega,
        ⟨Set.mem_univ _,
          ProjectiveSpace.genericPoint_mem_standardChart (r + 1) Omega 0⟩⟩
  have hres := X.presheaf.germ_res_apply
    (eqToHom hUB) (genericPoint X) hetaU
    ((AlgebraicGeometry.Proj.awayToSection
      (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
      (MvPolynomial.X (0 : Fin ((r + 1) + 1)))) z)
  rw [AlgEquiv.symm_apply_apply]
  change X.presheaf.germ U (genericPoint X) _
      (X.presheaf.map (eqToHom hUB).op
        ((AlgebraicGeometry.Proj.awayToSection
          (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1)))) z)) =
    X.presheaf.germ B (genericPoint X) _
      ((AlgebraicGeometry.Proj.awayToSection
        (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
        (MvPolynomial.X (0 : Fin ((r + 1) + 1)))) z)
  exact hres

/-- A homogeneous linear form divided by the zeroth coordinate is represented
by its dehomogenization under the standard projective function-field chart. -/
theorem projectiveGeneralFunctionFieldEquiv_chartDehomogenization
    (r : ℕ) (g : MvPolynomial (Fin ((r + 1) + 1)) Omega)
    (hg : g ∈ MvPolynomial.homogeneousSubmodule
      (Fin ((r + 1) + 1)) Omega 1) :
    projectiveGeneralFunctionFieldEquiv r Omega
        (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
          (ProjectiveSpace.chartDehomogenization (r + 1) Omega 0 g)) =
      (ProjectiveSpace (r + 1) Omega).presheaf.germ
        (AlgebraicGeometry.Proj.basicOpen
          (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
        (genericPoint (ProjectiveSpace (r + 1) Omega))
        (by
          exact ((genericPoint_spec
            (ProjectiveSpace (r + 1) Omega)).mem_open_set_iff
              (ProjectiveSpace.standardChart (r + 1) Omega 0).isOpen).mpr
            ⟨ProjectiveSpace.genericPoint (r + 1) Omega,
              ⟨Set.mem_univ _, ProjectiveSpace.genericPoint_mem_standardChart
                (r + 1) Omega 0⟩⟩)
        ((AlgebraicGeometry.Proj.awayToSection
          (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
          (HomogeneousLocalization.Away.mk
            (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
            (MvPolynomial.isHomogeneous_X Omega
              (0 : Fin ((r + 1) + 1))) 1 g (by simpa using hg))) := by
  let z := HomogeneousLocalization.Away.mk
    (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
    (MvPolynomial.isHomogeneous_X Omega (0 : Fin ((r + 1) + 1)))
    1 g (by simpa using hg)
  have hz : ProjectiveSpace.standardChartRingEquivMvPolynomial
      (r + 1) Omega 0 z =
      ProjectiveSpace.chartDehomogenization (r + 1) Omega 0 g := by
    exact ProjectiveSpace.standardChartToMvPolynomial_away_mk
      (r + 1) Omega 0 1 g hg
  rw [← hz]
  exact projectiveGeneralFunctionFieldEquiv_standardChartRing r z

set_option backward.isDefEq.respectTransparency false in
/-- Pullback of a normalized projective coordinate, in cross-multiplied form:
the transformed numerator divided by the transformed zeroth coordinate. -/
theorem mapLinearSubst_functionFieldMap_projectiveGeneral_normalized_mul
    (r : ℕ)
    (M N : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (hNM : N * M = 1)
    [IsDominant (mapLinearSubst (r + 1) M N hNM)]
    (i : Fin ((r + 1) + 1)) :
    let e := projectiveGeneralFunctionFieldEquiv r Omega
    let K := FractionRing (MvPolynomial (Fin (r + 1)) Omega)
    (mapLinearSubst (r + 1) M N hNM).functionFieldMap
        (e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
          (ProjectiveSpace.standardChartRingEquivMvPolynomial
            (r + 1) Omega 0
            (ProjectiveSpace.normalizedCoordinate
              (r + 1) Omega 0 i)))) *
      e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
        (ProjectiveSpace.chartDehomogenization (r + 1) Omega 0
          ((linearSubstGradedRingHom (r + 1) M)
            (MvPolynomial.X (0 : Fin ((r + 1) + 1)))))) =
      e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
        (ProjectiveSpace.chartDehomogenization (r + 1) Omega 0
          (linearSubst (r + 1) M i))) := by
  dsimp only
  let X := ProjectiveSpace (r + 1) Omega
  let eta := genericPoint X
  let L0 := (linearSubstGradedRingHom (r + 1) M)
    (MvPolynomial.X (0 : Fin ((r + 1) + 1)))
  let Li := linearSubst (r + 1) M i
  have hL0 : L0 ∈ MvPolynomial.homogeneousSubmodule
      (Fin ((r + 1) + 1)) Omega 1 := by
    exact (linearSubstGradedRingHom (r + 1) M).map_mem
      (MvPolynomial.isHomogeneous_X Omega (0 : Fin ((r + 1) + 1)))
  have hLi : Li ∈ MvPolynomial.homogeneousSubmodule
      (Fin ((r + 1) + 1)) Omega 1 := by
    exact isHomogeneous_linearSubst (r + 1) M i
  have hetaL0 : eta ∈ AlgebraicGeometry.Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega) L0 := by
    change (mapLinearSubst (r + 1) M N hNM) eta ∈
      ProjectiveSpace.standardChart (r + 1) Omega 0
    rw [(mapLinearSubst (r + 1) M N hNM).map_genericPoint_of_isDominant]
    exact ((genericPoint_spec X).mem_open_set_iff
      (ProjectiveSpace.standardChart (r + 1) Omega 0).isOpen).mpr
      ⟨ProjectiveSpace.genericPoint (r + 1) Omega,
        ⟨Set.mem_univ _, ProjectiveSpace.genericPoint_mem_standardChart
          (r + 1) Omega 0⟩⟩
  have heta0 : eta ∈ AlgebraicGeometry.Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
      (MvPolynomial.X (0 : Fin ((r + 1) + 1))) := by
    exact ((genericPoint_spec X).mem_open_set_iff
      (ProjectiveSpace.standardChart (r + 1) Omega 0).isOpen).mpr
      ⟨ProjectiveSpace.genericPoint (r + 1) Omega,
        ⟨Set.mem_univ _, ProjectiveSpace.genericPoint_mem_standardChart
          (r + 1) Omega 0⟩⟩
  rw [mapLinearSubst_functionFieldMap_projectiveGeneral_standardChart]
  rw [awayMap_linearSubst_normalizedCoordinate]
  rw [projectiveGeneralFunctionFieldEquiv_chartDehomogenization
    r L0 hL0]
  rw [projectiveGeneralFunctionFieldEquiv_chartDehomogenization
    r Li hLi]
  change
    (ProjectiveSpectrum.Proj.structureSheaf
        (MvPolynomial.homogeneousSubmodule
          (Fin ((r + 1) + 1)) Omega)).presheaf.germ
        (AlgebraicGeometry.Proj.basicOpen
          (MvPolynomial.homogeneousSubmodule
            (Fin ((r + 1) + 1)) Omega) L0)
        eta hetaL0
        ((AlgebraicGeometry.Proj.awayToSection
          (MvPolynomial.homogeneousSubmodule
            (Fin ((r + 1) + 1)) Omega) L0)
          (HomogeneousLocalization.Away.mk
            (MvPolynomial.homogeneousSubmodule
              (Fin ((r + 1) + 1)) Omega)
            hL0 1 Li (by simpa using hLi))) *
      (ProjectiveSpectrum.Proj.structureSheaf
        (MvPolynomial.homogeneousSubmodule
          (Fin ((r + 1) + 1)) Omega)).presheaf.germ
        (AlgebraicGeometry.Proj.basicOpen
          (MvPolynomial.homogeneousSubmodule
            (Fin ((r + 1) + 1)) Omega)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
        eta heta0
        ((AlgebraicGeometry.Proj.awayToSection
          (MvPolynomial.homogeneousSubmodule
            (Fin ((r + 1) + 1)) Omega)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
          (HomogeneousLocalization.Away.mk
            (MvPolynomial.homogeneousSubmodule
              (Fin ((r + 1) + 1)) Omega)
            (MvPolynomial.isHomogeneous_X Omega
              (0 : Fin ((r + 1) + 1)))
            1 L0 (by simpa using hL0))) =
      (ProjectiveSpectrum.Proj.structureSheaf
        (MvPolynomial.homogeneousSubmodule
          (Fin ((r + 1) + 1)) Omega)).presheaf.germ
        (AlgebraicGeometry.Proj.basicOpen
          (MvPolynomial.homogeneousSubmodule
            (Fin ((r + 1) + 1)) Omega)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
        eta heta0
        ((AlgebraicGeometry.Proj.awayToSection
          (MvPolynomial.homogeneousSubmodule
            (Fin ((r + 1) + 1)) Omega)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
          (HomogeneousLocalization.Away.mk
            (MvPolynomial.homogeneousSubmodule
              (Fin ((r + 1) + 1)) Omega)
            (MvPolynomial.isHomogeneous_X Omega
              (0 : Fin ((r + 1) + 1)))
            1 Li (by simpa using hLi)))
  exact awayToSection_germ_linear_ratio_mul
    (r + 1) L0 Li hL0 hLi eta hetaL0 heta0

set_option backward.isDefEq.respectTransparency false in
/-- The transformed zeroth row gives a unit in the generic function field.
This is the precise nonvanishing input needed to divide the cross-multiplied
projective-coordinate formula. -/
theorem mapLinearSubst_projectiveGeneral_transformedZero_isUnit
    (r : ℕ)
    (M N : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (hNM : N * M = 1)
    [IsDominant (mapLinearSubst (r + 1) M N hNM)] :
    IsUnit (projectiveGeneralFunctionFieldEquiv r Omega
      (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
        (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
        (ProjectiveSpace.chartDehomogenization (r + 1) Omega 0
          ((linearSubstGradedRingHom (r + 1) M)
            (MvPolynomial.X (0 : Fin ((r + 1) + 1))))))) := by
  let X := ProjectiveSpace (r + 1) Omega
  let eta := genericPoint X
  let L0 := (linearSubstGradedRingHom (r + 1) M)
    (MvPolynomial.X (0 : Fin ((r + 1) + 1)))
  have hL0 : L0 ∈ MvPolynomial.homogeneousSubmodule
      (Fin ((r + 1) + 1)) Omega 1 := by
    exact (linearSubstGradedRingHom (r + 1) M).map_mem
      (MvPolynomial.isHomogeneous_X Omega (0 : Fin ((r + 1) + 1)))
  have hetaL0 : eta ∈ AlgebraicGeometry.Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega) L0 := by
    change (mapLinearSubst (r + 1) M N hNM) eta ∈
      ProjectiveSpace.standardChart (r + 1) Omega 0
    rw [(mapLinearSubst (r + 1) M N hNM).map_genericPoint_of_isDominant]
    exact ((genericPoint_spec X).mem_open_set_iff
      (ProjectiveSpace.standardChart (r + 1) Omega 0).isOpen).mpr
      ⟨ProjectiveSpace.genericPoint (r + 1) Omega,
        ⟨Set.mem_univ _, ProjectiveSpace.genericPoint_mem_standardChart
          (r + 1) Omega 0⟩⟩
  have heta0 : eta ∈ AlgebraicGeometry.Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
      (MvPolynomial.X (0 : Fin ((r + 1) + 1))) := by
    exact ((genericPoint_spec X).mem_open_set_iff
      (ProjectiveSpace.standardChart (r + 1) Omega 0).isOpen).mpr
      ⟨ProjectiveSpace.genericPoint (r + 1) Omega,
        ⟨Set.mem_univ _, ProjectiveSpace.genericPoint_mem_standardChart
          (r + 1) Omega 0⟩⟩
  rw [projectiveGeneralFunctionFieldEquiv_chartDehomogenization r L0 hL0]
  exact awayToSection_germ_standard_linear_ratio_isUnit
    (r + 1) L0 hL0 eta hetaL0 heta0

/-- Pullback of a normalized projective coordinate as the expected quotient
of the dehomogenized transformed matrix rows. -/
theorem mapLinearSubst_functionFieldMap_projectiveGeneral_normalized
    (r : ℕ)
    (M N : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (hNM : N * M = 1)
    [IsDominant (mapLinearSubst (r + 1) M N hNM)]
    (i : Fin ((r + 1) + 1)) :
    let e := projectiveGeneralFunctionFieldEquiv r Omega
    let K := FractionRing (MvPolynomial (Fin (r + 1)) Omega)
    (mapLinearSubst (r + 1) M N hNM).functionFieldMap
        (e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
          (ProjectiveSpace.standardChartRingEquivMvPolynomial
            (r + 1) Omega 0
            (ProjectiveSpace.normalizedCoordinate
              (r + 1) Omega 0 i)))) =
      e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
          (ProjectiveSpace.chartDehomogenization (r + 1) Omega 0
            (linearSubst (r + 1) M i))) /
        e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
          (ProjectiveSpace.chartDehomogenization (r + 1) Omega 0
            (linearSubst (r + 1) M 0))) := by
  dsimp only
  have hunit := mapLinearSubst_projectiveGeneral_transformedZero_isUnit
    r M N hNM
  have hunit' : IsUnit (projectiveGeneralFunctionFieldEquiv r Omega
      (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
        (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
        (ProjectiveSpace.chartDehomogenization (r + 1) Omega 0
          (linearSubst (r + 1) M 0)))) := by
    simpa only [linearSubstGradedRingHom_X] using hunit
  apply (eq_div_iff hunit'.ne_zero).mpr
  simpa only [linearSubstGradedRingHom_X] using
    (mapLinearSubst_functionFieldMap_projectiveGeneral_normalized_mul
      r M N hNM i)

/-- Generator form of the preceding theorem: the `j`-th affine coordinate
pulls back to matrix row `0.succAbove j` divided by row zero. -/
public theorem mapLinearSubst_functionFieldMap_projectiveGeneral_X
    (r : ℕ)
    (M N : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (hNM : N * M = 1)
    [IsDominant (mapLinearSubst (r + 1) M N hNM)]
    (j : Fin (r + 1)) :
    let e := projectiveGeneralFunctionFieldEquiv r Omega
    let K := FractionRing (MvPolynomial (Fin (r + 1)) Omega)
    (mapLinearSubst (r + 1) M N hNM).functionFieldMap
        (e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
          (MvPolynomial.X j))) =
      e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
          (ProjectiveSpace.chartDehomogenization (r + 1) Omega 0
            (linearSubst (r + 1) M
              ((0 : Fin ((r + 1) + 1)).succAbove j)))) /
        e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
          (ProjectiveSpace.chartDehomogenization (r + 1) Omega 0
            (linearSubst (r + 1) M 0))) := by
  simpa only
    [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
    using mapLinearSubst_functionFieldMap_projectiveGeneral_normalized
      r M N hNM ((0 : Fin ((r + 1) + 1)).succAbove j)

end V14Formalization.SchemeGeometry
