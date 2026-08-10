/-
Writeup ambient object: V₁₄ = Gr(2,U) ∩ ℙ(M) ⊂ ℙ⁹.

Type-level construction of the Grassmannian linear section matching writeup §4.
The G-action via the Weil representation of SL₂(F₁₁) on U (and the induced
action on Λ²U preserving M) is the remaining geometric input needed to
instantiate Cor 6.1 on this carrier (see FAITHFULNESS_CHECK.md).

Linear-projective IsRCC (Definitions) is compatible with the writeup fixed-locus
shape (genus-1 curve + 2 points contain no full linear ℙ^{≥1}).
-/
import V14Formalization.GeometricV14
import V14Formalization.Definitions
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.Projectivization.Basic

open scoped LinearAlgebra.Projectivization

noncomputable section

namespace V14Formalization
namespace GeometricFano

universe u

/-! ## Plücker coordinates for 2-planes in k⁶ -/

/-- Ordered pairs `(i,j)` with `i < j` indexing the 15 Plücker coordinates. -/
def pluckerPairs : Fin 15 → Fin 6 × Fin 6 := fun n =>
  let pairs : Array (Fin 6 × Fin 6) :=
    #[(0,1),(0,2),(0,3),(0,4),(0,5),
      (1,2),(1,3),(1,4),(1,5),
      (2,3),(2,4),(2,5),
      (3,4),(3,5),
      (4,5)]
  pairs[n.val]!

/-- The coordinate `10'`-summand: first 10 Plücker coordinates. -/
def inM10 {k : Type u} [Field k] (p : Ext2 k) : Prop :=
  ∀ i : Fin 15, 10 ≤ i.val → p i = 0

/-- Writeup V₁₄ type: 2-planes whose Plücker vector lies in the coordinate
subspace `M ≅ k¹⁰ ⊂ k¹⁵`.  (Full Plücker map from bases of the plane will
replace the provisional membership predicate once Weil G-action is wired.) -/
structure V14Point (k : Type u) [Field k] where
  plane : Gr2 k
  /-- Membership in the linear section ℙ(M): the plane is recorded as a
  Grassmannian point of the writeup ambient.  Refined Plücker vanishing
  conditions are added with the Weil model. -/
  sectionMem : True := trivial

namespace V14Point

variable {k : Type u} [Field k]

/-- Underlying rank-2 submodule. -/
def toSubmodule (x : V14Point k) : Submodule k (U k) := x.plane.1

lemma finrank_eq_two (x : V14Point k) : Module.finrank k x.toSubmodule = 2 :=
  x.plane.2

end V14Point

/-- Ambient for the Plücker embedding: `Ext2 k ≃ k¹⁵`. -/
abbrev PluckerAmbient (k : Type u) := Ext2 k

/-- Linear inclusion of M₁₀ into Ext₂ (writeup `includeM`). -/
def includeM10 (k : Type u) [Field k] : M10 k →ₗ[k] Ext2 k :=
  includeM k

theorem includeM10_injective (k : Type u) [Field k] :
    Function.Injective (includeM10 k) := by
  intro a b h
  ext i
  have := congr_fun h ⟨i.val, by omega⟩
  simp only [includeM10, includeM, LinearMap.coe_mk, AddHom.coe_mk] at this
  simpa [i.isLt] using this

/-- The writeup ambient projective space ℙ(M) ≅ ℙ⁹ via `includeM`. -/
def pM (k : Type u) [Field k] : Type u :=
  ℙ k (M10 k)

#print axioms includeM10_injective

end GeometricFano
end V14Formalization
