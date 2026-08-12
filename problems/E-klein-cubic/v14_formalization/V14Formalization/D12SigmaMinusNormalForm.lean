/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12MatrixCertificate

/-!
# Structural normal form for the four-dimensional sigma carrier

This file contains no numerical packet.  It isolates the small commutative
algebra argument used by the generated minus-carrier certificate: quadratic
forms in four variables are stored in the ten upper-triangular monomials, two
normalized linear equations cut out a projective line, and one quadratic on
that line cuts out the residual degree-two divisor.
-/

noncomputable section

open Matrix
open scoped BigOperators

namespace V14Formalization.D12SigmaMinusNormalForm

universe u

variable {R : Type u} [CommRing R]

/-- The ten degree-two monomials in four variables, in upper-triangular
lexicographic order. -/
def quadMonomials (y : Fin 4 → R) : Fin 10 → R :=
  ![y 0 * y 0, y 0 * y 1, y 0 * y 2, y 0 * y 3,
    y 1 * y 1, y 1 * y 2, y 1 * y 3,
    y 2 * y 2, y 2 * y 3, y 3 * y 3]

/-- Evaluation of a quadratic coefficient vector. -/
def quadValue (Q : Fin 10 → R) (y : Fin 4 → R) : R :=
  dotProduct Q (quadMonomials y)

@[simp] theorem quadValue_add (Q₁ Q₂ : Fin 10 → R) (y : Fin 4 → R) :
    quadValue (Q₁ + Q₂) y = quadValue Q₁ y + quadValue Q₂ y := by
  simp only [quadValue, dotProduct, Pi.add_apply, add_mul,
    Finset.sum_add_distrib]

@[simp] theorem quadValue_sub (Q₁ Q₂ : Fin 10 → R) (y : Fin 4 → R) :
    quadValue (Q₁ - Q₂) y = quadValue Q₁ y - quadValue Q₂ y := by
  simp only [quadValue, dotProduct, Pi.sub_apply, sub_mul,
    Finset.sum_sub_distrib]

/-- Coefficients of the product of two four-variable linear forms. -/
def bilinearCoeffs (a b : Fin 4 → R) : Fin 10 → R :=
  ![a 0 * b 0,
    a 0 * b 1 + a 1 * b 0,
    a 0 * b 2 + a 2 * b 0,
    a 0 * b 3 + a 3 * b 0,
    a 1 * b 1,
    a 1 * b 2 + a 2 * b 1,
    a 1 * b 3 + a 3 * b 1,
    a 2 * b 2,
    a 2 * b 3 + a 3 * b 2,
    a 3 * b 3]

theorem quadValue_bilinearCoeffs (a b y : Fin 4 → R) :
    quadValue (bilinearCoeffs a b) y =
      dotProduct a y * dotProduct b y := by
  simp [quadValue, bilinearCoeffs, quadMonomials, dotProduct,
    Fin.sum_univ_succ]
  ring

/-- Coefficients of a Plücker quadratic after substituting the columns of a
four-parameter ambient matrix. -/
def restrictedPluckerCoeffs
    (B : Matrix (Fin 15) (Fin 4) R) (q : Fin 15) : Fin 10 → R :=
  let d := SchemeGeometry.pluckerRelation q
  bilinearCoeffs (B d.p1) (B d.p2) -
    bilinearCoeffs (B d.p3) (B d.p4) +
      bilinearCoeffs (B d.p5) (B d.p6)

theorem restrictedPluckerCoeffs_map
    {S : Type*} [CommRing S] (f : R →+* S)
    (B : Matrix (Fin 15) (Fin 4) R) (q : Fin 15) :
    restrictedPluckerCoeffs (B.map f) q =
      fun m ↦ f (restrictedPluckerCoeffs B q m) := by
  funext m
  fin_cases m <;> simp [restrictedPluckerCoeffs, bilinearCoeffs]

theorem quadValue_restrictedPluckerCoeffs
    {S : Type*} [Field S] (B : Matrix (Fin 15) (Fin 4) S)
    (q : Fin 15) (y : Fin 4 → S) :
    quadValue (restrictedPluckerCoeffs B q) y =
      D12Certificate.pluckerValue (B.mulVec y) q := by
  simp only [restrictedPluckerCoeffs, quadValue_sub, quadValue_add,
    quadValue_bilinearCoeffs]
  rfl

/-- First normalized linear equation cutting out the emitted projective line. -/
def linearOne (a b : R) (y : Fin 4 → R) : R :=
  y 1 + a * y 2 + b * y 3

/-- Second normalized linear equation cutting out the emitted projective line. -/
def linearTwo (c d : R) (y : Fin 4 → R) : R :=
  y 0 + c * y 2 + d * y 3

/-- The canonical parametrization of the intersection of the two normalized
hyperplanes. -/
def lineParam (a b c d s t : R) : Fin 4 → R :=
  ![-c * s - d * t, -a * s - b * t, s, t]

@[simp] theorem lineParam_two (a b c d s t : R) :
    lineParam a b c d s t 2 = s := rfl

@[simp] theorem lineParam_three (a b c d s t : R) :
    lineParam a b c d s t 3 = t := rfl

theorem lineParam_linearOne (a b c d s t : R) :
    linearOne a b (lineParam a b c d s t) = 0 := by
  simp [linearOne, lineParam]
  ring

theorem lineParam_linearTwo (a b c d s t : R) :
    linearTwo c d (lineParam a b c d s t) = 0 := by
  simp [linearTwo, lineParam]
  ring

theorem eq_lineParam_of_linears_zero
    (a b c d : R) {y : Fin 4 → R}
    (h1 : linearOne a b y = 0) (h2 : linearTwo c d y = 0) :
    y = lineParam a b c d (y 2) (y 3) := by
  funext i
  fin_cases i
  · change y 0 = -c * y 2 - d * y 3
    unfold linearTwo at h2
    linear_combination h2
  · change y 1 = -a * y 2 - b * y 3
    unfold linearOne at h1
    linear_combination h1
  · rfl
  · rfl

/-- The binary quadratic left after restricting the reference Plücker
equation to the emitted projective line. -/
def binaryQuadratic (A B C s t : R) : R :=
  A * s ^ 2 + B * s * t + C * t ^ 2

/-- The three coefficients obtained by restricting a four-variable quadratic
to the normalized line.  Keeping these formulas separate prevents numerical
certificates from expanding the whole binary quadratic in one tactic call. -/
def linePullbackA (Q : Fin 10 → R) (a c : R) : R :=
  Q 0 * c ^ 2 + Q 1 * c * a - Q 2 * c +
    Q 4 * a ^ 2 - Q 5 * a + Q 7

def linePullbackB (Q : Fin 10 → R) (a b c d : R) : R :=
  2 * Q 0 * c * d + Q 1 * (c * b + d * a) - Q 2 * d - Q 3 * c +
    2 * Q 4 * a * b - Q 5 * b - Q 6 * a + Q 8

def linePullbackC (Q : Fin 10 → R) (b d : R) : R :=
  Q 0 * d ^ 2 + Q 1 * d * b - Q 3 * d +
    Q 4 * b ^ 2 - Q 6 * b + Q 9

theorem quadValue_lineParam (Q : Fin 10 → R) (a b c d s t : R) :
    quadValue Q (lineParam a b c d s t) =
      binaryQuadratic (linePullbackA Q a c) (linePullbackB Q a b c d)
        (linePullbackC Q b d) s t := by
  simp [quadValue, quadMonomials, dotProduct, Fin.sum_univ_succ,
    lineParam, binaryQuadratic, linePullbackA, linePullbackB, linePullbackC]
  ring

theorem commonZero_parametric
    (Q : Fin 8 → Fin 10 → R) (a b c d A B C : R)
    {y : Fin 4 → R}
    (hlinear : (∀ q : Fin 8, quadValue (Q q) y = 0) →
      linearOne a b y = 0 ∧ linearTwo c d y = 0)
    (hpullback : ∀ s t,
      quadValue (Q 0) (lineParam a b c d s t) =
        binaryQuadratic A B C s t)
    (hQ : ∀ q : Fin 8, quadValue (Q q) y = 0) :
    y = lineParam a b c d (y 2) (y 3) ∧
      binaryQuadratic A B C (y 2) (y 3) = 0 := by
  obtain ⟨h1, h2⟩ := hlinear hQ
  have hy := eq_lineParam_of_linears_zero a b c d h1 h2
  refine ⟨hy, ?_⟩
  rw [← hpullback, ← hy]
  exact hQ 0

end V14Formalization.D12SigmaMinusNormalForm
