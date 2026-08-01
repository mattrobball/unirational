#!/usr/bin/env python3
"""Run every S19 producer check and independent verifier."""

from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
COMMANDS = [
    ([sys.executable, "produce_universal_marked_family.py", "--check"], "S19_UNIVERSAL_MARKED_FAMILY_PRODUCER_CHECK_OK"),
    ([sys.executable, "verify_universal_marked_family.py"], "S19_UNIVERSAL_MARKED_FAMILY_INDEPENDENT_REPLAY_OK"),
    ([sys.executable, "produce_marked_incidence_presentation.py", "--check"], "S19_MARKED_INCIDENCE_PRODUCER_CHECK_OK"),
    ([sys.executable, "verify_marked_incidence_presentation.py"], "S19_MARKED_INCIDENCE_PRESENTATION_INDEPENDENT_REPLAY_OK"),
    ([sys.executable, "produce_marked_component_presentation.py", "--check"], "S19_MARKED_COMPONENTS_FINITE_PRESENTATION_EXACT"),
    ([sys.executable, "verify_marked_component_presentation.py"], "S19_MARKED_COMPONENT_PRESENTATION_INDEPENDENT_REPLAY_OK"),
    ([sys.executable, "verify_null_curve_residual.py"], "S19_NULL_CURVE_RESIDUAL_LEDGER_CONSISTENT"),
    ([sys.executable, "verify_seal.py"], "S19_SEAL_VERIFIED"),
]


def main():
    environment = dict(os.environ)
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    for command, marker in COMMANDS:
        completed = subprocess.run(command, cwd=HERE, env=environment, text=True, capture_output=True)
        if completed.stdout:
            print(completed.stdout, end="")
        if completed.stderr:
            print(completed.stderr, end="", file=sys.stderr)
        assert completed.returncode == 0, command
        assert marker in completed.stdout, (command, marker)
    print("S19_FULL_PACKET_REPLAY_OK")


if __name__ == "__main__":
    main()
