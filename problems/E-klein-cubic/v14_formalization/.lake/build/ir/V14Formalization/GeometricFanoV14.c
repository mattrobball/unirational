// Lean compiler output
// Module: V14Formalization.GeometricFanoV14
// Imports: public import Init public meta import Init public import V14Formalization.WeilRep public import V14Formalization.Definitions public import V14Formalization.GeometricV14 public import Mathlib.LinearAlgebra.Dimension.Finrank public import Mathlib.LinearAlgebra.Projectivization.Basic
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
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricFanoV14_WeilU;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricFanoV14_V14Point_toSubmodule(lean_object*);
static lean_object* _init_lp_V14Formalization_V14Formalization_GeometricFanoV14_WeilU(void){
_start:
{
lean_object* v___x_1_; 
v___x_1_ = lean_box(0);
return v___x_1_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricFanoV14_V14Point_toSubmodule(lean_object* v_x_2_){
_start:
{
return v_x_2_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilRep(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_Definitions(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_GeometricV14(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finrank(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Projectivization_Basic(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_GeometricFanoV14(uint8_t builtin) {
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
res = initialize_V14Formalization_V14Formalization_Definitions(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_GeometricV14(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finrank(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Projectivization_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
lp_V14Formalization_V14Formalization_GeometricFanoV14_WeilU = _init_lp_V14Formalization_V14Formalization_GeometricFanoV14_WeilU();
lean_mark_persistent(lp_V14Formalization_V14Formalization_GeometricFanoV14_WeilU);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
