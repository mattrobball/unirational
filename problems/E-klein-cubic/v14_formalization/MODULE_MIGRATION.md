# Module-system migration (Lean 4.32.1)

Stage 1 (this document's origin) converted the 13 bottom-of-DAG files and
established the recipe, tooling, and measurements below. Stages 2-5 follow
the same recipe with the same tools.

## The one hard rule: strictly bottom-up

A `module` file cannot import a non-`module` file (hard error,
`Lean/Environment.lean:2066`). So a file may be converted only when every
project file it imports is already converted. Non-module files may import
module files, but they **ignore all module-system annotations**
(`Environment.lean:2068`) — so the legacy build keeps working during the
whole migration, and also proves nothing about the annotations. Validation
must come from module-side probes (below).

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
3. **Expose** (`@[expose] public`) only defs whose *bodies* importers need:
   - defs appearing downstream inside `simp [...]`, `dsimp [...]`,
     `unfold`, `norm_num [...]`;
   - defs computed by `decide`/`rfl` downstream (certificate data, list
     arithmetic);
   - type-defs whose values are constructed/projected in public signatures
     (e.g. `Circle1` in CentralizerD12 — field projection `.val` in an
     exposed signature needs the body);
   - defs a public theorem in the *same file* proves things about by
     term-mode `rfl` (error: "This theorem is exported from the current
     module ... definitions ... must be exposed" — e.g. `ψ` in WeilRep).
   Public `abbrev`s are exposed automatically; do not annotate them
   (`@[expose]` there is a warning).
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

Data files expose what they publish: downstream certificate proofs consume
the arrays via `rfl`/`decide`, which need bodies at elaboration time.

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
* After the batch: full `lake build V14Formalization V14Challenge
  V14Solution AxiomAudit`; `#print axioms` on
  `V14Formalization.Comparator.noEquivariantRationalMap_from_ambient` and
  `...noEquivariantRationalMap_projectiveGVariety` must yield exactly
  `[propext, Classical.choice, Quot.sound]`. Converting the bottom of the
  DAG invalidates every transitive dependent, so each stage pays one full
  rebuild — batch conversions accordingly.

## Stage-1 baseline (probe numbers, 2026-08-17)

Importer-side environment, `PREFIX=V14Formalization`; legacy probe
unchanged by the migration (control). Full table in the stage-1 report;
representative rows:

| target module        | probe  | total consts | proj consts | proj Expr nodes | max RSS |
|----------------------|--------|-------------:|------------:|----------------:|--------:|
| D12PolyZReflection   | module |      234,021 |          57 |           1,204 | 1.16 GB |
| D12PolyZReflection   | legacy |      329,398 |          69 |           1,288 | 2.18 GB |

(The total-constants and RSS drops are dominated by Mathlib's own public
interface being loaded instead of its full bodies — that benefit applies to
every converted file that imports Mathlib and grows as project files
convert.)

## Stage order

Convert a file only when all its project imports are converted. After
stage 1 (the 13 leaves: Basic, BiprojectiveIntegral, CentralizerD12,
D12PolyZReflection, D12PolynomialCore*, D12SealData*, 
EllipticPolynomialConstancy, MultiProjectiveZeroLocus, PSLCard,
ProjNaturality, SchemeBaseChangeAction, SchemeEquivariant, WeilRep;
\* = via emitter):

2. **Piece Split chain**: D12Piece{PP,PA,AP,AA}Split* families + their
   shared parents (D12PolynomialSM, D12PolynomialFRow*/RRow*, Data) —
   emitter-driven; one annotation pass per emitter, same pattern as
   export_d12_lean.py.
3. **SigmaMinus / SigmaCarrier / GeneratorSPhase / Compound** families —
   emitter-driven.
4. **SigmaPlusSegre stack** (incl. the *Z reflection shards over
   D12PolyZReflection) — emitter-driven.
5. **Hand-written core** (GeometricV14Carrier, SchemeFixedLocus,
   FaithfulHeadline, ... up the DAG), then the **roots last**:
   HeadlineStatement, V14Challenge, V14Solution, V14Formalization,
   AxiomAudit. Only when the roots become `module` files do downstream
   consumers (Comparator) see any benefit through them; until then the
   roots' legacy imports deliberately erase the annotations.

Stage-1 execution note for planning: the 11 hand-written conversions took
~6 compile-fix iterations total across 4 files (the other 7 were clean on
the first build); nothing required a proof or statement change.
