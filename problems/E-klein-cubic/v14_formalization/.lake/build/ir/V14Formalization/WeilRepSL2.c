// Lean compiler output
// Module: V14Formalization.WeilRepSL2
// Imports: public import Init public meta import Init public import V14Formalization.WeilRep public import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup public import Mathlib.Data.Matrix.Basic
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
lean_object* lean_nat_mod(lean_object*, lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
lean_object* lp_mathlib_Equiv_refl(lean_object*);
lean_object* lp_mathlib_ZMod_instField___redArg(lean_object*);
lean_object* lp_mathlib_Field_toSemifield___redArg(lean_object*);
lean_object* lp_mathlib_Semifield_toDivisionSemiring___redArg(lean_object*);
lean_object* lp_mathlib_instMulZeroClassOfSemiring___redArg(lean_object*);
lean_object* lp_mathlib_Field_toDivisionRing___redArg(lean_object*);
lean_object* lp_mathlib_Ring_toAddCommGroup___redArg(lean_object*);
lean_object* lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(lean_object*);
lean_object* lp_mathlib_Ring_toAddGroupWithOne___redArg(lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_ea(lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_eb(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_ec(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_ed(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___lam__0(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__0;
static lean_once_cell_t lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__1;
static lean_once_cell_t lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__2;
static lean_once_cell_t lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__3;
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_negI___lam__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_negI___lam__0___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_negI___lam__1(lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_WeilRepSL2_negI___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_negI___closed__0;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_negI;
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0(void){
_start:
{
lean_object* v___x_1_; lean_object* v___x_2_; lean_object* v___x_3_; 
v___x_1_ = lean_unsigned_to_nat(2u);
v___x_2_ = lean_unsigned_to_nat(0u);
v___x_3_ = lean_nat_mod(v___x_2_, v___x_1_);
return v___x_3_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_ea(lean_object* v_g_4_){
_start:
{
lean_object* v___x_5_; lean_object* v___x_6_; 
v___x_5_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0, &lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0);
v___x_6_ = lean_apply_2(v_g_4_, v___x_5_, v___x_5_);
return v___x_6_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0(void){
_start:
{
lean_object* v___x_7_; lean_object* v___x_8_; lean_object* v___x_9_; 
v___x_7_ = lean_unsigned_to_nat(2u);
v___x_8_ = lean_unsigned_to_nat(1u);
v___x_9_ = lean_nat_mod(v___x_8_, v___x_7_);
return v___x_9_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_eb(lean_object* v_g_10_){
_start:
{
lean_object* v___x_11_; lean_object* v___x_12_; lean_object* v___x_13_; 
v___x_11_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0, &lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0);
v___x_12_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0, &lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0);
v___x_13_ = lean_apply_2(v_g_10_, v___x_11_, v___x_12_);
return v___x_13_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_ec(lean_object* v_g_14_){
_start:
{
lean_object* v___x_15_; lean_object* v___x_16_; lean_object* v___x_17_; 
v___x_15_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0, &lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0);
v___x_16_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0, &lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilRepSL2_ea___closed__0);
v___x_17_ = lean_apply_2(v_g_14_, v___x_15_, v___x_16_);
return v___x_17_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_ed(lean_object* v_g_18_){
_start:
{
lean_object* v___x_19_; lean_object* v___x_20_; 
v___x_19_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0, &lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilRepSL2_eb___closed__0);
v___x_20_ = lean_apply_2(v_g_18_, v___x_19_, v___x_19_);
return v___x_20_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___lam__0(lean_object* v_toZero_21_, lean_object* v_d_22_, lean_object* v_i_23_, lean_object* v_j_24_){
_start:
{
uint8_t v___x_25_; 
v___x_25_ = lean_nat_dec_eq(v_i_23_, v_j_24_);
if (v___x_25_ == 0)
{
lean_dec(v_i_23_);
lean_dec_ref(v_d_22_);
lean_inc(v_toZero_21_);
return v_toZero_21_;
}
else
{
lean_object* v___x_26_; 
v___x_26_ = lean_apply_1(v_d_22_, v_i_23_);
return v___x_26_;
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___lam__0___boxed(lean_object* v_toZero_27_, lean_object* v_d_28_, lean_object* v_i_29_, lean_object* v_j_30_){
_start:
{
lean_object* v_res_31_; 
v_res_31_ = lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___lam__0(v_toZero_27_, v_d_28_, v_i_29_, v_j_30_);
lean_dec(v_j_30_);
lean_dec(v_toZero_27_);
return v_res_31_;
}
}
static lean_object* _init_lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__0(void){
_start:
{
lean_object* v___x_32_; lean_object* v___x_33_; 
v___x_32_ = lean_unsigned_to_nat(11u);
v___x_33_ = lp_mathlib_ZMod_instField___redArg(v___x_32_);
return v___x_33_;
}
}
static lean_object* _init_lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__1(void){
_start:
{
lean_object* v___x_34_; lean_object* v___x_35_; 
v___x_34_ = lean_obj_once(&lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__0, &lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__0_once, _init_lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__0);
v___x_35_ = lp_mathlib_Field_toSemifield___redArg(v___x_34_);
return v___x_35_;
}
}
static lean_object* _init_lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__2(void){
_start:
{
lean_object* v___x_36_; lean_object* v___x_37_; 
v___x_36_ = lean_obj_once(&lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__1, &lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__1_once, _init_lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__1);
v___x_37_ = lp_mathlib_Semifield_toDivisionSemiring___redArg(v___x_36_);
return v___x_37_;
}
}
static lean_object* _init_lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__3(void){
_start:
{
lean_object* v___x_38_; 
v___x_38_ = lp_mathlib_Equiv_refl(lean_box(0));
return v___x_38_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0(lean_object* v_d_39_, lean_object* v_a_40_, lean_object* v_a_41_){
_start:
{
lean_object* v___x_42_; lean_object* v_toSemiring_43_; lean_object* v___x_44_; lean_object* v_toZero_45_; lean_object* v___x_46_; lean_object* v_toFun_47_; lean_object* v___f_48_; lean_object* v___x_49_; 
v___x_42_ = lean_obj_once(&lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__2, &lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__2_once, _init_lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__2);
v_toSemiring_43_ = lean_ctor_get(v___x_42_, 0);
lean_inc_ref(v_toSemiring_43_);
v___x_44_ = lp_mathlib_instMulZeroClassOfSemiring___redArg(v_toSemiring_43_);
v_toZero_45_ = lean_ctor_get(v___x_44_, 1);
lean_inc(v_toZero_45_);
lean_dec_ref(v___x_44_);
v___x_46_ = lean_obj_once(&lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__3, &lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__3_once, _init_lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__3);
v_toFun_47_ = lean_ctor_get(v___x_46_, 0);
v___f_48_ = lean_alloc_closure((void*)(lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___lam__0___boxed), 4, 2);
lean_closure_set(v___f_48_, 0, v_toZero_45_);
lean_closure_set(v___f_48_, 1, v_d_39_);
lean_inc(v_toFun_47_);
v___x_49_ = lean_apply_3(v_toFun_47_, v___f_48_, v_a_40_, v_a_41_);
return v___x_49_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_negI___lam__0(lean_object* v_toOne_50_, lean_object* v_x_51_){
_start:
{
lean_inc(v_toOne_50_);
return v_toOne_50_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_negI___lam__0___boxed(lean_object* v_toOne_52_, lean_object* v_x_53_){
_start:
{
lean_object* v_res_54_; 
v_res_54_ = lp_V14Formalization_V14Formalization_WeilRepSL2_negI___lam__0(v_toOne_52_, v_x_53_);
lean_dec(v_x_53_);
lean_dec(v_toOne_52_);
return v_res_54_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_negI___lam__1(lean_object* v___f_55_, lean_object* v_toNeg_56_, lean_object* v___y_57_, lean_object* v___y_58_){
_start:
{
lean_object* v___x_59_; lean_object* v___x_60_; 
v___x_59_ = lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0(v___f_55_, v___y_57_, v___y_58_);
v___x_60_ = lean_apply_1(v_toNeg_56_, v___x_59_);
return v___x_60_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRepSL2_negI___closed__0(void){
_start:
{
lean_object* v___x_61_; lean_object* v___x_62_; 
v___x_61_ = lean_obj_once(&lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__0, &lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__0_once, _init_lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_WeilRepSL2_negI_spec__0___closed__0);
v___x_62_ = lp_mathlib_Field_toDivisionRing___redArg(v___x_61_);
return v___x_62_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRepSL2_negI(void){
_start:
{
lean_object* v___x_63_; lean_object* v_toRing_64_; lean_object* v___x_65_; lean_object* v___x_66_; lean_object* v_toNeg_67_; lean_object* v___x_68_; lean_object* v_toAddMonoidWithOne_69_; lean_object* v_toOne_70_; lean_object* v___f_71_; lean_object* v___f_72_; 
v___x_63_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilRepSL2_negI___closed__0, &lp_V14Formalization_V14Formalization_WeilRepSL2_negI___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilRepSL2_negI___closed__0);
v_toRing_64_ = lean_ctor_get(v___x_63_, 0);
v___x_65_ = lp_mathlib_Ring_toAddCommGroup___redArg(v_toRing_64_);
v___x_66_ = lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(v___x_65_);
lean_dec_ref(v___x_65_);
v_toNeg_67_ = lean_ctor_get(v___x_66_, 1);
lean_inc(v_toNeg_67_);
lean_dec_ref(v___x_66_);
lean_inc_ref(v_toRing_64_);
v___x_68_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_64_);
v_toAddMonoidWithOne_69_ = lean_ctor_get(v___x_68_, 1);
lean_inc_ref(v_toAddMonoidWithOne_69_);
lean_dec_ref(v___x_68_);
v_toOne_70_ = lean_ctor_get(v_toAddMonoidWithOne_69_, 2);
lean_inc(v_toOne_70_);
lean_dec_ref(v_toAddMonoidWithOne_69_);
v___f_71_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRepSL2_negI___lam__0___boxed), 2, 1);
lean_closure_set(v___f_71_, 0, v_toOne_70_);
v___f_72_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRepSL2_negI___lam__1), 4, 2);
lean_closure_set(v___f_72_, 0, v___f_71_);
lean_closure_set(v___f_72_, 1, v_toNeg_67_);
return v___f_72_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilRep(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_SpecialLinearGroup(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Matrix_Basic(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_WeilRepSL2(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_WeilRep(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_SpecialLinearGroup(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Matrix_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
lp_V14Formalization_V14Formalization_WeilRepSL2_negI = _init_lp_V14Formalization_V14Formalization_WeilRepSL2_negI();
lean_mark_persistent(lp_V14Formalization_V14Formalization_WeilRepSL2_negI);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
