/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12PolynomialCore
import V14Formalization.D12PolynomialRFull
import V14Formalization.D12PolynomialFFull
import V14Formalization.WeilRep

/-!
# Evaluating the polynomial D12 certificate

The generated D12 data are identities over `ℚ[X]`.  This file supplies the
small structural bridge that evaluates those identities in an arbitrary
`ℚ`-algebra, and in particular in the cyclotomic field `WeilRep.K` at `ζ`.
No generated matrix arithmetic is repeated here.
-/

noncomputable section

open Polynomial Matrix

namespace V14Formalization.D12PolynomialEvaluation

open D12PolynomialData

/-- Evaluation of the polynomial certificate at an element of a `ℚ`-algebra. -/
def evalPolyAt {S : Type*} [CommRing S] [Algebra ℚ S] (z : S) :
    Polynomial ℚ →+* S :=
  (aeval z : Polynomial ℚ →ₐ[ℚ] S).toRingHom

/-- Entrywise evaluation of a polynomial matrix. -/
def evalMatrixAt {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {m n : Type*} (M : Matrix m n (Polynomial ℚ)) : Matrix m n S :=
  M.map (evalPolyAt z)

@[simp] theorem evalMatrixAt_add {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {m n : Type*} (A B : Matrix m n (Polynomial ℚ)) :
    evalMatrixAt z (A + B) = evalMatrixAt z A + evalMatrixAt z B := by
  ext i j
  exact map_add (evalPolyAt z) (A i j) (B i j)

@[simp] theorem evalMatrixAt_sub {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {m n : Type*} (A B : Matrix m n (Polynomial ℚ)) :
    evalMatrixAt z (A - B) = evalMatrixAt z A - evalMatrixAt z B := by
  ext i j
  exact map_sub (evalPolyAt z) (A i j) (B i j)

@[simp] theorem evalMatrixAt_zero {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {m n : Type*} :
    evalMatrixAt z (0 : Matrix m n (Polynomial ℚ)) = 0 := by
  ext i j
  exact map_zero (evalPolyAt z)

@[simp] theorem evalMatrixAt_one {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {n : Type*} [DecidableEq n] :
    evalMatrixAt z (1 : Matrix n n (Polynomial ℚ)) = 1 := by
  exact Matrix.map_one (evalPolyAt z)
    (map_zero (evalPolyAt z)) (map_one (evalPolyAt z))

@[simp] theorem evalMatrixAt_mul {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {m n o : Type*} [Fintype n]
    (A : Matrix m n (Polynomial ℚ)) (B : Matrix n o (Polynomial ℚ)) :
    evalMatrixAt z (A * B) = evalMatrixAt z A * evalMatrixAt z B := by
  exact Matrix.map_mul

/-- The sparse generated left inverse remains a left inverse after evaluation. -/
theorem evalMatrixAt_left_inverse {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) :
    evalMatrixAt z L_poly * evalMatrixAt z B_poly = 1 := by
  rw [← evalMatrixAt_mul, L_mul_B_poly, evalMatrixAt_one]

/-- A certified zero matrix entry remains zero after evaluation. -/
theorem evalMatrixAt_entry_eq_zero_of_entry_eq_zero
    {S : Type*} [CommRing S] [Algebra ℚ S] (z : S)
    {m n : Type*} (M : Matrix m n (Polynomial ℚ)) (i : m) (j : n)
    (h : M i j = 0) : evalMatrixAt z M i j = 0 := by
  simpa [evalMatrixAt] using congrArg (evalPolyAt z) h

/-- Evaluation in the cyclotomic field at its distinguished root. -/
abbrev evalK : Polynomial ℚ →+* WeilRep.K := evalPolyAt WeilRep.ζ

/-- Matrix evaluation in the cyclotomic field at its distinguished root. -/
abbrev evalMatrixK {m n : Type*} (M : Matrix m n (Polynomial ℚ)) :
    Matrix m n WeilRep.K :=
  evalMatrixAt WeilRep.ζ M

theorem evalMatrixK_left_inverse :
    evalMatrixK L_poly * evalMatrixK B_poly = 1 :=
  evalMatrixAt_left_inverse WeilRep.ζ

/-- The certified rotation restriction remains valid after evaluation in any
commutative `ℚ`-algebra. -/
theorem evalMatrixAt_R_mul_B_eq_B_mul_RM
    {S : Type*} [CommRing S] [Algebra ℚ S] (z : S) :
    evalMatrixAt z RFull.R_poly * evalMatrixAt z B_poly =
      evalMatrixAt z B_poly * evalMatrixAt z RM_poly := by
  rw [← evalMatrixAt_mul, ← evalMatrixAt_mul,
    RFull.R_mul_B_eq_B_mul_RM]

/-- The rotation restriction identity over the actual cyclotomic field. -/
theorem evalMatrixK_R_mul_B_eq_B_mul_RM :
    evalMatrixK RFull.R_poly * evalMatrixK B_poly =
      evalMatrixK B_poly * evalMatrixK RM_poly :=
  evalMatrixAt_R_mul_B_eq_B_mul_RM WeilRep.ζ

/-- The certified reflection restriction remains valid after evaluation in any
commutative `ℚ`-algebra. -/
theorem evalMatrixAt_F_mul_B_eq_B_mul_SM
    {S : Type*} [CommRing S] [Algebra ℚ S] (z : S) :
    evalMatrixAt z FFull.F_poly * evalMatrixAt z B_poly =
      evalMatrixAt z B_poly * evalMatrixAt z SM_poly := by
  rw [← evalMatrixAt_mul, ← evalMatrixAt_mul,
    FFull.F_mul_B_eq_B_mul_SM]

/-- The reflection restriction identity over the actual cyclotomic field. -/
theorem evalMatrixK_F_mul_B_eq_B_mul_SM :
    evalMatrixK FFull.F_poly * evalMatrixK B_poly =
      evalMatrixK B_poly * evalMatrixK SM_poly :=
  evalMatrixAt_F_mul_B_eq_B_mul_SM WeilRep.ζ

/-- Evaluation at the image of `ζ` agrees with scalar extension of the
already evaluated polynomial over `WeilRep.K`. -/
theorem evalPolyAt_extension_eq_map_evalPolyAt
    (Ω : Type*) [CommRing Ω] [Algebra ℚ Ω] [Algebra WeilRep.K Ω]
    [IsScalarTower ℚ WeilRep.K Ω]
    (p : Polynomial ℚ) :
    evalPolyAt ((algebraMap WeilRep.K Ω) WeilRep.ζ) p =
      (algebraMap WeilRep.K Ω) (evalPolyAt WeilRep.ζ p) :=
  Polynomial.aeval_algHom_apply
    (IsScalarTower.toAlgHom ℚ WeilRep.K Ω) WeilRep.ζ p

/-- Evaluation at the image of `ζ` agrees entrywise with scalar extension of
the matrix already evaluated over `WeilRep.K`. -/
theorem evalMatrixAt_extension_eq_map_evalMatrixK
    (Ω : Type*) [CommRing Ω] [Algebra ℚ Ω] [Algebra WeilRep.K Ω]
    [IsScalarTower ℚ WeilRep.K Ω]
    {m n : Type*} (M : Matrix m n (Polynomial ℚ)) :
    evalMatrixAt ((algebraMap WeilRep.K Ω) WeilRep.ζ) M =
      (evalMatrixK M).map (algebraMap WeilRep.K Ω) := by
  ext i j
  exact evalPolyAt_extension_eq_map_evalPolyAt Ω (M i j)

/-- The rotation restriction after entrywise base change from `WeilRep.K`. -/
theorem map_evalMatrixK_R_mul_B_eq_B_mul_RM
    (Ω : Type*) [CommRing Ω] [Algebra ℚ Ω] [Algebra WeilRep.K Ω]
    [IsScalarTower ℚ WeilRep.K Ω] :
    (evalMatrixK RFull.R_poly).map (algebraMap WeilRep.K Ω) *
        (evalMatrixK B_poly).map (algebraMap WeilRep.K Ω) =
      (evalMatrixK B_poly).map (algebraMap WeilRep.K Ω) *
        (evalMatrixK RM_poly).map (algebraMap WeilRep.K Ω) := by
  rw [← evalMatrixAt_extension_eq_map_evalMatrixK Ω RFull.R_poly,
    ← evalMatrixAt_extension_eq_map_evalMatrixK Ω B_poly,
    ← evalMatrixAt_extension_eq_map_evalMatrixK Ω RM_poly]
  exact evalMatrixAt_R_mul_B_eq_B_mul_RM _

/-- The reflection restriction after entrywise base change from
`WeilRep.K`. -/
theorem map_evalMatrixK_F_mul_B_eq_B_mul_SM
    (Ω : Type*) [CommRing Ω] [Algebra ℚ Ω] [Algebra WeilRep.K Ω]
    [IsScalarTower ℚ WeilRep.K Ω] :
    (evalMatrixK FFull.F_poly).map (algebraMap WeilRep.K Ω) *
        (evalMatrixK B_poly).map (algebraMap WeilRep.K Ω) =
      (evalMatrixK B_poly).map (algebraMap WeilRep.K Ω) *
        (evalMatrixK SM_poly).map (algebraMap WeilRep.K Ω) := by
  rw [← evalMatrixAt_extension_eq_map_evalMatrixK Ω FFull.F_poly,
    ← evalMatrixAt_extension_eq_map_evalMatrixK Ω B_poly,
    ← evalMatrixAt_extension_eq_map_evalMatrixK Ω SM_poly]
  exact evalMatrixAt_F_mul_B_eq_B_mul_SM _

end V14Formalization.D12PolynomialEvaluation
