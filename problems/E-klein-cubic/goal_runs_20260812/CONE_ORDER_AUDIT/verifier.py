#!/usr/bin/env python3
"""Packet-root verifier. Delegates to scripts/verifier.py."""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SCRIPTS = os.path.join(HERE, "scripts")
sys.path.insert(0, SCRIPTS)
os.chdir(SCRIPTS)

import verifier as V  # noqa: E402

if __name__ == "__main__":
    sys.exit(V.main())
