#!/usr/bin/env python3
"""Repair and verify the degree-25 multiplier maps at the PC.2 fibre F_89.

The earlier fixed Cramer chart is valid over Q(zeta_11) and at p=419,463,
but its 16-by-16 source minor vanishes modulo 89.  This verifier rebuilds the
exact circuit at p=89, certifies that defect, deterministically selects a
p=89-unit source chart, identifies the resulting strict space with the fixed
DVR monic and Q|K frames, and builds the f6/f10 maps in authoritative Q|K
coordinates.

This repairs only the ambient linear maps.  It does not compute the image of
the nonlinear PC.2 landing scheme or decide any PC.3 support stratum.
"""

from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
WORK = ROOT / "goals_2026-08-01" / "COV_M1_DEG31_35_WORK"
EXACT = ROOT / "certificates" / "degree25_exact"
DVR = ROOT / "certificates" / "degree25_direct_support"

DUAL_PATH = WORK / "dual_hironaka_generators.json"
INVARIANT_PATH = WORK / "invariant_generators.json"
SOURCE_PATH = WORK / "degree_25_fixed_k1_basis.json"
TARGET_PATHS = {
    31: WORK / "degree_31" / "m1_cross_basis_circuits.json",
    35: WORK / "degree_35" / "m1_cross_basis_circuits.json",
}
CROSS_HELPER = WORK / "produce_cross_basis.py"
STRICT_HELPER = EXACT / "common_p25x.py"
DVR_SPECIAL = DVR / "dvr_special_fibre_p89.npz"
CHANGE_OF_BASIS = EXACT / "change_of_basis" / "matrices_multiprime.npz"
PRIOR_METADATA = HERE / "pc3_p25_multiplier_maps.json"
PRIOR_ARTIFACT = HERE / "pc3_p25_multiplier_maps.npz"
OUTPUT = HERE / "verify_pc3_p25_multiplier_p89_result.json"

EXPECTED_HASHES = {
    DUAL_PATH: "b9aa1f8fe852e15b1b786b6a0577f06cf3ce200c5b092bcbd4c444678add874b",
    INVARIANT_PATH: "1912db3e0c30c09d7485804adb03e9aeaed739076e2b87b8a2890007727c6421",
    SOURCE_PATH: "73e6132e19105d4489d70093edf310c766051b90583536ba3b3fa85e223722b1",
    TARGET_PATHS[31]: "8adc3f91db76f97a47d1df6d3f9cccee9e8eef62a825c2dff045ad96db6ff2f6",
    TARGET_PATHS[35]: "f28effc9a4c9e8923980b4726d264672141a030a61a23a416534b426a301775a",
    CROSS_HELPER: "7b99bf7712fdf3dd898ab27ff3cb469c9f5213bdab1c35902813993ce6210f68",
    STRICT_HELPER: "b5d27fe9174e859a88a9b1704963e07a4ff53f96ddd259d83c5a7d148d9588bc",
    DVR_SPECIAL: "02b96da20504b902d3f53906382f3afb6c55e20792c31b8b0b5346957fcfe1b8",
    CHANGE_OF_BASIS: "815666837ff861bb279f37d22d0a1bbe1f8f5745f42be46354ddbef865ac7614",
    PRIOR_METADATA: "6a21bf8a0d11ff5cd8db6878f1f3d43ef62c65b7c32c354697f2487beeaa4905",
    PRIOR_ARTIFACT: "1821aa187af7573833bb132769e262af61858622657f7684116d104466451110",
}

P = 89
ZETA = 78
SECOND_INDEX = 609
SECOND_KEY = (4, 8, 2, 7)
FROZEN_ROWS = tuple(range(16))
FROZEN_COLUMNS = (0, 1, 2, 3, 4, 5, 6, 7, 14, 15, 16, 17, 18, 19, 20, 35)
DIRECTIONS = (
    ((0, 1, 1), 2),
    ((1, 0, 1), 3),
    ((1, 1, 0), 4),
)
TARGET_DIMENSIONS = {31: 198, 35: 361}
MULTIPLIERS = {
    31: (0, (0, 0, 1, 0, 0)),  # installed primary f6
    35: (3, (0, 0, 0, 0, 0)),  # installed secondary f10
}


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 22):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray, dtype=np.uint16) -> str:
    return hashlib.sha256(np.ascontiguousarray(array, dtype=dtype).tobytes()).hexdigest()


def eliminate(matrix: np.ndarray, prime: int = P) -> tuple[np.ndarray, list[int]]:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    target = 0
    pivots: list[int] = []
    for column in range(value.shape[1]):
        choices = np.flatnonzero(value[target:, column])
        if not len(choices):
            continue
        pivot = target + int(choices[0])
        value[[target, pivot]] = value[[pivot, target]]
        value[target] = value[target] * pow(int(value[target, column]), -1, prime) % prime
        factors = value[:, column].copy()
        factors[target] = 0
        rows = np.flatnonzero(factors)
        if len(rows):
            value[rows] = value[rows] - factors[rows, None] * value[target]
            value[rows] %= prime
        pivots.append(column)
        target += 1
        if target == value.shape[0]:
            break
    return value, pivots


def rank_mod(matrix: np.ndarray, prime: int = P) -> int:
    return len(eliminate(matrix, prime)[1])


def inverse_mod(matrix: np.ndarray, prime: int = P) -> np.ndarray:
    value = np.asarray(matrix, dtype=np.int64) % prime
    size = value.shape[0]
    assert value.shape == (size, size)
    augmented = np.hstack([value, np.eye(size, dtype=np.int64)])
    reduced, pivots = eliminate(augmented, prime)
    assert pivots[:size] == list(range(size))
    assert np.array_equal(reduced[:, :size], np.eye(size, dtype=np.int64))
    return reduced[:, size:] % prime


def determinant_mod(matrix: np.ndarray, prime: int = P) -> int:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    assert value.shape[0] == value.shape[1]
    determinant = 1
    for column in range(len(value)):
        choices = np.flatnonzero(value[column:, column])
        if not len(choices):
            return 0
        pivot = column + int(choices[0])
        if pivot != column:
            value[[column, pivot]] = value[[pivot, column]]
            determinant = -determinant
        pivot_value = int(value[column, column])
        determinant = determinant * pivot_value % prime
        inverse = pow(pivot_value, -1, prime)
        for row in range(column + 1, len(value)):
            factor = int(value[row, column]) * inverse % prime
            if factor:
                value[row] = (value[row] - factor * value[column]) % prime
    return determinant % prime


def independent_rows(matrix: np.ndarray, prime: int = P) -> list[int]:
    return eliminate(np.asarray(matrix).T, prime)[1]


def same_column_space(left: np.ndarray, right: np.ndarray, prime: int = P) -> bool:
    left_rank = rank_mod(left, prime)
    right_rank = rank_mod(right, prime)
    return left_rank == right_rank == rank_mod(np.hstack([left, right]), prime)


def fmul(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(
        sum(left[2 * i + k] * right[2 * k + j] for k in range(2)) % 11
        for i in range(2)
        for j in range(2)
    )


def fcanon(matrix: tuple[int, ...]) -> tuple[int, ...]:
    matrix = tuple(entry % 11 for entry in matrix)
    return min(matrix, tuple(-entry % 11 for entry in matrix))


def psl_keys() -> list[tuple[int, ...]]:
    identity = fcanon((1, 0, 0, 1))
    generators = (fcanon((0, 2, 5, 0)), fcanon((1, 2, 0, 1)))
    seen = {identity}
    ordered = [identity]
    stack = [identity]
    while stack:
        current = stack.pop()
        for generator in generators:
            candidate = fcanon(fmul(current, generator))
            if candidate not in seen:
                seen.add(candidate)
                ordered.append(candidate)
                stack.append(candidate)
    assert len(ordered) == 660
    return ordered


def fixed_joint_basis(module) -> tuple[np.ndarray, np.ndarray]:
    assert psl_keys()[SECOND_INDEX] == SECOND_KEY
    identity = np.eye(5, dtype=np.int64) % P
    first = np.asarray(module.A, dtype=np.int64) % P
    second = np.asarray(module.GROUP[SECOND_INDEX], dtype=np.int64) % P
    assert np.array_equal(first @ second % P, second @ first % P)
    assert np.array_equal(second @ second % P, identity)
    spaces = []
    for first_sign, second_sign in ((1, 1), (1, -1), (-1, 1), (-1, -1)):
        equations = np.vstack(
            [first - first_sign * identity, second - second_sign * identity]
        ) % P
        reduced, pivots = eliminate(equations)
        free = [column for column in range(5) if column not in pivots]
        vectors = []
        for column in free:
            vector = np.zeros(5, dtype=np.int64)
            vector[column] = 1
            for row, pivot in enumerate(pivots):
                vector[pivot] = -reduced[row, column] % P
            vectors.append(vector)
        spaces.append(vectors)
    assert [len(space) for space in spaces] == [2, 1, 1, 1]
    basis = np.column_stack([vector for space in spaces for vector in space]) % P
    return basis, inverse_mod(basis)


def fixed_points(count: int = 80) -> np.ndarray:
    state = 20260802003135
    answer = []
    for _ in range(count):
        row = []
        for _ in range(5):
            state = (6364136223846793005 * state + 1442695040888963407) % (1 << 64)
            row.append((state >> 24) % 251)
        answer.append(row)
    return np.asarray(answer, dtype=np.int64)


def jet_grid(basis: np.ndarray) -> np.ndarray:
    points = []
    for direction, _ in DIRECTIONS:
        for parameter in range(24):
            for scalar in range(26):
                coordinates = np.asarray(
                    [1, parameter] + [scalar * entry % P for entry in direction],
                    dtype=np.int64,
                )
                points.append(basis @ coordinates % P)
    return np.asarray(points, dtype=np.int64)


def coefficient_two_weights() -> np.ndarray:
    vandermonde = np.asarray(
        [[pow(sample, exponent, P) for exponent in range(26)] for sample in range(26)],
        dtype=np.int64,
    )
    return inverse_mod(vandermonde)[2]


def rebuild_order2(source_jet: np.ndarray, basis_inverse: np.ndarray) -> np.ndarray:
    values = source_jet.reshape(3, 24, 26, 5, 59)
    weights = coefficient_two_weights()
    blocks = []
    for direction_index, (_, output_component) in enumerate(DIRECTIONS):
        adapted = np.einsum("ab,tsbk->tsak", basis_inverse, values[direction_index]) % P
        coefficient = np.einsum("s,tsak->tak", weights, adapted) % P
        blocks.append(coefficient[:, output_component, :])
    return np.vstack(blocks) % P


def unit_cramer_inclusion(
    order2: np.ndarray,
) -> tuple[np.ndarray, list[int], list[int], int]:
    rows = independent_rows(order2)
    assert len(rows) == 16
    chart = order2[rows]
    _, columns = eliminate(chart)
    assert len(columns) == 16
    minor = chart[:, columns]
    determinant = determinant_mod(minor)
    assert determinant != 0
    pivot_set = set(columns)
    free = [column for column in range(59) if column not in pivot_set]
    inclusion = np.zeros((59, 43), dtype=np.int64)
    inclusion[free, np.arange(43)] = 1
    inclusion[columns] = -inverse_mod(minor) @ chart[:, free] % P
    assert rank_mod(inclusion) == 43
    assert not np.any(order2 @ inclusion % P)
    return inclusion, rows, columns, determinant


def json_polynomial(terms: list[dict]) -> dict[tuple[int, ...], int]:
    return {
        tuple(map(int, term["exponents"])): int(term["coefficient"])
        for term in terms
        if int(term["coefficient"])
    }


def build_result() -> dict:
    for path, expected in EXPECTED_HASHES.items():
        assert sha256_file(path) == expected, path

    cross = load_module("pc3_p89_cross_evaluator", CROSS_HELPER)
    common = load_module("pc3_p89_strict_helper", STRICT_HELPER)
    module = cross.module_at(P, ZETA)

    invariant_packet = json.loads(INVARIANT_PATH.read_text())
    for degree, label in MULTIPLIERS.items():
        installed = json_polynomial(invariant_packet["forms"][str(6 if degree == 31 else 10)])
        exact = {key: int(value) for key, value in cross.invariant_polynomial(label).items()}
        assert installed == exact

    dual_records = json.loads(DUAL_PATH.read_text())["generators"]
    source_records = json.loads(SOURCE_PATH.read_text())["basis"]
    target_packets = {
        degree: json.loads(path.read_text()) for degree, path in TARGET_PATHS.items()
    }

    points = fixed_points() % P
    basis, basis_inverse = fixed_joint_basis(module)
    jets = jet_grid(basis)
    all_points = np.vstack([points, jets])
    evaluator = cross.DualEvaluator(module, all_points, P)
    dual_values = cross.evaluate_fixed_dual_generators(evaluator, dual_records)
    source_all = cross.evaluate_fixed_crosses(
        source_records, dual_values, all_points, P
    )
    source_values = source_all[:400]
    source_jet = source_all[400:]
    assert rank_mod(source_values) == 59

    order2 = rebuild_order2(source_jet, basis_inverse)
    assert order2.shape == (72, 59)
    assert rank_mod(order2) == 16

    frozen_chart = order2[list(FROZEN_ROWS)][:, list(FROZEN_COLUMNS)]
    frozen_row_block = order2[list(FROZEN_ROWS)]
    _, frozen_row_pivots = eliminate(frozen_row_block)
    assert rank_mod(frozen_row_block) == rank_mod(frozen_chart) == 15
    assert determinant_mod(frozen_chart) == 0

    inclusion, unit_rows, unit_columns, unit_determinant = unit_cramer_inclusion(order2)
    unit_values = source_values @ inclusion % P
    assert rank_mod(unit_values) == 43

    seed_records = common.load_seeds()
    seeds = [
        module.ReynoldsSeed(int(record["output"]), tuple(record["exponents"]))
        for record in seed_records
    ]
    _, plus, _ = common.involution_eigenspaces(module, P)
    arrangement = common.arrangement_kernel(module, seeds, plus, P)
    historical_strict, strict_reynolds, historical_order2 = common.strict_from_arrangement(
        module, seeds, arrangement, P
    )
    historical_monic, _ = common.monic_basis_reynolds(strict_reynolds, P)

    with np.load(DVR_SPECIAL, allow_pickle=False) as dvr:
        dvr_basis43 = dvr["basis43"].astype(np.int64) % P
        dvr_arrangement = dvr["ker"].astype(np.int64) % P
        dvr_strict = dvr["strict"].astype(np.int64) % P
    assert np.array_equal(arrangement, dvr_arrangement)
    assert np.array_equal(historical_strict, dvr_strict)
    assert np.array_equal(historical_monic, dvr_basis43)

    reynolds_values = common.batch_seed_evaluations(module, seeds, points, P)
    arrangement_values = reynolds_values @ dvr_arrangement.T % P
    monic_values = reynolds_values @ dvr_basis43.T % P
    assert same_column_space(source_values, arrangement_values)
    assert same_column_space(unit_values, monic_values)

    coordinate_rows = independent_rows(unit_values)
    assert len(coordinate_rows) == 43
    chart_to_monic = inverse_mod(unit_values[coordinate_rows]) @ monic_values[
        coordinate_rows
    ] % P
    assert rank_mod(chart_to_monic) == 43
    assert np.array_equal(unit_values @ chart_to_monic % P, monic_values)

    with np.load(CHANGE_OF_BASIS, allow_pickle=False) as change:
        frame_qk = change["frame_QK_p89"].astype(np.int64) % P
        q_rows = change["Q_rows_p89"].astype(np.int64) % P
        k_rows = change["K_rows_p89"].astype(np.int64) % P
    assert np.array_equal(frame_qk, np.vstack([q_rows, k_rows]))
    assert rank_mod(frame_qk) == 43
    chart_to_qk = chart_to_monic @ frame_qk.T % P
    qk_values = unit_values @ chart_to_qk % P
    assert np.array_equal(qk_values, monic_values @ frame_qk.T % P)
    assert rank_mod(qk_values) == 43

    fixed_dual = dual_values[:, :80]
    degree_results: dict[str, dict] = {}
    for degree, dimension in TARGET_DIMENSIONS.items():
        packet = target_packets[degree]
        assert packet["dimension"] == dimension
        assert np.array_equal(np.asarray(packet["fixed_evaluation_points"]), fixed_points())
        target_values = cross.evaluate_fixed_crosses(
            packet["basis"], fixed_dual, points, P
        )
        target_rows = np.asarray(packet["fixed_maximal_minor_rows"], dtype=np.int64)
        assert len(target_rows) == dimension
        target_minor = target_values[target_rows]
        assert rank_mod(target_values) == rank_mod(target_minor) == dimension

        multiplier_polynomial = cross.invariant_polynomial(MULTIPLIERS[degree])
        multiplier = cross.evaluate_polynomial(multiplier_polynomial, points, P)
        product_unit = (
            unit_values.reshape(80, 5, 43) * multiplier[:, None, None]
        ).reshape(-1, 43) % P
        unit_map = inverse_mod(target_minor) @ product_unit[target_rows] % P
        unit_residual = (target_values @ unit_map - product_unit) % P
        assert rank_mod(unit_map) == 43
        assert not np.any(unit_residual)

        qk_map = unit_map @ chart_to_qk % P
        product_qk = (
            qk_values.reshape(80, 5, 43) * multiplier[:, None, None]
        ).reshape(-1, 43) % P
        qk_residual = (target_values @ qk_map - product_qk) % P
        assert rank_mod(qk_map) == 43
        assert not np.any(qk_residual)

        degree_results[str(degree)] = {
            "authoritative_qk_map_rank": 43,
            "authoritative_qk_map_sha256": sha256_array(qk_map),
            "authoritative_qk_map_shape": [dimension, 43],
            "evaluation_residual_nonzeros": int(np.count_nonzero(qk_residual)),
            "installed_multiplier": "f6" if degree == 31 else "f10",
            "multiplier_values_sha256": sha256_array(multiplier),
            "target_dimension": dimension,
            "target_minor_rank": rank_mod(target_minor),
            "unit_chart_map_sha256": sha256_array(unit_map),
        }

    return {
        "authoritative_frame_bridge": {
            "chart_to_monic_rank": rank_mod(chart_to_monic),
            "chart_to_monic_sha256": sha256_array(chart_to_monic),
            "chart_to_qk_rank": rank_mod(chart_to_qk),
            "chart_to_qk_sha256": sha256_array(chart_to_qk),
            "dvr_basis43_matches_recomputed_monic": True,
            "fixed_cross_arrangement_equals_dvr_arrangement": True,
            "q_dimension": len(q_rows),
            "k_dimension": len(k_rows),
            "qk_frame_rank": rank_mod(frame_qk),
            "qk_frame_sha256": sha256_array(frame_qk, np.uint64),
            "unit_chart_strict_equals_dvr_strict": True,
        },
        "degrees": degree_results,
        "field": {"prime": P, "zeta11": ZETA},
        "fixed_chart_defect": {
            "columns": list(FROZEN_COLUMNS),
            "determinant_mod89": determinant_mod(frozen_chart),
            "rank": rank_mod(frozen_chart),
            "row_block_pivot_columns": frozen_row_pivots,
            "row_block_rank": rank_mod(frozen_row_block),
            "rows": list(FROZEN_ROWS),
        },
        "input_hashes": {
            str(path.relative_to(ROOT)): expected
            for path, expected in EXPECTED_HASHES.items()
        },
        "ok": True,
        "repaired_unit_chart": {
            "columns": unit_columns,
            "determinant_mod89": unit_determinant,
            "free_columns": [column for column in range(59) if column not in unit_columns],
            "inclusion_rank": rank_mod(inclusion),
            "inclusion_sha256": sha256_array(inclusion),
            "order2_rank": rank_mod(order2),
            "order2_residual_nonzeros": int(np.count_nonzero(order2 @ inclusion % P)),
            "rows": unit_rows,
            "selection_rule": (
                "first independent rows from left-to-right RREF of J^T, followed by "
                "first pivot columns from left-to-right RREF of the selected row block"
            ),
        },
        "schema": "verify-pc3-p25-multiplier-p89-v1",
        "status": "PASS_PC3_P25_MULTIPLIER_P89_AMBIENT_REPAIR",
        "theorem_boundary": {
            "does_not_prove": (
                "The nonlinear PC.2 landing scheme has not been decided or substituted "
                "through these maps. No actual degree-31/35 scheme image, factor or "
                "composition incidence saturation, survivor, degree-wide emptiness, "
                "or characteristic-zero point is proved. PC-UNDECIDED remains required."
            ),
            "proves": (
                "At the authoritative PC.2 fibre F_89, the prior frozen Cramer chart "
                "has rank 15 and cannot specialize. A deterministic unit chart gives "
                "the same rank-43 DVR strict space, and multiplication by the installed "
                "f6/f10 invariants yields rank-43 ambient maps of shapes 198x43 and "
                "361x43 in the authoritative Q(37)|K(6) coordinates, with all 400 "
                "evaluation residuals zero."
            ),
        },
    }


def main() -> None:
    result = build_result()
    if OUTPUT.exists():
        with OUTPUT.open("r", encoding="utf-8") as handle:
            assert json.load(handle) == result
    print(json.dumps(result, indent=2, sort_keys=True))
    print("PASS_PC3_P25_MULTIPLIER_P89_AMBIENT_REPAIR")


if __name__ == "__main__":
    main()
