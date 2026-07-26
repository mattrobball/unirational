/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.WeierstrassResidualInfinitesimalCertificate

/-!
# Axiom audit for the short-Weierstrass infinitesimal certificate

Run

`lake env lean BConicBundleMultisections/WeierstrassResidualInfinitesimalCertificateAxiomAudit.lean`

to print the transitive axiom dependencies.  This is kept separate from the certificate so that
the algebraic declarations remain usable without diagnostic output.
-/

#print axioms
  BConicBundleMultisections.WeierstrassResidualInfinitesimalCertificate.ambientCoeffU_weierstrass
#print axioms
  BConicBundleMultisections.WeierstrassResidualInfinitesimalCertificate.ne_zero_or_ne_zero_of_discr_ne_zero
#print axioms
  BConicBundleMultisections.WeierstrassResidualInfinitesimalCertificate.tangent_eq_smul_of_cross_equations
#print axioms
  BConicBundleMultisections.WeierstrassResidualInfinitesimalCertificate.tangent_eq_smul_of_residualU_equations
