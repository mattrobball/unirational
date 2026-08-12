import V14Formalization.V14FixedPointEquations

/-!
# Linear algebra after projective sigma fixedness

This file is representation-free. It turns a nonzero eigenvector of an
involutive matrix, already known to lie in the image of a commuting
idempotent, into its plus/minus projector and certified-basis factorization.
-/

noncomputable section

open Matrix

namespace V14Formalization
namespace SigmaProjectorLinearAlgebra

universe u v w

variable {L : Type u} [Field L]
variable {ι : Type v} [Fintype ι]

/-- The plus projector on the image of `P` for a commuting involution `S`. -/
def plusProjector (P S : Matrix ι ι L) : Matrix ι ι L :=
  (2 : L)⁻¹ • (P + S * P)

/-- The minus projector on the image of `P` for a commuting involution `S`. -/
def minusProjector (P S : Matrix ι ι L) : Matrix ι ι L :=
  (2 : L)⁻¹ • (P - S * P)

/-- A nonzero eigenvector of an involution has eigenvalue `+1` or `-1`. -/
theorem eigenvalue_eq_one_or_neg_one_of_involution
    [DecidableEq ι]
    (S : Matrix ι ι L) (x : ι → L) (a : L)
    (hS2 : S * S = 1) (hx : x ≠ 0)
    (hSx : S.mulVec x = a • x) :
    a = 1 ∨ a = -1 := by
  have hSSx : S.mulVec (S.mulVec x) = x := by
    rw [Matrix.mulVec_mulVec, hS2, Matrix.one_mulVec]
  have haa_smul : (a * a) • x = (1 : L) • x := by
    calc
      (a * a) • x = a • (a • x) := mul_smul a a x
      _ = a • S.mulVec x := by rw [hSx]
      _ = S.mulVec (a • x) := (Matrix.mulVec_smul S a x).symm
      _ = S.mulVec (S.mulVec x) := by rw [hSx]
      _ = x := hSSx
      _ = (1 : L) • x := (one_smul L x).symm
  have haa : a * a = 1 :=
    (smul_left_injective L hx) haa_smul
  exact mul_self_eq_one_iff.mp haa

/-- A `+1` eigenvector in the image of `P` is fixed by `plusProjector`. -/
theorem plusProjector_mulVec_eq_self
    [NeZero (2 : L)]
    (P S : Matrix ι ι L) (x : ι → L)
    (hPx : P.mulVec x = x) (hSx : S.mulVec x = x) :
    (plusProjector P S).mulVec x = x := by
  rw [plusProjector, Matrix.smul_mulVec, Matrix.add_mulVec,
    ← Matrix.mulVec_mulVec, hPx, hSx]
  ext i
  change (2 : L)⁻¹ * (x i + x i) = x i
  rw [← two_mul, ← mul_assoc, inv_mul_cancel₀ (NeZero.ne (2 : L)), one_mul]

/-- A `-1` eigenvector in the image of `P` is fixed by `minusProjector`. -/
theorem minusProjector_mulVec_eq_self
    [NeZero (2 : L)]
    (P S : Matrix ι ι L) (x : ι → L)
    (hPx : P.mulVec x = x) (hSx : S.mulVec x = (-1 : L) • x) :
    (minusProjector P S).mulVec x = x := by
  rw [minusProjector, Matrix.smul_mulVec, Matrix.sub_mulVec,
    ← Matrix.mulVec_mulVec, hPx, hSx]
  ext i
  simp only [Pi.smul_apply, Pi.sub_apply, smul_eq_mul, neg_one_mul,
    sub_neg_eq_add]
  change (2 : L)⁻¹ * (x i + x i) = x i
  rw [← two_mul, ← mul_assoc, inv_mul_cancel₀ (NeZero.ne (2 : L)), one_mul]

/-- A fixed vector of a projector `B*Lmat` is reconstructed from its certified
coordinates `Lmat*x`. -/
theorem eq_mulVec_mulVec_of_projector_fixed
    {κ : Type w} [Fintype κ]
    (Q : Matrix ι ι L) (B : Matrix ι κ L) (Lmat : Matrix κ ι L)
    (x : ι → L) (hBL : B * Lmat = Q) (hQx : Q.mulVec x = x) :
    x = B.mulVec (Lmat.mulVec x) := by
  calc
    x = Q.mulVec x := hQx.symm
    _ = (B * Lmat).mulVec x := by rw [hBL]
    _ = B.mulVec (Lmat.mulVec x) := (Matrix.mulVec_mulVec x B Lmat).symm

/-- The complete pointwise plus/minus reduction, including reconstruction in
the supplied certified carrier bases. The idempotence and commutation
hypotheses record the intended projector setup; the pointwise conclusion uses
their consequences `P*x=x` and `S^2=1` directly. -/
theorem eq_plus_or_minus_carrier_of_projector_involution_eigenvector
    [DecidableEq ι] [NeZero (2 : L)]
    {κplus : Type w} {κminus : Type w}
    [Fintype κplus] [Fintype κminus]
    (P S : Matrix ι ι L)
    (Bplus : Matrix ι κplus L) (Lplus : Matrix κplus ι L)
    (Bminus : Matrix ι κminus L) (Lminus : Matrix κminus ι L)
    (x : ι → L) (a : L)
    (_hP2 : P * P = P) (_hPS : P * S = S * P)
    (hS2 : S * S = 1)
    (hPx : P.mulVec x = x) (hx : x ≠ 0)
    (hSx : S.mulVec x = a • x)
    (hBLplus : Bplus * Lplus = plusProjector P S)
    (hBLminus : Bminus * Lminus = minusProjector P S) :
    (a = 1 ∧
      (plusProjector P S).mulVec x = x ∧
      x = Bplus.mulVec (Lplus.mulVec x)) ∨
    (a = -1 ∧
      (minusProjector P S).mulVec x = x ∧
      x = Bminus.mulVec (Lminus.mulVec x)) := by
  rcases eigenvalue_eq_one_or_neg_one_of_involution S x a hS2 hx hSx with
      ha | ha
  · left
    have hSx' : S.mulVec x = x := by simpa [ha] using hSx
    have hplus := plusProjector_mulVec_eq_self P S x hPx hSx'
    exact ⟨ha, hplus,
      eq_mulVec_mulVec_of_projector_fixed
        (plusProjector P S) Bplus Lplus x hBLplus hplus⟩
  · right
    have hSx' : S.mulVec x = (-1 : L) • x := by simpa [ha] using hSx
    have hminus := minusProjector_mulVec_eq_self P S x hPx hSx'
    exact ⟨ha, hminus,
      eq_mulVec_mulVec_of_projector_fixed
        (minusProjector P S) Bminus Lminus x hBLminus hminus⟩

/-- Exact `15 = 6 + 4` interface for the V14 sigma certificate matrices. -/
theorem fin15_eq_plus6_or_minus4_carrier
    [NeZero (2 : L)]
    (P S : Matrix (Fin 15) (Fin 15) L)
    (Bplus : Matrix (Fin 15) (Fin 6) L)
    (Lplus : Matrix (Fin 6) (Fin 15) L)
    (Bminus : Matrix (Fin 15) (Fin 4) L)
    (Lminus : Matrix (Fin 4) (Fin 15) L)
    (x : Fin 15 → L) (a : L)
    (hP2 : P * P = P) (hPS : P * S = S * P)
    (hS2 : S * S = 1)
    (hPx : P.mulVec x = x) (hx : x ≠ 0)
    (hSx : S.mulVec x = a • x)
    (hBLplus : Bplus * Lplus = plusProjector P S)
    (hBLminus : Bminus * Lminus = minusProjector P S) :
    (a = 1 ∧
      (plusProjector P S).mulVec x = x ∧
      x = Bplus.mulVec (Lplus.mulVec x)) ∨
    (a = -1 ∧
      (minusProjector P S).mulVec x = x ∧
      x = Bminus.mulVec (Lminus.mulVec x)) :=
  eq_plus_or_minus_carrier_of_projector_involution_eigenvector
    P S Bplus Lplus Bminus Lminus x a hP2 hPS hS2 hPx hx hSx
      hBLplus hBLminus

end SigmaProjectorLinearAlgebra
end V14Formalization
