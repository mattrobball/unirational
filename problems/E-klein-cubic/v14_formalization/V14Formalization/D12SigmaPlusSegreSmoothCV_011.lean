/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def CV_011_0_pre : Polynomial ℚ := C ((-22762931259623 / 8639957931 : ℚ)) + C ((-326852687059340 / 8639957931 : ℚ)) * X + C ((-5478807909844 / 71404611 : ℚ)) * X ^ 2 + C ((-1090138240142762 / 8639957931 : ℚ)) * X ^ 3 + C ((-1624367395646912 / 8639957931 : ℚ)) * X ^ 4 + C ((-1929045915231931 / 8639957931 : ℚ)) * X ^ 5 + C ((-2176371400500079 / 8639957931 : ℚ)) * X ^ 6 + C ((-2310914758277942 / 8639957931 : ℚ)) * X ^ 7 + C ((-2201671113900803 / 8639957931 : ℚ)) * X ^ 8 + C ((-719959184610812 / 2879985977 : ℚ)) * X ^ 9 + C ((-709410393132867 / 2879985977 : ℚ)) * X ^ 10 + C ((-697835620244001 / 2879985977 : ℚ)) * X ^ 11 + C ((-163761681121751 / 785450721 : ℚ)) * X ^ 12 + C ((-1496941796741312 / 8639957931 : ℚ)) * X ^ 13 + C ((-370510957919347 / 2879985977 : ℚ)) * X ^ 14 + C ((-55955674393601 / 785450721 : ℚ)) * X ^ 15 + C ((-111190889997492 / 2879985977 : ℚ)) * X ^ 16 + C ((-28749061574776 / 2879985977 : ℚ)) * X ^ 17 + C ((71034944301419 / 8639957931 : ℚ)) * X ^ 18
def CV_011_0_pim : Polynomial ℚ := C ((220674212446109 / 8639957931 : ℚ)) + C ((441348424892218 / 8639957931 : ℚ)) * X + C ((522052028023708 / 8639957931 : ℚ)) * X ^ 2 + C ((18701106572292 / 261816907 : ℚ)) * X ^ 3 + C ((464124796614166 / 8639957931 : ℚ)) * X ^ 4 + C ((54550665274438 / 2879985977 : ℚ)) * X ^ 5 + C ((-25617980156008 / 2879985977 : ℚ)) * X ^ 6 + C ((-431652063644711 / 8639957931 : ℚ)) * X ^ 7 + C ((-19210135493877 / 261816907 : ℚ)) * X ^ 8 + C ((-209316741669495 / 2879985977 : ℚ)) * X ^ 9 + C ((-200115465014446 / 2879985977 : ℚ)) * X ^ 10 + C ((-70971221725927 / 785450721 : ℚ)) * X ^ 11 + C ((-961020482927056 / 8639957931 : ℚ)) * X ^ 12 + C ((-1014120256093399 / 8639957931 : ℚ)) * X ^ 13 + C ((-367740166221957 / 2879985977 : ℚ)) * X ^ 14 + C ((-322567832169150 / 2879985977 : ℚ)) * X ^ 15 + C ((-702664656539246 / 8639957931 : ℚ)) * X ^ 16 + C ((-504151851894220 / 8639957931 : ℚ)) * X ^ 17 + C ((-184787689540181 / 8639957931 : ℚ)) * X ^ 18
theorem CV_011_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_011 - CV_0_im_000 * Fplus_dU_im_011 = CV_011_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_011_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_011_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_011 + CV_0_im_000 * Fplus_dU_re_011 = CV_011_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_011_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_011_0_mul :
    CV_0_c_000 * Fplus_dU_c_011 = ofLadj CV_011_0_pre CV_011_0_pim := by
  rw [CV_0_c_000_def, Fplus_dU_c_011_def, ofLadj_mul, CV_011_0_pre_eq, CV_011_0_pim_eq]

def CV_011_1_pre : Polynomial ℚ := C ((53231685536408 / 8639957931 : ℚ)) + C ((756214727591680 / 8639957931 : ℚ)) * X + C ((136211391265010 / 785450721 : ℚ)) * X ^ 2 + C ((818939501212256 / 2879985977 : ℚ)) * X ^ 3 + C ((3665119356735976 / 8639957931 : ℚ)) * X ^ 4 + C ((1454500710506600 / 2879985977 : ℚ)) * X ^ 5 + C ((4938172090922909 / 8639957931 : ℚ)) * X ^ 6 + C ((5280581378593072 / 8639957931 : ℚ)) * X ^ 7 + C ((5032071476701571 / 8639957931 : ℚ)) * X ^ 8 + C ((1658334350054977 / 2879985977 : ℚ)) * X ^ 9 + C ((4931785589855062 / 8639957931 : ℚ)) * X ^ 10 + C ((1620701891651426 / 2879985977 : ℚ)) * X ^ 11 + C ((1391856954087794 / 2879985977 : ℚ)) * X ^ 12 + C ((3476677746249821 / 8639957931 : ℚ)) * X ^ 13 + C ((2575252973064803 / 8639957931 : ℚ)) * X ^ 14 + C ((1419094436117878 / 8639957931 : ℚ)) * X ^ 15 + C ((751860290793559 / 8639957931 : ℚ)) * X ^ 16 + C ((177190331390450 / 8639957931 : ℚ)) * X ^ 17 + C ((-196367585739218 / 8639957931 : ℚ)) * X ^ 18
def CV_011_1_pim : Polynomial ℚ := C ((-171685691569224 / 2879985977 : ℚ)) + C ((-343371383138448 / 2879985977 : ℚ)) * X + C ((-1207425305501542 / 8639957931 : ℚ)) * X ^ 2 + C ((-1452184188875384 / 8639957931 : ℚ)) * X ^ 3 + C ((-1112809988268515 / 8639957931 : ℚ)) * X ^ 4 + C ((-431814409590761 / 8639957931 : ℚ)) * X ^ 5 + C ((41332553265869 / 2879985977 : ℚ)) * X ^ 6 + C ((956748144606284 / 8639957931 : ℚ)) * X ^ 7 + C ((1442193566549068 / 8639957931 : ℚ)) * X ^ 8 + C ((1433847176200051 / 8639957931 : ℚ)) * X ^ 9 + C ((1396325428233563 / 8639957931 : ℚ)) * X ^ 10 + C ((618730569063488 / 2879985977 : ℚ)) * X ^ 11 + C ((2316057986147365 / 8639957931 : ℚ)) * X ^ 12 + C ((818615798089025 / 2879985977 : ℚ)) * X ^ 13 + C ((2692259887291900 / 8639957931 : ℚ)) * X ^ 14 + C ((2376969699232030 / 8639957931 : ℚ)) * X ^ 15 + C ((1744075937994751 / 8639957931 : ℚ)) * X ^ 16 + C ((1246010076763987 / 8639957931 : ℚ)) * X ^ 17 + C ((461361409395785 / 8639957931 : ℚ)) * X ^ 18
theorem CV_011_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_011 - CV_1_im_000 * Fplus_dV_im_011 = CV_011_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_011_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_011_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_011 + CV_1_im_000 * Fplus_dV_re_011 = CV_011_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_011_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_011_1_mul :
    CV_1_c_000 * Fplus_dV_c_011 = ofLadj CV_011_1_pre CV_011_1_pim := by
  rw [CV_1_c_000_def, Fplus_dV_c_011_def, ofLadj_mul, CV_011_1_pre_eq, CV_011_1_pim_eq]

def CV_011_2_pre : Polynomial ℚ := C ((14383390390 / 97078179 : ℚ)) + C ((-25603056019160 / 8639957931 : ℚ)) * X + C ((-54396108745934 / 8639957931 : ℚ)) * X ^ 2 + C ((-92912434955884 / 8639957931 : ℚ)) * X ^ 3 + C ((-148222183196548 / 8639957931 : ℚ)) * X ^ 4 + C ((-191576633385034 / 8639957931 : ℚ)) * X ^ 5 + C ((-225860806910077 / 8639957931 : ℚ)) * X ^ 6 + C ((-235629137000864 / 8639957931 : ℚ)) * X ^ 7 + C ((-213132784680166 / 8639957931 : ℚ)) * X ^ 8 + C ((-197151224690689 / 8639957931 : ℚ)) * X ^ 9 + C ((-185027761358651 / 8639957931 : ℚ)) * X ^ 10 + C ((-181631169670100 / 8639957931 : ℚ)) * X ^ 11 + C ((-53141568446497 / 2879985977 : ℚ)) * X ^ 12 + C ((-1603990066795 / 97078179 : ℚ)) * X ^ 13 + C ((-40073449908094 / 2879985977 : ℚ)) * X ^ 14 + C ((-79528004484485 / 8639957931 : ℚ)) * X ^ 15 + C ((-14998688242240 / 2879985977 : ℚ)) * X ^ 16 + C ((-3570630400559 / 2879985977 : ℚ)) * X ^ 17 + C ((7878949319831 / 8639957931 : ℚ)) * X ^ 18
def CV_011_2_pim : Polynomial ℚ := C ((9174425818845 / 2879985977 : ℚ)) + C ((18348851637690 / 2879985977 : ℚ)) * X + C ((6169099010287 / 785450721 : ℚ)) * X ^ 2 + C ((86641917283876 / 8639957931 : ℚ)) * X ^ 3 + C ((84617229679498 / 8639957931 : ℚ)) * X ^ 4 + C ((60058066881976 / 8639957931 : ℚ)) * X ^ 5 + C ((25449157599209 / 8639957931 : ℚ)) * X ^ 6 + C ((-655259337945 / 261816907 : ℚ)) * X ^ 7 + C ((-47698022804312 / 8639957931 : ℚ)) * X ^ 8 + C ((-45298982093693 / 8639957931 : ℚ)) * X ^ 9 + C ((-11617616759066 / 2879985977 : ℚ)) * X ^ 10 + C ((-1419705748578 / 261816907 : ℚ)) * X ^ 11 + C ((-19615909709650 / 2879985977 : ℚ)) * X ^ 12 + C ((-20405043837514 / 2879985977 : ℚ)) * X ^ 13 + C ((-77597918972642 / 8639957931 : ℚ)) * X ^ 14 + C ((-27446564034658 / 2879985977 : ℚ)) * X ^ 15 + C ((-71193402937027 / 8639957931 : ℚ)) * X ^ 16 + C ((-52967846037236 / 8639957931 : ℚ)) * X ^ 17 + C ((-19308003916417 / 8639957931 : ℚ)) * X ^ 18
theorem CV_011_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_011 - CV_2_im_000 * Fplus_dW_im_011 = CV_011_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_011_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_011_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_011 + CV_2_im_000 * Fplus_dW_re_011 = CV_011_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_011_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_011_2_mul :
    CV_2_c_000 * Fplus_dW_c_011 = ofLadj CV_011_2_pre CV_011_2_pim := by
  rw [CV_2_c_000_def, Fplus_dW_c_011_def, ofLadj_mul, CV_011_2_pre_eq, CV_011_2_pim_eq]

def CV_011_3_pre : Polynomial ℚ := C ((-17261043260 / 785450721 : ℚ)) + C ((16738710788 / 261816907 : ℚ)) * X ^ 2 + C ((38153665976 / 261816907 : ℚ)) * X ^ 3 + C ((5352225624 / 23801537 : ℚ)) * X ^ 4 + C ((71379094564 / 261816907 : ℚ)) * X ^ 5 + C ((71379094564 / 261816907 : ℚ)) * X ^ 6 + C ((5352225624 / 23801537 : ℚ)) * X ^ 7 + C ((38153665976 / 261816907 : ℚ)) * X ^ 8 + C ((16738710788 / 261816907 : ℚ)) * X ^ 9
def CV_011_3_pim : Polynomial ℚ := C ((-672210784138 / 8639957931 : ℚ)) + C ((-1344421568276 / 8639957931 : ℚ)) * X + C ((-1872635383430 / 8639957931 : ℚ)) * X ^ 2 + C ((-1909532034488 / 8639957931 : ℚ)) * X ^ 3 + C ((-1732365732728 / 8639957931 : ℚ)) * X ^ 4 + C ((-987348719980 / 8639957931 : ℚ)) * X ^ 5 + C ((-357072848296 / 8639957931 : ℚ)) * X ^ 6 + C ((129314721484 / 2879985977 : ℚ)) * X ^ 7 + C ((188370155404 / 2879985977 : ℚ)) * X ^ 8 + C ((176071271718 / 2879985977 : ℚ)) * X ^ 9
theorem CV_011_3_neg_re : -CV_3_re_011 = CV_011_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_011_def, CV_011_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_011_3_neg_im : -CV_3_im_011 = CV_011_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_011_def, CV_011_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_011_3_mul : -CV_3_c_011 = ofLadj CV_011_3_pre CV_011_3_pim := by
  rw [CV_3_c_011_def, ofLadj_neg, CV_011_3_neg_re, CV_011_3_neg_im]

@[expose] public def CV_coeff_011 : Ki := CV_0_c_000 * Fplus_dU_c_011 + CV_1_c_000 * Fplus_dV_c_011 + CV_2_c_000 * Fplus_dW_c_011 + (-CV_3_c_011)

theorem CV_coeff_011_sum :
    CV_coeff_011 = ofLadj (CV_011_0_pre + CV_011_1_pre + CV_011_2_pre + CV_011_3_pre) (CV_011_0_pim + CV_011_1_pim + CV_011_2_pim + CV_011_3_pim) := by
  simp only [CV_coeff_011, CV_011_0_mul, CV_011_1_mul, CV_011_2_mul, CV_011_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_011_0_pre CV_011_0_pim CV_011_1_pre CV_011_1_pim CV_011_2_pre CV_011_2_pim CV_011_3_pre CV_011_3_pim

def CV_011_qre : Polynomial ℚ := C ((31559004545635 / 8639957931 : ℚ)) + C ((372199979967545 / 8639957931 : ℚ)) * X + C ((377786831020876 / 8639957931 : ℚ)) * X ^ 2 + C ((493481083981274 / 8639957931 : ℚ)) * X ^ 3 + C ((619445736278698 / 8639957931 : ℚ)) * X ^ 4 + C ((116920819076473 / 2879985977 : ℚ)) * X ^ 5 + C ((293060300609918 / 8639957931 : ℚ)) * X ^ 6 + C ((65894982527471 / 2879985977 : ℚ)) * X ^ 7 + C ((-117453692117968 / 8639957931 : ℚ)) * X ^ 8
def CV_011_qim : Polynomial ℚ := C ((-267531795589166 / 8639957931 : ℚ)) + C ((-267531795589166 / 8639957931 : ℚ)) * X + C ((-84322232569775 / 8639957931 : ℚ)) * X ^ 2 + C ((-43643154330751 / 2879985977 : ℚ)) * X ^ 3 + C ((184514959032781 / 8639957931 : ℚ)) * X ^ 4 + C ((118902877367376 / 2879985977 : ℚ)) * X ^ 5 + C ((8525075748059 / 261816907 : ℚ)) * X ^ 6 + C ((431624662893344 / 8639957931 : ℚ)) * X ^ 7 + C ((257265715939187 / 8639957931 : ℚ)) * X ^ 8
theorem CV_coeff_011_poly_re :
    CV_011_0_pre + CV_011_1_pre + CV_011_2_pre + CV_011_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_011_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_011_0_pre, CV_011_1_pre, CV_011_2_pre, CV_011_3_pre, CV_011_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_011_poly_im :
    CV_011_0_pim + CV_011_1_pim + CV_011_2_pim + CV_011_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_011_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_011_0_pim, CV_011_1_pim, CV_011_2_pim, CV_011_3_pim, CV_011_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_011_eq :
    CV_coeff_011 = (0 : Ki) := by
  rw [CV_coeff_011_sum, CV_coeff_011_poly_re,
    CV_coeff_011_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
