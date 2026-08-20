module

public import V14Formalization.D12ProjectorReduction
public import V14Formalization.D12U6Semantic
public import V14Formalization.D12F6Semantic
public import V14Formalization.D12CompoundR

noncomputable section

open Matrix Polynomial

namespace V14Formalization.D12GeneratorPolynomialCore

open D12PolynomialData D12PolynomialEvaluation

@[expose] public def S6_poly : Matrix (Fin 6) (Fin 6) (Polynomial ℚ) :=
  Matrix.of fun i j =>
    if j.val = 0 then D12U6Semantic.cFourierPoly
    else D12U6Semantic.cFourierPoly *
      (D12U6Semantic.phasePoly ((i.val : ZMod 11) * (j.val : ZMod 11)) +
        D12U6Semantic.phasePoly (-((i.val : ZMod 11) * (j.val : ZMod 11))))

@[expose] public def T6_poly : Matrix (Fin 6) (Fin 6) (Polynomial ℚ) :=
  Matrix.diagonal fun j =>
    D12U6Semantic.phasePoly ((j.val : ZMod 11) ^ 2)

/-- The integral phase matrix underlying the Fourier generator.  Factoring the
common Fourier scalar before checking invariance keeps every generated
certificate sparse and bounded. -/
@[expose] public def S6Phase_poly : Matrix (Fin 6) (Fin 6) (Polynomial ℚ) :=
  Matrix.of fun i j =>
    if j.val = 0 then 1
    else
      D12U6Semantic.phasePoly
          ((i.val : ZMod 11) * (j.val : ZMod 11)) +
        D12U6Semantic.phasePoly
          (-((i.val : ZMod 11) * (j.val : ZMod 11)))

theorem S6_poly_eq_cFourier_smul :
    S6_poly = D12U6Semantic.cFourierPoly • S6Phase_poly := by
  ext i j
  by_cases hj : j = 0
  · subst j
    simp [S6_poly, S6Phase_poly]
  · simp [S6_poly, S6Phase_poly, hj, smul_eq_mul]

/-- The order-two compound is quadratic under scalar multiplication. -/
theorem compound2Lex_smul {R : Type*} [CommRing R]
    (c : R) (A : Matrix (Fin 6) (Fin 6) R) :
    PluckerNaturality.compound2Lex (c • A) =
      (c * c) • PluckerNaturality.compound2Lex A := by
  ext i j
  simp [PluckerNaturality.compound2Lex, Matrix.det_fin_two, smul_eq_mul]
  ring

/-- Entrywise two-by-two determinant formula in the fixed lexicographic pair
coordinates.  Generated shards use this without unfolding order-embedding
proofs. -/
public theorem compound2Lex_apply_pairLex {R : Type*} [CommRing R]
    (A : Matrix (Fin 6) (Fin 6) R) (i j : Fin 15) :
    PluckerNaturality.compound2Lex A i j =
      A (PluckerNaturality.pairLexVec i 0)
          (PluckerNaturality.pairLexVec j 0) *
        A (PluckerNaturality.pairLexVec i 1)
          (PluckerNaturality.pairLexVec j 1) -
      A (PluckerNaturality.pairLexVec i 0)
          (PluckerNaturality.pairLexVec j 1) *
        A (PluckerNaturality.pairLexVec i 1)
          (PluckerNaturality.pairLexVec j 0) := by
  rw [PluckerNaturality.compound2Lex]
  simp only [Matrix.of_apply]
  rw [PluckerNaturality.pairEmb_eq_pairLexEmb,
    PluckerNaturality.pairEmb_eq_pairLexEmb, Matrix.det_fin_two]
  rfl

public theorem compound_S6_mul_B_factor :
    PluckerNaturality.compound2Lex S6_poly * B_poly =
      (D12U6Semantic.cFourierPoly * D12U6Semantic.cFourierPoly) •
        (PluckerNaturality.compound2Lex S6Phase_poly * B_poly) := by
  rw [S6_poly_eq_cFourier_smul, compound2Lex_smul, Matrix.smul_mul]

/-- Lift a sparse phase-matrix relation through a common scalar factor. -/
public theorem relation_of_smul_factor
    (G H : Matrix (Fin 15) (Fin 10) (Polynomial ℚ))
    (s q : Polynomial ℚ) (c : ℚ) (i k : Fin 15) (j : Fin 10)
    (hfactor : G = s • H)
    (hrel : H i j - C c * H k j = Phi11 * q) :
    G i j - C c * G k j = Phi11 * (s * q) := by
  rw [hfactor]
  simp only [Matrix.smul_apply, smul_eq_mul]
  calc
    s * H i j - C c * (s * H k j) =
        s * (H i j - C c * H k j) := by ring
    _ = s * (Phi11 * q) := by rw [hrel]
    _ = Phi11 * (s * q) := by ring

theorem evalMatrixK_S6_poly : evalMatrixK S6_poly = WeilRep.S6 := by
  ext i j
  by_cases hj : j = 0
  · subst j
    simp [S6_poly, evalMatrixAt, WeilRep.S6,
      D12U6Semantic.eval_cFourierPoly]
  · simp [S6_poly, evalMatrixAt, WeilRep.S6, hj,
      map_mul, map_add, D12U6Semantic.eval_cFourierPoly,
      D12U6Semantic.eval_phasePoly]

theorem evalMatrixK_T6_poly : evalMatrixK T6_poly = WeilRep.T6 := by
  ext i j
  by_cases h : i = j
  · subst i
    simp [T6_poly, evalMatrixAt, WeilRep.T6,
      D12U6Semantic.eval_phasePoly]
  · simp [T6_poly, evalMatrixAt, WeilRep.T6, h]

theorem compound2Lex_neg {R : Type*} [CommRing R]
    (A : Matrix (Fin 6) (Fin 6) R) :
    PluckerNaturality.compound2Lex (-A) =
      PluckerNaturality.compound2Lex A := by
  ext i j
  simp [PluckerNaturality.compound2Lex, Matrix.det_fin_two]

set_option synthInstance.maxHeartbeats 40000 in
theorem actualS_eq_compound_S6 :
    (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (QuotientGroup.mk PSLCard.Smat) :
      Matrix (Fin 15) (Fin 15) WeilRep.K) =
      PluckerNaturality.compound2Lex WeilRep.S6 := by
  rw [Lambda2Coordinates.lambda2MatrixRepresentation_coe]
  change LinearMap.toMatrix Lambda2Coordinates.lambda2Basis
      Lambda2Coordinates.lambda2Basis
      (GeometricFanoCarrier.pslLambda2Hom
        (QuotientGroup.mk PSLCard.Smat)) = _
  rw [GeometricFanoCarrier.pslLambda2_mk,
    PluckerNaturality.weilLambda2_toMatrix_eq_compound2Lex]
  have hmat : LinearMap.toMatrix Lambda2Coordinates.uBasisCore
      Lambda2Coordinates.uBasisCore
      (WeilHom.weilUHom PSLCard.Smat) = -WeilRep.S6 := by
    change LinearMap.toMatrix Lambda2Coordinates.uBasisCore
      Lambda2Coordinates.uBasisCore
      (WeilHom.weilUHom WeilRep.Smat) = -WeilRep.S6
    rw [show WeilHom.weilUHom WeilRep.Smat = -WeilRep.S_even by
        exact WeilRepSL2.weilU_Smat]
    calc
      LinearMap.toMatrix Lambda2Coordinates.uBasisCore
          Lambda2Coordinates.uBasisCore (-WeilRep.S_even) =
          -(LinearMap.toMatrix Lambda2Coordinates.uBasisCore
            Lambda2Coordinates.uBasisCore WeilRep.S_even) := by
        ext i j
        simp [LinearMap.toMatrix_apply]
      _ = -WeilRep.S6 := congrArg Neg.neg
        D12U6Fourier.toMatrix_Seven_eq_S6
  rw [hmat, compound2Lex_neg]

theorem actualT2_eq_compound_T6 :
    (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (QuotientGroup.mk (PSLCard.Tmat ^ 2)) :
      Matrix (Fin 15) (Fin 15) WeilRep.K) =
      PluckerNaturality.compound2Lex WeilRep.T6 := by
  rw [Lambda2Coordinates.lambda2MatrixRepresentation_coe]
  change LinearMap.toMatrix Lambda2Coordinates.lambda2Basis
      Lambda2Coordinates.lambda2Basis
      (GeometricFanoCarrier.pslLambda2Hom
        (QuotientGroup.mk (PSLCard.Tmat ^ 2))) = _
  rw [GeometricFanoCarrier.pslLambda2_mk,
    PluckerNaturality.weilLambda2_toMatrix_eq_compound2Lex]
  have hmat : LinearMap.toMatrix Lambda2Coordinates.uBasisCore
      Lambda2Coordinates.uBasisCore
      (WeilHom.weilUHom (PSLCard.Tmat ^ 2)) = WeilRep.T6 := by
    change LinearMap.toMatrix Lambda2Coordinates.uBasisCore
      Lambda2Coordinates.uBasisCore
      (WeilHom.weilUHom D12F6Semantic.T2) = WeilRep.T6
    rw [D12F6Semantic.weilUHom_T2,
      D12F6Semantic.toMatrix_Teven2_eq_T6]
  rw [hmat]

/-- Evaluation commutes with the order-two compound, specialized to the two
standard generator matrices. -/
theorem evalMatrixK_compound_S6_poly :
    evalMatrixK (PluckerNaturality.compound2Lex S6_poly) =
      PluckerNaturality.compound2Lex WeilRep.S6 := by
  change evalMatrixAt WeilRep.ζ (PluckerNaturality.compound2Lex S6_poly) = _
  rw [D12CompoundR.evalMatrixAt_compound2Lex]
  exact congrArg PluckerNaturality.compound2Lex evalMatrixK_S6_poly

theorem evalMatrixK_compound_T6_poly :
    evalMatrixK (PluckerNaturality.compound2Lex T6_poly) =
      PluckerNaturality.compound2Lex WeilRep.T6 := by
  change evalMatrixAt WeilRep.ζ (PluckerNaturality.compound2Lex T6_poly) = _
  rw [D12CompoundR.evalMatrixAt_compound2Lex]
  exact congrArg PluckerNaturality.compound2Lex evalMatrixK_T6_poly

/-- The polynomial Fourier generator evaluates to the genuine projective
exterior-square action. -/
public theorem evalMatrixK_compound_S6_poly_eq_actualS :
    evalMatrixK (PluckerNaturality.compound2Lex S6_poly) =
      (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (QuotientGroup.mk PSLCard.Smat) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) := by
  rw [evalMatrixK_compound_S6_poly, actualS_eq_compound_S6]

/-- The polynomial diagonal generator evaluates to the genuine action of
`Tmat²`. -/
public theorem evalMatrixK_compound_T6_poly_eq_actualT2 :
    evalMatrixK (PluckerNaturality.compound2Lex T6_poly) =
      (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (QuotientGroup.mk (PSLCard.Tmat ^ 2)) :
          Matrix (Fin 15) (Fin 15) WeilRep.K) := by
  rw [evalMatrixK_compound_T6_poly, actualT2_eq_compound_T6]

/-- A single polynomial relation modulo `Φ₁₁` becomes the corresponding
linear relation after evaluation at a root of `Φ₁₁`.  Generated row
shards use this lemma one coordinate at a time. -/
public theorem eval_relation_of_modPhi
    {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (hPhi : evalPolyAt z Phi11 = 0)
    (a b q : Polynomial ℚ) (c : ℚ)
    (h : a - C c * b = Phi11 * q) :
    evalPolyAt z a = algebraMap ℚ R c * evalPolyAt z b := by
  have he := congrArg (evalPolyAt z) h
  simp only [map_sub, map_mul, hPhi, zero_mul] at he
  have hc : evalPolyAt z (C c) = algebraMap ℚ R c := by
    simp [evalPolyAt]
  rw [hc] at he
  exact sub_eq_zero.mp he

/-! Sparse column formulas for right multiplication by the fixed basis `B`.
Keeping these ten formulas in the core prevents every generator shard from
re-expanding a fifteen-term matrix product. -/

public theorem mul_B_col0
    (G : Matrix (Fin 15) (Fin 15) (Polynomial ℚ)) (i : Fin 15) :
    (G * B_poly) i 0 = G i 0 + G i 13 * C (-1 / 2) := by
  simp [Matrix.mul_apply, B_poly, Matrix.of_apply,
    Fin.sum_univ_succ]

public theorem mul_B_col1
    (G : Matrix (Fin 15) (Fin 15) (Polynomial ℚ)) (i : Fin 15) :
    (G * B_poly) i 1 = G i 1 + G i 8 * C (1 / 2) := by
  simp [Matrix.mul_apply, B_poly, Matrix.of_apply,
    Fin.sum_univ_succ]

public theorem mul_B_col2
    (G : Matrix (Fin 15) (Fin 15) (Polynomial ℚ)) (i : Fin 15) :
    (G * B_poly) i 2 = G i 2 + G i 10 * C (-1 / 2) := by
  simp [Matrix.mul_apply, B_poly, Matrix.of_apply,
    Fin.sum_univ_succ]

public theorem mul_B_col3
    (G : Matrix (Fin 15) (Fin 15) (Polynomial ℚ)) (i : Fin 15) :
    (G * B_poly) i 3 = G i 3 + G i 5 * C (-1 / 2) := by
  simp [Matrix.mul_apply, B_poly, Matrix.of_apply,
    Fin.sum_univ_succ]

public theorem mul_B_col4
    (G : Matrix (Fin 15) (Fin 15) (Polynomial ℚ)) (i : Fin 15) :
    (G * B_poly) i 4 = G i 4 + G i 12 * C (1 / 2) := by
  simp [Matrix.mul_apply, B_poly, Matrix.of_apply,
    Fin.sum_univ_succ]

public theorem mul_B_col5
    (G : Matrix (Fin 15) (Fin 15) (Polynomial ℚ)) (i : Fin 15) :
    (G * B_poly) i 5 = G i 6 := by
  simp [Matrix.mul_apply, B_poly, Matrix.of_apply,
    Fin.sum_univ_succ]

public theorem mul_B_col6
    (G : Matrix (Fin 15) (Fin 15) (Polynomial ℚ)) (i : Fin 15) :
    (G * B_poly) i 6 = G i 7 := by
  simp [Matrix.mul_apply, B_poly, Matrix.of_apply,
    Fin.sum_univ_succ]

public theorem mul_B_col7
    (G : Matrix (Fin 15) (Fin 15) (Polynomial ℚ)) (i : Fin 15) :
    (G * B_poly) i 7 = G i 9 := by
  simp [Matrix.mul_apply, B_poly, Matrix.of_apply,
    Fin.sum_univ_succ]

public theorem mul_B_col8
    (G : Matrix (Fin 15) (Fin 15) (Polynomial ℚ)) (i : Fin 15) :
    (G * B_poly) i 8 = G i 11 := by
  simp [Matrix.mul_apply, B_poly, Matrix.of_apply,
    Fin.sum_univ_succ]

public theorem mul_B_col9
    (G : Matrix (Fin 15) (Fin 15) (Polynomial ℚ)) (i : Fin 15) :
    (G * B_poly) i 9 = G i 14 := by
  simp [Matrix.mul_apply, B_poly, Matrix.of_apply,
    Fin.sum_univ_succ]

@[expose] public def freeRow : Fin 10 → Fin 15
  | ⟨0, h⟩ => ⟨0, by omega⟩
  | ⟨1, h⟩ => ⟨1, by omega⟩
  | ⟨2, h⟩ => ⟨2, by omega⟩
  | ⟨3, h⟩ => ⟨3, by omega⟩
  | ⟨4, h⟩ => ⟨4, by omega⟩
  | ⟨5, h⟩ => ⟨6, by omega⟩
  | ⟨6, h⟩ => ⟨7, by omega⟩
  | ⟨7, h⟩ => ⟨9, by omega⟩
  | ⟨8, h⟩ => ⟨11, by omega⟩
  | ⟨9, h⟩ => ⟨14, by omega⟩

@[expose] public def restrictedAction {R : Type*} [CommRing R]
    (Cmat : Matrix (Fin 15) (Fin 10) R) :
    Matrix (Fin 10) (Fin 10) R :=
  Matrix.of fun i j => Cmat (freeRow i) j

private theorem row0 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 0 j =
      Cmat 0 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]

private theorem row1 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 1 j = Cmat 1 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]

private theorem row2 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 2 j = Cmat 2 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]

private theorem row3 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 3 j = Cmat 3 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]

private theorem row4 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 4 j = Cmat 4 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]

private theorem row5 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10)
    (h5 : Cmat 5 j = algebraMap ℚ R (-1 / 2) * Cmat 3 j) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 5 j =
      Cmat 5 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]
  simpa [evalPolyAt] using h5.symm

private theorem row6 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 6 j = Cmat 6 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]

private theorem row7 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 7 j = Cmat 7 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]

private theorem row8 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10)
    (h8 : Cmat 8 j = algebraMap ℚ R (1 / 2) * Cmat 1 j) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 8 j = Cmat 8 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]
  simpa [evalPolyAt] using h8.symm

private theorem row9 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 9 j = Cmat 9 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]

private theorem row10 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10)
    (h10 : Cmat 10 j = algebraMap ℚ R (-1 / 2) * Cmat 2 j) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 10 j = Cmat 10 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]
  simpa [evalPolyAt] using h10.symm

private theorem row11 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 11 j = Cmat 11 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]

private theorem row12 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10)
    (h12 : Cmat 12 j = algebraMap ℚ R (1 / 2) * Cmat 4 j) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 12 j = Cmat 12 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]
  simpa [evalPolyAt] using h12.symm

private theorem row13 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10)
    (h13 : Cmat 13 j = algebraMap ℚ R (-1 / 2) * Cmat 0 j) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 13 j = Cmat 13 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]
  simpa [evalPolyAt] using h13.symm

private theorem row14 {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R) (j : Fin 10) :
    (evalMatrixAt z B_poly * restrictedAction Cmat) 14 j = Cmat 14 j := by
  simp [evalMatrixAt, B_poly, restrictedAction, freeRow,
    Matrix.mul_apply, Fin.sum_univ_succ]

public theorem mul_B_eq_B_mul_restrictedAction_of_relations
    {R : Type*} [CommRing R] [Algebra ℚ R]
    (z : R) (Cmat : Matrix (Fin 15) (Fin 10) R)
    (h5 : ∀ j, Cmat 5 j = algebraMap ℚ R (-1 / 2) * Cmat 3 j)
    (h8 : ∀ j, Cmat 8 j = algebraMap ℚ R (1 / 2) * Cmat 1 j)
    (h10 : ∀ j, Cmat 10 j = algebraMap ℚ R (-1 / 2) * Cmat 2 j)
    (h12 : ∀ j, Cmat 12 j = algebraMap ℚ R (1 / 2) * Cmat 4 j)
    (h13 : ∀ j, Cmat 13 j = algebraMap ℚ R (-1 / 2) * Cmat 0 j) :
    Cmat = evalMatrixAt z B_poly * restrictedAction Cmat := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact (row0 z Cmat j).symm
  · exact (row1 z Cmat j).symm
  · exact (row2 z Cmat j).symm
  · exact (row3 z Cmat j).symm
  · exact (row4 z Cmat j).symm
  · exact (row5 z Cmat j (h5 j)).symm
  · exact (row6 z Cmat j).symm
  · exact (row7 z Cmat j).symm
  · exact (row8 z Cmat j (h8 j)).symm
  · exact (row9 z Cmat j).symm
  · exact (row10 z Cmat j (h10 j)).symm
  · exact (row11 z Cmat j).symm
  · exact (row12 z Cmat j (h12 j)).symm
  · exact (row13 z Cmat j (h13 j)).symm
  · exact (row14 z Cmat j).symm

end V14Formalization.D12GeneratorPolynomialCore
