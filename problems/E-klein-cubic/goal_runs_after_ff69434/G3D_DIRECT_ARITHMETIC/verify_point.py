#!/usr/bin/env python3
"""Headline point verifier — no POINT.md in this packet."""

from pathlib import Path

HERE = Path(__file__).resolve().parent


def main() -> None:
    if (HERE / "POINT.md").exists() or (HERE / "BRIDGE_DIRECT_ARITHMETIC_POS.md").exists():
        raise SystemExit("POINT artifacts present but verify_point not implemented for a real point")
    print("G3D_NO_POINT_OK")


if __name__ == "__main__":
    main()
