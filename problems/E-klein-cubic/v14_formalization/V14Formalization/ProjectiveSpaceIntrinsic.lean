/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.SymmetricAlgebraFunctor
public import V14Formalization.ProjNaturality
public import Mathlib.LinearAlgebra.Dual.Defs

/-!
# Coordinate-free projective space

`projectiveSpaceOfModule k V` is `Proj` of the symmetric algebra on the dual of
`V`, graded by `SymmetricAlgebraGraded`.  No basis of `V` appears anywhere in
its definition.

The module supplies what is needed to make it an object of
`Over (Spec k)` carrying a `G`-action for any linear representation of `G` on
`V`:

* `projMapDual`, the morphism induced by a linear endomorphism of `V`, with
  `Proj.map`'s irrelevant-ideal side condition discharged from a right inverse;
* the functor laws `projMapDual_id` and `projMapDual_comp`, which are what an
  honest `CategoryTheory.Action` needs;
* `projMapDual_toSpec`, saying the induced morphism commutes with the structure
  morphism to `Spec k`, which is what landing in `Over (Spec k)` needs.

The construction deliberately mirrors `SchemeProjectiveAction`, which does the
same thing for `ProjectiveSpace n k` and a matrix representation; only the
graded algebra underneath differs.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry HomogeneousIdeal

universe u

/-! ## A congruence lemma for `Proj.map` -/

namespace AlgebraicGeometry.Proj

open AlgebraicGeometry

variable {A B σ τ : Type u}
  [CommRing A] [SetLike σ A] [AddSubgroupClass σ A]
  [CommRing B] [SetLike τ B] [AddSubgroupClass τ B]
  {𝒶 : ℕ → σ} {ℬ : ℕ → τ} [GradedRing 𝒶] [GradedRing ℬ]

/-- `Proj.map` depends only on the graded ring hom, not on the proof of its
side condition.  The side condition is a `Prop`, so this is proof
irrelevance. -/
public theorem map_congr {f f' : 𝒶 →+*ᵍ ℬ} (hff' : f = f')
    (hf : ℬ₊ ≤ (𝒶₊).map f) (hf' : ℬ₊ ≤ (𝒶₊).map f') :
    map f hf = map f' hf' := by
  subst hff'; rfl

end AlgebraicGeometry.Proj

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry Module SymmetricAlgebra

/-! ## The scheme -/

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

/-! ## Functoriality -/

/-- The graded algebra endomorphism of `Sym (V*)` induced by a linear
endomorphism of `V`, by transposing and applying `Sym`. -/
@[expose] public def dualGradedMap (f : V →ₗ[k] V) :
    grade k (Dual k V) →ₐᵍ[k] grade k (Dual k V) :=
  gradedMap (Module.Dual.transpose (R := k) f)

/-- Transposition is contravariant. -/
public theorem transpose_comp (f g : V →ₗ[k] V) :
    Module.Dual.transpose (R := k) (f ∘ₗ g)
      = (Module.Dual.transpose (R := k) g) ∘ₗ (Module.Dual.transpose (R := k) f) :=
  rfl

public theorem transpose_id :
    Module.Dual.transpose (R := k) (LinearMap.id : V →ₗ[k] V) = LinearMap.id :=
  rfl

@[simp] public theorem dualGradedMap_id :
    dualGradedMap (LinearMap.id : V →ₗ[k] V) = GradedAlgHom.id k (grade k (Dual k V)) := by
  rw [dualGradedMap, transpose_id, gradedMap_id]

public theorem dualGradedMap_comp (f g : V →ₗ[k] V) :
    (dualGradedMap g).comp (dualGradedMap f) = dualGradedMap (f ∘ₗ g) := by
  rw [dualGradedMap, dualGradedMap, dualGradedMap, transpose_comp, gradedMap_comp]

/-- The side condition of `Proj.map`, discharged whenever the endomorphism has
a two-sided partner making the composite the identity. -/
public theorem irrelevant_le_dualGradedMap (f g : V →ₗ[k] V) (h : g ∘ₗ f = LinearMap.id) :
    (grade k (Dual k V))₊ ≤ ((grade k (Dual k V))₊).map (dualGradedMap f).toGradedRingHom :=
  irrelevant_le_map_of_rightInverse (dualGradedMap f) (dualGradedMap g) fun y => by
    have := congr($(dualGradedMap_comp g f) y)
    rw [h, dualGradedMap_id] at this
    exact this

/-- The morphism of schemes `ℙ(V) ⟶ ℙ(V)` induced by a linear automorphism of
`V`, presented by the map and its inverse. -/
@[expose] public def projMapDual (f g : V →ₗ[k] V) (h : g ∘ₗ f = LinearMap.id) :
    projectiveSpaceOfModule k V ⟶ projectiveSpaceOfModule k V :=
  Proj.map (dualGradedMap f).toGradedRingHom (irrelevant_le_dualGradedMap f g h)

/-! ## The functor laws at the level of `Proj`

These are what a genuine `CategoryTheory.Action` needs. -/

/-- `Proj` of the identity is the identity. -/
@[simp] public theorem projMapDual_id (h : LinearMap.id ∘ₗ LinearMap.id = (LinearMap.id : V →ₗ[k] V)) :
    projMapDual (LinearMap.id : V →ₗ[k] V) LinearMap.id h = 𝟙 _ := by
  have hc : (dualGradedMap (LinearMap.id : V →ₗ[k] V)).toGradedRingHom
      = GradedRingHom.id (grade k (Dual k V)) := by
    rw [dualGradedMap_id]; rfl
  exact (AlgebraicGeometry.Proj.map_congr hc _ (by simp)).trans AlgebraicGeometry.Proj.map_id

/-- `Proj` of a composite is the composite, contravariantly. -/
public theorem projMapDual_comp (f₁ g₁ f₂ g₂ : V →ₗ[k] V)
    (h₁ : g₁ ∘ₗ f₁ = LinearMap.id) (h₂ : g₂ ∘ₗ f₂ = LinearMap.id)
    (h : (g₂ ∘ₗ g₁) ∘ₗ (f₁ ∘ₗ f₂) = LinearMap.id) :
    projMapDual (f₁ ∘ₗ f₂) (g₂ ∘ₗ g₁) h
      = projMapDual f₂ g₂ h₂ ≫ projMapDual f₁ g₁ h₁ := by
  have hc : (dualGradedMap (f₁ ∘ₗ f₂)).toGradedRingHom
      = (dualGradedMap f₂).toGradedRingHom.comp (dualGradedMap f₁).toGradedRingHom := by
    rw [← dualGradedMap_comp, GradedAlgHom.comp_toGradedRingHom]
  refine (AlgebraicGeometry.Proj.map_congr hc _ ?_).trans
    (AlgebraicGeometry.Proj.map_comp _ _ _ _)
  exact HomogeneousIdeal.irrelevant_le_map_comp
    (irrelevant_le_dualGradedMap f₁ g₁ h₁) (irrelevant_le_dualGradedMap f₂ g₂ h₂)

/-! ## Compatibility with the structure morphism to `Spec k` -/

private theorem dualGradedMap_zero_comp_algebraMap (f : V →ₗ[k] V) :
    (dualGradedMap f).toGradedRingHom.gradedZeroRingHom.comp
        (algebraMap k (grade k (Dual k V) 0)) =
      algebraMap k (grade k (Dual k V) 0) := by
  apply RingHom.ext
  intro r
  apply Subtype.ext
  simp [dualGradedMap, gradedMap]

/-- Every morphism induced by a linear automorphism is a morphism over
`Spec k`.  This is the statement that lets `ℙ(V)` carry its `G`-action in
`Over (Spec k)` rather than merely in `Scheme`. -/
public theorem projMapDual_toSpec (f g : V →ₗ[k] V) (h : g ∘ₗ f = LinearMap.id) :
    projMapDual f g h ≫ projectiveSpaceOfModule.toSpec k V
      = projectiveSpaceOfModule.toSpec k V := by
  unfold projMapDual projectiveSpaceOfModule.toSpec projectiveSpaceOfModule
  rw [← Category.assoc, AlgebraicGeometry.Proj.map_toSpecZero]
  rw [Category.assoc, ← Spec.map_comp]
  have hz :
      CommRingCat.ofHom (algebraMap k (grade k (Dual k V) 0)) ≫
        CommRingCat.ofHom (dualGradedMap f).toGradedRingHom.gradedZeroRingHom =
      CommRingCat.ofHom (algebraMap k (grade k (Dual k V) 0)) := by
    simpa using congrArg CommRingCat.ofHom (dualGradedMap_zero_comp_algebraMap f)
  rw [hz]

@[expose] public instance projMapDual_isOver (f g : V →ₗ[k] V) (h : g ∘ₗ f = LinearMap.id) :
    (projMapDual f g h).IsOver (Spec (.of k)) where
  comp_over := projMapDual_toSpec f g h

end SchemeGeometry
end V14Formalization
