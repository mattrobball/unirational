/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.ProjectiveSpaceIntrinsic
public import V14Formalization.SchemeEquivariant
public import V14Formalization.Definitions

/-!
# The `G`-action on coordinate-free projective space

A linear representation of `G` on `V` makes `ℙ(V) = Proj (Sym (V*))` into an
object of `Action (Over (Spec k)) G`, entirely by functoriality: `G` acts on
`V`, hence on `V*` by transpose, hence on `Sym (V*)` gradedly, hence on its
`Proj` contravariantly — twice contravariant, so covariantly overall.

This mirrors `SchemeProjectiveAction.projectiveActionOver`, which does the same
for `ProjectiveSpace n k` and a *matrix* representation.  The point of this
module is that no basis of `V` is chosen anywhere.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry Module SymmetricAlgebra

universe u

variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

/-- `projMapDual` does not depend on the inverse it is handed, nor on the proof:
both appear only in a `Prop` argument. -/
public theorem projMapDual_congr {f f' g g' : V →ₗ[k] V} (hf : f = f')
    (h : g ∘ₗ f = LinearMap.id) (h' : g' ∘ₗ f' = LinearMap.id) :
    projMapDual f g h = projMapDual f' g' h' := by
  subst hf; rfl

public theorem rep_inv_comp (ρ : Representation k G V) (g : G) :
    ρ g⁻¹ ∘ₗ ρ g = LinearMap.id :=
  LinearMap.ext (ρ.inv_self_apply g)

public theorem rep_mul_comp (ρ : Representation k G V) (a b : G) :
    ρ (a * b) = ρ a ∘ₗ ρ b := by
  rw [map_mul, Module.End.mul_eq_comp]

/-- The automorphism of `ℙ(V)` attached to a group element. -/
@[expose] public def projRepHom (ρ : Representation k G V) (g : G) :
    projectiveSpaceOfModule k V ⟶ projectiveSpaceOfModule k V :=
  projMapDual (ρ g) (ρ g⁻¹) (rep_inv_comp ρ g)

@[simp] public theorem projRepHom_one (ρ : Representation k G V) :
    projRepHom ρ (1 : G) = 𝟙 _ := by
  have h1 : ρ (1 : G) = LinearMap.id := by
    rw [map_one, Module.End.one_eq_id]
  refine Eq.trans ?_ (projMapDual_id (V := V) (k := k) (by simp))
  exact projMapDual_congr h1 _ _

public theorem projRepHom_mul (ρ : Representation k G V) (a b : G) :
    projRepHom ρ (a * b) = projRepHom ρ b ≫ projRepHom ρ a := by
  have hab : ρ (a * b) = ρ a ∘ₗ ρ b := rep_mul_comp ρ a b
  have hinv : (ρ b⁻¹ ∘ₗ ρ a⁻¹) ∘ₗ (ρ a ∘ₗ ρ b) = LinearMap.id := by
    rw [← Module.End.mul_eq_comp, ← Module.End.mul_eq_comp, ← Module.End.mul_eq_comp,
      ← map_mul, ← map_mul, ← map_mul]
    have hg : (b⁻¹ * a⁻¹) * (a * b) = (1 : G) := by group
    rw [hg, map_one, Module.End.one_eq_id]
  refine Eq.trans (projMapDual_congr (g := ρ (a * b)⁻¹) (g' := ρ b⁻¹ ∘ₗ ρ a⁻¹) hab _ hinv) ?_
  exact projMapDual_comp (ρ a) (ρ a⁻¹) (ρ b) (ρ b⁻¹)
    (rep_inv_comp ρ a) (rep_inv_comp ρ b) hinv

/-- `ℙ(V)` with its `G`-action, as a scheme over `Spec k`.  This is the
coordinate-free replacement for `ambientProjectiveActionOver`. -/
@[expose] public def projectiveActionOverOfRep (ρ : Representation k G V) :
    Action (Over (Spec (.of k))) G :=
  actionOverOfHoms (projectiveSpaceOfModule k V) (projRepHom ρ)
    (projRepHom_one ρ) (projRepHom_mul ρ) (fun _ ↦ projMapDual_isOver _ _ _)

/-- `ℙ(V) = Proj (Sym (Module.Dual k V))` for a faithful representation `R`,
carrying the `G`-action it inherits by functoriality.  No basis and no system
of homogeneous coordinates enters; compare `ambientProjectiveActionOver`,
which needs both. -/
@[expose] public def projectiveSpaceOfRep (R : FaithfulLinearRep k G V) :
    Action (Over (Spec (.of k))) G :=
  projectiveActionOverOfRep R.ρ

end SchemeGeometry
end V14Formalization
