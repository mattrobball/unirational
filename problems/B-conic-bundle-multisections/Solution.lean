/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
import Solution.Definitions
import BConicBundleMultisections.MainTheorem

/-!
# Comparator solution wrapper

This theorem extracts the direct dominant rational map requested by `Statement.lean` from the
project's packaged headline theorem.
-/

open CategoryTheory
open scoped AlgebraicGeometry

namespace Bidegree23Unirationality

noncomputable section

universe u

open AlgebraicGeometry BiprojectiveSpace

theorem smooth_bidegree23_hasUnirationalParametrization
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) := by
  have hscheme : Bidegree23ZeroLocus k F =
      BConicBundleMultisections.Bidegree23ZeroLocus k F := rfl
  have htoSpec : Bidegree23ZeroLocus.toSpec k F =
      BConicBundleMultisections.Bidegree23ZeroLocus.toSpec k F := rfl
  have hsmoothFresh : Smooth (Bidegree23ZeroLocus.toSpec k F) := inferInstance
  letI : Smooth (BConicBundleMultisections.Bidegree23ZeroLocus.toSpec k F) :=
    htoSpec ▸ hsmoothFresh
  obtain ⟨p⟩ :=
    BConicBundleMultisections.smooth_bidegree23_hasUnirationalParametrization
      k F hF hF0
  exact ⟨p.map, p.isDominant, p.isOver⟩

end

end Bidegree23Unirationality
