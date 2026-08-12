/-
Auto-generated Fplus / det(bilinearN) coefficient identities.
-/
import V14Formalization.D12SigmaPlusSegreEval
import V14Formalization.D12SigmaPlusSegreMul

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

theorem DC222_0_mul : (1 : Ki) = ofLadj (1 : Polynomial ℚ) 0 :=
  ofLadj_one.symm

def detCoeff_222 : Ki :=
  (1 : Ki)

theorem detCoeff_222_sum :
    detCoeff_222 = ofLadj ((1 : Polynomial ℚ)) ((0 : Polynomial ℚ)) := by
  simp only [detCoeff_222, DC222_0_mul]

def DC222_qre : Polynomial ℚ := (0 : Polynomial ℚ)
def DC222_qim : Polynomial ℚ := (0 : Polynomial ℚ)

theorem detCoeff_222_sum_poly_re :
    (1 : Polynomial ℚ) = Fplus_re_222 + Phi11 * DC222_qre := by
  simp [Fplus_re_222, DC222_qre]

theorem detCoeff_222_sum_poly_im :
    (0 : Polynomial ℚ) = Fplus_im_222 + Phi11 * DC222_qim := by
  simp [Fplus_im_222, DC222_qim]

theorem detCoeff_222_eq :
    detCoeff_222 = ofLadj Fplus_re_222 Fplus_im_222 := by
  rw [detCoeff_222_sum, detCoeff_222_sum_poly_re,
    detCoeff_222_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
