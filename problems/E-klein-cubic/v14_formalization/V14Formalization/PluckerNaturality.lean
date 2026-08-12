/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.Lambda2Coordinates
import V14Formalization.GrassmannianLinearSection
import V14Formalization.GeometricFanoCarrier
import Mathlib.LinearAlgebra.ExteriorPower.Basis
import Mathlib.LinearAlgebra.ExteriorAlgebra.Basis
import Mathlib.Algebra.MvPolynomial.Funext
import Mathlib.Order.Hom.PowersetCard
import Mathlib.GroupTheory.QuotientGroup.Basic
import Mathlib.Data.Finset.Card
import Mathlib.Tactic.FinCases

/-!
# Plücker span naturality under the exterior-square representation

Infrastructure for the sealed-coordinate theorem

```
V14SchemeModel.plucker_span_aeval_lambda2_le (g : G)
```

Preferred route (compound matrix + lex indexing):

1. Matrix coefficients of `exteriorPower.map n f` are minors
   (`exterior_repr_map_eq_det_cross`).
2. Order-2 compound matrix equals `toMatrix` of the exterior-square map
   (`toMatrix_exteriorPower_eq_compound2Powerset`).
3. Lex pair reindexing: every `ρ(g)` is `compound2Lex A` for the Weil
   coordinate matrix of a lift of `g`
   (`lambda2MatrixRepresentation_eq_compound2Lex`).
4. Lex four-subset enumeration matching `pluckerRelation` order
   (`fourEnumeration`, bijective).
5. Free-variable identity
   `q_t(C₂(A) x) = ∑_s det(A[t|s]) q_s(x)`, then ideal-span membership
   via `eval_aeval_linearSubst` and homogeneous `MvPolynomial.funext`.

All five steps are proved unconditionally: no `sorry`, no project axioms,
no `native_decide`, and no nondefault heartbeat or recursion-depth options.
-/

noncomputable section

open Set Matrix exteriorPower Module

namespace V14Formalization
namespace PluckerNaturality

open Lambda2Coordinates
open GeometricFanoCarrier (PSL2F11 SLG weilLambda2 pslLambda2Hom pslLambda2_mk)
open SchemeGeometry

abbrev k := Lambda2Coordinates.k
abbrev G := Lambda2Coordinates.G

variable {R : Type*} [CommRing R]
variable {ι : Type*} [LinearOrder ι] [Fintype ι] [DecidableEq ι]
variable {V : Type*} [AddCommGroup V] [Module R V]

/-! ### Step 1: exterior-square matrix coefficients are minors -/

/-- Matrix entry of `exteriorPower.map n f` in the exterior basis is an
`n × n` minor determinant. -/
theorem exterior_repr_map_eq_det_cross
    (n : ℕ) (b : Basis ι R V) (f : Module.End R V)
    (s t : powersetCard ι n) :
    (b.exteriorPower n).repr
        (exteriorPower.map n f (b.exteriorPower n s)) t =
      ((LinearMap.toMatrix b b f).submatrix
        (powersetCard.ofFinEmbEquiv.symm t)
        (powersetCard.ofFinEmbEquiv.symm s)).det := by
  set B := b.exteriorPower n
  set embS := powersetCard.ofFinEmbEquiv.symm s
  set embT := powersetCard.ofFinEmbEquiv.symm t
  have hBs : B s = exteriorPower.ιMulti_family R n (b : ι → V) s := by
    simp only [B]
    exact exteriorPower.basis_apply (R := R) (n := n) b s
  rw [hBs, exteriorPower.basis_repr_apply (R := R) (n := n) b]
  have hmap :
      exteriorPower.map n f (exteriorPower.ιMulti_family R n (b : ι → V) s) =
        exteriorPower.ιMulti R n (fun i : Fin n => f (b (embS i))) := by
    dsimp [exteriorPower.ιMulti_family, embS]
    rw [exteriorPower.map_apply_ιMulti]
    rfl
  rw [hmap, exteriorPower.ιMultiDual_apply_ιMulti (R := R) (n := n) b t]
  have hT :
      (Matrix.of fun i j : Fin n => b.coord (embT j) (f (b (embS i)))) =
        ((LinearMap.toMatrix b b f).submatrix embT embS)ᵀ := by
    ext i j
    simp [Matrix.transpose_apply, Matrix.of_apply, Matrix.submatrix_apply,
      LinearMap.toMatrix_apply, Basis.coord_apply]
  rw [hT, Matrix.det_transpose]

/-! ### Step 2: order-2 compound matrix -/

/-- Order-2 compound matrix on the `powersetCard · 2` basis. -/
def compound2Powerset (A : Matrix ι ι R) :
    Matrix (powersetCard ι 2) (powersetCard ι 2) R :=
  Matrix.of fun s t =>
    (A.submatrix (powersetCard.ofFinEmbEquiv.symm s)
      (powersetCard.ofFinEmbEquiv.symm t)).det

/-- `toMatrix` of `exteriorPower.map 2 f` is the order-2 compound matrix of
`toMatrix f`. -/
theorem toMatrix_exteriorPower_eq_compound2Powerset
    (b : Basis ι R V) (f : Module.End R V) :
    LinearMap.toMatrix (b.exteriorPower 2) (b.exteriorPower 2)
        (exteriorPower.map 2 f) =
      compound2Powerset (LinearMap.toMatrix b b f) := by
  ext s t
  simp only [LinearMap.toMatrix_apply, compound2Powerset, Matrix.of_apply]
  exact exterior_repr_map_eq_det_cross (n := 2) b f t s

/-! ### Step 3: lex pair compound matrix = sealed `ρ(g)` -/

/-- Ordered embedding of the `i`-th lex pair into `Fin 6`. -/
def pairEmb (i : Fin 15) : Fin 2 ↪o Fin 6 :=
  powersetCard.ofFinEmbEquiv.symm (pairEnumeration i)

/-- Order-2 compound matrix in the sealed lex Plücker coordinate order
`01,02,...,45`. -/
def compound2Lex (A : Matrix (Fin 6) (Fin 6) R) : Matrix (Fin 15) (Fin 15) R :=
  Matrix.of fun i j => (A.submatrix (pairEmb i) (pairEmb j)).det

theorem pluckerPairEquiv_symm_apply (i : Fin 15) :
    pluckerPairEquiv.symm i = pairEnumeration i :=
  Equiv.ofBijective_apply pairEnumeration pairEnumeration_bijective i

theorem toMatrix_lambda2Basis_reindex
    (f : Module.End k Lambda2U) (i j : Fin 15) :
    LinearMap.toMatrix lambda2Basis lambda2Basis f i j =
      LinearMap.toMatrix (uBasisCore.exteriorPower 2) (uBasisCore.exteriorPower 2) f
        (pluckerPairEquiv.symm i) (pluckerPairEquiv.symm j) := by
  simp only [lambda2Basis, LinearMap.toMatrix_apply, Basis.reindex_apply,
    Basis.repr_reindex, Finsupp.mapDomain_equiv_apply]

/-- The exterior-square Weil action in lex Plücker coordinates is the compound
matrix of the coordinate Weil action on `U`. -/
theorem weilLambda2_toMatrix_eq_compound2Lex (g : SLG) :
    LinearMap.toMatrix lambda2Basis lambda2Basis (weilLambda2 g) =
      compound2Lex
        (LinearMap.toMatrix uBasisCore uBasisCore (WeilHom.weilUHom g)) := by
  have hpow :
      LinearMap.toMatrix (uBasisCore.exteriorPower 2) (uBasisCore.exteriorPower 2)
          (exteriorPower.map 2 (WeilHom.weilUHom g)) =
        compound2Powerset
          (LinearMap.toMatrix uBasisCore uBasisCore (WeilHom.weilUHom g)) :=
    toMatrix_exteriorPower_eq_compound2Powerset uBasisCore (WeilHom.weilUHom g)
  ext i j
  rw [toMatrix_lambda2Basis_reindex,
    show weilLambda2 g = exteriorPower.map 2 (WeilHom.weilUHom g) from rfl, hpow]
  simp only [compound2Lex, compound2Powerset, Matrix.of_apply, pairEmb,
    pluckerPairEquiv_symm_apply]

/-- PSL quotient form of the compound identification. -/
theorem pslLambda2_toMatrix_eq_compound2Lex (g : PSL2F11) :
    ∃ A : Matrix (Fin 6) (Fin 6) k,
      LinearMap.toMatrix lambda2Basis lambda2Basis (pslLambda2Hom g) =
        compound2Lex A := by
  refine QuotientGroup.induction_on g fun g => ?_
  refine ⟨LinearMap.toMatrix uBasisCore uBasisCore (WeilHom.weilUHom g), ?_⟩
  simpa [pslLambda2_mk] using weilLambda2_toMatrix_eq_compound2Lex g

/-- Every sealed matrix `ρ(g)` is an order-2 compound matrix in lex coordinates. -/
theorem lambda2MatrixRepresentation_eq_compound2Lex (g : G) :
    ∃ A : Matrix (Fin 6) (Fin 6) k,
      (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k) =
        compound2Lex A := by
  simpa [lambda2MatrixRepresentation_coe] using
    pslLambda2_toMatrix_eq_compound2Lex g

/-! ### Step 4: lex four-subset enumeration (matches `pluckerRelation` order) -/

lemma card_insert4 {α : Type*} [DecidableEq α] (a b c d : α)
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    ({a, b, c, d} : Finset α).card = 4 := by
  have h1 : a ∉ ({b, c, d} : Finset α) := by
    intro h; simp at h; rcases h with h | h | h <;> contradiction
  have h2 : b ∉ ({c, d} : Finset α) := by
    intro h; simp at h; rcases h with h | h <;> contradiction
  have h3 : c ∉ ({d} : Finset α) := by
    intro h; simp at h; contradiction
  simp [Finset.card_insert_of_notMem, h1, h2, h3, Finset.card_singleton]

/-- Four-subset with an explicit cardinality certificate. -/
def four (a b c d : Fin 6)
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    powersetCard (Fin 6) 4 :=
  ⟨{a, b, c, d}, card_insert4 a b c d hab hac had hbc hbd hcd⟩

/-- Lexicographic enumeration of 4-subsets of `Fin 6`, in the same order as
`SchemeGeometry.pluckerRelation` / `pluckerQuadric`. -/
def fourEnumeration : Fin 15 → powersetCard (Fin 6) 4
  | ⟨0, _⟩ => four 0 1 2 3 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨1, _⟩ => four 0 1 2 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨2, _⟩ => four 0 1 2 5 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨3, _⟩ => four 0 1 3 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨4, _⟩ => four 0 1 3 5 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨5, _⟩ => four 0 1 4 5 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨6, _⟩ => four 0 2 3 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨7, _⟩ => four 0 2 3 5 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨8, _⟩ => four 0 2 4 5 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨9, _⟩ => four 0 3 4 5 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨10, _⟩ => four 1 2 3 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨11, _⟩ => four 1 2 3 5 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨12, _⟩ => four 1 2 4 5 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨13, _⟩ => four 1 3 4 5 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  | ⟨14, _⟩ => four 2 3 4 5 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)

theorem fourEnumeration_injective : Function.Injective fourEnumeration := by
  intro a b h
  have hv : (fourEnumeration a).val = (fourEnumeration b).val :=
    congrArg Subtype.val h
  fin_cases a <;> fin_cases b <;> try rfl
  all_goals (simp [fourEnumeration, four] at hv; exact absurd hv (by decide))

theorem fourEnumeration_bijective : Function.Bijective fourEnumeration := by
  refine (Fintype.bijective_iff_injective_and_card fourEnumeration).mpr
    ⟨fourEnumeration_injective, ?_⟩
  rw [Fintype.card_fin, Fintype.card_eq_nat_card, powersetCard.card, Nat.card_fin]
  decide

/-- Ordered embedding of the `t`-th lex four-subset into `Fin 6`. -/
def fourEmb (t : Fin 15) : Fin 4 ↪o Fin 6 :=
  powersetCard.ofFinEmbEquiv.symm (fourEnumeration t)

/-- Pair coordinate of two distinct ambient indices in the sealed lex order. -/
def pairCoord (i j : Fin 6) (hij : i ≠ j) : Fin 15 :=
  pluckerPairEquiv (pair i j hij)

/-- Order-4 compound minor between two lex four-subsets. -/
def compound4Lex (A : Matrix (Fin 6) (Fin 6) R) (t s : Fin 15) : R :=
  (A.submatrix (fourEmb t) (fourEmb s)).det

/-- Pointwise Plücker value of a coordinate vector (evaluation of `pluckerQuadric`). -/
def pluckerValue (x : Fin 15 → R) (t : Fin 15) : R :=
  let d := pluckerRelation t
  x d.p1 * x d.p2 - x d.p3 * x d.p4 + x d.p5 * x d.p6

theorem pluckerValue_eq_eval (x : Fin 15 → R) (t : Fin 15) :
    pluckerValue x t = MvPolynomial.eval x (pluckerQuadric R t) := by
  simp [pluckerValue, pluckerQuadric]

/-! ### Step 5: the compound Plücker identity and ideal-span naturality -/

noncomputable abbrev b4 : Basis (Fin 4) R (Fin 4 → R) := Pi.basisFun R (Fin 4)

theorem fin4Vec_eq_id : (![0, 1, 2, 3] : Fin 4 → Fin 4) = id := by
  funext x
  fin_cases x <;> rfl

theorem injective_vec4_iff (a b c d : Fin 4) :
    Function.Injective (![a, b, c, d] : Fin 4 → Fin 4) ↔
      a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ b ≠ c ∧ b ≠ d ∧ c ≠ d := by
  constructor
  · intro h
    constructor
    · intro hab
      have : (0 : Fin 4) = 1 := h (by simpa [hab])
      exact (show (0 : Fin 4) ≠ 1 by decide) this
    constructor
    · intro hac
      have : (0 : Fin 4) = 2 := h (by simpa [hac])
      exact (show (0 : Fin 4) ≠ 2 by decide) this
    constructor
    · intro had
      have : (0 : Fin 4) = 3 := h (by simpa [had])
      exact (show (0 : Fin 4) ≠ 3 by decide) this
    constructor
    · intro hbc
      have : (1 : Fin 4) = 2 := h (by simpa [hbc])
      exact (show (1 : Fin 4) ≠ 2 by decide) this
    constructor
    · intro hbd
      have : (1 : Fin 4) = 3 := h (by simpa [hbd])
      exact (show (1 : Fin 4) ≠ 3 by decide) this
    · intro hcd
      have : (2 : Fin 4) = 3 := h (by simpa [hcd])
      exact (show (2 : Fin 4) ≠ 3 by decide) this
  · rintro ⟨hab, hac, had, hbc, hbd, hcd⟩ x y hxy
    fin_cases x <;> fin_cases y <;> simp_all

theorem b4Vec_eq_b4 :
    (![b4 (R := R) 0, b4 (R := R) 1, b4 (R := R) 2, b4 (R := R) 3] :
      Fin 4 → (Fin 4 → R)) = b4 (R := R) := by
  funext x
  fin_cases x <;> rfl

noncomputable def omega (i j : Fin 4) : ExteriorAlgebra R (Fin 4 → R) :=
  ExteriorAlgebra.ιMulti R 2 ![b4 (R := R) i, b4 (R := R) j]

noncomputable def vol : ExteriorAlgebra R (Fin 4 → R) :=
  ExteriorAlgebra.ιMulti R 4
    ![b4 (R := R) 0, b4 (R := R) 1, b4 (R := R) 2, b4 (R := R) 3]

theorem omega_mul_omega (i j k l : Fin 4) :
    omega (R := R) i j * omega (R := R) k l =
      ExteriorAlgebra.ιMulti R 4
        ![b4 (R := R) i, b4 (R := R) j, b4 (R := R) k, b4 (R := R) l] := by
  rw [omega, omega, ExteriorAlgebra.ιMulti_mul_ιMulti]
  congr 1
  funext x
  fin_cases x <;> rfl

theorem omega_mul_eq_zero (i j k l : Fin 4)
    (h : ¬ Function.Injective (![i, j, k, l] : Fin 4 → Fin 4)) :
    omega (R := R) i j * omega (R := R) k l = 0 := by
  rw [omega_mul_omega]
  apply ExteriorAlgebra.ιMulti_eq_zero_of_not_inj
  intro hinj
  apply h
  have hv : (![b4 (R := R) i, b4 (R := R) j, b4 (R := R) k, b4 (R := R) l] :
      Fin 4 → (Fin 4 → R)) = b4 (R := R) ∘ (![i, j, k, l] : Fin 4 → Fin 4) := by
    funext x
    fin_cases x <;> rfl
  rw [hv] at hinj
  intro a b hab
  apply hinj
  exact congrArg (b4 (R := R)) hab

def perm0213 : Equiv.Perm (Fin 4) :=
  Equiv.ofBijective ![(0 : Fin 4), 2, 1, 3] (by decide)

def perm2301 : Equiv.Perm (Fin 4) :=
  Equiv.ofBijective ![(2 : Fin 4), 3, 0, 1] (by decide)

def perm1302 : Equiv.Perm (Fin 4) :=
  Equiv.ofBijective ![(1 : Fin 4), 3, 0, 2] (by decide)

def perm0312 : Equiv.Perm (Fin 4) :=
  Equiv.ofBijective ![(0 : Fin 4), 3, 1, 2] (by decide)

def perm1203 : Equiv.Perm (Fin 4) :=
  Equiv.ofBijective ![(1 : Fin 4), 2, 0, 3] (by decide)

theorem sign_perm0213 : perm0213.sign = -1 := by
  have h : perm0213 = Equiv.swap 1 2 := by
    ext i
    fin_cases i <;> rfl
  rw [h, Equiv.Perm.sign_swap (by decide)]

theorem sign_perm2301 : perm2301.sign = 1 := by
  have h : perm2301 = Equiv.swap 0 2 * Equiv.swap 1 3 := by
    ext i
    fin_cases i <;> simp [perm2301, Equiv.Perm.mul_apply, Equiv.swap_apply_def]
  rw [h, Equiv.Perm.sign_mul, Equiv.Perm.sign_swap (by decide),
    Equiv.Perm.sign_swap (by decide)]
  norm_num

theorem sign_perm1302 : perm1302.sign = -1 := by
  have h : perm1302 = Equiv.swap 0 2 * Equiv.swap 0 1 * Equiv.swap 1 3 := by
    ext i
    fin_cases i <;> simp [perm1302, Equiv.Perm.mul_apply, Equiv.swap_apply_def]
  rw [h, Equiv.Perm.sign_mul, Equiv.Perm.sign_mul,
    Equiv.Perm.sign_swap (by decide), Equiv.Perm.sign_swap (by decide),
    Equiv.Perm.sign_swap (by decide)]
  norm_num

theorem sign_perm0312 : perm0312.sign = 1 := by
  have h : perm0312 = Equiv.swap 1 2 * Equiv.swap 1 3 := by
    ext i
    fin_cases i <;> simp [perm0312, Equiv.Perm.mul_apply, Equiv.swap_apply_def]
  rw [h, Equiv.Perm.sign_mul, Equiv.Perm.sign_swap (by decide),
    Equiv.Perm.sign_swap (by decide)]
  norm_num

theorem sign_perm1203 : perm1203.sign = 1 := by
  have h : perm1203 = Equiv.swap 0 2 * Equiv.swap 0 1 := by
    ext i
    fin_cases i <;> simp [perm1203, Equiv.Perm.mul_apply, Equiv.swap_apply_def]
  rw [h, Equiv.Perm.sign_mul, Equiv.Perm.sign_swap (by decide),
    Equiv.Perm.sign_swap (by decide)]
  norm_num

theorem omega_mul_of_perm (i j k l : Fin 4) (σ : Equiv.Perm (Fin 4))
    (hσ : (![i, j, k, l] : Fin 4 → Fin 4) = (![0, 1, 2, 3] : Fin 4 → Fin 4) ∘ σ) :
    omega (R := R) i j * omega (R := R) k l = σ.sign • vol (R := R) := by
  rw [omega_mul_omega, vol]
  have hv : (![b4 (R := R) i, b4 (R := R) j, b4 (R := R) k, b4 (R := R) l] :
      Fin 4 → (Fin 4 → R)) =
      (![b4 (R := R) 0, b4 (R := R) 1, b4 (R := R) 2, b4 (R := R) 3] :
        Fin 4 → (Fin 4 → R)) ∘ σ := by
    rw [b4Vec_eq_b4]
    have hσ' : (![i, j, k, l] : Fin 4 → Fin 4) = σ := by
      simpa [fin4Vec_eq_id] using hσ
    have hvleft :
        (![b4 (R := R) i, b4 (R := R) j, b4 (R := R) k, b4 (R := R) l] :
          Fin 4 → (Fin 4 → R)) = b4 (R := R) ∘ (![i, j, k, l] : Fin 4 → Fin 4) := by
      funext x
      fin_cases x <;> rfl
    rw [hvleft, hσ']
  rw [hv]
  exact AlternatingMap.map_perm (ExteriorAlgebra.ιMulti R 4) _ σ

theorem omega_mul_formula (i j k l : Fin 4) :
    omega (R := R) i j * omega (R := R) k l =
      if h : Function.Injective (![i, j, k, l] : Fin 4 → Fin 4) then
        let σ : Equiv.Perm (Fin 4) := Equiv.ofBijective ![i, j, k, l]
          ((Fintype.bijective_iff_injective_and_card _).mpr ⟨h, rfl⟩)
        σ.sign • vol (R := R)
      else 0 := by
  split_ifs with h
  · let σ : Equiv.Perm (Fin 4) := Equiv.ofBijective ![i, j, k, l]
      ((Fintype.bijective_iff_injective_and_card _).mpr ⟨h, rfl⟩)
    apply omega_mul_of_perm i j k l σ
    rw [fin4Vec_eq_id, Function.id_comp]
    rfl
  · exact omega_mul_eq_zero i j k l h

theorem omega01_mul_omega23 :
    omega (R := R) 0 1 * omega (R := R) 2 3 = vol (R := R) := by
  simpa using omega_mul_of_perm (R := R) 0 1 2 3 1 rfl

theorem omega23_mul_omega01 :
    omega (R := R) 2 3 * omega (R := R) 0 1 = vol (R := R) := by
  rw [omega_mul_of_perm (R := R) 2 3 0 1 perm2301 (by
    funext i; fin_cases i <;> rfl), sign_perm2301, one_smul]

theorem omega02_mul_omega13 :
    omega (R := R) 0 2 * omega (R := R) 1 3 = -vol (R := R) := by
  rw [omega_mul_of_perm (R := R) 0 2 1 3 perm0213 (by
    funext i; fin_cases i <;> rfl), sign_perm0213]
  simp

theorem omega13_mul_omega02 :
    omega (R := R) 1 3 * omega (R := R) 0 2 = -vol (R := R) := by
  rw [omega_mul_of_perm (R := R) 1 3 0 2 perm1302 (by
    funext i; fin_cases i <;> rfl), sign_perm1302]
  simp

theorem omega03_mul_omega12 :
    omega (R := R) 0 3 * omega (R := R) 1 2 = vol (R := R) := by
  rw [omega_mul_of_perm (R := R) 0 3 1 2 perm0312 (by
    funext i; fin_cases i <;> rfl), sign_perm0312, one_smul]

theorem omega12_mul_omega03 :
    omega (R := R) 1 2 * omega (R := R) 0 3 = vol (R := R) := by
  rw [omega_mul_of_perm (R := R) 1 2 0 3 perm1203 (by
    funext i; fin_cases i <;> rfl), sign_perm1203, one_smul]

noncomputable def stdBiv (a b c d e f : R) : ExteriorAlgebra R (Fin 4 → R) :=
  a • omega 0 1 + b • omega 0 2 + c • omega 0 3 +
    d • omega 1 2 + e • omega 1 3 + f • omega 2 3

theorem stdBiv_sq (a b c d e f : R) :
    stdBiv a b c d e f * stdBiv a b c d e f =
      (2 * (a*f - b*e + c*d)) • vol (R := R) := by
  simp only [stdBiv, mul_add, add_mul, smul_mul_assoc, mul_smul_comm]
  simp only [omega01_mul_omega23, omega23_mul_omega01,
    omega02_mul_omega13, omega13_mul_omega02,
    omega03_mul_omega12, omega12_mul_omega03]
  simp [omega_mul_formula, injective_vec4_iff]
  module

/-! Restrict a bivector in six coordinates to an ordered four-subset. -/

noncomputable abbrev b6 : Basis (Fin 6) R (Fin 6 → R) := Pi.basisFun R (Fin 6)

def pairLexVec : Fin 15 → Fin 2 → Fin 6 := ![
  ![0, 1], ![0, 2], ![0, 3], ![0, 4], ![0, 5],
  ![1, 2], ![1, 3], ![1, 4], ![1, 5],
  ![2, 3], ![2, 4], ![2, 5], ![3, 4], ![3, 5], ![4, 5]]

def fourLexVec : Fin 15 → Fin 4 → Fin 6 := ![
  ![0, 1, 2, 3], ![0, 1, 2, 4], ![0, 1, 2, 5],
  ![0, 1, 3, 4], ![0, 1, 3, 5], ![0, 1, 4, 5],
  ![0, 2, 3, 4], ![0, 2, 3, 5], ![0, 2, 4, 5], ![0, 3, 4, 5],
  ![1, 2, 3, 4], ![1, 2, 3, 5], ![1, 2, 4, 5], ![1, 3, 4, 5],
  ![2, 3, 4, 5]]

def fourLexEmb (t : Fin 15) : Fin 4 ↪o Fin 6 :=
  OrderEmbedding.ofStrictMono (fourLexVec t) (by
    intro a b hab
    fin_cases t <;> fin_cases a <;> fin_cases b <;> simp_all [fourLexVec])

theorem fourLexVec_injective (t : Fin 15) : Function.Injective (fourLexVec t) :=
  (fourLexEmb t).injective

noncomputable def restrict4 (t : Fin 15) : (Fin 6 → R) →ₗ[R] (Fin 4 → R) where
  toFun v a := v (fourLexVec t a)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

noncomputable def restrictedBasis (t : Fin 15) (j : Fin 6) : Fin 4 → R :=
  if j = fourLexEmb t 0 then b4 (R := R) 0 else
  if j = fourLexEmb t 1 then b4 (R := R) 1 else
  if j = fourLexEmb t 2 then b4 (R := R) 2 else
  if j = fourLexEmb t 3 then b4 (R := R) 3 else 0

theorem restrict4_b6 (t : Fin 15) (j : Fin 6) :
    restrict4 (R := R) t (b6 (R := R) j) = restrictedBasis (R := R) t j := by
  funext a
  fin_cases a
  · by_cases h : j = fourLexVec t 0 <;>
      simp [restrict4, restrictedBasis, b6, b4, Pi.single_apply, fourLexEmb,
        h, (fourLexVec_injective t).eq_iff] <;>
      split_ifs <;> simp [b4, Pi.single_apply]
  · by_cases h : j = fourLexVec t 1 <;>
      simp [restrict4, restrictedBasis, b6, b4, Pi.single_apply, fourLexEmb,
        h, (fourLexVec_injective t).eq_iff] <;>
      split_ifs <;> simp [b4, Pi.single_apply]
  · by_cases h : j = fourLexVec t 2 <;>
      simp [restrict4, restrictedBasis, b6, b4, Pi.single_apply, fourLexEmb,
        h, (fourLexVec_injective t).eq_iff] <;>
      split_ifs <;> simp [b4, Pi.single_apply]
  · by_cases h : j = fourLexVec t 3 <;>
      simp [restrict4, restrictedBasis, b6, b4, Pi.single_apply, fourLexEmb,
        h, (fourLexVec_injective t).eq_iff] <;>
      split_ifs <;> simp [b4, Pi.single_apply]

noncomputable def sourceOmega (i : Fin 15) : ExteriorAlgebra R (Fin 6 → R) :=
  ExteriorAlgebra.ι R (b6 (R := R) (pairLexVec i 0)) *
    ExteriorAlgebra.ι R (b6 (R := R) (pairLexVec i 1))

noncomputable def sourceWedge (x : Fin 15 → R) : ExteriorAlgebra R (Fin 6 → R) :=
  ∑ i, x i • sourceOmega i

noncomputable def relationStdBiv (x : Fin 15 → R) (t : Fin 15) :
    ExteriorAlgebra R (Fin 4 → R) :=
  let d := V14Formalization.SchemeGeometry.pluckerRelation t
  stdBiv (x d.p1) (x d.p3) (x d.p5) (x d.p6) (x d.p4) (x d.p2)

theorem map_sourceWedge_restrict4_0 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 0) (sourceWedge x) =
      relationStdBiv x 0 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_1 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 1) (sourceWedge x) =
      relationStdBiv x 1 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_2 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 2) (sourceWedge x) =
      relationStdBiv x 2 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_3 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 3) (sourceWedge x) =
      relationStdBiv x 3 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_4 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 4) (sourceWedge x) =
      relationStdBiv x 4 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_5 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 5) (sourceWedge x) =
      relationStdBiv x 5 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_6 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 6) (sourceWedge x) =
      relationStdBiv x 6 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_7 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 7) (sourceWedge x) =
      relationStdBiv x 7 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_8 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 8) (sourceWedge x) =
      relationStdBiv x 8 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_9 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 9) (sourceWedge x) =
      relationStdBiv x 9 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_10 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 10) (sourceWedge x) =
      relationStdBiv x 10 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_11 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 11) (sourceWedge x) =
      relationStdBiv x 11 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_12 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 12) (sourceWedge x) =
      relationStdBiv x 12 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_13 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 13) (sourceWedge x) =
      relationStdBiv x 13 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module

theorem map_sourceWedge_restrict4_14 (x : Fin 15 → R) :
    ExteriorAlgebra.map (restrict4 (R := R) 14) (sourceWedge x) =
      relationStdBiv x 14 := by
  simp only [sourceWedge, map_sum, map_smul, sourceOmega,
    map_mul, ExteriorAlgebra.map_apply_ι]
  simp_rw [restrict4_b6]
  simp [relationStdBiv, stdBiv, omega, pairLexVec,
    V14Formalization.SchemeGeometry.pluckerRelation, restrictedBasis,
    fourLexEmb, fourLexVec, Fin.sum_univ_succ]
  module


theorem map_sourceWedge_restrict4 (x : Fin 15 → R) (t : Fin 15) :
    ExteriorAlgebra.map (restrict4 (R := R) t) (sourceWedge x) =
      relationStdBiv x t := by
  fin_cases t
  · exact map_sourceWedge_restrict4_0 x
  · exact map_sourceWedge_restrict4_1 x
  · exact map_sourceWedge_restrict4_2 x
  · exact map_sourceWedge_restrict4_3 x
  · exact map_sourceWedge_restrict4_4 x
  · exact map_sourceWedge_restrict4_5 x
  · exact map_sourceWedge_restrict4_6 x
  · exact map_sourceWedge_restrict4_7 x
  · exact map_sourceWedge_restrict4_8 x
  · exact map_sourceWedge_restrict4_9 x
  · exact map_sourceWedge_restrict4_10 x
  · exact map_sourceWedge_restrict4_11 x
  · exact map_sourceWedge_restrict4_12 x
  · exact map_sourceWedge_restrict4_13 x
  · exact map_sourceWedge_restrict4_14 x

theorem map_sourceWedge_sq_restrict4 (x : Fin 15 → R) (t : Fin 15) :
    ExteriorAlgebra.map (restrict4 (R := R) t)
        (sourceWedge x * sourceWedge x) =
      (2 * V14Formalization.PluckerNaturality.pluckerValue x t) •
        vol (R := R) := by
  rw [map_mul, map_sourceWedge_restrict4]
  simp only [relationStdBiv]
  rw [stdBiv_sq]
  rfl

def pairLexEmb (i : Fin 15) : Fin 2 ↪o Fin 6 :=
  OrderEmbedding.ofStrictMono (pairLexVec i) (by
    intro a b hab
    fin_cases i <;> fin_cases a <;> fin_cases b <;> simp_all [pairLexVec])

theorem pairEmb_eq_pairLexEmb (i : Fin 15) :
    V14Formalization.PluckerNaturality.pairEmb i = pairLexEmb i := by
  apply Set.powersetCard.ofFinEmbEquiv.injective
  simp only [V14Formalization.PluckerNaturality.pairEmb, Equiv.apply_symm_apply]
  ext a
  fin_cases i <;> fin_cases a <;>
    simp [pairLexEmb, pairLexVec,
      V14Formalization.Lambda2Coordinates.pairEnumeration,
      V14Formalization.Lambda2Coordinates.pair,
      Set.powersetCard.ofFinEmbEquiv_apply]

noncomputable abbrev E2_6 := ⋀[R]^2 (Fin 6 → R)
noncomputable abbrev E4_6 := ⋀[R]^4 (Fin 6 → R)

noncomputable def lex2Basis : Basis (Fin 15) R (E2_6 (R := R)) :=
  ((b6 (R := R)).exteriorPower 2).reindex
    V14Formalization.Lambda2Coordinates.pluckerPairEquiv

@[simp] theorem lex2Basis_apply (i : Fin 15) :
    lex2Basis (R := R) i =
      (b6 (R := R)).exteriorPower 2
        (V14Formalization.Lambda2Coordinates.pairEnumeration i) := by
  rw [lex2Basis, Basis.reindex_apply]
  congr 1

noncomputable def sourceBivector (x : Fin 15 → R) : E2_6 (R := R) :=
  (lex2Basis (R := R)).equivFun.symm x

theorem coe_sourceBivector (x : Fin 15 → R) :
    ((sourceBivector x : E2_6 (R := R)) :
        ExteriorAlgebra R (Fin 6 → R)) = sourceWedge x := by
  rw [sourceBivector, Basis.equivFun_symm_apply]
  change (Submodule.subtype (E2_6 (R := R)))
      (∑ i, x i • lex2Basis (R := R) i) = sourceWedge x
  rw [map_sum]
  simp_rw [map_smul]
  change (∑ i, x i •
      ((lex2Basis (R := R) i : E2_6 (R := R)) :
          ExteriorAlgebra R (Fin 6 → R))) = ∑ i, x i • sourceOmega i
  apply Finset.sum_congr rfl
  intro i _
  congr 1
  rw [lex2Basis_apply, exteriorPower.basis_apply]
  change ExteriorAlgebra.ιMulti R 2
      (b6 (R := R) ∘ V14Formalization.PluckerNaturality.pairEmb i) = sourceOmega i
  rw [pairEmb_eq_pairLexEmb]
  simp [sourceOmega, pairLexEmb, ExteriorAlgebra.ιMulti_succ_apply,
    Matrix.vecTail]

theorem exterior_repr_map_eq_det_rect
    {M N : Type*} [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N]
    {I J : Type*} [LinearOrder I] [Fintype I] [DecidableEq I]
    [LinearOrder J] [Fintype J] [DecidableEq J]
    (n : ℕ) (bM : Basis I R M) (bN : Basis J R N) (f : M →ₗ[R] N)
    (s : powersetCard I n) (t : powersetCard J n) :
    (bN.exteriorPower n).repr
        (exteriorPower.map n f (bM.exteriorPower n s)) t =
      ((LinearMap.toMatrix bM bN f).submatrix
        (powersetCard.ofFinEmbEquiv.symm t)
        (powersetCard.ofFinEmbEquiv.symm s)).det := by
  set BM := bM.exteriorPower n
  set embS := powersetCard.ofFinEmbEquiv.symm s
  set embT := powersetCard.ofFinEmbEquiv.symm t
  have hBs : BM s = exteriorPower.ιMulti_family R n (bM : I → M) s := by
    simp only [BM]
    exact exteriorPower.basis_apply (R := R) (n := n) bM s
  rw [hBs, exteriorPower.basis_repr_apply (R := R) (n := n) bN]
  have hmap :
      exteriorPower.map n f
          (exteriorPower.ιMulti_family R n (bM : I → M) s) =
        exteriorPower.ιMulti R n (fun i : Fin n ↦ f (bM (embS i))) := by
    dsimp [exteriorPower.ιMulti_family, embS]
    rw [exteriorPower.map_apply_ιMulti]
    rfl
  rw [hmap, exteriorPower.ιMultiDual_apply_ιMulti (R := R) (n := n) bN t]
  have hT :
      (Matrix.of fun i j : Fin n => bN.coord (embT j) (f (bM (embS i)))) =
        ((LinearMap.toMatrix bM bN f).submatrix embT embS)ᵀ := by
    ext i j
    simp [Matrix.transpose_apply, Matrix.of_apply, Matrix.submatrix_apply,
      LinearMap.toMatrix_apply, Basis.coord_apply]
  rw [hT, Matrix.det_transpose]

noncomputable def top4 : powersetCard (Fin 4) 4 :=
  ⟨Finset.univ, by simp⟩

theorem top4Emb_eq :
    powersetCard.ofFinEmbEquiv.symm top4 = OrderEmbedding.id (Fin 4) := by
  apply powersetCard.ofFinEmbEquiv.injective
  apply Subtype.ext
  ext x
  simp [top4, powersetCard.ofFinEmbEquiv_apply]

theorem fourEmb_eq_fourLexEmb (t : Fin 15) :
    V14Formalization.PluckerNaturality.fourEmb t = fourLexEmb t := by
  apply powersetCard.ofFinEmbEquiv.injective
  simp only [V14Formalization.PluckerNaturality.fourEmb, Equiv.apply_symm_apply]
  ext a
  fin_cases t <;> fin_cases a <;>
    simp [fourLexEmb, fourLexVec,
      V14Formalization.PluckerNaturality.fourEnumeration,
      V14Formalization.PluckerNaturality.four,
      powersetCard.ofFinEmbEquiv_apply] <;> decide

noncomputable def wedgeMul6 :
    E2_6 (R := R) →ₗ[R] E2_6 (R := R) →ₗ[R] E4_6 (R := R) :=
  DirectSum.gMulLHom R (fun n ↦ ⋀[R]^n (Fin 6 → R))

theorem coe_wedgeMul6 (u v : E2_6 (R := R)) :
    ((wedgeMul6 u v : E4_6 (R := R)) : ExteriorAlgebra R (Fin 6 → R)) =
      (u : ExteriorAlgebra R (Fin 6 → R)) * v := by
  rfl

noncomputable def sourceSquare (x : Fin 15 → R) : E4_6 (R := R) :=
  wedgeMul6 (sourceBivector x) (sourceBivector x)

theorem coe_sourceSquare (x : Fin 15 → R) :
    ((sourceSquare x : E4_6 (R := R)) : ExteriorAlgebra R (Fin 6 → R)) =
      sourceWedge x * sourceWedge x := by
  rw [sourceSquare, coe_wedgeMul6, coe_sourceBivector]

noncomputable def squareLexCoord (x : Fin 15 → R) (t : Fin 15) : R :=
  ((b6 (R := R)).exteriorPower 4).repr (sourceSquare x)
    (V14Formalization.PluckerNaturality.fourEnumeration t)

theorem restrict4_det_0 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 0)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 0 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Matrix.det_fin_three, Fin.sum_univ_succ]

theorem restrict4_det_1 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 1)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 1 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_2 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 2)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 2 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_3 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 3)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 3 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_4 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 4)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 4 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_5 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 5)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 5 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_6 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 6)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 6 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_7 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 7)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 7 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_8 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 8)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 8 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_9 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 9)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 9 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_10 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 10)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 10 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_11 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 11)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 11 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_12 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 12)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 12 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_13 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 13)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 13 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]

theorem restrict4_det_14 (s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) 14)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = 14 then 1 else 0 := by
  fin_cases s <;>
    simp [LinearMap.toMatrix_apply, restrict4, top4Emb_eq,
      fourEmb_eq_fourLexEmb, fourLexEmb, fourLexVec, b6, b4,
      Matrix.det_succ_row_zero, Fin.sum_univ_succ]


theorem restrict4_det (t s : Fin 15) :
    ((LinearMap.toMatrix (b6 (R := R)) (b4 (R := R))
      (restrict4 (R := R) t)).submatrix
        (powersetCard.ofFinEmbEquiv.symm top4)
        (V14Formalization.PluckerNaturality.fourEmb s)).det =
      if s = t then 1 else 0 := by
  fin_cases t
  · exact restrict4_det_0 s
  · exact restrict4_det_1 s
  · exact restrict4_det_2 s
  · exact restrict4_det_3 s
  · exact restrict4_det_4 s
  · exact restrict4_det_5 s
  · exact restrict4_det_6 s
  · exact restrict4_det_7 s
  · exact restrict4_det_8 s
  · exact restrict4_det_9 s
  · exact restrict4_det_10 s
  · exact restrict4_det_11 s
  · exact restrict4_det_12 s
  · exact restrict4_det_13 s
  · exact restrict4_det_14 s

noncomputable def fourEquiv : Fin 15 ≃ powersetCard (Fin 6) 4 :=
  Equiv.ofBijective V14Formalization.PluckerNaturality.fourEnumeration
    V14Formalization.PluckerNaturality.fourEnumeration_bijective

@[simp] theorem fourEquiv_apply (s : Fin 15) :
    fourEquiv s = V14Formalization.PluckerNaturality.fourEnumeration s := rfl

theorem restrict4_top_repr (z : E4_6 (R := R)) (t : Fin 15) :
    ((b4 (R := R)).exteriorPower 4).repr
        (exteriorPower.map 4 (restrict4 (R := R) t) z) top4 =
      ((b6 (R := R)).exteriorPower 4).repr z
        (V14Formalization.PluckerNaturality.fourEnumeration t) := by
  have h := congrFun
    (LinearMap.toMatrix_mulVec_repr
      ((b6 (R := R)).exteriorPower 4)
      ((b4 (R := R)).exteriorPower 4)
      (exteriorPower.map 4 (restrict4 (R := R) t)) z) top4
  rw [← h]
  simp only [Matrix.mulVec, dotProduct]
  rw [← Equiv.sum_comp fourEquiv]
  have hcoeff (s : Fin 15) :
      LinearMap.toMatrix
          ((b6 (R := R)).exteriorPower 4)
          ((b4 (R := R)).exteriorPower 4)
          (exteriorPower.map 4 (restrict4 (R := R) t)) top4
          (V14Formalization.PluckerNaturality.fourEnumeration s) =
        if s = t then 1 else 0 := by
    rw [LinearMap.toMatrix_apply,
      exterior_repr_map_eq_det_rect]
    simpa [V14Formalization.PluckerNaturality.fourEmb] using
      restrict4_det (R := R) t s
  simp_rw [fourEquiv_apply, hcoeff]
  simp

theorem coe_exteriorPower_map_6_4
    (n : ℕ) (f : (Fin 6 → R) →ₗ[R] (Fin 4 → R))
    (u : ⋀[R]^n (Fin 6 → R)) :
    ((exteriorPower.map n f u : ⋀[R]^n (Fin 4 → R)) :
        ExteriorAlgebra R (Fin 4 → R)) =
      ExteriorAlgebra.map f (u : ExteriorAlgebra R (Fin 6 → R)) := by
  let B := (b6 (R := R)).exteriorPower n
  change ((Submodule.subtype (⋀[R]^n (Fin 4 → R))).comp
      (exteriorPower.map n f)) u =
    ((ExteriorAlgebra.map f).toLinearMap.comp
      (Submodule.subtype (⋀[R]^n (Fin 6 → R)))) u
  apply LinearMap.congr_fun _ u
  apply B.ext
  intro s
  simp only [B, exteriorPower.basis_apply, LinearMap.comp_apply,
    Submodule.coe_subtype, exteriorPower.map_apply_ιMulti_family,
    exteriorPower.ιMulti_family_apply_coe]
  simp only [ExteriorAlgebra.ιMulti_family, Function.comp_def]
  exact (ExteriorAlgebra.map_apply_ιMulti f _).symm

theorem coe_top4_basis :
    (((b4 (R := R)).exteriorPower 4 top4 : ⋀[R]^4 (Fin 4 → R)) :
        ExteriorAlgebra R (Fin 4 → R)) = vol (R := R) := by
  rw [exteriorPower.basis_apply]
  change ExteriorAlgebra.ιMulti R 4
      (b4 (R := R) ∘ powersetCard.ofFinEmbEquiv.symm top4) = vol (R := R)
  rw [top4Emb_eq]
  rfl

theorem map_sourceSquare_restrict4 (x : Fin 15 → R) (t : Fin 15) :
    exteriorPower.map 4 (restrict4 (R := R) t) (sourceSquare x) =
      (2 * V14Formalization.PluckerNaturality.pluckerValue x t) •
        ((b4 (R := R)).exteriorPower 4 top4) := by
  apply Subtype.ext
  simp only [coe_exteriorPower_map_6_4, coe_sourceSquare, map_sourceWedge_sq_restrict4,
    Submodule.coe_smul_of_tower, coe_top4_basis]

theorem squareLexCoord_eq_two_pluckerValue (x : Fin 15 → R) (t : Fin 15) :
    squareLexCoord x t =
      2 * V14Formalization.PluckerNaturality.pluckerValue x t := by
  rw [squareLexCoord, ← restrict4_top_repr (z := sourceSquare x) (t := t),
    map_sourceSquare_restrict4]
  simp

theorem sourceBivector_eq_equivFun_symm (x : Fin 15 → R) :
    sourceBivector x = (lex2Basis (R := R)).equivFun.symm x := by
  rfl

noncomputable def lex4Basis : Basis (Fin 15) R (E4_6 (R := R)) :=
  ((b6 (R := R)).exteriorPower 4).reindex fourEquiv.symm

@[simp] theorem lex4Basis_apply (t : Fin 15) :
    lex4Basis (R := R) t =
      (b6 (R := R)).exteriorPower 4
        (V14Formalization.PluckerNaturality.fourEnumeration t) := by
  rw [lex4Basis, Basis.reindex_apply]
  rfl

theorem squareLexCoord_eq_lex4_repr (x : Fin 15 → R) (t : Fin 15) :
    squareLexCoord x t = (lex4Basis (R := R)).repr (sourceSquare x) t := by
  simp [squareLexCoord, lex4Basis, Basis.repr_reindex,
    Finsupp.mapDomain_equiv_apply]

theorem coe_exteriorPower_map_6_6
    (n : ℕ) (f : (Fin 6 → R) →ₗ[R] (Fin 6 → R))
    (u : ⋀[R]^n (Fin 6 → R)) :
    ((exteriorPower.map n f u : ⋀[R]^n (Fin 6 → R)) :
        ExteriorAlgebra R (Fin 6 → R)) =
      ExteriorAlgebra.map f (u : ExteriorAlgebra R (Fin 6 → R)) := by
  let B := (b6 (R := R)).exteriorPower n
  change ((Submodule.subtype (⋀[R]^n (Fin 6 → R))).comp
      (exteriorPower.map n f)) u =
    ((ExteriorAlgebra.map f).toLinearMap.comp
      (Submodule.subtype (⋀[R]^n (Fin 6 → R)))) u
  apply LinearMap.congr_fun _ u
  apply B.ext
  intro s
  simp only [B, exteriorPower.basis_apply, LinearMap.comp_apply,
    Submodule.coe_subtype, exteriorPower.map_apply_ιMulti_family,
    exteriorPower.ιMulti_family_apply_coe]
  simp only [ExteriorAlgebra.ιMulti_family, Function.comp_def]
  exact (ExteriorAlgebra.map_apply_ιMulti f _).symm

theorem wedgeMul6_map (f : (Fin 6 → R) →ₗ[R] (Fin 6 → R))
    (u v : E2_6 (R := R)) :
    wedgeMul6 (exteriorPower.map 2 f u) (exteriorPower.map 2 f v) =
      exteriorPower.map 4 f (wedgeMul6 u v) := by
  apply Subtype.ext
  simp only [coe_wedgeMul6, coe_exteriorPower_map_6_6]
  rw [map_mul]

theorem sourceBivector_matrix_transform
    (f : (Fin 6 → R) →ₗ[R] (Fin 6 → R)) (x : Fin 15 → R) :
    sourceBivector
        ((LinearMap.toMatrix (lex2Basis (R := R)) (lex2Basis (R := R))
          (exteriorPower.map 2 f)).mulVec x) =
      exteriorPower.map 2 f (sourceBivector x) := by
  apply (lex2Basis (R := R)).equivFun.injective
  rw [sourceBivector, LinearEquiv.apply_symm_apply,
    Basis.equivFun_apply]
  have hx : ((lex2Basis (R := R)).repr (sourceBivector x) : Fin 15 → R) = x := by
    rw [← Basis.equivFun_apply, sourceBivector,
      LinearEquiv.apply_symm_apply]
  calc
    _ = (LinearMap.toMatrix (lex2Basis (R := R)) (lex2Basis (R := R))
          (exteriorPower.map 2 f)).mulVec
        ((lex2Basis (R := R)).repr (sourceBivector x)) :=
      congrArg _ hx.symm
    _ = _ := LinearMap.toMatrix_mulVec_repr
      (lex2Basis (R := R)) (lex2Basis (R := R))
      (exteriorPower.map 2 f) (sourceBivector x)

theorem sourceSquare_matrix_transform
    (f : (Fin 6 → R) →ₗ[R] (Fin 6 → R)) (x : Fin 15 → R) :
    sourceSquare
        ((LinearMap.toMatrix (lex2Basis (R := R)) (lex2Basis (R := R))
          (exteriorPower.map 2 f)).mulVec x) =
      exteriorPower.map 4 f (sourceSquare x) := by
  simp only [sourceSquare, sourceBivector_matrix_transform]
  exact wedgeMul6_map f (sourceBivector x) (sourceBivector x)

theorem squareLexCoord_matrix_transform
    (f : (Fin 6 → R) →ₗ[R] (Fin 6 → R))
    (x : Fin 15 → R) (t : Fin 15) :
    squareLexCoord
        ((LinearMap.toMatrix (lex2Basis (R := R)) (lex2Basis (R := R))
          (exteriorPower.map 2 f)).mulVec x) t =
      ∑ s, (LinearMap.toMatrix (lex4Basis (R := R)) (lex4Basis (R := R))
          (exteriorPower.map 4 f)) t s * squareLexCoord x s := by
  rw [squareLexCoord_eq_lex4_repr, sourceSquare_matrix_transform]
  have h := congrFun
    (LinearMap.toMatrix_mulVec_repr
      (lex4Basis (R := R)) (lex4Basis (R := R))
      (exteriorPower.map 4 f) (sourceSquare x)) t
  rw [← h]
  simp only [Matrix.mulVec, dotProduct]
  apply Finset.sum_congr rfl
  intro s _
  rw [squareLexCoord_eq_lex4_repr]

theorem toMatrix_lex2_reindex
    (f : E2_6 (R := R) →ₗ[R] E2_6 (R := R)) (i j : Fin 15) :
    LinearMap.toMatrix (lex2Basis (R := R)) (lex2Basis (R := R)) f i j =
      LinearMap.toMatrix ((b6 (R := R)).exteriorPower 2)
        ((b6 (R := R)).exteriorPower 2) f
        (V14Formalization.Lambda2Coordinates.pluckerPairEquiv.symm i)
        (V14Formalization.Lambda2Coordinates.pluckerPairEquiv.symm j) := by
  simp only [lex2Basis, LinearMap.toMatrix_apply, Basis.reindex_apply,
    Basis.repr_reindex, Finsupp.mapDomain_equiv_apply]

theorem toMatrix_exterior2_eq_compound2Lex
    (f : (Fin 6 → R) →ₗ[R] (Fin 6 → R)) :
    LinearMap.toMatrix (lex2Basis (R := R)) (lex2Basis (R := R))
        (exteriorPower.map 2 f) =
      V14Formalization.PluckerNaturality.compound2Lex
        (LinearMap.toMatrix (b6 (R := R)) (b6 (R := R)) f) := by
  have hpow :=
    V14Formalization.PluckerNaturality.toMatrix_exteriorPower_eq_compound2Powerset
      (b6 (R := R)) f
  ext i j
  rw [toMatrix_lex2_reindex, hpow]
  simp only [V14Formalization.PluckerNaturality.compound2Lex,
    V14Formalization.PluckerNaturality.compound2Powerset, Matrix.of_apply,
    V14Formalization.PluckerNaturality.pairEmb,
    V14Formalization.PluckerNaturality.pluckerPairEquiv_symm_apply]

theorem toMatrix_lex4_reindex
    (f : E4_6 (R := R) →ₗ[R] E4_6 (R := R)) (t s : Fin 15) :
    LinearMap.toMatrix (lex4Basis (R := R)) (lex4Basis (R := R)) f t s =
      LinearMap.toMatrix ((b6 (R := R)).exteriorPower 4)
        ((b6 (R := R)).exteriorPower 4) f
        (V14Formalization.PluckerNaturality.fourEnumeration t)
        (V14Formalization.PluckerNaturality.fourEnumeration s) := by
  simp [lex4Basis, LinearMap.toMatrix_apply, Basis.reindex_apply,
    Basis.repr_reindex, Finsupp.mapDomain_equiv_apply]

theorem toMatrix_exterior4_eq_compound4Lex
    (f : (Fin 6 → R) →ₗ[R] (Fin 6 → R)) :
    LinearMap.toMatrix (lex4Basis (R := R)) (lex4Basis (R := R))
        (exteriorPower.map 4 f) =
      V14Formalization.PluckerNaturality.compound4Lex
        (LinearMap.toMatrix (b6 (R := R)) (b6 (R := R)) f) := by
  ext t s
  rw [toMatrix_lex4_reindex]
  simp only [LinearMap.toMatrix_apply,
    V14Formalization.PluckerNaturality.compound4Lex]
  exact V14Formalization.PluckerNaturality.exterior_repr_map_eq_det_cross
    (n := 4) (b6 (R := R)) f
    (V14Formalization.PluckerNaturality.fourEnumeration s)
    (V14Formalization.PluckerNaturality.fourEnumeration t)

theorem squareLexCoord_compound_transform
    (A : Matrix (Fin 6) (Fin 6) R) (x : Fin 15 → R) (t : Fin 15) :
    squareLexCoord
        ((V14Formalization.PluckerNaturality.compound2Lex A).mulVec x) t =
      ∑ s, V14Formalization.PluckerNaturality.compound4Lex A t s *
        squareLexCoord x s := by
  let f := Matrix.toLin (b6 (R := R)) (b6 (R := R)) A
  have hf : LinearMap.toMatrix (b6 (R := R)) (b6 (R := R)) f = A := by
    simpa [f] using LinearMap.toMatrix_toLin (b6 (R := R)) (b6 (R := R)) A
  have h := squareLexCoord_matrix_transform (R := R) f x t
  rw [toMatrix_exterior2_eq_compound2Lex,
    toMatrix_exterior4_eq_compound4Lex, hf] at h
  exact h

theorem two_mul_pluckerValue_compound_transform
    (A : Matrix (Fin 6) (Fin 6) R) (x : Fin 15 → R) (t : Fin 15) :
    2 * V14Formalization.PluckerNaturality.pluckerValue
        ((V14Formalization.PluckerNaturality.compound2Lex A).mulVec x) t =
      ∑ s, V14Formalization.PluckerNaturality.compound4Lex A t s *
        (2 * V14Formalization.PluckerNaturality.pluckerValue x s) := by
  rw [← squareLexCoord_eq_two_pluckerValue,
    squareLexCoord_compound_transform]
  apply Finset.sum_congr rfl
  intro s _
  rw [squareLexCoord_eq_two_pluckerValue]

theorem pluckerValue_compound_transform [IsDomain R]
    (h2 : (2 : R) ≠ 0)
    (A : Matrix (Fin 6) (Fin 6) R) (x : Fin 15 → R) (t : Fin 15) :
    V14Formalization.PluckerNaturality.pluckerValue
        ((V14Formalization.PluckerNaturality.compound2Lex A).mulVec x) t =
      ∑ s, V14Formalization.PluckerNaturality.compound4Lex A t s *
        V14Formalization.PluckerNaturality.pluckerValue x s := by
  apply mul_left_cancel₀ h2
  rw [Finset.mul_sum]
  calc
    2 * V14Formalization.PluckerNaturality.pluckerValue
        ((V14Formalization.PluckerNaturality.compound2Lex A).mulVec x) t =
      ∑ s, V14Formalization.PluckerNaturality.compound4Lex A t s *
        (2 * V14Formalization.PluckerNaturality.pluckerValue x s) :=
          two_mul_pluckerValue_compound_transform A x t
    _ = ∑ s, 2 *
        (V14Formalization.PluckerNaturality.compound4Lex A t s *
          V14Formalization.PluckerNaturality.pluckerValue x s) := by
      apply Finset.sum_congr rfl
      intro s _
      ring

theorem aeval_pluckerQuadric_compound_transform [IsDomain R] [Infinite R]
    (h2 : (2 : R) ≠ 0)
    (A : Matrix (Fin 6) (Fin 6) R) (t : Fin 15) :
    (MvPolynomial.aeval
        (BConicBundleMultisections.linearSubst 14
          (V14Formalization.PluckerNaturality.compound2Lex A)) : _ →ₐ[R] _)
        (V14Formalization.SchemeGeometry.pluckerQuadric R t) =
      ∑ s, MvPolynomial.C
          (V14Formalization.PluckerNaturality.compound4Lex A t s) *
        V14Formalization.SchemeGeometry.pluckerQuadric R s := by
  apply MvPolynomial.funext
  intro x
  rw [BConicBundleMultisections.eval_aeval_linearSubst]
  simpa [V14Formalization.PluckerNaturality.pluckerValue_eq_eval] using
    pluckerValue_compound_transform (R := R) h2 A x t

theorem span_aeval_pluckerQuadric_compound_le [IsDomain R] [Infinite R]
    (h2 : (2 : R) ≠ 0) (A : Matrix (Fin 6) (Fin 6) R) :
    Ideal.span (Set.range (fun t : Fin 15 ↦
      (MvPolynomial.aeval
        (BConicBundleMultisections.linearSubst 14
          (V14Formalization.PluckerNaturality.compound2Lex A)) : _ →ₐ[R] _)
        (V14Formalization.SchemeGeometry.pluckerQuadric R t))) ≤
      Ideal.span (Set.range
        (V14Formalization.SchemeGeometry.pluckerQuadric R)) := by
  rw [Ideal.span_le]
  rintro _ ⟨t, rfl⟩
  change (MvPolynomial.aeval
      (BConicBundleMultisections.linearSubst 14
        (V14Formalization.PluckerNaturality.compound2Lex A)) : _ →ₐ[R] _)
      (V14Formalization.SchemeGeometry.pluckerQuadric R t) ∈ _
  rw [aeval_pluckerQuadric_compound_transform h2 A t]
  apply Ideal.sum_mem
  intro s _
  apply Ideal.mul_mem_left
  exact Ideal.subset_span ⟨s, rfl⟩

end PluckerNaturality
end V14Formalization
