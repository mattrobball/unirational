/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12GeneratorSPhaseRow5
import V14Formalization.D12GeneratorSPhaseRow8
import V14Formalization.D12GeneratorSPhaseRow10
import V14Formalization.D12GeneratorSPhaseRow12
import V14Formalization.D12GeneratorSPhaseRow13
import V14Formalization.D12GeneratorT2Relations
import V14Formalization.D12U6PolynomialSeal

/-!
# Sparse standard-generator invariance of the D12 ten-space

This module assembles the five independently generated dependent-row
certificates for the Fourier generator.  The ten free rows are read off from
the product itself, so no dense `15 × 15` normalization or finite-group sum is
performed here.
-/

noncomputable section

open Matrix Polynomial

namespace V14Formalization.D12GeneratorInvariance

open D12PolynomialData D12PolynomialEvaluation
open D12GeneratorPolynomialCore

/-- The restricted Fourier-generator action read from the ten free rows. -/
def SrestrictedAction : Matrix (Fin 10) (Fin 10) WeilRep.K :=
  restrictedAction
    (evalMatrixK
      (PluckerNaturality.compound2Lex S6_poly * B_poly))

/-- The five sparse dependent-row certificates assemble into preservation of
the generated ten-space by the evaluated Fourier matrix. -/
theorem evalMatrixK_compound_S6_mul_B_eq :
    evalMatrixK (PluckerNaturality.compound2Lex S6_poly) *
        evalMatrixK B_poly =
      evalMatrixK B_poly * SrestrictedAction := by
  rw [← evalMatrixAt_mul]
  exact mul_B_eq_B_mul_restrictedAction_of_relations
    WeilRep.ζ
    (evalMatrixK
      (PluckerNaturality.compound2Lex S6_poly * B_poly))
    (D12GeneratorSPhaseRow5.eval_relation WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ)
    (D12GeneratorSPhaseRow8.eval_relation WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ)
    (D12GeneratorSPhaseRow10.eval_relation WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ)
    (D12GeneratorSPhaseRow12.eval_relation WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ)
    (D12GeneratorSPhaseRow13.eval_relation WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ)

/-- The genuine exterior-square representation of `Smat` preserves the
generated ten-space. -/
theorem actualS_mul_B_eq :
    (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (QuotientGroup.mk PSLCard.Smat) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) * evalMatrixK B_poly =
      evalMatrixK B_poly * SrestrictedAction := by
  rw [← evalMatrixK_compound_S6_poly_eq_actualS]
  exact evalMatrixK_compound_S6_mul_B_eq

/-- The restricted diagonal-generator action read from the same ten free
rows. -/
def T2restrictedAction : Matrix (Fin 10) (Fin 10) WeilRep.K :=
  restrictedAction
    (evalMatrixK
      (PluckerNaturality.compound2Lex T6_poly * B_poly))

/-- In the emitted basis, the restricted diagonal generator is literally
diagonal.  The ten exponents are kept as their polynomial exponents; at
`WeilRep.ζ` they represent the ten distinct nonzero residue classes mod 11. -/
theorem T2restrictedAction_eq_diagonal :
    T2restrictedAction = Matrix.diagonal fun i =>
      WeilRep.ζ ^ D12GeneratorT2Relations.eigenExponent i := by
  exact D12GeneratorT2Relations.restrictedAction_eval WeilRep.ζ

/-- The five bounded diagonal dependent-row certificates assemble into
preservation of the generated ten-space. -/
theorem evalMatrixK_compound_T6_mul_B_eq :
    evalMatrixK (PluckerNaturality.compound2Lex T6_poly) *
        evalMatrixK B_poly =
      evalMatrixK B_poly * T2restrictedAction := by
  rw [← evalMatrixAt_mul]
  exact mul_B_eq_B_mul_restrictedAction_of_relations
    WeilRep.ζ
    (evalMatrixK
      (PluckerNaturality.compound2Lex T6_poly * B_poly))
    (D12GeneratorT2Relations.eval_relation_5 WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ)
    (D12GeneratorT2Relations.eval_relation_8 WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ)
    (D12GeneratorT2Relations.eval_relation_10 WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ)
    (D12GeneratorT2Relations.eval_relation_12 WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ)
    (D12GeneratorT2Relations.eval_relation_13 WeilRep.ζ
      D12U6PolynomialSeal.evalPhi11_ζ)

/-- The genuine exterior-square representation of `Tmat²` preserves the
generated ten-space. -/
theorem actualT2_mul_B_eq :
    (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (QuotientGroup.mk (PSLCard.Tmat ^ 2)) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) * evalMatrixK B_poly =
      evalMatrixK B_poly * T2restrictedAction := by
  rw [← evalMatrixK_compound_T6_poly_eq_actualT2]
  exact evalMatrixK_compound_T6_mul_B_eq

/-- Invariance under the two standard generators implies invariance under the
genuine character projector, without expanding its `660` summands. -/
theorem projector_mul_B_eq :
    ∃ A : Matrix (Fin 10) (Fin 10) WeilRep.K,
      V14SchemeModel.projectorMatrix * evalMatrixK B_poly =
        evalMatrixK B_poly * A := by
  exact D12ProjectorReduction.projector_invariant_of_standard_generators_pow_two
    (evalMatrixK B_poly) (evalMatrixK L_poly)
    evalMatrixK_left_inverse SrestrictedAction T2restrictedAction
    actualS_mul_B_eq actualT2_mul_B_eq

end V14Formalization.D12GeneratorInvariance
