/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveTwoEquationAffine
public import BConicBundleMultisections.ConicProjectionFlat
public import BConicBundleMultisections.GenericConicDescent
public import BConicBundleMultisections.IrreducibleProjectiveHypersurfaceIntegral
public import BConicBundleMultisections.PrimeSpanPairDescent
public import BConicBundleMultisections.PointedConicOpenDominance
public import BConicBundleMultisections.ResidualTargetNegativeTwistLocal
public import BConicBundleMultisections.TargetRelationChartGenericConic

/-!
# Integral affine charts of a target relation

Let `H` be an irreducible positive-degree homogeneous equation in the second projective
coordinates and suppose that it does not divide the conic discriminant.  On every nonempty
standard chart of `V(H)`, the target relation is a primitive affine conic over the domain
`k[y]/(H)`.  Its generic conic is nonsingular, so flat descent from the fraction field makes the
affine conic ring a domain.  Splitting the two affine variable blocks then identifies that ring
with the explicit two-equation standard-chart quotient.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry
open _root_.MvPolynomial
open PrimitiveHypersurfaceFlatness

attribute [local instance] MvPolynomial.gradedAlgebra

namespace BiprojectiveSpace

variable {k : Type u} [Field k]

/-- The standard projective `y`-chart maps to the affine chart ring of `V(H)`. -/
def standardChartToTargetRelationChart
    (H : MvPolynomial (Fin 3) k) (j : Fin 3) :
    ProjectiveSpace.StandardChartRing 2 k j →ₐ[k]
      targetRelationChartRing j H :=
  (Ideal.Quotient.mkₐ k
      (Ideal.span {ProjectiveSpace.chartDehomogenization 2 k j H})).comp
    (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j).toAlgHom

/-- The normalized coordinates induced by `standardChartToTargetRelationChart` are exactly the
explicit quotient coordinates used by `TargetRelationChartGenericConic`. -/
theorem secondNormalizedCoordinates_standardChartToTargetRelationChart
    (H : MvPolynomial (Fin 3) k) (j : Fin 3) :
    secondNormalizedCoordinates (standardChartToTargetRelationChart H j) =
      targetRelationChartCoordinates j H := by
  funext l
  unfold secondNormalizedCoordinates standardChartToTargetRelationChart
  change Ideal.Quotient.mk _
      (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
        (ProjectiveSpace.normalizedCoordinate 2 k j l)) = _
  rw [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_eq_chartDehomogenization_X]
  rfl

/-- Restricting the ordinary product-chart equation to the affine chart of `V(H)` is the
dehomogenization of the specialized homogeneous conic. -/
theorem affineChartEquationOverTargetRelationBase_eq_chartDehomogenization
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) (i j : Fin 3) :
    affineChartEquationOverTargetRelationBase k H i j F =
      ProjectiveSpace.chartDehomogenization 2 (targetRelationChartRing j H) i
        (sndConicAt F (targetRelationChartCoordinates j H)) := by
  induction F using MvPolynomial.induction_on with
  | C a =>
      simp [affineChartEquationOverTargetRelationBase, affineChartToTargetRelationBase,
        affineChartEquation, affineChartEvaluation, sndConicAt,
        ProjectiveSpace.chartDehomogenization]
  | add P Q hP hQ =>
      simpa [affineChartEquationOverTargetRelationBase, affineChartEquation,
        affineChartEvaluation, sndConicAt, map_add] using
        congrArg₂ (fun x y => x + y) hP hQ
  | mul_X P z hP =>
      rcases z with l | l
      · rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
        · simpa [affineChartEquationOverTargetRelationBase, affineChartToTargetRelationBase,
            affineChartEquation, affineChartEvaluation, affineChartVariable, sndConicAt,
            ProjectiveSpace.chartDehomogenization] using hP
        · simpa [affineChartEquationOverTargetRelationBase, affineChartToTargetRelationBase,
            affineChartEquation, affineChartEvaluation, affineChartVariable, sndConicAt,
            ProjectiveSpace.chartDehomogenization, map_mul] using
            congrArg (fun q => q * MvPolynomial.X r) hP
      · have hXraw :
            affineChartToTargetRelationBase k H j
                (affineChartVariable 2 2 k i j (.inr l)) =
              MvPolynomial.C (targetRelationChartCoordinates j H l) := by
          rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨s, rfl⟩
          · simp [affineChartToTargetRelationBase, affineChartVariable,
              targetRelationChartCoordinates]
          · simp [affineChartToTargetRelationBase, affineChartVariable,
              targetRelationChartCoordinates]
        simpa [affineChartEquationOverTargetRelationBase, affineChartEquation,
          affineChartEvaluation, sndConicAt, map_mul, hXraw] using
          congrArg (fun q => q * MvPolynomial.C (targetRelationChartCoordinates j H l)) hP

/-- The restricted affine equation is the standard base-changed chart equation. -/
theorem affineChartEquationOverTargetRelationBase_eq_baseChangedChartEquation
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) (i j : Fin 3) :
    affineChartEquationOverTargetRelationBase k H i j F =
      baseChangedChartEquation (i := i)
        (standardChartToTargetRelationChart H j) F := by
  rw [affineChartEquationOverTargetRelationBase_eq_chartDehomogenization]
  rw [baseChangedChartEquation_eq_chartDehomogenization]
  rw [secondNormalizedCoordinates_standardChartToTargetRelationChart]
  rfl

/-- Base change from the universal second chart to the target-relation chart maps the affine
conic equation to the restricted equation. -/
theorem map_baseChangedChartEquation_id_eq_affineChartEquationOverTargetRelationBase
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) (i j : Fin 3) :
    MvPolynomial.map (standardChartToTargetRelationChart H j).toRingHom
        (baseChangedChartEquation (i := i)
          (AlgHom.id k (ProjectiveSpace.StandardChartRing 2 k j)) F) =
      affineChartEquationOverTargetRelationBase k H i j F := by
  let S := ProjectiveSpace.StandardChartRing 2 k j
  let A := targetRelationChartRing j H
  let y : S →ₐ[k] A := standardChartToTargetRelationChart H j
  letI : Algebra S A := y.toAlgebra
  rw [affineChartEquationOverTargetRelationBase_eq_chartDehomogenization]
  rw [baseChangedChartEquation_eq_chartDehomogenization]
  change MvPolynomial.map (algebraMap S A)
      (ProjectiveSpace.chartDehomogenization 2 S i
        (sndConicAt F (secondNormalizedCoordinates (AlgHom.id k S)))) = _
  rw [← chartDehomogenization_map]
  rw [map_sndConicAt]
  · congr 2
    funext l
    change y (secondNormalizedCoordinates (AlgHom.id k S) l) =
      targetRelationChartCoordinates j H l
    change y (ProjectiveSpace.normalizedCoordinate 2 k j l) = _
    change Ideal.Quotient.mk _
        (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
          (ProjectiveSpace.normalizedCoordinate 2 k j l)) = _
    rw [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_eq_chartDehomogenization_X]
    rfl
  · ext a
    change y (algebraMap k S a) = algebraMap k A a
    exact y.commutes a

/-- Splitting the two affine variable blocks sends a dehomogenized second-block equation to the
same dehomogenized equation as a constant polynomial. -/
theorem sumAlgEquiv_affineChartEquation_rename_inr
    (H : MvPolynomial (Fin 3) k) (i j : Fin 3) :
    MvPolynomial.sumAlgEquiv k (Fin 2) (Fin 2)
        (affineChartEquation 2 2 k i j
          (MvPolynomial.rename
            (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H)) =
      MvPolynomial.C (ProjectiveSpace.chartDehomogenization 2 k j H) := by
  induction H using MvPolynomial.induction_on with
  | C a =>
      simp [affineChartEquation, affineChartEvaluation, affineChartVariable]
  | add P Q hP hQ =>
      simpa [affineChartEquation, affineChartEvaluation, map_add] using
        congrArg₂ (fun x y => x + y) hP hQ
  | mul_X P l hP =>
      rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨s, rfl⟩
      · simpa [affineChartEquation, affineChartEvaluation, affineChartVariable,
          ProjectiveSpace.chartDehomogenization] using hP
      · simpa [affineChartEquation, affineChartEvaluation, affineChartVariable,
          ProjectiveSpace.chartDehomogenization, map_mul] using
          congrArg (fun z => z * MvPolynomial.C (MvPolynomial.X s)) hP

/-- Smoothness makes the restricted conic equation primitive over every nonempty chart of
`V(H)`. -/
theorem span_range_coeff_affineChartEquationOverTargetRelationBase_eq_top
    [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (H : MvPolynomial (Fin 3) k) (i j : Fin 3) :
    Ideal.span (Set.range fun d =>
      (affineChartEquationOverTargetRelationBase k H i j F).coeff d) = ⊤ := by
  let S := ProjectiveSpace.StandardChartRing 2 k j
  let A := targetRelationChartRing j H
  let y : S →ₐ[k] A := standardChartToTargetRelationChart H j
  let g₀ : MvPolynomial (Fin 2) S :=
    baseChangedChartEquation (i := i) (AlgHom.id k S) F
  let g : MvPolynomial (Fin 2) A := affineChartEquationOverTargetRelationBase k H i j F
  have hg₀ : Ideal.span (Set.range fun d => g₀.coeff d) = ⊤ := by
    simpa [S, g₀] using
      span_range_coeff_baseChangedChartEquation_id_eq_top F hF hF0 i j
  have hmap : MvPolynomial.map y.toRingHom g₀ = g := by
    simpa [S, A, y, g₀, g] using
      map_baseChangedChartEquation_id_eq_affineChartEquationOverTargetRelationBase F H i j
  rw [← top_le_iff]
  have htop : Ideal.map y.toRingHom (Ideal.span (Set.range fun d => g₀.coeff d)) = ⊤ := by
    rw [hg₀, Ideal.map_top]
  rw [← htop]
  rw [Ideal.map_le_iff_le_comap]
  apply Ideal.span_le.mpr
  rintro a ⟨d, rfl⟩
  change y (g₀.coeff d) ∈ Ideal.span (Set.range fun e => g.coeff e)
  have hcoeff : y.toRingHom (g₀.coeff d) = g.coeff d := by
    rw [← hmap, MvPolynomial.coeff_map]
  change y.toRingHom (g₀.coeff d) ∈ _
  rw [hcoeff]
  exact Ideal.subset_span (Set.mem_range_self d)

/-- The restricted affine conic equation generates a prime ideal over every nonempty
target-relation chart. -/
theorem isPrime_span_affineChartEquationOverTargetRelationBase
    [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : Fin 3)
    (hnonempty : ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 k j H))
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i : Fin 3) :
    (Ideal.span {affineChartEquationOverTargetRelationBase k H i j F}).IsPrime := by
  let A := targetRelationChartRing j H
  letI : CommRing A := inferInstance
  let g : MvPolynomial (Fin 2) A :=
    affineChartEquationOverTargetRelationBase k H i j F
  let R := MvPolynomial (Fin 2) A
  letI : CommRing R := inferInstance
  let K := FractionRing A
  let y : Fin 3 → A := targetRelationChartCoordinates j H
  let Q : MvPolynomial (Fin 3) K :=
    MvPolynomial.map (algebraMap A K) (sndConicAt F y)
  letI : IsDomain A :=
    ProjectiveSpace.isDomain_chartDehomogenization_quotient_of_irreducible
      j H hH hHirr hnonempty
  have hprim : Ideal.span (Set.range fun e => g.coeff e) = ⊤ := by
    simpa [A, g] using
      span_range_coeff_affineChartEquationOverTargetRelationBase_eq_top
        F hF hF0 H i j
  letI : Module.Flat A (R ⧸ Ideal.span {g}) :=
    flat_mvPolynomial_quotient_span_singleton_of_span_range_coeff_eq_top g hprim
  obtain ⟨hQhom, hQ0, hQnonsing⟩ :=
    sndConicAt_targetRelationChart_fraction_nonsingular
      F hF H hH hHirr j hnonempty hdisc
  have hgK : MvPolynomial.map (algebraMap A K) g =
      ProjectiveSpace.chartDehomogenization 2 K i Q := by
    dsimp only [g, Q, y]
    rw [affineChartEquationOverTargetRelationBase_eq_chartDehomogenization]
    exact (chartDehomogenization_map i
      (sndConicAt F (targetRelationChartCoordinates j H))).symm
  have hdom : IsDomain (R ⧸ Ideal.span {g}) :=
    isDomain_chartQuotient_of_flat_of_nonsingular_baseChange
      (IsFractionRing.injective A K) g i Q hQhom hQ0 hQnonsing hgK
  change (Ideal.span {g}).IsPrime
  exact (Ideal.Quotient.isDomain_iff_prime (Ideal.span {g})).mp hdom

set_option maxHeartbeats 2000000 in
/-- Splitting the two affine variable blocks and quotienting the `y`-equation identifies the
two-equation chart ideal with the integral affine conic above. -/
theorem isPrime_twoEquationAffineChartIdeal_targetRelation
    [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : Fin 3)
    (hnonempty : ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 k j H))
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i : Fin 3) :
    (twoEquationAffineChartIdeal 2 2 k i j F
      (MvPolynomial.rename
        (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H)).IsPrime := by
  let h := ProjectiveSpace.chartDehomogenization 2 k j H
  let A := MvPolynomial (Fin 2) k ⧸ Ideal.span {h}
  let Rxy := MvPolynomial (Fin 2 ⊕ Fin 2) k
  let Riter := MvPolynomial (Fin 2) (MvPolynomial (Fin 2) k)
  let e : Rxy ≃+* Riter :=
    (MvPolynomial.sumAlgEquiv k (Fin 2) (Fin 2)).toRingEquiv
  let phi : Riter →+* MvPolynomial (Fin 2) A :=
    MvPolynomial.map (Ideal.Quotient.mk (Ideal.span {h}))
  let p : Rxy := affineChartEquation 2 2 k i j F
  let q : Rxy := affineChartEquation 2 2 k i j
    (MvPolynomial.rename
      (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H)
  let g : MvPolynomial (Fin 2) A :=
    affineChartEquationOverTargetRelationBase k H i j F
  have hphi_surj : Function.Surjective phi :=
    MvPolynomial.map_surjective _ Ideal.Quotient.mk_surjective
  have hsplitHom : phi.comp e.toRingHom =
      (affineChartToTargetRelationBase k H j).toRingHom := by
    refine MvPolynomial.ringHom_ext ?_ ?_
    · intro a
      simp only [RingHom.comp_apply]
      change phi (e.toRingHom (MvPolynomial.C a)) =
        (affineChartToTargetRelationBase k H j) (MvPolynomial.C a)
      rw [show e.toRingHom (MvPolynomial.C a) = MvPolynomial.C (MvPolynomial.C a) by
        exact MvPolynomial.sumAlgEquiv_C_inl k (Fin 2) (Fin 2) a]
      rw [MvPolynomial.map_C]
      simp only [affineChartToTargetRelationBase, MvPolynomial.aeval_C]
      apply congrArg MvPolynomial.C
      exact Ideal.Quotient.mk_algebraMap k
        (Ideal.span {ProjectiveSpace.chartDehomogenization 2 k j H}) a
    · rintro (r | s)
      · simp only [RingHom.comp_apply]
        change phi (e.toRingHom (MvPolynomial.X (.inl r))) =
          (affineChartToTargetRelationBase k H j) (MvPolynomial.X (.inl r))
        rw [show e.toRingHom (MvPolynomial.X (.inl r)) = MvPolynomial.X r by
          exact MvPolynomial.sumAlgEquiv_X_inl k (Fin 2) (Fin 2) r]
        rw [MvPolynomial.map_X]
        simp [affineChartToTargetRelationBase]
      · simp only [RingHom.comp_apply]
        change phi (e.toRingHom (MvPolynomial.X (.inr s))) =
          (affineChartToTargetRelationBase k H j) (MvPolynomial.X (.inr s))
        rw [show e.toRingHom (MvPolynomial.X (.inr s)) =
            MvPolynomial.C (MvPolynomial.X s) by
          exact MvPolynomial.sumAlgEquiv_X_inr k (Fin 2) (Fin 2) s]
        rw [MvPolynomial.map_C]
        simp [phi, h, affineChartToTargetRelationBase]
  have hsplit (P : Rxy) : phi (e P) = affineChartToTargetRelationBase k H j P := by
    exact DFunLike.congr_fun hsplitHom P
  have hphi_p : phi (e p) = g := by
    simpa [p, g, affineChartEquationOverTargetRelationBase] using hsplit p
  have hphi_q : phi (e q) = 0 := by
    rw [hsplit]
    change affineChartEquationOverTargetRelationBase k H i j
      (MvPolynomial.rename Sum.inr H) = 0
    exact affineChartEquationOverTargetRelationBase_rename_inr_eq_zero k H i j
  have hqsplit : e q = MvPolynomial.C h := by
    simpa [e, q, h] using sumAlgEquiv_affineChartEquation_rename_inr H i j
  have hphi_ker : RingHom.ker phi = Ideal.span {MvPolynomial.C h} := by
    dsimp only [phi]
    rw [MvPolynomial.ker_map, Ideal.mk_ker]
    change Ideal.map MvPolynomial.C (Ideal.span {h}) = _
    rw [Ideal.map_span]
    simp
  have hgprime : (Ideal.span {g}).IsPrime := by
    exact isPrime_span_affineChartEquationOverTargetRelationBase
      F hF hF0 H hH hHirr j hnonempty hdisc i
  have himagePrime : (Ideal.span {phi (e p)}).IsPrime := by
    rw [hphi_p]
    exact hgprime
  have hiter : (Ideal.span {e p, MvPolynomial.C h}).IsPrime :=
    isPrime_span_pair_of_surjective
      (R := Riter) (S := MvPolynomial (Fin 2) A)
      phi hphi_surj (e p) (MvPolynomial.C h) hphi_ker himagePrime
  have hmap : Ideal.map e
      (Ideal.span ({p, q} : Set Rxy)) =
      Ideal.span {e p, MvPolynomial.C h} := by
    rw [Ideal.map_span, Set.image_pair, hqsplit]
  have hcomap : Ideal.comap e
      (Ideal.span {e p, MvPolynomial.C h}) = Ideal.span {p, q} := by
    rw [← hmap, Ideal.comap_map_of_bijective e e.bijective]
  change (Ideal.span {p, q}).IsPrime
  rw [← hcomap]
  exact hiter.comap e

/-- Quotienting the affine target-relation chart by its second equation sends the full
two-equation ideal to the principal restricted-conic ideal. -/
theorem map_twoEquationAffineChartIdeal_targetRelation
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) (i j : Fin 3) :
    Ideal.map (affineChartToTargetRelationBase k H j).toRingHom
        (twoEquationAffineChartIdeal 2 2 k i j F
          (MvPolynomial.rename
            (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H)) =
      Ideal.span {affineChartEquationOverTargetRelationBase k H i j F} := by
  unfold twoEquationAffineChartIdeal
  rw [Ideal.map_span, Set.image_pair]
  change Ideal.span
      {affineChartEquationOverTargetRelationBase k H i j F,
        affineChartEquationOverTargetRelationBase k H i j
          (MvPolynomial.rename Sum.inr H)} = _
  rw [affineChartEquationOverTargetRelationBase_rename_inr_eq_zero]
  simp

set_option maxHeartbeats 800000 in
/-- Every first-block affine coordinate remains nonzero in a retained target-relation chart.
This is the algebraic overlap input for changing the first projective standard chart. -/
theorem quotient_X_inl_ne_zero_twoEquationAffineChartIdeal_targetRelation
    [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : Fin 3)
    (hnonempty : ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 k j H))
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i : Fin 3) (r : Fin 2) :
    Ideal.Quotient.mk
        (twoEquationAffineChartIdeal 2 2 k i j F
          (MvPolynomial.rename
            (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H))
        (MvPolynomial.X (.inl r)) ≠ 0 := by
  let A := targetRelationChartRing j H
  letI : IsDomain A :=
    ProjectiveSpace.isDomain_chartDehomogenization_quotient_of_irreducible
      j H hH hHirr hnonempty
  letI : CharZero A :=
    charZero_of_injective_algebraMap
      (FaithfulSMul.algebraMap_injective k A)
  let Q : MvPolynomial (Fin 3) A :=
    sndConicAt F (targetRelationChartCoordinates j H)
  let QK : MvPolynomial (Fin 3) (FractionRing A) :=
    MvPolynomial.map (algebraMap A (FractionRing A)) Q
  obtain ⟨hQKhom, _hQK0, hQKnonsing⟩ :=
    sndConicAt_targetRelationChart_fraction_nonsingular
      F hF H hH hHirr j hnonempty hdisc
  have hQhom : Q.IsHomogeneous 2 :=
    sndConicAt_isHomogeneous F hF (targetRelationChartCoordinates j H)
  have hdet : (polarMatrix QK).det ≠ 0 :=
    det_polarMatrix_ne_zero_of_nonsingular QK hQKhom hQKnonsing
  have hx : Ideal.Quotient.mk
      (Ideal.span {affineChartEquationOverTargetRelationBase k H i j F})
      (MvPolynomial.X r) ≠ 0 := by
    rw [affineChartEquationOverTargetRelationBase_eq_chartDehomogenization]
    exact quotient_chart_variable_ne_zero_of_fraction_det i r Q hQhom hdet
  intro hz
  apply hx
  rw [Ideal.Quotient.eq_zero_iff_mem]
  have hmem : MvPolynomial.X (.inl r) ∈
      twoEquationAffineChartIdeal 2 2 k i j F
        (MvPolynomial.rename Sum.inr H) :=
    Ideal.Quotient.eq_zero_iff_mem.mp hz
  have hmapped := Ideal.mem_map_of_mem
    (affineChartToTargetRelationBase k H j).toRingHom hmem
  rw [map_twoEquationAffineChartIdeal_targetRelation F H i j] at hmapped
  simpa [affineChartToTargetRelationBase] using hmapped

set_option maxHeartbeats 800000 in
/-- A retained second-block affine coordinate remains nonzero in the target-relation chart.
The hypothesis is the homogeneous nondivisibility statement for that coordinate. -/
theorem quotient_X_inr_ne_zero_twoEquationAffineChartIdeal_targetRelation
    [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : Fin 3)
    (hnonempty : ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 k j H))
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (i : Fin 3) (s : Fin 2)
    (hnotdvd : ¬ H ∣ MvPolynomial.X (j.succAbove s)) :
    Ideal.Quotient.mk
        (twoEquationAffineChartIdeal 2 2 k i j F
          (MvPolynomial.rename
            (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H))
        (MvPolynomial.X (.inr s)) ≠ 0 := by
  let A := targetRelationChartRing j H
  letI : IsDomain A :=
    ProjectiveSpace.isDomain_chartDehomogenization_quotient_of_irreducible
      j H hH hHirr hnonempty
  let g : MvPolynomial (Fin 2) A :=
    affineChartEquationOverTargetRelationBase k H i j F
  let QK : MvPolynomial (Fin 3) (FractionRing A) :=
    MvPolynomial.map (algebraMap A (FractionRing A))
      (sndConicAt F (targetRelationChartCoordinates j H))
  obtain ⟨hQKhom, hQK0, hQKnonsing⟩ :=
    sndConicAt_targetRelationChart_fraction_nonsingular
      F hF H hH hHirr j hnonempty hdisc
  have hirrQK : Irreducible QK :=
    TernaryQuadratic.irreducible_of_isHomogeneous_two_of_nonsingular
      QK hQKhom hQK0 hQKnonsing
  have hirrgK : Irreducible
      (MvPolynomial.map (algebraMap A (FractionRing A)) g) := by
    rw [show MvPolynomial.map (algebraMap A (FractionRing A)) g =
        ProjectiveSpace.chartDehomogenization 2 (FractionRing A) i QK by
      dsimp only [g, QK]
      rw [affineChartEquationOverTargetRelationBase_eq_chartDehomogenization]
      exact (chartDehomogenization_map i
        (sndConicAt F (targetRelationChartCoordinates j H))).symm]
    exact irreducible_chartDehomogenization_of_irreducible_homogeneous_two
      i QK hQKhom hQK0 hirrQK
  let a : A := Ideal.Quotient.mk
    (Ideal.span {ProjectiveSpace.chartDehomogenization 2 k j H})
      (MvPolynomial.X s)
  have ha : a ≠ 0 := by
    dsimp only [a]
    simpa using
      (ProjectiveSpace.quotient_mk_chartDehomogenization_ne_zero_of_not_dvd
        j H (MvPolynomial.X (j.succAbove s)) hH hHirr
          (MvPolynomial.isHomogeneous_X k (j.succAbove s)) hnonempty hnotdvd)
  have hCa : Ideal.Quotient.mk (Ideal.span {g}) (MvPolynomial.C a) ≠ 0 :=
    quotient_C_ne_zero_of_fraction_irreducible g hirrgK a ha
  intro hz
  apply hCa
  rw [Ideal.Quotient.eq_zero_iff_mem]
  have hmem : MvPolynomial.X (.inr s) ∈
      twoEquationAffineChartIdeal 2 2 k i j F
        (MvPolynomial.rename Sum.inr H) :=
    Ideal.Quotient.eq_zero_iff_mem.mp hz
  have hmapped := Ideal.mem_map_of_mem
    (affineChartToTargetRelationBase k H j).toRingHom hmem
  rw [map_twoEquationAffineChartIdeal_targetRelation F H i j] at hmapped
  simpa [affineChartToTargetRelationBase, a, g] using hmapped

end BiprojectiveSpace

end

end BConicBundleMultisections

end
