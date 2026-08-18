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

def CW_111_0_pre : Polynomial ℚ := interpQ 8639957931 [-4484688229110, -69508507856280, -140091543946986, -231379418341212, -345309667704166, -409159785025545, -462766064689653, -490436055323564, -467176763566567, -458282487226047, -451574962087067, -444530530427700, -382066454230787, -318190943279061, -235797345225355, -130001725978698, -71021932475774, -17415652811666, 15124661640700]
def CW_111_0_pim : Polynomial ℚ := interpQ 8639957931 [47076954186668, 94153908373336, 111045804310412, 132492852018252, 98838882854724, 35860829369607, -15525469450187, -91401242227962, -133737606769331, -132421763529407, -126585034731081, -165069230146494, -203553425561907, -214608592700657, -234739797168573, -204819833955414, -149337016172052, -106982895667020, -38602358591000]
theorem CW_111_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_011 - CW_0_im_100 * Fplus_dU_im_011 = CW_111_0_pre := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_111_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_011 + CW_0_im_100 * Fplus_dU_re_011 = CW_111_0_pim := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_111_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_0_mul :
    CW_0_c_100 * Fplus_dU_c_011 = ofLadj CW_111_0_pre CW_111_0_pim := by
  rw [CW_0_c_100_def, Fplus_dU_c_011_def, ofLadj_mul, CW_111_0_pre_eq, CW_111_0_pim_eq]

def CW_111_1_pre : Polynomial ℚ := interpQ 8639957931 [-4320759554320, -35711193776128, -65881373620376, -104212021875216, -149382834476456, -168763333112258, -187329308808210, -193484379617005, -179555662021659, -176896507945578, -174709197621603, -169729435778750, -138998003845475, -111015134325202, -75343640146443, -32728232255873, -14775216654278, 3790759041674, 11373312884676]
def CW_111_1_pim : Polynomial ℚ := interpQ 8639957931 [16463056925856, 32926113851712, 30523041309856, 32710293602980, 8865196123504, -23070715756264, -48297924309892, -82311268811465, -99093598130095, -98805958231404, -97006257867323, -110797691558432, -124589125249541, -120386352343604, -122285964738037, -99454590563475, -69923580537396, -47377048661600, -15768606013716]
theorem CW_111_1_pre_eq :
    CW_0_re_010 * Fplus_dU_re_101 - CW_0_im_010 * Fplus_dU_im_101 = CW_111_1_pre := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_111_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_1_pim_eq :
    CW_0_re_010 * Fplus_dU_im_101 + CW_0_im_010 * Fplus_dU_re_101 = CW_111_1_pim := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_111_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_1_mul :
    CW_0_c_010 * Fplus_dU_c_101 = ofLadj CW_111_1_pre CW_111_1_pim := by
  rw [CW_0_c_010_def, Fplus_dU_c_101_def, ofLadj_mul, CW_111_1_pre_eq, CW_111_1_pim_eq]

def CW_111_2_pre : Polynomial ℚ := interpQ 8639957931 [7151957062460, 120703746449888, 237777569294682, 389905355728410, 582674649510633, 691812571083311, 784687336353123, 838396793034674, 799404988119182, 790165035911679, 783522162707275, 773514881844718, 662818416257387, 552387466616997, 409499632390772, 224878794800220, 120770717190347, 27895951920535, -30843348723821]
def CW_111_2_pim : Polynomial ℚ := interpQ 8639957931 [-82764879655084, -165529759310168, -192044190633336, -233264312834544, -177729670157277, -70750426307547, 16752792245845, 149162006894932, 226000378431332, 224489112766837, 218585677895241, 292589148274700, 366592618654159, 387203615105731, 426912471642444, 375456615347824, 275894414766627, 197751756534307, 72759585153753]
theorem CW_111_2_pre_eq :
    CW_1_re_100 * Fplus_dV_re_011 - CW_1_im_100 * Fplus_dV_im_011 = CW_111_2_pre := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_111_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_2_pim_eq :
    CW_1_re_100 * Fplus_dV_im_011 + CW_1_im_100 * Fplus_dV_re_011 = CW_111_2_pim := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_111_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_2_mul :
    CW_1_c_100 * Fplus_dV_c_011 = ofLadj CW_111_2_pre CW_111_2_pim := by
  rw [CW_1_c_100_def, Fplus_dV_c_011_def, ofLadj_mul, CW_111_2_pre_eq, CW_111_2_pim_eq]

def CW_111_3_pre : Polynomial ℚ := interpQ 8639957931 [1025888764706, 24825587592200, 49823710257156, 81279463180912, 122628060656572, 145723935199749, 164023711035425, 173770452512364, 165736488249912, 162509793431393, 160186501575462, 158309260177628, 135360913983262, 112686083174237, 84457025069000, 46038869550322, 24620817404776, 6321041569100, -5103522305470]
def CW_111_3_pim : Polynomial ℚ := interpQ 8639957931 [-17053897610880, -34107795221760, -39282147562534, -47706348272330, -36437470772480, -13193083255705, 5101729165459, 31398878252694, 46611649099972, 46074608168757, 43904528690012, 57988850860050, 72073173030088, 75077445892117, 82964605670698, 73124964728712, 52560087242314, 37401173346272, 13783534289414]
theorem CW_111_3_pre_eq :
    CW_1_re_010 * Fplus_dV_re_101 - CW_1_im_010 * Fplus_dV_im_101 = CW_111_3_pre := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_111_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_3_pim_eq :
    CW_1_re_010 * Fplus_dV_im_101 + CW_1_im_010 * Fplus_dV_re_101 = CW_111_3_pim := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_111_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_3_mul :
    CW_1_c_010 * Fplus_dV_c_101 = ofLadj CW_111_3_pre CW_111_3_pim := by
  rw [CW_1_c_010_def, Fplus_dV_c_101_def, ofLadj_mul, CW_111_3_pre_eq, CW_111_3_pim_eq]

def CW_111_4_pre : Polynomial ℚ := interpQ 8639957931 [342538009853, -1991868616892, -4007191081386, -7020352408183, -11307872050398, -14457054473272, -17361366422154, -17891197102830, -16167987574376, -14877139586555, -14066742700133, -13967773132786, -12074874083241, -10869948505169, -9147635166193, -5962184237076, -3561923640960, -657611692078, 621140815356]
def CW_111_4_pim : Polynomial ℚ := interpQ 8639957931 [2201994907911, 4403989815822, 5216722363322, 7017461058327, 6546544361148, 4899539143786, 2232906139998, -1449561164866, -3447387318184, -3143902181475, -2330660536031, -3385670319324, -4440680102617, -4440171004673, -5937424562969, -6087721955396, -5409000256744, -4090795849866, -1376612063712]
theorem CW_111_4_pre_eq :
    CW_2_re_100 * Fplus_dW_re_011 - CW_2_im_100 * Fplus_dW_im_011 = CW_111_4_pre := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_111_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_4_pim_eq :
    CW_2_re_100 * Fplus_dW_im_011 + CW_2_im_100 * Fplus_dW_re_011 = CW_111_4_pim := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_111_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_4_mul :
    CW_2_c_100 * Fplus_dW_c_011 = ofLadj CW_111_4_pre CW_111_4_pim := by
  rw [CW_2_c_100_def, Fplus_dW_c_011_def, ofLadj_mul, CW_111_4_pre_eq, CW_111_4_pim_eq]

def CW_111_5_pre : Polynomial ℚ := interpQ 8639957931 [-4272290820448, -3011157845920, -11433337853934, -11423743193218, -14887295531046, -25871307014089, -19849643839588, -26951206557025, -28316848995951, -28127908587603, -28744445564169, -24098984106550, -25733287718249, -16694570733669, -16893105802733, -12986543121517, -1950420649562, -7972083824063, -922632095538]
def CW_111_5_pim : Polynomial ℚ := interpQ 8639957931 [567049356588, 1134098713176, 4357205171992, -2613973842360, 5914721532506, -2551277823155, -5413306653016, -3060841276415, -9113495621911, -8779364851825, -8969012465403, -9788016570144, -10607020674885, -14019774747279, -6714464962841, -15724601241537, -6632209104776, -3845140846165, -5571213441666]
theorem CW_111_5_pre_eq :
    CW_2_re_010 * Fplus_dW_re_101 - CW_2_im_010 * Fplus_dW_im_101 = CW_111_5_pre := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_111_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_5_pim_eq :
    CW_2_re_010 * Fplus_dW_im_101 + CW_2_im_010 * Fplus_dW_re_101 = CW_111_5_pim := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_111_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_5_mul :
    CW_2_c_010 * Fplus_dW_c_101 = ofLadj CW_111_5_pre CW_111_5_pim := by
  rw [CW_2_c_010_def, Fplus_dW_c_101_def, ofLadj_mul, CW_111_5_pre_eq, CW_111_5_pim_eq]

def CW_111_6_pre : Polynomial ℚ := interpQ 8639957931 [61179229683, 0, -584679705786, -1237980753691, -1933729847467, -2258248294412, -2258248294412, -1933729847467, -1237980753691, -584679705786]
def CW_111_6_pim : Polynomial ℚ := interpQ 8639957931 [682264250533, 1364528501066, 1812307334884, 1843663517321, 1687849015585, 1009296368876, 355232132190, -323320514519, -479135016255, -447778833818]
theorem CW_111_6_neg_re : -CW_3_re_111 = CW_111_6_pre := by
  simp only [CW_3_re_111_def, CW_111_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_6_neg_im : -CW_3_im_111 = CW_111_6_pim := by
  simp only [CW_3_im_111_def, CW_111_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_111_6_mul : -CW_3_c_111 = ofLadj CW_111_6_pre CW_111_6_pim := by
  rw [CW_3_c_111_def, ofLadj_neg, CW_111_6_neg_re, CW_111_6_neg_im]

theorem CW_111_7_mul : CW_3_c_110 = ofLadj CW_3_re_110 CW_3_im_110 := CW_3_c_110_def

@[expose] public def CW_coeff_111 : Ki := CW_0_c_100 * Fplus_dU_c_011 + CW_0_c_010 * Fplus_dU_c_101 + CW_1_c_100 * Fplus_dV_c_011 + CW_1_c_010 * Fplus_dV_c_101 + CW_2_c_100 * Fplus_dW_c_011 + CW_2_c_010 * Fplus_dW_c_101 + (-CW_3_c_111) + CW_3_c_110

theorem CW_coeff_111_sum :
    CW_coeff_111 = ofLadj (CW_111_0_pre + CW_111_1_pre + CW_111_2_pre + CW_111_3_pre + CW_111_4_pre + CW_111_5_pre + CW_111_6_pre + CW_3_re_110) (CW_111_0_pim + CW_111_1_pim + CW_111_2_pim + CW_111_3_pim + CW_111_4_pim + CW_111_5_pim + CW_111_6_pim + CW_3_im_110) := by
  simp only [CW_coeff_111, CW_111_0_mul, CW_111_1_mul, CW_111_2_mul, CW_111_3_mul, CW_111_4_mul, CW_111_5_mul, CW_111_6_mul, CW_111_7_mul]
  simp [ofLadj_add, add_assoc]

def CW_111_qre : Polynomial ℚ := interpQ 8639957931 [-4884102266795, 40190708213663, 31003757414764, 51528021829085, 67535952361670, 35156937582829, 42119636971047, 21712791987599, -9750387784097]
def CW_111_qim : Polynomial ℚ := interpQ 8639957931 [-33938149554941, -33938149554941, -13350630106338, -31373255679087, 17704593520008, 25342136422741, 24295647082045, 47632719522855, 25224329333073]
theorem CW_coeff_111_poly_re :
    CW_111_0_pre + CW_111_1_pre + CW_111_2_pre + CW_111_3_pre + CW_111_4_pre + CW_111_5_pre + CW_111_6_pre + CW_3_re_110 = (0 : Polynomial ℚ) + Phi11 * CW_111_qre := by
  rw [phi11_interpQ]
  simp only [CW_111_0_pre, CW_111_1_pre, CW_111_2_pre, CW_111_3_pre, CW_111_4_pre, CW_111_5_pre, CW_111_6_pre, CW_3_re_110_def, CW_111_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_111_poly_im :
    CW_111_0_pim + CW_111_1_pim + CW_111_2_pim + CW_111_3_pim + CW_111_4_pim + CW_111_5_pim + CW_111_6_pim + CW_3_im_110 = (0 : Polynomial ℚ) + Phi11 * CW_111_qim := by
  rw [phi11_interpQ]
  simp only [CW_111_0_pim, CW_111_1_pim, CW_111_2_pim, CW_111_3_pim, CW_111_4_pim, CW_111_5_pim, CW_111_6_pim, CW_3_im_110_def, CW_111_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_111_eq :
    CW_coeff_111 = (0 : Ki) := by
  rw [CW_coeff_111_sum, CW_coeff_111_poly_re,
    CW_coeff_111_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
