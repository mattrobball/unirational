// Lean compiler output
// Module: V14Formalization.GeometricFanoCarrier
// Imports: public import Init public meta import Init public import V14Formalization.WeilHom public import V14Formalization.Definitions public import Mathlib.LinearAlgebra.ExteriorPower.Basic public import Mathlib.LinearAlgebra.ExteriorPower.Basis public import Mathlib.LinearAlgebra.Dimension.Finrank public import Mathlib.LinearAlgebra.Dimension.StrongRankCondition public import Mathlib.LinearAlgebra.FreeModule.Finite.Basic public import Mathlib.LinearAlgebra.Basis.VectorSpace public import Mathlib.LinearAlgebra.Projectivization.Basic public import Mathlib.LinearAlgebra.Projectivization.PSL.PSL2 public import Mathlib.LinearAlgebra.Center public import Mathlib.GroupTheory.QuotientGroup.Basic public import Mathlib.GroupTheory.Subgroup.Center public import Mathlib.GroupTheory.Subgroup.Simple public import Mathlib.LinearAlgebra.Matrix.Determinant.Basic public import Mathlib.Data.Matrix.Basic public import Mathlib.NumberTheory.LegendreSymbol.AddCharacter public import Mathlib.Data.Set.PowersetCard public import Mathlib.Order.Hom.PowersetCard public import Mathlib.Data.Finset.Sort public import Mathlib.Tactic.FinCases
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
lean_object* l_List_finRange(lean_object*);
lean_object* l_instDecidableEqFin___boxed(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_Matrix_SpecialLinearGroup_instGroup___redArg(lean_object*, lean_object*, lean_object*);
lean_object* lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0(lean_object*);
lean_object* lp_mathlib_ZMod_val(lean_object*, lean_object*);
uint8_t lean_nat_dec_le(lean_object*, lean_object*);
lean_object* lean_nat_sub(lean_object*, lean_object*);
lean_object* lp_mathlib_QuotientGroup_Quotient_group___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_U;
static const lean_closure_object lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_instDecidableEqFin___boxed, .m_arity = 3, .m_num_fixed = 1, .m_objs = {((lean_object*)(((size_t)(2) << 1) | 1))} };
static const lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__0_value;
static lean_once_cell_t lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__1;
static lean_once_cell_t lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__2;
static lean_once_cell_t lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__3;
static lean_once_cell_t lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__4;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_evalEven___lam__0(lean_object*, lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_GeometricFanoCarrier_evalEven___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_GeometricFanoCarrier_evalEven___lam__0, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_evalEven___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_GeometricFanoCarrier_evalEven___closed__0_value;
LEAN_EXPORT const lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_evalEven = (const lean_object*)&lp_V14Formalization_V14Formalization_GeometricFanoCarrier_evalEven___closed__0_value;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_extendEvenFun(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_extendEvenFun___boxed(lean_object*, lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_GeometricFanoCarrier_extendEven___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_GeometricFanoCarrier_extendEvenFun___boxed, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_extendEven___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_GeometricFanoCarrier_extendEven___closed__0_value;
LEAN_EXPORT const lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_extendEven = (const lean_object*)&lp_V14Formalization_V14Formalization_GeometricFanoCarrier_extendEven___closed__0_value;
static lean_object* _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_U(void){
_start:
{
lean_object* v___x_1_; 
v___x_1_ = lean_box(0);
return v___x_1_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__1(void){
_start:
{
lean_object* v___x_4_; lean_object* v___x_5_; 
v___x_4_ = lean_unsigned_to_nat(2u);
v___x_5_ = l_List_finRange(v___x_4_);
return v___x_5_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__2(void){
_start:
{
lean_object* v___x_6_; lean_object* v___x_7_; 
v___x_6_ = lean_unsigned_to_nat(11u);
v___x_7_ = lp_mathlib_ZMod_commRing(v___x_6_);
return v___x_7_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__3(void){
_start:
{
lean_object* v___x_8_; lean_object* v___x_9_; lean_object* v___x_10_; lean_object* v___x_11_; 
v___x_8_ = lean_obj_once(&lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__2, &lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__2_once, _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__2);
v___x_9_ = lean_obj_once(&lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__1, &lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__1_once, _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__1);
v___x_10_ = ((lean_object*)(lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__0));
v___x_11_ = lp_mathlib_Matrix_SpecialLinearGroup_instGroup___redArg(v___x_10_, v___x_9_, v___x_8_);
return v___x_11_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__4(void){
_start:
{
lean_object* v___x_12_; lean_object* v___x_13_; lean_object* v___x_14_; 
v___x_12_ = lean_box(0);
v___x_13_ = lean_obj_once(&lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__3, &lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__3_once, _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__3);
v___x_14_ = lp_mathlib_QuotientGroup_Quotient_group___redArg(v___x_13_, v___x_12_);
return v___x_14_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11(void){
_start:
{
lean_object* v___x_15_; 
v___x_15_ = lean_obj_once(&lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__4, &lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__4_once, _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11___closed__4);
return v___x_15_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_evalEven___lam__0(lean_object* v_f_16_, lean_object* v_j_17_){
_start:
{
lean_object* v___x_18_; lean_object* v___x_19_; 
v___x_18_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0(v_j_17_);
v___x_19_ = lean_apply_1(v_f_16_, v___x_18_);
return v___x_19_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_extendEvenFun(lean_object* v_v_22_, lean_object* v_x_23_){
_start:
{
lean_object* v___x_24_; lean_object* v___x_25_; lean_object* v___x_26_; uint8_t v___x_27_; 
v___x_24_ = lean_unsigned_to_nat(11u);
v___x_25_ = lp_mathlib_ZMod_val(v___x_24_, v_x_23_);
v___x_26_ = lean_unsigned_to_nat(5u);
v___x_27_ = lean_nat_dec_le(v___x_25_, v___x_26_);
if (v___x_27_ == 0)
{
lean_object* v___x_28_; lean_object* v___x_29_; 
v___x_28_ = lean_nat_sub(v___x_24_, v___x_25_);
lean_dec(v___x_25_);
v___x_29_ = lean_apply_1(v_v_22_, v___x_28_);
return v___x_29_;
}
else
{
lean_object* v___x_30_; 
v___x_30_ = lean_apply_1(v_v_22_, v___x_25_);
return v___x_30_;
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricFanoCarrier_extendEvenFun___boxed(lean_object* v_v_31_, lean_object* v_x_32_){
_start:
{
lean_object* v_res_33_; 
v_res_33_ = lp_V14Formalization_V14Formalization_GeometricFanoCarrier_extendEvenFun(v_v_31_, v_x_32_);
lean_dec(v_x_32_);
return v_res_33_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_WeilHom(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_Definitions(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_ExteriorPower_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_ExteriorPower_Basis(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finrank(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Dimension_StrongRankCondition(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_FreeModule_Finite_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Basis_VectorSpace(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Projectivization_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Projectivization_PSL_PSL2(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Center(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_QuotientGroup_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_Subgroup_Center(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_Subgroup_Simple(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_Determinant_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Matrix_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_NumberTheory_LegendreSymbol_AddCharacter(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Set_PowersetCard(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Order_Hom_PowersetCard(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Finset_Sort(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Tactic_FinCases(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_GeometricFanoCarrier(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_WeilHom(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_Definitions(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_ExteriorPower_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_ExteriorPower_Basis(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finrank(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Dimension_StrongRankCondition(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_FreeModule_Finite_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Basis_VectorSpace(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Projectivization_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Projectivization_PSL_PSL2(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Center(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_QuotientGroup_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_Subgroup_Center(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_Subgroup_Simple(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_Determinant_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Matrix_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_NumberTheory_LegendreSymbol_AddCharacter(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Set_PowersetCard(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Order_Hom_PowersetCard(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Finset_Sort(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Tactic_FinCases(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
lp_V14Formalization_V14Formalization_GeometricFanoCarrier_U = _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_U();
lean_mark_persistent(lp_V14Formalization_V14Formalization_GeometricFanoCarrier_U);
lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11 = _init_lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11();
lean_mark_persistent(lp_V14Formalization_V14Formalization_GeometricFanoCarrier_instGroupPSL2F11);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
