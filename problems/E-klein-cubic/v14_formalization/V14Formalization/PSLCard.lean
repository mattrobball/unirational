/-
Cardinality of PSL₂(F₁₁) = 660, via |GL| → |SL| → |PSL|.
Projective order profile of SL₂(F₁₁) via a kernel-checked M4 slice
certificate, and the character-norm identity ∑_g χ₁₀'(g)² = 660.
-/
module

public import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Card
public import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup
public import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
public import Mathlib.LinearAlgebra.Matrix.ProjectiveSpecialLinearGroup
public import Mathlib.Data.ZMod.Basic
public import Mathlib.Algebra.Field.ZMod
public import Mathlib.Data.Fintype.Card
public import Mathlib.GroupTheory.Index
public import Mathlib.Algebra.Group.Subgroup.Finite
public import Mathlib.GroupTheory.SpecificGroups.Cyclic
public import Mathlib.GroupTheory.OrderOfElement
public import Mathlib.RingTheory.RootsOfUnity.Basic
public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.Data.Int.Basic
public import Mathlib.Data.Fintype.Sigma
public import Mathlib.LinearAlgebra.Matrix.Adjugate
public import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
public import Mathlib.Tactic.FinCases
public import Mathlib.GroupTheory.GroupAction.Quotient
public import Mathlib.GroupTheory.GroupAction.ConjAct
public import Mathlib.GroupTheory.Rank
public import Mathlib.Algebra.Group.Conj
public import Mathlib.Algebra.Group.ConjFinite
public import Mathlib.LinearAlgebra.Matrix.Trace
public import Mathlib.Data.Fintype.Sum
public import Mathlib.Algebra.Group.End
public import Mathlib.FieldTheory.Finite.Basic

open Matrix Matrix.SpecialLinearGroup BigOperators
open scoped MatrixGroups

noncomputable section

namespace V14Formalization
namespace PSLCard

public abbrev F := ZMod 11
@[expose] public instance : Fact (Nat.Prime 11) := ⟨Nat.prime_eleven⟩
public abbrev SLG := SpecialLinearGroup (Fin 2) F
public abbrev PSL2F11 := PSL(2, F)

theorem card_F11 : Fintype.card F = 11 := by decide

theorem card_GL2_F11 : Nat.card (GL (Fin 2) F) = 13200 := by
  have h := card_GL_field (𝔽 := F) (n := 2)
  rw [h, card_F11]
  simp only [Fin.prod_univ_two]
  norm_num [pow_zero, pow_one]

theorem card_units_F11 : Nat.card Fˣ = 10 := by
  rw [Nat.card_eq_fintype_card, Fintype.card_units, card_F11]

theorem card_SL2_F11 : Nat.card SLG = 1320 := by
  let f : GL (Fin 2) F →* Fˣ := GeneralLinearGroup.det (R := F) (n := Fin 2)
  have hsurj : Function.Surjective f := GeneralLinearGroup.det_surjective
  have hmul : Nat.card f.ker * f.ker.index = Nat.card (GL (Fin 2) F) :=
    Subgroup.card_mul_index f.ker
  have hidx : f.ker.index = Nat.card Fˣ := by
    rw [Subgroup.index_ker f]
    have : f.range = ⊤ := MonoidHom.range_eq_top.mpr hsurj
    rw [this]
    exact Nat.card_congr (Subgroup.topEquiv (G := Fˣ)).toEquiv
  have e : f.ker ≃ SLG := by
    refine Equiv.ofBijective (fun g => ⟨g.1.val, ?_⟩) ?_
    · have hfg : f (g : GL (Fin 2) F) = 1 := g.2
      have hval : (f (g : GL (Fin 2) F)).val = 1 := by rw [hfg]; rfl
      have hdet := GeneralLinearGroup.val_det_apply (g : GL (Fin 2) F)
      change (g : GL (Fin 2) F).val.det = 1
      rwa [← hdet]
    · constructor
      · intro g1 g2 h
        apply Subtype.ext
        apply GeneralLinearGroup.ext
        intro i j
        exact congr_fun (congr_fun (congrArg Subtype.val h) i) j
      · intro s
        refine ⟨⟨toGL s, ?_⟩, Subtype.ext rfl⟩
        · change f (toGL s) = 1
          apply Units.ext
          have hdet := GeneralLinearGroup.val_det_apply (toGL s)
          rw [hdet]
          change (s : Matrix (Fin 2) (Fin 2) F).det = 1
          exact s.2
  have hker : Nat.card f.ker = Nat.card SLG := Nat.card_congr e
  rw [hidx, hker, card_units_F11, card_GL2_F11] at hmul
  omega

theorem card_rootsOfUnity_two_F : Nat.card (rootsOfUnity 2 F) = 2 := by
  have heq : (rootsOfUnity 2 F : Subgroup Fˣ) = (powMonoidHom 2).ker := by
    ext x
    simp only [mem_rootsOfUnity, MonoidHom.mem_ker, powMonoidHom_apply]
  have hker' : Nat.card (powMonoidHom 2 : Fˣ →* Fˣ).ker = (Nat.card Fˣ).gcd 2 :=
    IsCyclic.card_powMonoidHom_ker (G := Fˣ) 2
  rw [← heq] at hker'
  rw [hker', card_units_F11]
  decide

theorem card_center_SL2 : Nat.card (Subgroup.center SLG) = 2 := by
  have he : Subgroup.center SLG ≃* rootsOfUnity (Fintype.card (Fin 2)) F :=
    SpecialLinearGroup.center_equiv_rootsOfUnity' (0 : Fin 2)
  have h2 : Fintype.card (Fin 2) = 2 := by decide
  rw [Nat.card_congr he.toEquiv]
  have : rootsOfUnity (Fintype.card (Fin 2)) F = rootsOfUnity 2 F := by
    simp only [h2]
  rw [this, card_rootsOfUnity_two_F]

theorem card_PSL2_F11 : Nat.card PSL2F11 = 660 := by
  have hSL := card_SL2_F11
  have hC := card_center_SL2
  have hprod :
      Nat.card (SLG ⧸ Subgroup.center SLG) * Nat.card (Subgroup.center SLG) =
        Nat.card SLG :=
    (Subgroup.card_eq_card_quotient_mul_card_subgroup (Subgroup.center SLG)).symm
  change Nat.card PSL2F11 * Nat.card (Subgroup.center SLG) = Nat.card SLG at hprod
  rw [hC, hSL] at hprod
  omega

public theorem card_PSL2_F11_fintype : Fintype.card PSL2F11 = 660 := by
  rw [← Nat.card_eq_fintype_card, card_PSL2_F11]

/-! ## Projective order profile and χ₁₀' character norm

Computable order of the image in PSL: least `n ∈ {1,2,3,5,6,11}` with
`g^n = ±I`.  Native enumeration of the SL order multiset yields
`∑_A χ(pslOrd A)² = 1320 = 2 · 660`, hence the PSL character norm is 660. -/

@[expose] public def negI : SLG := ⟨-1, by simp [det_neg, Fintype.card_fin, pow_two]⟩

public theorem negI_mem_center : negI ∈ Subgroup.center SLG := by
  rw [SpecialLinearGroup.mem_center_iff]
  refine ⟨(-1 : F), by decide, ?_⟩
  ext i j
  simp [negI, scalar, diagonal, Matrix.one_apply, Matrix.neg_apply]
  split_ifs <;> ring

theorem mem_center_iff_one_or_negI (A : SLG) :
    A ∈ Subgroup.center SLG ↔ A = 1 ∨ A = negI := by
  constructor
  · intro hA
    obtain ⟨r, hr, hsc⟩ :=
      (SpecialLinearGroup.mem_center_iff (n := Fin 2) (R := F)).mp hA
    have hr2 : r ^ 2 = 1 := by simpa [Fintype.card_fin] using hr
    have r_cases : r = 1 ∨ r = -1 := by
      have : r * r = 1 := by simpa [pow_two] using hr2
      have hfac : (r - 1) * (r + 1) = 0 := by
        calc (r - 1) * (r + 1) = r * r - 1 := by ring
          _ = 1 - 1 := by rw [this]
          _ = 0 := by ring
      rcases mul_eq_zero.mp hfac with h | h
      · exact Or.inl (sub_eq_zero.mp h)
      · exact Or.inr (eq_neg_of_add_eq_zero_left h)
    rcases r_cases with rfl | rfl
    · left
      apply Subtype.ext
      calc (A : Matrix (Fin 2) (Fin 2) F)
          = scalar (Fin 2) (1 : F) := hsc.symm
        _ = 1 := by
          ext i j; simp [scalar, diagonal, Matrix.one_apply]
    · right
      apply Subtype.ext
      calc (A : Matrix (Fin 2) (Fin 2) F)
          = scalar (Fin 2) (-1 : F) := hsc.symm
        _ = (negI : Matrix (Fin 2) (Fin 2) F) := by
          ext i j
          by_cases hij : i = j
          · simp [scalar, diagonal, negI, hij, Matrix.one_apply]
          · simp [scalar, diagonal, negI, hij, Matrix.one_apply]
  · intro h
    rcases h with rfl | rfl
    · exact Subgroup.one_mem _
    · exact negI_mem_center

/-- Computable projective order of an SL₂ matrix (image in PSL). -/
@[expose] public def pslOrd (g : SLG) : ℕ :=
  if g ^ 1 = 1 ∨ g ^ 1 = negI then 1
  else if g ^ 2 = 1 ∨ g ^ 2 = negI then 2
  else if g ^ 3 = 1 ∨ g ^ 3 = negI then 3
  else if g ^ 5 = 1 ∨ g ^ 5 = negI then 5
  else if g ^ 6 = 1 ∨ g ^ 6 = negI then 6
  else if g ^ 11 = 1 ∨ g ^ 11 = negI then 11
  else 0

@[expose] public def slCardOrder (n : ℕ) : ℕ :=
  (Finset.univ : Finset SLG).filter (fun g => pslOrd g = n) |>.card

/-! ### Raw M4 model and kernel-checked order profile

Enumerate SL₂(F₁₁) as 4-tuples, split by top-left entry (size 11³),
and certify one reusable slice profile by ordinary `decide`. -/

/-- Raw 2×2 matrix as a 4-tuple `(a,b,c,d)` meaning `!![a,b; c,d]`. -/
abbrev M4 := F × F × F × F

def det4 (m : M4) : F := m.1 * m.2.2.2 - m.2.1 * m.2.2.1

def isSL4 (m : M4) : Bool := decide (det4 m = 1)

def mul4 (A B : M4) : M4 :=
  (A.1 * B.1 + A.2.1 * B.2.2.1,
   A.1 * B.2.1 + A.2.1 * B.2.2.2,
   A.2.2.1 * B.1 + A.2.2.2 * B.2.2.1,
   A.2.2.1 * B.2.1 + A.2.2.2 * B.2.2.2)

def one4 : M4 := (1, 0, 0, 1)
def negI4 : M4 := (-1, 0, 0, -1)

def pow4 : M4 → ℕ → M4
  | _, 0 => one4
  | A, n + 1 => mul4 (pow4 A n) A

def pslOrd4 (g : M4) : ℕ :=
  if pow4 g 1 = one4 || pow4 g 1 = negI4 then 1
  else if pow4 g 2 = one4 || pow4 g 2 = negI4 then 2
  else if pow4 g 3 = one4 || pow4 g 3 = negI4 then 3
  else if pow4 g 5 = one4 || pow4 g 5 = negI4 then 5
  else if pow4 g 6 = one4 || pow4 g 6 = negI4 then 6
  else if pow4 g 11 = one4 || pow4 g 11 = negI4 then 11
  else 0

def inv4 (A : M4) : M4 := (A.2.2.2, -A.2.1, -A.2.2.1, A.1)

def allSL4 : Finset M4 :=
  (Finset.univ : Finset M4).filter (fun m => isSL4 m = true)

def toM4 (g : SLG) : M4 :=
  let M : Matrix (Fin 2) (Fin 2) F := g
  (M 0 0, M 0 1, M 1 0, M 1 1)

/-- Reconstruct `SLG` from a raw SL 4-tuple. -/
def ofM4 (m : M4) (hm : m ∈ allSL4) : SLG :=
  ⟨!![m.1, m.2.1; m.2.2.1, m.2.2.2], by
    have hdet4 : det4 m = 1 := by
      have h := (Finset.mem_filter.mp hm).2
      simpa [isSL4, decide_eq_true_eq] using h
    rw [Matrix.det_fin_two_of]
    simpa [det4] using hdet4⟩

theorem toM4_mem_allSL4 (A : SLG) : toM4 A ∈ allSL4 := by
  refine Finset.mem_filter.mpr ⟨Finset.mem_univ _, ?_⟩
  have hdet : (A : Matrix (Fin 2) (Fin 2) F).det = 1 := A.prop
  have : det4 (toM4 A) = 1 := by
    dsimp [det4, toM4]
    rwa [← Matrix.det_fin_two (A : Matrix (Fin 2) (Fin 2) F)]
  simpa [isSL4] using this

theorem toM4_ofM4 (m : M4) (hm : m ∈ allSL4) : toM4 (ofM4 m hm) = m := by
  simp [toM4, ofM4, Matrix.of_apply]

theorem ofM4_toM4 (A : SLG) :
    ofM4 (toM4 A) (toM4_mem_allSL4 A) = A := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

theorem toM4_injective : Function.Injective toM4 := by
  intro x y hxy
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j
  · simpa [toM4] using congrArg (fun m : M4 => m.1) hxy
  · simpa [toM4] using congrArg (fun m : M4 => m.2.1) hxy
  · simpa [toM4] using congrArg (fun m : M4 => m.2.2.1) hxy
  · simpa [toM4] using congrArg (fun m : M4 => m.2.2.2) hxy

theorem toM4_one : toM4 1 = one4 := by
  simp [toM4, one4, Matrix.one_apply]

theorem toM4_negI : toM4 negI = negI4 := by
  simp [toM4, negI, negI4]

theorem toM4_mul (A B : SLG) : toM4 (A * B) = mul4 (toM4 A) (toM4 B) := by
  ext <;> simp [toM4, mul4, Matrix.mul_apply, Fin.sum_univ_two]

theorem toM4_pow (A : SLG) (n : ℕ) : toM4 (A ^ n) = pow4 (toM4 A) n := by
  induction n with
  | zero => simp [pow_zero, toM4_one, pow4]
  | succ n ih => rw [pow_succ, toM4_mul, ih]; rfl

theorem toM4_inv (A : SLG) : toM4 A⁻¹ = inv4 (toM4 A) := by
  rw [Matrix.SpecialLinearGroup.SL2_inv_expl A]
  simp [toM4, inv4]

theorem eq_one_iff_toM4 (A : SLG) : A = 1 ↔ toM4 A = one4 := by
  constructor
  · intro h; rw [h, toM4_one]
  · intro h; exact toM4_injective (h.trans toM4_one.symm)

theorem eq_negI_iff_toM4 (A : SLG) : A = negI ↔ toM4 A = negI4 := by
  constructor
  · intro h; rw [h, toM4_negI]
  · intro h; exact toM4_injective (h.trans toM4_negI.symm)

theorem pow_eq_one_or_negI_iff (A : SLG) (n : ℕ) :
    (A ^ n = 1 ∨ A ^ n = negI) ↔
      (pow4 (toM4 A) n = one4 ∨ pow4 (toM4 A) n = negI4) := by
  constructor
  · intro h
    rcases h with h | h
    · left; rw [← toM4_pow, h, toM4_one]
    · right; rw [← toM4_pow, h, toM4_negI]
  · intro h
    rcases h with h | h
    · left; exact toM4_injective (by rw [toM4_pow, h, toM4_one])
    · right; exact toM4_injective (by rw [toM4_pow, h, toM4_negI])

/-- `pslOrd` agrees with the raw 4-tuple projective order. -/
theorem pslOrd_eq_pslOrd4 (A : SLG) : pslOrd A = pslOrd4 (toM4 A) := by
  unfold pslOrd pslOrd4
  have e1 := pow_eq_one_or_negI_iff A 1
  have e2 := pow_eq_one_or_negI_iff A 2
  have e3 := pow_eq_one_or_negI_iff A 3
  have e5 := pow_eq_one_or_negI_iff A 5
  have e6 := pow_eq_one_or_negI_iff A 6
  have e11 := pow_eq_one_or_negI_iff A 11
  simp only [Bool.or_eq_true, decide_eq_true_eq]
  rcases em (A ^ 1 = 1 ∨ A ^ 1 = negI) with h1 | h1
  · rw [if_pos h1, if_pos (e1.mp h1)]
  · rw [if_neg h1, if_neg (fun h => h1 (e1.mpr h))]
    rcases em (A ^ 2 = 1 ∨ A ^ 2 = negI) with h2 | h2
    · rw [if_pos h2, if_pos (e2.mp h2)]
    · rw [if_neg h2, if_neg (fun h => h2 (e2.mpr h))]
      rcases em (A ^ 3 = 1 ∨ A ^ 3 = negI) with h3 | h3
      · rw [if_pos h3, if_pos (e3.mp h3)]
      · rw [if_neg h3, if_neg (fun h => h3 (e3.mpr h))]
        rcases em (A ^ 5 = 1 ∨ A ^ 5 = negI) with h5 | h5
        · rw [if_pos h5, if_pos (e5.mp h5)]
        · rw [if_neg h5, if_neg (fun h => h5 (e5.mpr h))]
          rcases em (A ^ 6 = 1 ∨ A ^ 6 = negI) with h6 | h6
          · rw [if_pos h6, if_pos (e6.mp h6)]
          · rw [if_neg h6, if_neg (fun h => h6 (e6.mpr h))]
            rcases em (A ^ 11 = 1 ∨ A ^ 11 = negI) with h11 | h11
            · rw [if_pos h11, if_pos (e11.mp h11)]
            · rw [if_neg h11, if_neg (fun h => h11 (e11.mpr h))]

/-- Order multiset count on the raw SL model. -/
def m4CardOrder (n : ℕ) : ℕ :=
  (allSL4.filter (fun m => pslOrd4 m = n)).card

theorem slCardOrder_eq_m4CardOrder (n : ℕ) :
    slCardOrder n = m4CardOrder n := by
  classical
  let e' : {A : SLG // pslOrd A = n} ≃ {m : M4 // m ∈ allSL4 ∧ pslOrd4 m = n} :=
    { toFun := fun ⟨A, hA⟩ =>
        ⟨toM4 A, toM4_mem_allSL4 A, by rw [← pslOrd_eq_pslOrd4, hA]⟩
      invFun := fun ⟨m, hm, ho⟩ =>
        ⟨ofM4 m hm, by rw [pslOrd_eq_pslOrd4, toM4_ofM4, ho]⟩
      left_inv := fun ⟨A, _⟩ => by
        apply Subtype.ext; exact ofM4_toM4 A
      right_inv := fun ⟨m, hm, _⟩ => by
        apply Subtype.ext; exact toM4_ofM4 m hm }
  have h1 : slCardOrder n = Fintype.card {A : SLG // pslOrd A = n} := by
    rw [Fintype.card_subtype]; rfl
  have h2 : Fintype.card {A : SLG // pslOrd A = n} =
      Fintype.card {m : M4 // m ∈ allSL4 ∧ pslOrd4 m = n} :=
    Fintype.card_congr e'
  have h3 : Fintype.card {m : M4 // m ∈ allSL4 ∧ pslOrd4 m = n} =
      m4CardOrder n := by
    let e : {m : M4 // m ∈ allSL4 ∧ pslOrd4 m = n} ≃
        {m // m ∈ allSL4.filter (fun m => pslOrd4 m = n)} :=
      Equiv.subtypeEquivRight (fun m => by simp [Finset.mem_filter])
    rw [Fintype.card_congr e, Fintype.card_coe]
    rfl
  exact h1.trans (h2.trans h3)

/-- Pack `(a, (b,c,d))` as an M4 matrix. -/
private def pack4 (a : F) (p : F × F × F) : M4 := (a, p.1, p.2.1, p.2.2)

private theorem pack4_unpack (m : M4) :
    pack4 m.1 (m.2.1, m.2.2.1, m.2.2.2) = m := by
  rcases m with ⟨_, _, _, _⟩; rfl

/-- Slice of fixed top-left entry: count of SL matrices with given projective order. -/
def sliceCard (a : F) (k : ℕ) : ℕ :=
  ((Finset.univ : Finset (F × F × F)).filter (fun p =>
    isSL4 (pack4 a p) = true ∧ pslOrd4 (pack4 a p) = k)).card

/-! #### Determinant-eliminated slices

The determinant equation removes one matrix coordinate before any finite
certificate is evaluated.  Thus every kernel reduction below ranges over
`11² = 121` pairs, never `11³` triples.  Powers `a ^ 9` implement inversion
in `ZMod 11` while remaining reducible by the kernel evaluator.
-/

private abbrev fullPred (a : F) (k : ℕ) (p : F × F × F) : Prop :=
  isSL4 (pack4 a p) = true ∧ pslOrd4 (pack4 a p) = k

private abbrev redNZPred (a : F) (k : ℕ) (p : F × F) : Prop :=
  pslOrd4 (a, p.1, p.2, a ^ 9 * (1 + p.1 * p.2)) = k

private abbrev redZPred (k : ℕ) (p : F × F) : Prop :=
  p.1 ≠ 0 ∧ pslOrd4 (0, p.1, -(p.1 ^ 9), p.2) = k

def reducedSliceCard (a : F) (k : ℕ) : ℕ :=
  if a = 0 then
    ((Finset.univ : Finset (F × F)).filter (redZPred k)).card
  else
    ((Finset.univ : Finset (F × F)).filter (redNZPred a k)).card

private theorem filter_card_eq_subtype_card
    {X : Type} [Fintype X] [DecidableEq X]
    (P : X → Prop) [DecidablePred P] :
    ((Finset.univ : Finset X).filter P).card = Fintype.card {x : X // P x} := by
  let e : {x // x ∈ (Finset.univ : Finset X).filter P} ≃ {x : X // P x} :=
    Equiv.subtypeEquivRight (fun x => by simp)
  rw [← Fintype.card_coe, Fintype.card_congr e]

private theorem sliceCard_eq_full_card (a : F) (k : ℕ) :
    sliceCard a k = Fintype.card {p : F × F × F // fullPred a k p} := by
  simpa [sliceCard] using filter_card_eq_subtype_card (fullPred a k)

private theorem reducedSliceCard_eq_redNZ_card (a : F) (k : ℕ) (ha : a ≠ 0) :
    reducedSliceCard a k = Fintype.card {p : F × F // redNZPred a k p} := by
  simp only [reducedSliceCard, if_neg ha]
  exact filter_card_eq_subtype_card (redNZPred a k)

private theorem reducedSliceCard_zero_eq_redZ_card (k : ℕ) :
    reducedSliceCard 0 k = Fintype.card {p : F × F // redZPred k p} := by
  simp only [reducedSliceCard, if_pos]
  exact filter_card_eq_subtype_card (redZPred k)

private def fullToNZ (p : F × F × F) : F × F := (p.1, p.2.1)

private def nzToFull (a : F) (p : F × F) : F × F × F :=
  (p.1, p.2, a ^ 9 * (1 + p.1 * p.2))

private theorem mul_pow9_eq_one (a : F) (ha : a ≠ 0) : a * a ^ 9 = 1 := by
  rw [← pow_succ']
  exact ZMod.pow_card_sub_one_eq_one ha

private theorem nzToFull_valid (a : F) (ha : a ≠ 0) (k : ℕ)
    (p : F × F) (hp : redNZPred a k p) :
    fullPred a k (nzToFull a p) := by
  rcases p with ⟨b, c⟩
  constructor
  · change decide (a * (a ^ 9 * (1 + b * c)) - b * c = 1) = true
    apply decide_eq_true
    rw [← mul_assoc, mul_pow9_eq_one a ha, one_mul]
    exact add_sub_cancel_right 1 (b * c)
  · exact hp

private theorem full_d_eq (a : F) (ha : a ≠ 0) (k : ℕ)
    (p : F × F × F) (hp : fullPred a k p) :
    p.2.2 = a ^ 9 * (1 + p.1 * p.2.1) := by
  rcases p with ⟨b, c, d⟩
  change d = a ^ 9 * (1 + b * c)
  have hdet : a * d - b * c = 1 := by
    exact of_decide_eq_true (by simpa [isSL4, det4, pack4] using hp.1)
  apply mul_left_cancel₀ ha
  rw [← mul_assoc, mul_pow9_eq_one a ha, one_mul]
  exact sub_eq_iff_eq_add.mp hdet

private def nzEquiv (a : F) (ha : a ≠ 0) (k : ℕ) :
    {p : F × F × F // fullPred a k p} ≃
      {p : F × F // redNZPred a k p} :=
  { toFun := fun p => ⟨fullToNZ p.1, by
      rcases p with ⟨⟨b, c, d⟩, hp⟩
      dsimp [fullToNZ, redNZPred]
      rw [← full_d_eq a ha k (b, c, d) hp]
      exact hp.2⟩
    invFun := fun p => ⟨nzToFull a p.1, nzToFull_valid a ha k p.1 p.2⟩
    left_inv := fun p => by
      apply Subtype.ext
      rcases p with ⟨⟨b, c, d⟩, hp⟩
      dsimp [fullToNZ, nzToFull]
      rw [← full_d_eq a ha k (b, c, d) hp]
    right_inv := fun p => by
      apply Subtype.ext
      rcases p with ⟨⟨b, c⟩, _⟩
      rfl }

private theorem full_b_ne_zero (k : ℕ) (p : F × F × F)
    (hp : fullPred 0 k p) : p.1 ≠ 0 := by
  rcases p with ⟨b, c, d⟩
  change b ≠ 0
  have hdet : -(b * c) = 1 := by
    exact of_decide_eq_true (by simpa [isSL4, det4, pack4] using hp.1)
  intro hb
  subst b
  norm_num at hdet

private theorem full_c_eq (k : ℕ) (p : F × F × F)
    (hp : fullPred 0 k p) : p.2.1 = -(p.1 ^ 9) := by
  rcases p with ⟨b, c, d⟩
  change c = -(b ^ 9)
  have hb : b ≠ 0 := full_b_ne_zero k (b, c, d) hp
  have hdet : -(b * c) = 1 := by
    exact of_decide_eq_true (by simpa [isSL4, det4, pack4] using hp.1)
  apply mul_left_cancel₀ hb
  rw [mul_neg, mul_pow9_eq_one b hb]
  have h := congrArg Neg.neg hdet
  simpa using h

private theorem zToFull_valid (k : ℕ) (p : F × F) (hp : redZPred k p) :
    fullPred 0 k (p.1, -(p.1 ^ 9), p.2) := by
  rcases p with ⟨b, d⟩
  constructor
  · dsimp [fullPred, pack4, isSL4, det4]
    apply decide_eq_true
    simpa using mul_pow9_eq_one b hp.1
  · exact hp.2

private def zEquiv (k : ℕ) :
    {p : F × F × F // fullPred 0 k p} ≃
      {p : F × F // redZPred k p} :=
  { toFun := fun p => ⟨(p.1.1, p.1.2.2), by
      rcases p with ⟨⟨b, c, d⟩, hp⟩
      refine ⟨full_b_ne_zero k (b, c, d) hp, ?_⟩
      dsimp
      rw [← full_c_eq k (b, c, d) hp]
      exact hp.2⟩
    invFun := fun p => ⟨(p.1.1, -(p.1.1 ^ 9), p.1.2), zToFull_valid k p.1 p.2⟩
    left_inv := fun p => by
      apply Subtype.ext
      rcases p with ⟨⟨b, c, d⟩, hp⟩
      dsimp
      rw [← full_c_eq k (b, c, d) hp]
    right_inv := fun p => by
      apply Subtype.ext
      rcases p with ⟨⟨b, d⟩, _⟩
      rfl }

theorem sliceCard_eq_reducedSliceCard (a : F) (k : ℕ) :
    sliceCard a k = reducedSliceCard a k := by
  by_cases ha : a = 0
  · subst a
    rw [sliceCard_eq_full_card, reducedSliceCard_zero_eq_redZ_card]
    exact Fintype.card_congr (zEquiv k)
  · rw [sliceCard_eq_full_card, reducedSliceCard_eq_redNZ_card a k ha]
    exact Fintype.card_congr (nzEquiv a ha k)

private theorem reducedSliceCard_zero (a : F) : reducedSliceCard a 0 = 0 := by
  by_cases ha : a = 0
  · subst a
    rw [reducedSliceCard, if_pos rfl]
    decide
  · rw [reducedSliceCard, if_neg ha]
    fin_cases a
    · exact (ha rfl).elim
    all_goals decide

private theorem reducedSliceCard_one (a : F) :
    reducedSliceCard a 1 = if a = 1 ∨ a = 10 then 1 else 0 := by
  by_cases ha : a = 0
  · subst a
    rw [reducedSliceCard, if_pos rfl]
    decide
  · rw [reducedSliceCard, if_neg ha]
    fin_cases a
    · exact (ha rfl).elim
    all_goals decide

private theorem reducedSliceCard_two (a : F) : reducedSliceCard a 2 = 10 := by
  by_cases ha : a = 0
  · subst a
    rw [reducedSliceCard, if_pos rfl]
    decide
  · rw [reducedSliceCard, if_neg ha]
    fin_cases a
    · exact (ha rfl).elim
    all_goals decide

private theorem reducedSliceCard_three (a : F) : reducedSliceCard a 3 = 20 := by
  by_cases ha : a = 0
  · subst a
    rw [reducedSliceCard, if_pos rfl]
    decide
  · rw [reducedSliceCard, if_neg ha]
    fin_cases a
    · exact (ha rfl).elim
    all_goals decide

private theorem reducedSliceCard_five (a : F) :
    reducedSliceCard a 5 = if a = 0 ∨ a = 1 ∨ a = 10 then 40 else 51 := by
  by_cases ha : a = 0
  · subst a
    rw [reducedSliceCard, if_pos rfl]
    decide
  · rw [reducedSliceCard, if_neg ha]
    fin_cases a
    · exact (ha rfl).elim
    all_goals decide

private theorem reducedSliceCard_six (a : F) : reducedSliceCard a 6 = 20 := by
  by_cases ha : a = 0
  · subst a
    rw [reducedSliceCard, if_pos rfl]
    decide
  · rw [reducedSliceCard, if_neg ha]
    fin_cases a
    · exact (ha rfl).elim
    all_goals decide

private theorem reducedSliceCard_eleven (a : F) :
    reducedSliceCard a 11 = if a = 1 ∨ a = 10 then 30 else 20 := by
  by_cases ha : a = 0
  · subst a
    rw [reducedSliceCard, if_pos rfl]
    decide
  · rw [reducedSliceCard, if_neg ha]
    fin_cases a
    · exact (ha rfl).elim
    all_goals decide

/-- Global M4 order count is the sum of the eleven top-left slices. -/
theorem m4CardOrder_eq_sum_slices (k : ℕ) :
    m4CardOrder k = ∑ a : F, sliceCard a k := by
  classical
  let P (m : M4) : Prop := isSL4 m = true ∧ pslOrd4 m = k
  let Q (a : F) (p : F × F × F) : Prop :=
    isSL4 (pack4 a p) = true ∧ pslOrd4 (pack4 a p) = k
  let S := {m : M4 // P m}
  have hL : m4CardOrder k = Fintype.card S := by
    unfold m4CardOrder
    have hfilter :
        allSL4.filter (fun m => pslOrd4 m = k) =
          (Finset.univ : Finset M4).filter P := by
      ext m
      simp only [allSL4, P, Finset.mem_filter, Finset.mem_univ, true_and]
    rw [hfilter]
    let e : {m // m ∈ (Finset.univ : Finset M4).filter P} ≃ S :=
      Equiv.subtypeEquivRight (fun m => by simp [Finset.mem_filter, P])
    rw [← Fintype.card_coe, Fintype.card_congr e]
  have hslice : ∀ a, sliceCard a k = Fintype.card {p : F × F × F // Q a p} := by
    intro a
    change ((Finset.univ : Finset (F × F × F)).filter (Q a)).card =
      Fintype.card {p : F × F × F // Q a p}
    let e : {p // p ∈ (Finset.univ : Finset (F × F × F)).filter (Q a)} ≃
        {p : F × F × F // Q a p} :=
      Equiv.subtypeEquivRight (fun p => by simp [Finset.mem_filter, Q])
    rw [← Fintype.card_coe, Fintype.card_congr e]
  have hR : (∑ a : F, sliceCard a k) = Fintype.card S := by
    simp_rw [hslice]
    rw [← Fintype.card_sigma]
    let e : (Σ a : F, {p : F × F × F // Q a p}) ≃ S :=
      { toFun := fun ⟨a, p, hp⟩ => ⟨pack4 a p, hp⟩
        invFun := fun ⟨m, hm⟩ =>
          ⟨m.1, (m.2.1, m.2.2.1, m.2.2.2), by
            dsimp [Q]; rwa [pack4_unpack]⟩
        left_inv := fun ⟨a, p, _⟩ => by
          rcases p with ⟨b, c, d⟩; rfl
        right_inv := fun ⟨m, _⟩ => Subtype.ext (pack4_unpack m) }
    exact Fintype.card_congr e
  exact hL.trans hR.symm

theorem sliceCard_zero (a : F) : sliceCard a 0 = 0 := by
  rw [sliceCard_eq_reducedSliceCard, reducedSliceCard_zero]

theorem sliceCard_one (a : F) :
    sliceCard a 1 = if a = 1 ∨ a = 10 then 1 else 0 := by
  rw [sliceCard_eq_reducedSliceCard, reducedSliceCard_one]

theorem sliceCard_two (a : F) : sliceCard a 2 = 10 := by
  rw [sliceCard_eq_reducedSliceCard, reducedSliceCard_two]

theorem sliceCard_three (a : F) : sliceCard a 3 = 20 := by
  rw [sliceCard_eq_reducedSliceCard, reducedSliceCard_three]

theorem sliceCard_five (a : F) :
    sliceCard a 5 = if a = 0 ∨ a = 1 ∨ a = 10 then 40 else 51 := by
  rw [sliceCard_eq_reducedSliceCard, reducedSliceCard_five]

theorem sliceCard_six (a : F) : sliceCard a 6 = 20 := by
  rw [sliceCard_eq_reducedSliceCard, reducedSliceCard_six]

theorem sliceCard_eleven (a : F) :
    sliceCard a 11 = if a = 1 ∨ a = 10 then 30 else 20 := by
  rw [sliceCard_eq_reducedSliceCard, reducedSliceCard_eleven]

theorem m4CardOrder_zero : m4CardOrder 0 = 0 := by
  rw [m4CardOrder_eq_sum_slices]
  simp [sliceCard_zero]

theorem m4CardOrder_one : m4CardOrder 1 = 2 := by
  rw [m4CardOrder_eq_sum_slices]
  simp_rw [sliceCard_one]
  decide

theorem m4CardOrder_two : m4CardOrder 2 = 110 := by
  rw [m4CardOrder_eq_sum_slices]
  simp_rw [sliceCard_two]
  decide

theorem m4CardOrder_three : m4CardOrder 3 = 220 := by
  rw [m4CardOrder_eq_sum_slices]
  simp_rw [sliceCard_three]
  decide

theorem m4CardOrder_five : m4CardOrder 5 = 528 := by
  rw [m4CardOrder_eq_sum_slices]
  simp_rw [sliceCard_five]
  decide

theorem m4CardOrder_six : m4CardOrder 6 = 220 := by
  rw [m4CardOrder_eq_sum_slices]
  simp_rw [sliceCard_six]
  decide

theorem m4CardOrder_eleven : m4CardOrder 11 = 240 := by
  rw [m4CardOrder_eq_sum_slices]
  simp_rw [sliceCard_eleven]
  decide

public theorem slCardOrder_one : slCardOrder 1 = 2 :=
  (slCardOrder_eq_m4CardOrder 1).trans m4CardOrder_one

public theorem slCardOrder_two : slCardOrder 2 = 110 :=
  (slCardOrder_eq_m4CardOrder 2).trans m4CardOrder_two

public theorem slCardOrder_three : slCardOrder 3 = 220 :=
  (slCardOrder_eq_m4CardOrder 3).trans m4CardOrder_three

theorem slCardOrder_five : slCardOrder 5 = 528 :=
  (slCardOrder_eq_m4CardOrder 5).trans m4CardOrder_five

public theorem slCardOrder_six : slCardOrder 6 = 220 :=
  (slCardOrder_eq_m4CardOrder 6).trans m4CardOrder_six

public theorem slCardOrder_eleven : slCardOrder 11 = 240 :=
  (slCardOrder_eq_m4CardOrder 11).trans m4CardOrder_eleven

theorem slCardOrder_zero : slCardOrder 0 = 0 :=
  (slCardOrder_eq_m4CardOrder 0).trans m4CardOrder_zero

/-- Integer character values of χ₁₀' by projective order. -/
@[expose] public def chi10Int (n : ℕ) : ℤ :=
  if n = 1 then 10
  else if n = 2 then 2
  else if n = 3 then 1
  else if n = 5 then 0
  else if n = 6 then -1
  else if n = 11 then -1
  else 0

/-- ∑_{A : SL} χ(pslOrd A)² = 1320. -/
def slChiSumSq : ℤ :=
  ∑ A : SLG, chi10Int (pslOrd A) * chi10Int (pslOrd A)

/-- Indicator sum: ∑_A (if pslOrd A = n then c else 0) = c · slCardOrder n. -/
private theorem sum_ite_pslOrd (n : ℕ) (c : ℤ) :
    (∑ A : SLG, if pslOrd A = n then c else (0 : ℤ)) =
      c * slCardOrder n := by
  classical
  simp only [Finset.sum_ite, Finset.sum_const, nsmul_eq_mul, slCardOrder]
  ring

/-- On every matrix, χ(pslOrd)² is the corresponding order-profile contribution. -/
private theorem chi10Sq_eq_ite (A : SLG) :
    chi10Int (pslOrd A) * chi10Int (pslOrd A) =
      (if pslOrd A = 1 then (100 : ℤ) else 0) +
        (if pslOrd A = 2 then 4 else 0) +
        (if pslOrd A = 3 then 1 else 0) +
        (if pslOrd A = 6 then 1 else 0) +
        (if pslOrd A = 11 then 1 else 0) := by
  by_cases h1 : pslOrd A = 1
  · simp [h1, chi10Int]
  by_cases h2 : pslOrd A = 2
  · simp [h1, h2, chi10Int]
  by_cases h3 : pslOrd A = 3
  · simp [h1, h2, h3, chi10Int]
  by_cases h5 : pslOrd A = 5
  · simp [h1, h2, h3, h5, chi10Int]
  by_cases h6 : pslOrd A = 6
  · simp [h1, h2, h3, h5, h6, chi10Int]
  by_cases h11 : pslOrd A = 11
  · simp [h1, h2, h3, h5, h6, h11, chi10Int]
  · -- residual spectrum values (0 or junk) have χ = 0
    have hchi : chi10Int (pslOrd A) = 0 := by
      unfold chi10Int
      split_ifs <;> omega
    simp [h1, h2, h3, h6, h11, hchi]

theorem slChiSumSq_eq : slChiSumSq = 1320 := by
  unfold slChiSumSq
  simp_rw [chi10Sq_eq_ite]
  simp only [Finset.sum_add_distrib, sum_ite_pslOrd,
    slCardOrder_one, slCardOrder_two, slCardOrder_three,
    slCardOrder_six, slCardOrder_eleven]
  norm_num

/-- Equivalent count via order multiset: 100·2 + 4·110 + 1·220 + 0·528 + 1·220 + 1·240. -/
theorem slChiSumSq_by_orders :
    (100 : ℤ) * slCardOrder 1 + 4 * slCardOrder 2 + slCardOrder 3 +
      slCardOrder 6 + slCardOrder 11 = 1320 := by
  rw [slCardOrder_one, slCardOrder_two, slCardOrder_three, slCardOrder_six,
    slCardOrder_eleven]
  norm_num

theorem pslOrd_eq_one_or_pow_center (g : SLG) (n : ℕ)
    (hn : pslOrd g = n) (hn0 : n ≠ 0) :
    g ^ n = 1 ∨ g ^ n = negI := by
  unfold pslOrd at hn
  split_ifs at hn with h1 h2 h3 h5 h6 h11
  · subst hn; simpa using h1
  · subst hn; simpa using h2
  · subst hn; simpa using h3
  · subst hn; simpa using h5
  · subst hn; simpa using h6
  · subst hn; simpa using h11
  · exact absurd hn (Ne.symm hn0)

theorem mk_pow_eq_one_iff_pow_mem_center (A : SLG) (n : ℕ) :
    (QuotientGroup.mk A : PSL2F11) ^ n = 1 ↔ A ^ n ∈ Subgroup.center SLG := by
  rw [← QuotientGroup.mk_pow, QuotientGroup.eq_one_iff]

theorem pslOrd_le_of_pow_center {A : SLG} {k : ℕ}
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 5 ∨ k = 6 ∨ k = 11)
    (hpow : A ^ k = 1 ∨ A ^ k = negI) :
    pslOrd A ≤ k := by
  unfold pslOrd
  rcases hk with rfl | rfl | rfl | rfl | rfl | rfl <;> split_ifs <;> omega

theorem pslOrd_eq_cases (A : SLG) (hA : pslOrd A ≠ 0) :
    pslOrd A = 1 ∨ pslOrd A = 2 ∨ pslOrd A = 3 ∨
      pslOrd A = 5 ∨ pslOrd A = 6 ∨ pslOrd A = 11 := by
  unfold pslOrd at hA ⊢
  split_ifs at hA ⊢
  · exact Or.inl rfl
  · exact Or.inr (Or.inl rfl)
  · exact Or.inr (Or.inr (Or.inl rfl))
  · exact Or.inr (Or.inr (Or.inr (Or.inl rfl)))
  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl rfl))))
  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr rfl))))
  · exact absurd rfl hA

theorem not_pow_center_of_pslOrd_gt {A : SLG} {k : ℕ}
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 5 ∨ k = 6 ∨ k = 11)
    (hlt : k < pslOrd A) :
    ¬ (A ^ k = 1 ∨ A ^ k = negI) := fun hpow =>
  absurd (pslOrd_le_of_pow_center hk hpow) (not_le.mpr hlt)

private theorem pred_false_of_filter_card_eq_zero
    {α : Type} [Fintype α] [DecidableEq α]
    (p : α → Prop) [DecidablePred p]
    (hcard : ((Finset.univ : Finset α).filter p).card = 0)
    (x : α) : ¬ p x := by
  intro hx
  have hempty : (Finset.univ : Finset α).filter p = ∅ := Finset.card_eq_zero.mp hcard
  have hmem : x ∈ (Finset.univ : Finset α).filter p := by
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    exact hx
  rw [hempty] at hmem
  exact Finset.notMem_empty x hmem

theorem pslOrd_ne_zero (g : SLG) : pslOrd g ≠ 0 :=
  pred_false_of_filter_card_eq_zero (fun x : SLG => pslOrd x = 0) slCardOrder_zero g

public theorem pslOrd_eq_spectrum (A : SLG) :
    pslOrd A = 1 ∨ pslOrd A = 2 ∨ pslOrd A = 3 ∨
      pslOrd A = 5 ∨ pslOrd A = 6 ∨ pslOrd A = 11 := by
  have hA := pslOrd_ne_zero A
  exact pslOrd_eq_cases A hA

private theorem not_pow_one_of_pslOrd_eq {A : SLG} {n : ℕ}
    (hn : pslOrd A = n) (hne : n ≠ 1) :
    ¬ (A ^ 1 = 1 ∨ A ^ 1 = negI) := by
  intro hp
  have hle : pslOrd A ≤ 1 := pslOrd_le_of_pow_center (Or.inl rfl) hp
  have hge : 1 ≤ pslOrd A := Nat.pos_of_ne_zero (pslOrd_ne_zero A)
  have : pslOrd A = 1 := Nat.le_antisymm hle hge
  exact hne (hn.symm.trans this)

public theorem orderOf_mk_eq_pslOrd (A : SLG) :
    orderOf (QuotientGroup.mk A : PSL2F11) = pslOrd A := by
  have hA := pslOrd_ne_zero A
  have hcases := pslOrd_eq_cases A hA
  have hmk_of (k : ℕ) (hk : pslOrd A = k) (hk0 : k ≠ 0) :
      (QuotientGroup.mk A : PSL2F11) ^ k = 1 := by
    rw [mk_pow_eq_one_iff_pow_mem_center, mem_center_iff_one_or_negI]
    exact pslOrd_eq_one_or_pow_center A k hk hk0
  -- Case on the six possible orders; check proper divisors only
  rcases hcases with hn | hn | hn | hn | hn | hn
  · -- order 1: A = ±I so mk A = 1
    rw [hn]
    have hpow : A ^ 1 = 1 ∨ A ^ 1 = negI :=
      pslOrd_eq_one_or_pow_center A 1 hn (by decide)
    have hmk1 : (QuotientGroup.mk A : PSL2F11) = 1 := by
      rw [show (QuotientGroup.mk A : PSL2F11) = (QuotientGroup.mk A) ^ 1 by rw [pow_one]]
      exact hmk_of 1 hn (by decide)
    rw [hmk1, orderOf_one]
  · -- order 2
    rw [hn]
    refine (orderOf_eq_iff (by decide : 0 < 2)).2 ⟨hmk_of 2 hn (by decide), ?_⟩
    intro m hm_lt hm_pos hpowm
    have hm1 : m = 1 := by omega
    subst hm1
    have hAd : A ^ 1 = 1 ∨ A ^ 1 = negI :=
      (mem_center_iff_one_or_negI _).mp
        ((mk_pow_eq_one_iff_pow_mem_center A 1).mp hpowm)
    exact not_pow_one_of_pslOrd_eq hn (by decide : (2 : ℕ) ≠ 1) hAd
  · -- order 3
    rw [hn]
    refine (orderOf_eq_iff (by decide : 0 < 3)).2 ⟨hmk_of 3 hn (by decide), ?_⟩
    intro m hm_lt hm_pos hpowm
    have hm12 : m = 1 ∨ m = 2 := by omega
    have hAd : A ^ m = 1 ∨ A ^ m = negI :=
      (mem_center_iff_one_or_negI _).mp
        ((mk_pow_eq_one_iff_pow_mem_center A m).mp hpowm)
    rcases hm12 with rfl | rfl
    · exact not_pow_one_of_pslOrd_eq hn (by decide) hAd
    · exact (not_pow_center_of_pslOrd_gt (k := 2)
        (Or.inr (Or.inl rfl)) (by omega)) hAd
  · -- order 5: proper positive divisors of 5 are only 1
    rw [hn]
    refine (orderOf_eq_iff (by decide : 0 < 5)).2 ⟨hmk_of 5 hn (by decide), ?_⟩
    intro m hm_lt hm_pos hpowm
    have hord_m := orderOf_dvd_of_pow_eq_one hpowm
    have hord_5 := orderOf_dvd_of_pow_eq_one (hmk_of 5 hn (by decide))
    have hgcd : Nat.gcd m 5 = 1 := by
      have hprime : Nat.Prime 5 := by decide
      have hg : Nat.gcd m 5 ∣ 5 := Nat.gcd_dvd_right m 5
      have hgi := (Nat.dvd_prime hprime).mp hg
      exact hgi.resolve_right (by
        have : Nat.gcd m 5 ≤ m := Nat.gcd_le_left 5 hm_pos
        omega)
    have hord1 : orderOf (QuotientGroup.mk A : PSL2F11) ∣ 1 :=
      (Nat.dvd_gcd hord_m hord_5).trans (by rw [hgcd])
    have hmk1 : (QuotientGroup.mk A : PSL2F11) = 1 :=
      orderOf_eq_one_iff.mp (Nat.dvd_one.mp hord1)
    have hAcent : A = 1 ∨ A = negI :=
      (mem_center_iff_one_or_negI A).mp ((QuotientGroup.eq_one_iff _).mp hmk1)
    exact not_pow_one_of_pslOrd_eq hn (by decide)
      (by simpa [pow_one] using hAcent)
  · -- order 6
    rw [hn]
    refine (orderOf_eq_iff (by decide : 0 < 6)).2 ⟨hmk_of 6 hn (by decide), ?_⟩
    intro m hm_lt hm_pos hpowm
    have hord_m := orderOf_dvd_of_pow_eq_one hpowm
    have hord_6 := orderOf_dvd_of_pow_eq_one (hmk_of 6 hn (by decide))
    have hdvd : orderOf (QuotientGroup.mk A : PSL2F11) ∣ Nat.gcd m 6 :=
      Nat.dvd_gcd hord_m hord_6
    set d := Nat.gcd m 6 with hd_def
    have hdpos : 0 < d := Nat.gcd_pos_of_pos_left 6 hm_pos
    have hd_le : d ≤ m := Nat.le_of_dvd hm_pos (Nat.gcd_dvd_left m 6)
    have hd_lt : d < 6 := lt_of_le_of_lt hd_le hm_lt
    have hmk_d : (QuotientGroup.mk A : PSL2F11) ^ d = 1 :=
      orderOf_dvd_iff_pow_eq_one.mp hdvd
    have hAd' : A ^ d = 1 ∨ A ^ d = negI :=
      (mem_center_iff_one_or_negI _).mp
        ((mk_pow_eq_one_iff_pow_mem_center A d).mp hmk_d)
    have hd6 : d ∣ 6 := Nat.gcd_dvd_right m 6
    have hd123 : d = 1 ∨ d = 2 ∨ d = 3 := by
      have hdle6 : d ≤ 5 := Nat.lt_succ_iff.mp hd_lt
      interval_cases d
      · exact Or.inl rfl
      · exact Or.inr (Or.inl rfl)
      · exact Or.inr (Or.inr rfl)
      · exact absurd hd6 (by decide : ¬(4 ∣ 6))
      · exact absurd hd6 (by decide : ¬(5 ∣ 6))
    rcases hd123 with hd1 | hd2 | hd3
    · have hAd1 : A ^ 1 = 1 ∨ A ^ 1 = negI := by rwa [hd1] at hAd'
      exact not_pow_one_of_pslOrd_eq hn (by decide) hAd1
    · have hAd2 : A ^ 2 = 1 ∨ A ^ 2 = negI := by rwa [hd2] at hAd'
      exact (not_pow_center_of_pslOrd_gt (k := 2)
        (Or.inr (Or.inl rfl)) (by omega)) hAd2
    · have hAd3 : A ^ 3 = 1 ∨ A ^ 3 = negI := by rwa [hd3] at hAd'
      exact (not_pow_center_of_pslOrd_gt (k := 3)
        (Or.inr (Or.inr (Or.inl rfl))) (by omega)) hAd3
  · -- order 11
    rw [hn]
    refine (orderOf_eq_iff (by decide : 0 < 11)).2 ⟨hmk_of 11 hn (by decide), ?_⟩
    intro m hm_lt hm_pos hpowm
    have hord_m := orderOf_dvd_of_pow_eq_one hpowm
    have hord_11 := orderOf_dvd_of_pow_eq_one (hmk_of 11 hn (by decide))
    have hgcd : Nat.gcd m 11 = 1 := by
      have hprime : Nat.Prime 11 := Nat.prime_eleven
      have hg : Nat.gcd m 11 ∣ 11 := Nat.gcd_dvd_right m 11
      have hgi := (Nat.dvd_prime hprime).mp hg
      exact hgi.resolve_right (by
        have : Nat.gcd m 11 ≤ m := Nat.gcd_le_left 11 hm_pos
        omega)
    have hord1 : orderOf (QuotientGroup.mk A : PSL2F11) ∣ 1 :=
      (Nat.dvd_gcd hord_m hord_11).trans (by rw [hgcd])
    have hmk1 : (QuotientGroup.mk A : PSL2F11) = 1 :=
      orderOf_eq_one_iff.mp (Nat.dvd_one.mp hord1)
    have hAcent : A = 1 ∨ A = negI :=
      (mem_center_iff_one_or_negI A).mp ((QuotientGroup.eq_one_iff _).mp hmk1)
    exact not_pow_one_of_pslOrd_eq hn (by decide)
      (by simpa [pow_one] using hAcent)

/-! ## 2-to-1 quotient sum and PSL character norm

∑_A f(mk A) = 2 • ∑_g f(g) via fiber ≃ center, hence
∑_g χ(g)² = (1/2) · ∑_A χ(pslOrd A)² = 660. -/

@[expose] public noncomputable def lift (g : PSL2F11) : SLG :=
  Classical.choose (QuotientGroup.mk_surjective g)

theorem lift_spec (g : PSL2F11) : QuotientGroup.mk (lift g) = g :=
  Classical.choose_spec (QuotientGroup.mk_surjective g)

/-- Fiber of `mk` over `g` is equivariant to the center. -/
noncomputable def fiberEquiv (g : PSL2F11) :
    {A : SLG // QuotientGroup.mk A = g} ≃ Subgroup.center SLG where
  toFun := fun p =>
    ⟨(lift g)⁻¹ * p.1, by
      have hmk : QuotientGroup.mk ((lift g)⁻¹ * p.1) = (1 : PSL2F11) := by
        rw [QuotientGroup.mk_mul, QuotientGroup.mk_inv, p.2, lift_spec, inv_mul_cancel]
      exact (QuotientGroup.eq_one_iff _).mp hmk⟩
  invFun := fun z =>
    ⟨lift g * (z : SLG), by
      rw [QuotientGroup.mk_mul, (QuotientGroup.eq_one_iff _).mpr z.property, mul_one,
        lift_spec]⟩
  left_inv := fun p => by
    apply Subtype.ext
    change lift g * ((lift g)⁻¹ * p.1) = p.1
    group
  right_inv := fun z => by
    apply Subtype.ext
    change (lift g)⁻¹ * (lift g * (z : SLG)) = z
    group

theorem fiber_card (g : PSL2F11) :
    Fintype.card {A : SLG // QuotientGroup.mk A = g} = 2 := by
  rw [Fintype.card_congr (fiberEquiv g), ← Nat.card_eq_fintype_card, card_center_SL2]

/-- Pullback sum: ∑_A f(mk A) = 2 • ∑_g f(g). -/
public theorem sum_comp_mk {β : Type*} [AddCommMonoid β] (f : PSL2F11 → β) :
    (∑ A : SLG, f (QuotientGroup.mk A)) = 2 • (∑ g : PSL2F11, f g) := by
  classical
  let π : SLG → PSL2F11 := QuotientGroup.mk
  let e : (Σ g : PSL2F11, {A : SLG // π A = g}) ≃ SLG := Equiv.sigmaFiberEquiv π
  have h1 :
      (∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f (π (e p))) =
        (∑ A : SLG, f (π A)) :=
    Fintype.sum_equiv e (fun p => f (π (e p))) (fun A => f (π A)) (fun _ => rfl)
  have h2 : ∀ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f (π (e p)) = f p.1 := by
    intro p
    have he : e p = p.2.1 := rfl
    have hπ : π (e p) = p.1 := by rw [he]; exact p.2.2
    rw [hπ]
  have h3 :
      (∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f (π (e p))) =
        ∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f p.1 :=
    Fintype.sum_congr _ _ h2
  have h4 :
      (∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f p.1) =
        ∑ g : PSL2F11, ∑ _a : {A : SLG // π A = g}, f g := by
    rw [Fintype.sum_sigma]
  have h5 : ∀ g : PSL2F11,
      (∑ _a : {A : SLG // π A = g}, f g) = (2 : ℕ) • f g := by
    intro g
    have hc : Fintype.card {A : SLG // π A = g} = 2 := fiber_card g
    simp only [Finset.sum_const]
    have hcu : (Finset.univ : Finset {A : SLG // π A = g}).card =
        Fintype.card {A : SLG // π A = g} := rfl
    rw [hcu, hc]
  calc (∑ A : SLG, f (π A))
      = ∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f (π (e p)) := h1.symm
    _ = ∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f p.1 := h3
    _ = ∑ g : PSL2F11, ∑ _a : {A : SLG // π A = g}, f g := h4
    _ = ∑ g : PSL2F11, (2 : ℕ) • f g := Fintype.sum_congr _ _ h5
    _ = (2 : ℕ) • ∑ g : PSL2F11, f g := by simp only [Finset.smul_sum]

/-- Integer PSL character norm: ∑_g χ(orderOf g)² = 660. -/
public theorem chi10Int_sum_sq_psl :
    (∑ g : PSL2F11,
      (chi10Int (orderOf g) : ℤ) * chi10Int (orderOf g)) = 660 := by
  have hSL :
      (∑ A : SLG, (chi10Int (pslOrd A) : ℤ) * chi10Int (pslOrd A)) = 1320 := by
    simpa [slChiSumSq] using slChiSumSq_eq
  have hrew :
      (∑ A : SLG, (chi10Int (pslOrd A) : ℤ) * chi10Int (pslOrd A)) =
        (∑ A : SLG, (chi10Int (orderOf (QuotientGroup.mk A : PSL2F11)) : ℤ) *
          chi10Int (orderOf (QuotientGroup.mk A : PSL2F11))) := by
    refine Fintype.sum_congr _ _ fun A => by rw [orderOf_mk_eq_pslOrd A]
  rw [hrew] at hSL
  have hdouble :=
    sum_comp_mk (fun g : PSL2F11 =>
      (chi10Int (orderOf g) : ℤ) * chi10Int (orderOf g))
  have h2S : (2 : ℕ) • (∑ g : PSL2F11,
      (chi10Int (orderOf g) : ℤ) * chi10Int (orderOf g)) = 1320 :=
    hdouble.symm.trans hSL
  have h2S' : (2 : ℤ) * (∑ g : PSL2F11,
      (chi10Int (orderOf g) : ℤ) * chi10Int (orderOf g)) = 1320 := by
    simpa [two_nsmul, two_mul] using h2S
  linarith

/-! ## Character convolution ∑ χ(g)χ(g⁻¹k) = 66 χ(k)

Via SL double-cover: `convAt B = 132 · χ(pslOrd B)`. The identity is a class
function on PSL₂(F₁₁). Reduce to the eight inner conjugacy-class representatives
`1, Smat, el3, el5, el5², el6, Tmat, Tmat²` and discharge each raw M4 convolution
by ordinary kernel-checked `decide`. -/

/-- Card of PSL elements of order `n` = half the SL projective-order count. -/
theorem card_psl_order (n : ℕ) :
    Fintype.card {g : PSL2F11 // orderOf g = n} = slCardOrder n / 2 := by
  classical
  let OrderSL := {A : SLG // pslOrd A = n}
  let OrderPSL := {g : PSL2F11 // orderOf g = n}
  have hSL : Fintype.card OrderSL = slCardOrder n := by
    rw [Fintype.card_subtype]; rfl
  let e : OrderSL ≃ (Σ g : OrderPSL, {A : SLG // QuotientGroup.mk A = (g : PSL2F11)}) :=
    { toFun := fun ⟨A, hA⟩ =>
        ⟨⟨QuotientGroup.mk A, by rw [orderOf_mk_eq_pslOrd, hA]⟩, ⟨A, rfl⟩⟩
      invFun := fun ⟨⟨_g, hg⟩, ⟨A, hmk⟩⟩ =>
        ⟨A, by rw [← orderOf_mk_eq_pslOrd A, hmk, hg]⟩
      left_inv := fun ⟨A, _⟩ => rfl
      right_inv := fun ⟨⟨g, hg⟩, ⟨A, hmk⟩⟩ => by cases hmk; rfl }
  have hsig :
      Fintype.card (Σ g : OrderPSL, {A : SLG // QuotientGroup.mk A = (g : PSL2F11)}) =
        Fintype.card OrderPSL * 2 := by
    rw [Fintype.card_sigma]
    have h2 : ∀ g : OrderPSL,
        Fintype.card {A : SLG // QuotientGroup.mk A = (g : PSL2F11)} = 2 :=
      fun g => fiber_card (g : PSL2F11)
    simp only [h2]
    calc ∑ _g : OrderPSL, 2
        = (Finset.univ : Finset OrderPSL).card * 2 := by
          rw [Finset.sum_const, smul_eq_mul, mul_comm]
      _ = Fintype.card OrderPSL * 2 := rfl
  have hEq : slCardOrder n = Fintype.card {g : PSL2F11 // orderOf g = n} * 2 := by
    calc slCardOrder n
        = Fintype.card OrderSL := hSL.symm
      _ = Fintype.card (Σ g : OrderPSL, {A : SLG // QuotientGroup.mk A = (g : PSL2F11)}) :=
            Fintype.card_congr e
      _ = Fintype.card OrderPSL * 2 := hsig
  omega

public theorem card_psl_order_two :
    Fintype.card {g : PSL2F11 // orderOf g = 2} = 55 := by
  rw [card_psl_order, slCardOrder_two]

public theorem card_psl_order_three :
    Fintype.card {g : PSL2F11 // orderOf g = 3} = 110 := by
  rw [card_psl_order, slCardOrder_three]

theorem card_psl_order_five :
    Fintype.card {g : PSL2F11 // orderOf g = 5} = 264 := by
  rw [card_psl_order, slCardOrder_five]

public theorem card_psl_order_six :
    Fintype.card {g : PSL2F11 // orderOf g = 6} = 110 := by
  rw [card_psl_order, slCardOrder_six]

public theorem card_psl_order_eleven :
    Fintype.card {g : PSL2F11 // orderOf g = 11} = 120 := by
  rw [card_psl_order, slCardOrder_eleven]

/-! ### Representatives of the eight relevant conjugacy classes -/

@[expose] public def Smat : SLG := ⟨!![0, -1; 1, 0], by simp [Matrix.det_fin_two_of]⟩
theorem pslOrd_Smat : pslOrd Smat = 2 := by decide

@[expose] public def Tmat : SLG := ⟨!![1, 1; 0, 1], by simp [Matrix.det_fin_two_of]⟩
theorem pslOrd_Tmat : pslOrd Tmat = 11 := by decide

def el3 : SLG := ⟨!![0, -1; 1, -1], by simp [Matrix.det_fin_two_of]⟩
theorem pslOrd_el3 : pslOrd el3 = 3 := by decide

@[expose] public def el5 : SLG := ⟨!![0, -1; 1, 3], by simp [Matrix.det_fin_two_of]⟩
theorem pslOrd_el5 : pslOrd el5 = 5 := by decide

/-- Order-6 sample: `!![0,1; -1, 5]`. -/
def el6 : SLG := ⟨!![0, 1; -1, 5], by simp [Matrix.det_fin_two_of]⟩
theorem pslOrd_el6 : pslOrd el6 = 6 := by decide

theorem pslOrd_el5_pow_two : pslOrd (el5 ^ 2) = 5 := by decide
theorem pslOrd_Tmat_pow_two : pslOrd (Tmat ^ 2) = 11 := by decide

/-! ### Raw M4 convolution and representative checks -/

theorem card_allSL4 : allSL4.card = 1320 := by
  let e : SLG ≃ {m // m ∈ allSL4} :=
    { toFun := fun A => ⟨toM4 A, toM4_mem_allSL4 A⟩
      invFun := fun m => ofM4 m.1 m.2
      left_inv := fun A => ofM4_toM4 A
      right_inv := fun m => by
        apply Subtype.ext
        exact toM4_ofM4 m.1 m.2 }
  calc
    allSL4.card = Fintype.card {m // m ∈ allSL4} :=
      (Fintype.card_coe allSL4).symm
    _ = Fintype.card SLG := (Fintype.card_congr e).symm
    _ = Nat.card SLG := Fintype.card_eq_nat_card
    _ = 1320 := card_SL2_F11

/-! #### Determinant-eliminated weighted sums

The same determinant parametrization used for the order profile works for an
arbitrary additive weight.  It separates the `a = 0` cell (110 matrices) from
ten nonzero-`a` cells (121 candidate pairs each).  Later finite certificates
therefore reduce one cell per declaration at stock kernel limits.
-/

private theorem paramFull_b_ne_zero (b c d : F)
    (hdet : isSL4 (0, b, c, d) = true) : b ≠ 0 := by
  have h : -(b * c) = 1 := by
    exact of_decide_eq_true (by simpa [isSL4, det4] using hdet)
  intro hb
  subst b
  norm_num at h

private theorem paramFull_c_eq (b c d : F)
    (hdet : isSL4 (0, b, c, d) = true) : c = -(b ^ 9) := by
  have hb : b ≠ 0 := paramFull_b_ne_zero b c d hdet
  have h : -(b * c) = 1 := by
    exact of_decide_eq_true (by simpa [isSL4, det4] using hdet)
  apply mul_left_cancel₀ hb
  rw [mul_neg, mul_pow9_eq_one b hb]
  have hn := congrArg Neg.neg h
  simpa using hn

private theorem paramFull_d_eq (a b c d : F) (ha : a ≠ 0)
    (hdet : isSL4 (a, b, c, d) = true) :
    d = a ^ 9 * (1 + b * c) := by
  have h : a * d - b * c = 1 := by
    exact of_decide_eq_true (by simpa [isSL4, det4] using hdet)
  apply mul_left_cancel₀ ha
  rw [← mul_assoc, mul_pow9_eq_one a ha, one_mul]
  exact sub_eq_iff_eq_add.mp h

private abbrev RawSLParam := {m : M4 // isSL4 m = true}
private abbrev ZeroParam := {b : F // b ≠ 0} × F
private abbrev NZParam := {a : F // a ≠ 0} × (F × F)
private abbrev ParamSL := ZeroParam ⊕ NZParam

private def zeroMatrix (q : ZeroParam) : M4 :=
  (0, q.1.1, -(q.1.1 ^ 9), q.2)

private def nzMatrix (q : NZParam) : M4 :=
  (q.1.1, q.2.1, q.2.2, q.1.1 ^ 9 * (1 + q.2.1 * q.2.2))

private def paramMatrix : ParamSL → M4 := Sum.elim zeroMatrix nzMatrix

private def rawToParam (m : RawSLParam) : ParamSL := by
  rcases m with ⟨⟨a, b, c, d⟩, hm⟩
  by_cases ha : a = 0
  · subst a
    exact Sum.inl (⟨b, paramFull_b_ne_zero b c d hm⟩, d)
  · exact Sum.inr (⟨a, ha⟩, (b, c))

private def paramToRaw : ParamSL → RawSLParam
  | Sum.inl q => by
      rcases q with ⟨⟨b, hb⟩, d⟩
      refine ⟨zeroMatrix (⟨b, hb⟩, d), ?_⟩
      dsimp [zeroMatrix, isSL4, det4]
      apply decide_eq_true
      simpa only [zero_mul, zero_sub, mul_neg, neg_neg] using
        mul_pow9_eq_one b hb
  | Sum.inr q => by
      rcases q with ⟨⟨a, ha⟩, b, c⟩
      refine ⟨nzMatrix (⟨a, ha⟩, (b, c)), ?_⟩
      change decide (a * (a ^ 9 * (1 + b * c)) - b * c = 1) = true
      apply decide_eq_true
      rw [← mul_assoc, mul_pow9_eq_one a ha, one_mul]
      exact add_sub_cancel_right 1 (b * c)

private def rawParamEquiv : RawSLParam ≃ ParamSL where
  toFun := rawToParam
  invFun := paramToRaw
  left_inv := by
    rintro ⟨⟨a, b, c, d⟩, hm⟩
    apply Subtype.ext
    by_cases ha : a = 0
    · subst a
      simp only [rawToParam, paramToRaw, zeroMatrix]
      change (0, b, -(b ^ 9), d) = (0, b, c, d)
      rw [← paramFull_c_eq b c d hm]
    · simp only [rawToParam, ha, paramToRaw, nzMatrix]
      change (a, b, c, a ^ 9 * (1 + b * c)) = (a, b, c, d)
      rw [← paramFull_d_eq a b c d ha hm]
  right_inv := by
    intro q
    rcases q with q | q
    · rcases q with ⟨⟨b, hb⟩, d⟩
      simp [paramToRaw, zeroMatrix, rawToParam]
    · rcases q with ⟨⟨a, ha⟩, b, c⟩
      simp [paramToRaw, nzMatrix, rawToParam, ha]

private theorem paramToRaw_val (q : ParamSL) :
    (paramToRaw q).1 = paramMatrix q := by
  rcases q with q | q <;> rfl

private def attachRawEquiv : {m // m ∈ allSL4} ≃ RawSLParam :=
  Equiv.subtypeEquivRight (fun m ↦ by simp [allSL4])

theorem allSL4_sum_eq_param {A : Type} [AddCommMonoid A] (f : M4 → A) :
    allSL4.sum f =
      (∑ q : ZeroParam, f (zeroMatrix q)) +
      (∑ q : NZParam, f (nzMatrix q)) := by
  classical
  calc
    allSL4.sum f = ∑ m : {m // m ∈ allSL4}, f m :=
      (Finset.sum_attach allSL4 f).symm
    _ = ∑ m : RawSLParam, f m.1 := by
      exact Fintype.sum_equiv attachRawEquiv _ _ (fun _ ↦ rfl)
    _ = ∑ q : ParamSL, f (paramMatrix q) := by
      exact Fintype.sum_equiv rawParamEquiv _ _ (fun m ↦ by
        change f m.1 = f (paramMatrix (rawToParam m))
        have h := congrArg (fun r : RawSLParam ↦ f r.1) (rawParamEquiv.left_inv m)
        simpa only [rawParamEquiv, paramToRaw_val] using h.symm)
    _ = (∑ q : ZeroParam, f (zeroMatrix q)) +
        (∑ q : NZParam, f (nzMatrix q)) := by
      rw [Fintype.sum_sum_type]
      rfl

/-! A balanced `11 × 11` presentation of the determinant-one sum.

The product-type enumerator is intentionally flattened into two nested sums.
This keeps every finite certificate below the kernel's stock recursion limit. -/

private def zeroSum {A : Type} [AddCommMonoid A] (f : M4 → A) : A :=
  ∑ b : {b : F // b ≠ 0}, ∑ d : F, f (0, b.1, -(b.1 ^ 9), d)

private def nzSum {A : Type} [AddCommMonoid A] (a : F) (f : M4 → A) : A :=
  ∑ b : F, ∑ c : F, f (a, b, c, a ^ 9 * (1 + b * c))

theorem allSL4_sum_eq_nested {A : Type} [AddCommMonoid A] (f : M4 → A) :
    allSL4.sum f = zeroSum f +
      ∑ a : {a : F // a ≠ 0}, nzSum a.1 f := by
  rw [allSL4_sum_eq_param]
  simp only [zeroSum, nzSum, Fintype.sum_prod_type, zeroMatrix, nzMatrix]

private def nzIndex (i : Fin 10) : {a : F // a ≠ 0} :=
  ⟨(i.1 + 1 : ℕ), by fin_cases i <;> decide⟩

private def nzIndexEquiv : Fin 10 ≃ {a : F // a ≠ 0} :=
  Equiv.ofBijective nzIndex (by decide)

theorem sum_nonzero_eq_of_cells {A : Type} [AddCommMonoid A]
    (g : {a : F // a ≠ 0} → A) (table : Fin 10 → A)
    (hcell : ∀ i, g (nzIndex i) = table i) :
    (∑ a : {a : F // a ≠ 0}, g a) = ∑ i : Fin 10, table i := by
  exact (Fintype.sum_equiv nzIndexEquiv table g (fun i ↦ (hcell i).symm)).symm

/-- Raw convolution ∑_{A ∈ SL} χ(ord A)·χ(ord(A⁻¹B)). -/
def conv4 (B : M4) : ℤ :=
  allSL4.sum fun A => chi10Int (pslOrd4 A) * chi10Int (pslOrd4 (mul4 (inv4 A) B))

def expected4 (B : M4) : ℤ := 132 * chi10Int (pslOrd4 B)

/-- Convolution on SL: ∑_A χ(A)·χ(A⁻¹B). -/
def convAt (B : SLG) : ℤ :=
  ∑ A : SLG, chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * B))

private def term4 (B : M4) (A : M4) : ℤ :=
  chi10Int (pslOrd4 A) * chi10Int (pslOrd4 (mul4 (inv4 A) B))

private def convWeight (B : M4) : M4 → ℤ := term4 B

theorem convAt_eq_conv4 (B : SLG) : convAt B = conv4 (toM4 B) := by
  classical
  unfold convAt conv4
  let e : SLG ≃ {m // m ∈ allSL4} :=
    { toFun := fun A => ⟨toM4 A, toM4_mem_allSL4 A⟩
      invFun := fun m => ofM4 m.1 m.2
      left_inv := fun A => ofM4_toM4 A
      right_inv := fun m => by
        apply Subtype.ext
        exact toM4_ofM4 m.1 m.2 }
  have h1 :
      (∑ A : SLG, chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * B))) =
        ∑ m : {m // m ∈ allSL4}, term4 (toM4 B) m.1 := by
    refine Fintype.sum_equiv e _ _ fun A => ?_
    dsimp [e, term4]
    have hord1 := pslOrd_eq_pslOrd4 A
    have hord2 : pslOrd (A⁻¹ * B) =
        pslOrd4 (mul4 (inv4 (toM4 A)) (toM4 B)) := by
      rw [pslOrd_eq_pslOrd4, toM4_mul, toM4_inv]
    rw [hord1, hord2]
  have h2 :
      (∑ m : {m // m ∈ allSL4}, term4 (toM4 B) m.1) =
        allSL4.sum (term4 (toM4 B)) := by
    change (∑ m ∈ allSL4.attach, term4 (toM4 B) ↑m) =
      allSL4.sum (term4 (toM4 B))
    exact Finset.sum_attach allSL4 (term4 (toM4 B))
  exact h1.trans h2

/-! #### Kernel-checked representative convolutions -/

private theorem convOne_zero : zeroSum (convWeight one4) = 100 := by decide
private theorem convOne_nz1 : nzSum 1 (convWeight one4) = 210 := by decide
private theorem convOne_nz2 : nzSum 2 (convWeight one4) = 100 := by decide
private theorem convOne_nz3 : nzSum 3 (convWeight one4) = 100 := by decide
private theorem convOne_nz4 : nzSum 4 (convWeight one4) = 100 := by decide
private theorem convOne_nz5 : nzSum 5 (convWeight one4) = 100 := by decide
private theorem convOne_nz6 : nzSum 6 (convWeight one4) = 100 := by decide
private theorem convOne_nz7 : nzSum 7 (convWeight one4) = 100 := by decide
private theorem convOne_nz8 : nzSum 8 (convWeight one4) = 100 := by decide
private theorem convOne_nz9 : nzSum 9 (convWeight one4) = 100 := by decide
private theorem convOne_nz10 : nzSum 10 (convWeight one4) = 210 := by decide

private def convOneTable : Fin 10 → ℤ :=
  ![210, 100, 100, 100, 100, 100, 100, 100, 100, 210]

private theorem convOne_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (convWeight one4) = convOneTable i := by
  fin_cases i
  · exact convOne_nz1
  · exact convOne_nz2
  · exact convOne_nz3
  · exact convOne_nz4
  · exact convOne_nz5
  · exact convOne_nz6
  · exact convOne_nz7
  · exact convOne_nz8
  · exact convOne_nz9
  · exact convOne_nz10

theorem conv4_one4 : conv4 one4 = 1320 := by
  change allSL4.sum (convWeight one4) = 1320
  rw [allSL4_sum_eq_nested, convOne_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (convWeight one4)) convOneTable convOne_cells]
  decide

private theorem convSmat_zero : zeroSum (convWeight (toM4 Smat)) = 44 := by decide
private theorem convSmat_nz1 : nzSum 1 (convWeight (toM4 Smat)) = 44 := by decide
private theorem convSmat_nz2 : nzSum 2 (convWeight (toM4 Smat)) = 6 := by decide
private theorem convSmat_nz3 : nzSum 3 (convWeight (toM4 Smat)) = 30 := by decide
private theorem convSmat_nz4 : nzSum 4 (convWeight (toM4 Smat)) = 28 := by decide
private theorem convSmat_nz5 : nzSum 5 (convWeight (toM4 Smat)) = 2 := by decide
private theorem convSmat_nz6 : nzSum 6 (convWeight (toM4 Smat)) = 2 := by decide
private theorem convSmat_nz7 : nzSum 7 (convWeight (toM4 Smat)) = 28 := by decide
private theorem convSmat_nz8 : nzSum 8 (convWeight (toM4 Smat)) = 30 := by decide
private theorem convSmat_nz9 : nzSum 9 (convWeight (toM4 Smat)) = 6 := by decide
private theorem convSmat_nz10 : nzSum 10 (convWeight (toM4 Smat)) = 44 := by decide

private def convSmatTable : Fin 10 → ℤ := ![44, 6, 30, 28, 2, 2, 28, 30, 6, 44]

private theorem convSmat_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (convWeight (toM4 Smat)) = convSmatTable i := by
  fin_cases i
  · exact convSmat_nz1
  · exact convSmat_nz2
  · exact convSmat_nz3
  · exact convSmat_nz4
  · exact convSmat_nz5
  · exact convSmat_nz6
  · exact convSmat_nz7
  · exact convSmat_nz8
  · exact convSmat_nz9
  · exact convSmat_nz10

theorem conv4_Smat : conv4 (toM4 Smat) = 264 := by
  change allSL4.sum (convWeight (toM4 Smat)) = 264
  rw [allSL4_sum_eq_nested, convSmat_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (convWeight (toM4 Smat))) convSmatTable convSmat_cells]
  decide

private theorem convel3_zero : zeroSum (convWeight (toM4 el3)) = 22 := by decide
private theorem convel3_nz1 : nzSum 1 (convWeight (toM4 el3)) = 15 := by decide
private theorem convel3_nz2 : nzSum 2 (convWeight (toM4 el3)) = 11 := by decide
private theorem convel3_nz3 : nzSum 3 (convWeight (toM4 el3)) = 3 := by decide
private theorem convel3_nz4 : nzSum 4 (convWeight (toM4 el3)) = 17 := by decide
private theorem convel3_nz5 : nzSum 5 (convWeight (toM4 el3)) = 9 := by decide
private theorem convel3_nz6 : nzSum 6 (convWeight (toM4 el3)) = 9 := by decide
private theorem convel3_nz7 : nzSum 7 (convWeight (toM4 el3)) = 17 := by decide
private theorem convel3_nz8 : nzSum 8 (convWeight (toM4 el3)) = 3 := by decide
private theorem convel3_nz9 : nzSum 9 (convWeight (toM4 el3)) = 11 := by decide
private theorem convel3_nz10 : nzSum 10 (convWeight (toM4 el3)) = 15 := by decide

private def convel3Table : Fin 10 → ℤ := ![15, 11, 3, 17, 9, 9, 17, 3, 11, 15]

private theorem convel3_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (convWeight (toM4 el3)) = convel3Table i := by
  fin_cases i
  · exact convel3_nz1
  · exact convel3_nz2
  · exact convel3_nz3
  · exact convel3_nz4
  · exact convel3_nz5
  · exact convel3_nz6
  · exact convel3_nz7
  · exact convel3_nz8
  · exact convel3_nz9
  · exact convel3_nz10

theorem conv4_el3 : conv4 (toM4 el3) = 132 := by
  change allSL4.sum (convWeight (toM4 el3)) = 132
  rw [allSL4_sum_eq_nested, convel3_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (convWeight (toM4 el3))) convel3Table convel3_cells]
  decide

private theorem convel5_zero : zeroSum (convWeight (toM4 el5)) = 0 := by decide
private theorem convel5_nz1 : nzSum 1 (convWeight (toM4 el5)) = 4 := by decide
private theorem convel5_nz2 : nzSum 2 (convWeight (toM4 el5)) = -6 := by decide
private theorem convel5_nz3 : nzSum 3 (convWeight (toM4 el5)) = -1 := by decide
private theorem convel5_nz4 : nzSum 4 (convWeight (toM4 el5)) = -1 := by decide
private theorem convel5_nz5 : nzSum 5 (convWeight (toM4 el5)) = 4 := by decide
private theorem convel5_nz6 : nzSum 6 (convWeight (toM4 el5)) = 4 := by decide
private theorem convel5_nz7 : nzSum 7 (convWeight (toM4 el5)) = -1 := by decide
private theorem convel5_nz8 : nzSum 8 (convWeight (toM4 el5)) = -1 := by decide
private theorem convel5_nz9 : nzSum 9 (convWeight (toM4 el5)) = -6 := by decide
private theorem convel5_nz10 : nzSum 10 (convWeight (toM4 el5)) = 4 := by decide

private def convel5Table : Fin 10 → ℤ := ![4, -6, -1, -1, 4, 4, -1, -1, -6, 4]

private theorem convel5_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (convWeight (toM4 el5)) = convel5Table i := by
  fin_cases i
  · exact convel5_nz1
  · exact convel5_nz2
  · exact convel5_nz3
  · exact convel5_nz4
  · exact convel5_nz5
  · exact convel5_nz6
  · exact convel5_nz7
  · exact convel5_nz8
  · exact convel5_nz9
  · exact convel5_nz10

theorem conv4_el5 : conv4 (toM4 el5) = 0 := by
  change allSL4.sum (convWeight (toM4 el5)) = 0
  rw [allSL4_sum_eq_nested, convel5_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (convWeight (toM4 el5))) convel5Table convel5_cells]
  decide

private theorem convel5_pow_two_zero :
    zeroSum (convWeight (toM4 (el5 ^ 2))) = -12 := by decide
private theorem convel5_pow_two_nz1 :
    nzSum 1 (convWeight (toM4 (el5 ^ 2))) = 0 := by decide
private theorem convel5_pow_two_nz2 :
    nzSum 2 (convWeight (toM4 (el5 ^ 2))) = 13 := by decide
private theorem convel5_pow_two_nz3 :
    nzSum 3 (convWeight (toM4 (el5 ^ 2))) = -32 := by decide
private theorem convel5_pow_two_nz4 :
    nzSum 4 (convWeight (toM4 (el5 ^ 2))) = 9 := by decide
private theorem convel5_pow_two_nz5 :
    nzSum 5 (convWeight (toM4 (el5 ^ 2))) = 16 := by decide
private theorem convel5_pow_two_nz6 :
    nzSum 6 (convWeight (toM4 (el5 ^ 2))) = 16 := by decide
private theorem convel5_pow_two_nz7 :
    nzSum 7 (convWeight (toM4 (el5 ^ 2))) = 9 := by decide
private theorem convel5_pow_two_nz8 :
    nzSum 8 (convWeight (toM4 (el5 ^ 2))) = -32 := by decide
private theorem convel5_pow_two_nz9 :
    nzSum 9 (convWeight (toM4 (el5 ^ 2))) = 13 := by decide
private theorem convel5_pow_two_nz10 :
    nzSum 10 (convWeight (toM4 (el5 ^ 2))) = 0 := by decide

private def convel5_pow_twoTable : Fin 10 → ℤ :=
  ![0, 13, -32, 9, 16, 16, 9, -32, 13, 0]

private theorem convel5_pow_two_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (convWeight (toM4 (el5 ^ 2))) =
      convel5_pow_twoTable i := by
  fin_cases i
  · exact convel5_pow_two_nz1
  · exact convel5_pow_two_nz2
  · exact convel5_pow_two_nz3
  · exact convel5_pow_two_nz4
  · exact convel5_pow_two_nz5
  · exact convel5_pow_two_nz6
  · exact convel5_pow_two_nz7
  · exact convel5_pow_two_nz8
  · exact convel5_pow_two_nz9
  · exact convel5_pow_two_nz10

theorem conv4_el5_pow_two : conv4 (toM4 (el5 ^ 2)) = 0 := by
  change allSL4.sum (convWeight (toM4 (el5 ^ 2))) = 0
  rw [allSL4_sum_eq_nested, convel5_pow_two_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (convWeight (toM4 (el5 ^ 2))))
      convel5_pow_twoTable convel5_pow_two_cells]
  decide

private theorem convel6_zero : zeroSum (convWeight (toM4 el6)) = -22 := by decide
private theorem convel6_nz1 : nzSum 1 (convWeight (toM4 el6)) = -31 := by decide
private theorem convel6_nz2 : nzSum 2 (convWeight (toM4 el6)) = 8 := by decide
private theorem convel6_nz3 : nzSum 3 (convWeight (toM4 el6)) = -4 := by decide
private theorem convel6_nz4 : nzSum 4 (convWeight (toM4 el6)) = -23 := by decide
private theorem convel6_nz5 : nzSum 5 (convWeight (toM4 el6)) = -5 := by decide
private theorem convel6_nz6 : nzSum 6 (convWeight (toM4 el6)) = -5 := by decide
private theorem convel6_nz7 : nzSum 7 (convWeight (toM4 el6)) = -23 := by decide
private theorem convel6_nz8 : nzSum 8 (convWeight (toM4 el6)) = -4 := by decide
private theorem convel6_nz9 : nzSum 9 (convWeight (toM4 el6)) = 8 := by decide
private theorem convel6_nz10 : nzSum 10 (convWeight (toM4 el6)) = -31 := by decide

private def convel6Table : Fin 10 → ℤ := ![-31, 8, -4, -23, -5, -5, -23, -4, 8, -31]

private theorem convel6_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (convWeight (toM4 el6)) = convel6Table i := by
  fin_cases i
  · exact convel6_nz1
  · exact convel6_nz2
  · exact convel6_nz3
  · exact convel6_nz4
  · exact convel6_nz5
  · exact convel6_nz6
  · exact convel6_nz7
  · exact convel6_nz8
  · exact convel6_nz9
  · exact convel6_nz10

theorem conv4_el6 : conv4 (toM4 el6) = -132 := by
  change allSL4.sum (convWeight (toM4 el6)) = -132
  rw [allSL4_sum_eq_nested, convel6_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (convWeight (toM4 el6))) convel6Table convel6_cells]
  decide

private theorem convTmat_zero : zeroSum (convWeight (toM4 Tmat)) = -10 := by decide
private theorem convTmat_nz1 : nzSum 1 (convWeight (toM4 Tmat)) = -21 := by decide
private theorem convTmat_nz2 : nzSum 2 (convWeight (toM4 Tmat)) = -10 := by decide
private theorem convTmat_nz3 : nzSum 3 (convWeight (toM4 Tmat)) = -10 := by decide
private theorem convTmat_nz4 : nzSum 4 (convWeight (toM4 Tmat)) = -10 := by decide
private theorem convTmat_nz5 : nzSum 5 (convWeight (toM4 Tmat)) = -10 := by decide
private theorem convTmat_nz6 : nzSum 6 (convWeight (toM4 Tmat)) = -10 := by decide
private theorem convTmat_nz7 : nzSum 7 (convWeight (toM4 Tmat)) = -10 := by decide
private theorem convTmat_nz8 : nzSum 8 (convWeight (toM4 Tmat)) = -10 := by decide
private theorem convTmat_nz9 : nzSum 9 (convWeight (toM4 Tmat)) = -10 := by decide
private theorem convTmat_nz10 : nzSum 10 (convWeight (toM4 Tmat)) = -21 := by decide

private def convTmatTable : Fin 10 → ℤ :=
  ![-21, -10, -10, -10, -10, -10, -10, -10, -10, -21]

private theorem convTmat_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (convWeight (toM4 Tmat)) = convTmatTable i := by
  fin_cases i
  · exact convTmat_nz1
  · exact convTmat_nz2
  · exact convTmat_nz3
  · exact convTmat_nz4
  · exact convTmat_nz5
  · exact convTmat_nz6
  · exact convTmat_nz7
  · exact convTmat_nz8
  · exact convTmat_nz9
  · exact convTmat_nz10

theorem conv4_Tmat : conv4 (toM4 Tmat) = -132 := by
  change allSL4.sum (convWeight (toM4 Tmat)) = -132
  rw [allSL4_sum_eq_nested, convTmat_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (convWeight (toM4 Tmat))) convTmatTable convTmat_cells]
  decide

private theorem convTmat_pow_two_zero :
    zeroSum (convWeight (toM4 (Tmat ^ 2))) = -10 := by decide
private theorem convTmat_pow_two_nz1 :
    nzSum 1 (convWeight (toM4 (Tmat ^ 2))) = -21 := by decide
private theorem convTmat_pow_two_nz2 :
    nzSum 2 (convWeight (toM4 (Tmat ^ 2))) = -10 := by decide
private theorem convTmat_pow_two_nz3 :
    nzSum 3 (convWeight (toM4 (Tmat ^ 2))) = -10 := by decide
private theorem convTmat_pow_two_nz4 :
    nzSum 4 (convWeight (toM4 (Tmat ^ 2))) = -10 := by decide
private theorem convTmat_pow_two_nz5 :
    nzSum 5 (convWeight (toM4 (Tmat ^ 2))) = -10 := by decide
private theorem convTmat_pow_two_nz6 :
    nzSum 6 (convWeight (toM4 (Tmat ^ 2))) = -10 := by decide
private theorem convTmat_pow_two_nz7 :
    nzSum 7 (convWeight (toM4 (Tmat ^ 2))) = -10 := by decide
private theorem convTmat_pow_two_nz8 :
    nzSum 8 (convWeight (toM4 (Tmat ^ 2))) = -10 := by decide
private theorem convTmat_pow_two_nz9 :
    nzSum 9 (convWeight (toM4 (Tmat ^ 2))) = -10 := by decide
private theorem convTmat_pow_two_nz10 :
    nzSum 10 (convWeight (toM4 (Tmat ^ 2))) = -21 := by decide

private def convTmat_pow_twoTable : Fin 10 → ℤ :=
  ![-21, -10, -10, -10, -10, -10, -10, -10, -10, -21]

private theorem convTmat_pow_two_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (convWeight (toM4 (Tmat ^ 2))) =
      convTmat_pow_twoTable i := by
  fin_cases i
  · exact convTmat_pow_two_nz1
  · exact convTmat_pow_two_nz2
  · exact convTmat_pow_two_nz3
  · exact convTmat_pow_two_nz4
  · exact convTmat_pow_two_nz5
  · exact convTmat_pow_two_nz6
  · exact convTmat_pow_two_nz7
  · exact convTmat_pow_two_nz8
  · exact convTmat_pow_two_nz9
  · exact convTmat_pow_two_nz10

theorem conv4_Tmat_pow_two : conv4 (toM4 (Tmat ^ 2)) = -132 := by
  change allSL4.sum (convWeight (toM4 (Tmat ^ 2))) = -132
  rw [allSL4_sum_eq_nested, convTmat_pow_two_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (convWeight (toM4 (Tmat ^ 2))))
      convTmat_pow_twoTable convTmat_pow_two_cells]
  decide

theorem convAt_one_rep : convAt 1 = 1320 := by
  rw [convAt_eq_conv4, toM4_one, conv4_one4]

theorem convAt_Smat : convAt Smat = 264 := by
  rw [convAt_eq_conv4, conv4_Smat]

theorem convAt_el3 : convAt el3 = 132 := by
  rw [convAt_eq_conv4, conv4_el3]

theorem convAt_el5 : convAt el5 = 0 := by
  rw [convAt_eq_conv4, conv4_el5]

theorem convAt_el5_pow_two : convAt (el5 ^ 2) = 0 := by
  rw [convAt_eq_conv4, conv4_el5_pow_two]

theorem convAt_el6 : convAt el6 = -132 := by
  rw [convAt_eq_conv4, conv4_el6]

theorem convAt_Tmat : convAt Tmat = -132 := by
  rw [convAt_eq_conv4, conv4_Tmat]

theorem convAt_Tmat_pow_two : convAt (Tmat ^ 2) = -132 := by
  rw [convAt_eq_conv4, conv4_Tmat_pow_two]

/-! ### Conjugacy and sign invariance of `pslOrd` / `convAt` -/

theorem negI_mul_self : negI * negI = (1 : SLG) := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [negI, Matrix.mul_apply, Matrix.one_apply]

theorem negI_inv : negI⁻¹ = negI :=
  inv_eq_of_mul_eq_one_left negI_mul_self

theorem negI_comm (A : SLG) : negI * A = A * negI :=
  (Subgroup.mem_center_iff.mp negI_mem_center A).symm

theorem negI_mul_assoc (A B : SLG) : negI * (A * B) = (negI * A) * B :=
  (mul_assoc negI A B).symm

/-- PSL images equal iff the SL lifts differ by at most a central sign. -/
theorem mk_eq_mk_iff_pm (A B : SLG) :
    (QuotientGroup.mk A : PSL2F11) = QuotientGroup.mk B ↔
      A = B ∨ A = negI * B := by
  constructor
  · intro h
    have hcent : A⁻¹ * B ∈ Subgroup.center SLG := (QuotientGroup.eq).mp h
    rcases (mem_center_iff_one_or_negI _).mp hcent with h1 | hneg
    · left
      -- A⁻¹ * B = 1 ⇒ A = B
      exact inv_mul_eq_one.mp h1
    · right
      -- A⁻¹ * B = negI ⇒ B = A * negI ⇒ A = negI * B
      have hB : B = A * negI := by
        have := congrArg (fun z => A * z) hneg
        simpa [mul_assoc, mul_inv_cancel, one_mul] using this
      calc A = A * (1 : SLG) := (mul_one A).symm
        _ = A * (negI * negI) := by rw [negI_mul_self]
        _ = (A * negI) * negI := by group
        _ = B * negI := by rw [hB]
        _ = negI * B := (negI_comm B).symm
  · intro h
    rcases h with rfl | hneg
    · rfl
    · rw [hneg, QuotientGroup.mk_mul]
      have : (QuotientGroup.mk negI : PSL2F11) = 1 :=
        (QuotientGroup.eq_one_iff _).mpr negI_mem_center
      rw [this, one_mul]

theorem orderOf_conj_apply {G : Type*} [Group G] (c x : G) :
    orderOf (c * x * c⁻¹) = orderOf x := by
  have hpow : ∀ n : ℕ, (c * x * c⁻¹) ^ n = c * (x ^ n) * c⁻¹ := by
    intro n
    induction n with
    | zero => simp
    | succ n ih =>
      rw [pow_succ, pow_succ, ih]
      simp [mul_assoc]
  apply Eq.symm
  rw [orderOf_eq_orderOf_iff]
  intro n
  constructor
  · intro hx
    rw [hpow, hx]
    group
  · intro hconj
    have : c * (x ^ n) * c⁻¹ = 1 := by rwa [hpow] at hconj
    have := congrArg (fun z => c⁻¹ * z * c) this
    simpa [mul_assoc, inv_mul_cancel, mul_inv_cancel, one_mul, mul_one] using this

theorem pslOrd_conj (C A : SLG) : pslOrd (C * A * C⁻¹) = pslOrd A := by
  rw [← orderOf_mk_eq_pslOrd, ← orderOf_mk_eq_pslOrd]
  have hmk :
      (QuotientGroup.mk (C * A * C⁻¹) : PSL2F11) =
        QuotientGroup.mk C * QuotientGroup.mk A * (QuotientGroup.mk C)⁻¹ := by
    simp only [QuotientGroup.mk_mul, QuotientGroup.mk_inv]
  rw [hmk, orderOf_conj_apply]

theorem pslOrd_mul_negI (A : SLG) : pslOrd (negI * A) = pslOrd A := by
  rw [← orderOf_mk_eq_pslOrd, ← orderOf_mk_eq_pslOrd]
  have hmk : (QuotientGroup.mk (negI * A) : PSL2F11) = QuotientGroup.mk A := by
    rw [QuotientGroup.mk_mul]
    have : (QuotientGroup.mk negI : PSL2F11) = 1 :=
      (QuotientGroup.eq_one_iff _).mpr negI_mem_center
    rw [this, one_mul]
  rw [hmk]

theorem convAt_conj (C B : SLG) : convAt (C * B * C⁻¹) = convAt B := by
  classical
  let e : SLG ≃ SLG := (MulAut.conj C).toEquiv
  have he : ∀ A : SLG, e A = C * A * C⁻¹ := fun A => MulAut.conj_apply C A
  unfold convAt
  have hsum :
      (∑ A : SLG, chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * B))) =
        ∑ A : SLG, chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * (C * B * C⁻¹))) := by
    refine Fintype.sum_equiv e
      (fun A => chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * B)))
      (fun A => chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * (C * B * C⁻¹))))
      fun A => ?_
    have hre : (e A)⁻¹ * (C * B * C⁻¹) = C * (A⁻¹ * B) * C⁻¹ := by
      simp only [he]
      group
    calc chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * B))
        = chi10Int (pslOrd (e A)) * chi10Int (pslOrd (A⁻¹ * B)) := by
            rw [he A, pslOrd_conj]
      _ = chi10Int (pslOrd (e A)) * chi10Int (pslOrd ((e A)⁻¹ * (C * B * C⁻¹))) := by
            rw [hre, pslOrd_conj]
  exact hsum.symm

theorem convAt_mul_negI (B : SLG) : convAt (negI * B) = convAt B := by
  classical
  let e : SLG ≃ SLG :=
    { toFun := fun A => negI * A
      invFun := fun A => negI * A
      left_inv := fun A => by
        calc negI * (negI * A) = (negI * negI) * A := by rw [mul_assoc]
          _ = 1 * A := by rw [negI_mul_self]
          _ = A := one_mul A
      right_inv := fun A => by
        calc negI * (negI * A) = (negI * negI) * A := by rw [mul_assoc]
          _ = 1 * A := by rw [negI_mul_self]
          _ = A := one_mul A }
  unfold convAt
  have hsum :
      (∑ A : SLG, chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * B))) =
        ∑ A : SLG, chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * (negI * B))) := by
    refine Fintype.sum_equiv e
      (fun A => chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * B)))
      (fun A => chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * (negI * B))))
      fun A => ?_
    dsimp [e]
    have hre : (negI * A)⁻¹ * (negI * B) = A⁻¹ * B := by
      calc (negI * A)⁻¹ * (negI * B)
          = (A⁻¹ * negI⁻¹) * (negI * B) := by rw [_root_.mul_inv_rev]
        _ = (A⁻¹ * negI) * (negI * B) := by rw [negI_inv]
        _ = A⁻¹ * (negI * (negI * B)) := by group
        _ = A⁻¹ * ((negI * negI) * B) := by group
        _ = A⁻¹ * (1 * B) := by rw [negI_mul_self]
        _ = A⁻¹ * B := by group
    rw [pslOrd_mul_negI, hre]
  exact hsum.symm

theorem eq_negI_mul_of_conj_eq {X B : SLG} (h : X = negI * B) :
    B = negI * X := by
  calc B = 1 * B := (one_mul B).symm
    _ = (negI * negI) * B := by rw [negI_mul_self]
    _ = negI * (negI * B) := by group
    _ = negI * X := by rw [h]

theorem convAt_eq_of_psl_isConj {B B' : SLG}
    (h : IsConj (QuotientGroup.mk B : PSL2F11) (QuotientGroup.mk B')) :
    convAt B = convAt B' := by
  obtain ⟨c, hc⟩ := isConj_iff.mp h
  obtain ⟨C, rfl⟩ := QuotientGroup.mk_surjective c
  have hmk :
      (QuotientGroup.mk (C * B * C⁻¹) : PSL2F11) = QuotientGroup.mk B' := by
    simpa [QuotientGroup.mk_mul, QuotientGroup.mk_inv] using hc
  rcases (mk_eq_mk_iff_pm (C * B * C⁻¹) B').mp hmk with hEq | hNeg
  · rw [← hEq, convAt_conj]
  · have hB' : B' = negI * (C * B * C⁻¹) := eq_negI_mul_of_conj_eq hNeg
    rw [hB', convAt_mul_negI, convAt_conj]

/-! ### PSL centralizer via raw commuting lifts -/

/-- Entrywise negation on M4 (multiply by `-I`). -/
def neg4 (B : M4) : M4 := (-B.1, -B.2.1, -B.2.2.1, -B.2.2.2)

theorem toM4_negI_mul (B : SLG) : toM4 (negI * B) = neg4 (toM4 B) := by
  apply Prod.ext
  · simp [toM4, neg4, negI, SpecialLinearGroup.coe_mul, Matrix.mul_apply, Matrix.one_apply]
  apply Prod.ext
  · simp [toM4, neg4, negI, SpecialLinearGroup.coe_mul, Matrix.mul_apply, Matrix.one_apply]
  apply Prod.ext
  · simp [toM4, neg4, negI, SpecialLinearGroup.coe_mul, Matrix.mul_apply, Matrix.one_apply]
  · simp [toM4, neg4, negI, SpecialLinearGroup.coe_mul, Matrix.mul_apply, Matrix.one_apply]

/-- SL matrices whose PSL image centralizes `mk B`: commute or anticommute via `-I`. -/
def pslCentLifts4 (B : M4) : Finset M4 :=
  allSL4.filter (fun A =>
    let AB := mul4 A B
    decide (AB = mul4 B A ∨ AB = mul4 (neg4 B) A))

private def centWeight (B A : M4) : ℕ :=
  if mul4 A B = mul4 B A ∨ mul4 A B = mul4 (neg4 B) A then 1 else 0

theorem pslCentLifts4_card_eq_param (B : M4) :
    (pslCentLifts4 B).card =
      (∑ q : ZeroParam, centWeight B (zeroMatrix q)) +
      (∑ q : NZParam, centWeight B (nzMatrix q)) := by
  rw [← allSL4_sum_eq_param (centWeight B)]
  classical
  unfold pslCentLifts4
  rw [Finset.card_eq_sum_ones, Finset.sum_filter]
  apply Finset.sum_congr rfl
  intro A _
  by_cases h : mul4 A B = mul4 B A ∨ mul4 A B = mul4 (neg4 B) A
  · simp [centWeight, h]
  · simp [centWeight, h]

theorem pslCentLifts4_card_eq_nested (B : M4) :
    (pslCentLifts4 B).card = zeroSum (centWeight B) +
      ∑ a : {a : F // a ≠ 0}, nzSum a.1 (centWeight B) := by
  rw [pslCentLifts4_card_eq_param]
  simp only [zeroSum, nzSum, Fintype.sum_prod_type, zeroMatrix, nzMatrix]

theorem mul_eq_iff_conj (A B : SLG) :
    A * B = B * A ↔ A * B * A⁻¹ = B := by
  constructor
  · intro h
    calc A * B * A⁻¹ = B * A * A⁻¹ := by rw [h]
      _ = B := by group
  · intro h
    calc A * B = (A * B * A⁻¹) * A := by group
      _ = B * A := by rw [h]

theorem mul_eq_neg_iff_conj (A B : SLG) :
    A * B = (negI * B) * A ↔ A * B * A⁻¹ = negI * B := by
  constructor
  · intro h
    calc A * B * A⁻¹ = (negI * B) * A * A⁻¹ := by rw [h]
      _ = negI * B := by group
  · intro h
    calc A * B = (A * B * A⁻¹) * A := by group
      _ = (negI * B) * A := by rw [h]

theorem mk_mem_centralizer_iff (A B : SLG) :
    (QuotientGroup.mk A : PSL2F11) ∈
        Subgroup.centralizer ({QuotientGroup.mk B} : Set PSL2F11) ↔
      A * B * A⁻¹ = B ∨ A * B * A⁻¹ = negI * B := by
  rw [Subgroup.mem_centralizer_singleton_iff]
  constructor
  · intro h
    have hmk : (QuotientGroup.mk (A * B) : PSL2F11) =
        QuotientGroup.mk (B * A) := by
      simpa [QuotientGroup.mk_mul] using h
    rcases (mk_eq_mk_iff_pm (A * B) (B * A)).mp hmk with hEq | hNeg
    · left; exact (mul_eq_iff_conj A B).mp hEq
    · right
      have hEq' : A * B = (negI * B) * A := by
        calc A * B = negI * (B * A) := hNeg
          _ = (negI * B) * A := (mul_assoc negI B A).symm
      exact (mul_eq_neg_iff_conj A B).mp hEq'
  · intro h
    rcases h with hEq | hNeg
    · have hab : A * B = B * A := (mul_eq_iff_conj A B).mpr hEq
      have hmk : (QuotientGroup.mk (A * B) : PSL2F11) =
          QuotientGroup.mk (B * A) := congrArg QuotientGroup.mk hab
      rw [QuotientGroup.mk_mul, QuotientGroup.mk_mul] at hmk
      exact hmk
    · have hab : A * B = (negI * B) * A := (mul_eq_neg_iff_conj A B).mpr hNeg
      have hmk : (QuotientGroup.mk (A * B) : PSL2F11) =
          QuotientGroup.mk ((negI * B) * A) := congrArg QuotientGroup.mk hab
      have hneg1 : (QuotientGroup.mk negI : PSL2F11) = 1 :=
        (QuotientGroup.eq_one_iff _).mpr negI_mem_center
      have hmk' : (QuotientGroup.mk ((negI * B) * A) : PSL2F11) =
          QuotientGroup.mk (B * A) := by
        simp only [QuotientGroup.mk_mul, hneg1, one_mul]
      have hmkAB : (QuotientGroup.mk (A * B) : PSL2F11) =
          QuotientGroup.mk (B * A) := hmk.trans hmk'
      rw [QuotientGroup.mk_mul, QuotientGroup.mk_mul] at hmkAB
      exact hmkAB

theorem mem_pslCentLifts4_iff (A B : SLG) :
    toM4 A ∈ pslCentLifts4 (toM4 B) ↔
      A * B * A⁻¹ = B ∨ A * B * A⁻¹ = negI * B := by
  simp only [pslCentLifts4, Finset.mem_filter, toM4_mem_allSL4, true_and,
    decide_eq_true_eq]
  constructor
  · intro h
    rcases h with h1 | h2
    · left
      exact (mul_eq_iff_conj A B).mp
        (toM4_injective (by
          calc toM4 (A * B) = mul4 (toM4 A) (toM4 B) := toM4_mul A B
            _ = mul4 (toM4 B) (toM4 A) := h1
            _ = toM4 (B * A) := (toM4_mul B A).symm))
    · right
      exact (mul_eq_neg_iff_conj A B).mp
        (toM4_injective (by
          calc toM4 (A * B) = mul4 (toM4 A) (toM4 B) := toM4_mul A B
            _ = mul4 (neg4 (toM4 B)) (toM4 A) := h2
            _ = mul4 (toM4 (negI * B)) (toM4 A) := by rw [toM4_negI_mul]
            _ = toM4 ((negI * B) * A) := (toM4_mul (negI * B) A).symm))
  · intro h
    rcases h with h1 | h2
    · left
      have hab : A * B = B * A := (mul_eq_iff_conj A B).mpr h1
      calc mul4 (toM4 A) (toM4 B) = toM4 (A * B) := (toM4_mul A B).symm
        _ = toM4 (B * A) := congrArg toM4 hab
        _ = mul4 (toM4 B) (toM4 A) := toM4_mul B A
    · right
      have hab : A * B = (negI * B) * A := (mul_eq_neg_iff_conj A B).mpr h2
      calc mul4 (toM4 A) (toM4 B) = toM4 (A * B) := (toM4_mul A B).symm
        _ = toM4 ((negI * B) * A) := congrArg toM4 hab
        _ = mul4 (toM4 (negI * B)) (toM4 A) := toM4_mul (negI * B) A
        _ = mul4 (neg4 (toM4 B)) (toM4 A) := by rw [toM4_negI_mul]

theorem card_pslCentLifts4_eq (B : SLG) :
    (pslCentLifts4 (toM4 B)).card =
      Fintype.card {A : SLG //
        A * B * A⁻¹ = B ∨ A * B * A⁻¹ = negI * B} := by
  classical
  let S := {A : SLG // A * B * A⁻¹ = B ∨ A * B * A⁻¹ = negI * B}
  let e : S ≃ {m // m ∈ pslCentLifts4 (toM4 B)} :=
    { toFun := fun p => ⟨toM4 p.1, (mem_pslCentLifts4_iff p.1 B).mpr p.2⟩
      invFun := fun q => by
        have hm : q.1 ∈ allSL4 := Finset.mem_of_mem_filter q.1 q.2
        refine ⟨ofM4 q.1 hm, ?_⟩
        have hto : toM4 (ofM4 q.1 hm) = q.1 := toM4_ofM4 q.1 hm
        have hmem : toM4 (ofM4 q.1 hm) ∈ pslCentLifts4 (toM4 B) := by
          rw [hto]; exact q.2
        exact (mem_pslCentLifts4_iff (ofM4 q.1 hm) B).mp hmem
      left_inv := fun p => Subtype.ext (ofM4_toM4 p.1)
      right_inv := fun q => Subtype.ext (by
        have hm : q.1 ∈ allSL4 := Finset.mem_of_mem_filter q.1 q.2
        exact toM4_ofM4 q.1 hm) }
  calc (pslCentLifts4 (toM4 B)).card
      = Fintype.card {m // m ∈ pslCentLifts4 (toM4 B)} :=
        (Fintype.card_coe (pslCentLifts4 (toM4 B))).symm
    _ = Fintype.card S := Fintype.card_congr e.symm

theorem card_centralizer_eq_lifts_div_two (B : SLG) :
    Nat.card (Subgroup.centralizer
      ({QuotientGroup.mk B} : Set PSL2F11)) =
      (pslCentLifts4 (toM4 B)).card / 2 := by
  classical
  let C : Subgroup PSL2F11 :=
    Subgroup.centralizer ({QuotientGroup.mk B} : Set PSL2F11)
  let S := {A : SLG // A * B * A⁻¹ = B ∨ A * B * A⁻¹ = negI * B}
  have hS : (pslCentLifts4 (toM4 B)).card = Fintype.card S :=
    card_pslCentLifts4_eq B
  let e : S ≃ (Σ g : C, {A : SLG // QuotientGroup.mk A = (g : PSL2F11)}) :=
    { toFun := fun p =>
        ⟨⟨QuotientGroup.mk p.1, (mk_mem_centralizer_iff p.1 B).mpr p.2⟩, ⟨p.1, rfl⟩⟩
      invFun := fun q =>
        ⟨q.2.1, by
          have : QuotientGroup.mk q.2.1 ∈ C := by
            rw [q.2.2]; exact q.1.2
          exact (mk_mem_centralizer_iff q.2.1 B).mp this⟩
      left_inv := fun p => rfl
      right_inv := fun q => by
        rcases q with ⟨⟨g, hg⟩, ⟨A, hA⟩⟩
        cases hA
        rfl }
  have hsig :
      Fintype.card (Σ g : C, {A : SLG // QuotientGroup.mk A = (g : PSL2F11)}) =
        Fintype.card C * 2 := by
    rw [Fintype.card_sigma]
    have h2 : ∀ g : C,
        Fintype.card {A : SLG // QuotientGroup.mk A = (g : PSL2F11)} = 2 :=
      fun g => fiber_card (g : PSL2F11)
    simp only [h2]
    calc ∑ _g : C, 2
        = (Finset.univ : Finset C).card * 2 := by
          rw [Finset.sum_const, smul_eq_mul, mul_comm]
      _ = Fintype.card C * 2 := rfl
  have hcardS : Fintype.card S = Fintype.card C * 2 :=
    (Fintype.card_congr e).trans hsig
  have hmul : (pslCentLifts4 (toM4 B)).card = 2 * Nat.card C := by
    rw [hS, hcardS, Nat.card_eq_fintype_card, mul_comm]
  have hdiv : 2 * Nat.card C / 2 = Nat.card C := by omega
  calc Nat.card (Subgroup.centralizer ({QuotientGroup.mk B} : Set PSL2F11))
      = Nat.card C := rfl
    _ = 2 * Nat.card C / 2 := hdiv.symm
    _ = (pslCentLifts4 (toM4 B)).card / 2 := by rw [hmul]

/-! ### Kernel-checked centralizer lift counts -/

theorem pslCentLifts4_Smat : (pslCentLifts4 (toM4 Smat)).card = 24 := by decide

theorem pslCentLifts4_el3 : (pslCentLifts4 (toM4 el3)).card = 12 := by decide

private theorem centel5_zero : zeroSum (centWeight (toM4 el5)) = 2 := by decide
private theorem centel5_nz1 : nzSum 1 (centWeight (toM4 el5)) = 2 := by decide
private theorem centel5_nz2 : nzSum 2 (centWeight (toM4 el5)) = 0 := by decide
private theorem centel5_nz3 : nzSum 3 (centWeight (toM4 el5)) = 2 := by decide
private theorem centel5_nz4 : nzSum 4 (centWeight (toM4 el5)) = 0 := by decide
private theorem centel5_nz5 : nzSum 5 (centWeight (toM4 el5)) = 0 := by decide
private theorem centel5_nz6 : nzSum 6 (centWeight (toM4 el5)) = 0 := by decide
private theorem centel5_nz7 : nzSum 7 (centWeight (toM4 el5)) = 0 := by decide
private theorem centel5_nz8 : nzSum 8 (centWeight (toM4 el5)) = 2 := by decide
private theorem centel5_nz9 : nzSum 9 (centWeight (toM4 el5)) = 0 := by decide
private theorem centel5_nz10 : nzSum 10 (centWeight (toM4 el5)) = 2 := by decide

private def centel5Table : Fin 10 → ℕ := ![2, 0, 2, 0, 0, 0, 0, 2, 0, 2]

private theorem centel5_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (centWeight (toM4 el5)) = centel5Table i := by
  fin_cases i
  · exact centel5_nz1
  · exact centel5_nz2
  · exact centel5_nz3
  · exact centel5_nz4
  · exact centel5_nz5
  · exact centel5_nz6
  · exact centel5_nz7
  · exact centel5_nz8
  · exact centel5_nz9
  · exact centel5_nz10

theorem pslCentLifts4_el5 : (pslCentLifts4 (toM4 el5)).card = 10 := by
  rw [pslCentLifts4_card_eq_nested, centel5_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (centWeight (toM4 el5))) centel5Table centel5_cells]
  decide

private theorem centel5_pow_two_zero :
    zeroSum (centWeight (toM4 (el5 ^ 2))) = 2 := by decide
private theorem centel5_pow_two_nz1 :
    nzSum 1 (centWeight (toM4 (el5 ^ 2))) = 2 := by decide
private theorem centel5_pow_two_nz2 :
    nzSum 2 (centWeight (toM4 (el5 ^ 2))) = 0 := by decide
private theorem centel5_pow_two_nz3 :
    nzSum 3 (centWeight (toM4 (el5 ^ 2))) = 2 := by decide
private theorem centel5_pow_two_nz4 :
    nzSum 4 (centWeight (toM4 (el5 ^ 2))) = 0 := by decide
private theorem centel5_pow_two_nz5 :
    nzSum 5 (centWeight (toM4 (el5 ^ 2))) = 0 := by decide
private theorem centel5_pow_two_nz6 :
    nzSum 6 (centWeight (toM4 (el5 ^ 2))) = 0 := by decide
private theorem centel5_pow_two_nz7 :
    nzSum 7 (centWeight (toM4 (el5 ^ 2))) = 0 := by decide
private theorem centel5_pow_two_nz8 :
    nzSum 8 (centWeight (toM4 (el5 ^ 2))) = 2 := by decide
private theorem centel5_pow_two_nz9 :
    nzSum 9 (centWeight (toM4 (el5 ^ 2))) = 0 := by decide
private theorem centel5_pow_two_nz10 :
    nzSum 10 (centWeight (toM4 (el5 ^ 2))) = 2 := by decide

private def centel5_pow_twoTable : Fin 10 → ℕ := ![2, 0, 2, 0, 0, 0, 0, 2, 0, 2]

private theorem centel5_pow_two_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (centWeight (toM4 (el5 ^ 2))) =
      centel5_pow_twoTable i := by
  fin_cases i
  · exact centel5_pow_two_nz1
  · exact centel5_pow_two_nz2
  · exact centel5_pow_two_nz3
  · exact centel5_pow_two_nz4
  · exact centel5_pow_two_nz5
  · exact centel5_pow_two_nz6
  · exact centel5_pow_two_nz7
  · exact centel5_pow_two_nz8
  · exact centel5_pow_two_nz9
  · exact centel5_pow_two_nz10

theorem pslCentLifts4_el5_pow_two :
    (pslCentLifts4 (toM4 (el5 ^ 2))).card = 10 := by
  rw [pslCentLifts4_card_eq_nested, centel5_pow_two_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (centWeight (toM4 (el5 ^ 2))))
      centel5_pow_twoTable centel5_pow_two_cells]
  decide

theorem pslCentLifts4_el6 : (pslCentLifts4 (toM4 el6)).card = 12 := by decide

private theorem centTmat_zero : zeroSum (centWeight (toM4 Tmat)) = 0 := by decide
private theorem centTmat_nz1 : nzSum 1 (centWeight (toM4 Tmat)) = 11 := by decide
private theorem centTmat_nz2 : nzSum 2 (centWeight (toM4 Tmat)) = 0 := by decide
private theorem centTmat_nz3 : nzSum 3 (centWeight (toM4 Tmat)) = 0 := by decide
private theorem centTmat_nz4 : nzSum 4 (centWeight (toM4 Tmat)) = 0 := by decide
private theorem centTmat_nz5 : nzSum 5 (centWeight (toM4 Tmat)) = 0 := by decide
private theorem centTmat_nz6 : nzSum 6 (centWeight (toM4 Tmat)) = 0 := by decide
private theorem centTmat_nz7 : nzSum 7 (centWeight (toM4 Tmat)) = 0 := by decide
private theorem centTmat_nz8 : nzSum 8 (centWeight (toM4 Tmat)) = 0 := by decide
private theorem centTmat_nz9 : nzSum 9 (centWeight (toM4 Tmat)) = 0 := by decide
private theorem centTmat_nz10 : nzSum 10 (centWeight (toM4 Tmat)) = 11 := by decide

private def centTmatTable : Fin 10 → ℕ := ![11, 0, 0, 0, 0, 0, 0, 0, 0, 11]

private theorem centTmat_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (centWeight (toM4 Tmat)) = centTmatTable i := by
  fin_cases i
  · exact centTmat_nz1
  · exact centTmat_nz2
  · exact centTmat_nz3
  · exact centTmat_nz4
  · exact centTmat_nz5
  · exact centTmat_nz6
  · exact centTmat_nz7
  · exact centTmat_nz8
  · exact centTmat_nz9
  · exact centTmat_nz10

theorem pslCentLifts4_Tmat : (pslCentLifts4 (toM4 Tmat)).card = 22 := by
  rw [pslCentLifts4_card_eq_nested, centTmat_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (centWeight (toM4 Tmat))) centTmatTable centTmat_cells]
  decide

private theorem centTmat_pow_two_zero :
    zeroSum (centWeight (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem centTmat_pow_two_nz1 :
    nzSum 1 (centWeight (toM4 (Tmat ^ 2))) = 11 := by decide
private theorem centTmat_pow_two_nz2 :
    nzSum 2 (centWeight (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem centTmat_pow_two_nz3 :
    nzSum 3 (centWeight (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem centTmat_pow_two_nz4 :
    nzSum 4 (centWeight (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem centTmat_pow_two_nz5 :
    nzSum 5 (centWeight (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem centTmat_pow_two_nz6 :
    nzSum 6 (centWeight (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem centTmat_pow_two_nz7 :
    nzSum 7 (centWeight (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem centTmat_pow_two_nz8 :
    nzSum 8 (centWeight (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem centTmat_pow_two_nz9 :
    nzSum 9 (centWeight (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem centTmat_pow_two_nz10 :
    nzSum 10 (centWeight (toM4 (Tmat ^ 2))) = 11 := by decide

private def centTmat_pow_twoTable : Fin 10 → ℕ :=
  ![11, 0, 0, 0, 0, 0, 0, 0, 0, 11]

private theorem centTmat_pow_two_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (centWeight (toM4 (Tmat ^ 2))) =
      centTmat_pow_twoTable i := by
  fin_cases i
  · exact centTmat_pow_two_nz1
  · exact centTmat_pow_two_nz2
  · exact centTmat_pow_two_nz3
  · exact centTmat_pow_two_nz4
  · exact centTmat_pow_two_nz5
  · exact centTmat_pow_two_nz6
  · exact centTmat_pow_two_nz7
  · exact centTmat_pow_two_nz8
  · exact centTmat_pow_two_nz9
  · exact centTmat_pow_two_nz10

theorem pslCentLifts4_Tmat_pow_two :
    (pslCentLifts4 (toM4 (Tmat ^ 2))).card = 22 := by
  rw [pslCentLifts4_card_eq_nested, centTmat_pow_two_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (centWeight (toM4 (Tmat ^ 2))))
      centTmat_pow_twoTable centTmat_pow_two_cells]
  decide

open ConjAct ConjClasses

theorem card_carrier_of_cent {g : PSL2F11} {n : ℕ}
    (hcent : Nat.card (Subgroup.centralizer ({g} : Set PSL2F11)) = n) :
    Fintype.card (ConjClasses.mk g).carrier = 660 / n := by
  classical
  have hG : Fintype.card PSL2F11 = 660 := card_PSL2_F11_fintype
  have heq := Subgroup.nat_card_centralizer_nat_card_stabilizer (G := PSL2F11) g
  have hstab_nat : Nat.card (MulAction.stabilizer (ConjAct PSL2F11) g) = n :=
    heq.symm.trans hcent
  have hstab : Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) g) = n := by
    rwa [← Nat.card_eq_fintype_card]
  have h := ConjClasses.card_carrier (G := PSL2F11) g
  calc Fintype.card (ConjClasses.mk g).carrier
      = Fintype.card PSL2F11 /
          Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) g) := h
    _ = 660 / n := by rw [hG, hstab]

theorem card_carrier_Smat :
    Fintype.card (ConjClasses.mk (QuotientGroup.mk Smat : PSL2F11)).carrier = 55 := by
  classical
  have hcent :
      Nat.card (Subgroup.centralizer
        ({QuotientGroup.mk Smat} : Set PSL2F11)) = 12 := by
    rw [card_centralizer_eq_lifts_div_two, pslCentLifts4_Smat]
  simpa using card_carrier_of_cent hcent

theorem card_carrier_el3 :
    Fintype.card (ConjClasses.mk (QuotientGroup.mk el3 : PSL2F11)).carrier = 110 := by
  classical
  have hcent :
      Nat.card (Subgroup.centralizer
        ({QuotientGroup.mk el3} : Set PSL2F11)) = 6 := by
    rw [card_centralizer_eq_lifts_div_two, pslCentLifts4_el3]
  simpa using card_carrier_of_cent hcent

theorem card_carrier_el6 :
    Fintype.card (ConjClasses.mk (QuotientGroup.mk el6 : PSL2F11)).carrier = 110 := by
  classical
  have hcent :
      Nat.card (Subgroup.centralizer
        ({QuotientGroup.mk el6} : Set PSL2F11)) = 6 := by
    rw [card_centralizer_eq_lifts_div_two, pslCentLifts4_el6]
  simpa using card_carrier_of_cent hcent

theorem card_carrier_el5 :
    Fintype.card (ConjClasses.mk (QuotientGroup.mk el5 : PSL2F11)).carrier = 132 := by
  classical
  have hcent :
      Nat.card (Subgroup.centralizer
        ({QuotientGroup.mk el5} : Set PSL2F11)) = 5 := by
    rw [card_centralizer_eq_lifts_div_two, pslCentLifts4_el5]
  simpa using card_carrier_of_cent hcent

theorem card_carrier_el5_pow_two :
    Fintype.card (ConjClasses.mk (QuotientGroup.mk (el5 ^ 2) : PSL2F11)).carrier =
      132 := by
  classical
  have hcent :
      Nat.card (Subgroup.centralizer
        ({QuotientGroup.mk (el5 ^ 2)} : Set PSL2F11)) = 5 := by
    rw [card_centralizer_eq_lifts_div_two, pslCentLifts4_el5_pow_two]
  simpa using card_carrier_of_cent hcent

theorem card_carrier_Tmat :
    Fintype.card (ConjClasses.mk (QuotientGroup.mk Tmat : PSL2F11)).carrier = 60 := by
  classical
  have hcent :
      Nat.card (Subgroup.centralizer
        ({QuotientGroup.mk Tmat} : Set PSL2F11)) = 11 := by
    rw [card_centralizer_eq_lifts_div_two, pslCentLifts4_Tmat]
  simpa using card_carrier_of_cent hcent

theorem card_carrier_Tmat_pow_two :
    Fintype.card (ConjClasses.mk (QuotientGroup.mk (Tmat ^ 2) : PSL2F11)).carrier =
      60 := by
  classical
  have hcent :
      Nat.card (Subgroup.centralizer
        ({QuotientGroup.mk (Tmat ^ 2)} : Set PSL2F11)) = 11 := by
    rw [card_centralizer_eq_lifts_div_two, pslCentLifts4_Tmat_pow_two]
  simpa using card_carrier_of_cent hcent

/-! ### Class-function subsets and single-class conjugacy -/

theorem carrier_subset_orderOf {g : PSL2F11} {n : ℕ} (hg : orderOf g = n) :
    (ConjClasses.mk g).carrier ⊆ {x : PSL2F11 | orderOf x = n} := by
  intro x hx
  have hmk : ConjClasses.mk x = ConjClasses.mk g := mem_carrier_iff_mk_eq.mp hx
  have hc : IsConj g x := isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)
  obtain ⟨c, rfl⟩ := isConj_iff.mp hc
  change orderOf (c * g * c⁻¹) = n
  rw [orderOf_conj_apply, hg]

theorem isConj_of_order_of_card {rep : PSL2F11} {n k : ℕ}
    (hord : orderOf rep = n)
    (hcar : Fintype.card (ConjClasses.mk rep).carrier = k)
    (hordCard : Fintype.card {x : PSL2F11 // orderOf x = n} = k)
    {g : PSL2F11} (hg : orderOf g = n) :
    IsConj rep g := by
  classical
  have hsub := carrier_subset_orderOf hord
  let ι : (ConjClasses.mk rep).carrier → {x : PSL2F11 // orderOf x = n} :=
    fun x => ⟨x.1, hsub x.2⟩
  have hι_inj : Function.Injective ι := by
    intro a b h
    apply Subtype.ext
    exact congrArg (fun z : {x : PSL2F11 // orderOf x = n} => (z : PSL2F11)) h
  have hcard : Fintype.card (ConjClasses.mk rep).carrier =
      Fintype.card {x : PSL2F11 // orderOf x = n} := by
    rw [hcar, hordCard]
  have hι_bi : Function.Bijective ι :=
    (Fintype.bijective_iff_injective_and_card ι).2 ⟨hι_inj, hcard⟩
  obtain ⟨y, hy⟩ := hι_bi.surjective ⟨g, hg⟩
  have hcar_mem : g ∈ (ConjClasses.mk rep).carrier := by
    have : (ι y : PSL2F11) = g := congrArg Subtype.val hy
    convert y.property
    exact this.symm
  have hmk : ConjClasses.mk g = ConjClasses.mk rep :=
    mem_carrier_iff_mk_eq.mp hcar_mem
  exact isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)

theorem isConj_Smat_of_order_two {g : PSL2F11} (hg : orderOf g = 2) :
    IsConj (QuotientGroup.mk Smat) g :=
  isConj_of_order_of_card
    (by rw [orderOf_mk_eq_pslOrd, pslOrd_Smat])
    card_carrier_Smat card_psl_order_two hg

theorem isConj_el3_of_order_three {g : PSL2F11} (hg : orderOf g = 3) :
    IsConj (QuotientGroup.mk el3) g :=
  isConj_of_order_of_card
    (by rw [orderOf_mk_eq_pslOrd, pslOrd_el3])
    card_carrier_el3 card_psl_order_three hg

theorem isConj_el6_of_order_six {g : PSL2F11} (hg : orderOf g = 6) :
    IsConj (QuotientGroup.mk el6) g :=
  isConj_of_order_of_card
    (by rw [orderOf_mk_eq_pslOrd, pslOrd_el6])
    card_carrier_el6 card_psl_order_six hg

/-! ### Nonconjugacy of the split pairs 5A/5B and 11A/11B

Empty conjugator sets on the raw M4 model (O(|SL|) decide checks). -/

/-- Conjugators realizing `C X C⁻¹ = ± Y` in the raw model. -/
def conjLifts4 (X Y : M4) : Finset M4 :=
  allSL4.filter (fun C =>
    let conj := mul4 (mul4 C X) (inv4 C)
    decide (conj = Y ∨ conj = neg4 Y))

private def conjWeight (X Y C : M4) : ℕ :=
  if mul4 (mul4 C X) (inv4 C) = Y ∨
      mul4 (mul4 C X) (inv4 C) = neg4 Y then 1 else 0

theorem conjLifts4_card_eq_param (X Y : M4) :
    (conjLifts4 X Y).card =
      (∑ q : ZeroParam, conjWeight X Y (zeroMatrix q)) +
      (∑ q : NZParam, conjWeight X Y (nzMatrix q)) := by
  rw [← allSL4_sum_eq_param (conjWeight X Y)]
  classical
  unfold conjLifts4
  rw [Finset.card_eq_sum_ones, Finset.sum_filter]
  apply Finset.sum_congr rfl
  intro C _
  by_cases h : mul4 (mul4 C X) (inv4 C) = Y ∨
      mul4 (mul4 C X) (inv4 C) = neg4 Y
  · simp [conjWeight, h]
  · simp [conjWeight, h]

theorem conjLifts4_card_eq_nested (X Y : M4) :
    (conjLifts4 X Y).card = zeroSum (conjWeight X Y) +
      ∑ a : {a : F // a ≠ 0}, nzSum a.1 (conjWeight X Y) := by
  rw [conjLifts4_card_eq_param]
  simp only [zeroSum, nzSum, Fintype.sum_prod_type, zeroMatrix, nzMatrix]

private theorem conjel5_el5_pow_two_zero :
    zeroSum (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) = 0 := by decide
private theorem conjel5_el5_pow_two_nz1 :
    nzSum 1 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) = 0 := by decide
private theorem conjel5_el5_pow_two_nz2 :
    nzSum 2 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) = 0 := by decide
private theorem conjel5_el5_pow_two_nz3 :
    nzSum 3 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) = 0 := by decide
private theorem conjel5_el5_pow_two_nz4 :
    nzSum 4 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) = 0 := by decide
private theorem conjel5_el5_pow_two_nz5 :
    nzSum 5 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) = 0 := by decide
private theorem conjel5_el5_pow_two_nz6 :
    nzSum 6 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) = 0 := by decide
private theorem conjel5_el5_pow_two_nz7 :
    nzSum 7 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) = 0 := by decide
private theorem conjel5_el5_pow_two_nz8 :
    nzSum 8 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) = 0 := by decide
private theorem conjel5_el5_pow_two_nz9 :
    nzSum 9 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) = 0 := by decide
private theorem conjel5_el5_pow_two_nz10 :
    nzSum 10 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) = 0 := by decide

private def conjel5_el5_pow_twoTable : Fin 10 → ℕ := ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

private theorem conjel5_el5_pow_two_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))) =
      conjel5_el5_pow_twoTable i := by
  fin_cases i
  · exact conjel5_el5_pow_two_nz1
  · exact conjel5_el5_pow_two_nz2
  · exact conjel5_el5_pow_two_nz3
  · exact conjel5_el5_pow_two_nz4
  · exact conjel5_el5_pow_two_nz5
  · exact conjel5_el5_pow_two_nz6
  · exact conjel5_el5_pow_two_nz7
  · exact conjel5_el5_pow_two_nz8
  · exact conjel5_el5_pow_two_nz9
  · exact conjel5_el5_pow_two_nz10

theorem conjLifts4_el5_el5_pow_two_empty :
    (conjLifts4 (toM4 el5) (toM4 (el5 ^ 2))).card = 0 := by
  rw [conjLifts4_card_eq_nested, conjel5_el5_pow_two_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (conjWeight (toM4 el5) (toM4 (el5 ^ 2))))
      conjel5_el5_pow_twoTable conjel5_el5_pow_two_cells]
  decide

private theorem conjTmat_Tmat_pow_two_zero :
    zeroSum (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem conjTmat_Tmat_pow_two_nz1 :
    nzSum 1 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem conjTmat_Tmat_pow_two_nz2 :
    nzSum 2 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem conjTmat_Tmat_pow_two_nz3 :
    nzSum 3 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem conjTmat_Tmat_pow_two_nz4 :
    nzSum 4 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem conjTmat_Tmat_pow_two_nz5 :
    nzSum 5 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem conjTmat_Tmat_pow_two_nz6 :
    nzSum 6 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem conjTmat_Tmat_pow_two_nz7 :
    nzSum 7 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem conjTmat_Tmat_pow_two_nz8 :
    nzSum 8 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem conjTmat_Tmat_pow_two_nz9 :
    nzSum 9 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) = 0 := by decide
private theorem conjTmat_Tmat_pow_two_nz10 :
    nzSum 10 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) = 0 := by decide

private def conjTmat_Tmat_pow_twoTable : Fin 10 → ℕ :=
  ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

private theorem conjTmat_Tmat_pow_two_cells (i : Fin 10) :
    nzSum (nzIndex i).1 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))) =
      conjTmat_Tmat_pow_twoTable i := by
  fin_cases i
  · exact conjTmat_Tmat_pow_two_nz1
  · exact conjTmat_Tmat_pow_two_nz2
  · exact conjTmat_Tmat_pow_two_nz3
  · exact conjTmat_Tmat_pow_two_nz4
  · exact conjTmat_Tmat_pow_two_nz5
  · exact conjTmat_Tmat_pow_two_nz6
  · exact conjTmat_Tmat_pow_two_nz7
  · exact conjTmat_Tmat_pow_two_nz8
  · exact conjTmat_Tmat_pow_two_nz9
  · exact conjTmat_Tmat_pow_two_nz10

theorem conjLifts4_Tmat_Tmat_pow_two_empty :
    (conjLifts4 (toM4 Tmat) (toM4 (Tmat ^ 2))).card = 0 := by
  rw [conjLifts4_card_eq_nested, conjTmat_Tmat_pow_two_zero]
  rw [sum_nonzero_eq_of_cells
    (fun a ↦ nzSum a.1 (conjWeight (toM4 Tmat) (toM4 (Tmat ^ 2))))
      conjTmat_Tmat_pow_twoTable conjTmat_Tmat_pow_two_cells]
  decide

theorem not_psl_isConj_of_conjLifts4_empty {X Y : SLG}
    (hempty : (conjLifts4 (toM4 X) (toM4 Y)).card = 0) :
    ¬ IsConj (QuotientGroup.mk X : PSL2F11) (QuotientGroup.mk Y) := by
  intro h
  obtain ⟨c, hc⟩ := isConj_iff.mp h
  obtain ⟨C, rfl⟩ := QuotientGroup.mk_surjective c
  have hmk :
      (QuotientGroup.mk (C * X * C⁻¹) : PSL2F11) = QuotientGroup.mk Y := by
    simpa [QuotientGroup.mk_mul, QuotientGroup.mk_inv] using hc
  have hconj_toM4 :
      mul4 (mul4 (toM4 C) (toM4 X)) (inv4 (toM4 C)) =
        toM4 (C * X * C⁻¹) := by
    simp [← toM4_mul, ← toM4_inv]
  rcases (mk_eq_mk_iff_pm (C * X * C⁻¹) Y).mp hmk with hEq | hNeg
  · have hmem : toM4 C ∈ conjLifts4 (toM4 X) (toM4 Y) := by
      refine Finset.mem_filter.mpr ⟨toM4_mem_allSL4 C, ?_⟩
      simp only [decide_eq_true_eq]
      left
      rw [hconj_toM4, hEq]
    have hpos : 0 < (conjLifts4 (toM4 X) (toM4 Y)).card :=
      Finset.card_pos.mpr ⟨toM4 C, hmem⟩
    omega
  · have hmem : toM4 C ∈ conjLifts4 (toM4 X) (toM4 Y) := by
      refine Finset.mem_filter.mpr ⟨toM4_mem_allSL4 C, ?_⟩
      simp only [decide_eq_true_eq]
      right
      rw [hconj_toM4, hNeg, toM4_negI_mul]
    have hpos : 0 < (conjLifts4 (toM4 X) (toM4 Y)).card :=
      Finset.card_pos.mpr ⟨toM4 C, hmem⟩
    omega

theorem not_isConj_el5_el5_pow_two :
    ¬ IsConj (QuotientGroup.mk el5 : PSL2F11)
        (QuotientGroup.mk (el5 ^ 2)) :=
  not_psl_isConj_of_conjLifts4_empty conjLifts4_el5_el5_pow_two_empty

theorem not_isConj_Tmat_Tmat_pow_two :
    ¬ IsConj (QuotientGroup.mk Tmat : PSL2F11)
        (QuotientGroup.mk (Tmat ^ 2)) :=
  not_psl_isConj_of_conjLifts4_empty conjLifts4_Tmat_Tmat_pow_two_empty

/-! ### Double-class covering for orders 5 and 11 -/

private theorem isConj_of_mem_carrier {rep g : PSL2F11}
    (hg : g ∈ (ConjClasses.mk rep).carrier) : IsConj rep g :=
  isConj_comm.mp ((mk_eq_mk_iff_isConj).mp (mem_carrier_iff_mk_eq.mp hg))

private theorem disjoint_carriers_of_not_isConj {r1 r2 : PSL2F11}
    (hne : ¬ IsConj r1 r2) :
    Disjoint (ConjClasses.mk r1).carrier (ConjClasses.mk r2).carrier := by
  refine Set.disjoint_left.mpr fun x hx1 hx2 => ?_
  have hmk1 : ConjClasses.mk x = ConjClasses.mk r1 := mem_carrier_iff_mk_eq.mp hx1
  have hmk2 : ConjClasses.mk x = ConjClasses.mk r2 := mem_carrier_iff_mk_eq.mp hx2
  have hmk : ConjClasses.mk r1 = ConjClasses.mk r2 := hmk1.symm.trans hmk2
  exact hne ((mk_eq_mk_iff_isConj).mp hmk)

public theorem isConj_el5_or_pow_of_order_five {g : PSL2F11} (hg : orderOf g = 5) :
    IsConj (QuotientGroup.mk el5) g ∨
      IsConj (QuotientGroup.mk (el5 ^ 2)) g := by
  classical
  set r1 : PSL2F11 := QuotientGroup.mk el5
  set r2 : PSL2F11 := QuotientGroup.mk (el5 ^ 2)
  have hord1 : orderOf r1 = 5 := by
    change orderOf (QuotientGroup.mk el5) = 5
    rw [orderOf_mk_eq_pslOrd, pslOrd_el5]
  have hord2 : orderOf r2 = 5 := by
    change orderOf (QuotientGroup.mk (el5 ^ 2)) = 5
    rw [orderOf_mk_eq_pslOrd, pslOrd_el5_pow_two]
  have hsub1 := carrier_subset_orderOf hord1
  have hsub2 := carrier_subset_orderOf hord2
  -- Use Finite → Fintype for conjugacy class carriers.
  letI : Fintype (ConjClasses.mk r1).carrier := Fintype.ofFinite _
  letI : Fintype (ConjClasses.mk r2).carrier := Fintype.ofFinite _
  let ι : (ConjClasses.mk r1).carrier ⊕ (ConjClasses.mk r2).carrier →
      {x : PSL2F11 // orderOf x = 5} := fun
    | Sum.inl x => ⟨x.1, hsub1 x.2⟩
    | Sum.inr x => ⟨x.1, hsub2 x.2⟩
  have hι_inj : Function.Injective ι := by
    intro a b hab
    match a, b with
    | Sum.inl x, Sum.inl y =>
        exact congrArg Sum.inl <| Subtype.ext <|
          congrArg (fun z : {x // orderOf x = 5} => (z : PSL2F11)) hab
    | Sum.inr x, Sum.inr y =>
        exact congrArg Sum.inr <| Subtype.ext <|
          congrArg (fun z : {x // orderOf x = 5} => (z : PSL2F11)) hab
    | Sum.inl x, Sum.inr y =>
        have heq : (x : PSL2F11) = y :=
          congrArg (fun z : {x // orderOf x = 5} => (z : PSL2F11)) hab
        have hmk : ConjClasses.mk r1 = ConjClasses.mk r2 := by
          rw [← mem_carrier_iff_mk_eq.mp x.2, heq, mem_carrier_iff_mk_eq.mp y.2]
        exact absurd ((mk_eq_mk_iff_isConj).mp hmk) not_isConj_el5_el5_pow_two
    | Sum.inr x, Sum.inl y =>
        have heq : (x : PSL2F11) = y :=
          congrArg (fun z : {x // orderOf x = 5} => (z : PSL2F11)) hab
        have hmk : ConjClasses.mk r1 = ConjClasses.mk r2 := by
          rw [← mem_carrier_iff_mk_eq.mp y.2, ← heq, mem_carrier_iff_mk_eq.mp x.2]
        exact absurd ((mk_eq_mk_iff_isConj).mp hmk) not_isConj_el5_el5_pow_two
  have hcard :
      Fintype.card ((ConjClasses.mk r1).carrier ⊕ (ConjClasses.mk r2).carrier) =
        Fintype.card {x : PSL2F11 // orderOf x = 5} := by
    have hc1 : Fintype.card (ConjClasses.mk r1).carrier = 132 := by
      simpa [r1] using card_carrier_el5
    have hc2 : Fintype.card (ConjClasses.mk r2).carrier = 132 := by
      simpa [r2] using card_carrier_el5_pow_two
    rw [Fintype.card_sum, hc1, hc2, card_psl_order_five]
  have hι_bi : Function.Bijective ι :=
    (Fintype.bijective_iff_injective_and_card ι).2 ⟨hι_inj, hcard⟩
  obtain ⟨z, hz⟩ := hι_bi.surjective ⟨g, hg⟩
  match z with
  | Sum.inl x =>
      left
      exact isConj_of_mem_carrier (by
        have : (ι (Sum.inl x) : PSL2F11) = g := congrArg Subtype.val hz
        convert x.property; exact this.symm)
  | Sum.inr x =>
      right
      exact isConj_of_mem_carrier (by
        have : (ι (Sum.inr x) : PSL2F11) = g := congrArg Subtype.val hz
        convert x.property; exact this.symm)

public theorem isConj_Tmat_or_pow_of_order_eleven {g : PSL2F11} (hg : orderOf g = 11) :
    IsConj (QuotientGroup.mk Tmat) g ∨
      IsConj (QuotientGroup.mk (Tmat ^ 2)) g := by
  classical
  set r1 : PSL2F11 := QuotientGroup.mk Tmat
  set r2 : PSL2F11 := QuotientGroup.mk (Tmat ^ 2)
  have hord1 : orderOf r1 = 11 := by
    change orderOf (QuotientGroup.mk Tmat) = 11
    rw [orderOf_mk_eq_pslOrd, pslOrd_Tmat]
  have hord2 : orderOf r2 = 11 := by
    change orderOf (QuotientGroup.mk (Tmat ^ 2)) = 11
    rw [orderOf_mk_eq_pslOrd, pslOrd_Tmat_pow_two]
  have hsub1 := carrier_subset_orderOf hord1
  have hsub2 := carrier_subset_orderOf hord2
  letI : Fintype (ConjClasses.mk r1).carrier := Fintype.ofFinite _
  letI : Fintype (ConjClasses.mk r2).carrier := Fintype.ofFinite _
  let ι : (ConjClasses.mk r1).carrier ⊕ (ConjClasses.mk r2).carrier →
      {x : PSL2F11 // orderOf x = 11} := fun
    | Sum.inl x => ⟨x.1, hsub1 x.2⟩
    | Sum.inr x => ⟨x.1, hsub2 x.2⟩
  have hι_inj : Function.Injective ι := by
    intro a b hab
    match a, b with
    | Sum.inl x, Sum.inl y =>
        exact congrArg Sum.inl <| Subtype.ext <|
          congrArg (fun z : {x // orderOf x = 11} => (z : PSL2F11)) hab
    | Sum.inr x, Sum.inr y =>
        exact congrArg Sum.inr <| Subtype.ext <|
          congrArg (fun z : {x // orderOf x = 11} => (z : PSL2F11)) hab
    | Sum.inl x, Sum.inr y =>
        have heq : (x : PSL2F11) = y :=
          congrArg (fun z : {x // orderOf x = 11} => (z : PSL2F11)) hab
        have hmk : ConjClasses.mk r1 = ConjClasses.mk r2 := by
          rw [← mem_carrier_iff_mk_eq.mp x.2, heq, mem_carrier_iff_mk_eq.mp y.2]
        exact absurd ((mk_eq_mk_iff_isConj).mp hmk) not_isConj_Tmat_Tmat_pow_two
    | Sum.inr x, Sum.inl y =>
        have heq : (x : PSL2F11) = y :=
          congrArg (fun z : {x // orderOf x = 11} => (z : PSL2F11)) hab
        have hmk : ConjClasses.mk r1 = ConjClasses.mk r2 := by
          rw [← mem_carrier_iff_mk_eq.mp y.2, ← heq, mem_carrier_iff_mk_eq.mp x.2]
        exact absurd ((mk_eq_mk_iff_isConj).mp hmk) not_isConj_Tmat_Tmat_pow_two
  have hcard :
      Fintype.card ((ConjClasses.mk r1).carrier ⊕ (ConjClasses.mk r2).carrier) =
        Fintype.card {x : PSL2F11 // orderOf x = 11} := by
    have hc1 : Fintype.card (ConjClasses.mk r1).carrier = 60 := by
      simpa [r1] using card_carrier_Tmat
    have hc2 : Fintype.card (ConjClasses.mk r2).carrier = 60 := by
      simpa [r2] using card_carrier_Tmat_pow_two
    rw [Fintype.card_sum, hc1, hc2, card_psl_order_eleven]
  have hι_bi : Function.Bijective ι :=
    (Fintype.bijective_iff_injective_and_card ι).2 ⟨hι_inj, hcard⟩
  obtain ⟨z, hz⟩ := hι_bi.surjective ⟨g, hg⟩
  match z with
  | Sum.inl x =>
      left
      exact isConj_of_mem_carrier (by
        have : (ι (Sum.inl x) : PSL2F11) = g := congrArg Subtype.val hz
        convert x.property; exact this.symm)
  | Sum.inr x =>
      right
      exact isConj_of_mem_carrier (by
        have : (ι (Sum.inr x) : PSL2F11) = g := congrArg Subtype.val hz
        convert x.property; exact this.symm)

/-! ### Main convolution identity -/

theorem pslOrd_eq_one_iff (A : SLG) :
    pslOrd A = 1 ↔ A = 1 ∨ A = negI := by
  constructor
  · intro h
    have := pslOrd_eq_one_or_pow_center A 1 h (by decide)
    simpa [pow_one] using this
  · intro h
    rcases h with rfl | rfl
    · unfold pslOrd; simp
    · unfold pslOrd
      have : (negI : SLG) ^ 1 = negI := by simp
      simp [this]

/-- Convolution identity: `convAt B = 132 · χ(pslOrd B)`. -/
theorem convAt_eq (B : SLG) : convAt B = 132 * chi10Int (pslOrd B) := by
  have hspec := pslOrd_eq_spectrum B
  rcases hspec with h | h | h | h | h | h
  · have hpm : B = 1 ∨ B = negI := (pslOrd_eq_one_iff B).mp h
    rcases hpm with rfl | rfl
    · rw [h, convAt_one_rep, chi10Int]; norm_num
    · have hneg : convAt negI = convAt 1 := by
        simpa using convAt_mul_negI (1 : SLG)
      rw [h, hneg, convAt_one_rep, chi10Int]; norm_num
  · have hc := isConj_Smat_of_order_two (by rw [orderOf_mk_eq_pslOrd, h])
    have hconv := convAt_eq_of_psl_isConj (isConj_comm.mp hc)
    rw [hconv, convAt_Smat, h, chi10Int]; norm_num
  · have hc := isConj_el3_of_order_three (by rw [orderOf_mk_eq_pslOrd, h])
    have hconv := convAt_eq_of_psl_isConj (isConj_comm.mp hc)
    rw [hconv, convAt_el3, h, chi10Int]; norm_num
  · rcases isConj_el5_or_pow_of_order_five
        (by rw [orderOf_mk_eq_pslOrd, h]) with hc | hc
    · have hconv := convAt_eq_of_psl_isConj (isConj_comm.mp hc)
      rw [hconv, convAt_el5, h, chi10Int]; norm_num
    · have hconv := convAt_eq_of_psl_isConj (isConj_comm.mp hc)
      rw [hconv, convAt_el5_pow_two, h, chi10Int]; norm_num
  · have hc := isConj_el6_of_order_six (by rw [orderOf_mk_eq_pslOrd, h])
    have hconv := convAt_eq_of_psl_isConj (isConj_comm.mp hc)
    rw [hconv, convAt_el6, h, chi10Int]; norm_num
  · rcases isConj_Tmat_or_pow_of_order_eleven
        (by rw [orderOf_mk_eq_pslOrd, h]) with hc | hc
    · have hconv := convAt_eq_of_psl_isConj (isConj_comm.mp hc)
      rw [hconv, convAt_Tmat, h, chi10Int]; norm_num
    · have hconv := convAt_eq_of_psl_isConj (isConj_comm.mp hc)
      rw [hconv, convAt_Tmat_pow_two, h, chi10Int]; norm_num

/-- Spot-check: identity convolution value. -/
theorem convAt_one : convAt 1 = 1320 := convAt_one_rep

/-- PSL convolution: ∑_g χ(g)χ(g⁻¹k) = 66 χ(k). -/
public theorem chi10Int_convolution (k : PSL2F11) :
    (∑ g : PSL2F11, chi10Int (orderOf g) * chi10Int (orderOf (g⁻¹ * k))) =
      66 * chi10Int (orderOf k) := by
  obtain ⟨B, rfl⟩ := QuotientGroup.mk_surjective k
  set f : PSL2F11 → ℤ := fun g =>
    chi10Int (orderOf g) * chi10Int (orderOf (g⁻¹ * QuotientGroup.mk B))
  have hterm (A : SLG) :
      chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * B)) = f (QuotientGroup.mk A) := by
    dsimp [f]
    rw [orderOf_mk_eq_pslOrd A, ← QuotientGroup.mk_inv, ← QuotientGroup.mk_mul,
      orderOf_mk_eq_pslOrd]
  have hSL : convAt B = ∑ A : SLG, f (QuotientGroup.mk A) := by
    unfold convAt
    exact Fintype.sum_congr _ _ hterm
  have hdouble := sum_comp_mk f
  have hconv := convAt_eq B
  have hord : orderOf (QuotientGroup.mk B : PSL2F11) = pslOrd B :=
    orderOf_mk_eq_pslOrd B
  have h2 : (2 : ℕ) • (∑ g : PSL2F11, f g) = 132 * chi10Int (pslOrd B) := by
    calc (2 : ℕ) • (∑ g : PSL2F11, f g)
        = ∑ A : SLG, f (QuotientGroup.mk A) := hdouble.symm
      _ = convAt B := hSL.symm
      _ = 132 * chi10Int (pslOrd B) := hconv
  have h2' : (2 : ℤ) * (∑ g : PSL2F11, f g) = 132 * chi10Int (pslOrd B) := by
    simpa [two_nsmul, two_mul] using h2
  dsimp [f]
  rw [hord]
  have hmul : (2 : ℤ) * (∑ g : PSL2F11,
      chi10Int (orderOf g) *
        chi10Int (orderOf (g⁻¹ * QuotientGroup.mk B))) =
      (2 : ℤ) * (66 * chi10Int (pslOrd B)) := by
    rw [show f = fun g =>
      chi10Int (orderOf g) * chi10Int (orderOf (g⁻¹ * QuotientGroup.mk B)) from rfl] at h2'
    convert h2' using 1
    ring
  exact (mul_left_cancel₀ (by decide : (2 : ℤ) ≠ 0) hmul)

#print axioms card_PSL2_F11
#print axioms orderOf_mk_eq_pslOrd
#print axioms slChiSumSq_eq
#print axioms sum_comp_mk
#print axioms chi10Int_sum_sq_psl
#print axioms card_psl_order_two
#print axioms convAt_eq
#print axioms chi10Int_convolution

end PSLCard
end V14Formalization
