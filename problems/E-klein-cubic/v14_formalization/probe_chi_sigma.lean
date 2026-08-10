import V14Formalization.GeometricV14Carrier
import Mathlib.LinearAlgebra.ExteriorPower.Basis
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.LinearAlgebra.Charpoly.ToMatrix
import Mathlib.Data.Set.PowersetCard
import Mathlib.Order.Hom.PowersetCard
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Finset.Card
import Mathlib.Data.Finset.Sort

open Polynomial Module LinearMap Matrix exteriorPower BigOperators Set
open V14Formalization.GeometricV14Carrier

set_option maxHeartbeats 32000000
noncomputable section

/-! ## Target: chiLambda2_sigma = 3 via Newton exterior identity -/

theorem ambientAct_sigma_eq_map_Jlin :
    ambientAct sigma = exteriorPower.map 2 Jlin := by
  rw [ambientAct_sigma]; rfl

theorem Jlin_comp_trace : LinearMap.trace k U (Jlin ∘ₗ Jlin) = (-6 : k) := by
  rw [Jlin_sq]
  have hneg := map_neg (LinearMap.trace k U) (LinearMap.id : Module.End k U)
  rw [hneg, LinearMap.trace_id, V14Formalization.GeometricFanoCarrier.finrank_U]
  norm_num

theorem matrix_trace_sq_sub_sq {ι : Type*} [Fintype ι] [DecidableEq ι]
    (A : Matrix ι ι k) :
    (A.trace) ^ 2 - (A * A).trace =
      ∑ i : ι, ∑ j : ι,
        if i = j then (0 : k) else (A i i * A j j - A i j * A j i) := by
  have htr2 : (A.trace) ^ 2 = ∑ i : ι, ∑ j : ι, A i i * A j j := by
    simp only [Matrix.trace, pow_two]; exact Finset.sum_mul_sum _ _ _ _
  have hA2 : (A * A).trace = ∑ i : ι, ∑ j : ι, A i j * A j i := by
    simp only [Matrix.trace]
    refine Finset.sum_congr rfl fun i _ => ?_
    change (A * A) i i = ∑ j, A i j * A j i; rw [Matrix.mul_apply]
  rw [htr2, hA2]; simp only [← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
  split_ifs with h <;> [simp [h]; ring]

theorem matrix_sum_off_diag_symm {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]
    (f : ι → ι → k) (hf : ∀ i j, f i j = f j i) :
    (∑ i : ι, ∑ j : ι, if i = j then (0 : k) else f i j) =
      (2 : k) * ∑ i : ι, ∑ j : ι, if i < j then f i j else (0 : k) := by
  have hpt (i j : ι) :
      (if i = j then (0 : k) else f i j) =
        (if i < j then f i j else (0 : k)) +
        (if j < i then f i j else (0 : k)) := by
    rcases lt_trichotomy i j with h | rfl | h
    · rw [if_neg (ne_of_lt h), if_pos h, if_neg (lt_asymm h), add_zero]
    · simp only [lt_irrefl, ↓reduceIte, add_zero]
    · rw [if_neg (ne_of_gt h), if_neg (lt_asymm h), if_pos h, zero_add]
  rw [Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => hpt i j]
  simp only [Finset.sum_add_distrib]
  have hswap :
      (∑ i : ι, ∑ j : ι, if j < i then f i j else (0 : k)) =
        (∑ i : ι, ∑ j : ι, if i < j then f i j else (0 : k)) := by
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
    by_cases h : i < j <;> simp [h, hf]
  rw [hswap, two_mul]

theorem exterior_repr_map_eq_det
    {ι : Type*} [LinearOrder ι] [Fintype ι] [DecidableEq ι]
    {V : Type*} [AddCommGroup V] [Module k V]
    (b : Basis ι k V) (f : Module.End k V)
    (s : powersetCard ι 2) :
    (b.exteriorPower (n := 2)).repr
        (exteriorPower.map 2 f (b.exteriorPower (n := 2) s)) s =
      ((LinearMap.toMatrix b b f).submatrix
        (powersetCard.ofFinEmbEquiv.symm s)
        (powersetCard.ofFinEmbEquiv.symm s)).det := by
  set B := b.exteriorPower (n := 2)
  set emb := powersetCard.ofFinEmbEquiv.symm s
  have hBs : B s = ιMulti_family k 2 (b : ι → V) s := by
    simp only [B]; exact exteriorPower.basis_apply (R := k) (n := 2) b s
  rw [hBs, exteriorPower.basis_repr_apply (R := k) (n := 2) b]
  have hmap :
      exteriorPower.map 2 f (ιMulti_family k 2 (b : ι → V) s) =
        exteriorPower.ιMulti k 2 (fun i : Fin 2 => f (b (emb i))) := by
    dsimp [ιMulti_family, emb]; rw [exteriorPower.map_apply_ιMulti]; rfl
  rw [hmap, exteriorPower.ιMultiDual_apply_ιMulti (R := k) (n := 2) b s]
  have hT :
      (Matrix.of fun i j : Fin 2 => b.coord (emb j) (f (b (emb i)))) =
        ((LinearMap.toMatrix b b f).submatrix emb emb)ᵀ := by
    ext i j
    simp [Matrix.transpose_apply, Matrix.of_apply, Matrix.submatrix_apply,
      LinearMap.toMatrix_apply, Basis.coord_apply]
  rw [hT, Matrix.det_transpose]

/-- det of 2×2 submatrix on ordered emb equals M_ii M_jj - M_ij M_ji. -/
theorem det_submatrix_emb {ι : Type*} [DecidableEq ι]
    (M : Matrix ι ι k) (emb : Fin 2 → ι) :
    (M.submatrix emb emb).det =
      M (emb 0) (emb 0) * M (emb 1) (emb 1) -
        M (emb 0) (emb 1) * M (emb 1) (emb 0) := by
  rw [Matrix.det_fin_two]
  simp [Matrix.submatrix_apply]

/-- Newton for exterior square. -/
theorem trace_exterior_newton
    {V : Type*} [AddCommGroup V] [Module k V]
    [Module.Free k V] [Module.Finite k V]
    (f : Module.End k V) :
    LinearMap.trace k (⋀[k]^2 V) (exteriorPower.map 2 f) =
      (2 : k)⁻¹ * ((LinearMap.trace k V f) ^ 2 -
        LinearMap.trace k V (f ∘ₗ f)) := by
  classical
  let b0 := Module.Free.chooseBasis k V
  let n := Fintype.card (Module.Free.ChooseBasisIndex k V)
  let equivIdx : Module.Free.ChooseBasisIndex k V ≃ Fin n :=
    Fintype.equivFinOfCardEq rfl
  let b : Basis (Fin n) k V := b0.reindex equivIdx
  let B := b.exteriorPower (n := 2)
  let M := LinearMap.toMatrix b b f
  -- tr via exterior basis
  have htrB :
      LinearMap.trace k (⋀[k]^2 V) (exteriorPower.map 2 f) =
        ∑ s : powersetCard (Fin n) 2,
          B.repr (exteriorPower.map 2 f (B s)) s := by
    rw [LinearMap.trace_eq_matrix_trace k B (exteriorPower.map 2 f)]
    simp only [Matrix.trace, Matrix.diag_apply, LinearMap.toMatrix_apply]
  -- Each = det of principal submatrix
  have hdet (s : powersetCard (Fin n) 2) :
      B.repr (exteriorPower.map 2 f (B s)) s =
        M ((powersetCard.ofFinEmbEquiv.symm s) 0)
            ((powersetCard.ofFinEmbEquiv.symm s) 0) *
          M ((powersetCard.ofFinEmbEquiv.symm s) 1)
            ((powersetCard.ofFinEmbEquiv.symm s) 1) -
        M ((powersetCard.ofFinEmbEquiv.symm s) 0)
            ((powersetCard.ofFinEmbEquiv.symm s) 1) *
          M ((powersetCard.ofFinEmbEquiv.symm s) 1)
            ((powersetCard.ofFinEmbEquiv.symm s) 0) := by
    have h := exterior_repr_map_eq_det b f s
    dsimp [M, B] at *
    rw [h, det_submatrix_emb]
  rw [htrB]; simp_rw [hdet]
  -- Det function on pairs
  let detPair (i j : Fin n) : k := M i i * M j j - M i j * M j i
  -- Sum over powersetCard = sum over order embeddings
  have heq :
      (∑ s : powersetCard (Fin n) 2,
        detPair ((powersetCard.ofFinEmbEquiv.symm s) 0)
          ((powersetCard.ofFinEmbEquiv.symm s) 1)) =
      ∑ e : Fin 2 ↪o Fin n, detPair (e 0) (e 1) :=
    Fintype.sum_equiv
      (powersetCard.ofFinEmbEquiv (I := Fin n) (n := 2)).symm
      (fun s => detPair ((powersetCard.ofFinEmbEquiv.symm s) 0)
        ((powersetCard.ofFinEmbEquiv.symm s) 1))
      (fun e => detPair (e 0) (e 1))
      (fun _ => rfl)
  -- Sum over embeddings = sum over i < j
  have hpairs :
      (∑ e : Fin 2 ↪o Fin n, detPair (e 0) (e 1)) =
      ∑ i : Fin n, ∑ j : Fin n, if i < j then detPair i j else (0 : k) := by
    classical
    let S : Finset (Fin n × Fin n) :=
      (Finset.univ ×ˢ Finset.univ).filter (fun p => p.1 < p.2)
    have hrhs :
        (∑ i : Fin n, ∑ j : Fin n, if i < j then detPair i j else (0 : k)) =
          ∑ p ∈ S, detPair p.1 p.2 := by
      -- ∑_p∈S f = ∑_p if p.1<p.2 then f else 0, then unfold product
      calc (∑ i : Fin n, ∑ j : Fin n, if i < j then detPair i j else (0 : k))
          = ∑ p : Fin n × Fin n,
              if p.1 < p.2 then detPair p.1 p.2 else (0 : k) := by
            rw [← Finset.univ_product_univ, Finset.sum_product]
          _ = ∑ p ∈ S, detPair p.1 p.2 := by
            dsimp [S]; rw [Finset.sum_filter]
    rw [hrhs]
    refine Finset.sum_bij (fun e _ => ((e 0 : Fin n), (e 1 : Fin n)))
      (fun e _ => by
        simp only [S, Finset.mem_filter, Finset.mem_product, Finset.mem_univ, true_and]
        exact e.strictMono (by decide : (0 : Fin 2) < 1))
      (fun e₁ e₂ _ _ h => by
        apply RelEmbedding.ext; intro a
        fin_cases a
        · exact congrArg Prod.fst h
        · exact congrArg Prod.snd h)
      (fun p hp => by
        simp only [S, Finset.mem_filter, Finset.mem_product, Finset.mem_univ,
          true_and] at hp
        have hne : p.1 ≠ p.2 := ne_of_lt hp
        have hcard : ({p.1, p.2} : Finset (Fin n)).card = 2 := by
          rw [Finset.card_insert_of_notMem, Finset.card_singleton]
          simp [hne]
        have hpos : (0 : ℕ) < 2 := by decide
        refine ⟨Finset.orderEmbOfFin ({p.1, p.2} : Finset (Fin n)) hcard,
          Finset.mem_univ _, ?_⟩
        apply Prod.ext
        · change Finset.orderEmbOfFin _ hcard ⟨0, hpos⟩ = p.1
          rw [Finset.orderEmbOfFin_zero hcard hpos]
          have hneS : ({p.2} : Finset (Fin n)).Nonempty := Finset.singleton_nonempty _
          rw [Finset.min'_insert p.1 {p.2} hneS, Finset.min'_singleton,
            min_eq_left (le_of_lt hp)]
        · change Finset.orderEmbOfFin _ hcard ⟨1, by decide⟩ = p.2
          have hidx : (⟨1, by decide⟩ : Fin 2) =
              ⟨2 - 1, Nat.sub_lt hpos Nat.one_pos⟩ := rfl
          rw [hidx, Finset.orderEmbOfFin_last hcard hpos]
          have hneS : ({p.2} : Finset (Fin n)).Nonempty := Finset.singleton_nonempty _
          rw [Finset.max'_insert p.1 {p.2} hneS, Finset.max'_singleton,
            max_eq_right (le_of_lt hp)])
      (fun e _ => rfl)
  -- Current goal is ∑ s, detPair-form (expanded). Fold to detPair, apply heq, hpairs.
  change ∑ s : powersetCard (Fin n) 2,
      detPair ((powersetCard.ofFinEmbEquiv.symm s) 0)
        ((powersetCard.ofFinEmbEquiv.symm s) 1) = _
  rw [heq, hpairs]
  -- Matrix Newton: ∑_{i<j} detPair = (2)⁻¹ * ((tr)² - tr(M²))
  have hnewton := matrix_trace_sq_sub_sq M
  have hsym : ∀ i j : Fin n, detPair i j = detPair j i := fun _ _ => by
    dsimp [detPair]; ring
  have hoff := matrix_sum_off_diag_symm detPair hsym
  have h2ne : (2 : k) ≠ 0 := by norm_num
  have hlt :
      (∑ i : Fin n, ∑ j : Fin n, if i < j then detPair i j else (0 : k)) =
        (2 : k)⁻¹ * ((M.trace) ^ 2 - (M * M).trace) := by
    have h1 :
        (∑ i : Fin n, ∑ j : Fin n, if i = j then (0 : k) else detPair i j) =
          (M.trace) ^ 2 - (M * M).trace := by
      trans (∑ i : Fin n, ∑ j : Fin n,
          if i = j then (0 : k) else (M i i * M j j - M i j * M j i))
      · refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
        simp only [detPair]
      · exact hnewton.symm
    -- sum_{i<j} = (2)⁻¹ * sum_off = (2)⁻¹ * (tr² - tr(M²))
    rw [eq_comm, inv_mul_eq_iff_eq_mul₀ h2ne, eq_comm, ← hoff, h1]
  rw [hlt]
  have htrM : M.trace = LinearMap.trace k V f :=
    (LinearMap.trace_eq_matrix_trace k b f).symm
  have htrM2 : (M * M).trace = LinearMap.trace k V (f ∘ₗ f) := by
    have hc : LinearMap.toMatrix b b (f ∘ₗ f) = M * M :=
      LinearMap.toMatrix_comp b b b f f
    rw [LinearMap.trace_eq_matrix_trace k b (f ∘ₗ f), hc]
  rw [htrM, htrM2]

theorem chiLambda2_sigma : chiLambda2 sigma = 3 := by
  dsimp [chiLambda2]
  rw [ambientAct_sigma_eq_map_Jlin]
  have h := trace_exterior_newton (V := U) Jlin
  change LinearMap.trace k (⋀[k]^2 U) (exteriorPower.map 2 Jlin) = (3 : k)
  rw [h, Jlin_trace, Jlin_comp_trace]
  norm_num

#print axioms chiLambda2_sigma
#print axioms trace_exterior_newton
#print axioms exterior_repr_map_eq_det
