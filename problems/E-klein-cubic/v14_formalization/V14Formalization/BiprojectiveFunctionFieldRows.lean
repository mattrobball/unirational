import V14Formalization.BiprojectiveActionFunctionField
import V14Formalization.ProjectiveActionFunctionFieldRatio

noncomputable section

open CategoryTheory CategoryTheory.Limits TopologicalSpace
open scoped AlgebraicGeometry BigOperators

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

universe u
variable {Omega : Type u} [Field Omega]

local instance projectiveActionOver_isIntegral_row
    {N : Type u} [Group N]
    (d : ℕ) (M : MatrixRepresentation (k := Omega) (G := N) d) :
    IsIntegral (projectiveActionOver d M).V.left := by
  change IsIntegral (ProjectiveSpace d Omega)
  infer_instance

local instance plusProjectiveActionOver_isIntegral_row
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module Omega V]
    (R : FaithfulLinearRep Omega G V) (sigma : G) (d : ℕ)
    (b : Basis (Fin (d + 1)) Omega (R.plusEigenspace sigma)) :
    IsIntegral (plusProjectiveActionOver R sigma d b).V.left := by
  change IsIntegral (ProjectiveSpace d Omega)
  infer_instance

local instance minusProjectiveActionOver_isIntegral_row
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module Omega V]
    (R : FaithfulLinearRep Omega G V) (sigma : G) (d : ℕ)
    (b : Basis (Fin (d + 1)) Omega (R.minusEigenspace sigma)) :
    IsIntegral (minusProjectiveActionOver R sigma d b).V.left := by
  change IsIntegral (ProjectiveSpace d Omega)
  infer_instance

local instance plusMinusPullback_isIntegral_row
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module Omega V]
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    IsIntegral (pullback
      (plusProjectiveActionOver R sigma p bp).V.hom
      (minusProjectiveActionOver R sigma q bm).V.hom) := by
  change IsIntegral (BiprojectiveSpace p q Omega)
  infer_instance

theorem chartDehomogenization_linearSubst_eq_row
    (r : ℕ) (M : Matrix (Fin (r + 1)) (Fin (r + 1)) Omega)
    (i : Fin (r + 1)) :
    ProjectiveSpace.chartDehomogenization r Omega 0 (linearSubst r M i) =
      ∑ j, MvPolynomial.C (M i j) *
        Fin.cases (motive := fun _ => MvPolynomial (Fin r) Omega)
          (1 : MvPolynomial (Fin r) Omega)
          (fun k : Fin r => MvPolynomial.X k) j := by
  simp [linearSubst, ProjectiveSpace.chartDehomogenization]
  apply Finset.sum_congr rfl
  intro j hj
  rfl

def exceptionalPlusGenericVector (p q : ℕ) :
    Fin (p + 1) → LinearExceptionalFunctionField ((p + q) + 1) Omega :=
  Fin.cases 1 fun i =>
    algebraMap (MvPolynomial (Fin (((p + q) + 1) - 1)) Omega)
      (LinearExceptionalFunctionField ((p + q) + 1) Omega)
      (MvPolynomial.X ⟨i, by omega⟩)

def exceptionalMinusGenericVector (p q : ℕ) :
    Fin (q + 1) → LinearExceptionalFunctionField ((p + q) + 1) Omega :=
  Fin.cases 1 fun j =>
    algebraMap (MvPolynomial (Fin (((p + q) + 1) - 1)) Omega)
      (LinearExceptionalFunctionField ((p + q) + 1) Omega)
      (MvPolynomial.X ⟨p + j, by omega⟩)

def exceptionalPlusRowForm (p q : ℕ)
    (A : Matrix (Fin (p + 1)) (Fin (p + 1)) Omega)
    (i : Fin (p + 1)) :
    LinearExceptionalFunctionField ((p + q) + 1) Omega :=
  ∑ j, algebraMap Omega
      (LinearExceptionalFunctionField ((p + q) + 1) Omega) (A i j) *
    exceptionalPlusGenericVector p q j

def exceptionalMinusRowForm (p q : ℕ)
    (B : Matrix (Fin (q + 1)) (Fin (q + 1)) Omega)
    (i : Fin (q + 1)) :
    LinearExceptionalFunctionField ((p + q) + 1) Omega :=
  ∑ j, algebraMap Omega
      (LinearExceptionalFunctionField ((p + q) + 1) Omega) (B i j) *
    exceptionalMinusGenericVector p q j

def projectiveRowForm (r : ℕ)
    (A : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (i : Fin ((r + 1) + 1)) :
    FractionRing (MvPolynomial (Fin (r + 1)) Omega) :=
  algebraMap (MvPolynomial (Fin (r + 1)) Omega)
    (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
    (∑ j, MvPolynomial.C (A i j) *
      Fin.cases (1 : MvPolynomial (Fin (r + 1)) Omega)
        (fun k : Fin (r + 1) => MvPolynomial.X k) j)

theorem projectiveActionOver_actionFunctionFieldMap_X_row
    {N : Type u} [Group N]
    (r : ℕ) (M : MatrixRepresentation (k := Omega) (G := N) (r + 1))
    (n : N) (i : Fin (r + 1)) :
    (Scheme.actionFunctionFieldMap (projectiveActionOver (r + 1) M) n).hom
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
            (MvPolynomial.X i))) =
      projectiveGeneralFunctionFieldEquiv r Omega
          (projectiveRowForm r (M n) i.succ) /
        projectiveGeneralFunctionFieldEquiv r Omega
          (projectiveRowForm r (M n) 0) := by
  simpa [projectiveRowForm,
    chartDehomogenization_linearSubst_eq_row] using
    (projectiveActionOver_actionFunctionFieldMap_X
      (Omega := Omega) r M n i)

theorem plusProjectiveActionOver_actionFunctionFieldMap_X_row
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module Omega V]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (r : ℕ)
    (bp : Basis (Fin ((r + 1) + 1)) Omega (R.plusEigenspace sigma))
    (n : centralizer sigma) (i : Fin (r + 1)) :
    (Scheme.actionFunctionFieldMap
        (plusProjectiveActionOver R sigma (r + 1) bp) n).hom
      (projectiveGeneralFunctionFieldEquiv r Omega
        (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
          (MvPolynomial.X i))) =
      projectiveGeneralFunctionFieldEquiv r Omega
          (projectiveRowForm r
            (↑(plusCentralizerMatrixRepresentation R sigma (r + 1) bp n) :
              Matrix _ _ Omega) i.succ) /
        projectiveGeneralFunctionFieldEquiv r Omega
          (projectiveRowForm r
            (↑(plusCentralizerMatrixRepresentation R sigma (r + 1) bp n) :
              Matrix _ _ Omega) 0) := by
  unfold plusProjectiveActionOver
  exact projectiveActionOver_actionFunctionFieldMap_X_row
    r (plusCentralizerMatrixRepresentation R sigma (r + 1) bp) n i

theorem minusProjectiveActionOver_actionFunctionFieldMap_X_row
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module Omega V]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (r : ℕ)
    (bm : Basis (Fin ((r + 1) + 1)) Omega (R.minusEigenspace sigma))
    (n : centralizer sigma) (i : Fin (r + 1)) :
    (Scheme.actionFunctionFieldMap
        (minusProjectiveActionOver R sigma (r + 1) bm) n).hom
      (projectiveGeneralFunctionFieldEquiv r Omega
        (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
          (MvPolynomial.X i))) =
      projectiveGeneralFunctionFieldEquiv r Omega
          (projectiveRowForm r
            (↑(minusCentralizerMatrixRepresentation R sigma (r + 1) bm n) :
              Matrix _ _ Omega) i.succ) /
        projectiveGeneralFunctionFieldEquiv r Omega
          (projectiveRowForm r
            (↑(minusCentralizerMatrixRepresentation R sigma (r + 1) bm n) :
              Matrix _ _ Omega) 0) := by
  unfold minusProjectiveActionOver
  exact projectiveActionOver_actionFunctionFieldMap_X_row
    r (minusCentralizerMatrixRepresentation R sigma (r + 1) bm) n i

theorem biprojectiveFunctionFieldEquiv_plusGenericVector
    (r q : ℕ) (j : Fin ((r + 1) + 1)) :
    biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega
        (exceptionalPlusGenericVector (r + 1) q j) =
      (BiprojectiveSpace.fst (r + 1) q Omega).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
            (Fin.cases (1 : MvPolynomial (Fin (r + 1)) Omega)
              (fun i : Fin (r + 1) => MvPolynomial.X i) j))) := by
  refine Fin.cases ?_ ?_ j
  · simp only [exceptionalPlusGenericVector, Fin.cases_zero, map_one]
  · intro i
    change biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega
        (algebraMap (MvPolynomial (Fin ((r + 1) + q)) Omega)
          (FractionRing (MvPolynomial (Fin ((r + 1) + q)) Omega))
          (MvPolynomial.X ⟨i, by omega⟩)) = _
    have hind : (⟨i, by omega⟩ : Fin ((r + 1) + q)) =
        finSumFinEquiv (r + 1) q (Sum.inl i) := by
      apply Fin.ext
      simp [finSumFinEquiv]
    rw [hind]
    exact (biprojectiveGeneralFunctionFieldEquiv_X_inl
      (Omega := Omega) r q i).symm

theorem biprojectiveFunctionFieldEquiv_minusGenericVector
    (p r : ℕ) (j : Fin ((r + 1) + 1)) :
    biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega
        (exceptionalMinusGenericVector p (r + 1) j) =
      (BiprojectiveSpace.snd p (r + 1) Omega).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
            (Fin.cases (1 : MvPolynomial (Fin (r + 1)) Omega)
              (fun i : Fin (r + 1) => MvPolynomial.X i) j))) := by
  refine Fin.cases ?_ ?_ j
  · simp only [exceptionalMinusGenericVector, Fin.cases_zero, map_one]
  · intro i
    change biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega
        (algebraMap (MvPolynomial (Fin (p + (r + 1))) Omega)
          (FractionRing (MvPolynomial (Fin (p + (r + 1))) Omega))
          (MvPolynomial.X ⟨p + i, by omega⟩)) = _
    have hind : (⟨p + i, by omega⟩ : Fin (p + (r + 1))) =
        finSumFinEquiv p (r + 1) (Sum.inr i) := by
      apply Fin.ext
      simp [finSumFinEquiv]
    rw [hind]
    exact (biprojectiveGeneralFunctionFieldEquiv_X_inr
      (Omega := Omega) p r i).symm

theorem biprojectiveFunctionFieldEquiv_plusRowTerm
    (r q : ℕ) (c : Omega) (j : Fin ((r + 1) + 1)) :
    biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega
        (algebraMap Omega
            (LinearExceptionalFunctionField (((r + 1) + q) + 1) Omega) c *
          exceptionalPlusGenericVector (r + 1) q j) =
      (BiprojectiveSpace.fst (r + 1) q Omega).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
            (MvPolynomial.C c *
              Fin.cases (1 : MvPolynomial (Fin (r + 1)) Omega)
                (fun i : Fin (r + 1) => MvPolynomial.X i) j))) := by
  rw [map_mul, map_mul, map_mul, map_mul]
  rw [biprojectiveFunctionFieldEquiv_plusGenericVector]
  have hcoeff : biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega
        (algebraMap Omega
          (LinearExceptionalFunctionField (((r + 1) + q) + 1) Omega) c) =
      (BiprojectiveSpace.fst (r + 1) q Omega).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap Omega
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega)) c)) := by
    change biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega
        (baseToResidualField (((r + 1) + q) + 1) Omega c) = _
    rw [biprojectiveGeneralFunctionFieldEquiv_base,
      projectiveGeneralFunctionFieldEquiv_base,
      biprojectiveGeneralBaseToFunctionField_eq,
      projectiveGeneralBaseToFunctionField_eq]
    exact (biprojective_fst_functionFieldMap_base (r + 1) q c).symm
  rw [hcoeff]
  have hinput : algebraMap Omega
        (FractionRing (MvPolynomial (Fin (r + 1)) Omega)) c =
      algebraMap (MvPolynomial (Fin (r + 1)) Omega)
        (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
        (MvPolynomial.C c) := by
    exact IsScalarTower.algebraMap_apply Omega
      (MvPolynomial (Fin (r + 1)) Omega)
      (FractionRing (MvPolynomial (Fin (r + 1)) Omega)) c
  rw [hinput]

theorem biprojectiveFunctionFieldEquiv_minusRowTerm
    (p r : ℕ) (c : Omega) (j : Fin ((r + 1) + 1)) :
    biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega
        (algebraMap Omega
            (LinearExceptionalFunctionField ((p + (r + 1)) + 1) Omega) c *
          exceptionalMinusGenericVector p (r + 1) j) =
      (BiprojectiveSpace.snd p (r + 1) Omega).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
            (MvPolynomial.C c *
              Fin.cases (1 : MvPolynomial (Fin (r + 1)) Omega)
                (fun i : Fin (r + 1) => MvPolynomial.X i) j))) := by
  rw [map_mul, map_mul, map_mul, map_mul]
  rw [biprojectiveFunctionFieldEquiv_minusGenericVector]
  have hcoeff : biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega
        (algebraMap Omega
          (LinearExceptionalFunctionField ((p + (r + 1)) + 1) Omega) c) =
      (BiprojectiveSpace.snd p (r + 1) Omega).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap Omega
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega)) c)) := by
    change biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega
        (baseToResidualField ((p + (r + 1)) + 1) Omega c) = _
    rw [biprojectiveGeneralFunctionFieldEquiv_base,
      projectiveGeneralFunctionFieldEquiv_base,
      biprojectiveGeneralBaseToFunctionField_eq,
      projectiveGeneralBaseToFunctionField_eq]
    exact (biprojective_snd_functionFieldMap_base p (r + 1) c).symm
  rw [hcoeff]
  have hinput : algebraMap Omega
        (FractionRing (MvPolynomial (Fin (r + 1)) Omega)) c =
      algebraMap (MvPolynomial (Fin (r + 1)) Omega)
        (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
        (MvPolynomial.C c) := by
    exact IsScalarTower.algebraMap_apply Omega
      (MvPolynomial (Fin (r + 1)) Omega)
      (FractionRing (MvPolynomial (Fin (r + 1)) Omega)) c
  rw [hinput]

theorem biprojectiveFunctionFieldEquiv_plusRowForm
    (r q : ℕ)
    (A : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (i : Fin ((r + 1) + 1)) :
    biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega
        (exceptionalPlusRowForm (r + 1) q A i) =
      (BiprojectiveSpace.fst (r + 1) q Omega).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (projectiveRowForm r A i)) := by
  rw [exceptionalPlusRowForm, projectiveRowForm]
  rw [map_sum _ _ Finset.univ]
  rw [map_sum _ _ Finset.univ, map_sum _ _ Finset.univ,
    map_sum _ _ Finset.univ]
  apply Finset.sum_congr rfl
  intro j hj
  exact biprojectiveFunctionFieldEquiv_plusRowTerm r q (A i j) j

theorem biprojectiveFunctionFieldEquiv_minusRowForm
    (p r : ℕ)
    (B : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (i : Fin ((r + 1) + 1)) :
    biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega
        (exceptionalMinusRowForm p (r + 1) B i) =
      (BiprojectiveSpace.snd p (r + 1) Omega).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (projectiveRowForm r B i)) := by
  rw [exceptionalMinusRowForm, projectiveRowForm]
  rw [map_sum _ _ Finset.univ]
  rw [map_sum _ _ Finset.univ, map_sum _ _ Finset.univ,
    map_sum _ _ Finset.univ]
  apply Finset.sum_congr rfl
  intro j hj
  exact biprojectiveFunctionFieldEquiv_minusRowTerm p r (B i j) j

/-- The abstract pullback projection used by the diagonal action is literally
the standard first projection of biprojective space.  Keeping this equality as
a named bridge avoids unfolding the `actionOverOfIsOver` packaging proof. -/
theorem plusMinusPullback_fst_functionFieldMap
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module Omega V]
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    (pullback.fst
      (plusProjectiveActionOver R sigma p bp).V.hom
      (minusProjectiveActionOver R sigma q bm).V.hom).functionFieldMap =
      (BiprojectiveSpace.fst p q Omega).functionFieldMap := by
  rfl

/-- The corresponding typed bridge for the second projection. -/
theorem plusMinusPullback_snd_functionFieldMap
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module Omega V]
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma)) :
    (pullback.snd
      (plusProjectiveActionOver R sigma p bp).V.hom
      (minusProjectiveActionOver R sigma q bm).V.hom).functionFieldMap =
      (BiprojectiveSpace.snd p q Omega).functionFieldMap := by
  rfl

/-- The first pullback projection preserves division, stated across the typed
carrier bridge so downstream proofs never unfold `projectiveActionOver`. -/
theorem plusMinusPullback_fst_functionFieldMap_div
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module Omega V]
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (x y : (ProjectiveSpace p Omega).functionField) :
    (pullback.fst
      (plusProjectiveActionOver R sigma p bp).V.hom
      (minusProjectiveActionOver R sigma q bm).V.hom).functionFieldMap
        (x / y) =
      (BiprojectiveSpace.fst p q Omega).functionFieldMap x /
        (BiprojectiveSpace.fst p q Omega).functionFieldMap y := by
  rw [plusMinusPullback_fst_functionFieldMap]
  exact map_div₀ (BiprojectiveSpace.fst p q Omega).functionFieldMap.hom x y

/-- The analogous division bridge for the second projection. -/
theorem plusMinusPullback_snd_functionFieldMap_div
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module Omega V]
    (R : FaithfulLinearRep Omega G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (x y : (ProjectiveSpace q Omega).functionField) :
    (pullback.snd
      (plusProjectiveActionOver R sigma p bp).V.hom
      (minusProjectiveActionOver R sigma q bm).V.hom).functionFieldMap
        (x / y) =
      (BiprojectiveSpace.snd p q Omega).functionFieldMap x /
        (BiprojectiveSpace.snd p q Omega).functionFieldMap y := by
  rw [plusMinusPullback_snd_functionFieldMap]
  exact map_div₀ (BiprojectiveSpace.snd p q Omega).functionFieldMap.hom x y

/-- On every genuine plus-factor affine generator, the diagonal exceptional
action is the expected quotient of the corresponding transformed row by its
zeroth row. -/
theorem normalDivisorAction_functionFieldMap_plusGenerator
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module Omega V]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (r q : ℕ)
    (bp : Basis (Fin ((r + 1) + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) Omega (R.minusEigenspace sigma))
    (n : centralizer sigma) (i : Fin (r + 1)) :
    let A := (↑(plusCentralizerMatrixRepresentation R sigma (r + 1) bp n) :
      Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (Scheme.actionFunctionFieldMap
        (normalDivisorActionOver R sigma (r + 1) q bp bm) n).hom
      (biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega
        (exceptionalPlusGenericVector (r + 1) q i.succ)) =
      biprojectiveGeneralFunctionFieldEquiv (r + 1) q Omega
        (exceptionalPlusRowForm (r + 1) q A i.succ /
          exceptionalPlusRowForm (r + 1) q A 0) := by
  dsimp only
  letI : IsIso (diagonalPullbackActionHom
      (plusProjectiveActionOver R sigma (r + 1) bp)
      (minusProjectiveActionOver R sigma q bm) n) := by
    let e := (Over.forget (Spec (.of Omega))).mapIso
      ((diagonalPullbackActionOver
        (plusProjectiveActionOver R sigma (r + 1) bp)
        (minusProjectiveActionOver R sigma q bm)).ρAut n)
    change IsIso e.hom
    infer_instance
  letI : IsDominant (diagonalPullbackActionHom
      (plusProjectiveActionOver R sigma (r + 1) bp)
      (minusProjectiveActionOver R sigma q bm) n) := inferInstance
  have hdiag := diagonalPullbackAction_functionFieldMap_fst
    (plusProjectiveActionOver R sigma (r + 1) bp)
    (minusProjectiveActionOver R sigma q bm) n
    (projectiveGeneralFunctionFieldEquiv r Omega
      (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
        (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
        (MvPolynomial.X i)))
  rw [biprojectiveFunctionFieldEquiv_plusGenericVector]
  simp only [Fin.cases_succ]
  change (diagonalPullbackActionHom
      (plusProjectiveActionOver R sigma (r + 1) bp)
      (minusProjectiveActionOver R sigma q bm) n).functionFieldMap
      ((pullback.fst
        (plusProjectiveActionOver R sigma (r + 1) bp).V.hom
        (minusProjectiveActionOver R sigma q bm).V.hom).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
            (MvPolynomial.X i)))) = _
  rw [hdiag]
  rw [plusProjectiveActionOver_actionFunctionFieldMap_X_row]
  rw [plusMinusPullback_fst_functionFieldMap_div]
  rw [← biprojectiveFunctionFieldEquiv_plusRowForm,
    ← biprojectiveFunctionFieldEquiv_plusRowForm]
  rw [map_div₀]

/-- The corresponding row-ratio formula for every genuine minus-factor
affine generator. -/
theorem normalDivisorAction_functionFieldMap_minusGenerator
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module Omega V]
    (R : FaithfulLinearRep Omega G V) (sigma : G)
    (p r : ℕ)
    (bp : Basis (Fin (p + 1)) Omega (R.plusEigenspace sigma))
    (bm : Basis (Fin ((r + 1) + 1)) Omega (R.minusEigenspace sigma))
    (n : centralizer sigma) (i : Fin (r + 1)) :
    let B := (↑(minusCentralizerMatrixRepresentation R sigma (r + 1) bm n) :
      Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (Scheme.actionFunctionFieldMap
        (normalDivisorActionOver R sigma p (r + 1) bp bm) n).hom
      (biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega
        (exceptionalMinusGenericVector p (r + 1) i.succ)) =
      biprojectiveGeneralFunctionFieldEquiv p (r + 1) Omega
        (exceptionalMinusRowForm p (r + 1) B i.succ /
          exceptionalMinusRowForm p (r + 1) B 0) := by
  dsimp only
  letI : IsIso (diagonalPullbackActionHom
      (plusProjectiveActionOver R sigma p bp)
      (minusProjectiveActionOver R sigma (r + 1) bm) n) := by
    let e := (Over.forget (Spec (.of Omega))).mapIso
      ((diagonalPullbackActionOver
        (plusProjectiveActionOver R sigma p bp)
        (minusProjectiveActionOver R sigma (r + 1) bm)).ρAut n)
    change IsIso e.hom
    infer_instance
  letI : IsDominant (diagonalPullbackActionHom
      (plusProjectiveActionOver R sigma p bp)
      (minusProjectiveActionOver R sigma (r + 1) bm) n) := inferInstance
  have hdiag := diagonalPullbackAction_functionFieldMap_snd
    (plusProjectiveActionOver R sigma p bp)
    (minusProjectiveActionOver R sigma (r + 1) bm) n
    (projectiveGeneralFunctionFieldEquiv r Omega
      (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
        (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
        (MvPolynomial.X i)))
  rw [biprojectiveFunctionFieldEquiv_minusGenericVector]
  simp only [Fin.cases_succ]
  change (diagonalPullbackActionHom
      (plusProjectiveActionOver R sigma p bp)
      (minusProjectiveActionOver R sigma (r + 1) bm) n).functionFieldMap
      ((pullback.snd
        (plusProjectiveActionOver R sigma p bp).V.hom
        (minusProjectiveActionOver R sigma (r + 1) bm).V.hom).functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
            (MvPolynomial.X i)))) = _
  rw [hdiag]
  rw [minusProjectiveActionOver_actionFunctionFieldMap_X_row]
  rw [plusMinusPullback_snd_functionFieldMap_div]
  rw [← biprojectiveFunctionFieldEquiv_minusRowForm,
    ← biprojectiveFunctionFieldEquiv_minusRowForm]
  rw [map_div₀]

end V14Formalization.SchemeGeometry
