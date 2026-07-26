/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveHypersurfaceNegativeTwist

/-! # Axiom audit for projective-hypersurface negative-twist lemmas -/

@[expose] public section

open BConicBundleMultisections
open BConicBundleMultisections.ProjectiveSpace

#print axioms dvd_X_sub_C_mul_X_of_normalizedCoordinate_eq_algebraMap
#print axioms exists_normalizedCoordinate_not_baseScalar
#print axioms hypersurfaceFunctionField_eq_zero_of_all_quadraticMultiples_scalar
#print axioms exists_scalar_eq_projectiveZeroLocus_globalSection
#print axioms hypersurfaceFunctionField_eq_zero_of_quadraticMultiples_extendToGlobal
#print axioms hypersurfaceFunctionField_eq_zero_of_homogeneousQuadraticMultiples_extendToGlobal

end
