// Lean compiler output
// Module: V14Formalization
// Imports: public import Init public meta import Init public import V14Formalization.Basic public import V14Formalization.Definitions public import V14Formalization.Foundations public import V14Formalization.CentralizerObstruction public import V14Formalization.CentralizerD12 public import V14Formalization.GeometricCarrier public import V14Formalization.GeometricV14 public import V14Formalization.GeometricFano public import V14Formalization.V14Application public import V14Formalization.WeilRep public import V14Formalization.WeilRepSL2 public import V14Formalization.WeilMul public import V14Formalization.WeilWN public import V14Formalization.WeilHom
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
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_Basic(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_Definitions(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_Foundations(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_CentralizerObstruction(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_CentralizerD12(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_GeometricCarrier(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_GeometricV14(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_GeometricFano(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_V14Application(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilRep(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilRepSL2(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilMul(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilWN(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilHom(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_Definitions(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_Foundations(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_CentralizerObstruction(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_CentralizerD12(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_GeometricCarrier(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_GeometricV14(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_GeometricFano(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_V14Application(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_WeilRep(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_WeilRepSL2(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_WeilMul(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_WeilWN(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_WeilHom(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
