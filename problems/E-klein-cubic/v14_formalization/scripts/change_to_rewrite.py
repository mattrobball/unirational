#!/usr/bin/env python3
"""Emitter pass: replace `change`/`unfold` scaffolding by published equations.

Pipeline position
-----------------
    export_d12_*_piece_vec_lean.py  ->  SplitEntry shards
    merge_split_entry_rows.py       ->  D12Piece{fam}SplitRow{r}.lean
    splitrow_intro_rewrite.py       ->  same files, in place
    THIS PASS                       ->  same files, in place

The SplitEntry shards are not in the tree — they were merged away — so the
SplitRow files are the artifact to change, exactly as for
`splitrow_intro_rewrite.py`. Never hand-edit them; re-run this instead.

Why
---
Each `entry_eq` reached its working goal with

    change (∑ k : Fin 20, mul (XVec (0 : Fin 10) k)
        (AVec k (0 : Fin 10))) +
      (∑ k : Fin 1, mul (KVec (0 : Fin 10) k)
        (YVec k (0 : Fin 10))) = _

(or `unfold matrixMul`, in the PA family, which has no K/Y term).  Both ask the
exported context to reduce `matrixMul` — and `change` reduces the entire goal,
so every definition in the statement has to be unfoldable, whether or not the
tactic text names it.  That is a defeq context, so it pins `@[expose]`, and it
redoes the same `matrixMul` unfolding once per certificate.

`D12CyclotomicVec.matrixMul_apply` states the entry equation once.  With
`Matrix.add_apply` from Mathlib for the sum of the two products, the same goal
is reached by rewriting:

    rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]
    rw [matrixMul_apply]                    -- PA, single product

Statement preservation
----------------------
Only proofs change.  The pass extracts every line that is not part of a
rewritten tactic block from input and output and refuses to write if any
differs.  Strict (every `change` of the known shape must match) and idempotent.
"""
from __future__ import annotations

import argparse
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# `change (∑ k : Fin N, mul (XVec (i : Fin 10) k)\n … ) = _`, spanning the four
# emitted lines, immediately followed by `refine add_sum_mul_eq_of_scaled`.
CHANGE_SUM = re.compile(
    r"^(?P<indent>[ \t]*)change \(∑ k : Fin \d+, mul \(XVec \([0-9]+ : Fin 10\) k\)\n"
    r"[ \t]*\(AVec k \([0-9]+ : Fin 10\)\)\) \+\n"
    r"[ \t]*\(∑ k : Fin \d+, mul \(KVec \([0-9]+ : Fin 10\) k\)\n"
    r"[ \t]*\(YVec k \([0-9]+ : Fin 10\)\)\) = _\n",
    re.M,
)
UNFOLD_MATRIXMUL = re.compile(r"^(?P<indent>[ \t]*)unfold matrixMul[ \t]*$", re.M)


def rewrite(src: str) -> tuple[str, int, int]:
    out, n_change = CHANGE_SUM.subn(
        lambda m: f"{m.group('indent')}rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]\n",
        src,
    )
    out, n_unfold = UNFOLD_MATRIXMUL.subn(
        lambda m: f"{m.group('indent')}rw [matrixMul_apply]", out
    )
    return out, n_change, n_unfold


REWRITTEN = (
    "rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]",
    "rw [matrixMul_apply]",
    "unfold matrixMul",
)


def check_statements_untouched(before: str, after: str) -> None:
    """Every line outside a rewritten tactic block must survive verbatim."""
    def keep(text: str) -> list[str]:
        out, skip = [], 0
        lines = text.split("\n")
        for i, ln in enumerate(lines):
            if skip:
                skip -= 1
                continue
            s = ln.strip()
            if s in REWRITTEN:
                continue
            if s.startswith("change (∑ k : Fin"):
                skip = 3          # the change spans four emitted lines
                continue
            out.append(ln)
        return out
    b, a = keep(before), keep(after)
    if b != a:
        for i, (x, y) in enumerate(zip(b, a)):
            if x != y:
                raise SystemExit(
                    f"REFUSING TO WRITE: line {i} changed outside a rewritten tactic\n"
                    f"  before: {x!r}\n  after:  {y!r}")
        raise SystemExit(f"REFUSING TO WRITE: line count changed ({len(b)} -> {len(a)})")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+", type=Path)
    ap.add_argument("--check", action="store_true", help="report only, write nothing")
    args = ap.parse_args()
    tc = tu = touched = 0
    for f in args.files:
        p = f if f.is_absolute() else ROOT / f
        src = p.read_text()
        out, nc, nu = rewrite(src)
        check_statements_untouched(src, out)
        tc += nc
        tu += nu
        if out != src:
            touched += 1
            if not args.check:
                p.write_text(out)
    verb = "would rewrite" if args.check else "rewrote"
    print(f"{verb} {tc} `change` blocks and {tu} `unfold matrixMul` lines "
          f"in {touched} of {len(args.files)} files")


if __name__ == "__main__":
    main()
