#!/usr/bin/env python3
"""Replace `funext n; fin_cases n <;>` with `refine vec_ext ?_ .. ?_ <;>`.

`fin_cases` inlines a `List.Mem.casesOn` over `List.finRange 10` into every one
of the ten coordinate goals, and the generated certificates run it 838 times.
`D12CyclotomicVec.vec_ext` pays it once.  Measured on
`D12PieceAAActionRow0`: 68,046 per-constant nodes -> 47,321.

A post-pass in the shape of `scripts/interp_simp_arg_rewrite.py`: tactic lines
only, refuses to write if any other line moves, idempotent.

    python3 scripts/vec_ext_rewrite.py [--check] FILE...
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

OLD = "  funext n\n  fin_cases n <;>\n"
NEW = "  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>\n"

_DROP = ("funext n", "fin_cases n <;>", NEW.strip())


def non_tactic_lines(text: str) -> list[str]:
    return [l for l in text.split("\n") if l.strip() not in _DROP]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    ap.add_argument("files", nargs="+", type=Path)
    args = ap.parse_args()
    rc = 0
    for path in args.files:
        old = path.read_text(encoding="utf8")
        if not re.search(r"^open [^\n]*\bD12CyclotomicVec\b", old, re.M):
            print(f"REFUSED {path}: does not open D12CyclotomicVec",
                  file=sys.stderr)
            rc = 1
            continue
        n = old.count(OLD)
        new = old.replace(OLD, NEW)
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
