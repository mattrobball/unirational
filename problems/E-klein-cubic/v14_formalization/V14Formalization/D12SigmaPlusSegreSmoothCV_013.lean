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

def CV_013_0_pre : Polynomial ℚ := interpQ 8639957931 [-212293078387944, -2865488547213600, -5830161041723592, -9580756229916692, -14263235347959992, -16950565436977304, -19113567250044384, -20302147449976504, -19342370660441004, -18976868373725320, -18697603748116124, -18381390930861120, -15832115200902524, -13146707332001728, -9761614430524312, -5415178189071200, -2927474728140036, -764472915072956, 623733912945312]
def CV_013_0_pim : Polynomial ℚ := interpQ 8639957931 [1929326069334600, 3858652138669200, 4578285458689032, 5391755712136108, 4056670240718544, 1413287328399192, -705493208677904, -3816434685031296, -5602593367362096, -5549953001633012, -5308120068197512, -6883040903832040, -8457961739466568, -8935762126050900, -9696592013768892, -8515058410498976, -6182276419797348, -4432947368918820, -1632606814183152]
theorem CV_013_0_pre_eq :
    CV_0_re_002 * Fplus_dU_re_011 - CV_0_im_002 * Fplus_dU_im_011 = CV_013_0_pre := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_013_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_013_0_pim_eq :
    CV_0_re_002 * Fplus_dU_im_011 + CV_0_im_002 * Fplus_dU_re_011 = CV_013_0_pim := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_013_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_013_0_mul :
    CV_0_c_002 * Fplus_dU_c_011 = ofLadj CV_013_0_pre CV_013_0_pim := by
  rw [CV_0_c_002_def, Fplus_dU_c_011_def, ofLadj_mul, CV_013_0_pre_eq, CV_013_0_pim_eq]

def CV_013_1_pre : Polynomial ℚ := interpQ 8639957931 [442758015758424, 6082765530604000, 12073461254285240, 19779781801018016, 29496279389188676, 35132588947442216, 39741618058575736, 42507876127232732, 40512283011545992, 40054447105714444, 39705230123562396, 39131974892107568, 33622464592958396, 27980985851429204, 20732501210527976, 11436450209232812, 6050167615707568, 1441138504574048, -1575146528811244]
def CV_013_1_pim : Polynomial ℚ := interpQ 8639957931 [-4136962559360296, -8273925118720592, -9708927906412956, -11653911691532228, -8939578862345512, -3449880859361100, 1029700542031752, 7720346471364548, 11639763319780736, 11574185056648468, 11271264840024652, 14964645574038616, 18658026308052580, 19790108879121128, 21669514401108132, 19146960732083224, 14046556063461928, 10028990283224060, 3727637688254380]
theorem CV_013_1_pre_eq :
    CV_1_re_002 * Fplus_dV_re_011 - CV_1_im_002 * Fplus_dV_im_011 = CV_013_1_pre := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_013_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_013_1_pim_eq :
    CV_1_re_002 * Fplus_dV_im_011 + CV_1_im_002 * Fplus_dV_re_011 = CV_013_1_pim := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_013_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_013_1_mul :
    CV_1_c_002 * Fplus_dV_c_011 = ofLadj CV_013_1_pre CV_013_1_pim := by
  rw [CV_1_c_002_def, Fplus_dV_c_011_def, ofLadj_mul, CV_013_1_pre_eq, CV_013_1_pim_eq]

def CV_013_2_pre : Polynomial ℚ := interpQ 8639957931 [7761711275272, -162804631785056, -346976811741012, -593612445887344, -945304212952588, -1223448447283804, -1440823669193472, -1505172860234000, -1359861015834812, -1257728812174100, -1179965296884384, -1158516006254152, -1017160665099328, -910752000433088, -766248569947468, -508215492070548, -285845585496544, -68470363586876, 51653155210864]
def CV_013_2_pim : Polynomial ℚ := interpQ 8639957931 [174920349090440, 349840698180880, 433709348664820, 550601588190184, 539760575505228, 380509970056016, 161733331645572, -141034193741072, -307357143538912, -292815983957200, -225258245927276, -301293559905208, -377328873883140, -393639786337156, -495990866280808, -527817376596644, -455434464035536, -339555259295588, -123655426797048]
theorem CV_013_2_pre_eq :
    CV_2_re_002 * Fplus_dW_re_011 - CV_2_im_002 * Fplus_dW_im_011 = CV_013_2_pre := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_013_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_013_2_pim_eq :
    CV_2_re_002 * Fplus_dW_im_011 + CV_2_im_002 * Fplus_dW_re_011 = CV_013_2_pim := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_013_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_013_2_mul :
    CV_2_c_002 * Fplus_dW_c_011 = ofLadj CV_013_2_pre CV_013_2_pim := by
  rw [CV_2_c_002_def, Fplus_dW_c_011_def, ofLadj_mul, CV_013_2_pre_eq, CV_013_2_pim_eq]

theorem CV_013_3_mul : CV_3_c_003 = ofLadj CV_3_re_003 CV_3_im_003 := CV_3_c_003_def

@[expose] public def CV_coeff_013 : Ki := CV_0_c_002 * Fplus_dU_c_011 + CV_1_c_002 * Fplus_dV_c_011 + CV_2_c_002 * Fplus_dW_c_011 + CV_3_c_003

theorem CV_coeff_013_sum :
    CV_coeff_013 = ofLadj (CV_013_0_pre + CV_013_1_pre + CV_013_2_pre + CV_3_re_003) (CV_013_0_pim + CV_013_1_pim + CV_013_2_pim + CV_3_im_003) := by
  simp only [CV_coeff_013, CV_013_0_mul, CV_013_1_mul, CV_013_2_mul, CV_013_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_013_0_pre CV_013_0_pim CV_013_1_pre CV_013_1_pim CV_013_2_pre CV_013_2_pim CV_3_re_003 CV_3_im_003

def CV_013_qre : Polynomial ℚ := interpQ 8639957931 [235593123569592, 2818879228035752, 2849662207962156, 3718888308938192, 4691581681965132, 2676209226020076, 2228652076156772, 1507954686569284, -899759460655068]
def CV_013_qim : Polynomial ℚ := interpQ 8639957931 [-2042424584401504, -2042424584401504, -637971272030200, -1016224554325360, 1372846576070828, 2695239765358560, 2152357524619392, 3285112207735472, 1971375447274180]
theorem CV_coeff_013_poly_re :
    CV_013_0_pre + CV_013_1_pre + CV_013_2_pre + CV_3_re_003 = (0 : Polynomial ℚ) + Phi11 * CV_013_qre := by
  rw [phi11_interpQ]
  simp only [CV_013_0_pre, CV_013_1_pre, CV_013_2_pre, CV_3_re_003_def, CV_013_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_013_poly_im :
    CV_013_0_pim + CV_013_1_pim + CV_013_2_pim + CV_3_im_003 = (0 : Polynomial ℚ) + Phi11 * CV_013_qim := by
  rw [phi11_interpQ]
  simp only [CV_013_0_pim, CV_013_1_pim, CV_013_2_pim, CV_3_im_003_def, CV_013_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_013_eq :
    CV_coeff_013 = (0 : Ki) := by
  rw [CV_coeff_013_sum, CV_coeff_013_poly_re,
    CV_coeff_013_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
