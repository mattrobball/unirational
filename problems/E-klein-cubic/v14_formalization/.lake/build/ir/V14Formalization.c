// Lean compiler output
// Module: V14Formalization
// Imports: public import Init public meta import Init public import V14Formalization.Basic public import V14Formalization.Definitions public import V14Formalization.Foundations public import V14Formalization.CentralizerObstruction public import V14Formalization.CentralizerD12 public import V14Formalization.GeometricCarrier public import V14Formalization.GeometricV14 public import V14Formalization.GeometricFano public import V14Formalization.V14Application public import V14Formalization.Ord11CharacterSum public import V14Formalization.WeilRep public import V14Formalization.WeilRepSL2 public import V14Formalization.WeilMul public import V14Formalization.WeilWN public import V14Formalization.WeilHom public import V14Formalization.ResidualNotInM public import V14Formalization.SchemeEquivariant public import V14Formalization.SchemeFixedLocus public import V14Formalization.SchemeNormalSpecialization public import V14Formalization.SchemeFixedRationalMap public import V14Formalization.SchemeEquivariantSpecialization public import V14Formalization.SchemeBaseChangeAction public import V14Formalization.InvariantSubschemeAction public import V14Formalization.MultiProjectiveZeroLocus public import V14Formalization.ProjectiveFamilyNaturality public import V14Formalization.ProjectiveAwayNaturality public import V14Formalization.GrassmannianLinearSection public import V14Formalization.D12MatrixCertificate public import V14Formalization.Lambda2Coordinates public import V14Formalization.V14SchemeModel public import V14Formalization.SchemeProjectiveAction public import V14Formalization.TrustGuard
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
lean_object* initialize_V14Formalization_V14Formalization_Ord11CharacterSum(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilRep(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilRepSL2(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilMul(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilWN(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilHom(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_ResidualNotInM(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_SchemeEquivariant(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_SchemeFixedLocus(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_SchemeNormalSpecialization(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_SchemeFixedRationalMap(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_SchemeEquivariantSpecialization(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_SchemeBaseChangeAction(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_InvariantSubschemeAction(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_MultiProjectiveZeroLocus(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_ProjectiveFamilyNaturality(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_ProjectiveAwayNaturality(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_GrassmannianLinearSection(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_D12MatrixCertificate(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_Lambda2Coordinates(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_V14SchemeModel(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_SchemeProjectiveAction(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_TrustGuard(uint8_t builtin);
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
res = initialize_V14Formalization_V14Formalization_Ord11CharacterSum(builtin);
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
res = initialize_V14Formalization_V14Formalization_ResidualNotInM(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_SchemeEquivariant(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_SchemeFixedLocus(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_SchemeNormalSpecialization(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_SchemeFixedRationalMap(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_SchemeEquivariantSpecialization(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_SchemeBaseChangeAction(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_InvariantSubschemeAction(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_MultiProjectiveZeroLocus(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_ProjectiveFamilyNaturality(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_ProjectiveAwayNaturality(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_GrassmannianLinearSection(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_D12MatrixCertificate(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_Lambda2Coordinates(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_V14SchemeModel(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_SchemeProjectiveAction(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_TrustGuard(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
