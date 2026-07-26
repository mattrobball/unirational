/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveTwoEquationAffine
public import BConicBundleMultisections.FirstProjectionJacobian
public import BConicBundleMultisections.PlaneCurveIntersectionArtinian
public import Mathlib.RingTheory.Polynomial.GaussLemma

/-!
# Artinian generic fibres of target relations

This file combines the explicit two-equation product charts with the first-projection base-change
square.  One endpoint is deliberately effective: the three affine charts of the projective plane
intersection are required to be coprime over the opposite coordinate's fraction field in both
coordinate orders.  A stronger factor-theoretic endpoint only asks that the second equation on
each chart be a unit, or be irreducible and not divide the first equation.  Resultants handle the
nonconstant elimination cases; if both equations omit one coordinate, univariate Bezout makes the
chart quotient zero.

No projective Bezout or unformalized ``no common component'' principle is used here.  Passing from
the original homogeneous hypotheses to irreducibility and nondivisibility after the generic
coefficient extension remains a separate algebraic input.
-/

@[expose] public section

open CategoryTheory Limits Topology TopologicalSpace
open scoped AlgebraicGeometry TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry CommRingCat MvPolynomial PlaneCurveIntersectionArtinian

attribute [local instance] MvPolynomial.gradedAlgebra

namespace BiprojectiveSpace

variable {m n : ℕ} {R K : Type u} [CommRing R] [CommRing K] [Algebra R K]
variable {i : Fin (m + 1)} {j : Fin (n + 1)}

/-! ## Two-equation quotient charts over the first factor -/

/-- The two-generated ideal in the tensor-product coordinate ring of a standard product chart. -/
def twoEquationStandardChartIdeal
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R) :
    Ideal (StandardChartRing m n R i j) :=
  Ideal.span
    ({chartEquation m n R i j F, chartEquation m n R i j G} :
      Set (StandardChartRing m n R i j))

/-- The tensor-product quotient and ordinary affine-polynomial quotient presentations agree. -/
noncomputable def twoEquationStandardChartQuotientEquivAffineQuotient
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (StandardChartRing m n R i j ⧸
      twoEquationStandardChartIdeal m n R i j F G) ≃+*
      (MvPolynomial (Fin m ⊕ Fin n) R ⧸
        twoEquationAffineChartIdeal m n R i j F G) :=
  Ideal.quotientEquiv _ _
    (standardChartRingEquivMvPolynomial m n R i j).toRingEquiv <| by
      symm
      unfold twoEquationStandardChartIdeal twoEquationAffineChartIdeal
      rw [Ideal.map_span, Set.image_pair]
      have hF :
          (standardChartRingEquivMvPolynomial m n R i j).toRingEquiv
              (chartEquation m n R i j F) =
            affineChartEquation m n R i j F := by
        simpa using standardChartRingEquivMvPolynomial_chartEquation m n R i j F
      have hG :
          (standardChartRingEquivMvPolynomial m n R i j).toRingEquiv
              (chartEquation m n R i j G) =
            affineChartEquation m n R i j G := by
        simpa using standardChartRingEquivMvPolynomial_chartEquation m n R i j G
      change Ideal.span
          ({(standardChartRingEquivMvPolynomial m n R i j).toRingEquiv
                (chartEquation m n R i j F),
              (standardChartRingEquivMvPolynomial m n R i j).toRingEquiv
                (chartEquation m n R i j G)} :
            Set (MvPolynomial (Fin m ⊕ Fin n) R)) = _
      rw [hF, hG]

/-- The first-factor chart ring maps to the ordinary affine two-equation quotient. -/
def twoEquationAffineChartQuotientXHom
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R) :
    ProjectiveSpace.StandardChartRing m R i →+*
      (MvPolynomial (Fin m ⊕ Fin n) R ⧸
        twoEquationAffineChartIdeal m n R i j F G) :=
  ((Ideal.Quotient.mk (twoEquationAffineChartIdeal m n R i j F G)).comp
      (standardChartRingEquivMvPolynomial m n R i j).toRingHom).comp
    (Algebra.TensorProduct.includeLeftRingHom
      (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
      (B := ProjectiveSpace.StandardChartRing n R j))

@[reassoc]
theorem twoEquationChartSubschemeCover_comp_isoSpecAffineQuotient
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (twoEquationChartIdealSheaf m n R i j F G).subschemeCover.f
        (chartTopAffineOpen m n R i j) ≫
      (twoEquationChartIsoSpecAffineQuotient m n R i j F G).hom =
    Spec.map
      (twoEquationChartQuotientEquivMvPolynomial
        m n R i j F G).symm.toCommRingCatIso.hom := by
  unfold twoEquationChartIsoSpecAffineQuotient
  simp
  rfl

set_option backward.isDefEq.respectTransparency false in
/-- Under the explicit affine presentation, projection to the first factor is induced by the
left tensor-factor inclusion followed by the quotient map. -/
theorem twoEquationChartIsoSpecAffineQuotient_hom_fst
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (twoEquationChartIsoSpecAffineQuotient m n R i j F G).hom ≫
        Spec.map (ofHom
          (twoEquationAffineChartQuotientXHom m n R i j F G)) ≫
        ProjectiveSpace.standardChartι m R i =
      (twoEquationChartIdealSheaf m n R i j F G).subschemeι ≫
        standardChartι m n R i j ≫ BiprojectiveSpace.fst m n R := by
  rw [← cancel_epi
    ((twoEquationChartIdealSheaf m n R i j F G).subschemeCover.f
      (chartTopAffineOpen m n R i j))]
  rw [← Category.assoc,
    twoEquationChartSubschemeCover_comp_isoSpecAffineQuotient]
  rw [← Category.assoc, ← Spec.map_comp]
  rw [subschemeCover_map_subschemeι_fromSpec]
  rw [← standardChartIsoSpec_hom_fst]
  rw [chartTopAffineOpen_fromSpec_comp_standardChartIsoSpec_assoc]
  simp only [← Spec.map_comp_assoc]
  congr 1
  rw [Spec.map_injective.eq_iff]
  ext a
  change (twoEquationChartQuotientEquivMvPolynomial m n R i j F G).symm
      (twoEquationAffineChartQuotientXHom m n R i j F G a) =
    Ideal.Quotient.mk _ ((standardChartΓIso m n R i j).inv
      (Algebra.TensorProduct.includeLeftRingHom
        (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
        (B := ProjectiveSpace.StandardChartRing n R j) a))
  apply (twoEquationChartQuotientEquivMvPolynomial m n R i j F G).injective
  rw [RingEquiv.apply_symm_apply]
  unfold twoEquationChartQuotientEquivMvPolynomial
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

/-- The affine quotient's first-factor map is the tensor inclusion and quotient map transported
through the quotient equivalence. -/
theorem twoEquationAffineChartQuotientXHom_eq_equiv_comp_includeLeft_mk
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R) :
    twoEquationAffineChartQuotientXHom m n R i j F G =
      (twoEquationStandardChartQuotientEquivAffineQuotient
        m n R i j F G).toRingHom.comp
        ((Ideal.Quotient.mk
          (twoEquationStandardChartIdeal m n R i j F G)).comp
          (Algebra.TensorProduct.includeLeftRingHom
            (R := R)
            (A := ProjectiveSpace.StandardChartRing m R i)
            (B := ProjectiveSpace.StandardChartRing n R j))) := by
  ext a
  unfold twoEquationAffineChartQuotientXHom
    twoEquationStandardChartQuotientEquivAffineQuotient
  simp only [RingHom.comp_apply, Ideal.quotientEquiv_mk,
    RingEquiv.toRingHom_eq_coe, RingEquiv.coe_toRingHom, AlgEquiv.coe_ringEquiv]

/-- Scheme-level form of the preceding first-factor ring-map identity. -/
theorem Spec_map_twoEquationAffineChartQuotientXHom
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R) :
    Spec.map (ofHom
      (twoEquationAffineChartQuotientXHom m n R i j F G)) =
      Spec.map (ofHom
        (twoEquationStandardChartQuotientEquivAffineQuotient
          m n R i j F G).toRingHom) ≫
      Spec.map
        (ofHom
          (Algebra.TensorProduct.includeLeftRingHom
            (R := R)
            (A := ProjectiveSpace.StandardChartRing m R i)
            (B := ProjectiveSpace.StandardChartRing n R j)) ≫
          ofHom (Ideal.Quotient.mk
            (twoEquationStandardChartIdeal m n R i j F G))) := by
  rw [twoEquationAffineChartQuotientXHom_eq_equiv_comp_includeLeft_mk]
  rw [show ofHom
      ((twoEquationStandardChartQuotientEquivAffineQuotient
          m n R i j F G).toRingHom.comp
        ((Ideal.Quotient.mk
          (twoEquationStandardChartIdeal m n R i j F G)).comp
          (Algebra.TensorProduct.includeLeftRingHom
            (R := R)
            (A := ProjectiveSpace.StandardChartRing m R i)
            (B := ProjectiveSpace.StandardChartRing n R j)))) =
      (ofHom
        (Algebra.TensorProduct.includeLeftRingHom
          (R := R)
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)) ≫
        ofHom (Ideal.Quotient.mk
          (twoEquationStandardChartIdeal m n R i j F G))) ≫
        ofHom (twoEquationStandardChartQuotientEquivAffineQuotient
          m n R i j F G).toRingHom by rfl]
  rw [Spec.map_comp]

/-! ## The quotient chart as an open of the global two-equation intersection -/

/-- The local two-equation chart maps to the global complete intersection through the canonical
pullback of the standard product chart. -/
noncomputable def twoEquationChartToGlobal
    (m n : ℕ) (R : Type u) [CommRing R]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (twoEquationChartIdealSheaf m n R i j F G).subscheme ⟶
      twoEquationBiprojectiveZeroLocus m n R F G :=
  (twoEquationChartIsoPullback m n R F G hF hG i j).hom ≫
    pullback.snd (standardChartι m n R i j)
      (twoEquationBiprojectiveι m n R F G)

instance twoEquationChartToGlobal_isOpenImmersion
    (m n : ℕ) (R : Type u) [CommRing R]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    IsOpenImmersion (twoEquationChartToGlobal m n R F G hF hG i j) := by
  unfold twoEquationChartToGlobal
  infer_instance

@[reassoc]
theorem twoEquationChartToGlobal_comp_ι
    (m n : ℕ) (R : Type u) [CommRing R]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    twoEquationChartToGlobal m n R F G hF hG i j ≫
        twoEquationBiprojectiveι m n R F G =
      (twoEquationChartIdealSheaf m n R i j F G).subschemeι ≫
        standardChartι m n R i j := by
  unfold twoEquationChartToGlobal
  rw [Category.assoc, ← pullback.condition]
  rw [← Category.assoc,
    twoEquationChartIsoPullback_hom_fst]

/-- The local chart has exactly the preimage of the ambient standard product chart as its
underlying range in the complete intersection. -/
theorem range_twoEquationChartToGlobal
    (m n : ℕ) (R : Type u) [CommRing R]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    Set.range (twoEquationChartToGlobal m n R F G hF hG i j).base =
      (twoEquationBiprojectiveι m n R F G).base ⁻¹'
        Set.range (standardChartι m n R i j).base := by
  unfold twoEquationChartToGlobal
  have hiso : Function.Surjective
      (twoEquationChartIsoPullback m n R F G hF hG i j).hom.base :=
    Scheme.Hom.surjective _
  change Set.range
      ((pullback.snd (standardChartι m n R i j)
        (twoEquationBiprojectiveι m n R F G)).base ∘
        (twoEquationChartIsoPullback m n R F G hF hG i j).hom.base) = _
  rw [Function.Surjective.range_comp hiso]
  exact Scheme.Pullback.range_snd _ _

/-- The tensor-coordinate quotient chart as an open subscheme of the global complete
intersection. -/
noncomputable def twoEquationStandardQuotientToGlobal
    (m n : ℕ) (R : Type u) [CommRing R]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    Spec (.of (StandardChartRing m n R i j ⧸
      twoEquationStandardChartIdeal m n R i j F G)) ⟶
      twoEquationBiprojectiveZeroLocus m n R F G :=
  Spec.map
      (twoEquationStandardChartQuotientEquivAffineQuotient
        m n R i j F G).symm.toCommRingCatIso.hom ≫
    (twoEquationChartIsoSpecAffineQuotient m n R i j F G).inv ≫
      twoEquationChartToGlobal m n R F G hF hG i j

instance twoEquationStandardQuotientToGlobal_isOpenImmersion
    (m n : ℕ) (R : Type u) [CommRing R]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    IsOpenImmersion
      (twoEquationStandardQuotientToGlobal m n R F G hF hG i j) := by
  unfold twoEquationStandardQuotientToGlobal
  infer_instance

/-- Passing to either explicit quotient presentation does not change the chart's underlying
range. -/
theorem range_twoEquationStandardQuotientToGlobal
    (m n : ℕ) (R : Type u) [CommRing R]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    Set.range
        (twoEquationStandardQuotientToGlobal m n R F G hF hG i j).base =
      (twoEquationBiprojectiveι m n R F G).base ⁻¹'
        Set.range (standardChartι m n R i j).base := by
  unfold twoEquationStandardQuotientToGlobal
  have hRing : Function.Surjective
      (Spec.map
        (twoEquationStandardChartQuotientEquivAffineQuotient
          m n R i j F G).symm.toCommRingCatIso.hom).base :=
    Scheme.Hom.surjective _
  have hChart : Function.Surjective
      (twoEquationChartIsoSpecAffineQuotient m n R i j F G).inv.base :=
    Scheme.Hom.surjective _
  change Set.range
      (((twoEquationChartToGlobal m n R F G hF hG i j).base ∘
        (twoEquationChartIsoSpecAffineQuotient m n R i j F G).inv.base) ∘
        (Spec.map
          (twoEquationStandardChartQuotientEquivAffineQuotient
            m n R i j F G).symm.toCommRingCatIso.hom).base) = _
  rw [Function.Surjective.range_comp hRing]
  rw [Function.Surjective.range_comp hChart]
  exact range_twoEquationChartToGlobal m n R F G hF hG i j

set_option backward.isDefEq.respectTransparency false in
/-- The tensor-coordinate quotient chart projects to the first projective factor through the
left tensor-factor inclusion and quotient map. -/
theorem twoEquationStandardQuotientToGlobal_comp_fst
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G) :
    twoEquationStandardQuotientToGlobal m n R F G hF hG i j ≫
        twoEquationBiprojectiveι m n R F G ≫
        BiprojectiveSpace.fst m n R =
      Spec.map
          (ofHom
            (Algebra.TensorProduct.includeLeftRingHom
              (R := R)
              (A := ProjectiveSpace.StandardChartRing m R i)
              (B := ProjectiveSpace.StandardChartRing n R j)) ≫
            ofHom (Ideal.Quotient.mk
              (twoEquationStandardChartIdeal m n R i j F G))) ≫
        ProjectiveSpace.standardChartι m R i := by
  have hlocal :
      (twoEquationChartIsoSpecAffineQuotient m n R i j F G).inv ≫
          (twoEquationChartIdealSheaf m n R i j F G).subschemeι ≫
          standardChartι m n R i j ≫ BiprojectiveSpace.fst m n R =
        Spec.map (ofHom
            (twoEquationAffineChartQuotientXHom m n R i j F G)) ≫
          ProjectiveSpace.standardChartι m R i := by
    rw [← cancel_epi
      (twoEquationChartIsoSpecAffineQuotient m n R i j F G).hom]
    simpa [Category.assoc, Iso.hom_inv_id_assoc] using
      (twoEquationChartIsoSpecAffineQuotient_hom_fst
        m n R i j F G).symm
  unfold twoEquationStandardQuotientToGlobal
  simp only [Category.assoc]
  rw [twoEquationChartToGlobal_comp_ι_assoc]
  rw [hlocal]
  rw [← Category.assoc,
    Spec_map_twoEquationAffineChartQuotientXHom]
  simp only [Category.assoc]
  have hcancel :
      Spec.map
          (twoEquationStandardChartQuotientEquivAffineQuotient
            m n R i j F G).symm.toCommRingCatIso.hom ≫
        Spec.map
          (ofHom (twoEquationStandardChartQuotientEquivAffineQuotient
            m n R i j F G).toRingHom) = 𝟙 _ := by
    rw [← Spec.map_comp]
    let e := twoEquationStandardChartQuotientEquivAffineQuotient
      m n R i j F G
    have he : ofHom e.toRingHom ≫ e.symm.toCommRingCatIso.hom = 𝟙 _ :=
      e.toCommRingCatIso.hom_inv_id
    rw [he, Spec.map_id]
  rw [← Category.assoc, hcancel, Category.id_comp]

/-! ## Base-changing a two-equation chart to a first-projection fibre -/

/-- Mapping a two-generated chart ideal along the first-fibre chart map maps its two explicit
generators. -/
theorem map_twoEquationStandardChartIdeal_fstFiber
    (x : ProjectiveSpace.StandardChartRing m R i →ₐ[R] K)
    (F G : MvPolynomial (BiprojectiveCoordinate m n) R) :
    Ideal.map (fstFiberChartMap (j := j) x).toRingHom
        (twoEquationStandardChartIdeal m n R i j F G) =
      Ideal.span
        ({fstFiberChartMap (j := j) x (chartEquation m n R i j F),
          fstFiberChartMap (j := j) x (chartEquation m n R i j G)} :
          Set (K ⊗[R] ProjectiveSpace.StandardChartRing n R j)) := by
  unfold twoEquationStandardChartIdeal
  rw [Ideal.map_span, Set.image_pair]
  rfl

set_option maxHeartbeats 4000000 in
-- The nested quotient pushout, pullback comparison, and exact range computation need extra time.
/-- Every standard second-factor chart of a first-projection fibre of a two-equation
biprojective intersection is the spectrum of the two specialized affine equations.

The range formula is what makes the three resulting charts an actual cover of the fibre; it is
not merely an abstract affine presentation. -/
theorem exists_openImmersion_twoEquationFstChart_into_fiber
    {k : Type u} [Field k]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (x : ProjectiveSpace 2 k) (i j : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i) :
    letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
      ProjectiveSpace.residueAlgebra 2 k x
    let A : Type u := (ProjectiveSpace 2 k).residueField x
    let f : MvPolynomial (Fin 2) A :=
      fstBaseChangedChartEquation (i := i) (j := j)
        (ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx) F
    let g : MvPolynomial (Fin 2) A :=
      fstBaseChangedChartEquation (i := i) (j := j)
        (ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx) G
    ∃ (r : Spec (.of (PlaneCurveIntersectionArtinian.affinePlaneIntersectionRing f g)) ⟶
        ((twoEquationBiprojectiveι 2 2 k F G ≫
          BiprojectiveSpace.fst 2 2 k).fiber x)),
      IsOpenImmersion r ∧
        Set.range r.base =
          ((twoEquationBiprojectiveι 2 2 k F G ≫
            BiprojectiveSpace.fst 2 2 k).fiberι x).base ⁻¹'
            Set.range
              (twoEquationStandardQuotientToGlobal
                2 2 k F G hF hG i j).base := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
    ProjectiveSpace.residueAlgebra 2 k x
  let A : Type u := (ProjectiveSpace 2 k).residueField x
  let p := twoEquationBiprojectiveι 2 2 k F G ≫ BiprojectiveSpace.fst 2 2 k
  let t : Spec (.of A) ⟶ ProjectiveSpace 2 k :=
    (ProjectiveSpace 2 k).fromSpecResidueField x
  let ψ : Spec (.of A) ⟶ Spec (.of A) := 𝟙 _
  let xAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx
  have hxt : Spec.map (ofHom xAlg.toRingHom) ≫
      ProjectiveSpace.standardChartι 2 k i = t := by
    have hlift := ProjectiveSpace.standardChartResidueLift_standardChartι
      2 k x i hx
    have hφ : Spec.map (ofHom xAlg.toRingHom) =
        ProjectiveSpace.standardChartResidueLift 2 k x i hx := by
      have hpre : ofHom xAlg.toRingHom =
          Spec.preimage
            (ProjectiveSpace.standardChartResidueLift 2 k x i hx) := by
        ext a
        change xAlg.toRingHom a =
          ProjectiveSpace.standardChartResidueRingHom 2 k x i hx a
        rfl
      rw [hpre, Spec.map_preimage]
    rw [hφ, hlift]
  let I : Ideal (StandardChartRing 2 2 k i j) :=
    twoEquationStandardChartIdeal 2 2 k i j F G
  let qF := fstFiberChartMap (j := j) xAlg
    (chartEquation 2 2 k i j F)
  let qG := fstFiberChartMap (j := j) xAlg
    (chartEquation 2 2 k i j G)
  let f : MvPolynomial (Fin 2) A :=
    fstBaseChangedChartEquation (i := i) (j := j) xAlg F
  let g : MvPolynomial (Fin 2) A :=
    fstBaseChangedChartEquation (i := i) (j := j) xAlg G
  have hImap : I.map (fstFiberChartMap (j := j) xAlg).toRingHom =
      Ideal.span ({qF, qG} : Set
        (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k j)) := by
    exact map_twoEquationStandardChartIdeal_fstFiber
      (j := j) xAlg F G
  have hpb0 := isPullback_SpecMap_fstChartQuotient
    (R := k) (K := A) (i := i) (j := j) xAlg I
  haveI : Mono (ProjectiveSpace.standardChartι 2 k i) := inferInstance
  have hpb1 := fstJacobian_isPullback_comp_mono hpb0
    (ProjectiveSpace.standardChartι 2 k i)
  let c : Spec (.of (StandardChartRing 2 2 k i j ⧸ I)) ⟶
      twoEquationBiprojectiveZeroLocus 2 2 k F G :=
    twoEquationStandardQuotientToGlobal 2 2 k F G hF hG i j
  haveI : IsOpenImmersion c := by
    dsimp [c]
    infer_instance
  have hcp : c ≫ p =
      Spec.map
          (ofHom
            (Algebra.TensorProduct.includeLeftRingHom
              (R := k)
              (A := ProjectiveSpace.StandardChartRing 2 k i)
              (B := ProjectiveSpace.StandardChartRing 2 k j)) ≫
            ofHom (Ideal.Quotient.mk I)) ≫
        ProjectiveSpace.standardChartι 2 k i := by
    dsimp [c, p, I]
    exact twoEquationStandardQuotientToGlobal_comp_fst F G hF hG
  have hpb2 : IsPullback
      (Spec.map
        (ofHom
          (Algebra.TensorProduct.includeLeftRingHom
            (R := k) (A := A)
            (B := ProjectiveSpace.StandardChartRing 2 k j)) ≫
          ofHom
            (Ideal.Quotient.mk
              (I.map (fstFiberChartMap (j := j) xAlg).toRingHom))))
      (Spec.map
        (ofHom
          (Ideal.Quotient.lift I
            ((Ideal.Quotient.mk
              (I.map (fstFiberChartMap (j := j) xAlg).toRingHom)).comp
                (fstFiberChartMap (j := j) xAlg).toRingHom)
            (fun _ ha ↦ Ideal.Quotient.eq_zero_iff_mem.mpr
              (Ideal.mem_map_of_mem _ ha)))))
      (ψ ≫ t) (c ≫ p) := by
    have hψt : ψ ≫ t = Spec.map (ofHom xAlg.toRingHom) ≫
        ProjectiveSpace.standardChartι 2 k i := by
      change 𝟙 _ ≫ t = _
      rw [Category.id_comp, hxt]
    rw [hψt, hcp]
    exact hpb1
  have hpb3 := hpb2.flip
  let rmap :=
    pullback.map (c ≫ p) (ψ ≫ t) p t c ψ (𝟙 _)
      (by simp) (by simp)
  let r0 := hpb3.isoPullback.hom ≫ rmap
  haveI : IsOpenImmersion r0 := by
    dsimp [r0, rmap]
    infer_instance
  have hr0_range : Set.range r0.base =
      (pullback.fst p t).base ⁻¹' Set.range c.base ∩
        (pullback.snd p t).base ⁻¹' Set.range ψ.base := by
    simpa [r0, rmap] using Scheme.range_isOpenImmersion_to_pullback
      p t c ψ hpb3
  let eW :
      (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k j ⧸
        Ideal.span ({qF, qG} : Set
          (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k j))) ≃+*
      (MvPolynomial (Fin 2) A ⧸
        Ideal.span ({f, g} : Set (MvPolynomial (Fin 2) A))) :=
    Ideal.quotientEquiv _ _
      (tensorStandardChartEquivMvPolynomial 2 k A j).toRingEquiv <| by
        rw [Ideal.map_span, Set.image_pair]
        rfl
  let eI := Ideal.quotEquivOfEq hImap
  let eFull := eI.trans eW
  let r : Spec (.of (MvPolynomial (Fin 2) A ⧸
      Ideal.span ({f, g} : Set (MvPolynomial (Fin 2) A)))) ⟶
      pullback p t :=
    Spec.map eFull.toCommRingCatIso.hom ≫ r0
  haveI : IsOpenImmersion r :=
    IsOpenImmersion.comp (Spec.map eFull.toCommRingCatIso.hom) r0
  have hr_range : Set.range r.base = Set.range r0.base := by
    have hiso : Function.Surjective
        (Spec.map eFull.toCommRingCatIso.hom).base :=
      Scheme.Hom.surjective _
    change Set.range
        ((r0.base : _ → _) ∘ (Spec.map eFull.toCommRingCatIso.hom).base) = _
    exact Function.Surjective.range_comp hiso _
  change ∃ (r' : Spec (.of (MvPolynomial (Fin 2) A ⧸
      Ideal.span ({f, g} : Set (MvPolynomial (Fin 2) A)))) ⟶ pullback p t),
    IsOpenImmersion r' ∧
      Set.range r'.base = (pullback.fst p t).base ⁻¹' Set.range c.base
  refine ⟨r, inferInstance, ?_⟩
  rw [hr_range, hr0_range]
  simp [p, t, ψ]

/-! ## The three-chart Artinian fibre criterion -/

set_option maxHeartbeats 6000000 in
-- Constructing and proving coverage of all three pulled-back quotient charts needs extra time.
/-- If the three explicit affine intersection rings are Artinian, then the entire projective
first-projection fibre is locally Artinian.

This is the complete scheme-theoretic gluing statement: the three affine quotient charts are
constructed by base change and their ranges are proved to cover.  All polynomial elimination is
isolated in the concrete chart-ring hypothesis. -/
theorem twoEquationFstFiber_isLocallyArtinian_of_affineChartRings
    {k : Type u} [Field k]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i)
    (hArt : ∀ j : Fin 3,
      letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
        ProjectiveSpace.residueAlgebra 2 k x
      let xAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx
      let f := fstBaseChangedChartEquation (i := i) (j := j) xAlg F
      let g := fstBaseChangedChartEquation (i := i) (j := j) xAlg G
      IsArtinianRing
        (PlaneCurveIntersectionArtinian.affinePlaneIntersectionRing f g)) :
    IsLocallyArtinian
      ((twoEquationBiprojectiveι 2 2 k F G ≫
        BiprojectiveSpace.fst 2 2 k).fiber x) := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
    ProjectiveSpace.residueAlgebra 2 k x
  let A : Type u := (ProjectiveSpace 2 k).residueField x
  let xAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx
  let p := twoEquationBiprojectiveι 2 2 k F G ≫ BiprojectiveSpace.fst 2 2 k
  let f : Fin 3 → MvPolynomial (Fin 2) A := fun j ↦
    fstBaseChangedChartEquation (i := i) (j := j) xAlg F
  let g : Fin 3 → MvPolynomial (Fin 2) A := fun j ↦
    fstBaseChangedChartEquation (i := i) (j := j) xAlg G
  have himm (j : Fin 3) :
      ∃ (r : Spec (.of
          (PlaneCurveIntersectionArtinian.affinePlaneIntersectionRing
            (f j) (g j))) ⟶ p.fiber x),
        IsOpenImmersion r ∧
          Set.range r.base = (p.fiberι x).base ⁻¹'
            Set.range
              (twoEquationStandardQuotientToGlobal
                2 2 k F G hF hG i j).base := by
    exact exists_openImmersion_twoEquationFstChart_into_fiber
      F G hF hG x i j hx
  choose r hrOI hrange using himm
  have hrangeStandardChart (a b : Fin 3) :
      Set.range (standardChartι 2 2 k a b).base =
        (BiprojectiveSpace.fst 2 2 k).base ⁻¹'
            Set.range (ProjectiveSpace.standardChartι 2 k a).base ∩
          (BiprojectiveSpace.snd 2 2 k).base ⁻¹'
            Set.range (ProjectiveSpace.standardChartι 2 k b).base := by
    have h := Scheme.Pullback.range_map
      (ProjectiveSpace.standardChartι 2 k a ≫ ProjectiveSpace.toSpec 2 k)
      (ProjectiveSpace.standardChartι 2 k b ≫ ProjectiveSpace.toSpec 2 k)
      (ProjectiveSpace.toSpec 2 k) (ProjectiveSpace.toSpec 2 k)
      (ProjectiveSpace.standardChartι 2 k a)
      (ProjectiveSpace.standardChartι 2 k b) (𝟙 _)
      (by simp) (by simp)
    convert h using 1
    dsimp only [standardChartι, standardOpenCover]
    simp only [Scheme.Pullback.openCoverOfLeftRight_f]
    rfl
  let 𝒰 : Scheme.OpenCover (p.fiber x) :=
    Scheme.Cover.mkOfCovers (Fin 3)
      (fun j ↦ Spec (.of
        (PlaneCurveIntersectionArtinian.affinePlaneIntersectionRing
          (f j) (g j))))
      r
      (fun z ↦ by
        classical
        let w : BiprojectiveSpace 2 2 k :=
          (twoEquationBiprojectiveι 2 2 k F G).base ((p.fiberι x).base z)
        have hwtop : w ∈ (⊤ : (BiprojectiveSpace 2 2 k).Opens) := trivial
        rw [← BiprojectiveSpace.iSup_standardChartAffineOpen 2 2 k] at hwtop
        simp only [TopologicalSpace.Opens.mem_iSup] at hwtop
        obtain ⟨⟨a, b⟩, hwab⟩ := hwtop
        change w ∈ ((standardChartAffineOpen 2 2 k a b).1 : Set _) at hwab
        have hstdab : ((standardChartAffineOpen 2 2 k a b).1 : Set _) =
            Set.range (standardChartι 2 2 k a b).base := by
          simp [standardChartAffineOpen, Scheme.Hom.coe_opensRange]
        rw [hstdab, hrangeStandardChart] at hwab
        have hpx : p.base ((p.fiberι x).base z) = x := by
          have hzmem : (p.fiberι x).base z ∈ Set.range (p.fiberι x).base :=
            ⟨z, rfl⟩
          rw [Scheme.Hom.range_fiberι] at hzmem
          exact hzmem
        have hwfst : (BiprojectiveSpace.fst 2 2 k).base w = x := by
          rw [← hpx]
          rfl
        have hxrange : x ∈
            Set.range (ProjectiveSpace.standardChartι 2 k i).base := by
          rw [← Scheme.Hom.coe_opensRange,
            ProjectiveSpace.opensRange_standardChartι]
          exact hx
        have hwij : w ∈ Set.range (standardChartι 2 2 k i b).base := by
          rw [hrangeStandardChart]
          refine ⟨?_, hwab.2⟩
          change (BiprojectiveSpace.fst 2 2 k).base w ∈
            Set.range (ProjectiveSpace.standardChartι 2 k i).base
          rw [hwfst]
          exact hxrange
        have hzChart : (p.fiberι x).base z ∈
            Set.range
              (twoEquationStandardQuotientToGlobal
                2 2 k F G hF hG i b).base := by
          rw [range_twoEquationStandardQuotientToGlobal]
          exact hwij
        have hzrange : z ∈ Set.range (r b).base := by
          rw [hrange b]
          exact hzChart
        obtain ⟨z', hz'⟩ := hzrange
        exact ⟨b, z', hz'⟩)
      (fun j ↦ hrOI j)
  rw [isLocallyArtinian_iff_openCover 𝒰]
  intro j
  letI : IsArtinianRing
      (PlaneCurveIntersectionArtinian.affinePlaneIntersectionRing
        (f j) (g j)) := hArt j
  change IsLocallyArtinian
    (Spec (.of (PlaneCurveIntersectionArtinian.affinePlaneIntersectionRing
      (f j) (g j))))
  exact Scheme.isLocallyArtinianScheme_Spec.mpr inferInstance

/-- Chartwise fraction-field coprimality in both coordinate orders supplies the Artinian chart
rings required by `twoEquationFstFiber_isLocallyArtinian_of_affineChartRings`. -/
theorem twoEquationFstFiber_isLocallyArtinian_of_isCoprimeOverFractionField
    {k : Type u} [Field k]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i)
    (hidDeg : ∀ j : Fin 3,
      letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
        ProjectiveSpace.residueAlgebra 2 k x
      let xAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx
      let f := fstBaseChangedChartEquation (i := i) (j := j) xAlg F
      let g := fstBaseChangedChartEquation (i := i) (j := j) xAlg G
      ((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
        (K := (ProjectiveSpace 2 k).residueField x)
        (Equiv.refl (Fin 2))) f).natDegree ≠ 0 ∨
      ((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
        (K := (ProjectiveSpace 2 k).residueField x)
        (Equiv.refl (Fin 2))) g).natDegree ≠ 0)
    (hidCop : ∀ j : Fin 3,
      letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
        ProjectiveSpace.residueAlgebra 2 k x
      let xAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx
      PlaneCurveIntersectionArtinian.IsCoprimeOverFractionFieldInOrder
        (fstBaseChangedChartEquation (i := i) (j := j) xAlg F)
        (fstBaseChangedChartEquation (i := i) (j := j) xAlg G)
        (Equiv.refl (Fin 2)))
    (hswapDeg : ∀ j : Fin 3,
      letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
        ProjectiveSpace.residueAlgebra 2 k x
      let xAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx
      let f := fstBaseChangedChartEquation (i := i) (j := j) xAlg F
      let g := fstBaseChangedChartEquation (i := i) (j := j) xAlg G
      ((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
        (K := (ProjectiveSpace 2 k).residueField x)
        (Equiv.swap (0 : Fin 2) (1 : Fin 2))) f).natDegree ≠ 0 ∨
      ((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
        (K := (ProjectiveSpace 2 k).residueField x)
        (Equiv.swap (0 : Fin 2) (1 : Fin 2))) g).natDegree ≠ 0)
    (hswapCop : ∀ j : Fin 3,
      letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
        ProjectiveSpace.residueAlgebra 2 k x
      let xAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx
      PlaneCurveIntersectionArtinian.IsCoprimeOverFractionFieldInOrder
        (fstBaseChangedChartEquation (i := i) (j := j) xAlg F)
        (fstBaseChangedChartEquation (i := i) (j := j) xAlg G)
        (Equiv.swap (0 : Fin 2) (1 : Fin 2))) :
    IsLocallyArtinian
      ((twoEquationBiprojectiveι 2 2 k F G ≫
        BiprojectiveSpace.fst 2 2 k).fiber x) := by
  apply twoEquationFstFiber_isLocallyArtinian_of_affineChartRings
    F G hF hG x i hx
  intro j
  exact affinePlaneIntersectionRing_isArtinian_of_isCoprimeOverFractionField
    _ _ (hidDeg j) (hidCop j) (hswapDeg j) (hswapCop j)

/-! ## Target-relation specialization -/

/-- Specializing a polynomial supported entirely in the second Cox block leaves that polynomial
unchanged, apart from the residue-field coefficient map. -/
theorem fstResidueFiberPolynomial_rename_inr
    {k : Type u} [Field k]
    (H : MvPolynomial (Fin 3) k)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i) :
    fstResidueFiberPolynomial
        (MvPolynomial.rename
          (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H) x i hx =
      H.map (ProjectiveSpace.residueCoefficientMap 2 k x) := by
  unfold fstResidueFiberPolynomial
  rw [MvPolynomial.map_rename]
  let P := H.map (ProjectiveSpace.residueCoefficientMap 2 k x)
  change specializeFirstCoordinates
      (ProjectiveSpace.normalizedResidueCoordinates 2 k x i hx)
      (MvPolynomial.rename Sum.inr P) = P
  induction P using MvPolynomial.induction_on with
  | C a => simp [specializeFirstCoordinates]
  | add P Q hP hQ => simp [hP, hQ]
  | mul_X P j hP =>
      rw [map_mul, MvPolynomial.rename_X, map_mul, hP]
      simp

/-- Consequently the second target-relation chart equation is exactly the dehomogenization of
`H` after mapping its coefficients to the residue field; it is independent of the chosen
first-factor point coordinates. -/
theorem fstBaseChangedChartEquation_rename_inr
    {k : Type u} [Field k]
    (H : MvPolynomial (Fin 3) k)
    (x : ProjectiveSpace 2 k) (i j : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i) :
    letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
      ProjectiveSpace.residueAlgebra 2 k x
    fstBaseChangedChartEquation (i := i) (j := j)
        (ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx)
        (MvPolynomial.rename
          (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H) =
      ProjectiveSpace.chartDehomogenization 2
        ((ProjectiveSpace 2 k).residueField x) j
        (H.map (ProjectiveSpace.residueCoefficientMap 2 k x)) := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
    ProjectiveSpace.residueAlgebra 2 k x
  rw [fstBaseChangedChartEquation_eq_chartDehomogenization_fstResidue]
  rw [fstResidueFiberPolynomial_rename_inr]

/-! ## Irreducible second equations supply the ordered coprimality certificates -/

/-- The two nonconstant-in-an-eliminated-coordinate conditions needed by the resultant proof. -/
def HasAffinePlaneEliminationDegrees
    {K : Type u} [Field K]
    (f g : MvPolynomial (Fin 2) K) : Prop :=
  (((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
      (K := K) (Equiv.refl (Fin 2))) f).natDegree ≠ 0 ∨
    ((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
      (K := K) (Equiv.refl (Fin 2))) g).natDegree ≠ 0) ∧
  (((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
      (K := K) (Equiv.swap (0 : Fin 2) (1 : Fin 2))) f).natDegree ≠ 0 ∨
    ((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
      (K := K) (Equiv.swap (0 : Fin 2) (1 : Fin 2))) g).natDegree ≠ 0)

/-- An irreducible affine plane equation which does not divide the other equation remains
coprime to it after choosing either coordinate as the outer polynomial variable and passing to
the fraction field of the other coordinate.

The degree-zero case is important: the irreducible equation then becomes a nonzero constant over
the coefficient fraction field, hence a unit.  In positive outer degree this is Gauss's lemma and
contraction of divisibility for a primitive polynomial. -/
theorem isCoprimeOverFractionFieldInOrder_of_irreducible_not_dvd
    {K : Type u} [Field K]
    (f g : MvPolynomial (Fin 2) K) (e : Fin 2 ≃ Fin 2)
    (hg : Irreducible g) (hgdvd : ¬ g ∣ f) :
    PlaneCurveIntersectionArtinian.IsCoprimeOverFractionFieldInOrder f g e := by
  let R := MvPolynomial (Fin 1) K
  let E := PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv (K := K) e
  let f' : Polynomial R := E f
  let g' : Polynomial R := E g
  let φ : R →+* FractionRing R := algebraMap R (FractionRing R)
  have hg' : Irreducible g' := by
    exact hg.map E.toRingEquiv
  have hgdvd' : ¬ g' ∣ f' := by
    change ¬ E.toRingEquiv g ∣ E.toRingEquiv f
    exact (not_congr (map_dvd_iff E.toRingEquiv)).mpr hgdvd
  by_cases hdeg : g'.natDegree = 0
  · have hg'C : g' = Polynomial.C (g'.coeff 0) :=
      Polynomial.eq_C_of_natDegree_eq_zero hdeg
    have hc0 : g'.coeff 0 ≠ 0 := by
      intro hc
      apply hg'.ne_zero
      rw [hg'C, hc, Polynomial.C_0]
    have hmapc0 : φ (g'.coeff 0) ≠ 0 := by
      simpa only [φ, map_zero] using
        (IsFractionRing.injective R (FractionRing R)).ne hc0
    have hunit : IsUnit (g'.map φ) := by
      rw [hg'C, Polynomial.map_C]
      exact Polynomial.isUnit_C.mpr hmapc0.isUnit
    obtain ⟨a, ha⟩ := isUnit_iff_exists_inv'.mp hunit
    exact ⟨0, a, by simpa using ha⟩
  · have hprim : g'.IsPrimitive := hg'.isPrimitive hdeg
    have hgmap : Irreducible (g'.map φ) :=
      hprim.irreducible_iff_irreducible_map_fraction_map.mp hg'
    have hnotmap : ¬ g'.map φ ∣ f'.map φ := by
      intro hdvd
      exact hgdvd' (hprim.dvd_of_fraction_map_dvd_fraction_map hdvd)
    exact (hgmap.coprime_iff_not_dvd.mpr hnotmap).symm

/-- In a chosen coordinate order, either one equation has positive outer degree, or the two
equations generate the unit ideal.  Indeed, if both have outer degree zero, they lie in the
one-variable coefficient ring; irreducibility and nondivisibility then give Bezout there. -/
theorem eliminationDegree_or_span_eq_top_of_irreducible_not_dvd
    {K : Type u} [Field K]
    (f g : MvPolynomial (Fin 2) K) (e : Fin 2 ≃ Fin 2)
    (hg : Irreducible g) (hgdvd : ¬ g ∣ f) :
    ((((orderedAffinePlaneEquiv (K := K) e) f).natDegree ≠ 0 ∨
        ((orderedAffinePlaneEquiv (K := K) e) g).natDegree ≠ 0) ∨
      Ideal.span ({f, g} : Set (MvPolynomial (Fin 2) K)) = ⊤) := by
  let R := MvPolynomial (Fin 1) K
  let E := orderedAffinePlaneEquiv (K := K) e
  let f' : Polynomial R := E f
  let g' : Polynomial R := E g
  have hg' : Irreducible g' := hg.map E.toRingEquiv
  have hgdvd' : ¬ g' ∣ f' := by
    change ¬ E.toRingEquiv g ∣ E.toRingEquiv f
    exact (not_congr (map_dvd_iff E.toRingEquiv)).mpr hgdvd
  by_cases hfdeg : f'.natDegree ≠ 0
  · exact Or.inl (Or.inl hfdeg)
  by_cases hgdeg : g'.natDegree ≠ 0
  · exact Or.inl (Or.inr hgdeg)
  right
  have hfdeg0 : f'.natDegree = 0 := not_ne_iff.mp hfdeg
  have hgdeg0 : g'.natDegree = 0 := not_ne_iff.mp hgdeg
  let a : R := f'.coeff 0
  let b : R := g'.coeff 0
  have hf'C : f' = Polynomial.C a := Polynomial.eq_C_of_natDegree_eq_zero hfdeg0
  have hg'C : g' = Polynomial.C b := Polynomial.eq_C_of_natDegree_eq_zero hgdeg0
  have hb : Irreducible b := by
    refine ⟨?_, ?_⟩
    · intro hbu
      exact hg'.not_isUnit (hg'C ▸ Polynomial.isUnit_C.mpr hbu)
    · intro c d hcd
      have hC : g' = Polynomial.C c * Polynomial.C d := by
        rw [hg'C, hcd, map_mul]
      rcases hg'.isUnit_or_isUnit hC with hc | hd
      · exact Or.inl (Polynomial.isUnit_C.mp hc)
      · exact Or.inr (Polynomial.isUnit_C.mp hd)
  have hbdvd : ¬ b ∣ a := by
    intro h
    apply hgdvd'
    rw [hf'C, hg'C]
    exact map_dvd Polynomial.C h
  let U := MvPolynomial.uniqueAlgEquiv K (Fin 1)
  have hbU : Irreducible (U b) := hb.map U.toRingEquiv
  have hbdvdU : ¬ U b ∣ U a := by
    exact (not_congr (map_dvd_iff U.toRingEquiv)).mpr hbdvd
  have hcopU : IsCoprime (U b) (U a) :=
    hbU.coprime_iff_not_dvd.mpr hbdvdU
  have hcopR : IsCoprime b a := by
    simpa using hcopU.map U.symm.toRingHom
  have hcop' : IsCoprime f' g' := by
    rw [hf'C, hg'C]
    exact hcopR.symm.map Polynomial.C
  have hcop : IsCoprime f g := by
    simpa [f', g'] using hcop'.map E.symm.toRingHom
  apply (Ideal.eq_top_iff_one _).mpr
  exact Ideal.mem_span_pair.mpr hcop

/-- If the two affine equations generate the unit ideal, their quotient ring is zero and hence
Artinian. -/
theorem affinePlaneIntersectionRing_isArtinian_of_span_eq_top
    {K : Type u} [Field K]
    (f g : MvPolynomial (Fin 2) K)
    (hI : Ideal.span ({f, g} : Set (MvPolynomial (Fin 2) K)) = ⊤) :
    IsArtinianRing (affinePlaneIntersectionRing f g) := by
  apply Ring.isArtinian_of_zero_eq_one
  symm
  apply Ideal.Quotient.eq_zero_iff_mem.mpr
  change (1 : MvPolynomial (Fin 2) K) ∈ Ideal.span ({f, g} : Set _)
  rw [hI]
  trivial

/-- A unit second equation gives the zero quotient.  Otherwise irreducibility and
nondivisibility suffice: Gauss's lemma and resultants handle every nonconstant elimination
order, while a missing elimination degree forces the quotient itself to be zero. -/
theorem affinePlaneIntersectionRing_isArtinian_of_isUnit_or_irreducible_not_dvd
    {K : Type u} [Field K]
    (f g : MvPolynomial (Fin 2) K)
    (hg : IsUnit g ∨ (Irreducible g ∧ ¬ g ∣ f)) :
    IsArtinianRing
      (PlaneCurveIntersectionArtinian.affinePlaneIntersectionRing f g) := by
  rcases hg with hgunit | ⟨hgirr, hgdvd⟩
  · apply affinePlaneIntersectionRing_isArtinian_of_span_eq_top
    let I : Ideal (MvPolynomial (Fin 2) K) := Ideal.span ({f, g} : Set _)
    have hgmem : g ∈ I := Ideal.subset_span (by simp)
    exact I.eq_top_of_isUnit_mem hgmem hgunit
  · rcases eliminationDegree_or_span_eq_top_of_irreducible_not_dvd
        f g (Equiv.refl (Fin 2)) hgirr hgdvd with hidDeg | htop
    · rcases eliminationDegree_or_span_eq_top_of_irreducible_not_dvd
          f g (Equiv.swap (0 : Fin 2) (1 : Fin 2)) hgirr hgdvd with
        hswapDeg | htop
      · apply affinePlaneIntersectionRing_isArtinian_of_isCoprimeOverFractionField
          f g hidDeg
          (isCoprimeOverFractionFieldInOrder_of_irreducible_not_dvd
            f g (Equiv.refl (Fin 2)) hgirr hgdvd)
          hswapDeg
          (isCoprimeOverFractionFieldInOrder_of_irreducible_not_dvd
            f g (Equiv.swap (0 : Fin 2) (1 : Fin 2)) hgirr hgdvd)
      · exact affinePlaneIntersectionRing_isArtinian_of_span_eq_top f g htop
    · exact affinePlaneIntersectionRing_isArtinian_of_span_eq_top f g htop

/-- The packaged effective no-common-component hypothesis for the three affine charts of a
first-projection fibre.  Both coordinate orders are included because they produce the two
coordinate eliminants needed for finite-dimensionality. -/
def HasThreeChartCoprimality
    {k : Type u} [Field k]
    (F G : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i) : Prop :=
  letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
    ProjectiveSpace.residueAlgebra 2 k x
  let xAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx
  ∀ j : Fin 3,
    let f := fstBaseChangedChartEquation (i := i) (j := j) xAlg F
    let g := fstBaseChangedChartEquation (i := i) (j := j) xAlg G
    (((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
        (K := (ProjectiveSpace 2 k).residueField x)
        (Equiv.refl (Fin 2))) f).natDegree ≠ 0 ∨
      ((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
        (K := (ProjectiveSpace 2 k).residueField x)
        (Equiv.refl (Fin 2))) g).natDegree ≠ 0) ∧
    PlaneCurveIntersectionArtinian.IsCoprimeOverFractionFieldInOrder
      f g (Equiv.refl (Fin 2)) ∧
    (((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
        (K := (ProjectiveSpace 2 k).residueField x)
        (Equiv.swap (0 : Fin 2) (1 : Fin 2))) f).natDegree ≠ 0 ∨
      ((PlaneCurveIntersectionArtinian.orderedAffinePlaneEquiv
        (K := (ProjectiveSpace 2 k).residueField x)
        (Equiv.swap (0 : Fin 2) (1 : Fin 2))) g).natDegree ≠ 0) ∧
    PlaneCurveIntersectionArtinian.IsCoprimeOverFractionFieldInOrder
      f g (Equiv.swap (0 : Fin 2) (1 : Fin 2))

/-- A factor-theoretic form of the three-chart input.  On a chart missed by the second equation
the equation is a unit.  Otherwise it is irreducible and does not divide the specialized first
equation. -/
def HasThreeChartIrreducibleSecondEquation
    {k : Type u} [Field k]
    (F G : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i) : Prop :=
  letI : Algebra k ((ProjectiveSpace 2 k).residueField x) :=
    ProjectiveSpace.residueAlgebra 2 k x
  let xAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k x i hx
  ∀ j : Fin 3,
    let f := fstBaseChangedChartEquation (i := i) (j := j) xAlg F
    let g := fstBaseChangedChartEquation (i := i) (j := j) xAlg G
    IsUnit g ∨ (Irreducible g ∧ ¬ g ∣ f)

/-- The three factor-theoretic chart conditions make the complete-intersection fibre locally
Artinian. -/
theorem twoEquationFstFiber_isLocallyArtinian_of_irreducibleSecondEquation
    {k : Type u} [Field k]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i)
    (hfac : HasThreeChartIrreducibleSecondEquation F G x i hx) :
    IsLocallyArtinian
      ((twoEquationBiprojectiveι 2 2 k F G ≫
        BiprojectiveSpace.fst 2 2 k).fiber x) := by
  apply twoEquationFstFiber_isLocallyArtinian_of_affineChartRings
    F G hF hG x i hx
  intro j
  exact affinePlaneIntersectionRing_isArtinian_of_isUnit_or_irreducible_not_dvd
    _ _ (hfac j)

/-- Packaged-coprimality form of the complete-intersection fibre theorem. -/
theorem twoEquationFstFiber_isLocallyArtinian_of_hasThreeChartCoprimality
    {k : Type u} [Field k]
    {dF eF dG eG : ℕ}
    (F G : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hG : IsBihomogeneousOfBidegree dG eG G)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i)
    (hcop : HasThreeChartCoprimality F G x i hx) :
    IsLocallyArtinian
      ((twoEquationBiprojectiveι 2 2 k F G ≫
        BiprojectiveSpace.fst 2 2 k).fiber x) := by
  apply twoEquationFstFiber_isLocallyArtinian_of_isCoprimeOverFractionField
    F G hF hG x i hx
  · intro j
    exact (hcop j).1
  · intro j
    exact (hcop j).2.1
  · intro j
    exact (hcop j).2.2.1
  · intro j
    exact (hcop j).2.2.2

/-- For the target relation, the second equation in the packaged chart-coprimality condition is
the second-block lift of `H`. -/
abbrev HasTargetRelationFstFiberChartCoprimality
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i) : Prop :=
  HasThreeChartCoprimality F
    (MvPolynomial.rename
      (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H) x i hx

/-- Factor-theoretic target-relation chart input. -/
abbrev HasTargetRelationFstFiberIrreducibleChartEquation
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i) : Prop :=
  HasThreeChartIrreducibleSecondEquation F
    (MvPolynomial.rename
      (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H) x i hx

/-- The scheme-theoretic generic point of the projective plane lies in every standard chart. -/
theorem schemeGenericPoint_mem_standardChart
    (k : Type u) [Field k] (i : Fin 3) :
    genericPoint (ProjectiveSpace 2 k) ∈
      ProjectiveSpace.standardChart 2 k i := by
  have hη : ProjectiveSpace.genericPoint 2 k =
      genericPoint (ProjectiveSpace 2 k) := by
    refine ((genericPoint_spec (ProjectiveSpace 2 k)).eq ?_).symm
    rw [isGenericPoint_def, ← dense_iff_closure_eq]
    exact ProjectiveSpectrum.dense_singleton_genericPoint _
      (ProjectiveSpace.irrelevant_ne_bot 2 k)
  rw [← hη]
  exact ProjectiveSpace.genericPoint_mem_standardChart 2 k i

/-- Effective projective-plane-intersection criterion for a target-relation fibre. -/
theorem targetRelationFstFiber_isLocallyArtinian_of_hasThreeChartCoprimality
    {k : Type u} [Field k]
    {dF eF dH : ℕ}
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hH : H.IsHomogeneous dH)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i)
    (hcop : HasTargetRelationFstFiberChartCoprimality F H x i hx) :
    IsLocallyArtinian ((targetRelationToFirst F H).fiber x) := by
  change IsLocallyArtinian
    ((twoEquationBiprojectiveι 2 2 k F
      (MvPolynomial.rename
        (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H) ≫
      BiprojectiveSpace.fst 2 2 k).fiber x)
  exact twoEquationFstFiber_isLocallyArtinian_of_hasThreeChartCoprimality
    F (MvPolynomial.rename Sum.inr H) hF (rename_inr_isBihomogeneous hH)
      x i hx hcop

/-- Factor-theoretic projective-plane-intersection criterion for a target-relation fibre. -/
theorem targetRelationFstFiber_isLocallyArtinian_of_irreducibleChartEquation
    {k : Type u} [Field k]
    {dF eF dH : ℕ}
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hH : H.IsHomogeneous dH)
    (x : ProjectiveSpace 2 k) (i : Fin 3)
    (hx : x ∈ ProjectiveSpace.standardChart 2 k i)
    (hfac : HasTargetRelationFstFiberIrreducibleChartEquation F H x i hx) :
    IsLocallyArtinian ((targetRelationToFirst F H).fiber x) := by
  change IsLocallyArtinian
    ((twoEquationBiprojectiveι 2 2 k F
      (MvPolynomial.rename
        (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H) ≫
      BiprojectiveSpace.fst 2 2 k).fiber x)
  exact twoEquationFstFiber_isLocallyArtinian_of_irreducibleSecondEquation
    F (MvPolynomial.rename Sum.inr H) hF (rename_inr_isBihomogeneous hH)
      x i hx hfac

/-- Generic-fibre endpoint used by `TargetRelationGenericFiber`: after choosing any standard
chart containing the generic point, the six explicit ordered coprimality/degree checks imply the
required `IsLocallyArtinian` instance. -/
theorem targetRelation_genericFiber_isLocallyArtinian_of_hasThreeChartCoprimality
    {k : Type u} [Field k]
    {dF eF dH : ℕ}
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hH : H.IsHomogeneous dH)
    (i : Fin 3)
    (hη : genericPoint (ProjectiveSpace 2 k) ∈
      ProjectiveSpace.standardChart 2 k i)
    (hcop : HasTargetRelationFstFiberChartCoprimality F H
      (genericPoint (ProjectiveSpace 2 k)) i hη) :
    IsLocallyArtinian
      ((targetRelationToFirst F H).fiber
        (genericPoint (ProjectiveSpace 2 k))) :=
  targetRelationFstFiber_isLocallyArtinian_of_hasThreeChartCoprimality
    F H hF hH (genericPoint (ProjectiveSpace 2 k)) i hη hcop

/-- Same generic-fibre criterion with membership in the chosen standard chart discharged
canonically. -/
theorem targetRelation_genericFiber_isLocallyArtinian_of_chartwiseCoprime
    {k : Type u} [Field k]
    {dF eF dH : ℕ}
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hH : H.IsHomogeneous dH)
    (i : Fin 3)
    (hcop : HasTargetRelationFstFiberChartCoprimality F H
      (genericPoint (ProjectiveSpace 2 k)) i
        (schemeGenericPoint_mem_standardChart k i)) :
    IsLocallyArtinian
      ((targetRelationToFirst F H).fiber
        (genericPoint (ProjectiveSpace 2 k))) :=
  targetRelation_genericFiber_isLocallyArtinian_of_hasThreeChartCoprimality
    F H hF hH i (schemeGenericPoint_mem_standardChart k i) hcop

/-- Generic target-relation fibre criterion in the factor-theoretic chart form.  Compared with
the ordered-coprimality endpoint, the only non-resultant algebra left is irreducibility after
the generic coefficient extension and nondivisibility of the specialized first equation. -/
theorem targetRelation_genericFiber_isLocallyArtinian_of_irreducibleChartEquation
    {k : Type u} [Field k]
    {dF eF dH : ℕ}
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (hF : IsBihomogeneousOfBidegree dF eF F)
    (hH : H.IsHomogeneous dH)
    (i : Fin 3)
    (hfac : HasTargetRelationFstFiberIrreducibleChartEquation F H
      (genericPoint (ProjectiveSpace 2 k)) i
        (schemeGenericPoint_mem_standardChart k i)) :
    IsLocallyArtinian
      ((targetRelationToFirst F H).fiber
        (genericPoint (ProjectiveSpace 2 k))) :=
  targetRelationFstFiber_isLocallyArtinian_of_irreducibleChartEquation
    F H hF hH (genericPoint (ProjectiveSpace 2 k)) i
      (schemeGenericPoint_mem_standardChart k i) hfac

end BiprojectiveSpace

end

end BConicBundleMultisections
