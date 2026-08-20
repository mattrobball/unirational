#!/usr/bin/env python3
"""Add `interpQ, toPolyZ` to simp lists that unfold an integer-reflected table.

The sigma carrier tables (`Kplus_poly_row*`, `Kminus_poly_row*`,
`Srestricted_reduced_poly_row*`) now hold `interpQ d [n...]` instead of
`C (a/b) + C (c/d) * X + ...`.  A consumer that names one of those rows in a
`simp` / `norm_num` list gets the Horner form back and has to unfold one more
layer, so `interpQ` and `toPolyZ` join the list.

This is a POST-PASS, not an emitter change, because
`scripts/export_sigma_plus_span.py` -- which emits `D12SigmaPlusSegreBplus` --
is one of the stale emitters that refuse to run (see MODULE_MIGRATION.md).
The in-tree source is the authority for that family.

It is strict and idempotent: it rewrites only tactic-argument lines that name a
trigger, inserts one `open` line, and refuses to write if any other line
changed.

    python3 scripts/interp_simp_arg_rewrite.py [--check] FILE...
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

TRIGGERS = (
    "Kplus_poly_row9",
    "Kminus_poly_row9",
    "Srestricted_reduced_poly_row",
)

OPEN_LINE = "open V14Formalization.D12PolyZReflection"

_STATEMENT_HEAD = re.compile(
    r"^\s*(?:@\[[^\]]*\]\s*)?(?:public\s+|private\s+|protected\s+)?"
    r"(?:noncomputable\s+)?(?:theorem|lemma|def|abbrev|instance|structure)\b"
)


def rewrite_text(text: str) -> str:
    lines = text.split("\n")
    out: list[str] = []
    for line in lines:
        if ("interpQ" not in line and "]" in line
                and any(t in line for t in TRIGGERS)
                and not _STATEMENT_HEAD.match(line)):
            # insert immediately after the last trigger occurrence's comma
            idx = max(line.rfind(t) + len(t) for t in TRIGGERS if t in line)
            # skip a row index that follows `Srestricted_reduced_poly_row`
            while idx < len(line) and line[idx].isdigit():
                idx += 1
            line = line[:idx] + ", interpQ, toPolyZ" + line[idx:]
        out.append(line)
    # `grind` closes most of the Horner-form residuals but not all of them;
    # `ring` finishes the rest and is a no-op when there is no goal left.
    if any("interpQ, toPolyZ" in l for l in out):
        patched: list[str] = []
        for i, line in enumerate(out):
            patched.append(line)
            if line.strip() == "try grind" and (
                    i + 1 >= len(out) or out[i + 1].strip() != "try ring"):
                patched.append(line.replace("try grind", "try ring"))
                patched.append(line.replace(
                    "try grind",
                    "try (norm_num [\u2190 Polynomial.C_mul])"))
        out = patched
    text = "\n".join(out)
    if OPEN_LINE not in text:
        # place it after the last `open` line of the file header
        lines = text.split("\n")
        last_open = max(
            (i for i, l in enumerate(lines) if l.startswith("open ")),
            default=None)
        if last_open is None:
            raise SystemExit("no `open` line to anchor the new import")
        lines.insert(last_open + 1, OPEN_LINE)
        text = "\n".join(lines)
    return text


def statements(text: str) -> list[str]:
    """Every declaration head and signature line, for the no-change check."""
    keep: list[str] = []
    in_sig = False
    for line in text.split("\n"):
        if _STATEMENT_HEAD.match(line):
            in_sig = True
        if in_sig:
            keep.append(line)
            if ":= by" in line or line.rstrip().endswith(":=") or "  :=" in line:
                in_sig = False
    return keep


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    ap.add_argument("files", nargs="+", type=Path)
    args = ap.parse_args()
    rc = 0
    for path in args.files:
        old = path.read_text(encoding="utf8")
        new = rewrite_text(old)
        if statements(old) != statements(new):
            print(f"REFUSED {path}: a statement line would change",
                  file=sys.stderr)
            rc = 1
            continue
        if old == new:
            print(f"unchanged {path}")
            continue
        if args.check:
            print(f"would rewrite {path}")
        else:
            path.write_text(new, encoding="utf8")
            print(f"rewrote {path}")
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
