/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.Definitions
import V14Formalization.SchemeEquivariant
import V14Formalization.SchemeProjectiveAction
import V14Formalization.UniversalNormalDivisor
import V14Formalization.V14SchemeModel
import V14Formalization.MultiProjectiveZeroLocus
import Mathlib.AlgebraicGeometry.Morphisms.ClosedImmersion
import Mathlib.LinearAlgebra.Basis.Basic

/-!
# Projective G-varieties as Mathlib schemes

A projective `G`-variety here is a closed subscheme of scheme-level
projective space `Proj k[X₀,…,Xₙ]`, equipped with a `G`-action in the
category of schemes over `Spec k`.  The underlying object is Mathlib's
`AlgebraicGeometry.Scheme`.  Equivariant maps are Mathlib
`Scheme.RationalMap`s.

This replaces the linear-algebra point model `SmoothProjectiveGVariety`,
whose `X` is a bare type and whose maps are total functions induced by
injective linear maps.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

universe u v

/-- A closed subscheme of `ℙⁿ` with a `G`-action over `Spec k`. -/
structure ProjectiveGVariety
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
abbrev toScheme (X : ProjectiveGVariety k G) : Scheme :=
  X.action.V.left

/-- Full projective space `ℙⁿ` with the action induced by a matrix representation. -/
def ofMatrixRepresentation (n : ℕ)
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
def ofLinearRep {G : Type u} [Group G] {V : Type u}
    [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (d : ℕ) (b : Basis (Fin (d + 1)) k V) :
    ProjectiveGVariety k G :=
  ofMatrixRepresentation d (ambientMatrixRepresentation R d b)

instance ofMatrixRepresentation_irreducible (n : ℕ)
    (R : MatrixRepresentation (k := k) (G := G) n) :
    IrreducibleSpace (ofMatrixRepresentation n R).toScheme := by
  change IrreducibleSpace (ProjectiveSpace n k)
  infer_instance

instance ofLinearRep_irreducible {G : Type u} [Group G] {V : Type u}
    [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (d : ℕ) (b : Basis (Fin (d + 1)) k V) :
    IrreducibleSpace (ofLinearRep R d b).toScheme :=
  ofMatrixRepresentation_irreducible d (ambientMatrixRepresentation R d b)

/-- The coordinate V14, as a closed subscheme of `ℙ¹⁴` with its genuine
`PSL₂(𝔽₁₁)` action. -/
def v14 : ProjectiveGVariety V14SchemeModel.k V14SchemeModel.G where
  n := 14
  action := V14SchemeModel.actionOver
  ι := V14SchemeModel.v14Schemeι
  closed := by
    dsimp [V14SchemeModel.v14Schemeι, grassmannianLinearSectionι]
    exact projectiveZeroLocusFamilyι_isClosedImmersion 14 V14SchemeModel.k
      (grassmannianLinearSectionEquations V14SchemeModel.k
        V14SchemeModel.projectorMatrix)
  ι_over :=
    projectiveZeroLocusFamilyι_isOver 14 V14SchemeModel.k _

/-- Existence of a `G`-equivariant Mathlib rational map of the underlying
schemes over `Spec k`. -/
def HasEquivariantRationalMap (X Y : ProjectiveGVariety k G)
    [IrreducibleSpace X.toScheme] : Prop :=
  SchemeGeometry.HasEquivariantRationalMap X.action Y.action

end ProjectiveGVariety

end SchemeGeometry
end V14Formalization
