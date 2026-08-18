/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12PolynomialCore
public import V14Formalization.D12PolynomialRM
public import V14Formalization.D12PolynomialSM
public import V14Formalization.WeilRep

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
@[expose] public def evalPolyAt {S : Type*} [CommRing S] [Algebra ℚ S] (z : S) :
    Polynomial ℚ →+* S :=
  (aeval z : Polynomial ℚ →ₐ[ℚ] S).toRingHom

/-- Entrywise evaluation of a polynomial matrix. -/
@[expose] public def evalMatrixAt {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {m n : Type*} (M : Matrix m n (Polynomial ℚ)) : Matrix m n S :=
  M.map (evalPolyAt z)

@[simp] public theorem evalMatrixAt_add {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {m n : Type*} (A B : Matrix m n (Polynomial ℚ)) :
    evalMatrixAt z (A + B) = evalMatrixAt z A + evalMatrixAt z B := by
  ext i j
  exact map_add (evalPolyAt z) (A i j) (B i j)

@[simp] public theorem evalMatrixAt_sub {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {m n : Type*} (A B : Matrix m n (Polynomial ℚ)) :
    evalMatrixAt z (A - B) = evalMatrixAt z A - evalMatrixAt z B := by
  ext i j
  exact map_sub (evalPolyAt z) (A i j) (B i j)

@[simp] public theorem evalMatrixAt_zero {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {m n : Type*} :
    evalMatrixAt z (0 : Matrix m n (Polynomial ℚ)) = 0 := by
  ext i j
  exact map_zero (evalPolyAt z)

@[simp] public theorem evalMatrixAt_one {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {n : Type*} [DecidableEq n] :
    evalMatrixAt z (1 : Matrix n n (Polynomial ℚ)) = 1 := by
  exact Matrix.map_one (evalPolyAt z)
    (map_zero (evalPolyAt z)) (map_one (evalPolyAt z))

@[simp] public theorem evalMatrixAt_mul {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) {m n o : Type*} [Fintype n]
    (A : Matrix m n (Polynomial ℚ)) (B : Matrix n o (Polynomial ℚ)) :
    evalMatrixAt z (A * B) = evalMatrixAt z A * evalMatrixAt z B := by
  exact Matrix.map_mul

/-- The sparse generated left inverse remains a left inverse after evaluation. -/
public theorem evalMatrixAt_left_inverse {S : Type*} [CommRing S] [Algebra ℚ S]
    (z : S) :
    evalMatrixAt z L_poly * evalMatrixAt z B_poly = 1 := by
  rw [← evalMatrixAt_mul, L_mul_B_poly, evalMatrixAt_one]

/-- A certified zero matrix entry remains zero after evaluation. -/
public theorem evalMatrixAt_entry_eq_zero_of_entry_eq_zero
    {S : Type*} [CommRing S] [Algebra ℚ S] (z : S)
    {m n : Type*} (M : Matrix m n (Polynomial ℚ)) (i : m) (j : n)
    (h : M i j = 0) : evalMatrixAt z M i j = 0 := by
  simpa [evalMatrixAt] using congrArg (evalPolyAt z) h

/-- Evaluation in the cyclotomic field at its distinguished root. -/
public abbrev evalK : Polynomial ℚ →+* WeilRep.K := evalPolyAt WeilRep.ζ

/-- Matrix evaluation in the cyclotomic field at its distinguished root. -/
public abbrev evalMatrixK {m n : Type*} (M : Matrix m n (Polynomial ℚ)) :
    Matrix m n WeilRep.K :=
  evalMatrixAt WeilRep.ζ M

public theorem evalMatrixK_left_inverse :
    evalMatrixK L_poly * evalMatrixK B_poly = 1 :=
  evalMatrixAt_left_inverse WeilRep.ζ

/-- Evaluation at the image of `ζ` agrees with scalar extension of the
already evaluated polynomial over `WeilRep.K`. -/
public theorem evalPolyAt_extension_eq_map_evalPolyAt
    (Ω : Type*) [CommRing Ω] [Algebra ℚ Ω] [Algebra WeilRep.K Ω]
    [IsScalarTower ℚ WeilRep.K Ω]
    (p : Polynomial ℚ) :
    evalPolyAt ((algebraMap WeilRep.K Ω) WeilRep.ζ) p =
      (algebraMap WeilRep.K Ω) (evalPolyAt WeilRep.ζ p) :=
  Polynomial.aeval_algHom_apply
    (IsScalarTower.toAlgHom ℚ WeilRep.K Ω) WeilRep.ζ p

/-- Evaluation at the image of `ζ` agrees entrywise with scalar extension of
the matrix already evaluated over `WeilRep.K`. -/
public theorem evalMatrixAt_extension_eq_map_evalMatrixK
    (Ω : Type*) [CommRing Ω] [Algebra ℚ Ω] [Algebra WeilRep.K Ω]
    [IsScalarTower ℚ WeilRep.K Ω]
    {m n : Type*} (M : Matrix m n (Polynomial ℚ)) :
    evalMatrixAt ((algebraMap WeilRep.K Ω) WeilRep.ζ) M =
      (evalMatrixK M).map (algebraMap WeilRep.K Ω) := by
  ext i j
  exact evalPolyAt_extension_eq_map_evalPolyAt Ω (M i j)

end V14Formalization.D12PolynomialEvaluation
