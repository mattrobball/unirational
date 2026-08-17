module

public import V14Formalization.V14FieldPointReconstruction
public import V14Formalization.ProjectiveAwayNaturality

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry Matrix

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u

/-- Evaluation confirms the coordinate orientation of Problem B's linear
substitution: its induced point vector is `M.mulVec x`, with no transpose or
inverse. -/
public theorem eval_map_linearSubst_eq_mappedMatrix_mulVec
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (x : Fin (n + 1) → L) (i : Fin (n + 1)) :
    MvPolynomial.eval x
        (MvPolynomial.map (algebraMap k L) (linearSubst n M i)) =
      ((M.map (algebraMap k L)).mulVec x) i := by
  classical
  simp [linearSubst, Matrix.mulVec, dotProduct]

/-- On the `j`-th standard chart, the degree-zero fraction whose numerator is
the `i`-th transformed linear coordinate evaluates to `(M x) i` when `x j = 1`. -/
public theorem standardChartEvalAlgebra_linearSubstRatio
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (j i : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1) :
    ProjectiveSpace.standardChartEvalAlgebra (R := k) n j x
        (HomogeneousLocalization.Away.mk (coordGraded (R := k) n)
          (MvPolynomial.isHomogeneous_X k j) 1 (linearSubst n M i)
          (by
            rw [← linearSubstGradedRingHom_X]
            exact (linearSubstGradedRingHom n M).map_mem
              (MvPolynomial.isHomogeneous_X k i))) =
      ((M.map (algebraMap k L)).mulVec x) i := by
  classical
  have hsi : linearSubst n M i ∈ coordGraded (R := k) n 1 := by
    rw [← linearSubstGradedRingHom_X]
    exact (linearSubstGradedRingHom n M).map_mem
      (MvPolynomial.isHomogeneous_X k i)
  unfold ProjectiveSpace.standardChartEvalAlgebra
  rw [RingHom.comp_apply]
  change MvPolynomial.aeval (ProjectiveSpace.affineCoordinates j x)
    (ProjectiveSpace.standardChartToMvPolynomial n k j
      (HomogeneousLocalization.Away.mk _ _ 1 (linearSubst n M i) _)) = _
  rw [ProjectiveSpace.standardChartToMvPolynomial_away_mk n k j 1
    (linearSubst n M i) hsi]
  simp [linearSubst, ProjectiveSpace.chartDehomogenization,
    Matrix.mulVec, dotProduct]
  apply Finset.sum_congr rfl
  intro l hl
  congr 1
  rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨r, rfl⟩
  · simp [hxj]
  · simp [ProjectiveSpace.affineCoordinates]

/-- The localization element cutting out the inverse image of the `i`-th
target chart evaluates to the `i`-th coordinate of `M x`. -/
public theorem standardChartEvalAlgebra_isLocalizationElem_linearSubst
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (j i : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1) :
    ProjectiveSpace.standardChartEvalAlgebra (R := k) n j x
        (HomogeneousLocalization.Away.isLocalizationElem
          (MvPolynomial.isHomogeneous_X k j)
          ((linearSubstGradedRingHom n M).map_mem
            (MvPolynomial.isHomogeneous_X k i))) =
      ((M.map (algebraMap k L)).mulVec x) i := by
  rw [show
    HomogeneousLocalization.Away.isLocalizationElem
        (MvPolynomial.isHomogeneous_X k j)
        ((linearSubstGradedRingHom n M).map_mem
          (MvPolynomial.isHomogeneous_X k i)) =
      HomogeneousLocalization.Away.mk (coordGraded (R := k) n)
        (MvPolynomial.isHomogeneous_X k j) 1 (linearSubst n M i)
        (by
          rw [← linearSubstGradedRingHom_X]
          exact (linearSubstGradedRingHom n M).map_mem
            (MvPolynomial.isHomogeneous_X k i)) by
    apply HomogeneousLocalization.val_injective
    simp [HomogeneousLocalization.Away.isLocalizationElem]]
  exact standardChartEvalAlgebra_linearSubstRatio n M j i x hxj

/-- A normalized point fixed by the projective linear substitution has nonzero
transformed coordinate in its normalizing chart. -/
public theorem mappedMatrix_mulVec_normalizingCoordinate_ne_zero_of_fixed
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (hNM : N * M = 1)
    (j : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1)
    (hfixed :
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x ≫
          mapLinearSubst n M N hNM =
        ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x) :
    ((M.map (algebraMap k L)).mulVec x) j ≠ 0 := by
  classical
  let p := ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x
  let z := IsLocalRing.closedPoint L
  have hpchart : p.base z ∈ ProjectiveSpace.standardChart n k j := by
    exact pointOfNormalizedCoordinatesAlgebra_mem_standardChart n j x hxj j
      (by simp [hxj])
  have himagechart : (p ≫ mapLinearSubst n M N hNM).base z ∈
      ProjectiveSpace.standardChart n k j := by
    rw [hfixed]
    exact hpchart
  have hpaway : p.base z ∈ (linearAwayι n M j).opensRange := by
    rw [opensRange_linearAwayι n M N hNM j]
    change (mapLinearSubst n M N hNM).base (p.base z) ∈
      (ProjectiveSpace.standardChartι n k j).opensRange
    change (mapLinearSubst n M N hNM).base (p.base z) ∈
      ProjectiveSpace.standardChart n k j at himagechart
    simpa only [ProjectiveSpace.opensRange_standardChartι] using himagechart
  let e := ProjectiveSpace.standardChartEvalAlgebra (R := k) n j x
  have hs : linearSubst n M j ∈ coordGraded (R := k) n 1 := by
    simpa [linearSubstGradedRingHom_X] using
      (linearSubstGradedRingHom n M).map_mem
        (MvPolynomial.isHomogeneous_X k j)
  have hpre :
      ProjectiveSpace.standardChartι n k j ⁻¹ᵁ
          (linearAwayι n M j).opensRange =
        PrimeSpectrum.basicOpen
          (HomogeneousLocalization.Away.isLocalizationElem
            (MvPolynomial.isHomogeneous_X k j) hs) := by
    unfold linearAwayι ProjectiveSpace.standardChartι
    rw [Proj.opensRange_awayι]
    rw [linearSubstGradedRingHom_X]
    exact Proj.awayι_preimage_basicOpen
      (coordGraded (R := k) n)
      (MvPolynomial.isHomogeneous_X k j) zero_lt_one hs zero_lt_one
  have hmem : PrimeSpectrum.comap e z ∈
      PrimeSpectrum.basicOpen
        (HomogeneousLocalization.Away.isLocalizationElem
          (MvPolynomial.isHomogeneous_X k j) hs) := by
    rw [← hpre]
    change (Spec.map (CommRingCat.ofHom e)).base z ∈
      ProjectiveSpace.standardChartι n k j ⁻¹ᵁ
        (linearAwayι n M j).opensRange
    change (ProjectiveSpace.standardChartι n k j).base
      ((Spec.map (CommRingCat.ofHom e)).base z) ∈
        (linearAwayι n M j).opensRange
    change (ProjectiveSpace.standardChartι n k j).base
      ((Spec.map (CommRingCat.ofHom
        (ProjectiveSpace.standardChartEvalAlgebra (R := k) n j x))).base z) ∈
        (linearAwayι n M j).opensRange at hpaway
    exact hpaway
  rw [PrimeSpectrum.mem_basicOpen, PrimeSpectrum.comap_asIdeal,
    Ideal.mem_comap] at hmem
  have heval :
      e (HomogeneousLocalization.Away.isLocalizationElem
          (MvPolynomial.isHomogeneous_X k j) hs) =
        ((M.map (algebraMap k L)).mulVec x) j := by
    unfold e ProjectiveSpace.standardChartEvalAlgebra
    rw [RingHom.comp_apply]
    change MvPolynomial.aeval (ProjectiveSpace.affineCoordinates j x)
      (ProjectiveSpace.standardChartToMvPolynomial n k j
        (HomogeneousLocalization.Away.isLocalizationElem
          (MvPolynomial.isHomogeneous_X k j) hs)) = _
    unfold HomogeneousLocalization.Away.isLocalizationElem
    simp only [pow_one]
    rw [ProjectiveSpace.standardChartToMvPolynomial_away_mk
      n k j 1 (linearSubst n M j) hs]
    simp [linearSubst, ProjectiveSpace.chartDehomogenization,
      Matrix.mulVec, dotProduct]
    apply Finset.sum_congr rfl
    intro l hl
    congr 1
    rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨r, rfl⟩
    · simp [hxj]
    · simp [ProjectiveSpace.affineCoordinates]
  intro hy
  apply hmem
  simp [heval, hy]

/-- If the transformed `j`-coordinate is nonzero, Problem B's `Proj.map`
construction sends the normalized point `x` to the normalized point `M x /(M x)_j`. -/
public theorem pointOfNormalizedCoordinatesAlgebra_comp_mapLinearSubst
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (hNM : N * M = 1)
    (j : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1)
    (hyj : ((M.map (algebraMap k L)).mulVec x) j ≠ 0) :
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x ≫
        mapLinearSubst n M N hNM =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j
        (fun l ↦ ((M.map (algebraMap k L)).mulVec x) l /
          ((M.map (algebraMap k L)).mulVec x) j) := by
  classical
  have het₀ := standardChartEvalAlgebra_isLocalizationElem_linearSubst
    n M j j x hxj
  let y : Fin (n + 1) → L := (M.map (algebraMap k L)).mulVec x
  let s : MvPolynomial (Fin (n + 1)) k :=
    (linearSubstGradedRingHom n M) (MvPolynomial.X j)
  have hs : s ∈ coordGraded (R := k) n 1 := by
    dsimp [s]
    exact (linearSubstGradedRingHom n M).map_mem
      (MvPolynomial.isHomogeneous_X k j)
  let A₀ := ProjectiveSpace.StandardChartRing n k j
  let Aₒ := HomogeneousLocalization.Away (coordGraded (R := k) n)
    (s * MvPolynomial.X j)
  let e : A₀ →+* L :=
    ProjectiveSpace.standardChartEvalAlgebra (R := k) n j x
  let t : A₀ := HomogeneousLocalization.Away.isLocalizationElem
    (MvPolynomial.isHomogeneous_X k j) hs
  let locMap : A₀ →+* Aₒ := awayMap_X_s n s hs j
  let f := linearSubstGradedRingHom n M
  let targetMap : A₀ →+* Aₒ := by
    exact (awayMap_s_X n s hs j).comp
      (HomogeneousLocalization.Away.map f (MvPolynomial.X j))
  have het : e t = y j := by
    change ProjectiveSpace.standardChartEvalAlgebra (R := k) n j x
      (HomogeneousLocalization.Away.isLocalizationElem
        (MvPolynomial.isHomogeneous_X k j) hs) =
      ((M.map (algebraMap k L)).mulVec x) j
    have hproof : hs =
        (linearSubstGradedRingHom n M).map_mem
          (MvPolynomial.isHomogeneous_X k j) := Subsingleton.elim _ _
    rw [hproof]
    exact het₀
  letI : Algebra A₀ Aₒ := locMap.toAlgebra
  letI : IsLocalization.Away t Aₒ := by
    dsimp [A₀, Aₒ, locMap, t]
    exact HomogeneousLocalization.Away.isLocalization_mul
      (MvPolynomial.isHomogeneous_X k j) hs
      (mul_comm s (MvPolynomial.X j)) one_ne_zero
  have htunit : IsUnit (e t) := isUnit_iff_ne_zero.mpr (het.trans_ne hyj)
  let eₒ : Aₒ →+* L := IsLocalization.Away.lift t htunit
  have heₒ_comp : eₒ.comp locMap = e := by
    exact IsLocalization.Away.lift_comp t htunit
  have hcoord (l : Fin (n + 1)) :
      eₒ (targetMap (ProjectiveSpace.normalizedCoordinate n k j l)) =
        y l / y j := by
    have hfl : f (MvPolynomial.X l) ∈ coordGraded (R := k) n 1 :=
      f.map_mem (MvPolynomial.isHomogeneous_X k l)
    let q : A₀ := HomogeneousLocalization.Away.isLocalizationElem
      (MvPolynomial.isHomogeneous_X k j) hfl
    have heq : e q = y l := by
      change ProjectiveSpace.standardChartEvalAlgebra (R := k) n j x
        (HomogeneousLocalization.Away.isLocalizationElem
          (MvPolynomial.isHomogeneous_X k j) hfl) =
        ((M.map (algebraMap k L)).mulVec x) l
      have hproof : hfl =
          (linearSubstGradedRingHom n M).map_mem
            (MvPolynomial.isHomogeneous_X k l) := Subsingleton.elim _ _
      rw [hproof]
      exact standardChartEvalAlgebra_isLocalizationElem_linearSubst
        n M j l x hxj
    have ht_mk : t = HomogeneousLocalization.Away.mk
        (coordGraded (R := k) n) (MvPolynomial.isHomogeneous_X k j) 1 s hs := by
      apply HomogeneousLocalization.val_injective
      simp [t, HomogeneousLocalization.Away.isLocalizationElem]
    have hq_mk : q = HomogeneousLocalization.Away.mk
        (coordGraded (R := k) n) (MvPolynomial.isHomogeneous_X k j) 1
          (f (MvPolynomial.X l)) hfl := by
      apply HomogeneousLocalization.val_injective
      simp [q, HomogeneousLocalization.Away.isLocalizationElem]
    have hloc_t : locMap t =
        HomogeneousLocalization.Away.mk (coordGraded (R := k) n)
          (mem_coordGraded_s_mul_X (R := k) n hs j) 1
          (s * s ^ 1) (mem_coordGraded_G_mul_s_pow (R := k) n hs hs) := by
      rw [ht_mk]
      exact awayMap_X_s_mk n s hs j s hs
    have hmap_coord :
        HomogeneousLocalization.Away.map f (MvPolynomial.X j)
            (ProjectiveSpace.normalizedCoordinate n k j l) =
          HomogeneousLocalization.Away.mk (coordGraded (R := k) n) hs 1
            (f (MvPolynomial.X l)) hfl := by
      unfold ProjectiveSpace.normalizedCoordinate
      exact HomogeneousLocalization.Away.map_mk f (MvPolynomial.X j)
        (MvPolynomial.isHomogeneous_X k j) 1 (MvPolynomial.X l)
        (by simpa using MvPolynomial.isHomogeneous_X k l)
    have htarget : targetMap
          (ProjectiveSpace.normalizedCoordinate n k j l) =
        HomogeneousLocalization.Away.mk (coordGraded (R := k) n)
          (mem_coordGraded_s_mul_X (R := k) n hs j) 1
          (f (MvPolynomial.X l) * MvPolynomial.X j ^ 1)
          (mem_coordGraded_G_mul_X_pow (R := k) n hfl j) := by
      change (awayMap_s_X n s hs j)
        ((HomogeneousLocalization.Away.map f (MvPolynomial.X j))
          (ProjectiveSpace.normalizedCoordinate n k j l)) = _
      rw [hmap_coord]
      exact awayMap_s_X_mk n s hs j (f (MvPolynomial.X l)) hfl
    have hloc_q : locMap q =
        HomogeneousLocalization.Away.mk (coordGraded (R := k) n)
          (mem_coordGraded_s_mul_X (R := k) n hs j) 1
          (f (MvPolynomial.X l) * s ^ 1)
          (mem_coordGraded_G_mul_s_pow (R := k) n hfl hs) := by
      rw [hq_mk]
      exact awayMap_X_s_mk n s hs j (f (MvPolynomial.X l)) hfl
    have hrel : locMap t * targetMap
          (ProjectiveSpace.normalizedCoordinate n k j l) = locMap q := by
      rw [hloc_t, htarget, hloc_q]
      apply HomogeneousLocalization.val_injective
      rw [HomogeneousLocalization.val_mul]
      simp only [HomogeneousLocalization.Away.val_mk, pow_one]
      rw [Localization.mk_mul]
      apply Localization.mk_eq_mk_iff.mpr
      refine Localization.r_iff_exists.mpr ⟨1, ?_⟩
      simp only [OneMemClass.coe_one, one_mul, Submonoid.coe_mul]
      ring
    have hrel' := congrArg eₒ hrel
    have hlt : eₒ (locMap t) = e t := by
      change (eₒ.comp locMap) t = e t
      rw [heₒ_comp]
    have hlq : eₒ (locMap q) = e q := by
      change (eₒ.comp locMap) q = e q
      rw [heₒ_comp]
    simp only [map_mul] at hrel'
    rw [hlt, hlq, het, heq] at hrel'
    apply (eq_div_iff hyj).2
    simpa only [mul_comm] using hrel'
  have htarget_coeff (r : k) :
      targetMap (algebraMap k A₀ r) = locMap (algebraMap k A₀ r) := by
    let cr : coordGraded (R := k) n 0 :=
      ⟨MvPolynomial.C r, MvPolynomial.isHomogeneous_C _ r⟩
    have hfcr : f.gradedZeroRingHom cr = cr := by
      apply Subtype.ext
      change MvPolynomial.aeval (linearSubst n M) (MvPolynomial.C r) =
        MvPolynomial.C r
      simp
    have hfcr_val : f (cr : MvPolynomial (Fin (n + 1)) k) = cr := by
      change MvPolynomial.aeval (linearSubst n M) (MvPolynomial.C r) =
        MvPolynomial.C r
      simp
    have hmapF :
        HomogeneousLocalization.Away.map f (MvPolynomial.X j)
            (algebraMap k A₀ r) =
          HomogeneousLocalization.fromZeroRingHom
            (coordGraded (R := k) n) (.powers s) cr := by
      change HomogeneousLocalization.Away.map f (MvPolynomial.X j)
          (HomogeneousLocalization.fromZeroRingHom
            (coordGraded (R := k) n) (.powers (MvPolynomial.X j)) cr) = _
      apply HomogeneousLocalization.val_injective
      simp [HomogeneousLocalization.fromZeroRingHom,
        HomogeneousLocalization.Away.map,
        HomogeneousLocalization.map_mk]
      apply Localization.mk_eq_mk_iff.mpr
      refine Localization.r_iff_exists.mpr ⟨1, ?_⟩
      simp [hfcr_val]
    change (awayMap_s_X n s hs j)
        ((HomogeneousLocalization.Away.map f (MvPolynomial.X j))
          (algebraMap k A₀ r)) =
      (awayMap_X_s n s hs j) (algebraMap k A₀ r)
    rw [hmapF]
    change (awayMap_s_X n s hs j)
        (HomogeneousLocalization.fromZeroRingHom
          (coordGraded (R := k) n) (.powers s) cr) =
      (awayMap_X_s n s hs j)
        (HomogeneousLocalization.fromZeroRingHom
          (coordGraded (R := k) n) (.powers (MvPolynomial.X j)) cr)
    dsimp only [awayMap_s_X, awayMap_X_s]
    rw [HomogeneousLocalization.awayMap_fromZeroRingHom,
      HomogeneousLocalization.awayMap_fromZeroRingHom]
  have hcoeff (r : k) :
      (eₒ.comp targetMap) (algebraMap k A₀ r) = algebraMap k L r := by
    rw [RingHom.comp_apply, htarget_coeff]
    change (eₒ.comp locMap) (algebraMap k A₀ r) = _
    rw [heₒ_comp]
    simp [e, ProjectiveSpace.standardChartEvalAlgebra]
  let yN : Fin (n + 1) → L := fun l ↦ y l / y j
  have hyNj : yN j = 1 := by
    change y j / y j = 1
    exact div_self (by simpa only [y] using hyj)
  let eN : A₀ →+* L :=
    ProjectiveSpace.standardChartEvalAlgebra (R := k) n j yN
  let E := ProjectiveSpace.standardChartRingEquivMvPolynomial n k j
  let φ : MvPolynomial (Fin n) k →+* L :=
    (eₒ.comp targetMap).comp E.symm.toRingHom
  let ψ : MvPolynomial (Fin n) k →+* L :=
    eN.comp E.symm.toRingHom
  have hφψ : φ = ψ := by
    apply MvPolynomial.ringHom_ext
    · intro r
      have hEC : E.symm (MvPolynomial.C r) = algebraMap k A₀ r := by
        change E.symm (MvPolynomial.C r) =
          algebraMap k (ProjectiveSpace.StandardChartRing n k j) r
        apply E.injective
        rw [E.apply_symm_apply, E.commutes]
        exact DFunLike.congr_fun (MvPolynomial.algebraMap_eq k (Fin n)) r
      change (eₒ.comp targetMap) (E.symm (MvPolynomial.C r)) =
        eN (E.symm (MvPolynomial.C r))
      rw [hEC, hcoeff]
      simp [eN, ProjectiveSpace.standardChartEvalAlgebra]
    · intro r
      have hEX : E.symm (MvPolynomial.X r) =
          ProjectiveSpace.normalizedCoordinate n k j (j.succAbove r) := by
        apply E.injective
        simp [E]
      change (eₒ.comp targetMap) (E.symm (MvPolynomial.X r)) =
        eN (E.symm (MvPolynomial.X r))
      rw [hEX, RingHom.comp_apply, hcoord]
      exact (standardChartEvalAlgebra_normalizedCoordinate
        n j yN hyNj (j.succAbove r)).symm
  have hring : eₒ.comp targetMap = eN := by
    ext z
    let P := E z
    have hz : E.symm P = z := E.symm_apply_apply z
    rw [← hz]
    exact DFunLike.congr_fun hφψ P
  have hecat : CommRingCat.ofHom locMap ≫ CommRingCat.ofHom eₒ =
      CommRingCat.ofHom e := by
    rw [← CommRingCat.ofHom_comp]
    exact congrArg CommRingCat.ofHom heₒ_comp
  have hsource :
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x =
        (Spec.map (CommRingCat.ofHom eₒ) ≫
          Spec.map (CommRingCat.ofHom locMap)) ≫
            ProjectiveSpace.standardChartι n k j := by
    unfold ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
    rw [← Spec.map_comp, hecat]
  have hoverlap :
      Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs j)) ≫
          linearAwayι n M j =
        Spec.map (CommRingCat.ofHom locMap) ≫
          ProjectiveSpace.standardChartι n k j := by
    change Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs j)) ≫
        Proj.awayι (coordGraded (R := k) n) s hs zero_lt_one =
      Spec.map (CommRingCat.ofHom (awayMap_X_s n s hs j)) ≫
        ProjectiveSpace.standardChartι n k j
    exact awayMap_overlap_comp_eq n s hs j
  have hlinear :
      linearAwayι n M j ≫ mapLinearSubst n M N hNM =
        Spec.map (CommRingCat.ofHom
          (HomogeneousLocalization.Away.map f (MvPolynomial.X j))) ≫
            ProjectiveSpace.standardChartι n k j := by
    exact linearAwayι_comp_mapLinearSubst n M N hNM j
  have htargetCat :
      (CommRingCat.ofHom
          (HomogeneousLocalization.Away.map f (MvPolynomial.X j)) ≫
        CommRingCat.ofHom (awayMap_s_X n s hs j)) ≫
          CommRingCat.ofHom eₒ = CommRingCat.ofHom eN := by
    rw [← CommRingCat.ofHom_comp, ← CommRingCat.ofHom_comp]
    exact congrArg CommRingCat.ofHom hring
  have hspecTarget :
      (Spec.map (CommRingCat.ofHom eₒ) ≫
        Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs j))) ≫
          Spec.map (CommRingCat.ofHom
            (HomogeneousLocalization.Away.map f (MvPolynomial.X j))) =
        Spec.map (CommRingCat.ofHom eN) := by
    rw [← Spec.map_comp, ← Spec.map_comp, ← Category.assoc, htargetCat]
  change ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x ≫
      mapLinearSubst n M N hNM =
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j yN
  calc
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x ≫
        mapLinearSubst n M N hNM =
      (((Spec.map (CommRingCat.ofHom eₒ) ≫
        Spec.map (CommRingCat.ofHom locMap)) ≫
          ProjectiveSpace.standardChartι n k j) ≫
            mapLinearSubst n M N hNM) := by rw [← hsource]
    _ = Spec.map (CommRingCat.ofHom eₒ) ≫
        ((Spec.map (CommRingCat.ofHom locMap) ≫
          ProjectiveSpace.standardChartι n k j) ≫
            mapLinearSubst n M N hNM) := by simp only [Category.assoc]
    _ = Spec.map (CommRingCat.ofHom eₒ) ≫
        ((Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs j)) ≫
          linearAwayι n M j) ≫ mapLinearSubst n M N hNM) := by
            rw [hoverlap]
    _ = (Spec.map (CommRingCat.ofHom eₒ) ≫
        Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs j))) ≫
          (linearAwayι n M j ≫ mapLinearSubst n M N hNM) := by
            simp only [Category.assoc]
    _ = (Spec.map (CommRingCat.ofHom eₒ) ≫
        Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs j))) ≫
          (Spec.map (CommRingCat.ofHom
            (HomogeneousLocalization.Away.map f (MvPolynomial.X j))) ≫
              ProjectiveSpace.standardChartι n k j) := by rw [hlinear]
    _ = ((Spec.map (CommRingCat.ofHom eₒ) ≫
        Spec.map (CommRingCat.ofHom (awayMap_s_X n s hs j))) ≫
          Spec.map (CommRingCat.ofHom
            (HomogeneousLocalization.Away.map f (MvPolynomial.X j)))) ≫
              ProjectiveSpace.standardChartι n k j := by simp only [Category.assoc]
    _ = Spec.map (CommRingCat.ofHom eN) ≫
        ProjectiveSpace.standardChartι n k j := by rw [hspecTarget]
    _ = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j yN := rfl

/-- A normalized field-valued projective point fixed by an invertible linear
substitution is represented by an eigenvector of the scalar-extended matrix. -/
public theorem exists_eigenScalar_of_pointOfNormalizedCoordinatesAlgebra_fixed
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (hNM : N * M = 1)
    (j : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1)
    (hfixed :
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x ≫
          mapLinearSubst n M N hNM =
        ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x) :
    ∃ a : L, a ≠ 0 ∧
      (M.map (algebraMap k L)).mulVec x = a • x := by
  let y : Fin (n + 1) → L := (M.map (algebraMap k L)).mulVec x
  have hyj : y j ≠ 0 := by
    exact mappedMatrix_mulVec_normalizingCoordinate_ne_zero_of_fixed
      n M N hNM j x hxj hfixed
  let yN : Fin (n + 1) → L := fun l ↦ y l / y j
  have hyNj : yN j = 1 := by
    change y j / y j = 1
    exact div_self hyj
  have hmap :
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x ≫
          mapLinearSubst n M N hNM =
        ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j yN := by
    exact pointOfNormalizedCoordinatesAlgebra_comp_mapLinearSubst
      n M N hNM j x hxj (by simpa only [y] using hyj)
  have hpoint :
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x =
        ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j yN :=
    hfixed.symm.trans hmap
  have hxy : x = yN :=
    normalizedCoordinates_eq_of_pointOfNormalizedCoordinatesAlgebra_eq
      n j x yN hxj hyNj hpoint
  refine ⟨y j, hyj, ?_⟩
  funext l
  have hl : x l = y l / y j := congrFun hxy l
  have hmul : x l * y j = y l := (eq_div_iff hyj).mp hl
  simpa only [y, Pi.smul_apply, smul_eq_mul, mul_comm] using hmul.symm

/-- Requested wrapper with an explicitly named scheme point reconstructed from
normalized coordinates. -/
public theorem exists_eigenScalar_of_mapLinearSubst_fixed
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k)
    (hNM : N * M = 1)
    (j : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1)
    (p : Spec (.of L) ⟶ ProjectiveSpace n k)
    (hp : p = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
      (R := k) n j x)
    (hfixed : p ≫ mapLinearSubst n M N hNM = p) :
    ∃ a : L, a ≠ 0 ∧
      (M.map (algebraMap k L)).mulVec x = a • x := by
  subst p
  exact exists_eigenScalar_of_pointOfNormalizedCoordinatesAlgebra_fixed
    n M N hNM j x hxj hfixed

end SchemeGeometry
end V14Formalization
