import V14Formalization.GeometricV14Carrier
import Mathlib.RingTheory.Polynomial.Basic
import Mathlib.LinearAlgebra.Charpoly.Basic
import Mathlib.FieldTheory.Minpoly.Field

open Polynomial Module LinearMap
open V14Formalization.GeometricV14Carrier

set_option maxHeartbeats 32000000
noncomputable section

/-! ## Residual decomposition of Rlin -/

theorem aeval_Rlin_X6_add_one :
    aeval (Rlin : Module.End k U) ((X : k[X]) ^ 6 + 1) = 0 := by
  have h :
      aeval (Rlin : Module.End k U) ((X : k[X]) ^ 6 + 1) =
        (Rlin : Module.End k U) ^ 6 + LinearMap.id := by
    simp only [map_add, map_pow, map_one, aeval_X, Module.End.one_eq_id]
  rw [h, Rlin_pow_six_eq_neg_id]
  exact neg_add_cancel (LinearMap.id : Module.End k U)

theorem poly_ident_X4_X2 :
    (X ^ 4 - X ^ 2 + 1 : k[X]) - (X ^ 2 - 2) * (X ^ 2 + 1) = 3 := by
  ring

theorem isCoprime_X2p1_X4 :
    IsCoprime ((X : k[X]) ^ 2 + 1) (X ^ 4 - X ^ 2 + 1) := by
  have h3ne : (3 : k) ≠ 0 := by norm_num
  -- Scale the identity 3 = q - (X²-2)p by 1/3
  refine ⟨-C (3 : k)⁻¹ * (X ^ 2 - 2), C (3 : k)⁻¹, ?_⟩
  have hC3 : (3 : k[X]) = C (3 : k) := by
    simp only [map_ofNat]
  calc (-C (3 : k)⁻¹ * (X ^ 2 - 2)) * (X ^ 2 + 1) + C (3 : k)⁻¹ * (X ^ 4 - X ^ 2 + 1)
      = C (3 : k)⁻¹ * ((X ^ 4 - X ^ 2 + 1) - (X ^ 2 - 2) * (X ^ 2 + 1)) := by ring
    _ = C (3 : k)⁻¹ * (3 : k[X]) := by rw [poly_ident_X4_X2]
    _ = C (3 : k)⁻¹ * C (3 : k) := by rw [hC3]
    _ = C ((3 : k)⁻¹ * 3) := by rw [← map_mul]
    _ = C (1 : k) := by rw [inv_mul_cancel₀ h3ne]
    _ = 1 := by simp

theorem residualKer_eq_ker_X2 :
    residualKer =
      LinearMap.ker (aeval (Rlin : Module.End k U) ((X : k[X]) ^ 2 + 1)) := by
  ext u
  have haev :
      aeval (Rlin : Module.End k U) ((X : k[X]) ^ 2 + 1) =
        (Rlin : Module.End k U) ^ 2 + LinearMap.id := by
    simp only [map_add, map_pow, map_one, aeval_X, Module.End.one_eq_id]
  constructor
  · intro hu
    have : Rlin (Rlin u) + u = 0 := (mem_residualKer_iff).mp hu
    rw [LinearMap.mem_ker, haev, LinearMap.add_apply, pow_two, Module.End.mul_apply]
    exact this
  · intro hu
    rw [LinearMap.mem_ker, haev, LinearMap.add_apply, pow_two, Module.End.mul_apply] at hu
    exact (mem_residualKer_iff).mpr hu

abbrev Wker : Submodule k U :=
  LinearMap.ker (aeval (Rlin : Module.End k U) ((X : k[X]) ^ 4 - X ^ 2 + 1))

theorem residualKer_sup_Wker_eq_top :
    residualKer ⊔ Wker = (⊤ : Submodule k U) := by
  have hpq := isCoprime_X2p1_X4
  have hsup :=
    Polynomial.sup_ker_aeval_eq_ker_aeval_mul_of_coprime (Rlin : Module.End k U) hpq
  have hmul :
      ((X : k[X]) ^ 2 + 1) * (X ^ 4 - X ^ 2 + 1) = X ^ 6 + 1 :=
    (X6_add_one_factor).symm
  have htop :
      LinearMap.ker (aeval (Rlin : Module.End k U)
        (((X : k[X]) ^ 2 + 1) * (X ^ 4 - X ^ 2 + 1))) = ⊤ := by
    rw [hmul]
    ext u
    simp only [Submodule.mem_top, LinearMap.mem_ker, iff_true]
    exact LinearMap.congr_fun aeval_Rlin_X6_add_one u
  rw [residualKer_eq_ker_X2, hsup, htop]

theorem residualKer_disjoint_Wker : Disjoint residualKer Wker := by
  rw [residualKer_eq_ker_X2]
  exact Polynomial.disjoint_ker_aeval_of_isCoprime _ isCoprime_X2p1_X4

theorem isCompl_residualKer_Wker : IsCompl residualKer Wker := by
  refine ⟨residualKer_disjoint_Wker, ?_⟩
  exact codisjoint_iff.mpr residualKer_sup_Wker_eq_top

#print axioms aeval_Rlin_X6_add_one
#print axioms isCoprime_X2p1_X4
#print axioms residualKer_eq_ker_X2
#print axioms isCompl_residualKer_Wker

#print axioms aeval_Rlin_X6_add_one
#print axioms isCoprime_X2p1_X4
#print axioms residualKer_eq_ker_X2

/-! ## Irreducibility of X⁴ − X² + 1 over k -/

theorem not_dvd_X2p1_X4 :
    ¬ ((X : k[X]) ^ 2 + 1) ∣ (X ^ 4 - X ^ 2 + 1) := by
  intro h
  have hmod :
      (X ^ 4 - X ^ 2 + 1 : k[X]) = (X ^ 2 - 2) * (X ^ 2 + 1) + 3 := by ring
  have h3ne : (3 : k[X]) ≠ 0 := by
    intro h0
    have hc := congrArg (coeff · 0) h0
    simp at hc
  have hdiv3 : ((X : k[X]) ^ 2 + 1) ∣ (3 : k[X]) := by
    have h' : ((X : k[X]) ^ 2 + 1) ∣ ((X ^ 2 - 2) * (X ^ 2 + 1) + 3) := by
      rwa [← hmod]
    exact (dvd_add_right (dvd_mul_left (X ^ 2 - 2) _)).mp h'
  have hle := natDegree_le_of_dvd hdiv3 h3ne
  have hdeg2 : ((X : k[X]) ^ 2 + 1).natDegree = 2 := by
    simpa using (natDegree_X_pow_add_C (n := 2) (r := (1 : k)))
  have hdeg3 : ((3 : k[X]).natDegree) = 0 := natDegree_natCast 3
  omega

theorem no_root_X4_sub_X2_add_one (α : k) :
    ¬ IsRoot ((X : k[X]) ^ 4 - X ^ 2 + 1) α := by
  intro h
  have ha : aeval α ((X : k[X]) ^ 4 - X ^ 2 + 1) = 0 := by
    simpa [IsRoot.def] using h
  have h6 : α ^ 6 + 1 = 0 := by
    have : aeval α ((X : k[X]) ^ 6 + 1) = 0 := by
      rw [X6_add_one_factor, map_mul, ha, mul_zero]
    simpa [map_add, map_pow, map_one, aeval_X] using this
  exact no_sixth_root_neg_one (eq_neg_of_add_eq_zero_left h6)

/-- Any monic degree-2 divisor of `X⁴−X²+1` would divide `X⁶+1`, hence equal `X²+1`
by `monic_quad_dvd_X6_eq_X2_add_one`, which does not divide `X⁴−X²+1`. -/
theorem not_exists_monic_quad_dvd_X4 :
    ¬ ∃ f : k[X], f.Monic ∧ f.natDegree = 2 ∧ f ∣ (X ^ 4 - X ^ 2 + 1) := by
  rintro ⟨f, hmon, hdeg, hdiv⟩
  have hdiv6 : f ∣ ((X : k[X]) ^ 6 + 1) := by
    rw [X6_add_one_factor]
    exact hdiv.trans (dvd_mul_left _ _)
  have hf := monic_quad_dvd_X6_eq_X2_add_one f hmon hdeg hdiv6
  rw [hf] at hdiv
  exact not_dvd_X2p1_X4 hdiv

theorem irreducible_X4_sub_X2_add_one :
    Irreducible ((X : k[X]) ^ 4 - X ^ 2 + 1) := by
  classical
  have hmon : ((X : k[X]) ^ 4 - X ^ 2 + 1).Monic := monic_X4_sub_X2_add_one
  have hdeg4 : ((X : k[X]) ^ 4 - X ^ 2 + 1).natDegree = 4 :=
    natDegree_X4_sub_X2_add_one
  refine (irreducible_iff_natDegree_pos_and_irreducible_of_monic hmon).2 ?_
  -- Fallback manual Irreducible constructor
  refine ⟨?_, ?_⟩
  · -- not unit
    intro hu
    have : ((X : k[X]) ^ 4 - X ^ 2 + 1).natDegree = 0 :=
      natDegree_eq_zero_of_isUnit hu
    omega
  · intro f g hfg
    have hf0 : f ≠ 0 := fun hz => by
      rw [hz, zero_mul] at hfg
      exact hmon.ne_zero hfg.symm
    have hg0 : g ≠ 0 := fun hz => by
      rw [hz, mul_zero] at hfg
      exact hmon.ne_zero hfg.symm
    have hsum : f.natDegree + g.natDegree = 4 := by
      have := natDegree_mul hf0 hg0
      rwa [← hfg, hdeg4] at this
    -- WLOG deg f ≤ deg g, so deg f ≤ 2
    wlog hle : f.natDegree ≤ g.natDegree generalizing f g with H
    · rcases H g f (by rw [mul_comm, hfg]) hg0 hf0 (by omega) (le_of_not_ge hle) with h | h
      · exact Or.inr h
      · exact Or.inl h
    have hf_le2 : f.natDegree ≤ 2 := by omega
    match hf : f.natDegree with
    | 0 =>
      left
      exact isUnit_iff_degree_eq_zero.2 (degree_eq_zero_of_natDegree_eq_zero hf)
    | 1 =>
      -- has a root
      have hdeg1 : degree f = 1 := by
        rw [degree_eq_natDegree hf0, hf]; simp
      obtain ⟨α, hα⟩ := exists_root_of_degree_eq_one hdeg1
      have : IsRoot ((X : k[X]) ^ 4 - X ^ 2 + 1) α := by
        rw [← hfg]; exact hα.dvd hfg ▸ ?_
        -- IsRoot mul
        exact isRoot_mul_iff.2 (Or.inl hα) -- may not exist
      -- simpler:
      have hroot : aeval α ((X : k[X]) ^ 4 - X ^ 2 + 1) = 0 := by
        rw [← hfg, map_mul]
        have : aeval α f = 0 := by simpa [IsRoot.def] using hα
        rw [this, zero_mul]
      exact False.elim (no_root_X4_sub_X2_add_one α (by simpa [IsRoot.def] using hroot))
    | 2 =>
      -- monic associate of f has deg 2 and divides
      let c := f.leadingCoeff
      have hc0 : c ≠ 0 := leadingCoeff_ne_zero.2 hf0
      let f' : k[X] := C c⁻¹ * f
      have hf'mon : f'.Monic := by
        dsimp [f']
        rw [Monic.def, leadingCoeff_C_mul, inv_mul_cancel₀ hc0]
      have hf'deg : f'.natDegree = 2 := by
        dsimp [f']
        rw [natDegree_C_mul (inv_ne_zero hc0), hf]
      have hf'div : f' ∣ (X ^ 4 - X ^ 2 + 1 : k[X]) := by
        dsimp [f']
        refine ⟨C c * g, ?_⟩
        calc C c⁻¹ * f * (C c * g)
            = (C c⁻¹ * C c) * (f * g) := by ring
          _ = C (c⁻¹ * c) * (f * g) := by rw [← map_mul]
          _ = C 1 * (f * g) := by rw [inv_mul_cancel₀ hc0]
          _ = f * g := by simp
          _ = X ^ 4 - X ^ 2 + 1 := hfg
      exact False.elim (not_exists_monic_quad_dvd_X4 ⟨f', hf'mon, hf'deg, hf'div⟩)
    | n + 3 =>
      omega

#print axioms not_dvd_X2p1_X4
#print axioms no_root_X4_sub_X2_add_one
#print axioms not_exists_monic_quad_dvd_X4
#print axioms irreducible_X4_sub_X2_add_one
