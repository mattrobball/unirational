#!/usr/bin/env python3
"""Produce the exact lazy C1 involution in the maximal-etale rectangle."""

from __future__ import annotations

import hashlib
import json
import runpy
from pathlib import Path

import numpy as np
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = HERE / "c1_involution.json"
POINT = (1, 2, 3, 4, 5)


def word_matrix(word, generators, identity):
    answer = identity
    for letter in word:
        answer = answer.matmul(generators[letter])
    return answer


def group_records(pf):
    one5 = pf["identity"](5)
    one6 = pf["identity"](6)
    ws, wt = pf["weil_generators"]()
    sa, sb = pf["schur_generators"]()
    source_s = word_matrix(pf["WEIL_TO_PFAFFIAN"]["S"], {"A": sa, "B": sb}, one6)
    source_t = word_matrix(pf["WEIL_TO_PFAFFIAN"]["T"], {"A": sa, "B": sb}, one6)
    targets_inverse = {"S": ws.inv(), "T": wt.inv()}
    sources = {"S": source_s, "T": source_t}
    sources_inverse = {key: value.inv() for key, value in sources.items()}
    _group, words = pf["abstract_group"]()
    result = []
    for word in words.values():
        target_inverse = one5
        source = one6
        source_inverse = one6
        for letter in word:
            target_inverse = targets_inverse[letter].matmul(target_inverse)
            source = source.matmul(sources[letter])
            source_inverse = sources_inverse[letter].matmul(source_inverse)
        result.append((target_inverse.to_list(), source.to_list(), source_inverse.to_list()))
    assert len(result) == 660
    return result


def evaluate_frame(point, records, pf, kp, seeds):
    K = pf["K11"]
    forms = kp["forms"]()
    f14 = K(kp["evaluate"](forms[14], point))
    assert f14 != K.zero
    matrices = []
    for seed in seeds:
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
                scalar *= value**int(exponent)
            for row in range(6):
                for column in range(6):
                    matrix[row][column] += scalar * source[row][unit_row] * source_inverse[unit_column][column]
        multiplier = K(kp["evaluate"](forms[14 - degree], point)) / f14
        matrices.append(DomainMatrix(matrix, (6, 6), K) * multiplier)
    return matrices


def flatten(matrix):
    return [value for row in matrix.to_list() for value in row]


def column_matrix(matrices, field):
    columns = [flatten(matrix) for matrix in matrices]
    return DomainMatrix([[columns[column][row] for column in range(len(columns))] for row in range(36)], (36, len(columns)), field)


def powers(matrix, count, pf):
    answer = [pf["identity"](6)]
    for _ in range(1, count):
        answer.append(answer[-1].matmul(matrix))
    return answer


def rectangle(a, b, pf):
    ap = powers(a, 6, pf)
    bp = powers(b, 6, pf)
    matrices = [bp[j].matmul(ap[i]) for j in range(6) for i in range(6)]
    return matrices, column_matrix(matrices, pf["K11"])


def universal_form(point, pf):
    certificate = json.loads((ROOT / "tmp" / "pfaffian_representation_alignment" / "certificate.json").read_text())
    embedding = pf["deserialize_matrix"](certificate["exact_intertwiner"]["embedding_15x5"])
    values = embedding.matmul(DomainMatrix([[pf["K11"](value)] for value in point], (5, 1), pf["K11"])).to_list()
    q = [[pf["K11"].zero for _ in range(6)] for _ in range(6)]
    for row, (left, right) in zip(values, pf["PAIR_INDEX"]):
        q[left][right] = row[0]
        q[right][left] = -row[0]
    answer = DomainMatrix(q, (6, 6), pf["K11"])
    assert answer.det() != pf["K11"].zero
    return answer


def adjoint(matrix, q, q_inverse):
    return q_inverse.matmul(matrix.transpose()).matmul(q)


def digest_matrix(matrix, pf):
    serialized = pf["serialize_matrix"](matrix, 10)
    return hashlib.sha256(json.dumps(serialized, separators=(",", ":")).encode()).hexdigest()


def reduce_k11(value, p, zeta, pf):
    result = 0
    for exponent, (numerator, denominator) in enumerate(pf["coefficients"](value, 10)):
        result += int(numerator) * pow(int(denominator), -1, p) * pow(zeta, exponent, p)
    return result % p


def rank_mod(matrix, p):
    work = matrix.copy() % p
    row = 0
    for column in range(work.shape[1]):
        pivots = np.flatnonzero(work[row:, column] % p)
        if not len(pivots):
            continue
        pivot = row + int(pivots[0])
        work[[row, pivot]] = work[[pivot, row]]
        work[row] = work[row] * pow(int(work[row, column]), -1, p) % p
        for other in range(work.shape[0]):
            if other != row and work[other, column] % p:
                work[other] = (work[other] - work[other, column] * work[row]) % p
        row += 1
        if row == work.shape[0]:
            break
    return row


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


def modular_transport_checks(seeds, embedding, pf):
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
    checks = []
    for p, zeta in ((23, 2), (331, 74), (463, 15)):
        conjugation, inverse_targets = c3["build_group"](c2, p, zeta)
        chosen = None
        for point in (POINT, (2, 3, 5, 7, 11), (3, 5, 8, 13, 21)):
            try:
                matrices, vectors = c3["frame_at_point"](
                    c2, conjugation, inverse_targets, seeds, forms,
                    kproj["evaluate_mod"], point, p,
                )
            except ValueError:
                continue
            a, b = matrices[1], matrices[2]
            rectangle = c3["rectangle_matrices"](a, b, p)
            rectangle_frame = np.stack([matrix.reshape(-1) for matrix in rectangle], axis=1) % p
            if c3["det_mod"](rectangle_frame, p):
                chosen = point, matrices, vectors, rectangle, rectangle_frame
                break
        assert chosen is not None
        point, matrices, vectors, rectangle, rectangle_frame = chosen
        original_frame = vectors.T % p
        original_inverse = c3["inv_mat"](original_frame, p)
        rectangle_inverse = c3["inv_mat"](rectangle_frame, p)
        q = q_mod(point, p, zeta, embedding, pf)
        assert c3["det_mod"](q, p)
        q_inverse = c3["inv_mat"](q, p)

        def sigma(matrix):
            return q_inverse @ matrix.T @ q % p

        original_images = np.stack([sigma(matrix).reshape(-1) for matrix in matrices], axis=1) % p
        rectangle_images = np.stack([sigma(matrix).reshape(-1) for matrix in rectangle], axis=1) % p
        sigma_original = original_inverse @ original_images % p
        sigma_rectangle = rectangle_inverse @ rectangle_images % p
        identity = np.eye(36, dtype=np.int64) % p
        assert np.array_equal(sigma_original @ sigma_original % p, identity)
        assert np.array_equal(sigma_rectangle @ sigma_rectangle % p, identity)
        change = original_inverse @ rectangle_frame % p
        assert np.array_equal(sigma_original @ change % p, change @ sigma_rectangle % p)
        assert 36 - rank_mod(sigma_rectangle - identity, p) == 15
        assert 36 - rank_mod(sigma_rectangle + identity, p) == 21
        for left in rectangle:
            for right in rectangle:
                assert np.array_equal(sigma(left @ right % p), sigma(right) @ sigma(left) % p)
        checks.append({
            "prime": p,
            "zeta11": zeta,
            "point": list(point),
            "original_frame_determinant": c3["det_mod"](original_frame, p),
            "rectangle_determinant": c3["det_mod"](rectangle_frame, p),
            "q_determinant": c3["det_mod"](q, p),
            "sigma_original_sha256": hashlib.sha256(bytes(sigma_original.astype(np.uint16))).hexdigest(),
            "sigma_rectangle_sha256": hashlib.sha256(bytes(sigma_rectangle.astype(np.uint16))).hexdigest(),
            "change_of_basis_intertwining": True,
            "anti_multiplicativity_basis_pairs": 36 * 36,
            "plus_dimension": 15,
            "minus_dimension": 21,
        })
    return checks


def main():
    pf = runpy.run_path(str(ROOT / "tmp" / "pfaffian_representation_alignment" / "core.py"))
    kp = runpy.run_path(str(ROOT / "tmp" / "kproj_arithmetic" / "core.py"))
    alignment = json.loads((ROOT / "tmp" / "pfaffian_representation_alignment" / "certificate.json").read_text())
    seeds = alignment["end36_reynolds_frame"]["selected_reynolds_seeds"]
    records = group_records(pf)
    original_matrices = evaluate_frame(POINT, records, pf, kp, seeds)
    a, b = original_matrices[1], original_matrices[2]
    rectangle_matrices, rectangle_frame = rectangle(a, b, pf)
    q = universal_form(POINT, pf)
    q_inverse = q.inv()
    assert q.transpose() == -q
    identity6 = pf["identity"](6)
    exact_test_matrices = (identity6, a, b, a.matmul(b), b.matmul(a))
    for matrix in exact_test_matrices:
        assert adjoint(adjoint(matrix, q, q_inverse), q, q_inverse) == matrix
    for left, right in ((a, b), (b, a), (a.matmul(b), b.matmul(a))):
        assert adjoint(left.matmul(right), q, q_inverse) == adjoint(right, q, q_inverse).matmul(adjoint(left, q, q_inverse))
    modular_checks = modular_transport_checks(seeds, pf["deserialize_matrix"](alignment["exact_intertwiner"]["embedding_15x5"]), pf)

    payload = {
        "format": "goal-c-c1-lazy-involution-v1",
        "field": "K_proj=Q(zeta11)(P(W))^PSL_2(F_11)",
        "universal_form": {
            "definition": "Q(x)=J*x from the exact 15x5 Pfaffian intertwiner",
            "covariance": "Q(g*x)=rho6(g)^(-T) Q(x) rho6(g)^(-1)",
            "pfaffian": "Pf(Q)=lambda*(x0^2*x1+x1^2*x2+x2^2*x3+x3^2*x4+x4^2*x0), lambda!=0",
        },
        "rectangular_involution": {
            "rectangle": "R=column_stack(vec(b^j*a^i), 0<=j,i<6)",
            "formula": "Sigma_R[:,(j,i)] = R^-1*vec(Q^-1*transpose(b^j*a^i)*Q)",
            "generic_open": "det(R)*Pf(Q)!=0",
            "symbolic_identities": [
                "Sigma_R^2=1 because Q^-1*(Q^-1*M^T*Q)^T*Q=M for Q^T=-Q",
                "sigma(XY)=sigma(Y)*sigma(X) by transpose reversal",
                "Reynolds covariance plus Q covariance makes every coordinate G-invariant",
            ],
        },
        "lazy_exact_transport": {
            "point": list(POINT),
            "Sigma_F": "F^-1*column_stack(vec(Q^-1*F_i^T*Q))",
            "Sigma_R": "R^-1*column_stack(vec(Q^-1*R_i^T*Q))",
            "C": "F^-1*R",
            "exact_identity": "Sigma_F*C=C*Sigma_R by cancellation of F and equality of the adjoint-image columns",
            "generic_nonvanishing": "each denominator is a polynomial/rational function with a nonzero good-reduction witness below",
            "q_exact_digest": digest_matrix(q, pf),
            "a_exact_digest": digest_matrix(a, pf),
            "b_exact_digest": digest_matrix(b, pf),
            "exact_direct_sigma_squared_checks": len(exact_test_matrices),
            "exact_direct_anti_multiplicativity_checks": 3,
        },
        "independent_good_reductions": modular_checks,
        "theorem_boundary": {
            "proved": "exact lazy transport of the specific symplectic involution to the C3 rectangle, with original-frame compatibility",
            "not_proved": "a self-adjoint rank-two idempotent, quaternion corner, five Hermitian matrices, common line, or headline",
        },
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"WROTE {OUT}")
    print("C1-INVOLUTION-LAZY-EXACT")


if __name__ == "__main__":
    main()
