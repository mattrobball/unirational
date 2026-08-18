/-
Auto-generated Fplus / det(bilinearN) coefficient identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreApplyN
public import V14Formalization.D12SigmaPlusSegreFplusZ

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

theorem DC022_0_mul :
    N_entry_0_0 = ofLadj N_re_0_0 N_im_0_0 := rfl

theorem DC022_1_mul :
    N_entry_1_1 = ofLadj N_re_1_1 N_im_1_1 := rfl

theorem DC022_2_mul :
    N_entry_2_2 = ofLadj N_re_2_2 N_im_2_2 := rfl

@[expose] public def detCoeff_022 : Ki :=
  N_entry_0_0 + N_entry_1_1 + N_entry_2_2

theorem detCoeff_022_sum :
    detCoeff_022 = ofLadj (N_re_0_0 + N_re_1_1 + N_re_2_2) (N_im_0_0 + N_im_1_1 + N_im_2_2) := by
  simp only [detCoeff_022, DC022_0_mul, DC022_1_mul, DC022_2_mul]
  simpa [add_assoc] using ofLadj_add3 N_re_0_0 N_im_0_0 N_re_1_1 N_im_1_1 N_re_2_2 N_im_2_2

def DC022_qre : Polynomial ℚ := interpQ 1 []
def DC022_qim : Polynomial ℚ := interpQ 1 []

theorem detCoeff_022_sum_poly_re :
    N_re_0_0 + N_re_1_1 + N_re_2_2 = Fplus_re_022 + Phi11 * DC022_qre := by
  rw [phi11_interpQ]
  simp only [z_N_re_0_0, z_N_re_1_1, z_N_re_2_2, z_Fplus_re_022, DC022_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem detCoeff_022_sum_poly_im :
    N_im_0_0 + N_im_1_1 + N_im_2_2 = Fplus_im_022 + Phi11 * DC022_qim := by
  rw [phi11_interpQ]
  simp only [z_N_im_0_0, z_N_im_1_1, z_N_im_2_2, z_Fplus_im_022, DC022_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

public theorem detCoeff_022_eq :
    detCoeff_022 = ofLadj Fplus_re_022 Fplus_im_022 := by
  rw [detCoeff_022_sum, detCoeff_022_sum_poly_re,
    detCoeff_022_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
