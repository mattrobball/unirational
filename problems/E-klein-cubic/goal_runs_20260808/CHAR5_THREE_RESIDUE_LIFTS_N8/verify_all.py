#!/usr/bin/env python3
"""Replay every sealed verification layer from the packet directory."""

from pathlib import Path
import os
import subprocess
import sys


HERE = Path(__file__).resolve().parent


def run(script):
    print("RUN", script, flush=True)
    environment = dict(os.environ)
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    subprocess.run(
        [sys.executable, str(HERE / script)],
        check=True,
        cwd=HERE,
        env=environment,
    )


def main():
    run("verify_seal.py")
    run("verify_dpll_n2_n7.py")
    run("verify_n8_solver_replay.py")
    print("F55-CHAR5-FIXED-THREE-RESIDUE-THROUGH-N8-REPLAY-OK")
    print("HEADLINE_OPEN_NO_ALL_DEGREE_CUTOFF")


if __name__ == "__main__":
    main()
