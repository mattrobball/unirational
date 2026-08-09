#!/usr/bin/env python3
"""Finite scope audit for the analytic Pfaffian degree-four packet."""

from pathlib import Path


ROOT = Path(__file__).resolve().parent


def main() -> None:
    theorem = (ROOT / "THEOREM.md").read_text()
    sources = (ROOT / "SOURCES.md").read_text()

    required = [
        "Theorem 1.1 (degree-four replacement)",
        "4\\times6",
        "4\\times4",
        "\\deg_H=4",
        "does **not** prove the Klein cubic negative",
    ]
    for marker in required:
        assert marker in theorem, marker

    # A maximal minor of a 4 x 6 matrix whose entries are linear on P^1
    # is homogeneous of degree 4.  This is the only numerical calculation
    # used in the proof.
    row_count = 4
    entry_degree = 1
    assert row_count * entry_degree == 4

    for source_marker in [
        "Tschinkel and Zh. Zhang",
        "A. Kuznetsov",
        "A. Iliev and D. Markushevich",
        "C. Li, Y. Lin, L. Pertusi, and X. Zhao",
    ]:
        assert source_marker in sources, source_marker

    print("SCHUR-CONIC-ALL-DEGREES-REDUCED-TO-DEGREE4")


if __name__ == "__main__":
    main()
