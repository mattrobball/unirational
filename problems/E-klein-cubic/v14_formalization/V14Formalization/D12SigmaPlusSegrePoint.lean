/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12SigmaPlusSegreHMDir
import V14Formalization.D12SigmaPlusSegreSpanEval
import V14Formalization.D12SigmaPlusSegrePlucker
import V14Formalization.D12SigmaPlusSegreFplusDet
import V14Formalization.D12SigmaPlusSegreSection
import V14Formalization.D12SigmaPlusSegreSmooth
import V14Formalization.V14FixedPointSegreBridge

/-!
# Point-level plus Segre: Plücker zeros become the determinantal cubic
-/

noncomputable section

open Matrix MvPolynomial
open V14Formalization.D12SigmaPlusQuadric6

namespace V14Formalization.D12SigmaPlusSegreCore

variable {F : Type*} [Field F]

def segrVecOn (a b : Fin 3 → F) : Fin 9 → F :=
  fun p =>
    a ⟨p.val / 3, Nat.div_lt_of_lt_mul (by
      have := p.isLt
      omega)⟩ *
    b ⟨p.val % 3, Nat.mod_lt _ (by decide)⟩

def bilinearNOn (φ : Ki →+* F) (a : Fin 3 → F) : Matrix (Fin 3) (Fin 3) F :=
  fun r j => ∑ i : Fin 3, φ (N r (crossIndex i j)) * a i

theorem leftInv_map_mul_H_map (φ : Ki →+* F) :
    ((D12SigmaPlusSegreCore.L).map φ) * (H.map φ) = 1 := by
  rw [← Matrix.map_mul, D12SigmaPlusSegreData.L_mul_H]
  exact Matrix.map_one φ (map_zero φ) (map_one φ)

theorem N_map_mul_H_map (φ : Ki →+* F) :
    (N.map φ) * (H.map φ) = 0 := by
  rw [← Matrix.map_mul, D12SigmaPlusSegreData.N_mul_H]
  simp [Matrix.map_zero]

theorem H_map_mulVec_injective (φ : Ki →+* F) :
    Function.Injective ((H.map φ).mulVec : (Fin 6 → F) → Fin 9 → F) := by
  intro u v h
  have := congrArg ((D12SigmaPlusSegreCore.L).map φ).mulVec h
  simpa [Matrix.mulVec_mulVec, leftInv_map_mul_H_map φ] using this

theorem reshapeMinor_mapH (φ : Ki →+* F) (u : Fin 6 → F) (s : Fin 9) :
    reshapeMinor ((H.map φ).mulVec u) s =
      quadValue (fun k => φ (minorCoeffsH s k)) u := by
  have hdot (p : Fin 9) :
      ((H.map φ).mulVec u) p =
        dotProduct (fun j => φ (H p j)) u := by
    simp [Matrix.mulVec, Matrix.map_apply, dotProduct]
  have hb (p q : Fin 9) :
      quadValue (fun k => φ (bilinearCoeffs (Hrow p) (Hrow q) k)) u =
        dotProduct (fun j => φ (H p j)) u *
          dotProduct (fun j => φ (H q j)) u := by
    have := quadValue_bilinearCoeffs (fun j => φ (H p j)) (fun j => φ (H q j)) u
    refine Eq.trans ?_ this
    apply congrArg (fun Q => quadValue Q u)
    funext k
    exact (bilinearCoeffs_map φ (Hrow p) (Hrow q) k).symm
  have hsub (p q r t : Fin 9) :
      quadValue (fun k =>
          φ (bilinearCoeffs (Hrow p) (Hrow q) k) -
            φ (bilinearCoeffs (Hrow r) (Hrow t) k)) u =
        dotProduct (fun j => φ (H p j)) u *
            dotProduct (fun j => φ (H q j)) u -
          dotProduct (fun j => φ (H r j)) u *
            dotProduct (fun j => φ (H t j)) u := by
    change quadValue
        ((fun k => φ (bilinearCoeffs (Hrow p) (Hrow q) k)) -
          fun k => φ (bilinearCoeffs (Hrow r) (Hrow t) k)) u = _
    rw [quadValue_sub, hb, hb]
  fin_cases s <;>
    simp [reshapeMinor, minorCoeffsH, minorOrder, reshape3_apply, hdot,
      hsub, crossIndex, Hrow]

theorem minorCoeffsH_map (φ : Ki →+* F) (s : Fin 9) (k : Fin 21) :
    φ (minorCoeffsH s k) = φ (minorQ s k) := by
  rw [minorCoeffsH_eq_minorQ]

theorem quadValue_minorQ_map (φ : Ki →+* F) (u : Fin 6 → F) (s : Fin 9) :
    quadValue (fun k => φ (minorQ s k)) u =
      ∑ q : Fin 15, φ (spanV s q) * quadValue (fun k => φ (Qplus q k)) u := by
  have hrow :
      (fun k => φ (minorQ s k)) =
        ∑ q : Fin 15, φ (spanV s q) • (fun k => φ (Qplus q k)) := by
    funext k
    have h := congrArg (fun M : Matrix (Fin 9) (Fin 21) Ki => φ (M s k))
      spanV_mul_Qplus
    simpa [Matrix.mul_apply, Pi.smul_apply, smul_eq_mul, Finset.sum_apply,
      map_sum, map_mul] using h.symm
  rw [hrow, quadValue_linear]

theorem reshapeMinor_mapH_of_Qplus
    (φ : Ki →+* F) (u : Fin 6 → F) (s : Fin 9)
    (hQ : ∀ q : Fin 15, quadValue (fun k => φ (Qplus q k)) u = 0) :
    reshapeMinor ((H.map φ).mulVec u) s = 0 := by
  rw [reshapeMinor_mapH, funext fun k => minorCoeffsH_map φ s k,
    quadValue_minorQ_map]
  simp [hQ]

theorem twoByTwo_of_reshapeMinors {R : Type*} [CommRing R]
    (z : Fin 9 → R) (h : ∀ s : Fin 9, reshapeMinor z s = 0)
    (i i' j j' : Fin 3) :
    reshape3 z i j * reshape3 z i' j' = reshape3 z i j' * reshape3 z i' j := by
  wlog hii : i.val ≤ i'.val generalizing i i'
  · have := this i' i (Nat.le_of_not_ge hii)
    simpa [mul_comm] using this.symm
  wlog hjj : j.val ≤ j'.val generalizing j j'
  · have := this j' j (Nat.le_of_not_ge hjj)
    simpa [mul_comm] using this.symm
  rcases eq_or_ne i i' with hi | hi
  · subst i'; ring
  rcases eq_or_ne j j' with hj | hj
  · subst j'; ring
  have h0 := sub_eq_zero.mp (by
    simpa [reshapeMinor, reshape3_apply, crossIndex] using h (0 : Fin 9))
  have h1 := sub_eq_zero.mp (by
    simpa [reshapeMinor, reshape3_apply, crossIndex] using h (1 : Fin 9))
  have h2 := sub_eq_zero.mp (by
    simpa [reshapeMinor, reshape3_apply, crossIndex] using h (2 : Fin 9))
  have h3 := sub_eq_zero.mp (by
    simpa [reshapeMinor, reshape3_apply, crossIndex] using h (3 : Fin 9))
  have h4 := sub_eq_zero.mp (by
    simpa [reshapeMinor, reshape3_apply, crossIndex] using h (4 : Fin 9))
  have h5 := sub_eq_zero.mp (by
    simpa [reshapeMinor, reshape3_apply, crossIndex] using h (5 : Fin 9))
  have h6 := sub_eq_zero.mp (by
    simpa [reshapeMinor, reshape3_apply, crossIndex] using h (6 : Fin 9))
  have h7 := sub_eq_zero.mp (by
    simpa [reshapeMinor, reshape3_apply, crossIndex] using h (7 : Fin 9))
  have h8 := sub_eq_zero.mp (by
    simpa [reshapeMinor, reshape3_apply, crossIndex] using h (8 : Fin 9))
  have hi01 : i = 0 ∧ i' = 1 ∨ i = 0 ∧ i' = 2 ∨ i = 1 ∧ i' = 2 := by
    revert i i' hi hii; decide
  have hj01 : j = 0 ∧ j' = 1 ∨ j = 0 ∧ j' = 2 ∨ j = 1 ∧ j' = 2 := by
    revert j j' hj hjj; decide
  rcases hi01 with (⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩) <;>
    rcases hj01 with (⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩)
  · exact h0
  · exact h1
  · exact h2
  · exact h3
  · exact h4
  · exact h5
  · exact h6
  · exact h7
  · exact h8

theorem plucker_eq_Qplus_value (φ : Ki →+* F) (u : Fin 6 → F) (q : Fin 15) :
    D12Certificate.pluckerValue ((BplusKi.map φ).mulVec u) q =
      quadValue (fun k => φ (Qplus q k)) u := by
  have hres :
      restrictedPluckerCoeffs (BplusKi.map φ) q =
        fun m => φ (restrictedPluckerCoeffs BplusKi q m) :=
    restrictedPluckerCoeffs_map φ BplusKi q
  have hQ : restrictedPluckerCoeffs BplusKi q = fun m => Qplus q m := by
    funext m
    exact Qplus_eq_restricted q m
  rw [← quadValue_restrictedPluckerCoeffs (BplusKi.map φ) q u, hres, hQ]

theorem N_map_mulVec_segrVec (φ : Ki →+* F) (a b : Fin 3 → F) :
    (N.map φ).mulVec (segrVecOn a b) = (bilinearNOn φ a).mulVec b := by
  funext r
  simp [Matrix.mulVec, bilinearNOn, segrVecOn, dotProduct, Fin.sum_univ_succ,
    crossIndex, Matrix.map_apply]
  ring

theorem segrVecOn_ne_zero {a b : Fin 3 → F} (ha : a ≠ 0) (hb : b ≠ 0) :
    segrVecOn a b ≠ 0 := by
  intro hz
  obtain ⟨i, hi⟩ : ∃ i, a i ≠ 0 := by
    by_contra h; push_neg at h; exact ha (funext h)
  obtain ⟨j, hj⟩ : ∃ j, b j ≠ 0 := by
    by_contra h; push_neg at h; exact hb (funext h)
  have h0 : segrVecOn a b (crossIndex i j) = 0 := congrFun hz _
  have hdiv : (3 * i.val + j.val) / 3 = i.val := by
    rw [Nat.add_comm, Nat.add_mul_div_left j.val i.val (by decide),
      Nat.div_eq_of_lt j.isLt, zero_add]
  have hmod : (3 * i.val + j.val) % 3 = j.val := by
    rw [Nat.add_comm, Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt j.isLt]
  have hab : a i * b j = 0 := by
    simpa [segrVecOn, crossIndex, hdiv, hmod] using h0
  exact mul_ne_zero hi hj hab

theorem reshape3_segrVecOn (a b : Fin 3 → F) (i j : Fin 3) :
    reshape3 (segrVecOn a b) i j = a i * b j := by
  have hdiv : (3 * i.val + j.val) / 3 = i.val := by
    rw [Nat.add_comm, Nat.add_mul_div_left j.val i.val (by decide),
      Nat.div_eq_of_lt j.isLt, zero_add]
  have hmod : (3 * i.val + j.val) % 3 = j.val := by
    rw [Nat.add_comm, Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt j.isLt]
  simp [reshape3_apply, segrVecOn, crossIndex, hdiv, hmod]

/-- A plus-carrier Plücker zero is a Segre tensor on the determinantal cubic. -/
theorem plusCarrier_commonPluckerZero_to_determinantalCubic
    (φ : Ki →+* F) (u : Fin 6 → F) (hu : u ≠ 0)
    (hQ : ∀ q : Fin 15,
      D12Certificate.pluckerValue ((BplusKi.map φ).mulVec u) q = 0) :
    ∃ (a b : Fin 3 → F),
      a ≠ 0 ∧ b ≠ 0 ∧
      (H.map φ).mulVec u = segrVecOn a b ∧
      (bilinearNOn φ a).mulVec b = 0 ∧
      (bilinearNOn φ a).det = 0 := by
  have hz : (H.map φ).mulVec u ≠ 0 := by
    intro h0
    exact hu (H_map_mulVec_injective φ (h0.trans (Matrix.mulVec_zero _).symm))
  have hminor : ∀ s : Fin 9,
      reshapeMinor ((H.map φ).mulVec u) s = 0 := by
    intro s
    refine reshapeMinor_mapH_of_Qplus φ u s ?_
    intro q
    rw [← plucker_eq_Qplus_value φ u q]
    exact hQ q
  let zMat : Matrix (Fin 3) (Fin 3) F := reshape3 ((H.map φ).mulVec u)
  have hzMat : zMat ≠ 0 := by
    intro h0
    apply hz
    funext p
    obtain ⟨i, j, hij⟩ : ∃ i j, crossIndex i j = p := by
      refine ⟨⟨p.val / 3, ?_⟩, ⟨p.val % 3, Nat.mod_lt _ (by decide)⟩, ?_⟩
      · exact Nat.div_lt_of_lt_mul (by have := p.isLt; omega)
      · ext
        simp [crossIndex, Nat.div_add_mod]
    simpa [zMat, reshape3_apply, hij] using congrFun (congrFun h0 i) j
  have hminors :
      ∀ i i' j j', zMat i j * zMat i' j' = zMat i j' * zMat i' j :=
    twoByTwo_of_reshapeMinors _ hminor
  obtain ⟨a, b, ha, hb, hab⟩ :=
    exists_pureTensor_of_twoByTwoMinors_eq_zero zMat hzMat hminors
  have hsegr : (H.map φ).mulVec u = segrVecOn a b := by
    funext p
    let i : Fin 3 := ⟨p.val / 3, Nat.div_lt_of_lt_mul (by
      have := p.isLt; omega)⟩
    let j : Fin 3 := ⟨p.val % 3, Nat.mod_lt _ (by decide)⟩
    have hp : crossIndex i j = p := by
      ext
      simp [i, j, crossIndex, Nat.div_add_mod]
    have hz : ((H.map φ).mulVec u) p = zMat i j := by
      simp [zMat, reshape3_apply, hp]
    rw [hz, hab, ← reshape3_segrVecOn a b i j, reshape3_apply, hp]
  have hN : (N.map φ).mulVec ((H.map φ).mulVec u) = 0 := by
    simp [Matrix.mulVec_mulVec, N_map_mul_H_map]
  have hker : (bilinearNOn φ a).mulVec b = 0 := by
    rw [← N_map_mulVec_segrVec, ← hsegr, hN]
  have hdet0 : (bilinearNOn φ a).det = 0 := by
    obtain ⟨j, hj⟩ : ∃ j, b j ≠ 0 := by
      by_contra h; push_neg at h; exact hb (funext h)
    exact Matrix.det_eq_zero_of_mulVec_eq_zero_of_mem_nonZeroDivisors hker
      (mem_nonZeroDivisors_iff_ne_zero.mpr hj)
  exact ⟨a, b, ha, hb, hsegr, hker, hdet0⟩

theorem bilinearNOn_id (a : Fin 3 → Ki) :
    bilinearNOn (RingHom.id Ki) a = bilinearN a := by
  ext r j
  simp [bilinearNOn, bilinearN]

theorem plusCarrier_commonPluckerZero_Ki
    (u : Fin 6 → Ki) (hu : u ≠ 0)
    (hQ : ∀ q : Fin 15, D12Certificate.pluckerValue (BplusKi.mulVec u) q = 0) :
    ∃ (a b : Fin 3 → Ki),
      a ≠ 0 ∧ b ≠ 0 ∧
      H.mulVec u = segrVecOn a b ∧
      (bilinearN a).mulVec b = 0 ∧
      MvPolynomial.eval a Fplus = 0 := by
  obtain ⟨a, b, ha, hb, hsegr, hker, hdet0⟩ :=
    plusCarrier_commonPluckerZero_to_determinantalCubic (RingHom.id Ki) u hu
      (by
        intro q
        simpa [Matrix.map_id] using hQ q)
  refine ⟨a, b, ha, hb, ?_, ?_, ?_⟩
  · simpa [Matrix.map_id] using hsegr
  · simpa [bilinearNOn_id] using hker
  · rw [eval_Fplus_eq_det, ← bilinearNOn_id]
    exact hdet0

end V14Formalization.D12SigmaPlusSegreCore
