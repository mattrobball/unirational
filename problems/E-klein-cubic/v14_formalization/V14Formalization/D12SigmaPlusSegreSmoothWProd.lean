/-
Auto-generated Fplus chart Bézout product identities.
-/
import V14Formalization.D12SigmaPlusSegreEval
import V14Formalization.D12SigmaPlusSegreSmoothU
import V14Formalization.D12SigmaPlusSegreSmoothV
import V14Formalization.D12SigmaPlusSegreSmoothW

noncomputable section
open Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def WP0_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def WP0_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def WP0_F : Ki := ofLadj WP0_Fre WP0_Fim
def WP0_pre : Polynomial ℚ := C ((27572445123 / 505929314 : ℚ)) + C ((37217564 / 534809 : ℚ)) * X ^ 2 + C ((854396112 / 252964657 : ℚ)) * X ^ 3 + C ((-5239083001 / 91987148 : ℚ)) * X ^ 4 + C ((-48176390755 / 505929314 : ℚ)) * X ^ 5 + C ((-222154746215 / 1011858628 : ℚ)) * X ^ 6 + C ((-5837941383 / 22996787 : ℚ)) * X ^ 7 + C ((-131528430317 / 505929314 : ℚ)) * X ^ 8 + C ((-262699169961 / 1011858628 : ℚ)) * X ^ 9 + C ((-279520645153 / 1011858628 : ℚ)) * X ^ 10 + C ((-82572779230 / 252964657 : ℚ)) * X ^ 11 + C ((-279520645153 / 1011858628 : ℚ)) * X ^ 12 + C ((-333114801049 / 1011858628 : ℚ)) * X ^ 13 + C ((-133237222541 / 505929314 : ℚ)) * X ^ 14 + C ((-182758109775 / 1011858628 : ℚ)) * X ^ 15 + C ((-147309090829 / 1011858628 : ℚ)) * X ^ 16 + C ((-44436211 / 2090617 : ℚ)) * X ^ 17 + C ((8240699033 / 505929314 : ℚ)) * X ^ 18
def WP0_pim : Polynomial ℚ := C ((13862995305 / 252964657 : ℚ)) + C ((27725990610 / 252964657 : ℚ)) * X + C ((37149439917 / 252964657 : ℚ)) * X ^ 2 + C ((71839003919 / 252964657 : ℚ)) * X ^ 3 + C ((271480221839 / 1011858628 : ℚ)) * X ^ 4 + C ((8034885534 / 22996787 : ℚ)) * X ^ 5 + C ((173738401147 / 505929314 : ℚ)) * X ^ 6 + C ((285015951865 / 1011858628 : ℚ)) * X ^ 7 + C ((136086137905 / 505929314 : ℚ)) * X ^ 8 + C ((141530452405 / 505929314 : ℚ)) * X ^ 9 + C ((66136104211 / 252964657 : ℚ)) * X ^ 10 + C ((4620998435 / 22996787 : ℚ)) * X ^ 11 + C ((35525861359 / 252964657 : ℚ)) * X ^ 12 + C ((42946580121 / 505929314 : ℚ)) * X ^ 13 + C ((-20988233383 / 505929314 : ℚ)) * X ^ 14 + C ((-7815545373 / 252964657 : ℚ)) * X ^ 15 + C ((-48409186531 / 505929314 : ℚ)) * X ^ 16 + C ((-21660392002 / 252964657 : ℚ)) * X ^ 17 + C ((-1920541873 / 252964657 : ℚ)) * X ^ 18
theorem WP0_pre_eq :
    WA_0_0_re * WP0_Fre - WA_0_0_im * WP0_Fim = WP0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP0_Fre, WP0_Fim, WP0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP0_pim_eq :
    WA_0_0_re * WP0_Fim + WA_0_0_im * WP0_Fre = WP0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP0_Fre, WP0_Fim, WP0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP0_mul : WA_0_0 * WP0_F = ofLadj WP0_pre WP0_pim := by
  rw [WA_0_0, WP0_F, ofLadj_mul, WP0_pre_eq, WP0_pim_eq]

def WP1_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def WP1_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def WP1_F : Ki := ofLadj WP1_Fre WP1_Fim
def WP1_pre : Polynomial ℚ := C ((15283903849 / 252964657 : ℚ)) + C ((-73935974960 / 758893971 : ℚ)) * X + C ((-17840076713 / 252964657 : ℚ)) * X ^ 2 + C ((-2899742327 / 12543702 : ℚ)) * X ^ 3 + C ((-116290948399 / 252964657 : ℚ)) * X ^ 4 + C ((-117045374007 / 252964657 : ℚ)) * X ^ 5 + C ((-1125957637469 / 1517787942 : ℚ)) * X ^ 6 + C ((-182275303988 / 252964657 : ℚ)) * X ^ 7 + C ((-28106249643 / 45993574 : ℚ)) * X ^ 8 + C ((-469761639686 / 758893971 : ℚ)) * X ^ 9 + C ((-132911487485 / 252964657 : ℚ)) * X ^ 10 + C ((-491420451001 / 758893971 : ℚ)) * X ^ 11 + C ((-324798487495 / 758893971 : ℚ)) * X ^ 12 + C ((-416241409547 / 758893971 : ℚ)) * X ^ 13 + C ((-26210791666 / 68990361 : ℚ)) * X ^ 14 + C ((-57087146115 / 252964657 : ℚ)) * X ^ 15 + C ((-56612670649 / 252964657 : ℚ)) * X ^ 16 + C ((84009369533 / 1517787942 : ℚ)) * X ^ 17 + C ((8897209474 / 252964657 : ℚ)) * X ^ 18
def WP1_pim : Polynomial ℚ := C ((83075608172 / 758893971 : ℚ)) + C ((166151216344 / 758893971 : ℚ)) * X + C ((55360151857 / 252964657 : ℚ)) * X ^ 2 + C ((668099028323 / 1517787942 : ℚ)) * X ^ 3 + C ((234341977454 / 758893971 : ℚ)) * X ^ 4 + C ((22093402256 / 68990361 : ℚ)) * X ^ 5 + C ((145579900513 / 505929314 : ℚ)) * X ^ 6 + C ((-7549275974 / 758893971 : ℚ)) * X ^ 7 + C ((18237503247 / 505929314 : ℚ)) * X ^ 8 + C ((-525863953 / 758893971 : ℚ)) * X ^ 9 + C ((14249997712 / 252964657 : ℚ)) * X ^ 10 + C ((-6300170324 / 252964657 : ℚ)) * X ^ 11 + C ((-26850338360 / 252964657 : ℚ)) * X ^ 12 + C ((-37204397218 / 758893971 : ℚ)) * X ^ 13 + C ((-77685191544 / 252964657 : ℚ)) * X ^ 14 + C ((-104057164349 / 758893971 : ℚ)) * X ^ 15 + C ((-191788201324 / 758893971 : ℚ)) * X ^ 16 + C ((-282517759723 / 1517787942 : ℚ)) * X ^ 17 + C ((1871552423 / 252964657 : ℚ)) * X ^ 18
theorem WP1_pre_eq :
    WA_0_0_re * WP1_Fre - WA_0_0_im * WP1_Fim = WP1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP1_Fre, WP1_Fim, WP1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP1_pim_eq :
    WA_0_0_re * WP1_Fim + WA_0_0_im * WP1_Fre = WP1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP1_Fre, WP1_Fim, WP1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP1_mul : WA_0_0 * WP1_F = ofLadj WP1_pre WP1_pim := by
  rw [WA_0_0, WP1_F, ofLadj_mul, WP1_pre_eq, WP1_pim_eq]

def WP2_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def WP2_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def WP2_F : Ki := ofLadj WP2_Fre WP2_Fim
def WP2_pre : Polynomial ℚ := C ((-3304891412 / 68990361 : ℚ)) + C ((295743899840 / 758893971 : ℚ)) * X + C ((133963352670 / 252964657 : ℚ)) * X ^ 2 + C ((750763369888 / 758893971 : ℚ)) * X ^ 3 + C ((1180704216358 / 758893971 : ℚ)) * X ^ 4 + C ((352921671945 / 252964657 : ℚ)) * X ^ 5 + C ((2988104051239 / 1517787942 : ℚ)) * X ^ 6 + C ((1349351031476 / 758893971 : ℚ)) * X ^ 7 + C ((38054398124 / 22996787 : ℚ)) * X ^ 8 + C ((416810596094 / 252964657 : ℚ)) * X ^ 9 + C ((814423098007 / 505929314 : ℚ)) * X ^ 10 + C ((419307228766 / 252964657 : ℚ)) * X ^ 11 + C ((1851781494341 / 1517787942 : ℚ)) * X ^ 12 + C ((282847243424 / 252964657 : ℚ)) * X ^ 13 + C ((505031768204 / 758893971 : ℚ)) * X ^ 14 + C ((9660760900 / 68990361 : ℚ)) * X ^ 15 + C ((156571409053 / 505929314 : ℚ)) * X ^ 16 + C ((-18220899655 / 68990361 : ℚ)) * X ^ 17 + C ((-62378445218 / 758893971 : ℚ)) * X ^ 18
def WP2_pim : Polynomial ℚ := C ((-184430482768 / 758893971 : ℚ)) + C ((-368860965536 / 758893971 : ℚ)) * X + C ((-93449890370 / 252964657 : ℚ)) * X ^ 2 + C ((-560656290697 / 758893971 : ℚ)) * X ^ 3 + C ((-125184440404 / 758893971 : ℚ)) * X ^ 4 + C ((-7599017617 / 68990361 : ℚ)) * X ^ 5 + C ((113084001673 / 1517787942 : ℚ)) * X ^ 6 + C ((446137737872 / 758893971 : ℚ)) * X ^ 7 + C ((133663053060 / 252964657 : ℚ)) * X ^ 8 + C ((137362252702 / 252964657 : ℚ)) * X ^ 9 + C ((780836802127 / 1517787942 : ℚ)) * X ^ 10 + C ((556185881128 / 758893971 : ℚ)) * X ^ 11 + C ((481302240795 / 505929314 : ℚ)) * X ^ 12 + C ((203924569908 / 252964657 : ℚ)) * X ^ 13 + C ((903177928237 / 758893971 : ℚ)) * X ^ 14 + C ((461693484194 / 758893971 : ℚ)) * X ^ 15 + C ((893598889129 / 1517787942 : ℚ)) * X ^ 16 + C ((323758545106 / 758893971 : ℚ)) * X ^ 17 + C ((-13045328314 / 252964657 : ℚ)) * X ^ 18
theorem WP2_pre_eq :
    WA_0_0_re * WP2_Fre - WA_0_0_im * WP2_Fim = WP2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP2_Fre, WP2_Fim, WP2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP2_pim_eq :
    WA_0_0_re * WP2_Fim + WA_0_0_im * WP2_Fre = WP2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP2_Fre, WP2_Fim, WP2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP2_mul : WA_0_0 * WP2_F = ofLadj WP2_pre WP2_pim := by
  rw [WA_0_0, WP2_F, ofLadj_mul, WP2_pre_eq, WP2_pim_eq]

def WP3_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def WP3_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def WP3_F : Ki := ofLadj WP3_Fre WP3_Fim
def WP3_pre : Polynomial ℚ := C ((110033871347 / 1517787942 : ℚ)) + C ((-92419968700 / 758893971 : ℚ)) * X + C ((-102845572307 / 1517787942 : ℚ)) * X ^ 2 + C ((-449597708363 / 1517787942 : ℚ)) * X ^ 3 + C ((-793548256823 / 1517787942 : ℚ)) * X ^ 4 + C ((-815701053305 / 1517787942 : ℚ)) * X ^ 5 + C ((-1333508554871 / 1517787942 : ℚ)) * X ^ 6 + C ((-220922137714 / 252964657 : ℚ)) * X ^ 7 + C ((-1372331242169 / 1517787942 : ℚ)) * X ^ 8 + C ((-1353467814913 / 1517787942 : ℚ)) * X ^ 9 + C ((-249559366960 / 252964657 : ℚ)) * X ^ 10 + C ((-68125341995 / 68990361 : ℚ)) * X ^ 11 + C ((-656258132180 / 758893971 : ℚ)) * X ^ 12 + C ((-56846465573 / 68990361 : ℚ)) * X ^ 13 + C ((-153788922301 / 252964657 : ℚ)) * X ^ 14 + C ((-151916922647 / 505929314 : ℚ)) * X ^ 15 + C ((-150203621225 / 505929314 : ℚ)) * X ^ 16 + C ((22398879297 / 505929314 : ℚ)) * X ^ 17 + C ((38116900760 / 758893971 : ℚ)) * X ^ 18
def WP3_pim : Polynomial ℚ := C ((67689340665 / 505929314 : ℚ)) + C ((67689340665 / 252964657 : ℚ)) * X + C ((9727465873 / 35297394 : ℚ)) * X ^ 2 + C ((437873869717 / 758893971 : ℚ)) * X ^ 3 + C ((588066371485 / 1517787942 : ℚ)) * X ^ 4 + C ((134066810178 / 252964657 : ℚ)) * X ^ 5 + C ((115514492845 / 252964657 : ℚ)) * X ^ 6 + C ((150237296569 / 505929314 : ℚ)) * X ^ 7 + C ((66287280987 / 252964657 : ℚ)) * X ^ 8 + C ((231232334731 / 758893971 : ℚ)) * X ^ 9 + C ((180639340045 / 758893971 : ℚ)) * X ^ 10 + C ((64173331550 / 758893971 : ℚ)) * X ^ 11 + C ((-17430892315 / 252964657 : ℚ)) * X ^ 12 + C ((-217916331811 / 1517787942 : ℚ)) * X ^ 13 + C ((-9252152351 / 22996787 : ℚ)) * X ^ 14 + C ((-529686176 / 2090617 : ℚ)) * X ^ 15 + C ((-437886493171 / 1517787942 : ℚ)) * X ^ 16 + C ((-12023392569 / 45993574 : ℚ)) * X ^ 17 + C ((4301636387 / 758893971 : ℚ)) * X ^ 18
theorem WP3_pre_eq :
    WA_0_0_re * WP3_Fre - WA_0_0_im * WP3_Fim = WP3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP3_Fre, WP3_Fim, WP3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP3_pim_eq :
    WA_0_0_re * WP3_Fim + WA_0_0_im * WP3_Fre = WP3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP3_Fre, WP3_Fim, WP3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP3_mul : WA_0_0 * WP3_F = ofLadj WP3_pre WP3_pim := by
  rw [WA_0_0, WP3_F, ofLadj_mul, WP3_pre_eq, WP3_pim_eq]

def WP4_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP4_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP4_F : Ki := ofLadj WP4_Fre WP4_Fim
def WP4_pre : Polynomial ℚ := C ((128159592284 / 758893971 : ℚ)) + C ((-369679874800 / 758893971 : ℚ)) * X + C ((-144560507482 / 252964657 : ℚ)) * X ^ 2 + C ((-1027930349033 / 758893971 : ℚ)) * X ^ 3 + C ((-543438371252 / 252964657 : ℚ)) * X ^ 4 + C ((-36724560151 / 17648697 : ℚ)) * X ^ 5 + C ((-740084570783 / 252964657 : ℚ)) * X ^ 6 + C ((-2096047018055 / 758893971 : ℚ)) * X ^ 7 + C ((-1975201462534 / 758893971 : ℚ)) * X ^ 8 + C ((-642987404676 / 252964657 : ℚ)) * X ^ 9 + C ((-1901896833730 / 758893971 : ℚ)) * X ^ 10 + C ((-666773724984 / 252964657 : ℚ)) * X ^ 11 + C ((-510738986310 / 252964657 : ℚ)) * X ^ 12 + C ((-498426897194 / 252964657 : ℚ)) * X ^ 13 + C ((-947271113501 / 758893971 : ℚ)) * X ^ 14 + C ((-125148929559 / 252964657 : ℚ)) * X ^ 15 + C ((-154113507521 / 252964657 : ℚ)) * X ^ 16 + C ((178757103293 / 758893971 : ℚ)) * X ^ 17 + C ((90285115622 / 758893971 : ℚ)) * X ^ 18
def WP4_pim : Polynomial ℚ := C ((313716075290 / 758893971 : ℚ)) + C ((627432150580 / 758893971 : ℚ)) * X + C ((600880582598 / 758893971 : ℚ)) * X ^ 2 + C ((368800169707 / 252964657 : ℚ)) * X ^ 3 + C ((538609827590 / 758893971 : ℚ)) * X ^ 4 + C ((188192665425 / 252964657 : ℚ)) * X ^ 5 + C ((363325591997 / 758893971 : ℚ)) * X ^ 6 + C ((-163685711869 / 758893971 : ℚ)) * X ^ 7 + C ((-51431818159 / 252964657 : ℚ)) * X ^ 8 + C ((-47526977899 / 252964657 : ℚ)) * X ^ 9 + C ((-42134620981 / 252964657 : ℚ)) * X ^ 10 + C ((-390246454700 / 758893971 : ℚ)) * X ^ 11 + C ((-59462640587 / 68990361 : ℚ)) * X ^ 12 + C ((-611360407721 / 758893971 : ℚ)) * X ^ 13 + C ((-368388604488 / 252964657 : ℚ)) * X ^ 14 + C ((-558125671109 / 758893971 : ℚ)) * X ^ 15 + C ((-203198684235 / 252964657 : ℚ)) * X ^ 16 + C ((-471368294387 / 758893971 : ℚ)) * X ^ 17 + C ((30140796568 / 758893971 : ℚ)) * X ^ 18
theorem WP4_pre_eq :
    WA_0_0_re * WP4_Fre - WA_0_0_im * WP4_Fim = WP4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP4_Fre, WP4_Fim, WP4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP4_pim_eq :
    WA_0_0_re * WP4_Fim + WA_0_0_im * WP4_Fre = WP4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP4_Fre, WP4_Fim, WP4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP4_mul : WA_0_0 * WP4_F = ofLadj WP4_pre WP4_pim := by
  rw [WA_0_0, WP4_F, ofLadj_mul, WP4_pre_eq, WP4_pim_eq]

def WP5_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def WP5_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def WP5_F : Ki := ofLadj WP5_Fre WP5_Fim
def WP5_pre : Polynomial ℚ := C ((100740692648 / 758893971 : ℚ)) + C ((-258775912360 / 758893971 : ℚ)) * X + C ((-272889054226 / 758893971 : ℚ)) * X ^ 2 + C ((-674582915201 / 758893971 : ℚ)) * X ^ 3 + C ((-2217234881215 / 1517787942 : ℚ)) * X ^ 4 + C ((-1069481350964 / 758893971 : ℚ)) * X ^ 5 + C ((-1580778546233 / 758893971 : ℚ)) * X ^ 6 + C ((-511635241959 / 252964657 : ℚ)) * X ^ 7 + C ((-1478415248729 / 758893971 : ℚ)) * X ^ 8 + C ((-3033797617889 / 1517787942 : ℚ)) * X ^ 9 + C ((-3034862511833 / 1517787942 : ℚ)) * X ^ 10 + C ((-1640342331131 / 758893971 : ℚ)) * X ^ 11 + C ((-839103562371 / 505929314 : ℚ)) * X ^ 12 + C ((-75394530589 / 45993574 : ℚ)) * X ^ 13 + C ((-267944111176 / 252964657 : ℚ)) * X ^ 14 + C ((-236302732691 / 505929314 : ℚ)) * X ^ 15 + C ((-253057135757 / 505929314 : ℚ)) * X ^ 16 + C ((87807661089 / 505929314 : ℚ)) * X ^ 17 + C ((71834186233 / 758893971 : ℚ)) * X ^ 18
def WP5_pim : Polynomial ℚ := C ((230691648947 / 758893971 : ℚ)) + C ((461383297894 / 758893971 : ℚ)) * X + C ((444852179825 / 758893971 : ℚ)) * X ^ 2 + C ((848633217532 / 758893971 : ℚ)) * X ^ 3 + C ((318821856691 / 505929314 : ℚ)) * X ^ 4 + C ((542654789768 / 758893971 : ℚ)) * X ^ 5 + C ((913392332671 / 1517787942 : ℚ)) * X ^ 6 + C ((43292077243 / 505929314 : ℚ)) * X ^ 7 + C ((75290891565 / 505929314 : ℚ)) * X ^ 8 + C ((197651038241 / 1517787942 : ℚ)) * X ^ 9 + C ((364339369 / 3208854 : ℚ)) * X ^ 10 + C ((-167813753972 / 758893971 : ℚ)) * X ^ 11 + C ((-843587537425 / 1517787942 : ℚ)) * X ^ 12 + C ((-278614605997 / 505929314 : ℚ)) * X ^ 13 + C ((-1671627529859 / 1517787942 : ℚ)) * X ^ 14 + C ((-39827287864 / 68990361 : ℚ)) * X ^ 15 + C ((-166502819061 / 252964657 : ℚ)) * X ^ 16 + C ((-748173417941 / 1517787942 : ℚ)) * X ^ 17 + C ((20685055553 / 758893971 : ℚ)) * X ^ 18
theorem WP5_pre_eq :
    WA_0_0_re * WP5_Fre - WA_0_0_im * WP5_Fim = WP5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP5_Fre, WP5_Fim, WP5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP5_pim_eq :
    WA_0_0_re * WP5_Fim + WA_0_0_im * WP5_Fre = WP5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_0_re, WA_0_0_im, WP5_Fre, WP5_Fim, WP5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP5_mul : WA_0_0 * WP5_F = ofLadj WP5_pre WP5_pim := by
  rw [WA_0_0, WP5_F, ofLadj_mul, WP5_pre_eq, WP5_pim_eq]

def WP6_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def WP6_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def WP6_F : Ki := ofLadj WP6_Fre WP6_Fim
def WP6_pre : Polynomial ℚ := C ((2672001939 / 45993574 : ℚ)) + C ((-1149985010 / 5882899 : ℚ)) * X ^ 2 + C ((-160282044867 / 505929314 : ℚ)) * X ^ 3 + C ((-227829948705 / 252964657 : ℚ)) * X ^ 4 + C ((-1559838301677 / 1011858628 : ℚ)) * X ^ 5 + C ((-2089266194239 / 1011858628 : ℚ)) * X ^ 6 + C ((-650079277665 / 252964657 : ℚ)) * X ^ 7 + C ((-2831624305633 / 1011858628 : ℚ)) * X ^ 8 + C ((-728038041440 / 252964657 : ℚ)) * X ^ 9 + C ((-2956811864393 / 1011858628 : ℚ)) * X ^ 10 + C ((-1531820298251 / 505929314 : ℚ)) * X ^ 11 + C ((-2956811864393 / 1011858628 : ℚ)) * X ^ 12 + C ((-678588686010 / 252964657 : ℚ)) * X ^ 13 + C ((-2511060215899 / 1011858628 : ℚ)) * X ^ 14 + C ((-461338309629 / 252964657 : ℚ)) * X ^ 15 + C ((-1156715539953 / 1011858628 : ℚ)) * X ^ 16 + C ((-627287647391 / 1011858628 : ℚ)) * X ^ 17 + C ((-39088980669 / 252964657 : ℚ)) * X ^ 18
def WP6_pim : Polynomial ℚ := C ((189695342055 / 505929314 : ℚ)) + C ((189695342055 / 252964657 : ℚ)) * X + C ((56815760535 / 45993574 : ℚ)) * X ^ 2 + C ((460065756641 / 252964657 : ℚ)) * X ^ 3 + C ((1157947281015 / 505929314 : ℚ)) * X ^ 4 + C ((2425729889289 / 1011858628 : ℚ)) * X ^ 5 + C ((227929555693 / 91987148 : ℚ)) * X ^ 6 + C ((1081019390457 / 505929314 : ℚ)) * X ^ 7 + C ((1909699755121 / 1011858628 : ℚ)) * X ^ 8 + C ((949879659059 / 505929314 : ℚ)) * X ^ 9 + C ((15245292703 / 8362468 : ℚ)) * X ^ 10 + C ((63231780685 / 45993574 : ℚ)) * X ^ 11 + C ((85228903007 / 91987148 : ℚ)) * X ^ 12 + C ((97818417118 / 252964657 : ℚ)) * X ^ 13 + C ((-208983063325 / 1011858628 : ℚ)) * X ^ 14 + C ((-321957447583 / 505929314 : ℚ)) * X ^ 15 + C ((-708458992949 / 1011858628 : ℚ)) * X ^ 16 + C ((-683516290603 / 1011858628 : ℚ)) * X ^ 17 + C ((-146519364709 / 505929314 : ℚ)) * X ^ 18
theorem WP6_pre_eq :
    WA_1_0_re * WP6_Fre - WA_1_0_im * WP6_Fim = WP6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP6_Fre, WP6_Fim, WP6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP6_pim_eq :
    WA_1_0_re * WP6_Fim + WA_1_0_im * WP6_Fre = WP6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP6_Fre, WP6_Fim, WP6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP6_mul : WA_1_0 * WP6_F = ofLadj WP6_pre WP6_pim := by
  rw [WA_1_0, WP6_F, ofLadj_mul, WP6_pre_eq, WP6_pim_eq]

def WP7_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def WP7_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def WP7_F : Ki := ofLadj WP7_Fre WP7_Fim
def WP7_pre : Polynomial ℚ := C ((-19294059423 / 252964657 : ℚ)) + C ((-505854245480 / 758893971 : ℚ)) * X + C ((-1112895495092 / 758893971 : ℚ)) * X ^ 2 + C ((-1688606746795 / 758893971 : ℚ)) * X ^ 3 + C ((-2794281904103 / 758893971 : ℚ)) * X ^ 4 + C ((-3709033571035 / 758893971 : ℚ)) * X ^ 5 + C ((-1427552077128 / 252964657 : ℚ)) * X ^ 6 + C ((-4666138231181 / 758893971 : ℚ)) * X ^ 7 + C ((-401950151770 / 68990361 : ℚ)) * X ^ 8 + C ((-377432576023 / 68990361 : ℚ)) * X ^ 9 + C ((-366667109066 / 68990361 : ℚ)) * X ^ 10 + C ((-3848673069986 / 758893971 : ℚ)) * X ^ 11 + C ((-3527483954246 / 758893971 : ℚ)) * X ^ 12 + C ((-1012954280387 / 252964657 : ℚ)) * X ^ 13 + C ((-2732844922675 / 758893971 : ℚ)) * X ^ 14 + C ((-598582859271 / 252964657 : ℚ)) * X ^ 15 + C ((-342754968959 / 252964657 : ℚ)) * X ^ 16 + C ((-454642246528 / 758893971 : ℚ)) * X ^ 17 + C ((25369249755 / 252964657 : ℚ)) * X ^ 18
def WP7_pim : Polynomial ℚ := C ((462217145681 / 758893971 : ℚ)) + C ((924434291362 / 758893971 : ℚ)) * X + C ((1235000551117 / 758893971 : ℚ)) * X ^ 2 + C ((526641154329 / 252964657 : ℚ)) * X ^ 3 + C ((573593881889 / 252964657 : ℚ)) * X ^ 4 + C ((1172882685778 / 758893971 : ℚ)) * X ^ 5 + C ((630259573619 / 758893971 : ℚ)) * X ^ 6 + C ((-191443349608 / 758893971 : ℚ)) * X ^ 7 + C ((-827019467735 / 758893971 : ℚ)) * X ^ 8 + C ((-753213325804 / 758893971 : ℚ)) * X ^ 9 + C ((-19308760877 / 22996787 : ℚ)) * X ^ 10 + C ((-78905351018 / 68990361 : ℚ)) * X ^ 11 + C ((-99884419405 / 68990361 : ℚ)) * X ^ 12 + C ((-1293270656347 / 758893971 : ℚ)) * X ^ 13 + C ((-1564387426286 / 758893971 : ℚ)) * X ^ 14 + C ((-616151640461 / 252964657 : ℚ)) * X ^ 15 + C ((-1432902937327 / 758893971 : ℚ)) * X ^ 16 + C ((-393907584368 / 252964657 : ℚ)) * X ^ 17 + C ((-164122268570 / 252964657 : ℚ)) * X ^ 18
theorem WP7_pre_eq :
    WA_1_0_re * WP7_Fre - WA_1_0_im * WP7_Fim = WP7_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP7_Fre, WP7_Fim, WP7_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP7_pim_eq :
    WA_1_0_re * WP7_Fim + WA_1_0_im * WP7_Fre = WP7_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP7_Fre, WP7_Fim, WP7_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP7_mul : WA_1_0 * WP7_F = ofLadj WP7_pre WP7_pim := by
  rw [WA_1_0, WP7_F, ofLadj_mul, WP7_pre_eq, WP7_pim_eq]

def WP8_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def WP8_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def WP8_F : Ki := ofLadj WP8_Fre WP8_Fim
def WP8_pre : Polynomial ℚ := C ((388286160164 / 758893971 : ℚ)) + C ((2023416981920 / 758893971 : ℚ)) * X + C ((3959745149276 / 758893971 : ℚ)) * X ^ 2 + C ((6031101956879 / 758893971 : ℚ)) * X ^ 3 + C ((8465673686710 / 758893971 : ℚ)) * X ^ 4 + C ((10069343570705 / 758893971 : ℚ)) * X ^ 5 + C ((10606815871412 / 758893971 : ℚ)) * X ^ 6 + C ((3763002859752 / 252964657 : ℚ)) * X ^ 7 + C ((10491901160209 / 758893971 : ℚ)) * X ^ 8 + C ((10326067475786 / 758893971 : ℚ)) * X ^ 9 + C ((10229026570781 / 758893971 : ℚ)) * X ^ 10 + C ((3258951429208 / 252964657 : ℚ)) * X ^ 11 + C ((2735203196287 / 252964657 : ℚ)) * X ^ 12 + C ((2122107442170 / 252964657 : ℚ)) * X ^ 13 + C ((4460799203330 / 758893971 : ℚ)) * X ^ 14 + C ((723662080804 / 252964657 : ℚ)) * X ^ 15 + C ((642173185627 / 758893971 : ℚ)) * X ^ 16 + C ((104700884920 / 758893971 : ℚ)) * X ^ 17 + C ((-652348650134 / 758893971 : ℚ)) * X ^ 18
def WP8_pim : Polynomial ℚ := C ((-837160091764 / 758893971 : ℚ)) + C ((-1674320183528 / 758893971 : ℚ)) * X + C ((-551832333500 / 252964657 : ℚ)) * X ^ 2 + C ((-443760840115 / 252964657 : ℚ)) * X ^ 3 + C ((-151735745424 / 252964657 : ℚ)) * X ^ 4 + C ((1747064705102 / 758893971 : ℚ)) * X ^ 5 + C ((9055460844 / 2090617 : ℚ)) * X ^ 6 + C ((1648046954460 / 252964657 : ℚ)) * X ^ 7 + C ((6202466001821 / 758893971 : ℚ)) * X ^ 8 + C ((6176192847688 / 758893971 : ℚ)) * X ^ 9 + C ((183815887875 / 22996787 : ℚ)) * X ^ 10 + C ((6759888040412 / 758893971 : ℚ)) * X ^ 11 + C ((7453851780949 / 758893971 : ℚ)) * X ^ 12 + C ((7324760050108 / 758893971 : ℚ)) * X ^ 13 + C ((2324757471940 / 252964657 : ℚ)) * X ^ 14 + C ((187279603890 / 22996787 : ℚ)) * X ^ 15 + C ((4088133635537 / 758893971 : ℚ)) * X ^ 16 + C ((2723125270285 / 758893971 : ℚ)) * X ^ 17 + C ((1176295341818 / 758893971 : ℚ)) * X ^ 18
theorem WP8_pre_eq :
    WA_1_0_re * WP8_Fre - WA_1_0_im * WP8_Fim = WP8_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP8_Fre, WP8_Fim, WP8_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP8_pim_eq :
    WA_1_0_re * WP8_Fim + WA_1_0_im * WP8_Fre = WP8_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP8_Fre, WP8_Fim, WP8_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP8_mul : WA_1_0 * WP8_F = ofLadj WP8_pre WP8_pim := by
  rw [WA_1_0, WP8_F, ofLadj_mul, WP8_pre_eq, WP8_pim_eq]

def WP9_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def WP9_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def WP9_F : Ki := ofLadj WP9_Fre WP9_Fim
def WP9_pre : Polynomial ℚ := C ((-74802057947 / 758893971 : ℚ)) + C ((-632317806850 / 758893971 : ℚ)) * X + C ((-2664226077199 / 1517787942 : ℚ)) * X ^ 2 + C ((-2105343146690 / 758893971 : ℚ)) * X ^ 3 + C ((-6808457650589 / 1517787942 : ℚ)) * X ^ 4 + C ((-3021077018833 / 505929314 : ℚ)) * X ^ 5 + C ((-5299467349667 / 758893971 : ℚ)) * X ^ 6 + C ((-12368080330189 / 1517787942 : ℚ)) * X ^ 7 + C ((-12596588774791 / 1517787942 : ℚ)) * X ^ 8 + C ((-13097863176023 / 1517787942 : ℚ)) * X ^ 9 + C ((-4435821527947 / 505929314 : ℚ)) * X ^ 10 + C ((-6719467107544 / 758893971 : ℚ)) * X ^ 11 + C ((-12042828970141 / 1517787942 : ℚ)) * X ^ 12 + C ((-5216818549412 / 758893971 : ℚ)) * X ^ 13 + C ((-2795300827137 / 505929314 : ℚ)) * X ^ 14 + C ((-912969799419 / 252964657 : ℚ)) * X ^ 15 + C ((-976570596135 / 505929314 : ℚ)) * X ^ 16 + C ((-697004072785 / 758893971 : ℚ)) * X ^ 17 + C ((40901941543 / 758893971 : ℚ)) * X ^ 18
def WP9_pim : Polynomial ℚ := C ((187321162310 / 252964657 : ℚ)) + C ((374642324620 / 252964657 : ℚ)) * X + C ((24426865361 / 11765798 : ℚ)) * X ^ 2 + C ((2054971319732 / 758893971 : ℚ)) * X ^ 3 + C ((4717288348981 / 1517787942 : ℚ)) * X ^ 4 + C ((3843158809427 / 1517787942 : ℚ)) * X ^ 5 + C ((1709244879833 / 758893971 : ℚ)) * X ^ 6 + C ((690863511267 / 505929314 : ℚ)) * X ^ 7 + C ((941625731059 / 1517787942 : ℚ)) * X ^ 8 + C ((268090992481 / 505929314 : ℚ)) * X ^ 9 + C ((18197145425 / 45993574 : ℚ)) * X ^ 10 + C ((-161415553330 / 252964657 : ℚ)) * X ^ 11 + C ((-845830812995 / 505929314 : ℚ)) * X ^ 12 + C ((-607411883542 / 252964657 : ℚ)) * X ^ 13 + C ((-4740701062763 / 1517787942 : ℚ)) * X ^ 14 + C ((-2540044559615 / 758893971 : ℚ)) * X ^ 15 + C ((-1328630399781 / 505929314 : ℚ)) * X ^ 16 + C ((-494148343665 / 252964657 : ℚ)) * X ^ 17 + C ((-233153742632 / 252964657 : ℚ)) * X ^ 18
theorem WP9_pre_eq :
    WA_1_0_re * WP9_Fre - WA_1_0_im * WP9_Fim = WP9_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP9_Fre, WP9_Fim, WP9_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP9_pim_eq :
    WA_1_0_re * WP9_Fim + WA_1_0_im * WP9_Fre = WP9_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP9_Fre, WP9_Fim, WP9_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP9_mul : WA_1_0 * WP9_F = ofLadj WP9_pre WP9_pim := by
  rw [WA_1_0, WP9_F, ofLadj_mul, WP9_pre_eq, WP9_pim_eq]

def WP10_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP10_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP10_F : Ki := ofLadj WP10_Fre WP10_Fim
def WP10_pre : Polynomial ℚ := C ((-397181636218 / 758893971 : ℚ)) + C ((-2529271227400 / 758893971 : ℚ)) * X + C ((-5472587471794 / 758893971 : ℚ)) * X ^ 2 + C ((-8534263232116 / 758893971 : ℚ)) * X ^ 3 + C ((-12582163594250 / 758893971 : ℚ)) * X ^ 4 + C ((-32608712852 / 1604427 : ℚ)) * X ^ 5 + C ((-16824735530492 / 758893971 : ℚ)) * X ^ 6 + C ((-6060741587423 / 252964657 : ℚ)) * X ^ 7 + C ((-17419765071925 / 758893971 : ℚ)) * X ^ 8 + C ((-17098288138961 / 758893971 : ℚ)) * X ^ 9 + C ((-5616955700802 / 252964657 : ℚ)) * X ^ 10 + C ((-16390660104668 / 758893971 : ℚ)) * X ^ 11 + C ((-14321595875006 / 758893971 : ℚ)) * X ^ 12 + C ((-11625700667167 / 758893971 : ℚ)) * X ^ 13 + C ((-2961833946603 / 252964657 : ℚ)) * X ^ 14 + C ((-5139274248283 / 758893971 : ℚ)) * X ^ 15 + C ((-2453342671402 / 758893971 : ℚ)) * X ^ 16 + C ((-350842773302 / 252964657 : ℚ)) * X ^ 17 + C ((13963239992 / 22996787 : ℚ)) * X ^ 18
def WP10_pim : Polynomial ℚ := C ((1615536140870 / 758893971 : ℚ)) + C ((3231072281740 / 758893971 : ℚ)) * X + C ((3946966149488 / 758893971 : ℚ)) * X ^ 2 + C ((382775860292 / 68990361 : ℚ)) * X ^ 3 + C ((3588040878010 / 758893971 : ℚ)) * X ^ 4 + C ((845400906830 / 758893971 : ℚ)) * X ^ 5 + C ((-1038541137092 / 758893971 : ℚ)) * X ^ 6 + C ((-3502583497277 / 758893971 : ℚ)) * X ^ 7 + C ((-5315192333933 / 758893971 : ℚ)) * X ^ 8 + C ((-5270824616419 / 758893971 : ℚ)) * X ^ 9 + C ((-152851210608 / 22996787 : ℚ)) * X ^ 10 + C ((-6363211287910 / 758893971 : ℚ)) * X ^ 11 + C ((-7682332625756 / 758893971 : ℚ)) * X ^ 12 + C ((-8171491827149 / 758893971 : ℚ)) * X ^ 13 + C ((-2796897474453 / 252964657 : ℚ)) * X ^ 14 + C ((-718579925581 / 68990361 : ℚ)) * X ^ 15 + C ((-5448326860330 / 758893971 : ℚ)) * X ^ 16 + C ((-1284627734496 / 252964657 : ℚ)) * X ^ 17 + C ((-1676428493422 / 758893971 : ℚ)) * X ^ 18
theorem WP10_pre_eq :
    WA_1_0_re * WP10_Fre - WA_1_0_im * WP10_Fim = WP10_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP10_Fre, WP10_Fim, WP10_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP10_pim_eq :
    WA_1_0_re * WP10_Fim + WA_1_0_im * WP10_Fre = WP10_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP10_Fre, WP10_Fim, WP10_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP10_mul : WA_1_0 * WP10_F = ofLadj WP10_pre WP10_pim := by
  rw [WA_1_0, WP10_F, ofLadj_mul, WP10_pre_eq, WP10_pim_eq]

def WP11_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def WP11_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def WP11_F : Ki := ofLadj WP11_Fre WP11_Fim
def WP11_pre : Polynomial ℚ := C ((-266270336821 / 758893971 : ℚ)) + C ((-1770489859180 / 758893971 : ℚ)) * X + C ((-3788614173512 / 758893971 : ℚ)) * X ^ 2 + C ((-5814736193503 / 758893971 : ℚ)) * X ^ 3 + C ((-264718202010 / 22996787 : ℚ)) * X ^ 4 + C ((-21840392764169 / 1517787942 : ℚ)) * X ^ 5 + C ((-24385645768163 / 1517787942 : ℚ)) * X ^ 6 + C ((-2458301577793 / 137980722 : ℚ)) * X ^ 7 + C ((-4461637108706 / 252964657 : ℚ)) * X ^ 8 + C ((-27071714570531 / 1517787942 : ℚ)) * X ^ 9 + C ((-27376376498783 / 1517787942 : ℚ)) * X ^ 10 + C ((-13458368800379 / 758893971 : ℚ)) * X ^ 11 + C ((-7945132260141 / 505929314 : ℚ)) * X ^ 12 + C ((-19494486223507 / 1517787942 : ℚ)) * X ^ 13 + C ((-7570175132615 / 758893971 : ℚ)) * X ^ 14 + C ((-8956913604797 / 1517787942 : ℚ)) * X ^ 15 + C ((-4403518605863 / 1517787942 : ℚ)) * X ^ 16 + C ((-1858265601869 / 1517787942 : ℚ)) * X ^ 17 + C ((102167069711 / 252964657 : ℚ)) * X ^ 18
def WP11_pim : Polynomial ℚ := C ((1206753435431 / 758893971 : ℚ)) + C ((2413506870862 / 758893971 : ℚ)) * X + C ((3039047910875 / 758893971 : ℚ)) * X ^ 2 + C ((3477334931012 / 758893971 : ℚ)) * X ^ 3 + C ((3375368927596 / 758893971 : ℚ)) * X ^ 4 + C ((316150298677 / 137980722 : ℚ)) * X ^ 5 + C ((448283779589 / 505929314 : ℚ)) * X ^ 6 + C ((-1902068118245 / 1517787942 : ℚ)) * X ^ 7 + C ((-2231963986669 / 758893971 : ℚ)) * X ^ 8 + C ((-1492677630517 / 505929314 : ℚ)) * X ^ 9 + C ((-3325695493 / 1069618 : ℚ)) * X ^ 10 + C ((-339400509248 / 68990361 : ℚ)) * X ^ 11 + C ((-84417028945 / 12543702 : ℚ)) * X ^ 12 + C ((-3902223865129 / 505929314 : ℚ)) * X ^ 13 + C ((-6298675276937 / 758893971 : ℚ)) * X ^ 14 + C ((-12294116297293 / 1517787942 : ℚ)) * X ^ 15 + C ((-2898060558615 / 505929314 : ℚ)) * X ^ 16 + C ((-6234931613557 / 1517787942 : ℚ)) * X ^ 17 + C ((-1330581052421 / 758893971 : ℚ)) * X ^ 18
theorem WP11_pre_eq :
    WA_1_0_re * WP11_Fre - WA_1_0_im * WP11_Fim = WP11_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP11_Fre, WP11_Fim, WP11_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP11_pim_eq :
    WA_1_0_re * WP11_Fim + WA_1_0_im * WP11_Fre = WP11_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_0_re, WA_1_0_im, WP11_Fre, WP11_Fim, WP11_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP11_mul : WA_1_0 * WP11_F = ofLadj WP11_pre WP11_pim := by
  rw [WA_1_0, WP11_F, ofLadj_mul, WP11_pre_eq, WP11_pim_eq]

def WP12_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def WP12_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def WP12_F : Ki := ofLadj WP12_Fre WP12_Fim
def WP12_pre : Polynomial ℚ := C ((-72804787503 / 505929314 : ℚ)) + C ((932231565 / 5882899 : ℚ)) * X ^ 2 + C ((183053571263 / 505929314 : ℚ)) * X ^ 3 + C ((585228923077 / 505929314 : ℚ)) * X ^ 4 + C ((90154308027 / 45993574 : ℚ)) * X ^ 5 + C ((687268575154 / 252964657 : ℚ)) * X ^ 6 + C ((1709942253575 / 505929314 : ℚ)) * X ^ 7 + C ((922277050461 / 252964657 : ℚ)) * X ^ 8 + C ((949108638403 / 252964657 : ℚ)) * X ^ 9 + C ((1937207944077 / 505929314 : ℚ)) * X ^ 10 + C ((2028231461969 / 505929314 : ℚ)) * X ^ 11 + C ((1937207944077 / 505929314 : ℚ)) * X ^ 12 + C ((909022681108 / 252964657 : ℚ)) * X ^ 13 + C ((1661500529659 / 505929314 : ℚ)) * X ^ 14 + C ((1211995014159 / 505929314 : ℚ)) * X ^ 15 + C ((387526082639 / 252964657 : ℚ)) * X ^ 16 + C ((392212403267 / 505929314 : ℚ)) * X ^ 17 + C ((87281683661 / 505929314 : ℚ)) * X ^ 18
def WP12_pim : Polynomial ℚ := C ((-258573978285 / 505929314 : ℚ)) + C ((-258573978285 / 252964657 : ℚ)) * X + C ((-416608413325 / 252964657 : ℚ)) * X ^ 2 + C ((-630148747332 / 252964657 : ℚ)) * X ^ 3 + C ((-774975654397 / 252964657 : ℚ)) * X ^ 4 + C ((-1656750377617 / 505929314 : ℚ)) * X ^ 5 + C ((-1694128253967 / 505929314 : ℚ)) * X ^ 6 + C ((-132863336281 / 45993574 : ℚ)) * X ^ 7 + C ((-118264606381 / 45993574 : ℚ)) * X ^ 8 + C ((-1292421843701 / 505929314 : ℚ)) * X ^ 9 + C ((-1259109251677 / 505929314 : ℚ)) * X ^ 10 + C ((-86191326095 / 45993574 : ℚ)) * X ^ 11 + C ((-637099922413 / 505929314 : ℚ)) * X ^ 12 + C ((-287718460309 / 505929314 : ℚ)) * X ^ 13 + C ((147851034195 / 505929314 : ℚ)) * X ^ 14 + C ((207243984201 / 252964657 : ℚ)) * X ^ 15 + C ((239324296124 / 252964657 : ℚ)) * X ^ 16 + C ((229436454338 / 252964657 : ℚ)) * X ^ 17 + C ((183602908823 / 505929314 : ℚ)) * X ^ 18
theorem WP12_pre_eq :
    WA_0_1_re * WP12_Fre - WA_0_1_im * WP12_Fim = WP12_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP12_Fre, WP12_Fim, WP12_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP12_pim_eq :
    WA_0_1_re * WP12_Fim + WA_0_1_im * WP12_Fre = WP12_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP12_Fre, WP12_Fim, WP12_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP12_mul : WA_0_1 * WP12_F = ofLadj WP12_pre WP12_pim := by
  rw [WA_0_1, WP12_F, ofLadj_mul, WP12_pre_eq, WP12_pim_eq]

def WP13_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def WP13_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def WP13_F : Ki := ofLadj WP13_Fre WP13_Fim
def WP13_pre : Polynomial ℚ := C ((2504814683 / 758893971 : ℚ)) + C ((689530608760 / 758893971 : ℚ)) * X + C ((1402510913644 / 758893971 : ℚ)) * X ^ 2 + C ((734555118767 / 252964657 : ℚ)) * X ^ 3 + C ((3755128580705 / 758893971 : ℚ)) * X ^ 4 + C ((4863771533497 / 758893971 : ℚ)) * X ^ 5 + C ((1920263346432 / 252964657 : ℚ)) * X ^ 6 + C ((565346710229 / 68990361 : ℚ)) * X ^ 7 + C ((1943067084265 / 252964657 : ℚ)) * X ^ 8 + C ((5512784444419 / 758893971 : ℚ)) * X ^ 9 + C ((5295144935287 / 758893971 : ℚ)) * X ^ 10 + C ((5182107336458 / 758893971 : ℚ)) * X ^ 11 + C ((1535204775509 / 252964657 : ℚ)) * X ^ 12 + C ((1370091176925 / 252964657 : ℚ)) * X ^ 13 + C ((1208511965498 / 252964657 : ℚ)) * X ^ 14 + C ((2342676036719 / 758893971 : ℚ)) * X ^ 15 + C ((1411588908904 / 758893971 : ℚ)) * X ^ 16 + C ((46779127555 / 68990361 : ℚ)) * X ^ 17 + C ((-40336398365 / 252964657 : ℚ)) * X ^ 18
def WP13_pim : Polynomial ℚ := C ((-217291935889 / 252964657 : ℚ)) + C ((-434583871778 / 252964657 : ℚ)) * X + C ((-1665343295734 / 758893971 : ℚ)) * X ^ 2 + C ((-2262395992013 / 758893971 : ℚ)) * X ^ 3 + C ((-2354580493255 / 758893971 : ℚ)) * X ^ 4 + C ((-559140471905 / 252964657 : ℚ)) * X ^ 5 + C ((-989276532148 / 758893971 : ℚ)) * X ^ 6 + C ((229787186887 / 758893971 : ℚ)) * X ^ 7 + C ((968075169895 / 758893971 : ℚ)) * X ^ 8 + C ((304298596507 / 252964657 : ℚ)) * X ^ 9 + C ((723196173185 / 758893971 : ℚ)) * X ^ 10 + C ((357601131242 / 252964657 : ℚ)) * X ^ 11 + C ((1422410614267 / 758893971 : ℚ)) * X ^ 12 + C ((144936607121 / 68990361 : ℚ)) * X ^ 13 + C ((2136175994236 / 758893971 : ℚ)) * X ^ 14 + C ((789631488907 / 252964657 : ℚ)) * X ^ 15 + C ((643860313980 / 252964657 : ℚ)) * X ^ 16 + C ((1576972178041 / 758893971 : ℚ)) * X ^ 17 + C ((199251337255 / 252964657 : ℚ)) * X ^ 18
theorem WP13_pre_eq :
    WA_0_1_re * WP13_Fre - WA_0_1_im * WP13_Fim = WP13_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP13_Fre, WP13_Fim, WP13_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP13_pim_eq :
    WA_0_1_re * WP13_Fim + WA_0_1_im * WP13_Fre = WP13_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP13_Fre, WP13_Fim, WP13_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP13_mul : WA_0_1 * WP13_F = ofLadj WP13_pre WP13_pim := by
  rw [WA_0_1, WP13_F, ofLadj_mul, WP13_pre_eq, WP13_pim_eq]

def WP14_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def WP14_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def WP14_F : Ki := ofLadj WP14_Fre WP14_Fim
def WP14_pre : Polynomial ℚ := C ((-398311458748 / 758893971 : ℚ)) + C ((-2758122435040 / 758893971 : ℚ)) * X + C ((-1741247384164 / 252964657 : ℚ)) * X ^ 2 + C ((-8046743288629 / 758893971 : ℚ)) * X ^ 3 + C ((-11492327365252 / 758893971 : ℚ)) * X ^ 4 + C ((-13323726133370 / 758893971 : ℚ)) * X ^ 5 + C ((-4791486460076 / 252964657 : ℚ)) * X ^ 6 + C ((-5023138256276 / 252964657 : ℚ)) * X ^ 7 + C ((-1273941871046 / 68990361 : ℚ)) * X ^ 8 + C ((-13794867918443 / 758893971 : ℚ)) * X ^ 9 + C ((-4547791815108 / 252964657 : ℚ)) * X ^ 10 + C ((-13185263851684 / 758893971 : ℚ)) * X ^ 11 + C ((-10885253010284 / 758893971 : ℚ)) * X ^ 12 + C ((-8571125765951 / 758893971 : ℚ)) * X ^ 13 + C ((-1988872430959 / 252964657 : ℚ)) * X ^ 14 + C ((-2712627031688 / 758893971 : ℚ)) * X ^ 15 + C ((-90022019359 / 68990361 : ℚ)) * X ^ 16 + C ((60491033909 / 758893971 : ℚ)) * X ^ 17 + C ((288153457296 / 252964657 : ℚ)) * X ^ 18
def WP14_pim : Polynomial ℚ := C ((1228442013148 / 758893971 : ℚ)) + C ((2456884026296 / 758893971 : ℚ)) * X + C ((763729944400 / 252964657 : ℚ)) * X ^ 2 + C ((740388327517 / 252964657 : ℚ)) * X ^ 3 + C ((244557304190 / 252964657 : ℚ)) * X ^ 4 + C ((-2023183743436 / 758893971 : ℚ)) * X ^ 5 + C ((-4021100989502 / 758893971 : ℚ)) * X ^ 6 + C ((-6422000232674 / 758893971 : ℚ)) * X ^ 7 + C ((-2640468583146 / 252964657 : ℚ)) * X ^ 8 + C ((-2628555913955 / 252964657 : ℚ)) * X ^ 9 + C ((-7743956752784 / 758893971 : ℚ)) * X ^ 10 + C ((-8773162531844 / 758893971 : ℚ)) * X ^ 11 + C ((-9802368310904 / 758893971 : ℚ)) * X ^ 12 + C ((-9494963128727 / 758893971 : ℚ)) * X ^ 13 + C ((-853563660955 / 68990361 : ℚ)) * X ^ 14 + C ((-7999744469572 / 758893971 : ℚ)) * X ^ 15 + C ((-1805487723775 / 252964657 : ℚ)) * X ^ 16 + C ((-3628693133129 / 758893971 : ℚ)) * X ^ 17 + C ((-1401368247716 / 758893971 : ℚ)) * X ^ 18
theorem WP14_pre_eq :
    WA_0_1_re * WP14_Fre - WA_0_1_im * WP14_Fim = WP14_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP14_Fre, WP14_Fim, WP14_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP14_pim_eq :
    WA_0_1_re * WP14_Fim + WA_0_1_im * WP14_Fre = WP14_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP14_Fre, WP14_Fim, WP14_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP14_mul : WA_0_1 * WP14_F = ofLadj WP14_pre WP14_pim := by
  rw [WA_0_1, WP14_F, ofLadj_mul, WP14_pre_eq, WP14_pim_eq]

def WP15_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def WP15_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def WP15_F : Ki := ofLadj WP15_Fre WP15_Fim
def WP15_pre : Polynomial ℚ := C ((3066027993 / 252964657 : ℚ)) + C ((861913260950 / 758893971 : ℚ)) * X + C ((553933112358 / 252964657 : ℚ)) * X ^ 2 + C ((2756063845213 / 758893971 : ℚ)) * X ^ 3 + C ((1513581082316 / 252964657 : ℚ)) * X ^ 4 + C ((5913769179772 / 758893971 : ℚ)) * X ^ 5 + C ((2363510292304 / 252964657 : ℚ)) * X ^ 6 + C ((8175222870971 / 758893971 : ℚ)) * X ^ 7 + C ((8333506612217 / 758893971 : ℚ)) * X ^ 8 + C ((8624935260166 / 758893971 : ℚ)) * X ^ 9 + C ((24328729880 / 2090617 : ℚ)) * X ^ 10 + C ((2978763316399 / 252964657 : ℚ)) * X ^ 11 + C ((7969415685490 / 758893971 : ℚ)) * X ^ 12 + C ((6963135923092 / 758893971 : ℚ)) * X ^ 13 + C ((5577442767004 / 758893971 : ℚ)) * X ^ 14 + C ((1181589095264 / 252964657 : ℚ)) * X ^ 15 + C ((1995058510955 / 758893971 : ℚ)) * X ^ 16 + C ((272765604605 / 252964657 : ℚ)) * X ^ 17 + C ((-89712338231 / 758893971 : ℚ)) * X ^ 18
def WP15_pim : Polynomial ℚ := C ((-793296928060 / 758893971 : ℚ)) + C ((-1586593856120 / 758893971 : ℚ)) * X + C ((-16435599041 / 5882899 : ℚ)) * X ^ 2 + C ((-2949816138284 / 758893971 : ℚ)) * X ^ 3 + C ((-3189060534344 / 758893971 : ℚ)) * X ^ 4 + C ((-2751737032771 / 758893971 : ℚ)) * X ^ 5 + C ((-810570159266 / 252964657 : ℚ)) * X ^ 6 + C ((-137076848378 / 68990361 : ℚ)) * X ^ 7 + C ((-780845660303 / 758893971 : ℚ)) * X ^ 8 + C ((-243616472697 / 252964657 : ℚ)) * X ^ 9 + C ((-561714938432 / 758893971 : ℚ)) * X ^ 10 + C ((522186644255 / 758893971 : ℚ)) * X ^ 11 + C ((535362742314 / 252964657 : ℚ)) * X ^ 12 + C ((2308821126770 / 758893971 : ℚ)) * X ^ 13 + C ((1062813743659 / 252964657 : ℚ)) * X ^ 14 + C ((1100565041025 / 252964657 : ℚ)) * X ^ 15 + C ((881247155010 / 252964657 : ℚ)) * X ^ 16 + C ((665828492643 / 252964657 : ℚ)) * X ^ 17 + C ((852990175817 / 758893971 : ℚ)) * X ^ 18
theorem WP15_pre_eq :
    WA_0_1_re * WP15_Fre - WA_0_1_im * WP15_Fim = WP15_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP15_Fre, WP15_Fim, WP15_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP15_pim_eq :
    WA_0_1_re * WP15_Fim + WA_0_1_im * WP15_Fre = WP15_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP15_Fre, WP15_Fim, WP15_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP15_mul : WA_0_1 * WP15_F = ofLadj WP15_pre WP15_pim := by
  rw [WA_0_1, WP15_F, ofLadj_mul, WP15_pre_eq, WP15_pim_eq]

def WP16_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP16_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP16_F : Ki := ofLadj WP16_Fre WP16_Fim
def WP16_pre : Polynomial ℚ := C ((279474960926 / 758893971 : ℚ)) + C ((3447653043800 / 758893971 : ℚ)) * X + C ((643999746088 / 68990361 : ℚ)) * X ^ 2 + C ((3778747752688 / 252964657 : ℚ)) * X ^ 3 + C ((16953181857526 / 758893971 : ℚ)) * X ^ 4 + C ((157694671242 / 5882899 : ℚ)) * X ^ 5 + C ((22640769159952 / 758893971 : ℚ)) * X ^ 6 + C ((24195899972110 / 758893971 : ℚ)) * X ^ 7 + C ((7711424017114 / 252964657 : ℚ)) * X ^ 8 + C ((22692222900064 / 758893971 : ℚ)) * X ^ 9 + C ((22367660980612 / 758893971 : ℚ)) * X ^ 10 + C ((21981974230790 / 758893971 : ℚ)) * X ^ 11 + C ((18920007936812 / 758893971 : ℚ)) * X ^ 12 + C ((15608225693096 / 758893971 : ℚ)) * X ^ 13 + C ((3932676264426 / 252964657 : ℚ)) * X ^ 14 + C ((6584117966882 / 758893971 : ℚ)) * X ^ 15 + C ((1137699478910 / 252964657 : ℚ)) * X ^ 16 + C ((1114941866996 / 758893971 : ℚ)) * X ^ 17 + C ((-658600147702 / 758893971 : ℚ)) * X ^ 18
def WP16_pim : Polynomial ℚ := C ((-2311274451290 / 758893971 : ℚ)) + C ((-4622548902580 / 758893971 : ℚ)) * X + C ((-1801827009052 / 252964657 : ℚ)) * X ^ 2 + C ((-6273880267724 / 758893971 : ℚ)) * X ^ 3 + C ((-1662188456354 / 252964657 : ℚ)) * X ^ 4 + C ((-1630178741636 / 758893971 : ℚ)) * X ^ 5 + C ((867780690466 / 758893971 : ℚ)) * X ^ 6 + C ((4367530323704 / 758893971 : ℚ)) * X ^ 7 + C ((199503226746 / 22996787 : ℚ)) * X ^ 8 + C ((6517996291192 / 758893971 : ℚ)) * X ^ 9 + C ((6217767559012 / 758893971 : ℚ)) * X ^ 10 + C ((8122139403670 / 758893971 : ℚ)) * X ^ 11 + C ((10026511248328 / 758893971 : ℚ)) * X ^ 12 + C ((3503071546908 / 252964657 : ℚ)) * X ^ 13 + C ((342787990602 / 22996787 : ℚ)) * X ^ 14 + C ((3405651573568 / 252964657 : ℚ)) * X ^ 15 + C ((2411190932246 / 252964657 : ℚ)) * X ^ 16 + C ((5150555159192 / 758893971 : ℚ)) * X ^ 17 + C ((2023810229414 / 758893971 : ℚ)) * X ^ 18
theorem WP16_pre_eq :
    WA_0_1_re * WP16_Fre - WA_0_1_im * WP16_Fim = WP16_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP16_Fre, WP16_Fim, WP16_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP16_pim_eq :
    WA_0_1_re * WP16_Fim + WA_0_1_im * WP16_Fre = WP16_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP16_Fre, WP16_Fim, WP16_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP16_mul : WA_0_1 * WP16_F = ofLadj WP16_pre WP16_pim := by
  rw [WA_0_1, WP16_F, ofLadj_mul, WP16_pre_eq, WP16_pim_eq]

def WP17_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def WP17_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def WP17_F : Ki := ofLadj WP17_Fre WP17_Fim
def WP17_pre : Polynomial ℚ := C ((166510557647 / 758893971 : ℚ)) + C ((2413357130660 / 758893971 : ℚ)) * X + C ((4872876261899 / 758893971 : ℚ)) * X ^ 2 + C ((7687757939285 / 758893971 : ℚ)) * X ^ 3 + C ((11746074992678 / 758893971 : ℚ)) * X ^ 4 + C ((4783136062612 / 252964657 : ℚ)) * X ^ 5 + C ((1488522384553 / 68990361 : ℚ)) * X ^ 6 + C ((5988118082416 / 252964657 : ℚ)) * X ^ 7 + C ((5910465794367 / 252964657 : ℚ)) * X ^ 8 + C ((17955801285970 / 758893971 : ℚ)) * X ^ 9 + C ((18144198010963 / 758893971 : ℚ)) * X ^ 10 + C ((6014232024996 / 252964657 : ℚ)) * X ^ 11 + C ((15730840880303 / 758893971 : ℚ)) * X ^ 12 + C ((13082925024071 / 758893971 : ℚ)) * X ^ 13 + C ((913058131256 / 68990361 : ℚ)) * X ^ 14 + C ((524360907784 / 68990361 : ℚ)) * X ^ 15 + C ((1010856779279 / 252964657 : ℚ)) * X ^ 16 + C ((1008232295590 / 758893971 : ℚ)) * X ^ 17 + C ((-450309268946 / 758893971 : ℚ)) * X ^ 18
def WP17_pim : Polynomial ℚ := C ((-1721321707217 / 758893971 : ℚ)) + C ((-3442643414434 / 758893971 : ℚ)) * X + C ((-4139716330325 / 758893971 : ℚ)) * X ^ 2 + C ((-5106710329478 / 758893971 : ℚ)) * X ^ 3 + C ((-4647360448111 / 758893971 : ℚ)) * X ^ 4 + C ((-894580257523 / 252964657 : ℚ)) * X ^ 5 + C ((-117905929915 / 68990361 : ℚ)) * X ^ 6 + C ((1048761870973 / 758893971 : ℚ)) * X ^ 7 + C ((2571189530576 / 758893971 : ℚ)) * X ^ 8 + C ((2598277439171 / 758893971 : ℚ)) * X ^ 9 + C ((63982803847 / 17648697 : ℚ)) * X ^ 10 + C ((4702916465086 / 758893971 : ℚ)) * X ^ 11 + C ((6654572364751 / 758893971 : ℚ)) * X ^ 12 + C ((7504628406892 / 758893971 : ℚ)) * X ^ 13 + C ((8498710314640 / 758893971 : ℚ)) * X ^ 14 + C ((2650709655468 / 252964657 : ℚ)) * X ^ 15 + C ((1927940515173 / 252964657 : ℚ)) * X ^ 16 + C ((1386691323951 / 252964657 : ℚ)) * X ^ 17 + C ((1609659126472 / 758893971 : ℚ)) * X ^ 18
theorem WP17_pre_eq :
    WA_0_1_re * WP17_Fre - WA_0_1_im * WP17_Fim = WP17_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP17_Fre, WP17_Fim, WP17_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP17_pim_eq :
    WA_0_1_re * WP17_Fim + WA_0_1_im * WP17_Fre = WP17_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_0_1_re, WA_0_1_im, WP17_Fre, WP17_Fim, WP17_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP17_mul : WA_0_1 * WP17_F = ofLadj WP17_pre WP17_pim := by
  rw [WA_0_1, WP17_F, ofLadj_mul, WP17_pre_eq, WP17_pim_eq]

def WP18_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def WP18_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def WP18_F : Ki := ofLadj WP18_Fre WP18_Fim
def WP18_pre : Polynomial ℚ := C ((-30217429017 / 2023717256 : ℚ)) + C ((147890878 / 5882899 : ℚ)) * X ^ 2 + C ((25345411681 / 1011858628 : ℚ)) * X ^ 3 + C ((10706250477 / 91987148 : ℚ)) * X ^ 4 + C ((198501160743 / 1011858628 : ℚ)) * X ^ 5 + C ((127748757651 / 505929314 : ℚ)) * X ^ 6 + C ((660632910081 / 2023717256 : ℚ)) * X ^ 7 + C ((64011915685 / 183974296 : ℚ)) * X ^ 8 + C ((736941443291 / 2023717256 : ℚ)) * X ^ 9 + C ((754318247935 / 2023717256 : ℚ)) * X ^ 10 + C ((779018778525 / 2023717256 : ℚ)) * X ^ 11 + C ((754318247935 / 2023717256 : ℚ)) * X ^ 12 + C ((62369725569 / 183974296 : ℚ)) * X ^ 13 + C ((653440249173 / 2023717256 : ℚ)) * X ^ 14 + C ((118359589363 / 505929314 : ℚ)) * X ^ 15 + C ((141338969063 / 1011858628 : ℚ)) * X ^ 16 + C ((21085653626 / 252964657 : ℚ)) * X ^ 17 + C ((48342957865 / 2023717256 : ℚ)) * X ^ 18
def WP18_pim : Polynomial ℚ := C ((-102660680577 / 2023717256 : ℚ)) + C ((-102660680577 / 1011858628 : ℚ)) * X + C ((-82284937019 / 505929314 : ℚ)) * X ^ 2 + C ((-469879972409 / 2023717256 : ℚ)) * X ^ 3 + C ((-627407113305 / 2023717256 : ℚ)) * X ^ 4 + C ((-158472872057 / 505929314 : ℚ)) * X ^ 5 + C ((-640243849525 / 2023717256 : ℚ)) * X ^ 6 + C ((-586258888511 / 2023717256 : ℚ)) * X ^ 7 + C ((-520899292173 / 2023717256 : ℚ)) * X ^ 8 + C ((-62389412199 / 252964657 : ℚ)) * X ^ 9 + C ((-509127345667 / 2023717256 : ℚ)) * X ^ 10 + C ((-34220226859 / 183974296 : ℚ)) * X ^ 11 + C ((-243717645231 / 2023717256 : ℚ)) * X ^ 12 + C ((-16238913298 / 252964657 : ℚ)) * X ^ 13 + C ((1482405115 / 91987148 : ℚ)) * X ^ 14 + C ((176786162879 / 2023717256 : ℚ)) * X ^ 15 + C ((7210784567 / 91987148 : ℚ)) * X ^ 16 + C ((157331725227 / 2023717256 : ℚ)) * X ^ 17 + C ((650524685 / 16724936 : ℚ)) * X ^ 18
theorem WP18_pre_eq :
    WA_2_0_re * WP18_Fre - WA_2_0_im * WP18_Fim = WP18_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP18_Fre, WP18_Fim, WP18_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP18_pim_eq :
    WA_2_0_re * WP18_Fim + WA_2_0_im * WP18_Fre = WP18_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP18_Fre, WP18_Fim, WP18_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP18_mul : WA_2_0 * WP18_F = ofLadj WP18_pre WP18_pim := by
  rw [WA_2_0, WP18_F, ofLadj_mul, WP18_pre_eq, WP18_pim_eq]

def WP19_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def WP19_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def WP19_F : Ki := ofLadj WP19_Fre WP19_Fim
def WP19_pre : Polynomial ℚ := C ((-2066880655 / 3035575884 : ℚ)) + C ((68440453718 / 758893971 : ℚ)) * X + C ((50098134133 / 252964657 : ℚ)) * X ^ 2 + C ((801277313527 / 3035575884 : ℚ)) * X ^ 3 + C ((1451116587607 / 3035575884 : ℚ)) * X ^ 4 + C ((326994910193 / 505929314 : ℚ)) * X ^ 5 + C ((2156500560041 / 3035575884 : ℚ)) * X ^ 6 + C ((54424244399 / 68990361 : ℚ)) * X ^ 7 + C ((570115820627 / 758893971 : ℚ)) * X ^ 8 + C ((32500735605 / 45993574 : ℚ)) * X ^ 9 + C ((699145102521 / 1011858628 : ℚ)) * X ^ 10 + C ((167005134816 / 252964657 : ℚ)) * X ^ 11 + C ((1823673492691 / 3035575884 : ℚ)) * X ^ 12 + C ((257311823389 / 505929314 : ℚ)) * X ^ 13 + C ((1479185968981 / 3035575884 : ℚ)) * X ^ 14 + C ((76490749036 / 252964657 : ℚ)) * X ^ 15 + C ((242684645519 / 1517787942 : ℚ)) * X ^ 16 + C ((290838192155 / 3035575884 : ℚ)) * X ^ 17 + C ((-8553725839 / 1011858628 : ℚ)) * X ^ 18
def WP19_pim : Polynomial ℚ := C ((-259686540691 / 3035575884 : ℚ)) + C ((-259686540691 / 1517787942 : ℚ)) * X + C ((-322078382573 / 1517787942 : ℚ)) * X ^ 2 + C ((-816276852509 / 3035575884 : ℚ)) * X ^ 3 + C ((-998066679413 / 3035575884 : ℚ)) * X ^ 4 + C ((-310604324939 / 1517787942 : ℚ)) * X ^ 5 + C ((-109141429135 / 1011858628 : ℚ)) * X ^ 6 + C ((-233569925 / 1517787942 : ℚ)) * X ^ 7 + C ((175926707245 / 1517787942 : ℚ)) * X ^ 8 + C ((79288998386 / 758893971 : ℚ)) * X ^ 9 + C ((258449480929 / 3035575884 : ℚ)) * X ^ 10 + C ((199142490329 / 1517787942 : ℚ)) * X ^ 11 + C ((538120480387 / 3035575884 : ℚ)) * X ^ 12 + C ((151049412884 / 758893971 : ℚ)) * X ^ 13 + C ((247206772651 / 1011858628 : ℚ)) * X ^ 14 + C ((83316750543 / 252964657 : ℚ)) * X ^ 15 + C ((167005944218 / 758893971 : ℚ)) * X ^ 16 + C ((557806040345 / 3035575884 : ℚ)) * X ^ 17 + C ((91976564227 / 1011858628 : ℚ)) * X ^ 18
theorem WP19_pre_eq :
    WA_2_0_re * WP19_Fre - WA_2_0_im * WP19_Fim = WP19_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP19_Fre, WP19_Fim, WP19_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP19_pim_eq :
    WA_2_0_re * WP19_Fim + WA_2_0_im * WP19_Fre = WP19_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP19_Fre, WP19_Fim, WP19_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP19_mul : WA_2_0 * WP19_F = ofLadj WP19_pre WP19_pim := by
  rw [WA_2_0, WP19_F, ofLadj_mul, WP19_pre_eq, WP19_pim_eq]

def WP20_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def WP20_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def WP20_F : Ki := ofLadj WP20_Fre WP20_Fim
def WP20_pre : Polynomial ℚ := C ((-38223024701 / 758893971 : ℚ)) + C ((-273761814872 / 758893971 : ℚ)) * X + C ((-537369618640 / 758893971 : ℚ)) * X ^ 2 + C ((-3018651844513 / 3035575884 : ℚ)) * X ^ 3 + C ((-99778626634 / 68990361 : ℚ)) * X ^ 4 + C ((-2682576010951 / 1517787942 : ℚ)) * X ^ 5 + C ((-898968717981 / 505929314 : ℚ)) * X ^ 6 + C ((-1470058908460 / 758893971 : ℚ)) * X ^ 7 + C ((-5522954072065 / 3035575884 : ℚ)) * X ^ 8 + C ((-2702179022209 / 1517787942 : ℚ)) * X ^ 9 + C ((-5351920397287 / 3035575884 : ℚ)) * X ^ 10 + C ((-867816549773 / 505929314 : ℚ)) * X ^ 11 + C ((-4256873137799 / 3035575884 : ℚ)) * X ^ 12 + C ((-1627439784929 / 1517787942 : ℚ)) * X ^ 13 + C ((-208691852296 / 252964657 : ℚ)) * X ^ 14 + C ((-97286113811 / 252964657 : ℚ)) * X ^ 15 + C ((-252436854271 / 3035575884 : ℚ)) * X ^ 16 + C ((-74592189429 / 1011858628 : ℚ)) * X ^ 17 + C ((7330515823 / 68990361 : ℚ)) * X ^ 18
def WP20_pim : Polynomial ℚ := C ((40935211085 / 252964657 : ℚ)) + C ((81870422170 / 252964657 : ℚ)) * X + C ((212685884911 / 758893971 : ℚ)) * X ^ 2 + C ((716811413489 / 3035575884 : ℚ)) * X ^ 3 + C ((78689105059 / 505929314 : ℚ)) * X ^ 4 + C ((-214070259679 / 758893971 : ℚ)) * X ^ 5 + C ((-401507239511 / 758893971 : ℚ)) * X ^ 6 + C ((-577135641529 / 758893971 : ℚ)) * X ^ 7 + C ((-3043554904105 / 3035575884 : ℚ)) * X ^ 8 + C ((-1494992547937 / 1517787942 : ℚ)) * X ^ 9 + C ((-2965707444055 / 3035575884 : ℚ)) * X ^ 10 + C ((-843147929825 / 758893971 : ℚ)) * X ^ 11 + C ((-1259825331515 / 1011858628 : ℚ)) * X ^ 12 + C ((-603916136055 / 505929314 : ℚ)) * X ^ 13 + C ((-858998720486 / 758893971 : ℚ)) * X ^ 14 + C ((-541876496837 / 505929314 : ℚ)) * X ^ 15 + C ((-667856373023 / 1011858628 : ℚ)) * X ^ 16 + C ((-1296859256731 / 3035575884 : ℚ)) * X ^ 17 + C ((-56255954648 / 252964657 : ℚ)) * X ^ 18
theorem WP20_pre_eq :
    WA_2_0_re * WP20_Fre - WA_2_0_im * WP20_Fim = WP20_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP20_Fre, WP20_Fim, WP20_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP20_pim_eq :
    WA_2_0_re * WP20_Fim + WA_2_0_im * WP20_Fre = WP20_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP20_Fre, WP20_Fim, WP20_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP20_mul : WA_2_0 * WP20_F = ofLadj WP20_pre WP20_pim := by
  rw [WA_2_0, WP20_F, ofLadj_mul, WP20_pre_eq, WP20_pim_eq]

def WP21_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def WP21_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def WP21_F : Ki := ofLadj WP21_Fre WP21_Fim
def WP21_pre : Polynomial ℚ := C ((-32740867 / 1517787942 : ℚ)) + C ((171101134295 / 1517787942 : ℚ)) * X + C ((64818303001 / 275961444 : ℚ)) * X ^ 2 + C ((167375695683 / 505929314 : ℚ)) * X ^ 3 + C ((1761607873853 / 3035575884 : ℚ)) * X ^ 4 + C ((1188596714851 / 1517787942 : ℚ)) * X ^ 5 + C ((884363786881 / 1011858628 : ℚ)) * X ^ 6 + C ((24107577712 / 22996787 : ℚ)) * X ^ 7 + C ((3239626354391 / 3035575884 : ℚ)) * X ^ 8 + C ((3365284157017 / 3035575884 : ℚ)) * X ^ 9 + C ((310754513383 / 275961444 : ℚ)) * X ^ 10 + C ((878761104205 / 758893971 : ℚ)) * X ^ 11 + C ((3076097378623 / 3035575884 : ℚ)) * X ^ 12 + C ((1326141412003 / 1517787942 : ℚ)) * X ^ 13 + C ((2235372180293 / 3035575884 : ℚ)) * X ^ 14 + C ((710728680649 / 1517787942 : ℚ)) * X ^ 15 + C ((58317134262 / 252964657 : ℚ)) * X ^ 16 + C ((423907680203 / 3035575884 : ℚ)) * X ^ 17 + C ((864977167 / 3035575884 : ℚ)) * X ^ 18
def WP21_pim : Polynomial ℚ := C ((-316053119149 / 3035575884 : ℚ)) + C ((-316053119149 / 1517787942 : ℚ)) * X + C ((-4769597021 / 17648697 : ℚ)) * X ^ 2 + C ((-1071781663397 / 3035575884 : ℚ)) * X ^ 3 + C ((-448763403051 / 1011858628 : ℚ)) * X ^ 4 + C ((-253254225280 / 758893971 : ℚ)) * X ^ 5 + C ((-76469922003 / 252964657 : ℚ)) * X ^ 6 + C ((-666720514243 / 3035575884 : ℚ)) * X ^ 7 + C ((-339983589497 / 3035575884 : ℚ)) * X ^ 8 + C ((-296805874237 / 3035575884 : ℚ)) * X ^ 9 + C ((-69252754012 / 758893971 : ℚ)) * X ^ 10 + C ((28794011777 / 505929314 : ℚ)) * X ^ 11 + C ((14148617213 / 68990361 : ℚ)) * X ^ 12 + C ((830598464875 / 3035575884 : ℚ)) * X ^ 13 + C ((281296788980 / 758893971 : ℚ)) * X ^ 14 + C ((1336709566333 / 3035575884 : ℚ)) * X ^ 15 + C ((320159200349 / 1011858628 : ℚ)) * X ^ 16 + C ((683600267135 / 3035575884 : ℚ)) * X ^ 17 + C ((35429369099 / 275961444 : ℚ)) * X ^ 18
theorem WP21_pre_eq :
    WA_2_0_re * WP21_Fre - WA_2_0_im * WP21_Fim = WP21_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP21_Fre, WP21_Fim, WP21_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP21_pim_eq :
    WA_2_0_re * WP21_Fim + WA_2_0_im * WP21_Fre = WP21_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP21_Fre, WP21_Fim, WP21_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP21_mul : WA_2_0 * WP21_F = ofLadj WP21_pre WP21_pim := by
  rw [WA_2_0, WP21_F, ofLadj_mul, WP21_pre_eq, WP21_pim_eq]

def WP22_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP22_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP22_F : Ki := ofLadj WP22_Fre WP22_Fim
def WP22_pre : Polynomial ℚ := C ((50231418227 / 1517787942 : ℚ)) + C ((342202268590 / 758893971 : ℚ)) * X + C ((741069627868 / 758893971 : ℚ)) * X ^ 2 + C ((351314602061 / 252964657 : ℚ)) * X ^ 3 + C ((3259473302339 / 1517787942 : ℚ)) * X ^ 4 + C ((94552450001 / 35297394 : ℚ)) * X ^ 5 + C ((2132064868075 / 758893971 : ℚ)) * X ^ 6 + C ((4710740346965 / 1517787942 : ℚ)) * X ^ 7 + C ((1508627256913 / 505929314 : ℚ)) * X ^ 8 + C ((4435807495333 / 1517787942 : ℚ)) * X ^ 9 + C ((729764446239 / 252964657 : ℚ)) * X ^ 10 + C ((392691173927 / 137980722 : ℚ)) * X ^ 11 + C ((1847091070127 / 758893971 : ℚ)) * X ^ 12 + C ((2953668239597 / 1517787942 : ℚ)) * X ^ 13 + C ((805998052791 / 505929314 : ℚ)) * X ^ 14 + C ((1351601731727 / 1517787942 : ℚ)) * X ^ 15 + C ((189884707405 / 505929314 : ℚ)) * X ^ 16 + C ((61879956018 / 252964657 : ℚ)) * X ^ 17 + C ((-99665312899 / 1517787942 : ℚ)) * X ^ 18
def WP22_pim : Polynomial ℚ := C ((-153668368001 / 505929314 : ℚ)) + C ((-153668368001 / 252964657 : ℚ)) * X + C ((-172416018545 / 252964657 : ℚ)) * X ^ 2 + C ((-49850857894 / 68990361 : ℚ)) * X ^ 3 + C ((-369821808405 / 505929314 : ℚ)) * X ^ 4 + C ((-44554675670 / 252964657 : ℚ)) * X ^ 5 + C ((206265288947 / 1517787942 : ℚ)) * X ^ 6 + C ((119191643115 / 252964657 : ℚ)) * X ^ 7 + C ((1232904825943 / 1517787942 : ℚ)) * X ^ 8 + C ((1220905094303 / 1517787942 : ℚ)) * X ^ 9 + C ((382789932663 / 505929314 : ℚ)) * X ^ 10 + C ((1543236081389 / 1517787942 : ℚ)) * X ^ 11 + C ((1938102364789 / 1517787942 : ℚ)) * X ^ 12 + C ((1978052971739 / 1517787942 : ℚ)) * X ^ 13 + C ((2028276002497 / 1517787942 : ℚ)) * X ^ 14 + C ((347605270470 / 252964657 : ℚ)) * X ^ 15 + C ((119773591765 / 137980722 : ℚ)) * X ^ 16 + C ((151335868405 / 252964657 : ℚ)) * X ^ 17 + C ((473145898477 / 1517787942 : ℚ)) * X ^ 18
theorem WP22_pre_eq :
    WA_2_0_re * WP22_Fre - WA_2_0_im * WP22_Fim = WP22_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP22_Fre, WP22_Fim, WP22_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP22_pim_eq :
    WA_2_0_re * WP22_Fim + WA_2_0_im * WP22_Fre = WP22_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP22_Fre, WP22_Fim, WP22_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP22_mul : WA_2_0 * WP22_F = ofLadj WP22_pre WP22_pim := by
  rw [WA_2_0, WP22_F, ofLadj_mul, WP22_pre_eq, WP22_pim_eq]

def WP23_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def WP23_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def WP23_F : Ki := ofLadj WP23_Fre WP23_Fim
def WP23_pre : Polynomial ℚ := C ((58237013911 / 3035575884 : ℚ)) + C ((239541588013 / 758893971 : ℚ)) * X + C ((682745661603 / 1011858628 : ℚ)) * X ^ 2 + C ((1421641761757 / 1517787942 : ℚ)) * X ^ 3 + C ((1506898104807 / 1011858628 : ℚ)) * X ^ 4 + C ((1438684542364 / 758893971 : ℚ)) * X ^ 5 + C ((3080611143139 / 1517787942 : ℚ)) * X ^ 6 + C ((3491820260281 / 1517787942 : ℚ)) * X ^ 7 + C ((6934176171455 / 3035575884 : ℚ)) * X ^ 8 + C ((1167648094287 / 505929314 : ℚ)) * X ^ 9 + C ((591352665814 / 252964657 : ℚ)) * X ^ 10 + C ((1174776778163 / 505929314 : ℚ)) * X ^ 11 + C ((1534516409429 / 758893971 : ℚ)) * X ^ 12 + C ((1652550526971 / 1011858628 : ℚ)) * X ^ 13 + C ((123966443877 / 91987148 : ℚ)) * X ^ 14 + C ((2337619715725 / 3035575884 : ℚ)) * X ^ 15 + C ((1040153703233 / 3035575884 : ℚ)) * X ^ 16 + C ((633669586411 / 3035575884 : ℚ)) * X ^ 17 + C ((-31331622604 / 758893971 : ℚ)) * X ^ 18
def WP23_pim : Polynomial ℚ := C ((-228823805945 / 1011858628 : ℚ)) + C ((-228823805945 / 505929314 : ℚ)) * X + C ((-1588395619517 / 3035575884 : ℚ)) * X ^ 2 + C ((-164244345083 / 275961444 : ℚ)) * X ^ 3 + C ((-1012635841783 / 1517787942 : ℚ)) * X ^ 4 + C ((-322602442025 / 1011858628 : ℚ)) * X ^ 5 + C ((-71111659411 / 505929314 : ℚ)) * X ^ 6 + C ((67491592165 / 1011858628 : ℚ)) * X ^ 7 + C ((312397762663 / 1011858628 : ℚ)) * X ^ 8 + C ((314448159709 / 1011858628 : ℚ)) * X ^ 9 + C ((7659671251 / 23531596 : ℚ)) * X ^ 10 + C ((442604981938 / 758893971 : ℚ)) * X ^ 11 + C ((2552742264125 / 3035575884 : ℚ)) * X ^ 12 + C ((703237040056 / 758893971 : ℚ)) * X ^ 13 + C ((506231921293 / 505929314 : ℚ)) * X ^ 14 + C ((98230858659 / 91987148 : ℚ)) * X ^ 15 + C ((2089921512929 / 3035575884 : ℚ)) * X ^ 16 + C ((245408798241 / 505929314 : ℚ)) * X ^ 17 + C ((374537795579 / 1517787942 : ℚ)) * X ^ 18
theorem WP23_pre_eq :
    WA_2_0_re * WP23_Fre - WA_2_0_im * WP23_Fim = WP23_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP23_Fre, WP23_Fim, WP23_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP23_pim_eq :
    WA_2_0_re * WP23_Fim + WA_2_0_im * WP23_Fre = WP23_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_2_0_re, WA_2_0_im, WP23_Fre, WP23_Fim, WP23_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP23_mul : WA_2_0 * WP23_F = ofLadj WP23_pre WP23_pim := by
  rw [WA_2_0, WP23_F, ofLadj_mul, WP23_pre_eq, WP23_pim_eq]

def WP24_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def WP24_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def WP24_F : Ki := ofLadj WP24_Fre WP24_Fim
def WP24_pre : Polynomial ℚ := C ((14326518411 / 505929314 : ℚ)) + C ((-84448989 / 5882899 : ℚ)) * X ^ 2 + C ((-24316347519 / 1011858628 : ℚ)) * X ^ 3 + C ((-136005680469 / 1011858628 : ℚ)) * X ^ 4 + C ((-246877122405 / 1011858628 : ℚ)) * X ^ 5 + C ((-161945024295 / 505929314 : ℚ)) * X ^ 6 + C ((-36966088383 / 91987148 : ℚ)) * X ^ 7 + C ((-113036034345 / 252964657 : ℚ)) * X ^ 8 + C ((-230761354257 / 505929314 : ℚ)) * X ^ 9 + C ((-42845033139 / 91987148 : ℚ)) * X ^ 10 + C ((-254350670715 / 505929314 : ℚ)) * X ^ 11 + C ((-42845033139 / 91987148 : ℚ)) * X ^ 12 + C ((-223498741203 / 505929314 : ℚ)) * X ^ 13 + C ((-427827789861 / 1011858628 : ℚ)) * X ^ 14 + C ((-75082167687 / 252964657 : ℚ)) * X ^ 15 + C ((-183783432813 / 1011858628 : ℚ)) * X ^ 16 + C ((-26692626657 / 252964657 : ℚ)) * X ^ 17 + C ((-7426844751 / 252964657 : ℚ)) * X ^ 18
def WP24_pim : Polynomial ℚ := C ((18577539378 / 252964657 : ℚ)) + C ((37155078756 / 252964657 : ℚ)) * X + C ((108140938533 / 505929314 : ℚ)) * X ^ 2 + C ((336933672453 / 1011858628 : ℚ)) * X ^ 3 + C ((421294248363 / 1011858628 : ℚ)) * X ^ 4 + C ((435421795431 / 1011858628 : ℚ)) * X ^ 5 + C ((111803671200 / 252964657 : ℚ)) * X ^ 6 + C ((402525066387 / 1011858628 : ℚ)) * X ^ 7 + C ((183986336487 / 505929314 : ℚ)) * X ^ 8 + C ((8415222822 / 22996787 : ℚ)) * X ^ 9 + C ((32624280543 / 91987148 : ℚ)) * X ^ 10 + C ((6192513126 / 22996787 : ℚ)) * X ^ 11 + C ((16915824465 / 91987148 : ℚ)) * X ^ 12 + C ((53504894439 / 505929314 : ℚ)) * X ^ 13 + C ((-11344875315 / 1011858628 : ℚ)) * X ^ 14 + C ((-46171882023 / 505929314 : ℚ)) * X ^ 15 + C ((-98186383821 / 1011858628 : ℚ)) * X ^ 16 + C ((-45444313149 / 505929314 : ℚ)) * X ^ 17 + C ((-9478520148 / 252964657 : ℚ)) * X ^ 18
theorem WP24_pre_eq :
    WA_1_1_re * WP24_Fre - WA_1_1_im * WP24_Fim = WP24_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP24_Fre, WP24_Fim, WP24_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP24_pim_eq :
    WA_1_1_re * WP24_Fim + WA_1_1_im * WP24_Fre = WP24_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP24_Fre, WP24_Fim, WP24_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP24_mul : WA_1_1 * WP24_F = ofLadj WP24_pre WP24_pim := by
  rw [WA_1_1, WP24_F, ofLadj_mul, WP24_pre_eq, WP24_pim_eq]

def WP25_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def WP25_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def WP25_F : Ki := ofLadj WP25_Fre WP25_Fim
def WP25_pre : Polynomial ℚ := C ((2886163485 / 252964657 : ℚ)) + C ((-33026736672 / 252964657 : ℚ)) * X + C ((-62292695855 / 252964657 : ℚ)) * X ^ 2 + C ((-86807247941 / 252964657 : ℚ)) * X ^ 3 + C ((-161132967398 / 252964657 : ℚ)) * X ^ 4 + C ((-212770113945 / 252964657 : ℚ)) * X ^ 5 + C ((-240790849350 / 252964657 : ℚ)) * X ^ 6 + C ((-260765173884 / 252964657 : ℚ)) * X ^ 7 + C ((-250313061375 / 252964657 : ℚ)) * X ^ 8 + C ((-238566803353 / 252964657 : ℚ)) * X ^ 9 + C ((-228095199905 / 252964657 : ℚ)) * X ^ 10 + C ((-226856323204 / 252964657 : ℚ)) * X ^ 11 + C ((-195068463233 / 252964657 : ℚ)) * X ^ 12 + C ((-176274107498 / 252964657 : ℚ)) * X ^ 13 + C ((-163505813434 / 252964657 : ℚ)) * X ^ 14 + C ((-100140933910 / 252964657 : ℚ)) * X ^ 15 + C ((-56852099153 / 252964657 : ℚ)) * X ^ 16 + C ((-2621033068 / 22996787 : ℚ)) * X ^ 17 + C ((-508727424 / 252964657 : ℚ)) * X ^ 18
def WP25_pim : Polynomial ℚ := C ((32082065346 / 252964657 : ℚ)) + C ((64164130692 / 252964657 : ℚ)) * X + C ((71271071272 / 252964657 : ℚ)) * X ^ 2 + C ((103505043764 / 252964657 : ℚ)) * X ^ 3 + C ((116094591666 / 252964657 : ℚ)) * X ^ 4 + C ((77835271038 / 252964657 : ℚ)) * X ^ 5 + C ((50334514623 / 252964657 : ℚ)) * X ^ 6 + C ((7479077854 / 252964657 : ℚ)) * X ^ 7 + C ((-20781638063 / 252964657 : ℚ)) * X ^ 8 + C ((-19188205354 / 252964657 : ℚ)) * X ^ 9 + C ((-12147379612 / 252964657 : ℚ)) * X ^ 10 + C ((-31025919632 / 252964657 : ℚ)) * X ^ 11 + C ((-49904459652 / 252964657 : ℚ)) * X ^ 12 + C ((-49970574490 / 252964657 : ℚ)) * X ^ 13 + C ((-80611114273 / 252964657 : ℚ)) * X ^ 14 + C ((-97383532154 / 252964657 : ℚ)) * X ^ 15 + C ((-69998093568 / 252964657 : ℚ)) * X ^ 16 + C ((-56059400665 / 252964657 : ℚ)) * X ^ 17 + C ((-24077845938 / 252964657 : ℚ)) * X ^ 18
theorem WP25_pre_eq :
    WA_1_1_re * WP25_Fre - WA_1_1_im * WP25_Fim = WP25_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP25_Fre, WP25_Fim, WP25_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP25_pim_eq :
    WA_1_1_re * WP25_Fim + WA_1_1_im * WP25_Fre = WP25_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP25_Fre, WP25_Fim, WP25_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP25_mul : WA_1_1 * WP25_F = ofLadj WP25_pre WP25_pim := by
  rw [WA_1_1, WP25_F, ofLadj_mul, WP25_pre_eq, WP25_pim_eq]

def WP26_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def WP26_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def WP26_F : Ki := ofLadj WP26_Fre WP26_Fim
def WP26_pre : Polynomial ℚ := C ((13924712124 / 252964657 : ℚ)) + C ((132106946688 / 252964657 : ℚ)) * X + C ((237950475794 / 252964657 : ℚ)) * X ^ 2 + C ((336739925120 / 252964657 : ℚ)) * X ^ 3 + C ((502685429128 / 252964657 : ℚ)) * X ^ 4 + C ((587991693788 / 252964657 : ℚ)) * X ^ 5 + C ((618596495109 / 252964657 : ℚ)) * X ^ 6 + C ((655075449131 / 252964657 : ℚ)) * X ^ 7 + C ((624266481484 / 252964657 : ℚ)) * X ^ 8 + C ((614863123585 / 252964657 : ℚ)) * X ^ 9 + C ((609428421769 / 252964657 : ℚ)) * X ^ 10 + C ((53918603456 / 22996787 : ℚ)) * X ^ 11 + C ((43392861371 / 22996787 : ℚ)) * X ^ 12 + C ((376912647791 / 252964657 : ℚ)) * X ^ 13 + C ((287526556364 / 252964657 : ℚ)) * X ^ 14 + C ((131206139935 / 252964657 : ℚ)) * X ^ 15 + C ((48150900561 / 252964657 : ℚ)) * X ^ 16 + C ((17546099240 / 252964657 : ℚ)) * X ^ 17 + C ((-21183880068 / 252964657 : ℚ)) * X ^ 18
def WP26_pim : Polynomial ℚ := C ((-62274788040 / 252964657 : ℚ)) + C ((-124549576080 / 252964657 : ℚ)) * X + C ((-96647179338 / 252964657 : ℚ)) * X ^ 2 + C ((-109549733001 / 252964657 : ℚ)) * X ^ 3 + C ((-66074261862 / 252964657 : ℚ)) * X ^ 4 + C ((65864906105 / 252964657 : ℚ)) * X ^ 5 + C ((145333126735 / 252964657 : ℚ)) * X ^ 6 + C ((226028536086 / 252964657 : ℚ)) * X ^ 7 + C ((292449492003 / 252964657 : ℚ)) * X ^ 8 + C ((291596935926 / 252964657 : ℚ)) * X ^ 9 + C ((283354044814 / 252964657 : ℚ)) * X ^ 10 + C ((2799813776 / 2090617 : ℚ)) * X ^ 11 + C ((394200888978 / 252964657 : ℚ)) * X ^ 12 + C ((358055601124 / 252964657 : ℚ)) * X ^ 13 + C ((370105598710 / 252964657 : ℚ)) * X ^ 14 + C ((331579061516 / 252964657 : ℚ)) * X ^ 15 + C ((206430872106 / 252964657 : ℚ)) * X ^ 16 + C ((135376452766 / 252964657 : ℚ)) * X ^ 17 + C ((61472021972 / 252964657 : ℚ)) * X ^ 18
theorem WP26_pre_eq :
    WA_1_1_re * WP26_Fre - WA_1_1_im * WP26_Fim = WP26_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP26_Fre, WP26_Fim, WP26_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP26_pim_eq :
    WA_1_1_re * WP26_Fim + WA_1_1_im * WP26_Fre = WP26_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP26_Fre, WP26_Fim, WP26_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP26_mul : WA_1_1 * WP26_F = ofLadj WP26_pre WP26_pim := by
  rw [WA_1_1, WP26_F, ofLadj_mul, WP26_pre_eq, WP26_pim_eq]

def WP27_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def WP27_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def WP27_F : Ki := ofLadj WP27_Fre WP27_Fim
def WP27_pre : Polynomial ℚ := C ((583590093 / 45993574 : ℚ)) + C ((-41283420840 / 252964657 : ℚ)) * X + C ((-73000830898 / 252964657 : ℚ)) * X ^ 2 + C ((-218411182589 / 505929314 : ℚ)) * X ^ 3 + C ((-194088689365 / 252964657 : ℚ)) * X ^ 4 + C ((-510599208969 / 505929314 : ℚ)) * X ^ 5 + C ((-589584526327 / 505929314 : ℚ)) * X ^ 6 + C ((-685616190051 / 505929314 : ℚ)) * X ^ 7 + C ((-356982800195 / 252964657 : ℚ)) * X ^ 8 + C ((-731239494785 / 505929314 : ℚ)) * X ^ 9 + C ((-376512471969 / 252964657 : ℚ)) * X ^ 10 + C ((-385836394732 / 252964657 : ℚ)) * X ^ 11 + C ((-335229051129 / 252964657 : ℚ)) * X ^ 12 + C ((-585237832989 / 505929314 : ℚ)) * X ^ 13 + C ((-495554417801 / 505929314 : ℚ)) * X ^ 14 + C ((-305284007025 / 505929314 : ℚ)) * X ^ 15 + C ((-81776286139 / 252964657 : ℚ)) * X ^ 16 + C ((-42283627460 / 252964657 : ℚ)) * X ^ 17 + C ((-3922597852 / 252964657 : ℚ)) * X ^ 18
def WP27_pim : Polynomial ℚ := C ((78140992323 / 505929314 : ℚ)) + C ((78140992323 / 252964657 : ℚ)) * X + C ((2116391584 / 5882899 : ℚ)) * X ^ 2 + C ((272171844115 / 505929314 : ℚ)) * X ^ 3 + C ((154335409341 / 252964657 : ℚ)) * X ^ 4 + C ((256215158677 / 505929314 : ℚ)) * X ^ 5 + C ((234920366375 / 505929314 : ℚ)) * X ^ 6 + C ((180951655125 / 505929314 : ℚ)) * X ^ 7 + C ((58494786102 / 252964657 : ℚ)) * X ^ 8 + C ((10622501907 / 45993574 : ℚ)) * X ^ 9 + C ((4830974955 / 22996787 : ℚ)) * X ^ 10 + C ((436850258 / 252964657 : ℚ)) * X ^ 11 + C ((-52267023989 / 252964657 : ℚ)) * X ^ 12 + C ((-140827811523 / 505929314 : ℚ)) * X ^ 13 + C ((-231132030641 / 505929314 : ℚ)) * X ^ 14 + C ((-264310780149 / 505929314 : ℚ)) * X ^ 15 + C ((-96400322930 / 252964657 : ℚ)) * X ^ 16 + C ((-70152746757 / 252964657 : ℚ)) * X ^ 17 + C ((-33641153990 / 252964657 : ℚ)) * X ^ 18
theorem WP27_pre_eq :
    WA_1_1_re * WP27_Fre - WA_1_1_im * WP27_Fim = WP27_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP27_Fre, WP27_Fim, WP27_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP27_pim_eq :
    WA_1_1_re * WP27_Fim + WA_1_1_im * WP27_Fre = WP27_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP27_Fre, WP27_Fim, WP27_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP27_mul : WA_1_1 * WP27_F = ofLadj WP27_pre WP27_pim := by
  rw [WA_1_1, WP27_F, ofLadj_mul, WP27_pre_eq, WP27_pim_eq]

def WP28_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP28_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP28_F : Ki := ofLadj WP28_Fre WP28_Fim
def WP28_pre : Polynomial ℚ := C ((-3079371744 / 252964657 : ℚ)) + C ((-165133683360 / 252964657 : ℚ)) * X + C ((-319945822780 / 252964657 : ℚ)) * X ^ 2 + C ((-469057319758 / 252964657 : ℚ)) * X ^ 3 + C ((-731229556522 / 252964657 : ℚ)) * X ^ 4 + C ((-20649138773 / 5882899 : ℚ)) * X ^ 5 + C ((-961846356785 / 252964657 : ℚ)) * X ^ 6 + C ((-94106097986 / 22996787 : ℚ)) * X ^ 7 + C ((-1010032406899 / 252964657 : ℚ)) * X ^ 8 + C ((-988502694946 / 252964657 : ℚ)) * X ^ 9 + C ((-976915321688 / 252964657 : ℚ)) * X ^ 10 + C ((-971896921010 / 252964657 : ℚ)) * X ^ 11 + C ((-811781638328 / 252964657 : ℚ)) * X ^ 12 + C ((-668556872166 / 252964657 : ℚ)) * X ^ 13 + C ((-540975087141 / 252964657 : ℚ)) * X ^ 14 + C ((-296069971352 / 252964657 : ℚ)) * X ^ 15 + C ((-1202257448 / 2090617 : ℚ)) * X ^ 16 + C ((-71539761662 / 252964657 : ℚ)) * X ^ 17 + C ((7867549972 / 252964657 : ℚ)) * X ^ 18
def WP28_pim : Polynomial ℚ := C ((114998563806 / 252964657 : ℚ)) + C ((229997127612 / 252964657 : ℚ)) * X + C ((21132469590 / 22996787 : ℚ)) * X ^ 2 + C ((292148681718 / 252964657 : ℚ)) * X ^ 3 + C ((266667043342 / 252964657 : ℚ)) * X ^ 4 + C ((104337777147 / 252964657 : ℚ)) * X ^ 5 + C ((6880614825 / 252964657 : ℚ)) * X ^ 6 + C ((-111406116808 / 252964657 : ℚ)) * X ^ 7 + C ((-206350903333 / 252964657 : ℚ)) * X ^ 8 + C ((-201958360928 / 252964657 : ℚ)) * X ^ 9 + C ((-187093812298 / 252964657 : ℚ)) * X ^ 10 + C ((-26112413168 / 22996787 : ℚ)) * X ^ 11 + C ((-387379277398 / 252964657 : ℚ)) * X ^ 12 + C ((-374974766646 / 252964657 : ℚ)) * X ^ 13 + C ((-430273740469 / 252964657 : ℚ)) * X ^ 14 + C ((-37823957430 / 22996787 : ℚ)) * X ^ 15 + C ((-269609333000 / 252964657 : ℚ)) * X ^ 16 + C ((-1537892736 / 2090617 : ℚ)) * X ^ 17 + C ((-7606668808 / 22996787 : ℚ)) * X ^ 18
theorem WP28_pre_eq :
    WA_1_1_re * WP28_Fre - WA_1_1_im * WP28_Fim = WP28_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP28_Fre, WP28_Fim, WP28_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP28_pim_eq :
    WA_1_1_re * WP28_Fim + WA_1_1_im * WP28_Fre = WP28_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP28_Fre, WP28_Fim, WP28_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP28_mul : WA_1_1 * WP28_F = ofLadj WP28_pre WP28_pim := by
  rw [WA_1_1, WP28_F, ofLadj_mul, WP28_pre_eq, WP28_pim_eq]

def WP29_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def WP29_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def WP29_F : Ki := ofLadj WP29_Fre WP29_Fim
def WP29_pre : Polynomial ℚ := C ((-245357766 / 252964657 : ℚ)) + C ((-115593578352 / 252964657 : ℚ)) * X + C ((-219021312625 / 252964657 : ℚ)) * X ^ 2 + C ((-627899863439 / 505929314 : ℚ)) * X ^ 3 + C ((-1009917394029 / 505929314 : ℚ)) * X ^ 4 + C ((-625478916553 / 252964657 : ℚ)) * X ^ 5 + C ((-1382935012477 / 505929314 : ℚ)) * X ^ 6 + C ((-1527235106847 / 505929314 : ℚ)) * X ^ 7 + C ((-1538123018711 / 505929314 : ℚ)) * X ^ 8 + C ((-777264318056 / 252964657 : ℚ)) * X ^ 9 + C ((-1570711327787 / 505929314 : ℚ)) * X ^ 10 + C ((-789319083764 / 252964657 : ℚ)) * X ^ 11 + C ((-1339524171083 / 505929314 : ℚ)) * X ^ 12 + C ((-558243005431 / 252964657 : ℚ)) * X ^ 13 + C ((-455111577636 / 252964657 : ℚ)) * X ^ 14 + C ((-255233808847 / 252964657 : ℚ)) * X ^ 15 + C ((-256398014503 / 505929314 : ℚ)) * X ^ 16 + C ((-5655492506 / 22996787 : ℚ)) * X ^ 17 + C ((3425047562 / 252964657 : ℚ)) * X ^ 18
def WP29_pim : Polynomial ℚ := C ((7768455015 / 22996787 : ℚ)) + C ((15536910030 / 22996787 : ℚ)) * X + C ((177705610443 / 252964657 : ℚ)) * X ^ 2 + C ((473360387637 / 505929314 : ℚ)) * X ^ 3 + C ((479535816471 / 505929314 : ℚ)) * X ^ 4 + C ((139769787953 / 252964657 : ℚ)) * X ^ 5 + C ((174459062867 / 505929314 : ℚ)) * X ^ 6 + C ((21994629463 / 505929314 : ℚ)) * X ^ 7 + C ((-104551649327 / 505929314 : ℚ)) * X ^ 8 + C ((-52774142466 / 252964657 : ℚ)) * X ^ 9 + C ((-2711679607 / 11765798 : ℚ)) * X ^ 10 + C ((-154002481636 / 252964657 : ℚ)) * X ^ 11 + C ((-45400700313 / 45993574 : ℚ)) * X ^ 12 + C ((-262030420919 / 252964657 : ℚ)) * X ^ 13 + C ((-321503322097 / 252964657 : ℚ)) * X ^ 14 + C ((-321949651527 / 252964657 : ℚ)) * X ^ 15 + C ((-428285787057 / 505929314 : ℚ)) * X ^ 16 + C ((-149955378800 / 252964657 : ℚ)) * X ^ 17 + C ((-65914524382 / 252964657 : ℚ)) * X ^ 18
theorem WP29_pre_eq :
    WA_1_1_re * WP29_Fre - WA_1_1_im * WP29_Fim = WP29_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP29_Fre, WP29_Fim, WP29_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP29_pim_eq :
    WA_1_1_re * WP29_Fim + WA_1_1_im * WP29_Fre = WP29_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WA_1_1_re, WA_1_1_im, WP29_Fre, WP29_Fim, WP29_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP29_mul : WA_1_1 * WP29_F = ofLadj WP29_pre WP29_pim := by
  rw [WA_1_1, WP29_F, ofLadj_mul, WP29_pre_eq, WP29_pim_eq]

def WP30_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def WP30_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def WP30_F : Ki := ofLadj WP30_Fre WP30_Fim
def WP30_pre : Polynomial ℚ := C ((37933474969 / 3035575884 : ℚ)) + C ((-36732232378 / 758893971 : ℚ)) * X + C ((-117267070759 / 1517787942 : ℚ)) * X ^ 2 + C ((-194969903567 / 1517787942 : ℚ)) * X ^ 3 + C ((-184436728391 / 758893971 : ℚ)) * X ^ 4 + C ((-150789831399 / 505929314 : ℚ)) * X ^ 5 + C ((-564361645403 / 1517787942 : ℚ)) * X ^ 6 + C ((-595766674993 / 1517787942 : ℚ)) * X ^ 7 + C ((-1093316979949 / 3035575884 : ℚ)) * X ^ 8 + C ((-175981877129 / 505929314 : ℚ)) * X ^ 9 + C ((-491335257697 / 1517787942 : ℚ)) * X ^ 10 + C ((-171313128043 / 505929314 : ℚ)) * X ^ 11 + C ((-417870792941 / 1517787942 : ℚ)) * X ^ 12 + C ((-205339280314 / 758893971 : ℚ)) * X ^ 13 + C ((-234459057605 / 1011858628 : ℚ)) * X ^ 14 + C ((-142574030095 / 1011858628 : ℚ)) * X ^ 15 + C ((-143000064497 / 1517787942 : ℚ)) * X ^ 16 + C ((-10335971097 / 505929314 : ℚ)) * X ^ 17 + C ((8688115379 / 1011858628 : ℚ)) * X ^ 18
def WP30_pim : Polynomial ℚ := C ((49965290855 / 1011858628 : ℚ)) + C ((49965290855 / 505929314 : ℚ)) * X + C ((7618384199 / 68990361 : ℚ)) * X ^ 2 + C ((4351831465 / 25087404 : ℚ)) * X ^ 3 + C ((84868649871 / 505929314 : ℚ)) * X ^ 4 + C ((195893476297 / 1517787942 : ℚ)) * X ^ 5 + C ((278849630735 / 3035575884 : ℚ)) * X ^ 6 + C ((210088925 / 505929314 : ℚ)) * X ^ 7 + C ((-20558721466 / 758893971 : ℚ)) * X ^ 8 + C ((-47027313523 / 1517787942 : ℚ)) * X ^ 9 + C ((-21052048595 / 1517787942 : ℚ)) * X ^ 10 + C ((-2060665861 / 45993574 : ℚ)) * X ^ 11 + C ((-114951898231 / 1517787942 : ℚ)) * X ^ 12 + C ((-53342606558 / 758893971 : ℚ)) * X ^ 13 + C ((-138850956641 / 1011858628 : ℚ)) * X ^ 14 + C ((-133369494479 / 1011858628 : ℚ)) * X ^ 15 + C ((-59894435763 / 505929314 : ℚ)) * X ^ 16 + C ((-283486117273 / 3035575884 : ℚ)) * X ^ 17 + C ((-27526699287 / 1011858628 : ℚ)) * X ^ 18
theorem WP30_pre_eq :
    WB_0_0_re * WP30_Fre - WB_0_0_im * WP30_Fim = WP30_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP30_Fre, WP30_Fim, WP30_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP30_pim_eq :
    WB_0_0_re * WP30_Fim + WB_0_0_im * WP30_Fre = WP30_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP30_Fre, WP30_Fim, WP30_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP30_mul : WB_0_0 * WP30_F = ofLadj WP30_pre WP30_pim := by
  rw [WB_0_0, WP30_F, ofLadj_mul, WP30_pre_eq, WP30_pim_eq]

def WP31_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def WP31_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def WP31_F : Ki := ofLadj WP31_Fre WP31_Fim
def WP31_pre : Polynomial ℚ := C ((14916737102 / 252964657 : ℚ)) + C ((-183661161890 / 758893971 : ℚ)) * X + C ((-89444397539 / 252964657 : ℚ)) * X ^ 2 + C ((-985739605919 / 1517787942 : ℚ)) * X ^ 3 + C ((-874346034494 / 758893971 : ℚ)) * X ^ 4 + C ((-2161462455373 / 1517787942 : ℚ)) * X ^ 5 + C ((-912007002177 / 505929314 : ℚ)) * X ^ 6 + C ((-1021963752663 / 505929314 : ℚ)) * X ^ 7 + C ((-3148900788035 / 1517787942 : ℚ)) * X ^ 8 + C ((-1069835101529 / 505929314 : ℚ)) * X ^ 9 + C ((-1679108538451 / 758893971 : ℚ)) * X ^ 10 + C ((-570720301893 / 252964657 : ℚ)) * X ^ 11 + C ((-1495447376561 / 758893971 : ℚ)) * X ^ 12 + C ((-890946306451 / 505929314 : ℚ)) * X ^ 13 + C ((-32775169426 / 22996787 : ℚ)) * X ^ 14 + C ((-1266240379247 / 1517787942 : ℚ)) * X ^ 15 + C ((-398162612399 / 758893971 : ℚ)) * X ^ 16 + C ((-110883336820 / 758893971 : ℚ)) * X ^ 17 + C ((8493134959 / 252964657 : ℚ)) * X ^ 18
def WP31_pim : Polynomial ℚ := C ((182778311659 / 758893971 : ℚ)) + C ((365556623318 / 758893971 : ℚ)) * X + C ((9888542018 / 17648697 : ℚ)) * X ^ 2 + C ((1382371335143 / 1517787942 : ℚ)) * X ^ 3 + C ((222722189346 / 252964657 : ℚ)) * X ^ 4 + C ((1287789325675 / 1517787942 : ℚ)) * X ^ 5 + C ((1139540099851 / 1517787942 : ℚ)) * X ^ 6 + C ((801118173265 / 1517787942 : ℚ)) * X ^ 7 + C ((549519825715 / 1517787942 : ℚ)) * X ^ 8 + C ((191601485895 / 505929314 : ℚ)) * X ^ 9 + C ((241735384639 / 758893971 : ℚ)) * X ^ 10 + C ((4473170263 / 758893971 : ℚ)) * X ^ 11 + C ((-232789044113 / 758893971 : ℚ)) * X ^ 12 + C ((-676213143545 / 1517787942 : ℚ)) * X ^ 13 + C ((-591442616585 / 758893971 : ℚ)) * X ^ 14 + C ((-1150270615339 / 1517787942 : ℚ)) * X ^ 15 + C ((-472239854330 / 758893971 : ℚ)) * X ^ 16 + C ((-366921894589 / 758893971 : ℚ)) * X ^ 17 + C ((-119087383157 / 758893971 : ℚ)) * X ^ 18
theorem WP31_pre_eq :
    WB_0_0_re * WP31_Fre - WB_0_0_im * WP31_Fim = WP31_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP31_Fre, WP31_Fim, WP31_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP31_pim_eq :
    WB_0_0_re * WP31_Fim + WB_0_0_im * WP31_Fre = WP31_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP31_Fre, WP31_Fim, WP31_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP31_mul : WB_0_0 * WP31_F = ofLadj WP31_pre WP31_pim := by
  rw [WB_0_0, WP31_F, ofLadj_mul, WP31_pre_eq, WP31_pim_eq]

def WP32_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP32_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP32_F : Ki := ofLadj WP32_Fre WP32_Fim
def WP32_pre : Polynomial ℚ := C ((36167774507 / 758893971 : ℚ)) + C ((-367322323780 / 758893971 : ℚ)) * X + C ((-215376953570 / 252964657 : ℚ)) * X ^ 2 + C ((-1072106184926 / 758893971 : ℚ)) * X ^ 3 + C ((-1682593502792 / 758893971 : ℚ)) * X ^ 4 + C ((-44721235279 / 17648697 : ℚ)) * X ^ 5 + C ((-744517881659 / 252964657 : ℚ)) * X ^ 6 + C ((-775361119443 / 252964657 : ℚ)) * X ^ 7 + C ((-4450087071421 / 1517787942 : ℚ)) * X ^ 8 + C ((-4355111014541 / 1517787942 : ℚ)) * X ^ 9 + C ((-4298312780131 / 1517787942 : ℚ)) * X ^ 10 + C ((-723905116926 / 252964657 : ℚ)) * X ^ 11 + C ((-3563668132571 / 1517787942 : ℚ)) * X ^ 12 + C ((-3062849293121 / 1517787942 : ℚ)) * X ^ 13 + C ((-768624900523 / 505929314 : ℚ)) * X ^ 14 + C ((-581795635994 / 758893971 : ℚ)) * X ^ 15 + C ((-362568077918 / 758893971 : ℚ)) * X ^ 16 + C ((-17342516646 / 252964657 : ℚ)) * X ^ 17 + C ((509869583 / 6271851 : ℚ)) * X ^ 18
def WP32_pim : Polynomial ℚ := C ((273726042373 / 758893971 : ℚ)) + C ((547452084746 / 758893971 : ℚ)) * X + C ((564986472584 / 758893971 : ℚ)) * X ^ 2 + C ((791060576785 / 758893971 : ℚ)) * X ^ 3 + C ((577412253412 / 758893971 : ℚ)) * X ^ 4 + C ((314598118262 / 758893971 : ℚ)) * X ^ 5 + C ((84177474416 / 758893971 : ℚ)) * X ^ 6 + C ((-92690264052 / 252964657 : ℚ)) * X ^ 7 + C ((-878633479325 / 1517787942 : ℚ)) * X ^ 8 + C ((-860314140283 / 1517787942 : ℚ)) * X ^ 9 + C ((-266805145401 / 505929314 : ℚ)) * X ^ 10 + C ((-633867726089 / 758893971 : ℚ)) * X ^ 11 + C ((-1735055468153 / 1517787942 : ℚ)) * X ^ 12 + C ((-1710225539749 / 1517787942 : ℚ)) * X ^ 13 + C ((-2144054409109 / 1517787942 : ℚ)) * X ^ 14 + C ((-293899620541 / 252964657 : ℚ)) * X ^ 15 + C ((-652424845301 / 758893971 : ℚ)) * X ^ 16 + C ((-466634114809 / 758893971 : ℚ)) * X ^ 17 + C ((-45975322355 / 252964657 : ℚ)) * X ^ 18
theorem WP32_pre_eq :
    WB_0_0_re * WP32_Fre - WB_0_0_im * WP32_Fim = WP32_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP32_Fre, WP32_Fim, WP32_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP32_pim_eq :
    WB_0_0_re * WP32_Fim + WB_0_0_im * WP32_Fre = WP32_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP32_Fre, WP32_Fim, WP32_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP32_mul : WB_0_0 * WP32_F = ofLadj WP32_pre WP32_pim := by
  rw [WB_0_0, WP32_F, ofLadj_mul, WP32_pre_eq, WP32_pim_eq]

def WP33_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def WP33_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def WP33_F : Ki := ofLadj WP33_Fre WP33_Fim
def WP33_pre : Polynomial ℚ := C ((-2966943053 / 505929314 : ℚ)) + C ((36732232378 / 252964657 : ℚ)) * X + C ((108690750611 / 505929314 : ℚ)) * X ^ 2 + C ((177274462767 / 505929314 : ℚ)) * X ^ 3 + C ((145583142853 / 252964657 : ℚ)) * X ^ 4 + C ((152372732470 / 252964657 : ℚ)) * X ^ 5 + C ((369443936193 / 505929314 : ℚ)) * X ^ 6 + C ((417830726383 / 505929314 : ℚ)) * X ^ 7 + C ((215377505943 / 252964657 : ℚ)) * X ^ 8 + C ((459925525953 / 505929314 : ℚ)) * X ^ 9 + C ((488643501733 / 505929314 : ℚ)) * X ^ 10 + C ((253221252661 / 252964657 : ℚ)) * X ^ 11 + C ((415179036977 / 505929314 : ℚ)) * X ^ 12 + C ((15965217061 / 22996787 : ℚ)) * X ^ 13 + C ((253480549119 / 505929314 : ℚ)) * X ^ 14 + C ((108995739289 / 505929314 : ℚ)) * X ^ 15 + C ((35997164074 / 252964657 : ℚ)) * X ^ 16 + C ((7295856895 / 505929314 : ℚ)) * X ^ 17 + C ((-8834350694 / 252964657 : ℚ)) * X ^ 18
def WP33_pim : Polynomial ℚ := C ((-47398761999 / 505929314 : ℚ)) + C ((-47398761999 / 252964657 : ℚ)) * X + C ((-89852166703 / 505929314 : ℚ)) * X ^ 2 + C ((-73843768385 / 252964657 : ℚ)) * X ^ 3 + C ((-50397821907 / 252964657 : ℚ)) * X ^ 4 + C ((-61520888531 / 505929314 : ℚ)) * X ^ 5 + C ((-30934389379 / 252964657 : ℚ)) * X ^ 6 + C ((-9221844385 / 505929314 : ℚ)) * X ^ 7 + C ((9105253684 / 252964657 : ℚ)) * X ^ 8 + C ((10196924036 / 252964657 : ℚ)) * X ^ 9 + C ((19607548695 / 252964657 : ℚ)) * X ^ 10 + C ((61550160990 / 252964657 : ℚ)) * X ^ 11 + C ((9408433935 / 22996787 : ℚ)) * X ^ 12 + C ((220861438593 / 505929314 : ℚ)) * X ^ 13 + C ((140440074682 / 252964657 : ℚ)) * X ^ 14 + C ((224620852235 / 505929314 : ℚ)) * X ^ 15 + C ((78898216746 / 252964657 : ℚ)) * X ^ 16 + C ((116996353759 / 505929314 : ℚ)) * X ^ 17 + C ((18399877963 / 252964657 : ℚ)) * X ^ 18
theorem WP33_pre_eq :
    WB_0_0_re * WP33_Fre - WB_0_0_im * WP33_Fim = WP33_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP33_Fre, WP33_Fim, WP33_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP33_pim_eq :
    WB_0_0_re * WP33_Fim + WB_0_0_im * WP33_Fre = WP33_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP33_Fre, WP33_Fim, WP33_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP33_mul : WB_0_0 * WP33_F = ofLadj WP33_pre WP33_pim := by
  rw [WB_0_0, WP33_F, ofLadj_mul, WP33_pre_eq, WP33_pim_eq]

def WP34_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def WP34_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def WP34_F : Ki := ofLadj WP34_Fre WP34_Fim
def WP34_pre : Polynomial ℚ := C ((-105536380468 / 758893971 : ℚ)) + C ((1028502506584 / 758893971 : ℚ)) * X + C ((14514358403 / 6271851 : ℚ)) * X ^ 2 + C ((2899814749067 / 758893971 : ℚ)) * X ^ 3 + C ((4595096008364 / 758893971 : ℚ)) * X ^ 4 + C ((40635055761 / 5882899 : ℚ)) * X ^ 5 + C ((142706429507 / 17648697 : ℚ)) * X ^ 6 + C ((6413742061772 / 758893971 : ℚ)) * X ^ 7 + C ((6161521640891 / 758893971 : ℚ)) * X ^ 8 + C ((6055982997850 / 758893971 : ℚ)) * X ^ 9 + C ((6038825208496 / 758893971 : ℚ)) * X ^ 10 + C ((6094442003086 / 758893971 : ℚ)) * X ^ 11 + C ((151827960664 / 22996787 : ℚ)) * X ^ 12 + C ((4299745631087 / 758893971 : ℚ)) * X ^ 13 + C ((1087235630608 / 252964657 : ℚ)) * X ^ 14 + C ((1615309752131 / 758893971 : ℚ)) * X ^ 15 + C ((1008380330843 / 758893971 : ℚ)) * X ^ 16 + C ((37975351737 / 252964657 : ℚ)) * X ^ 17 + C ((-203336301277 / 758893971 : ℚ)) * X ^ 18
def WP34_pim : Polynomial ℚ := C ((-257926455040 / 252964657 : ℚ)) + C ((-515852910080 / 252964657 : ℚ)) * X + C ((-520813710855 / 252964657 : ℚ)) * X ^ 2 + C ((-751508946465 / 252964657 : ℚ)) * X ^ 3 + C ((-1647200283736 / 758893971 : ℚ)) * X ^ 4 + C ((-945074555878 / 758893971 : ℚ)) * X ^ 5 + C ((-287360402536 / 758893971 : ℚ)) * X ^ 6 + C ((240900202376 / 252964657 : ℚ)) * X ^ 7 + C ((401470599903 / 252964657 : ℚ)) * X ^ 8 + C ((389210168854 / 252964657 : ℚ)) * X ^ 9 + C ((102544825517 / 68990361 : ℚ)) * X ^ 10 + C ((611200401618 / 252964657 : ℚ)) * X ^ 11 + C ((2539209329021 / 758893971 : ℚ)) * X ^ 12 + C ((838151435157 / 252964657 : ℚ)) * X ^ 13 + C ((1056586239718 / 252964657 : ℚ)) * X ^ 14 + C ((2630072984251 / 758893971 : ℚ)) * X ^ 15 + C ((651707667436 / 252964657 : ℚ)) * X ^ 16 + C ((1396955635574 / 758893971 : ℚ)) * X ^ 17 + C ((12547587025 / 22996787 : ℚ)) * X ^ 18
theorem WP34_pre_eq :
    WB_0_0_re * WP34_Fre - WB_0_0_im * WP34_Fim = WP34_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP34_Fre, WP34_Fim, WP34_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP34_pim_eq :
    WB_0_0_re * WP34_Fim + WB_0_0_im * WP34_Fre = WP34_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP34_Fre, WP34_Fim, WP34_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP34_mul : WB_0_0 * WP34_F = ofLadj WP34_pre WP34_pim := by
  rw [WB_0_0, WP34_F, ofLadj_mul, WP34_pre_eq, WP34_pim_eq]

def WP35_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def WP35_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def WP35_F : Ki := ofLadj WP35_Fre WP35_Fim
def WP35_pre : Polynomial ℚ := C ((8100000765 / 505929314 : ℚ)) + C ((-36732232378 / 758893971 : ℚ)) * X + C ((-42412287963 / 505929314 : ℚ)) * X ^ 2 + C ((-111889495457 / 758893971 : ℚ)) * X ^ 3 + C ((-192024659245 / 758893971 : ℚ)) * X ^ 4 + C ((-162970677999 / 505929314 : ℚ)) * X ^ 5 + C ((-197058873381 / 505929314 : ℚ)) * X ^ 6 + C ((-297438567809 / 758893971 : ℚ)) * X ^ 7 + C ((-181342202391 / 505929314 : ℚ)) * X ^ 8 + C ((-250052959405 / 758893971 : ℚ)) * X ^ 9 + C ((-473319656429 / 1517787942 : ℚ)) * X ^ 10 + C ((-236432933360 / 758893971 : ℚ)) * X ^ 11 + C ((-133285063891 / 505929314 : ℚ)) * X ^ 12 + C ((-33897186811 / 137980722 : ℚ)) * X ^ 13 + C ((-320247616259 / 1517787942 : ℚ)) * X ^ 14 + C ((-96579557870 / 758893971 : ℚ)) * X ^ 15 + C ((-460594960 / 5882899 : ℚ)) * X ^ 16 + C ((-2761485589 / 252964657 : ℚ)) * X ^ 17 + C ((8834350694 / 758893971 : ℚ)) * X ^ 18
def WP35_pim : Polynomial ℚ := C ((84130994377 / 1517787942 : ℚ)) + C ((84130994377 / 758893971 : ℚ)) * X + C ((181277803477 / 1517787942 : ℚ)) * X ^ 2 + C ((266075307893 / 1517787942 : ℚ)) * X ^ 3 + C ((11198554249 / 68990361 : ℚ)) * X ^ 4 + C ((98362827182 / 758893971 : ℚ)) * X ^ 5 + C ((31853217635 / 505929314 : ℚ)) * X ^ 6 + C ((-3301791475 / 252964657 : ℚ)) * X ^ 7 + C ((-38581851815 / 758893971 : ℚ)) * X ^ 8 + C ((-94200902 / 2090617 : ℚ)) * X ^ 9 + C ((-8040890355 / 252964657 : ℚ)) * X ^ 10 + C ((-43184044801 / 758893971 : ℚ)) * X ^ 11 + C ((-62245418537 / 758893971 : ℚ)) * X ^ 12 + C ((-39120713025 / 505929314 : ℚ)) * X ^ 13 + C ((-64461931571 / 505929314 : ℚ)) * X ^ 14 + C ((-97115939576 / 758893971 : ℚ)) * X ^ 15 + C ((-56927519317 / 505929314 : ℚ)) * X ^ 16 + C ((-20996156628 / 252964657 : ℚ)) * X ^ 17 + C ((-18399877963 / 758893971 : ℚ)) * X ^ 18
theorem WP35_pre_eq :
    WB_0_0_re * WP35_Fre - WB_0_0_im * WP35_Fim = WP35_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP35_Fre, WP35_Fim, WP35_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP35_pim_eq :
    WB_0_0_re * WP35_Fim + WB_0_0_im * WP35_Fre = WP35_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_0_re, WB_0_0_im, WP35_Fre, WP35_Fim, WP35_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP35_mul : WB_0_0 * WP35_F = ofLadj WP35_pre WP35_pim := by
  rw [WB_0_0, WP35_F, ofLadj_mul, WP35_pre_eq, WP35_pim_eq]

def WP36_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def WP36_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def WP36_F : Ki := ofLadj WP36_Fre WP36_Fim
def WP36_pre : Polynomial ℚ := C ((-5712924511 / 505929314 : ℚ)) + C ((-168144798724 / 758893971 : ℚ)) * X + C ((-356448849445 / 758893971 : ℚ)) * X ^ 2 + C ((-2305541600275 / 3035575884 : ℚ)) * X ^ 3 + C ((-3819698205911 / 3035575884 : ℚ)) * X ^ 4 + C ((-4936275528491 / 3035575884 : ℚ)) * X ^ 5 + C ((-1968653187891 / 1011858628 : ℚ)) * X ^ 6 + C ((-3192295486679 / 1517787942 : ℚ)) * X ^ 7 + C ((-1980733012139 / 1011858628 : ℚ)) * X ^ 8 + C ((-1865801344887 / 1011858628 : ℚ)) * X ^ 9 + C ((-1799338879667 / 1011858628 : ℚ)) * X ^ 10 + C ((-2615238290729 / 1517787942 : ℚ)) * X ^ 11 + C ((-4725437444105 / 3035575884 : ℚ)) * X ^ 12 + C ((-4171608636881 / 3035575884 : ℚ)) * X ^ 13 + C ((-1818328718071 / 1517787942 : ℚ)) * X ^ 14 + C ((-2394609432305 / 3035575884 : ℚ)) * X ^ 15 + C ((-485144350791 / 1011858628 : ℚ)) * X ^ 16 + C ((-485749017191 / 3035575884 : ℚ)) * X ^ 17 + C ((28380555857 / 505929314 : ℚ)) * X ^ 18
def WP36_pim : Polynomial ℚ := C ((313377290861 / 1517787942 : ℚ)) + C ((313377290861 / 758893971 : ℚ)) * X + C ((38624142356 / 68990361 : ℚ)) * X ^ 2 + C ((2227487355761 / 3035575884 : ℚ)) * X ^ 3 + C ((2278811205751 / 3035575884 : ℚ)) * X ^ 4 + C ((548357039913 / 1011858628 : ℚ)) * X ^ 5 + C ((306683856131 / 1011858628 : ℚ)) * X ^ 6 + C ((-92136047501 / 758893971 : ℚ)) * X ^ 7 + C ((-1169774644981 / 3035575884 : ℚ)) * X ^ 8 + C ((-1101440198809 / 3035575884 : ℚ)) * X ^ 9 + C ((-903516454721 / 3035575884 : ℚ)) * X ^ 10 + C ((-101965533589 / 252964657 : ℚ)) * X ^ 11 + C ((-1543656351415 / 3035575884 : ℚ)) * X ^ 12 + C ((-1791685707547 / 3035575884 : ℚ)) * X ^ 13 + C ((-562844088368 / 758893971 : ℚ)) * X ^ 14 + C ((-823237380791 / 1011858628 : ℚ)) * X ^ 15 + C ((-2061597754115 / 3035575884 : ℚ)) * X ^ 16 + C ((-1697188576709 / 3035575884 : ℚ)) * X ^ 17 + C ((-105703086011 / 505929314 : ℚ)) * X ^ 18
theorem WP36_pre_eq :
    WB_1_0_re * WP36_Fre - WB_1_0_im * WP36_Fim = WP36_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP36_Fre, WP36_Fim, WP36_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP36_pim_eq :
    WB_1_0_re * WP36_Fim + WB_1_0_im * WP36_Fre = WP36_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP36_Fre, WP36_Fim, WP36_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP36_mul : WB_1_0 * WP36_F = ofLadj WP36_pre WP36_pim := by
  rw [WB_1_0, WP36_F, ofLadj_mul, WP36_pre_eq, WP36_pim_eq]

def WP37_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def WP37_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def WP37_F : Ki := ofLadj WP37_Fre WP37_Fim
def WP37_pre : Polynomial ℚ := C ((-47627907106 / 758893971 : ℚ)) + C ((-840723993620 / 758893971 : ℚ)) * X + C ((-566000206520 / 252964657 : ℚ)) * X ^ 2 + C ((-959227005978 / 252964657 : ℚ)) * X ^ 3 + C ((-4628742847882 / 758893971 : ℚ)) * X ^ 4 + C ((-2010824370996 / 252964657 : ℚ)) * X ^ 5 + C ((-2428181389116 / 252964657 : ℚ)) * X ^ 6 + C ((-8403648443015 / 758893971 : ℚ)) * X ^ 7 + C ((-8495163561772 / 758893971 : ℚ)) * X ^ 8 + C ((-2944015299399 / 252964657 : ℚ)) * X ^ 9 + C ((-9014143294454 / 758893971 : ℚ)) * X ^ 10 + C ((-9087285436402 / 758893971 : ℚ)) * X ^ 11 + C ((-2724473100278 / 252964657 : ℚ)) * X ^ 12 + C ((-2378015092879 / 252964657 : ℚ)) * X ^ 13 + C ((-510680231258 / 68990361 : ℚ)) * X ^ 14 + C ((-329188308613 / 68990361 : ℚ)) * X ^ 15 + C ((-682399443021 / 252964657 : ℚ)) * X ^ 16 + C ((-265042424901 / 252964657 : ℚ)) * X ^ 17 + C ((153834200390 / 758893971 : ℚ)) * X ^ 18
def WP37_pim : Polynomial ℚ := C ((254141709104 / 252964657 : ℚ)) + C ((508283418208 / 252964657 : ℚ)) * X + C ((16756385758 / 5882899 : ℚ)) * X ^ 2 + C ((2895145349695 / 758893971 : ℚ)) * X ^ 3 + C ((1038007861931 / 252964657 : ℚ)) * X ^ 4 + C ((2693089281934 / 758893971 : ℚ)) * X ^ 5 + C ((2350011214676 / 758893971 : ℚ)) * X ^ 6 + C ((1319543938325 / 758893971 : ℚ)) * X ^ 7 + C ((577684194782 / 758893971 : ℚ)) * X ^ 8 + C ((166727698525 / 252964657 : ℚ)) * X ^ 9 + C ((321577865395 / 758893971 : ℚ)) * X ^ 10 + C ((-730795209896 / 758893971 : ℚ)) * X ^ 11 + C ((-1783168285187 / 758893971 : ℚ)) * X ^ 12 + C ((-2598497023525 / 758893971 : ℚ)) * X ^ 13 + C ((-309960882695 / 68990361 : ℚ)) * X ^ 14 + C ((-3459697322108 / 758893971 : ℚ)) * X ^ 15 + C ((-2828346951269 / 758893971 : ℚ)) * X ^ 16 + C ((-195590337319 / 68990361 : ℚ)) * X ^ 17 + C ((-910610367178 / 758893971 : ℚ)) * X ^ 18
theorem WP37_pre_eq :
    WB_1_0_re * WP37_Fre - WB_1_0_im * WP37_Fim = WP37_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP37_Fre, WP37_Fim, WP37_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP37_pim_eq :
    WB_1_0_re * WP37_Fim + WB_1_0_im * WP37_Fre = WP37_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP37_Fre, WP37_Fim, WP37_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP37_mul : WB_1_0 * WP37_F = ofLadj WP37_pre WP37_pim := by
  rw [WB_1_0, WP37_F, ofLadj_mul, WP37_pre_eq, WP37_pim_eq]

def WP38_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP38_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP38_F : Ki := ofLadj WP38_Fre WP38_Fim
def WP38_pre : Polynomial ℚ := C ((-190875279682 / 758893971 : ℚ)) + C ((-1681447987240 / 758893971 : ℚ)) * X + C ((-1188351787388 / 252964657 : ℚ)) * X ^ 2 + C ((-5834616947275 / 758893971 : ℚ)) * X ^ 3 + C ((-8603623847333 / 758893971 : ℚ)) * X ^ 4 + C ((-80022769643 / 5882899 : ℚ)) * X ^ 5 + C ((-11541975744322 / 758893971 : ℚ)) * X ^ 6 + C ((-4113806232815 / 252964657 : ℚ)) * X ^ 7 + C ((-3904290539499 / 252964657 : ℚ)) * X ^ 8 + C ((-11498759649743 / 758893971 : ℚ)) * X ^ 9 + C ((-11324108645095 / 758893971 : ℚ)) * X ^ 10 + C ((-3690054752068 / 252964657 : ℚ)) * X ^ 11 + C ((-3214220219285 / 252964657 : ℚ)) * X ^ 12 + C ((-7933704287579 / 758893971 : ℚ)) * X ^ 13 + C ((-5878254671222 / 758893971 : ℚ)) * X ^ 14 + C ((-1105264455662 / 252964657 : ℚ)) * X ^ 15 + C ((-1718662013722 / 758893971 : ℚ)) * X ^ 16 + C ((-166541184449 / 252964657 : ℚ)) * X ^ 17 + C ((422001484126 / 758893971 : ℚ)) * X ^ 18
def WP38_pim : Polynomial ℚ := C ((1104488257814 / 758893971 : ℚ)) + C ((2208976515628 / 758893971 : ℚ)) * X + C ((916226735264 / 252964657 : ℚ)) * X ^ 2 + C ((3052955412635 / 758893971 : ℚ)) * X ^ 3 + C ((2331189169291 / 758893971 : ℚ)) * X ^ 4 + C ((656300558995 / 758893971 : ℚ)) * X ^ 5 + C ((-19836287184 / 22996787 : ℚ)) * X ^ 6 + C ((-2537895273217 / 758893971 : ℚ)) * X ^ 7 + C ((-3688342138610 / 758893971 : ℚ)) * X ^ 8 + C ((-3662552715893 / 758893971 : ℚ)) * X ^ 9 + C ((-3515487904490 / 758893971 : ℚ)) * X ^ 10 + C ((-4404124397462 / 758893971 : ℚ)) * X ^ 11 + C ((-5292760890434 / 758893971 : ℚ)) * X ^ 12 + C ((-5685399769195 / 758893971 : ℚ)) * X ^ 13 + C ((-1987961851107 / 252964657 : ℚ)) * X ^ 14 + C ((-5327310747884 / 758893971 : ℚ)) * X ^ 15 + C ((-1281284287840 / 252964657 : ℚ)) * X ^ 16 + C ((-2757122497699 / 758893971 : ℚ)) * X ^ 17 + C ((-1065255427486 / 758893971 : ℚ)) * X ^ 18
theorem WP38_pre_eq :
    WB_1_0_re * WP38_Fre - WB_1_0_im * WP38_Fim = WP38_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP38_Fre, WP38_Fim, WP38_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP38_pim_eq :
    WB_1_0_re * WP38_Fim + WB_1_0_im * WP38_Fre = WP38_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP38_Fre, WP38_Fim, WP38_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP38_mul : WB_1_0 * WP38_F = ofLadj WP38_pre WP38_pim := by
  rw [WB_1_0, WP38_F, ofLadj_mul, WP38_pre_eq, WP38_pim_eq]

def WP39_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def WP39_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def WP39_F : Ki := ofLadj WP39_Fre WP39_Fim
def WP39_pre : Polynomial ℚ := C ((22912306587 / 252964657 : ℚ)) + C ((168144798724 / 252964657 : ℚ)) * X + C ((27847467079 / 22996787 : ℚ)) * X ^ 2 + C ((985850827035 / 505929314 : ℚ)) * X ^ 3 + C ((1461838224119 / 505929314 : ℚ)) * X ^ 4 + C ((849139613419 / 252964657 : ℚ)) * X ^ 5 + C ((958916241755 / 252964657 : ℚ)) * X ^ 6 + C ((2213500820757 / 505929314 : ℚ)) * X ^ 7 + C ((1129267499380 / 252964657 : ℚ)) * X ^ 8 + C ((1219998159088 / 252964657 : ℚ)) * X ^ 9 + C ((2570601868035 / 505929314 : ℚ)) * X ^ 10 + C ((1285738689190 / 252964657 : ℚ)) * X ^ 11 + C ((2234312270587 / 505929314 : ℚ)) * X ^ 12 + C ((913676021219 / 252964657 : ℚ)) * X ^ 13 + C ((1272684171725 / 505929314 : ℚ)) * X ^ 14 + C ((314957902917 / 252964657 : ℚ)) * X ^ 15 + C ((152945615486 / 252964657 : ℚ)) * X ^ 16 + C ((43168987150 / 252964657 : ℚ)) * X ^ 17 + C ((-60873395402 / 252964657 : ℚ)) * X ^ 18
def WP39_pim : Polynomial ℚ := C ((-93634345909 / 252964657 : ℚ)) + C ((-187268691818 / 252964657 : ℚ)) * X + C ((-228999607715 / 252964657 : ℚ)) * X ^ 2 + C ((-551652164479 / 505929314 : ℚ)) * X ^ 3 + C ((-39110228439 / 45993574 : ℚ)) * X ^ 4 + C ((-84485022407 / 252964657 : ℚ)) * X ^ 5 + C ((-3997630559 / 22996787 : ℚ)) * X ^ 6 + C ((155583672817 / 505929314 : ℚ)) * X ^ 7 + C ((180013922050 / 252964657 : ℚ)) * X ^ 8 + C ((193036178366 / 252964657 : ℚ)) * X ^ 9 + C ((511300167729 / 505929314 : ℚ)) * X ^ 10 + C ((432005199810 / 252964657 : ℚ)) * X ^ 11 + C ((110610966501 / 45993574 : ℚ)) * X ^ 12 + C ((712705137151 / 252964657 : ℚ)) * X ^ 13 + C ((1545107735983 / 505929314 : ℚ)) * X ^ 14 + C ((671747918564 / 252964657 : ℚ)) * X ^ 15 + C ((466154553691 / 252964657 : ℚ)) * X ^ 16 + C ((339046112667 / 252964657 : ℚ)) * X ^ 17 + C ((142308209244 / 252964657 : ℚ)) * X ^ 18
theorem WP39_pre_eq :
    WB_1_0_re * WP39_Fre - WB_1_0_im * WP39_Fim = WP39_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP39_Fre, WP39_Fim, WP39_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP39_pim_eq :
    WB_1_0_re * WP39_Fim + WB_1_0_im * WP39_Fre = WP39_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP39_Fre, WP39_Fim, WP39_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP39_mul : WB_1_0 * WP39_F = ofLadj WP39_pre WP39_pim := by
  rw [WB_1_0, WP39_F, ofLadj_mul, WP39_pre_eq, WP39_pim_eq]

def WP40_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def WP40_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def WP40_F : Ki := ofLadj WP40_Fre WP40_Fim
def WP40_pre : Polynomial ℚ := C ((175600408624 / 252964657 : ℚ)) + C ((4708054364272 / 758893971 : ℚ)) * X + C ((3248744071102 / 252964657 : ℚ)) * X ^ 2 + C ((5303456442054 / 252964657 : ℚ)) * X ^ 3 + C ((23454759192812 / 758893971 : ℚ)) * X ^ 4 + C ((656841463595 / 17648697 : ℚ)) * X ^ 5 + C ((735606570418 / 17648697 : ℚ)) * X ^ 6 + C ((34099800032930 / 758893971 : ℚ)) * X ^ 7 + C ((32332500451519 / 758893971 : ℚ)) * X ^ 8 + C ((2910664976809 / 68990361 : ℚ)) * X ^ 9 + C ((10561564135163 / 252964657 : ℚ)) * X ^ 10 + C ((31095899438528 / 758893971 : ℚ)) * X ^ 11 + C ((26976638041217 / 758893971 : ℚ)) * X ^ 12 + C ((22271082531593 / 758893971 : ℚ)) * X ^ 13 + C ((16422131125357 / 758893971 : ℚ)) * X ^ 14 + C ((9240840462184 / 758893971 : ℚ)) * X ^ 15 + C ((4646280835466 / 758893971 : ℚ)) * X ^ 16 + C ((419793747359 / 252964657 : ℚ)) * X ^ 17 + C ((-1404200377934 / 758893971 : ℚ)) * X ^ 18
def WP40_pim : Polynomial ℚ := C ((-284199643784 / 68990361 : ℚ)) + C ((-568399287568 / 68990361 : ℚ)) * X + C ((-701049620870 / 68990361 : ℚ)) * X ^ 2 + C ((-8710410365882 / 758893971 : ℚ)) * X ^ 3 + C ((-2272649398240 / 252964657 : ℚ)) * X ^ 4 + C ((-735225384325 / 252964657 : ℚ)) * X ^ 5 + C ((473529434500 / 252964657 : ℚ)) * X ^ 6 + C ((2264642693554 / 252964657 : ℚ)) * X ^ 7 + C ((10096823299549 / 758893971 : ℚ)) * X ^ 8 + C ((10084196434351 / 758893971 : ℚ)) * X ^ 9 + C ((3276111257003 / 252964657 : ℚ)) * X ^ 10 + C ((4200193330284 / 252964657 : ℚ)) * X ^ 11 + C ((5124275403565 / 252964657 : ℚ)) * X ^ 12 + C ((16576117213675 / 758893971 : ℚ)) * X ^ 13 + C ((1596577716799 / 68990361 : ℚ)) * X ^ 14 + C ((15768797082680 / 758893971 : ℚ)) * X ^ 15 + C ((11515092934412 / 758893971 : ℚ)) * X ^ 16 + C ((8218762733519 / 758893971 : ℚ)) * X ^ 17 + C ((3203990849834 / 758893971 : ℚ)) * X ^ 18
theorem WP40_pre_eq :
    WB_1_0_re * WP40_Fre - WB_1_0_im * WP40_Fim = WP40_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP40_Fre, WP40_Fim, WP40_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP40_pim_eq :
    WB_1_0_re * WP40_Fim + WB_1_0_im * WP40_Fre = WP40_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP40_Fre, WP40_Fim, WP40_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP40_mul : WB_1_0 * WP40_F = ofLadj WP40_pre WP40_pim := by
  rw [WB_1_0, WP40_F, ofLadj_mul, WP40_pre_eq, WP40_pim_eq]

def WP41_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def WP41_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def WP41_F : Ki := ofLadj WP41_Fre WP41_Fim
def WP41_pre : Polynomial ℚ := C ((-3788413493 / 758893971 : ℚ)) + C ((-168144798724 / 758893971 : ℚ)) * X + C ((-379532384335 / 758893971 : ℚ)) * X ^ 2 + C ((-116689359137 / 137980722 : ℚ)) * X ^ 3 + C ((-2019279471617 / 1517787942 : ℚ)) * X ^ 4 + C ((-1311825454136 / 758893971 : ℚ)) * X ^ 5 + C ((-3066617852317 / 1517787942 : ℚ)) * X ^ 6 + C ((-49094374577 / 22996787 : ℚ)) * X ^ 7 + C ((-1454404158379 / 758893971 : ℚ)) * X ^ 8 + C ((-1347675407704 / 758893971 : ℚ)) * X ^ 9 + C ((-1260793369102 / 758893971 : ℚ)) * X ^ 10 + C ((-1234457783131 / 758893971 : ℚ)) * X ^ 11 + C ((-364216190126 / 252964657 : ℚ)) * X ^ 12 + C ((-322714341123 / 252964657 : ℚ)) * X ^ 13 + C ((-1625225366251 / 1517787942 : ℚ)) * X ^ 14 + C ((-366400819887 / 505929314 : ℚ)) * X ^ 15 + C ((-14011980577 / 35297394 : ℚ)) * X ^ 16 + C ((-7252191853 / 68990361 : ℚ)) * X ^ 17 + C ((60873395402 / 758893971 : ℚ)) * X ^ 18
def WP41_pim : Polynomial ℚ := C ((5385052887 / 22996787 : ℚ)) + C ((10770105774 / 22996787 : ℚ)) * X + C ((154043361843 / 252964657 : ℚ)) * X ^ 2 + C ((1117687845899 / 1517787942 : ℚ)) * X ^ 3 + C ((372395562853 / 505929314 : ℚ)) * X ^ 4 + C ((378521777054 / 758893971 : ℚ)) * X ^ 5 + C ((302051511919 / 1517787942 : ℚ)) * X ^ 6 + C ((-59015666939 / 252964657 : ℚ)) * X ^ 7 + C ((-32971394096 / 68990361 : ℚ)) * X ^ 8 + C ((-350220055357 / 758893971 : ℚ)) * X ^ 9 + C ((-90737373317 / 252964657 : ℚ)) * X ^ 10 + C ((-347932800448 / 758893971 : ℚ)) * X ^ 11 + C ((-423653480945 / 758893971 : ℚ)) * X ^ 12 + C ((-452362140526 / 758893971 : ℚ)) * X ^ 13 + C ((-1073221396495 / 1517787942 : ℚ)) * X ^ 14 + C ((-1159380489145 / 1517787942 : ℚ)) * X ^ 15 + C ((-332307127437 / 505929314 : ℚ)) * X ^ 16 + C ((-123846317404 / 252964657 : ℚ)) * X ^ 17 + C ((-47436069748 / 252964657 : ℚ)) * X ^ 18
theorem WP41_pre_eq :
    WB_1_0_re * WP41_Fre - WB_1_0_im * WP41_Fim = WP41_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP41_Fre, WP41_Fim, WP41_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP41_pim_eq :
    WB_1_0_re * WP41_Fim + WB_1_0_im * WP41_Fre = WP41_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_0_re, WB_1_0_im, WP41_Fre, WP41_Fim, WP41_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP41_mul : WB_1_0 * WP41_F = ofLadj WP41_pre WP41_pim := by
  rw [WB_1_0, WP41_F, ofLadj_mul, WP41_pre_eq, WP41_pim_eq]

def WP42_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def WP42_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def WP42_F : Ki := ofLadj WP42_Fre WP42_Fim
def WP42_pre : Polynomial ℚ := C ((2905591600 / 252964657 : ℚ)) + C ((238498860428 / 758893971 : ℚ)) * X + C ((987552054143 / 1517787942 : ℚ)) * X ^ 2 + C ((1603420175645 / 1517787942 : ℚ)) * X ^ 3 + C ((2668984221905 / 1517787942 : ℚ)) * X ^ 4 + C ((1719786346937 / 758893971 : ℚ)) * X ^ 5 + C ((1375585519973 / 505929314 : ℚ)) * X ^ 6 + C ((4446870794737 / 1517787942 : ℚ)) * X ^ 7 + C ((4145968986481 / 1517787942 : ℚ)) * X ^ 8 + C ((1956806997011 / 758893971 : ℚ)) * X ^ 9 + C ((626929848720 / 252964657 : ℚ)) * X ^ 10 + C ((1833227718538 / 758893971 : ℚ)) * X ^ 11 + C ((1642290685732 / 758893971 : ℚ)) * X ^ 12 + C ((2926061939879 / 1517787942 : ℚ)) * X ^ 13 + C ((1271274405418 / 758893971 : ℚ)) * X ^ 14 + C ((1669566635531 / 1517787942 : ℚ)) * X ^ 15 + C ((1022306977979 / 1517787942 : ℚ)) * X ^ 16 + C ((55853851989 / 252964657 : ℚ)) * X ^ 17 + C ((-36106645767 / 505929314 : ℚ)) * X ^ 18
def WP42_pim : Polynomial ℚ := C ((-446463257353 / 1517787942 : ℚ)) + C ((-446463257353 / 758893971 : ℚ)) * X + C ((-592842235954 / 758893971 : ℚ)) * X ^ 2 + C ((-264408077845 / 252964657 : ℚ)) * X ^ 3 + C ((-1608307371439 / 1517787942 : ℚ)) * X ^ 4 + C ((-1170565254829 / 1517787942 : ℚ)) * X ^ 5 + C ((-337689143560 / 758893971 : ℚ)) * X ^ 6 + C ((234894888007 / 1517787942 : ℚ)) * X ^ 7 + C ((769743790235 / 1517787942 : ℚ)) * X ^ 8 + C ((66093152311 / 137980722 : ℚ)) * X ^ 9 + C ((588379010603 / 1517787942 : ℚ)) * X ^ 10 + C ((410324747039 / 758893971 : ℚ)) * X ^ 11 + C ((350973325851 / 505929314 : ℚ)) * X ^ 12 + C ((402344089979 / 505929314 : ℚ)) * X ^ 13 + C ((142279740935 / 137980722 : ℚ)) * X ^ 14 + C ((564572818563 / 505929314 : ℚ)) * X ^ 15 + C ((21612988961 / 22996787 : ℚ)) * X ^ 16 + C ((389286247991 / 505929314 : ℚ)) * X ^ 17 + C ((142688833731 / 505929314 : ℚ)) * X ^ 18
theorem WP42_pre_eq :
    WB_0_1_re * WP42_Fre - WB_0_1_im * WP42_Fim = WP42_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP42_Fre, WP42_Fim, WP42_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP42_pim_eq :
    WB_0_1_re * WP42_Fim + WB_0_1_im * WP42_Fre = WP42_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP42_Fre, WP42_Fim, WP42_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP42_mul : WB_0_1 * WP42_F = ofLadj WP42_pre WP42_pim := by
  rw [WB_0_1, WP42_F, ofLadj_mul, WP42_pre_eq, WP42_pim_eq]

def WP43_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def WP43_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def WP43_F : Ki := ofLadj WP43_Fre WP43_Fim
def WP43_pre : Polynomial ℚ := C ((50856436901 / 758893971 : ℚ)) + C ((1192494302140 / 758893971 : ℚ)) * X + C ((213451409416 / 68990361 : ℚ)) * X ^ 2 + C ((4004733577531 / 758893971 : ℚ)) * X ^ 3 + C ((6461945759536 / 758893971 : ℚ)) * X ^ 4 + C ((8393418945035 / 758893971 : ℚ)) * X ^ 5 + C ((3391279578877 / 252964657 : ℚ)) * X ^ 6 + C ((11689916352203 / 758893971 : ℚ)) * X ^ 7 + C ((3953696079008 / 252964657 : ℚ)) * X ^ 8 + C ((4101614000269 / 252964657 : ℚ)) * X ^ 9 + C ((12582896060860 / 758893971 : ℚ)) * X ^ 10 + C ((4227089975738 / 252964657 : ℚ)) * X ^ 11 + C ((3796800586240 / 252964657 : ℚ)) * X ^ 12 + C ((9956876497231 / 758893971 : ℚ)) * X ^ 13 + C ((7856354659493 / 758893971 : ℚ)) * X ^ 14 + C ((5038825835209 / 758893971 : ℚ)) * X ^ 15 + C ((959179658892 / 252964657 : ℚ)) * X ^ 16 + C ((1097119185080 / 758893971 : ℚ)) * X ^ 17 + C ((-63048252486 / 252964657 : ℚ)) * X ^ 18
def WP43_pim : Polynomial ℚ := C ((-362115261943 / 252964657 : ℚ)) + C ((-724230523886 / 252964657 : ℚ)) * X + C ((-70177044514 / 17648697 : ℚ)) * X ^ 2 + C ((-4126249324913 / 758893971 : ℚ)) * X ^ 3 + C ((-4383182879332 / 758893971 : ℚ)) * X ^ 4 + C ((-3838138905319 / 758893971 : ℚ)) * X ^ 5 + C ((-3359036430113 / 758893971 : ℚ)) * X ^ 6 + C ((-175843566883 / 68990361 : ℚ)) * X ^ 7 + C ((-915149520068 / 758893971 : ℚ)) * X ^ 8 + C ((-830059104095 / 758893971 : ℚ)) * X ^ 9 + C ((-568049444476 / 758893971 : ℚ)) * X ^ 10 + C ((918754148162 / 758893971 : ℚ)) * X ^ 11 + C ((2405557740800 / 758893971 : ℚ)) * X ^ 12 + C ((3512488742863 / 758893971 : ℚ)) * X ^ 13 + C ((4706215569647 / 758893971 : ℚ)) * X ^ 14 + C ((432255210887 / 68990361 : ℚ)) * X ^ 15 + C ((3894075307744 / 758893971 : ℚ)) * X ^ 16 + C ((989305584118 / 252964657 : ℚ)) * X ^ 17 + C ((409157173318 / 252964657 : ℚ)) * X ^ 18
theorem WP43_pre_eq :
    WB_0_1_re * WP43_Fre - WB_0_1_im * WP43_Fim = WP43_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP43_Fre, WP43_Fim, WP43_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP43_pim_eq :
    WB_0_1_re * WP43_Fim + WB_0_1_im * WP43_Fre = WP43_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP43_Fre, WP43_Fim, WP43_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP43_mul : WB_0_1 * WP43_F = ofLadj WP43_pre WP43_pim := by
  rw [WB_0_1, WP43_F, ofLadj_mul, WP43_pre_eq, WP43_pim_eq]

def WP44_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP44_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP44_F : Ki := ofLadj WP44_Fre WP44_Fim
def WP44_pre : Polynomial ℚ := C ((247164131822 / 758893971 : ℚ)) + C ((2384988604280 / 758893971 : ℚ)) * X + C ((1656059208152 / 252964657 : ℚ)) * X ^ 2 + C ((8148315379852 / 758893971 : ℚ)) * X ^ 3 + C ((1094543564540 / 68990361 : ℚ)) * X ^ 4 + C ((334823370337 / 17648697 : ℚ)) * X ^ 5 + C ((5385898185493 / 252964657 : ℚ)) * X ^ 6 + C ((17218866423412 / 758893971 : ℚ)) * X ^ 7 + C ((16387102032737 / 758893971 : ℚ)) * X ^ 8 + C ((16083860289040 / 758893971 : ℚ)) * X ^ 9 + C ((15842918515232 / 758893971 : ℚ)) * X ^ 10 + C ((5169773433952 / 252964657 : ℚ)) * X ^ 11 + C ((4485976636984 / 252964657 : ℚ)) * X ^ 12 + C ((11115682664584 / 758893971 : ℚ)) * X ^ 13 + C ((8238786652885 / 758893971 : ℚ)) * X ^ 14 + C ((1544050499006 / 252964657 : ℚ)) * X ^ 15 + C ((2445519812552 / 758893971 : ℚ)) * X ^ 16 + C ((228410060188 / 252964657 : ℚ)) * X ^ 17 + C ((-182245238818 / 252964657 : ℚ)) * X ^ 18
def WP44_pim : Polynomial ℚ := C ((-1576444420588 / 758893971 : ℚ)) + C ((-3152888841176 / 758893971 : ℚ)) * X + C ((-3842881952270 / 758893971 : ℚ)) * X ^ 2 + C ((-4378495451540 / 758893971 : ℚ)) * X ^ 3 + C ((-1106001519976 / 252964657 : ℚ)) * X ^ 4 + C ((-1026848372717 / 758893971 : ℚ)) * X ^ 5 + C ((786790145675 / 758893971 : ℚ)) * X ^ 6 + C ((3415550935052 / 758893971 : ℚ)) * X ^ 7 + C ((1659961371675 / 252964657 : ℚ)) * X ^ 8 + C ((4938965511232 / 758893971 : ℚ)) * X ^ 9 + C ((4735775350268 / 758893971 : ℚ)) * X ^ 10 + C ((2003746117938 / 252964657 : ℚ)) * X ^ 11 + C ((7286701357360 / 758893971 : ℚ)) * X ^ 12 + C ((7773504307490 / 758893971 : ℚ)) * X ^ 13 + C ((250551490999 / 22996787 : ℚ)) * X ^ 14 + C ((7331405595446 / 758893971 : ℚ)) * X ^ 15 + C ((482356556212 / 68990361 : ℚ)) * X ^ 16 + C ((3803723975162 / 758893971 : ℚ)) * X ^ 17 + C ((480211965294 / 252964657 : ℚ)) * X ^ 18
theorem WP44_pre_eq :
    WB_0_1_re * WP44_Fre - WB_0_1_im * WP44_Fim = WP44_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP44_Fre, WP44_Fim, WP44_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP44_pim_eq :
    WB_0_1_re * WP44_Fim + WB_0_1_im * WP44_Fre = WP44_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP44_Fre, WP44_Fim, WP44_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP44_mul : WB_0_1 * WP44_F = ofLadj WP44_pre WP44_pim := by
  rw [WB_0_1, WP44_F, ofLadj_mul, WP44_pre_eq, WP44_pim_eq]

def WP45_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def WP45_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def WP45_F : Ki := ofLadj WP45_Fre WP45_Fim
def WP45_pre : Polynomial ℚ := C ((-30534463503 / 252964657 : ℚ)) + C ((-238498860428 / 252964657 : ℚ)) * X + C ((-38751571224 / 22996787 : ℚ)) * X ^ 2 + C ((-686999410565 / 252964657 : ℚ)) * X ^ 3 + C ((-1024969881093 / 252964657 : ℚ)) * X ^ 4 + C ((-1180783692249 / 252964657 : ℚ)) * X ^ 5 + C ((-1342671120987 / 252964657 : ℚ)) * X ^ 6 + C ((-1544863913218 / 252964657 : ℚ)) * X ^ 7 + C ((-1579722168929 / 252964657 : ℚ)) * X ^ 8 + C ((-1705395801859 / 252964657 : ℚ)) * X ^ 9 + C ((-1797925524480 / 252964657 : ℚ)) * X ^ 10 + C ((-1799940912984 / 252964657 : ℚ)) * X ^ 11 + C ((-1559426664052 / 252964657 : ℚ)) * X ^ 12 + C ((-1279128518395 / 252964657 : ℚ)) * X ^ 13 + C ((-892722758364 / 252964657 : ℚ)) * X ^ 14 + C ((-440806961305 / 252964657 : ℚ)) * X ^ 15 + C ((-220710982885 / 252964657 : ℚ)) * X ^ 16 + C ((-58823554147 / 252964657 : ℚ)) * X ^ 17 + C ((79087070820 / 252964657 : ℚ)) * X ^ 18
def WP45_pim : Polynomial ℚ := C ((12163141456 / 22996787 : ℚ)) + C ((24326282912 / 22996787 : ℚ)) * X + C ((319685095500 / 252964657 : ℚ)) * X ^ 2 + C ((396671528244 / 252964657 : ℚ)) * X ^ 3 + C ((27674925378 / 22996787 : ℚ)) * X ^ 4 + C ((127688327859 / 252964657 : ℚ)) * X ^ 5 + C ((74395686075 / 252964657 : ℚ)) * X ^ 6 + C ((-97088995045 / 252964657 : ℚ)) * X ^ 7 + C ((-235221347287 / 252964657 : ℚ)) * X ^ 8 + C ((-254096661465 / 252964657 : ℚ)) * X ^ 9 + C ((-338033724728 / 252964657 : ℚ)) * X ^ 10 + C ((-589198892360 / 252964657 : ℚ)) * X ^ 11 + C ((-840364059992 / 252964657 : ℚ)) * X ^ 12 + C ((-976397106723 / 252964657 : ℚ)) * X ^ 13 + C ((-1072258853645 / 252964657 : ℚ)) * X ^ 14 + C ((-925600818731 / 252964657 : ℚ)) * X ^ 15 + C ((-58514318129 / 22996787 : ℚ)) * X ^ 16 + C ((-469235187203 / 252964657 : ℚ)) * X ^ 17 + C ((-192543038070 / 252964657 : ℚ)) * X ^ 18
theorem WP45_pre_eq :
    WB_0_1_re * WP45_Fre - WB_0_1_im * WP45_Fim = WP45_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP45_Fre, WP45_Fim, WP45_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP45_pim_eq :
    WB_0_1_re * WP45_Fim + WB_0_1_im * WP45_Fre = WP45_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP45_Fre, WP45_Fim, WP45_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP45_mul : WB_0_1 * WP45_F = ofLadj WP45_pre WP45_pim := by
  rw [WB_0_1, WP45_F, ofLadj_mul, WP45_pre_eq, WP45_pim_eq]

def WP46_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def WP46_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def WP46_F : Ki := ofLadj WP46_Fre WP46_Fim
def WP46_pre : Polynomial ℚ := C ((-226807822820 / 252964657 : ℚ)) + C ((-6677968091984 / 758893971 : ℚ)) * X + C ((-13575000585584 / 758893971 : ℚ)) * X ^ 2 + C ((-22207111055324 / 758893971 : ℚ)) * X ^ 3 + C ((-32830339528706 / 758893971 : ℚ)) * X ^ 4 + C ((-27747709398 / 534809 : ℚ)) * X ^ 5 + C ((-1030082400748 / 17648697 : ℚ)) * X ^ 6 + C ((-4323839974922 / 68990361 : ℚ)) * X ^ 7 + C ((-45247363458194 / 758893971 : ℚ)) * X ^ 8 + C ((-44777515619732 / 758893971 : ℚ)) * X ^ 9 + C ((-44344711956584 / 758893971 : ℚ)) * X ^ 10 + C ((-1319805863072 / 22996787 : ℚ)) * X ^ 11 + C ((-12555581288200 / 252964657 : ℚ)) * X ^ 12 + C ((-10400838344716 / 252964657 : ℚ)) * X ^ 13 + C ((-7680084134290 / 252964657 : ℚ)) * X ^ 14 + C ((-12906023787290 / 758893971 : ℚ)) * X ^ 15 + C ((-6638513168032 / 758893971 : ℚ)) * X ^ 16 + C ((-572989857210 / 252964657 : ℚ)) * X ^ 17 + C ((608625469382 / 252964657 : ℚ)) * X ^ 18
def WP46_pim : Polynomial ℚ := C ((4461744149732 / 758893971 : ℚ)) + C ((8923488299464 / 758893971 : ℚ)) * X + C ((10772914659394 / 758893971 : ℚ)) * X ^ 2 + C ((4163494326650 / 252964657 : ℚ)) * X ^ 3 + C ((9685818452972 / 758893971 : ℚ)) * X ^ 4 + C ((1128634242644 / 252964657 : ℚ)) * X ^ 5 + C ((-1646254982464 / 758893971 : ℚ)) * X ^ 6 + C ((-829945283650 / 68990361 : ℚ)) * X ^ 7 + C ((-4544955078266 / 252964657 : ℚ)) * X ^ 8 + C ((-4530955433860 / 252964657 : ℚ)) * X ^ 9 + C ((-13245891634768 / 758893971 : ℚ)) * X ^ 10 + C ((-17213065567364 / 758893971 : ℚ)) * X ^ 11 + C ((-7060079833320 / 252964657 : ℚ)) * X ^ 12 + C ((-22682691193078 / 758893971 : ℚ)) * X ^ 13 + C ((-8119420193472 / 252964657 : ℚ)) * X ^ 14 + C ((-7241135973956 / 252964657 : ℚ)) * X ^ 15 + C ((-15896186062816 / 758893971 : ℚ)) * X ^ 16 + C ((-11346104517916 / 758893971 : ℚ)) * X ^ 17 + C ((-1445218415406 / 252964657 : ℚ)) * X ^ 18
theorem WP46_pre_eq :
    WB_0_1_re * WP46_Fre - WB_0_1_im * WP46_Fim = WP46_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP46_Fre, WP46_Fim, WP46_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP46_pim_eq :
    WB_0_1_re * WP46_Fim + WB_0_1_im * WP46_Fre = WP46_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP46_Fre, WP46_Fim, WP46_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP46_mul : WB_0_1 * WP46_F = ofLadj WP46_pre WP46_pim := by
  rw [WB_0_1, WP46_F, ofLadj_mul, WP46_pre_eq, WP46_pim_eq]

def WP47_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def WP47_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def WP47_F : Ki := ofLadj WP47_Fre WP47_Fim
def WP47_pre : Polynomial ℚ := C ((1444211899 / 758893971 : ℚ)) + C ((238498860428 / 758893971 : ℚ)) * X + C ((175325230714 / 252964657 : ℚ)) * X ^ 2 + C ((298080638705 / 252964657 : ℚ)) * X ^ 3 + C ((1409759830580 / 758893971 : ℚ)) * X ^ 4 + C ((1829047380715 / 758893971 : ℚ)) * X ^ 5 + C ((2144809050182 / 758893971 : ℚ)) * X ^ 6 + C ((2254121969255 / 758893971 : ℚ)) * X ^ 7 + C ((677403935265 / 252964657 : ℚ)) * X ^ 8 + C ((1881885027764 / 758893971 : ℚ)) * X ^ 9 + C ((160254438590 / 68990361 : ℚ)) * X ^ 10 + C ((1725432409540 / 758893971 : ℚ)) * X ^ 11 + C ((1524299964062 / 758893971 : ℚ)) * X ^ 12 + C ((1355909335622 / 758893971 : ℚ)) * X ^ 13 + C ((379323296560 / 252964657 : ℚ)) * X ^ 14 + C ((255091689285 / 252964657 : ℚ)) * X ^ 15 + C ((9870684371 / 17648697 : ℚ)) * X ^ 16 + C ((9879796226 / 68990361 : ℚ)) * X ^ 17 + C ((-26362356940 / 252964657 : ℚ)) * X ^ 18
def WP47_pim : Polynomial ℚ := C ((-84347995410 / 252964657 : ℚ)) + C ((-168695990820 / 252964657 : ℚ)) * X + C ((-644144806034 / 758893971 : ℚ)) * X ^ 2 + C ((-795980883917 / 758893971 : ℚ)) * X ^ 3 + C ((-262802370051 / 252964657 : ℚ)) * X ^ 4 + C ((-181013168855 / 252964657 : ℚ)) * X ^ 5 + C ((-74247254687 / 252964657 : ℚ)) * X ^ 6 + C ((231177360461 / 758893971 : ℚ)) * X ^ 7 + C ((485742377881 / 758893971 : ℚ)) * X ^ 8 + C ((466055212673 / 758893971 : ℚ)) * X ^ 9 + C ((120406349463 / 252964657 : ℚ)) * X ^ 10 + C ((469949462146 / 758893971 : ℚ)) * X ^ 11 + C ((578679875903 / 758893971 : ℚ)) * X ^ 12 + C ((611900545193 / 758893971 : ℚ)) * X ^ 13 + C ((248016485956 / 252964657 : ℚ)) * X ^ 14 + C ((266165887818 / 252964657 : ℚ)) * X ^ 15 + C ((229125536734 / 252964657 : ℚ)) * X ^ 16 + C ((512215612256 / 758893971 : ℚ)) * X ^ 17 + C ((64181012690 / 252964657 : ℚ)) * X ^ 18
theorem WP47_pre_eq :
    WB_0_1_re * WP47_Fre - WB_0_1_im * WP47_Fim = WP47_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP47_Fre, WP47_Fim, WP47_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP47_pim_eq :
    WB_0_1_re * WP47_Fim + WB_0_1_im * WP47_Fre = WP47_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_0_1_re, WB_0_1_im, WP47_Fre, WP47_Fim, WP47_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP47_mul : WB_0_1 * WP47_F = ofLadj WP47_pre WP47_pim := by
  rw [WB_0_1, WP47_F, ofLadj_mul, WP47_pre_eq, WP47_pim_eq]

def WP48_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def WP48_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def WP48_F : Ki := ofLadj WP48_Fre WP48_Fim
def WP48_pre : Polynomial ℚ := C ((1665806594 / 252964657 : ℚ)) + C ((5669487707 / 252964657 : ℚ)) * X + C ((12776140335 / 252964657 : ℚ)) * X ^ 2 + C ((83785207789 / 1011858628 : ℚ)) * X ^ 3 + C ((254672001659 / 2023717256 : ℚ)) * X ^ 4 + C ((42340570368 / 252964657 : ℚ)) * X ^ 5 + C ((399941311285 / 2023717256 : ℚ)) * X ^ 6 + C ((19538128069 / 91987148 : ℚ)) * X ^ 7 + C ((411362370095 / 2023717256 : ℚ)) * X ^ 8 + C ((96199347867 / 505929314 : ℚ)) * X ^ 9 + C ((373196721189 / 2023717256 : ℚ)) * X ^ 10 + C ((43994825080 / 252964657 : ℚ)) * X ^ 11 + C ((327840819533 / 2023717256 : ℚ)) * X ^ 12 + C ((70647067197 / 505929314 : ℚ)) * X ^ 13 + C ((243791954517 / 2023717256 : ℚ)) * X ^ 14 + C ((169633838459 / 2023717256 : ℚ)) * X ^ 15 + C ((12497170159 / 252964657 : ℚ)) * X ^ 16 + C ((38760612931 / 2023717256 : ℚ)) * X ^ 17 + C ((-691622175 / 252964657 : ℚ)) * X ^ 18
def WP48_pim : Polynomial ℚ := C ((-39118563281 / 2023717256 : ℚ)) + C ((-39118563281 / 1011858628 : ℚ)) * X + C ((-111432683951 / 2023717256 : ℚ)) * X ^ 2 + C ((-71033677507 / 1011858628 : ℚ)) * X ^ 3 + C ((-142459276291 / 2023717256 : ℚ)) * X ^ 4 + C ((-102991363735 / 2023717256 : ℚ)) * X ^ 5 + C ((-55272977119 / 2023717256 : ℚ)) * X ^ 6 + C ((7267935429 / 505929314 : ℚ)) * X ^ 7 + C ((42942006423 / 1011858628 : ℚ)) * X ^ 8 + C ((76868864535 / 2023717256 : ℚ)) * X ^ 9 + C ((8524377087 / 252964657 : ℚ)) * X ^ 10 + C ((3890900029 / 91987148 : ℚ)) * X ^ 11 + C ((25751146145 / 505929314 : ℚ)) * X ^ 12 + C ((63763147065 / 1011858628 : ℚ)) * X ^ 13 + C ((74572908441 / 1011858628 : ℚ)) * X ^ 14 + C ((163441510769 / 2023717256 : ℚ)) * X ^ 15 + C ((138330113957 / 2023717256 : ℚ)) * X ^ 16 + C ((112896701611 / 2023717256 : ℚ)) * X ^ 17 + C ((5363562315 / 252964657 : ℚ)) * X ^ 18
theorem WP48_pre_eq :
    WB_2_0_re * WP48_Fre - WB_2_0_im * WP48_Fim = WP48_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP48_Fre, WP48_Fim, WP48_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP48_pim_eq :
    WB_2_0_re * WP48_Fim + WB_2_0_im * WP48_Fre = WP48_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP48_Fre, WP48_Fim, WP48_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP48_mul : WB_2_0 * WP48_F = ofLadj WP48_pre WP48_pim := by
  rw [WB_2_0, WP48_F, ofLadj_mul, WP48_pre_eq, WP48_pim_eq]

def WP49_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def WP49_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def WP49_F : Ki := ofLadj WP49_Fre WP49_Fim
def WP49_pre : Polynomial ℚ := C ((33174169213 / 1011858628 : ℚ)) + C ((28347438535 / 252964657 : ℚ)) * X + C ((61971749585 / 252964657 : ℚ)) * X ^ 2 + C ((207840684985 / 505929314 : ℚ)) * X ^ 3 + C ((312642448705 / 505929314 : ℚ)) * X ^ 4 + C ((417158316229 / 505929314 : ℚ)) * X ^ 5 + C ((249433590819 / 252964657 : ℚ)) * X ^ 6 + C ((285523249929 / 252964657 : ℚ)) * X ^ 7 + C ((1171957355399 / 1011858628 : ℚ)) * X ^ 8 + C ((609501667673 / 505929314 : ℚ)) * X ^ 9 + C ((28071386019 / 22996787 : ℚ)) * X ^ 10 + C ((613148165643 / 505929314 : ℚ)) * X ^ 11 + C ((280437807674 / 252964657 : ℚ)) * X ^ 12 + C ((485558168503 / 505929314 : ℚ)) * X ^ 13 + C ((756275985429 / 1011858628 : ℚ)) * X ^ 14 + C ((256379015929 / 505929314 : ℚ)) * X ^ 15 + C ((71179052094 / 252964657 : ℚ)) * X ^ 16 + C ((60649238779 / 505929314 : ℚ)) * X ^ 17 + C ((-1012517612 / 252964657 : ℚ)) * X ^ 18
def WP49_pim : Polynomial ℚ := C ((-94961664349 / 1011858628 : ℚ)) + C ((-94961664349 / 505929314 : ℚ)) * X + C ((-1660294874 / 5882899 : ℚ)) * X ^ 2 + C ((-183106641943 / 505929314 : ℚ)) * X ^ 3 + C ((-199533260263 / 505929314 : ℚ)) * X ^ 4 + C ((-84920845187 / 252964657 : ℚ)) * X ^ 5 + C ((-150825486219 / 505929314 : ℚ)) * X ^ 6 + C ((-38913701201 / 252964657 : ℚ)) * X ^ 7 + C ((-61703113763 / 1011858628 : ℚ)) * X ^ 8 + C ((-12701504059 / 252964657 : ℚ)) * X ^ 9 + C ((-12017825989 / 505929314 : ℚ)) * X ^ 10 + C ((53139617581 / 505929314 : ℚ)) * X ^ 11 + C ((118297061151 / 505929314 : ℚ)) * X ^ 12 + C ((16318721645 / 45993574 : ℚ)) * X ^ 13 + C ((450551539275 / 1011858628 : ℚ)) * X ^ 14 + C ((113934302615 / 252964657 : ℚ)) * X ^ 15 + C ((188551879247 / 505929314 : ℚ)) * X ^ 16 + C ((143432868159 / 505929314 : ℚ)) * X ^ 17 + C ((30404814124 / 252964657 : ℚ)) * X ^ 18
theorem WP49_pre_eq :
    WB_2_0_re * WP49_Fre - WB_2_0_im * WP49_Fim = WP49_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP49_Fre, WP49_Fim, WP49_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP49_pim_eq :
    WB_2_0_re * WP49_Fim + WB_2_0_im * WP49_Fre = WP49_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP49_Fre, WP49_Fim, WP49_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP49_mul : WB_2_0 * WP49_F = ofLadj WP49_pre WP49_pim := by
  rw [WB_2_0, WP49_F, ofLadj_mul, WP49_pre_eq, WP49_pim_eq]

def WP50_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP50_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP50_F : Ki := ofLadj WP50_Fre WP50_Fim
def WP50_pre : Polynomial ℚ := C ((31754542543 / 505929314 : ℚ)) + C ((56694877070 / 252964657 : ℚ)) * X + C ((247769544991 / 505929314 : ℚ)) * X ^ 2 + C ((204233979527 / 252964657 : ℚ)) * X ^ 3 + C ((287420065868 / 252964657 : ℚ)) * X ^ 4 + C ((32727723307 / 23531596 : ℚ)) * X ^ 5 + C ((1568217688215 / 1011858628 : ℚ)) * X ^ 6 + C ((835016133539 / 505929314 : ℚ)) * X ^ 7 + C ((73130232183 / 45993574 : ℚ)) * X ^ 8 + C ((1581206610661 / 1011858628 : ℚ)) * X ^ 9 + C ((1556808510761 / 1011858628 : ℚ)) * X ^ 10 + C ((743488693711 / 505929314 : ℚ)) * X ^ 11 + C ((1330029002481 / 1011858628 : ℚ)) * X ^ 12 + C ((1085667520679 / 1011858628 : ℚ)) * X ^ 13 + C ((395964594959 / 505929314 : ℚ)) * X ^ 14 + C ((242003807939 / 505929314 : ℚ)) * X ^ 15 + C ((61198581853 / 252964657 : ℚ)) * X ^ 16 + C ((41934370699 / 505929314 : ℚ)) * X ^ 17 + C ((-826008812 / 22996787 : ℚ)) * X ^ 18
def WP50_pim : Polynomial ℚ := C ((-33307112907 / 252964657 : ℚ)) + C ((-66614225814 / 252964657 : ℚ)) * X + C ((-87723901953 / 252964657 : ℚ)) * X ^ 2 + C ((-183561457609 / 505929314 : ℚ)) * X ^ 3 + C ((-69448123439 / 252964657 : ℚ)) * X ^ 4 + C ((-54146200235 / 1011858628 : ℚ)) * X ^ 5 + C ((10886749113 / 91987148 : ℚ)) * X ^ 6 + C ((92530203528 / 252964657 : ℚ)) * X ^ 7 + C ((131682009224 / 252964657 : ℚ)) * X ^ 8 + C ((522198228863 / 1011858628 : ℚ)) * X ^ 9 + C ((505667353139 / 1011858628 : ℚ)) * X ^ 10 + C ((304711304907 / 505929314 : ℚ)) * X ^ 11 + C ((64834351499 / 91987148 : ℚ)) * X ^ 12 + C ((781085695321 / 1011858628 : ℚ)) * X ^ 13 + C ((396391597347 / 505929314 : ℚ)) * X ^ 14 + C ((178380931360 / 252964657 : ℚ)) * X ^ 15 + C ((258325278469 / 505929314 : ℚ)) * X ^ 16 + C ((185064859713 / 505929314 : ℚ)) * X ^ 17 + C ((36634067644 / 252964657 : ℚ)) * X ^ 18
theorem WP50_pre_eq :
    WB_2_0_re * WP50_Fre - WB_2_0_im * WP50_Fim = WP50_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP50_Fre, WP50_Fim, WP50_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP50_pim_eq :
    WB_2_0_re * WP50_Fim + WB_2_0_im * WP50_Fre = WP50_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP50_Fre, WP50_Fim, WP50_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP50_mul : WB_2_0 * WP50_F = ofLadj WP50_pre WP50_pim := by
  rw [WB_2_0, WP50_F, ofLadj_mul, WP50_pre_eq, WP50_pim_eq]

def WP51_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def WP51_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def WP51_F : Ki := ofLadj WP51_Fre WP51_Fim
def WP51_pre : Polynomial ℚ := C ((-18712015125 / 1011858628 : ℚ)) + C ((-17008463121 / 252964657 : ℚ)) * X + C ((-128802590127 / 1011858628 : ℚ)) * X ^ 2 + C ((-207700467477 / 1011858628 : ℚ)) * X ^ 3 + C ((-146110106121 / 505929314 : ℚ)) * X ^ 4 + C ((-87612490182 / 252964657 : ℚ)) * X ^ 5 + C ((-393688002009 / 1011858628 : ℚ)) * X ^ 6 + C ((-225275642505 / 505929314 : ℚ)) * X ^ 7 + C ((-462781610835 / 1011858628 : ℚ)) * X ^ 8 + C ((-125792025798 / 252964657 : ℚ)) * X ^ 9 + C ((-132175169925 / 252964657 : ℚ)) * X ^ 10 + C ((-128162235336 / 252964657 : ℚ)) * X ^ 11 + C ((-115166706804 / 252964657 : ℚ)) * X ^ 12 + C ((-374365513065 / 1011858628 : ℚ)) * X ^ 13 + C ((-127540571679 / 505929314 : ℚ)) * X ^ 14 + C ((-35500801176 / 252964657 : ℚ)) * X ^ 15 + C ((-65730625635 / 1011858628 : ℚ)) * X ^ 16 + C ((-11246292177 / 505929314 : ℚ)) * X ^ 17 + C ((4081967016 / 252964657 : ℚ)) * X ^ 18
def WP51_pim : Polynomial ℚ := C ((8291287560 / 252964657 : ℚ)) + C ((16582575120 / 252964657 : ℚ)) * X + C ((91427069007 / 1011858628 : ℚ)) * X ^ 2 + C ((97357511121 / 1011858628 : ℚ)) * X ^ 3 + C ((78461516835 / 1011858628 : ℚ)) * X ^ 4 + C ((29506398309 / 1011858628 : ℚ)) * X ^ 5 + C ((2336799273 / 505929314 : ℚ)) * X ^ 6 + C ((-41357376381 / 1011858628 : ℚ)) * X ^ 7 + C ((-81338322375 / 1011858628 : ℚ)) * X ^ 8 + C ((-91540039113 / 1011858628 : ℚ)) * X ^ 9 + C ((-113738499189 / 1011858628 : ℚ)) * X ^ 10 + C ((-44856272580 / 252964657 : ℚ)) * X ^ 11 + C ((-245111681451 / 1011858628 : ℚ)) * X ^ 12 + C ((-146203455027 / 505929314 : ℚ)) * X ^ 13 + C ((-154269534453 / 505929314 : ℚ)) * X ^ 14 + C ((-135329359083 / 505929314 : ℚ)) * X ^ 15 + C ((-188832591303 / 1011858628 : ℚ)) * X ^ 16 + C ((-34466821428 / 252964657 : ℚ)) * X ^ 17 + C ((-14741325612 / 252964657 : ℚ)) * X ^ 18
theorem WP51_pre_eq :
    WB_2_0_re * WP51_Fre - WB_2_0_im * WP51_Fim = WP51_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP51_Fre, WP51_Fim, WP51_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP51_pim_eq :
    WB_2_0_re * WP51_Fim + WB_2_0_im * WP51_Fre = WP51_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP51_Fre, WP51_Fim, WP51_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP51_mul : WB_2_0 * WP51_F = ofLadj WP51_pre WP51_pim := by
  rw [WB_2_0, WP51_F, ofLadj_mul, WP51_pre_eq, WP51_pim_eq]

def WP52_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def WP52_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def WP52_F : Ki := ofLadj WP52_Fre WP52_Fim
def WP52_pre : Polynomial ℚ := C ((-44513144627 / 252964657 : ℚ)) + C ((-158745655796 / 252964657 : ℚ)) * X + C ((-338848243718 / 252964657 : ℚ)) * X ^ 2 + C ((-558383949694 / 252964657 : ℚ)) * X ^ 3 + C ((-783398358959 / 252964657 : ℚ)) * X ^ 4 + C ((-44745311729 / 11765798 : ℚ)) * X ^ 5 + C ((-49975811341 / 11765798 : ℚ)) * X ^ 6 + C ((-1153144627715 / 252964657 : ℚ)) * X ^ 7 + C ((-1109412709049 / 252964657 : ℚ)) * X ^ 8 + C ((-1100819712106 / 252964657 : ℚ)) * X ^ 9 + C ((-197804459311 / 45993574 : ℚ)) * X ^ 10 + C ((-94810573613 / 22996787 : ℚ)) * X ^ 11 + C ((-1858357740829 / 505929314 : ℚ)) * X ^ 12 + C ((-761971468388 / 252964657 : ℚ)) * X ^ 13 + C ((-551028759355 / 252964657 : ℚ)) * X ^ 14 + C ((-338012695528 / 252964657 : ℚ)) * X ^ 15 + C ((-332815555507 / 505929314 : ℚ)) * X ^ 16 + C ((-107904072191 / 505929314 : ℚ)) * X ^ 17 + C ((31733573228 / 252964657 : ℚ)) * X ^ 18
def WP52_pim : Polynomial ℚ := C ((94393813681 / 252964657 : ℚ)) + C ((188787627362 / 252964657 : ℚ)) * X + C ((497003423385 / 505929314 : ℚ)) * X ^ 2 + C ((523617431493 / 505929314 : ℚ)) * X ^ 3 + C ((412511824261 / 505929314 : ℚ)) * X ^ 4 + C ((100826305181 / 505929314 : ℚ)) * X ^ 5 + C ((-69509894820 / 252964657 : ℚ)) * X ^ 6 + C ((-248595550898 / 252964657 : ℚ)) * X ^ 7 + C ((-360638605609 / 252964657 : ℚ)) * X ^ 8 + C ((-361160418967 / 252964657 : ℚ)) * X ^ 9 + C ((-32108470329 / 22996787 : ℚ)) * X ^ 10 + C ((-435667007201 / 252964657 : ℚ)) * X ^ 11 + C ((-518140840783 / 252964657 : ℚ)) * X ^ 12 + C ((-1139775359531 / 505929314 : ℚ)) * X ^ 13 + C ((-1167432994355 / 505929314 : ℚ)) * X ^ 14 + C ((-1058855119593 / 505929314 : ℚ)) * X ^ 15 + C ((-35190283857 / 22996787 : ℚ)) * X ^ 16 + C ((-552713044767 / 505929314 : ℚ)) * X ^ 17 + C ((-10070835316 / 22996787 : ℚ)) * X ^ 18
theorem WP52_pre_eq :
    WB_2_0_re * WP52_Fre - WB_2_0_im * WP52_Fim = WP52_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP52_Fre, WP52_Fim, WP52_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP52_pim_eq :
    WB_2_0_re * WP52_Fim + WB_2_0_im * WP52_Fre = WP52_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP52_Fre, WP52_Fim, WP52_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP52_mul : WB_2_0 * WP52_F = ofLadj WP52_pre WP52_pim := by
  rw [WB_2_0, WP52_F, ofLadj_mul, WP52_pre_eq, WP52_pim_eq]

def WP53_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def WP53_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def WP53_F : Ki := ofLadj WP53_Fre WP53_Fim
def WP53_pre : Polynomial ℚ := C ((6805189043 / 1011858628 : ℚ)) + C ((5669487707 / 252964657 : ℚ)) * X + C ((53638732661 / 1011858628 : ℚ)) * X ^ 2 + C ((92131513803 / 1011858628 : ℚ)) * X ^ 3 + C ((135917997887 / 1011858628 : ℚ)) * X ^ 4 + C ((178181241741 / 1011858628 : ℚ)) * X ^ 5 + C ((207499268711 / 1011858628 : ℚ)) * X ^ 6 + C ((219365043589 / 1011858628 : ℚ)) * X ^ 7 + C ((200339197689 / 1011858628 : ℚ)) * X ^ 8 + C ((46483263089 / 252964657 : ℚ)) * X ^ 9 + C ((15821678765 / 91987148 : ℚ)) * X ^ 10 + C ((41578271298 / 252964657 : ℚ)) * X ^ 11 + C ((151360515587 / 1011858628 : ℚ)) * X ^ 12 + C ((132294319695 / 1011858628 : ℚ)) * X ^ 13 + C ((54103841943 / 505929314 : ℚ)) * X ^ 14 + C ((39002211507 / 505929314 : ℚ)) * X ^ 15 + C ((245161762 / 5882899 : ℚ)) * X ^ 16 + C ((6424898047 / 505929314 : ℚ)) * X ^ 17 + C ((-1360655672 / 252964657 : ℚ)) * X ^ 18
def WP53_pim : Polynomial ℚ := C ((-11197012747 / 505929314 : ℚ)) + C ((-11197012747 / 252964657 : ℚ)) * X + C ((-60350234273 / 1011858628 : ℚ)) * X ^ 2 + C ((-17618995142 / 252964657 : ℚ)) * X ^ 3 + C ((-35455580319 / 505929314 : ℚ)) * X ^ 4 + C ((-11314381824 / 252964657 : ℚ)) * X ^ 5 + C ((-4543512902 / 252964657 : ℚ)) * X ^ 6 + C ((25929390981 / 1011858628 : ℚ)) * X ^ 7 + C ((12890579098 / 252964657 : ℚ)) * X ^ 8 + C ((49551600833 / 1011858628 : ℚ)) * X ^ 9 + C ((38954434811 / 1011858628 : ℚ)) * X ^ 10 + C ((24234694013 / 505929314 : ℚ)) * X ^ 11 + C ((57984341241 / 1011858628 : ℚ)) * X ^ 12 + C ((15737339626 / 252964657 : ℚ)) * X ^ 13 + C ((17766097310 / 252964657 : ℚ)) * X ^ 14 + C ((77477393905 / 1011858628 : ℚ)) * X ^ 15 + C ((16507061294 / 252964657 : ℚ)) * X ^ 16 + C ((12388514698 / 252964657 : ℚ)) * X ^ 17 + C ((4913775204 / 252964657 : ℚ)) * X ^ 18
theorem WP53_pre_eq :
    WB_2_0_re * WP53_Fre - WB_2_0_im * WP53_Fim = WP53_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP53_Fre, WP53_Fim, WP53_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP53_pim_eq :
    WB_2_0_re * WP53_Fim + WB_2_0_im * WP53_Fre = WP53_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_2_0_re, WB_2_0_im, WP53_Fre, WP53_Fim, WP53_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP53_mul : WB_2_0 * WP53_F = ofLadj WP53_pre WP53_pim := by
  rw [WB_2_0, WP53_F, ofLadj_mul, WP53_pre_eq, WP53_pim_eq]

def WP54_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def WP54_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def WP54_F : Ki := ofLadj WP54_Fre WP54_Fim
def WP54_pre : Polynomial ℚ := C ((-854483819 / 758893971 : ℚ)) + C ((-24742720352 / 758893971 : ℚ)) * X + C ((-70578659169 / 1011858628 : ℚ)) * X ^ 2 + C ((-152579806205 / 1517787942 : ℚ)) * X ^ 3 + C ((-1093529638 / 6271851 : ℚ)) * X ^ 4 + C ((-58743069551 / 252964657 : ℚ)) * X ^ 5 + C ((-400395003067 / 1517787942 : ℚ)) * X ^ 6 + C ((-219214651681 / 758893971 : ℚ)) * X ^ 7 + C ((-416053228579 / 1517787942 : ℚ)) * X ^ 8 + C ((-130612025453 / 505929314 : ℚ)) * X ^ 9 + C ((-253648592399 / 1011858628 : ℚ)) * X ^ 10 + C ((-60975584860 / 252964657 : ℚ)) * X ^ 11 + C ((-661974895789 / 3035575884 : ℚ)) * X ^ 12 + C ((-190645391737 / 1011858628 : ℚ)) * X ^ 13 + C ((-131736711187 / 758893971 : ℚ)) * X ^ 14 + C ((-112040045269 / 1011858628 : ℚ)) * X ^ 15 + C ((-94117116545 / 1517787942 : ℚ)) * X ^ 16 + C ((-23090265392 / 758893971 : ℚ)) * X ^ 17 + C ((3823375375 / 1011858628 : ℚ)) * X ^ 18
def WP54_pim : Polynomial ℚ := C ((23173079242 / 758893971 : ℚ)) + C ((46346158484 / 758893971 : ℚ)) * X + C ((235103052439 / 3035575884 : ℚ)) * X ^ 2 + C ((153015947083 / 1517787942 : ℚ)) * X ^ 3 + C ((7879145677 / 68990361 : ℚ)) * X ^ 4 + C ((114743665463 / 1517787942 : ℚ)) * X ^ 5 + C ((10608859682 / 252964657 : ℚ)) * X ^ 6 + C ((-3865049681 / 758893971 : ℚ)) * X ^ 7 + C ((-33437007374 / 758893971 : ℚ)) * X ^ 8 + C ((-30465721445 / 758893971 : ℚ)) * X ^ 9 + C ((-99367600735 / 3035575884 : ℚ)) * X ^ 10 + C ((-37132160410 / 758893971 : ℚ)) * X ^ 11 + C ((-197689682545 / 3035575884 : ℚ)) * X ^ 12 + C ((-224912816003 / 3035575884 : ℚ)) * X ^ 13 + C ((-47326085669 / 505929314 : ℚ)) * X ^ 14 + C ((-116551746831 / 1011858628 : ℚ)) * X ^ 15 + C ((-64145973935 / 758893971 : ℚ)) * X ^ 16 + C ((-105941200357 / 1517787942 : ℚ)) * X ^ 17 + C ((-31079873305 / 1011858628 : ℚ)) * X ^ 18
theorem WP54_pre_eq :
    WB_1_1_re * WP54_Fre - WB_1_1_im * WP54_Fim = WP54_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP54_Fre, WP54_Fim, WP54_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP54_pim_eq :
    WB_1_1_re * WP54_Fim + WB_1_1_im * WP54_Fre = WP54_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP54_Fre, WP54_Fim, WP54_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP54_mul : WB_1_1 * WP54_F = ofLadj WP54_pre WP54_pim := by
  rw [WB_1_1, WP54_F, ofLadj_mul, WP54_pre_eq, WP54_pim_eq]

def WP55_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def WP55_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def WP55_F : Ki := ofLadj WP55_Fre WP55_Fim
def WP55_pre : Polynomial ℚ := C ((-5034018562 / 758893971 : ℚ)) + C ((-123713601760 / 758893971 : ℚ)) * X + C ((-251759475899 / 758893971 : ℚ)) * X ^ 2 + C ((-127217767029 / 252964657 : ℚ)) * X ^ 3 + C ((-642565336619 / 758893971 : ℚ)) * X ^ 4 + C ((-856497688226 / 758893971 : ℚ)) * X ^ 5 + C ((-329000283059 / 252964657 : ℚ)) * X ^ 6 + C ((-35181857614 / 22996787 : ℚ)) * X ^ 7 + C ((-1184646377780 / 758893971 : ℚ)) * X ^ 8 + C ((-1228807905202 / 758893971 : ℚ)) * X ^ 9 + C ((-1251299962190 / 758893971 : ℚ)) * X ^ 10 + C ((-115826809550 / 68990361 : ℚ)) * X ^ 11 + C ((-1127586360430 / 758893971 : ℚ)) * X ^ 12 + C ((-977048429303 / 758893971 : ℚ)) * X ^ 13 + C ((-802993076693 / 758893971 : ℚ)) * X ^ 14 + C ((-514809737390 / 758893971 : ℚ)) * X ^ 15 + C ((-89705796203 / 252964657 : ℚ)) * X ^ 16 + C ((-138614227658 / 758893971 : ℚ)) * X ^ 17 + C ((329657023 / 68990361 : ℚ)) * X ^ 18
def WP55_pim : Polynomial ℚ := C ((112772556166 / 758893971 : ℚ)) + C ((225545112332 / 758893971 : ℚ)) * X + C ((6969716408 / 17648697 : ℚ)) * X ^ 2 + C ((399993283271 / 758893971 : ℚ)) * X ^ 3 + C ((1295017796 / 2090617 : ℚ)) * X ^ 4 + C ((375558480754 / 758893971 : ℚ)) * X ^ 5 + C ((112529876806 / 252964657 : ℚ)) * X ^ 6 + C ((227039239027 / 758893971 : ℚ)) * X ^ 7 + C ((10600804765 / 68990361 : ℚ)) * X ^ 8 + C ((104632650574 / 758893971 : ℚ)) * X ^ 9 + C ((89330451076 / 758893971 : ℚ)) * X ^ 10 + C ((-22710960126 / 252964657 : ℚ)) * X ^ 11 + C ((-225596211832 / 758893971 : ℚ)) * X ^ 12 + C ((-315051104542 / 758893971 : ℚ)) * X ^ 13 + C ((-427322784110 / 758893971 : ℚ)) * X ^ 14 + C ((-475786529368 / 758893971 : ℚ)) * X ^ 15 + C ((-119989076474 / 252964657 : ℚ)) * X ^ 16 + C ((-263901530174 / 758893971 : ℚ)) * X ^ 17 + C ((-132064818031 / 758893971 : ℚ)) * X ^ 18
theorem WP55_pre_eq :
    WB_1_1_re * WP55_Fre - WB_1_1_im * WP55_Fim = WP55_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP55_Fre, WP55_Fim, WP55_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP55_pim_eq :
    WB_1_1_re * WP55_Fim + WB_1_1_im * WP55_Fre = WP55_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP55_Fre, WP55_Fim, WP55_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP55_mul : WB_1_1 * WP55_F = ofLadj WP55_pre WP55_pim := by
  rw [WB_1_1, WP55_F, ofLadj_mul, WP55_pre_eq, WP55_pim_eq]

def WP56_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP56_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP56_F : Ki := ofLadj WP56_Fre WP56_Fim
def WP56_pre : Polynomial ℚ := C ((-25300026464 / 758893971 : ℚ)) + C ((-247427203520 / 758893971 : ℚ)) * X + C ((-525317768651 / 758893971 : ℚ)) * X ^ 2 + C ((-23922732532 / 22996787 : ℚ)) * X ^ 3 + C ((-1192380354722 / 758893971 : ℚ)) * X ^ 4 + C ((-34087109933 / 17648697 : ℚ)) * X ^ 5 + C ((-1579547320178 / 758893971 : ℚ)) * X ^ 6 + C ((-1717531284944 / 758893971 : ℚ)) * X ^ 7 + C ((-549859858998 / 252964657 : ℚ)) * X ^ 8 + C ((-1617686692561 / 758893971 : ℚ)) * X ^ 9 + C ((-531892384489 / 252964657 : ℚ)) * X ^ 10 + C ((-1565469592960 / 758893971 : ℚ)) * X ^ 11 + C ((-1348249949947 / 758893971 : ℚ)) * X ^ 12 + C ((-99306265810 / 68990361 : ℚ)) * X ^ 13 + C ((-286709801146 / 252964657 : ℚ)) * X ^ 14 + C ((-486621454289 / 758893971 : ℚ)) * X ^ 15 + C ((-75161416340 / 252964657 : ℚ)) * X ^ 16 + C ((-37227551987 / 252964657 : ℚ)) * X ^ 17 + C ((38529475933 / 758893971 : ℚ)) * X ^ 18
def WP56_pim : Polynomial ℚ := C ((54562770484 / 252964657 : ℚ)) + C ((109125540968 / 252964657 : ℚ)) * X + C ((125986404519 / 252964657 : ℚ)) * X ^ 2 + C ((414166443916 / 758893971 : ℚ)) * X ^ 3 + C ((125274653030 / 252964657 : ℚ)) * X ^ 4 + C ((33719256663 / 252964657 : ℚ)) * X ^ 5 + C ((-72557760494 / 758893971 : ℚ)) * X ^ 6 + C ((-8666330737 / 22996787 : ℚ)) * X ^ 7 + C ((-460086739039 / 758893971 : ℚ)) * X ^ 8 + C ((-455480245856 / 758893971 : ℚ)) * X ^ 9 + C ((-143973428550 / 252964657 : ℚ)) * X ^ 10 + C ((-569263366916 / 758893971 : ℚ)) * X ^ 11 + C ((-706606448182 / 758893971 : ℚ)) * X ^ 12 + C ((-733629078629 / 758893971 : ℚ)) * X ^ 13 + C ((-765229815805 / 758893971 : ℚ)) * X ^ 14 + C ((-247221279912 / 252964657 : ℚ)) * X ^ 15 + C ((-493879559900 / 758893971 : ℚ)) * X ^ 16 + C ((-115290186841 / 252964657 : ℚ)) * X ^ 17 + C ((-159321315961 / 758893971 : ℚ)) * X ^ 18
theorem WP56_pre_eq :
    WB_1_1_re * WP56_Fre - WB_1_1_im * WP56_Fim = WP56_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP56_Fre, WP56_Fim, WP56_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP56_pim_eq :
    WB_1_1_re * WP56_Fim + WB_1_1_im * WP56_Fre = WP56_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP56_Fre, WP56_Fim, WP56_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP56_mul : WB_1_1 * WP56_F = ofLadj WP56_pre WP56_pim := by
  rw [WB_1_1, WP56_F, ofLadj_mul, WP56_pre_eq, WP56_pim_eq]

def WP57_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def WP57_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def WP57_F : Ki := ofLadj WP57_Fre WP57_Fim
def WP57_pre : Polynomial ℚ := C ((3139282220 / 252964657 : ℚ)) + C ((24742720352 / 252964657 : ℚ)) * X + C ((89890276317 / 505929314 : ℚ)) * X ^ 2 + C ((546661016 / 2090617 : ℚ)) * X ^ 3 + C ((203567682275 / 505929314 : ℚ)) * X ^ 4 + C ((121022891375 / 252964657 : ℚ)) * X ^ 5 + C ((129292862562 / 252964657 : ℚ)) * X ^ 6 + C ((155834302948 / 252964657 : ℚ)) * X ^ 7 + C ((320604120345 / 505929314 : ℚ)) * X ^ 8 + C ((168939007370 / 252964657 : ℚ)) * X ^ 9 + C ((359663463893 / 505929314 : ℚ)) * X ^ 10 + C ((182806626978 / 252964657 : ℚ)) * X ^ 11 + C ((310178023189 / 505929314 : ℚ)) * X ^ 12 + C ((247987738423 / 505929314 : ℚ)) * X ^ 13 + C ((188312154473 / 505929314 : ℚ)) * X ^ 14 + C ((96532223435 / 505929314 : ℚ)) * X ^ 15 + C ((19372259226 / 252964657 : ℚ)) * X ^ 16 + C ((11102288039 / 252964657 : ℚ)) * X ^ 17 + C ((-5784350093 / 252964657 : ℚ)) * X ^ 18
def WP57_pim : Polynomial ℚ := C ((-13894559110 / 252964657 : ℚ)) + C ((-27789118220 / 252964657 : ℚ)) * X + C ((-62633778387 / 505929314 : ℚ)) * X ^ 2 + C ((-37791986550 / 252964657 : ℚ)) * X ^ 3 + C ((-70333514091 / 505929314 : ℚ)) * X ^ 4 + C ((-11343847473 / 252964657 : ℚ)) * X ^ 5 + C ((-8431454464 / 252964657 : ℚ)) * X ^ 6 + C ((3093740635 / 252964657 : ℚ)) * X ^ 7 + C ((45614403763 / 505929314 : ℚ)) * X ^ 8 + C ((22878227495 / 252964657 : ℚ)) * X ^ 9 + C ((56322526957 / 505929314 : ℚ)) * X ^ 10 + C ((55689200674 / 252964657 : ℚ)) * X ^ 11 + C ((166434275739 / 505929314 : ℚ)) * X ^ 12 + C ((184055889653 / 505929314 : ℚ)) * X ^ 13 + C ((197148135593 / 505929314 : ℚ)) * X ^ 14 + C ((188577451525 / 505929314 : ℚ)) * X ^ 15 + C ((60938579048 / 252964657 : ℚ)) * X ^ 16 + C ((42426006017 / 252964657 : ℚ)) * X ^ 17 + C ((21373573776 / 252964657 : ℚ)) * X ^ 18
theorem WP57_pre_eq :
    WB_1_1_re * WP57_Fre - WB_1_1_im * WP57_Fim = WP57_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP57_Fre, WP57_Fim, WP57_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP57_pim_eq :
    WB_1_1_re * WP57_Fim + WB_1_1_im * WP57_Fre = WP57_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP57_Fre, WP57_Fim, WP57_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP57_mul : WB_1_1 * WP57_F = ofLadj WP57_pre WP57_pim := by
  rw [WB_1_1, WP57_F, ofLadj_mul, WP57_pre_eq, WP57_pim_eq]

def WP58_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def WP58_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def WP58_F : Ki := ofLadj WP58_Fre WP58_Fim
def WP58_pre : Polynomial ℚ := C ((6329228632 / 68990361 : ℚ)) + C ((692796169856 / 758893971 : ℚ)) * X + C ((1436577588932 / 758893971 : ℚ)) * X ^ 2 + C ((2146412635696 / 758893971 : ℚ)) * X ^ 3 + C ((3249713996975 / 758893971 : ℚ)) * X ^ 4 + C ((31140522503 / 5882899 : ℚ)) * X ^ 5 + C ((33485140048 / 5882899 : ℚ)) * X ^ 6 + C ((4745600664221 / 758893971 : ℚ)) * X ^ 7 + C ((4554119528015 / 758893971 : ℚ)) * X ^ 8 + C ((1502129695578 / 252964657 : ℚ)) * X ^ 9 + C ((4461225586828 / 758893971 : ℚ)) * X ^ 10 + C ((36361336688 / 6271851 : ℚ)) * X ^ 11 + C ((342584492452 / 68990361 : ℚ)) * X ^ 12 + C ((3069811497802 / 758893971 : ℚ)) * X ^ 13 + C ((2407706892319 / 758893971 : ℚ)) * X ^ 14 + C ((123716876399 / 68990361 : ℚ)) * X ^ 15 + C ((201870380768 / 252964657 : ℚ)) * X ^ 16 + C ((101051826333 / 252964657 : ℚ)) * X ^ 17 + C ((-135001026857 / 758893971 : ℚ)) * X ^ 18
def WP58_pim : Polynomial ℚ := C ((-463275816136 / 758893971 : ℚ)) + C ((-926551632272 / 758893971 : ℚ)) * X + C ((-353019423604 / 252964657 : ℚ)) * X ^ 2 + C ((-1182333116692 / 758893971 : ℚ)) * X ^ 3 + C ((-99792242221 / 68990361 : ℚ)) * X ^ 4 + C ((-109064570713 / 252964657 : ℚ)) * X ^ 5 + C ((50365558548 / 252964657 : ℚ)) * X ^ 6 + C ((252681744041 / 252964657 : ℚ)) * X ^ 7 + C ((419489797223 / 252964657 : ℚ)) * X ^ 8 + C ((418928622268 / 252964657 : ℚ)) * X ^ 9 + C ((1208846145890 / 758893971 : ℚ)) * X ^ 10 + C ((1633525779928 / 758893971 : ℚ)) * X ^ 11 + C ((686068471322 / 252964657 : ℚ)) * X ^ 12 + C ((714257443864 / 252964657 : ℚ)) * X ^ 13 + C ((2264363652607 / 758893971 : ℚ)) * X ^ 14 + C ((66614650381 / 22996787 : ℚ)) * X ^ 15 + C ((494992532684 / 252964657 : ℚ)) * X ^ 16 + C ((343873122009 / 252964657 : ℚ)) * X ^ 17 + C ((481885897319 / 758893971 : ℚ)) * X ^ 18
theorem WP58_pre_eq :
    WB_1_1_re * WP58_Fre - WB_1_1_im * WP58_Fim = WP58_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP58_Fre, WP58_Fim, WP58_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP58_pim_eq :
    WB_1_1_re * WP58_Fim + WB_1_1_im * WP58_Fre = WP58_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP58_Fre, WP58_Fim, WP58_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP58_mul : WB_1_1 * WP58_F = ofLadj WP58_pre WP58_pim := by
  rw [WB_1_1, WP58_F, ofLadj_mul, WP58_pre_eq, WP58_pim_eq]

def WP59_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def WP59_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def WP59_F : Ki := ofLadj WP59_Fre WP59_Fim
def WP59_pre : Polynomial ℚ := C ((-8444032 / 68990361 : ℚ)) + C ((-24742720352 / 758893971 : ℚ)) * X + C ((-113224824811 / 1517787942 : ℚ)) * X ^ 2 + C ((-85318195484 / 758893971 : ℚ)) * X ^ 3 + C ((-278288875129 / 1517787942 : ℚ)) * X ^ 4 + C ((-374101216145 / 1517787942 : ℚ)) * X ^ 5 + C ((-209540947406 / 758893971 : ℚ)) * X ^ 6 + C ((-443136504035 / 1517787942 : ℚ)) * X ^ 7 + C ((-404238225425 / 1517787942 : ℚ)) * X ^ 8 + C ((-191853053155 / 758893971 : ℚ)) * X ^ 9 + C ((-32245244945 / 137980722 : ℚ)) * X ^ 10 + C ((-57443675132 / 252964657 : ℚ)) * X ^ 11 + C ((-101737417897 / 505929314 : ℚ)) * X ^ 12 + C ((-24589207409 / 137980722 : ℚ)) * X ^ 13 + C ((-233601834457 / 1517787942 : ℚ)) * X ^ 14 + C ((-25546488120 / 252964657 : ℚ)) * X ^ 15 + C ((-916889872 / 17648697 : ℚ)) * X ^ 16 + C ((-11290616775 / 505929314 : ℚ)) * X ^ 17 + C ((5784350093 / 758893971 : ℚ)) * X ^ 18
def WP59_pim : Polynomial ℚ := C ((26265919286 / 758893971 : ℚ)) + C ((52531838572 / 758893971 : ℚ)) * X + C ((127609868713 / 1517787942 : ℚ)) * X ^ 2 + C ((75995514956 / 758893971 : ℚ)) * X ^ 3 + C ((170600647009 / 1517787942 : ℚ)) * X ^ 4 + C ((107482860257 / 1517787942 : ℚ)) * X ^ 5 + C ((21068564183 / 758893971 : ℚ)) * X ^ 6 + C ((-35006008445 / 1517787942 : ℚ)) * X ^ 7 + C ((-80784716843 / 1517787942 : ℚ)) * X ^ 8 + C ((-40897032122 / 758893971 : ℚ)) * X ^ 9 + C ((-66161363395 / 1517787942 : ℚ)) * X ^ 10 + C ((-14439280166 / 252964657 : ℚ)) * X ^ 11 + C ((-107109998597 / 1517787942 : ℚ)) * X ^ 12 + C ((-114023489317 / 1517787942 : ℚ)) * X ^ 13 + C ((-46471332639 / 505929314 : ℚ)) * X ^ 14 + C ((-26842529310 / 252964657 : ℚ)) * X ^ 15 + C ((-20871722771 / 252964657 : ℚ)) * X ^ 16 + C ((-92597336845 / 1517787942 : ℚ)) * X ^ 17 + C ((-7124524592 / 252964657 : ℚ)) * X ^ 18
theorem WP59_pre_eq :
    WB_1_1_re * WP59_Fre - WB_1_1_im * WP59_Fim = WP59_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP59_Fre, WP59_Fim, WP59_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP59_pim_eq :
    WB_1_1_re * WP59_Fim + WB_1_1_im * WP59_Fre = WP59_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WB_1_1_re, WB_1_1_im, WP59_Fre, WP59_Fim, WP59_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP59_mul : WB_1_1 * WP59_F = ofLadj WP59_pre WP59_pim := by
  rw [WB_1_1, WP59_F, ofLadj_mul, WP59_pre_eq, WP59_pim_eq]

def WP60_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def WP60_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def WP60_F : Ki := ofLadj WP60_Fre WP60_Fim
def WP60_pre : Polynomial ℚ := C ((-481994681 / 17648697 : ℚ)) + C ((35254864 / 17648697 : ℚ)) * X + C ((-99832141 / 3208854 : ℚ)) * X ^ 2 + C ((191140341 / 11765798 : ℚ)) * X ^ 3 + C ((1731344207 / 35297394 : ℚ)) * X ^ 4 + C ((-541969509 / 11765798 : ℚ)) * X ^ 5 + C ((412011643 / 5882899 : ℚ)) * X ^ 6 + C ((-1295461 / 35297394 : ℚ)) * X ^ 7 + C ((-16489595 / 1069618 : ℚ)) * X ^ 8 + C ((-239632358 / 17648697 : ℚ)) * X ^ 9 + C ((-121618185 / 5882899 : ℚ)) * X ^ 10 + C ((19081108 / 1604427 : ℚ)) * X ^ 11 + C ((-400109419 / 17648697 : ℚ)) * X ^ 12 + C ((618888835 / 35297394 : ℚ)) * X ^ 13 + C ((-186262943 / 5882899 : ℚ)) * X ^ 14 + C ((-2293007143 / 35297394 : ℚ)) * X ^ 15 + C ((1220565409 / 35297394 : ℚ)) * X ^ 16 + C ((-1438706488 / 17648697 : ℚ)) * X ^ 17 + C ((-560367475 / 35297394 : ℚ)) * X ^ 18
def WP60_pim : Polynomial ℚ := C ((-340426172 / 17648697 : ℚ)) + C ((-680852344 / 17648697 : ℚ)) * X + C ((-931899515 / 35297394 : ℚ)) * X ^ 2 + C ((-2552231755 / 23531596 : ℚ)) * X ^ 3 + C ((139577918 / 17648697 : ℚ)) * X ^ 4 + C ((-2143881511 / 35297394 : ℚ)) * X ^ 5 + C ((-1187639756 / 17648697 : ℚ)) * X ^ 6 + C ((961727333 / 70594788 : ℚ)) * X ^ 7 + C ((-2860299569 / 70594788 : ℚ)) * X ^ 8 + C ((-2830341007 / 70594788 : ℚ)) * X ^ 9 + C ((-886192705 / 23531596 : ℚ)) * X ^ 10 + C ((-388905898 / 17648697 : ℚ)) * X ^ 11 + C ((-452669069 / 70594788 : ℚ)) * X ^ 12 + C ((-1140516523 / 70594788 : ℚ)) * X ^ 13 + C ((2341169137 / 35297394 : ℚ)) * X ^ 14 + C ((-1281961509 / 23531596 : ℚ)) * X ^ 15 + C ((1517918137 / 70594788 : ℚ)) * X ^ 16 + C ((51083253 / 2139236 : ℚ)) * X ^ 17 + C ((-1754405519 / 35297394 : ℚ)) * X ^ 18
theorem WP60_pre_eq :
    WC_0_0_re * WP60_Fre - WC_0_0_im * WP60_Fim = WP60_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP60_Fre, WP60_Fim, WP60_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP60_pim_eq :
    WC_0_0_re * WP60_Fim + WC_0_0_im * WP60_Fre = WP60_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP60_Fre, WP60_Fim, WP60_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP60_mul : WC_0_0 * WP60_F = ofLadj WP60_pre WP60_pim := by
  rw [WC_0_0, WP60_F, ofLadj_mul, WP60_pre_eq, WP60_pim_eq]

def WP61_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP61_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP61_F : Ki := ofLadj WP61_Fre WP61_Fim
def WP61_pre : Polynomial ℚ := C ((1941199298 / 17648697 : ℚ)) + C ((-88137160 / 17648697 : ℚ)) * X + C ((2718754960 / 17648697 : ℚ)) * X ^ 2 + C ((-187948538 / 5882899 : ℚ)) * X ^ 3 + C ((-1714796894 / 17648697 : ℚ)) * X ^ 4 + C ((1779376777 / 11765798 : ℚ)) * X ^ 5 + C ((-5696971769 / 35297394 : ℚ)) * X ^ 6 + C ((167588173 / 35297394 : ℚ)) * X ^ 7 + C ((1318190561 / 17648697 : ℚ)) * X ^ 8 + C ((2677688021 / 35297394 : ℚ)) * X ^ 9 + C ((1393170619 / 17648697 : ℚ)) * X ^ 10 + C ((-219241744 / 17648697 : ℚ)) * X ^ 11 + C ((1481307779 / 17648697 : ℚ)) * X ^ 12 + C ((-919940633 / 11765798 : ℚ)) * X ^ 13 + C ((1882036175 / 17648697 : ℚ)) * X ^ 14 + C ((6074693861 / 35297394 : ℚ)) * X ^ 15 + C ((-1611139096 / 17648697 : ℚ)) * X ^ 16 + C ((1302137318 / 5882899 : ℚ)) * X ^ 17 + C ((412918650 / 5882899 : ℚ)) * X ^ 18
def WP61_pim : Polynomial ℚ := C ((870896291 / 17648697 : ℚ)) + C ((1741792582 / 17648697 : ℚ)) * X + C ((479348062 / 5882899 : ℚ)) * X ^ 2 + C ((514354526 / 1604427 : ℚ)) * X ^ 3 + C ((-307657342 / 17648697 : ℚ)) * X ^ 4 + C ((2365336183 / 11765798 : ℚ)) * X ^ 5 + C ((2186290605 / 11765798 : ℚ)) * X ^ 6 + C ((-175772523 / 11765798 : ℚ)) * X ^ 7 + C ((1794410744 / 17648697 : ℚ)) * X ^ 8 + C ((1201009213 / 11765798 : ℚ)) * X ^ 9 + C ((1679966590 / 17648697 : ℚ)) * X ^ 10 + C ((1044977902 / 17648697 : ℚ)) * X ^ 11 + C ((409989214 / 17648697 : ℚ)) * X ^ 12 + C ((394793587 / 11765798 : ℚ)) * X ^ 13 + C ((-1206854048 / 5882899 : ℚ)) * X ^ 14 + C ((1580135841 / 11765798 : ℚ)) * X ^ 15 + C ((-1405912432 / 17648697 : ℚ)) * X ^ 16 + C ((-1589779364 / 17648697 : ℚ)) * X ^ 17 + C ((2032860751 / 17648697 : ℚ)) * X ^ 18
theorem WP61_pre_eq :
    WC_0_0_re * WP61_Fre - WC_0_0_im * WP61_Fim = WP61_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP61_Fre, WP61_Fim, WP61_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP61_pim_eq :
    WC_0_0_re * WP61_Fim + WC_0_0_im * WP61_Fre = WP61_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP61_Fre, WP61_Fim, WP61_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP61_mul : WC_0_0 * WP61_F = ofLadj WP61_pre WP61_pim := by
  rw [WC_0_0, WP61_F, ofLadj_mul, WP61_pre_eq, WP61_pim_eq]

def WP62_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def WP62_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def WP62_F : Ki := ofLadj WP62_Fre WP62_Fim
def WP62_pre : Polynomial ℚ := C ((2914002376 / 17648697 : ℚ)) + C ((-123392024 / 17648697 : ℚ)) * X + C ((1427206793 / 5882899 : ℚ)) * X ^ 2 + C ((-286378333 / 11765798 : ℚ)) * X ^ 3 + C ((-1355025717 / 11765798 : ℚ)) * X ^ 4 + C ((9501510977 / 35297394 : ℚ)) * X ^ 5 + C ((-3812217116 / 17648697 : ℚ)) * X ^ 6 + C ((86801254 / 5882899 : ℚ)) * X ^ 7 + C ((149677947 / 1069618 : ℚ)) * X ^ 8 + C ((1266730033 / 11765798 : ℚ)) * X ^ 9 + C ((2216365168 / 17648697 : ℚ)) * X ^ 10 + C ((-934467947 / 17648697 : ℚ)) * X ^ 11 + C ((779919064 / 5882899 : ℚ)) * X ^ 12 + C ((-1587683553 / 11765798 : ℚ)) * X ^ 13 + C ((966417875 / 5882899 : ℚ)) * X ^ 14 + C ((2913680663 / 11765798 : ℚ)) * X ^ 15 + C ((-2325510574 / 17648697 : ℚ)) * X ^ 16 + C ((12474924061 / 35297394 : ℚ)) * X ^ 17 + C ((62956929 / 534809 : ℚ)) * X ^ 18
def WP62_pim : Polynomial ℚ := C ((1224543037 / 17648697 : ℚ)) + C ((2449086074 / 17648697 : ℚ)) * X + C ((605457904 / 5882899 : ℚ)) * X ^ 2 + C ((16008138701 / 35297394 : ℚ)) * X ^ 3 + C ((-413812339 / 11765798 : ℚ)) * X ^ 4 + C ((3475230499 / 11765798 : ℚ)) * X ^ 5 + C ((5344208543 / 17648697 : ℚ)) * X ^ 6 + C ((-429855598 / 17648697 : ℚ)) * X ^ 7 + C ((6392522881 / 35297394 : ℚ)) * X ^ 8 + C ((5628088375 / 35297394 : ℚ)) * X ^ 9 + C ((946552072 / 5882899 : ℚ)) * X ^ 10 + C ((1513207244 / 17648697 : ℚ)) * X ^ 11 + C ((186758272 / 17648697 : ℚ)) * X ^ 12 + C ((1690165325 / 35297394 : ℚ)) * X ^ 13 + C ((-1908276743 / 5882899 : ℚ)) * X ^ 14 + C ((2278131249 / 11765798 : ℚ)) * X ^ 15 + C ((-2616853978 / 17648697 : ℚ)) * X ^ 16 + C ((-4929399503 / 35297394 : ℚ)) * X ^ 17 + C ((3108877795 / 17648697 : ℚ)) * X ^ 18
theorem WP62_pre_eq :
    WC_0_0_re * WP62_Fre - WC_0_0_im * WP62_Fim = WP62_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP62_Fre, WP62_Fim, WP62_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP62_pim_eq :
    WC_0_0_re * WP62_Fim + WC_0_0_im * WP62_Fre = WP62_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP62_Fre, WP62_Fim, WP62_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP62_mul : WC_0_0 * WP62_F = ofLadj WP62_pre WP62_pim := by
  rw [WC_0_0, WP62_F, ofLadj_mul, WP62_pre_eq, WP62_pim_eq]

def WP63_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def WP63_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def WP63_F : Ki := ofLadj WP63_Fre WP63_Fim
def WP63_pre : Polynomial ℚ := C ((-916799859 / 5882899 : ℚ)) + C ((123392024 / 17648697 : ℚ)) * X + C ((-7673651455 / 35297394 : ℚ)) * X ^ 2 + C ((1413199891 / 35297394 : ℚ)) * X ^ 3 + C ((2464390405 / 17648697 : ℚ)) * X ^ 4 + C ((-4063223482 / 17648697 : ℚ)) * X ^ 5 + C ((4381770775 / 17648697 : ℚ)) * X ^ 6 + C ((-243398231 / 17648697 : ℚ)) * X ^ 7 + C ((-3244228469 / 35297394 : ℚ)) * X ^ 8 + C ((-183677452 / 1604427 : ℚ)) * X ^ 9 + C ((-3091861519 / 35297394 : ℚ)) * X ^ 10 + C ((191887904 / 17648697 : ℚ)) * X ^ 11 + C ((-3338645567 / 35297394 : ℚ)) * X ^ 12 + C ((1210915837 / 11765798 : ℚ)) * X ^ 13 + C ((-776238060 / 5882899 : ℚ)) * X ^ 14 + C ((-2990854409 / 11765798 : ℚ)) * X ^ 15 + C ((2581300811 / 17648697 : ℚ)) * X ^ 16 + C ((-1954564482 / 5882899 : ℚ)) * X ^ 17 + C ((-1185661985 / 11765798 : ℚ)) * X ^ 18
def WP63_pim : Polynomial ℚ := C ((-1220136179 / 17648697 : ℚ)) + C ((-2440272358 / 17648697 : ℚ)) * X + C ((-1760841151 / 17648697 : ℚ)) * X ^ 2 + C ((-2675919647 / 5882899 : ℚ)) * X ^ 3 + C ((299029304 / 5882899 : ℚ)) * X ^ 4 + C ((-5168670314 / 17648697 : ℚ)) * X ^ 5 + C ((-1500452444 / 5882899 : ℚ)) * X ^ 6 + C ((357783752 / 17648697 : ℚ)) * X ^ 7 + C ((-801803461 / 5882899 : ℚ)) * X ^ 8 + C ((-23085157 / 145857 : ℚ)) * X ^ 9 + C ((-767612762 / 5882899 : ℚ)) * X ^ 10 + C ((-44118730 / 534809 : ℚ)) * X ^ 11 + C ((-202999298 / 5882899 : ℚ)) * X ^ 12 + C ((-797963390 / 17648697 : ℚ)) * X ^ 13 + C ((5081060786 / 17648697 : ℚ)) * X ^ 14 + C ((-3437939570 / 17648697 : ℚ)) * X ^ 15 + C ((1920650696 / 17648697 : ℚ)) * X ^ 16 + C ((217933492 / 1604427 : ℚ)) * X ^ 17 + C ((-3169040632 / 17648697 : ℚ)) * X ^ 18
theorem WP63_pre_eq :
    WC_0_0_re * WP63_Fre - WC_0_0_im * WP63_Fim = WP63_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP63_Fre, WP63_Fim, WP63_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP63_pim_eq :
    WC_0_0_re * WP63_Fim + WC_0_0_im * WP63_Fre = WP63_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP63_Fre, WP63_Fim, WP63_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP63_mul : WC_0_0 * WP63_F = ofLadj WP63_pre WP63_pim := by
  rw [WC_0_0, WP63_F, ofLadj_mul, WP63_pre_eq, WP63_pim_eq]

def WP64_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def WP64_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def WP64_F : Ki := ofLadj WP64_Fre WP64_Fim
def WP64_pre : Polynomial ℚ := C ((650004338 / 17648697 : ℚ)) + C ((-17627432 / 17648697 : ℚ)) * X + C ((299673921 / 5882899 : ℚ)) * X ^ 2 + C ((-33850225 / 17648697 : ℚ)) * X ^ 3 + C ((-262824305 / 17648697 : ℚ)) * X ^ 4 + C ((754836457 / 17648697 : ℚ)) * X ^ 5 + C ((-786747158 / 17648697 : ℚ)) * X ^ 6 + C ((-61316495 / 5882899 : ℚ)) * X ^ 7 + C ((143479489 / 17648697 : ℚ)) * X ^ 8 + C ((840839530 / 17648697 : ℚ)) * X ^ 9 + C ((128382852 / 5882899 : ℚ)) * X ^ 10 + C ((-37678436 / 5882899 : ℚ)) * X ^ 11 + C ((402775988 / 17648697 : ℚ)) * X ^ 12 + C ((-58182233 / 17648697 : ℚ)) * X ^ 13 + C ((177329714 / 17648697 : ℚ)) * X ^ 14 + C ((132863649 / 5882899 : ℚ)) * X ^ 15 + C ((-142531963 / 5882899 : ℚ)) * X ^ 16 + C ((371329242 / 5882899 : ℚ)) * X ^ 17 + C ((319716127 / 17648697 : ℚ)) * X ^ 18
def WP64_pim : Polynomial ℚ := C ((60410077 / 5882899 : ℚ)) + C ((120820154 / 5882899 : ℚ)) * X + C ((235883608 / 17648697 : ℚ)) * X ^ 2 + C ((1489958627 / 17648697 : ℚ)) * X ^ 3 + C ((-18695021 / 1604427 : ℚ)) * X ^ 4 + C ((360387087 / 5882899 : ℚ)) * X ^ 5 + C ((811897532 / 17648697 : ℚ)) * X ^ 6 + C ((5558086 / 17648697 : ℚ)) * X ^ 7 + C ((-134725925 / 17648697 : ℚ)) * X ^ 8 + C ((7843954 / 534809 : ℚ)) * X ^ 9 + C ((482010065 / 17648697 : ℚ)) * X ^ 10 + C ((218690668 / 17648697 : ℚ)) * X ^ 11 + C ((-14876243 / 5882899 : ℚ)) * X ^ 12 + C ((305107708 / 17648697 : ℚ)) * X ^ 13 + C ((-555390904 / 17648697 : ℚ)) * X ^ 14 + C ((147288714 / 5882899 : ℚ)) * X ^ 15 + C ((-611674402 / 17648697 : ℚ)) * X ^ 16 + C ((-481542593 / 17648697 : ℚ)) * X ^ 17 + C ((558062801 / 17648697 : ℚ)) * X ^ 18
theorem WP64_pre_eq :
    WC_0_0_re * WP64_Fre - WC_0_0_im * WP64_Fim = WP64_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP64_Fre, WP64_Fim, WP64_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP64_pim_eq :
    WC_0_0_re * WP64_Fim + WC_0_0_im * WP64_Fre = WP64_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP64_Fre, WP64_Fim, WP64_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP64_mul : WC_0_0 * WP64_F = ofLadj WP64_pre WP64_pim := by
  rw [WC_0_0, WP64_F, ofLadj_mul, WP64_pre_eq, WP64_pim_eq]

def WP65_Fre : Polynomial ℚ := C (3)
def WP65_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def WP65_F : Ki := ofLadj WP65_Fre WP65_Fim
def WP65_pre : Polynomial ℚ := C ((163602799 / 11765798 : ℚ)) + C ((199390453 / 11765798 : ℚ)) * X ^ 2 + C ((-56783439 / 11765798 : ℚ)) * X ^ 3 + C ((-18723468 / 5882899 : ℚ)) * X ^ 4 + C ((-8924517 / 5882899 : ℚ)) * X ^ 5 + C ((-8924517 / 5882899 : ℚ)) * X ^ 6 + C ((-18723468 / 5882899 : ℚ)) * X ^ 7 + C ((-56783439 / 11765798 : ℚ)) * X ^ 8 + C ((199390453 / 11765798 : ℚ)) * X ^ 9
def WP65_pim : Polynomial ℚ := C ((2203429 / 5882899 : ℚ)) + C ((4406858 / 5882899 : ℚ)) * X + C ((24461137 / 5882899 : ℚ)) * X ^ 2 + C ((99840159 / 5882899 : ℚ)) * X ^ 3 + C ((-32226248 / 5882899 : ℚ)) * X ^ 4 + C ((45935728 / 5882899 : ℚ)) * X ^ 5 + C ((-41528870 / 5882899 : ℚ)) * X ^ 6 + C ((36633106 / 5882899 : ℚ)) * X ^ 7 + C ((-95433301 / 5882899 : ℚ)) * X ^ 8 + C ((-20054279 / 5882899 : ℚ)) * X ^ 9
theorem WP65_pre_eq :
    WC_0_0_re * WP65_Fre - WC_0_0_im * WP65_Fim = WP65_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP65_Fre, WP65_Fim, WP65_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP65_pim_eq :
    WC_0_0_re * WP65_Fim + WC_0_0_im * WP65_Fre = WP65_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_0_re, WC_0_0_im, WP65_Fre, WP65_Fim, WP65_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP65_mul : WC_0_0 * WP65_F = ofLadj WP65_pre WP65_pim := by
  rw [WC_0_0, WP65_F, ofLadj_mul, WP65_pre_eq, WP65_pim_eq]

def WP66_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def WP66_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def WP66_F : Ki := ofLadj WP66_Fre WP66_Fim
def WP66_pre : Polynomial ℚ := C ((42994651235 / 758893971 : ℚ)) + C ((256341721400 / 758893971 : ℚ)) * X + C ((513703108822 / 758893971 : ℚ)) * X ^ 2 + C ((2918351480917 / 3035575884 : ℚ)) * X ^ 3 + C ((348301966380 / 252964657 : ℚ)) * X ^ 4 + C ((1715969262391 / 1011858628 : ℚ)) * X ^ 5 + C ((1288731166421 / 758893971 : ℚ)) * X ^ 6 + C ((469991571075 / 252964657 : ℚ)) * X ^ 7 + C ((2638179695689 / 1517787942 : ℚ)) * X ^ 8 + C ((1721416517741 / 1011858628 : ℚ)) * X ^ 9 + C ((116283853471 / 68990361 : ℚ)) * X ^ 10 + C ((2472284441431 / 1517787942 : ℚ)) * X ^ 11 + C ((340926888927 / 252964657 : ℚ)) * X ^ 12 + C ((3109437117935 / 3035575884 : ℚ)) * X ^ 13 + C ((2358007910461 / 3035575884 : ℚ)) * X ^ 14 + C ((282961815613 / 758893971 : ℚ)) * X ^ 15 + C ((73571649579 / 1011858628 : ℚ)) * X ^ 16 + C ((106849035113 / 1517787942 : ℚ)) * X ^ 17 + C ((-82106998472 / 758893971 : ℚ)) * X ^ 18
def WP66_pim : Polynomial ℚ := C ((-110188664935 / 758893971 : ℚ)) + C ((-220377329870 / 758893971 : ℚ)) * X + C ((-67149307961 / 252964657 : ℚ)) * X ^ 2 + C ((-600934865147 / 3035575884 : ℚ)) * X ^ 3 + C ((-190410112129 / 1517787942 : ℚ)) * X ^ 4 + C ((897890240627 / 3035575884 : ℚ)) * X ^ 5 + C ((818590448033 / 1517787942 : ℚ)) * X ^ 6 + C ((386094900237 / 505929314 : ℚ)) * X ^ 7 + C ((253760694588 / 252964657 : ℚ)) * X ^ 8 + C ((2996166948637 / 3035575884 : ℚ)) * X ^ 9 + C ((742884613120 / 758893971 : ℚ)) * X ^ 10 + C ((277636241263 / 252964657 : ℚ)) * X ^ 11 + C ((922932834458 / 758893971 : ℚ)) * X ^ 12 + C ((1197128405909 / 1011858628 : ℚ)) * X ^ 13 + C ((1112522333641 / 1011858628 : ℚ)) * X ^ 14 + C ((793702733639 / 758893971 : ℚ)) * X ^ 15 + C ((1968556990553 / 3035575884 : ℚ)) * X ^ 16 + C ((639066171793 / 1517787942 : ℚ)) * X ^ 17 + C ((167800089778 / 758893971 : ℚ)) * X ^ 18
theorem WP66_pre_eq :
    WC_1_0_re * WP66_Fre - WC_1_0_im * WP66_Fim = WP66_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP66_Fre, WP66_Fim, WP66_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP66_pim_eq :
    WC_1_0_re * WP66_Fim + WC_1_0_im * WP66_Fre = WP66_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP66_Fre, WP66_Fim, WP66_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP66_mul : WC_1_0 * WP66_F = ofLadj WP66_pre WP66_pim := by
  rw [WC_1_0, WP66_F, ofLadj_mul, WP66_pre_eq, WP66_pim_eq]

def WP67_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP67_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP67_F : Ki := ofLadj WP67_Fre WP67_Fim
def WP67_pre : Polynomial ℚ := C ((-75850459415 / 758893971 : ℚ)) + C ((-640854303500 / 758893971 : ℚ)) * X + C ((-129970658195 / 68990361 : ℚ)) * X ^ 2 + C ((-2046896207524 / 758893971 : ℚ)) * X ^ 3 + C ((-283530958907 / 68990361 : ℚ)) * X ^ 4 + C ((-2758735757 / 534809 : ℚ)) * X ^ 5 + C ((-4095270139679 / 758893971 : ℚ)) * X ^ 6 + C ((-4534681604014 / 758893971 : ℚ)) * X ^ 7 + C ((-4349355113179 / 758893971 : ℚ)) * X ^ 8 + C ((-4265611748147 / 758893971 : ℚ)) * X ^ 9 + C ((-1402791939749 / 252964657 : ℚ)) * X ^ 10 + C ((-4124014290721 / 758893971 : ℚ)) * X ^ 11 + C ((-3567521515747 / 758893971 : ℚ)) * X ^ 12 + C ((-2835934508002 / 758893971 : ℚ)) * X ^ 13 + C ((-767486301885 / 252964657 : ℚ)) * X ^ 14 + C ((-1311889382911 / 758893971 : ℚ)) * X ^ 15 + C ((-541486486889 / 758893971 : ℚ)) * X ^ 16 + C ((-120287462131 / 252964657 : ℚ)) * X ^ 17 + C ((103951673126 / 758893971 : ℚ)) * X ^ 18
def WP67_pim : Polynomial ℚ := C ((38151261875 / 68990361 : ℚ)) + C ((76302523750 / 68990361 : ℚ)) * X + C ((981402054577 / 758893971 : ℚ)) * X ^ 2 + C ((989492636458 / 758893971 : ℚ)) * X ^ 3 + C ((336793539883 / 252964657 : ℚ)) * X ^ 4 + C ((195512093626 / 758893971 : ℚ)) * X ^ 5 + C ((-2206706944 / 6271851 : ℚ)) * X ^ 6 + C ((-765246442672 / 758893971 : ℚ)) * X ^ 7 + C ((-116073011554 / 68990361 : ℚ)) * X ^ 8 + C ((-1266585465070 / 758893971 : ℚ)) * X ^ 9 + C ((-399559864009 / 252964657 : ℚ)) * X ^ 10 + C ((-517855669695 / 252964657 : ℚ)) * X ^ 11 + C ((-636151475381 / 252964657 : ℚ)) * X ^ 12 + C ((-1982622846427 / 758893971 : ℚ)) * X ^ 13 + C ((-660165255428 / 252964657 : ℚ)) * X ^ 14 + C ((-680442874641 / 252964657 : ℚ)) * X ^ 15 + C ((-432790479703 / 252964657 : ℚ)) * X ^ 16 + C ((-897935371213 / 758893971 : ℚ)) * X ^ 17 + C ((-157203936658 / 252964657 : ℚ)) * X ^ 18
theorem WP67_pre_eq :
    WC_1_0_re * WP67_Fre - WC_1_0_im * WP67_Fim = WP67_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP67_Fre, WP67_Fim, WP67_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP67_pim_eq :
    WC_1_0_re * WP67_Fim + WC_1_0_im * WP67_Fre = WP67_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP67_Fre, WP67_Fim, WP67_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP67_mul : WC_1_0 * WP67_F = ofLadj WP67_pre WP67_pim := by
  rw [WC_1_0, WP67_F, ofLadj_mul, WP67_pre_eq, WP67_pim_eq]

def WP68_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def WP68_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def WP68_F : Ki := ofLadj WP68_Fre WP68_Fim
def WP68_pre : Polynomial ℚ := C ((-97754331535 / 758893971 : ℚ)) + C ((-897196024900 / 758893971 : ℚ)) * X + C ((-660745098644 / 252964657 : ℚ)) * X ^ 2 + C ((-2773361190503 / 758893971 : ℚ)) * X ^ 3 + C ((-393798142165 / 68990361 : ℚ)) * X ^ 4 + C ((-1850177366953 / 252964657 : ℚ)) * X ^ 5 + C ((-5928208641518 / 758893971 : ℚ)) * X ^ 6 + C ((-6733898268734 / 758893971 : ℚ)) * X ^ 7 + C ((-6677605089635 / 758893971 : ℚ)) * X ^ 8 + C ((-6744924713602 / 758893971 : ℚ)) * X ^ 9 + C ((-6833297309561 / 758893971 : ℚ)) * X ^ 10 + C ((-6742636858970 / 758893971 : ℚ)) * X ^ 11 + C ((-5936101284661 / 758893971 : ℚ)) * X ^ 12 + C ((-4762689417670 / 758893971 : ℚ)) * X ^ 13 + C ((-1301414633044 / 252964657 : ℚ)) * X ^ 14 + C ((-2269964665267 / 758893971 : ℚ)) * X ^ 15 + C ((-331225432885 / 252964657 : ℚ)) * X ^ 16 + C ((-615999757996 / 758893971 : ℚ)) * X ^ 17 + C ((132154039652 / 758893971 : ℚ)) * X ^ 18
def WP68_pim : Polynomial ℚ := C ((625980691085 / 758893971 : ℚ)) + C ((1251961382170 / 758893971 : ℚ)) * X + C ((1511016185648 / 758893971 : ℚ)) * X ^ 2 + C ((49801118836 / 22996787 : ℚ)) * X ^ 3 + C ((1862363529236 / 758893971 : ℚ)) * X ^ 4 + C ((842020845209 / 758893971 : ℚ)) * X ^ 5 + C ((308063349493 / 758893971 : ℚ)) * X ^ 6 + C ((-309027082390 / 758893971 : ℚ)) * X ^ 7 + C ((-1043628935720 / 758893971 : ℚ)) * X ^ 8 + C ((-95196289904 / 68990361 : ℚ)) * X ^ 9 + C ((-25438525922 / 17648697 : ℚ)) * X ^ 10 + C ((-603235619908 / 252964657 : ℚ)) * X ^ 11 + C ((-2525557104802 / 758893971 : ℚ)) * X ^ 12 + C ((-943769777994 / 252964657 : ℚ)) * X ^ 13 + C ((-989086774382 / 252964657 : ℚ)) * X ^ 14 + C ((-1057946372804 / 252964657 : ℚ)) * X ^ 15 + C ((-686796852868 / 252964657 : ℚ)) * X ^ 16 + C ((-1457145973376 / 758893971 : ℚ)) * X ^ 17 + C ((-248983221904 / 252964657 : ℚ)) * X ^ 18
theorem WP68_pre_eq :
    WC_1_0_re * WP68_Fre - WC_1_0_im * WP68_Fim = WP68_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP68_Fre, WP68_Fim, WP68_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP68_pim_eq :
    WC_1_0_re * WP68_Fim + WC_1_0_im * WP68_Fre = WP68_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP68_Fre, WP68_Fim, WP68_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP68_mul : WC_1_0 * WP68_F = ofLadj WP68_pre WP68_pim := by
  rw [WC_1_0, WP68_F, ofLadj_mul, WP68_pre_eq, WP68_pim_eq]

def WP69_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def WP69_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def WP69_F : Ki := ofLadj WP69_Fre WP69_Fim
def WP69_pre : Polynomial ℚ := C ((34928197080 / 252964657 : ℚ)) + C ((897196024900 / 758893971 : ℚ)) * X + C ((3915898258319 / 1517787942 : ℚ)) * X ^ 2 + C ((1855287285959 / 505929314 : ℚ)) * X ^ 3 + C ((2831565300549 / 505929314 : ℚ)) * X ^ 4 + C ((250030508465 / 35297394 : ℚ)) * X ^ 5 + C ((259933008355 / 35297394 : ℚ)) * X ^ 6 + C ((569939805250 / 68990361 : ℚ)) * X ^ 7 + C ((12000079561033 / 1517787942 : ℚ)) * X ^ 8 + C ((3963089154363 / 505929314 : ℚ)) * X ^ 9 + C ((5875051103297 / 758893971 : ℚ)) * X ^ 10 + C ((5800738790969 / 758893971 : ℚ)) * X ^ 11 + C ((4977855078397 / 758893971 : ℚ)) * X ^ 12 + C ((3986684602385 / 758893971 : ℚ)) * X ^ 13 + C ((3217108851578 / 758893971 : ℚ)) * X ^ 14 + C ((1225059021853 / 505929314 : ℚ)) * X ^ 15 + C ((1427164742489 / 1517787942 : ℚ)) * X ^ 16 + C ((333785749073 / 505929314 : ℚ)) * X ^ 17 + C ((-184401374147 / 758893971 : ℚ)) * X ^ 18
def WP69_pim : Polynomial ℚ := C ((-593937975910 / 758893971 : ℚ)) + C ((-1187875951820 / 758893971 : ℚ)) * X + C ((-2753501019899 / 1517787942 : ℚ)) * X ^ 2 + C ((-2827447260883 / 1517787942 : ℚ)) * X ^ 3 + C ((-2963487060019 / 1517787942 : ℚ)) * X ^ 4 + C ((-656704403279 / 1517787942 : ℚ)) * X ^ 5 + C ((602426978875 / 1517787942 : ℚ)) * X ^ 6 + C ((338139866255 / 252964657 : ℚ)) * X ^ 7 + C ((317229710723 / 137980722 : ℚ)) * X ^ 8 + C ((1167539553395 / 505929314 : ℚ)) * X ^ 9 + C ((1675954812230 / 758893971 : ℚ)) * X ^ 10 + C ((2226262156999 / 758893971 : ℚ)) * X ^ 11 + C ((925523167256 / 252964657 : ℚ)) * X ^ 12 + C ((2890089542035 / 758893971 : ℚ)) * X ^ 13 + C ((977869527881 / 252964657 : ℚ)) * X ^ 14 + C ((548763070289 / 137980722 : ℚ)) * X ^ 15 + C ((3910120584779 / 1517787942 : ℚ)) * X ^ 16 + C ((2673453563981 / 1517787942 : ℚ)) * X ^ 17 + C ((237925135611 / 252964657 : ℚ)) * X ^ 18
theorem WP69_pre_eq :
    WC_1_0_re * WP69_Fre - WC_1_0_im * WP69_Fim = WP69_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP69_Fre, WP69_Fim, WP69_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP69_pim_eq :
    WC_1_0_re * WP69_Fim + WC_1_0_im * WP69_Fre = WP69_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP69_Fre, WP69_Fim, WP69_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP69_mul : WC_1_0 * WP69_F = ofLadj WP69_pre WP69_pim := by
  rw [WC_1_0, WP69_F, ofLadj_mul, WP69_pre_eq, WP69_pim_eq]

def WP70_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def WP70_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def WP70_F : Ki := ofLadj WP70_Fre WP70_Fim
def WP70_pre : Polynomial ℚ := C ((-3921676355 / 758893971 : ℚ)) + C ((-128170860700 / 758893971 : ℚ)) * X + C ((-314625714076 / 758893971 : ℚ)) * X ^ 2 + C ((-441576946534 / 758893971 : ℚ)) * X ^ 3 + C ((-730649527348 / 758893971 : ℚ)) * X ^ 4 + C ((-1002108404749 / 758893971 : ℚ)) * X ^ 5 + C ((-1088461480514 / 758893971 : ℚ)) * X ^ 6 + C ((-389695519348 / 252964657 : ℚ)) * X ^ 7 + C ((-354368872925 / 252964657 : ℚ)) * X ^ 8 + C ((-1023209741839 / 758893971 : ℚ)) * X ^ 9 + C ((-936527887472 / 758893971 : ℚ)) * X ^ 10 + C ((-907783697486 / 758893971 : ℚ)) * X ^ 11 + C ((-808357026772 / 758893971 : ℚ)) * X ^ 12 + C ((-236194675921 / 252964657 : ℚ)) * X ^ 13 + C ((-621529672241 / 758893971 : ℚ)) * X ^ 14 + C ((-406920069268 / 758893971 : ℚ)) * X ^ 15 + C ((-4547059885 / 17648697 : ℚ)) * X ^ 16 + C ((-36390166430 / 252964657 : ℚ)) * X ^ 17 + C ((31516961428 / 758893971 : ℚ)) * X ^ 18
def WP70_pim : Polynomial ℚ := C ((45067040135 / 252964657 : ℚ)) + C ((90134080270 / 252964657 : ℚ)) * X + C ((334987310884 / 758893971 : ℚ)) * X ^ 2 + C ((372236548204 / 758893971 : ℚ)) * X ^ 3 + C ((457196168848 / 758893971 : ℚ)) * X ^ 4 + C ((88202752919 / 252964657 : ℚ)) * X ^ 5 + C ((91515934006 / 758893971 : ℚ)) * X ^ 6 + C ((-98723839166 / 758893971 : ℚ)) * X ^ 7 + C ((-72916467887 / 252964657 : ℚ)) * X ^ 8 + C ((-230523050221 / 758893971 : ℚ)) * X ^ 9 + C ((-191859798986 / 758893971 : ℚ)) * X ^ 10 + C ((-240219428432 / 758893971 : ℚ)) * X ^ 11 + C ((-288579057878 / 758893971 : ℚ)) * X ^ 12 + C ((-314500876717 / 758893971 : ℚ)) * X ^ 13 + C ((-363523760597 / 758893971 : ℚ)) * X ^ 14 + C ((-441898104160 / 758893971 : ℚ)) * X ^ 15 + C ((-29653459579 / 68990361 : ℚ)) * X ^ 16 + C ((-79990917816 / 252964657 : ℚ)) * X ^ 17 + C ((-126610841576 / 758893971 : ℚ)) * X ^ 18
theorem WP70_pre_eq :
    WC_1_0_re * WP70_Fre - WC_1_0_im * WP70_Fim = WP70_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP70_Fre, WP70_Fim, WP70_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP70_pim_eq :
    WC_1_0_re * WP70_Fim + WC_1_0_im * WP70_Fre = WP70_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP70_Fre, WP70_Fim, WP70_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP70_mul : WC_1_0 * WP70_F = ofLadj WP70_pre WP70_pim := by
  rw [WC_1_0, WP70_F, ofLadj_mul, WP70_pre_eq, WP70_pim_eq]

def WP71_Fre : Polynomial ℚ := C (3)
def WP71_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def WP71_F : Ki := ofLadj WP71_Fre WP71_Fim
def WP71_pre : Polynomial ℚ := C ((7030259705 / 505929314 : ℚ)) + C ((-17415778165 / 252964657 : ℚ)) * X ^ 2 + C ((-52554853737 / 505929314 : ℚ)) * X ^ 3 + C ((-43639305482 / 252964657 : ℚ)) * X ^ 4 + C ((-52829134530 / 252964657 : ℚ)) * X ^ 5 + C ((-52829134530 / 252964657 : ℚ)) * X ^ 6 + C ((-43639305482 / 252964657 : ℚ)) * X ^ 7 + C ((-52554853737 / 505929314 : ℚ)) * X ^ 8 + C ((-17415778165 / 252964657 : ℚ)) * X ^ 9
def WP71_pim : Polynomial ℚ := C ((32042715175 / 505929314 : ℚ)) + C ((32042715175 / 252964657 : ℚ)) * X + C ((43100801468 / 252964657 : ℚ)) * X ^ 2 + C ((80045104829 / 505929314 : ℚ)) * X ^ 3 + C ((40279314695 / 252964657 : ℚ)) * X ^ 4 + C ((23904922482 / 252964657 : ℚ)) * X ^ 5 + C ((8137792693 / 252964657 : ℚ)) * X ^ 6 + C ((-8236599520 / 252964657 : ℚ)) * X ^ 7 + C ((-15959674479 / 505929314 : ℚ)) * X ^ 8 + C ((-11058086293 / 252964657 : ℚ)) * X ^ 9
theorem WP71_pre_eq :
    WC_1_0_re * WP71_Fre - WC_1_0_im * WP71_Fim = WP71_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP71_Fre, WP71_Fim, WP71_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP71_pim_eq :
    WC_1_0_re * WP71_Fim + WC_1_0_im * WP71_Fre = WP71_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_1_0_re, WC_1_0_im, WP71_Fre, WP71_Fim, WP71_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP71_mul : WC_1_0 * WP71_F = ofLadj WP71_pre WP71_pim := by
  rw [WC_1_0, WP71_F, ofLadj_mul, WP71_pre_eq, WP71_pim_eq]

def WP72_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def WP72_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def WP72_F : Ki := ofLadj WP72_Fre WP72_Fim
def WP72_pre : Polynomial ℚ := C ((-18243325394 / 252964657 : ℚ)) + C ((-114120939408 / 252964657 : ℚ)) * X + C ((-217319952194 / 252964657 : ℚ)) * X ^ 2 + C ((-1890572322209 / 1517787942 : ℚ)) * X ^ 3 + C ((-454105385543 / 252964657 : ℚ)) * X ^ 4 + C ((-98771334829 / 45993574 : ℚ)) * X ^ 5 + C ((-563079290493 / 252964657 : ℚ)) * X ^ 6 + C ((-1810189139689 / 758893971 : ℚ)) * X ^ 7 + C ((-1135972170255 / 505929314 : ℚ)) * X ^ 8 + C ((-1676289295438 / 758893971 : ℚ)) * X ^ 9 + C ((-3323691061705 / 1517787942 : ℚ)) * X ^ 10 + C ((-1599070204868 / 758893971 : ℚ)) * X ^ 11 + C ((-2638965425257 / 1517787942 : ℚ)) * X ^ 12 + C ((-1024329438856 / 758893971 : ℚ)) * X ^ 13 + C ((-758672094278 / 758893971 : ℚ)) * X ^ 14 + C ((-364900043245 / 758893971 : ℚ)) * X ^ 15 + C ((-214438196375 / 1517787942 : ℚ)) * X ^ 16 + C ((-47708251387 / 758893971 : ℚ)) * X ^ 17 + C ((27657646605 / 252964657 : ℚ)) * X ^ 18
def WP72_pim : Polynomial ℚ := C ((148959875750 / 758893971 : ℚ)) + C ((297919751500 / 758893971 : ℚ)) * X + C ((262093405198 / 758893971 : ℚ)) * X ^ 2 + C ((470861329811 / 1517787942 : ℚ)) * X ^ 3 + C ((128014172818 / 758893971 : ℚ)) * X ^ 4 + C ((-246498404899 / 758893971 : ℚ)) * X ^ 5 + C ((-160364810592 / 252964657 : ℚ)) * X ^ 6 + C ((-1422895092529 / 1517787942 : ℚ)) * X ^ 7 + C ((-1832961144241 / 1517787942 : ℚ)) * X ^ 8 + C ((-607645960901 / 505929314 : ℚ)) * X ^ 9 + C ((-1785055047203 / 1517787942 : ℚ)) * X ^ 10 + C ((-340129423838 / 252964657 : ℚ)) * X ^ 11 + C ((-2296498038853 / 1517787942 : ℚ)) * X ^ 12 + C ((-728987503583 / 505929314 : ℚ)) * X ^ 13 + C ((-1061806884313 / 758893971 : ℚ)) * X ^ 14 + C ((-1938251452201 / 1517787942 : ℚ)) * X ^ 15 + C ((-1224837739751 / 1517787942 : ℚ)) * X ^ 16 + C ((-24414853635 / 45993574 : ℚ)) * X ^ 17 + C ((-190297691981 / 758893971 : ℚ)) * X ^ 18
theorem WP72_pre_eq :
    WC_0_1_re * WP72_Fre - WC_0_1_im * WP72_Fim = WP72_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP72_Fre, WP72_Fim, WP72_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP72_pim_eq :
    WC_0_1_re * WP72_Fim + WC_0_1_im * WP72_Fre = WP72_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP72_Fre, WP72_Fim, WP72_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP72_mul : WC_0_1 * WP72_F = ofLadj WP72_pre WP72_pim := by
  rw [WC_0_1, WP72_F, ofLadj_mul, WP72_pre_eq, WP72_pim_eq]

def WP73_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP73_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP73_F : Ki := ofLadj WP73_Fre WP73_Fim
def WP73_pre : Polynomial ℚ := C ((30177949298 / 252964657 : ℚ)) + C ((285302348520 / 252964657 : ℚ)) * X + C ((1791179680858 / 758893971 : ℚ)) * X ^ 2 + C ((885336795564 / 252964657 : ℚ)) * X ^ 3 + C ((4019842619066 / 758893971 : ℚ)) * X ^ 4 + C ((115322083804 / 17648697 : ℚ)) * X ^ 5 + C ((1773898446244 / 252964657 : ℚ)) * X ^ 6 + C ((1927452866531 / 252964657 : ℚ)) * X ^ 7 + C ((46221458227 / 6271851 : ℚ)) * X ^ 8 + C ((1827484021982 / 252964657 : ℚ)) * X ^ 9 + C ((5410913902525 / 758893971 : ℚ)) * X ^ 10 + C ((1769254063576 / 252964657 : ℚ)) * X ^ 11 + C ((4555006856965 / 758893971 : ℚ)) * X ^ 12 + C ((3691272385088 / 758893971 : ℚ)) * X ^ 13 + C ((2936786058775 / 758893971 : ℚ)) * X ^ 14 + C ((1670106943907 / 758893971 : ℚ)) * X ^ 15 + C ((769885408826 / 758893971 : ℚ)) * X ^ 16 + C ((135679891222 / 252964657 : ℚ)) * X ^ 17 + C ((-92409036620 / 758893971 : ℚ)) * X ^ 18
def WP73_pim : Polynomial ℚ := C ((-564978774626 / 758893971 : ℚ)) + C ((-1129957549252 / 758893971 : ℚ)) * X + C ((-1263498036368 / 758893971 : ℚ)) * X ^ 2 + C ((-1412860736248 / 758893971 : ℚ)) * X ^ 3 + C ((-437382646328 / 252964657 : ℚ)) * X ^ 4 + C ((-124848820534 / 252964657 : ℚ)) * X ^ 5 + C ((65670066926 / 252964657 : ℚ)) * X ^ 6 + C ((80225506187 / 68990361 : ℚ)) * X ^ 7 + C ((487977919403 / 252964657 : ℚ)) * X ^ 8 + C ((1445592307004 / 758893971 : ℚ)) * X ^ 9 + C ((1366024729321 / 758893971 : ℚ)) * X ^ 10 + C ((614949122066 / 252964657 : ℚ)) * X ^ 11 + C ((2323670003075 / 758893971 : ℚ)) * X ^ 12 + C ((2377642912508 / 758893971 : ℚ)) * X ^ 13 + C ((836221387061 / 252964657 : ℚ)) * X ^ 14 + C ((820248788191 / 252964657 : ℚ)) * X ^ 15 + C ((1614024955316 / 758893971 : ℚ)) * X ^ 16 + C ((374416162884 / 252964657 : ℚ)) * X ^ 17 + C ((528658189498 / 758893971 : ℚ)) * X ^ 18
theorem WP73_pre_eq :
    WC_0_1_re * WP73_Fre - WC_0_1_im * WP73_Fim = WP73_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP73_Fre, WP73_Fim, WP73_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP73_pim_eq :
    WC_0_1_re * WP73_Fim + WC_0_1_im * WP73_Fre = WP73_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP73_Fre, WP73_Fim, WP73_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP73_mul : WC_0_1 * WP73_F = ofLadj WP73_pre WP73_pim := by
  rw [WC_0_1, WP73_F, ofLadj_mul, WP73_pre_eq, WP73_pim_eq]

def WP74_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def WP74_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def WP74_F : Ki := ofLadj WP74_Fre WP74_Fim
def WP74_pre : Polynomial ℚ := C ((38134365234 / 252964657 : ℚ)) + C ((399423287928 / 252964657 : ℚ)) * X + C ((824158678980 / 252964657 : ℚ)) * X ^ 2 + C ((326562485746 / 68990361 : ℚ)) * X ^ 3 + C ((1857125298960 / 252964657 : ℚ)) * X ^ 4 + C ((7014861113801 / 758893971 : ℚ)) * X ^ 5 + C ((7687592433331 / 758893971 : ℚ)) * X ^ 6 + C ((779053129642 / 68990361 : ℚ)) * X ^ 7 + C ((8563423313347 / 758893971 : ℚ)) * X ^ 8 + C ((2883916445923 / 252964657 : ℚ)) * X ^ 9 + C ((795498234842 / 68990361 : ℚ)) * X ^ 10 + C ((2888518430112 / 252964657 : ℚ)) * X ^ 11 + C ((7552210719478 / 758893971 : ℚ)) * X ^ 12 + C ((2059757766943 / 252964657 : ℚ)) * X ^ 13 + C ((4971235970141 / 758893971 : ℚ)) * X ^ 14 + C ((962638806156 / 252964657 : ℚ)) * X ^ 15 + C ((1378470918287 / 758893971 : ℚ)) * X ^ 16 + C ((235246532919 / 252964657 : ℚ)) * X ^ 17 + C ((-110292110714 / 758893971 : ℚ)) * X ^ 18
def WP74_pim : Polynomial ℚ := C ((-842324707210 / 758893971 : ℚ)) + C ((-1684649414420 / 758893971 : ℚ)) * X + C ((-647495503190 / 252964657 : ℚ)) * X ^ 2 + C ((-774348607744 / 252964657 : ℚ)) * X ^ 3 + C ((-803102700178 / 252964657 : ℚ)) * X ^ 4 + C ((-1258165837895 / 758893971 : ℚ)) * X ^ 5 + C ((-618989466479 / 758893971 : ℚ)) * X ^ 6 + C ((87125124852 / 252964657 : ℚ)) * X ^ 7 + C ((1072051352135 / 758893971 : ℚ)) * X ^ 8 + C ((1074198740299 / 758893971 : ℚ)) * X ^ 9 + C ((8856780874 / 5882899 : ℚ)) * X ^ 10 + C ((698306432236 / 252964657 : ℚ)) * X ^ 11 + C ((1015771286890 / 252964657 : ℚ)) * X ^ 12 + C ((1124492316089 / 252964657 : ℚ)) * X ^ 13 + C ((3756183650093 / 758893971 : ℚ)) * X ^ 14 + C ((1272468391508 / 252964657 : ℚ)) * X ^ 15 + C ((855428108795 / 252964657 : ℚ)) * X ^ 16 + C ((1816060156985 / 758893971 : ℚ)) * X ^ 17 + C ((835716730450 / 758893971 : ℚ)) * X ^ 18
theorem WP74_pre_eq :
    WC_0_1_re * WP74_Fre - WC_0_1_im * WP74_Fim = WP74_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP74_Fre, WP74_Fim, WP74_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP74_pim_eq :
    WC_0_1_re * WP74_Fim + WC_0_1_im * WP74_Fre = WP74_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP74_Fre, WP74_Fim, WP74_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP74_mul : WC_0_1 * WP74_F = ofLadj WP74_pre WP74_pim := by
  rw [WC_0_1, WP74_F, ofLadj_mul, WP74_pre_eq, WP74_pim_eq]

def WP75_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def WP75_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def WP75_F : Ki := ofLadj WP75_Fre WP75_Fim
def WP75_pre : Polynomial ℚ := C ((-124690005160 / 758893971 : ℚ)) + C ((-399423287928 / 252964657 : ℚ)) * X + C ((-816052489091 / 252964657 : ℚ)) * X ^ 2 + C ((-1202454149547 / 252964657 : ℚ)) * X ^ 3 + C ((-5478949168826 / 758893971 : ℚ)) * X ^ 4 + C ((-157996851250 / 17648697 : ℚ)) * X ^ 5 + C ((-169199985490 / 17648697 : ℚ)) * X ^ 6 + C ((-2661829271634 / 252964657 : ℚ)) * X ^ 7 + C ((-2573910801097 / 252964657 : ℚ)) * X ^ 8 + C ((-7636140152450 / 758893971 : ℚ)) * X ^ 9 + C ((-7564944670861 / 758893971 : ℚ)) * X ^ 10 + C ((-2485588065472 / 252964657 : ℚ)) * X ^ 11 + C ((-6366674807077 / 758893971 : ℚ)) * X ^ 12 + C ((-5187982685177 / 758893971 : ℚ)) * X ^ 13 + C ((-1371456651550 / 252964657 : ℚ)) * X ^ 14 + C ((-2336623134581 / 758893971 : ℚ)) * X ^ 15 + C ((-345957119812 / 252964657 : ℚ)) * X ^ 16 + C ((-16852623852 / 22996787 : ℚ)) * X ^ 17 + C ((169915511495 / 758893971 : ℚ)) * X ^ 18
def WP75_pim : Polynomial ℚ := C ((72684486812 / 68990361 : ℚ)) + C ((145368973624 / 68990361 : ℚ)) * X + C ((1769847797321 / 758893971 : ℚ)) * X ^ 2 + C ((672182857061 / 252964657 : ℚ)) * X ^ 3 + C ((1914847006933 / 758893971 : ℚ)) * X ^ 4 + C ((595602996077 / 758893971 : ℚ)) * X ^ 5 + C ((-193122738757 / 758893971 : ℚ)) * X ^ 6 + C ((-1163867297005 / 758893971 : ℚ)) * X ^ 7 + C ((-2002543112063 / 758893971 : ℚ)) * X ^ 8 + C ((-1995913411741 / 758893971 : ℚ)) * X ^ 9 + C ((-1913236701611 / 758893971 : ℚ)) * X ^ 10 + C ((-883752958774 / 252964657 : ℚ)) * X ^ 11 + C ((-3389281051033 / 758893971 : ℚ)) * X ^ 12 + C ((-3477393428360 / 758893971 : ℚ)) * X ^ 13 + C ((-3717464501900 / 758893971 : ℚ)) * X ^ 14 + C ((-1217668163724 / 252964657 : ℚ)) * X ^ 15 + C ((-2428752727883 / 758893971 : ℚ)) * X ^ 16 + C ((-559062190739 / 252964657 : ℚ)) * X ^ 17 + C ((-801434261536 / 758893971 : ℚ)) * X ^ 18
theorem WP75_pre_eq :
    WC_0_1_re * WP75_Fre - WC_0_1_im * WP75_Fim = WP75_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP75_Fre, WP75_Fim, WP75_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP75_pim_eq :
    WC_0_1_re * WP75_Fim + WC_0_1_im * WP75_Fre = WP75_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP75_Fre, WP75_Fim, WP75_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP75_mul : WC_0_1 * WP75_F = ofLadj WP75_pre WP75_pim := by
  rw [WC_0_1, WP75_F, ofLadj_mul, WP75_pre_eq, WP75_pim_eq]

def WP76_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def WP76_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def WP76_F : Ki := ofLadj WP76_Fre WP76_Fim
def WP76_pre : Polynomial ℚ := C ((1647714446 / 758893971 : ℚ)) + C ((57060469704 / 252964657 : ℚ)) * X + C ((128513522208 / 252964657 : ℚ)) * X ^ 2 + C ((190782820576 / 252964657 : ℚ)) * X ^ 3 + C ((311831858750 / 252964657 : ℚ)) * X ^ 4 + C ((1265722410350 / 758893971 : ℚ)) * X ^ 5 + C ((42716321074 / 22996787 : ℚ)) * X ^ 6 + C ((1482053259892 / 758893971 : ℚ)) * X ^ 7 + C ((1365701389666 / 758893971 : ℚ)) * X ^ 8 + C ((1301843740466 / 758893971 : ℚ)) * X ^ 9 + C ((400688271462 / 252964657 : ℚ)) * X ^ 10 + C ((105719135996 / 68990361 : ℚ)) * X ^ 11 + C ((343627801758 / 252964657 : ℚ)) * X ^ 12 + C ((916303173842 / 758893971 : ℚ)) * X ^ 13 + C ((793352927938 / 758893971 : ℚ)) * X ^ 14 + C ((517741679668 / 758893971 : ℚ)) * X ^ 15 + C ((561679234 / 1604427 : ℚ)) * X ^ 16 + C ((121758092590 / 758893971 : ℚ)) * X ^ 17 + C ((-9605334658 / 252964657 : ℚ)) * X ^ 18
def WP76_pim : Polynomial ℚ := C ((-1499738170 / 6271851 : ℚ)) + C ((-2999476340 / 6271851 : ℚ)) * X + C ((-142180748098 / 252964657 : ℚ)) * X ^ 2 + C ((-517264390084 / 758893971 : ℚ)) * X ^ 3 + C ((-588615570430 / 758893971 : ℚ)) * X ^ 4 + C ((-369757098710 / 758893971 : ℚ)) * X ^ 5 + C ((-148965439820 / 758893971 : ℚ)) * X ^ 6 + C ((98554893058 / 758893971 : ℚ)) * X ^ 7 + C ((245598057994 / 758893971 : ℚ)) * X ^ 8 + C ((83414412926 / 252964657 : ℚ)) * X ^ 9 + C ((68256133094 / 252964657 : ℚ)) * X ^ 10 + C ((91606566076 / 252964657 : ℚ)) * X ^ 11 + C ((10450636278 / 22996787 : ℚ)) * X ^ 12 + C ((363001764832 / 758893971 : ℚ)) * X ^ 13 + C ((458369091406 / 758893971 : ℚ)) * X ^ 14 + C ((178220551950 / 252964657 : ℚ)) * X ^ 15 + C ((405724984034 / 758893971 : ℚ)) * X ^ 16 + C ((99900104604 / 252964657 : ℚ)) * X ^ 17 + C ((142101780838 / 758893971 : ℚ)) * X ^ 18
theorem WP76_pre_eq :
    WC_0_1_re * WP76_Fre - WC_0_1_im * WP76_Fim = WP76_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP76_Fre, WP76_Fim, WP76_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP76_pim_eq :
    WC_0_1_re * WP76_Fim + WC_0_1_im * WP76_Fre = WP76_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP76_Fre, WP76_Fim, WP76_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP76_mul : WC_0_1 * WP76_F = ofLadj WP76_pre WP76_pim := by
  rw [WC_0_1, WP76_F, ofLadj_mul, WP76_pre_eq, WP76_pim_eq]

def WP77_Fre : Polynomial ℚ := C (3)
def WP77_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def WP77_F : Ki := ofLadj WP77_Fre WP77_Fim
def WP77_pre : Polynomial ℚ := C ((-5143454729 / 252964657 : ℚ)) + C ((19874466927 / 252964657 : ℚ)) * X ^ 2 + C ((34795870949 / 252964657 : ℚ)) * X ^ 3 + C ((53641632574 / 252964657 : ℚ)) * X ^ 4 + C ((67381334802 / 252964657 : ℚ)) * X ^ 5 + C ((67381334802 / 252964657 : ℚ)) * X ^ 6 + C ((53641632574 / 252964657 : ℚ)) * X ^ 7 + C ((34795870949 / 252964657 : ℚ)) * X ^ 8 + C ((19874466927 / 252964657 : ℚ)) * X ^ 9
def WP77_pim : Polynomial ℚ := C ((-21397676139 / 252964657 : ℚ)) + C ((-42795352278 / 252964657 : ℚ)) * X + C ((-54222841916 / 252964657 : ℚ)) * X ^ 2 + C ((-53975427423 / 252964657 : ℚ)) * X ^ 3 + C ((-51192721138 / 252964657 : ℚ)) * X ^ 4 + C ((-31613645725 / 252964657 : ℚ)) * X ^ 5 + C ((-11181706553 / 252964657 : ℚ)) * X ^ 6 + C ((8397368860 / 252964657 : ℚ)) * X ^ 7 + C ((11180075145 / 252964657 : ℚ)) * X ^ 8 + C ((11427489638 / 252964657 : ℚ)) * X ^ 9
theorem WP77_pre_eq :
    WC_0_1_re * WP77_Fre - WC_0_1_im * WP77_Fim = WP77_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP77_Fre, WP77_Fim, WP77_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP77_pim_eq :
    WC_0_1_re * WP77_Fim + WC_0_1_im * WP77_Fre = WP77_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_0_1_re, WC_0_1_im, WP77_Fre, WP77_Fim, WP77_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP77_mul : WC_0_1 * WP77_F = ofLadj WP77_pre WP77_pim := by
  rw [WC_0_1, WP77_F, ofLadj_mul, WP77_pre_eq, WP77_pim_eq]

def WP78_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def WP78_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def WP78_F : Ki := ofLadj WP78_Fre WP78_Fim
def WP78_pre : Polynomial ℚ := C ((-4183630613 / 505929314 : ℚ)) + C ((-7076174476 / 252964657 : ℚ)) * X + C ((-9824186465 / 252964657 : ℚ)) * X ^ 2 + C ((-5802667611 / 183974296 : ℚ)) * X ^ 3 + C ((-56070694811 / 1011858628 : ℚ)) * X ^ 4 + C ((-151212170151 / 2023717256 : ℚ)) * X ^ 5 + C ((-65456484867 / 1011858628 : ℚ)) * X ^ 6 + C ((-19032829975 / 252964657 : ℚ)) * X ^ 7 + C ((-45759330281 / 505929314 : ℚ)) * X ^ 8 + C ((-189282713253 / 2023717256 : ℚ)) * X ^ 9 + C ((-97529423809 / 1011858628 : ℚ)) * X ^ 10 + C ((-82447879471 / 1011858628 : ℚ)) * X ^ 11 + C ((-69224725905 / 1011858628 : ℚ)) * X ^ 12 + C ((-10062656503 / 183974296 : ℚ)) * X ^ 13 + C ((-119207977403 / 2023717256 : ℚ)) * X ^ 14 + C ((-11085524617 / 252964657 : ℚ)) * X ^ 15 + C ((-34713892171 / 2023717256 : ℚ)) * X ^ 16 + C ((-13753273147 / 505929314 : ℚ)) * X ^ 17 + C ((-24281473379 / 1011858628 : ℚ)) * X ^ 18
def WP78_pim : Polynomial ℚ := C ((4876768607 / 505929314 : ℚ)) + C ((4876768607 / 252964657 : ℚ)) * X + C ((568516954 / 252964657 : ℚ)) * X ^ 2 + C ((14307814833 / 2023717256 : ℚ)) * X ^ 3 + C ((1396299591 / 45993574 : ℚ)) * X ^ 4 + C ((1608795355 / 252964657 : ℚ)) * X ^ 5 + C ((51410584 / 252964657 : ℚ)) * X ^ 6 + C ((45544218655 / 2023717256 : ℚ)) * X ^ 7 + C ((1109905199 / 91987148 : ℚ)) * X ^ 8 + C ((2912267027 / 505929314 : ℚ)) * X ^ 9 + C ((125351091 / 8362468 : ℚ)) * X ^ 10 + C ((624374823 / 505929314 : ℚ)) * X ^ 11 + C ((-12669982719 / 1011858628 : ℚ)) * X ^ 12 + C ((6952985925 / 505929314 : ℚ)) * X ^ 13 + C ((5283418229 / 2023717256 : ℚ)) * X ^ 14 + C ((-3854166455 / 183974296 : ℚ)) * X ^ 15 + C ((16447749743 / 2023717256 : ℚ)) * X ^ 16 + C ((14279750185 / 2023717256 : ℚ)) * X ^ 17 + C ((-10288211107 / 1011858628 : ℚ)) * X ^ 18
theorem WP78_pre_eq :
    WC_2_0_re * WP78_Fre - WC_2_0_im * WP78_Fim = WP78_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP78_Fre, WP78_Fim, WP78_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP78_pim_eq :
    WC_2_0_re * WP78_Fim + WC_2_0_im * WP78_Fre = WP78_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP78_Fre, WP78_Fim, WP78_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP78_mul : WC_2_0 * WP78_F = ofLadj WP78_pre WP78_pim := by
  rw [WC_2_0, WP78_F, ofLadj_mul, WP78_pre_eq, WP78_pim_eq]

def WP79_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def WP79_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def WP79_F : Ki := ofLadj WP79_Fre WP79_Fim
def WP79_pre : Polynomial ℚ := C ((11427391595 / 505929314 : ℚ)) + C ((17690436190 / 252964657 : ℚ)) * X + C ((56568833763 / 505929314 : ℚ)) * X ^ 2 + C ((22635181253 / 252964657 : ℚ)) * X ^ 3 + C ((71216822463 / 505929314 : ℚ)) * X ^ 4 + C ((1301274138 / 5882899 : ℚ)) * X ^ 5 + C ((46159427310 / 252964657 : ℚ)) * X ^ 6 + C ((203401439781 / 1011858628 : ℚ)) * X ^ 7 + C ((270989988275 / 1011858628 : ℚ)) * X ^ 8 + C ((65579013877 / 252964657 : ℚ)) * X ^ 9 + C ((264246684315 / 1011858628 : ℚ)) * X ^ 10 + C ((514508074 / 2090617 : ℚ)) * X ^ 11 + C ((193484939555 / 1011858628 : ℚ)) * X ^ 12 + C ((74589193991 / 505929314 : ℚ)) * X ^ 13 + C ((180449263263 / 1011858628 : ℚ)) * X ^ 14 + C ((128240893287 / 1011858628 : ℚ)) * X ^ 15 + C ((21667407947 / 505929314 : ℚ)) * X ^ 16 + C ((41258129195 / 505929314 : ℚ)) * X ^ 17 + C ((16818274608 / 252964657 : ℚ)) * X ^ 18
def WP79_pim : Polynomial ℚ := C ((-20152617803 / 505929314 : ℚ)) + C ((-20152617803 / 252964657 : ℚ)) * X + C ((-6073485019 / 252964657 : ℚ)) * X ^ 2 + C ((-15383735842 / 252964657 : ℚ)) * X ^ 3 + C ((-2871577163 / 22996787 : ℚ)) * X ^ 4 + C ((-30091767557 / 505929314 : ℚ)) * X ^ 5 + C ((-33045295715 / 505929314 : ℚ)) * X ^ 6 + C ((-113323104371 / 1011858628 : ℚ)) * X ^ 7 + C ((-95091225723 / 1011858628 : ℚ)) * X ^ 8 + C ((-4576425547 / 45993574 : ℚ)) * X ^ 9 + C ((-103978598907 / 1011858628 : ℚ)) * X ^ 10 + C ((-30750156771 / 505929314 : ℚ)) * X ^ 11 + C ((-19022028177 / 1011858628 : ℚ)) * X ^ 12 + C ((-39317898093 / 505929314 : ℚ)) * X ^ 13 + C ((-46984929205 / 1011858628 : ℚ)) * X ^ 14 + C ((25021183941 / 1011858628 : ℚ)) * X ^ 15 + C ((-9291244954 / 252964657 : ℚ)) * X ^ 16 + C ((-10042997984 / 252964657 : ℚ)) * X ^ 17 + C ((5520108653 / 505929314 : ℚ)) * X ^ 18
theorem WP79_pre_eq :
    WC_2_0_re * WP79_Fre - WC_2_0_im * WP79_Fim = WP79_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP79_Fre, WP79_Fim, WP79_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP79_pim_eq :
    WC_2_0_re * WP79_Fim + WC_2_0_im * WP79_Fre = WP79_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP79_Fre, WP79_Fim, WP79_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP79_mul : WC_2_0 * WP79_F = ofLadj WP79_pre WP79_pim := by
  rw [WC_2_0, WP79_F, ofLadj_mul, WP79_pre_eq, WP79_pim_eq]

def WP80_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def WP80_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def WP80_F : Ki := ofLadj WP80_Fre WP80_Fim
def WP80_pre : Polynomial ℚ := C ((16256565583 / 505929314 : ℚ)) + C ((24766610666 / 252964657 : ℚ)) * X + C ((39188761185 / 252964657 : ℚ)) * X ^ 2 + C ((28770511635 / 252964657 : ℚ)) * X ^ 3 + C ((96672787771 / 505929314 : ℚ)) * X ^ 4 + C ((323139509021 / 1011858628 : ℚ)) * X ^ 5 + C ((253525859569 / 1011858628 : ℚ)) * X ^ 6 + C ((141364136719 / 505929314 : ℚ)) * X ^ 7 + C ((398223490765 / 1011858628 : ℚ)) * X ^ 8 + C ((389316117841 / 1011858628 : ℚ)) * X ^ 9 + C ((195176117805 / 505929314 : ℚ)) * X ^ 10 + C ((92597337587 / 252964657 : ℚ)) * X ^ 11 + C ((145642896473 / 505929314 : ℚ)) * X ^ 12 + C ((232561073101 / 1011858628 : ℚ)) * X ^ 13 + C ((283141444225 / 1011858628 : ℚ)) * X ^ 14 + C ((97841269089 / 505929314 : ℚ)) * X ^ 15 + C ((67419197495 / 1011858628 : ℚ)) * X ^ 16 + C ((137032846947 / 1011858628 : ℚ)) * X ^ 17 + C ((53149920141 / 505929314 : ℚ)) * X ^ 18
def WP80_pim : Polynomial ℚ := C ((-30336517267 / 505929314 : ℚ)) + C ((-30336517267 / 252964657 : ℚ)) * X + C ((-21024925079 / 505929314 : ℚ)) * X ^ 2 + C ((-54711636253 / 505929314 : ℚ)) * X ^ 3 + C ((-4762116681 / 22996787 : ℚ)) * X ^ 4 + C ((-112612473263 / 1011858628 : ℚ)) * X ^ 5 + C ((-127184214973 / 1011858628 : ℚ)) * X ^ 6 + C ((-50472969066 / 252964657 : ℚ)) * X ^ 7 + C ((-183224628717 / 1011858628 : ℚ)) * X ^ 8 + C ((-193068673009 / 1011858628 : ℚ)) * X ^ 9 + C ((-1089049590 / 5882899 : ℚ)) * X ^ 10 + C ((-31608658368 / 252964657 : ℚ)) * X ^ 11 + C ((-16388184366 / 252964657 : ℚ)) * X ^ 12 + C ((-139096812845 / 1011858628 : ℚ)) * X ^ 13 + C ((-81567434789 / 1011858628 : ℚ)) * X ^ 14 + C ((12151593185 / 505929314 : ℚ)) * X ^ 15 + C ((-66716834163 / 1011858628 : ℚ)) * X ^ 16 + C ((-67701813613 / 1011858628 : ℚ)) * X ^ 17 + C ((6453243923 / 505929314 : ℚ)) * X ^ 18
theorem WP80_pre_eq :
    WC_2_0_re * WP80_Fre - WC_2_0_im * WP80_Fim = WP80_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP80_Fre, WP80_Fim, WP80_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP80_pim_eq :
    WC_2_0_re * WP80_Fim + WC_2_0_im * WP80_Fre = WP80_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP80_Fre, WP80_Fim, WP80_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP80_mul : WC_2_0 * WP80_F = ofLadj WP80_pre WP80_pim := by
  rw [WC_2_0, WP80_F, ofLadj_mul, WP80_pre_eq, WP80_pim_eq]

def WP81_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def WP81_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def WP81_F : Ki := ofLadj WP81_Fre WP81_Fim
def WP81_pre : Polynomial ℚ := C ((-729153839 / 22996787 : ℚ)) + C ((-24766610666 / 252964657 : ℚ)) * X + C ((-153258882503 / 1011858628 : ℚ)) * X ^ 2 + C ((-117476035379 / 1011858628 : ℚ)) * X ^ 3 + C ((-48836422399 / 252964657 : ℚ)) * X ^ 4 + C ((-1774846164 / 5882899 : ℚ)) * X ^ 5 + C ((-1449231140 / 5882899 : ℚ)) * X ^ 6 + C ((-276237257501 / 1011858628 : ℚ)) * X ^ 7 + C ((-376038303385 / 1011858628 : ℚ)) * X ^ 8 + C ((-16620033671 / 45993574 : ℚ)) * X ^ 9 + C ((-184838499397 / 505929314 : ℚ)) * X ^ 10 + C ((-86638815312 / 252964657 : ℚ)) * X ^ 11 + C ((-135305278065 / 505929314 : ℚ)) * X ^ 12 + C ((-212381858259 / 1011858628 : ℚ)) * X ^ 13 + C ((-129281134003 / 505929314 : ℚ)) * X ^ 14 + C ((-91457739947 / 505929314 : ℚ)) * X ^ 15 + C ((-32314238751 / 505929314 : ℚ)) * X ^ 16 + C ((-60317130815 / 505929314 : ℚ)) * X ^ 17 + C ((-102023911989 / 1011858628 : ℚ)) * X ^ 18
def WP81_pim : Polynomial ℚ := C ((14283736824 / 252964657 : ℚ)) + C ((28567473648 / 252964657 : ℚ)) * X + C ((34745692369 / 1011858628 : ℚ)) * X ^ 2 + C ((87713050479 / 1011858628 : ℚ)) * X ^ 3 + C ((183795580707 / 1011858628 : ℚ)) * X ^ 4 + C ((81029950107 / 1011858628 : ℚ)) * X ^ 5 + C ((86884455517 / 1011858628 : ℚ)) * X ^ 6 + C ((80119262361 / 505929314 : ℚ)) * X ^ 7 + C ((129609908911 / 1011858628 : ℚ)) * X ^ 8 + C ((135013592181 / 1011858628 : ℚ)) * X ^ 9 + C ((71426697945 / 505929314 : ℚ)) * X ^ 10 + C ((40219749689 / 505929314 : ℚ)) * X ^ 11 + C ((9012801433 / 505929314 : ℚ)) * X ^ 12 + C ((52694804399 / 505929314 : ℚ)) * X ^ 13 + C ((28912966979 / 505929314 : ℚ)) * X ^ 14 + C ((-48360002919 / 1011858628 : ℚ)) * X ^ 15 + C ((50967938927 / 1011858628 : ℚ)) * X ^ 16 + C ((56266548797 / 1011858628 : ℚ)) * X ^ 17 + C ((-10262604581 / 505929314 : ℚ)) * X ^ 18
theorem WP81_pre_eq :
    WC_2_0_re * WP81_Fre - WC_2_0_im * WP81_Fim = WP81_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP81_Fre, WP81_Fim, WP81_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP81_pim_eq :
    WC_2_0_re * WP81_Fim + WC_2_0_im * WP81_Fre = WP81_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP81_Fre, WP81_Fim, WP81_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP81_mul : WC_2_0 * WP81_F = ofLadj WP81_pre WP81_pim := by
  rw [WC_2_0, WP81_F, ofLadj_mul, WP81_pre_eq, WP81_pim_eq]

def WP82_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def WP82_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def WP82_F : Ki := ofLadj WP82_Fre WP82_Fim
def WP82_pre : Polynomial ℚ := C ((239069829 / 45993574 : ℚ)) + C ((3538087238 / 252964657 : ℚ)) * X + C ((555548326 / 22996787 : ℚ)) * X ^ 2 + C ((4217263287 / 252964657 : ℚ)) * X ^ 3 + C ((14465312683 / 505929314 : ℚ)) * X ^ 4 + C ((14362121959 / 252964657 : ℚ)) * X ^ 5 + C ((11158389950 / 252964657 : ℚ)) * X ^ 6 + C ((8505381988 / 252964657 : ℚ)) * X ^ 7 + C ((14190084201 / 252964657 : ℚ)) * X ^ 8 + C ((16534999792 / 252964657 : ℚ)) * X ^ 9 + C ((14451144394 / 252964657 : ℚ)) * X ^ 10 + C ((11179018413 / 252964657 : ℚ)) * X ^ 11 + C ((10913057156 / 252964657 : ℚ)) * X ^ 12 + C ((10423968206 / 252964657 : ℚ)) * X ^ 13 + C ((9972820914 / 252964657 : ℚ)) * X ^ 14 + C ((5794741020 / 252964657 : ℚ)) * X ^ 15 + C ((103431885 / 11765798 : ℚ)) * X ^ 16 + C ((10855035073 / 505929314 : ℚ)) * X ^ 17 + C ((9044030747 / 505929314 : ℚ)) * X ^ 18
def WP82_pim : Polynomial ℚ := C ((-6860993351 / 505929314 : ℚ)) + C ((-6860993351 / 252964657 : ℚ)) * X + C ((-4552969177 / 505929314 : ℚ)) * X ^ 2 + C ((-5643256574 / 252964657 : ℚ)) * X ^ 3 + C ((-22649181801 / 505929314 : ℚ)) * X ^ 4 + C ((-5645563988 / 252964657 : ℚ)) * X ^ 5 + C ((-64316665 / 4181234 : ℚ)) * X ^ 6 + C ((-15648742661 / 505929314 : ℚ)) * X ^ 7 + C ((-9726264833 / 252964657 : ℚ)) * X ^ 8 + C ((-8856777134 / 252964657 : ℚ)) * X ^ 9 + C ((-5982679754 / 252964657 : ℚ)) * X ^ 10 + C ((-5020963658 / 252964657 : ℚ)) * X ^ 11 + C ((-4059247562 / 252964657 : ℚ)) * X ^ 12 + C ((-1049028899 / 45993574 : ℚ)) * X ^ 13 + C ((-1533399260 / 252964657 : ℚ)) * X ^ 14 + C ((2755728607 / 505929314 : ℚ)) * X ^ 15 + C ((-8341335847 / 505929314 : ℚ)) * X ^ 16 + C ((-3195530523 / 252964657 : ℚ)) * X ^ 17 + C ((157850411 / 45993574 : ℚ)) * X ^ 18
theorem WP82_pre_eq :
    WC_2_0_re * WP82_Fre - WC_2_0_im * WP82_Fim = WP82_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP82_Fre, WP82_Fim, WP82_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP82_pim_eq :
    WC_2_0_re * WP82_Fim + WC_2_0_im * WP82_Fre = WP82_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP82_Fre, WP82_Fim, WP82_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP82_mul : WC_2_0 * WP82_F = ofLadj WP82_pre WP82_pim := by
  rw [WC_2_0, WP82_F, ofLadj_mul, WP82_pre_eq, WP82_pim_eq]

def WP83_Fre : Polynomial ℚ := C (3)
def WP83_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def WP83_F : Ki := ofLadj WP83_Fre WP83_Fim
def WP83_pre : Polynomial ℚ := C ((645543375 / 1011858628 : ℚ)) + C ((4275928293 / 1011858628 : ℚ)) * X ^ 2 + C ((3078626277 / 1011858628 : ℚ)) * X ^ 3 + C ((-1049455305 / 505929314 : ℚ)) * X ^ 4 + C ((6217119351 / 1011858628 : ℚ)) * X ^ 5 + C ((6217119351 / 1011858628 : ℚ)) * X ^ 6 + C ((-1049455305 / 505929314 : ℚ)) * X ^ 7 + C ((3078626277 / 1011858628 : ℚ)) * X ^ 8 + C ((4275928293 / 1011858628 : ℚ)) * X ^ 9
def WP83_pim : Polynomial ℚ := C ((-5307130857 / 1011858628 : ℚ)) + C ((-5307130857 / 505929314 : ℚ)) * X + C ((-1497770199 / 505929314 : ℚ)) * X ^ 2 + C ((-5061363693 / 1011858628 : ℚ)) * X ^ 3 + C ((-388440003 / 45993574 : ℚ)) * X ^ 4 + C ((-1375674789 / 252964657 : ℚ)) * X ^ 5 + C ((-2555781279 / 505929314 : ℚ)) * X ^ 6 + C ((-517145412 / 252964657 : ℚ)) * X ^ 7 + C ((-504808911 / 91987148 : ℚ)) * X ^ 8 + C ((-1904680329 / 252964657 : ℚ)) * X ^ 9
theorem WP83_pre_eq :
    WC_2_0_re * WP83_Fre - WC_2_0_im * WP83_Fim = WP83_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP83_Fre, WP83_Fim, WP83_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP83_pim_eq :
    WC_2_0_re * WP83_Fim + WC_2_0_im * WP83_Fre = WP83_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [WC_2_0_re, WC_2_0_im, WP83_Fre, WP83_Fim, WP83_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem WP83_mul : WC_2_0 * WP83_F = ofLadj WP83_pre WP83_pim := by
  rw [WC_2_0, WP83_F, ofLadj_mul, WP83_pre_eq, WP83_pim_eq]

end V14Formalization.D12SigmaPlusSegreCore
