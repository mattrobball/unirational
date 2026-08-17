module

public import V14Formalization.V14ProjectorEigenspaceFactorization

/-!
# Dimension-based factorization through the sigma carriers

Suppose a rank-ten projector `P` has image contained in the image of a
fifteen-by-ten matrix `B`. If six independent `+1` eigenvectors and four
independent `-1` eigenvectors of an involution `S` lie in the image of `P`,
then those ten vectors span the whole projector image. Consequently every
nonzero `S`-eigenvector fixed by `P` factors through exactly one carrier.

This replaces two full fifteen-by-fifteen projector identities by bounded
left-inverse and inclusion identities.
-/

noncomputable section

open Matrix

namespace V14Formalization.SigmaProjectorLinearAlgebra

universe u

variable {L : Type u} [Field L]

/-- The direct-sum coordinate map for the plus and minus carrier matrices. -/
public def plusMinusCarrierMap
    (Bplus : Matrix (Fin 15) (Fin 6) L)
    (Bminus : Matrix (Fin 15) (Fin 4) L) :
    ((Fin 6 → L) × (Fin 4 → L)) →ₗ[L] (Fin 15 → L) where
  toFun z := Bplus.mulVec z.1 + Bminus.mulVec z.2
  map_add' x y := by simp [Matrix.mulVec_add, add_left_comm, add_comm]
  map_smul' c x := by simp [Matrix.mulVec_smul, smul_add]

/-- Left inverses and opposite sigma eigenvalues make the combined carrier
map injective. -/
public theorem plusMinusCarrierMap_injective [NeZero (2 : L)]
    (S : Matrix (Fin 15) (Fin 15) L)
    (Bplus : Matrix (Fin 15) (Fin 6) L)
    (Lplus : Matrix (Fin 6) (Fin 15) L)
    (Bminus : Matrix (Fin 15) (Fin 4) L)
    (Lminus : Matrix (Fin 4) (Fin 15) L)
    (hLBplus : Lplus * Bplus = 1)
    (hLBminus : Lminus * Bminus = 1)
    (hSplus : S * Bplus = Bplus)
    (hSminus : S * Bminus = -Bminus) :
    Function.Injective (plusMinusCarrierMap Bplus Bminus) := by
  intro z w hzw
  let t := z - w
  have hz : plusMinusCarrierMap Bplus Bminus t = 0 := by
    rw [map_sub, hzw, sub_self]
  have hsum : Bplus.mulVec t.1 + Bminus.mulVec t.2 = 0 := hz
  have hdiff : Bplus.mulVec t.1 - Bminus.mulVec t.2 = 0 := by
    have h := congrArg S.mulVec hsum
    rw [Matrix.mulVec_add, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec,
      hSplus, hSminus, Matrix.neg_mulVec] at h
    have hzS : S.mulVec 0 = 0 := Matrix.mulVec_zero S
    rw [hzS] at h
    simpa [sub_eq_add_neg] using h
  have hplus2 : (2 : L) • Bplus.mulVec t.1 = 0 := by
    calc
      (2 : L) • Bplus.mulVec t.1 =
          (Bplus.mulVec t.1 + Bminus.mulVec t.2) +
            (Bplus.mulVec t.1 - Bminus.mulVec t.2) := by module
      _ = 0 := by rw [hsum, hdiff, add_zero]
  have hminus2 : (2 : L) • Bminus.mulVec t.2 = 0 := by
    calc
      (2 : L) • Bminus.mulVec t.2 =
          (Bplus.mulVec t.1 + Bminus.mulVec t.2) -
            (Bplus.mulVec t.1 - Bminus.mulVec t.2) := by module
      _ = 0 := by rw [hsum, hdiff, sub_zero]
  have hplus0 : Bplus.mulVec t.1 = 0 :=
    (smul_eq_zero.mp hplus2).resolve_left (NeZero.ne (2 : L))
  have hminus0 : Bminus.mulVec t.2 = 0 :=
    (smul_eq_zero.mp hminus2).resolve_left (NeZero.ne (2 : L))
  have hz1 : t.1 = 0 := by
    have h := congrArg Lplus.mulVec hplus0
    simpa [Matrix.mulVec_mulVec, hLBplus] using h
  have hz2 : t.2 = 0 := by
    have h := congrArg Lminus.mulVec hminus0
    simpa [Matrix.mulVec_mulVec, hLBminus] using h
  have : t = 0 := Prod.ext hz1 hz2
  change z - w = 0 at this
  exact sub_eq_zero.mp this

/-- The two carrier images exhaust the projector image by dimension. -/
public theorem exists_plusMinusCarrier_coordinates
    [NeZero (2 : L)]
    (P S : Matrix (Fin 15) (Fin 15) L)
    (B : Matrix (Fin 15) (Fin 10) L)
    (Lmat : Matrix (Fin 10) (Fin 15) L)
    (Bplus : Matrix (Fin 15) (Fin 6) L)
    (Lplus : Matrix (Fin 6) (Fin 15) L)
    (Bminus : Matrix (Fin 15) (Fin 4) L)
    (Lminus : Matrix (Fin 4) (Fin 15) L)
    (hfactor : B * Lmat * P = P)
    (hLBplus : Lplus * Bplus = 1)
    (hLBminus : Lminus * Bminus = 1)
    (hPplus : P * Bplus = Bplus)
    (hPminus : P * Bminus = Bminus)
    (hSplus : S * Bplus = Bplus)
    (hSminus : S * Bminus = -Bminus)
    {x : Fin 15 → L} (hPx : P.mulVec x = x) :
    ∃ u : Fin 6 → L, ∃ v : Fin 4 → L,
      Bplus.mulVec u + Bminus.mulVec v = x := by
  let c := plusMinusCarrierMap Bplus Bminus
  let p := P.toLin'
  let b := B.toLin'
  have hcinj : Function.Injective c :=
    plusMinusCarrierMap_injective S Bplus Lplus Bminus Lminus
      hLBplus hLBminus hSplus hSminus
  have hrangeC : Module.finrank L (LinearMap.range c) = 10 := by
    rw [LinearMap.finrank_range_of_inj hcinj]
    simp
  have hcp : LinearMap.range c ≤ LinearMap.range p := by
    rintro _ ⟨z, rfl⟩
    refine ⟨c z, ?_⟩
    change P.mulVec (Bplus.mulVec z.1 + Bminus.mulVec z.2) =
      Bplus.mulVec z.1 + Bminus.mulVec z.2
    rw [Matrix.mulVec_add, Matrix.mulVec_mulVec,
      Matrix.mulVec_mulVec, hPplus, hPminus]
  have hpb : LinearMap.range p ≤ LinearMap.range b := by
    rintro _ ⟨y, rfl⟩
    refine ⟨Lmat.mulVec (P.mulVec y), ?_⟩
    change B.mulVec (Lmat.mulVec (P.mulVec y)) = P.mulVec y
    rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, hfactor]
  have hrangeP_le : Module.finrank L (LinearMap.range p) ≤ 10 := by
    calc
      Module.finrank L (LinearMap.range p) ≤
          Module.finrank L (LinearMap.range b) := Submodule.finrank_mono hpb
      _ ≤ 10 := by
        simpa using LinearMap.finrank_range_le b
  have hrangeP : Module.finrank L (LinearMap.range p) = 10 := by
    apply Nat.le_antisymm hrangeP_le
    simpa [hrangeC] using Submodule.finrank_mono hcp
  have hcp_eq : LinearMap.range c = LinearMap.range p := by
    exact Submodule.eq_of_le_of_finrank_eq hcp (by rw [hrangeC, hrangeP])
  have hxmem : x ∈ LinearMap.range p := ⟨x, hPx⟩
  rw [← hcp_eq] at hxmem
  obtain ⟨z, hz⟩ := hxmem
  exact ⟨z.1, z.2, hz⟩

/-- A nonzero sigma eigenvector in the projector image belongs to exactly one
of the plus or minus carrier images. -/
public theorem exists_plus_or_minus_carrier_of_eigen
    [NeZero (2 : L)]
    (P S : Matrix (Fin 15) (Fin 15) L)
    (B : Matrix (Fin 15) (Fin 10) L)
    (Lmat : Matrix (Fin 10) (Fin 15) L)
    (Bplus : Matrix (Fin 15) (Fin 6) L)
    (Lplus : Matrix (Fin 6) (Fin 15) L)
    (Bminus : Matrix (Fin 15) (Fin 4) L)
    (Lminus : Matrix (Fin 4) (Fin 15) L)
    (hfactor : B * Lmat * P = P)
    (hLBplus : Lplus * Bplus = 1)
    (hLBminus : Lminus * Bminus = 1)
    (hPplus : P * Bplus = Bplus)
    (hPminus : P * Bminus = Bminus)
    (hSplus : S * Bplus = Bplus)
    (hSminus : S * Bminus = -Bminus)
    {x : Fin 15 → L} {a : L}
    (hPx : P.mulVec x = x)
    (hSx : S.mulVec x = a • x) (hx : x ≠ 0)
    (hS2 : S * S = 1) :
    (∃ u : Fin 6 → L, u ≠ 0 ∧ x = Bplus.mulVec u ∧ a = 1) ∨
      (∃ v : Fin 4 → L, v ≠ 0 ∧ x = Bminus.mulVec v ∧ a = -1) := by
  obtain ⟨u, v, huv⟩ := exists_plusMinusCarrier_coordinates P S B Lmat
    Bplus Lplus Bminus Lminus hfactor hLBplus hLBminus hPplus hPminus
    hSplus hSminus hPx
  rcases eigenvalue_eq_one_or_neg_one_of_involution S x a hS2 hx hSx with
      ha | ha
  · left
    have hSx' : S.mulVec x = x := by simpa [ha] using hSx
    have hminus0 : Bminus.mulVec v = 0 := by
      have h := congrArg S.mulVec huv
      rw [Matrix.mulVec_add, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec,
        hSplus, hSminus, Matrix.neg_mulVec, hSx'] at h
      have hneg : -Bminus.mulVec v = Bminus.mulVec v := by
        have hs : Bplus.mulVec u + -Bminus.mulVec v =
            Bplus.mulVec u + Bminus.mulVec v := by
          simpa [sub_eq_add_neg] using h.trans huv.symm
        exact add_left_cancel hs
      have htwo : (2 : L) • Bminus.mulVec v = 0 := by
        rw [two_smul]
        exact eq_neg_iff_add_eq_zero.mp hneg.symm
      exact (smul_eq_zero.mp htwo).resolve_left (NeZero.ne (2 : L))
    have hv0 : v = 0 := by
      have h := congrArg Lminus.mulVec hminus0
      simpa [Matrix.mulVec_mulVec, hLBminus] using h
    have hxu : x = Bplus.mulVec u := by simpa [hv0] using huv.symm
    have hu : u ≠ 0 := by
      intro hu0
      apply hx
      simpa [hu0] using hxu
    exact ⟨u, hu, hxu, ha⟩
  · right
    have hSx' : S.mulVec x = -x := by simpa [ha] using hSx
    have hplus0 : Bplus.mulVec u = 0 := by
      have h := congrArg S.mulVec huv
      rw [Matrix.mulVec_add, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec,
        hSplus, hSminus, Matrix.neg_mulVec, hSx'] at h
      have hneg : Bplus.mulVec u = -Bplus.mulVec u := by
        have hs0 := h.trans (congrArg Neg.neg huv).symm
        have hs : Bplus.mulVec u + -Bminus.mulVec v =
            -Bplus.mulVec u + -Bminus.mulVec v := by
          simpa [sub_eq_add_neg, neg_add_rev, add_comm, add_left_comm,
            add_assoc] using hs0
        exact add_right_cancel hs
      have htwo : (2 : L) • Bplus.mulVec u = 0 := by
        rw [two_smul]
        exact eq_neg_iff_add_eq_zero.mp hneg
      exact (smul_eq_zero.mp htwo).resolve_left (NeZero.ne (2 : L))
    have hu0 : u = 0 := by
      have h := congrArg Lplus.mulVec hplus0
      simpa [Matrix.mulVec_mulVec, hLBplus] using h
    have hxv : x = Bminus.mulVec v := by simpa [hu0] using huv.symm
    have hv : v ≠ 0 := by
      intro hv0
      apply hx
      simpa [hv0] using hxv
    exact ⟨v, hv, hxv, ha⟩

end V14Formalization.SigmaProjectorLinearAlgebra
