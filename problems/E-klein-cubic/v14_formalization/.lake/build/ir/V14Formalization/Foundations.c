// Lean compiler output
// Module: V14Formalization.Foundations
// Imports: public import Init public meta import Init public import V14Formalization.Definitions
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
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_TrackedStratum_ofPlusStratum(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_TrackedStratum_ofPlusStratum___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_TrackedStratum_ofPlusStratum(lean_object* v_k_1_, lean_object* v_inst_2_, lean_object* v_G_3_, lean_object* v_inst_4_, lean_object* v_V_5_, lean_object* v_inst_6_, lean_object* v_inst_7_, lean_object* v_inst_8_, lean_object* v_inst_9_, lean_object* v_R_10_, lean_object* v_00_u03c3_11_, lean_object* v_hG_12_, lean_object* v_h_u03c3_13_, lean_object* v_hnd_14_){
_start:
{
lean_object* v___x_15_; 
v___x_15_ = lean_box(0);
return v___x_15_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_TrackedStratum_ofPlusStratum___boxed(lean_object* v_k_16_, lean_object* v_inst_17_, lean_object* v_G_18_, lean_object* v_inst_19_, lean_object* v_V_20_, lean_object* v_inst_21_, lean_object* v_inst_22_, lean_object* v_inst_23_, lean_object* v_inst_24_, lean_object* v_R_25_, lean_object* v_00_u03c3_26_, lean_object* v_hG_27_, lean_object* v_h_u03c3_28_, lean_object* v_hnd_29_){
_start:
{
lean_object* v_res_30_; 
v_res_30_ = lp_V14Formalization_V14Formalization_TrackedStratum_ofPlusStratum(v_k_16_, v_inst_17_, v_G_18_, v_inst_19_, v_V_20_, v_inst_21_, v_inst_22_, v_inst_23_, v_inst_24_, v_R_25_, v_00_u03c3_26_, v_hG_27_, v_h_u03c3_28_, v_hnd_29_);
lean_dec(v_00_u03c3_26_);
lean_dec(v_R_25_);
lean_dec(v_inst_22_);
lean_dec_ref(v_inst_21_);
lean_dec_ref(v_inst_19_);
lean_dec_ref(v_inst_17_);
return v_res_30_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_Definitions(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_Foundations(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_Definitions(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
