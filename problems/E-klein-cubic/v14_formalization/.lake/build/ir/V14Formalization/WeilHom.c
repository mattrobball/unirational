// Lean compiler output
// Module: V14Formalization.WeilHom
// Imports: public import Init public meta import Init public import V14Formalization.WeilMul public import V14Formalization.WeilWN
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
lean_object* lp_mathlib_Field_toSemifield___redArg(lean_object*);
lean_object* lp_mathlib_Semifield_toDivisionSemiring___redArg(lean_object*);
lean_object* lp_mathlib_instDistribOfSemiring___redArg(lean_object*);
lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_ec(lean_object*);
lean_object* lp_mathlib_ZMod_inv(lean_object*, lean_object*);
lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_ed(lean_object*);
lean_object* lp_V14Formalization_V14Formalization_WeilRepSL2_ea(lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__1;
static lean_once_cell_t lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__2;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilHom_bigBigS(lean_object*, lean_object*);
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__0(void){
_start:
{
lean_object* v___x_1_; lean_object* v___x_2_; 
v___x_1_ = lean_unsigned_to_nat(11u);
v___x_2_ = lp_mathlib_ZMod_instField___redArg(v___x_1_);
return v___x_2_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__1(void){
_start:
{
lean_object* v___x_3_; lean_object* v___x_4_; 
v___x_3_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__0, &lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__0);
v___x_4_ = lp_mathlib_Field_toSemifield___redArg(v___x_3_);
return v___x_4_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__2(void){
_start:
{
lean_object* v___x_5_; lean_object* v___x_6_; 
v___x_5_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__1, &lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__1_once, _init_lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__1);
v___x_6_ = lp_mathlib_Semifield_toDivisionSemiring___redArg(v___x_5_);
return v___x_6_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilHom_bigBigS(lean_object* v_g_7_, lean_object* v_h_8_){
_start:
{
lean_object* v___x_9_; lean_object* v___x_10_; lean_object* v_toSemiring_11_; lean_object* v___x_12_; lean_object* v_toMul_13_; lean_object* v_toAdd_14_; lean_object* v___x_15_; lean_object* v___x_16_; lean_object* v___x_17_; lean_object* v___x_18_; lean_object* v___x_19_; lean_object* v___x_20_; lean_object* v___x_21_; lean_object* v___x_22_; lean_object* v___x_23_; lean_object* v___x_24_; lean_object* v___x_25_; 
v___x_9_ = lean_unsigned_to_nat(11u);
v___x_10_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__2, &lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__2_once, _init_lp_V14Formalization_V14Formalization_WeilHom_bigBigS___closed__2);
v_toSemiring_11_ = lean_ctor_get(v___x_10_, 0);
lean_inc_ref(v_toSemiring_11_);
v___x_12_ = lp_mathlib_instDistribOfSemiring___redArg(v_toSemiring_11_);
v_toMul_13_ = lean_ctor_get(v___x_12_, 0);
lean_inc_n(v_toMul_13_, 4);
v_toAdd_14_ = lean_ctor_get(v___x_12_, 1);
lean_inc(v_toAdd_14_);
lean_dec_ref(v___x_12_);
lean_inc_ref(v_g_7_);
v___x_15_ = lp_V14Formalization_V14Formalization_WeilRepSL2_ec(v_g_7_);
lean_inc_n(v___x_15_, 2);
v___x_16_ = lean_apply_2(v_toMul_13_, v___x_15_, v___x_15_);
v___x_17_ = lp_mathlib_ZMod_inv(v___x_9_, v___x_15_);
lean_dec(v___x_15_);
v___x_18_ = lp_V14Formalization_V14Formalization_WeilRepSL2_ed(v_g_7_);
v___x_19_ = lean_apply_2(v_toMul_13_, v___x_17_, v___x_18_);
lean_inc_ref(v_h_8_);
v___x_20_ = lp_V14Formalization_V14Formalization_WeilRepSL2_ea(v_h_8_);
v___x_21_ = lp_V14Formalization_V14Formalization_WeilRepSL2_ec(v_h_8_);
v___x_22_ = lp_mathlib_ZMod_inv(v___x_9_, v___x_21_);
lean_dec(v___x_21_);
v___x_23_ = lean_apply_2(v_toMul_13_, v___x_20_, v___x_22_);
v___x_24_ = lean_apply_2(v_toAdd_14_, v___x_19_, v___x_23_);
v___x_25_ = lean_apply_2(v_toMul_13_, v___x_16_, v___x_24_);
return v___x_25_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilMul(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilWN(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_WeilHom(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_WeilMul(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_WeilWN(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
