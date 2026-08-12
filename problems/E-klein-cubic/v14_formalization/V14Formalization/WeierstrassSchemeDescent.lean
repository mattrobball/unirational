/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.EllipticPolynomialConstancy
import V14Formalization.SchemeRationalConstancy
import V14Formalization.V14FieldPointReconstruction
import Mathlib.AlgebraicGeometry.EllipticCurve.Projective.Basic
import Mathlib.LinearAlgebra.Projectivization.Basic

/-!
# Descent of Weierstrass field-valued points

Bundled point-surjectivity for an affine Weierstrass equation is converted
here into an equality of scheme morphisms.  The construction is generic in
the field extension and is then specialized to pure transcendental fields in
any finite number of variables.

The affine scheme theorem is complemented by a homogeneous point theorem.
The latter treats the point at infinity directly and proves that every
field-valued point of a smooth short-Weierstrass cubic over a pure
transcendental extension descends projectively to the base field.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry Polynomial.Bivariate
open AlgebraicGeometry

namespace V14Formalization.WeierstrassSchemeDescent

open WeierstrassCurve EllipticPolynomialConstancy BConicBundleMultisections

universe u

variable {k K : Type u} [Field k] [Field K] [Algebra k K]
variable (W : WeierstrassCurve k)

noncomputable abbrev AffineScheme : Scheme :=
  Spec (.of W.toAffine.CoordinateRing)

noncomputable def AffineToBase : AffineScheme W ⟶ Spec (.of k) :=
  Spec.map (CommRingCat.ofHom (algebraMap k W.toAffine.CoordinateRing))

lemma preimage_comp_algebraMap {f : Spec (.of K) ⟶ AffineScheme W}
    (hf : f ≫ AffineToBase W =
      Spec.map (CommRingCat.ofHom (algebraMap k K))) :
    (Spec.preimage f).hom.comp (algebraMap k W.toAffine.CoordinateRing) =
      algebraMap k K := by
  have h := congrArg Spec.preimage hf
  have hc :
      CommRingCat.ofHom (algebraMap k W.toAffine.CoordinateRing) ≫
          Spec.preimage f =
        CommRingCat.ofHom (algebraMap k K) := by
    simpa only [Spec.preimage_comp, AffineToBase, Spec.preimage_map] using h
  exact congrArg CommRingCat.Hom.hom hc

noncomputable def xOfHom (f : Spec (.of K) ⟶ AffineScheme W) : K :=
  Spec.preimage f (AdjoinRoot.of W.toAffine.polynomial Polynomial.X)

noncomputable def yOfHom (f : Spec (.of K) ⟶ AffineScheme W) : K :=
  Spec.preimage f (AdjoinRoot.root W.toAffine.polynomial)

lemma preimage_comp_of_eq_eval₂RingHom
    {f : Spec (.of K) ⟶ AffineScheme W}
    (hf : f ≫ AffineToBase W =
      Spec.map (CommRingCat.ofHom (algebraMap k K))) :
    (Spec.preimage f).hom.comp (AdjoinRoot.of W.toAffine.polynomial) =
      Polynomial.eval₂RingHom (algebraMap k K) (xOfHom W f) := by
  apply Polynomial.ringHom_ext
  · intro a
    change Spec.preimage f
        (AdjoinRoot.of W.toAffine.polynomial (Polynomial.C a)) =
      Polynomial.eval₂ (algebraMap k K) (xOfHom W f) (Polynomial.C a)
    rw [Polynomial.eval₂_C]
    have ha := DFunLike.congr_fun
      (AdjoinRoot.algebraMap_eq' k W.toAffine.polynomial) a
    change algebraMap k W.toAffine.CoordinateRing a =
      AdjoinRoot.of W.toAffine.polynomial (Polynomial.C a) at ha
    rw [← ha]
    exact DFunLike.congr_fun (preimage_comp_algebraMap W hf) a
  · change Spec.preimage f
        (AdjoinRoot.of W.toAffine.polynomial Polynomial.X) =
      Polynomial.eval₂ (algebraMap k K) (xOfHom W f) Polynomial.X
    rw [Polynomial.eval₂_X]
    rfl

lemma equation_xOfHom_yOfHom
    {f : Spec (.of K) ⟶ AffineScheme W}
    (hf : f ≫ AffineToBase W =
      Spec.map (CommRingCat.ofHom (algebraMap k K))) :
    (W.toAffine.baseChange K).Equation (xOfHom W f) (yOfHom W f) := by
  have hr := congrArg (Spec.preimage f)
    (AdjoinRoot.eval₂_root W.toAffine.polynomial)
  rw [map_zero, Polynomial.hom_eval₂,
    preimage_comp_of_eq_eval₂RingHom W hf] at hr
  change (W.toAffine.map (algebraMap k K)).polynomial.evalEval
      (xOfHom W f) (yOfHom W f) = 0
  rw [WeierstrassCurve.Affine.map_polynomial]
  simpa only [Polynomial.eval₂_eval₂RingHom_apply, yOfHom] using hr

lemma eval₂_polynomial_eq_evalEval (x y : k) :
    W.toAffine.polynomial.eval₂ (Polynomial.evalRingHom x) y =
      W.toAffine.polynomial.evalEval x y := by
  simpa only [Polynomial.evalRingHom, Polynomial.mapRingHom_id,
    Polynomial.map_id] using
    (Polynomial.eval₂_eval₂RingHom_apply (RingHom.id k) x y
      W.toAffine.polynomial)

noncomputable def ringHomOfPoint {x y : k}
    (h : W.toAffine.Equation x y) :
    W.toAffine.CoordinateRing →+* k :=
  AdjoinRoot.lift (Polynomial.evalRingHom x) y <| by
    rw [eval₂_polynomial_eq_evalEval, ← WeierstrassCurve.Affine.Equation]
    exact h

@[simp] lemma ringHomOfPoint_root {x y : k}
    (h : W.toAffine.Equation x y) :
    ringHomOfPoint W h (AdjoinRoot.root W.toAffine.polynomial) = y := by
  apply AdjoinRoot.lift_root

@[simp] lemma ringHomOfPoint_of {x y : k}
    (h : W.toAffine.Equation x y) (p : Polynomial k) :
    ringHomOfPoint W h (AdjoinRoot.of W.toAffine.polynomial p) = p.eval x := by
  apply AdjoinRoot.lift_of

@[simp] lemma ringHomOfPoint_algebraMap {x y : k}
    (h : W.toAffine.Equation x y) (a : k) :
    ringHomOfPoint W h (algebraMap k W.toAffine.CoordinateRing a) = a := by
  have ha := DFunLike.congr_fun
    (AdjoinRoot.algebraMap_eq' k W.toAffine.polynomial) a
  change algebraMap k W.toAffine.CoordinateRing a =
    AdjoinRoot.of W.toAffine.polynomial (Polynomial.C a) at ha
  rw [ha, ringHomOfPoint_of, Polynomial.eval_C]

/-- Surjectivity on bundled Weierstrass points turns every over-base affine
scheme point over `K` into the scalar extension of a point over `k`. -/
theorem affine_morphism_descends_of_point_baseChange_surjective
    [DecidableEq k] [DecidableEq K] [W.IsElliptic]
    (hsurj : Function.Surjective
      (WeierstrassCurve.Affine.Point.baseChange
        (W' := W.toAffine) k K))
    (f : Spec (.of K) ⟶ AffineScheme W)
    (hf : f ≫ AffineToBase W =
      Spec.map (CommRingCat.ofHom (algebraMap k K))) :
    ∃ g : Spec (.of k) ⟶ AffineScheme W,
      g ≫ AffineToBase W = 𝟙 _ ∧
      f = Spec.map (CommRingCat.ofHom (algebraMap k K)) ≫ g := by
  letI : (W.toAffine.baseChange k).IsElliptic :=
    WeierstrassCurve.instIsEllipticMap W.toAffine (algebraMap k k)
  letI : (W.toAffine.baseChange K).IsElliptic :=
    WeierstrassCurve.instIsEllipticMap W.toAffine (algebraMap k K)
  let Q : (W.toAffine.baseChange K).Point :=
    WeierstrassCurve.Affine.Point.mk (equation_xOfHom_yOfHom W hf)
  obtain ⟨P, hP⟩ := hsurj Q
  rcases P with _ | ⟨x, y, hxy⟩
  · change (0 : (W.toAffine.baseChange K).Point) = Q at hP
    have hQ : Q ≠ 0 := by
      simpa only [Q, WeierstrassCurve.Affine.Point.mk] using
        (WeierstrassCurve.Affine.Point.some_ne_zero
          (WeierstrassCurve.Affine.equation_iff_nonsingular.mp
            (equation_xOfHom_yOfHom W hf)))
    exact False.elim (hQ hP.symm)
  · have hcoords :
        algebraMap k K x = xOfHom W f ∧
          algebraMap k K y = yOfHom W f := by
      change WeierstrassCurve.Affine.Point.map
        (W' := W.toAffine) (Algebra.ofId k K)
          (WeierstrassCurve.Affine.Point.some x y hxy) = Q at hP
      rw [WeierstrassCurve.Affine.Point.map_some] at hP
      simpa only [Q, WeierstrassCurve.Affine.Point.mk,
        WeierstrassCurve.Affine.Point.some.injEq,
        Algebra.ofId_apply] using hP
    have hxy0 : (W.toAffine.baseChange k).Equation x y :=
      WeierstrassCurve.Affine.equation_iff_nonsingular.mpr hxy
    have hxyW : W.toAffine.Equation x y := by
      simpa [WeierstrassCurve.baseChange, WeierstrassCurve.map] using hxy0
    let gr : W.toAffine.CoordinateRing →+* k := ringHomOfPoint W hxyW
    let g : Spec (.of k) ⟶ AffineScheme W :=
      Spec.map (CommRingCat.ofHom gr)
    refine ⟨g, ?_, ?_⟩
    · dsimp only [g, AffineToBase]
      rw [← Spec.map_comp, Spec.map_eq_id]
      apply CommRingCat.hom_ext
      ext a
      change gr (algebraMap k W.toAffine.CoordinateRing a) = a
      dsimp only [gr]
      exact ringHomOfPoint_algebraMap W hxyW a
    · rw [← Spec.map_preimage f, ← Spec.map_comp, Spec.map_inj]
      apply CommRingCat.hom_ext
      apply AdjoinRoot.ringHom_ext
      · apply Polynomial.ringHom_ext
        · intro a
          have hbase := DFunLike.congr_fun
            (preimage_comp_algebraMap W hf) a
          have ha := DFunLike.congr_fun
            (AdjoinRoot.algebraMap_eq' k W.toAffine.polynomial) a
          change algebraMap k W.toAffine.CoordinateRing a =
            AdjoinRoot.of W.toAffine.polynomial (Polynomial.C a) at ha
          simpa only [g, gr, CommRingCat.hom_comp, CommRingCat.hom_ofHom,
            RingHom.comp_apply, ringHomOfPoint_algebraMap, ← ha] using hbase
        · simp only [CommRingCat.hom_comp, CommRingCat.hom_ofHom,
            RingHom.comp_apply]
          dsimp only [gr]
          rw [ringHomOfPoint_of, Polynomial.eval_X]
          simpa only [xOfHom] using hcoords.1.symm
      · simp only [CommRingCat.hom_comp, CommRingCat.hom_ofHom,
          RingHom.comp_apply]
        dsimp only [gr]
        rw [ringHomOfPoint_root]
        simpa only [yOfHom] using hcoords.2.symm

/-- If affine Weierstrass points descend along `k → K`, then every nonzero
homogeneous triple on the projective Weierstrass cubic is a nonzero scalar
multiple of a triple over `k`.  The `z = 0` branch is the unique point at
infinity; the `z ≠ 0` branch is the affine descent hypothesis. -/
theorem projective_weierstrass_triple_descends_of_pointBaseChange_surjective
    {k K : Type u} [Field k] [Field K] [Algebra k K]
    [DecidableEq k] [DecidableEq K]
    (W : WeierstrassCurve k) [W.IsElliptic]
    (hsurj : Function.Surjective
      (WeierstrassCurve.Affine.Point.baseChange
        (W' := W.toAffine) k K))
    (p : Fin 3 → K) (hp0 : p ≠ 0)
    (hp : (W.baseChange K).toProjective.Equation p) :
    ∃ q : Fin 3 → k, q ≠ 0 ∧
      ∃ c : K, c ≠ 0 ∧
        ∀ i, p i = c * algebraMap k K (q i) := by
  letI : (W.toAffine.baseChange k).IsElliptic :=
    WeierstrassCurve.instIsEllipticMap W.toAffine (algebraMap k k)
  letI : (W.toAffine.baseChange K).IsElliptic :=
    WeierstrassCurve.instIsEllipticMap W.toAffine (algebraMap k K)
  by_cases hz : p 2 = 0
  · have hp' :=
      (WeierstrassCurve.Projective.equation_iff p).mp hp
    simp only [hz, mul_zero, zero_pow (by decide : (3 : ℕ) ≠ 0),
      zero_pow (by decide : (2 : ℕ) ≠ 0), add_zero, sub_eq_zero] at hp'
    have hx : p 0 = 0 :=
      (pow_eq_zero_iff (by decide : (3 : ℕ) ≠ 0)).mp hp'.symm
    have hy : p 1 ≠ 0 := by
      intro hy
      apply hp0
      funext i
      fin_cases i <;> assumption
    let q : Fin 3 → k := ![0, 1, 0]
    refine ⟨q, ?_, p 1, hy, ?_⟩
    · intro hq
      have := congrFun hq (1 : Fin 3)
      simp [q] at this
    · intro i
      fin_cases i
      · simp [q, hx]
      · simp [q]
      · simp [q, hz]
  · have heq : (W.toAffine.baseChange K).Equation
        (p 0 / p 2) (p 1 / p 2) := by
      rw [WeierstrassCurve.Affine.Equation,
        ← WeierstrassCurve.Projective.eval_polynomial_of_Z_ne_zero hz]
      rw [show MvPolynomial.eval p (W.baseChange K).toProjective.polynomial = 0
        from hp]
      simp
    let Q : (W.toAffine.baseChange K).Point :=
      WeierstrassCurve.Affine.Point.mk heq
    obtain ⟨P, hP⟩ := hsurj Q
    rcases P with _ | ⟨x, y, hxy⟩
    · change (0 : (W.toAffine.baseChange K).Point) = Q at hP
      have hQ : Q ≠ 0 := by
        simpa only [Q, WeierstrassCurve.Affine.Point.mk] using
          (WeierstrassCurve.Affine.Point.some_ne_zero
            (WeierstrassCurve.Affine.equation_iff_nonsingular.mp heq))
      exact False.elim (hQ hP.symm)
    · have hcoords :
          algebraMap k K x = p 0 / p 2 ∧
            algebraMap k K y = p 1 / p 2 := by
        change WeierstrassCurve.Affine.Point.map
          (W' := W.toAffine) (Algebra.ofId k K)
            (WeierstrassCurve.Affine.Point.some x y hxy) = Q at hP
        rw [WeierstrassCurve.Affine.Point.map_some] at hP
        simpa only [Q, WeierstrassCurve.Affine.Point.mk,
          WeierstrassCurve.Affine.Point.some.injEq,
          Algebra.ofId_apply] using hP
      let q : Fin 3 → k := ![x, y, 1]
      refine ⟨q, ?_, p 2, hz, ?_⟩
      · intro hq
        have := congrFun hq (2 : Fin 3)
        simp [q] at this
      · intro i
        fin_cases i
        · have hx := (div_eq_iff hz).mp hcoords.1.symm
          simpa [q, mul_comm] using hx
        · have hy := (div_eq_iff hz).mp hcoords.2.symm
          simpa [q, mul_comm] using hy
        · simp [q]

/-- Projective-space form of
`projective_weierstrass_triple_descends_of_pointBaseChange_surjective`. -/
theorem projectivization_weierstrass_descends_of_pointBaseChange_surjective
    {k K : Type u} [Field k] [Field K] [Algebra k K]
    [DecidableEq k] [DecidableEq K]
    (W : WeierstrassCurve k) [W.IsElliptic]
    (hsurj : Function.Surjective
      (WeierstrassCurve.Affine.Point.baseChange
        (W' := W.toAffine) k K))
    (p : Fin 3 → K) (hp0 : p ≠ 0)
    (hp : (W.baseChange K).toProjective.Equation p) :
    ∃ (q : Fin 3 → k) (_hq : q ≠ 0),
      ∃ hqK : (fun i ↦ algebraMap k K (q i)) ≠ 0,
        Projectivization.mk K p hp0 =
          Projectivization.mk K (fun i ↦ algebraMap k K (q i)) hqK := by
  obtain ⟨q, hq, c, hc, hscale⟩ :=
    projective_weierstrass_triple_descends_of_pointBaseChange_surjective
      W hsurj p hp0 hp
  have hqK : (fun i ↦ algebraMap k K (q i)) ≠ 0 := by
    intro h
    apply hq
    funext i
    apply (algebraMap k K).injective
    have hi := congrFun h i
    simpa using hi
  refine ⟨q, hq, hqK, ?_⟩
  apply (Projectivization.mk_eq_mk_iff' K _ _ hp0 hqK).mpr
  refine ⟨c, ?_⟩
  funext i
  simpa [Pi.smul_apply, smul_eq_mul] using (hscale i).symm

/-- Homogeneous short-Weierstrass points over a pure transcendental field
descend to the algebraically closed base, in coordinates. -/
theorem projective_weierstrass_triple_descends_mvfrac
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    [DecidableEq k] (n : ℕ) [DecidableEq (MvFrac k n)]
    (W : WeierstrassCurve k) [W.IsShortNF] [W.IsElliptic]
    (p : Fin 3 → MvFrac k n) (hp0 : p ≠ 0)
    (hp : (W.baseChange (MvFrac k n)).toProjective.Equation p) :
    ∃ q : Fin 3 → k, q ≠ 0 ∧
      ∃ c : MvFrac k n, c ≠ 0 ∧
        ∀ i, p i = c * algebraMap k (MvFrac k n) (q i) := by
  exact projective_weierstrass_triple_descends_of_pointBaseChange_surjective W
    (short_weierstrass_point_baseChange_mvfrac_surjective n W) p hp0 hp

/-- Homogeneous short-Weierstrass points over a pure transcendental field
descend as literal points of projective space. -/
theorem projectivization_weierstrass_descends_mvfrac
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    [DecidableEq k] (n : ℕ) [DecidableEq (MvFrac k n)]
    (W : WeierstrassCurve k) [W.IsShortNF] [W.IsElliptic]
    (p : Fin 3 → MvFrac k n) (hp0 : p ≠ 0)
    (hp : (W.baseChange (MvFrac k n)).toProjective.Equation p) :
    ∃ (q : Fin 3 → k) (_hq : q ≠ 0),
      ∃ hqK : (fun i ↦ algebraMap k (MvFrac k n) (q i)) ≠ 0,
        Projectivization.mk (MvFrac k n) p hp0 =
          Projectivization.mk (MvFrac k n)
            (fun i ↦ algebraMap k (MvFrac k n) (q i)) hqK := by
  exact projectivization_weierstrass_descends_of_pointBaseChange_surjective W
    (short_weierstrass_point_baseChange_mvfrac_surjective n W) p hp0 hp

/-- Dimension-generic pure-transcendental specialization of the affine
scheme bridge. -/
theorem affine_morphism_descends_mvfrac
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    [DecidableEq k] (n : ℕ) [DecidableEq (MvFrac k n)]
    (W : WeierstrassCurve k) [W.IsShortNF] [W.IsElliptic]
    (f : Spec (.of (MvFrac k n)) ⟶ AffineScheme W)
    (hf : f ≫ AffineToBase W =
      Spec.map (CommRingCat.ofHom (algebraMap k (MvFrac k n)))) :
    ∃ g : Spec (.of k) ⟶ AffineScheme W,
      g ≫ AffineToBase W = 𝟙 _ ∧
      f = Spec.map (CommRingCat.ofHom (algebraMap k (MvFrac k n))) ≫ g := by
  exact affine_morphism_descends_of_point_baseChange_surjective W
    (short_weierstrass_point_baseChange_mvfrac_surjective n W) f hf

/-- A base-field normalized projective point, after scalar extension on the source,
is the algebra-valued normalized point obtained by mapping its coordinates. -/
theorem specMap_comp_pointOfNormalizedCoordinates
    {R S : Type u} [Field R] [Field S] [Algebra R S]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → R)
    (hxi : x i = 1) :
    Spec.map (CommRingCat.ofHom (algebraMap R S)) ≫
        ProjectiveSpace.pointOfNormalizedCoordinates n R i x hxi =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) n i
        (fun l ↦ algebraMap R S (x l)) := by
  unfold ProjectiveSpace.pointOfNormalizedCoordinates
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
  rw [← Category.assoc, ← Spec.map_comp]
  congr 1
  apply Spec.map_inj.mpr
  apply CommRingCat.hom_ext
  ext r
  simp only [CommRingCat.hom_comp, CommRingCat.hom_ofHom,
    ProjectiveSpace.standardChartEval,
    ProjectiveSpace.standardChartEvalAlgebra, RingHom.comp_apply]
  change algebraMap R S
      (MvPolynomial.eval (ProjectiveSpace.affineCoordinates i x)
        ((ProjectiveSpace.standardChartRingEquivMvPolynomial n R i) r)) =
    MvPolynomial.aeval
      (ProjectiveSpace.affineCoordinates i
        (fun l ↦ algebraMap R S (x l)))
      ((ProjectiveSpace.standardChartRingEquivMvPolynomial n R i) r)
  rw [MvPolynomial.aeval_def, ← MvPolynomial.eval₂_id]
  convert
    (MvPolynomial.hom_eval₂
      ((ProjectiveSpace.standardChartRingEquivMvPolynomial n R i) r)
      (RingHom.id R) (algebraMap R S)
      (ProjectiveSpace.affineCoordinates i x)) using 1
  rfl

/-- If normalized coordinates reconstructing a pure-transcendental field point
of `P²` satisfy the short Weierstrass equation, the corresponding scheme
morphism descends to the base field. -/
theorem projectiveSpace_morphism_descends_weierstrass_mvfrac_of_coordinates
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    [DecidableEq k] (n : ℕ) [DecidableEq (MvFrac k n)]
    (W : WeierstrassCurve k) [W.IsShortNF] [W.IsElliptic]
    (f : Spec (.of (MvFrac k n)) ⟶ ProjectiveSpace 2 k)
    (_hfbase : f ≫ ProjectiveSpace.toSpec 2 k =
      Spec.map (CommRingCat.ofHom (algebraMap k (MvFrac k n))))
    (j : Fin 3) (p : Fin 3 → MvFrac k n)
    (hpj : p j = 1)
    (hfcoord : f =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 2 j p)
    (hp : (W.baseChange (MvFrac k n)).toProjective.Equation p) :
    ∃ y : Spec (.of k) ⟶ ProjectiveSpace 2 k,
      y ≫ ProjectiveSpace.toSpec 2 k = 𝟙 _ ∧
      f = Spec.map (CommRingCat.ofHom
        (algebraMap k (MvFrac k n))) ≫ y := by
  have hp0 : p ≠ 0 := by
    intro h
    have := congrFun h j
    simp [hpj] at this
  obtain ⟨q, _hq, c, _hc, hscale⟩ :=
    projective_weierstrass_triple_descends_mvfrac k n W p hp0 hp
  have hqj : q j ≠ 0 := by
    intro h
    have hj := hscale j
    rw [hpj, h, map_zero, mul_zero] at hj
    exact one_ne_zero hj
  let r : Fin 3 → k := fun i ↦ q i / q j
  have hrj : r j = 1 := by simp [r, hqj]
  have haqj : algebraMap k (MvFrac k n) (q j) ≠ 0 :=
    by simpa using (algebraMap k (MvFrac k n)).injective.ne hqj
  have hcqj : c * algebraMap k (MvFrac k n) (q j) = 1 := by
    rw [← hscale j, hpj]
  have hpr : p = fun i ↦ algebraMap k (MvFrac k n) (r i) := by
    funext i
    rw [hscale i]
    change c * algebraMap k (MvFrac k n) (q i) =
      algebraMap k (MvFrac k n) (q i / q j)
    rw [map_div₀]
    calc
      c * algebraMap k (MvFrac k n) (q i) =
          (c * algebraMap k (MvFrac k n) (q j)) *
            (algebraMap k (MvFrac k n) (q i) /
              algebraMap k (MvFrac k n) (q j)) := by
                field_simp
      _ = algebraMap k (MvFrac k n) (q i) /
            algebraMap k (MvFrac k n) (q j) := by rw [hcqj, one_mul]
  let y : Spec (.of k) ⟶ ProjectiveSpace 2 k :=
    ProjectiveSpace.pointOfNormalizedCoordinates 2 k j r hrj
  refine ⟨y, ProjectiveSpace.pointOfNormalizedCoordinates_toSpec
    2 k j r hrj, ?_⟩
  calc
    f = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
        (R := k) 2 j p := hfcoord
    _ = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
        (R := k) 2 j (fun i ↦ algebraMap k (MvFrac k n) (r i)) := by
          rw [hpr]
    _ = Spec.map (CommRingCat.ofHom
          (algebraMap k (MvFrac k n))) ≫ y := by
          exact (specMap_comp_pointOfNormalizedCoordinates
            2 j r hrj).symm

/-- Reconstruction-API wrapper: it suffices to verify the Weierstrass equation
for the normalized triple returned from any chart reconstruction of `f`. -/
theorem projectiveSpace_morphism_descends_weierstrass_mvfrac
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    [DecidableEq k] (n : ℕ) [DecidableEq (MvFrac k n)]
    (W : WeierstrassCurve k) [W.IsShortNF] [W.IsElliptic]
    (f : Spec (.of (MvFrac k n)) ⟶ ProjectiveSpace 2 k)
    (hfbase : f ≫ ProjectiveSpace.toSpec 2 k =
      Spec.map (CommRingCat.ofHom (algebraMap k (MvFrac k n))))
    (hEq : ∀ (j : Fin 3) (p : Fin 3 → MvFrac k n),
      p j = 1 →
      f = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
        (R := k) 2 j p →
      (W.baseChange (MvFrac k n)).toProjective.Equation p) :
    ∃ y : Spec (.of k) ⟶ ProjectiveSpace 2 k,
      y ≫ ProjectiveSpace.toSpec 2 k = 𝟙 _ ∧
      f = Spec.map (CommRingCat.ofHom
        (algebraMap k (MvFrac k n))) ≫ y := by
  obtain ⟨j, p, hpj, hfcoord⟩ :=
    V14Formalization.SchemeGeometry.exists_normalizedResidueCoordinates_for_fieldPoint
      2 f hfbase
  exact projectiveSpace_morphism_descends_weierstrass_mvfrac_of_coordinates
    k n W f hfbase j p hpj hfcoord (hEq j p hpj hfcoord)

end V14Formalization.WeierstrassSchemeDescent
