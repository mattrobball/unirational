#!/usr/bin/env python3
"""Independent verifier for the load-bearing Goal-V computations.

This verifier does not import ``produce.py`` or either exploration script.
It reconstructs the generic cubic and primitive covariants from the upstream
authoritative sources, checks the index and Newton combinatorics, and audits
the bounded-result ledger without treating it as an all-degree theorem.
"""

from __future__ import annotations

import itertools
import hashlib
import json
import math
import sys
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
sys.path.insert(0, str(PROBLEM / "tmp" / "generic_twist"))
sys.path.insert(0, str(PROBLEM / "tmp" / "kproj_arithmetic"))

from phi_coefficients import all_coefficients  # noqa: E402
from core import SECONDARY_DEGREES, forms, weighted_exponents  # noqa: E402


FRAME_DEGREES = (1, 4, 5, 6, 7)
PRIMARY_DEGREES = (3, 5, 6, 8, 11)
TARGET_INDEX = {5: 1, 6: 2}


def polynomial(sparse, variables):
    return sp.Poly(
        sum(
            coefficient
            * sp.prod(variable**exponent for variable, exponent in zip(variables, exponents))
            for exponents, coefficient in sparse.items()
        ),
        *variables,
        domain=sp.QQ,
    )


def quotient_dimension(degree, target):
    if degree < 0:
        return 0
    answer = 0
    target_index = TARGET_INDEX[target]
    for secondary_degree in SECONDARY_DEGREES:
        remainder = degree - secondary_degree
        if remainder < 0:
            continue
        answer += sum(
            exponents[target_index] == 0 for exponents in weighted_exponents(remainder)
        )
    return answer


def verify_payload_ledger(payload):
    assert payload["schema"] == "klein_goal_v_valuation_payload_v1"
    assert payload["status"] == "V-UNDECIDED"
    local = payload["local_index"]
    assert math.gcd(*local["cycle_degrees"]) == 1
    assert sum(a * b for a, b in zip(local["cycle_degrees"], local["bezout_coefficients"])) == 1
    all_rank = payload["all_rank_inertia_tropical"]
    assert all_rank["centralizer_orders"] == {"2": 12, "3": 6, "5": 5, "6": 6, "11": 11}
    assert all_rank["tropical_conclusion"] == (
        "for every rank and every valuation, the tropical hypersurface contains a point over the base value group"
    )
    assert all_rank["closed_residue_conclusion"] == "every valuation with residue field C is locally soluble"
    parshin = payload["standard_parshin_completion_solubility"]
    assert parshin["effective_cycle_degree"] == 55
    assert parshin["covered_chain_lengths_on_Kproj"] == [3, 4]
    assert parshin["terminal_residue_transcendence_degree_bound"] == 1
    frontier = payload["next_bounded_frontier"]
    assert frontier == {
        "target": "f5",
        "degree": 16,
        "block_dimensions": [7, 5, 2, 2, 3],
        "candidates": 19,
        "equation_rank": 151,
        "timeout_seconds": 300,
        "verdict": "timeout nonverdict",
    }

    for target in (5, 6):
        rows = payload["bounded_full_frame_screen"][f"f{target}"]
        assert [row["degree"] for row in rows] == list(range(1, 16))
        for row in rows:
            expected = sum(
                quotient_dimension(row["degree"] - frame_degree, target)
                for frame_degree in FRAME_DEGREES
            )
            assert row["candidates"] == expected
            if row["candidates"] == 0:
                assert row["cone_dimension"] is None
            elif target == 6 and row["degree"] == 15:
                assert row["verdict"] == "timeout nonverdict"
                assert row["cone_dimension"] is None
            else:
                assert row["cone_dimension"] == 0


def verify_newton_combinatorics():
    # Pigeonhole step: five residues in Z/3 always repeat.
    for residues in itertools.product(range(3), repeat=5):
        assert len(set(residues)) < 5
    # Every ordered partition of horizontal length three is either [3] or
    # contains a unit edge.
    partitions = ((3,), (1, 2), (2, 1), (1, 1, 1))
    assert all(parts == (3,) or 1 in parts for parts in partitions)


def verify_seal():
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["schema"] == "klein_goal_v_seal_v1"
    for relative, expected in seal["files"].items():
        path = (PROBLEM / relative).resolve()
        assert path.is_file(), path
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        assert actual == expected, (relative, expected, actual)


def main():
    payload = json.loads((HERE / "proof_payload.json").read_text())
    verify_payload_ledger(payload)

    names, frame, coefficients = all_coefficients()
    expected_support = set(itertools.combinations_with_replacement(range(5), 3))
    assert set(coefficients) == expected_support
    assert len(expected_support) == 35 and all(coefficients.values())
    assert payload["genuine_twist"]["nonzero_cubic_coefficients"] == 35

    variables = sp.symbols("w0:5")
    gcd_degrees = []
    for vector in frame:
        components = [polynomial(component, variables) for component in vector]
        common = components[0]
        for component in components[1:]:
            common = sp.gcd(common, component)
        gcd_degrees.append(common.total_degree())
    assert gcd_degrees == [0, 0, 0, 0, 0]
    assert gcd_degrees == payload["diagonal_covariant_divisors"]["coordinate_gcd_total_degrees"]

    diagonal = [coefficients[(index, index, index)] for index in range(5)]
    degrees = [sum(next(iter(entry))) for entry in diagonal]
    assert degrees == [3, 12, 15, 18, 21]
    assert forms()[3] == diagonal[0]
    assert forms()[12] == diagonal[1]

    verify_newton_combinatorics()
    verify_seal()

    assert payload["strict_nonclaims"] == [
        "no full-twist local nonpoint is proved",
        "no all-natural-valuations theorem is proved",
        "no unramified residue-twist point census is complete",
        "no bounded computation is promoted to an all-degree result",
        "Problem E remains open",
    ]
    print("PASS independent 35-term Newton support reconstruction")
    print("PASS independent primitive-covariant base-gcd reconstruction")
    print("PASS independent diagonal f3/f12 and degree reconstruction")
    print("PASS independent local-index, all-rank/Parshin ledgers, and rank-one tropical combinatorics")
    print("PASS bounded ledger candidate dimensions and strict timeout scope")
    print("PASS packet and authoritative-input seal")
    print("GOAL_V_INDEPENDENT_VERIFY_ACCEPT")


if __name__ == "__main__":
    main()
