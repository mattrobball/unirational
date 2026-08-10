// Lean compiler output
// Module: V14Formalization.WeilRep
// Imports: public import Init public meta import Init public import Mathlib.RingTheory.Polynomial.Cyclotomic.Basic public import Mathlib.RingTheory.Polynomial.Cyclotomic.Roots public import Mathlib.RingTheory.AdjoinRoot public import Mathlib.NumberTheory.LegendreSymbol.AddCharacter public import Mathlib.NumberTheory.GaussSum public import Mathlib.NumberTheory.MulChar.Basic public import Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic public import Mathlib.LinearAlgebra.Dimension.Finrank public import Mathlib.LinearAlgebra.FreeModule.Finite.Basic public import Mathlib.Data.ZMod.Basic public import Mathlib.Algebra.Field.ZMod public import Mathlib.Data.Nat.Prime.Basic public import Mathlib.GroupTheory.OrderOfElement public import Mathlib.Algebra.Module.Pi public import Mathlib.Algebra.BigOperators.Group.Finset.Basic public import Mathlib.Algebra.BigOperators.Ring.Finset public import Mathlib.Data.Fintype.BigOperators public import Mathlib.Algebra.Algebra.Basic public import Mathlib.Algebra.CharP.Basic public import Mathlib.FieldTheory.Minpoly.Field public import Mathlib.LinearAlgebra.Matrix.ToLin public import Mathlib.LinearAlgebra.Matrix.NonsingularInverse public import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup
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
lean_object* lp_mathlib_Semiring_toMonoidWithZero___redArg(lean_object*);
lean_object* lp_mathlib_instDistribOfSemiring___redArg(lean_object*);
lean_object* lp_mathlib_MonoidWithZero_toMulZeroOneClass___redArg(lean_object*);
lean_object* lp_mathlib_MulZeroOneClass_toMulZeroClass___redArg(lean_object*);
uint8_t lp_mathlib_ZMod_decidableEq(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_ZMod_decidableEq___boxed(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_ZMod_fintype___redArg(lean_object*);
uint8_t lp_mathlib_Fintype_IsSquare_decidablePred___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_nat_to_int(lean_object*);
lean_object* lean_int_neg(lean_object*);
lean_object* lp_mathlib_Field_toDivisionRing___redArg(lean_object*);
lean_object* lp_mathlib_Ring_toAddGroupWithOne___redArg(lean_object*);
lean_object* l_Fin_cases___redArg(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_Equiv_refl(lean_object*);
lean_object* lp_mathlib_ZMod_inv(lean_object*, lean_object*);
lean_object* lp_mathlib_instMulZeroClassOfSemiring___redArg(lean_object*);
lean_object* lp_mathlib_Ring_toAddCommGroup___redArg(lean_object*);
lean_object* lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(lean_object*);
static lean_once_cell_t lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__0;
static lean_once_cell_t lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__1;
static lean_once_cell_t lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2;
static const lean_closure_object lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_mathlib_ZMod_decidableEq___boxed, .m_arity = 3, .m_num_fixed = 1, .m_objs = {((lean_object*)(((size_t)(11) << 1) | 1))} };
static const lean_object* lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__3 = (const lean_object*)&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__3_value;
static lean_once_cell_t lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__4;
static lean_once_cell_t lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__5;
static lean_once_cell_t lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__6;
static lean_once_cell_t lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__7_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__7;
LEAN_EXPORT lean_object* lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0(lean_object*);
static const lean_closure_object lp_V14Formalization_quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0___closed__0 = (const lean_object*)&lp_V14Formalization_quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0___closed__0_value;
LEAN_EXPORT const lean_object* lp_V14Formalization_quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0 = (const lean_object*)&lp_V14Formalization_quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0___closed__0_value;
LEAN_EXPORT const lean_object* lp_V14Formalization_V14Formalization_WeilRep_00_u03c7_u2082_u2124 = (const lean_object*)&lp_V14Formalization_quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0___closed__0_value;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_EvenSub;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_U;
static lean_once_cell_t lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0;
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0(lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__1;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_twoInv;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__0(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__0___boxed(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__1___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__2(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__2___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__3(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__3___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__4(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__5(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__5___boxed(lean_object*, lean_object*, lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__0;
static const lean_closure_object lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__0___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__1 = (const lean_object*)&lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__1_value;
static const lean_closure_object lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__1___boxed, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__2 = (const lean_object*)&lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__2_value;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Tmat;
static lean_object* _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__0(void){
_start:
{
lean_object* v___x_1_; lean_object* v___x_2_; 
v___x_1_ = lean_unsigned_to_nat(11u);
v___x_2_ = lp_mathlib_ZMod_instField___redArg(v___x_1_);
return v___x_2_;
}
}
static lean_object* _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__1(void){
_start:
{
lean_object* v___x_3_; lean_object* v___x_4_; 
v___x_3_ = lean_obj_once(&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__0, &lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__0_once, _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__0);
v___x_4_ = lp_mathlib_Field_toSemifield___redArg(v___x_3_);
return v___x_4_;
}
}
static lean_object* _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2(void){
_start:
{
lean_object* v___x_5_; lean_object* v___x_6_; 
v___x_5_ = lean_obj_once(&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__1, &lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__1_once, _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__1);
v___x_6_ = lp_mathlib_Semifield_toDivisionSemiring___redArg(v___x_5_);
return v___x_6_;
}
}
static lean_object* _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__4(void){
_start:
{
lean_object* v___x_9_; lean_object* v___x_10_; 
v___x_9_ = lean_unsigned_to_nat(11u);
v___x_10_ = lp_mathlib_ZMod_fintype___redArg(v___x_9_);
return v___x_10_;
}
}
static lean_object* _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__5(void){
_start:
{
lean_object* v___x_11_; lean_object* v___x_12_; 
v___x_11_ = lean_unsigned_to_nat(1u);
v___x_12_ = lean_nat_to_int(v___x_11_);
return v___x_12_;
}
}
static lean_object* _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__6(void){
_start:
{
lean_object* v___x_13_; lean_object* v___x_14_; 
v___x_13_ = lean_obj_once(&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__5, &lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__5_once, _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__5);
v___x_14_ = lean_int_neg(v___x_13_);
return v___x_14_;
}
}
static lean_object* _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__7(void){
_start:
{
lean_object* v___x_15_; lean_object* v___x_16_; 
v___x_15_ = lean_unsigned_to_nat(0u);
v___x_16_ = lean_nat_to_int(v___x_15_);
return v___x_16_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0(lean_object* v_a_17_){
_start:
{
lean_object* v___x_18_; lean_object* v___x_19_; lean_object* v_toSemiring_20_; lean_object* v___x_21_; lean_object* v___x_22_; lean_object* v_toMul_23_; lean_object* v___x_24_; lean_object* v___x_25_; lean_object* v_toZero_26_; uint8_t v___x_27_; 
v___x_18_ = lean_unsigned_to_nat(11u);
v___x_19_ = lean_obj_once(&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2, &lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2_once, _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2);
v_toSemiring_20_ = lean_ctor_get(v___x_19_, 0);
v___x_21_ = lp_mathlib_Semiring_toMonoidWithZero___redArg(v_toSemiring_20_);
lean_inc_ref(v_toSemiring_20_);
v___x_22_ = lp_mathlib_instDistribOfSemiring___redArg(v_toSemiring_20_);
v_toMul_23_ = lean_ctor_get(v___x_22_, 0);
lean_inc(v_toMul_23_);
lean_dec_ref(v___x_22_);
v___x_24_ = lp_mathlib_MonoidWithZero_toMulZeroOneClass___redArg(v___x_21_);
v___x_25_ = lp_mathlib_MulZeroOneClass_toMulZeroClass___redArg(v___x_24_);
v_toZero_26_ = lean_ctor_get(v___x_25_, 1);
lean_inc(v_toZero_26_);
lean_dec_ref(v___x_25_);
v___x_27_ = lp_mathlib_ZMod_decidableEq(v___x_18_, v_a_17_, v_toZero_26_);
lean_dec(v_toZero_26_);
if (v___x_27_ == 0)
{
lean_object* v___x_28_; lean_object* v___x_29_; uint8_t v___x_30_; 
v___x_28_ = ((lean_object*)(lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__3));
v___x_29_ = lean_obj_once(&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__4, &lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__4_once, _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__4);
v___x_30_ = lp_mathlib_Fintype_IsSquare_decidablePred___redArg(v_toMul_23_, v___x_29_, v___x_28_, v_a_17_);
if (v___x_30_ == 0)
{
lean_object* v___x_31_; 
v___x_31_ = lean_obj_once(&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__6, &lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__6_once, _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__6);
return v___x_31_;
}
else
{
lean_object* v___x_32_; 
v___x_32_ = lean_obj_once(&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__5, &lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__5_once, _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__5);
return v___x_32_;
}
}
else
{
lean_object* v___x_33_; 
lean_dec(v_toMul_23_);
lean_dec(v_a_17_);
v___x_33_ = lean_obj_once(&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__7, &lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__7_once, _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__7);
return v___x_33_;
}
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRep_EvenSub(void){
_start:
{
lean_object* v___x_37_; 
v___x_37_ = lean_box(0);
return v___x_37_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRep_U(void){
_start:
{
lean_object* v___x_38_; 
v___x_38_ = lean_box(0);
return v___x_38_;
}
}
static lean_object* _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0(void){
_start:
{
lean_object* v___x_39_; lean_object* v___x_40_; 
v___x_39_ = lean_obj_once(&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__0, &lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__0_once, _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__0);
v___x_40_ = lp_mathlib_Field_toDivisionRing___redArg(v___x_39_);
return v___x_40_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0(lean_object* v_a_41_){
_start:
{
lean_object* v___x_42_; lean_object* v_toRing_43_; lean_object* v___x_44_; lean_object* v_toAddMonoidWithOne_45_; lean_object* v_toNatCast_46_; lean_object* v___x_47_; 
v___x_42_ = lean_obj_once(&lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0, &lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0_once, _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0);
v_toRing_43_ = lean_ctor_get(v___x_42_, 0);
lean_inc_ref(v_toRing_43_);
v___x_44_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_43_);
v_toAddMonoidWithOne_45_ = lean_ctor_get(v___x_44_, 1);
lean_inc_ref(v_toAddMonoidWithOne_45_);
lean_dec_ref(v___x_44_);
v_toNatCast_46_ = lean_ctor_get(v_toAddMonoidWithOne_45_, 0);
lean_inc(v_toNatCast_46_);
lean_dec_ref(v_toAddMonoidWithOne_45_);
v___x_47_ = lean_apply_1(v_toNatCast_46_, v_a_41_);
return v___x_47_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__0(void){
_start:
{
lean_object* v___x_48_; lean_object* v___x_49_; 
v___x_48_ = lean_unsigned_to_nat(2u);
v___x_49_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0(v___x_48_);
return v___x_49_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__1(void){
_start:
{
lean_object* v___x_50_; lean_object* v___x_51_; lean_object* v___x_52_; 
v___x_50_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__0, &lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__0);
v___x_51_ = lean_unsigned_to_nat(11u);
v___x_52_ = lp_mathlib_ZMod_inv(v___x_51_, v___x_50_);
return v___x_52_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRep_twoInv(void){
_start:
{
lean_object* v___x_53_; 
v___x_53_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__1, &lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__1_once, _init_lp_V14Formalization_V14Formalization_WeilRep_twoInv___closed__1);
return v___x_53_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__0(lean_object* v___y_54_){
_start:
{
lean_internal_panic_unreachable();
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__0___boxed(lean_object* v___y_55_){
_start:
{
lean_object* v_res_56_; 
v_res_56_ = lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__0(v___y_55_);
lean_dec(v___y_55_);
return v_res_56_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__1(lean_object* v___y_57_, lean_object* v___y_58_){
_start:
{
lean_internal_panic_unreachable();
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__1___boxed(lean_object* v___y_59_, lean_object* v___y_60_){
_start:
{
lean_object* v_res_61_; 
v_res_61_ = lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__1(v___y_59_, v___y_60_);
lean_dec(v___y_60_);
lean_dec(v___y_59_);
return v_res_61_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__2(lean_object* v_toZero_62_, lean_object* v___f_63_, lean_object* v___y_64_){
_start:
{
lean_object* v___x_65_; 
v___x_65_ = l_Fin_cases___redArg(v_toZero_62_, v___f_63_, v___y_64_);
return v___x_65_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__2___boxed(lean_object* v_toZero_66_, lean_object* v___f_67_, lean_object* v___y_68_){
_start:
{
lean_object* v_res_69_; 
v_res_69_ = lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__2(v_toZero_66_, v___f_67_, v___y_68_);
lean_dec(v___y_68_);
lean_dec(v_toZero_66_);
return v_res_69_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__3(lean_object* v_toOne_70_, lean_object* v___f_71_, lean_object* v___y_72_){
_start:
{
lean_object* v___x_73_; 
v___x_73_ = l_Fin_cases___redArg(v_toOne_70_, v___f_71_, v___y_72_);
return v___x_73_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__3___boxed(lean_object* v_toOne_74_, lean_object* v___f_75_, lean_object* v___y_76_){
_start:
{
lean_object* v_res_77_; 
v_res_77_ = lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__3(v_toOne_74_, v___f_75_, v___y_76_);
lean_dec(v___y_76_);
lean_dec(v_toOne_74_);
return v_res_77_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__4(lean_object* v___f_78_, lean_object* v___f_79_, lean_object* v___y_80_, lean_object* v___y_81_){
_start:
{
lean_object* v___x_2758__overap_82_; lean_object* v___x_83_; 
v___x_2758__overap_82_ = l_Fin_cases___redArg(v___f_78_, v___f_79_, v___y_80_);
v___x_83_ = lean_apply_1(v___x_2758__overap_82_, v___y_81_);
return v___x_83_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__4___boxed(lean_object* v___f_84_, lean_object* v___f_85_, lean_object* v___y_86_, lean_object* v___y_87_){
_start:
{
lean_object* v_res_88_; 
v_res_88_ = lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__4(v___f_84_, v___f_85_, v___y_86_, v___y_87_);
lean_dec(v___y_86_);
lean_dec_ref(v___f_84_);
return v_res_88_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__5(lean_object* v___x_89_, lean_object* v___f_90_, lean_object* v___y_91_){
_start:
{
lean_object* v___x_92_; 
v___x_92_ = l_Fin_cases___redArg(v___x_89_, v___f_90_, v___y_91_);
return v___x_92_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__5___boxed(lean_object* v___x_93_, lean_object* v___f_94_, lean_object* v___y_95_){
_start:
{
lean_object* v_res_96_; 
v_res_96_ = lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__5(v___x_93_, v___f_94_, v___y_95_);
lean_dec(v___y_95_);
lean_dec(v___x_93_);
return v_res_96_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__0(void){
_start:
{
lean_object* v___x_97_; 
v___x_97_ = lp_mathlib_Equiv_refl(lean_box(0));
return v___x_97_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRep_Smat(void){
_start:
{
lean_object* v___x_100_; lean_object* v_toSemiring_101_; lean_object* v___x_102_; lean_object* v_toZero_103_; lean_object* v___x_104_; lean_object* v_toRing_105_; lean_object* v___x_106_; lean_object* v___x_107_; lean_object* v_toNeg_108_; lean_object* v___x_109_; lean_object* v_toAddMonoidWithOne_110_; lean_object* v_toOne_111_; lean_object* v___x_112_; lean_object* v_toFun_113_; lean_object* v___f_114_; lean_object* v___f_115_; lean_object* v___f_116_; lean_object* v___f_117_; lean_object* v___f_118_; lean_object* v___x_119_; lean_object* v___f_120_; lean_object* v___f_121_; lean_object* v___f_122_; lean_object* v___x_123_; 
v___x_100_ = lean_obj_once(&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2, &lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2_once, _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2);
v_toSemiring_101_ = lean_ctor_get(v___x_100_, 0);
lean_inc_ref(v_toSemiring_101_);
v___x_102_ = lp_mathlib_instMulZeroClassOfSemiring___redArg(v_toSemiring_101_);
v_toZero_103_ = lean_ctor_get(v___x_102_, 1);
lean_inc_n(v_toZero_103_, 2);
lean_dec_ref(v___x_102_);
v___x_104_ = lean_obj_once(&lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0, &lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0_once, _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0);
v_toRing_105_ = lean_ctor_get(v___x_104_, 0);
v___x_106_ = lp_mathlib_Ring_toAddCommGroup___redArg(v_toRing_105_);
v___x_107_ = lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(v___x_106_);
lean_dec_ref(v___x_106_);
v_toNeg_108_ = lean_ctor_get(v___x_107_, 1);
lean_inc(v_toNeg_108_);
lean_dec_ref(v___x_107_);
lean_inc_ref(v_toRing_105_);
v___x_109_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_105_);
v_toAddMonoidWithOne_110_ = lean_ctor_get(v___x_109_, 1);
lean_inc_ref(v_toAddMonoidWithOne_110_);
lean_dec_ref(v___x_109_);
v_toOne_111_ = lean_ctor_get(v_toAddMonoidWithOne_110_, 2);
lean_inc_n(v_toOne_111_, 2);
lean_dec_ref(v_toAddMonoidWithOne_110_);
v___x_112_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__0, &lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__0);
v_toFun_113_ = lean_ctor_get(v___x_112_, 0);
v___f_114_ = ((lean_object*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__1));
v___f_115_ = ((lean_object*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__2));
v___f_116_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__2___boxed), 3, 2);
lean_closure_set(v___f_116_, 0, v_toZero_103_);
lean_closure_set(v___f_116_, 1, v___f_114_);
v___f_117_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__3___boxed), 3, 2);
lean_closure_set(v___f_117_, 0, v_toOne_111_);
lean_closure_set(v___f_117_, 1, v___f_116_);
v___f_118_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__4___boxed), 4, 2);
lean_closure_set(v___f_118_, 0, v___f_117_);
lean_closure_set(v___f_118_, 1, v___f_115_);
v___x_119_ = lean_apply_1(v_toNeg_108_, v_toOne_111_);
v___f_120_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__5___boxed), 3, 2);
lean_closure_set(v___f_120_, 0, v___x_119_);
lean_closure_set(v___f_120_, 1, v___f_114_);
v___f_121_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__2___boxed), 3, 2);
lean_closure_set(v___f_121_, 0, v_toZero_103_);
lean_closure_set(v___f_121_, 1, v___f_120_);
v___f_122_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__4___boxed), 4, 2);
lean_closure_set(v___f_122_, 0, v___f_121_);
lean_closure_set(v___f_122_, 1, v___f_118_);
lean_inc(v_toFun_113_);
v___x_123_ = lean_apply_1(v_toFun_113_, v___f_122_);
return v___x_123_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_WeilRep_Tmat(void){
_start:
{
lean_object* v___x_124_; lean_object* v_toRing_125_; lean_object* v___x_126_; lean_object* v_toAddMonoidWithOne_127_; lean_object* v_toOne_128_; lean_object* v___x_129_; lean_object* v_toSemiring_130_; lean_object* v___x_131_; lean_object* v_toZero_132_; lean_object* v___x_133_; lean_object* v_toFun_134_; lean_object* v___f_135_; lean_object* v___f_136_; lean_object* v___f_137_; lean_object* v___f_138_; lean_object* v___f_139_; lean_object* v___f_140_; lean_object* v___f_141_; lean_object* v___x_142_; 
v___x_124_ = lean_obj_once(&lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0, &lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0_once, _init_lp_V14Formalization_Nat_cast___at___00V14Formalization_WeilRep_twoInv_spec__0___closed__0);
v_toRing_125_ = lean_ctor_get(v___x_124_, 0);
lean_inc_ref(v_toRing_125_);
v___x_126_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_125_);
v_toAddMonoidWithOne_127_ = lean_ctor_get(v___x_126_, 1);
lean_inc_ref(v_toAddMonoidWithOne_127_);
lean_dec_ref(v___x_126_);
v_toOne_128_ = lean_ctor_get(v_toAddMonoidWithOne_127_, 2);
lean_inc_n(v_toOne_128_, 2);
lean_dec_ref(v_toAddMonoidWithOne_127_);
v___x_129_ = lean_obj_once(&lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2, &lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2_once, _init_lp_V14Formalization_quadraticCharFun___at___00quadraticChar___at___00V14Formalization_WeilRep_00_u03c7_u2082_u2124_spec__0_spec__0___closed__2);
v_toSemiring_130_ = lean_ctor_get(v___x_129_, 0);
lean_inc_ref(v_toSemiring_130_);
v___x_131_ = lp_mathlib_instMulZeroClassOfSemiring___redArg(v_toSemiring_130_);
v_toZero_132_ = lean_ctor_get(v___x_131_, 1);
lean_inc(v_toZero_132_);
lean_dec_ref(v___x_131_);
v___x_133_ = lean_obj_once(&lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__0, &lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__0_once, _init_lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__0);
v_toFun_134_ = lean_ctor_get(v___x_133_, 0);
v___f_135_ = ((lean_object*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__1));
v___f_136_ = ((lean_object*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___closed__2));
v___f_137_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__3___boxed), 3, 2);
lean_closure_set(v___f_137_, 0, v_toOne_128_);
lean_closure_set(v___f_137_, 1, v___f_135_);
lean_inc_ref(v___f_137_);
v___f_138_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__3___boxed), 3, 2);
lean_closure_set(v___f_138_, 0, v_toOne_128_);
lean_closure_set(v___f_138_, 1, v___f_137_);
v___f_139_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__2___boxed), 3, 2);
lean_closure_set(v___f_139_, 0, v_toZero_132_);
lean_closure_set(v___f_139_, 1, v___f_137_);
v___f_140_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__4___boxed), 4, 2);
lean_closure_set(v___f_140_, 0, v___f_139_);
lean_closure_set(v___f_140_, 1, v___f_136_);
v___f_141_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_WeilRep_Smat___lam__4___boxed), 4, 2);
lean_closure_set(v___f_141_, 0, v___f_138_);
lean_closure_set(v___f_141_, 1, v___f_140_);
lean_inc(v_toFun_134_);
v___x_142_ = lean_apply_1(v_toFun_134_, v___f_141_);
return v___x_142_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_Polynomial_Cyclotomic_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_Polynomial_Cyclotomic_Roots(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_AdjoinRoot(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_NumberTheory_LegendreSymbol_AddCharacter(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_NumberTheory_GaussSum(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_NumberTheory_MulChar_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_NumberTheory_LegendreSymbol_QuadraticChar_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finrank(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_FreeModule_Finite_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_ZMod_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Field_ZMod(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Nat_Prime_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_OrderOfElement(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Module_Pi(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_BigOperators_Group_Finset_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_BigOperators_Ring_Finset(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Fintype_BigOperators(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Algebra_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_CharP_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_FieldTheory_Minpoly_Field(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_ToLin(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_NonsingularInverse(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_SpecialLinearGroup(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_WeilRep(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_Polynomial_Cyclotomic_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_Polynomial_Cyclotomic_Roots(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_AdjoinRoot(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_NumberTheory_LegendreSymbol_AddCharacter(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_NumberTheory_GaussSum(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_NumberTheory_MulChar_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_NumberTheory_LegendreSymbol_QuadraticChar_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Finrank(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_FreeModule_Finite_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_ZMod_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Field_ZMod(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Nat_Prime_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_OrderOfElement(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Module_Pi(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_BigOperators_Group_Finset_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_BigOperators_Ring_Finset(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Fintype_BigOperators(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Algebra_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_CharP_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_FieldTheory_Minpoly_Field(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_ToLin(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_NonsingularInverse(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_SpecialLinearGroup(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
lp_V14Formalization_V14Formalization_WeilRep_EvenSub = _init_lp_V14Formalization_V14Formalization_WeilRep_EvenSub();
lean_mark_persistent(lp_V14Formalization_V14Formalization_WeilRep_EvenSub);
lp_V14Formalization_V14Formalization_WeilRep_U = _init_lp_V14Formalization_V14Formalization_WeilRep_U();
lean_mark_persistent(lp_V14Formalization_V14Formalization_WeilRep_U);
lp_V14Formalization_V14Formalization_WeilRep_twoInv = _init_lp_V14Formalization_V14Formalization_WeilRep_twoInv();
lean_mark_persistent(lp_V14Formalization_V14Formalization_WeilRep_twoInv);
lp_V14Formalization_V14Formalization_WeilRep_Smat = _init_lp_V14Formalization_V14Formalization_WeilRep_Smat();
lean_mark_persistent(lp_V14Formalization_V14Formalization_WeilRep_Smat);
lp_V14Formalization_V14Formalization_WeilRep_Tmat = _init_lp_V14Formalization_V14Formalization_WeilRep_Tmat();
lean_mark_persistent(lp_V14Formalization_V14Formalization_WeilRep_Tmat);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
