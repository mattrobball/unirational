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

def CU_021_0_pre : Polynomial ℚ := C ((-48322974209968 / 235794999 : ℚ)) + C ((-653944684947520 / 235794999 : ℚ)) * X + C ((-1330568871771856 / 235794999 : ℚ)) * X ^ 2 + C ((-2185947207677984 / 235794999 : ℚ)) * X ^ 3 + C ((-1084877539609144 / 78598333 : ℚ)) * X ^ 4 + C ((-3868269789703940 / 235794999 : ℚ)) * X ^ 5 + C ((-4361155465401532 / 235794999 : ℚ)) * X ^ 6 + C ((-4632683263299020 / 235794999 : ℚ)) * X ^ 7 + C ((-4413811622779336 / 235794999 : ℚ)) * X ^ 8 + C ((-4330359567346652 / 235794999 : ℚ)) * X ^ 9 + C ((-4266681744846736 / 235794999 : ℚ)) * X ^ 10 + C ((-4194660522188176 / 235794999 : ℚ)) * X ^ 11 + C ((-1204245686633072 / 78598333 : ℚ)) * X ^ 12 + C ((-2999790695574796 / 235794999 : ℚ)) * X ^ 13 + C ((-2227864415101352 / 235794999 : ℚ)) * X ^ 14 + C ((-112350777182668 / 21435909 : ℚ)) * X ^ 15 + C ((-667737023019656 / 235794999 : ℚ)) * X ^ 16 + C ((-58283782440688 / 78598333 : ℚ)) * X ^ 17 + C ((47397365154080 / 78598333 : ℚ)) * X ^ 18
def CU_021_0_pim : Polynomial ℚ := C ((13343984133224 / 7145303 : ℚ)) + C ((26687968266448 / 7145303 : ℚ)) * X + C ((1044644747265536 / 235794999 : ℚ)) * X ^ 2 + C ((410058292357104 / 78598333 : ℚ)) * X ^ 3 + C ((926262281845544 / 235794999 : ℚ)) * X ^ 4 + C ((322454654576180 / 235794999 : ℚ)) * X ^ 5 + C ((-160880877375868 / 235794999 : ℚ)) * X ^ 6 + C ((-290143741358172 / 78598333 : ℚ)) * X ^ 7 + C ((-1278144009571424 / 235794999 : ℚ)) * X ^ 8 + C ((-1266138372164476 / 235794999 : ℚ)) * X ^ 9 + C ((-1210906080110392 / 235794999 : ℚ)) * X ^ 10 + C ((-1570425726623536 / 235794999 : ℚ)) * X ^ 11 + C ((-1929945373136680 / 235794999 : ℚ)) * X ^ 12 + C ((-679551625185116 / 78598333 : ℚ)) * X ^ 13 + C ((-737393122651392 / 78598333 : ℚ)) * X ^ 14 + C ((-1943311147497820 / 235794999 : ℚ)) * X ^ 15 + C ((-470139482662408 / 78598333 : ℚ)) * X ^ 16 + C ((-337101276555792 / 78598333 : ℚ)) * X ^ 17 + C ((-124222803575832 / 78598333 : ℚ)) * X ^ 18
theorem CU_021_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_011 - CU_0_im_010 * Fplus_dU_im_011 = CU_021_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010, CU_0_im_010, Fplus_dU_re_011, Fplus_dU_im_011, CU_021_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_011 + CU_0_im_010 * Fplus_dU_re_011 = CU_021_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010, CU_0_im_010, Fplus_dU_re_011, Fplus_dU_im_011, CU_021_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_0_mul :
    CU_0_c_010 * Fplus_dU_c_011 = ofLadj CU_021_0_pre CU_021_0_pim := by
  rw [CU_0_c_010, Fplus_dU_c_011, ofLadj_mul, CU_021_0_pre_eq, CU_021_0_pim_eq]

def CU_021_1_pre : Polynomial ℚ := C ((402283896356 / 235794999 : ℚ)) + C ((795658057877840 / 235794999 : ℚ)) * X + C ((45651014001146 / 7145303 : ℚ)) * X ^ 2 + C ((2594844621769234 / 235794999 : ℚ)) * X ^ 3 + C ((4234179871759898 / 235794999 : ℚ)) * X ^ 4 + C ((5463526857810620 / 235794999 : ℚ)) * X ^ 5 + C ((6660843801450766 / 235794999 : ℚ)) * X ^ 6 + C ((2541972204387196 / 78598333 : ℚ)) * X ^ 7 + C ((2584431568756316 / 78598333 : ℚ)) * X ^ 8 + C ((8023961364602068 / 235794999 : ℚ)) * X ^ 9 + C ((8230565570168786 / 235794999 : ℚ)) * X ^ 10 + C ((8307064796433808 / 235794999 : ℚ)) * X ^ 11 + C ((2478302504096982 / 78598333 : ℚ)) * X ^ 12 + C ((6517477902564250 / 235794999 : ℚ)) * X ^ 13 + C ((5158450084499714 / 235794999 : ℚ)) * X ^ 14 + C ((99102251025374 / 7145303 : ℚ)) * X ^ 15 + C ((631110992481626 / 78598333 : ℚ)) * X ^ 16 + C ((696016033804732 / 235794999 : ℚ)) * X ^ 17 + C ((-11032950687668 / 21435909 : ℚ)) * X ^ 18
def CU_021_1_pim : Polynomial ℚ := C ((-734695299364724 / 235794999 : ℚ)) + C ((-1469390598729448 / 235794999 : ℚ)) * X + C ((-1985570065508302 / 235794999 : ℚ)) * X ^ 2 + C ((-929531490779222 / 78598333 : ℚ)) * X ^ 3 + C ((-2917576298802830 / 235794999 : ℚ)) * X ^ 4 + C ((-864858008799852 / 78598333 : ℚ)) * X ^ 5 + C ((-2275271928981878 / 235794999 : ℚ)) * X ^ 6 + C ((-451514534950032 / 78598333 : ℚ)) * X ^ 7 + C ((-695202701853584 / 235794999 : ℚ)) * X ^ 8 + C ((-218761008916292 / 78598333 : ℚ)) * X ^ 9 + C ((-477144872377190 / 235794999 : ℚ)) * X ^ 10 + C ((519796305982672 / 235794999 : ℚ)) * X ^ 11 + C ((1516737484342534 / 235794999 : ℚ)) * X ^ 12 + C ((2212055105493074 / 235794999 : ℚ)) * X ^ 13 + C ((1017999729142382 / 78598333 : ℚ)) * X ^ 14 + C ((1023117235380274 / 78598333 : ℚ)) * X ^ 15 + C ((2516297907311162 / 235794999 : ℚ)) * X ^ 16 + C ((1923750061306168 / 235794999 : ℚ)) * X ^ 17 + C ((257656736916000 / 78598333 : ℚ)) * X ^ 18
theorem CU_021_1_pre_eq :
    CU_0_re_001 * Fplus_dU_re_020 - CU_0_im_001 * Fplus_dU_im_020 = CU_021_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001, CU_0_im_001, Fplus_dU_re_020, Fplus_dU_im_020, CU_021_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_1_pim_eq :
    CU_0_re_001 * Fplus_dU_im_020 + CU_0_im_001 * Fplus_dU_re_020 = CU_021_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001, CU_0_im_001, Fplus_dU_re_020, Fplus_dU_im_020, CU_021_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_1_mul :
    CU_0_c_001 * Fplus_dU_c_020 = ofLadj CU_021_1_pre CU_021_1_pim := by
  rw [CU_0_c_001, Fplus_dU_c_020, ofLadj_mul, CU_021_1_pre_eq, CU_021_1_pim_eq]

def CU_021_2_pre : Polynomial ℚ := C ((110695819919152 / 235794999 : ℚ)) + C ((1548595579000736 / 235794999 : ℚ)) * X + C ((3072086654116244 / 235794999 : ℚ)) * X ^ 2 + C ((5031482165496236 / 235794999 : ℚ)) * X ^ 3 + C ((7505447811960248 / 235794999 : ℚ)) * X ^ 4 + C ((8940606672456092 / 235794999 : ℚ)) * X ^ 5 + C ((10110973419331348 / 235794999 : ℚ)) * X ^ 6 + C ((10816253606497232 / 235794999 : ℚ)) * X ^ 7 + C ((3436121612184300 / 78598333 : ℚ)) * X ^ 8 + C ((10191755307506216 / 235794999 : ℚ)) * X ^ 9 + C ((306148517609912 / 7145303 : ℚ)) * X ^ 10 + C ((82308015165896 / 1948719 : ℚ)) * X ^ 11 + C ((8554305502126360 / 235794999 : ℚ)) * X ^ 12 + C ((2373222884463324 / 78598333 : ℚ)) * X ^ 13 + C ((5276882671056664 / 235794999 : ℚ)) * X ^ 14 + C ((970009829658460 / 78598333 : ℚ)) * X ^ 15 + C ((1538257358776196 / 235794999 : ℚ)) * X ^ 16 + C ((122630203966980 / 78598333 : ℚ)) * X ^ 17 + C ((-133592101853868 / 78598333 : ℚ)) * X ^ 18
def CU_021_2_pim : Polynomial ℚ := C ((-351350787813792 / 78598333 : ℚ)) + C ((-702701575627584 / 78598333 : ℚ)) * X + C ((-2471248436621116 / 235794999 : ℚ)) * X ^ 2 + C ((-2967606176654956 / 235794999 : ℚ)) * X ^ 3 + C ((-2279348859147392 / 235794999 : ℚ)) * X ^ 4 + C ((-879801240452732 / 235794999 : ℚ)) * X ^ 5 + C ((258275765668220 / 235794999 : ℚ)) * X ^ 6 + C ((1960191352830680 / 235794999 : ℚ)) * X ^ 7 + C ((2957268095223460 / 235794999 : ℚ)) * X ^ 8 + C ((980157254756576 / 78598333 : ℚ)) * X ^ 9 + C ((86764356788952 / 7145303 : ℚ)) * X ^ 10 + C ((1268176955477464 / 78598333 : ℚ)) * X ^ 11 + C ((1581945986276456 / 78598333 : ℚ)) * X ^ 12 + C ((5031733678333420 / 235794999 : ℚ)) * X ^ 13 + C ((1837098362471176 / 78598333 : ℚ)) * X ^ 14 + C ((4872070636931804 / 235794999 : ℚ)) * X ^ 15 + C ((324689400773524 / 21435909 : ℚ)) * X ^ 16 + C ((2550899072257780 / 235794999 : ℚ)) * X ^ 17 + C ((7835073350140 / 1948719 : ℚ)) * X ^ 18
theorem CU_021_2_pre_eq :
    CU_1_re_010 * Fplus_dV_re_011 - CU_1_im_010 * Fplus_dV_im_011 = CU_021_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010, CU_1_im_010, Fplus_dV_re_011, Fplus_dV_im_011, CU_021_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_2_pim_eq :
    CU_1_re_010 * Fplus_dV_im_011 + CU_1_im_010 * Fplus_dV_re_011 = CU_021_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010, CU_1_im_010, Fplus_dV_re_011, Fplus_dV_im_011, CU_021_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_2_mul :
    CU_1_c_010 * Fplus_dV_c_011 = ofLadj CU_021_2_pre CU_021_2_pim := by
  rw [CU_1_c_010, Fplus_dV_c_011, ofLadj_mul, CU_021_2_pre_eq, CU_021_2_pim_eq]

def CU_021_3_pre : Polynomial ℚ := C ((-2038292303736 / 7145303 : ℚ)) + C ((-217317998116224 / 78598333 : ℚ)) * X + C ((-378351995091080 / 78598333 : ℚ)) * X ^ 2 + C ((-611051573129570 / 78598333 : ℚ)) * X ^ 3 + C ((-923216977398062 / 78598333 : ℚ)) * X ^ 4 + C ((-1049623226596218 / 78598333 : ℚ)) * X ^ 5 + C ((-1203942397829330 / 78598333 : ℚ)) * X ^ 6 + C ((-125611449168958 / 7145303 : ℚ)) * X ^ 7 + C ((-128618684001264 / 7145303 : ℚ)) * X ^ 8 + C ((-138663062632064 / 7145303 : ℚ)) * X ^ 9 + C ((-146331266443536 / 7145303 : ℚ)) * X ^ 10 + C ((-147151195313488 / 7145303 : ℚ)) * X ^ 11 + C ((-1392325932762672 / 78598333 : ℚ)) * X ^ 12 + C ((-1146941693861624 / 78598333 : ℚ)) * X ^ 13 + C ((-803753950884334 / 78598333 : ℚ)) * X ^ 14 + C ((-390056017102152 / 78598333 : ℚ)) * X ^ 15 + C ((-203312754280340 / 78598333 : ℚ)) * X ^ 16 + C ((-48993583047228 / 78598333 : ℚ)) * X ^ 17 + C ((6222995123484 / 7145303 : ℚ)) * X ^ 18
def CU_021_3_pim : Polynomial ℚ := C ((124613141152092 / 78598333 : ℚ)) + C ((249226282304184 / 78598333 : ℚ)) * X + C ((287065654444420 / 78598333 : ℚ)) * X ^ 2 + C ((372409214049254 / 78598333 : ℚ)) * X ^ 3 + C ((279992398927330 / 78598333 : ℚ)) * X ^ 4 + C ((11474675627746 / 7145303 : ℚ)) * X ^ 5 + C ((85010737299882 / 78598333 : ℚ)) * X ^ 6 + C ((-71465371364058 / 78598333 : ℚ)) * X ^ 7 + C ((-190537957515704 / 78598333 : ℚ)) * X ^ 8 + C ((-206426162916764 / 78598333 : ℚ)) * X ^ 9 + C ((-279526248458364 / 78598333 : ℚ)) * X ^ 10 + C ((-511230061783356 / 78598333 : ℚ)) * X ^ 11 + C ((-67539443191668 / 7145303 : ℚ)) * X ^ 12 + C ((-853873332790184 / 78598333 : ℚ)) * X ^ 13 + C ((-955105097796078 / 78598333 : ℚ)) * X ^ 14 + C ((-816313233248732 / 78598333 : ℚ)) * X ^ 15 + C ((-568643109379992 / 78598333 : ℚ)) * X ^ 16 + C ((-415822901087624 / 78598333 : ℚ)) * X ^ 17 + C ((-165447635577068 / 78598333 : ℚ)) * X ^ 18
theorem CU_021_3_pre_eq :
    CU_1_re_001 * Fplus_dV_re_020 - CU_1_im_001 * Fplus_dV_im_020 = CU_021_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001, CU_1_im_001, Fplus_dV_re_020, Fplus_dV_im_020, CU_021_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_3_pim_eq :
    CU_1_re_001 * Fplus_dV_im_020 + CU_1_im_001 * Fplus_dV_re_020 = CU_021_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001, CU_1_im_001, Fplus_dV_re_020, Fplus_dV_im_020, CU_021_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_3_mul :
    CU_1_c_001 * Fplus_dV_c_020 = ofLadj CU_021_3_pre CU_021_3_pim := by
  rw [CU_1_c_001, Fplus_dV_c_020, ofLadj_mul, CU_021_3_pre_eq, CU_021_3_pim_eq]

def CU_021_4_pre : Polynomial ℚ := C ((737141301300 / 78598333 : ℚ)) + C ((-54381789792592 / 235794999 : ℚ)) * X + C ((-38753684588748 / 78598333 : ℚ)) * X ^ 2 + C ((-66352134875252 / 78598333 : ℚ)) * X ^ 3 + C ((-316564399995748 / 235794999 : ℚ)) * X ^ 4 + C ((-136465624033336 / 78598333 : ℚ)) * X ^ 5 + C ((-482425231489988 / 235794999 : ℚ)) * X ^ 6 + C ((-504142119290284 / 235794999 : ℚ)) * X ^ 7 + C ((-455370845299952 / 235794999 : ℚ)) * X ^ 8 + C ((-38278789150600 / 21435909 : ℚ)) * X ^ 9 + C ((-131693698989356 / 78598333 : ℚ)) * X ^ 10 + C ((-129250356346824 / 78598333 : ℚ)) * X ^ 11 + C ((-340699307175476 / 235794999 : ℚ)) * X ^ 12 + C ((-304805626890356 / 235794999 : ℚ)) * X ^ 13 + C ((-256314440674196 / 235794999 : ℚ)) * X ^ 14 + C ((-170253868735400 / 235794999 : ℚ)) * X ^ 15 + C ((-95865648781240 / 235794999 : ℚ)) * X ^ 16 + C ((-22837289391260 / 235794999 : ℚ)) * X ^ 17 + C ((1574895505376 / 21435909 : ℚ)) * X ^ 18
def CU_021_4_pim : Polynomial ℚ := C ((58333507630604 / 235794999 : ℚ)) + C ((116667015261208 / 235794999 : ℚ)) * X + C ((48359897779692 / 78598333 : ℚ)) * X ^ 2 + C ((183909763386436 / 235794999 : ℚ)) * X ^ 3 + C ((179896132911508 / 235794999 : ℚ)) * X ^ 4 + C ((42308258211584 / 78598333 : ℚ)) * X ^ 5 + C ((17889248639700 / 78598333 : ℚ)) * X ^ 6 + C ((-47762955963172 / 235794999 : ℚ)) * X ^ 7 + C ((-103774689212608 / 235794999 : ℚ)) * X ^ 8 + C ((-32933402810104 / 78598333 : ℚ)) * X ^ 9 + C ((-76032696125780 / 235794999 : ℚ)) * X ^ 10 + C ((-33801207999432 / 78598333 : ℚ)) * X ^ 11 + C ((-126774551870812 / 235794999 : ℚ)) * X ^ 12 + C ((-12038156149468 / 21435909 : ℚ)) * X ^ 13 + C ((-166275306909212 / 235794999 : ℚ)) * X ^ 14 + C ((-176759625514928 / 235794999 : ℚ)) * X ^ 15 + C ((-13896412300352 / 21435909 : ℚ)) * X ^ 16 + C ((-113872217985364 / 235794999 : ℚ)) * X ^ 17 + C ((-13837928056264 / 78598333 : ℚ)) * X ^ 18
theorem CU_021_4_pre_eq :
    CU_2_re_010 * Fplus_dW_re_011 - CU_2_im_010 * Fplus_dW_im_011 = CU_021_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010, CU_2_im_010, Fplus_dW_re_011, Fplus_dW_im_011, CU_021_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_4_pim_eq :
    CU_2_re_010 * Fplus_dW_im_011 + CU_2_im_010 * Fplus_dW_re_011 = CU_021_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010, CU_2_im_010, Fplus_dW_re_011, Fplus_dW_im_011, CU_021_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_4_mul :
    CU_2_c_010 * Fplus_dW_c_011 = ofLadj CU_021_4_pre CU_021_4_pim := by
  rw [CU_2_c_010, Fplus_dW_c_011, ofLadj_mul, CU_021_4_pre_eq, CU_021_4_pim_eq]

def CU_021_5_pre : Polynomial ℚ := C ((-57866982376576 / 235794999 : ℚ)) + C ((-268415658718368 / 78598333 : ℚ)) * X + C ((-1597714793949412 / 235794999 : ℚ)) * X ^ 2 + C ((-2619534376003276 / 235794999 : ℚ)) * X ^ 3 + C ((-355091356855832 / 21435909 : ℚ)) * X ^ 4 + C ((-4651699009692736 / 235794999 : ℚ)) * X ^ 5 + C ((-5262958097301836 / 235794999 : ℚ)) * X ^ 6 + C ((-5629051468483486 / 235794999 : ℚ)) * X ^ 7 + C ((-1787931487201016 / 78598333 : ℚ)) * X ^ 8 + C ((-5303215099904296 / 235794999 : ℚ)) * X ^ 9 + C ((-5256906455459126 / 235794999 : ℚ)) * X ^ 10 + C ((-5181697311084016 / 235794999 : ℚ)) * X ^ 11 + C ((-4451659479304022 / 235794999 : ℚ)) * X ^ 12 + C ((-1235166768651628 / 78598333 : ℚ)) * X ^ 13 + C ((-2744260085599772 / 235794999 : ℚ)) * X ^ 14 + C ((-1513470170817794 / 235794999 : ℚ)) * X ^ 15 + C ((-800975967073780 / 235794999 : ℚ)) * X ^ 16 + C ((-63238959821560 / 78598333 : ℚ)) * X ^ 17 + C ((209576372251540 / 235794999 : ℚ)) * X ^ 18
def CU_021_5_pim : Polynomial ℚ := C ((547965439904656 / 235794999 : ℚ)) + C ((1095930879809312 / 235794999 : ℚ)) * X + C ((1286269751489572 / 235794999 : ℚ)) * X ^ 2 + C ((1544265092486228 / 235794999 : ℚ)) * X ^ 3 + C ((1183758195210904 / 235794999 : ℚ)) * X ^ 4 + C ((457090084111504 / 235794999 : ℚ)) * X ^ 5 + C ((-135589043454724 / 235794999 : ℚ)) * X ^ 6 + C ((-31009156277158 / 7145303 : ℚ)) * X ^ 7 + C ((-1541744369065916 / 235794999 : ℚ)) * X ^ 8 + C ((-511013857421228 / 78598333 : ℚ)) * X ^ 9 + C ((-1493005871719786 / 235794999 : ℚ)) * X ^ 10 + C ((-1982145543986752 / 235794999 : ℚ)) * X ^ 11 + C ((-2471285216253718 / 235794999 : ℚ)) * X ^ 12 + C ((-2621588387390080 / 235794999 : ℚ)) * X ^ 13 + C ((-956960310528168 / 78598333 : ℚ)) * X ^ 14 + C ((-2535767969821718 / 235794999 : ℚ)) * X ^ 15 + C ((-620197217122668 / 78598333 : ℚ)) * X ^ 16 + C ((-443089865817656 / 78598333 : ℚ)) * X ^ 17 + C ((-493048276407164 / 235794999 : ℚ)) * X ^ 18
theorem CU_021_5_pre_eq :
    CU_2_re_001 * Fplus_dW_re_020 - CU_2_im_001 * Fplus_dW_im_020 = CU_021_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001, CU_2_im_001, Fplus_dW_re_020, Fplus_dW_im_020, CU_021_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_5_pim_eq :
    CU_2_re_001 * Fplus_dW_im_020 + CU_2_im_001 * Fplus_dW_re_020 = CU_021_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001, CU_2_im_001, Fplus_dW_re_020, Fplus_dW_im_020, CU_021_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_5_mul :
    CU_2_c_001 * Fplus_dW_c_020 = ofLadj CU_021_5_pre CU_021_5_pim := by
  rw [CU_2_c_001, Fplus_dW_c_020, ofLadj_mul, CU_021_5_pre_eq, CU_021_5_pim_eq]

def CU_021_6_pre : Polynomial ℚ := C ((-6868108296 / 7145303 : ℚ)) + C ((61027640240 / 21435909 : ℚ)) * X ^ 2 + C ((145410935224 / 21435909 : ℚ)) * X ^ 3 + C ((73867307664 / 7145303 : ℚ)) * X ^ 4 + C ((87695390864 / 7145303 : ℚ)) * X ^ 5 + C ((87695390864 / 7145303 : ℚ)) * X ^ 6 + C ((73867307664 / 7145303 : ℚ)) * X ^ 7 + C ((145410935224 / 21435909 : ℚ)) * X ^ 8 + C ((61027640240 / 21435909 : ℚ)) * X ^ 9
def CU_021_6_pim : Polynomial ℚ := C ((-282922903688 / 78598333 : ℚ)) + C ((-565845807376 / 78598333 : ℚ)) * X + C ((-2322949837216 / 235794999 : ℚ)) * X ^ 2 + C ((-821530925496 / 78598333 : ℚ)) * X ^ 3 + C ((-685680321504 / 78598333 : ℚ)) * X ^ 4 + C ((-1284386879440 / 235794999 : ℚ)) * X ^ 5 + C ((-413150542688 / 235794999 : ℚ)) * X ^ 6 + C ((119834514128 / 78598333 : ℚ)) * X ^ 7 + C ((255685118120 / 78598333 : ℚ)) * X ^ 8 + C ((625412415088 / 235794999 : ℚ)) * X ^ 9
theorem CU_021_6_neg_re : -CU_3_re_021 = CU_021_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_021, CU_021_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_6_neg_im : -CU_3_im_021 = CU_021_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_021, CU_021_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_021_6_mul : -CU_3_c_021 = ofLadj CU_021_6_pre CU_021_6_pim := by
  rw [CU_3_c_021, ofLadj_neg, CU_021_6_neg_re, CU_021_6_neg_im]

@[expose] public def CU_coeff_021 : Ki := CU_0_c_010 * Fplus_dU_c_011 + CU_0_c_001 * Fplus_dU_c_020 + CU_1_c_010 * Fplus_dV_c_011 + CU_1_c_001 * Fplus_dV_c_020 + CU_2_c_010 * Fplus_dW_c_011 + CU_2_c_001 * Fplus_dW_c_020 + (-CU_3_c_021)

theorem CU_coeff_021_sum :
    CU_coeff_021 = ofLadj (CU_021_0_pre + CU_021_1_pre + CU_021_2_pre + CU_021_3_pre + CU_021_4_pre + CU_021_5_pre + CU_021_6_pre) (CU_021_0_pim + CU_021_1_pim + CU_021_2_pim + CU_021_3_pim + CU_021_4_pim + CU_021_5_pim + CU_021_6_pim) := by
  simp only [CU_coeff_021, CU_021_0_mul, CU_021_1_mul, CU_021_2_mul, CU_021_3_mul, CU_021_4_mul, CU_021_5_mul, CU_021_6_mul]
  simp [ofLadj_add, add_assoc]

def CU_021_qre : Polynomial ℚ := C ((-60370722464192 / 235794999 : ℚ)) + C ((239096914098880 / 235794999 : ℚ)) * X + C ((220914523801262 / 235794999 : ℚ)) * X ^ 2 + C ((390592884421258 / 235794999 : ℚ)) * X ^ 3 + C ((234992942861444 / 78598333 : ℚ)) * X ^ 4 + C ((833579698438346 / 235794999 : ℚ)) * X ^ 5 + C ((727553054119394 / 235794999 : ℚ)) * X ^ 6 + C ((477207986164048 / 235794999 : ℚ)) * X ^ 7 + C ((52312394221936 / 235794999 : ℚ)) * X ^ 8
def CU_021_qim : Polynomial ℚ := C ((-369106584129236 / 235794999 : ℚ)) + C ((-369106584129236 / 235794999 : ℚ)) * X + C ((-383737128280718 / 235794999 : ℚ)) * X ^ 2 + C ((-561137570138182 / 235794999 : ℚ)) * X ^ 3 + C ((-386000525487416 / 235794999 : ℚ)) * X ^ 4 + C ((-40479150842962 / 78598333 : ℚ)) * X ^ 5 + C ((185346567825482 / 235794999 : ℚ)) * X ^ 6 + C ((455294077115084 / 235794999 : ℚ)) * X ^ 7 + C ((317440708080284 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_021_poly_re :
    CU_021_0_pre + CU_021_1_pre + CU_021_2_pre + CU_021_3_pre + CU_021_4_pre + CU_021_5_pre + CU_021_6_pre = (0 : Polynomial ℚ) + Phi11 * CU_021_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_021_0_pre, CU_021_1_pre, CU_021_2_pre, CU_021_3_pre, CU_021_4_pre, CU_021_5_pre, CU_021_6_pre, CU_021_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_021_poly_im :
    CU_021_0_pim + CU_021_1_pim + CU_021_2_pim + CU_021_3_pim + CU_021_4_pim + CU_021_5_pim + CU_021_6_pim = (0 : Polynomial ℚ) + Phi11 * CU_021_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_021_0_pim, CU_021_1_pim, CU_021_2_pim, CU_021_3_pim, CU_021_4_pim, CU_021_5_pim, CU_021_6_pim, CU_021_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CU_coeff_021_eq :
    CU_coeff_021 = (0 : Ki) := by
  rw [CU_coeff_021_sum, CU_coeff_021_poly_re,
    CU_coeff_021_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
