#!/usr/bin/env python3
"""Independent exact support check for the rank-one tropical theorem."""

from __future__ import annotations

import itertools
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
sys.path.insert(0, str(PROBLEM / "tmp/generic_twist"))
from phi_coefficients import all_coefficients  # noqa: E402


def compositions(total: int):
    if total == 0:
        yield ()
        return
    for first in range(1, total + 1):
        for rest in compositions(total - first):
            yield (first,) + rest


def main() -> None:
    names, frame, coefficients = all_coefficients()
    assert tuple(names) == ("x", "C", "D", "E", "K")
    assert len(frame) == 5
    assert len(coefficients) == 35
    for index in range(5):
        pure_cube = coefficients[(index, index, index)]
        assert pure_cube

    # These are all possible residue classes modulo 3 of the five pure-cube
    # coefficient valuations.  Pigeonhole gives a pair with equal residue.
    for residues in itertools.product(range(3), repeat=5):
        assert any(
            residues[left] == residues[right]
            for left in range(5)
            for right in range(left + 1, 5)
        )

    # Lower-edge horizontal lengths are a composition of 3.  Multiple edges
    # force a unit edge; a single edge has length 3, and congruent endpoint
    # heights make its slope integral.
    possibilities = set(compositions(3))
    assert possibilities == {(3,), (1, 2), (2, 1), (1, 1, 1)}
    for lengths in possibilities:
        assert (len(lengths) == 1 and lengths[0] == 3) or 1 in lengths

    print("PASS exact 35-term support and five nonzero pure cubes")
    print("PASS all 3^5 pure-cube valuation residues and lower-edge partitions")
    print("V_RANK_ONE_TROPICAL_SUPPORT_ACCEPT")


if __name__ == "__main__":
    main()
