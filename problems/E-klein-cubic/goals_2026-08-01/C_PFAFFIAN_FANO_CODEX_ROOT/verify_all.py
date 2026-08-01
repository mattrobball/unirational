#!/usr/bin/env python3
"""Aggregate the exact, honestly scoped Goal C interface replays."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


CHECKS = (
    (HERE / "verify_compressed_algebra.py", "C3-APROJ-LAZY-EXECUTABLE-VERIFIED"),
    (HERE / "verify_involution.py", "C1-LAZY-INVOLUTION-EXACT-VERIFIED"),
    (ROOT / "certificates/exact_covariants_check.py", "PASS det[x,C,D,E,K]"),
    (HERE / "verify_distinguished_five_plane.py", "C2-DISTINGUISHED-FIVE-PLANE-LAZY-VERIFIED"),
    (HERE / "audit_ambient_leading.py", "AMBIENT-LEADING-HILBERT-AUDITED"),
)


def main() -> None:
    assert (HERE / "STATUS.md").read_text().startswith("C-UNDECIDED\n")
    for script, marker in CHECKS:
        completed = subprocess.run(
            [sys.executable, "-u", str(script)],
            cwd=HERE,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=900,
            check=False,
        )
        print(completed.stdout, end="")
        assert completed.returncode == 0, script
        assert marker in completed.stdout, (script, marker)
    status = (HERE / "STATUS.md").read_text()
    forbidden = "C-POINT-HEADLINE-POSITIVE"
    assert forbidden not in status
    print("SCOPE exact C0/C1 and distinguished pre-Morita five-plane; no C2 corner or C3 point")
    print("C-PARTIAL-EXACT-INTERFACE-VERIFIED")


if __name__ == "__main__":
    main()
