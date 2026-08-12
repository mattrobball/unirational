#!/usr/bin/env python3
"""Standalone R2 spot-check: Klein F at coordinate points + gradient.

Runnable as:
  python3 scripts/r2_tangent_check.py
"""
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import verifier as V  # noqa: E402


def main() -> int:
    V.r2_no_x_cubed()
    V.r2_over_Z()
    for p in (331, 661):
        V.r2_mod_p(p)
    fails = [c for c in V.CHECKS if not c["ok"]]
    print(f"R2-only: {len(V.CHECKS) - len(fails)}/{len(V.CHECKS)} pass")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
