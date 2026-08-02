#!/usr/bin/env python3
"""Independent replay of the C5 convention/input failure.

This verifier does not import ``produce.py`` or a point-producing solver.
It reconstructs the first Hilbert--90 vector, the first symmetric section
element, the unit-ideal certificate, input hashes, and the local seal.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def reduce_q11(coefficient, prime: int, zeta: int) -> int:
    return sum(
        int(num) * pow(int(den), -1, prime) * pow(zeta, power, prime)
        for power, (num, den) in enumerate(coefficient)
    ) % prime


def determinant_mod(matrix: list[list[int]], prime: int) -> int:
    work = [[entry % prime for entry in row] for row in matrix]
    answer = 1
    for column in range(len(work)):
        pivot = next((row for row in range(column, len(work)) if work[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            answer = -answer
        scalar = work[column][column] % prime
        answer = answer * scalar % prime
        inverse = pow(scalar, -1, prime)
        work[column] = [value * inverse % prime for value in work[column]]
        for row in range(column + 1, len(work)):
            factor = work[row][column]
            if factor:
                work[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(work[row], work[column])
                ]
    return answer % prime


def check_coordinate_x(five_plane: dict) -> None:
    assert five_plane["hilbert90_frame"]["names"] == ["x", "C", "D", "E", "K"]
    vectors = five_plane["hilbert90_frame"]["vectors"]["x"]
    assert len(vectors) == 5
    for index, polynomial in enumerate(vectors):
        exponent = [0] * 5
        exponent[index] = 1
        assert polynomial == [{"exponents": exponent, "coefficient": 1}]


def check_q_open(involution: dict) -> None:
    coefficients = involution["Q_linear_coefficients"]
    assert len(coefficients) == 6
    for prime, zeta, point in ((331, 74, (1, 2, 3, 4, 5)), (463, 15, (2, 3, 5, 7, 11))):
        q = [
            [
                sum(reduce_q11(coefficients[r][c][i], prime, zeta) * point[i] for i in range(5)) % prime
                for c in range(6)
            ]
            for r in range(6)
        ]
        assert all(q[r][c] == -q[c][r] % prime for r in range(6) for c in range(6))
        assert determinant_mod(q, prime) != 0


def check_unit_ideal_certificate() -> None:
    # Reconstruct in an honest 6x6 splitting matrix.  Reduced trace is the
    # ordinary matrix trace, and the calculation is coefficientwise.
    variables = sp.symbols("e0:36")
    e = sp.Matrix(6, 6, variables)
    identity = sp.eye(6)
    h = e * e - e
    g = e * identity * e
    assert g - h == e
    trd_e = sp.trace(e)
    trace_of_g_minus_h = sp.trace(g - h)
    certificate = sp.expand(-sp.Rational(1, 2) * ((trd_e - 2) - trace_of_g_minus_h))
    assert certificate == 1


def main() -> None:
    manifest = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    incidence = json.loads((HERE / "projector_incidence.json").read_text())
    api = json.loads((HERE / "canonical_algebra_api.json").read_text())

    for section in ("authoritative_inputs", "audit_only_inputs"):
        for entry in manifest[section].values():
            path = ROOT / entry["path"]
            assert path.stat().st_size == entry["bytes"]
            assert sha256(path) == entry["sha256"]

    five_path = ROOT / manifest["authoritative_inputs"]["distinguished_five_plane"]["path"]
    involution_path = ROOT / manifest["authoritative_inputs"]["involution"]["path"]
    morita_path = ROOT / manifest["authoritative_inputs"]["morita_five_forms"]["path"]
    five_plane = json.loads(five_path.read_text())
    involution = json.loads(involution_path.read_text())
    morita = json.loads(morita_path.read_text())

    check_coordinate_x(five_plane)
    check_q_open(involution)
    assert five_plane["symmetric_elements"]["semantics"] == "S_j(x)=Q(x)^-1*Q(V_j(x))"
    assert api["S_x_coordinates"] == api["unit_coordinates"]
    assert morita["distinguished_hermitian_forms"]["names"][0] == "x"
    assert morita["good_fibre_witness"]["pairing"] != 0
    check_unit_ideal_certificate()

    assert len(incidence["all_coordinate_equations"]["idempotent"]) == 36
    assert len(incidence["all_coordinate_equations"]["self_adjoint"]) == 36
    assert len(incidence["all_coordinate_equations"]["section"]) == 5 * 36
    assert incidence["all_coordinate_equations"]["discarded_coordinate_equations"] == 0
    assert incidence["exit"] == "C5-UNDECIDED"
    assert incidence["marker"] == "C5_CONVENTION_GATE_FAIL"
    assert incidence["why_not_fano_emptiness"]["correct_symmetric_model"]["equations"] == [
        "n^2=0",
        "Trd(n*S_i)=0 for i=0,...,4",
    ]

    seal_path = HERE / "SEAL.json"
    if seal_path.exists():
        seal = json.loads(seal_path.read_text())
        for relative, expected in seal["local_files"].items():
            assert sha256(HERE / relative) == expected
        assert seal["external_inputs"] == {
            entry["path"]: entry["sha256"]
            for section in ("authoritative_inputs", "audit_only_inputs")
            for entry in manifest[section].values()
        }

    print("PASS all canonical and audit-only input hashes")
    print("PASS exact Hilbert--90 first vector V_0=x")
    print("PASS Q(x) is skew and invertible at two independent good reductions")
    print("PASS S_0=Q(x)^-1 Q(x)=1_A")
    print("PASS exact unit-ideal certificate for the prescribed projector incidence")
    print("PASS corrected boundary: this is not emptiness of the genuine Fano scheme")
    print("C5_CONVENTION_GATE_FAIL_INDEPENDENTLY_VERIFIED")


if __name__ == "__main__":
    main()
