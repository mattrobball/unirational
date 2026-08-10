// Lean compiler output
// Module: V14Formalization.GeometricV14Carrier
// Imports: public import Init public meta import Init public import V14Formalization.GeometricFanoCarrier public import V14Formalization.CentralizerD12 public import V14Formalization.PSLCard public import Mathlib.LinearAlgebra.Projectivization.Basic public import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Card public import Mathlib.GroupTheory.Index public import Mathlib.Algebra.Field.ZMod public import Mathlib.GroupTheory.SpecificGroups.Cyclic public import Mathlib.RingTheory.RootsOfUnity.Basic public import Mathlib.NumberTheory.Cyclotomic.PrimitiveRoots public import Mathlib.RingTheory.RootsOfUnity.PrimitiveRoots public import Mathlib.RingTheory.PowerBasis public import Mathlib.RingTheory.Polynomial.Cyclotomic.Basic public import Mathlib.FieldTheory.IntermediateField.Adjoin.Basic public import Mathlib.FieldTheory.IntermediateField.Algebraic public import Mathlib.FieldTheory.KummerPolynomial public import Mathlib.FieldTheory.Minpoly.Field public import Mathlib.RingTheory.PrincipalIdealDomain public import Mathlib.LinearAlgebra.FreeModule.Basic public import Mathlib.LinearAlgebra.FreeModule.Finite.Basic public import Mathlib.LinearAlgebra.Basis.VectorSpace public import Mathlib.LinearAlgebra.Charpoly.Basic public import Mathlib.Algebra.Module.LinearMap.End public import Mathlib.Algebra.Polynomial.Degree.SmallDegree public import Mathlib.Algebra.Polynomial.EraseLead public import Mathlib.Algebra.Polynomial.RingDivision public import Mathlib.Algebra.Polynomial.Div public import Mathlib.Algebra.Polynomial.FieldDivision public import Mathlib.Algebra.Polynomial.SpecificDegree public import Mathlib.Data.Rat.Lemmas public import Mathlib.Data.Set.PowersetCard public import Mathlib.Order.Hom.PowersetCard public import Mathlib.Data.Finset.Sort public import Mathlib.Tactic.FinCases public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas public import Mathlib.LinearAlgebra.Dimension.OrzechProperty public import Mathlib.LinearAlgebra.Dual.Lemmas public import Mathlib.GroupTheory.Coset.Card public import Mathlib.GroupTheory.Sylow public import Mathlib.GroupTheory.PGroup public import Mathlib.GroupTheory.Index public import Mathlib.Algebra.Group.Subgroup.Finite public import Mathlib.Data.Nat.Factorization.Basic public import Mathlib.Data.Fintype.Card public import Mathlib.Data.Set.Card public import Mathlib.LinearAlgebra.Trace public import Mathlib.LinearAlgebra.Projection public import Mathlib.Algebra.Group.Idempotent public import Mathlib.LinearAlgebra.Semisimple public import Mathlib.LinearAlgebra.ExteriorPower.Basic public import Mathlib.LinearAlgebra.ExteriorPower.Basis public import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff public import Mathlib.LinearAlgebra.Charpoly.ToMatrix public import Mathlib.RingTheory.AdjoinRoot public import Mathlib.RingTheory.Trace.Basic public import Mathlib.LinearAlgebra.Dimension.Constructions public import Mathlib.RingTheory.AlgebraTower public import Mathlib.LinearAlgebra.Matrix.ToLin public import Mathlib.LinearAlgebra.Matrix.Trace public import Mathlib.Algebra.Polynomial.Eval.Defs public import Mathlib.RingTheory.Ideal.Quotient.Defs public import Mathlib.Algebra.BigOperators.Ring.Finset public import Mathlib.Data.Fintype.BigOperators public import Mathlib.Data.Finset.Card public import Mathlib.RingTheory.Polynomial.Basic public import Mathlib.Algebra.GroupWithZero.Associated public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas public import Mathlib.LinearAlgebra.Charpoly.Basic public import Mathlib.FieldTheory.Minpoly.Field public import Mathlib.RingTheory.PrincipalIdealDomain
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
lean_object* lp_V14Formalization_dotProduct___at___00V14Formalization_PSLCard_convAt_spec__1(lean_object*, lean_object*);
lean_object* lp_V14Formalization_Matrix_adjugate___at___00V14Formalization_PSLCard_convAt_spec__0(lean_object*, lean_object*, lean_object*);
lean_object* l_instDecidableEqFin___boxed(lean_object*, lean_object*, lean_object*);
extern lean_object* lp_V14Formalization_V14Formalization_CentralizerN_rotGen;
lean_object* l_List_finRange(lean_object*);
lean_object* lp_mathlib_ZMod_commRing(lean_object*);
lean_object* lp_mathlib_Semiring_toNonUnitalSemiring___redArg(lean_object*);
lean_object* lp_mathlib_Matrix_nonUnitalNonAssocSemiring___redArg(lean_object*, lean_object*);
lean_object* lp_mathlib_Semiring_toNonAssocSemiring___redArg(lean_object*);
lean_object* lp_mathlib_Matrix_nonAssocSemiring___redArg(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_npowBinRec_go___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
extern lean_object* lp_V14Formalization_V14Formalization_CentralizerN_reflGen;
extern lean_object* lp_V14Formalization_V14Formalization_WeilRep_Smat;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_U;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14___lam__0(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14___lam__0___boxed(lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14___lam__0___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14___closed__0_value;
LEAN_EXPORT const lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14 = (const lean_object*)&lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14___closed__0_value;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_sigma;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__1(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__2(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__3(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__4(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__5(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__6(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__7(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__8(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__9(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__10(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__11(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv(lean_object*);
LEAN_EXPORT const lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14M = (const lean_object*)&lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14___closed__0_value;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_actionKernelM;
LEAN_EXPORT lean_object* lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_rGen;
LEAN_EXPORT lean_object* lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_sGen;
LEAN_EXPORT lean_object* lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_instDecidableEqFin___boxed, .m_arity = 3, .m_num_fixed = 1, .m_objs = {((lean_object*)(((size_t)(2) << 1) | 1))} };
static const lean_object* lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__0 = (const lean_object*)&lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__0_value;
static lean_once_cell_t lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__1;
static lean_once_cell_t lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__2;
static lean_once_cell_t lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__3;
LEAN_EXPORT lean_object* lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2;
static lean_object* _init_lp_V14Formalization_V14Formalization_GeometricV14Carrier_U(void){
_start:
{
lean_object* v___x_1_; 
v___x_1_ = lean_box(0);
return v___x_1_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14___lam__0(lean_object* v_x_2_){
_start:
{
lean_inc(v_x_2_);
return v_x_2_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14___lam__0___boxed(lean_object* v_x_3_){
_start:
{
lean_object* v_res_4_; 
v_res_4_ = lp_V14Formalization_V14Formalization_GeometricV14Carrier_embedV14___lam__0(v_x_3_);
lean_dec(v_x_3_);
return v_res_4_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_GeometricV14Carrier_sigma(void){
_start:
{
lean_object* v___x_7_; 
v___x_7_ = lp_V14Formalization_V14Formalization_WeilRep_Smat;
return v___x_7_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__0(lean_object* v_h_8_, lean_object* v___y_9_, lean_object* v_j_10_){
_start:
{
lean_object* v___x_11_; 
v___x_11_ = lean_apply_2(v_h_8_, v_j_10_, v___y_9_);
return v___x_11_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__1(lean_object* v_h_12_, lean_object* v___y_13_, lean_object* v_j_14_){
_start:
{
lean_object* v___x_15_; 
v___x_15_ = lp_V14Formalization_Matrix_adjugate___at___00V14Formalization_PSLCard_convAt_spec__0(v_h_12_, v___y_13_, v_j_14_);
return v___x_15_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__2(lean_object* v_g_16_, lean_object* v_j_17_, lean_object* v_j_18_){
_start:
{
lean_object* v___x_19_; 
v___x_19_ = lean_apply_2(v_g_16_, v_j_18_, v_j_17_);
return v___x_19_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__3(lean_object* v_g_20_, lean_object* v___f_21_, lean_object* v_j_22_){
_start:
{
lean_object* v___f_23_; lean_object* v___x_24_; 
v___f_23_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__2), 3, 2);
lean_closure_set(v___f_23_, 0, v_g_20_);
lean_closure_set(v___f_23_, 1, v_j_22_);
v___x_24_ = lp_V14Formalization_dotProduct___at___00V14Formalization_PSLCard_convAt_spec__1(v___f_21_, v___f_23_);
return v___x_24_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__4(lean_object* v_h_25_, lean_object* v_g_26_, lean_object* v___y_27_, lean_object* v___y_28_){
_start:
{
lean_object* v___f_29_; lean_object* v___f_30_; lean_object* v___f_31_; lean_object* v___x_32_; 
lean_inc(v_h_25_);
v___f_29_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__0), 3, 2);
lean_closure_set(v___f_29_, 0, v_h_25_);
lean_closure_set(v___f_29_, 1, v___y_28_);
v___f_30_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__1), 3, 2);
lean_closure_set(v___f_30_, 0, v_h_25_);
lean_closure_set(v___f_30_, 1, v___y_27_);
v___f_31_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__3), 3, 2);
lean_closure_set(v___f_31_, 0, v_g_26_);
lean_closure_set(v___f_31_, 1, v___f_30_);
v___x_32_ = lp_V14Formalization_dotProduct___at___00V14Formalization_PSLCard_convAt_spec__1(v___f_31_, v___f_29_);
return v___x_32_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__5(lean_object* v_h_33_, lean_object* v_g_34_){
_start:
{
lean_object* v___f_35_; 
v___f_35_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__4), 4, 2);
lean_closure_set(v___f_35_, 0, v_h_33_);
lean_closure_set(v___f_35_, 1, v_g_34_);
return v___f_35_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__6(lean_object* v_h_36_, lean_object* v___y_37_, lean_object* v_j_38_){
_start:
{
lean_object* v___x_39_; 
v___x_39_ = lp_V14Formalization_Matrix_adjugate___at___00V14Formalization_PSLCard_convAt_spec__0(v_h_36_, v_j_38_, v___y_37_);
return v___x_39_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__7(lean_object* v_h_40_, lean_object* v___y_41_, lean_object* v_j_42_){
_start:
{
lean_object* v___x_43_; 
v___x_43_ = lean_apply_2(v_h_40_, v___y_41_, v_j_42_);
return v___x_43_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__8(lean_object* v_t_44_, lean_object* v_j_45_, lean_object* v_j_46_){
_start:
{
lean_object* v___x_47_; 
v___x_47_ = lean_apply_2(v_t_44_, v_j_46_, v_j_45_);
return v___x_47_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__9(lean_object* v_t_48_, lean_object* v___f_49_, lean_object* v_j_50_){
_start:
{
lean_object* v___f_51_; lean_object* v___x_52_; 
v___f_51_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__8), 3, 2);
lean_closure_set(v___f_51_, 0, v_t_48_);
lean_closure_set(v___f_51_, 1, v_j_50_);
v___x_52_ = lp_V14Formalization_dotProduct___at___00V14Formalization_PSLCard_convAt_spec__1(v___f_49_, v___f_51_);
return v___x_52_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__10(lean_object* v_h_53_, lean_object* v_t_54_, lean_object* v___y_55_, lean_object* v___y_56_){
_start:
{
lean_object* v___f_57_; lean_object* v___f_58_; lean_object* v___f_59_; lean_object* v___x_60_; 
lean_inc(v_h_53_);
v___f_57_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__6), 3, 2);
lean_closure_set(v___f_57_, 0, v_h_53_);
lean_closure_set(v___f_57_, 1, v___y_56_);
v___f_58_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__7), 3, 2);
lean_closure_set(v___f_58_, 0, v_h_53_);
lean_closure_set(v___f_58_, 1, v___y_55_);
v___f_59_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__9), 3, 2);
lean_closure_set(v___f_59_, 0, v_t_54_);
lean_closure_set(v___f_59_, 1, v___f_58_);
v___x_60_ = lp_V14Formalization_dotProduct___at___00V14Formalization_PSLCard_convAt_spec__1(v___f_59_, v___f_57_);
return v___x_60_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__11(lean_object* v_h_61_, lean_object* v_t_62_){
_start:
{
lean_object* v___f_63_; 
v___f_63_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__10), 4, 2);
lean_closure_set(v___f_63_, 0, v_h_61_);
lean_closure_set(v___f_63_, 1, v_t_62_);
return v___f_63_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv(lean_object* v_h_64_){
_start:
{
lean_object* v___f_65_; lean_object* v___f_66_; lean_object* v___x_67_; 
lean_inc(v_h_64_);
v___f_65_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__5), 2, 1);
lean_closure_set(v___f_65_, 0, v_h_64_);
v___f_66_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_GeometricV14Carrier_conjEquiv___lam__11), 2, 1);
lean_closure_set(v___f_66_, 0, v_h_64_);
v___x_67_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_67_, 0, v___f_65_);
lean_ctor_set(v___x_67_, 1, v___f_66_);
return v___x_67_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_GeometricV14Carrier_actionKernelM(void){
_start:
{
lean_object* v___x_69_; 
v___x_69_ = lean_box(0);
return v___x_69_;
}
}
static lean_object* _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_rGen(void){
_start:
{
lean_object* v___x_70_; 
v___x_70_ = lp_V14Formalization_V14Formalization_CentralizerN_rotGen;
return v___x_70_;
}
}
static lean_object* _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_sGen(void){
_start:
{
lean_object* v___x_71_; 
v___x_71_ = lp_V14Formalization_V14Formalization_CentralizerN_reflGen;
return v___x_71_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___lam__0(lean_object* v___x_72_, lean_object* v___x_73_, lean_object* v___x_74_, lean_object* v___x_75_, lean_object* v___x_76_, lean_object* v___y_77_, lean_object* v___y_78_){
_start:
{
lean_object* v_toSemiring_79_; lean_object* v___x_80_; lean_object* v___x_81_; lean_object* v___x_82_; lean_object* v___x_83_; lean_object* v_toMul_84_; lean_object* v_toOne_85_; lean_object* v___x_176__overap_86_; lean_object* v___x_87_; 
v_toSemiring_79_ = lean_ctor_get(v___x_72_, 0);
lean_inc_ref(v_toSemiring_79_);
lean_dec_ref(v___x_72_);
v___x_80_ = lp_mathlib_Semiring_toNonUnitalSemiring___redArg(v_toSemiring_79_);
lean_inc(v___x_73_);
v___x_81_ = lp_mathlib_Matrix_nonUnitalNonAssocSemiring___redArg(v___x_80_, v___x_73_);
v___x_82_ = lp_mathlib_Semiring_toNonAssocSemiring___redArg(v_toSemiring_79_);
v___x_83_ = lp_mathlib_Matrix_nonAssocSemiring___redArg(v___x_82_, v___x_73_, v___x_74_);
v_toMul_84_ = lean_ctor_get(v___x_81_, 1);
lean_inc(v_toMul_84_);
lean_dec_ref(v___x_81_);
v_toOne_85_ = lean_ctor_get(v___x_83_, 1);
lean_inc(v_toOne_85_);
lean_dec_ref(v___x_83_);
v___x_176__overap_86_ = lp_mathlib_npowBinRec_go___redArg(v_toMul_84_, v___x_75_, v_toOne_85_, v___x_76_);
v___x_87_ = lean_apply_2(v___x_176__overap_86_, v___y_77_, v___y_78_);
return v___x_87_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___lam__0___boxed(lean_object* v___x_88_, lean_object* v___x_89_, lean_object* v___x_90_, lean_object* v___x_91_, lean_object* v___x_92_, lean_object* v___y_93_, lean_object* v___y_94_){
_start:
{
lean_object* v_res_95_; 
v_res_95_ = lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___lam__0(v___x_88_, v___x_89_, v___x_90_, v___x_91_, v___x_92_, v___y_93_, v___y_94_);
lean_dec(v___x_91_);
return v_res_95_;
}
}
static lean_object* _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__1(void){
_start:
{
lean_object* v___x_98_; lean_object* v___x_99_; 
v___x_98_ = lean_unsigned_to_nat(2u);
v___x_99_ = l_List_finRange(v___x_98_);
return v___x_99_;
}
}
static lean_object* _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__2(void){
_start:
{
lean_object* v___x_100_; lean_object* v___x_101_; 
v___x_100_ = lean_unsigned_to_nat(11u);
v___x_101_ = lp_mathlib_ZMod_commRing(v___x_100_);
return v___x_101_;
}
}
static lean_object* _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__3(void){
_start:
{
lean_object* v___x_102_; lean_object* v___x_103_; lean_object* v___x_104_; lean_object* v___x_105_; lean_object* v___x_106_; lean_object* v___f_107_; 
v___x_102_ = lp_V14Formalization_V14Formalization_CentralizerN_rotGen;
v___x_103_ = lean_unsigned_to_nat(2u);
v___x_104_ = ((lean_object*)(lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__0));
v___x_105_ = lean_obj_once(&lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__1, &lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__1_once, _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__1);
v___x_106_ = lean_obj_once(&lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__2, &lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__2_once, _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__2);
v___f_107_ = lean_alloc_closure((void*)(lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___lam__0___boxed), 7, 5);
lean_closure_set(v___f_107_, 0, v___x_106_);
lean_closure_set(v___f_107_, 1, v___x_105_);
lean_closure_set(v___f_107_, 2, v___x_104_);
lean_closure_set(v___f_107_, 3, v___x_103_);
lean_closure_set(v___f_107_, 4, v___x_102_);
return v___f_107_;
}
}
static lean_object* _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2(void){
_start:
{
lean_object* v___f_108_; 
v___f_108_ = lean_obj_once(&lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__3, &lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__3_once, _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2___closed__3);
return v___f_108_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_GeometricFanoCarrier(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_CentralizerD12(uint8_t builtin);
lean_object* initialize_V14Formalization_V14Formalization_PSLCard(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Projectivization_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_GeneralLinearGroup_Card(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_Index(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Field_ZMod(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_SpecificGroups_Cyclic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_RootsOfUnity_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_NumberTheory_Cyclotomic_PrimitiveRoots(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_RootsOfUnity_PrimitiveRoots(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_PowerBasis(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_Polynomial_Cyclotomic_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_FieldTheory_IntermediateField_Adjoin_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_FieldTheory_IntermediateField_Algebraic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_FieldTheory_KummerPolynomial(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_FieldTheory_Minpoly_Field(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_PrincipalIdealDomain(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_FreeModule_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_FreeModule_Finite_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Basis_VectorSpace(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Charpoly_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Module_LinearMap_End(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Polynomial_Degree_SmallDegree(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Polynomial_EraseLead(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Polynomial_RingDivision(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Polynomial_Div(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Polynomial_FieldDivision(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Polynomial_SpecificDegree(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Rat_Lemmas(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Set_PowersetCard(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Order_Hom_PowersetCard(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Finset_Sort(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Tactic_FinCases(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_FiniteDimensional_Lemmas(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Dimension_OrzechProperty(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Dual_Lemmas(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_Coset_Card(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_Sylow(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_PGroup(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_Index(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Group_Subgroup_Finite(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Nat_Factorization_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Fintype_Card(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Set_Card(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Trace(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Projection(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Group_Idempotent(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Semisimple(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_ExteriorPower_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_ExteriorPower_Basis(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_Charpoly_Coeff(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Charpoly_ToMatrix(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_AdjoinRoot(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_Trace_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Constructions(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_AlgebraTower(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_ToLin(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_Trace(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Polynomial_Eval_Defs(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_Ideal_Quotient_Defs(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_BigOperators_Ring_Finset(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Fintype_BigOperators(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Finset_Card(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_Polynomial_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_GroupWithZero_Associated(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_FiniteDimensional_Lemmas(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Charpoly_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_FieldTheory_Minpoly_Field(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_RingTheory_PrincipalIdealDomain(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_GeometricV14Carrier(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_GeometricFanoCarrier(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_CentralizerD12(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_V14Formalization_V14Formalization_PSLCard(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Projectivization_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_GeneralLinearGroup_Card(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_Index(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Field_ZMod(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_SpecificGroups_Cyclic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_RootsOfUnity_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_NumberTheory_Cyclotomic_PrimitiveRoots(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_RootsOfUnity_PrimitiveRoots(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_PowerBasis(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_Polynomial_Cyclotomic_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_FieldTheory_IntermediateField_Adjoin_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_FieldTheory_IntermediateField_Algebraic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_FieldTheory_KummerPolynomial(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_FieldTheory_Minpoly_Field(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_PrincipalIdealDomain(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_FreeModule_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_FreeModule_Finite_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Basis_VectorSpace(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Charpoly_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Module_LinearMap_End(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Polynomial_Degree_SmallDegree(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Polynomial_EraseLead(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Polynomial_RingDivision(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Polynomial_Div(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Polynomial_FieldDivision(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Polynomial_SpecificDegree(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Rat_Lemmas(builtin);
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
res = initialize_mathlib_Mathlib_LinearAlgebra_FiniteDimensional_Lemmas(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Dimension_OrzechProperty(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Dual_Lemmas(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_Coset_Card(builtin);
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
res = initialize_mathlib_Mathlib_Algebra_Group_Subgroup_Finite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Nat_Factorization_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Fintype_Card(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Set_Card(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Trace(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Projection(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Group_Idempotent(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Semisimple(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_ExteriorPower_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_ExteriorPower_Basis(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_Charpoly_Coeff(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Charpoly_ToMatrix(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_AdjoinRoot(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_Trace_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Dimension_Constructions(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_AlgebraTower(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_ToLin(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Matrix_Trace(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Polynomial_Eval_Defs(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_Ideal_Quotient_Defs(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_BigOperators_Ring_Finset(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Fintype_BigOperators(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Finset_Card(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_Polynomial_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_GroupWithZero_Associated(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_FiniteDimensional_Lemmas(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_LinearAlgebra_Charpoly_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_FieldTheory_Minpoly_Field(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_RingTheory_PrincipalIdealDomain(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
lp_V14Formalization_V14Formalization_GeometricV14Carrier_U = _init_lp_V14Formalization_V14Formalization_GeometricV14Carrier_U();
lean_mark_persistent(lp_V14Formalization_V14Formalization_GeometricV14Carrier_U);
lp_V14Formalization_V14Formalization_GeometricV14Carrier_sigma = _init_lp_V14Formalization_V14Formalization_GeometricV14Carrier_sigma();
lean_mark_persistent(lp_V14Formalization_V14Formalization_GeometricV14Carrier_sigma);
lp_V14Formalization_V14Formalization_GeometricV14Carrier_actionKernelM = _init_lp_V14Formalization_V14Formalization_GeometricV14Carrier_actionKernelM();
lean_mark_persistent(lp_V14Formalization_V14Formalization_GeometricV14Carrier_actionKernelM);
lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_rGen = _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_rGen();
lean_mark_persistent(lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_rGen);
lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_sGen = _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_sGen();
lean_mark_persistent(lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_sGen);
lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2 = _init_lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2();
lean_mark_persistent(lp_V14Formalization___private_V14Formalization_GeometricV14Carrier_0__V14Formalization_GeometricV14Carrier_r2);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
