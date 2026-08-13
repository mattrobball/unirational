# Faithful V14 completion status

Date initialized: 2026-08-12

Headline status: **OPEN / CONDITIONAL**

Operational instructions: `WORK_ORDERS_2026-08-12.md`

Mathematical architecture: `HANDOFF_2026-08-12.md`

Baseline and hashes: `HANDOFF_BASELINE_2026-08-12.md`

## Queue

| Work order | Status | Prerequisites | Current smallest blocker |
|---|---|---|---|
| WO-00 preserve plus inputs | READY | none | Refactor the archived generator, regenerate the JSON, and install reproducible project paths |
| WO-01 repair minus endpoint | RED | none | Direct carrier import, proof-dependent `Fin` dispatch, scalar-extension evaluation |
| WO-02 seal/integrate minus | BLOCKED | WO-01 | Concrete endpoint is red |
| WO-03 `MvFrac` constant field | READY | none | The RatFunc-relative-constants theorem is not yet in project source |
| WO-04 minus descent | BLOCKED | WO-02, WO-03 | Certificate and constant-field theorem |
| WO-05 plus Lean data | BLOCKED | WO-00 | Plus inputs are still ephemeral |
| WO-06 plus Segre/smoothness certificate | BLOCKED | WO-05 | No generated Lean packet |
| WO-07 arbitrary-field cubic descent | BLOCKED | WO-03 | Constant-field/base-change layer |
| WO-08 plus descent | BLOCKED | WO-06, WO-07 | Both plus certificate and cubic descent |
| WO-09 coordinate-to-scheme reconstruction | READY | existing integrated APIs | Reverse closed-immersion lift and eigenvector converse are not yet written |
| WO-10 fixed field-point descent | BLOCKED | WO-04, WO-08, WO-09 | Both branch descents and coordinate-to-scheme assembly |
| WO-11 rational-map constancy | BLOCKED | WO-10 | Fixed field-point descent |
| WO-12 unconditional headline | BLOCKED | WO-11 | Rational-map constancy |
| WO-13 final audit | BLOCKED | WO-12 | Unconditional theorem |

## Update protocol

For every status change append an entry below.  Do not overwrite prior entries.

Required fields:

```text
Timestamp:
Agent:
Work order:
Old status -> new status:
Files changed:
Commands and exit codes:
Wall times:
Endpoint axiom sets:
Source/output hashes:
Exact remaining blocker, if any:
```

## Log

### 2026-08-12 — handoff initialization

- WO-01 was independently replayed with
  `lake build V14Formalization.D12SigmaMinusConcrete`; exit code 1 after
  15.16 seconds for the final target once dependencies were available.
- `lake build V14Formalization.FaithfulHeadlineReduction` exited 0 in
  4.42 seconds in the final cached replay.
- `lake build V14Formalization.TrustGuard` exited 0 in 4.37 seconds in the
  final cached replay.
- The archived plus generator replay exited 0 in 12.37 seconds, recreated the
  expected JSON and M2 hashes, and the M2 replay exited 0 with
  `chart_smooth={true, true, true}` and `smooth=true`.  This preserves the
  exploratory input but does not complete WO-00's location-independent
  generator requirement.
- No work order beyond the conditional headline is being claimed complete.

### 2026-08-12 — WO-00 plus inputs

- Archived generator recreated `/tmp/sigma_plus_segre_Ki.json` with SHA-256
  `52c1280a0a5e84128432db79e4d95753efe52a73d49a0fa450e69798a64965dc`.
- Project generator `scripts/export_sigma_plus_segre.py` now uses
  `Path(__file__).resolve().parents[1]` and `--out-dir`.
- Two isolated regenerations were byte-identical.  Installed
  `results/sigma_plus_segre_Ki.json` with the same hash, and
  `scripts/sigma_plus_smooth_mod89.m2` still hashes to
  `e254e8a6bb2852fa843b1ab732c97723268047e7e319cc98b89f91cfe9c35f2d`.
- Input hashes unchanged:
  `d12_lean_K.json` = `76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0`,
  `sigma_normal_form_K.json` = `69c98b2df53b0689df935306fbe647014c7a8d46ea05c486f756ba20a61b426a`.
- WO-00 status: GREEN_LOCAL.  No Lean theorem claimed.

### 2026-08-12 — WO-01 in progress

- Added `evalPolyAt_extension_eq_map_evalPolyAt` and repaired
  `D12SigmaMinusConcrete` (carrier import, `interval_cases` dispatch,
  scalar-extension evaluation).  `lake build V14Formalization.D12SigmaMinusConcrete`
  exits 0.

### 2026-08-12 — WO-02 / WO-03 / WO-04 local green

- Minus generator `--out-dir`: two isolated runs match each other and the 20
  checked-in `D12SigmaMinus*.lean` files.
- `MvFracConstantField`, `BinaryQuadraticDescent`, and
  `D12SigmaMinusDescent` compile.
- `ProjectiveFamilyFieldPointLift` and `V14FixedPointDescent` compile.
- `D12SigmaPlusSegreCore` data compiles; L*H / N*H / smoothness are not
  kernel theorems yet.
- Unconditional headline remains open.

### 2026-08-12 — plus identities / kernel line

- `scripts/export_sigma_plus_identities.py` emits per-entry `L*H` and `N*H`
  identities with Φ₁₁ witnesses, proved by `Polynomial.funext` over `ℚ`.
- `lake build V14Formalization.D12SigmaPlusSegreData` exits 0: kernel theorems
  `L_mul_H` and `N_mul_H`.
- `Fplus_isHomogeneous` compiles.
- Exact M2 over `toField(QQ[z,I]/(Φ₁₁,I²+1))` reports
  `chart_smooth={true,true,true}` with Bezout certificates saved in
  `results/sigma_plus_smooth_Ki_m2.log`.
- `kernelLine_descends_of_rank_eq_two` compiles with no extra minor hypothesis.
- Unconditional headline remains open: plus section invertibility, Plücker
  spans, `Fplus = det`, geometric smoothness in Lean, cubic descent, and
  assembly are still missing.

### 2026-08-12 — T inverse and cubic draft

- `L * K = 0` and `N * K = 1` compile (`D12SigmaPlusSegreTinv`).
- `eq_H_mulVec_L_of_N_mulVec` compiles: `N z = 0` implies `z = H (L z)`.
- Cubic descent draft is in `SmoothPlaneCubicMvFracDescent.lean` with an honest
  geometric-smoothness hypothesis over `AlgebraicClosure K`. `lake build` of
  that module cannot rebuild BConic artifacts in this environment.

### 2026-08-12 — geometry helpers and sigma-fixed lift

- `D12SigmaPlusQuadric6` and `D12SigmaPlusSegreGeom` compile.
- `v14SchemePointOfNormalizedCoordinates_sigma_fixed` compiles.

### 2026-08-12 — plus Segre packet in progress

- `eval_Fplus_eq_det` is written; Det000/002/012/022/111/112/122/222 compile.
  Det001/Det011 still need their 6-term group sums split (stock `simp` timeout).
- Span matrices `spanU`, `spanV`, `minorQ`, `Qplus` compile.
- First V-span identity `VQ_entry_0_0 : spanV * Qplus = minorQ` at `(0,0)`
  compiles at stock limits. Remaining 188+315 product files are generated.
- Exact Bézout solvers produced degree-≤2 chart certificates for U,V,W
  (`A,B,C` terms 5/5/4). Lean `pderiv` evaluations on the U-chart compile.
  Pointwise `IsSmoothPlaneCubic` assembly is not yet closed.

### 2026-08-12 — plus Segre packet compiled

- `spanV * Qplus = minorQ` and `spanU * minorQ = Qplus` compile
  (`D12SigmaPlusSegreSpanVDir`, `D12SigmaPlusSegreSpanUDir`).
- `quadValue` of a minor is the corresponding linear combination of
  `Qplus` values (`D12SigmaPlusSegreSpanEval`).
- `eval_Fplus_eq_det` and `Fplus_isSmoothPlaneCubic` /
  `Fplus_isSmoothPlaneCubic_map` compile.
- `minorCoeffsH = minorQ` compiles (`D12SigmaPlusSegreHM_*`, `HMDir`).
- Point-level theorem
  `plusCarrier_commonPluckerZero_to_determinantalCubic` compiles:
  a nonzero plus-carrier Plücker zero is a Segre tensor `a ⊗ b` with
  `det A(a) = 0`. The `Ki` form also gives `eval a Fplus = 0`.
- Reconstruction `u = L (a ⊗ b)` compiles (`D12SigmaPlusDescent`).
- Rank bound `rank ≤ 2` from `det = 0` compiles. Rank exactly 2
  (exclude rank ≤ 1 via vanishing partials) is not yet assembled.
- Unconditional headline remains open: `MvFrac` descent of both tensor
  factors, `Ki → K`, generic-point constancy, and umbrella import.

### 2026-08-12 — plus descent and fixed field-point descent

- `plusCarrier_commonPluckerZero_descends_mvfrac_Ki` compiles: cubic
  descent of the first factor, rank-2 kernel line of the second, then
  reconstruction through `L`.
- `plusCarrier_commonPluckerZero_descends_mvfrac` compiles over
  `V14SchemeModel.k`: base-change to `Ki`, apply the Ki theorem, return
  by ratios and `mvFrac_eq_constant_of_baseChange_eq_constant`.
- `plusCarrier_ambient_descends_mvfrac` compiles.
- Axioms of those three theorems, and of
  `kernelLine_descends_of_rank_eq_two`, are exactly
  `propext`, `Classical.choice`, `Quot.sound`.
- `v14FixedFieldPoint_descends_of_mvfrac` compiles in
  `V14FixedFieldPointDescent.lean` (plus or minus branch, rebuild a
  base-field V14 point, σ-fixed, matches after `Spec.map`).
  Axioms: `propext`, `Classical.choice`, `Quot.sound`.
- `lake build` of modules that import `SmoothPlaneCubicMvFracDescent`
  still cannot rebuild the nested BConic tree here. Compile with
  `LEAN_PATH` putting a complete BConic olean overlay first, then this
  project's `.lake/build/lib/lean`.
- TrustGuard was not given the new imports: re-elaborating it needs
  missing D12 piece oleans. Umbrella import and headline constancy
  remain open.

### 2026-08-12 — headline landed; lakefile stays on GitHub BConic require
- `noEquivariantRationalMap_from_ambient` compiles; axioms propext, Classical.choice, Quot.sound.
- Umbrella and TrustGuard import/guard it.
- lakefile.toml requires BConic from github.com/mattrobball/unirational (not a local path).

### 2026-08-12 — ProjectiveGVariety is a Mathlib scheme
- Added `SchemeGeometry.ProjectiveGVariety`: closed subscheme of `Proj` with a `G`-action over `Spec k`.
- `SmoothProjectiveGVariety` is documented as the linear-algebra point model (not a Scheme).
- Headline restated as `noEquivariantRationalMap_projectiveGVariety`.
