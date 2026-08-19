module

public import Mathlib

/-! # Trusted base

Target: `V14Formalization.Comparator.noEquivariantRationalMap_ambientFree`

Target: `V14Formalization.Comparator.noEquivariantRationalMap_from_ambient`

Target: `V14Formalization.Comparator.noEquivariantRationalMap_projectiveGVariety`

Boundary: V14Formalization, BConicBundleMultisections

212 declarations from 29 modules, inlined in dependency order with every proof replaced by `sorry`. Imports above are outside the boundary and are trusted as given.
-/

universe u v w

-- ═══ ProjectiveSpace ═══

@[expose] public section
open CategoryTheory Limits
open scoped AlgebraicGeometry
namespace BConicBundleMultisections
noncomputable section
open AlgebraicGeometry
attribute [local instance] MvPolynomial.gradedAlgebra

/-- Scheme-level projective `n`-space over a commutative ring `R`. -/
abbrev ProjectiveSpace (n : ℕ) (R : Type u) [CommRing R] : Scheme.{u} :=
  Proj (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)

namespace ProjectiveSpace

/-- The structure morphism from projective `n`-space over `R` to `Spec R`. -/
def toSpec (n : ℕ) (R : Type u) [CommRing R] : ProjectiveSpace n R ⟶ Spec (.of R) :=
  Proj.toSpecZero (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) ≫
    Spec.map (CommRingCat.ofHom
      (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)))

instance (n : ℕ) (R : Type u) [CommRing R] :
    (ProjectiveSpace n R).CanonicallyOver (Spec (.of R)) where
  hom := toSpec n R

/-- The degree-zero homogeneous localization defining the `i`-th standard affine chart. -/
abbrev StandardChartRing (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) : Type u :=
  HomogeneousLocalization.Away (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.X i)

/-- The canonical ring homomorphism from `R` to the ring of the `i`-th standard chart. -/
def standardChartRingHom (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    R →+* StandardChartRing n R i :=
  (algebraMap (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)
    (StandardChartRing n R i)).comp
      (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0))

/-- The canonical `R`-algebra structure on a standard projective-space chart. -/
instance standardChartRingAlgebra (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) : Algebra R (StandardChartRing n R i) where
  smul := (inferInstance : SMul R (StandardChartRing n R i)).smul
  algebraMap := standardChartRingHom n R i
  commutes' _ _ := sorry
  smul_def' r x := sorry

/-- The standard open immersion `Spec (R[X₀, …, Xₙ]_(Xᵢ))₀ ⟶ ℙⁿ_R`. -/
def standardChartι (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    Spec (.of (StandardChartRing n R i)) ⟶ ProjectiveSpace n R :=
  Proj.awayι (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) (MvPolynomial.X i)
    (MvPolynomial.isHomogeneous_X R i) zero_lt_one

end ProjectiveSpace
end
end BConicBundleMultisections


-- ═══ SchemeEquivariant ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry
open TopologicalSpace

/-- Package an absolute scheme action over `S` after proving that every action
morphism preserves the structure map. -/
@[expose] public noncomputable def actionOverOfIsOver
    {S : Scheme.{u}} {G : Type v} [Group G]
    (X : Action Scheme G) [X.V.Over S]
    (h : ∀ g : G, (X.ρ g).IsOver S) :
    Action (Over S) G where
  V := OverClass.asOver X.V S
  ρ :=
    { toFun := fun g ↦ by
        letI : (X.ρ g).IsOver S := h g
        exact (X.ρ g).asOver S
      map_one' := by
        apply Over.OverMorphism.ext
        simp
      map_mul' := fun g h ↦ by
        apply Over.OverMorphism.ext
        simp }

/-- Precompose a rational map by one automorphism from a group action. -/
@[expose] public noncomputable def actionPrecomp {S : Scheme.{u}} {G : Type v} [Group G]
    (X : Action (Over S) G) [IrreducibleSpace X.V.left]
    {Y : Scheme.{u}} (g : G)
    (f : X.V.left ⤏ Y) : X.V.left ⤏ Y := by
  let e : X.V.left ≅ X.V.left := (Over.forget S).mapIso (X.ρAut g)
  letI : IsIso (X.ρ g).left := by
    change IsIso e.hom
    infer_instance
  letI : IsDominant (X.ρ g).left := inferInstance
  letI : ((X.ρ g).left.toRationalMap).IsDominant := inferInstance
  exact (X.ρ g).left.toRationalMap.comp f

/-- A rational map over `S` commuting with the actions of `G`. -/
public structure EquivariantRationalMap {S : Scheme.{u}} {G : Type v} [Group G]
    (X Y : Action (Over S) G) [IrreducibleSpace X.V.left] where
  map : X.V.left ⤏ Y.V.left
  isOver : map.IsOver S
  equivariant : ∀ g : G,
    actionPrecomp X g map = map.compHom (Y.ρ g).left

/-- Existence of a genuine equivariant rational map of schemes. -/
@[expose] public def HasEquivariantRationalMap {S : Scheme.{u}} {G : Type v} [Group G]
    (X Y : Action (Over S) G) [IrreducibleSpace X.V.left] : Prop :=
  Nonempty (EquivariantRationalMap X Y)

end SchemeGeometry
end V14Formalization


-- ═══ BiprojectiveChart ═══

@[expose] public section
open scoped TensorProduct
namespace BConicBundleMultisections
noncomputable section
attribute [local instance] MvPolynomial.gradedAlgebra
namespace ProjectiveSpace

/-- The homogeneous coordinate `Xₗ`, divided by the distinguished chart coordinate `Xᵢ`. -/
def normalizedCoordinate (n : ℕ) (R : Type u) [CommRing R] (i l : Fin (n + 1)) :
    StandardChartRing n R i :=
  HomogeneousLocalization.Away.mk
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.isHomogeneous_X R i) 1
    (MvPolynomial.X l)
    (by simpa using MvPolynomial.isHomogeneous_X R l)

end ProjectiveSpace
end
end BConicBundleMultisections


-- ═══ Definitions ═══

noncomputable section
open scoped LinearAlgebra.Projectivization MatrixGroups
namespace V14Formalization

@[expose] public def IsInvolution {G : Type u} [Monoid G] (σ : G) : Prop :=
  σ ^ 2 = 1 ∧ σ ≠ 1

public structure FaithfulLinearRep (k : Type u) [Field k] (G : Type u) [Monoid G]
    (V : Type u) [AddCommGroup V] [Module k V] where
  ρ : Representation k G V
  finiteDimensional : FiniteDimensional k V
  faithful : Function.Injective ρ

namespace FaithfulLinearRep
variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

@[expose] public def act (R : FaithfulLinearRep k G V) (g : G) : V →ₗ[k] V := R.ρ g

@[expose] public def plusEigenspace (R : FaithfulLinearRep k G V) (σ : G) : Submodule k V :=
  Module.End.eigenspace (R.act σ) (1 : k)

@[expose] public def minusEigenspace (R : FaithfulLinearRep k G V) (σ : G) : Submodule k V :=
  Module.End.eigenspace (R.act σ) (-1 : k)

/-- In characteristic zero, an involution splits every honest linear
representation as its `+1` and `-1` eigenspaces. -/
public theorem isCompl_plus_minus (R : FaithfulLinearRep k G V) {σ : G}
    [CharZero k] (hσ : IsInvolution σ) :
    IsCompl (R.plusEigenspace σ) (R.minusEigenspace σ)  := sorry

end FaithfulLinearRep
end V14Formalization


-- ═══ LinearSubstitution ═══

@[expose] public section
namespace BConicBundleMultisections
noncomputable section
open MvPolynomial
open scoped Matrix
variable {R : Type u} [CommRing R]

/-- The linear forms substituted for the variables. -/
def linearSubst (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R) :
    Fin (n + 1) → MvPolynomial (Fin (n + 1)) R :=
  fun j => ∑ l : Fin (n + 1), C (M j l) * X l

/-- Each substituted form is homogeneous of degree one. -/
theorem isHomogeneous_linearSubst (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (j : Fin (n + 1)) : (linearSubst n M j).IsHomogeneous 1  := sorry

end
end BConicBundleMultisections


-- ═══ LinearCoordinateChange ═══

@[expose] public section
namespace BConicBundleMultisections
noncomputable section
open CategoryTheory
open AlgebraicGeometry HomogeneousIdeal MvPolynomial ProjectiveSpace
attribute [local instance] MvPolynomial.gradedAlgebra
variable {k : Type u} [CommRing k]

/-- A linear change of homogeneous coordinates, as a graded ring homomorphism.

Homogeneity is preserved because substituting degree-one forms multiplies degrees by one
(`MvPolynomial.IsHomogeneous.aeval`). -/
def linearSubstGradedRingHom (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) k) :
    (homogeneousSubmodule (Fin (n + 1)) k) →+*ᵍ (homogeneousSubmodule (Fin (n + 1)) k) where
  toRingHom :=
    (aeval (linearSubst n M) :
      MvPolynomial (Fin (n + 1)) k →ₐ[k] MvPolynomial (Fin (n + 1)) k).toRingHom
  map_mem {i} {a} ha := sorry

/-- An invertible linear substitution satisfies the hypothesis `Proj.map` requires: the irrelevant
ideal is contained in the image of the irrelevant ideal. -/
theorem irrelevant_le_map_linearSubst (n : ℕ) (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (h : N * M = 1) :
    (homogeneousSubmodule (Fin (n + 1)) k)₊ ≤
      ((homogeneousSubmodule (Fin (n + 1)) k)₊).map (linearSubstGradedRingHom n M)  := sorry

/-- The automorphism of `ℙⁿ_k` induced by an invertible linear change of homogeneous
coordinates. -/
def mapLinearSubst (n : ℕ) (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k) (h : N * M = 1) :
    ProjectiveSpace n k ⟶ ProjectiveSpace n k :=
  Proj.map (linearSubstGradedRingHom n M) (irrelevant_le_map_linearSubst n M N h)

end
end BConicBundleMultisections


-- ═══ SchemeProjectiveAction ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry BConicBundleMultisections
attribute [local instance] MvPolynomial.gradedAlgebra
variable {k : Type u} [Field k] {G : Type v} [Group G]

/-- A matrix representation on the `n+1` homogeneous coordinates of
scheme-level projective `n`-space.  Faithfulness is not needed to construct
the induced projective action. -/
public abbrev MatrixRepresentation (n : ℕ) := G →* GL (Fin (n + 1)) k

/-- A faithful matrix representation on the `n+1` homogeneous coordinates of
scheme-level projective `n`-space. -/
public structure FaithfulMatrixRepresentation (n : ℕ) where
  ρ : MatrixRepresentation (k := k) (G := G) n
  faithful : Function.Injective ρ

/-- The projective-scheme automorphism induced by one representation matrix. -/
@[expose] public def projectiveActionHom {n : ℕ}
    (R : MatrixRepresentation (k := k) (G := G) n) (g : G) :
    ProjectiveSpace n k ⟶ ProjectiveSpace n k :=
  mapLinearSubst n (↑(R g) : Matrix _ _ k) (↑((R g)⁻¹) : Matrix _ _ k) (by simp)

@[simp]
public theorem projectiveActionHom_one {n : ℕ}
    (R : MatrixRepresentation (k := k) (G := G) n) :
    projectiveActionHom R 1 = 𝟙 _  := sorry

public theorem projectiveActionHom_mul {n : ℕ}
    (R : MatrixRepresentation (k := k) (G := G) n) (g h : G) :
    projectiveActionHom R (g * h) =
      projectiveActionHom R h ≫ projectiveActionHom R g  := sorry

/-- Scheme-level projective space equipped with the action induced by `R`. -/
@[expose] public def projectiveAction (n : ℕ)
    (R : MatrixRepresentation (k := k) (G := G) n) :
    Action Scheme G where
  V := ProjectiveSpace n k
  ρ :=
    { toFun := projectiveActionHom R
      map_one' := projectiveActionHom_one R
      map_mul' := projectiveActionHom_mul R }

/-- Each projective action morphism preserves the canonical structure map to
`Spec k`. -/
@[expose] public instance projectiveActionHom_isOver {n : ℕ}
    (R : MatrixRepresentation (k := k) (G := G) n) (g : G) :
    (projectiveActionHom R g).IsOver (Spec (.of k))  := sorry

/-- Scheme-level projective space with its matrix action, genuinely packaged
as a scheme over `Spec k`. -/
@[expose] public def projectiveActionOver (n : ℕ)
    (R : MatrixRepresentation (k := k) (G := G) n) :
    Action (Over (Spec (.of k))) G := by
  letI : (projectiveAction n R).V.Over (Spec (.of k)) := by
    change (ProjectiveSpace n k).Over (Spec (.of k))
    infer_instance
  exact actionOverOfIsOver (projectiveAction n R) fun g ↦ by
    change (projectiveActionHom R g).IsOver (Spec (.of k))
    infer_instance

end SchemeGeometry
end V14Formalization


-- ═══ UniversalNormalDivisor ═══

noncomputable section
open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry BConicBundleMultisections Module
attribute [local instance] MvPolynomial.gradedAlgebra
variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

/-- Matrix coordinates for the full representation in a chosen basis. -/
@[expose] public def ambientMatrixRepresentation
    (R : FaithfulLinearRep k G V) (d : ℕ)
    (b : Basis (Fin (d + 1)) k V) :
    MatrixRepresentation (k := k) (G := G) d :=
  (Matrix.GeneralLinearGroup.toLin' b).symm.toMonoidHom.comp
    R.ρ.toHomUnits

/-- The source projective space with its honest full-group scheme action. -/
@[expose] public def ambientProjectiveActionOver
    (R : FaithfulLinearRep k G V) (d : ℕ)
    (b : Basis (Fin (d + 1)) k V) :
    Action (Over (Spec (.of k))) G :=
  projectiveActionOver d (ambientMatrixRepresentation R d b)

/-- The source projective scheme is integral. -/
@[expose] public instance ambientProjectiveActionOver_isIntegral
    (R : FaithfulLinearRep k G V) (d : ℕ)
    (b : Basis (Fin (d + 1)) k V) :
    IsIntegral (ambientProjectiveActionOver R d b).V.left  := sorry

/-- The ambient representation splits equivariantly into its two eigenspaces. -/
@[expose] public def plusMinusLinearEquiv [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G) (hσ : IsInvolution sigma) :
    V ≃ₗ[k] (R.plusEigenspace sigma × R.minusEigenspace sigma) :=
  ((R.plusEigenspace sigma).prodEquivOfIsCompl
    (R.minusEigenspace sigma) (R.isCompl_plus_minus hσ)).symm

/-- The block-order identification used for plus coordinates followed by
minus coordinates. -/
@[expose] public def finSumFinEquiv (m n : ℕ) : Fin m ⊕ Fin n ≃ Fin (m + n) where
  toFun := Sum.elim (Fin.castAdd n) (Fin.natAdd m)
  invFun := Fin.addCases Sum.inl Sum.inr
  left_inv x := sorry
  right_inv i := sorry

/-- The concrete block order has ambient projective dimension `p + q + 1`. -/
@[expose] public def plusMinusFinEquiv (p q : ℕ) :
    Fin (p + 1) ⊕ Fin (q + 1) ≃ Fin ((p + q + 1) + 1) :=
  (finSumFinEquiv (p + 1) (q + 1)).trans
    (Equiv.cast (congrArg Fin (by omega)))

/-- The ambient basis formed by concatenating the plus and minus bases and
transporting across the eigenspace decomposition.  These are the homogeneous
coordinates used by the normal valuation chart. -/
@[expose] public def plusMinusAmbientBasis [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G) (hσ : IsInvolution sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :
    Basis (Fin ((p + q + 1) + 1)) k V :=
  ((bp.prod bm).map (plusMinusLinearEquiv R sigma hσ).symm).reindex
    (plusMinusFinEquiv p q)

end SchemeGeometry
end V14Formalization


-- ═══ ProjectiveHypersurfaceScheme ═══

@[expose] public section
open CategoryTheory Limits
open scoped AlgebraicGeometry
namespace BConicBundleMultisections
noncomputable section
open AlgebraicGeometry
namespace ProjectiveSpace
attribute [local instance] MvPolynomial.gradedAlgebra

/-- The value of a homogeneous polynomial in normalized coordinates on a standard chart. -/
def hypersurfaceChartEquation
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1))
    (H : MvPolynomial (Fin (n + 1)) R) : StandardChartRing n R i :=
  MvPolynomial.aeval (fun l ↦ normalizedCoordinate n R i l) H

/-- Global sections of the standard chart identify with its homogeneous-localization ring. -/
def hypersurfaceChartΓIso
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    Γ(Spec (.of (StandardChartRing n R i)), ⊤) ≅ .of (StandardChartRing n R i) :=
  Scheme.ΓSpecIso (.of (StandardChartRing n R i))

/-- The chart equation as a global section of the affine standard chart. -/
def hypersurfaceChartEquationSection
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1))
    (H : MvPolynomial (Fin (n + 1)) R) :
    Γ(Spec (.of (StandardChartRing n R i)), ⊤) :=
  (hypersurfaceChartΓIso n R i).inv (hypersurfaceChartEquation n R i H)

/-- The principal ideal generated by the chart equation. -/
def hypersurfaceChartIdealTop
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1))
    (H : MvPolynomial (Fin (n + 1)) R) :
    Ideal Γ(Spec (.of (StandardChartRing n R i)), ⊤) :=
  Ideal.span {hypersurfaceChartEquationSection n R i H}

/-- The corresponding principal ideal sheaf on one standard chart. -/
def hypersurfaceChartIdealSheaf
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1))
    (H : MvPolynomial (Fin (n + 1)) R) :
    (Spec (.of (StandardChartRing n R i))).IdealSheafData :=
  Scheme.IdealSheafData.ofIdealTop (hypersurfaceChartIdealTop n R i H)

/-- The global ideal sheaf obtained by descending the homogeneous chart equations. -/
def projectiveZeroLocusIdeal
    (n : ℕ) (R : Type u) [CommRing R]
    (H : MvPolynomial (Fin (n + 1)) R) :
    (ProjectiveSpace n R).IdealSheafData :=
  ⨅ i : Fin (n + 1),
    (hypersurfaceChartIdealSheaf n R i H).map (standardChartι n R i)

end ProjectiveSpace
end
end BConicBundleMultisections
end


-- ═══ MultiProjectiveZeroLocus ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry BConicBundleMultisections
variable (n : ℕ) (R : Type u) [CommRing R]
variable {ι : Type v}

/-- The sum of the ideal sheaves generated by a family of projective
equations.  Its zero locus is their scheme-theoretic intersection. -/
@[expose] public def projectiveZeroLocusFamilyIdeal
    (F : ι → MvPolynomial (Fin (n + 1)) R) :
    (ProjectiveSpace n R).IdealSheafData :=
  ⨆ i, ProjectiveSpace.projectiveZeroLocusIdeal n R (F i)

/-- The closed projective subscheme cut out by a family of equations. -/
public abbrev projectiveZeroLocusFamily
    (F : ι → MvPolynomial (Fin (n + 1)) R) : Scheme.{u} :=
  (projectiveZeroLocusFamilyIdeal n R F).subscheme

/-- The canonical closed immersion of a family zero locus. -/
public abbrev projectiveZeroLocusFamilyι
    (F : ι → MvPolynomial (Fin (n + 1)) R) :
    projectiveZeroLocusFamily n R F ⟶ ProjectiveSpace n R :=
  (projectiveZeroLocusFamilyIdeal n R F).subschemeι

@[expose] public instance projectiveZeroLocusFamilyι_isClosedImmersion
    (F : ι → MvPolynomial (Fin (n + 1)) R) :
    IsClosedImmersion (projectiveZeroLocusFamilyι n R F)  := sorry

/-- The structure morphism inherited from projective space. -/
@[expose] public def projectiveZeroLocusFamilyToSpec
    (F : ι → MvPolynomial (Fin (n + 1)) R) :
    projectiveZeroLocusFamily n R F ⟶ Spec (.of R) :=
  projectiveZeroLocusFamilyι n R F ≫ ProjectiveSpace.toSpec n R

@[expose] public instance projectiveZeroLocusFamily_canonicallyOver
    (F : ι → MvPolynomial (Fin (n + 1)) R) :
    (projectiveZeroLocusFamily n R F).CanonicallyOver (Spec (.of R)) where
  hom := projectiveZeroLocusFamilyToSpec n R F

@[expose] public instance projectiveZeroLocusFamilyι_isOver
    (F : ι → MvPolynomial (Fin (n + 1)) R) :
    (projectiveZeroLocusFamilyι n R F).IsOver (Spec (.of R))  := sorry

end SchemeGeometry
end V14Formalization


-- ═══ InvariantSubschemeAction ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry
variable {G : Type v} [Group G]

/-- An ideal sheaf is invariant when every action morphism restricts to
its associated closed subscheme.  The reverse inclusion follows by applying
the condition to the inverse group element, but is not needed to construct
the restricted action. -/
public structure IsInvariantIdeal (A : Action Scheme G)
    (I : A.V.IdealSheafData) : Prop where
  le_map : ∀ g : G, I ≤ I.map (A.ρ g)

namespace IsInvariantIdeal
variable {A : Action Scheme G} {I : A.V.IdealSheafData}

/-- The restriction of one action morphism to the invariant subscheme. -/
@[expose] public def hom (hI : IsInvariantIdeal A I) (g : G) : I.subscheme ⟶ I.subscheme :=
  I.subschemeMap I (A.ρ g) (hI.le_map g)

@[reassoc]
public theorem hom_subschemeι (hI : IsInvariantIdeal A I) (g : G) :
    hI.hom g ≫ I.subschemeι = I.subschemeι ≫ A.ρ g  := sorry

@[simp]
public theorem hom_one (hI : IsInvariantIdeal A I) : hI.hom 1 = 𝟙 _  := sorry

public theorem hom_mul (hI : IsInvariantIdeal A I) (g h : G) :
    hI.hom (g * h) = hI.hom h ≫ hI.hom g  := sorry

/-- The induced action on the invariant closed subscheme. -/
@[expose] public def action (hI : IsInvariantIdeal A I) : Action Scheme G where
  V := I.subscheme
  ρ :=
    { toFun := hI.hom
      map_one' := hI.hom_one
      map_mul' := hI.hom_mul }

/-- If the ambient action is over `S`, so is the induced action on the
invariant closed subscheme. -/
@[expose] public def actionOver {S : Scheme.{u}} (hI : IsInvariantIdeal A I)
    [A.V.Over S] (hA : ∀ g : G, (A.ρ g).IsOver S) :
    Action (Over S) G := by
  letI hsub : I.subscheme.Over S :=
    ⟨I.subschemeι ≫ A.V ↘ S⟩
  letI : hI.action.V.Over S := by
    change I.subscheme.Over S
    exact hsub
  apply actionOverOfIsOver hI.action
  intro g
  change (hI.hom g).IsOver S
  refine ⟨?_⟩
  change hI.hom g ≫ I.subschemeι ≫ A.V ↘ S =
    I.subschemeι ≫ A.V ↘ S
  rw [← Category.assoc, hI.hom_subschemeι, Category.assoc]
  exact congrArg (fun f ↦ I.subschemeι ≫ f) (hA g).comp_over

end IsInvariantIdeal
end SchemeGeometry
end V14Formalization


-- ═══ GrassmannianLinearSection ═══

noncomputable section
open scoped BigOperators
open AlgebraicGeometry BConicBundleMultisections
namespace V14Formalization
namespace SchemeGeometry

/-- Six coordinate indices in one relation
`x_ab*x_cd - x_ac*x_bd + x_ad*x_bc`. -/
public structure PluckerRelation where
  p1 : Fin 15
  p2 : Fin 15
  p3 : Fin 15
  p4 : Fin 15
  p5 : Fin 15
  p6 : Fin 15

/-- The fifteen Plücker relations, in lexicographic `Λ⁴` order. -/
@[expose] public def pluckerRelation : Fin 15 → PluckerRelation := ![
  ⟨0,  9, 1,  6, 2,  5⟩,
  ⟨0, 10, 1,  7, 3,  5⟩,
  ⟨0, 11, 1,  8, 4,  5⟩,
  ⟨0, 12, 2,  7, 3,  6⟩,
  ⟨0, 13, 2,  8, 4,  6⟩,
  ⟨0, 14, 3,  8, 4,  7⟩,
  ⟨1, 12, 2, 10, 3,  9⟩,
  ⟨1, 13, 2, 11, 4,  9⟩,
  ⟨1, 14, 3, 11, 4, 10⟩,
  ⟨2, 14, 3, 13, 4, 12⟩,
  ⟨5, 12, 6, 10, 7,  9⟩,
  ⟨5, 13, 6, 11, 8,  9⟩,
  ⟨5, 14, 7, 11, 8, 10⟩,
  ⟨6, 14, 7, 13, 8, 12⟩,
  ⟨9, 14, 10, 13, 11, 12⟩
]

variable (R : Type u) [CommRing R]

/-- One Plücker quadric in the coordinate order fixed above. -/
@[expose] public def pluckerQuadric (q : Fin 15) : MvPolynomial (Fin 15) R :=
  let d := pluckerRelation q
  MvPolynomial.X d.p1 * MvPolynomial.X d.p2 -
    MvPolynomial.X d.p3 * MvPolynomial.X d.p4 +
      MvPolynomial.X d.p5 * MvPolynomial.X d.p6

/-- The `i`-th linear coordinate of `(P-I)x`. -/
@[expose] public def projectorLinearCut
    (P : Matrix (Fin 15) (Fin 15) R) (i : Fin 15) :
    MvPolynomial (Fin 15) R :=
  ∑ j : Fin 15,
    MvPolynomial.C (P i j - if i = j then 1 else 0) * MvPolynomial.X j

/-- Plücker equations followed by the projector-image equations. -/
@[expose] public def grassmannianLinearSectionEquations
    (P : Matrix (Fin 15) (Fin 15) R) :
    Fin 15 ⊕ Fin 15 → MvPolynomial (Fin 15) R
  | Sum.inl q => pluckerQuadric R q
  | Sum.inr i => projectorLinearCut R P i

/-- The actual scheme-theoretic intersection `Gr(2,6) ∩ P(im P)`
for a supplied coordinate projector `P`. -/
public abbrev grassmannianLinearSection
    (P : Matrix (Fin 15) (Fin 15) R) : Scheme :=
  projectiveZeroLocusFamily 14 R (grassmannianLinearSectionEquations R P)

/-- Its canonical closed immersion into coordinate `P¹⁴`. -/
public abbrev grassmannianLinearSectionι
    (P : Matrix (Fin 15) (Fin 15) R) :
    grassmannianLinearSection R P ⟶ ProjectiveSpace 14 R :=
  projectiveZeroLocusFamilyι 14 R (grassmannianLinearSectionEquations R P)

end SchemeGeometry
end V14Formalization


-- ═══ WeilRep ═══

open Polynomial AddChar MulChar Matrix BigOperators
noncomputable section
namespace V14Formalization
namespace WeilRep

@[expose] public instance : Fact (Nat.Prime 11)  := sorry

@[expose] public instance : NeZero (11 : ℕ)  := sorry

@[expose] public def Φ11 : ℚ[X] := cyclotomic 11 ℚ

@[expose] public instance : Fact (Irreducible Φ11)  := sorry

public abbrev K := AdjoinRoot Φ11

@[expose] public instance : Field K := inferInstance

@[expose] public instance : CharZero K  := sorry

@[expose] public def ζ : K := AdjoinRoot.root Φ11

public theorem ζ_pow_eleven : ζ ^ (11 : ℕ) = 1  := sorry

@[expose] public def ψ : AddChar (ZMod 11) K := zmodChar 11 ζ_pow_eleven

@[expose] public def χ₂ℤ : MulChar (ZMod 11) ℤ := quadraticChar (ZMod 11)

@[expose] public def χ₂ : MulChar (ZMod 11) K := χ₂ℤ.ringHomComp (algebraMap ℤ K)

@[expose] public def gauss : K := ∑ x : ZMod 11, ψ (x ^ 2)

@[expose] public def cFourier : K := gauss⁻¹

public abbrev Fun := ZMod 11 → K

@[expose] public instance : AddCommGroup Fun := inferInstance

@[expose] public instance : Module K Fun := inferInstance

/-- Full Fourier transform. -/
@[expose] public def Sfull : Fun →ₗ[K] Fun where
  toFun f := fun x => cFourier * ∑ y : ZMod 11, ψ (x * y) * f y
  map_add' f g := sorry
  map_smul' r f := sorry

/-- Even functions f(−x) = f(x). -/
@[expose] public def EvenSub : Submodule K Fun where
  carrier := {f | ∀ x, f (-x) = f x}
  add_mem' := sorry
  zero_mem' := sorry
  smul_mem' := sorry

public abbrev U := EvenSub

@[expose] public instance : Module K U := inferInstance

public abbrev Ucoord := Fin 6 → K

@[expose] public instance : Module K Ucoord := inferInstance

/-- Half-quadratic phase: ψ(b · x² / 2). Standard Weil normalization so that
the Bruhat big-cell formula matches the Fourier–unipotent identity W N(t) W. -/
@[expose] public def twoInv : ZMod 11 := (2 : ZMod 11)⁻¹

/-- Multiplication by ψ(b · x² / 2) on Fun; preserves even functions. -/
@[expose] public def Tfull_b (b : ZMod 11) : Fun →ₗ[K] Fun where
  toFun f := fun x => ψ (b * x ^ 2 * twoInv) * f x
  map_add' := sorry
  map_smul' := sorry

/-- The matrix S = [[0,-1],[1,0]] in SL₂(F₁₁). -/
@[expose] public def Smat : SpecialLinearGroup (Fin 2) (ZMod 11) :=
  ⟨!![0, -1; 1, 0], by
    simp [Matrix.det_fin_two_of]⟩

end WeilRep
end V14Formalization


-- ═══ WeilRepSL2 ═══

open Matrix Matrix.SpecialLinearGroup AddChar MulChar BigOperators
open V14Formalization.WeilRep
noncomputable section
namespace V14Formalization
namespace WeilRepSL2

public abbrev F := ZMod 11

public abbrev SLG := SpecialLinearGroup (Fin 2) F

@[expose] public instance : Fact (Nat.Prime 11)  := sorry

@[expose] public def ea (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 0 0

@[expose] public def eb (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 0 1

@[expose] public def ec (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 1 0

@[expose] public def ed (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 1 1

public theorem ea_ne_zero_of_ec_zero (g : SLG) (hc : ec g = 0) : ea g ≠ 0  := sorry

/-- ρ(diag(t)): f(x) ↦ χ₂(t) · f(t · x).  (Right scaling so D∘N(t)=N(t s²)∘D.) -/
@[expose] public def Dfull (t : F) (_ht : t ≠ 0) : Fun →ₗ[K] Fun where
  toFun f := fun x => χ₂ t * f (t * x)
  map_add' := sorry
  map_smul' := sorry

@[expose] public def Nfull (t : F) : Fun →ₗ[K] Fun := Tfull_b t

@[expose] public def Wfull : Fun →ₗ[K] Fun := Sfull

@[expose] public def borelFun (g : SLG) (hc : ec g = 0) : Fun →ₗ[K] Fun :=
  Nfull (eb g * ea g) ∘ₗ Dfull (ea g) (ea_ne_zero_of_ec_zero g hc)

/-- Positive NWDN kernel of a big-cell Bruhat factor. -/
@[expose] public def bigCellPos (g : SLG) (hc : ec g ≠ 0) : Fun →ₗ[K] Fun :=
  Nfull (ea g * (ec g)⁻¹) ∘ₗ Wfull ∘ₗ Dfull (ec g) hc ∘ₗ
    Nfull ((ec g)⁻¹ * ed g)

/-- Big-cell factor with the metaplectic sign so that the even Weil
representation of SL₂ is a true monoid homomorphism (D(−ec) = −D(ec)
on even functions forces this overall minus). -/
@[expose] public def bigCellFun (g : SLG) (hc : ec g ≠ 0) : Fun →ₗ[K] Fun :=
  - bigCellPos g hc

@[expose] public def weilFun (g : SLG) : Fun →ₗ[K] Fun :=
  if hc : ec g = 0 then borelFun g hc else bigCellFun g hc

public theorem weilFun_preserves_even (g : SLG) {f : Fun}
    (hf : ∀ x, f (-x) = f x) (x : ZMod 11) :
    weilFun g f (-x) = weilFun g f x  := sorry

/-- Weil action on the even module U. -/
@[expose] public def weilU (g : SLG) : U →ₗ[K] U where
  toFun f := ⟨weilFun g f.1, fun x => weilFun_preserves_even g (fun z => f.2 z) x⟩
  map_add' := sorry
  map_smul' := sorry

public theorem weilU_one : weilU (1 : SLG) = LinearMap.id  := sorry

end WeilRepSL2
end V14Formalization


-- ═══ WeilHom ═══

open Matrix Matrix.SpecialLinearGroup
open V14Formalization.WeilRep
open V14Formalization.WeilRepSL2
noncomputable section
namespace V14Formalization
namespace WeilHom

public abbrev F := ZMod 11

public abbrev SLG := SpecialLinearGroup (Fin 2) F

public theorem weilU_mul (g h : SLG) : weilU (g * h) = weilU g ∘ₗ weilU h  := sorry

/-- The even Weil representation as a monoid homomorphism SL₂(F₁₁) → End(U). -/
@[expose] public def weilUHom : SLG →* (U →ₗ[K] U) where
  toFun := weilU
  map_one' := sorry
  map_mul' := sorry

end WeilHom
end V14Formalization


-- ═══ GeometricFanoCarrier ═══

open scoped BigOperators LinearAlgebra.Projectivization MatrixGroups
open Matrix Matrix.SpecialLinearGroup exteriorPower Module
noncomputable section
namespace V14Formalization
namespace GeometricFanoCarrier

public abbrev k := WeilRep.K

public abbrev F := ZMod 11

public abbrev SLG := SpecialLinearGroup (Fin 2) F

public abbrev PSL2F11 : Type := PSL(2, F)

public abbrev U := WeilRep.U

@[expose] public instance : Fact (Nat.Prime 11)  := sorry

@[expose] public instance : Group PSL2F11 := inferInstance

/-- Evaluation of even functions at coordinates 0..5. -/
@[expose] public def evalEven : U →ₗ[k] (Fin 6 → k) where
  toFun f j := f.1 (j.val : ZMod 11)
  map_add' _ _ := sorry
  map_smul' _ _ := sorry

/-- Pointwise even extension of a 6-tuple (before packaging as an element of `U`). -/
@[expose] public def extendEvenFun (v : Fin 6 → k) : ZMod 11 → k := fun x =>
  if hle : x.val ≤ 5 then v ⟨x.val, Nat.lt_succ_of_le hle⟩
  else v ⟨11 - x.val, by
    have : 6 ≤ x.val := by omega
    have : x.val ≤ 10 := Nat.lt_succ_iff.mp (ZMod.val_lt x)
    omega⟩

public theorem extendEvenFun_even (v : Fin 6 → k) (x : ZMod 11) :
    extendEvenFun v (-x) = extendEvenFun v x  := sorry

/-- Even extension of a 6-tuple of values. -/
@[expose] public def extendEven : (Fin 6 → k) →ₗ[k] U where
  toFun v := ⟨extendEvenFun v, extendEvenFun_even v⟩
  map_add' := sorry
  map_smul' := sorry

public theorem evalEven_extendEven : evalEven ∘ₗ extendEven = LinearMap.id  := sorry

public theorem evalEven_injective : Function.Injective evalEven  := sorry

public abbrev Lambda2U : Type := ↥(⋀[k]^2 U)

@[expose] public instance : AddCommGroup Lambda2U := inferInstance

@[expose] public instance : Module k Lambda2U := inferInstance

@[expose] public def weilLambda2 (g : SLG) : Lambda2U →ₗ[k] Lambda2U :=
  exteriorPower.map 2 (WeilHom.weilUHom g)

public theorem weilLambda2_one : weilLambda2 1 = LinearMap.id  := sorry

public theorem weilLambda2_mul (g h : SLG) :
    weilLambda2 (g * h) = weilLambda2 g ∘ₗ weilLambda2 h  := sorry

@[expose] public def weilLambda2Hom : SLG →* (Lambda2U →ₗ[k] Lambda2U) where
  toFun := weilLambda2
  map_one' := sorry
  map_mul' := sorry

public theorem weilLambda2Hom_ker_center :
    Subgroup.center SLG ≤ weilLambda2Hom.ker  := sorry

@[expose] public def pslLambda2Hom : PSL2F11 →* (Lambda2U →ₗ[k] Lambda2U) :=
  QuotientGroup.lift (N := Subgroup.center SLG) weilLambda2Hom weilLambda2Hom_ker_center

public theorem pslLambda2Hom_injective : Function.Injective pslLambda2Hom  := sorry

end GeometricFanoCarrier
end V14Formalization


-- ═══ CentralizerD12 ═══

open scoped MatrixGroups
open Matrix Matrix.SpecialLinearGroup
noncomputable section
namespace V14Formalization
namespace CentralizerN

@[expose] public instance fact_prime_eleven' : Fact (Nat.Prime 11)  := sorry

public abbrev F := ZMod 11

public abbrev PSL2F11 := PSL(2, F)

@[expose] public def Circle1 := { p : F × F // p.1 ^ 2 + p.2 ^ 2 = 1 }

@[expose] public instance : Fintype Circle1 :=
  Fintype.subtype ((Finset.univ : Finset (F × F)).filter fun p => p.1 ^ 2 + p.2 ^ 2 = 1)
    (by intro; simp)

@[expose] public instance : Fintype PSL2F11 := QuotientGroup.fintype _

end CentralizerN
end V14Formalization


-- ═══ GeometricV14Carrier ═══

open scoped LinearAlgebra.Projectivization MatrixGroups
open Matrix Matrix.SpecialLinearGroup exteriorPower Module Polynomial IntermediateField
open LinearMap (IsProj)
open AdjoinRoot
open BigOperators Set
noncomputable section
namespace V14Formalization
namespace GeometricV14Carrier
open GeometricFanoCarrier

public abbrev k := GeometricFanoCarrier.k

public abbrev PSL2F11 := GeometricFanoCarrier.PSL2F11

public abbrev Lambda2U := GeometricFanoCarrier.Lambda2U

@[expose] public def ambientAct (g : PSL2F11) : Lambda2U →ₗ[k] Lambda2U := pslLambda2Hom g

@[expose] public def sigma : PSL2F11 := QuotientGroup.mk WeilRep.Smat

public theorem sigma_isInvolution : IsInvolution sigma  := sorry

open ExteriorAlgebra
open ExteriorAlgebra

/-- Character values of the irreducible `10'` of `PSL₂(𝔽₁₁)`, determined by element order.
    Table: `1A↦10, 2A↦2, 3A↦1, 5A/5B↦0, 6A↦-1, 11A/11B↦-1`. -/
@[expose] public noncomputable def chi10' (g : PSL2F11) : k :=
  let n := orderOf g
  if n = 1 then 10
  else if n = 2 then 2
  else if n = 3 then 1
  else if n = 5 then 0
  else if n = 6 then -1
  else if n = 11 then -1
  else 0

/-- Isotypic projector onto the 10′ summand `M ⊂ Λ²U`.
    `π = (10/|G|) ∑_g χ₁₀'(g) · ambientAct g`, with `|G| = 660`. -/
@[expose] public noncomputable def projectorM : Module.End k Lambda2U :=
  (10 * (660 : k)⁻¹) •
    ∑ g : PSL2F11, chi10' g • (ambientAct g : Module.End k Lambda2U)

open ExteriorAlgebra
open ConjAct ConjClasses
end GeometricV14Carrier
end V14Formalization


-- ═══ Lambda2Coordinates ═══

noncomputable section
open Set Matrix exteriorPower Module
namespace V14Formalization
namespace Lambda2Coordinates
open GeometricFanoCarrier SchemeGeometry

public abbrev k := GeometricFanoCarrier.k

public abbrev G := GeometricFanoCarrier.PSL2F11

public abbrev U := GeometricFanoCarrier.U

public abbrev Lambda2U := GeometricFanoCarrier.Lambda2U

/-- Evaluation at `0,...,5`, as an equivalence on the even Weil model. -/
@[expose] public noncomputable def evalEvenEquivCore : U ≃ₗ[k] (Fin 6 → k) := by
  apply LinearEquiv.ofBijective GeometricFanoCarrier.evalEven
  refine ⟨GeometricFanoCarrier.evalEven_injective, ?_⟩
  intro v
  refine ⟨GeometricFanoCarrier.extendEven v, ?_⟩
  simpa [LinearMap.comp_apply] using
    LinearMap.congr_fun GeometricFanoCarrier.evalEven_extendEven v

/-- The coordinate basis dual to evaluation at `0,...,5`. -/
@[expose] public noncomputable def uBasisCore : Basis (Fin 6) k U :=
  Basis.ofEquivFun evalEvenEquivCore

/-- The two-subset `{i,j}` with its cardinality certificate. -/
@[expose] public def pair (i j : Fin 6) (h : i ≠ j) : powersetCard (Fin 6) 2 :=
  ⟨{i, j}, by simp [Finset.card_pair h]⟩

/-- Lexicographic enumeration `01,02,03,04,05,12,...,45`. -/
@[expose] public def pairEnumeration : Fin 15 → powersetCard (Fin 6) 2 := ![
  pair 0 1 (by decide), pair 0 2 (by decide), pair 0 3 (by decide),
  pair 0 4 (by decide), pair 0 5 (by decide), pair 1 2 (by decide),
  pair 1 3 (by decide), pair 1 4 (by decide), pair 1 5 (by decide),
  pair 2 3 (by decide), pair 2 4 (by decide), pair 2 5 (by decide),
  pair 3 4 (by decide), pair 3 5 (by decide), pair 4 5 (by decide)]

public theorem pairEnumeration_bijective : Function.Bijective pairEnumeration  := sorry

/-- The exact Plücker coordinate order used by the sealed matrix data. -/
@[expose] public noncomputable def pluckerPairEquiv : powersetCard (Fin 6) 2 ≃ Fin 15 :=
  (Equiv.ofBijective pairEnumeration pairEnumeration_bijective).symm

/-- Exterior-square basis in lexicographic Plücker order. -/
@[expose] public noncomputable def lambda2Basis : Basis (Fin 15) k Lambda2U :=
  (uBasisCore.exteriorPower 2).reindex pluckerPairEquiv

/-- The actual faithful `15 × 15` representation of `PSL₂(F₁₁)` in the
lexicographic Plücker basis. -/
@[expose] public noncomputable def lambda2MatrixRepresentation :
    FaithfulMatrixRepresentation (k := k) (G := G) 14 where
  ρ := (Matrix.GeneralLinearGroup.toLin' lambda2Basis).symm.toMonoidHom.comp
    GeometricFanoCarrier.pslLambda2Hom.toHomUnits
  faithful :=
    sorry

end Lambda2Coordinates
end V14Formalization


-- ═══ V14SchemeModel ═══

noncomputable section
open Set Matrix exteriorPower Module
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace V14SchemeModel
open GeometricFanoCarrier GeometricV14Carrier Lambda2Coordinates SchemeGeometry
  BConicBundleMultisections

public abbrev k := GeometricV14Carrier.k

public abbrev G := GeometricV14Carrier.PSL2F11

/-- The character projector in the exact Plücker coordinate basis
`01,02,03,04,05,12,...,45`. -/
@[expose] public noncomputable def projectorMatrix : Matrix (Fin 15) (Fin 15) k :=
  LinearMap.toMatrix lambda2Basis lambda2Basis projectorM

/-- The scheme-theoretic intersection `Gr(2,6) ∩ P(M)` in the actual
representation coordinates. -/
public abbrev v14Scheme : AlgebraicGeometry.Scheme :=
  grassmannianLinearSection k projectorMatrix

/-- The canonical closed immersion of the coordinate V14 into `P¹⁴`. -/
public abbrev v14Schemeι : v14Scheme ⟶ ProjectiveSpace 14 k :=
  grassmannianLinearSectionι k projectorMatrix

/-- The genuine projective action before restriction to the V14 subscheme. -/
public abbrev ambientSchemeAction : Action AlgebraicGeometry.Scheme G :=
  projectiveAction 14 lambda2MatrixRepresentation.ρ

/-- The ideal sheaf defining the coordinate V14 inside `P¹⁴`. -/
public abbrev v14Ideal : (ProjectiveSpace 14 k).IdealSheafData :=
  projectiveZeroLocusFamilyIdeal 14 k
    (grassmannianLinearSectionEquations k projectorMatrix)

/-- The defining ideal sheaf of the coordinate V14 is invariant under the
genuine projective `PSL₂(F₁₁)` action. -/
public theorem invariantIdeal : IsInvariantIdeal ambientSchemeAction v14Ideal  := sorry

/-- The unconditional V14 action with its canonical structure morphism to
`Spec k`.  This is the base-preserving target used by equivariant rational
maps and proper specialization. -/
@[expose] public noncomputable def actionOver :
    Action (Over (AlgebraicGeometry.Spec (.of k))) G := by
  letI : ambientSchemeAction.V.Over (AlgebraicGeometry.Spec (.of k)) := by
    change (ProjectiveSpace 14 k).Over (AlgebraicGeometry.Spec (.of k))
    infer_instance
  exact invariantIdeal.actionOver fun g ↦ by
    change (projectiveActionHom lambda2MatrixRepresentation.ρ g).IsOver
      (AlgebraicGeometry.Spec (.of k))
    infer_instance

end V14SchemeModel
end V14Formalization


-- ═══ SchemeModelAliases ═══

namespace V14Formalization.SchemeGeometry

/-- The V14 base field, as used throughout the scheme-geometry namespace. -/
public abbrev k := V14SchemeModel.k

/-- The acting group `PSL₂(𝔽₁₁)`, as used throughout the scheme-geometry
namespace. -/
public abbrev G := V14SchemeModel.G

end V14Formalization.SchemeGeometry


-- ═══ ProjectiveGVariety ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry BConicBundleMultisections Module

/-- A closed subscheme of `ℙⁿ` with a `G`-action over `Spec k`. -/
public structure ProjectiveGVariety
    (k : Type u) [Field k] (G : Type v) [Group G] where
  /-- Geometric dimension of the ambient projective space. -/
  n : ℕ
  /-- `G`-action on a scheme over `Spec k`. -/
  action : Action (Over (Spec (.of k))) G
  /-- Closed immersion into Mathlib `Proj` of the standard graded polynomial ring. -/
  ι : action.V.left ⟶ ProjectiveSpace n k
  [closed : IsClosedImmersion ι]
  [ι_over : ι.IsOver (Spec (.of k))]

attribute [instance] ProjectiveGVariety.closed
attribute [instance] ProjectiveGVariety.ι_over
namespace ProjectiveGVariety
variable {k : Type u} [Field k] {G : Type v} [Group G]

/-- The underlying Mathlib scheme. -/
public abbrev toScheme (X : ProjectiveGVariety k G) : Scheme :=
  X.action.V.left

/-- Full projective space `ℙⁿ` with the action induced by a matrix representation. -/
@[expose] public def ofMatrixRepresentation (n : ℕ)
    (R : MatrixRepresentation (k := k) (G := G) n) :
    ProjectiveGVariety k G := by
  refine
    { n := n
      action := projectiveActionOver n R
      ι := eqToHom ?hleft
      closed := ?hcl
      ι_over := ?hover }
  · change (projectiveAction n R).V = ProjectiveSpace n k
    rfl
  · infer_instance
  · refine ⟨?_⟩
    -- `eqToHom rfl ≫ toSpec` is the structure map of `ℙⁿ`.
    rfl

/-- Projectivization of a faithful linear representation, as a projective
`G`-scheme.  Homogeneous coordinates come from the chosen basis. -/
@[expose] public def ofLinearRep {G : Type u} [Group G] {V : Type u}
    [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (d : ℕ) (b : Basis (Fin (d + 1)) k V) :
    ProjectiveGVariety k G :=
  ofMatrixRepresentation d (ambientMatrixRepresentation R d b)

/-- The coordinate V14, as a closed subscheme of `ℙ¹⁴` with its genuine
`PSL₂(𝔽₁₁)` action. -/
@[expose] public def v14 : ProjectiveGVariety V14SchemeModel.k V14SchemeModel.G where
  n := 14
  action := V14SchemeModel.actionOver
  ι := V14SchemeModel.v14Schemeι
  closed := sorry
  ι_over :=
    sorry

/-- Existence of a `G`-equivariant Mathlib rational map of the underlying
schemes over `Spec k`. -/
@[expose] public def HasEquivariantRationalMap (X Y : ProjectiveGVariety k G)
    [IrreducibleSpace X.toScheme] : Prop :=
  SchemeGeometry.HasEquivariantRationalMap X.action Y.action

end ProjectiveGVariety
end SchemeGeometry
end V14Formalization


-- ═══ SymmetricAlgebraGraded ═══

@[expose] public section
namespace SymmetricAlgebra
variable {R M : Type*} [CommSemiring R] [AddCommMonoid M] [Module R M]
open scoped DirectSum
variable (R M)

/-- A version of `SymmetricAlgebra.ι` that maps directly into the graded
structure.  This is primarily an auxiliary construction used to provide
`SymmetricAlgebra.gradedAlgebra`. -/
nonrec def GradedAlgebra.ι : M →ₗ[R] ⨁ i : ℕ, ↥(LinearMap.range (ι R M) ^ i) :=
  DirectSum.lof R ℕ (fun i => ↥(LinearMap.range (ι R M) ^ i)) 1 ∘ₗ
    (ι R M).codRestrict _ fun m => by simpa only [pow_one] using LinearMap.mem_range_self _ m

theorem GradedAlgebra.ι_apply (m : M) :
    GradedAlgebra.ι R M m =
      DirectSum.of (fun i : ℕ => ↥(LinearMap.range (SymmetricAlgebra.ι R M) ^ i)) 1
        ⟨SymmetricAlgebra.ι R M m, by
          simpa only [pow_one] using LinearMap.mem_range_self _ m⟩  := sorry

variable {R M}

/-- The symmetric algebra is graded by the powers of the submodule
`(SymmetricAlgebra.ι R M).range`. -/
instance gradedAlgebra :
    GradedAlgebra ((LinearMap.range (ι R M) ^ ·) : ℕ → Submodule R (SymmetricAlgebra R M)) :=
  fast_instance% GradedAlgebra.ofAlgHom _ (lift (GradedAlgebra.ι R M))
    (by
      ext m
      change DirectSum.coeAlgHom (fun i : ℕ => LinearMap.range (ι R M) ^ i)
          (lift (GradedAlgebra.ι R M) (ι R M m)) = ι R M m
      rw [lift_ι_apply, GradedAlgebra.ι_apply R M, DirectSum.coeAlgHom_of])
    fun i x => by
    obtain ⟨x, hx⟩ := x
    dsimp only [Subtype.coe_mk, DirectSum.lof_eq_of]
    induction hx using Submodule.pow_induction_on_left' with
    | algebraMap r =>
      rw [AlgHom.commutes, DirectSum.algebraMap_apply]; rfl
    | add x y i hx hy ihx ihy =>
      rw [map_add, ihx, ihy, ← map_add]
      rfl
    | mem_mul m hm i x hx ih =>
      obtain ⟨_, rfl⟩ := hm
      rw [map_mul, ih, lift_ι_apply, GradedAlgebra.ι_apply R M, DirectSum.of_mul_of]
      exact DirectSum.of_eq_of_gradedMonoid_eq (Sigma.subtype_ext (add_comm _ _) rfl)

/-- The grading on `SymmetricAlgebra R M`, as a named family.  `grade R M i` is
the `R`-submodule of elements of degree `i`. -/
abbrev grade (R M : Type*) [CommSemiring R] [AddCommMonoid M] [Module R M] :
    ℕ → Submodule R (SymmetricAlgebra R M) :=
  fun i => LinearMap.range (ι R M) ^ i

end SymmetricAlgebra


-- ═══ SymmetricAlgebraFunctor ═══

noncomputable section
@[expose] public section
open Module
attribute [local instance] MvPolynomial.gradedAlgebra
namespace SymmetricAlgebra
variable {κ R M N L : Type*} [CommSemiring R]
  [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module R N]
  [AddCommMonoid L] [Module R L]

/-- Functoriality of the symmetric algebra: a linear map `M →ₗ[R] N` induces an
algebra map `SymmetricAlgebra R M →ₐ[R] SymmetricAlgebra R N`.  This is the
symmetric-algebra analogue of `ExteriorAlgebra.map`. -/
def map (f : M →ₗ[R] N) : SymmetricAlgebra R M →ₐ[R] SymmetricAlgebra R N :=
  lift (ι R N ∘ₗ f)

lemma map_mem_grade (f : M →ₗ[R] N) {i : ℕ} {x : SymmetricAlgebra R M}
    (hx : x ∈ grade R M i) : map f x ∈ grade R N i  := sorry

/-- The symmetric algebra of a linear map, as a morphism of graded algebras. -/
def gradedMap (f : M →ₗ[R] N) : grade R M →ₐᵍ[R] grade R N :=
  { map f with map_mem := sorry }

end SymmetricAlgebra


-- ═══ ProjectiveSpaceIntrinsic ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry HomogeneousIdeal
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry Module SymmetricAlgebra
variable {k : Type u} [Field k] {V : Type u} [AddCommGroup V] [Module k V]

/-- Coordinate-free projective space: `Proj` of the symmetric algebra on the
dual of `V`.  This is `ℙ(V)` with no basis in sight. -/
@[expose] public def projectiveSpaceOfModule (k V : Type u) [Field k] [AddCommGroup V]
    [Module k V] : Scheme.{u} :=
  Proj (grade k (Dual k V))

/-- The structure morphism `ℙ(V) ⟶ Spec k`, built exactly as for `Proj` of a
polynomial ring. -/
@[expose] public def projectiveSpaceOfModule.toSpec (k V : Type u) [Field k] [AddCommGroup V]
    [Module k V] : projectiveSpaceOfModule k V ⟶ Spec (.of k) :=
  Proj.toSpecZero (grade k (Dual k V)) ≫
    Spec.map (CommRingCat.ofHom (algebraMap k (grade k (Dual k V) 0)))

public instance projectiveSpaceOfModule_over :
    (projectiveSpaceOfModule k V).CanonicallyOver (Spec (.of k)) where
  hom := projectiveSpaceOfModule.toSpec k V

/-- The graded algebra endomorphism of `Sym (V*)` induced by a linear
endomorphism of `V`, by transposing and applying `Sym`. -/
@[expose] public def dualGradedMap (f : V →ₗ[k] V) :
    grade k (Dual k V) →ₐᵍ[k] grade k (Dual k V) :=
  gradedMap (Module.Dual.transpose (R := k) f)

/-- The side condition of `Proj.map`, discharged whenever the endomorphism has
a two-sided partner making the composite the identity. -/
public theorem irrelevant_le_dualGradedMap (f g : V →ₗ[k] V) (h : g ∘ₗ f = LinearMap.id) :
    (grade k (Dual k V))₊ ≤ ((grade k (Dual k V))₊).map (dualGradedMap f).toGradedRingHom  := sorry

/-- The morphism of schemes `ℙ(V) ⟶ ℙ(V)` induced by a linear automorphism of
`V`, presented by the map and its inverse. -/
@[expose] public def projMapDual (f g : V →ₗ[k] V) (h : g ∘ₗ f = LinearMap.id) :
    projectiveSpaceOfModule k V ⟶ projectiveSpaceOfModule k V :=
  Proj.map (dualGradedMap f).toGradedRingHom (irrelevant_le_dualGradedMap f g h)

@[expose] public instance projMapDual_isOver (f g : V →ₗ[k] V) (h : g ∘ₗ f = LinearMap.id) :
    (projMapDual f g h).IsOver (Spec (.of k))  := sorry

end SchemeGeometry
end V14Formalization


-- ═══ ProjectiveSpaceIntrinsicAction ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry Module SymmetricAlgebra
variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

public theorem rep_inv_comp (ρ : Representation k G V) (g : G) :
    ρ g⁻¹ ∘ₗ ρ g = LinearMap.id  := sorry

/-- The automorphism of `ℙ(V)` attached to a group element. -/
@[expose] public def projRepHom (ρ : Representation k G V) (g : G) :
    projectiveSpaceOfModule k V ⟶ projectiveSpaceOfModule k V :=
  projMapDual (ρ g) (ρ g⁻¹) (rep_inv_comp ρ g)

@[simp] public theorem projRepHom_one (ρ : Representation k G V) :
    projRepHom ρ (1 : G) = 𝟙 _  := sorry

public theorem projRepHom_mul (ρ : Representation k G V) (a b : G) :
    projRepHom ρ (a * b) = projRepHom ρ b ≫ projRepHom ρ a  := sorry

/-- `ℙ(V)` with its `G`-action, in `Scheme`. -/
@[expose] public def projectiveActionOfRep (ρ : Representation k G V) : Action Scheme G where
  V := projectiveSpaceOfModule k V
  ρ :=
    { toFun := projRepHom ρ
      map_one' := projRepHom_one ρ
      map_mul' := projRepHom_mul ρ }

/-- `ℙ(V)` with its `G`-action, as a scheme over `Spec k`.  This is the
coordinate-free replacement for `ambientProjectiveActionOver`. -/
@[expose] public def projectiveActionOverOfRep (ρ : Representation k G V) :
    Action (Over (Spec (.of k))) G := by
  letI : (projectiveActionOfRep ρ).V.Over (Spec (.of k)) := by
    change (projectiveSpaceOfModule k V).Over (Spec (.of k))
    infer_instance
  exact actionOverOfIsOver (projectiveActionOfRep ρ) fun g ↦ by
    change (projRepHom ρ g).IsOver (Spec (.of k))
    exact projMapDual_isOver _ _ _

/-- The coordinate-free ambient projective space of a faithful representation,
with its action.  Compare `ambientProjectiveActionOver`, which needs a basis. -/
@[expose] public def ambientFree (R : FaithfulLinearRep k G V) :
    Action (Over (Spec (.of k))) G :=
  projectiveActionOverOfRep R.ρ

end SchemeGeometry
end V14Formalization


-- ═══ ProjectiveSpaceIntrinsicIrreducible ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry HomogeneousIdeal
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry Module SymmetricAlgebra
variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V] {d : ℕ}

@[expose] public instance ambientFree_irreducibleSpace
    [FiniteDimensional k V] [Nontrivial V] (R : FaithfulLinearRep k G V) :
    IrreducibleSpace (ambientFree R).V.left  := sorry

end SchemeGeometry
end V14Formalization


-- ═══ HeadlineStatement ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization.SchemeGeometry
open AlgebraicGeometry GeometricV14Carrier Module

public abbrev ambientFor
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :=
  ambientProjectiveActionOver R (p + q + 1)
    (plusMinusAmbientBasis R sigma sigma_isInvolution p q bp bm)

/-- Plus/minus homogeneous coordinates used by the normal chart.  This is a
hypothesis of the public theorems, which are stated for *every* such choice;
`PlusMinusCoords.ofRep` below shows the hypothesis is never vacuous. -/
public structure PlusMinusCoords
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) where
  p : ℕ
  q : ℕ
  bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma)
  bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)

/-- The numbered projective action of `R` in the plus/minus coordinates `c`. -/
public abbrev ambientOf
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (c : PlusMinusCoords R) :
    Action (Over (Spec (.of k))) G :=
  ambientFor R c.p c.q c.bp c.bm

namespace ProjectiveGVariety

/-- Projectivization of a faithful linear representation, as a closed
subscheme of the numbered `Proj` in the plus/minus coordinates `c`. -/
public abbrev ofFaithfulRep
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (c : PlusMinusCoords R) :
    ProjectiveGVariety k G :=
  ofLinearRep R (c.p + c.q + 1)
    (plusMinusAmbientBasis R sigma sigma_isInvolution c.p c.q c.bp c.bm)

@[expose] public instance ofFaithfulRep_irreducible
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (c : PlusMinusCoords R) :
    IrreducibleSpace (ofFaithfulRep R c).toScheme  := sorry

end ProjectiveGVariety
end V14Formalization.SchemeGeometry


-- ═══ V14Solution ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization.Comparator
open V14Formalization.SchemeGeometry
open AlgebraicGeometry Module

/-- **Coordinate-free form.**  There is no equivariant `Scheme.RationalMap`
from `ℙ(V) = Proj (Sym (V*))`, the projectivization of a faithful linear
representation, to the coordinate V14.

No basis of `V` and no system of homogeneous coordinates appears anywhere in
this statement; the `G`-action on `ℙ(V)` arrives by functoriality alone.  The
two coordinatized theorems below are corollaries of this one. -/
public theorem noEquivariantRationalMap_ambientFree
    {V : Type} [AddCommGroup V] [Module V14SchemeModel.k V]
    [FiniteDimensional V14SchemeModel.k V] [Nontrivial V]
    (R : FaithfulLinearRep V14SchemeModel.k V14SchemeModel.G V) :
    ¬ HasEquivariantRationalMap (ambientFree R)
      V14SchemeModel.actionOver  := sorry

public theorem noEquivariantRationalMap_from_ambient
    {V : Type} [AddCommGroup V] [Module V14SchemeModel.k V]
    (R : FaithfulLinearRep V14SchemeModel.k V14SchemeModel.G V)
    (c : PlusMinusCoords R) :
    ¬ HasEquivariantRationalMap (ambientOf R c)
      V14SchemeModel.actionOver  := sorry

public theorem noEquivariantRationalMap_projectiveGVariety
    {V : Type} [AddCommGroup V] [Module V14SchemeModel.k V]
    (R : FaithfulLinearRep V14SchemeModel.k V14SchemeModel.G V)
    (c : PlusMinusCoords R) :
    ¬ ProjectiveGVariety.HasEquivariantRationalMap
        (ProjectiveGVariety.ofFaithfulRep R c)
        ProjectiveGVariety.v14  := sorry

end V14Formalization.Comparator
