import V14Formalization.BlockSourceFieldMap

noncomputable section
open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry BigOperators
namespace V14Formalization.SchemeGeometry
open AlgebraicGeometry BConicBundleMultisections Module
universe u
variable {Omega : Type u} [Field Omega]
  {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module Omega V]

theorem exceptionalPlusRowForm_one_succ
    (r q : ℕ) (i : Fin (r + 1)) :
    exceptionalPlusRowForm (Omega := Omega) (r + 1) q
        (1 : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega) i.succ /
      exceptionalPlusRowForm (Omega := Omega) (r + 1) q 1 0 =
      orderedResidualGenerator (Omega := Omega) (r + 1) q
        (orderedResidualPlusIndex (r + 1) q i) := by
  simp [exceptionalPlusRowForm, exceptionalPlusGenericVector,
    Matrix.one_apply]
  unfold orderedResidualGenerator orderedResidualPlusIndex
  congr 2

theorem exceptionalMinusRowForm_neg_one_succ
    (p r : ℕ) (i : Fin (r + 1)) :
    exceptionalMinusRowForm (Omega := Omega) p (r + 1)
        (-1 : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega) i.succ /
      exceptionalMinusRowForm (Omega := Omega) p (r + 1) (-1) 0 =
      orderedResidualGenerator (Omega := Omega) p (r + 1)
        (orderedResidualMinusIndex p (r + 1) i) := by
  simp [exceptionalMinusRowForm, exceptionalMinusGenericVector,
    Matrix.one_apply]
  unfold orderedResidualGenerator orderedResidualMinusIndex
  congr 2

theorem orderedBlockSemidirectElement_sigma_right_C
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (c : Omega) :
    (orderedBlockSemidirectElement R sigma p q bp bm
      (biprojectiveGeneralFunctionFieldEquiv p q Omega)
      (sigmaCentralizer sigma)).right
        (baseToResidualField (Nat.succ (p + q)) Omega c) =
      baseToResidualField (Nat.succ (p + q)) Omega c :=
  orderedBlockSemidirectElement_right_C_base
    R sigma p q bp bm (sigmaCentralizer sigma) c

noncomputable def orderedBlockSigmaResidualEquiv
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    orderedResidualField (Omega := Omega) p q ≃+*
      orderedResidualField (Omega := Omega) p q :=
  (orderedBlockSemidirectElement R sigma p q bp bm
    (biprojectiveGeneralFunctionFieldEquiv p q Omega)
    (sigmaCentralizer sigma)).right

theorem orderedBlockSigmaResidualEquiv_C
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (c : Omega) :
    orderedBlockSigmaResidualEquiv R sigma p q bp bm
        (baseToResidualField (Nat.succ (p + q)) Omega c) =
      baseToResidualField (Nat.succ (p + q)) Omega c := by
  exact orderedBlockSemidirectElement_sigma_right_C
    R sigma p q bp bm c

theorem orderedBlockSigmaResidualEquiv_plusGenerator
    (R : FaithfulLinearRep Omega G V) (sigma : G) (r q : ℕ)
    (bp : Basis (Fin ((r + 1) + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (i : Fin (r + 1)) :
    orderedBlockSigmaResidualEquiv R sigma (r + 1) q bp bm
        (orderedResidualGenerator (r + 1) q
          (orderedResidualPlusIndex (r + 1) q i)) =
      orderedResidualGenerator (r + 1) q
        (orderedResidualPlusIndex (r + 1) q i) := by
  have hj := orderedBlockSemidirectElement_right_plusGenerator
    R sigma r q bp bm (sigmaCentralizer sigma) i
  rw [plusCentralizerMatrixRepresentation_sigma] at hj
  exact hj.trans (exceptionalPlusRowForm_one_succ (Omega := Omega) r q i)

theorem orderedBlockSigmaResidualEquiv_minusGenerator
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p r : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin ((r + 1) + 1)) Omega (R.minusEigenspace sigma))
    (i : Fin (r + 1)) :
    orderedBlockSigmaResidualEquiv R sigma p (r + 1) bp bm
        (orderedResidualGenerator p (r + 1)
          (orderedResidualMinusIndex p (r + 1) i)) =
      orderedResidualGenerator p (r + 1)
        (orderedResidualMinusIndex p (r + 1) i) := by
  have hj := orderedBlockSemidirectElement_right_minusGenerator
    R sigma p r bp bm (sigmaCentralizer sigma) i
  rw [minusCentralizerMatrixRepresentation_sigma] at hj
  exact hj.trans (exceptionalMinusRowForm_neg_one_succ (Omega := Omega) p r i)

theorem orderedResidualField_ringHom_ext_base_X
    (p q : ℕ) {L : Type u} [Field L]
    (f h : orderedResidualField (Omega := Omega) p q →+* L)
    (hC : ∀ c : Omega,
      f (baseToResidualField (Nat.succ (p + q)) Omega c) =
        h (baseToResidualField (Nat.succ (p + q)) Omega c))
    (hX : ∀ i : Fin (p + q),
      f (orderedResidualGenerator p q i) =
        h (orderedResidualGenerator p q i)) : f = h := by
  apply IsFractionRing.ringHom_ext (A := MvPolynomial (Fin (p + q)) Omega)
  intro P
  have hpoly : f.comp (algebraMap (MvPolynomial (Fin (p + q)) Omega)
        (orderedResidualField (Omega := Omega) p q)) =
      h.comp (algebraMap (MvPolynomial (Fin (p + q)) Omega)
        (orderedResidualField (Omega := Omega) p q)) := by
    apply MvPolynomial.ringHom_ext
    · intro c
      exact hC c
    · intro i
      exact hX i
  exact DFunLike.congr_fun hpoly P

theorem orderedBlockSemidirectElement_sigma_right_eq_one
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    (orderedBlockSemidirectElement R sigma p q bp bm
      (biprojectiveGeneralFunctionFieldEquiv p q Omega)
      (sigmaCentralizer sigma)).right = 1 := by
  change orderedBlockSigmaResidualEquiv R sigma p q bp bm = 1
  have hmaps : (orderedBlockSigmaResidualEquiv R sigma p q bp bm).toRingHom =
      RingHom.id _ := by
    apply orderedResidualField_ringHom_ext_base_X (Omega := Omega) p q
    · intro c
      simp only [RingHom.id_apply]
      exact orderedBlockSigmaResidualEquiv_C R sigma p q bp bm c
    · intro i
      simp only [RingHom.id_apply]
      rcases orderedResidualIndex_cases p q i with ⟨j, rfl⟩ | ⟨j, rfl⟩
      · cases p with
        | zero => exact Fin.elim0 j
        | succ r =>
          exact orderedBlockSigmaResidualEquiv_plusGenerator
            R sigma r q bp bm j
      · cases q with
        | zero => exact Fin.elim0 j
        | succ r =>
          exact orderedBlockSigmaResidualEquiv_minusGenerator
            R sigma p r bp bm j
  apply RingEquiv.ext
  intro x
  exact DFunLike.congr_fun hmaps x

theorem orderedPlusMinusEquivariantNormalDataOfCorrectedChartActual_sigma
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    (orderedPlusMinusEquivariantNormalDataOfCorrectedChartActual
      R sigma hsigma p q bp bm).exceptionalFunctionFieldAction
        (sigmaCentralizer sigma) = 𝟙 _ := by
  unfold orderedPlusMinusEquivariantNormalDataOfCorrectedChartActual
  unfold orderedPlusMinusEquivariantNormalDataOfCorrectedChart
  unfold orderedPlusMinusEquivariantNormalDataOfBlocks
  unfold orderedPlusMinusEquivariantNormalDataOfNormalMultiplier
  apply orderedPlusMinusEquivariantNormalDataOfPointwiseSemidirect_sigma
  exact orderedBlockSemidirectElement_sigma_right_eq_one
    R sigma p q bp bm

end V14Formalization.SchemeGeometry

