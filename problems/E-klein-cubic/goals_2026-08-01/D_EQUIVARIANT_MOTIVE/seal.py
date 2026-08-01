#!/usr/bin/env python3
"""Compatibility entry point for regenerating the deterministic seal.

The canonical producer also regenerates the mathematical payload before it
hashes the package, preventing a seal over stale calculations.
"""

from __future__ import annotations

from produce import main as produce_main


def main() -> None:
    produce_main()
    print("D_EQUIVARIANT_MOTIVE_SEAL_OK")


if __name__ == "__main__":
    main()
