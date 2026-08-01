#!/usr/bin/env python3
"""Replay every producer check and independent verifier in this packet."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
COMMANDS = (
    ([sys.executable, "probe_hankel_incidence.py", "--check"], "S19_HANKEL_PROBE_REPRODUCES"),
    ([sys.executable, "verify_hankel_incidence.py"], "S19_HANKEL_COMPRESSION_INDEPENDENT_REPLAY_OK"),
    ([sys.executable, "produce_trisecant_degeneration.py", "--check"], "S19_EXACT_TRISECANT_DEGENERATION_REPRODUCES"),
    ([sys.executable, "verify_trisecant_degeneration.py"], "S19_EXACT_TRISECANT_DEGENERATION_INDEPENDENT_REPLAY_OK"),
    ([sys.executable, "analyze_cover_family_mod67.py", "--check"], "S19_TWO_TRANSVERSAL_MOD67_REPRODUCES"),
    ([sys.executable, "verify_seal.py"], "S19_CONTINUATION_2_SEAL_VERIFIED"),
)


def main():
    for command, marker in COMMANDS:
        result = subprocess.run(command, cwd=HERE, check=True, text=True, capture_output=True)
        print(result.stdout, end="")
        if marker not in result.stdout:
            raise SystemExit(f"missing replay marker: {marker}")
    print("S19_CONTINUATION_2_FULL_REPLAY_OK")


if __name__ == "__main__":
    main()
