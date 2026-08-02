#!/usr/bin/env python3
"""Low-memory exact audit of systematic M2 structure and shortcut barriers."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
SYSTEMATIC = HERE.parent / "systematic_module" / "systematic_m2_decomposition.npz"
SYZYGY_META = HERE.parents[1] / "linear_syzygies.json"
OUTPUT = HERE / "structural_audit.json"
P = 89


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def rank_mod(matrix: np.ndarray) -> int:
    a = np.ascontiguousarray(matrix, dtype=np.int64) % P
    rows, columns = a.shape
    pivot_row = 0
    for column in range(columns):
        candidates = np.flatnonzero(a[pivot_row:, column])
        if len(candidates) == 0:
            continue
        selected = pivot_row + int(candidates[0])
        if selected != pivot_row:
            a[[pivot_row, selected]] = a[[selected, pivot_row]]
        a[pivot_row] = a[pivot_row] * pow(int(a[pivot_row, column]), -1, P) % P
        for row in range(rows):
            if row != pivot_row and a[row, column]:
                a[row] = (a[row] - int(a[row, column]) * a[pivot_row]) % P
        pivot_row += 1
        if pivot_row == rows:
            break
    return pivot_row


def determinant_mod(matrix: np.ndarray) -> int:
    a = np.ascontiguousarray(matrix, dtype=np.int64) % P
    n = a.shape[0]
    if a.shape != (n, n):
        raise AssertionError("determinant needs square matrix")
    value = 1
    for column in range(n):
        candidates = np.flatnonzero(a[column:, column])
        if len(candidates) == 0:
            return 0
        selected = column + int(candidates[0])
        if selected != column:
            a[[column, selected]] = a[[selected, column]]
            value = -value
        pivot = int(a[column, column])
        value = value * pivot % P
        inverse = pow(pivot, -1, P)
        a[column] = a[column] * inverse % P
        for row in range(column + 1, n):
            if a[row, column]:
                a[row] = (a[row] - int(a[row, column]) * a[column]) % P
    return value % P


def main() -> None:
    if sha256(RELATION) != "6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb":
        raise AssertionError("sealed relation hash mismatch")
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("prime mismatch")
    q1 = weak_compositions(1, 37)
    variable_of = [monomial.index(1) for monomial in q1]
    m2 = np.empty((690, 21, 37), dtype=np.uint8)
    for component in range(21):
        block = seeds[:, int(offsets[7 + component]) : int(offsets[8 + component])]
        for monomial_index, variable in enumerate(variable_of):
            m2[:, component, variable] = block[:, monomial_index]
    flatten = m2.reshape(690, 777)
    nnz = np.count_nonzero(flatten, axis=0)
    unit_columns = np.flatnonzero(nnz == 1).astype(np.int32)
    free_columns = np.flatnonzero(nnz > 1).astype(np.int32)
    unit_rows = np.asarray(
        [int(np.flatnonzero(flatten[:, column])[0]) for column in unit_columns],
        dtype=np.int32,
    )
    if len(unit_columns) != 690 or len(free_columns) != 87:
        raise AssertionError("systematic dimensions mismatch")
    identity = flatten[unit_rows][:, unit_columns]
    if not np.array_equal(identity, np.eye(690, dtype=np.uint8)):
        raise AssertionError("systematic identity minor failed")
    tail = flatten[unit_rows][:, free_columns]
    with np.load(SYSTEMATIC, allow_pickle=False) as frozen:
        for key, expected in {
            "unit_columns": unit_columns,
            "free_columns": free_columns,
            "unit_rows": unit_rows,
            "tail": tail,
        }.items():
            if not np.array_equal(frozen[key], expected):
                raise AssertionError(f"systematic packet mismatch: {key}")

    tail_rank = rank_mod(tail)
    adjacency = np.zeros((21, 21), dtype=np.int32)
    for systematic_row, pivot_column in enumerate(unit_columns):
        pivot_component = int(pivot_column) // 37
        for tail_column_index in np.flatnonzero(tail[systematic_row]):
            free_component = int(free_columns[int(tail_column_index)]) // 37
            adjacency[pivot_component, free_component] += 1
    coordinate_support_complete = bool(np.all(adjacency > 0))

    unit_row_of = {int(column): int(row) for column, row in zip(unit_columns, unit_rows)}
    minor_values = []
    identity21 = np.eye(21, dtype=np.uint8)
    for variable in range(5, 37):
        rows = np.asarray(
            [unit_row_of[component * 37 + variable] for component in range(21)],
            dtype=np.int32,
        )
        if not np.array_equal(m2[rows, :, variable], identity21):
            raise AssertionError(f"coordinate {variable} pivot block is not identity")
        direction = m2[rows, :, 0]
        at_zero = determinant_mod(identity21)
        at_one = determinant_mod((identity21.astype(np.int16) + direction) % P)
        if at_zero != 1 or at_one == at_zero:
            raise AssertionError(
                f"expected nonconstant canonical minor witness failed at q{variable}"
            )
        minor_values.append({"pivot_q": variable, "det_at_t0": at_zero, "det_at_t1": at_one})

    syzygy_meta = json.loads(SYZYGY_META.read_text())
    if syzygy_meta["coefficient_matrix_rank"] != 14763:
        raise AssertionError("degree-two multiplication rank metadata mismatch")
    free_by_component = [int(np.count_nonzero(free_columns // 37 == j)) for j in range(21)]
    free_free_quadrics = sum(count * (count + 1) // 2 for count in free_by_component)
    first_pairs = sum((37 - count) * (36 - count) // 2 for count in free_by_component)
    if free_by_component != [5, 5, 5, *([4] * 18)]:
        raise AssertionError("unexpected free-coordinate distribution")
    if free_free_quadrics != 225 or first_pairs != 10992:
        raise AssertionError("first-layer arithmetic mismatch")
    if first_pairs - free_free_quadrics != 10767:
        raise AssertionError("linear-syzygy arithmetic mismatch")

    payload = {
        "status": "PASS_EXACT_LOW_MEMORY_STRUCTURAL_AUDIT",
        "prime": P,
        "source": {"file": str(RELATION), "sha256": sha256(RELATION)},
        "systematic": {
            "flattening_shape": [690, 777],
            "identity_columns": 690,
            "free_columns": 87,
            "free_by_b2_component": free_by_component,
            "tail_rank": tail_rank,
            "tail_nnz": int(np.count_nonzero(tail)),
            "component_coupling_graph_complete": coordinate_support_complete,
            "component_coupling_min_terms": int(adjacency.min()),
            "component_coupling_max_terms": int(adjacency.max()),
        },
        "m2_cokernel": {
            "presentation": "S(-1)^690 -> S^21",
            "hilbert_function": [21, 87, 0],
            "vanishes_in_degrees_at_least": 2,
            "degree_two_target": 14763,
            "degree_two_rank": 14763,
            "regularity": 1,
            "first_same_component_pairs": first_pairs,
            "free_free_quadrics": free_free_quadrics,
            "linear_syzygies": first_pairs - free_free_quadrics,
            "rank_source": {
                "file": str(SYZYGY_META),
                "sha256": sha256(SYZYGY_META),
                "coefficient_matrix_sha256": syzygy_meta["coefficient_matrix_sha256"],
            },
        },
        "canonical_coordinate_minor_obstruction": {
            "variables": list(range(5, 37)),
            "direction": "q0",
            "minor": "det(q_i I_21 + q0 A_i)",
            "evaluations": minor_values,
            "conclusion": (
                "Every canonical systematic 21x21 pivot minor is nonconstant "
                "on D(q_i), hence has a zero over the algebraic closure. It "
                "cannot by itself provide a polynomial left inverse on that chart."
            ),
        },
        "complex_audit": {
            "steiner_exact_on_projective_space": True,
            "koszul_regular_sequence": False,
            "eagon_northcott_grade_hypothesis": False,
            "expected_maximal_minor_grade": 670,
            "ambient_ring_dimension": 37,
            "meaning": (
                "The M2 transpose is an exact Steiner-type surjection after "
                "sheafification, but standard Buchsbaum-Rim/Eagon-Northcott "
                "exactness cannot be invoked because expected grade 670 is "
                "impossible in 37 variables. The later M1/M0 compatibility "
                "maps remain genuine extra data."
            ),
        },
        "symmetry_scope": (
            "The exact tail support couples every ordered pair of the 21 b2 "
            "coordinate components, ruling out a support-disjoint coordinate "
            "block decomposition in the sealed bases. This does not rule out "
            "an undiscovered non-monomial change of bases. No q-space action "
            "or chart-transitive tensor symmetry is asserted."
        ),
        "verdict": "NONVERDICT_FOR_STAGE_B_STAGE_C_AND_P25",
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()

