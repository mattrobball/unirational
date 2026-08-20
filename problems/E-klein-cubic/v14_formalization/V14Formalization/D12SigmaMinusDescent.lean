/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.BinaryQuadraticDescent
public import V14Formalization.D12SigmaMinusConcrete
public import V14Formalization.V14SchemeModel

/-!
# Descent of a minus-carrier Plücker zero to the base field
-/

noncomputable section

open Matrix Polynomial

namespace V14Formalization.D12SigmaMinusDescent

open D12PolynomialData D12PolynomialEvaluation
open D12SigmaMinusNormalForm D12SigmaMinusNormalFormData
open D12SigmaMinusConcrete
open EllipticPolynomialConstancy MvFracConstantField BinaryQuadraticDescent

public abbrev k := V14SchemeModel.k

private lemma evalA_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalA ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalA WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S a_poly

private lemma evalB_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalB ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalB WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S b_poly

private lemma evalC_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalC ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalC WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S c_poly

private lemma evalD_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalD ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalD WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S d_poly

private lemma evalBinaryA_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalBinaryA ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalBinaryA WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S A_poly

private lemma evalBinaryB_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalBinaryB ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalBinaryB WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S BB_poly

private lemma evalBinaryC_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalBinaryC ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalBinaryC WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S C_poly

private lemma lineParam_map {S : Type*} [CommRing S] [Algebra k S]
    (a b c d s t : k) :
    lineParam (algebraMap k S a) (algebraMap k S b)
        (algebraMap k S c) (algebraMap k S d)
        (algebraMap k S s) (algebraMap k S t) =
      fun i => algebraMap k S (lineParam a b c d s t i) := by
  funext i
  fin_cases i <;> simp [lineParam, map_add, map_mul, map_neg, map_sub]

private lemma lineParam_map_algebraMap {R S : Type*} [CommRing R] [CommRing S]
    [Algebra R S] (a b c d s t : R) :
    lineParam (algebraMap R S a) (algebraMap R S b) (algebraMap R S c)
        (algebraMap R S d) (algebraMap R S s) (algebraMap R S t) =
      fun i => algebraMap R S (lineParam a b c d s t i) := by
  funext i
  fin_cases i <;> simp [lineParam, map_add, map_mul, map_neg, map_sub]

private lemma lineParam_smul {R : Type*} [CommRing R]
    (a b c d s t r : R) :
    lineParam a b c d (r * s) (r * t) =
      r • lineParam a b c d s t := by
  funext i
  fin_cases i <;> simp [lineParam, Pi.smul_apply, smul_eq_mul] <;> ring

public theorem minusCarrier_commonPluckerZero_descends_mvfrac
    (n : ℕ) (v : Fin 4 → MvFrac k n)
    (hv : v ≠ 0)
    (hQ : ∀ q : Fin 15,
      D12Certificate.pluckerValue
        (((D12SigmaCarrierConcrete.core.Bminus).map
          (algebraMap k (MvFrac k n))).mulVec v) q = 0) :
    ∃ (v0 : Fin 4 → k) (_hv0 : v0 ≠ 0) (c : MvFrac k n),
      c ≠ 0 ∧ v = c • fun i => algebraMap k (MvFrac k n) (v0 i) := by
  haveI : CharZero k := inferInstance
  have hparam :=
    common_plucker_zero_parametric (S := MvFrac k n) hv hQ
  have hdisc : evalBinaryB (WeilRep.ζ : k) ^ 2 -
      4 * evalBinaryA WeilRep.ζ * evalBinaryC WeilRep.ζ ≠ 0 := by
    have := hparam.2.2
    rw [evalBinaryA_map, evalBinaryB_map, evalBinaryC_map] at this
    exact (map_ne_zero_iff (algebraMap k (MvFrac k n))
      (algebraMap k (MvFrac k n)).injective).1 (by
        convert this using 1
        simp [map_sub, map_mul, map_pow, map_ofNat])
  have hst : v 2 ≠ 0 ∨ v 3 ≠ 0 := by
    by_contra h
    push_neg at h
    have hvlin := hparam.1
    apply hv
    rw [hvlin]
    simp [lineParam, h.1, h.2]
  have hq : (algebraMap k (MvFrac k n) (evalBinaryA WeilRep.ζ)) * (v 2) ^ 2 +
      (algebraMap k (MvFrac k n) (evalBinaryB WeilRep.ζ)) * (v 2) * (v 3) +
      (algebraMap k (MvFrac k n) (evalBinaryC WeilRep.ζ)) * (v 3) ^ 2 = 0 := by
    have := hparam.2.1
    rw [evalBinaryA_map, evalBinaryB_map, evalBinaryC_map] at this
    simpa [binaryQuadratic] using this
  obtain ⟨s0, t0, c, hst0, hc, hs, ht⟩ :=
    binaryQuadratic_projective_descends_mvfrac n
      (evalBinaryA WeilRep.ζ) (evalBinaryB WeilRep.ζ) (evalBinaryC WeilRep.ζ)
      hdisc (v 2) (v 3) hst hq
  let v0 : Fin 4 → k :=
    lineParam (evalA WeilRep.ζ) (evalB WeilRep.ζ)
      (evalC WeilRep.ζ) (evalD WeilRep.ζ) s0 t0
  have hv0 : v0 ≠ 0 := by
    intro h0
    have hs0 : s0 = 0 := by simpa [v0, lineParam] using congrFun h0 (2 : Fin 4)
    have ht0 : t0 = 0 := by simpa [v0, lineParam] using congrFun h0 (3 : Fin 4)
    cases hst0 with
    | inl h => exact h hs0
    | inr h => exact h ht0
  refine ⟨v0, hv0, c, hc, ?_⟩
  have hvlin := hparam.1
  rw [hvlin, evalA_map, evalB_map, evalC_map, evalD_map, hs, ht]
  have hscale := lineParam_smul
    (algebraMap k (MvFrac k n) (evalA WeilRep.ζ))
    (algebraMap k (MvFrac k n) (evalB WeilRep.ζ))
    (algebraMap k (MvFrac k n) (evalC WeilRep.ζ))
    (algebraMap k (MvFrac k n) (evalD WeilRep.ζ))
    (algebraMap k (MvFrac k n) s0)
    (algebraMap k (MvFrac k n) t0) c
  rw [hscale]
  funext i
  simp [Pi.smul_apply, smul_eq_mul, v0, lineParam_map]

public theorem minusCarrier_ambient_descends_mvfrac
    (n : ℕ) (x : Fin 15 → MvFrac k n)
    (v : Fin 4 → MvFrac k n) (hv : v ≠ 0)
    (hx : x = ((D12SigmaCarrierConcrete.core.Bminus).map
      (algebraMap k (MvFrac k n))).mulVec v)
    (hQ : ∀ q : Fin 15, D12Certificate.pluckerValue x q = 0) :
    ∃ (x0 : Fin 15 → k) (_hx0 : x0 ≠ 0) (c : MvFrac k n),
      c ≠ 0 ∧ x = c • fun i => algebraMap k (MvFrac k n) (x0 i) := by
  obtain ⟨v0, hv0, c, hc, hvdesc⟩ :=
    minusCarrier_commonPluckerZero_descends_mvfrac n v hv (by
      intro q; simpa [hx] using hQ q)
  let x0 : Fin 15 → k := D12SigmaCarrierConcrete.core.Bminus.mulVec v0
  have hx0 : x0 ≠ 0 := by
    intro h0
    have hL := congrArg (D12SigmaCarrierConcrete.core.Lminus.mulVec) h0
    have : v0 = 0 := by
      simpa [x0, Matrix.mulVec_mulVec,
        D12SigmaCarrierConcrete.core.left_inverse_minus] using hL
    exact hv0 this
  refine ⟨x0, hx0, c, hc, ?_⟩
  have hmap :
      ((D12SigmaCarrierConcrete.core.Bminus).map
          (algebraMap k (MvFrac k n))).mulVec
        (fun i => algebraMap k (MvFrac k n) (v0 i)) =
      fun i => algebraMap k (MvFrac k n) (x0 i) := by
    funext i
    simp [x0, Matrix.mulVec, dotProduct, map_sum, map_mul]
  rw [hx, hvdesc, Matrix.mulVec_smul, hmap]

/-! ## The minus branch over an arbitrary base field

The minus carrier meets the Plücker locus in a line plus a binary conic, and the
descent is `binaryQuadratic_projective_descends_mvfrac`, which is already stated
over an arbitrary characteristic-zero field.  What was pinned to `k = ℚ(ζ₁₁)`
was only the *supply* of the coefficients: `common_plucker_zero_parametric`
takes any field `S` over `WeilRep.K`, so pointing it at `MvFrac F n` through the
tower `k → F → MvFrac F n` is the whole of the generalization.

The discriminant condition `B² − 4AC ≠ 0` is an explicit element of `k`; its
image in `F` is nonzero because a field map is injective.  So the minus branch
asks nothing of `F` beyond `[Algebra k F]`. -/

section OverBase

variable (F : Type) [Field F] [Algebra k F]

/-- Characteristic zero for a field over `ℚ(ζ₁₁)`.  Stated locally so that this
file does not have to import `BaseFieldCriteria`. -/
private theorem charZero_of_algebra_k : CharZero F :=
  charZero_of_injective_algebraMap (FaithfulSMul.algebraMap_injective k F)

/-- A minus-carrier Plücker zero over `MvFrac F n` is a scalar multiple of an
`F`-rational minus-carrier vector, for every field `F` over `ℚ(ζ₁₁)`.  The
`k`-instance is `minusCarrier_commonPluckerZero_descends_mvfrac`. -/
public theorem minusCarrier_commonPluckerZero_descends_mvfrac_overBase
    (n : ℕ) (v : Fin 4 → MvFrac F n) (hv : v ≠ 0)
    (hQ : ∀ q : Fin 15,
      D12Certificate.pluckerValue
        ((((D12SigmaCarrierConcrete.core.Bminus).map (algebraMap k F)).map
          (algebraMap F (MvFrac F n))).mulVec v) q = 0) :
    ∃ (v0 : Fin 4 → F) (_hv0 : v0 ≠ 0) (c : MvFrac F n),
      c ≠ 0 ∧ v = c • fun i => algebraMap F (MvFrac F n) (v0 i) := by
  haveI : CharZero F := charZero_of_algebra_k F
  -- `MvFrac F n` is already a `k`-algebra through `F`, and both scalar towers
  -- are already instances; nothing has to be built by hand.
  have halg : ∀ a : k, algebraMap k (MvFrac F n) a =
      algebraMap F (MvFrac F n) (algebraMap k F a) :=
    fun a => IsScalarTower.algebraMap_apply k F (MvFrac F n) a
  -- transport the hypothesis to the `k`-algebra structure on `MvFrac F n`
  have hQ' : ∀ q : Fin 15,
      D12Certificate.pluckerValue
        (((D12SigmaCarrierConcrete.core.Bminus).map
          (algebraMap k (MvFrac F n))).mulVec v) q = 0 := by
    intro q
    have hB : (D12SigmaCarrierConcrete.core.Bminus).map
        (algebraMap k (MvFrac F n)) =
      ((D12SigmaCarrierConcrete.core.Bminus).map (algebraMap k F)).map
        (algebraMap F (MvFrac F n)) := by
      ext i j
      simp [Matrix.map_apply, halg]
    rw [hB]
    exact hQ q
  have hparam := common_plucker_zero_parametric (S := MvFrac F n) hv hQ'
  -- the three binary-conic coefficients, as elements of `F`
  set A : F := algebraMap k F (evalBinaryA WeilRep.ζ) with hA
  set B : F := algebraMap k F (evalBinaryB WeilRep.ζ) with hB
  set C : F := algebraMap k F (evalBinaryC WeilRep.ζ) with hC
  have hAS : evalBinaryA ((algebraMap k (MvFrac F n)) WeilRep.ζ) =
      algebraMap F (MvFrac F n) A := by
    rw [evalBinaryA_map, hA, halg]
  have hBS : evalBinaryB ((algebraMap k (MvFrac F n)) WeilRep.ζ) =
      algebraMap F (MvFrac F n) B := by
    rw [evalBinaryB_map, hB, halg]
  have hCS : evalBinaryC ((algebraMap k (MvFrac F n)) WeilRep.ζ) =
      algebraMap F (MvFrac F n) C := by
    rw [evalBinaryC_map, hC, halg]
  have hdisc : B ^ 2 - 4 * A * C ≠ 0 := by
    have hne := hparam.2.2
    rw [hAS, hBS, hCS] at hne
    refine (map_ne_zero_iff (algebraMap F (MvFrac F n))
      (algebraMap F (MvFrac F n)).injective).1 ?_
    convert hne using 1
    simp [map_sub, map_mul, map_pow, map_ofNat]
  have hst : v 2 ≠ 0 ∨ v 3 ≠ 0 := by
    by_contra h
    push_neg at h
    have hvlin := hparam.1
    apply hv
    rw [hvlin]
    simp [lineParam, h.1, h.2]
  have hq : (algebraMap F (MvFrac F n) A) * (v 2) ^ 2 +
      (algebraMap F (MvFrac F n) B) * (v 2) * (v 3) +
      (algebraMap F (MvFrac F n) C) * (v 3) ^ 2 = 0 := by
    have hbq := hparam.2.1
    rw [hAS, hBS, hCS] at hbq
    simpa [binaryQuadratic] using hbq
  obtain ⟨s0, t0, c, hst0, hc, hs, ht⟩ :=
    binaryQuadratic_projective_descends_mvfrac n A B C hdisc (v 2) (v 3) hst hq
  let v0 : Fin 4 → F :=
    lineParam (evalA ((algebraMap k F) WeilRep.ζ)) (evalB ((algebraMap k F) WeilRep.ζ))
      (evalC ((algebraMap k F) WeilRep.ζ)) (evalD ((algebraMap k F) WeilRep.ζ)) s0 t0
  have hv0 : v0 ≠ 0 := by
    intro h0
    have hs0 : s0 = 0 := by simpa [v0, lineParam] using congrFun h0 (2 : Fin 4)
    have ht0 : t0 = 0 := by simpa [v0, lineParam] using congrFun h0 (3 : Fin 4)
    cases hst0 with
    | inl h => exact h hs0
    | inr h => exact h ht0
  refine ⟨v0, hv0, c, hc, ?_⟩
  have hvlin := hparam.1
  have haS : evalA ((algebraMap k (MvFrac F n)) WeilRep.ζ) =
      algebraMap F (MvFrac F n) (evalA ((algebraMap k F) WeilRep.ζ)) := by
    rw [evalA_map, evalA_map, halg]
  have hbS : evalB ((algebraMap k (MvFrac F n)) WeilRep.ζ) =
      algebraMap F (MvFrac F n) (evalB ((algebraMap k F) WeilRep.ζ)) := by
    rw [evalB_map, evalB_map, halg]
  have hcS : evalC ((algebraMap k (MvFrac F n)) WeilRep.ζ) =
      algebraMap F (MvFrac F n) (evalC ((algebraMap k F) WeilRep.ζ)) := by
    rw [evalC_map, evalC_map, halg]
  have hdS : evalD ((algebraMap k (MvFrac F n)) WeilRep.ζ) =
      algebraMap F (MvFrac F n) (evalD ((algebraMap k F) WeilRep.ζ)) := by
    rw [evalD_map, evalD_map, halg]
  rw [hvlin, haS, hbS, hcS, hdS, hs, ht]
  have hscale := lineParam_smul
    (algebraMap F (MvFrac F n) (evalA ((algebraMap k F) WeilRep.ζ)))
    (algebraMap F (MvFrac F n) (evalB ((algebraMap k F) WeilRep.ζ)))
    (algebraMap F (MvFrac F n) (evalC ((algebraMap k F) WeilRep.ζ)))
    (algebraMap F (MvFrac F n) (evalD ((algebraMap k F) WeilRep.ζ)))
    (algebraMap F (MvFrac F n) s0)
    (algebraMap F (MvFrac F n) t0) c
  rw [hscale, lineParam_map_algebraMap]

/-- The ambient form of the minus-branch descent over an arbitrary base field.
The `k`-instance is `minusCarrier_ambient_descends_mvfrac`. -/
public theorem minusCarrier_ambient_descends_mvfrac_overBase
    (n : ℕ) (x : Fin 15 → MvFrac F n)
    (v : Fin 4 → MvFrac F n) (hv : v ≠ 0)
    (hx : x = (((D12SigmaCarrierConcrete.core.Bminus).map (algebraMap k F)).map
      (algebraMap F (MvFrac F n))).mulVec v)
    (hQ : ∀ q : Fin 15, D12Certificate.pluckerValue x q = 0) :
    ∃ (x0 : Fin 15 → F) (_hx0 : x0 ≠ 0) (c : MvFrac F n),
      c ≠ 0 ∧ x = c • fun i => algebraMap F (MvFrac F n) (x0 i) := by
  obtain ⟨v0, hv0, c, hc, hvdesc⟩ :=
    minusCarrier_commonPluckerZero_descends_mvfrac_overBase F n v hv (by
      intro q; simpa [hx] using hQ q)
  let x0 : Fin 15 → F :=
    ((D12SigmaCarrierConcrete.core.Bminus).map (algebraMap k F)).mulVec v0
  have hx0 : x0 ≠ 0 := by
    intro h0
    have hL := congrArg
      (((D12SigmaCarrierConcrete.core.Lminus).map (algebraMap k F)).mulVec) h0
    have hLB : ((D12SigmaCarrierConcrete.core.Lminus).map (algebraMap k F)) *
        ((D12SigmaCarrierConcrete.core.Bminus).map (algebraMap k F)) = 1 := by
      rw [← Matrix.map_mul, D12SigmaCarrierConcrete.core.left_inverse_minus]
      exact Matrix.map_one _ (map_zero _) (map_one _)
    have : v0 = 0 := by
      simpa [x0, Matrix.mulVec_mulVec, hLB] using hL
    exact hv0 this
  refine ⟨x0, hx0, c, hc, ?_⟩
  have hmap :
      (((D12SigmaCarrierConcrete.core.Bminus).map (algebraMap k F)).map
          (algebraMap F (MvFrac F n))).mulVec
        (fun i => algebraMap F (MvFrac F n) (v0 i)) =
      fun i => algebraMap F (MvFrac F n) (x0 i) := by
    funext i
    simp [x0, Matrix.mulVec, Matrix.map_apply, dotProduct, map_sum, map_mul]
  rw [hx, hvdesc, Matrix.mulVec_smul, hmap]

end OverBase

end V14Formalization.D12SigmaMinusDescent
