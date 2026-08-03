#!/usr/bin/env python3
"""Standalone parity checker for notebook_build/manifest.json.

Verifies the manifest ledger against the on-disk repository state. Exits
nonzero if any check fails. Uses only the python3 standard library.

Checks:
  1. Every goal_runs_after_*/ "run dir" (a directory containing its own
     verify*.py or STATUS.md, found at most one sublevel below the
     goal_runs_after_* batch container) has a manifest record.
  2. Every direct certificates/* subdirectory has a manifest record.
  3. Every manifest record with tracked == "main" points to a path that
     exists on disk.
  4. Every manifest record has a non-null "entry" mapping.
  5. No manifest record has verification_class == "UNCLASSIFIED" or a
     null primary_exit.
  6. Every branch-only record's pinned branch_head_sha still matches the
     live branch head (git rev-parse origin/<branch>).
"""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
PROBLEM_ROOT = SCRIPT_DIR.parent
MANIFEST_PATH = PROBLEM_ROOT / "notebook_build" / "manifest.json"


def load_manifest() -> dict:
    with open(MANIFEST_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def is_run_dir(path: Path) -> bool:
    """A directory counts as its own 'run dir' if it directly contains a
    verify*.py file or a STATUS.md file (not recursively)."""
    if not path.is_dir():
        return False
    if (path / "STATUS.md").is_file():
        return True
    for child in path.iterdir():
        if child.is_file() and child.name.startswith("verify") and child.name.endswith(".py"):
            return True
    return False


def find_goal_run_dirs() -> set[str]:
    """Find every goal_runs_after_*/ run dir (at most one sublevel below
    the batch container) that looks like its own run, as a set of paths
    relative to PROBLEM_ROOT."""
    found: set[str] = set()
    for batch in sorted(PROBLEM_ROOT.glob("goal_runs_after_*")):
        if not batch.is_dir():
            continue
        for level1 in sorted(batch.iterdir()):
            if not level1.is_dir() or level1.name.startswith("."):
                continue
            if is_run_dir(level1):
                found.add(str(level1.relative_to(PROBLEM_ROOT)))
            for level2 in sorted(level1.iterdir()):
                if not level2.is_dir() or is_ignorable_dir_name(level2.name):
                    continue
                if is_run_dir(level2):
                    found.add(str(level2.relative_to(PROBLEM_ROOT)))
    return found


def is_ignorable_dir_name(name: str) -> bool:
    """Build/cache artifacts and hidden dirs are not content packets."""
    return name == "__pycache__" or name.startswith(".")


def find_certificate_dirs() -> set[str]:
    cert_root = PROBLEM_ROOT / "certificates"
    found: set[str] = set()
    if not cert_root.is_dir():
        return found
    for child in sorted(cert_root.iterdir()):
        if child.is_dir() and not is_ignorable_dir_name(child.name):
            found.add(str(child.relative_to(PROBLEM_ROOT)))
    return found


def git_rev_parse(ref: str) -> str | None:
    try:
        out = subprocess.run(
            ["git", "-C", str(PROBLEM_ROOT), "rev-parse", ref],
            capture_output=True,
            text=True,
            check=True,
        )
        return out.stdout.strip()
    except subprocess.CalledProcessError:
        return None


def main() -> int:
    failures = 0

    try:
        manifest = load_manifest()
    except (OSError, json.JSONDecodeError) as exc:
        print(f"FAIL manifest_parses: could not load/parse {MANIFEST_PATH}: {exc}")
        return 1

    records = manifest.get("records", [])
    manifest_paths = {r["path"] for r in records}

    # --- Check 1+2: unmapped directories on disk -------------------------
    disk_goal_run_dirs = find_goal_run_dirs()
    unmapped_goal_runs = sorted(disk_goal_run_dirs - manifest_paths)
    if unmapped_goal_runs:
        failures += 1
        print(f"FAIL unmapped_goal_run_dirs: {len(unmapped_goal_runs)} run dir(s) missing from manifest:")
        for p in unmapped_goal_runs:
            print(f"    {p}")
    else:
        print(f"OK   unmapped_goal_run_dirs: 0 missing ({len(disk_goal_run_dirs)} run dirs on disk, all mapped)")

    disk_cert_dirs = find_certificate_dirs()
    unmapped_certs = sorted(disk_cert_dirs - manifest_paths)
    if unmapped_certs:
        failures += 1
        print(f"FAIL unmapped_certificate_dirs: {len(unmapped_certs)} certificates/* subdir(s) missing from manifest:")
        for p in unmapped_certs:
            print(f"    {p}")
    else:
        print(f"OK   unmapped_certificate_dirs: 0 missing ({len(disk_cert_dirs)} certificate dirs on disk, all mapped)")

    # --- Check 3: main-tracked paths exist on disk ------------------------
    missing_on_disk = []
    for r in records:
        if r.get("tracked") == "main":
            if not (PROBLEM_ROOT / r["path"]).exists():
                missing_on_disk.append(r["path"])
    if missing_on_disk:
        failures += 1
        print(f"FAIL main_tracked_paths_exist: {len(missing_on_disk)} path(s) tracked:'main' absent on disk:")
        for p in missing_on_disk:
            print(f"    {p}")
    else:
        n_main = sum(1 for r in records if r.get("tracked") == "main")
        print(f"OK   main_tracked_paths_exist: {n_main} tracked:'main' record(s), all present on disk")

    # --- Check 4: entry mapping present ------------------------------------
    missing_entry = [r["path"] for r in records if not r.get("entry")]
    if missing_entry:
        failures += 1
        print(f"FAIL entry_mapping_present: {len(missing_entry)} record(s) without an 'entry' mapping:")
        for p in missing_entry:
            print(f"    {p}")
    else:
        print(f"OK   entry_mapping_present: {len(records)} record(s), all have an 'entry' mapping")

    # --- Check 5: no UNCLASSIFIED / null primary_exit ----------------------
    unclassified = [r["path"] for r in records if r.get("verification_class") == "UNCLASSIFIED"]
    if unclassified:
        failures += 1
        print(f"FAIL no_unclassified_verification_class: {len(unclassified)} record(s) still UNCLASSIFIED:")
        for p in unclassified:
            print(f"    {p}")
    else:
        print(f"OK   no_unclassified_verification_class: 0 remaining UNCLASSIFIED ({len(records)} records checked)")

    null_exit = [r["path"] for r in records if r.get("primary_exit") is None]
    if null_exit:
        failures += 1
        print(f"FAIL no_null_primary_exit: {len(null_exit)} record(s) with null primary_exit:")
        for p in null_exit:
            print(f"    {p}")
    else:
        print(f"OK   no_null_primary_exit: 0 remaining null primary_exit ({len(records)} records checked)")

    # --- Check 6: branch-only heads still match pinned SHA -----------------
    branch_records = [r for r in records if r.get("tracked") == "branch-only"]
    branch_mismatches = []
    branch_unresolved = []
    for r in branch_records:
        branch = r.get("branch")
        pinned = r.get("branch_head_sha")
        if not branch or not pinned:
            branch_mismatches.append(f"{r['path']}: missing 'branch' or 'branch_head_sha' field")
            continue
        live = git_rev_parse(f"origin/{branch}")
        if live is None:
            branch_unresolved.append(f"{r['path']}: could not resolve origin/{branch}")
        elif live != pinned:
            branch_mismatches.append(f"{r['path']}: origin/{branch} is now {live}, pinned {pinned}")
    if branch_mismatches or branch_unresolved:
        failures += 1
        print(f"FAIL branch_head_sha_pinned: {len(branch_mismatches)} mismatch(es), {len(branch_unresolved)} unresolved, of {len(branch_records)} branch-only record(s):")
        for m in branch_mismatches + branch_unresolved:
            print(f"    {m}")
    else:
        print(f"OK   branch_head_sha_pinned: {len(branch_records)} branch-only record(s), all match live branch heads")

    print()
    if failures:
        print(f"RESULT: FAIL ({failures} check(s) failed)")
        return 1
    print("RESULT: PASS (all checks passed)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
