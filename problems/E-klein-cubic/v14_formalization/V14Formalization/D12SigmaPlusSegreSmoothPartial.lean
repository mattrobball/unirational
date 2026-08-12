/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12SigmaPlusSegreCore
import Mathlib.Algebra.MvPolynomial.PDeriv

noncomputable section

open MvPolynomial

namespace V14Formalization.D12SigmaPlusSegreCore

abbrev c000 : Ki := ofLadj Fplus_re_000 Fplus_im_000
abbrev c001 : Ki := ofLadj Fplus_re_001 Fplus_im_001
abbrev c002 : Ki := ofLadj Fplus_re_002 Fplus_im_002
abbrev c011 : Ki := ofLadj Fplus_re_011 Fplus_im_011
abbrev c012 : Ki := ofLadj Fplus_re_012 Fplus_im_012
abbrev c022 : Ki := ofLadj Fplus_re_022 Fplus_im_022
abbrev c111 : Ki := ofLadj Fplus_re_111 Fplus_im_111
abbrev c112 : Ki := ofLadj Fplus_re_112 Fplus_im_112
abbrev c122 : Ki := ofLadj Fplus_re_122 Fplus_im_122
abbrev c222 : Ki := ofLadj Fplus_re_222 Fplus_im_222

theorem eval_Fplus_explicit (r : Fin 3 → Ki) :
    eval r Fplus =
      c000 * r 0 ^ 3 + c001 * (r 0 ^ 2 * r 1) + c002 * (r 0 ^ 2 * r 2) +
        c011 * (r 0 * r 1 ^ 2) + c012 * (r 0 * r 1 * r 2) +
          c022 * (r 0 * r 2 ^ 2) + c111 * r 1 ^ 3 + c112 * (r 1 ^ 2 * r 2) +
            c122 * (r 1 * r 2 ^ 2) + c222 * r 2 ^ 3 := by
  unfold Fplus
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_pderiv0_chartU (v w : Ki) :
    eval ![1, v, w] (pderiv 0 Fplus) =
      3 * c000 + 2 * c001 * v + 2 * c002 * w + c011 * v ^ 2 +
        c012 * v * w + c022 * w ^ 2 := by
  unfold Fplus
  simp [map_add, pderiv_C_mul, pderiv_mul, pderiv_X, pderiv_C, pderiv_pow,
    eval_add, eval_mul, eval_C, eval_X, eval_pow, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.head_cons]
  ring

theorem eval_pderiv1_chartU (v w : Ki) :
    eval ![1, v, w] (pderiv 1 Fplus) =
      c001 + 2 * c011 * v + c012 * w + 3 * c111 * v ^ 2 +
        2 * c112 * v * w + c122 * w ^ 2 := by
  unfold Fplus
  simp [map_add, pderiv_C_mul, pderiv_mul, pderiv_X, pderiv_C, pderiv_pow,
    eval_add, eval_mul, eval_C, eval_X, eval_pow, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.head_cons]
  ring

theorem eval_pderiv2_chartU (v w : Ki) :
    eval ![1, v, w] (pderiv 2 Fplus) =
      c002 + c012 * v + 2 * c022 * w + c112 * v ^ 2 +
        2 * c122 * v * w + 3 * c222 * w ^ 2 := by
  unfold Fplus
  simp [map_add, pderiv_C_mul, pderiv_mul, pderiv_X, pderiv_C, pderiv_pow,
    eval_add, eval_mul, eval_C, eval_X, eval_pow, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.head_cons]
  ring

end V14Formalization.D12SigmaPlusSegreCore
