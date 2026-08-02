#!/usr/bin/env python3
"""Produce fixed characteristic-zero bases for K1 in degrees 31 and 35.

The construction first selects a fixed Hironaka basis of the 60-generator
dual-covariant module N=(K[W] tensor W*)^G.  Four dual covariants evaluated at
the same point lie in the three-dimensional dual plus-space on every
involution plane.  Their generalized cross product is therefore a primal
self-covariant vanishing on all 55 planes.  Fixed independent collections of
such crosses give the complete K1 bases.

All selected objects are Reynolds circuits over Q(zeta_11), not fibrewise
RREF vectors.  Fresh reductions are used only to certify fixed minors.
"""

from __future__ import annotations

from collections import defaultdict
import ctypes
import hashlib
import importlib.util
import itertools
import json
import math
from pathlib import Path
import shutil
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OLD = HERE.parent / "COV_STRUCTURED_SEARCH"
sys.path.insert(0, str(ROOT / "tmp" / "generic_twist"))
sys.path.insert(0, str(ROOT / "tmp" / "kproj_arithmetic"))

import core  # noqa: E402
import phi_coefficients as phi  # noqa: E402


RECONSTRUCTOR = ROOT / "tmp" / "degree13_opt" / "reconstruct_large_prime.py"
FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"
PRIMES = {419: 13, 463: 15}
TARGETS = {31: (410, 198, 212), 35: (637, 361, 276)}
PRIMARY_WEIGHTS = tuple(map(int, core.PRIMARY_DEGREES))
DUAL_SUPPORT = {
    2: 1, 4: 1, 5: 1, 6: 2, 7: 2, 8: 2, 9: 3, 10: 3,
    11: 4, 12: 3, 13: 5, 14: 5, 15: 4, 16: 5, 17: 4,
    18: 4, 19: 2, 20: 4, 21: 1, 22: 1, 23: 1, 24: 1, 27: 1,
}
assert sum(DUAL_SUPPORT.values()) == 60


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
    wrapper = load(f"cross_basis_reconstructor_{prime}", RECONSTRUCTOR)
    return wrapper.load_module(prime, zeta)


def rank_profile(matrix: np.ndarray, prime: int) -> np.ndarray:
    value = np.array(matrix, dtype=np.float64, order="C", copy=True)
    pointer = ctypes.POINTER(ctypes.c_size_t)()
    function = ctypes.CDLL(FFPACK).RowRankProfile_modular_double
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
    return len(rank_profile(matrix, prime))


class Echelon:
    def __init__(self, prime: int):
        self.prime = prime
        self.rows: list[tuple[int, np.ndarray]] = []

    def add(self, row: np.ndarray) -> bool:
        remainder = np.asarray(row, dtype=np.int64).copy() % self.prime
        for pivot, basis in self.rows:
            if remainder[pivot]:
                remainder = (remainder - remainder[pivot] * basis) % self.prime
        nonzero = np.flatnonzero(remainder)
        if not len(nonzero):
            return False
        pivot = int(nonzero[0])
        remainder = remainder * pow(int(remainder[pivot]), -1, self.prime) % self.prime
        self.rows.append((pivot, remainder))
        return True

    def __len__(self):
        return len(self.rows)


def fixed_points(count: int) -> np.ndarray:
    state = 20260802003135
    answer = []
    for _ in range(count):
        point = []
        for _ in range(5):
            state = (6364136223846793005 * state + 1442695040888963407) % (1 << 64)
            point.append((state >> 24) % 251)
        answer.append(point)
    return np.asarray(answer, dtype=np.int64)


def evaluate_polynomial(polynomial, points: np.ndarray, prime: int) -> np.ndarray:
    answer = np.zeros(len(points), dtype=np.int64)
    for exponents, coefficient in polynomial.items():
        value = np.full(len(points), int(coefficient) % prime, dtype=np.int64)
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                value = value * np.asarray(
                    [pow(int(item), int(exponent), prime) for item in points[:, coordinate]],
                    dtype=np.int64,
                ) % prime
        answer = (answer + value) % prime
    return answer


class DualEvaluator:
    def __init__(self, module, points: np.ndarray, prime: int):
        self.module = module
        self.points = np.asarray(points, dtype=np.int64) % prime
        self.prime = prime
        self.transformed = np.einsum("gij,pj->pgi", module.GROUP, self.points) % prime
        self.powers: dict[tuple[int, int], np.ndarray] = {}

    def power(self, coordinate: int, exponent: int):
        key = coordinate, exponent
        if key not in self.powers:
            value = np.ones(self.transformed.shape[:2], dtype=np.int64)
            for _ in range(exponent):
                value = value * self.transformed[:, :, coordinate] % self.prime
            self.powers[key] = value
        return self.powers[key]

    def monomial_values(self, exponents):
        values = np.ones(self.transformed.shape[:2], dtype=np.int64)
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                values = values * self.power(coordinate, exponent) % self.prime
        return values

    def seed(self, output: int, exponents) -> np.ndarray:
        values = self.monomial_values(exponents)
        # q(hx)=h^(-T)q(x): sum_g g^T e_output (g x)^alpha.
        return values @ np.asarray(self.module.GROUP[:, output, :], dtype=np.int64) % self.prime


def primary_partition_count(degree: int) -> int:
    return len(core.weighted_exponents(degree, PRIMARY_WEIGHTS)) if degree >= 0 else 0


def dual_dimension(degree: int) -> int:
    return sum(
        multiplicity * primary_partition_count(degree - source_degree)
        for source_degree, multiplicity in DUAL_SUPPORT.items()
        if source_degree <= degree
    )


def generator_json(degree: int, output: int, exponents):
    return {
        "degree": int(degree),
        "reynolds_output": int(output),
        "reynolds_exponents": list(map(int, exponents)),
        "circuit": "sum_(g in G) (g*x)^alpha * g^T*e_output",
    }


def select_dual_generators(module, evaluator: DualEvaluator, fixed=None):
    selected = []
    selected_values = []
    by_degree: dict[int, list[int]] = defaultdict(list)
    fixed_cursor = 0
    ledger = []
    max_degree = 24
    for degree in range(max_degree + 1):
        wanted = DUAL_SUPPORT.get(degree, 0)
        echelon = Echelon(evaluator.prime)
        for index, record in enumerate(selected):
            residual = degree - int(record["degree"])
            if residual < 0:
                continue
            for powers in core.weighted_exponents(residual, PRIMARY_WEIGHTS):
                scalar = evaluate_polynomial(
                    core.primary_monomial(powers), evaluator.points, evaluator.prime
                )
                value = selected_values[index] * scalar[:, None] % evaluator.prime
                assert echelon.add(value.reshape(-1))
        inherited_rank = len(echelon)
        assert inherited_rank == dual_dimension(degree) - wanted
        new_records = []
        if fixed is None:
            for exponents in module.monomials(degree):
                for output in range(5):
                    value = evaluator.seed(output, exponents)
                    if echelon.add(value.reshape(-1)):
                        record = generator_json(degree, output, exponents)
                        new_records.append(record)
                        selected.append(record)
                        selected_values.append(value)
                        by_degree[degree].append(len(selected) - 1)
                        if len(new_records) == wanted:
                            break
                if len(new_records) == wanted:
                    break
        else:
            for _ in range(wanted):
                record = fixed[fixed_cursor]
                fixed_cursor += 1
                assert int(record["degree"]) == degree
                value = evaluator.seed(
                    int(record["reynolds_output"]), tuple(record["reynolds_exponents"])
                )
                assert echelon.add(value.reshape(-1))
                new_records.append(record)
                selected.append(record)
                selected_values.append(value)
                by_degree[degree].append(len(selected) - 1)
        assert len(new_records) == wanted
        assert len(echelon) == dual_dimension(degree)
        if wanted:
            print(
                f"dual p={evaluator.prime} degree={degree} inherited={inherited_rank} "
                f"new={wanted} total={len(echelon)}",
                flush=True,
            )
        ledger.append({
            "degree": degree,
            "inherited_primary_multiple_rank": inherited_rank,
            "new_hironaka_generators": wanted,
            "full_dual_covariant_dimension": len(echelon),
        })
    if fixed is not None:
        assert fixed_cursor == len(fixed)
    assert len(selected) == sum(v for d, v in DUAL_SUPPORT.items() if d <= max_degree)
    return selected, np.asarray(selected_values), ledger


def evaluate_fixed_dual_generators(evaluator: DualEvaluator, records):
    """Evaluate fixed Reynolds circuits without making an independence claim."""
    return np.asarray([
        evaluator.seed(
            int(record["reynolds_output"]), tuple(record["reynolds_exponents"])
        )
        for record in records
    ])


def invariant_labels(degree: int):
    result = []
    for secondary, secondary_degree in enumerate(core.SECONDARY_DEGREES):
        if secondary_degree <= degree:
            for exponents in core.weighted_exponents(degree - secondary_degree):
                result.append((secondary, tuple(map(int, exponents))))
    return result


def invariant_polynomial(label):
    secondary, exponents = label
    return phi.multiply(
        core.primary_monomial(exponents), core.secondary_polynomials()[secondary]
    )


def invariant_json(label):
    secondary, exponents = label
    return {
        "secondary_index": int(secondary),
        "secondary_name": core.SECONDARY_NAMES[secondary],
        "secondary_degree": int(core.SECONDARY_DEGREES[secondary]),
        "primary_exponents": list(exponents),
    }


def determinant4(values: np.ndarray, prime: int) -> np.ndarray:
    # values has shape (points,4,4); p^4 is safely below int64 here.
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


def cross4(values: np.ndarray, indices, prime: int) -> np.ndarray:
    rows = values[list(indices)].transpose(1, 0, 2)
    answer = np.empty((rows.shape[0], 5), dtype=np.int64)
    for omitted in range(5):
        columns = [column for column in range(5) if column != omitted]
        value = determinant4(rows[:, :, columns], prime)
        answer[:, omitted] = value if omitted % 2 == 0 else -value
    return answer % prime


def direction_json(indices, multiplier):
    return {
        "dual_generator_indices": list(map(int, indices)),
        "multiplier": invariant_json(multiplier),
        "circuit": (
            "multiplier times the signed 4x4 maximal minors of the four "
            "listed dual Reynolds covariants"
        ),
    }


def select_cross_basis(
    target: int, expected: int, generators, values: np.ndarray,
    points: np.ndarray, prime: int, fixed=None,
):
    degrees = [int(record["degree"]) for record in generators]
    echelon = Echelon(prime)
    selected = []
    selected_values = []
    candidates = 0
    if fixed is None:
        for indices in itertools.combinations(range(len(generators)), 4):
            residual = target - sum(degrees[index] for index in indices)
            if residual < 0:
                continue
            cross = cross4(values, indices, prime)
            for label in invariant_labels(residual):
                candidates += 1
                scalar = evaluate_polynomial(invariant_polynomial(label), points, prime)
                value = cross * scalar[:, None] % prime
                if echelon.add(value.reshape(-1)):
                    selected.append(direction_json(indices, label))
                    selected_values.append(value)
                    if len(selected) == expected:
                        break
            if len(selected) == expected:
                break
    else:
        for record in fixed:
            indices = tuple(map(int, record["dual_generator_indices"]))
            label_record = record["multiplier"]
            label = (
                int(label_record["secondary_index"]),
                tuple(map(int, label_record["primary_exponents"])),
            )
            value = cross4(values, indices, prime)
            scalar = evaluate_polynomial(invariant_polynomial(label), points, prime)
            value = value * scalar[:, None] % prime
            assert echelon.add(value.reshape(-1))
            selected.append(record)
            selected_values.append(value)
    assert len(selected) == len(echelon) == expected
    matrix = np.asarray(selected_values).transpose(1, 2, 0).reshape(-1, expected)
    rows = rank_profile(matrix, prime)
    assert len(rows) == expected
    return selected, matrix, rows, candidates


def evaluate_fixed_crosses(
    records, values: np.ndarray, points: np.ndarray, prime: int
) -> np.ndarray:
    columns = []
    for record in records:
        indices = tuple(map(int, record["dual_generator_indices"]))
        multiplier = record["multiplier"]
        label = (
            int(multiplier["secondary_index"]),
            tuple(map(int, multiplier["primary_exponents"])),
        )
        vector = cross4(values, indices, prime)
        scalar = evaluate_polynomial(invariant_polynomial(label), points, prime)
        columns.append(vector * scalar[:, None] % prime)
    return np.asarray(columns).transpose(1, 2, 0).reshape(-1, len(records))


def full_seed_evaluations(module, records, points: np.ndarray, prime: int):
    transformed = np.einsum("gij,pj->pgi", module.GROUP, points) % prime
    powers = {}
    columns = []
    for record in records:
        values = np.ones(transformed.shape[:2], dtype=np.int64)
        for coordinate, exponent in enumerate(record["exponents"]):
            key = coordinate, int(exponent)
            if exponent and key not in powers:
                power = np.ones(transformed.shape[:2], dtype=np.int64)
                for _ in range(int(exponent)):
                    power = power * transformed[:, :, coordinate] % prime
                powers[key] = power
            if exponent:
                values = values * powers[key] % prime
        output = int(record["output"])
        columns.append((values @ module.INVERSES[:, :, output] % prime).reshape(-1))
    return np.column_stack(columns)


def nullspace_rows_small(matrix: np.ndarray, prime: int):
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    pivots = []
    row = 0
    for column in range(value.shape[1]):
        choices = np.flatnonzero(value[row:, column])
        if not len(choices):
            continue
        pivot = row + int(choices[0])
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
        for other in range(value.shape[0]):
            if other != row and value[other, column]:
                value[other] = (value[other] - value[other, column] * value[row]) % prime
        pivots.append(column)
        row += 1
        if row == value.shape[0]:
            break
    free = [column for column in range(value.shape[1]) if column not in pivots]
    answer = np.zeros((len(free), value.shape[1]), dtype=np.int64)
    for index, column in enumerate(free):
        answer[index, column] = 1
        for pivot_row, pivot_column in enumerate(pivots):
            answer[index, pivot_column] = -value[pivot_row, column] % prime
    return answer


def plus_basis(module, prime: int):
    matrix = (np.asarray(module.A, dtype=np.int64) - np.eye(5, dtype=np.int64)) % prime
    basis = nullspace_rows_small(matrix, prime)
    assert basis.shape == (3, 5)
    return basis


def plane_points(plus: np.ndarray, degree: int, prime: int):
    coefficients = np.asarray(
        [(1, i, j) for i in range(degree + 1) for j in range(degree + 1 - i)],
        dtype=np.int64,
    )
    return coefficients @ plus % prime


def main() -> None:
    points = fixed_points(80)
    full_points = fixed_points(140)
    prime_data = {}
    fixed_generators = None
    fixed_crosses = {}
    fixed_rows = {}
    fixed_full_rows = {}
    for prime, zeta in PRIMES.items():
        module = module_at(prime, zeta)
        evaluator = DualEvaluator(module, points, prime)
        generators, generator_values, dual_ledger = select_dual_generators(
            module, evaluator, fixed_generators
        )
        if fixed_generators is None:
            fixed_generators = generators
        prime_record = {
            "prime": prime,
            "zeta11": zeta,
            "dual_hironaka_ledger": dual_ledger,
            "degrees": {},
        }
        for target, (full_dimension, kernel_dimension, restriction_rank) in TARGETS.items():
            directory = HERE / f"degree_{target}"
            directory.mkdir(exist_ok=True)
            source = OLD / f"degree_{target}" / "covariant_basis_seeds.json"
            circuits = directory / "full_reynolds_circuits.json"
            if not circuits.exists():
                shutil.copyfile(source, circuits)
            full_records = json.loads(circuits.read_text())
            assert len(full_records) == full_dimension
            full_evaluations = full_seed_evaluations(
                module, full_records, full_points % prime, prime
            )
            full_rank = rank_mod(full_evaluations, prime)
            assert full_rank == full_dimension
            if target not in fixed_full_rows:
                fixed_full_rows[target] = rank_profile(full_evaluations, prime)
            assert len(fixed_full_rows[target]) == full_dimension
            assert rank_mod(
                full_evaluations[fixed_full_rows[target]], prime
            ) == full_dimension

            selected, cross_matrix, cross_rows, candidate_count = select_cross_basis(
                target, kernel_dimension, generators, generator_values,
                points % prime, prime, fixed_crosses.get(target),
            )
            if target not in fixed_crosses:
                fixed_crosses[target] = selected
                fixed_rows[target] = cross_rows
            assert rank_mod(cross_matrix[fixed_rows[target]], prime) == kernel_dimension

            plus = plus_basis(module, prime)
            restriction_points = plane_points(plus, target, prime)
            restriction = full_seed_evaluations(
                module, full_records, restriction_points, prime
            )
            actual_restriction_rank = rank_mod(restriction, prime)
            assert actual_restriction_rank == restriction_rank
            # Coefficient-exact at this fibre: the full degree-d triangular grid.
            dual_plane = DualEvaluator(module, restriction_points, prime)
            dual_plane_values = evaluate_fixed_dual_generators(
                dual_plane, fixed_generators
            )
            plane_cross_matrix = evaluate_fixed_crosses(
                selected, dual_plane_values, restriction_points, prime
            )
            assert not np.any(plane_cross_matrix)

            payload = directory / f"basis_holdout_p{prime}.npz"
            np.savez_compressed(
                payload,
                fixed_points=(points % prime).astype(np.uint16),
                cross_evaluations=cross_matrix.astype(np.uint16),
                fixed_cross_minor_rows=fixed_rows[target].astype(np.int32),
                full_basis_minor_rows=fixed_full_rows[target].astype(np.int32),
                plus_basis=plus.astype(np.uint16),
            )
            prime_record["degrees"][str(target)] = {
                "full_dimension": full_dimension,
                "full_basis_rank": full_rank,
                "fixed_full_minor_rank": rank_mod(
                    full_evaluations[fixed_full_rows[target]], prime
                ),
                "restriction_rank": actual_restriction_rank,
                "restriction_kernel_upper_bound": full_dimension - actual_restriction_rank,
                "cross_basis_rank": rank_mod(cross_matrix, prime),
                "fixed_cross_minor_rank": rank_mod(
                    cross_matrix[fixed_rows[target]], prime
                ),
                "plane_grid_cross_rank": rank_mod(plane_cross_matrix, prime),
                "candidate_directions_examined_at_selection_prime": candidate_count,
                "payload": payload.name,
                "payload_sha256": sha256(payload),
            }
            print(
                f"target={target} p={prime} restriction={actual_restriction_rank} "
                f"cross={kernel_dimension} plane=0",
                flush=True,
            )
        prime_data[str(prime)] = prime_record

    generators_path = HERE / "dual_hironaka_generators.json"
    generators_path.write_text(json.dumps({
        "schema": "cov-dual-hironaka-reynolds-v1",
        "field": "Q(zeta_11)",
        "denominator_hsop_degrees": list(PRIMARY_WEIGHTS),
        "exact_hironaka_numerator": {str(k): v for k, v in DUAL_SUPPORT.items()},
        "reynolds_rule": "q(x)=sum_(g in G) (g*x)^alpha g^T e_j",
        "generators": fixed_generators,
    }, indent=2, sort_keys=True) + "\n")

    degrees = {}
    for target, (full_dimension, kernel_dimension, restriction_rank) in TARGETS.items():
        directory = HERE / f"degree_{target}"
        cross_path = directory / "m1_cross_basis_circuits.json"
        cross_path.write_text(json.dumps({
            "schema": "cov-m1-four-dual-cross-basis-v1",
            "degree": target,
            "dimension": kernel_dimension,
            "dual_generators": "../dual_hironaka_generators.json",
            "basis": fixed_crosses[target],
            "fixed_evaluation_points": points.tolist(),
            "fixed_maximal_minor_rows": fixed_rows[target].tolist(),
            "exact_vanishing_proof": (
                "For x fixed by an involution t, every dual covariant q satisfies "
                "q(x)=t^(-T)q(x), so four q-values lie in the 3-dimensional dual "
                "plus-space. Their generalized cross is zero. Equivariance gives "
                "all 55 planes."
            ),
            "exact_completeness_proof": (
                "The fixed cross minor is nonzero after good reduction, giving "
                f"{kernel_dimension} independent characteristic-zero vectors in K1. "
                "The fixed full Reynolds restriction has rank "
                f"{restriction_rank} after good reduction, so characteristic-zero "
                f"nullity is at most {full_dimension}-{restriction_rank}={kernel_dimension}."
            ),
        }, indent=2, sort_keys=True) + "\n")
        full_path = directory / "full_reynolds_circuits.json"
        degrees[str(target)] = {
            "full_dimension": full_dimension,
            "m1_dimension": kernel_dimension,
            "full_basis": str(full_path.relative_to(HERE)),
            "full_basis_sha256": sha256(full_path),
            "m1_basis": str(cross_path.relative_to(HERE)),
            "m1_basis_sha256": sha256(cross_path),
        }

    manifest = {
        "schema": "cov-m1-canonical-bases-v2",
        "field": "K=Q(zeta_11), Phi_11(zeta_11)=0",
        "integral_open": (
            "O=Z[zeta_11,1/(660*Delta_dual*Delta_full31*Delta_m1_31*"
            "Delta_full35*Delta_m1_35)]. Each Delta is the determinant circuit "
            "defined by the fixed integral points and fixed maximal-minor rows "
            "in this packet; its reductions at 419 and 463 are nonzero."
        ),
        "unused_good_primes": list(PRIMES),
        "dual_generators": generators_path.name,
        "dual_generators_sha256": sha256(generators_path),
        "degrees": degrees,
        "prime_records": prime_data,
    }
    output = HERE / "canonical_bases.json"
    output.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    print("COV_M1_CANONICAL_BASES_PRODUCED", flush=True)


if __name__ == "__main__":
    main()
