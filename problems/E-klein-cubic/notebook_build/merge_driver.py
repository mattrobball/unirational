#!/usr/bin/env python3
"""Git merge driver for the generated Problem E notebook digest.

Declared in problems/E-klein-cubic/.gitattributes as `merge=notebook` and
wired up per clone by notebook_build/setup_merge_driver.sh (reconcile.py runs
that for you if the driver is not configured).

Two paths use it:

  NOTEBOOK.md            both textual sides are DISCARDED. The digest is
                         regenerated from the three-way merge of the *source*
                         trees (notebook_build/sections + entries) taken from
                         HEAD, MERGE_HEAD and their merge base. Two sessions
                         adding two different entry files therefore merge with
                         no conflict and no manual step.
  notebook_build/parent_head
                         resolved to the current HEAD, which is exactly what
                         the parity checker's pre-commit/replay pin semantics
                         want for a merge commit (its first parent).

Sources are read from git trees rather than the worktree on purpose: git
processes `NOTEBOOK.md` before `notebook_build/...` (capital N sorts first), so
the worktree copies of the entry files are not reliably merged yet when this
driver runs.

Called as: merge_driver.py %O %A %B %P   (writes the result into %A)
Exit 0 = resolved, nonzero = leave it to a human (then: run reconcile.py).
"""

from __future__ import annotations

import subprocess
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from generate_notebook import (BuildError, ENTRIES_DIRNAME,  # noqa: E402
                               SECTIONS_DIRNAME, generate_from_parts)

BUILD_DIR = Path(__file__).resolve().parent


def git(*args: str, check: bool = True) -> str:
    r = subprocess.run(["git", *args], capture_output=True, text=True)
    if check and r.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)}: {r.stderr.strip()}")
    return r.stdout


def rev(name: str) -> str | None:
    r = subprocess.run(["git", "rev-parse", "--verify", "--quiet", name],
                       capture_output=True, text=True)
    out = r.stdout.strip()
    return out or None


def source_prefix(pathname: str) -> str:
    """Build-dir path relative to the repo root, derived from %P.

    Derived from the merged file's own repo-relative path so the driver works
    in any clone, including one whose checkout is not the clone this script
    was installed from.
    """
    return pathname.rsplit("/", 1)[0] + "/notebook_build"


def tree_parts(revision: str | None, prefix: str) -> dict[str, str]:
    """{part path relative to the build dir: blob sha} for one revision."""
    if revision is None:
        return {}
    out = git("ls-tree", "-r", "-z", revision, "--",
              f"{prefix}/{SECTIONS_DIRNAME}", f"{prefix}/{ENTRIES_DIRNAME}")
    parts: dict[str, str] = {}
    for rec in out.split("\0"):
        if not rec:
            continue
        meta, path = rec.split("\t", 1)
        mode, kind, sha = meta.split()
        if kind != "blob":
            continue
        parts[path[len(prefix) + 1:]] = sha
    return parts


def blob(sha: str | None) -> str:
    if sha is None:
        return ""
    return git("cat-file", "blob", sha)


def three_way(base: str, ours: str, theirs: str, label: str) -> str | None:
    """Clean merge -> text; conflict -> None."""
    with tempfile.TemporaryDirectory() as td:
        paths = []
        for name, text in (("ours", ours), ("base", base), ("theirs", theirs)):
            p = Path(td) / name
            p.write_text(text, encoding="utf-8")
            paths.append(str(p))
        r = subprocess.run(
            ["git", "merge-file", "-p", "-L", f"ours/{label}",
             "-L", f"base/{label}", "-L", f"theirs/{label}", *paths],
            capture_output=True, text=True)
        if r.returncode != 0:
            return None
        return r.stdout


def part_order(name: str) -> tuple[int, str]:
    return (0 if name.startswith(SECTIONS_DIRNAME + "/") else 1, name)


def merged_parts(pathname: str) -> list[tuple[str, str]]:
    prefix = source_prefix(pathname)
    head, other = rev("HEAD"), rev("MERGE_HEAD")
    if other is None:
        for alt in ("REBASE_HEAD", "CHERRY_PICK_HEAD", "REVERT_HEAD"):
            other = rev(alt)
            if other:
                break
    if head is None or other is None:
        raise RuntimeError("no HEAD/MERGE_HEAD pair to merge sources from")
    base = subprocess.run(["git", "merge-base", head, other],
                          capture_output=True, text=True).stdout.strip() or None

    ours = tree_parts(head, prefix)
    theirs = tree_parts(other, prefix)
    anc = tree_parts(base, prefix)

    parts: list[tuple[str, str]] = []
    for name in sorted(set(ours) | set(theirs), key=part_order):
        o, t, b = ours.get(name), theirs.get(name), anc.get(name)
        if o == t:
            keep = o
        elif b == o:
            keep = t
        elif b == t:
            keep = o
        else:
            text = three_way(blob(b), blob(o), blob(t), name)
            if text is None:
                raise RuntimeError(
                    f"source part {name} conflicts; resolve it, then run "
                    f"notebook_build/reconcile.py")
            parts.append((name, text))
            continue
        if keep is None:
            continue  # deleted on the winning side
        parts.append((name, blob(keep)))
    return parts


def main(argv: list[str]) -> int:
    if len(argv) < 4:
        print("merge_driver: expected %O %A %B %P", file=sys.stderr)
        return 2
    _ancestor, current, _other, pathname = argv[0], argv[1], argv[2], argv[3]

    try:
        if pathname.endswith("parent_head"):
            head = rev("HEAD")
            if head is None:
                return 1
            Path(current).write_text(head + "\n", encoding="utf-8")
            print(f"merge driver: parent_head resolved to HEAD {head[:12]}",
                  file=sys.stderr)
            return 0

        if not pathname.endswith("NOTEBOOK.md"):
            print(f"merge driver: unexpected path {pathname}", file=sys.stderr)
            return 1

        text = generate_from_parts(merged_parts(pathname))
        Path(current).write_text(text, encoding="utf-8")
        print(f"merge driver: NOTEBOOK.md regenerated from the merged sources "
              f"({len(text)} bytes)", file=sys.stderr)
        return 0
    except (RuntimeError, BuildError, OSError) as exc:
        print(f"merge driver: {exc}", file=sys.stderr)
        print("merge driver: leaving the conflict in place; after resolving "
              "the sources run notebook_build/reconcile.py", file=sys.stderr)
        return 1


if __name__ == "__main__":
    # git runs merge drivers from the top of the merging worktree; stay there
    # so every git call below targets the repository actually being merged.
    sys.exit(main(sys.argv[1:]))
