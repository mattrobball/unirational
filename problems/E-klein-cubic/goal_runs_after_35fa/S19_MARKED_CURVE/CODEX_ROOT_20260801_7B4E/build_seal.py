#!/usr/bin/env python3
"""Compatibility entry point for the canonical make_seal.py builder."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.write:
        subprocess.run([sys.executable, "make_seal.py"], cwd=HERE, check=True)
    else:
        print("Use make_seal.py, or pass --write to this compatibility entry point.")


if __name__ == "__main__":
    main()
