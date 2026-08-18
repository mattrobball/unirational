/-
Auto-generated Fplus / det(bilinearN) coefficient identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreFplusZ

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

theorem DC222_0_mul : (1 : Ki) = ofLadj (1 : Polynomial ℚ) 0 :=
  ofLadj_one.symm

@[expose] public def detCoeff_222 : Ki :=
  (1 : Ki)

theorem detCoeff_222_sum :
    detCoeff_222 = ofLadj ((1 : Polynomial ℚ)) ((0 : Polynomial ℚ)) := by
  simp only [detCoeff_222, DC222_0_mul]

def DC222_qre : Polynomial ℚ := interpQ 1 []
def DC222_qim : Polynomial ℚ := interpQ 1 []

theorem detCoeff_222_sum_poly_re :
    (1 : Polynomial ℚ) = Fplus_re_222 + Phi11 * DC222_qre := by
  rw [phi11_interpQ]
  simp only [z_Fplus_re_222, DC222_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem detCoeff_222_sum_poly_im :
    (0 : Polynomial ℚ) = Fplus_im_222 + Phi11 * DC222_qim := by
  rw [phi11_interpQ]
  simp only [z_Fplus_im_222, DC222_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

public theorem detCoeff_222_eq :
    detCoeff_222 = ofLadj Fplus_re_222 Fplus_im_222 := by
  rw [detCoeff_222_sum, detCoeff_222_sum_poly_re,
    detCoeff_222_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
