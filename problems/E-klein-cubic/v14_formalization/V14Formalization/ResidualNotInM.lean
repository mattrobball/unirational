/-
Residual pure-M exclusion.

GREEN:
* F₂₃ pureMWitness_ne_zero, residual_mixed_F23
* reduceCyclo : ℤ[ζ₁₁] → F₂₃ (ζ ↦ 2), Phi11_eval_two_F23
* chi10'_sum_eq_zero
* tDiff_eq_zero_of_pureM, residual_support_eq_residualKer
* residual_plucker_projectorM_ne_of_not_pureM (cross ≠ 42)

OPEN model match for pure-M_K:
  pure-M_K ⇒ tDiff=0 ⇒ reduce(tDiff)=pureMWitness=0 ⊥ pureMWitness_ne_zero
  needs free S-module Plücker coords of residual type + identification with seal.
  External char-0: residual tDiff ≠ 0 over K (coord0 = 66+132ζ−22ζ²+… nonzero).
-/
import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Data.Fin.VecNotation
import Mathlib.LinearAlgebra.Dual.Lemmas
import Mathlib.RingTheory.Polynomial.Cyclotomic.Basic
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.Algebra.Field.ZMod
import Mathlib.Algebra.Ring.GeomSum
import Mathlib.Data.Nat.Prime.Defs
import V14Formalization.GeometricV14Carrier
import V14Formalization.Ord11CharacterSum
import V14Formalization.PSLCard

noncomputable section

open BigOperators Polynomial AdjoinRoot

namespace V14Formalization
namespace ResidualNotInM

open GeometricV14Carrier

abbrev F23 := ZMod 23
abbrev V15 := Fin 15 → F23

instance : Fact (Nat.Prime 23) := ⟨by decide⟩

/-! ## F₂₃ residual pure-M certificate -/

def omega : V15 :=
  ![15, 10, 16, 14, 6, 11, 16, 21, 15, 2, 16, 1, 9, 5, 1]

def chiSumOmega : V15 :=
  ![3, 19, 0, 17, 16, 3, 21, 6, 21, 17, 0, 20, 8, 10, 20]

def pureMWitness : V15 :=
  fun p => chiSumOmega p - (20 : F23) * omega p

theorem pureMWitness_zero_eq : pureMWitness 0 = 2 := by decide

theorem pureMWitness_ne_zero : pureMWitness ≠ fun _ => 0 := by
  intro h
  have : pureMWitness 0 = 0 := congrFun h 0
  rw [pureMWitness_zero_eq] at this
  exact absurd this (by decide : (2 : F23) ≠ 0)

def minor01 : F23 :=
  chiSumOmega 0 * omega 1 - chiSumOmega 1 * omega 0

theorem minor01_eq : minor01 = 21 := by decide

theorem minor01_ne_zero : minor01 ≠ 0 := by
  rw [minor01_eq]; decide

theorem residual_mixed_F23 : ∀ α : F23, chiSumOmega ≠ fun p => α * omega p := by
  intro α heq
  have h0 : minor01 = 0 := by
    dsimp [minor01]
    rw [heq]
    ring
  exact minor01_ne_zero h0

/-! ## Ring hom ℤ[ζ₁₁] → F₂₃, ζ ↦ 2 -/

theorem pow_two_eleven_F23 : (2 : F23) ^ 11 = 1 := by decide
theorem two_ne_one_F23 : (2 : F23) ≠ 1 := by decide

theorem geom_sum_two_range11 : ∑ i ∈ Finset.range 11, (2 : F23) ^ i = 0 := by
  have hx : (2 : F23) ≠ 1 := two_ne_one_F23
  have h := geom_sum_eq hx (n := 11)
  rw [h, pow_two_eleven_F23]
  ring

theorem X_pow_sub_one_eq_X_sub_one_mul_Phi11
    (R : Type*) [CommRing R] [IsDomain R] [NeZero (11 : R)] :
    (X : R[X]) ^ 11 - 1 = (X - 1) * cyclotomic 11 R := by
  have h := prod_cyclotomic_eq_X_pow_sub_one (n := 11) (R := R) (by decide : 0 < 11)
  have hdiv : Nat.divisors 11 = {1, 11} := by decide
  rw [hdiv, Finset.prod_insert (by decide : (1 : ℕ) ∉ ({11} : Finset ℕ)),
    Finset.prod_singleton, cyclotomic_one] at h
  exact h.symm

theorem Phi11_eval_two_F23 : eval (2 : F23) (cyclotomic 11 F23) = 0 := by
  haveI : NeZero (11 : F23) := ⟨by decide⟩
  have hfac : (X : F23[X]) ^ 11 - 1 = (X - 1) * cyclotomic 11 F23 :=
    X_pow_sub_one_eq_X_sub_one_mul_Phi11 F23
  have hpow : eval (2 : F23) (X ^ 11 - 1) = 0 := by
    simp [eval_sub, eval_pow, eval_X, eval_one, pow_two_eleven_F23]
  have heval := congrArg (eval (2 : F23)) hfac
  rw [hpow, eval_mul, eval_sub, eval_X, eval_one] at heval
  have h2 : (2 : F23) - 1 ≠ 0 := by decide
  exact (mul_eq_zero.mp heval.symm).resolve_left h2

/-- Ring hom ℤ[ζ₁₁] → F₂₃ sending ζ ↦ 2. -/
noncomputable def reduceCyclo : AdjoinRoot (cyclotomic 11 ℤ) →+* F23 :=
  AdjoinRoot.lift (Int.castRingHom F23) (2 : F23) (by
    have hmap : (cyclotomic 11 ℤ).map (Int.castRingHom F23) = cyclotomic 11 F23 :=
      Polynomial.map_cyclotomic_int 11 F23
    rw [eval₂_eq_eval_map, hmap, Phi11_eval_two_F23])

theorem reduceCyclo_root :
    reduceCyclo (AdjoinRoot.root (cyclotomic 11 ℤ)) = 2 := by
  simp [reduceCyclo, AdjoinRoot.lift_root]

theorem reduceCyclo_zero : reduceCyclo 0 = 0 := map_zero reduceCyclo

/-! ## ∑ χ₁₀' = 0 over PSL -/

private theorem sum_ite_pslOrd (n : ℕ) (c : ℤ) :
    (∑ A : SLG, if PSLCard.pslOrd A = n then c else (0 : ℤ)) =
      c * PSLCard.slCardOrder n := by
  classical
  simp only [Finset.sum_ite, Finset.sum_const, nsmul_eq_mul,
    PSLCard.slCardOrder]
  ring

private theorem chi10Int_eq_order_contributions (A : SLG) :
    PSLCard.chi10Int (PSLCard.pslOrd A) =
      (if PSLCard.pslOrd A = 1 then (10 : ℤ) else 0) +
      (if PSLCard.pslOrd A = 2 then 2 else 0) +
      (if PSLCard.pslOrd A = 3 then 1 else 0) +
      (if PSLCard.pslOrd A = 6 then -1 else 0) +
      (if PSLCard.pslOrd A = 11 then -1 else 0) := by
  by_cases h1 : PSLCard.pslOrd A = 1
  · simp [h1, PSLCard.chi10Int]
  by_cases h2 : PSLCard.pslOrd A = 2
  · simp [h1, h2, PSLCard.chi10Int]
  by_cases h3 : PSLCard.pslOrd A = 3
  · simp [h1, h2, h3, PSLCard.chi10Int]
  by_cases h5 : PSLCard.pslOrd A = 5
  · simp [h1, h2, h3, h5, PSLCard.chi10Int]
  by_cases h6 : PSLCard.pslOrd A = 6
  · simp [h1, h2, h3, h5, h6, PSLCard.chi10Int]
  by_cases h11 : PSLCard.pslOrd A = 11
  · simp [h1, h2, h3, h5, h6, h11, PSLCard.chi10Int]
  · have hchi : PSLCard.chi10Int (PSLCard.pslOrd A) = 0 := by
      unfold PSLCard.chi10Int
      split_ifs <;> omega
    simp [h1, h2, h3, h6, h11, hchi]

private theorem sum_chi10Int_over_sl :
    (∑ A : SLG, PSLCard.chi10Int (PSLCard.pslOrd A)) = 0 := by
  simp_rw [chi10Int_eq_order_contributions]
  simp only [Finset.sum_add_distrib, sum_ite_pslOrd,
    PSLCard.slCardOrder_one, PSLCard.slCardOrder_two,
    PSLCard.slCardOrder_three, PSLCard.slCardOrder_six,
    PSLCard.slCardOrder_eleven]
  norm_num

theorem chi10'_sum_eq_zero :
    (∑ g : PSL2F11, chi10' g) = (0 : k) := by
  classical
  have hterm (g : PSL2F11) :
      chi10' g = ((PSLCard.chi10Int (orderOf g) : ℤ) : k) :=
    chi10'_eq_chi10Int g
  rw [Fintype.sum_congr _ _ hterm]
  have hcast :
      (∑ g : PSL2F11, ((PSLCard.chi10Int (orderOf g) : ℤ) : k)) =
        ((∑ g : PSL2F11, PSLCard.chi10Int (orderOf g) : ℤ) : k) := by
    simp only [Int.cast_sum]
  rw [hcast]
  have hint : (∑ g : PSL2F11, PSLCard.chi10Int (orderOf g) : ℤ) = 0 := by
    have hdouble := PSLCard.sum_comp_mk
      (fun g : PSL2F11 ↦ PSLCard.chi10Int (orderOf g))
    simp_rw [PSLCard.orderOf_mk_eq_pslOrd] at hdouble
    rw [sum_chi10Int_over_sl] at hdouble
    simp only [two_nsmul] at hdouble
    exact add_self_eq_zero.mp hdouble.symm
  rw [hint]
  norm_num

/-! ## Residual tDiff and support uniqueness over K -/

def tDiff (u : U) : Lambda2U :=
  chiSumOp (GeometricFanoCarrier.pureWedge u (Rlin u)) -
    (66 : k) • GeometricFanoCarrier.pureWedge u (Rlin u)

theorem tDiff_eq_zero_of_pureM {u : U}
    (hfix : projectorM (GeometricFanoCarrier.pureWedge u (Rlin u)) =
      GeometricFanoCarrier.pureWedge u (Rlin u)) :
    tDiff u = 0 := by
  unfold tDiff
  rw [chiSumOp_eq_sixty_six_of_mem_Mfix hfix, sub_self]

theorem residual_support_eq_residualKer {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (_hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u)) :
    (k ∙ u) ⊔ (k ∙ Rlin u) = residualKer := by
  have hI := residual_pair_independent hu0 hR2
  have hRpure :
      GeometricFanoCarrier.pureWedge (Rlin u) (Rlin (Rlin u)) =
        (1 : k) • GeometricFanoCarrier.pureWedge u (Rlin u) := by
    have hR2u : Rlin (Rlin u) = -u :=
      residualKer_R2 (mem_residualKer_iff.mpr hR2)
    calc GeometricFanoCarrier.pureWedge (Rlin u) (Rlin (Rlin u))
        = GeometricFanoCarrier.pureWedge (Rlin u) (-u) := by rw [hR2u]
      _ = GeometricFanoCarrier.pureWedge (Rlin u) ((-1 : k) • u) := by
          rw [← neg_one_smul k u]
      _ = (-1 : k) • GeometricFanoCarrier.pureWedge (Rlin u) u :=
          pureWedge_smul_right (-1) (Rlin u) u
      _ = (-1 : k) • (-GeometricFanoCarrier.pureWedge u (Rlin u)) := by
          rw [pureWedge_swap]
      _ = GeometricFanoCarrier.pureWedge u (Rlin u) := by
          rw [smul_neg, neg_smul, one_smul, neg_neg]
      _ = (1 : k) • GeometricFanoCarrier.pureWedge u (Rlin u) :=
          (one_smul k _).symm
  exact support_eq_residualKer_of_R_character hI one_ne_zero hRpure

/-! ## Free S-model residual-type tDiff obstruction

Residual Plücker of residualKer in the even-Weil model has coordinates in
S = ℤ[ζ₁₁,1/11]. After clearing the denominator 11, the character-sum tDiff =
Tω − 66ω has integer cyclotomic coordinates. Coordinate 0 is sealedTDiff0 below.
It is nonzero over K (power basis / minpoly degree), and reduces to
pureMWitness 0 = 2 along ζ ↦ 2.

Pure-M residual type means tDiff vanishes for residualKer pure wedge, hence all
free S-model coordinates vanish, including sealedTDiff0 — contradiction.
-/

open V14Formalization.WeilRep (ζ Φ11 Φ11_natDegree Φ11_monic minpoly_ζ)

/-- Free S-model residual-type tDiff, Plücker coordinate 0 (scale ×11). -/
def residualTypeTDiffCoord0Coeffs : Fin 10 → ℤ :=
  ![726, 1452, -242, 1210, 968, -242, 1694, 484, 242, 1694]

noncomputable def residualTypeTDiffCoord0 : k :=
  ∑ i : Fin 10, (residualTypeTDiffCoord0Coeffs i : k) * ζ ^ (i.val)

/-- residualTypeTDiffCoord0 ≠ 0 over K = ℚ(ζ₁₁). -/
theorem residualTypeTDiffCoord0_ne : residualTypeTDiffCoord0 ≠ 0 := by
  intro h
  let p : ℚ[X] :=
    ∑ i : Fin 10, C (↑(residualTypeTDiffCoord0Coeffs i) : ℚ) * X ^ (i.val)
  have hp : aeval ζ p = residualTypeTDiffCoord0 := by
    unfold residualTypeTDiffCoord0 p
    simp only [map_sum, map_mul, aeval_X_pow, map_intCast]
  have hdiv : Φ11 ∣ p := by
    have := minpoly.dvd ℚ ζ (by rw [hp]; exact h)
    rwa [minpoly_ζ] at this
  have hdeg : p.natDegree ≤ 9 := by
    refine (natDegree_sum_le _ _).trans ?_
    refine Finset.sup_le fun i _ => ?_
    exact (natDegree_C_mul_X_pow_le (↑(residualTypeTDiffCoord0Coeffs i) : ℚ) i.val).trans
      (Nat.le_of_lt_succ i.isLt)
  have hp0 : p = 0 := by
    obtain ⟨q, hq⟩ := hdiv
    have hΦ : Φ11.natDegree = 10 := Φ11_natDegree
    by_cases hq0 : q = 0
    · simpa [hq0] using hq
    · have hsumdeg := natDegree_mul Φ11_monic.ne_zero hq0
      have : natDegree (Φ11 * q) = 10 + q.natDegree := by
        rw [hsumdeg, hΦ]
      have hle' : 10 + q.natDegree ≤ 9 := by
        rw [← this, ← hq]; exact hdeg
      omega
  have hconst : p.coeff 0 = 726 := by
    change (∑ i : Fin 10,
        C (↑(residualTypeTDiffCoord0Coeffs i) : ℚ) * X ^ (i.val)).coeff 0 = 726
    rw [finsetSum_coeff, Finset.sum_eq_single (0 : Fin 10)]
    · rw [coeff_C_mul_X_pow]
      simp [residualTypeTDiffCoord0Coeffs]
    · intro i _ hi
      rw [coeff_C_mul_X_pow]
      have hne : 0 ≠ i.val := fun he => hi (Fin.ext he.symm)
      rw [if_neg hne]
    · simp
  have : (726 : ℚ) = 0 := by
    have hc := congrArg (Polynomial.coeff · 0) hp0
    simp only [hconst, coeff_zero] at hc
    exact hc
  exact (by norm_num : (726 : ℚ) ≠ 0) this

/-- Reduce of residualTypeTDiffCoord0 along ζ ↦ 2 equals pureMWitness 0 = 2. -/
theorem residualTypeTDiffCoord0_reduce :
    (∑ i : Fin 10, (residualTypeTDiffCoord0Coeffs i : F23) * (2 : F23) ^ i.val) =
      (2 : F23) := by decide

/-! ## Residual ∉ Msub: pure-M exclusion via free S-model -/

/-- If residualTypeTDiffCoord0 = 0 in K, its F₂₃ reduction is 0. -/
theorem residualTypeTDiffCoord0_eq_zero_implies_reduce_zero
    (h : residualTypeTDiffCoord0 = 0) :
    (∑ i : Fin 10, (residualTypeTDiffCoord0Coeffs i : F23) * (2 : F23) ^ i.val) =
      (0 : F23) := by
  -- residualTypeTDiffCoord0 = ∑ a_i ζ^i = 0 ⇒ Φ11 ∣ p ⇒ p = 0 (deg < 10)
  -- ⇒ all a_i = 0 ⇒ ∑ a_i 2^i = 0 in F23
  let p : ℚ[X] :=
    ∑ i : Fin 10, C (↑(residualTypeTDiffCoord0Coeffs i) : ℚ) * X ^ (i.val)
  have hp : aeval ζ p = residualTypeTDiffCoord0 := by
    unfold residualTypeTDiffCoord0 p
    simp only [map_sum, map_mul, aeval_X_pow, map_intCast]
  have hdiv : Φ11 ∣ p := by
    have := minpoly.dvd ℚ ζ (by rw [hp]; exact h)
    rwa [minpoly_ζ] at this
  have hdeg : p.natDegree ≤ 9 := by
    refine (natDegree_sum_le _ _).trans ?_
    refine Finset.sup_le fun i _ => ?_
    exact (natDegree_C_mul_X_pow_le (↑(residualTypeTDiffCoord0Coeffs i) : ℚ) i.val).trans
      (Nat.le_of_lt_succ i.isLt)
  have hp0 : p = 0 := by
    obtain ⟨q, hq⟩ := hdiv
    have hΦ : Φ11.natDegree = 10 := Φ11_natDegree
    by_cases hq0 : q = 0
    · simpa [hq0] using hq
    · have hsumdeg := natDegree_mul Φ11_monic.ne_zero hq0
      have : natDegree (Φ11 * q) = 10 + q.natDegree := by
        rw [hsumdeg, hΦ]
      have hle' : 10 + q.natDegree ≤ 9 := by
        rw [← this, ← hq]; exact hdeg
      omega
  -- all coeffs of p are 0
  have hcoeffs : ∀ i : Fin 10, residualTypeTDiffCoord0Coeffs i = 0 := by
    intro i
    have hc := congrArg (fun q : ℚ[X] => q.coeff i.val) hp0
    simp only [coeff_zero] at hc
    -- p.coeff i.val = residualTypeTDiffCoord0Coeffs i
    have hci : p.coeff i.val = (residualTypeTDiffCoord0Coeffs i : ℚ) := by
      change (∑ j : Fin 10,
          C (↑(residualTypeTDiffCoord0Coeffs j) : ℚ) * X ^ (j.val)).coeff i.val =
        (residualTypeTDiffCoord0Coeffs i : ℚ)
      rw [finsetSum_coeff, Finset.sum_eq_single i]
      · rw [coeff_C_mul_X_pow]; simp
      · intro j _ hj
        rw [coeff_C_mul_X_pow]
        have hne : i.val ≠ j.val := fun he => hj (Fin.ext he.symm)
        rw [if_neg hne]
      · simp
    have : (residualTypeTDiffCoord0Coeffs i : ℚ) = 0 := by
      rw [← hci]; exact hc
    exact_mod_cast this
  -- sum a_i * 2^i = 0
  simp only [hcoeffs, Int.cast_zero, zero_mul, Finset.sum_const_zero]

/-! ## Honest boundary for the residual free-model comparison

The finite-field certificate and the characteristic-zero nonvanishing theorem
above are kernel-checked.  What is not yet formalized is the comparison saying
that the sealed cyclotomic coordinate is the coordinate of `tDiff u` for an
arbitrary residual generator `u`.  Keeping that comparison as an explicit
hypothesis prevents the computational certificate from being promoted to an
unconditional geometric theorem.
-/

/-- The exact missing comparison between the Lean residual vector and the
sealed free cyclotomic model.  This is a proposition, not an axiom: downstream
results must accept a proof of it explicitly. -/
def HasResidualFreeModelMatch : Prop :=
  ∀ {u : U},
    u ≠ 0 →
    Rlin (Rlin u) + u = 0 →
    Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u) →
    tDiff u = 0 →
    residualTypeTDiffCoord0 = 0

/-- With the free-model comparison supplied, pure-M forces the sealed
coordinate to vanish. -/
theorem residualTypeTDiffCoord0_eq_zero_of_pureM_of_model_match
    (hmodel : HasResidualFreeModelMatch) {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (hFix : projectorM (GeometricFanoCarrier.pureWedge u (Rlin u)) =
      GeometricFanoCarrier.pureWedge u (Rlin u)) :
    residualTypeTDiffCoord0 = 0 :=
  hmodel hu0 hR2 hSstab (tDiff_eq_zero_of_pureM hFix)

/-- Conditional pure-M exclusion.  The suffix records the sole missing bridge. -/
theorem not_pureM_residual_of_model_match
    (hmodel : HasResidualFreeModelMatch) {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (hFix : projectorM (GeometricFanoCarrier.pureWedge u (Rlin u)) =
      GeometricFanoCarrier.pureWedge u (Rlin u)) :
    False :=
  residualTypeTDiffCoord0_ne
    (residualTypeTDiffCoord0_eq_zero_of_pureM_of_model_match
      hmodel hu0 hR2 hSstab hFix)

/-- Conditional residual Plücker exclusion from the projector fixed space. -/
theorem residual_plucker_projectorM_ne_of_model_match
    (hmodel : HasResidualFreeModelMatch) {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u)) :
    projectorM (GeometricFanoCarrier.pureWedge u (Rlin u)) ≠
      GeometricFanoCarrier.pureWedge u (Rlin u) :=
  fun h => not_pureM_residual_of_model_match hmodel hu0 hR2 hSstab h

/-- Conditional residual Plücker exclusion from `Msub`. -/
theorem residual_plucker_not_mem_Msub_of_model_match
    (hmodel : HasResidualFreeModelMatch) {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u)) :
    GeometricFanoCarrier.pureWedge u (Rlin u) ∉ Msub := by
  intro hM
  have hfix : projectorM (GeometricFanoCarrier.pureWedge u (Rlin u)) =
      GeometricFanoCarrier.pureWedge u (Rlin u) :=
    (mem_Mfix_iff (v := GeometricFanoCarrier.pureWedge u (Rlin u))).mp
      (by rwa [← Mfix_eq_Msub] at hM)
  exact residual_plucker_projectorM_ne_of_model_match
    hmodel hu0 hR2 hSstab hfix

/-! ## D₁₂ character-piece boundary

This is the base-change-stable route to the final M-cut exclusion.  The
coordinate certificate proving this proposition is developed separately; no
free-model comparison is involved.
-/

/-- The two scalar characters of each generator of the dihedral centralizer. -/
def d12Sign (negative : Bool) : k :=
  if negative then -1 else 1

/-- Every decomposable vector in a joint ±1 character piece of the M-cut is
zero.  This proposition is the exact output expected from the explicit four
piece coordinate certificate. -/
def D12CharacterPluckerEmpty : Prop :=
  ∀ (rotNegative reflNegative : Bool) (u v : U),
    GeometricFanoCarrier.pureWedge u v ∈ Msub →
    ambientAct (CentralizerN.rotGen : PSL2F11)
        (GeometricFanoCarrier.pureWedge u v) =
      d12Sign rotNegative • GeometricFanoCarrier.pureWedge u v →
    ambientAct (CentralizerN.reflGen : PSL2F11)
        (GeometricFanoCarrier.pureWedge u v) =
      d12Sign reflNegative • GeometricFanoCarrier.pureWedge u v →
    GeometricFanoCarrier.pureWedge u v = 0

/-- The trivial D₁₂ character piece excludes the residual Plücker vector from
`Msub`.  Once `D12CharacterPluckerEmpty` is proved by coordinates, this
replaces the K-only free-model route. -/
theorem residual_plucker_not_mem_Msub_of_d12
    (hD12 : D12CharacterPluckerEmpty) {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u)) :
    GeometricFanoCarrier.pureWedge u (Rlin u) ∉ Msub := by
  intro hM
  have hfixed := residual_plucker_N_vec_fixed hu0 hR2 hSstab
  have hzero := hD12 false false u (Rlin u) hM
    (by simpa [d12Sign] using hfixed.1)
    (by simpa [d12Sign] using hfixed.2)
  exact pureWedge_residual_ne_zero hu0 hR2 hzero

/-- Non-pure-M residual exclusion over K (cross ≠ 42·ω). -/
theorem residual_plucker_projectorM_ne_of_not_pureM {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (hnot42 : chiCrossTerm (GeometricFanoCarrier.pureWedge u (Rlin u)) ≠
      (42 : k) • GeometricFanoCarrier.pureWedge u (Rlin u)) :
    projectorM (GeometricFanoCarrier.pureWedge u (Rlin u)) ≠
      GeometricFanoCarrier.pureWedge u (Rlin u) :=
  residual_plucker_projectorM_ne_of_cross_ne_forty_two hu0 hR2 hSstab hnot42

#print axioms residualTypeTDiffCoord0_ne
#print axioms residualTypeTDiffCoord0_reduce
#print axioms pureMWitness_ne_zero
#print axioms residual_mixed_F23
#print axioms reduceCyclo
#print axioms chi10'_sum_eq_zero
#print axioms residual_support_eq_residualKer
#print axioms tDiff_eq_zero_of_pureM
#print axioms residual_plucker_not_mem_Msub_of_model_match
#print axioms not_pureM_residual_of_model_match
#print axioms residual_plucker_not_mem_Msub_of_d12

end ResidualNotInM
end V14Formalization
