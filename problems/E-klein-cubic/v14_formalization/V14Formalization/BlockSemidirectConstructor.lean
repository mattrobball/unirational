import V14Formalization.ActionSpecific
import V14Formalization.CorrectedOrderedConstructor
import V14Formalization.CorrectedOrderedProjectiveChart
import V14Formalization.CorrectedSourceFunctionFieldRatio
import V14Formalization.GenericCharts
import V14Formalization.BiprojectiveFunctionFieldRows

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

universe u

variable {Omega : Type u} [Field Omega]
  {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module Omega V]

/-- The corrected pointwise semidirect element attached to the two
centralizer blocks.  Its left component is the explicit quotient
`B₀(v)/A₀(u)`, while its right component is transported from the actual
exceptional action. -/
noncomputable def orderedBlockSemidirectElement
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (eE : LinearExceptionalFunctionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusExceptionalAction
        R sigma p q bp bm).V.left.functionField)
    (n : centralizer sigma) :
    pointwiseLinearSemidirectGroup (Omega := Omega) (p + q + 1) :=
  semidirectElementOfExceptionalAction (p + q + 1)
    (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm) eE
    (blockNormalMultiplier R sigma p q bp bm) n

@[simp]
theorem orderedBlockSemidirectElement_left
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (eE : LinearExceptionalFunctionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusExceptionalAction
        R sigma p q bp bm).V.left.functionField)
    (n : centralizer sigma) :
    (orderedBlockSemidirectElement R sigma p q bp bm eE n).left =
      blockNormalMultiplier R sigma p q bp bm n := rfl

@[simp]
theorem orderedBlockSemidirectElement_sigma_left
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (eE : LinearExceptionalFunctionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusExceptionalAction
        R sigma p q bp bm).V.left.functionField) :
  (orderedBlockSemidirectElement R sigma p q bp bm eE
      (sigmaCentralizer sigma)).left = -1 := by
  rw [orderedBlockSemidirectElement_left, blockNormalMultiplier_sigma]
  rfl

theorem orderedBlockSemidirectElement_exceptional_field_map
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (eE : LinearExceptionalFunctionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusExceptionalAction
        R sigma p q bp bm).V.left.functionField)
    (n : centralizer sigma) :
    (pointwiseSemidirectExceptionalEquiv (p + q + 1) eE
      (orderedBlockSemidirectElement R sigma p q bp bm eE n)).toRingHom =
        (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusExceptionalAction
            R sigma p q bp bm) n).hom :=
  semidirectElementOfExceptionalAction_exceptional_field_map
    (p + q + 1)
    (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm) eE
    (blockNormalMultiplier R sigma p q bp bm) n

/-- Pointwise form of the exceptional comparison.  Keeping this as a named
bridge prevents downstream row calculations from unfolding the pullback
action package and its proof-dependent carrier. -/
theorem orderedBlockSemidirectElement_right_map
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (eE : LinearExceptionalFunctionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusExceptionalAction
        R sigma p q bp bm).V.left.functionField)
    (n : centralizer sigma)
    (x : LinearExceptionalFunctionField (p + q + 1) Omega) :
    eE ((orderedBlockSemidirectElement R sigma p q bp bm eE n).right x) =
      (Scheme.actionFunctionFieldMap
        (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm) n).hom
          (eE x) := by
  have h := DFunLike.congr_fun
    (orderedBlockSemidirectElement_exceptional_field_map
      R sigma p q bp bm eE n) (eE x)
  change eE ((orderedBlockSemidirectElement R sigma p q bp bm eE n).right
    (eE.symm (eE x))) = _ at h
  rw [eE.symm_apply_apply] at h
  exact h

/-- The residual action on a genuine plus-chart generator is the expected
row ratio of the plus centralizer block. -/
theorem orderedBlockSemidirectElement_right_plusGenerator
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (r q : ℕ)
    (bp : Basis (Fin ((r + 1) + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (n : centralizer sigma) (i : Fin (r + 1)) :
    let A := (↑(plusCentralizerMatrixRepresentation R sigma (r + 1) bp n) :
      Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    let g := orderedBlockSemidirectElement R sigma (r + 1) q bp bm
      (biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega) n
    g.right (orderedResidualGenerator (r + 1) q
        ⟨i, lt_of_lt_of_le i.isLt (Nat.le_add_right (r + 1) q)⟩) =
      exceptionalPlusRowForm (r + 1) q A i.succ /
        exceptionalPlusRowForm (r + 1) q A 0 := by
  dsimp only
  let E : Action (Over (linearBase Omega)) (centralizer sigma) :=
    normalDivisorActionOver R sigma (r + 1) q bp bm
  let eE : LinearExceptionalFunctionField ((r + 1) + q + 1) Omega ≃+*
      E.V.left.functionField :=
    biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega
  have hinput : orderedResidualGenerator (Omega := Omega) (r + 1) q
      ⟨i, lt_of_lt_of_le i.isLt (Nat.le_add_right (r + 1) q)⟩ =
      exceptionalPlusGenericVector (r + 1) q i.succ := rfl
  apply eE.injective
  have hleft := orderedBlockSemidirectElement_right_map
    R sigma (r + 1) q bp bm eE n
      (orderedResidualGenerator (r + 1) q
        ⟨i, lt_of_lt_of_le i.isLt (Nat.le_add_right (r + 1) q)⟩)
  rw [hleft, hinput]
  exact normalDivisorAction_functionFieldMap_plusGenerator
    R sigma r q bp bm n i

/-- The analogous row-ratio formula on a genuine minus-chart generator. -/
theorem orderedBlockSemidirectElement_right_minusGenerator
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (p r : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin ((r + 1) + 1)) Omega (R.minusEigenspace sigma))
    (n : centralizer sigma) (i : Fin (r + 1)) :
    let B := (↑(minusCentralizerMatrixRepresentation R sigma (r + 1) bm n) :
      Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    let g := orderedBlockSemidirectElement R sigma p (r + 1) bp bm
      (biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega) n
    g.right (orderedResidualGenerator p (r + 1) ⟨p + i, by omega⟩) =
      exceptionalMinusRowForm p (r + 1) B i.succ /
        exceptionalMinusRowForm p (r + 1) B 0 := by
  dsimp only
  let E : Action (Over (linearBase Omega)) (centralizer sigma) :=
    normalDivisorActionOver R sigma p (r + 1) bp bm
  let eE : LinearExceptionalFunctionField (p + (r + 1) + 1) Omega ≃+*
      E.V.left.functionField :=
    biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega
  have hinput : orderedResidualGenerator (Omega := Omega) p (r + 1)
      ⟨p + i, by omega⟩ = exceptionalMinusGenericVector p (r + 1) i.succ := rfl
  apply eE.injective
  have hleft := orderedBlockSemidirectElement_right_map
    R sigma p (r + 1) bp bm eE n
      (orderedResidualGenerator p (r + 1) ⟨p + i, by omega⟩)
  rw [hleft, hinput]
  exact normalDivisorAction_functionFieldMap_minusGenerator
    R sigma p r bp bm n i

/-- The residual component chosen from the actual exceptional action fixes
the embedded ground field.  Opaque local abbreviations keep this proof within
the stock recursion limit; no elaboration limit is raised. -/
theorem orderedBlockSemidirectElement_right_C_base
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (n : centralizer sigma) (c : Omega) :
    (orderedBlockSemidirectElement R sigma p q bp bm
      (biprojectiveGeneralFunctionFieldEquiv p q Omega) n).right
      (baseToResidualField (Nat.succ (p + q)) Omega c) =
    baseToResidualField (Nat.succ (p + q)) Omega c := by
  let E : Action (Over (linearBase Omega)) (centralizer sigma) :=
    correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm
  let eE : LinearExceptionalFunctionField (Nat.succ (p + q)) Omega ≃+*
      E.V.left.functionField :=
    biprojectiveGeneralFunctionFieldEquiv p q Omega
  have hebase : ∀ z : Omega,
      eE (baseToResidualField (Nat.succ (p + q)) Omega z) =
        functionFieldBaseRingHom Omega E.V.left E.V.hom z := by
    intro z
    change biprojectiveGeneralFunctionFieldEquiv p q Omega
        (baseToResidualField (Nat.succ (p + q)) Omega z) = _
    rw [biprojectiveGeneralFunctionFieldEquiv_base,
      biprojectiveGeneralBaseToFunctionField_eq]
    rfl
  exact residualEquivOfAction_base
    (Nat.succ (p + q)) E eE n hebase c

/-- For the corrected ordered source chart, the complete function-field
comparison is reduced to the `p+q` residual generators and the one normal
parameter. Ground-field constants are discharged structurally from the two
over-base actions. -/
theorem correctedOrdered_sourceFieldMap_of_residual_X_T
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (n : centralizer sigma)
    (hU : ∀ i : Fin (p + q),
      let X := correctedOrderedPlusMinusSourceAction
        R sigma hsigma p q bp bm
      let eK := correctedOrderedLinearNormalFunctionFieldEquiv
        (Omega := Omega) p q
      let g := orderedBlockSemidirectElement R sigma p q bp bm
        (biprojectiveGeneralFunctionFieldEquiv p q Omega) n
      (Scheme.actionFunctionFieldMap X n).hom
          (linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK
            (orderedResidualGenerator p q i)) =
        linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK
          (g.right (orderedResidualGenerator p q i)))
    (hT :
      let X := correctedOrderedPlusMinusSourceAction
        R sigma hsigma p q bp bm
      let eK := correctedOrderedLinearNormalFunctionFieldEquiv
        (Omega := Omega) p q
      let g := orderedBlockSemidirectElement R sigma p q bp bm
        (biprojectiveGeneralFunctionFieldEquiv p q Omega) n
      (Scheme.actionFunctionFieldMap X n).hom
          (linearNormalParameterElement (Nat.succ (p + q)) eK) =
        linearNormalScaledParameterElement (Nat.succ (p + q)) eK
          (g.left : _)) :
    let X := correctedOrderedPlusMinusSourceAction
      R sigma hsigma p q bp bm
    let eK := correctedOrderedLinearNormalFunctionFieldEquiv
      (Omega := Omega) p q
    let g := orderedBlockSemidirectElement R sigma p q bp bm
      (biprojectiveGeneralFunctionFieldEquiv p q Omega) n
    (pointwiseSemidirectSourceEquiv (Nat.succ (p + q)) eK g).toRingHom =
      (Scheme.actionFunctionFieldMap X n).hom := by
  let X := correctedOrderedPlusMinusSourceAction
    R sigma hsigma p q bp bm
  let eK := correctedOrderedLinearNormalFunctionFieldEquiv
    (Omega := Omega) p q
  let g := orderedBlockSemidirectElement R sigma p q bp bm
    (biprojectiveGeneralFunctionFieldEquiv p q Omega) n
  apply pointwiseSemidirectSourceEquiv_eq_actionFunctionFieldMap_of_residual_generators
    p q X eK n g
  · intro c
    have hg : g.right (baseToResidualField (Nat.succ (p + q)) Omega c) =
        baseToResidualField (Nat.succ (p + q)) Omega c := by
      exact orderedBlockSemidirectElement_right_C_base
        R sigma p q bp bm n c
    rw [hg]
    exact correctedSource_actionFunctionFieldMap_C_base
      R sigma hsigma p q bp bm n c
  · intro i
    change (Scheme.actionFunctionFieldMap X n).hom
        (linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK
          (orderedResidualGenerator p q i)) =
      linearNormalCoefficientEmbedding (Nat.succ (p + q)) eK
        (g.right (orderedResidualGenerator p q i))
    exact hU i
  · change (Scheme.actionFunctionFieldMap X n).hom
        (linearNormalParameterElement (Nat.succ (p + q)) eK) =
      linearNormalScaledParameterElement (Nat.succ (p + q)) eK (g.left : _)
    exact hT

/-- With the block multiplier and canonical exceptional component fixed, the
whole equivariant normal datum needs only the corrected source chart
comparison. -/
noncomputable def orderedPlusMinusEquivariantNormalDataOfBlocks
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (eK : LinearNormalFractionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusSourceAction
        R sigma hsigma p q bp bm).V.left.functionField)
    (eE : LinearExceptionalFunctionField (p + q + 1) Omega ≃+*
      (correctedOrderedPlusMinusExceptionalAction
        R sigma p q bp bm).V.left.functionField)
    (generic_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartGenericHom (p + q + 1) Omega
            (correctedOrderedPlusMinusSourceAction
              R sigma hsigma p q bp bm).V.left eK)) ≫
          linearNormalValuation_toBase (p + q + 1) Omega =
        (correctedOrderedPlusMinusSourceAction
          R sigma hsigma p q bp bm).V.left.fromSpecStalk _ ≫
          (correctedOrderedPlusMinusSourceAction
            R sigma hsigma p q bp bm).V.hom)
    (special_toBase :
      Spec.map (CommRingCat.ofHom
          (linearChartResidueHom (p + q + 1) Omega
            (correctedOrderedPlusMinusExceptionalAction
              R sigma p q bp bm).V.left eE)) ≫
          linearNormalValuation_toBase (p + q + 1) Omega =
        (correctedOrderedPlusMinusExceptionalAction
          R sigma p q bp bm).V.left.fromSpecStalk _ ≫
          (correctedOrderedPlusMinusExceptionalAction
            R sigma p q bp bm).V.hom)
    (source_field_map : ∀ n,
      (pointwiseSemidirectSourceEquiv (p + q + 1) eK
        (orderedBlockSemidirectElement R sigma p q bp bm eE n)).toRingHom =
        (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction
            R sigma hsigma p q bp bm) n).hom) :
    EquivariantNormalValuationData
      (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm)
      (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm) :=
  orderedPlusMinusEquivariantNormalDataOfNormalMultiplier
    R sigma hsigma p q bp bm eK eE generic_toBase special_toBase
    (blockNormalMultiplier R sigma p q bp bm) source_field_map

/-- Concrete corrected-chart constructor.  Both chart equivalences and both
base squares are discharged; the only remaining hypothesis is the actual
projective source-action comparison. -/
noncomputable def orderedPlusMinusEquivariantNormalDataOfCorrectedChart
    [CharZero Omega]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (hsigma : IsInvolution sigma) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (source_field_map : ∀ n,
      (pointwiseSemidirectSourceEquiv (p + q + 1)
        (correctedOrderedLinearNormalFunctionFieldEquiv p q)
        (orderedBlockSemidirectElement R sigma p q bp bm
          (biprojectiveGeneralFunctionFieldEquiv p q Omega) n)).toRingHom =
        (Scheme.actionFunctionFieldMap
          (correctedOrderedPlusMinusSourceAction
            R sigma hsigma p q bp bm) n).hom) :
    EquivariantNormalValuationData
      (correctedOrderedPlusMinusSourceAction R sigma hsigma p q bp bm)
      (correctedOrderedPlusMinusExceptionalAction R sigma p q bp bm) :=
  orderedPlusMinusEquivariantNormalDataOfBlocks
    R sigma hsigma p q bp bm
    (correctedOrderedLinearNormalFunctionFieldEquiv p q)
    (biprojectiveGeneralFunctionFieldEquiv p q Omega)
    (correctedOrderedLinearNormal_generic_toBase p q)
    (biprojectiveLinearNormal_special_toBase p q Omega)
    source_field_map

end V14Formalization.SchemeGeometry
