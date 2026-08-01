#!/usr/bin/env python3
"""Produce fixed exact-circuit bases for the full and m=1 modules.

The characteristic-zero kernel basis is represented by a Cramer circuit on a
fixed restriction minor.  A D12 character computation supplies the exact
upper bound on the restriction rank; the nonzero fixed minor supplies the
matching lower bound.  Thus this is not a promoted fibrewise RREF basis.
"""

from __future__ import annotations

import ctypes
import hashlib
import importlib.util
import json
import math
from pathlib import Path
import shutil
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]
OLD_PACKET = HERE.parent / "COV_STRUCTURED_SEARCH"
RECONSTRUCTOR = E_ROOT / "tmp/degree13_opt/reconstruct_large_prime.py"
FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"
DEGREES = {31: (410, 212, 198), 35: (637, 276, 361)}
PRIMES = {419: 13, 463: 15}


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


def module_at(prime: int, zeta: int):
    wrapper = load(f"cov2_reconstructor_{prime}", RECONSTRUCTOR)
    return wrapper.load_module(prime, zeta)


def rank_profile(name: str, matrix: np.ndarray, prime: int) -> np.ndarray:
    value = np.array(matrix, dtype=np.float64, order="C", copy=True)
    pointer = ctypes.POINTER(ctypes.c_size_t)()
    function = getattr(ctypes.CDLL(FFPACK), name)
    function.argtypes = [
        ctypes.c_double, ctypes.c_size_t, ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_double), ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_size_t)), ctypes.c_int,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rank = int(function(
        float(prime), *value.shape,
        value.ctypes.data_as(ctypes.POINTER(ctypes.c_double)), value.shape[1],
        ctypes.byref(pointer), 2, True,
    ))
    result = np.ctypeslib.as_array(pointer, shape=(rank,)).copy().astype(np.int64)
    libc = ctypes.CDLL(None)
    libc.free.argtypes = [ctypes.c_void_p]
    libc.free(pointer)
    return result


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    return len(rank_profile("RowRankProfile_modular_double", matrix, prime))


def inverse_mod(matrix: np.ndarray, prime: int) -> np.ndarray:
    n = len(matrix)
    value = np.concatenate(
        [np.asarray(matrix, dtype=np.int64) % prime, np.eye(n, dtype=np.int64)],
        axis=1,
    )
    for column in range(n):
        choices = np.flatnonzero(value[column:, column])
        assert len(choices)
        pivot = column + int(choices[0])
        value[[column, pivot]] = value[[pivot, column]]
        value[column] = value[column] * pow(int(value[column, column]), -1, prime) % prime
        active = np.flatnonzero(value[:, column])
        active = active[active != column]
        for start in range(0, len(active), 128):
            rows = active[start:start + 128]
            value[rows] = (
                value[rows] - value[rows, column, None] * value[column][None, :]
            ) % prime
    return value[:, n:]


def fixed_nullspace(
    matrix: np.ndarray,
    prime: int,
    row_indices: np.ndarray,
    pivot_columns: np.ndarray,
) -> np.ndarray:
    pivot_set = set(map(int, pivot_columns))
    free = np.asarray(
        [column for column in range(matrix.shape[1]) if column not in pivot_set],
        dtype=np.int64,
    )
    selected = np.asarray(matrix[row_indices], dtype=np.int64) % prime
    inverse = inverse_mod(selected[:, pivot_columns], prime)
    solved = -inverse @ selected[:, free] % prime
    answer = np.zeros((len(free), matrix.shape[1]), dtype=np.int64)
    answer[:, pivot_columns] = solved.T
    answer[:, free] = np.eye(len(free), dtype=np.int64)
    assert not np.any(np.asarray(matrix, dtype=np.int64) @ answer.T % prime)
    return answer


def batch_evaluate(module, seeds, points: np.ndarray, prime: int, chunk: int = 40):
    pieces = []
    for start in range(0, len(points), chunk):
        block = np.asarray(points[start:start + chunk], dtype=np.int64) % prime
        transformed = np.einsum("gij,pj->pgi", module.GROUP, block) % prime
        cache = {}

        def power(coordinate: int, exponent: int):
            key = coordinate, exponent
            if key not in cache:
                value = np.ones(transformed.shape[:2], dtype=np.int64)
                for _ in range(exponent):
                    value = value * transformed[:, :, coordinate] % prime
                cache[key] = value
            return cache[key]

        columns = []
        for seed in seeds:
            values = np.ones(transformed.shape[:2], dtype=np.int64)
            for coordinate, exponent in enumerate(seed.exponents):
                if exponent:
                    values = values * power(coordinate, exponent) % prime
            columns.append((values @ module.INVERSES[:, :, seed.output] % prime).reshape(-1))
        pieces.append(np.column_stack(columns).astype(np.int32))
    return np.vstack(pieces)


def fixed_plus_basis(module, prime: int, row_indices=None, pivot_columns=None):
    matrix = (np.asarray(module.A, dtype=np.int64) - np.eye(5, dtype=np.int64)) % prime
    if row_indices is None:
        row_indices = rank_profile("RowRankProfile_modular_double", matrix, prime)
        selected = matrix[row_indices]
        pivot_columns = rank_profile("ColumnRankProfile_modular_double", selected, prime)
    basis = fixed_nullspace(matrix, prime, row_indices, pivot_columns)
    assert basis.shape == (3, 5)
    return basis, np.asarray(row_indices), np.asarray(pivot_columns)


def restriction_points(plus: np.ndarray, degree: int, prime: int):
    coefficients = np.asarray(
        [(1, i, j) for i in range(degree + 1) for j in range(degree + 1 - i)],
        dtype=np.int64,
    )
    return coefficients, coefficients @ plus % prime


def left_inverse(basis_rows: np.ndarray, prime: int) -> np.ndarray:
    # basis_rows is 3 x 5.  Choose a fixed invertible 3-column block.
    columns = rank_profile("ColumnRankProfile_modular_double", basis_rows, prime)
    assert len(columns) == 3
    result = np.zeros((3, 5), dtype=np.int64)
    result[:, columns] = inverse_mod(basis_rows[:, columns], prime).T
    assert np.array_equal(result @ basis_rows.T % prime, np.eye(3, dtype=np.int64))
    return result


def symmetric_trace(matrix: np.ndarray, degree: int, prime: int) -> int:
    current = np.eye(len(matrix), dtype=np.int64)
    power_traces = [0]
    for _ in range(degree):
        current = current @ matrix % prime
        power_traces.append(int(np.trace(current) % prime))
    complete = [1]
    for n in range(1, degree + 1):
        value = sum(power_traces[k] * complete[n - k] for k in range(1, n + 1))
        complete.append(value * pow(n, -1, prime) % prime)
    return complete[degree]


def d12_target_multiplicity(module, plus: np.ndarray, degree: int, prime: int) -> int:
    identity = np.eye(5, dtype=np.int64) % prime
    centralizer = [
        np.asarray(matrix, dtype=np.int64) % prime
        for matrix in module.GROUP
        if np.array_equal(matrix @ module.A % prime, module.A @ matrix % prime)
    ]
    assert len(centralizer) == 12
    left = left_inverse(plus, prime)
    total = 0
    for matrix in centralizer:
        coordinates = left @ matrix @ plus.T % prime
        coordinates_inverse = inverse_mod(coordinates, prime)
        polynomial_trace = symmetric_trace(coordinates_inverse, degree, prime)
        total = (total + int(np.trace(matrix) % prime) * polynomial_trace) % prime
    return total * pow(12, -1, prime) % prime


def generic_integer_points(count: int) -> np.ndarray:
    # Fixed small integral points, independent of the reduction prime.
    state = 20260802003135
    values = []
    for _ in range(count * 5):
        state = (6364136223846793005 * state + 1442695040888963407) % (1 << 64)
        values.append((state >> 24) % 251)
    return np.asarray(values, dtype=np.int64).reshape(count, 5)


def main() -> None:
    manifest = {
        "schema": "cov-m1-fixed-cyclotomic-bases-v1",
        "field": "K=Q(zeta_11), Phi_11(zeta_11)=0",
        "lattice": (
            "O=Z[zeta_11,1/(660*Delta31*Delta35)], where each Delta is the "
            "fixed Cramer restriction minor specified below"
        ),
        "exact_reynolds_rule": (
            "R_(j,alpha)(x)=sum_(g in PSL(2,11)) (g x)^alpha g^(-1)e_j; "
            "the omitted factor 1/660 is a unit on the stated open"
        ),
        "unused_good_primes": list(PRIMES),
        "degrees": {},
    }
    fixed_plus_rows = fixed_plus_pivots = None
    fixed_restriction = {}
    for degree, (full_dimension, target_dimension, kernel_dimension) in DEGREES.items():
        directory = HERE / f"degree_{degree}"
        directory.mkdir(exist_ok=True)
        source = OLD_PACKET / f"degree_{degree}/covariant_basis_seeds.json"
        circuits_path = directory / "full_reynolds_circuits.json"
        shutil.copyfile(source, circuits_path)
        records = json.loads(circuits_path.read_text())
        assert len(records) == full_dimension
        generic_points = generic_integer_points(math.ceil(full_dimension / 5) + 16)
        prime_records = []
        for prime, zeta in PRIMES.items():
            module = module_at(prime, zeta)
            seeds = [
                module.ReynoldsSeed(int(item["output"]), tuple(map(int, item["exponents"])))
                for item in records
            ]
            generic = batch_evaluate(module, seeds, generic_points, prime)
            full_rank = rank_mod(generic, prime)
            assert full_rank == full_dimension
            plus, plus_rows, plus_pivots = fixed_plus_basis(
                module, prime, fixed_plus_rows, fixed_plus_pivots
            )
            if fixed_plus_rows is None:
                fixed_plus_rows, fixed_plus_pivots = plus_rows, plus_pivots
            coefficients, points = restriction_points(plus, degree, prime)
            restriction = batch_evaluate(module, seeds, points, prime)
            character_residue = d12_target_multiplicity(module, plus, degree, prime)
            assert character_residue == target_dimension % prime

            if degree not in fixed_restriction:
                row_indices = rank_profile(
                    "RowRankProfile_modular_double", restriction, prime
                )
                assert len(row_indices) == target_dimension
                pivot_columns = rank_profile(
                    "ColumnRankProfile_modular_double", restriction[row_indices], prime
                )
                fixed_restriction[degree] = row_indices, pivot_columns
            row_indices, pivot_columns = fixed_restriction[degree]
            assert rank_mod(restriction[row_indices][:, pivot_columns], prime) == target_dimension
            kernel = fixed_nullspace(restriction, prime, row_indices, pivot_columns)
            assert kernel.shape == (kernel_dimension, full_dimension)
            output = directory / f"fixed_m1_basis_p{prime}.npz"
            np.savez_compressed(
                output,
                plus_basis=plus.astype(np.uint16),
                plane_grid_coefficients=coefficients.astype(np.uint16),
                generic_points=generic_points.astype(np.uint16),
                restriction_row_indices=row_indices.astype(np.int32),
                restriction_pivot_columns=pivot_columns.astype(np.int32),
                fixed_kernel=kernel.astype(np.uint16),
            )
            prime_records.append({
                "prime": prime,
                "zeta11": zeta,
                "full_basis_rank": full_rank,
                "d12_character_target_dimension_residue": character_residue,
                "restriction_rank": rank_mod(restriction, prime),
                "fixed_minor_rank": rank_mod(
                    restriction[row_indices][:, pivot_columns], prime
                ),
                "m1_kernel_dimension": len(kernel),
                "payload": output.name,
                "payload_sha256": sha256(output),
            })
            print(
                f"degree={degree} p={prime} full={full_rank} "
                f"restriction={target_dimension} m1={len(kernel)}",
                flush=True,
            )

        row_indices, pivot_columns = fixed_restriction[degree]
        circuit = {
            "schema": "cov-m1-cramer-kernel-circuit-v1",
            "degree": degree,
            "full_basis_dimension": full_dimension,
            "restriction_target_dimension_by_exact_D12_character": target_dimension,
            "m1_dimension": kernel_dimension,
            "plus_basis_circuit": {
                "matrix": "A(zeta_11)-I_5",
                "selected_rows": fixed_plus_rows.tolist(),
                "pivot_columns": fixed_plus_pivots.tolist(),
                "basis_rule": "free-column Cramer basis with monic free coordinates",
            },
            "plane_grid": "(1,i,j), 0<=i<=d, 0<=j<=d-i, in the fixed plus basis",
            "restriction_selected_rows": row_indices.tolist(),
            "restriction_pivot_columns": pivot_columns.tolist(),
            "basis_rule": (
                "For each nonpivot Reynolds coordinate c, set c=1 and the other "
                "free coordinates to zero; solve the fixed selected restriction "
                "rows by Cramer's rule. Exact target multiplicity bounds the full "
                "rank by the minor size, so all remaining rows vanish."
            ),
            "proof": (
                "The D12 character computation gives rank(R)<=target_dimension in "
                "characteristic zero. The displayed fixed minor is nonzero after "
                "two good reductions, hence nonzero over K and rank(R)>=target_dimension."
            ),
        }
        circuit_path = directory / "fixed_m1_basis_circuit.json"
        circuit_path.write_text(json.dumps(circuit, indent=2, sort_keys=True) + "\n")
        manifest["degrees"][str(degree)] = {
            "full_circuits": str(circuits_path.relative_to(HERE)),
            "full_circuits_sha256": sha256(circuits_path),
            "kernel_circuit": str(circuit_path.relative_to(HERE)),
            "kernel_circuit_sha256": sha256(circuit_path),
            "prime_records": prime_records,
        }
    (HERE / "canonical_bases.json").write_text(
        json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    )
    print("COV_M1_CANONICAL_BASES_PRODUCED")


if __name__ == "__main__":
    main()
