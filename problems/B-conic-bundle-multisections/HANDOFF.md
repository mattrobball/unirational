# HANDOFF — B-conic-bundle-multisections

Cold-start document for the next implementer. Written 2026-07-24.
Git commit/push was blocked (`.git` not writable / `index.lock` Operation not permitted); all other land steps done.

**Working tree state (uncommitted):**
- Modified: `BConicBundleMultisections.lean`, `ResidualImageAlgebraPoint.lean`, `ResidualImageRationalParam.lean`, `SpecializedConicFreeDir.lean`
- Untracked: `ResidualImageDominance.lean`, `ResidualYCoordsPureT.lean`, this `HANDOFF.md`
- Last green root commit on disk history: `97000c8` (`Checkpoint: free-direction nonvanishing closed; main theorem still conditional`)

---

## 1. BUILD FACTS

### Toolchain
| Item | Pin |
|------|-----|
| Lean | `leanprover/lean4:v4.32.1` (`lean-toolchain`) |
| Mathlib | rev `v4.32.1` / commit `520045ab14e26149ee970e2e617ca04b09bde5d6` (`lake-manifest.json`) |
| Lake package | `BConicBundleMultisections` (`lakefile.toml`) |
| Default target | `BConicBundleMultisections` (root module) |

### Build commands
```bash
# Root (does NOT build ResidualImageDominance — not imported)
lake build

# Dominance infrastructure (has 4 sorries; builds alone)
lake build BConicBundleMultisections.ResidualImageDominance

# Pure-t residual Y (imported by root; green, no sorry)
lake build BConicBundleMultisections.ResidualYCoordsPureT

# Slow denseness file
lake build BConicBundleMultisections.SpecializedConicFreeDir
```

### Wall-clock (this machine, approximate)
| Build | Time | Notes |
|-------|------|-------|
| Full cold `lake build` | **~15–40+ min** when Mathlib/deps cold; after Mathlib oleans present, **~5–15 min** full project rebuild observed historically | 3058 jobs when green at handoff |
| Incremental root (only leaf modules dirty) | **~1–3 min** | e.g. ResidualYCoordsPureT replay ~seconds if deps warm |
| `SpecializedConicFreeDir.lean` alone (warm deps) | **~2–8 min** | **4208 lines**; treat as slow; do not casually reformat |
| `ResidualImageDominance.lean` alone (warm deps) | **~1–30 s** once RationalParam oleans warm; first build after RationalParam change **~30 s** | |
| `ResidualImageRationalParam.lean` | **~30–90 s** incremental | 1329 lines |
| `UniversalResidualIdentity.lean` | **very heavy** | `maxHeartbeats 8000000` |

Evidence at handoff: `lake build` exit 0 (3058 jobs). `lake build BConicBundleMultisections.ResidualImageDominance` exit 0 with 4 sorry warnings.

### `set_option maxHeartbeats` sites (and why)
| File:line | Value | Why |
|-----------|------:|-----|
| `UniversalResidualIdentity.lean:143` | 8_000_000 | Universal residual polynomial identity |
| `BiprojectiveZeroLocusClosedPoints.lean:193` | 800_000 | Closed-point / Nullstellensatz packaging |
| `PlaneCubicResidualVanishing.lean:30` | 800_000 | Plane cubic residual vanishing |
| `ResidualImageAlgebraPoint.lean:172` | 800_000 | Chart immersion comparison (`chartZeroLocusPoint…_subschemeι`) |
| `ResidualYCoordsPureT.lean:141,170,196,235,260` | 2_000_000 | IsDomain L-vanishing + pure-t residualY packages |
| `ResidualImageDominance.lean` | (removed after timeout) | `ker_eq_bot_of_map_le` still timed out at 1.6M; **stubbed** |

### Slow files (>60s expected if rechecked cold)
1. `SpecializedConicFreeDir.lean` (4208 lines) — denseness + freeDir singularity + residual X
2. `UniversalResidualIdentity.lean` — huge heartbeats
3. `ResidualImageRationalParam.lean` / `ResidualImageAffineParam.lean` — residual algebra packaging
4. `ResidualMultisectionDominant.lean` — Nullstellensatz residual multisection
5. WP2 pair: `BiprojectiveNoWholeFiber.lean`, `BiprojectiveProjectionDominant.lean` (green; reconfirmed)

### Sorry count
| Scope | Count | Location |
|-------|------:|----------|
| Root `lake build` cone | **0** | ResidualImageDominance **not** imported by root |
| `ResidualImageDominance.lean` alone | **4** | see §5 |
| `False.elim` elsewhere | 1 benign | `BiprojectiveAffineChartDegree.lean:49` (`False.elim (hs (coeff_zero s))` — real proof, not stub) |

---

## 2. STATUS TABLE

Cone of `smooth_bidegree23_hasUnirationalParametrization` (`MainTheorem.lean:285–292`) and residual-image path.

| Lean name | file:line | Currently assumes | To discharge | Confidence |
|-----------|-----------|-------------------|--------------|------------|
| `smooth_bidegree23_hasUnirationalParametrization` | `MainTheorem.lean:285` | `hXT : HasResidualBaseChangeUnirationalParametrization3 F` | Prove `hXT` from residual image has2 + pointed conic + bridge | Packaging OK; geometric inputs open |
| `HasResidualBaseChangeUnirationalParametrization3` | `ResidualBaseChangeUnirational.lean:173` | (definition) | from has2 + `IsResidualPointedConicRational` + bridge | High if inputs true |
| `HasResidualImageUnirationalParametrization2` | `ResidualBaseChangeUnirational.lean:168` | nonempty unirational param of residual image | residual X≠0, Y≠0, Loc dominant | Partial |
| `IsResidualPointedConicRational` | `ResidualBaseChangeUnirational.lean:160` | pointed conic over residual multisection | Prove pointed-conic rationality of `X_T` | Medium–high classically; **not started** as theorem |
| `hasResidualImageUnirationalParametrization2_of_smooth_L_branch_pureT` | `ResidualYCoordsPureT.lean:288` | `hst2`, `freeDirPureT`, `hdeg`, `ht0`, `hq2`, `hg2`, **`hdom` Loc IsDominant** | Prove Loc dominant; discharge branch hyps | Medium (hyps heavy) |
| `isDominant_residualImagePointOfNormalizedLoc` | `ResidualImageDominance.lean:338` | `residualChartDenom ≠ 0` | WP10 denseness + chart path | Medium classically; **sorry** |
| `residualImageChartEval_injective` | `ResidualImageDominance.lean:322` | `hdenom ≠ 0` | denseness of residual map in residual image chart | Medium; **sorry**; see §6 re reducibility |
| `residualImageChartPoint_appTop_injective_of_eval_injective` | `ResidualImageDominance.lean:290` | injectivity of chart eval | `Scheme.ΓSpecIso_naturality` transport | **High** (pure API); **sorry** |
| `ker_eq_bot_of_map_le_residualImageIdeal` | `ResidualImageDominance.lean:67` | map ker ≤ residualImageIdeal | comap_map_le + comap_mono + comap bot | **High**; proof known, elaborator timeout; **sorry** |
| `residualImageIdeal_comap_residualImageι` | `ResidualImageDominance.lean:50` | — | **DONE** (Mono + pullback.fst iso) | Green |
| `isDominant_residualImageRationalMapAffine` | `ResidualImageRationalParam.lean:1303` | `[IsDominant residualImagePointOfNormalizedLoc]` | transport only | **DONE** (ofhom-dom) |
| `residualImageXCoords_ne_zero_of_smooth` | `SpecializedConicFreeDir.lean:1158` | smooth, F≠0, Tsen isotropic v | freeDir form ≠0 | **DONE** |
| `residualImageXCoords F v 2 ≠ 0` (`hst2`) | used at `ResidualYCoordsPureT.lean:295` | index-2 of residual X | Prove specifically coord 2 ≠0 (or reindex) | Medium; not free from residual X ≠0 alone |
| `freeDirPureT F` | `SpecializedConicFreeDir.lean:3947` | pure-t freeDir | Prove for general smooth F, or case-split non-pure-t | **Open**; branch restriction |
| `freeDirCoeffT F 0 0` degree / root hyps | `ResidualYCoordsPureT.lean:297–299` | `hdeg`, `ht0` | freeDir depends on t; root with v₂(t)≠0 | Medium under pure-t |
| `residualComplementaryDir F v 2 = 0` (`hq2`) | `ResidualYCoordsPureT.lean:300` | L-branch | Geometric choice of residual tangent | Medium; branch condition |
| residual cubic `pderiv 2` ≠0 (`hg2`) | `ResidualYCoordsPureT.lean:301` | nonsingular residual cubic at line | Smooth fiber / L-branch | Medium |
| `residualYCoords_ne_zero_of_smooth_L_branch_pureT` | `ResidualYCoordsPureT.lean:264` | pure-t L-branch package | **DONE** under those hyps | Green under hyps |
| WP2 projection dominant / no whole fiber | `BiprojectiveProjectionDominant`, `BiprojectiveNoWholeFiber` | smooth (2,3) | **DONE** | Green (reconfirmed) |
| Bridge has2 → pointed → baseChange dim 3 | `MainTheorem.lean:303–306` | as hyp `hbridge` | `AffineSpaceProduct` + pointed packaging | Partial infrastructure; not closed |
| Pointed-a1 ofHom A¹_T → residual base change | (planned) | — | residual base change unirationality assembly | Not landed |
| Drop `hXT` unconditional main | `MainTheorem.lean:285` | — | all of above | Far |

---

## 3. WHAT `freeDirPureT` ACTUALLY IS

### Definition (verbatim)
```lean
-- SpecializedConicFreeDir.lean:3947–3950
def freeDirPureT
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  freeDirCoeffT F 0 1 = 0 ∧ freeDirCoeffT F 1 1 = 0
```

### Supporting definitions
```lean
-- freeDirCoeffT F i j : Polynomial k
-- = ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j
-- SpecializedConicFreeDir.lean:3449–3452

-- freeDirPolyT F s =
--   freeDirCoeffT F 0 0 + freeDirCoeffT F 0 1 * C s + freeDirCoeffT F 1 1 * C s^2
-- SpecializedConicFreeDir.lean:3462–3468
```

### In words
The specialized conic along the coordinate line, restricted to the free plane `{X₂ = 0}` (stereographic directions `(1,s,0)`), is a binary quadratic in the free parameter `s` whose coefficients are polynomials in the line parameter `t`. Those three coefficient polynomials are `freeDirCoeffT F 0 0`, `0 1`, `1 1`.

**`freeDirPureT F` means the freeDir form on the free plane does not depend on `s`:** the coefficients of `s` and `s²` vanish identically as polynomials in `t`. Equivalently, for every `s`,
```lean
freeDirPolyT F s = freeDirCoeffT F 0 0   -- freeDirPolyT_eq_coeff00_of_pureT
```
So the free-direction vanishing condition is a univariate condition in `t` alone.

### Geometric content
Classically: at parameter `t`, the specialized conic `Q_t` of the coordinate-line fiber vanishes on the free plane `{X₂=0}` for some freeDir direction. When freeDir is pure-`t`, that vanishing (when it holds) is independent of stereographic slope `s`. That lets denseness arguments fix pure-`t` freeDir roots and conclude whole free-plane vanishing (`eval_on_free_plane_of_pureT_freeDir_root`, `SpecializedConicFreeDir.lean:3969`).

Used to push residual denseness / residualY nonvanishing without quantifying over all `s` freeDir roots.

### Complementary (non-pure-t) branch
**Not handled.** If `freeDirCoeffT F 0 1 ≠ 0` or `freeDirCoeffT F 1 1 ≠ 0`, freeDir is a genuine quadratic/linear pencil in `s` with `t`-dependent coefficients. Parallel argument would need:
1. For general `t`, existence of freeDir root `s(t)` (alg closed);
2. Control polar nonvanishing along that root;
3. Denseness of freeDir specializations in the free plane without reducing to a pure-`t` univariate;
4. Possibly `freeDirDependsOnT` (`SpecializedConicFreeDir.lean:3455`) as the weaker “some coeff has positive degree” predicate.

`freeDirDependsOnT_of_pureT_natDegree` only lifts pure-t + deg(coeff00)≠0 → `freeDirDependsOnT`.

**Risk:** pure-t may be special for generic `F`. Treating pure-t as the only residualY path leaves a case gap for the unconditional main theorem.

---

## 4. DEAD ENDS (do not repeat)

### 4.1 `exists_nonsingular_stereo_cubicFiber_of_smooth` / Disc∘stereo ≢ 0
- **Goal:** residual stereo cubic fiber nonsingular for smooth F (binary discriminant of residual cubic ≠0, or existence of nonsingular stereo point).
- **Approaches tried:** specialize stereo residual cubic to smooth fiber; push freeDir singularity contradiction into residual cubic Disc; numerical probes of freeDir.
- **How far:** freeDir form ≠0 on smooth F **landed** (`specializedConicFreeDirForm_ne_zero_of_smooth` → residual X ≠0). Disc∘stereo / nonsingular stereo cubic as a global package was **not** closed as a single theorem of that name.
- **Why stuck:** residual cubic is pullback of F along residual X coords (themselves stereo of specialized conic); composing Disc with stereo is multi-layer; smoothness of ambient F does not immediately give Disc of residual cubic ≠0 without more residual geometry.
- **Do not:** re-open freeDir form =0 singularity path; that is green.

### 4.2 Mathlib lemmas looked for that **do not exist** (or not under guessed names)
| Guessed / wanted | Reality |
|------------------|---------|
| `IsBihomogeneousOfBidegree.eval_smul_right` (or similar off-the-shelf) | **No** such API. Homogeneous evaluation scaling uses local lemmas / `eval_smul_point_of_isHomogeneous` style helpers in-project |
| `Ideal.ker_lift_eq_bot_iff` (used briefly in Dominance) | **Not** a Mathlib name in this pin; injectivity of `Ideal.Quotient.lift` needs the standard ker characterization differently |
| `Scheme.Spec_map_appTop_ΓSpecIso` | **Wrong name**. Correct: `Scheme.ΓSpecIso_naturality` (`Mathlib/.../Scheme.lean` ~628): `(Spec.map f).appTop ≫ ΓSpecIso S = ΓSpecIso R ≫ f` |
| Direct `isDominant_of_of_appTop_injective` on `Loc → residualImage` | **Inapplicable**: residualImage is **not** affine. Must factor through residual image **chart** (affine) |
| Free lunch `Hom.ker_comp = f.ker.map g ⊔ g.ker` | In this Mathlib, `Hom.ker_comp f g : (f ≫ g).ker = f.ker.map g` **only** (no ⊔ g.ker). Residual image ideal enters via `le_ker_comp` separately |

### 4.3 `residualYCoords_ne_zero_of_smooth` (cut attempt)
- **Wanted:** residual Y ≠0 for smooth F without pure-t / L-branch hyps.
- **Bihomogeneity scaling idea:** residual Y comes from residualAmbientRep of binary residual of cubic fiber along complementary tangent; if residual binary =0 then cubic vanishes on a line through p; clear denominators via homogeneity (`eval_smul_point_of_isHomogeneous`) to get vanishing on L={X₂=0}; contradict denseness / freeDir / smoothness.
- **Where it broke:**
  1. Field-based `eval_on_L_…` timed out / failed to specialize at `affineTwoRing k` (**domain, not Field**).
  2. Fix: `eval_on_L_eq_zero_of_residual_binary_eq_zero_of_q_two_grad2_ne_domain` in `ResidualYCoordsPureT.lean` (IsDomain + clear dens).
  3. Full unconditional residualY still needs binary ≠0 and L-branch geometry; only **pure-t L-branch** package landed.
- **Landed instead:** `residualYCoords_ne_zero_of_smooth_L_branch_pureT` (`ResidualYCoordsPureT.lean:264`).

### 4.4 Algebra `toBase` on residual image points (reverted)
- Appended residualImagePoint… toBase / residualY projection to `ResidualImageAlgebraPoint.lean`.
- **Failed:** elaborator timeout + ambiguous `standardChartRingEquivMvPolynomial`.
- **Action:** truncated file restored through `residualImagePointOfNormalizedAlgebra_toSpec` (`ResidualImageAlgebraPoint.lean` ends ~that region). Do not re-append bulk toBase without splitting modules.

### 4.5 ResidualImageDominance Nullstellensatz `False.elim` path
- Tried: radical membership of Q via vanishingIdeal zeroLocus + denseness, then residualImageChartIdeal radical.
- **Failed:** denseness not formalized; radical ≠ ideal without reducedness; `False.elim` placeholders left file red.
- **Action:** replaced with explicit `sorry -- TODO(...)` stubs; forward ideal ≤ ker **green**.

### 4.6 `ker_eq_bot_of_map_le_residualImageIdeal` elaborator
- Proof sketch is correct (probe `implementer/probe_comap_bot4.lean` closed comap bot; map_le path outlined).
- Full-file context: **timeout at `whnf`** even at 1.6M heartbeats on `comap_map_le` / ideal sheaf.
- **Do not** burn hours re-increasing heartbeats in-file; either isolate lemma in a thin module, or keep sorry and use only for packaging.

### 4.7 TRUE vs SUSPECTED FALSE

**Believe TRUE (unproved or stubbed):**
- `IsDominant residualImagePointOfNormalizedLoc` under `residualChartDenom ≠ 0` **onto the residual component T_L** classically (WP10).
- `residualImageChartEval` injectivity if residual image chart = residual map image scheme-theoretically and reduced.
- `ker_eq_bot_of_map_le` as stated (API timeout only).
- appTop injectivity from chart eval injectivity via ΓSpecIso_naturality.

**Suspect FALSE or overstated as currently targeted:**
- **Dominance onto all of `residualImage = V(F, residualEquation)`** if residual divisor D has extra vertical components besides T_L. Classically residual map hits T_L densely, not necessarily every vertical component. Then `HasUnirationalParametrization 2 (residualImageToSpec F)` may be **classically false** for reducible residualImage. Packaging may need residual image = T_L (prime/component) rather than full residualEquation zero locus.
- **`residualImageChartEval_injective` for full residualImageChartIdeal** same issue: ker may properly contain residualImageChartIdeal if residual map misses components.
- **Unconditional `freeDirPureT F` for all smooth F** — likely false; pure-t is a branch.

---

## 5. DOMINANCE PLAN STATUS (`ResidualImageDominance.lean`)

Module docstring strategy (aligned to steps 1–6):

| Step | Content | Status |
|------|---------|--------|
| 1 | `residualImageIdeal.comap residualImageι = ⊥` | **COMPLETE** — `residualImageIdeal_comap_residualImageι` (`ResidualImageDominance.lean:50`) |
| 2 | `f.ker.map residualImageι ≤ residualImageIdeal ⇒ f.ker = ⊥` | **STUBBED** — `ker_eq_bot_of_map_le_residualImageIdeal` (`:67`) sorry `TODO(ker-bot-map)`; sketch known |
| 3 | `residualChartEval.ker = Loc.ker.map residualImageι` | **COMPLETE** — `residualChartEval_eq`, `residualChartEval_ker_eq`; also `residualImageIdeal_le_residualChartEval_ker` |
| 4 | Residual image chart Spec + eval maps | **DEFS COMPLETE** — `residualImageChartIdeal`, `residualImageChartEval`, `residualImageChartPoint`. Loc factorization through chart immersion into residualImage **OPEN** |
| 5 | injectivity ⇒ chart IsDominant via `isDominant_of_of_appTop_injective` | **CONDITIONAL skeleton** — `isDominant_residualImageChartPoint_of_eval_injective` (`:304`) depends on appTop inj **sorry** `TODO(appTop-inj)` |
| 6 | residualImageChartEval injectivity + Loc dominant | **STUBBED** — `TODO(WP10-dense)`, `TODO(loc-dom)` |

### Next concrete obligation (recommended order)
1. **`TODO(appTop-inj)`** — easiest; pure Mathlib (`Scheme.ΓSpecIso_naturality`).
2. **`TODO(ker-bot-map)`** — isolate in tiny file if elaborator chokes.
3. **`TODO(WP10-dense)`** — real geometry; decide residualImage vs T_L first (§4.7, §6).
4. Wire chart→residualImage factorization; compose dominance.
5. Drop `hdom` from pure-t has2; then pointed-a1 / hXT.

**Not imported by root** — sorries do not poison main cone.

---

## 6. SHAKY GROUND

1. **`residualImage` target for unirationality** — may be reducible (T_L + vertical components). has2 onto full residualImage is the biggest packaging risk.
2. **`freeDirPureT` branch** — residualY pure-t path does not cover non-pure-t; no case split.
3. **`hst2 : residualImageXCoords F v 2 ≠ 0`** — stronger than residual X ≠0; stereo/index choice may fail for some Tsen sections.
4. **L-branch hyps `hq2`, `hg2`** — residual complementary dir component 2 =0 and residual cubic ∂₂ ≠0; geometric “good L-branch” not derived from smoothness alone in Lean.
5. **`Hom.ker_comp` shape** — only `f.ker.map g`; do not invent ⊔ residualImageIdeal in rewrites.
6. **`ResidualImageAlgebraPoint`** — do not bulk-append; previous toBase attempt timed out.
7. **`SpecializedConicFreeDir.lean` size** — 4208 lines; incremental appends frequently broke mid-file; prefer thin wrapper modules (pattern of `ResidualYCoordsPureT`).
8. **ofhom-dom transport is complete** but **does not prove geometry** — only moves IsDominant Loc → affine rational map.
9. **Main theorem `CharZero`** present; residual path may not use it yet — keep for classical residual/Lattès if reintroduced.
10. **Policy:** no silent `False.elim`; stub with `sorry -- TODO(name): …`. Root cone currently sorry-free.

---

## 7. CONVENTIONS

### Coordinates
- `BiprojectiveCoordinate m n := Sum (Fin (m+1)) (Fin (n+1))` (`BigradedPolynomial.lean:25`).
- **`.inl` / first block = X** (conic-bundle **base** when projecting via `snd`? — check carefully):
  - In this project, **conic fibers are in the second block (Y)** for the usual “conic fibration over P²_x”: `biprojectiveZeroLocusSnd` / residual multisection base is Y-projection.
  - Residual stereo first coords = **X-block** (`residualImageXCoords` = `stereoFirstCoords`).
  - Residual Y coords = residual point in **Y-block**.
- Standard chart `(i,j)`: dehomogenize X_i=1, Y_j=1; affine ring `MvPolynomial (Fin 2 ⊕ Fin 2) k` for m=n=2.

### residualChartDenom / localization idiom
```lean
residualChartDenom F v i j := residualImageXCoords F v i * residualYCoords F v j
residualChartLoc F v i j := Away (residualChartDenom F v i j)
-- normalize: scaleByUnitInv so x_i = 1, y_j = 1 in Loc
residualImagePointOfNormalizedLoc : Spec residualChartLoc → residualImage
residualImagePartialMap : domain = basicOpen(denom), dense when denom ≠ 0
residualImageRationalMapAffine : AffineSpace.SpecIso then residual rational map
```
Always: nonzero residual X and Y vectors ⇒ some `i,j` with denom ≠0 (`exists_residualChartDenom_ne_zero`).

### Naming
- `…OfNormalizedAlgebra` — algebra-valued coords over R→S, Spec S → residualImage.
- `…OfNormalizedLoc` — Away localization of affine plane.
- `…RationalMapAffine` — map from 𝔸²_k.
- `hasResidualImageUnirationalParametrization2_of_…` — packaging theorems.
- Pure-t wrappers live in `ResidualYCoordsPureT.lean`, not more bulk in SpecializedConicFreeDir.

### House style
- Prefer thin modules over 4k-line appends.
- `set_option maxHeartbeats` **before** doc/theorem (not after).
- Residual defs as `def` not `abbrev` when unfolding hurts elaborator.
- Evidence logs historically under implementer scratch  
  ` /var/folders/n3/bqmjrljs275_439r2z8m30380000gp/T/grok-goal-c7950ca0eea8/implementer/`  
  (e.g. `ofhom-dom-has2-green.txt`, `residualy-puret-green.txt`, `wp2-reconfirm2.txt`).

### Key green theorems to start from
- `residualImageXCoords_ne_zero_of_smooth` — `SpecializedConicFreeDir.lean:1158`
- `residualYCoords_ne_zero_of_smooth_L_branch_pureT` — `ResidualYCoordsPureT.lean:264`
- `isDominant_residualImageRationalMapAffine` — `ResidualImageRationalParam.lean:1303`
- `residualImageIdeal_comap_residualImageι` — `ResidualImageDominance.lean:50`
- WP2: `BiprojectiveNoWholeFiber`, `BiprojectiveProjectionDominant`

### Root import
`BConicBundleMultisections.lean` imports `ResidualYCoordsPureT` but **not** `ResidualImageDominance`.

---

## Quick command cheatsheet
```bash
lake build                                          # root green expected
lake build BConicBundleMultisections.ResidualImageDominance
rg -n "sorry --" BConicBundleMultisections
rg -n "freeDirPureT|isDominant_residualImagePointOfNormalizedLoc|HasResidualImageUnirationalParametrization2" BConicBundleMultisections --glob '*.lean'
```
