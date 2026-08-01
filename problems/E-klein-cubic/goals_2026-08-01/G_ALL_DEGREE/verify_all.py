#!/usr/bin/env python3
"""Replay every independent Goal G verifier and the final content seal."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PYTHON = "/opt/homebrew/bin/python3" if Path("/opt/homebrew/bin/python3").exists() else sys.executable
CHECKS = (
    ("verify_generic_cubic.py", ("G_GENERIC_CUBIC_SUPPORT_UNDECIDED",)),
    (
        "verify_universal_object.py",
        (
            "G_DENOMINATOR_CLEARING_EQUIVALENCE_OK",
            "G_GENERIC_SUPPORT_STILL_UNDECIDED",
        ),
    ),
    ("verify_line_constant.py", ("G_ALL_DEGREE_LINE_CONSTANT_VERIFY_OK",)),
    ("verify_structural.py", ("G_ALL_DEGREE_STRUCTURAL_VERIFY_OK",)),
    (
        "attacks/constructive_point/verify.py",
        ("G_CONSTRUCTIVE_POINT_ATTACK_VERIFY_OK",),
    ),
    (
        "attacks/local_infinite_descent/verify.py",
        ("LOCAL_INFINITE_DESCENT_RECURRENCE_OK",),
    ),
    (
        "attacks/valuation_obstruction/verify.py",
        ("G_VALUATION_PARSHIN_COMPLETIONS_SOLUBLE_EXACT",),
    ),
    (
        "attacks/zero_cycle_containment/verify.py",
        (
            "ZERO_CYCLE_GENUINE_QUARTIC_FRONTIER_OK",
            "ZERO_CYCLE_CONTAINMENT_ROUTE_AUDIT_OK",
        ),
    ),
    ("verify_seal.py", ("G_ALL_DEGREE_SEAL_OK",)),
)


def main() -> None:
    for script, markers in CHECKS:
        completed = subprocess.run(
            [PYTHON, str(HERE / script)],
            cwd=PROBLEM,
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        for marker in markers:
            if marker not in completed.stdout:
                raise AssertionError(f"{script} did not emit {marker}")
        print(f"PASS {script}: {', '.join(markers)}")
    print("G_ALL_DEGREE_PACKET_VERIFY_OK")
    print("SCOPE G-STRUCTURAL-UNDECIDED; HEADLINE SUPPORT REMAINS OPEN")


if __name__ == "__main__":
    main()
