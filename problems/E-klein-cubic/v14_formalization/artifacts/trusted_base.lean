import Mathlib.LinearAlgebra.Center
import Mathlib.LinearAlgebra.FreeModule.Basic
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.Dimension.Finite
import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic
import Mathlib.AlgebraicGeometry.Pullbacks
import Mathlib.RingTheory.MvPolynomial.Homogeneous
import Mathlib.RingTheory.MvPolynomial.Ideal
import Mathlib.AlgebraicGeometry.Birational.Composition
import Mathlib.CategoryTheory.Action.Basic
import Mathlib.CategoryTheory.Comma.Over.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import Mathlib.LinearAlgebra.Basis.Prod
import Mathlib.LinearAlgebra.Dimension.Free
import Mathlib.RingTheory.Polynomial.Cyclotomic.Basic
import Mathlib.RingTheory.Polynomial.Cyclotomic.Roots
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.NumberTheory.LegendreSymbol.AddCharacter
import Mathlib.NumberTheory.GaussSum
import Mathlib.NumberTheory.MulChar.Basic
import Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic
import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Field.ZMod
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.Algebra.Module.Pi
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Algebra.Algebra.Basic
import Mathlib.Algebra.CharP.Basic
import Mathlib.FieldTheory.Minpoly.Field
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.ExteriorPower.Basic
import Mathlib.LinearAlgebra.ExteriorPower.Basis
import Mathlib.LinearAlgebra.Dimension.StrongRankCondition
import Mathlib.LinearAlgebra.Basis.VectorSpace
import Mathlib.LinearAlgebra.Projectivization.Basic
import Mathlib.LinearAlgebra.Projectivization.PSL.PSL2
import Mathlib.GroupTheory.QuotientGroup.Basic
import Mathlib.GroupTheory.Subgroup.Center
import Mathlib.GroupTheory.Subgroup.Simple
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Data.Set.PowersetCard
import Mathlib.Order.Hom.PowersetCard
import Mathlib.Data.Finset.Sort
import Mathlib.Tactic.FinCases
import Mathlib.LinearAlgebra.Matrix.ProjectiveSpecialLinearGroup
import Mathlib.Data.Nat.Prime.Defs
import Mathlib.GroupTheory.SpecificGroups.Dihedral
import Mathlib.Algebra.Group.Subgroup.Finite
import Mathlib.GroupTheory.Subgroup.Centralizer
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Card
import Mathlib.GroupTheory.Index
import Mathlib.GroupTheory.SpecificGroups.Cyclic
import Mathlib.RingTheory.RootsOfUnity.Basic
import Mathlib.NumberTheory.Cyclotomic.PrimitiveRoots
import Mathlib.RingTheory.RootsOfUnity.PrimitiveRoots
import Mathlib.RingTheory.PowerBasis
import Mathlib.FieldTheory.IntermediateField.Adjoin.Basic
import Mathlib.FieldTheory.IntermediateField.Algebraic
import Mathlib.FieldTheory.KummerPolynomial
import Mathlib.RingTheory.PrincipalIdealDomain
import Mathlib.LinearAlgebra.Charpoly.Basic
import Mathlib.Algebra.Module.LinearMap.End
import Mathlib.Algebra.Polynomial.Degree.SmallDegree
import Mathlib.Algebra.Polynomial.EraseLead
import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.Algebra.Polynomial.Div
import Mathlib.Algebra.Polynomial.FieldDivision
import Mathlib.Algebra.Polynomial.SpecificDegree
import Mathlib.Data.Rat.Lemmas
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.Dimension.OrzechProperty
import Mathlib.LinearAlgebra.Dual.Lemmas
import Mathlib.GroupTheory.Coset.Card
import Mathlib.GroupTheory.Sylow
import Mathlib.GroupTheory.PGroup
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Set.Card
import Mathlib.LinearAlgebra.Trace
import Mathlib.LinearAlgebra.Projection
import Mathlib.Algebra.Group.Idempotent
import Mathlib.LinearAlgebra.Semisimple
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.LinearAlgebra.Charpoly.ToMatrix
import Mathlib.RingTheory.Trace.Basic
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.RingTheory.AlgebraTower
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.RingTheory.Ideal.Quotient.Defs
import Mathlib.Data.Finset.Card
import Mathlib.RingTheory.Polynomial.Basic
import Mathlib.Algebra.GroupWithZero.Associated
import Mathlib.AlgebraicGeometry.IdealSheaf.Functorial
import Mathlib.Algebra.CharZero.Infinite

/-! # Trusted base

Target: `V14Formalization.Comparator.noEquivariantRationalMap_from_ambient`

Boundary: V14Formalization, BConicBundleMultisections

155 declarations from 22 modules, inlined in dependency order with every proof replaced by `sorry`. Imports above are outside the boundary and are trusted as given.
-/

universe u v w

-- ═══ Definitions ═══

noncomputable section
open scoped LinearAlgebra.Projectivization MatrixGroups
namespace V14Formalization

def IsInvolution {G : Type u} [Monoid G] (σ : G) : Prop :=
  σ ^ 2 = 1 ∧ σ ≠ 1

structure FaithfulLinearRep (k : Type u) [Field k] (G : Type u) [Monoid G]
    (V : Type u) [AddCommGroup V] [Module k V] where
  ρ : Representation k G V
  finiteDimensional : FiniteDimensional k V
  faithful : Function.Injective ρ

namespace FaithfulLinearRep
variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

def act (R : FaithfulLinearRep k G V) (g : G) : V →ₗ[k] V := R.ρ g

def plusEigenspace (R : FaithfulLinearRep k G V) (σ : G) : Submodule k V :=
  Module.End.eigenspace (R.act σ) (1 : k)

def minusEigenspace (R : FaithfulLinearRep k G V) (σ : G) : Submodule k V :=
  Module.End.eigenspace (R.act σ) (-1 : k)

/-- In characteristic zero, an involution splits every honest linear
representation as its `+1` and `-1` eigenspaces. -/
theorem isCompl_plus_minus (R : FaithfulLinearRep k G V) {σ : G}
    [CharZero k] (hσ : IsInvolution σ) :
    IsCompl (R.plusEigenspace σ) (R.minusEigenspace σ)  := sorry

end FaithfulLinearRep
namespace SmoothProjectiveGVariety
variable {k : Type u} [Field k] {G : Type u} [Group G]
  (Y : SmoothProjectiveGVariety k G)
end SmoothProjectiveGVariety
namespace FaithfulLinearRep
variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]
end FaithfulLinearRep
end V14Formalization

-- ═══ ProjectiveSpace ═══

open CategoryTheory Limits
open scoped AlgebraicGeometry
namespace BConicBundleMultisections
noncomputable section
open AlgebraicGeometry

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
  commutes' _ _ := mul_comm _ _
  smul_def' r x := by
    apply HomogeneousLocalization.val_injective
    rw [HomogeneousLocalization.val_smul, HomogeneousLocalization.val_mul, Algebra.smul_def]
    rfl

/-- The standard open immersion `Spec (R[X₀, …, Xₙ]_(Xᵢ))₀ ⟶ ℙⁿ_R`. -/
def standardChartι (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    Spec (.of (StandardChartRing n R i)) ⟶ ProjectiveSpace n R :=
  Proj.awayι (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) (MvPolynomial.X i)
    (MvPolynomial.isHomogeneous_X R i) zero_lt_one

end ProjectiveSpace
namespace BiprojectiveSpace
end BiprojectiveSpace
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
noncomputable def actionOverOfIsOver
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
noncomputable def actionPrecomp {S : Scheme.{u}} {G : Type v} [Group G]
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
structure EquivariantRationalMap {S : Scheme.{u}} {G : Type v} [Group G]
    (X Y : Action (Over S) G) [IrreducibleSpace X.V.left] where
  map : X.V.left ⤏ Y.V.left
  isOver : map.IsOver S
  equivariant : ∀ g : G,
    actionPrecomp X g map = map.compHom (Y.ρ g).left

namespace EquivariantRationalMap
variable {S : Scheme.{u}} {G : Type v} [Group G]
  {X Y : Action (Over S) G} [IrreducibleSpace X.V.left]
end EquivariantRationalMap

/-- Existence of a genuine equivariant rational map of schemes. -/
def HasEquivariantRationalMap {S : Scheme.{u}} {G : Type v} [Group G]
    (X Y : Action (Over S) G) [IrreducibleSpace X.V.left] : Prop :=
  Nonempty (EquivariantRationalMap X Y)

end SchemeGeometry
end V14Formalization

-- ═══ LinearSubstitution ═══

namespace BConicBundleMultisections
noncomputable section
open MvPolynomial
open scoped Matrix
variable {R : Type u} [CommRing R]

/-- The linear forms substituted for the variables. -/
def linearSubst (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R) :
    Fin (n + 1) → MvPolynomial (Fin (n + 1)) R :=
  fun j => ∑ l : Fin (n + 1), C (M j l) * X l

end
end BConicBundleMultisections

-- ═══ LinearCoordinateChange ═══

namespace BConicBundleMultisections
noncomputable section
open CategoryTheory
open AlgebraicGeometry HomogeneousIdeal MvPolynomial ProjectiveSpace
variable {k : Type u} [CommRing k]

/-- A linear change of homogeneous coordinates, as a graded ring homomorphism.

Homogeneity is preserved because substituting degree-one forms multiplies degrees by one
(`MvPolynomial.IsHomogeneous.aeval`). -/
def linearSubstGradedRingHom (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) k) :
    (homogeneousSubmodule (Fin (n + 1)) k) →+*ᵍ (homogeneousSubmodule (Fin (n + 1)) k) where
  toRingHom :=
    (aeval (linearSubst n M) :
      MvPolynomial (Fin (n + 1)) k →ₐ[k] MvPolynomial (Fin (n + 1)) k).toRingHom
  map_mem {i} {a} ha := by
    have h := (ha : a.IsHomogeneous i).aeval (linearSubst n M) (isHomogeneous_linearSubst n M)
    simpa using h

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
variable {k : Type u} [Field k] {G : Type v} [Group G]

/-- A matrix representation on the `n+1` homogeneous coordinates of
scheme-level projective `n`-space.  Faithfulness is not needed to construct
the induced projective action. -/
abbrev MatrixRepresentation (n : ℕ) := G →* GL (Fin (n + 1)) k

/-- A faithful matrix representation on the `n+1` homogeneous coordinates of
scheme-level projective `n`-space. -/
structure FaithfulMatrixRepresentation (n : ℕ) where
  ρ : MatrixRepresentation (k := k) (G := G) n
  faithful : Function.Injective ρ

/-- The projective-scheme automorphism induced by one representation matrix. -/
def projectiveActionHom {n : ℕ}
    (R : MatrixRepresentation (k := k) (G := G) n) (g : G) :
    ProjectiveSpace n k ⟶ ProjectiveSpace n k :=
  mapLinearSubst n (↑(R g) : Matrix _ _ k) (↑((R g)⁻¹) : Matrix _ _ k) (by simp)

@[simp]
theorem projectiveActionHom_one {n : ℕ}
    (R : MatrixRepresentation (k := k) (G := G) n) :
    projectiveActionHom R 1 = 𝟙 _  := sorry

theorem projectiveActionHom_mul {n : ℕ}
    (R : MatrixRepresentation (k := k) (G := G) n) (g h : G) :
    projectiveActionHom R (g * h) =
      projectiveActionHom R h ≫ projectiveActionHom R g  := sorry

/-- Scheme-level projective space equipped with the action induced by `R`. -/
def projectiveAction (n : ℕ)
    (R : MatrixRepresentation (k := k) (G := G) n) :
    Action Scheme G where
  V := ProjectiveSpace n k
  ρ :=
    { toFun := projectiveActionHom R
      map_one' := projectiveActionHom_one R
      map_mul' := projectiveActionHom_mul R }

/-- Scheme-level projective space with its matrix action, genuinely packaged
as a scheme over `Spec k`. -/
def projectiveActionOver (n : ℕ)
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

-- ═══ BiprojectiveChart ═══

open scoped TensorProduct
namespace BConicBundleMultisections
noncomputable section
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
namespace BiprojectiveSpace
end BiprojectiveSpace
end
end BConicBundleMultisections

-- ═══ UniversalNormalDivisor ═══

noncomputable section
open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry BConicBundleMultisections Module
variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

/-- Matrix coordinates for the full representation in a chosen basis. -/
def ambientMatrixRepresentation
    (R : FaithfulLinearRep k G V) (d : ℕ)
    (b : Basis (Fin (d + 1)) k V) :
    MatrixRepresentation (k := k) (G := G) d :=
  (Matrix.GeneralLinearGroup.toLin' b).symm.toMonoidHom.comp
    R.ρ.toHomUnits

/-- The source projective space with its honest full-group scheme action. -/
def ambientProjectiveActionOver
    (R : FaithfulLinearRep k G V) (d : ℕ)
    (b : Basis (Fin (d + 1)) k V) :
    Action (Over (Spec (.of k))) G :=
  projectiveActionOver d (ambientMatrixRepresentation R d b)

/-- The source projective scheme is integral. -/
instance ambientProjectiveActionOver_isIntegral
    (R : FaithfulLinearRep k G V) (d : ℕ)
    (b : Basis (Fin (d + 1)) k V) :
    IsIntegral (ambientProjectiveActionOver R d b).V.left  := sorry

/-- The ambient representation splits equivariantly into its two eigenspaces. -/
def plusMinusLinearEquiv [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G) (hσ : IsInvolution sigma) :
    V ≃ₗ[k] (R.plusEigenspace sigma × R.minusEigenspace sigma) :=
  ((R.plusEigenspace sigma).prodEquivOfIsCompl
    (R.minusEigenspace sigma) (R.isCompl_plus_minus hσ)).symm

/-- The block-order identification used for plus coordinates followed by
minus coordinates. -/
def finSumFinEquiv (m n : ℕ) : Fin m ⊕ Fin n ≃ Fin (m + n) where
  toFun := Sum.elim (Fin.castAdd n) (Fin.natAdd m)
  invFun := Fin.addCases Sum.inl Sum.inr
  left_inv x := by cases x <;> simp
  right_inv i := by
    refine Fin.addCases ?_ ?_ i
    · intro j
      simp
    · intro j
      simp

/-- The concrete block order has ambient projective dimension `p + q + 1`. -/
def plusMinusFinEquiv (p q : ℕ) :
    Fin (p + 1) ⊕ Fin (q + 1) ≃ Fin ((p + q + 1) + 1) :=
  (finSumFinEquiv (p + 1) (q + 1)).trans
    (Equiv.cast (congrArg Fin (by omega)))

/-- The ambient basis formed by concatenating the plus and minus bases and
transporting across the eigenspace decomposition.  These are the homogeneous
coordinates used by the normal valuation chart. -/
def plusMinusAmbientBasis [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G) (hσ : IsInvolution sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :
    Basis (Fin ((p + q + 1) + 1)) k V :=
  ((bp.prod bm).map (plusMinusLinearEquiv R sigma hσ).symm).reindex
    (plusMinusFinEquiv p q)

end SchemeGeometry
end V14Formalization

-- ═══ WeilRep ═══

open Polynomial AddChar MulChar Matrix BigOperators
noncomputable section
namespace V14Formalization
namespace WeilRep

instance : Fact (Nat.Prime 11)  := sorry

instance : NeZero (11 : ℕ)  := sorry

def Φ11 : ℚ[X] := cyclotomic 11 ℚ

instance : Fact (Irreducible Φ11)  := sorry

abbrev K := AdjoinRoot Φ11

instance : Field K := inferInstance

instance : CharZero K  := sorry

def ζ : K := AdjoinRoot.root Φ11

theorem ζ_pow_eleven : ζ ^ (11 : ℕ) = 1  := sorry

def ψ : AddChar (ZMod 11) K := zmodChar 11 ζ_pow_eleven

def χ₂ℤ : MulChar (ZMod 11) ℤ := quadraticChar (ZMod 11)

def χ₂ : MulChar (ZMod 11) K := χ₂ℤ.ringHomComp (algebraMap ℤ K)

def gauss : K := ∑ x : ZMod 11, ψ (x ^ 2)

def cFourier : K := gauss⁻¹

abbrev Fun := ZMod 11 → K

instance : AddCommGroup Fun := inferInstance

instance : Module K Fun := inferInstance

/-- Full Fourier transform. -/
def Sfull : Fun →ₗ[K] Fun where
  toFun f := fun x => cFourier * ∑ y : ZMod 11, ψ (x * y) * f y
  map_add' f g := by
    funext x
    simp only [Pi.add_apply]
    rw [← mul_add, ← Finset.sum_add_distrib]
    congr 1
    exact Finset.sum_congr rfl fun y _ => by ring
  map_smul' r f := by
    funext x
    simp only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply]
    -- c * Σ ψ*(r*f) = c * r * Σ ψ*f
    have h : (∑ y : ZMod 11, ψ (x * y) * (r * f y)) =
        r * ∑ y : ZMod 11, ψ (x * y) * f y := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl fun y _ => by ring
    rw [h, mul_left_comm]

/-- Even functions f(−x) = f(x). -/
def EvenSub : Submodule K Fun where
  carrier := {f | ∀ x, f (-x) = f x}
  add_mem' := fun {f g} hf hg x => by simp [hf x, hg x]
  zero_mem' := fun x => rfl
  smul_mem' := fun r {f} hf x => by simp [hf x]

abbrev U := EvenSub

instance : Module K U := inferInstance

abbrev Ucoord := Fin 6 → K

instance : Module K Ucoord := inferInstance

/-- Multiplication by ψ(x² / 2) preserves even functions. (Matches `Tfull_b 1`.) -/
def Tfull : Fun →ₗ[K] Fun where
  toFun f := fun x => ψ (x ^ 2 * (2 : ZMod 11)⁻¹) * f x
  map_add' := by
    intro f g; funext x
    simp only [Pi.add_apply]; ring
  map_smul' := by
    intro r f; funext x
    simp only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply]; ring

/-- Half-quadratic phase: ψ(b · x² / 2). Standard Weil normalization so that
the Bruhat big-cell formula matches the Fourier–unipotent identity W N(t) W. -/
def twoInv : ZMod 11 := (2 : ZMod 11)⁻¹

/-- Multiplication by ψ(b · x² / 2) on Fun; preserves even functions. -/
def Tfull_b (b : ZMod 11) : Fun →ₗ[K] Fun where
  toFun f := fun x => ψ (b * x ^ 2 * twoInv) * f x
  map_add' := by
    intro f g; funext x
    simp only [Pi.add_apply]; ring
  map_smul' := by
    intro r f; funext x
    simp only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply]; ring

/-- The matrix S = [[0,-1],[1,0]] in SL₂(F₁₁). -/
def Smat : SpecialLinearGroup (Fin 2) (ZMod 11) :=
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

abbrev F := ZMod 11

abbrev SLG := SpecialLinearGroup (Fin 2) F

instance : Fact (Nat.Prime 11)  := sorry

def ea (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 0 0

def eb (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 0 1

def ec (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 1 0

def ed (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 1 1

theorem ea_ne_zero_of_ec_zero (g : SLG) (hc : ec g = 0) : ea g ≠ 0  := sorry

/-- ρ(diag(t)): f(x) ↦ χ₂(t) · f(t · x).  (Right scaling so D∘N(t)=N(t s²)∘D.) -/
def Dfull (t : F) (_ht : t ≠ 0) : Fun →ₗ[K] Fun where
  toFun f := fun x => χ₂ t * f (t * x)
  map_add' := by
    intro f g; funext x; simp [Pi.add_apply]; ring
  map_smul' := by
    intro r f; funext x; simp [Pi.smul_apply, smul_eq_mul]; ring

def Nfull (t : F) : Fun →ₗ[K] Fun := Tfull_b t

def Wfull : Fun →ₗ[K] Fun := Sfull

def borelFun (g : SLG) (hc : ec g = 0) : Fun →ₗ[K] Fun :=
  Nfull (eb g * ea g) ∘ₗ Dfull (ea g) (ea_ne_zero_of_ec_zero g hc)

/-- Positive NWDN kernel of a big-cell Bruhat factor. -/
def bigCellPos (g : SLG) (hc : ec g ≠ 0) : Fun →ₗ[K] Fun :=
  Nfull (ea g * (ec g)⁻¹) ∘ₗ Wfull ∘ₗ Dfull (ec g) hc ∘ₗ
    Nfull ((ec g)⁻¹ * ed g)

/-- Big-cell factor with the metaplectic sign so that the even Weil
representation of SL₂ is a true monoid homomorphism (D(−ec) = −D(ec)
on even functions forces this overall minus). -/
def bigCellFun (g : SLG) (hc : ec g ≠ 0) : Fun →ₗ[K] Fun :=
  - bigCellPos g hc

def weilFun (g : SLG) : Fun →ₗ[K] Fun :=
  if hc : ec g = 0 then borelFun g hc else bigCellFun g hc

/-- Weil action on the even module U. -/
def weilU (g : SLG) : U →ₗ[K] U where
  toFun f := ⟨weilFun g f.1, fun x => weilFun_preserves_even g (fun z => f.2 z) x⟩
  map_add' := by
    intro f₁ f₂
    apply Subtype.ext
    exact (weilFun g).map_add f₁.1 f₂.1
  map_smul' := by
    intro r f
    apply Subtype.ext
    exact (weilFun g).map_smul r f.1

theorem weilU_one : weilU (1 : SLG) = LinearMap.id  := sorry

end WeilRepSL2
end V14Formalization

-- ═══ WeilHom ═══

open Matrix Matrix.SpecialLinearGroup
open V14Formalization.WeilRep
open V14Formalization.WeilRepSL2
open V14Formalization.WeilMul
open V14Formalization.WeilWN
noncomputable section
namespace V14Formalization
namespace WeilHom

abbrev F := ZMod 11

abbrev SLG := SpecialLinearGroup (Fin 2) F

theorem weilU_mul (g h : SLG) : weilU (g * h) = weilU g ∘ₗ weilU h  := sorry

/-- The even Weil representation as a monoid homomorphism SL₂(F₁₁) → End(U). -/
def weilUHom : SLG →* (U →ₗ[K] U) where
  toFun := weilU
  map_one' := weilU_one
  map_mul' := weilU_mul

end WeilHom
end V14Formalization

-- ═══ GeometricFanoCarrier ═══

open scoped BigOperators LinearAlgebra.Projectivization MatrixGroups
open Matrix Matrix.SpecialLinearGroup exteriorPower Module
noncomputable section
namespace V14Formalization
namespace GeometricFanoCarrier

abbrev k := WeilRep.K

abbrev F := ZMod 11

abbrev SLG := SpecialLinearGroup (Fin 2) F

abbrev PSL2F11 : Type := PSL(2, F)

abbrev U := WeilRep.U

instance : Fact (Nat.Prime 11)  := sorry

instance : Group PSL2F11 := inferInstance

/-- Evaluation of even functions at coordinates 0..5. -/
def evalEven : U →ₗ[k] (Fin 6 → k) where
  toFun f j := f.1 (j.val : ZMod 11)
  map_add' _ _ := funext fun _ => rfl
  map_smul' _ _ := funext fun _ => rfl

abbrev Lambda2U : Type := ↥(⋀[k]^2 U)

instance : AddCommGroup Lambda2U := inferInstance

instance : Module k Lambda2U := inferInstance

def weilLambda2 (g : SLG) : Lambda2U →ₗ[k] Lambda2U :=
  exteriorPower.map 2 (WeilHom.weilUHom g)

theorem weilLambda2_one : weilLambda2 1 = LinearMap.id  := sorry

theorem weilLambda2_mul (g h : SLG) :
    weilLambda2 (g * h) = weilLambda2 g ∘ₗ weilLambda2 h  := sorry

def weilLambda2Hom : SLG →* (Lambda2U →ₗ[k] Lambda2U) where
  toFun := weilLambda2
  map_one' := weilLambda2_one
  map_mul' := weilLambda2_mul

theorem weilLambda2Hom_ker_center :
    Subgroup.center SLG ≤ weilLambda2Hom.ker  := sorry

def pslLambda2Hom : PSL2F11 →* (Lambda2U →ₗ[k] Lambda2U) :=
  QuotientGroup.lift (N := Subgroup.center SLG) weilLambda2Hom weilLambda2Hom_ker_center

end GeometricFanoCarrier
end V14Formalization

-- ═══ Lambda2Coordinates ═══

noncomputable section
open Set Matrix exteriorPower Module
namespace V14Formalization
namespace Lambda2Coordinates
open GeometricFanoCarrier SchemeGeometry

abbrev k := GeometricFanoCarrier.k

abbrev G := GeometricFanoCarrier.PSL2F11

abbrev U := GeometricFanoCarrier.U

abbrev Lambda2U := GeometricFanoCarrier.Lambda2U

/-- Evaluation at `0,...,5`, as an equivalence on the even Weil model. -/
noncomputable def evalEvenEquivCore : U ≃ₗ[k] (Fin 6 → k) := by
  apply LinearEquiv.ofBijective GeometricFanoCarrier.evalEven
  refine ⟨GeometricFanoCarrier.evalEven_injective, ?_⟩
  intro v
  refine ⟨GeometricFanoCarrier.extendEven v, ?_⟩
  simpa [LinearMap.comp_apply] using
    LinearMap.congr_fun GeometricFanoCarrier.evalEven_extendEven v

/-- The coordinate basis dual to evaluation at `0,...,5`. -/
noncomputable def uBasisCore : Basis (Fin 6) k U :=
  Basis.ofEquivFun evalEvenEquivCore

/-- The two-subset `{i,j}` with its cardinality certificate. -/
def pair (i j : Fin 6) (h : i ≠ j) : powersetCard (Fin 6) 2 :=
  ⟨{i, j}, by simp [Finset.card_pair h]⟩

/-- Lexicographic enumeration `01,02,03,04,05,12,...,45`. -/
def pairEnumeration : Fin 15 → powersetCard (Fin 6) 2 := ![
  pair 0 1 (by decide), pair 0 2 (by decide), pair 0 3 (by decide),
  pair 0 4 (by decide), pair 0 5 (by decide), pair 1 2 (by decide),
  pair 1 3 (by decide), pair 1 4 (by decide), pair 1 5 (by decide),
  pair 2 3 (by decide), pair 2 4 (by decide), pair 2 5 (by decide),
  pair 3 4 (by decide), pair 3 5 (by decide), pair 4 5 (by decide)]

theorem pairEnumeration_bijective : Function.Bijective pairEnumeration  := sorry

/-- The exact Plücker coordinate order used by the sealed matrix data. -/
noncomputable def pluckerPairEquiv : powersetCard (Fin 6) 2 ≃ Fin 15 :=
  (Equiv.ofBijective pairEnumeration pairEnumeration_bijective).symm

/-- Exterior-square basis in lexicographic Plücker order. -/
noncomputable def lambda2Basis : Basis (Fin 15) k Lambda2U :=
  (uBasisCore.exteriorPower 2).reindex pluckerPairEquiv

/-- The actual faithful `15 × 15` representation of `PSL₂(F₁₁)` in the
lexicographic Plücker basis. -/
noncomputable def lambda2MatrixRepresentation :
    FaithfulMatrixRepresentation (k := k) (G := G) 14 where
  ρ := (Matrix.GeneralLinearGroup.toLin' lambda2Basis).symm.toMonoidHom.comp
    GeometricFanoCarrier.pslLambda2Hom.toHomUnits
  faithful :=
    (Matrix.GeneralLinearGroup.toLin' lambda2Basis).symm.injective.comp
      (MonoidHom.ker_eq_bot_iff _ |>.mp (by
        rw [MonoidHom.ker_toHomUnits]
        exact (MonoidHom.ker_eq_bot_iff _).mpr
          GeometricFanoCarrier.pslLambda2Hom_injective))

end Lambda2Coordinates
end V14Formalization

-- ═══ CentralizerD12 ═══

open scoped MatrixGroups
open Matrix Matrix.SpecialLinearGroup
noncomputable section
namespace V14Formalization
namespace CentralizerN

abbrev F := ZMod 11

abbrev PSL2F11 := PSL(2, F)

instance : Fintype Circle1 :=
  Fintype.subtype ((Finset.univ : Finset (F × F)).filter fun p => p.1 ^ 2 + p.2 ^ 2 = 1)
    (by intro; simp)

instance : Fintype PSL2F11 := QuotientGroup.fintype _

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

abbrev k := GeometricFanoCarrier.k

abbrev PSL2F11 := GeometricFanoCarrier.PSL2F11

abbrev Lambda2U := GeometricFanoCarrier.Lambda2U

def ambientAct (g : PSL2F11) : Lambda2U →ₗ[k] Lambda2U := pslLambda2Hom g

def sigma : PSL2F11 := QuotientGroup.mk WeilRep.Smat

theorem sigma_isInvolution : IsInvolution sigma  := sorry

open ExteriorAlgebra
open ExteriorAlgebra

/-- Character values of the irreducible `10'` of `PSL₂(𝔽₁₁)`, determined by element order.
    Table: `1A↦10, 2A↦2, 3A↦1, 5A/5B↦0, 6A↦-1, 11A/11B↦-1`. -/
noncomputable def chi10' (g : PSL2F11) : k :=
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
noncomputable def projectorM : Module.End k Lambda2U :=
  (10 * (660 : k)⁻¹) •
    ∑ g : PSL2F11, chi10' g • (ambientAct g : Module.End k Lambda2U)

open ExteriorAlgebra
open ConjAct ConjClasses
end GeometricV14Carrier
end V14Formalization

-- ═══ ProjectiveHypersurfaceScheme ═══

open CategoryTheory Limits
open scoped AlgebraicGeometry
namespace BConicBundleMultisections
noncomputable section
open AlgebraicGeometry
namespace ProjectiveSpace

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
def projectiveZeroLocusFamilyIdeal
    (F : ι → MvPolynomial (Fin (n + 1)) R) :
    (ProjectiveSpace n R).IdealSheafData :=
  ⨆ i, ProjectiveSpace.projectiveZeroLocusIdeal n R (F i)

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
structure PluckerRelation where
  p1 : Fin 15
  p2 : Fin 15
  p3 : Fin 15
  p4 : Fin 15
  p5 : Fin 15
  p6 : Fin 15

/-- The fifteen Plücker relations, in lexicographic `Λ⁴` order. -/
def pluckerRelation : Fin 15 → PluckerRelation := ![
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
def pluckerQuadric (q : Fin 15) : MvPolynomial (Fin 15) R :=
  let d := pluckerRelation q
  MvPolynomial.X d.p1 * MvPolynomial.X d.p2 -
    MvPolynomial.X d.p3 * MvPolynomial.X d.p4 +
      MvPolynomial.X d.p5 * MvPolynomial.X d.p6

/-- The `i`-th linear coordinate of `(P-I)x`. -/
def projectorLinearCut
    (P : Matrix (Fin 15) (Fin 15) R) (i : Fin 15) :
    MvPolynomial (Fin 15) R :=
  ∑ j : Fin 15,
    MvPolynomial.C (P i j - if i = j then 1 else 0) * MvPolynomial.X j

/-- Plücker equations followed by the projector-image equations. -/
def grassmannianLinearSectionEquations
    (P : Matrix (Fin 15) (Fin 15) R) :
    Fin 15 ⊕ Fin 15 → MvPolynomial (Fin 15) R
  | Sum.inl q => pluckerQuadric R q
  | Sum.inr i => projectorLinearCut R P i

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
structure IsInvariantIdeal (A : Action Scheme G)
    (I : A.V.IdealSheafData) : Prop where
  le_map : ∀ g : G, I ≤ I.map (A.ρ g)

namespace IsInvariantIdeal
variable {A : Action Scheme G} {I : A.V.IdealSheafData}

/-- The restriction of one action morphism to the invariant subscheme. -/
def hom (hI : IsInvariantIdeal A I) (g : G) : I.subscheme ⟶ I.subscheme :=
  I.subschemeMap I (A.ρ g) (hI.le_map g)

@[simp]
theorem hom_one (hI : IsInvariantIdeal A I) : hI.hom 1 = 𝟙 _  := sorry

theorem hom_mul (hI : IsInvariantIdeal A I) (g h : G) :
    hI.hom (g * h) = hI.hom h ≫ hI.hom g  := sorry

/-- The induced action on the invariant closed subscheme. -/
def action (hI : IsInvariantIdeal A I) : Action Scheme G where
  V := I.subscheme
  ρ :=
    { toFun := hI.hom
      map_one' := hI.hom_one
      map_mul' := hI.hom_mul }

/-- If the ambient action is over `S`, so is the induced action on the
invariant closed subscheme. -/
def actionOver {S : Scheme.{u}} (hI : IsInvariantIdeal A I)
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

-- ═══ V14SchemeModel ═══

noncomputable section
open Set Matrix exteriorPower Module
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace V14SchemeModel
open GeometricFanoCarrier GeometricV14Carrier Lambda2Coordinates SchemeGeometry
  BConicBundleMultisections

abbrev k := GeometricV14Carrier.k

abbrev G := GeometricV14Carrier.PSL2F11

/-- The character projector in the exact Plücker coordinate basis
`01,02,03,04,05,12,...,45`. -/
noncomputable def projectorMatrix : Matrix (Fin 15) (Fin 15) k :=
  LinearMap.toMatrix lambda2Basis lambda2Basis projectorM

/-- The genuine projective action before restriction to the V14 subscheme. -/
abbrev ambientSchemeAction : Action AlgebraicGeometry.Scheme G :=
  projectiveAction 14 lambda2MatrixRepresentation.ρ

/-- The ideal sheaf defining the coordinate V14 inside `P¹⁴`. -/
abbrev v14Ideal : (ProjectiveSpace 14 k).IdealSheafData :=
  projectiveZeroLocusFamilyIdeal 14 k
    (grassmannianLinearSectionEquations k projectorMatrix)

/-- The defining ideal sheaf of the coordinate V14 is invariant under the
genuine projective `PSL₂(F₁₁)` action. -/
theorem invariantIdeal : IsInvariantIdeal ambientSchemeAction v14Ideal  := sorry

/-- The unconditional V14 action with its canonical structure morphism to
`Spec k`.  This is the base-preserving target used by equivariant rational
maps and proper specialization. -/
noncomputable def actionOver :
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

-- ═══ HeadlineStatement ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization.SchemeGeometry
open AlgebraicGeometry GeometricV14Carrier Module

abbrev ambientFor
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :=
  ambientProjectiveActionOver R (p + q + 1)
    (plusMinusAmbientBasis R sigma sigma_isInvolution p q bp bm)

/-- Plus/minus homogeneous coordinates used by the normal chart.  Not a
hypothesis of the public theorem: any faithful `R` supplies some. -/
structure PlusMinusCoords
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) where
  p : ℕ
  q : ℕ
  bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma)
  bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)

/-- Choose plus/minus bases from nondegeneracy.  The numbered `Proj` and the
`(u,T,v)` chart are built from this choice; this is not a basis-free
identification of `ℙ(V)`. -/
noncomputable def PlusMinusCoords.ofRep
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) : PlusMinusCoords R :=
  let h := exists_plus_minus_projective_bases R sigma sigma_isInvolution
    (not_degenerates R)
  { p := h.choose
    q := h.choose_spec.choose
    bp := Classical.choice h.choose_spec.choose_spec.1
    bm := Classical.choice h.choose_spec.choose_spec.2 }

/-- The numbered projective action of `R` in the chosen plus/minus
coordinates. -/
abbrev ambientOf
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    Action (Over (Spec (.of k))) G :=
  ambientFor R (PlusMinusCoords.ofRep R).p (PlusMinusCoords.ofRep R).q
    (PlusMinusCoords.ofRep R).bp (PlusMinusCoords.ofRep R).bm

namespace ProjectiveGVariety
end ProjectiveGVariety
end V14Formalization.SchemeGeometry

-- ═══ V14Challenge ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization.Comparator
open V14Formalization.SchemeGeometry
open AlgebraicGeometry Module

/-- There is no equivariant `Scheme.RationalMap` from the numbered
projectivization of a faithful linear representation to the coordinate V14. -/
theorem noEquivariantRationalMap_from_ambient
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    ¬ HasEquivariantRationalMap (ambientOf R)
      V14SchemeModel.actionOver  := sorry

end V14Formalization.Comparator
