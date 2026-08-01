#!/usr/bin/env python3
"""Aggregate independent replay for the sealed scoped COV exit."""

from __future__ import annotations

from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent


def run(*arguments: str) -> None:
    command = [sys.executable, "-u", *arguments]
    print("RUN", " ".join(command), flush=True)
    subprocess.run(command, cwd=HERE, check=True)


def main() -> None:
    run("verify_ranking.py")
    run("verify_sparse_frame.py")
    for degree in (25, 31, 35):
        run("verify_global_jets_holdout.py", str(degree))
    run("verify_manifests.py")
    run("verify_seal.py")
    print("COV_STRUCTURED_SEARCH_ALL_VERIFIED")


if __name__ == "__main__":
    main()
