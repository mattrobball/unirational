#!/usr/bin/env python3
"""Emitter pass: publish a generated matrix's entry equations from its own module.

Why
---
`D12SigmaPlusSegreVQ_*` reaches its working goal with

    change spanV_entry_0_0 * Qplus_entry_0_0 + … = minorQ_entry_0_0

after `rw [Matrix.mul_apply, sum_fin15]`.  `change` makes the elaborator reduce
the whole goal, so `spanV`, `minorQ` and every entry they name have to be
unfoldable whether or not the tactic text mentions them.  The stated fact the
proof actually needs is one equation per entry:

    public theorem spanV_apply_0_0 :
        spanV (0 : Fin 9) (0 : Fin 15) = spanV_entry_0_0 := by
      rfl

Tactic-mode, in the defining module, so it needs no `@[expose]` of its own.

`D12SigmaPlusSegreApply_spanV_*` and `Apply_spanU_*` were meant to be these
lemmas, but they say `unfold spanV spanV_row0` while `spanV` is defined by a
single two-dimensional `match` with no `spanV_row*` at all.  That is why those
24 shards have never compiled on any branch.  Deriving the lemmas in the module
that owns the matrix is both correct and cheaper.

The modules concerned are emitted by `export_sigma_plus_span_identities.py`,
which is stale and refuses to run, so this rides a post-pass in the style of
`splitrow_intro_rewrite.py`.

What it changes
---------------
Appends the entry equations before the module's final `end`, and nothing else.
The pass verifies that every pre-existing line survives byte-for-byte, and is
idempotent: a module that already carries them is left alone.
"""
from __future__ import annotations

import argparse
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# `@[expose] public def spanV : Matrix (Fin 9) (Fin 15) Ki :=`
MATRIX_DEF = re.compile(
    r"^(?:@\[expose\]\s+)?public def (?P<name>[A-Za-z_][\w']*) : Matrix "
    r"\(Fin (?P<rows>\d+)\) \(Fin (?P<cols>\d+)\) (?P<elem>\S+) :=$", re.M)
ENTRY_ARM = re.compile(r"^\s*\| (?P<i>\d+), (?P<j>\d+) => (?P<entry>[A-Za-z_][\w']*)$", re.M)


def entries_of(src: str, name: str) -> dict[tuple[int, int], str]:
    m = next(d for d in MATRIX_DEF.finditer(src) if d.group("name") == name)
    tail = src[m.end():]
    stop = re.search(r"\n(?:@\[|public |end |theorem |def )", tail)
    body = tail[: stop.start()] if stop else tail
    return {(int(a.group("i")), int(a.group("j"))): a.group("entry")
            for a in ENTRY_ARM.finditer(body)}


def build(src: str, name: str) -> tuple[str, int]:
    if f"public theorem {name}_apply_" in src:
        return src, 0
    m = next(d for d in MATRIX_DEF.finditer(src) if d.group("name") == name)
    rows, cols = int(m.group("rows")), int(m.group("cols"))
    ent = entries_of(src, name)
    block = ["",
             f"-- Entry equations for `{name}`, published so that consumers state the",
             "-- fact they need instead of `change`-ing the goal into the entry form.",
             "-- Tactic-mode proofs in the defining module need no `@[expose]`."]
    n = 0
    for i in range(rows):
        for j in range(cols):
            if (i, j) not in ent:
                continue
            block += [
                f"public theorem {name}_apply_{i}_{j} :",
                f"    {name} ({i} : Fin {rows}) ({j} : Fin {cols}) = {ent[(i, j)]} := by",
                "  rfl",
                "",
            ]
            n += 1
    idx = src.rfind("\nend ")
    if idx < 0:
        raise SystemExit(f"no trailing `end` in the module defining {name}")
    return src[:idx] + "\n" + "\n".join(block) + src[idx:], n


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("file", type=Path)
    ap.add_argument("matrix")
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args()
    p = args.file if args.file.is_absolute() else ROOT / args.file
    src = p.read_text()
    out, n = build(src, args.matrix)
    # Nothing that was there before may have moved: the output must be the
    # input with one contiguous block spliced in at the trailing `end`.
    idx = src.rfind("\nend ")
    if not (out.startswith(src[:idx]) and out.endswith(src[idx:])):
        raise SystemExit("REFUSING TO WRITE: existing text changed")
    if not args.check:
        p.write_text(out)
    print(f"{p.name}: {'would add' if args.check else 'added'} {n} "
          f"`{args.matrix}_apply_*` equations")


if __name__ == "__main__":
    main()
