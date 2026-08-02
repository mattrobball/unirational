#!/usr/bin/env python3
"""Independent replay of the fixed PC.3 degree-25 multiplier maps.

The verifier does not import the producer and does not use its stored matrices
as computational inputs.  It rebuilds the finite Weil representations, fixed
dual Reynolds circuits, cross-circuit source and targets, frozen D12 chart,
Cramer kernel, and f6/f10 coordinate maps.  It also bridges the fixed cross
source to the separately installed 189-Reynolds strict model at both primes.
Only after those computations are complete are the producer arrays opened and
compared entry by entry.

The result is an independent two-prime modular replay plus an exact arithmetic
circuit specification.  It is not an entrywise Q(zeta_11) reconstruction and
does not decide the nonlinear PC.2 landing scheme.
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

DUAL_PATH = WORK / "dual_hironaka_generators.json"
SOURCE_PATH = WORK / "degree_25_fixed_k1_basis.json"
TARGET_PATHS = {
    31: WORK / "degree_31" / "m1_cross_basis_circuits.json",
    35: WORK / "degree_35" / "m1_cross_basis_circuits.json",
}
PRODUCER_JSON = HERE / "pc3_p25_multiplier_maps.json"
PRODUCER_NPZ = HERE / "pc3_p25_multiplier_maps.npz"
OUTPUT = HERE / "verify_pc3_p25_multiplier_maps_result.json"

EXPECTED_INPUT_HASHES = {
    DUAL_PATH: "b9aa1f8fe852e15b1b786b6a0577f06cf3ce200c5b092bcbd4c444678add874b",
    ROOT / "goals_2026-08-01" / "COV_M1_DEG31_35_WORK" / "invariant_generators.json":
        "1912db3e0c30c09d7485804adb03e9aeaed739076e2b87b8a2890007727c6421",
    SOURCE_PATH: "73e6132e19105d4489d70093edf310c766051b90583536ba3b3fa85e223722b1",
    TARGET_PATHS[31]: "8adc3f91db76f97a47d1df6d3f9cccee9e8eef62a825c2dff045ad96db6ff2f6",
    TARGET_PATHS[35]: "f28effc9a4c9e8923980b4726d264672141a030a61a23a416534b426a301775a",
}
PRIMES = {419: 13, 463: 15}
TARGET_DIMENSIONS = {31: 198, 35: 361}
MULTIPLIERS = {
    31: (0, (0, 0, 1, 0, 0)),
    35: (3, (0, 0, 0, 0, 0)),
}
SOURCE_MINOR_ROWS = tuple(list(range(49)) + [50, 51, 52, 53, 55, 56, 57, 58, 60, 61])
CHART_ROWS = tuple(range(16))
PIVOT_COLUMNS = (0, 1, 2, 3, 4, 5, 6, 7, 14, 15, 16, 17, 18, 19, 20, 35)
SECOND_INDEX = 609
SECOND_KEY = (4, 8, 2, 7)
DIRECTIONS = (
    ((0, 1, 1), 2),
    ((1, 0, 1), 3),
    ((1, 1, 0), 4),
)


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


# This verifier deliberately uses the already installed canonical-cross
# evaluator, whereas the producer has its own evaluator implementation.
sys.path.insert(0, str(WORK))
cross = load("pc3_verify_cross_basis", WORK / "produce_cross_basis.py")
common = load("pc3_verify_common_p25x", EXACT / "common_p25x.py")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


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


def eliminate(matrix: np.ndarray, prime: int) -> tuple[np.ndarray, list[int]]:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    row = 0
    pivots = []
    for column in range(value.shape[1]):
        pivot = next(
            (candidate for candidate in range(row, value.shape[0])
             if int(value[candidate, column]) % prime),
            None,
        )
        if pivot is None:
            continue
        value[[row, pivot]] = value[[pivot, row]]
        value[row] *= pow(int(value[row, column]), -1, prime)
        value[row] %= prime
        for other in range(value.shape[0]):
            if other != row and value[other, column]:
                value[other] -= value[other, column] * value[row]
                value[other] %= prime
        pivots.append(column)
        row += 1
        if row == value.shape[0]:
            break
    return value, pivots


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    return len(eliminate(matrix, prime)[1])


def inverse_mod(matrix: np.ndarray, prime: int) -> np.ndarray:
    matrix = np.asarray(matrix, dtype=np.int64) % prime
    size = len(matrix)
    augmented = np.hstack([matrix, np.eye(size, dtype=np.int64)])
    reduced, pivots = eliminate(augmented, prime)
    assert pivots[:size] == list(range(size))
    assert np.array_equal(reduced[:, :size], np.eye(size, dtype=np.int64))
    return reduced[:, size:]


def kernel_rows(matrix: np.ndarray, prime: int) -> np.ndarray:
    reduced, pivots = eliminate(matrix, prime)
    free = [column for column in range(matrix.shape[1]) if column not in pivots]
    answer = []
    for column in free:
        vector = np.zeros(matrix.shape[1], dtype=np.int64)
        vector[column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row, column] % prime
        answer.append(vector)
    result = np.asarray(answer, dtype=np.int64)
    assert not np.any(np.asarray(matrix, dtype=np.int64) @ result.T % prime)
    return result


def fmul(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(
        sum(left[2 * i + k] * right[2 * k + j] for k in range(2)) % 11
        for i in range(2) for j in range(2)
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


def frozen_joint_basis(module, prime: int) -> tuple[np.ndarray, np.ndarray]:
    assert psl_keys()[SECOND_INDEX] == SECOND_KEY
    identity = np.eye(5, dtype=np.int64) % prime
    first = np.asarray(module.A, dtype=np.int64) % prime
    second = np.asarray(module.GROUP[SECOND_INDEX], dtype=np.int64) % prime
    assert np.array_equal(first @ second % prime, second @ first % prime)
    assert np.array_equal(second @ second % prime, identity)
    spaces = []
    for first_sign, second_sign in ((1, 1), (1, -1), (-1, 1), (-1, -1)):
        spaces.append(kernel_rows(np.vstack([
            first - first_sign * identity,
            second - second_sign * identity,
        ]) % prime, prime))
    assert [len(space) for space in spaces] == [2, 1, 1, 1]
    basis = np.column_stack([vector for space in spaces for vector in space]) % prime
    return basis, inverse_mod(basis, prime)


def jet_grid(basis: np.ndarray, prime: int) -> np.ndarray:
    points = []
    for direction, _ in DIRECTIONS:
        for parameter in range(24):
            for scalar in range(26):
                coordinates = [1, parameter]
                coordinates.extend(scalar * entry % prime for entry in direction)
                points.append(basis @ np.asarray(coordinates, dtype=np.int64) % prime)
    return np.asarray(points)


def coefficient_two_weights(prime: int) -> np.ndarray:
    vandermonde = np.asarray(
        [[pow(sample, exponent, prime) for exponent in range(26)]
         for sample in range(26)],
        dtype=np.int64,
    )
    return inverse_mod(vandermonde, prime)[2]


def rebuild_order2(
    source_jet: np.ndarray, basis_inverse: np.ndarray, prime: int
) -> np.ndarray:
    values = source_jet.reshape(3, 24, 26, 5, 59)
    weights = coefficient_two_weights(prime)
    blocks = []
    for direction_index, (_, output_component) in enumerate(DIRECTIONS):
        adapted = np.einsum(
            "ab,tsbk->tsak", basis_inverse, values[direction_index]
        ) % prime
        coefficient = np.einsum("s,tsak->tak", weights, adapted) % prime
        blocks.append(coefficient[:, output_component, :])
    return np.vstack(blocks) % prime


def rebuild_inclusion(order2: np.ndarray, prime: int) -> np.ndarray:
    pivot_set = set(PIVOT_COLUMNS)
    free = [column for column in range(59) if column not in pivot_set]
    chart = order2[list(CHART_ROWS)]
    _, actual_pivots = eliminate(chart, prime)
    assert tuple(actual_pivots) == PIVOT_COLUMNS
    result = np.zeros((59, 43), dtype=np.int64)
    result[free, np.arange(43)] = 1
    result[list(PIVOT_COLUMNS)] = (
        -inverse_mod(chart[:, list(PIVOT_COLUMNS)], prime) @ chart[:, free]
    ) % prime
    assert not np.any(order2 @ result % prime)
    return result


def same_column_space(left: np.ndarray, right: np.ndarray, prime: int) -> bool:
    left_rank = rank_mod(left, prime)
    right_rank = rank_mod(right, prime)
    return left_rank == right_rank == rank_mod(np.hstack([left, right]), prime)


def historical_strict_bridge(
    module, source_values: np.ndarray, strict_values: np.ndarray,
    points: np.ndarray, prime: int,
) -> dict:
    seed_data = common.load_seeds()
    seeds = [
        module.ReynoldsSeed(int(record["output"]), tuple(record["exponents"]))
        for record in seed_data
    ]
    _, plus, _ = common.involution_eigenspaces(module, prime)
    arrangement = common.arrangement_kernel(module, seeds, plus, prime)
    strict, strict_reynolds, order2 = common.strict_from_arrangement(
        module, seeds, arrangement, prime
    )
    monic, pivots = common.monic_basis_reynolds(strict_reynolds, prime)
    reynolds_values = common.batch_seed_evaluations(module, seeds, points, prime)
    arrangement_values = reynolds_values @ arrangement.T % prime
    historical_values = reynolds_values @ monic.T % prime
    assert same_column_space(source_values, arrangement_values, prime)
    assert same_column_space(strict_values, historical_values, prime)
    return {
        "arrangement_rank": rank_mod(arrangement_values, prime),
        "fixed_cross_equals_historical_arrangement": True,
        "historical_order2_rank": rank_mod(order2, prime),
        "historical_strict_rank": rank_mod(historical_values, prime),
        "fixed_strict_equals_historical_strict": True,
        "historical_monic_pivots_prefix": list(map(int, pivots[:12])),
        "historical_strict_coordinate_sha256": sha256_array(monic.astype(np.uint64)),
    }


def main() -> None:
    for path, expected in EXPECTED_INPUT_HASHES.items():
        assert sha256_file(path) == expected, path

    dual_records = json.loads(DUAL_PATH.read_text())["generators"]
    source_records = json.loads(SOURCE_PATH.read_text())["basis"]
    target_packets = {
        degree: json.loads(path.read_text()) for degree, path in TARGET_PATHS.items()
    }
    points = fixed_points()
    recomputed: dict[str, np.ndarray] = {
        "fixed_evaluation_points": points.astype(np.uint16),
        "source_minor_rows": np.asarray(SOURCE_MINOR_ROWS, dtype=np.uint16),
        "order2_chart_rows": np.asarray(CHART_ROWS, dtype=np.uint16),
        "order2_pivot_columns": np.asarray(PIVOT_COLUMNS, dtype=np.uint16),
        "order2_free_columns": np.asarray(
            [column for column in range(59) if column not in PIVOT_COLUMNS],
            dtype=np.uint16,
        ),
    }
    prime_results = []
    for prime, zeta in PRIMES.items():
        print(f"verify p={prime}: rebuilding all circuits", flush=True)
        module = cross.module_at(prime, zeta)
        basis, basis_inverse = frozen_joint_basis(module, prime)
        jets = jet_grid(basis, prime)
        all_points = np.vstack([points % prime, jets])
        evaluator = cross.DualEvaluator(module, all_points, prime)
        dual_values = cross.evaluate_fixed_dual_generators(evaluator, dual_records)
        source_all = cross.evaluate_fixed_crosses(
            source_records, dual_values, all_points, prime
        )
        source_values = source_all[: 5 * len(points)]
        source_jet = source_all[5 * len(points):]
        assert rank_mod(source_values, prime) == 59
        assert rank_mod(source_values[list(SOURCE_MINOR_ROWS)], prime) == 59

        order2 = rebuild_order2(source_jet, basis_inverse, prime)
        assert rank_mod(order2, prime) == 16
        inclusion = rebuild_inclusion(order2, prime)
        strict_values = source_values @ inclusion % prime
        assert rank_mod(inclusion, prime) == rank_mod(strict_values, prime) == 43

        recomputed[f"order2_map_p{prime}"] = order2.astype(np.uint16)
        recomputed[f"strict_inclusion_p{prime}"] = inclusion.astype(np.uint16)
        recomputed[f"strict_values_p{prime}"] = strict_values.astype(np.uint16)
        degree_results = {}
        fixed_dual = dual_values[:, : len(points)]
        for degree, dimension in TARGET_DIMENSIONS.items():
            packet = target_packets[degree]
            assert np.array_equal(np.asarray(packet["fixed_evaluation_points"]), points)
            target_values = cross.evaluate_fixed_crosses(
                packet["basis"], fixed_dual, points % prime, prime
            )
            rows = np.asarray(packet["fixed_maximal_minor_rows"], dtype=np.int64)
            assert len(rows) == dimension
            inverse = inverse_mod(target_values[rows], prime)
            multiplier_polynomial = cross.invariant_polynomial(MULTIPLIERS[degree])
            multiplier = cross.evaluate_polynomial(
                multiplier_polynomial, points % prime, prime
            )
            product = (
                strict_values.reshape(len(points), 5, 43)
                * multiplier[:, None, None]
            ).reshape(-1, 43) % prime
            coordinate_map = inverse @ product[rows] % prime
            residual = target_values @ coordinate_map % prime - product
            residual %= prime
            assert not np.any(residual)
            assert rank_mod(coordinate_map, prime) == 43
            recomputed[f"multiplier_values_d{degree}_p{prime}"] = multiplier.astype(np.uint16)
            recomputed[f"strict_multiplier_map_d{degree}_p{prime}"] = coordinate_map.astype(np.uint16)
            degree_results[str(degree)] = {
                "map_rank": 43,
                "map_sha256": sha256_array(coordinate_map.astype(np.uint16)),
                "all_400_evaluation_residual_nonzeros": 0,
            }

        bridge = historical_strict_bridge(
            module, source_values, strict_values, points % prime, prime
        )
        prime_results.append({
            "prime": prime,
            "zeta11": zeta,
            "source_rank": 59,
            "order2_rank": 16,
            "strict_rank": 43,
            "strict_order2_residual_nonzeros": 0,
            "historical_strict_bridge": bridge,
            "degrees": degree_results,
        })

    # The stored artifact is consulted only after every load-bearing object has
    # been rebuilt from the upstream circuit inputs.
    with np.load(PRODUCER_NPZ, allow_pickle=False) as frozen:
        assert set(frozen.files) == set(recomputed)
        for name, expected in recomputed.items():
            actual = frozen[name]
            if not np.array_equal(actual, expected):
                raise AssertionError(f"producer array differs: {name}")

    metadata = json.loads(PRODUCER_JSON.read_text())
    assert metadata["schema"] == "pc3-fixed-p25-strict-multiplier-circuits-v1"
    assert metadata["artifact_sha256"] == sha256_file(PRODUCER_NPZ)
    assert metadata["fixed_source"]["second_involution_group_index"] == SECOND_INDEX
    assert tuple(metadata["fixed_source"]["second_involution_psl_key"]) == SECOND_KEY
    assert tuple(metadata["fixed_source"]["cramer_chart_rows"]) == CHART_ROWS
    assert tuple(metadata["fixed_source"]["cramer_pivot_columns"]) == PIVOT_COLUMNS
    for record in metadata["prime_records"]:
        prime = int(record["prime"])
        assert record["source_rank"] == 59
        assert record["order2_rank"] == record["order2_chart_rank"] == 16
        assert record["strict_inclusion_rank"] == record["strict_evaluation_rank"] == 43
        for degree in (31, 35):
            claim = record["degrees"][str(degree)]
            actual = recomputed[f"strict_multiplier_map_d{degree}_p{prime}"]
            assert claim["map_rank"] == 43
            assert claim["map_sha256"] == sha256_array(actual)
            assert claim["all_400_evaluation_residual_nonzeros"] == 0

    result = {
        "schema": "verify-pc3-fixed-p25-strict-multiplier-circuits-v1",
        "verdict": "PASS",
        "producer_artifact_sha256": sha256_file(PRODUCER_NPZ),
        "producer_metadata_sha256": sha256_file(PRODUCER_JSON),
        "independent_implementation": {
            "producer_imported": False,
            "stored_matrices_used_as_computational_inputs": False,
            "cross_evaluator": str((WORK / "produce_cross_basis.py").relative_to(ROOT)),
            "cross_evaluator_sha256": sha256_file(WORK / "produce_cross_basis.py"),
            "historical_strict_helper": str((EXACT / "common_p25x.py").relative_to(ROOT)),
            "historical_strict_helper_sha256": sha256_file(EXACT / "common_p25x.py"),
        },
        "prime_results": prime_results,
        "scope": (
            "Independent exact finite-field replay at p=419 and p=463 of the fixed "
            "59x43 Cramer inclusion and the induced 198x43 f6 and 361x43 f10 maps. "
            "The fixed cross source agrees with the separately installed Reynolds "
            "arrangement and strict spaces at both fibres."
        ),
        "char0_boundary": (
            "The fixed Reynolds/cross/group/minor formulas are arithmetic circuits over "
            "Q(zeta_11), and good-fibre nonzero minors certify that their exact Cramer "
            "denominators are nonzero. No entrywise characteristic-zero matrices were "
            "expanded or reconstructed. Two finite-field replays alone do not prove an "
            "entrywise lift and do not decide the nonlinear PC.2 landing scheme."
        ),
    }
    OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PC3_P25_MULTIPLIER_MAPS_VERIFIED", flush=True)


if __name__ == "__main__":
    main()
