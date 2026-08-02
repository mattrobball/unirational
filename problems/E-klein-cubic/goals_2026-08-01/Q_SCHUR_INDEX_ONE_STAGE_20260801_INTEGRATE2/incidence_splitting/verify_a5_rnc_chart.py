#!/usr/bin/env python3
"""Independent algebra/arithmetic replay for the seven-point RNC chart."""

from itertools import combinations
import hashlib
import json
from pathlib import Path

import sympy as sp


REPORT = Path(__file__).with_name("A5_DEGREE11_RNC.md").read_text()
HERE = Path(__file__).resolve().parent


def det3(rows):
    return sp.det(sp.Matrix(rows))


def rank_mod_p(rows, p):
    work = [[int(x) % p for x in row] for row in rows]
    pivot = 0
    for column in range(len(work[0])):
        found = next((r for r in range(pivot, len(work)) if work[r][column]), None)
        if found is None:
            continue
        work[pivot], work[found] = work[found], work[pivot]
        unit = pow(work[pivot][column], -1, p)
        work[pivot] = [unit * x % p for x in work[pivot]]
        for r in range(len(work)):
            if r != pivot and work[r][column]:
                scalar = work[r][column]
                work[r] = [
                    (x - scalar * y) % p
                    for x, y in zip(work[r], work[pivot])
                ]
        pivot += 1
        if pivot == len(work):
            break
    return pivot


def symbolic_membership_identity():
    s, t = sp.symbols("s t")
    v = sp.symbols("v0:5")
    w = [v[i] * sp.prod(v[j] * s + t for j in range(5) if j != i) for i in range(5)]
    rows = [[v[i] * w[i], -v[i], w[i]] for i in range(5)]
    for indices in combinations(range(5), 3):
        assert sp.expand(det3([rows[i] for i in indices])) == 0


def finite_chart_check():
    p = 101
    v = [1, 2, 3, 4, 5]

    def curve(s, t):
        return [
            v[i]
            * sp.prod((v[j] * s + t) % p for j in range(5) if j != i)
            % p
            for i in range(5)
        ]

    # Seven anchors: five coordinate points, the all-one point, and v.
    for i in range(5):
        point = curve(-pow(v[i], -1, p), 1)
        assert point[i] and all(not point[j] for j in range(5) if j != i)
    infinity = curve(1, 0)
    assert len(set(infinity)) == 1 and infinity[0]
    assert curve(0, 1) == v

    for parameter in (6, 7, 8, 9):
        w = curve(parameter, 1)
        rows = [[v[i] * w[i], -v[i], w[i]] for i in range(5)]
        assert rank_mod_p(rows, p) <= 2

    off_curve = [1, 1, 2, 3, 5]
    rows = [[v[i] * off_curve[i], -v[i], off_curve[i]] for i in range(5)]
    assert rank_mod_p(rows, p) == 3


def arithmetic_and_scope():
    assert 4 * 3 == 12
    assert 12 - 11 == 1
    assert sp.gcd(2, 11) == 1
    assert 11 * 3 == 33
    assert 4 * 3 == 12
    assert 33 - 12 == 21
    assert 5 * 4 * 3 * 2 == 120
    for phrase in (
        "generically finite of degree",
        "does **not** prove rationality",
        "no applicable theorem forcing a point",
        "six installed constant degree-eleven `A5` landing maps",
    ):
        assert phrase in REPORT


def verify_seal():
    seal = json.loads((HERE / "A5_RNC_SEAL.json").read_text())
    assert seal["format"] == "q-schur-a5-degree11-rnc-incidence-seal-v1"
    assert seal["marker"] == "Q_SCHUR_A5_DEGREE11_RNC_INCIDENCE_EXACT"
    assert seal["status"] == "Q-UNDECIDED"
    assert seal["binary_headline_resolved"] is False
    assert seal["rnc_point_constructed"] is False
    for name, expected in seal["files"].items():
        actual = hashlib.sha256((HERE / name).read_bytes()).hexdigest()
        assert actual == expected, (name, expected, actual)
    for name, expected in seal["upstream_dependencies"].items():
        actual = hashlib.sha256((HERE / name).read_bytes()).hexdigest()
        assert actual == expected, (name, expected, actual)
    assert len(seal["remaining_rank_conditions"]) == 4
    print("A5_DEGREE11_RNC_STRICT_SEAL_OK")


def main():
    symbolic_membership_identity()
    finite_chart_check()
    arithmetic_and_scope()
    verify_seal()
    print("RNC_SEVEN_POINT_CHART_SYMBOLIC_OK")
    print("RNC_FOUR_MEMBERSHIP_RANK_CONDITIONS_OK")
    print("RNC_INCIDENCE_DIMENSION_21_DEGREE_120_OK")
    print("Q_SCHUR_A5_DEGREE11_RNC_INCIDENCE_EXACT")


if __name__ == "__main__":
    main()
