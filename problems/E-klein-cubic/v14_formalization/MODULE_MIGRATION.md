# The module system in this project (Lean 4.32.1)

**The migration is finished.** This document describes the state of the tree
and the rules that keep it that way; it is no longer a plan. Read
"Where things stand" first, then the sections that apply to what you are
changing.

## Where things stand (2026-08-17)

| | |
|---|---:|
| `module` files | 1,376 |
| legacy files remaining | 34 |
| Comparator closure converted | 1,052 / 1,052 |
| declarations | 92,716 |
| ... `public` | 11,220 (12.1%) |
| ... `@[expose]` | 7,093 (7.7%) |
| ... module-private | 81,496 (87.9%) |
| modules publishing at most one declaration | 1,005 of 1,376 |

The 34 legacy files are exactly the ones that have never compiled, on any
branch: `D12SealProof` (deterministic whnf timeout at `L₀_mul_B₀`), the 24
`Apply_span{U,V}` shards that reference `spanU_row*` / `spanV_row*` lemmas
defined nowhere in the tree, the 3 `Smooth{U,V,W}` files whose
`Ambiguous term C/X` reproduces with pure Mathlib imports, and 6 aggregators
and shards that import them. None has ever had an olean. A module file may
not import a non-module file, so they cannot be converted until they compile.
**Every file in this project that compiles is a module file.**

What that bought, measured on an importer of `V14Solution`:

| importer | constants | max RSS |
|---|---:|---:|
| legacy (`import V14Solution`) | 589,728 | 3.77 GB |
| module (`public import V14Solution`) | 413,384 | **2.08 GB** |

A module importer sees 30% fewer constants and 45% less resident memory,
because 87.9% of this tree's declarations are now genuinely internal. 3,040
of them were written `private` by their authors, which under the legacy
elaborator only mangled the name while still loading the body into every
consumer.

## The one hard rule: strictly bottom-up

A `module` file cannot import a non-`module` file (hard error,
`Lean/Environment.lean:2066`). So a file may be converted only when every
project file it imports is already converted.

## Semantics that matter (verified empirically on 4.32.1)

* **Legacy importers keep full defeq.** A non-`module` file importing a
  converted module still sees every body, exposed or not (`rfl` through a
  non-exposed def works). Conversion cannot break legacy *proofs*.
* **`public`/`private` names bind for everyone.** A module-private
  declaration is inaccessible by name even from legacy importers. The
  downstream-usage scan is therefore the load-bearing guard; the full
  build catches any scan miss as a plain unknown-identifier error.
* **Module importers' private contexts also unfold non-exposed public
  defs** (plain `public import` suffices). `@[expose]` is needed only
  where the *exported* context does defeq: term-mode `rfl`/`:=`-proofs of
  public theorems, bodies of exposed defs, field projections inside public
  signatures. Tactic proofs (`by rfl`, `simp [f]`) work without exposure.
* Because legacy importers ignore annotations, the legacy build proves
  nothing about them; validation must come from module-side probes
  (below).

## Per-file recipe (hand-written files)

Decisions live in `scripts/migration_stage1.json` (one JSON block per file:
`public` names, `expose` names); `scripts/module_migrate.py` applies them
idempotently. Later stages add their own config files and reuse the tool.

1. **Compute the used set**: names of this file's declarations referenced
   by any transitive importer (Unicode-aware token scan — plain `\w` regexes
   miss `ζ`, `Φ11`, `χ₂`). These become `public`.
2. Additionally public, regardless of the scan: every `instance` and every
   `@[simp]`/`@[norm_num]` declaration (they act through resolution and
   simp sets, so text scans cannot prove them unused) — the tool does this
   automatically.
3. **Expose only what has to unfold** (`--narrow-expose`; the blanket
   `expose_all_public_defs` posture is retired and no config sets it).
   `@[expose]` is needed only where the *exported* context does defeq. The
   generator derives that from three things, and all three were learned from
   builds that failed without them:
   - a name in a `simp` / `dsimp` / `norm_num` / `decide` unfold list, or
     under `unfold f` — `simp [WeilRep.Φ11]` in a module consumer needs the
     body, since equation lemmas of non-exposed imports do not exist;
   - a name in a `change e` / `show e`, and — separately — every name in the
     STATEMENT of any declaration whose proof runs `change` / `show` / `rfl` /
     `decide`, because the tactic forces defeq against its own goal and the
     goal's head need not appear in the tactic text
     (`D12GeneratorSRow0Nonzero` `change`s a goal stated with
     `SrestrictedAction`, which the tactic never mentions);
   - the in-file closure: an exposed def's body may only reference public
     names, and a public `:= rfl` theorem's statement must reduce, so both
     pull their references in transitively.
   Public `abbrev`s are exposed automatically; do not annotate them.
   Anything the scan proposes and the build refuses goes in `no_expose` with
   the reason (`LinearNormalProjectiveChart`'s two AlgEquiv defs fail
   instance synthesis when exposed).
4. Everything else stays unannotated = module-private. Old-style `private`
   compiles unchanged as module-private (PSLCard's 237 `private` decls
   needed zero edits).
5. All imports become `public import` (Mathlib's own convention).
6. **Iterate on compile errors** — expect 1-3 rounds per nontrivial file:
   - "private declaration ... would need to be public": a public
     signature mentions it → add to `public`.
   - "Unknown identifier" inside an exposed body: exposed bodies may only
     reference public names → add the referenced def/theorem to `public`
     (and `expose` if defeq must continue through it, e.g. `liftsToN`).
   - "Not a definitional equality ... theorem is exported": add the
     unfolded def to `expose`.
7. **Never touch statements or proofs.** Every fix in this migration is a
   visibility annotation.

## Remedy preference order for reduction failures (directive, 2026-08-17)

When a `decide` / `rfl` / defeq proof fails in a converted module, fix it
in this order — `import all` is a last resort, not a standard remedy:

1. **Move the computation to where the bodies live.** Do the `decide` in
   the module that DEFINES the data and export only the resulting theorem
   as `public`; consumers reference the constant instead of re-reducing.
   Best outcome: shrinks terms as well as imports.
2. **Prove a characterization lemma once**; consumers rewrite with it
   rather than unfold (the `v14/expose-pilot` branch cut one certificate
   module 9.2x deduped / 87x raw this way).
3. **`@[expose]` the specific definitions needed** — narrow and named,
   not a blanket section.
4. **`import all`** — only when 1–3 are impossible, listed and justified
   here.

### `import all`: RESOLVED, count is zero and must stay zero (2026-08-17)

Stage 2 left 82 lines on two core edges, in 41 files (D12CyclotomicVecZ +
the 40 D12Piece{PP,PA,AP,AA}SplitRow shards):

* `import all Init.Data.Vector.Basic`
* `import all Init.Data.Array.DecidableEq`

The diagnosis was right and the remedy was wrong.

The diagnosis: `VecZ = Vector Int 10`, and the Lean 4.32.1 toolchain's
`instDecidableEqVector.decEq` and `Array.instDecidableEqImpl` are `public`
but not `@[expose]`d, so inside a `module` file `decide` — and
`decide +kernel` — get stuck on *any* `Vector` equality, including
`#v[1,2,3] = #v[1,2,3]`. Re-verified in isolation on 2026-08-17. No
project-side annotation can reach a toolchain declaration, so remedy 3 is
genuinely impossible.

The error was concluding that remedy 2 was also impossible. It is not: the
route through `Vector`'s `DecidableEq` instance is not the only way to
decide the equality. `D12CyclotomicVecZ` — the module that DEFINES `VecZ` —
now carries

```lean
@[expose] public def eqZ (a b : VecZ) : Bool :=  -- coordinatewise
  a[0] == b[0] && … && a[9] == b[9]
public theorem eq_of_eqZ      {a b : VecZ} (h : eqZ a b = true)  : a = b
public theorem ne_of_eqZ_false {a b : VecZ} (h : eqZ a b = false) : a ≠ b
```

`Int.beq` and `Bool.and` reduce in the kernel, so every certificate keeps
deciding its own arithmetic — all ten convolution coefficients evaluated
and compared, the mutated-product canary still an honest disequality — with
no `import all` anywhere in the tree. **Zero is now the required count**;
`scripts/check_module_invariants.sh` fails the checkpoint if any reappears.

Generalisable lesson for later stages: when a `decide` is stuck on a core
type whose `DecidableEq` will not reduce, the fix is a decidable
characterisation *in the module that defines the data*, not a wider import.

## REQUIRED pre-build static sweep (stage 2 on)

Stage 2 initially burned three ~25-minute closure rebuilds discovering one
reduction failure each. Before every stage build, run this sweep so the
build is attempted exactly once:

1. **Enumerate every reduction-based proof** in the stage's files: `decide`,
   `decide +kernel`, tactic and term-mode `rfl`, `simp [f]` / `norm_num [f]`
   / `dsimp [f]` with explicit def names, and `unfold f`. Generated families
   are uniform, so normalizing digits collapses the census to a few dozen
   idioms (script: strip comments, match tactic lines, `re.sub(r'-?\d+','N')`,
   count per family).
2. **Resolve every name in unfold-lists and defeq chains** to its defining
   module and check it is `public` + `@[expose]`d there (the
   `expose_all_public_defs` posture covers defs; theorems in simp lists need
   `public` only, which the usage scan records).
3. **Probe core/Mathlib reducibility in isolation.** For each `Decidable`
   instance a `decide` evaluates (work outward from the proposition's head:
   `Eq`/`Ne` on which type), elaborate a scratch `module` file with a
   minimal literal instance of the same proposition. This costs seconds and
   finds gaps that no annotation in this repo can see, because they live in
   the toolchain:
   * **Known core gap (Lean 4.32.1):** `instDecidableEqVector.decEq` and
     `Array.instDecidableEqImpl` are `public` but not `@[expose]`d in core,
     so `decide` on `Vector α n` / `Array α` equality is unfixable by
     project-side exposure — even `#v[1,2] = #v[1,2]` gets stuck. `List`,
     `Int`, `Nat`, `Fin` decides all reduce fine.
   * **Fix (option 2 of the preference order above):** a decidable
     characterisation in the module that DEFINES the data.
     `D12CyclotomicVecZ.eqZ` tests the ten coordinates as `Int`s and returns
     a `Bool`, which the kernel does reduce; `eq_of_eqZ` / `ne_of_eqZ_false`
     carry the result to the `Eq` / `Ne` the certificates state. `import all`
     is NOT the remedy and is banned outright — see the audit above.
4. Only after the sweep is clean, run the stage checkpoint build.

## Generated families

Never hand-edit outputs: change the emitter, regenerate, and check the
diff contains only the intended annotations (`git diff` must show only
`module`/`public`/`@[expose]`/header-comment lines). Two patterns exist:

* **Live emitter** (`scripts/export_d12_lean.py`, D12SealData): the emitter
  gained a final `annotate_module_visibility` pass over the emitted text
  plus a hardcoded, commented public set (the names `D12SealProof`
  consumes). Aggregates defined from `_c*` chunks force the chunks
  public+exposed — the emitter computes that closure itself.
* **Frozen output whose emit code predates the repo**
  (`scripts/export_d12_poly_lean.py`, D12PolynomialCore): the emitter
  carries a verified transformation of the frozen bytes — strip
  annotations, require sha256 == recorded pristine hash, re-annotate
  (`--migrate-core-only`). Idempotent; the pristine bytes can always be
  recovered mechanically.

* **Post-pass on a frozen merge output**
  (`scripts/splitrow_intro_rewrite.py`, the 40 D12Piece*SplitRow shards).
  The chain is `export_d12_piece_vec_lean.py` -> SplitEntry shards ->
  `merge_split_entry_rows.py` -> SplitRow shards -> this pass, in place.
  It rewrites PROOFS only and proves it: it extracts every statement line
  from input and output and refuses to write if any differs. Strict (every
  rewritable proof must match a known shape) and idempotent.

Data files expose what they publish: downstream certificate proofs consume
the arrays via `rfl`/`decide`, which need bodies at elaboration time.

## Duplicate `abbrev`s in a shared namespace (the stage-3 blocker)

Eight modules each declared their own `abbrev k := V14SchemeModel.k` /
`abbrev G := V14SchemeModel.G` inside `V14Formalization.SchemeGeometry`.
Under the legacy elaborator that works only because `private` mangles the
name per module. In the module system it cannot be made to work:

* a `public` signature may not mention a `private` declaration
  (`Unknown identifier`, "would need to be public"), so the aliases must be
  published wherever a public theorem's statement uses them; and
* two `public` declarations of one name cannot coexist —
  `import M.C failed, environment already contains 'Foo.G' from M.B` — and a
  downstream legacy `private abbrev` of the same name then fails with
  `a non-private declaration 'Foo.G' has already been declared`.

Both were reproduced in four-line isolated files. There is no annotation-only
fix. The resolution is one shared declaration
(`V14Formalization/SchemeModelAliases.lean`) that the eight modules import;
their source text is otherwise unchanged. This does not touch the published
Comparator statements, which spell `V14SchemeModel.k` / `V14SchemeModel.G` in
full (commit 7680055a) and must keep doing so.

Before each stage, sweep for the same shape: any name declared in more than
one file where at least one declaration is `public`.

## Validation (what the legacy build cannot tell you)

* Build each converted file (`lake build V14Formalization.<X>`) — module
  files are re-elaborated against Mathlib's *public* view, so a conversion
  can break the file's own proofs even though the legacy build passed.
* Elaborate a **module smoke file**: `module` header, imports of every
  converted file, `#check @<name>` for every public name, plus one example
  per downstream proof idiom (simp-unfold, `decide` over the list
  arithmetic, `rfl` through exposed defs). Stage 1's smoke content is easy
  to regenerate from the config; keep doing this per stage.
* `scripts/module_probe.sh <Module>` (see `scripts/module_probe.README.md`):
  module numbers shrink, legacy numbers must not move.
* After the batch, the per-stage checkpoint is
  `LEAN_NUM_THREADS=8 lake build V14Challenge V14Solution AxiomAudit` —
  the Comparator closure plus the axiom-audit entrypoint, which is what
  CI verifies. Then `#print axioms` on
  `V14Formalization.Comparator.noEquivariantRationalMap_from_ambient` and
  `...noEquivariantRationalMap_projectiveGVariety` must yield exactly
  `[propext, Classical.choice, Quot.sound]`. Converting the bottom of the
  DAG invalidates every transitive dependent, so each stage pays one
  closure rebuild — batch conversions accordingly.
* **Do not use the glob target for checkpoints.** The lakefile's
  `V14Formalization.*` glob additionally contains ~360 modules nothing
  imports; building them adds cost and noise on every stage. At least one
  of them (`D12SealProof`, deterministic whnf timeout at its
  `L₀_mul_B₀`) does not compile on `v14/build-shrink` either — no olean
  in the warm cache, no importers. If a final glob sweep is wanted at the
  end of the migration, adjudicate each failure against build-shrink: it
  only blocks if the same file *builds* there and fails after conversion.
* **Cap build parallelism on this shared box.** This Lake
  (5.0.0-src+f054605) has no `-j`/`--jobs` flag; the verified mechanism
  is `LEAN_NUM_THREADS=N lake build ...`, which caps the number of
  concurrent `lean` processes at N (measured: N=2 held it to 2 while the
  default ran 8+). Use N≈8 for stage rebuilds.

## Stage-1 baseline (probe numbers, 2026-08-17)

Importer-side environment, `PREFIX=V14Formalization`. Control verified:
legacy probes against pre-conversion and post-conversion sources agree
(identical for PSLCard / D12SealData / D12PolynomialCore; ±3 constants of
compiler-generated aux drift on D12PolyZReflection / WeilRep).
Representative rows (full table in the stage-1 report):

| target module        | probe  | total consts | proj consts | proj Expr nodes | max RSS |
|----------------------|--------|-------------:|------------:|----------------:|--------:|
| PSLCard              | module |      266,458 |          62 |           1,721 | 1.24 GB |
| PSLCard              | legacy |      368,773 |         573 |           7,206 | 2.32 GB |
| D12SealData          | module |      126,033 |         168 |          11,167 | 0.63 GB |
| D12SealData          | legacy |      205,087 |         544 |          20,134 | 1.21 GB |
| D12PolyZReflection   | module |      234,021 |          57 |           1,204 | 1.08 GB |
| D12PolyZReflection   | legacy |      329,398 |          69 |           1,288 | 2.03 GB |

(The total-constants and RSS drops are dominated by Mathlib's own public
interface being loaded instead of its full bodies — that benefit applies to
every converted file that imports Mathlib and grows as project files
convert. Caveat: the PREFIX filter counts names *mentioning*
`V14Formalization`, so leaves whose declarations live in foreign namespaces
— BiprojectiveIntegral, ProjNaturality — show 0 project constants on the
module side.)

## Stage-1 glob-failure adjudication (for the record)

A full glob build after conversion showed 28 failing modules, all outside
the `V14Solution`/`V14Challenge` closures and all failing for
pre-conversion reasons:

* `D12SealProof` — whnf timeout at `L₀_mul_B₀`; fails identically on
  pristine `v14/build-shrink` sources; no warm olean; no importers.
* `D12SigmaPlusSegreSmooth{U,V,W}` — `Ambiguous term C/X`; reproduces
  with pure Mathlib imports (`open Matrix Polynomial MvPolynomial`), no
  project code involved; no warm oleans.
* `D12SigmaPlusSegreApply_span{U 0-14, V 0-8}` (24 shards) — reference
  `spanU_row*`/`spanV_row*` lemmas that are defined nowhere in the tree;
  can never have compiled; no warm oleans.

## What the annotation migration can and cannot do (measured 2026-08-17)

The migration's purpose is to let Comparator verify this proof on a 15 GB
runner.  Comparator OOMs at 22-24 GB during `lean4export`, and that memory is
the proof-term closure of the two published theorems, not the environment
(merely importing `V14Solution` costs 4.05 GB, measured again here at 3.80 GB).

`public`, `@[expose]` and `import all` do not change a single proof term.  They
move *loading* around, i.e. at most the 4 GB term.  **No amount of annotation
work can fix the export.**  What fixes the export is relocating computation:
proving a case split or a normalisation once and applying it, so the generated
proofs stop re-inlining it.  The two goals coincide only when the migration is
done that way.

Measure with `scripts/closure_stats.lean` (both dedup granularities; the
270.8M baseline figure is the per-constant one — see that file's header for the
calibration against the pilot commit).

| | constants | per-constant nodes | per-module nodes |
|---|---:|---:|---:|
| baseline quoted 2026-08-16 | 160,956 | 270.8M | — |
| before this session (reconstructed) | ~160k | ~260.4M | — |
| after the SplitRow rewrite | 159,623 | 210.9M | 112.1M |
| after the Segre bridge rewrite | 159,776 | **177.6M** | **88.8M** |
| after the module migration completed | 159,781 | 177.6M | 88.8M |

The last row is the point of the framing: converting 1,049 further modules
moved the closure by 700 nodes out of 177.6M. Visibility annotations do not
change proof terms, so the migration is worth doing for the code, not for the
export — while an importer of `V14Solution` did go from 3.77 GB to 2.08 GB.

Net for the session: **-31.8%** on the metric the baseline used. The SplitRow
reconstruction is exact for the part it changed — the four families measured
54.1M before (1.360M / 1.362M / 1.273M / 1.418M per representative module x 10)
and 4.7M after. The Segre step is measured end to end, before and after, on the
same tree.

At the baseline's ~85 bytes/node that is ~15.1 GB of export against a 15 GB
runner: at the line, without margin, and Comparator holds its own ~12 GB
concurrently with `lean4export` (see the 2026-08-15 OOM log). **More is
needed.** What is left, and what to do about it:

| family | constants | per-constant nodes | share | shape |
|---|---:|---:|---:|---|
| SigmaMinusReverse | 2,923 | 18.0M | 10.1% | `relation_*`, 60-88k each |
| SigmaCarrierBridgeRow | 1,010 | 13.5M | 7.6% | `relation_*`, 55-95k each |
| SigmaPlusSegreLH | 1,926 | 12.2M | 6.8% | pointwise-eval `simp` + `ring` |
| SigmaPlusSegreDet | 1,021 | 11.4M | 6.4% | pointwise-eval `simp` + `ring` |
| Compound{R,F}Row | 2,010 | 19.6M | 11.1% | `norm_num` + `linear_combination` |
| SigmaPlusSegreSmoothC{U,V,W} | 2,175 | 22.4M | 12.6% | pointwise-eval `simp` + `ring` |
| SigmaPlusSegreNH | 936 | 5.8M | 3.3% | pointwise-eval `simp` + `ring` |

LH, Det, SmoothC* and NH (51.8M, 29%) all prove polynomial identities the
expensive way — `refine Polynomial.funext fun r => ?_`, a full-width `simp`
over the `Polynomial.eval_*` lemmas, then `ring`, per identity. HM and VQ do
NOT: they go through the integer interpolation (`interp_mul`,
`interp_sub_gen`, `interp_eq` and `decide` on `List Int`), which is why they
are now cheap. **Porting LH / Det / SmoothC / NH onto the same integer route
is the next reduction**, and the `interpQ_expand_*` lemmas this session added
make the first step of it free. The emitters hold the integer data already.

Compound and the two `relation_*` families are genuine per-instance rational
arithmetic over 1/11 denominators and need the `ℤ`-rescaling treatment
described in CERTIFICATE_COST_2026-08-16.md, which is a larger job.

### The Segre `interpQ` bridge rewrite (done this session)

Recorded because the same recipe is what the remaining families need.  3,711
theorems of the form

```lean
def HM_5_0_A_pre : Polynomial ℚ := C 4 + C 16 * X + … + C 4 * X ^ 18
theorem z_HM_5_0_A_pre : HM_5_0_A_pre = interpQ 1 [4, 16, …, 4] := by
  refine Polynomial.funext fun r => ?_
  simp [HM_5_0_A_pre, interpQ, toPolyZ, Polynomial.eval_add, …]
  try ring
```

— one shape, ~15,000 Expr nodes each.  `V14Formalization/D12PolyZExpand.lean`
proves the expansion once.  It is one lemma per (length, support) pattern, not
per degree, because the emitter omits zero-coefficient terms so the left-hand
side is sparse and not definitionally the dense sum; 153 patterns cover all
3,053 rewritable bridges.  Generated and applied by
`scripts/interpq_expand_rewrite.py`.

  * isolated degree-18 case: 14,784 nodes -> 152 (97x)
  * `D12SigmaPlusSegreHM_5_0`: 82,333 -> 8,116 (10.1x)
  * `D12SigmaPlusSegreVQ_4_8`: 61,668 -> 21,574 (2.9x)
  * families: HM 21.1M -> below the reporting floor, VQ 20.4M -> 4.5M
  * shared lemma module: 1.52M nodes, paid once


## How it was done (for anyone converting more files)

Convert a file only when all its project imports are converted; the waves
below are just a topological order of that constraint.

1. 13 leaves, by hand (Basic, BiprojectiveIntegral, CentralizerD12,
   D12PolyZReflection, D12PolynomialCore, D12SealData,
   EllipticPolynomialConstancy, MultiProjectiveZeroLocus, PSLCard,
   ProjNaturality, SchemeBaseChangeAction, SchemeEquivariant, WeilRep).
2. The Piece Split chain (207 files).
3. SigmaMinus / SigmaCarrier / GeneratorSPhase / Compound (85 files).
4. The generated bulk, levels 0-6 of the remaining DAG (658 files), then the
   core chain, levels 7-22 (85 files).
5. The roots: V14Challenge, V14Solution, AxiomAudit.
6. The 322 modules outside the Comparator closure.

Waves 4-6 were done with one build each, not one build per file: run
`module_stage_tool.py gen-config --narrow-expose` over the whole wave, apply
with `module_migrate.py`, build once, and fix what the build actually
complains about. Wave 4's 658 files needed exactly one static fix before the
build went green.

The tools:

* `scripts/module_stage_tool.py gen-config [--narrow-expose] <files.txt> <cfg>`
  — computes `public` from downstream usage and `expose` from observed defeq
  contexts. **Always pass `--narrow-expose`.** Without it the config falls
  back to the old posture of exposing every public def.
* `scripts/module_migrate.py <cfg>` — applies a config, idempotently. Keys:
  `public`, `expose`, `no_expose` (strip an exposure), `no_public` (strip a
  publication), `import_all` (allow-list; must stay empty).
* `scripts/module_stage_tool.py fix <cfgs...> <lake-log>` — grows a config
  from build errors. Read its output before applying it: it infers a
  declaration name from the error text and can pick the wrong module.
* `scripts/check_module_invariants.sh` — the gate. Run it after every change.

## Two failure modes that `lake build` does not catch

Both have happened here. Both are why the gate script exists.

1. **The published theorems can silently disappear.** They are declared in
   BOTH roots — that is what a challenge/solution pair is — so any heuristic
   keyed on "this name is declared in more than one module" will try to demote
   them, and no module imports a root, so the build stays green while the
   published surface empties. `module_migrate.py` now hard-refuses to demote
   `noEquivariantRationalMap_from_ambient` and
   `noEquivariantRationalMap_projectiveGVariety`.
2. **`import all` can come back through the emitters.** The applier INSERTS
   from the config's `import_all` key, and every emitter re-runs the applier
   via `reapply_module_annotations()`. A stale key meant regenerating any
   generated family would silently restore all 82 lines. The key is empty and
   the applier now strips any `import all` not listed in it.

Related, and the reason to re-run the collision sweep before each wave: a
name declared `public` in two modules cannot be imported into one
environment (`environment already contains 'Foo.G'`), and a legacy `private`
declaration of that name downstream fails with `a non-private declaration has
already been declared`. Module-private names do not collide — verified.

## `public` means "a cross-module consumer needs this"

The usage scan matches a declaration's LAST NAME COMPONENT, which is wrong
whenever sibling modules declare the same name in different namespaces:
`quotient_0` lives in 35 modules, so every importer that mentions the token
looked like a consumer of all 35. That published 500 declarations nobody
outside their module can even name — `D12CompoundRRow0` published all 16 of
its declarations when `D12CompoundR` consumes exactly one.

Those are demoted, recorded as `no_public`. If you regenerate a config, re-run
the namespace-aware check: a name declared in more than one module counts as
used by importer `I` only if `I` mentions it qualified, or if exactly one
module in `I`'s import closure declares it. Two things must override the
demotion, and both were found the hard way:

* the in-file closure — an exposed def's body may only reference public
  names, so `XRow0` stays public for `XVec` even though no importer names it;
* whatever the build then rejects (3 names, in one round).

The widest public surfaces left are the pure data modules —
`D12SigmaPlusSegreQplus` (946 of 946), `D12SigmaPlusSegreMinorQ` (568 of
568), the four `D12Piece*Data` (~486 of 487). These are coefficient tables
whose every entry is consumed by a certificate that must unfold it; the
surface is wide because the module genuinely is an interface. By contrast the
generated certificate modules publish one theorem each: `D12PieceAASplitRow0`
is 1 public of 591 declarations, `D12SigmaMinusReverse1` 1 of 257.

