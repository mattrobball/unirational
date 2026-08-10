/-
Geometric inputs for the V14 application.

* `N_card_eq_12` / `N_mulEquiv_dihedral`: writeup Input 1 (from `CentralizerN`).
* Grassmannian scaffolding `Gr2`, `Ext2`, `M10` for the writeup ambient
  `V₁₄ = Gr(2,U) ∩ ℙ(M) ⊂ ℙ⁹`.
* `SigmaFixedLocusShape` + `HypothesisA_of_sigmaFixedLocusShape`: interface
  reducing hyp (a) to the writeup fixed-locus shape (genus-1 component with
  no RCC multi-point subsets + two points).
-/
import V14Formalization.CentralizerD12
import V14Formalization.Definitions
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.Dimension.Finite
import Mathlib.GroupTheory.SpecificGroups.Dihedral

noncomputable section

namespace V14Formalization

universe u

/-! ## Writeup Input 1: N = C_G(σ) ≃ D₁₂ -/

theorem N_card_eq_12 :
    Fintype.card
      (Subgroup.centralizer ({CentralizerN.sigma} : Set CentralizerN.PSL2F11)) = 12 :=
  CentralizerN.centralizer_sigma_card

theorem N_mulEquiv_dihedral :
    Nonempty
      (Subgroup.centralizer ({CentralizerN.sigma} : Set CentralizerN.PSL2F11) ≃*
        DihedralGroup 6) :=
  CentralizerN.centralizer_sigma_mulEquiv_dihedral

#print axioms N_card_eq_12
#print axioms N_mulEquiv_dihedral

/-! ## Grassmannian ambient scaffolding (writeup §6) -/

/-- 6-dimensional space `U` for the Pfaffian–Grassmannian model. -/
abbrev U (k : Type u) := Fin 6 → k

/-- Grassmannian of 2-planes in `U = k⁶`. -/
def Gr2 (k : Type u) [Field k] : Type u :=
  { W : Submodule k (U k) // Module.finrank k W = 2 }

/-- Plücker ambient `Λ²U ≃ k¹⁵`. -/
abbrev Ext2 (k : Type u) := Fin 15 → k

/-- The 10-dimensional summand `M` (writeup `10'`). -/
abbrev M10 (k : Type u) := Fin 10 → k

/-- Linear inclusion of the `10'` summand into Plücker space. -/
def includeM (k : Type u) [Field k] : M10 k →ₗ[k] Ext2 k where
  toFun := fun m i => if h : i.val < 10 then m ⟨i.val, h⟩ else 0
  map_add' := by
    intro x y; ext i
    by_cases h : i.val < 10 <;> simp [h]
  map_smul' := by
    intro r x; ext i
    by_cases h : i.val < 10 <;> simp [h]

/-! ## Writeup fixed-locus shape ⇒ operational hyp (a) -/

/-- Writeup shape of `Y^σ`: genus-1 curve component + two points, with the
operational content of hyp (a) on each piece and no mixed RCC sets. -/
structure SigmaFixedLocusShape
    {k : Type u} [Field k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G) (σ : G) where
  curve : Set Y.X
  pt1 : Y.X
  pt2 : Y.X
  distinct : pt1 ≠ pt2
  partition : Y.fixedByElement σ = curve ∪ {pt1, pt2}
  /-- Genus-1 piece: every linear-RCC subset is a singleton. -/
  curve_rcc_singleton :
    ∀ S : Set Y.X, S ⊆ curve → IsRCC k Y S → ∃ y : Y.X, S = {y}
  /-- The isolated two-point set is not linear-RCC (no linear ℙ¹ through 2 pts
  fills both as a full projective line of the ambient). -/
  points_not_rcc : ¬ IsRCC k Y ({pt1, pt2} : Set Y.X)
  /-- No linear-RCC set meets both the curve and the isolated points. -/
  no_mixed_rcc :
    ∀ S : Set Y.X, S ⊆ curve ∪ {pt1, pt2} → IsRCC k Y S →
      S ⊆ curve ∨ S ⊆ ({pt1, pt2} : Set Y.X)

/-- Operational hyp (a) from the writeup fixed-locus shape. -/
theorem HypothesisA_of_sigmaFixedLocusShape
    {k : Type u} [Field k] {G : Type u} [Group G]
    {Y : SmoothProjectiveGVariety k G} {σ : G}
    (h : SigmaFixedLocusShape Y σ) :
    HypothesisA k Y σ := by
  intro S hS hRCC
  have hS' : S ⊆ h.curve ∪ {h.pt1, h.pt2} := by
    rwa [← h.partition]
  rcases h.no_mixed_rcc S hS' hRCC with hc | hp
  · exact h.curve_rcc_singleton S hc hRCC
  · -- S ⊆ {pt1, pt2}
    by_cases h1 : h.pt1 ∈ S
    · by_cases h2 : h.pt2 ∈ S
      · have heq : S = ({h.pt1, h.pt2} : Set Y.X) := by
          ext x
          constructor
          · intro hx; exact hp hx
          · intro hx
            simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hx
            rcases hx with rfl | rfl <;> assumption
        have hRCC' : IsRCC k Y ({h.pt1, h.pt2} : Set Y.X) := by rwa [← heq]
        exact (h.points_not_rcc hRCC').elim
      · refine ⟨h.pt1, ?_⟩
        ext x
        constructor
        · intro hx
          have := hp hx
          simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at this
          rcases this with rfl | rfl
          · rfl
          · exact (h2 hx).elim
        · intro hx
          simp only [Set.mem_singleton_iff] at hx
          rwa [hx]
    · by_cases h2 : h.pt2 ∈ S
      · refine ⟨h.pt2, ?_⟩
        ext x
        constructor
        · intro hx
          have := hp hx
          simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at this
          rcases this with rfl | rfl
          · exact (h1 hx).elim
          · rfl
        · intro hx
          simp only [Set.mem_singleton_iff] at hx
          rwa [hx]
      · -- S ⊆ {pt1,pt2} but contains neither ⇒ S = ∅, not linear-RCC
        rcases hRCC with ⟨W, hdim, hSeq⟩
        have hneW : W ≠ ⊥ := by
          intro hbot
          have : Module.finrank k W = 0 := by rw [hbot, finrank_bot]
          omega
        obtain ⟨v, hv, hvne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hneW
        have : (Y.embed '' S).Nonempty := by
          rw [hSeq]
          refine ⟨Projectivization.mk k v hvne, ?_⟩
          exact (Submodule.span_singleton_le_iff_mem _ _).mpr hv
        rcases this with ⟨_, ⟨x, hxS, _⟩⟩
        have := hp hxS
        simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at this
        rcases this with rfl | rfl
        · exact (h1 hxS).elim
        · exact (h2 hxS).elim

theorem HypothesisB_iff_N_fixed_empty
    {k : Type u} [Field k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G) (N : Subgroup G) :
    HypothesisB Y N ↔ Y.fixedBy N = ∅ := Iff.rfl

end V14Formalization
