/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.FunctionField
public import Mathlib.Topology.Sheaves.SheafCondition.UniqueGluing

/-!
# Gluing regular representatives of one rational function

On an integral scheme, restriction to the function field is injective on every nonempty open.
Consequently, local regular sections which represent the same rational function are automatically
compatible on overlaps and glue over any open cover.
-/

@[expose] public section

open CategoryTheory TopologicalSpace Opposite
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry

/-- Local regular representatives of the same function-field element glue to a global regular
function. -/
theorem exists_globalSection_of_eq_germToFunctionField_on_cover
    {X : Scheme.{u}} [IsIntegral X]
    {ι : Type u} (U : ι → X.Opens)
    (hU : ∀ i, Nonempty (U i))
    (hcover : (⊤ : X.Opens) ≤ iSup U)
    (s : ∀ i, Γ(X, U i)) (g : X.functionField)
    (hg : ∀ i, X.germToFunctionField (U i) (s i) = g) :
    ∃ t : Γ(X, ⊤), ∀ i,
      X.presheaf.map (homOfLE (show U i ≤ (⊤ : X.Opens) from le_top)).op t = s i := by
  letI hUi (i : ι) : Nonempty (U i) := hU i
  have hcompat : TopCat.Presheaf.IsCompatible X.presheaf U s := by
    intro i j
    by_cases hij : Nonempty ((U i ⊓ U j : X.Opens) : Type u)
    · letI : Nonempty ((U i ⊓ U j : X.Opens) : Type u) := hij
      apply X.germToFunctionField_injective (U i ⊓ U j)
      let hx : genericPoint X ∈ U i ⊓ U j :=
        ((genericPoint_spec X).mem_open_set_iff (U i ⊓ U j).isOpen).mpr
          (by simpa using hij)
      change X.presheaf.germ (U i ⊓ U j) (genericPoint X) hx
          (X.presheaf.map (Opens.infLELeft (U i) (U j)).op (s i)) =
        X.presheaf.germ (U i ⊓ U j) (genericPoint X) hx
          (X.presheaf.map (Opens.infLERight (U i) (U j)).op (s j))
      rw [X.presheaf.germ_res_apply, X.presheaf.germ_res_apply]
      exact (hg i).trans (hg j).symm
    · apply TopCat.Presheaf.section_ext X.sheaf
      intro x hx
      exact (hij ⟨x, hx⟩).elim
  obtain ⟨t, ht, _htuniq⟩ :=
    X.sheaf.existsUnique_gluing' U (⊤ : X.Opens)
      (fun i ↦ homOfLE le_top) hcover s hcompat
  exact ⟨t, ht⟩

end

end BConicBundleMultisections
