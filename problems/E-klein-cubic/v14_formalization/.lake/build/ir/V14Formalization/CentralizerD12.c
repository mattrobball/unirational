// Lean compiler output
// Module: V14Formalization.CentralizerD12
// Imports: public import Init public meta import Init public import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup public import Mathlib.LinearAlgebra.Matrix.ProjectiveSpecialLinearGroup public import Mathlib.Data.ZMod.Basic public import Mathlib.Algebra.Field.ZMod public import Mathlib.Data.Nat.Prime.Defs public import Mathlib.GroupTheory.SpecificGroups.Dihedral public import Mathlib.Data.Fintype.BigOperators public import Mathlib.Algebra.Group.Subgroup.Finite public import Mathlib.GroupTheory.OrderOfElement public import Mathlib.GroupTheory.Subgroup.Centralizer
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
lean_object* l_instDecidableEqFin___boxed(lean_object*, lean_object*, lean_object*);
lean_object* l_List_finRange(lean_object*);
lean_object* lp_mathlib_ZMod_commRing(lean_object*);
lean_object* lp_mathlib_instDistribOfSemiring___redArg(lean_object*);
lean_object* lp_mathlib_ZMod_decidableEq___boxed(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_dotProduct___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lp_mathlib_Matrix_decidableEq___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_ZMod_fintype___redArg(lean_object*);
lean_object* lp_mathlib_Matrix_SpecialLinearGroup_instFintypeOfDecidableEq___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lp_mathlib_Fintype_decidableForallFintype___redArg(lean_object*, lean_object*);
lean_object* lp_mathlib_ZMod_instField___redArg(lean_object*);
lean_object* lp_mathlib_Field_toDivisionRing___redArg(lean_object*);
lean_object* lp_mathlib_Ring_toAddGroupWithOne___redArg(lean_object*);
lean_object* lp_mathlib_Matrix_SpecialLinearGroup_instGroup___redArg(lean_object*, lean_object*, lean_object*);
uint8_t lp_mathlib_QuotientGroup_leftRelDecidable___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_Semiring_toNonAssocSemiring___redArg(lean_object*);
lean_object* lp_mathlib_NonAssocSemiring_toAddCommMonoidWithOne___redArg(lean_object*);
lean_object* lp_mathlib_AddMonoid_toAddZeroClass___redArg(lean_object*);
lean_object* lp_mathlib_Equiv_refl(lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
lean_object* l_Fin_cases___redArg(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_Multiset_map___redArg(lean_object*, lean_object*);
lean_object* l_List_foldrTR___redArg(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_Field_toSemifield___redArg(lean_object*);
lean_object* lp_mathlib_Semifield_toDivisionSemiring___redArg(lean_object*);
uint8_t lp_mathlib_ZMod_decidableEq(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_Ring_toAddCommGroup___redArg(lean_object*);
lean_object* lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(lean_object*);
lean_object* lp_mathlib_Semiring_toNonUnitalSemiring___redArg(lean_object*);
lean_object* lp_mathlib_NonUnitalNonAssocSemiring_toDistrib___redArg(lean_object*);
lean_object* lp_mathlib_Multiset_product___redArg(lean_object*, lean_object*);
lean_object* lp_mathlib_Multiset_filter___redArg(lean_object*, lean_object*);
lean_object* lp_mathlib_instMulZeroClassOfSemiring___redArg(lean_object*);
lean_object* lean_nat_shiftr(lean_object*, lean_object*);
lean_object* lean_nat_land(lean_object*, lean_object*);
lean_object* lp_mathlib_ZMod_val(lean_object*, lean_object*);
lean_object* lp_mathlib_QuotientGroup_fintype___redArg(lean_object*, lean_object*);
lean_object* lp_mathlib_Fintype_subtype___redArg(lean_object*);
lean_object* lp_mathlib_AddGroupWithOne_toAddGroup___redArg(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__0(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__0___boxed(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__1___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__2(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__2___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__3(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__3___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__4(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__5(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__5___boxed(lean_object*, lean_object*, lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__1;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4;
static const lean_closure_object lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__0___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__5 = (const lean_object*)&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__5_value;
static const lean_closure_object lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__1___boxed, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__6 = (const lean_object*)&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__6_value;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_sigma;
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___lam__0(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___lam__0___boxed(lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___lam__0___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__0_value;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__1;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__2;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__3;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__4;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1;
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___lam__0(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___lam__0___boxed(lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___lam__0___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__0_value;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__1;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__2;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__2(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__2___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__0___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRot(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRefl(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_CentralizerN_negI_spec__0___lam__0(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_CentralizerN_negI_spec__0___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_CentralizerN_negI_spec__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negI___lam__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negI___lam__0___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negI___lam__1(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negI;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negS___lam__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negS___lam__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___lam__0(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___lam__0(lean_object*, lean_object*, lean_object*);
static lean_once_cell_t lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0;
LEAN_EXPORT lean_object* lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0___redArg(lean_object*, lean_object*);
static lean_once_cell_t lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0;
LEAN_EXPORT lean_object* lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negS___lam__2(lean_object*, lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_CentralizerN_negS___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_CentralizerN_negS___lam__2, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negS___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_CentralizerN_negS___closed__0_value;
LEAN_EXPORT const lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negS = (const lean_object*)&lp_V14Formalization_V14Formalization_CentralizerN_negS___closed__0_value;
LEAN_EXPORT lean_object* lp_V14Formalization_Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_liftsToN(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization___private_V14Formalization_CentralizerD12_0__V14Formalization_CentralizerN_liftsToN_match__1_splitter___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization___private_V14Formalization_CentralizerD12_0__V14Formalization_CentralizerN_liftsToN_match__1_splitter(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__1(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__6___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__4(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_instDecidableEqFin___boxed, .m_arity = 3, .m_num_fixed = 1, .m_objs = {((lean_object*)(((size_t)(2) << 1) | 1))} };
static const lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__0_value;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__1;
static const lean_closure_object lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_mathlib_ZMod_decidableEq___boxed, .m_arity = 3, .m_num_fixed = 1, .m_objs = {((lean_object*)(((size_t)(11) << 1) | 1))} };
static const lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__2 = (const lean_object*)&lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__2_value;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__3;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__4;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__5;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__6;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11;
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__6___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___closed__0;
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_liftMat(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negLift(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_cast___at___00V14Formalization_CentralizerN_rotPt_spec__0(lean_object*);
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__1;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__2;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_rotPt;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_reflPt;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__1;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_rotGen;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__0;
static lean_once_cell_t lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__1;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_reflGen;
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mulCircle1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Quotient_map_u2082___at___00V14Formalization_CentralizerN_dihedralToN_spec__1___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Quotient_map_u2082___at___00V14Formalization_CentralizerN_dihedralToN_spec__1(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0___lam__1(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1___lam__0(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3_spec__4_spec__5(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Finset_sum___at___00dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3_spec__4___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__1(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__2(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__5(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1___lam__0___boxed, .m_arity = 4, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1___closed__0 = (const lean_object*)&lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1___closed__0_value;
LEAN_EXPORT lean_object* lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__0(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__1(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__2(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__3(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___boxed(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Finset_sum___at___00dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3_spec__4(lean_object*, lean_object*, lean_object*);
static const lean_closure_object lp_V14Formalization_V14Formalization_CentralizerN_dihedralToNHom___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToNHom___closed__0 = (const lean_object*)&lp_V14Formalization_V14Formalization_CentralizerN_dihedralToNHom___closed__0_value;
LEAN_EXPORT const lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToNHom = (const lean_object*)&lp_V14Formalization_V14Formalization_CentralizerN_dihedralToNHom___closed__0_value;
LEAN_EXPORT lean_object* lp_V14Formalization_Submonoid_center___at___00Subgroup_center___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__0_spec__0;
LEAN_EXPORT lean_object* lp_V14Formalization_Subgroup_center___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__0;
LEAN_EXPORT lean_object* lp_V14Formalization_Submonoid_centralizer___at___00Subgroup_centralizer___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__1_spec__2(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_Subgroup_centralizer___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__1(lean_object*);
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__0(lean_object* v___y_1_){
_start:
{
lean_internal_panic_unreachable();
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__0___boxed(lean_object* v___y_2_){
_start:
{
lean_object* v_res_3_; 
v_res_3_ = lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__0(v___y_2_);
lean_dec(v___y_2_);
return v_res_3_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__1(lean_object* v___y_4_, lean_object* v___y_5_){
_start:
{
lean_internal_panic_unreachable();
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__1___boxed(lean_object* v___y_6_, lean_object* v___y_7_){
_start:
{
lean_object* v_res_8_; 
v_res_8_ = lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__1(v___y_6_, v___y_7_);
lean_dec(v___y_7_);
lean_dec(v___y_6_);
return v_res_8_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__2(lean_object* v_toZero_9_, lean_object* v___f_10_, lean_object* v___y_11_){
_start:
{
lean_object* v___x_12_; 
v___x_12_ = l_Fin_cases___redArg(v_toZero_9_, v___f_10_, v___y_11_);
return v___x_12_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__2___boxed(lean_object* v_toZero_13_, lean_object* v___f_14_, lean_object* v___y_15_){
_start:
{
lean_object* v_res_16_; 
v_res_16_ = lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__2(v_toZero_13_, v___f_14_, v___y_15_);
lean_dec(v___y_15_);
lean_dec(v_toZero_13_);
return v_res_16_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__3(lean_object* v_toOne_17_, lean_object* v___f_18_, lean_object* v___y_19_){
_start:
{
lean_object* v___x_20_; 
v___x_20_ = l_Fin_cases___redArg(v_toOne_17_, v___f_18_, v___y_19_);
return v___x_20_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__3___boxed(lean_object* v_toOne_21_, lean_object* v___f_22_, lean_object* v___y_23_){
_start:
{
lean_object* v_res_24_; 
v_res_24_ = lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__3(v_toOne_21_, v___f_22_, v___y_23_);
lean_dec(v___y_23_);
lean_dec(v_toOne_21_);
return v_res_24_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__4(lean_object* v___f_25_, lean_object* v___f_26_, lean_object* v___y_27_, lean_object* v___y_28_){
_start:
{
lean_object* v___x_2758__overap_29_; lean_object* v___x_30_; 
v___x_2758__overap_29_ = l_Fin_cases___redArg(v___f_25_, v___f_26_, v___y_27_);
v___x_30_ = lean_apply_1(v___x_2758__overap_29_, v___y_28_);
return v___x_30_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__4___boxed(lean_object* v___f_31_, lean_object* v___f_32_, lean_object* v___y_33_, lean_object* v___y_34_){
_start:
{
lean_object* v_res_35_; 
v_res_35_ = lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__4(v___f_31_, v___f_32_, v___y_33_, v___y_34_);
lean_dec(v___y_33_);
lean_dec_ref(v___f_31_);
return v_res_35_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__5(lean_object* v___x_36_, lean_object* v___f_37_, lean_object* v___y_38_){
_start:
{
lean_object* v___x_39_; 
v___x_39_ = l_Fin_cases___redArg(v___x_36_, v___f_37_, v___y_38_);
return v___x_39_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__5___boxed(lean_object* v___x_40_, lean_object* v___f_41_, lean_object* v___y_42_){
_start:
{
lean_object* v_res_43_; 
v_res_43_ = lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__5(v___x_40_, v___f_41_, v___y_42_);
lean_dec(v___y_42_);
lean_dec(v___x_40_);
return v_res_43_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__0(void){
_start:
{
lean_object* v___x_44_; lean_object* v___x_45_; 
v___x_44_ = lean_unsigned_to_nat(11u);
v___x_45_ = lp_mathlib_ZMod_instField___redArg(v___x_44_);
return v___x_45_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__1(void){
_start:
{
lean_object* v___x_46_; lean_object* v___x_47_; 
v___x_46_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__0, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__0_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__0);
v___x_47_ = lp_mathlib_Field_toSemifield___redArg(v___x_46_);
return v___x_47_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2(void){
_start:
{
lean_object* v___x_48_; lean_object* v___x_49_; 
v___x_48_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__1, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__1_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__1);
v___x_49_ = lp_mathlib_Semifield_toDivisionSemiring___redArg(v___x_48_);
return v___x_49_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3(void){
_start:
{
lean_object* v___x_50_; lean_object* v___x_51_; 
v___x_50_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__0, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__0_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__0);
v___x_51_ = lp_mathlib_Field_toDivisionRing___redArg(v___x_50_);
return v___x_51_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4(void){
_start:
{
lean_object* v___x_52_; 
v___x_52_ = lp_mathlib_Equiv_refl(lean_box(0));
return v___x_52_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat(void){
_start:
{
lean_object* v___x_55_; lean_object* v_toSemiring_56_; lean_object* v___x_57_; lean_object* v_toZero_58_; lean_object* v___x_59_; lean_object* v_toRing_60_; lean_object* v___x_61_; lean_object* v___x_62_; lean_object* v_toNeg_63_; lean_object* v___x_64_; lean_object* v_toAddMonoidWithOne_65_; lean_object* v_toOne_66_; lean_object* v___x_67_; lean_object* v_toFun_68_; lean_object* v___f_69_; lean_object* v___f_70_; lean_object* v___f_71_; lean_object* v___f_72_; lean_object* v___f_73_; lean_object* v___x_74_; lean_object* v___f_75_; lean_object* v___f_76_; lean_object* v___f_77_; lean_object* v___x_78_; 
v___x_55_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2);
v_toSemiring_56_ = lean_ctor_get(v___x_55_, 0);
lean_inc_ref(v_toSemiring_56_);
v___x_57_ = lp_mathlib_instMulZeroClassOfSemiring___redArg(v_toSemiring_56_);
v_toZero_58_ = lean_ctor_get(v___x_57_, 1);
lean_inc_n(v_toZero_58_, 2);
lean_dec_ref(v___x_57_);
v___x_59_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3);
v_toRing_60_ = lean_ctor_get(v___x_59_, 0);
v___x_61_ = lp_mathlib_Ring_toAddCommGroup___redArg(v_toRing_60_);
v___x_62_ = lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(v___x_61_);
lean_dec_ref(v___x_61_);
v_toNeg_63_ = lean_ctor_get(v___x_62_, 1);
lean_inc(v_toNeg_63_);
lean_dec_ref(v___x_62_);
lean_inc_ref(v_toRing_60_);
v___x_64_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_60_);
v_toAddMonoidWithOne_65_ = lean_ctor_get(v___x_64_, 1);
lean_inc_ref(v_toAddMonoidWithOne_65_);
lean_dec_ref(v___x_64_);
v_toOne_66_ = lean_ctor_get(v_toAddMonoidWithOne_65_, 2);
lean_inc_n(v_toOne_66_, 2);
lean_dec_ref(v_toAddMonoidWithOne_65_);
v___x_67_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4);
v_toFun_68_ = lean_ctor_get(v___x_67_, 0);
v___f_69_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__5));
v___f_70_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__6));
v___f_71_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__2___boxed), 3, 2);
lean_closure_set(v___f_71_, 0, v_toZero_58_);
lean_closure_set(v___f_71_, 1, v___f_69_);
v___f_72_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__3___boxed), 3, 2);
lean_closure_set(v___f_72_, 0, v_toOne_66_);
lean_closure_set(v___f_72_, 1, v___f_71_);
v___f_73_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__4___boxed), 4, 2);
lean_closure_set(v___f_73_, 0, v___f_72_);
lean_closure_set(v___f_73_, 1, v___f_70_);
v___x_74_ = lean_apply_1(v_toNeg_63_, v_toOne_66_);
v___f_75_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__5___boxed), 3, 2);
lean_closure_set(v___f_75_, 0, v___x_74_);
lean_closure_set(v___f_75_, 1, v___f_69_);
v___f_76_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__2___boxed), 3, 2);
lean_closure_set(v___f_76_, 0, v_toZero_58_);
lean_closure_set(v___f_76_, 1, v___f_75_);
v___f_77_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__4___boxed), 4, 2);
lean_closure_set(v___f_77_, 0, v___f_76_);
lean_closure_set(v___f_77_, 1, v___f_73_);
lean_inc(v_toFun_68_);
v___x_78_ = lean_apply_1(v_toFun_68_, v___f_77_);
return v___x_78_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_sigma(void){
_start:
{
lean_object* v___x_79_; 
v___x_79_ = lp_V14Formalization_V14Formalization_CentralizerN_Smat;
return v___x_79_;
}
}
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___lam__0(lean_object* v_a_80_){
_start:
{
lean_object* v___x_81_; lean_object* v___x_82_; lean_object* v_toSemiring_83_; lean_object* v___x_84_; lean_object* v_toMonoid_85_; lean_object* v_toAdd_86_; lean_object* v_toNPow_87_; lean_object* v_fst_88_; lean_object* v_snd_89_; lean_object* v___x_90_; lean_object* v_toRing_91_; lean_object* v___x_92_; lean_object* v_toAddMonoidWithOne_93_; lean_object* v_toOne_94_; lean_object* v___x_95_; lean_object* v___x_96_; lean_object* v___x_97_; lean_object* v___x_98_; uint8_t v___x_99_; 
v___x_81_ = lean_unsigned_to_nat(11u);
v___x_82_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2);
v_toSemiring_83_ = lean_ctor_get(v___x_82_, 0);
lean_inc_ref(v_toSemiring_83_);
v___x_84_ = lp_mathlib_instDistribOfSemiring___redArg(v_toSemiring_83_);
v_toMonoid_85_ = lean_ctor_get(v_toSemiring_83_, 1);
v_toAdd_86_ = lean_ctor_get(v___x_84_, 1);
lean_inc(v_toAdd_86_);
lean_dec_ref(v___x_84_);
v_toNPow_87_ = lean_ctor_get(v_toMonoid_85_, 2);
v_fst_88_ = lean_ctor_get(v_a_80_, 0);
lean_inc(v_fst_88_);
v_snd_89_ = lean_ctor_get(v_a_80_, 1);
lean_inc(v_snd_89_);
lean_dec_ref(v_a_80_);
v___x_90_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3);
v_toRing_91_ = lean_ctor_get(v___x_90_, 0);
lean_inc_ref(v_toRing_91_);
v___x_92_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_91_);
v_toAddMonoidWithOne_93_ = lean_ctor_get(v___x_92_, 1);
lean_inc_ref(v_toAddMonoidWithOne_93_);
lean_dec_ref(v___x_92_);
v_toOne_94_ = lean_ctor_get(v_toAddMonoidWithOne_93_, 2);
lean_inc(v_toOne_94_);
lean_dec_ref(v_toAddMonoidWithOne_93_);
v___x_95_ = lean_unsigned_to_nat(2u);
lean_inc_n(v_toNPow_87_, 2);
v___x_96_ = lean_apply_2(v_toNPow_87_, v___x_95_, v_fst_88_);
v___x_97_ = lean_apply_2(v_toNPow_87_, v___x_95_, v_snd_89_);
v___x_98_ = lean_apply_2(v_toAdd_86_, v___x_96_, v___x_97_);
v___x_99_ = lp_mathlib_ZMod_decidableEq(v___x_81_, v___x_98_, v_toOne_94_);
lean_dec(v_toOne_94_);
lean_dec(v___x_98_);
return v___x_99_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___lam__0___boxed(lean_object* v_a_100_){
_start:
{
uint8_t v_res_101_; lean_object* v_r_102_; 
v_res_101_ = lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___lam__0(v_a_100_);
v_r_102_ = lean_box(v_res_101_);
return v_r_102_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__1(void){
_start:
{
lean_object* v___x_104_; lean_object* v___x_105_; 
v___x_104_ = lean_unsigned_to_nat(11u);
v___x_105_ = lp_mathlib_ZMod_fintype___redArg(v___x_104_);
return v___x_105_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__2(void){
_start:
{
lean_object* v___x_106_; lean_object* v___x_107_; 
v___x_106_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__1, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__1_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__1);
v___x_107_ = lp_mathlib_Multiset_product___redArg(v___x_106_, v___x_106_);
return v___x_107_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__3(void){
_start:
{
lean_object* v___x_108_; lean_object* v___f_109_; lean_object* v___x_110_; 
v___x_108_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__2, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__2_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__2);
v___f_109_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__0));
v___x_110_ = lp_mathlib_Multiset_filter___redArg(v___f_109_, v___x_108_);
return v___x_110_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__4(void){
_start:
{
lean_object* v___x_111_; lean_object* v___x_112_; 
v___x_111_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__3);
v___x_112_ = lp_mathlib_Fintype_subtype___redArg(v___x_111_);
return v___x_112_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1(void){
_start:
{
lean_object* v___x_113_; 
v___x_113_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__4, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__4_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__4);
return v___x_113_;
}
}
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___lam__0(lean_object* v_a_114_){
_start:
{
lean_object* v___x_115_; lean_object* v___x_116_; lean_object* v_toSemiring_117_; lean_object* v___x_118_; lean_object* v_toMonoid_119_; lean_object* v_toAdd_120_; lean_object* v_toNPow_121_; lean_object* v_fst_122_; lean_object* v_snd_123_; lean_object* v___x_124_; lean_object* v_toRing_125_; lean_object* v___x_126_; lean_object* v___x_127_; lean_object* v_toNeg_128_; lean_object* v___x_129_; lean_object* v_toAddMonoidWithOne_130_; lean_object* v_toOne_131_; lean_object* v___x_132_; lean_object* v___x_133_; lean_object* v___x_134_; lean_object* v___x_135_; lean_object* v___x_136_; uint8_t v___x_137_; 
v___x_115_ = lean_unsigned_to_nat(11u);
v___x_116_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2);
v_toSemiring_117_ = lean_ctor_get(v___x_116_, 0);
lean_inc_ref(v_toSemiring_117_);
v___x_118_ = lp_mathlib_instDistribOfSemiring___redArg(v_toSemiring_117_);
v_toMonoid_119_ = lean_ctor_get(v_toSemiring_117_, 1);
v_toAdd_120_ = lean_ctor_get(v___x_118_, 1);
lean_inc(v_toAdd_120_);
lean_dec_ref(v___x_118_);
v_toNPow_121_ = lean_ctor_get(v_toMonoid_119_, 2);
v_fst_122_ = lean_ctor_get(v_a_114_, 0);
lean_inc(v_fst_122_);
v_snd_123_ = lean_ctor_get(v_a_114_, 1);
lean_inc(v_snd_123_);
lean_dec_ref(v_a_114_);
v___x_124_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3);
v_toRing_125_ = lean_ctor_get(v___x_124_, 0);
v___x_126_ = lp_mathlib_Ring_toAddCommGroup___redArg(v_toRing_125_);
v___x_127_ = lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(v___x_126_);
lean_dec_ref(v___x_126_);
v_toNeg_128_ = lean_ctor_get(v___x_127_, 1);
lean_inc(v_toNeg_128_);
lean_dec_ref(v___x_127_);
lean_inc_ref(v_toRing_125_);
v___x_129_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_125_);
v_toAddMonoidWithOne_130_ = lean_ctor_get(v___x_129_, 1);
lean_inc_ref(v_toAddMonoidWithOne_130_);
lean_dec_ref(v___x_129_);
v_toOne_131_ = lean_ctor_get(v_toAddMonoidWithOne_130_, 2);
lean_inc(v_toOne_131_);
lean_dec_ref(v_toAddMonoidWithOne_130_);
v___x_132_ = lean_unsigned_to_nat(2u);
lean_inc_n(v_toNPow_121_, 2);
v___x_133_ = lean_apply_2(v_toNPow_121_, v___x_132_, v_fst_122_);
v___x_134_ = lean_apply_2(v_toNPow_121_, v___x_132_, v_snd_123_);
v___x_135_ = lean_apply_2(v_toAdd_120_, v___x_133_, v___x_134_);
v___x_136_ = lean_apply_1(v_toNeg_128_, v_toOne_131_);
v___x_137_ = lp_mathlib_ZMod_decidableEq(v___x_115_, v___x_135_, v___x_136_);
lean_dec(v___x_136_);
lean_dec(v___x_135_);
return v___x_137_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___lam__0___boxed(lean_object* v_a_138_){
_start:
{
uint8_t v_res_139_; lean_object* v_r_140_; 
v_res_139_ = lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___lam__0(v_a_138_);
v_r_140_ = lean_box(v_res_139_);
return v_r_140_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__1(void){
_start:
{
lean_object* v___x_142_; lean_object* v___f_143_; lean_object* v___x_144_; 
v___x_142_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__2, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__2_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__2);
v___f_143_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__0));
v___x_144_ = lp_mathlib_Multiset_filter___redArg(v___f_143_, v___x_142_);
return v___x_144_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__2(void){
_start:
{
lean_object* v___x_145_; lean_object* v___x_146_; 
v___x_145_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__1, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__1_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__1);
v___x_146_ = lp_mathlib_Fintype_subtype___redArg(v___x_145_);
return v___x_146_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1(void){
_start:
{
lean_object* v___x_147_; 
v___x_147_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__2, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__2_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1___closed__2);
return v___x_147_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__2(lean_object* v_snd_148_, lean_object* v___f_149_, lean_object* v___y_150_){
_start:
{
lean_object* v___x_151_; 
v___x_151_ = l_Fin_cases___redArg(v_snd_148_, v___f_149_, v___y_150_);
return v___x_151_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__2___boxed(lean_object* v_snd_152_, lean_object* v___f_153_, lean_object* v___y_154_){
_start:
{
lean_object* v_res_155_; 
v_res_155_ = lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__2(v_snd_152_, v___f_153_, v___y_154_);
lean_dec(v___y_154_);
lean_dec(v_snd_152_);
return v_res_155_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__0(lean_object* v_fst_156_, lean_object* v___f_157_, lean_object* v___y_158_){
_start:
{
lean_object* v___x_159_; 
v___x_159_ = l_Fin_cases___redArg(v_fst_156_, v___f_157_, v___y_158_);
return v___x_159_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__0___boxed(lean_object* v_fst_160_, lean_object* v___f_161_, lean_object* v___y_162_){
_start:
{
lean_object* v_res_163_; 
v_res_163_ = lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__0(v_fst_160_, v___f_161_, v___y_162_);
lean_dec(v___y_162_);
lean_dec(v_fst_160_);
return v_res_163_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRot(lean_object* v_p_164_){
_start:
{
lean_object* v_fst_165_; lean_object* v_snd_166_; lean_object* v___x_167_; lean_object* v_toRing_168_; lean_object* v___x_169_; lean_object* v___x_170_; lean_object* v_toNeg_171_; lean_object* v___x_172_; lean_object* v_toFun_173_; lean_object* v___f_174_; lean_object* v___f_175_; lean_object* v___f_176_; lean_object* v___f_177_; lean_object* v___f_178_; lean_object* v___x_179_; lean_object* v___f_180_; lean_object* v___f_181_; lean_object* v___f_182_; lean_object* v___x_183_; 
v_fst_165_ = lean_ctor_get(v_p_164_, 0);
lean_inc_n(v_fst_165_, 2);
v_snd_166_ = lean_ctor_get(v_p_164_, 1);
lean_inc_n(v_snd_166_, 2);
lean_dec_ref(v_p_164_);
v___x_167_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3);
v_toRing_168_ = lean_ctor_get(v___x_167_, 0);
v___x_169_ = lp_mathlib_Ring_toAddCommGroup___redArg(v_toRing_168_);
v___x_170_ = lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(v___x_169_);
lean_dec_ref(v___x_169_);
v_toNeg_171_ = lean_ctor_get(v___x_170_, 1);
lean_inc(v_toNeg_171_);
lean_dec_ref(v___x_170_);
v___x_172_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4);
v_toFun_173_ = lean_ctor_get(v___x_172_, 0);
v___f_174_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__6));
v___f_175_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__5));
v___f_176_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__2___boxed), 3, 2);
lean_closure_set(v___f_176_, 0, v_snd_166_);
lean_closure_set(v___f_176_, 1, v___f_175_);
v___f_177_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__0___boxed), 3, 2);
lean_closure_set(v___f_177_, 0, v_fst_165_);
lean_closure_set(v___f_177_, 1, v___f_176_);
v___f_178_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__0___boxed), 3, 2);
lean_closure_set(v___f_178_, 0, v_fst_165_);
lean_closure_set(v___f_178_, 1, v___f_175_);
v___x_179_ = lean_apply_1(v_toNeg_171_, v_snd_166_);
v___f_180_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__5___boxed), 3, 2);
lean_closure_set(v___f_180_, 0, v___x_179_);
lean_closure_set(v___f_180_, 1, v___f_178_);
v___f_181_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__4___boxed), 4, 2);
lean_closure_set(v___f_181_, 0, v___f_180_);
lean_closure_set(v___f_181_, 1, v___f_174_);
v___f_182_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__4___boxed), 4, 2);
lean_closure_set(v___f_182_, 0, v___f_177_);
lean_closure_set(v___f_182_, 1, v___f_181_);
lean_inc(v_toFun_173_);
v___x_183_ = lean_apply_1(v_toFun_173_, v___f_182_);
return v___x_183_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mkRefl(lean_object* v_p_184_){
_start:
{
lean_object* v_fst_185_; lean_object* v_snd_186_; lean_object* v___x_187_; lean_object* v_toRing_188_; lean_object* v___x_189_; lean_object* v___x_190_; lean_object* v_toNeg_191_; lean_object* v___x_192_; lean_object* v_toFun_193_; lean_object* v___f_194_; lean_object* v___f_195_; lean_object* v___f_196_; lean_object* v___f_197_; lean_object* v___x_198_; lean_object* v___f_199_; lean_object* v___f_200_; lean_object* v___f_201_; lean_object* v___f_202_; lean_object* v___x_203_; 
v_fst_185_ = lean_ctor_get(v_p_184_, 0);
lean_inc_n(v_fst_185_, 2);
v_snd_186_ = lean_ctor_get(v_p_184_, 1);
lean_inc_n(v_snd_186_, 2);
lean_dec_ref(v_p_184_);
v___x_187_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3);
v_toRing_188_ = lean_ctor_get(v___x_187_, 0);
v___x_189_ = lp_mathlib_Ring_toAddCommGroup___redArg(v_toRing_188_);
v___x_190_ = lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(v___x_189_);
lean_dec_ref(v___x_189_);
v_toNeg_191_ = lean_ctor_get(v___x_190_, 1);
lean_inc(v_toNeg_191_);
lean_dec_ref(v___x_190_);
v___x_192_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4);
v_toFun_193_ = lean_ctor_get(v___x_192_, 0);
v___f_194_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__5));
v___f_195_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__6));
v___f_196_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__2___boxed), 3, 2);
lean_closure_set(v___f_196_, 0, v_snd_186_);
lean_closure_set(v___f_196_, 1, v___f_194_);
v___f_197_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__0___boxed), 3, 2);
lean_closure_set(v___f_197_, 0, v_fst_185_);
lean_closure_set(v___f_197_, 1, v___f_196_);
v___x_198_ = lean_apply_1(v_toNeg_191_, v_fst_185_);
v___f_199_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__5___boxed), 3, 2);
lean_closure_set(v___f_199_, 0, v___x_198_);
lean_closure_set(v___f_199_, 1, v___f_194_);
v___f_200_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_mkRot___lam__2___boxed), 3, 2);
lean_closure_set(v___f_200_, 0, v_snd_186_);
lean_closure_set(v___f_200_, 1, v___f_199_);
v___f_201_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__4___boxed), 4, 2);
lean_closure_set(v___f_201_, 0, v___f_200_);
lean_closure_set(v___f_201_, 1, v___f_195_);
v___f_202_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_Smat___lam__4___boxed), 4, 2);
lean_closure_set(v___f_202_, 0, v___f_197_);
lean_closure_set(v___f_202_, 1, v___f_201_);
lean_inc(v_toFun_193_);
v___x_203_ = lean_apply_1(v_toFun_193_, v___f_202_);
return v___x_203_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_CentralizerN_negI_spec__0___lam__0(lean_object* v_toZero_204_, lean_object* v_d_205_, lean_object* v_i_206_, lean_object* v_j_207_){
_start:
{
uint8_t v___x_208_; 
v___x_208_ = lean_nat_dec_eq(v_i_206_, v_j_207_);
if (v___x_208_ == 0)
{
lean_dec(v_i_206_);
lean_dec_ref(v_d_205_);
lean_inc(v_toZero_204_);
return v_toZero_204_;
}
else
{
lean_object* v___x_209_; 
v___x_209_ = lean_apply_1(v_d_205_, v_i_206_);
return v___x_209_;
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_CentralizerN_negI_spec__0___lam__0___boxed(lean_object* v_toZero_210_, lean_object* v_d_211_, lean_object* v_i_212_, lean_object* v_j_213_){
_start:
{
lean_object* v_res_214_; 
v_res_214_ = lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_CentralizerN_negI_spec__0___lam__0(v_toZero_210_, v_d_211_, v_i_212_, v_j_213_);
lean_dec(v_j_213_);
lean_dec(v_toZero_210_);
return v_res_214_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_CentralizerN_negI_spec__0(lean_object* v_d_215_, lean_object* v_a_216_, lean_object* v_a_217_){
_start:
{
lean_object* v___x_218_; lean_object* v_toSemiring_219_; lean_object* v___x_220_; lean_object* v_toZero_221_; lean_object* v___x_222_; lean_object* v_toFun_223_; lean_object* v___f_224_; lean_object* v___x_225_; 
v___x_218_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2);
v_toSemiring_219_ = lean_ctor_get(v___x_218_, 0);
lean_inc_ref(v_toSemiring_219_);
v___x_220_ = lp_mathlib_instMulZeroClassOfSemiring___redArg(v_toSemiring_219_);
v_toZero_221_ = lean_ctor_get(v___x_220_, 1);
lean_inc(v_toZero_221_);
lean_dec_ref(v___x_220_);
v___x_222_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4);
v_toFun_223_ = lean_ctor_get(v___x_222_, 0);
v___f_224_ = lean_alloc_closure((void*)(lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_CentralizerN_negI_spec__0___lam__0___boxed), 4, 2);
lean_closure_set(v___f_224_, 0, v_toZero_221_);
lean_closure_set(v___f_224_, 1, v_d_215_);
lean_inc(v_toFun_223_);
v___x_225_ = lean_apply_3(v_toFun_223_, v___f_224_, v_a_216_, v_a_217_);
return v___x_225_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negI___lam__0(lean_object* v_toOne_226_, lean_object* v_x_227_){
_start:
{
lean_inc(v_toOne_226_);
return v_toOne_226_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negI___lam__0___boxed(lean_object* v_toOne_228_, lean_object* v_x_229_){
_start:
{
lean_object* v_res_230_; 
v_res_230_ = lp_V14Formalization_V14Formalization_CentralizerN_negI___lam__0(v_toOne_228_, v_x_229_);
lean_dec(v_x_229_);
lean_dec(v_toOne_228_);
return v_res_230_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negI___lam__1(lean_object* v___f_231_, lean_object* v_toNeg_232_, lean_object* v___y_233_, lean_object* v___y_234_){
_start:
{
lean_object* v___x_235_; lean_object* v___x_236_; 
v___x_235_ = lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_CentralizerN_negI_spec__0(v___f_231_, v___y_233_, v___y_234_);
v___x_236_ = lean_apply_1(v_toNeg_232_, v___x_235_);
return v___x_236_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_negI(void){
_start:
{
lean_object* v___x_237_; lean_object* v_toRing_238_; lean_object* v___x_239_; lean_object* v___x_240_; lean_object* v_toNeg_241_; lean_object* v___x_242_; lean_object* v_toAddMonoidWithOne_243_; lean_object* v_toOne_244_; lean_object* v___f_245_; lean_object* v___f_246_; 
v___x_237_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3);
v_toRing_238_ = lean_ctor_get(v___x_237_, 0);
v___x_239_ = lp_mathlib_Ring_toAddCommGroup___redArg(v_toRing_238_);
v___x_240_ = lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(v___x_239_);
lean_dec_ref(v___x_239_);
v_toNeg_241_ = lean_ctor_get(v___x_240_, 1);
lean_inc(v_toNeg_241_);
lean_dec_ref(v___x_240_);
lean_inc_ref(v_toRing_238_);
v___x_242_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_238_);
v_toAddMonoidWithOne_243_ = lean_ctor_get(v___x_242_, 1);
lean_inc_ref(v_toAddMonoidWithOne_243_);
lean_dec_ref(v___x_242_);
v_toOne_244_ = lean_ctor_get(v_toAddMonoidWithOne_243_, 2);
lean_inc(v_toOne_244_);
lean_dec_ref(v_toAddMonoidWithOne_243_);
v___f_245_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_negI___lam__0___boxed), 2, 1);
lean_closure_set(v___f_245_, 0, v_toOne_244_);
v___f_246_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_negI___lam__1), 4, 2);
lean_closure_set(v___f_246_, 0, v___f_245_);
lean_closure_set(v___f_246_, 1, v_toNeg_241_);
return v___f_246_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negS___lam__0(lean_object* v___y_247_, lean_object* v_j_248_){
_start:
{
lean_object* v___x_1553__overap_249_; lean_object* v___x_250_; 
v___x_1553__overap_249_ = lp_V14Formalization_V14Formalization_CentralizerN_Smat;
v___x_250_ = lean_apply_2(v___x_1553__overap_249_, v_j_248_, v___y_247_);
return v___x_250_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negS___lam__1(lean_object* v___y_251_, lean_object* v_j_252_){
_start:
{
lean_object* v___x_1555__overap_253_; lean_object* v___x_254_; 
v___x_1555__overap_253_ = lp_V14Formalization_V14Formalization_CentralizerN_negI;
v___x_254_ = lean_apply_2(v___x_1555__overap_253_, v___y_251_, v_j_252_);
return v___x_254_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___lam__0(lean_object* v_v_255_, lean_object* v_w_256_, lean_object* v_toMul_257_, lean_object* v_i_258_){
_start:
{
lean_object* v___x_259_; lean_object* v___x_260_; lean_object* v___x_261_; 
lean_inc(v_i_258_);
v___x_259_ = lean_apply_1(v_v_255_, v_i_258_);
v___x_260_ = lean_apply_1(v_w_256_, v_i_258_);
v___x_261_ = lean_apply_2(v_toMul_257_, v___x_259_, v___x_260_);
return v___x_261_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___lam__0(lean_object* v_toAdd_262_, lean_object* v_x1_263_, lean_object* v_x2_264_){
_start:
{
lean_object* v___x_265_; 
v___x_265_ = lean_apply_2(v_toAdd_262_, v_x1_263_, v_x2_264_);
return v___x_265_;
}
}
static lean_object* _init_lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0(void){
_start:
{
lean_object* v___x_266_; lean_object* v___x_267_; 
v___x_266_ = lean_unsigned_to_nat(11u);
v___x_267_ = lp_mathlib_ZMod_commRing(v___x_266_);
return v___x_267_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1(lean_object* v_s_268_){
_start:
{
lean_object* v___x_269_; lean_object* v_toSemiring_270_; lean_object* v_toAddCommMonoid_271_; lean_object* v___x_272_; lean_object* v_toZero_273_; lean_object* v_toAdd_274_; lean_object* v___f_275_; lean_object* v___x_276_; 
v___x_269_ = lean_obj_once(&lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0, &lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0_once, _init_lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0);
v_toSemiring_270_ = lean_ctor_get(v___x_269_, 0);
v_toAddCommMonoid_271_ = lean_ctor_get(v_toSemiring_270_, 0);
v___x_272_ = lp_mathlib_AddMonoid_toAddZeroClass___redArg(v_toAddCommMonoid_271_);
v_toZero_273_ = lean_ctor_get(v___x_272_, 0);
lean_inc(v_toZero_273_);
v_toAdd_274_ = lean_ctor_get(v___x_272_, 1);
lean_inc(v_toAdd_274_);
lean_dec_ref(v___x_272_);
v___f_275_ = lean_alloc_closure((void*)(lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___lam__0), 3, 1);
lean_closure_set(v___f_275_, 0, v_toAdd_274_);
v___x_276_ = l_List_foldrTR___redArg(v___f_275_, v_toZero_273_, v_s_268_);
return v___x_276_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0___redArg(lean_object* v_s_277_, lean_object* v_f_278_){
_start:
{
lean_object* v___x_279_; lean_object* v___x_280_; 
v___x_279_ = lp_mathlib_Multiset_map___redArg(v_f_278_, v_s_277_);
v___x_280_ = lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1(v___x_279_);
return v___x_280_;
}
}
static lean_object* _init_lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0(void){
_start:
{
lean_object* v___x_281_; lean_object* v___x_282_; 
v___x_281_ = lean_unsigned_to_nat(2u);
v___x_282_ = l_List_finRange(v___x_281_);
return v___x_282_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0(lean_object* v_v_283_, lean_object* v_w_284_){
_start:
{
lean_object* v___x_285_; lean_object* v_toSemiring_286_; lean_object* v___x_287_; lean_object* v_toMul_288_; lean_object* v___f_289_; lean_object* v___x_290_; lean_object* v___x_291_; 
v___x_285_ = lean_obj_once(&lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0, &lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0_once, _init_lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0);
v_toSemiring_286_ = lean_ctor_get(v___x_285_, 0);
lean_inc_ref(v_toSemiring_286_);
v___x_287_ = lp_mathlib_instDistribOfSemiring___redArg(v_toSemiring_286_);
v_toMul_288_ = lean_ctor_get(v___x_287_, 0);
lean_inc(v_toMul_288_);
lean_dec_ref(v___x_287_);
v___f_289_ = lean_alloc_closure((void*)(lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___lam__0), 4, 3);
lean_closure_set(v___f_289_, 0, v_v_283_);
lean_closure_set(v___f_289_, 1, v_w_284_);
lean_closure_set(v___f_289_, 2, v_toMul_288_);
v___x_290_ = lean_obj_once(&lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0, &lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0_once, _init_lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0);
v___x_291_ = lp_V14Formalization_Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0___redArg(v___x_290_, v___f_289_);
return v___x_291_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negS___lam__2(lean_object* v___y_292_, lean_object* v___y_293_){
_start:
{
lean_object* v___f_294_; lean_object* v___f_295_; lean_object* v___x_296_; 
v___f_294_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_negS___lam__0), 2, 1);
lean_closure_set(v___f_294_, 0, v___y_293_);
v___f_295_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_negS___lam__1), 2, 1);
lean_closure_set(v___f_295_, 0, v___y_292_);
v___x_296_ = lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0(v___f_295_, v___f_294_);
return v___x_296_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0(lean_object* v_00_u03b9_299_, lean_object* v_s_300_, lean_object* v_f_301_){
_start:
{
lean_object* v___x_302_; 
v___x_302_ = lp_V14Formalization_Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0___redArg(v_s_300_, v_f_301_);
return v___x_302_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_liftsToN(lean_object* v_x_303_){
_start:
{
if (lean_obj_tag(v_x_303_) == 0)
{
lean_object* v_val_304_; lean_object* v___x_305_; 
v_val_304_ = lean_ctor_get(v_x_303_, 0);
lean_inc(v_val_304_);
lean_dec_ref_known(v_x_303_, 1);
v___x_305_ = lp_V14Formalization_V14Formalization_CentralizerN_mkRot(v_val_304_);
return v___x_305_;
}
else
{
lean_object* v_val_306_; lean_object* v___x_307_; 
v_val_306_ = lean_ctor_get(v_x_303_, 0);
lean_inc(v_val_306_);
lean_dec_ref_known(v_x_303_, 1);
v___x_307_ = lp_V14Formalization_V14Formalization_CentralizerN_mkRefl(v_val_306_);
return v___x_307_;
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization___private_V14Formalization_CentralizerD12_0__V14Formalization_CentralizerN_liftsToN_match__1_splitter___redArg(lean_object* v_x_308_, lean_object* v_h__1_309_, lean_object* v_h__2_310_){
_start:
{
if (lean_obj_tag(v_x_308_) == 0)
{
lean_object* v_val_311_; lean_object* v___x_312_; 
lean_dec(v_h__2_310_);
v_val_311_ = lean_ctor_get(v_x_308_, 0);
lean_inc(v_val_311_);
lean_dec_ref_known(v_x_308_, 1);
v___x_312_ = lean_apply_1(v_h__1_309_, v_val_311_);
return v___x_312_;
}
else
{
lean_object* v_val_313_; lean_object* v___x_314_; 
lean_dec(v_h__1_309_);
v_val_313_ = lean_ctor_get(v_x_308_, 0);
lean_inc(v_val_313_);
lean_dec_ref_known(v_x_308_, 1);
v___x_314_ = lean_apply_1(v_h__2_310_, v_val_313_);
return v___x_314_;
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization___private_V14Formalization_CentralizerD12_0__V14Formalization_CentralizerN_liftsToN_match__1_splitter(lean_object* v_motive_315_, lean_object* v_x_316_, lean_object* v_h__1_317_, lean_object* v_h__2_318_){
_start:
{
if (lean_obj_tag(v_x_316_) == 0)
{
lean_object* v_val_319_; lean_object* v___x_320_; 
lean_dec(v_h__2_318_);
v_val_319_ = lean_ctor_get(v_x_316_, 0);
lean_inc(v_val_319_);
lean_dec_ref_known(v_x_316_, 1);
v___x_320_ = lean_apply_1(v_h__1_317_, v_val_319_);
return v___x_320_;
}
else
{
lean_object* v_val_321_; lean_object* v___x_322_; 
lean_dec(v_h__1_317_);
v_val_321_ = lean_ctor_get(v_x_316_, 0);
lean_inc(v_val_321_);
lean_dec_ref_known(v_x_316_, 1);
v___x_322_ = lean_apply_1(v_h__2_318_, v_val_321_);
return v___x_322_;
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__0(lean_object* v_a_323_, lean_object* v___y_324_, lean_object* v_j_325_){
_start:
{
lean_object* v___x_326_; 
v___x_326_ = lean_apply_2(v_a_323_, v_j_325_, v___y_324_);
return v___x_326_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__1(lean_object* v_a_327_, lean_object* v___y_328_, lean_object* v_j_329_){
_start:
{
lean_object* v___x_330_; 
v___x_330_ = lean_apply_2(v_a_327_, v___y_328_, v_j_329_);
return v___x_330_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__2(lean_object* v_a_331_, lean_object* v_a_332_, lean_object* v___x_333_, lean_object* v_toMul_334_, lean_object* v_toAddCommMonoid_335_, lean_object* v___y_336_, lean_object* v___y_337_){
_start:
{
lean_object* v___f_338_; lean_object* v___f_339_; lean_object* v___x_340_; 
v___f_338_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__0), 3, 2);
lean_closure_set(v___f_338_, 0, v_a_331_);
lean_closure_set(v___f_338_, 1, v___y_337_);
v___f_339_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__1), 3, 2);
lean_closure_set(v___f_339_, 0, v_a_332_);
lean_closure_set(v___f_339_, 1, v___y_336_);
v___x_340_ = lp_mathlib_dotProduct___redArg(v___x_333_, v_toMul_334_, v_toAddCommMonoid_335_, v___f_339_, v___f_338_);
return v___x_340_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__2___boxed(lean_object* v_a_341_, lean_object* v_a_342_, lean_object* v___x_343_, lean_object* v_toMul_344_, lean_object* v_toAddCommMonoid_345_, lean_object* v___y_346_, lean_object* v___y_347_){
_start:
{
lean_object* v_res_348_; 
v_res_348_ = lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__2(v_a_341_, v_a_342_, v___x_343_, v_toMul_344_, v_toAddCommMonoid_345_, v___y_346_, v___y_347_);
lean_dec_ref(v_toAddCommMonoid_345_);
return v_res_348_;
}
}
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__6(lean_object* v___x_349_, lean_object* v_a_350_, lean_object* v___x_351_, lean_object* v___x_352_, lean_object* v_a_353_){
_start:
{
lean_object* v_toSemiring_354_; lean_object* v___x_355_; lean_object* v_toMul_356_; lean_object* v_toAddCommMonoid_357_; lean_object* v___f_358_; lean_object* v___f_359_; uint8_t v___x_360_; 
v_toSemiring_354_ = lean_ctor_get(v___x_349_, 0);
lean_inc_ref_n(v_toSemiring_354_, 2);
lean_dec_ref(v___x_349_);
v___x_355_ = lp_mathlib_instDistribOfSemiring___redArg(v_toSemiring_354_);
v_toMul_356_ = lean_ctor_get(v___x_355_, 0);
lean_inc_n(v_toMul_356_, 2);
lean_dec_ref(v___x_355_);
v_toAddCommMonoid_357_ = lean_ctor_get(v_toSemiring_354_, 0);
lean_inc_ref_n(v_toAddCommMonoid_357_, 2);
lean_dec_ref(v_toSemiring_354_);
lean_inc_n(v___x_351_, 3);
lean_inc_ref(v_a_350_);
lean_inc_ref(v_a_353_);
v___f_358_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__2___boxed), 7, 5);
lean_closure_set(v___f_358_, 0, v_a_353_);
lean_closure_set(v___f_358_, 1, v_a_350_);
lean_closure_set(v___f_358_, 2, v___x_351_);
lean_closure_set(v___f_358_, 3, v_toMul_356_);
lean_closure_set(v___f_358_, 4, v_toAddCommMonoid_357_);
v___f_359_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__2___boxed), 7, 5);
lean_closure_set(v___f_359_, 0, v_a_350_);
lean_closure_set(v___f_359_, 1, v_a_353_);
lean_closure_set(v___f_359_, 2, v___x_351_);
lean_closure_set(v___f_359_, 3, v_toMul_356_);
lean_closure_set(v___f_359_, 4, v_toAddCommMonoid_357_);
v___x_360_ = lp_mathlib_Matrix_decidableEq___redArg(v___x_352_, v___x_351_, v___x_351_, v___f_359_, v___f_358_);
return v___x_360_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__6___boxed(lean_object* v___x_361_, lean_object* v_a_362_, lean_object* v___x_363_, lean_object* v___x_364_, lean_object* v_a_365_){
_start:
{
uint8_t v_res_366_; lean_object* v_r_367_; 
v_res_366_ = lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__6(v___x_361_, v_a_362_, v___x_363_, v___x_364_, v_a_365_);
v_r_367_ = lean_box(v_res_366_);
return v_r_367_;
}
}
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__3(lean_object* v___x_368_, lean_object* v___x_369_, lean_object* v___x_370_, lean_object* v___x_371_, lean_object* v_a_372_){
_start:
{
lean_object* v___f_373_; uint8_t v___x_374_; 
v___f_373_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__6___boxed), 5, 4);
lean_closure_set(v___f_373_, 0, v___x_368_);
lean_closure_set(v___f_373_, 1, v_a_372_);
lean_closure_set(v___f_373_, 2, v___x_369_);
lean_closure_set(v___f_373_, 3, v___x_370_);
v___x_374_ = lp_mathlib_Fintype_decidableForallFintype___redArg(v___f_373_, v___x_371_);
return v___x_374_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__3___boxed(lean_object* v___x_375_, lean_object* v___x_376_, lean_object* v___x_377_, lean_object* v___x_378_, lean_object* v_a_379_){
_start:
{
uint8_t v_res_380_; lean_object* v_r_381_; 
v_res_380_ = lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__3(v___x_375_, v___x_376_, v___x_377_, v___x_378_, v_a_379_);
v_r_381_ = lean_box(v_res_380_);
return v_r_381_;
}
}
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__4(lean_object* v___x_382_, lean_object* v___f_383_, lean_object* v_a_384_, lean_object* v_b_385_){
_start:
{
uint8_t v___x_386_; 
v___x_386_ = lp_mathlib_QuotientGroup_leftRelDecidable___redArg(v___x_382_, v___f_383_, v_a_384_, v_b_385_);
return v___x_386_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__4___boxed(lean_object* v___x_387_, lean_object* v___f_388_, lean_object* v_a_389_, lean_object* v_b_390_){
_start:
{
uint8_t v_res_391_; lean_object* v_r_392_; 
v_res_391_ = lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__4(v___x_387_, v___f_388_, v_a_389_, v_b_390_);
lean_dec_ref(v___x_387_);
v_r_392_ = lean_box(v_res_391_);
return v_r_392_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__1(void){
_start:
{
lean_object* v___x_395_; lean_object* v___x_396_; lean_object* v___x_397_; lean_object* v___x_398_; 
v___x_395_ = lean_obj_once(&lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0, &lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0_once, _init_lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0);
v___x_396_ = lean_obj_once(&lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0, &lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0_once, _init_lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0);
v___x_397_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__0));
v___x_398_ = lp_mathlib_Matrix_SpecialLinearGroup_instGroup___redArg(v___x_397_, v___x_396_, v___x_395_);
return v___x_398_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__3(void){
_start:
{
lean_object* v___x_401_; lean_object* v___x_402_; lean_object* v___x_403_; lean_object* v___x_404_; lean_object* v___x_405_; lean_object* v___x_406_; 
v___x_401_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__2));
v___x_402_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__1, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__1_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1___closed__1);
v___x_403_ = lean_obj_once(&lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0, &lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0_once, _init_lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0);
v___x_404_ = lean_obj_once(&lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0, &lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0_once, _init_lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0);
v___x_405_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__0));
v___x_406_ = lp_mathlib_Matrix_SpecialLinearGroup_instFintypeOfDecidableEq___redArg(v___x_405_, v___x_404_, v___x_403_, v___x_402_, v___x_401_);
return v___x_406_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__4(void){
_start:
{
lean_object* v___x_407_; lean_object* v___x_408_; lean_object* v___x_409_; lean_object* v___x_410_; lean_object* v___f_411_; 
v___x_407_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__3);
v___x_408_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__2));
v___x_409_ = lean_obj_once(&lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0, &lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0_once, _init_lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0);
v___x_410_ = lean_obj_once(&lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0, &lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0_once, _init_lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0);
v___f_411_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__3___boxed), 5, 4);
lean_closure_set(v___f_411_, 0, v___x_410_);
lean_closure_set(v___f_411_, 1, v___x_409_);
lean_closure_set(v___f_411_, 2, v___x_408_);
lean_closure_set(v___f_411_, 3, v___x_407_);
return v___f_411_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__5(void){
_start:
{
lean_object* v___f_412_; lean_object* v___x_413_; lean_object* v___f_414_; 
v___f_412_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__4, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__4_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__4);
v___x_413_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__1, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__1_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__1);
v___f_414_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__4___boxed), 4, 2);
lean_closure_set(v___f_414_, 0, v___x_413_);
lean_closure_set(v___f_414_, 1, v___f_412_);
return v___f_414_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__6(void){
_start:
{
lean_object* v___f_415_; lean_object* v___x_416_; lean_object* v___x_417_; 
v___f_415_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__5, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__5_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__5);
v___x_416_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__3);
v___x_417_ = lp_mathlib_QuotientGroup_fintype___redArg(v___x_416_, v___f_415_);
return v___x_417_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11(void){
_start:
{
lean_object* v___x_418_; 
v___x_418_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__6, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__6_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__6);
return v___x_418_;
}
}
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__6(lean_object* v___x_419_, lean_object* v___x_420_, lean_object* v_a_421_, lean_object* v___x_422_, lean_object* v_a_423_){
_start:
{
lean_object* v_toSemiring_424_; lean_object* v___x_425_; lean_object* v_toMul_426_; lean_object* v_toAddCommMonoid_427_; lean_object* v___x_428_; lean_object* v___f_429_; lean_object* v___f_430_; uint8_t v___x_431_; 
v_toSemiring_424_ = lean_ctor_get(v___x_419_, 0);
lean_inc_ref_n(v_toSemiring_424_, 2);
lean_dec_ref(v___x_419_);
v___x_425_ = lp_mathlib_instDistribOfSemiring___redArg(v_toSemiring_424_);
v_toMul_426_ = lean_ctor_get(v___x_425_, 0);
lean_inc_n(v_toMul_426_, 2);
lean_dec_ref(v___x_425_);
v_toAddCommMonoid_427_ = lean_ctor_get(v_toSemiring_424_, 0);
lean_inc_ref_n(v_toAddCommMonoid_427_, 2);
lean_dec_ref(v_toSemiring_424_);
v___x_428_ = lean_alloc_closure((void*)(lp_mathlib_ZMod_decidableEq___boxed), 3, 1);
lean_closure_set(v___x_428_, 0, v___x_420_);
lean_inc_n(v___x_422_, 3);
lean_inc_ref(v_a_421_);
lean_inc_ref(v_a_423_);
v___f_429_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__2___boxed), 7, 5);
lean_closure_set(v___f_429_, 0, v_a_423_);
lean_closure_set(v___f_429_, 1, v_a_421_);
lean_closure_set(v___f_429_, 2, v___x_422_);
lean_closure_set(v___f_429_, 3, v_toMul_426_);
lean_closure_set(v___f_429_, 4, v_toAddCommMonoid_427_);
v___f_430_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___lam__2___boxed), 7, 5);
lean_closure_set(v___f_430_, 0, v_a_421_);
lean_closure_set(v___f_430_, 1, v_a_423_);
lean_closure_set(v___f_430_, 2, v___x_422_);
lean_closure_set(v___f_430_, 3, v_toMul_426_);
lean_closure_set(v___f_430_, 4, v_toAddCommMonoid_427_);
v___x_431_ = lp_mathlib_Matrix_decidableEq___redArg(v___x_428_, v___x_422_, v___x_422_, v___f_430_, v___f_429_);
return v___x_431_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__6___boxed(lean_object* v___x_432_, lean_object* v___x_433_, lean_object* v_a_434_, lean_object* v___x_435_, lean_object* v_a_436_){
_start:
{
uint8_t v_res_437_; lean_object* v_r_438_; 
v_res_437_ = lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__6(v___x_432_, v___x_433_, v_a_434_, v___x_435_, v_a_436_);
v_r_438_ = lean_box(v_res_437_);
return v_r_438_;
}
}
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__0(lean_object* v___x_439_, lean_object* v___x_440_, lean_object* v___x_441_, lean_object* v___x_442_, lean_object* v_a_443_){
_start:
{
lean_object* v___f_444_; lean_object* v___x_445_; lean_object* v___x_446_; lean_object* v___x_447_; uint8_t v___x_448_; 
lean_inc(v___x_441_);
lean_inc(v___x_440_);
lean_inc_ref(v___x_439_);
v___f_444_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__6___boxed), 5, 4);
lean_closure_set(v___f_444_, 0, v___x_439_);
lean_closure_set(v___f_444_, 1, v___x_440_);
lean_closure_set(v___f_444_, 2, v_a_443_);
lean_closure_set(v___f_444_, 3, v___x_441_);
v___x_445_ = lp_mathlib_ZMod_fintype___redArg(v___x_440_);
v___x_446_ = lean_alloc_closure((void*)(lp_mathlib_ZMod_decidableEq___boxed), 3, 1);
lean_closure_set(v___x_446_, 0, v___x_440_);
v___x_447_ = lp_mathlib_Matrix_SpecialLinearGroup_instFintypeOfDecidableEq___redArg(v___x_442_, v___x_441_, v___x_439_, v___x_445_, v___x_446_);
v___x_448_ = lp_mathlib_Fintype_decidableForallFintype___redArg(v___f_444_, v___x_447_);
return v___x_448_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__0___boxed(lean_object* v___x_449_, lean_object* v___x_450_, lean_object* v___x_451_, lean_object* v___x_452_, lean_object* v_a_453_){
_start:
{
uint8_t v_res_454_; lean_object* v_r_455_; 
v_res_454_ = lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__0(v___x_449_, v___x_450_, v___x_451_, v___x_452_, v_a_453_);
v_r_455_ = lean_box(v_res_454_);
return v_r_455_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___closed__0(void){
_start:
{
lean_object* v___x_456_; lean_object* v___x_457_; lean_object* v___x_458_; lean_object* v___x_459_; lean_object* v___f_460_; 
v___x_456_ = ((lean_object*)(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__0));
v___x_457_ = lean_obj_once(&lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0, &lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0_once, _init_lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0);
v___x_458_ = lean_unsigned_to_nat(11u);
v___x_459_ = lean_obj_once(&lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0, &lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0_once, _init_lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0);
v___f_460_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___lam__0___boxed), 5, 4);
lean_closure_set(v___f_460_, 0, v___x_459_);
lean_closure_set(v___f_460_, 1, v___x_458_);
lean_closure_set(v___f_460_, 2, v___x_457_);
lean_closure_set(v___f_460_, 3, v___x_456_);
return v___f_460_;
}
}
LEAN_EXPORT uint8_t lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11(lean_object* v_a_461_, lean_object* v_b_462_){
_start:
{
lean_object* v___f_463_; lean_object* v___x_464_; uint8_t v___x_465_; 
v___f_463_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___closed__0, &lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___closed__0_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___closed__0);
v___x_464_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__1, &lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__1_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11___closed__1);
v___x_465_ = lp_mathlib_QuotientGroup_leftRelDecidable___redArg(v___x_464_, v___f_463_, v_a_461_, v_b_462_);
return v___x_465_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11___boxed(lean_object* v_a_466_, lean_object* v_b_467_){
_start:
{
uint8_t v_res_468_; lean_object* v_r_469_; 
v_res_468_ = lp_V14Formalization_V14Formalization_CentralizerN_instDecidableEqPSL2F11(v_a_466_, v_b_467_);
v_r_469_ = lean_box(v_res_468_);
return v_r_469_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_liftMat(lean_object* v_x_470_){
_start:
{
if (lean_obj_tag(v_x_470_) == 0)
{
lean_object* v_val_471_; lean_object* v___x_472_; 
v_val_471_ = lean_ctor_get(v_x_470_, 0);
lean_inc(v_val_471_);
lean_dec_ref_known(v_x_470_, 1);
v___x_472_ = lp_V14Formalization_V14Formalization_CentralizerN_mkRot(v_val_471_);
return v___x_472_;
}
else
{
lean_object* v_val_473_; lean_object* v___x_474_; 
v_val_473_ = lean_ctor_get(v_x_470_, 0);
lean_inc(v_val_473_);
lean_dec_ref_known(v_x_470_, 1);
v___x_474_ = lp_V14Formalization_V14Formalization_CentralizerN_mkRefl(v_val_473_);
return v___x_474_;
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_negLift(lean_object* v_x_475_){
_start:
{
if (lean_obj_tag(v_x_475_) == 0)
{
lean_object* v_val_476_; lean_object* v___x_478_; uint8_t v_isShared_479_; uint8_t v_isSharedCheck_499_; 
v_val_476_ = lean_ctor_get(v_x_475_, 0);
v_isSharedCheck_499_ = !lean_is_exclusive(v_x_475_);
if (v_isSharedCheck_499_ == 0)
{
v___x_478_ = v_x_475_;
v_isShared_479_ = v_isSharedCheck_499_;
goto v_resetjp_477_;
}
else
{
lean_inc(v_val_476_);
lean_dec(v_x_475_);
v___x_478_ = lean_box(0);
v_isShared_479_ = v_isSharedCheck_499_;
goto v_resetjp_477_;
}
v_resetjp_477_:
{
lean_object* v___x_480_; lean_object* v_toRing_481_; lean_object* v___x_482_; lean_object* v___x_483_; lean_object* v_toNeg_484_; lean_object* v_fst_485_; lean_object* v_snd_486_; lean_object* v___x_488_; uint8_t v_isShared_489_; uint8_t v_isSharedCheck_498_; 
v___x_480_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3);
v_toRing_481_ = lean_ctor_get(v___x_480_, 0);
v___x_482_ = lp_mathlib_Ring_toAddCommGroup___redArg(v_toRing_481_);
v___x_483_ = lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(v___x_482_);
lean_dec_ref(v___x_482_);
v_toNeg_484_ = lean_ctor_get(v___x_483_, 1);
lean_inc(v_toNeg_484_);
lean_dec_ref(v___x_483_);
v_fst_485_ = lean_ctor_get(v_val_476_, 0);
v_snd_486_ = lean_ctor_get(v_val_476_, 1);
v_isSharedCheck_498_ = !lean_is_exclusive(v_val_476_);
if (v_isSharedCheck_498_ == 0)
{
v___x_488_ = v_val_476_;
v_isShared_489_ = v_isSharedCheck_498_;
goto v_resetjp_487_;
}
else
{
lean_inc(v_snd_486_);
lean_inc(v_fst_485_);
lean_dec(v_val_476_);
v___x_488_ = lean_box(0);
v_isShared_489_ = v_isSharedCheck_498_;
goto v_resetjp_487_;
}
v_resetjp_487_:
{
lean_object* v___x_490_; lean_object* v___x_491_; lean_object* v___x_493_; 
lean_inc(v_toNeg_484_);
v___x_490_ = lean_apply_1(v_toNeg_484_, v_fst_485_);
v___x_491_ = lean_apply_1(v_toNeg_484_, v_snd_486_);
if (v_isShared_489_ == 0)
{
lean_ctor_set(v___x_488_, 1, v___x_491_);
lean_ctor_set(v___x_488_, 0, v___x_490_);
v___x_493_ = v___x_488_;
goto v_reusejp_492_;
}
else
{
lean_object* v_reuseFailAlloc_497_; 
v_reuseFailAlloc_497_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_497_, 0, v___x_490_);
lean_ctor_set(v_reuseFailAlloc_497_, 1, v___x_491_);
v___x_493_ = v_reuseFailAlloc_497_;
goto v_reusejp_492_;
}
v_reusejp_492_:
{
lean_object* v___x_495_; 
if (v_isShared_479_ == 0)
{
lean_ctor_set(v___x_478_, 0, v___x_493_);
v___x_495_ = v___x_478_;
goto v_reusejp_494_;
}
else
{
lean_object* v_reuseFailAlloc_496_; 
v_reuseFailAlloc_496_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_496_, 0, v___x_493_);
v___x_495_ = v_reuseFailAlloc_496_;
goto v_reusejp_494_;
}
v_reusejp_494_:
{
return v___x_495_;
}
}
}
}
}
else
{
lean_object* v_val_500_; lean_object* v___x_502_; uint8_t v_isShared_503_; uint8_t v_isSharedCheck_523_; 
v_val_500_ = lean_ctor_get(v_x_475_, 0);
v_isSharedCheck_523_ = !lean_is_exclusive(v_x_475_);
if (v_isSharedCheck_523_ == 0)
{
v___x_502_ = v_x_475_;
v_isShared_503_ = v_isSharedCheck_523_;
goto v_resetjp_501_;
}
else
{
lean_inc(v_val_500_);
lean_dec(v_x_475_);
v___x_502_ = lean_box(0);
v_isShared_503_ = v_isSharedCheck_523_;
goto v_resetjp_501_;
}
v_resetjp_501_:
{
lean_object* v___x_504_; lean_object* v_toRing_505_; lean_object* v___x_506_; lean_object* v___x_507_; lean_object* v_toNeg_508_; lean_object* v_fst_509_; lean_object* v_snd_510_; lean_object* v___x_512_; uint8_t v_isShared_513_; uint8_t v_isSharedCheck_522_; 
v___x_504_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3);
v_toRing_505_ = lean_ctor_get(v___x_504_, 0);
v___x_506_ = lp_mathlib_Ring_toAddCommGroup___redArg(v_toRing_505_);
v___x_507_ = lp_mathlib_SubNegZeroMonoid_toNegZeroClass___redArg(v___x_506_);
lean_dec_ref(v___x_506_);
v_toNeg_508_ = lean_ctor_get(v___x_507_, 1);
lean_inc(v_toNeg_508_);
lean_dec_ref(v___x_507_);
v_fst_509_ = lean_ctor_get(v_val_500_, 0);
v_snd_510_ = lean_ctor_get(v_val_500_, 1);
v_isSharedCheck_522_ = !lean_is_exclusive(v_val_500_);
if (v_isSharedCheck_522_ == 0)
{
v___x_512_ = v_val_500_;
v_isShared_513_ = v_isSharedCheck_522_;
goto v_resetjp_511_;
}
else
{
lean_inc(v_snd_510_);
lean_inc(v_fst_509_);
lean_dec(v_val_500_);
v___x_512_ = lean_box(0);
v_isShared_513_ = v_isSharedCheck_522_;
goto v_resetjp_511_;
}
v_resetjp_511_:
{
lean_object* v___x_514_; lean_object* v___x_515_; lean_object* v___x_517_; 
lean_inc(v_toNeg_508_);
v___x_514_ = lean_apply_1(v_toNeg_508_, v_fst_509_);
v___x_515_ = lean_apply_1(v_toNeg_508_, v_snd_510_);
if (v_isShared_513_ == 0)
{
lean_ctor_set(v___x_512_, 1, v___x_515_);
lean_ctor_set(v___x_512_, 0, v___x_514_);
v___x_517_ = v___x_512_;
goto v_reusejp_516_;
}
else
{
lean_object* v_reuseFailAlloc_521_; 
v_reuseFailAlloc_521_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_521_, 0, v___x_514_);
lean_ctor_set(v_reuseFailAlloc_521_, 1, v___x_515_);
v___x_517_ = v_reuseFailAlloc_521_;
goto v_reusejp_516_;
}
v_reusejp_516_:
{
lean_object* v___x_519_; 
if (v_isShared_503_ == 0)
{
lean_ctor_set(v___x_502_, 0, v___x_517_);
v___x_519_ = v___x_502_;
goto v_reusejp_518_;
}
else
{
lean_object* v_reuseFailAlloc_520_; 
v_reuseFailAlloc_520_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_520_, 0, v___x_517_);
v___x_519_ = v_reuseFailAlloc_520_;
goto v_reusejp_518_;
}
v_reusejp_518_:
{
return v___x_519_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_cast___at___00V14Formalization_CentralizerN_rotPt_spec__0(lean_object* v_a_524_){
_start:
{
lean_object* v___x_525_; lean_object* v_toRing_526_; lean_object* v___x_527_; lean_object* v_toAddMonoidWithOne_528_; lean_object* v_toNatCast_529_; lean_object* v___x_530_; 
v___x_525_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3);
v_toRing_526_ = lean_ctor_get(v___x_525_, 0);
lean_inc_ref(v_toRing_526_);
v___x_527_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_526_);
v_toAddMonoidWithOne_528_ = lean_ctor_get(v___x_527_, 1);
lean_inc_ref(v_toAddMonoidWithOne_528_);
lean_dec_ref(v___x_527_);
v_toNatCast_529_ = lean_ctor_get(v_toAddMonoidWithOne_528_, 0);
lean_inc(v_toNatCast_529_);
lean_dec_ref(v_toAddMonoidWithOne_528_);
v___x_530_ = lean_apply_1(v_toNatCast_529_, v_a_524_);
return v___x_530_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__0(void){
_start:
{
lean_object* v___x_531_; lean_object* v___x_532_; 
v___x_531_ = lean_unsigned_to_nat(3u);
v___x_532_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_CentralizerN_rotPt_spec__0(v___x_531_);
return v___x_532_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__1(void){
_start:
{
lean_object* v___x_533_; lean_object* v___x_534_; 
v___x_533_ = lean_unsigned_to_nat(5u);
v___x_534_ = lp_V14Formalization_Nat_cast___at___00V14Formalization_CentralizerN_rotPt_spec__0(v___x_533_);
return v___x_534_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__2(void){
_start:
{
lean_object* v___x_535_; lean_object* v___x_536_; lean_object* v___x_537_; 
v___x_535_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__1, &lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__1_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__1);
v___x_536_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__0, &lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__0_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__0);
v___x_537_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_537_, 0, v___x_536_);
lean_ctor_set(v___x_537_, 1, v___x_535_);
return v___x_537_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_rotPt(void){
_start:
{
lean_object* v___x_538_; 
v___x_538_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__2, &lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__2_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__2);
return v___x_538_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_reflPt(void){
_start:
{
lean_object* v___x_539_; lean_object* v_toRing_540_; lean_object* v___x_541_; lean_object* v_toAddMonoidWithOne_542_; lean_object* v_toOne_543_; lean_object* v___x_544_; lean_object* v___x_545_; 
v___x_539_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3);
v_toRing_540_ = lean_ctor_get(v___x_539_, 0);
lean_inc_ref(v_toRing_540_);
v___x_541_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_540_);
v_toAddMonoidWithOne_542_ = lean_ctor_get(v___x_541_, 1);
lean_inc_ref(v_toAddMonoidWithOne_542_);
lean_dec_ref(v___x_541_);
v_toOne_543_ = lean_ctor_get(v_toAddMonoidWithOne_542_, 2);
lean_inc(v_toOne_543_);
lean_dec_ref(v_toAddMonoidWithOne_542_);
v___x_544_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__0, &lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__0_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_rotPt___closed__0);
v___x_545_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_545_, 0, v_toOne_543_);
lean_ctor_set(v___x_545_, 1, v___x_544_);
return v___x_545_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__0(void){
_start:
{
lean_object* v___x_546_; lean_object* v___x_547_; 
v___x_546_ = lp_V14Formalization_V14Formalization_CentralizerN_rotPt;
v___x_547_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_547_, 0, v___x_546_);
return v___x_547_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__1(void){
_start:
{
lean_object* v___x_548_; lean_object* v___x_549_; 
v___x_548_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__0, &lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__0_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__0);
v___x_549_ = lp_V14Formalization_V14Formalization_CentralizerN_liftsToN(v___x_548_);
return v___x_549_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_rotGen(void){
_start:
{
lean_object* v___x_550_; 
v___x_550_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__1, &lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__1_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_rotGen___closed__1);
return v___x_550_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__0(void){
_start:
{
lean_object* v___x_551_; lean_object* v___x_552_; 
v___x_551_ = lp_V14Formalization_V14Formalization_CentralizerN_reflPt;
v___x_552_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_552_, 0, v___x_551_);
return v___x_552_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__1(void){
_start:
{
lean_object* v___x_553_; lean_object* v___x_554_; 
v___x_553_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__0, &lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__0_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__0);
v___x_554_ = lp_V14Formalization_V14Formalization_CentralizerN_liftsToN(v___x_553_);
return v___x_554_;
}
}
static lean_object* _init_lp_V14Formalization_V14Formalization_CentralizerN_reflGen(void){
_start:
{
lean_object* v___x_555_; 
v___x_555_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__1, &lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__1_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_reflGen___closed__1);
return v___x_555_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_mulCircle1(lean_object* v_p_556_, lean_object* v_q_557_){
_start:
{
lean_object* v___x_558_; lean_object* v_toRing_559_; lean_object* v___x_560_; lean_object* v___x_561_; lean_object* v_toSub_562_; lean_object* v___x_563_; lean_object* v_toSemiring_564_; lean_object* v___x_565_; lean_object* v_toMul_566_; lean_object* v_toAdd_567_; lean_object* v_fst_568_; lean_object* v_snd_569_; lean_object* v_fst_570_; lean_object* v_snd_571_; lean_object* v___x_573_; uint8_t v_isShared_574_; uint8_t v_isSharedCheck_584_; 
v___x_558_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__3);
v_toRing_559_ = lean_ctor_get(v___x_558_, 0);
lean_inc_ref(v_toRing_559_);
v___x_560_ = lp_mathlib_Ring_toAddGroupWithOne___redArg(v_toRing_559_);
v___x_561_ = lp_mathlib_AddGroupWithOne_toAddGroup___redArg(v___x_560_);
lean_dec_ref(v___x_560_);
v_toSub_562_ = lean_ctor_get(v___x_561_, 2);
lean_inc(v_toSub_562_);
lean_dec_ref(v___x_561_);
v___x_563_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__2);
v_toSemiring_564_ = lean_ctor_get(v___x_563_, 0);
lean_inc_ref(v_toSemiring_564_);
v___x_565_ = lp_mathlib_instDistribOfSemiring___redArg(v_toSemiring_564_);
v_toMul_566_ = lean_ctor_get(v___x_565_, 0);
lean_inc(v_toMul_566_);
v_toAdd_567_ = lean_ctor_get(v___x_565_, 1);
lean_inc(v_toAdd_567_);
lean_dec_ref(v___x_565_);
v_fst_568_ = lean_ctor_get(v_p_556_, 0);
lean_inc(v_fst_568_);
v_snd_569_ = lean_ctor_get(v_p_556_, 1);
lean_inc(v_snd_569_);
lean_dec_ref(v_p_556_);
v_fst_570_ = lean_ctor_get(v_q_557_, 0);
v_snd_571_ = lean_ctor_get(v_q_557_, 1);
v_isSharedCheck_584_ = !lean_is_exclusive(v_q_557_);
if (v_isSharedCheck_584_ == 0)
{
v___x_573_ = v_q_557_;
v_isShared_574_ = v_isSharedCheck_584_;
goto v_resetjp_572_;
}
else
{
lean_inc(v_snd_571_);
lean_inc(v_fst_570_);
lean_dec(v_q_557_);
v___x_573_ = lean_box(0);
v_isShared_574_ = v_isSharedCheck_584_;
goto v_resetjp_572_;
}
v_resetjp_572_:
{
lean_object* v___x_575_; lean_object* v___x_576_; lean_object* v___x_577_; lean_object* v___x_578_; lean_object* v___x_579_; lean_object* v___x_580_; lean_object* v___x_582_; 
lean_inc_n(v_toMul_566_, 3);
lean_inc(v_fst_570_);
lean_inc(v_fst_568_);
v___x_575_ = lean_apply_2(v_toMul_566_, v_fst_568_, v_fst_570_);
lean_inc(v_snd_571_);
lean_inc(v_snd_569_);
v___x_576_ = lean_apply_2(v_toMul_566_, v_snd_569_, v_snd_571_);
v___x_577_ = lean_apply_2(v_toSub_562_, v___x_575_, v___x_576_);
v___x_578_ = lean_apply_2(v_toMul_566_, v_fst_568_, v_snd_571_);
v___x_579_ = lean_apply_2(v_toMul_566_, v_snd_569_, v_fst_570_);
v___x_580_ = lean_apply_2(v_toAdd_567_, v___x_578_, v___x_579_);
if (v_isShared_574_ == 0)
{
lean_ctor_set(v___x_573_, 1, v___x_580_);
lean_ctor_set(v___x_573_, 0, v___x_577_);
v___x_582_ = v___x_573_;
goto v_reusejp_581_;
}
else
{
lean_object* v_reuseFailAlloc_583_; 
v_reuseFailAlloc_583_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_583_, 0, v___x_577_);
lean_ctor_set(v_reuseFailAlloc_583_, 1, v___x_580_);
v___x_582_ = v_reuseFailAlloc_583_;
goto v_reusejp_581_;
}
v_reusejp_581_:
{
return v___x_582_;
}
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Quotient_map_u2082___at___00V14Formalization_CentralizerN_dihedralToN_spec__1___redArg(lean_object* v_f_585_, lean_object* v_q_u2081_586_, lean_object* v_q_u2082_587_){
_start:
{
lean_object* v___x_588_; 
v___x_588_ = lean_apply_2(v_f_585_, v_q_u2081_586_, v_q_u2082_587_);
return v___x_588_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Quotient_map_u2082___at___00V14Formalization_CentralizerN_dihedralToN_spec__1(lean_object* v_f_589_, lean_object* v_h_590_, lean_object* v_q_u2081_591_, lean_object* v_q_u2082_592_){
_start:
{
lean_object* v___x_593_; 
v___x_593_ = lean_apply_2(v_f_589_, v_q_u2081_591_, v_q_u2082_592_);
return v___x_593_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Matrix_diagonal___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__0(lean_object* v_d_594_, lean_object* v_a_595_, lean_object* v_a_596_){
_start:
{
lean_object* v___x_597_; lean_object* v_toSemiring_598_; lean_object* v___x_599_; lean_object* v___x_600_; lean_object* v_toAddMonoid_601_; lean_object* v___x_602_; lean_object* v_toZero_603_; lean_object* v___x_604_; lean_object* v_toFun_605_; lean_object* v___f_606_; lean_object* v___x_607_; 
v___x_597_ = lean_obj_once(&lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0, &lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0_once, _init_lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0);
v_toSemiring_598_ = lean_ctor_get(v___x_597_, 0);
lean_inc_ref(v_toSemiring_598_);
v___x_599_ = lp_mathlib_Semiring_toNonAssocSemiring___redArg(v_toSemiring_598_);
v___x_600_ = lp_mathlib_NonAssocSemiring_toAddCommMonoidWithOne___redArg(v___x_599_);
v_toAddMonoid_601_ = lean_ctor_get(v___x_600_, 1);
lean_inc_ref(v_toAddMonoid_601_);
lean_dec_ref(v___x_600_);
v___x_602_ = lp_mathlib_AddMonoid_toAddZeroClass___redArg(v_toAddMonoid_601_);
lean_dec_ref(v_toAddMonoid_601_);
v_toZero_603_ = lean_ctor_get(v___x_602_, 0);
lean_inc(v_toZero_603_);
lean_dec_ref(v___x_602_);
v___x_604_ = lean_obj_once(&lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4, &lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4_once, _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat___closed__4);
v_toFun_605_ = lean_ctor_get(v___x_604_, 0);
v___f_606_ = lean_alloc_closure((void*)(lp_V14Formalization_Matrix_diagonal___at___00V14Formalization_CentralizerN_negI_spec__0___lam__0___boxed), 4, 2);
lean_closure_set(v___f_606_, 0, v_toZero_603_);
lean_closure_set(v___f_606_, 1, v_d_594_);
lean_inc(v_toFun_605_);
v___x_607_ = lean_apply_3(v_toFun_605_, v___f_606_, v_a_595_, v_a_596_);
return v___x_607_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0___lam__1(lean_object* v___f_608_, lean_object* v___y_609_, lean_object* v___y_610_){
_start:
{
lean_object* v___x_611_; 
v___x_611_ = lp_V14Formalization_Matrix_diagonal___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__0(v___f_608_, v___y_609_, v___y_610_);
return v___x_611_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1___lam__0(lean_object* v_y_612_, lean_object* v_x_613_, lean_object* v___y_614_, lean_object* v___y_615_){
_start:
{
lean_object* v___x_616_; 
v___x_616_ = lean_apply_2(v_y_612_, v___y_614_, v___y_615_);
return v___x_616_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1___lam__0___boxed(lean_object* v_y_617_, lean_object* v_x_618_, lean_object* v___y_619_, lean_object* v___y_620_){
_start:
{
lean_object* v_res_621_; 
v_res_621_ = lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1___lam__0(v_y_617_, v_x_618_, v___y_619_, v___y_620_);
lean_dec_ref(v_x_618_);
return v_res_621_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3_spec__4_spec__5(lean_object* v_s_622_){
_start:
{
lean_object* v___x_623_; lean_object* v_toSemiring_624_; lean_object* v___x_625_; lean_object* v_toAddCommMonoid_626_; lean_object* v___x_627_; lean_object* v_toZero_628_; lean_object* v_toAdd_629_; lean_object* v___f_630_; lean_object* v___x_631_; 
v___x_623_ = lean_obj_once(&lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0, &lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0_once, _init_lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0);
v_toSemiring_624_ = lean_ctor_get(v___x_623_, 0);
v___x_625_ = lp_mathlib_Semiring_toNonUnitalSemiring___redArg(v_toSemiring_624_);
v_toAddCommMonoid_626_ = lean_ctor_get(v___x_625_, 0);
lean_inc_ref(v_toAddCommMonoid_626_);
lean_dec_ref(v___x_625_);
v___x_627_ = lp_mathlib_AddMonoid_toAddZeroClass___redArg(v_toAddCommMonoid_626_);
lean_dec_ref(v_toAddCommMonoid_626_);
v_toZero_628_ = lean_ctor_get(v___x_627_, 0);
lean_inc(v_toZero_628_);
v_toAdd_629_ = lean_ctor_get(v___x_627_, 1);
lean_inc(v_toAdd_629_);
lean_dec_ref(v___x_627_);
v___f_630_ = lean_alloc_closure((void*)(lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___lam__0), 3, 1);
lean_closure_set(v___f_630_, 0, v_toAdd_629_);
v___x_631_ = l_List_foldrTR___redArg(v___f_630_, v_toZero_628_, v_s_622_);
return v___x_631_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Finset_sum___at___00dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3_spec__4___redArg(lean_object* v_s_632_, lean_object* v_f_633_){
_start:
{
lean_object* v___x_634_; lean_object* v___x_635_; 
v___x_634_ = lp_mathlib_Multiset_map___redArg(v_f_633_, v_s_632_);
v___x_635_ = lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3_spec__4_spec__5(v___x_634_);
return v___x_635_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3(lean_object* v_v_636_, lean_object* v_w_637_){
_start:
{
lean_object* v___x_638_; lean_object* v_toSemiring_639_; lean_object* v___x_640_; lean_object* v___x_641_; lean_object* v_toMul_642_; lean_object* v___f_643_; lean_object* v___x_644_; lean_object* v___x_645_; 
v___x_638_ = lean_obj_once(&lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0, &lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0_once, _init_lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0);
v_toSemiring_639_ = lean_ctor_get(v___x_638_, 0);
v___x_640_ = lp_mathlib_Semiring_toNonUnitalSemiring___redArg(v_toSemiring_639_);
v___x_641_ = lp_mathlib_NonUnitalNonAssocSemiring_toDistrib___redArg(v___x_640_);
v_toMul_642_ = lean_ctor_get(v___x_641_, 0);
lean_inc(v_toMul_642_);
lean_dec_ref(v___x_641_);
v___f_643_ = lean_alloc_closure((void*)(lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___lam__0), 4, 3);
lean_closure_set(v___f_643_, 0, v_v_636_);
lean_closure_set(v___f_643_, 1, v_w_637_);
lean_closure_set(v___f_643_, 2, v_toMul_642_);
v___x_644_ = lean_obj_once(&lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0, &lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0_once, _init_lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0___closed__0);
v___x_645_ = lp_V14Formalization_Finset_sum___at___00dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3_spec__4___redArg(v___x_644_, v___f_643_);
return v___x_645_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__1(lean_object* v___y_646_, lean_object* v___y_647_, lean_object* v_j_648_){
_start:
{
lean_object* v___x_649_; 
v___x_649_ = lean_apply_2(v___y_646_, v___y_647_, v_j_648_);
return v___x_649_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__0(lean_object* v___y_650_, lean_object* v___y_651_, lean_object* v_j_652_){
_start:
{
lean_object* v___x_653_; 
v___x_653_ = lean_apply_2(v___y_650_, v_j_652_, v___y_651_);
return v___x_653_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__2(lean_object* v___y_654_, lean_object* v___y_655_, lean_object* v___y_656_, lean_object* v___y_657_){
_start:
{
lean_object* v___f_658_; lean_object* v___f_659_; lean_object* v___x_660_; 
v___f_658_ = lean_alloc_closure((void*)(lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__0), 3, 2);
lean_closure_set(v___f_658_, 0, v___y_654_);
lean_closure_set(v___f_658_, 1, v___y_657_);
v___f_659_ = lean_alloc_closure((void*)(lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__1), 3, 2);
lean_closure_set(v___f_659_, 0, v___y_655_);
lean_closure_set(v___f_659_, 1, v___y_656_);
v___x_660_ = lp_V14Formalization_dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3(v___f_659_, v___f_658_);
return v___x_660_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__5(lean_object* v___y_661_, lean_object* v___y_662_, lean_object* v___y_663_){
_start:
{
lean_object* v___f_664_; lean_object* v___f_665_; lean_object* v___x_666_; 
lean_inc_ref(v___y_661_);
v___f_664_ = lean_alloc_closure((void*)(lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__0), 3, 2);
lean_closure_set(v___f_664_, 0, v___y_661_);
lean_closure_set(v___f_664_, 1, v___y_663_);
v___f_665_ = lean_alloc_closure((void*)(lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__1), 3, 2);
lean_closure_set(v___f_665_, 0, v___y_661_);
lean_closure_set(v___f_665_, 1, v___y_662_);
v___x_666_ = lp_V14Formalization_dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3(v___f_665_, v___f_664_);
return v___x_666_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4(lean_object* v_zero_667_, lean_object* v_n_668_, lean_object* v___y_669_, lean_object* v___y_670_, lean_object* v___y_671_, lean_object* v___y_672_){
_start:
{
lean_object* v___x_673_; uint8_t v___x_674_; 
v___x_673_ = lean_unsigned_to_nat(0u);
v___x_674_ = lean_nat_dec_eq(v_n_668_, v___x_673_);
if (v___x_674_ == 0)
{
lean_object* v___f_675_; lean_object* v___f_676_; lean_object* v___x_677_; lean_object* v___x_681_; uint8_t v___x_682_; 
lean_inc_ref(v___y_669_);
lean_inc_ref(v___y_670_);
v___f_675_ = lean_alloc_closure((void*)(lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__2), 4, 2);
lean_closure_set(v___f_675_, 0, v___y_670_);
lean_closure_set(v___f_675_, 1, v___y_669_);
v___f_676_ = lean_alloc_closure((void*)(lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4___lam__5), 3, 1);
lean_closure_set(v___f_676_, 0, v___y_670_);
v___x_677_ = lean_unsigned_to_nat(1u);
v___x_681_ = lean_nat_land(v___x_677_, v_n_668_);
v___x_682_ = lean_nat_dec_eq(v___x_681_, v___x_673_);
lean_dec(v___x_681_);
if (v___x_682_ == 0)
{
lean_dec_ref(v___y_669_);
goto v___jp_678_;
}
else
{
if (v___x_674_ == 0)
{
lean_object* v___x_683_; 
lean_dec_ref(v___f_675_);
v___x_683_ = lean_nat_shiftr(v_n_668_, v___x_677_);
lean_dec(v_n_668_);
v_n_668_ = v___x_683_;
v___y_670_ = v___f_676_;
goto _start;
}
else
{
lean_dec_ref(v___y_669_);
goto v___jp_678_;
}
}
v___jp_678_:
{
lean_object* v___x_679_; 
v___x_679_ = lean_nat_shiftr(v_n_668_, v___x_677_);
lean_dec(v_n_668_);
v_n_668_ = v___x_679_;
v___y_669_ = v___f_675_;
v___y_670_ = v___f_676_;
goto _start;
}
}
else
{
lean_object* v___x_685_; 
lean_dec(v_n_668_);
v___x_685_ = lean_apply_4(v_zero_667_, v___y_669_, v___y_670_, v___y_671_, v___y_672_);
return v___x_685_;
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1(lean_object* v_k_687_, lean_object* v_a_688_, lean_object* v_a_689_, lean_object* v___y_690_, lean_object* v___y_691_){
_start:
{
lean_object* v___f_692_; lean_object* v___x_693_; 
v___f_692_ = ((lean_object*)(lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1___closed__0));
v___x_693_ = lp_V14Formalization_Nat_binaryRec___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__4(v___f_692_, v_k_687_, v_a_688_, v_a_689_, v___y_690_, v___y_691_);
return v___x_693_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0(lean_object* v_k_694_, lean_object* v_a_695_, lean_object* v___y_696_, lean_object* v___y_697_){
_start:
{
lean_object* v___x_698_; lean_object* v_toSemiring_699_; lean_object* v___x_700_; lean_object* v___x_701_; lean_object* v_toOne_702_; lean_object* v___f_703_; lean_object* v___f_704_; lean_object* v___x_705_; 
v___x_698_ = lean_obj_once(&lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0, &lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0_once, _init_lp_V14Formalization_Multiset_sum___at___00Finset_sum___at___00dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0_spec__0_spec__1___closed__0);
v_toSemiring_699_ = lean_ctor_get(v___x_698_, 0);
lean_inc_ref(v_toSemiring_699_);
v___x_700_ = lp_mathlib_Semiring_toNonAssocSemiring___redArg(v_toSemiring_699_);
v___x_701_ = lp_mathlib_NonAssocSemiring_toAddCommMonoidWithOne___redArg(v___x_700_);
v_toOne_702_ = lean_ctor_get(v___x_701_, 2);
lean_inc(v_toOne_702_);
lean_dec_ref(v___x_701_);
v___f_703_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_negI___lam__0___boxed), 2, 1);
lean_closure_set(v___f_703_, 0, v_toOne_702_);
v___f_704_ = lean_alloc_closure((void*)(lp_V14Formalization_npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0___lam__1), 3, 1);
lean_closure_set(v___f_704_, 0, v___f_703_);
v___x_705_ = lp_V14Formalization_npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1(v_k_694_, v___f_704_, v_a_695_, v___y_696_, v___y_697_);
return v___x_705_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__0(lean_object* v___x_706_, lean_object* v___x_707_, lean_object* v___y_708_, lean_object* v___y_709_){
_start:
{
lean_object* v___x_710_; 
v___x_710_ = lp_V14Formalization_npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0(v___x_706_, v___x_707_, v___y_708_, v___y_709_);
return v___x_710_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__1(lean_object* v___x_711_, lean_object* v___x_712_, lean_object* v___y_713_, lean_object* v_j_714_){
_start:
{
lean_object* v___x_715_; 
v___x_715_ = lp_V14Formalization_npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0(v___x_711_, v___x_712_, v_j_714_, v___y_713_);
return v___x_715_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__2(lean_object* v___y_716_, lean_object* v_j_717_){
_start:
{
lean_object* v___x_3569__overap_718_; lean_object* v___x_719_; 
v___x_3569__overap_718_ = lp_V14Formalization_V14Formalization_CentralizerN_reflGen;
v___x_719_ = lean_apply_2(v___x_3569__overap_718_, v___y_716_, v_j_717_);
return v___x_719_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__3(lean_object* v___x_720_, lean_object* v___x_721_, lean_object* v___y_722_, lean_object* v___y_723_){
_start:
{
lean_object* v___f_724_; lean_object* v___f_725_; lean_object* v___x_726_; 
v___f_724_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__1), 4, 3);
lean_closure_set(v___f_724_, 0, v___x_720_);
lean_closure_set(v___f_724_, 1, v___x_721_);
lean_closure_set(v___f_724_, 2, v___y_723_);
v___f_725_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__2), 2, 1);
lean_closure_set(v___f_725_, 0, v___y_722_);
v___x_726_ = lp_V14Formalization_dotProduct___at___00V14Formalization_CentralizerN_negS_spec__0(v___f_725_, v___f_724_);
return v___x_726_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN(lean_object* v_x_727_){
_start:
{
if (lean_obj_tag(v_x_727_) == 0)
{
lean_object* v_a_728_; lean_object* v___x_729_; lean_object* v___x_730_; lean_object* v___x_731_; lean_object* v___f_732_; 
v_a_728_ = lean_ctor_get(v_x_727_, 0);
v___x_729_ = lp_V14Formalization_V14Formalization_CentralizerN_rotGen;
v___x_730_ = lean_unsigned_to_nat(6u);
v___x_731_ = lp_mathlib_ZMod_val(v___x_730_, v_a_728_);
v___f_732_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__0), 4, 2);
lean_closure_set(v___f_732_, 0, v___x_731_);
lean_closure_set(v___f_732_, 1, v___x_729_);
return v___f_732_;
}
else
{
lean_object* v_a_733_; lean_object* v___x_734_; lean_object* v___x_735_; lean_object* v___x_736_; lean_object* v___f_737_; 
v_a_733_ = lean_ctor_get(v_x_727_, 0);
v___x_734_ = lp_V14Formalization_V14Formalization_CentralizerN_rotGen;
v___x_735_ = lean_unsigned_to_nat(6u);
v___x_736_ = lp_mathlib_ZMod_val(v___x_735_, v_a_733_);
v___f_737_ = lean_alloc_closure((void*)(lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___lam__3), 4, 2);
lean_closure_set(v___f_737_, 0, v___x_736_);
lean_closure_set(v___f_737_, 1, v___x_734_);
return v___f_737_;
}
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN___boxed(lean_object* v_x_738_){
_start:
{
lean_object* v_res_739_; 
v_res_739_ = lp_V14Formalization_V14Formalization_CentralizerN_dihedralToN(v_x_738_);
lean_dec_ref(v_x_738_);
return v_res_739_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Finset_sum___at___00dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3_spec__4(lean_object* v_00_u03b9_740_, lean_object* v_s_741_, lean_object* v_f_742_){
_start:
{
lean_object* v___x_743_; 
v___x_743_ = lp_V14Formalization_Finset_sum___at___00dotProduct___at___00npowBinRec_go___at___00npowBinRec___at___00V14Formalization_CentralizerN_dihedralToN_spec__0_spec__1_spec__3_spec__4___redArg(v_s_741_, v_f_742_);
return v___x_743_;
}
}
static lean_object* _init_lp_V14Formalization_Submonoid_center___at___00Subgroup_center___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__0_spec__0(void){
_start:
{
lean_object* v___x_746_; 
v___x_746_ = lean_box(0);
return v___x_746_;
}
}
static lean_object* _init_lp_V14Formalization_Subgroup_center___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__0(void){
_start:
{
lean_object* v___x_747_; 
v___x_747_ = lean_box(0);
return v___x_747_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Submonoid_centralizer___at___00Subgroup_centralizer___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__1_spec__2(lean_object* v_S_748_){
_start:
{
lean_object* v___x_749_; 
v___x_749_ = lean_box(0);
return v___x_749_;
}
}
LEAN_EXPORT lean_object* lp_V14Formalization_Subgroup_centralizer___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__1(lean_object* v_s_750_){
_start:
{
lean_object* v___x_751_; 
v___x_751_ = lean_box(0);
return v___x_751_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_SpecialLinearGroup(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_LinearAlgebra_Matrix_ProjectiveSpecialLinearGroup(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_ZMod_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Field_ZMod(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Nat_Prime_Defs(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_SpecificGroups_Dihedral(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Fintype_BigOperators(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Group_Subgroup_Finite(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_OrderOfElement(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_GroupTheory_Subgroup_Centralizer(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_V14Formalization_V14Formalization_CentralizerD12(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
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
res = initialize_mathlib_Mathlib_GroupTheory_SpecificGroups_Dihedral(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Fintype_BigOperators(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Group_Subgroup_Finite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_OrderOfElement(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_GroupTheory_Subgroup_Centralizer(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
lp_V14Formalization_V14Formalization_CentralizerN_Smat = _init_lp_V14Formalization_V14Formalization_CentralizerN_Smat();
lean_mark_persistent(lp_V14Formalization_V14Formalization_CentralizerN_Smat);
lp_V14Formalization_V14Formalization_CentralizerN_sigma = _init_lp_V14Formalization_V14Formalization_CentralizerN_sigma();
lean_mark_persistent(lp_V14Formalization_V14Formalization_CentralizerN_sigma);
lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1 = _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1();
lean_mark_persistent(lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircle1);
lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1 = _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1();
lean_mark_persistent(lp_V14Formalization_V14Formalization_CentralizerN_instFintypeCircleM1);
lp_V14Formalization_V14Formalization_CentralizerN_negI = _init_lp_V14Formalization_V14Formalization_CentralizerN_negI();
lean_mark_persistent(lp_V14Formalization_V14Formalization_CentralizerN_negI);
lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11 = _init_lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11();
lean_mark_persistent(lp_V14Formalization_V14Formalization_CentralizerN_instFintypePSL2F11);
lp_V14Formalization_V14Formalization_CentralizerN_rotPt = _init_lp_V14Formalization_V14Formalization_CentralizerN_rotPt();
lean_mark_persistent(lp_V14Formalization_V14Formalization_CentralizerN_rotPt);
lp_V14Formalization_V14Formalization_CentralizerN_reflPt = _init_lp_V14Formalization_V14Formalization_CentralizerN_reflPt();
lean_mark_persistent(lp_V14Formalization_V14Formalization_CentralizerN_reflPt);
lp_V14Formalization_V14Formalization_CentralizerN_rotGen = _init_lp_V14Formalization_V14Formalization_CentralizerN_rotGen();
lean_mark_persistent(lp_V14Formalization_V14Formalization_CentralizerN_rotGen);
lp_V14Formalization_V14Formalization_CentralizerN_reflGen = _init_lp_V14Formalization_V14Formalization_CentralizerN_reflGen();
lean_mark_persistent(lp_V14Formalization_V14Formalization_CentralizerN_reflGen);
lp_V14Formalization_Submonoid_center___at___00Subgroup_center___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__0_spec__0 = _init_lp_V14Formalization_Submonoid_center___at___00Subgroup_center___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__0_spec__0();
lean_mark_persistent(lp_V14Formalization_Submonoid_center___at___00Subgroup_center___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__0_spec__0);
lp_V14Formalization_Subgroup_center___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__0 = _init_lp_V14Formalization_Subgroup_center___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__0();
lean_mark_persistent(lp_V14Formalization_Subgroup_center___at___00V14Formalization_CentralizerN_dihedralToNHom_spec__0);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
