#!/usr/bin/env python3
"""Independent replay of the exact lazy C1 involution packet.

This verifier deliberately does not import ``produce_c1_involution.py``.  It
rebuilds the two installed Reynolds generators and the universal alternating
form from the sealed upstream alignment, and it uses finite-field holdouts not
recorded by the producer.
"""

from __future__ import annotations

import hashlib
import json
import runpy
from pathlib import Path

import numpy as np
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PACKET = HERE / "c1_involution.json"
POINT = (1, 2, 3, 4, 5)


def word_matrix(word, generators, identity):
    answer = identity
    for letter in word:
        answer = answer.matmul(generators[letter])
    return answer


def rebuild_records(pf):
    one5 = pf["identity"](5)
    one6 = pf["identity"](6)
    weil_s, weil_t = pf["weil_generators"]()
    schur_a, schur_b = pf["schur_generators"]()
    source_s = word_matrix(pf["WEIL_TO_PFAFFIAN"]["S"], {"A": schur_a, "B": schur_b}, one6)
    source_t = word_matrix(pf["WEIL_TO_PFAFFIAN"]["T"], {"A": schur_a, "B": schur_b}, one6)
    target_inverse = {"S": weil_s.inv(), "T": weil_t.inv()}
    source = {"S": source_s, "T": source_t}
    source_inverse = {letter: matrix.inv() for letter, matrix in source.items()}
    _group, words = pf["abstract_group"]()
    records = []
    for word in words.values():
        ti, s, si = one5, one6, one6
        for letter in word:
            ti = target_inverse[letter].matmul(ti)
            s = s.matmul(source[letter])
            si = source_inverse[letter].matmul(si)
        records.append((ti.to_list(), s.to_list(), si.to_list()))
    assert len(records) == 660
    return records


def evaluate_seed(point, seed, records, pf, kp):
    K = pf["K11"]
    degree = int(seed["degree"])
    exponents = seed["monomial_exponents"]
    unit_row, unit_column = seed["matrix_unit_zero_based"]
    matrix = [[K.zero for _ in range(6)] for _ in range(6)]
    for target_inverse, source, source_inverse in records:
        transformed = [
            sum((target_inverse[row][column] * K(point[column]) for column in range(5)), K.zero)
            for row in range(5)
        ]
        scalar = K.one
        for value, exponent in zip(transformed, exponents):
            scalar *= value ** int(exponent)
        for row in range(6):
            for column in range(6):
                matrix[row][column] += scalar * source[row][unit_row] * source_inverse[unit_column][column]
    forms = kp["forms"]()
    multiplier = K(kp["evaluate"](forms[14 - degree], point)) / K(kp["evaluate"](forms[14], point))
    return DomainMatrix(matrix, (6, 6), K) * multiplier


def universal_form(point, embedding, pf):
    K = pf["K11"]
    values = embedding.matmul(DomainMatrix([[K(value)] for value in point], (5, 1), K)).to_list()
    q = [[K.zero for _ in range(6)] for _ in range(6)]
    for row, (left, right) in zip(values, pf["PAIR_INDEX"]):
        q[left][right] = row[0]
        q[right][left] = -row[0]
    return DomainMatrix(q, (6, 6), K)


def digest_matrix(matrix, pf):
    serialized = pf["serialize_matrix"](matrix, 10)
    return hashlib.sha256(json.dumps(serialized, separators=(",", ":")).encode()).hexdigest()


def reduce_k11(value, p, zeta, pf):
    return sum(
        int(numerator) * pow(int(denominator), -1, p) * pow(zeta, exponent, p)
        for exponent, (numerator, denominator) in enumerate(pf["coefficients"](value, 10))
    ) % p


def q_mod(point, p, zeta, embedding, pf):
    reduced = np.array(
        [[reduce_k11(value, p, zeta, pf) for value in row] for row in embedding.to_list()],
        dtype=np.int64,
    )
    values = reduced @ np.array(point, dtype=np.int64) % p
    q = np.zeros((6, 6), dtype=np.int64)
    for value, (left, right) in zip(values, pf["PAIR_INDEX"]):
        q[left, right] = value
        q[right, left] = -value % p
    return q


def rank_mod(matrix, p):
    work = matrix.copy() % p
    row = 0
    for column in range(work.shape[1]):
        candidates = np.flatnonzero(work[row:, column] % p)
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        work[[row, pivot]] = work[[pivot, row]]
        work[row] = work[row] * pow(int(work[row, column]), -1, p) % p
        for other in range(work.shape[0]):
            if other != row and work[other, column] % p:
                work[other] = (work[other] - work[other, column] * work[row]) % p
        row += 1
        if row == work.shape[0]:
            break
    return row


def primitive_root_11(p):
    assert (p - 1) % 11 == 0
    for value in range(2, p):
        zeta = pow(value, (p - 1) // 11, p)
        if zeta != 1 and pow(zeta, 11, p) == 1:
            return zeta
    raise AssertionError("no 11th root")


def holdout_transport(p, pf, embedding, seeds):
    zeta = primitive_root_11(p)
    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    kproj = {}
    core = ROOT / "tmp" / "kproj_arithmetic" / "core.py"
    exec(
        compile(core.read_text().replace(
            "ROOT = Path(__file__).resolve().parents[2]", f"ROOT = Path(r'{ROOT}')"
        ), str(core), "exec"),
        kproj,
    )
    forms = kproj["forms"]()
    conjugation, inverse_targets = c3["build_group"](c2, p, zeta)
    selected = None
    for point in ((5, 2, 7, 11, 13), POINT, (2, 3, 5, 7, 11)):
        try:
            matrices, vectors = c3["frame_at_point"](
                c2, conjugation, inverse_targets, seeds, forms,
                kproj["evaluate_mod"], point, p,
            )
        except ValueError:
            continue
        rectangle = c3["rectangle_matrices"](matrices[1], matrices[2], p)
        rectangle_frame = np.stack([matrix.reshape(-1) for matrix in rectangle], axis=1) % p
        if c3["det_mod"](rectangle_frame, p):
            selected = point, matrices, vectors, rectangle, rectangle_frame
            break
    assert selected is not None
    point, matrices, vectors, rectangle, rectangle_frame = selected
    original_frame = vectors.T % p
    original_inverse = c3["inv_mat"](original_frame, p)
    rectangle_inverse = c3["inv_mat"](rectangle_frame, p)
    q = q_mod(point, p, zeta, embedding, pf)
    q_inverse = c3["inv_mat"](q, p)

    def sigma(matrix):
        return q_inverse @ matrix.T @ q % p

    original_images = np.stack([sigma(matrix).reshape(-1) for matrix in matrices], axis=1) % p
    rectangle_images = np.stack([sigma(matrix).reshape(-1) for matrix in rectangle], axis=1) % p
    sigma_original = original_inverse @ original_images % p
    sigma_rectangle = rectangle_inverse @ rectangle_images % p
    change = original_inverse @ rectangle_frame % p
    identity = np.eye(36, dtype=np.int64) % p
    assert np.array_equal(sigma_original @ sigma_original % p, identity)
    assert np.array_equal(sigma_rectangle @ sigma_rectangle % p, identity)
    assert np.array_equal(sigma_original @ change % p, change @ sigma_rectangle % p)
    assert 36 - rank_mod(sigma_rectangle - identity, p) == 15
    assert 36 - rank_mod(sigma_rectangle + identity, p) == 21
    for left_index in range(36):
        for right_index in range(36):
            left, right = rectangle[left_index], rectangle[right_index]
            assert np.array_equal(sigma(left @ right % p), sigma(right) @ sigma(left) % p)
    return p, zeta, point


def main():
    payload = json.loads(PACKET.read_text())
    assert payload["format"] == "goal-c-c1-lazy-involution-v1"
    assert payload["theorem_boundary"]["not_proved"].startswith("a self-adjoint rank-two idempotent")

    pf = runpy.run_path(str(ROOT / "tmp" / "pfaffian_representation_alignment" / "core.py"))
    kp = runpy.run_path(str(ROOT / "tmp" / "kproj_arithmetic" / "core.py"))
    alignment = json.loads((ROOT / "tmp" / "pfaffian_representation_alignment" / "certificate.json").read_text())
    embedding = pf["deserialize_matrix"](alignment["exact_intertwiner"]["embedding_15x5"])
    seeds = alignment["end36_reynolds_frame"]["selected_reynolds_seeds"]
    records = rebuild_records(pf)
    a = evaluate_seed(POINT, seeds[1], records, pf, kp)
    b = evaluate_seed(POINT, seeds[2], records, pf, kp)
    q = universal_form(POINT, embedding, pf)
    assert q.transpose() == -q and q.det() != pf["K11"].zero
    assert digest_matrix(q, pf) == payload["lazy_exact_transport"]["q_exact_digest"]
    assert digest_matrix(a, pf) == payload["lazy_exact_transport"]["a_exact_digest"]
    assert digest_matrix(b, pf) == payload["lazy_exact_transport"]["b_exact_digest"]
    q_inverse = q.inv()

    def sigma(matrix):
        return q_inverse.matmul(matrix.transpose()).matmul(q)

    for matrix in (pf["identity"](6), a, b, a.matmul(b), b.matmul(a)):
        assert sigma(sigma(matrix)) == matrix
    for left, right in ((a, b), (b, a), (a.matmul(b), b.matmul(a))):
        assert sigma(left.matmul(right)) == sigma(right).matmul(sigma(left))

    holdouts = [holdout_transport(p, pf, embedding, seeds) for p in (353, 617)]
    print("PASS rebuilt exact Q, a, and b digests without importing producer")
    print("PASS exact alternating adjoint involution and anti-multiplicativity checks")
    print(f"PASS unused split-prime original/rectangle transport holdouts {holdouts}")
    print("PASS plus/minus dimensions 15/21 and all 1296 rectangle basis pairs")
    print("C1-INVOLUTION-LAZY-EXACT-VERIFIED")


if __name__ == "__main__":
    main()
