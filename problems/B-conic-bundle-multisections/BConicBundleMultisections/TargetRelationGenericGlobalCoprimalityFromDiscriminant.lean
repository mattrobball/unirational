/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GenericCubicNondegeneracy
public import BConicBundleMultisections.MvPolynomialFractionFieldDivisibility
public import BConicBundleMultisections.ProjectiveGenericChartFractionRing
public import BConicBundleMultisections.TargetRelationDiscriminantGenericConic
public import BConicBundleMultisections.TargetRelationGenericFiberGlobalCoprimality

/-!
# Generic target-relation coprimality from the conic discriminant

For an irreducible positive-degree homogeneous target relation `H`, avoiding the
second-conic discriminant implies the single global coprimality condition over
the generic first-plane residue field.  This discharges the algebraic input of
`targetRelation_genericFiber_isLocallyArtinian_of_globalCoprimality`.

The key source calculation identifies the block-swapped affine first-chart
equation with a dehomogenization of the universal second conic.  Thus a
divisibility by `H` would make that dehomogenization zero modulo `H`.  Since the
generic conic is a nonzero homogeneous quadratic under the discriminant
hypothesis, injectivity of homogeneous dehomogenization gives a contradiction.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section
universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace MvPolynomialFractionRing

attribute [local instance] MvPolynomial.algebraMvPolynomial
attribute [local instance] MvPolynomial.gradedAlgebra

/-- Purely transcendental coefficient extension preserves irreducibility for
any implementation of the fraction field. -/
theorem irreducible_map_of_isFractionRing_mvPolynomial_coefficients
    {k : Type u} {σ τ : Type*} {K : Type*}
    [Field k] [Field K]
    [Algebra (MvPolynomial σ k) K]
    [IsFractionRing (MvPolynomial σ k) K]
    [Algebra k K] [IsScalarTower k (MvPolynomial σ k) K]
    (H : MvPolynomial τ k) (hH : Irreducible H) :
    Irreducible (H.map (algebraMap k K)) := by
  let P := MvPolynomial σ k
  let K₀ := FractionRing P
  let e : K₀ ≃ₐ[P] K :=
    IsLocalization.algEquiv (nonZeroDivisors P) K₀ K
  have h₀ : Irreducible (H.map (algebraMap k K₀)) :=
    MvPolynomial.irreducible_map_fractionRing_mvPolynomial H hH
  have he : Irreducible
      ((H.map (algebraMap k K₀)).map e.toRingHom) := by
    simpa using h₀.map (MvPolynomial.mapEquiv τ e.toRingEquiv)
  have hmap : (H.map (algebraMap k K₀)).map e.toRingHom =
      H.map (algebraMap k K) := by
    rw [MvPolynomial.map_map]
    apply congrArg (fun f : k →+* K ↦ H.map f)
    apply RingHom.ext
    intro a
    change e (algebraMap k K₀ a) = algebraMap k K a
    rw [IsScalarTower.algebraMap_apply k P K₀,
      IsScalarTower.algebraMap_apply k P K]
    exact e.commutes (algebraMap k P a)
  rwa [hmap] at he

set_option maxHeartbeats 800000 in
-- The induction unfolds two nested multivariate-polynomial transformations.
/-- Swapping the affine first-chart equation identifies it with the corresponding
dehomogenization of the universal second conic. -/
theorem commAlgEquiv_genericFstCubicChart
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3) :
    MvPolynomial.commAlgEquiv k (Fin 3) (Fin 2)
        (genericFstCubicChart F i) =
      ProjectiveSpace.chartDehomogenization 2 (MvPolynomial (Fin 3) k) i
        (universalSndConic F) := by
  induction F using MvPolynomial.induction_on with
  | C a => simp [genericFstCubicChart, universalSndConic]
  | add P Q hP hQ =>
      rw [show genericFstCubicChart (P + Q) i =
          genericFstCubicChart P i + genericFstCubicChart Q i by
            simp [genericFstCubicChart],
        show universalSndConic (P + Q) = universalSndConic P + universalSndConic Q by
          simp [universalSndConic]]
      rw [map_add, map_add, hP, hQ]
  | mul_X P z hP =>
      rcases z with x | y
      · rw [show genericFstCubicChart (P * MvPolynomial.X (Sum.inl x)) i =
            genericFstCubicChart P i *
              MvPolynomial.C (chartSubst (K := k) i x) by
            simp [genericFstCubicChart],
          show universalSndConic (P * MvPolynomial.X (Sum.inl x)) =
              universalSndConic P * MvPolynomial.X x by
            simp [universalSndConic]]
        rw [map_mul, map_mul, hP]
        rcases Fin.eq_self_or_eq_succAbove i x with rfl | ⟨r, rfl⟩
        · simp
        · simp
      · rw [show genericFstCubicChart (P * MvPolynomial.X (Sum.inr y)) i =
            genericFstCubicChart P i * MvPolynomial.X y by
            simp [genericFstCubicChart],
          show universalSndConic (P * MvPolynomial.X (Sum.inr y)) =
              universalSndConic P * MvPolynomial.C (MvPolynomial.X y) by
            simp [universalSndConic]]
        rw [map_mul, map_mul, hP]
        simp

/-- If `H` avoids the conic discriminant, it cannot divide the first-projection
equation over any affine first chart. -/
theorem not_dvd_genericFstCubicChart_of_not_dvd_discriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (H : MvPolynomial (Fin 3) k) (hH : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F) (i : Fin 3) :
    ¬ MvPolynomial.map (MvPolynomial.C : k →+* MvPolynomial (Fin 2) k) H ∣
      genericFstCubicChart F i := by
  let Ry := MvPolynomial (Fin 3) k
  let A := Ry ⧸ Ideal.span ({H} : Set Ry)
  let L := FractionRing A
  letI : IsDomain A := isDomain_targetRelationCone hH
  let π : Ry →+* A := Ideal.Quotient.mk (Ideal.span ({H} : Set Ry))
  let φ : Ry →+* L := (algebraMap A L).comp π
  letI : Algebra Ry L := φ.toAlgebra
  intro hdvd
  have hswap : MvPolynomial.C H ∣
      ProjectiveSpace.chartDehomogenization 2 Ry i (universalSndConic F) := by
    obtain ⟨c, hc⟩ := hdvd
    refine ⟨MvPolynomial.commAlgEquiv k (Fin 3) (Fin 2) c, ?_⟩
    have hmapped := congrArg
      (MvPolynomial.commAlgEquiv k (Fin 3) (Fin 2)) hc
    simpa [MvPolynomial.commAlgEquiv_map_C,
      commAlgEquiv_genericFstCubicChart] using hmapped
  have hchartmap :
      MvPolynomial.map φ
          (ProjectiveSpace.chartDehomogenization 2 Ry i (universalSndConic F)) = 0 := by
    obtain ⟨c, hc⟩ := hswap
    rw [hc, map_mul]
    have hφH : φ H = 0 := by
      change algebraMap A L (π H) = 0
      rw [show π H = 0 by
        apply Ideal.Quotient.eq_zero_iff_mem.mpr
        exact Ideal.subset_span (Set.mem_singleton H)]
      exact map_zero _
    simp [hφH]
  let Q : MvPolynomial (Fin 3) L :=
    MvPolynomial.map (algebraMap A L) (universalSndConicModulo F H)
  have hQdef : Q = MvPolynomial.map φ (universalSndConic F) := by
    simp [Q, universalSndConicModulo, φ, π, MvPolynomial.map_map]
    rfl
  obtain ⟨hQhom, hQ0, _⟩ :=
    universalSndConicModulo_fraction_nonsingular_of_irreducible_not_dvd_discriminant
      F hF H hH hdisc
  have hchartQ : ProjectiveSpace.chartDehomogenization 2 L i Q = 0 := by
    rw [hQdef]
    change ProjectiveSpace.chartDehomogenization 2 L i
      (MvPolynomial.map (algebraMap Ry L) (universalSndConic F)) = 0
    rw [chartDehomogenization_map]
    have hφalg : algebraMap Ry L = φ := rfl
    rw [hφalg]
    exact hchartmap
  exact hQ0
    (ProjectiveSpace.chartDehomogenization_eq_zero_of_isHomogeneous
      2 i 2 Q hQhom hchartQ)

namespace BiprojectiveSpace

/-- The affine first-chart polynomial maps exactly to the first residue-fibre
polynomial at the scheme-theoretic generic point. -/
theorem map_genericFstCubicChart_standardChartResidueRingHom
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3) :
    let X := ProjectiveSpace 2 k
    let η := _root_.genericPoint X
    let hη := schemeGenericPoint_mem_standardChart k i
    let R := ProjectiveSpace.StandardChartRing 2 k i
    let P := MvPolynomial (Fin 2) k
    let ρR := ProjectiveSpace.standardChartResidueRingHom 2 k η i hη
    let E := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i
    let ρP : P →+* X.residueField η := ρR.comp E.symm.toRingHom
    MvPolynomial.map ρP (genericFstCubicChart F i) =
      fstResidueFiberPolynomial F η i hη := by
  dsimp only
  let X := ProjectiveSpace 2 k
  let η := _root_.genericPoint X
  let hη := schemeGenericPoint_mem_standardChart k i
  let R := ProjectiveSpace.StandardChartRing 2 k i
  let P := MvPolynomial (Fin 2) k
  let ρR := ProjectiveSpace.standardChartResidueRingHom 2 k η i hη
  let E := ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i
  let ρP : P →+* X.residueField η := ρR.comp E.symm.toRingHom
  letI : Algebra k (X.residueField η) :=
    ProjectiveSpace.residueAlgebra 2 k η
  have hcoeff : ρP.comp (MvPolynomial.C : k →+* P) =
      ProjectiveSpace.residueCoefficientMap 2 k η := by
    apply RingHom.ext
    intro a
    change ρR (E.symm (MvPolynomial.C a)) =
      ProjectiveSpace.residueCoefficientMap 2 k η a
    rw [show E.symm (MvPolynomial.C a) = algebraMap k R a by
      exact E.symm.commutes a]
    exact DFunLike.congr_fun
      (ProjectiveSpace.standardChartResidueRingHom_comp_standardChartRingHom
        2 k η i hη) a
  have hE (l : Fin 3) :
      E (ProjectiveSpace.normalizedCoordinate 2 k i l) =
        chartSubst (K := k) i l := by
    rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
    · simp
    · simpa [E] using
        (ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove
          2 k i r)
  have hcoords : (fun l => ρP (chartSubst (K := k) i l)) =
      ProjectiveSpace.normalizedResidueCoordinates 2 k η i hη := by
    funext l
    change ρR (E.symm (chartSubst (K := k) i l)) =
      ρR (ProjectiveSpace.normalizedCoordinate 2 k i l)
    congr 1
    exact E.symm_apply_eq.mpr (hE l).symm
  rw [MvPolynomialFractionRing.map_genericFstCubicChart]
  unfold fstResidueFiberPolynomial
  rw [hcoords, hcoeff]

/-- The discriminant-avoidance hypothesis supplies exactly the homogeneous
global-coprimality input used by the generic-fibre Artinian theorem. -/
theorem hasTargetRelationFstFiberGlobalCoprimality_generic_of_not_dvd_discriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hHhom : H.IsHomogeneous d) (hd : 0 < d) (hH : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F) (i : Fin 3) :
    HasTargetRelationFstFiberGlobalCoprimality F H
      (_root_.genericPoint (ProjectiveSpace 2 k)) i
      (schemeGenericPoint_mem_standardChart k i) := by
  let X := ProjectiveSpace 2 k
  let η := _root_.genericPoint X
  let hη := schemeGenericPoint_mem_standardChart k i
  let R := ProjectiveSpace.StandardChartRing 2 k i
  let P := MvPolynomial (Fin 2) k
  let K := X.residueField η
  let ρR : R →+* K :=
    ProjectiveSpace.standardChartResidueRingHom 2 k η i hη
  let E : R ≃ₐ[k] P :=
    ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i
  let ρP : P →+* K := ρR.comp E.symm.toRingHom
  letI : Algebra R K := ρR.toAlgebra
  letI : IsFractionRing R K :=
    standardChartResidueRingHom_isFractionRing_generic k i
  letI : Algebra P K := ρP.toAlgebra
  letI : IsFractionRing P K := by
    exact (IsFractionRing.isFractionRing_iff_of_base_ringEquiv K E.toRingEquiv).mp
      inferInstance
  letI : Algebra k K := ProjectiveSpace.residueAlgebra 2 k η
  have hcoeff : ρP.comp (MvPolynomial.C : k →+* P) =
      ProjectiveSpace.residueCoefficientMap 2 k η := by
    apply RingHom.ext
    intro a
    change ρR (E.symm (MvPolynomial.C a)) =
      ProjectiveSpace.residueCoefficientMap 2 k η a
    rw [show E.symm (MvPolynomial.C a) = algebraMap k R a by
      exact E.symm.commutes a]
    exact DFunLike.congr_fun
      (ProjectiveSpace.standardChartResidueRingHom_comp_standardChartRingHom
        2 k η i hη) a
  letI : IsScalarTower k P K := by
    apply IsScalarTower.of_algebraMap_eq'
    exact hcoeff.symm
  constructor
  · change Irreducible (H.map (algebraMap k K))
    exact irreducible_map_of_isFractionRing_mvPolynomial_coefficients
      (σ := Fin 2) H hH
  · intro hdvd
    have hmapped :
        MvPolynomial.map (algebraMap P K)
            (MvPolynomial.map (MvPolynomial.C : k →+* P) H) ∣
          MvPolynomial.map (algebraMap P K) (genericFstCubicChart F i) := by
      have hρPalg : algebraMap P K = ρP := rfl
      rw [hρPalg, MvPolynomial.map_map, hcoeff,
        map_genericFstCubicChart_standardChartResidueRingHom]
      exact hdvd
    have hprimeH :
        (Ideal.span ({H} : Set (MvPolynomial (Fin 3) k))).IsPrime :=
      (Ideal.span_singleton_prime hH.ne_zero).mpr hH.prime
    have hprime := isPrime_span_map_coefficients_of_prime
      (σ := Fin 2) H hprimeH
    have hdisj :=
      disjoint_nonZeroDivisors_map_C_span_map_coefficients_of_homogeneous
        (σ := Fin 2) H hHhom hd
    have hsource := dvd_of_map_dvd_map_of_isFractionRing
      hprime hdisj hmapped
    exact (not_dvd_genericFstCubicChart_of_not_dvd_discriminant
      F hF H hH hdisc i) hsource

/-- Direct generic-fibre endpoint: discriminant avoidance implies the target
relation fibre over the generic first-plane point is locally Artinian. -/
theorem targetRelation_genericFiber_isLocallyArtinian_of_irreducible_not_dvd_discriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hHhom : H.IsHomogeneous d) (hd : 0 < d) (hH : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F) (i : Fin 3) :
    IsLocallyArtinian
      ((targetRelationToFirst F H).fiber
        (_root_.genericPoint (ProjectiveSpace 2 k))) := by
  exact targetRelation_genericFiber_isLocallyArtinian_of_globalCoprimality
    F H hF hHhom i
      (hasTargetRelationFstFiberGlobalCoprimality_generic_of_not_dvd_discriminant
        F hF H hHhom hd hH hdisc i)

end BiprojectiveSpace

end
end BConicBundleMultisections
