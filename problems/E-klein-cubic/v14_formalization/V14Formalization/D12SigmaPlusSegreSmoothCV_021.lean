/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData
public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreFplusZ

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

def CV_021_0_pre : Polynomial ℚ := interpQ 8639957931 [501106510253, 496047878465200, 939699255905257, 1617918268633676, 2640144822921930, 3406488240244165, 4152901862216485, 4754488333852562, 4834323551793775, 5003069318516149, 5131854448681750, 5179378921370544, 4635806570216550, 4063370062610892, 3216405283160099, 2039185281961913, 1180772360051769, 434358738079449, -75158228968719]
def CV_021_0_pim : Polynomial ℚ := interpQ 8639957931 [-457967421138375, -915934842276750, -1237583624947612, -1738131241659359, -1818516418606241, -1617348303861924, -1417899710898601, -844344624591354, -432929076224553, -408797723873784, -297106689104680, 324362088003660, 945830865112000, 1379170682551966, 1903849651614482, 1913507054466964, 1568838084923350, 1199199263567745, 482143322461201]
theorem CV_021_0_pre_eq :
    CV_0_re_001 * Fplus_dU_re_020 - CV_0_im_001 * Fplus_dU_im_020 = CV_021_0_pre := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_021_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_021_0_pim_eq :
    CV_0_re_001 * Fplus_dU_im_020 + CV_0_im_001 * Fplus_dU_re_020 = CV_021_0_pim := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_021_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_021_0_mul :
    CV_0_c_001 * Fplus_dU_c_020 = ofLadj CV_021_0_pre CV_021_0_pim := by
  rw [CV_0_c_001_def, Fplus_dU_c_020_def, ofLadj_mul, CV_021_0_pre_eq, CV_021_0_pim_eq]

def CV_021_1_pre : Polynomial ℚ := interpQ 8639957931 [-47716463512434, -467437660743912, -813323009062731, -1314189208102191, -1985895117502434, -2257618677249573, -2589384953443893, -2972124998312328, -3042689230948950, -3280537739417343, -3461954059677024, -3482075849357634, -2994516398933112, -2467214730354612, -1728500022846759, -838401763446246, -436782027362265, -105015751167945, 147828117363648]
def CV_021_1_pim : Polynomial ℚ := interpQ 8639957931 [268290306208728, 536580612417456, 617660339785779, 801893168624958, 602821922461119, 271760998934433, 183674245891395, -153500038710513, -409292121674526, -443355167386647, -600696636521355, -1099452185006388, -1598207733491421, -1836628929994452, -2054924804545752, -1756196216727000, -1222943553786567, -894815448634581, -355449424618926]
theorem CV_021_1_pre_eq :
    CV_1_re_001 * Fplus_dV_re_020 - CV_1_im_001 * Fplus_dV_im_020 = CV_021_1_pre := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_021_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_021_1_pim_eq :
    CV_1_re_001 * Fplus_dV_im_020 + CV_1_im_001 * Fplus_dV_re_020 = CV_021_1_pim := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_021_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_021_1_mul :
    CV_1_c_001 * Fplus_dV_c_020 = ofLadj CV_021_1_pre CV_021_1_pim := by
  rw [CV_1_c_001_def, Fplus_dV_c_020_def, ofLadj_mul, CV_021_1_pre_eq, CV_021_1_pim_eq]

def CV_021_2_pre : Polynomial ℚ := interpQ 8639957931 [-64625512530368, -907968205750536, -1800780894891525, -2952227086681725, -4402974284367840, -5242882113991029, -5932228610256434, -6344583543814207, -6045908594227892, -5977512546003077, -5925433733365001, -5841185418316496, -5017465527614465, -4176731651111552, -3093681507546167, -1705649426026086, -903155615932730, -213809119667325, 235959833420281]
def CV_021_2_pim : Polynomial ℚ := interpQ 8639957931 [618123220772540, 1236246441545080, 1449922622951497, 1741899431707755, 1335177533848365, 516390029102160, -151476683003983, -1151875878053811, -1736068711878652, -1726173915168358, -1681051694617908, -2232883239868246, -2784714785118584, -2953268745974551, -3235350758020515, -2857381261419878, -2096539624275375, -1497893760014214, -555440432566088]
theorem CV_021_2_pre_eq :
    CV_2_re_001 * Fplus_dW_re_020 - CV_2_im_001 * Fplus_dW_im_020 = CV_021_2_pre := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_021_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_021_2_pim_eq :
    CV_2_re_001 * Fplus_dW_im_020 + CV_2_im_001 * Fplus_dW_re_020 = CV_021_2_pim := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_021_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_021_2_mul :
    CV_2_c_001 * Fplus_dW_c_020 = ofLadj CV_021_2_pre CV_021_2_pim := by
  rw [CV_2_c_001_def, Fplus_dW_c_020_def, ofLadj_mul, CV_021_2_pre_eq, CV_021_2_pim_eq]

theorem CV_021_3_mul : CV_3_c_011 = ofLadj CV_3_re_011 CV_3_im_011 := CV_3_c_011_def

@[expose] public def CV_coeff_021 : Ki := CV_0_c_001 * Fplus_dU_c_020 + CV_1_c_001 * Fplus_dV_c_020 + CV_2_c_001 * Fplus_dW_c_020 + CV_3_c_011

theorem CV_coeff_021_sum :
    CV_coeff_021 = ofLadj (CV_021_0_pre + CV_021_1_pre + CV_021_2_pre + CV_3_re_011) (CV_021_0_pim + CV_021_1_pim + CV_021_2_pim + CV_3_im_011) := by
  simp only [CV_coeff_021, CV_021_0_mul, CV_021_1_mul, CV_021_2_mul, CV_021_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_021_0_pre CV_021_0_pim CV_021_1_pre CV_021_1_pim CV_021_2_pre CV_021_2_pim CV_3_re_011 CV_3_im_011

def CV_021_qre : Polynomial ℚ := interpQ 8639957931 [-111650998056689, -767706989972559, -795599037475755, -974800071622445, -1100910339722408, -345700624267193, -274699150487405, -193095854571031, 308629721815210]
def CV_021_qim : Polynomial ℚ := interpQ 8639957931 [429118316627031, 429118316627031, -26364660080968, -24301082465252, -686355487271871, -949425330541322, -557135148057542, -764763410357237, -428746534723813]
theorem CV_coeff_021_poly_re :
    CV_021_0_pre + CV_021_1_pre + CV_021_2_pre + CV_3_re_011 = (0 : Polynomial ℚ) + Phi11 * CV_021_qre := by
  rw [phi11_interpQ]
  simp only [CV_021_0_pre, CV_021_1_pre, CV_021_2_pre, CV_3_re_011_def, CV_021_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_021_poly_im :
    CV_021_0_pim + CV_021_1_pim + CV_021_2_pim + CV_3_im_011 = (0 : Polynomial ℚ) + Phi11 * CV_021_qim := by
  rw [phi11_interpQ]
  simp only [CV_021_0_pim, CV_021_1_pim, CV_021_2_pim, CV_3_im_011_def, CV_021_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_021_eq :
    CV_coeff_021 = (0 : Ki) := by
  rw [CV_coeff_021_sum, CV_coeff_021_poly_re,
    CV_coeff_021_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
