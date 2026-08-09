#!/usr/bin/env python3
"""Replay the exact 11^10 top-degree search in the second prime fibre."""

from __future__ import annotations

import subprocess
import tempfile
from pathlib import Path

from generate_mod7_bruteforce import source


def main():
    # 1/24 reduces to 6 modulo 11, so this is again A_k=r_k, f_k=1.
    cpp = source((1, 2, 3, 4, 6), (1, 1, 1, 1, 1), prime=11)
    with tempfile.TemporaryDirectory(prefix="osculating_mod11_") as temporary:
        directory = Path(temporary)
        source_path = directory / "search.cpp"
        executable = directory / "search"
        source_path.write_text(cpp)
        subprocess.run(
            ["c++", "-O3", "-std=c++17", "-pthread", source_path, "-o", executable],
            check=True,
        )
        completed = subprocess.run(
            [executable],
            check=True,
            text=True,
            stdout=subprocess.PIPE,
        )
    assert completed.stdout.strip() == "NO_FP_POINT p=11"
    print("PASS exhaustive 11^10 search: no top-degree F_11 point")
    print("F55-OSCULATING-NORMALIZED-FIBRE-F11-EXHAUSTIVE")


if __name__ == "__main__":
    main()
