/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.TargetRelationProjectiveIntegrality

/-! Axiom audit for the projective target-relation integrality bridge. -/

set_option linter.style.longLine false

#print axioms
  BConicBundleMultisections.span_range_coeff_universalSndConicModulo_ne_top
#print axioms
  BConicBundleMultisections.isIntegral_targetRelationZeroLocus_of_projectiveCurve_pullback
#print axioms
  BConicBundleMultisections.isIntegral_targetRelationZeroLocus_of_projectiveCurve_pullback_of_geometricallyIntegral
#print axioms
  BConicBundleMultisections.isIntegral_targetRelationZeroLocus_of_irreducible_homogeneous_not_dvd_discriminant
