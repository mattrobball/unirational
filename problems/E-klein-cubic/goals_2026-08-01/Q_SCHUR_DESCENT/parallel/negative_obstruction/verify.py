#!/usr/bin/env python3
"""Independent scope verifier for the negative-obstruction interface."""

from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            h.update(block)
    return h.hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


payload = json.loads((HERE / "audit_payload.json").read_text())
require(payload["schema"] == "q-schur-negative-obstruction-interface-v1", "schema")
require(payload["status"].endswith("NONTERMINAL"), "status must be nonterminal")
require(payload["headline"] == "OPEN", "headline must remain open")

for relative, expected in payload["authoritative_inputs"].items():
    actual = sha256(ROOT / relative)
    require(actual == expected, f"input hash drift: {relative}: {actual}")

degrees = payload["known_effective_cycle_degrees"]
coefficients = payload["bezout"]["coefficients"]
require(degrees == [3, 55], "cycle degrees")
require(math.gcd(*degrees) == 1, "cycle gcd")
require(sum(a * b for a, b in zip(coefficients, degrees)) == 1, "Bezout identity")
require(
    payload["global_no_go"]["semiabelian_torsor_recipient"]
    == "retired as a special case",
    "semiabelian-torsor boundary",
)

v_payload = json.loads((ROOT / "V_VALUATION_TROPICAL/proof_payload.json").read_text())
inertia = v_payload["all_rank_inertia_tropical"]
require(
    inertia["ramified_conclusion"]
    == "every valuation with nontrivial torsor inertia is locally soluble",
    "ramified-inertia theorem",
)
require(
    inertia["unramified_conclusion"]
    == "the local point problem is exactly the residue twist point problem",
    "unramified residue equivalence",
)

field_dimension = payload["schur_field"]["transcendence_degree"]
minimum_residue = payload["local_narrowing"][
    "necessary_minimum_residue_transcendence_degree"
]
expected_max_rank = field_dimension - minimum_residue
require(field_dimension == 5, "Schur field dimension")
require(expected_max_rank == 3, "Abhyankar rank boundary")
require(
    payload["local_narrowing"]["necessary_maximum_rational_rank"]
    == expected_max_rank,
    "stored rank boundary",
)

table = payload["local_narrowing"]["abhyankar_table"]
require([row["rational_rank"] for row in table] == [1, 2, 3, 4, 5], "rank table")
for row in table:
    require(
        row["maximum_residue_transcendence_degree"]
        == field_dimension - row["rational_rank"],
        "Abhyankar table arithmetic",
    )
for row in table:
    if row["rational_rank"] >= 4:
        require(
            row["maximum_residue_transcendence_degree"] <= 1,
            "rank >= 4 must have low residue transcendence degree",
        )

groups = payload["local_narrowing"]["surviving_decomposition_groups"]
require(
    groups == ["PSL(2,11)", "A5_class_1", "A5_class_2", "11:5"],
    "surviving decomposition groups",
)
h_status = (ROOT / "H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/STATUS.md").read_text()
for needle in (
    "two maximal `A5` classes",
    "maximal `11:5`",
    "all proper subgroups other than",
):
    require(needle in h_status, f"subgroup boundary missing: {needle}")

theorem = (HERE / "THEOREM.md").read_text()
for needle in (
    "rational rank at least four",
    "Graber--Harris--Starr",
    "No nontrivial commutative or semiabelian torsor",
    "Item 5 is not present",
    "not silently",
):
    require(needle in theorem, f"scope marker missing: {needle}")

for nonclaim in payload["strict_nonclaims"]:
    require(nonclaim in {
        "no Schur-field local nonpoint has been constructed",
        "no full residue cubic is proved pointless",
        "no global pointlessness theorem is proved",
        "the Problem E headline remains open",
    }, f"unexpected nonclaim: {nonclaim}")

print("PASS authoritative input hashes")
print("PASS degree-3/degree-55 transfer annihilation")
print("PASS commutative and semiabelian torsor-recipient no-go")
print("PASS universal ramified-inertia and unramified-residue imports")
print("PASS Schur-field Abhyankar boundary rr(v) <= 3 for a nonpoint")
print("PASS proper-subgroup decomposition boundary")
print("PASS strict nonterminal scope")
print("Q_NEGATIVE_OBSTRUCTION_INTERFACE_ACCEPT")
