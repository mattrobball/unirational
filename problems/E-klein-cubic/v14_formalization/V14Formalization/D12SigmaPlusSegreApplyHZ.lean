/- Auto-generated integer-reflection bridges. DO NOT HAND-EDIT. -/
module

public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreCore

noncomputable section
open Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open V14Formalization.D12PolyZReflection

public theorem z_H_im_0_0 : H_im_0_0 = interpQ 1 [0, 0, 0, 4, 0, 0, 0, 0, -4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_0_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_0_1 : H_im_0_1 = interpQ 1 [2, 4, 2, 0, 0, 2, 2, 4, 4, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_0_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_0_2 : H_im_0_2 = interpQ 1 [4, 8, 6, 10, 4, 8, 0, 4, -2, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_0_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_0_3 : H_im_0_3 = interpQ 1 [-6, -12, -14, -12, -10, -8, -4, -2, 0, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_0_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_0_4 : H_im_0_4 = interpQ 1 [0, 0, -2, -4, 2, 0, 0, -2, 4, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_0_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_0_5 : H_im_0_5 = interpQ 1 [0, 0, -4, -4, -4, 0, 0, 4, 4, 4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_0_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_1_0 : H_im_1_0 = interpQ 1 [-2, -4, -6, -8, -4, -3, -1, 0, 4, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_1_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_1_1 : H_im_1_1 = interpQ 1 [0, 0, 1, 2, 0, 0, 0, 0, -2, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_1_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_1_2 : H_im_1_2 = interpQ 1 [2, 4, 2, 5, 1, 4, 0, 3, -1, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_1_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_1_3 : H_im_1_3 = interpQ 1 [0, 0, -1, -3, 0, 0, 0, 0, 3, 1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_1_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_1_4 : H_im_1_4 = interpQ 1 [-1, -2, 2, 0, 3, -4, 2, -5, -2, -4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_1_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_1_5 : H_im_1_5 = interpQ 1 [2, 4, 6, 8, 4, 4, 0, 0, -4, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_1_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_2_0 : H_im_2_0 = interpQ 1 [2, 4, 6, 6, 4, 3, 1, 0, -2, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_2_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_2_1 : H_im_2_1 = interpQ 1 [-1, -2, -2, -2, 0, -1, -1, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_2_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_2_2 : H_im_2_2 = interpQ 1 [-1, -2, 1, -1, 3, -4, 2, -5, -1, -3] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_2_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_2_3 : H_im_2_3 = interpQ 1 [0, 0, -4, -2, -6, 1, -1, 6, 2, 4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_2_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_2_4 : H_im_2_4 = interpQ 1 [2, 4, 5, 6, 3, 5, -1, 1, -2, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_2_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_2_5 : H_im_2_5 = interpQ 1 [-2, -4, -4, -6, -2, -4, 0, -2, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_2_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_3_0 : H_im_3_0 = interpQ 1 [-2, -4, -6, -8, -4, -3, -1, 0, 4, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_3_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_3_1 : H_im_3_1 = interpQ 1 [0, 0, 1, 2, 0, 0, 0, 0, -2, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_3_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_3_2 : H_im_3_2 = interpQ 1 [2, 4, 2, 5, 1, 4, 0, 3, -1, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_3_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_3_3 : H_im_3_3 = interpQ 1 [0, 0, -1, -3, 0, 0, 0, 0, 3, 1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_3_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_3_4 : H_im_3_4 = interpQ 1 [-1, -2, 2, 0, 3, -4, 2, -5, -2, -4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_3_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_3_5 : H_im_3_5 = interpQ 1 [2, 4, 6, 8, 4, 4, 0, 0, -4, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_3_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_4_0 : H_im_4_0 = interpQ 1 [-5, -10, -12, -14, -11, -9, -1, 1, 4, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_4_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_4_1 : H_im_4_1 = interpQ 1 [0, 0, 1, 3, 2, 1, -1, -2, -3, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_4_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_4_2 : H_im_4_2 = interpQ 1 [0, 0, -1, 1, -1, 2, -2, 1, -1, 1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_4_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_4_3 : H_im_4_3 = interpQ 1 [2, 4, 5, 4, 4, 2, 2, 0, 0, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_4_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_4_4 : H_im_4_4 = interpQ 1 [2, 4, 8, 5, 7, 1, 3, -3, -1, -4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_4_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_4_5 : H_im_4_5 = interpQ 1 [6, 12, 14, 16, 14, 8, 4, -2, -4, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_4_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_5_0 : H_im_5_0 = interpQ 1 [1, 2, 3, 0, 2, 1, 1, 0, 2, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_5_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_5_1 : H_im_5_1 = interpQ 1 [-2, -4, -2, -1, -1, -2, -2, -3, -3, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_5_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_5_2 : H_im_5_2 = interpQ 1 [0, 0, 0, 1, 1, 1, -1, -1, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_5_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_5_3 : H_im_5_3 = interpQ 1 [1, 2, 0, -1, 0, 1, 1, 2, 3, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_5_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_5_4 : H_im_5_4 = interpQ 1 [2, 4, 6, 6, 5, 1, 3, -1, -2, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_5_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_5_5 : H_im_5_5 = interpQ 1 [-2, -4, -2, 0, -2, -2, -2, -2, -4, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_5_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_6_0 : H_im_6_0 = interpQ 1 [2, 4, 6, 6, 4, 3, 1, 0, -2, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_6_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_6_1 : H_im_6_1 = interpQ 1 [-1, -2, -2, -2, 0, -1, -1, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_6_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_6_2 : H_im_6_2 = interpQ 1 [-1, -2, 1, -1, 3, -4, 2, -5, -1, -3] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_6_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_6_3 : H_im_6_3 = interpQ 1 [0, 0, -4, -2, -6, 1, -1, 6, 2, 4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_6_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_6_4 : H_im_6_4 = interpQ 1 [2, 4, 5, 6, 3, 5, -1, 1, -2, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_6_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_6_5 : H_im_6_5 = interpQ 1 [-2, -4, -4, -6, -2, -4, 0, -2, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_6_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_7_0 : H_im_7_0 = interpQ 1 [1, 2, 3, 0, 2, 1, 1, 0, 2, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_7_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_7_1 : H_im_7_1 = interpQ 1 [-2, -4, -2, -1, -1, -2, -2, -3, -3, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_7_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_7_2 : H_im_7_2 = interpQ 1 [0, 0, 0, 1, 1, 1, -1, -1, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_7_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_7_3 : H_im_7_3 = interpQ 1 [1, 2, 0, -1, 0, 1, 1, 2, 3, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_7_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_7_4 : H_im_7_4 = interpQ 1 [2, 4, 6, 6, 5, 1, 3, -1, -2, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_7_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_7_5 : H_im_7_5 = interpQ 1 [-2, -4, -2, 0, -2, -2, -2, -2, -4, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_7_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_8_0 : H_im_8_0 = interpQ 1 [2, 4, 6, 2, 5, 5, -1, -1, 2, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_8_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_8_1 : H_im_8_1 = interpQ 1 [-2, -4, -2, -3, -2, -4, 0, -2, -1, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_8_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_8_2 : H_im_8_2 = interpQ 1 [-3, -6, 2, -6, 3, -8, 2, -9, 0, -8] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_8_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_8_3 : H_im_8_3 = interpQ 1 [2, 4, -2, 4, -3, 6, -2, 7, 0, 6] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_8_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_8_4 : H_im_8_4 = interpQ 1 [3, 6, 1, 9, 2, 5, 1, 4, -3, 5] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_8_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_im_8_5 : H_im_8_5 = interpQ 1 [-2, -4, 0, -6, 0, -4, 0, -4, 2, -4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_im_8_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_0_0 : H_re_0_0 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_0_1 : H_re_0_1 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_0_2 : H_re_0_2 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_0_3 : H_re_0_3 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_0_4 : H_re_0_4 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_0_5 : H_re_0_5 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_1_0 : H_re_1_0 = interpQ 1 [-2, 0, 0, 6, 8, 9, 9, 8, 6] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_1_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_1_1 : H_re_1_1 = interpQ 1 [0, 0, -1, -4, -4, -2, -2, -4, -4, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_1_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_1_2 : H_re_1_2 = interpQ 1 [2, 0, 2, 1, 3, 4, 4, 3, 1, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_1_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_1_3 : H_re_1_3 = interpQ 1 [0, 0, -3, -3, -6, -10, -10, -6, -3, -3] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_1_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_1_4 : H_re_1_4 = interpQ 1 [-5, 0, -4, -4, -9, -8, -8, -9, -4, -4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_1_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_1_5 : H_re_1_5 = interpQ 1 [2, 0, -2, -8, -12, -12, -12, -12, -8, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_1_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_2_0 : H_re_2_0 = interpQ 1 [-2, 0, -4, -4, -4, -9, -9, -4, -4, -4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_2_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_2_1 : H_re_2_1 = interpQ 1 [-1, 0, -2, -2, -2, 1, 1, -2, -2, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_2_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_2_2 : H_re_2_2 = interpQ 1 [-9, 0, -9, -3, -7, -4, -4, -7, -3, -9] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_2_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_2_3 : H_re_2_3 = interpQ 1 [6, 0, 6, 4, 6, 3, 3, 6, 4, 6] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_2_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_2_4 : H_re_2_4 = interpQ 1 [6, 0, 5, -2, -3, -3, -3, -3, -2, 5] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_2_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_2_5 : H_re_2_5 = interpQ 1 [-6, 0, -4, -2, -2, 0, 0, -2, -2, -4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_2_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_3_0 : H_re_3_0 = interpQ 1 [2, 0, 0, -6, -8, -9, -9, -8, -6] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_3_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_3_1 : H_re_3_1 = interpQ 1 [0, 0, 1, 4, 4, 2, 2, 4, 4, 1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_3_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_3_2 : H_re_3_2 = interpQ 1 [-2, 0, -2, -1, -3, -4, -4, -3, -1, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_3_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_3_3 : H_re_3_3 = interpQ 1 [0, 0, 3, 3, 6, 10, 10, 6, 3, 3] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_3_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_3_4 : H_re_3_4 = interpQ 1 [5, 0, 4, 4, 9, 8, 8, 9, 4, 4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_3_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_3_5 : H_re_3_5 = interpQ 1 [-2, 0, 2, 8, 12, 12, 12, 12, 8, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_3_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_4_0 : H_re_4_0 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_4_1 : H_re_4_1 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_4_2 : H_re_4_2 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_4_3 : H_re_4_3 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_4_4 : H_re_4_4 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_4_5 : H_re_4_5 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_5_0 : H_re_5_0 = interpQ 1 [1, 0, 1, -4, -7, -7, -7, -7, -4, 1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_5_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_5_1 : H_re_5_1 = interpQ 1 [0, 0, -2, 0, 1, 1, 1, 1, 0, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_5_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_5_2 : H_re_5_2 = interpQ 1 [-6, 0, -7, -2, -6, -4, -4, -6, -2, -7] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_5_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_5_3 : H_re_5_3 = interpQ 1 [2, 0, 6, 3, 6, 6, 6, 6, 3, 6] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_5_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_5_4 : H_re_5_4 = interpQ 1 [5, 0, 4, -1, 2, -2, -2, 2, -1, 4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_5_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_5_5 : H_re_5_5 = interpQ 1 [-2, 0, -2, 4, 4, 6, 6, 4, 4, -2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_5_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_6_0 : H_re_6_0 = interpQ 1 [2, 0, 4, 4, 4, 9, 9, 4, 4, 4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_6_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_6_1 : H_re_6_1 = interpQ 1 [1, 0, 2, 2, 2, -1, -1, 2, 2, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_6_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_6_2 : H_re_6_2 = interpQ 1 [9, 0, 9, 3, 7, 4, 4, 7, 3, 9] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_6_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_6_3 : H_re_6_3 = interpQ 1 [-6, 0, -6, -4, -6, -3, -3, -6, -4, -6] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_6_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_6_4 : H_re_6_4 = interpQ 1 [-6, 0, -5, 2, 3, 3, 3, 3, 2, -5] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_6_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_6_5 : H_re_6_5 = interpQ 1 [6, 0, 4, 2, 2, 0, 0, 2, 2, 4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_6_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_7_0 : H_re_7_0 = interpQ 1 [-1, 0, -1, 4, 7, 7, 7, 7, 4, -1] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_7_0, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_7_1 : H_re_7_1 = interpQ 1 [0, 0, 2, 0, -1, -1, -1, -1, 0, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_7_1, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_7_2 : H_re_7_2 = interpQ 1 [6, 0, 7, 2, 6, 4, 4, 6, 2, 7] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_7_2, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_7_3 : H_re_7_3 = interpQ 1 [-2, 0, -6, -3, -6, -6, -6, -6, -3, -6] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_7_3, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_7_4 : H_re_7_4 = interpQ 1 [-5, 0, -4, 1, -2, 2, 2, -2, 1, -4] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_7_4, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_7_5 : H_re_7_5 = interpQ 1 [2, 0, 2, -4, -4, -6, -6, -4, -4, 2] := by
  refine Polynomial.funext fun r => ?_
  simp [H_re_7_5, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

public theorem z_H_re_8_0 : H_re_8_0 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_8_1 : H_re_8_1 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_8_2 : H_re_8_2 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_8_3 : H_re_8_3 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_8_4 : H_re_8_4 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

public theorem z_H_re_8_5 : H_re_8_5 = interpQ 1 [] := by
  rw [interpQ_nil]; rfl

end V14Formalization.D12SigmaPlusSegreCore
