/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12CertificateBaseChange
public import V14Formalization.D12CertificateK

/-!
# The D12 certificate over an arbitrary extension of the cyclotomic base

`D12CertificateK.certificate` is the checked four-piece certificate over
`WeilRep.K = ℚ(ζ₁₁)`.  This file discharges the three explicit nonvanishing
conditions of `D12Certificate.Certificate.mapRingHom` for it, and so produces
the same certificate over **any** field receiving a ring map from `WeilRep.K`.

The three scalars are

* `(+,+)`: the determinant of the canonical `3 × 3` Plücker coefficient matrix,
  equal to `D12PiecePPPlucker.C.det`;
* `(-,+)`: `D12PieceAPPlucker.deltaVec` evaluated in `ℚ(ζ₁₁)`;
* `(-,-)`: `D12PieceAAPlucker.deltaVec` evaluated in `ℚ(ζ₁₁)`.

Along a ring map out of a field all three stay nonzero automatically, so no
condition at all is left on the target field.  What the *general* statement
`mapRingHom` needs is only that the three images are nonzero — which is the
honest, ring-map-level form of "the D12 fixed locus is empty".
-/

noncomputable section

open Matrix

namespace V14Formalization
namespace D12CertificateK

open D12Certificate D12ActionCoreCertificate D12CyclotomicVec

/-! ## The four emitted action matrices are character stacks -/

public theorem pp_A :
    certificate.pp.A =
      D12PieceAction.characterStack certificate.RM certificate.SM 1 1 := rfl

public theorem pa_A :
    certificate.pa.A =
      D12PieceAction.characterStack certificate.RM certificate.SM 1 (-1) := rfl

public theorem ap_A :
    certificate.ap.A =
      D12PieceAction.characterStack certificate.RM certificate.SM (-1) 1 := rfl

public theorem aa_A :
    certificate.aa.A =
      D12PieceAction.characterStack certificate.RM certificate.SM (-1) (-1) := rfl

/-! ## The three nonvanishing scalars -/

public theorem ppDet_eq : certificate.ppDet = D12PiecePPPlucker.C.det := by
  have hC : D12PiecePPPlucker.C =
      pluckerCoeffMatrix2 (certificate.B * certificate.pp.K) :=
    eq_pluckerCoeffMatrix2 fun t => by
      show D12PiecePPPlucker.C.mulVec (squareMonomials t) =
        ![pluckerValue ((D12ActionCoreCertificate.actionCore.B *
            D12PiecePPCertificate.K).mulVec t) 1,
          pluckerValue ((D12ActionCoreCertificate.actionCore.B *
            D12PiecePPCertificate.K).mulVec t) 2,
          pluckerValue ((D12ActionCoreCertificate.actionCore.B *
            D12PiecePPCertificate.K).mulVec t) 9]
      rw [D12PiecePPCertificate.BK_eq]
      exact D12PiecePPPlucker.coefficient_identity t
  show (pluckerCoeffMatrix2 (certificate.B * certificate.pp.K)).det = _
  rw [← hC]

public theorem ppDet_ne_zero : certificate.ppDet ≠ 0 := by
  rw [ppDet_eq]
  exact D12PiecePPPlucker.det_ne_zero

public theorem apDelta_eq :
    certificate.apDelta = eval D12PieceAPPlucker.deltaVec :=
  (eq_pluckerCoeff1 (M := certificate.B * certificate.ap.K)
    (delta := eval D12PieceAPPlucker.deltaVec) (q := 0) fun t => by
      show pluckerValue ((D12ActionCoreCertificate.actionCore.B *
        D12PieceAPCertificate.K).mulVec t) 0 = _
      rw [D12PieceAPCertificate.BK_eq]
      exact D12PieceAPPlucker.plucker_coefficient t).symm

public theorem apDelta_ne_zero : certificate.apDelta ≠ 0 := by
  rw [apDelta_eq]
  exact D12PieceAPPlucker.delta_ne_zero

public theorem aaDelta_eq :
    certificate.aaDelta = eval D12PieceAAPlucker.deltaVec :=
  (eq_pluckerCoeff1 (M := certificate.B * certificate.aa.K)
    (delta := eval D12PieceAAPlucker.deltaVec) (q := 0) fun t => by
      show pluckerValue ((D12ActionCoreCertificate.actionCore.B *
        D12PieceAACertificate.K).mulVec t) 0 = _
      rw [D12PieceAACertificate.BK_eq]
      exact D12PieceAAPlucker.plucker_coefficient t).symm

public theorem aaDelta_ne_zero : certificate.aaDelta ≠ 0 := by
  rw [aaDelta_eq]
  exact D12PieceAAPlucker.delta_ne_zero

/-! ## The certificate over an arbitrary field over the cyclotomic base -/

universe u

variable (F : Type u) [Field F] [Algebra WeilRep.K F]

/-- The checked four-piece D12 certificate, base-changed to an arbitrary field
extension of `ℚ(ζ₁₁)`.  No hypothesis on `F` beyond being a field over the
cyclotomic base: the three coefficient scalars survive because a ring map out
of a field is injective. -/
@[expose] public def certificateOver : D12Certificate.Certificate (Ω := F) :=
  certificate.mapOfInjective (algebraMap WeilRep.K F)
    (algebraMap WeilRep.K F).injective
    pp_A pa_A ap_A aa_A ppDet_ne_zero apDelta_ne_zero aaDelta_ne_zero

@[simp] public theorem certificateOver_P :
    (certificateOver F).P = certificate.P.map (algebraMap WeilRep.K F) := rfl

@[simp] public theorem certificateOver_R :
    (certificateOver F).R = certificate.R.map (algebraMap WeilRep.K F) := rfl

@[simp] public theorem certificateOver_F :
    (certificateOver F).F = certificate.F.map (algebraMap WeilRep.K F) := rfl

end D12CertificateK
end V14Formalization
