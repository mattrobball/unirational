#!/bin/zsh
# Measurement harness for the module-system migration (stages 1-5).
#
# For each given module it elaborates two tiny probe files and reports what
# an IMPORTER of that module gets:
#   probe A ("module"): a `module` file with `public import <target>` —
#     sees only the target's public interface (the migration's payoff);
#   probe B ("legacy"): the same import without the `module` header —
#     ignores all module-system annotations (the pre-migration behavior,
#     and what any still-legacy file in this repo sees today).
#
# Reported per probe:
#   total-constants    constants in the importer's elaboration environment
#   project-constants  constants whose name mentions the project prefix
#   project-expr-nodes DAG-deduplicated Expr nodes (types + available
#                      bodies) over the project constants
#   max-RSS            peak resident set of the `lean` process
#
# Usage:  scripts/module_probe.sh V14Formalization.PSLCard [more modules...]
#   env PREFIX=V14Formalization   (default) name filter for project metrics
#
# The legacy numbers should NOT move when a module is converted; the module
# numbers shrink as declarations become module-private. Run from the
# package root (needs `lake env`).
set -e
PREFIX=${PREFIX:-V14Formalization}
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

emit_metrics() {
cat <<EOF
open Lean in
run_meta do
  let env ← getEnv
  let mut total := 0
  let mut proj : Array (Name × ConstantInfo) := #[]
  for (n, ci) in env.constants.toList do
    total := total + 1
    if (n.toString.splitOn "$PREFIX").length > 1 then
      proj := proj.push (n, ci)
  -- DAG-deduplicated Expr node count over project constants
  let mut seen : Std.HashSet Expr := {}
  let mut nodes := 0
  for (_, ci) in proj do
    let mut stack : Array Expr := #[ci.type]
    if let some v := ci.value? then stack := stack.push v
    while h : stack.size > 0 do
      let e := stack[stack.size - 1]
      stack := stack.pop
      if seen.contains e then continue
      seen := seen.insert e
      nodes := nodes + 1
      match e with
      | .app f a => stack := stack.push f |>.push a
      | .lam _ t b _ | .forallE _ t b _ => stack := stack.push t |>.push b
      | .letE _ t v b _ => stack := stack.push t |>.push v |>.push b
      | .mdata _ b | .proj _ _ b => stack := stack.push b
      | _ => pure ()
  IO.println s!"total-constants={total}"
  IO.println s!"project-constants={proj.size}"
  IO.println s!"project-expr-nodes={nodes}"
EOF
}

for target in "$@"; do
  {
    echo "module"
    echo "public import $target"
    echo "meta import Lean"
    emit_metrics
  } > "$TMP/probe_module.lean"
  {
    echo "import $target"
    echo "import Lean"
    emit_metrics
  } > "$TMP/probe_legacy.lean"
  for mode in module legacy; do
    echo "== $target [$mode probe]"
    /usr/bin/time -l lake env lean "$TMP/probe_$mode.lean" 2> "$TMP/time.out"
    rss=$(grep "maximum resident set size" "$TMP/time.out" | awk '{print $1}')
    echo "max-RSS-bytes=$rss"
  done
done
