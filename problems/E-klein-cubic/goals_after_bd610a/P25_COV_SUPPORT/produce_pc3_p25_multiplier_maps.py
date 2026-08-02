#!/usr/bin/env python3
"""Produce fixed modular PC.3 maps from the strict degree-25 circuit.

The source is the fixed 59-element characteristic-zero cross-circuit basis of
K1_25.  We freeze the second D12 involution as group element 609, equivalently
the PSL_2(F_11) key (4,8,2,7), and freeze a 16 by 16 Cramer chart for the
common-line order-two map.  Its free-coordinate kernel gives a 59 by 43
inclusion.  Multiplication by f6 and f10 is then expressed in the installed
fixed K1_31 and K1_35 bases.

This producer materializes reductions at p=419 and p=463.  The same formulas
define arithmetic circuits over Q(zeta_11), but this script does not expand
their characteristic-zero entries.  In particular, two matching rank/minor
specializations are not relabelled as an entrywise characteristic-zero
matrix reconstruction.
"""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
WORK = ROOT / "goals_2026-08-01" / "COV_M1_DEG31_35_WORK"
RECONSTRUCTOR = ROOT / "tmp" / "degree13_opt" / "reconstruct_large_prime.py"

DUAL_PATH = WORK / "dual_hironaka_generators.json"
INVARIANT_PATH = WORK / "invariant_generators.json"
SOURCE_PATH = WORK / "degree_25_fixed_k1_basis.json"
TARGET_PATHS = {
    31: WORK / "degree_31" / "m1_cross_basis_circuits.json",
    35: WORK / "degree_35" / "m1_cross_basis_circuits.json",
}
EXISTING_EMBEDDINGS = {
    31: WORK / "degree_31" / "p25_multiplier_embedding_p463.npz",
    35: WORK / "degree_35" / "p25_multiplier_embedding_p463.npz",
}

OUTPUT_NPZ = HERE / "pc3_p25_multiplier_maps.npz"
OUTPUT_JSON = HERE / "pc3_p25_multiplier_maps.json"

PRIMES = {419: 13, 463: 15}
TARGET_DIMENSIONS = {31: 198, 35: 361}
MULTIPLIER_DEGREES = {31: 6, 35: 10}
EXPECTED_HASHES = {
    DUAL_PATH: "b9aa1f8fe852e15b1b786b6a0577f06cf3ce200c5b092bcbd4c444678add874b",
    INVARIANT_PATH: "1912db3e0c30c09d7485804adb03e9aeaed739076e2b87b8a2890007727c6421",
    SOURCE_PATH: "73e6132e19105d4489d70093edf310c766051b90583536ba3b3fa85e223722b1",
    TARGET_PATHS[31]: "8adc3f91db76f97a47d1df6d3f9cccee9e8eef62a825c2dff045ad96db6ff2f6",
    TARGET_PATHS[35]: "f28effc9a4c9e8923980b4726d264672141a030a61a23a416534b426a301775a",
}

# The common helper's former ``min(bytes(matrix mod p))`` choice is not an
# exact choice: it selects group index 609 at 419/463 but index 189 at 727.
# The exact PSL key below is obtained by the same A,B word enumeration as the
# installed modular representation, so it is independent of the residue size.
SECOND_INVOLUTION_INDEX = 609
SECOND_INVOLUTION_PSL_KEY = (4, 8, 2, 7)
ORDER2_CHART_ROWS = tuple(range(16))
ORDER2_PIVOT_COLUMNS = (0, 1, 2, 3, 4, 5, 6, 7, 14, 15, 16, 17, 18, 19, 20, 35)
SOURCE_MINOR_ROWS = tuple(list(range(49)) + [50, 51, 52, 53, 55, 56, 57, 58, 60, 61])
ORDER2_DIRECTIONS = (
    ((0, 1, 1), 2),
    ((1, 0, 1), 3),
    ((1, 1, 0), 4),
)

PRIMARY_DEGREES = (3, 5, 6, 8, 11)
SECONDARY_FACTORS = (
    (),
    (7,),
    (9,),
    (10,),
    (12,),
    (14,),
    (7, 7),
    (7, 9),
    (9, 9),
    (9, 10),
    (7, 7, 7),
    (9, 9, 10),
)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def load_module(prime: int, zeta: int):
    wrapper = load(f"pc3_p25_reconstructor_{prime}", RECONSTRUCTOR)
    return wrapper.load_module(prime, zeta)


def fixed_points(count: int = 80) -> np.ndarray:
    state = 20260802003135
    answer = []
    for _ in range(count):
        point = []
        for _ in range(5):
            state = (6364136223846793005 * state + 1442695040888963407) % (1 << 64)
            point.append((state >> 24) % 251)
        answer.append(point)
    return np.asarray(answer, dtype=np.int64)


def rref(matrix: np.ndarray, prime: int) -> tuple[np.ndarray, list[int]]:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    target = 0
    pivots: list[int] = []
    for column in range(value.shape[1]):
        choices = np.flatnonzero(value[target:, column])
        if not len(choices):
            continue
        pivot = target + int(choices[0])
        value[[target, pivot]] = value[[pivot, target]]
        value[target] = (
            value[target] * pow(int(value[target, column]), -1, prime)
        ) % prime
        factors = value[:, column].copy()
        factors[target] = 0
        rows = np.flatnonzero(factors)
        if len(rows):
            value[rows] = (
                value[rows] - factors[rows, None] * value[target][None, :]
            ) % prime
        pivots.append(column)
        target += 1
        if target == value.shape[0]:
            break
    return value, pivots


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    return len(rref(matrix, prime)[1])


def inverse_mod(matrix: np.ndarray, prime: int) -> np.ndarray:
    matrix = np.asarray(matrix, dtype=np.int64) % prime
    size = matrix.shape[0]
    assert matrix.shape == (size, size)
    augmented = np.concatenate([matrix, np.eye(size, dtype=np.int64)], axis=1)
    reduced, pivots = rref(augmented, prime)
    assert pivots[:size] == list(range(size))
    assert np.array_equal(reduced[:, :size] % prime, np.eye(size, dtype=np.int64))
    return reduced[:, size:] % prime


def nullspace_rows(matrix: np.ndarray, prime: int) -> np.ndarray:
    reduced, pivots = rref(matrix, prime)
    free = [column for column in range(matrix.shape[1]) if column not in pivots]
    answer = np.zeros((len(free), matrix.shape[1]), dtype=np.int64)
    for index, column in enumerate(free):
        answer[index, column] = 1
        for row, pivot in enumerate(pivots):
            answer[index, pivot] = -reduced[row, column] % prime
    assert not np.any(np.asarray(matrix, dtype=np.int64) @ answer.T % prime)
    return answer


def independent_rows(matrix: np.ndarray, prime: int) -> tuple[int, ...]:
    return tuple(rref(np.asarray(matrix).T, prime)[1])


def fmul(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(
        sum(left[2 * i + k] * right[2 * k + j] for k in range(2)) % 11
        for i in range(2) for j in range(2)
    )


def fcanon(matrix: tuple[int, ...]) -> tuple[int, ...]:
    matrix = tuple(value % 11 for value in matrix)
    negative = tuple(-value % 11 for value in matrix)
    return min(matrix, negative)


def exact_psl_enumeration() -> list[tuple[int, ...]]:
    identity = fcanon((1, 0, 0, 1))
    generators = (fcanon((0, 2, 5, 0)), fcanon((1, 2, 0, 1)))
    seen = {identity: identity}
    stack = [identity]
    while stack:
        current = stack.pop()
        for generator in generators:
            candidate = fcanon(fmul(current, generator))
            if candidate not in seen:
                seen[candidate] = candidate
                stack.append(candidate)
    assert len(seen) == 660
    return list(seen)


def joint_basis(module, prime: int) -> tuple[np.ndarray, np.ndarray, list[int]]:
    identity = np.eye(5, dtype=np.int64) % prime
    first = np.asarray(module.A, dtype=np.int64) % prime
    second = np.asarray(module.GROUP[SECOND_INVOLUTION_INDEX], dtype=np.int64) % prime
    assert exact_psl_enumeration()[SECOND_INVOLUTION_INDEX] == SECOND_INVOLUTION_PSL_KEY
    assert np.array_equal(second @ second % prime, identity)
    assert np.array_equal(first @ second % prime, second @ first % prime)
    candidates = [
        index for index, matrix in enumerate(module.GROUP)
        if not np.array_equal(matrix % prime, identity)
        and not np.array_equal(matrix % prime, first)
        and np.array_equal(matrix @ matrix % prime, identity)
        and np.array_equal(matrix @ first % prime, first @ matrix % prime)
    ]
    assert candidates == [108, 109, 188, 189, 608, 609]

    spaces = []
    for first_sign, second_sign in ((1, 1), (1, -1), (-1, 1), (-1, -1)):
        equations = np.vstack(
            [first - first_sign * identity, second - second_sign * identity]
        ) % prime
        spaces.append(nullspace_rows(equations, prime))
    assert [len(space) for space in spaces] == [2, 1, 1, 1]
    basis = np.column_stack([row for space in spaces for row in space]) % prime
    return basis, inverse_mod(basis, prime), candidates


def coefficient_weights(degree: int, coefficient: int, prime: int) -> np.ndarray:
    vandermonde = np.asarray(
        [[pow(value, exponent, prime) for exponent in range(degree + 1)]
         for value in range(degree + 1)],
        dtype=np.int64,
    )
    return inverse_mod(vandermonde, prime)[coefficient]


def order2_points(basis: np.ndarray, prime: int) -> np.ndarray:
    points = []
    for direction, _ in ORDER2_DIRECTIONS:
        for parameter in range(24):
            for scalar in range(26):
                coordinates = np.asarray(
                    [1, parameter] + [scalar * entry % prime for entry in direction],
                    dtype=np.int64,
                )
                points.append(basis @ coordinates % prime)
    return np.asarray(points, dtype=np.int64)


def evaluate_dual_generators(
    module, records: list[dict], points: np.ndarray, prime: int
) -> np.ndarray:
    """Evaluate the fixed dual Reynolds circuits, memory-bounded by uint16 powers."""

    group = np.asarray(module.GROUP, dtype=np.int64) % prime
    transformed = (np.einsum("gij,pj->pgi", group, points) % prime).astype(np.uint16)
    needed = {
        (coordinate, int(exponent))
        for record in records
        for coordinate, exponent in enumerate(record["reynolds_exponents"])
        if exponent
    }
    powers: dict[tuple[int, int], np.ndarray] = {}
    for coordinate in sorted({coordinate for coordinate, _ in needed}):
        current = np.ones(transformed.shape[:2], dtype=np.uint16)
        maximum = max(exponent for c, exponent in needed if c == coordinate)
        for exponent in range(1, maximum + 1):
            current = (
                current.astype(np.int64) * transformed[:, :, coordinate].astype(np.int64)
                % prime
            ).astype(np.uint16)
            if (coordinate, exponent) in needed:
                powers[(coordinate, exponent)] = current.copy()

    assert 660 * (prime - 1) ** 2 < 2**53
    values = []
    for record in records:
        monomial = np.ones(transformed.shape[:2], dtype=np.int64)
        for coordinate, exponent in enumerate(record["reynolds_exponents"]):
            if exponent:
                monomial = (
                    monomial * powers[(coordinate, int(exponent))].astype(np.int64)
                ) % prime
        output = int(record["reynolds_output"])
        evaluated = np.remainder(
            monomial.astype(np.float64)
            @ group[:, output, :].astype(np.float64),
            float(prime),
        ).astype(np.int64)
        values.append(evaluated)
    return np.asarray(values, dtype=np.int64)


def evaluate_invariant_forms(
    form_records: dict[str, list[dict]], points: np.ndarray, prime: int
) -> dict[int, np.ndarray]:
    powers: dict[tuple[int, int], np.ndarray] = {}
    needed = {
        (coordinate, int(exponent))
        for terms in form_records.values() for term in terms
        for coordinate, exponent in enumerate(term["exponents"])
        if exponent
    }
    for coordinate, exponent in needed:
        powers[(coordinate, exponent)] = np.asarray(
            [pow(int(value), exponent, prime) for value in points[:, coordinate]],
            dtype=np.int64,
        )
    answer = {}
    for degree_text, terms in form_records.items():
        value = np.zeros(len(points), dtype=np.int64)
        for term in terms:
            monomial = np.full(len(points), int(term["coefficient"]) % prime, dtype=np.int64)
            for coordinate, exponent in enumerate(term["exponents"]):
                if exponent:
                    monomial = monomial * powers[(coordinate, int(exponent))] % prime
            value = (value + monomial) % prime
        answer[int(degree_text)] = value
    return answer


def label_values(label_record: dict, forms: dict[int, np.ndarray], prime: int) -> np.ndarray:
    value = np.ones_like(next(iter(forms.values())), dtype=np.int64)
    secondary = int(label_record["secondary_index"])
    for degree in SECONDARY_FACTORS[secondary]:
        value = value * forms[degree] % prime
    for degree, exponent in zip(PRIMARY_DEGREES, label_record["primary_exponents"]):
        if exponent:
            value = value * np.asarray(
                [pow(int(item), int(exponent), prime) for item in forms[degree]],
                dtype=np.int64,
            ) % prime
    return value


def determinant4(values: np.ndarray, prime: int) -> np.ndarray:
    answer = np.zeros(len(values), dtype=np.int64)
    for permutation in itertools.permutations(range(4)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(4) for j in range(i + 1, 4)
        )
        term = np.ones(len(values), dtype=np.int64)
        for row, column in enumerate(permutation):
            term = term * values[:, row, column] % prime
        answer = answer - term if inversions % 2 else answer + term
    return answer % prime


def cross4(dual_values: np.ndarray, indices: list[int], prime: int) -> np.ndarray:
    rows = dual_values[indices].transpose(1, 0, 2)
    answer = np.empty((rows.shape[0], 5), dtype=np.int64)
    for omitted in range(5):
        columns = [column for column in range(5) if column != omitted]
        minor = determinant4(rows[:, :, columns], prime)
        answer[:, omitted] = minor if omitted % 2 == 0 else -minor
    return answer % prime


def evaluate_cross_basis(
    records: list[dict], dual_values: np.ndarray,
    forms: dict[int, np.ndarray], prime: int,
) -> np.ndarray:
    scalar_cache: dict[tuple[int, tuple[int, ...]], np.ndarray] = {}
    columns = []
    for record in records:
        label = record["multiplier"]
        key = (
            int(label["secondary_index"]),
            tuple(map(int, label["primary_exponents"])),
        )
        if key not in scalar_cache:
            scalar_cache[key] = label_values(label, forms, prime)
        vector = cross4(
            dual_values, list(map(int, record["dual_generator_indices"])), prime
        )
        columns.append(vector * scalar_cache[key][:, None] % prime)
    cube = np.asarray(columns, dtype=np.int64).transpose(1, 2, 0)
    return cube.reshape(-1, len(records))


def order2_map(
    source_values: np.ndarray, basis_inverse: np.ndarray, prime: int
) -> np.ndarray:
    cube = source_values.reshape(3, 24, 26, 5, 59)
    weights = coefficient_weights(25, 2, prime)
    components = []
    for component, (_, target_component) in enumerate(ORDER2_DIRECTIONS):
        adapted = np.einsum(
            "ab,tsbk->tsak", basis_inverse, cube[component]
        ) % prime
        coefficient = np.einsum("s,tsak->tak", weights, adapted) % prime
        components.append(coefficient[:, target_component, :])
    return np.vstack(components) % prime


def cramer_inclusion(order2: np.ndarray, prime: int) -> np.ndarray:
    rows = np.asarray(ORDER2_CHART_ROWS, dtype=np.int64)
    pivots = np.asarray(ORDER2_PIVOT_COLUMNS, dtype=np.int64)
    pivot_set = set(ORDER2_PIVOT_COLUMNS)
    free = np.asarray([column for column in range(59) if column not in pivot_set])
    chart = order2[rows]
    pivot_inverse = inverse_mod(chart[:, pivots], prime)
    answer = np.zeros((59, 43), dtype=np.int64)
    answer[free, np.arange(43)] = 1
    answer[pivots] = -pivot_inverse @ chart[:, free] % prime
    assert not np.any(order2 @ answer % prime)
    return answer % prime


def main() -> None:
    for path, expected in EXPECTED_HASHES.items():
        actual = sha256_file(path)
        if actual != expected:
            raise AssertionError(f"input hash changed: {path}: {actual}")

    dual_records = json.loads(DUAL_PATH.read_text())["generators"]
    source_records = json.loads(SOURCE_PATH.read_text())["basis"]
    invariant_records = json.loads(INVARIANT_PATH.read_text())["forms"]
    targets = {
        degree: json.loads(path.read_text()) for degree, path in TARGET_PATHS.items()
    }
    assert len(dual_records) == 59
    assert len(source_records) == 59
    assert {degree: data["dimension"] for degree, data in targets.items()} == TARGET_DIMENSIONS

    evaluation_points = fixed_points()
    for degree, data in targets.items():
        assert np.array_equal(
            np.asarray(data["fixed_evaluation_points"], dtype=np.int64), evaluation_points
        ), degree

    arrays: dict[str, np.ndarray] = {
        "fixed_evaluation_points": evaluation_points.astype(np.uint16),
        "source_minor_rows": np.asarray(SOURCE_MINOR_ROWS, dtype=np.uint16),
        "order2_chart_rows": np.asarray(ORDER2_CHART_ROWS, dtype=np.uint16),
        "order2_pivot_columns": np.asarray(ORDER2_PIVOT_COLUMNS, dtype=np.uint16),
        "order2_free_columns": np.asarray(
            [column for column in range(59) if column not in ORDER2_PIVOT_COLUMNS],
            dtype=np.uint16,
        ),
    }
    records = []
    selected_source_profile = None
    for prime, zeta in PRIMES.items():
        print(f"p={prime}: reconstructing fixed source and targets", flush=True)
        module = load_module(prime, zeta)
        basis, basis_inverse, candidate_indices = joint_basis(module, prime)
        jet_points = order2_points(basis, prime)
        all_points = np.vstack([evaluation_points % prime, jet_points])
        dual_values = evaluate_dual_generators(module, dual_records, all_points, prime)
        form_values = evaluate_invariant_forms(invariant_records, all_points, prime)

        source_all = evaluate_cross_basis(source_records, dual_values, form_values, prime)
        source_fixed = source_all[: 5 * len(evaluation_points)]
        source_jet = source_all[5 * len(evaluation_points):]
        profile = independent_rows(source_fixed, prime)
        assert len(profile) == 59
        if selected_source_profile is None:
            selected_source_profile = profile
            assert profile == SOURCE_MINOR_ROWS, profile
        assert rank_mod(source_fixed[list(SOURCE_MINOR_ROWS)], prime) == 59

        common_order2 = order2_map(source_jet, basis_inverse, prime)
        assert common_order2.shape == (72, 59)
        assert rank_mod(common_order2, prime) == 16
        chart = common_order2[list(ORDER2_CHART_ROWS)]
        _, chart_pivots = rref(chart, prime)
        assert tuple(chart_pivots) == ORDER2_PIVOT_COLUMNS
        inclusion = cramer_inclusion(common_order2, prime)
        strict_values = source_fixed @ inclusion % prime
        assert rank_mod(inclusion, prime) == rank_mod(strict_values, prime) == 43

        arrays[f"order2_map_p{prime}"] = common_order2.astype(np.uint16)
        arrays[f"strict_inclusion_p{prime}"] = inclusion.astype(np.uint16)
        arrays[f"strict_values_p{prime}"] = strict_values.astype(np.uint16)
        degree_records = {}
        fixed_dual = dual_values[:, : len(evaluation_points)]
        fixed_forms = {
            degree: values[: len(evaluation_points)]
            for degree, values in form_values.items()
        }
        for degree, dimension in TARGET_DIMENSIONS.items():
            target_values = evaluate_cross_basis(
                targets[degree]["basis"], fixed_dual, fixed_forms, prime
            )
            target_rows = np.asarray(
                targets[degree]["fixed_maximal_minor_rows"], dtype=np.int64
            )
            assert len(target_rows) == dimension
            target_minor = target_values[target_rows]
            assert rank_mod(target_minor, prime) == dimension
            multiplier = fixed_forms[MULTIPLIER_DEGREES[degree]]
            product = (
                strict_values.reshape(len(evaluation_points), 5, 43)
                * multiplier[:, None, None]
            ).reshape(-1, 43) % prime
            coordinate_map = inverse_mod(target_minor, prime) @ product[target_rows] % prime
            residual = target_values @ coordinate_map % prime - product
            residual %= prime
            assert not np.any(residual)
            assert rank_mod(coordinate_map, prime) == 43

            arrays[f"multiplier_values_d{degree}_p{prime}"] = multiplier.astype(np.uint16)
            arrays[f"strict_multiplier_map_d{degree}_p{prime}"] = coordinate_map.astype(np.uint16)
            existing_comparison = None
            if prime == 463:
                existing_path = EXISTING_EMBEDDINGS[degree]
                with np.load(existing_path, allow_pickle=False) as frozen:
                    old_rows = frozen["target_basis_minor_rows"].astype(np.int64)
                    old_embedding = frozen["multiplier_embedding"].astype(np.int64)
                assert np.array_equal(old_rows, target_rows)
                assert np.array_equal(old_embedding @ inclusion % prime, coordinate_map)
                existing_comparison = {
                    "path": str(existing_path.relative_to(ROOT)),
                    "sha256": sha256_file(existing_path),
                    "identity": "old_59_column_embedding * fixed_59x43_inclusion = new_map",
                }

            degree_records[str(degree)] = {
                "target_dimension": dimension,
                "multiplier": f"f{MULTIPLIER_DEGREES[degree]}",
                "map_shape": [dimension, 43],
                "map_rank": rank_mod(coordinate_map, prime),
                "map_sha256": sha256_array(coordinate_map.astype(np.uint16)),
                "multiplier_values_sha256": sha256_array(multiplier.astype(np.uint16)),
                "all_400_evaluation_residual_nonzeros": int(np.count_nonzero(residual)),
                "target_minor_rows_sha256": sha256_array(target_rows.astype(np.int32)),
                "existing_embedding_crosscheck": existing_comparison,
            }
            print(f"p={prime} d={degree}: target={dimension} map-rank=43 residual=0", flush=True)

        records.append({
            "prime": prime,
            "zeta11": zeta,
            "commuting_involution_candidate_indices": candidate_indices,
            "source_rank": rank_mod(source_fixed, prime),
            "source_minor_rank": rank_mod(source_fixed[list(SOURCE_MINOR_ROWS)], prime),
            "order2_rank": rank_mod(common_order2, prime),
            "order2_chart_rank": rank_mod(chart, prime),
            "order2_map_sha256": sha256_array(common_order2.astype(np.uint16)),
            "strict_inclusion_rank": rank_mod(inclusion, prime),
            "strict_inclusion_sha256": sha256_array(inclusion.astype(np.uint16)),
            "strict_evaluation_rank": rank_mod(strict_values, prime),
            "strict_order2_residual_nonzeros": int(np.count_nonzero(common_order2 @ inclusion % prime)),
            "degrees": degree_records,
        })

    np.savez_compressed(OUTPUT_NPZ, **arrays)
    payload = {
        "schema": "pc3-fixed-p25-strict-multiplier-circuits-v1",
        "field": "K=Q(zeta_11), Phi_11(zeta_11)=0",
        "input_hashes": {
            str(path.relative_to(ROOT)): digest for path, digest in EXPECTED_HASHES.items()
        },
        "fixed_source": {
            "basis": str(SOURCE_PATH.relative_to(ROOT)),
            "ambient_dimension": 59,
            "strict_dimension": 43,
            "evaluation_points": evaluation_points.tolist(),
            "fixed_source_minor_rows": list(SOURCE_MINOR_ROWS),
            "first_involution": "rho((0,2,5,0)) = S = installed module.A",
            "second_involution_group_index": SECOND_INVOLUTION_INDEX,
            "second_involution_psl_key": list(SECOND_INVOLUTION_PSL_KEY),
            "joint_eigenspace_order": [[1, 1], [1, -1], [-1, 1], [-1, -1]],
            "order2_map": (
                "For directions (0,1,1),(1,0,1),(1,1,0), evaluate at "
                "z=(1,t,s*direction), t=0..23, s=0..25; transform output by "
                "the inverse joint eigenbasis; extract the s^2 coefficient and "
                "components 2,3,4 respectively. Stack to a 72x59 matrix J."
            ),
            "cramer_chart_rows": list(ORDER2_CHART_ROWS),
            "cramer_pivot_columns": list(ORDER2_PIVOT_COLUMNS),
            "cramer_formula": (
                "For free columns F, N[F,:]=I_43 and "
                "N[P,:]=-J[R,P]^(-1)J[R,F]."
            ),
        },
        "target_maps": {
            "31": {
                "target_basis": str(TARGET_PATHS[31].relative_to(ROOT)),
                "target_dimension": 198,
                "multiplier": "the installed integral invariant f6",
                "formula": "D31[R31]^(-1) * (f6 * L25 * N)[R31]",
            },
            "35": {
                "target_basis": str(TARGET_PATHS[35].relative_to(ROOT)),
                "target_dimension": 361,
                "multiplier": "the installed integral invariant f10",
                "formula": "D35[R35]^(-1) * (f10 * L25 * N)[R35]",
            },
        },
        "prime_records": records,
        "artifact": OUTPUT_NPZ.name,
        "artifact_sha256": sha256_file(OUTPUT_NPZ),
        "theorem_scope": {
            "materialized": (
                "Exact finite-field reductions of the fixed circuits at p=419 and p=463, "
                "including 59x43 inclusions, 198x43/361x43 multiplier maps, ranks, "
                "and all-400-row evaluation identities."
            ),
            "exact_circuit": (
                "The input Reynolds/cross circuits, frozen PSL group elements, Cramer "
                "minors, and target coordinate formulas define maps over Q(zeta_11). "
                "A nonzero good-fibre Cramer minor proves each denominator circuit is "
                "nonzero in characteristic zero; multiplication by nonzero f6/f10 has "
                "rank 43 on the exact 43-space."
            ),
            "open": (
                "No entrywise Q(zeta_11) matrices are materialized here. The two modular "
                "arrays are not a rational reconstruction, and this packet does not "
                "decide the authoritative nonlinear PC.2 landing scheme or its images."
            ),
        },
    }
    OUTPUT_JSON.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PC3_P25_MULTIPLIER_MAPS_PRODUCED", flush=True)


if __name__ == "__main__":
    main()
