#!/usr/bin/env python3
"""Independent verifier for the exact lazy compressed involution."""

from __future__ import annotations

import hashlib
import json
import runpy
from pathlib import Path

import numpy as np
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def digest(path):
    h = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            h.update(block)
    return h.hexdigest()


def expected_q(pf):
    embedding, dimension = pf["normalized_intertwiner"]()
    assert dimension == 1 and embedding.rank() == 5
    K = pf["K11"]
    answer = [[[K.zero for _ in range(5)] for _ in range(6)] for _ in range(6)]
    rows = embedding.to_list()
    for index, (left, right) in enumerate(pf["PAIR_INDEX"]):
        for variable in range(5):
            answer[left][right][variable] = rows[index][variable]
            answer[right][left][variable] = -rows[index][variable]
    return answer


def deserialize_q(payload, pf):
    K = pf["K11"]
    return [[[pf["from_coefficients"](entry, K) for entry in variables] for variables in row] for row in payload["Q_linear_coefficients"]]


def q_at(coefficients, point, pf):
    K = pf["K11"]
    return DomainMatrix([[sum((coefficients[r][c][i] * K(point[i]) for i in range(5)), K.zero) for c in range(6)] for r in range(6)], (6, 6), K)


def exact_generator(data, point, pf):
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


def reduce_q(coefficients, point, p, zeta, pf):
    answer = np.zeros((6, 6), dtype=np.int64)
    for r in range(6):
        for c in range(6):
            for variable in range(5):
                data = pf["coefficients"](coefficients[r][c][variable], 10)
                scalar = sum(int(num) * pow(int(den), -1, p) * pow(zeta, exponent, p) for exponent, (num, den) in enumerate(data)) % p
                answer[r, c] = (answer[r, c] + scalar * point[variable]) % p
    return answer


def main():
    payload = json.loads((HERE / "involution.json").read_text())
    compressed = json.loads((HERE / "compressed_algebra.json").read_text())
    assert payload["format"] == "c1-lazy-symplectic-involution-v1"
    assert payload["source_hashes"]["compressed_algebra.json"] == digest(HERE / "compressed_algebra.json")
    assert payload["source_hashes"]["alignment_core.py"] == digest(ROOT / "tmp/pfaffian_representation_alignment/core.py")
    assert payload["source_hashes"]["alignment_certificate.json"] == digest(ROOT / "tmp/pfaffian_representation_alignment/certificate.json")

    pf = runpy.run_path(str(ROOT / "tmp/pfaffian_representation_alignment/core.py"))
    kp = runpy.run_path(str(ROOT / "tmp/kproj_arithmetic/core.py"))
    expected = expected_q(pf)
    stored = deserialize_q(payload, pf)
    assert stored == expected

    point = tuple(payload["exact_witness"])
    q = q_at(stored, point, pf)
    assert q.transpose() == -q and q.det() != pf["K11"].zero
    forms = kp["forms"]()
    scale = pf["K11"](kp["evaluate"](forms[11], point)) / pf["K11"](kp["evaluate"](forms[14], point))
    a = exact_generator(compressed["generators"]["a"]["C_a"], point, pf) * scale
    b = exact_generator(compressed["generators"]["b"]["C_b"], point, pf) * scale
    sigma = lambda matrix: q.inv().matmul(matrix.transpose()).matmul(q)
    assert sigma(sigma(a)) == a and sigma(sigma(b)) == b
    assert sigma(a.matmul(b)) == sigma(b).matmul(sigma(a))

    c3 = runpy.run_path(str(ROOT / "certificates/fano_c3/produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    kpm = {}
    core = ROOT / "tmp/kproj_arithmetic/core.py"
    exec(compile(core.read_text().replace("ROOT = Path(__file__).resolve().parents[2]", f"ROOT = Path(r'{ROOT}')"), str(core), "exec"), kpm)
    invariant_forms = kpm["forms"]()
    seeds = json.loads((ROOT / "tmp/pfaffian_representation_alignment/certificate.json").read_text())["end36_reynolds_frame"]["selected_reynolds_seeds"]
    holdouts = []
    for p, zeta, modular_point in ((331, 74, (2, 3, 5, 7, 11)), (463, 15, (2, 3, 5, 7, 11))):
        conjugation, inverse_targets = c3["build_group"](c2, p, zeta)
        frame, _vectors = c3["frame_at_point"](c2, conjugation, inverse_targets, seeds, invariant_forms, kpm["evaluate_mod"], modular_point, p)
        a_mod, b_mod = frame[1] % p, frame[2] % p
        q_mod = reduce_q(stored, modular_point, p, zeta, pf)
        assert np.array_equal(q_mod.T % p, -q_mod % p)
        qinv = c3["inv_mat"](q_mod, p)
        rectangle = np.stack([matrix.reshape(-1) for matrix in c3["rectangle_matrices"](a_mod, b_mod, p)], axis=1) % p
        rinv = c3["inv_mat"](rectangle, p)
        sigma_columns = []
        for matrix in c3["rectangle_matrices"](a_mod, b_mod, p):
            image = qinv @ matrix.T @ q_mod % p
            coordinates = rinv @ image.reshape(-1) % p
            assert np.array_equal(rectangle @ coordinates % p, image.reshape(-1))
            sigma_columns.append(coordinates)
        operator = np.stack(sigma_columns, axis=1) % p
        identity = np.eye(36, dtype=np.int64) % p
        assert np.array_equal(operator @ operator % p, identity)
        dimensions = (36 - rank_mod(operator - identity, p), 36 - rank_mod(operator + identity, p))
        assert dimensions == (15, 21)
        assert np.array_equal(qinv @ (a_mod @ b_mod % p).T @ q_mod % p, (qinv @ b_mod.T @ q_mod % p) @ (qinv @ a_mod.T @ q_mod % p) % p)
        holdouts.append((p, dimensions))

    print("PASS exact Q(x)=Jx rebuilt coefficient-by-coefficient from the normalized intertwiner")
    print(f"PASS exact skewness, invertibility, sigma^2, and anti-multiplicativity at {point}")
    print(f"PASS fresh compressed-coordinate holdouts with eigenspace dimensions {holdouts}")
    print("SCOPE exact lazy involution; Morita corner, Hermitian five-plane, common line, and headline remain open")
    print("C1-LAZY-INVOLUTION-EXACT-VERIFIED")


if __name__ == "__main__":
    main()
