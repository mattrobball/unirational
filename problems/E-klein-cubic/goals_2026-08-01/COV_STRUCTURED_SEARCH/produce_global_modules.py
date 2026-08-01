#!/usr/bin/env python3
"""Build exact good-fibre covariant and fixed-locus modules in degrees 25,31,35.

Each saved seed label denotes the exact Reynolds average of a monomial-output
map.  Independence at a good split prime, together with the characteristic-
zero Molien multiplicity, certifies that the corresponding formal Reynolds
averages are a characteristic-zero basis of the full self-covariant space.

The arrangement and common-line kernels are computed exactly over two split
good fibres.  Agreement is recorded only at that modular scope; it is not
silently promoted to a characteristic-zero kernel basis.
"""

from __future__ import annotations

import ctypes
import hashlib
import importlib.util
import itertools
import json
import math
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]
RECONSTRUCTOR = E_ROOT / "tmp/degree13_opt/reconstruct_large_prime.py"
P25_SEEDS = E_ROOT / "tmp/higher_compatibility_regularity/seeds/degree_25.json"
P35_SEEDS = E_ROOT / "tmp/m1_t1_f3_colon_degree35_audit/ambient_seeds_35.json"
FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"
PRIMES = ((89, 78), (199, 61))
DEGREES = (25, 31, 35)
COVARIANT_DIMENSIONS = {25: 189, 31: 410, 35: 637}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def load_module(prime: int, zeta: int):
    wrapper = load(f"cov_struct_reconstructor_{prime}", RECONSTRUCTOR)
    return wrapper.load_module(prime, zeta)


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    value = np.array(matrix, dtype=np.int32, order="C", copy=True)
    rows = np.empty(value.shape[0], dtype=np.uintp)
    columns = np.empty(value.shape[1], dtype=np.uintp)
    function = ctypes.CDLL(FFPACK).RowEchelonForm_modular_int32_t
    function.argtypes = [
        ctypes.c_int32, ctypes.c_size_t, ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_int32), ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_size_t), ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_bool, ctypes.c_int, ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    return int(function(
        prime, value.shape[0], value.shape[1],
        value.ctypes.data_as(ctypes.POINTER(ctypes.c_int32)), value.shape[1],
        rows.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        columns.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        False, 2, True,
    ))


def rref(matrix: np.ndarray, prime: int):
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    rows, columns = value.shape
    pivots = []
    pivot_row = 0
    for column in range(columns):
        candidates = np.flatnonzero(value[pivot_row:, column])
        if not len(candidates):
            continue
        selected = pivot_row + int(candidates[0])
        value[[pivot_row, selected]] = value[[selected, pivot_row]]
        value[pivot_row] = value[pivot_row] * pow(int(value[pivot_row, column]), -1, prime) % prime
        active = np.flatnonzero(value[:, column])
        active = active[active != pivot_row]
        for start in range(0, len(active), 256):
            block = active[start:start + 256]
            value[block] = (
                value[block]
                - value[block, column, None] * value[pivot_row][None, :]
            ) % prime
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    return value, pivots


def nullspace_rows(matrix: np.ndarray, prime: int):
    reduced, pivots = rref(matrix, prime)
    free = [column for column in range(matrix.shape[1]) if column not in pivots]
    answer = np.zeros((len(free), matrix.shape[1]), dtype=np.int64)
    for index, free_column in enumerate(free):
        answer[index, free_column] = 1
        for row, pivot in enumerate(pivots):
            answer[index, pivot] = -reduced[row, free_column] % prime
    assert not len(answer) or not np.any(np.asarray(matrix, dtype=np.int64) @ answer.T % prime)
    return answer


def batch_seed_evaluations(module, seeds, points: np.ndarray, prime: int, chunk: int = 48):
    pieces = []
    for start in range(0, len(points), chunk):
        block = np.asarray(points[start:start + chunk], dtype=np.int64) % prime
        transformed = np.einsum("gij,pj->pgi", module.GROUP, block) % prime
        cache: dict[tuple[int, int], np.ndarray] = {}

        def power(coordinate: int, exponent: int):
            key = (coordinate, exponent)
            if key not in cache:
                value = np.ones(transformed.shape[:2], dtype=np.int64)
                base = transformed[:, :, coordinate]
                for _ in range(exponent):
                    value = value * base % prime
                cache[key] = value
            return cache[key]

        columns = []
        for seed in seeds:
            values = np.ones(transformed.shape[:2], dtype=np.int64)
            for coordinate, exponent in enumerate(seed.exponents):
                if exponent:
                    values = values * power(coordinate, exponent) % prime
            evaluated = values @ module.INVERSES[:, :, seed.output] % prime
            columns.append(evaluated.reshape(-1))
        pieces.append(np.column_stack(columns).astype(np.int32))
    return np.vstack(pieces).astype(np.int32)


def small_nullspace(matrix: np.ndarray, prime: int):
    return nullspace_rows(matrix, prime)


def plus_minus_spaces(module, prime: int):
    identity = np.eye(5, dtype=np.int64)
    plus = small_nullspace((module.A - identity) % prime, prime)
    minus = small_nullspace((module.A + identity) % prime, prime)
    assert plus.shape == (3, 5) and minus.shape == (2, 5)
    return plus, minus


def triangular_points(plus: np.ndarray, degree: int, prime: int):
    return np.asarray(
        [
            (plus[0] + i * plus[1] + j * plus[2]) % prime
            for i in range(degree + 1)
            for j in range(degree + 1 - i)
        ],
        dtype=np.int64,
    )


def inverse_mod(matrix: np.ndarray, prime: int):
    n = matrix.shape[0]
    augmented = np.concatenate(
        [np.asarray(matrix, dtype=np.int64) % prime, np.eye(n, dtype=np.int64)], axis=1
    )
    for column in range(n):
        pivot = next(row for row in range(column, n) if augmented[row, column] % prime)
        augmented[[column, pivot]] = augmented[[pivot, column]]
        augmented[column] = augmented[column] * pow(int(augmented[column, column]), -1, prime) % prime
        for row in range(n):
            if row != column and augmented[row, column]:
                augmented[row] = augmented[row] - augmented[row, column] * augmented[column]
                augmented[row] %= prime
    return augmented[:, n:]


def combined_first_second_jet_sample(
    module,
    seeds,
    arrangement: np.ndarray,
    plus: np.ndarray,
    minus: np.ndarray,
    degree: int,
    prime: int,
):
    """An exact injectivity witness for the order-(1,2) jet on Arr.

    Full rank of any evaluation sample proves injectivity of the complete jet
    map.  No claim of surjectivity or unisolvence is needed.
    """

    # Involution parity leaves two effective target components in order one
    # and three in order two, so each base/normal sample contributes at most
    # five independent rows, not ten raw coordinate rows.
    sample_count = math.ceil(len(arrangement) / 5) + 8
    rng = np.random.default_rng(2026080200 + degree + prime)
    base_coefficients = rng.integers(0, prime, size=(sample_count, 3), dtype=np.int64)
    normal_coefficients = rng.integers(0, prime, size=(sample_count, 2), dtype=np.int64)
    # Avoid the zero normal direction.
    for row in normal_coefficients:
        if not np.any(row):
            row[0] = 1
    bases = base_coefficients @ plus % prime
    normals = normal_coefficients @ minus % prime
    points = np.asarray(
        [
            (base + scalar * normal) % prime
            for base, normal in zip(bases, normals)
            for scalar in range(degree + 1)
        ],
        dtype=np.int64,
    )
    evaluated = batch_seed_evaluations(module, seeds, points, prime).reshape(
        sample_count, degree + 1, 5, len(seeds)
    )
    vandermonde = np.asarray(
        [
            [pow(value, exponent, prime) for exponent in range(degree + 1)]
            for value in range(degree + 1)
        ],
        dtype=np.int64,
    )
    weights = inverse_mod(vandermonde, prime)
    first = np.einsum("s,nsvc->nvc", weights[1], evaluated) % prime
    second = np.einsum("s,nsvc->nvc", weights[2], evaluated) % prime
    seed_map = np.concatenate((first.reshape(-1, len(seeds)), second.reshape(-1, len(seeds))))
    arrangement_map = seed_map @ arrangement.T % prime
    return {
        "base_coefficients": base_coefficients.astype(np.int32),
        "normal_coefficients": normal_coefficients.astype(np.int32),
        "seed_map": seed_map.astype(np.int32),
        "arrangement_map": arrangement_map.astype(np.int32),
        "rank": rank_mod(arrangement_map, prime),
    }


def joint_basis(module, prime: int):
    identity = np.eye(5, dtype=np.int64)
    first = np.asarray(module.A, dtype=np.int64) % prime
    commuting = []
    for candidate in module.GROUP:
        candidate = np.asarray(candidate, dtype=np.int64) % prime
        if np.array_equal(candidate, identity):
            continue
        if (
            np.array_equal(candidate @ candidate % prime, identity)
            and np.array_equal(candidate @ first % prime, first @ candidate % prime)
            and not np.array_equal(candidate, first)
        ):
            commuting.append(candidate)
    assert len(commuting) == 6
    second = min(commuting, key=lambda matrix: bytes(matrix.astype(np.uint8).flat))
    spaces = []
    for sign1, sign2 in ((1, 1), (1, -1), (-1, 1), (-1, -1)):
        equations = np.vstack((first - sign1 * identity, second - sign2 * identity)) % prime
        spaces.append(small_nullspace(equations, prime))
    assert [len(space) for space in spaces] == [2, 1, 1, 1]
    basis = np.column_stack([vector for space in spaces for vector in space]) % prime
    return basis, inverse_mod(basis, prime)


def order2_seed_map(module, seeds, degree: int, prime: int):
    basis, basis_inverse = joint_basis(module, prime)
    base_points = np.asarray(
        [basis @ np.asarray([1, t, 0, 0, 0], dtype=np.int64) % prime for t in range(degree - 1)],
        dtype=np.int64,
    )
    direction_records = (((0, 1, 1), 2), ((1, 0, 1), 3), ((1, 1, 0), 4))
    directions = np.asarray(
        [basis @ np.asarray([0, 0, *direction], dtype=np.int64) % prime for direction, _ in direction_records],
        dtype=np.int64,
    )
    transformed_base = np.einsum("gij,pj->pgi", module.GROUP, base_points) % prime
    transformed_normal = np.einsum("gij,nj->ngi", module.GROUP, directions) % prime
    base_cache = {}
    normal_cache = {}

    def power(cache, values, coordinate, exponent):
        key = (coordinate, exponent)
        if key not in cache:
            answer = np.ones(values.shape[:2], dtype=np.int64)
            for _ in range(exponent):
                answer = answer * values[:, :, coordinate] % prime
            cache[key] = answer
        return cache[key]

    splittings = []
    for picked in itertools.product(range(3), repeat=5):
        if sum(picked) == 2:
            splittings.append(picked)
    columns = []
    for seed in seeds:
        coefficient = np.zeros((len(base_points), len(directions), len(module.GROUP)), dtype=np.int64)
        for picked in splittings:
            if any(k > exponent for k, exponent in zip(picked, seed.exponents)):
                continue
            scalar = 1
            term = np.ones_like(coefficient)
            for coordinate, (exponent, k) in enumerate(zip(seed.exponents, picked)):
                scalar = scalar * math.comb(exponent, k) % prime
                term = term * power(base_cache, transformed_base, coordinate, exponent - k)[:, None, :] % prime
                term = term * power(normal_cache, transformed_normal, coordinate, k)[None, :, :] % prime
            coefficient = (coefficient + scalar * term) % prime
        evaluated = np.einsum("png,gk->pnk", coefficient, module.INVERSES[:, :, seed.output]) % prime
        adapted = np.einsum("ab,pnb->pna", basis_inverse, evaluated) % prime
        column = np.concatenate(
            [adapted[:, index, target] for index, (_direction, target) in enumerate(direction_records)]
        )
        columns.append(column)
    return np.column_stack(columns).astype(np.int32)


def seed_records_for_degree(degree: int, module67=None):
    target = HERE / f"degree_{degree}/covariant_basis_seeds.json"
    if target.exists():
        records = json.loads(target.read_text())
        if len(records) == COVARIANT_DIMENSIONS[degree]:
            return records
    source = {25: P25_SEEDS, 35: P35_SEEDS}.get(degree)
    if source is not None:
        records = json.loads(source.read_text())
    else:
        assert module67 is not None
        rng = np.random.default_rng(2026080131)
        module67.SELECTION_POINTS = [
            rng.integers(0, 67, size=5, dtype=np.int64)
            for _ in range(math.ceil(COVARIANT_DIMENSIONS[degree] / 5) + 8)
        ]
        seeds = module67.covariant_basis(degree, COVARIANT_DIMENSIONS[degree])
        records = [
            {"output": int(seed.output), "exponents": list(map(int, seed.exponents))}
            for seed in seeds
        ]
    assert len(records) == COVARIANT_DIMENSIONS[degree]
    target.write_text(json.dumps(records, indent=2) + "\n")
    return records


def main() -> None:
    module67 = load_module(67, 64)
    summary = {}
    for degree in DEGREES:
        directory = HERE / f"degree_{degree}"
        directory.mkdir(exist_ok=True)
        records = seed_records_for_degree(degree, module67)
        prime_results = []
        for prime, zeta in PRIMES:
            module = load_module(prime, zeta)
            seeds = [
                module.ReynoldsSeed(int(item["output"]), tuple(map(int, item["exponents"])))
                for item in records
            ]
            rng = np.random.default_rng(2026080100 + degree + prime)
            generic = rng.integers(
                0, prime,
                size=(math.ceil(len(seeds) / 5) + 8, 5),
                dtype=np.int64,
            )
            basis_evaluations = batch_seed_evaluations(module, seeds, generic, prime)
            basis_rank = rank_mod(basis_evaluations, prime)
            assert basis_rank == len(seeds)
            plus, minus = plus_minus_spaces(module, prime)
            plane_points = triangular_points(plus, degree, prime)
            restriction = batch_seed_evaluations(module, seeds, plane_points, prime)
            restriction_rank = rank_mod(restriction, prime)
            arrangement = nullspace_rows(restriction, prime)
            order2_seeds = order2_seed_map(module, seeds, degree, prime)
            order2_arrangement = order2_seeds @ arrangement.T % prime
            order2_rank = rank_mod(order2_arrangement, prime)
            strict_in_arrangement = nullspace_rows(order2_arrangement, prime)
            strict_in_covariants = strict_in_arrangement @ arrangement % prime
            higher = combined_first_second_jet_sample(
                module, seeds, arrangement, plus, minus, degree, prime
            )
            output = directory / f"global_module_p{prime}.npz"
            np.savez_compressed(
                output,
                generic_points=generic.astype(np.int32),
                basis_evaluations=basis_evaluations.astype(np.int32),
                plus_basis=plus.astype(np.int32),
                minus_basis=minus.astype(np.int32),
                restriction=restriction.astype(np.int32),
                arrangement_basis=arrangement.astype(np.int32),
                order2_seed_map=order2_seeds.astype(np.int32),
                order2_arrangement_map=order2_arrangement.astype(np.int32),
                strict_in_arrangement=strict_in_arrangement.astype(np.int32),
                strict_in_covariants=strict_in_covariants.astype(np.int32),
                higher_jet_base_coefficients=higher["base_coefficients"],
                higher_jet_normal_coefficients=higher["normal_coefficients"],
                higher_jet_seed_map=higher["seed_map"],
                higher_jet_arrangement_map=higher["arrangement_map"],
            )
            record = {
                "prime": prime,
                "zeta11": zeta,
                "covariant_basis_rank": basis_rank,
                "plane_point_count": len(plane_points),
                "restriction_rank": restriction_rank,
                "arrangement_kernel_dimension": len(arrangement),
                "common_order2_rank_on_arrangement": order2_rank,
                "strict_dimension": len(strict_in_arrangement),
                "combined_first_second_jet_rank_on_arrangement": higher["rank"],
                "plane_order_at_least_3_dimension": len(arrangement) - higher["rank"],
                "payload": output.name,
                "payload_sha256": sha256(output),
            }
            prime_results.append(record)
            print(
                f"degree={degree} prime={prime} M={len(seeds)} "
                f"Arr={len(arrangement)} strict={len(strict_in_arrangement)} "
                f"order>=3={len(arrangement) - higher['rank']}",
                flush=True,
            )
        summary[str(degree)] = {
            "degree": degree,
            "characteristic_zero_self_covariant_dimension": len(records),
            "characteristic_zero_basis_model": "exact Reynolds averages of the stored monomial-output labels",
            "basis_seed_payload": f"degree_{degree}/covariant_basis_seeds.json",
            "basis_seed_sha256": sha256(directory / "covariant_basis_seeds.json"),
            "prime_results": prime_results,
            "arrangement_scope": "exact in each displayed good fibre; agreement alone is not a characteristic-zero kernel reconstruction",
        }
    (HERE / "global_modules_summary.json").write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print("COV_GLOBAL_MODULES_PRODUCED", flush=True)


if __name__ == "__main__":
    main()
