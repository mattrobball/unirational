#!/usr/bin/env python3
"""Run all independent G3H phase verifiers. Does not import produce_all."""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def run(script: str) -> None:
    proc = subprocess.run(
        [sys.executable, "-u", str(HERE / script)],
        cwd=str(HERE.parents[1]),
        capture_output=True,
        text=True,
    )
    sys.stdout.write(proc.stdout)
    sys.stderr.write(proc.stderr)
    if proc.returncode != 0:
        raise SystemExit(proc.returncode)


def main() -> None:
    for script in (
        "verify_phase1.py",
        "verify_phase2.py",
        "verify_phase3.py",
        "verify_phase4.py",
        "verify_phase5.py",
        "phase5_springer_next/verify_phase5_next.py",
    ):
        print(f"== {script} ==")
        run(script)

    status = (HERE / "STATUS.md").read_text().splitlines()[0].strip()
    seal = json.loads((HERE / "SEAL.json").read_text())
    allowed = {
        "G3P-POINT-HEADLINE-POSITIVE",
        "G3H-QUADRATIC-SPRINGER-REDUCTION-PASS",
        "G3H-SEMILINEAR-G3-FRAME-PASS",
        "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED",
        "G3H-UNDECIDED",
        "G3H-CANONICAL-INPUT-FAIL",
    }
    if status not in allowed:
        print(f"G3H_VERIFY_FAIL: bad STATUS {status}", file=sys.stderr)
        raise SystemExit(1)
    if seal.get("exit") != status:
        print("G3H_VERIFY_FAIL: SEAL/STATUS mismatch", file=sys.stderr)
        raise SystemExit(1)
    if seal.get("headline") != "OPEN" and status == "G3P-POINT-HEADLINE-POSITIVE":
        pass
    if status != "G3P-POINT-HEADLINE-POSITIVE" and seal.get("headline") != "OPEN":
        print("G3H_VERIFY_FAIL: non-headline exit must keep headline OPEN", file=sys.stderr)
        raise SystemExit(1)

    # Producer must not be imported by this process
    if "produce_all" in sys.modules:
        print("G3H_VERIFY_FAIL: produce_all imported", file=sys.stderr)
        raise SystemExit(1)

    print(f"STATUS {status}")
    print("G3H_VERIFY_ALL_OK")


if __name__ == "__main__":
    main()
