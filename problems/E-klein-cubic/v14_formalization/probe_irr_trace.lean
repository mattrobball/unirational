import V14Formalization.GeometricV14Carrier
import Mathlib.FieldTheory.Minpoly.Field
import Mathlib.LinearAlgebra.Charpoly.Basic
import Mathlib.LinearAlgebra.Charpoly.ToMatrix
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.Algebra.GroupWithZero.Associated

open Polynomial Module LinearMap AdjoinRoot Matrix
open V14Formalization.GeometricV14Carrier
open V14Formalization.GeometricFanoCarrier

set_option maxHeartbeats 32000000
noncomputable section

/-! ## Irreducible X⁴−X²+1 -/

theorem irreducible_X4_sub_X2_add_one :
    Irreducible ((X : k[X]) ^ 4 - X ^ 2 + 1) := by
  classical
  have hmon : ((X : k[X]) ^ 4 - X ^ 2 + 1).Monic := monic_X4_sub_X2_add_one
  have hdeg : ((X : k[X]) ^ 4 - X ^ 2 + 1).natDegree = 4 :=
    natDegree_X4_sub_X2_add_one
  have hne1 : ((X : k[X]) ^ 4 - X ^ 2 + 1) ≠ 1 := by
    intro h
    have := congrArg natDegree h
    simp only [hdeg, natDegree_one] at this
    omega
  rw [hmon.irreducible_iff_lt_natDegree_lt hne1]
  intro q hqmon hqdeg hdiv
  have hmem : 0 < q.natDegree ∧ q.natDegree ≤ 2 := by
    have : q.natDegree ∈ Finset.Ioc 0 (4 / 2) := by simpa [hdeg] using hqdeg
    simpa [Finset.mem_Ioc] using this
  have hq0 : q ≠ 0 := hqmon.ne_zero
  match hqd : q.natDegree with
  | 0 => omega
  | 1 =>
    have hdeg1 : degree q = 1 := (degree_eq_iff_natDegree_eq hq0).2 hqd
    obtain ⟨α, hα⟩ := exists_root_of_degree_eq_one hdeg1
    have hroot : IsRoot ((X : k[X]) ^ 4 - X ^ 2 + 1) α := by
      have : aeval α ((X : k[X]) ^ 4 - X ^ 2 + 1) = 0 :=
        aeval_eq_zero_of_dvd_aeval_eq_zero hdiv (by simpa [IsRoot.def] using hα)
      simpa [IsRoot.def] using this
    exact no_root_X4_sub_X2_add_one α hroot
  | 2 =>
    exact not_exists_monic_quad_dvd_X4 ⟨q, hqmon, hqd, hdiv⟩
  | n + 3 =>
    omega

/-! ## R preserves Wker -/

theorem aeval_Rlin_X4_eq :
    aeval (Rlin : Module.End k U) ((X : k[X]) ^ 4 - X ^ 2 + 1) =
      (Rlin : Module.End k U) ^ 4 - Rlin ^ 2 + LinearMap.id := by
  simp only [map_add, map_sub, map_pow, map_one, aeval_X, Module.End.one_eq_id]

theorem Rlin_mem_Wker {u : U} (hu : u ∈ Wker) : Rlin u ∈ Wker := by
  dsimp [Wker] at hu ⊢
  rw [LinearMap.mem_ker, aeval_Rlin_X4_eq] at hu ⊢
  have hpow (n : ℕ) :
      ((Rlin : Module.End k U) ^ n) (Rlin u) = (Rlin ^ (n + 1)) u := by
    rw [pow_succ, Module.End.mul_apply]
  show ((Rlin : Module.End k U) ^ 4 - Rlin ^ 2 + LinearMap.id) (Rlin u) = 0
  simp only [LinearMap.add_apply, LinearMap.sub_apply, LinearMap.id_apply]
  calc (Rlin ^ 4) (Rlin u) - (Rlin ^ 2) (Rlin u) + Rlin u
      = (Rlin ^ 5) u - (Rlin ^ 3) u + Rlin u := by rw [hpow 4, hpow 2]
    _ = Rlin ((Rlin ^ 4) u - (Rlin ^ 2) u + u) := by
          have h4 : (Rlin ^ 5) u = Rlin ((Rlin ^ 4) u) := by
            rw [pow_succ', Module.End.mul_apply]
          have h2 : (Rlin ^ 3) u = Rlin ((Rlin ^ 2) u) := by
            rw [pow_succ', Module.End.mul_apply]
          rw [h4, h2, map_add, map_sub]
    _ = Rlin (((Rlin : Module.End k U) ^ 4 - Rlin ^ 2 + LinearMap.id) u) := by
          simp only [LinearMap.add_apply, LinearMap.sub_apply, LinearMap.id_apply]
    _ = Rlin 0 := by rw [hu]
    _ = 0 := map_zero _

theorem Wker_ne_bot : Wker ≠ (⊥ : Submodule k U) := by
  intro hbot
  have htop : residualKer = ⊤ := by
    have : residualKer ⊔ Wker = ⊤ := residualKer_sup_Wker_eq_top
    rwa [hbot, sup_bot_eq] at this
  exact residualKer_ne_top htop

/-! ## finrank Wker = 4 -/

theorem minpoly_Rrestrict_Wker
    (hR : ∀ x ∈ Wker, Rlin x ∈ Wker) :
    minpoly k (Rrestrict Wker hR) = (X : k[X]) ^ 4 - X ^ 2 + 1 := by
  classical
  let RW := Rrestrict Wker hR
  haveI : Module.Finite k Wker := by
    haveI : Module.Finite k U := inferInstance
    exact Submodule.finite _
  have hann : aeval RW ((X : k[X]) ^ 4 - X ^ 2 + 1) = 0 := by
    ext x
    have hx : (x : U) ∈ Wker := x.property
    have hker : aeval (Rlin : Module.End k U) ((X : k[X]) ^ 4 - X ^ 2 + 1) (x : U) = 0 := by
      dsimp [Wker] at hx; rwa [LinearMap.mem_ker] at hx
    have hpow (n : ℕ) :
        (((RW ^ n) x : Wker) : U) = ((Rlin : Module.End k U) ^ n) (x : U) :=
      Rrestrict_pow_coe Wker hR n x
    have hcoe :
        ((aeval RW ((X : k[X]) ^ 4 - X ^ 2 + 1) x : Wker) : U) =
          aeval (Rlin : Module.End k U) ((X : k[X]) ^ 4 - X ^ 2 + 1) (x : U) := by
      simp only [map_add, map_sub, map_pow, map_one, aeval_X, Module.End.one_eq_id]
      change (((RW ^ 4 - RW ^ 2 + 1) x : Wker) : U) =
        ((Rlin ^ 4 - Rlin ^ 2 + LinearMap.id) (x : U))
      simp only [LinearMap.add_apply, LinearMap.sub_apply, Module.End.one_eq_id,
        LinearMap.id_apply, Submodule.coe_add, Submodule.coe_sub]
      rw [hpow 4, hpow 2]; rfl
    apply Subtype.ext
    rw [hcoe, hker]
    rfl
  have hmin_dvd : minpoly k RW ∣ ((X : k[X]) ^ 4 - X ^ 2 + 1) :=
    minpoly.dvd k RW (by simpa using hann)
  have hmin_irr : Irreducible (minpoly k RW) :=
    minpoly.irreducible (IsIntegral.of_finite k RW)
  have hmin_not_unit : ¬ IsUnit (minpoly k RW) := hmin_irr.not_isUnit
  have hassoc : Associated (minpoly k RW) ((X : k[X]) ^ 4 - X ^ 2 + 1) :=
    (irreducible_X4_sub_X2_add_one.dvd_iff.mp hmin_dvd).resolve_left hmin_not_unit
  exact eq_of_monic_of_associated
    (minpoly.monic (IsIntegral.of_finite k RW))
    monic_X4_sub_X2_add_one hassoc.symm

theorem finrank_Wker_eq_four : Module.finrank k Wker = 4 := by
  classical
  haveI : Module.Finite k U := inferInstance
  haveI : Module.Finite k Wker := Submodule.finite _
  haveI : Module.Free k Wker := Module.Free.of_divisionRing k Wker
  have hR : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
  let RW := Rrestrict Wker hR
  have hmin := minpoly_Rrestrict_Wker hR
  have hmin_deg : (minpoly k RW).natDegree = 4 := by
    rw [hmin, natDegree_X4_sub_X2_add_one]
  -- charpoly monic deg = finrank, minpoly | charpoly, both monic, deg minpoly = 4
  -- ⇒ if finrank < 4 impossible (minpoly deg ≤ finrank); so finrank ≥ 4
  have hle : (minpoly k RW).natDegree ≤ Module.finrank k Wker :=
    minpoly.natDegree_le k RW
  have hge : 4 ≤ Module.finrank k Wker := by rwa [hmin_deg] at hle
  -- finrank residual + finrank W = 6
  have hsum : Module.finrank k residualKer + Module.finrank k Wker =
      Module.finrank k U :=
    Submodule.finrank_add_eq_of_isCompl (V := U) isCompl_residualKer_Wker
  have hU : Module.finrank k U = 6 := finrank_U
  -- residual ≠ ⊤ already used for W ≠ ⊥; residual dim ≥ 0
  -- finrank W ≤ 6 and ≥ 4, and from field extension will get multiple of 4
  -- Use: charpoly = minpoly when degrees match after showing finrank = 4
  -- From hsum: finrank W = 6 - finrank residual ≤ 6
  have hWle : Module.finrank k Wker ≤ 6 := by omega
  -- AdjoinRoot field structure: L = k[X]/(minpoly), finrank L = 4, W is L-module
  let p : k[X] := (X : k[X]) ^ 4 - X ^ 2 + 1
  have hp_eq : minpoly k RW = p := hmin
  haveI : Fact (Irreducible p) := ⟨irreducible_X4_sub_X2_add_one⟩
  -- Use minpoly_dvd_charpoly and that charpoly degree = finrank
  -- If finrank = 5: impossible since minpoly deg 4 ≤ 5 but charpoly would need...
  -- Simpler: minpoly | charpoly, charpoly monic deg = n = finrank W
  -- Factorization: since minpoly irr, charpoly = minpoly^m * unit for the primary
  -- Actually over a field, if minpoly is irreducible then every irr factor of charpoly
  -- equals minpoly, so charpoly = c * minpoly^m. Monic ⇒ charpoly = minpoly^m.
  -- Thus n = 4m. With 4 ≤ n ≤ 6, n = 4.
  have hchar_dvd := LinearMap.minpoly_dvd_charpoly (K := k) (M := Wker) RW
  have hchar_deg : (LinearMap.charpoly RW).natDegree = Module.finrank k Wker :=
    LinearMap.charpoly_natDegree _
  -- minpoly^1 divides charpoly; extract power
  obtain ⟨q, hq⟩ := hchar_dvd
  have hmon_c : (LinearMap.charpoly RW).Monic := LinearMap.charpoly_monic RW
  have hmon_m : (minpoly k RW).Monic := minpoly.monic (IsIntegral.of_finite k RW)
  -- Since minpoly is irr, UniqueFactorization: charpoly is power of minpoly
  -- Use that q must be power of minpoly
  have : Module.finrank k Wker = 4 ∨ Module.finrank k Wker = 5 ∨
      Module.finrank k Wker = 6 := by omega
  -- Rule out 5,6 using multiplicity
  -- For monic factorization minpoly * q = charpoly with minpoly irr monic deg 4:
  -- deg q = n - 4 ∈ {0,1,2}
  -- If deg q = 0, q unit, n=4. Good.
  -- If deg q = 1, q has a root α, then minpoly(α for RW)? Charpoly(α)=0 so α eigenvalue,
  -- minpoly divides X-α in alg closure - contradiction with minpoly deg 4 irr having no root in k
  -- Actually q monic of deg 1 divides... wait q = charpoly/minpoly in the fraction field
  -- Simpler approach: use Associated and powers via normalizedFactors
  have hn : Module.finrank k Wker = 4 := by
    have hqd : q.natDegree = Module.finrank k Wker - 4 := by
      have hne : minpoly k RW ≠ 0 := minpoly.ne_zero (IsIntegral.of_finite k RW)
      have := natDegree_mul hne (fun hq0 => by
        rw [hq0, mul_zero] at hq
        exact (LinearMap.charpoly_monic RW).ne_zero hq.symm)
      rw [← hq, hchar_deg, hmin_deg] at this
      omega
    match hqdeg : q.natDegree with
    | 0 =>
      omega  -- finrank = 4
    | 1 =>
      -- q monic deg 1 after normalizing: charpoly has a linear factor over k
      -- ⇒ eigenvalue in k for RW ⇒ minpoly has deg 1 factor, contradiction
      have hroot : ∃ α : k, aeval α (LinearMap.charpoly RW) = 0 := by
        -- charpoly = minpoly * q, q deg 1 has root
        have hq1 : degree q = 1 := (degree_eq_iff_natDegree_eq
          (fun h0 => by simp [h0] at hqdeg)).2 hqdeg
        obtain ⟨α, hα⟩ := exists_root_of_degree_eq_one hq1
        refine ⟨α, ?_⟩
        rw [hq, map_mul]
        have : aeval α q = 0 := by simpa [IsRoot.def] using hα
        rw [this, mul_zero]
      obtain ⟨α, hα⟩ := hroot
      -- Cayley-Hamilton already used; eigenvalue means minpoly divides X-α
      have hev : aeval (RW) (C α : k[X]) = algebraMap k _ α := by
        simp [aeval_C, Algebra.algebraMap_eq_smul_one, Module.End.one_eq_id]
      -- If charpoly(α)=0 as scalar eval, not the same as eigenvalue without alg closed
      -- Use: minpoly divides any poly that annihilates; X-α doesn't annihilate unless...
      -- Actually eval of charpoly at α in k being 0 doesn't give eigenvalue without dual numbers.
      -- Better: q monic deg 1 = X - C β, so minpoly * (X-C β) = charpoly monic
      -- Then aeval RW (X-C β) * something = 0... not necessarily.
      -- Use UniqueFactorizationMonoid.dvd_of_mem_normalizedFactors
      exfalso
      -- minpoly irr deg 4 has no root, so doesn't have linear factor
      -- charpoly = minpoly * q with q deg 1 monic means charpoly has linear factor
      -- Over a field, charpoly splits into irr factors; having linear factor means
      -- minpoly has linear factor (same irr factors), contradiction
      have hlin : ∃ α : k, minpoly k RW ∣ (X - C α) := by
        -- From factorization in UFD
        sorry
      obtain ⟨α, hα⟩ := hlin
      have : (minpoly k RW).natDegree ≤ 1 :=
        natDegree_le_of_dvd hα (X_sub_C_ne_zero α)
      omega
    | 2 =>
      -- similar: minpoly would have deg ≤ 2 factor
      omega -- will fix
    | n + 3 =>
      omega
  exact hn

#print axioms irreducible_X4_sub_X2_add_one
#print axioms Rlin_mem_Wker
#print axioms Wker_ne_bot
#print axioms minpoly_Rrestrict_Wker
