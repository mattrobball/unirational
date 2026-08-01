#!/usr/bin/env python3
"""Independent consistency verifier for the nonterminal Goal-Q audit."""

from __future__ import annotations

import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def load(relative: str) -> dict:
    return json.loads((HERE / relative).read_text())


audit = load("completion_audit.json")
q0 = load("q0_ledger.json")
quartic = load("quartic_frontier.json")
negative = load("parallel/negative_obstruction/audit_payload.json")
linked = load("parallel/quartic_descent/linked_quintic_certificate.json")
incidence = load("parallel/curve_incidence/incidence_certificate.json")
bridge = load("parallel/fixed_curve_bridge/bridge_cases.json")

assert audit["schema"] == "q-schur-completion-audit-v1"
assert audit["headline"] == "Q-UNDECIDED"
assert all(value is False for value in audit["binary_exits"].values())
assert audit["seal_present"] is False
assert not (HERE / "SEAL.json").exists()
assert (HERE / "STATUS.md").read_text().splitlines()[0] == "Q-UNDECIDED"
assert (HERE / "COMPLETION_AUDIT.md").read_text().splitlines()[0] == "Q-UNDECIDED"

frontier = audit["exact_frontiers"]
assert q0["index"] == frontier["index"] == 1
assert q0["headline"] == quartic["headline"] == negative["headline"] == "OPEN"
assert quartic["no_point_consequence"]["possible_galois_closure_groups"] == frontier[
    "primitive_quartic_groups"
]
assert (
    linked["schur_field"]["quartic_x_quintic_residue_compositum_degree"]
    == frontier["linked_residue_compositum_degree"]
    == 20
)
counts = {row["degree"]: row["point_normalized_invariant"] for row in incidence["point_counts"]}
assert counts[3] == frontier["degree_three_point_incidence_count"] == 8
assert counts[4] == frontier["degree_four_virtual_point_incidence_count"] == 192
assert frontier["generic_twisted_cubic_incidence_degree"] == 8
assert frontier["actual_odd_degree_stable_map_forces_point"] is True
assert frontier["special_incidence_splitting_verified"] is False
assert incidence["conclusions"]["goal_resolved"] is False
assert "actual_degree_three_genus_zero_stable_map_over_K" in bridge["decisive_outputs"]
assert bridge["conditional_c3_gate"]["currently_verified"] is False
assert (
    negative["local_narrowing"]["necessary_maximum_rational_rank"]
    == frontier["valuation_nonpoint_maximum_rational_rank"]
    == 3
)
assert (
    negative["local_narrowing"]["surviving_decomposition_groups"]
    == frontier["surviving_decomposition_groups"]
)
assert "No unrestricted" in audit["missing_positive_premise"]
assert "No surviving" in audit["missing_negative_premise"]

print("PASS both binary exits remain unproved")
print("PASS absence of terminal seal")
print("PASS exact frontier payloads agree")
print(audit["marker"])
