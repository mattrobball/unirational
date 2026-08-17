/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12U6PolynomialSeal
public import Mathlib.Algebra.BigOperators.Fin
public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.Algebra.Polynomial.Roots

/-!
# Evaluation lemmas for plus Segre identities

Polynomial reduction modulo `Φ₁₁` and the cyclotomic evaluation map.
-/

noncomputable section

open Polynomial Matrix

namespace V14Formalization.D12SigmaPlusSegreCore

open GeometricV14Carrier D12PolynomialData D12PolynomialEvaluation
open D12U6PolynomialSeal

theorem C_eq_smul_one (a : ℚ) : C a = a • (1 : Polynomial ℚ) := by
  rw [Polynomial.smul_eq_C_mul, mul_one]

theorem smul_one_mul (a : ℚ) (p : Polynomial ℚ) :
    (a • (1 : Polynomial ℚ)) * p = a • p := by
  rw [smul_mul_assoc, one_mul]

theorem mul_one_smul (a : ℚ) (p : Polynomial ℚ) :
    p * (a • (1 : Polynomial ℚ)) = a • p := by
  rw [mul_smul_comm, mul_one]

theorem ofPoly_Phi11_mul (q : Polynomial ℚ) :
    ofPoly (Phi11 * q) = 0 := by
  simp [ofPoly, map_mul, evalPhi11_ζ]

public theorem ofPoly_add_Phi11 (p q : Polynomial ℚ) :
    ofPoly (p + Phi11 * q) = ofPoly p := by
  rw [ofPoly_add, ofPoly_Phi11_mul, add_zero]

public theorem ofLadj_add_Phi11 (re im qre qim : Polynomial ℚ) :
    ofLadj (re + Phi11 * qre) (im + Phi11 * qim) = ofLadj re im := by
  simp [ofLadj, ofPoly_add_Phi11]

public theorem ofLadj_add3 (a b c d e f : Polynomial ℚ) :
    ofLadj a b + ofLadj c d + ofLadj e f = ofLadj (a + c + e) (b + d + f) := by
  simp [ofLadj_add, add_assoc]

theorem ofLadj_C (n : ℚ) : ofLadj (C n) 0 = algebraMap ℚ Ki n := by
  simp [ofLadj, ofPoly, evalPolyAt, map_zero]

public theorem ofLadj_three : ofLadj (C (3 : ℚ)) 0 = (3 : Ki) := by
  rw [ofLadj_C]
  norm_cast

public theorem ofLadj_two : ofLadj (C (2 : ℚ)) 0 = (2 : Ki) := by
  rw [ofLadj_C]
  norm_cast

public theorem ofLadj_neg (a b : Polynomial ℚ) :
    -ofLadj a b = ofLadj (-a) (-b) := by
  simp [ofLadj, ofPoly_neg, map_neg]
  ring

public theorem ofLadj_sub (a b c d : Polynomial ℚ) :
    ofLadj a b - ofLadj c d = ofLadj (a - c) (b - d) := by
  rw [sub_eq_add_neg, ofLadj_neg, ofLadj_add]
  simp [sub_eq_add_neg]

public theorem ofLadj_add4
    (r0 i0 r1 i1 r2 i2 r3 i3 : Polynomial ℚ) :
    ofLadj r0 i0 + ofLadj r1 i1 + ofLadj r2 i2 + ofLadj r3 i3 =
      ofLadj (r0 + r1 + r2 + r3) (i0 + i1 + i2 + i3) := by
  simp [ofLadj_add, add_assoc]

public theorem ofLadj_add5
    (r0 i0 r1 i1 r2 i2 r3 i3 r4 i4 : Polynomial ℚ) :
    ofLadj r0 i0 + ofLadj r1 i1 + ofLadj r2 i2 + ofLadj r3 i3 + ofLadj r4 i4 =
      ofLadj (r0 + r1 + r2 + r3 + r4) (i0 + i1 + i2 + i3 + i4) := by
  simp [ofLadj_add, add_assoc]

theorem ofLadj_add7
    (r0 i0 r1 i1 r2 i2 r3 i3 r4 i4 r5 i5 r6 i6 : Polynomial ℚ) :
    ofLadj r0 i0 + ofLadj r1 i1 + ofLadj r2 i2 + ofLadj r3 i3 +
      ofLadj r4 i4 + ofLadj r5 i5 + ofLadj r6 i6 =
      ofLadj (r0 + r1 + r2 + r3 + r4 + r5 + r6)
        (i0 + i1 + i2 + i3 + i4 + i5 + i6) := by
  simp [ofLadj_add, add_assoc]

theorem ofLadj_add8
    (r0 i0 r1 i1 r2 i2 r3 i3 r4 i4 r5 i5 r6 i6 r7 i7 : Polynomial ℚ) :
    ofLadj r0 i0 + ofLadj r1 i1 + ofLadj r2 i2 + ofLadj r3 i3 +
      ofLadj r4 i4 + ofLadj r5 i5 + ofLadj r6 i6 + ofLadj r7 i7 =
      ofLadj (r0 + r1 + r2 + r3 + r4 + r5 + r6 + r7)
        (i0 + i1 + i2 + i3 + i4 + i5 + i6 + i7) := by
  simp [ofLadj_add, add_assoc]

public theorem ofLadj_add6
    (r0 i0 r1 i1 r2 i2 r3 i3 r4 i4 r5 i5 : Polynomial ℚ) :
    ofLadj r0 i0 + ofLadj r1 i1 + ofLadj r2 i2 + ofLadj r3 i3 +
      ofLadj r4 i4 + ofLadj r5 i5 =
      ofLadj (r0 + r1 + r2 + r3 + r4 + r5)
        (i0 + i1 + i2 + i3 + i4 + i5) := by
  simp [ofLadj_add, add_assoc]

public theorem ofLadj_add9
    (r0 i0 r1 i1 r2 i2 r3 i3 r4 i4 r5 i5 r6 i6 r7 i7 r8 i8 : Polynomial ℚ) :
    ofLadj r0 i0 + ofLadj r1 i1 + ofLadj r2 i2 + ofLadj r3 i3 + ofLadj r4 i4 +
      ofLadj r5 i5 + ofLadj r6 i6 + ofLadj r7 i7 + ofLadj r8 i8 =
      ofLadj (r0 + r1 + r2 + r3 + r4 + r5 + r6 + r7 + r8)
        (i0 + i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8) := by
  simp [ofLadj_add, add_assoc]

public theorem ofLadj_add12
    (r0 i0 r1 i1 r2 i2 r3 i3 r4 i4 r5 i5 r6 i6 r7 i7 r8 i8
      r9 i9 r10 i10 r11 i11 : Polynomial ℚ) :
    ofLadj r0 i0 + ofLadj r1 i1 + ofLadj r2 i2 + ofLadj r3 i3 + ofLadj r4 i4 +
      ofLadj r5 i5 + ofLadj r6 i6 + ofLadj r7 i7 + ofLadj r8 i8 +
      ofLadj r9 i9 + ofLadj r10 i10 + ofLadj r11 i11 =
      ofLadj (r0 + r1 + r2 + r3 + r4 + r5 + r6 + r7 + r8 + r9 + r10 + r11)
        (i0 + i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11) := by
  simp [ofLadj_add, add_assoc]

public theorem ofLadj_add15
    (r0 i0 r1 i1 r2 i2 r3 i3 r4 i4 r5 i5 r6 i6 r7 i7 r8 i8
      r9 i9 r10 i10 r11 i11 r12 i12 r13 i13 r14 i14 : Polynomial ℚ) :
    ofLadj r0 i0 + ofLadj r1 i1 + ofLadj r2 i2 + ofLadj r3 i3 + ofLadj r4 i4 +
      ofLadj r5 i5 + ofLadj r6 i6 + ofLadj r7 i7 + ofLadj r8 i8 +
      ofLadj r9 i9 + ofLadj r10 i10 + ofLadj r11 i11 + ofLadj r12 i12 +
      ofLadj r13 i13 + ofLadj r14 i14 =
      ofLadj (r0 + r1 + r2 + r3 + r4 + r5 + r6 + r7 + r8 + r9 + r10 + r11 +
          r12 + r13 + r14)
        (i0 + i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 +
          i12 + i13 + i14) := by
  simp [ofLadj_add, add_assoc]

public theorem ofLadj_add18
    (r0 i0 r1 i1 r2 i2 r3 i3 r4 i4 r5 i5 r6 i6 r7 i7 r8 i8
      r9 i9 r10 i10 r11 i11 r12 i12 r13 i13 r14 i14 r15 i15 r16 i16 r17 i17 :
      Polynomial ℚ) :
    ofLadj r0 i0 + ofLadj r1 i1 + ofLadj r2 i2 + ofLadj r3 i3 + ofLadj r4 i4 +
      ofLadj r5 i5 + ofLadj r6 i6 + ofLadj r7 i7 + ofLadj r8 i8 +
      ofLadj r9 i9 + ofLadj r10 i10 + ofLadj r11 i11 + ofLadj r12 i12 +
      ofLadj r13 i13 + ofLadj r14 i14 + ofLadj r15 i15 + ofLadj r16 i16 +
      ofLadj r17 i17 =
      ofLadj (r0 + r1 + r2 + r3 + r4 + r5 + r6 + r7 + r8 + r9 + r10 + r11 +
          r12 + r13 + r14 + r15 + r16 + r17)
        (i0 + i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 +
          i12 + i13 + i14 + i15 + i16 + i17) := by
  simp [ofLadj_add, add_assoc]

public theorem ofLadj_ofPoly (p : Polynomial ℚ) :
    ofLadj p 0 = algebraMap k Ki (ofPoly p) := by
  simp [ofLadj, ofPoly, map_zero]

theorem ofPoly_sum {ι : Type*} [Fintype ι] (p : ι → Polynomial ℚ) :
    ofPoly (∑ i, p i) = ∑ i, ofPoly (p i) :=
  map_sum (evalPolyAt WeilRep.ζ) p Finset.univ

theorem ofLadj_sum_fin15 (re im : Fin 15 → Polynomial ℚ) :
    ∑ q : Fin 15, ofLadj (re q) (im q) =
      ofLadj (∑ q : Fin 15, re q) (∑ q : Fin 15, im q) := by
  simp only [ofLadj, ofPoly]
  rw [Finset.sum_add_distrib, ← Finset.sum_mul]
  simp [map_sum]

public theorem sum_fin15 (f : Fin 15 → Ki) :
    ∑ q : Fin 15, f q =
      f 0 + f 1 + f 2 + f 3 + f 4 + f 5 + f 6 + f 7 + f 8 +
        f 9 + f 10 + f 11 + f 12 + f 13 + f 14 := by
  simp [Fin.sum_univ_succ, add_assoc]

public theorem Phi11_expand :
    (Phi11 : Polynomial ℚ) =
      1 + X + X ^ 2 + X ^ 3 + X ^ 4 + X ^ 5 + X ^ 6 + X ^ 7 + X ^ 8 + X ^ 9 + X ^ 10 := by
  simp [Phi11, Finset.sum_range_succ, Finset.sum_range_zero]

public theorem mul_apply_fin9
    (A : Matrix (Fin 6) (Fin 9) Ki) (B : Matrix (Fin 9) (Fin 6) Ki)
    (i : Fin 6) (j : Fin 6) :
    (A * B) i j =
      A i 0 * B 0 j + A i 1 * B 1 j + A i 2 * B 2 j + A i 3 * B 3 j +
        A i 4 * B 4 j + A i 5 * B 5 j + A i 6 * B 6 j + A i 7 * B 7 j +
          A i 8 * B 8 j := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, add_assoc]

public theorem mul_apply_fin9_N
    (A : Matrix (Fin 3) (Fin 9) Ki) (B : Matrix (Fin 9) (Fin 6) Ki)
    (i : Fin 3) (j : Fin 6) :
    (A * B) i j =
      A i 0 * B 0 j + A i 1 * B 1 j + A i 2 * B 2 j + A i 3 * B 3 j +
        A i 4 * B 4 j + A i 5 * B 5 j + A i 6 * B 6 j + A i 7 * B 7 j +
          A i 8 * B 8 j := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, add_assoc]

public theorem mul_apply_fin9_LK
    (A : Matrix (Fin 6) (Fin 9) Ki) (B : Matrix (Fin 9) (Fin 3) Ki)
    (i : Fin 6) (j : Fin 3) :
    (A * B) i j =
      A i 0 * B 0 j + A i 1 * B 1 j + A i 2 * B 2 j + A i 3 * B 3 j +
        A i 4 * B 4 j + A i 5 * B 5 j + A i 6 * B 6 j + A i 7 * B 7 j +
          A i 8 * B 8 j := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, add_assoc]

public theorem mul_apply_fin9_NK
    (A : Matrix (Fin 3) (Fin 9) Ki) (B : Matrix (Fin 9) (Fin 3) Ki)
    (i : Fin 3) (j : Fin 3) :
    (A * B) i j =
      A i 0 * B 0 j + A i 1 * B 1 j + A i 2 * B 2 j + A i 3 * B 3 j +
        A i 4 * B 4 j + A i 5 * B 5 j + A i 6 * B 6 j + A i 7 * B 7 j +
          A i 8 * B 8 j := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, add_assoc]

theorem ofLadj_add2 (a b c d : Polynomial ℚ) :
    ofLadj a b + ofLadj c d = ofLadj (a + c) (b + d) :=
  ofLadj_add a b c d

theorem ofLadj_sum_fin9 (re im : Fin 9 → Polynomial ℚ) :
    ∑ s : Fin 9, ofLadj (re s) (im s) =
      ofLadj (∑ s : Fin 9, re s) (∑ s : Fin 9, im s) := by
  simp only [ofLadj, ofPoly]
  rw [Finset.sum_add_distrib, ← Finset.sum_mul]
  simp [map_sum]

public theorem sum_fin9 (f : Fin 9 → Ki) :
    ∑ s : Fin 9, f s =
      f 0 + f 1 + f 2 + f 3 + f 4 + f 5 + f 6 + f 7 + f 8 := by
  simp [Fin.sum_univ_succ, add_assoc]

end V14Formalization.D12SigmaPlusSegreCore
