/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14FixedByAmbientPoint
public import V14Formalization.V14FixedPointCarrierConcrete
public import V14Formalization.V14FixedPointDescent
public import V14Formalization.D12SigmaMinusDescent
public import V14Formalization.D12SigmaPlusDescent
public import V14Formalization.WeierstrassSchemeDescent
public import V14Formalization.SchemeFixedLocus
public import V14Formalization.SchemeModelAliases

/-!
# Descent of a pure-transcendental V14 sigma-fixed field point
-/

noncomputable section

open CategoryTheory Matrix MvPolynomial
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open GeometricV14Carrier Lambda2Coordinates
open EllipticPolynomialConstancy
open D12SigmaPlusDescent D12SigmaMinusDescent
open WeierstrassSchemeDescent


theorem pluckerValue_eq_eval_map {F : Type*} [Field F] [Algebra k F]
    (x : Fin 15 → F) (q : Fin 15) :
    D12Certificate.pluckerValue x q =
      eval x (map (algebraMap k F) (pluckerQuadric k q)) := by
  simp [D12Certificate.pluckerValue, pluckerQuadric, eval_mul,
    eval_sub, eval_add, eval_X]

theorem algEquiv_comp_algebraMap
    {L : Type} [Field L] [Algebra k L] {n : ℕ}
    (e : MvFrac k n ≃ₐ[k] L) :
    e.toRingHom.comp (algebraMap k (MvFrac k n)) = algebraMap k L :=
  RingHom.ext fun a => e.commutes a

theorem algEquiv_symm_comp_algebraMap
    {L : Type} [Field L] [Algebra k L] {n : ℕ}
    (e : MvFrac k n ≃ₐ[k] L) :
    e.symm.toRingHom.comp (algebraMap k L) = algebraMap k (MvFrac k n) :=
  RingHom.ext fun a => by
    have := congrArg e.symm (e.commutes a)
    simpa using this

theorem mulVec_map_algEquiv
    {L : Type} [Field L] [Algebra k L] {nvars rows cols : ℕ}
    (e : MvFrac k nvars ≃ₐ[k] L)
    (M : Matrix (Fin rows) (Fin cols) k)
    (v : Fin cols → MvFrac k nvars) :
    (M.map (algebraMap k L)).mulVec (fun i => e (v i)) =
      fun i => e ((M.map (algebraMap k (MvFrac k nvars))).mulVec v i) := by
  have hcomp := algEquiv_comp_algebraMap (L := L) e
  have := mulVec_comp_map (m := rows) (n := cols) e.toRingHom
      (algebraMap k (MvFrac k nvars)) M v
  rw [hcomp] at this
  exact this

/-- Plus-carrier coordinates over `L ≃ MvFrac k n` descend to a normalized
base-field plus eigenvector. -/
theorem plus_branch_normalized_descends
    {L : Type} [Field L] [Algebra k L] (n : ℕ)
    (e : MvFrac k n ≃ₐ[k] L)
    (x : Fin 15 → L) (u : Fin 6 → L) (hu : u ≠ 0)
    (hx : x = ((D12SigmaCarrierConcrete.core.Bplus).map
      (algebraMap k L)).mulVec u)
    (hPx : (V14SchemeModel.projectorMatrix.map
      (algebraMap k L)).mulVec x = x)
    (hQ : ∀ q : Fin 15, D12Certificate.pluckerValue x q = 0)
    (j : Fin 15) (hxj : x j = 1) :
    ∃ (x0 : Fin 15 → k),
      x0 j = 1 ∧
      x = (fun i => algebraMap k L (x0 i)) ∧
      V14SchemeModel.projectorMatrix.mulVec x0 = x0 ∧
      (∀ q : Fin 15, eval x0 (pluckerQuadric k q) = 0) ∧
      ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
          GeometricV14Carrier.sigma :
          Matrix (Fin 15) (Fin 15) k)).mulVec x0 = x0 := by
  let C := D12SigmaCarrierConcrete.core
  let xM : Fin 15 → MvFrac k n := fun i => e.symm (x i)
  let uM : Fin 6 → MvFrac k n := fun i => e.symm (u i)
  have huM : uM ≠ 0 := by
    intro h0
    apply hu
    funext i
    have : e.symm (u i) = 0 := congrFun h0 i
    simpa using (map_eq_zero_iff e.symm.toRingHom e.symm.injective).1 this
  have hxM :
      xM = (C.Bplus.map (algebraMap k (MvFrac k n))).mulVec uM := by
    have hx' :
        x = fun i => e ((C.Bplus.map
          (algebraMap k (MvFrac k n))).mulVec uM i) := by
      have hu' : u = fun i => e (uM i) := by
        funext i
        simp [uM]
      rw [hx, hu']
      exact mulVec_map_algEquiv (rows := 15) (cols := 6) e C.Bplus uM
    funext i
    have hi := congrFun hx' i
    have : e (xM i) =
        e ((C.Bplus.map (algebraMap k (MvFrac k n))).mulVec uM i) := by
      simpa [xM] using hi
    exact e.injective this
  have hQM : ∀ q : Fin 15, D12Certificate.pluckerValue xM q = 0 := by
    intro q
    have := pluckerValue_map e.symm.toRingHom x q
    simpa [xM, hQ q] using this
  obtain ⟨u0, hu0, c, hc, hudesc⟩ :=
    plusCarrier_commonPluckerZero_descends_mvfrac n uM huM (by
      intro q
      simpa [hxM] using hQM q)
  let y0 : Fin 15 → k := C.Bplus.mulVec u0
  have hy0 : y0 ≠ 0 := by
    intro h0
    have := congrArg C.Lplus.mulVec h0
    have : u0 = 0 := by
      simpa [y0, Matrix.mulVec_mulVec, C.left_inverse_plus] using this
    exact hu0 this
  have hxMy0 :
      xM = c • fun i => algebraMap k (MvFrac k n) (y0 i) := by
    have hmap :
        (C.Bplus.map (algebraMap k (MvFrac k n))).mulVec
          (fun i => algebraMap k (MvFrac k n) (u0 i)) =
        fun i => algebraMap k (MvFrac k n) (y0 i) := by
      funext i
      simp [y0, Matrix.mulVec, dotProduct, map_sum, map_mul]
    rw [hxM, hudesc, Matrix.mulVec_smul, hmap]
  have hy0j : y0 j ≠ 0 := by
    intro h0
    have hxMj : xM j = 1 := by simp [xM, hxj]
    have := congrFun hxMy0 j
    rw [hxMj, Pi.smul_apply, smul_eq_mul, h0, map_zero, mul_zero] at this
    exact one_ne_zero this
  let x0 : Fin 15 → k := fun i => y0 i / y0 j
  have hx0j : x0 j = 1 := by simp [x0, hy0j]
  have hxM' : xM = fun i => algebraMap k (MvFrac k n) (x0 i) := by
    have hcj : c * algebraMap k (MvFrac k n) (y0 j) = 1 := by
      have := congrFun hxMy0 j
      simpa [xM, hxj, Pi.smul_apply, smul_eq_mul] using this.symm
    funext i
    have hi := congrFun hxMy0 i
    rw [Pi.smul_apply, smul_eq_mul] at hi
    calc
      xM i = c * algebraMap k (MvFrac k n) (y0 i) := hi
      _ = (c * algebraMap k (MvFrac k n) (y0 j)) *
            (algebraMap k (MvFrac k n) (y0 i) /
              algebraMap k (MvFrac k n) (y0 j)) := by
            have hb0 : algebraMap k (MvFrac k n) (y0 j) ≠ 0 :=
              (map_ne_zero_iff (algebraMap k (MvFrac k n))
                (algebraMap k (MvFrac k n)).injective).2 hy0j
            field_simp [hb0]
      _ = algebraMap k (MvFrac k n) (y0 i / y0 j) := by
            rw [hcj, one_mul, ← map_div₀]
      _ = algebraMap k (MvFrac k n) (x0 i) := rfl
  have hx0 : x = fun i => algebraMap k L (x0 i) := by
    funext i
    have : e (xM i) = x i := by simp [xM]
    rw [← this, congrFun hxM' i]
    exact e.commutes (x0 i)
  have hproj0 : V14SchemeModel.projectorMatrix.mulVec x0 = x0 := by
    have hmap :
        (V14SchemeModel.projectorMatrix.map (algebraMap k L)).mulVec
          (fun i => algebraMap k L (x0 i)) =
        fun i => algebraMap k L
          (V14SchemeModel.projectorMatrix.mulVec x0 i) := by
      funext i
      simp [Matrix.mulVec, Matrix.map_apply, dotProduct, map_sum, map_mul]
    have := hPx
    rw [hx0, hmap] at this
    ext i
    exact (algebraMap k L).injective (congrFun this i)
  have hQ0 : ∀ q : Fin 15, eval x0 (pluckerQuadric k q) = 0 := by
    intro q
    have hmap :
        D12Certificate.pluckerValue
          (fun i => algebraMap k (MvFrac k n) (x0 i)) q =
        algebraMap k (MvFrac k n)
          (D12Certificate.pluckerValue x0 q) :=
      pluckerValue_map (algebraMap k (MvFrac k n)) x0 q
    have := hQM q
    rw [hxM', hmap] at this
    have hval : D12Certificate.pluckerValue x0 q = 0 :=
      (map_eq_zero_iff (algebraMap k (MvFrac k n))
        (algebraMap k (MvFrac k n)).injective).1 this
    simpa [D12Certificate.pluckerValue, pluckerQuadric, eval_pluckerQuadric]
      using hval
  have hS0 :
      ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
          GeometricV14Carrier.sigma :
          Matrix (Fin 15) (Fin 15) k)).mulVec x0 = x0 := by
    have hSB : ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
          GeometricV14Carrier.sigma :
          Matrix (Fin 15) (Fin 15) k)) * C.Bplus = C.Bplus :=
      C.sigma_eigen_plus
    have hyS :
        ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
            GeometricV14Carrier.sigma :
            Matrix (Fin 15) (Fin 15) k)).mulVec y0 = y0 := by
      simp only [y0]
      rw [Matrix.mulVec_mulVec, hSB]
    have hx0smul : x0 = (y0 j)⁻¹ • y0 := by
      funext i
      simp [x0, Pi.smul_apply, smul_eq_mul, div_eq_inv_mul]
    rw [hx0smul, Matrix.mulVec_smul, hyS]
  exact ⟨x0, hx0j, hx0, hproj0, hQ0, hS0⟩

/-- Minus-carrier coordinates over `L ≃ MvFrac k n` descend to a normalized
base-field minus eigenvector. -/
theorem minus_branch_normalized_descends
    {L : Type} [Field L] [Algebra k L] (n : ℕ)
    (e : MvFrac k n ≃ₐ[k] L)
    (x : Fin 15 → L) (v : Fin 4 → L) (hv : v ≠ 0)
    (hx : x = ((D12SigmaCarrierConcrete.core.Bminus).map
      (algebraMap k L)).mulVec v)
    (hPx : (V14SchemeModel.projectorMatrix.map
      (algebraMap k L)).mulVec x = x)
    (hQ : ∀ q : Fin 15, D12Certificate.pluckerValue x q = 0)
    (j : Fin 15) (hxj : x j = 1) :
    ∃ (x0 : Fin 15 → k),
      x0 j = 1 ∧
      x = (fun i => algebraMap k L (x0 i)) ∧
      V14SchemeModel.projectorMatrix.mulVec x0 = x0 ∧
      (∀ q : Fin 15, eval x0 (pluckerQuadric k q) = 0) ∧
      ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
          GeometricV14Carrier.sigma :
          Matrix (Fin 15) (Fin 15) k)).mulVec x0 = -x0 := by
  let C := D12SigmaCarrierConcrete.core
  let xM : Fin 15 → MvFrac k n := fun i => e.symm (x i)
  let vM : Fin 4 → MvFrac k n := fun i => e.symm (v i)
  have hvM : vM ≠ 0 := by
    intro h0
    apply hv
    funext i
    have : e.symm (v i) = 0 := congrFun h0 i
    simpa using (map_eq_zero_iff e.symm.toRingHom e.symm.injective).1 this
  have hxM :
      xM = (C.Bminus.map (algebraMap k (MvFrac k n))).mulVec vM := by
    have hx' :
        x = fun i => e ((C.Bminus.map
          (algebraMap k (MvFrac k n))).mulVec vM i) := by
      have hv' : v = fun i => e (vM i) := by
        funext i
        simp [vM]
      rw [hx, hv']
      exact mulVec_map_algEquiv (rows := 15) (cols := 4) e C.Bminus vM
    funext i
    have hi := congrFun hx' i
    have : e (xM i) =
        e ((C.Bminus.map (algebraMap k (MvFrac k n))).mulVec vM i) := by
      simpa [xM] using hi
    exact e.injective this
  have hQM : ∀ q : Fin 15, D12Certificate.pluckerValue xM q = 0 := by
    intro q
    have := pluckerValue_map e.symm.toRingHom x q
    simpa [xM, hQ q] using this
  obtain ⟨v0, hv0, c, hc, hvdesc⟩ :=
    minusCarrier_commonPluckerZero_descends_mvfrac n vM hvM (by
      intro q
      simpa [hxM] using hQM q)
  let y0 : Fin 15 → k := C.Bminus.mulVec v0
  have hy0j : y0 j ≠ 0 := by
    have hmap :
        (C.Bminus.map (algebraMap k (MvFrac k n))).mulVec
          (fun i => algebraMap k (MvFrac k n) (v0 i)) =
        fun i => algebraMap k (MvFrac k n) (y0 i) := by
      funext i
      simp [y0, Matrix.mulVec, dotProduct, map_sum, map_mul]
    have hxMy0 :
        xM = c • fun i => algebraMap k (MvFrac k n) (y0 i) := by
      rw [hxM, hvdesc, Matrix.mulVec_smul, hmap]
    intro h0
    have := congrFun hxMy0 j
    simp [xM, hxj, Pi.smul_apply, smul_eq_mul, h0] at this
  let x0 : Fin 15 → k := fun i => y0 i / y0 j
  have hx0j : x0 j = 1 := by simp [x0, hy0j]
  have hxM' : xM = fun i => algebraMap k (MvFrac k n) (x0 i) := by
    have hmap :
        (C.Bminus.map (algebraMap k (MvFrac k n))).mulVec
          (fun i => algebraMap k (MvFrac k n) (v0 i)) =
        fun i => algebraMap k (MvFrac k n) (y0 i) := by
      funext i
      simp [y0, Matrix.mulVec, dotProduct, map_sum, map_mul]
    have hxMy0 :
        xM = c • fun i => algebraMap k (MvFrac k n) (y0 i) := by
      rw [hxM, hvdesc, Matrix.mulVec_smul, hmap]
    have hcj : c * algebraMap k (MvFrac k n) (y0 j) = 1 := by
      have := congrFun hxMy0 j
      simpa [xM, hxj, Pi.smul_apply, smul_eq_mul] using this.symm
    funext i
    have hi := congrFun hxMy0 i
    rw [Pi.smul_apply, smul_eq_mul] at hi
    calc
      xM i = c * algebraMap k (MvFrac k n) (y0 i) := hi
      _ = (c * algebraMap k (MvFrac k n) (y0 j)) *
            (algebraMap k (MvFrac k n) (y0 i) /
              algebraMap k (MvFrac k n) (y0 j)) := by
            have hb0 : algebraMap k (MvFrac k n) (y0 j) ≠ 0 :=
              (map_ne_zero_iff (algebraMap k (MvFrac k n))
                (algebraMap k (MvFrac k n)).injective).2 hy0j
            field_simp [hb0]
      _ = algebraMap k (MvFrac k n) (y0 i / y0 j) := by
            rw [hcj, one_mul, ← map_div₀]
      _ = algebraMap k (MvFrac k n) (x0 i) := rfl
  have hx0 : x = fun i => algebraMap k L (x0 i) := by
    funext i
    have : e (xM i) = x i := by simp [xM]
    rw [← this, congrFun hxM' i]
    exact e.commutes (x0 i)
  have hproj0 : V14SchemeModel.projectorMatrix.mulVec x0 = x0 := by
    have hmap :
        (V14SchemeModel.projectorMatrix.map (algebraMap k L)).mulVec
          (fun i => algebraMap k L (x0 i)) =
        fun i => algebraMap k L
          (V14SchemeModel.projectorMatrix.mulVec x0 i) := by
      funext i
      simp [Matrix.mulVec, Matrix.map_apply, dotProduct, map_sum, map_mul]
    have := hPx
    rw [hx0, hmap] at this
    ext i
    exact (algebraMap k L).injective (congrFun this i)
  have hQ0 : ∀ q : Fin 15, eval x0 (pluckerQuadric k q) = 0 := by
    intro q
    have hmap :
        D12Certificate.pluckerValue
          (fun i => algebraMap k (MvFrac k n) (x0 i)) q =
        algebraMap k (MvFrac k n)
          (D12Certificate.pluckerValue x0 q) :=
      pluckerValue_map (algebraMap k (MvFrac k n)) x0 q
    have := hQM q
    rw [hxM', hmap] at this
    have hval : D12Certificate.pluckerValue x0 q = 0 :=
      (map_eq_zero_iff (algebraMap k (MvFrac k n))
        (algebraMap k (MvFrac k n)).injective).1 this
    simpa [D12Certificate.pluckerValue, pluckerQuadric, eval_pluckerQuadric]
      using hval
  have hS0 :
      ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
          GeometricV14Carrier.sigma :
          Matrix (Fin 15) (Fin 15) k)).mulVec x0 = -x0 := by
    have hSB : ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
          GeometricV14Carrier.sigma :
          Matrix (Fin 15) (Fin 15) k)) * C.Bminus = -C.Bminus :=
      C.sigma_eigen_minus
    have hyS :
        ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
            GeometricV14Carrier.sigma :
            Matrix (Fin 15) (Fin 15) k)).mulVec y0 = -y0 := by
      simp only [y0]
      rw [Matrix.mulVec_mulVec, hSB, Matrix.neg_mulVec]
    have hx0smul : x0 = (y0 j)⁻¹ • y0 := by
      funext i
      simp [x0, Pi.smul_apply, smul_eq_mul, div_eq_inv_mul]
    rw [hx0smul, Matrix.mulVec_smul, hyS, smul_neg]
  exact ⟨x0, hx0j, hx0, hproj0, hQ0, hS0⟩

theorem pointOfNormalizedCoordinatesAlgebra_over_base
    (j : Fin 15) (x0 : Fin 15 → k) (hx0j : x0 j = 1) :
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 14 j x0 =
      ProjectiveSpace.pointOfNormalizedCoordinates 14 k j x0 hx0j := by
  have h := specMap_comp_pointOfNormalizedCoordinates
    (R := k) (S := k) 14 j x0 hx0j
  have hmap : algebraMap k k = RingHom.id k :=
    RingHom.ext fun t => by simp
  rw [hmap] at h
  simpa using h.symm

theorem v14FixedFieldPoint_comp_ι_eq
    {L : Type} [Field L] [Algebra k L]
    (p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma)
    (j : Fin 15) (x : Fin 15 → L) (x0 : Fin 15 → k)
    (hx0j : x0 j = 1)
    (hproj0 : V14SchemeModel.projectorMatrix.mulVec x0 = x0)
    (hQ0 : ∀ q : Fin 15, eval x0 (pluckerQuadric k q) = 0)
    (hxpt : ambientPointOfV14FixedBy L p =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 14 j x)
    (hx0 : x = fun i => algebraMap k L (x0 i)) :
    (p.left ≫
        (fixedByι V14SchemeModel.actionOver
          GeometricV14Carrier.sigma).left) ≫
        V14SchemeModel.v14Schemeι =
      (Spec.map (CommRingCat.ofHom (algebraMap k L)) ≫
        v14SchemePointOfNormalizedCoordinates j x0 hx0j hproj0 hQ0) ≫
        V14SchemeModel.v14Schemeι := by
  have hι := v14SchemePointOfNormalizedCoordinates_ι j x0 hx0j hproj0 hQ0
  calc
    (p.left ≫
        (fixedByι V14SchemeModel.actionOver
          GeometricV14Carrier.sigma).left) ≫
        V14SchemeModel.v14Schemeι =
      ambientPointOfV14FixedBy L p := rfl
    _ = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
          (R := k) 14 j x := hxpt
    _ = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
          (R := k) 14 j (fun i => algebraMap k L (x0 i)) := by
          rw [hx0]
    _ = Spec.map (CommRingCat.ofHom (algebraMap k L)) ≫
          ProjectiveSpace.pointOfNormalizedCoordinates 14 k j x0 hx0j :=
          (specMap_comp_pointOfNormalizedCoordinates 14 j x0 hx0j).symm
    _ = Spec.map (CommRingCat.ofHom (algebraMap k L)) ≫
          (v14SchemePointOfNormalizedCoordinates j x0 hx0j hproj0 hQ0 ≫
            V14SchemeModel.v14Schemeι) := by
          rw [hι, pointOfNormalizedCoordinatesAlgebra_over_base j x0 hx0j]
    _ = (Spec.map (CommRingCat.ofHom (algebraMap k L)) ≫
          v14SchemePointOfNormalizedCoordinates j x0 hx0j hproj0 hQ0) ≫
          V14SchemeModel.v14Schemeι :=
        (Category.assoc _ _ _).symm

public theorem v14FixedFieldPoint_descends_of_mvfrac
    (n : ℕ) (L : Type) [Field L] [Algebra k L] [NeZero (2 : L)]
    (e : MvFrac k n ≃ₐ[k] L)
    (p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma) :
    ∃ y : Spec (.of k) ⟶ V14SchemeModel.v14Scheme,
      y ≫ V14SchemeModel.actionOver.V.hom = 𝟙 _ ∧
      y ≫ (V14SchemeModel.actionOver.ρ
        GeometricV14Carrier.sigma).left = y ∧
      p.left ≫
          (fixedByι V14SchemeModel.actionOver
            GeometricV14Carrier.sigma).left =
        Spec.map (CommRingCat.ofHom (algebraMap k L)) ≫ y := by
  obtain ⟨j, x, a, hxj, hxpt, hPx, hplucker, ha, hbranch⟩ :=
    exists_normalizedCoordinates_v14FixedBy_concrete_plus_or_minus_carrier L p
  have hQval : ∀ q : Fin 15, D12Certificate.pluckerValue x q = 0 := by
    intro q
    rw [pluckerValue_eq_eval_map]
    exact hplucker q
  haveI : Mono V14SchemeModel.v14Schemeι := inferInstance
  rcases hbranch with ⟨u, hu, hxu, ha1⟩ | ⟨v, hv, hxv, ha1⟩
  · obtain ⟨x0, hx0j, hx0, hproj0, hQ0, hS0⟩ :=
      plus_branch_normalized_descends n e x u hu hxu hPx hQval j hxj
    let y := v14SchemePointOfNormalizedCoordinates j x0 hx0j hproj0 hQ0
    refine ⟨y, v14SchemePointOfNormalizedCoordinates_toSpec j x0 hx0j hproj0 hQ0,
      v14SchemePointOfNormalizedCoordinates_sigma_fixed
        j x0 hx0j hproj0 hQ0 1 one_ne_zero (by simpa using hS0), ?_⟩
    exact (cancel_mono V14SchemeModel.v14Schemeι).1
      (v14FixedFieldPoint_comp_ι_eq p j x x0 hx0j hproj0 hQ0 hxpt hx0)
  · obtain ⟨x0, hx0j, hx0, hproj0, hQ0, hS0⟩ :=
      minus_branch_normalized_descends n e x v hv hxv hPx hQval j hxj
    let y := v14SchemePointOfNormalizedCoordinates j x0 hx0j hproj0 hQ0
    refine ⟨y, v14SchemePointOfNormalizedCoordinates_toSpec j x0 hx0j hproj0 hQ0,
      v14SchemePointOfNormalizedCoordinates_sigma_fixed
        j x0 hx0j hproj0 hQ0 (-1) (neg_ne_zero.mpr one_ne_zero)
        (by simpa using hS0), ?_⟩
    exact (cancel_mono V14SchemeModel.v14Schemeι).1
      (v14FixedFieldPoint_comp_ι_eq p j x x0 hx0j hproj0 hQ0 hxpt hx0)

end V14Formalization.SchemeGeometry
