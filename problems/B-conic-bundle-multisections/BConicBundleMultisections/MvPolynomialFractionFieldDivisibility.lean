module

public import Mathlib.RingTheory.MvPolynomial.Localization
public import Mathlib.RingTheory.Localization.Ideal
public import Mathlib.RingTheory.Polynomial.Quotient
public import Mathlib.RingTheory.MvPolynomial.Homogeneous

@[expose] public section

open MvPolynomial

attribute [local instance] MvPolynomial.algebraMvPolynomial

theorem Ideal.isPrime_map_C_mvPolynomial
    {R σ : Type*} [CommRing R] (P : Ideal R) (hP : P.IsPrime) :
    (Ideal.map (MvPolynomial.C : R →+* MvPolynomial σ R) P).IsPrime := by
  rw [← Ideal.Quotient.isDomain_iff_prime]
  letI : P.IsPrime := hP
  haveI : IsDomain (R ⧸ P) := inferInstance
  haveI : IsDomain (MvPolynomial σ (R ⧸ P)) := inferInstance
  exact MulEquiv.isDomain (MvPolynomial σ (R ⧸ P))
    (MvPolynomial.quotientEquivQuotientMvPolynomial P).symm.toMulEquiv

theorem MvPolynomial.commAlgEquiv_map_C
    {k σ τ : Type*} [CommSemiring k] (H : MvPolynomial τ k) :
    MvPolynomial.commAlgEquiv k τ σ
        (MvPolynomial.map (MvPolynomial.C : k →+* MvPolynomial σ k) H) =
      MvPolynomial.C H := by
  induction H using MvPolynomial.induction_on with
  | C r => simp
  | add p q hp hq => simp [hp, hq]
  | mul_X p i hp => simp [hp, mul_comm]

theorem isPrime_span_map_coefficients_of_prime
    {k σ τ : Type*} [Field k] (H : MvPolynomial τ k)
    (hH : (Ideal.span ({H} : Set (MvPolynomial τ k))).IsPrime) :
    (Ideal.span
      ({MvPolynomial.map (MvPolynomial.C : k →+* MvPolynomial σ k) H} :
        Set (MvPolynomial τ (MvPolynomial σ k)))).IsPrime := by
  let Ry := MvPolynomial τ k
  let Rx := MvPolynomial σ k
  let T := MvPolynomial τ Rx
  let U := MvPolynomial σ Ry
  let e : T ≃+* U := (MvPolynomial.commAlgEquiv k τ σ).toRingEquiv
  let P : Ideal Ry := Ideal.span ({H} : Set Ry)
  have hP : P.IsPrime := hH
  have hPC : (Ideal.map (MvPolynomial.C : Ry →+* U) P).IsPrime :=
    Ideal.isPrime_map_C_mvPolynomial P hP
  have hPCeq : Ideal.map (MvPolynomial.C : Ry →+* U) P =
      Ideal.span ({MvPolynomial.C H} : Set U) := by
    change Ideal.map (MvPolynomial.C : Ry →+* U) (Ideal.span ({H} : Set Ry)) = _
    rw [Ideal.map_span, Set.image_singleton]
  have heH : e (MvPolynomial.map (MvPolynomial.C : k →+* Rx) H) =
      MvPolynomial.C H := by
    exact MvPolynomial.commAlgEquiv_map_C H
  have hmap : Ideal.map e
      (Ideal.span
        ({MvPolynomial.map (MvPolynomial.C : k →+* Rx) H} : Set T)) =
      Ideal.span ({MvPolynomial.C H} : Set U) := by
    rw [Ideal.map_span, Set.image_singleton, heH]
  have hcomap : Ideal.comap e (Ideal.span ({MvPolynomial.C H} : Set U)) =
      Ideal.span
        ({MvPolynomial.map (MvPolynomial.C : k →+* Rx) H} : Set T) := by
    rw [← hmap, Ideal.comap_map_of_bijective e e.bijective]
  rw [← hcomap]
  exact (hPCeq ▸ hPC).comap e

theorem disjoint_nonZeroDivisors_map_C_span_map_coefficients_of_homogeneous
    {k σ τ : Type*} [Field k] (H : MvPolynomial τ k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) :
    Disjoint
      (((nonZeroDivisors (MvPolynomial σ k)).map
          (MvPolynomial.C : MvPolynomial σ k →+*
            MvPolynomial τ (MvPolynomial σ k)).toMonoidHom :
        Submonoid (MvPolynomial τ (MvPolynomial σ k))) :
        Set (MvPolynomial τ (MvPolynomial σ k)))
      (Ideal.span
        ({MvPolynomial.map (MvPolynomial.C : k →+* MvPolynomial σ k) H} :
          Set (MvPolynomial τ (MvPolynomial σ k))) :
        Set (MvPolynomial τ (MvPolynomial σ k))) := by
  rw [Set.disjoint_left]
  intro z hzM hzI
  obtain ⟨r, hr, hrz⟩ := Submonoid.mem_map.mp hzM
  subst z
  obtain ⟨a, ha⟩ := Ideal.mem_span_singleton.mp hzI
  have hconst : MvPolynomial.constantCoeff H = 0 := by
    exact hH.coeff_eq_zero (by simpa using hd.ne)
  have heval := congrArg
    (MvPolynomial.eval (0 : τ → MvPolynomial σ k)) ha
  have hr0 : r = 0 := by
    simpa [MvPolynomial.constantCoeff_map, hconst] using heval
  exact (mem_nonZeroDivisors_iff_ne_zero.mp hr) hr0

theorem dvd_of_map_dvd_map_of_isFractionRing
    {R K σ : Type*} [CommRing R] [IsDomain R]
    [CommRing K] [Algebra R K] [IsFractionRing R K]
    {f g : MvPolynomial σ R}
    (hg : (Ideal.span ({g} : Set (MvPolynomial σ R))).IsPrime)
    (hdisj : Disjoint
      (((nonZeroDivisors R).map
          (MvPolynomial.C : R →+* MvPolynomial σ R).toMonoidHom :
        Submonoid (MvPolynomial σ R)) : Set (MvPolynomial σ R))
      (Ideal.span ({g} : Set (MvPolynomial σ R)) : Set (MvPolynomial σ R)))
    (h : MvPolynomial.map (algebraMap R K) g ∣
      MvPolynomial.map (algebraMap R K) f) :
    g ∣ f := by
  let M : Submonoid (MvPolynomial σ R) :=
    (nonZeroDivisors R).map
      (MvPolynomial.C : R →+* MvPolynomial σ R).toMonoidHom
  let I : Ideal (MvPolynomial σ R) := Ideal.span ({g} : Set (MvPolynomial σ R))
  letI : IsLocalization M (MvPolynomial σ K) := by
    dsimp [M]
    infer_instance
  have hmap : MvPolynomial.map (algebraMap R K) f ∈
      Ideal.map (algebraMap (MvPolynomial σ R) (MvPolynomial σ K)) I := by
    rw [show Ideal.map (algebraMap (MvPolynomial σ R) (MvPolynomial σ K)) I =
        Ideal.span ({MvPolynomial.map (algebraMap R K) g} :
          Set (MvPolynomial σ K)) by
      simp only [I, Ideal.map_span, Set.image_singleton,
        MvPolynomial.algebraMap_def]]
    exact Ideal.mem_span_singleton.mpr h
  have hcontract := IsLocalization.under_map_of_isPrime_disjoint M
    (MvPolynomial σ K) hg hdisj
  have hfI : f ∈ I := by
    rw [← show (Ideal.map (algebraMap (MvPolynomial σ R) (MvPolynomial σ K)) I).under
      (MvPolynomial σ R) = I by simpa [I, M] using hcontract]
    change algebraMap (MvPolynomial σ R) (MvPolynomial σ K) f ∈
      Ideal.map (algebraMap (MvPolynomial σ R) (MvPolynomial σ K)) I
    simpa only [MvPolynomial.algebraMap_def] using hmap
  exact Ideal.mem_span_singleton.mp hfI
