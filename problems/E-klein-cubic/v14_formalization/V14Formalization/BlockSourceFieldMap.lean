module

public import V14Formalization.BlockSemidirectConstructor

noncomputable section
open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry BigOperators
namespace V14Formalization.SchemeGeometry
open AlgebraicGeometry BConicBundleMultisections Module
universe u
variable {Omega : Type u} [Field Omega]

theorem block_submatrix_plus_plus
    (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
    (i j : Fin (p + 1)) :
    ((Matrix.fromBlocks A 0 0 B).submatrix
      (plusMinusFinEquiv p q).symm (plusMinusFinEquiv p q).symm)
      (plusMinusFinEquiv p q (Sum.inl i))
      (plusMinusFinEquiv p q (Sum.inl j)) = A i j := by
  simp

theorem block_submatrix_plus_minus
    (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
    (i : Fin (p + 1)) (j : Fin (q + 1)) :
    ((Matrix.fromBlocks A 0 0 B).submatrix
      (plusMinusFinEquiv p q).symm (plusMinusFinEquiv p q).symm)
      (plusMinusFinEquiv p q (Sum.inl i))
      (plusMinusFinEquiv p q (Sum.inr j)) = 0 := by
  simp

theorem block_submatrix_minus_plus
    (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
    (i : Fin (q + 1)) (j : Fin (p + 1)) :
    ((Matrix.fromBlocks A 0 0 B).submatrix
      (plusMinusFinEquiv p q).symm (plusMinusFinEquiv p q).symm)
      (plusMinusFinEquiv p q (Sum.inr i))
      (plusMinusFinEquiv p q (Sum.inl j)) = 0 := by
  simp

theorem block_submatrix_minus_minus
    (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
    (i j : Fin (q + 1)) :
    ((Matrix.fromBlocks A 0 0 B).submatrix
      (plusMinusFinEquiv p q).symm (plusMinusFinEquiv p q).symm)
      (plusMinusFinEquiv p q (Sum.inr i))
      (plusMinusFinEquiv p q (Sum.inr j)) = B i j := by
  simp

theorem plusMinusFinEquiv_plus_zero (p q : ℕ) :
    plusMinusFinEquiv p q (Sum.inl (0 : Fin (p + 1))) = 0 := by
  unfold plusMinusFinEquiv finSumFinEquiv
  dsimp only [Equiv.trans_apply, Equiv.cast_apply, Equiv.coe_fn_mk, Sum.elim_inl]
  rw [cast_eq_iff_heq, Fin.heq_ext_iff]
  simp
  omega

theorem plusMinusFinEquiv_plus_succ (p q : ℕ) (i : Fin p) :
    plusMinusFinEquiv p q (Sum.inl i.succ) =
      (0 : Fin ((p + q + 1) + 1)).succAbove (orderedPlusIndex p q i) := by
  unfold plusMinusFinEquiv finSumFinEquiv
  dsimp only [Equiv.trans_apply, Equiv.cast_apply, Equiv.coe_fn_mk, Sum.elim_inl]
  rw [cast_eq_iff_heq, Fin.heq_ext_iff]
  simp [orderedPlusIndex]
  omega

theorem plusMinusFinEquiv_minus_zero (p q : ℕ) :
    plusMinusFinEquiv p q (Sum.inr (0 : Fin (q + 1))) =
      (0 : Fin ((p + q + 1) + 1)).succAbove (orderedNormalIndex p q) := by
  unfold plusMinusFinEquiv finSumFinEquiv
  dsimp only [Equiv.trans_apply, Equiv.cast_apply, Equiv.coe_fn_mk, Sum.elim_inr]
  rw [cast_eq_iff_heq, Fin.heq_ext_iff]
  simp [orderedNormalIndex]
  omega

theorem plusMinusFinEquiv_minus_succ (p q : ℕ) (j : Fin q) :
    plusMinusFinEquiv p q (Sum.inr j.succ) =
      (0 : Fin ((p + q + 1) + 1)).succAbove (orderedMinusTailIndex p q j) := by
  unfold plusMinusFinEquiv finSumFinEquiv
  dsimp only [Equiv.trans_apply, Equiv.cast_apply, Equiv.coe_fn_mk, Sum.elim_inr]
  rw [cast_eq_iff_heq, Fin.heq_ext_iff]
  simp [orderedMinusTailIndex]
  all_goals omega

section Actual
variable {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module Omega V]

theorem ambientCentralizerMatrix_plus_plus [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (i j : Fin (p + 1)) :
    (↑(ambientMatrixRepresentation R (p + q + 1)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm) (n : G)) :
      Matrix _ _ Omega)
      (plusMinusFinEquiv p q (Sum.inl i))
      (plusMinusFinEquiv p q (Sum.inl j)) =
    (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
      Matrix _ _ Omega) i j := by
  rw [ambientMatrixRepresentation_centralizer_block_general]
  exact block_submatrix_plus_plus p q _ _ i j

theorem ambientCentralizerMatrix_plus_minus [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (i : Fin (p + 1)) (j : Fin (q + 1)) :
    (↑(ambientMatrixRepresentation R (p + q + 1)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm) (n : G)) :
      Matrix _ _ Omega)
      (plusMinusFinEquiv p q (Sum.inl i))
      (plusMinusFinEquiv p q (Sum.inr j)) = 0 := by
  rw [ambientMatrixRepresentation_centralizer_block_general]
  exact block_submatrix_plus_minus p q _ _ i j

theorem ambientCentralizerMatrix_minus_plus [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (i : Fin (q + 1)) (j : Fin (p + 1)) :
    (↑(ambientMatrixRepresentation R (p + q + 1)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm) (n : G)) :
      Matrix _ _ Omega)
      (plusMinusFinEquiv p q (Sum.inr i))
      (plusMinusFinEquiv p q (Sum.inl j)) = 0 := by
  rw [ambientMatrixRepresentation_centralizer_block_general]
  exact block_submatrix_minus_plus p q _ _ i j

theorem ambientCentralizerMatrix_minus_minus [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (i j : Fin (q + 1)) :
    (↑(ambientMatrixRepresentation R (p + q + 1)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm) (n : G)) :
      Matrix _ _ Omega)
      (plusMinusFinEquiv p q (Sum.inr i))
      (plusMinusFinEquiv p q (Sum.inr j)) =
    (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
      Matrix _ _ Omega) i j := by
  rw [ambientMatrixRepresentation_centralizer_block_general]
  exact block_submatrix_minus_minus p q _ _ i j

def plusAmbientRowPolynomial (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
    (i : Fin (p + 1)) : MvPolynomial (Fin (p + q + 1)) Omega :=
  ∑ j, MvPolynomial.C (A i j) * Fin.cases 1
    (fun k : Fin p => MvPolynomial.X (orderedPlusIndex p q k)) j

def minusAmbientRowPolynomial (p q : ℕ)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
    (i : Fin (q + 1)) : MvPolynomial (Fin (p + q + 1)) Omega :=
  ∑ j, MvPolynomial.C (B i j) * Fin.cases
    (MvPolynomial.X (orderedNormalIndex p q))
    (fun k : Fin q => MvPolynomial.X (orderedMinusTailIndex p q k)) j

theorem chartDehomogenization_block_plus_row
    (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
    (i : Fin (p + 1)) :
    ProjectiveSpace.chartDehomogenization (p + q + 1) Omega 0
      (linearSubst (p + q + 1)
        ((Matrix.fromBlocks A 0 0 B).submatrix
          (plusMinusFinEquiv p q).symm (plusMinusFinEquiv p q).symm)
        (plusMinusFinEquiv p q (Sum.inl i))) =
      plusAmbientRowPolynomial p q A i := by
  rw [chartDehomogenization_linearSubst_eq_row]
  rw [← Equiv.sum_comp (plusMinusFinEquiv p q)]
  rw [Fintype.sum_sum_type]
  simp only [block_submatrix_plus_plus, block_submatrix_plus_minus,
    map_zero, zero_mul, Finset.sum_const_zero, add_zero]
  rw [plusAmbientRowPolynomial]
  apply Finset.sum_congr rfl
  intro j hj
  congr 1
  refine Fin.cases ?_ ?_ j
  · rw [plusMinusFinEquiv_plus_zero]
    rfl
  · intro k
    rw [plusMinusFinEquiv_plus_succ]
    rfl

theorem chartDehomogenization_block_minus_row
    (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
    (i : Fin (q + 1)) :
    ProjectiveSpace.chartDehomogenization (p + q + 1) Omega 0
      (linearSubst (p + q + 1)
        ((Matrix.fromBlocks A 0 0 B).submatrix
          (plusMinusFinEquiv p q).symm (plusMinusFinEquiv p q).symm)
        (plusMinusFinEquiv p q (Sum.inr i))) =
      minusAmbientRowPolynomial p q B i := by
  rw [chartDehomogenization_linearSubst_eq_row]
  rw [← Equiv.sum_comp (plusMinusFinEquiv p q)]
  rw [Fintype.sum_sum_type]
  simp only [block_submatrix_minus_plus, block_submatrix_minus_minus,
    map_zero, zero_mul, Finset.sum_const_zero, zero_add]
  rw [minusAmbientRowPolynomial]
  apply Finset.sum_congr rfl
  intro j hj
  congr 1
  refine Fin.cases ?_ ?_ j
  · rw [plusMinusFinEquiv_minus_zero]
    rfl
  · intro k
    rw [plusMinusFinEquiv_minus_succ]
    rfl

theorem chartDehomogenization_ambient_plus_row [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (i : Fin (p + 1)) :
    let M := (↑(ambientMatrixRepresentation R (p + q + 1)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm) (n : G)) :
      Matrix (Fin ((p + q + 1) + 1)) (Fin ((p + q + 1) + 1)) Omega)
    let A := (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
      Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
    ProjectiveSpace.chartDehomogenization (p + q + 1) Omega 0
      (linearSubst (p + q + 1) M
        (plusMinusFinEquiv p q (Sum.inl i))) =
      plusAmbientRowPolynomial p q A i := by
  dsimp only
  rw [ambientMatrixRepresentation_centralizer_block_general]
  exact chartDehomogenization_block_plus_row p q _ _ i

theorem chartDehomogenization_ambient_minus_row [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (i : Fin (q + 1)) :
    let M := (↑(ambientMatrixRepresentation R (p + q + 1)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm) (n : G)) :
      Matrix (Fin ((p + q + 1) + 1)) (Fin ((p + q + 1) + 1)) Omega)
    let B := (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
      Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
    ProjectiveSpace.chartDehomogenization (p + q + 1) Omega 0
      (linearSubst (p + q + 1) M
        (plusMinusFinEquiv p q (Sum.inr i))) =
      minusAmbientRowPolynomial p q B i := by
  dsimp only
  rw [ambientMatrixRepresentation_centralizer_block_general]
  exact chartDehomogenization_block_minus_row p q _ _ i

theorem linearNormalCoefficientEmbedding_apply_C
    (p q : ℕ) (c : LinearResidualField (Nat.succ (p + q)) Omega) :
    linearNormalCoefficientEmbedding (Nat.succ (p + q))
        (correctedOrderedLinearNormalFunctionFieldEquiv p q) c =
      correctedOrderedLinearNormalFunctionFieldEquiv p q (RatFunc.C c) := by
  simp only [linearNormalCoefficientEmbedding, RingHom.comp_apply]
  rw [← RatFunc.algebraMap_eq_C]
  rfl

theorem correctedChart_C_base (p q : ℕ) (c : Omega) :
    correctedOrderedLinearNormalFunctionFieldEquiv p q
        (RatFunc.C (algebraMap Omega
          (LinearResidualField (Nat.succ (p + q)) Omega) c)) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (MvPolynomial (Fin (p + q + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (p + q + 1)) Omega))
          (MvPolynomial.C c)) := by
  rw [← RatFunc.algebraMap_eq_C]
  change correctedOrderedLinearNormalFunctionFieldEquiv p q
      (baseToLinearNormalFractionField (Nat.succ (p + q)) Omega c) = _
  rw [MvPolynomial.C_eq_algebraMap,
    ← IsScalarTower.algebraMap_apply Omega
      (MvPolynomial (Fin (p + q + 1)) Omega)
      (FractionRing (MvPolynomial (Fin (p + q + 1)) Omega)),
    correctedOrderedLinearNormalFunctionFieldEquiv_base,
    projectiveGeneralFunctionFieldEquiv_base,
    projectiveGeneralBaseToFunctionField_eq]

theorem correctedChart_C_plusGeneric (p q : ℕ) (k : Fin p) :
    correctedOrderedLinearNormalFunctionFieldEquiv p q
        (RatFunc.C (exceptionalPlusGenericVector (Omega := Omega) p q k.succ)) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (MvPolynomial (Fin (p + q + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (p + q + 1)) Omega))
          (MvPolynomial.X (orderedPlusIndex p q k))) := by
  change correctedOrderedLinearNormalFunctionFieldEquiv p q
      (RatFunc.C (residualCoordinateInField (Omega := Omega) p q
        (orderedResidualPlusIndex p q k))) = _
  exact correctedOrderedLinearNormalFunctionFieldEquiv_C_plus p q k

theorem correctedChart_C_minusGeneric (p q : ℕ) (k : Fin q) :
    correctedOrderedLinearNormalFunctionFieldEquiv p q
        (RatFunc.C (exceptionalMinusGenericVector (Omega := Omega) p q k.succ)) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (MvPolynomial (Fin (p + q + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (p + q + 1)) Omega))
            (MvPolynomial.X (orderedMinusTailIndex p q k)) /
          algebraMap (MvPolynomial (Fin (p + q + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (p + q + 1)) Omega))
            (MvPolynomial.X (orderedNormalIndex p q))) := by
  change correctedOrderedLinearNormalFunctionFieldEquiv p q
      (RatFunc.C (residualCoordinateInField (Omega := Omega) p q
        (orderedResidualMinusIndex p q k))) = _
  exact correctedOrderedLinearNormalFunctionFieldEquiv_C_tail p q k

theorem correctedChart_parameter
    (p q : ℕ) :
    linearNormalParameterElement (Nat.succ (p + q))
        (correctedOrderedLinearNormalFunctionFieldEquiv (Omega := Omega) p q) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (MvPolynomial (Fin (p + q + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (p + q + 1)) Omega))
          (MvPolynomial.X (orderedNormalIndex p q))) := by
  exact correctedOrderedLinearNormalFunctionFieldEquiv_X p q

theorem correctedChart_parameter_ne_zero
    (p q : ℕ) :
    linearNormalParameterElement (Nat.succ (p + q))
        (correctedOrderedLinearNormalFunctionFieldEquiv (Omega := Omega) p q) ≠ 0 := by
  rw [correctedChart_parameter]
  rw [RingEquiv.map_ne_zero_iff]
  rw [map_ne_zero_iff _
    (IsFractionRing.injective (MvPolynomial (Fin (p + q + 1)) Omega)
      (FractionRing (MvPolynomial (Fin (p + q + 1)) Omega)))]
  exact MvPolynomial.X_ne_zero (orderedNormalIndex p q)

theorem correctedChart_coefficient_plusRowForm
    (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
    (i : Fin (p + 1)) :
    linearNormalCoefficientEmbedding (Nat.succ (p + q))
        (correctedOrderedLinearNormalFunctionFieldEquiv p q)
        (exceptionalPlusRowForm p q A i) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (MvPolynomial (Fin (p + q + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (p + q + 1)) Omega))
          (plusAmbientRowPolynomial p q A i)) := by
  rw [exceptionalPlusRowForm, plusAmbientRowPolynomial]
  rw [linearNormalCoefficientEmbedding_apply_C]
  simp only [map_sum, map_mul]
  apply Finset.sum_congr rfl
  intro j hj
  refine Fin.cases ?_ ?_ j
  · simp only [Fin.cases_zero, exceptionalPlusGenericVector, map_one, mul_one]
    exact correctedChart_C_base p q (A i 0)
  · intro k
    simp only [Fin.cases_succ]
    rw [correctedChart_C_base (Omega := Omega),
      correctedChart_C_plusGeneric (Omega := Omega)]

theorem correctedChart_coefficient_minusRowForm
    (p q : ℕ)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
    (i : Fin (q + 1)) :
    linearNormalCoefficientEmbedding (Nat.succ (p + q))
        (correctedOrderedLinearNormalFunctionFieldEquiv p q)
        (exceptionalMinusRowForm p q B i) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (MvPolynomial (Fin (p + q + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (p + q + 1)) Omega))
          (minusAmbientRowPolynomial p q B i)) /
      linearNormalParameterElement (Nat.succ (p + q))
        (correctedOrderedLinearNormalFunctionFieldEquiv p q) := by
  apply (eq_div_iff (correctedChart_parameter_ne_zero (Omega := Omega) p q)).mpr
  rw [exceptionalMinusRowForm, minusAmbientRowPolynomial]
  rw [linearNormalCoefficientEmbedding_apply_C]
  simp only [map_sum, map_mul, Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro j hj
  refine Fin.cases ?_ ?_ j
  · simp only [Fin.cases_zero, exceptionalMinusGenericVector, map_one, mul_one]
    rw [correctedChart_C_base (Omega := Omega), correctedChart_parameter]
  · intro k
    have ht : projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (MvPolynomial (Fin (p + q + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (p + q + 1)) Omega))
          (MvPolynomial.X (orderedNormalIndex p q))) ≠ 0 := by
      rw [← correctedChart_parameter (Omega := Omega)]
      exact correctedChart_parameter_ne_zero (Omega := Omega) p q
    simp only [Fin.cases_succ]
    rw [correctedChart_C_base (Omega := Omega),
      correctedChart_C_minusGeneric (Omega := Omega), correctedChart_parameter]
    rw [map_div₀]
    rw [mul_assoc, div_mul_cancel₀ _ ht]

public theorem correctedSource_coefficient_plusGenerator [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (r q : ℕ)
    (bp : Basis (Fin ((r + 1) + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (i : Fin (r + 1)) :
    let X := correctedOrderedPlusMinusSourceAction
      R sigma hsigma (r + 1) q bp bm
    let eK := correctedOrderedLinearNormalFunctionFieldEquiv
      (Omega := Omega) (r + 1) q
    let g := orderedBlockSemidirectElement R sigma (r + 1) q bp bm
      (biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega) n
    (Scheme.actionFunctionFieldMap X n).hom
        (linearNormalCoefficientEmbedding (Nat.succ ((r + 1) + q)) eK
          (orderedResidualGenerator (r + 1) q
            (orderedResidualPlusIndex (r + 1) q i))) =
      linearNormalCoefficientEmbedding (Nat.succ ((r + 1) + q)) eK
        (g.right (orderedResidualGenerator (r + 1) q
          (orderedResidualPlusIndex (r + 1) q i))) := by
  let X := correctedOrderedPlusMinusSourceAction
    R sigma hsigma (r + 1) q bp bm
  dsimp only
  change (Scheme.actionFunctionFieldMap X n).hom
      (linearNormalCoefficientEmbedding (Nat.succ ((r + 1) + q))
        (correctedOrderedLinearNormalFunctionFieldEquiv (r + 1) q)
        (orderedResidualGenerator (r + 1) q
          (orderedResidualPlusIndex (r + 1) q i))) =
    linearNormalCoefficientEmbedding (Nat.succ ((r + 1) + q))
      (correctedOrderedLinearNormalFunctionFieldEquiv (r + 1) q)
      ((orderedBlockSemidirectElement R sigma (r + 1) q bp bm
        (biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega) n).right
          (orderedResidualGenerator (r + 1) q
            (orderedResidualPlusIndex (r + 1) q i)))
  have hgen : orderedResidualGenerator (Omega := Omega) (r + 1) q
      (orderedResidualPlusIndex (r + 1) q i) =
      residualCoordinateInField (Omega := Omega) (r + 1) q
        (orderedResidualPlusIndex (r + 1) q i) := rfl
  rw [hgen, linearNormalCoefficientEmbedding_apply_C,
    correctedOrderedLinearNormalFunctionFieldEquiv_C_plus]
  have hright := orderedBlockSemidirectElement_right_plusGenerator
    R sigma r q bp bm n i
  change (orderedBlockSemidirectElement R sigma (r + 1) q bp bm
      (biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega) n).right
      (residualCoordinateInField (Omega := Omega) (r + 1) q
        (orderedResidualPlusIndex (r + 1) q i)) = _ at hright
  rw [hright, map_div₀]
  rw [correctedChart_coefficient_plusRowForm,
    correctedChart_coefficient_plusRowForm]
  let e := projectiveGeneralFunctionFieldEquiv ((r + 1) + q) Omega
  let K := orderedCoordinateField (Omega := Omega) (r + 1) q
  let M := (↑(ambientMatrixRepresentation R ((r + 1) + q + 1)
    (plusMinusAmbientBasis R sigma hsigma (r + 1) q bp bm) (n : G)) :
      Matrix (Fin ((((r + 1) + q) + 1) + 1))
        (Fin ((((r + 1) + q) + 1) + 1)) Omega)
  let A := (↑(plusCentralizerMatrixRepresentation R sigma (r + 1) bp n) :
    Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
  have hsource :
      (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction
            R sigma hsigma (r + 1) q bp bm) n).hom
          (e (algebraMap (orderedCoordinatePolynomial (Omega := Omega) (r + 1) q)
            K (MvPolynomial.X (orderedPlusIndex (r + 1) q i)))) =
        e (algebraMap (orderedCoordinatePolynomial (Omega := Omega) (r + 1) q)
            K (ProjectiveSpace.chartDehomogenization ((r + 1) + q + 1)
              Omega 0 (linearSubst ((r + 1) + q + 1) M
                ((0 : Fin ((((r + 1) + q) + 1) + 1)).succAbove
                  (orderedPlusIndex (r + 1) q i))))) /
          e (algebraMap (orderedCoordinatePolynomial (Omega := Omega) (r + 1) q)
            K (ProjectiveSpace.chartDehomogenization ((r + 1) + q + 1)
              Omega 0 (linearSubst ((r + 1) + q + 1) M 0))) := by
    simpa only [e, K, M] using
      (correctedOrderedPlusMinusSource_actionFunctionFieldMap_X
        R sigma hsigma (r + 1) q bp bm n (orderedPlusIndex (r + 1) q i))
  have hnum : ProjectiveSpace.chartDehomogenization ((r + 1) + q + 1)
        Omega 0 (linearSubst ((r + 1) + q + 1) M
          ((0 : Fin ((((r + 1) + q) + 1) + 1)).succAbove
            (orderedPlusIndex (r + 1) q i))) =
      plusAmbientRowPolynomial (r + 1) q A i.succ := by
    have h := chartDehomogenization_ambient_plus_row
      R sigma hsigma n (r + 1) q bp bm i.succ
    rw [plusMinusFinEquiv_plus_succ (r + 1) q i] at h
    simpa only [M, A] using h
  have hden : ProjectiveSpace.chartDehomogenization ((r + 1) + q + 1)
        Omega 0 (linearSubst ((r + 1) + q + 1) M 0) =
      plusAmbientRowPolynomial (r + 1) q A 0 := by
    have h := chartDehomogenization_ambient_plus_row
      R sigma hsigma n (r + 1) q bp bm (0 : Fin ((r + 1) + 1))
    rw [plusMinusFinEquiv_plus_zero (r + 1) q] at h
    simpa only [M, A] using h
  rw [hnum, hden] at hsource
  simpa only [X, e, K, A] using hsource

def orderedMinusAffineIndex (p q : ℕ) : Fin (q + 1) → Fin (p + q + 1) :=
  Fin.cases (orderedNormalIndex p q) (orderedMinusTailIndex p q)

theorem plusMinusFinEquiv_minus_affine (p q : ℕ) (i : Fin (q + 1)) :
    plusMinusFinEquiv p q (Sum.inr i) =
      (0 : Fin ((p + q + 1) + 1)).succAbove
        (orderedMinusAffineIndex p q i) := by
  refine Fin.cases ?_ ?_ i
  · exact plusMinusFinEquiv_minus_zero p q
  · intro j
    exact plusMinusFinEquiv_minus_succ p q j

theorem correctedSource_projective_minusGenerator_row [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (i : Fin (q + 1)) :
    let X := correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm
    let e := projectiveGeneralFunctionFieldEquiv (p + q) Omega
    let K := orderedCoordinateField (Omega := Omega) p q
    let B := (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
      Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
    let A := (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
      Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
    (Scheme.actionFunctionFieldMap X n).hom
        (e (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q) K
          (MvPolynomial.X (orderedMinusAffineIndex p q i)))) =
      e (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q) K
          (minusAmbientRowPolynomial p q B i)) /
        e (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q) K
          (plusAmbientRowPolynomial p q A 0)) := by
  dsimp only
  let e := projectiveGeneralFunctionFieldEquiv (p + q) Omega
  let K := orderedCoordinateField (Omega := Omega) p q
  let M := (↑(ambientMatrixRepresentation R (p + q + 1)
    (plusMinusAmbientBasis R sigma hsigma p q bp bm) (n : G)) :
      Matrix (Fin ((p + q + 1) + 1)) (Fin ((p + q + 1) + 1)) Omega)
  let B := (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
    Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
  let A := (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
    Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
  have hsource :
      (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm) n).hom
          (e (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q) K
            (MvPolynomial.X (orderedMinusAffineIndex p q i)))) =
        e (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q) K
            (ProjectiveSpace.chartDehomogenization (p + q + 1) Omega 0
              (linearSubst (p + q + 1) M
                ((0 : Fin ((p + q + 1) + 1)).succAbove
                  (orderedMinusAffineIndex p q i))))) /
          e (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q) K
            (ProjectiveSpace.chartDehomogenization (p + q + 1) Omega 0
              (linearSubst (p + q + 1) M 0))) := by
    simpa only [e, K, M] using
      (correctedOrderedPlusMinusSource_actionFunctionFieldMap_X
        R sigma hsigma p q bp bm n (orderedMinusAffineIndex p q i))
  have hnum : ProjectiveSpace.chartDehomogenization (p + q + 1) Omega 0
        (linearSubst (p + q + 1) M
          ((0 : Fin ((p + q + 1) + 1)).succAbove
            (orderedMinusAffineIndex p q i))) =
      minusAmbientRowPolynomial p q B i := by
    have h := chartDehomogenization_ambient_minus_row
      R sigma hsigma n p q bp bm i
    rw [plusMinusFinEquiv_minus_affine p q i] at h
    simpa only [M, B] using h
  have hden : ProjectiveSpace.chartDehomogenization (p + q + 1) Omega 0
        (linearSubst (p + q + 1) M 0) =
      plusAmbientRowPolynomial p q A 0 := by
    have h := chartDehomogenization_ambient_plus_row
      R sigma hsigma n p q bp bm (0 : Fin (p + 1))
    rw [plusMinusFinEquiv_plus_zero p q] at h
    simpa only [M, A] using h
  rw [hnum, hden] at hsource
  exact hsource

theorem div_div_same_denominator {K : Type u} [Field K]
    (a b c : K) (hc : c ≠ 0) :
    (a / c) / (b / c) = a / b := by
  field_simp

theorem ambientSource_coefficient_minusGenerator_row [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (i : Fin q) :
    (Scheme.actionFunctionFieldMap
        (ambientProjectiveActionOver R (p + q + 1)
          (plusMinusAmbientBasis R sigma hsigma p q bp bm)) (n : G)).hom
      (correctedOrderedLinearNormalFunctionFieldEquiv p q
        (RatFunc.C (residualCoordinateInField p q
          (orderedResidualMinusIndex p q i)))) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
          (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
            (orderedCoordinateField (Omega := Omega) p q)
            (minusAmbientRowPolynomial p q
              (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
                Matrix _ _ Omega) i.succ)) /
        projectiveGeneralFunctionFieldEquiv (p + q) Omega
          (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
            (orderedCoordinateField (Omega := Omega) p q)
            (minusAmbientRowPolynomial p q
              (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
                Matrix _ _ Omega) 0)) := by
  rw [correctedOrderedLinearNormalFunctionFieldEquiv_C_tail]
  rw [map_div₀ (projectiveGeneralFunctionFieldEquiv (p + q) Omega)]
  let Y := ambientProjectiveActionOver R (p + q + 1)
    (plusMinusAmbientBasis R sigma hsigma p q bp bm)
  let u : Y.V.left.functionField :=
    projectiveGeneralFunctionFieldEquiv (p + q) Omega
      (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.X (orderedMinusTailIndex p q i)))
  let v : Y.V.left.functionField :=
    projectiveGeneralFunctionFieldEquiv (p + q) Omega
      (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.X (orderedNormalIndex p q)))
  change (Scheme.actionFunctionFieldMap Y (n : G)).hom (u / v) = _
  rw [map_div₀]
  have htail := correctedSource_projective_minusGenerator_row
    R sigma hsigma n p q bp bm i.succ
  have hnormal := correctedSource_projective_minusGenerator_row
    R sigma hsigma n p q bp bm (0 : Fin (q + 1))
  have htail' :
      (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm) n).hom
          (projectiveGeneralFunctionFieldEquiv (p + q) Omega
            (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
              (orderedCoordinateField (Omega := Omega) p q)
              (MvPolynomial.X (orderedMinusTailIndex p q i)))) =
        projectiveGeneralFunctionFieldEquiv (p + q) Omega
            (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
              (orderedCoordinateField (Omega := Omega) p q)
              (minusAmbientRowPolynomial p q
                (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
                  Matrix _ _ Omega) i.succ)) /
          projectiveGeneralFunctionFieldEquiv (p + q) Omega
            (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
              (orderedCoordinateField (Omega := Omega) p q)
              (plusAmbientRowPolynomial p q
                (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
                  Matrix _ _ Omega) 0)) := by
    simpa [orderedMinusAffineIndex] using htail
  have hnormal' :
      (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm) n).hom
          (projectiveGeneralFunctionFieldEquiv (p + q) Omega
            (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
              (orderedCoordinateField (Omega := Omega) p q)
              (MvPolynomial.X (orderedNormalIndex p q)))) =
        projectiveGeneralFunctionFieldEquiv (p + q) Omega
            (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
              (orderedCoordinateField (Omega := Omega) p q)
              (minusAmbientRowPolynomial p q
                (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
                  Matrix _ _ Omega) 0)) /
          projectiveGeneralFunctionFieldEquiv (p + q) Omega
            (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
              (orderedCoordinateField (Omega := Omega) p q)
              (plusAmbientRowPolynomial p q
                (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
                  Matrix _ _ Omega) 0)) := by
    simpa [orderedMinusAffineIndex] using hnormal
  have haction :
      Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm) n =
        Scheme.actionFunctionFieldMap
          (ambientProjectiveActionOver R (p + q + 1)
            (plusMinusAmbientBasis R sigma hsigma p q bp bm)) (n : G) := by
    rfl
  rw [haction] at htail' hnormal'
  change (Scheme.actionFunctionFieldMap Y (n : G)).hom u = _ at htail'
  change (Scheme.actionFunctionFieldMap Y (n : G)).hom v = _ at hnormal'
  rw [htail', hnormal']
  have hplus : projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (plusAmbientRowPolynomial p q
            (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
              Matrix _ _ Omega) 0)) ≠ 0 := by
    rw [← correctedChart_coefficient_plusRowForm]
    apply (map_ne_zero _).2
    change plusFirstRowForm p q
      (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
        Matrix _ _ Omega) ≠ 0
    exact plusFirstRowForm_ne_zero p q
      (plusCentralizerMatrixRepresentation R sigma p bp n)
  have hminus : projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (minusAmbientRowPolynomial p q
            (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
              Matrix _ _ Omega) 0)) ≠ 0 := by
    intro hz
    have hrow := correctedChart_coefficient_minusRowForm (Omega := Omega)
      p q
      (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
        Matrix _ _ Omega) (0 : Fin (q + 1))
    rw [hz, zero_div] at hrow
    have hform : exceptionalMinusRowForm p q
        (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
          Matrix _ _ Omega) 0 ≠ 0 := by
      change minusFirstRowForm p q
        (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
          Matrix _ _ Omega) ≠ 0
      exact minusFirstRowForm_ne_zero p q
        (minusCentralizerMatrixRepresentation R sigma q bm n)
    exact ((map_ne_zero _).2 hform) hrow
  exact div_div_same_denominator _ _ _ hplus

public theorem correctedSource_coefficient_minusGenerator [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p r : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin ((r + 1) + 1)) Omega (R.minusEigenspace sigma))
    (i : Fin (r + 1)) :
    let X := correctedOrderedPlusMinusSourceAction
      R sigma hsigma p (r + 1) bp bm
    let eK := correctedOrderedLinearNormalFunctionFieldEquiv
      (Omega := Omega) p (r + 1)
    let g := orderedBlockSemidirectElement R sigma p (r + 1) bp bm
      (biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega) n
    (Scheme.actionFunctionFieldMap X n).hom
        (linearNormalCoefficientEmbedding (Nat.succ (p + (r + 1))) eK
          (orderedResidualGenerator p (r + 1)
            (orderedResidualMinusIndex p (r + 1) i))) =
      linearNormalCoefficientEmbedding (Nat.succ (p + (r + 1))) eK
        (g.right (orderedResidualGenerator p (r + 1)
          (orderedResidualMinusIndex p (r + 1) i))) := by
  dsimp only
  have hgen : orderedResidualGenerator (Omega := Omega) p (r + 1)
      (orderedResidualMinusIndex p (r + 1) i) =
      residualCoordinateInField (Omega := Omega) p (r + 1)
        (orderedResidualMinusIndex p (r + 1) i) := rfl
  rw [hgen, linearNormalCoefficientEmbedding_apply_C]
  have haction :
      Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction
            R sigma hsigma p (r + 1) bp bm) n =
        Scheme.actionFunctionFieldMap
          (ambientProjectiveActionOver R (p + (r + 1) + 1)
            (plusMinusAmbientBasis R sigma hsigma p (r + 1) bp bm))
          (n : G) := by
    rfl
  have hactval := congrArg (fun f ↦ f.hom
      (correctedOrderedLinearNormalFunctionFieldEquiv p (r + 1)
        (RatFunc.C (residualCoordinateInField p (r + 1)
          (orderedResidualMinusIndex p (r + 1) i))))) haction
  have hambient := ambientSource_coefficient_minusGenerator_row
    R sigma hsigma n p (r + 1) bp bm i
  have hleft := hactval.trans hambient
  rw [hleft]
  have hright := orderedBlockSemidirectElement_right_minusGenerator
    R sigma p r bp bm n i
  change (orderedBlockSemidirectElement R sigma p (r + 1) bp bm
      (biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega) n).right
      (residualCoordinateInField (Omega := Omega) p (r + 1)
        (orderedResidualMinusIndex p (r + 1) i)) = _ at hright
  rw [hright, map_div₀]
  rw [correctedChart_coefficient_minusRowForm,
    correctedChart_coefficient_minusRowForm]
  exact (div_div_same_denominator _ _ _
    (correctedChart_parameter_ne_zero (Omega := Omega) p (r + 1))).symm

theorem ambientSource_parameter_row [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    (Scheme.actionFunctionFieldMap
        (ambientProjectiveActionOver R (p + q + 1)
          (plusMinusAmbientBasis R sigma hsigma p q bp bm)) (n : G)).hom
      (correctedOrderedLinearNormalFunctionFieldEquiv p q
        (RatFunc.X : LinearNormalFractionField (Nat.succ (p + q)) Omega)) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
          (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
            (orderedCoordinateField (Omega := Omega) p q)
            (minusAmbientRowPolynomial p q
              (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
                Matrix _ _ Omega) 0)) /
        projectiveGeneralFunctionFieldEquiv (p + q) Omega
          (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
            (orderedCoordinateField (Omega := Omega) p q)
            (plusAmbientRowPolynomial p q
              (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
                Matrix _ _ Omega) 0)) := by
  rw [correctedOrderedLinearNormalFunctionFieldEquiv_X]
  have hnormal := correctedSource_projective_minusGenerator_row
    R sigma hsigma n p q bp bm (0 : Fin (q + 1))
  have hnormal' :
      (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm) n).hom
          (projectiveGeneralFunctionFieldEquiv (p + q) Omega
            (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
              (orderedCoordinateField (Omega := Omega) p q)
              (MvPolynomial.X (orderedNormalIndex p q)))) =
        projectiveGeneralFunctionFieldEquiv (p + q) Omega
            (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
              (orderedCoordinateField (Omega := Omega) p q)
              (minusAmbientRowPolynomial p q
                (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
                  Matrix _ _ Omega) 0)) /
          projectiveGeneralFunctionFieldEquiv (p + q) Omega
            (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
              (orderedCoordinateField (Omega := Omega) p q)
              (plusAmbientRowPolynomial p q
                (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
                  Matrix _ _ Omega) 0)) := by
    simpa [orderedMinusAffineIndex] using hnormal
  have haction :
      Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm) n =
        Scheme.actionFunctionFieldMap
          (ambientProjectiveActionOver R (p + q + 1)
            (plusMinusAmbientBasis R sigma hsigma p q bp bm)) (n : G) := by
    rfl
  have hactval := congrArg (fun f ↦ f.hom
      (projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedNormalIndex p q))))) haction
  exact hactval.symm.trans hnormal'

theorem div_div_mul_same_denominator {K : Type u} [Field K]
    (a b t : K) (ht : t ≠ 0) :
    ((a / t) / b) * t = a / b := by
  field_simp

public theorem correctedSource_parameter [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    let X := correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm
    let eK := correctedOrderedLinearNormalFunctionFieldEquiv
      (Omega := Omega) p q
    let g := orderedBlockSemidirectElement R sigma p q bp bm
      (biprojectiveGeneralFunctionFieldEquiv p q Omega) n
    (Scheme.actionFunctionFieldMap X n).hom
        (linearNormalParameterElement (Nat.succ (p + q)) eK) =
      linearNormalScaledParameterElement (Nat.succ (p + q)) eK
        (g.left : _) := by
  dsimp only
  change (Scheme.actionFunctionFieldMap
      (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm) n).hom
      (correctedOrderedLinearNormalFunctionFieldEquiv p q
        (RatFunc.X : LinearNormalFractionField (Nat.succ (p + q)) Omega)) = _
  have haction :
      Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm) n =
        Scheme.actionFunctionFieldMap
          (ambientProjectiveActionOver R (p + q + 1)
            (plusMinusAmbientBasis R sigma hsigma p q bp bm)) (n : G) := by
    rfl
  have hactval := congrArg (fun f ↦ f.hom
      (correctedOrderedLinearNormalFunctionFieldEquiv p q
        (RatFunc.X : LinearNormalFractionField (Nat.succ (p + q)) Omega))) haction
  have hambient := ambientSource_parameter_row R sigma hsigma n p q bp bm
  have hleft := hactval.trans hambient
  have hmult : (↑(blockNormalMultiplier R sigma p q bp bm n) :
        orderedResidualField (Omega := Omega) p q) =
      minusFirstRowForm p q
          (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
            Matrix _ _ Omega) /
        plusFirstRowForm p q
          (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
            Matrix _ _ Omega) := rfl
  have hscaled :
      linearNormalScaledParameterElement (Nat.succ (p + q))
          (correctedOrderedLinearNormalFunctionFieldEquiv p q)
          ((orderedBlockSemidirectElement R sigma p q bp bm
            (biprojectiveGeneralFunctionFieldEquiv p q Omega) n).left : _) =
        linearNormalCoefficientEmbedding (Nat.succ (p + q))
            (correctedOrderedLinearNormalFunctionFieldEquiv p q)
            (minusFirstRowForm p q
                (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
                  Matrix _ _ Omega) /
              plusFirstRowForm p q
                (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
                  Matrix _ _ Omega)) *
          linearNormalParameterElement (Nat.succ (p + q))
            (correctedOrderedLinearNormalFunctionFieldEquiv p q) := by
    rw [orderedBlockSemidirectElement_left]
    simp only [linearNormalScaledParameterElement, map_mul]
    rw [hmult]
    rfl
  have hmap := map_div₀
    (linearNormalCoefficientEmbedding (Nat.succ (p + q))
      (correctedOrderedLinearNormalFunctionFieldEquiv p q))
    (exceptionalMinusRowForm p q
      (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
        Matrix _ _ Omega) 0)
    (exceptionalPlusRowForm p q
      (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
        Matrix _ _ Omega) 0)
  change linearNormalCoefficientEmbedding (Nat.succ (p + q))
      (correctedOrderedLinearNormalFunctionFieldEquiv p q)
      (minusFirstRowForm p q
          (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
            Matrix _ _ Omega) /
        plusFirstRowForm p q
          (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
            Matrix _ _ Omega)) = _ at hmap
  have hminus := correctedChart_coefficient_minusRowForm (Omega := Omega)
    p q (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
      Matrix _ _ Omega) (0 : Fin (q + 1))
  have hplus := correctedChart_coefficient_plusRowForm (Omega := Omega)
    p q (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
      Matrix _ _ Omega) (0 : Fin (p + 1))
  have hcoeff := hmap.trans (congrArg₂ (fun a b ↦ a / b) hminus hplus)
  have hproduct := congrArg₂ (fun a b ↦ a * b) hcoeff
    (Eq.refl (linearNormalParameterElement (Nat.succ (p + q))
      (correctedOrderedLinearNormalFunctionFieldEquiv p q)))
  have hcancel := div_div_mul_same_denominator
    (projectiveGeneralFunctionFieldEquiv (p + q) Omega
      (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (minusAmbientRowPolynomial p q
          (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
            Matrix _ _ Omega) 0)))
    (projectiveGeneralFunctionFieldEquiv (p + q) Omega
      (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (plusAmbientRowPolynomial p q
          (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
            Matrix _ _ Omega) 0)))
    (linearNormalParameterElement (Nat.succ (p + q))
      (correctedOrderedLinearNormalFunctionFieldEquiv p q))
    (correctedChart_parameter_ne_zero (Omega := Omega) p q)
  have hright := hscaled.trans (hproduct.trans hcancel)
  exact hleft.trans hright.symm

public theorem correctedSource_coefficient_generator [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (i : Fin (p + q)) :
    let X := correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm
    let eK := correctedOrderedLinearNormalFunctionFieldEquiv
      (Omega := Omega) p q
    let g := orderedBlockSemidirectElement R sigma p q bp bm
      (biprojectiveGeneralFunctionFieldEquiv p q Omega) n
    (Scheme.actionFunctionFieldMap X n).hom
        (linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK
          (orderedResidualGenerator p q i)) =
      linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK
        (g.right (orderedResidualGenerator p q i)) := by
  rcases orderedResidualIndex_cases p q i with ⟨j, rfl⟩ | ⟨j, rfl⟩
  · cases p with
    | zero => exact Fin.elim0 j
    | succ r =>
      exact correctedSource_coefficient_plusGenerator
        R sigma hsigma n r q bp bm j
  · cases q with
    | zero => exact Fin.elim0 j
    | succ r =>
      exact correctedSource_coefficient_minusGenerator
        R sigma hsigma n p r bp bm j

public theorem correctedOrdered_sourceFieldMap [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (n : centralizer sigma) :
    (pointwiseSemidirectSourceEquiv (Nat.succ (p + q))
      (correctedOrderedLinearNormalFunctionFieldEquiv p q)
      (orderedBlockSemidirectElement R sigma p q bp bm
        (biprojectiveGeneralFunctionFieldEquiv p q Omega) n)).toRingHom =
      (Scheme.actionFunctionFieldMap
        (correctedOrderedPlusMinusSourceAction
          R sigma hsigma p q bp bm) n).hom := by
  exact correctedOrdered_sourceFieldMap_of_residual_X_T
    R sigma hsigma p q bp bm n
    (correctedSource_coefficient_generator R sigma hsigma n p q bp bm)
    (correctedSource_parameter R sigma hsigma n p q bp bm)

@[expose] public noncomputable def orderedPlusMinusEquivariantNormalDataOfCorrectedChartActual
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    EquivariantNormalValuationData
      (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm)
      (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm) :=
  orderedPlusMinusEquivariantNormalDataOfCorrectedChart
    R sigma hsigma p q bp bm
    (correctedOrdered_sourceFieldMap R sigma hsigma p q bp bm)


end Actual

end V14Formalization.SchemeGeometry
