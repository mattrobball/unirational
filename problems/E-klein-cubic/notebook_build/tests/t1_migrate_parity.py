#!/usr/bin/env python3
"""T1 -- migrate, regenerate, parity, and no content lost.

Run in a scratch clone (tests/run_tests.sh does that for you):

    python3 t1_migrate_parity.py --repo <clone> [--baseline REV|none]

Asserts, programmatically:
  1. migrate_split.py --force reassembles byte-identically to its input;
  2. the regenerated digest equals the committed one (migration is a no-op
     round trip on an already-migrated tree -- i.e. it is idempotent);
  3. running it twice produces the identical source tree;
  4. check_manifest_parity.py exits 0;
  5. every `#`/`##` heading of the BASELINE digest is present in the generated
     digest, verbatim;
  6. every genuine primary_exit string in manifest.json is present in the
     generated digest, verbatim.

The baseline is auto-detected as the newest revision whose NOTEBOOK.md still
carries the pre-migration `notebook parent head: \\`sha\\`` line -- i.e. the last
hand-edited digest. Pass --baseline none to compare against the committed
digest instead (do that if a later session deliberately deletes a heading).
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

LEGACY_PIN_RE = re.compile(r"notebook parent head: `[0-9a-f]{7,40}`")
ROLE_VALUES = {"SUBRUN-ONLY", "EVIDENCE-FOR-PARENT", "NO-INDEPENDENT-EXIT",
               "SUPERSEDED", "PROPOSAL-UNRUN", "UNDECIDED"}

failures: list[str] = []


def check(ok: bool, label: str, detail: str = "") -> None:
    print(f"{'OK  ' if ok else 'FAIL'} T1 {label}{(': ' + detail) if detail else ''}")
    if not ok:
        failures.append(label)


def git(repo: Path, *args: str, check_rc: bool = True) -> str:
    r = subprocess.run(["git", "-C", str(repo), *args],
                       capture_output=True, text=True)
    if check_rc and r.returncode != 0:
        raise SystemExit(f"git {' '.join(args)} failed: {r.stderr.strip()}")
    return r.stdout


def digest_of_tree(d: Path) -> str:
    h = hashlib.sha256()
    for p in sorted(d.rglob("*")):
        if p.is_file():
            h.update(str(p.relative_to(d)).encode())
            h.update(p.read_bytes())
    return h.hexdigest()


def find_baseline(repo: Path, rel: str) -> str | None:
    for rev in git(repo, "log", "--format=%H", "--", rel).split():
        blob = git(repo, "show", f"{rev}:{rel}", check_rc=False)
        if LEGACY_PIN_RE.search(blob):
            return rev
    return None


def headings(text: str) -> list[str]:
    return [l for l in text.split("\n")
            if l.startswith("# ") or l.startswith("## ")]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", required=True)
    ap.add_argument("--baseline", default="auto")
    args = ap.parse_args()

    repo = Path(args.repo).resolve()
    problem = repo / "problems" / "E-klein-cubic"
    build = problem / "notebook_build"
    rel = "problems/E-klein-cubic/NOTEBOOK.md"

    committed = (problem / "NOTEBOOK.md").read_text(encoding="utf-8")

    if args.baseline == "auto":
        rev = find_baseline(repo, rel)
        baseline = git(repo, "show", f"{rev}:{rel}") if rev else committed
        src = f"pre-migration revision {rev[:12]}" if rev else "committed digest"
    elif args.baseline == "none":
        baseline, src = committed, "committed digest"
    else:
        baseline = git(repo, "show", f"{args.baseline}:{rel}")
        src = args.baseline[:12]
    print(f"     T1 baseline: {src} ({len(baseline)} chars)")

    r = subprocess.run([sys.executable, str(build / "migrate_split.py"), "--force"],
                       capture_output=True, text=True)
    print("     " + "\n     ".join(r.stdout.strip().split("\n")[-3:]))
    check(r.returncode == 0 and "byte-identical" in r.stdout,
          "migrate_reassembles_byte_identically", r.stderr.strip()[:200])
    tree1 = digest_of_tree(build / "sections") + digest_of_tree(build / "entries")

    regenerated = (problem / "NOTEBOOK.md").read_text(encoding="utf-8")
    check(regenerated == committed, "migration_is_idempotent_on_committed_digest",
          f"{len(committed)} vs {len(regenerated)} chars")

    r2 = subprocess.run([sys.executable, str(build / "migrate_split.py"), "--force"],
                        capture_output=True, text=True)
    tree2 = digest_of_tree(build / "sections") + digest_of_tree(build / "entries")
    check(r2.returncode == 0 and tree1 == tree2, "rerun_produces_identical_sources")

    r3 = subprocess.run(
        [sys.executable, str(problem / "scripts" / "check_manifest_parity.py")],
        capture_output=True, text=True)
    tail = [l for l in r3.stdout.strip().split("\n") if l.startswith(("FAIL", "RESULT"))]
    check(r3.returncode == 0, "parity_checker_passes", "; ".join(tail))

    missing_h = [h for h in headings(baseline) if h not in regenerated]
    check(not missing_h, "every_baseline_heading_present",
          f"{len(headings(baseline))} headings checked"
          + (f"; missing {missing_h[:3]}" if missing_h else ""))

    manifest = json.loads((build / "manifest.json").read_text(encoding="utf-8"))
    # same contract as the parity checker's exits_surfaced_in_notebook check
    exits = sorted({str(rec["primary_exit"]) for rec in manifest["records"]
                    if rec.get("kind") == "goal_run"
                    and rec.get("primary_exit") not in ROLE_VALUES
                    and rec.get("primary_exit")})
    missing_e = [e for e in exits if e not in regenerated]
    check(not missing_e, "every_manifest_exit_marker_present",
          f"{len(exits)} exit strings checked"
          + (f"; missing {missing_e[:3]}" if missing_e else ""))

    # exit markers that the baseline surfaced must still be surfaced
    base_exits = [e for e in exits if e in baseline]
    lost = [e for e in base_exits if e not in regenerated]
    check(not lost, "no_baseline_exit_marker_lost",
          f"{len(base_exits)} baseline exit strings checked")

    print(f"\nT1 RESULT: {'PASS' if not failures else 'FAIL ' + str(failures)}")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
