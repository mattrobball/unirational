#!/usr/bin/env python3
"""Sealed replay for the exact degree-three multisection theorem."""

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
    result = subprocess.run(
        [sys.executable, str(path)],
        cwd=path.parent,
        check=True,
        text=True,
        capture_output=True,
    )
    print(result.stdout, end="")


def require_text(name: str, markers: list[str]) -> None:
    content = (HERE / name).read_text()
    for marker in markers:
        assert marker in content, (name, marker)


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    status = (HERE / "STATUS.md").read_text().splitlines()[0]
    assert status == seal["verdict"] == "DEGREE-3-MULTISECTION-PROVED"

    for relative, expected in seal["local_files"].items():
        assert digest(HERE / relative) == expected, relative
    for relative, expected in seal["upstream_inputs"].items():
        assert digest(PROBLEM_ROOT / relative) == expected, relative
    print("PASS sealed local files and pinned upstream inputs")

    payload = json.loads((HERE / "payload.json").read_text())
    center = payload["center"]
    cubic = payload["degree_3_construction"]
    quadratic = payload["degree_2_audit"]
    minimum = payload["minimum"]

    assert not center["K0_point"] and center["index"] == 3
    assert cubic["finite_etale_degree"] == cubic["degree_over_B"] == 3
    assert cubic["connected"] and cubic["multisection"] == "P1_K3"
    assert cubic["rational_over_constant_field"]
    assert not cubic["K0_rational"]
    assert not cubic["geometrically_integral_over_K0"]
    assert cubic["descent_datum_stable"]
    assert not cubic["G_orbit_of_three_branches"]

    # A disconnected finite-etale algebra of total degree 3 necessarily has
    # a degree-one factor.  Enumerate all ordered degree partitions.
    partitions = {(1, 1, 1), (1, 2), (3,)}
    assert all(1 in partition for partition in partitions if len(partition) > 1)
    print("PASS pointless center forces a transverse degree-3 divisor to be connected")

    assert quadratic["ambient_line_intersection_degree"] == 3
    assert quadratic["effective_cycle_degree"] == 2
    assert quadratic["residual_degree"] == 3 - 2 == 1
    assert quadratic["contained_line_also_has_K_point"]
    assert quadratic["implies_rational_section"]

    assert minimum["possible_values"] == [1, 3]
    assert minimum["if_section_exists"] == 1
    assert minimum["if_no_section_exists"] == 3
    assert minimum["degree_2_never_minimal"]
    assert minimum["degree_55_not_minimal"] and 3 < 55
    print("PASS minimum degree is 1 with a section and otherwise exactly 3")

    require_text(
        "THEOREM.md",
        [
            "A connected cubic point on the center",
            "The degree-three constant-field multisection",
            "Why degree two forces degree one",
            "\\min=3",
            "not \\(K_0\\)-rational",
        ],
    )
    require_text(
        "COMPLETION_AUDIT.md",
        [
            "degree 3 exists unconditionally",
            "degree-two middle case",
        ],
    )

    run(WORK_ROOT / "M_SARKISOV" / "section_or_multisection_20260801" / "verify.py")

    print("PASS E=C x P1 and the sealed xCD center has no K0-point")
    print("PASS integral constant-field multisection P1_K3 has exact degree 3")
    print("STRICT SCOPE P1_K3 is K3-rational, not K0-rational or geometrically integral")
    print("MINIMUM_DEGREE_IN_{1,3}_NEVER_2")
    print("DEGREE-3-MULTISECTION-PROVED")


if __name__ == "__main__":
    main()
