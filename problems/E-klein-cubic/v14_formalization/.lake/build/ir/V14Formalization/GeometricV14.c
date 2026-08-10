// Lean compiler output
// Module: V14Formalization.GeometricV14
// Imports: public import Init public meta import Init public import V14Formalization.CentralizerD12 public import V14Formalization.Definitions public import Mathlib.LinearAlgebra.Dimension.Finrank public import Mathlib.LinearAlgebra.Dimension.Finite public import Mathlib.GroupTheory.SpecificGroups.Dihedral
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
lean_object* lp_mathlib_Field_toSemifield___redArg(lean_object*);
lean_object* lp_mathlib_Semifield_toDivisionSemiring___redArg(lean_object*);
uint8_t lean_nat_dec_lt(lean_object*, lean_object*);
lean_object* lp_mathlib_instMulZeroClassOfSemiring___redArg(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_includeM___redArg___lam__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_includeM___redArg(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_includeM___redArg___boxed(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_includeM(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_includeM___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_includeM___redArg___lam__0(lean_object* v_toSemiring_1_, lean_object* v_m_2_, lean_object* v_i_3_){
_start:
{
lean_object* v___x_4_; uint8_t v___x_5_; 
v___x_4_ = lean_unsigned_to_nat(10u);
v___x_5_ = lean_nat_dec_lt(v_i_3_, v___x_4_);
if (v___x_5_ == 0)
{
lean_object* v___x_6_; lean_object* v_toZero_7_; 
lean_dec(v_i_3_);
lean_dec(v_m_2_);
v___x_6_ = lp_mathlib_instMulZeroClassOfSemiring___redArg(v_toSemiring_1_);
v_toZero_7_ = lean_ctor_get(v___x_6_, 1);
lean_inc(v_toZero_7_);
lean_dec_ref(v___x_6_);
return v_toZero_7_;
}
else
{
lean_object* v___x_8_; 
lean_dec_ref(v_toSemiring_1_);
v___x_8_ = lean_apply_1(v_m_2_, v_i_3_);
return v___x_8_;
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_includeM___redArg(lean_object* v_inst_9_){
_start:
{
lean_object* v___x_10_; lean_object* v___x_11_; lean_object* v_toSemiring_12_; lean_object* v___f_13_; 
v___x_10_ = lp_mathlib_Field_toSemifield___redArg(v_inst_9_);
v___x_11_ = lp_mathlib_Semifield_toDivisionSemiring___redArg(v___x_10_);
v_toSemiring_12_ = lean_ctor_get(v___x_11_, 0);
lean_inc_ref(v_toSemiring_12_);
lean_dec_ref(v___x_11_);
v___f_13_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_includeM___redArg___lam__0), 3, 1);
lean_closure_set(v___f_13_, 0, v_toSemiring_12_);
return v___f_13_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_includeM___redArg___boxed(lean_object* v_inst_14_){
_start:
{
lean_object* v_res_15_; 
v_res_15_ = lp_V14Formalization_V14Formalization_includeM___redArg(v_inst_14_);
lean_dec_ref(v_inst_14_);
return v_res_15_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_includeM(lean_object* v_k_16_, lean_object* v_inst_17_){
_start:
{
lean_object* v___x_18_; 
v___x_18_ = lp_V14Formalization_V14Formalization_includeM___redArg(v_inst_17_);
return v___x_18_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_includeM___boxed(lean_object* v_k_19_, lean_object* v_inst_20_){
_start:
{
lean_object* v_res_21_; 
v_res_21_ = lp_V14Formalization_V14Formalization_includeM(v_k_19_, v_inst_20_);
lean_dec_ref(v_inst_20_);
return v_res_21_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_CentralizerD12(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_Definitions(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finrank(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finite(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_SpecificGroups_Dihedral(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_GeometricV14(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_CentralizerD12(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_Definitions(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finrank(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_SpecificGroups_Dihedral(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
