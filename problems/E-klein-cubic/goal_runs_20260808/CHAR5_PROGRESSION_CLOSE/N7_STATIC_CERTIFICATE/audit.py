#!/usr/bin/env python3
"""Replay the sealed root-degree-seven certificate from its final directory."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent


def run(name: str):
    subprocess.run([sys.executable, str(HERE / name)], check=True)


def main():
    run("verify_seal.py")
    run("verify.py")
    print("F55-CHAR5-DEGREE45-STATIC-PACKET-AUDIT-PASS")


if __name__ == "__main__":
    main()

