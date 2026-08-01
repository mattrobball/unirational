#!/usr/bin/env python3
"""Run the lightweight independent checks for this structural packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            h.update(chunk)
    return h.hexdigest()


def run(script: str, marker: str) -> None:
    completed = subprocess.run(
        [sys.executable, "-u", str(HERE / script)],
        cwd=HERE,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    print(completed.stdout, end="")
    if completed.returncode != 0 or marker not in completed.stdout:
        raise SystemExit(f"FAIL: {script}")


def main() -> None:
    run("verify_structure.py", "PASS: independent Stage-B structural replay")
    run(
        "verify_coordinate_lines.py",
        "PASS: replayed 666 coordinate-line unit-gcd certificates",
    )
    job = json.loads((HERE / "support_cover_r43_boundary_job.json").read_text())
    script = HERE / job["script"]
    source = HERE / job["source"]
    if sha256(script) != job["script_sha256"]:
        raise SystemExit("FAIL: generated Singular script hash")
    if sha256(source) != job["source_sha256"]:
        raise SystemExit("FAIL: selected contraction source hash")
    if not (HERE / "REPORT.md").is_file():
        raise SystemExit("FAIL: REPORT.md missing")
    print("PASS: stageb_structure packet")


if __name__ == "__main__":
    main()
