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

def CU_022_0_pre : Polynomial ℚ := interpQ 235794999 [99907330511664, 1355513625193920, 2757779185953712, 4530107909092336, 6745375386653424, 8017220532543544, 9038410815123800, 9601234969122976, 9147871338909368, 8974874985933208, 8842935809506056, 8693943902513824, 7487422184312136, 6217095799979496, 4617763429817032, 2561421337354416, 1383861437036832, 362671154456576, -294438245115136]
def CU_022_0_pim : Polynomial ℚ := interpQ 235794999 [-912879456694192, -1825758913388384, -2165018458703712, -2549921811642256, -1920418206334832, -668758827175704, 332858915481704, 1803040815283744, 2648051969780824, 2623148652185640, 2508645781710496, 3254033999389216, 3999422217067936, 4224178891908120, 4584178927251480, 4027351531862112, 2922662025175232, 2095546971908816, 772334944579024]
theorem CU_022_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_011 - CU_0_im_011 * Fplus_dU_im_011 = CU_022_0_pre := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CU_022_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_011 + CU_0_im_011 * Fplus_dU_re_011 = CU_022_0_pim := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CU_022_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_0_mul :
    CU_0_c_011 * Fplus_dU_c_011 = ofLadj CU_022_0_pre CU_022_0_pim := by
  rw [CU_0_c_011_def, Fplus_dU_c_011_def, ofLadj_mul, CU_022_0_pre_eq, CU_022_0_pim_eq]

def CU_022_1_pre : Polynomial ℚ := interpQ 235794999 [-880953881328, -1919278593207280, -3633866741140656, -6258225541312520, -10212671264298528, -13178155184763496, -16065147570154912, -18393195169688376, -18700727487867528, -19353459126000328, -19851768763284080, -20036570027658208, -17932490170076800, -15719592384859672, -12442501946555008, -7888219644963336, -4566334330266736, -1679341944875320, 292304260426512]
def CU_022_1_pim : Polynomial ℚ := interpQ 235794999 [1772251126114568, 3544502252229136, 4789105639131904, 6726102572647600, 7037982589472032, 6258201073377216, 5488260204739976, 3268231832766400, 1677788267350536, 1583929690935008, 1152042277410256, -1252827216027344, -3657696709464944, -5334187509892464, -7365043019823688, -7402945715570704, -6068416056420480, -4639197401522264, -1864420886493280]
theorem CU_022_1_pre_eq :
    CU_0_re_002 * Fplus_dU_re_020 - CU_0_im_002 * Fplus_dU_im_020 = CU_022_1_pre := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CU_022_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_1_pim_eq :
    CU_0_re_002 * Fplus_dU_im_020 + CU_0_im_002 * Fplus_dU_re_020 = CU_022_1_pim := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CU_022_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_1_mul :
    CU_0_c_002 * Fplus_dU_c_020 = ofLadj CU_022_1_pre CU_022_1_pim := by
  rw [CU_0_c_002_def, Fplus_dU_c_020_def, ofLadj_mul, CU_022_1_pre_eq, CU_022_1_pim_eq]

def CU_022_2_pre : Polynomial ℚ := interpQ 235794999 [-243417696446512, -3391994509484224, -6730213185597216, -11028585558283168, -16447597172717944, -19590586210092208, -22159503167481776, -23703411836853904, -22588290713393104, -22333042425001272, -22138109413383152, -21822153742527936, -18746114903898928, -15602829239404056, -11559705155109936, -6375326995323360, -3371685835793344, -802768878403776, 880487668812600]
def CU_022_2_pim : Polynomial ℚ := interpQ 235794999 [2308370327105360, 4616740654210720, 5415766434079304, 6502022707660168, 4989283958870360, 1925477256318160, -569479205434752, -4303373966287432, -6487730800912520, -6451058380595272, -6282105583051776, -8343085559243344, -10404065535434912, -11034138517760000, -12083722371023616, -10678099708158080, -7831316272997792, -5594112242161584, -2077240748700816]
theorem CU_022_2_pre_eq :
    CU_1_re_011 * Fplus_dV_re_011 - CU_1_im_011 * Fplus_dV_im_011 = CU_022_2_pre := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CU_022_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_2_pim_eq :
    CU_1_re_011 * Fplus_dV_im_011 + CU_1_im_011 * Fplus_dV_re_011 = CU_022_2_pim := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CU_022_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_2_mul :
    CU_1_c_011 * Fplus_dV_c_011 = ofLadj CU_022_2_pre CU_022_2_pim := by
  rw [CU_1_c_011_def, Fplus_dV_c_011_def, ofLadj_mul, CU_022_2_pre_eq, CU_022_2_pim_eq]

def CU_022_3_pre : Polynomial ℚ := interpQ 235794999 [179561242063896, 1740177586985760, 3029704115514072, 4892965125441768, 7392620871244488, 8404928404057536, 9640472109627144, 11064190105436760, 11329087472012616, 12213761907809208, 12889218879616776, 12961454074187808, 11149041292631016, 9184057792295136, 6436122346570848, 3123468674312328, 1627964727451896, 392421021882288, -548100559879944]
def CU_022_3_pim : Polynomial ℚ := interpQ 235794999 [-997830370834152, -1995660741668304, -2298663133573296, -2981972172009336, -2242092770550648, -1010656573640160, -680679846319416, 572193087822768, 1525778780311824, 1652978763695904, 2238276536400024, 4093660921663968, 5949045306927912, 6837345471537024, 7647854493357144, 6536684137051584, 4553365072229496, 3329632449389712, 1324876647335928]
theorem CU_022_3_pre_eq :
    CU_1_re_002 * Fplus_dV_re_020 - CU_1_im_002 * Fplus_dV_im_020 = CU_022_3_pre := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CU_022_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_3_pim_eq :
    CU_1_re_002 * Fplus_dV_im_020 + CU_1_im_002 * Fplus_dV_re_020 = CU_022_3_pim := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CU_022_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_3_mul :
    CU_1_c_002 * Fplus_dV_c_020 = ofLadj CU_022_3_pre CU_022_3_pim := by
  rw [CU_1_c_002_def, Fplus_dV_c_020_def, ofLadj_mul, CU_022_3_pre_eq, CU_022_3_pim_eq]

def CU_022_4_pre : Polynomial ℚ := interpQ 235794999 [-5726837806840, 132125228171936, 282156339792680, 481853587248256, 767293902927824, 992995781997184, 1169165107671952, 1221434865054064, 1103871942014512, 1021261140900968, 958016476993488, 940174906075104, 825891248821552, 739104801108288, 622018354766256, 412596386273888, 232150691443904, 55981365769136, -41544575852352]
def CU_022_4_pim : Polynomial ℚ := interpQ 235794999 [-141814764384392, -283629528768784, -351665083349800, -446247694970328, -437511666188768, -308450338719272, -130536045604896, 114342134202368, 249589893489048, 237760094665864, 183087358861928, 244664505866240, 306241652870552, 319604471647632, 402357284444976, 428219939276672, 369491998672760, 275193868615104, 100649075673424]
theorem CU_022_4_pre_eq :
    CU_2_re_011 * Fplus_dW_re_011 - CU_2_im_011 * Fplus_dW_im_011 = CU_022_4_pre := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CU_022_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_4_pim_eq :
    CU_2_re_011 * Fplus_dW_im_011 + CU_2_im_011 * Fplus_dW_re_011 = CU_022_4_pim := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CU_022_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_4_mul :
    CU_2_c_011 * Fplus_dW_c_011 = ofLadj CU_022_4_pre CU_022_4_pim := by
  rw [CU_2_c_011_def, Fplus_dW_c_011_def, ofLadj_mul, CU_022_4_pre_eq, CU_022_4_pim_eq]

def CU_022_5_pre : Polynomial ℚ := interpQ 235794999 [220915537154144, 3077676654077312, 6106396788261200, 10008349773371616, 14925214465372752, 17776199770566144, 20109101242078904, 21509252588802576, 20496762296525352, 20265178364559432, 20088281858752128, 19801367114015600, 17010605204674816, 14158781576298232, 10488412523153736, 5784398901365264, 3060015064019960, 727113592507200, -799639222064560]
def CU_022_5_pim : Polynomial ℚ := interpQ 235794999 [-2094443831504032, -4188887663008064, -4914705569766848, -5900628657479184, -4526053679917608, -1747216125736232, 517021688931360, 3906665897114928, 5888340298508248, 5855059587640816, 5701872037197032, 7571718727076064, 9441565416955096, 10014195773270096, 10966838150115000, 9689417998715840, 7107435177444736, 5077309050504200, 1884519575230904]
theorem CU_022_5_pre_eq :
    CU_2_re_002 * Fplus_dW_re_020 - CU_2_im_002 * Fplus_dW_im_020 = CU_022_5_pre := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CU_022_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_5_pim_eq :
    CU_2_re_002 * Fplus_dW_im_020 + CU_2_im_002 * Fplus_dW_re_020 = CU_022_5_pim := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CU_022_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_022_5_mul :
    CU_2_c_002 * Fplus_dW_c_020 = ofLadj CU_022_5_pre CU_022_5_pim := by
  rw [CU_2_c_002_def, Fplus_dW_c_020_def, ofLadj_mul, CU_022_5_pre_eq, CU_022_5_pim_eq]

@[expose] public def CU_coeff_022 : Ki := CU_0_c_011 * Fplus_dU_c_011 + CU_0_c_002 * Fplus_dU_c_020 + CU_1_c_011 * Fplus_dV_c_011 + CU_1_c_002 * Fplus_dV_c_020 + CU_2_c_011 * Fplus_dW_c_011 + CU_2_c_002 * Fplus_dW_c_020

theorem CU_coeff_022_sum :
    CU_coeff_022 = ofLadj (CU_022_0_pre + CU_022_1_pre + CU_022_2_pre + CU_022_3_pre + CU_022_4_pre + CU_022_5_pre) (CU_022_0_pim + CU_022_1_pim + CU_022_2_pim + CU_022_3_pim + CU_022_4_pim + CU_022_5_pim) := by
  simp only [CU_coeff_022, CU_022_0_mul, CU_022_1_mul, CU_022_2_mul, CU_022_3_mul, CU_022_4_mul, CU_022_5_mul]
  simpa [add_assoc] using ofLadj_add6 CU_022_0_pre CU_022_0_pim CU_022_1_pre CU_022_1_pim CU_022_2_pre CU_022_2_pim CU_022_3_pre CU_022_3_pim CU_022_4_pre CU_022_4_pim CU_022_5_pre CU_022_5_pim

def CU_022_qre : Polynomial ℚ := interpQ 235794999 [250358621595024, 743861370142400, 817736511046368, 814508792774496, 543770893623728, -747633094873312, -690104557443592, -432993014991016, -510930673672880]
def CU_022_qim : Polynomial ℚ := interpQ 235794999 [-66346970196840, -66346970196840, 607513768211232, 874535116389112, 1551835281143872, 1547406239073472, 508849247369968, 403654089108800, 140718607625184]
theorem CU_coeff_022_poly_re :
    CU_022_0_pre + CU_022_1_pre + CU_022_2_pre + CU_022_3_pre + CU_022_4_pre + CU_022_5_pre = (0 : Polynomial ℚ) + Phi11 * CU_022_qre := by
  rw [phi11_interpQ]
  simp only [CU_022_0_pre, CU_022_1_pre, CU_022_2_pre, CU_022_3_pre, CU_022_4_pre, CU_022_5_pre, CU_022_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_022_poly_im :
    CU_022_0_pim + CU_022_1_pim + CU_022_2_pim + CU_022_3_pim + CU_022_4_pim + CU_022_5_pim = (0 : Polynomial ℚ) + Phi11 * CU_022_qim := by
  rw [phi11_interpQ]
  simp only [CU_022_0_pim, CU_022_1_pim, CU_022_2_pim, CU_022_3_pim, CU_022_4_pim, CU_022_5_pim, CU_022_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_022_eq :
    CU_coeff_022 = (0 : Ki) := by
  rw [CU_coeff_022_sum, CU_coeff_022_poly_re,
    CU_coeff_022_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
