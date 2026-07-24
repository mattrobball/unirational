/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.Topology.Irreducible

/-!
# Spaces with a generic point

**Part of `BConicBundleMultisections/Standard/` — see `Standard/GenericSmoothness.lean` for the
contract.**  Standard mathematics absent from Mathlib, stated in its natural generality so that it
can be proved independently and leave the project.  Unlike most of this directory, it is proved
rather than `sorry`ed.

A space with a dense point is irreducible.  Mathlib has `irreducibleSpace_def` and
`isIrreducible_singleton` but not this composite, and `exact?` does not find it.

Needed by `PLAN.md` WP-1: the standard chart of `ℙ²_k` is dominant, which reduces to
`IrreducibleSpace (ProjectiveSpace 2 k)`, and the cheapest route to that is the generic point —
`ProjectiveSpectrum` of a graded *domain* has the point `⊥`, whose closure is everything.  That is
much shorter than covering `ℙⁿ` by irreducible charts, which additionally needs a projective chart
cover that does not exist in the tree.
-/

@[expose] public section

open Set

namespace BConicBundleMultisections.Standard

/-- **A space with a dense point is irreducible.**

The closure of a singleton is irreducible, and here that closure is everything. -/
theorem irreducibleSpace_of_dense_singleton {X : Type*} [TopologicalSpace X] (x : X)
    (h : Dense ({x} : Set X)) : IrreducibleSpace X := by
  rw [irreducibleSpace_def]
  have htop : (⊤ : Set X) = closure ({x} : Set X) := by
    rw [h.closure_eq]; rfl
  rw [htop]
  exact isIrreducible_singleton.closure

/-- A nonempty open subset of an irreducible space is dense.  Restatement of `IsOpen.dense` kept
here so the WP-1 chart argument reads in one place. -/
theorem dense_of_isOpen_of_nonempty {X : Type*} [TopologicalSpace X] [IrreducibleSpace X]
    {U : Set X} (hU : IsOpen U) (hne : U.Nonempty) : Dense U :=
  hU.dense hne

end BConicBundleMultisections.Standard
