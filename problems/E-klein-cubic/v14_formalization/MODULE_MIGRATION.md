# The module system in this project (Lean 4.32.1)

**The migration is finished.** This document describes the state of the tree
and the rules that keep it that way; it is no longer a plan. Read
"Where things stand" first, then the sections that apply to what you are
changing.

## Where things stand (2026-08-18)

| | |
|---|---:|
| `module` files | 1,376 |
| legacy files remaining | 34 |
| Comparator closure converted | 1,052 / 1,052 |
| declarations | 101,084 |
| ... `public` | 17,059 (16.9%) |
| ... `@[expose]` | 4,769 (4.7%) |
| ... module-private | 84,025 (83.1%) |
| modules publishing at most one declaration | 1,005 of 1,376 |

(Counts are from one parser run over the tree, so before/after figures in this
document are comparable to each other; they sit a little under a raw
`grep -c '@\[expose\]'`, which also sees attribute lines that are not
declaration heads.  At the start of 2026-08-18 the same parser read 11,038
`public` / 6,930 `@[expose]`.  The session moved every coefficient table it
touched from "exposed def" to "published equation": BezoutData and Partials
(312), then the four Piece*Data (1,848).  `public` rose because each table now
publishes the facts its consumers used to obtain by unfolding — that is the
trade, and it is the right way round: a published equation is an interface, an
exposed body is not.)

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
| legacy (`import V14Solution`) | 598,978 | 3.50 GB |
| module (`public import V14Solution`) | 417,189 | **1.88 GB** |

(2026-08-17 figures were 589,728 / 3.77 GB and 413,384 / 2.08 GB; both sides
dropped ~0.2 GB when the proof terms shrank — see the closure table below. The
constant counts rose by `grind`'s auxiliary lemmas and by the published
projection equations, neither of which the RSS noticed.)

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
* **In the DEFINING module, a tactic-mode public theorem needs no exposure
  at all** — this is what makes de-exposing a table possible, and it was
  verified in isolation on 4.32.1 (`.probe/`, four four-line files):

  | where | proof | def exposed? | result |
  |---|---|---|---|
  | defining module | `:= rfl` | no | **fails**, "this theorem is exported … must be exposed" |
  | defining module | `:= by rfl` | no | compiles |
  | defining module | `:= by simp [f]` | no | compiles |
  | consumer | `:= rfl` | no | fails |
  | consumer | `:= by rfl` | no | fails |
  | consumer | `simp [f]` | no | fails, "Expected a definition with an exposed body" |
  | consumer | `rw [thm]` on a public theorem | no | compiles |

  So a reduction that lives in a consumer forces exposure, and the *same*
  reduction relocated into the defining module and exported as a theorem
  does not.
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
the arrays via `rfl`/`decide`, which need bodies at elaboration time — unless
the module is converted to publish equations instead (see "De-exposing a
table").

### FOUR EMITTERS ARE STALE — THREE REFUSE TO RUN (2026-08-18)

`scripts/export_sigma_plus_span.py`, `scripts/export_sigma_plus_tinv.py` and
`scripts/export_sigma_plus_span_identities.py` now **exit 2** with an
explanation rather than corrupting the tree; `--emitter-is-current` re-enables
one, for whoever re-derives it and can first show a byte-identical round-trip.
A fourth, `scripts/export_sigma_plus_minor_h.py` (the HM family), is stale in
the same way and is not yet guarded: its output predates
`transform_vqhm_reflection.py` and `interpq_expand_rewrite.py`, so it emits the
pre-`interpQ` proofs and none of the `z_*` bridges. Re-deriving these means
wiring their post-passes into the emitter, not rewriting the emitter: the
pipeline is emitter + `transform_vqhm_reflection.py` +
`interpq_expand_rewrite.py` + `ring_to_grind_rewrite.py` + the annotation hook,
and only the first stage is in `main()`. The passes are not parameterised on an
input directory, which is the work.

They still emit the proofs their outputs had **before** the
integer-interpolation rewrite. Running any of them
over `V14Formalization/` reverts that work — measured, on 2026-08-18: 243, 273
and 614 tracked files rewritten back to `simp (disch := decide) only [interp_mul,
…]` / `apply interp_eq` / `· decide` shapes, plus **378 files created that are no
longer part of the tree at all** (an `MH_*` family, `Apply_minorQ`, …). The
in-tree sources are the authority for those families; use a post-pass
(`ring_to_grind_rewrite.py`, `table_interface_rewrite.py`) instead, and if an
emitter must be changed, first check that it round-trips: emit in place with the
emitter unchanged and require `git diff` to be empty. `export_sigma_plus_identities.py`
does round-trip byte-for-byte and is safe.

### The post-emit annotation hook was broken in nine emitters (fixed 2026-08-18)

Every emitter ends with

```python
if __name__ == "__main__":
    main()
    sys.path.insert(0, …)
    from module_annotation_hook import reapply_module_annotations
    reapply_module_annotations()
```

but nine of them never imported `sys`, so the hook raised `NameError` after the
files were already written and **every regeneration silently dropped `module`,
`public` and `@[expose]`**. `lake build` would then fail, but only after the
tree had been rewritten. The line now reads `__import__("sys").path.insert(…)`,
which cannot depend on the emitter's imports. Verified by regenerating the
identity modules with the emitter otherwise unchanged: byte-identical to the
tree, annotations and all.

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
| after `ring` -> `grind` (2026-08-18) | 162,545 | 139.9M | 66.5M |
| after de-exposing BezoutData + Partials | 162,794 | 140.0M | 66.5M |
| after removing 1,100 `change`s | 163,796 | 140.2M | 66.6M |
| after the SplitRow redesign + de-exposing Piece*Data | 166,352 | 143.2M | 67.8M |
| after converting VQ / HM `change` | 166,991 | **143.5M** | **68.1M** |

Net for 2026-08-18: **177.6M -> 143.5M, -19.2%**, and `@[expose]` 7,093 -> 4,769.
The last two rows are the exposure work paid for on the export: +3.35M, +2.4%,
in exchange for 1,848 exposures and certificates that no longer reach through a
table's body.  At ~85 bytes/node the export is ~12.2 GB against the 15 GB
runner.

Publishing 312 defining equations cost 94,222 nodes, +0.07% — the de-exposure
is very nearly free on the export, which is the reason to prefer it to leaving
a table exposed.

The migration row is the point of the framing: converting 1,049 further modules
moved the closure by 700 nodes out of 177.6M. Visibility annotations do not
change proof terms, so the migration is worth doing for the code, not for the
export — while an importer of `V14Solution` did go from 3.77 GB to 2.08 GB.

Net for the session: **-31.8%** on the metric the baseline used. The SplitRow
reconstruction is exact for the part it changed — the four families measured
54.1M before (1.360M / 1.362M / 1.273M / 1.418M per representative module x 10)
and 4.7M after. The Segre step is measured end to end, before and after, on the
same tree.

At the baseline's ~85 bytes/node, 177.6M was ~15.1 GB of export against a 15 GB
runner: at the line, without margin, and Comparator holds its own ~12 GB
concurrently with `lean4export` (see the 2026-08-15 OOM log). 140.0M is
~11.9 GB — the first time this proof has had margin. What was left as of
2026-08-17, and what happened to it:

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
over the `Polynomial.eval_*` lemmas, then `ring`, per identity. That is the
table as it stood on 2026-08-17; **it has since been fixed by replacing one
tactic** — see below. Compound and the two `relation_*` families are genuine
per-instance rational arithmetic over 1/11 denominators and need the
`ℤ`-rescaling treatment described in CERTIFICATE_COST_2026-08-16.md, which is
a larger job, and they are now the top of the table.

### `ring` -> `grind` on the pointwise-eval identities (2026-08-18)

`ring` reflects the goal and inlines its whole normalisation trace into the
proof term. `grind` closes the same goals through its own commutative-ring
solver and stores a far smaller certificate. The substitution is one word per
proof; nothing else changes.

Pilot, `D12SigmaPlusSegreNH_0_0` built standalone before and after:

| | constants | per-module nodes | per-constant nodes | elaboration |
|---|---:|---:|---:|---:|
| `try ring` | 126 | 163,531 | 329,763 | 8.05 s |
| `try grind` | 140 | 38,883 | 121,223 | 8.07 s |

-63.2% per-constant, -76.2% per-module, no measurable time cost. The extra 14
constants are `grind`'s `_proof_*` auxiliaries; every original theorem is
present with its original statement.

Rolled out to the 190 closure modules that use the idiom (4,613 tactic lines).
Per family, closure per-constant nodes:

| family | before | after | |
|---|---:|---:|---:|
| LH | 12,150,693 | 4,283,134 | -64.7% |
| Det | 11,374,397 | 3,399,255 | -70.1% |
| SmoothCU | 7,447,251 | 2,372,760 | -68.1% |
| SmoothCV | 7,461,483 | 2,570,086 | -65.6% |
| SmoothCW | 7,454,015 | 2,556,173 | -65.7% |
| NH | 5,799,219 | 2,025,214 | -65.1% |
| PolyZExpand | 1,521,882 | 324,081 | -78.7% |
| MinorQZ | 1,538,739 | 785,751 | -48.9% |
| SpanVZ | 825,042 | 419,999 | -49.1% |
| Qrel | 2,006,057 | 1,506,600 | -24.9% |
| ApplyHZ | 472,491 | 246,916 | -47.7% |
| QplusZ | 248,649 | 152,535 | -38.7% |
| LK / NK / Bplus | unchanged | | `simp` already closed those goals, so neither tactic ever ran |

**Whole closure 177.6M -> 139.9M, -21.2%.** At ~85 bytes/node that is ~15.1 GB
of export -> ~11.9 GB, i.e. the first version of this proof with actual margin
under the 15 GB runner.

What `grind` will *not* do here, tested and recorded so nobody repeats it:

* `grind [defs…]` straight at the `Polynomial ℚ` identity — fails
  (maximum recursion depth, and raising `maxRecDepth` does not help);
* `grind` after `simp only [defs]` but before the eval-simp — fails;
* `grind [Polynomial.eval_add, …]` in place of the eval-simp — fails;
* plain `ring` at the polynomial level without `Polynomial.funext` — fails,
  since `C 2 * C 3` and `C 6` are unrelated atoms.

Only the last tactic can change: keep `refine Polynomial.funext fun r => ?_`,
keep the `simp only [defs]`, keep the eval-simp, and swap `try ring` for
`try grind`. Carried by `scripts/ring_to_grind_rewrite.py` for the frozen
families, and directly by `scripts/export_sigma_plus_identities.py` for LH/NH.

The 315 UM modules use the same idiom and are deliberately NOT converted: they
are outside the `V14Solution` import closure entirely, so the rebuild moves the
export by nothing. `Smooth{U,V,W}Prod` and `SpanV_0_0` are not converted either
— they have never compiled, so the change would be unverifiable.

**The integer-interpolation port is no longer the next step for these four
families.** It was the plan on 2026-08-17, on the assumption that only a change
of route could shrink them; one tactic did two thirds of it at a fraction of the
cost. The remaining `interpQ` work belongs to Compound and the `relation_*`
families, which `grind` does not address.

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
  It is a **zsh** script (`print`, not `echo`); running it under `bash` fails
  with `print: command not found` on every line.
* `scripts/table_interface_rewrite.py --table <f> --consumers <f…>` — converts
  a coefficient table from "exposed bodies" to "published equations" and
  rewrites its consumers. Refuses to write if any line outside the rewritten
  tactics changed.
* `scripts/ring_to_grind_rewrite.py <files…>` — `try ring` -> `try grind` in
  the frozen pointwise-eval families, with the same statement-preservation
  check. `--check` reports without writing.
* `scripts/module_stats.lean` — per-module proof-term size, the cheap
  counterpart of `closure_stats.lean`:
  `lake env lean --run scripts/module_stats.lean V14Formalization.<M> …`.
  Use it to measure one file before paying a closure rebuild.

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

## De-exposing a table (2026-08-18)

### There is no annotation slack left — checked, twice

Re-running `module_stage_tool.py gen-config --narrow-expose` over the ten
widest data modules reproduces **exactly** what is annotated today (946/946,
568/568, 486/486, 465/465, 465/465, 432/432, 438 public + 431 exposed, 406/406,
406/406, 255/255). Nothing in those modules is public or exposed by accident.
Splitting the 4,860 exposures into what a downstream reduction actually names
versus what the in-file closure then drags along:

| module | exposed | demanded downstream | in-file cascade |
|---|---:|---:|---:|
| `D12SigmaPlusSegreQplus` | 946 | 946 | 0 |
| `D12SigmaPlusSegreMinorQ` | 568 | 568 | 0 |
| `D12PiecePPData` | 486 | 302 | 184 |
| `D12PieceAAData` / `APData` | 465 | 306 | 159 |
| `D12PiecePAData` | 432 | 300 | 132 |
| `D12SigmaPlusSegreCore` | 431 | 302 | 129 |
| `D12SigmaPlusSegreSpanU` | 406 | 292 | 114 |
| `D12SigmaPlusSegreSpanV` | 406 | 406 | 0 |
| `D12SigmaPlusSegreBezoutData` | 255 | 210 | 45 |

Every cascade root is itself demanded (`AVec`, `XVec`, `spanU`, `Qplus`,
`minorQ`), so the cascade cannot be cut without cutting the root. **Exposure
here is load-bearing; the only way down is to move the reduction.**

### The recipe, and what it costs

`scripts/table_interface_rewrite.py`. The table publishes one equation per
definition, tactic-proved so it needs no exposure of its own, and drops
`@[expose]`:

```lean
public def CU_0_re_002 : Polynomial ℚ := C (…) + C (…) * X ^ 2 + …
public theorem CU_0_re_002_def :
    CU_0_re_002 = C (…) + C (…) * X ^ 2 + … := by
  rfl
```

Consumers rewrite with the theorem instead of unfolding the definition:
`simp only [X]` -> `simp only [X_def]`, `rw [X]` -> `rw [X_def]`,
`unfold X` -> `rw [X_def]`, and `theorem … : X = e := rfl` -> `:= X_def`.
The pass refuses to write unless every line it did not deliberately rewrite
survives byte-for-byte. Record the result in the stage config's `no_expose`
key, or the next emitter run puts `@[expose]` back.

Done for `D12SigmaPlusSegreBezoutData` (255 -> 0 exposed, 80 consumers) and
`D12SigmaPlusSegrePartials` (57 -> 0, 74 consumers). Tree-wide `@[expose]`
6,930 -> 6,618; `@[expose]` as a share of public 62.8% -> 58.3%.

### The remaining tables, and why each is still exposed

The blocker is never the table; it is the number and shape of the reductions
that would have to move. Consumer counts are modules that name the table:

| table | exposed | consumers | why it is still exposed |
|---|---:|---:|---|
| `D12SigmaPlusSegreQplus` | 946 | 521 | Qrel (15) + VQ (189) + UM (315) all `simp only` the entries; UM alone is 315 modules and is outside the `V14Solution` closure, so the rebuild buys nothing for the export |
| `D12SigmaPlusSegreMinorQ` | 568 | ~694 | same, plus HM (189) |
| `D12SigmaPlusSegreSpanU` / `SpanV` | 406 + 406 | ~330 each | driven by UM (315, outside the closure) and by the 24 `Apply_span{U,V}` shards, which have never compiled |
| `D12SigmaPlusSegreCore` | 431 | 899 | the most-imported module in the tree; also holds `Ki`, `ofLadj`, `k` — structural definitions where an `_def` equation is meaningless, so the pass would need a name filter |
| `D12Piece{PP,AA,AP,PA}Data` | 1,848 | 34 each | **bounded, and the next one worth doing** — but the `ActionRow` proofs are `change ACell0_0 = RMVec 0 0 - constVec (-1)`, and `change` needs defeq on both sides of the goal, which no published equation supplies. Those proofs have to be restructured first, not just their tactic arguments rewritten. |

The Piece data modules looked like the largest bounded prize left (1,848
exposures, 135 consumers). The `change`-shaped proofs were converted — and the
de-exposure still does not go through. See the next section.

## `change` in generated proofs (2026-08-18)

`change` is a defeq context: it makes the elaborator reduce the *whole* goal,
so every definition in the statement must be unfoldable whether or not the
tactic text names it. That is why it pins `@[expose]` on things the proof never
mentions. Two generated families used it uniformly and were converted:

| family | occurrences | was | now |
|---|---:|---|---|
| the 80 `D12Piece*ActionRow*` | 800 | `change ACell0_0 = RMVec 0 0 - constVec (-1)` | `rw [AVec_apply_0_0, characterStackVec_apply_0_0]` |
| the 40 `D12Piece*SplitRow*` | 300 + 100 `unfold matrixMul` | `change (∑ k, mul (XVec 0 k) (AVec k 0)) + … = _` | `rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]` |

The equations they rewrite with are published from the modules that own the
definitions — `characterStackVec_apply_{i}_{j}` and `matrixMul_apply` are proved
once instead of once per certificate — and are emitted by
`export_d12_piece_vec_lean.py` / `export_d12_nonzero_piece_vec_lean.py`
(both round-trip byte-for-byte, checked before editing) and by
`scripts/change_to_rewrite.py` for the SplitRow files, whose SplitEntry shards
are no longer in the tree.

### `change` does NOT cost proof-term size — measured

This was the reason to expect a second payoff, and it is wrong:

| | constants | per-constant nodes |
|---|---:|---:|
| before the `change` removal | 162,794 | 140,034,124 |
| after (1,100 occurrences) | 163,796 | **140,165,930** |

**+131,806 nodes, +0.09%.** Every ActionRow family went up 0.6%, every SplitRow
family 0.4-1.0%, plus 82,592 for the 200 new `characterStackVec_apply` lemmas
in `D12PieceVecBase`. That is the expected direction once stated plainly:
`change` is a type ascription, so it leaves *no* term-level artifact, while
`rw` inserts a real `Eq.mpr` and its motive. The `v14/expose-pilot` bloat that
`funext`/`fin_cases`/`change` were blamed for jointly was `fin_cases` — it
inlines a `List.Mem.casesOn` over `List.finRange 10` into every coordinate
case. `change` was innocent.

So removing `change` is worth doing for the interface it unpins, not for the
export. Where it unpins nothing, leave it.

### The Piece*Data de-exposure: done (2026-08-18)

All four tables are now 0% `@[expose]` — 1,848 exposures removed, tree-wide
6,618 -> 4,769, and `@[expose]` falls from 50.0% to 28.0% of public.

The blocker was not `change`.  It was that each of the 16,800
`{X,A,K,Y}Z_scale_*` certificates passed its ten coordinate equations to
`toVec_eq_smul10` as *term-mode arguments*, and every argument's expected type
mentions the cell:

```
eq_smul_div (-15) scale (-15) 44 …  :  ↑(-15) = ↑scale * (↑(-15) / ↑44)
expected                            :  ↑(XZ 0)[0] = ↑scale * XCell9_0 0
```

so each one only typechecked if the cell body reduced.  No partial exposure
helps — the 16,800 cover every cell of every table.

The fix is a different characterisation.  The table publishes, once per cell,
the fact the certificates actually need:

```lean
public theorem XCell0_0_scaled :
    toVec #v[-73, -117, …] = ((66 : ℤ) : ℚ) • XCell0_0 :=
  toVec_eq_smul10 #v[-73, -117, …] 66 XCell0_0 (eq_smul_div …) …
```

and each certificate collapses to one application of a shared lemma whose only
remaining content is an integer identity that `rfl` discharges:

```lean
theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell0_0 :=
  toVec_eq_smul_of_scaledZ (XZ 0) scale XCell0_0_scaled (by decide) rfl
```

`toVec_eq_smul_of_scaledZ` (D12VecScaleIntro) does the `d ≠ 0` cancellation
once; `smulZ` / `toVec_smulZ` (D12CyclotomicVecZ) are new.  The ten
`eq_smul_div` certificates are paid 1,848 times instead of 168,000.  The
aggregate `*Z_scale` lemmas, which are stated about `XVec i k` rather than the
cell, are carried across by `toVec_smul_congr` applied to the table's published
entry equation, replacing a `simp [XVec, XRow6]`.

Two things the tables also publish, for the other consumers:

* `{A,X,K,Y}Vec_apply_{i}_{j}` — the entry equations, used by the ActionRow
  certificates and the `*Z_scale` aggregates;
* `…Cell{i}_{j}_def : … = ![…]` — the flat value, which the evaluating
  consumers (`norm_num [ACell0_0_def, …]`) rewrite with.  Measured on one cell,
  module importer, project constants only: exposed def 2 constants / 380 Expr
  nodes; def + ten point equations 11 / 134; def + one flat equation 2 / **107**.
* `KVec_col{j}` — a binder-friendly form, because the Plucker certificate
  rewrites `KVec k 0` under a `∑ k : Fin 10` where per-index equations cannot
  fire: after `Fin.sum_univ_succ` the index reads
  `(Fin.succ 2).succ.succ.succ.succ`, which matches no numeral.  (`Fin.sum_univ_ten`
  does not exist in this Mathlib.)

Generated source drops 104,090 lines.  Two things that did NOT work, recorded so
they are not retried:

* naming the integer numerator vector in the data module, to keep the `#v[…]`
  literal out of 16,800 proof terms: **`decide +kernel` cannot unfold a `public`
  def that is not `@[expose]`d**, so it trades 1,848 table exposures for 1,848
  exposed integer vectors.  The literal stays.
* `decide +kernel` for the integer identity at all: `rfl` is both smaller and
  sufficient, since `eqZ` and `smulZ` are coordinatewise and evaluate.  Measured
  on D12PieceAASplitRow0: 151,665 -> 111,493 per-constant nodes.

### What it cost on the export

| | constants | per-constant nodes |
|---|---:|---:|
| before the redesign | 163,796 | 140,165,930 |
| redesign, `decide +kernel` | 183,152 | 145,029,498 |
| redesign, `rfl` | 166,352 | **143,200,858** |

**+3.03M, +2.2%.**  The certificates got smaller and the tables got bigger: the
`_scaled`, `_def` and `_apply` equations are new constants in the closure, and
the four data modules go from below the reporting floor to ~2.6M between them.
De-exposure is not free on the export; it is worth it for the interface, and
~12.2 GB still leaves margin under the 15 GB runner.

### The old obstruction, for the record

Attempted and reverted, with the errors recorded. With `@[expose]` stripped
from all four tables the ActionRow certificates are fine — that was the point
of the conversion — and the failures are all in the SplitRow certificates:

```
Application type mismatch: the argument
  eq_smul_div (-15) scale (-15) 44 ?m.20 ?m.21
has type      ↑(-15) = ↑scale * (↑(-15) / ↑44)
but is expected to have type
              ↑(XZ 0)[0] = ↑scale * XCell9_0 0
Note: The following definitions were not unfolded because their definition is
not exposed:  XCell9_0 ↦ 48
```

`toVec_eq_smul10` takes the ten coordinate equations as *term-mode arguments*,
and each argument's expected type mentions `XCell9_0 0`, which only typechecks
if the cell body reduces. There are **16,800** such `{X,A,K,Y}Z_scale_*`
theorems across the 40 SplitRow modules, covering essentially every cell of
every table, so no partial exposure helps.

The fix is not another tactic swap; it is a different characterisation. Each
cell is a scaled integer vector, and the data module could publish that
directly:

```lean
public theorem XCell0_0_scaled : XCell0_0 = (1 / 66 : ℚ) • toVec #v[-73, -117, …]
```

which replaces the ten `eq_smul_div` arguments with one rewrite and one shared
lemma — smaller certificates *and* a de-exposed table. That is a redesign of
the SplitRow certificate shape and interacts with `splitrow_intro_rewrite.py`,
so it belongs in its own pass with its own measurement.

Measured, for whoever picks that up — one cell, module importer, project
constants only:

| table encoding | importer constants | importer Expr nodes |
|---|---:|---:|
| `@[expose] public def` (today) | 2 | 380 |
| `public def` + ten point equations | 11 | 134 |
| `public def` + one flat `![…]` equation | 2 | **107** |

De-exposing a match-defined cell is a real 3.6x saving in what an importer
loads, not a cosmetic one — the exposed form drags in the matcher and the
equation lemmas. The one-flat-equation encoding is the one to use.

### The `change` residue, and why each part of it stands

**995 occurrences remain**, down from 2,173 at the start of 2026-08-18:
ActionRow 800 -> 0, SplitRow 300 -> 0, VQ 189 -> 0, HM 378 -> 189.

| where | count | why it stands |
|---|---:|---|
| `D12SigmaPlusSegreHM`, first of two per module | 189 | It reshapes the *result of a `simp`* into an explicit `bilinearCoeffs (Hrow 0) (Hrow 4) 0 - …` expression. There is no stated equation to rewrite with: the goal simp leaves is only *defeq* to the target, and nothing names its shape. Converting it means pinning down that simp normal form, which is a separate piece of work. The second `change` per module is gone — it is now `rw [minorQ_apply_0_0]`. |
| `D12SigmaPlusSegreUM` | 315 | outside the `V14Solution` import closure entirely. |
| hand-written, ~60 modules | ~490 | `GeometricVCarrier` 100, `BiprojectiveFunctionFieldProjection` 31, `PSLCard` 29, `ProjectiveEigenvectorReduction` 25, … Authored proofs, not emitter output. |

Deriving the entry equations for VQ turned up the root cause of a
long-standing defect: `D12SigmaPlusSegreApply_span{U,V}_*` — 24 of the 34 files
that have never compiled on any branch — say `unfold spanV spanV_row0`, while
`spanV` is a single two-dimensional `match` with no `spanV_row*` anywhere in
the tree. They were meant to be the `spanV_apply_{i}_{j}` lemmas. Derived from
the actual definition, in the module that owns the matrix, they are `rfl`
(`scripts/matrix_apply_lemmas.py`); `spanU_apply_*` and `minorQ_apply_*` are
added on the same footing. `Qplus_apply_*` already existed and is live — the
Qrel modules use it — so the VQ modules import it rather than publishing a
second copy, which collides at import time.

The measured rule for the rest: converting `change` to `rw` costs about 120
Expr nodes per occurrence. It is worth doing where it lets a table drop
`@[expose]` — which is what it did for the four Piece*Data — and it is worth
doing for the code, because a proof that depends on how a definition is written
rather than on a stated fact about it is what couples every certificate to a
table's body. It is not a size lever: that was measured and is settled.

