import V14Formalization.LinearNormalValuation
import Mathlib.Algebra.MonoidAlgebra.MapDomain

noncomputable section

open scoped BigOperators

namespace V14Formalization.SchemeGeometry

universe u

variable {Omega : Type u} [Field Omega]

def orderedNormalIndex (p q : ℕ) : Fin (p + q + 1) :=
  ⟨p, by omega⟩

def orderedPlusIndex (p q : ℕ) (i : Fin p) : Fin (p + q + 1) :=
  ⟨i, by omega⟩

def orderedMinusTailIndex (p q : ℕ) (j : Fin q) : Fin (p + q + 1) :=
  ⟨p + 1 + j, by omega⟩

/-- Exponent shear realizing `z_(p+1+j) ↦ T*v_j`: it leaves all
exponents except the `T` exponent unchanged and adds every tail exponent to
the `T` exponent. -/
def orderedTailShear (p q : ℕ) :
    (Fin (p + q + 1) →₀ ℕ) →+ (Fin (p + q + 1) →₀ ℕ) where
  toFun m := Finsupp.equivFunOnFinite.symm fun k ↦
    if k = orderedNormalIndex p q then
        m k + ∑ j : Fin q, m (orderedMinusTailIndex p q j)
      else m k
  map_zero' := by
    ext k
    simp
  map_add' m n := by
    ext k
    by_cases hk : k = orderedNormalIndex p q
    · subst k
      simp [Finset.sum_add_distrib, add_assoc, add_left_comm]
    · simp [hk]

theorem orderedMinusTailIndex_ne_normal (p q : ℕ) (j : Fin q) :
    orderedMinusTailIndex p q j ≠ orderedNormalIndex p q := by
  intro h
  have := congrArg Fin.val h
  simp [orderedMinusTailIndex, orderedNormalIndex] at this
  omega

theorem orderedPlusIndex_ne_normal (p q : ℕ) (i : Fin p) :
    orderedPlusIndex p q i ≠ orderedNormalIndex p q := by
  intro h
  have := congrArg Fin.val h
  simp [orderedPlusIndex, orderedNormalIndex] at this
  omega

theorem orderedPlusIndex_ne_minusTail (p q : ℕ) (i : Fin p) (j : Fin q) :
    orderedPlusIndex p q i ≠ orderedMinusTailIndex p q j := by
  intro h
  have := congrArg Fin.val h
  simp [orderedPlusIndex, orderedMinusTailIndex] at this
  omega

theorem orderedMinusTailIndex_injective (p q : ℕ) :
    Function.Injective (orderedMinusTailIndex p q) := by
  intro i j h
  apply Fin.ext
  have := congrArg Fin.val h
  simp [orderedMinusTailIndex] at this
  omega

theorem orderedTailShear_injective (p q : ℕ) :
    Function.Injective (orderedTailShear p q) := by
  intro m n h
  ext k
  by_cases hk : k = orderedNormalIndex p q
  · subst k
    have htail : (∑ j : Fin q, m (orderedMinusTailIndex p q j)) =
        ∑ j : Fin q, n (orderedMinusTailIndex p q j) := by
      apply Finset.sum_congr rfl
      intro j hj
      have hjv := DFunLike.congr_fun h (orderedMinusTailIndex p q j)
      simpa [orderedTailShear, orderedMinusTailIndex_ne_normal] using hjv
    have hp := DFunLike.congr_fun h (orderedNormalIndex p q)
    simp [orderedTailShear] at hp
    omega
  · have hk' := DFunLike.congr_fun h k
    simpa [orderedTailShear, hk] using hk'

/-- Polynomial substitution from ambient affine-chart coordinates to the
ordered normal polynomial coordinates. -/
def ambientToOrderedNormalPolynomialHom (p q : ℕ) :
    MvPolynomial (Fin (p + q + 1)) Omega →+*
      MvPolynomial (Fin (p + q + 1)) Omega :=
  AddMonoidAlgebra.mapDomainRingHom Omega (orderedTailShear p q)

theorem ambientToOrderedNormalPolynomialHom_injective (p q : ℕ) :
    Function.Injective (ambientToOrderedNormalPolynomialHom
      (Omega := Omega) p q) :=
  AddMonoidAlgebra.mapDomain_injective (orderedTailShear_injective p q)

@[simp]
theorem ambientToOrderedNormalPolynomialHom_C
    (p q : ℕ) (c : Omega) :
    ambientToOrderedNormalPolynomialHom (Omega := Omega) p q
        (MvPolynomial.C c) = MvPolynomial.C c := by
  change AddMonoidAlgebra.mapDomain (orderedTailShear p q)
      (AddMonoidAlgebra.single 0 c) = AddMonoidAlgebra.single 0 c
  rw [AddMonoidAlgebra.mapDomain_single]
  congr
  ext k
  simp [orderedTailShear]

theorem ambientToOrderedNormalPolynomialHom_X_normal (p q : ℕ) :
    ambientToOrderedNormalPolynomialHom (Omega := Omega) p q
        (MvPolynomial.X (orderedNormalIndex p q)) =
      MvPolynomial.X (orderedNormalIndex p q) := by
  change AddMonoidAlgebra.mapDomain (orderedTailShear p q)
      (AddMonoidAlgebra.single
        (Finsupp.single (orderedNormalIndex p q) 1) 1) =
    AddMonoidAlgebra.single (Finsupp.single (orderedNormalIndex p q) 1) 1
  rw [AddMonoidAlgebra.mapDomain_single]
  congr 1
  ext k
  by_cases hk : k = orderedNormalIndex p q
  · subst k
    simp [orderedTailShear, orderedMinusTailIndex_ne_normal]
  · simp [orderedTailShear, hk]

theorem ambientToOrderedNormalPolynomialHom_X_plus
    (p q : ℕ) (i : Fin p) :
    ambientToOrderedNormalPolynomialHom (Omega := Omega) p q
        (MvPolynomial.X (orderedPlusIndex p q i)) =
      MvPolynomial.X (orderedPlusIndex p q i) := by
  change AddMonoidAlgebra.mapDomain (orderedTailShear p q)
      (AddMonoidAlgebra.single
        (Finsupp.single (orderedPlusIndex p q i) 1) 1) =
    AddMonoidAlgebra.single (Finsupp.single (orderedPlusIndex p q i) 1) 1
  rw [AddMonoidAlgebra.mapDomain_single]
  congr 1
  ext k
  by_cases hk : k = orderedNormalIndex p q
  · subst k
    simp [orderedTailShear, orderedPlusIndex_ne_normal,
      orderedPlusIndex_ne_minusTail]
  · simp [orderedTailShear, hk]

theorem ambientToOrderedNormalPolynomialHom_X_tail
    (p q : ℕ) (j : Fin q) :
    ambientToOrderedNormalPolynomialHom (Omega := Omega) p q
        (MvPolynomial.X (orderedMinusTailIndex p q j)) =
      MvPolynomial.X (orderedNormalIndex p q) *
        MvPolynomial.X (orderedMinusTailIndex p q j) := by
  change AddMonoidAlgebra.mapDomain (orderedTailShear p q)
      (AddMonoidAlgebra.single
        (Finsupp.single (orderedMinusTailIndex p q j) 1) 1) =
    AddMonoidAlgebra.single (Finsupp.single (orderedNormalIndex p q) 1) 1 *
      AddMonoidAlgebra.single
        (Finsupp.single (orderedMinusTailIndex p q j) 1) 1
  rw [AddMonoidAlgebra.mapDomain_single,
    AddMonoidAlgebra.single_mul_single]
  simp only [one_mul]
  congr 1
  ext k
  by_cases hk : k = orderedNormalIndex p q
  · subst k
    have hsum : (∑ j_1 : Fin q,
        (Finsupp.single (orderedMinusTailIndex p q j) 1)
          (orderedMinusTailIndex p q j_1)) = 1 := by
      rw [Finset.sum_eq_single j]
      · simp
      · intro b hb hbj
        have hne : orderedMinusTailIndex p q j ≠
            orderedMinusTailIndex p q b := fun h ↦
          hbj ((orderedMinusTailIndex_injective p q) h.symm)
        simp [hne]
      · simp
    simp [orderedTailShear, orderedMinusTailIndex_ne_normal, hsum]
  · simp [orderedTailShear, hk]

abbrev orderedCoordinatePolynomial (p q : ℕ) :=
  MvPolynomial (Fin (p + q + 1)) Omega

abbrev orderedCoordinateField (p q : ℕ) :=
  FractionRing (orderedCoordinatePolynomial (Omega := Omega) p q)

def ambientPolynomialToOrderedFieldHom (p q : ℕ) :
    orderedCoordinatePolynomial (Omega := Omega) p q →+*
      orderedCoordinateField (Omega := Omega) p q :=
  (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
    (orderedCoordinateField (Omega := Omega) p q)).comp
      (ambientToOrderedNormalPolynomialHom p q)

theorem ambientPolynomialToOrderedFieldHom_injective (p q : ℕ) :
    Function.Injective (ambientPolynomialToOrderedFieldHom
      (Omega := Omega) p q) :=
  (FaithfulSMul.algebraMap_injective
    (orderedCoordinatePolynomial (Omega := Omega) p q)
    (orderedCoordinateField (Omega := Omega) p q)).comp
      (ambientToOrderedNormalPolynomialHom_injective p q)

/-- Fraction-field map induced by the polynomial substitution
`z_tail ↦ T*v`. -/
noncomputable def ambientToOrderedNormalFieldHom (p q : ℕ) :
    orderedCoordinateField (Omega := Omega) p q →+*
      orderedCoordinateField (Omega := Omega) p q :=
  IsFractionRing.lift
    (ambientPolynomialToOrderedFieldHom_injective (Omega := Omega) p q)

@[simp]
theorem ambientToOrderedNormalFieldHom_X_normal (p q : ℕ) :
    ambientToOrderedNormalFieldHom (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedNormalIndex p q))) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.X (orderedNormalIndex p q)) := by
  rw [ambientToOrderedNormalFieldHom, IsFractionRing.lift_algebraMap]
  simp [ambientPolynomialToOrderedFieldHom,
    ambientToOrderedNormalPolynomialHom_X_normal]

@[simp]
theorem ambientToOrderedNormalFieldHom_X_plus
    (p q : ℕ) (i : Fin p) :
    ambientToOrderedNormalFieldHom (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedPlusIndex p q i))) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.X (orderedPlusIndex p q i)) := by
  rw [ambientToOrderedNormalFieldHom, IsFractionRing.lift_algebraMap]
  simp [ambientPolynomialToOrderedFieldHom,
    ambientToOrderedNormalPolynomialHom_X_plus]

@[simp]
theorem ambientToOrderedNormalFieldHom_X_tail
    (p q : ℕ) (j : Fin q) :
    ambientToOrderedNormalFieldHom (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedMinusTailIndex p q j))) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedNormalIndex p q)) *
        algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedMinusTailIndex p q j)) := by
  rw [ambientToOrderedNormalFieldHom, IsFractionRing.lift_algebraMap]
  simp [ambientPolynomialToOrderedFieldHom,
    ambientToOrderedNormalPolynomialHom_X_tail]

@[simp]
theorem ambientToOrderedNormalFieldHom_C
    (p q : ℕ) (c : Omega) :
    ambientToOrderedNormalFieldHom (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.C c)) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.C c) := by
  rw [ambientToOrderedNormalFieldHom, IsFractionRing.lift_algebraMap]
  simp [ambientPolynomialToOrderedFieldHom]

theorem orderedCoordinateIndex_cases (p q : ℕ)
    (k : Fin (p + q + 1)) :
    (∃ i : Fin p, k = orderedPlusIndex p q i) ∨
      k = orderedNormalIndex p q ∨
        ∃ j : Fin q, k = orderedMinusTailIndex p q j := by
  by_cases hp : (k : Nat) < p
  · left
    exact ⟨⟨k, hp⟩, Fin.ext (by simp [orderedPlusIndex])⟩
  · by_cases heq : (k : Nat) = p
    · right; left
      exact Fin.ext (by simp [orderedNormalIndex, heq])
    · right; right
      have hklo : p + 1 ≤ (k : Nat) := by omega
      let j : Fin q := ⟨(k : Nat) - (p + 1), by omega⟩
      refine ⟨j, Fin.ext ?_⟩
      simp [j, orderedMinusTailIndex]
      omega

theorem orderedCoordinate_X_mem_fieldRange (p q : ℕ)
    (k : Fin (p + q + 1)) :
    algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.X k) ∈
      (ambientToOrderedNormalFieldHom (Omega := Omega) p q).fieldRange := by
  rcases orderedCoordinateIndex_cases p q k with ⟨i, rfl⟩ | rfl | ⟨j, rfl⟩
  · exact ⟨algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
      (orderedCoordinateField (Omega := Omega) p q)
      (MvPolynomial.X (orderedPlusIndex p q i)),
        ambientToOrderedNormalFieldHom_X_plus p q i⟩
  · exact ⟨algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
      (orderedCoordinateField (Omega := Omega) p q)
      (MvPolynomial.X (orderedNormalIndex p q)),
        ambientToOrderedNormalFieldHom_X_normal p q⟩
  · let zT := algebraMap
      (orderedCoordinatePolynomial (Omega := Omega) p q)
      (orderedCoordinateField (Omega := Omega) p q)
      (MvPolynomial.X (orderedNormalIndex p q))
    let zV := algebraMap
      (orderedCoordinatePolynomial (Omega := Omega) p q)
      (orderedCoordinateField (Omega := Omega) p q)
      (MvPolynomial.X (orderedMinusTailIndex p q j))
    refine ⟨zV / zT, ?_⟩
    have hzT : zT ≠ 0 := by
      intro hz
      have hx0 : MvPolynomial.X (R := Omega) (orderedNormalIndex p q) = 0 :=
        (FaithfulSMul.algebraMap_injective
        (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)) (by
          dsimp [zT] at hz
          simpa only [map_zero] using hz)
      exact MvPolynomial.X_ne_zero (orderedNormalIndex p q) hx0
    change ambientToOrderedNormalFieldHom (Omega := Omega) p q (zV / zT) = zV
    rw [map_div₀, ambientToOrderedNormalFieldHom_X_tail,
      ambientToOrderedNormalFieldHom_X_normal]
    exact mul_div_cancel_left₀ zV hzT

theorem orderedCoordinate_algebraMap_mem_fieldRange (p q : ℕ)
    (P : orderedCoordinatePolynomial (Omega := Omega) p q) :
    algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q) P ∈
      (ambientToOrderedNormalFieldHom (Omega := Omega) p q).fieldRange := by
  induction P using MvPolynomial.induction_on with
  | C c =>
      exact ⟨algebraMap
        (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.C c), ambientToOrderedNormalFieldHom_C p q c⟩
  | add P Q hP hQ =>
      simpa only [map_add] using
        (ambientToOrderedNormalFieldHom (Omega := Omega) p q).fieldRange.add_mem hP hQ
  | mul_X P i hP =>
      simpa only [map_mul] using
        (ambientToOrderedNormalFieldHom (Omega := Omega) p q).fieldRange.mul_mem
          hP (orderedCoordinate_X_mem_fieldRange p q i)

theorem ambientToOrderedNormalFieldHom_surjective (p q : ℕ) :
    Function.Surjective (ambientToOrderedNormalFieldHom
      (Omega := Omega) p q) := by
  rw [← RingHom.fieldRange_eq_top_iff]
  apply top_unique
  intro y hy
  obtain ⟨a, b, hb, rfl⟩ := IsFractionRing.div_surjective
    (orderedCoordinatePolynomial (Omega := Omega) p q) y
  exact (ambientToOrderedNormalFieldHom (Omega := Omega) p q).fieldRange.div_mem
    (orderedCoordinate_algebraMap_mem_fieldRange p q a)
    (orderedCoordinate_algebraMap_mem_fieldRange p q b)

noncomputable def ambientToOrderedNormalFieldEquiv (p q : ℕ) :
    orderedCoordinateField (Omega := Omega) p q ≃+*
      orderedCoordinateField (Omega := Omega) p q :=
  RingEquiv.ofBijective (ambientToOrderedNormalFieldHom p q)
    ⟨RingHom.injective _, ambientToOrderedNormalFieldHom_surjective p q⟩

/-- Corrected birational substitution from ordered normal coordinates to
the ambient affine chart: `u_i ↦ z_i`, `T ↦ z_p`, and
`v_j ↦ z_(p+1+j)/z_p`. -/
noncomputable def orderedNormalToAmbientFieldEquiv (p q : ℕ) :
    orderedCoordinateField (Omega := Omega) p q ≃+*
      orderedCoordinateField (Omega := Omega) p q :=
  (ambientToOrderedNormalFieldEquiv p q).symm

@[simp]
theorem orderedNormalToAmbientFieldEquiv_C
    (p q : ℕ) (c : Omega) :
    orderedNormalToAmbientFieldEquiv (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.C c)) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.C c) := by
  apply (ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).injective
  change (ambientToOrderedNormalFieldEquiv (Omega := Omega) p q)
      ((ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).symm _) = _
  rw [(ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).apply_symm_apply]
  exact (ambientToOrderedNormalFieldHom_C p q c).symm

@[simp]
theorem orderedNormalToAmbientFieldEquiv_X_normal (p q : ℕ) :
    orderedNormalToAmbientFieldEquiv (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedNormalIndex p q))) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.X (orderedNormalIndex p q)) := by
  apply (ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).injective
  change (ambientToOrderedNormalFieldEquiv (Omega := Omega) p q)
      ((ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).symm _) = _
  rw [(ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).apply_symm_apply]
  exact (ambientToOrderedNormalFieldHom_X_normal p q).symm

@[simp]
theorem orderedNormalToAmbientFieldEquiv_X_plus
    (p q : ℕ) (i : Fin p) :
    orderedNormalToAmbientFieldEquiv (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedPlusIndex p q i))) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.X (orderedPlusIndex p q i)) := by
  apply (ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).injective
  change (ambientToOrderedNormalFieldEquiv (Omega := Omega) p q)
      ((ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).symm _) = _
  rw [(ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).apply_symm_apply]
  exact (ambientToOrderedNormalFieldHom_X_plus p q i).symm

theorem orderedNormalToAmbientFieldEquiv_X_tail
    (p q : ℕ) (j : Fin q) :
    orderedNormalToAmbientFieldEquiv (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedMinusTailIndex p q j))) =
      algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedMinusTailIndex p q j)) /
        algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedNormalIndex p q)) := by
  let zT := algebraMap
    (orderedCoordinatePolynomial (Omega := Omega) p q)
    (orderedCoordinateField (Omega := Omega) p q)
    (MvPolynomial.X (orderedNormalIndex p q))
  let zV := algebraMap
    (orderedCoordinatePolynomial (Omega := Omega) p q)
    (orderedCoordinateField (Omega := Omega) p q)
    (MvPolynomial.X (orderedMinusTailIndex p q j))
  have hzT : zT ≠ 0 := by
    intro hz
    have hx0 : MvPolynomial.X (R := Omega) (orderedNormalIndex p q) = 0 :=
      (FaithfulSMul.algebraMap_injective
        (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)) (by
          dsimp [zT] at hz
          simpa only [map_zero] using hz)
    exact MvPolynomial.X_ne_zero (orderedNormalIndex p q) hx0
  apply (ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).injective
  change (ambientToOrderedNormalFieldEquiv (Omega := Omega) p q)
      ((ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).symm zV) =
    (ambientToOrderedNormalFieldEquiv (Omega := Omega) p q) (zV / zT)
  rw [(ambientToOrderedNormalFieldEquiv (Omega := Omega) p q).apply_symm_apply,
    map_div₀]
  have hV : (ambientToOrderedNormalFieldEquiv (Omega := Omega) p q) zV =
      zT * zV := by
    exact ambientToOrderedNormalFieldHom_X_tail p q j
  have hT : (ambientToOrderedNormalFieldEquiv (Omega := Omega) p q) zT =
      zT := by
    exact ambientToOrderedNormalFieldHom_X_normal p q
  rw [hV, hT]
  exact (mul_div_cancel_left₀ zV hzT).symm

end V14Formalization.SchemeGeometry
