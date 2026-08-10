import V14Formalization.GeometricV14Carrier
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.Algebra.Polynomial.SpecificDegree
import Mathlib.FieldTheory.Minpoly.Field
import Mathlib.RingTheory.Trace.Basic
import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.RingTheory.AlgebraTower
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.RingTheory.Ideal.Quotient.Defs

open Polynomial Module LinearMap AdjoinRoot Matrix
open V14Formalization.GeometricV14Carrier

set_option maxHeartbeats 16000000
noncomputable section

theorem irr_X_sq_add_one : Irreducible ((X : k[X]) ^ 2 + C (1 : k)) := by
  have heq : (X : k[X]) ^ 2 + C 1 = X ^ 2 - C (-1 : k) := by
    ext n; simp [sub_eq_add_neg]
  rw [heq]
  exact (X_pow_sub_C_irreducible_iff_of_prime (by decide : Nat.Prime 2)
      (a := (-1 : k))).2 fun b hb =>
    not_isSquare_neg_one ⟨b, by simpa [pow_two] using hb.symm⟩

instance fact_irr_X2p1 : Fact (Irreducible ((X : k[X]) ^ 2 + C (1 : k))) :=
  ⟨irr_X_sq_add_one⟩

abbrev L := AdjoinRoot ((X : k[X]) ^ 2 + C (1 : k))
def iRoot : L := root ((X : k[X]) ^ 2 + C (1 : k))

theorem aeval_iRoot : aeval iRoot ((X : k[X]) ^ 2 + C (1 : k)) = 0 :=
  (aeval_eq (f := (X : k[X]) ^ 2 + C 1) (p := (X : k[X]) ^ 2 + C 1)).trans
    (mk_self (f := (X : k[X]) ^ 2 + C 1))

theorem monic_X2p1 : ((X : k[X]) ^ 2 + C (1 : k)).Monic :=
  monic_X_pow_add_C (1 : k) (by decide : (2 : ℕ) ≠ 0)

theorem minpoly_iRoot : minpoly k iRoot = (X : k[X]) ^ 2 + C 1 :=
  (minpoly.eq_of_irreducible_of_monic irr_X_sq_add_one aeval_iRoot monic_X2p1).symm

theorem nextCoeff_X2p1 : nextCoeff ((X : k[X]) ^ 2 + C (1 : k)) = 0 := by
  have hdeg : natDegree ((X : k[X]) ^ 2 + C 1) = 2 := natDegree_X_pow_add_C
  unfold nextCoeff
  rw [hdeg]
  simp only [OfNat.ofNat_ne_zero, ite_false]
  change ((X : k[X]) ^ 2 + C (1 : k)).coeff 1 = 0
  rw [coeff_add, coeff_X_pow, if_neg (by decide : (1 : ℕ) ≠ 2)]
  rw [coeff_C, if_neg (by decide : (1 : ℕ) ≠ 0)]
  simp

theorem algebra_trace_iRoot : Algebra.trace k L iRoot = 0 := by
  let hpb := powerBasis (K := k) (f := (X : k[X]) ^ 2 + C (1 : k))
    irr_X_sq_add_one.ne_zero
  have hgen : hpb.gen = iRoot := rfl
  have htr := PowerBasis.trace_gen_eq_nextCoeff_minpoly hpb
  calc Algebra.trace k L iRoot
      = Algebra.trace k L hpb.gen := by rw [hgen]
    _ = - (minpoly k hpb.gen).nextCoeff := htr
    _ = - (minpoly k iRoot).nextCoeff := by rw [hgen]
    _ = - nextCoeff ((X : k[X]) ^ 2 + C 1) := by rw [minpoly_iRoot]
    _ = 0 := by rw [nextCoeff_X2p1, neg_zero]

#print axioms algebra_trace_iRoot

/-! ## RingHom L → End via Ideal.Quotient.lift + eval₂RingHom' (End not CommRing) -/

theorem algebraMap_end_commute (r : k) :
    Commute (algebraMap k (Module.End k U) r) (Jlin : Module.End k U) := by
  rw [commute_iff_eq]
  ext u
  simp only [Algebra.algebraMap_eq_smul_one, Module.End.mul_eq_comp,
    LinearMap.comp_apply, LinearMap.smul_apply, Module.End.one_eq_id,
    LinearMap.id_apply, map_smul]

noncomputable def eval₂Jlin : k[X] →+* Module.End k U :=
  eval₂RingHom' (algebraMap k (Module.End k U)) Jlin algebraMap_end_commute

theorem eval₂Jlin_X2p1 : eval₂Jlin ((X : k[X]) ^ 2 + C 1) = 0 := by
  change eval₂ (algebraMap k (Module.End k U)) Jlin ((X : k[X]) ^ 2 + C 1) = 0
  have h : eval₂ (algebraMap k (Module.End k U)) Jlin ((X : k[X]) ^ 2 + C 1) =
      (Jlin : Module.End k U) ^ 2 + algebraMap k (Module.End k U) 1 := by
    simp only [eval₂_add, eval₂_X_pow, eval₂_C]
  rw [h, map_one]
  have hpow : (Jlin : Module.End k U) ^ 2 = -1 := by
    rw [pow_two, Module.End.mul_eq_comp, Jlin_sq]
    ext x; simp [Module.End.one_eq_id]
  rw [hpow]
  ext x; simp [Module.End.one_eq_id]

theorem eval₂Jlin_span_eq_zero :
    ∀ g : k[X], g ∈ Ideal.span {((X : k[X]) ^ 2 + C (1 : k))} → eval₂Jlin g = 0 := by
  intro g hg
  obtain ⟨h, rfl⟩ := Ideal.mem_span_singleton.mp hg
  rw [map_mul, eval₂Jlin_X2p1, zero_mul]

/-- The polynomial ideal for L = k[X]/(X²+1). -/
abbrev Ipoly : Ideal k[X] := Ideal.span {((X : k[X]) ^ 2 + C (1 : k))}

/-- RingHom on the raw quotient (defeq to L). -/
noncomputable def LtoEndQuot : (k[X] ⧸ Ipoly) →+* Module.End k U :=
  Ideal.Quotient.lift Ipoly eval₂Jlin eval₂Jlin_span_eq_zero

/-- RingHom L →+* End_k(U) sending root ↦ Jlin.
`L` is defeq to `k[X] ⧸ Ipoly`. -/
noncomputable def LtoEnd : L →+* Module.End k U := LtoEndQuot

theorem LtoEnd_root : LtoEnd iRoot = Jlin := by
  -- iRoot = mk X
  show LtoEndQuot (Ideal.Quotient.mk Ipoly X) = Jlin
  rw [LtoEndQuot, Ideal.Quotient.lift_mk]
  exact eval₂_X (algebraMap k (Module.End k U)) Jlin

theorem LtoEnd_of (r : k) :
    LtoEnd (algebraMap k L r) = algebraMap k (Module.End k U) r := by
  -- algebraMap r = of r = mk (C r)
  show LtoEndQuot (Ideal.Quotient.mk Ipoly (C r)) = algebraMap k (Module.End k U) r
  rw [LtoEndQuot, Ideal.Quotient.lift_mk]
  change eval₂ (algebraMap k (Module.End k U)) Jlin (C r) =
    algebraMap k (Module.End k U) r
  rw [eval₂_C]
#print axioms LtoEnd_root

/-! ## Module L U -/

instance moduleL_U : Module L U := Module.compHom U LtoEnd

instance isScalarTower_kLU : IsScalarTower k L U where
  smul_assoc r l u := by
    -- (r • l) • u = r • (l • u)
    -- Module.compHom: α • u means LtoEnd α u
    have hdef : (r • l : L) = algebraMap k L r * l := Algebra.smul_def r l
    -- Unfold both sides of smul from Module.compHom
    show LtoEnd (r • l) u = r • (LtoEnd l u)
    rw [hdef, map_mul, LtoEnd_of]
    show (algebraMap k (Module.End k U) r * LtoEnd l) u = r • LtoEnd l u
    rw [Algebra.algebraMap_eq_smul_one, Module.End.mul_eq_comp]
    simp only [LinearMap.comp_apply, LinearMap.smul_apply, Module.End.one_eq_id,
      LinearMap.id_apply]

theorem finrank_L : Module.finrank k L = 2 := by
  let hpb := powerBasis (K := k) (f := (X : k[X]) ^ 2 + C 1) irr_X_sq_add_one.ne_zero
  have h : Module.finrank k (AdjoinRoot ((X : k[X]) ^ 2 + C 1)) = hpb.dim := hpb.finrank
  have hdim : hpb.dim = 2 := by
    change ((X : k[X]) ^ 2 + C 1).natDegree = 2
    exact natDegree_X_pow_add_C
  exact h.trans hdim

instance instFreeL : Module.Free k L := Module.Free.of_basis
  (powerBasis (K := k) (f := (X : k[X]) ^ 2 + C 1) irr_X_sq_add_one.ne_zero).basis

instance instFiniteL : Module.Finite k L := Module.Finite.of_basis
  (powerBasis (K := k) (f := (X : k[X]) ^ 2 + C 1) irr_X_sq_add_one.ne_zero).basis

instance instFreeLU : Module.Free L U := Module.Free.of_divisionRing L U

theorem finrank_L_U : Module.finrank L U = 3 := by
  -- Tower law needs only Free (not Finite)
  have hmul : Module.finrank k L * Module.finrank L U = Module.finrank k U :=
    Module.finrank_mul_finrank k L U
  have hU : Module.finrank k U = 6 := V14Formalization.GeometricFanoCarrier.finrank_U
  have hL : Module.finrank k L = 2 := finrank_L
  have h : 2 * Module.finrank L U = 6 := by
    calc 2 * Module.finrank L U
        = Module.finrank k L * Module.finrank L U := by rw [hL]
      _ = Module.finrank k U := hmul
      _ = 6 := hU
  exact Nat.eq_of_mul_eq_mul_left (by decide : 0 < 2) h

instance instFiniteLU : Module.Finite L U :=
  Module.finite_of_finrank_eq_succ (n := 2) (by rw [finrank_L_U])

/-! ## tr(J) = 0

Power basis {1, i} of L/k and any L-basis of U give a k-basis of U on which
the matrix of J is block-diagonal with 2×2 blocks [[0,-1],[1,0]], each of
trace 0.
-/

theorem iRoot_smul_eq_Jlin (u : U) : iRoot • u = Jlin u := by
  change LtoEnd iRoot u = Jlin u
  rw [LtoEnd_root]

theorem iRoot_mul_self : iRoot * iRoot = (-1 : L) := by
  have h0 : iRoot ^ 2 + (1 : L) = 0 := by
    simpa [map_add, map_pow, map_one, aeval_X] using aeval_iRoot
  have : iRoot ^ 2 = -1 := eq_neg_of_add_eq_zero_left h0
  rwa [pow_two] at this

/-- Power basis of L = k[i] over k. -/
noncomputable def pbL : PowerBasis k L :=
  powerBasis (K := k) (f := (X : k[X]) ^ 2 + C 1) irr_X_sq_add_one.ne_zero

theorem pbL_gen : pbL.gen = iRoot := rfl

theorem pbL_dim : pbL.dim = 2 := by
  change ((X : k[X]) ^ 2 + C 1).natDegree = 2
  exact natDegree_X_pow_add_C

/-- Reindexed power basis of L on `Fin 2`. -/
noncomputable def bL2 : Basis (Fin 2) k L :=
  pbL.basis.reindex (finCongr pbL_dim)

theorem bL2_zero : bL2 0 = (1 : L) := by
  simp only [bL2, Basis.reindex_apply]
  have heq : (finCongr pbL_dim).symm (0 : Fin 2) =
      ⟨0, by rw [pbL_dim]; decide⟩ := Fin.ext (by simp)
  rw [heq, pbL.basis_eq_pow, pow_zero]

theorem bL2_one : bL2 1 = iRoot := by
  simp only [bL2, Basis.reindex_apply]
  have heq : (finCongr pbL_dim).symm (1 : Fin 2) =
      ⟨1, by rw [pbL_dim]; decide⟩ := Fin.ext (by simp)
  rw [heq, pbL.basis_eq_pow, pbL_gen, pow_one]

theorem bL2_eq_zero (h : (0 : ℕ) < 2) : bL2 ⟨0, h⟩ = (1 : L) := by
  convert bL2_zero <;> rfl

theorem bL2_eq_one (h : (1 : ℕ) < 2) : bL2 ⟨1, h⟩ = iRoot := by
  convert bL2_one <;> rfl

/-- Trace of Jlin is 0. -/
theorem Jlin_trace : LinearMap.trace k U Jlin = 0 := by
  classical
  haveI : Module.Free L U := instFreeLU
  haveI : Module.Finite L U := instFiniteLU
  haveI : Module.Free k L := instFreeL
  haveI : Module.Finite k L := instFiniteL
  haveI : Module.Free k U := inferInstance
  haveI : Module.Finite k U := inferInstance
  let bU := Module.Free.chooseBasis L U
  let b := bL2.smulTower bU
  have htr : LinearMap.trace k U Jlin = (LinearMap.toMatrix b b Jlin).trace :=
    LinearMap.trace_eq_matrix_trace k b Jlin
  rw [htr, Matrix.trace]
  simp_rw [Matrix.diag_apply, LinearMap.toMatrix_apply]
  -- Goal: ∑ ij, b.repr (Jlin (b ij)) ij = 0
  refine Finset.sum_eq_zero fun ij _ => ?_
  obtain ⟨i, x⟩ := ij
  have happly : b (i, x) = bL2 i • (bU x : U) := Basis.smulTower_apply bL2 bU (i, x)
  have hJ : Jlin (b (i, x)) = (iRoot * bL2 i) • (bU x : U) := by
    rw [happly, ← iRoot_smul_eq_Jlin, smul_smul]
  match i with
  | ⟨0, hi0⟩ =>
    rw [hJ, bL2_eq_zero hi0, mul_one]
    have hbx : iRoot • (bU x : U) = b ((1 : Fin 2), x) := by
      rw [Basis.smulTower_apply bL2 bU ((1 : Fin 2), x), bL2_one]
    rw [hbx, Basis.repr_self]
    exact Finsupp.single_eq_of_ne (fun h => by cases h)
  | ⟨1, hi1⟩ =>
    rw [hJ, bL2_eq_one hi1, iRoot_mul_self]
    have hbx : ((-1 : L) • (bU x : U)) = -b ((0 : Fin 2), x) := by
      rw [neg_one_smul, Basis.smulTower_apply bL2 bU ((0 : Fin 2), x), bL2_zero, one_smul]
    rw [hbx, map_neg, Basis.repr_self]
    have hne : ((0 : Fin 2), x) ≠ ((1 : Fin 2), x) := fun h => by cases h
    simpa using Finsupp.single_eq_of_ne (a := ((0 : Fin 2), x)) (b := ((1 : Fin 2), x))
      (v := (1 : k)) hne
  | ⟨n+2, hn⟩ =>
    omega

#print axioms algebra_trace_iRoot
#print axioms LtoEnd_root
#print axioms LtoEnd_of
#print axioms finrank_L
#print axioms finrank_L_U
#print axioms Jlin_trace
