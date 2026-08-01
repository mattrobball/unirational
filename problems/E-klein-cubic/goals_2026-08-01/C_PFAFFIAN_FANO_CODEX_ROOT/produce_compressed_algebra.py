#!/usr/bin/env python3
"""Run the shared exact producer but seal its payload in this isolated folder."""

from pathlib import Path
import runpy


HERE = Path(__file__).resolve().parent
SHARED = HERE.parent / "C_PFAFFIAN_FANO" / "produce_compressed_algebra.py"


def main():
    namespace = runpy.run_path(str(SHARED))
    namespace["main"].__globals__["OUT"] = HERE / "compressed_algebra.json"
    namespace["main"]()


if __name__ == "__main__":
    main()
