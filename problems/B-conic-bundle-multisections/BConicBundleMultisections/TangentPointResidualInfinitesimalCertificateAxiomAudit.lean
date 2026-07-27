/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.TangentPointResidualInfinitesimalCertificate

/-!
# Axiom audit for the tangent-point infinitesimal certificate

Run

`lake env lean BConicBundleMultisections/TangentPointResidualInfinitesimalCertificateAxiomAudit.lean`

to print the transitive axiom dependencies.
-/

#print axioms
  BConicBundleMultisections.TangentPointResidualInfinitesimalCertificate.three_mul_nonflexDiscr
#print axioms
  BConicBundleMultisections.TangentPointResidualInfinitesimalCertificate.normalized_tangent_eq_zero_of_cross_equations
