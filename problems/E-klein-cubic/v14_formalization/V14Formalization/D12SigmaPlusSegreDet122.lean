/-
Auto-generated Fplus / det(bilinearN) coefficient identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

theorem DC122_0_mul :
    N_entry_0_3 = ofLadj N_re_0_3 N_im_0_3 := rfl

theorem DC122_1_mul :
    N_entry_1_4 = ofLadj N_re_1_4 N_im_1_4 := rfl

theorem DC122_2_mul :
    N_entry_2_5 = ofLadj N_re_2_5 N_im_2_5 := rfl

@[expose] public def detCoeff_122 : Ki :=
  N_entry_0_3 + N_entry_1_4 + N_entry_2_5

theorem detCoeff_122_sum :
    detCoeff_122 = ofLadj (N_re_0_3 + N_re_1_4 + N_re_2_5) (N_im_0_3 + N_im_1_4 + N_im_2_5) := by
  simp only [detCoeff_122, DC122_0_mul, DC122_1_mul, DC122_2_mul]
  simpa [add_assoc] using ofLadj_add3 N_re_0_3 N_im_0_3 N_re_1_4 N_im_1_4 N_re_2_5 N_im_2_5

def DC122_qre : Polynomial ℚ := (0 : Polynomial ℚ)
def DC122_qim : Polynomial ℚ := (0 : Polynomial ℚ)

theorem detCoeff_122_sum_poly_re :
    N_re_0_3 + N_re_1_4 + N_re_2_5 = Fplus_re_122 + Phi11 * DC122_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [N_re_0_3, N_re_1_4, N_re_2_5, Fplus_re_122, DC122_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring

theorem detCoeff_122_sum_poly_im :
    N_im_0_3 + N_im_1_4 + N_im_2_5 = Fplus_im_122 + Phi11 * DC122_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [N_im_0_3, N_im_1_4, N_im_2_5, Fplus_im_122, DC122_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring

public theorem detCoeff_122_eq :
    detCoeff_122 = ofLadj Fplus_re_122 Fplus_im_122 := by
  rw [detCoeff_122_sum, detCoeff_122_sum_poly_re,
    detCoeff_122_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
