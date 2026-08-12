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

def VP0_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def VP0_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def VP0_F : Ki := ofLadj VP0_Fre VP0_Fim
def VP0_pre : Polynomial ℚ := C ((-72983259 / 20812 : ℚ)) + C ((65370741 / 20812 : ℚ)) * X ^ 2 + C ((46767855 / 5203 : ℚ)) * X ^ 3 + C ((286301715 / 10406 : ℚ)) * X ^ 4 + C ((960998201 / 20812 : ℚ)) * X ^ 5 + C ((680744547 / 10406 : ℚ)) * X ^ 6 + C ((421601414 / 5203 : ℚ)) * X ^ 7 + C ((1809073725 / 20812 : ℚ)) * X ^ 8 + C ((465414711 / 5203 : ℚ)) * X ^ 9 + C ((950834483 / 10406 : ℚ)) * X ^ 10 + C ((1989616749 / 20812 : ℚ)) * X ^ 11 + C ((950834483 / 10406 : ℚ)) * X ^ 12 + C ((1796288103 / 20812 : ℚ)) * X ^ 13 + C ((147454755 / 1892 : ℚ)) * X ^ 14 + C ((594110641 / 10406 : ℚ)) * X ^ 15 + C ((192800769 / 5203 : ℚ)) * X ^ 16 + C ((370712183 / 20812 : ℚ)) * X ^ 17 + C ((18604764 / 5203 : ℚ)) * X ^ 18
def VP0_pim : Polynomial ℚ := C ((-250489989 / 20812 : ℚ)) + C ((-250489989 / 10406 : ℚ)) * X + C ((-815434203 / 20812 : ℚ)) * X ^ 2 + C ((-112780521 / 1892 : ℚ)) * X ^ 3 + C ((-1503340671 / 20812 : ℚ)) * X ^ 4 + C ((-814752097 / 10406 : ℚ)) * X ^ 5 + C ((-1663132695 / 20812 : ℚ)) * X ^ 6 + C ((-355101477 / 5203 : ℚ)) * X ^ 7 + C ((-631092689 / 10406 : ℚ)) * X ^ 8 + C ((-1254582625 / 20812 : ℚ)) * X ^ 9 + C ((-609907961 / 10406 : ℚ)) * X ^ 10 + C ((-83496663 / 1892 : ℚ)) * X ^ 11 + C ((-154277666 / 5203 : ℚ)) * X ^ 12 + C ((-66972434 / 5203 : ℚ)) * X ^ 13 + C ((164864545 / 20812 : ℚ)) * X ^ 14 + C ((36861207 / 1892 : ℚ)) * X ^ 15 + C ((243540465 / 10406 : ℚ)) * X ^ 16 + C ((467649395 / 20812 : ℚ)) * X ^ 17 + C ((90183369 / 10406 : ℚ)) * X ^ 18
theorem VP0_pre_eq :
    VA_0_0_re * VP0_Fre - VA_0_0_im * VP0_Fim = VP0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP0_Fre, VP0_Fim, VP0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP0_pim_eq :
    VA_0_0_re * VP0_Fim + VA_0_0_im * VP0_Fre = VP0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP0_Fre, VP0_Fim, VP0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP0_mul : VA_0_0 * VP0_F = ofLadj VP0_pre VP0_pim := by
  rw [VA_0_0, VP0_F, ofLadj_mul, VP0_pre_eq, VP0_pim_eq]

def VP1_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def VP1_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def VP1_F : Ki := ofLadj VP1_Fre VP1_Fim
def VP1_pre : Polynomial ℚ := C ((-1100315 / 10406 : ℚ)) + C ((111328884 / 5203 : ℚ)) * X + C ((445798643 / 10406 : ℚ)) * X ^ 2 + C ((1091028589 / 15609 : ℚ)) * X ^ 3 + C ((55828207 / 473 : ℚ)) * X ^ 4 + C ((786132264 / 5203 : ℚ)) * X ^ 5 + C ((5690541371 / 31218 : ℚ)) * X ^ 6 + C ((2037847061 / 10406 : ℚ)) * X ^ 7 + C ((66157853 / 363 : ℚ)) * X ^ 8 + C ((62631197 / 363 : ℚ)) * X ^ 9 + C ((5155830455 / 31218 : ℚ)) * X ^ 10 + C ((2536326326 / 15609 : ℚ)) * X ^ 11 + C ((4487857151 / 31218 : ℚ)) * X ^ 12 + C ((4048887013 / 31218 : ℚ)) * X ^ 13 + C ((1753759090 / 15609 : ℚ)) * X ^ 14 + C ((69176519 / 946 : ℚ)) * X ^ 15 + C ((1415921513 / 31218 : ℚ)) * X ^ 16 + C ((73695621 / 5203 : ℚ)) * X ^ 17 + C ((-24342399 / 5203 : ℚ)) * X ^ 18
def VP1_pim : Polynomial ℚ := C ((-211044049 / 10406 : ℚ)) + C ((-211044049 / 5203 : ℚ)) * X + C ((-546648671 / 10406 : ℚ)) * X ^ 2 + C ((-1123685360 / 15609 : ℚ)) * X ^ 3 + C ((-1129285445 / 15609 : ℚ)) * X ^ 4 + C ((-829866566 / 15609 : ℚ)) * X ^ 5 + C ((-993446767 / 31218 : ℚ)) * X ^ 6 + C ((285488299 / 31218 : ℚ)) * X ^ 7 + C ((490002965 / 15609 : ℚ)) * X ^ 8 + C ((468020251 / 15609 : ℚ)) * X ^ 9 + C ((22297299 / 946 : ℚ)) * X ^ 10 + C ((537827927 / 15609 : ℚ)) * X ^ 11 + C ((1415500841 / 31218 : ℚ)) * X ^ 12 + C ((529650975 / 10406 : ℚ)) * X ^ 13 + C ((1076206102 / 15609 : ℚ)) * X ^ 14 + C ((2291295533 / 31218 : ℚ)) * X ^ 15 + C ((1949239915 / 31218 : ℚ)) * X ^ 16 + C ((264831233 / 5203 : ℚ)) * X ^ 17 + C ((94472412 / 5203 : ℚ)) * X ^ 18
theorem VP1_pre_eq :
    VA_0_0_re * VP1_Fre - VA_0_0_im * VP1_Fim = VP1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP1_Fre, VP1_Fim, VP1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP1_pim_eq :
    VA_0_0_re * VP1_Fim + VA_0_0_im * VP1_Fre = VP1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP1_Fre, VP1_Fim, VP1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP1_mul : VA_0_0 * VP1_F = ofLadj VP1_pre VP1_pim := by
  rw [VA_0_0, VP1_F, ofLadj_mul, VP1_pre_eq, VP1_pim_eq]

def VP2_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def VP2_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def VP2_F : Ki := ofLadj VP2_Fre VP2_Fim
def VP2_pre : Polynomial ℚ := C ((-62673378 / 5203 : ℚ)) + C ((-445315536 / 5203 : ℚ)) * X + C ((-840064284 / 5203 : ℚ)) * X ^ 2 + C ((-7934549585 / 31218 : ℚ)) * X ^ 3 + C ((-1881513064 / 5203 : ℚ)) * X ^ 4 + C ((-12940173275 / 31218 : ℚ)) * X ^ 5 + C ((-14169603127 / 31218 : ℚ)) * X ^ 6 + C ((-14738230783 / 31218 : ℚ)) * X ^ 7 + C ((-620411141 / 1419 : ℚ)) * X ^ 8 + C ((-6721113662 / 15609 : ℚ)) * X ^ 9 + C ((-13284067565 / 31218 : ℚ)) * X ^ 10 + C ((-6424361561 / 15609 : ℚ)) * X ^ 11 + C ((-10612174349 / 31218 : ℚ)) * X ^ 12 + C ((-4200920810 / 15609 : ℚ)) * X ^ 13 + C ((-1904831839 / 10406 : ℚ)) * X ^ 14 + C ((-2550102427 / 31218 : ℚ)) * X ^ 15 + C ((-506216164 / 15609 : ℚ)) * X ^ 16 + C ((36166254 / 5203 : ℚ)) * X ^ 17 + C ((149841662 / 5203 : ℚ)) * X ^ 18
def VP2_pim : Polynomial ℚ := C ((18130030 / 473 : ℚ)) + C ((36260060 / 473 : ℚ)) * X + C ((34586130 / 473 : ℚ)) * X ^ 2 + C ((756602005 / 10406 : ℚ)) * X ^ 3 + C ((101614439 / 5203 : ℚ)) * X ^ 4 + C ((-651115581 / 10406 : ℚ)) * X ^ 5 + C ((-3920555587 / 31218 : ℚ)) * X ^ 6 + C ((-2142933085 / 10406 : ℚ)) * X ^ 7 + C ((-1302528158 / 5203 : ℚ)) * X ^ 8 + C ((-3892728913 / 15609 : ℚ)) * X ^ 9 + C ((-7648791889 / 31218 : ℚ)) * X ^ 10 + C ((-4322224946 / 15609 : ℚ)) * X ^ 11 + C ((-876373445 / 2838 : ℚ)) * X ^ 12 + C ((-1565493763 / 5203 : ℚ)) * X ^ 13 + C ((-9350372891 / 31218 : ℚ)) * X ^ 14 + C ((-7776959975 / 31218 : ℚ)) * X ^ 15 + C ((-244985558 / 1419 : ℚ)) * X ^ 16 + C ((-1816075609 / 15609 : ℚ)) * X ^ 17 + C ((-216610538 / 5203 : ℚ)) * X ^ 18
theorem VP2_pre_eq :
    VA_0_0_re * VP2_Fre - VA_0_0_im * VP2_Fim = VP2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP2_Fre, VP2_Fim, VP2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP2_pim_eq :
    VA_0_0_re * VP2_Fim + VA_0_0_im * VP2_Fre = VP2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP2_Fre, VP2_Fim, VP2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP2_mul : VA_0_0 * VP2_F = ofLadj VP2_pre VP2_pim := by
  rw [VA_0_0, VP2_F, ofLadj_mul, VP2_pre_eq, VP2_pim_eq]

def VP3_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def VP3_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def VP3_F : Ki := ofLadj VP3_Fre VP3_Fim
def VP3_pre : Polynomial ℚ := C ((651919 / 10406 : ℚ)) + C ((139161105 / 5203 : ℚ)) * X + C ((263854441 / 5203 : ℚ)) * X ^ 2 + C ((124029034 / 1419 : ℚ)) * X ^ 3 + C ((1482857889 / 10406 : ℚ)) * X ^ 4 + C ((956751242 / 5203 : ℚ)) * X ^ 5 + C ((1166670323 / 5203 : ℚ)) * X ^ 6 + C ((4007012263 / 15609 : ℚ)) * X ^ 7 + C ((8146333145 / 31218 : ℚ)) * X ^ 8 + C ((2810588765 / 10406 : ℚ)) * X ^ 9 + C ((4323987451 / 15609 : ℚ)) * X ^ 10 + C ((8727000701 / 31218 : ℚ)) * X ^ 11 + C ((3906504136 / 15609 : ℚ)) * X ^ 12 + C ((2282879883 / 10406 : ℚ)) * X ^ 13 + C ((5417694397 / 31218 : ℚ)) * X ^ 14 + C ((3436552637 / 31218 : ℚ)) * X ^ 15 + C ((994926413 / 15609 : ℚ)) * X ^ 16 + C ((365169170 / 15609 : ℚ)) * X ^ 17 + C ((-21483037 / 5203 : ℚ)) * X ^ 18
def VP3_pim : Polynomial ℚ := C ((-128423503 / 5203 : ℚ)) + C ((-256847006 / 5203 : ℚ)) * X + C ((-347679236 / 5203 : ℚ)) * X ^ 2 + C ((-1463286905 / 15609 : ℚ)) * X ^ 3 + C ((-278291879 / 2838 : ℚ)) * X ^ 4 + C ((-2722733071 / 31218 : ℚ)) * X ^ 5 + C ((-2386957777 / 31218 : ℚ)) * X ^ 6 + C ((-236169606 / 5203 : ℚ)) * X ^ 7 + C ((-32931394 / 1419 : ℚ)) * X ^ 8 + C ((-113822585 / 5203 : ℚ)) * X ^ 9 + C ((-494453099 / 31218 : ℚ)) * X ^ 10 + C ((551351519 / 31218 : ℚ)) * X ^ 11 + C ((532385379 / 10406 : ℚ)) * X ^ 12 + C ((1165315964 / 15609 : ℚ)) * X ^ 13 + C ((535447580 / 5203 : ℚ)) * X ^ 14 + C ((3226807127 / 31218 : ℚ)) * X ^ 15 + C ((1323560009 / 15609 : ℚ)) * X ^ 16 + C ((1012095916 / 15609 : ℚ)) * X ^ 17 + C ((135507030 / 5203 : ℚ)) * X ^ 18
theorem VP3_pre_eq :
    VA_0_0_re * VP3_Fre - VA_0_0_im * VP3_Fim = VP3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP3_Fre, VP3_Fim, VP3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP3_pim_eq :
    VA_0_0_re * VP3_Fim + VA_0_0_im * VP3_Fre = VP3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP3_Fre, VP3_Fim, VP3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP3_mul : VA_0_0 * VP3_F = ofLadj VP3_pre VP3_pim := by
  rw [VA_0_0, VP3_F, ofLadj_mul, VP3_pre_eq, VP3_pim_eq]

def VP4_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP4_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP4_F : Ki := ofLadj VP4_Fre VP4_Fim
def VP4_pre : Polynomial ℚ := C ((41850093 / 5203 : ℚ)) + C ((556644420 / 5203 : ℚ)) * X + C ((1133499425 / 5203 : ℚ)) * X ^ 2 + C ((5593659881 / 15609 : ℚ)) * X ^ 3 + C ((2774260022 / 5203 : ℚ)) * X ^ 4 + C ((3296835943 / 5203 : ℚ)) * X ^ 5 + C ((11155244990 / 15609 : ℚ)) * X ^ 6 + C ((3949439235 / 5203 : ℚ)) * X ^ 7 + C ((3761917455 / 5203 : ℚ)) * X ^ 8 + C ((3690913090 / 5203 : ℚ)) * X ^ 9 + C ((3636505832 / 5203 : ℚ)) * X ^ 10 + C ((3574323059 / 5203 : ℚ)) * X ^ 11 + C ((71624684 / 121 : ℚ)) * X ^ 12 + C ((2557413665 / 5203 : ℚ)) * X ^ 13 + C ((5692092484 / 15609 : ℚ)) * X ^ 14 + C ((1053003265 / 5203 : ℚ)) * X ^ 15 + C ((569414139 / 5203 : ℚ)) * X ^ 16 + C ((443505256 / 15609 : ℚ)) * X ^ 17 + C ((-122175948 / 5203 : ℚ)) * X ^ 18
def VP4_pim : Polynomial ℚ := C ((-374532907 / 5203 : ℚ)) + C ((-749065814 / 5203 : ℚ)) * X + C ((-890509523 / 5203 : ℚ)) * X ^ 2 + C ((-1047503701 / 5203 : ℚ)) * X ^ 3 + C ((-786802858 / 5203 : ℚ)) * X ^ 4 + C ((-819441428 / 15609 : ℚ)) * X ^ 5 + C ((37995851 / 1419 : ℚ)) * X ^ 6 + C ((2237553535 / 15609 : ℚ)) * X ^ 7 + C ((3279980335 / 15609 : ℚ)) * X ^ 8 + C ((3249508595 / 15609 : ℚ)) * X ^ 9 + C ((3108625532 / 15609 : ℚ)) * X ^ 10 + C ((4025086243 / 15609 : ℚ)) * X ^ 11 + C ((1647182318 / 5203 : ℚ)) * X ^ 12 + C ((1741665006 / 5203 : ℚ)) * X ^ 13 + C ((5665505812 / 15609 : ℚ)) * X ^ 14 + C ((4972527877 / 15609 : ℚ)) * X ^ 15 + C ((3612951521 / 15609 : ℚ)) * X ^ 16 + C ((2591510590 / 15609 : ℚ)) * X ^ 17 + C ((317767402 / 5203 : ℚ)) * X ^ 18
theorem VP4_pre_eq :
    VA_0_0_re * VP4_Fre - VA_0_0_im * VP4_Fim = VP4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP4_Fre, VP4_Fim, VP4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP4_pim_eq :
    VA_0_0_re * VP4_Fim + VA_0_0_im * VP4_Fre = VP4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP4_Fre, VP4_Fim, VP4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP4_mul : VA_0_0 * VP4_F = ofLadj VP4_pre VP4_pim := by
  rw [VA_0_0, VP4_F, ofLadj_mul, VP4_pre_eq, VP4_pim_eq]

def VP5_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def VP5_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def VP5_F : Ki := ofLadj VP5_Fre VP5_Fim
def VP5_pre : Polynomial ℚ := C ((48859029 / 10406 : ℚ)) + C ((389651094 / 5203 : ℚ)) * X + C ((778675539 / 5203 : ℚ)) * X ^ 2 + C ((3796960892 / 15609 : ℚ)) * X ^ 3 + C ((1921770176 / 5203 : ℚ)) * X ^ 4 + C ((13938513101 / 31218 : ℚ)) * X ^ 5 + C ((16140471475 / 31218 : ℚ)) * X ^ 6 + C ((800170375 / 1419 : ℚ)) * X ^ 7 + C ((17304922483 / 31218 : ℚ)) * X ^ 8 + C ((8768720908 / 15609 : ℚ)) * X ^ 9 + C ((8857434703 / 15609 : ℚ)) * X ^ 10 + C ((8817015604 / 15609 : ℚ)) * X ^ 11 + C ((7688481421 / 15609 : ℚ)) * X ^ 12 + C ((6432694291 / 15609 : ℚ)) * X ^ 13 + C ((3237000233 / 10406 : ℚ)) * X ^ 14 + C ((2780272478 / 15609 : ℚ)) * X ^ 15 + C ((1008695143 / 10406 : ℚ)) * X ^ 16 + C ((824127055 / 31218 : ℚ)) * X ^ 17 + C ((-85430373 / 5203 : ℚ)) * X ^ 18
def VP5_pim : Polynomial ℚ := C ((-557744735 / 10406 : ℚ)) + C ((-557744735 / 5203 : ℚ)) * X + C ((-681203062 / 5203 : ℚ)) * X ^ 2 + C ((-1699765283 / 10406 : ℚ)) * X ^ 3 + C ((-1474624453 / 10406 : ℚ)) * X ^ 4 + C ((-886977447 / 10406 : ℚ)) * X ^ 5 + C ((-1291917943 / 31218 : ℚ)) * X ^ 6 + C ((195840457 / 5203 : ℚ)) * X ^ 7 + C ((1298739238 / 15609 : ℚ)) * X ^ 8 + C ((1315455157 / 15609 : ℚ)) * X ^ 9 + C ((1392488905 / 15609 : ℚ)) * X ^ 10 + C ((2341629391 / 15609 : ℚ)) * X ^ 11 + C ((3290769877 / 15609 : ℚ)) * X ^ 12 + C ((3738178606 / 15609 : ℚ)) * X ^ 13 + C ((8521866527 / 31218 : ℚ)) * X ^ 14 + C ((7748743093 / 31218 : ℚ)) * X ^ 15 + C ((526192037 / 2838 : ℚ)) * X ^ 16 + C ((4184787031 / 31218 : ℚ)) * X ^ 17 + C ((253356113 / 5203 : ℚ)) * X ^ 18
theorem VP5_pre_eq :
    VA_0_0_re * VP5_Fre - VA_0_0_im * VP5_Fim = VP5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP5_Fre, VP5_Fim, VP5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP5_pim_eq :
    VA_0_0_re * VP5_Fim + VA_0_0_im * VP5_Fre = VP5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_0_re, VA_0_0_im, VP5_Fre, VP5_Fim, VP5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP5_mul : VA_0_0 * VP5_F = ofLadj VP5_pre VP5_pim := by
  rw [VA_0_0, VP5_F, ofLadj_mul, VP5_pre_eq, VP5_pim_eq]

def VP6_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def VP6_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def VP6_F : Ki := ofLadj VP6_Fre VP6_Fim
def VP6_pre : Polynomial ℚ := C ((23570718 / 5203 : ℚ)) + C ((-41733671 / 10406 : ℚ)) * X ^ 2 + C ((-119592651 / 10406 : ℚ)) * X ^ 3 + C ((-16696795 / 473 : ℚ)) * X ^ 4 + C ((-308339452 / 5203 : ℚ)) * X ^ 5 + C ((-873476491 / 10406 : ℚ)) * X ^ 6 + C ((-2164091467 / 20812 : ℚ)) * X ^ 7 + C ((-1160877015 / 10406 : ℚ)) * X ^ 8 + C ((-2389187557 / 20812 : ℚ)) * X ^ 9 + C ((-110937565 / 946 : ℚ)) * X ^ 10 + C ((-638518658 / 5203 : ℚ)) * X ^ 11 + C ((-110937565 / 946 : ℚ)) * X ^ 12 + C ((-2305720215 / 20812 : ℚ)) * X ^ 13 + C ((-520642182 / 5203 : ℚ)) * X ^ 14 + C ((-1525157173 / 20812 : ℚ)) * X ^ 15 + C ((-494826945 / 10406 : ℚ)) * X ^ 16 + C ((-119014679 / 5203 : ℚ)) * X ^ 17 + C ((-47862343 / 10406 : ℚ)) * X ^ 18
def VP6_pim : Polynomial ℚ := C ((80473890 / 5203 : ℚ)) + C ((160947780 / 5203 : ℚ)) * X + C ((523514349 / 10406 : ℚ)) * X ^ 2 + C ((796680779 / 10406 : ℚ)) * X ^ 3 + C ((965534985 / 10406 : ℚ)) * X ^ 4 + C ((523180103 / 5203 : ℚ)) * X ^ 5 + C ((1067894373 / 10406 : ℚ)) * X ^ 6 + C ((1824741075 / 20812 : ℚ)) * X ^ 7 + C ((810916871 / 10406 : ℚ)) * X ^ 8 + C ((146553999 / 1892 : ℚ)) * X ^ 9 + C ((391876274 / 5203 : ℚ)) * X ^ 10 + C ((26824630 / 473 : ℚ)) * X ^ 11 + C ((198265586 / 5203 : ℚ)) * X ^ 12 + C ((345235873 / 20812 : ℚ)) * X ^ 13 + C ((-1225795 / 121 : ℚ)) * X ^ 14 + C ((-520200007 / 20812 : ℚ)) * X ^ 15 + C ((-156148536 / 5203 : ℚ)) * X ^ 16 + C ((-299778227 / 10406 : ℚ)) * X ^ 17 + C ((-115626239 / 10406 : ℚ)) * X ^ 18
theorem VP6_pre_eq :
    VA_1_0_re * VP6_Fre - VA_1_0_im * VP6_Fim = VP6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP6_Fre, VP6_Fim, VP6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP6_pim_eq :
    VA_1_0_re * VP6_Fim + VA_1_0_im * VP6_Fre = VP6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP6_Fre, VP6_Fim, VP6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP6_mul : VA_1_0 * VP6_F = ofLadj VP6_pre VP6_pim := by
  rw [VA_1_0, VP6_F, ofLadj_mul, VP6_pre_eq, VP6_pim_eq]

def VP7_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def VP7_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def VP7_F : Ki := ofLadj VP7_Fre VP7_Fim
def VP7_pre : Polynomial ℚ := C ((20916 / 121 : ℚ)) + C ((-429194080 / 15609 : ℚ)) * X + C ((-858598513 / 15609 : ℚ)) * X ^ 2 + C ((-1399806013 / 15609 : ℚ)) * X ^ 3 + C ((-788527868 / 5203 : ℚ)) * X ^ 4 + C ((-3028354997 / 15609 : ℚ)) * X ^ 5 + C ((-110685090 / 473 : ℚ)) * X ^ 6 + C ((-1308049596 / 5203 : ℚ)) * X ^ 7 + C ((-1217471368 / 5203 : ℚ)) * X ^ 8 + C ((-3457995311 / 15609 : ℚ)) * X ^ 9 + C ((-3309804019 / 15609 : ℚ)) * X ^ 10 + C ((-3257115934 / 15609 : ℚ)) * X ^ 11 + C ((-960203313 / 5203 : ℚ)) * X ^ 12 + C ((-2599396798 / 15609 : ℚ)) * X ^ 13 + C ((-2252608091 / 15609 : ℚ)) * X ^ 14 + C ((-488435859 / 5203 : ℚ)) * X ^ 15 + C ((-302874234 / 5203 : ℚ)) * X ^ 16 + C ((-284369729 / 15609 : ℚ)) * X ^ 17 + C ((31085869 / 5203 : ℚ)) * X ^ 18
def VP7_pim : Polynomial ℚ := C ((406972444 / 15609 : ℚ)) + C ((813944888 / 15609 : ℚ)) * X + C ((1052815615 / 15609 : ℚ)) * X ^ 2 + C ((1443741677 / 15609 : ℚ)) * X ^ 3 + C ((483917153 / 5203 : ℚ)) * X ^ 4 + C ((1066358110 / 15609 : ℚ)) * X ^ 5 + C ((212951806 / 5203 : ℚ)) * X ^ 6 + C ((-181449682 / 15609 : ℚ)) * X ^ 7 + C ((-208925616 / 5203 : ℚ)) * X ^ 8 + C ((-199588304 / 5203 : ℚ)) * X ^ 9 + C ((-470229772 / 15609 : ℚ)) * X ^ 10 + C ((-688899868 / 15609 : ℚ)) * X ^ 11 + C ((-907569964 / 15609 : ℚ)) * X ^ 12 + C ((-1017905551 / 15609 : ℚ)) * X ^ 13 + C ((-1380819677 / 15609 : ℚ)) * X ^ 14 + C ((-1470501434 / 15609 : ℚ)) * X ^ 15 + C ((-1250129405 / 15609 : ℚ)) * X ^ 16 + C ((-1018938971 / 15609 : ℚ)) * X ^ 17 + C ((-121218397 / 5203 : ℚ)) * X ^ 18
theorem VP7_pre_eq :
    VA_1_0_re * VP7_Fre - VA_1_0_im * VP7_Fim = VP7_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP7_Fre, VP7_Fim, VP7_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP7_pim_eq :
    VA_1_0_re * VP7_Fim + VA_1_0_im * VP7_Fre = VP7_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP7_Fre, VP7_Fim, VP7_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP7_mul : VA_1_0 * VP7_F = ofLadj VP7_pre VP7_pim := by
  rw [VA_1_0, VP7_F, ofLadj_mul, VP7_pre_eq, VP7_pim_eq]

def VP8_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def VP8_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def VP8_F : Ki := ofLadj VP8_Fre VP8_Fim
def VP8_pre : Polynomial ℚ := C ((240628336 / 15609 : ℚ)) + C ((1716776320 / 15609 : ℚ)) * X + C ((8917644 / 43 : ℚ)) * X ^ 2 + C ((5092715512 / 15609 : ℚ)) * X ^ 3 + C ((2416264936 / 5203 : ℚ)) * X ^ 4 + C ((8308910549 / 15609 : ℚ)) * X ^ 5 + C ((3032362121 / 5203 : ℚ)) * X ^ 6 + C ((9462447487 / 15609 : ℚ)) * X ^ 7 + C ((8764681579 / 15609 : ℚ)) * X ^ 8 + C ((8631837842 / 15609 : ℚ)) * X ^ 9 + C ((8530331978 / 15609 : ℚ)) * X ^ 10 + C ((2750607980 / 5203 : ℚ)) * X ^ 11 + C ((6813555658 / 15609 : ℚ)) * X ^ 12 + C ((5394733070 / 15609 : ℚ)) * X ^ 13 + C ((10115609 / 43 : ℚ)) * X ^ 14 + C ((1637988563 / 15609 : ℚ)) * X ^ 15 + C ((216847317 / 5203 : ℚ)) * X ^ 16 + C ((-137633863 / 15609 : ℚ)) * X ^ 17 + C ((-575664116 / 15609 : ℚ)) * X ^ 18
def VP8_pim : Polynomial ℚ := C ((-769501616 / 15609 : ℚ)) + C ((-1539003232 / 15609 : ℚ)) * X + C ((-1465427980 / 15609 : ℚ)) * X ^ 2 + C ((-1459708144 / 15609 : ℚ)) * X ^ 3 + C ((-395458496 / 15609 : ℚ)) * X ^ 4 + C ((1251246335 / 15609 : ℚ)) * X ^ 5 + C ((2513360387 / 15609 : ℚ)) * X ^ 6 + C ((4121730290 / 15609 : ℚ)) * X ^ 7 + C ((5011700042 / 15609 : ℚ)) * X ^ 8 + C ((38702174 / 121 : ℚ)) * X ^ 9 + C ((4904741365 / 15609 : ℚ)) * X ^ 10 + C ((1848453664 / 5203 : ℚ)) * X ^ 11 + C ((6185980619 / 15609 : ℚ)) * X ^ 12 + C ((2008188762 / 5203 : ℚ)) * X ^ 13 + C ((545429714 / 1419 : ℚ)) * X ^ 14 + C ((4991227574 / 15609 : ℚ)) * X ^ 15 + C ((3457422245 / 15609 : ℚ)) * X ^ 16 + C ((2329689785 / 15609 : ℚ)) * X ^ 17 + C ((278073128 / 5203 : ℚ)) * X ^ 18
theorem VP8_pre_eq :
    VA_1_0_re * VP8_Fre - VA_1_0_im * VP8_Fim = VP8_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP8_Fre, VP8_Fim, VP8_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP8_pim_eq :
    VA_1_0_re * VP8_Fim + VA_1_0_im * VP8_Fre = VP8_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP8_Fre, VP8_Fim, VP8_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP8_mul : VA_1_0 * VP8_F = ofLadj VP8_pre VP8_pim := by
  rw [VA_1_0, VP8_F, ofLadj_mul, VP8_pre_eq, VP8_pim_eq]

def VP9_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def VP9_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def VP9_F : Ki := ofLadj VP9_Fre VP9_Fim
def VP9_pre : Polynomial ℚ := C ((-555748 / 15609 : ℚ)) + C ((-536492600 / 15609 : ℚ)) * X + C ((-338737900 / 5203 : ℚ)) * X ^ 2 + C ((-583512832 / 5203 : ℚ)) * X ^ 3 + C ((-1903896383 / 10406 : ℚ)) * X ^ 4 + C ((-7370354557 / 31218 : ℚ)) * X ^ 5 + C ((-8985689243 / 31218 : ℚ)) * X ^ 6 + C ((-3429246829 / 10406 : ℚ)) * X ^ 7 + C ((-10459027951 / 31218 : ℚ)) * X ^ 8 + C ((-10824539969 / 31218 : ℚ)) * X ^ 9 + C ((-11102869717 / 31218 : ℚ)) * X ^ 10 + C ((-1867610796 / 5203 : ℚ)) * X ^ 11 + C ((-3343294839 / 10406 : ℚ)) * X ^ 12 + C ((-8792112569 / 31218 : ℚ)) * X ^ 13 + C ((-161812813 / 726 : ℚ)) * X ^ 14 + C ((-2205952378 / 15609 : ℚ)) * X ^ 15 + C ((-1277037548 / 15609 : ℚ)) * X ^ 16 + C ((-156456735 / 5203 : ℚ)) * X ^ 17 + C ((82073291 / 15609 : ℚ)) * X ^ 18
def VP9_pim : Polynomial ℚ := C ((3839560 / 121 : ℚ)) + C ((7679120 / 121 : ℚ)) * X + C ((446410017 / 5203 : ℚ)) * X ^ 2 + C ((1880220775 / 15609 : ℚ)) * X ^ 3 + C ((3934474639 / 31218 : ℚ)) * X ^ 4 + C ((1166243905 / 10406 : ℚ)) * X ^ 5 + C ((1022665533 / 10406 : ℚ)) * X ^ 6 + C ((1825235419 / 31218 : ℚ)) * X ^ 7 + C ((935846887 / 31218 : ℚ)) * X ^ 8 + C ((883051097 / 31218 : ℚ)) * X ^ 9 + C ((641386519 / 31218 : ℚ)) * X ^ 10 + C ((-351456865 / 15609 : ℚ)) * X ^ 11 + C ((-2047213979 / 31218 : ℚ)) * X ^ 12 + C ((-995375233 / 10406 : ℚ)) * X ^ 13 + C ((-4120902937 / 31218 : ℚ)) * X ^ 14 + C ((-2070610664 / 15609 : ℚ)) * X ^ 15 + C ((-51445750 / 473 : ℚ)) * X ^ 16 + C ((-1297961657 / 15609 : ℚ)) * X ^ 17 + C ((-521551615 / 15609 : ℚ)) * X ^ 18
theorem VP9_pre_eq :
    VA_1_0_re * VP9_Fre - VA_1_0_im * VP9_Fim = VP9_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP9_Fre, VP9_Fim, VP9_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP9_pim_eq :
    VA_1_0_re * VP9_Fim + VA_1_0_im * VP9_Fre = VP9_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP9_Fre, VP9_Fim, VP9_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP9_mul : VA_1_0 * VP9_F = ofLadj VP9_pre VP9_pim := by
  rw [VA_1_0, VP9_F, ofLadj_mul, VP9_pre_eq, VP9_pim_eq]

def VP10_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP10_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP10_F : Ki := ofLadj VP10_Fre VP10_Fim
def VP10_pre : Polynomial ℚ := C ((-159361112 / 15609 : ℚ)) + C ((-2145970400 / 15609 : ℚ)) * X + C ((-1455737098 / 5203 : ℚ)) * X ^ 2 + C ((-166970666 / 363 : ℚ)) * X ^ 3 + C ((-3562318054 / 5203 : ℚ)) * X ^ 4 + C ((-1154560574 / 1419 : ℚ)) * X ^ 5 + C ((-14322064186 / 15609 : ℚ)) * X ^ 6 + C ((-5070761282 / 5203 : ℚ)) * X ^ 7 + C ((-14491780990 / 15609 : ℚ)) * X ^ 8 + C ((-4739322485 / 5203 : ℚ)) * X ^ 9 + C ((-14008668500 / 15609 : ℚ)) * X ^ 10 + C ((-13771202582 / 15609 : ℚ)) * X ^ 11 + C ((-8359900 / 11 : ℚ)) * X ^ 12 + C ((-3283585387 / 5203 : ℚ)) * X ^ 13 + C ((-7312042352 / 15609 : ℚ)) * X ^ 14 + C ((-4056574570 / 15609 : ℚ)) * X ^ 15 + C ((-66460168 / 473 : ℚ)) * X ^ 16 + C ((-190429224 / 5203 : ℚ)) * X ^ 17 + C ((468755114 / 15609 : ℚ)) * X ^ 18
def VP10_pim : Polynomial ℚ := C ((1444720360 / 15609 : ℚ)) + C ((2889440720 / 15609 : ℚ)) * X + C ((9450418 / 43 : ℚ)) * X ^ 2 + C ((4038690466 / 15609 : ℚ)) * X ^ 3 + C ((3036871004 / 15609 : ℚ)) * X ^ 4 + C ((1056717868 / 15609 : ℚ)) * X ^ 5 + C ((-531132794 / 15609 : ℚ)) * X ^ 6 + C ((-2864531866 / 15609 : ℚ)) * X ^ 7 + C ((-4202685076 / 15609 : ℚ)) * X ^ 8 + C ((-4163389609 / 15609 : ℚ)) * X ^ 9 + C ((-3982252528 / 15609 : ℚ)) * X ^ 10 + C ((-1720425220 / 5203 : ℚ)) * X ^ 11 + C ((-6340298792 / 15609 : ℚ)) * X ^ 12 + C ((-2233407575 / 5203 : ℚ)) * X ^ 13 + C ((-7269115990 / 15609 : ℚ)) * X ^ 14 + C ((-2127360484 / 5203 : ℚ)) * X ^ 15 + C ((-4634800510 / 15609 : ℚ)) * X ^ 16 + C ((-3323895164 / 15609 : ℚ)) * X ^ 17 + C ((-1223368286 / 15609 : ℚ)) * X ^ 18
theorem VP10_pre_eq :
    VA_1_0_re * VP10_Fre - VA_1_0_im * VP10_Fim = VP10_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP10_Fre, VP10_Fim, VP10_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP10_pim_eq :
    VA_1_0_re * VP10_Fim + VA_1_0_im * VP10_Fre = VP10_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP10_Fre, VP10_Fim, VP10_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP10_mul : VA_1_0 * VP10_F = ofLadj VP10_pre VP10_pim := by
  rw [VA_1_0, VP10_F, ofLadj_mul, VP10_pre_eq, VP10_pim_eq]

def VP11_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def VP11_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def VP11_F : Ki := ofLadj VP11_Fre VP11_Fim
def VP11_pre : Polynomial ℚ := C ((-92696204 / 15609 : ℚ)) + C ((-1502179280 / 15609 : ℚ)) * X + C ((-2999933975 / 15609 : ℚ)) * X ^ 2 + C ((-4873040831 / 15609 : ℚ)) * X ^ 3 + C ((-224326940 / 473 : ℚ)) * X ^ 4 + C ((-2982946594 / 5203 : ℚ)) * X ^ 5 + C ((-313962131 / 473 : ℚ)) * X ^ 6 + C ((-7533549361 / 10406 : ℚ)) * X ^ 7 + C ((-11109818299 / 15609 : ℚ)) * X ^ 8 + C ((-11259005918 / 15609 : ℚ)) * X ^ 9 + C ((-11372905144 / 15609 : ℚ)) * X ^ 10 + C ((-11322561463 / 15609 : ℚ)) * X ^ 11 + C ((-9870725864 / 15609 : ℚ)) * X ^ 12 + C ((-2753023981 / 5203 : ℚ)) * X ^ 13 + C ((-6236777468 / 15609 : ℚ)) * X ^ 14 + C ((-7139799715 / 31218 : ℚ)) * X ^ 15 + C ((-1942450000 / 15609 : ℚ)) * X ^ 16 + C ((-530539459 / 15609 : ℚ)) * X ^ 17 + C ((327635164 / 15609 : ℚ)) * X ^ 18
def VP11_pim : Polynomial ℚ := C ((1075683364 / 15609 : ℚ)) + C ((2151366728 / 15609 : ℚ)) * X + C ((874696645 / 5203 : ℚ)) * X ^ 2 + C ((1092155403 / 5203 : ℚ)) * X ^ 3 + C ((258614833 / 1419 : ℚ)) * X ^ 4 + C ((13267846 / 121 : ℚ)) * X ^ 5 + C ((6460306 / 121 : ℚ)) * X ^ 6 + C ((-498770235 / 10406 : ℚ)) * X ^ 7 + C ((-553614912 / 5203 : ℚ)) * X ^ 8 + C ((-560769326 / 5203 : ℚ)) * X ^ 9 + C ((-1781057945 / 15609 : ℚ)) * X ^ 10 + C ((-1000430466 / 5203 : ℚ)) * X ^ 11 + C ((-4221524851 / 15609 : ℚ)) * X ^ 12 + C ((-4792998025 / 15609 : ℚ)) * X ^ 13 + C ((-496985231 / 1419 : ℚ)) * X ^ 14 + C ((-904088099 / 2838 : ℚ)) * X ^ 15 + C ((-1237488348 / 5203 : ℚ)) * X ^ 16 + C ((-62411224 / 363 : ℚ)) * X ^ 17 + C ((-975339334 / 15609 : ℚ)) * X ^ 18
theorem VP11_pre_eq :
    VA_1_0_re * VP11_Fre - VA_1_0_im * VP11_Fim = VP11_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP11_Fre, VP11_Fim, VP11_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP11_pim_eq :
    VA_1_0_re * VP11_Fim + VA_1_0_im * VP11_Fre = VP11_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_0_re, VA_1_0_im, VP11_Fre, VP11_Fim, VP11_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP11_mul : VA_1_0 * VP11_F = ofLadj VP11_pre VP11_pim := by
  rw [VA_1_0, VP11_F, ofLadj_mul, VP11_pre_eq, VP11_pim_eq]

def VP12_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def VP12_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def VP12_F : Ki := ofLadj VP12_Fre VP12_Fim
def VP12_pre : Polynomial ℚ := C ((260598 / 473 : ℚ)) + C ((-4925771 / 10406 : ℚ)) * X ^ 2 + C ((-13937571 / 10406 : ℚ)) * X ^ 3 + C ((-43606729 / 10406 : ℚ)) * X ^ 4 + C ((-6671723 / 946 : ℚ)) * X ^ 5 + C ((-103703931 / 10406 : ℚ)) * X ^ 6 + C ((-128555047 / 10406 : ℚ)) * X ^ 7 + C ((-69013596 / 5203 : ℚ)) * X ^ 8 + C ((-71011682 / 5203 : ℚ)) * X ^ 9 + C ((-145095695 / 10406 : ℚ)) * X ^ 10 + C ((-6908282 / 473 : ℚ)) * X ^ 11 + C ((-145095695 / 10406 : ℚ)) * X ^ 12 + C ((-137097593 / 10406 : ℚ)) * X ^ 13 + C ((-124089621 / 10406 : ℚ)) * X ^ 14 + C ((-90746761 / 10406 : ℚ)) * X ^ 15 + C ((-29375545 / 5203 : ℚ)) * X ^ 16 + C ((-14218056 / 5203 : ℚ)) * X ^ 17 + C ((-5798443 / 10406 : ℚ)) * X ^ 18
def VP12_pim : Polynomial ℚ := C ((9636951 / 5203 : ℚ)) + C ((19273902 / 5203 : ℚ)) * X + C ((62435709 / 10406 : ℚ)) * X ^ 2 + C ((95054063 / 10406 : ℚ)) * X ^ 3 + C ((115358491 / 10406 : ℚ)) * X ^ 4 + C ((62391436 / 5203 : ℚ)) * X ^ 5 + C ((63677886 / 5203 : ℚ)) * X ^ 6 + C ((109072005 / 10406 : ℚ)) * X ^ 7 + C ((48527596 / 5203 : ℚ)) * X ^ 8 + C ((48239558 / 5203 : ℚ)) * X ^ 9 + C ((46921870 / 5203 : ℚ)) * X ^ 10 + C ((3212317 / 473 : ℚ)) * X ^ 11 + C ((23749104 / 5203 : ℚ)) * X ^ 12 + C ((487789 / 242 : ℚ)) * X ^ 13 + C ((-12219503 / 10406 : ℚ)) * X ^ 14 + C ((-30850115 / 10406 : ℚ)) * X ^ 15 + C ((-36868695 / 10406 : ℚ)) * X ^ 16 + C ((-35380197 / 10406 : ℚ)) * X ^ 17 + C ((-13690629 / 10406 : ℚ)) * X ^ 18
theorem VP12_pre_eq :
    VA_0_1_re * VP12_Fre - VA_0_1_im * VP12_Fim = VP12_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP12_Fre, VP12_Fim, VP12_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP12_pim_eq :
    VA_0_1_re * VP12_Fim + VA_0_1_im * VP12_Fre = VP12_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP12_Fre, VP12_Fim, VP12_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP12_mul : VA_0_1 * VP12_F = ofLadj VP12_pre VP12_pim := by
  rw [VA_0_1, VP12_F, ofLadj_mul, VP12_pre_eq, VP12_pim_eq]

def VP13_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def VP13_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def VP13_F : Ki := ofLadj VP13_Fre VP13_Fim
def VP13_pre : Polynomial ℚ := C ((176032 / 5203 : ℚ)) + C ((-51397072 / 15609 : ℚ)) * X + C ((-847511 / 129 : ℚ)) * X ^ 2 + C ((-166173472 / 15609 : ℚ)) * X ^ 3 + C ((-281868652 / 15609 : ℚ)) * X ^ 4 + C ((-361250128 / 15609 : ℚ)) * X ^ 5 + C ((-13172978 / 473 : ℚ)) * X ^ 6 + C ((-467194696 / 15609 : ℚ)) * X ^ 7 + C ((-435254294 / 15609 : ℚ)) * X ^ 8 + C ((-412188394 / 15609 : ℚ)) * X ^ 9 + C ((-394523417 / 15609 : ℚ)) * X ^ 10 + C ((-388395556 / 15609 : ℚ)) * X ^ 11 + C ((-343126345 / 15609 : ℚ)) * X ^ 12 + C ((-309639563 / 15609 : ℚ)) * X ^ 13 + C ((-269080822 / 15609 : ℚ)) * X ^ 14 + C ((-58199725 / 5203 : ℚ)) * X ^ 15 + C ((-107917562 / 15609 : ℚ)) * X ^ 16 + C ((-11486472 / 5203 : ℚ)) * X ^ 17 + C ((3575623 / 5203 : ℚ)) * X ^ 18
def VP13_pim : Polynomial ℚ := C ((48794542 / 15609 : ℚ)) + C ((97589084 / 15609 : ℚ)) * X + C ((125497609 / 15609 : ℚ)) * X ^ 2 + C ((172420954 / 15609 : ℚ)) * X ^ 3 + C ((174191632 / 15609 : ℚ)) * X ^ 4 + C ((11587168 / 1419 : ℚ)) * X ^ 5 + C ((76613110 / 15609 : ℚ)) * X ^ 6 + C ((-20236496 / 15609 : ℚ)) * X ^ 7 + C ((-73175612 / 15609 : ℚ)) * X ^ 8 + C ((-69869906 / 15609 : ℚ)) * X ^ 9 + C ((-54644749 / 15609 : ℚ)) * X ^ 10 + C ((-2454068 / 473 : ℚ)) * X ^ 11 + C ((-107323739 / 15609 : ℚ)) * X ^ 12 + C ((-3636579 / 473 : ℚ)) * X ^ 13 + C ((-54541582 / 5203 : ℚ)) * X ^ 14 + C ((-58346611 / 5203 : ℚ)) * X ^ 15 + C ((-147922682 / 15609 : ℚ)) * X ^ 16 + C ((-120528680 / 15609 : ℚ)) * X ^ 17 + C ((-14431569 / 5203 : ℚ)) * X ^ 18
theorem VP13_pre_eq :
    VA_0_1_re * VP13_Fre - VA_0_1_im * VP13_Fim = VP13_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP13_Fre, VP13_Fim, VP13_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP13_pim_eq :
    VA_0_1_re * VP13_Fim + VA_0_1_im * VP13_Fre = VP13_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP13_Fre, VP13_Fim, VP13_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP13_mul : VA_0_1 * VP13_F = ofLadj VP13_pre VP13_pim := by
  rw [VA_0_1, VP13_F, ofLadj_mul, VP13_pre_eq, VP13_pim_eq]

def VP14_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def VP14_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def VP14_F : Ki := ofLadj VP14_Fre VP14_Fim
def VP14_pre : Polynomial ℚ := C ((28464448 / 15609 : ℚ)) + C ((205588288 / 15609 : ℚ)) * X + C ((386933600 / 15609 : ℚ)) * X ^ 2 + C ((606164038 / 15609 : ℚ)) * X ^ 3 + C ((864341980 / 15609 : ℚ)) * X ^ 4 + C ((330526517 / 5203 : ℚ)) * X ^ 5 + C ((1083920776 / 15609 : ℚ)) * X ^ 6 + C ((1128299276 / 15609 : ℚ)) * X ^ 7 + C ((1046170841 / 15609 : ℚ)) * X ^ 8 + C ((1030267619 / 15609 : ℚ)) * X ^ 9 + C ((1018241855 / 15609 : ℚ)) * X ^ 10 + C ((328449624 / 5203 : ℚ)) * X ^ 11 + C ((73877597 / 1419 : ℚ)) * X ^ 12 + C ((214444673 / 5203 : ℚ)) * X ^ 13 + C ((440006803 / 15609 : ℚ)) * X ^ 14 + C ((65458056 / 5203 : ℚ)) * X ^ 15 + C ((7062658 / 1419 : ℚ)) * X ^ 16 + C ((-14651987 / 15609 : ℚ)) * X ^ 17 + C ((-67583128 / 15609 : ℚ)) * X ^ 18
def VP14_pim : Polynomial ℚ := C ((-92384024 / 15609 : ℚ)) + C ((-184768048 / 15609 : ℚ)) * X + C ((-58185704 / 5203 : ℚ)) * X ^ 2 + C ((-174799652 / 15609 : ℚ)) * X ^ 3 + C ((-16626848 / 5203 : ℚ)) * X ^ 4 + C ((147695261 / 15609 : ℚ)) * X ^ 5 + C ((27053392 / 1419 : ℚ)) * X ^ 6 + C ((487356502 / 15609 : ℚ)) * X ^ 7 + C ((197920677 / 5203 : ℚ)) * X ^ 8 + C ((591434425 / 15609 : ℚ)) * X ^ 9 + C ((193633641 / 5203 : ℚ)) * X ^ 10 + C ((658017944 / 15609 : ℚ)) * X ^ 11 + C ((735134965 / 15609 : ℚ)) * X ^ 12 + C ((714390527 / 15609 : ℚ)) * X ^ 13 + C ((712305461 / 15609 : ℚ)) * X ^ 14 + C ((198041234 / 5203 : ℚ)) * X ^ 15 + C ((410000516 / 15609 : ℚ)) * X ^ 16 + C ((91994917 / 5203 : ℚ)) * X ^ 17 + C ((99668180 / 15609 : ℚ)) * X ^ 18
theorem VP14_pre_eq :
    VA_0_1_re * VP14_Fre - VA_0_1_im * VP14_Fim = VP14_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP14_Fre, VP14_Fim, VP14_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP14_pim_eq :
    VA_0_1_re * VP14_Fim + VA_0_1_im * VP14_Fre = VP14_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP14_Fre, VP14_Fim, VP14_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP14_mul : VA_0_1 * VP14_F = ofLadj VP14_pre VP14_pim := by
  rw [VA_0_1, VP14_F, ofLadj_mul, VP14_pre_eq, VP14_pim_eq]

def VP15_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def VP15_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def VP15_F : Ki := ofLadj VP15_Fre VP15_Fim
def VP15_pre : Polynomial ℚ := C ((182357 / 15609 : ℚ)) + C ((-64246340 / 15609 : ℚ)) * X + C ((-40440177 / 5203 : ℚ)) * X ^ 2 + C ((-6298734 / 473 : ℚ)) * X ^ 3 + C ((-113412329 / 5203 : ℚ)) * X ^ 4 + C ((-439353751 / 15609 : ℚ)) * X ^ 5 + C ((-534581548 / 15609 : ℚ)) * X ^ 6 + C ((-204150083 / 5203 : ℚ)) * X ^ 7 + C ((-623088910 / 15609 : ℚ)) * X ^ 8 + C ((-644635763 / 15609 : ℚ)) * X ^ 9 + C ((-661311874 / 15609 : ℚ)) * X ^ 10 + C ((-667854974 / 15609 : ℚ)) * X ^ 11 + C ((-597065534 / 15609 : ℚ)) * X ^ 12 + C ((-47574112 / 1419 : ℚ)) * X ^ 13 + C ((-415230688 / 15609 : ℚ)) * X ^ 14 + C ((-87656091 / 5203 : ℚ)) * X ^ 15 + C ((-151778027 / 15609 : ℚ)) * X ^ 16 + C ((-5140930 / 1419 : ℚ)) * X ^ 17 + C ((3081663 / 5203 : ℚ)) * X ^ 18
def VP15_pim : Polynomial ℚ := C ((19795673 / 5203 : ℚ)) + C ((39591346 / 5203 : ℚ)) * X + C ((159655820 / 15609 : ℚ)) * X ^ 2 + C ((224637328 / 15609 : ℚ)) * X ^ 3 + C ((235840592 / 15609 : ℚ)) * X ^ 4 + C ((209104243 / 15609 : ℚ)) * X ^ 5 + C ((183713173 / 15609 : ℚ)) * X ^ 6 + C ((110723248 / 15609 : ℚ)) * X ^ 7 + C ((57620281 / 15609 : ℚ)) * X ^ 8 + C ((54565315 / 15609 : ℚ)) * X ^ 9 + C ((40379344 / 15609 : ℚ)) * X ^ 10 + C ((-40196282 / 15609 : ℚ)) * X ^ 11 + C ((-120771908 / 15609 : ℚ)) * X ^ 12 + C ((-175839661 / 15609 : ℚ)) * X ^ 13 + C ((-81292045 / 5203 : ℚ)) * X ^ 14 + C ((-82046509 / 5203 : ℚ)) * X ^ 15 + C ((-66998634 / 5203 : ℚ)) * X ^ 16 + C ((-51146680 / 5203 : ℚ)) * X ^ 17 + C ((-62042839 / 15609 : ℚ)) * X ^ 18
theorem VP15_pre_eq :
    VA_0_1_re * VP15_Fre - VA_0_1_im * VP15_Fim = VP15_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP15_Fre, VP15_Fim, VP15_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP15_pim_eq :
    VA_0_1_re * VP15_Fim + VA_0_1_im * VP15_Fre = VP15_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP15_Fre, VP15_Fim, VP15_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP15_mul : VA_0_1 * VP15_F = ofLadj VP15_pre VP15_pim := by
  rw [VA_0_1, VP15_F, ofLadj_mul, VP15_pre_eq, VP15_pim_eq]

def VP16_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP16_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP16_F : Ki := ofLadj VP16_Fre VP16_Fim
def VP16_pre : Polynomial ℚ := C ((-18381092 / 15609 : ℚ)) + C ((-256985360 / 15609 : ℚ)) * X + C ((-521886058 / 15609 : ℚ)) * X ^ 2 + C ((-854086304 / 15609 : ℚ)) * X ^ 3 + C ((-424552880 / 5203 : ℚ)) * X ^ 4 + C ((-504935048 / 5203 : ℚ)) * X ^ 5 + C ((-1705644262 / 15609 : ℚ)) * X ^ 6 + C ((-1812687028 / 15609 : ℚ)) * X ^ 7 + C ((-1728156058 / 15609 : ℚ)) * X ^ 8 + C ((-565115770 / 5203 : ℚ)) * X ^ 9 + C ((-1670578970 / 15609 : ℚ)) * X ^ 10 + C ((-149372456 / 1419 : ℚ)) * X ^ 11 + C ((-996190 / 11 : ℚ)) * X ^ 12 + C ((-1173461252 / 15609 : ℚ)) * X ^ 13 + C ((-874069754 / 15609 : ℚ)) * X ^ 14 + C ((-484524026 / 15609 : ℚ)) * X ^ 15 + C ((-260948612 / 15609 : ℚ)) * X ^ 16 + C ((-70109494 / 15609 : ℚ)) * X ^ 17 + C ((4954942 / 1419 : ℚ)) * X ^ 18
def VP16_pim : Polynomial ℚ := C ((173301736 / 15609 : ℚ)) + C ((346603472 / 15609 : ℚ)) * X + C ((408979882 / 15609 : ℚ)) * X ^ 2 + C ((160869608 / 5203 : ℚ)) * X ^ 3 + C ((366080392 / 15609 : ℚ)) * X ^ 4 + C ((128265064 / 15609 : ℚ)) * X ^ 5 + C ((-60206846 / 15609 : ℚ)) * X ^ 6 + C ((-30500102 / 1419 : ℚ)) * X ^ 7 + C ((-495203536 / 15609 : ℚ)) * X ^ 8 + C ((-490422412 / 15609 : ℚ)) * X ^ 9 + C ((-156216768 / 5203 : ℚ)) * X ^ 10 + C ((-610509508 / 15609 : ℚ)) * X ^ 11 + C ((-752368712 / 15609 : ℚ)) * X ^ 12 + C ((-264324338 / 5203 : ℚ)) * X ^ 13 + C ((-861820832 / 15609 : ℚ)) * X ^ 14 + C ((-253065748 / 5203 : ℚ)) * X ^ 15 + C ((-549126628 / 15609 : ℚ)) * X ^ 16 + C ((-393347134 / 15609 : ℚ)) * X ^ 17 + C ((-48599190 / 5203 : ℚ)) * X ^ 18
theorem VP16_pre_eq :
    VA_0_1_re * VP16_Fre - VA_0_1_im * VP16_Fim = VP16_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP16_Fre, VP16_Fim, VP16_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP16_pim_eq :
    VA_0_1_re * VP16_Fim + VA_0_1_im * VP16_Fre = VP16_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP16_Fre, VP16_Fim, VP16_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP16_mul : VA_0_1 * VP16_F = ofLadj VP16_pre VP16_pim := by
  rw [VA_0_1, VP16_F, ofLadj_mul, VP16_pre_eq, VP16_pim_eq]

def VP17_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def VP17_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def VP17_F : Ki := ofLadj VP17_Fre VP17_Fim
def VP17_pre : Polynomial ℚ := C ((-10573502 / 15609 : ℚ)) + C ((-179889752 / 15609 : ℚ)) * X + C ((-119478119 / 5203 : ℚ)) * X ^ 2 + C ((-579367571 / 15609 : ℚ)) * X ^ 3 + C ((-294043898 / 5203 : ℚ)) * X ^ 4 + C ((-1067319202 / 15609 : ℚ)) * X ^ 5 + C ((-1233582275 / 15609 : ℚ)) * X ^ 6 + C ((-1346175781 / 15609 : ℚ)) * X ^ 7 + C ((-1324486618 / 15609 : ℚ)) * X ^ 8 + C ((-1342146301 / 15609 : ℚ)) * X ^ 9 + C ((-1355750228 / 15609 : ℚ)) * X ^ 10 + C ((-1350284626 / 15609 : ℚ)) * X ^ 11 + C ((-391953492 / 5203 : ℚ)) * X ^ 12 + C ((-983711944 / 15609 : ℚ)) * X ^ 13 + C ((-745119047 / 15609 : ℚ)) * X ^ 14 + C ((-142021679 / 5203 : ℚ)) * X ^ 15 + C ((-231090203 / 15609 : ℚ)) * X ^ 16 + C ((-64827130 / 15609 : ℚ)) * X ^ 17 + C ((37979050 / 15609 : ℚ)) * X ^ 18
def VP17_pim : Polynomial ℚ := C ((129020776 / 15609 : ℚ)) + C ((258041552 / 15609 : ℚ)) * X + C ((312821719 / 15609 : ℚ)) * X ^ 2 + C ((391474367 / 15609 : ℚ)) * X ^ 3 + C ((342209918 / 15609 : ℚ)) * X ^ 4 + C ((205628869 / 15609 : ℚ)) * X ^ 5 + C ((101480026 / 15609 : ℚ)) * X ^ 6 + C ((-84822890 / 15609 : ℚ)) * X ^ 7 + C ((-64550721 / 5203 : ℚ)) * X ^ 8 + C ((-196161256 / 15609 : ℚ)) * X ^ 9 + C ((-207828878 / 15609 : ℚ)) * X ^ 10 + C ((-32192348 / 1419 : ℚ)) * X ^ 11 + C ((-166800926 / 5203 : ℚ)) * X ^ 12 + C ((-188950189 / 5203 : ℚ)) * X ^ 13 + C ((-648012308 / 15609 : ℚ)) * X ^ 14 + C ((-197127880 / 5203 : ℚ)) * X ^ 15 + C ((-439726282 / 15609 : ℚ)) * X ^ 16 + C ((-28870247 / 1419 : ℚ)) * X ^ 17 + C ((-38731164 / 5203 : ℚ)) * X ^ 18
theorem VP17_pre_eq :
    VA_0_1_re * VP17_Fre - VA_0_1_im * VP17_Fim = VP17_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP17_Fre, VP17_Fim, VP17_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP17_pim_eq :
    VA_0_1_re * VP17_Fim + VA_0_1_im * VP17_Fre = VP17_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_0_1_re, VA_0_1_im, VP17_Fre, VP17_Fim, VP17_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP17_mul : VA_0_1 * VP17_F = ofLadj VP17_pre VP17_pim := by
  rw [VA_0_1, VP17_F, ofLadj_mul, VP17_pre_eq, VP17_pim_eq]

def VP18_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def VP18_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def VP18_F : Ki := ofLadj VP18_Fre VP18_Fim
def VP18_pre : Polynomial ℚ := C ((-60091953 / 41624 : ℚ)) + C ((13237189 / 10406 : ℚ)) * X ^ 2 + C ((75686079 / 20812 : ℚ)) * X ^ 3 + C ((116591547 / 10406 : ℚ)) * X ^ 4 + C ((391622567 / 20812 : ℚ)) * X ^ 5 + C ((554470289 / 20812 : ℚ)) * X ^ 6 + C ((1373893803 / 41624 : ℚ)) * X ^ 7 + C ((1474190239 / 41624 : ℚ)) * X ^ 8 + C ((1517024043 / 41624 : ℚ)) * X ^ 9 + C ((774829355 / 20812 : ℚ)) * X ^ 10 + C ((147455095 / 3784 : ℚ)) * X ^ 11 + C ((774829355 / 20812 : ℚ)) * X ^ 12 + C ((1464075287 / 41624 : ℚ)) * X ^ 13 + C ((1322818081 / 41624 : ℚ)) * X ^ 14 + C ((484266639 / 20812 : ℚ)) * X ^ 15 + C ((628242881 / 41624 : ℚ)) * X ^ 16 + C ((302547437 / 41624 : ℚ)) * X ^ 17 + C ((61005663 / 41624 : ℚ)) * X ^ 18
def VP18_pim : Polynomial ℚ := C ((-204646089 / 41624 : ℚ)) + C ((-204646089 / 20812 : ℚ)) * X + C ((-332563053 / 20812 : ℚ)) * X ^ 2 + C ((-1012355413 / 41624 : ℚ)) * X ^ 3 + C ((-1227107217 / 41624 : ℚ)) * X ^ 4 + C ((-664754021 / 20812 : ℚ)) * X ^ 5 + C ((-123345317 / 3784 : ℚ)) * X ^ 6 + C ((-1159734711 / 41624 : ℚ)) * X ^ 7 + C ((-128868230 / 5203 : ℚ)) * X ^ 8 + C ((-128103897 / 5203 : ℚ)) * X ^ 9 + C ((-124564124 / 5203 : ℚ)) * X ^ 10 + C ((-68215363 / 3784 : ℚ)) * X ^ 11 + C ((-252112497 / 20812 : ℚ)) * X ^ 12 + C ((-2558987 / 484 : ℚ)) * X ^ 13 + C ((133271089 / 41624 : ℚ)) * X ^ 14 + C ((330114055 / 41624 : ℚ)) * X ^ 15 + C ((396095719 / 41624 : ℚ)) * X ^ 16 + C ((190090323 / 20812 : ℚ)) * X ^ 17 + C ((146697709 / 41624 : ℚ)) * X ^ 18
theorem VP18_pre_eq :
    VA_2_0_re * VP18_Fre - VA_2_0_im * VP18_Fim = VP18_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP18_Fre, VP18_Fim, VP18_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP18_pim_eq :
    VA_2_0_re * VP18_Fim + VA_2_0_im * VP18_Fre = VP18_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP18_Fre, VP18_Fim, VP18_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP18_mul : VA_2_0 * VP18_F = ofLadj VP18_pre VP18_pim := by
  rw [VA_2_0, VP18_F, ofLadj_mul, VP18_pre_eq, VP18_pim_eq]

def VP19_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def VP19_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def VP19_F : Ki := ofLadj VP19_Fre VP19_Fim
def VP19_pre : Polynomial ℚ := C ((-1261277 / 20812 : ℚ)) + C ((136430726 / 15609 : ℚ)) * X + C ((272802557 / 15609 : ℚ)) * X ^ 2 + C ((1777155491 / 62436 : ℚ)) * X ^ 3 + C ((273203365 / 5676 : ℚ)) * X ^ 4 + C ((1282610135 / 20812 : ℚ)) * X ^ 5 + C ((386602631 / 5203 : ℚ)) * X ^ 6 + C ((4984382621 / 62436 : ℚ)) * X ^ 7 + C ((4640000291 / 62436 : ℚ)) * X ^ 8 + C ((4393365347 / 62436 : ℚ)) * X ^ 9 + C ((382265585 / 5676 : ℚ)) * X ^ 10 + C ((2069226515 / 31218 : ℚ)) * X ^ 11 + C ((3659198531 / 62436 : ℚ)) * X ^ 12 + C ((1100718373 / 20812 : ℚ)) * X ^ 13 + C ((238570400 / 5203 : ℚ)) * X ^ 14 + C ((620501107 / 20812 : ℚ)) * X ^ 15 + C ((288436414 / 15609 : ℚ)) * X ^ 16 + C ((362344489 / 62436 : ℚ)) * X ^ 17 + C ((-39214095 / 20812 : ℚ)) * X ^ 18
def VP19_pim : Polynomial ℚ := C ((-47051713 / 5676 : ℚ)) + C ((-47051713 / 2838 : ℚ)) * X + C ((-334365478 / 15609 : ℚ)) * X ^ 2 + C ((-1834865033 / 62436 : ℚ)) * X ^ 3 + C ((-615452329 / 20812 : ℚ)) * X ^ 4 + C ((-451826867 / 20812 : ℚ)) * X ^ 5 + C ((-203112940 / 15609 : ℚ)) * X ^ 6 + C ((75978113 / 20812 : ℚ)) * X ^ 7 + C ((72129715 / 5676 : ℚ)) * X ^ 8 + C ((757869971 / 62436 : ℚ)) * X ^ 9 + C ((198254775 / 20812 : ℚ)) * X ^ 10 + C ((145516625 / 10406 : ℚ)) * X ^ 11 + C ((34891975 / 1892 : ℚ)) * X ^ 12 + C ((1290653755 / 62436 : ℚ)) * X ^ 13 + C ((876249991 / 31218 : ℚ)) * X ^ 14 + C ((169781797 / 5676 : ℚ)) * X ^ 15 + C ((132187802 / 5203 : ℚ)) * X ^ 16 + C ((430913517 / 20812 : ℚ)) * X ^ 17 + C ((153961565 / 20812 : ℚ)) * X ^ 18
theorem VP19_pre_eq :
    VA_2_0_re * VP19_Fre - VA_2_0_im * VP19_Fim = VP19_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP19_Fre, VP19_Fim, VP19_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP19_pim_eq :
    VA_2_0_re * VP19_Fim + VA_2_0_im * VP19_Fre = VP19_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP19_Fre, VP19_Fim, VP19_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP19_mul : VA_2_0 * VP19_F = ofLadj VP19_pre VP19_pim := by
  rw [VA_2_0, VP19_F, ofLadj_mul, VP19_pre_eq, VP19_pim_eq]

def VP20_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def VP20_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def VP20_F : Ki := ofLadj VP20_Fre VP20_Fim
def VP20_pre : Polynomial ℚ := C ((-76338773 / 15609 : ℚ)) + C ((-545722904 / 15609 : ℚ)) * X + C ((-1028642672 / 15609 : ℚ)) * X ^ 2 + C ((-2156137043 / 20812 : ℚ)) * X ^ 3 + C ((-209317093 / 1419 : ℚ)) * X ^ 4 + C ((-2639495410 / 15609 : ℚ)) * X ^ 5 + C ((-1926136691 / 10406 : ℚ)) * X ^ 6 + C ((-2003690833 / 10406 : ℚ)) * X ^ 7 + C ((-5568992291 / 31218 : ℚ)) * X ^ 8 + C ((-10968980213 / 62436 : ℚ)) * X ^ 9 + C ((-5420154089 / 31218 : ℚ)) * X ^ 10 + C ((-873902292 / 5203 : ℚ)) * X ^ 11 + C ((-4328708281 / 31218 : ℚ)) * X ^ 12 + C ((-2284803175 / 20812 : ℚ)) * X ^ 13 + C ((-4669573453 / 62436 : ℚ)) * X ^ 14 + C ((-1041536701 / 31218 : ℚ)) * X ^ 15 + C ((-275727165 / 20812 : ℚ)) * X ^ 16 + C ((171657011 / 62436 : ℚ)) * X ^ 17 + C ((182279876 / 15609 : ℚ)) * X ^ 18
def VP20_pim : Polynomial ℚ := C ((244707391 / 15609 : ℚ)) + C ((489414782 / 15609 : ℚ)) * X + C ((155111591 / 5203 : ℚ)) * X ^ 2 + C ((618651443 / 20812 : ℚ)) * X ^ 3 + C ((253607239 / 31218 : ℚ)) * X ^ 4 + C ((-132241051 / 5203 : ℚ)) * X ^ 5 + C ((-265782695 / 5203 : ℚ)) * X ^ 6 + C ((-1307299117 / 15609 : ℚ)) * X ^ 7 + C ((-1590081539 / 15609 : ℚ)) * X ^ 8 + C ((-6336100207 / 62436 : ℚ)) * X ^ 9 + C ((-1556074580 / 15609 : ℚ)) * X ^ 10 + C ((-1759899469 / 15609 : ℚ)) * X ^ 11 + C ((-654574786 / 5203 : ℚ)) * X ^ 12 + C ((-7646775509 / 62436 : ℚ)) * X ^ 13 + C ((-692469527 / 5676 : ℚ)) * X ^ 14 + C ((-3169623103 / 31218 : ℚ)) * X ^ 15 + C ((-398975651 / 5676 : ℚ)) * X ^ 16 + C ((-268774501 / 5676 : ℚ)) * X ^ 17 + C ((-265077107 / 15609 : ℚ)) * X ^ 18
theorem VP20_pre_eq :
    VA_2_0_re * VP20_Fre - VA_2_0_im * VP20_Fim = VP20_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP20_Fre, VP20_Fim, VP20_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP20_pim_eq :
    VA_2_0_re * VP20_Fim + VA_2_0_im * VP20_Fre = VP20_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP20_Fre, VP20_Fim, VP20_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP20_mul : VA_2_0 * VP20_F = ofLadj VP20_pre VP20_pim := by
  rw [VA_2_0, VP20_F, ofLadj_mul, VP20_pre_eq, VP20_pim_eq]

def VP21_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def VP21_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def VP21_F : Ki := ofLadj VP21_Fre VP21_Fim
def VP21_pre : Polynomial ℚ := C ((138937 / 31218 : ℚ)) + C ((341076815 / 31218 : ℚ)) * X + C ((645715669 / 31218 : ℚ)) * X ^ 2 + C ((555630565 / 15609 : ℚ)) * X ^ 3 + C ((3627997079 / 62436 : ℚ)) * X ^ 4 + C ((1560637697 / 20812 : ℚ)) * X ^ 5 + C ((5706270095 / 62436 : ℚ)) * X ^ 6 + C ((6533671739 / 62436 : ℚ)) * X ^ 7 + C ((1660866368 / 15609 : ℚ)) * X ^ 8 + C ((2291719259 / 20812 : ℚ)) * X ^ 9 + C ((1763044991 / 15609 : ℚ)) * X ^ 10 + C ((2372716403 / 20812 : ℚ)) * X ^ 11 + C ((3185013167 / 31218 : ℚ)) * X ^ 12 + C ((5583726439 / 62436 : ℚ)) * X ^ 13 + C ((1105235803 / 15609 : ℚ)) * X ^ 14 + C ((2802560087 / 62436 : ℚ)) * X ^ 15 + C ((1621793579 / 62436 : ℚ)) * X ^ 16 + C ((199145525 / 20812 : ℚ)) * X ^ 17 + C ((-103114573 / 62436 : ℚ)) * X ^ 18
def VP21_pim : Polynomial ℚ := C ((-209969071 / 20812 : ℚ)) + C ((-209969071 / 10406 : ℚ)) * X + C ((-567118033 / 20812 : ℚ)) * X ^ 2 + C ((-2389748917 / 62436 : ℚ)) * X ^ 3 + C ((-227417825 / 5676 : ℚ)) * X ^ 4 + C ((-101076287 / 2838 : ℚ)) * X ^ 5 + C ((-1950391513 / 62436 : ℚ)) * X ^ 6 + C ((-581533885 / 31218 : ℚ)) * X ^ 7 + C ((-27175703 / 2838 : ℚ)) * X ^ 8 + C ((-282298879 / 31218 : ℚ)) * X ^ 9 + C ((-34286449 / 5203 : ℚ)) * X ^ 10 + C ((443328739 / 62436 : ℚ)) * X ^ 11 + C ((649047433 / 31218 : ℚ)) * X ^ 12 + C ((1892794909 / 62436 : ℚ)) * X ^ 13 + C ((2614457435 / 62436 : ℚ)) * X ^ 14 + C ((1314591343 / 31218 : ℚ)) * X ^ 15 + C ((538581397 / 15609 : ℚ)) * X ^ 16 + C ((1646587291 / 62436 : ℚ)) * X ^ 17 + C ((220774737 / 20812 : ℚ)) * X ^ 18
theorem VP21_pre_eq :
    VA_2_0_re * VP21_Fre - VA_2_0_im * VP21_Fim = VP21_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP21_Fre, VP21_Fim, VP21_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP21_pim_eq :
    VA_2_0_re * VP21_Fim + VA_2_0_im * VP21_Fre = VP21_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP21_Fre, VP21_Fim, VP21_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP21_mul : VA_2_0 * VP21_F = ofLadj VP21_pre VP21_pim := by
  rw [VA_2_0, VP21_F, ofLadj_mul, VP21_pre_eq, VP21_pim_eq]

def VP22_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP22_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP22_F : Ki := ofLadj VP22_Fre VP22_Fim
def VP22_pre : Polynomial ℚ := C ((100709003 / 31218 : ℚ)) + C ((682153630 / 15609 : ℚ)) * X + C ((1387707181 / 15609 : ℚ)) * X ^ 2 + C ((759864673 / 5203 : ℚ)) * X ^ 3 + C ((6788547281 / 31218 : ℚ)) * X ^ 4 + C ((1344703203 / 5203 : ℚ)) * X ^ 5 + C ((9096447961 / 31218 : ℚ)) * X ^ 6 + C ((3220871759 / 10406 : ℚ)) * X ^ 7 + C ((4603188668 / 15609 : ℚ)) * X ^ 8 + C ((9032318879 / 31218 : ℚ)) * X ^ 9 + C ((8899499077 / 31218 : ℚ)) * X ^ 10 + C ((8749412473 / 31218 : ℚ)) * X ^ 11 + C ((175237019 / 726 : ℚ)) * X ^ 12 + C ((2085634839 / 10406 : ℚ)) * X ^ 13 + C ((2323594649 / 15609 : ℚ)) * X ^ 14 + C ((234343433 / 2838 : ℚ)) * X ^ 15 + C ((464332183 / 10406 : ℚ)) * X ^ 16 + C ((182383903 / 15609 : ℚ)) * X ^ 17 + C ((-98763411 / 10406 : ℚ)) * X ^ 18
def VP22_pim : Polynomial ℚ := C ((-83521601 / 2838 : ℚ)) + C ((-83521601 / 1419 : ℚ)) * X + C ((-1089512945 / 15609 : ℚ)) * X ^ 2 + C ((-1283319592 / 15609 : ℚ)) * X ^ 3 + C ((-1932625339 / 31218 : ℚ)) * X ^ 4 + C ((-673513471 / 31218 : ℚ)) * X ^ 5 + C ((167293309 / 15609 : ℚ)) * X ^ 6 + C ((907039487 / 15609 : ℚ)) * X ^ 7 + C ((1332158738 / 15609 : ℚ)) * X ^ 8 + C ((2639229859 / 31218 : ℚ)) * X ^ 9 + C ((2524033057 / 31218 : ℚ)) * X ^ 10 + C ((3274195183 / 31218 : ℚ)) * X ^ 11 + C ((4024357309 / 31218 : ℚ)) * X ^ 12 + C ((1416903725 / 10406 : ℚ)) * X ^ 13 + C ((2306618426 / 15609 : ℚ)) * X ^ 14 + C ((2026194914 / 15609 : ℚ)) * X ^ 15 + C ((980376457 / 10406 : ℚ)) * X ^ 16 + C ((1054356313 / 15609 : ℚ)) * X ^ 17 + C ((777071681 / 31218 : ℚ)) * X ^ 18
theorem VP22_pre_eq :
    VA_2_0_re * VP22_Fre - VA_2_0_im * VP22_Fim = VP22_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP22_Fre, VP22_Fim, VP22_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP22_pim_eq :
    VA_2_0_re * VP22_Fim + VA_2_0_im * VP22_Fre = VP22_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP22_Fre, VP22_Fim, VP22_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP22_mul : VA_2_0 * VP22_F = ofLadj VP22_pre VP22_pim := by
  rw [VA_2_0, VP22_F, ofLadj_mul, VP22_pre_eq, VP22_pim_eq]

def VP23_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def VP23_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def VP23_F : Ki := ofLadj VP23_Fre VP23_Fim
def VP23_pre : Polynomial ℚ := C ((116955823 / 62436 : ℚ)) + C ((477507541 / 15609 : ℚ)) * X + C ((3812882783 / 62436 : ℚ)) * X ^ 2 + C ((1031375907 / 10406 : ℚ)) * X ^ 3 + C ((9404572043 / 62436 : ℚ)) * X ^ 4 + C ((5685022985 / 31218 : ℚ)) * X ^ 5 + C ((199400059 / 946 : ℚ)) * X ^ 6 + C ((7177466203 / 31218 : ℚ)) * X ^ 7 + C ((14115028303 / 62436 : ℚ)) * X ^ 8 + C ((7152223717 / 31218 : ℚ)) * X ^ 9 + C ((4816354221 / 20812 : ℚ)) * X ^ 10 + C ((7193088835 / 31218 : ℚ)) * X ^ 11 + C ((12539032499 / 62436 : ℚ)) * X ^ 12 + C ((3497188217 / 20812 : ℚ)) * X ^ 13 + C ((7926772861 / 62436 : ℚ)) * X ^ 14 + C ((1512142615 / 20812 : ℚ)) * X ^ 15 + C ((616840085 / 15609 : ℚ)) * X ^ 16 + C ((56416868 / 5203 : ℚ)) * X ^ 17 + C ((-68988753 / 10406 : ℚ)) * X ^ 18
def VP23_pim : Polynomial ℚ := C ((-1368091091 / 62436 : ℚ)) + C ((-1368091091 / 31218 : ℚ)) * X + C ((-3333579125 / 62436 : ℚ)) * X ^ 2 + C ((-4164390917 / 62436 : ℚ)) * X ^ 3 + C ((-904880708 / 15609 : ℚ)) * X ^ 4 + C ((-2177629505 / 62436 : ℚ)) * X ^ 5 + C ((-265658065 / 15609 : ℚ)) * X ^ 6 + C ((314127749 / 20812 : ℚ)) * X ^ 7 + C ((525505432 / 15609 : ℚ)) * X ^ 8 + C ((193557445 / 5676 : ℚ)) * X ^ 9 + C ((751478587 / 20812 : ℚ)) * X ^ 10 + C ((1903109059 / 31218 : ℚ)) * X ^ 11 + C ((5358000475 / 62436 : ℚ)) * X ^ 12 + C ((506725107 / 5203 : ℚ)) * X ^ 13 + C ((6938623243 / 62436 : ℚ)) * X ^ 14 + C ((2104812421 / 20812 : ℚ)) * X ^ 15 + C ((2355715357 / 31218 : ℚ)) * X ^ 16 + C ((3405085105 / 62436 : ℚ)) * X ^ 17 + C ((309739094 / 15609 : ℚ)) * X ^ 18
theorem VP23_pre_eq :
    VA_2_0_re * VP23_Fre - VA_2_0_im * VP23_Fim = VP23_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP23_Fre, VP23_Fim, VP23_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP23_pim_eq :
    VA_2_0_re * VP23_Fim + VA_2_0_im * VP23_Fre = VP23_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_2_0_re, VA_2_0_im, VP23_Fre, VP23_Fim, VP23_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP23_mul : VA_2_0 * VP23_F = ofLadj VP23_pre VP23_pim := by
  rw [VA_2_0, VP23_F, ofLadj_mul, VP23_pre_eq, VP23_pim_eq]

def VP24_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def VP24_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def VP24_F : Ki := ofLadj VP24_Fre VP24_Fim
def VP24_pre : Polynomial ℚ := C ((-2805795 / 10406 : ℚ)) + C ((2485921 / 10406 : ℚ)) * X ^ 2 + C ((14243975 / 20812 : ℚ)) * X ^ 3 + C ((43549039 / 20812 : ℚ)) * X ^ 4 + C ((3317095 / 946 : ℚ)) * X ^ 5 + C ((103324587 / 20812 : ℚ)) * X ^ 6 + C ((2909543 / 473 : ℚ)) * X ^ 7 + C ((6243727 / 946 : ℚ)) * X ^ 8 + C ((141350709 / 20812 : ℚ)) * X ^ 9 + C ((36097921 / 5203 : ℚ)) * X ^ 10 + C ((37784858 / 5203 : ℚ)) * X ^ 11 + C ((36097921 / 5203 : ℚ)) * X ^ 12 + C ((136378867 / 20812 : ℚ)) * X ^ 13 + C ((123118019 / 20812 : ℚ)) * X ^ 14 + C ((90153281 / 20812 : ℚ)) * X ^ 15 + C ((14637520 / 5203 : ℚ)) * X ^ 16 + C ((28201583 / 20812 : ℚ)) * X ^ 17 + C ((1420607 / 5203 : ℚ)) * X ^ 18
def VP24_pim : Polynomial ℚ := C ((-4742922 / 5203 : ℚ)) + C ((-9485844 / 5203 : ℚ)) * X + C ((-30873475 / 10406 : ℚ)) * X ^ 2 + C ((-94047605 / 20812 : ℚ)) * X ^ 3 + C ((-114012935 / 20812 : ℚ)) * X ^ 4 + C ((-61810343 / 10406 : ℚ)) * X ^ 5 + C ((-11463853 / 1892 : ℚ)) * X ^ 6 + C ((-26908784 / 5203 : ℚ)) * X ^ 7 + C ((-23902047 / 5203 : ℚ)) * X ^ 8 + C ((-95035949 / 20812 : ℚ)) * X ^ 9 + C ((-23097947 / 5203 : ℚ)) * X ^ 10 + C ((-1580974 / 473 : ℚ)) * X ^ 11 + C ((-11683481 / 5203 : ℚ)) * X ^ 12 + C ((-1844199 / 1892 : ℚ)) * X ^ 13 + C ((12586705 / 20812 : ℚ)) * X ^ 14 + C ((30882509 / 20812 : ℚ)) * X ^ 15 + C ((9273282 / 5203 : ℚ)) * X ^ 16 + C ((35560853 / 20812 : ℚ)) * X ^ 17 + C ((56597 / 86 : ℚ)) * X ^ 18
theorem VP24_pre_eq :
    VA_1_1_re * VP24_Fre - VA_1_1_im * VP24_Fim = VP24_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP24_Fre, VP24_Fim, VP24_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP24_pim_eq :
    VA_1_1_re * VP24_Fim + VA_1_1_im * VP24_Fre = VP24_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP24_Fre, VP24_Fim, VP24_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP24_mul : VA_1_1 * VP24_F = ofLadj VP24_pre VP24_pim := by
  rw [VA_1_1, VP24_F, ofLadj_mul, VP24_pre_eq, VP24_pim_eq]

def VP25_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def VP25_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def VP25_F : Ki := ofLadj VP25_Fre VP25_Fim
def VP25_pre : Polynomial ℚ := C ((-20269 / 1419 : ℚ)) + C ((25295584 / 15609 : ℚ)) * X + C ((1179040 / 363 : ℚ)) * X ^ 2 + C ((82748551 / 15609 : ℚ)) * X ^ 3 + C ((139839452 / 15609 : ℚ)) * X ^ 4 + C ((59645511 / 5203 : ℚ)) * X ^ 5 + C ((71947038 / 5203 : ℚ)) * X ^ 6 + C ((231889261 / 15609 : ℚ)) * X ^ 7 + C ((215812697 / 15609 : ℚ)) * X ^ 8 + C ((204332567 / 15609 : ℚ)) * X ^ 9 + C ((413428 / 33 : ℚ)) * X ^ 10 + C ((192528230 / 15609 : ℚ)) * X ^ 11 + C ((170255860 / 15609 : ℚ)) * X ^ 12 + C ((153633847 / 15609 : ℚ)) * X ^ 13 + C ((133064146 / 15609 : ℚ)) * X ^ 14 + C ((86541896 / 15609 : ℚ)) * X ^ 15 + C ((53707310 / 15609 : ℚ)) * X ^ 16 + C ((16802729 / 15609 : ℚ)) * X ^ 17 + C ((-42697 / 121 : ℚ)) * X ^ 18
def VP25_pim : Polynomial ℚ := C ((-24004166 / 15609 : ℚ)) + C ((-48008332 / 15609 : ℚ)) * X + C ((-20689228 / 5203 : ℚ)) * X ^ 2 + C ((-85167044 / 15609 : ℚ)) * X ^ 3 + C ((-707569 / 129 : ℚ)) * X ^ 4 + C ((-20958747 / 5203 : ℚ)) * X ^ 5 + C ((-37574543 / 15609 : ℚ)) * X ^ 6 + C ((11045849 / 15609 : ℚ)) * X ^ 7 + C ((12472507 / 5203 : ℚ)) * X ^ 8 + C ((11923605 / 5203 : ℚ)) * X ^ 9 + C ((9387691 / 5203 : ℚ)) * X ^ 10 + C ((13678596 / 5203 : ℚ)) * X ^ 11 + C ((1633591 / 473 : ℚ)) * X ^ 12 + C ((5487283 / 1419 : ℚ)) * X ^ 13 + C ((81812767 / 15609 : ℚ)) * X ^ 14 + C ((87083290 / 15609 : ℚ)) * X ^ 15 + C ((74113406 / 15609 : ℚ)) * X ^ 16 + C ((60400622 / 15609 : ℚ)) * X ^ 17 + C ((7183318 / 5203 : ℚ)) * X ^ 18
theorem VP25_pre_eq :
    VA_1_1_re * VP25_Fre - VA_1_1_im * VP25_Fim = VP25_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP25_Fre, VP25_Fim, VP25_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP25_pim_eq :
    VA_1_1_re * VP25_Fim + VA_1_1_im * VP25_Fre = VP25_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP25_Fre, VP25_Fim, VP25_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP25_mul : VA_1_1 * VP25_F = ofLadj VP25_pre VP25_pim := by
  rw [VA_1_1, VP25_F, ofLadj_mul, VP25_pre_eq, VP25_pim_eq]

def VP26_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def VP26_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def VP26_F : Ki := ofLadj VP26_Fre VP26_Fim
def VP26_pre : Polynomial ℚ := C ((-14072404 / 15609 : ℚ)) + C ((-101182336 / 15609 : ℚ)) * X + C ((-191021090 / 15609 : ℚ)) * X ^ 2 + C ((-300774224 / 15609 : ℚ)) * X ^ 3 + C ((-142744806 / 5203 : ℚ)) * X ^ 4 + C ((-163574206 / 5203 : ℚ)) * X ^ 5 + C ((-179108565 / 5203 : ℚ)) * X ^ 6 + C ((-558762010 / 15609 : ℚ)) * X ^ 7 + C ((-517477388 / 15609 : ℚ)) * X ^ 8 + C ((-509626202 / 15609 : ℚ)) * X ^ 9 + C ((-503628013 / 15609 : ℚ)) * X ^ 10 + C ((-487309292 / 15609 : ℚ)) * X ^ 11 + C ((-134148559 / 5203 : ℚ)) * X ^ 12 + C ((-106201704 / 5203 : ℚ)) * X ^ 13 + C ((-72234388 / 5203 : ℚ)) * X ^ 14 + C ((-96460922 / 15609 : ℚ)) * X ^ 15 + C ((-3479981 / 1419 : ℚ)) * X ^ 16 + C ((8323286 / 15609 : ℚ)) * X ^ 17 + C ((3096970 / 1419 : ℚ)) * X ^ 18
def VP26_pim : Polynomial ℚ := C ((15141832 / 5203 : ℚ)) + C ((30283664 / 5203 : ℚ)) * X + C ((28781226 / 5203 : ℚ)) * X ^ 2 + C ((85970387 / 15609 : ℚ)) * X ^ 3 + C ((177636 / 121 : ℚ)) * X ^ 4 + C ((-24792934 / 5203 : ℚ)) * X ^ 5 + C ((-149044739 / 15609 : ℚ)) * X ^ 6 + C ((-244339228 / 15609 : ℚ)) * X ^ 7 + C ((-297075527 / 15609 : ℚ)) * X ^ 8 + C ((-815312 / 43 : ℚ)) * X ^ 9 + C ((-96920814 / 5203 : ℚ)) * X ^ 10 + C ((-328564448 / 15609 : ℚ)) * X ^ 11 + C ((-366366454 / 15609 : ℚ)) * X ^ 12 + C ((-356663326 / 15609 : ℚ)) * X ^ 13 + C ((-355172764 / 15609 : ℚ)) * X ^ 14 + C ((-98467074 / 5203 : ℚ)) * X ^ 15 + C ((-204794096 / 15609 : ℚ)) * X ^ 16 + C ((-46020089 / 5203 : ℚ)) * X ^ 17 + C ((-16484166 / 5203 : ℚ)) * X ^ 18
theorem VP26_pre_eq :
    VA_1_1_re * VP26_Fre - VA_1_1_im * VP26_Fim = VP26_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP26_Fre, VP26_Fim, VP26_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP26_pim_eq :
    VA_1_1_re * VP26_Fim + VA_1_1_im * VP26_Fre = VP26_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP26_Fre, VP26_Fim, VP26_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP26_mul : VA_1_1 * VP26_F = ofLadj VP26_pre VP26_pim := by
  rw [VA_1_1, VP26_F, ofLadj_mul, VP26_pre_eq, VP26_pim_eq]

def VP27_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def VP27_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def VP27_F : Ki := ofLadj VP27_Fre VP27_Fim
def VP27_pre : Polynomial ℚ := C ((-89765 / 31218 : ℚ)) + C ((31619480 / 15609 : ℚ)) * X + C ((119993623 / 31218 : ℚ)) * X ^ 2 + C ((206961079 / 31218 : ℚ)) * X ^ 3 + C ((56275315 / 5203 : ℚ)) * X ^ 4 + C ((217761991 / 15609 : ℚ)) * X ^ 5 + C ((531036991 / 31218 : ℚ)) * X ^ 6 + C ((202651115 / 10406 : ℚ)) * X ^ 7 + C ((309070532 / 15609 : ℚ)) * X ^ 8 + C ((319869400 / 15609 : ℚ)) * X ^ 9 + C ((656216555 / 31218 : ℚ)) * X ^ 10 + C ((331197085 / 15609 : ℚ)) * X ^ 11 + C ((592977595 / 31218 : ℚ)) * X ^ 12 + C ((519745177 / 31218 : ℚ)) * X ^ 13 + C ((137059995 / 10406 : ℚ)) * X ^ 14 + C ((260625953 / 31218 : ℚ)) * X ^ 15 + C ((151003417 / 31218 : ℚ)) * X ^ 16 + C ((27745204 / 15609 : ℚ)) * X ^ 17 + C ((-4837751 / 15609 : ℚ)) * X ^ 18
def VP27_pim : Polynomial ℚ := C ((-58429441 / 31218 : ℚ)) + C ((-58429441 / 15609 : ℚ)) * X + C ((-52630447 / 10406 : ℚ)) * X ^ 2 + C ((-73944265 / 10406 : ℚ)) * X ^ 3 + C ((-115999388 / 15609 : ℚ)) * X ^ 4 + C ((-103170235 / 15609 : ℚ)) * X ^ 5 + C ((-180689921 / 31218 : ℚ)) * X ^ 6 + C ((-106969889 / 31218 : ℚ)) * X ^ 7 + C ((-27117785 / 15609 : ℚ)) * X ^ 8 + C ((-198210 / 121 : ℚ)) * X ^ 9 + C ((-12270611 / 10406 : ℚ)) * X ^ 10 + C ((21256229 / 15609 : ℚ)) * X ^ 11 + C ((121836749 / 31218 : ℚ)) * X ^ 12 + C ((59065185 / 10406 : ℚ)) * X ^ 13 + C ((244234399 / 31218 : ℚ)) * X ^ 14 + C ((5705257 / 726 : ℚ)) * X ^ 15 + C ((67096401 / 10406 : ℚ)) * X ^ 16 + C ((76953611 / 15609 : ℚ)) * X ^ 17 + C ((2809484 / 1419 : ℚ)) * X ^ 18
theorem VP27_pre_eq :
    VA_1_1_re * VP27_Fre - VA_1_1_im * VP27_Fim = VP27_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP27_Fre, VP27_Fim, VP27_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP27_pim_eq :
    VA_1_1_re * VP27_Fim + VA_1_1_im * VP27_Fre = VP27_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP27_Fre, VP27_Fim, VP27_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP27_mul : VA_1_1 * VP27_F = ofLadj VP27_pre VP27_pim := by
  rw [VA_1_1, VP27_F, ofLadj_mul, VP27_pre_eq, VP27_pim_eq]

def VP28_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP28_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP28_F : Ki := ofLadj VP28_Fre VP28_Fim
def VP28_pre : Polynomial ℚ := C ((833920 / 1419 : ℚ)) + C ((126477920 / 15609 : ℚ)) * X + C ((257768576 / 15609 : ℚ)) * X ^ 2 + C ((141392334 / 5203 : ℚ)) * X ^ 3 + C ((631500592 / 15609 : ℚ)) * X ^ 4 + C ((750249565 / 15609 : ℚ)) * X ^ 5 + C ((846136345 / 15609 : ℚ)) * X ^ 6 + C ((299546593 / 5203 : ℚ)) * X ^ 7 + C ((856042448 / 15609 : ℚ)) * X ^ 8 + C ((6941036 / 129 : ℚ)) * X ^ 9 + C ((827484431 / 15609 : ℚ)) * X ^ 10 + C ((813685244 / 15609 : ℚ)) * X ^ 11 + C ((5434159 / 121 : ℚ)) * X ^ 12 + C ((194032260 / 5203 : ℚ)) * X ^ 13 + C ((431865446 / 15609 : ℚ)) * X ^ 14 + C ((79808369 / 5203 : ℚ)) * X ^ 15 + C ((1004254 / 121 : ℚ)) * X ^ 16 + C ((11220662 / 5203 : ℚ)) * X ^ 17 + C ((-27714080 / 15609 : ℚ)) * X ^ 18
def VP28_pim : Polynomial ℚ := C ((-28413134 / 5203 : ℚ)) + C ((-56826268 / 5203 : ℚ)) * X + C ((-202242476 / 15609 : ℚ)) * X ^ 2 + C ((-79389674 / 5203 : ℚ)) * X ^ 3 + C ((-178739398 / 15609 : ℚ)) * X ^ 4 + C ((-20582823 / 5203 : ℚ)) * X ^ 5 + C ((32296447 / 15609 : ℚ)) * X ^ 6 + C ((56857743 / 5203 : ℚ)) * X ^ 7 + C ((83287258 / 5203 : ℚ)) * X ^ 8 + C ((247538404 / 15609 : ℚ)) * X ^ 9 + C ((78947235 / 5203 : ℚ)) * X ^ 10 + C ((306361276 / 15609 : ℚ)) * X ^ 11 + C ((375880847 / 15609 : ℚ)) * X ^ 12 + C ((132315940 / 5203 : ℚ)) * X ^ 13 + C ((430550996 / 15609 : ℚ)) * X ^ 14 + C ((8788525 / 363 : ℚ)) * X ^ 15 + C ((91557808 / 5203 : ℚ)) * X ^ 16 + C ((197022346 / 15609 : ℚ)) * X ^ 17 + C ((72503342 / 15609 : ℚ)) * X ^ 18
theorem VP28_pre_eq :
    VA_1_1_re * VP28_Fre - VA_1_1_im * VP28_Fim = VP28_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP28_Fre, VP28_Fim, VP28_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP28_pim_eq :
    VA_1_1_re * VP28_Fim + VA_1_1_im * VP28_Fre = VP28_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP28_Fre, VP28_Fim, VP28_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP28_mul : VA_1_1 * VP28_F = ofLadj VP28_pre VP28_pim := by
  rw [VA_1_1, VP28_F, ofLadj_mul, VP28_pre_eq, VP28_pim_eq]

def VP29_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def VP29_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def VP29_F : Ki := ofLadj VP29_Fre VP29_Fim
def VP29_pre : Polynomial ℚ := C ((5298866 / 15609 : ℚ)) + C ((88534544 / 15609 : ℚ)) * X + C ((59025625 / 5203 : ℚ)) * X ^ 2 + C ((575870741 / 31218 : ℚ)) * X ^ 3 + C ((874983599 / 31218 : ℚ)) * X ^ 4 + C ((32041697 / 946 : ℚ)) * X ^ 5 + C ((612155168 / 15609 : ℚ)) * X ^ 6 + C ((1335238825 / 31218 : ℚ)) * X ^ 7 + C ((656349970 / 15609 : ℚ)) * X ^ 8 + C ((1330372771 / 31218 : ℚ)) * X ^ 9 + C ((1343833471 / 31218 : ℚ)) * X ^ 10 + C ((20276854 / 473 : ℚ)) * X ^ 11 + C ((388921461 / 10406 : ℚ)) * X ^ 12 + C ((976219021 / 31218 : ℚ)) * X ^ 13 + C ((245609733 / 10406 : ℚ)) * X ^ 14 + C ((70254220 / 5203 : ℚ)) * X ^ 15 + C ((38254099 / 5203 : ℚ)) * X ^ 16 + C ((62590259 / 31218 : ℚ)) * X ^ 17 + C ((-19364953 / 15609 : ℚ)) * X ^ 18
def VP29_pim : Polynomial ℚ := C ((-21153973 / 5203 : ℚ)) + C ((-42307946 / 5203 : ℚ)) * X + C ((-51564658 / 5203 : ℚ)) * X ^ 2 + C ((-386446715 / 31218 : ℚ)) * X ^ 3 + C ((-111705963 / 10406 : ℚ)) * X ^ 4 + C ((-201265571 / 31218 : ℚ)) * X ^ 5 + C ((-48589234 / 15609 : ℚ)) * X ^ 6 + C ((30124009 / 10406 : ℚ)) * X ^ 7 + C ((99284551 / 15609 : ℚ)) * X ^ 8 + C ((201129553 / 31218 : ℚ)) * X ^ 9 + C ((212818291 / 31218 : ℚ)) * X ^ 10 + C ((178406686 / 15609 : ℚ)) * X ^ 11 + C ((166936151 / 10406 : ℚ)) * X ^ 12 + C ((189345821 / 10406 : ℚ)) * X ^ 13 + C ((647656681 / 31218 : ℚ)) * X ^ 14 + C ((294460840 / 15609 : ℚ)) * X ^ 15 + C ((220032218 / 15609 : ℚ)) * X ^ 16 + C ((318158671 / 31218 : ℚ)) * X ^ 17 + C ((57801625 / 15609 : ℚ)) * X ^ 18
theorem VP29_pre_eq :
    VA_1_1_re * VP29_Fre - VA_1_1_im * VP29_Fim = VP29_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP29_Fre, VP29_Fim, VP29_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP29_pim_eq :
    VA_1_1_re * VP29_Fim + VA_1_1_im * VP29_Fre = VP29_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VA_1_1_re, VA_1_1_im, VP29_Fre, VP29_Fim, VP29_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP29_mul : VA_1_1 * VP29_F = ofLadj VP29_pre VP29_pim := by
  rw [VA_1_1, VP29_F, ofLadj_mul, VP29_pre_eq, VP29_pim_eq]

def VP30_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def VP30_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def VP30_F : Ki := ofLadj VP30_Fre VP30_Fim
def VP30_pre : Polynomial ℚ := C ((-3148355 / 62436 : ℚ)) + C ((120127042 / 15609 : ℚ)) * X + C ((240301960 / 15609 : ℚ)) * X ^ 2 + C ((783153893 / 31218 : ℚ)) * X ^ 3 + C ((1323833435 / 31218 : ℚ)) * X ^ 4 + C ((3389814047 / 62436 : ℚ)) * X ^ 5 + C ((4087723415 / 62436 : ℚ)) * X ^ 6 + C ((731963547 / 10406 : ℚ)) * X ^ 7 + C ((2044003469 / 31218 : ℚ)) * X ^ 8 + C ((351861043 / 5676 : ℚ)) * X ^ 9 + C ((617434547 / 10406 : ℚ)) * X ^ 10 + C ((165714617 / 2838 : ℚ)) * X ^ 11 + C ((1612049557 / 31218 : ℚ)) * X ^ 12 + C ((2909263633 / 62436 : ℚ)) * X ^ 13 + C ((210141596 / 5203 : ℚ)) * X ^ 14 + C ((1640052503 / 62436 : ℚ)) * X ^ 15 + C ((1016683595 / 62436 : ℚ)) * X ^ 16 + C ((318774227 / 62436 : ℚ)) * X ^ 17 + C ((-34687303 / 20812 : ℚ)) * X ^ 18
def VP30_pim : Polynomial ℚ := C ((-41424199 / 5676 : ℚ)) + C ((-41424199 / 2838 : ℚ)) * X + C ((-392757811 / 20812 : ℚ)) * X ^ 2 + C ((-1615975117 / 62436 : ℚ)) * X ^ 3 + C ((-1625583121 / 62436 : ℚ)) * X ^ 4 + C ((-99469286 / 5203 : ℚ)) * X ^ 5 + C ((-10835537 / 946 : ℚ)) * X ^ 6 + C ((101135707 / 31218 : ℚ)) * X ^ 7 + C ((700742399 / 62436 : ℚ)) * X ^ 8 + C ((1297253 / 121 : ℚ)) * X ^ 9 + C ((262807601 / 31218 : ℚ)) * X ^ 10 + C ((385250197 / 31218 : ℚ)) * X ^ 11 + C ((169230931 / 10406 : ℚ)) * X ^ 12 + C ((379519765 / 20812 : ℚ)) * X ^ 13 + C ((386225282 / 15609 : ℚ)) * X ^ 14 + C ((1645901375 / 62436 : ℚ)) * X ^ 15 + C ((699279677 / 31218 : ℚ)) * X ^ 16 + C ((569942965 / 31218 : ℚ)) * X ^ 17 + C ((67846457 / 10406 : ℚ)) * X ^ 18
theorem VP30_pre_eq :
    VB_0_0_re * VP30_Fre - VB_0_0_im * VP30_Fim = VP30_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP30_Fre, VP30_Fim, VP30_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP30_pim_eq :
    VB_0_0_re * VP30_Fim + VB_0_0_im * VP30_Fre = VP30_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP30_Fre, VP30_Fim, VP30_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP30_mul : VB_0_0 * VP30_F = ofLadj VP30_pre VP30_pim := by
  rw [VB_0_0, VP30_F, ofLadj_mul, VP30_pre_eq, VP30_pim_eq]

def VP31_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def VP31_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def VP31_F : Ki := ofLadj VP31_Fre VP31_Fim
def VP31_pre : Polynomial ℚ := C ((467249 / 15609 : ℚ)) + C ((600635210 / 15609 : ℚ)) * X + C ((2275259299 / 31218 : ℚ)) * X ^ 2 + C ((91106363 / 726 : ℚ)) * X ^ 3 + C ((1065462401 / 5203 : ℚ)) * X ^ 4 + C ((4124878169 / 15609 : ℚ)) * X ^ 5 + C ((10056034889 / 31218 : ℚ)) * X ^ 6 + C ((11513872327 / 31218 : ℚ)) * X ^ 7 + C ((3902099907 / 10406 : ℚ)) * X ^ 8 + C ((6057552904 / 15609 : ℚ)) * X ^ 9 + C ((4142227459 / 10406 : ℚ)) * X ^ 10 + C ((6271188061 / 15609 : ℚ)) * X ^ 11 + C ((11225411957 / 31218 : ℚ)) * X ^ 12 + C ((9839846509 / 31218 : ℚ)) * X ^ 13 + C ((3894363056 / 15609 : ℚ)) * X ^ 14 + C ((1646092969 / 10406 : ℚ)) * X ^ 15 + C ((952682793 / 10406 : ℚ)) * X ^ 16 + C ((525884914 / 15609 : ℚ)) * X ^ 17 + C ((-91409507 / 15609 : ℚ)) * X ^ 18
def VP31_pim : Polynomial ℚ := C ((-554566856 / 15609 : ℚ)) + C ((-1109133712 / 15609 : ℚ)) * X + C ((-999220447 / 10406 : ℚ)) * X ^ 2 + C ((-1403056373 / 10406 : ℚ)) * X ^ 3 + C ((-2202665051 / 15609 : ℚ)) * X ^ 4 + C ((-59338569 / 473 : ℚ)) * X ^ 5 + C ((-3434528203 / 31218 : ℚ)) * X ^ 6 + C ((-2045078015 / 31218 : ℚ)) * X ^ 7 + C ((-349759093 / 10406 : ℚ)) * X ^ 8 + C ((-165047076 / 5203 : ℚ)) * X ^ 9 + C ((-720127589 / 31218 : ℚ)) * X ^ 10 + C ((130840681 / 5203 : ℚ)) * X ^ 11 + C ((2290215761 / 31218 : ℚ)) * X ^ 12 + C ((3339764545 / 31218 : ℚ)) * X ^ 13 + C ((2305133573 / 15609 : ℚ)) * X ^ 14 + C ((421332595 / 2838 : ℚ)) * X ^ 15 + C ((88343945 / 726 : ℚ)) * X ^ 16 + C ((483984145 / 5203 : ℚ)) * X ^ 17 + C ((583785160 / 15609 : ℚ)) * X ^ 18
theorem VP31_pre_eq :
    VB_0_0_re * VP31_Fre - VB_0_0_im * VP31_Fim = VP31_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP31_Fre, VP31_Fim, VP31_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP31_pim_eq :
    VB_0_0_re * VP31_Fim + VB_0_0_im * VP31_Fre = VP31_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP31_Fre, VP31_Fim, VP31_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP31_mul : VB_0_0 * VP31_F = ofLadj VP31_pre VP31_pim := by
  rw [VB_0_0, VP31_F, ofLadj_mul, VP31_pre_eq, VP31_pim_eq]

def VP32_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP32_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP32_F : Ki := ofLadj VP32_Fre VP32_Fim
def VP32_pre : Polynomial ℚ := C ((88988353 / 15609 : ℚ)) + C ((1201270420 / 15609 : ℚ)) * X + C ((2444543005 / 15609 : ℚ)) * X ^ 2 + C ((365215654 / 1419 : ℚ)) * X ^ 3 + C ((1993552075 / 5203 : ℚ)) * X ^ 4 + C ((2369280702 / 5203 : ℚ)) * X ^ 5 + C ((8014455452 / 15609 : ℚ)) * X ^ 6 + C ((17026084453 / 31218 : ℚ)) * X ^ 7 + C ((8110352654 / 15609 : ℚ)) * X ^ 8 + C ((15914132735 / 31218 : ℚ)) * X ^ 9 + C ((237575424 / 473 : ℚ)) * X ^ 10 + C ((7707382217 / 15609 : ℚ)) * X ^ 11 + C ((154388804 / 363 : ℚ)) * X ^ 12 + C ((334092325 / 946 : ℚ)) * X ^ 13 + C ((1364326820 / 5203 : ℚ)) * X ^ 14 + C ((4541192555 / 31218 : ℚ)) * X ^ 15 + C ((111559109 / 1419 : ℚ)) * X ^ 16 + C ((320536853 / 15609 : ℚ)) * X ^ 17 + C ((-261789724 / 15609 : ℚ)) * X ^ 18
def VP32_pim : Polynomial ℚ := C ((-24509579 / 473 : ℚ)) + C ((-49019158 / 473 : ℚ)) * X + C ((-174511940 / 1419 : ℚ)) * X ^ 2 + C ((-205475975 / 1419 : ℚ)) * X ^ 3 + C ((-1700732018 / 15609 : ℚ)) * X ^ 4 + C ((-591817273 / 15609 : ℚ)) * X ^ 5 + C ((98872219 / 5203 : ℚ)) * X ^ 6 + C ((1067606867 / 10406 : ℚ)) * X ^ 7 + C ((2350527859 / 15609 : ℚ)) * X ^ 8 + C ((1552330291 / 10406 : ℚ)) * X ^ 9 + C ((2227060634 / 15609 : ℚ)) * X ^ 10 + C ((2887267321 / 15609 : ℚ)) * X ^ 11 + C ((1182491336 / 5203 : ℚ)) * X ^ 12 + C ((2498692221 / 10406 : ℚ)) * X ^ 13 + C ((4066610294 / 15609 : ℚ)) * X ^ 14 + C ((2380955583 / 10406 : ℚ)) * X ^ 15 + C ((2592830065 / 15609 : ℚ)) * X ^ 16 + C ((1859272979 / 15609 : ℚ)) * X ^ 17 + C ((684790771 / 15609 : ℚ)) * X ^ 18
theorem VP32_pre_eq :
    VB_0_0_re * VP32_Fre - VB_0_0_im * VP32_Fim = VP32_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP32_Fre, VP32_Fim, VP32_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP32_pim_eq :
    VB_0_0_re * VP32_Fim + VB_0_0_im * VP32_Fre = VP32_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP32_Fre, VP32_Fim, VP32_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP32_mul : VB_0_0 * VP32_F = ofLadj VP32_pre VP32_pim := by
  rw [VB_0_0, VP32_F, ofLadj_mul, VP32_pre_eq, VP32_pim_eq]

def VP33_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def VP33_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def VP33_F : Ki := ofLadj VP33_Fre VP33_Fim
def VP33_pre : Polynomial ℚ := C ((-24841979 / 10406 : ℚ)) + C ((-120127042 / 5203 : ℚ)) * X + C ((-209199874 / 5203 : ℚ)) * X ^ 2 + C ((-675670491 / 10406 : ℚ)) * X ^ 3 + C ((-1020751899 / 10406 : ℚ)) * X ^ 4 + C ((-105517011 / 946 : ℚ)) * X ^ 5 + C ((-121014961 / 946 : ℚ)) * X ^ 6 + C ((-1527818241 / 10406 : ℚ)) * X ^ 7 + C ((-71108189 / 473 : ℚ)) * X ^ 8 + C ((-843269753 / 5203 : ℚ)) * X ^ 9 + C ((-1779806717 / 10406 : ℚ)) * X ^ 10 + C ((-894863895 / 5203 : ℚ)) * X ^ 11 + C ((-1539552633 / 10406 : ℚ)) * X ^ 12 + C ((-634069879 / 5203 : ℚ)) * X ^ 13 + C ((-888709667 / 10406 : ℚ)) * X ^ 14 + C ((-431365535 / 10406 : ℚ)) * X ^ 15 + C ((-224717985 / 10406 : ℚ)) * X ^ 16 + C ((-54240535 / 10406 : ℚ)) * X ^ 17 + C ((75700807 / 10406 : ℚ)) * X ^ 18
def VP33_pim : Polynomial ℚ := C ((137737813 / 10406 : ℚ)) + C ((137737813 / 5203 : ℚ)) * X + C ((7381259 / 242 : ℚ)) * X ^ 2 + C ((205790184 / 5203 : ℚ)) * X ^ 3 + C ((309545415 / 10406 : ℚ)) * X ^ 4 + C ((139419565 / 10406 : ℚ)) * X ^ 5 + C ((93795715 / 10406 : ℚ)) * X ^ 6 + C ((-3597640 / 473 : ℚ)) * X ^ 7 + C ((-210903899 / 10406 : ℚ)) * X ^ 8 + C ((-114234855 / 5203 : ℚ)) * X ^ 9 + C ((-28117879 / 946 : ℚ)) * X ^ 10 + C ((-282720380 / 5203 : ℚ)) * X ^ 11 + C ((-821584851 / 10406 : ℚ)) * X ^ 12 + C ((-85848211 / 946 : ℚ)) * X ^ 13 + C ((-1056082363 / 10406 : ℚ)) * X ^ 14 + C ((-451385305 / 5203 : ℚ)) * X ^ 15 + C ((-628822721 / 10406 : ℚ)) * X ^ 16 + C ((-459798453 / 10406 : ℚ)) * X ^ 17 + C ((-16639329 / 946 : ℚ)) * X ^ 18
theorem VP33_pre_eq :
    VB_0_0_re * VP33_Fre - VB_0_0_im * VP33_Fim = VP33_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP33_Fre, VP33_Fim, VP33_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP33_pim_eq :
    VB_0_0_re * VP33_Fim + VB_0_0_im * VP33_Fre = VP33_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP33_Fre, VP33_Fim, VP33_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP33_mul : VB_0_0 * VP33_F = ofLadj VP33_pre VP33_pim := by
  rw [VB_0_0, VP33_F, ofLadj_mul, VP33_pre_eq, VP33_pim_eq]

def VP34_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def VP34_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def VP34_F : Ki := ofLadj VP34_Fre VP34_Fim
def VP34_pre : Polynomial ℚ := C ((-242123080 / 15609 : ℚ)) + C ((-3363557176 / 15609 : ℚ)) * X + C ((-155231981 / 363 : ℚ)) * X ^ 2 + C ((-10938390673 / 15609 : ℚ)) * X ^ 3 + C ((-16311876134 / 15609 : ℚ)) * X ^ 4 + C ((-1766335963 / 1419 : ℚ)) * X ^ 5 + C ((-7325717965 / 5203 : ℚ)) * X ^ 6 + C ((-23508721504 / 15609 : ℚ)) * X ^ 7 + C ((-22402247699 / 15609 : ℚ)) * X ^ 8 + C ((-22149263500 / 15609 : ℚ)) * X ^ 9 + C ((-7318590152 / 5203 : ℚ)) * X ^ 10 + C ((-21641778118 / 15609 : ℚ)) * X ^ 11 + C ((-18592213280 / 15609 : ℚ)) * X ^ 12 + C ((-15474288317 / 15609 : ℚ)) * X ^ 13 + C ((-11463857026 / 15609 : ℚ)) * X ^ 14 + C ((-2107707663 / 5203 : ℚ)) * X ^ 15 + C ((-3343546307 / 15609 : ℚ)) * X ^ 16 + C ((-796088005 / 15609 : ℚ)) * X ^ 17 + C ((873722381 / 15609 : ℚ)) * X ^ 18
def VP34_pim : Polynomial ℚ := C ((2288710508 / 15609 : ℚ)) + C ((4577421016 / 15609 : ℚ)) * X + C ((5371056799 / 15609 : ℚ)) * X ^ 2 + C ((6446801099 / 15609 : ℚ)) * X ^ 3 + C ((4946787917 / 15609 : ℚ)) * X ^ 4 + C ((1907892049 / 15609 : ℚ)) * X ^ 5 + C ((-566775833 / 15609 : ℚ)) * X ^ 6 + C ((-1423426775 / 5203 : ℚ)) * X ^ 7 + C ((-6437046259 / 15609 : ℚ)) * X ^ 8 + C ((-6400789613 / 15609 : ℚ)) * X ^ 9 + C ((-6233213563 / 15609 : ℚ)) * X ^ 10 + C ((-8276551766 / 15609 : ℚ)) * X ^ 11 + C ((-3439963323 / 5203 : ℚ)) * X ^ 12 + C ((-10945949702 / 15609 : ℚ)) * X ^ 13 + C ((-11985437356 / 15609 : ℚ)) * X ^ 14 + C ((-82104586 / 121 : ℚ)) * X ^ 15 + C ((-7767954265 / 15609 : ℚ)) * X ^ 16 + C ((-5548844467 / 15609 : ℚ)) * X ^ 17 + C ((-2060698514 / 15609 : ℚ)) * X ^ 18
theorem VP34_pre_eq :
    VB_0_0_re * VP34_Fre - VB_0_0_im * VP34_Fim = VP34_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP34_Fre, VP34_Fim, VP34_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP34_pim_eq :
    VB_0_0_re * VP34_Fim + VB_0_0_im * VP34_Fre = VP34_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP34_Fre, VP34_Fim, VP34_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP34_mul : VB_0_0 * VP34_F = ofLadj VP34_pre VP34_pim := by
  rw [VB_0_0, VP34_F, ofLadj_mul, VP34_pre_eq, VP34_pim_eq]

def VP35_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def VP35_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def VP35_F : Ki := ofLadj VP35_Fre VP35_Fim
def VP35_pre : Polynomial ℚ := C ((-10379563 / 31218 : ℚ)) + C ((120127042 / 15609 : ℚ)) * X + C ((85513193 / 5203 : ℚ)) * X ^ 2 + C ((146105802 / 5203 : ℚ)) * X ^ 3 + C ((465237071 / 10406 : ℚ)) * X ^ 4 + C ((903008011 / 15609 : ℚ)) * X ^ 5 + C ((1063397261 / 15609 : ℚ)) * X ^ 6 + C ((67330333 / 946 : ℚ)) * X ^ 7 + C ((1003939402 / 15609 : ℚ)) * X ^ 8 + C ((1857428239 / 31218 : ℚ)) * X ^ 9 + C ((580826353 / 10406 : ℚ)) * X ^ 10 + C ((77730805 / 1419 : ℚ)) * X ^ 11 + C ((1502224975 / 31218 : ℚ)) * X ^ 12 + C ((1344349081 / 31218 : ℚ)) * X ^ 13 + C ((565621996 / 15609 : ℚ)) * X ^ 14 + C ((750488969 / 31218 : ℚ)) * X ^ 15 + C ((211179370 / 15609 : ℚ)) * X ^ 16 + C ((16930040 / 5203 : ℚ)) * X ^ 17 + C ((-75700807 / 31218 : ℚ)) * X ^ 18
def VP35_pim : Polynomial ℚ := C ((-257864855 / 31218 : ℚ)) + C ((-257864855 / 15609 : ℚ)) * X + C ((-639675229 / 31218 : ℚ)) * X ^ 2 + C ((-811715587 / 31218 : ℚ)) * X ^ 3 + C ((-795438953 / 31218 : ℚ)) * X ^ 4 + C ((-560940157 / 31218 : ℚ)) * X ^ 5 + C ((-79126467 / 10406 : ℚ)) * X ^ 6 + C ((104173169 / 15609 : ℚ)) * X ^ 7 + C ((151503163 / 10406 : ℚ)) * X ^ 8 + C ((432904001 / 31218 : ℚ)) * X ^ 9 + C ((166655591 / 15609 : ℚ)) * X ^ 10 + C ((74218953 / 5203 : ℚ)) * X ^ 11 + C ((25332557 / 1419 : ℚ)) * X ^ 12 + C ((290834477 / 15609 : ℚ)) * X ^ 13 + C ((122017304 / 5203 : ℚ)) * X ^ 14 + C ((129826287 / 5203 : ℚ)) * X ^ 15 + C ((20375919 / 946 : ℚ)) * X ^ 16 + C ((166937319 / 10406 : ℚ)) * X ^ 17 + C ((5546443 / 946 : ℚ)) * X ^ 18
theorem VP35_pre_eq :
    VB_0_0_re * VP35_Fre - VB_0_0_im * VP35_Fim = VP35_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP35_Fre, VP35_Fim, VP35_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP35_pim_eq :
    VB_0_0_re * VP35_Fim + VB_0_0_im * VP35_Fre = VP35_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_0_re, VB_0_0_im, VP35_Fre, VP35_Fim, VP35_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP35_mul : VB_0_0 * VP35_F = ofLadj VP35_pre VP35_pim := by
  rw [VB_0_0, VP35_F, ofLadj_mul, VP35_pre_eq, VP35_pim_eq]

def VP36_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def VP36_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def VP36_F : Ki := ofLadj VP36_Fre VP36_Fim
def VP36_pre : Polynomial ℚ := C ((1348997 / 20812 : ℚ)) + C ((-49577102 / 5203 : ℚ)) * X + C ((-54078997 / 2838 : ℚ)) * X ^ 2 + C ((-645868879 / 20812 : ℚ)) * X ^ 3 + C ((-3276403873 / 62436 : ℚ)) * X ^ 4 + C ((-381368939 / 5676 : ℚ)) * X ^ 5 + C ((-2528922973 / 31218 : ℚ)) * X ^ 6 + C ((-1811389719 / 20812 : ℚ)) * X ^ 7 + C ((-5058723025 / 62436 : ℚ)) * X ^ 8 + C ((-4789834807 / 62436 : ℚ)) * X ^ 9 + C ((-1528129565 / 20812 : ℚ)) * X ^ 10 + C ((-2255932601 / 31218 : ℚ)) * X ^ 11 + C ((-1329821157 / 20812 : ℚ)) * X ^ 12 + C ((-1200032291 / 20812 : ℚ)) * X ^ 13 + C ((-780279097 / 15609 : ℚ)) * X ^ 14 + C ((-2029521521 / 62436 : ℚ)) * X ^ 15 + C ((-314465948 / 15609 : ℚ)) * X ^ 16 + C ((-395076175 / 62436 : ℚ)) * X ^ 17 + C ((42747921 / 20812 : ℚ)) * X ^ 18
def VP36_pim : Polynomial ℚ := C ((188070171 / 20812 : ℚ)) + C ((188070171 / 10406 : ℚ)) * X + C ((22092193 / 946 : ℚ)) * X ^ 2 + C ((666753927 / 20812 : ℚ)) * X ^ 3 + C ((2012752883 / 62436 : ℚ)) * X ^ 4 + C ((1477657361 / 62436 : ℚ)) * X ^ 5 + C ((221387467 / 15609 : ℚ)) * X ^ 6 + C ((-248660855 / 62436 : ℚ)) * X ^ 7 + C ((-865306439 / 62436 : ℚ)) * X ^ 8 + C ((-275496457 / 20812 : ℚ)) * X ^ 9 + C ((-58972477 / 5676 : ℚ)) * X ^ 10 + C ((-476041849 / 31218 : ℚ)) * X ^ 11 + C ((-1255470149 / 62436 : ℚ)) * X ^ 12 + C ((-1407341737 / 62436 : ℚ)) * X ^ 13 + C ((-477675428 / 15609 : ℚ)) * X ^ 14 + C ((-16828159 / 516 : ℚ)) * X ^ 15 + C ((-432371011 / 15609 : ℚ)) * X ^ 16 + C ((-469823185 / 20812 : ℚ)) * X ^ 17 + C ((-167877053 / 20812 : ℚ)) * X ^ 18
theorem VP36_pre_eq :
    VB_1_0_re * VP36_Fre - VB_1_0_im * VP36_Fim = VP36_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP36_Fre, VP36_Fim, VP36_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP36_pim_eq :
    VB_1_0_re * VP36_Fim + VB_1_0_im * VP36_Fre = VP36_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP36_Fre, VP36_Fim, VP36_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP36_mul : VB_1_0 * VP36_F = ofLadj VP36_pre VP36_pim := by
  rw [VB_1_0, VP36_F, ofLadj_mul, VP36_pre_eq, VP36_pim_eq]

def VP37_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def VP37_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def VP37_F : Ki := ofLadj VP37_Fre VP37_Fim
def VP37_pre : Polynomial ℚ := C ((-132543 / 5203 : ℚ)) + C ((-247885510 / 5203 : ℚ)) * X + C ((-469352481 / 5203 : ℚ)) * X ^ 2 + C ((-2423171569 / 15609 : ℚ)) * X ^ 3 + C ((-3955397101 / 15609 : ℚ)) * X ^ 4 + C ((-5104448119 / 15609 : ℚ)) * X ^ 5 + C ((-6221234612 / 15609 : ℚ)) * X ^ 6 + C ((-7123305326 / 15609 : ℚ)) * X ^ 7 + C ((-7243012408 / 15609 : ℚ)) * X ^ 8 + C ((-227140959 / 473 : ℚ)) * X ^ 9 + C ((-2562866481 / 5203 : ℚ)) * X ^ 10 + C ((-7760464289 / 15609 : ℚ)) * X ^ 11 + C ((-2314980971 / 5203 : ℚ)) * X ^ 12 + C ((-2029198068 / 5203 : ℚ)) * X ^ 13 + C ((-146055783 / 473 : ℚ)) * X ^ 14 + C ((-1018505926 / 5203 : ℚ)) * X ^ 15 + C ((-589391608 / 5203 : ℚ)) * X ^ 16 + C ((-59217121 / 1419 : ℚ)) * X ^ 17 + C ((112390447 / 15609 : ℚ)) * X ^ 18
def VP37_pim : Polynomial ℚ := C ((228890576 / 5203 : ℚ)) + C ((457781152 / 5203 : ℚ)) * X + C ((1854798782 / 15609 : ℚ)) * X ^ 2 + C ((868382810 / 5203 : ℚ)) * X ^ 3 + C ((2727094525 / 15609 : ℚ)) * X ^ 4 + C ((2424106130 / 15609 : ℚ)) * X ^ 5 + C ((708702252 / 5203 : ℚ)) * X ^ 6 + C ((422570957 / 5203 : ℚ)) * X ^ 7 + C ((651452668 / 15609 : ℚ)) * X ^ 8 + C ((18641384 / 473 : ℚ)) * X ^ 9 + C ((448178953 / 15609 : ℚ)) * X ^ 10 + C ((-483630919 / 15609 : ℚ)) * X ^ 11 + C ((-471813597 / 5203 : ℚ)) * X ^ 12 + C ((-2063882836 / 15609 : ℚ)) * X ^ 13 + C ((-950173160 / 5203 : ℚ)) * X ^ 14 + C ((-86864939 / 473 : ℚ)) * X ^ 15 + C ((-2348868811 / 15609 : ℚ)) * X ^ 16 + C ((-598420819 / 5203 : ℚ)) * X ^ 17 + C ((-21884327 / 473 : ℚ)) * X ^ 18
theorem VP37_pre_eq :
    VB_1_0_re * VP37_Fre - VB_1_0_im * VP37_Fim = VP37_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP37_Fre, VP37_Fim, VP37_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP37_pim_eq :
    VB_1_0_re * VP37_Fim + VB_1_0_im * VP37_Fre = VP37_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP37_Fre, VP37_Fim, VP37_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP37_mul : VB_1_0 * VP37_F = ofLadj VP37_pre VP37_pim := by
  rw [VB_1_0, VP37_F, ofLadj_mul, VP37_pre_eq, VP37_pim_eq]

def VP38_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP38_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP38_F : Ki := ofLadj VP38_Fre VP38_Fim
def VP38_pre : Polynomial ℚ := C ((-36640871 / 5203 : ℚ)) + C ((-495771020 / 5203 : ℚ)) * X + C ((-3025889792 / 15609 : ℚ)) * X ^ 2 + C ((-4970641966 / 15609 : ℚ)) * X ^ 3 + C ((-7401030595 / 15609 : ℚ)) * X ^ 4 + C ((-8796227837 / 15609 : ℚ)) * X ^ 5 + C ((-3305737064 / 5203 : ℚ)) * X ^ 6 + C ((-10534484438 / 15609 : ℚ)) * X ^ 7 + C ((-10037084360 / 15609 : ℚ)) * X ^ 8 + C ((-9847346125 / 15609 : ℚ)) * X ^ 9 + C ((-9702518186 / 15609 : ℚ)) * X ^ 10 + C ((-9538776631 / 15609 : ℚ)) * X ^ 11 + C ((-191051282 / 363 : ℚ)) * X ^ 12 + C ((-6821456333 / 15609 : ℚ)) * X ^ 13 + C ((-5066442394 / 15609 : ℚ)) * X ^ 14 + C ((-255494402 / 1419 : ℚ)) * X ^ 15 + C ((-1518698191 / 15609 : ℚ)) * X ^ 16 + C ((-132571612 / 5203 : ℚ)) * X ^ 17 + C ((107671807 / 5203 : ℚ)) * X ^ 18
def VP38_pim : Polynomial ℚ := C ((333838397 / 5203 : ℚ)) + C ((667676794 / 5203 : ℚ)) * X + C ((2375501576 / 15609 : ℚ)) * X ^ 2 + C ((932626360 / 5203 : ℚ)) * X ^ 3 + C ((2106647371 / 15609 : ℚ)) * X ^ 4 + C ((733951132 / 15609 : ℚ)) * X ^ 5 + C ((-365211949 / 15609 : ℚ)) * X ^ 6 + C ((-659395255 / 5203 : ℚ)) * X ^ 7 + C ((-2905270814 / 15609 : ℚ)) * X ^ 8 + C ((-2877913829 / 15609 : ℚ)) * X ^ 9 + C ((-2752336612 / 15609 : ℚ)) * X ^ 10 + C ((-3570059693 / 15609 : ℚ)) * X ^ 11 + C ((-1462594258 / 5203 : ℚ)) * X ^ 12 + C ((-4634676751 / 15609 : ℚ)) * X ^ 13 + C ((-5029697270 / 15609 : ℚ)) * X ^ 14 + C ((-1472746229 / 5203 : ℚ)) * X ^ 15 + C ((-1068906405 / 5203 : ℚ)) * X ^ 16 + C ((-2299108972 / 15609 : ℚ)) * X ^ 17 + C ((-847311923 / 15609 : ℚ)) * X ^ 18
theorem VP38_pre_eq :
    VB_1_0_re * VP38_Fre - VB_1_0_im * VP38_Fim = VP38_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP38_Fre, VP38_Fim, VP38_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP38_pim_eq :
    VB_1_0_re * VP38_Fim + VB_1_0_im * VP38_Fre = VP38_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP38_Fre, VP38_Fim, VP38_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP38_mul : VB_1_0 * VP38_F = ofLadj VP38_pre VP38_pim := by
  rw [VB_1_0, VP38_F, ofLadj_mul, VP38_pre_eq, VP38_pim_eq]

def VP39_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def VP39_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def VP39_F : Ki := ofLadj VP39_Fre VP39_Fim
def VP39_pre : Polynomial ℚ := C ((30714711 / 10406 : ℚ)) + C ((148731306 / 5203 : ℚ)) * X + C ((517879847 / 10406 : ℚ)) * X ^ 2 + C ((835940889 / 10406 : ℚ)) * X ^ 3 + C ((1263234559 / 10406 : ℚ)) * X ^ 4 + C ((718173648 / 5203 : ℚ)) * X ^ 5 + C ((823556126 / 5203 : ℚ)) * X ^ 6 + C ((945352195 / 5203 : ℚ)) * X ^ 7 + C ((1936110339 / 10406 : ℚ)) * X ^ 8 + C ((2087010623 / 10406 : ℚ)) * X ^ 9 + C ((1101275437 / 5203 : ℚ)) * X ^ 10 + C ((1107512444 / 5203 : ℚ)) * X ^ 11 + C ((86594921 / 473 : ℚ)) * X ^ 12 + C ((784565388 / 5203 : ℚ)) * X ^ 13 + C ((550084725 / 5203 : ℚ)) * X ^ 14 + C ((534047331 / 10406 : ℚ)) * X ^ 15 + C ((139071995 / 5203 : ℚ)) * X ^ 16 + C ((33689517 / 5203 : ℚ)) * X ^ 17 + C ((-46711250 / 5203 : ℚ)) * X ^ 18
def VP39_pim : Polynomial ℚ := C ((-170556777 / 10406 : ℚ)) + C ((-170556777 / 5203 : ℚ)) * X + C ((-392750715 / 10406 : ℚ)) * X ^ 2 + C ((-509526327 / 10406 : ℚ)) * X ^ 3 + C ((-383434325 / 10406 : ℚ)) * X ^ 4 + C ((-86359677 / 5203 : ℚ)) * X ^ 5 + C ((-58238819 / 5203 : ℚ)) * X ^ 6 + C ((48612825 / 5203 : ℚ)) * X ^ 7 + C ((260499975 / 10406 : ℚ)) * X ^ 8 + C ((282139175 / 10406 : ℚ)) * X ^ 9 + C ((190958740 / 5203 : ℚ)) * X ^ 10 + C ((349569404 / 5203 : ℚ)) * X ^ 11 + C ((46198188 / 473 : ℚ)) * X ^ 12 + C ((583887801 / 5203 : ℚ)) * X ^ 13 + C ((653095207 / 5203 : ℚ)) * X ^ 14 + C ((1116894447 / 10406 : ℚ)) * X ^ 15 + C ((388887083 / 5203 : ℚ)) * X ^ 16 + C ((284293444 / 5203 : ℚ)) * X ^ 17 + C ((113239145 / 5203 : ℚ)) * X ^ 18
theorem VP39_pre_eq :
    VB_1_0_re * VP39_Fre - VB_1_0_im * VP39_Fim = VP39_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP39_Fre, VP39_Fim, VP39_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP39_pim_eq :
    VB_1_0_re * VP39_Fim + VB_1_0_im * VP39_Fre = VP39_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP39_Fre, VP39_Fim, VP39_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP39_mul : VB_1_0 * VP39_F = ofLadj VP39_pre VP39_pim := by
  rw [VB_1_0, VP39_F, ofLadj_mul, VP39_pre_eq, VP39_pim_eq]

def VP40_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def VP40_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def VP40_F : Ki := ofLadj VP40_Fre VP40_Fim
def VP40_pre : Polynomial ℚ := C ((9062216 / 473 : ℚ)) + C ((1388158856 / 5203 : ℚ)) * X + C ((8262326917 / 15609 : ℚ)) * X ^ 2 + C ((4511199989 / 5203 : ℚ)) * X ^ 3 + C ((20185884628 / 15609 : ℚ)) * X ^ 4 + C ((728636430 / 473 : ℚ)) * X ^ 5 + C ((27194750719 / 15609 : ℚ)) * X ^ 6 + C ((29090751982 / 15609 : ℚ)) * X ^ 7 + C ((27724436552 / 15609 : ℚ)) * X ^ 8 + C ((9136982187 / 5203 : ℚ)) * X ^ 9 + C ((9057304261 / 5203 : ℚ)) * X ^ 10 + C ((8928030806 / 5203 : ℚ)) * X ^ 11 + C ((7669145405 / 5203 : ℚ)) * X ^ 12 + C ((1740783604 / 1419 : ℚ)) * X ^ 13 + C ((14190836585 / 15609 : ℚ)) * X ^ 14 + C ((2608848425 / 5203 : ℚ)) * X ^ 15 + C ((376191509 / 1419 : ℚ)) * X ^ 16 + C ((329452690 / 5203 : ℚ)) * X ^ 17 + C ((-359440693 / 5203 : ℚ)) * X ^ 18
def VP40_pim : Polynomial ℚ := C ((-944662932 / 5203 : ℚ)) + C ((-1889325864 / 5203 : ℚ)) * X + C ((-2215484043 / 5203 : ℚ)) * X ^ 2 + C ((-2660100679 / 5203 : ℚ)) * X ^ 3 + C ((-2042420598 / 5203 : ℚ)) * X ^ 4 + C ((-2365136416 / 15609 : ℚ)) * X ^ 5 + C ((696521569 / 15609 : ℚ)) * X ^ 6 + C ((5274649478 / 15609 : ℚ)) * X ^ 7 + C ((241096762 / 473 : ℚ)) * X ^ 8 + C ((7911107929 / 15609 : ℚ)) * X ^ 9 + C ((7703484479 / 15609 : ℚ)) * X ^ 10 + C ((10234137230 / 15609 : ℚ)) * X ^ 11 + C ((12764789981 / 15609 : ℚ)) * X ^ 12 + C ((4511880356 / 5203 : ℚ)) * X ^ 13 + C ((14824405759 / 15609 : ℚ)) * X ^ 14 + C ((13103046757 / 15609 : ℚ)) * X ^ 15 + C ((9607342445 / 15609 : ℚ)) * X ^ 16 + C ((6861569270 / 15609 : ℚ)) * X ^ 17 + C ((2549862427 / 15609 : ℚ)) * X ^ 18
theorem VP40_pre_eq :
    VB_1_0_re * VP40_Fre - VB_1_0_im * VP40_Fim = VP40_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP40_Fre, VP40_Fim, VP40_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP40_pim_eq :
    VB_1_0_re * VP40_Fim + VB_1_0_im * VP40_Fre = VP40_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP40_Fre, VP40_Fim, VP40_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP40_mul : VB_1_0 * VP40_F = ofLadj VP40_pre VP40_pim := by
  rw [VB_1_0, VP40_F, ofLadj_mul, VP40_pre_eq, VP40_pim_eq]

def VP41_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def VP41_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def VP41_F : Ki := ofLadj VP41_Fre VP41_Fim
def VP41_pre : Polynomial ℚ := C ((35637 / 86 : ℚ)) + C ((-49577102 / 5203 : ℚ)) * X + C ((-211694107 / 10406 : ℚ)) * X ^ 2 + C ((-12610388 / 363 : ℚ)) * X ^ 3 + C ((-1727086651 / 31218 : ℚ)) * X ^ 4 + C ((-2235042661 / 31218 : ℚ)) * X ^ 5 + C ((-2631671171 / 31218 : ℚ)) * X ^ 6 + C ((-916381853 / 10406 : ℚ)) * X ^ 7 + C ((-828216223 / 10406 : ℚ)) * X ^ 8 + C ((-383120591 / 5203 : ℚ)) * X ^ 9 + C ((-359400157 / 5203 : ℚ)) * X ^ 10 + C ((-1058112391 / 15609 : ℚ)) * X ^ 11 + C ((-309823055 / 5203 : ℚ)) * X ^ 12 + C ((-554547075 / 10406 : ℚ)) * X ^ 13 + C ((-1400155301 / 31218 : ℚ)) * X ^ 14 + C ((-464318204 / 15609 : ℚ)) * X ^ 15 + C ((-174202927 / 10406 : ℚ)) * X ^ 16 + C ((-125980271 / 31218 : ℚ)) * X ^ 17 + C ((46711250 / 15609 : ℚ)) * X ^ 18
def VP41_pim : Polynomial ℚ := C ((106429361 / 10406 : ℚ)) + C ((106429361 / 5203 : ℚ)) * X + C ((791562485 / 31218 : ℚ)) * X ^ 2 + C ((167449367 / 5203 : ℚ)) * X ^ 3 + C ((984895433 / 31218 : ℚ)) * X ^ 4 + C ((694558565 / 31218 : ℚ)) * X ^ 5 + C ((293982377 / 31218 : ℚ)) * X ^ 6 + C ((-257017487 / 31218 : ℚ)) * X ^ 7 + C ((-561405875 / 31218 : ℚ)) * X ^ 8 + C ((-89123813 / 5203 : ℚ)) * X ^ 9 + C ((-205877260 / 15609 : ℚ)) * X ^ 10 + C ((-275203751 / 15609 : ℚ)) * X ^ 11 + C ((-114843414 / 5203 : ℚ)) * X ^ 12 + C ((-719058445 / 31218 : ℚ)) * X ^ 13 + C ((-301843055 / 10406 : ℚ)) * X ^ 14 + C ((-481819247 / 15609 : ℚ)) * X ^ 15 + C ((-277172771 / 10406 : ℚ)) * X ^ 16 + C ((-18765499 / 946 : ℚ)) * X ^ 17 + C ((-113239145 / 15609 : ℚ)) * X ^ 18
theorem VP41_pre_eq :
    VB_1_0_re * VP41_Fre - VB_1_0_im * VP41_Fim = VP41_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP41_Fre, VP41_Fim, VP41_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP41_pim_eq :
    VB_1_0_re * VP41_Fim + VB_1_0_im * VP41_Fre = VP41_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_0_re, VB_1_0_im, VP41_Fre, VP41_Fim, VP41_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP41_mul : VB_1_0 * VP41_F = ofLadj VP41_pre VP41_pim := by
  rw [VB_1_0, VP41_F, ofLadj_mul, VP41_pre_eq, VP41_pim_eq]

def VP42_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def VP42_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def VP42_F : Ki := ofLadj VP42_Fre VP42_Fim
def VP42_pre : Polynomial ℚ := C ((31793 / 2838 : ℚ)) + C ((-23071336 / 15609 : ℚ)) * X + C ((-1073845 / 363 : ℚ)) * X ^ 2 + C ((-75324001 / 15609 : ℚ)) * X ^ 3 + C ((-127301549 / 15609 : ℚ)) * X ^ 4 + C ((-325860395 / 31218 : ℚ)) * X ^ 5 + C ((-65510606 / 5203 : ℚ)) * X ^ 6 + C ((-211136074 / 15609 : ℚ)) * X ^ 7 + C ((-65503125 / 5203 : ℚ)) * X ^ 8 + C ((-124036025 / 10406 : ℚ)) * X ^ 9 + C ((-8282191 / 726 : ℚ)) * X ^ 10 + C ((-58425223 / 5203 : ℚ)) * X ^ 11 + C ((-309991541 / 31218 : ℚ)) * X ^ 12 + C ((-279757405 / 31218 : ℚ)) * X ^ 13 + C ((-121185374 / 15609 : ℚ)) * X ^ 14 + C ((-157639171 / 31218 : ℚ)) * X ^ 15 + C ((-97792931 / 31218 : ℚ)) * X ^ 16 + C ((-15294845 / 15609 : ℚ)) * X ^ 17 + C ((77751 / 242 : ℚ)) * X ^ 18
def VP42_pim : Polynomial ℚ := C ((21885332 / 15609 : ℚ)) + C ((43770664 / 15609 : ℚ)) * X + C ((56594074 / 15609 : ℚ)) * X ^ 2 + C ((25880990 / 5203 : ℚ)) * X ^ 3 + C ((156119423 / 31218 : ℚ)) * X ^ 4 + C ((1737477 / 473 : ℚ)) * X ^ 5 + C ((68655373 / 31218 : ℚ)) * X ^ 6 + C ((-6583389 / 10406 : ℚ)) * X ^ 7 + C ((-33842374 / 15609 : ℚ)) * X ^ 8 + C ((-10781006 / 5203 : ℚ)) * X ^ 9 + C ((-8473438 / 5203 : ℚ)) * X ^ 10 + C ((-37172396 / 15609 : ℚ)) * X ^ 11 + C ((-48924478 / 15609 : ℚ)) * X ^ 12 + C ((-54825184 / 15609 : ℚ)) * X ^ 13 + C ((-74374724 / 15609 : ℚ)) * X ^ 14 + C ((-7198010 / 1419 : ℚ)) * X ^ 15 + C ((-134698987 / 31218 : ℚ)) * X ^ 16 + C ((-18296354 / 5203 : ℚ)) * X ^ 17 + C ((-6526882 / 5203 : ℚ)) * X ^ 18
theorem VP42_pre_eq :
    VB_0_1_re * VP42_Fre - VB_0_1_im * VP42_Fim = VP42_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP42_Fre, VP42_Fim, VP42_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP42_pim_eq :
    VB_0_1_re * VP42_Fim + VB_0_1_im * VP42_Fre = VP42_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP42_Fre, VP42_Fim, VP42_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP42_mul : VB_0_1 * VP42_F = ofLadj VP42_pre VP42_pim := by
  rw [VB_0_1, VP42_F, ofLadj_mul, VP42_pre_eq, VP42_pim_eq]

def VP43_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def VP43_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def VP43_F : Ki := ofLadj VP43_Fre VP43_Fim
def VP43_pre : Polynomial ℚ := C ((25351 / 15609 : ℚ)) + C ((-115356680 / 15609 : ℚ)) * X + C ((-72862545 / 5203 : ℚ)) * X ^ 2 + C ((-125596426 / 5203 : ℚ)) * X ^ 3 + C ((-614733226 / 15609 : ℚ)) * X ^ 4 + C ((-793083430 / 15609 : ℚ)) * X ^ 5 + C ((-966988277 / 15609 : ℚ)) * X ^ 6 + C ((-1107045788 / 15609 : ℚ)) * X ^ 7 + C ((-375183981 / 5203 : ℚ)) * X ^ 8 + C ((-388286940 / 5203 : ℚ)) * X ^ 9 + C ((-398286484 / 5203 : ℚ)) * X ^ 10 + C ((-1206001804 / 15609 : ℚ)) * X ^ 11 + C ((-1079502772 / 15609 : ℚ)) * X ^ 12 + C ((-28674945 / 473 : ℚ)) * X ^ 13 + C ((-249587555 / 5203 : ℚ)) * X ^ 14 + C ((-43151992 / 1419 : ℚ)) * X ^ 15 + C ((-2271989 / 129 : ℚ)) * X ^ 16 + C ((-101005822 / 15609 : ℚ)) * X ^ 17 + C ((17640650 / 15609 : ℚ)) * X ^ 18
def VP43_pim : Polynomial ℚ := C ((106542743 / 15609 : ℚ)) + C ((213085486 / 15609 : ℚ)) * X + C ((95983391 / 5203 : ℚ)) * X ^ 2 + C ((404470780 / 15609 : ℚ)) * X ^ 3 + C ((423065750 / 15609 : ℚ)) * X ^ 4 + C ((125427296 / 5203 : ℚ)) * X ^ 5 + C ((329788207 / 15609 : ℚ)) * X ^ 6 + C ((195836398 / 15609 : ℚ)) * X ^ 7 + C ((33340155 / 5203 : ℚ)) * X ^ 8 + C ((2194748 / 363 : ℚ)) * X ^ 9 + C ((68323738 / 15609 : ℚ)) * X ^ 10 + C ((-25424378 / 5203 : ℚ)) * X ^ 11 + C ((-220870006 / 15609 : ℚ)) * X ^ 12 + C ((-321785119 / 15609 : ℚ)) * X ^ 13 + C ((-147984009 / 5203 : ℚ)) * X ^ 14 + C ((-10372946 / 363 : ℚ)) * X ^ 15 + C ((-121941525 / 5203 : ℚ)) * X ^ 16 + C ((-93235434 / 5203 : ℚ)) * X ^ 17 + C ((-37442084 / 5203 : ℚ)) * X ^ 18
theorem VP43_pre_eq :
    VB_0_1_re * VP43_Fre - VB_0_1_im * VP43_Fim = VP43_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP43_Fre, VP43_Fim, VP43_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP43_pim_eq :
    VB_0_1_re * VP43_Fim + VB_0_1_im * VP43_Fre = VP43_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP43_Fre, VP43_Fim, VP43_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP43_mul : VB_0_1 * VP43_F = ofLadj VP43_pre VP43_pim := by
  rw [VB_0_1, VP43_F, ofLadj_mul, VP43_pre_eq, VP43_pim_eq]

def VP44_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP44_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP44_F : Ki := ofLadj VP44_Fre VP44_Fim
def VP44_pre : Polynomial ℚ := C ((-1538948 / 1419 : ℚ)) + C ((-230713360 / 15609 : ℚ)) * X + C ((-469700096 / 15609 : ℚ)) * X ^ 2 + C ((-772544254 / 15609 : ℚ)) * X ^ 3 + C ((-1150047568 / 15609 : ℚ)) * X ^ 4 + C ((-1366475857 / 15609 : ℚ)) * X ^ 5 + C ((-1541101313 / 15609 : ℚ)) * X ^ 6 + C ((-545590615 / 5203 : ℚ)) * X ^ 7 + C ((-1559244109 / 15609 : ℚ)) * X ^ 8 + C ((-1529773567 / 15609 : ℚ)) * X ^ 9 + C ((-1507247867 / 15609 : ℚ)) * X ^ 10 + C ((-493967440 / 5203 : ℚ)) * X ^ 11 + C ((-29686849 / 363 : ℚ)) * X ^ 12 + C ((-1060073471 / 15609 : ℚ)) * X ^ 13 + C ((-262233285 / 5203 : ℚ)) * X ^ 14 + C ((-39662683 / 1419 : ℚ)) * X ^ 15 + C ((-5488354 / 363 : ℚ)) * X ^ 16 + C ((-20457922 / 5203 : ℚ)) * X ^ 17 + C ((16811588 / 5203 : ℚ)) * X ^ 18
def VP44_pim : Polynomial ℚ := C ((51802382 / 5203 : ℚ)) + C ((103604764 / 5203 : ℚ)) * X + C ((122942696 / 5203 : ℚ)) * X ^ 2 + C ((144792760 / 5203 : ℚ)) * X ^ 3 + C ((108782750 / 5203 : ℚ)) * X ^ 4 + C ((113317079 / 15609 : ℚ)) * X ^ 5 + C ((-19229631 / 5203 : ℚ)) * X ^ 6 + C ((-103036991 / 5203 : ℚ)) * X ^ 7 + C ((-151070609 / 5203 : ℚ)) * X ^ 8 + C ((-448980547 / 15609 : ℚ)) * X ^ 9 + C ((-13014975 / 473 : ℚ)) * X ^ 10 + C ((-556294648 / 15609 : ℚ)) * X ^ 11 + C ((-683095121 / 15609 : ℚ)) * X ^ 12 + C ((-721622545 / 15609 : ℚ)) * X ^ 13 + C ((-782941457 / 15609 : ℚ)) * X ^ 14 + C ((-15982909 / 363 : ℚ)) * X ^ 15 + C ((-499294502 / 15609 : ℚ)) * X ^ 16 + C ((-358108688 / 15609 : ℚ)) * X ^ 17 + C ((-131747194 / 15609 : ℚ)) * X ^ 18
theorem VP44_pre_eq :
    VB_0_1_re * VP44_Fre - VB_0_1_im * VP44_Fim = VP44_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP44_Fre, VP44_Fim, VP44_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP44_pim_eq :
    VB_0_1_re * VP44_Fim + VB_0_1_im * VP44_Fre = VP44_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP44_Fre, VP44_Fim, VP44_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP44_mul : VB_0_1 * VP44_F = ofLadj VP44_pre VP44_pim := by
  rw [VB_0_1, VP44_F, ofLadj_mul, VP44_pre_eq, VP44_pim_eq]

def VP45_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def VP45_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def VP45_F : Ki := ofLadj VP45_Fre VP45_Fim
def VP45_pre : Polynomial ℚ := C ((2372008 / 5203 : ℚ)) + C ((23071336 / 5203 : ℚ)) * X + C ((40195021 / 5203 : ℚ)) * X ^ 2 + C ((64970247 / 5203 : ℚ)) * X ^ 3 + C ((2282540 / 121 : ℚ)) * X ^ 4 + C ((111570696 / 5203 : ℚ)) * X ^ 5 + C ((127993528 / 5203 : ℚ)) * X ^ 6 + C ((146856393 / 5203 : ℚ)) * X ^ 7 + C ((150368927 / 5203 : ℚ)) * X ^ 8 + C ((162142152 / 5203 : ℚ)) * X ^ 9 + C ((171098428 / 5203 : ℚ)) * X ^ 10 + C ((172050154 / 5203 : ℚ)) * X ^ 11 + C ((148027092 / 5203 : ℚ)) * X ^ 12 + C ((121947131 / 5203 : ℚ)) * X ^ 13 + C ((85398680 / 5203 : ℚ)) * X ^ 14 + C ((41415810 / 5203 : ℚ)) * X ^ 15 + C ((21600928 / 5203 : ℚ)) * X ^ 16 + C ((470736 / 473 : ℚ)) * X ^ 17 + C ((-7291363 / 5203 : ℚ)) * X ^ 18
def VP45_pim : Polynomial ℚ := C ((-13233581 / 5203 : ℚ)) + C ((-26467162 / 5203 : ℚ)) * X + C ((-30484550 / 5203 : ℚ)) * X ^ 2 + C ((-39543527 / 5203 : ℚ)) * X ^ 3 + C ((-29694535 / 5203 : ℚ)) * X ^ 4 + C ((-13371933 / 5203 : ℚ)) * X ^ 5 + C ((-8960989 / 5203 : ℚ)) * X ^ 6 + C ((7724943 / 5203 : ℚ)) * X ^ 7 + C ((20375132 / 5203 : ℚ)) * X ^ 8 + C ((22074868 / 5203 : ℚ)) * X ^ 9 + C ((29868749 / 5203 : ℚ)) * X ^ 10 + C ((54475898 / 5203 : ℚ)) * X ^ 11 + C ((79083047 / 5203 : ℚ)) * X ^ 12 + C ((90894316 / 5203 : ℚ)) * X ^ 13 + C ((101653029 / 5203 : ℚ)) * X ^ 14 + C ((86847615 / 5203 : ℚ)) * X ^ 15 + C ((60535460 / 5203 : ℚ)) * X ^ 16 + C ((44282096 / 5203 : ℚ)) * X ^ 17 + C ((1600601 / 473 : ℚ)) * X ^ 18
theorem VP45_pre_eq :
    VB_0_1_re * VP45_Fre - VB_0_1_im * VP45_Fim = VP45_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP45_Fre, VP45_Fim, VP45_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP45_pim_eq :
    VB_0_1_re * VP45_Fim + VB_0_1_im * VP45_Fre = VP45_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP45_Fre, VP45_Fim, VP45_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP45_mul : VB_0_1 * VP45_F = ofLadj VP45_pre VP45_pim := by
  rw [VB_0_1, VP45_F, ofLadj_mul, VP45_pre_eq, VP45_pim_eq]

def VP46_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def VP46_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def VP46_F : Ki := ofLadj VP46_Fre VP46_Fim
def VP46_pre : Polynomial ℚ := C ((46041268 / 15609 : ℚ)) + C ((645997408 / 15609 : ℚ)) * X + C ((1282567574 / 15609 : ℚ)) * X ^ 2 + C ((2103546766 / 15609 : ℚ)) * X ^ 3 + C ((3136766012 / 15609 : ℚ)) * X ^ 4 + C ((1245108804 / 5203 : ℚ)) * X ^ 5 + C ((1408687590 / 5203 : ℚ)) * X ^ 6 + C ((4519906850 / 15609 : ℚ)) * X ^ 7 + C ((4306882820 / 15609 : ℚ)) * X ^ 8 + C ((1419411106 / 5203 : ℚ)) * X ^ 9 + C ((1407015052 / 5203 : ℚ)) * X ^ 10 + C ((378277348 / 1419 : ℚ)) * X ^ 11 + C ((3575047748 / 15609 : ℚ)) * X ^ 12 + C ((2975665744 / 15609 : ℚ)) * X ^ 13 + C ((2203336054 / 15609 : ℚ)) * X ^ 14 + C ((404944904 / 5203 : ℚ)) * X ^ 15 + C ((214322766 / 5203 : ℚ)) * X ^ 16 + C ((50743980 / 5203 : ℚ)) * X ^ 17 + C ((-56102042 / 5203 : ℚ)) * X ^ 18
def VP46_pim : Polynomial ℚ := C ((-439754276 / 15609 : ℚ)) + C ((-879508552 / 15609 : ℚ)) * X + C ((-1031931860 / 15609 : ℚ)) * X ^ 2 + C ((-112634480 / 1419 : ℚ)) * X ^ 3 + C ((-949286804 / 15609 : ℚ)) * X ^ 4 + C ((-11080150 / 473 : ℚ)) * X ^ 5 + C ((36900502 / 5203 : ℚ)) * X ^ 6 + C ((824329394 / 15609 : ℚ)) * X ^ 7 + C ((413725644 / 5203 : ℚ)) * X ^ 8 + C ((411396240 / 5203 : ℚ)) * X ^ 9 + C ((400685500 / 5203 : ℚ)) * X ^ 10 + C ((1594539152 / 15609 : ℚ)) * X ^ 11 + C ((1987021804 / 15609 : ℚ)) * X ^ 12 + C ((2107312892 / 15609 : ℚ)) * X ^ 13 + C ((209761100 / 1419 : ℚ)) * X ^ 14 + C ((2038076026 / 15609 : ℚ)) * X ^ 15 + C ((1495776662 / 15609 : ℚ)) * X ^ 16 + C ((24854338 / 363 : ℚ)) * X ^ 17 + C ((396451136 / 15609 : ℚ)) * X ^ 18
theorem VP46_pre_eq :
    VB_0_1_re * VP46_Fre - VB_0_1_im * VP46_Fim = VP46_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP46_Fre, VP46_Fim, VP46_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP46_pim_eq :
    VB_0_1_re * VP46_Fim + VB_0_1_im * VP46_Fre = VP46_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP46_Fre, VP46_Fim, VP46_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP46_mul : VB_0_1 * VP46_F = ofLadj VP46_pre VP46_pim := by
  rw [VB_0_1, VP46_F, ofLadj_mul, VP46_pre_eq, VP46_pim_eq]

def VP47_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def VP47_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def VP47_F : Ki := ofLadj VP47_Fre VP47_Fim
def VP47_pre : Polynomial ℚ := C ((1023818 / 15609 : ℚ)) + C ((-23071336 / 15609 : ℚ)) * X + C ((-49300715 / 15609 : ℚ)) * X ^ 2 + C ((-7665308 / 1419 : ℚ)) * X ^ 3 + C ((-4066923 / 473 : ℚ)) * X ^ 4 + C ((-15782042 / 1419 : ℚ)) * X ^ 5 + C ((-18590581 / 1419 : ℚ)) * X ^ 6 + C ((-213645416 / 15609 : ℚ)) * X ^ 7 + C ((-64352122 / 5203 : ℚ)) * X ^ 8 + C ((-59517712 / 5203 : ℚ)) * X ^ 9 + C ((-15228073 / 1419 : ℚ)) * X ^ 10 + C ((-54807182 / 5203 : ℚ)) * X ^ 11 + C ((-144437467 / 15609 : ℚ)) * X ^ 12 + C ((-129252421 / 15609 : ℚ)) * X ^ 13 + C ((-108737978 / 15609 : ℚ)) * X ^ 14 + C ((-72145594 / 15609 : ℚ)) * X ^ 15 + C ((-13541624 / 5203 : ℚ)) * X ^ 16 + C ((-226301 / 363 : ℚ)) * X ^ 17 + C ((7291363 / 15609 : ℚ)) * X ^ 18
def VP47_pim : Polynomial ℚ := C ((24769249 / 15609 : ℚ)) + C ((49538498 / 15609 : ℚ)) * X + C ((61452026 / 15609 : ℚ)) * X ^ 2 + C ((78016447 / 15609 : ℚ)) * X ^ 3 + C ((1776586 / 363 : ℚ)) * X ^ 4 + C ((4898362 / 1419 : ℚ)) * X ^ 5 + C ((22753780 / 15609 : ℚ)) * X ^ 6 + C ((-20175047 / 15609 : ℚ)) * X ^ 7 + C ((-43877594 / 15609 : ℚ)) * X ^ 8 + C ((-41774638 / 15609 : ℚ)) * X ^ 9 + C ((-975114 / 473 : ℚ)) * X ^ 10 + C ((-332870 / 121 : ℚ)) * X ^ 11 + C ((-17900566 / 5203 : ℚ)) * X ^ 12 + C ((-56019350 / 15609 : ℚ)) * X ^ 13 + C ((-23493605 / 5203 : ℚ)) * X ^ 14 + C ((-74953502 / 15609 : ℚ)) * X ^ 15 + C ((-64747558 / 15609 : ℚ)) * X ^ 16 + C ((-16076722 / 5203 : ℚ)) * X ^ 17 + C ((-1600601 / 1419 : ℚ)) * X ^ 18
theorem VP47_pre_eq :
    VB_0_1_re * VP47_Fre - VB_0_1_im * VP47_Fim = VP47_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP47_Fre, VP47_Fim, VP47_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP47_pim_eq :
    VB_0_1_re * VP47_Fim + VB_0_1_im * VP47_Fre = VP47_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_0_1_re, VB_0_1_im, VP47_Fre, VP47_Fim, VP47_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP47_mul : VB_0_1 * VP47_F = ofLadj VP47_pre VP47_pim := by
  rw [VB_0_1, VP47_F, ofLadj_mul, VP47_pre_eq, VP47_pim_eq]

def VP48_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def VP48_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def VP48_F : Ki := ofLadj VP48_Fre VP48_Fim
def VP48_pre : Polynomial ℚ := C ((-2679173 / 124872 : ℚ)) + C ((44024456 / 15609 : ℚ)) * X + C ((29336550 / 5203 : ℚ)) * X ^ 2 + C ((1147622095 / 124872 : ℚ)) * X ^ 3 + C ((485079599 / 31218 : ℚ)) * X ^ 4 + C ((2484071335 / 124872 : ℚ)) * X ^ 5 + C ((2995725949 / 124872 : ℚ)) * X ^ 6 + C ((1609210685 / 62436 : ℚ)) * X ^ 7 + C ((575767 / 24 : ℚ)) * X ^ 8 + C ((65956535 / 2904 : ℚ)) * X ^ 9 + C ((904906615 / 41624 : ℚ)) * X ^ 10 + C ((667937863 / 31218 : ℚ)) * X ^ 11 + C ((214774927 / 11352 : ℚ)) * X ^ 12 + C ((2132053805 / 124872 : ℚ)) * X ^ 13 + C ((308015601 / 20812 : ℚ)) * X ^ 14 + C ((1201669883 / 124872 : ℚ)) * X ^ 15 + C ((186260035 / 31218 : ℚ)) * X ^ 16 + C ((964403 / 516 : ℚ)) * X ^ 17 + C ((-25477697 / 41624 : ℚ)) * X ^ 18
def VP48_pim : Polynomial ℚ := C ((-167046751 / 62436 : ℚ)) + C ((-167046751 / 31218 : ℚ)) * X + C ((-863647583 / 124872 : ℚ)) * X ^ 2 + C ((-394907723 / 41624 : ℚ)) * X ^ 3 + C ((-1191896675 / 124872 : ℚ)) * X ^ 4 + C ((-437505785 / 62436 : ℚ)) * X ^ 5 + C ((-7951553 / 1892 : ℚ)) * X ^ 6 + C ((148124935 / 124872 : ℚ)) * X ^ 7 + C ((512946341 / 124872 : ℚ)) * X ^ 8 + C ((5570240 / 1419 : ℚ)) * X ^ 9 + C ((384676817 / 124872 : ℚ)) * X ^ 10 + C ((70539298 / 15609 : ℚ)) * X ^ 11 + C ((743951951 / 124872 : ℚ)) * X ^ 12 + C ((277969409 / 41624 : ℚ)) * X ^ 13 + C ((141527324 / 15609 : ℚ)) * X ^ 14 + C ((1206085951 / 124872 : ℚ)) * X ^ 15 + C ((85403951 / 10406 : ℚ)) * X ^ 16 + C ((18986555 / 2838 : ℚ)) * X ^ 17 + C ((99375851 / 41624 : ℚ)) * X ^ 18
theorem VP48_pre_eq :
    VB_2_0_re * VP48_Fre - VB_2_0_im * VP48_Fim = VP48_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP48_Fre, VP48_Fim, VP48_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP48_pim_eq :
    VB_2_0_re * VP48_Fim + VB_2_0_im * VP48_Fre = VP48_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP48_Fre, VP48_Fim, VP48_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP48_mul : VB_2_0 * VP48_F = ofLadj VP48_pre VP48_pim := by
  rw [VB_2_0, VP48_F, ofLadj_mul, VP48_pre_eq, VP48_pim_eq]

def VP49_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def VP49_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def VP49_F : Ki := ofLadj VP49_Fre VP49_Fim
def VP49_pre : Polynomial ℚ := C ((-217355 / 62436 : ℚ)) + C ((220122280 / 15609 : ℚ)) * X + C ((416609564 / 15609 : ℚ)) * X ^ 2 + C ((130475497 / 2838 : ℚ)) * X ^ 3 + C ((4684551947 / 62436 : ℚ)) * X ^ 4 + C ((1007543919 / 10406 : ℚ)) * X ^ 5 + C ((1842270082 / 15609 : ℚ)) * X ^ 6 + C ((8437483385 / 62436 : ℚ)) * X ^ 7 + C ((4289095669 / 31218 : ℚ)) * X ^ 8 + C ((2219386369 / 15609 : ℚ)) * X ^ 9 + C ((4553116895 / 31218 : ℚ)) * X ^ 10 + C ((2297912933 / 15609 : ℚ)) * X ^ 11 + C ((124632495 / 946 : ℚ)) * X ^ 12 + C ((1802776805 / 15609 : ℚ)) * X ^ 13 + C ((1426932601 / 15609 : ℚ)) * X ^ 14 + C ((82236806 / 1419 : ℚ)) * X ^ 15 + C ((1047067567 / 31218 : ℚ)) * X ^ 16 + C ((192579580 / 15609 : ℚ)) * X ^ 17 + C ((-67255987 / 31218 : ℚ)) * X ^ 18
def VP49_pim : Polynomial ℚ := C ((-813221527 / 62436 : ℚ)) + C ((-813221527 / 31218 : ℚ)) * X + C ((-99870971 / 2838 : ℚ)) * X ^ 2 + C ((-771496708 / 15609 : ℚ)) * X ^ 3 + C ((-3229625023 / 62436 : ℚ)) * X ^ 4 + C ((-717769868 / 15609 : ℚ)) * X ^ 5 + C ((-1259299595 / 31218 : ℚ)) * X ^ 6 + C ((-1499698741 / 62436 : ℚ)) * X ^ 7 + C ((-192601069 / 15609 : ℚ)) * X ^ 8 + C ((-121200665 / 10406 : ℚ)) * X ^ 9 + C ((-264597313 / 31218 : ℚ)) * X ^ 10 + C ((47860108 / 5203 : ℚ)) * X ^ 11 + C ((838918609 / 31218 : ℚ)) * X ^ 12 + C ((37069165 / 946 : ℚ)) * X ^ 13 + C ((563098441 / 10406 : ℚ)) * X ^ 14 + C ((849095999 / 15609 : ℚ)) * X ^ 15 + C ((231964284 / 5203 : ℚ)) * X ^ 16 + C ((532076698 / 15609 : ℚ)) * X ^ 17 + C ((427569653 / 31218 : ℚ)) * X ^ 18
theorem VP49_pre_eq :
    VB_2_0_re * VP49_Fre - VB_2_0_im * VP49_Fim = VP49_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP49_Fre, VP49_Fim, VP49_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP49_pim_eq :
    VB_2_0_re * VP49_Fim + VB_2_0_im * VP49_Fre = VP49_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP49_Fre, VP49_Fim, VP49_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP49_mul : VB_2_0 * VP49_F = ofLadj VP49_pre VP49_pim := by
  rw [VB_2_0, VP49_F, ofLadj_mul, VP49_pre_eq, VP49_pim_eq]

def VP50_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP50_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP50_F : Ki := ofLadj VP50_Fre VP50_Fim
def VP50_pre : Polynomial ℚ := C ((32294210 / 15609 : ℚ)) + C ((440244560 / 15609 : ℚ)) * X + C ((1791053461 / 31218 : ℚ)) * X ^ 2 + C ((490660888 / 5203 : ℚ)) * X ^ 3 + C ((2191510412 / 15609 : ℚ)) * X ^ 4 + C ((3472570023 / 20812 : ℚ)) * X ^ 5 + C ((3915608269 / 20812 : ℚ)) * X ^ 6 + C ((3119355647 / 15609 : ℚ)) * X ^ 7 + C ((270154268 / 1419 : ℚ)) * X ^ 8 + C ((24094775 / 129 : ℚ)) * X ^ 9 + C ((522294583 / 2838 : ℚ)) * X ^ 10 + C ((941427761 / 5203 : ℚ)) * X ^ 11 + C ((113133751 / 726 : ℚ)) * X ^ 12 + C ((1346627363 / 10406 : ℚ)) * X ^ 13 + C ((1499714284 / 15609 : ℚ)) * X ^ 14 + C ((1663580935 / 31218 : ℚ)) * X ^ 15 + C ((449576323 / 15609 : ℚ)) * X ^ 16 + C ((234595277 / 31218 : ℚ)) * X ^ 17 + C ((-192109535 / 31218 : ℚ)) * X ^ 18
def VP50_pim : Polynomial ℚ := C ((-197699749 / 10406 : ℚ)) + C ((-197699749 / 5203 : ℚ)) * X + C ((-234540766 / 5203 : ℚ)) * X ^ 2 + C ((-1657489729 / 31218 : ℚ)) * X ^ 3 + C ((-1247367409 / 31218 : ℚ)) * X ^ 4 + C ((-289623115 / 20812 : ℚ)) * X ^ 5 + C ((432233855 / 62436 : ℚ)) * X ^ 6 + C ((586464898 / 15609 : ℚ)) * X ^ 7 + C ((860733757 / 15609 : ℚ)) * X ^ 8 + C ((284230220 / 5203 : ℚ)) * X ^ 9 + C ((815491300 / 15609 : ℚ)) * X ^ 10 + C ((1057588628 / 15609 : ℚ)) * X ^ 11 + C ((433228652 / 5203 : ℚ)) * X ^ 12 + C ((1373009647 / 15609 : ℚ)) * X ^ 13 + C ((2980178233 / 31218 : ℚ)) * X ^ 14 + C ((1308562912 / 15609 : ℚ)) * X ^ 15 + C ((316635620 / 5203 : ℚ)) * X ^ 16 + C ((1362660043 / 31218 : ℚ)) * X ^ 17 + C ((501467807 / 31218 : ℚ)) * X ^ 18
theorem VP50_pre_eq :
    VB_2_0_re * VP50_Fre - VB_2_0_im * VP50_Fim = VP50_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP50_Fre, VP50_Fim, VP50_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP50_pim_eq :
    VB_2_0_re * VP50_Fim + VB_2_0_im * VP50_Fre = VP50_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP50_Fre, VP50_Fim, VP50_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP50_mul : VB_2_0 * VP50_F = ofLadj VP50_pre VP50_pim := by
  rw [VB_2_0, VP50_F, ofLadj_mul, VP50_pre_eq, VP50_pim_eq]

def VP51_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def VP51_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def VP51_F : Ki := ofLadj VP51_Fre VP51_Fim
def VP51_pre : Polynomial ℚ := C ((-9051073 / 10406 : ℚ)) + C ((-44024456 / 5203 : ℚ)) * X + C ((-76634244 / 5203 : ℚ)) * X ^ 2 + C ((-123780054 / 5203 : ℚ)) * X ^ 3 + C ((-187023115 / 5203 : ℚ)) * X ^ 4 + C ((-212635821 / 5203 : ℚ)) * X ^ 5 + C ((-243874962 / 5203 : ℚ)) * X ^ 6 + C ((-1119667449 / 20812 : ℚ)) * X ^ 7 + C ((-1146385049 / 20812 : ℚ)) * X ^ 8 + C ((-1235926243 / 20812 : ℚ)) * X ^ 9 + C ((-1304277809 / 20812 : ℚ)) * X ^ 10 + C ((-327922953 / 5203 : ℚ)) * X ^ 11 + C ((-1128179985 / 20812 : ℚ)) * X ^ 12 + C ((-929389267 / 20812 : ℚ)) * X ^ 13 + C ((-651264833 / 20812 : ℚ)) * X ^ 14 + C ((-316031043 / 20812 : ℚ)) * X ^ 15 + C ((-82325993 / 10406 : ℚ)) * X ^ 16 + C ((-19847711 / 10406 : ℚ)) * X ^ 17 + C ((27771973 / 10406 : ℚ)) * X ^ 18
def VP51_pim : Polynomial ℚ := C ((101010067 / 20812 : ℚ)) + C ((101010067 / 10406 : ℚ)) * X + C ((116319411 / 10406 : ℚ)) * X ^ 2 + C ((75463075 / 5203 : ℚ)) * X ^ 3 + C ((113491621 / 10406 : ℚ)) * X ^ 4 + C ((102288481 / 20812 : ℚ)) * X ^ 5 + C ((68992125 / 20812 : ℚ)) * X ^ 6 + C ((-5259053 / 1892 : ℚ)) * X ^ 7 + C ((-3589155 / 484 : ℚ)) * X ^ 8 + C ((-3888111 / 484 : ℚ)) * X ^ 9 + C ((-226421573 / 20812 : ℚ)) * X ^ 10 + C ((-103557640 / 5203 : ℚ)) * X ^ 11 + C ((-602039547 / 20812 : ℚ)) * X ^ 12 + C ((-62899185 / 1892 : ℚ)) * X ^ 13 + C ((-773959621 / 20812 : ℚ)) * X ^ 14 + C ((-60140363 / 1892 : ℚ)) * X ^ 15 + C ((-230364637 / 10406 : ℚ)) * X ^ 16 + C ((-168496159 / 10406 : ℚ)) * X ^ 17 + C ((-33507663 / 5203 : ℚ)) * X ^ 18
theorem VP51_pre_eq :
    VB_2_0_re * VP51_Fre - VB_2_0_im * VP51_Fim = VP51_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP51_Fre, VP51_Fim, VP51_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP51_pim_eq :
    VB_2_0_re * VP51_Fim + VB_2_0_im * VP51_Fre = VP51_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP51_Fre, VP51_Fim, VP51_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP51_mul : VB_2_0 * VP51_F = ofLadj VP51_pre VP51_pim := by
  rw [VB_2_0, VP51_F, ofLadj_mul, VP51_pre_eq, VP51_pim_eq]

def VP52_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def VP52_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def VP52_F : Ki := ofLadj VP52_Fre VP52_Fim
def VP52_pre : Polynomial ℚ := C ((-7984687 / 1419 : ℚ)) + C ((-1232684768 / 15609 : ℚ)) * X + C ((-4890525583 / 31218 : ℚ)) * X ^ 2 + C ((-8015643421 / 31218 : ℚ)) * X ^ 3 + C ((-5977215839 / 15609 : ℚ)) * X ^ 4 + C ((-14238685715 / 31218 : ℚ)) * X ^ 5 + C ((-66553726 / 129 : ℚ)) * X ^ 6 + C ((-8614136309 / 15609 : ℚ)) * X ^ 7 + C ((-8208317968 / 15609 : ℚ)) * X ^ 8 + C ((-16231154543 / 31218 : ℚ)) * X ^ 9 + C ((-8044689058 / 15609 : ℚ)) * X ^ 10 + C ((-7930512620 / 15609 : ℚ)) * X ^ 11 + C ((-6812004290 / 15609 : ℚ)) * X ^ 12 + C ((-5670314480 / 15609 : ℚ)) * X ^ 13 + C ((-8400992515 / 31218 : ℚ)) * X ^ 14 + C ((-4632791285 / 31218 : ℚ)) * X ^ 15 + C ((-1224923246 / 15609 : ℚ)) * X ^ 16 + C ((-582530515 / 31218 : ℚ)) * X ^ 17 + C ((641049655 / 31218 : ℚ)) * X ^ 18
def VP52_pim : Polynomial ℚ := C ((839143837 / 15609 : ℚ)) + C ((1678287674 / 15609 : ℚ)) * X + C ((656208391 / 5203 : ℚ)) * X ^ 2 + C ((2363801249 / 15609 : ℚ)) * X ^ 3 + C ((3627815879 / 31218 : ℚ)) * X ^ 4 + C ((1400271379 / 31218 : ℚ)) * X ^ 5 + C ((-18728401 / 1419 : ℚ)) * X ^ 6 + C ((-3127514605 / 31218 : ℚ)) * X ^ 7 + C ((-4714425781 / 31218 : ℚ)) * X ^ 8 + C ((-213078299 / 1419 : ℚ)) * X ^ 9 + C ((-2282470435 / 15609 : ℚ)) * X ^ 10 + C ((-3031687288 / 15609 : ℚ)) * X ^ 11 + C ((-3780904141 / 15609 : ℚ)) * X ^ 12 + C ((-4009850786 / 15609 : ℚ)) * X ^ 13 + C ((-266162137 / 946 : ℚ)) * X ^ 14 + C ((-2587161035 / 10406 : ℚ)) * X ^ 15 + C ((-2845817495 / 15609 : ℚ)) * X ^ 16 + C ((-369707761 / 2838 : ℚ)) * X ^ 17 + C ((-1508991973 / 31218 : ℚ)) * X ^ 18
theorem VP52_pre_eq :
    VB_2_0_re * VP52_Fre - VB_2_0_im * VP52_Fim = VP52_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP52_Fre, VP52_Fim, VP52_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP52_pim_eq :
    VB_2_0_re * VP52_Fim + VB_2_0_im * VP52_Fre = VP52_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP52_Fre, VP52_Fim, VP52_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP52_mul : VB_2_0 * VP52_F = ofLadj VP52_pre VP52_pim := by
  rw [VB_2_0, VP52_F, ofLadj_mul, VP52_pre_eq, VP52_pim_eq]

def VP53_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def VP53_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def VP53_F : Ki := ofLadj VP53_Fre VP53_Fim
def VP53_pre : Polynomial ℚ := C ((-177731 / 1419 : ℚ)) + C ((44024456 / 15609 : ℚ)) * X + C ((187923289 / 31218 : ℚ)) * X ^ 2 + C ((58395647 / 5676 : ℚ)) * X ^ 3 + C ((1022791907 / 62436 : ℚ)) * X ^ 4 + C ((330880003 / 15609 : ℚ)) * X ^ 5 + C ((519546451 / 20812 : ℚ)) * X ^ 6 + C ((1628263181 / 62436 : ℚ)) * X ^ 7 + C ((245229569 / 10406 : ℚ)) * X ^ 8 + C ((453690209 / 20812 : ℚ)) * X ^ 9 + C ((1276863959 / 62436 : ℚ)) * X ^ 10 + C ((313312115 / 15609 : ℚ)) * X ^ 11 + C ((366922045 / 20812 : ℚ)) * X ^ 12 + C ((985224049 / 62436 : ℚ)) * X ^ 13 + C ((829025297 / 62436 : ℚ)) * X ^ 14 + C ((137481832 / 15609 : ℚ)) * X ^ 15 + C ((77367391 / 15609 : ℚ)) * X ^ 16 + C ((74350223 / 62436 : ℚ)) * X ^ 17 + C ((-27771973 / 31218 : ℚ)) * X ^ 18
def VP53_pim : Polynomial ℚ := C ((-189058979 / 62436 : ℚ)) + C ((-189058979 / 31218 : ℚ)) * X + C ((-117217286 / 15609 : ℚ)) * X ^ 2 + C ((-49592921 / 5203 : ℚ)) * X ^ 3 + C ((-583207651 / 62436 : ℚ)) * X ^ 4 + C ((-411282341 / 62436 : ℚ)) * X ^ 5 + C ((-87120923 / 31218 : ℚ)) * X ^ 6 + C ((50859885 / 20812 : ℚ)) * X ^ 7 + C ((332853391 / 62436 : ℚ)) * X ^ 8 + C ((317032823 / 62436 : ℚ)) * X ^ 9 + C ((244045217 / 62436 : ℚ)) * X ^ 10 + C ((27181804 / 5203 : ℚ)) * X ^ 11 + C ((408318079 / 62436 : ℚ)) * X ^ 12 + C ((426081659 / 62436 : ℚ)) * X ^ 13 + C ((536506999 / 62436 : ℚ)) * X ^ 14 + C ((95140447 / 10406 : ℚ)) * X ^ 15 + C ((82118493 / 10406 : ℚ)) * X ^ 16 + C ((367058567 / 62436 : ℚ)) * X ^ 17 + C ((11169221 / 5203 : ℚ)) * X ^ 18
theorem VP53_pre_eq :
    VB_2_0_re * VP53_Fre - VB_2_0_im * VP53_Fim = VP53_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP53_Fre, VP53_Fim, VP53_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP53_pim_eq :
    VB_2_0_re * VP53_Fim + VB_2_0_im * VP53_Fre = VP53_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_2_0_re, VB_2_0_im, VP53_Fre, VP53_Fim, VP53_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP53_mul : VB_2_0 * VP53_F = ofLadj VP53_pre VP53_pim := by
  rw [VB_2_0, VP53_F, ofLadj_mul, VP53_pre_eq, VP53_pim_eq]

def VP54_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def VP54_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def VP54_F : Ki := ofLadj VP54_Fre VP54_Fim
def VP54_pre : Polynomial ℚ := C ((-552757 / 62436 : ℚ)) + C ((14051462 / 15609 : ℚ)) * X + C ((10222219 / 5676 : ℚ)) * X ^ 2 + C ((61156157 / 20812 : ℚ)) * X ^ 3 + C ((77552395 / 15609 : ℚ)) * X ^ 4 + C ((99252136 / 15609 : ℚ)) * X ^ 5 + C ((119713706 / 15609 : ℚ)) * X ^ 6 + C ((514438567 / 62436 : ℚ)) * X ^ 7 + C ((478794685 / 62436 : ℚ)) * X ^ 8 + C ((113317958 / 15609 : ℚ)) * X ^ 9 + C ((144619975 / 20812 : ℚ)) * X ^ 10 + C ((213562111 / 31218 : ℚ)) * X ^ 11 + C ((377654077 / 62436 : ℚ)) * X ^ 12 + C ((113609141 / 20812 : ℚ)) * X ^ 13 + C ((147663107 / 31218 : ℚ)) * X ^ 14 + C ((63994647 / 20812 : ℚ)) * X ^ 15 + C ((119114381 / 62436 : ℚ)) * X ^ 16 + C ((37268101 / 62436 : ℚ)) * X ^ 17 + C ((-185531 / 946 : ℚ)) * X ^ 18
def VP54_pim : Polynomial ℚ := C ((-53352751 / 62436 : ℚ)) + C ((-53352751 / 31218 : ℚ)) * X + C ((-45956333 / 20812 : ℚ)) * X ^ 2 + C ((-189206575 / 62436 : ℚ)) * X ^ 3 + C ((-95162467 / 31218 : ℚ)) * X ^ 4 + C ((-23282657 / 10406 : ℚ)) * X ^ 5 + C ((-41859773 / 31218 : ℚ)) * X ^ 6 + C ((8045211 / 20812 : ℚ)) * X ^ 7 + C ((82471555 / 62436 : ℚ)) * X ^ 8 + C ((39433439 / 31218 : ℚ)) * X ^ 9 + C ((61965625 / 62436 : ℚ)) * X ^ 10 + C ((15104889 / 10406 : ℚ)) * X ^ 11 + C ((119293043 / 62436 : ℚ)) * X ^ 12 + C ((44518429 / 20812 : ℚ)) * X ^ 13 + C ((90644093 / 31218 : ℚ)) * X ^ 14 + C ((64342783 / 20812 : ℚ)) * X ^ 15 + C ((164150359 / 62436 : ℚ)) * X ^ 16 + C ((133818295 / 62436 : ℚ)) * X ^ 17 + C ((7952353 / 10406 : ℚ)) * X ^ 18
theorem VP54_pre_eq :
    VB_1_1_re * VP54_Fre - VB_1_1_im * VP54_Fim = VP54_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP54_Fre, VP54_Fim, VP54_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP54_pim_eq :
    VB_1_1_re * VP54_Fim + VB_1_1_im * VP54_Fre = VP54_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP54_Fre, VP54_Fim, VP54_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP54_mul : VB_1_1 * VP54_F = ofLadj VP54_pre VP54_pim := by
  rw [VB_1_1, VP54_F, ofLadj_mul, VP54_pre_eq, VP54_pim_eq]

def VP55_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def VP55_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def VP55_F : Ki := ofLadj VP55_Fre VP55_Fim
def VP55_pre : Polynomial ℚ := C ((-15397 / 1419 : ℚ)) + C ((70257310 / 15609 : ℚ)) * X + C ((133048363 / 15609 : ℚ)) * X ^ 2 + C ((229449796 / 15609 : ℚ)) * X ^ 3 + C ((374461036 / 15609 : ℚ)) * X ^ 4 + C ((43918151 / 1419 : ℚ)) * X ^ 5 + C ((196320315 / 5203 : ℚ)) * X ^ 6 + C ((674336281 / 15609 : ℚ)) * X ^ 7 + C ((228530402 / 5203 : ℚ)) * X ^ 8 + C ((709510576 / 15609 : ℚ)) * X ^ 9 + C ((727824761 / 15609 : ℚ)) * X ^ 10 + C ((66795511 / 1419 : ℚ)) * X ^ 11 + C ((657567451 / 15609 : ℚ)) * X ^ 12 + C ((192154071 / 5203 : ℚ)) * X ^ 13 + C ((456141410 / 15609 : ℚ)) * X ^ 14 + C ((289094063 / 15609 : ℚ)) * X ^ 15 + C ((55801343 / 5203 : ℚ)) * X ^ 16 + C ((5594795 / 1419 : ℚ)) * X ^ 17 + C ((-10781182 / 15609 : ℚ)) * X ^ 18
def VP55_pim : Polynomial ℚ := C ((-64934506 / 15609 : ℚ)) + C ((-129869012 / 15609 : ℚ)) * X + C ((-58452995 / 5203 : ℚ)) * X ^ 2 + C ((-246430751 / 15609 : ℚ)) * X ^ 3 + C ((-257815072 / 15609 : ℚ)) * X ^ 4 + C ((-76407077 / 5203 : ℚ)) * X ^ 5 + C ((-200955397 / 15609 : ℚ)) * X ^ 6 + C ((-119263226 / 15609 : ℚ)) * X ^ 7 + C ((-20296930 / 5203 : ℚ)) * X ^ 8 + C ((-19150470 / 5203 : ℚ)) * X ^ 9 + C ((-13863990 / 5203 : ℚ)) * X ^ 10 + C ((46542223 / 15609 : ℚ)) * X ^ 11 + C ((134676416 / 15609 : ℚ)) * X ^ 12 + C ((65341943 / 5203 : ℚ)) * X ^ 13 + C ((270536975 / 15609 : ℚ)) * X ^ 14 + C ((271861294 / 15609 : ℚ)) * X ^ 15 + C ((74303257 / 5203 : ℚ)) * X ^ 16 + C ((170482291 / 15609 : ℚ)) * X ^ 17 + C ((68432438 / 15609 : ℚ)) * X ^ 18
theorem VP55_pre_eq :
    VB_1_1_re * VP55_Fre - VB_1_1_im * VP55_Fim = VP55_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP55_Fre, VP55_Fim, VP55_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP55_pim_eq :
    VB_1_1_re * VP55_Fim + VB_1_1_im * VP55_Fre = VP55_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP55_Fre, VP55_Fim, VP55_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP55_mul : VB_1_1 * VP55_F = ofLadj VP55_pre VP55_pim := by
  rw [VB_1_1, VP55_F, ofLadj_mul, VP55_pre_eq, VP55_pim_eq]

def VP56_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP56_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP56_F : Ki := ofLadj VP56_Fre VP56_Fim
def VP56_pre : Polynomial ℚ := C ((10092851 / 15609 : ℚ)) + C ((140514620 / 15609 : ℚ)) * X + C ((286015553 / 15609 : ℚ)) * X ^ 2 + C ((470509808 / 15609 : ℚ)) * X ^ 3 + C ((700583696 / 15609 : ℚ)) * X ^ 4 + C ((277467023 / 5203 : ℚ)) * X ^ 5 + C ((312896916 / 5203 : ℚ)) * X ^ 6 + C ((332334954 / 5203 : ℚ)) * X ^ 7 + C ((949742864 / 15609 : ℚ)) * X ^ 8 + C ((931756234 / 15609 : ℚ)) * X ^ 9 + C ((306020463 / 5203 : ℚ)) * X ^ 10 + C ((902814217 / 15609 : ℚ)) * X ^ 11 + C ((18082483 / 363 : ℚ)) * X ^ 12 + C ((645740681 / 15609 : ℚ)) * X ^ 13 + C ((159744352 / 5203 : ℚ)) * X ^ 14 + C ((265653596 / 15609 : ℚ)) * X ^ 15 + C ((47890572 / 5203 : ℚ)) * X ^ 16 + C ((1132789 / 473 : ℚ)) * X ^ 17 + C ((-30767570 / 15609 : ℚ)) * X ^ 18
def VP56_pim : Polynomial ℚ := C ((-31580119 / 5203 : ℚ)) + C ((-63160238 / 5203 : ℚ)) * X + C ((-224669789 / 15609 : ℚ)) * X ^ 2 + C ((-264704162 / 15609 : ℚ)) * X ^ 3 + C ((-198963310 / 15609 : ℚ)) * X ^ 4 + C ((-2091572 / 473 : ℚ)) * X ^ 5 + C ((35043133 / 15609 : ℚ)) * X ^ 6 + C ((62784838 / 5203 : ℚ)) * X ^ 7 + C ((92040541 / 5203 : ℚ)) * X ^ 8 + C ((273559982 / 15609 : ℚ)) * X ^ 9 + C ((261667606 / 15609 : ℚ)) * X ^ 10 + C ((30816821 / 1419 : ℚ)) * X ^ 11 + C ((416302456 / 15609 : ℚ)) * X ^ 12 + C ((439599155 / 15609 : ℚ)) * X ^ 13 + C ((477071887 / 15609 : ℚ)) * X ^ 14 + C ((418842682 / 15609 : ℚ)) * X ^ 15 + C ((304199578 / 15609 : ℚ)) * X ^ 16 + C ((72756171 / 5203 : ℚ)) * X ^ 17 + C ((80255462 / 15609 : ℚ)) * X ^ 18
theorem VP56_pre_eq :
    VB_1_1_re * VP56_Fre - VB_1_1_im * VP56_Fim = VP56_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP56_Fre, VP56_Fim, VP56_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP56_pim_eq :
    VB_1_1_re * VP56_Fim + VB_1_1_im * VP56_Fre = VP56_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP56_Fre, VP56_Fim, VP56_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP56_mul : VB_1_1 * VP56_F = ofLadj VP56_pre VP56_pim := by
  rw [VB_1_1, VP56_F, ofLadj_mul, VP56_pre_eq, VP56_pim_eq]

def VP57_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def VP57_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def VP57_F : Ki := ofLadj VP57_Fre VP57_Fim
def VP57_pre : Polynomial ℚ := C ((-2853097 / 10406 : ℚ)) + C ((-14051462 / 5203 : ℚ)) * X + C ((-24473522 / 5203 : ℚ)) * X ^ 2 + C ((-79134797 / 10406 : ℚ)) * X ^ 3 + C ((-119591551 / 10406 : ℚ)) * X ^ 4 + C ((-135923631 / 10406 : ℚ)) * X ^ 5 + C ((-155902531 / 10406 : ℚ)) * X ^ 6 + C ((-178914313 / 10406 : ℚ)) * X ^ 7 + C ((-91589667 / 5203 : ℚ)) * X ^ 8 + C ((-98759281 / 5203 : ℚ)) * X ^ 9 + C ((-208434653 / 10406 : ℚ)) * X ^ 10 + C ((-9529493 / 473 : ℚ)) * X ^ 11 + C ((-180331729 / 10406 : ℚ)) * X ^ 12 + C ((-74285759 / 5203 : ℚ)) * X ^ 13 + C ((-104044537 / 10406 : ℚ)) * X ^ 14 + C ((-25213733 / 5203 : ℚ)) * X ^ 15 + C ((-13143756 / 5203 : ℚ)) * X ^ 16 + C ((-3154306 / 5203 : ℚ)) * X ^ 17 + C ((4447648 / 5203 : ℚ)) * X ^ 18
def VP57_pim : Polynomial ℚ := C ((16137779 / 10406 : ℚ)) + C ((16137779 / 5203 : ℚ)) * X + C ((18562010 / 5203 : ℚ)) * X ^ 2 + C ((48199759 / 10406 : ℚ)) * X ^ 3 + C ((36199017 / 10406 : ℚ)) * X ^ 4 + C ((16284799 / 10406 : ℚ)) * X ^ 5 + C ((10946659 / 10406 : ℚ)) * X ^ 6 + C ((-9406307 / 10406 : ℚ)) * X ^ 7 + C ((-12416971 / 5203 : ℚ)) * X ^ 8 + C ((-13447726 / 5203 : ℚ)) * X ^ 9 + C ((-36385307 / 10406 : ℚ)) * X ^ 10 + C ((-33195930 / 5203 : ℚ)) * X ^ 11 + C ((-96398413 / 10406 : ℚ)) * X ^ 12 + C ((-55368365 / 5203 : ℚ)) * X ^ 13 + C ((-123873979 / 10406 : ℚ)) * X ^ 14 + C ((-52925310 / 5203 : ℚ)) * X ^ 15 + C ((-36879361 / 5203 : ℚ)) * X ^ 16 + C ((-26990449 / 5203 : ℚ)) * X ^ 17 + C ((-10725126 / 5203 : ℚ)) * X ^ 18
theorem VP57_pre_eq :
    VB_1_1_re * VP57_Fre - VB_1_1_im * VP57_Fim = VP57_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP57_Fre, VP57_Fim, VP57_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP57_pim_eq :
    VB_1_1_re * VP57_Fim + VB_1_1_im * VP57_Fre = VP57_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP57_Fre, VP57_Fim, VP57_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP57_mul : VB_1_1 * VP57_F = ofLadj VP57_pre VP57_pim := by
  rw [VB_1_1, VP57_F, ofLadj_mul, VP57_pre_eq, VP57_pim_eq]

def VP58_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def VP58_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def VP58_F : Ki := ofLadj VP58_Fre VP58_Fim
def VP58_pre : Polynomial ℚ := C ((-27425456 / 15609 : ℚ)) + C ((-393440936 / 15609 : ℚ)) * X + C ((-780996691 / 15609 : ℚ)) * X ^ 2 + C ((-427042731 / 5203 : ℚ)) * X ^ 3 + C ((-636957289 / 5203 : ℚ)) * X ^ 4 + C ((-2275431275 / 15609 : ℚ)) * X ^ 5 + C ((-2574096872 / 15609 : ℚ)) * X ^ 6 + C ((-2753227529 / 15609 : ℚ)) * X ^ 7 + C ((-2623306814 / 15609 : ℚ)) * X ^ 8 + C ((-2593650388 / 15609 : ℚ)) * X ^ 9 + C ((-856999089 / 5203 : ℚ)) * X ^ 10 + C ((-2535091168 / 15609 : ℚ)) * X ^ 11 + C ((-2177556331 / 15609 : ℚ)) * X ^ 12 + C ((-604217899 / 5203 : ℚ)) * X ^ 13 + C ((-1342178621 / 15609 : ℚ)) * X ^ 14 + C ((-739693792 / 15609 : ℚ)) * X ^ 15 + C ((-130460604 / 5203 : ℚ)) * X ^ 16 + C ((-30905405 / 5203 : ℚ)) * X ^ 17 + C ((102661870 / 15609 : ℚ)) * X ^ 18
def VP58_pim : Polynomial ℚ := C ((268083292 / 15609 : ℚ)) + C ((536166584 / 15609 : ℚ)) * X + C ((628540079 / 15609 : ℚ)) * X ^ 2 + C ((251674925 / 5203 : ℚ)) * X ^ 3 + C ((52609133 / 1419 : ℚ)) * X ^ 4 + C ((74250941 / 5203 : ℚ)) * X ^ 5 + C ((-67176568 / 15609 : ℚ)) * X ^ 6 + C ((-502249685 / 15609 : ℚ)) * X ^ 7 + C ((-68747672 / 1419 : ℚ)) * X ^ 8 + C ((-751940212 / 15609 : ℚ)) * X ^ 9 + C ((-244117267 / 5203 : ℚ)) * X ^ 10 + C ((-323880142 / 5203 : ℚ)) * X ^ 11 + C ((-403643017 / 5203 : ℚ)) * X ^ 12 + C ((-116701285 / 1419 : ℚ)) * X ^ 13 + C ((-468638217 / 5203 : ℚ)) * X ^ 14 + C ((-1242066728 / 15609 : ℚ)) * X ^ 15 + C ((-303762134 / 5203 : ℚ)) * X ^ 16 + C ((-217134707 / 5203 : ℚ)) * X ^ 17 + C ((-241498318 / 15609 : ℚ)) * X ^ 18
theorem VP58_pre_eq :
    VB_1_1_re * VP58_Fre - VB_1_1_im * VP58_Fim = VP58_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP58_Fre, VP58_Fim, VP58_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP58_pim_eq :
    VB_1_1_re * VP58_Fim + VB_1_1_im * VP58_Fre = VP58_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP58_Fre, VP58_Fim, VP58_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP58_mul : VB_1_1 * VP58_F = ofLadj VP58_pre VP58_pim := by
  rw [VB_1_1, VP58_F, ofLadj_mul, VP58_pre_eq, VP58_pim_eq]

def VP59_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def VP59_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def VP59_F : Ki := ofLadj VP59_Fre VP59_Fim
def VP59_pre : Polynomial ℚ := C ((-1319537 / 31218 : ℚ)) + C ((14051462 / 15609 : ℚ)) * X + C ((10006356 / 5203 : ℚ)) * X ^ 2 + C ((51352093 / 15609 : ℚ)) * X ^ 3 + C ((163501099 / 31218 : ℚ)) * X ^ 4 + C ((211513463 / 31218 : ℚ)) * X ^ 5 + C ((87785 / 11 : ℚ)) * X ^ 6 + C ((3943560 / 473 : ℚ)) * X ^ 7 + C ((235188643 / 31218 : ℚ)) * X ^ 8 + C ((108757906 / 15609 : ℚ)) * X ^ 9 + C ((102027556 / 15609 : ℚ)) * X ^ 10 + C ((100169012 / 15609 : ℚ)) * X ^ 11 + C ((87976094 / 15609 : ℚ)) * X ^ 12 + C ((78738838 / 15609 : ℚ)) * X ^ 13 + C ((132484457 / 31218 : ℚ)) * X ^ 14 + C ((29292855 / 10406 : ℚ)) * X ^ 15 + C ((49474525 / 31218 : ℚ)) * X ^ 16 + C ((1975693 / 5203 : ℚ)) * X ^ 17 + C ((-4447648 / 15609 : ℚ)) * X ^ 18
def VP59_pim : Polynomial ℚ := C ((-30189241 / 31218 : ℚ)) + C ((-30189241 / 15609 : ℚ)) * X + C ((-37427086 / 15609 : ℚ)) * X ^ 2 + C ((-47534318 / 15609 : ℚ)) * X ^ 3 + C ((-93128185 / 31218 : ℚ)) * X ^ 4 + C ((-21885025 / 10406 : ℚ)) * X ^ 5 + C ((-13867012 / 15609 : ℚ)) * X ^ 6 + C ((372957 / 473 : ℚ)) * X ^ 7 + C ((17823863 / 10406 : ℚ)) * X ^ 8 + C ((25455569 / 15609 : ℚ)) * X ^ 9 + C ((19611200 / 15609 : ℚ)) * X ^ 10 + C ((2379109 / 1419 : ℚ)) * X ^ 11 + C ((32729198 / 15609 : ℚ)) * X ^ 12 + C ((34122674 / 15609 : ℚ)) * X ^ 13 + C ((85899361 / 31218 : ℚ)) * X ^ 14 + C ((91365085 / 31218 : ℚ)) * X ^ 15 + C ((26298967 / 10406 : ℚ)) * X ^ 16 + C ((29397256 / 15609 : ℚ)) * X ^ 17 + C ((3575042 / 5203 : ℚ)) * X ^ 18
theorem VP59_pre_eq :
    VB_1_1_re * VP59_Fre - VB_1_1_im * VP59_Fim = VP59_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP59_Fre, VP59_Fim, VP59_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP59_pim_eq :
    VB_1_1_re * VP59_Fim + VB_1_1_im * VP59_Fre = VP59_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VB_1_1_re, VB_1_1_im, VP59_Fre, VP59_Fim, VP59_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP59_mul : VB_1_1 * VP59_F = ofLadj VP59_pre VP59_pim := by
  rw [VB_1_1, VP59_F, ofLadj_mul, VP59_pre_eq, VP59_pim_eq]

def VP60_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def VP60_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def VP60_F : Ki := ofLadj VP60_Fre VP60_Fim
def VP60_pre : Polynomial ℚ := C ((-22114703 / 15609 : ℚ)) + C ((-155270912 / 15609 : ℚ)) * X + C ((-586663093 / 31218 : ℚ)) * X ^ 2 + C ((-462306175 / 15609 : ℚ)) * X ^ 3 + C ((-438040541 / 10406 : ℚ)) * X ^ 4 + C ((-1004509597 / 20812 : ℚ)) * X ^ 5 + C ((-3299978881 / 62436 : ℚ)) * X ^ 6 + C ((-286058312 / 5203 : ℚ)) * X ^ 7 + C ((-1588873463 / 31218 : ℚ)) * X ^ 8 + C ((-782384842 / 15609 : ℚ)) * X ^ 9 + C ((-3092735729 / 62436 : ℚ)) * X ^ 10 + C ((-1495138793 / 31218 : ℚ)) * X ^ 11 + C ((-823884027 / 20812 : ℚ)) * X ^ 12 + C ((-88918781 / 2838 : ℚ)) * X ^ 13 + C ((-221420371 / 10406 : ℚ)) * X ^ 14 + C ((-148415372 / 15609 : ℚ)) * X ^ 15 + C ((-234980533 / 62436 : ℚ)) * X ^ 16 + C ((17156519 / 20812 : ℚ)) * X ^ 17 + C ((105397505 / 31218 : ℚ)) * X ^ 18
def VP60_pim : Polynomial ℚ := C ((69361942 / 15609 : ℚ)) + C ((138723884 / 15609 : ℚ)) * X + C ((265814167 / 31218 : ℚ)) * X ^ 2 + C ((525772721 / 62436 : ℚ)) * X ^ 3 + C ((11545865 / 5203 : ℚ)) * X ^ 4 + C ((-152673601 / 20812 : ℚ)) * X ^ 5 + C ((-917064359 / 62436 : ℚ)) * X ^ 6 + C ((-1502446909 / 62436 : ℚ)) * X ^ 7 + C ((-912946613 / 31218 : ℚ)) * X ^ 8 + C ((-303158781 / 10406 : ℚ)) * X ^ 9 + C ((-1787248955 / 62436 : ℚ)) * X ^ 10 + C ((-168149472 / 5203 : ℚ)) * X ^ 11 + C ((-2248338373 / 62436 : ℚ)) * X ^ 12 + C ((-16616420 / 473 : ℚ)) * X ^ 13 + C ((-2180571287 / 62436 : ℚ)) * X ^ 14 + C ((-1813489045 / 62436 : ℚ)) * X ^ 15 + C ((-19058395 / 946 : ℚ)) * X ^ 16 + C ((-211938140 / 15609 : ℚ)) * X ^ 17 + C ((-151653109 / 31218 : ℚ)) * X ^ 18
theorem VP60_pre_eq :
    VC_0_0_re * VP60_Fre - VC_0_0_im * VP60_Fim = VP60_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP60_Fre, VP60_Fim, VP60_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP60_pim_eq :
    VC_0_0_re * VP60_Fim + VC_0_0_im * VP60_Fre = VP60_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP60_Fre, VP60_Fim, VP60_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP60_mul : VC_0_0 * VP60_F = ofLadj VP60_pre VP60_pim := by
  rw [VC_0_0, VP60_F, ofLadj_mul, VP60_pre_eq, VP60_pim_eq]

def VP61_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP61_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP61_F : Ki := ofLadj VP61_Fre VP61_Fim
def VP61_pre : Polynomial ℚ := C ((30232220 / 15609 : ℚ)) + C ((388177280 / 15609 : ℚ)) * X + C ((791987807 / 15609 : ℚ)) * X ^ 2 + C ((1303969861 / 15609 : ℚ)) * X ^ 3 + C ((1938335998 / 15609 : ℚ)) * X ^ 4 + C ((418887737 / 2838 : ℚ)) * X ^ 5 + C ((5197580653 / 31218 : ℚ)) * X ^ 6 + C ((5520891331 / 31218 : ℚ)) * X ^ 7 + C ((2628619687 / 15609 : ℚ)) * X ^ 8 + C ((5158303703 / 31218 : ℚ)) * X ^ 9 + C ((5082006179 / 31218 : ℚ)) * X ^ 10 + C ((2496502609 / 15609 : ℚ)) * X ^ 11 + C ((100131433 / 726 : ℚ)) * X ^ 12 + C ((3574328089 / 31218 : ℚ)) * X ^ 13 + C ((441549942 / 5203 : ℚ)) * X ^ 14 + C ((490637215 / 10406 : ℚ)) * X ^ 15 + C ((397773679 / 15609 : ℚ)) * X ^ 16 + C ((9351446 / 1419 : ℚ)) * X ^ 17 + C ((-86153845 / 15609 : ℚ)) * X ^ 18
def VP61_pim : Polynomial ℚ := C ((-260744743 / 15609 : ℚ)) + C ((-521489486 / 15609 : ℚ)) * X + C ((-207364097 / 5203 : ℚ)) * X ^ 2 + C ((-729806509 / 15609 : ℚ)) * X ^ 3 + C ((-1507394 / 43 : ℚ)) * X ^ 4 + C ((-376940153 / 31218 : ℚ)) * X ^ 5 + C ((200500651 / 31218 : ℚ)) * X ^ 6 + C ((1049969761 / 31218 : ℚ)) * X ^ 7 + C ((768231526 / 15609 : ℚ)) * X ^ 8 + C ((507468043 / 10406 : ℚ)) * X ^ 9 + C ((485649497 / 10406 : ℚ)) * X ^ 10 + C ((313624928 / 5203 : ℚ)) * X ^ 11 + C ((768850215 / 10406 : ℚ)) * X ^ 12 + C ((2442300617 / 31218 : ℚ)) * X ^ 13 + C ((1321835065 / 15609 : ℚ)) * X ^ 14 + C ((2319669475 / 31218 : ℚ)) * X ^ 15 + C ((843386839 / 15609 : ℚ)) * X ^ 16 + C ((55008454 / 1419 : ℚ)) * X ^ 17 + C ((74208162 / 5203 : ℚ)) * X ^ 18
theorem VP61_pre_eq :
    VC_0_0_re * VP61_Fre - VC_0_0_im * VP61_Fim = VP61_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP61_Fre, VP61_Fim, VP61_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP61_pim_eq :
    VC_0_0_re * VP61_Fim + VC_0_0_im * VP61_Fre = VP61_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP61_Fre, VP61_Fim, VP61_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP61_mul : VC_0_0 * VP61_F = ofLadj VP61_pre VP61_pim := by
  rw [VC_0_0, VP61_F, ofLadj_mul, VP61_pre_eq, VP61_pim_eq]

def VP62_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def VP62_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def VP62_F : Ki := ofLadj VP62_Fre VP62_Fim
def VP62_pre : Polynomial ℚ := C ((35643898 / 15609 : ℚ)) + C ((543448192 / 15609 : ℚ)) * X + C ((1088365424 / 15609 : ℚ)) * X ^ 2 + C ((3541533007 / 31218 : ℚ)) * X ^ 3 + C ((488301685 / 2838 : ℚ)) * X ^ 4 + C ((6494209157 / 31218 : ℚ)) * X ^ 5 + C ((3760666451 / 15609 : ℚ)) * X ^ 6 + C ((1367298474 / 5203 : ℚ)) * X ^ 7 + C ((366470224 / 1419 : ℚ)) * X ^ 8 + C ((8170782727 / 31218 : ℚ)) * X ^ 9 + C ((8253489853 / 31218 : ℚ)) * X ^ 10 + C ((4106260753 / 15609 : ℚ)) * X ^ 11 + C ((7166593469 / 31218 : ℚ)) * X ^ 12 + C ((1998017293 / 10406 : ℚ)) * X ^ 13 + C ((1506937307 / 10406 : ℚ)) * X ^ 14 + C ((2591312363 / 31218 : ℚ)) * X ^ 15 + C ((704822479 / 15609 : ℚ)) * X ^ 16 + C ((127507071 / 10406 : ℚ)) * X ^ 17 + C ((-120579973 / 15609 : ℚ)) * X ^ 18
def VP62_pim : Polynomial ℚ := C ((-388333277 / 15609 : ℚ)) + C ((-776666554 / 15609 : ℚ)) * X + C ((-317291849 / 5203 : ℚ)) * X ^ 2 + C ((-789739415 / 10406 : ℚ)) * X ^ 3 + C ((-2052977539 / 31218 : ℚ)) * X ^ 4 + C ((-1232799511 / 31218 : ℚ)) * X ^ 5 + C ((-2452109 / 129 : ℚ)) * X ^ 6 + C ((279211574 / 15609 : ℚ)) * X ^ 7 + C ((203832479 / 5203 : ℚ)) * X ^ 8 + C ((1238482505 / 31218 : ℚ)) * X ^ 9 + C ((1310549311 / 31218 : ℚ)) * X ^ 10 + C ((365321216 / 5203 : ℚ)) * X ^ 11 + C ((3073305281 / 31218 : ℚ)) * X ^ 12 + C ((3495790073 / 31218 : ℚ)) * X ^ 13 + C ((3976744855 / 31218 : ℚ)) * X ^ 14 + C ((3615008005 / 31218 : ℚ)) * X ^ 15 + C ((1351199507 / 15609 : ℚ)) * X ^ 16 + C ((1954332359 / 31218 : ℚ)) * X ^ 17 + C ((118344645 / 5203 : ℚ)) * X ^ 18
theorem VP62_pre_eq :
    VC_0_0_re * VP62_Fre - VC_0_0_im * VP62_Fim = VP62_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP62_Fre, VP62_Fim, VP62_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP62_pim_eq :
    VC_0_0_re * VP62_Fim + VC_0_0_im * VP62_Fre = VP62_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP62_Fre, VP62_Fim, VP62_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP62_mul : VC_0_0 * VP62_F = ofLadj VP62_pre VP62_pim := by
  rw [VC_0_0, VP62_F, ofLadj_mul, VP62_pre_eq, VP62_pim_eq]

def VP63_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def VP63_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def VP63_F : Ki := ofLadj VP63_Fre VP63_Fim
def VP63_pre : Polynomial ℚ := C ((-13737191 / 5203 : ℚ)) + C ((-543448192 / 15609 : ℚ)) * X + C ((-2162714837 / 31218 : ℚ)) * X ^ 2 + C ((-3551053631 / 31218 : ℚ)) * X ^ 3 + C ((-5286526217 / 31218 : ℚ)) * X ^ 4 + C ((-1049642361 / 5203 : ℚ)) * X ^ 5 + C ((-7126480871 / 31218 : ℚ)) * X ^ 6 + C ((-7623218893 / 31218 : ℚ)) * X ^ 7 + C ((-3630199531 / 15609 : ℚ)) * X ^ 8 + C ((-1196559028 / 5203 : ℚ)) * X ^ 9 + C ((-3557880571 / 15609 : ℚ)) * X ^ 10 + C ((-3504999589 / 15609 : ℚ)) * X ^ 11 + C ((-1004810793 / 5203 : ℚ)) * X ^ 12 + C ((-456058121 / 2838 : ℚ)) * X ^ 13 + C ((-112404407 / 946 : ℚ)) * X ^ 14 + C ((-31052336 / 473 : ℚ)) * X ^ 15 + C ((-1083497185 / 31218 : ℚ)) * X ^ 16 + C ((-127435240 / 15609 : ℚ)) * X ^ 17 + C ((143619250 / 15609 : ℚ)) * X ^ 18
def VP63_pim : Polynomial ℚ := C ((33538583 / 1419 : ℚ)) + C ((67077166 / 1419 : ℚ)) * X + C ((290175692 / 5203 : ℚ)) * X ^ 2 + C ((346933918 / 5203 : ℚ)) * X ^ 3 + C ((530736609 / 10406 : ℚ)) * X ^ 4 + C ((304676494 / 15609 : ℚ)) * X ^ 5 + C ((-194539597 / 31218 : ℚ)) * X ^ 6 + C ((-700337096 / 15609 : ℚ)) * X ^ 7 + C ((-701268303 / 10406 : ℚ)) * X ^ 8 + C ((-1046331317 / 15609 : ℚ)) * X ^ 9 + C ((-1019332084 / 15609 : ℚ)) * X ^ 10 + C ((-1348278880 / 15609 : ℚ)) * X ^ 11 + C ((-1677225676 / 15609 : ℚ)) * X ^ 12 + C ((-1782904693 / 15609 : ℚ)) * X ^ 13 + C ((-1298405489 / 10406 : ℚ)) * X ^ 14 + C ((-1719568987 / 15609 : ℚ)) * X ^ 15 + C ((-842179247 / 10406 : ℚ)) * X ^ 16 + C ((-902846759 / 15609 : ℚ)) * X ^ 17 + C ((-223271843 / 10406 : ℚ)) * X ^ 18
theorem VP63_pre_eq :
    VC_0_0_re * VP63_Fre - VC_0_0_im * VP63_Fim = VP63_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP63_Fre, VP63_Fim, VP63_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP63_pim_eq :
    VC_0_0_re * VP63_Fim + VC_0_0_im * VP63_Fre = VP63_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP63_Fre, VP63_Fim, VP63_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP63_mul : VC_0_0 * VP63_F = ofLadj VP63_pre VP63_pim := by
  rw [VC_0_0, VP63_F, ofLadj_mul, VP63_pre_eq, VP63_pim_eq]

def VP64_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def VP64_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def VP64_F : Ki := ofLadj VP64_Fre VP64_Fim
def VP64_pre : Polynomial ℚ := C ((-2861836 / 15609 : ℚ)) + C ((77635456 / 15609 : ℚ)) * X + C ((166332164 / 15609 : ℚ)) * X ^ 2 + C ((94945074 / 5203 : ℚ)) * X ^ 3 + C ((452593322 / 15609 : ℚ)) * X ^ 4 + C ((195106788 / 5203 : ℚ)) * X ^ 5 + C ((229898077 / 5203 : ℚ)) * X ^ 6 + C ((721051819 / 15609 : ℚ)) * X ^ 7 + C ((217032272 / 5203 : ℚ)) * X ^ 8 + C ((602021056 / 15609 : ℚ)) * X ^ 9 + C ((188284218 / 5203 : ℚ)) * X ^ 10 + C ((184761330 / 5203 : ℚ)) * X ^ 11 + C ((487217198 / 15609 : ℚ)) * X ^ 12 + C ((435688892 / 15609 : ℚ)) * X ^ 13 + C ((122087198 / 5203 : ℚ)) * X ^ 14 + C ((171646 / 11 : ℚ)) * X ^ 15 + C ((137050256 / 15609 : ℚ)) * X ^ 16 + C ((32676389 / 15609 : ℚ)) * X ^ 17 + C ((-24892823 / 15609 : ℚ)) * X ^ 18
def VP64_pim : Polynomial ℚ := C ((-2521307 / 473 : ℚ)) + C ((-5042614 / 473 : ℚ)) * X + C ((-207422371 / 15609 : ℚ)) * X ^ 2 + C ((-87476848 / 5203 : ℚ)) * X ^ 3 + C ((-23337250 / 1419 : ℚ)) * X ^ 4 + C ((-16447477 / 1419 : ℚ)) * X ^ 5 + C ((-25456290 / 5203 : ℚ)) * X ^ 6 + C ((68824004 / 15609 : ℚ)) * X ^ 7 + C ((149100377 / 15609 : ℚ)) * X ^ 8 + C ((12909241 / 1419 : ℚ)) * X ^ 9 + C ((109291706 / 15609 : ℚ)) * X ^ 10 + C ((145475456 / 15609 : ℚ)) * X ^ 11 + C ((181659206 / 15609 : ℚ)) * X ^ 12 + C ((63321790 / 5203 : ℚ)) * X ^ 13 + C ((237874817 / 15609 : ℚ)) * X ^ 14 + C ((84311465 / 5203 : ℚ)) * X ^ 15 + C ((218821591 / 15609 : ℚ)) * X ^ 16 + C ((163014176 / 15609 : ℚ)) * X ^ 17 + C ((59496001 / 15609 : ℚ)) * X ^ 18
theorem VP64_pre_eq :
    VC_0_0_re * VP64_Fre - VC_0_0_im * VP64_Fim = VP64_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP64_Fre, VP64_Fim, VP64_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP64_pim_eq :
    VC_0_0_re * VP64_Fim + VC_0_0_im * VP64_Fre = VP64_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP64_Fre, VP64_Fim, VP64_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP64_mul : VC_0_0 * VP64_F = ofLadj VP64_pre VP64_pim := by
  rw [VC_0_0, VP64_F, ofLadj_mul, VP64_pre_eq, VP64_pim_eq]

def VP65_Fre : Polynomial ℚ := C (3)
def VP65_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def VP65_F : Ki := ofLadj VP65_Fre VP65_Fim
def VP65_pre : Polynomial ℚ := C ((-5567675 / 10406 : ℚ)) + C ((7679759 / 5203 : ℚ)) * X ^ 2 + C ((17744167 / 5203 : ℚ)) * X ^ 3 + C ((54037853 / 10406 : ℚ)) * X ^ 4 + C ((64896343 / 10406 : ℚ)) * X ^ 5 + C ((64896343 / 10406 : ℚ)) * X ^ 6 + C ((54037853 / 10406 : ℚ)) * X ^ 7 + C ((17744167 / 5203 : ℚ)) * X ^ 8 + C ((7679759 / 5203 : ℚ)) * X ^ 9
def VP65_pim : Polynomial ℚ := C ((-9704432 / 5203 : ℚ)) + C ((-19408864 / 5203 : ℚ)) * X + C ((-52235175 / 10406 : ℚ)) * X ^ 2 + C ((-55114561 / 10406 : ℚ)) * X ^ 3 + C ((-46635261 / 10406 : ℚ)) * X ^ 4 + C ((-14737006 / 5203 : ℚ)) * X ^ 5 + C ((-4671858 / 5203 : ℚ)) * X ^ 6 + C ((7817533 / 10406 : ℚ)) * X ^ 7 + C ((16296833 / 10406 : ℚ)) * X ^ 8 + C ((13417447 / 10406 : ℚ)) * X ^ 9
theorem VP65_pre_eq :
    VC_0_0_re * VP65_Fre - VC_0_0_im * VP65_Fim = VP65_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP65_Fre, VP65_Fim, VP65_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP65_pim_eq :
    VC_0_0_re * VP65_Fim + VC_0_0_im * VP65_Fre = VP65_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_0_re, VC_0_0_im, VP65_Fre, VP65_Fim, VP65_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP65_mul : VC_0_0 * VP65_F = ofLadj VP65_pre VP65_pim := by
  rw [VC_0_0, VP65_F, ofLadj_mul, VP65_pre_eq, VP65_pim_eq]

def VP66_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def VP66_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def VP66_F : Ki := ofLadj VP66_Fre VP66_Fim
def VP66_pre : Polynomial ℚ := C ((25367543 / 15609 : ℚ)) + C ((179208824 / 15609 : ℚ)) * X + C ((112785290 / 5203 : ℚ)) * X ^ 2 + C ((2133701773 / 62436 : ℚ)) * X ^ 3 + C ((252784308 / 5203 : ℚ)) * X ^ 4 + C ((3476590123 / 62436 : ℚ)) * X ^ 5 + C ((1904262605 / 31218 : ℚ)) * X ^ 6 + C ((660125531 / 10406 : ℚ)) * X ^ 7 + C ((305539512 / 5203 : ℚ)) * X ^ 8 + C ((3611039143 / 62436 : ℚ)) * X ^ 9 + C ((81099682 / 1419 : ℚ)) * X ^ 10 + C ((156858929 / 2838 : ℚ)) * X ^ 11 + C ((237629226 / 5203 : ℚ)) * X ^ 12 + C ((2257615663 / 62436 : ℚ)) * X ^ 13 + C ((1532772371 / 62436 : ℚ)) * X ^ 14 + C ((31100683 / 2838 : ℚ)) * X ^ 15 + C ((90545973 / 20812 : ℚ)) * X ^ 16 + C ((-5024764 / 5203 : ℚ)) * X ^ 17 + C ((-60781616 / 15609 : ℚ)) * X ^ 18
def VP66_pim : Polynomial ℚ := C ((-26719917 / 5203 : ℚ)) + C ((-53439834 / 5203 : ℚ)) * X + C ((-153422803 / 15609 : ℚ)) * X ^ 2 + C ((-55322765 / 5676 : ℚ)) * X ^ 3 + C ((-26727027 / 10406 : ℚ)) * X ^ 4 + C ((47927399 / 5676 : ℚ)) * X ^ 5 + C ((528303509 / 31218 : ℚ)) * X ^ 6 + C ((3358430 / 121 : ℚ)) * X ^ 7 + C ((1052710081 / 31218 : ℚ)) * X ^ 8 + C ((2097430265 / 62436 : ℚ)) * X ^ 9 + C ((1030401863 / 31218 : ℚ)) * X ^ 10 + C ((581830141 / 15609 : ℚ)) * X ^ 11 + C ((1296918701 / 31218 : ℚ)) * X ^ 12 + C ((2529624067 / 62436 : ℚ)) * X ^ 13 + C ((2516493373 / 62436 : ℚ)) * X ^ 14 + C ((348599351 / 10406 : ℚ)) * X ^ 15 + C ((483718839 / 20812 : ℚ)) * X ^ 16 + C ((81533183 / 5203 : ℚ)) * X ^ 17 + C ((87294824 / 15609 : ℚ)) * X ^ 18
theorem VP66_pre_eq :
    VC_1_0_re * VP66_Fre - VC_1_0_im * VP66_Fim = VP66_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP66_Fre, VP66_Fim, VP66_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP66_pim_eq :
    VC_1_0_re * VP66_Fim + VC_1_0_im * VP66_Fre = VP66_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP66_Fre, VP66_Fim, VP66_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP66_mul : VC_1_0 * VP66_F = ofLadj VP66_pre VP66_pim := by
  rw [VC_1_0, VP66_F, ofLadj_mul, VP66_pre_eq, VP66_pim_eq]

def VP67_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP67_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP67_F : Ki := ofLadj VP67_Fre VP67_Fim
def VP67_pre : Polynomial ℚ := C ((-34266863 / 15609 : ℚ)) + C ((-448022060 / 15609 : ℚ)) * X + C ((-913233943 / 15609 : ℚ)) * X ^ 2 + C ((-501506362 / 5203 : ℚ)) * X ^ 3 + C ((-2236836907 / 15609 : ℚ)) * X ^ 4 + C ((-885930565 / 5203 : ℚ)) * X ^ 5 + C ((-999653681 / 5203 : ℚ)) * X ^ 6 + C ((-3184885018 / 15609 : ℚ)) * X ^ 7 + C ((-1010917766 / 5203 : ℚ)) * X ^ 8 + C ((-2975607508 / 15609 : ℚ)) * X ^ 9 + C ((-2931634292 / 15609 : ℚ)) * X ^ 10 + C ((-960275993 / 5203 : ℚ)) * X ^ 11 + C ((-19252808 / 121 : ℚ)) * X ^ 12 + C ((-687457855 / 5203 : ℚ)) * X ^ 13 + C ((-509411404 / 5203 : ℚ)) * X ^ 14 + C ((-282860461 / 5203 : ℚ)) * X ^ 15 + C ((-459247385 / 15609 : ℚ)) * X ^ 16 + C ((-10734367 / 1419 : ℚ)) * X ^ 17 + C ((33155576 / 5203 : ℚ)) * X ^ 18
def VP67_pim : Polynomial ℚ := C ((100401447 / 5203 : ℚ)) + C ((200802894 / 5203 : ℚ)) * X + C ((239337013 / 5203 : ℚ)) * X ^ 2 + C ((281154230 / 5203 : ℚ)) * X ^ 3 + C ((631797887 / 15609 : ℚ)) * X ^ 4 + C ((218433802 / 15609 : ℚ)) * X ^ 5 + C ((-114506024 / 15609 : ℚ)) * X ^ 6 + C ((-605282558 / 15609 : ℚ)) * X ^ 7 + C ((-885430729 / 15609 : ℚ)) * X ^ 8 + C ((-292441467 / 5203 : ℚ)) * X ^ 9 + C ((-839559962 / 15609 : ℚ)) * X ^ 10 + C ((-1084957153 / 15609 : ℚ)) * X ^ 11 + C ((-3664888 / 43 : ℚ)) * X ^ 12 + C ((-1408192262 / 15609 : ℚ)) * X ^ 13 + C ((-138685235 / 1419 : ℚ)) * X ^ 14 + C ((-445885787 / 5203 : ℚ)) * X ^ 15 + C ((-973088707 / 15609 : ℚ)) * X ^ 16 + C ((-232781565 / 5203 : ℚ)) * X ^ 17 + C ((-5961944 / 363 : ℚ)) * X ^ 18
theorem VP67_pre_eq :
    VC_1_0_re * VP67_Fre - VC_1_0_im * VP67_Fim = VP67_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP67_Fre, VP67_Fim, VP67_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP67_pim_eq :
    VC_1_0_re * VP67_Fim + VC_1_0_im * VP67_Fre = VP67_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP67_Fre, VP67_Fim, VP67_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP67_mul : VC_1_0 * VP67_F = ofLadj VP67_pre VP67_pim := by
  rw [VC_1_0, VP67_F, ofLadj_mul, VP67_pre_eq, VP67_pim_eq]

def VP68_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def VP68_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def VP68_F : Ki := ofLadj VP68_Fre VP68_Fim
def VP68_pre : Polynomial ℚ := C ((-40199743 / 15609 : ℚ)) + C ((-627230884 / 15609 : ℚ)) * X + C ((-1254832006 / 15609 : ℚ)) * X ^ 2 + C ((-2042966663 / 15609 : ℚ)) * X ^ 3 + C ((-1033047327 / 5203 : ℚ)) * X ^ 4 + C ((-3745688659 / 15609 : ℚ)) * X ^ 5 + C ((-4339602337 / 15609 : ℚ)) * X ^ 6 + C ((-4732461667 / 15609 : ℚ)) * X ^ 7 + C ((-4650778592 / 15609 : ℚ)) * X ^ 8 + C ((-1571114882 / 5203 : ℚ)) * X ^ 9 + C ((-4761081923 / 15609 : ℚ)) * X ^ 10 + C ((-1579461624 / 5203 : ℚ)) * X ^ 11 + C ((-4133851039 / 15609 : ℚ)) * X ^ 12 + C ((-314410240 / 1419 : ℚ)) * X ^ 13 + C ((-869270643 / 5203 : ℚ)) * X ^ 14 + C ((-135823970 / 1419 : ℚ)) * X ^ 15 + C ((-271210496 / 5203 : ℚ)) * X ^ 16 + C ((-73239270 / 5203 : ℚ)) * X ^ 17 + C ((1079504 / 121 : ℚ)) * X ^ 18
def VP68_pim : Polynomial ℚ := C ((149522467 / 5203 : ℚ)) + C ((299044934 / 5203 : ℚ)) * X + C ((1098540230 / 15609 : ℚ)) * X ^ 2 + C ((1368804686 / 15609 : ℚ)) * X ^ 3 + C ((1185028226 / 15609 : ℚ)) * X ^ 4 + C ((712619269 / 15609 : ℚ)) * X ^ 5 + C ((344177362 / 15609 : ℚ)) * X ^ 6 + C ((-9743323 / 473 : ℚ)) * X ^ 7 + C ((-703971781 / 15609 : ℚ)) * X ^ 8 + C ((-713024540 / 15609 : ℚ)) * X ^ 9 + C ((-754561466 / 15609 : ℚ)) * X ^ 10 + C ((-1263567440 / 15609 : ℚ)) * X ^ 11 + C ((-1772573414 / 15609 : ℚ)) * X ^ 12 + C ((-2015515768 / 15609 : ℚ)) * X ^ 13 + C ((-2294832983 / 15609 : ℚ)) * X ^ 14 + C ((-2084641909 / 15609 : ℚ)) * X ^ 15 + C ((-1559080537 / 15609 : ℚ)) * X ^ 16 + C ((-102519652 / 1419 : ℚ)) * X ^ 17 + C ((-408856736 / 15609 : ℚ)) * X ^ 18
theorem VP68_pre_eq :
    VC_1_0_re * VP68_Fre - VC_1_0_im * VP68_Fim = VP68_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP68_Fre, VP68_Fim, VP68_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP68_pim_eq :
    VC_1_0_re * VP68_Fim + VC_1_0_im * VP68_Fre = VP68_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP68_Fre, VP68_Fim, VP68_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP68_mul : VC_1_0 * VP68_F = ofLadj VP68_pre VP68_pim := by
  rw [VC_1_0, VP68_F, ofLadj_mul, VP68_pre_eq, VP68_pim_eq]

def VP69_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def VP69_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def VP69_F : Ki := ofLadj VP69_Fre VP69_Fim
def VP69_pre : Polynomial ℚ := C ((46677964 / 15609 : ℚ)) + C ((627230884 / 15609 : ℚ)) * X + C ((2493739075 / 31218 : ℚ)) * X ^ 2 + C ((1365705263 / 10406 : ℚ)) * X ^ 3 + C ((6100735049 / 31218 : ℚ)) * X ^ 4 + C ((2421709839 / 10406 : ℚ)) * X ^ 5 + C ((8224003199 / 31218 : ℚ)) * X ^ 6 + C ((4397642888 / 15609 : ℚ)) * X ^ 7 + C ((8376692333 / 31218 : ℚ)) * X ^ 8 + C ((8282925499 / 31218 : ℚ)) * X ^ 9 + C ((373173088 / 1419 : ℚ)) * X ^ 10 + C ((1348196569 / 5203 : ℚ)) * X ^ 11 + C ((3477673084 / 15609 : ℚ)) * X ^ 12 + C ((964864404 / 5203 : ℚ)) * X ^ 13 + C ((2139788272 / 15609 : ℚ)) * X ^ 14 + C ((2362999295 / 31218 : ℚ)) * X ^ 15 + C ((417034617 / 10406 : ℚ)) * X ^ 16 + C ((26566379 / 2838 : ℚ)) * X ^ 17 + C ((-55258572 / 5203 : ℚ)) * X ^ 18
def VP69_pim : Polynomial ℚ := C ((-426166298 / 15609 : ℚ)) + C ((-852332596 / 15609 : ℚ)) * X + C ((-46728601 / 726 : ℚ)) * X ^ 2 + C ((-2405771143 / 31218 : ℚ)) * X ^ 3 + C ((-612718939 / 10406 : ℚ)) * X ^ 4 + C ((-705896303 / 31218 : ℚ)) * X ^ 5 + C ((221338019 / 31218 : ℚ)) * X ^ 6 + C ((807393511 / 15609 : ℚ)) * X ^ 7 + C ((808275151 / 10406 : ℚ)) * X ^ 8 + C ((803911057 / 10406 : ℚ)) * X ^ 9 + C ((1174796620 / 15609 : ℚ)) * X ^ 10 + C ((518260593 / 5203 : ℚ)) * X ^ 11 + C ((1934766938 / 15609 : ℚ)) * X ^ 12 + C ((2056029298 / 15609 : ℚ)) * X ^ 13 + C ((2247703807 / 15609 : ℚ)) * X ^ 14 + C ((3966532591 / 31218 : ℚ)) * X ^ 15 + C ((2914999231 / 31218 : ℚ)) * X ^ 16 + C ((694673659 / 10406 : ℚ)) * X ^ 17 + C ((385649564 / 15609 : ℚ)) * X ^ 18
theorem VP69_pre_eq :
    VC_1_0_re * VP69_Fre - VC_1_0_im * VP69_Fim = VP69_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP69_Fre, VP69_Fim, VP69_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP69_pim_eq :
    VC_1_0_re * VP69_Fim + VC_1_0_im * VP69_Fre = VP69_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP69_Fre, VP69_Fim, VP69_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP69_mul : VC_1_0 * VP69_F = ofLadj VP69_pre VP69_pim := by
  rw [VC_1_0, VP69_F, ofLadj_mul, VP69_pre_eq, VP69_pim_eq]

def VP70_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def VP70_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def VP70_F : Ki := ofLadj VP70_Fre VP70_Fim
def VP70_pre : Polynomial ℚ := C ((3511781 / 15609 : ℚ)) + C ((-89604412 / 15609 : ℚ)) * X + C ((-191717942 / 15609 : ℚ)) * X ^ 2 + C ((-109537012 / 5203 : ℚ)) * X ^ 3 + C ((-174076548 / 5203 : ℚ)) * X ^ 4 + C ((-675228215 / 15609 : ℚ)) * X ^ 5 + C ((-795900500 / 15609 : ℚ)) * X ^ 6 + C ((-831895760 / 15609 : ℚ)) * X ^ 7 + C ((-751209697 / 15609 : ℚ)) * X ^ 8 + C ((-694468237 / 15609 : ℚ)) * X ^ 9 + C ((-217220580 / 5203 : ℚ)) * X ^ 10 + C ((-639587666 / 15609 : ℚ)) * X ^ 11 + C ((-562057328 / 15609 : ℚ)) * X ^ 12 + C ((-502750295 / 15609 : ℚ)) * X ^ 13 + C ((-422598661 / 15609 : ℚ)) * X ^ 14 + C ((-280931572 / 15609 : ℚ)) * X ^ 15 + C ((-1307375 / 129 : ℚ)) * X ^ 16 + C ((-37520090 / 15609 : ℚ)) * X ^ 17 + C ((28734544 / 15609 : ℚ)) * X ^ 18
def VP70_pim : Polynomial ℚ := C ((96082633 / 15609 : ℚ)) + C ((192165266 / 15609 : ℚ)) * X + C ((239337698 / 15609 : ℚ)) * X ^ 2 + C ((101053072 / 5203 : ℚ)) * X ^ 3 + C ((296314112 / 15609 : ℚ)) * X ^ 4 + C ((69679455 / 5203 : ℚ)) * X ^ 5 + C ((29452304 / 5203 : ℚ)) * X ^ 6 + C ((-79316630 / 15609 : ℚ)) * X ^ 7 + C ((-171885469 / 15609 : ℚ)) * X ^ 8 + C ((-54541909 / 5203 : ℚ)) * X ^ 9 + C ((-125889100 / 15609 : ℚ)) * X ^ 10 + C ((-167709004 / 15609 : ℚ)) * X ^ 11 + C ((-209528908 / 15609 : ℚ)) * X ^ 12 + C ((-19905883 / 1419 : ℚ)) * X ^ 13 + C ((-274526489 / 15609 : ℚ)) * X ^ 14 + C ((-291739376 / 15609 : ℚ)) * X ^ 15 + C ((-252504355 / 15609 : ℚ)) * X ^ 16 + C ((-188143664 / 15609 : ℚ)) * X ^ 17 + C ((-68510848 / 15609 : ℚ)) * X ^ 18
theorem VP70_pre_eq :
    VC_1_0_re * VP70_Fre - VC_1_0_im * VP70_Fim = VP70_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP70_Fre, VP70_Fim, VP70_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP70_pim_eq :
    VC_1_0_re * VP70_Fim + VC_1_0_im * VP70_Fre = VP70_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP70_Fre, VP70_Fim, VP70_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP70_mul : VC_1_0 * VP70_F = ofLadj VP70_pre VP70_pim := by
  rw [VC_1_0, VP70_F, ofLadj_mul, VP70_pre_eq, VP70_pim_eq]

def VP71_Fre : Polynomial ℚ := C (3)
def VP71_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def VP71_F : Ki := ofLadj VP71_Fre VP71_Fim
def VP71_pre : Polynomial ℚ := C ((6478221 / 10406 : ℚ)) + C ((-8839900 / 5203 : ℚ)) * X ^ 2 + C ((-40966865 / 10406 : ℚ)) * X ^ 3 + C ((-31167316 / 5203 : ℚ)) * X ^ 4 + C ((-37439360 / 5203 : ℚ)) * X ^ 5 + C ((-37439360 / 5203 : ℚ)) * X ^ 6 + C ((-31167316 / 5203 : ℚ)) * X ^ 7 + C ((-40966865 / 10406 : ℚ)) * X ^ 8 + C ((-8839900 / 5203 : ℚ)) * X ^ 9
def VP71_pim : Polynomial ℚ := C ((22401103 / 10406 : ℚ)) + C ((22401103 / 5203 : ℚ)) * X + C ((30136827 / 5203 : ℚ)) * X ^ 2 + C ((63630931 / 10406 : ℚ)) * X ^ 3 + C ((26908245 / 5203 : ℚ)) * X ^ 4 + C ((17015761 / 5203 : ℚ)) * X ^ 5 + C ((5385342 / 5203 : ℚ)) * X ^ 6 + C ((-4507142 / 5203 : ℚ)) * X ^ 7 + C ((-18828725 / 10406 : ℚ)) * X ^ 8 + C ((-7735724 / 5203 : ℚ)) * X ^ 9
theorem VP71_pre_eq :
    VC_1_0_re * VP71_Fre - VC_1_0_im * VP71_Fim = VP71_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP71_Fre, VP71_Fim, VP71_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP71_pim_eq :
    VC_1_0_re * VP71_Fim + VC_1_0_im * VP71_Fre = VP71_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_1_0_re, VC_1_0_im, VP71_Fre, VP71_Fim, VP71_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP71_mul : VC_1_0 * VP71_F = ofLadj VP71_pre VP71_pim := by
  rw [VC_1_0, VP71_F, ofLadj_mul, VP71_pre_eq, VP71_pim_eq]

def VP72_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def VP72_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def VP72_F : Ki := ofLadj VP72_Fre VP72_Fim
def VP72_pre : Polynomial ℚ := C ((2350874 / 15609 : ℚ)) + C ((17378096 / 15609 : ℚ)) * X + C ((10843418 / 5203 : ℚ)) * X ^ 2 + C ((33538539 / 10406 : ℚ)) * X ^ 3 + C ((72081650 / 15609 : ℚ)) * X ^ 4 + C ((165884401 / 31218 : ℚ)) * X ^ 5 + C ((30070508 / 5203 : ℚ)) * X ^ 6 + C ((8557993 / 1419 : ℚ)) * X ^ 7 + C ((58375437 / 10406 : ℚ)) * X ^ 8 + C ((86221412 / 15609 : ℚ)) * X ^ 9 + C ((170489083 / 31218 : ℚ)) * X ^ 10 + C ((82536584 / 15609 : ℚ)) * X ^ 11 + C ((45244297 / 10406 : ℚ)) * X ^ 12 + C ((53691158 / 15609 : ℚ)) * X ^ 13 + C ((12418449 / 5203 : ℚ)) * X ^ 14 + C ((16694233 / 15609 : ℚ)) * X ^ 15 + C ((1184531 / 2838 : ℚ)) * X ^ 16 + C ((-754403 / 15609 : ℚ)) * X ^ 17 + C ((-5362040 / 15609 : ℚ)) * X ^ 18
def VP72_pim : Polynomial ℚ := C ((-7845886 / 15609 : ℚ)) + C ((-15691772 / 15609 : ℚ)) * X + C ((-4839376 / 5203 : ℚ)) * X ^ 2 + C ((-29446937 / 31218 : ℚ)) * X ^ 3 + C ((-4837711 / 15609 : ℚ)) * X ^ 4 + C ((23917673 / 31218 : ℚ)) * X ^ 5 + C ((24322631 / 15609 : ℚ)) * X ^ 6 + C ((79226423 / 31218 : ℚ)) * X ^ 7 + C ((16188151 / 5203 : ℚ)) * X ^ 8 + C ((48364225 / 15609 : ℚ)) * X ^ 9 + C ((47464562 / 15609 : ℚ)) * X ^ 10 + C ((4915102 / 1419 : ℚ)) * X ^ 11 + C ((60667682 / 15609 : ℚ)) * X ^ 12 + C ((58594375 / 15609 : ℚ)) * X ^ 13 + C ((39066325 / 10406 : ℚ)) * X ^ 14 + C ((98591215 / 31218 : ℚ)) * X ^ 15 + C ((67229623 / 31218 : ℚ)) * X ^ 16 + C ((7514731 / 5203 : ℚ)) * X ^ 17 + C ((2789788 / 5203 : ℚ)) * X ^ 18
theorem VP72_pre_eq :
    VC_0_1_re * VP72_Fre - VC_0_1_im * VP72_Fim = VP72_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP72_Fre, VP72_Fim, VP72_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP72_pim_eq :
    VC_0_1_re * VP72_Fim + VC_0_1_im * VP72_Fre = VP72_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP72_Fre, VP72_Fim, VP72_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP72_mul : VC_0_1 * VP72_F = ofLadj VP72_pre VP72_pim := by
  rw [VC_0_1, VP72_F, ofLadj_mul, VP72_pre_eq, VP72_pim_eq]

def VP73_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP73_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP73_F : Ki := ofLadj VP73_Fre VP73_Fim
def VP73_pre : Polynomial ℚ := C ((-2886710 / 15609 : ℚ)) + C ((-43445240 / 15609 : ℚ)) * X + C ((-29239990 / 5203 : ℚ)) * X ^ 2 + C ((-47175940 / 5203 : ℚ)) * X ^ 3 + C ((-212120602 / 15609 : ℚ)) * X ^ 4 + C ((-253016054 / 15609 : ℚ)) * X ^ 5 + C ((-283511974 / 15609 : ℚ)) * X ^ 6 + C ((-301850474 / 15609 : ℚ)) * X ^ 7 + C ((-288472048 / 15609 : ℚ)) * X ^ 8 + C ((-282925603 / 15609 : ℚ)) * X ^ 9 + C ((-2304830 / 129 : ℚ)) * X ^ 10 + C ((-91532160 / 5203 : ℚ)) * X ^ 11 + C ((-1825110 / 121 : ℚ)) * X ^ 12 + C ((-195205633 / 15609 : ℚ)) * X ^ 13 + C ((-146944228 / 15609 : ℚ)) * X ^ 14 + C ((-27120884 / 5203 : ℚ)) * X ^ 15 + C ((-43250366 / 15609 : ℚ)) * X ^ 16 + C ((-4251482 / 5203 : ℚ)) * X ^ 17 + C ((8367220 / 15609 : ℚ)) * X ^ 18
def VP73_pim : Polynomial ℚ := C ((29389894 / 15609 : ℚ)) + C ((58779788 / 15609 : ℚ)) * X + C ((68200774 / 15609 : ℚ)) * X ^ 2 + C ((26973856 / 5203 : ℚ)) * X ^ 3 + C ((63038332 / 15609 : ℚ)) * X ^ 4 + C ((22482062 / 15609 : ℚ)) * X ^ 5 + C ((-8531980 / 15609 : ℚ)) * X ^ 6 + C ((-52896488 / 15609 : ℚ)) * X ^ 7 + C ((-79617980 / 15609 : ℚ)) * X ^ 8 + C ((-78770761 / 15609 : ℚ)) * X ^ 9 + C ((-25018570 / 5203 : ℚ)) * X ^ 10 + C ((-9029362 / 1419 : ℚ)) * X ^ 11 + C ((-123590254 / 15609 : ℚ)) * X ^ 12 + C ((-11754199 / 1419 : ℚ)) * X ^ 13 + C ((-47056588 / 5203 : ℚ)) * X ^ 14 + C ((-41904336 / 5203 : ℚ)) * X ^ 15 + C ((-89772856 / 15609 : ℚ)) * X ^ 16 + C ((-64043402 / 15609 : ℚ)) * X ^ 17 + C ((-24295012 / 15609 : ℚ)) * X ^ 18
theorem VP73_pre_eq :
    VC_0_1_re * VP73_Fre - VC_0_1_im * VP73_Fim = VP73_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP73_Fre, VP73_Fim, VP73_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP73_pim_eq :
    VC_0_1_re * VP73_Fim + VC_0_1_im * VP73_Fre = VP73_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP73_Fre, VP73_Fim, VP73_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP73_mul : VC_0_1 * VP73_F = ofLadj VP73_pre VP73_pim := by
  rw [VC_0_1, VP73_F, ofLadj_mul, VP73_pre_eq, VP73_pim_eq]

def VP74_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def VP74_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def VP74_F : Ki := ofLadj VP74_Fre VP74_Fim
def VP74_pre : Polynomial ℚ := C ((-3243934 / 15609 : ℚ)) + C ((-60823336 / 15609 : ℚ)) * X + C ((-120449644 / 15609 : ℚ)) * X ^ 2 + C ((-63903228 / 5203 : ℚ)) * X ^ 3 + C ((-293705536 / 15609 : ℚ)) * X ^ 4 + C ((-356518012 / 15609 : ℚ)) * X ^ 5 + C ((-409799510 / 15609 : ℚ)) * X ^ 6 + C ((-13574871 / 473 : ℚ)) * X ^ 7 + C ((-40165310 / 1419 : ℚ)) * X ^ 8 + C ((-447570604 / 15609 : ℚ)) * X ^ 9 + C ((-452124512 / 15609 : ℚ)) * X ^ 10 + C ((-150214914 / 5203 : ℚ)) * X ^ 11 + C ((-391301176 / 15609 : ℚ)) * X ^ 12 + C ((-109040320 / 5203 : ℚ)) * X ^ 13 + C ((-5816482 / 363 : ℚ)) * X ^ 14 + C ((-142730191 / 15609 : ℚ)) * X ^ 15 + C ((-76576334 / 15609 : ℚ)) * X ^ 16 + C ((-23294836 / 15609 : ℚ)) * X ^ 17 + C ((11535016 / 15609 : ℚ)) * X ^ 18
def VP74_pim : Polynomial ℚ := C ((3977506 / 1419 : ℚ)) + C ((7955012 / 1419 : ℚ)) * X + C ((104329796 / 15609 : ℚ)) * X ^ 2 + C ((131267914 / 15609 : ℚ)) * X ^ 3 + C ((39053048 / 5203 : ℚ)) * X ^ 4 + C ((70086218 / 15609 : ℚ)) * X ^ 5 + C ((35883854 / 15609 : ℚ)) * X ^ 6 + C ((-23844955 / 15609 : ℚ)) * X ^ 7 + C ((-165806 / 43 : ℚ)) * X ^ 8 + C ((-60956234 / 15609 : ℚ)) * X ^ 9 + C ((-64752200 / 15609 : ℚ)) * X ^ 10 + C ((-114288388 / 15609 : ℚ)) * X ^ 11 + C ((-54608192 / 5203 : ℚ)) * X ^ 12 + C ((-16767746 / 1419 : ℚ)) * X ^ 13 + C ((-212151980 / 15609 : ℚ)) * X ^ 14 + C ((-413761 / 33 : ℚ)) * X ^ 15 + C ((-47880400 / 5203 : ℚ)) * X ^ 16 + C ((-103400516 / 15609 : ℚ)) * X ^ 17 + C ((-3516080 / 1419 : ℚ)) * X ^ 18
theorem VP74_pre_eq :
    VC_0_1_re * VP74_Fre - VC_0_1_im * VP74_Fim = VP74_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP74_Fre, VP74_Fim, VP74_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP74_pim_eq :
    VC_0_1_re * VP74_Fim + VC_0_1_im * VP74_Fre = VP74_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP74_Fre, VP74_Fim, VP74_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP74_mul : VC_0_1 * VP74_F = ofLadj VP74_pre VP74_pim := by
  rw [VC_0_1, VP74_F, ofLadj_mul, VP74_pre_eq, VP74_pim_eq]

def VP75_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def VP75_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def VP75_F : Ki := ofLadj VP75_Fre VP75_Fim
def VP75_pre : Polynomial ℚ := C ((1302828 / 5203 : ℚ)) + C ((60823336 / 15609 : ℚ)) * X + C ((119740073 / 15609 : ℚ)) * X ^ 2 + C ((192486479 / 15609 : ℚ)) * X ^ 3 + C ((96421129 / 5203 : ℚ)) * X ^ 4 + C ((345880753 / 15609 : ℚ)) * X ^ 5 + C ((129529814 / 5203 : ℚ)) * X ^ 6 + C ((416744291 / 15609 : ℚ)) * X ^ 7 + C ((398469892 / 15609 : ℚ)) * X ^ 8 + C ((131267242 / 5203 : ℚ)) * X ^ 9 + C ((390506141 / 15609 : ℚ)) * X ^ 10 + C ((35049680 / 1419 : ℚ)) * X ^ 11 + C ((329682805 / 15609 : ℚ)) * X ^ 12 + C ((274061653 / 15609 : ℚ)) * X ^ 13 + C ((205983413 / 15609 : ℚ)) * X ^ 14 + C ((113386294 / 15609 : ℚ)) * X ^ 15 + C ((58946432 / 15609 : ℚ)) * X ^ 16 + C ((5412581 / 5203 : ℚ)) * X ^ 17 + C ((-14094610 / 15609 : ℚ)) * X ^ 18
def VP75_pim : Polynomial ℚ := C ((-41580304 / 15609 : ℚ)) + C ((-83160608 / 15609 : ℚ)) * X + C ((-31781905 / 5203 : ℚ)) * X ^ 2 + C ((-115406983 / 15609 : ℚ)) * X ^ 3 + C ((-91561553 / 15609 : ℚ)) * X ^ 4 + C ((-11917505 / 5203 : ℚ)) * X ^ 5 + C ((7456645 / 15609 : ℚ)) * X ^ 6 + C ((70306655 / 15609 : ℚ)) * X ^ 7 + C ((109003637 / 15609 : ℚ)) * X ^ 8 + C ((108273215 / 15609 : ℚ)) * X ^ 9 + C ((105094501 / 15609 : ℚ)) * X ^ 10 + C ((142527794 / 15609 : ℚ)) * X ^ 11 + C ((59987029 / 5203 : ℚ)) * X ^ 12 + C ((62989160 / 5203 : ℚ)) * X ^ 13 + C ((208298326 / 15609 : ℚ)) * X ^ 14 + C ((186544744 / 15609 : ℚ)) * X ^ 15 + C ((134590139 / 15609 : ℚ)) * X ^ 16 + C ((95600711 / 15609 : ℚ)) * X ^ 17 + C ((36605134 / 15609 : ℚ)) * X ^ 18
theorem VP75_pre_eq :
    VC_0_1_re * VP75_Fre - VC_0_1_im * VP75_Fim = VP75_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP75_Fre, VP75_Fim, VP75_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP75_pim_eq :
    VC_0_1_re * VP75_Fim + VC_0_1_im * VP75_Fre = VP75_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP75_Fre, VP75_Fim, VP75_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP75_mul : VC_0_1 * VP75_F = ofLadj VP75_pre VP75_pim := by
  rw [VC_0_1, VP75_F, ofLadj_mul, VP75_pre_eq, VP75_pim_eq]

def VP76_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def VP76_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def VP76_F : Ki := ofLadj VP76_Fre VP76_Fim
def VP76_pre : Polynomial ℚ := C ((485938 / 15609 : ℚ)) + C ((-8689048 / 15609 : ℚ)) * X + C ((-18403508 / 15609 : ℚ)) * X ^ 2 + C ((-30696964 / 15609 : ℚ)) * X ^ 3 + C ((-49380088 / 15609 : ℚ)) * X ^ 4 + C ((-64340840 / 15609 : ℚ)) * X ^ 5 + C ((-25061704 / 5203 : ℚ)) * X ^ 6 + C ((-78382148 / 15609 : ℚ)) * X ^ 7 + C ((-71147024 / 15609 : ℚ)) * X ^ 8 + C ((-66147430 / 15609 : ℚ)) * X ^ 9 + C ((-1876592 / 473 : ℚ)) * X ^ 10 + C ((-20229584 / 5203 : ℚ)) * X ^ 11 + C ((-53238488 / 15609 : ℚ)) * X ^ 12 + C ((-47743922 / 15609 : ℚ)) * X ^ 13 + C ((-40450060 / 15609 : ℚ)) * X ^ 14 + C ((-8854988 / 5203 : ℚ)) * X ^ 15 + C ((-4939464 / 5203 : ℚ)) * X ^ 16 + C ((-3974120 / 15609 : ℚ)) * X ^ 17 + C ((2437096 / 15609 : ℚ)) * X ^ 18
def VP76_pim : Polynomial ℚ := C ((3117866 / 5203 : ℚ)) + C ((6235732 / 5203 : ℚ)) * X + C ((22704068 / 15609 : ℚ)) * X ^ 2 + C ((2632064 / 1419 : ℚ)) * X ^ 3 + C ((877926 / 473 : ℚ)) * X ^ 4 + C ((20265418 / 15609 : ℚ)) * X ^ 5 + C ((8676706 / 15609 : ℚ)) * X ^ 6 + C ((-592588 / 1419 : ℚ)) * X ^ 7 + C ((-4981374 / 5203 : ℚ)) * X ^ 8 + C ((-1302830 / 1419 : ℚ)) * X ^ 9 + C ((-3694062 / 5203 : ℚ)) * X ^ 10 + C ((-457140 / 473 : ℚ)) * X ^ 11 + C ((-6363018 / 5203 : ℚ)) * X ^ 12 + C ((-163942 / 129 : ℚ)) * X ^ 13 + C ((-25472626 / 15609 : ℚ)) * X ^ 14 + C ((-27416782 / 15609 : ℚ)) * X ^ 15 + C ((-7726220 / 5203 : ℚ)) * X ^ 16 + C ((-17227508 / 15609 : ℚ)) * X ^ 17 + C ((-2166784 / 5203 : ℚ)) * X ^ 18
theorem VP76_pre_eq :
    VC_0_1_re * VP76_Fre - VC_0_1_im * VP76_Fim = VP76_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP76_Fre, VP76_Fim, VP76_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP76_pim_eq :
    VC_0_1_re * VP76_Fim + VC_0_1_im * VP76_Fre = VP76_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP76_Fre, VP76_Fim, VP76_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP76_mul : VC_0_1 * VP76_F = ofLadj VP76_pre VP76_pim := by
  rw [VC_0_1, VP76_F, ofLadj_mul, VP76_pre_eq, VP76_pim_eq]

def VP77_Fre : Polynomial ℚ := C (3)
def VP77_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def VP77_F : Ki := ofLadj VP77_Fre VP77_Fim
def VP77_pre : Polynomial ℚ := C ((332275 / 5203 : ℚ)) + C ((-853198 / 5203 : ℚ)) * X ^ 2 + C ((-1905349 / 5203 : ℚ)) * X ^ 3 + C ((-2902749 / 5203 : ℚ)) * X ^ 4 + C ((-3540764 / 5203 : ℚ)) * X ^ 5 + C ((-3540764 / 5203 : ℚ)) * X ^ 6 + C ((-2902749 / 5203 : ℚ)) * X ^ 7 + C ((-1905349 / 5203 : ℚ)) * X ^ 8 + C ((-853198 / 5203 : ℚ)) * X ^ 9
def VP77_pim : Polynomial ℚ := C ((1086131 / 5203 : ℚ)) + C ((2172262 / 5203 : ℚ)) * X + C ((2862844 / 5203 : ℚ)) * X ^ 2 + C ((2998223 / 5203 : ℚ)) * X ^ 3 + C ((2575462 / 5203 : ℚ)) * X ^ 4 + C ((1651783 / 5203 : ℚ)) * X ^ 5 + C ((520479 / 5203 : ℚ)) * X ^ 6 + C ((-403200 / 5203 : ℚ)) * X ^ 7 + C ((-825961 / 5203 : ℚ)) * X ^ 8 + C ((-690582 / 5203 : ℚ)) * X ^ 9
theorem VP77_pre_eq :
    VC_0_1_re * VP77_Fre - VC_0_1_im * VP77_Fim = VP77_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP77_Fre, VP77_Fim, VP77_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP77_pim_eq :
    VC_0_1_re * VP77_Fim + VC_0_1_im * VP77_Fre = VP77_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_0_1_re, VC_0_1_im, VP77_Fre, VP77_Fim, VP77_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP77_mul : VC_0_1 * VP77_F = ofLadj VP77_pre VP77_pim := by
  rw [VC_0_1, VP77_F, ofLadj_mul, VP77_pre_eq, VP77_pim_eq]

def VP78_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def VP78_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def VP78_F : Ki := ofLadj VP78_Fre VP78_Fim
def VP78_pre : Polynomial ℚ := C ((-4681383 / 10406 : ℚ)) + C ((-16698200 / 5203 : ℚ)) * X + C ((-377660123 / 62436 : ℚ)) * X ^ 2 + C ((-53935993 / 5676 : ℚ)) * X ^ 3 + C ((-844856387 / 62436 : ℚ)) * X ^ 4 + C ((-968780579 / 62436 : ℚ)) * X ^ 5 + C ((-2120151139 / 124872 : ℚ)) * X ^ 6 + C ((-1102940519 / 62436 : ℚ)) * X ^ 7 + C ((-681349555 / 41624 : ℚ)) * X ^ 8 + C ((-2012965381 / 124872 : ℚ)) * X ^ 9 + C ((-994729111 / 62436 : ℚ)) * X ^ 10 + C ((-962200103 / 62436 : ℚ)) * X ^ 11 + C ((-72213701 / 5676 : ℚ)) * X ^ 12 + C ((-419215045 / 41624 : ℚ)) * X ^ 13 + C ((-857456819 / 124872 : ℚ)) * X ^ 14 + C ((-191368075 / 62436 : ℚ)) * X ^ 15 + C ((-50592203 / 41624 : ℚ)) * X ^ 16 + C ((2567781 / 10406 : ℚ)) * X ^ 17 + C ((66716057 / 62436 : ℚ)) * X ^ 18
def VP78_pim : Polynomial ℚ := C ((22453192 / 15609 : ℚ)) + C ((44906384 / 15609 : ℚ)) * X + C ((15518531 / 5676 : ℚ)) * X ^ 2 + C ((340299935 / 124872 : ℚ)) * X ^ 3 + C ((354823 / 473 : ℚ)) * X ^ 4 + C ((-145496717 / 62436 : ℚ)) * X ^ 5 + C ((-24373528 / 5203 : ℚ)) * X ^ 6 + C ((-119805742 / 15609 : ℚ)) * X ^ 7 + C ((-388721635 / 41624 : ℚ)) * X ^ 8 + C ((-96811973 / 10406 : ℚ)) * X ^ 9 + C ((-380397975 / 41624 : ℚ)) * X ^ 10 + C ((-53785719 / 5203 : ℚ)) * X ^ 11 + C ((-43652139 / 3784 : ℚ)) * X ^ 12 + C ((-701063723 / 62436 : ℚ)) * X ^ 13 + C ((-698299235 / 62436 : ℚ)) * X ^ 14 + C ((-193823191 / 20812 : ℚ)) * X ^ 15 + C ((-804661523 / 124872 : ℚ)) * X ^ 16 + C ((-541843811 / 124872 : ℚ)) * X ^ 17 + C ((-32458605 / 20812 : ℚ)) * X ^ 18
theorem VP78_pre_eq :
    VC_2_0_re * VP78_Fre - VC_2_0_im * VP78_Fim = VP78_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP78_Fre, VP78_Fim, VP78_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP78_pim_eq :
    VC_2_0_re * VP78_Fim + VC_2_0_im * VP78_Fre = VP78_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP78_Fre, VP78_Fim, VP78_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP78_mul : VC_2_0 * VP78_F = ofLadj VP78_pre VP78_pim := by
  rw [VC_2_0, VP78_F, ofLadj_mul, VP78_pre_eq, VP78_pim_eq]

def VP79_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def VP79_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def VP79_F : Ki := ofLadj VP79_Fre VP79_Fim
def VP79_pre : Polynomial ℚ := C ((3100941 / 5203 : ℚ)) + C ((41745500 / 5203 : ℚ)) * X + C ((254776375 / 15609 : ℚ)) * X ^ 2 + C ((278768275 / 10406 : ℚ)) * X ^ 3 + C ((14481851 / 363 : ℚ)) * X ^ 4 + C ((987044827 / 20812 : ℚ)) * X ^ 5 + C ((1112484851 / 20812 : ℚ)) * X ^ 6 + C ((3545627687 / 62436 : ℚ)) * X ^ 7 + C ((3378683389 / 62436 : ℚ)) * X ^ 8 + C ((3314811559 / 62436 : ℚ)) * X ^ 9 + C ((1088696933 / 20812 : ℚ)) * X ^ 10 + C ((267573005 / 5203 : ℚ)) * X ^ 11 + C ((21435231 / 484 : ℚ)) * X ^ 12 + C ((17796171 / 484 : ℚ)) * X ^ 13 + C ((1706073739 / 62436 : ℚ)) * X ^ 14 + C ((86047369 / 5676 : ℚ)) * X ^ 15 + C ((85164005 / 10406 : ℚ)) * X ^ 16 + C ((2040363 / 946 : ℚ)) * X ^ 17 + C ((-27057064 / 15609 : ℚ)) * X ^ 18
def VP79_pim : Polynomial ℚ := C ((-168622385 / 31218 : ℚ)) + C ((-168622385 / 15609 : ℚ)) * X + C ((-66624106 / 5203 : ℚ)) * X ^ 2 + C ((-235388656 / 15609 : ℚ)) * X ^ 3 + C ((-355021655 / 31218 : ℚ)) * X ^ 4 + C ((-247444787 / 62436 : ℚ)) * X ^ 5 + C ((40813007 / 20812 : ℚ)) * X ^ 6 + C ((221384373 / 20812 : ℚ)) * X ^ 7 + C ((325461901 / 20812 : ℚ)) * X ^ 8 + C ((29307103 / 1892 : ℚ)) * X ^ 9 + C ((924831775 / 62436 : ℚ)) * X ^ 10 + C ((100024260 / 5203 : ℚ)) * X ^ 11 + C ((1475750465 / 62436 : ℚ)) * X ^ 12 + C ((1558447573 / 62436 : ℚ)) * X ^ 13 + C ((1691261621 / 62436 : ℚ)) * X ^ 14 + C ((1486675321 / 62436 : ℚ)) * X ^ 15 + C ((179715507 / 10406 : ℚ)) * X ^ 16 + C ((64400452 / 5203 : ℚ)) * X ^ 17 + C ((142653785 / 31218 : ℚ)) * X ^ 18
theorem VP79_pre_eq :
    VC_2_0_re * VP79_Fre - VC_2_0_im * VP79_Fim = VP79_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP79_Fre, VP79_Fim, VP79_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP79_pim_eq :
    VC_2_0_re * VP79_Fim + VC_2_0_im * VP79_Fre = VP79_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP79_Fre, VP79_Fim, VP79_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP79_mul : VC_2_0 * VP79_F = ofLadj VP79_pre VP79_pim := by
  rw [VC_2_0, VP79_F, ofLadj_mul, VP79_pre_eq, VP79_pim_eq]

def VP80_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def VP80_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def VP80_F : Ki := ofLadj VP80_Fre VP80_Fim
def VP80_pre : Polynomial ℚ := C ((3607774 / 5203 : ℚ)) + C ((58443700 / 5203 : ℚ)) * X + C ((700049981 / 31218 : ℚ)) * X ^ 2 + C ((2270165539 / 62436 : ℚ)) * X ^ 3 + C ((3450740465 / 62436 : ℚ)) * X ^ 4 + C ((4173022159 / 62436 : ℚ)) * X ^ 5 + C ((4828400345 / 62436 : ℚ)) * X ^ 6 + C ((877882015 / 10406 : ℚ)) * X ^ 7 + C ((1294995572 / 15609 : ℚ)) * X ^ 8 + C ((5249451319 / 62436 : ℚ)) * X ^ 9 + C ((441871545 / 5203 : ℚ)) * X ^ 10 + C ((2639545255 / 31218 : ℚ)) * X ^ 11 + C ((383427845 / 5203 : ℚ)) * X ^ 12 + C ((29839933 / 484 : ℚ)) * X ^ 13 + C ((2909816749 / 62436 : ℚ)) * X ^ 14 + C ((555149065 / 20812 : ℚ)) * X ^ 15 + C ((905090345 / 62436 : ℚ)) * X ^ 16 + C ((249712159 / 62436 : ℚ)) * X ^ 17 + C ((-75552215 / 31218 : ℚ)) * X ^ 18
def VP80_pim : Polynomial ℚ := C ((-251099719 / 31218 : ℚ)) + C ((-251099719 / 15609 : ℚ)) * X + C ((-305788009 / 15609 : ℚ)) * X ^ 2 + C ((-12626491 / 516 : ℚ)) * X ^ 3 + C ((-10306355 / 484 : ℚ)) * X ^ 4 + C ((-799491109 / 62436 : ℚ)) * X ^ 5 + C ((-130099459 / 20812 : ℚ)) * X ^ 6 + C ((171775075 / 31218 : ℚ)) * X ^ 7 + C ((192368426 / 15609 : ℚ)) * X ^ 8 + C ((779308103 / 62436 : ℚ)) * X ^ 9 + C ((872381 / 66 : ℚ)) * X ^ 10 + C ((116239029 / 5203 : ℚ)) * X ^ 11 + C ((982232135 / 31218 : ℚ)) * X ^ 12 + C ((2229181753 / 62436 : ℚ)) * X ^ 13 + C ((2543669527 / 62436 : ℚ)) * X ^ 14 + C ((2316452123 / 62436 : ℚ)) * X ^ 15 + C ((52339867 / 1892 : ℚ)) * X ^ 16 + C ((415970565 / 20812 : ℚ)) * X ^ 17 + C ((227427671 / 31218 : ℚ)) * X ^ 18
theorem VP80_pre_eq :
    VC_2_0_re * VP80_Fre - VC_2_0_im * VP80_Fim = VP80_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP80_Fre, VP80_Fim, VP80_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP80_pim_eq :
    VC_2_0_re * VP80_Fim + VC_2_0_im * VP80_Fre = VP80_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP80_Fre, VP80_Fim, VP80_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP80_mul : VC_2_0 * VP80_F = ofLadj VP80_pre VP80_pim := by
  rw [VC_2_0, VP80_F, ofLadj_mul, VP80_pre_eq, VP80_pim_eq]

def VP81_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def VP81_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def VP81_F : Ki := ofLadj VP81_Fre VP81_Fim
def VP81_pre : Polynomial ℚ := C ((-25314361 / 31218 : ℚ)) + C ((-58443700 / 5203 : ℚ)) * X + C ((-1391355155 / 62436 : ℚ)) * X ^ 2 + C ((-2276945687 / 62436 : ℚ)) * X ^ 3 + C ((-1698421391 / 31218 : ℚ)) * X ^ 4 + C ((-674543349 / 10406 : ℚ)) * X ^ 5 + C ((-138662555 / 1892 : ℚ)) * X ^ 6 + C ((-4895568343 / 62436 : ℚ)) * X ^ 7 + C ((-1166584054 / 15609 : ℚ)) * X ^ 8 + C ((-4613533765 / 62436 : ℚ)) * X ^ 9 + C ((-381111493 / 5203 : ℚ)) * X ^ 10 + C ((-2253959801 / 31218 : ℚ)) * X ^ 11 + C ((-322667793 / 5203 : ℚ)) * X ^ 12 + C ((-1611089305 / 31218 : ℚ)) * X ^ 13 + C ((-2389390529 / 62436 : ℚ)) * X ^ 14 + C ((-658999597 / 31218 : ℚ)) * X ^ 15 + C ((-232052657 / 20812 : ℚ)) * X ^ 16 + C ((-27925625 / 10406 : ℚ)) * X ^ 17 + C ((180726367 / 62436 : ℚ)) * X ^ 18
def VP81_pim : Polynomial ℚ := C ((238576069 / 31218 : ℚ)) + C ((238576069 / 15609 : ℚ)) * X + C ((559233239 / 31218 : ℚ)) * X ^ 2 + C ((111898559 / 5203 : ℚ)) * X ^ 3 + C ((258148624 / 15609 : ℚ)) * X ^ 4 + C ((132834629 / 20812 : ℚ)) * X ^ 5 + C ((-116601673 / 62436 : ℚ)) * X ^ 6 + C ((-885386461 / 62436 : ℚ)) * X ^ 7 + C ((-222817875 / 10406 : ℚ)) * X ^ 8 + C ((-664661827 / 31218 : ℚ)) * X ^ 9 + C ((-647136779 / 31218 : ℚ)) * X ^ 10 + C ((-13033964 / 473 : ℚ)) * X ^ 11 + C ((-1073346469 / 31218 : ℚ)) * X ^ 12 + C ((-568951261 / 15609 : ℚ)) * X ^ 13 + C ((-1246268839 / 31218 : ℚ)) * X ^ 14 + C ((-200413175 / 5676 : ℚ)) * X ^ 15 + C ((-1615356823 / 62436 : ℚ)) * X ^ 16 + C ((-384402537 / 20812 : ℚ)) * X ^ 17 + C ((-4992155 / 726 : ℚ)) * X ^ 18
theorem VP81_pre_eq :
    VC_2_0_re * VP81_Fre - VC_2_0_im * VP81_Fim = VP81_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP81_Fre, VP81_Fim, VP81_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP81_pim_eq :
    VC_2_0_re * VP81_Fim + VC_2_0_im * VP81_Fre = VP81_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP81_Fre, VP81_Fim, VP81_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP81_mul : VC_2_0 * VP81_F = ofLadj VP81_pre VP81_pim := by
  rw [VC_2_0, VP81_F, ofLadj_mul, VP81_pre_eq, VP81_pim_eq]

def VP82_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def VP82_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def VP82_F : Ki := ofLadj VP82_Fre VP82_Fim
def VP82_pre : Polynomial ℚ := C ((-1073609 / 15609 : ℚ)) + C ((8349100 / 5203 : ℚ)) * X + C ((35652151 / 10406 : ℚ)) * X ^ 2 + C ((91214737 / 15609 : ℚ)) * X ^ 3 + C ((96873019 / 10406 : ℚ)) * X ^ 4 + C ((188103053 / 15609 : ℚ)) * X ^ 5 + C ((442800331 / 31218 : ℚ)) * X ^ 6 + C ((231278830 / 15609 : ℚ)) * X ^ 7 + C ((209065295 / 15609 : ℚ)) * X ^ 8 + C ((193466807 / 15609 : ℚ)) * X ^ 9 + C ((362938141 / 31218 : ℚ)) * X ^ 10 + C ((59353515 / 5203 : ℚ)) * X ^ 11 + C ((312843541 / 31218 : ℚ)) * X ^ 12 + C ((279977161 / 31218 : ℚ)) * X ^ 13 + C ((117850558 / 15609 : ℚ)) * X ^ 14 + C ((26047095 / 5203 : ℚ)) * X ^ 15 + C ((14650811 / 5203 : ℚ)) * X ^ 16 + C ((58707 / 86 : ℚ)) * X ^ 17 + C ((-15656033 / 31218 : ℚ)) * X ^ 18
def VP82_pim : Polynomial ℚ := C ((-53762317 / 31218 : ℚ)) + C ((-53762317 / 15609 : ℚ)) * X + C ((-66605585 / 15609 : ℚ)) * X ^ 2 + C ((-15368509 / 2838 : ℚ)) * X ^ 3 + C ((-82941677 / 15609 : ℚ)) * X ^ 4 + C ((-58463309 / 15609 : ℚ)) * X ^ 5 + C ((-24744320 / 15609 : ℚ)) * X ^ 6 + C ((14353235 / 10406 : ℚ)) * X ^ 7 + C ((47112485 / 15609 : ℚ)) * X ^ 8 + C ((44892374 / 15609 : ℚ)) * X ^ 9 + C ((34577036 / 15609 : ℚ)) * X ^ 10 + C ((15412847 / 5203 : ℚ)) * X ^ 11 + C ((57900046 / 15609 : ℚ)) * X ^ 12 + C ((60427976 / 15609 : ℚ)) * X ^ 13 + C ((152258159 / 31218 : ℚ)) * X ^ 14 + C ((81060619 / 15609 : ℚ)) * X ^ 15 + C ((69887447 / 15609 : ℚ)) * X ^ 16 + C ((52034947 / 15609 : ℚ)) * X ^ 17 + C ((12710647 / 10406 : ℚ)) * X ^ 18
theorem VP82_pre_eq :
    VC_2_0_re * VP82_Fre - VC_2_0_im * VP82_Fim = VP82_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP82_Fre, VP82_Fim, VP82_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP82_pim_eq :
    VC_2_0_re * VP82_Fim + VC_2_0_im * VP82_Fre = VP82_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP82_Fre, VP82_Fim, VP82_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP82_mul : VC_2_0 * VP82_F = ofLadj VP82_pre VP82_pim := by
  rw [VC_2_0, VP82_F, ofLadj_mul, VP82_pre_eq, VP82_pim_eq]

def VP83_Fre : Polynomial ℚ := C (3)
def VP83_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def VP83_F : Ki := ofLadj VP83_Fre VP83_Fim
def VP83_pre : Polynomial ℚ := C ((-3667717 / 20812 : ℚ)) + C ((9873979 / 20812 : ℚ)) * X ^ 2 + C ((22730835 / 20812 : ℚ)) * X ^ 3 + C ((34591065 / 20812 : ℚ)) * X ^ 4 + C ((10415228 / 5203 : ℚ)) * X ^ 5 + C ((10415228 / 5203 : ℚ)) * X ^ 6 + C ((34591065 / 20812 : ℚ)) * X ^ 7 + C ((22730835 / 20812 : ℚ)) * X ^ 8 + C ((9873979 / 20812 : ℚ)) * X ^ 9
def VP83_pim : Polynomial ℚ := C ((-6261825 / 10406 : ℚ)) + C ((-6261825 / 5203 : ℚ)) * X + C ((-762666 / 473 : ℚ)) * X ^ 2 + C ((-35394677 / 20812 : ℚ)) * X ^ 3 + C ((-7501717 / 5203 : ℚ)) * X ^ 4 + C ((-4762284 / 5203 : ℚ)) * X ^ 5 + C ((-1499541 / 5203 : ℚ)) * X ^ 6 + C ((1239892 / 5203 : ℚ)) * X ^ 7 + C ((10347377 / 20812 : ℚ)) * X ^ 8 + C ((2127501 / 5203 : ℚ)) * X ^ 9
theorem VP83_pre_eq :
    VC_2_0_re * VP83_Fre - VC_2_0_im * VP83_Fim = VP83_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP83_Fre, VP83_Fim, VP83_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP83_pim_eq :
    VC_2_0_re * VP83_Fim + VC_2_0_im * VP83_Fre = VP83_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [VC_2_0_re, VC_2_0_im, VP83_Fre, VP83_Fim, VP83_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem VP83_mul : VC_2_0 * VP83_F = ofLadj VP83_pre VP83_pim := by
  rw [VC_2_0, VP83_F, ofLadj_mul, VP83_pre_eq, VP83_pim_eq]

end V14Formalization.D12SigmaPlusSegreCore
