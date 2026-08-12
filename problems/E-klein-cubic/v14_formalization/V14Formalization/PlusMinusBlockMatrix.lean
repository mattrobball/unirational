/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.UniversalNormalDivisor

/-!
# Block coordinates for the centralizer action

In the basis obtained by concatenating bases of the two involution
eigenspaces, every centralizer element has the expected block-diagonal
matrix.
-/

noncomputable section

open CategoryTheory

namespace V14Formalization.SchemeGeometry

open Module

universe u

variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

theorem plusMinusLinearEquiv_conjugates_centralizer [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma) :
    (plusMinusLinearEquiv R sigma hsigma).toLinearMap.comp (R.act (n : G)) =
      ((plusCentralizerRepresentation R sigma n).prodMap
        (minusCentralizerRepresentation R sigma n)).comp
          (plusMinusLinearEquiv R sigma hsigma).toLinearMap := by
  apply LinearMap.ext
  intro v
  change plusMinusLinearEquiv R sigma hsigma (R.act (n : G) v) =
    (plusCentralizerRepresentation R sigma n).prodMap
      (minusCentralizerRepresentation R sigma n)
        (plusMinusLinearEquiv R sigma hsigma v)
  rw [plusMinusLinearEquiv_centralizer]
  apply Prod.ext
  · apply Subtype.ext
    rfl
  · apply Subtype.ext
    rfl

theorem plusMinusMappedBasis_toMatrix [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (bp : Basis (Fin 3) k (R.plusEigenspace sigma))
    (bm : Basis (Fin 3) k (R.minusEigenspace sigma)) :
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

theorem plusMinusAmbientBasis_toMatrix [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (bp : Basis (Fin 3) k (R.plusEigenspace sigma))
    (bm : Basis (Fin 3) k (R.minusEigenspace sigma)) :
    LinearMap.toMatrix
        (plusMinusAmbientBasis R sigma hsigma 2 2 bp bm)
        (plusMinusAmbientBasis R sigma hsigma 2 2 bp bm)
        (R.act (n : G)) =
      (Matrix.fromBlocks
        (LinearMap.toMatrix bp bp (plusCentralizerRepresentation R sigma n))
        0 0
        (LinearMap.toMatrix bm bm (minusCentralizerRepresentation R sigma n))).submatrix
          (plusMinusFinEquiv 2 2).symm (plusMinusFinEquiv 2 2).symm := by
  ext i j
  simp only [plusMinusAmbientBasis, LinearMap.toMatrix_apply,
    Basis.repr_reindex, Basis.coe_reindex, Function.comp_apply,
    Matrix.submatrix_apply, Finsupp.mapDomain_equiv_apply]
  simpa only [LinearMap.toMatrix_apply] using congrFun (congrFun
    (plusMinusMappedBasis_toMatrix R sigma hsigma n bp bm)
      ((plusMinusFinEquiv 2 2).symm i))
        ((plusMinusFinEquiv 2 2).symm j)

theorem ambientMatrixRepresentation_centralizer_block [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hsigma : IsInvolution sigma) (n : centralizer sigma)
    (bp : Basis (Fin 3) k (R.plusEigenspace sigma))
    (bm : Basis (Fin 3) k (R.minusEigenspace sigma)) :
    (↑(ambientMatrixRepresentation R 5
        (plusMinusAmbientBasis R sigma hsigma 2 2 bp bm) (n : G)) :
      Matrix (Fin 6) (Fin 6) k) =
      (Matrix.fromBlocks
        (LinearMap.toMatrix bp bp (plusCentralizerRepresentation R sigma n))
        0 0
        (LinearMap.toMatrix bm bm (minusCentralizerRepresentation R sigma n))).submatrix
          (plusMinusFinEquiv 2 2).symm (plusMinusFinEquiv 2 2).symm := by
  change LinearMap.toMatrix
      (plusMinusAmbientBasis R sigma hsigma 2 2 bp bm)
      (plusMinusAmbientBasis R sigma hsigma 2 2 bp bm)
      (R.act (n : G)) = _
  exact plusMinusAmbientBasis_toMatrix R sigma hsigma n bp bm

end V14Formalization.SchemeGeometry

