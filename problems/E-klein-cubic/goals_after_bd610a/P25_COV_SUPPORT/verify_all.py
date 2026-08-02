#!/usr/bin/env python3
"""Run every independent verifier used by the current honest-stop packet."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent

CHECKS = [
    ("verify_reported_inputs.py", "PASS_REPORTED_INPUT_REPLAY"),
    ("verify_pc0_multiplication.py", "PASS_INDEPENDENT_PC0_REPLAY"),
    ("verify_pc1_degree4_closure.py", "PASS_INDEPENDENT_PC1_DEGREE4_REPLAY"),
    (
        "verify_pc1_coupled_degree4.py",
        "PASS_INDEPENDENT_PC1_COUPLED_DEGREE4_REPLAY",
    ),
    (
        "verify_representation_characters.py",
        "PASS_PC1_REPRESENTATION_CHARACTERS_SCOPED",
    ),
    (
        "verify_pc1_border_stability.py",
        "PASS_INDEPENDENT_PC1_BORDER_STABILITY_REPLAY",
    ),
    (
        "verify_pc2_coordinate_planes.py",
        "PASS_INDEPENDENT_PC2_COORDINATE_PLANES_SUPPORT_LE3",
    ),
    (
        "verify_pc2_structural_next_gate.py",
        "PASS_PC2_SCHUR_GATE_SCOPED",
    ),
    (
        "verify_pc3_inherited_bezout.py",
        "PASS_INDEPENDENT_PC3_INHERITED_BEZOUT_REPLAY",
    ),
    (
        "verify_pc3_p25_multiplier_maps.py",
        "PC3_P25_MULTIPLIER_MAPS_VERIFIED",
    ),
    (
        "verify_pc3_p25_multiplier_p89.py",
        "PASS_PC3_P25_MULTIPLIER_P89_AMBIENT_REPAIR",
    ),
    (
        "verify_pc3_d31_e6_factor_incidence.py",
        "PC3_D31_E6_FACTOR_INCIDENCE_VERIFIED",
    ),
    (
        "verify_pc3_d31_common_factor_union.py",
        "PC3_D31_COMMON_FACTOR_UNION_VERIFIED",
    ),
    (
        "verify_pc3_d35_common_factor_union.py",
        "PC3_D35_COMMON_FACTOR_UNION_VERIFIED",
    ),
]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--quick",
        action="store_true",
        help="verify hashes and stored result statuses only; not an acceptance replay",
    )
    parser.add_argument(
        "--log",
        type=Path,
        help="write the combined transcript after all checks finish",
    )
    args = parser.parse_args()

    transcript = []
    checks = CHECKS[:1] if args.quick else CHECKS
    if args.quick:
        transcript.append(
            "QUICK MODE IS NOT AN ACCEPTANCE REPLAY; load-bearing ranks were skipped."
        )
    for script, marker in checks:
        header = f"=== {script} ==="
        print(header, flush=True)
        transcript.append(header)
        run = subprocess.run(
            [sys.executable, "-B", "-u", str(HERE / script)],
            cwd=HERE.parent,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        print(run.stdout, end="", flush=True)
        transcript.append(run.stdout.rstrip())
        if run.returncode != 0 or marker not in run.stdout:
            transcript.append(
                f"FAIL {script}: returncode={run.returncode}, missing={marker!r}"
            )
            if args.log:
                args.log.write_text("\n".join(transcript) + "\n")
            return 1
    terminal = "PASS_P25_COV_SUPPORT_PARTIAL_PACKET_FULL_REPLAY"
    if args.quick:
        terminal = "PASS_P25_COV_SUPPORT_QUICK_HASH_REPLAY_ONLY"
    print(terminal, flush=True)
    transcript.append(terminal)
    if args.log:
        args.log.write_text("\n".join(transcript) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
