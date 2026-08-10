// Lean compiler output
// Module: V14Formalization.Ord11CharacterSum
// Imports: public import Init public meta import Init public import V14Formalization.GeometricV14Carrier public import V14Formalization.PSLCard public import Mathlib.GroupTheory.Sylow public import Mathlib.GroupTheory.PGroup public import Mathlib.GroupTheory.Index public import Mathlib.Data.Nat.Factorization.Basic public import Mathlib.LinearAlgebra.Trace public import Mathlib.LinearAlgebra.Dimension.Finite public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas public import Mathlib.LinearAlgebra.Matrix.ToLin public import Mathlib.LinearAlgebra.Matrix.Diagonal public import Mathlib.Data.Matrix.Mul public import Mathlib.Tactic.Abel
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
lean_object* initialize_V14Formalization_V14Formalization_GeometricV14Carrier(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_PSLCard(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_Sylow(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_PGroup(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_Index(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Nat_Factorization_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Trace(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finite(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_FiniteDimensional_Lemmas(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_ToLin(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_Diagonal(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Matrix_Mul(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Tactic_Abel(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_Ord11CharacterSum(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_GeometricV14Carrier(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_PSLCard(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_Sylow(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_PGroup(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_Index(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Nat_Factorization_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Trace(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_FiniteDimensional_Lemmas(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_ToLin(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_Diagonal(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Matrix_Mul(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Tactic_Abel(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
