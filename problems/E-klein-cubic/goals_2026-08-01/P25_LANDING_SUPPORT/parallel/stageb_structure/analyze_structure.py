#!/usr/bin/env python3
"""Exact structural audit of the sealed Stage-B relation data.

This script is deliberately not an emptiness solver.  It verifies structural
facts that are useful when choosing a contraction subsystem:

* the systematic 690 + 87 decomposition of the M2 flattening;
* exact ranks and density diagnostics for all graded relation blocks;
* certified coordinate linear components forced by support-deficient syzygy
  packets;
* a support- and coordinate-rank-complete 43-row Stage-B contraction packet.

Every output is written in this directory.  Inputs elsewhere in the repository
are read-only and are bound by SHA-256.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path
from typing import Iterable

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
ROOT = HERE.parents[3]
FM = ROOT / "certificates" / "degree25_finite_module"
RELATION = FM / "relation_matrix.npz"
LINEAR = P25 / "linear_syzygies.npz"
LINEAR_R48 = P25 / "linear_syzygies_r48_reconstructed.npz"
CONTRACTED_48 = P25 / "syzygy_r48_q0_contracted.npz"
CONTRACTED_96 = P25 / "syzygy_r96_q0_contracted.npz"
CONTRACTED_256 = P25 / "syzygy_r256_q0_contracted.npz"
P = 89


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            h.update(chunk)
    return h.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    out: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            out.append((first,) + tail)
    return out


def composition_masks(total: int, parts: int) -> np.ndarray:
    answer = np.empty(len(weak_compositions(total, parts)), dtype=object)
    for index, exponent in enumerate(weak_compositions(total, parts)):
        mask = 0
        for variable, power in enumerate(exponent):
            if power:
                mask |= 1 << variable
        answer[index] = mask
    return answer


def rank_small(matrix: np.ndarray) -> int:
    """Exact rank over F_89 for the small matrices used in cover selection."""
    a = np.asarray(matrix, dtype=np.int64).copy() % P
    if a.size == 0:
        return 0
    rows, columns = a.shape
    row = 0
    for column in range(columns):
        candidates = np.flatnonzero(a[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        a[[row, pivot]] = a[[pivot, row]]
        a[row] = (a[row] * pow(int(a[row, column]), -1, P)) % P
        for other in range(row + 1, rows):
            if a[other, column]:
                a[other] = (a[other] - a[other, column] * a[row]) % P
        row += 1
        if row == rows:
            break
    return row


def rank_fflas(matrix: np.ndarray) -> int:
    """Exact dense modular rank through the installed FFLAS-FFPACK C API."""
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


def multiplication_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: i for i, monomial in enumerate(target)}
    answer = np.empty((37, len(source)), dtype=np.int32)
    for variable in range(37):
        for source_index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, source_index] = target_index[tuple(exponent)]
    return answer


def direct_syzygy_check(syzygy: np.ndarray, m2: np.ndarray) -> bool:
    raw = (
        syzygy.T.astype(np.int64) @ m2.reshape(690, -1).astype(np.int64)
    ) % P
    raw = raw.reshape(37, 21, 37)
    for u in range(37):
        if np.any(raw[u, :, u]):
            return False
        for v in range(u + 1, 37):
            if np.any((raw[u, :, v] + raw[v, :, u]) % P):
                return False
    return True


def contract_p3(
    syzygy: np.ndarray,
    block: np.ndarray,
    product_map: np.ndarray,
    target_size: int,
) -> np.ndarray:
    coefficients = (
        syzygy.T.astype(np.int64) @ block.astype(np.int64)
    ) % P
    output = np.zeros(target_size, dtype=np.int64)
    np.add.at(output, product_map.ravel(), coefficients.ravel())
    return (output % P).astype(np.uint8)


def graph_components(adjacency: np.ndarray) -> int:
    """Components of the bipartite graph represented by a boolean matrix."""
    nleft, nright = adjacency.shape
    seen_left = np.zeros(nleft, dtype=bool)
    seen_right = np.zeros(nright, dtype=bool)
    components = 0
    for start in range(nleft):
        if seen_left[start]:
            continue
        components += 1
        left_stack = [start]
        seen_left[start] = True
        while left_stack:
            left = left_stack.pop()
            rights = np.flatnonzero(adjacency[left] & ~seen_right)
            for right in rights:
                seen_right[right] = True
                new_left = np.flatnonzero(adjacency[:, right] & ~seen_left)
                for item in new_left:
                    seen_left[item] = True
                    left_stack.append(int(item))
    # Isolated right vertices, if any, are separate components.
    components += int(np.count_nonzero(~seen_right))
    return components


def weighted_basis(
    rows: Iterable[int], evaluations: np.ndarray, costs: np.ndarray, q: int
) -> list[int]:
    """Minimum-weight basis by the exact linear-matroid greedy theorem."""
    chosen: list[int] = []
    current_rank = 0
    ordered = sorted(rows, key=lambda row: (int(costs[row]), int(row)))
    for row in ordered:
        new_rank = rank_small(evaluations[chosen + [row], :, q])
        if new_rank > current_rank:
            chosen.append(int(row))
            current_rank = new_rank
        if current_rank == 6:
            return chosen
    raise AssertionError(f"rows do not span the six b1 directions at q{q}")


def packet_obstruction(
    name: str,
    syzygies: np.ndarray,
    p3: np.ndarray,
    p4: np.ndarray,
    masks3: np.ndarray,
    masks4: np.ndarray,
) -> dict:
    support = np.any(syzygies != 0, axis=(0, 1))
    missing = np.flatnonzero(~support).astype(int).tolist()
    result: dict = {
        "name": name,
        "rows": int(len(syzygies)),
        "q_coefficient_support": np.flatnonzero(support).astype(int).tolist(),
        "missing_q_coordinates": missing,
        "syzygy_nnz": int(np.count_nonzero(syzygies)),
    }
    if missing:
        allowed_mask = sum(1 << variable for variable in missing)
        indices3 = np.asarray(
            [i for i, mask in enumerate(masks3) if int(mask) & ~allowed_mask == 0],
            dtype=np.int32,
        )
        indices4 = np.asarray(
            [i for i, mask in enumerate(masks4) if int(mask) & ~allowed_mask == 0],
            dtype=np.int32,
        )
        restricted_p3_nnz = int(np.count_nonzero(p3[:, :, indices3]))
        restricted_p4_nnz = int(np.count_nonzero(p4[:, indices4]))
        assert restricted_p3_nnz == 0
        assert restricted_p4_nnz == 0
        result.update(
            {
                "allowed_projective_coordinate_space": [
                    f"q{variable}" for variable in missing
                ],
                "coordinate_space_projective_dimension": len(missing) - 1,
                "boundary_false_component_dimension": len(missing) + 4,
                "restricted_degree3_monomials": int(len(indices3)),
                "restricted_degree4_monomials": int(len(indices4)),
                "restricted_p3_nnz": restricted_p3_nnz,
                "restricted_p4_nnz": restricted_p4_nnz,
                "saturated_unit_possible": False,
                "reason": (
                    "All contractions vanish identically on the displayed nonzero "
                    "projective q-coordinate space, for every projective b1."
                ),
            }
        )
    else:
        result.update(
            {
                "saturated_unit_possible": True,
                "reason": (
                    "No coordinate subspace is forced solely by missing q support; "
                    "this is necessary, not sufficient, for a unit saturation."
                ),
            }
        )
    return result


def write_self_hashed_json(path: Path, payload: dict) -> None:
    body = dict(payload)
    body.pop("self_sha256", None)
    canonical = json.dumps(body, indent=2, sort_keys=True) + "\n"
    body["self_sha256"] = hashlib.sha256(canonical.encode()).hexdigest()
    path.write_text(json.dumps(body, indent=2, sort_keys=True) + "\n")


def main() -> None:
    required = [
        RELATION,
        LINEAR,
        LINEAR_R48,
        CONTRACTED_48,
        CONTRACTED_96,
        CONTRACTED_256,
    ]
    for path in required:
        if not path.is_file():
            raise FileNotFoundError(path)

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        basis_degrees = frozen["Bdeg"].astype(np.int8)
        assert int(frozen["prime"]) == P
    assert seeds.shape == (690, 14134)
    assert basis_degrees.tolist() == [0] + [1] * 6 + [2] * 21

    q1 = weak_compositions(1, 37)
    q2 = weak_compositions(2, 37)
    q3 = weak_compositions(3, 37)
    q3_index = {monomial: i for i, monomial in enumerate(q3)}
    pure3_indices: list[int] = []
    for variable in range(37):
        exponent = [0] * 37
        exponent[variable] = 3
        pure3_indices.append(q3_index[tuple(exponent)])
    variable_of = [monomial.index(1) for monomial in q1]

    # M2[a,j,v] is the q_v coefficient of the j-th quadratic-basis column.
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
    assert np.all(flatten[unit_rows, unit_columns] == 1)
    assert np.array_equal(
        flatten[unit_rows][:, unit_columns], np.eye(690, dtype=np.uint8)
    )
    tail = flatten[unit_rows][:, free_columns]
    free_tensor_coordinates = [
        {"b2": int(column // 37), "q": int(column % 37)}
        for column in free_columns
    ]
    expected_free = [
        {"b2": b2, "q": q}
        for b2 in range(21)
        for q in range(5 if b2 < 3 else 4)
    ]
    assert free_tensor_coordinates == expected_free

    relation_blocks: list[dict] = []
    for block_index in range(28):
        block = seeds[
            :, int(offsets[block_index]) : int(offsets[block_index + 1])
        ]
        relation_blocks.append(
            {
                "basis_index": block_index,
                "basis_degree": int(basis_degrees[block_index]),
                "shape": list(block.shape),
                "nnz": int(np.count_nonzero(block)),
                "rank": rank_fflas(block),
            }
        )

    with np.load(LINEAR, allow_pickle=False) as frozen:
        all_syzygies = frozen["syzygies"].astype(np.uint8)
        basis_columns = frozen["selected_basis_columns"].astype(np.int32)
        assert int(frozen["prime"]) == P
    assert all_syzygies.shape == (256, 690, 37)

    with np.load(LINEAR_R48, allow_pickle=False) as frozen:
        syzygies48 = frozen["syzygies"].astype(np.uint8)
        old_syzygies96 = frozen["old_syzygies"].astype(np.uint8)
        assert int(frozen["prime"]) == P
    with np.load(CONTRACTED_48, allow_pickle=False) as frozen:
        p3_48 = frozen["p3"].astype(np.uint8)
        p4_48 = frozen["p4"].astype(np.uint8)
    with np.load(CONTRACTED_96, allow_pickle=False) as frozen:
        p3_96 = frozen["p3"].astype(np.uint8)
        p4_96 = frozen["p4"].astype(np.uint8)
        chosen96 = frozen["chosen_syzygies"].astype(np.int32)
    with np.load(CONTRACTED_256, allow_pickle=False) as frozen:
        p3_256 = frozen["p3"].astype(np.uint8)
        p4_256 = frozen["p4"].astype(np.uint8)
        chosen256 = frozen["chosen_syzygies"].astype(np.int32)
        assert int(frozen["prime"]) == P
    assert sorted(chosen256.tolist()) == list(range(256))

    masks3 = composition_masks(3, 37)
    masks4 = composition_masks(4, 37)
    packet_obstructions = [
        packet_obstruction(
            "sealed_r43_from_r48",
            syzygies48[:43],
            p3_48[:43],
            p4_48[:43],
            masks3,
            masks4,
        ),
        packet_obstruction(
            "sealed_r48",
            syzygies48,
            p3_48,
            p4_48,
            masks3,
            masks4,
        ),
        packet_obstruction(
            "sealed_r96",
            old_syzygies96[chosen96],
            p3_96,
            p4_96,
            masks3,
            masks4,
        ),
        packet_obstruction(
            "current_256_sparsity_first43",
            all_syzygies[chosen256[:43]],
            p3_256[:43],
            p4_256[:43],
            masks3,
            masks4,
        ),
        packet_obstruction(
            "sealed_r256",
            all_syzygies[chosen256],
            p3_256,
            p4_256,
            masks3,
            masks4,
        ),
    ]
    packet_p3_arrays = [
        p3_48[:43],
        p3_48,
        p3_96,
        p3_256[:43],
        p3_256,
    ]
    for packet, p3_packet in zip(packet_obstructions, packet_p3_arrays):
        packet["coordinate_point_b1_ranks"] = [
            rank_small(p3_packet[:, :, pure3_indices[q]]) for q in range(37)
        ]

    # Exact ranks of the retained contraction tensors.
    p3_rank_data = {
        "equation_rows_rank": rank_fflas(p3_256.reshape(256, -1)),
        "all_1536_cubic_forms_rank": rank_fflas(p3_256.reshape(1536, 9139)),
        "six_block_ranks": [rank_fflas(p3_256[:, j, :]) for j in range(6)],
    }
    assert p3_rank_data == {
        "equation_rows_rank": 256,
        "all_1536_cubic_forms_rank": 1536,
        "six_block_ranks": [256] * 6,
    }

    evaluations = p3_256[:, :, pure3_indices]  # row x b1 x q-coordinate
    full_coordinate_ranks = [
        rank_small(evaluations[:, :, q]) for q in range(37)
    ]
    assert full_coordinate_ranks == [6] * 37

    row_syzygies = all_syzygies[chosen256]
    row_support = np.any(row_syzygies != 0, axis=1)
    p3_costs = np.count_nonzero(p3_256, axis=(1, 2)).astype(np.int64)
    q4_family = np.flatnonzero(row_support[:, 4]).astype(int).tolist()
    q5_family = np.flatnonzero(row_support[:, 5]).astype(int).tolist()
    assert len(q4_family) == 16 and len(q5_family) == 14
    assert not set(q4_family) & set(q5_family)

    # Exact minimum-weight bases in the two rare coordinate families.
    q4_basis = weighted_basis(q4_family, evaluations, p3_costs, 4)
    q5_basis = weighted_basis(q5_family, evaluations, p3_costs, 5)
    assert len(q4_basis) == len(q5_basis) == 6
    assert rank_small(evaluations[q4_family, :, 6]) == 0
    assert rank_small(evaluations[q5_family, :, 6]) == 3

    # Extend the rank-three q6 space at minimum weight.  The linear-matroid
    # greedy theorem again makes this extension weight-minimal for the fixed
    # q5 base space.
    coordinate_cover = q4_basis + q5_basis
    rank_q6 = rank_small(evaluations[coordinate_cover, :, 6])
    assert rank_q6 == 3
    q6_extension: list[int] = []
    for row in sorted(range(256), key=lambda i: (int(p3_costs[i]), i)):
        if row in coordinate_cover:
            continue
        new_rank = rank_small(
            evaluations[coordinate_cover + q6_extension + [row], :, 6]
        )
        if new_rank > rank_q6:
            q6_extension.append(row)
            rank_q6 = new_rank
        if rank_q6 == 6:
            break
    assert len(q6_extension) == 3
    coordinate_cover += q6_extension
    assert len(set(coordinate_cover)) == 15
    cover_coordinate_ranks = [
        rank_small(evaluations[coordinate_cover, :, q]) for q in range(37)
    ]
    assert cover_coordinate_ranks == [6] * 37

    # Cardinality lower bound: six q4-only rows, six disjoint q5-only rows,
    # and at least three further rows to enlarge rank 3 to rank 6 at q6.
    coordinate_cover_lower_bound = 6 + 6 + (6 - 3)
    assert coordinate_cover_lower_bound == len(coordinate_cover)

    selected43 = list(coordinate_cover)
    for row in sorted(range(256), key=lambda i: (int(p3_costs[i]), i)):
        if row not in selected43:
            selected43.append(row)
        if len(selected43) == 43:
            break
    selected43 = sorted(selected43)
    selected_saved_indices = chosen256[selected43]
    selected_syzygies = all_syzygies[selected_saved_indices]
    selected_p3 = p3_256[selected43]
    assert len(np.unique(selected_saved_indices)) == 43
    assert np.all(np.any(selected_syzygies != 0, axis=(0, 1)))
    selected_coordinate_ranks = [
        rank_small(evaluations[selected43, :, q]) for q in range(37)
    ]
    assert selected_coordinate_ranks == [6] * 37
    assert rank_fflas(selected_p3.reshape(43, -1)) == 43
    assert [rank_fflas(selected_p3[:, j, :]) for j in range(6)] == [43] * 6

    # Independently check the selected C(q)M2(q)=0 identities and recompute
    # every selected P3 coefficient directly from the sealed relation blocks.
    for syzygy in selected_syzygies:
        assert direct_syzygy_check(syzygy, m2)
    map_2_to_3 = multiplication_map(q2, q3)
    rebuilt_p3 = np.empty_like(selected_p3)
    for output_row, syzygy in enumerate(selected_syzygies):
        for j in range(6):
            block = seeds[:, int(offsets[1 + j]) : int(offsets[2 + j])]
            rebuilt_p3[output_row, j] = contract_p3(
                syzygy, block, map_2_to_3, len(q3)
            )
    assert np.array_equal(rebuilt_p3, selected_p3)

    selected_path = HERE / "support_cover_r43_stageB.npz"
    np.savez_compressed(
        selected_path,
        p3=selected_p3,
        syzygies=selected_syzygies,
        contracted_row_indices=np.asarray(selected43, dtype=np.int32),
        saved_syzygy_indices=selected_saved_indices.astype(np.int32),
        selected_basis_columns=basis_columns[selected_saved_indices],
        p3_term_counts=p3_costs[selected43],
        coordinate_cover_rows=np.asarray(coordinate_cover, dtype=np.int32),
        coordinate_cover_lower_bound=np.int32(coordinate_cover_lower_bound),
        prime=np.int32(P),
        relation_matrix_sha256=np.asarray(sha256(RELATION)),
        linear_syzygies_sha256=np.asarray(sha256(LINEAR)),
        source_contracted_sha256=np.asarray(sha256(CONTRACTED_256)),
    )

    # The original b0=0 presentation itself has full column rank at all 37
    # coordinate points; this is an exhaustive exact check of those points,
    # not a statement about the rest of P^36.
    q1_index = {monomial: i for i, monomial in enumerate(q1)}
    q2_index = {monomial: i for i, monomial in enumerate(q2)}
    original_full_ranks: list[int] = []
    original_boundary_ranks: list[int] = []
    for variable in range(37):
        e1 = [0] * 37
        e2 = [0] * 37
        e3 = [0] * 37
        e1[variable] = 1
        e2[variable] = 2
        e3[variable] = 3
        columns = [seeds[:, int(offsets[0]) + q3_index[tuple(e3)]]]
        columns += [
            seeds[:, int(offsets[1 + j]) + q2_index[tuple(e2)]]
            for j in range(6)
        ]
        columns += [
            seeds[:, int(offsets[7 + j]) + q1_index[tuple(e1)]]
            for j in range(21)
        ]
        evaluated = np.stack(columns, axis=1)
        original_full_ranks.append(rank_fflas(evaluated))
        original_boundary_ranks.append(rank_fflas(evaluated[:, 1:]))
    assert original_full_ranks == [28] * 37
    assert original_boundary_ranks == [27] * 37

    naïve_terms = int(np.sum(p3_costs[:43]))
    selected_terms = int(np.sum(p3_costs[selected43]))
    payload = {
        "status": "PASS",
        "scope": (
            "Exact structural audit and improved Stage-B contraction selection; "
            "not an emptiness or nonemptiness verdict."
        ),
        "prime": P,
        "input_hashes": {str(path.relative_to(ROOT)): sha256(path) for path in required},
        "relation_matrix": {
            "shape": [690, 28],
            "storage_shape": list(seeds.shape),
            "graded_block_lengths": np.diff(offsets).astype(int).tolist(),
            "block_statistics": relation_blocks,
        },
        "m2_systematic_decomposition": {
            "flattening_shape": list(flatten.shape),
            "flattening_rank": rank_fflas(flatten),
            "unit_columns": int(len(unit_columns)),
            "free_columns": int(len(free_columns)),
            "free_tensor_coordinates": free_tensor_coordinates,
            "tail_shape": list(tail.shape),
            "tail_nnz": int(np.count_nonzero(tail)),
            "tail_min_row_nnz": int(np.min(np.count_nonzero(tail, axis=1))),
            "tail_max_row_nnz": int(np.max(np.count_nonzero(tail, axis=1))),
            "tail_min_column_nnz": int(np.min(np.count_nonzero(tail, axis=0))),
            "tail_max_column_nnz": int(np.max(np.count_nonzero(tail, axis=0))),
            "tail_bipartite_components": graph_components(tail != 0),
            "interpretation": (
                "After explicit row/column permutations M2 flattening is "
                "[I_690 | A], with the listed 87 tensor coordinates free."
            ),
        },
        "grading_guard": {
            "b1_block_degree": 2,
            "b1_block_monomials_each": 703,
            "b2_block_degree": 1,
            "b2_block_monomials_each": 37,
            "honest_b0_zero_coefficient_flattening_columns": 6 * 703 + 21 * 37,
            "claimed_37_times_27_columns": 37 * 27,
            "conclusion": (
                "The b0=0 incidence is not a 690x999 linear flattening: its six "
                "b1 columns are quadratic in q."
            ),
        },
        "p3_contraction_ranks": p3_rank_data,
        "packet_support_obstructions": packet_obstructions,
        "coordinate_point_checks": {
            "r256_contracted_P3_ranks": full_coordinate_ranks,
            "original_full_28_column_ranks": original_full_ranks,
            "original_b0_zero_27_column_ranks": original_boundary_ranks,
            "scope": "Exhaustive for the 37 coordinate points only.",
        },
        "support_cover_r43": {
            "artifact": selected_path.name,
            "artifact_sha256": sha256(selected_path),
            "contracted_row_indices": selected43,
            "saved_syzygy_indices": selected_saved_indices.astype(int).tolist(),
            "selected_basis_columns": basis_columns[selected_saved_indices]
            .astype(int)
            .tolist(),
            "coordinate_cover_rows": coordinate_cover,
            "q4_minimum_weight_basis_rows": q4_basis,
            "q5_minimum_weight_basis_rows": q5_basis,
            "q6_minimum_weight_extension_rows": q6_extension,
            "coordinate_cover_cardinality": len(coordinate_cover),
            "coordinate_cover_cardinality_lower_bound": coordinate_cover_lower_bound,
            "lower_bound_certificate": {
                "q4_family_size": len(q4_family),
                "q5_family_size": len(q5_family),
                "families_disjoint": True,
                "q4_family_rank_at_q6": rank_small(evaluations[q4_family, :, 6]),
                "q5_family_rank_at_q6": rank_small(evaluations[q5_family, :, 6]),
                "required_q4_rows": 6,
                "required_q5_rows": 6,
                "required_additional_q6_rows": 3,
            },
            "coordinate_ranks": selected_coordinate_ranks,
            "equation_row_rank": rank_fflas(selected_p3.reshape(43, -1)),
            "six_cubic_block_ranks": [
                rank_fflas(selected_p3[:, j, :]) for j in range(6)
            ],
            "p3_terms": selected_terms,
            "current_256_first43_p3_terms": naïve_terms,
            "term_ratio_to_current_first43": selected_terms / naïve_terms,
            "all_selected_syzygies_directly_rechecked": True,
            "all_selected_p3_coefficients_rebuilt": True,
            "logical_scope": (
                "This removes the forced coordinate components and has full b1 "
                "rank at every q-coordinate point. A unit saturation is still "
                "required for Stage-B emptiness."
            ),
        },
    }
    write_self_hashed_json(HERE / "structure_certificate.json", payload)
    print("PASS: exact Stage-B structural audit")
    print(
        f"support-cover rows=43 p3_terms={selected_terms} "
        f"coordinate-cover-minimum={len(coordinate_cover)}"
    )
    print(f"wrote {selected_path.name} and structure_certificate.json")


if __name__ == "__main__":
    main()
