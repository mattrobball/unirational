-- Stage-1 module-importer smoke test: run `lake env lean scripts/module_smoke_stage1.lean`.
-- A `module` importer must see every public name and elaborate every downstream idiom.
-- Extend (or copy per stage) as later stages convert more files.
module

import V14Formalization.Basic
import V14Formalization.BiprojectiveIntegral
import V14Formalization.CentralizerD12
import V14Formalization.D12PolyZReflection
import V14Formalization.EllipticPolynomialConstancy
import V14Formalization.MultiProjectiveZeroLocus
import V14Formalization.PSLCard
import V14Formalization.ProjNaturality
import V14Formalization.SchemeBaseChangeAction
import V14Formalization.SchemeEquivariant
import V14Formalization.WeilRep
import V14Formalization.D12PolynomialCore
import V14Formalization.D12SealData

#check @BConicBundleMultisections.BiprojectiveSpace.isIntegral
#check @BConicBundleMultisections.BiprojectiveSpace.standardChartIntegral
#check @BConicBundleMultisections.BiprojectiveSpace.standardChartRanges_pairwise
#check @V14Formalization.CentralizerN.Circle1
#check @V14Formalization.CentralizerN.CircleM1
#check @V14Formalization.CentralizerN.F
#check @V14Formalization.CentralizerN.PSL2F11
#check @V14Formalization.CentralizerN.SLG
#check @V14Formalization.CentralizerN.Smat
#check @V14Formalization.CentralizerN.center_eq_one_or_negI
#check @V14Formalization.CentralizerN.centralizer_sigma_card
#check @V14Formalization.CentralizerN.centralizer_sigma_mulEquiv_dihedral
#check @V14Formalization.CentralizerN.dihedralToN
#check @V14Formalization.CentralizerN.dihedralToNHom
#check @V14Formalization.CentralizerN.dihedralToNHom_injective
#check @V14Formalization.CentralizerN.eq_zero_of_eq_neg
#check @V14Formalization.CentralizerN.liftsToN
#check @V14Formalization.CentralizerN.mkRefl
#check @V14Formalization.CentralizerN.mkRefl_conj_mkRot
#check @V14Formalization.CentralizerN.mkRefl_pow_two
#check @V14Formalization.CentralizerN.mkRot
#check @V14Formalization.CentralizerN.mkRot_pow_six
#check @V14Formalization.CentralizerN.mk_negI
#check @V14Formalization.CentralizerN.negI
#check @V14Formalization.CentralizerN.negI_mem_center
#check @V14Formalization.CentralizerN.orderOf_rotGen
#check @V14Formalization.CentralizerN.reflGen
#check @V14Formalization.CentralizerN.reflGen_conj_rotGen
#check @V14Formalization.CentralizerN.reflGen_mul_self
#check @V14Formalization.CentralizerN.reflGen_ne_rot_pow
#check @V14Formalization.CentralizerN.reflPt
#check @V14Formalization.CentralizerN.refl_mem
#check @V14Formalization.CentralizerN.rotGen
#check @V14Formalization.CentralizerN.rotGen_inv_eq
#check @V14Formalization.CentralizerN.rotGen_mul_reflGen
#check @V14Formalization.CentralizerN.rotGen_pow_mod
#check @V14Formalization.CentralizerN.rotGen_pow_mul_reflGen
#check @V14Formalization.CentralizerN.rotGen_pow_six
#check @V14Formalization.CentralizerN.rotPt
#check @V14Formalization.CentralizerN.rot_mem
#check @V14Formalization.CentralizerN.sigma
#check @V14Formalization.CentralizerN.sq_eq_one_cases
#check @V14Formalization.D12PolyZReflection.addList
#check @V14Formalization.D12PolyZReflection.convList
#check @V14Formalization.D12PolyZReflection.interpQ
#check @V14Formalization.D12PolyZReflection.interpQ_nil
#check @V14Formalization.D12PolyZReflection.interp_add_gen
#check @V14Formalization.D12PolyZReflection.interp_eq
#check @V14Formalization.D12PolyZReflection.interp_mul
#check @V14Formalization.D12PolyZReflection.interp_sub_gen
#check @V14Formalization.D12PolyZReflection.smulList
#check @V14Formalization.D12PolyZReflection.subList
#check @V14Formalization.D12PolyZReflection.toPolyZ
#check @V14Formalization.EllipticPolynomialConstancy.MvFrac
#check @V14Formalization.EllipticPolynomialConstancy.mvFractionSuccRingEquiv
#check @V14Formalization.EllipticPolynomialConstancy.mvFractionZeroAlgEquiv
#check @V14Formalization.EllipticPolynomialConstancy.mvRatFuncBack
#check @V14Formalization.EllipticPolynomialConstancy.mvRatFuncBackBase
#check @V14Formalization.EllipticPolynomialConstancy.mvSuccToRatFunc
#check @V14Formalization.EllipticPolynomialConstancy.mvSuccToRatFuncBase
#check @V14Formalization.EllipticPolynomialConstancy.mvSuccToRatFunc_algebraMap_base
#check @V14Formalization.EllipticPolynomialConstancy.mvSuccToRatFunc_comp_mvRatFuncBack
#check @V14Formalization.EllipticPolynomialConstancy.mvTailBase
#check @V14Formalization.EllipticPolynomialConstancy.mvTailFrac
#check @V14Formalization.EllipticPolynomialConstancy.mvfrac_coordinates_constant_of_short_weierstrass_equation
#check @V14Formalization.EllipticPolynomialConstancy.mvfrac_xy_constant_of_split_cubic_square
#check @V14Formalization.EllipticPolynomialConstancy.polynomial_xy_constant_of_short_weierstrass_over_field
#check @V14Formalization.EllipticPolynomialConstancy.ratfunc_coordinates_constant_of_short_weierstrass_equation
#check @V14Formalization.EllipticPolynomialConstancy.ratfunc_xy_constant_of_short_weierstrass
#check @V14Formalization.EllipticPolynomialConstancy.ratfunc_xy_constant_of_split_cubic_square_over_field
#check @V14Formalization.EllipticPolynomialConstancy.ratfunc_xy_constant_of_unit_denominators
#check @V14Formalization.EllipticPolynomialConstancy.short_weierstrass_point_baseChange_mvfrac_fin4_surjective
#check @V14Formalization.EllipticPolynomialConstancy.short_weierstrass_point_baseChange_mvfrac_surjective
#check @V14Formalization.EllipticPolynomialConstancy.short_weierstrass_point_baseChange_of_fin4_algEquiv_surjective
#check @V14Formalization.EllipticPolynomialConstancy.short_weierstrass_point_baseChange_ratfunc_surjective
#check @V14Formalization.SchemeGeometry.ker_projectiveZeroLocusFamilyι
#check @V14Formalization.SchemeGeometry.projectiveZeroLocusFamily
#check @V14Formalization.SchemeGeometry.projectiveZeroLocusFamilyIdeal
#check @V14Formalization.SchemeGeometry.projectiveZeroLocusFamilyToSpec
#check @V14Formalization.SchemeGeometry.projectiveZeroLocusFamilyι
#check @V14Formalization.SchemeGeometry.projectiveZeroLocusFamilyι_isClosedImmersion
#check @V14Formalization.SchemeGeometry.projectiveZeroLocusFamilyι_isOver
#check @V14Formalization.PSLCard.F
#check @V14Formalization.PSLCard.PSL2F11
#check @V14Formalization.PSLCard.SLG
#check @V14Formalization.PSLCard.Smat
#check @V14Formalization.PSLCard.Tmat
#check @V14Formalization.PSLCard.card_PSL2_F11_fintype
#check @V14Formalization.PSLCard.card_psl_order_eleven
#check @V14Formalization.PSLCard.card_psl_order_six
#check @V14Formalization.PSLCard.card_psl_order_three
#check @V14Formalization.PSLCard.card_psl_order_two
#check @V14Formalization.PSLCard.chi10Int
#check @V14Formalization.PSLCard.chi10Int_convolution
#check @V14Formalization.PSLCard.chi10Int_sum_sq_psl
#check @V14Formalization.PSLCard.lift
#check @V14Formalization.PSLCard.negI
#check @V14Formalization.PSLCard.negI_mem_center
#check @V14Formalization.PSLCard.orderOf_mk_eq_pslOrd
#check @V14Formalization.PSLCard.pslOrd
#check @V14Formalization.PSLCard.pslOrd_eq_spectrum
#check @V14Formalization.PSLCard.slCardOrder
#check @V14Formalization.PSLCard.slCardOrder_eleven
#check @V14Formalization.PSLCard.slCardOrder_one
#check @V14Formalization.PSLCard.slCardOrder_six
#check @V14Formalization.PSLCard.slCardOrder_three
#check @V14Formalization.PSLCard.slCardOrder_two
#check @V14Formalization.PSLCard.sum_comp_mk
#check @AlgebraicGeometry.Proj.map_toSpecZero
#check @BConicBundleMultisections.mapLinearSubst_toSpec
#check @V14Formalization.SchemeGeometry.baseChangeAction
#check @V14Formalization.SchemeGeometry.EquivariantRationalMap
#check @V14Formalization.SchemeGeometry.HasEquivariantRationalMap
#check @V14Formalization.SchemeGeometry.actionOverOfIsOver
#check @V14Formalization.SchemeGeometry.actionPrecomp
#check @V14Formalization.SchemeGeometry.actionPrecomp_eq_self_of_rho_eq_id
#check @V14Formalization.SchemeGeometry.EquivariantRationalMap.res
#check @V14Formalization.WeilRep.EvenSub
#check @V14Formalization.WeilRep.Fun
#check @V14Formalization.WeilRep.K
#check @V14Formalization.WeilRep.S6
#check @V14Formalization.WeilRep.S_even
#check @V14Formalization.WeilRep.S_even_sq
#check @V14Formalization.WeilRep.Sfull
#check @V14Formalization.WeilRep.Sfull_preserves_even
#check @V14Formalization.WeilRep.Sfull_sq_apply
#check @V14Formalization.WeilRep.Smat
#check @V14Formalization.WeilRep.T6
#check @V14Formalization.WeilRep.T_even_b
#check @V14Formalization.WeilRep.T_even_b_add
#check @V14Formalization.WeilRep.T_even_b_zero
#check @V14Formalization.WeilRep.Tfull_b
#check @V14Formalization.WeilRep.Tfull_b_preserves_even
#check @V14Formalization.WeilRep.Tmat
#check @V14Formalization.WeilRep.U
#check @V14Formalization.WeilRep.Ucoord
#check @V14Formalization.WeilRep.aeval_ζ_Φ11
#check @V14Formalization.WeilRep.cFourier
#check @V14Formalization.WeilRep.cFourier_sq_mul_eleven
#check @V14Formalization.WeilRep.card_sq_eq
#check @V14Formalization.WeilRep.gauss
#check @V14Formalization.WeilRep.gauss_eq_gaussSum
#check @V14Formalization.WeilRep.gauss_ne_zero
#check @V14Formalization.WeilRep.gauss_sq
#check @V14Formalization.WeilRep.minpoly_ζ
#check @V14Formalization.WeilRep.orderOf_ζ
#check @V14Formalization.WeilRep.sum_ψ_eq_zero
#check @V14Formalization.WeilRep.sum_ψ_mul
#check @V14Formalization.WeilRep.twoInv
#check @V14Formalization.WeilRep.two_mul_twoInv
#check @V14Formalization.WeilRep.Φ11
#check @V14Formalization.WeilRep.Φ11_irreducible
#check @V14Formalization.WeilRep.Φ11_monic
#check @V14Formalization.WeilRep.Φ11_natDegree
#check @V14Formalization.WeilRep.ζ
#check @V14Formalization.WeilRep.ζ_pow_eleven
#check @V14Formalization.WeilRep.χ₂
#check @V14Formalization.WeilRep.χ₂_isQuadratic
#check @V14Formalization.WeilRep.χ₂_ne_one
#check @V14Formalization.WeilRep.χ₂_neg_one
#check @V14Formalization.WeilRep.χ₂ℤ
#check @V14Formalization.WeilRep.ψ
#check @V14Formalization.WeilRep.ψ_add
#check @V14Formalization.WeilRep.ψ_apply
#check @V14Formalization.WeilRep.ψ_primitive
#check @V14Formalization.WeilRep.ψ_zero
#check @V14Formalization.D12PolynomialData.PolyQ
#check @V14Formalization.D12PolynomialData.Coeff10
#check @V14Formalization.D12PolynomialData.payloadSha256
#check @V14Formalization.D12PolynomialData.of10
#check @V14Formalization.D12PolynomialData.of10_add
#check @V14Formalization.D12PolynomialData.C_mul_of10
#check @V14Formalization.D12PolynomialData.of10_mul_C
#check @V14Formalization.D12PolynomialData.Phi11
#check @V14Formalization.D12PolynomialData.B_poly
#check @V14Formalization.D12PolynomialData.L_poly
#check @V14Formalization.D12PolynomialData.L_mul_B_poly
#check @V14Formalization.D12SealData.F15x15_flat
#check @V14Formalization.D12SealData.KCoeff10
#check @V14Formalization.D12SealData.R15x15_flat
#check @V14Formalization.D12SealData.RM10x10_flat
#check @V14Formalization.D12SealData.SM10x10_flat
#check @V14Formalization.D12SealData.deltaAA
#check @V14Formalization.D12SealData.deltaAP
#check @V14Formalization.D12SealData.deltaPP
#check @V14Formalization.D12SealData.pieceAA_K10xd
#check @V14Formalization.D12SealData.pieceAA_X10x20_flat
#check @V14Formalization.D12SealData.pieceAA_Ydx10
#check @V14Formalization.D12SealData.pieceAA_coeffMatrix
#check @V14Formalization.D12SealData.pieceAP_K10xd
#check @V14Formalization.D12SealData.pieceAP_X10x20_flat
#check @V14Formalization.D12SealData.pieceAP_Ydx10
#check @V14Formalization.D12SealData.pieceAP_coeffMatrix
#check @V14Formalization.D12SealData.piecePA_X10x20_flat
#check @V14Formalization.D12SealData.piecePP_K10xd
#check @V14Formalization.D12SealData.piecePP_X10x20_flat
#check @V14Formalization.D12SealData.piecePP_Ydx10
#check @V14Formalization.D12SealData.piecePP_coeffMatrix
#check @V14Formalization.D12SealData.RatPair

open V14Formalization.D12PolyZReflection in
example : interpQ 1 [0] = 0 := by simp [interpQ, toPolyZ]

open V14Formalization.D12PolyZReflection in
example : convList [1, 2] [3, 4] = [3, 10, 8] := by decide

open V14Formalization.D12PolyZReflection in
example : subList (smulList 2 [1]) (smulList 1 [2]) = [0] := by decide

open V14Formalization.D12PolynomialData in
example : of10 (fun _ => 0) = 0 := by simp [of10]

open V14Formalization.D12PolynomialData in
example : Phi11.coeff 0 = 1 := by
  simp [Phi11, Polynomial.coeff_X_pow, Finset.sum_ite_eq']

example : V14Formalization.D12SealData.deltaPP.size = 10 := by rfl

open V14Formalization CentralizerN in
example : (rotGen : Subgroup.centralizer ({sigma} : Set PSL2F11)).val =
    QuotientGroup.mk (mkRot rotPt) := rfl

open V14Formalization.WeilRep in
example (a : ZMod 11) : ψ a = ζ ^ a.val := rfl
