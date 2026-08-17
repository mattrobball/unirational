/-
Writeup ambient object V₁₄ = Gr(2,U) ∩ ℙ(M) on the even Weil module U.

* U is the even subspace of functions F₁₁ → K (`WeilRep.U`), with S² = −id proved.
* M ⊂ Λ²U is the 10-dimensional summand (coordinate model `Ext2` / `M10` for now;
  isotypic identification completes with the SL₂ → GL(U) homomorphism).
* `V14Point` packages rank-2 planes in U (Grassmannian points of the writeup model).
-/
module

public import V14Formalization.WeilRep
public import V14Formalization.Definitions
public import V14Formalization.GeometricV14
public import Mathlib.LinearAlgebra.Dimension.Finrank
public import Mathlib.LinearAlgebra.Projectivization.Basic

open scoped LinearAlgebra.Projectivization

noncomputable section

namespace V14Formalization
namespace GeometricFanoV14

/-! ## Ambient: even Weil module U over K = ℚ(ζ₁₁) -/

public abbrev k := WeilRep.K
public abbrev WeilU := WeilRep.U

public theorem S_sq :
    WeilRep.S_even ∘ₗ WeilRep.S_even = (-LinearMap.id : WeilU →ₗ[k] WeilU) :=
  WeilRep.S_even_sq

theorem gauss_sq_m11 : WeilRep.gauss ^ 2 = (-11 : k) :=
  WeilRep.gauss_sq

/-! ## Grassmannian of 2-planes in the even Weil module -/

/-- Writeup Gr(2,U): rank-2 subspaces of the even Weil module. -/
def Gr2Weil : Type :=
  { W : Submodule k WeilU // Module.finrank k W = 2 }

/-- Plücker ambient Λ²(U) ≃ k¹⁵ (coordinate model). -/
abbrev Plucker := Ext2 k

/-- The 10' summand M (coordinate model Fin 10 → k). -/
abbrev Mspace := M10 k

def includeM' : Mspace →ₗ[k] Plucker := includeM k

theorem includeM'_injective : Function.Injective includeM' := by
  intro a b h
  ext i
  have := congr_fun h ⟨i.val, by omega⟩
  simp only [includeM', includeM, LinearMap.coe_mk, AddHom.coe_mk] at this
  simpa [i.isLt] using this

/-- A point of the writeup V₁₄: a 2-plane in the even Weil module U. -/
structure V14Point where
  plane : Gr2Weil

namespace V14Point

def toSubmodule (x : V14Point) : Submodule k WeilU := x.plane.1

lemma finrank_eq_two (x : V14Point) : Module.finrank k x.toSubmodule = 2 :=
  x.plane.2

end V14Point

/-- Ambient projective space ℙ(M) ≅ ℙ⁹. -/
abbrev PM := ℙ k Mspace

/-- Re-export: S² = −I is the Weil normalization. -/
theorem weil_S_sq_neg_id :
    WeilRep.S_even ∘ₗ WeilRep.S_even = (-LinearMap.id : WeilU →ₗ[k] WeilU) :=
  WeilRep.S_even_sq

end GeometricFanoV14
end V14Formalization
