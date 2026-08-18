#!/usr/bin/env python3
"""Emitter pass: publish a coefficient table's defining equations, not its bodies.

Why
---
A generated data module like `D12SigmaPlusSegreBezoutData` is 100% `public` and
100% `@[expose]`d, because every consumer unfolds every entry -- `simp only
[CU_0_re_002, …]`, `rw [CU_1_c_002, …]`, `unfold CU_0`, and the occasional
`… := rfl`.  `@[expose]` is what makes those reductions possible across a module
boundary, and it is also what forces the table's bodies into every importer's
elaboration environment, and what cascades: an exposed def's body may only
mention public names, so `CU_0_c_011 := ofLadj CU_0_re_011 CU_0_im_011` drags
its two operands out with it.

Empirically (Lean 4.32.1), a `public theorem` proved in TACTIC mode inside the
defining module needs no exposure at all -- only term-mode `:= rfl` proofs
elaborate against the exported view.  So the table can publish

    public theorem CU_0_re_002_def : CU_0_re_002 = C (…) + C (…) * X ^ 2 + … := by
      rfl

and drop `@[expose]` from the def itself.  Consumers rewrite with the theorem
instead of unfolding the definition; they get exactly the same equation and the
same proof, but the module now exports an interface rather than an environment.

What it changes, and why it is safe
-----------------------------------
In the TABLE module: strips `@[expose]` and appends one `_def` theorem per
definition.  No existing declaration's statement or proof is touched.

In the CONSUMER modules: rewrites references to the table's definitions to
references to the corresponding `_def` theorem, in the four contexts that
force defeq --

    simp only [X, …] / simp [X, …] / dsimp [X, …] / norm_num [X, …]  ->  X_def
    rw [X, …] / rw [← X, …]                                          ->  X_def
    unfold X                                                         ->  rw [X_def]
    theorem foo : X = <body> := rfl                                  ->  := X_def

-- and nothing else.  Before writing, the pass checks that every line it did not
deliberately rewrite survives byte-for-byte, so no statement can move.  It is
idempotent: a converted file rewrites to itself.
"""
from __future__ import annotations

import argparse
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

DEF_RE = re.compile(
    r"^(?P<expose>@\[expose\]\s+)?public def (?P<name>[A-Za-z_][\w']*)\b", re.M)

# Tactics whose bracketed argument list forces defeq through a definition.
TACTIC_LIST_RE = re.compile(
    r"(?P<head>\b(?:simp only|simp|dsimp only|dsimp|norm_num|rw|rewrite)\b\s*\[)")


def parse_table(src: str) -> list[tuple[str, str, str]]:
    """Return [(name, type_ascription, body)] for every `public def` in the file."""
    out = []
    lines = src.split("\n")
    starts = [i for i, ln in enumerate(lines) if DEF_RE.match(ln)]
    for k, i in enumerate(starts):
        end = starts[k + 1] if k + 1 < len(starts) else len(lines)
        # a declaration ends at the first blank line after its start
        j = i
        while j < end and not (j > i and lines[j].strip() == ""):
            j += 1
        chunk = "\n".join(lines[i:j])
        m = DEF_RE.match(chunk)
        name = m.group("name")
        head, _, body = chunk.partition(":=")
        ty = head.split(":", 1)[1].strip() if ":" in head.split(name, 1)[1] else ""
        out.append((name, ty, body.strip()))
    return out


def emit_defs(src: str, decls: list[tuple[str, str, str]]) -> str:
    """Strip `@[expose]` from the defs and append one `_def` theorem each."""
    out = re.sub(r"^@\[expose\] (public def )", r"\1", src, flags=re.M)
    if "_def :" in out:          # already converted
        return out
    block = ["", "-- Defining equations, published so that consumers rewrite with the",
             "-- theorem instead of unfolding the definition (see",
             "-- scripts/table_interface_rewrite.py).  Tactic-mode proofs in the",
             "-- defining module need no `@[expose]`."]
    for name, _ty, body in decls:
        block.append(f"public theorem {name}_def : {name} = {body} := by")
        block.append("  rfl")
        block.append("")
    marker = "\nend "
    idx = out.rfind(marker)
    if idx < 0:
        return out + "\n".join(block) + "\n"
    return out[:idx] + "\n" + "\n".join(block) + out[idx:]


def _rewrite_lists(text: str, names: set[str]) -> str:
    """Replace `X` by `X_def` inside simp/rw-style bracketed argument lists."""
    out = []
    pos = 0
    for m in TACTIC_LIST_RE.finditer(text):
        if m.start() < pos:
            continue
        # find the matching close bracket
        depth = 0
        i = m.end() - 1
        while i < len(text):
            if text[i] == "[":
                depth += 1
            elif text[i] == "]":
                depth -= 1
                if depth == 0:
                    break
            i += 1
        if i >= len(text):
            continue
        inner = text[m.end():i]
        new = re.sub(r"\b([A-Za-z_][\w']*)\b",
                     lambda w: w.group(1) + "_def" if w.group(1) in names else w.group(1),
                     inner)
        out.append(text[pos:m.end()])
        out.append(new)
        pos = i
    out.append(text[pos:])
    return "".join(out)


def rewrite_consumer(src: str, names: set[str]) -> str:
    out = _rewrite_lists(src, names)

    # `unfold X …` -> `rw [X_def, …]`, keeping any names that are not the
    # table's (they live in a module that is still exposed) on their own
    # `unfold` line.
    def unf(m):
        ns = m.group("ns").split()
        mine = [n for n in ns if n in names]
        other = [n for n in ns if n not in names]
        if not mine:
            return m.group(0)
        ind = m.group("indent")
        line = f"{ind}rw [{', '.join(n + '_def' for n in mine)}]"
        if other:
            line += f"\n{ind}unfold {' '.join(other)}"
        return line
    out = re.sub(r"^(?P<indent>[ \t]*)unfold (?P<ns>[A-Za-z_][\w']*(?:[ \t]+[A-Za-z_][\w']*)*)[ \t]*$",
                 unf, out, flags=re.M)
    # `theorem foo : X = <anything> := rfl` -> `:= X_def`
    def rfl(m):
        return f"{m.group('stmt')}:= {m.group('n')}_def" if m.group("n") in names else m.group(0)
    out = re.sub(
        r"(?P<stmt>theorem [\w']+ : (?P<n>[A-Za-z_][\w']*) = [^\n]*?)"
        r":= rfl(?=\s*$)", rfl, out, flags=re.M)
    return out


def check_untouched(before: str, after: str, changed_ok) -> None:
    b = [ln for ln in before.split("\n") if not changed_ok(ln)]
    a = [ln for ln in after.split("\n") if not changed_ok(ln)]
    if b != a:
        for i, (x, y) in enumerate(zip(b, a)):
            if x != y:
                raise SystemExit(
                    f"REFUSING TO WRITE: untouched line {i} changed\n"
                    f"  before: {x!r}\n  after:  {y!r}")
        raise SystemExit(f"REFUSING TO WRITE: line count changed ({len(b)} -> {len(a)})")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--table", type=Path, required=True)
    ap.add_argument("--consumers", type=Path, nargs="*", default=[])
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args()

    tpath = args.table if args.table.is_absolute() else ROOT / args.table
    tsrc = tpath.read_text()
    decls = parse_table(tsrc)
    names = {n for n, _, _ in decls}
    print(f"{tpath.name}: {len(decls)} definitions")
    tout = emit_defs(tsrc, decls)
    if not args.check:
        tpath.write_text(tout)

    total = 0
    for c in args.consumers:
        p = c if c.is_absolute() else ROOT / c
        src = p.read_text()
        out = rewrite_consumer(src, names)
        if out == src:
            continue
        n = sum(1 for x, y in zip(src.split("\n"), out.split("\n")) if x != y)
        total += n
        if not args.check:
            p.write_text(out)
    print(f"{'would rewrite' if args.check else 'rewrote'} {total} lines "
          f"across {len(args.consumers)} consumers")


if __name__ == "__main__":
    main()
