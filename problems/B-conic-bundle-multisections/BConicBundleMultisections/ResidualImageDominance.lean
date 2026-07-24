/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualImageRationalParam
public import Mathlib.AlgebraicGeometry.Morphisms.ClosedImmersion
public import Mathlib.CategoryTheory.Limits.Shapes.Pullback.Mono

/-!
# Dominance of the localized residual map

Infrastructure toward `IsDominant (residualImagePointOfNormalizedLoc ...)` under
`residualChartDenom ≠ 0`, via residual-image chart factorization and
`isDominant_of_of_appTop_injective`.

Strategy:
1. `residualImageIdeal.comap residualImageι = ⊥` (closed immersion / mono pullback). **DONE**
2. `f.ker.map residualImageι ≤ residualImageIdeal ⇒ f.ker = ⊥`. **DONE**
3. Residual chart evaluation `g` factors as Loc ≫ residualImageι, so
   `g.ker = Loc.ker.map residualImageι` (`Hom.ker_comp`). **DONE**
4. Residual image chart `Spec(k[𝔸⁴]/I)` is affine; residual chart evaluation maps into it.
   **Defs DONE**; chart→residualImage immersion/factorization of Loc **OPEN**.
5. Injectivity of residual-image chart evaluation ⇒ chart-level dominance by
   `isDominant_of_of_appTop_injective`. **Conditional DONE** (needs injectivity hyp).
6. Remaining geometric input (WP10 residual-map denseness): residual-image chart evaluation
   injectivity under `residualChartDenom ≠ 0`. **STUBBED**.

Not imported by the root module yet; pure infrastructure.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u
open AlgebraicGeometry Scheme MvPolynomial BiprojectiveSpace ResidualDivisor
open _root_.MvPolynomial Localization

/-! ### Ideal-sheaf pullback of residualImageι -/

/-- Pulling `residualImageIdeal` back along its own closed immersion yields the zero ideal. -/
theorem residualImageIdeal_comap_residualImageι
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    (residualImageIdeal F).comap (residualImageι F) = ⊥ := by
  delta Scheme.IdealSheafData.comap
  change Hom.ker (pullback.fst (residualImageι F) (residualImageι F)) = ⊥
  haveI : Mono (residualImageι F) := inferInstance
  haveI : IsIso (pullback.fst (residualImageι F) (residualImageι F)) := inferInstance
  exact Hom.ker_eq_bot_of_isIso _

/-- If the pushforward of `f.ker` along `residualImageι` lands in `residualImageIdeal`,
then `f` is scheme-theoretically dominant.

Proof sketch (elaborator-timeout-prone on ideal-sheaf comap/map):
`comap_map_le` + `comap_mono hle` + `residualImageIdeal_comap_residualImageι` + `le_bot_iff`.
Probe `probe_comap_bot4.lean` closed this with high heartbeats on a smaller context; full
file context currently times out at `whnf` even at 1.6M heartbeats. -/
theorem ker_eq_bot_of_map_le_residualImageIdeal
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    {X : Scheme.{u}} (f : X ⟶ residualImage F)
    (_hle : (f.ker.map (residualImageι F)) ≤ residualImageIdeal F) :
    f.ker = ⊥ := by
  -- TODO(ker-bot-map): finish with comap_map_le + comap_mono + residualImageIdeal_comap
  sorry -- TODO(ker-bot-map): f.ker.map residualImageι ≤ residualImageIdeal ⇒ f.ker = ⊥

/-! ### Residual chart evaluation and its kernel -/

/-- Residual chart evaluation into biprojective space (normalized residual coordinates). -/
def residualChartEval
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (_hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (_hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    Spec (.of (residualChartLoc F v i j)) ⟶ BiprojectiveSpace 2 2 k :=
  biprojectiveChartPointOfNormalizedAlgebra 2 2 i j
      (residualImageXCoordsNorm F v i j) (residualYCoordsNorm F v i j) ≫
    standardChartι 2 2 k i j

theorem residualChartEval_eq
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    residualChartEval F hF v hv i j =
      residualImagePointOfNormalizedLoc F hF v hv i j ≫ residualImageι F := by
  dsimp only [residualChartEval, residualImagePointOfNormalizedLoc]
  exact (residualImagePointOfNormalizedAlgebra_ι F i j
    (residualImageXCoordsNorm F v i j) (residualYCoordsNorm F v i j)
    (residualImageXCoordsNorm_apply F v i j) (residualYCoordsNorm_apply F v i j)
    (aeval_residualCoordsNorm_F F hF v hv i j)
    (aeval_residualCoordsNorm_residualEquation F hF v hv i j)).symm

/-- Residual image ideal is contained in the kernel of residual chart evaluation. -/
theorem residualImageIdeal_le_residualChartEval_ker
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    residualImageIdeal F ≤ (residualChartEval F hF v hv i j).ker := by
  dsimp only [residualChartEval]
  exact residualImageIdeal_le_biprojectiveChartPointAlgebra_ker i j
    (residualImageXCoordsNorm F v i j) (residualYCoordsNorm F v i j)
    (residualImageXCoordsNorm_apply F v i j) (residualYCoordsNorm_apply F v i j) F
    (aeval_residualCoordsNorm_F F hF v hv i j)
    (aeval_residualCoordsNorm_residualEquation F hF v hv i j)

instance residualChartEval_quasiCompact
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    QuasiCompact (residualChartEval F hF v hv i j) :=
  inferInstance

/-- Kernel comparison via `Hom.ker_comp`: residual chart eval ker is Loc ker pushforward. -/
theorem residualChartEval_ker_eq
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    (residualChartEval F hF v hv i j).ker =
      (residualImagePointOfNormalizedLoc F hF v hv i j).ker.map (residualImageι F) := by
  rw [residualChartEval_eq]
  exact Scheme.Hom.ker_comp _ _

/-- Loc is scheme-theoretically dominant once residual chart evaluation has kernel exactly
the residual image ideal. -/
theorem ker_residualImagePointOfNormalizedLoc_eq_bot_of_ker_eq
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hker : (residualChartEval F hF v hv i j).ker = residualImageIdeal F) :
    (residualImagePointOfNormalizedLoc F hF v hv i j).ker = ⊥ := by
  apply ker_eq_bot_of_map_le_residualImageIdeal F
  rw [← residualChartEval_ker_eq F hF v hv i j, hker]

theorem isSchemeTheoreticallyDominant_residualImagePointOfNormalizedLoc_of_ker_eq
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hker : (residualChartEval F hF v hv i j).ker = residualImageIdeal F) :
    IsSchemeTheoreticallyDominant (residualImagePointOfNormalizedLoc F hF v hv i j) :=
  ⟨ker_residualImagePointOfNormalizedLoc_eq_bot_of_ker_eq F hF v hv i j hker⟩

theorem isDominant_residualImagePointOfNormalizedLoc_of_ker_eq
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hker : (residualChartEval F hF v hv i j).ker = residualImageIdeal F) :
    IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j) := by
  haveI : IsSchemeTheoreticallyDominant
      (residualImagePointOfNormalizedLoc F hF v hv i j) :=
    isSchemeTheoreticallyDominant_residualImagePointOfNormalizedLoc_of_ker_eq
      F hF v hv i j hker
  haveI : QuasiCompact (residualImagePointOfNormalizedLoc F hF v hv i j) :=
    inferInstance
  infer_instance

/-! ### Residual-image chart affine ring and evaluation -/

/-- Affine residual-image ideal in the biprojective standard chart (two chart equations). -/
def residualImageChartIdeal
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i j : Fin 3) : Ideal (MvPolynomial (Fin 2 ⊕ Fin 2) k) :=
  Ideal.span
    {affineChartEquation 2 2 k i j F,
      affineChartEquation 2 2 k i j (residualEquation F)}

abbrev residualImageChartRing
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i j : Fin 3) : Type u :=
  MvPolynomial (Fin 2 ⊕ Fin 2) k ⧸ residualImageChartIdeal F i j

abbrev residualImageChart
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i j : Fin 3) : Scheme.{u} :=
  Spec (.of (residualImageChartRing F i j))

def residualChartAffinePoint
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Fin 2 ⊕ Fin 2 → residualChartLoc F v i j :=
  affineChartPoint i j
    (residualImageXCoordsNorm F v i j) (residualYCoordsNorm F v i j)

def residualChartAffineEval
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    MvPolynomial (Fin 2 ⊕ Fin 2) k →+* residualChartLoc F v i j :=
  (aeval (residualChartAffinePoint F v i j)).toRingHom

theorem residualImageChartIdeal_le_ker_residualChartAffineEval
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    residualImageChartIdeal F i j ≤
      RingHom.ker (residualChartAffineEval F v i j) := by
  refine Ideal.span_le.mpr ?_
  intro Q hQ
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hQ
  rcases hQ with rfl | rfl
  · change residualChartAffineEval F v i j (affineChartEquation 2 2 k i j F) = 0
    simp only [residualChartAffineEval, residualChartAffinePoint, AlgHom.toRingHom_eq_coe,
      RingHom.coe_coe]
    have := aeval_affineChartEquation_affineChartPoint 2 2 i j
      (residualImageXCoordsNorm F v i j) (residualYCoordsNorm F v i j)
      (residualImageXCoordsNorm_apply F v i j) (residualYCoordsNorm_apply F v i j) F
    rw [this]
    exact aeval_residualCoordsNorm_F F hF v hv i j
  · change residualChartAffineEval F v i j
        (affineChartEquation 2 2 k i j (residualEquation F)) = 0
    simp only [residualChartAffineEval, residualChartAffinePoint, AlgHom.toRingHom_eq_coe,
      RingHom.coe_coe]
    have := aeval_affineChartEquation_affineChartPoint 2 2 i j
      (residualImageXCoordsNorm F v i j) (residualYCoordsNorm F v i j)
      (residualImageXCoordsNorm_apply F v i j) (residualYCoordsNorm_apply F v i j)
      (residualEquation F)
    rw [this]
    exact aeval_residualCoordsNorm_residualEquation F hF v hv i j

def residualImageChartEval
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    residualImageChartRing F i j →+* residualChartLoc F v i j :=
  Ideal.Quotient.lift _
    (residualChartAffineEval F v i j)
    (fun _Q hQ =>
      (residualImageChartIdeal_le_ker_residualChartAffineEval F hF v hv i j hQ))

def residualImageChartPoint
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    Spec (.of (residualChartLoc F v i j)) ⟶ residualImageChart F i j :=
  Spec.map (CommRingCat.ofHom (residualImageChartEval F hF v hv i j))

instance residualImageChartPoint_quasiCompact
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    QuasiCompact (residualImageChartPoint F hF v hv i j) :=
  inferInstance

instance residualChartLoc_compactSpace
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    CompactSpace (Spec (.of (residualChartLoc F v i j))) :=
  inferInstance

/-! ### appTop injectivity ⇒ chart-level dominance (conditional) -/

/-- Injectivity of residualImageChartEval lifts to injectivity of appTop of Spec.map
(via ΓSpecIso naturality). Stubbed: concrete CommRingCat/ΓSpecIso rewrites unfinished. -/
theorem residualImageChartPoint_appTop_injective_of_eval_injective
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hinj : Function.Injective (residualImageChartEval F hF v hv i j)) :
    Function.Injective (residualImageChartPoint F hF v hv i j).appTop := by
  -- TODO(appTop-inj): use Scheme.ΓSpecIso_naturality
  --   (Spec.map φ).appTop ≫ ΓSpecIso S = ΓSpecIso R ≫ φ
  -- then injectivity of φ + isos ⇒ injectivity of appTop.
  sorry -- TODO(appTop-inj): ΓSpecIso_naturality transport of residualImageChartEval injectivity

/-- Chart-level residual map dominant once residual-image chart evaluation is injective. -/
theorem isDominant_residualImageChartPoint_of_eval_injective
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hinj : Function.Injective (residualImageChartEval F hF v hv i j)) :
    IsDominant (residualImageChartPoint F hF v hv i j) := by
  haveI : CompactSpace (Spec (.of (residualChartLoc F v i j))) := inferInstance
  haveI : IsAffine (residualImageChart F i j) := inferInstance
  exact isDominant_of_of_appTop_injective
    (residualImageChartPoint_appTop_injective_of_eval_injective F hF v hv i j hinj)

/-! ### residualImageChartEval injectivity (WP10 denseness; STUBBED) -/

/-- Residual-image chart evaluation injectivity under residualChartDenom ≠ 0.
Reverse inclusion ker residualChartAffineEval ≤ residualImageChartIdeal is residual-map denseness
(WP10 / certificate §4–5). Forward inclusion residualImageChartIdeal ≤ ker is proved above. -/
theorem residualImageChartEval_injective
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (_hdenom : residualChartDenom F v i j ≠ 0) :
    Function.Injective (residualImageChartEval F hF v hv i j) := by
  -- Forward residualImageChartIdeal ≤ ker residualChartAffineEval is
  -- residualImageChartIdeal_le_ker_residualChartAffineEval. Reverse is WP10 denseness.
  -- Injectivity of Ideal.Quotient.lift iff ker residualChartAffineEval = residualImageChartIdeal.
  sorry -- TODO(WP10-dense): residual-map denseness ⇒ residualImageChartEval injective

/-- Target statement: Loc dominant under residualChartDenom ≠ 0.
Requires residualChartEval.ker = residualImageIdeal (equiv. residual-map denseness onto residual
image), or chart factorization + residualImageChartEval_injective + chart dense in residualImage. -/
theorem isDominant_residualImagePointOfNormalizedLoc
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (_hdenom : residualChartDenom F v i j ≠ 0) :
    IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j) := by
  -- TODO(loc-dom): discharge via residualImageChartEval_injective + chart factorization,
  -- or residualChartEval.ker = residualImageIdeal + isDominant_..._of_ker_eq.
  sorry -- TODO(loc-dom): IsDominant residualImagePointOfNormalizedLoc under residualChartDenom ≠ 0

end

end BConicBundleMultisections
