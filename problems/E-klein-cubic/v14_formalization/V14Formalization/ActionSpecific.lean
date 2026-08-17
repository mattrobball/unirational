module

public import V14Formalization.PointwiseSemidirect
public import V14Formalization.UniversalSigmaDiagonal

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry
open scoped BigOperators

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

universe u

variable {Omega : Type u} [Field Omega]
  {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module Omega V]

public abbrev orderedResidualField (p q : ℕ) :=
  FractionRing (MvPolynomial (Fin (p + q)) Omega)

@[expose] public def orderedResidualGenerator (p q : ℕ) (i : Fin (p + q)) :
    orderedResidualField (Omega := Omega) p q :=
  algebraMap (MvPolynomial (Fin (p + q)) Omega)
    (orderedResidualField (Omega := Omega) p q) (MvPolynomial.X i)

@[expose] public def plusGenericVector (p q : ℕ) :
    Fin (p + 1) → orderedResidualField (Omega := Omega) p q :=
  Fin.cases 1 fun i ↦ orderedResidualGenerator p q
    ⟨i, lt_of_lt_of_le i.isLt (Nat.le_add_right p q)⟩

@[expose] public def minusGenericVector (p q : ℕ) :
    Fin (q + 1) → orderedResidualField (Omega := Omega) p q :=
  Fin.cases 1 fun j ↦ orderedResidualGenerator p q
    ⟨p + j, by omega⟩

@[expose] public def plusFirstRowForm (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega) :
    orderedResidualField (Omega := Omega) p q :=
  ∑ j, algebraMap Omega (orderedResidualField (Omega := Omega) p q) (A 0 j) *
    plusGenericVector p q j

@[expose] public def minusFirstRowForm (p q : ℕ)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega) :
    orderedResidualField (Omega := Omega) p q :=
  ∑ j, algebraMap Omega (orderedResidualField (Omega := Omega) p q) (B 0 j) *
    minusGenericVector p q j

def plusFirstRowPolynomial (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega) :
    MvPolynomial (Fin (p + q)) Omega :=
  ∑ j, MvPolynomial.C (A 0 j) * Fin.cases 1
    (fun i ↦ MvPolynomial.X
      (⟨i, lt_of_lt_of_le i.isLt (Nat.le_add_right p q)⟩ : Fin (p + q))) j

theorem plusFirstRowForm_eq_algebraMap (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega) :
    plusFirstRowForm p q A =
      algebraMap (MvPolynomial (Fin (p + q)) Omega)
        (orderedResidualField (Omega := Omega) p q)
        (plusFirstRowPolynomial p q A) := by
  rw [plusFirstRowForm, plusFirstRowPolynomial, map_sum]
  apply Finset.sum_congr rfl
  intro j hj
  rw [map_mul]
  change algebraMap Omega (orderedResidualField (Omega := Omega) p q) (A 0 j) *
      plusGenericVector p q j = _
  rw [MvPolynomial.C_eq_algebraMap,
    IsScalarTower.algebraMap_apply Omega
      (MvPolynomial (Fin (p + q)) Omega)
      (orderedResidualField (Omega := Omega) p q)]
  congr 1
  refine Fin.cases ?_ ?_ j
  · simp [plusGenericVector]
  · intro i
    simp [plusGenericVector, orderedResidualGenerator]

theorem plusFirstRowPolynomial_ne_zero (p q : ℕ)
    (A : Matrix.GeneralLinearGroup (Fin (p + 1)) Omega) :
    plusFirstRowPolynomial p q (A : Matrix _ _ Omega) ≠ 0 := by
  have hrow : ((A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega) 0) ≠ 0 :=
    (Matrix.linearIndependent_rows_of_det_ne_zero
      (Matrix.GeneralLinearGroup.det_ne_zero A)).ne_zero 0
  by_cases h00 : (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega) 0 0 = 0
  · have hex : ∃ i : Fin p,
        (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega) 0 i.succ ≠ 0 := by
      by_contra h
      push Not at h
      apply hrow
      funext j
      refine Fin.cases h00 ?_ j
      intro i
      exact h i
    obtain ⟨i, hi⟩ := hex
    intro hP
    have heval := congrArg
      (MvPolynomial.eval (fun k : Fin (p + q) ↦
        if k = (⟨i, lt_of_lt_of_le i.isLt (Nat.le_add_right p q)⟩ :
          Fin (p + q)) then 1 else 0)) hP
    dsimp [plusFirstRowPolynomial] at heval
    simp only [map_sum, map_mul, MvPolynomial.eval_C, map_zero] at heval
    rw [Fin.sum_univ_succ] at heval
    simp [h00, Fin.ext_iff] at heval
    have hs : (∑ x : Fin p, if (x : Nat) = (i : Nat)
        then (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega) 0 x.succ
        else 0) = (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega) 0 i.succ := by
      rw [Finset.sum_eq_single i]
      · simp
      · intro b hb hbi
        have hv : (b : Nat) ≠ (i : Nat) := fun h ↦ hbi (Fin.ext h)
        simp [hv]
      · simp
    rw [hs] at heval
    exact hi heval
  · intro hP
    have heval := congrArg
      (MvPolynomial.eval (fun _ : Fin (p + q) ↦ (0 : Omega))) hP
    dsimp [plusFirstRowPolynomial] at heval
    simp only [map_sum, map_mul, MvPolynomial.eval_C, map_zero] at heval
    rw [Fin.sum_univ_succ] at heval
    simp at heval
    exact h00 heval

public theorem plusFirstRowForm_ne_zero (p q : ℕ)
    (A : Matrix.GeneralLinearGroup (Fin (p + 1)) Omega) :
    plusFirstRowForm p q (A : Matrix _ _ Omega) ≠ 0 := by
  rw [plusFirstRowForm_eq_algebraMap]
  intro hz
  apply plusFirstRowPolynomial_ne_zero p q A
  apply (FaithfulSMul.algebraMap_injective
    (MvPolynomial (Fin (p + q)) Omega)
    (orderedResidualField (Omega := Omega) p q))
  simpa using hz

def minusFirstRowPolynomial (p q : ℕ)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega) :
    MvPolynomial (Fin (p + q)) Omega :=
  ∑ j, MvPolynomial.C (B 0 j) * Fin.cases 1
    (fun i ↦ MvPolynomial.X
      (⟨p + i, by omega⟩ : Fin (p + q))) j

theorem minusFirstRowForm_eq_algebraMap (p q : ℕ)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega) :
    minusFirstRowForm p q B =
      algebraMap (MvPolynomial (Fin (p + q)) Omega)
        (orderedResidualField (Omega := Omega) p q)
        (minusFirstRowPolynomial p q B) := by
  rw [minusFirstRowForm, minusFirstRowPolynomial, map_sum]
  apply Finset.sum_congr rfl
  intro j hj
  rw [map_mul]
  change algebraMap Omega (orderedResidualField (Omega := Omega) p q) (B 0 j) *
      minusGenericVector p q j = _
  rw [MvPolynomial.C_eq_algebraMap,
    IsScalarTower.algebraMap_apply Omega
      (MvPolynomial (Fin (p + q)) Omega)
      (orderedResidualField (Omega := Omega) p q)]
  congr 1
  refine Fin.cases ?_ ?_ j
  · simp [minusGenericVector]
  · intro i
    simp [minusGenericVector, orderedResidualGenerator]

theorem minusFirstRowPolynomial_ne_zero (p q : ℕ)
    (B : Matrix.GeneralLinearGroup (Fin (q + 1)) Omega) :
    minusFirstRowPolynomial p q (B : Matrix _ _ Omega) ≠ 0 := by
  have hrow : ((B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega) 0) ≠ 0 :=
    (Matrix.linearIndependent_rows_of_det_ne_zero
      (Matrix.GeneralLinearGroup.det_ne_zero B)).ne_zero 0
  by_cases h00 : (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega) 0 0 = 0
  · have hex : ∃ i : Fin q,
        (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega) 0 i.succ ≠ 0 := by
      by_contra h
      push Not at h
      apply hrow
      funext j
      refine Fin.cases h00 ?_ j
      intro i
      exact h i
    obtain ⟨i, hi⟩ := hex
    intro hP
    have heval := congrArg
      (MvPolynomial.eval (fun k : Fin (p + q) ↦
        if k = (⟨p + i, by omega⟩ : Fin (p + q)) then 1 else 0)) hP
    dsimp [minusFirstRowPolynomial] at heval
    simp only [map_sum, map_mul, MvPolynomial.eval_C, map_zero] at heval
    rw [Fin.sum_univ_succ] at heval
    simp [h00, Fin.ext_iff] at heval
    have hs : (∑ x : Fin q, if (x : Nat) = (i : Nat)
        then (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega) 0 x.succ
        else 0) = (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega) 0 i.succ := by
      rw [Finset.sum_eq_single i]
      · simp
      · intro b hb hbi
        have hv : (b : Nat) ≠ (i : Nat) := fun h ↦ hbi (Fin.ext h)
        simp [hv]
      · simp
    rw [hs] at heval
    exact hi heval
  · intro hP
    have heval := congrArg
      (MvPolynomial.eval (fun _ : Fin (p + q) ↦ (0 : Omega))) hP
    dsimp [minusFirstRowPolynomial] at heval
    simp only [map_sum, map_mul, MvPolynomial.eval_C, map_zero] at heval
    rw [Fin.sum_univ_succ] at heval
    simp at heval
    exact h00 heval

public theorem minusFirstRowForm_ne_zero (p q : ℕ)
    (B : Matrix.GeneralLinearGroup (Fin (q + 1)) Omega) :
    minusFirstRowForm p q (B : Matrix _ _ Omega) ≠ 0 := by
  rw [minusFirstRowForm_eq_algebraMap]
  intro hz
  apply minusFirstRowPolynomial_ne_zero p q B
  apply (FaithfulSMul.algebraMap_injective
    (MvPolynomial (Fin (p + q)) Omega)
    (orderedResidualField (Omega := Omega) p q))
  simpa using hz

@[expose] public noncomputable def blockNormalMultiplier
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    centralizer sigma →
      (orderedResidualField (Omega := Omega) p q)ˣ := fun n ↦
  Units.mk0
    (minusFirstRowForm p q
        (↑(minusCentralizerMatrixRepresentation R sigma q bm n) :
          Matrix (Fin (q + 1)) (Fin (q + 1)) Omega) /
      plusFirstRowForm p q
        (↑(plusCentralizerMatrixRepresentation R sigma p bp n) :
          Matrix (Fin (p + 1)) (Fin (p + 1)) Omega))
    (div_ne_zero
      (minusFirstRowForm_ne_zero p q
        (minusCentralizerMatrixRepresentation R sigma q bm n))
      (plusFirstRowForm_ne_zero p q
        (plusCentralizerMatrixRepresentation R sigma p bp n)))

@[simp]
theorem plusFirstRowForm_one (p q : ℕ) :
    plusFirstRowForm (Omega := Omega) p q
      (1 : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega) = 1 := by
  simp [plusFirstRowForm, plusGenericVector, Matrix.one_apply]

@[simp]
theorem minusFirstRowForm_neg_one (p q : ℕ) :
    minusFirstRowForm (Omega := Omega) p q
      (-1 : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega) = -1 := by
  simp [minusFirstRowForm, minusGenericVector, Matrix.one_apply]

/-- The distinguished involution scales the normal parameter by `-1`, as
required: it is identity on the plus projective factor and scalar `-1` on
the minus factor. -/
public theorem blockNormalMultiplier_sigma
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    blockNormalMultiplier R sigma p q bp bm (sigmaCentralizer sigma) = -1 := by
  apply Units.ext
  simp [blockNormalMultiplier, plusCentralizerMatrixRepresentation_sigma,
    minusCentralizerMatrixRepresentation_sigma]

/-- Equality with a transported semidirect action on `κ(T)` reduces to the
coefficient field and the single normal generator.  This is the exact
generator-level target for a projective chart computation. -/
theorem conjugate_xAdicRatFuncEquiv_eq_of_C_X
    {kappa L : Type u} [Field kappa] [Field L]
    (e : RatFunc kappa ≃+* L) (tau : kappa ≃+* kappa) (v : kappaˣ)
    (f : L →+* L)
    (hC : ∀ c : kappa,
      f (e (algebraMap (Polynomial kappa) (RatFunc kappa)
        (Polynomial.C c))) =
        e (algebraMap (Polynomial kappa) (RatFunc kappa)
          (Polynomial.C (tau c))))
    (hX :
      f (e (algebraMap (Polynomial kappa) (RatFunc kappa)
        (@Polynomial.X kappa _))) =
        e (algebraMap (Polynomial kappa) (RatFunc kappa)
          ((Polynomial.C (v : kappa) : Polynomial kappa) *
            (@Polynomial.X kappa _)))) :
    (e.toRingHom.comp (xAdicRatFuncEquiv kappa tau v).toRingHom).comp
        e.symm.toRingHom = f := by
  apply RingHom.ext
  intro y
  obtain ⟨x, rfl⟩ := e.surjective y
  simp only [RingHom.comp_apply]
  change e (xAdicRatFuncEquiv kappa tau v (e.symm (e x))) = f (e x)
  rw [RingEquiv.symm_apply_apply]
  have hfield :
      e.toRingHom.comp (xAdicRatFuncEquiv kappa tau v).toRingHom =
        f.comp e.toRingHom := by
    apply IsFractionRing.ringHom_ext (A := Polynomial kappa)
    intro p
    have hpoly :
        (e.toRingHom.comp
          (xAdicRatFuncEquiv kappa tau v).toRingHom).comp
            (algebraMap (Polynomial kappa) (RatFunc kappa)) =
          (f.comp e.toRingHom).comp
            (algebraMap (Polynomial kappa) (RatFunc kappa)) := by
      apply Polynomial.ringHom_ext
      · intro c
        simp only [RingHom.comp_apply]
        change e (xAdicRatFuncEquiv kappa tau v
          (algebraMap (Polynomial kappa) (RatFunc kappa)
            (Polynomial.C c))) = _
        rw [xAdicRatFuncEquiv_algebraMap, xAdicPolynomialEquiv_C]
        exact (hC c).symm
      · simp only [RingHom.comp_apply]
        change e (xAdicRatFuncEquiv kappa tau v
          (algebraMap (Polynomial kappa) (RatFunc kappa)
            (@Polynomial.X kappa _))) = _
        rw [xAdicRatFuncEquiv_algebraMap, xAdicPolynomialEquiv_X]
        exact hX.symm
    exact DFunLike.congr_fun hpoly p
  exact DFunLike.congr_fun hfield x

/-- Equality on the residual rational field reduces to constants and its
`Fin r` polynomial generators. -/
theorem conjugate_fractionRingEquiv_eq_of_C_X
    (r : ℕ) {L : Type u} [Field L]
    (e : FractionRing (MvPolynomial (Fin r) Omega) ≃+* L)
    (tau : FractionRing (MvPolynomial (Fin r) Omega) ≃+*
      FractionRing (MvPolynomial (Fin r) Omega))
    (f : L →+* L)
    (hC : ∀ c : Omega,
      f (e (algebraMap (MvPolynomial (Fin r) Omega)
          (FractionRing (MvPolynomial (Fin r) Omega)) (MvPolynomial.C c))) =
        e (tau (algebraMap (MvPolynomial (Fin r) Omega)
          (FractionRing (MvPolynomial (Fin r) Omega)) (MvPolynomial.C c))))
    (hX : ∀ i : Fin r,
      f (e (algebraMap (MvPolynomial (Fin r) Omega)
          (FractionRing (MvPolynomial (Fin r) Omega)) (MvPolynomial.X i))) =
        e (tau (algebraMap (MvPolynomial (Fin r) Omega)
          (FractionRing (MvPolynomial (Fin r) Omega)) (MvPolynomial.X i)))) :
    (e.toRingHom.comp tau.toRingHom).comp e.symm.toRingHom = f := by
  apply RingHom.ext
  intro y
  obtain ⟨x, rfl⟩ := e.surjective y
  simp only [RingHom.comp_apply]
  change e (tau (e.symm (e x))) = f (e x)
  rw [RingEquiv.symm_apply_apply]
  have hfield : e.toRingHom.comp tau.toRingHom = f.comp e.toRingHom := by
    apply IsFractionRing.ringHom_ext
      (A := MvPolynomial (Fin r) Omega)
    intro P
    have hpoly :
        (e.toRingHom.comp tau.toRingHom).comp
            (algebraMap (MvPolynomial (Fin r) Omega)
              (FractionRing (MvPolynomial (Fin r) Omega))) =
          (f.comp e.toRingHom).comp
            (algebraMap (MvPolynomial (Fin r) Omega)
              (FractionRing (MvPolynomial (Fin r) Omega))) := by
      apply MvPolynomial.ringHom_ext
      · intro c
        simp only [RingHom.comp_apply]
        change e (tau (algebraMap (MvPolynomial (Fin r) Omega)
          (FractionRing (MvPolynomial (Fin r) Omega)) (MvPolynomial.C c))) = _
        exact (hC c).symm
      · intro i
        simp only [RingHom.comp_apply]
        change e (tau (algebraMap (MvPolynomial (Fin r) Omega)
          (FractionRing (MvPolynomial (Fin r) Omega)) (MvPolynomial.X i))) = _
        exact (hX i).symm
    exact DFunLike.congr_fun hpoly P
  exact DFunLike.congr_fun hfield x

theorem fractionRing_ringHom_ext_C_X
    (r : ℕ) {L : Type u} [Field L]
    (f h : FractionRing (MvPolynomial (Fin r) Omega) →+* L)
    (hC : ∀ c : Omega,
      f (algebraMap (MvPolynomial (Fin r) Omega)
        (FractionRing (MvPolynomial (Fin r) Omega)) (MvPolynomial.C c)) =
      h (algebraMap (MvPolynomial (Fin r) Omega)
        (FractionRing (MvPolynomial (Fin r) Omega)) (MvPolynomial.C c)))
    (hX : ∀ i : Fin r,
      f (algebraMap (MvPolynomial (Fin r) Omega)
        (FractionRing (MvPolynomial (Fin r) Omega)) (MvPolynomial.X i)) =
      h (algebraMap (MvPolynomial (Fin r) Omega)
        (FractionRing (MvPolynomial (Fin r) Omega)) (MvPolynomial.X i))) :
    f = h := by
  apply IsFractionRing.ringHom_ext (A := MvPolynomial (Fin r) Omega)
  intro P
  have hpoly : f.comp (algebraMap (MvPolynomial (Fin r) Omega)
        (FractionRing (MvPolynomial (Fin r) Omega))) =
      h.comp (algebraMap (MvPolynomial (Fin r) Omega)
        (FractionRing (MvPolynomial (Fin r) Omega))) := by
    apply MvPolynomial.ringHom_ext
    · exact hC
    · exact hX
  exact DFunLike.congr_fun hpoly P

/-- For the corrected ordered plus/minus chart, the full source
function-field comparison follows from its coefficient and normal-coordinate
formulas. -/
theorem pointwiseSemidirectSourceEquiv_eq_actionFunctionFieldMap_of_C_X
    {N : Type u} [Group N] (d : ℕ)
    (X : Action (Over (linearBase Omega)) N) [IsIntegral X.V.left]
    (eK : LinearNormalFractionField d Omega ≃+* X.V.left.functionField)
    (n : N) (g : pointwiseLinearSemidirectGroup (Omega := Omega) d)
    (hC : ∀ c : LinearResidualField d Omega,
      (Scheme.actionFunctionFieldMap X n).hom
          (eK (algebraMap (Polynomial (LinearResidualField d Omega))
            (LinearNormalFractionField d Omega) (Polynomial.C c))) =
        eK (algebraMap (Polynomial (LinearResidualField d Omega))
          (LinearNormalFractionField d Omega) (Polynomial.C (g.right c))))
    (hT :
      (Scheme.actionFunctionFieldMap X n).hom
          (eK (algebraMap (Polynomial (LinearResidualField d Omega))
            (LinearNormalFractionField d Omega)
              (@Polynomial.X (LinearResidualField d Omega) _))) =
        eK (algebraMap (Polynomial (LinearResidualField d Omega))
          (LinearNormalFractionField d Omega)
            ((Polynomial.C (g.left : LinearResidualField d Omega) :
              Polynomial (LinearResidualField d Omega)) *
              (@Polynomial.X (LinearResidualField d Omega) _)))) :
    (pointwiseSemidirectSourceEquiv d eK g).toRingHom =
      (Scheme.actionFunctionFieldMap X n).hom := by
  simpa [pointwiseSemidirectSourceEquiv, conjugateRingEquiv,
    xAdicSemidirectRatFuncAction_apply] using
      conjugate_xAdicRatFuncEquiv_eq_of_C_X eK g.right g.left
        (Scheme.actionFunctionFieldMap X n).hom hC hT

/-- Readable coefficient/parameter interface for the source comparison. -/
theorem pointwiseSemidirectSourceEquiv_eq_actionFunctionFieldMap_of_coefficient_parameter
    {N : Type u} [Group N] (d : ℕ)
    (X : Action (Over (linearBase Omega)) N) [IsIntegral X.V.left]
    (eK : LinearNormalFractionField d Omega ≃+* X.V.left.functionField)
    (n : N) (g : pointwiseLinearSemidirectGroup (Omega := Omega) d)
    (hcoeff : ∀ c : LinearResidualField d Omega,
      (Scheme.actionFunctionFieldMap X n).hom
          (linearNormalCoefficientEmbedding d eK c) =
        linearNormalCoefficientEmbedding d eK (g.right c))
    (hparam :
      (Scheme.actionFunctionFieldMap X n).hom
          (linearNormalParameterElement d eK) =
        linearNormalScaledParameterElement d eK (g.left : _)) :
    (pointwiseSemidirectSourceEquiv d eK g).toRingHom =
      (Scheme.actionFunctionFieldMap X n).hom := by
  exact pointwiseSemidirectSourceEquiv_eq_actionFunctionFieldMap_of_C_X
    d X eK n g hcoeff hparam

/-- For residual dimension `p+q`, equality on the coefficient field is
generated by ground-field constants and the `p+q` affine variables.  This
form avoids unfolding the large corrected chart during specialization. -/
public theorem pointwiseSemidirectSourceEquiv_eq_actionFunctionFieldMap_of_residual_generators
    {N : Type u} [Group N] (p q : ℕ)
    (X : Action (Over (linearBase Omega)) N) [IsIntegral X.V.left]
    (eK : LinearNormalFractionField (Nat.succ (p + q)) Omega ≃+*
      X.V.left.functionField)
    (n : N)
    (g : pointwiseLinearSemidirectGroup (Omega := Omega)
      (Nat.succ (p + q)))
    (hbase : ∀ c : Omega,
      (Scheme.actionFunctionFieldMap X n).hom
          (linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK
            (baseToResidualField (Nat.succ (p + q)) Omega c)) =
        linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK
          (g.right (baseToResidualField (Nat.succ (p + q)) Omega c)))
    (hgen : ∀ i : Fin (p + q),
      (Scheme.actionFunctionFieldMap X n).hom
          (linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK
            (orderedResidualGenerator p q i)) =
        linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK
          (g.right (orderedResidualGenerator p q i)))
    (hparam :
      (Scheme.actionFunctionFieldMap X n).hom
          (linearNormalParameterElement (Nat.succ (p + q)) eK) =
        linearNormalScaledParameterElement (Nat.succ (p + q)) eK
          (g.left : _)) :
    (pointwiseSemidirectSourceEquiv (Nat.succ (p + q)) eK g).toRingHom =
      (Scheme.actionFunctionFieldMap X n).hom := by
  apply pointwiseSemidirectSourceEquiv_eq_actionFunctionFieldMap_of_coefficient_parameter
    (Nat.succ (p + q)) X eK n g _ hparam
  intro c
  let f : FractionRing (MvPolynomial (Fin (p + q)) Omega) →+*
      X.V.left.functionField :=
    (Scheme.actionFunctionFieldMap X n).hom.comp
      (linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK)
  let h : FractionRing (MvPolynomial (Fin (p + q)) Omega) →+*
      X.V.left.functionField :=
    (linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK).comp
      g.right.toRingHom
  have hfh : f = h := fractionRing_ringHom_ext_C_X (Omega := Omega)
    (p + q) f h (by
      intro z
      exact hbase z) (by
      intro i
      exact hgen i)
  exact DFunLike.congr_fun hfh c

/-- The exceptional comparison is determined by constants and the
`Fin (p+q)` residual chart generators. -/
theorem pointwiseSemidirectExceptionalEquiv_eq_actionFunctionFieldMap_of_C_X
    {N : Type u} [Group N] (p q : ℕ)
    (E : Action (Over (linearBase Omega)) N) [IsIntegral E.V.left]
    (eE : LinearExceptionalFunctionField (Nat.succ (p + q)) Omega ≃+*
      E.V.left.functionField)
    (n : N)
    (g : pointwiseLinearSemidirectGroup (Omega := Omega) (Nat.succ (p + q)))
    (hC : ∀ c : Omega,
      (Scheme.actionFunctionFieldMap E n).hom
          (eE (algebraMap (MvPolynomial (Fin (p + q)) Omega)
            (FractionRing (MvPolynomial (Fin (p + q)) Omega))
              (MvPolynomial.C c))) =
        eE (g.right (algebraMap (MvPolynomial (Fin (p + q)) Omega)
          (FractionRing (MvPolynomial (Fin (p + q)) Omega))
            (MvPolynomial.C c))))
    (hX : ∀ i : Fin (p + q),
      (Scheme.actionFunctionFieldMap E n).hom
          (eE (algebraMap (MvPolynomial (Fin (p + q)) Omega)
            (FractionRing (MvPolynomial (Fin (p + q)) Omega))
              (MvPolynomial.X i))) =
        eE (g.right (algebraMap (MvPolynomial (Fin (p + q)) Omega)
          (FractionRing (MvPolynomial (Fin (p + q)) Omega))
            (MvPolynomial.X i)))) :
    (pointwiseSemidirectExceptionalEquiv (Nat.succ (p + q)) eE g).toRingHom =
      (Scheme.actionFunctionFieldMap E n).hom := by
  change (eE.toRingHom.comp g.right.toRingHom).comp eE.symm.toRingHom = _
  exact conjugate_fractionRingEquiv_eq_of_C_X (Omega := Omega) (p + q)
    eE g.right (Scheme.actionFunctionFieldMap E n).hom hC hX

/-- For ambient dimension `p+q+1`, the corrected source comparison is already
determined by the ground-field constants, the `p+q` residual coordinates, and
the one normal coordinate.  Thus the remaining projective-chart calculation
is a finite family of explicit coordinate identities. -/
public theorem pointwiseSemidirectSourceEquiv_eq_actionFunctionFieldMap_of_residual_C_X_T
    {N : Type u} [Group N] (p q : ℕ)
    (X : Action (Over (linearBase Omega)) N) [IsIntegral X.V.left]
    (eK : LinearNormalFractionField (Nat.succ (p + q)) Omega ≃+*
      X.V.left.functionField)
    (n : N)
    (g : pointwiseLinearSemidirectGroup (Omega := Omega)
      (Nat.succ (p + q)))
    (hC : ∀ c : Omega,
      (Scheme.actionFunctionFieldMap X n).hom
          (eK (algebraMap
            (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
            (LinearNormalFractionField (Nat.succ (p + q)) Omega)
            (Polynomial.C (algebraMap
              (MvPolynomial (Fin (p + q)) Omega)
              (FractionRing (MvPolynomial (Fin (p + q)) Omega))
              (MvPolynomial.C c))))) =
        eK (algebraMap
          (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
          (LinearNormalFractionField (Nat.succ (p + q)) Omega)
          (Polynomial.C (g.right (algebraMap
            (MvPolynomial (Fin (p + q)) Omega)
            (FractionRing (MvPolynomial (Fin (p + q)) Omega))
            (MvPolynomial.C c))))))
    (hU : ∀ i : Fin (p + q),
      (Scheme.actionFunctionFieldMap X n).hom
          (eK (algebraMap
            (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
            (LinearNormalFractionField (Nat.succ (p + q)) Omega)
            (Polynomial.C (algebraMap
              (MvPolynomial (Fin (p + q)) Omega)
              (FractionRing (MvPolynomial (Fin (p + q)) Omega))
              (MvPolynomial.X i))))) =
        eK (algebraMap
          (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
          (LinearNormalFractionField (Nat.succ (p + q)) Omega)
          (Polynomial.C (g.right (algebraMap
            (MvPolynomial (Fin (p + q)) Omega)
            (FractionRing (MvPolynomial (Fin (p + q)) Omega))
            (MvPolynomial.X i))))))
    (hT :
      (Scheme.actionFunctionFieldMap X n).hom
          (eK (algebraMap
            (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
            (LinearNormalFractionField (Nat.succ (p + q)) Omega)
              (@Polynomial.X
                (LinearResidualField (Nat.succ (p + q)) Omega) _))) =
        eK (algebraMap
          (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
          (LinearNormalFractionField (Nat.succ (p + q)) Omega)
            ((Polynomial.C
              (g.left : LinearResidualField (Nat.succ (p + q)) Omega) :
                Polynomial
                  (LinearResidualField (Nat.succ (p + q)) Omega)) *
              (@Polynomial.X
                (LinearResidualField (Nat.succ (p + q)) Omega) _)))) :
    (pointwiseSemidirectSourceEquiv (Nat.succ (p + q)) eK g).toRingHom =
      (Scheme.actionFunctionFieldMap X n).hom := by
  apply pointwiseSemidirectSourceEquiv_eq_actionFunctionFieldMap_of_C_X
    (Nat.succ (p + q)) X eK n g _ hT
  intro c
  let coeff : LinearResidualField (Nat.succ (p + q)) Omega →+*
      LinearNormalFractionField (Nat.succ (p + q)) Omega :=
    (algebraMap
      (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
      (LinearNormalFractionField (Nat.succ (p + q)) Omega)).comp
        Polynomial.C
  let f : FractionRing (MvPolynomial (Fin (p + q)) Omega) →+*
      X.V.left.functionField :=
    (Scheme.actionFunctionFieldMap X n).hom.comp
      (eK.toRingHom.comp coeff)
  let h : FractionRing (MvPolynomial (Fin (p + q)) Omega) →+*
      X.V.left.functionField :=
    (eK.toRingHom.comp coeff).comp g.right.toRingHom
  have hfh : f = h := fractionRing_ringHom_ext_C_X (Omega := Omega)
    (p + q) f h (by
      intro z
      change (Scheme.actionFunctionFieldMap X n).hom
          (eK (algebraMap
            (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
            (LinearNormalFractionField (Nat.succ (p + q)) Omega)
            (Polynomial.C (algebraMap
              (MvPolynomial (Fin (p + q)) Omega)
              (FractionRing (MvPolynomial (Fin (p + q)) Omega))
              (MvPolynomial.C z))))) = _
      rw [hC z]
      rfl) (by
      intro i
      change (Scheme.actionFunctionFieldMap X n).hom
          (eK (algebraMap
            (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
            (LinearNormalFractionField (Nat.succ (p + q)) Omega)
            (Polynomial.C (algebraMap
              (MvPolynomial (Fin (p + q)) Omega)
              (FractionRing (MvPolynomial (Fin (p + q)) Omega))
              (MvPolynomial.X i))))) = _
      rw [hU i]
      rfl)
  have hc := DFunLike.congr_fun hfh c
  change (Scheme.actionFunctionFieldMap X n).hom
      (eK (algebraMap
        (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
        (LinearNormalFractionField (Nat.succ (p + q)) Omega)
        (Polynomial.C c))) =
      eK (algebraMap
        (Polynomial (LinearResidualField (Nat.succ (p + q)) Omega))
        (LinearNormalFractionField (Nat.succ (p + q)) Omega)
        (Polynomial.C (g.right c))) at hc
  exact hc

end V14Formalization.SchemeGeometry
