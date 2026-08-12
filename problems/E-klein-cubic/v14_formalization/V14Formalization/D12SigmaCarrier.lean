/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.V14FixedPointCarrierDimensionFactorization
import V14Formalization.D12GeneratorInvariance

/-!
# Structural sigma carriers inside the checked D12 ten-space

The actual ambient carrier matrices are defined as `B * Kplus` and
`B * Kminus`. Their left inverses are obtained by selecting the first six or
four coordinates after applying the checked left inverse `L`. Consequently a
finite carrier certificate contains only the two restricted coordinate
matrices, their identity top blocks, and their sigma eigenvalue identities.
-/

noncomputable section

open Matrix

namespace V14Formalization.D12SigmaCarrier

open D12ActionCoreCertificate D12GeneratorInvariance

abbrev K := WeilRep.K

/-- Select the first six coordinates of the checked D12 basis. -/
def selectPlus : Matrix (Fin 6) (Fin 10) K := fun i j =>
  if j.val = i.val then 1 else 0

/-- Select the first four coordinates of the checked D12 basis. -/
def selectMinus : Matrix (Fin 4) (Fin 10) K := fun i j =>
  if j.val = i.val then 1 else 0

/-- Minimal finite interface for the two sigma eigencarriers. -/
structure Core where
  Kplus : Matrix (Fin 10) (Fin 6) K
  Kminus : Matrix (Fin 10) (Fin 4) K
  plus_top : selectPlus * Kplus = 1
  minus_top : selectMinus * Kminus = 1
  plus_eigen : SrestrictedAction * Kplus = Kplus
  minus_eigen : SrestrictedAction * Kminus = -Kminus

namespace Core

private theorem sigma_eq_pslCardSmat :
    GeometricV14Carrier.sigma = QuotientGroup.mk PSLCard.Smat := by
  rfl

/-- The actual ambient plus carrier. -/
def Bplus (C : Core) : Matrix (Fin 15) (Fin 6) K :=
  actionCore.B * C.Kplus

/-- A structural left inverse of the actual ambient plus carrier. -/
def Lplus (_C : Core) : Matrix (Fin 6) (Fin 15) K :=
  selectPlus * actionCore.L

/-- The actual ambient minus carrier. -/
def Bminus (C : Core) : Matrix (Fin 15) (Fin 4) K :=
  actionCore.B * C.Kminus

/-- A structural left inverse of the actual ambient minus carrier. -/
def Lminus (_C : Core) : Matrix (Fin 4) (Fin 15) K :=
  selectMinus * actionCore.L

theorem left_inverse_plus (C : Core) : C.Lplus * C.Bplus = 1 := by
  simp only [Lplus, Bplus, Matrix.mul_assoc]
  rw [← Matrix.mul_assoc actionCore.L actionCore.B C.Kplus,
    actionCore.left_inverse, Matrix.one_mul, C.plus_top]

theorem left_inverse_minus (C : Core) : C.Lminus * C.Bminus = 1 := by
  simp only [Lminus, Bminus, Matrix.mul_assoc]
  rw [← Matrix.mul_assoc actionCore.L actionCore.B C.Kminus,
    actionCore.left_inverse, Matrix.one_mul, C.minus_top]

theorem ambient_factor_plus (C : Core) :
    actionCore.B * actionCore.L * C.Bplus = C.Bplus := by
  simp only [Bplus, Matrix.mul_assoc]
  rw [← Matrix.mul_assoc actionCore.L actionCore.B C.Kplus,
    actionCore.left_inverse, Matrix.one_mul]

theorem ambient_factor_minus (C : Core) :
    actionCore.B * actionCore.L * C.Bminus = C.Bminus := by
  simp only [Bminus, Matrix.mul_assoc]
  rw [← Matrix.mul_assoc actionCore.L actionCore.B C.Kminus,
    actionCore.left_inverse, Matrix.one_mul]

theorem sigma_eigen_plus (C : Core) :
    (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
      GeometricV14Carrier.sigma : Matrix (Fin 15) (Fin 15) K) * C.Bplus =
        C.Bplus := by
  have hSB :
      (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        GeometricV14Carrier.sigma : Matrix (Fin 15) (Fin 15) K) *
          actionCore.B = actionCore.B * SrestrictedAction := by
    rw [sigma_eq_pslCardSmat]
    simpa only [D12ActionCoreCertificate.actionCore] using
      D12GeneratorInvariance.actualS_mul_B_eq
  calc
    (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        GeometricV14Carrier.sigma : Matrix (Fin 15) (Fin 15) K) * C.Bplus =
        ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
          GeometricV14Carrier.sigma : Matrix (Fin 15) (Fin 15) K) *
            actionCore.B) * C.Kplus := by simp only [Bplus, Matrix.mul_assoc]
    _ = (actionCore.B * SrestrictedAction) * C.Kplus := by rw [hSB]
    _ = actionCore.B * (SrestrictedAction * C.Kplus) := by
      simp only [Matrix.mul_assoc]
    _ = actionCore.B * C.Kplus := by rw [C.plus_eigen]
    _ = C.Bplus := rfl

theorem sigma_eigen_minus (C : Core) :
    (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
      GeometricV14Carrier.sigma : Matrix (Fin 15) (Fin 15) K) * C.Bminus =
        -C.Bminus := by
  have hSB :
      (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        GeometricV14Carrier.sigma : Matrix (Fin 15) (Fin 15) K) *
          actionCore.B = actionCore.B * SrestrictedAction := by
    rw [sigma_eq_pslCardSmat]
    simpa only [D12ActionCoreCertificate.actionCore] using
      D12GeneratorInvariance.actualS_mul_B_eq
  calc
    (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        GeometricV14Carrier.sigma : Matrix (Fin 15) (Fin 15) K) * C.Bminus =
        ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
          GeometricV14Carrier.sigma : Matrix (Fin 15) (Fin 15) K) *
            actionCore.B) * C.Kminus := by simp only [Bminus, Matrix.mul_assoc]
    _ = (actionCore.B * SrestrictedAction) * C.Kminus := by rw [hSB]
    _ = actionCore.B * (SrestrictedAction * C.Kminus) := by
      simp only [Matrix.mul_assoc]
    _ = actionCore.B * (-C.Kminus) := by rw [C.minus_eigen]
    _ = -(actionCore.B * C.Kminus) := Matrix.mul_neg _ _
    _ = -C.Bminus := rfl

end Core

end V14Formalization.D12SigmaCarrier
