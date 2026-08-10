// Lean compiler output
// Module: V14Formalization.ResidualNotInM
// Imports: public import Init public meta import Init public import Mathlib.Data.ZMod.Basic public import Mathlib.Data.Fintype.BigOperators public import Mathlib.Algebra.BigOperators.Group.Finset.Basic public import Mathlib.Tactic.NormNum public import Mathlib.Tactic.Ring public import Mathlib.Data.Fin.VecNotation
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
lean_object* lp_mathlib_ZMod_commRing(lean_object*);
lean_object* lp_mathlib_Ring_toAddGroupWithOne___redArg(lean_object*);
lean_object* l_Fin_cases___redArg(lean_object*, lean_object*, lean_object*);
lean_object* lean_nat_mod(lean_object*, lean_object*);
lean_object* lp_mathlib_instMulZeroClassOfSemiring___redArg(lean_object*);
lean_object* lp_mathlib_AddGroupWithOne_toAddGroup___redArg(lean_object*);
lean_object* lp_mathlib_instDistribOfSemiring___redArg(lean_object*);
static lean_once_cell_t lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0;
static lean_once_cell_t lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1;
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__0(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__0___boxed(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__1(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__1___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed(lean_object*, lean_object*, lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__0___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__0_value;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__1;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__2;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__3;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__4;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__5;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__6;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__7_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__7;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__8_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__8;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__9;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__10_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__10;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___boxed(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___lam__5(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___lam__5___boxed(lean_object*, lean_object*, lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__1;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__2;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__4;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__5;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__6;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__7_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__7;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__8_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__8;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___boxed(lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness___closed__0;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness___boxed(lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__1;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_minor01;
static lean_object* _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0(void){
_start:
{
lean_object* v___x_1_; lean_object* v___x_2_; 
v___x_1_ = lean_unsigned_to_nat(23u);
v___x_2_ = lp_mathlib_ZMod_commRing(v___x_1_);
return v___x_2_;
}
}
static lean_object* _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1(void){
_start:
{
lean_object* v___x_3_; lean_object* v___x_4_; 
v___x_3_ = lean_obj_once(&lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0, &lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0_once, _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0);
v___x_4_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v___x_3_);
return v___x_4_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(lean_object* v_a_5_){
_start:
{
lean_object* v___x_6_; lean_object* v_toAddMonoidWithOne_7_; lean_object* v_toNatCast_8_; lean_object* v___x_9_; 
v___x_6_ = lean_obj_once(&lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1, &lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1_once, _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1);
v_toAddMonoidWithOne_7_ = lean_ctor_get(v___x_6_, 1);
v_toNatCast_8_ = lean_ctor_get(v_toAddMonoidWithOne_7_, 0);
lean_inc(v_toNatCast_8_);
v___x_9_ = lean_apply_1(v_toNatCast_8_, v_a_5_);
return v___x_9_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__0(lean_object* v___y_10_){
_start:
{
lean_internal_panic_unreachable();
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__0___boxed(lean_object* v___y_11_){
_start:
{
lean_object* v_res_12_; 
v_res_12_ = lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__0(v___y_11_);
lean_dec(v___y_11_);
return v_res_12_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__1(lean_object* v_toOne_13_, lean_object* v___f_14_, lean_object* v___y_15_){
_start:
{
lean_object* v___x_16_; 
v___x_16_ = l_Fin_cases___redArg(v_toOne_13_, v___f_14_, v___y_15_);
return v___x_16_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__1___boxed(lean_object* v_toOne_17_, lean_object* v___f_18_, lean_object* v___y_19_){
_start:
{
lean_object* v_res_20_; 
v_res_20_ = lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__1(v_toOne_17_, v___f_18_, v___y_19_);
lean_dec(v___y_19_);
lean_dec(v_toOne_17_);
return v_res_20_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2(lean_object* v___x_21_, lean_object* v___f_22_, lean_object* v___y_23_){
_start:
{
lean_object* v___x_24_; 
v___x_24_ = l_Fin_cases___redArg(v___x_21_, v___f_22_, v___y_23_);
return v___x_24_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed(lean_object* v___x_25_, lean_object* v___f_26_, lean_object* v___y_27_){
_start:
{
lean_object* v_res_28_; 
v_res_28_ = lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2(v___x_25_, v___f_26_, v___y_27_);
lean_dec(v___y_27_);
lean_dec(v___x_25_);
return v_res_28_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__1(void){
_start:
{
lean_object* v___x_30_; lean_object* v___x_31_; 
v___x_30_ = lean_unsigned_to_nat(15u);
v___x_31_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_30_);
return v___x_31_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__2(void){
_start:
{
lean_object* v___x_32_; lean_object* v___x_33_; 
v___x_32_ = lean_unsigned_to_nat(10u);
v___x_33_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_32_);
return v___x_33_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__3(void){
_start:
{
lean_object* v___x_34_; lean_object* v___x_35_; 
v___x_34_ = lean_unsigned_to_nat(16u);
v___x_35_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_34_);
return v___x_35_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__4(void){
_start:
{
lean_object* v___x_36_; lean_object* v___x_37_; 
v___x_36_ = lean_unsigned_to_nat(14u);
v___x_37_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_36_);
return v___x_37_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__5(void){
_start:
{
lean_object* v___x_38_; lean_object* v___x_39_; 
v___x_38_ = lean_unsigned_to_nat(6u);
v___x_39_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_38_);
return v___x_39_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__6(void){
_start:
{
lean_object* v___x_40_; lean_object* v___x_41_; 
v___x_40_ = lean_unsigned_to_nat(11u);
v___x_41_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_40_);
return v___x_41_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__7(void){
_start:
{
lean_object* v___x_42_; lean_object* v___x_43_; 
v___x_42_ = lean_unsigned_to_nat(21u);
v___x_43_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_42_);
return v___x_43_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__8(void){
_start:
{
lean_object* v___x_44_; lean_object* v___x_45_; 
v___x_44_ = lean_unsigned_to_nat(2u);
v___x_45_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_44_);
return v___x_45_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__9(void){
_start:
{
lean_object* v___x_46_; lean_object* v___x_47_; 
v___x_46_ = lean_unsigned_to_nat(9u);
v___x_47_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_46_);
return v___x_47_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__10(void){
_start:
{
lean_object* v___x_48_; lean_object* v___x_49_; 
v___x_48_ = lean_unsigned_to_nat(5u);
v___x_49_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_48_);
return v___x_49_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega(lean_object* v_a_50_){
_start:
{
lean_object* v___x_51_; lean_object* v_toAddMonoidWithOne_52_; lean_object* v_toOne_53_; lean_object* v___f_54_; lean_object* v___x_55_; lean_object* v___x_56_; lean_object* v___x_57_; lean_object* v___x_58_; lean_object* v___x_59_; lean_object* v___x_60_; lean_object* v___x_61_; lean_object* v___x_62_; lean_object* v___f_63_; lean_object* v___x_64_; lean_object* v___x_65_; lean_object* v___f_66_; lean_object* v___f_67_; lean_object* v___f_68_; lean_object* v___f_69_; lean_object* v___f_70_; lean_object* v___f_71_; lean_object* v___f_72_; lean_object* v___f_73_; lean_object* v___f_74_; lean_object* v___f_75_; lean_object* v___f_76_; lean_object* v___f_77_; lean_object* v___f_78_; lean_object* v___x_79_; 
v___x_51_ = lean_obj_once(&lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1, &lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1_once, _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1);
v_toAddMonoidWithOne_52_ = lean_ctor_get(v___x_51_, 1);
v_toOne_53_ = lean_ctor_get(v_toAddMonoidWithOne_52_, 2);
v___f_54_ = ((lean_object*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__0));
v___x_55_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__1, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__1_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__1);
v___x_56_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__2, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__2_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__2);
v___x_57_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__3, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__3_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__3);
v___x_58_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__4, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__4_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__4);
v___x_59_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__5, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__5_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__5);
v___x_60_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__6, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__6_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__6);
v___x_61_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__7, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__7_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__7);
v___x_62_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__8, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__8_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__8);
lean_inc_n(v_toOne_53_, 2);
v___f_63_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__1___boxed), 3, 2);
lean_closure_set(v___f_63_, 0, v_toOne_53_);
lean_closure_set(v___f_63_, 1, v___f_54_);
v___x_64_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__9, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__9_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__9);
v___x_65_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__10, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__10_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__10);
v___f_66_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_66_, 0, v___x_65_);
lean_closure_set(v___f_66_, 1, v___f_63_);
v___f_67_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_67_, 0, v___x_64_);
lean_closure_set(v___f_67_, 1, v___f_66_);
v___f_68_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__1___boxed), 3, 2);
lean_closure_set(v___f_68_, 0, v_toOne_53_);
lean_closure_set(v___f_68_, 1, v___f_67_);
v___f_69_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_69_, 0, v___x_57_);
lean_closure_set(v___f_69_, 1, v___f_68_);
v___f_70_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_70_, 0, v___x_62_);
lean_closure_set(v___f_70_, 1, v___f_69_);
v___f_71_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_71_, 0, v___x_55_);
lean_closure_set(v___f_71_, 1, v___f_70_);
v___f_72_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_72_, 0, v___x_61_);
lean_closure_set(v___f_72_, 1, v___f_71_);
v___f_73_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_73_, 0, v___x_57_);
lean_closure_set(v___f_73_, 1, v___f_72_);
v___f_74_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_74_, 0, v___x_60_);
lean_closure_set(v___f_74_, 1, v___f_73_);
v___f_75_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_75_, 0, v___x_59_);
lean_closure_set(v___f_75_, 1, v___f_74_);
v___f_76_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_76_, 0, v___x_58_);
lean_closure_set(v___f_76_, 1, v___f_75_);
v___f_77_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_77_, 0, v___x_57_);
lean_closure_set(v___f_77_, 1, v___f_76_);
v___f_78_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_78_, 0, v___x_56_);
lean_closure_set(v___f_78_, 1, v___f_77_);
v___x_79_ = l_Fin_cases___redArg(v___x_55_, v___f_78_, v_a_50_);
return v___x_79_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_omega___boxed(lean_object* v_a_80_){
_start:
{
lean_object* v_res_81_; 
v_res_81_ = lp_V14Formalization_V14Formalization_ResidualNotInM_omega(v_a_80_);
lean_dec(v_a_80_);
return v_res_81_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___lam__5(lean_object* v_toZero_82_, lean_object* v___f_83_, lean_object* v___y_84_){
_start:
{
lean_object* v___x_85_; 
v___x_85_ = l_Fin_cases___redArg(v_toZero_82_, v___f_83_, v___y_84_);
return v___x_85_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___lam__5___boxed(lean_object* v_toZero_86_, lean_object* v___f_87_, lean_object* v___y_88_){
_start:
{
lean_object* v_res_89_; 
v_res_89_ = lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___lam__5(v_toZero_86_, v___f_87_, v___y_88_);
lean_dec(v___y_88_);
lean_dec(v_toZero_86_);
return v_res_89_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__0(void){
_start:
{
lean_object* v___x_90_; lean_object* v___x_91_; 
v___x_90_ = lean_unsigned_to_nat(3u);
v___x_91_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_90_);
return v___x_91_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__1(void){
_start:
{
lean_object* v___x_92_; lean_object* v___x_93_; 
v___x_92_ = lean_unsigned_to_nat(19u);
v___x_93_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_92_);
return v___x_93_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__2(void){
_start:
{
lean_object* v___x_94_; lean_object* v___x_95_; 
v___x_94_ = lean_unsigned_to_nat(17u);
v___x_95_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_94_);
return v___x_95_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3(void){
_start:
{
lean_object* v___x_96_; lean_object* v___x_97_; 
v___x_96_ = lean_unsigned_to_nat(20u);
v___x_97_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_96_);
return v___x_97_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__4(void){
_start:
{
lean_object* v___f_98_; lean_object* v___x_99_; lean_object* v___f_100_; 
v___f_98_ = ((lean_object*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__0));
v___x_99_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3, &lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3);
v___f_100_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_100_, 0, v___x_99_);
lean_closure_set(v___f_100_, 1, v___f_98_);
return v___f_100_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__5(void){
_start:
{
lean_object* v___x_101_; lean_object* v___x_102_; 
v___x_101_ = lean_unsigned_to_nat(8u);
v___x_102_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0(v___x_101_);
return v___x_102_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__6(void){
_start:
{
lean_object* v___f_103_; lean_object* v___x_104_; lean_object* v___f_105_; 
v___f_103_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__4, &lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__4_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__4);
v___x_104_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__2, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__2_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__2);
v___f_105_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_105_, 0, v___x_104_);
lean_closure_set(v___f_105_, 1, v___f_103_);
return v___f_105_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__7(void){
_start:
{
lean_object* v___f_106_; lean_object* v___x_107_; lean_object* v___f_108_; 
v___f_106_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__6, &lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__6_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__6);
v___x_107_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__5, &lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__5_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__5);
v___f_108_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_108_, 0, v___x_107_);
lean_closure_set(v___f_108_, 1, v___f_106_);
return v___f_108_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__8(void){
_start:
{
lean_object* v___f_109_; lean_object* v___x_110_; lean_object* v___f_111_; 
v___f_109_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__7, &lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__7_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__7);
v___x_110_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3, &lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3);
v___f_111_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_111_, 0, v___x_110_);
lean_closure_set(v___f_111_, 1, v___f_109_);
return v___f_111_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega(lean_object* v_a_112_){
_start:
{
lean_object* v___x_113_; lean_object* v_toSemiring_114_; lean_object* v___x_115_; lean_object* v_toZero_116_; lean_object* v___x_117_; lean_object* v___x_118_; lean_object* v___x_119_; lean_object* v___x_120_; lean_object* v___x_121_; lean_object* v___x_122_; lean_object* v___f_123_; lean_object* v___f_124_; lean_object* v___f_125_; lean_object* v___f_126_; lean_object* v___f_127_; lean_object* v___f_128_; lean_object* v___f_129_; lean_object* v___f_130_; lean_object* v___f_131_; lean_object* v___f_132_; lean_object* v___f_133_; lean_object* v___x_134_; 
v___x_113_ = lean_obj_once(&lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0, &lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0_once, _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0);
v_toSemiring_114_ = lean_ctor_get(v___x_113_, 0);
lean_inc_ref(v_toSemiring_114_);
v___x_115_ = lp_mathlib_instMulZeroClassOfSemiring___redArg(v_toSemiring_114_);
v_toZero_116_ = lean_ctor_get(v___x_115_, 1);
lean_inc_n(v_toZero_116_, 2);
lean_dec_ref(v___x_115_);
v___x_117_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__0, &lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__0_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__0);
v___x_118_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__1, &lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__1_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__1);
v___x_119_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__2, &lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__2_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__2);
v___x_120_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__3, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__3_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__3);
v___x_121_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__7, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__7_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__7);
v___x_122_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__5, &lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__5_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_omega___closed__5);
v___f_123_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__8, &lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__8_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__8);
v___f_124_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___lam__5___boxed), 3, 2);
lean_closure_set(v___f_124_, 0, v_toZero_116_);
lean_closure_set(v___f_124_, 1, v___f_123_);
v___f_125_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_125_, 0, v___x_119_);
lean_closure_set(v___f_125_, 1, v___f_124_);
v___f_126_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_126_, 0, v___x_121_);
lean_closure_set(v___f_126_, 1, v___f_125_);
v___f_127_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_127_, 0, v___x_122_);
lean_closure_set(v___f_127_, 1, v___f_126_);
v___f_128_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_128_, 0, v___x_121_);
lean_closure_set(v___f_128_, 1, v___f_127_);
v___f_129_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_129_, 0, v___x_117_);
lean_closure_set(v___f_129_, 1, v___f_128_);
v___f_130_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_130_, 0, v___x_120_);
lean_closure_set(v___f_130_, 1, v___f_129_);
v___f_131_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_131_, 0, v___x_119_);
lean_closure_set(v___f_131_, 1, v___f_130_);
v___f_132_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___lam__5___boxed), 3, 2);
lean_closure_set(v___f_132_, 0, v_toZero_116_);
lean_closure_set(v___f_132_, 1, v___f_131_);
v___f_133_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_ResidualNotInM_omega___lam__2___boxed), 3, 2);
lean_closure_set(v___f_133_, 0, v___x_118_);
lean_closure_set(v___f_133_, 1, v___f_132_);
v___x_134_ = l_Fin_cases___redArg(v___x_117_, v___f_133_, v_a_112_);
return v___x_134_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___boxed(lean_object* v_a_135_){
_start:
{
lean_object* v_res_136_; 
v_res_136_ = lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega(v_a_135_);
lean_dec(v_a_135_);
return v_res_136_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness___closed__0(void){
_start:
{
lean_object* v___x_137_; lean_object* v___x_138_; 
v___x_137_ = lean_obj_once(&lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1, &lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1_once, _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__1);
v___x_138_ = lp_mathlib_AddGroupWithOne_toAddGroup___redArg(v___x_137_);
return v___x_138_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness(lean_object* v_p_139_){
_start:
{
lean_object* v___x_140_; lean_object* v___x_141_; lean_object* v_toSub_142_; lean_object* v_toSemiring_143_; lean_object* v___x_144_; lean_object* v_toMul_145_; lean_object* v___x_146_; lean_object* v___x_147_; lean_object* v___x_148_; lean_object* v___x_149_; lean_object* v___x_150_; 
v___x_140_ = lean_obj_once(&lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0, &lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0_once, _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0);
v___x_141_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness___closed__0, &lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness___closed__0_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness___closed__0);
v_toSub_142_ = lean_ctor_get(v___x_141_, 2);
v_toSemiring_143_ = lean_ctor_get(v___x_140_, 0);
lean_inc_ref(v_toSemiring_143_);
v___x_144_ = lp_mathlib_instDistribOfSemiring___redArg(v_toSemiring_143_);
v_toMul_145_ = lean_ctor_get(v___x_144_, 0);
lean_inc(v_toMul_145_);
lean_dec_ref(v___x_144_);
v___x_146_ = lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega(v_p_139_);
v___x_147_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3, &lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega___closed__3);
v___x_148_ = lp_V14Formalization_V14Formalization_ResidualNotInM_omega(v_p_139_);
v___x_149_ = lean_apply_2(v_toMul_145_, v___x_147_, v___x_148_);
lean_inc(v_toSub_142_);
v___x_150_ = lean_apply_2(v_toSub_142_, v___x_146_, v___x_149_);
return v___x_150_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness___boxed(lean_object* v_p_151_){
_start:
{
lean_object* v_res_152_; 
v_res_152_ = lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness(v_p_151_);
lean_dec(v_p_151_);
return v_res_152_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__0(void){
_start:
{
lean_object* v___x_153_; lean_object* v___x_154_; lean_object* v___x_155_; 
v___x_153_ = lean_unsigned_to_nat(15u);
v___x_154_ = lean_unsigned_to_nat(0u);
v___x_155_ = lean_nat_mod(v___x_154_, v___x_153_);
return v___x_155_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__1(void){
_start:
{
lean_object* v___x_156_; lean_object* v___x_157_; lean_object* v___x_158_; 
v___x_156_ = lean_unsigned_to_nat(15u);
v___x_157_ = lean_unsigned_to_nat(1u);
v___x_158_ = lean_nat_mod(v___x_157_, v___x_156_);
return v___x_158_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_ResidualNotInM_minor01(void){
_start:
{
lean_object* v___x_159_; lean_object* v___x_160_; lean_object* v_toSub_161_; lean_object* v_toSemiring_162_; lean_object* v___x_163_; lean_object* v_toMul_164_; lean_object* v___x_165_; lean_object* v___x_166_; lean_object* v___x_167_; lean_object* v___x_168_; lean_object* v___x_169_; lean_object* v___x_170_; lean_object* v___x_171_; lean_object* v___x_172_; lean_object* v___x_173_; 
v___x_159_ = lean_obj_once(&lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0, &lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0_once, _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_ResidualNotInM_omega_spec__0___closed__0);
v___x_160_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness___closed__0, &lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness___closed__0_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_pureMWitness___closed__0);
v_toSub_161_ = lean_ctor_get(v___x_160_, 2);
v_toSemiring_162_ = lean_ctor_get(v___x_159_, 0);
lean_inc_ref(v_toSemiring_162_);
v___x_163_ = lp_mathlib_instDistribOfSemiring___redArg(v_toSemiring_162_);
v_toMul_164_ = lean_ctor_get(v___x_163_, 0);
lean_inc_n(v_toMul_164_, 2);
lean_dec_ref(v___x_163_);
v___x_165_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__0, &lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__0_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__0);
v___x_166_ = lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega(v___x_165_);
v___x_167_ = lean_obj_once(&lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__1, &lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__1_once, _init_lp_V14Formalization_V14Formalization_ResidualNotInM_minor01___closed__1);
v___x_168_ = lp_V14Formalization_V14Formalization_ResidualNotInM_omega(v___x_167_);
v___x_169_ = lean_apply_2(v_toMul_164_, v___x_166_, v___x_168_);
v___x_170_ = lp_V14Formalization_V14Formalization_ResidualNotInM_chiSumOmega(v___x_167_);
v___x_171_ = lp_V14Formalization_V14Formalization_ResidualNotInM_omega(v___x_165_);
v___x_172_ = lean_apply_2(v_toMul_164_, v___x_170_, v___x_171_);
lean_inc(v_toSub_161_);
v___x_173_ = lean_apply_2(v_toSub_161_, v___x_169_, v___x_172_);
return v___x_173_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_ZMod_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Fintype_BigOperators(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_BigOperators_Group_Finset_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Tactic_NormNum(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Tactic_Ring(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Fin_VecNotation(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_ResidualNotInM(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_ZMod_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Fintype_BigOperators(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_BigOperators_Group_Finset_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Tactic_NormNum(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Tactic_Ring(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Fin_VecNotation(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
lp_V14Formalization_V14Formalization_ResidualNotInM_minor01 = _init_lp_V14Formalization_V14Formalization_ResidualNotInM_minor01();
lean_mark_persistent(lp_V14Formalization_V14Formalization_ResidualNotInM_minor01);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
