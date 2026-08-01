#!/usr/bin/env python3
"""Produce exact dual-Reynolds wedge bases for the degree-31/35 K1 spaces.

The cross-covariant module N=(K[W] tensor W*)^G is free over the invariant
hsop of degrees 3,5,6,8,11 with the 60-generator Hironaka numerator below.
We select fixed Reynolds seed circuits for those generators simultaneously at
two unused split primes.  Wedges of four dual covariants, multiplied by the
fixed Hironaka invariant basis, are self-covariants.  They vanish on every
involution plus-plane because four vectors in the three-dimensional fixed
subspace of W* are dependent.

The output is a fixed characteristic-zero circuit basis: independence after
one good reduction supplies a nonzero maximal minor, while the independently
computed reduction of the full restriction map supplies the matching upper
bound.  The second prime is a holdout, not a source of basis changes.
"""

from __future__ import annotations

import ctypes
from dataclasses import dataclass
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OLD = HERE.parent / "COV_STRUCTURED_SEARCH"
sys.path.insert(0, str(ROOT / "tmp" / "generic_twist"))
sys.path.insert(0, str(ROOT / "tmp" / "kproj_arithmetic"))

import core  # noqa: E402
import phi_coefficients as phi  # noqa: E402


FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"
PRIMES = {419: 13, 463: 15}
TARGETS = {31: (410, 198), 35: (637, 361)}
POINT_COUNT = 84
SUPPORT = {
    2: 1, 4: 1, 5: 1, 6: 2, 7: 2, 8: 2, 9: 3, 10: 3,
    11: 4, 12: 3, 13: 5, 14: 5, 15: 4, 16: 5, 17: 4,
    18: 4, 19: 2, 20: 4, 21: 1, 22: 1, 23: 1, 24: 1, 27: 1,
}


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
    wrapper = load(
        f"dual_wedge_reconstructor_{prime}",
        ROOT / "tmp" / "degree13_opt" / "reconstruct_large_prime.py",
    )
    return wrapper.load_module(prime, zeta)


def rank_profile(name: str, matrix: np.ndarray, prime: int) -> np.ndarray:
    value = np.array(matrix, dtype=np.float64, order="C", copy=True)
    pointer = ctypes.POINTER(ctypes.c_size_t)()
    function = getattr(ctypes.CDLL(FFPACK), name)
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_double),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_size_t)),
        ctypes.c_int,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rank = int(
        function(
            float(prime),
            *value.shape,
            value.ctypes.data_as(ctypes.POINTER(ctypes.c_double)),
            value.shape[1],
            ctypes.byref(pointer),
            2,
            True,
        )
    )
    answer = np.ctypeslib.as_array(pointer, shape=(rank,)).copy().astype(np.int64)
    libc = ctypes.CDLL(None)
    libc.free.argtypes = [ctypes.c_void_p]
    libc.free(pointer)
    return answer


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    return len(rank_profile("RowRankProfile_modular_double", matrix, prime))


@dataclass
class Echelon:
    prime: int
    rows: list[tuple[int, np.ndarray]]

    @classmethod
    def empty(cls, prime: int):
        return cls(prime, [])

    def reduce(self, row: np.ndarray):
        remainder = np.asarray(row, dtype=np.int64).copy() % self.prime
        for pivot, basis in self.rows:
            if remainder[pivot]:
                remainder = (remainder - remainder[pivot] * basis) % self.prime
        nonzero = np.flatnonzero(remainder)
        if not len(nonzero):
            return None
        pivot = int(nonzero[0])
        remainder = remainder * pow(int(remainder[pivot]), -1, self.prime) % self.prime
        return pivot, remainder

    def append(self, reduced) -> None:
        assert reduced is not None
        self.rows.append(reduced)


def generic_points(count: int):
    state = 20260802006035
    answer = []
    for _ in range(count):
        point = []
        for _ in range(5):
            state = (6364136223846793005 * state + 1442695040888963407) % (1 << 64)
            point.append((state >> 24) % 251)
        answer.append(point)
    return np.asarray(answer, dtype=np.int64)


class Evaluator:
    def __init__(self, module, prime: int, points: np.ndarray):
        self.module = module
        self.prime = prime
        self.points = np.asarray(points, dtype=np.int64) % prime
        self.transformed = np.einsum(
            "gij,pj->pgi", np.asarray(module.GROUP, dtype=np.int64), self.points
        ) % prime
        self.power_cache = {}
        self.seed_cache = {}
        self.polynomial_cache = {}

    def power(self, coordinate: int, exponent: int):
        key = coordinate, exponent
        if key not in self.power_cache:
            value = np.ones(self.transformed.shape[:2], dtype=np.int64)
            for _ in range(exponent):
                value = value * self.transformed[:, :, coordinate] % self.prime
            self.power_cache[key] = value
        return self.power_cache[key]

    def dual_seed(self, output: int, exponents: tuple[int, ...]):
        key = output, exponents
        if key not in self.seed_cache:
            values = np.ones(self.transformed.shape[:2], dtype=np.int64)
            for coordinate, exponent in enumerate(exponents):
                if exponent:
                    values = values * self.power(coordinate, exponent) % self.prime
            # q(hx)=h^{-T}q(x): q=sum_g g^T e_output (gx)^alpha.
            result = values @ np.asarray(
                self.module.GROUP[:, output, :], dtype=np.int64
            ) % self.prime
            self.seed_cache[key] = result
        return self.seed_cache[key]

    def polynomial(self, polynomial):
        key = id(polynomial)
        if key not in self.polynomial_cache:
            values = np.zeros(len(self.points), dtype=np.int64)
            for exponents, coefficient in polynomial.items():
                term = np.full(len(self.points), int(coefficient) % self.prime, dtype=np.int64)
                for coordinate, exponent in enumerate(exponents):
                    if exponent:
                        term = term * np.asarray(
                            [pow(int(x), int(exponent), self.prime)
                             for x in self.points[:, coordinate]],
                            dtype=np.int64,
                        ) % self.prime
                values = (values + term) % self.prime
            self.polynomial_cache[key] = values
        return self.polynomial_cache[key]


def primary_monomials(degree: int):
    return [
        (tuple(map(int, exponents)), core.primary_monomial(exponents))
        for exponents in core.weighted_exponents(degree)
    ]


def cross_module_dimension(degree: int) -> int:
    return sum(
        multiplicity * len(core.weighted_exponents(degree - source_degree))
        for source_degree, multiplicity in SUPPORT.items()
        if source_degree <= degree
    )


def select_dual_generators(evaluators: dict[int, Evaluator]):
    generators = []
    for degree in range(25):
        new_count = SUPPORT.get(degree, 0)
        if not new_count:
            continue
        echelons = {prime: Echelon.empty(prime) for prime in evaluators}
        known_count = 0
        for generator in generators:
            residual = degree - generator["degree"]
            if residual < 0:
                continue
            for _label, polynomial in primary_monomials(residual):
                known_count += 1
                for prime, evaluator in evaluators.items():
                    seed = evaluator.dual_seed(
                        generator["output"], tuple(generator["exponents"])
                    )
                    values = seed * evaluator.polynomial(polynomial)[:, None] % prime
                    reduced = echelons[prime].reduce(values.reshape(-1))
                    assert reduced is not None
                    echelons[prime].append(reduced)
        expected_known = cross_module_dimension(degree) - new_count
        assert known_count == expected_known
        assert all(len(echelon.rows) == expected_known for echelon in echelons.values())

        selected_here = 0
        candidates_tested = 0
        reference = next(iter(evaluators.values())).module
        for exponents in reference.monomials(degree):
            exponents = tuple(map(int, exponents))
            for output in range(5):
                candidates_tested += 1
                reduced = {
                    prime: echelons[prime].reduce(
                        evaluator.dual_seed(output, exponents).reshape(-1)
                    )
                    for prime, evaluator in evaluators.items()
                }
                if not all(value is not None for value in reduced.values()):
                    continue
                for prime in evaluators:
                    echelons[prime].append(reduced[prime])
                generators.append({
                    "index": len(generators),
                    "degree": degree,
                    "output": output,
                    "exponents": list(exponents),
                })
                selected_here += 1
                if selected_here == new_count:
                    break
            if selected_here == new_count:
                break
        assert selected_here == new_count
        expected_full = cross_module_dimension(degree)
        assert all(len(echelon.rows) == expected_full for echelon in echelons.values())
        print(
            f"dual degree={degree} known={known_count} new={new_count} "
            f"full={expected_full} candidates={candidates_tested}",
            flush=True,
        )
    assert len(generators) == sum(m for d, m in SUPPORT.items() if d <= 24) == 59
    return generators


def invariant_labels(degree: int):
    labels = []
    for secondary, secondary_degree in enumerate(core.SECONDARY_DEGREES):
        if secondary_degree <= degree:
            for exponents in core.weighted_exponents(degree - secondary_degree):
                labels.append((secondary, tuple(map(int, exponents))))
    return labels


def invariant_polynomial(label):
    secondary, exponents = label
    return phi.multiply(
        core.primary_monomial(exponents), core.secondary_polynomials()[secondary]
    )


def label_json(label):
    secondary, exponents = label
    return {
        "secondary_index": int(secondary),
        "secondary_name": core.SECONDARY_NAMES[secondary],
        "secondary_degree": int(core.SECONDARY_DEGREES[secondary]),
        "primary_exponents": list(exponents),
    }


def determinant4(values: np.ndarray, prime: int):
    # values shape point x 4 x 4.
    result = np.zeros(len(values), dtype=np.int64)
    for permutation in itertools.permutations(range(4)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(4) for j in range(i + 1, 4)
        )
        term = np.ones(len(values), dtype=np.int64)
        for row, column in enumerate(permutation):
            term = term * values[:, row, column] % prime
        result = (result - term if inversions % 2 else result + term) % prime
    return result


def wedge4(rows: np.ndarray, prime: int):
    # rows shape point x 4 x 5; identify wedge^4 W* with W by volume.
    answer = np.empty((len(rows), 5), dtype=np.int64)
    for omitted in range(5):
        columns = [column for column in range(5) if column != omitted]
        value = determinant4(rows[:, :, columns], prime)
        answer[:, omitted] = value if omitted % 2 == 0 else -value % prime
    return answer % prime


def all_directions(target: int, generators):
    directions = []
    for indices in itertools.combinations(range(len(generators)), 4):
        residual = target - sum(generators[index]["degree"] for index in indices)
        if residual < 0:
            continue
        for label in invariant_labels(residual):
            directions.append((indices, label))
    return directions


def direction_matrices(target, generators, evaluators, directions):
    matrices = {
        prime: np.empty((POINT_COUNT * 5, len(directions)), dtype=np.uint16)
        for prime in evaluators
    }
    generator_values = {
        prime: [
            evaluator.dual_seed(item["output"], tuple(item["exponents"]))
            for item in generators
        ]
        for prime, evaluator in evaluators.items()
    }
    polynomial_cache = {}
    wedge_cache = {prime: {} for prime in evaluators}
    for column, (indices, label) in enumerate(directions):
        if label not in polynomial_cache:
            polynomial_cache[label] = invariant_polynomial(label)
        polynomial = polynomial_cache[label]
        for prime, evaluator in evaluators.items():
            if indices not in wedge_cache[prime]:
                rows = np.stack(
                    [generator_values[prime][index] for index in indices], axis=1
                )
                wedge_cache[prime][indices] = wedge4(rows, prime)
            values = (
                wedge_cache[prime][indices]
                * evaluator.polynomial(polynomial)[:, None]
                % prime
            )
            matrices[prime][:, column] = values.reshape(-1).astype(np.uint16)
        if (column + 1) % 1000 == 0:
            print(f"degree={target} built directions={column + 1}/{len(directions)}", flush=True)
    return matrices


def main() -> None:
    points = generic_points(POINT_COUNT)
    modules = {prime: module_at(prime, zeta) for prime, zeta in PRIMES.items()}
    evaluators = {
        prime: Evaluator(modules[prime], prime, points) for prime in PRIMES
    }
    generators = select_dual_generators(evaluators)
    generator_path = HERE / "dual_hironaka_generators.json"
    generator_path.write_text(json.dumps({
        "schema": "cov-dual-reynolds-hironaka-v1",
        "field": "Q(zeta_11)",
        "hsop_degrees": list(core.PRIMARY_DEGREES),
        "numerator": {str(key): value for key, value in SUPPORT.items()},
        "generator_count": len(generators),
        "generators_used_through_degree_24": generators,
        "degree_27_generator_not_needed_for_targets_31_35": SUPPORT[27],
        "reynolds_rule": (
            "q_(j,alpha)(x)=sum_g g^T e_j (g x)^alpha; "
            "q(hx)=h^(-T)q(x)"
        ),
        "simultaneous_selection_primes": list(PRIMES),
        "selection_points": points.tolist(),
    }, indent=2, sort_keys=True) + "\n")

    summary = {
        "schema": "cov-m1-dual-wedge-bases-v1",
        "dual_generators": generator_path.name,
        "dual_generators_sha256": sha256(generator_path),
        "primes": PRIMES,
        "degrees": {},
    }
    for target, (full_dimension, kernel_dimension) in TARGETS.items():
        directions = all_directions(target, generators)
        print(f"degree={target} candidate_directions={len(directions)}", flush=True)
        matrices = direction_matrices(
            target, generators, evaluators, directions
        )
        first_prime = next(iter(PRIMES))
        # The FFPACK column-profile C entry point has a transposed leading-
        # dimension convention.  A row profile of the literal transpose is
        # the same mathematical object and is independently checked below.
        profile = rank_profile(
            "RowRankProfile_modular_double", matrices[first_prime].T, first_prime
        )
        print(
            f"degree={target} wedge_rank_p{first_prime}={len(profile)} "
            f"expected={kernel_dimension}",
            flush=True,
        )
        assert len(profile) == kernel_dimension, (target, len(profile), kernel_dimension)
        selected = profile[:kernel_dimension]
        prime_records = []
        directory = HERE / f"degree_{target}"
        directory.mkdir(exist_ok=True)
        for prime in PRIMES:
            full_rank = rank_mod(matrices[prime], prime)
            selected_rank = rank_mod(matrices[prime][:, selected], prime)
            assert full_rank == selected_rank == kernel_dimension
            output = directory / f"dual_wedge_basis_p{prime}.npz"
            np.savez_compressed(
                output,
                generic_points=points.astype(np.uint16),
                selected_direction_indices=selected.astype(np.int32),
                selected_evaluations=matrices[prime][:, selected].astype(np.uint16),
            )
            prime_records.append({
                "prime": prime,
                "zeta11": PRIMES[prime],
                "candidate_direction_rank": full_rank,
                "fixed_selected_basis_rank": selected_rank,
                "payload": output.name,
                "payload_sha256": sha256(output),
            })
        basis_records = []
        for basis_index, direction_index in enumerate(selected):
            indices, label = directions[int(direction_index)]
            basis_records.append({
                "basis_index": basis_index,
                "candidate_direction_index": int(direction_index),
                "dual_generator_indices": list(indices),
                "dual_generator_degrees": [generators[index]["degree"] for index in indices],
                "multiplier": label_json(label),
                "multiplier_degree": target - sum(generators[index]["degree"] for index in indices),
            })
        basis_path = directory / "fixed_m1_dual_wedge_basis.json"
        basis_path.write_text(json.dumps({
            "schema": "cov-m1-dual-wedge-circuit-basis-v1",
            "degree": target,
            "dimension": kernel_dimension,
            "candidate_direction_count": len(directions),
            "basis": basis_records,
            "formula": (
                "p=I_beta * star(q_i1 wedge q_i2 wedge q_i3 wedge q_i4), "
                "with q_i the fixed dual Reynolds circuits"
            ),
            "plane_vanishing_proof": (
                "For x fixed by an involution t, q_i(x) lies in the +1 space "
                "of t^(-T), which has dimension 3. Hence every displayed "
                "four-fold wedge vanishes. Equivariance covers all 55 planes."
            ),
            "independence_proof": (
                "The fixed selected evaluation minor has full column rank at "
                "both unused good primes; in particular its determinant is a "
                "nonzero reduction of a characteristic-zero minor."
            ),
            "prime_records": prime_records,
        }, indent=2, sort_keys=True) + "\n")
        summary["degrees"][str(target)] = {
            "full_self_covariant_dimension": full_dimension,
            "m1_dimension": kernel_dimension,
            "basis": str(basis_path.relative_to(HERE)),
            "basis_sha256": sha256(basis_path),
            "prime_records": prime_records,
        }
        print(
            f"degree={target} fixed_wedge_basis={kernel_dimension} "
            f"holdout_primes={list(PRIMES)}",
            flush=True,
        )
    output = HERE / "dual_wedge_bases.json"
    output.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print("COV_M1_DUAL_WEDGE_BASES_PRODUCED")


if __name__ == "__main__":
    main()
