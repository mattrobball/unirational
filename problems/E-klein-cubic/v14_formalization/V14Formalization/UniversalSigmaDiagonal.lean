module

public import V14Formalization.SchemeFixedProjectiveCoordinates
public import V14Formalization.PlusMinusBlockMatrix

/-!
# The involution matrix in the universal plus/minus basis

Point-level infrastructure only: this file identifies the matrix of `sigma`
in `plusMinusAmbientBasis` and feeds it to the checked fixed-coordinate
classifier.  It does not identify any scheme-theoretic fixed locus.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

universe u

variable {k L : Type u} [Field k] [Field L] [Algebra k L]
  {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

/-- General-dimensional version of the block-matrix calculation already used
in dimension `3+3`. -/
public theorem plusMinusMappedBasis_toMatrix_general [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :
    LinearMap.toMatrix
        ((bp.prod bm).map (plusMinusLinearEquiv R sigma hsigma).symm)
        ((bp.prod bm).map (plusMinusLinearEquiv R sigma hsigma).symm)
        (R.act (n : G)) =
      Matrix.fromBlocks
        (LinearMap.toMatrix bp bp (plusCentralizerRepresentation R sigma n))
        0 0
        (LinearMap.toMatrix bm bm (minusCentralizerRepresentation R sigma n)) := by
  rw [← LinearMap.toMatrix_prodMap bp bm]
  simp only [LinearMap.toMatrix_map_left, LinearMap.toMatrix_map_right]
  congr 1
  change ((plusMinusLinearEquiv R sigma hsigma).toLinearMap.comp
      (R.act (n : G))).comp
        (plusMinusLinearEquiv R sigma hsigma).symm.toLinearMap = _
  rw [plusMinusLinearEquiv_conjugates_centralizer R sigma hsigma n,
    LinearMap.comp_assoc]
  simp

public theorem plusMinusAmbientBasis_toMatrix_general [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :
    LinearMap.toMatrix
        (plusMinusAmbientBasis R sigma hsigma p q bp bm)
        (plusMinusAmbientBasis R sigma hsigma p q bp bm)
        (R.act (n : G)) =
      (Matrix.fromBlocks
        (LinearMap.toMatrix bp bp (plusCentralizerRepresentation R sigma n))
        0 0
        (LinearMap.toMatrix bm bm (minusCentralizerRepresentation R sigma n))).submatrix
          (plusMinusFinEquiv p q).symm (plusMinusFinEquiv p q).symm := by
  ext i j
  simp only [plusMinusAmbientBasis, LinearMap.toMatrix_apply,
    Basis.repr_reindex, Basis.coe_reindex, Function.comp_apply,
    Matrix.submatrix_apply, Finsupp.mapDomain_equiv_apply]
  simpa only [LinearMap.toMatrix_apply] using congrFun (congrFun
    (plusMinusMappedBasis_toMatrix_general R sigma hsigma n p q bp bm)
      ((plusMinusFinEquiv p q).symm i))
        ((plusMinusFinEquiv p q).symm j)

public theorem ambientMatrixRepresentation_centralizer_block_general [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :
    (↑(ambientMatrixRepresentation R (p + q + 1)
        (plusMinusAmbientBasis R sigma hsigma p q bp bm) (n : G)) :
      Matrix (Fin ((p + q + 1) + 1)) (Fin ((p + q + 1) + 1)) k) =
      (Matrix.fromBlocks
        (LinearMap.toMatrix bp bp (plusCentralizerRepresentation R sigma n))
        0 0
        (LinearMap.toMatrix bm bm (minusCentralizerRepresentation R sigma n))).submatrix
          (plusMinusFinEquiv p q).symm (plusMinusFinEquiv p q).symm := by
  change LinearMap.toMatrix
      (plusMinusAmbientBasis R sigma hsigma p q bp bm)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm)
      (R.act (n : G)) = _
  exact plusMinusAmbientBasis_toMatrix_general
    R sigma hsigma n p q bp bm

/-- Coordinate sign in the concatenated plus-then-minus basis. -/
@[expose] public def plusMinusSigmaSign (p q : ℕ) :
    Fin ((p + q + 1) + 1) → k := fun i ↦
  Sum.elim (fun _ ↦ 1) (fun _ ↦ -1) ((plusMinusFinEquiv p q).symm i)

@[simp]
theorem plusMinusSigmaSign_plus (p q : ℕ) (i : Fin (p + 1)) :
    plusMinusSigmaSign (k := k) p q
      (plusMinusFinEquiv p q (Sum.inl i)) = 1 := by
  simp [plusMinusSigmaSign]

@[simp]
theorem plusMinusSigmaSign_minus (p q : ℕ) (i : Fin (q + 1)) :
    plusMinusSigmaSign (k := k) p q
      (plusMinusFinEquiv p q (Sum.inr i)) = -1 := by
  simp [plusMinusSigmaSign]

theorem plusMinusSigmaSign_eq_one_or_neg_one (p q : ℕ)
    (i : Fin ((p + q + 1) + 1)) :
    plusMinusSigmaSign (k := k) p q i = 1 ∨
      plusMinusSigmaSign (k := k) p q i = -1 := by
  unfold plusMinusSigmaSign
  cases h : (plusMinusFinEquiv p q).symm i <;> simp [h]

/-- In the universal plus/minus ambient basis, `sigma` is literally diagonal:
`+1` on the plus block and `-1` on the minus block. -/
public theorem ambientMatrixRepresentation_sigma_diagonal [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :
    (↑(ambientMatrixRepresentation R (p + q + 1)
        (plusMinusAmbientBasis R sigma hsigma p q bp bm) sigma) :
      Matrix (Fin ((p + q + 1) + 1)) (Fin ((p + q + 1) + 1)) k) =
      Matrix.diagonal (plusMinusSigmaSign (k := k) p q) := by
  have hblock :
      Matrix.fromBlocks
        (LinearMap.toMatrix bp bp
          (plusCentralizerRepresentation R sigma (sigmaCentralizer sigma)))
        0 0
        (LinearMap.toMatrix bm bm
          (minusCentralizerRepresentation R sigma (sigmaCentralizer sigma))) =
      Matrix.diagonal (fun s : Fin (p + 1) ⊕ Fin (q + 1) ↦
        Sum.elim (fun _ ↦ (1 : k)) (fun _ ↦ -1) s) := by
    rw [plusCentralizerRepresentation_sigma,
      minusCentralizerRepresentation_sigma]
    ext i j
    rcases i with i | i <;> rcases j with j | j
    · simp [Matrix.diagonal, Matrix.one_apply]
    · simp [Matrix.diagonal, Matrix.one_apply]
    · simp [Matrix.diagonal, Matrix.one_apply]
    · by_cases hij : i = j <;> simp [Matrix.diagonal, Matrix.one_apply, hij]
  have hcentral := ambientMatrixRepresentation_centralizer_block_general
    R sigma hsigma (sigmaCentralizer sigma) p q bp bm
  change LinearMap.toMatrix
      (plusMinusAmbientBasis R sigma hsigma p q bp bm)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm)
      (R.act sigma) = _
  change LinearMap.toMatrix
      (plusMinusAmbientBasis R sigma hsigma p q bp bm)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm)
      (R.act (sigmaCentralizer sigma : G)) = _
  change LinearMap.toMatrix
      (plusMinusAmbientBasis R sigma hsigma p q bp bm)
      (plusMinusAmbientBasis R sigma hsigma p q bp bm)
      (R.act (sigmaCentralizer sigma : G)) = _ at hcentral
  rw [hcentral, hblock]
  ext i j
  simp only [Matrix.submatrix_apply, Matrix.diagonal, Matrix.of_apply]
  by_cases hij : i = j
  · subst j
    simp [plusMinusSigmaSign]
  · have hsymm : (plusMinusFinEquiv p q).symm i ≠
        (plusMinusFinEquiv p q).symm j := by
      exact fun h ↦ hij ((plusMinusFinEquiv p q).symm.injective h)
    simp [hij, hsymm]

/-- A nondegenerate involution supplies projective bases in which the preceding
diagonal formula and its sign predicate hold. -/
public theorem exists_plusMinusBasis_sigma_diagonal [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hsigma : IsInvolution sigma)
    (hnd : ¬ R.DegeneratesToPlusMinusId sigma) :
    ∃ (p q : ℕ)
        (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
        (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)),
      (↑(ambientMatrixRepresentation R (p + q + 1)
          (plusMinusAmbientBasis R sigma hsigma p q bp bm) sigma) :
        Matrix (Fin ((p + q + 1) + 1)) (Fin ((p + q + 1) + 1)) k) =
        Matrix.diagonal (plusMinusSigmaSign (k := k) p q) ∧
      ∀ i, plusMinusSigmaSign (k := k) p q i = 1 ∨
        plusMinusSigmaSign (k := k) p q i = -1 := by
  obtain ⟨p, q, ⟨bp⟩, ⟨bm⟩⟩ :=
    exists_plus_minus_projective_bases R sigma hsigma hnd
  exact ⟨p, q, bp, bm,
    ambientMatrixRepresentation_sigma_diagonal R sigma hsigma p q bp bm,
    plusMinusSigmaSign_eq_one_or_neg_one p q⟩

/-- The checked point classifier specialized to the actual involution matrix
in the universal plus/minus basis. -/
public theorem exists_normalizedCoordinates_support_of_sigma_fixed
    [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hsigma : IsInvolution sigma) (pdim qdim : ℕ)
    (bp : Basis (Fin (pdim + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (qdim + 1)) k (R.minusEigenspace sigma))
    (p : Spec (.of L) ⟶ ProjectiveSpace (pdim + qdim + 1) k)
    (hpbase : p ≫ ProjectiveSpace.toSpec (pdim + qdim + 1) k =
      Spec.map (CommRingCat.ofHom (algebraMap k L)))
    (hfixed : p ≫ projectiveActionHom
      (ambientMatrixRepresentation R (pdim + qdim + 1)
        (plusMinusAmbientBasis R sigma hsigma pdim qdim bp bm)) sigma = p) :
    ∃ (j : Fin ((pdim + qdim + 1) + 1))
        (x : Fin ((pdim + qdim + 1) + 1) → L),
      x j = 1 ∧
      p = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k)
        (pdim + qdim + 1) j x ∧
      ((plusMinusSigmaSign (k := k) pdim qdim j = 1 ∧
          ∀ l, plusMinusSigmaSign (k := k) pdim qdim l = -1 → x l = 0) ∨
        (plusMinusSigmaSign (k := k) pdim qdim j = -1 ∧
          ∀ l, plusMinusSigmaSign (k := k) pdim qdim l = 1 → x l = 0)) := by
  letI : NeZero (2 : k) := ⟨by norm_num⟩
  exact exists_normalizedCoordinates_support_of_projectiveActionHom_fixed
    (pdim + qdim + 1)
    (ambientMatrixRepresentation R (pdim + qdim + 1)
      (plusMinusAmbientBasis R sigma hsigma pdim qdim bp bm))
    sigma (plusMinusSigmaSign (k := k) pdim qdim)
    (plusMinusSigmaSign_eq_one_or_neg_one pdim qdim)
    (ambientMatrixRepresentation_sigma_diagonal R sigma hsigma pdim qdim bp bm)
    p hpbase hfixed

end V14Formalization.SchemeGeometry
