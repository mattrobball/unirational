#!/usr/bin/env python3
"""Independent phase-1 verifier: G7B quarantine. Does not import produce_all."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PHASE1 = HERE / "phase1_quarantine"


def fail(msg: str) -> None:
    print(f"G3H_PHASE1_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    qpath = PHASE1 / "quarantine.json"
    if not qpath.is_file():
        fail("missing quarantine.json")
    data = json.loads(qpath.read_text())
    if data.get("marker") != "G3H-G7B-QUARANTINE-PASS":
        fail("marker")
    if data.get("historical_rewrite") is not False:
        fail("must not rewrite historical G7B")
    if data.get("defects_recorded", {}).get("coset_map_well_defined") is not False:
        fail("coset map must be recorded as not well-defined")
    if data.get("defects_recorded", {}).get("Stab_G_e0") != 11:
        fail("Stab")

    # Re-run audit independently
    audit = (
        ROOT
        / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/audit_induced_refutation.py"
    )
    proc = subprocess.run(
        [sys.executable, "-u", str(audit)],
        cwd=str(ROOT),
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        fail(f"audit rc={proc.returncode}")
    out = proc.stdout + proc.stderr
    if "G7B-INDUCED-CYCLE-REFUTED" not in out:
        fail("missing refutation marker")
    if "G7B_AUDIT_OK" not in out:
        fail("missing G7B_AUDIT_OK")

    # Hash continuity of historical artifacts
    hist = data["historical_hashes"]
    for name, rel in (
        ("INDUCED_CYCLE_REFUTATION.md", "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/INDUCED_CYCLE_REFUTATION.md"),
        ("audit_induced_refutation.py", "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/audit_induced_refutation.py"),
        ("cycles.json", "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/cycles.json"),
    ):
        p = ROOT / rel
        if sha256_file(p) != hist[name]:
            fail(f"historical hash drift for {name} — was G7B rewritten?")

    status = (
        ROOT / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/STATUS.md"
    ).read_text().splitlines()[0].strip()
    if status == "G7-INDUCED-DOUBLE-CYCLE-PASS":
        fail("G7B STATUS still claims induced pass")

    print("G3H-G7B-QUARANTINE-PASS")
    print("G3H_PHASE1_OK")


if __name__ == "__main__":
    main()
