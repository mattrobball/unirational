#!/usr/bin/env python3
"""Compatibility entry point for the non-writing replay.py runner."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
def main():
    subprocess.run([sys.executable, "replay.py"], cwd=HERE, check=True)
    print("S19_MARKED_CURVE_CONTINUATION_REPLAY_OK")


if __name__ == "__main__":
    main()
