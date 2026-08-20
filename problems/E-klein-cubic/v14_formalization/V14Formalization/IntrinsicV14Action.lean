/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.IntrinsicV14
public import V14Formalization.ProjectiveSpaceIntrinsic
public import V14Formalization.SchemeEquivariant
public import Mathlib.RepresentationTheory.Basic

/-!
# The `G`-action on the intrinsic `V₁₄`

A pair of representations — `ρ` on `M` and `π` on `U` — compatible in the sense
that `incl ∘ ρ g = ⋀²(π g) ∘ incl`, makes `IntrinsicV14.scheme` into an object
of `Action (Over (Spec k)) G`, entirely by functoriality:

* `IntrinsicV14.pluckerIdeal_map_le` says the Plücker ideal is stable, so
  `GradedQuotient.mapQuot` descends `Sym (ρ g)ᵀ` to the quotient;
* `GradedQuotient.irrelevant_le_map_mapQuot` discharges `Proj.map`'s side
  condition from the corresponding statement upstairs;
* `AlgebraicGeometry.Proj.map_id` / `map_comp` give the functor laws;
* `AlgebraicGeometry.Proj.map_toSpecZero` gives compatibility with the
  structure morphism to `Spec k`, which is what landing in `Over (Spec k)`
  needs.

This mirrors `ProjectiveSpaceIntrinsic{,Action}` step for step; only the graded
algebra underneath differs, being a quotient rather than a symmetric algebra.
No basis of `U`, no basis of `M`, and no Plücker coordinate appears.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry HomogeneousIdeal

universe u

namespace V14Formalization
namespace IntrinsicV14

open AlgebraicGeometry Module SymmetricAlgebra

/-- A representation sends `g⁻¹` to a left inverse of the image of `g`. -/
public theorem repInvComp {R N H : Type*} [CommSemiring R] [AddCommMonoid N] [Module R N]
    [Group H] (ρ : Representation R H N) (g : H) : ρ g⁻¹ ∘ₗ ρ g = LinearMap.id :=
  LinearMap.ext (ρ.inv_self_apply g)


variable (k U : Type u) [Field k] [AddCommGroup U] [Module k U] [FiniteDimensional k U]
  [Module.Free k U]
variable {M : Type u} [AddCommGroup M] [Module k M] [FiniteDimensional k M]
  (incl : M →ₗ[k] ↥(⋀[k]^2 U))

/-! ## Endomorphisms of `M` that come from endomorphisms of `U` -/

/-- `α : M →ₗ M` is **covered** when it is the restriction along `incl` of
`⋀²f` for some endomorphism `f` of `U`.  The covering `f` is existentially
quantified because a group acting on `⋀²U` need not act on `U`: for
`PSL₂(F₁₁)` only `SL₂(F₁₁)` acts on `U`, and the two lifts of an element of
`PSL₂` differ by `-1`, which acts trivially on `⋀²U`. -/
@[expose] public def Covers (α : M →ₗ[k] M) : Prop :=
  ∃ f : U →ₗ[k] U, ∀ x, incl (α x) = exteriorPower.map 2 f (incl x)

omit [FiniteDimensional k U] [Module.Free k U] [FiniteDimensional k M] in
public theorem covers_id : Covers k U incl (LinearMap.id : M →ₗ[k] M) :=
  ⟨LinearMap.id, fun x => by simp⟩

omit [FiniteDimensional k U] [Module.Free k U] [FiniteDimensional k M] in
public theorem Covers.comp {α₁ α₂ : M →ₗ[k] M} (h₁ : Covers k U incl α₁)
    (h₂ : Covers k U incl α₂) : Covers k U incl (α₁ ∘ₗ α₂) := by
  obtain ⟨f₁, hf₁⟩ := h₁
  obtain ⟨f₂, hf₂⟩ := h₂
  refine ⟨f₁ ∘ₗ f₂, fun x => ?_⟩
  show incl (α₁ (α₂ x)) = _
  rw [hf₁, hf₂, exteriorPower.map_comp]
  rfl

omit [FiniteDimensional k U] [Module.Free k U] in
/-- The Plücker ideal is stable under every covered endomorphism. -/
public theorem pluckerIdeal_map_le' (α : M →ₗ[k] M) (hcov : Covers k U incl α) :
    (pluckerIdeal k U incl).map
        (SymmetricAlgebra.gradedMap (α.dualMap)).toGradedRingHom ≤ pluckerIdeal k U incl := by
  obtain ⟨f, hf⟩ := hcov
  exact pluckerIdeal_map_le k U incl α f hf

/-! ## Functoriality of the homogeneous coordinate ring -/

/-- The endomorphism of the homogeneous coordinate ring of `V₁₄` induced by an
endomorphism `α` of `M` covered by an endomorphism `f` of `U`.  It is
`Sym (αᵀ)` descended to the quotient by the Plücker ideal, which is legitimate
because `pluckerIdeal_map_le` says the ideal is stable. -/
@[expose] public def quotMap (α : M →ₗ[k] M) (hcov : Covers k U incl α) :
    coordinateRing k U incl →+*ᵍ coordinateRing k U incl :=
  GradedQuotient.mapQuot (pluckerIdeal k U incl) (pluckerIdeal k U incl)
    (SymmetricAlgebra.gradedMap α.dualMap).toGradedRingHom
    (pluckerIdeal_map_le' k U incl α hcov)

omit [FiniteDimensional k U] [Module.Free k U] in
@[simp] public theorem quotMap_mk (α : M →ₗ[k] M) (hcov : Covers k U incl α)
    (a : SymmetricAlgebra k (Dual k M)) :
    quotMap k U incl α hcov (Ideal.Quotient.mk (pluckerIdeal k U incl).toIdeal a) =
      Ideal.Quotient.mk (pluckerIdeal k U incl).toIdeal (SymmetricAlgebra.map α.dualMap a) :=
  rfl

omit [FiniteDimensional k U] [Module.Free k U] in
/-- `Proj.map`'s side condition for `quotMap`, inherited from the same
statement for `Sym (αᵀ)` upstairs. -/
public theorem irrelevant_le_quotMap (α β : M →ₗ[k] M) (hcov : Covers k U incl α)
    (hinv : β ∘ₗ α = LinearMap.id) :
    (coordinateRing k U incl)₊ ≤
      ((coordinateRing k U incl)₊).map (quotMap k U incl α hcov) :=
  GradedQuotient.irrelevant_le_map_mapQuot (pluckerIdeal k U incl) (pluckerIdeal k U incl)
    _ (pluckerIdeal_map_le' k U incl α hcov)
    (SchemeGeometry.irrelevant_le_dualGradedMap α β hinv)

omit [FiniteDimensional k U] [Module.Free k U] in
/-- The functor law for the identity. -/
public theorem quotMap_id (hcov : Covers k U incl (LinearMap.id : M →ₗ[k] M)) :
    quotMap k U incl LinearMap.id hcov
      = GradedRingHom.id (coordinateRing k U incl) := by
  refine GradedRingHom.ext fun x => ?_
  obtain ⟨a, rfl⟩ := Ideal.Quotient.mk_surjective x
  rw [quotMap_mk]
  rw [LinearMap.dualMap_id]
  rw [show SymmetricAlgebra.map (LinearMap.id : Dual k M →ₗ[k] Dual k M) a = a from
    congr($(SymmetricAlgebra.map_id (R := k) (M := Dual k M)) a)]
  rfl

omit [FiniteDimensional k U] [Module.Free k U] in
/-- The functor law for composites, contravariantly. -/
public theorem quotMap_comp (α₁ α₂ : M →ₗ[k] M)
    (hcov₁ : Covers k U incl α₁) (hcov₂ : Covers k U incl α₂)
    (hcov : Covers k U incl (α₁ ∘ₗ α₂)) :
    quotMap k U incl (α₁ ∘ₗ α₂) hcov
      = (quotMap k U incl α₂ hcov₂).comp (quotMap k U incl α₁ hcov₁) := by
  refine GradedRingHom.ext fun x => ?_
  obtain ⟨a, rfl⟩ := Ideal.Quotient.mk_surjective x
  rw [quotMap_mk]
  show _ = quotMap k U incl α₂ hcov₂
    (quotMap k U incl α₁ hcov₁ (Ideal.Quotient.mk _ a))
  rw [quotMap_mk, quotMap_mk]
  congr 1
  rw [show ((α₁ ∘ₗ α₂).dualMap : Dual k M →ₗ[k] Dual k M) = α₂.dualMap ∘ₗ α₁.dualMap from
    (LinearMap.dualMap_comp_dualMap α₂ α₁).symm]
  rw [← SymmetricAlgebra.map_comp]
  rfl

/-! ## The induced endomorphisms of the scheme -/

/-- The endomorphism of `V₁₄` induced by an automorphism `α` of `M` covered by
an endomorphism `f` of `U`, presented by `α` together with a left inverse. -/
@[expose] public def schemeMap (α β : M →ₗ[k] M) (hcov : Covers k U incl α)
    (hinv : β ∘ₗ α = LinearMap.id) :
    scheme k U incl ⟶ scheme k U incl :=
  Proj.map (quotMap k U incl α hcov) (irrelevant_le_quotMap k U incl α β hcov hinv)

omit [FiniteDimensional k U] [Module.Free k U] in
/-- `schemeMap` depends only on `α`: the covering map, the left inverse and
both proofs enter only through `Prop`-valued arguments. -/
public theorem schemeMap_congr {α α' β β' : M →ₗ[k] M} (hα : α = α')
    (hcov : Covers k U incl α) (hcov' : Covers k U incl α')
    (hinv : β ∘ₗ α = LinearMap.id) (hinv' : β' ∘ₗ α' = LinearMap.id) :
    schemeMap k U incl α β hcov hinv = schemeMap k U incl α' β' hcov' hinv' := by
  subst hα; rfl

omit [FiniteDimensional k U] [Module.Free k U] in
/-- `V₁₄` of the identity is the identity. -/
@[simp] public theorem schemeMap_id (hcov : Covers k U incl (LinearMap.id : M →ₗ[k] M))
    (hinv : (LinearMap.id : M →ₗ[k] M) ∘ₗ LinearMap.id = LinearMap.id) :
    schemeMap k U incl LinearMap.id LinearMap.id hcov hinv = 𝟙 _ :=
  (AlgebraicGeometry.Proj.map_congr (quotMap_id k U incl hcov) _ (by simp)).trans
    AlgebraicGeometry.Proj.map_id

omit [FiniteDimensional k U] [Module.Free k U] in
/-- `V₁₄` of a composite is the composite, contravariantly. -/
public theorem schemeMap_comp (α₁ β₁ α₂ β₂ : M →ₗ[k] M)
    (hcov₁ : Covers k U incl α₁) (hcov₂ : Covers k U incl α₂)
    (hcov : Covers k U incl (α₁ ∘ₗ α₂))
    (hinv₁ : β₁ ∘ₗ α₁ = LinearMap.id) (hinv₂ : β₂ ∘ₗ α₂ = LinearMap.id)
    (hinv : (β₂ ∘ₗ β₁) ∘ₗ (α₁ ∘ₗ α₂) = LinearMap.id) :
    schemeMap k U incl (α₁ ∘ₗ α₂) (β₂ ∘ₗ β₁) hcov hinv
      = schemeMap k U incl α₂ β₂ hcov₂ hinv₂ ≫ schemeMap k U incl α₁ β₁ hcov₁ hinv₁ := by
  refine (AlgebraicGeometry.Proj.map_congr
    (quotMap_comp k U incl α₁ α₂ hcov₁ hcov₂ hcov) _ ?_).trans
    (AlgebraicGeometry.Proj.map_comp _ _ _ _)
  exact HomogeneousIdeal.irrelevant_le_map_comp
    (irrelevant_le_quotMap k U incl α₁ β₁ hcov₁ hinv₁)
    (irrelevant_le_quotMap k U incl α₂ β₂ hcov₂ hinv₂)

/-! ## The structure morphism to `Spec k` -/

/-- The structure morphism `V₁₄ ⟶ Spec k`, built exactly as for `Proj` of a
polynomial ring. -/
@[expose] public def toSpec : scheme k U incl ⟶ Spec (.of k) :=
  Proj.toSpecZero (coordinateRing k U incl) ≫
    Spec.map (CommRingCat.ofHom (algebraMap k (coordinateRing k U incl 0)))

public instance canonicallyOver :
    (scheme k U incl).CanonicallyOver (Spec (.of k)) where
  hom := toSpec k U incl

omit [FiniteDimensional k U] [Module.Free k U] in
private theorem quotMap_zero_comp_algebraMap (α : M →ₗ[k] M) (hcov : Covers k U incl α) :
    (quotMap k U incl α hcov).gradedZeroRingHom.comp
        (algebraMap k (coordinateRing k U incl 0)) =
      algebraMap k (coordinateRing k U incl 0) := by
  apply RingHom.ext
  intro r
  apply Subtype.ext
  show Ideal.Quotient.mk _ (SymmetricAlgebra.map α.dualMap _) = _
  rw [show ((algebraMap k (SymmetricAlgebra k (Dual k M))) r) =
      (algebraMap k (SymmetricAlgebra k (Dual k M))) r from rfl]
  rw [AlgHom.commutes]
  rfl

omit [FiniteDimensional k U] [Module.Free k U] in
/-- Every endomorphism of `V₁₄` induced by an automorphism of `M` is a morphism
over `Spec k`. -/
public theorem schemeMap_toSpec (α β : M →ₗ[k] M) (hcov : Covers k U incl α)
    (hinv : β ∘ₗ α = LinearMap.id) :
    schemeMap k U incl α β hcov hinv ≫ toSpec k U incl = toSpec k U incl := by
  unfold schemeMap toSpec scheme
  rw [← Category.assoc, AlgebraicGeometry.Proj.map_toSpecZero]
  rw [Category.assoc, ← Spec.map_comp]
  have hz :
      CommRingCat.ofHom (algebraMap k (coordinateRing k U incl 0)) ≫
        CommRingCat.ofHom (quotMap k U incl α hcov).gradedZeroRingHom =
      CommRingCat.ofHom (algebraMap k (coordinateRing k U incl 0)) := by
    simpa using congrArg CommRingCat.ofHom
      (quotMap_zero_comp_algebraMap k U incl α hcov)
  rw [hz]

@[expose] public instance schemeMap_isOver (α β : M →ₗ[k] M) (hcov : Covers k U incl α)
    (hinv : β ∘ₗ α = LinearMap.id) :
    (schemeMap k U incl α β hcov hinv).IsOver (Spec (.of k)) where
  comp_over := schemeMap_toSpec k U incl α β hcov hinv

/-! ## The action of a group -/

variable {G : Type u} [Group G]

/-- The automorphism of `V₁₄` attached to a group element. -/
@[expose] public def repHom (ρ : Representation k G M)
    (hcov : ∀ g : G, Covers k U incl (ρ g)) (g : G) :
    scheme k U incl ⟶ scheme k U incl :=
  schemeMap k U incl (ρ g) (ρ g⁻¹) (hcov g) (repInvComp ρ g)

omit [FiniteDimensional k U] [Module.Free k U] in
@[simp] public theorem repHom_one (ρ : Representation k G M)
    (hcov : ∀ g : G, Covers k U incl (ρ g)) :
    repHom k U incl ρ hcov (1 : G) = 𝟙 _ := by
  have h1 : ρ (1 : G) = LinearMap.id := by
    rw [map_one, Module.End.one_eq_id]
  refine Eq.trans ?_ (schemeMap_id k U incl (covers_id k U incl) (by simp))
  exact schemeMap_congr k U incl h1 _ _ _ _

omit [FiniteDimensional k U] [Module.Free k U] in
public theorem repHom_mul (ρ : Representation k G M)
    (hcov : ∀ g : G, Covers k U incl (ρ g)) (a b : G) :
    repHom k U incl ρ hcov (a * b)
      = repHom k U incl ρ hcov b ≫ repHom k U incl ρ hcov a := by
  have hab : ρ (a * b) = ρ a ∘ₗ ρ b := by
    rw [map_mul, Module.End.mul_eq_comp]
  have hinv : (ρ b⁻¹ ∘ₗ ρ a⁻¹) ∘ₗ (ρ a ∘ₗ ρ b) = LinearMap.id := by
    rw [← Module.End.mul_eq_comp, ← Module.End.mul_eq_comp, ← Module.End.mul_eq_comp,
      ← map_mul, ← map_mul, ← map_mul]
    have hg : (b⁻¹ * a⁻¹) * (a * b) = (1 : G) := by group
    rw [hg, map_one, Module.End.one_eq_id]
  refine Eq.trans (schemeMap_congr k U incl (β := ρ (a * b)⁻¹) (β' := ρ b⁻¹ ∘ₗ ρ a⁻¹)
    hab _ ((hcov a).comp k U incl (hcov b)) _ hinv) ?_
  exact schemeMap_comp k U incl (ρ a) (ρ a⁻¹) (ρ b) (ρ b⁻¹)
    (hcov a) (hcov b) ((hcov a).comp k U incl (hcov b))
    (repInvComp ρ a) (repInvComp ρ b) hinv

/-- **`V₁₄` with its `G`-action**, in `Scheme`. -/
@[expose] public def action (ρ : Representation k G M)
    (hcov : ∀ g : G, Covers k U incl (ρ g)) :
    Action Scheme.{u} G where
  V := scheme k U incl
  ρ :=
    { toFun := repHom k U incl ρ hcov
      map_one' := repHom_one k U incl ρ hcov
      map_mul' := repHom_mul k U incl ρ hcov }

/-- **`V₁₄` with its `G`-action, as a scheme over `Spec k`.**  This is the
coordinate-free replacement for `V14SchemeModel.actionOver`. -/
@[expose] public def actionOver (ρ : Representation k G M)
    (hcov : ∀ g : G, Covers k U incl (ρ g)) :
    Action (Over (Spec (.of k))) G := by
  letI : (action k U incl ρ hcov).V.Over (Spec (.of k)) := by
    change (scheme k U incl).Over (Spec (.of k))
    infer_instance
  exact SchemeGeometry.actionOverOfIsOver (action k U incl ρ hcov) fun g ↦ by
    change (repHom k U incl ρ hcov g).IsOver (Spec (.of k))
    exact schemeMap_isOver _ _ _ _ _ _ _

omit [FiniteDimensional k U] [Module.Free k U] in
@[simp] public theorem actionOver_carrier (ρ : Representation k G M)
    (hcov : ∀ g : G, Covers k U incl (ρ g)) :
    (actionOver k U incl ρ hcov).V.left = scheme k U incl := rfl

end IntrinsicV14
end V14Formalization
