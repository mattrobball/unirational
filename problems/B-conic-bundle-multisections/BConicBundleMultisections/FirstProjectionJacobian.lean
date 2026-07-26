/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PointedConicRationalFamilies

/-!
# Jacobian nonsingularity of fibres of the first projection

This is the first-projection counterpart of
`nonsingular_sndResidueFiberPolynomial_of_smooth`.  For a bidegree-`(2,3)` equation the fibres of
the first projection are plane cubics, so the final homogeneous-chart argument is the degree-three
version of the degree-two argument in `HomogeneousJacobianChart`.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry CommRingCat MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra

namespace BiprojectiveSpace

variable {m n : ℕ} {R K : Type u} [CommRing R] [CommRing K] [Algebra R K]
variable {i : Fin (m + 1)} {j : Fin (n + 1)}

/-! ## First-projection chart base change -/

@[reassoc]
theorem standardChartIsoSpec_hom_fst
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (standardChartIsoSpec m n R i j).hom ≫
        Spec.map (ofHom (Algebra.TensorProduct.includeLeftRingHom
          (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j))) ≫
        ProjectiveSpace.standardChartι m R i =
      standardChartι m n R i j ≫ BiprojectiveSpace.fst m n R := by
  rw [← cancel_epi (standardChartIsoSpec m n R i j).inv]
  rw [Iso.inv_hom_id_assoc, standardChartι_fst, ← Category.assoc,
    standardChartIsoSpec_inv_fst]

/-- The map from the first-factor chart ring into the affine chart ring of the zero locus. -/
def affineChartQuotientXHom (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    ProjectiveSpace.StandardChartRing m R i →+*
      (MvPolynomial (Fin m ⊕ Fin n) R ⧸
        Ideal.span {affineChartEquation m n R i j F}) :=
  ((Ideal.Quotient.mk (Ideal.span {affineChartEquation m n R i j F})).comp
      (standardChartRingEquivMvPolynomial m n R i j).toRingHom).comp
    (Algebra.TensorProduct.includeLeftRingHom
      (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
      (B := ProjectiveSpace.StandardChartRing n R j))

set_option backward.isDefEq.respectTransparency false in
/-- The affine quotient chart maps to the first projective factor through the first block. -/
theorem chartZeroLocusIsoSpecAffineQuotient_hom_fst
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (chartZeroLocusIsoSpecAffineQuotient m n R i j F).hom ≫
        Spec.map (ofHom (affineChartQuotientXHom m n R i j F)) ≫
        ProjectiveSpace.standardChartι m R i =
      chartZeroLocusToGlobal m n R F hF i j ≫ biprojectiveZeroLocusFst m n R F := by
  rw [biprojectiveZeroLocusFst, chartZeroLocusToGlobal_ι_assoc]
  rw [← cancel_epi ((chartIdealSheaf m n R i j F).subschemeCover.f
    (chartTopAffineOpen m n R i j))]
  rw [← Category.assoc, chartSubschemeCover_comp_chartZeroLocusIsoSpecAffineQuotient]
  rw [← Category.assoc, ← Spec.map_comp]
  rw [subschemeCover_map_subschemeι_fromSpec]
  rw [← standardChartIsoSpec_hom_fst]
  rw [chartTopAffineOpen_fromSpec_comp_standardChartIsoSpec_assoc]
  simp only [← Spec.map_comp_assoc]
  congr 1
  rw [Spec.map_injective.eq_iff]
  ext a
  change (chartIdealQuotientEquivMvPolynomial m n R i j F).symm
      (affineChartQuotientXHom m n R i j F a) =
    Ideal.Quotient.mk _ ((standardChartΓIso m n R i j).inv
      (Algebra.TensorProduct.includeLeftRingHom
        (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
        (B := ProjectiveSpace.StandardChartRing n R j) a))
  apply (chartIdealQuotientEquivMvPolynomial m n R i j F).injective
  rw [RingEquiv.apply_symm_apply]
  unfold chartIdealQuotientEquivMvPolynomial
  rw [Ideal.quotientEquiv_mk]
  have h : chartSectionsEquivMvPolynomial m n R i j
      ((standardChartΓIso m n R i j).inv
        (Algebra.TensorProduct.includeLeftRingHom
          (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j) a)) =
      standardChartRingEquivMvPolynomial m n R i j
        (Algebra.TensorProduct.includeLeftRingHom
          (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j) a) := by
    unfold chartSectionsEquivMvPolynomial
    change standardChartRingEquivMvPolynomial m n R i j
      ((standardChartΓIso m n R i j).hom
        ((standardChartΓIso m n R i j).inv
          (Algebra.TensorProduct.includeLeftRingHom
            (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
            (B := ProjectiveSpace.StandardChartRing n R j) a))) = _
    rw [Iso.inv_hom_id_apply]
  rw [h]
  rfl

theorem includeLeft_comp_fstFiberChartMap
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K) :
    (ofHom (Algebra.TensorProduct.includeLeftRingHom
        (A := ProjectiveSpace.StandardChartRing m R i)
        (B := ProjectiveSpace.StandardChartRing n R j))) ≫
        ofHom (fstFiberChartMap (j := j) x).toRingHom =
      ofHom x.toRingHom ≫
        ofHom (Algebra.TensorProduct.includeLeftRingHom
          (A := K) (B := ProjectiveSpace.StandardChartRing n R j)) := by
  ext a
  change fstFiberChartMap (j := j) x (a ⊗ₜ[R] 1) = _
  rw [fstFiberChartMap_tmul]
  simp

theorem includeRight_comp_fstFiberChartMap
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K) :
    (ofHom (Algebra.TensorProduct.includeRight
        (A := ProjectiveSpace.StandardChartRing m R i)
        (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom) ≫
        ofHom (fstFiberChartMap (j := j) x).toRingHom =
      ofHom (Algebra.TensorProduct.includeRight
        (A := K) (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom := by
  ext b
  change fstFiberChartMap (j := j) x (1 ⊗ₜ[R] b) = _
  rw [fstFiberChartMap_tmul]
  simp

theorem algebraMap_comp_fstChartPoint
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K) :
    ofHom (algebraMap R (ProjectiveSpace.StandardChartRing m R i)) ≫ ofHom x.toRingHom =
      ofHom (algebraMap R K) := by
  ext r
  exact x.commutes r

theorem isPushout_fstFiberChartMap
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K) :
    IsPushout (ofHom x.toRingHom)
      (ofHom (Algebra.TensorProduct.includeLeftRingHom
        (A := ProjectiveSpace.StandardChartRing m R i)
        (B := ProjectiveSpace.StandardChartRing n R j)))
      (ofHom (Algebra.TensorProduct.includeLeftRingHom
        (A := K) (B := ProjectiveSpace.StandardChartRing n R j)))
      (ofHom (fstFiberChartMap (j := j) x).toRingHom) := by
  refine ((CommRingCat.isPushout_tensorProduct R
    (ProjectiveSpace.StandardChartRing m R i)
    (ProjectiveSpace.StandardChartRing n R j)).paste_horiz_iff
      (includeLeft_comp_fstFiberChartMap (j := j) x).symm).mp ?_
  rw [algebraMap_comp_fstChartPoint x, includeRight_comp_fstFiberChartMap (j := j) x]
  exact CommRingCat.isPushout_tensorProduct R K (ProjectiveSpace.StandardChartRing n R j)

theorem isPushout_fstChartQuotient
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K)
    (I : Ideal (StandardChartRing m n R i j)) :
    IsPushout (ofHom x.toRingHom)
      (ofHom (Algebra.TensorProduct.includeLeftRingHom
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)) ≫
        ofHom (Ideal.Quotient.mk I))
      (ofHom (Algebra.TensorProduct.includeLeftRingHom
          (A := K) (B := ProjectiveSpace.StandardChartRing n R j)) ≫
        ofHom (Ideal.Quotient.mk (I.map (fstFiberChartMap (j := j) x).toRingHom)))
      (ofHom (Ideal.Quotient.lift I
        ((Ideal.Quotient.mk (I.map (fstFiberChartMap (j := j) x).toRingHom)).comp
          (fstFiberChartMap (j := j) x).toRingHom)
        (fun _ ha => Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_map_of_mem _ ha)))) :=
  (isPushout_fstFiberChartMap (j := j) x).paste_vert
    (isPushout_quotientMk (ofHom (fstFiberChartMap (j := j) x).toRingHom) I).flip

theorem isPullback_SpecMap_fstChartQuotient
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K)
    (I : Ideal (StandardChartRing m n R i j)) :
    IsPullback
      (Spec.map (ofHom (Algebra.TensorProduct.includeLeftRingHom
          (A := K) (B := ProjectiveSpace.StandardChartRing n R j)) ≫
        ofHom (Ideal.Quotient.mk (I.map (fstFiberChartMap (j := j) x).toRingHom))))
      (Spec.map (ofHom (Ideal.Quotient.lift I
        ((Ideal.Quotient.mk (I.map (fstFiberChartMap (j := j) x).toRingHom)).comp
          (fstFiberChartMap (j := j) x).toRingHom)
        (fun _ ha => Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_map_of_mem _ ha)))))
      (Spec.map (ofHom x.toRingHom))
      (Spec.map (ofHom (Algebra.TensorProduct.includeLeftRingHom
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)) ≫
        ofHom (Ideal.Quotient.mk I))) :=
  isPullback_SpecMap_of_isPushout _ _ _ _ (isPushout_fstChartQuotient (j := j) x I)

/-- The first-projection chart equation after base change, in ordinary affine coordinates. -/
noncomputable def fstBaseChangedChartEquation
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    MvPolynomial (Fin n) K :=
  tensorStandardChartEquivMvPolynomial n R K j
    (fstFiberChartMap (j := j) x (chartEquation m n R i j F))

theorem map_span_chartEquation_eq_span_fstFiber
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    Ideal.map (fstFiberChartMap (j := j) x).toRingHom
        (Ideal.span {chartEquation m n R i j F}) =
      Ideal.span {fstFiberChartMap (j := j) x (chartEquation m n R i j F)} := by
  rw [Ideal.map_span, Set.image_singleton]
  rfl

theorem affineChartQuotientXHom_eq_equiv_comp_includeLeft_mk
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    affineChartQuotientXHom m n R i j F =
      (standardChartQuotientEquivAffineQuotient (R := R) (i := i) (j := j) F).toRingHom.comp
        ((Ideal.Quotient.mk (Ideal.span {chartEquation m n R i j F})).comp
          (Algebra.TensorProduct.includeLeftRingHom
              (R := R)
              (A := ProjectiveSpace.StandardChartRing m R i)
              (B := ProjectiveSpace.StandardChartRing n R j))) := by
  ext a
  unfold affineChartQuotientXHom standardChartQuotientEquivAffineQuotient
  simp only [RingHom.comp_apply, Ideal.quotientEquiv_mk, RingEquiv.toRingHom_eq_coe,
    RingEquiv.coe_toRingHom, AlgEquiv.coe_ringEquiv]

theorem Spec_map_affineChartQuotientXHom
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    Spec.map (ofHom (affineChartQuotientXHom m n R i j F)) =
      Spec.map
          (ofHom
            (standardChartQuotientEquivAffineQuotient (R := R) (i := i) (j := j) F).toRingHom) ≫
        Spec.map
          (ofHom
              (Algebra.TensorProduct.includeLeftRingHom
                  (R := R)
                  (A := ProjectiveSpace.StandardChartRing m R i)
                  (B := ProjectiveSpace.StandardChartRing n R j)) ≫
                ofHom
                  (Ideal.Quotient.mk (Ideal.span {chartEquation m n R i j F}))) := by
  rw [affineChartQuotientXHom_eq_equiv_comp_includeLeft_mk]
  have hcomp :
      ofHom
          ((standardChartQuotientEquivAffineQuotient (R := R) (i := i) (j := j) F).toRingHom.comp
            ((Ideal.Quotient.mk (Ideal.span {chartEquation m n R i j F})).comp
              (Algebra.TensorProduct.includeLeftRingHom
                  (R := R)
                  (A := ProjectiveSpace.StandardChartRing m R i)
                  (B := ProjectiveSpace.StandardChartRing n R j)))) =
        (ofHom
            (Algebra.TensorProduct.includeLeftRingHom
                (R := R)
                (A := ProjectiveSpace.StandardChartRing m R i)
                (B := ProjectiveSpace.StandardChartRing n R j)) ≫
              ofHom
                (Ideal.Quotient.mk (Ideal.span {chartEquation m n R i j F}))) ≫
          ofHom
            (standardChartQuotientEquivAffineQuotient (R := R) (i := i) (j := j) F).toRingHom := by
    ext a
    rfl
  rw [hcomp, Spec.map_comp]

set_option backward.isDefEq.respectTransparency false in
theorem chartQuotient_to_projective_fst_eq
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F) :
    let I := Ideal.span {chartEquation m n R i j F}
    Spec.map
          (ofHom
            (standardChartQuotientEquivAffineQuotient (R := R) (i := i) (j := j) F).symm.toRingHom) ≫
        (chartZeroLocusIsoSpecAffineQuotient m n R i j F).inv ≫
          chartZeroLocusToGlobal m n R F hF i j ≫ biprojectiveZeroLocusFst m n R F =
      Spec.map
          (ofHom
              (Algebra.TensorProduct.includeLeftRingHom
                  (R := R)
                  (A := ProjectiveSpace.StandardChartRing m R i)
                  (B := ProjectiveSpace.StandardChartRing n R j)) ≫
                ofHom (Ideal.Quotient.mk I)) ≫
        ProjectiveSpace.standardChartι m R i := by
  intro I
  have h_inv :
      (chartZeroLocusIsoSpecAffineQuotient m n R i j F).inv ≫
          chartZeroLocusToGlobal m n R F hF i j ≫ biprojectiveZeroLocusFst m n R F =
        Spec.map (ofHom (affineChartQuotientXHom m n R i j F)) ≫
          ProjectiveSpace.standardChartι m R i := by
    have h := chartZeroLocusIsoSpecAffineQuotient_hom_fst m n R F hF i j
    rw [← cancel_epi (chartZeroLocusIsoSpecAffineQuotient m n R i j F).hom]
    simpa [Category.assoc, Iso.hom_inv_id_assoc] using h.symm
  calc
    Spec.map
          (ofHom
            (standardChartQuotientEquivAffineQuotient (R := R) (i := i) (j := j) F).symm.toRingHom) ≫
        (chartZeroLocusIsoSpecAffineQuotient m n R i j F).inv ≫
          chartZeroLocusToGlobal m n R F hF i j ≫ biprojectiveZeroLocusFst m n R F
        = Spec.map
              (ofHom
                (standardChartQuotientEquivAffineQuotient (R := R) (i := i) (j := j) F).symm.toRingHom) ≫
            (Spec.map (ofHom (affineChartQuotientXHom m n R i j F)) ≫
              ProjectiveSpace.standardChartι m R i) := by
            rw [← Category.assoc, Category.assoc (Spec.map _), h_inv]
    _ = Spec.map
            (ofHom
              (standardChartQuotientEquivAffineQuotient (R := R) (i := i) (j := j) F).symm.toRingHom) ≫
          Spec.map
              (ofHom
                (standardChartQuotientEquivAffineQuotient (R := R) (i := i) (j := j) F).toRingHom) ≫
            Spec.map
                (ofHom
                    (Algebra.TensorProduct.includeLeftRingHom
                        (R := R)
                        (A := ProjectiveSpace.StandardChartRing m R i)
                        (B := ProjectiveSpace.StandardChartRing n R j)) ≫
                      ofHom (Ideal.Quotient.mk I)) ≫
              ProjectiveSpace.standardChartι m R i := by
            rw [Spec_map_affineChartQuotientXHom, Category.assoc]
    _ = Spec.map
            (ofHom
                (Algebra.TensorProduct.includeLeftRingHom
                    (R := R)
                    (A := ProjectiveSpace.StandardChartRing m R i)
                    (B := ProjectiveSpace.StandardChartRing n R j)) ≫
                  ofHom (Ideal.Quotient.mk I)) ≫
          ProjectiveSpace.standardChartι m R i := by
            have h_id :
                Spec.map
                      (ofHom
                        (standardChartQuotientEquivAffineQuotient
                          (R := R) (i := i) (j := j) F).symm.toRingHom) ≫
                    Spec.map
                      (ofHom
                        (standardChartQuotientEquivAffineQuotient
                          (R := R) (i := i) (j := j) F).toRingHom) =
                  𝟙 _ := by
              let e := standardChartQuotientEquivAffineQuotient
                (R := R) (i := i) (j := j) F
              rw [← Spec.map_comp]
              have he : ofHom e.toRingHom ≫ ofHom e.symm.toRingHom = 𝟙 _ :=
                e.toCommRingCatIso.hom_inv_id
              rw [he, Spec.map_id]
            rw [← Category.assoc (Spec.map _), h_id, Category.id_comp]

end BiprojectiveSpace

open BiprojectiveSpace

/-- A pullback square remains a pullback after both base legs are postcomposed with a mono. -/
theorem fstJacobian_isPullback_comp_mono
    {C : Type*} [Category C] {P X Y V B : C} {fst : P ⟶ X} {snd : P ⟶ Y}
    {f : X ⟶ V} {g : Y ⟶ V} (h : IsPullback fst snd f g) (u : V ⟶ B) [Mono u] :
    IsPullback fst snd (f ≫ u) (g ≫ u) := by
  refine IsPullback.of_isLimit' ⟨by rw [← Category.assoc, ← Category.assoc, h.w]⟩
    (Limits.PullbackCone.isLimitAux' _ fun s => ?_)
  have hs : (Limits.PullbackCone.fst s) ≫ f = (Limits.PullbackCone.snd s) ≫ g := by
    rw [← cancel_mono u, Category.assoc, Category.assoc]
    exact s.condition
  refine ⟨h.lift (Limits.PullbackCone.fst s) (Limits.PullbackCone.snd s) hs,
    h.lift_fst _ _ _, h.lift_snd _ _ _, fun {m} hm₁ hm₂ => ?_⟩
  apply h.hom_ext
  · rw [h.lift_fst]
    exact hm₁
  · rw [h.lift_snd]
    exact hm₂

/-! ## The first residue polynomial is the equation of the base-changed chart -/

/-- The base-changed chart equation over `κ(x)` is the dehomogenization of the first residue
fibre polynomial. -/
theorem fstBaseChangedChartEquation_eq_chartDehomogenization_fstResidue
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : ProjectiveSpace 2 k) (i j : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i) :
    letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
      ProjectiveSpace.residueAlgebra 2 k x
    fstBaseChangedChartEquation (i := i) (j := j)
        (ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx) F =
      ProjectiveSpace.chartDehomogenization 2 ((ProjectiveSpace 2 k).residueField x) j
        (BiprojectiveSpace.fstResidueFiberPolynomial F x i hx) := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
    ProjectiveSpace.residueAlgebra 2 k x
  let K : Type u := (ProjectiveSpace 2 k).residueField x
  let xAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx
  let Q := BiprojectiveSpace.fstResidueFiberPolynomial F x i hx
  change tensorStandardChartEquivMvPolynomial 2 k K j
      (fstFiberChartMap (j := j) xAlg (chartEquation 2 2 k i j F)) =
    ProjectiveSpace.chartDehomogenization 2 K j Q
  have hmap :=
    BiprojectiveSpace.fstResidueFiberChartMap_chartEquation
      (m := 2) (n := 2) (R := k) F x i hx j
  rw [hmap]
  let φ : Fin 3 → K ⊗[k] ProjectiveSpace.StandardChartRing 2 k j := fun l =>
    Algebra.TensorProduct.includeRight
      (R := k) (A := K) (B := ProjectiveSpace.StandardChartRing 2 k j)
      (ProjectiveSpace.normalizedCoordinate 2 k j l)
  have hX (l : Fin 3) :
      tensorStandardChartEquivMvPolynomial 2 k K j (φ l) =
        ProjectiveSpace.chartDehomogenization 2 K j (MvPolynomial.X l) := by
    dsimp [φ]
    by_cases hl : l = j
    · rw [hl, ProjectiveSpace.normalizedCoordinate_self,
        ProjectiveSpace.chartDehomogenization_X_self]
      have h1 : ((1 : K) ⊗ₜ[k] (1 : ProjectiveSpace.StandardChartRing 2 k j)) =
          algebraMap K (K ⊗[k] ProjectiveSpace.StandardChartRing 2 k j) 1 := by
        rw [Algebra.TensorProduct.algebraMap_apply]
        simp
      rw [h1, AlgEquiv.commutes, map_one]
    · obtain ⟨r, hr⟩ := Fin.exists_succAbove_eq hl
      rw [← hr, ProjectiveSpace.chartDehomogenization_X_succAbove]
      change (MvPolynomial.algebraTensorAlgEquiv k K)
          ((Algebra.TensorProduct.congr (AlgEquiv.refl (R := k) (A₁ := K))
            (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j))
            ((1 : K) ⊗ₜ[k]
              ProjectiveSpace.normalizedCoordinate 2 k j (j.succAbove r))) = MvPolynomial.X r
      rw [Algebra.TensorProduct.congr_apply, Algebra.TensorProduct.map_tmul]
      convert MvPolynomial.algebraTensorAlgEquiv_tmul (R := k) (A := K) (1 : K)
        (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j
          (ProjectiveSpace.normalizedCoordinate 2 k j (j.succAbove r))) using 2
      · simp
      · rw [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
        simp [MvPolynomial.map_X, one_smul]
  have hagree :
      (tensorStandardChartEquivMvPolynomial 2 k K j).toAlgHom.comp (MvPolynomial.aeval φ) =
        ProjectiveSpace.chartDehomogenization 2 K j := by
    refine MvPolynomial.algHom_ext fun l => ?_
    simp only [AlgHom.comp_apply, MvPolynomial.aeval_X]
    exact hX l
  have hφ : (fun l =>
      Algebra.TensorProduct.includeRight
        (R := k) (A := K) (B := ProjectiveSpace.StandardChartRing 2 k j)
        (ProjectiveSpace.normalizedCoordinate 2 k j l)) = φ := rfl
  rw [hφ]
  exact congrArg
    (fun ψ : MvPolynomial (Fin 3) K →ₐ[K] MvPolynomial (Fin 2) K => ψ Q) hagree

/-! ## Degree-three homogeneous chart algebra -/

variable {K : Type u} [Field K]

/-- Evaluation of a free partial of a dehomogenized cubic. -/
theorem eval_pderiv_chartDehomogenization_three
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 3)
    (v : Fin 3 → K) (i : Fin 3) (hvi : v i ≠ 0) (r : Fin 2) :
    MvPolynomial.eval (affineCoords v i hvi)
        (MvPolynomial.pderiv r (ProjectiveSpace.chartDehomogenization 2 K i Q)) =
      MvPolynomial.eval v (MvPolynomial.pderiv (i.succAbove r) Q) * (v i)⁻¹ ^ 2 := by
  rw [pderiv_chartDehomogenization, eval_chartDehomogenization]
  have hp : (MvPolynomial.pderiv (i.succAbove r) Q).IsHomogeneous 2 := hQ.pderiv
  have h := eval_smul_point_of_isHomogeneous hp (v i)⁻¹ v
  have hv : (fun j => (v i)⁻¹ * v j) = fun j => v j * (v i)⁻¹ := by
    funext j
    ring
  rw [hv] at h
  rw [h]
  ring

/-- Degree-three version of `nonsingular_of_smooth_dehomogenized_charts`. -/
theorem nonsingular_cubic_of_smooth_dehomogenized_charts
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 3) (hQ0 : Q ≠ 0)
    (hsm : ∀ i : Fin 3,
      RingHom.Smooth
        (algebraMap K
          (MvPolynomial (Fin 2) K ⧸
            Ideal.span {ProjectiveSpace.chartDehomogenization 2 K i Q})))
    (v : Fin 3 → K) (hv0 : v ≠ 0) (hQv : MvPolynomial.eval v Q = 0) :
    ∃ j : Fin 3, MvPolynomial.eval v (MvPolynomial.pderiv j Q) ≠ 0 := by
  classical
  obtain ⟨i, hvi⟩ : ∃ i, v i ≠ 0 := by
    by_contra h
    push Not at h
    exact hv0 (funext h)
  set f := ProjectiveSpace.chartDehomogenization 2 K i Q
  have hf0 : f ≠ 0 := chartDehomogenization_ne_zero_of_isHomogeneous Q 3 hQ hQ0 i
  have ha : MvPolynomial.aeval (affineCoords v i hvi) f = 0 := by
    have h := eval_chartDehomogenization_eq_zero_of Q 3 hQ v i hvi hQv
    simpa [MvPolynomial.aeval_def] using h
  obtain ⟨r, hr⟩ := Hypersurface.exists_pderiv_ne_zero_at_of_smooth f hf0 (hsm i)
    (affineCoords v i hvi) ha
  refine ⟨i.succAbove r, ?_⟩
  intro hzero
  have hrel := eval_pderiv_chartDehomogenization_three Q hQ v i hvi r
  have hvan : MvPolynomial.eval (affineCoords v i hvi) (MvPolynomial.pderiv r f) = 0 := by
    rw [hrel, hzero, zero_mul]
  have hr' : MvPolynomial.eval (affineCoords v i hvi) (MvPolynomial.pderiv r f) ≠ 0 := by
    simpa [MvPolynomial.aeval_def] using hr
  exact hr' hvan

/-! ## Smooth first fibres give smooth cubic charts -/

set_option maxHeartbeats 4000000 in
/-- Each affine dehomogenization of the first residue-fibre polynomial is smooth when the
scheme-theoretic first-projection fibre is smooth. -/
theorem ringHom_smooth_chartDehomogenization_fstResidue_of_smooth_fiber
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (x : ProjectiveSpace 2 k) (i j : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i)
    (hsmooth : Smooth ((biprojectiveZeroLocusFst 2 2 k F).fiberToSpecResidueField x))
    (_hQ0 : BiprojectiveSpace.fstResidueFiberPolynomial F x i hx ≠ 0) :
    letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
      ProjectiveSpace.residueAlgebra 2 k x
    RingHom.Smooth
      (algebraMap ((ProjectiveSpace 2 k).residueField x)
        (MvPolynomial (Fin 2) ((ProjectiveSpace 2 k).residueField x) ⧸
          Ideal.span {ProjectiveSpace.chartDehomogenization 2
            ((ProjectiveSpace 2 k).residueField x) j
            (BiprojectiveSpace.fstResidueFiberPolynomial F x i hx)})) := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
    ProjectiveSpace.residueAlgebra 2 k x
  let A : Type u := (ProjectiveSpace 2 k).residueField x
  let t : Spec (.of A) ⟶ ProjectiveSpace 2 k :=
    (ProjectiveSpace 2 k).fromSpecResidueField x
  let ψ : Spec (.of A) ⟶ Spec (.of A) := 𝟙 _
  let xAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx
  have hxt : Spec.map (ofHom xAlg.toRingHom) ≫ ProjectiveSpace.standardChartι 2 k i = t := by
    have hlift := ProjectiveSpace.standardChartResidueLift_standardChartι 2 k x i hx
    have hφ : Spec.map (ofHom xAlg.toRingHom) =
        ProjectiveSpace.standardChartResidueLift 2 k x i hx := by
      have hpre : ofHom xAlg.toRingHom =
          Spec.preimage (ProjectiveSpace.standardChartResidueLift 2 k x i hx) := by
        ext a
        change xAlg.toRingHom a =
          ProjectiveSpace.standardChartResidueRingHom 2 k x i hx a
        rfl
      rw [hpre, Spec.map_preimage]
    rw [hφ, hlift]
  let I : Ideal (StandardChartRing 2 2 k i j) :=
    Ideal.span {chartEquation 2 2 k i j F}
  let q := fstFiberChartMap (j := j) xAlg (chartEquation 2 2 k i j F)
  let g : MvPolynomial (Fin 2) A :=
    fstBaseChangedChartEquation (i := i) (j := j) xAlg F
  have hImap : I.map (fstFiberChartMap (j := j) xAlg).toRingHom = Ideal.span {q} :=
    map_span_chartEquation_eq_span_fstFiber (j := j) xAlg F
  have hpb0 := isPullback_SpecMap_fstChartQuotient
    (R := k) (K := A) (i := i) (j := j) xAlg I
  haveI : Mono (ProjectiveSpace.standardChartι 2 k i) := inferInstance
  have hpb1 := fstJacobian_isPullback_comp_mono hpb0 (ProjectiveSpace.standardChartι 2 k i)
  let eRing := standardChartQuotientEquivAffineQuotient (R := k) (i := i) (j := j) F
  let c : Spec (.of (StandardChartRing 2 2 k i j ⧸ I)) ⟶
      biprojectiveZeroLocus 2 2 k F :=
    Spec.map eRing.symm.toCommRingCatIso.hom ≫
      (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv ≫
        chartZeroLocusToGlobal 2 2 k F hF i j
  haveI : IsOpenImmersion c := by
    dsimp [c]
    infer_instance
  have hcρ : c ≫ biprojectiveZeroLocusFst 2 2 k F =
      Spec.map
          (ofHom
              (Algebra.TensorProduct.includeLeftRingHom
                  (R := k)
                  (A := ProjectiveSpace.StandardChartRing 2 k i)
                  (B := ProjectiveSpace.StandardChartRing 2 k j)) ≫
                ofHom (Ideal.Quotient.mk I)) ≫
        ProjectiveSpace.standardChartι 2 k i := by
    dsimp [c]
    convert chartQuotient_to_projective_fst_eq (i := i) (j := j) F hF using 1
    · simp only [Category.assoc]
      rfl
  have hpb2 : IsPullback
      (Spec.map
        (ofHom
          (Algebra.TensorProduct.includeLeftRingHom
              (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k j)) ≫
            ofHom
              (Ideal.Quotient.mk (I.map (fstFiberChartMap (j := j) xAlg).toRingHom))))
      (Spec.map
        (ofHom
          (Ideal.Quotient.lift I
            ((Ideal.Quotient.mk (I.map (fstFiberChartMap (j := j) xAlg).toRingHom)).comp
              (fstFiberChartMap (j := j) xAlg).toRingHom)
            (fun _ ha => Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_map_of_mem _ ha)))))
      (ψ ≫ t)
      (c ≫ biprojectiveZeroLocusFst 2 2 k F) := by
    have hψt : ψ ≫ t = Spec.map (ofHom xAlg.toRingHom) ≫
        ProjectiveSpace.standardChartι 2 k i := by
      change 𝟙 _ ≫ t = _
      rw [Category.id_comp, hxt]
    rw [hψt, hcρ]
    exact hpb1
  have hpb3 := hpb2.flip
  let rmap :=
    pullback.map (c ≫ biprojectiveZeroLocusFst 2 2 k F) (ψ ≫ t)
      (biprojectiveZeroLocusFst 2 2 k F) t c ψ (𝟙 _) (by simp) (by simp)
  let r0 := hpb3.isoPullback.hom ≫ rmap
  haveI : IsOpenImmersion r0 := by
    dsimp [r0, rmap]
    infer_instance
  have hr0 : r0 ≫ Limits.pullback.snd (biprojectiveZeroLocusFst 2 2 k F) t =
      Spec.map
          (CommRingCat.ofHom
            (Algebra.TensorProduct.includeLeftRingHom
                (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k j)) ≫
              CommRingCat.ofHom
                (Ideal.Quotient.mk
                  (I.map (fstFiberChartMap (j := j) xAlg).toRingHom))) ≫
        ψ := by
    dsimp [r0, rmap]
    rw [Category.assoc, Limits.pullback.lift_snd, ← Category.assoc]
    congr 1
    exact hpb3.isoPullback_hom_snd
  let eW := conicChartQuotientEquivMvPolynomial 2 k A j q
  let eI := Ideal.quotEquivOfEq hImap
  let eFull := eI.trans eW.toRingEquiv
  let r : Spec (CommRingCat.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})) ⟶
      Limits.pullback (biprojectiveZeroLocusFst 2 2 k F) t :=
    Spec.map eFull.toCommRingCatIso.hom ≫ r0
  haveI : IsIso (Spec.map eFull.toCommRingCatIso.hom) := inferInstance
  haveI : IsOpenImmersion (Spec.map eFull.toCommRingCatIso.hom) := inferInstance
  haveI : IsOpenImmersion r :=
    IsOpenImmersion.comp (Spec.map eFull.toCommRingCatIso.hom) r0
  have hr : r ≫ Limits.pullback.snd (biprojectiveZeroLocusFst 2 2 k F) t =
      Spec.map (CommRingCat.ofHom
        ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ ψ := by
    dsimp only [r]
    rw [Category.assoc, hr0]
    rw [← Category.assoc]
    congr 1
    rw [← Spec.map_comp]
    congr 1
    ext a
    change eFull
        (Ideal.Quotient.mk (I.map (fstFiberChartMap (j := j) xAlg).toRingHom)
          (Algebra.TensorProduct.includeLeftRingHom
            (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k j) a)) =
      Ideal.Quotient.mk (Ideal.span {g}) (MvPolynomial.C a)
    have hinc :
        Algebra.TensorProduct.includeLeftRingHom
          (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k j) a =
        algebraMap A (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k j) a := rfl
    rw [hinc]
    set a' := algebraMap A (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k j) a with ha'
    change eW
        (eI (Ideal.Quotient.mk (I.map (fstFiberChartMap (j := j) xAlg).toRingHom) a')) =
      Ideal.Quotient.mk (Ideal.span {g}) (MvPolynomial.C a)
    have heI :
        eI (Ideal.Quotient.mk (I.map (fstFiberChartMap (j := j) xAlg).toRingHom) a') =
          Ideal.Quotient.mk (Ideal.span {q}) a' :=
      Ideal.quotEquivOfEq_mk hImap a'
    rw [heI]
    have hcomm := eW.commutes a
    convert hcomm using 1
    · rfl
    · change Ideal.Quotient.mk (Ideal.span {g}) (MvPolynomial.C a) =
        algebraMap A
          (MvPolynomial (Fin 2) A ⧸
            Ideal.span {tensorStandardChartEquivMvPolynomial 2 k A j q}) a
      rfl
  haveI : Smooth (Limits.pullback.snd (biprojectiveZeroLocusFst 2 2 k F) t) := by
    change Smooth ((biprojectiveZeroLocusFst 2 2 k F).fiberToSpecResidueField x)
    exact hsmooth
  haveI : Smooth r := inferInstance
  haveI hstrSmooth :
      Smooth (Spec.map (CommRingCat.ofHom
        ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ ψ) := by
    have hcomp : Smooth
        (r ≫ Limits.pullback.snd (biprojectiveZeroLocusFst 2 2 k F) t) :=
      inferInstance
    rwa [hr] at hcomp
  haveI : Smooth (Spec.map (CommRingCat.ofHom
      ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C))) := by
    change Smooth (Spec.map (CommRingCat.ofHom
      ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ 𝟙 _)
    exact hstrSmooth
  have hR : RingHom.Smooth
      ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C) :=
    (HasRingHomProperty.Spec_iff (P := @Smooth)).mp ‹_›
  have hgf : g =
      ProjectiveSpace.chartDehomogenization 2 A j
        (BiprojectiveSpace.fstResidueFiberPolynomial F x i hx) :=
    fstBaseChangedChartEquation_eq_chartDehomogenization_fstResidue F x i j hx
  have heq :
      algebraMap A
          (MvPolynomial (Fin 2) A ⧸
            Ideal.span
              {ProjectiveSpace.chartDehomogenization 2 A j
                (BiprojectiveSpace.fstResidueFiberPolynomial F x i hx)}) =
        (Ideal.Quotient.mk
            (Ideal.span
              {ProjectiveSpace.chartDehomogenization 2 A j
                (BiprojectiveSpace.fstResidueFiberPolynomial F x i hx)})).comp
          MvPolynomial.C := rfl
  rw [heq, ← hgf]
  exact hR

/-- A smooth first-projection fibre has a Jacobian-nonsingular cubic residue equation. -/
theorem nonsingular_fstResidueFiberPolynomial_of_smooth
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i)
    (hsmooth : Smooth ((biprojectiveZeroLocusFst 2 2 k F).fiberToSpecResidueField x))
    (hQ0 : BiprojectiveSpace.fstResidueFiberPolynomial F x i hx ≠ 0)
    (v : Fin 3 → (ProjectiveSpace 2 k).residueField x) (hv0 : v ≠ 0)
    (hQv : MvPolynomial.eval v (BiprojectiveSpace.fstResidueFiberPolynomial F x i hx) = 0) :
    ∃ j, MvPolynomial.eval v
      (MvPolynomial.pderiv j (BiprojectiveSpace.fstResidueFiberPolynomial F x i hx)) ≠ 0 := by
  set Q := BiprojectiveSpace.fstResidueFiberPolynomial F x i hx
  have hQ : Q.IsHomogeneous 3 :=
    BiprojectiveSpace.fstResidueFiberPolynomial_isHomogeneous (d := 2) (e := 3) hF x i hx
  have hsm : ∀ j : Fin 3,
      RingHom.Smooth
        (algebraMap ((ProjectiveSpace 2 k).residueField x)
          (MvPolynomial (Fin 2) ((ProjectiveSpace 2 k).residueField x) ⧸
            Ideal.span {ProjectiveSpace.chartDehomogenization 2
              ((ProjectiveSpace 2 k).residueField x) j Q})) := by
    intro j
    exact ringHom_smooth_chartDehomogenization_fstResidue_of_smooth_fiber
      F hF x i j hx hsmooth hQ0
  exact nonsingular_cubic_of_smooth_dehomogenized_charts Q hQ hQ0 hsm v hv0 hQv

end

end BConicBundleMultisections
