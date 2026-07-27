/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.IntegralOpenCover
public import BConicBundleMultisections.ResidualTargetRelationGeometry
public import BConicBundleMultisections.TargetRelationChartDomain
public import BConicBundleMultisections.TargetRelationGenericFiberArtinian

/-!
# Integral target relations away from the discriminant

For an irreducible positive-degree homogeneous equation `H` in the second projective plane,
retain precisely the nonempty standard charts of `V(H)`.  Every product chart of the target
relation above a retained base chart is the spectrum of a domain.  The generic point of any
one retained chart lies in every other retained chart: first-block coordinates remain nonzero
by nonsingularity of the generic conic, and second-block coordinates remain nonzero by
irreducibility of `H`.  The retained charts therefore form a pairwise-overlapping integral open
cover of the whole target relation.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry CommRingCat

attribute [local instance] MvPolynomial.gradedAlgebra

namespace BiprojectiveSpace

variable {m n : ℕ} {R : Type u} [CommRing R]
variable {i : Fin (m + 1)} {j : Fin (n + 1)}

/-! ## The second projection of an explicit two-equation chart -/

/-- The second-factor chart ring maps to the ordinary affine two-equation quotient. -/
def twoEquationAffineChartQuotientYHom
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R) :
    ProjectiveSpace.StandardChartRing n R j →+*
      (MvPolynomial (Fin m ⊕ Fin n) R ⧸
        twoEquationAffineChartIdeal m n R i j F G) :=
  ((Ideal.Quotient.mk (twoEquationAffineChartIdeal m n R i j F G)).comp
      (standardChartRingEquivMvPolynomial m n R i j).toRingHom).comp
    (Algebra.TensorProduct.includeRight
      (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
      (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom

set_option backward.isDefEq.respectTransparency false in
/-- Under the explicit affine presentation, projection to the second factor is induced by the
right tensor-factor inclusion followed by the quotient map. -/
theorem twoEquationChartIsoSpecAffineQuotient_hom_snd
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (twoEquationChartIsoSpecAffineQuotient m n R i j F G).hom ≫
        Spec.map (ofHom
          (twoEquationAffineChartQuotientYHom m n R i j F G)) ≫
        ProjectiveSpace.standardChartι n R j =
      (twoEquationChartIdealSheaf m n R i j F G).subschemeι ≫
        standardChartι m n R i j ≫ BiprojectiveSpace.snd m n R := by
  rw [← cancel_epi
    ((twoEquationChartIdealSheaf m n R i j F G).subschemeCover.f
      (chartTopAffineOpen m n R i j))]
  rw [← Category.assoc,
    twoEquationChartSubschemeCover_comp_isoSpecAffineQuotient]
  rw [← Category.assoc, ← Spec.map_comp]
  rw [subschemeCover_map_subschemeι_fromSpec]
  rw [← standardChartIsoSpec_hom_snd]
  rw [chartTopAffineOpen_fromSpec_comp_standardChartIsoSpec_assoc]
  simp only [← Spec.map_comp_assoc]
  congr 1
  rw [Spec.map_injective.eq_iff]
  ext b
  change (twoEquationChartQuotientEquivMvPolynomial m n R i j F G).symm
      (twoEquationAffineChartQuotientYHom m n R i j F G b) =
    Ideal.Quotient.mk _ ((standardChartΓIso m n R i j).inv
      (Algebra.TensorProduct.includeRight
        (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
        (B := ProjectiveSpace.StandardChartRing n R j) b))
  apply (twoEquationChartQuotientEquivMvPolynomial m n R i j F G).injective
  rw [RingEquiv.apply_symm_apply]
  unfold twoEquationChartQuotientEquivMvPolynomial
  rw [Ideal.quotientEquiv_mk]
  have h : chartSectionsEquivMvPolynomial m n R i j
      ((standardChartΓIso m n R i j).inv
        (Algebra.TensorProduct.includeRight
          (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j) b)) =
      standardChartRingEquivMvPolynomial m n R i j
        (Algebra.TensorProduct.includeRight
          (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j) b) := by
    unfold chartSectionsEquivMvPolynomial
    change standardChartRingEquivMvPolynomial m n R i j
      ((standardChartΓIso m n R i j).hom
        ((standardChartΓIso m n R i j).inv
          (Algebra.TensorProduct.includeRight
            (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
            (B := ProjectiveSpace.StandardChartRing n R j) b))) = _
    rw [Iso.inv_hom_id_apply]
  rw [h]
  rfl

/-! ## Retained affine target-relation charts -/

/-- The explicit ordinary-polynomial coordinate ring of a target-relation product chart. -/
abbrev TargetRelationAffineChartQuotient
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) (i j : Fin 3) :=
  MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸
    twoEquationAffineChartIdeal 2 2 k i j F
      (MvPolynomial.rename
        (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H)

/-- Every product chart lying above a nonempty chart of the irreducible relation curve has a
domain as its explicit coordinate ring. -/
theorem isDomain_targetRelationAffineChartQuotient
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : Fin 3)
    (hnonempty : ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 k j H))
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i : Fin 3) :
    IsDomain (TargetRelationAffineChartQuotient F H i j) := by
  exact (Ideal.Quotient.isDomain_iff_prime
    (twoEquationAffineChartIdeal 2 2 k i j F
      (MvPolynomial.rename Sum.inr H))).mpr
    (isPrime_twoEquationAffineChartIdeal_targetRelation
      F hF hF0 H hH hHirr j hnonempty hdisc i)

/-- Every normalized first-factor coordinate is nonzero in a retained target-relation chart. -/
theorem quotient_affineChartVariable_inl_ne_zero_targetRelation
    {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : Fin 3)
    (hnonempty : ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 k j H))
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i l : Fin 3) :
    Ideal.Quotient.mk
        (twoEquationAffineChartIdeal 2 2 k i j F
          (MvPolynomial.rename Sum.inr H))
        (affineChartVariable 2 2 k i j (.inl l)) ≠ 0 := by
  letI : IsDomain (TargetRelationAffineChartQuotient F H i j) :=
    isDomain_targetRelationAffineChartQuotient
      F hF hF0 H hH hHirr j hnonempty hdisc i
  rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
  · simpa [affineChartVariable] using
      (one_ne_zero : (1 : TargetRelationAffineChartQuotient F H i j) ≠ 0)
  · simpa [affineChartVariable] using
      quotient_X_inl_ne_zero_twoEquationAffineChartIdeal_targetRelation
        F hF hF0 H hH hHirr j hnonempty hdisc i r

/-- Every normalized coordinate belonging to another retained second-factor chart is nonzero in
the source target-relation chart. -/
theorem quotient_affineChartVariable_inr_ne_zero_targetRelation
    {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i : Fin 3) (j' : ProjectiveSpace.NonemptyHypersurfaceChart H) :
    Ideal.Quotient.mk
        (twoEquationAffineChartIdeal 2 2 k i j.1 F
          (MvPolynomial.rename Sum.inr H))
        (affineChartVariable 2 2 k i j.1 (.inr j'.1)) ≠ 0 := by
  letI : IsDomain (TargetRelationAffineChartQuotient F H i j.1) :=
    isDomain_targetRelationAffineChartQuotient
      F hF hF0 H hH hHirr j.1 j.2 hdisc i
  rcases Fin.eq_self_or_eq_succAbove j.1 j'.1 with heq | ⟨s, hs⟩
  · rw [heq]
    simpa [affineChartVariable] using
      (one_ne_zero : (1 : TargetRelationAffineChartQuotient F H i j.1) ≠ 0)
  · have hnotdvd : ¬ H ∣ MvPolynomial.X (j.1.succAbove s) := by
      simpa [hs] using
        (ProjectiveSpace.not_dvd_X_of_not_isUnit_chartDehomogenization
          H hHirr j'.1 j'.2)
    simpa [affineChartVariable, hs] using
      quotient_X_inr_ne_zero_twoEquationAffineChartIdeal_targetRelation
        F hF hF0 H hH hHirr j.1 j.2 hdisc i s hnotdvd

/-- The generic point of an explicit retained affine target-relation chart. -/
noncomputable def targetRelationAffineChartGenericPoint
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : Fin 3)
    (hnonempty : ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 k j H))
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i : Fin 3) :
    Spec (.of (TargetRelationAffineChartQuotient F H i j)) := by
  letI : IsDomain (TargetRelationAffineChartQuotient F H i j) :=
    isDomain_targetRelationAffineChartQuotient
      F hF hF0 H hH hHirr j hnonempty hdisc i
  exact genericPoint _

/-! ## Generic points meet every retained ambient chart -/

/-- Under the first-factor chart map, a retained target-relation chart's generic point lies in
every projective standard chart. -/
theorem targetRelationAffineChartGenericPoint_fst_mem_standardChart_range
    {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i i' : Fin 3) :
    (ProjectiveSpace.standardChartι 2 k i).base
      ((Spec.map (ofHom
        (twoEquationAffineChartQuotientXHom 2 2 k i j.1 F
          (MvPolynomial.rename Sum.inr H)))).base
        (targetRelationAffineChartGenericPoint
          F hF hF0 H hH hHirr j.1 j.2 hdisc i)) ∈
      Set.range (ProjectiveSpace.standardChartι 2 k i') := by
  let G := MvPolynomial.rename
    (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H
  let A := TargetRelationAffineChartQuotient F H i j.1
  letI : IsDomain A := isDomain_targetRelationAffineChartQuotient
    F hF hF0 H hH hHirr j.1 j.2 hdisc i
  let phi : ProjectiveSpace.StandardChartRing 2 k i →+* A :=
    twoEquationAffineChartQuotientXHom 2 2 k i j.1 F G
  let eta := targetRelationAffineChartGenericPoint
    F hF hF0 H hH hHirr j.1 j.2 hdisc i
  change (ProjectiveSpace.standardChartι 2 k i).base
      ((Spec.map (ofHom phi)).base eta) ∈ _
  rw [← Scheme.Hom.coe_opensRange,
    ProjectiveSpace.opensRange_standardChartι]
  change (Spec.map (ofHom phi)).base eta ∈
    ((ProjectiveSpace.standardChartι 2 k i) ⁻¹ᵁ
      ProjectiveSpace.standardChart 2 k i' :
        (Spec (.of (ProjectiveSpace.StandardChartRing 2 k i))).Opens)
  change (Spec.map (ofHom phi)).base eta ∈
    (Proj.awayι _ (MvPolynomial.X i)
        (MvPolynomial.isHomogeneous_X k i) zero_lt_one ⁻¹ᵁ
      Proj.basicOpen _ (MvPolynomial.X i'))
  have hXi : MvPolynomial.X i ∈
      MvPolynomial.homogeneousSubmodule (Fin 3) k 1 := by
    simpa using MvPolynomial.isHomogeneous_X k i
  have hXi' : MvPolynomial.X i' ∈
      MvPolynomial.homogeneousSubmodule (Fin 3) k 1 := by
    simpa using MvPolynomial.isHomogeneous_X k i'
  rw [Proj.awayι_preimage_basicOpen
    (MvPolynomial.homogeneousSubmodule (Fin 3) k)
    hXi zero_lt_one hXi' zero_lt_one]
  change PrimeSpectrum.comap phi eta ∈
    PrimeSpectrum.basicOpen
      (HomogeneousLocalization.Away.isLocalizationElem hXi hXi')
  rw [PrimeSpectrum.mem_basicOpen]
  rw [away_isLocalizationElem_X_eq_normalizedCoordinate]
  intro hmem
  rw [PrimeSpectrum.comap_asIdeal] at hmem
  have heta : eta = (⊥ : PrimeSpectrum A) := by
    change targetRelationAffineChartGenericPoint
      F hF hF0 H hH hHirr j.1 j.2 hdisc i = _
    unfold targetRelationAffineChartGenericPoint
    exact genericPoint_eq_bot_of_affine (.of A)
  have heqzero : phi (ProjectiveSpace.normalizedCoordinate 2 k i i') = 0 := by
    simpa [heta] using hmem
  have hcoord :
      phi (ProjectiveSpace.normalizedCoordinate 2 k i i') =
        Ideal.Quotient.mk
          (twoEquationAffineChartIdeal 2 2 k i j.1 F G)
          (affineChartVariable 2 2 k i j.1 (.inl i')) := by
    change Ideal.Quotient.mk _
      (standardChartRingEquivMvPolynomial 2 2 k i j.1
        (ProjectiveSpace.normalizedCoordinate 2 k i i' ⊗ₜ[k] 1)) = _
    rw [← chartVariable_inl,
      standardChartRingEquivMvPolynomial_chartVariable]
  rw [hcoord] at heqzero
  exact quotient_affineChartVariable_inl_ne_zero_targetRelation
    F hF hF0 H hH hHirr j.1 j.2 hdisc i i' heqzero

/-- Under the second-factor chart map, a retained target-relation chart's generic point lies in
every other retained projective standard chart. -/
theorem targetRelationAffineChartGenericPoint_snd_mem_standardChart_range
    {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i : Fin 3) (j' : ProjectiveSpace.NonemptyHypersurfaceChart H) :
    (ProjectiveSpace.standardChartι 2 k j.1).base
      ((Spec.map (ofHom
        (twoEquationAffineChartQuotientYHom 2 2 k i j.1 F
          (MvPolynomial.rename Sum.inr H)))).base
        (targetRelationAffineChartGenericPoint
          F hF hF0 H hH hHirr j.1 j.2 hdisc i)) ∈
      Set.range (ProjectiveSpace.standardChartι 2 k j'.1) := by
  let G := MvPolynomial.rename
    (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H
  let A := TargetRelationAffineChartQuotient F H i j.1
  letI : IsDomain A := isDomain_targetRelationAffineChartQuotient
    F hF hF0 H hH hHirr j.1 j.2 hdisc i
  let phi : ProjectiveSpace.StandardChartRing 2 k j.1 →+* A :=
    twoEquationAffineChartQuotientYHom 2 2 k i j.1 F G
  let eta := targetRelationAffineChartGenericPoint
    F hF hF0 H hH hHirr j.1 j.2 hdisc i
  change (ProjectiveSpace.standardChartι 2 k j.1).base
      ((Spec.map (ofHom phi)).base eta) ∈ _
  rw [← Scheme.Hom.coe_opensRange,
    ProjectiveSpace.opensRange_standardChartι]
  change (Spec.map (ofHom phi)).base eta ∈
    ((ProjectiveSpace.standardChartι 2 k j.1) ⁻¹ᵁ
      ProjectiveSpace.standardChart 2 k j'.1 :
        (Spec (.of (ProjectiveSpace.StandardChartRing 2 k j.1))).Opens)
  change (Spec.map (ofHom phi)).base eta ∈
    (Proj.awayι _ (MvPolynomial.X j.1)
        (MvPolynomial.isHomogeneous_X k j.1) zero_lt_one ⁻¹ᵁ
      Proj.basicOpen _ (MvPolynomial.X j'.1))
  have hXj : MvPolynomial.X j.1 ∈
      MvPolynomial.homogeneousSubmodule (Fin 3) k 1 := by
    simpa using MvPolynomial.isHomogeneous_X k j.1
  have hXj' : MvPolynomial.X j'.1 ∈
      MvPolynomial.homogeneousSubmodule (Fin 3) k 1 := by
    simpa using MvPolynomial.isHomogeneous_X k j'.1
  rw [Proj.awayι_preimage_basicOpen
    (MvPolynomial.homogeneousSubmodule (Fin 3) k)
    hXj zero_lt_one hXj' zero_lt_one]
  change PrimeSpectrum.comap phi eta ∈
    PrimeSpectrum.basicOpen
      (HomogeneousLocalization.Away.isLocalizationElem hXj hXj')
  rw [PrimeSpectrum.mem_basicOpen]
  rw [away_isLocalizationElem_X_eq_normalizedCoordinate]
  intro hmem
  rw [PrimeSpectrum.comap_asIdeal] at hmem
  have heta : eta = (⊥ : PrimeSpectrum A) := by
    change targetRelationAffineChartGenericPoint
      F hF hF0 H hH hHirr j.1 j.2 hdisc i = _
    unfold targetRelationAffineChartGenericPoint
    exact genericPoint_eq_bot_of_affine (.of A)
  have heqzero :
      phi (ProjectiveSpace.normalizedCoordinate 2 k j.1 j'.1) = 0 := by
    simpa [heta] using hmem
  have hcoord :
      phi (ProjectiveSpace.normalizedCoordinate 2 k j.1 j'.1) =
        Ideal.Quotient.mk
          (twoEquationAffineChartIdeal 2 2 k i j.1 F G)
          (affineChartVariable 2 2 k i j.1 (.inr j'.1)) := by
    change Ideal.Quotient.mk _
      (standardChartRingEquivMvPolynomial 2 2 k i j.1
        (1 ⊗ₜ[k] ProjectiveSpace.normalizedCoordinate 2 k j.1 j'.1)) = _
    rw [← chartVariable_inr,
      standardChartRingEquivMvPolynomial_chartVariable]
  rw [hcoord] at heqzero
  exact quotient_affineChartVariable_inr_ne_zero_targetRelation
    F hF hF0 H hH hHirr j hdisc i j' heqzero

/-! ## Global overlap witnesses -/

/-- The image in the global target relation of a retained affine chart's generic point. -/
noncomputable def targetRelationGlobalChartGenericPoint
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i : Fin 3) :
    targetRelationZeroLocus F H :=
  (twoEquationChartToGlobal 2 2 k F
      (MvPolynomial.rename Sum.inr H) hF
      (rename_inr_isBihomogeneous hH) i j.1).base
    ((twoEquationChartIsoSpecAffineQuotient 2 2 k i j.1 F
      (MvPolynomial.rename Sum.inr H)).inv.base
        (targetRelationAffineChartGenericPoint
          F hF hF0 H hH hHirr j.1 j.2 hdisc i))

/-- A retained chart's global generic point belongs to every retained target-relation product
chart. -/
theorem targetRelationGlobalChartGenericPoint_mem_chart_range
    {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i i' : Fin 3) (j' : ProjectiveSpace.NonemptyHypersurfaceChart H) :
    targetRelationGlobalChartGenericPoint
        F hF hF0 H hH hHirr j hdisc i ∈
      Set.range (twoEquationChartToGlobal 2 2 k F
        (MvPolynomial.rename Sum.inr H) hF
        (rename_inr_isBihomogeneous hH) i' j'.1).base := by
  let G := MvPolynomial.rename
    (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H
  let eta := targetRelationAffineChartGenericPoint
    F hF hF0 H hH hHirr j.1 j.2 hdisc i
  let xi := (twoEquationChartIsoSpecAffineQuotient
    2 2 k i j.1 F G).inv.base eta
  rw [range_twoEquationChartToGlobal]
  change (twoEquationBiprojectiveι 2 2 k F G).base
      (targetRelationGlobalChartGenericPoint
        F hF hF0 H hH hHirr j hdisc i) ∈
    Set.range (standardChartι 2 2 k i' j'.1).base
  rw [range_standardChartι]
  refine ⟨?_, ?_⟩
  · change ((twoEquationBiprojectiveι 2 2 k F G ≫
        BiprojectiveSpace.fst 2 2 k).base
          (targetRelationGlobalChartGenericPoint
            F hF hF0 H hH hHirr j hdisc i)) ∈
      Set.range (ProjectiveSpace.standardChartι 2 k i')
    have heq :
        (twoEquationChartIsoSpecAffineQuotient 2 2 k i j.1 F G).hom ≫
            Spec.map (ofHom
              (twoEquationAffineChartQuotientXHom 2 2 k i j.1 F G)) ≫
            ProjectiveSpace.standardChartι 2 k i =
          twoEquationChartToGlobal 2 2 k F G hF
              (rename_inr_isBihomogeneous hH) i j.1 ≫
            twoEquationBiprojectiveι 2 2 k F G ≫
            BiprojectiveSpace.fst 2 2 k := by
      rw [twoEquationChartToGlobal_comp_ι_assoc]
      exact twoEquationChartIsoSpecAffineQuotient_hom_fst
        2 2 k i j.1 F G
    have happ := congrArg
      (fun f :
        (twoEquationChartIdealSheaf 2 2 k i j.1 F G).subscheme ⟶
          ProjectiveSpace 2 k => f.base xi) heq
    have hproj :
        ((twoEquationBiprojectiveι 2 2 k F G ≫
          BiprojectiveSpace.fst 2 2 k).base
            (targetRelationGlobalChartGenericPoint
              F hF hF0 H hH hHirr j hdisc i)) =
          (ProjectiveSpace.standardChartι 2 k i).base
            ((Spec.map (ofHom
              (twoEquationAffineChartQuotientXHom
                2 2 k i j.1 F G))).base eta) := by
      simpa [targetRelationGlobalChartGenericPoint, eta, xi,
        Scheme.Hom.comp_apply] using happ.symm
    rw [hproj]
    exact targetRelationAffineChartGenericPoint_fst_mem_standardChart_range
      F hF hF0 H hH hHirr j hdisc i i'
  · change ((twoEquationBiprojectiveι 2 2 k F G ≫
        BiprojectiveSpace.snd 2 2 k).base
          (targetRelationGlobalChartGenericPoint
            F hF hF0 H hH hHirr j hdisc i)) ∈
      Set.range (ProjectiveSpace.standardChartι 2 k j'.1)
    have heq :
        (twoEquationChartIsoSpecAffineQuotient 2 2 k i j.1 F G).hom ≫
            Spec.map (ofHom
              (twoEquationAffineChartQuotientYHom 2 2 k i j.1 F G)) ≫
            ProjectiveSpace.standardChartι 2 k j.1 =
          twoEquationChartToGlobal 2 2 k F G hF
              (rename_inr_isBihomogeneous hH) i j.1 ≫
            twoEquationBiprojectiveι 2 2 k F G ≫
            BiprojectiveSpace.snd 2 2 k := by
      rw [twoEquationChartToGlobal_comp_ι_assoc]
      exact twoEquationChartIsoSpecAffineQuotient_hom_snd
        2 2 k i j.1 F G
    have happ := congrArg
      (fun f :
        (twoEquationChartIdealSheaf 2 2 k i j.1 F G).subscheme ⟶
          ProjectiveSpace 2 k => f.base xi) heq
    have hproj :
        ((twoEquationBiprojectiveι 2 2 k F G ≫
          BiprojectiveSpace.snd 2 2 k).base
            (targetRelationGlobalChartGenericPoint
              F hF hF0 H hH hHirr j hdisc i)) =
          (ProjectiveSpace.standardChartι 2 k j.1).base
            ((Spec.map (ofHom
              (twoEquationAffineChartQuotientYHom
                2 2 k i j.1 F G))).base eta) := by
      simpa [targetRelationGlobalChartGenericPoint, eta, xi,
        Scheme.Hom.comp_apply] using happ.symm
    rw [hproj]
    exact targetRelationAffineChartGenericPoint_snd_mem_standardChart_range
      F hF hF0 H hH hHirr j hdisc i j'

/-! ## The retained open cover -/

/-- A point of a two-equation product chart certifies that the dehomogenized second equation is
not a unit. -/
theorem not_isUnit_chartDehomogenization_of_twoEquationChartPoint
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) (i j : Fin 3)
    (z : (twoEquationChartIdealSheaf 2 2 k i j F
      (MvPolynomial.rename Sum.inr H)).subscheme) :
    ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 k j H) := by
  intro hunit
  let G := MvPolynomial.rename
    (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H
  let I := twoEquationAffineChartIdeal 2 2 k i j F G
  let q := affineChartEquation 2 2 k i j G
  let e : MvPolynomial (Fin 2 ⊕ Fin 2) k ≃+*
      MvPolynomial (Fin 2) (MvPolynomial (Fin 2) k) :=
    (MvPolynomial.sumAlgEquiv k (Fin 2) (Fin 2)).toRingEquiv
  have hCunit : IsUnit
      (MvPolynomial.C (ProjectiveSpace.chartDehomogenization 2 k j H) :
        MvPolynomial (Fin 2) (MvPolynomial (Fin 2) k)) :=
    hunit.map (MvPolynomial.C :
      MvPolynomial (Fin 2) k →+*
        MvPolynomial (Fin 2) (MvPolynomial (Fin 2) k))
  have heq : e q =
      MvPolynomial.C (ProjectiveSpace.chartDehomogenization 2 k j H) := by
    simpa [e, q, G] using sumAlgEquiv_affineChartEquation_rename_inr H i j
  have hqunit : IsUnit q := by
    apply (isUnit_map_iff e q).mp
    rw [heq]
    exact hCunit
  have hqmem : q ∈ I := by
    exact Ideal.subset_span (by simp [I, q, G, twoEquationAffineChartIdeal])
  have hItop : I = ⊤ := I.eq_top_of_isUnit_mem hqmem hqunit
  let A := MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸ I
  letI : Subsingleton A := Ideal.Quotient.subsingleton_iff.mpr hItop
  have hempty : IsEmpty (PrimeSpectrum A) :=
    PrimeSpectrum.isEmpty_iff_subsingleton.mpr inferInstance
  exact hempty.false
    ((twoEquationChartIsoSpecAffineQuotient 2 2 k i j F G).hom.base z)

/-- The product charts lying above nonempty standard charts of `V(H)` form an open cover of the
whole target relation. -/
noncomputable def targetRelationRetainedOpenCover
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F)
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) :
    (targetRelationZeroLocus F H).OpenCover :=
  Scheme.Cover.mkOfCovers
    (Fin 3 × ProjectiveSpace.NonemptyHypersurfaceChart H)
    (fun ij => (twoEquationChartIdealSheaf 2 2 k ij.1 ij.2.1 F
      (MvPolynomial.rename Sum.inr H)).subscheme)
    (fun ij => twoEquationChartToGlobal 2 2 k
      (dF := 2) (eF := 3) (dG := 0) (eG := d) F
      (MvPolynomial.rename Sum.inr H) hF
      (rename_inr_isBihomogeneous hH) ij.1 ij.2.1)
    (fun x => by
      have hx : (targetRelationι F H).base x ∈
          (⊤ : (BiprojectiveSpace 2 2 k).Opens) := trivial
      rw [← BiprojectiveSpace.iSup_standardChartAffineOpen 2 2 k] at hx
      simp only [TopologicalSpace.Opens.mem_iSup] at hx
      obtain ⟨ij, hij⟩ := hx
      have hambient : (targetRelationι F H).base x ∈
          Set.range (standardChartι 2 2 k ij.1 ij.2).base := by
        have hstd :
            ((standardChartAffineOpen 2 2 k ij.1 ij.2).1 : Set _) =
              Set.range (standardChartι 2 2 k ij.1 ij.2).base := by
          simp [standardChartAffineOpen, Scheme.Hom.coe_opensRange]
        exact hstd ▸ hij
      have hxrange : x ∈ Set.range
          (twoEquationChartToGlobal 2 2 k
            (dF := 2) (eF := 3) (dG := 0) (eG := d) F
            (MvPolynomial.rename Sum.inr H) hF
            (rename_inr_isBihomogeneous hH) ij.1 ij.2).base := by
        rw [range_twoEquationChartToGlobal]
        exact hambient
      obtain ⟨z, hz⟩ := hxrange
      let jj : ProjectiveSpace.NonemptyHypersurfaceChart H :=
        ⟨ij.2,
          not_isUnit_chartDehomogenization_of_twoEquationChartPoint
            F H ij.1 ij.2 z⟩
      exact ⟨(ij.1, jj), z, hz⟩)
    (fun ij => by
      exact twoEquationChartToGlobal_isOpenImmersion
        2 2 k F (MvPolynomial.rename Sum.inr H) hF
          (rename_inr_isBihomogeneous hH) ij.1 ij.2.1)

/-- Every member of the retained target-relation cover is integral. -/
theorem isIntegral_targetRelationRetainedChart
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (ij : Fin 3 × ProjectiveSpace.NonemptyHypersurfaceChart H) :
    IsIntegral ((twoEquationChartIdealSheaf 2 2 k ij.1 ij.2.1 F
      (MvPolynomial.rename Sum.inr H)).subscheme) := by
  letI : IsDomain (TargetRelationAffineChartQuotient F H ij.1 ij.2.1) :=
    isDomain_targetRelationAffineChartQuotient
      F hF hF0 H hH hHirr ij.2.1 ij.2.2 hdisc ij.1
  exact IsIntegral.of_isIso
    (twoEquationChartIsoSpecAffineQuotient 2 2 k ij.1 ij.2.1 F
      (MvPolynomial.rename Sum.inr H)).inv

/-! ## Global integrality -/

/-- The target relation cut out by an irreducible positive-degree relation away from the conic
discriminant is integral. -/
theorem isIntegral_targetRelationZeroLocus_of_smooth_irreducible_awayDiscriminant
    {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hHirr : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F) :
    IsIntegral (targetRelationZeroLocus F H) := by
  let U := targetRelationRetainedOpenCover F hF H hH
  letI : Nonempty (ProjectiveSpace.NonemptyHypersurfaceChart H) :=
    ProjectiveSpace.nonempty_nonemptyHypersurfaceChart H hH hd hHirr
  let j0 : ProjectiveSpace.NonemptyHypersurfaceChart H := Nonempty.some inferInstance
  letI : Nonempty (targetRelationZeroLocus F H) :=
    ⟨targetRelationGlobalChartGenericPoint
      F hF hF0 H hH hHirr j0 hdisc 0⟩
  haveI hUi (ij : U.I₀) : IsIntegral (U.X ij) := by
    change IsIntegral ((twoEquationChartIdealSheaf 2 2 k ij.1 ij.2.1 F
      (MvPolynomial.rename Sum.inr H)).subscheme)
    exact isIntegral_targetRelationRetainedChart
      F hF hF0 H hH hHirr hdisc ij
  apply isIntegral_of_openCover_of_pairwise_nonempty U
  intro a b _hab
  change Fin 3 × ProjectiveSpace.NonemptyHypersurfaceChart H at a b
  intro hdis
  let x := targetRelationGlobalChartGenericPoint
    F hF hF0 H hH hHirr a.2 hdisc a.1
  have hxa : x ∈ (U.f a).opensRange := by
    change x ∈ (twoEquationChartToGlobal 2 2 k F
      (MvPolynomial.rename Sum.inr H) hF
      (rename_inr_isBihomogeneous hH) a.1 a.2.1).opensRange
    exact (show x ∈ Set.range
      (twoEquationChartToGlobal 2 2 k F
        (MvPolynomial.rename Sum.inr H) hF
        (rename_inr_isBihomogeneous hH) a.1 a.2.1).base from
          targetRelationGlobalChartGenericPoint_mem_chart_range
            F hF hF0 H hH hHirr a.2 hdisc a.1 a.1 a.2)
  have hxb : x ∈ (U.f b).opensRange := by
    change x ∈ (twoEquationChartToGlobal 2 2 k F
      (MvPolynomial.rename Sum.inr H) hF
      (rename_inr_isBihomogeneous hH) b.1 b.2.1).opensRange
    exact (show x ∈ Set.range
      (twoEquationChartToGlobal 2 2 k F
        (MvPolynomial.rename Sum.inr H) hF
        (rename_inr_isBihomogeneous hH) b.1 b.2.1).base from
          targetRelationGlobalChartGenericPoint_mem_chart_range
            F hF hF0 H hH hHirr a.2 hdisc a.1 b.1 b.2)
  have hxbot : x ∈ (⊥ : (targetRelationZeroLocus F H).Opens) :=
    hdis.le_bot ⟨hxa, hxb⟩
  exact hxbot

end BiprojectiveSpace

/-- Smooth nonzero bidegree `(2,3)` conic bundles have integral target relations for every
irreducible positive-degree relation away from the discriminant. -/
theorem targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth
    {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 k F)] :
    TargetRelationsProjectivelyIntegralAwayDiscriminant F := by
  intro H d hHabs hH hd hdisc
  exact BiprojectiveSpace.isIntegral_targetRelationZeroLocus_of_smooth_irreducible_awayDiscriminant
    F hF hF0 H hH hd hHabs.irreducible hdisc

end

end BConicBundleMultisections

end
