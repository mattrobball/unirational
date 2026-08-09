#!/usr/bin/env python3
"""Replay the exact 7^10 saturated search for the normalized mod-7 fibre."""

from __future__ import annotations

import subprocess
import tempfile
from pathlib import Path

from generate_mod7_bruteforce import source
from verify_mod7_point import POINTS


def main():
    # Modulo seven, (1,2,3,4,5) is the root tuple and hence A_k=r_k.
    cpp = source((1, 2, 3, 4, 5), (1, 1, 1, 1, 1))
    with tempfile.TemporaryDirectory(prefix="osculating_mod7_") as temporary:
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

    found = set()
    count = None
    for line in completed.stdout.splitlines():
        fields = line.split()
        if fields and fields[0] == "FOUND":
            found.add(tuple(map(int, fields[1:])))
        elif fields and fields[0] == "POINTS":
            count = int(fields[1])
    assert found == set(POINTS)
    assert count == len(POINTS) == 3
    print("PASS exhaustive 7^10 search: exactly three top-degree points")
    print("F55-OSCULATING-NORMALIZED-FIBRE-F7-EXHAUSTIVE")


if __name__ == "__main__":
    main()
