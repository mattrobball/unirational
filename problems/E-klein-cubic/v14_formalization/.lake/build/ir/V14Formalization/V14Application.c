// Lean compiler output
// Module: V14Formalization.V14Application
// Imports: public import Init public meta import Init public import V14Formalization.CentralizerObstruction public import V14Formalization.CentralizerD12 public import V14Formalization.GeometricCarrier public import Mathlib.GroupTheory.SpecificGroups.Dihedral public import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup public import Mathlib.LinearAlgebra.Matrix.ProjectiveSpecialLinearGroup public import Mathlib.Data.ZMod.Basic public import Mathlib.Algebra.Field.ZMod public import Mathlib.Data.Nat.Prime.Defs public import Mathlib.GroupTheory.Subgroup.Center public import Mathlib.RepresentationTheory.Basic public import Mathlib.LinearAlgebra.FreeModule.Finite.Basic public import Mathlib.Algebra.Module.Pi public import Mathlib.LinearAlgebra.Projectivization.Basic
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
lean_object* l_List_finRange(lean_object*);
lean_object* l_Fin_cases___redArg(lean_object*, lean_object*, lean_object*);
extern lean_object* lp_mathlib_Rat_addCommGroup;
lean_object* lp_mathlib_Pi_addCommGroup___redArg(lean_object*);
lean_object* lp_mathlib_ZMod_decidableEq___boxed(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_ZMod_fintype___redArg(lean_object*);
lean_object* lp_mathlib_ZMod_commRing(lean_object*);
lean_object* l_instDecidableEqFin___boxed(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_Matrix_SpecialLinearGroup_instFintypeOfDecidableEq___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_instDistribOfSemiring___redArg(lean_object*);
lean_object* lp_mathlib_dotProduct___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lp_mathlib_Matrix_decidableEq___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lp_mathlib_Fintype_decidableForallFintype___redArg(lean_object*, lean_object*);
lean_object* lp_mathlib_Matrix_SpecialLinearGroup_instGroup___redArg(lean_object*, lean_object*, lean_object*);
uint8_t lp_mathlib_QuotientGroup_leftRelDecidable___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_QuotientGroup_fintype___redArg(lean_object*, lean_object*);
extern lean_object* lp_mathlib_Rat_commSemiring;
lean_object* lp_mathlib_Semiring_toModule___redArg(lean_object*);
lean_object* lp_mathlib_Pi_Function_module___redArg(lean_object*);
lean_object* lp_mathlib_ZMod_instField___redArg(lean_object*);
lean_object* lp_mathlib_Field_toSemifield___redArg(lean_object*);
lean_object* lp_mathlib_Semifield_toDivisionSemiring___redArg(lean_object*);
lean_object* lp_mathlib_instMulZeroClassOfSemiring___redArg(lean_object*);
lean_object* lp_mathlib_Field_toDivisionRing___redArg(lean_object*);
lean_object* lp_mathlib_Ring_toAddCommGroup___redArg(lean_object*);
lean_object* lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(lean_object*);
lean_object* lp_mathlib_Ring_toAddGroupWithOne___redArg(lean_object*);
lean_object* lp_mathlib_Equiv_refl(lean_object*);
lean_object* lp_mathlib_QuotientGroup_Quotient_group___redArg(lean_object*, lean_object*);
lean_object* lp_V14Formalization_Matrix_adjugate___at___00V14Formalization_GeometricCarrier_cosetAmbientAct_spec__0(lean_object*, lean_object*, lean_object*);
lean_object* lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0(lean_object*, lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_instDecidableEqFin___boxed, .m_arity = 3, .m_num_fixed = 1, .m_objs = {((lean_object*)(((size_t)(2) << 1) | 1))} };
static const lean_object* lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__0_value;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__3;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__4;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__1(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__6___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__4(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__0;
static const lean_closure_object lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_mathlib_ZMod_decidableEq___boxed, .m_arity = 3, .m_num_fixed = 1, .m_objs = {((lean_object*)(((size_t)(11) << 1) | 1))} };
static const lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__1 = (const lean_object*)&lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__1_value;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__2;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__3;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__4;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__5;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__0(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__0___boxed(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__1___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__2(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__2___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__4(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__4___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__3(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_Tmat___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_Tmat___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___closed__2;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4;
static const lean_closure_object lp_V14Formalization_V14Formalization_V14App_Tmat___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_V14App_Tmat___lam__0___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___closed__5 = (const lean_object*)&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__5_value;
static const lean_closure_object lp_V14Formalization_V14Formalization_V14App_Tmat___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_V14App_Tmat___lam__1___boxed, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___closed__6 = (const lean_object*)&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__6_value;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Umat;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_sigmaLift___lam__5(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_sigmaLift___lam__5___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_sigmaLift;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_sigma;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___lam__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___lam__0___boxed(lean_object*, lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__1;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__1;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instModuleKReg;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_regularRep___lam__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_regularRep___lam__1(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_regularRep___lam__2(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_regularRep___lam__3(lean_object*, lean_object*, lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_V14App_regularRep___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_V14App_regularRep___lam__3, .m_arity = 3, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_V14App_regularRep___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_V14App_regularRep___closed__0_value;
LEAN_EXPORT const lean_object* lp_V14Formalization_V14Formalization_V14App_regularRep = (const lean_object*)&lp_V14Formalization_V14Formalization_V14App_regularRep___closed__0_value;
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1(void){
_start:
{
lean_object* v___x_3_; lean_object* v___x_4_; 
v___x_3_ = lean_unsigned_to_nat(2u);
v___x_4_ = l_List_finRange(v___x_3_);
return v___x_4_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2(void){
_start:
{
lean_object* v___x_5_; lean_object* v___x_6_; 
v___x_5_ = lean_unsigned_to_nat(11u);
v___x_6_ = lp_mathlib_ZMod_commRing(v___x_5_);
return v___x_6_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__3(void){
_start:
{
lean_object* v___x_7_; lean_object* v___x_8_; lean_object* v___x_9_; lean_object* v___x_10_; 
v___x_7_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2, &lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2_once, _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2);
v___x_8_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1, &lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1_once, _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1);
v___x_9_ = ((lean_object*)(lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__0));
v___x_10_ = lp_mathlib_Matrix_SpecialLinearGroup_instGroup___redArg(v___x_9_, v___x_8_, v___x_7_);
return v___x_10_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__4(void){
_start:
{
lean_object* v___x_11_; lean_object* v___x_12_; lean_object* v___x_13_; 
v___x_11_ = lean_box(0);
v___x_12_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__3, &lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__3_once, _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__3);
v___x_13_ = lp_mathlib_QuotientGroup_Quotient_group___redArg(v___x_12_, v___x_11_);
return v___x_13_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11(void){
_start:
{
lean_object* v___x_14_; 
v___x_14_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__4, &lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__4_once, _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__4);
return v___x_14_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__0(lean_object* v_a_15_, lean_object* v___y_16_, lean_object* v_j_17_){
_start:
{
lean_object* v___x_18_; 
v___x_18_ = lean_apply_2(v_a_15_, v_j_17_, v___y_16_);
return v___x_18_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__1(lean_object* v_a_19_, lean_object* v___y_20_, lean_object* v_j_21_){
_start:
{
lean_object* v___x_22_; 
v___x_22_ = lean_apply_2(v_a_19_, v___y_20_, v_j_21_);
return v___x_22_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__2(lean_object* v_a_23_, lean_object* v_a_24_, lean_object* v___x_25_, lean_object* v_toMul_26_, lean_object* v_toAddCommMonoid_27_, lean_object* v___y_28_, lean_object* v___y_29_){
_start:
{
lean_object* v___f_30_; lean_object* v___f_31_; lean_object* v___x_32_; 
v___f_30_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__0), 3, 2);
lean_closure_set(v___f_30_, 0, v_a_23_);
lean_closure_set(v___f_30_, 1, v___y_29_);
v___f_31_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__1), 3, 2);
lean_closure_set(v___f_31_, 0, v_a_24_);
lean_closure_set(v___f_31_, 1, v___y_28_);
v___x_32_ = lp_mathlib_dotProduct___redArg(v___x_25_, v_toMul_26_, v_toAddCommMonoid_27_, v___f_31_, v___f_30_);
return v___x_32_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__2___boxed(lean_object* v_a_33_, lean_object* v_a_34_, lean_object* v___x_35_, lean_object* v_toMul_36_, lean_object* v_toAddCommMonoid_37_, lean_object* v___y_38_, lean_object* v___y_39_){
_start:
{
lean_object* v_res_40_; 
v_res_40_ = lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__2(v_a_33_, v_a_34_, v___x_35_, v_toMul_36_, v_toAddCommMonoid_37_, v___y_38_, v___y_39_);
lean_dec_ref(v_toAddCommMonoid_37_);
return v_res_40_;
}
}
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__6(lean_object* v___x_41_, lean_object* v_a_42_, lean_object* v___x_43_, lean_object* v___x_44_, lean_object* v_a_45_){
_start:
{
lean_object* v_toSemiring_46_; lean_object* v___x_47_; lean_object* v_toMul_48_; lean_object* v_toAddCommMonoid_49_; lean_object* v___f_50_; lean_object* v___f_51_; uint8_t v___x_52_; 
v_toSemiring_46_ = lean_ctor_get(v___x_41_, 0);
lean_inc_ref_n(v_toSemiring_46_, 2);
lean_dec_ref(v___x_41_);
v___x_47_ = lp_mathlib_instDistribOfSemiring___redArg(v_toSemiring_46_);
v_toMul_48_ = lean_ctor_get(v___x_47_, 0);
lean_inc_n(v_toMul_48_, 2);
lean_dec_ref(v___x_47_);
v_toAddCommMonoid_49_ = lean_ctor_get(v_toSemiring_46_, 0);
lean_inc_ref_n(v_toAddCommMonoid_49_, 2);
lean_dec_ref(v_toSemiring_46_);
lean_inc_n(v___x_43_, 3);
lean_inc_ref(v_a_42_);
lean_inc_ref(v_a_45_);
v___f_50_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__2___boxed), 7, 5);
lean_closure_set(v___f_50_, 0, v_a_45_);
lean_closure_set(v___f_50_, 1, v_a_42_);
lean_closure_set(v___f_50_, 2, v___x_43_);
lean_closure_set(v___f_50_, 3, v_toMul_48_);
lean_closure_set(v___f_50_, 4, v_toAddCommMonoid_49_);
v___f_51_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__2___boxed), 7, 5);
lean_closure_set(v___f_51_, 0, v_a_42_);
lean_closure_set(v___f_51_, 1, v_a_45_);
lean_closure_set(v___f_51_, 2, v___x_43_);
lean_closure_set(v___f_51_, 3, v_toMul_48_);
lean_closure_set(v___f_51_, 4, v_toAddCommMonoid_49_);
v___x_52_ = lp_mathlib_Matrix_decidableEq___redArg(v___x_44_, v___x_43_, v___x_43_, v___f_51_, v___f_50_);
return v___x_52_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__6___boxed(lean_object* v___x_53_, lean_object* v_a_54_, lean_object* v___x_55_, lean_object* v___x_56_, lean_object* v_a_57_){
_start:
{
uint8_t v_res_58_; lean_object* v_r_59_; 
v_res_58_ = lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__6(v___x_53_, v_a_54_, v___x_55_, v___x_56_, v_a_57_);
v_r_59_ = lean_box(v_res_58_);
return v_r_59_;
}
}
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__3(lean_object* v___x_60_, lean_object* v___x_61_, lean_object* v___x_62_, lean_object* v___x_63_, lean_object* v_a_64_){
_start:
{
lean_object* v___f_65_; uint8_t v___x_66_; 
v___f_65_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__6___boxed), 5, 4);
lean_closure_set(v___f_65_, 0, v___x_60_);
lean_closure_set(v___f_65_, 1, v_a_64_);
lean_closure_set(v___f_65_, 2, v___x_61_);
lean_closure_set(v___f_65_, 3, v___x_62_);
v___x_66_ = lp_mathlib_Fintype_decidableForallFintype___redArg(v___f_65_, v___x_63_);
return v___x_66_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__3___boxed(lean_object* v___x_67_, lean_object* v___x_68_, lean_object* v___x_69_, lean_object* v___x_70_, lean_object* v_a_71_){
_start:
{
uint8_t v_res_72_; lean_object* v_r_73_; 
v_res_72_ = lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__3(v___x_67_, v___x_68_, v___x_69_, v___x_70_, v_a_71_);
v_r_73_ = lean_box(v_res_72_);
return v_r_73_;
}
}
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__4(lean_object* v___x_74_, lean_object* v___f_75_, lean_object* v_a_76_, lean_object* v_b_77_){
_start:
{
uint8_t v___x_78_; 
v___x_78_ = lp_mathlib_QuotientGroup_leftRelDecidable___redArg(v___x_74_, v___f_75_, v_a_76_, v_b_77_);
return v___x_78_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__4___boxed(lean_object* v___x_79_, lean_object* v___f_80_, lean_object* v_a_81_, lean_object* v_b_82_){
_start:
{
uint8_t v_res_83_; lean_object* v_r_84_; 
v_res_83_ = lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__4(v___x_79_, v___f_80_, v_a_81_, v_b_82_);
lean_dec_ref(v___x_79_);
v_r_84_ = lean_box(v_res_83_);
return v_r_84_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__0(void){
_start:
{
lean_object* v___x_85_; lean_object* v___x_86_; 
v___x_85_ = lean_unsigned_to_nat(11u);
v___x_86_ = lp_mathlib_ZMod_fintype___redArg(v___x_85_);
return v___x_86_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__2(void){
_start:
{
lean_object* v___x_89_; lean_object* v___x_90_; lean_object* v___x_91_; lean_object* v___x_92_; lean_object* v___x_93_; lean_object* v___x_94_; 
v___x_89_ = ((lean_object*)(lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__1));
v___x_90_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__0, &lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__0_once, _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__0);
v___x_91_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2, &lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2_once, _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2);
v___x_92_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1, &lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1_once, _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1);
v___x_93_ = ((lean_object*)(lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__0));
v___x_94_ = lp_mathlib_Matrix_SpecialLinearGroup_instFintypeOfDecidableEq___redArg(v___x_93_, v___x_92_, v___x_91_, v___x_90_, v___x_89_);
return v___x_94_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__3(void){
_start:
{
lean_object* v___x_95_; lean_object* v___x_96_; lean_object* v___x_97_; lean_object* v___x_98_; lean_object* v___f_99_; 
v___x_95_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__2, &lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__2_once, _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__2);
v___x_96_ = ((lean_object*)(lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__1));
v___x_97_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1, &lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1_once, _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__1);
v___x_98_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2, &lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2_once, _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__2);
v___f_99_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__3___boxed), 5, 4);
lean_closure_set(v___f_99_, 0, v___x_98_);
lean_closure_set(v___f_99_, 1, v___x_97_);
lean_closure_set(v___f_99_, 2, v___x_96_);
lean_closure_set(v___f_99_, 3, v___x_95_);
return v___f_99_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__4(void){
_start:
{
lean_object* v___f_100_; lean_object* v___x_101_; lean_object* v___f_102_; 
v___f_100_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__3, &lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__3_once, _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__3);
v___x_101_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__3, &lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__3_once, _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11___closed__3);
v___f_102_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___lam__4___boxed), 4, 2);
lean_closure_set(v___f_102_, 0, v___x_101_);
lean_closure_set(v___f_102_, 1, v___f_100_);
return v___f_102_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__5(void){
_start:
{
lean_object* v___f_103_; lean_object* v___x_104_; lean_object* v___x_105_; 
v___f_103_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__4, &lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__4_once, _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__4);
v___x_104_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__2, &lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__2_once, _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__2);
v___x_105_ = lp_mathlib_QuotientGroup_fintype___redArg(v___x_104_, v___f_103_);
return v___x_105_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11(void){
_start:
{
lean_object* v___x_106_; 
v___x_106_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__5, &lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__5_once, _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11___closed__5);
return v___x_106_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__0(lean_object* v___y_107_){
_start:
{
lean_internal_panic_unreachable();
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__0___boxed(lean_object* v___y_108_){
_start:
{
lean_object* v_res_109_; 
v_res_109_ = lp_V14Formalization_V14Formalization_V14App_Tmat___lam__0(v___y_108_);
lean_dec(v___y_108_);
return v_res_109_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__1(lean_object* v___y_110_, lean_object* v___y_111_){
_start:
{
lean_internal_panic_unreachable();
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__1___boxed(lean_object* v___y_112_, lean_object* v___y_113_){
_start:
{
lean_object* v_res_114_; 
v_res_114_ = lp_V14Formalization_V14Formalization_V14App_Tmat___lam__1(v___y_112_, v___y_113_);
lean_dec(v___y_113_);
lean_dec(v___y_112_);
return v_res_114_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__2(lean_object* v_toOne_115_, lean_object* v___f_116_, lean_object* v___y_117_){
_start:
{
lean_object* v___x_118_; 
v___x_118_ = l_Fin_cases___redArg(v_toOne_115_, v___f_116_, v___y_117_);
return v___x_118_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__2___boxed(lean_object* v_toOne_119_, lean_object* v___f_120_, lean_object* v___y_121_){
_start:
{
lean_object* v_res_122_; 
v_res_122_ = lp_V14Formalization_V14Formalization_V14App_Tmat___lam__2(v_toOne_119_, v___f_120_, v___y_121_);
lean_dec(v___y_121_);
lean_dec(v_toOne_119_);
return v_res_122_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__4(lean_object* v_toZero_123_, lean_object* v___f_124_, lean_object* v___y_125_){
_start:
{
lean_object* v___x_126_; 
v___x_126_ = l_Fin_cases___redArg(v_toZero_123_, v___f_124_, v___y_125_);
return v___x_126_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__4___boxed(lean_object* v_toZero_127_, lean_object* v___f_128_, lean_object* v___y_129_){
_start:
{
lean_object* v_res_130_; 
v_res_130_ = lp_V14Formalization_V14Formalization_V14App_Tmat___lam__4(v_toZero_127_, v___f_128_, v___y_129_);
lean_dec(v___y_129_);
lean_dec(v_toZero_127_);
return v_res_130_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__3(lean_object* v___f_131_, lean_object* v___f_132_, lean_object* v___y_133_, lean_object* v___y_134_){
_start:
{
lean_object* v___x_1751__overap_135_; lean_object* v___x_136_; 
v___x_1751__overap_135_ = l_Fin_cases___redArg(v___f_131_, v___f_132_, v___y_133_);
v___x_136_ = lean_apply_1(v___x_1751__overap_135_, v___y_134_);
return v___x_136_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_Tmat___lam__3___boxed(lean_object* v___f_137_, lean_object* v___f_138_, lean_object* v___y_139_, lean_object* v___y_140_){
_start:
{
lean_object* v_res_141_; 
v_res_141_ = lp_V14Formalization_V14Formalization_V14App_Tmat___lam__3(v___f_137_, v___f_138_, v___y_139_, v___y_140_);
lean_dec(v___y_139_);
lean_dec_ref(v___f_137_);
return v_res_141_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__0(void){
_start:
{
lean_object* v___x_142_; lean_object* v___x_143_; 
v___x_142_ = lean_unsigned_to_nat(11u);
v___x_143_ = lp_mathlib_ZMod_instField___redArg(v___x_142_);
return v___x_143_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1(void){
_start:
{
lean_object* v___x_144_; lean_object* v___x_145_; 
v___x_144_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__0, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__0_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__0);
v___x_145_ = lp_mathlib_Field_toDivisionRing___redArg(v___x_144_);
return v___x_145_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__2(void){
_start:
{
lean_object* v___x_146_; lean_object* v___x_147_; 
v___x_146_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__0, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__0_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__0);
v___x_147_ = lp_mathlib_Field_toSemifield___redArg(v___x_146_);
return v___x_147_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3(void){
_start:
{
lean_object* v___x_148_; lean_object* v___x_149_; 
v___x_148_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__2, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__2_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__2);
v___x_149_ = lp_mathlib_Semifield_toDivisionSemiring___redArg(v___x_148_);
return v___x_149_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4(void){
_start:
{
lean_object* v___x_150_; 
v___x_150_ = lp_mathlib_Equiv_refl(lean_box(0));
return v___x_150_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_Tmat(void){
_start:
{
lean_object* v___x_153_; lean_object* v_toRing_154_; lean_object* v___x_155_; lean_object* v_toAddMonoidWithOne_156_; lean_object* v_toOne_157_; lean_object* v___x_158_; lean_object* v_toSemiring_159_; lean_object* v___x_160_; lean_object* v_toZero_161_; lean_object* v___x_162_; lean_object* v_toFun_163_; lean_object* v___f_164_; lean_object* v___f_165_; lean_object* v___f_166_; lean_object* v___f_167_; lean_object* v___f_168_; lean_object* v___f_169_; lean_object* v___f_170_; lean_object* v___x_171_; 
v___x_153_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1);
v_toRing_154_ = lean_ctor_get(v___x_153_, 0);
lean_inc_ref(v_toRing_154_);
v___x_155_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_154_);
v_toAddMonoidWithOne_156_ = lean_ctor_get(v___x_155_, 1);
lean_inc_ref(v_toAddMonoidWithOne_156_);
lean_dec_ref(v___x_155_);
v_toOne_157_ = lean_ctor_get(v_toAddMonoidWithOne_156_, 2);
lean_inc_n(v_toOne_157_, 2);
lean_dec_ref(v_toAddMonoidWithOne_156_);
v___x_158_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3);
v_toSemiring_159_ = lean_ctor_get(v___x_158_, 0);
lean_inc_ref(v_toSemiring_159_);
v___x_160_ = lp_mathlib_instMulZeroClassOfSemiring___redArg(v_toSemiring_159_);
v_toZero_161_ = lean_ctor_get(v___x_160_, 1);
lean_inc(v_toZero_161_);
lean_dec_ref(v___x_160_);
v___x_162_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4);
v_toFun_163_ = lean_ctor_get(v___x_162_, 0);
v___f_164_ = ((lean_object*)(lp_V14Formalization_V14Formalization_V14App_Tmat___closed__5));
v___f_165_ = ((lean_object*)(lp_V14Formalization_V14Formalization_V14App_Tmat___closed__6));
v___f_166_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__2___boxed), 3, 2);
lean_closure_set(v___f_166_, 0, v_toOne_157_);
lean_closure_set(v___f_166_, 1, v___f_164_);
lean_inc_ref(v___f_166_);
v___f_167_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__2___boxed), 3, 2);
lean_closure_set(v___f_167_, 0, v_toOne_157_);
lean_closure_set(v___f_167_, 1, v___f_166_);
v___f_168_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__4___boxed), 3, 2);
lean_closure_set(v___f_168_, 0, v_toZero_161_);
lean_closure_set(v___f_168_, 1, v___f_166_);
v___f_169_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__3___boxed), 4, 2);
lean_closure_set(v___f_169_, 0, v___f_168_);
lean_closure_set(v___f_169_, 1, v___f_165_);
v___f_170_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__3___boxed), 4, 2);
lean_closure_set(v___f_170_, 0, v___f_167_);
lean_closure_set(v___f_170_, 1, v___f_169_);
lean_inc(v_toFun_163_);
v___x_171_ = lean_apply_1(v_toFun_163_, v___f_170_);
return v___x_171_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_Umat(void){
_start:
{
lean_object* v___x_172_; lean_object* v_toRing_173_; lean_object* v___x_174_; lean_object* v_toAddMonoidWithOne_175_; lean_object* v_toOne_176_; lean_object* v___x_177_; lean_object* v_toSemiring_178_; lean_object* v___x_179_; lean_object* v_toZero_180_; lean_object* v___x_181_; lean_object* v_toFun_182_; lean_object* v___f_183_; lean_object* v___f_184_; lean_object* v___f_185_; lean_object* v___f_186_; lean_object* v___f_187_; lean_object* v___f_188_; lean_object* v___f_189_; lean_object* v___f_190_; lean_object* v___x_191_; 
v___x_172_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1);
v_toRing_173_ = lean_ctor_get(v___x_172_, 0);
lean_inc_ref(v_toRing_173_);
v___x_174_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_173_);
v_toAddMonoidWithOne_175_ = lean_ctor_get(v___x_174_, 1);
lean_inc_ref(v_toAddMonoidWithOne_175_);
lean_dec_ref(v___x_174_);
v_toOne_176_ = lean_ctor_get(v_toAddMonoidWithOne_175_, 2);
lean_inc_n(v_toOne_176_, 3);
lean_dec_ref(v_toAddMonoidWithOne_175_);
v___x_177_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3);
v_toSemiring_178_ = lean_ctor_get(v___x_177_, 0);
lean_inc_ref(v_toSemiring_178_);
v___x_179_ = lp_mathlib_instMulZeroClassOfSemiring___redArg(v_toSemiring_178_);
v_toZero_180_ = lean_ctor_get(v___x_179_, 1);
lean_inc(v_toZero_180_);
lean_dec_ref(v___x_179_);
v___x_181_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4);
v_toFun_182_ = lean_ctor_get(v___x_181_, 0);
v___f_183_ = ((lean_object*)(lp_V14Formalization_V14Formalization_V14App_Tmat___closed__6));
v___f_184_ = ((lean_object*)(lp_V14Formalization_V14Formalization_V14App_Tmat___closed__5));
v___f_185_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__2___boxed), 3, 2);
lean_closure_set(v___f_185_, 0, v_toOne_176_);
lean_closure_set(v___f_185_, 1, v___f_184_);
v___f_186_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__2___boxed), 3, 2);
lean_closure_set(v___f_186_, 0, v_toOne_176_);
lean_closure_set(v___f_186_, 1, v___f_185_);
v___f_187_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__3___boxed), 4, 2);
lean_closure_set(v___f_187_, 0, v___f_186_);
lean_closure_set(v___f_187_, 1, v___f_183_);
v___f_188_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__4___boxed), 3, 2);
lean_closure_set(v___f_188_, 0, v_toZero_180_);
lean_closure_set(v___f_188_, 1, v___f_184_);
v___f_189_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__2___boxed), 3, 2);
lean_closure_set(v___f_189_, 0, v_toOne_176_);
lean_closure_set(v___f_189_, 1, v___f_188_);
v___f_190_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__3___boxed), 4, 2);
lean_closure_set(v___f_190_, 0, v___f_189_);
lean_closure_set(v___f_190_, 1, v___f_187_);
lean_inc(v_toFun_182_);
v___x_191_ = lean_apply_1(v_toFun_182_, v___f_190_);
return v___x_191_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_sigmaLift___lam__5(lean_object* v___x_192_, lean_object* v___f_193_, lean_object* v___y_194_){
_start:
{
lean_object* v___x_195_; 
v___x_195_ = l_Fin_cases___redArg(v___x_192_, v___f_193_, v___y_194_);
return v___x_195_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_sigmaLift___lam__5___boxed(lean_object* v___x_196_, lean_object* v___f_197_, lean_object* v___y_198_){
_start:
{
lean_object* v_res_199_; 
v_res_199_ = lp_V14Formalization_V14Formalization_V14App_sigmaLift___lam__5(v___x_196_, v___f_197_, v___y_198_);
lean_dec(v___y_198_);
lean_dec(v___x_196_);
return v_res_199_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_sigmaLift(void){
_start:
{
lean_object* v___x_200_; lean_object* v_toSemiring_201_; lean_object* v___x_202_; lean_object* v_toZero_203_; lean_object* v___x_204_; lean_object* v_toRing_205_; lean_object* v___x_206_; lean_object* v___x_207_; lean_object* v_toNeg_208_; lean_object* v___x_209_; lean_object* v_toAddMonoidWithOne_210_; lean_object* v_toOne_211_; lean_object* v___x_212_; lean_object* v_toFun_213_; lean_object* v___f_214_; lean_object* v___f_215_; lean_object* v___f_216_; lean_object* v___f_217_; lean_object* v___f_218_; lean_object* v___x_219_; lean_object* v___f_220_; lean_object* v___f_221_; lean_object* v___f_222_; lean_object* v___x_223_; 
v___x_200_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__3);
v_toSemiring_201_ = lean_ctor_get(v___x_200_, 0);
lean_inc_ref(v_toSemiring_201_);
v___x_202_ = lp_mathlib_instMulZeroClassOfSemiring___redArg(v_toSemiring_201_);
v_toZero_203_ = lean_ctor_get(v___x_202_, 1);
lean_inc_n(v_toZero_203_, 2);
lean_dec_ref(v___x_202_);
v___x_204_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__1);
v_toRing_205_ = lean_ctor_get(v___x_204_, 0);
v___x_206_ = lp_mathlib_Ring_toAddCommGroup___redArg(v_toRing_205_);
v___x_207_ = lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(v___x_206_);
lean_dec_ref(v___x_206_);
v_toNeg_208_ = lean_ctor_get(v___x_207_, 1);
lean_inc(v_toNeg_208_);
lean_dec_ref(v___x_207_);
lean_inc_ref(v_toRing_205_);
v___x_209_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_205_);
v_toAddMonoidWithOne_210_ = lean_ctor_get(v___x_209_, 1);
lean_inc_ref(v_toAddMonoidWithOne_210_);
lean_dec_ref(v___x_209_);
v_toOne_211_ = lean_ctor_get(v_toAddMonoidWithOne_210_, 2);
lean_inc_n(v_toOne_211_, 2);
lean_dec_ref(v_toAddMonoidWithOne_210_);
v___x_212_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4, &lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4_once, _init_lp_V14Formalization_V14Formalization_V14App_Tmat___closed__4);
v_toFun_213_ = lean_ctor_get(v___x_212_, 0);
v___f_214_ = ((lean_object*)(lp_V14Formalization_V14Formalization_V14App_Tmat___closed__5));
v___f_215_ = ((lean_object*)(lp_V14Formalization_V14Formalization_V14App_Tmat___closed__6));
v___f_216_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__4___boxed), 3, 2);
lean_closure_set(v___f_216_, 0, v_toZero_203_);
lean_closure_set(v___f_216_, 1, v___f_214_);
v___f_217_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__2___boxed), 3, 2);
lean_closure_set(v___f_217_, 0, v_toOne_211_);
lean_closure_set(v___f_217_, 1, v___f_216_);
v___f_218_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__3___boxed), 4, 2);
lean_closure_set(v___f_218_, 0, v___f_217_);
lean_closure_set(v___f_218_, 1, v___f_215_);
v___x_219_ = lean_apply_1(v_toNeg_208_, v_toOne_211_);
v___f_220_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_sigmaLift___lam__5___boxed), 3, 2);
lean_closure_set(v___f_220_, 0, v___x_219_);
lean_closure_set(v___f_220_, 1, v___f_214_);
v___f_221_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__4___boxed), 3, 2);
lean_closure_set(v___f_221_, 0, v_toZero_203_);
lean_closure_set(v___f_221_, 1, v___f_220_);
v___f_222_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_Tmat___lam__3___boxed), 4, 2);
lean_closure_set(v___f_222_, 0, v___f_221_);
lean_closure_set(v___f_222_, 1, v___f_218_);
lean_inc(v_toFun_213_);
v___x_223_ = lean_apply_1(v_toFun_213_, v___f_222_);
return v___x_223_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_sigma(void){
_start:
{
lean_object* v___x_224_; 
v___x_224_ = lp_V14Formalization_V14Formalization_V14App_sigmaLift;
return v___x_224_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___lam__0(lean_object* v___x_225_, lean_object* v_i_226_){
_start:
{
lean_inc_ref(v___x_225_);
return v___x_225_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___lam__0___boxed(lean_object* v___x_227_, lean_object* v_i_228_){
_start:
{
lean_object* v_res_229_; 
v_res_229_ = lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___lam__0(v___x_227_, v_i_228_);
lean_dec(v_i_228_);
lean_dec_ref(v___x_227_);
return v_res_229_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__0(void){
_start:
{
lean_object* v___x_230_; lean_object* v___f_231_; 
v___x_230_ = lp_mathlib_Rat_addCommGroup;
v___f_231_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___lam__0___boxed), 2, 1);
lean_closure_set(v___f_231_, 0, v___x_230_);
return v___f_231_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__1(void){
_start:
{
lean_object* v___f_232_; lean_object* v___x_233_; 
v___f_232_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__0, &lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__0_once, _init_lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__0);
v___x_233_ = lp_mathlib_Pi_addCommGroup___redArg(v___f_232_);
return v___x_233_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg(void){
_start:
{
lean_object* v___x_234_; 
v___x_234_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__1, &lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__1_once, _init_lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg___closed__1);
return v___x_234_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__0(void){
_start:
{
lean_object* v___x_235_; lean_object* v___x_236_; 
v___x_235_ = lp_mathlib_Rat_commSemiring;
v___x_236_ = lp_mathlib_Semiring_toModule___redArg(v___x_235_);
return v___x_236_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__1(void){
_start:
{
lean_object* v___x_237_; lean_object* v___x_238_; 
v___x_237_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__0, &lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__0_once, _init_lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__0);
v___x_238_ = lp_mathlib_Pi_Function_module___redArg(v___x_237_);
return v___x_238_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_V14App_instModuleKReg(void){
_start:
{
lean_object* v___x_239_; 
v___x_239_ = lean_obj_once(&lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__1, &lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__1_once, _init_lp_V14Formalization_V14Formalization_V14App_instModuleKReg___closed__1);
return v___x_239_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_regularRep___lam__0(lean_object* v___y_240_, lean_object* v___y_241_, lean_object* v_j_242_){
_start:
{
lean_object* v___x_243_; 
v___x_243_ = lean_apply_2(v___y_240_, v_j_242_, v___y_241_);
return v___x_243_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_regularRep___lam__1(lean_object* v_g_244_, lean_object* v___y_245_, lean_object* v_j_246_){
_start:
{
lean_object* v___x_247_; 
v___x_247_ = lp_V14Formalization_Matrix_adjugate___at___00V14Formalization_GeometricCarrier_cosetAmbientAct_spec__0(v_g_244_, v___y_245_, v_j_246_);
return v___x_247_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_regularRep___lam__2(lean_object* v___y_248_, lean_object* v_g_249_, lean_object* v___y_250_, lean_object* v___y_251_){
_start:
{
lean_object* v___f_252_; lean_object* v___f_253_; lean_object* v___x_254_; 
v___f_252_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_regularRep___lam__0), 3, 2);
lean_closure_set(v___f_252_, 0, v___y_248_);
lean_closure_set(v___f_252_, 1, v___y_251_);
v___f_253_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_regularRep___lam__1), 3, 2);
lean_closure_set(v___f_253_, 0, v_g_249_);
lean_closure_set(v___f_253_, 1, v___y_250_);
v___x_254_ = lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0(v___f_253_, v___f_252_);
return v___x_254_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_V14App_regularRep___lam__3(lean_object* v_g_255_, lean_object* v___y_256_, lean_object* v___y_257_){
_start:
{
lean_object* v___f_258_; lean_object* v___x_259_; 
v___f_258_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_V14App_regularRep___lam__2), 4, 2);
lean_closure_set(v___f_258_, 0, v___y_257_);
lean_closure_set(v___f_258_, 1, v_g_255_);
v___x_259_ = lean_apply_1(v___y_256_, v___f_258_);
return v___x_259_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_CentralizerObstruction(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_CentralizerD12(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_GeometricCarrier(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_SpecificGroups_Dihedral(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_SpecialLinearGroup(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_ProjectiveSpecialLinearGroup(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_ZMod_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Field_ZMod(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Nat_Prime_Defs(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_Subgroup_Center(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RepresentationTheory_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_FreeModule_Finite_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Module_Pi(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Projectivization_Basic(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_V14Application(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
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
res = initialize_mathlib_Mathlib_GroupTheory_SpecificGroups_Dihedral(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_SpecialLinearGroup(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_ProjectiveSpecialLinearGroup(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_ZMod_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Field_ZMod(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Nat_Prime_Defs(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_Subgroup_Center(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RepresentationTheory_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_FreeModule_Finite_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Module_Pi(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Projectivization_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11 = _init_lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11();
lean_mark_persistent(lp_V14Formalization_V14Formalization_V14App_instGroupPSL2F11);
lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11 = _init_lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11();
lean_mark_persistent(lp_V14Formalization_V14Formalization_V14App_instFintypePSL2F11);
lp_V14Formalization_V14Formalization_V14App_Tmat = _init_lp_V14Formalization_V14Formalization_V14App_Tmat();
lean_mark_persistent(lp_V14Formalization_V14Formalization_V14App_Tmat);
lp_V14Formalization_V14Formalization_V14App_Umat = _init_lp_V14Formalization_V14Formalization_V14App_Umat();
lean_mark_persistent(lp_V14Formalization_V14Formalization_V14App_Umat);
lp_V14Formalization_V14Formalization_V14App_sigmaLift = _init_lp_V14Formalization_V14Formalization_V14App_sigmaLift();
lean_mark_persistent(lp_V14Formalization_V14Formalization_V14App_sigmaLift);
lp_V14Formalization_V14Formalization_V14App_sigma = _init_lp_V14Formalization_V14Formalization_V14App_sigma();
lean_mark_persistent(lp_V14Formalization_V14Formalization_V14App_sigma);
lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg = _init_lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg();
lean_mark_persistent(lp_V14Formalization_V14Formalization_V14App_instAddCommGroupReg);
lp_V14Formalization_V14Formalization_V14App_instModuleKReg = _init_lp_V14Formalization_V14Formalization_V14App_instModuleKReg();
lean_mark_persistent(lp_V14Formalization_V14Formalization_V14App_instModuleKReg);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
