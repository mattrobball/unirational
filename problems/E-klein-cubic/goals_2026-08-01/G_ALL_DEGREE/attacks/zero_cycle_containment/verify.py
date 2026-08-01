#!/usr/bin/env python3
"""Independent replay for the zero-cycle containment route audit."""

from __future__ import annotations

import argparse
from hashlib import sha256
from itertools import permutations, product
import json
from math import factorial, gcd
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
GOALS = HERE.parents[2]
REPORT = HERE / "REPORT.md"
GAP = Path("/opt/homebrew/Caskroom/miniforge/base/bin/gap")
SINGULAR = Path("/opt/homebrew/bin/Singular")
VOISIN_V2_SHA256 = "fc2210924b225cd095f2d428cfd50fb798535a153465832f65c56b1ec32069c5"


def run(command: list[str], marker: str) -> None:
    completed = subprocess.run(
        command,
        cwd=HERE,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    if marker not in completed.stdout:
        raise AssertionError(
            f"missing marker {marker!r} in output:\n{completed.stdout}"
        )


def verify_small_splitting() -> None:
    assert GAP.is_file(), GAP
    run([str(GAP), "-q", "group_check.g"], "PSL211_ORDER_660_SIMPLE_OK")
    order = 660
    for degree in range(2, 5):
        # A nontrivial map from a simple group is injective, but an injection
        # into S_degree is impossible by the order inequality.
        assert factorial(degree) < order
    print("ZERO_CYCLE_SMALL_SPLITTING_LEMMA_OK")


def verify_countermodel() -> None:
    assert SINGULAR.is_file(), SINGULAR
    run(
        [str(SINGULAR), "-q", "counterexample.sing"],
        "SMOOTH_CUBIC_RESIDUAL_QUADRATIC_COUNTERMODEL_OK",
    )
    print("ZERO_CYCLE_RESIDUAL_CONTAINMENT_COUNTERMODEL_OK")


def verify_closed_point_arithmetic() -> None:
    d = 3
    n = 55
    upper = n * d - n - d
    assert upper == 107 == 2 * n - 3

    # Exact modular proof that the two bad-partition alternatives cannot
    # occur for a partition of 107.
    assert upper % 3 != 0
    assert upper < 2 * n
    assert (upper - n) % 3 != 0

    sequence = [n]
    for _ in range(5):
        current = sequence[-1]
        assert current > 3 and current % 3 != 0
        nxt = 2 * current - 3
        assert nxt > current
        assert nxt % 3 != 0
        assert nxt % current != 0
        sequence.append(nxt)
    assert sequence == [55, 107, 211, 419, 835, 1667]
    print("ZERO_CYCLE_CLOSED_POINT_NONTERMINATION_OK")


def verify_genuine_quartic_frontier(voisin_pdf: Path | None) -> None:
    # Bind the orbit theorem to the exact projective generic twist, rather
    # than merely reusing a neighboring Schur packet by name.
    generic_path = GOALS / "G_ALL_DEGREE/generic_cubic.json"
    generic = json.loads(generic_path.read_text())
    assert generic["schema"] == "G_GENERIC_KLEIN_CUBIC_V1"
    assert generic["projective_base"] == ["t3", "t6", "t8", "t11"]
    assert len(generic["projective_basis"]) == 12
    assert generic["scope"].endswith(
        "no rational point or pointlessness verdict."
    )
    run(
        [
            "/opt/homebrew/bin/python3",
            str(GOALS / "G_ALL_DEGREE/verify_generic_cubic.py"),
        ],
        "G_PROJECTIVE_NORMALIZATION_35_COEFFICIENTS_OK",
    )

    valuation_directory = (
        GOALS / "G_ALL_DEGREE/attacks/valuation_obstruction"
    )
    valuation = json.loads(
        (valuation_directory / "certificate.json").read_text()
    )
    assert valuation["schema"] == "G_VALUATION_PARSHIN_SOLUBILITY_V1"
    assert valuation["generic_cubic"]["field"] == "K_proj"
    assert valuation["generic_cubic"]["coefficient_count"] == 35
    assert valuation["effective_cycle"] == {
        "group_order": 660,
        "stabilizer": "D12",
        "stabilizer_order": 12,
        "orbit_degree": 55,
        "prime_to_three": True,
        "signed_index_identity": [1, -18],
        "signed_index_degrees": [55, 3],
    }
    assert valuation["authoritative_hashes"][
        "G_ALL_DEGREE/generic_cubic.json"
    ] == sha256(generic_path.read_bytes()).hexdigest()
    valuation_theorem = (valuation_directory / "THEOREM.md").read_text()
    for phrase in (
        "For every `G`-torsor `T/K`",
        "Effective degree-55 cycle on the genuine twist",
        "The 35 coefficients in `generic_cubic.json` give the genuine twist",
    ):
        assert phrase in valuation_theorem, phrase

    # Rebuild the authoritative D12 line-orbit ledger used to put an actual
    # degree-55 point on a general cubic-surface section of the genuine twist.
    run(
        [
            "/opt/homebrew/bin/python3",
            str(GOALS / "Q_SCHUR_DESCENT/verify_zero_cycle_ledger.py"),
        ],
        "Q_SCHUR_ZERO_CYCLE_LEDGER_EXACT",
    )
    assert 660 // 12 == 55 and gcd(55, 3) == 1
    assert 55 - 18 * 3 == 1
    if voisin_pdf is not None:
        assert voisin_pdf.is_file(), voisin_pdf
        assert sha256(voisin_pdf.read_bytes()).hexdigest() == VOISIN_V2_SHA256

    def partitions(total: int, ceiling: int | None = None):
        if total == 0:
            yield ()
            return
        ceiling = total if ceiling is None else min(total, ceiling)
        for first in range(ceiling, 0, -1):
            for rest in partitions(total - first, first):
                yield (first,) + rest

    # In a no-point branch, degrees one and two are impossible.  The latter
    # descends by the conjugate secant and residual third intersection.
    survivors = [
        partition
        for partition in partitions(4)
        if all(degree not in (1, 2) for degree in partition)
    ]
    assert survivors == [(4,)]

    # Independently enumerate the transitive subgroups of S4.  A quartic
    # with no intermediate quadratic field has no invariant two-block
    # partition, leaving precisely the primitive orders 12 and 24 (A4,S4).
    symmetric_group = tuple(permutations(range(4)))
    identity = tuple(range(4))

    def compose(left, right):
        return tuple(left[right[index]] for index in range(4))

    def generated(generators):
        group = {identity}
        changed = True
        while changed:
            changed = False
            for left, right in product(
                tuple(group), tuple(generators) + tuple(group)
            ):
                value = compose(left, right)
                if value not in group:
                    group.add(value)
                    changed = True
        return frozenset(group)

    groups = {
        generated((first, second))
        for first in symmetric_group
        for second in symmetric_group
    }
    transitive = {
        group
        for group in groups
        if {permutation[0] for permutation in group} == set(range(4))
    }
    block_partitions = (
        frozenset((frozenset((0, 1)), frozenset((2, 3)))),
        frozenset((frozenset((0, 2)), frozenset((1, 3)))),
        frozenset((frozenset((0, 3)), frozenset((1, 2)))),
    )

    def preserves(group, partition):
        return all(
            frozenset(
                frozenset(permutation[value] for value in block)
                for block in partition
            )
            == partition
            for permutation in group
        )

    primitive = [
        group
        for group in transitive
        if not any(preserves(group, partition) for partition in block_partitions)
    ]
    assert sorted(len(group) for group in primitive) == [12, 24]
    print("ZERO_CYCLE_GENUINE_QUARTIC_FRONTIER_OK")


def verify_scope_text() -> None:
    text = REPORT.read_text()
    required = (
        "does **not** decide the Goal G headline",
        "genuine projective generic twist",
        "exactly the genuine twist represented by",
        "primitive quartic point with closure",
        "second alternative remains possible",
        "arXiv v2 (20 February 2026), Theorem 1.5",
        VOISIN_V2_SHA256,
        "HEADLINE_OPEN",
    )
    for phrase in required:
        assert phrase in text, phrase


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--voisin-pdf",
        type=Path,
        help="optional arXiv v2 PDF to check against the pinned SHA-256",
    )
    args = parser.parse_args()
    verify_small_splitting()
    verify_countermodel()
    verify_closed_point_arithmetic()
    verify_genuine_quartic_frontier(args.voisin_pdf)
    verify_scope_text()
    print("ZERO_CYCLE_CONTAINMENT_ROUTE_AUDIT_OK")
    print("HEADLINE_OPEN")


if __name__ == "__main__":
    main()
