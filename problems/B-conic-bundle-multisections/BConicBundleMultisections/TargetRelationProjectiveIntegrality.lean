/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PointedConicRationalFamilies
public import BConicBundleMultisections.ResidualComponentExhaustion
public import BConicBundleMultisections.ResidualRelationGenericConic
public import BConicBundleMultisections.ResidualTargetRelationNullstellensatz
public import BConicBundleMultisections.VerticalCompleteIntersectionPrime

/-!
# Projective integrality bridge for a target relation

For a homogeneous relation `H(y)`, the scheme `targetRelationZeroLocus F H` should be the base
change of the conic projection `V(F) → ℙ²_y` to the projective curve `V(H)`.  Once that pullback
square and the integral projective curve are available, the remaining integrality argument is
formal: global flatness of the smooth conic projection descends to the base change, and an
integral generic conic makes the total space integral.

This module packages that formal endpoint without choosing a particular construction of the
projective hypersurface `V(H)`.  The exact remaining interface is an integral scheme `C`, a map
`C → ℙ²_y`, a map from the target relation to `C`, the indicated pullback square, and geometric
integrality of its generic fibre.  `ResidualRelationGenericConic` supplies the algebraic
nonsingularity input for the last item; identifying its fraction field with the residue field of
the generic point of `C` is part of the projective-hypersurface plumbing.

The affine-cone quotient is deliberately not substituted for `C`: the cone vertex makes every
coefficient of the universal conic vanish, so the primitive-polynomial flatness theorem cannot
apply there.  Projectivization is what removes that false flatness obstruction.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry BiprojectiveSpace

/-! ## Why the affine cone is not the flat base -/

/-- Evaluation at the cone vertex descends through a positive-degree homogeneous relation. -/
def targetRelationConeVertexHom
    {k : Type u} [Field k]
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) :
    (MvPolynomial (Fin 3) k ⧸ Ideal.span {H}) →+* k :=
  Ideal.Quotient.lift (Ideal.span {H})
    (MvPolynomial.aeval (0 : Fin 3 → k)).toRingHom (by
      intro p hp
      obtain ⟨a, ha⟩ := Ideal.mem_span_singleton'.mp hp
      rw [← ha, map_mul]
      have hH0 : MvPolynomial.aeval (0 : Fin 3 → k) H = 0 := by
        rw [MvPolynomial.aeval_def, MvPolynomial.eval₂_eq_eval_map]
        have hk : algebraMap k k = RingHom.id k := by
          ext a
          simp
        rw [hk, MvPolynomial.map_id, MvPolynomial.eval_zero,
          MvPolynomial.constantCoeff_eq]
        exact hH.coeff_eq_zero (by simpa using hd.ne)
      have hH0' : (MvPolynomial.aeval (0 : Fin 3 → k)).toRingHom H = 0 := hH0
      rw [hH0', mul_zero])

@[simp]
theorem targetRelationConeVertexHom_mk
    {k : Type u} [Field k]
    (H P : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) :
    targetRelationConeVertexHom H hH hd
        (Ideal.Quotient.mk (Ideal.span {H}) P) =
      MvPolynomial.aeval (0 : Fin 3 → k) P := by
  exact Ideal.Quotient.lift_mk _ _ _

/-- Every coefficient of the universal conic vanishes at the vertex of the target-relation
cone. -/
theorem map_targetRelationConeVertexHom_universalSndConicModulo_eq_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F)
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) :
    MvPolynomial.map (targetRelationConeVertexHom H hH hd)
      (universalSndConicModulo F H) = 0 := by
  rw [universalSndConicModulo, MvPolynomial.map_map]
  have hcomp : (targetRelationConeVertexHom H hH hd).comp
      (Ideal.Quotient.mk (Ideal.span {H})) =
      (MvPolynomial.aeval (0 : Fin 3 → k)).toRingHom := by
    apply RingHom.ext
    intro P
    exact targetRelationConeVertexHom_mk H P hH hd
  rw [hcomp, map_universalSndConic_aeval]
  dsimp only [sndConicAt]
  have hmap : MvPolynomial.map (algebraMap k k) F = F := by
    have hk : algebraMap k k = RingHom.id k := by
      ext a
      simp
    rw [hk]
    exact MvPolynomial.map_id F
  rw [hmap, specializeSecondCoordinates_zero_of_bidegree_pos hF (by norm_num)]

/-- The coefficient ideal of the universal conic over the affine relation cone is proper.

Thus the primitive-polynomial flatness criterion cannot be used before projectivizing the base:
all coefficients vanish at the cone vertex. -/
theorem span_range_coeff_universalSndConicModulo_ne_top
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F)
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) :
    let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
    let Q : MvPolynomial (Fin 3) A := universalSndConicModulo F H
    Ideal.span (Set.range fun e ↦ Q.coeff e) ≠ ⊤ := by
  dsimp only
  let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
  let Q : MvPolynomial (Fin 3) A := universalSndConicModulo F H
  let ε : A →+* k := targetRelationConeVertexHom H hH hd
  have hQzero : MvPolynomial.map ε Q = 0 :=
    map_targetRelationConeVertexHom_universalSndConicModulo_eq_zero
      F hF H hH hd
  have hcoeff (e : Fin 3 →₀ ℕ) : ε (Q.coeff e) = 0 := by
    have := congrArg (MvPolynomial.coeff e) hQzero
    simpa only [MvPolynomial.coeff_map, MvPolynomial.coeff_zero] using this
  have hle : Ideal.span (Set.range fun e ↦ Q.coeff e) ≤ RingHom.ker ε := by
    apply Ideal.span_le.mpr
    rintro a ⟨e, rfl⟩
    exact hcoeff e
  have hmapbot : Ideal.map ε (Ideal.span (Set.range fun e ↦ Q.coeff e)) = ⊥ :=
    (Ideal.map_eq_bot_iff_le_ker ε).mpr hle
  intro htop
  have hmaptop := congrArg (Ideal.map ε) htop
  rw [hmapbot, Ideal.map_top] at hmaptop
  exact (bot_ne_top : (⊥ : Ideal k) ≠ ⊤) hmaptop

/-- The canonical closed immersion from the two-equation target relation into the conic
hypersurface `V(F)`. -/
def targetRelationToConic
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    targetRelationZeroLocus F H ⟶ biprojectiveZeroLocus 2 2 k F :=
  Scheme.IdealSheafData.inclusion
    (show biprojectiveZeroLocusIdeal 2 2 k F ≤ targetRelationIdeal F H by
      exact le_sup_left)

@[reassoc]
theorem targetRelationToConic_ι
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    targetRelationToConic F H ≫ biprojectiveZeroLocusι 2 2 k F =
      targetRelationι F H := by
  exact Scheme.IdealSheafData.inclusion_subschemeι _

/-- The second projection of the target relation to the ambient `y`-plane. -/
def targetRelationToSecond
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    targetRelationZeroLocus F H ⟶ ProjectiveSpace 2 k :=
  targetRelationι F H ≫ BiprojectiveSpace.snd 2 2 k

@[reassoc]
theorem targetRelationToConic_biprojectiveZeroLocusSnd
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    targetRelationToConic F H ≫ biprojectiveZeroLocusSnd 2 2 k F =
      targetRelationToSecond F H := by
  rw [biprojectiveZeroLocusSnd, ← Category.assoc, targetRelationToConic_ι]
  rfl

/-- Formal projective-curve endpoint with integrality of the generic fibre as an explicit input.

The `IsPullback` hypothesis is the precise scheme-theoretic assertion that
`targetRelationZeroLocus F H` is `V(F) ×_{ℙ²_y} C`. -/
theorem isIntegral_targetRelationZeroLocus_of_projectiveCurve_pullback
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (H : MvPolynomial (Fin 3) k)
    {C : Scheme.{u}} [IsIntegral C]
    (t : C ⟶ ProjectiveSpace 2 k)
    (p : targetRelationZeroLocus F H ⟶ C)
    (hpb : IsPullback (targetRelationToConic F H) p
      (biprojectiveZeroLocusSnd 2 2 k F) t)
    (hη : IsIntegral (p.fiber (genericPoint C))) :
    IsIntegral (targetRelationZeroLocus F H) := by
  haveI hflatπ : Flat (biprojectiveZeroLocusSnd 2 2 k F) :=
    flat_biprojectiveZeroLocusSnd_of_smooth_bidegree23 F hF hF0
  haveI hflatp : Flat p := MorphismProperty.of_isPullback hpb hflatπ
  exact isIntegral_of_flat_of_isIntegral_genericFiber p hη

/-- Geometrically integral generic-fibre form of the projective-curve endpoint.

This is the form intended for the nonsingular generic conic supplied algebraically by
`sndConicAt_relationCone_fraction_nonsingular`. -/
theorem isIntegral_targetRelationZeroLocus_of_projectiveCurve_pullback_of_geometricallyIntegral
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (H : MvPolynomial (Fin 3) k)
    {C : Scheme.{u}} [IsIntegral C]
    (t : C ⟶ ProjectiveSpace 2 k)
    (p : targetRelationZeroLocus F H ⟶ C)
    (hpb : IsPullback (targetRelationToConic F H) p
      (biprojectiveZeroLocusSnd 2 2 k F) t)
    (hη : GeometricallyIntegral
      (p.fiberToSpecResidueField (genericPoint C))) :
    IsIntegral (targetRelationZeroLocus F H) := by
  apply isIntegral_targetRelationZeroLocus_of_projectiveCurve_pullback
    F hF hF0 H t p hpb
  haveI : Subsingleton (Spec (C.residueField (genericPoint C))) := inferInstance
  exact GeometricallyIntegral.isIntegral_of_subsingleton
    (p.fiberToSpecResidueField (genericPoint C))

/-! ## Exact projective-curve interface for the G4 endpoint -/

/-- The remaining projective plumbing for an irreducible homogeneous target relation.

Besides the integral projective curve and pullback square, the package asks only for the
comparison that turns nonsingularity of the explicit cone-fraction conic into geometric
integrality of the scheme-theoretic generic fibre.  Thus the algebraic nonsingularity proof stays
outside the package and is supplied by `ResidualRelationGenericConic`. -/
structure TargetRelationProjectiveCurvePackage
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    {d : ℕ} (_hH : H.IsHomogeneous d) (_hd : 0 < d) where
  /-- The projective relation curve. -/
  curve : Scheme.{u}
  /-- The curve is integral. -/
  curve_isIntegral : IsIntegral curve
  /-- Its canonical map to the ambient second projective plane. -/
  curveToBase : curve ⟶ ProjectiveSpace 2 k
  /-- Projection of the target relation to the relation curve. -/
  relationToCurve : targetRelationZeroLocus F H ⟶ curve
  /-- The target relation is the base change of the conic hypersurface to the curve. -/
  isPullback : IsPullback (targetRelationToConic F H) relationToCurve
    (biprojectiveZeroLocusSnd 2 2 k F) curveToBase
  /-- A chosen generic point of the integral curve. -/
  η : curve
  /-- The chosen point is generic. -/
  η_isGeneric : IsGenericPoint η Set.univ
  /-- Comparison between the explicit fraction-field conic and the scheme generic fibre. -/
  genericFiber_geometricallyIntegral_of_relationCone_nonsingular :
    (let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
     let y : Fin 3 → A := fun i ↦
       Ideal.Quotient.mk (Ideal.span ({H} : Set (MvPolynomial (Fin 3) k)))
         (MvPolynomial.X i)
     let Q : MvPolynomial (Fin 3) (FractionRing A) :=
       MvPolynomial.map (algebraMap A (FractionRing A)) (sndConicAt F y)
     Q.IsHomogeneous 2 ∧ Q ≠ 0 ∧
       ∀ x : Fin 3 → FractionRing A, x ≠ 0 → MvPolynomial.eval x Q = 0 →
         ∃ j, MvPolynomial.eval x (MvPolynomial.pderiv j Q) ≠ 0) →
      GeometricallyIntegral (relationToCurve.fiberToSpecResidueField η)

/-- G4 target-relation integrality from the exact projective-curve package.

All polynomial algebra is discharged here from irreducibility and discriminant avoidance.  The
package contains precisely the still-missing construction of `Proj(k[y]/(H))`, its pullback
identification with `targetRelationZeroLocus`, and the generic-fibre comparison. -/
theorem isIntegral_targetRelationZeroLocus_of_irreducible_homogeneous_not_dvd_discriminant
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hHirr : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (D : TargetRelationProjectiveCurvePackage F H hH hd) :
    IsIntegral (targetRelationZeroLocus F H) := by
  letI : IsIntegral D.curve := D.curve_isIntegral
  have hηeq : D.η = genericPoint D.curve := by
    apply ((genericPoint_spec D.curve).eq _).symm
    exact D.η_isGeneric
  have hnonsingular :=
    sndConicAt_relationCone_fraction_nonsingular F hF hHirr hdisc
  have hgiη : GeometricallyIntegral
      (D.relationToCurve.fiberToSpecResidueField D.η) :=
    D.genericFiber_geometricallyIntegral_of_relationCone_nonsingular hnonsingular
  have hgi : GeometricallyIntegral
      (D.relationToCurve.fiberToSpecResidueField (genericPoint D.curve)) := by
    rw [← hηeq]
    exact hgiη
  exact
    isIntegral_targetRelationZeroLocus_of_projectiveCurve_pullback_of_geometricallyIntegral
      F hF hF0 H D.curveToBase D.relationToCurve D.isPullback hgi

end

end BConicBundleMultisections

end
