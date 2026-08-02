#!/usr/bin/env python3
"""Replay the corrected C5 Lane-A point at the certified p=23 fibre.

The verifier reads the accepted symmetric-frame and full-wedge packets,
reconstructs every displayed coordinate list, and performs the six-fibre
constant-coefficient obstruction check.  It writes nothing.
"""

from __future__ import annotations

import hashlib
import itertools
import runpy
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
ATTACK = ROOT / "tmp/pfaffian_rank2_idempotent_attack/attack_core.py"
FANO = ROOT / "tmp/fano14_twist/fano_covariant_scan.py"
PRIME = 23
SYMMETRIC_INDICES = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15)
SYMMETRIC_MINOR_ROWS = (0, 1, 2, 3, 4, 6, 7, 8, 9, 12, 13, 14, 18, 19, 24)
EXPECTED_U = (16, 3, 22, 17, 7, 8)
EXPECTED_V = (6, 9, 17, 15, 1, 0)
EXPECTED_P15 = (11, 2, 0, 20, 21, 14, 7, 9, 20, 18, 18, 2, 4, 18, 15)
EXPECTED_Z10 = (14, 7, 9, 20, 18, 18, 2, 4, 18, 15)
EXPECTED_A15 = (20, 2, 13, 18, 6, 3, 0, 21, 8, 2, 2, 10, 3, 11, 22)
SOURCE_SHA256 = {
    ROOT / "tmp/pfaffian_rank2_idempotent_attack/attack_core.py":
        "d44132e529618c0a639039d6af5604d6700fc7e8653be2ad7c060c9be282eb05",
    ROOT / "tmp/fano14_twist/fano_covariant_scan.py":
        "b3c93a41ed1f8b5106d93717dbad058b6c60af100bcee8138925485dac6f107e",
    ROOT / "tmp/pfaffian_25plus11_descent/descent_core.py":
        "59fa59a249f02af563173e6279360af13da1a6ee748338a43086b0697c79d436",
    ROOT / "tmp/pfaffian_representation_alignment/core.py":
        "4adce14eae3e7f6c4ace7e398946b4e9efe686dbe68f6808c0289e2c7e73f5b4",
    ROOT / "tmp/pfaffian_25plus11_descent/certificate.json":
        "8361006e7fa78cb7269e3efbe9542dba676fedce35303528aee03b79320736bd",
    ROOT / "tmp/pfaffian_representation_alignment/certificate.json":
        "90746a65051b863c684c906f7166c70572a2edc319e6f6e6e306042261153848",
    ROOT / "tmp/generic_twist/phi_coefficients.py":
        "8c217aeaefe300a76e886f0a94803b5812689574299e1a2c72daeec72efd4525",
    ROOT / "tmp/kproj_arithmetic/core.py":
        "913b6184df2272e4834f81b38abdda9f468a2852ec571a04a469610054468b01",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


for source_path, expected_hash in SOURCE_SHA256.items():
    assert sha256(source_path) == expected_hash, source_path

attack = runpy.run_path(str(ATTACK))
fano = runpy.run_path(str(FANO))
rank = fano["rank"]
nullspace = fano["nullspace"]
inverse = fano["inv"]
pairs = fano["PAIRS"]
pair_index = fano["PAIR_INDEX"]


def skew(vector: np.ndarray) -> np.ndarray:
    matrix = np.zeros((6, 6), dtype=np.int64)
    for value, (left, right) in zip(vector, pairs):
        matrix[left, right] = value
        matrix[right, left] = -value % PRIME
    return matrix % PRIME


def fibre(data: dict, point: tuple[int, ...]):
    evaluation = attack["evaluate_basis"](data, point)
    q = evaluation["q"] % PRIME
    q_inverse = attack["dc"].inverse_mod(q)
    f3 = data["evaluate_mod"](data["forms"][3], point, PRIME)
    f5 = data["evaluate_mod"](data["forms"][5], point, PRIME)
    tau = f3 * f3 * pow(int(f5), -1, PRIME) % PRIME
    columns = []
    for degree, vector in zip((1, 4, 5, 6, 7), data["hilbert_frame"]):
        columns.append(
            [
                data["phi"]["evaluate"](component, point)
                * pow(int(tau), -degree, PRIME)
                % PRIME
                for component in vector
            ]
        )
    hilbert_frame = np.column_stack(columns) % PRIME
    assert rank(hilbert_frame) == 5
    forms = [
        skew(data["embedding"] @ hilbert_frame[:, column] % PRIME)
        for column in range(5)
    ]
    sections = [q_inverse @ form % PRIME for form in forms]
    symmetric = [
        evaluation["symmetric"][index] % PRIME for index in SYMMETRIC_INDICES
    ]
    symmetric_columns = np.column_stack(
        [matrix.reshape(-1) for matrix in symmetric]
    ) % PRIME
    traces = np.array(
        [
            [int(np.trace(matrix @ section) % PRIME) for matrix in symmetric]
            for section in sections
        ],
        dtype=np.int64,
    ) % PRIME
    return q, forms, sections, symmetric, symmetric_columns, traces


def main() -> None:
    data = attack["load_fixed_data"]()
    point = attack["POINTS"][0]
    q, forms, sections, symmetric, symmetric_columns, traces = fibre(data, point)
    assert point == (22, 21, 8, 1, 1)
    assert rank(traces) == 5
    trace_kernel = nullspace(traces)
    assert trace_kernel.shape == (15, 10)

    domain_basis, target_basis, _ = fano["representation_data"]()
    evaluated_form_columns = np.column_stack(
        [
            np.array([form[i, j] for i, j in pairs], dtype=np.int64)
            for form in forms
        ]
    ) % PRIME
    assert rank(np.column_stack([domain_basis, evaluated_form_columns])) == 5

    # P -> n=-P Q, followed by coordinates in the certified symmetric basis.
    symmetric_minor_inverse = inverse(
        symmetric_columns[np.array(SYMMETRIC_MINOR_ROWS), :]
    )
    target_to_symmetric = []
    for column in range(10):
        p_matrix = skew(target_basis[:, column] % PRIME)
        n_matrix = -p_matrix @ q % PRIME
        coefficients = (
            symmetric_minor_inverse
            @ n_matrix.reshape(-1)[np.array(SYMMETRIC_MINOR_ROWS)]
            % PRIME
        )
        assert np.array_equal(
            symmetric_columns @ coefficients % PRIME,
            n_matrix.reshape(-1) % PRIME,
        )
        target_to_symmetric.append(coefficients)
    target_to_symmetric = np.column_stack(target_to_symmetric) % PRIME
    assert rank(target_to_symmetric) == 10
    assert np.all(traces @ target_to_symmetric % PRIME == 0)
    assert rank(np.column_stack([trace_kernel, target_to_symmetric])) == 10

    # Re-run the deterministic seed-20260801 discovery: six coordinate vectors
    # first, then 2,000 PCG64 vectors.  The first rank-drop hit is trial 49.
    rng = np.random.default_rng(20260801)
    candidates = []
    for coordinate in range(6):
        vector = np.zeros(6, dtype=np.int64)
        vector[coordinate] = 1
        candidates.append(vector)
    candidates.extend(
        vector
        for vector in (
            rng.integers(0, PRIME, size=6, dtype=np.int64) for _ in range(2000)
        )
        if np.any(vector)
    )
    discovery = None
    for trial, candidate_u in enumerate(candidates):
        common_kernel = nullspace(
            np.vstack([candidate_u @ form % PRIME for form in forms]) % PRIME
        )
        if common_kernel.shape[1] < 2:
            continue
        for column in range(common_kernel.shape[1]):
            candidate_v = common_kernel[:, column] % PRIME
            if rank(np.column_stack([candidate_u, candidate_v])) == 2:
                discovery = trial, candidate_u % PRIME, candidate_v
                break
        if discovery is not None:
            break
    assert discovery is not None
    trial, u, v = discovery
    assert trial == 49
    assert tuple(map(int, u)) == EXPECTED_U
    assert tuple(map(int, v)) == EXPECTED_V
    assert rank(np.column_stack([u, v])) == 2
    p15 = np.array(
        [
            (u[left] * v[right] - u[right] * v[left]) % PRIME
            for left, right in pairs
        ],
        dtype=np.int64,
    )
    assert tuple(map(int, p15)) == EXPECTED_P15
    assert [int(u @ form @ v % PRIME) for form in forms] == [0] * 5

    # target_basis*z10=p15 uniquely defines z10.
    assert rank(target_basis[:10, :]) == 10
    z10 = inverse(target_basis[:10, :]) @ p15[:10] % PRIME
    assert np.array_equal(target_basis @ z10 % PRIME, p15)
    assert tuple(map(int, z10)) == EXPECTED_Z10

    # a15 is the coordinate vector of n=-P Q in the accepted symmetric basis.
    a15 = target_to_symmetric @ z10 % PRIME
    assert tuple(map(int, a15)) == EXPECTED_A15
    p_matrix = skew(p15)
    n_matrix = (symmetric_columns @ a15 % PRIME).reshape(6, 6)
    q_inverse = attack["dc"].inverse_mod(q)
    assert np.array_equal(n_matrix, -p_matrix @ q % PRIME)
    assert rank(p_matrix) == rank(n_matrix) == 2
    assert np.all(n_matrix @ n_matrix % PRIME == 0)
    assert np.array_equal(q_inverse @ n_matrix.T @ q % PRIME, n_matrix)
    assert [
        int(np.trace(n_matrix @ section) % PRIME) for section in sections
    ] == [0] * 5

    # Jacobian of all 15 Pluecker generators after p=target_basis*z.
    residuals = []
    jacobian = []
    for i, j, k, ell in itertools.combinations(range(6), 4):
        ij, ik, ie = pair_index[(i, j)], pair_index[(i, k)], pair_index[(i, ell)]
        jk, je, ke = pair_index[(j, k)], pair_index[(j, ell)], pair_index[(k, ell)]
        residuals.append(
            (
                p15[ij] * p15[ke]
                - p15[ik] * p15[je]
                + p15[ie] * p15[jk]
            )
            % PRIME
        )
        jacobian.append(
            (
                target_basis[ij] * p15[ke]
                + p15[ij] * target_basis[ke]
                - target_basis[ik] * p15[je]
                - p15[ik] * target_basis[je]
                + target_basis[ie] * p15[jk]
                + p15[ie] * target_basis[jk]
            )
            % PRIME
        )
    jacobian = np.array(jacobian, dtype=np.int64) % PRIME
    assert residuals == [0] * 15
    assert rank(jacobian) == 6
    assert 10 - rank(jacobian) == 4

    # The six regular-fibre trace matrices have no constant common kernel.
    all_traces = []
    fibre_rows = []
    for other_point in attack["POINTS"]:
        _, _, _, other_symmetric, _, other_traces = fibre(data, other_point)
        other_n = sum(
            (
                int(coefficient) * matrix
                for coefficient, matrix in zip(a15, other_symmetric)
            ),
            np.zeros((6, 6), dtype=np.int64),
        ) % PRIME
        fibre_rows.append(
            {
                "point": other_point,
                "traces": tuple(map(int, other_traces @ a15 % PRIME)),
                "rank_n": rank(other_n),
                "n2_nonzero_entries": int(
                    np.count_nonzero(other_n @ other_n % PRIME)
                ),
            }
        )
        all_traces.append(other_traces)
    stacked = np.vstack(all_traces) % PRIME
    assert rank(stacked) == 15

    print("dependency_hashes=PASS")
    print(f"point={point} symmetric_indices={SYMMETRIC_INDICES}")
    print("trace_matrix_rank=5 trace_kernel_dimension=10 target_match=PASS")
    print(f"deterministic_discovery_trial={trial}")
    print(f"u={EXPECTED_U}")
    print(f"v={EXPECTED_V}")
    print(f"p15={tuple(map(int, p15))}")
    print(f"z10={tuple(map(int, z10))}")
    print(f"a15={tuple(map(int, a15))}")
    print("rank_P=2 rank_n=2 n2=0 sigma_n=n traces=0 pluecker=0")
    print(
        "restricted_pluecker_jacobian_rank=6 "
        "affine_tangent_dimension=4 projective_tangent_dimension=3"
    )
    for row in fibre_rows:
        print(row)
    print("six_fibre_stacked_trace_rank=15 constant_coefficient_kernel_dimension=0")
    print("C5_MODULAR_SEED_P23_OK")


if __name__ == "__main__":
    main()
