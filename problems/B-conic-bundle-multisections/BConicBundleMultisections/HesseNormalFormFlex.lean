/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HesseNormalForm
public import BConicBundleMultisections.ProjectiveCommonZero
public import BConicBundleMultisections.DeterminantHomogeneous
public import BConicBundleMultisections.PlaneCubicTangentForm
public import BConicBundleMultisections.PlaneCubicPartials
public import BConicBundleMultisections.ResidualLineBasePointFree
public import BConicBundleMultisections.LinearSubstitutionNonsingular
public import Mathlib.Algebra.MvPolynomial.Funext
public import Mathlib.LinearAlgebra.Basis.VectorSpace
public import Mathlib.LinearAlgebra.Matrix.Basis
public import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# Flex candidates and tangent-adapted bases for plane cubics

For a ternary cubic, its Hessian determinant is again a ternary cubic.  The projective common-zero
theorem therefore gives a nonzero common zero of the cubic and its Hessian over an algebraically
closed field.  If the original cubic is smooth, its tangent form at this point is nonzero.  The
linear-algebra basis-extension theorem then supplies a basis containing the point in which the
tangent functional is a coordinate functional.

The remaining local calculation in the Hesse-normal-form bridge is to turn Hessian vanishing in
this adapted basis into the missing Weierstrass-support coefficient vanishing.
-/

@[expose] public section

open MvPolynomial
open scoped Matrix
open Module

namespace BConicBundleMultisections.HesseNormalForm

universe u

variable {k : Type u} [Field k]

/-- The projective point at infinity in homogeneous Weierstrass coordinates. -/
def weierstrassInfinity : Fin 3 → k := ![0, 1, 0]

/-- The matrix of second partial derivatives of a ternary polynomial. -/
noncomputable def hessianMatrix (f : MvPolynomial (Fin 3) k) :
    Matrix (Fin 3) (Fin 3) (MvPolynomial (Fin 3) k) :=
  fun i j ↦ pderiv i (pderiv j f)

/-- The Hessian determinant of a ternary polynomial. -/
noncomputable def hessian (f : MvPolynomial (Fin 3) k) : MvPolynomial (Fin 3) k :=
  (hessianMatrix f).det

/-- The Hessian determinant of a ternary cubic is homogeneous of degree three. -/
theorem hessian_isHomogeneous {f : MvPolynomial (Fin 3) k}
    (hf : f.IsHomogeneous 3) : (hessian f).IsHomogeneous 3 := by
  unfold hessian
  apply Matrix.det_isHomogeneous (hessianMatrix f) 1
  intro i j
  simpa [hessianMatrix] using (hf.pderiv (i := j)).pderiv (i := i)

/-- The numerical Hessian matrix obtained by evaluating all second partials at a point. -/
noncomputable def evaluatedHessianMatrix (f : MvPolynomial (Fin 3) k) (p : Fin 3 → k) :
    Matrix (Fin 3) (Fin 3) k :=
  fun i j ↦ eval p (hessianMatrix f i j)

/-- Evaluation of the Hessian polynomial is the determinant of the evaluated Hessian matrix. -/
theorem eval_hessian_eq_det_evaluatedHessianMatrix
    (f : MvPolynomial (Fin 3) k) (p : Fin 3 → k) :
    eval p (hessian f) = (evaluatedHessianMatrix f p).det := by
  unfold hessian evaluatedHessianMatrix
  rw [(eval p).map_det]
  congr 1

/-- The numerical Hessian matrix transforms by `Mᵀ H M` under a linear substitution. -/
theorem evaluatedHessianMatrix_aeval_linearSubst
    (M : Matrix (Fin 3) (Fin 3) k) (f : MvPolynomial (Fin 3) k) (p : Fin 3 → k) :
    evaluatedHessianMatrix
        ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) f) p =
      Mᵀ * evaluatedHessianMatrix f (M *ᵥ p) * M := by
  classical
  ext i j
  simp only [evaluatedHessianMatrix, hessianMatrix]
  rw [pderiv_aeval_linearSubst 2 M f j, map_sum]
  simp only [Derivation.leibniz, pderiv_C, smul_eq_mul, mul_zero, zero_add]
  simp_rw [pderiv_aeval_linearSubst 2 M]
  simp only [map_sum, map_mul, eval_C]
  simp only [evaluatedHessianMatrix, hessianMatrix, Matrix.mul_apply,
    Matrix.transpose_apply]
  refine Finset.sum_congr rfl fun a _ ↦ ?_
  rw [mul_comm (M a j)]
  apply congrArg (fun z : k ↦ z * M a j)
  refine Finset.sum_congr rfl fun b _ ↦ ?_
  rw [eval_aeval_linearSubst]
  ring

/-- The Hessian determinant transforms by the square of the determinant of the coordinate matrix. -/
theorem eval_hessian_aeval_linearSubst
    (M : Matrix (Fin 3) (Fin 3) k) (f : MvPolynomial (Fin 3) k) (p : Fin 3 → k) :
    eval p (hessian
      ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) f)) =
      M.det ^ 2 * eval (M *ᵥ p) (hessian f) := by
  rw [eval_hessian_eq_det_evaluatedHessianMatrix,
    evaluatedHessianMatrix_aeval_linearSubst,
    Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose,
    ← eval_hessian_eq_det_evaluatedHessianMatrix]
  ring

/-- A ternary cubic and its Hessian have a common nonzero projective zero over an algebraically
closed field.  Smoothness is not needed for this existence statement. -/
theorem exists_cubic_hessian_common_nonzero_zero [IsAlgClosed k]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    ∃ p : Fin 3 → k, p ≠ 0 ∧ eval p f = 0 ∧ eval p (hessian f) = 0 := by
  exact exists_common_nonzero_zero_pair hf (hessian_isHomogeneous hf)
    (by norm_num) (by norm_num) (by simp)

/-- The tangent functional at a point, bundled as a linear map on coordinate vectors. -/
noncomputable def tangentLinearMap (f : MvPolynomial (Fin 3) k) (p : Fin 3 → k) :
    (Fin 3 → k) →ₗ[k] k :=
  (dotProductBilin k k) (fun i ↦ eval p (pderiv i f))

@[simp]
theorem tangentLinearMap_apply (f : MvPolynomial (Fin 3) k) (p q : Fin 3 → k) :
    tangentLinearMap f p q = eval q (tangentForm f p) := by
  simp [tangentLinearMap, dotProductBilin, dotProduct, eval_tangentForm]

/-- A point on a homogeneous cubic is killed by its tangent functional. -/
theorem tangentLinearMap_self_eq_zero {f : MvPolynomial (Fin 3) k}
    (hf : f.IsHomogeneous 3) {p : Fin 3 → k} (hp : eval p f = 0) :
    tangentLinearMap f p p = 0 := by
  rw [tangentLinearMap_apply]
  exact eval_tangentForm_self_eq_zero hf hp

/-- At a smooth point, the tangent functional is nonzero. -/
theorem tangentLinearMap_ne_zero_of_smooth
    {f : MvPolynomial (Fin 3) k} (hsmooth : Standard.IsSmoothPlaneCubic f)
    {p : Fin 3 → k} (hp0 : p ≠ 0) (hpf : eval p f = 0) :
    tangentLinearMap f p ≠ 0 := by
  classical
  obtain ⟨i, hi⟩ := hsmooth.2 p hp0 hpf
  intro hzero
  have happly : tangentLinearMap f p (Pi.single i 1) = 0 := by rw [hzero]; simp
  have hi0 : eval p (pderiv i f) = 0 := by
    change (fun j ↦ eval p (pderiv j f)) ⬝ᵥ Pi.single i 1 = 0 at happly
    simpa [dotProduct_single] using happly
  exact hi hi0

/-- The chain rule written intrinsically: the `i`-th partial after a linear substitution is the
original tangent functional applied to the `i`-th column of the substitution matrix. -/
theorem eval_pderiv_aeval_linearSubst_eq_tangentLinearMap
    (M : Matrix (Fin 3) (Fin 3) k) (f : MvPolynomial (Fin 3) k)
    (q : Fin 3 → k) (i : Fin 3) :
    eval q (pderiv i
      ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) f)) =
      tangentLinearMap f (M *ᵥ q) (M.col i) := by
  rw [eval_pderiv_aeval_linearSubst]
  simp [tangentLinearMap, dotProductBilin, dotProduct, Matrix.col_apply, mul_comm]

/-- A smooth point admits a basis containing that point in which its tangent functional is a
different coordinate functional. -/
theorem exists_tangentAdaptedBasis
    {f : MvPolynomial (Fin 3) k} (hsmooth : Standard.IsSmoothPlaneCubic f)
    {p : Fin 3 → k} (hp0 : p ≠ 0) (hpf : eval p f = 0) :
    ∃ (n : Set (Fin 3 → k)) (b : Basis n k (Fin 3 → k)) (i j : n),
      i ≠ j ∧ p = b i ∧ tangentLinearMap f p = b.coord j := by
  apply exists_basis_of_pairing_eq_zero
  · exact tangentLinearMap_self_eq_zero hsmooth.1 hpf
  · exact tangentLinearMap_ne_zero_of_smooth hsmooth hp0 hpf
  · exact hp0

/-- A tangent-adapted basis can be reindexed by `Fin 3`, with the point in slot `1` and the
tangent coordinate functional in slot `2`. -/
theorem exists_fin3_tangentAdaptedBasis
    {f : MvPolynomial (Fin 3) k} (hsmooth : Standard.IsSmoothPlaneCubic f)
    {p : Fin 3 → k} (hp0 : p ≠ 0) (hpf : eval p f = 0) :
    ∃ b : Basis (Fin 3) k (Fin 3 → k),
      p = b 1 ∧ tangentLinearMap f p = b.coord 2 := by
  obtain ⟨n, b, i, j, hij, hpi, htangent⟩ :=
    exists_tangentAdaptedBasis hsmooth hp0 hpf
  letI : Fintype n := FiniteDimensional.fintypeBasisIndex b
  have hcard : Fintype.card n = 3 := by
    rw [← Module.finrank_eq_card_basis b]
    simp
  let e0 : Fin 3 ≃ n := Fintype.equivOfCardEq (by simpa using hcard.symm)
  let a : Fin 3 := e0.symm i
  let c : Fin 3 := e0.symm j
  have hac : a ≠ c := by
    intro h
    apply hij
    simpa [a, c] using congrArg e0 h
  let src : Fin 2 → Fin 3 := fun x ↦ x.succ
  let dst : Fin 2 → Fin 3 := ![a, c]
  have hsrc : Function.Injective src := Fin.succ_injective 2
  have hdst : Function.Injective dst := by
    intro x y hxy
    fin_cases x <;> fin_cases y <;> simp_all [dst]
  obtain ⟨σ, hσ⟩ := Equiv.Perm.exists_extending_pair src dst hsrc hdst
  let e : Fin 3 ≃ n := σ.trans e0
  let b' : Basis (Fin 3) k (Fin 3 → k) := b.reindex e.symm
  refine ⟨b', ?_, ?_⟩
  · rw [hpi]
    have hei : e 1 = i := by
      simpa [e, src, dst, a] using congrArg e0 (hσ 0)
    simp [b', hei]
  · rw [htangent]
    ext x
    have hej : e 2 = j := by
      simpa [e, src, dst, c] using congrArg e0 (hσ 1)
    simp [b', Basis.coord_apply, hej]

/-- Matrix form of a tangent-adapted basis.  The matrix and its displayed inverse send the
Weierstrass point at infinity to `p`; their columns `0` and `2` have tangent values `0` and `1`.
These are exactly the two gradient normalizations used below. -/
theorem exists_tangentAdaptedCoordinates
    {f : MvPolynomial (Fin 3) k} (hsmooth : Standard.IsSmoothPlaneCubic f)
    {p : Fin 3 → k} (hp0 : p ≠ 0) (hpf : eval p f = 0) :
    ∃ M N : Matrix (Fin 3) (Fin 3) k,
      M * N = 1 ∧ N * M = 1 ∧
      M *ᵥ weierstrassInfinity = p ∧
      tangentLinearMap f p (M.col 0) = 0 ∧
      tangentLinearMap f p (M.col 2) = 1 := by
  obtain ⟨b, hp, htangent⟩ := exists_fin3_tangentAdaptedBasis hsmooth hp0 hpf
  let std : Basis (Fin 3) k (Fin 3 → k) := Pi.basisFun k (Fin 3)
  let M : Matrix (Fin 3) (Fin 3) k := std.toMatrix b
  let N : Matrix (Fin 3) (Fin 3) k := b.toMatrix std
  have hcol (i : Fin 3) : M.col i = b i := by
    funext a
    simp [M, std, Basis.toMatrix_apply, Pi.basisFun_repr]
  refine ⟨M, N, ?_, ?_, ?_, ?_, ?_⟩
  · exact Basis.toMatrix_mul_toMatrix_flip std b
  · exact Basis.toMatrix_mul_toMatrix_flip b std
  · rw [hp]
    have hinf : weierstrassInfinity (k := k) = Pi.single 1 1 := by
      funext i
      fin_cases i <;> simp [weierstrassInfinity]
    rw [hinf, Matrix.mulVec_single_one, hcol]
  · rw [hcol, htangent]
    simp [Basis.coord_apply]
  · rw [hcol, htangent]
    simp [Basis.coord_apply]

/-- Every smooth ternary cubic over an algebraically closed field has a Hessian-zero point and a
tangent-adapted basis at that point. -/
theorem exists_hessianZero_tangentAdaptedBasis [IsAlgClosed k]
    (f : MvPolynomial (Fin 3) k) (hsmooth : Standard.IsSmoothPlaneCubic f) :
    ∃ (p : Fin 3 → k) (n : Set (Fin 3 → k))
        (b : Basis n k (Fin 3 → k)) (i j : n),
      p ≠ 0 ∧ eval p f = 0 ∧ eval p (hessian f) = 0 ∧
        i ≠ j ∧ p = b i ∧ tangentLinearMap f p = b.coord j := by
  obtain ⟨p, hp0, hpf, hpH⟩ := exists_cubic_hessian_common_nonzero_zero f hsmooth.1
  obtain ⟨n, b, i, j, hij, hpi, htangent⟩ :=
    exists_tangentAdaptedBasis hsmooth hp0 hpf
  exact ⟨p, n, b, i, j, hp0, hpf, hpH, hij, hpi, htangent⟩

/-! ### The local Hessian calculation in Weierstrass coordinates -/

@[simp]
theorem eval_weierstrassInfinity_eq_coeffV3
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) f = PlaneCubicResidual.coeffV3 f := by
  rw [PlaneCubicResidual.eval_eq_planeCubicValue hf]
  simp [weierstrassInfinity, UniversalResidual.planeCubicValue]

@[simp]
theorem eval_pderiv_zero_weierstrassInfinity
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (pderiv 0 f) =
      PlaneCubicResidual.coeffUV2 f := by
  rw [PlaneCubicResidual.eval_pderiv0_planeCubic f hf]
  simp [weierstrassInfinity]

@[simp]
theorem eval_pderiv_two_weierstrassInfinity
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (pderiv 2 f) =
      PlaneCubicResidual.coeffV2W f := by
  rw [PlaneCubicResidual.eval_pderiv2_planeCubic f hf]
  simp [weierstrassInfinity]

set_option maxRecDepth 10000
set_option maxHeartbeats 1000000

/-- The first partial derivative written as a quadratic in the ten standard cubic coefficients. -/
noncomputable def pderivZeroNormalForm (f : MvPolynomial (Fin 3) k) :
    MvPolynomial (Fin 3) k :=
  C (3 * PlaneCubicResidual.coeffU3 f) * X 0 ^ 2 +
    C (2 * PlaneCubicResidual.coeffU2V f) * X 0 * X 1 +
    C (PlaneCubicResidual.coeffUV2 f) * X 1 ^ 2 +
    X 2 * (C (2 * PlaneCubicResidual.coeffU2W f) * X 0 +
      C (PlaneCubicResidual.coeffUVW f) * X 1) +
    C (PlaneCubicResidual.coeffUW2 f) * X 2 ^ 2

/-- The second partial derivative written as a quadratic in the ten standard cubic coefficients. -/
noncomputable def pderivOneNormalForm (f : MvPolynomial (Fin 3) k) :
    MvPolynomial (Fin 3) k :=
  C (PlaneCubicResidual.coeffU2V f) * X 0 ^ 2 +
    C (2 * PlaneCubicResidual.coeffUV2 f) * X 0 * X 1 +
    C (3 * PlaneCubicResidual.coeffV3 f) * X 1 ^ 2 +
    X 2 * (C (PlaneCubicResidual.coeffUVW f) * X 0 +
      C (2 * PlaneCubicResidual.coeffV2W f) * X 1) +
    C (PlaneCubicResidual.coeffVW2 f) * X 2 ^ 2

/-- The third partial derivative written as a quadratic in the ten standard cubic coefficients. -/
noncomputable def pderivTwoNormalForm (f : MvPolynomial (Fin 3) k) :
    MvPolynomial (Fin 3) k :=
  C (PlaneCubicResidual.coeffU2W f) * X 0 ^ 2 +
    C (PlaneCubicResidual.coeffUVW f) * X 0 * X 1 +
    C (PlaneCubicResidual.coeffV2W f) * X 1 ^ 2 +
    X 2 * (C (2 * PlaneCubicResidual.coeffUW2 f) * X 0 +
      C (2 * PlaneCubicResidual.coeffVW2 f) * X 1) +
    C (3 * PlaneCubicResidual.coeffW3 f) * X 2 ^ 2

theorem pderiv_zero_eq_normalForm [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    pderiv 0 f = pderivZeroNormalForm f := by
  apply MvPolynomial.funext
  intro q
  rw [PlaneCubicResidual.eval_pderiv0_planeCubic f hf]
  simp [pderivZeroNormalForm]
  try ring

theorem pderiv_one_eq_normalForm [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    pderiv 1 f = pderivOneNormalForm f := by
  apply MvPolynomial.funext
  intro q
  rw [PlaneCubicResidual.eval_pderiv1_planeCubic f hf]
  simp [pderivOneNormalForm]
  try ring

theorem pderiv_two_eq_normalForm [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    pderiv 2 f = pderivTwoNormalForm f := by
  apply MvPolynomial.funext
  intro q
  rw [PlaneCubicResidual.eval_pderiv2_planeCubic f hf]
  simp [pderivTwoNormalForm]

theorem eval_hessianMatrix_zero_zero [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (hessianMatrix f 0 0) =
      2 * PlaneCubicResidual.coeffU2V f := by
  unfold hessianMatrix
  rw [pderiv_zero_eq_normalForm f hf]
  simp [pderivZeroNormalForm, weierstrassInfinity]
  try ring

theorem eval_hessianMatrix_zero_one [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (hessianMatrix f 0 1) =
      2 * PlaneCubicResidual.coeffUV2 f := by
  unfold hessianMatrix
  rw [pderiv_one_eq_normalForm f hf]
  simp [pderivOneNormalForm, weierstrassInfinity]
  try ring

theorem eval_hessianMatrix_zero_two [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (hessianMatrix f 0 2) =
      PlaneCubicResidual.coeffUVW f := by
  unfold hessianMatrix
  rw [pderiv_two_eq_normalForm f hf]
  simp [pderivTwoNormalForm, weierstrassInfinity]
  try ring

theorem eval_hessianMatrix_one_zero [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (hessianMatrix f 1 0) =
      2 * PlaneCubicResidual.coeffUV2 f := by
  unfold hessianMatrix
  rw [pderiv_zero_eq_normalForm f hf]
  simp [pderivZeroNormalForm, weierstrassInfinity]
  ring

theorem eval_hessianMatrix_one_one [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (hessianMatrix f 1 1) =
      6 * PlaneCubicResidual.coeffV3 f := by
  unfold hessianMatrix
  rw [pderiv_one_eq_normalForm f hf]
  simp [pderivOneNormalForm, weierstrassInfinity]
  ring

theorem eval_hessianMatrix_one_two [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (hessianMatrix f 1 2) =
      2 * PlaneCubicResidual.coeffV2W f := by
  unfold hessianMatrix
  rw [pderiv_two_eq_normalForm f hf]
  simp [pderivTwoNormalForm, weierstrassInfinity]
  ring

theorem eval_hessianMatrix_two_zero [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (hessianMatrix f 2 0) =
      PlaneCubicResidual.coeffUVW f := by
  unfold hessianMatrix
  rw [pderiv_zero_eq_normalForm f hf]
  simp [pderivZeroNormalForm, weierstrassInfinity]

theorem eval_hessianMatrix_two_one [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (hessianMatrix f 2 1) =
      2 * PlaneCubicResidual.coeffV2W f := by
  unfold hessianMatrix
  rw [pderiv_one_eq_normalForm f hf]
  simp [pderivOneNormalForm, weierstrassInfinity]

theorem eval_hessianMatrix_two_two [NeZero (2 : k)] [NeZero (3 : k)]
    (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (hessianMatrix f 2 2) =
      2 * PlaneCubicResidual.coeffVW2 f := by
  unfold hessianMatrix
  rw [pderiv_two_eq_normalForm f hf]
  simp [pderivTwoNormalForm, weierstrassInfinity]

/-- Evaluation of the cubic Hessian at the Weierstrass point at infinity, in terms of the six
coefficients which can contribute there. -/
theorem eval_hessian_weierstrassInfinity
    [NeZero (2 : k)] [NeZero (3 : k)] (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3) :
    eval (weierstrassInfinity (k := k)) (hessian f) =
      24 * PlaneCubicResidual.coeffU2V f * PlaneCubicResidual.coeffV3 f *
          PlaneCubicResidual.coeffVW2 f
        - 8 * PlaneCubicResidual.coeffU2V f * PlaneCubicResidual.coeffV2W f ^ 2
        - 8 * PlaneCubicResidual.coeffUV2 f ^ 2 * PlaneCubicResidual.coeffVW2 f
        + 8 * PlaneCubicResidual.coeffUV2 f * PlaneCubicResidual.coeffV2W f *
            PlaneCubicResidual.coeffUVW f
        - 6 * PlaneCubicResidual.coeffV3 f * PlaneCubicResidual.coeffUVW f ^ 2 := by
  unfold hessian
  rw [Matrix.det_fin_three]
  simp only [map_sub, map_add, map_mul]
  rw [eval_hessianMatrix_zero_zero f hf, eval_hessianMatrix_one_one f hf,
    eval_hessianMatrix_two_two f hf, eval_hessianMatrix_one_two f hf,
    eval_hessianMatrix_two_one f hf, eval_hessianMatrix_zero_one f hf,
    eval_hessianMatrix_one_zero f hf, eval_hessianMatrix_zero_two f hf,
    eval_hessianMatrix_two_zero f hf]
  ring

/-- At a Hessian-zero point normalized to `(0:1:0)` with tangent functional `Z`, the three
non-Weierstrass coefficients vanish and the coefficient of `Y²Z` is one. -/
theorem normalized_hessianZero_coefficients
    [NeZero (2 : k)] [NeZero (3 : k)] (f : MvPolynomial (Fin 3) k) (hf : f.IsHomogeneous 3)
    (hpoint : eval (weierstrassInfinity (k := k)) f = 0)
    (hgradX : eval (weierstrassInfinity (k := k)) (pderiv 0 f) = 0)
    (hgradZ : eval (weierstrassInfinity (k := k)) (pderiv 2 f) = 1)
    (hhessian : eval (weierstrassInfinity (k := k)) (hessian f) = 0) :
    PlaneCubicResidual.coeffV3 f = 0 ∧
      PlaneCubicResidual.coeffUV2 f = 0 ∧
      PlaneCubicResidual.coeffV2W f = 1 ∧
      PlaneCubicResidual.coeffU2V f = 0 := by
  have hV3 : PlaneCubicResidual.coeffV3 f = 0 := by
    rwa [eval_weierstrassInfinity_eq_coeffV3 f hf] at hpoint
  have hUV2 : PlaneCubicResidual.coeffUV2 f = 0 := by
    rwa [eval_pderiv_zero_weierstrassInfinity f hf] at hgradX
  have hV2W : PlaneCubicResidual.coeffV2W f = 1 := by
    rwa [eval_pderiv_two_weierstrassInfinity f hf] at hgradZ
  have hH := eval_hessian_weierstrassInfinity f hf
  rw [hhessian, hV3, hUV2, hV2W] at hH
  norm_num at hH
  exact ⟨hV3, hUV2, hV2W, hH⟩

/-- On the coordinate line `X₂ = 0`, the product `X₂ Q` and its first two partials vanish;
its last partial is the restriction of `Q`. -/
theorem eval_X2_mul_partials_on_X2_zero
    (Q : MvPolynomial (Fin 3) k) (a b : k) :
    eval ![a, b, (0 : k)] (X (2 : Fin 3) * Q) = 0 ∧
      eval ![a, b, (0 : k)] (pderiv 0 (X (2 : Fin 3) * Q)) = 0 ∧
        eval ![a, b, (0 : k)] (pderiv 1 (X (2 : Fin 3) * Q)) = 0 ∧
          eval ![a, b, (0 : k)] (pderiv 2 (X (2 : Fin 3) * Q)) =
            eval ![a, b, (0 : k)] Q := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · simp [eval_mul, eval_X]
  · rw [Derivation.leibniz, pderiv_X]
    simp [eval_mul, eval_X, smul_eq_mul]
  · rw [Derivation.leibniz, pderiv_X]
    simp [eval_mul, eval_X, smul_eq_mul]
  · rw [Derivation.leibniz, pderiv_X]
    simp [eval_mul, eval_X, smul_eq_mul]

/-- A smooth cubic cannot have all four coefficients of its restriction to `X₂ = 0` equal to
zero.  Otherwise it is `X₂ Q`; a binary factor of `Q|_{X₂=0}` gives an explicit nonzero
singular point on the line. -/
theorem coeffU3_ne_zero_of_smooth_of_lineSupport [IsAlgClosed k]
    (G : MvPolynomial (Fin 3) k) (hG : G.IsHomogeneous 3)
    (hns : ∀ r : Fin 3 → k, r ≠ 0 → eval r G = 0 →
      ∃ i : Fin 3, eval r (pderiv i G) ≠ 0)
    (hb : PlaneCubicResidual.coeffU2V G = 0)
    (hc : PlaneCubicResidual.coeffUV2 G = 0)
    (hd : PlaneCubicResidual.coeffV3 G = 0) :
    PlaneCubicResidual.coeffU3 G ≠ 0 := by
  intro ha
  let a := PlaneCubicResidual.coeffU2W G
  let b := PlaneCubicResidual.coeffUVW G
  let c := PlaneCubicResidual.coeffV2W G
  let Q : MvPolynomial (Fin 3) k :=
    C a * X 0 ^ 2 + C b * X 0 * X 1 + C c * X 1 ^ 2 +
      C (PlaneCubicResidual.coeffUW2 G) * X 0 * X 2 +
      C (PlaneCubicResidual.coeffVW2 G) * X 1 * X 2 +
      C (PlaneCubicResidual.coeffW3 G) * X 2 ^ 2
  have hGQ : G = X 2 * Q := by
    simpa [Q, a, b, c] using
      PlaneCubicResidual.eq_X2_mul_of_lineRestriction_eq_zero G hG ha hb hc hd
  by_cases habc : a = 0 ∧ b = 0 ∧ c = 0
  · obtain ⟨ha0, hb0, hc0⟩ := habc
    let r : Fin 3 → k := ![1, 0, 0]
    have hr0 : r ≠ 0 := by
      intro h
      exact one_ne_zero (α := k) (by simpa [r] using congrFun h 0)
    have hQ0 : eval r Q = 0 := by
      simp [Q, r, a, b, c, ha0, hb0, hc0]
    have hpartials := eval_X2_mul_partials_on_X2_zero Q (1 : k) 0
    have hrG : eval r G = 0 := by
      rw [hGQ]
      simpa [r] using hpartials.1
    have hsing : ∀ i : Fin 3, eval r (pderiv i G) = 0 := by
      intro i
      rw [hGQ]
      fin_cases i
      · simpa [r] using hpartials.2.1
      · simpa [r] using hpartials.2.2.1
      · simpa [r, hQ0] using hpartials.2.2.2
    obtain ⟨i, hi⟩ := hns r hr0 hrG
    exact hi (hsing i)
  · obtain ⟨s₁, t₁, s₂, t₂, h₁, _h₂, ha', hb', hc'⟩ :=
      PlaneCubicResidual.exists_binaryQuadratic_split a b c habc
    let r : Fin 3 → k := ![-t₁, s₁, 0]
    have hr0 : r ≠ 0 := by
      intro h
      rcases h₁ with hs₁ | ht₁
      · exact hs₁ (by simpa [r] using congrFun h 1)
      · exact ht₁ (neg_eq_zero.mp (by simpa [r] using congrFun h 0))
    have hq : a * (-t₁) ^ 2 + b * ((-t₁) * s₁) + c * s₁ ^ 2 = 0 := by
      rw [ha', hb', hc']
      ring
    have hQ0 : eval r Q = 0 := by
      simp [Q, r, a, b, c]
      linear_combination hq
    have hpartials := eval_X2_mul_partials_on_X2_zero Q (-t₁) s₁
    have hrG : eval r G = 0 := by
      rw [hGQ]
      simpa [r] using hpartials.1
    have hsing : ∀ i : Fin 3, eval r (pderiv i G) = 0 := by
      intro i
      rw [hGQ]
      fin_cases i
      · simpa [r] using hpartials.2.1
      · simpa [r] using hpartials.2.2.1
      · simpa [r, hQ0] using hpartials.2.2.2
    obtain ⟨i, hi⟩ := hns r hr0 hrG
    exact hi (hsing i)

/-- Every smooth ternary cubic over an algebraically closed characteristic-zero field admits an
invertible projective coordinate matrix in which the point at infinity is a flex, its tangent is
`Z = 0`, and the four non-Weierstrass support coefficients have the normalized values
`Y³ = XY² = X²Y = 0` and `Y²Z = 1`.

This is the explicit plane-embedding endpoint missing from an abstract same-`j` comparison. -/
theorem exists_weierstrassSupport_coordinates [NeZero (2 : k)] [NeZero (3 : k)] [IsAlgClosed k]
    (f : MvPolynomial (Fin 3) k) (hsmooth : Standard.IsSmoothPlaneCubic f) :
    ∃ M N : Matrix (Fin 3) (Fin 3) k,
      M * N = 1 ∧ N * M = 1 ∧
      let g :=
        (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) f
      Standard.IsSmoothPlaneCubic g ∧
        PlaneCubicResidual.coeffV3 g = 0 ∧
        PlaneCubicResidual.coeffUV2 g = 0 ∧
        PlaneCubicResidual.coeffV2W g = 1 ∧
        PlaneCubicResidual.coeffU2V g = 0 ∧
        PlaneCubicResidual.coeffU3 g ≠ 0 := by
  obtain ⟨p, hp0, hpf, hpH⟩ :=
    exists_cubic_hessian_common_nonzero_zero f hsmooth.1
  obtain ⟨M, N, hMN, hNM, hMp, htan0, htan2⟩ :=
    exists_tangentAdaptedCoordinates hsmooth hp0 hpf
  let g : MvPolynomial (Fin 3) k :=
    (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) f
  have hgHom : g.IsHomogeneous 3 := isHomogeneous_aeval_linearSubst M hsmooth.1
  have hgSmooth : Standard.IsSmoothPlaneCubic g :=
    ⟨hgHom, nonsingular_aeval_linearSubst_of_nonsingular 2 M N hMN f hsmooth.2⟩
  have hgPoint : eval (weierstrassInfinity (k := k)) g = 0 := by
    simp only [g]
    rw [eval_aeval_linearSubst, hMp, hpf]
  have hgGrad0 : eval (weierstrassInfinity (k := k)) (pderiv 0 g) = 0 := by
    simp only [g]
    rw [eval_pderiv_aeval_linearSubst_eq_tangentLinearMap, hMp, htan0]
  have hgGrad2 : eval (weierstrassInfinity (k := k)) (pderiv 2 g) = 1 := by
    simp only [g]
    rw [eval_pderiv_aeval_linearSubst_eq_tangentLinearMap, hMp, htan2]
  have hgHessian : eval (weierstrassInfinity (k := k)) (hessian g) = 0 := by
    simp only [g]
    rw [eval_hessian_aeval_linearSubst, hMp, hpH, mul_zero]
  obtain ⟨hV3, hUV2, hV2W, hU2V⟩ :=
    normalized_hessianZero_coefficients g hgHom hgPoint hgGrad0 hgGrad2 hgHessian
  have hU3 : PlaneCubicResidual.coeffU3 g ≠ 0 :=
    coeffU3_ne_zero_of_smooth_of_lineSupport g hgHom hgSmooth.2 hU2V hUV2 hV3
  exact ⟨M, N, hMN, hNM, hgSmooth, hV3, hUV2, hV2W, hU2V, hU3⟩

end BConicBundleMultisections.HesseNormalForm
