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
     live branch head (after git fetch; git rev-parse origin/<branch>).
  7. The notebook parent head recorded in notebook_build/parent_head equals
     the current HEAD (pre-commit staleness guard: run this checker after
     reconciling, before committing) or the parent of the last commit that
     touched the notebook (post-commit replay on a fresh clone).
  8. Every manifest "entry" value matches E01-E55 (optional a/b suffix);
     no duplicate manifest paths.
  9. Coverage-by-mention: every goals_after_*/goals_2026-* level-1
     subdirectory, external_sessions/ file, and external_packets/ snapshot
     is at least mentioned in NOTEBOOK.md (these are manually indexed, not
     per-record manifest entries — see the coverage contract).
 10. Every live remote branch is registered in the notebook_build/branches/
     marker inventory.
 11. Digest freshness: the committed NOTEBOOK.md is byte-identical to
     notebook_build/generate_notebook.py's output. Search must never see
     stale content, so the digest may not drift from its sources.

Checks 9, 9b and 10 read the GENERATED digest (which check 11 pins to the
committed one). On a tree that predates the notebook_build/ split, the
generator has no sources: freshness is then reported WARN-skipped and every
other check falls back to the committed NOTEBOOK.md exactly as before.
"""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
PROBLEM_ROOT = SCRIPT_DIR.parent
BUILD_DIR = PROBLEM_ROOT / "notebook_build"
MANIFEST_PATH = BUILD_DIR / "manifest.json"
BRANCHES_DIR = BUILD_DIR / "branches"
PARENT_HEAD_PATH = BUILD_DIR / "parent_head"

sys.path.insert(0, str(BUILD_DIR))


def load_manifest() -> dict:
    with open(MANIFEST_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def generated_digest() -> tuple[str | None, str | None]:
    """(generated digest text, reason it is unavailable)."""
    try:
        from generate_notebook import BuildError, generate  # type: ignore
    except ImportError as exc:
        return None, f"generate_notebook.py not importable ({exc})"
    try:
        return generate(BUILD_DIR), None
    except BuildError as exc:
        return None, str(exc)


def decode_branch(filename: str) -> str:
    return filename.replace("%2F", "/").replace("%25", "%")


def registered_branches() -> tuple[set[str], bool]:
    """(inventory, whether the branches/ marker directory exists)."""
    if not BRANCHES_DIR.is_dir():
        return set(), False
    return ({decode_branch(p.name) for p in BRANCHES_DIR.iterdir()
             if p.is_file() and not p.name.startswith(".")}, True)


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


def git_fetch_quiet() -> bool:
    """Returns True iff a live fetch succeeded; False means cached refs only."""
    try:
        r = subprocess.run(["git", "-C", str(PROBLEM_ROOT), "fetch", "-q", "origin"],
                           capture_output=True, timeout=30)
        return r.returncode == 0
    except Exception:
        return False


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
    live_fetch = git_fetch_quiet()
    ref_mode = "live refs" if live_fetch else "CACHED refs only (fetch unavailable)"
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
        print(f"OK   branch_head_sha_pinned: {len(branch_records)} branch-only record(s), all match pinned heads ({ref_mode})")

    # --- Check 11: the committed digest is what the generator produces -----
    # Search must never see stale content, so NOTEBOOK.md may not drift from
    # notebook_build/{sections,entries}/. Every text-based check below reads
    # the generated digest, which this check pins to the committed file.
    import re
    committed_text = (PROBLEM_ROOT / "NOTEBOOK.md").read_text(encoding="utf-8")
    generated_text, gen_unavailable = generated_digest()
    if gen_unavailable is not None:
        print(f"WARN digest_freshness: generator unavailable, checking the "
              f"committed NOTEBOOK.md as-is ({gen_unavailable})")
        notebook_text = committed_text
    elif generated_text == committed_text:
        print(f"OK   digest_freshness: NOTEBOOK.md is byte-identical to the "
              f"generator output ({len(committed_text)} bytes)")
        notebook_text = generated_text
    else:
        failures += 1
        print(f"FAIL digest_freshness: NOTEBOOK.md ({len(committed_text)} bytes) "
              f"differs from the generator output ({len(generated_text)} bytes) "
              f"— run notebook_build/reconcile.py")
        notebook_text = generated_text

    # --- Check 7: notebook parent head is current (replayable) -------------
    # The pin lives in notebook_build/parent_head (it used to sit in the digest
    # text, which forced a digest diff on every branch that stamped it).
    # Passes if the recorded parent equals EITHER the parent of the last commit
    # that touched the notebook (post-commit replay on a fresh clone) OR the
    # current HEAD (pre-commit guard while the change is still staged).
    pin_source = "notebook_build/parent_head"
    if PARENT_HEAD_PATH.is_file():
        pinned = PARENT_HEAD_PATH.read_text(encoding="utf-8").strip()
        m = re.fullmatch(r"[0-9a-f]{7,40}", pinned)
    else:
        # legacy tree: the pin is still a line inside the digest
        pin_source = "NOTEBOOK.md preamble (legacy)"
        m = re.search(r"notebook parent head: `([0-9a-f]{7,40})`", committed_text)
        pinned = m.group(1) if m else ""
    head = git_rev_parse("HEAD")
    last_touch = None
    try:
        out = subprocess.run(
            ["git", "-C", str(PROBLEM_ROOT), "log", "-1", "--format=%H",
             "--", "NOTEBOOK.md", "notebook_build/parent_head"],
            capture_output=True, text=True, check=True)
        last_touch = out.stdout.strip() or None
    except subprocess.CalledProcessError:
        pass
    touch_parent = git_rev_parse(last_touch + "^") if last_touch else None
    if not m:
        failures += 1
        print(f"FAIL notebook_parent_head_current: no parent-head sha found in {pin_source}")
    elif head is None:
        failures += 1
        print("FAIL notebook_parent_head_current: could not resolve HEAD")
    elif head.startswith(pinned):
        print(f"OK   notebook_parent_head_current: recorded parent `{pinned[:12]}` matches HEAD (pre-commit mode, {pin_source})")
    elif touch_parent and touch_parent.startswith(pinned):
        print(f"OK   notebook_parent_head_current: recorded parent `{pinned[:12]}` matches parent of the last notebook commit (replay mode, {pin_source})")
    else:
        failures += 1
        print(f"FAIL notebook_parent_head_current: recorded `{pinned[:12]}`; HEAD {head[:12]}; parent-of-last-touch {(touch_parent or 'unknown')[:12]} — run notebook_build/reconcile.py")

    # --- Check 8: entry-id validity and duplicate paths --------------------
    bad_ids = [r["path"] for r in records
               if not re.fullmatch(r"E(0[1-9]|[1-4][0-9]|5[0-6])[ab]?", str(r.get("entry", "")))]
    seen: dict[str, int] = {}
    for r in records:
        seen[r["path"]] = seen.get(r["path"], 0) + 1
    dupes = sorted(p for p, n in seen.items() if n > 1)
    if bad_ids or dupes:
        failures += 1
        print(f"FAIL entry_ids_and_duplicates: {len(bad_ids)} invalid entry id(s), {len(dupes)} duplicate path(s):")
        for p in bad_ids:
            print(f"    bad-id {p}")
        for p in dupes:
            print(f"    dup    {p}")
    else:
        print(f"OK   entry_ids_and_duplicates: all entry ids valid (E01-E55[ab]), no duplicate paths")

    # --- Check 9: coverage-by-mention for manually indexed families --------
    unmentioned = []
    mention_targets: list[str] = []
    for pattern in ("goals_after_*", "goals_2026-*"):
        for batch in sorted(PROBLEM_ROOT.glob(pattern)):
            if batch.is_dir():
                for child in sorted(batch.iterdir()):
                    if child.is_dir() and not is_ignorable_dir_name(child.name):
                        mention_targets.append(child.name)
    for fam in ("external_sessions", "external_packets"):
        fam_dir = PROBLEM_ROOT / fam
        if fam_dir.is_dir():
            for child in sorted(fam_dir.iterdir()):
                if is_ignorable_dir_name(child.name) or child.name == "README.md":
                    continue
                mention_targets.append(child.name.removesuffix(".md"))
    for name in mention_targets:
        if name not in notebook_text:
            unmentioned.append(name)
    # top-level problem documents must be mentioned in NOTEBOOK.md
    for doc in sorted(PROBLEM_ROOT.glob("*.md")):
        if doc.name == "NOTEBOOK.md":
            continue
        mention_targets.append(doc.name)
        if doc.name not in notebook_text:
            unmentioned.append(doc.name)
    # tmp/ top-level dirs must be accounted for in the committed disposition
    # inventory (notebook_build/tmp_disposition.md) or NOTEBOOK.md itself.
    tmp_root = PROBLEM_ROOT / "tmp"
    disp_path = PROBLEM_ROOT / "notebook_build" / "tmp_disposition.md"
    disp_text = disp_path.read_text(encoding="utf-8") if disp_path.is_file() else ""
    if tmp_root.is_dir():
        for child in sorted(tmp_root.iterdir()):
            if not child.is_dir() or is_ignorable_dir_name(child.name):
                continue
            mention_targets.append(child.name)
            if child.name not in notebook_text and child.name not in disp_text:
                unmentioned.append("tmp/" + child.name)
    if unmentioned:
        failures += 1
        print(f"FAIL coverage_by_mention: {len(unmentioned)} of {len(mention_targets)} manually-indexed item(s) never mentioned in NOTEBOOK.md:")
        for p in unmentioned:
            print(f"    {p}")
    else:
        print(f"OK   coverage_by_mention: {len(mention_targets)} manually-indexed items all mentioned in NOTEBOOK.md")

    # --- Check 9b: packet exits must surface in the notebook ---------------
    # Every goal_run record with a genuine primary exit (not a role value)
    # must have that exit mentioned verbatim in NOTEBOOK.md — this is the
    # staleness guard that forces per-packet notebook propagation.
    ROLE_VALUES = {"SUBRUN-ONLY", "EVIDENCE-FOR-PARENT", "NO-INDEPENDENT-EXIT",
                   "SUPERSEDED", "PROPOSAL-UNRUN", "UNDECIDED"}
    unsurfaced = [(r["path"], r["primary_exit"]) for r in records
                  if r.get("kind") == "goal_run"
                  and r.get("primary_exit") not in ROLE_VALUES
                  and str(r.get("primary_exit")) not in notebook_text]
    if unsurfaced:
        failures += 1
        print(f"FAIL exits_surfaced_in_notebook: {len(unsurfaced)} packet exit(s) not mentioned in NOTEBOOK.md:")
        for p, e in unsurfaced:
            print(f"    {e}  ({p})")
    else:
        n_exits = sum(1 for r in records if r.get("kind") == "goal_run"
                      and r.get("primary_exit") not in ROLE_VALUES)
        print(f"OK   exits_surfaced_in_notebook: {n_exits} genuine packet exits, all mentioned in NOTEBOOK.md")

    # --- Check 10: no unknown remote branches ------------------------------
    # The inventory is one marker file per branch under notebook_build/
    # branches/ (registration = adding a file, so it never conflicts). A
    # legacy manifest.json "known_branches" array, if still present, is
    # unioned in so the check never regresses mid-migration.
    marker_known, have_markers = registered_branches()
    legacy_known = set(manifest.get("known_branches", []))
    known = marker_known | legacy_known
    if legacy_known:
        print(f"WARN branch_inventory: manifest.json still carries a legacy "
              f"'known_branches' array ({len(legacy_known)} name(s)) — run "
              f"notebook_build/migrate_split.py to move it to branches/")
    if have_markers:
        print(f"OK   branch_inventory: {len(marker_known)} marker file(s) in "
              f"notebook_build/branches/")
    if known:
        try:
            out = subprocess.run(
                ["git", "-C", str(PROBLEM_ROOT), "for-each-ref",
                 "--format=%(refname:short)", "refs/remotes/origin"],
                capture_output=True, text=True, check=True)
            live_branches = {b.removeprefix("origin/") for b in out.stdout.split()
                             if b not in ("origin", "origin/HEAD")}
            unknown = sorted(live_branches - known)
        except subprocess.CalledProcessError:
            unknown = None
        if unknown is None:
            print("WARN unknown_remote_branches: could not enumerate remote refs")
        elif unknown:
            failures += 1
            print(f"FAIL unknown_remote_branches: {len(unknown)} branch(es) not in the branch inventory ({ref_mode}) — register with notebook_build/register_branch.py:")
            for b in unknown:
                print(f"    {b}")
        else:
            print(f"OK   unknown_remote_branches: {len(live_branches)} remote branch(es), all in the branch inventory ({ref_mode})")
    else:
        print("WARN unknown_remote_branches: no branch inventory found (neither notebook_build/branches/ nor manifest 'known_branches')")

    print()
    if failures:
        print(f"RESULT: FAIL ({failures} check(s) failed)")
        return 1
    print("RESULT: PASS (all checks passed)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
