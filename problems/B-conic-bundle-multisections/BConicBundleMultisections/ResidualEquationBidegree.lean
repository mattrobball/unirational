/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.CubicFiberSingularLocus
public import BConicBundleMultisections.ResidualDivisor
public import BConicBundleMultisections.ResidualEquationLine

/-!
# Bidegree of the residual divisor equation

The residual-line coefficients are degree-five covariants of the ten coefficients of a plane
cubic.  For a bidegree-`(2,3)` equation those ten coefficients are quadratic in the first Cox
block, so the residual-line coefficients are homogeneous of degree ten.  Multiplication by one
second-block variable gives the advertised bidegree `(10,1)`.
-/

@[expose] public section

namespace BConicBundleMultisections
namespace ResidualDivisor

noncomputable section

open MvPolynomial
open UniversalResidual

universe u

/-! ### The universal degree-five covariants

`isHomogeneous_of_eval_smul` reads homogeneity off a scaling identity checked at every `K`-point,
which needs `K` infinite.  Homogeneity is a statement about the support, so it descends along any
injective change of coefficients, and the scaling identity is available over the algebraic closure
because `residualCoeff*_poly` is a fixed integer polynomial in its arguments, hence commutes with
base change (`map_residualCoeff*_poly`).  So the theorems below hold over an arbitrary field, with
`[Infinite K]` discharged over `AlgebraicClosure K` rather than assumed. -/

private theorem residualCoeffU_poly_isHomogeneous_of_infinite
    {K : Type u} [Field K] [Infinite K]
    {a b c d e f hh i : MvPolynomial (Fin 3) K}
    (ha : a.IsHomogeneous 2) (hb : b.IsHomogeneous 2) (hc : c.IsHomogeneous 2)
    (hd : d.IsHomogeneous 2) (he : e.IsHomogeneous 2) (hf : f.IsHomogeneous 2)
    (hhh : hh.IsHomogeneous 2) (hi : i.IsHomogeneous 2) :
    (residualCoeffU_poly a b c d e f hh i).IsHomogeneous 10 := by
  refine isHomogeneous_of_eval_smul fun r x => ?_
  rw [eval_residualCoeffU_poly, eval_residualCoeffU_poly]
  rw [eval_smul_point_of_isHomogeneous ha, eval_smul_point_of_isHomogeneous hb,
    eval_smul_point_of_isHomogeneous hc, eval_smul_point_of_isHomogeneous hd,
    eval_smul_point_of_isHomogeneous he, eval_smul_point_of_isHomogeneous hf,
    eval_smul_point_of_isHomogeneous hhh, eval_smul_point_of_isHomogeneous hi]
  simp only [residualCoeffU]
  ring

private theorem residualCoeffV_poly_isHomogeneous_of_infinite
    {K : Type u} [Field K] [Infinite K]
    {a b c d e f hh j : MvPolynomial (Fin 3) K}
    (ha : a.IsHomogeneous 2) (hb : b.IsHomogeneous 2) (hc : c.IsHomogeneous 2)
    (hd : d.IsHomogeneous 2) (he : e.IsHomogeneous 2) (hf : f.IsHomogeneous 2)
    (hhh : hh.IsHomogeneous 2) (hj : j.IsHomogeneous 2) :
    (residualCoeffV_poly a b c d e f hh j).IsHomogeneous 10 := by
  refine isHomogeneous_of_eval_smul fun r x => ?_
  rw [eval_residualCoeffV_poly, eval_residualCoeffV_poly]
  rw [eval_smul_point_of_isHomogeneous ha, eval_smul_point_of_isHomogeneous hb,
    eval_smul_point_of_isHomogeneous hc, eval_smul_point_of_isHomogeneous hd,
    eval_smul_point_of_isHomogeneous he, eval_smul_point_of_isHomogeneous hf,
    eval_smul_point_of_isHomogeneous hhh, eval_smul_point_of_isHomogeneous hj]
  simp only [residualCoeffV]
  ring

private theorem residualCoeffW_poly_isHomogeneous_of_infinite
    {K : Type u} [Field K] [Infinite K]
    {a b c d e f hh k : MvPolynomial (Fin 3) K}
    (ha : a.IsHomogeneous 2) (hb : b.IsHomogeneous 2) (hc : c.IsHomogeneous 2)
    (hd : d.IsHomogeneous 2) (he : e.IsHomogeneous 2) (hf : f.IsHomogeneous 2)
    (hhh : hh.IsHomogeneous 2) (hk : k.IsHomogeneous 2) :
    (residualCoeffW_poly a b c d e f hh k).IsHomogeneous 10 := by
  refine isHomogeneous_of_eval_smul fun r x => ?_
  rw [eval_residualCoeffW_poly, eval_residualCoeffW_poly]
  rw [eval_smul_point_of_isHomogeneous ha, eval_smul_point_of_isHomogeneous hb,
    eval_smul_point_of_isHomogeneous hc, eval_smul_point_of_isHomogeneous hd,
    eval_smul_point_of_isHomogeneous he, eval_smul_point_of_isHomogeneous hf,
    eval_smul_point_of_isHomogeneous hhh, eval_smul_point_of_isHomogeneous hk]
  simp only [residualCoeffW]
  ring

theorem residualCoeffU_poly_isHomogeneous
    {K : Type u} [Field K]
    {a b c d e f hh i : MvPolynomial (Fin 3) K}
    (ha : a.IsHomogeneous 2) (hb : b.IsHomogeneous 2) (hc : c.IsHomogeneous 2)
    (hd : d.IsHomogeneous 2) (he : e.IsHomogeneous 2) (hf : f.IsHomogeneous 2)
    (hhh : hh.IsHomogeneous 2) (hi : i.IsHomogeneous 2) :
    (residualCoeffU_poly a b c d e f hh i).IsHomogeneous 10 := by
  classical
  set φ : K →+* AlgebraicClosure K := algebraMap K (AlgebraicClosure K) with hφ
  refine isHomogeneous_of_map_isHomogeneous φ (algebraMap K _).injective ?_
  rw [← map_residualCoeffU_poly φ]
  exact residualCoeffU_poly_isHomogeneous_of_infinite (ha.map φ) (hb.map φ) (hc.map φ)
    (hd.map φ) (he.map φ) (hf.map φ) (hhh.map φ) (hi.map φ)

theorem residualCoeffV_poly_isHomogeneous
    {K : Type u} [Field K]
    {a b c d e f hh j : MvPolynomial (Fin 3) K}
    (ha : a.IsHomogeneous 2) (hb : b.IsHomogeneous 2) (hc : c.IsHomogeneous 2)
    (hd : d.IsHomogeneous 2) (he : e.IsHomogeneous 2) (hf : f.IsHomogeneous 2)
    (hhh : hh.IsHomogeneous 2) (hj : j.IsHomogeneous 2) :
    (residualCoeffV_poly a b c d e f hh j).IsHomogeneous 10 := by
  classical
  set φ : K →+* AlgebraicClosure K := algebraMap K (AlgebraicClosure K) with hφ
  refine isHomogeneous_of_map_isHomogeneous φ (algebraMap K _).injective ?_
  rw [← map_residualCoeffV_poly φ]
  exact residualCoeffV_poly_isHomogeneous_of_infinite (ha.map φ) (hb.map φ) (hc.map φ)
    (hd.map φ) (he.map φ) (hf.map φ) (hhh.map φ) (hj.map φ)

theorem residualCoeffW_poly_isHomogeneous
    {K : Type u} [Field K]
    {a b c d e f hh k : MvPolynomial (Fin 3) K}
    (ha : a.IsHomogeneous 2) (hb : b.IsHomogeneous 2) (hc : c.IsHomogeneous 2)
    (hd : d.IsHomogeneous 2) (he : e.IsHomogeneous 2) (hf : f.IsHomogeneous 2)
    (hhh : hh.IsHomogeneous 2) (hk : k.IsHomogeneous 2) :
    (residualCoeffW_poly a b c d e f hh k).IsHomogeneous 10 := by
  classical
  set φ : K →+* AlgebraicClosure K := algebraMap K (AlgebraicClosure K) with hφ
  refine isHomogeneous_of_map_isHomogeneous φ (algebraMap K _).injective ?_
  rw [← map_residualCoeffW_poly φ]
  exact residualCoeffW_poly_isHomogeneous_of_infinite (ha.map φ) (hb.map φ) (hc.map φ)
    (hd.map φ) (he.map φ) (hf.map φ) (hhh.map φ) (hk.map φ)

/-! ### Degree ten for the residual-line coefficients -/

theorem residualCoeffU_of_isHomogeneous
    {K : Type u} [Field K]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F) :
    (residualCoeffU_of F).IsHomogeneous 10 := by
  let c := cubicCoefficients F
  exact residualCoeffU_poly_isHomogeneous
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨0, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨1, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨2, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨3, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨4, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨5, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨6, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨7, by omega⟩)

theorem residualCoeffV_of_isHomogeneous
    {K : Type u} [Field K]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F) :
    (residualCoeffV_of F).IsHomogeneous 10 := by
  exact residualCoeffV_poly_isHomogeneous
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨0, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨1, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨2, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨3, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨4, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨5, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨6, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨8, by omega⟩)

theorem residualCoeffW_of_isHomogeneous
    {K : Type u} [Field K]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F) :
    (residualCoeffW_of F).IsHomogeneous 10 := by
  exact residualCoeffW_poly_isHomogeneous
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨0, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨1, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨2, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨3, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨4, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨5, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨6, by omega⟩)
    (cubicCoefficients_isHomogeneous_of_bidegree23 hF ⟨9, by omega⟩)

/-! ### Lifting an ordinary homogeneous form into the first Cox block -/

private theorem IsWeightedHomogeneous.aeval_preserves_weights
    {R : Type u} [CommSemiring R] {σ τ M : Type*} [AddCommMonoid M]
    {w : σ → M} {v : τ → M} {P : MvPolynomial σ R} {d : M}
    (hP : P.IsWeightedHomogeneous w d) (g : σ → MvPolynomial τ R)
    (hg : ∀ i, (g i).IsWeightedHomogeneous v (w i)) :
    (aeval g P).IsWeightedHomogeneous v d := by
  rw [aeval_def]
  apply IsWeightedHomogeneous.sum
  intro s hs
  rw [← zero_add d]
  apply (isWeightedHomogeneous_C v _).mul
  convert IsWeightedHomogeneous.prod s.support (fun i => g i ^ s i)
      (fun i => s i • w i) (fun i _ => (hg i).pow (s i)) using 1
  · simp only [Finsupp.prod]
  · rw [← hP (mem_support_iff.mp hs), Finsupp.weight_apply]
    simp only [Finsupp.sum]

private theorem isWeightedHomogeneous_pair_left_of_isHomogeneous
    {R : Type u} [CommSemiring R] {σ : Type*} {p : MvPolynomial σ R} {d : ℕ}
    (hp : p.IsHomogeneous d) :
    p.IsWeightedHomogeneous (fun _ => (1, 0)) (d, 0) := by
  classical
  intro s hs
  have hdeg : s.degree = d := by
    rw [Finsupp.degree_eq_weight_one]
    exact hp hs
  rw [Finsupp.weight_apply, Finsupp.sum]
  apply Prod.ext
  · simp only [Prod.fst_sum, Prod.smul_mk, smul_eq_mul, mul_one]
    rwa [← Finsupp.degree_apply]
  · simp only [Prod.snd_sum, Prod.smul_mk, smul_eq_mul, mul_zero, Finset.sum_const_zero]

theorem liftFirstBlock_isBihomogeneous
    {K : Type u} [CommRing K] {p : MvPolynomial (Fin 3) K} {d : ℕ}
    (hp : p.IsHomogeneous d) :
    IsBihomogeneousOfBidegree d 0 (liftFirstBlock p) := by
  rw [liftFirstBlock, rename_eq_aeval]
  apply IsWeightedHomogeneous.aeval_preserves_weights
    (isWeightedHomogeneous_pair_left_of_isHomogeneous hp)
  intro i
  exact isWeightedHomogeneous_X K bidegreeWeight (.inl i)

theorem liftSecondLinear_isBihomogeneous
    {K : Type u} [CommRing K] {p : MvPolynomial (Fin 3) K} {d : ℕ}
    (hp : p.IsHomogeneous d) (j : Fin 3) :
    IsBihomogeneousOfBidegree d 1 (liftSecondLinear p j) := by
  unfold liftSecondLinear
  simpa [IsBihomogeneousOfBidegree, bidegreeWeight] using
    (liftFirstBlock_isBihomogeneous hp).mul
      (isWeightedHomogeneous_X K bidegreeWeight (.inr j))

/-- The residual divisor equation of a bidegree-`(2,3)` form has bidegree `(10,1)`. -/
theorem residualEquation_isBihomogeneous
    {K : Type u} [Field K]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F) :
    IsBihomogeneousOfBidegree 10 1 (residualEquation F) := by
  unfold residualEquation
  exact
    ((liftSecondLinear_isBihomogeneous (residualCoeffU_of_isHomogeneous hF) 0).add
      (liftSecondLinear_isBihomogeneous (residualCoeffV_of_isHomogeneous hF) 1)).add
      (liftSecondLinear_isBihomogeneous (residualCoeffW_of_isHomogeneous hF) 2)

/-! ### Transport to an arbitrary line frame -/

theorem secondBlockSubst_isBihomogeneous
    {K : Type u} [CommRing K] {a b : ℕ}
    (M : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K}
    (hF : IsBihomogeneousOfBidegree a b F) :
    IsBihomogeneousOfBidegree a b (secondBlockSubst M F) := by
  unfold secondBlockSubst
  apply IsWeightedHomogeneous.aeval_preserves_weights hF
  rintro (i | j)
  · exact isWeightedHomogeneous_X K bidegreeWeight (.inl i)
  · refine IsWeightedHomogeneous.sum Finset.univ _ _ fun l _ => ?_
    simpa [bidegreeWeight] using
      (isWeightedHomogeneous_C bidegreeWeight (M j l)).mul
        (isWeightedHomogeneous_X K bidegreeWeight (.inr l))

/-- The arbitrary-frame residual equation retains bidegree `(10,1)`. -/
theorem residualEquationOn_isBihomogeneous
    {K : Type u} [Field K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F) :
    IsBihomogeneousOfBidegree 10 1 (residualEquationOn M N F) := by
  unfold residualEquationOn
  exact secondBlockSubst_isBihomogeneous N
    (residualEquation_isBihomogeneous (secondBlockSubst_isBihomogeneous M hF))

/-! ### Coefficients of a general bihomogeneous form -/

theorem secondBlockCoeff_isHomogeneous_of_bidegree
    {R : Type u} [CommRing R] {a b : ℕ}
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBihomogeneousOfBidegree a b F) (m : Fin 3 →₀ ℕ) :
    (secondBlockCoeff F m).IsHomogeneous a := by
  classical
  refine IsHomogeneous.sum _ _ _ ?_
  intro d hd
  split_ifs
  · have hdc : coeff d F ≠ 0 := MvPolynomial.mem_support_iff.mp hd
    have hdeg : Finsupp.weight bidegreeWeight d = (a, b) := hF hdc
    have hleft : Finsupp.weight leftDegreeWeight d = a := by
      simpa [fst_weight_bidegreeWeight] using congrArg Prod.fst hdeg
    have hfirst : (firstPart d).degree = a := by
      simpa [degree_firstPart] using hleft
    exact isHomogeneous_monomial (F.coeff d) hfirst
  · exact isHomogeneous_zero (Fin 3) R a

/-- Every coefficient of the arbitrary-line residual form is homogeneous of degree ten in `x`. -/
theorem residualLineCoeffOn_isHomogeneous
    {K : Type u} [Field K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F)
    (j : Fin 3) :
    (residualLineCoeffOn M N F j).IsHomogeneous 10 := by
  unfold residualLineCoeffOn
  exact secondBlockCoeff_isHomogeneous_of_bidegree
    (residualEquationOn_isBihomogeneous M N hF) _

end

end ResidualDivisor
end BConicBundleMultisections
