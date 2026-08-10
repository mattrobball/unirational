#!/usr/bin/env python3
"""Run every exact verifier in the four-term sparse packet."""

from pathlib import Path
import subprocess
import sys


CHECKS = (
    (
        "verify_escape.py",
        "FOUR-TERM-DELETION-POLARIZATION-ESCAPE-NOT-SOLUTION-OK",
    ),
    (
        "verify_fixed_point_tangent.py",
        "F55-TRACE-FOUR-TERM-FIXED-POINT-TANGENT-REDUCTION-OK",
    ),
    (
        "verify_higher_jet_reduction.py",
        "F55-TRACE-FOUR-TERM-TETRAHEDRAL-NORM-FIBRE-REDUCTION-OK",
    ),
    (
        "verify_tetrahedral_exclusion.py",
        "F55-TRACE-FOUR-TERM-AFFINE-RANK-THREE-EXCLUSION-OK",
    ),
    (
        "verify_planar_circuit_reduction.py",
        "F55-TRACE-FOUR-TERM-PLANAR-CIRCUIT-REDUCTION-OK",
    ),
    (
        "verify_rank2_quadratic_exclusion.py",
        "F55-TRACE-RATIONAL-RANK2-QUADRATIC-LANDING-EXCLUSION-OK",
    ),
)


def main():
    packet = Path(__file__).resolve().parent
    for filename, marker in CHECKS:
        result = subprocess.run(
            [sys.executable, str(packet / filename)],
            cwd=packet,
            check=True,
            capture_output=True,
            text=True,
        )
        assert marker in result.stdout
        print(filename, marker)
    print("F55-TRACE-FOUR-TERM-ALL-EXPONENT-EXCLUSION-REPLAY-OK")


if __name__ == "__main__":
    main()
