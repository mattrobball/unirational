/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualPrimitiveEquation

/-! # Axiom audit for residual content removal -/

@[expose] public section

open BConicBundleMultisections

#print axioms
  ResidualPrimitiveEquation.exists_primitive_factorization_of_eq_sum
#print axioms
  ResidualPrimitiveEquation.exists_primitive_residualEquationOn_factorization
#print axioms
  ResidualPrimitiveEquation.exists_primitive_residualEquationOn_factorization_with_degree_control
#print axioms
  MvPolynomial.exists_isHomogeneous_of_mul_isHomogeneous
#print axioms
  MvPolynomial.exists_irreducible_isHomogeneous_dvd
#print axioms
  MvPolynomial.exists_irreducible_isHomogeneous_dvd_aeval_eq_zero
#print axioms
  ResidualPrimitiveEquation.exists_homogeneous_firstBlockContent_primitiveCoefficient
#print axioms
  ResidualPrimitiveEquation.exists_bihomogeneous_primitive_residualEquationOn_factorization
