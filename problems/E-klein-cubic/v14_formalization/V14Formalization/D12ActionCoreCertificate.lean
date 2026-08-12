/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12MatrixCertificate
import V14Formalization.D12PolynomialEvaluation
import V14Formalization.D12CompoundR
import V14Formalization.D12CompoundF
import V14Formalization.D12RestrictedProjector

/-!
# The unconditional ambient-action core of the D12 certificate

This module packages the parts of `D12Certificate.Certificate` that do not
depend on the four simultaneous-character calculations.  The matrices are the
actual geometric rotation, reflection, and projector; the sparse polynomial
matrices provide their ten-dimensional restriction.

The remaining inputs to a full certificate are exactly the four
`PieceCertificate`s.
-/

noncomputable section

open Matrix

namespace V14Formalization.D12ActionCoreCertificate

open D12Certificate D12PolynomialData D12PolynomialEvaluation
open Lambda2Coordinates

/-- The common ambient and restricted action data, before adjoining the four
simultaneous-character certificates. -/
structure ActionCore where
  P : Matrix (Fin 15) (Fin 15) WeilRep.K
  R : Matrix (Fin 15) (Fin 15) WeilRep.K
  F : Matrix (Fin 15) (Fin 15) WeilRep.K
  B : Matrix (Fin 15) (Fin 10) WeilRep.K
  L : Matrix (Fin 10) (Fin 15) WeilRep.K
  RM : Matrix (Fin 10) (Fin 10) WeilRep.K
  SM : Matrix (Fin 10) (Fin 10) WeilRep.K
  left_inverse : L * B = 1
  projector_factor : B * L * P = P
  rot_restrict : R * B = B * RM
  refl_restrict : F * B = B * SM

namespace ActionCore

/-- Adjoin the four finite character-piece certificates to an action core. -/
def toCertificate (C : ActionCore)
    (pp : PieceCertificate C.B C.RM C.SM 1 1 (Fin 2))
    (pa : PieceCertificate C.B C.RM C.SM 1 (-1) (Fin 0))
    (ap : PieceCertificate C.B C.RM C.SM (-1) 1 (Fin 1))
    (aa : PieceCertificate C.B C.RM C.SM (-1) (-1) (Fin 1)) :
    Certificate (Ω := WeilRep.K) where
  P := C.P
  R := C.R
  F := C.F
  B := C.B
  L := C.L
  RM := C.RM
  SM := C.SM
  left_inverse := C.left_inverse
  projector_factor := C.projector_factor
  rot_restrict := C.rot_restrict
  refl_restrict := C.refl_restrict
  pp := pp
  pa := pa
  ap := ap
  aa := aa

end ActionCore

/-- The checked action core over the cyclotomic base field. -/
def actionCore : ActionCore where
  P := V14SchemeModel.projectorMatrix
  R := lambda2MatrixRepresentation.ρ
    (CentralizerN.rotGen : GeometricV14Carrier.PSL2F11)
  F := lambda2MatrixRepresentation.ρ
    (CentralizerN.reflGen : GeometricV14Carrier.PSL2F11)
  B := evalMatrixK B_poly
  L := evalMatrixK L_poly
  RM := evalMatrixK RM_poly
  SM := evalMatrixK SM_poly
  left_inverse := evalMatrixK_left_inverse
  projector_factor := D12RestrictedProjector.projector_factor
  rot_restrict := by
    rw [← D12CompoundR.evalMatrixK_R_eq_actualRot]
    exact evalMatrixK_R_mul_B_eq_B_mul_RM
  refl_restrict := by
    rw [← D12CompoundF.evalMatrixK_F_eq_actualRefl]
    exact evalMatrixK_F_mul_B_eq_B_mul_SM

@[simp] theorem actionCore_P :
    actionCore.P = V14SchemeModel.projectorMatrix := rfl

@[simp] theorem actionCore_R :
    actionCore.R =
      (lambda2MatrixRepresentation.ρ
        (CentralizerN.rotGen : GeometricV14Carrier.PSL2F11) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) := rfl

@[simp] theorem actionCore_F :
    actionCore.F =
      (lambda2MatrixRepresentation.ρ
        (CentralizerN.reflGen : GeometricV14Carrier.PSL2F11) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) := rfl

end V14Formalization.D12ActionCoreCertificate
