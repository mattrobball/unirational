#!/usr/bin/env python3
"""Install the exact lazy symplectic involution on the compressed algebra."""

from __future__ import annotations

import hashlib
import json
import runpy
from pathlib import Path

import numpy as np
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = HERE / "involution.json"


def digest(path):
    h = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            h.update(block)
    return h.hexdigest()


def deserialize_generator_matrix(data, point, pf):
    K = pf["K11"]
    rows = []
    for row in data:
        output = []
        for polynomial in row:
            value = K.zero
            for term in polynomial:
                coefficient = pf["from_coefficients"](term["coefficient_Qzeta11"], K)
                monomial = 1
                for coordinate, exponent in zip(point, term["exponents"]):
                    monomial *= coordinate ** exponent
                value += coefficient * K(monomial)
            output.append(value)
        rows.append(output)
    return DomainMatrix(rows, (6, 6), K)


def q_coefficients(pf):
    embedding, hom_dimension = pf["normalized_intertwiner"]()
    assert hom_dimension == 1 and embedding.rank() == 5
    K = pf["K11"]
    rows = embedding.to_list()
    coefficients = [[[K.zero for _ in range(5)] for _ in range(6)] for _ in range(6)]
    for pair_index, (left, right) in enumerate(pf["PAIR_INDEX"]):
        for variable in range(5):
            coefficients[left][right][variable] = rows[pair_index][variable]
            coefficients[right][left][variable] = -rows[pair_index][variable]
    return coefficients


def serialize_q(coefficients, pf):
    return [[[pf["coefficients"](value, 10) for value in entry] for entry in row] for row in coefficients]


def q_at(coefficients, point, pf):
    K = pf["K11"]
    rows = [[sum((coefficients[r][c][i] * K(point[i]) for i in range(5)), K.zero) for c in range(6)] for r in range(6)]
    return DomainMatrix(rows, (6, 6), K)


def sigma(matrix, q):
    return q.inv().matmul(matrix.transpose()).matmul(q)


def reduce_k11(data, p, zeta):
    return sum(int(num) * pow(int(den), -1, p) * pow(zeta, exponent, p) for exponent, (num, den) in enumerate(data)) % p


def q_mod(serialized, point, p, zeta):
    answer = np.zeros((6, 6), dtype=np.int64)
    for r in range(6):
        for c in range(6):
            answer[r, c] = sum(reduce_k11(serialized[r][c][i], p, zeta) * int(point[i]) for i in range(5)) % p
    return answer


def rank_mod(matrix, p):
    value = matrix.copy() % p
    row = 0
    for column in range(value.shape[1]):
        pivots = np.flatnonzero(value[row:, column])
        if not len(pivots):
            continue
        pivot = row + int(pivots[0])
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, p) % p
        for other in range(value.shape[0]):
            if other != row and value[other, column]:
                value[other] = (value[other] - value[other, column] * value[row]) % p
        row += 1
        if row == value.shape[0]:
            break
    return row


def modular_checks(serialized_q):
    c3 = runpy.run_path(str(ROOT / "certificates/fano_c3/produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    checks = []
    point = (1, 2, 3, 4, 5)
    for p, zeta in ((89, 2), (199, 18)):
        frame = c2["build_projective_reynolds_frame"](p, zeta)
        a, b = frame["basis_mats"][1] % p, frame["basis_mats"][2] % p
        q = q_mod(serialized_q, point, p, zeta)
        assert np.array_equal(q.T % p, -q % p)
        qinv = c3["inv_mat"](q, p)
        rectangle_columns = [matrix.reshape(-1) for matrix in c3["rectangle_matrices"](a, b, p)]
        rectangle = np.stack(rectangle_columns, axis=1) % p
        rinv = c3["inv_mat"](rectangle, p)
        sigma_columns = []
        basis_matrices = c3["rectangle_matrices"](a, b, p)
        for matrix in basis_matrices:
            image = qinv @ matrix.T @ q % p
            coordinates = rinv @ image.reshape(-1) % p
            assert np.array_equal(rectangle @ coordinates % p, image.reshape(-1))
            sigma_columns.append(coordinates)
        sigma_matrix = np.stack(sigma_columns, axis=1) % p
        identity = np.eye(36, dtype=np.int64) % p
        assert np.array_equal(sigma_matrix @ sigma_matrix % p, identity)
        fixed_dimension = 36 - rank_mod((sigma_matrix - identity) % p, p)
        anti_dimension = 36 - rank_mod((sigma_matrix + identity) % p, p)
        assert (fixed_dimension, anti_dimension) == (15, 21)
        sigma_a = qinv @ a.T @ q % p
        sigma_b = qinv @ b.T @ q % p
        assert np.array_equal(qinv @ (a @ b % p).T @ q % p, sigma_b @ sigma_a % p)
        assert np.array_equal(qinv @ sigma_a.T @ q % p, a)
        checks.append({"prime": p, "zeta11": zeta, "fixed_dimension": fixed_dimension, "anti_dimension": anti_dimension})
    return checks


def main():
    pf = runpy.run_path(str(ROOT / "tmp/pfaffian_representation_alignment/core.py"))
    kp = runpy.run_path(str(ROOT / "tmp/kproj_arithmetic/core.py"))
    compressed = json.loads((HERE / "compressed_algebra.json").read_text())
    coefficients = q_coefficients(pf)
    serialized = serialize_q(coefficients, pf)

    # Exact identities at a tiny point; these use only 6x6 inverses.
    point = (0, 0, 1, -1, -1)
    q = q_at(coefficients, point, pf)
    assert q.transpose() == -q and q.det() != pf["K11"].zero
    ca = deserialize_generator_matrix(compressed["generators"]["a"]["C_a"], point, pf)
    cb = deserialize_generator_matrix(compressed["generators"]["b"]["C_b"], point, pf)
    forms = kp["forms"]()
    scale = pf["K11"](kp["evaluate"](forms[11], point)) / pf["K11"](kp["evaluate"](forms[14], point))
    a, b = ca * scale, cb * scale
    assert sigma(sigma(a, q), q) == a
    assert sigma(a.matmul(b), q) == sigma(b, q).matmul(sigma(a, q))

    payload = {
        "format": "c1-lazy-symplectic-involution-v1",
        "field": compressed["base"]["K_proj"],
        "Q_linear_coefficients": serialized,
        "Q_semantics": "Q(x)[r,c]=sum_i Q_linear_coefficients[r,c,i]*x_i",
        "involution": "sigma_x(M)=Q(x)^-1*M^t*Q(x)",
        "compressed_transport": {
            "basis": "b^j*a^i, j outer then i",
            "coordinate_matrix": "S=R^-1*column_stack(vec(sigma(b^j*a^i)))",
            "anti_multiplicative_shortcut": "sigma(b^j*a^i)=sigma(a)^i*sigma(b)^j",
            "coordinate_invariance": "Pfaffian equivariance plus uniqueness of rectangle coordinates makes S descend to K_proj",
        },
        "identities": ["Q^t=-Q", "sigma^2=1", "sigma(xy)=sigma(y)sigma(x)"],
        "eigenspace_dimensions": {"sigma_plus": 15, "sigma_minus": 21},
        "exact_witness": list(point),
        "modular_checks": modular_checks(serialized),
        "source_hashes": {
            "compressed_algebra.json": digest(HERE / "compressed_algebra.json"),
            "alignment_core.py": digest(ROOT / "tmp/pfaffian_representation_alignment/core.py"),
            "alignment_certificate.json": digest(ROOT / "tmp/pfaffian_representation_alignment/certificate.json"),
        },
        "theorem_boundary": {
            "proved": "the exact lazy compressed symplectic involution and its 15/21 eigenspace dimensions",
            "not_proved": "a materialized named-invariant coordinate matrix, self-adjoint idempotent, Morita quaternion, five Hermitian forms, common line, or headline",
        },
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"WROTE {OUT}")
    print("C1-LAZY-INVOLUTION-EXACT")


if __name__ == "__main__":
    main()
