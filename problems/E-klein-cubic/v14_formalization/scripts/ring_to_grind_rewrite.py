#!/usr/bin/env python3
"""Emitter pass: close the pointwise-eval identities with `grind`, not `ring`.

Pipeline position
-----------------
    <frozen emitter>  ->  D12SigmaPlusSegre{SmoothC*,Det*}.lean
    THIS PASS         ->  same files, in place

Use this only for the generated families whose emit code predates the repo and
is therefore not in `scripts/` (the SmoothC charts and the Det coefficient
identities).  Families that still have a live emitter carry the change in the
emitter instead -- see `export_sigma_plus_identities.py`, which emits
`try grind` directly.  Never hand-edit the outputs; re-run this instead.

What it changes, and why
------------------------
Only *proofs*, and only one tactic line per proof:

    refine Polynomial.funext fun r => ?_
    simp only [<the definitions>]
    simp [Polynomial.eval_add, ...]
    try ring          ->    try grind

Every one of these goals is a polynomial identity over a commutative ring
after the eval-simp, which both tactics discharge.  `ring` reflects the goal
and inlines the whole normalisation trace into the proof term; `grind` closes
it through its own commutative-ring solver and stores a much smaller
certificate.  Measured on D12SigmaPlusSegreNH_0_0, built standalone before and
after the substitution:

    dedup Expr nodes, per-constant   329,763 -> 121,223   (-63.2%)
    dedup Expr nodes, per-module     163,531 ->  39,872   (-75.6%)
    elaboration time                   8.05s ->   8.07s   (unchanged)

Statement preservation
----------------------
The pass is strict and idempotent, and it proves that it touched no statement:
it extracts every line of the file that is not the rewritten tactic and
refuses to write if any of them differs from the input.  A file with no
`try ring` is left byte-identical.
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# The one line this pass is allowed to change.
RING_RE = re.compile(r"^(?P<indent>[ \t]*)try ring[ \t]*$", re.M)
GRIND = "try grind"


def rewrite(src: str) -> tuple[str, int]:
    """Return (rewritten source, number of substitutions)."""
    out, n = RING_RE.subn(lambda m: f"{m.group('indent')}{GRIND}", src)
    return out, n


def check_only_tactic_changed(before: str, after: str) -> None:
    """Every line except the rewritten tactic must survive byte-for-byte."""
    b = [ln for ln in before.split("\n") if ln.strip() not in ("try ring", GRIND)]
    a = [ln for ln in after.split("\n") if ln.strip() not in ("try ring", GRIND)]
    if b != a:
        for i, (x, y) in enumerate(zip(b, a)):
            if x != y:
                raise SystemExit(
                    f"REFUSING TO WRITE: line {i} changed outside the tactic\n"
                    f"  before: {x!r}\n  after:  {y!r}"
                )
        raise SystemExit(
            f"REFUSING TO WRITE: line count changed ({len(b)} -> {len(a)})"
        )


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+", type=Path)
    ap.add_argument("--check", action="store_true",
                    help="report what would change; write nothing")
    args = ap.parse_args()

    total = 0
    touched = 0
    for p in args.files:
        if not p.is_absolute():
            p = ROOT / p
        src = p.read_text()
        out, n = rewrite(src)
        check_only_tactic_changed(src, out)
        total += n
        if n:
            touched += 1
            if not args.check:
                p.write_text(out)
        print(f"{p.relative_to(ROOT)}: {n}")
    verb = "would rewrite" if args.check else "rewrote"
    print(f"{verb} {total} tactic lines in {touched} of {len(args.files)} files")
    if not args.check:
        sys.path.insert(0, str(Path(__file__).resolve().parent))
        from module_annotation_hook import reapply_module_annotations
        reapply_module_annotations()


if __name__ == "__main__":
    main()
