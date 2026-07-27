/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.FunctionField
public import Mathlib.AlgebraicGeometry.Morphisms.UnderlyingMap
public import Mathlib.AlgebraicGeometry.Stalk

/-!
# Dominance of the function-field point

For an integral scheme `X`, the canonical morphism `Spec k(X) ⟶ X` has image containing the
generic point and is therefore dominant.  Mathlib supplies both ingredients -- the closed point of
the spectrum of the stalk maps to the chosen point, and the generic point has dense closure -- but
does not package their composite as an `IsDominant` instance.

This is the scheme-theoretic bridge used by the generic-fibre version of the pointed-conic
argument: one may work over `Spec k(T)` and then postcompose back to `T` (and ultimately to the
original biprojective hypersurface) without proving integrality of the entire base change over
`T`.
-/

@[expose] public section

open AlgebraicGeometry

universe u

namespace BConicBundleMultisections

noncomputable section

/-- The canonical function-field point of an integral scheme is dominant. -/
theorem isDominant_fromSpecFunctionField (X : Scheme.{u}) [IsIntegral X] :
    IsDominant (X.fromSpecStalk (genericPoint X)) := by
  refine ⟨?_⟩
  rw [DenseRange]
  have hd : Dense ({genericPoint X} : Set X) := by
    rw [dense_iff_closure_eq, genericPoint_spec]
  apply Dense.mono (Set.singleton_subset_iff.mpr ?_) hd
  exact ⟨IsLocalRing.closedPoint X.functionField, Scheme.fromSpecStalk_closedPoint⟩

end

end BConicBundleMultisections
