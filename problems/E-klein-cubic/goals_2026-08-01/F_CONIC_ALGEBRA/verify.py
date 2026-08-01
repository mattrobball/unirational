#!/usr/bin/env python3
"""Independent replay for the terminal Goal F emptiness packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            value.update(chunk)
    return value.hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> None:
    status = (HERE / "STATUS.md").read_text().splitlines()[0]
    require(status == "F-CONIC-CRITERION-EMPTY", "wrong or missing terminal marker")
    criterion = (HERE / "CRITERION.md").read_text()
    for phrase in (
        "six cubics in twelve",
        "F-CONIC-CRITERION-EMPTY",
        "C(K_proj)=empty",
    ):
        require(phrase in criterion, f"criterion theorem missing: {phrase}")

    presentation = json.loads((HERE / "field_presentation.json").read_text())
    require(presentation["primitive_equation"] == "P(A,B,Y,Z,u)=0", "primitive label drift")
    require(presentation["determinant_identity"] == "det(M)=u*C*P", "determinant identity drift")
    for filename, expected in presentation["payload_sha256"].items():
        actual = digest(HERE / "payload" / filename)
        require(actual == expected, f"payload hash mismatch: {filename}")

    primitive = (HERE / "payload/global_primitive_u_sextic_exact.tsv").read_text().splitlines()
    require(len(primitive) == 1594, "primitive term-count drift")
    exponents = [list(map(int, line.split()[:5])) for line in primitive[1:]]
    require(max(row[4] for row in exponents) == 6, "primitive is not sextic in u")
    require(any(row[4] == 6 for row in exponents), "primitive leading coefficient vanished")

    replay = subprocess.run(
        [sys.executable, str(HERE / "verify_field_presentation.py")],
        cwd=HERE,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
    ).stdout
    for marker in (
        "LOCAL_MATRIX_EQUALS_ACCEPTED_SPARSE_CONSEQUENCES",
        "DET_EQUALS_U_CONTENT_PRIMITIVE_ON_EXACT_SYMBOLIC_LINES",
        "PRIMITIVE_SEXTIC_DEGREE6_AND_SELECTED_EMBEDDING_ACCEPT",
        "GOAL_F_FIELD_PRESENTATION_ACCEPT",
    ):
        require(marker in replay, f"field replay marker missing: {marker}")

    obstruction = subprocess.run(
        [sys.executable, str(HERE / "verify_infinity_obstruction.py")],
        cwd=HERE,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
    ).stdout
    for marker in (
        "GOAL_F_INFINITY_EXACT_IDENTITIES_ACCEPT",
        "GOAL_F_INFINITY_MODULAR_LIFT_ACCEPT",
        "GOAL_F_CONIC_CRITERION_EMPTY_ACCEPT",
    ):
        require(marker in obstruction, f"infinity replay marker missing: {marker}")

    linear = json.loads((HERE / "linear_ansatz_p67.json").read_text())
    require(linear["scope"] == "discovery only", "bounded linear screen scope drift")
    require((HERE / "linear_ansatz_p67.out").read_text().strip() == "[-1]:", "linear ansatz output drift")
    line = json.loads((HERE / "line_constant_basis_p67.json").read_text())
    require(line["status"] == "timeout", "line ansatz must remain a non-result")

    seal_path = HERE / "SEAL.json"
    if seal_path.exists():
        seal = json.loads(seal_path.read_text())
        require(seal["exit"] == "F-CONIC-CRITERION-EMPTY", "seal exit drift")
        for relative, expected in seal["sha256"].items():
            require(digest(HERE / relative) == expected, f"seal hash mismatch: {relative}")

    print("GOAL_F_EXACT_FIELD_LAYER_ACCEPT")
    print("GOAL_F_BOUNDED_SCREENS_SCOPED_ACCEPT")
    print("GOAL_F_CONIC_CRITERION_EMPTY_ACCEPT")


if __name__ == "__main__":
    main()
