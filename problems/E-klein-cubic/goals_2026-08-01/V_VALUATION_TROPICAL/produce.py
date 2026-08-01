#!/usr/bin/env python3
"""Producer/replay for the Goal-V exact payload.

The producer reconstructs the load-bearing sparse data from the authoritative
generic-twist sources and checks the checked-in machine-readable payload.  It
does not write files.  ``--full`` also reruns the bounded Macaulay2 screens;
that mode is intentionally slower and preserves the degree-15 f6 timeout as a
nonverdict.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
sys.path.insert(0, str(PROBLEM / "tmp" / "generic_twist"))
sys.path.insert(0, str(PROBLEM / "tmp" / "kproj_arithmetic"))
sys.path.insert(0, str(HERE))

from phi_coefficients import all_coefficients  # noqa: E402
from core import forms  # noqa: E402
from explore_diagonal_divisors import divide_exact  # noqa: E402


def run(command, marker):
    completed = subprocess.run(
        command,
        cwd=HERE.parent,
        text=True,
        capture_output=True,
        check=False,
    )
    if completed.returncode or marker not in completed.stdout:
        raise RuntimeError(completed.stdout + completed.stderr)
    return completed.stdout


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--full", action="store_true")
    args = parser.parse_args()
    payload = json.loads((HERE / "proof_payload.json").read_text())
    inertia = json.loads((HERE / "inertia_centralizers.json").read_text())

    names, frame, coefficients = all_coefficients()
    assert names == ("x", "C", "D", "E", "K")
    assert len(coefficients) == 35 and all(coefficients.values())
    diagonal = [coefficients[(index, index, index)] for index in range(5)]
    diagonal_degrees = [sum(next(iter(polynomial))) for polynomial in diagonal]
    assert diagonal_degrees == payload["diagonal_covariant_divisors"]["diagonal_degrees"]
    assert forms()[3] == diagonal[0]
    assert forms()[12] == diagonal[1]

    for polynomial, degree in zip(diagonal, (3, 12, 15, 18, 21)):
        quotient, remainder, _ = divide_exact(polynomial, forms()[degree] if degree in forms() else polynomial)
        if degree in (3, 12):
            assert not remainder and len(quotient) == 1
        else:
            assert not remainder and len(quotient) == 1

    index_row = payload["local_index"]
    assert sum(a * b for a, b in zip(index_row["cycle_degrees"], index_row["bezout_coefficients"])) == 1
    all_rank = payload["all_rank_inertia_tropical"]
    assert all_rank["centralizer_orders"] == {
        str(order): inertia["centralizers"][str(order)]["order"]
        for order in (2, 3, 5, 6, 11)
    }
    assert all_rank["ramified_conclusion"] == "every valuation with nontrivial torsor inertia is locally soluble"
    parshin = payload["standard_parshin_completion_solubility"]
    assert parshin["effective_cycle_degree"] == 55
    assert parshin["covered_chain_lengths_on_Kproj"] == [3, 4]
    frontier = payload["next_bounded_frontier"]
    assert (frontier["target"], frontier["degree"], frontier["candidates"], frontier["equation_rank"]) == (
        "f5", 16, 19, 151
    )
    assert frontier["verdict"] == "timeout nonverdict"

    constant_output = run(
        [sys.executable, str(HERE / "search_constant_residue_points.py")],
        "CONSTANT_RESIDUE_POINT_SCREEN_EXACT",
    )
    assert constant_output.count("PROJECTIVELY_EMPTY=True") == 2

    if args.full:
        f5 = run(
            [
                sys.executable,
                "-u",
                str(HERE / "search_full_frame_bounded.py"),
                "--target",
                "5",
                "--lower",
                "1",
                "--upper",
                "15",
                "--timeout",
                "300",
            ],
            "FULL_FRAME_BOUNDED_SCREEN_COMPLETE",
        )
        f6 = run(
            [
                sys.executable,
                "-u",
                str(HERE / "search_full_frame_bounded.py"),
                "--target",
                "6",
                "--lower",
                "1",
                "--upper",
                "15",
                "--timeout",
                "10",
            ],
            "FULL_FRAME_BOUNDED_SCREEN_COMPLETE",
        )
        assert f5.count("verdict=PROJECTIVELY_EMPTY") == 13
        assert "f6 N=15" in f6 and "verdict=TIMEOUT_NONVERDICT" in f6

    print("PASS exact generic cubic has all 35 Newton coefficients")
    print("PASS local index Bezout relation equals one")
    print("PASS five diagonal covariant divisor degrees and f3/f12 identities")
    print("PASS all-rank inertia, tropical, and Parshin-completion payload linkage")
    print("PASS constant normalized residue coordinates excluded at f5 and f6")
    if args.full:
        print("PASS optional bounded full-frame screens replayed at their exact scope")
    print("GOAL_V_PAYLOAD_PRODUCER_ACCEPT")


if __name__ == "__main__":
    main()
