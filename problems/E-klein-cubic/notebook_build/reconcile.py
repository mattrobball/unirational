#!/usr/bin/env python3
"""Regenerate the Problem E notebook digest, stamp the pin, stage the result.

This is the one command a session runs before committing notebook work, and
the one command that resolves a digest merge conflict.

    reconcile.py                  regenerate NOTEBOOK.md, stamp
                                  notebook_build/parent_head = HEAD, git add
    reconcile.py --resolve-merge  same, and also `git add` the whole source
                                  tree, so a conflicted merge becomes
                                  committable with no hand editing
    reconcile.py --no-stage       regenerate and stamp, stage nothing
    reconcile.py --no-pin         regenerate only (leave parent_head alone)

Pin semantics are unchanged: parent_head records the commit the revision was
authored against, so before committing it equals HEAD, and after committing it
equals the parent of the commit that last touched the notebook. That is what
scripts/check_manifest_parity.py checks.

It also installs the merge driver (setup_merge_driver.sh) if this clone does
not have it yet.
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from generate_notebook import BuildError, generate  # noqa: E402

BUILD_DIR = Path(__file__).resolve().parent
PROBLEM_ROOT = BUILD_DIR.parent
NOTEBOOK_PATH = PROBLEM_ROOT / "NOTEBOOK.md"
PIN_PATH = BUILD_DIR / "parent_head"


def git(*args: str, check: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(["git", "-C", str(PROBLEM_ROOT), *args],
                          capture_output=True, text=True, check=check)


def ensure_merge_driver() -> None:
    if os.environ.get("NOTEBOOK_SKIP_DRIVER_SETUP"):
        return
    r = git("config", "--get", "merge.notebook.driver", check=False)
    if r.returncode == 0 and r.stdout.strip():
        return
    script = BUILD_DIR / "setup_merge_driver.sh"
    if not script.is_file():
        print("reconcile: setup_merge_driver.sh missing; skipping driver setup",
              file=sys.stderr)
        return
    s = subprocess.run(["sh", str(script)], cwd=str(PROBLEM_ROOT),
                       capture_output=True, text=True)
    if s.returncode == 0:
        print("reconcile: installed the notebook merge driver in this clone")
    else:
        print(f"reconcile: could not install the merge driver: "
              f"{s.stderr.strip()}", file=sys.stderr)


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--resolve-merge", action="store_true",
                    help="also stage the merged source tree")
    ap.add_argument("--no-stage", action="store_true")
    ap.add_argument("--no-pin", action="store_true")
    ap.add_argument("--pin", default=None, metavar="SHA",
                    help="stamp this sha instead of HEAD")
    args = ap.parse_args(argv)

    ensure_merge_driver()

    try:
        text = generate(BUILD_DIR)
    except BuildError as exc:
        print(f"reconcile: {exc}", file=sys.stderr)
        return 2
    before = NOTEBOOK_PATH.read_text(encoding="utf-8") if NOTEBOOK_PATH.is_file() else None
    NOTEBOOK_PATH.write_text(text, encoding="utf-8")
    verb = "unchanged" if before == text else "regenerated"
    print(f"NOTEBOOK.md {verb} ({len(text)} bytes)")

    if not args.no_pin:
        head = args.pin or git("rev-parse", "HEAD").stdout.strip()
        PIN_PATH.write_text(head + "\n", encoding="utf-8")
        print(f"parent_head stamped {head[:12]}")

    if not args.no_stage:
        paths = ["NOTEBOOK.md", "notebook_build/parent_head"]
        if args.resolve_merge:
            paths += ["notebook_build/sections", "notebook_build/entries",
                      "notebook_build/branches"]
        paths = [p for p in paths if (PROBLEM_ROOT / p).exists()]
        git("add", "--", *paths)
        print(f"staged: {', '.join(paths)}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
