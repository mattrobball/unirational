/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14FixedFieldPointDescent

/-!
# Descent of a pure-transcendental V14 sigma-fixed field point, over any base field

`V14FixedFieldPointDescent` descends a `σ`-fixed point of the coordinate `V₁₄`
with values in a purely transcendental extension `L / k` to a `k`-point.  This
file does the same with `k = ℚ(ζ₁₁)` replaced by an arbitrary field `F` over
`ℚ(ζ₁₁)`: `L` is purely transcendental over `F`, and the descended point is an
`F`-point.

Nothing new is proved about the two carriers.  The plus and minus descents were
already available over an arbitrary base field
(`plusCarrier_commonPluckerZero_descends_mvfrac_base`,
`minusCarrier_commonPluckerZero_descends_mvfrac_overBase`); what changes here is
only the field the coordinates are normalized over.  The two branches are run
through one shared lemma, `branch_normalized_descends_over`, which takes the
carrier, its left inverse, its `σ`-eigenvalue and its descent as arguments.
-/

noncomputable section

open CategoryTheory Matrix MvPolynomial
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open GeometricV14Carrier Lambda2Coordinates
open EllipticPolynomialConstancy
open D12SigmaPlusDescent D12SigmaMinusDescent

/-! ## Generic helpers

The `k`-pinned versions of these live in `V14FixedFieldPointDescent`, where they
are module-private.  They are restated here over an arbitrary coefficient map.
-/

theorem pluckerValue_eq_eval_map_of_ringHom {K L : Type*} [Field K] [Field L]
    (φ : K →+* L) (x : Fin 15 → L) (q : Fin 15) :
    D12Certificate.pluckerValue x q =
      eval x (MvPolynomial.map φ (pluckerQuadric K q)) := by
  simp [D12Certificate.pluckerValue, pluckerQuadric, eval_mul,
    eval_sub, eval_add, eval_X]

theorem algEquiv_comp_algebraMap_gen
    {K L : Type*} [Field K] [Field L] [Algebra K L] {n : ℕ}
    (e : MvFrac K n ≃ₐ[K] L) :
    e.toRingHom.comp (algebraMap K (MvFrac K n)) = algebraMap K L :=
  RingHom.ext fun a => e.commutes a

theorem mulVec_map_algEquiv_gen
    {K L : Type*} [Field K] [Field L] [Algebra K L] {nvars rows cols : ℕ}
    (e : MvFrac K nvars ≃ₐ[K] L)
    (M : Matrix (Fin rows) (Fin cols) K)
    (v : Fin cols → MvFrac K nvars) :
    (M.map (algebraMap K L)).mulVec (fun i => e (v i)) =
      fun i => e ((M.map (algebraMap K (MvFrac K nvars))).mulVec v i) := by
  have hcomp := algEquiv_comp_algebraMap_gen (L := L) e
  have h := mulVec_comp_map (m := rows) (n := cols) e.toRingHom
      (algebraMap K (MvFrac K nvars)) M v
  rw [hcomp] at h
  exact h

/-! ## One branch of the descent -/

section Branch

open V14SchemeModel (k)

variable (F : Type) [Field F] [Algebra k F]

/-- **The descent of one `σ`-eigenbranch, over an arbitrary base field `F`.**

`B` is the ambient carrier of the branch, `a` its
`σ`-eigenvalue, and `hdesc` the branch's own Plücker descent over `F`.  The
conclusion normalizes at the coordinate `j`, so the descended vector is an
honest `F`-point of the same projective point. -/
theorem branch_normalized_descends_over
    {L : Type} [Field L] [Algebra k L] [Algebra F L] [IsScalarTower k F L]
    (n : ℕ) (e : MvFrac F n ≃ₐ[F] L)
    {m : ℕ} (B : Matrix (Fin 15) (Fin m) k)
    (a : k)
    (hSB : (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        GeometricV14Carrier.sigma : Matrix (Fin 15) (Fin 15) k) * B = a • B)
    (hdesc : ∀ w : Fin m → MvFrac F n, w ≠ 0 →
      (∀ q : Fin 15, D12Certificate.pluckerValue
        (((B.map (algebraMap k F)).map
          (algebraMap F (MvFrac F n))).mulVec w) q = 0) →
      ∃ (w0 : Fin m → F) (_hw0 : w0 ≠ 0) (c : MvFrac F n),
        c ≠ 0 ∧ w = c • fun i => algebraMap F (MvFrac F n) (w0 i))
    (x : Fin 15 → L) (u : Fin m → L) (hu : u ≠ 0)
    (hx : x = (B.map (algebraMap k L)).mulVec u)
    (hPx : (V14SchemeModel.projectorMatrix.map (algebraMap k L)).mulVec x = x)
    (hQ : ∀ q : Fin 15, D12Certificate.pluckerValue x q = 0)
    (j : Fin 15) (hxj : x j = 1) :
    ∃ x0 : Fin 15 → F,
      x0 j = 1 ∧
      x = (fun i => algebraMap F L (x0 i)) ∧
      (V14SchemeModel.projectorMatrix.map (algebraMap k F)).mulVec x0 = x0 ∧
      (∀ q : Fin 15, D12Certificate.pluckerValue x0 q = 0) ∧
      ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
          GeometricV14Carrier.sigma :
          Matrix (Fin 15) (Fin 15) k).map (algebraMap k F)).mulVec x0 =
        (algebraMap k F a) • x0 := by
  classical
  set BF : Matrix (Fin 15) (Fin m) F := B.map (algebraMap k F) with hBF
  -- the tower rewrites `.map (algebraMap k L)` into `.map` twice
  have htower : ∀ b : k, algebraMap k L b = algebraMap F L (algebraMap k F b) :=
    fun b => IsScalarTower.algebraMap_apply k F L b
  have hBL : B.map (algebraMap k L) = BF.map (algebraMap F L) := by
    ext i l
    simp [hBF, Matrix.map_apply, htower]
  set xM : Fin 15 → MvFrac F n := fun i => e.symm (x i) with hxMdef
  set uM : Fin m → MvFrac F n := fun i => e.symm (u i) with huMdef
  have huM : uM ≠ 0 := by
    intro h0
    apply hu
    funext i
    have hi : e.symm (u i) = 0 := congrFun h0 i
    simpa using (map_eq_zero_iff e.symm.toRingHom e.symm.injective).1 hi
  have hxM : xM = (BF.map (algebraMap F (MvFrac F n))).mulVec uM := by
    have hx' : x = fun i =>
        e ((BF.map (algebraMap F (MvFrac F n))).mulVec uM i) := by
      have hu' : u = fun i => e (uM i) := by
        funext i; simp [huMdef]
      rw [hx, hBL, hu']
      exact mulVec_map_algEquiv_gen (rows := 15) (cols := m) e BF uM
    funext i
    have hi := congrFun hx' i
    have hxe : e (xM i) =
        e ((BF.map (algebraMap F (MvFrac F n))).mulVec uM i) := by
      simpa [hxMdef] using hi
    exact e.injective hxe
  have hQM : ∀ q : Fin 15, D12Certificate.pluckerValue xM q = 0 := by
    intro q
    have h := pluckerValue_map e.symm.toRingHom x q
    simpa [hxMdef, hQ q] using h
  obtain ⟨u0, hu0, c, hc, hudesc⟩ := hdesc uM huM (by
    intro q
    simpa [hxM] using hQM q)
  set y0 : Fin 15 → F := BF.mulVec u0 with hy0def
  have hmapB :
      (BF.map (algebraMap F (MvFrac F n))).mulVec
          (fun i => algebraMap F (MvFrac F n) (u0 i)) =
        fun i => algebraMap F (MvFrac F n) (y0 i) := by
    funext i
    simp [hy0def, Matrix.mulVec, Matrix.map_apply, dotProduct, map_sum, map_mul]
  have hxMy0 : xM = c • fun i => algebraMap F (MvFrac F n) (y0 i) := by
    rw [hxM, hudesc, Matrix.mulVec_smul, hmapB]
  have hy0j : y0 j ≠ 0 := by
    intro h0
    have hxMj : xM j = 1 := by simp [hxMdef, hxj]
    have hcj := congrFun hxMy0 j
    rw [hxMj, Pi.smul_apply, smul_eq_mul, h0, map_zero, mul_zero] at hcj
    exact one_ne_zero hcj
  set x0 : Fin 15 → F := fun i => y0 i / y0 j with hx0def
  have hx0j : x0 j = 1 := by simp [hx0def, hy0j]
  have hxM' : xM = fun i => algebraMap F (MvFrac F n) (x0 i) := by
    have hcj : c * algebraMap F (MvFrac F n) (y0 j) = 1 := by
      have h := congrFun hxMy0 j
      simpa [hxMdef, hxj, Pi.smul_apply, smul_eq_mul] using h.symm
    funext i
    have hi := congrFun hxMy0 i
    rw [Pi.smul_apply, smul_eq_mul] at hi
    calc
      xM i = c * algebraMap F (MvFrac F n) (y0 i) := hi
      _ = (c * algebraMap F (MvFrac F n) (y0 j)) *
            (algebraMap F (MvFrac F n) (y0 i) /
              algebraMap F (MvFrac F n) (y0 j)) := by
            have hb0 : algebraMap F (MvFrac F n) (y0 j) ≠ 0 :=
              (map_ne_zero_iff (algebraMap F (MvFrac F n))
                (algebraMap F (MvFrac F n)).injective).2 hy0j
            field_simp
      _ = algebraMap F (MvFrac F n) (y0 i / y0 j) := by
            rw [hcj, one_mul, ← map_div₀]
      _ = algebraMap F (MvFrac F n) (x0 i) := rfl
  have hx0 : x = fun i => algebraMap F L (x0 i) := by
    funext i
    have hei : e (xM i) = x i := by simp [hxMdef]
    rw [← hei, congrFun hxM' i]
    exact e.commutes (x0 i)
  refine ⟨x0, hx0j, hx0, ?_, ?_, ?_⟩
  · -- the projector fixes the descended vector
    have hmap :
        (V14SchemeModel.projectorMatrix.map (algebraMap k L)).mulVec
            (fun i => algebraMap F L (x0 i)) =
          fun i => algebraMap F L
            ((V14SchemeModel.projectorMatrix.map
              (algebraMap k F)).mulVec x0 i) := by
      funext i
      simp [Matrix.mulVec, Matrix.map_apply, dotProduct, map_sum, map_mul,
        htower]
    have h := hPx
    rw [hx0, hmap] at h
    funext i
    exact (algebraMap F L).injective (congrFun h i)
  · -- the Plücker quadrics vanish on the descended vector
    intro q
    have hmap :
        D12Certificate.pluckerValue
            (fun i => algebraMap F (MvFrac F n) (x0 i)) q =
          algebraMap F (MvFrac F n) (D12Certificate.pluckerValue x0 q) :=
      pluckerValue_map (algebraMap F (MvFrac F n)) x0 q
    have h := hQM q
    rw [hxM', hmap] at h
    exact (map_eq_zero_iff (algebraMap F (MvFrac F n))
      (algebraMap F (MvFrac F n)).injective).1 h
  · -- the descended vector is still a `σ`-eigenvector
    set S : Matrix (Fin 15) (Fin 15) k :=
      (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        GeometricV14Carrier.sigma : Matrix (Fin 15) (Fin 15) k) with hSdef
    have hSBF : (S.map (algebraMap k F)) * BF = (algebraMap k F a) • BF := by
      rw [hBF, ← Matrix.map_mul, hSB]
      ext i l
      simp [Matrix.map_apply, Matrix.smul_apply]
    have hyS : (S.map (algebraMap k F)).mulVec y0 = (algebraMap k F a) • y0 := by
      rw [hy0def, Matrix.mulVec_mulVec, hSBF, Matrix.smul_mulVec]
    have hx0smul : x0 = (y0 j)⁻¹ • y0 := by
      funext i
      simp [hx0def, Pi.smul_apply, smul_eq_mul, div_eq_inv_mul]
    rw [hx0smul, Matrix.mulVec_smul, hyS, smul_comm]

/-! ## The descended point as an `F`-point of the coordinate `V₁₄` -/

/-- Normalized coordinates over `F` satisfying the projector and Plücker
equations determine a section `Spec F ⟶ v14Scheme` over `Spec k`.  This is
`v14SchemePointOfNormalizedCoordinates` with the coordinates allowed to live in
an extension of the base. -/
@[expose] public noncomputable def v14SchemePointOfNormalizedCoordinatesOver
    (j : Fin 15) (x : Fin 15 → F) (hxj : x j = 1)
    (hproj : (V14SchemeModel.projectorMatrix.map (algebraMap k F)).mulVec x = x)
    (hQ : ∀ q : Fin 15, MvPolynomial.eval x
      (MvPolynomial.map (algebraMap k F) (pluckerQuadric k q)) = 0) :
    Spec (.of F) ⟶ V14SchemeModel.v14Scheme :=
  pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily
    14 (grassmannianLinearSectionEquations k V14SchemeModel.projectorMatrix)
    V14SchemeModel.equationDegree V14SchemeModel.equations_isHomogeneous
    j x hxj (v14Equations_of_projector_and_plucker x hproj hQ)

public theorem v14SchemePointOfNormalizedCoordinatesOver_toSpec
    (j : Fin 15) (x : Fin 15 → F) (hxj : x j = 1)
    (hproj : (V14SchemeModel.projectorMatrix.map (algebraMap k F)).mulVec x = x)
    (hQ : ∀ q : Fin 15, MvPolynomial.eval x
      (MvPolynomial.map (algebraMap k F) (pluckerQuadric k q)) = 0) :
    v14SchemePointOfNormalizedCoordinatesOver F j x hxj hproj hQ ≫
        V14SchemeModel.actionOver.V.hom =
      Spec.map (CommRingCat.ofHom (algebraMap k F)) :=
  pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily_toSpec
    14 (grassmannianLinearSectionEquations k V14SchemeModel.projectorMatrix)
    V14SchemeModel.equationDegree V14SchemeModel.equations_isHomogeneous
    j x hxj (v14Equations_of_projector_and_plucker x hproj hQ)

public theorem v14SchemePointOfNormalizedCoordinatesOver_ι
    (j : Fin 15) (x : Fin 15 → F) (hxj : x j = 1)
    (hproj : (V14SchemeModel.projectorMatrix.map (algebraMap k F)).mulVec x = x)
    (hQ : ∀ q : Fin 15, MvPolynomial.eval x
      (MvPolynomial.map (algebraMap k F) (pluckerQuadric k q)) = 0) :
    v14SchemePointOfNormalizedCoordinatesOver F j x hxj hproj hQ ≫
        V14SchemeModel.v14Schemeι =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 14 j x :=
  pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily_ι
    14 (grassmannianLinearSectionEquations k V14SchemeModel.projectorMatrix)
    V14SchemeModel.equationDegree V14SchemeModel.equations_isHomogeneous
    j x hxj (v14Equations_of_projector_and_plucker x hproj hQ)

/-- A descended eigenvector for `λ²(σ)` is a `σ`-fixed `F`-point of `V₁₄`. -/
public theorem v14SchemePointOfNormalizedCoordinatesOver_sigma_fixed
    (j : Fin 15) (x : Fin 15 → F) (hxj : x j = 1)
    (hproj : (V14SchemeModel.projectorMatrix.map (algebraMap k F)).mulVec x = x)
    (hQ : ∀ q : Fin 15, MvPolynomial.eval x
      (MvPolynomial.map (algebraMap k F) (pluckerQuadric k q)) = 0)
    (a : F) (ha : a ≠ 0)
    (heig : ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        GeometricV14Carrier.sigma :
        Matrix (Fin 15) (Fin 15) k).map (algebraMap k F)).mulVec x = a • x) :
    v14SchemePointOfNormalizedCoordinatesOver F j x hxj hproj hQ ≫
        (V14SchemeModel.actionOver.ρ GeometricV14Carrier.sigma).left =
      v14SchemePointOfNormalizedCoordinatesOver F j x hxj hproj hQ := by
  haveI : Mono V14SchemeModel.v14Schemeι := inferInstance
  apply (cancel_mono V14SchemeModel.v14Schemeι).1
  have hsq := V14SchemeModel.actionOver_hom_v14Schemeι GeometricV14Carrier.sigma
  have hι := v14SchemePointOfNormalizedCoordinatesOver_ι F j x hxj hproj hQ
  set y := v14SchemePointOfNormalizedCoordinatesOver F j x hxj hproj hQ with hy
  calc
    (y ≫ (V14SchemeModel.actionOver.ρ GeometricV14Carrier.sigma).left) ≫
        V14SchemeModel.v14Schemeι =
        y ≫ ((V14SchemeModel.actionOver.ρ GeometricV14Carrier.sigma).left ≫
          V14SchemeModel.v14Schemeι) := Category.assoc _ _ _
    _ = y ≫ (V14SchemeModel.v14Schemeι ≫
          projectiveActionHom lambda2MatrixRepresentation.ρ
            GeometricV14Carrier.sigma) := congrArg (fun t => y ≫ t) hsq
    _ = (y ≫ V14SchemeModel.v14Schemeι) ≫
          projectiveActionHom lambda2MatrixRepresentation.ρ
            GeometricV14Carrier.sigma := (Category.assoc _ _ _).symm
    _ = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 14 j x ≫
          mapLinearSubst 14
            (lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma :
              Matrix (Fin 15) (Fin 15) k)
            ((lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma)⁻¹ :
              Matrix (Fin 15) (Fin 15) k)
            (by simp) := by rw [hι]; rfl
    _ = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 14 j x :=
        pointOfNormalizedCoordinates_fixed_of_mulVec_eq_smul 14
          (lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma :
            Matrix (Fin 15) (Fin 15) k)
          ((lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma)⁻¹ :
            Matrix (Fin 15) (Fin 15) k)
          (by simp) j x hxj a ha heig
    _ = y ≫ V14SchemeModel.v14Schemeι := hι.symm

/-! ## The descent -/

/-- An algebra-valued normalized projective point, after a further scalar
extension, is the normalized point obtained by mapping its coordinates.  The
`R = S` case is `specMap_comp_pointOfNormalizedCoordinates`. -/
public theorem specMap_comp_pointOfNormalizedCoordinatesAlgebra
    {R S T : Type u} [CommRing R] [CommRing S] [CommRing T]
    [Algebra R S] [Algebra R T] [Algebra S T] [IsScalarTower R S T]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S) :
    Spec.map (CommRingCat.ofHom (algebraMap S T)) ≫
        ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) n i x =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) n i
        (fun l => algebraMap S T (x l)) := by
  unfold ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
  rw [← Category.assoc, ← Spec.map_comp]
  congr 1
  apply Spec.map_inj.mpr
  apply CommRingCat.hom_ext
  ext r
  simp only [CommRingCat.hom_comp, CommRingCat.hom_ofHom,
    ProjectiveSpace.standardChartEvalAlgebra, RingHom.comp_apply]
  change algebraMap S T
      (MvPolynomial.aeval (ProjectiveSpace.affineCoordinates i x)
        ((ProjectiveSpace.standardChartRingEquivMvPolynomial n R i) r)) =
    MvPolynomial.aeval
      (ProjectiveSpace.affineCoordinates i (fun l => algebraMap S T (x l)))
      ((ProjectiveSpace.standardChartRingEquivMvPolynomial n R i) r)
  exact MvPolynomial.comp_aeval_apply
    (f := ProjectiveSpace.affineCoordinates i x)
    (IsScalarTower.toAlgHom R S T) _

/-- **A `σ`-fixed point of the coordinate `V₁₄` with values in a purely
transcendental extension of `F` descends to an `F`-point.**

This is `v14FixedFieldPoint_descends_of_mvfrac` with the base field `ℚ(ζ₁₁)`
replaced by an arbitrary field `F` over it. -/
public theorem v14FixedFieldPoint_descends_of_mvfrac_over
    (n : ℕ) (L : Type) [Field L] [Algebra k L] [Algebra F L]
    [IsScalarTower k F L] [NeZero (2 : L)]
    (e : MvFrac F n ≃ₐ[F] L)
    (p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma) :
    ∃ y : Spec (.of F) ⟶ V14SchemeModel.v14Scheme,
      y ≫ V14SchemeModel.actionOver.V.hom =
        Spec.map (CommRingCat.ofHom (algebraMap k F)) ∧
      y ≫ (V14SchemeModel.actionOver.ρ
        GeometricV14Carrier.sigma).left = y ∧
      p.left ≫
          (fixedByι V14SchemeModel.actionOver
            GeometricV14Carrier.sigma).left =
        Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫ y := by
  classical
  obtain ⟨j, x, a, hxj, hxpt, hPx, hplucker, _ha, hbranch⟩ :=
    exists_normalizedCoordinates_v14FixedBy_concrete_plus_or_minus_carrier L p
  have hQval : ∀ q : Fin 15, D12Certificate.pluckerValue x q = 0 := by
    intro q
    rw [pluckerValue_eq_eval_map_of_ringHom (algebraMap k L)]
    exact hplucker q
  haveI : Mono V14SchemeModel.v14Schemeι := inferInstance
  -- one branch, then the other; only the carrier data differ
  have main : ∀ (m : ℕ) (B : Matrix (Fin 15) (Fin m) k) (a0 : k) (ha0 : a0 ≠ 0),
      ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        GeometricV14Carrier.sigma : Matrix (Fin 15) (Fin 15) k) * B = a0 • B) →
      (∀ w : Fin m → MvFrac F n, w ≠ 0 →
        (∀ q : Fin 15, D12Certificate.pluckerValue
          (((B.map (algebraMap k F)).map
            (algebraMap F (MvFrac F n))).mulVec w) q = 0) →
        ∃ (w0 : Fin m → F) (_hw0 : w0 ≠ 0) (c : MvFrac F n),
          c ≠ 0 ∧ w = c • fun i => algebraMap F (MvFrac F n) (w0 i)) →
      ∀ u : Fin m → L, u ≠ 0 →
      x = (B.map (algebraMap k L)).mulVec u →
      ∃ y : Spec (.of F) ⟶ V14SchemeModel.v14Scheme,
        y ≫ V14SchemeModel.actionOver.V.hom =
          Spec.map (CommRingCat.ofHom (algebraMap k F)) ∧
        y ≫ (V14SchemeModel.actionOver.ρ
          GeometricV14Carrier.sigma).left = y ∧
        p.left ≫
            (fixedByι V14SchemeModel.actionOver
              GeometricV14Carrier.sigma).left =
          Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫ y := by
    intro m B a0 ha0 hSB hdesc u hu hx
    obtain ⟨x0, hx0j, hx0, hproj0, hQ0, hS0⟩ :=
      branch_normalized_descends_over F n e B a0 hSB hdesc x u hu hx hPx hQval j hxj
    have hQ0' : ∀ q : Fin 15, MvPolynomial.eval x0
        (MvPolynomial.map (algebraMap k F) (pluckerQuadric k q)) = 0 := by
      intro q
      rw [← pluckerValue_eq_eval_map_of_ringHom (algebraMap k F)]
      exact hQ0 q
    refine ⟨v14SchemePointOfNormalizedCoordinatesOver F j x0 hx0j hproj0 hQ0',
      v14SchemePointOfNormalizedCoordinatesOver_toSpec F j x0 hx0j hproj0 hQ0',
      v14SchemePointOfNormalizedCoordinatesOver_sigma_fixed F j x0 hx0j hproj0 hQ0'
        (algebraMap k F a0)
        ((map_ne_zero_iff (algebraMap k F)
          (algebraMap k F).injective).2 ha0) hS0, ?_⟩
    refine (cancel_mono V14SchemeModel.v14Schemeι).1 ?_
    have hι := v14SchemePointOfNormalizedCoordinatesOver_ι F j x0 hx0j hproj0 hQ0'
    calc
      (p.left ≫ (fixedByι V14SchemeModel.actionOver
            GeometricV14Carrier.sigma).left) ≫ V14SchemeModel.v14Schemeι
          = ambientPointOfV14FixedBy L p := rfl
      _ = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 14 j x :=
          hxpt
      _ = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 14 j
            (fun i => algebraMap F L (x0 i)) := by rw [hx0]
      _ = Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫
            ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 14 j x0 :=
          (specMap_comp_pointOfNormalizedCoordinatesAlgebra 14 j x0).symm
      _ = Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫
            (v14SchemePointOfNormalizedCoordinatesOver F j x0 hx0j hproj0 hQ0' ≫
              V14SchemeModel.v14Schemeι) := by rw [hι]
      _ = (Spec.map (CommRingCat.ofHom (algebraMap F L)) ≫
            v14SchemePointOfNormalizedCoordinatesOver F j x0 hx0j hproj0 hQ0') ≫
            V14SchemeModel.v14Schemeι := (Category.assoc _ _ _).symm
  rcases hbranch with ⟨u, hu, hxu, _⟩ | ⟨v, hv, hxv, _⟩
  · exact main 6 D12SigmaCarrierConcrete.core.Bplus 1 one_ne_zero
      (by simpa using D12SigmaCarrierConcrete.core.sigma_eigen_plus)
      (fun w hw hQ => plusCarrier_commonPluckerZero_descends_mvfrac_base F n w hw hQ)
      u hu hxu
  · exact main 4 D12SigmaCarrierConcrete.core.Bminus (-1)
      (by simp)
      (by simpa using D12SigmaCarrierConcrete.core.sigma_eigen_minus)
      (fun w hw hQ =>
        minusCarrier_commonPluckerZero_descends_mvfrac_overBase F n w hw hQ)
      v hv hxv

end Branch

end V14Formalization.SchemeGeometry
