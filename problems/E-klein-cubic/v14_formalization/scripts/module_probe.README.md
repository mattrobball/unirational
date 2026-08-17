# module_probe.sh — the migration's measuring stick

One instrument for all migration stages, so numbers stay comparable.

```
scripts/module_probe.sh V14Formalization.PSLCard [more modules...]
PREFIX=V14Formalization scripts/module_probe.sh ...   # name filter (default shown)
```

For each target it elaborates two one-line importers and reports what each
kind of importer receives:

* **module probe** — a `module` file with `public import <target>`.
  Sees only the target's (and its transitive imports') public interface.
  This is the number the migration improves.
* **legacy probe** — the same import from a non-`module` file. Legacy
  imports ignore every module-system annotation (Lean
  `Environment.lean:2068`), so this number must NOT move when a file is
  converted. It is the control: if it moves, the conversion changed more
  than visibility.

Metrics: `total-constants` (importer's environment), `project-constants`
(names mentioning PREFIX; module-private names vanish from the module
probe), `project-expr-nodes` (DAG-deduplicated Expr nodes across types and
available bodies of project constants), `max-RSS-bytes` (peak RSS of the
probing `lean` process).

Run from the package root with the target already built (`lake build <target>`).
Stage-1 baseline numbers live in MODULE_MIGRATION.md.

Caveat: measuring through a *legacy root* (e.g. importing `V14Solution`)
shows no module-system effect at all — that is expected, not a failed
migration; only `module` importers benefit until the roots convert in the
final stage.
