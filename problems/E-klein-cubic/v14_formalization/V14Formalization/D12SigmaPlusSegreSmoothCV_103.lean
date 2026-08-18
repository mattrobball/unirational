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

def CV_103_0_pre : Polynomial ℚ := interpQ 17279915862 [-1832543504912, 17113533117184, 31433072563338, 53627214786010, 82240475225860, 99299649626572, 114846806500502, 126090093351749, 122465761852853, 123274974492876, 125735692476591, 126872771574478, 108622159359407, 91841901929538, 68838547066843, 37995380692241, 20347913124688, 4800756250758, -5854237433648]
def CV_103_0_pim : Polynomial ℚ := interpQ 17279915862 [-13378028531096, -26756057062192, -31610728992530, -39875928285702, -36308428065690, -20924026686950, -14835623152874, 6437486317075, 14324825163781, 15307386608792, 15957277961005, 31210391367720, 46463504774435, 51968068056986, 61215828795169, 55924966993387, 40204697111132, 31219678401940, 9610700428476]
theorem CV_103_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_002 - CV_0_im_101 * Fplus_dU_im_002 = CV_103_0_pre := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_103_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_002 + CV_0_im_101 * Fplus_dU_re_002 = CV_103_0_pim := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_103_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_0_mul :
    CV_0_c_101 * Fplus_dU_c_002 = ofLadj CV_103_0_pre CV_103_0_pim := by
  rw [CV_0_c_101_def, Fplus_dU_c_002_def, ofLadj_mul, CV_103_0_pre_eq, CV_103_0_pim_eq]

def CV_103_1_pre : Polynomial ℚ := interpQ 17279915862 [642116360469984, 4584781675541760, 8643084015355488, 13592249272345160, 19350034837308896, 22180346726293208, 24282513348255196, 25258470483421008, 23399078146404224, 23044044973997656, 22773657358246676, 22030131499594736, 18188875682704916, 14400960958642168, 9806828874059064, 4374716472565456, 1738231421202820, -363935200759168, -1533719173546656]
def CV_103_1_pim : Polynomial ℚ := interpQ 17279915862 [-2055345833938464, -4110691667876928, -3911107987206528, -3898197261646696, -1060582613316432, 3336424419379672, 6704229966381564, 10993514561106296, 13369247656279448, 13318536588685440, 13083705274246028, 14795310328453216, 16506915382660404, 16072500387550592, 16008878594396752, 13319768515148664, 9224605556420492, 6214669046847776, 2227228526090976]
theorem CV_103_1_pre_eq :
    CV_0_re_002 * Fplus_dU_re_101 - CV_0_im_002 * Fplus_dU_im_101 = CV_103_1_pre := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_103_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_1_pim_eq :
    CV_0_re_002 * Fplus_dU_im_101 + CV_0_im_002 * Fplus_dU_re_101 = CV_103_1_pim := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_103_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_1_mul :
    CV_0_c_002 * Fplus_dU_c_101 = ofLadj CV_103_1_pre CV_103_1_pim := by
  rw [CV_0_c_002_def, Fplus_dU_c_101_def, ofLadj_mul, CV_103_1_pre_eq, CV_103_1_pim_eq]

def CV_103_2_pre : Polynomial ℚ := interpQ 17279915862 [1735182114161, -13258205184620, -27259590664039, -47802293277027, -76299454871305, -99149512215811, -116848529256790, -122044447401629, -109688693020283, -101097612384115, -94998893479280, -94076645835694, -81740688294660, -73838021720076, -61886399743256, -40957382092490, -22799633452352, -5100616411373, 4787610437834]
def CV_103_2_pim : Polynomial ℚ := interpQ 17279915862 [14520638537199, 29041277074398, 35748424080433, 45609293146927, 45067620623891, 31510537042623, 14526179997866, -11348596625159, -24180514349207, -23118698720331, -17457553120784, -23921428956604, -30385304792424, -31431306198912, -40230359636530, -42960582853214, -36796498103346, -28041799775953, -9560021984328]
theorem CV_103_2_pre_eq :
    CV_1_re_101 * Fplus_dV_re_002 - CV_1_im_101 * Fplus_dV_im_002 = CV_103_2_pre := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_103_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_2_pim_eq :
    CV_1_re_101 * Fplus_dV_im_002 + CV_1_im_101 * Fplus_dV_re_002 = CV_103_2_pim := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_103_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_2_mul :
    CV_1_c_101 * Fplus_dV_c_002 = ofLadj CV_103_2_pre CV_103_2_pim := by
  rw [CV_1_c_101_def, Fplus_dV_c_002_def, ofLadj_mul, CV_103_2_pre_eq, CV_103_2_pim_eq]

def CV_103_3_pre : Polynomial ℚ := interpQ 17279915862 [-325313989129064, -4344832521860000, -8843167973208000, -14529095646696440, -21629217797150008, -25704882622313412, -28985109934703372, -30786637554265784, -29333071639026196, -28779546107326216, -28355422246563000, -27873355517036944, -24010589724703000, -19936378134118216, -14803975992329756, -8213807096631384, -4440626695368160, -1160399382978200, 943612660484392]
def CV_103_3_pim : Polynomial ℚ := interpQ 17279915862 [2923938738672640, 5847877477345280, 6939706331829304, 8171697400967080, 6146483540823784, 2140507676861420, -1076387152628284, -5790138593974680, -8500932501735804, -8420562521067656, -8054257149552384, -10440756408778440, -12827255668004496, -13552779150973248, -14704400239442876, -12912643166273704, -9376819512556224, -6720936351888512, -2477337120787000]
theorem CV_103_3_pre_eq :
    CV_1_re_002 * Fplus_dV_re_101 - CV_1_im_002 * Fplus_dV_im_101 = CV_103_3_pre := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_103_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_3_pim_eq :
    CV_1_re_002 * Fplus_dV_im_101 + CV_1_im_002 * Fplus_dV_re_101 = CV_103_3_pim := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_103_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_3_mul :
    CV_1_c_002 * Fplus_dV_c_101 = ofLadj CV_103_3_pre CV_103_3_pim := by
  rw [CV_1_c_002_def, Fplus_dV_c_101_def, ofLadj_mul, CV_103_3_pre_eq, CV_103_3_pim_eq]

def CV_103_4_pre : Polynomial ℚ := interpQ 17279915862 [4774827657630, 0, -12666196541682, -29309539539531, -44524186080219, -53569586476290, -53569586476290, -44524186080219, -29309539539531, -12666196541682]
def CV_103_4_pim : Polynomial ℚ := interpQ 17279915862 [16104193656330, 32208387312660, 43189131719196, 45572560196901, 38571364673679, 24484855546962, 7723531765698, -6362977361019, -13364172884241, -10980744406536]
theorem CV_103_4_pre_eq :
    CV_2_re_101 * Fplus_dW_re_002 - CV_2_im_101 * Fplus_dW_im_002 = CV_103_4_pre := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_103_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_4_pim_eq :
    CV_2_re_101 * Fplus_dW_im_002 + CV_2_im_101 * Fplus_dW_re_002 = CV_103_4_pim := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_103_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_4_mul :
    CV_2_c_101 * Fplus_dW_c_002 = ofLadj CV_103_4_pre CV_103_4_pim := by
  rw [CV_2_c_101_def, Fplus_dW_c_002_def, ofLadj_mul, CV_103_4_pre_eq, CV_103_4_pim_eq]

def CV_103_5_pre : Polynomial ℚ := interpQ 17279915862 [-133650388253872, -2279264844990784, -4544658377583720, -7386150834114416, -11225378373337000, -13569371238240744, -15709208867725872, -17134693757393888, -16843734286089524, -17068270281656976, -17243232160099444, -17171661807068960, -14963967315108660, -12523611904073256, -9457583451975108, -5409063125048504, -2942086671598976, -802249042113848, 500252259008384]
def CV_103_5_pim : Polynomial ℚ := interpQ 17279915862 [1634861728340880, 3269723456681760, 3983580517040712, 4977603881832080, 4326124236846648, 2601408807508968, 1276863489586528, -1127493271615832, -2506270075893620, -2540356794519352, -2689122632953508, -4543719102243024, -6398315571532540, -7260938470325648, -8289048553742748, -7540620238020656, -5625781295944392, -4070205748955392, -1475725475014448]
theorem CV_103_5_pre_eq :
    CV_2_re_002 * Fplus_dW_re_101 - CV_2_im_002 * Fplus_dW_im_101 = CV_103_5_pre := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_103_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_5_pim_eq :
    CV_2_re_002 * Fplus_dW_im_101 + CV_2_im_002 * Fplus_dW_re_101 = CV_103_5_pim := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_103_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_103_5_mul :
    CV_2_c_002 * Fplus_dW_c_101 = ofLadj CV_103_5_pre CV_103_5_pim := by
  rw [CV_2_c_002_def, Fplus_dW_c_101_def, ofLadj_mul, CV_103_5_pre_eq, CV_103_5_pim_eq]

@[expose] public def CV_coeff_103 : Ki := CV_0_c_101 * Fplus_dU_c_002 + CV_0_c_002 * Fplus_dU_c_101 + CV_1_c_101 * Fplus_dV_c_002 + CV_1_c_002 * Fplus_dV_c_101 + CV_2_c_101 * Fplus_dW_c_002 + CV_2_c_002 * Fplus_dW_c_101

theorem CV_coeff_103_sum :
    CV_coeff_103 = ofLadj (CV_103_0_pre + CV_103_1_pre + CV_103_2_pre + CV_103_3_pre + CV_103_4_pre + CV_103_5_pre) (CV_103_0_pim + CV_103_1_pim + CV_103_2_pim + CV_103_3_pim + CV_103_4_pim + CV_103_5_pim) := by
  simp only [CV_coeff_103, CV_103_0_mul, CV_103_1_mul, CV_103_2_mul, CV_103_3_mul, CV_103_4_mul, CV_103_5_mul]
  simpa [add_assoc] using ofLadj_add6 CV_103_0_pre CV_103_0_pim CV_103_1_pre CV_103_1_pim CV_103_2_pre CV_103_2_pim CV_103_3_pre CV_103_3_pim CV_103_4_pre CV_103_4_pim CV_103_5_pre CV_103_5_pim

def CV_103_qre : Polynomial ℚ := interpQ 17279915862 [187829449353927, -2223289812730387, -2717774686702155, -3593246776417629, -5196662672407532, -3604182084422701, -3320050180080149, -2235962604962137, -90920881049694]
def CV_103_qim : Polynomial ℚ := interpQ 17279915862 [2520701436737489, 2520701436737489, 2018102814995609, 2242904257740003, 156945775375290, -1345943451933185, -1201291877702197, -2847511784103817, -1725783391266324]
theorem CV_coeff_103_poly_re :
    CV_103_0_pre + CV_103_1_pre + CV_103_2_pre + CV_103_3_pre + CV_103_4_pre + CV_103_5_pre = (0 : Polynomial ℚ) + Phi11 * CV_103_qre := by
  rw [phi11_interpQ]
  simp only [CV_103_0_pre, CV_103_1_pre, CV_103_2_pre, CV_103_3_pre, CV_103_4_pre, CV_103_5_pre, CV_103_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_103_poly_im :
    CV_103_0_pim + CV_103_1_pim + CV_103_2_pim + CV_103_3_pim + CV_103_4_pim + CV_103_5_pim = (0 : Polynomial ℚ) + Phi11 * CV_103_qim := by
  rw [phi11_interpQ]
  simp only [CV_103_0_pim, CV_103_1_pim, CV_103_2_pim, CV_103_3_pim, CV_103_4_pim, CV_103_5_pim, CV_103_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_103_eq :
    CV_coeff_103 = (0 : Ki) := by
  rw [CV_coeff_103_sum, CV_coeff_103_poly_re,
    CV_coeff_103_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
