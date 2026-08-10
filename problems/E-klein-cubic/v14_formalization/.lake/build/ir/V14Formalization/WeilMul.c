// Lean compiler output
// Module: V14Formalization.WeilMul
// Imports: public import Init public meta import Init public import V14Formalization.WeilRepSL2 public import Mathlib.Algebra.BigOperators.Ring.Finset public import Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic
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
lean_object* lp_mathlib_ZMod_instField___redArg(lean_object*);
lean_object* lp_mathlib_Field_toDivisionRing___redArg(lean_object*);
lean_object* lp_mathlib_Ring_toAddCommGroup___redArg(lean_object*);
lean_object* lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__1;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0(lean_object*, lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_WeilMul_Rfull___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_WeilMul_Rfull___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_WeilMul_Rfull___closed__0_value;
LEAN_EXPORT const lean_object* lp_V14Formalization_V14Formalization_WeilMul_Rfull = (const lean_object*)&lp_V14Formalization_V14Formalization_WeilMul_Rfull___closed__0_value;
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__0(void){
_start:
{
lean_object* v___x_1_; lean_object* v___x_2_; 
v___x_1_ = lean_unsigned_to_nat(11u);
v___x_2_ = lp_mathlib_ZMod_instField___redArg(v___x_1_);
return v___x_2_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__1(void){
_start:
{
lean_object* v___x_3_; lean_object* v___x_4_; 
v___x_3_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__0, &lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__0);
v___x_4_ = lp_mathlib_Field_toDivisionRing___redArg(v___x_3_);
return v___x_4_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0(lean_object* v_f_5_, lean_object* v_x_6_){
_start:
{
lean_object* v___x_7_; lean_object* v_toRing_8_; lean_object* v___x_9_; lean_object* v___x_10_; lean_object* v_toNeg_11_; lean_object* v___x_12_; lean_object* v___x_13_; 
v___x_7_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__1, &lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__1_once, _init_lp_V14Formalization_V14Formalization_WeilMul_Rfull___lam__0___closed__1);
v_toRing_8_ = lean_ctor_get(v___x_7_, 0);
v___x_9_ = lp_mathlib_Ring_toAddCommGroup___redArg(v_toRing_8_);
v___x_10_ = lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(v___x_9_);
lean_dec_ref(v___x_9_);
v_toNeg_11_ = lean_ctor_get(v___x_10_, 1);
lean_inc(v_toNeg_11_);
lean_dec_ref(v___x_10_);
v___x_12_ = lean_apply_1(v_toNeg_11_, v_x_6_);
v___x_13_ = lean_apply_1(v_f_5_, v___x_12_);
return v___x_13_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilRepSL2(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_BigOperators_Ring_Finset(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_NumberTheory_LegendreSymbol_QuadraticChar_Basic(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_WeilMul(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_WeilRepSL2(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_BigOperators_Ring_Finset(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_NumberTheory_LegendreSymbol_QuadraticChar_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
