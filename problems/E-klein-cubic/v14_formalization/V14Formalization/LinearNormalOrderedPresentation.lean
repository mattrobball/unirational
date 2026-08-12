import V14Formalization.CorrectedBirationalField
import Mathlib.FieldTheory.RatFunc.AsPolynomial
import Mathlib.RingTheory.AlgebraicIndependent.Transcendental

noncomputable section

open scoped BigOperators

namespace V14Formalization.SchemeGeometry

universe u

variable {Omega : Type u} [Field Omega]

abbrev orderedResidualTowerField (p q : ℕ) :=
  FractionRing (MvPolynomial (Fin (p + q)) Omega)

abbrev orderedNormalTowerField (p q : ℕ) :=
  RatFunc (orderedResidualTowerField (Omega := Omega) p q)

/-- Reindex ordered coordinates `[u,T,v]` by the tower coordinates
`T ⊕ [u,v]`. -/
def orderedIndexToNormalSum (p q : ℕ) :
    Fin (p + q + 1) → Unit ⊕ Fin (p + q) := fun k ↦
  if hT : (k : Nat) = p then Sum.inl ()
  else if hu : (k : Nat) < p then Sum.inr ⟨k, by omega⟩
  else Sum.inr ⟨(k : Nat) - 1, by omega⟩

theorem orderedIndexToNormalSum_injective (p q : ℕ) :
    Function.Injective (orderedIndexToNormalSum p q) := by
  intro i j h
  by_cases hiT : (i : Nat) = p
  · by_cases hjT : (j : Nat) = p
    · exact Fin.ext (by omega)
    · by_cases hju : (j : Nat) < p <;>
        simp [orderedIndexToNormalSum, hiT, hjT, hju] at h
  · by_cases hjT : (j : Nat) = p
    · by_cases hiu : (i : Nat) < p <;>
        simp [orderedIndexToNormalSum, hiT, hjT, hiu] at h
    · by_cases hiu : (i : Nat) < p
      · by_cases hju : (j : Nat) < p
        · simp [orderedIndexToNormalSum, hiT, hjT, hiu, hju] at h
          exact Fin.ext h
        · simp [orderedIndexToNormalSum, hiT, hjT, hiu, hju] at h
          omega
      · by_cases hju : (j : Nat) < p
        · simp [orderedIndexToNormalSum, hiT, hjT, hiu, hju] at h
          omega
        · simp [orderedIndexToNormalSum, hiT, hjT, hiu, hju] at h
          apply Fin.ext
          omega

def residualCoordinateInField (p q : ℕ) (i : Fin (p + q)) :
    orderedResidualTowerField (Omega := Omega) p q :=
  algebraMap (MvPolynomial (Fin (p + q)) Omega)
    (orderedResidualTowerField (Omega := Omega) p q) (MvPolynomial.X i)

def normalTowerCoordinate (p q : ℕ) :
    Unit ⊕ Fin (p + q) → orderedNormalTowerField (Omega := Omega) p q :=
  Sum.elim (fun _ ↦ RatFunc.X)
    (fun i ↦ RatFunc.C (residualCoordinateInField p q i))

def orderedCoordinateInLinearNormalField (p q : ℕ) :
    Fin (p + q + 1) → orderedNormalTowerField (Omega := Omega) p q :=
  normalTowerCoordinate p q ∘ orderedIndexToNormalSum p q

theorem residualCoordinate_algebraicIndependent (p q : ℕ) :
    AlgebraicIndependent Omega
      (residualCoordinateInField (Omega := Omega) p q) := by
  let f : MvPolynomial (Fin (p + q)) Omega →ₐ[Omega]
      orderedResidualTowerField (Omega := Omega) p q :=
    IsScalarTower.toAlgHom Omega
      (MvPolynomial (Fin (p + q)) Omega)
      (orderedResidualTowerField (Omega := Omega) p q)
  have h := (MvPolynomial.algebraicIndependent_X
    (Fin (p + q)) Omega).map' (f := f)
      (IsFractionRing.injective
        (MvPolynomial (Fin (p + q)) Omega)
        (orderedResidualTowerField (Omega := Omega) p q))
  change AlgebraicIndependent Omega (fun x : Fin (p + q) ↦
    algebraMap (MvPolynomial (Fin (p + q)) Omega)
      (orderedResidualTowerField (Omega := Omega) p q) (MvPolynomial.X x))
  exact h

theorem normalTowerCoordinate_algebraicIndependent (p q : ℕ) :
    AlgebraicIndependent Omega
      (normalTowerCoordinate (Omega := Omega) p q) := by
  have hT : AlgebraicIndependent
      (orderedResidualTowerField (Omega := Omega) p q)
      (fun _ : Unit ↦ (RatFunc.X :
        orderedNormalTowerField (Omega := Omega) p q)) := by
    rw [algebraicIndependent_unique_type_iff]
    exact RatFunc.transcendental_X
  have h := (residualCoordinate_algebraicIndependent
    (Omega := Omega) p q).sumElim_comp hT
  simpa [normalTowerCoordinate, Function.comp_def, RatFunc.algebraMap_eq_C] using h

theorem orderedCoordinateInLinearNormalField_algebraicIndependent
    (p q : ℕ) :
    AlgebraicIndependent Omega
      (orderedCoordinateInLinearNormalField (Omega := Omega) p q) := by
  exact (normalTowerCoordinate_algebraicIndependent
    (Omega := Omega) p q).comp (orderedIndexToNormalSum p q)
      (orderedIndexToNormalSum_injective p q)

def orderedCoordinatePolynomialToLinearNormalField (p q : ℕ) :
    orderedCoordinatePolynomial (Omega := Omega) p q →+*
      orderedNormalTowerField (Omega := Omega) p q :=
  (MvPolynomial.aeval
    (orderedCoordinateInLinearNormalField (Omega := Omega) p q)).toRingHom

theorem orderedCoordinatePolynomialToLinearNormalField_injective
    (p q : ℕ) :
    Function.Injective
      (orderedCoordinatePolynomialToLinearNormalField
        (Omega := Omega) p q) :=
  algebraicIndependent_iff_injective_aeval.mp
    (orderedCoordinateInLinearNormalField_algebraicIndependent
      (Omega := Omega) p q)

noncomputable def orderedCoordinateFieldToLinearNormalHom (p q : ℕ) :
    orderedCoordinateField (Omega := Omega) p q →+*
      orderedNormalTowerField (Omega := Omega) p q :=
  IsFractionRing.lift
    (orderedCoordinatePolynomialToLinearNormalField_injective
      (Omega := Omega) p q)

@[simp]
theorem orderedCoordinateFieldToLinearNormalHom_X
    (p q : ℕ) (k : Fin (p + q + 1)) :
    orderedCoordinateFieldToLinearNormalHom (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X k)) =
      orderedCoordinateInLinearNormalField (Omega := Omega) p q k := by
  rw [orderedCoordinateFieldToLinearNormalHom,
    IsFractionRing.lift_algebraMap]
  simp [orderedCoordinatePolynomialToLinearNormalField]

def orderedResidualPlusIndex (p q : ℕ) (i : Fin p) : Fin (p + q) :=
  ⟨i, by omega⟩

def orderedResidualMinusIndex (p q : ℕ) (j : Fin q) : Fin (p + q) :=
  ⟨p + j, by omega⟩

@[simp]
theorem orderedCoordinateInLinearNormalField_plus
    (p q : ℕ) (i : Fin p) :
    orderedCoordinateInLinearNormalField (Omega := Omega) p q
        (orderedPlusIndex p q i) =
      RatFunc.C (residualCoordinateInField (Omega := Omega) p q
        (orderedResidualPlusIndex p q i)) := by
  have hiT : (i : Nat) ≠ p := by omega
  simp [orderedCoordinateInLinearNormalField, normalTowerCoordinate,
    orderedIndexToNormalSum, orderedPlusIndex, hiT,
    orderedResidualPlusIndex]

@[simp]
theorem orderedCoordinateInLinearNormalField_normal (p q : ℕ) :
    orderedCoordinateInLinearNormalField (Omega := Omega) p q
        (orderedNormalIndex p q) = RatFunc.X := by
  simp [orderedCoordinateInLinearNormalField, normalTowerCoordinate,
    orderedIndexToNormalSum, orderedNormalIndex]

@[simp]
theorem orderedCoordinateInLinearNormalField_tail
    (p q : ℕ) (j : Fin q) :
    orderedCoordinateInLinearNormalField (Omega := Omega) p q
        (orderedMinusTailIndex p q j) =
      RatFunc.C (residualCoordinateInField (Omega := Omega) p q
        (orderedResidualMinusIndex p q j)) := by
  have hjT : p + 1 + (j : Nat) ≠ p := by omega
  have hju : ¬p + 1 + (j : Nat) < p := by omega
  simp [orderedCoordinateInLinearNormalField, normalTowerCoordinate,
    orderedIndexToNormalSum, orderedMinusTailIndex, hjT, hju,
    orderedResidualMinusIndex]

@[simp]
theorem orderedCoordinateFieldToLinearNormalHom_X_plus
    (p q : ℕ) (i : Fin p) :
    orderedCoordinateFieldToLinearNormalHom (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedPlusIndex p q i))) =
      RatFunc.C (residualCoordinateInField (Omega := Omega) p q
        (orderedResidualPlusIndex p q i)) := by
  rw [orderedCoordinateFieldToLinearNormalHom_X,
    orderedCoordinateInLinearNormalField_plus]

@[simp]
theorem orderedCoordinateFieldToLinearNormalHom_X_normal (p q : ℕ) :
    orderedCoordinateFieldToLinearNormalHom (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedNormalIndex p q))) = RatFunc.X := by
  rw [orderedCoordinateFieldToLinearNormalHom_X,
    orderedCoordinateInLinearNormalField_normal]

@[simp]
theorem orderedCoordinateFieldToLinearNormalHom_X_tail
    (p q : ℕ) (j : Fin q) :
    orderedCoordinateFieldToLinearNormalHom (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedMinusTailIndex p q j))) =
      RatFunc.C (residualCoordinateInField (Omega := Omega) p q
        (orderedResidualMinusIndex p q j)) := by
  rw [orderedCoordinateFieldToLinearNormalHom_X,
    orderedCoordinateInLinearNormalField_tail]

@[simp]
theorem orderedCoordinateFieldToLinearNormalHom_C
    (p q : ℕ) (c : Omega) :
    orderedCoordinateFieldToLinearNormalHom (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.C c)) =
      RatFunc.C (algebraMap Omega
        (orderedResidualTowerField (Omega := Omega) p q) c) := by
  rw [orderedCoordinateFieldToLinearNormalHom,
    IsFractionRing.lift_algebraMap]
  simp [orderedCoordinatePolynomialToLinearNormalField,
    ← RatFunc.algebraMap_eq_C,
    IsScalarTower.algebraMap_apply Omega
      (orderedResidualTowerField (Omega := Omega) p q)
      (orderedNormalTowerField (Omega := Omega) p q)]

theorem orderedResidualIndex_cases (p q : ℕ) (i : Fin (p + q)) :
    (∃ j : Fin p, i = orderedResidualPlusIndex p q j) ∨
      ∃ j : Fin q, i = orderedResidualMinusIndex p q j := by
  by_cases hi : (i : Nat) < p
  · left
    exact ⟨⟨i, hi⟩, Fin.ext (by simp [orderedResidualPlusIndex])⟩
  · right
    let j : Fin q := ⟨(i : Nat) - p, by omega⟩
    refine ⟨j, Fin.ext ?_⟩
    simp [j, orderedResidualMinusIndex]
    omega

theorem residualCoordinate_C_mem_orderedFieldRange
    (p q : ℕ) (i : Fin (p + q)) :
    RatFunc.C (residualCoordinateInField (Omega := Omega) p q i) ∈
      (orderedCoordinateFieldToLinearNormalHom
        (Omega := Omega) p q).fieldRange := by
  rcases orderedResidualIndex_cases p q i with ⟨j, rfl⟩ | ⟨j, rfl⟩
  · exact ⟨algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
      (orderedCoordinateField (Omega := Omega) p q)
      (MvPolynomial.X (orderedPlusIndex p q j)),
        orderedCoordinateFieldToLinearNormalHom_X_plus p q j⟩
  · exact ⟨algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
      (orderedCoordinateField (Omega := Omega) p q)
      (MvPolynomial.X (orderedMinusTailIndex p q j)),
        orderedCoordinateFieldToLinearNormalHom_X_tail p q j⟩

theorem residualPolynomial_C_mem_orderedFieldRange
    (p q : ℕ) (P : MvPolynomial (Fin (p + q)) Omega) :
    RatFunc.C (algebraMap (MvPolynomial (Fin (p + q)) Omega)
      (orderedResidualTowerField (Omega := Omega) p q) P) ∈
      (orderedCoordinateFieldToLinearNormalHom
        (Omega := Omega) p q).fieldRange := by
  induction P using MvPolynomial.induction_on with
  | C c =>
      exact ⟨algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.C c), by
          rw [orderedCoordinateFieldToLinearNormalHom_C]
          congr 2⟩
  | add P Q hP hQ =>
      simpa only [map_add] using
        (orderedCoordinateFieldToLinearNormalHom
          (Omega := Omega) p q).fieldRange.add_mem hP hQ
  | mul_X P i hP =>
      simpa only [map_mul, residualCoordinateInField] using
        (orderedCoordinateFieldToLinearNormalHom
          (Omega := Omega) p q).fieldRange.mul_mem hP
            (residualCoordinate_C_mem_orderedFieldRange p q i)

theorem residual_C_mem_orderedFieldRange
    (p q : ℕ) (c : orderedResidualTowerField (Omega := Omega) p q) :
    RatFunc.C c ∈ (orderedCoordinateFieldToLinearNormalHom
      (Omega := Omega) p q).fieldRange := by
  obtain ⟨a, b, hb, hab⟩ := IsFractionRing.div_surjective
    (MvPolynomial (Fin (p + q)) Omega) c
  rw [← hab, map_div₀]
  exact (orderedCoordinateFieldToLinearNormalHom
    (Omega := Omega) p q).fieldRange.div_mem
      (residualPolynomial_C_mem_orderedFieldRange p q a)
      (residualPolynomial_C_mem_orderedFieldRange p q b)

theorem normalPolynomial_mem_orderedFieldRange
    (p q : ℕ)
    (P : Polynomial (orderedResidualTowerField (Omega := Omega) p q)) :
    algebraMap (Polynomial (orderedResidualTowerField (Omega := Omega) p q))
        (orderedNormalTowerField (Omega := Omega) p q) P ∈
      (orderedCoordinateFieldToLinearNormalHom
        (Omega := Omega) p q).fieldRange := by
  induction P using Polynomial.induction_on' with
  | add P Q hP hQ =>
      simpa only [map_add] using
        (orderedCoordinateFieldToLinearNormalHom
          (Omega := Omega) p q).fieldRange.add_mem hP hQ
  | monomial n c =>
      rw [RatFunc.algebraMap_monomial]
      have hX : (RatFunc.X : orderedNormalTowerField
          (Omega := Omega) p q) ∈
          (orderedCoordinateFieldToLinearNormalHom
            (Omega := Omega) p q).fieldRange :=
        ⟨algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedNormalIndex p q)),
            orderedCoordinateFieldToLinearNormalHom_X_normal p q⟩
      exact (orderedCoordinateFieldToLinearNormalHom
        (Omega := Omega) p q).fieldRange.mul_mem
          (residual_C_mem_orderedFieldRange p q c)
          ((orderedCoordinateFieldToLinearNormalHom
            (Omega := Omega) p q).fieldRange.pow_mem hX n)

theorem orderedCoordinateFieldToLinearNormalHom_surjective
    (p q : ℕ) :
    Function.Surjective (orderedCoordinateFieldToLinearNormalHom
      (Omega := Omega) p q) := by
  rw [← RingHom.fieldRange_eq_top_iff]
  apply top_unique
  intro z hz
  obtain ⟨a, b, hb, rfl⟩ := IsFractionRing.div_surjective
    (Polynomial (orderedResidualTowerField (Omega := Omega) p q)) z
  exact (orderedCoordinateFieldToLinearNormalHom
    (Omega := Omega) p q).fieldRange.div_mem
      (normalPolynomial_mem_orderedFieldRange p q a)
      (normalPolynomial_mem_orderedFieldRange p q b)

noncomputable def orderedCoordinateFieldToLinearNormalEquiv (p q : ℕ) :
    orderedCoordinateField (Omega := Omega) p q ≃+*
      orderedNormalTowerField (Omega := Omega) p q :=
  RingEquiv.ofBijective (orderedCoordinateFieldToLinearNormalHom p q)
    ⟨RingHom.injective _,
      orderedCoordinateFieldToLinearNormalHom_surjective p q⟩

/-- Direct, generator-controlled presentation of the linear normal fraction
field in ordered coordinates `[u,T,v]`. -/
noncomputable def linearNormalToOrderedCoordinateFieldEquiv (p q : ℕ) :
    orderedNormalTowerField (Omega := Omega) p q ≃+*
      orderedCoordinateField (Omega := Omega) p q :=
  (orderedCoordinateFieldToLinearNormalEquiv p q).symm

@[simp]
theorem linearNormalToOrderedCoordinateFieldEquiv_X_normal
    (p q : ℕ) :
    linearNormalToOrderedCoordinateFieldEquiv (Omega := Omega) p q
        (RatFunc.X : orderedNormalTowerField (Omega := Omega) p q) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.X (orderedNormalIndex p q)) := by
  apply (orderedCoordinateFieldToLinearNormalEquiv
    (Omega := Omega) p q).injective
  change (orderedCoordinateFieldToLinearNormalEquiv (Omega := Omega) p q)
      ((orderedCoordinateFieldToLinearNormalEquiv (Omega := Omega) p q).symm _) = _
  rw [(orderedCoordinateFieldToLinearNormalEquiv
    (Omega := Omega) p q).apply_symm_apply]
  exact (orderedCoordinateFieldToLinearNormalHom_X_normal p q).symm

@[simp]
theorem linearNormalToOrderedCoordinateFieldEquiv_C_plus
    (p q : ℕ) (i : Fin p) :
    linearNormalToOrderedCoordinateFieldEquiv (Omega := Omega) p q
        (RatFunc.C (residualCoordinateInField (Omega := Omega) p q
          (orderedResidualPlusIndex p q i))) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.X (orderedPlusIndex p q i)) := by
  apply (orderedCoordinateFieldToLinearNormalEquiv
    (Omega := Omega) p q).injective
  change (orderedCoordinateFieldToLinearNormalEquiv (Omega := Omega) p q)
      ((orderedCoordinateFieldToLinearNormalEquiv (Omega := Omega) p q).symm _) = _
  rw [(orderedCoordinateFieldToLinearNormalEquiv
    (Omega := Omega) p q).apply_symm_apply]
  exact (orderedCoordinateFieldToLinearNormalHom_X_plus p q i).symm

@[simp]
theorem linearNormalToOrderedCoordinateFieldEquiv_C_tail
    (p q : ℕ) (j : Fin q) :
    linearNormalToOrderedCoordinateFieldEquiv (Omega := Omega) p q
        (RatFunc.C (residualCoordinateInField (Omega := Omega) p q
          (orderedResidualMinusIndex p q j))) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.X (orderedMinusTailIndex p q j)) := by
  apply (orderedCoordinateFieldToLinearNormalEquiv
    (Omega := Omega) p q).injective
  change (orderedCoordinateFieldToLinearNormalEquiv (Omega := Omega) p q)
      ((orderedCoordinateFieldToLinearNormalEquiv (Omega := Omega) p q).symm _) = _
  rw [(orderedCoordinateFieldToLinearNormalEquiv
    (Omega := Omega) p q).apply_symm_apply]
  exact (orderedCoordinateFieldToLinearNormalHom_X_tail p q j).symm

theorem linearNormalToOrderedCoordinateFieldEquiv_base
    (p q : ℕ) (c : Omega) :
    linearNormalToOrderedCoordinateFieldEquiv (Omega := Omega) p q
        (baseToLinearNormalFractionField (Nat.succ (p + q)) Omega c) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.C c) := by
  apply (orderedCoordinateFieldToLinearNormalEquiv
    (Omega := Omega) p q).injective
  change (orderedCoordinateFieldToLinearNormalEquiv (Omega := Omega) p q)
      ((orderedCoordinateFieldToLinearNormalEquiv (Omega := Omega) p q).symm _) = _
  rw [(orderedCoordinateFieldToLinearNormalEquiv
    (Omega := Omega) p q).apply_symm_apply]
  change RatFunc.C (algebraMap Omega
      (orderedResidualTowerField (Omega := Omega) p q) c) =
    orderedCoordinateFieldToLinearNormalHom (Omega := Omega) p q
      (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q) (MvPolynomial.C c))
  exact (orderedCoordinateFieldToLinearNormalHom_C p q c).symm

end V14Formalization.SchemeGeometry
