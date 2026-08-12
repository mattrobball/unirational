/-
Centralizer N = C_G(σ) of the standard involution in PSL(2, F₁₁)
has order 12 and is isomorphic to DihedralGroup 6.
-/
import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup
import Mathlib.LinearAlgebra.Matrix.ProjectiveSpecialLinearGroup
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Field.ZMod
import Mathlib.Data.Nat.Prime.Defs
import Mathlib.GroupTheory.SpecificGroups.Dihedral
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Algebra.Group.Subgroup.Finite
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.GroupTheory.Subgroup.Centralizer

open scoped MatrixGroups
open Matrix Matrix.SpecialLinearGroup

noncomputable section

namespace V14Formalization
namespace CentralizerN

instance fact_prime_eleven' : Fact (Nat.Prime 11) := ⟨Nat.prime_eleven⟩

abbrev F := ZMod 11
abbrev SLG := SpecialLinearGroup (Fin 2) F
abbrev PSL2F11 := PSL(2, F)

def Smat : SLG := ⟨!![0, -1; 1, 0], by simp [Matrix.det_fin_two_of]⟩
def sigma : PSL2F11 := QuotientGroup.mk Smat

def Circle1 := { p : F × F // p.1 ^ 2 + p.2 ^ 2 = 1 }
def CircleM1 := { p : F × F // p.1 ^ 2 + p.2 ^ 2 = -1 }

instance : Fintype Circle1 :=
  Fintype.subtype ((Finset.univ : Finset (F × F)).filter fun p => p.1 ^ 2 + p.2 ^ 2 = 1)
    (by intro; simp)
instance : Fintype CircleM1 :=
  Fintype.subtype ((Finset.univ : Finset (F × F)).filter fun p => p.1 ^ 2 + p.2 ^ 2 = -1)
    (by intro; simp)

theorem card_Circle1 : Fintype.card Circle1 = 12 := by
  unfold Circle1; rw [Fintype.card_subtype]; decide

theorem card_CircleM1 : Fintype.card CircleM1 = 12 := by
  unfold CircleM1; rw [Fintype.card_subtype]; decide

def mkRot (p : Circle1) : SLG :=
  ⟨!![p.val.1, p.val.2; -p.val.2, p.val.1], by
    simp [Matrix.det_fin_two_of]; simpa [pow_two] using p.property⟩

def mkRefl (p : CircleM1) : SLG :=
  ⟨!![p.val.1, p.val.2; p.val.2, -p.val.1], by
    simp [Matrix.det_fin_two_of]
    have h' : p.val.1 * p.val.1 + p.val.2 * p.val.2 = -1 := by
      simpa [pow_two] using p.property
    calc -(p.val.1 * p.val.1) - p.val.2 * p.val.2
        = -(p.val.1 * p.val.1 + p.val.2 * p.val.2) := by ring
      _ = -(-1) := by rw [h']
      _ = 1 := by ring⟩

lemma mkRot_mul_S (p : Circle1) : mkRot p * Smat = Smat * mkRot p := by
  apply Subtype.ext
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [mkRot, Smat, Matrix.mul_apply, Fin.sum_univ_two, SpecialLinearGroup.coe_mul]

def negI : SLG := ⟨-1, by simp [det_neg, Fintype.card_fin, pow_two]⟩

lemma mk_negI : (QuotientGroup.mk negI : PSL2F11) = 1 := by
  apply (QuotientGroup.eq_one_iff _).mpr
  rw [mem_center_iff]
  refine ⟨(-1 : F), by decide, ?_⟩
  ext i j
  simp [negI, scalar, diagonal, Matrix.one_apply, Matrix.neg_apply]
  split_ifs <;> ring

def negS : SLG := negI * Smat

lemma mk_negS : (QuotientGroup.mk negS : PSL2F11) = sigma := by
  simp [negS, sigma, QuotientGroup.mk_mul, mk_negI]

lemma coe_negS : negS.1 = -Smat.1 := by
  simp [negS, negI, SpecialLinearGroup.coe_mul]

lemma mkRefl_mul_S (p : CircleM1) : mkRefl p * Smat = negS * mkRefl p := by
  apply Subtype.ext
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [mkRefl, Smat, coe_negS, Matrix.mul_apply, Fin.sum_univ_two,
      SpecialLinearGroup.coe_mul, Matrix.neg_apply]

theorem rot_mem (p : Circle1) :
    QuotientGroup.mk (mkRot p) ∈ Subgroup.centralizer ({sigma} : Set PSL2F11) := by
  rw [Subgroup.mem_centralizer_singleton_iff]
  change (QuotientGroup.mk (mkRot p) : PSL2F11) * QuotientGroup.mk Smat =
    QuotientGroup.mk Smat * QuotientGroup.mk (mkRot p)
  rw [← QuotientGroup.mk_mul, ← QuotientGroup.mk_mul, mkRot_mul_S]

theorem refl_mem (p : CircleM1) :
    QuotientGroup.mk (mkRefl p) ∈ Subgroup.centralizer ({sigma} : Set PSL2F11) := by
  rw [Subgroup.mem_centralizer_singleton_iff]
  change (QuotientGroup.mk (mkRefl p) : PSL2F11) * sigma =
    sigma * QuotientGroup.mk (mkRefl p)
  calc (QuotientGroup.mk (mkRefl p) : PSL2F11) * sigma
      = QuotientGroup.mk (mkRefl p * Smat) := by simp only [sigma, ← QuotientGroup.mk_mul]
    _ = QuotientGroup.mk (negS * mkRefl p) := by rw [mkRefl_mul_S]
    _ = QuotientGroup.mk negS * QuotientGroup.mk (mkRefl p) := by rw [QuotientGroup.mk_mul]
    _ = sigma * QuotientGroup.mk (mkRefl p) := by rw [mk_negS]

def liftsToN : Circle1 ⊕ CircleM1 → Subgroup.centralizer ({sigma} : Set PSL2F11)
  | .inl p => ⟨QuotientGroup.mk (mkRot p), rot_mem p⟩
  | .inr p => ⟨QuotientGroup.mk (mkRefl p), refl_mem p⟩

lemma sq_eq_one_cases (r : F) (hr : r ^ 2 = 1) : r = 1 ∨ r = -1 := by
  have fac : (r - 1) * (r + 1) = 0 := by
    have t : r ^ 2 - 1 = 0 := by rw [hr, sub_self]
    convert t using 1; ring
  rcases mul_eq_zero.mp fac with h | h
  · left; exact sub_eq_zero.mp h
  · right; exact eq_neg_of_add_eq_zero_left h

/-- Matrix form of centralizer condition: A.1 * S = (scalar r) * (S * A.1). -/
lemma exists_scalar_comm (A : SLG)
    (hA : (QuotientGroup.mk A : PSL2F11) ∈ Subgroup.centralizer ({sigma} : Set PSL2F11)) :
    ∃ r : F, r ^ 2 = 1 ∧ A.1 * Smat.1 = scalar (Fin 2) r * (Smat.1 * A.1) := by
  have hcomm : (QuotientGroup.mk (A * Smat) : PSL2F11) =
      QuotientGroup.mk (Smat * A) := by
    have h := (Subgroup.mem_centralizer_singleton_iff).mp hA
    change (QuotientGroup.mk A : PSL2F11) * sigma = sigma * QuotientGroup.mk A at h
    simpa [sigma, ← QuotientGroup.mk_mul] using h
  -- w := A*S*(S*A)⁻¹ is central because mk(A*S)=mk(S*A)
  have hw : A * Smat * (Smat * A)⁻¹ ∈ Subgroup.center SLG := by
    -- (A*S)*(S*A)⁻¹ ∈ center ↔ mk(A*S)=mk(S*A)
    have : (QuotientGroup.mk (A * Smat * (Smat * A)⁻¹) : PSL2F11) = 1 := by
      rw [QuotientGroup.mk_mul, QuotientGroup.mk_inv, hcomm, mul_inv_cancel]
    exact (QuotientGroup.eq_one_iff _).mp this
  obtain ⟨r, hr, hsc⟩ := (mem_center_iff (n := Fin 2) (R := F)).mp hw
  have rsq : r ^ 2 = 1 := by simpa [Fintype.card_fin] using hr
  refine ⟨r, rsq, ?_⟩
  -- A*S = w * (S*A)
  have heq : A * Smat = (A * Smat * (Smat * A)⁻¹) * (Smat * A) := by
    simp [mul_assoc]
  have t : A.1 * Smat.1 =
      (A * Smat * (Smat * A)⁻¹).1 * (Smat.1 * A.1) := by
    have h := congrArg Subtype.val heq
    simpa only [SpecialLinearGroup.coe_mul, SpecialLinearGroup.coe_inv] using h
  have hs : (A * Smat * (Smat * A)⁻¹).1 = scalar (Fin 2) r := hsc.symm
  rwa [hs] at t


theorem exists_rot_or_refl (A : SLG)
    (hA : (QuotientGroup.mk A : PSL2F11) ∈ Subgroup.centralizer ({sigma} : Set PSL2F11)) :
    (∃ p : Circle1, A = mkRot p) ∨ (∃ p : CircleM1, A = mkRefl p) := by
  obtain ⟨r, rsq, hmat⟩ := exists_scalar_comm A hA
  set a := A.1 0 0
  set b := A.1 0 1
  set c := A.1 1 0
  set d := A.1 1 1
  have hAmat : A.1 = !![a, b; c, d] := by ext i j; fin_cases i <;> fin_cases j <;> rfl
  have hdet : a * d - b * c = 1 := by simpa [Matrix.det_fin_two, hAmat] using A.property
  have hL : A.1 * Smat.1 = !![b, -a; d, -c] := by
    rw [hAmat]
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [Smat, Matrix.mul_apply, Fin.sum_univ_two]
  have hSA : Smat.1 * A.1 = !![(-c), (-d); a, b] := by
    rw [hAmat]
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [Smat, Matrix.mul_apply, Fin.sum_univ_two]
  rcases sq_eq_one_cases r rsq with rfl | rfl
  · -- r = 1
    have hs1 : scalar (Fin 2) (1 : F) = (1 : Matrix (Fin 2) (Fin 2) F) := by
      ext i j; simp [scalar, diagonal, Matrix.one_apply]
    have heq : !![b, -a; d, -c] = !![(-c), (-d); a, b] := by
      calc !![b, -a; d, -c] = A.1 * Smat.1 := hL.symm
        _ = scalar (Fin 2) 1 * (Smat.1 * A.1) := hmat
        _ = 1 * (Smat.1 * A.1) := by rw [hs1]
        _ = Smat.1 * A.1 := one_mul _
        _ = !![(-c), (-d); a, b] := hSA
    have hb : b = -c := by simpa using congr_fun (congr_fun heq 0) 0
    have hd : d = a := by
      have h' : -a = -d := by simpa using congr_fun (congr_fun heq 0) 1
      exact (neg_inj.mp h').symm
    have hab : a ^ 2 + b ^ 2 = 1 := by
      have h1 := hdet
      simp only [hb, hd] at h1
      -- h1 : a*a - (-c)*c = 1, hb : b = -c
      have : a * a + b * b = 1 := by
        rw [hb]; convert h1 using 1; ring
      simpa [pow_two] using this
    left
    refine ⟨⟨(a, b), hab⟩, Subtype.ext ?_⟩
    simp [mkRot, hAmat, hb, hd]
  · -- r = -1
    have heq : !![b, -a; d, -c] = !![c, d; -a, -b] := by
      have h1 : !![b, -a; d, -c] = scalar (Fin 2) (-1) * (Smat.1 * A.1) := by
        rw [← hL, hmat]
      have h2 : scalar (Fin 2) (-1 : F) * (Smat.1 * A.1) = -(Smat.1 * A.1) := by
        have hsmul : scalar (Fin 2) (-1 : F) * (Smat.1 * A.1) =
            (-1 : F) • (Smat.1 * A.1) := by
          ext i j
          simp [scalar, diagonal, Matrix.mul_apply, Fin.sum_univ_two, smul_eq_mul]
        rw [hsmul, neg_one_smul]
      have h3 : -(Smat.1 * A.1) = !![c, d; -a, -b] := by
        rw [hSA]
        ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.neg_apply]
      rw [h1, h2, h3]
    have hb : b = c := by simpa using congr_fun (congr_fun heq 0) 0
    have hd : d = -a := by
      have h' : -a = d := by simpa using congr_fun (congr_fun heq 0) 1
      exact h'.symm
    have hab : a ^ 2 + b ^ 2 = -1 := by
      have h1 := hdet
      simp only [hb, hd] at h1
      -- h1 : a*(-a) - c*c = 1, and b = c
      have : a * (-a) - b * b = 1 := by simpa [hb] using h1
      have h2 : -(a * a + b * b) = 1 := by
        convert this using 1; ring
      have h3 : a * a + b * b = -1 := by
        have := congrArg Neg.neg h2; simpa using this
      simpa [pow_two] using h3
    right
    refine ⟨⟨(a, b), hab⟩, Subtype.ext ?_⟩
    simp [mkRefl, hAmat, hb, hd]

theorem liftsToN_surjective : Function.Surjective liftsToN := by
  intro ⟨g, hg⟩
  obtain ⟨A, rfl⟩ := QuotientGroup.mk_surjective g
  rcases exists_rot_or_refl A hg with ⟨p, hp⟩ | ⟨p, hp⟩
  · exact ⟨Sum.inl p, Subtype.ext (by simp [liftsToN, hp])⟩
  · exact ⟨Sum.inr p, Subtype.ext (by simp [liftsToN, hp])⟩


instance : Fintype PSL2F11 := QuotientGroup.fintype _
instance : DecidableEq PSL2F11 := Quotient.decidableEq
instance : Fintype (Subgroup.centralizer ({sigma} : Set PSL2F11)) :=
  Fintype.ofFinite _

def liftMat : Circle1 ⊕ CircleM1 → SLG
  | .inl p => mkRot p
  | .inr p => mkRefl p

lemma liftsToN_val (x : Circle1 ⊕ CircleM1) :
    (liftsToN x).val = QuotientGroup.mk (liftMat x) := by
  cases x <;> rfl

def negLift : Circle1 ⊕ CircleM1 → Circle1 ⊕ CircleM1
  | .inl p => .inl ⟨(-p.val.1, -p.val.2), by simpa [pow_two] using p.property⟩
  | .inr p => .inr ⟨(-p.val.1, -p.val.2), by simpa [pow_two] using p.property⟩

lemma liftMat_negLift (x : Circle1 ⊕ CircleM1) :
    liftMat (negLift x) = negI * liftMat x := by
  cases x with
  | inl p =>
    apply Subtype.ext
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [liftMat, negLift, mkRot, negI, SpecialLinearGroup.coe_mul,
        Matrix.mul_apply, Fin.sum_univ_two]
  | inr p =>
    apply Subtype.ext
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [liftMat, negLift, mkRefl, negI, SpecialLinearGroup.coe_mul,
        Matrix.mul_apply, Fin.sum_univ_two]

lemma liftsToN_negLift (x : Circle1 ⊕ CircleM1) :
    liftsToN (negLift x) = liftsToN x := by
  apply Subtype.ext
  rw [liftsToN_val, liftsToN_val, liftMat_negLift, QuotientGroup.mk_mul, mk_negI, one_mul]

lemma eq_zero_of_eq_neg (x : F) (h : x = -x) : x = 0 := by
  have : (2 : F) * x = 0 := by
    have hx : x + x = x + (-x) := congrArg (fun t => x + t) h
    have hx0 : x + x = 0 := hx.trans (add_neg_cancel x)
    rwa [← two_mul] at hx0
  exact (mul_eq_zero.mp this).resolve_left (by decide)

lemma eq_zero_of_neg_eq (x : F) (h : -x = x) : x = 0 :=
  eq_zero_of_eq_neg x h.symm

lemma negLift_ne (x : Circle1 ⊕ CircleM1) : negLift x ≠ x := by
  intro h
  cases x with
  | inl p =>
    have hp : ((-p.val.1, -p.val.2) : F × F) = p.val :=
      Subtype.ext_iff.mp (Sum.inl.inj h)
    have h1 : p.val.1 = 0 := eq_zero_of_neg_eq _ (congrArg Prod.fst hp)
    have h2 : p.val.2 = 0 := eq_zero_of_neg_eq _ (congrArg Prod.snd hp)
    have : (0:F)^2 + (0:F)^2 = 1 := by simpa [h1, h2] using p.property
    exact absurd this (by decide)
  | inr p =>
    have hp : ((-p.val.1, -p.val.2) : F × F) = p.val :=
      Subtype.ext_iff.mp (Sum.inr.inj h)
    have h1 : p.val.1 = 0 := eq_zero_of_neg_eq _ (congrArg Prod.fst hp)
    have h2 : p.val.2 = 0 := eq_zero_of_neg_eq _ (congrArg Prod.snd hp)
    have : (0:F)^2 + (0:F)^2 = -1 := by simpa [h1, h2] using p.property
    exact absurd this (by decide)

lemma negLift_involutive : Function.Involutive negLift := by
  intro x
  cases x with
  | inl p => simp only [negLift]; congr 1; apply Subtype.ext; simp
  | inr p => simp only [negLift]; congr 1; apply Subtype.ext; simp

lemma center_eq_one_or_negI (A : SLG) (hA : A ∈ Subgroup.center SLG) :
    A = 1 ∨ A = negI := by
  obtain ⟨r, hr, hsc⟩ := (Matrix.SpecialLinearGroup.mem_center_iff (n := Fin 2) (R := F)).mp hA
  have rsq : r ^ 2 = 1 := by simpa [Fintype.card_fin] using hr
  rcases sq_eq_one_cases r rsq with rfl | rfl
  · left
    apply Subtype.ext
    have hs : scalar (Fin 2) (1 : F) = (1 : Matrix (Fin 2) (Fin 2) F) := by
      ext i j; simp [scalar, diagonal, Matrix.one_apply]
    change A.1 = (1 : SLG).1
    rw [← hsc, hs, SpecialLinearGroup.coe_one]
  · right
    apply Subtype.ext
    have hs : scalar (Fin 2) (-1 : F) = (-(1 : Matrix (Fin 2) (Fin 2) F)) := by
      ext i j
      simp [scalar, diagonal, Matrix.one_apply, Matrix.neg_apply]
      split_ifs <;> ring
    change A.1 = negI.1
    rw [← hsc, hs]
    simp [negI]

lemma liftMat_injective : Function.Injective liftMat := by
  intro x y h
  match x, y with
  | .inl p, .inl q =>
    have h00 : p.val.1 = q.val.1 := by
      simpa [liftMat, mkRot] using congrArg (fun M : SLG => M.1 0 0) h
    have h01 : p.val.2 = q.val.2 := by
      simpa [liftMat, mkRot] using congrArg (fun M : SLG => M.1 0 1) h
    exact congrArg Sum.inl (Subtype.ext (Prod.ext h00 h01))
  | .inr p, .inr q =>
    have h00 : p.val.1 = q.val.1 := by
      simpa [liftMat, mkRefl] using congrArg (fun M : SLG => M.1 0 0) h
    have h01 : p.val.2 = q.val.2 := by
      simpa [liftMat, mkRefl] using congrArg (fun M : SLG => M.1 0 1) h
    exact congrArg Sum.inr (Subtype.ext (Prod.ext h00 h01))
  | .inl p, .inr q =>
    have h10 : -p.val.2 = q.val.2 := by
      simpa [liftMat, mkRot, mkRefl] using congrArg (fun M : SLG => M.1 1 0) h
    have h01 : p.val.2 = q.val.2 := by
      simpa [liftMat, mkRot, mkRefl] using congrArg (fun M : SLG => M.1 0 1) h
    have h11 : p.val.1 = -q.val.1 := by
      simpa [liftMat, mkRot, mkRefl] using congrArg (fun M : SLG => M.1 1 1) h
    have h00 : p.val.1 = q.val.1 := by
      simpa [liftMat, mkRot, mkRefl] using congrArg (fun M : SLG => M.1 0 0) h
    have hb0 : p.val.2 = 0 := by
      have : p.val.2 = -p.val.2 := h01.trans h10.symm
      exact eq_zero_of_eq_neg _ this
    have ha0 : p.val.1 = 0 := by
      have : p.val.1 = -p.val.1 := by
        have hq : q.val.1 = -p.val.1 := by
          have := congrArg Neg.neg h11
          simpa using this.symm
        calc p.val.1 = q.val.1 := h00
          _ = -p.val.1 := hq
      exact eq_zero_of_eq_neg _ this
    exact (absurd (by simpa [ha0, hb0, pow_two] using p.property)
      (by decide : ¬((0 : F) + (0 : F) = 1)))
  | .inr p, .inl q =>
    have h10 : p.val.2 = -q.val.2 := by
      simpa [liftMat, mkRot, mkRefl] using congrArg (fun M : SLG => M.1 1 0) h
    have h01 : p.val.2 = q.val.2 := by
      simpa [liftMat, mkRot, mkRefl] using congrArg (fun M : SLG => M.1 0 1) h
    have h00 : p.val.1 = q.val.1 := by
      simpa [liftMat, mkRot, mkRefl] using congrArg (fun M : SLG => M.1 0 0) h
    have h11 : -p.val.1 = q.val.1 := by
      simpa [liftMat, mkRot, mkRefl] using congrArg (fun M : SLG => M.1 1 1) h
    have hb0 : p.val.2 = 0 := by
      have : p.val.2 = -p.val.2 := by
        calc p.val.2 = q.val.2 := h01
          _ = -(-q.val.2) := (neg_neg _).symm
          _ = -p.val.2 := by rw [← h10]
      exact eq_zero_of_eq_neg _ this
    have ha0 : p.val.1 = 0 := by
      have : p.val.1 = -p.val.1 := by
        calc p.val.1 = q.val.1 := h00
          _ = -p.val.1 := h11.symm
      exact eq_zero_of_eq_neg _ this
    exact (absurd (by simpa [ha0, hb0, pow_two] using p.property)
      (by decide : ¬((0 : F) + (0 : F) = -1)))

lemma negI_mem_center : negI ∈ Subgroup.center SLG := by
  rw [Matrix.SpecialLinearGroup.mem_center_iff]
  refine ⟨(-1 : F), by decide, ?_⟩
  ext i j
  simp [negI, scalar, diagonal, Matrix.one_apply, Matrix.neg_apply]
  split_ifs <;> ring

lemma negI_mul_negI : negI * negI = (1 : SLG) := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [negI, SpecialLinearGroup.coe_mul, SpecialLinearGroup.coe_one,
      Matrix.mul_apply, Matrix.one_apply]

lemma liftMat_eq_neg_iff (x y : Circle1 ⊕ CircleM1) :
    liftMat x = negI * liftMat y ↔ x = negLift y := by
  constructor
  · intro h
    apply liftMat_injective
    calc liftMat x = negI * liftMat y := h
      _ = liftMat (negLift y) := (liftMat_negLift y).symm
  · intro h; rw [h, liftMat_negLift]

lemma liftsToN_eq_iff (x y : Circle1 ⊕ CircleM1) :
    liftsToN x = liftsToN y ↔ x = y ∨ x = negLift y := by
  constructor
  · intro h
    have hmk : (QuotientGroup.mk (liftMat x) : PSL2F11) =
        QuotientGroup.mk (liftMat y) := by
      simpa [liftsToN_val] using congrArg Subtype.val h
    have hz : (liftMat x)⁻¹ * liftMat y ∈ Subgroup.center SLG :=
      (QuotientGroup.eq (s := Subgroup.center SLG)).mp hmk
    rcases center_eq_one_or_negI _ hz with h1 | hneg
    · left
      have heq : liftMat x = liftMat y := inv_mul_eq_one.mp h1
      exact liftMat_injective heq
    · right
      have hy : liftMat y = liftMat x * negI := by
        have := congrArg (fun z => liftMat x * z) hneg
        simpa [mul_assoc, mul_inv_cancel] using this
      have hcomm : liftMat y * negI = negI * liftMat y :=
        Subgroup.mem_center_iff.mp negI_mem_center (liftMat y)
      have : liftMat x = negI * liftMat y := by
        calc liftMat x = liftMat x * (1 : SLG) := (mul_one _).symm
          _ = liftMat x * (negI * negI) := by rw [negI_mul_negI]
          _ = (liftMat x * negI) * negI := by simp [mul_assoc]
          _ = liftMat y * negI := by rw [hy]
          _ = negI * liftMat y := hcomm
      exact (liftMat_eq_neg_iff x y).mp this
  · rintro (rfl | h)
    · rfl
    · rw [h, liftsToN_negLift]

lemma fiber_card (y : Subgroup.centralizer ({sigma} : Set PSL2F11)) :
    Fintype.card { x : Circle1 ⊕ CircleM1 // liftsToN x = y } = 2 := by
  classical
  obtain ⟨x0, hx0⟩ := liftsToN_surjective y
  let s : Finset (Circle1 ⊕ CircleM1) := insert x0 {negLift x0}
  have hne : x0 ∉ ({negLift x0} : Finset _) := by
    simp only [Finset.mem_singleton]
    intro h; exact negLift_ne x0 h.symm
  have hs_card : s.card = 2 := by
    simp only [s]
    rw [Finset.card_insert_of_notMem hne, Finset.card_singleton]
  have hmem : ∀ z : Circle1 ⊕ CircleM1, liftsToN z = y ↔ z ∈ s := by
    intro z
    constructor
    · intro hz
      have : liftsToN z = liftsToN x0 := hz.trans hx0.symm
      rcases (liftsToN_eq_iff z x0).mp this with h | h
      · simp [s, h]
      · simp [s, h]
    · intro hz
      simp only [s, Finset.mem_insert, Finset.mem_singleton] at hz
      rcases hz with rfl | rfl
      · exact hx0
      · rw [liftsToN_negLift, hx0]
  let e : { x : Circle1 ⊕ CircleM1 // liftsToN x = y } ≃ { x // x ∈ s } :=
    { toFun := fun z => ⟨z.val, (hmem z.val).mp z.property⟩
      invFun := fun z => ⟨z.val, (hmem z.val).mpr z.property⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  calc Fintype.card { x // liftsToN x = y }
      = Fintype.card { x // x ∈ s } := Fintype.card_congr e
    _ = s.card := Fintype.card_coe s
    _ = 2 := hs_card

theorem centralizer_sigma_card :
    Fintype.card (Subgroup.centralizer ({sigma} : Set PSL2F11)) = 12 := by
  classical
  set N := Subgroup.centralizer ({sigma} : Set PSL2F11)
  have hdom : Fintype.card (Circle1 ⊕ CircleM1) = 24 := by
    rw [Fintype.card_sum, card_Circle1, card_CircleM1]
  have hsig : Fintype.card (Σ y : N, { x // liftsToN x = y }) = 24 := by
    rw [Fintype.card_congr (Equiv.sigmaFiberEquiv liftsToN), hdom]
  have hfib : ∀ y : N, Fintype.card { x // liftsToN x = y } = 2 := fiber_card
  have hsum : Fintype.card (Σ y : N, { x // liftsToN x = y }) = Fintype.card N * 2 := by
    rw [Fintype.card_sigma]
    simp only [hfib, Finset.sum_const, Finset.card_univ, smul_eq_mul, mul_comm]
  have hmul : Fintype.card N * 2 = 24 := by
    calc Fintype.card N * 2 = ∑ _y : N, (2 : ℕ) := by
          rw [Finset.sum_const, Finset.card_univ, smul_eq_mul, mul_comm]
      _ = Fintype.card (Σ y : N, { x // liftsToN x = y }) := by
          rw [Fintype.card_sigma]; simp only [hfib]
      _ = 24 := hsig
  exact Nat.eq_of_mul_eq_mul_right (by decide : 0 < 2) (by
    calc Fintype.card N * 2 = 24 := hmul
      _ = 12 * 2 := by norm_num)


/-- |N| = |DihedralGroup 6| = 12 (structure for Cor 6.1 input 1). -/
theorem centralizer_sigma_card_eq_dihedral :
    Fintype.card (Subgroup.centralizer ({sigma} : Set PSL2F11)) =
      Fintype.card (DihedralGroup 6) := by
  rw [centralizer_sigma_card, DihedralGroup.card]


/-! ## N ≃ DihedralGroup 6 -/

def rotPt : Circle1 := ⟨(3, 5), by decide⟩
def reflPt : CircleM1 := ⟨(1, 3), by decide⟩

def rotGen : Subgroup.centralizer ({sigma} : Set PSL2F11) :=
  liftsToN (.inl rotPt)

def reflGen : Subgroup.centralizer ({sigma} : Set PSL2F11) :=
  liftsToN (.inr reflPt)

lemma mkRot_pow_six : (mkRot rotPt : SLG) ^ 6 = negI := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j
  all_goals
    simp only [pow_succ, pow_zero, SpecialLinearGroup.coe_mul, SpecialLinearGroup.coe_one,
      mkRot, rotPt, negI, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply,
      Matrix.neg_apply, Matrix.of_apply, Matrix.cons_val]
    decide

lemma rotGen_pow_six : rotGen ^ 6 = 1 := by
  apply Subtype.ext
  change (QuotientGroup.mk (mkRot rotPt) : PSL2F11) ^ 6 = 1
  rw [← QuotientGroup.mk_pow]
  exact (QuotientGroup.eq_one_iff _).mpr (by rw [mkRot_pow_six]; exact negI_mem_center)

lemma mkRefl_pow_two : (mkRefl reflPt : SLG) ^ 2 = negI := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j
  all_goals
    simp only [pow_two, SpecialLinearGroup.coe_mul, mkRefl, reflPt, negI,
      Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply, Matrix.neg_apply,
      Matrix.of_apply, Matrix.cons_val]
    decide

lemma reflGen_sq : reflGen ^ 2 = 1 := by
  apply Subtype.ext
  change (QuotientGroup.mk (mkRefl reflPt) : PSL2F11) ^ 2 = 1
  rw [← QuotientGroup.mk_pow]
  exact (QuotientGroup.eq_one_iff _).mpr (by rw [mkRefl_pow_two]; exact negI_mem_center)

lemma reflGen_mul_self : reflGen * reflGen = (1 : _) := by
  simpa [pow_two] using reflGen_sq

lemma mkRefl_conj_mkRot :
    mkRefl reflPt * mkRot rotPt * mkRefl reflPt = negI * (mkRot rotPt)⁻¹ := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j
  all_goals
    simp only [SpecialLinearGroup.coe_mul, SpecialLinearGroup.coe_inv, mkRefl, mkRot,
      reflPt, rotPt, negI, Matrix.mul_apply, Fin.sum_univ_two, Matrix.neg_apply,
      Matrix.of_apply, Matrix.cons_val, Matrix.adjugate_fin_two, Matrix.one_apply]
    decide

lemma reflGen_conj_rotGen : reflGen * rotGen * reflGen = rotGen⁻¹ := by
  apply Subtype.ext
  change (QuotientGroup.mk (mkRefl reflPt) : PSL2F11) *
      QuotientGroup.mk (mkRot rotPt) * QuotientGroup.mk (mkRefl reflPt) =
      (QuotientGroup.mk (mkRot rotPt))⁻¹
  have hL :
      (QuotientGroup.mk (mkRefl reflPt) : PSL2F11) *
        QuotientGroup.mk (mkRot rotPt) * QuotientGroup.mk (mkRefl reflPt) =
      QuotientGroup.mk (mkRefl reflPt * mkRot rotPt * mkRefl reflPt) := by
    simp [← QuotientGroup.mk_mul, mul_assoc]
  rw [hL, mkRefl_conj_mkRot, QuotientGroup.mk_mul, mk_negI, one_mul, QuotientGroup.mk_inv]

lemma rotGen_mul_reflGen : rotGen * reflGen = reflGen * rotGen⁻¹ := by
  have h := congrArg (fun g => g * reflGen) reflGen_conj_rotGen
  have hL : reflGen * rotGen * reflGen * reflGen = reflGen * rotGen := by
    rw [mul_assoc (reflGen * rotGen), reflGen_mul_self, mul_one]
  have hSR : reflGen * rotGen = rotGen⁻¹ * reflGen := by
    have : reflGen * rotGen * reflGen * reflGen = rotGen⁻¹ * reflGen := h
    rwa [hL] at this
  have h2 := congrArg (fun g => reflGen * g) hSR
  have h2' : rotGen = reflGen * rotGen⁻¹ * reflGen := by
    simpa [← mul_assoc, reflGen_mul_self, one_mul] using h2
  have h3 := congrArg (fun g => g * reflGen) h2'
  simpa [mul_assoc, reflGen_mul_self, mul_one] using h3

lemma rotGen_pow_mul_reflGen (k : ℕ) :
    rotGen ^ k * reflGen = reflGen * (rotGen⁻¹) ^ k := by
  induction k with
  | zero => simp
  | succ k ih =>
    calc rotGen ^ (k + 1) * reflGen
        = (rotGen ^ k * rotGen) * reflGen := by rw [pow_succ]
      _ = rotGen ^ k * (rotGen * reflGen) := by simp [mul_assoc]
      _ = rotGen ^ k * (reflGen * rotGen⁻¹) := by rw [rotGen_mul_reflGen]
      _ = (rotGen ^ k * reflGen) * rotGen⁻¹ := by simp [mul_assoc]
      _ = (reflGen * (rotGen⁻¹) ^ k) * rotGen⁻¹ := by rw [ih]
      _ = reflGen * ((rotGen⁻¹) ^ k * rotGen⁻¹) := by simp [mul_assoc]
      _ = reflGen * (rotGen⁻¹) ^ (k + 1) := by rw [← pow_succ]

lemma rotGen_pow_mod (k : ℕ) : rotGen ^ k = rotGen ^ (k % 6) := by
  have h6 := rotGen_pow_six
  have hk : k = 6 * (k / 6) + k % 6 := (Nat.div_add_mod k 6).symm
  calc rotGen ^ k = rotGen ^ (6 * (k / 6) + k % 6) := by rw [← hk]
    _ = (rotGen ^ 6) ^ (k / 6) * rotGen ^ (k % 6) := by rw [pow_add, pow_mul]
    _ = (1 : _) ^ (k / 6) * rotGen ^ (k % 6) := by rw [h6]
    _ = rotGen ^ (k % 6) := by simp

lemma rotGen_inv_eq : rotGen⁻¹ = rotGen ^ 5 := by
  refine inv_eq_of_mul_eq_one_right ?_
  calc rotGen * rotGen ^ 5 = rotGen ^ 1 * rotGen ^ 5 := by rw [pow_one]
    _ = rotGen ^ (1 + 5) := by rw [← pow_add]
    _ = rotGen ^ 6 := by norm_num
    _ = 1 := rotGen_pow_six

lemma rotGen_inv_pow (k : ℕ) : (rotGen⁻¹) ^ k = rotGen ^ ((5 * k) % 6) := by
  rw [rotGen_inv_eq, ← pow_mul, rotGen_pow_mod]

lemma five_mul_val_eq_neg_val (i : ZMod 6) : (5 * i.val) % 6 = (-i).val := by
  fin_cases i <;> decide

def mulCircle1 (p q : Circle1) : Circle1 :=
  ⟨(p.val.1 * q.val.1 - p.val.2 * q.val.2, p.val.1 * q.val.2 + p.val.2 * q.val.1), by
    have hp := p.property; have hq := q.property
    have : (p.val.1 * q.val.1 - p.val.2 * q.val.2) ^ 2 +
        (p.val.1 * q.val.2 + p.val.2 * q.val.1) ^ 2 =
        (p.val.1 ^ 2 + p.val.2 ^ 2) * (q.val.1 ^ 2 + q.val.2 ^ 2) := by ring
    rw [this, hp, hq, one_mul]⟩

lemma mkRot_mul (p q : Circle1) : mkRot p * mkRot q = mkRot (mulCircle1 p q) := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [mkRot, mulCircle1, SpecialLinearGroup.coe_mul, Matrix.mul_apply, Fin.sum_univ_two]
  all_goals ring

lemma mkRot_one : mkRot ⟨(1, 0), by decide⟩ = (1 : SLG) := by
  apply Subtype.ext
  simp [mkRot, SpecialLinearGroup.coe_one]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.one_apply]

lemma exists_rot_pow (k : ℕ) :
    ∃ p : Circle1, rotGen ^ k = liftsToN (.inl p) := by
  induction k with
  | zero =>
    refine ⟨⟨(1, 0), by decide⟩, ?_⟩
    apply Subtype.ext
    change (1 : PSL2F11) = QuotientGroup.mk (mkRot ⟨(1, 0), by decide⟩)
    rw [mkRot_one, QuotientGroup.mk_one]
  | succ k ih =>
    obtain ⟨p, hp⟩ := ih
    refine ⟨mulCircle1 p rotPt, ?_⟩
    rw [pow_succ, hp]
    apply Subtype.ext
    change (liftsToN (.inl p)).val * rotGen.val =
      QuotientGroup.mk (mkRot (mulCircle1 p rotPt))
    simp only [rotGen, liftsToN]
    rw [← QuotientGroup.mk_mul, mkRot_mul]

lemma reflGen_ne_rot_pow (k : ℕ) : reflGen ≠ rotGen ^ k := by
  intro h
  obtain ⟨p, hp⟩ := exists_rot_pow k
  have heq : liftsToN (.inr reflPt) = liftsToN (.inl p) := h.trans hp
  rcases (liftsToN_eq_iff _ _).mp heq with h1 | h2
  · cases h1
  · have : negLift (Sum.inl p) =
        Sum.inl ⟨(-p.val.1, -p.val.2), by simpa [pow_two] using p.property⟩ := rfl
    rw [this] at h2
    cases h2

lemma orderOf_rotGen : orderOf rotGen = 6 := by
  refine (orderOf_eq_iff (by decide : 0 < 6)).2 ⟨rotGen_pow_six, ?_⟩
  intro m hm6 hm0 hpow
  have hval : (rotGen : PSL2F11) ^ m = 1 := congrArg Subtype.val hpow
  have hmk : (QuotientGroup.mk ((mkRot rotPt) ^ m) : PSL2F11) = 1 := by
    have : (QuotientGroup.mk (mkRot rotPt) : PSL2F11) ^ m = 1 := by
      simpa [rotGen, liftsToN] using hval
    rwa [← QuotientGroup.mk_pow] at this
  have hc : (mkRot rotPt) ^ m ∈ Subgroup.center SLG := (QuotientGroup.eq_one_iff _).mp hmk
  rcases center_eq_one_or_negI _ hc with h1 | hneg
  · have heq : (mkRot rotPt : SLG) ^ m = 1 := h1
    revert heq hm0
    interval_cases m <;> intro hm0 heq
    · exact absurd hm0 (by decide : ¬0 < 0)
    all_goals
      have he := congrArg (fun M : SLG => M.1 0 0) heq
      simp [mkRot, rotPt, SpecialLinearGroup.coe_one, pow_succ, pow_zero,
        SpecialLinearGroup.coe_mul, Matrix.mul_apply, Fin.sum_univ_two,
        Matrix.one_apply, Matrix.of_apply, Matrix.cons_val] at he
      exact absurd he (by decide)
  · have heq : (mkRot rotPt : SLG) ^ m = negI := hneg
    revert heq hm0
    interval_cases m <;> intro hm0 heq
    · exact absurd hm0 (by decide : ¬0 < 0)
    all_goals
      have he := congrArg (fun M : SLG => M.1 0 0) heq
      simp [mkRot, rotPt, negI, pow_succ, pow_zero, SpecialLinearGroup.coe_mul,
        Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply, Matrix.neg_apply,
        Matrix.of_apply, Matrix.cons_val] at he
      exact absurd he (by decide)

def dihedralToN : DihedralGroup 6 → Subgroup.centralizer ({sigma} : Set PSL2F11)
  | .r i => rotGen ^ i.val
  | .sr i => reflGen * rotGen ^ i.val

lemma dihedralToN_mul (a b : DihedralGroup 6) :
    dihedralToN (a * b) = dihedralToN a * dihedralToN b := by
  cases a with
  | r i =>
    cases b with
    | r j =>
      change rotGen ^ (i + j).val = rotGen ^ i.val * rotGen ^ j.val
      have hval : (i + j).val = (i.val + j.val) % 6 := ZMod.val_add i j
      rw [hval, ← rotGen_pow_mod (i.val + j.val), pow_add]
    | sr j =>
      change reflGen * rotGen ^ (j - i).val =
        rotGen ^ i.val * (reflGen * rotGen ^ j.val)
      have hval : (j - i).val = (j.val + (-i).val) % 6 := by
        rw [sub_eq_add_neg]; exact ZMod.val_add j (-i)
      symm
      calc rotGen ^ i.val * (reflGen * rotGen ^ j.val)
          = (rotGen ^ i.val * reflGen) * rotGen ^ j.val := by simp [mul_assoc]
        _ = (reflGen * (rotGen⁻¹) ^ i.val) * rotGen ^ j.val := by
              rw [rotGen_pow_mul_reflGen]
        _ = (reflGen * rotGen ^ ((5 * i.val) % 6)) * rotGen ^ j.val := by
              rw [rotGen_inv_pow]
        _ = (reflGen * rotGen ^ (-i).val) * rotGen ^ j.val := by
              rw [five_mul_val_eq_neg_val]
        _ = reflGen * (rotGen ^ (-i).val * rotGen ^ j.val) := by simp [mul_assoc]
        _ = reflGen * rotGen ^ ((-i).val + j.val) := by rw [← pow_add]
        _ = reflGen * rotGen ^ (((-i).val + j.val) % 6) := by rw [rotGen_pow_mod]
        _ = reflGen * rotGen ^ ((j.val + (-i).val) % 6) := by rw [add_comm]
        _ = reflGen * rotGen ^ (j - i).val := by rw [← hval]
  | sr i =>
    cases b with
    | r j =>
      change reflGen * rotGen ^ (i + j).val =
        (reflGen * rotGen ^ i.val) * rotGen ^ j.val
      have hval : (i + j).val = (i.val + j.val) % 6 := ZMod.val_add i j
      rw [hval, ← rotGen_pow_mod (i.val + j.val), pow_add, mul_assoc]
    | sr j =>
      change rotGen ^ (j - i).val =
        (reflGen * rotGen ^ i.val) * (reflGen * rotGen ^ j.val)
      have hval : (j - i).val = (j.val + (-i).val) % 6 := by
        rw [sub_eq_add_neg]; exact ZMod.val_add j (-i)
      symm
      calc (reflGen * rotGen ^ i.val) * (reflGen * rotGen ^ j.val)
          = reflGen * (rotGen ^ i.val * reflGen) * rotGen ^ j.val := by
              simp [mul_assoc]
        _ = reflGen * (reflGen * (rotGen⁻¹) ^ i.val) * rotGen ^ j.val := by
              rw [rotGen_pow_mul_reflGen]
        _ = (reflGen * reflGen) * ((rotGen⁻¹) ^ i.val * rotGen ^ j.val) := by
              simp [mul_assoc]
        _ = (1 : _) * ((rotGen⁻¹) ^ i.val * rotGen ^ j.val) := by
              rw [reflGen_mul_self]
        _ = (rotGen⁻¹) ^ i.val * rotGen ^ j.val := one_mul _
        _ = rotGen ^ ((5 * i.val) % 6) * rotGen ^ j.val := by rw [rotGen_inv_pow]
        _ = rotGen ^ (-i).val * rotGen ^ j.val := by rw [five_mul_val_eq_neg_val]
        _ = rotGen ^ ((-i).val + j.val) := by rw [← pow_add]
        _ = rotGen ^ (((-i).val + j.val) % 6) := by rw [rotGen_pow_mod]
        _ = rotGen ^ ((j.val + (-i).val) % 6) := by rw [add_comm]
        _ = rotGen ^ (j - i).val := by rw [← hval]

def dihedralToNHom : DihedralGroup 6 →* Subgroup.centralizer ({sigma} : Set PSL2F11) where
  toFun := dihedralToN
  map_one' := by
    change rotGen ^ (0 : ZMod 6).val = 1
    rw [ZMod.val_zero, pow_zero]
  map_mul' := dihedralToN_mul

lemma dihedralToNHom_injective : Function.Injective dihedralToNHom := by
  rw [injective_iff_map_eq_one]
  intro x hx
  match x with
  | .r i =>
    change rotGen ^ i.val = 1 at hx
    have hord := orderOf_dvd_iff_pow_eq_one (x := rotGen) (n := i.val) |>.mpr hx
    rw [orderOf_rotGen] at hord
    have hival : i.val < 6 := ZMod.val_lt i
    have : i.val = 0 := Nat.eq_zero_of_dvd_of_lt hord hival
    have : i = 0 := (ZMod.val_eq_zero i).mp this
    rw [this, DihedralGroup.r_zero]
  | .sr i =>
    change reflGen * rotGen ^ i.val = 1 at hx
    have : reflGen = (rotGen ^ i.val)⁻¹ := eq_inv_of_mul_eq_one_left hx
    have : reflGen = rotGen⁻¹ ^ i.val := by rw [this, inv_pow]
    have hfalse : reflGen = rotGen ^ ((5 * i.val) % 6) := by
      rw [this, rotGen_inv_pow]
    exact absurd hfalse (reflGen_ne_rot_pow _)

theorem centralizer_sigma_mulEquiv_dihedral :
    Nonempty (Subgroup.centralizer ({sigma} : Set PSL2F11) ≃* DihedralGroup 6) := by
  classical
  have hinj := dihedralToNHom_injective
  have hcard : Fintype.card (DihedralGroup 6) =
      Fintype.card (Subgroup.centralizer ({sigma} : Set PSL2F11)) := by
    rw [DihedralGroup.card, centralizer_sigma_card]
  have hbij : Function.Bijective dihedralToNHom :=
    (Fintype.bijective_iff_injective_and_card _).2 ⟨hinj, hcard⟩
  exact ⟨(MulEquiv.ofBijective dihedralToNHom hbij).symm⟩

#print axioms centralizer_sigma_card
#print axioms centralizer_sigma_mulEquiv_dihedral

end CentralizerN
end V14Formalization
