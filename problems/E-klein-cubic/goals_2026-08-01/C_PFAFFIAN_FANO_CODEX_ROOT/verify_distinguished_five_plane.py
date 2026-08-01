#!/usr/bin/env python3
"""Independent replay of the exact descended distinguished five-plane."""

from __future__ import annotations

import hashlib
import json
import runpy
from pathlib import Path

import numpy as np
from sympy import Matrix
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


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


def q_coefficients(pf):
    embedding, hom_dimension = pf["normalized_intertwiner"]()
    assert hom_dimension == 1 and embedding.rank() == 5
    K = pf["K11"]
    rows = embedding.to_list()
    answer = [[[K.zero for _ in range(5)] for _ in range(6)] for _ in range(6)]
    for pair_index, (left, right) in enumerate(pf["PAIR_INDEX"]):
        for variable in range(5):
            answer[left][right][variable] = rows[pair_index][variable]
            answer[right][left][variable] = -rows[pair_index][variable]
    return answer


def q_at(coefficients, point, K):
    return DomainMatrix([
        [sum((coefficients[r][c][i] * K(point[i]) for i in range(5)), K.zero) for c in range(6)]
        for r in range(6)
    ], (6, 6), K)


def sigma(matrix, q):
    return q.inv().matmul(matrix.transpose()).matmul(q)


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    value = matrix.copy() % prime
    row = 0
    for column in range(value.shape[1]):
        pivots = np.flatnonzero(value[row:, column])
        if not len(pivots):
            continue
        pivot = row + int(pivots[0])
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
        for other in range(value.shape[0]):
            if other != row and value[other, column]:
                value[other] = (value[other] - value[other, column] * value[row]) % prime
        row += 1
        if row == value.shape[0]:
            break
    return row


def reduce_k11(data, prime, zeta):
    return sum(
        int(num) * pow(int(den), -1, prime) * pow(zeta, exponent, prime)
        for exponent, (num, den) in enumerate(data)
    ) % prime


def q_mod(serialized, point, prime, zeta):
    answer = np.zeros((6, 6), dtype=np.int64)
    for r in range(6):
        for c in range(6):
            answer[r, c] = sum(
                reduce_k11(serialized[r][c][i], prime, zeta) * int(point[i])
                for i in range(5)
            ) % prime
    return answer


def main() -> None:
    payload = json.loads((HERE / "distinguished_five_plane.json").read_text())
    assert payload["format"] == "c2-distinguished-five-plane-lazy-v1"
    expected_hashes = {
        "involution.json": digest(HERE / "involution.json"),
        "alignment_core.py": digest(ROOT / "tmp/pfaffian_representation_alignment/core.py"),
        "phi_coefficients.py": digest(ROOT / "tmp/generic_twist/phi_coefficients.py"),
        "exact_covariants_check.py": digest(ROOT / "certificates/exact_covariants_check.py"),
    }
    assert payload["source_hashes"] == expected_hashes

    pf = runpy.run_path(str(ROOT / "tmp/pfaffian_representation_alignment/core.py"))
    phi = runpy.run_path(str(ROOT / "tmp/generic_twist/phi_coefficients.py"))
    names, frame, _ = phi["all_coefficients"]()
    stored = payload["hilbert90_frame"]
    assert list(names) == stored["names"] and stored["degrees"] == [1, 4, 5, 6, 7]
    for name, vector in zip(names, frame):
        assert [serialize_polynomial(component) for component in vector] == stored["vectors"][name]
    print("PASS independently rebuilt the exact x,C,D,E,K Hilbert-90 frame")

    coefficients = q_coefficients(pf)
    involution = json.loads((HERE / "involution.json").read_text())
    serialized = [[[pf["coefficients"](value, 10) for value in entry] for entry in row] for row in coefficients]
    assert serialized == involution["Q_linear_coefficients"]

    point = (1, -1, 0, 2, -2)
    values = [[phi["evaluate"](component, point) for component in vector] for vector in frame]
    frame_det = Matrix(5, 5, lambda row, column: values[column][row]).det()
    assert frame_det == -1737906321
    q = q_at(coefficients, point, pf["K11"])
    assert q.det() != pf["K11"].zero and q.transpose() == -q
    symmetric = []
    for value in values:
        alternating = q_at(coefficients, value, pf["K11"])
        element = q.inv().matmul(alternating)
        assert alternating.transpose() == -alternating and sigma(element, q) == element
        symmetric.append(element)
    columns = [[symmetric[j][r, c].element for j in range(5)] for r in range(6) for c in range(6)]
    assert DomainMatrix(columns, (36, 5), pf["K11"]).rank() == 5
    print("PASS exact independent witness gives five linearly independent sigma-fixed elements")

    c3 = runpy.run_path(str(ROOT / "certificates/fano_c3/produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    fresh = []
    modular_point = (1, 2, 3, 4, 5)
    modular_values = [
        [phi["evaluate"](component, modular_point) for component in vector]
        for vector in frame
    ]
    for prime, zeta in ((331, 74), (463, 15)):
        frame_data = c2["build_projective_reynolds_frame"](prime, zeta)
        a = frame_data["basis_mats"][1] % prime
        b = frame_data["basis_mats"][2] % prime
        rectangle_matrices = c3["rectangle_matrices"](a, b, prime)
        rectangle = np.stack([matrix.reshape(-1) for matrix in rectangle_matrices], axis=1) % prime
        rinv = c3["inv_mat"](rectangle, prime)
        q0 = q_mod(serialized, modular_point, prime, zeta)
        qinv = c3["inv_mat"](q0, prime)
        symmetric_columns = []
        for value in modular_values:
            alternating = q_mod(serialized, value, prime, zeta)
            assert np.array_equal(alternating.T % prime, -alternating % prime)
            element = qinv @ alternating % prime
            assert np.array_equal(qinv @ element.T @ q0 % prime, element)
            coordinates = rinv @ element.reshape(-1) % prime
            assert np.array_equal(rectangle @ coordinates % prime, element.reshape(-1))
            symmetric_columns.append(element.reshape(-1))
        assert rank_mod(np.stack(symmetric_columns, axis=1), prime) == 5
        fresh.append({"prime": prime, "zeta11": zeta, "rank": 5})
    print(f"PASS fresh-prime compressed transports {fresh}")
    print("SCOPE exact distinguished five-plane before explicit Morita/Hermitian coordinates")
    print("C2-DISTINGUISHED-FIVE-PLANE-LAZY-VERIFIED")


if __name__ == "__main__":
    main()
