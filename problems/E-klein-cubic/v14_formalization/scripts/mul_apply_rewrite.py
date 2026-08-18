#!/usr/bin/env python3
"""Point the Plucker coefficient certificates at `mul_apply_k`.

The generated `*_apply_k` certificates prove one coordinate of a product of
cyclotomic vectors with

    norm_num [<defs>, mul, conv, coeffAt, Fin.sum_univ_succ]

so every one of them makes `norm_num` expand `mul` into its three ten-term
convolutions before it can do any arithmetic -- about 18,000 `Expr` nodes per
coordinate, and there are ~380 of them.  `D12CyclotomicVec.mul_apply_{0..9}`
writes that expansion out once per coordinate, so the certificate keeps only
its arithmetic.  Measured on `D12PiecePPDeterminant`: 2,287,031 per-constant
nodes -> 449,127.

This is a post-pass, not an emitter change, in the shape of
`scripts/interp_simp_arg_rewrite.py`: it rewrites tactic-argument lines only,
and refuses to write if any other line moves.  Strict (the coordinate index in
the theorem name must match the one in its statement) and idempotent.

    python3 scripts/mul_apply_rewrite.py [--check] FILE...
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

OLD = "mul, conv, coeffAt, Fin.sum_univ_succ"

_BLOCK = re.compile(
    r"(theorem (\w+)_apply_(\d+) :\n"          # 1 head, 2 stem, 3 index
    r"    [^\n]*\((\d+) : Fin 10\)[^\n]*\n"    # 4 the coordinate in the statement
    r"  norm_num \[)"
    r"((?:(?!theorem )[\s\S])*?)"              # 5 the argument list
    + re.escape(OLD) + r"\]")


def rewrite_text(text: str) -> tuple[str, int]:
    count = 0

    def sub(m: re.Match) -> str:
        nonlocal count
        if m.group(3) != m.group(4):
            raise SystemExit(
                f"index mismatch in {m.group(2)}_apply_{m.group(3)}")
        count += 1
        # the list may wrap; keep it on the lines it already occupies
        args = m.group(5).rstrip().rstrip(",")
        return m.group(1) + args + ", mul_apply_" + m.group(3) + "]"

    return _BLOCK.sub(sub, text), count


def non_tactic_lines(text: str) -> list[str]:
    """Everything that is not a `norm_num` argument line."""
    keep: list[str] = []
    for line in text.split("\n"):
        s = line.strip()
        if s.startswith("norm_num [") or (
                s.endswith("]") and ("mul_apply_" in s or OLD in s)):
            continue
        keep.append(line)
    return keep


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    ap.add_argument("files", nargs="+", type=Path)
    args = ap.parse_args()
    rc = 0
    for path in args.files:
        old = path.read_text(encoding="utf8")
        new, n = rewrite_text(old)
        if non_tactic_lines(old) != non_tactic_lines(new):
            print(f"REFUSED {path}: a non-tactic line would change",
                  file=sys.stderr)
            rc = 1
            continue
        if old == new:
            print(f"unchanged {path}")
            continue
        if args.check:
            print(f"would rewrite {path} ({n})")
        else:
            path.write_text(new, encoding="utf8")
            print(f"rewrote {path} ({n})")
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
