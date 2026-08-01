#!/usr/bin/env python3
"""Export the ten integral Klein invariant generators used by landing replay."""

from __future__ import annotations

import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
sys.path.insert(0, str(REPO / "tmp/kproj_arithmetic"))
sys.path.insert(0, str(REPO / "tmp/generic_twist"))

import core  # noqa: E402


def main() -> None:
    result = {
        "schema": "klein-integral-invariant-generators-v1",
        "variable_order": ["x0", "x1", "x2", "x3", "x4"],
        "primary_degrees": list(core.PRIMARY_DEGREES),
        "secondary_degrees": list(core.SECONDARY_DEGREES),
        "secondary_names": list(core.SECONDARY_NAMES),
        "forms": {},
    }
    for degree, polynomial in sorted(core.forms().items()):
        result["forms"][str(degree)] = [
            {"exponents": list(exponents), "coefficient": int(coefficient)}
            for exponents, coefficient in sorted(polynomial.items())
        ]
    (HERE / "invariant_generators.json").write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n"
    )
    print("EXPORTED 10 INTEGRAL INVARIANT GENERATORS")


if __name__ == "__main__":
    main()
