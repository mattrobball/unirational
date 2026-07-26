/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HesseNormalFormBridge

/-!
# Axiom audit for the elementary Hesse normal-form layer

This file is intentionally executable documentation.  Running

`lake env lean BConicBundleMultisections/HesseNormalFormAxiomAudit.lean`

prints the transitive axiom dependencies of the main declarations.  The downstream standard
residual-line rigidity theorem is now proved and has its own focused audit.
-/

#print axioms BConicBundleMultisections.HesseNormalForm.hesseCubic_isHomogeneous
#print axioms BConicBundleMultisections.HesseNormalForm.isSmoothPlaneCubic_hesseCubic_iff
#print axioms BConicBundleMultisections.HesseNormalForm.hesseJPolynomial_degree
#print axioms BConicBundleMultisections.HesseNormalForm.exists_hesseParameter_jValue_eq
#print axioms BConicBundleMultisections.HesseNormalForm.exists_hesseParameter_variableChange_to_ofJ
#print axioms BConicBundleMultisections.HesseNormalForm.exists_weierstrassSupport_coordinates
#print axioms BConicBundleMultisections.HesseNormalForm.exists_hesseWeierstrassModel
#print axioms BConicBundleMultisections.HesseNormalForm.variableChangeMatrix_mul_inv
#print axioms
  BConicBundleMultisections.HesseNormalForm.aeval_variableChangeMatrix_weierstrassPolynomial
#print axioms BConicBundleMultisections.HesseNormalForm.exists_hesseNormalForm_coordinates
