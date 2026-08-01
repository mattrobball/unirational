#!/usr/bin/env python3
"""Exploratory full polynomial-covariant landing search for both A5 classes.

This deliberately reports degree-scoped evidence only.  It reuses the exact
subgroup packet's finite-field representation builders at the split good
prime 331 and computes the complete linear covariant space in each degree.
"""

from __future__ import annotations

import importlib.util
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
PACKET = HERE.parent / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
sys.path.insert(0, str(PACKET))

spec = importlib.util.spec_from_file_location("a4_search", PACKET / "a4_direct_search.py")
assert spec and spec.loader
search = importlib.util.module_from_spec(spec)
spec.loader.exec_module(search)
base = search.base


def class_data():
    for label, (a, b, subgroup) in zip(
        ("A5_class_1", "A5_class_2"), base.two_a5_classes()
    ):
        mapping = base.iso(a, b, subgroup)
        source = [search.SOURCE_A5[mapping[g]] for g in (a, b)]
        target = [search.RHO[g] for g in (a, b)]
        yield label, source, target


def main(argv: list[str]) -> None:
    degrees = tuple(int(value) for value in argv[1:]) or tuple(range(1, 9))
    for label, source, target in class_data():
        for degree in degrees:
            mons, basis = search.covariant_basis(source, target, degree)
            coeffs = search.landing_coefficients(mons, basis)
            if not basis:
                empty, charts = True, []
            else:
                empty, charts = search.projective_empty(coeffs, len(basis))
            print(
                f"{label} degree={degree} covariant_dimension={len(basis)} "
                f"landing_equations={len(coeffs)} geometrically_empty={empty} "
                f"charts={len(charts)}",
                flush=True,
            )


if __name__ == "__main__":
    main(sys.argv)
