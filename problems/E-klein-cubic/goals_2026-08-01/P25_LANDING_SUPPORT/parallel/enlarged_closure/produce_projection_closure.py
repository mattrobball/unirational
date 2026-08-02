#!/usr/bin/env python3
"""Low-memory exact audit of the pure-q part of the first T-closure step.

The old lower presentation has 690 homogeneous cubic normal-form relations.
Let V0 be their basis-degree-zero (pure-q) coefficient space.  The 126
pure-q tails of the six multiplication operators on the 21 quadratic basis
elements contain only 56 distinct cubics.  This producer:

1. proves that V0 plus those 56 cubics is a direct 746-row space;
2. byte-matches that row set (up to the rewrite sign) to the pure-q
   projection of the complete 746-cubic QK RREF;
3. computes quotient coordinates W=(V0+W)/V0;
4. constructs all 4,140 T_i(seed_a) and 315 commutator classes in the small
   formal tensor space S_1 tensor W of dimension 37*56=2,072;
5. proves that the T_i(seed_a) classes span all 2,072 formal directions.

This does NOT identify the tensor quotient with its polynomial image in S_4;
that requires the still-open kernel of multiplication
S_1 tensor (V0+W) -> S_4.  Peak dense rank input here is about 71 MiB.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path
import time

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
FM = ROOT / "certificates" / "degree25_finite_module"
RREF_CACHE = ROOT / "tmp" / "p25z1_probe" / "rref_A.npz"
P = 89
NQ = 37
NSEED = 690
NK = 6
NQUAD = 21
DIM3Q = 9139
NW = 56
FORMAL_DIM = NQ * NW


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def write_json(path: Path, payload: dict) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


def rank_fflas(matrix: np.ndarray) -> int:
    """Exact modular rank via the installed FFLAS-FFPACK specialization."""
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


def rref_rows(matrix: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    """Exact row RREF; used only on the 746 by 9,139 cubic matrix."""
    a = np.ascontiguousarray(matrix, dtype=np.int64) % P
    rows, columns = a.shape
    pivots: list[int] = []
    row = 0
    for column in range(columns):
        candidates = np.flatnonzero(a[row:, column] % P)
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        if pivot != row:
            a[[row, pivot]] = a[[pivot, row]]
        a[row] = a[row] * pow(int(a[row, column]), -1, P) % P
        factors = a[:, column].copy()
        factors[row] = 0
        active = np.flatnonzero(factors)
        for target in active:
            a[target] = (a[target] - int(factors[target]) * a[row]) % P
        pivots.append(column)
        row += 1
        if row == rows:
            break
    return a, np.asarray(pivots, dtype=np.int32)


def invert_mod(matrix: np.ndarray) -> np.ndarray:
    n = matrix.shape[0]
    a = np.concatenate(
        [
            np.ascontiguousarray(matrix, dtype=np.int64) % P,
            np.eye(n, dtype=np.int64),
        ],
        axis=1,
    )
    for column in range(n):
        candidates = np.flatnonzero(a[column:, column] % P)
        if not len(candidates):
            raise AssertionError(f"singular basis minor at column {column}")
        pivot = column + int(candidates[0])
        if pivot != column:
            a[[column, pivot]] = a[[pivot, column]]
        a[column] = a[column] * pow(int(a[column, column]), -1, P) % P
        factors = a[:, column].copy()
        factors[column] = 0
        for target in np.flatnonzero(factors):
            a[target] = (a[target] - int(factors[target]) * a[column]) % P
    return a[:, n:]


def row_void(array: np.ndarray) -> np.ndarray:
    contiguous = np.ascontiguousarray(array)
    return contiguous.view(
        np.dtype((np.void, contiguous.dtype.itemsize * contiguous.shape[1]))
    ).ravel()


def full_coordinates(
    rows: np.ndarray, pivot_columns: np.ndarray, inverse_minor: np.ndarray
) -> np.ndarray:
    return (
        rows[:, pivot_columns].astype(np.int64) @ inverse_minor.astype(np.int64)
    ) % P


def row_rank_profile_fflas(matrix: np.ndarray) -> np.ndarray:
    """Return exact independent row indices from FFLAS's rank-profile API."""
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.RowRankProfile_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_size_t)),
        ctypes.c_int,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    pointer = ctypes.POINTER(ctypes.c_size_t)()
    rows, columns = dense.shape
    rank = int(
        function(
            float(P),
            rows,
            columns,
            dense,
            columns,
            ctypes.byref(pointer),
            1,  # FfpackSlabRecursive
            False,
        )
    )
    profile = np.ctypeslib.as_array(pointer, shape=(rank,)).copy()
    return profile.astype(np.int32)


def main() -> None:
    started = time.monotonic()
    relation_path = FM / "relation_matrix.npz"
    multiplication_path = FM / "multiplication_matrices.npz"
    with np.load(relation_path, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        bdeg = frozen["Bdeg"].astype(np.int8)
        assert int(frozen["prime"]) == P
    with np.load(multiplication_path, allow_pickle=False) as frozen:
        tquad = frozen["T_quad_F3"].astype(np.uint8)
        assert int(frozen["prime"]) == P
    if seeds.shape != (NSEED, 14134) or tquad.shape != (NK, NQUAD, 14134):
        raise AssertionError("unexpected sealed input shape")
    if list(bdeg[:7]) != [0, 1, 1, 1, 1, 1, 1]:
        raise AssertionError("unexpected basis grading")

    v0 = np.ascontiguousarray(seeds[:, offsets[0] : offsets[1]])
    tq0 = np.ascontiguousarray(
        tquad[:, :, offsets[0] : offsets[1]].reshape(NK * NQUAD, DIM3Q)
    )
    unique_tq0 = np.unique(tq0, axis=0)
    if unique_tq0.shape != (NW, DIM3Q):
        raise AssertionError(f"expected 56 unique rewrite tails, got {unique_tq0.shape}")

    # The complete QK-RREF pure-q rows are the residual V0 rows and the
    # opposite-signed monic K^3 tails.  A row-multiset equality is stronger
    # here than a mere rank agreement and avoids a second large echelonization.
    complete_basis = np.vstack(
        [v0, (-unique_tq0.astype(np.int16) % P).astype(np.uint8)]
    )
    with np.load(RREF_CACHE, allow_pickle=False) as frozen:
        complete_rref = frozen["A"].astype(np.uint8)
        permutation = frozen["perm"].astype(np.int32)
    if complete_rref.shape != (746, 14190):
        raise AssertionError("unexpected complete RREF shape")
    q_block_start = 56 + 777 + 4218
    complete_q_projection = np.ascontiguousarray(complete_rref[:, q_block_start:])
    row_multiset_equal = np.array_equal(
        np.sort(row_void(complete_basis)), np.sort(row_void(complete_q_projection))
    )
    if not row_multiset_equal:
        raise AssertionError("746-row pure-q multiset mismatch")

    # One nonzero 746-square minor proves simultaneously
    # rank(V0)=690, rank(W)=56, and rank(V0 direct-sum W)=746.
    _echelon, pivot_columns = rref_rows(complete_basis)
    if len(pivot_columns) != 746:
        raise AssertionError(f"complete pure-q rank {len(pivot_columns)} != 746")
    basis_minor = np.ascontiguousarray(complete_basis[:, pivot_columns])
    inverse_minor = invert_mod(basis_minor)
    if not np.array_equal(
        basis_minor.astype(np.int64) @ inverse_minor % P,
        np.eye(746, dtype=np.int64),
    ):
        raise AssertionError("basis minor inverse failed")

    tq_full_coordinates = full_coordinates(tq0, pivot_columns, inverse_minor)
    tq_w_coordinates = np.ascontiguousarray(tq_full_coordinates[:, NSEED:], dtype=np.uint8)
    # Full reconstruction certifies that quotient coordinates were not read
    # merely from pivot columns under an unproved span assumption.
    reconstructed = tq_full_coordinates.astype(np.int64) @ complete_basis.astype(np.int64) % P
    if not np.array_equal(reconstructed.astype(np.uint8), tq0):
        raise AssertionError("rewrite-tail coordinate reconstruction failed")

    # M2[a,quadratic-basis,q-linear-monomial].  We retain the sealed monomial
    # order; it is a permutation of q0,...,q36 and hence a canonical S_1 basis.
    m2 = np.stack(
        [
            seeds[:, offsets[7 + quadratic] : offsets[8 + quadratic]]
            for quadratic in range(NQUAD)
        ],
        axis=1,
    ).astype(np.uint8)
    if m2.shape != (NSEED, NQUAD, NQ):
        raise AssertionError(f"unexpected M2 shape {m2.shape}")
    tq_w = tq_w_coordinates.reshape(NK, NQUAD, NW).astype(np.int64)

    test_blocks: list[np.ndarray] = []
    block_ranks: list[int] = []
    cumulative_ranks: list[int] = []
    for operator in range(NK):
        # (seed,q-coordinate,quadratic) times (quadratic,W) -> (seed,q,W)
        block = (
            m2.transpose(0, 2, 1).astype(np.int64) @ tq_w[operator]
        ) % P
        block = np.ascontiguousarray(block.reshape(NSEED, FORMAL_DIM), dtype=np.uint8)
        test_blocks.append(block)
        block_ranks.append(rank_fflas(block))
        cumulative_ranks.append(rank_fflas(np.vstack(test_blocks)))
    formal_tests = np.ascontiguousarray(np.vstack(test_blocks), dtype=np.uint8)
    zero_test_rows = int(np.count_nonzero(~np.any(formal_tests, axis=1)))
    formal_test_rank = cumulative_ranks[-1]
    if formal_test_rank != FORMAL_DIM or zero_test_rows != 0:
        raise AssertionError(
            f"unexpected formal test rank/zeros {formal_test_rank}/{zero_test_rows}"
        )

    # Pure-q commutator classes, using exactly the ordering/formula of the
    # sealed P25V bulk computation but reducing cubics only in the 56-dim W.
    tquad_quadratic = np.empty((NK, NQUAD, NQUAD, NQ), dtype=np.uint8)
    for operator in range(NK):
        for source in range(NQUAD):
            for target in range(NQUAD):
                tquad_quadratic[operator, source, target] = tquad[
                    operator,
                    source,
                    offsets[7 + target] : offsets[8 + target],
                ]
    commutators: list[np.ndarray] = []
    commutator_labels: list[list[int]] = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source in range(NQUAD):
                first = (
                    tquad_quadratic[right, source].T.astype(np.int64)
                    @ tq_w[left]
                ) % P
                second = (
                    tquad_quadratic[left, source].T.astype(np.int64)
                    @ tq_w[right]
                ) % P
                commutators.append(
                    np.ascontiguousarray((first - second) % P, dtype=np.uint8).reshape(
                        FORMAL_DIM
                    )
                )
                commutator_labels.append([left, right, source])
    formal_commutators = np.ascontiguousarray(np.vstack(commutators), dtype=np.uint8)
    zero_commutator_rows = int(
        np.count_nonzero(~np.any(formal_commutators, axis=1))
    )
    commutator_rank = rank_fflas(formal_commutators)
    augmented_formal_rank = rank_fflas(
        np.vstack([formal_tests, formal_commutators])
    )
    if augmented_formal_rank != FORMAL_DIM:
        raise AssertionError("commutators unexpectedly changed formal ambient rank")

    minor_rows = row_rank_profile_fflas(formal_tests)
    minor_rule = "FFLAS exact row-rank profile"
    if len(minor_rows) != FORMAL_DIM:
        raise AssertionError(f"formal row-rank profile length {len(minor_rows)}")
    formal_minor = np.ascontiguousarray(formal_tests[minor_rows], dtype=np.uint8)
    formal_minor_hash = sha256_array(formal_minor)
    if rank_fflas(formal_minor) != FORMAL_DIM:
        raise AssertionError("stored formal minor is singular")

    certificate_path = HERE / "projection_closure_certificate.npz"
    np.savez_compressed(
        certificate_path,
        prime=np.int32(P),
        basis_pivot_columns=pivot_columns,
        basis_minor=basis_minor,
        basis_minor_sha256=np.asarray(sha256_array(basis_minor)),
        tq_w_coordinates=tq_w_coordinates,
        tq_w_coordinates_sha256=np.asarray(sha256_array(tq_w_coordinates)),
        formal_test_minor_rows=minor_rows,
        formal_test_minor_sha256=np.asarray(formal_minor_hash),
        formal_test_sha256=np.asarray(sha256_array(formal_tests)),
        formal_commutator_sha256=np.asarray(sha256_array(formal_commutators)),
        commutator_labels=np.asarray(commutator_labels, dtype=np.int16),
    )

    payload = {
        "status": "PASS_ENLARGED_CLOSURE_PROJECTION",
        "prime": P,
        "inputs": {
            "relation_matrix": str(relation_path.relative_to(ROOT)),
            "relation_matrix_sha256": sha256_file(relation_path),
            "multiplication_matrices": str(multiplication_path.relative_to(ROOT)),
            "multiplication_matrices_sha256": sha256_file(multiplication_path),
            "complete_rref_cache": str(RREF_CACHE.relative_to(ROOT)),
            "complete_rref_cache_sha256": sha256_file(RREF_CACHE),
            "permutation_sha256": sha256_array(permutation),
        },
        "cubic_projection": {
            "V0_shape": [NSEED, DIM3Q],
            "rank_V0": NSEED,
            "Tq0_rows": NK * NQUAD,
            "Tq0_distinct_rows": NW,
            "rank_W": NW,
            "rank_V0_plus_W": NSEED + NW,
            "direct_sum": True,
            "complete_746_pure_q_row_multiset_equal": row_multiset_equal,
            "basis_minor_shape": [746, 746],
            "basis_minor_sha256": sha256_array(basis_minor),
        },
        "degree4_formal_tensor": {
            "space": "S_1 tensor ((V0+W)/V0)",
            "ambient_dimension": FORMAL_DIM,
            "T_i_seed_rows": NK * NSEED,
            "T_i_seed_zero_rows": zero_test_rows,
            "T_i_block_ranks": block_ranks,
            "T_i_cumulative_ranks": cumulative_ranks,
            "T_i_seed_span_rank": formal_test_rank,
            "T_i_seed_span_is_entire_formal_tensor": formal_test_rank == FORMAL_DIM,
            "commutator_rows": len(commutator_labels),
            "commutator_zero_rows": zero_commutator_rows,
            "commutator_span_rank": commutator_rank,
            "rank_after_adding_commutators": augmented_formal_rank,
            "commutators_add_formal_directions": augmented_formal_rank - formal_test_rank,
            "full_rank_minor_rule": minor_rule,
            "full_rank_minor_shape": [FORMAL_DIM, FORMAL_DIM],
            "full_rank_minor_sha256": formal_minor_hash,
        },
        "iteration": {
            "degree4": "one T-step spans all S_1 tensor W formally",
            "degree5": {
                "formal_q_multiple_space": "S_2 tensor W",
                "dimension": 703 * NW,
                "covered_by_q_multiples_of_degree4": True,
            },
            "all_higher_degrees": (
                "By symmetric multiplication, q-multiples of the degree-4 formal "
                "span cover S_d tensor W for every d>=1. This stabilizes only the "
                "pure-q formal quotient; coupled module closure may still enlarge."
            ),
        },
        "theorem_boundary": {
            "proves": (
                "Over F_89, the complete 746-cubic pure-q projection is exactly "
                "V0 direct-sum W with dimensions 690+56. The 4,140 first T-closure "
                "classes span the full 2,072-dimensional formal tensor S_1 tensor W; "
                "the 315 commutator classes add no formal direction. Hence the pure-q "
                "part of the first enlargement is controlled by 2,072 directions, "
                "not 4,455 separately adjoined rows."
            ),
            "does_not_prove": (
                "Injectivity or exact rank of multiplication S_1 tensor (V0+W)->S_4; "
                "the 2,072-dimensional rank of the polynomial quotient "
                "S_1(V0+W)/S_1V0; individual quartic nonmembership; stabilization of "
                "the full coupled S-module; a pure-q annihilator; or support emptiness."
            ),
            "safe_polynomial_consequence": (
                "The polynomial images of all first-step T_i(seed) pure-q components "
                "span the entire image of S_1 tensor W modulo S_1V0, whatever its "
                "eventual dimension. This is a generator reduction, not a membership verdict."
            ),
        },
        "superseding_degree5_dimension": {
            "source_upper_bound": 4386720,
            "target_dimension": 4496388,
            "full_surjectivity_possible": False,
        },
        "certificate": {
            "file": certificate_path.name,
            "sha256": sha256_file(certificate_path),
        },
        "resource": {
            "elapsed_seconds": round(time.monotonic() - started, 6),
            "largest_rank_matrix_shape": [NK * NSEED + 15 * NQUAD, FORMAL_DIM],
            "largest_rank_matrix_float64_mib": round(
                (NK * NSEED + 15 * NQUAD) * FORMAL_DIM * 8 / 2**20, 3
            ),
            "singular_launched": False,
            "old_45_GiB_rref_replayed": False,
        },
    }
    result_path = HERE / "projection_closure_result.json"
    write_json(result_path, payload)
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
