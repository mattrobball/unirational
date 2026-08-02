#!/usr/bin/env python3
"""Independent replay of the enlarged pure-q projection certificate.

This verifier does not import the producer.  It rebuilds the cubic row sets,
quotient coordinates, all formal T-closure rows, and all commutator rows from
the sealed relation/multiplication arrays.  Exact ranks use only small FFLAS
matrices; the historical 25,530 by 91,390 RREF is never constructed.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
FM = ROOT / "certificates" / "degree25_finite_module"
RREF_CACHE = ROOT / "tmp" / "p25z1_probe" / "rref_A.npz"
P = 89
NQ, NSEED, NK, NQUAD, NW = 37, 690, 6, 21, 56
FORMAL_DIM = NQ * NW


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def rank_fflas(matrix: np.ndarray) -> int:
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.Rank_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rows, columns = dense.shape
    return int(function(float(P), rows, columns, dense, columns, False))


def independent_inverse(matrix: np.ndarray) -> np.ndarray:
    """Gauss-Jordan inverse, separately implemented for replay."""
    n = matrix.shape[0]
    work = np.zeros((n, 2 * n), dtype=np.int64)
    work[:, :n] = matrix.astype(np.int64) % P
    work[:, n:] = np.eye(n, dtype=np.int64)
    for col in range(n):
        pivot = next(
            (row for row in range(col, n) if int(work[row, col]) % P), None
        )
        if pivot is None:
            raise AssertionError(f"singular stored cubic minor at {col}")
        if pivot != col:
            work[[col, pivot]] = work[[pivot, col]]
        work[col] = work[col] * pow(int(work[col, col]), -1, P) % P
        coefficients = work[:, col].copy()
        coefficients[col] = 0
        for row in np.flatnonzero(coefficients):
            work[row] = (work[row] - int(coefficients[row]) * work[col]) % P
    return work[:, n:]


def row_void(array: np.ndarray) -> np.ndarray:
    contiguous = np.ascontiguousarray(array)
    return contiguous.view(
        np.dtype((np.void, contiguous.dtype.itemsize * contiguous.shape[1]))
    ).ravel()


def main() -> None:
    result_path = HERE / "projection_closure_result.json"
    certificate_path = HERE / "projection_closure_certificate.npz"
    result = json.loads(result_path.read_text())
    if result["status"] != "PASS_ENLARGED_CLOSURE_PROJECTION":
        raise AssertionError("producer result did not record PASS")
    if sha256_file(certificate_path) != result["certificate"]["sha256"]:
        raise AssertionError("certificate file hash mismatch")

    relation_path = FM / "relation_matrix.npz"
    multiplication_path = FM / "multiplication_matrices.npz"
    if sha256_file(relation_path) != result["inputs"]["relation_matrix_sha256"]:
        raise AssertionError("relation input hash mismatch")
    if (
        sha256_file(multiplication_path)
        != result["inputs"]["multiplication_matrices_sha256"]
    ):
        raise AssertionError("multiplication input hash mismatch")
    if sha256_file(RREF_CACHE) != result["inputs"]["complete_rref_cache_sha256"]:
        raise AssertionError("complete RREF cache hash mismatch")

    relation = np.load(relation_path, allow_pickle=False)
    multiplication = np.load(multiplication_path, allow_pickle=False)
    seeds = relation["seed_F3"].astype(np.uint8)
    offsets = relation["off3"].astype(np.int32)
    tquad = multiplication["T_quad_F3"].astype(np.uint8)
    v0 = np.ascontiguousarray(seeds[:, offsets[0] : offsets[1]])
    tq0 = np.ascontiguousarray(
        tquad[:, :, offsets[0] : offsets[1]].reshape(NK * NQUAD, 9139)
    )
    unique_tq0 = np.unique(tq0, axis=0)
    if unique_tq0.shape != (NW, 9139):
        raise AssertionError("rewrite-tail deduplication did not give 56 rows")
    complete_basis = np.vstack(
        [v0, (-unique_tq0.astype(np.int16) % P).astype(np.uint8)]
    )

    cached = np.load(RREF_CACHE, allow_pickle=False)
    complete_q = np.ascontiguousarray(cached["A"][:, 56 + 777 + 4218 :])
    if not np.array_equal(
        np.sort(row_void(complete_basis)), np.sort(row_void(complete_q))
    ):
        raise AssertionError("complete 746 pure-q row multiset mismatch")

    certificate = np.load(certificate_path, allow_pickle=False)
    if int(certificate["prime"]) != P:
        raise AssertionError("certificate prime mismatch")
    pivot_columns = certificate["basis_pivot_columns"].astype(np.int32)
    stored_minor = certificate["basis_minor"].astype(np.uint8)
    rebuilt_minor = np.ascontiguousarray(complete_basis[:, pivot_columns])
    if not np.array_equal(stored_minor, rebuilt_minor):
        raise AssertionError("stored cubic minor byte mismatch")
    if sha256_array(rebuilt_minor) != str(certificate["basis_minor_sha256"]):
        raise AssertionError("stored cubic minor digest mismatch")
    if rank_fflas(rebuilt_minor) != 746:
        raise AssertionError("stored cubic minor is not full rank")

    inverse = independent_inverse(rebuilt_minor)
    all_coordinates = (
        tq0[:, pivot_columns].astype(np.int64) @ inverse.astype(np.int64)
    ) % P
    quotient_coordinates = np.ascontiguousarray(
        all_coordinates[:, NSEED:], dtype=np.uint8
    )
    if not np.array_equal(quotient_coordinates, certificate["tq_w_coordinates"]):
        raise AssertionError("quotient coordinate byte mismatch")
    if sha256_array(quotient_coordinates) != str(
        certificate["tq_w_coordinates_sha256"]
    ):
        raise AssertionError("quotient coordinate hash mismatch")
    if not np.array_equal(
        (all_coordinates @ complete_basis.astype(np.int64) % P).astype(np.uint8),
        tq0,
    ):
        raise AssertionError("full quotient-coordinate reconstruction failed")

    m2 = np.stack(
        [
            seeds[:, offsets[7 + quadratic] : offsets[8 + quadratic]]
            for quadratic in range(NQUAD)
        ],
        axis=1,
    )
    tq_w = quotient_coordinates.reshape(NK, NQUAD, NW).astype(np.int64)
    blocks: list[np.ndarray] = []
    block_ranks: list[int] = []
    cumulative_ranks: list[int] = []
    for operator in range(NK):
        block = (
            m2.transpose(0, 2, 1).astype(np.int64) @ tq_w[operator]
        ) % P
        block = np.ascontiguousarray(block.reshape(NSEED, FORMAL_DIM), dtype=np.uint8)
        blocks.append(block)
        block_ranks.append(rank_fflas(block))
        cumulative_ranks.append(rank_fflas(np.vstack(blocks)))
    formal_tests = np.ascontiguousarray(np.vstack(blocks), dtype=np.uint8)
    if sha256_array(formal_tests) != str(certificate["formal_test_sha256"]):
        raise AssertionError("formal T-test digest mismatch")
    if block_ranks != result["degree4_formal_tensor"]["T_i_block_ranks"]:
        raise AssertionError("formal T block-rank mismatch")
    if cumulative_ranks != result["degree4_formal_tensor"]["T_i_cumulative_ranks"]:
        raise AssertionError("formal T cumulative-rank mismatch")

    minor_rows = certificate["formal_test_minor_rows"].astype(np.int32)
    formal_minor = np.ascontiguousarray(formal_tests[minor_rows])
    if sha256_array(formal_minor) != str(certificate["formal_test_minor_sha256"]):
        raise AssertionError("formal full-rank minor digest mismatch")
    if rank_fflas(formal_minor) != FORMAL_DIM:
        raise AssertionError("formal T-test minor is not full rank")

    tq_quadratic = np.empty((NK, NQUAD, NQUAD, NQ), dtype=np.uint8)
    for operator in range(NK):
        for source in range(NQUAD):
            for target in range(NQUAD):
                tq_quadratic[operator, source, target] = tquad[
                    operator,
                    source,
                    offsets[7 + target] : offsets[8 + target],
                ]
    commutators: list[np.ndarray] = []
    labels: list[list[int]] = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source in range(NQUAD):
                first = tq_quadratic[right, source].T.astype(np.int64) @ tq_w[left]
                second = tq_quadratic[left, source].T.astype(np.int64) @ tq_w[right]
                commutators.append(
                    np.ascontiguousarray((first - second) % P, dtype=np.uint8).reshape(
                        FORMAL_DIM
                    )
                )
                labels.append([left, right, source])
    formal_commutators = np.ascontiguousarray(np.vstack(commutators), dtype=np.uint8)
    if not np.array_equal(
        np.asarray(labels, dtype=np.int16), certificate["commutator_labels"]
    ):
        raise AssertionError("commutator label order mismatch")
    if sha256_array(formal_commutators) != str(
        certificate["formal_commutator_sha256"]
    ):
        raise AssertionError("formal commutator digest mismatch")
    commutator_rank = rank_fflas(formal_commutators)
    if commutator_rank != result["degree4_formal_tensor"]["commutator_span_rank"]:
        raise AssertionError("formal commutator rank mismatch")
    if rank_fflas(np.vstack([formal_minor, formal_commutators])) != FORMAL_DIM:
        raise AssertionError("commutators changed full formal span")

    output = {
        "status": "PASS_INDEPENDENT_PROJECTION_CLOSURE_REPLAY",
        "rank_V0": NSEED,
        "rank_W": NW,
        "rank_V0_plus_W": NSEED + NW,
        "formal_T_rank": FORMAL_DIM,
        "formal_commutator_rank": commutator_rank,
        "formal_augmented_rank": FORMAL_DIM,
        "basis_minor_sha256": sha256_array(rebuilt_minor),
        "formal_minor_sha256": sha256_array(formal_minor),
        "old_45_GiB_rref_replayed": False,
        "theorem_boundary_checked": True,
    }
    output_path = HERE / "verify_projection_closure_result.json"
    output_path.write_text(json.dumps(output, indent=2, sort_keys=True) + "\n")
    print(json.dumps(output, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
