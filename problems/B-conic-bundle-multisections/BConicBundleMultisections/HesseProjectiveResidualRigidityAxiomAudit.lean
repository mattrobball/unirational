/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HesseProjectiveResidualRigidity

/-!
# Axiom audit for projective Hesse residual-map rigidity

Run

`lake env lean BConicBundleMultisections/HesseProjectiveResidualRigidityAxiomAudit.lean`

to print the transitive axiom dependencies of the interpolation, scalar-rigidity, recovery, and
endpoint theorems.
-/

#print axioms
  BConicBundleMultisections.HesseProjectiveResidualRigidity.octic_coefficients_eq_zero
#print axioms
  BConicBundleMultisections.HesseProjectiveResidualRigidity.coefficients_eq_zero_of_crossEquations
#print axioms
  BConicBundleMultisections.HesseProjectiveResidualRigidity.coefficients_eq_zero_of_projective_hesse
#print axioms
  BConicBundleMultisections.HesseProjectiveResidualRigidity.recoveryEquations_of_projectiveResidual_eq
#print axioms
  BConicBundleMultisections.HesseProjectiveResidualRigidity.eq_hesse_of_projective_fullResidual_eq
#print axioms
  BConicBundleMultisections.HesseProjectiveResidualRigidity.eq_hesse_of_projective_fullResidual_eq_at_origin
