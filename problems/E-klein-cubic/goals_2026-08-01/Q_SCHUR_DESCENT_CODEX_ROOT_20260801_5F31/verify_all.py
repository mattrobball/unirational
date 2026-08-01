#!/usr/bin/env python3
"""Independent fast verifier for the isolated Q packet and its seal."""

from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
REPOSITORY = Path(
    subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        cwd=HERE,
        text=True,
        stdout=subprocess.PIPE,
        check=True,
    ).stdout.strip()
)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


assert (HERE / "STATUS.md").read_text().splitlines()[0] == "Q-UNDECIDED"
manifest = json.loads((HERE / "SOURCE_MANIFEST.json").read_text())
assert manifest["format"] == "Q-SCHUR-SOURCE-MANIFEST-v1"
for relative, expected in manifest["sources"].items():
    assert digest(REPOSITORY / relative) == expected, relative

environment = dict(os.environ)
environment["PYTHONDONTWRITEBYTECODE"] = "1"
checks = (
    (
        "verify_completion_audit.py",
        "Q_SCHUR_REQUIREMENT_AUDIT_BLOCKED_NOT_COMPLETE",
    ),
    ("verify_quartic_frontier.py", "Q_SCHUR_QUARTIC_FRONTIER_EXACT"),
    (
        "verify_quartic_tangent_probe.py",
        "Q_SCHUR_TANGENT_TWISTED_CUBIC_SHORTCUT_REFUTED",
    ),
    (
        "verify_primitive_quartic_tangent.py",
        "Q_SCHUR_PRIMITIVE_INPUT_TANGENT_COPLANARITY_REFUTED",
    ),
    ("verify_full_frame_r8.py", "BOUNDARY no all-height or full-twist point verdict"),
    ("verify_full_frame_r10.py", "BOUNDARY no all-height or full-twist point verdict"),
    ("verify_full_frame_r12d5.py", "remaining nine scalar directions"),
)
for script, marker in checks:
    completed = subprocess.run(
        [sys.executable, "-u", script],
        cwd=HERE,
        env=environment,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
    )
    assert marker in completed.stdout, (script, completed.stdout)
    print(completed.stdout, end="")

seal = json.loads((HERE / "SEAL.json").read_text())
assert seal["format"] == "Q-SCHUR-ISOLATED-SEAL-v1"
for name, expected in seal["files"].items():
    assert digest(HERE / name) == expected, name
current = {
    path.name
    for path in HERE.iterdir()
    if path.is_file() and path.name != "SEAL.json"
}
assert current == set(seal["files"]), (sorted(current - set(seal["files"])), sorted(set(seal["files"]) - current))
print("PASS source manifest and complete isolated-folder seal")
print("Q_SCHUR_ISOLATED_PACKET_VERIFY_OK")
