#!/usr/bin/env python3
"""Replay every independent Goal G verifier and the final content seal."""

from __future__ import annotations

import os
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
        "verify_literature_frontier.py",
        ("G_CURRENT_LITERATURE_FRONTIER_2026_07_18_OPEN_OK",),
    ),
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
    (
        "attacks/low_rank_valuations_v2/verify.py",
        ("G_LOW_RANK_C1_RESIDUE_LOCAL_SOLUBILITY_EXACT",),
    ),
    (
        "attacks/ternary_kproj_v2/verify.py",
        (
            "THEOREM Goal-G x,C,D plane has no K_proj,C-point (literal 10-coefficient bind)",
            "CHAR0_TRANSFER projective special-fibre emptiness at p=101 => geometric QQ/C emptiness",
            "STRICT_SCOPE xCD plane theorem plus 120 finite common-secondary ansatze; full cubic remains open",
            "G_TERNARY_KPROJ_V2_VERIFY_OK",
        ),
    ),
    (
        "attacks/primitive_quartic_v2/verify.py",
        (
            "PRIMITIVE_QUARTIC_FORCED_DISJOINTNESS_OK",
            "PRIMITIVE_QUARTIC_CUBIC_RESOLVENT_OK",
            "PRIMITIVE_QUARTIC_FINITE_GATE_OK",
            "PRIMITIVE_QUARTIC_S4_SMOOTH_COUNTERMODEL_OK",
            "PRIMITIVE_QUARTIC_ROUTE_AUDIT_OK",
            "HEADLINE_OPEN",
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
            env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
        )
        for marker in markers:
            if marker not in completed.stdout:
                raise AssertionError(f"{script} did not emit {marker}")
        print(f"PASS {script}: {', '.join(markers)}")
    print("G_ALL_DEGREE_PACKET_VERIFY_OK")
    print("SCOPE G-STRUCTURAL-UNDECIDED; HEADLINE SUPPORT REMAINS OPEN")


if __name__ == "__main__":
    main()
