/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12PiecePPCertificate
import V14Formalization.D12PiecePACertificate
import V14Formalization.D12PieceAPCertificate
import V14Formalization.D12PieceAACertificate

/-! # The complete D12 matrix certificate over `WeilRep.K`. -/

noncomputable section

namespace V14Formalization.D12CertificateK

open D12ActionCoreCertificate

/-- All four simultaneous character pieces adjoined to the geometric action
core. -/
def certificate : D12Certificate.Certificate (Ω := WeilRep.K) :=
  actionCore.toCertificate
    D12PiecePPCertificate.certificate
    D12PiecePACertificate.certificate
    D12PieceAPCertificate.certificate
    D12PieceAACertificate.certificate

@[simp] theorem certificate_P :
    certificate.P = V14SchemeModel.projectorMatrix := rfl

@[simp] theorem certificate_R :
    certificate.R =
      (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (CentralizerN.rotGen : GeometricV14Carrier.PSL2F11) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) := rfl

@[simp] theorem certificate_F :
    certificate.F =
      (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (CentralizerN.reflGen : GeometricV14Carrier.PSL2F11) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) := rfl

end V14Formalization.D12CertificateK
