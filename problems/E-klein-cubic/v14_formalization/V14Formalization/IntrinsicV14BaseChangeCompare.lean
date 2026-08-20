/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.IntrinsicV14Compare
public import V14Formalization.IntrinsicV14Field
public import V14Formalization.WeilModelBaseChange
public import V14Formalization.V14SchemeBaseChange

/-!
# The intrinsic `V₁₄` over `F` maps to the coordinate `V₁₄` over `ℚ(ζ₁₁)`

`IntrinsicV14Compare.compare` is field-generic, so over `F` it produces a
morphism to the coordinate `V₁₄` *built over `F`*.  The general-field headline
`FaithfulHeadlineOverField.noEquivariantRationalMap_ambientFree_over_of_constancy`
targets `V14SchemeModel.actionOverBaseChange F`, the base change of the
coordinate model built over `ℚ(ζ₁₁)`.  This file closes that gap.

**No base-change theorem for `Proj` is needed.**  A morphism in the direction
`intrinsic_F ⟶ (coordinate model)_F ×_k F` is all that `compHom` wants, and a
morphism into a fibre product is a pair.  So the whole content is one
`Proj.map` along a graded ring homomorphism

    MvPolynomial (Fin 15) k  ⟶  MvPolynomial (Fin 15) F  ⟶  Sym (M_F*) ⧸ I_F

— coefficient extension (`BConicBundleMultisections.coeffGradedRingHom`) followed
by `IntrinsicV14Compare.gradedCompare` over `F` — together with the fact that
the thirty *`k`-defined* equations die under it.  The fifteen Plücker quadrics
die because they are defined over `ℤ`; the fifteen linear cuts die because
`WeilModelBaseChange.projectorMatrix_map_mulVec_Msub` says the `k`-defined
projector matrix, mapped to `F`, fixes the coordinates of `M_F`.  That last
statement is the identification: it says `M_F` *is* `M_k ⊗ F` inside `⋀²U_F`.

`pullback.lift` then produces the morphism to the base change, and it is
equivariant and lies over `Spec F`.
-/

set_option linter.unusedSectionVars false
set_option maxRecDepth 20000
set_option maxHeartbeats 4000000

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry HomogeneousIdeal

namespace V14Formalization
namespace IntrinsicV14BaseChange

open AlgebraicGeometry Module BConicBundleMultisections
open V14Formalization.SchemeGeometry
open V14Formalization.WeilLambda2
open V14Formalization.WeilRep (IsCycl11)

attribute [local instance] MvPolynomial.gradedAlgebra

open V14SchemeModel (k)

/-! ## General lemmas about coefficient extension -/

/-- The Plücker quadrics have integer coefficients, so they are defined over
the prime field and coefficient extension carries them to each other. -/
public theorem map_pluckerQuadric {R S : Type} [CommRing R] [CommRing S]
    (f : R →+* S) (q : Fin 15) :
    MvPolynomial.map f (pluckerQuadric R q) = pluckerQuadric S q := by
  simp [pluckerQuadric]

/-- The linear cuts of a matrix map to the linear cuts of its image. -/
public theorem map_projectorLinearCut {R S : Type} [CommRing R] [CommRing S]
    (f : R →+* S) (P : Matrix (Fin 15) (Fin 15) R) (i : Fin 15) :
    MvPolynomial.map f (projectorLinearCut R P i) =
      projectorLinearCut S (P.map f) i := by
  simp [projectorLinearCut, Matrix.map_apply]

public theorem map_linearSubst {R S : Type} [CommRing R] [CommRing S] (φ : R →+* S)
    (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (j : Fin (n + 1)) :
    MvPolynomial.map φ (linearSubst n M j) = linearSubst n (M.map φ) j := by
  simp only [linearSubst, map_sum, map_mul, MvPolynomial.map_C, MvPolynomial.map_X,
    Matrix.map_apply]

public theorem map_aeval_linearSubst {R S : Type} [CommRing R] [CommRing S] (φ : R →+* S)
    (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (p : MvPolynomial (Fin (n + 1)) R) :
    MvPolynomial.map φ
        ((MvPolynomial.aeval (linearSubst n M) :
          MvPolynomial (Fin (n + 1)) R →ₐ[R] MvPolynomial (Fin (n + 1)) R) p) =
      (MvPolynomial.aeval (linearSubst n (M.map φ)) :
          MvPolynomial (Fin (n + 1)) S →ₐ[S] MvPolynomial (Fin (n + 1)) S)
        (MvPolynomial.map φ p) := by
  have hext :
      ((MvPolynomial.map φ).comp
        (MvPolynomial.aeval (linearSubst n M) :
          MvPolynomial (Fin (n + 1)) R →ₐ[R] MvPolynomial (Fin (n + 1)) R).toRingHom) =
      ((MvPolynomial.aeval (linearSubst n (M.map φ)) :
          MvPolynomial (Fin (n + 1)) S →ₐ[S] MvPolynomial (Fin (n + 1)) S).toRingHom.comp
        (MvPolynomial.map φ)) := by
    apply MvPolynomial.ringHom_ext
    · intro r; simp
    · intro j; simp [map_linearSubst]
  exact congr($hext p)

private theorem coeff_zero_comp {R S : Type} [CommRing R] [CommRing S]
    (φ : R →+* S) (n : ℕ) :
    (coeffGradedRingHom φ n).gradedZeroRingHom.comp
        (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)) =
      (algebraMap S (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) S 0)).comp φ := by
  apply RingHom.ext
  intro r
  apply Subtype.ext
  show MvPolynomial.map φ (MvPolynomial.C r) = MvPolynomial.C (φ r)
  rw [MvPolynomial.map_C]

/-- Coefficient extension of `ℙⁿ` lies over `Spec` of the coefficient map. -/
public theorem mapCoeff_toSpec {R S : Type} [CommRing R] [CommRing S]
    (φ : R →+* S) (n : ℕ) :
    mapCoeff φ n ≫ ProjectiveSpace.toSpec n R =
      ProjectiveSpace.toSpec n S ≫ Spec.map (CommRingCat.ofHom φ) := by
  unfold mapCoeff ProjectiveSpace.toSpec
  rw [← Category.assoc, AlgebraicGeometry.Proj.map_toSpecZero]
  rw [Category.assoc, ← Spec.map_comp, Category.assoc, ← Spec.map_comp]
  have hz :
      CommRingCat.ofHom
          (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)) ≫
        CommRingCat.ofHom (coeffGradedRingHom φ n).gradedZeroRingHom =
      CommRingCat.ofHom φ ≫
        CommRingCat.ofHom
          (algebraMap S (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) S 0)) := by
    simpa using congrArg CommRingCat.ofHom (coeff_zero_comp φ n)
  rw [hz]

variable (F : Type) [Field F] [CharZero F] [IsCycl11 F] [Algebra k F]
  (hzF : algebraMap k F (WeilRep.ζ : k) = (WeilRep.ζ : F))

/-! ## The graded ring homomorphism -/

/-- The comparison graded ring map, with the *`ℚ(ζ₁₁)`* coordinate ring as
source: extend coefficients, then restrict linear forms to `M_F` and quotient
by the Plücker ideal. -/
@[expose] public def gradedCompareBC :
    MvPolynomial.homogeneousSubmodule (Fin 15) k →+*ᵍ
      IntrinsicV14.coordinateRing F (WeilRep.U F) (IntrinsicV14Field.inclM F) :=
  (IntrinsicV14Compare.gradedCompare (IntrinsicV14Field.inclM F)
      (WeilModelBaseChange.uBasis F)).comp
    (coeffGradedRingHom (algebraMap k F) 14)

public theorem gradedCompareBC_apply (p : MvPolynomial (Fin 15) k) :
    gradedCompareBC F p =
      Ideal.Quotient.mk
        (IntrinsicV14.pluckerIdeal F (WeilRep.U F) (IntrinsicV14Field.inclM F)).toIdeal
        (IntrinsicV14Compare.symCompare (IntrinsicV14Field.inclM F)
          (WeilModelBaseChange.uBasis F) (MvPolynomial.map (algebraMap k F) p)) :=
  rfl

public theorem irrelevant_le_gradedCompareBC :
    (IntrinsicV14.coordinateRing F (WeilRep.U F) (IntrinsicV14Field.inclM F))₊ ≤
      ((MvPolynomial.homogeneousSubmodule (Fin 15) k)₊).map (gradedCompareBC F) :=
  HomogeneousIdeal.irrelevant_le_map_comp
    (irrelevant_le_map_coeff (algebraMap k F) 14)
    (IntrinsicV14Compare.irrelevant_le_gradedCompare (IntrinsicV14Field.inclM F)
      (WeilModelBaseChange.uBasis F) (IntrinsicV14Field.inclM_dualMap_surjective F))

/-! ## Into `ℙ¹⁴` over `ℚ(ζ₁₁)` -/

/-- The morphism from the intrinsic `V₁₄` over `F` to the *`ℚ(ζ₁₁)`*-projective
space `ℙ¹⁴`. -/
@[expose] public def toAmbient14BC :
    IntrinsicV14.scheme F (WeilRep.U F) (IntrinsicV14Field.inclM F) ⟶
      ProjectiveSpace 14 k :=
  Proj.map (gradedCompareBC F) (irrelevant_le_gradedCompareBC F)

/-- The comparison factors through `ℙ¹⁴` over `F`: it is the `F`-comparison
followed by coefficient extension. -/
public theorem toAmbient14BC_eq :
    toAmbient14BC F =
      IntrinsicV14Compare.toAmbient14 (IntrinsicV14Field.inclM F)
          (WeilModelBaseChange.uBasis F)
          (IntrinsicV14Field.inclM_dualMap_surjective F) ≫
        mapCoeff (algebraMap k F) 14 :=
  AlgebraicGeometry.Proj.map_comp _ _ _ _

/-- The morphism to `ℙ¹⁴_k` lies over `Spec k` through `Spec F`. -/
public theorem toAmbient14BC_toSpec :
    toAmbient14BC F ≫ ProjectiveSpace.toSpec 14 k =
      IntrinsicV14.toSpec F (WeilRep.U F) (IntrinsicV14Field.inclM F) ≫
        Spec.map (CommRingCat.ofHom (algebraMap k F)) := by
  rw [toAmbient14BC_eq, Category.assoc, mapCoeff_toSpec, ← Category.assoc,
    IntrinsicV14Compare.toAmbient14_toSpec]

/-! ## The thirty `ℚ(ζ₁₁)`-defined equations die -/

include hzF

public theorem gradedCompareBC_equations_eq_zero (s : Fin 15 ⊕ Fin 15) :
    gradedCompareBC F
        (grassmannianLinearSectionEquations k V14SchemeModel.projectorMatrix s) = 0 := by
  haveI : Infinite F := Infinite.of_injective _ (Nat.cast_injective (R := F))
  have h2 : (2 : F) ≠ 0 := two_ne_zero
  rcases s with q | i
  · have hq : gradedCompareBC F (pluckerQuadric k q) = 0 := by
      rw [gradedCompareBC_apply, map_pluckerQuadric]
      exact (Ideal.Quotient.eq_zero_iff_mem).2
        (IntrinsicV14Compare.symCompare_pluckerQuadric_mem (IntrinsicV14Field.inclM F)
          (WeilModelBaseChange.uBasis F) h2 q)
    exact hq
  · have hP : ∀ x : ↥(WeilLambda2.Msub F),
        (V14SchemeModel.projectorMatrix.map (algebraMap k F)).mulVec
            ((Lambda4Coordinates.lex2 (WeilModelBaseChange.uBasis F)).equivFun
              (IntrinsicV14Field.inclM F x)) =
          (Lambda4Coordinates.lex2 (WeilModelBaseChange.uBasis F)).equivFun
            (IntrinsicV14Field.inclM F x) :=
      WeilModelBaseChange.projectorMatrix_map_mulVec_Msub F hzF
    have hcut := IntrinsicV14Compare.symCompare_projectorLinearCut
      (IntrinsicV14Field.inclM F) (WeilModelBaseChange.uBasis F)
      (V14SchemeModel.projectorMatrix.map (algebraMap k F)) hP i
    have hi : gradedCompareBC F
        (projectorLinearCut k V14SchemeModel.projectorMatrix i) = 0 := by
      rw [gradedCompareBC_apply, map_projectorLinearCut, hcut, map_zero]
    exact hi

/-- **The comparison morphism, from the intrinsic `V₁₄` over `F` to the
coordinate `V₁₄` over `ℚ(ζ₁₁)`.** -/
@[expose] public def compareBC :
    IntrinsicV14.scheme F (WeilRep.U F) (IntrinsicV14Field.inclM F) ⟶
      V14SchemeModel.v14Scheme :=
  liftToZeroLocusFamily (gradedCompareBC F) (irrelevant_le_gradedCompareBC F)
    (grassmannianLinearSectionEquations k V14SchemeModel.projectorMatrix)
    V14SchemeModel.equationDegree V14SchemeModel.equations_isHomogeneous
    (gradedCompareBC_equations_eq_zero F hzF)

@[reassoc]
public theorem compareBC_ι :
    compareBC F hzF ≫ V14SchemeModel.v14Schemeι = toAmbient14BC F :=
  liftToZeroLocusFamily_ι _ _ _ _ _ _

/-- The comparison lies over `Spec k` through `Spec F`: this is the square that
`pullback.lift` consumes. -/
public theorem compareBC_comm :
    compareBC F hzF ≫ V14SchemeModel.actionOver.V.hom =
      IntrinsicV14.toSpec F (WeilRep.U F) (IntrinsicV14Field.inclM F) ≫
        Spec.map (CommRingCat.ofHom (algebraMap k F)) := by
  change compareBC F hzF ≫ projectiveZeroLocusFamilyToSpec 14 k
      (grassmannianLinearSectionEquations k V14SchemeModel.projectorMatrix) = _
  rw [projectiveZeroLocusFamilyToSpec, ← Category.assoc, compareBC_ι,
    toAmbient14BC_toSpec]

/-! ## Equivariance

Both sides are `Proj.map`s, so the whole content is one identity of graded ring
homomorphisms.  `IntrinsicV14Compare.gradedCompare_intertwines` supplies it over
`F` for the *mapped* matrix; what is added here is that a linear substitution
commutes with coefficient extension.
-/

include hzF

/-- The intertwining identity for the base-changed comparison, at the level of
graded rings. -/
public theorem gradedCompareBC_intertwines
    (α : ↥(WeilLambda2.Msub F) →ₗ[F] ↥(WeilLambda2.Msub F))
    (hα : IntrinsicV14.Covers F (WeilRep.U F) (IntrinsicV14Field.inclM F) α)
    (A : Matrix (Fin 15) (Fin 15) k)
    (hA : ∀ (x : ↥(WeilLambda2.Msub F)) (j : Fin 15),
      (Lambda4Coordinates.lex2 (WeilModelBaseChange.uBasis F)).equivFun
          (IntrinsicV14Field.inclM F (α x)) j =
        ∑ l : Fin 15, (A.map (algebraMap k F)) j l *
          (Lambda4Coordinates.lex2 (WeilModelBaseChange.uBasis F)).equivFun
            (IntrinsicV14Field.inclM F x) l) :
    (IntrinsicV14.quotMap F (WeilRep.U F) (IntrinsicV14Field.inclM F) α hα).comp
        (gradedCompareBC F) =
      (gradedCompareBC F).comp (linearSubstGradedRingHom 14 A) := by
  have hcore := IntrinsicV14Compare.gradedCompare_intertwines (IntrinsicV14Field.inclM F)
    (WeilModelBaseChange.uBasis F) α hα (A.map (algebraMap k F)) hA
  refine GradedRingHom.ext fun p => ?_
  show (IntrinsicV14.quotMap F (WeilRep.U F) (IntrinsicV14Field.inclM F) α hα)
      (IntrinsicV14Compare.gradedCompare (IntrinsicV14Field.inclM F)
        (WeilModelBaseChange.uBasis F) (MvPolynomial.map (algebraMap k F) p)) =
    IntrinsicV14Compare.gradedCompare (IntrinsicV14Field.inclM F)
      (WeilModelBaseChange.uBasis F)
      (MvPolynomial.map (algebraMap k F)
        ((MvPolynomial.aeval (linearSubst 14 A) :
          MvPolynomial (Fin 15) k →ₐ[k] MvPolynomial (Fin 15) k) p))
  rw [map_aeval_linearSubst]
  exact congr($hcore (MvPolynomial.map (algebraMap k F) p))

/-- The intertwining identity at the level of schemes. -/
public theorem schemeMapBC_comp_toAmbient14
    (α β : ↥(WeilLambda2.Msub F) →ₗ[F] ↥(WeilLambda2.Msub F))
    (hα : IntrinsicV14.Covers F (WeilRep.U F) (IntrinsicV14Field.inclM F) α)
    (hinvα : β ∘ₗ α = LinearMap.id)
    (A N : Matrix (Fin 15) (Fin 15) k) (hAN : N * A = 1)
    (hA : ∀ (x : ↥(WeilLambda2.Msub F)) (j : Fin 15),
      (Lambda4Coordinates.lex2 (WeilModelBaseChange.uBasis F)).equivFun
          (IntrinsicV14Field.inclM F (α x)) j =
        ∑ l : Fin 15, (A.map (algebraMap k F)) j l *
          (Lambda4Coordinates.lex2 (WeilModelBaseChange.uBasis F)).equivFun
            (IntrinsicV14Field.inclM F x) l) :
    IntrinsicV14.schemeMap F (WeilRep.U F) (IntrinsicV14Field.inclM F) α β hα hinvα ≫
        toAmbient14BC F =
      toAmbient14BC F ≫ mapLinearSubst 14 A N hAN := by
  have hL : IntrinsicV14.schemeMap F (WeilRep.U F) (IntrinsicV14Field.inclM F) α β hα hinvα ≫
      toAmbient14BC F =
      Proj.map ((IntrinsicV14.quotMap F (WeilRep.U F) (IntrinsicV14Field.inclM F) α hα).comp
          (gradedCompareBC F))
        (HomogeneousIdeal.irrelevant_le_map_comp
          (irrelevant_le_gradedCompareBC F)
          (IntrinsicV14.irrelevant_le_quotMap F (WeilRep.U F) (IntrinsicV14Field.inclM F)
            α β hα hinvα)) :=
    (Proj.map_comp _ _ _ _).symm
  have hR : toAmbient14BC F ≫ mapLinearSubst 14 A N hAN =
      Proj.map ((gradedCompareBC F).comp (linearSubstGradedRingHom 14 A))
        (HomogeneousIdeal.irrelevant_le_map_comp
          (irrelevant_le_map_linearSubst 14 A N hAN)
          (irrelevant_le_gradedCompareBC F)) :=
    (Proj.map_comp _ _ _ _).symm
  rw [hL, hR]
  exact AlgebraicGeometry.Proj.map_congr
    (gradedCompareBC_intertwines F hzF α hα A hA) _ _

/-- **The comparison is equivariant.** -/
public theorem compareBC_equivariant (g : WeilLambda2.PSL2F11) :
    ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ compareBC F hzF =
      compareBC F hzF ≫ (V14SchemeModel.actionOver.ρ g).left := by
  refine (cancel_mono V14SchemeModel.v14Schemeι).1 ?_
  have hleft : ((IntrinsicV14Field.intrinsicV14 F).ρ g).left =
      IntrinsicV14.schemeMap F (WeilRep.U F) (IntrinsicV14Field.inclM F)
        (IntrinsicV14Field.repM F g) (IntrinsicV14Field.repM F g⁻¹)
        (IntrinsicV14Field.coversM F g)
        (IntrinsicV14.repInvComp (IntrinsicV14Field.repM F) g) := rfl
  have hA : ∀ (x : ↥(WeilLambda2.Msub F)) (j : Fin 15),
      (Lambda4Coordinates.lex2 (WeilModelBaseChange.uBasis F)).equivFun
          (IntrinsicV14Field.inclM F (IntrinsicV14Field.repM F g x)) j =
        ∑ l : Fin 15,
          ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ g :
            Matrix (Fin 15) (Fin 15) k).map (algebraMap k F)) j l *
            (Lambda4Coordinates.lex2 (WeilModelBaseChange.uBasis F)).equivFun
              (IntrinsicV14Field.inclM F x) l := by
    intro x j
    rw [IntrinsicV14Field.inclM_repM]
    exact WeilModelBaseChange.lex2_equivFun_ambientAct F hzF g
      (IntrinsicV14Field.inclM F x) j
  have step := schemeMapBC_comp_toAmbient14 F hzF (IntrinsicV14Field.repM F g)
    (IntrinsicV14Field.repM F g⁻¹) (IntrinsicV14Field.coversM F g)
    (IntrinsicV14.repInvComp (IntrinsicV14Field.repM F) g)
    (Lambda2Coordinates.lambda2MatrixRepresentation.ρ g)
    ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ g)⁻¹ :
      Matrix (Fin 15) (Fin 15) k) (by simp) hA
  calc (((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ compareBC F hzF) ≫
        V14SchemeModel.v14Schemeι
      = ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫
          (compareBC F hzF ≫ V14SchemeModel.v14Schemeι) := Category.assoc _ _ _
    _ = ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ toAmbient14BC F :=
        congrArg (fun m => ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ m)
          (compareBC_ι F hzF)
    _ = IntrinsicV14.schemeMap F (WeilRep.U F) (IntrinsicV14Field.inclM F)
          (IntrinsicV14Field.repM F g) (IntrinsicV14Field.repM F g⁻¹)
          (IntrinsicV14Field.coversM F g)
          (IntrinsicV14.repInvComp (IntrinsicV14Field.repM F) g) ≫ toAmbient14BC F :=
        congrArg (fun m => m ≫ toAmbient14BC F) hleft
    _ = toAmbient14BC F ≫ projectiveActionHom
          Lambda2Coordinates.lambda2MatrixRepresentation.ρ g := step
    _ = (compareBC F hzF ≫ V14SchemeModel.v14Schemeι) ≫ projectiveActionHom
          Lambda2Coordinates.lambda2MatrixRepresentation.ρ g :=
        congrArg (fun m => m ≫ projectiveActionHom
          Lambda2Coordinates.lambda2MatrixRepresentation.ρ g) (compareBC_ι F hzF).symm
    _ = compareBC F hzF ≫ (V14SchemeModel.v14Schemeι ≫ projectiveActionHom
          Lambda2Coordinates.lambda2MatrixRepresentation.ρ g) := Category.assoc _ _ _
    _ = compareBC F hzF ≫ ((V14SchemeModel.actionOver.ρ g).left ≫
          V14SchemeModel.v14Schemeι) :=
        congrArg (fun m => compareBC F hzF ≫ m)
          (V14SchemeModel.actionOver_hom_v14Schemeι g).symm
    _ = (compareBC F hzF ≫ (V14SchemeModel.actionOver.ρ g).left) ≫
          V14SchemeModel.v14Schemeι := (Category.assoc _ _ _).symm

/-! ## Retyped against the two `Action` carriers

`(intrinsicV14 F).V.left` and `IntrinsicV14.scheme F …` are the same scheme, as
are `actionOver.V.left` and `v14Scheme`, but only definitionally: `actionOver`
is built by a tactic block, so the elaborator will not find the identification
while it is also solving for something else.  Paying for it once, here, keeps
every composite below syntactically well typed.
-/

/-- The comparison, retyped against the carriers of the two actions. -/
@[expose] public def compareBCOver :
    (IntrinsicV14Field.intrinsicV14 F).V.left ⟶ V14SchemeModel.actionOver.V.left :=
  compareBC F hzF

public theorem compareBCOver_comm :
    compareBCOver F hzF ≫ V14SchemeModel.actionOver.V.hom =
      (IntrinsicV14Field.intrinsicV14 F).V.hom ≫
        Spec.map (CommRingCat.ofHom (algebraMap k F)) :=
  compareBC_comm F hzF

public theorem compareBCOver_equivariant (g : WeilLambda2.PSL2F11) :
    ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ compareBCOver F hzF =
      compareBCOver F hzF ≫ (V14SchemeModel.actionOver.ρ g).left :=
  compareBC_equivariant F hzF g

/-! ## Into the base change -/

/-- **The morphism from the intrinsic `V₁₄` over `F` to the base change of the
coordinate `V₁₄`.**  A morphism into a fibre product is a pair: the comparison
above, and the structure morphism to `Spec F`. -/
@[expose] public def compareBCPullback :
    (IntrinsicV14Field.intrinsicV14 F).V.left ⟶
      (V14SchemeModel.actionOverBaseChange F).V.left :=
  pullback.lift (compareBCOver F hzF) ((IntrinsicV14Field.intrinsicV14 F).V.hom)
    (compareBCOver_comm F hzF)

@[reassoc (attr := simp)]
public theorem compareBCPullback_fst :
    compareBCPullback F hzF ≫
        pullback.fst V14SchemeModel.actionOver.V.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k F))) = compareBCOver F hzF :=
  pullback.lift_fst _ _ _

@[reassoc (attr := simp)]
public theorem compareBCPullback_snd :
    compareBCPullback F hzF ≫
        pullback.snd V14SchemeModel.actionOver.V.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k F))) =
      (IntrinsicV14Field.intrinsicV14 F).V.hom :=
  pullback.lift_snd _ _ _

public instance compareBCPullback_isOver :
    (compareBCPullback F hzF).IsOver (Spec (.of F)) where
  comp_over := compareBCPullback_snd F hzF

public theorem compareBCPullback_equivariant (g : WeilLambda2.PSL2F11) :
    ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ compareBCPullback F hzF =
      compareBCPullback F hzF ≫
        ((V14SchemeModel.actionOverBaseChange F).ρ g).left := by
  have hfst : ((V14SchemeModel.actionOverBaseChange F).ρ g).left ≫
      pullback.fst V14SchemeModel.actionOver.V.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k F))) =
      pullback.fst V14SchemeModel.actionOver.V.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k F))) ≫
        (V14SchemeModel.actionOver.ρ g).left :=
    pullback.lift_fst _ _ _
  have hsnd : ((V14SchemeModel.actionOverBaseChange F).ρ g).left ≫
      pullback.snd V14SchemeModel.actionOver.V.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k F))) =
      pullback.snd V14SchemeModel.actionOver.V.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k F))) :=
    Over.w ((V14SchemeModel.actionOverBaseChange F).ρ g)
  have hbase : ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫
      (IntrinsicV14Field.intrinsicV14 F).V.hom =
      (IntrinsicV14Field.intrinsicV14 F).V.hom :=
    Over.w ((IntrinsicV14Field.intrinsicV14 F).ρ g)
  have leg1 : (((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ compareBCPullback F hzF) ≫
        pullback.fst V14SchemeModel.actionOver.V.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k F))) =
      (compareBCPullback F hzF ≫
          ((V14SchemeModel.actionOverBaseChange F).ρ g).left) ≫
        pullback.fst V14SchemeModel.actionOver.V.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k F))) := by
    calc (((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ compareBCPullback F hzF) ≫
          pullback.fst V14SchemeModel.actionOver.V.hom
            (Spec.map (CommRingCat.ofHom (algebraMap k F)))
        = ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫
            (compareBCPullback F hzF ≫
              pullback.fst V14SchemeModel.actionOver.V.hom
                (Spec.map (CommRingCat.ofHom (algebraMap k F)))) := Category.assoc _ _ _
      _ = ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ compareBCOver F hzF :=
          congrArg (fun m => ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ m)
            (compareBCPullback_fst F hzF)
      _ = compareBCOver F hzF ≫ (V14SchemeModel.actionOver.ρ g).left :=
          compareBCOver_equivariant F hzF g
      _ = (compareBCPullback F hzF ≫
            pullback.fst V14SchemeModel.actionOver.V.hom
              (Spec.map (CommRingCat.ofHom (algebraMap k F)))) ≫
            (V14SchemeModel.actionOver.ρ g).left :=
          congrArg (fun m => m ≫ (V14SchemeModel.actionOver.ρ g).left)
            (compareBCPullback_fst F hzF).symm
      _ = compareBCPullback F hzF ≫
            (pullback.fst V14SchemeModel.actionOver.V.hom
              (Spec.map (CommRingCat.ofHom (algebraMap k F))) ≫
                (V14SchemeModel.actionOver.ρ g).left) := Category.assoc _ _ _
      _ = compareBCPullback F hzF ≫
            (((V14SchemeModel.actionOverBaseChange F).ρ g).left ≫
              pullback.fst V14SchemeModel.actionOver.V.hom
                (Spec.map (CommRingCat.ofHom (algebraMap k F)))) :=
          congrArg (fun m => compareBCPullback F hzF ≫ m) hfst.symm
      _ = (compareBCPullback F hzF ≫
            ((V14SchemeModel.actionOverBaseChange F).ρ g).left) ≫
            pullback.fst V14SchemeModel.actionOver.V.hom
              (Spec.map (CommRingCat.ofHom (algebraMap k F))) :=
          (Category.assoc _ _ _).symm
  have leg2 : (((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ compareBCPullback F hzF) ≫
        pullback.snd V14SchemeModel.actionOver.V.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k F))) =
      (compareBCPullback F hzF ≫
          ((V14SchemeModel.actionOverBaseChange F).ρ g).left) ≫
        pullback.snd V14SchemeModel.actionOver.V.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k F))) := by
    calc (((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ compareBCPullback F hzF) ≫
          pullback.snd V14SchemeModel.actionOver.V.hom
            (Spec.map (CommRingCat.ofHom (algebraMap k F)))
        = ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫
            (compareBCPullback F hzF ≫
              pullback.snd V14SchemeModel.actionOver.V.hom
                (Spec.map (CommRingCat.ofHom (algebraMap k F)))) := Category.assoc _ _ _
      _ = ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫
            (IntrinsicV14Field.intrinsicV14 F).V.hom :=
          congrArg (fun m => ((IntrinsicV14Field.intrinsicV14 F).ρ g).left ≫ m)
            (compareBCPullback_snd F hzF)
      _ = (IntrinsicV14Field.intrinsicV14 F).V.hom := hbase
      _ = compareBCPullback F hzF ≫
            pullback.snd V14SchemeModel.actionOver.V.hom
              (Spec.map (CommRingCat.ofHom (algebraMap k F))) :=
          (compareBCPullback_snd F hzF).symm
      _ = compareBCPullback F hzF ≫
            (((V14SchemeModel.actionOverBaseChange F).ρ g).left ≫
              pullback.snd V14SchemeModel.actionOver.V.hom
                (Spec.map (CommRingCat.ofHom (algebraMap k F)))) :=
          congrArg (fun m => compareBCPullback F hzF ≫ m) hsnd.symm
      _ = (compareBCPullback F hzF ≫
            ((V14SchemeModel.actionOverBaseChange F).ρ g).left) ≫
            pullback.snd V14SchemeModel.actionOver.V.hom
              (Spec.map (CommRingCat.ofHom (algebraMap k F))) :=
          (Category.assoc _ _ _).symm
  exact pullback.hom_ext leg1 leg2

end IntrinsicV14BaseChange
end V14Formalization
