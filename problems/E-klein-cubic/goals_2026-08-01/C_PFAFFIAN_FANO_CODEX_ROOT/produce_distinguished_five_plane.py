#!/usr/bin/env python3
"""Install the exact distinguished five-plane before Morita coordinates."""

from __future__ import annotations

import hashlib
import json
import runpy
from pathlib import Path

from sympy import Matrix
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = HERE / "distinguished_five_plane.json"


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            value.update(block)
    return value.hexdigest()


def serialize_polynomial(polynomial: dict[tuple[int, ...], int]) -> list[dict]:
    return [
        {"exponents": list(exponents), "coefficient": int(polynomial[exponents])}
        for exponents in sorted(polynomial)
    ]


def sigma(matrix: DomainMatrix, q: DomainMatrix) -> DomainMatrix:
    return q.inv().matmul(matrix.transpose()).matmul(q)


def main() -> None:
    pf = runpy.run_path(str(ROOT / "tmp/pfaffian_representation_alignment/core.py"))
    phi = runpy.run_path(str(ROOT / "tmp/generic_twist/phi_coefficients.py"))
    inv_helpers = runpy.run_path(str(HERE / "produce_involution.py"))
    involution = json.loads((HERE / "involution.json").read_text())

    names, frame, _coefficients = phi["all_coefficients"]()
    assert names == ("x", "C", "D", "E", "K")
    q_coefficients = inv_helpers["q_coefficients"](pf)
    assert inv_helpers["serialize_q"](q_coefficients, pf) == involution["Q_linear_coefficients"]

    point = (-2, -2, -2, -2, -1)
    values = [
        [phi["evaluate"](component, point) for component in vector]
        for vector in frame
    ]
    frame_determinant = Matrix(5, 5, lambda row, column: values[column][row]).det()
    assert frame_determinant == -295136920
    q = inv_helpers["q_at"](q_coefficients, point, pf)
    assert q.det() != pf["K11"].zero and q.transpose() == -q

    symmetric = []
    for value in values:
        alternating = inv_helpers["q_at"](q_coefficients, value, pf)
        assert alternating.transpose() == -alternating
        element = q.inv().matmul(alternating)
        assert sigma(element, q) == element
        symmetric.append(element)
    columns = [
        [symmetric[column][row, col].element for column in range(5)]
        for row in range(6)
        for col in range(6)
    ]
    assert DomainMatrix(columns, (36, 5), pf["K11"]).rank() == 5

    payload = {
        "format": "c2-distinguished-five-plane-lazy-v1",
        "field": involution["field"],
        "hilbert90_frame": {
            "names": list(names),
            "degrees": [1, 4, 5, 6, 7],
            "vectors": {
                name: [serialize_polynomial(component) for component in vector]
                for name, vector in zip(names, frame)
            },
            "generic_basis_witness": list(point),
            "generic_basis_determinant": int(frame_determinant),
        },
        "alternating_forms": {
            "semantics": "B_j(x)=Q(V_j(x)), with Q the exact aligned linear Pfaffian map",
            "distinguished_section": "span_K{B_x,B_C,B_D,B_E,B_K}",
        },
        "symmetric_elements": {
            "semantics": "S_j(x)=Q(x)^-1*Q(V_j(x))",
            "compressed_coordinates": "R^-1*vec(S_j), using compressed_algebra.json",
            "fixedness_identity": (
                "for alternating B_j and Q, sigma(Q^-1 B_j)="
                "Q^-1 (Q^-1 B_j)^t Q=Q^-1 B_j"
            ),
            "dimension": 5,
        },
        "exact_witness": {
            "point": list(point),
            "frame_determinant": int(frame_determinant),
            "Q_invertible": True,
            "symmetric_span_rank": 5,
        },
        "source_hashes": {
            "involution.json": digest(HERE / "involution.json"),
            "alignment_core.py": digest(ROOT / "tmp/pfaffian_representation_alignment/core.py"),
            "phi_coefficients.py": digest(ROOT / "tmp/generic_twist/phi_coefficients.py"),
            "exact_covariants_check.py": digest(ROOT / "certificates/exact_covariants_check.py"),
        },
        "theorem_boundary": {
            "proved": (
                "exact lazy K_proj basis of the specific descended five-plane as "
                "five sigma-symmetric algebra elements"
            ),
            "not_proved": (
                "an explicit self-adjoint projector, quaternion corner, 3x3 Hermitian "
                "coordinates, common isotropic line, or Fano point"
            ),
        },
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"WROTE {OUT}")
    print("C2-DISTINGUISHED-FIVE-PLANE-LAZY-EXACT")


if __name__ == "__main__":
    main()
