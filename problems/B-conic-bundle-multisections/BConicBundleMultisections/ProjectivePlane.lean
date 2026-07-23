/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveSpace

/-!
# Projective-plane specializations

This file supplies the dimension-two aliases used by the final `(2, 3)` threefold theorem.  The
projective-space, product-chart, and overlap infrastructure itself remains dimension-generic in
the modules imported below.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

/-- The projective plane over a commutative ring. -/
abbrev ProjectivePlane (R : Type u) [CommRing R] := ProjectiveSpace 2 R

/-- The self-product `ℙ²_R ×_{Spec R} ℙ²_R`. -/
abbrev ProductOfProjectivePlanes (R : Type u) [CommRing R] :=
  BiprojectiveSpace 2 2 R

end

end BConicBundleMultisections
