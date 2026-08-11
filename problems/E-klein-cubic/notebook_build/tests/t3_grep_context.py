#!/usr/bin/env python3
"""T3 -- grep-discoverability is byte-for-byte what it was before the split.

A fresh session finds its way in by grepping ONE file and reading around the
hit. This asserts that for three probe strings -- an exit marker, a packet
path, and a theorem name from an old entry -- `grep -C3` against the generated
digest returns exactly the same text as against the pre-migration digest.

Line numbers are allowed to shift (the preamble's pin block moved out); the
matched line and its three lines of context on each side must be identical
text, and the number of hits must be identical.

    python3 t3_grep_context.py --repo <clone> [--baseline REV]
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

LEGACY_PIN_RE = re.compile(r"notebook parent head: `[0-9a-f]{7,40}`")

PROBES = [
    ("exit marker", "SPIN-ROUTE-CLOSED-METHOD-INSUFFICIENT"),
    ("packet path", "goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE"),
    ("theorem name from an old entry", "B-BRIDGE-REFUTED"),
]

failures: list[str] = []


def git(repo: Path, *args: str, check_rc: bool = True) -> str:
    r = subprocess.run(["git", "-C", str(repo), *args],
                       capture_output=True, text=True)
    if check_rc and r.returncode != 0:
        raise SystemExit(f"git {' '.join(args)} failed: {r.stderr.strip()}")
    return r.stdout


def find_baseline(repo: Path, rel: str) -> str | None:
    for rev in git(repo, "log", "--format=%H", "--", rel).split():
        if LEGACY_PIN_RE.search(git(repo, "show", f"{rev}:{rel}", check_rc=False)):
            return rev
    return None


def grep_context(text: str, needle: str, ctx: int = 3) -> list[str]:
    """`grep -C<ctx>` output as a list of hit blocks, text only."""
    lines = text.split("\n")
    blocks = []
    for i, line in enumerate(lines):
        if needle in line:
            lo, hi = max(0, i - ctx), min(len(lines), i + ctx + 1)
            blocks.append("\n".join(lines[lo:hi]))
    return blocks


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", required=True)
    ap.add_argument("--baseline", default="auto")
    args = ap.parse_args()

    repo = Path(args.repo).resolve()
    rel = "problems/E-klein-cubic/NOTEBOOK.md"
    generated = (repo / rel).read_text(encoding="utf-8")

    if args.baseline == "auto":
        rev = find_baseline(repo, rel)
        if rev is None:
            print("FAIL T3 baseline: no pre-migration NOTEBOOK.md found in history")
            return 1
    else:
        rev = args.baseline
    baseline = git(repo, "show", f"{rev}:{rel}")
    print(f"     T3 baseline: pre-migration revision {rev[:12]}")

    for label, needle in PROBES:
        before = grep_context(baseline, needle)
        after = grep_context(generated, needle)
        ok = bool(before) and before == after
        print(f"{'OK  ' if ok else 'FAIL'} T3 {label}: {needle!r} -- "
              f"{len(before)} hit(s) before, {len(after)} after, "
              f"context {'identical' if before == after else 'DIFFERS'}")
        if not ok:
            failures.append(needle)
            if before and after:
                for b, a in zip(before, after):
                    if b != a:
                        print("     before:\n" + b)
                        print("     after:\n" + a)
                        break
            elif not before:
                print(f"     probe not found in the baseline digest at all")

    print(f"\nT3 RESULT: {'PASS' if not failures else 'FAIL ' + str(failures)}")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
