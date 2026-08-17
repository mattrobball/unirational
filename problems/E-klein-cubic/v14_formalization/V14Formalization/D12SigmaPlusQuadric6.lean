/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12MatrixCertificate

/-!
# Degree-two monomials in six variables

Upper-triangular lex order matches the plus Segre exporter.
-/

noncomputable section

open Matrix
open scoped BigOperators

namespace V14Formalization.D12SigmaPlusQuadric6

universe u
variable {R : Type u} [CommRing R]

/-- Pairs `i ≤ j` in `Fin 6`, as a `Fin 21`. -/
@[expose] public def monomPair (k : Fin 21) : Fin 6 × Fin 6 :=
  match k.val with
  | 0 => (0, 0)
  | 1 => (0, 1)
  | 2 => (0, 2)
  | 3 => (0, 3)
  | 4 => (0, 4)
  | 5 => (0, 5)
  | 6 => (1, 1)
  | 7 => (1, 2)
  | 8 => (1, 3)
  | 9 => (1, 4)
  | 10 => (1, 5)
  | 11 => (2, 2)
  | 12 => (2, 3)
  | 13 => (2, 4)
  | 14 => (2, 5)
  | 15 => (3, 3)
  | 16 => (3, 4)
  | 17 => (3, 5)
  | 18 => (4, 4)
  | 19 => (4, 5)
  | 20 => (5, 5)
  | _ => (0, 0)

@[expose] public def quadMonomials (y : Fin 6 → R) : Fin 21 → R :=
  fun k =>
    let p := monomPair k
    y p.1 * y p.2

@[expose] public def quadValue (Q : Fin 21 → R) (y : Fin 6 → R) : R :=
  dotProduct Q (quadMonomials y)

@[expose] public def bilinearCoeffs (a b : Fin 6 → R) : Fin 21 → R :=
  fun k =>
    let p := monomPair k
    if p.1 = p.2 then a p.1 * b p.1 else a p.1 * b p.2 + a p.2 * b p.1

theorem quadValue_add (Q₁ Q₂ : Fin 21 → R) (y : Fin 6 → R) :
    quadValue (Q₁ + Q₂) y = quadValue Q₁ y + quadValue Q₂ y := by
  simp [quadValue, dotProduct, Pi.add_apply, add_mul, Finset.sum_add_distrib]

public theorem quadValue_sub (Q₁ Q₂ : Fin 21 → R) (y : Fin 6 → R) :
    quadValue (Q₁ - Q₂) y = quadValue Q₁ y - quadValue Q₂ y := by
  simp [quadValue, dotProduct, Pi.sub_apply, sub_mul, Finset.sum_sub_distrib]

theorem quadValue_smul (c : R) (Q : Fin 21 → R) (y : Fin 6 → R) :
    quadValue (c • Q) y = c * quadValue Q y := by
  simp [quadValue, dotProduct, Pi.smul_apply, smul_eq_mul, mul_assoc,
    Finset.mul_sum]

public theorem quadValue_bilinearCoeffs (a b y : Fin 6 → R) :
    quadValue (bilinearCoeffs a b) y = dotProduct a y * dotProduct b y := by
  simp [quadValue, bilinearCoeffs, quadMonomials, monomPair, dotProduct,
    Fin.sum_univ_succ]
  ring

@[expose] public def restrictedPluckerCoeffs
    (B : Matrix (Fin 15) (Fin 6) R) (q : Fin 15) : Fin 21 → R :=
  let d := SchemeGeometry.pluckerRelation q
  bilinearCoeffs (B d.p1) (B d.p2) -
    bilinearCoeffs (B d.p3) (B d.p4) +
      bilinearCoeffs (B d.p5) (B d.p6)

public theorem bilinearCoeffs_map {S : Type*} [CommRing S] (f : R →+* S)
    (a b : Fin 6 → R) (m : Fin 21) :
    bilinearCoeffs (fun j => f (a j)) (fun j => f (b j)) m =
      f (bilinearCoeffs a b m) := by
  dsimp [bilinearCoeffs]
  split_ifs <;> simp [map_mul, map_add]

public theorem restrictedPluckerCoeffs_map {S : Type*} [CommRing S] (f : R →+* S)
    (B : Matrix (Fin 15) (Fin 6) R) (q : Fin 15) :
    restrictedPluckerCoeffs (B.map f) q =
      fun m ↦ f (restrictedPluckerCoeffs B q m) := by
  funext m
  dsimp [restrictedPluckerCoeffs]
  have hrow (i : Fin 15) : B.map f i = fun j => f (B i j) := rfl
  simp only [hrow, bilinearCoeffs_map, map_add, map_sub]

public theorem quadValue_restrictedPluckerCoeffs
    {S : Type*} [Field S] (B : Matrix (Fin 15) (Fin 6) S)
    (q : Fin 15) (y : Fin 6 → S) :
    quadValue (restrictedPluckerCoeffs B q) y =
      D12Certificate.pluckerValue (B.mulVec y) q := by
  simp only [restrictedPluckerCoeffs, quadValue_add, quadValue_sub,
    quadValue_bilinearCoeffs, D12Certificate.pluckerValue]
  simp [Matrix.mulVec, dotProduct]

theorem quadValue_sum {ι : Type*} [Fintype ι]
    (Q : ι → Fin 21 → R) (y : Fin 6 → R) :
    quadValue (∑ i, Q i) y = ∑ i, quadValue (Q i) y := by
  simp only [quadValue, dotProduct]
  simp_rw [Finset.sum_apply, Finset.sum_mul]
  rw [Finset.sum_comm]

public theorem quadValue_linear {ι : Type*} [Fintype ι]
    (c : ι → R) (Q : ι → Fin 21 → R) (y : Fin 6 → R) :
    quadValue (∑ i, c i • Q i) y = ∑ i, c i * quadValue (Q i) y := by
  rw [quadValue_sum]
  exact Finset.sum_congr rfl fun i _ => quadValue_smul (c i) (Q i) y

/-- Reshape nine coordinates as a `3 × 3` matrix, row-major. -/
@[expose] public def reshape3 (z : Fin 9 → R) : Matrix (Fin 3) (Fin 3) R :=
  fun a b => z ⟨3 * a.val + b.val, by
    have ha := a.isLt
    have hb := b.isLt
    omega⟩

@[expose] public def minorOrder (s : Fin 9) : Fin 3 × Fin 3 × Fin 3 × Fin 3 :=
  match s.val with
  | 0 => (0, 1, 0, 1)
  | 1 => (0, 1, 0, 2)
  | 2 => (0, 1, 1, 2)
  | 3 => (0, 2, 0, 1)
  | 4 => (0, 2, 0, 2)
  | 5 => (0, 2, 1, 2)
  | 6 => (1, 2, 0, 1)
  | 7 => (1, 2, 0, 2)
  | 8 => (1, 2, 1, 2)
  | _ => (0, 1, 0, 1)

/-- Minor `M a0 b0 * M a1 b1 - M a0 b1 * M a1 b0` for `minorOrder s = (a0,a1,b0,b1)`. -/
@[expose] public def reshapeMinor (z : Fin 9 → R) (s : Fin 9) : R :=
  let p := minorOrder s
  reshape3 z p.1 p.2.2.1 * reshape3 z p.2.1 p.2.2.2 -
    reshape3 z p.1 p.2.2.2 * reshape3 z p.2.1 p.2.2.1

@[expose] public def crossIndex (a b : Fin 3) : Fin 9 :=
  ⟨3 * a.val + b.val, by
    have ha := a.isLt
    have hb := b.isLt
    omega⟩

public theorem reshape3_apply (z : Fin 9 → R) (a b : Fin 3) :
    reshape3 z a b = z (crossIndex a b) := rfl

@[simp] public theorem monomPair_0 : monomPair (0 : Fin 21) = (0, 0) := rfl
@[simp] public theorem monomPair_1 : monomPair (1 : Fin 21) = (0, 1) := rfl
@[simp] public theorem monomPair_2 : monomPair (2 : Fin 21) = (0, 2) := rfl
@[simp] public theorem monomPair_3 : monomPair (3 : Fin 21) = (0, 3) := rfl
@[simp] public theorem monomPair_4 : monomPair (4 : Fin 21) = (0, 4) := rfl
@[simp] public theorem monomPair_5 : monomPair (5 : Fin 21) = (0, 5) := rfl
@[simp] public theorem monomPair_6 : monomPair (6 : Fin 21) = (1, 1) := rfl
@[simp] public theorem monomPair_7 : monomPair (7 : Fin 21) = (1, 2) := rfl
@[simp] public theorem monomPair_8 : monomPair (8 : Fin 21) = (1, 3) := rfl
@[simp] public theorem monomPair_9 : monomPair (9 : Fin 21) = (1, 4) := rfl
@[simp] public theorem monomPair_10 : monomPair (10 : Fin 21) = (1, 5) := rfl
@[simp] public theorem monomPair_11 : monomPair (11 : Fin 21) = (2, 2) := rfl
@[simp] public theorem monomPair_12 : monomPair (12 : Fin 21) = (2, 3) := rfl
@[simp] public theorem monomPair_13 : monomPair (13 : Fin 21) = (2, 4) := rfl
@[simp] public theorem monomPair_14 : monomPair (14 : Fin 21) = (2, 5) := rfl
@[simp] public theorem monomPair_15 : monomPair (15 : Fin 21) = (3, 3) := rfl
@[simp] public theorem monomPair_16 : monomPair (16 : Fin 21) = (3, 4) := rfl
@[simp] public theorem monomPair_17 : monomPair (17 : Fin 21) = (3, 5) := rfl
@[simp] public theorem monomPair_18 : monomPair (18 : Fin 21) = (4, 4) := rfl
@[simp] public theorem monomPair_19 : monomPair (19 : Fin 21) = (4, 5) := rfl
@[simp] public theorem monomPair_20 : monomPair (20 : Fin 21) = (5, 5) := rfl

@[simp] public theorem minorOrder_0 : minorOrder (0 : Fin 9) = (0, 1, 0, 1) := rfl
@[simp] public theorem minorOrder_1 : minorOrder (1 : Fin 9) = (0, 1, 0, 2) := rfl
@[simp] public theorem minorOrder_2 : minorOrder (2 : Fin 9) = (0, 1, 1, 2) := rfl
@[simp] public theorem minorOrder_3 : minorOrder (3 : Fin 9) = (0, 2, 0, 1) := rfl
@[simp] public theorem minorOrder_4 : minorOrder (4 : Fin 9) = (0, 2, 0, 2) := rfl
@[simp] public theorem minorOrder_5 : minorOrder (5 : Fin 9) = (0, 2, 1, 2) := rfl
@[simp] public theorem minorOrder_6 : minorOrder (6 : Fin 9) = (1, 2, 0, 1) := rfl
@[simp] public theorem minorOrder_7 : minorOrder (7 : Fin 9) = (1, 2, 0, 2) := rfl
@[simp] public theorem minorOrder_8 : minorOrder (8 : Fin 9) = (1, 2, 1, 2) := rfl

@[simp] public theorem crossIndex_01 : crossIndex 0 1 = 1 := rfl
@[simp] public theorem crossIndex_02 : crossIndex 0 2 = 2 := rfl
@[simp] public theorem crossIndex_10 : crossIndex 1 0 = 3 := rfl
@[simp] public theorem crossIndex_11 : crossIndex 1 1 = 4 := rfl
@[simp] public theorem crossIndex_12 : crossIndex 1 2 = 5 := rfl
@[simp] public theorem crossIndex_20 : crossIndex 2 0 = 6 := rfl
@[simp] public theorem crossIndex_21 : crossIndex 2 1 = 7 := rfl
@[simp] public theorem crossIndex_22 : crossIndex 2 2 = 8 := rfl

@[simp] public theorem pluckerRelation_0 :
    SchemeGeometry.pluckerRelation (0 : Fin 15) = ⟨0, 9, 1, 6, 2, 5⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_1 :
    SchemeGeometry.pluckerRelation (1 : Fin 15) = ⟨0, 10, 1, 7, 3, 5⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_2 :
    SchemeGeometry.pluckerRelation (2 : Fin 15) = ⟨0, 11, 1, 8, 4, 5⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_3 :
    SchemeGeometry.pluckerRelation (3 : Fin 15) = ⟨0, 12, 2, 7, 3, 6⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_4 :
    SchemeGeometry.pluckerRelation (4 : Fin 15) = ⟨0, 13, 2, 8, 4, 6⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_5 :
    SchemeGeometry.pluckerRelation (5 : Fin 15) = ⟨0, 14, 3, 8, 4, 7⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_6 :
    SchemeGeometry.pluckerRelation (6 : Fin 15) = ⟨1, 12, 2, 10, 3, 9⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_7 :
    SchemeGeometry.pluckerRelation (7 : Fin 15) = ⟨1, 13, 2, 11, 4, 9⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_8 :
    SchemeGeometry.pluckerRelation (8 : Fin 15) = ⟨1, 14, 3, 11, 4, 10⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_9 :
    SchemeGeometry.pluckerRelation (9 : Fin 15) = ⟨2, 14, 3, 13, 4, 12⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_10 :
    SchemeGeometry.pluckerRelation (10 : Fin 15) = ⟨5, 12, 6, 10, 7, 9⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_11 :
    SchemeGeometry.pluckerRelation (11 : Fin 15) = ⟨5, 13, 6, 11, 8, 9⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_12 :
    SchemeGeometry.pluckerRelation (12 : Fin 15) = ⟨5, 14, 7, 11, 8, 10⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_13 :
    SchemeGeometry.pluckerRelation (13 : Fin 15) = ⟨6, 14, 7, 13, 8, 12⟩ := by
  simp [SchemeGeometry.pluckerRelation]
@[simp] public theorem pluckerRelation_14 :
    SchemeGeometry.pluckerRelation (14 : Fin 15) = ⟨9, 14, 10, 13, 11, 12⟩ := by
  simp [SchemeGeometry.pluckerRelation]

end V14Formalization.D12SigmaPlusQuadric6
