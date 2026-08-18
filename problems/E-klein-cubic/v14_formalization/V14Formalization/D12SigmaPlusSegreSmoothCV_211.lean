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

def CV_211_0_pre : Polynomial ℚ := interpQ 8639957931 [-577038152268, 2444790445312, 4307705098019, 7523848361733, 13107867753654, 16768162005558, 20439996768373, 21878433508075, 20195314001818, 18632066596682, 18353633560652, 18040996607676, 15908843115340, 14324361498663, 12671465640085, 7833324777376, 4998532685368, 1326697922553, -937240977045]
def CV_211_0_pim : Polynomial ℚ := interpQ 8639957931 [-2478687572104, -4957375144208, -6220734185581, -8516469543453, -9038328059837, -6151372166650, -4587573443900, 999078053980, 2832797273481, 2968765090466, 2004963310927, 3498173949016, 4991384587105, 5290941848939, 7722645023796, 8251589195176, 6836217923959, 5941700440415, 1826633564505]
theorem CV_211_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_110 - CV_0_im_101 * Fplus_dU_im_110 = CV_211_0_pre := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_211_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_211_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_110 + CV_0_im_101 * Fplus_dU_re_110 = CV_211_0_pim := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_211_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_211_0_mul :
    CV_0_c_101 * Fplus_dU_c_110 = ofLadj CV_211_0_pre CV_211_0_pim := by
  rw [CV_0_c_101_def, Fplus_dU_c_110_def, ofLadj_mul, CV_211_0_pre_eq, CV_211_0_pim_eq]

def CV_211_1_pre : Polynomial ℚ := interpQ 8639957931 [2444305256534, -33145512961550, -59751749303300, -106480808552627, -174269775773627, -225319232264424, -274767027094061, -315687940558655, -319216135068760, -330175053774943, -339431102210078, -344581251710380, -306285589248528, -270423304471643, -212735326516133, -134226109904339, -77172571187181, -27724776357544, 7192054880689]
def CV_211_1_pim : Polynomial ℚ := interpQ 8639957931 [31329769398765, 62659538797530, 83494139882041, 118249665430287, 124024218911997, 109296558148617, 98352675527053, 57519621807987, 31658058516651, 29760321798198, 22439569445619, -20028956837650, -62497483120919, -90652836558009, -127306098824708, -127866824536719, -103954004763804, -81093603789636, -31075391061035]
theorem CV_211_1_pre_eq :
    CV_1_re_101 * Fplus_dV_re_110 - CV_1_im_101 * Fplus_dV_im_110 = CV_211_1_pre := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_211_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_211_1_pim_eq :
    CV_1_re_101 * Fplus_dV_im_110 + CV_1_im_101 * Fplus_dV_re_110 = CV_211_1_pim := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_211_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_211_1_mul :
    CV_1_c_101 * Fplus_dV_c_110 = ofLadj CV_211_1_pre CV_211_1_pim := by
  rw [CV_1_c_101_def, Fplus_dV_c_110_def, ofLadj_mul, CV_211_1_pre_eq, CV_211_1_pim_eq]

def CV_211_2_pre : Polynomial ℚ := interpQ 8639957931 [-7741012130030, -107361291042200, -218273461978638, -358816557222949, -534167603157025, -634497974769929, -715713678808598, -760249535400306, -724314889975274, -710613880738429, -700161388208310, -688495802379798, -592800097166110, -492340418759791, -365498332752325, -202707464808225, -109853529852588, -28637825813919, 23374467435056]
def CV_211_2_pim : Polynomial ℚ := interpQ 8639957931 [72374820721370, 144749641442740, 171526848296544, 202169997993649, 151954017707853, 53142079444857, -25966262989268, -142627552258704, -209456648750415, -207505967178703, -198452637425531, -257543844593450, -316635051761369, -334358928862001, -363051396987394, -318580799998427, -231402108506800, -166111755692949, -61083713194882]
theorem CV_211_2_pre_eq :
    CV_2_re_101 * Fplus_dW_re_110 - CV_2_im_101 * Fplus_dW_im_110 = CV_211_2_pre := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_211_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_211_2_pim_eq :
    CV_2_re_101 * Fplus_dW_im_110 + CV_2_im_101 * Fplus_dW_re_110 = CV_211_2_pim := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_211_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_211_2_mul :
    CV_2_c_101 * Fplus_dW_c_110 = ofLadj CV_211_2_pre CV_211_2_pim := by
  rw [CV_2_c_101_def, Fplus_dW_c_110_def, ofLadj_mul, CV_211_2_pre_eq, CV_211_2_pim_eq]

theorem CV_211_3_mul : CV_3_c_201 = ofLadj CV_3_re_201 CV_3_im_201 := CV_3_c_201_def

@[expose] public def CV_coeff_211 : Ki := CV_0_c_101 * Fplus_dU_c_110 + CV_1_c_101 * Fplus_dV_c_110 + CV_2_c_101 * Fplus_dW_c_110 + CV_3_c_201

theorem CV_coeff_211_sum :
    CV_coeff_211 = ofLadj (CV_211_0_pre + CV_211_1_pre + CV_211_2_pre + CV_3_re_201) (CV_211_0_pim + CV_211_1_pim + CV_211_2_pim + CV_3_im_201) := by
  simp only [CV_coeff_211, CV_211_0_mul, CV_211_1_mul, CV_211_2_mul, CV_211_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_211_0_pre CV_211_0_pim CV_211_1_pre CV_211_1_pim CV_211_2_pre CV_211_2_pim CV_3_re_201 CV_3_im_201

def CV_211_qre : Polynomial ℚ := interpQ 8639957931 [-6202799375234, -131859214183204, -134737481566527, -182877168104398, -236461943693185, -147072681580787, -126991664105491, -84665185587610, 29629281338700]
def CV_211_qim : Polynomial ℚ := interpQ 8639957931 [100066522813099, 100066522813099, 45579673275888, 62914027217235, -44438815448336, -109676139993325, -87256236304475, -150931188350758, -90332470691412]
theorem CV_coeff_211_poly_re :
    CV_211_0_pre + CV_211_1_pre + CV_211_2_pre + CV_3_re_201 = (0 : Polynomial ℚ) + Phi11 * CV_211_qre := by
  rw [phi11_interpQ]
  simp only [CV_211_0_pre, CV_211_1_pre, CV_211_2_pre, CV_3_re_201_def, CV_211_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_211_poly_im :
    CV_211_0_pim + CV_211_1_pim + CV_211_2_pim + CV_3_im_201 = (0 : Polynomial ℚ) + Phi11 * CV_211_qim := by
  rw [phi11_interpQ]
  simp only [CV_211_0_pim, CV_211_1_pim, CV_211_2_pim, CV_3_im_201_def, CV_211_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_211_eq :
    CV_coeff_211 = (0 : Ki) := by
  rw [CV_coeff_211_sum, CV_coeff_211_poly_re,
    CV_coeff_211_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
