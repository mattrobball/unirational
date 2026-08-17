/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12SigmaPlusSegrePoint
public import V14Formalization.D12SigmaPlusSegreSection
public import V14Formalization.D12SigmaPlusSegreGeom
public import V14Formalization.D12SigmaPlusSegreRankTwo
public import V14Formalization.D12SigmaPlusSegreFplusMap
public import V14Formalization.D12SigmaPlusSegreSmooth
public import V14Formalization.SmoothPlaneCubicMvFracDescent
public import V14Formalization.KernelLineDescent
public import V14Formalization.MvFracConstantField
public import V14Formalization.D12SigmaCarrierConcrete
public import V14Formalization.V14SchemeModel
public import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure

/-!
# Descent of a plus-carrier Plücker zero
-/

noncomputable section

open Matrix MvPolynomial
open V14Formalization.D12SigmaPlusQuadric6
open BConicBundleMultisections

namespace V14Formalization.D12SigmaPlusDescent

open D12SigmaPlusSegreCore
open EllipticPolynomialConstancy MvFracConstantField
open SmoothPlaneCubicMvFracDescent KernelLineDescent

public abbrev k := V14SchemeModel.k
private abbrev Ki := GeometricV14Carrier.Ladj

public instance : Algebra.IsAlgebraic k Ki :=
  Algebra.IsAlgebraic.of_finite k Ki

theorem plus_reconstruct_Ki
    (u : Fin 6 → Ki) (a b : Fin 3 → Ki)
    (h : H.mulVec u = segrVecOn a b) :
    u = L.mulVec (segrVecOn a b) := by
  have := congrArg L.mulVec h
  simpa [Matrix.mulVec_mulVec, D12SigmaPlusSegreData.L_mul_H] using this

theorem plus_reconstruct_map {F : Type*} [Field F]
    (φ : Ki →+* F) (u : Fin 6 → F) (a b : Fin 3 → F)
    (h : (H.map φ).mulVec u = segrVecOn a b) :
    u = ((D12SigmaPlusSegreCore.L).map φ).mulVec (segrVecOn a b) := by
  have := congrArg ((D12SigmaPlusSegreCore.L).map φ).mulVec h
  simpa [Matrix.mulVec_mulVec, leftInv_map_mul_H_map φ] using this

theorem plusCarrier_Ki_reconstructs
    (u : Fin 6 → Ki) (hu : u ≠ 0)
    (hQ : ∀ q : Fin 15, D12Certificate.pluckerValue (BplusKi.mulVec u) q = 0) :
    ∃ (a b : Fin 3 → Ki),
      a ≠ 0 ∧ b ≠ 0 ∧
      u = L.mulVec (segrVecOn a b) ∧
      (bilinearN a).mulVec b = 0 ∧
      eval a Fplus = 0 := by
  obtain ⟨a, b, ha, hb, hsegr, hker, hF⟩ :=
    plusCarrier_commonPluckerZero_Ki u hu hQ
  exact ⟨a, b, ha, hb, plus_reconstruct_Ki u a b hsegr, hker, hF⟩

theorem align_projective_scalars_fin6
    (K : Type*) [Field K] (n : ℕ) (u : Fin 6 → MvFrac K n) (hu : u ≠ 0)
    (hconst : ∀ i, ∃ c : K, u i = algebraMap K (MvFrac K n) c) :
    ∃ (u0 : Fin 6 → K) (_hu0 : u0 ≠ 0) (c : MvFrac K n),
      c ≠ 0 ∧ u = c • fun i => algebraMap K (MvFrac K n) (u0 i) := by
  obtain ⟨j, hj⟩ : ∃ j, u j ≠ 0 := by
    by_contra h
    push Not at h
    exact hu (funext h)
  obtain ⟨cj, hcj⟩ := hconst j
  have hcjne : cj ≠ 0 := by
    intro h0
    apply hj
    simp [hcj, h0]
  refine ⟨fun i => Classical.choose (hconst i) * cj⁻¹, ?_,
    algebraMap K (MvFrac K n) cj, ?_, ?_⟩
  · intro h0
    have h0j := congrFun h0 j
    have hch : Classical.choose (hconst j) = cj := by
      have hspec := Classical.choose_spec (hconst j)
      exact (algebraMap K (MvFrac K n)).injective (hspec.symm.trans hcj)
    have : (cj * cj⁻¹ : K) = 0 := by
      simpa [hch] using h0j
    rw [mul_inv_cancel₀ hcjne] at this
    exact one_ne_zero this
  · simpa [hcj] using hcjne
  · funext i
    have hi := Classical.choose_spec (hconst i)
    rw [Pi.smul_apply, smul_eq_mul, hi, map_mul, map_inv₀]
    have hcj0 : algebraMap K (MvFrac K n) cj ≠ 0 := by
      simpa [hcj] using hj
    field_simp [hcj0]

public instance : Infinite (AlgebraicClosure Ki) :=
  CharZero.infinite (M := AlgebraicClosure Ki)

theorem Fplus_smooth_algClosure :
    Standard.IsSmoothPlaneCubic
      (map (algebraMap Ki (AlgebraicClosure Ki)) Fplus) :=
  Fplus_isSmoothPlaneCubic_map (algebraMap Ki (AlgebraicClosure Ki))

theorem plusCarrier_commonPluckerZero_descends_mvfrac_Ki
    (n : ℕ) (u : Fin 6 → MvFrac Ki n) (hu : u ≠ 0)
    (hQ : ∀ q : Fin 15,
      D12Certificate.pluckerValue
        ((BplusKi.map (algebraMap Ki (MvFrac Ki n))).mulVec u) q = 0) :
    ∃ (u0 : Fin 6 → Ki) (_hu0 : u0 ≠ 0) (c : MvFrac Ki n),
      c ≠ 0 ∧ u = c • fun i => algebraMap Ki (MvFrac Ki n) (u0 i) := by
  set φ : Ki →+* MvFrac Ki n := algebraMap Ki (MvFrac Ki n)
  obtain ⟨a, b, ha, hb, hsegr, hker, hdet0⟩ :=
    plusCarrier_commonPluckerZero_to_determinantalCubic φ u hu hQ
  have hzero : eval a (map φ Fplus) = 0 := by
    rw [eval_map_Fplus_eq_det, hdet0]
  obtain ⟨a0, ha0, ca, hca, haesc⟩ :=
    smoothPlaneCubic_projective_descends_mvfrac n Fplus
      Fplus_smooth_algClosure a ha hzero
  have hA :
      bilinearNOn φ a = ca • (bilinearN a0).map φ := by
    have : a = ca • fun i => φ (a0 i) := haesc
    rw [this, bilinearNOn_smul, bilinearNOn_map_of_base]
  have hker0 : ((bilinearN a0).map φ).mulVec b = 0 := by
    have := hker
    rw [hA] at this
    have : ca • ((bilinearN a0).map φ).mulVec b = 0 := by
      simpa [Matrix.smul_mulVec] using this
    exact (smul_eq_zero.mp this).resolve_left hca
  have hF0 : eval a0 Fplus = 0 := by
    have hmap0 : eval (fun i => φ (a0 i)) (map φ Fplus) = φ (eval a0 Fplus) := by
      rw [eval_map_Fplus, eval_Fplus]
      simp [map_add, map_mul, map_pow]
    have hhom : eval a (map φ Fplus) =
        ca ^ 3 * eval (fun i => φ (a0 i)) (map φ Fplus) := by
      rw [haesc, eval_map_Fplus, eval_map_Fplus]
      simp [Pi.smul_apply, smul_eq_mul]
      ring
    have hca3 : ca ^ 3 ≠ 0 := pow_ne_zero 3 hca
    have := hzero
    rw [hhom, hmap0] at this
    have : φ (eval a0 Fplus) = 0 :=
      (mul_eq_zero.mp this).resolve_left hca3
    exact (map_eq_zero_iff φ φ.injective).1 this
  have hrank : (bilinearN a0).rank = 2 :=
    smooth_detCubic_rank_eq_two a0 ha0 hF0
  obtain ⟨b0, cb, hb0, hcb, hbesc⟩ :=
    kernelLine_descends_of_rank_eq_two (bilinearN a0) hrank b hb hker0
  have hb0ker : (bilinearN a0).mulVec b0 = 0 := by
    have : ((bilinearN a0).map φ).mulVec (fun i => φ (b0 i)) = 0 := by
      have := hker0
      rw [hbesc] at this
      simpa [Matrix.mulVec_smul, smul_eq_zero, hcb] using this
    have hmap :
        ((bilinearN a0).map φ).mulVec (fun i => φ (b0 i)) =
          fun i => φ ((bilinearN a0).mulVec b0 i) := by
      funext i
      simp [Matrix.mulVec, Matrix.map_apply, dotProduct, map_sum, map_mul]
    rw [hmap] at this
    ext i
    exact (map_eq_zero_iff φ φ.injective).1 (congrFun this i)
  let u0 : Fin 6 → Ki := L.mulVec (segrVecOn a0 b0)
  have hu0 : u0 ≠ 0 := by
    intro h0
    have hse : segrVecOn a0 b0 = segrVec a0 b0 := by
      funext p
      rfl
    have hN0 : N.mulVec (segrVecOn a0 b0) = 0 := by
      simpa [hse, N_mulVec_segrVec] using hb0ker
    have hHL : H.mulVec u0 = segrVecOn a0 b0 := by
      simpa [u0] using (eq_H_mulVec_L_of_N_mulVec _ hN0).symm
    have : segrVecOn a0 b0 = 0 := by
      simpa [h0] using hHL.symm
    exact segrVecOn_ne_zero ha0 hb0 this
  refine ⟨u0, hu0, ca * cb, mul_ne_zero hca hcb, ?_⟩
  have hsegr' :
      segrVecOn a b =
        (ca * cb) • fun p => φ (segrVecOn a0 b0 p) := by
    have ha' : a = ca • fun i => φ (a0 i) := haesc
    have hb' : b = cb • fun i => φ (b0 i) := hbesc
    rw [ha', hb', segrVecOn_smul, segrVecOn_map]
  have hrec := plus_reconstruct_map φ u a b hsegr
  rw [hrec, hsegr', Matrix.mulVec_smul, L_map_mulVec_map]

public theorem pluckerValue_map {F F' : Type*} [Field F] [Field F']
    (φ : F →+* F') (x : Fin 15 → F) (q : Fin 15) :
    D12Certificate.pluckerValue (fun i => φ (x i)) q =
      φ (D12Certificate.pluckerValue x q) := by
  simp [D12Certificate.pluckerValue, map_mul, map_sub, map_add]

public theorem mulVec_comp_map {m n : ℕ} {R S T : Type*}
    [Semiring R] [Semiring S] [Semiring T]
    (f : S →+* T) (g : R →+* S)
    (M : Matrix (Fin m) (Fin n) R) (v : Fin n → S) :
    (M.map (f.comp g)).mulVec (f ∘ v) =
      f ∘ (M.map g).mulVec v := by
  funext i
  simp [Matrix.mulVec, Matrix.map_apply, dotProduct, map_sum, map_mul]

/-- A plus-carrier Plücker zero over `MvFrac k n` is a scalar multiple of a
base-field plus-carrier vector.  The Segre packet is used after extending
coefficients to `Ki`, then ratios return to `k`. -/
public theorem plusCarrier_commonPluckerZero_descends_mvfrac
    (n : ℕ) (u : Fin 6 → MvFrac k n) (hu : u ≠ 0)
    (hQ : ∀ q : Fin 15,
      D12Certificate.pluckerValue
        (((D12SigmaCarrierConcrete.core.Bplus).map
          (algebraMap k (MvFrac k n))).mulVec u) q = 0) :
    ∃ (u0 : Fin 6 → k) (_hu0 : u0 ≠ 0) (c : MvFrac k n),
      c ≠ 0 ∧ u = c • fun i => algebraMap k (MvFrac k n) (u0 i) := by
  let ι :=
    mvFracBaseChange (algebraMap k Ki)
      (FaithfulSMul.algebraMap_injective k Ki) n
  let uL : Fin 6 → MvFrac Ki n := fun i => ι (u i)
  have huL : uL ≠ 0 := by
    intro h0
    apply hu
    funext i
    exact (map_eq_zero_iff ι (mvFracBaseChange_injective _ _ n)).1
      (congrFun h0 i)
  have hQL : ∀ q : Fin 15,
      D12Certificate.pluckerValue
        ((BplusKi.map (algebraMap Ki (MvFrac Ki n))).mulVec uL) q = 0 := by
    intro q
    have hcomp :
        (algebraMap Ki (MvFrac Ki n)).comp (algebraMap k Ki) =
          ι.comp (algebraMap k (MvFrac k n)) :=
      RingHom.ext fun a =>
        (mvFracBaseChange_algebraMap_base (algebraMap k Ki)
            (FaithfulSMul.algebraMap_injective k Ki) n a).symm
    have hx :
        (BplusKi.map (algebraMap Ki (MvFrac Ki n))).mulVec uL =
          fun i => ι
            (((D12SigmaCarrierConcrete.core.Bplus).map
              (algebraMap k (MvFrac k n))).mulVec u i) := by
      have hB :
          BplusKi.map (algebraMap Ki (MvFrac Ki n)) =
            (D12SigmaCarrierConcrete.core.Bplus).map
              ((algebraMap Ki (MvFrac Ki n)).comp (algebraMap k Ki)) := by
        simp [BplusKi, Matrix.map_map]
      rw [hB, hcomp]
      exact mulVec_comp_map ι (algebraMap k (MvFrac k n))
        D12SigmaCarrierConcrete.core.Bplus u
    rw [hx, pluckerValue_map, hQ, map_zero]
  obtain ⟨u0L, _hu0L, cL, hcL, hscale⟩ :=
    plusCarrier_commonPluckerZero_descends_mvfrac_Ki n uL huL hQL
  obtain ⟨j, hj⟩ : ∃ j, u j ≠ 0 := by
    by_contra h
    push Not at h
    exact hu (funext h)
  have hιj : ι (u j) ≠ 0 :=
    (map_ne_zero_iff ι (mvFracBaseChange_injective _ _ n)).2 hj
  have hscalei : ∀ i,
      ι (u i) = cL * algebraMap Ki (MvFrac Ki n) (u0L i) := by
    intro i
    simpa [uL, Pi.smul_apply, smul_eq_mul] using congrFun hscale i
  have hu0Lj : u0L j ≠ 0 := by
    intro h0
    have := hscalei j
    rw [h0, map_zero, mul_zero] at this
    exact hιj this
  have hratio : ∀ i,
      ∃ r : k, u i / u j = algebraMap k (MvFrac k n) r := by
    intro i
    have hιratio :
        ι (u i / u j) =
          algebraMap Ki (MvFrac Ki n) (u0L i / u0L j) := by
      calc
        ι (u i / u j) = ι (u i) / ι (u j) := map_div₀ _ _ _
        _ = (cL * algebraMap Ki (MvFrac Ki n) (u0L i)) /
              (cL * algebraMap Ki (MvFrac Ki n) (u0L j)) := by
              rw [hscalei i, hscalei j]
        _ = algebraMap Ki (MvFrac Ki n) (u0L i) /
              algebraMap Ki (MvFrac Ki n) (u0L j) :=
              mul_div_mul_left _ _ hcL
        _ = algebraMap Ki (MvFrac Ki n) (u0L i / u0L j) :=
              (map_div₀ _ _ _).symm
    exact mvFrac_eq_constant_of_baseChange_eq_constant n
      (u i / u j) (u0L i / u0L j) hιratio
  let u0 : Fin 6 → k := fun i => Classical.choose (hratio i)
  have hu0i : ∀ i, u i = algebraMap k (MvFrac k n) (u0 i) * u j := by
    intro i
    have hi := Classical.choose_spec (hratio i)
    calc
      u i = (u i / u j) * u j := (div_mul_cancel₀ (u i) hj).symm
      _ = algebraMap k (MvFrac k n) (u0 i) * u j := by rw [hi]
  have hu0 : u0 ≠ 0 := by
    intro h0
    have hj0 : u0 j = 0 := congrFun h0 j
    have := hu0i j
    rw [hj0, map_zero, zero_mul] at this
    exact hj this
  refine ⟨u0, hu0, u j, hj, ?_⟩
  funext i
  rw [Pi.smul_apply, smul_eq_mul, hu0i i, mul_comm]

public theorem plusCarrier_ambient_descends_mvfrac
    (n : ℕ) (x : Fin 15 → MvFrac k n)
    (u : Fin 6 → MvFrac k n) (hu : u ≠ 0)
    (hx : x = ((D12SigmaCarrierConcrete.core.Bplus).map
      (algebraMap k (MvFrac k n))).mulVec u)
    (hQ : ∀ q : Fin 15, D12Certificate.pluckerValue x q = 0) :
    ∃ (x0 : Fin 15 → k) (_hx0 : x0 ≠ 0) (c : MvFrac k n),
      c ≠ 0 ∧ x = c • fun i => algebraMap k (MvFrac k n) (x0 i) := by
  obtain ⟨u0, hu0, c, hc, hudesc⟩ :=
    plusCarrier_commonPluckerZero_descends_mvfrac n u hu (by
      intro q; simpa [hx] using hQ q)
  let x0 : Fin 15 → k := D12SigmaCarrierConcrete.core.Bplus.mulVec u0
  have hx0 : x0 ≠ 0 := by
    intro h0
    have hL := congrArg (D12SigmaCarrierConcrete.core.Lplus.mulVec) h0
    have : u0 = 0 := by
      simpa [x0, Matrix.mulVec_mulVec,
        D12SigmaCarrierConcrete.core.left_inverse_plus] using hL
    exact hu0 this
  refine ⟨x0, hx0, c, hc, ?_⟩
  have hmap :
      ((D12SigmaCarrierConcrete.core.Bplus).map
          (algebraMap k (MvFrac k n))).mulVec
        (fun i => algebraMap k (MvFrac k n) (u0 i)) =
      fun i => algebraMap k (MvFrac k n) (x0 i) := by
    funext i
    simp [x0, Matrix.mulVec, dotProduct, map_sum, map_mul]
  rw [hx, hudesc, Matrix.mulVec_smul, hmap]

end V14Formalization.D12SigmaPlusDescent
