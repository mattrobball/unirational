# The module system in this project (Lean 4.32.1)

**The migration is finished.** This document describes the state of the tree
and the rules that keep it that way; it is no longer a plan. Read
"Where things stand" first, then the sections that apply to what you are
changing.

## Where things stand (2026-08-19)

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

Later on 2026-08-18, retiring the tabulated 15x15 ambient generators (see
"Retiring the 15x15 ambient tables" below) deleted 32 module files and added
one, so `module` files went to 1,345; then deleting the 350 dead files (see
"Deleting the dead files" below) took it to **1,028**, with **one** legacy file
left. The declaration counts in the table predate both changes.

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

The 34 legacy files were exactly the ones that have never compiled, on any
branch: `D12SealProof` (deterministic whnf timeout at `L₀_mul_B₀`), the 24
`Apply_span{U,V}` shards that reference `spanU_row*` / `spanV_row*` lemmas
defined nowhere in the tree, the 3 `Smooth{U,V,W}` files whose
`Ambiguous term C/X` reproduces with pure Mathlib imports, and 6 aggregators
and shards that import them. None has ever had an olean. 33 of the 34 were
deleted on 2026-08-18 ("Deleting the dead files"); only `D12SealProof` is
left. A module file may not import a non-module file, so it cannot be
converted until it compiles.
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
| after converting VQ / HM `change` | 166,991 | 143.5M | 68.1M |
| after retiring the 15x15 ambient tables | 163,958 | **133.4M** | **65.0M** |
| deleting the 350 dead files (2026-08-19) | 163,958 | 133.4M | 65.0M |
| sigma carrier eigen-columns -> integer reflection | 163,815 | 128.6M | 61.8M |
| sigma minus normal form -> integer reflection | 163,345 | 111.0M | 53.5M |
| compound restriction -> integer reflection | 163,824 | 98.9M | 47.6M |
| sigma carrier bridge rows -> integer reflection | 163,824 | 91.9M | 43.4M |
| ... including the five dense entries | 163,489 | 86.9M | 41.0M |
| Segre LH / NH -> integer reflection | 163,117 | **82.0M** | **39.2M** |
| Segre Det + SmoothC{U,V,W} -> integer reflection | 162,035 | 72.3M | 34.6M |
| Plucker certificates -> `mul_apply_k` | 162,018 | 65.7M | 31.4M |
| Vec certificates -> `vec_ext` | 162,039 | 63.8M | 30.7M |
| PluckerNaturality -> `fin15_cases` | 162,055 | **62.8M** | **30.5M** |

Net for 2026-08-19: **133.4M -> 82.0M, -38.5%** — see "The integer reflection,
applied everywhere" below. At ~85 bytes/node the export is ~7.0 GB against the
15 GB runner, which is the first time this proof has had a factor of two of
margin rather than a sliver.

Net for 2026-08-20: **82.0M -> 62.8M, -23.5%** per-constant; 39.2M -> 30.5M,
-22.2% per-module. See "Finishing the reflection, and the two `fin_cases`
lemmas" below. At ~85 bytes/node the export is ~5.3 GB.

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
| Compound{R,F}Row | 2,010 | 19.6M | 11.1% | `norm_num` + `linear_combination` — now 14.5M, see below |
| SigmaPlusSegreSmoothC{U,V,W} | 2,175 | 22.4M | 12.6% | pointwise-eval `simp` + `ring` |
| SigmaPlusSegreNH | 936 | 5.8M | 3.3% | pointwise-eval `simp` + `ring` |

LH, Det, SmoothC* and NH (51.8M, 29%) all prove polynomial identities the
expensive way — `refine Polynomial.funext fun r => ?_`, a full-width `simp`
over the `Polynomial.eval_*` lemmas, then `ring`, per identity. That is the
table as it stood on 2026-08-17; **it has since been fixed by replacing one
tactic** — see below. Compound and the two `relation_*` families are genuine
per-instance rational arithmetic over 1/11 denominators and need the
`ℤ`-rescaling treatment described in CERTIFICATE_COST_2026-08-16.md, which is
a larger job, and they were then the top of the table. Compound has since been
cut by 26% a different way — by deleting the data it was reconciling, not by
making its arithmetic cheaper. The two `relation_*` families still stand and
are now the top of the table.

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

The 315 UM modules used the same idiom and were deliberately NOT converted:
they are outside the `V14Solution` import closure entirely, so the rebuild
moves the export by nothing. `Smooth{U,V,W}Prod` and `SpanV_0_0` were not
converted either — they have never compiled, so the change would be
unverifiable. All of them have since been deleted; see "Deleting the dead
files".

**The integer-interpolation port is no longer the next step for these four
families.** It was the plan on 2026-08-17, on the assumption that only a change
of route could shrink them; one tactic did two thirds of it at a fraction of the
cost. The remaining `interpQ` work belongs to Compound and the `relation_*`
families, which `grind` does not address.

## The integer reflection, applied everywhere (2026-08-19)

**133.4M -> 82.0M per-constant, -38.5%; 65.0M -> 39.2M per-module, -39.6%.**
At ~85 bytes/node the export goes from ~11.3 GB to ~7.0 GB, against a 15 GB
runner that has to hold Comparator's own ~12 GB alongside `lean4export`.

### One mechanism

Every family below proved polynomial identities the same expensive way: unfold
the coefficient tables into `C (a/b) + C (c/d) * X + ...`, then close the goal
with `ring_nf` + 63 `natN_as_C` rewrites + `module`, or with
`Polynomial.funext` + a full-width eval `simp` + `grind`. Both tactics inline
their whole normalisation trace into the proof term, which is why these
families were 50,000-75,000 `Expr` nodes *per certificate*.

`V14Formalization/D12PolyZReflection.lean` -- written earlier for the Segre
families -- already had the alternative: a polynomial is carried as
`interpQ d [n...]`, integer numerators against a positive denominator, and

* `interp_mul` turns a product into an **unevaluated** `convList`,
* `interp_add` / `interp_sub` (equal denominators) and `interp_add_gen` /
  `interp_sub_gen` (mixed) fold a sum into one `interpQ`,
* `interp_eq` reduces the goal to a `List Int` all-zero test that `decide`
  runs in the kernel.

So the proof term carries the input literals and the fold's structure, and
nothing else; the arithmetic happens in the kernel where it costs no nodes.
The work in each family is (i) publish `x = interpQ d [...]` once per table
entry, (ii) rewrite with those instead of unfolding, (iii) fold and `decide`.

| family | before | after | |
|---|---:|---:|---:|
| `D12SigmaMinusReverse` | 18,015,924 | below the floor | |
| `D12SigmaCarrierBridgeRow` | 13,583,171 | below the floor | |
| `D12CompoundRRow` | 7,290,836 | below the floor | |
| `D12CompoundFRow` | 7,227,934 | below the floor | |
| `D12SigmaPlusSegreLH` | 4,283,134 | below the floor | |
| `D12SigmaCarrierPlusCol` | 3,023,561 | below the floor | |
| `D12SigmaCarrierMinusCol` | 2,607,092 | below the floor | |
| `D12SigmaPlusSegreNH` | 2,025,214 | below the floor | |
| `D12SigmaMinusReference` | 808,066 | below the floor | |
| `D12SigmaMinusQuadric` | 580,873 | below the floor | |
| paid back: `D12CompoundBridge` | 134,239 | 1,432,425 | 272 entry bridges |
| paid back: `D12SigmaPlusSegreApplyL` | small | 343,135 | 108 entry bridges |
| paid back: `D12SigmaCarrierS6Explicit` | small | 103,482 | 6 row equations |

Representative single modules, standalone: `D12SigmaCarrierPlusCol0`
605,078 -> 68,245; `D12SigmaMinusReverse0` 1,792,121 -> 195,498;
`D12CompoundRRow0` 471,252 -> 42,384; `D12SigmaCarrierBridgeRow0` 786,660 ->
159,658; `D12SigmaCarrierBridgeRow5` 1,963,815 -> 160,976;
`D12SigmaPlusSegreLH_0_0` ~119,000 -> 22,386.

### Six things that had to be learned

1. **Publish the reflection per ROW, not per entry, wherever the index is
   computed.** In the bridge rows the 6x6 indices arrive as `pairLexVec`
   values, not numerals, so `z_S6_explicit_0_1 : S6_explicit_row0 1 = …` can
   never fire. `z_S6_explicit_row0 : S6_explicit_row0 = fun j => match j.val
   with …` reduces exactly the way unfolding the definition does, and does
   fire. Where the index *is* a numeral (`R6c_0_0`, `of10 RM0c0`) the
   per-entry form is fine and cheaper.
2. **`simp` normalises `a - (b + c)` to `-b + -c`,** so the fold needs
   `interp_neg` or it stops at the first negation.
3. **List `interp_add` / `interp_sub` before the `_gen` versions.** The
   denominator-mixing lemmas multiply denominators, and 15 additions of
   denominator-121 terms would reach 121^15. With the equal-denominator
   lemmas available the fold stays at 121 or 242.
4. **`compute_degree` cannot see through the Horner nesting** that `toPolyZ`
   builds. `natDegree_toPolyZ_lt` / `natDegree_interpQ_lt` prove the sharp
   bound once by induction; `D12SigmaMinusReference` needs
   `disc_poly.natDegree < 10` for `AdjoinRoot.mk_ne_zero_of_natDegree_lt`.
5. **`Polynomial.C_mul` and `map_mul` are simp lemmas in the splitting
   direction,** so `C (1/2) * C 2` will not combine: `simp only [←
   Polynomial.C_mul]` followed by anything that runs the default simp set
   just puts it back. Where a consumer is left holding that residual
   (`D12SigmaMinusAmbient`), the repo's own `C_eq_smul_one` + `module`
   finisher is the thing that closes it.
6. **Numeral coefficients need lemmas of their own**: `interp_zero`,
   `interp_one`, `interp_ofNat`, `interp_pow_two`, so that `2 * p`, `p ^ 2`
   and the `0`/`1` right-hand sides stay foldable.

### Emitters

All changes are emitter changes, and each emitter was checked to round-trip
byte-for-byte first (modulo the annotation hook, which only runs on an
in-place emit):

* `scripts/export_sigma_carrier_lean.py` -- core tables, eigen columns,
  bridge rows, the explicit 6x6.
* `scripts/export_sigma_minus_normal_form_lean.py` -- the whole minus packet.
* `scripts/export_d12_compound_lean.py` -- the 600 compound certificates and
  the shared bridge.
* `scripts/export_sigma_plus_identities.py` -- LH / NH and the L / N entry
  bridges.

One consumer, `D12SigmaPlusSegreBplus`, belongs to a **stale** emitter
(`export_sigma_plus_span.py`, which refuses to run). It is handled by
`scripts/interp_simp_arg_rewrite.py`, a strict idempotent post-pass that adds
`interpQ, toPolyZ` to the simp lists that name a reflected table and refuses
to write if a statement line would change -- the remedy MODULE_MIGRATION
already prescribes for stale families.

`emit_split_bridge_relation` in the carrier emitter is now unreachable
(`if False and …`, with the reason in a comment): it chunked the quotient into
five-degree windows so that no tactic saw both the degree-35 raw entry and the
full quotient, and the reflection makes that unnecessary. It is kept rather
than deleted because it is the only record of why those five entries were
special.

### What is left, and what the numbers say about the two proposals it came from

The brief that drove this session proposed two separate levers. Both were
checked against measurement, and the measurement changed the answer.

**"Halve the field degree on the sigma side" (estimated -13 to -17%).** The
field claim is TRUE and was verified first, over the whole packet: every one
of the 1,938 field elements in `Bplus_15x6`, `Bminus_15x4`, `Lplus_6x15`,
`Lminus_4x15`, `S15x15`, `P15x15`, `Pplus15x15`, `Pminus15x15`, the 30
restricted Plucker quadrics and the entire minus normal-form packet is fixed
by `z -> z^-1`, i.e. lies in the degree-5 real subfield `Q(z + z^-1)`. The one
exception is `R15x15` (205 of its 225 entries are not real), which is not part
of that packet. Verified independently in Python from
`results/sigma_normal_form_K.json`.

It is nevertheless **not the lever to pull**, for two measured reasons:

* The estimate assumed the arithmetic stayed on `ring_nf` + `module`, where
  cost scales with the number of coefficient products. Under the integer
  reflection the products are unevaluated `convList` terms, so halving the
  coefficient count halves *literals*, not traces. The whole sigma carrier +
  sigma minus side is now **4.28M nodes, 5.2% of the closure**; halving its
  lists could reach ~2M, i.e. about 2%, not 13-17%.
* It would break the one place that genuinely needs `Q(zeta)`. The bridge
  rows identify `Srestricted_poly`, built from `compound2Lex S6_poly`, with
  its reduced representative, and `S6 = g^-1 M_0` with `g` the Gauss sum is
  *not* real. Moving the reduced side to a degree-5 variable `Y` would need
  `evalPolyAt z p = evalPolyAt (z + z^10) q` per entry, i.e. a degree-40
  composition certificate for each of 100 entries. The exterior square squares
  the Gauss sum out, which is exactly why everything *else* is real -- and
  exactly why the bridge is not.

**"Replace `split_identity` with `A·K = 0` plus a mod-23 rank certificate"
(estimated -2 to -3%).** Not attempted; the measured prize today is the four
`D12Piece*SplitRow` families at **4,351,115 nodes, 5.3% of the closure**. It
is the only one of the proposals that is a change of *proof architecture*
rather than of arithmetic, and it needs three layers the tree does not have:
rank-nullity over `Omega` relating `finrank (ker A.mulVec)` to a right
inverse, a ring hom `Z[zeta] -> F_23` applied to matrices with
`RingHom.map_det`, and an 8x8 `Matrix.det` reduced by `decide` over `ZMod 23`
(`Finset.univ : Finset (Equiv.Perm (Fin 8))` has 40,320 elements, which is
where that plan is most likely to fail). The cheap-looking substitute -- an
explicit right inverse instead of a determinant -- is not cheaper: it is
64-100 entries per piece against `split_identity`'s 100, so it saves nothing.
Whoever picks this up should cost the `decide` on the `ZMod 23` determinant
*first*.

### The families still above the reporting floor

| family | per-constant | share | shape |
|---|---:|---:|---|
| `D12SigmaPlusSegreVQ` | 4,745,143 | 5.8% | partly reflected already; the `interpQ` bridges exist, the `Qrel`-side sums do not use them |
| `D12SigmaPlusSegreDet` | 3,399,255 | 4.1% | `Polynomial.funext` + eval `simp` + `grind`; **no emitter in `scripts/`** |
| `D12PiecePPCoeffProduct` | 3,179,221 | 3.9% | |
| `D12SigmaPlusSegreSmoothC{U,V,W}` | 7,531,419 | 9.2% | same idiom as Det; **no emitter in `scripts/`** |
| `D12PiecePPDeterminant` | 2,287,031 | 2.8% | `detTriple*_apply`, ~200k each |
| `PluckerNaturality` | 2,216,648 | 2.7% | hand-written |
| `D12SigmaPlusSegreHM` | 2,132,097 | 2.6% | |
| `D12PiecePPCoeff` | 2,099,863 | 2.6% | |
| the four `D12Piece*SplitRow` | 4,351,115 | 5.3% | the `split_identity` families above |

Det and SmoothC{U,V,W} are 10.9M between them, 13.3%, and are the same
pointwise-eval shape that fell by 81% in LH/NH. Their emitters are not in the
tree, so converting them means a post-pass in the shape of
`interp_simp_arg_rewrite.py`: parse the `def NAME : Polynomial Q := C (..) + …`
bodies, emit a bridge module, rewrite the proofs, and refuse to write if a
statement line changes. That is the largest remaining bounded prize.

**That was done on 2026-08-20, along with three other families — see below.**

## Finishing the reflection, and the two `fin_cases` lemmas (2026-08-20)

**82.0M -> 62.8M per-constant, -23.5%; 39.2M -> 30.5M per-module, -22.2%.**
At ~85 bytes/node the export goes from ~7.0 GB to ~5.3 GB.

Four steps, each measured, built and committed on its own.

| family | before | after | |
|---|---:|---:|---:|
| `D12SigmaPlusSegreDet` | 3,399,255 | 401,588 | |
| `D12SigmaPlusSegreSmoothC{U,V,W}` | 7,531,419 | 774,950 | |
| `D12PiecePPCoeffProduct` | 3,179,221 | 535,915 | |
| `D12PiecePPDeterminant` | 2,287,031 | 443,904 | |
| `D12PiecePPCoeff` | 2,099,863 | 415,919 | |
| `PluckerNaturality` | 2,216,648 | 1,200,054 | |
| the four `D12Piece*ActionRow` | 5,493,931 | 3,599,707 | |
| `D12PieceA{A,P}Plucker` | 972,400 | 378,000 | |
| `D12PiecePPPluckerBase` | 552,485 | 502,121 | |
| paid back: `D12CyclotomicVec` | 37,157 | 223,322 | `mul_apply_k`, `vec_ext` |
| paid back: `D12SigmaPlusSegreFplusZ` | — | 58,590 | 20 `Fplus` bridges + `phi11_interpQ` |
| paid back: `D12SigmaPlusSegreSmooth` | 168,515 | 178,310 | |
| and `D12SigmaPlusSegreBezoutData` fell | 81,504 | 35,504 | the `interpQ` table is smaller than the `C (..)` one |

### 1. Det and SmoothC{U,V,W}: the integer reflection (10.9M -> 1.2M)

`scripts/segre_interp_rewrite.py`, the post-pass the section above asked for.
It parses every `def NAME : Polynomial ℚ := C (..) + ..` body to exact
`Fraction`s, **re-renders it and aborts unless the re-render is byte-identical**
to the text it is replacing, and refuses to write if a theorem statement line
would move. Three modes: `--certs` (the certificate families), `--tables` (a
coefficient table), `--emit-fplus-bridge`.

Three things this needed that the earlier reflection work did not:

* **One denominator per file, not per definition.** The file-local `def`s are
  emitted over the lcm of all of them, so the sums fold with `interp_add`
  rather than `interp_add_gen` and the denominators stay put. (Lesson 3 of the
  2026-08-19 list, applied at file granularity.)
* **Reflect the table, do not bridge it.** `SmoothC` consumes
  `D12SigmaPlusSegreBezoutData` (162 polynomials) and
  `D12SigmaPlusSegrePartials` (36). Publishing 198 `z_*` bridges would have
  cost more than the certificates save, because those entries carry 15-digit
  rational coefficients. Converting the tables themselves — the `def` bodies
  *and* the `_def` equations they publish, which stay `rfl` — costs nothing and
  the table got **smaller**. Only `Fplus_{re,im}_*` (20 entries in
  `D12SigmaPlusSegreCore`, which has other consumers) got a bridge module.
* **The import scan misses transitive consumers.** `D12SigmaPlusSegreSmooth`
  never imports `Partials` or `BezoutData` by name — it reaches them through
  `SmoothAsm` — so a `grep -l` over import lines said the tables had 79
  consumers when they had 80, and the checkpoint build was the thing that found
  it. Its nine unscaled identities are now a plain `rw` chain: both sides
  reduce to the *same* `interpQ` literal, so `rw` closes them. The twelve
  scaled ones (`Fplus_dU_c_200 = 3 * ofLadj ..`) keep their route with
  `interpQ, toPolyZ` added to the simp list — `C 3 * interpQ d n` has no
  folding lemma, and writing one would have to match `C (3 : ℚ)` against
  `C ((3 : ℤ) : ℚ)`.

### 2. `mul_apply_k`: expand the convolution once, not 380 times (7.6M -> 1.4M)

Every `*_apply_k` certificate in the Plucker chain proved one coordinate of a
product of cyclotomic vectors with

```lean
norm_num [<defs>, mul, conv, coeffAt, Fin.sum_univ_succ]
```

`mul a b k = conv a b k + conv a b (k+11) - conv a b 10` and each `conv` is a
ten-term `Finset.sum`, so every one of ~380 certificates made `norm_num` expand
all three before it could do any arithmetic — ~18,000 `Expr` nodes each.
`D12CyclotomicVec.mul_apply_{0..9}` writes the expansion out once per
coordinate:

```lean
mul a b k = (∑_{i≤k} a i * b (k-i)) + (∑_{i≥k+2} a i * b (k+11-i))
              - (∑_{i≥1} a i * b (10-i))
```

Carried by `scripts/mul_apply_rewrite.py` (tactic-argument lines only; the
coordinate index in the theorem name must match the one in its statement).

**`rfl` does not work here, and neither does `decide`.** The obvious move —
these are closed rational computations, so let the kernel do them — fails:
`Vec = Fin 10 → ℚ`, and `Rat` arithmetic reduces through `Nat.gcd`, which is
well-founded recursion. Tried on all 130 `D12PiecePPDeterminant` certificates:
every one reports "the left-hand side `detPair0 0` is not definitionally equal
to the right-hand side". This is why the SplitRow redesign moved to `VecZ`
(`Int`, kernel-computable) and why these families cannot follow it without the
same rescaling redesign.

### 3. `vec_ext`: pay `fin_cases` once (838 occurrences)

838 generated certificates opened with `funext n; fin_cases n <;> ..`, and
`fin_cases` inlines a `List.Mem.casesOn` over `List.finRange 10` into every one
of the ten coordinate goals — the bloat identified on 2026-08-18 and never
acted on. `D12CyclotomicVec.vec_ext` pays it once.
`scripts/vec_ext_rewrite.py` applies it. `D12PieceAAActionRow0` 68,046 ->
47,321, and the four ActionRow families fall 34%.

**State the hypotheses in `Fin.mk` form.** `vec_ext` with `(h0 : a 0 = b 0)`
compiles, and then every certificate fails: `norm_num` cannot evaluate
`![10/11, ..] (2 : Fin 10)` with a *numeral* index in this Mathlib, only
`![..] ⟨2, _⟩`, which is the form `fin_cases` produced. Verified in isolation.

### 4. `fin15_cases` for `PluckerNaturality` (2.22M -> 1.20M)

`restrict4_det_t (s : Fin 15)` was the most expensive theorem shape left in the
tree at ~107,000 nodes each: `fin_cases s` over `Fin 15` inlines a
`List.Mem.casesOn` over `List.finRange 15` into all fifteen cases, and only
then does each case expand a 4x4 determinant. A `private fin15_cases` pays it
once, -45% on the file.

**`refine fin15_cases ?_ .. ?_ s` does not elaborate** — the motive is not
abstracted and every use reports `?m.54 s` against the real goal.
`induction s using fin15_cases <;> ..` does. Same `Fin.mk` rule as `vec_ext`.

### Emitters

All four emit sites were brought in line and **checked by emitting to a scratch
directory and diffing against the tree**, modulo the annotations the hook adds:

* `scripts/export_d12_nonzero_piece_vec_lean.py` — `mul_apply_k` at four sites,
  `refine vec_ext` at three. `D12PiecePPDeterminant`, `D12PiecePPCoeff0_0`,
  `D12PiecePPCoeff0_1Product0`, `D12PieceAAPlucker`, `D12PiecePPPluckerBase`
  and `D12PieceAAActionRow{0,13}` are byte-identical after the change.
  `D12PiecePPCoeff0_0` was **not** identical before it: the emitter has always
  put that `norm_num` on one line and the tree wrapped it. It now agrees.
* `scripts/export_d12_piece_vec_lean.py` — `refine vec_ext`; checked on
  `D12PiecePAActionRow{0,17}`.
* Det and SmoothC still have no emitter; `segre_interp_rewrite.py` is the
  authority, and it is idempotent.

### What did NOT pay, measured

* **Widening the `interp_*` fold list in VQ/HM.** Those 378 modules fold with
  `simp (disch := decide) only [interp_mul, interp_add_gen, interp_sub_gen,
  Nat.reduceMul]` — no `interp_add`/`interp_sub`, so every sum goes through the
  denominator-mixing lemmas and carries `smulList 1` wrappers even though every
  denominator is 1. Adding the equal-denominator lemmas moved
  `D12SigmaPlusSegreVQ_4_8` from 23,042 to 22,953, **-0.4%**. The wrappers are
  shared subterms; they cost nothing after dedup. Do not repeat this.
* **`rfl` / `decide` on the rational vector products** — see step 2 above.

### Where it stands now, and what is left

The table is flat. The largest family is `D12SigmaPlusSegreVQ` at 7.6%, and
that is 22,059 constants at **215 nodes each** — it is big because there are
many small certificates, not because any one of them is expensive, and no
shared lemma addresses it. For comparison the families that were worth
attacking ran 2,000-12,000 nodes per constant.

| family | per-constant | share | nodes/constant | shape |
|---|---:|---:|---:|---|
| `D12SigmaPlusSegreVQ` | 4,745,143 | 7.6% | 215 | already reflected; nothing concentrated |
| `D12SigmaPlusSegreHM` | 2,132,097 | 3.4% | 339 | already reflected |
| `D12GeneratorSPhaseRow` | 1,650,804 | 2.6% | 2,116 | **the last family still on `ring_nf` + `C_eq_smul_one` + `module`** |
| `D12SigmaPlusSegreQrel` | 1,506,600 | 2.4% | 674 | |
| `D12SigmaCarrierBridgeRow` | 1,438,962 | 2.3% | 2,284 | |
| `D12CompoundBridge` | 1,372,057 | 2.2% | 2,330 | shared, paid once |
| `D12SigmaMinusReverse` | 1,345,040 | 2.1% | 524 | |
| the four `D12Piece*SplitRow` | 4,351,115 | 6.9% | 144 | |
| the four `D12Piece*ActionRow` | 3,599,707 | 5.7% | 2,142 | |
| `D12{F6,U6}PolynomialData` | 1,943,349 | 3.1% | 6,478 | |

The one family that is still on the *old* arithmetic route is
`D12GeneratorSPhaseRow` — `phase_relation_k` is `ring_nf`, then 63
`C_eq_smul_one`-style rewrites, then `module`, which is exactly what the
reflection replaced everywhere else. Converting it is the same job
`D12CompoundBridge` was, with one extra obstacle: the relations carry a scalar
`C (-1/2 : ℚ) * (..)`, and there is no folding lemma for `C (a/b) * interpQ d n`
— writing one means matching the literal `C (-1/2 : ℚ)` against
`C ((a : ℤ) / (b : ℕ) : ℚ)`, which `rw` will not do syntactically. The
`D12CompoundBridge` trick (state everything for twice the difference so the
halves land in one shared collapse lemma) is the precedent to follow.

## Deleting the dead files (2026-08-18)

350 files were outside the `V14Solution` import closure entirely — zero
closure nodes, so nothing to gain on the export, but real build time and real
disk. All of them are gone:

| family | files | why it is dead |
|---|---:|---|
| `D12SigmaPlusSegreUM_*` | 315 | proved `spanU * minorQ = Qplus`, which has no consumer anywhere |
| `D12SigmaPlusSegreSpanUDir` | 1 | the aggregator that exists only to `fin_cases` over those 315 |
| `D12SigmaPlusSegreApply_span{U,V}*` | 26 | 24 shards + 2 aggregators; they `unfold spanV spanV_row0`, and `spanV` is a single two-dimensional `match` with no `spanV_row*` anywhere in the tree, so they have never compiled on any branch |
| `D12SigmaPlusSegreSpanV_0_0` | 1 | the only other importer of `Apply_spanV`; legacy, never compiled |
| `D12SigmaPlusSegreSmooth{U,V,W}Prod` | 3 | legacy, `Ambiguous term C/X` |
| `D12SigmaPlusSegreSmooth{U,V,W}` | 3 | same, and the three `*Prod` files were their only importers |
| `D12SigmaPlusSegreSpan` | 1 | a dead duplicate of `D12SigmaPlusSegreSpanVDir`, which is the live prover of `spanV_mul_Qplus`; nothing imported it |

The `Apply_span{U,V}` shards were meant to be the `spanU_apply_*` /
`spanV_apply_*` entry lemmas. Those were derived correctly from the actual
definitions, in the modules that own the matrices, by
`scripts/matrix_apply_lemmas.py` — so nothing is lost.

Two emitters had no surviving output and were deleted with their families:
`scripts/export_sigma_plus_smooth_lean.py` (emitted only `Smooth{U,V,W}`) and
`scripts/export_sigma_plus_smooth_id.py` (only `Smooth{U,V,W}Prod`). The two
stale span emitters keep their `exit 2` guard and now list the retired
families in the guard message, so a future `--emitter-is-current` cannot
resurrect them by accident. 317 stanzas were pruned from
`scripts/migration_stage7.json` (deletions only — key order and every
surviving value are byte-identical).

| | before | after |
|---|---:|---:|
| project `.lean` files | 1,379 | 1,029 |
| legacy (non-`module`) files | 34 | 1 |
| `.lake/build` | 5.41 GB | 3.96 GB |
| closure, per-constant | 133,422,326 | 133,422,326 |
| closure, per-module | 64,982,352 | 64,982,352 |

**-1.45 GB of build artifacts, zero closure change** — which is the point.
Build time: one `UM_*` module elaborates in 7.07 s wall / 14.2 s CPU, so the
315 alone were ~37 minutes of wall time on a full glob build, before the two
aggregators that `fin_cases` over 315 and 504 imports. The checkpoint target
(`V14Challenge V14Solution AxiomAudit`) never built any of them, so its time
is unchanged.

## Retiring the 15x15 ambient tables (2026-08-18)

### What the 450 certificates were actually proving

The tree used to tabulate the ambient 15x15 rotation and reflection
(`D12Polynomial{R,F}Row0..14`) *and* the 6x6 Weil generators
(`D12{U6,F6}PolynomialData`), and then prove 225 entrywise identities per
generator, in `D12Compound{R,F}Row0..14`, reconciling the two:

```
compound2(R6)[i,j] - R15[i,j] = Phi11 * q[i,j]
```

It is tempting to read that as a copy being checked against its own
derivation, with the certificates a tautology waiting to be deleted. It is
not. `compound2(R6)` has degree up to 18; `R15` has degree at most 9. They are
congruent modulo `Phi11`, not equal — **all 225 quotients are nonzero, for
both generators**. `R15` is the canonical reduced representative of
`compound2(R6)` in `Q[X]/(Phi11)`, and that reduction is exactly what made the
*exact* `Q[X]` identity

```
R15 * B = B * RM
```

true. Substituting `compound2(R6)` into it breaks it: the two differ by
`Phi11 * Q` with `Q` nonzero, and `B` has full column rank, so `Q * B` is
nonzero too. Anyone planning to make the reconciliations `rfl` should stop
here — they cannot be, and the emitter now says so in its docstring.

### What replaced them

The reconciliation is not what the proof needs. Its single consumer,
`D12ActionCoreCertificate.actionCore`, needs one fact over `K`:

```
rho(rotGen) * B = B * RM
```

and the identification of `rho(g)` with a compound matrix is already
structural, for every `g`, in
`PluckerNaturality.lambda2MatrixRepresentation_eq_compound2Lex`. So the
ambient generator is no longer stored at all: it *is*
`compound2Lex R6_poly`, and the generated modules certify only the
restriction,

```
2 * ((compound2Lex R6_poly * B_poly) i j - (B_poly * RM_poly) i j)
  = Phi11 * quotient_j
```

`B` has ten columns, so that is 150 entries per generator instead of 225 —
which is where a third of the saving comes from. The rest comes from deleting
the 15x15 tables and the exact `R*B = B*RM` layer they supported.

| | before | after |
|---|---:|---:|
| `D12CompoundRRow` | 9,864,823 | 7,290,836 |
| `D12CompoundFRow` | 9,772,123 | 7,227,934 |
| `D12PolynomialRRow` | 2,534,279 | deleted |
| `D12PolynomialFRow` | 2,536,847 | deleted |
| `D12PolynomialRFull` / `FFull` | 36,439 | deleted |
| `D12CompoundBridge` (new) | — | 134,239 |
| **closure, per-constant** | **143,515,204** | **133,422,326** |

**-10,092,878, -7.03%**, and 32 module files deleted against one added. At
~85 bytes/node the export goes from ~12.2 GB to ~11.3 GB.

### `D12CompoundBridge`: the parts that were paid 30 times

Three things moved out of the generated modules into one shared module:

* the `C (n/d) = n' * C (1/22)` normalisation lemmas, which every certificate
  needs and each of the 30 modules used to declare privately for itself;
* `two_mul_B_col{0..9}` and `two_B_mul_row{0..14}`, generic in the matrix
  being multiplied: the sparse-`B` collapse done once per column and once per
  row rather than once per certificate;
* `of_two`.

The doubling is the reason the certificates stay clean. `B_poly` has entries
`+-1/2`, and `C (1/2)` is an atom `ring` knows nothing about, so a certificate
that meets one has to carry a second relation through `linear_combination`.
Stating everything for *twice* the difference pushes every half into the two
collapse lemmas — where it is discharged once — and leaves the 300 per-entry
certificates with integer scalars only. `of_two` divides back by 2 at the end.

The common denominator matters too, and cost one build to discover: the 6x6
tables are over 11 but `RM`/`SM` also carry `3/22` entries, so `C (1/11)` and
`C (3/22)` are unrelated atoms and `ring` fails on a residual that is visibly
zero. Everything normalises to `C (1/22)`.

### Emitters

`scripts/export_d12_compound_lean.py` was rewritten and now emits the bridge
as well as the 30 row modules. `scripts/export_d12_poly_lean.py` keeps
`D12PolynomialCore` / `RM` / `SM` and a trimmed `D12PolynomialData`; its
15x15 emit code is retained but unreachable, together with the
exact-arithmetic residual checks (`R*B-B*RM=0`, `F*B-B*SM=0`) that validated
the retired layer — those still run on every invocation, as an independent
audit of `results/d12_lean_K.json`. Both emitters round-trip byte-for-byte
after this change, checked the way the section above prescribes.

One stale line is left deliberately: `D12PolynomialCore.lean`'s header still
says "Action rows live in D12PolynomialRRow*.lean shards". That file is the
frozen-bytes case — its emitter re-annotates it only after checking
`sha256 == recorded pristine hash` — so correcting the comment would mean
re-recording the hash for a comment. It is not worth it.

`scripts/const_stats.lean` is new: the per-*constant* counterpart of
`closure_stats.lean` / `module_stats.lean`, which is what tells you whether a
family's cost is in its tables or in one expensive theorem shape. Here it said
`cert_*` was 97.7% of `D12CompoundRRow0` and the 15x15 table was 0.6% of
`D12PolynomialRRow0` — so the table was never the prize, the certificate count
was.

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
* `scripts/segre_interp_rewrite.py [--check] {--certs|--tables} <files…>` —
  the integer reflection for `Det` / `SmoothC{U,V,W}` and for the coefficient
  tables they consume; `--emit-fplus-bridge <path>` writes the shared
  `Fplus` / `Phi11` bridge module. Every polynomial body is parsed to exact
  `Fraction`s and re-rendered, and the pass aborts unless the re-render is
  byte-identical to what it replaces.
* `scripts/mul_apply_rewrite.py [--check] <files…>` — points the Plucker
  `*_apply_k` certificates at `D12CyclotomicVec.mul_apply_k` instead of making
  each of them expand `mul`/`conv`/`coeffAt`.
* `scripts/vec_ext_rewrite.py [--check] <files…>` — `funext n; fin_cases n <;>`
  -> `refine vec_ext ?_ .. ?_ <;>`.
* `scripts/module_stats.lean` — per-module proof-term size, the cheap
  counterpart of `closure_stats.lean`:
  `lake env lean --run scripts/module_stats.lean V14Formalization.<M> …`.
  Use it to measure one file before paying a closure rebuild.
* `scripts/const_stats.lean` — per-*constant* sizes for a chosen list of
  modules (edit `wanted`). This is what tells you whether a family is one
  expensive theorem shape (worth a shared lemma) or many cheap ones (not).
  Every win in this campaign was found by looking at nodes-per-constant, not
  at the family total.

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
| `D12SigmaPlusSegreQplus` | 946 | 521 | Qrel (15) + VQ (189) + UM (315) all `simp only` the entries. The 315 UM modules have since been deleted, so the consumer count is now 206 — revisit. |
| `D12SigmaPlusSegreMinorQ` | 568 | ~694 | same, plus HM (189) |
| `D12SigmaPlusSegreSpanU` / `SpanV` | 406 + 406 | ~330 each | driven by UM (315) and by the 24 `Apply_span{U,V}` shards. **All 339 of those modules have since been deleted**, so `SpanU`'s remaining consumers are few and de-exposing it is now a small job — revisit. |
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
| ~~`D12SigmaPlusSegreUM`~~ | ~~315~~ | deleted with the family; see "Deleting the dead files". |
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

