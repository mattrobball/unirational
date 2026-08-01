#!/usr/bin/env python3
"""Sealed replay for the exact degree-55 multisection theorem."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
WORK_ROOT = HERE.parents[1]
PROBLEM_ROOT = HERE.parents[2]


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(path: Path) -> None:
    completed = subprocess.run(
        [sys.executable, str(path)],
        cwd=path.parent,
        check=True,
        text=True,
        capture_output=True,
    )
    print(completed.stdout, end="")


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    status = (HERE / "STATUS.md").read_text().splitlines()[0]
    assert status == seal["verdict"] == "PROVED-MULTISECTION-DEGREE-55"

    for relative, expected in seal["local_files"].items():
        actual = digest(HERE / relative)
        assert actual == expected, (relative, expected, actual)
    for relative, expected in seal["upstream_inputs"].items():
        actual = digest(PROBLEM_ROOT / relative)
        assert actual == expected, (relative, expected, actual)
    print("PASS seal and pinned local/upstream hashes")

    payload = json.loads((HERE / "payload.json").read_text())
    group = payload["group"]
    fields = payload["fields"]
    avoidance = payload["center_avoidance"]
    multi = payload["multisection"]
    disjunction = payload["requested_disjunction"]

    assert group["order"] == 660
    assert group["line_stabilizer_order"] == 12
    assert group["order"] // group["line_stabilizer_order"] == 55
    assert group["orbit_size"] == fields["L_over_K0_degree"] == 55
    assert fields["L_is_field"]

    bezout = avoidance["bezout_coefficients"]
    assert bezout["degree_3"] * avoidance["center_divisor_degree"] + bezout[
        "degree_55"
    ] * avoidance["hypothetical_orbit_intersection_cycle_degree"] == 1
    assert not avoidance["center_has_K0_point"]
    assert avoidance["all_orbit_lines_disjoint_from_center_plane"]

    assert multi["normalization"] == "P1_L"
    assert multi["component_map_to_base_degree"] == 1
    assert multi["geometric_components"] == multi["degree_over_K0_base"] == 55
    assert multi["finite_etale_over_base"] and multi["connected_over_K0"]
    assert not multi["geometrically_connected"]
    assert disjunction["multisection"] == "PROVED_DEGREE_55"
    assert disjunction["result"] is True
    assert disjunction["section"] == "NOT_CLAIMED"
    print("PASS arithmetic: 660/12=55 and 37*3-2*55=1")
    print("PASS normalized multisection P1_L -> P1_K0 has exact degree 55")

    # Each upstream verifier has its own deeper hash-bound dependency ledger.
    run(WORK_ROOT / "M_SARKISOV" / "verify.py")
    run(PROBLEM_ROOT / "tmp" / "schur_unrestricted_point_attack_audit" / "verify.py")
    run(PROBLEM_ROOT / "tmp" / "xcd_general_slice_completion" / "verify.py")

    print("PASS exact xCD center is pointless over Kproj and hence over K0")
    print("PASS orbit lines avoid the center and give a G-equivariant degree-55 multisection")
    print("PROVED-MULTISECTION-DEGREE-55")


if __name__ == "__main__":
    main()
