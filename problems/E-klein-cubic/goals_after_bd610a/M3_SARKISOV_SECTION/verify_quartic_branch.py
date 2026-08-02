#!/usr/bin/env python3
"""Independently check the algebraic ledger for the M3 quartic theorem.

Voisin's and Kollar's theorems remain external theorem-level inputs.  This
checker verifies the exact M3 hypotheses, degree arithmetic, C4 intermediate
field logic, S4 subgroup reduction, source hashes, upstream group replay, and
byte-for-byte reproducibility of the serialized ledger.
"""

from __future__ import annotations

import hashlib
import itertools
import json
import math
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
DATA_PATH = HERE / "quartic_branch.json"
PRODUCER = HERE / "produce_quartic_branch.py"
UPSTREAM_VERIFY = (
    PROBLEM / "goals_2026-08-01" / "Q_SCHUR_DESCENT" / "verify_quartic_frontier.py"
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(4))


IDENTITY = tuple(range(4))
S4 = tuple(itertools.permutations(range(4)))


def closure(generators: tuple[tuple[int, ...], ...]) -> frozenset[tuple[int, ...]]:
    subgroup = {IDENTITY}
    queue = [IDENTITY]
    while queue:
        value = queue.pop()
        for generator in generators:
            candidate = compose(value, generator)
            if candidate not in subgroup:
                subgroup.add(candidate)
                queue.append(candidate)
    return frozenset(subgroup)


PARTITIONS = (
    frozenset((frozenset((0, 1)), frozenset((2, 3)))),
    frozenset((frozenset((0, 2)), frozenset((1, 3)))),
    frozenset((frozenset((0, 3)), frozenset((1, 2)))),
)


def transitive(group: frozenset[tuple[int, ...]]) -> bool:
    return {element[0] for element in group} == set(range(4))


def imprimitive(group: frozenset[tuple[int, ...]]) -> bool:
    for partition in PARTITIONS:
        if all(
            frozenset(
                frozenset(element[index] for index in block)
                for block in partition
            )
            == partition
            for element in group
        ):
            return True
    return False


def main() -> None:
    data = json.loads(DATA_PATH.read_text())
    fibration = json.loads((HERE / "fibration_model.json").read_text())
    assert fibration["base_field"] == "K=C(P(V6))^PSL2(F11)"
    assert fibration["generic_fibre"]["smooth"] is True
    degrees = [entry["degree"] for entry in fibration["generic_fibre"]["zero_cycles"]]
    assert degrees == [3, 55]
    assert math.gcd(*degrees) == 1
    assert data["hypothesis_certificate"]["effective_zero_cycle_degrees"] == degrees
    assert data["hypothesis_certificate"]["index"] == 1

    for relative, expected in data["inputs"].items():
        path = HERE / relative if relative == "fibration_model.json" else PROBLEM / relative
        assert sha256(path) == expected, relative

    # The four roots of T^4-q are cycled by theta -> i*theta.  C4 has exactly
    # one nontrivial proper subgroup, giving the unique quadratic subfield.
    sigma = (1, 2, 3, 0)
    c4 = closure((sigma,))
    assert len(c4) == 4
    subgroups_c4 = {
        closure(tuple(generators))
        for length in range(3)
        for generators in itertools.combinations(c4, length)
    }
    assert sorted({len(group) for group in subgroups_c4}) == [1, 2, 4]
    assert sum(len(group) == 2 for group in subgroups_c4) == 1
    assert data["section_branch"]["exact_residue_degree"] == 4

    # Exhaust transitive two-generator subgroups.  The primitive ones are
    # exactly A4 and S4 by order; all C4/V4/D4 actions preserve a 2+2 block.
    subgroups = {closure((left, right)) for left in S4 for right in S4}
    transitive_groups = {group for group in subgroups if transitive(group)}
    primitive_groups = {group for group in transitive_groups if not imprimitive(group)}
    assert sorted({len(group) for group in transitive_groups}) == [4, 8, 12, 24]
    assert sorted({len(group) for group in primitive_groups}) == [12, 24]
    assert data["decomposition_group_reduction"]["remaining"] == ["A4", "S4"]

    upstream = subprocess.run(
        ["/opt/homebrew/bin/python3", "-u", str(UPSTREAM_VERIFY)],
        cwd=PROBLEM,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
        timeout=120,
    )
    assert "Q_SCHUR_QUARTIC_FRONTIER_EXACT" in upstream.stdout

    reproduced = subprocess.run(
        ["/opt/homebrew/bin/python3", "-u", str(PRODUCER)],
        cwd=PROBLEM,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
        timeout=120,
    )
    assert json.loads(reproduced.stdout) == data

    verdict = data["verdict"]
    assert verdict["integral_degree_four_multisection_exists"] is True
    assert verdict["quartic_locus_empty"] is False
    assert verdict["explicit_field_and_point_coordinates_produced"] is False
    assert verdict["selects_section_alternative"] is False
    assert verdict["terminal_exit"] == "M3-INTEGRAL-DEGREE4-MULTISECTION"
    assert verdict["section_question"] == "UNDECIDED"
    assert verdict["headline"] == "OPEN"

    print("PASS exact M3 smoothness and degree-3/55 index-one hypotheses")
    print("PASS C4 extension has unique quadratic intermediate field")
    print("PASS imprimitive quartic groups are C4/V4/D4; primitive groups are A4/S4")
    print("PASS current source hashes and serialized theorem ledger")
    print("BOUNDARY Voisin and Kollar are theorem-level external inputs")
    print("BOUNDARY no quartic coordinates and no rational section are certified")
    print("M3_QUARTIC_BRANCH_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
