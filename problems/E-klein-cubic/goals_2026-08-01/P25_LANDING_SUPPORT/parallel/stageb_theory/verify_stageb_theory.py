#!/usr/bin/env python3
"""Replay the exact Stage-B structural-theory audit over F_89.

The script verifies three useful but deliberately nonterminal facts.

1.  The M2 coefficient flattening has an explicit [I_690 | T] form with 87
    free tensor coordinates.
2.  Polarizing M1 gives a faithful linear 690 x 243 over-approximation L(q):

        L(q)(b1 tensor q, b2) = M1(q)b1 + M2(q)b2.

    An explicit 243 x 243 minor is nonzero at each coordinate point.  This is
    not a global constant-rank certificate.
3.  A concrete generalized zero of L is produced, so a 1-generic-matrix
    height theorem cannot be invoked.

The JSON result states the exact scope and records deterministic random-point
ranks separately as sampling only.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
import math
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
LINEAR_META = P25 / "linear_syzygies.json"
P = 89
SAMPLE_SEED = 2026080147
N_SAMPLES = 64


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            h.update(chunk)
    return h.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    result: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            result.append((first,) + tail)
    return result


def fflas_rank(matrix: np.ndarray) -> int:
    """Exact rank over F_89 through the installed FFLAS-FFPACK interface."""
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
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
    rows, columns = dense.shape
    return int(function(float(P), rows, columns, dense, columns, False))


def fflas_row_rank_profile(matrix: np.ndarray) -> tuple[int, np.ndarray]:
    """Return exact earliest independent row indices over F_89."""
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
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
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
            2,  # FfpackTileRecursive
            False,
        )
    )
    profile = np.ctypeslib.as_array(pointer, shape=(rank,)).copy()
    return rank, profile


def determinant_mod(matrix: np.ndarray) -> int:
    """Exact determinant over F_89, independent of the rank-profile call."""
    a = np.asarray(matrix, dtype=np.int64).copy() % P
    rows, columns = a.shape
    if rows != columns:
        raise ValueError("determinant requires a square matrix")
    determinant = 1
    for column in range(columns):
        candidates = np.flatnonzero(a[column:, column])
        if not len(candidates):
            return 0
        pivot_row = column + int(candidates[0])
        if pivot_row != column:
            a[[column, pivot_row]] = a[[pivot_row, column]]
            determinant = -determinant
        pivot = int(a[column, column])
        determinant = determinant * pivot % P
        inverse = pow(pivot, -1, P)
        a[column, column:] = a[column, column:] * inverse % P
        if column + 1 < rows:
            factors = a[column + 1 :, column].copy()
            a[column + 1 :, column:] = (
                a[column + 1 :, column:]
                - factors[:, None] * a[column, column:][None, :]
            ) % P
    return determinant % P


def one_right_null_vector(matrix: np.ndarray) -> tuple[np.ndarray, int]:
    """Return one explicit nonzero vector in the right kernel over F_89."""
    a = np.asarray(matrix, dtype=np.int64).copy() % P
    rows, columns = a.shape
    pivot_columns: list[int] = []
    pivot_row = 0
    for column in range(columns):
        candidates = np.flatnonzero(a[pivot_row:, column])
        if not len(candidates):
            continue
        selected = pivot_row + int(candidates[0])
        a[[pivot_row, selected]] = a[[selected, pivot_row]]
        inverse = pow(int(a[pivot_row, column]), -1, P)
        a[pivot_row] = a[pivot_row] * inverse % P
        factors = a[:, column].copy()
        factors[pivot_row] = 0
        a = (a - factors[:, None] * a[pivot_row][None, :]) % P
        pivot_columns.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    pivot_set = set(pivot_columns)
    free_columns = [column for column in range(columns) if column not in pivot_set]
    if not free_columns:
        raise AssertionError("matrix has no right kernel")
    chosen_free = free_columns[0]
    vector = np.zeros(columns, dtype=np.int64)
    vector[chosen_free] = 1
    for row, column in enumerate(pivot_columns):
        vector[column] = -a[row, chosen_free] % P
    if not np.any(vector) or np.any(np.asarray(matrix, dtype=np.int64) @ vector % P):
        raise AssertionError("failed to construct a right-kernel vector")
    return vector.astype(np.uint8), len(pivot_columns)


def write_self_hashed_json(path: Path, payload: dict) -> None:
    body = dict(payload)
    body.pop("self_sha256", None)
    canonical = json.dumps(body, indent=2, sort_keys=True) + "\n"
    body["self_sha256"] = hashlib.sha256(canonical.encode()).hexdigest()
    path.write_text(json.dumps(body, indent=2, sort_keys=True) + "\n")


def main() -> None:
    if not RELATION.is_file() or not LINEAR_META.is_file():
        raise FileNotFoundError("required sealed input is absent")

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        basis_degrees = frozen["Bdeg"].astype(np.int8)
        assert int(frozen["prime"]) == P
    assert seeds.shape == (690, 14134)
    assert basis_degrees.tolist() == [0] + [1] * 6 + [2] * 21

    q1 = weak_compositions(1, 37)
    q2 = weak_compositions(2, 37)
    variable_of = [monomial.index(1) for monomial in q1]
    assert len(q1) == 37 and len(q2) == 703

    # M2[a,j,u] is the q_u coefficient in row a and b2 column j.
    m2 = np.empty((690, 21, 37), dtype=np.uint8)
    for j in range(21):
        block = seeds[:, int(offsets[7 + j]) : int(offsets[8 + j])]
        for monomial_index, variable in enumerate(variable_of):
            m2[:, j, variable] = block[:, monomial_index]
    flatten = m2.reshape(690, 777)
    column_nnz = np.count_nonzero(flatten, axis=0)
    unit_columns = np.flatnonzero(column_nnz == 1)
    free_columns = np.flatnonzero(column_nnz > 1)
    assert len(unit_columns) == 690 and len(free_columns) == 87
    assert not np.any(column_nnz == 0)
    unit_rows = np.asarray(
        [int(np.flatnonzero(flatten[:, column])[0]) for column in unit_columns],
        dtype=np.int32,
    )
    assert len(np.unique(unit_rows)) == 690
    assert np.array_equal(
        flatten[unit_rows][:, unit_columns], np.eye(690, dtype=np.uint8)
    )
    free_coordinates = [
        {"b2": int(column // 37), "q": int(column % 37)}
        for column in free_columns
    ]
    expected_free = [
        {"b2": b2, "q": q}
        for b2 in range(21)
        for q in range(5 if b2 < 3 else 4)
    ]
    assert free_coordinates == expected_free
    tail = flatten[unit_rows][:, free_columns]

    # beta[a,b,u,v] is the symmetric polarization coefficient multiplying
    # q_u*y_(b,v).  Off-diagonal coefficients are divided equally because
    # 2 is invertible in F_89.
    beta = np.zeros((690, 6, 37, 37), dtype=np.uint8)
    inverse_two = pow(2, -1, P)
    for b in range(6):
        block = seeds[:, int(offsets[1 + b]) : int(offsets[2 + b])]
        for monomial_index, exponent in enumerate(q2):
            variables = [
                variable
                for variable, power in enumerate(exponent)
                for _ in range(power)
            ]
            u, v = variables
            coefficient = block[:, monomial_index]
            if u == v:
                beta[:, b, u, v] = coefficient
                assert np.array_equal(beta[:, b, u, v], coefficient)
            else:
                half = (coefficient.astype(np.uint16) * inverse_two % P).astype(
                    np.uint8
                )
                beta[:, b, u, v] = half
                beta[:, b, v, u] = half
                assert np.array_equal(
                    (beta[:, b, u, v].astype(np.uint16)
                     + beta[:, b, v, u].astype(np.uint16))
                    % P,
                    coefficient,
                )

    # Exact full-column-rank minors at all 37 coordinate points.  These are
    # stored as bounded structural facts, never as a global rank conclusion.
    coordinate_certificates: list[dict] = []
    for q in range(37):
        evaluated = np.concatenate(
            [beta[:, :, q, :].reshape(690, 222), m2[:, :, q]], axis=1
        )
        rank, rows = fflas_row_rank_profile(evaluated)
        assert rank == 243 and len(rows) == 243
        determinant = determinant_mod(evaluated[rows])
        assert determinant != 0
        coordinate_certificates.append(
            {
                "q_coordinate": q,
                "minor_rows": rows.astype(int).tolist(),
                "minor_determinant_mod_89": determinant,
            }
        )

    # Deterministic exact samples away from the coordinate points.  They are
    # explicitly reported as a nonverdict.
    rng = np.random.default_rng(SAMPLE_SEED)
    sampled_ranks: list[int] = []
    sampled_points_sha = hashlib.sha256()
    for _ in range(N_SAMPLES):
        q = rng.integers(0, P, size=37, dtype=np.int64)
        if not np.any(q):
            q[0] = 1
        sampled_points_sha.update(np.ascontiguousarray(q).tobytes())
        polarized_part = np.einsum(
            "abuv,u->abv", beta.astype(np.int64), q, optimize=True
        ) % P
        m2_part = np.einsum(
            "aju,u->aj", m2.astype(np.int64), q, optimize=True
        ) % P
        evaluated = np.concatenate(
            [polarized_part.reshape(690, 222), m2_part], axis=1
        )
        sampled_ranks.append(fflas_rank(evaluated))
    assert sampled_ranks == [243] * N_SAMPLES

    # An explicit generalized zero.  Fix y=e_(b=0,v=0).  Its q-coefficient
    # matrix has only 37 columns, so a nonzero row functional annihilating all
    # of them must exist.  Store one such functional and recheck it exactly.
    fixed_y_coefficients = beta[:, 0, :, 0]  # row x q coefficient
    generalized_zero, fixed_y_rank = one_right_null_vector(
        fixed_y_coefficients.T
    )
    assert np.any(generalized_zero)
    assert not np.any(
        generalized_zero.astype(np.int64) @ fixed_y_coefficients.astype(np.int64)
        % P
    )

    with LINEAR_META.open() as handle:
        linear_metadata = json.load(handle)
    assert linear_metadata["coefficient_matrix_rank"] == 14763
    assert linear_metadata["nullity"] == 10767
    assert linear_metadata["coefficient_matrix_shape"] == [14763, 25530]

    # Exact dimension audit for the nullspace-free mapping-cone formulation.
    sym2 = math.comb(38, 2)  # 703
    sym3 = math.comb(39, 3)  # 9139
    sym4 = math.comb(40, 4)  # 91390
    sym5 = math.comb(41, 5)  # 749398
    assert (sym2, sym3, sym4, sym5) == (703, 9139, 91390, 749398)
    wedge2_v_u = math.comb(37, 2) * 21
    v_k = 37 * 87
    linear_syzygies = wedge2_v_u - v_k
    assert (wedge2_v_u, v_k, linear_syzygies) == (13986, 3219, 10767)
    mapping_cone_source = wedge2_v_u * sym2
    mapping_cone_constraint = v_k * sym2
    degree5_target = 6 * sym5
    mapping_cone_target = mapping_cone_constraint + degree5_target
    assert mapping_cone_source == 9_832_158
    assert mapping_cone_constraint == 2_262_957
    assert degree5_target == 4_496_388
    assert mapping_cone_target == 6_759_345

    # The raw source count L_1 tensor S_2 overcounts its polynomial image.
    # Surjectivity of the sealed degree-one M2-dual map propagates to every
    # higher degree by multiplication.  Hence all degree-three polynomial
    # left syzygies have the following exact dimension, which is smaller than
    # the degree-five B1 target.  This rules out a full degree-five rank
    # certificate, though it does not rule out 222 selected pure-power RHSs.
    degree3_row_polynomials = 690 * sym3
    degree4_m2_target = 21 * sym4
    degree3_polynomial_syzygies = degree3_row_polynomials - degree4_m2_target
    multiplication_relation_floor = (
        linear_syzygies * sym2 - degree3_polynomial_syzygies
    )
    degree5_surjectivity_deficit = degree5_target - degree3_polynomial_syzygies
    mixed_macaulay_target = degree4_m2_target + degree5_target
    assert degree3_row_polynomials == 6_305_910
    assert degree4_m2_target == 1_919_190
    assert degree3_polynomial_syzygies == 4_386_720
    assert multiplication_relation_floor == 3_182_481
    assert degree5_surjectivity_deficit == 109_668
    assert mixed_macaulay_target == 6_415_578

    # Degree floor for the faithful polarized linear over-approximation.  This
    # explains why it is conceptually cleaner but computationally worse than
    # the degree-five contraction map.
    polarized_first_possible = None
    for degree in range(1, 100):
        source = 690 * math.comb(degree - 1 + 36, 36)
        target = 243 * math.comb(degree + 36, 36)
        if source >= target:
            polarized_first_possible = {
                "degree": degree,
                "source_dimension": source,
                "target_dimension": target,
            }
            break
    assert polarized_first_possible is not None
    assert polarized_first_possible["degree"] == 20

    payload = {
        "status": "PASS_EXACT_THEORY_NONVERDICT",
        "verdict": "STAGE_B_UNDECIDED",
        "prime": P,
        "input_hashes": {
            str(RELATION.relative_to(ROOT)): sha256(RELATION),
            str(LINEAR_META.relative_to(ROOT)): sha256(LINEAR_META),
        },
        "m2_systematic": {
            "flattening_shape": list(flatten.shape),
            "rank_certified_by_identity_minor": 690,
            "unit_columns": int(len(unit_columns)),
            "free_columns": int(len(free_columns)),
            "free_tensor_coordinates": free_coordinates,
            "tail_shape": list(tail.shape),
            "tail_nnz": int(np.count_nonzero(tail)),
            "tail_min_row_nnz": int(np.min(np.count_nonzero(tail, axis=1))),
            "tail_max_row_nnz": int(np.max(np.count_nonzero(tail, axis=1))),
            "tail_min_column_nnz": int(np.min(np.count_nonzero(tail, axis=0))),
            "tail_max_column_nnz": int(np.max(np.count_nonzero(tail, axis=0))),
        },
        "faithful_polarization": {
            "matrix_shape": [690, 243],
            "domain_split": {"B1_tensor_Q": 222, "B2": 21},
            "identity": (
                "L(q)(b1 tensor q,b2)=M1(q)b1+M2(q)b2, checked at the "
                "coefficient-tensor level; characteristic 89 makes 1/2 valid"
            ),
            "safe_implication": (
                "If L(q) is injective for every projective q, then Stage B is empty"
            ),
            "converse_warning": (
                "A kernel vector with arbitrary y in B1 tensor Q need not satisfy "
                "y=b1 tensor q and would not be a Stage-B point"
            ),
            "coordinate_certificates": coordinate_certificates,
            "deterministic_samples": {
                "seed": SAMPLE_SEED,
                "points": N_SAMPLES,
                "points_sha256": sampled_points_sha.hexdigest(),
                "ranks": sampled_ranks,
                "scope": "Sampling only; no algebraic-closure or global verdict.",
            },
            "dual_macaulay_first_dimensionally_possible": polarized_first_possible,
        },
        "one_genericity_audit": {
            "applicable": False,
            "reason": (
                "For fixed nonzero y, the map from the 690-dimensional row-dual "
                "space to the 37-dimensional linear-form space has a nonzero "
                "kernel, producing a generalized zero."
            ),
            "fixed_y": {"b1": 0, "q_slot": 0},
            "fixed_y_coefficient_rank": fixed_y_rank,
            "generalized_zero_row_functional": generalized_zero.astype(int).tolist(),
            "generalized_zero_nnz": int(np.count_nonzero(generalized_zero)),
        },
        "full_syzygy_mapping_cone": {
            "sealed_linear_syzygy_map_rank": 14763,
            "linear_syzygy_dimension": linear_syzygies,
            "exact_sequence_dimensions": {
                "wedge2_Qdual_tensor_B2dual": wedge2_v_u,
                "Qdual_tensor_Kdual": v_k,
                "kernel": linear_syzygies,
            },
            "degree5": {
                "mapping_cone_source": mapping_cone_source,
                "mapping_cone_constraint_target": mapping_cone_constraint,
                "module_target": degree5_target,
                "combined_target": mapping_cone_target,
                "degree3_polynomial_syzygy_ceiling": degree3_polynomial_syzygies,
                "multiplication_relation_floor": multiplication_relation_floor,
                "surjectivity_deficit": degree5_surjectivity_deficit,
                "full_surjectivity_possible": False,
            },
            "certificate_options": [
                (
                    "Full degree-five surjectivity and any leading-term cover of "
                    "all degree-five module monomials are impossible by the exact "
                    "109668-dimensional deficit."
                ),
                (
                    "Preimages of the selected 222 vectors q_i^5 e_j could still "
                    "exist inside this proper image; those identities would put "
                    "a fifth power of each coordinate in the module and prove "
                    "Stage-B emptiness."
                ),
            ],
        },
        "targeted_degree5_mixed_macaulay": {
            "map": "S_3^690 -> S_5^6 direct_sum S_4^21 via [M1|M2]",
            "source_dimension": degree3_row_polynomials,
            "target_dimension": mixed_macaulay_target,
            "dimension_deficit": degree5_surjectivity_deficit,
            "pure_rhs": "(q_i^5 e_j,0), for 0<=i<37 and 0<=j<6",
            "logical_scope": (
                "Each exact preimage is a sufficient module-membership identity; "
                "failure to find one is not nonmembership without a dual witness."
            ),
        },
        "theorem_boundary": {
            "proved": [
                "systematic M2 identity minor and 87-coordinate kernel chart",
                "faithful polarization identity and its safe implication",
                "explicit full-rank minors at the 37 coordinate points",
                "explicit generalized zero excluding a 1-genericity shortcut",
                "exact dimensions of a nullspace-free degree-5 mapping-cone test",
            ],
            "not_proved": [
                "injectivity of L(q) at every geometric projective point",
                "unit saturation or irrelevant-power containment",
                "Stage-B emptiness or existence of a true Stage-B point",
            ],
        },
    }
    write_self_hashed_json(HERE / "result.json", payload)
    print("PASS_EXACT_THEORY_NONVERDICT")
    print("coordinate polarized ranks: 37 copies of 243")
    print("deterministic sampled ranks: 64 copies of 243 (sampling only)")


if __name__ == "__main__":
    main()
