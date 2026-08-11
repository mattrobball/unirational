#!/usr/bin/env python3
"""Register a remote branch in the Problem E branch inventory.

The inventory used to be manifest.json's `known_branches` array, which every
session edited in the same place. It is now one marker file per branch under
notebook_build/branches/, so registering a branch adds a new file and never
conflicts. `/` in a branch name is encoded as `%2F` (and `%` as `%25`); the
file NAME is authoritative.

    register_branch.py                 register the current branch
    register_branch.py NAME [NAME...]  register these branches
    register_branch.py --list          print the registered inventory
    register_branch.py --missing       print live origin/* branches that are
                                       not registered yet
"""

from __future__ import annotations

import argparse
import datetime
import subprocess
import sys
from pathlib import Path

BUILD_DIR = Path(__file__).resolve().parent
BRANCHES_DIR = BUILD_DIR / "branches"


def encode(name: str) -> str:
    return name.replace("%", "%25").replace("/", "%2F")


def decode(filename: str) -> str:
    return filename.replace("%2F", "/").replace("%25", "%")


def registered() -> set[str]:
    if not BRANCHES_DIR.is_dir():
        return set()
    return {decode(p.name) for p in BRANCHES_DIR.iterdir()
            if p.is_file() and not p.name.startswith(".")}


def live_branches() -> set[str]:
    out = subprocess.run(
        ["git", "-C", str(BUILD_DIR), "for-each-ref",
         "--format=%(refname:short)", "refs/remotes/origin"],
        capture_output=True, text=True, check=True).stdout.split()
    return {b.removeprefix("origin/") for b in out
            if b not in ("origin", "origin/HEAD")}


def current_branch() -> str:
    return subprocess.run(
        ["git", "-C", str(BUILD_DIR), "rev-parse", "--abbrev-ref", "HEAD"],
        capture_output=True, text=True, check=True).stdout.strip()


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("names", nargs="*")
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--missing", action="store_true")
    ap.add_argument("--note", default="", help="free-text note in the marker")
    args = ap.parse_args(argv)

    if args.list:
        for name in sorted(registered()):
            print(name)
        return 0
    if args.missing:
        missing = sorted(live_branches() - registered())
        for name in missing:
            print(name)
        return 1 if missing else 0

    names = args.names or [current_branch()]
    BRANCHES_DIR.mkdir(exist_ok=True)
    for name in names:
        marker = BRANCHES_DIR / encode(name)
        if marker.exists():
            print(f"already registered: {name}")
            continue
        # Deterministic content on purpose: if two sessions register the same
        # branch, both write the same bytes and git resolves the add/add
        # without a conflict.
        body = f"branch: {name}\n"
        if args.note:
            body += f"note: {args.note}\n"
        marker.write_text(body, encoding="utf-8")
        print(f"registered: {name}  ({marker.relative_to(BUILD_DIR.parent)})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
