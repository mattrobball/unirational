#!/usr/bin/env python3
"""Exact finite-field reconnaissance for the lossless S19 Hankel compression.

The modular output is discovery evidence only.  A rank drop reconstructs a
degree-19 interpolation map over the chosen finite field; full S19 status
would still require characteristic-zero lifting, descent, and safeguards.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
import random
from collections import Counter
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
FAMILY = HERE.parent / "CODEX_ROOT_20260801_7B4E" / "universal_marked_family.json"
OUTPUT = HERE / "hankel_probe.json"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def cyclotomic_mod(coefficients, zeta, prime):
    return sum(int(coefficient) * pow(zeta, exponent, prime)
               for exponent, coefficient in enumerate(coefficients)) % prime


def rref_mod(matrix, prime):
    array = np.array(matrix, dtype=np.int64) % prime
    rows, columns = array.shape
    pivot_columns = []
    pivot_row = 0
    for column in range(columns):
        possible = np.flatnonzero(array[pivot_row:, column])
        if not len(possible):
            continue
        selected = pivot_row + int(possible[0])
        if selected != pivot_row:
            array[[pivot_row, selected]] = array[[selected, pivot_row]]
        array[pivot_row] = array[pivot_row] * pow(int(array[pivot_row, column]), -1, prime) % prime
        factors = array[:, column].copy()
        factors[pivot_row] = 0
        active = np.flatnonzero(factors)
        if len(active):
            array[active] = (array[active] - factors[active, None] * array[pivot_row]) % prime
        pivot_columns.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    return array, pivot_columns


def rank_mod(matrix, prime):
    return len(rref_mod(matrix, prime)[1])


def nullspace_mod(matrix, prime):
    reduced, pivots = rref_mod(matrix, prime)
    free = [column for column in range(reduced.shape[1]) if column not in pivots]
    basis = []
    for free_column in free:
        vector = np.zeros(reduced.shape[1], dtype=np.int64)
        vector[free_column] = 1
        for row, pivot in reversed(list(enumerate(pivots))):
            vector[pivot] = -reduced[row, free_column] % prime
        basis.append(vector)
    return basis


def monomial_exponents(variables, degree):
    answer = []
    for total in range(degree + 1):
        def visit(prefix, left, remaining):
            if left == 1:
                answer.append(tuple(prefix + [remaining]))
                return
            for exponent in range(remaining + 1):
                visit(prefix + [exponent], left - 1, remaining - exponent)
        visit([], variables, total)
    return answer


def evaluation_rank(points, degree, prime):
    exponents = [exponent for exponent in monomial_exponents(4, degree) if sum(exponent) == degree]
    matrix = []
    for point in points:
        matrix.append([
            math.prod(pow(point[index], exponent[index], prime) for index in range(4)) % prime
            for exponent in exponents
        ])
    return rank_mod(matrix, prime)


def build_points(payload, prime, zeta, hyperplane):
    points = []
    line_pairs = []
    for line in payload["lines"]:
        u = [cyclotomic_mod(coefficient, zeta, prime) for coefficient in line["u"]]
        v = [cyclotomic_mod(coefficient, zeta, prime) for coefficient in line["v"]]
        a = sum(hyperplane[index] * u[index] for index in range(5)) % prime
        b = sum(hyperplane[index] * v[index] for index in range(5)) % prime
        if not a and not b:
            raise ValueError("hyperplane contains an orbit line")
        point = [(b * u[index] - a * v[index]) % prime for index in range(5)]
        points.append(point[:4])
        line_pairs.append((b, -a % prime))
    return points, line_pairs


def projective_key(vector, prime):
    pivot = next((index for index, value in enumerate(vector) if value % prime), None)
    if pivot is None:
        raise ValueError("zero projective vector")
    inverse = pow(int(vector[pivot]), -1, prime)
    return tuple(int(value) * inverse % prime for value in vector)


def choose_nonvanishing_coordinate(points, prime):
    # The last coefficient must be nonzero so (y0,p0,p1,p2) is a GL4 change.
    for bound in range(2, 8):
        for coefficients in itertools.product(range(bound), repeat=4):
            if coefficients == (0, 0, 0, 0) or not coefficients[3]:
                continue
            values = [sum(coefficients[j] * point[j] for j in range(4)) % prime for point in points]
            if all(values):
                return list(coefficients), values
    raise ValueError("no small propagation coordinate found")


def derivative_weights(tau, prime):
    weights = []
    for index, value in enumerate(tau):
        derivative = 1
        for other_index, other in enumerate(tau):
            if other_index != index:
                derivative = derivative * (value - other) % prime
        if not derivative:
            raise ValueError("source parameters are not distinct")
        weights.append(pow(int(derivative), -1, prime))
    return np.array(weights, dtype=np.int64)


def hankel_matrix(points, y0, tau, prime):
    """Return the 105x20 lossless incidence matrix H(tau)."""
    if len(set(map(int, tau))) != 55:
        raise ValueError("source parameters are not distinct")
    tau = np.array(tau, dtype=np.int64) % prime
    weights = derivative_weights(tau, prime)
    powers = np.ones((55, 54), dtype=np.int64)
    for exponent in range(1, 54):
        powers[:, exponent] = powers[:, exponent - 1] * tau % prime
    inverse_y0 = np.array([pow(int(value), -1, prime) for value in y0], dtype=np.int64)
    ratios = np.array([[point[j] for point in points] for j in range(3)], dtype=np.int64)
    ratios = ratios * inverse_y0[None, :] % prime
    moments = ((ratios * weights[None, :]) @ powers) % prime
    rows = [moments[coordinate, moment:moment + 20]
            for coordinate in range(3) for moment in range(35)]
    return np.array(rows, dtype=np.int64)


def polynomial_values(coefficients, tau, prime):
    values = []
    for value in tau:
        accumulator = 0
        for coefficient in reversed(coefficients):
            accumulator = (accumulator * int(value) + int(coefficient)) % prime
        values.append(accumulator)
    return values


def interpolate_degree_19(tau, values, prime):
    vandermonde = [[pow(int(tau[row]), column, prime) for column in range(20)]
                   for row in range(20)]
    augmented = [vandermonde[row] + [int(values[row]) % prime] for row in range(20)]
    reduced, pivots = rref_mod(augmented, prime)
    if pivots[:20] != list(range(20)):
        raise ValueError("singular interpolation block")
    coefficients = [int(reduced[row, 20]) for row in range(20)]
    if polynomial_values(coefficients, tau, prime) != [int(value) % prime for value in values]:
        raise ValueError("values do not interpolate in degree 19")
    return coefficients


def reconstruct_candidate(points, y0_coefficients, y0, tau, hankel, prime):
    kernels = nullspace_mod(hankel, prime)
    if not kernels:
        return None
    q = [int(value) for value in kernels[0]]
    q_values = polynomial_values(q, tau, prime)
    if not all(q_values):
        return {"rejected": "the selected kernel polynomial vanishes at a marked parameter"}
    inverse_y0 = [pow(int(value), -1, prime) for value in y0]
    scales = [q_values[i] * inverse_y0[i] % prime for i in range(55)]
    coordinate_values = [[scales[i] * points[i][j] % prime for i in range(55)] for j in range(4)]
    forms = [interpolate_degree_19(tau, values, prime) for values in coordinate_values]
    for i in range(55):
        assert all(polynomial_values(forms[j], [tau[i]], prime)[0] == coordinate_values[j][i]
                   for j in range(4))
    return {
        "q_y0_coefficients_low_to_high": q,
        "source_parameters": list(map(int, tau)),
        "point_scales": scales,
        "map_forms_original_coordinates_low_to_high": forms,
        "target_y0_coefficients": y0_coefficients,
        "scope": "finite-field incidence candidate only; safeguards and characteristic-zero lift remain mandatory",
    }


def normalized_affine_points(points, y0, prime):
    return [[point[j] * pow(y0[i], -1, prime) % prime for j in range(3)]
            for i, point in enumerate(points)]


def evaluate_random_polynomial(affine_points, exponents, rng, prime):
    coefficients = [rng.randrange(prime) for _ in exponents]
    return [
        sum(coefficients[column] * math.prod(pow(point[j], exponent[j], prime) for j in range(3))
            for column, exponent in enumerate(exponents)) % prime
        for point in affine_points
    ]


def evaluate_random_rational_function(affine_points, exponents, rng, prime):
    numerator = evaluate_random_polynomial(affine_points, exponents, rng, prime)
    denominator = evaluate_random_polynomial(affine_points, exponents, rng, prime)
    if not all(denominator):
        return None
    return [numerator[i] * pow(int(denominator[i]), -1, prime) % prime
            for i in range(len(affine_points))]


def run_probe(prime, zeta, trials, seed):
    payload = json.loads(FAMILY.read_text())
    hyperplane = [value % prime for value in payload["good_open"]["hyperplane_witness"]]
    points, line_pairs = build_points(payload, prime, zeta, hyperplane)
    if len({projective_key(point, prime) for point in points}) != 55:
        raise ValueError("the witness does not give 55 distinct points at this prime")
    hilbert_function = [evaluation_rank(points, degree, prime) for degree in range(7)]
    if hilbert_function != [1, 4, 10, 19, 31, 45, 55]:
        raise ValueError(f"bad Hilbert fibre: {hilbert_function}")
    y0_coefficients, y0 = choose_nonvanishing_coordinate(points, prime)
    affine_points = normalized_affine_points(points, y0, prime)
    rng = random.Random(seed)
    histogram = Counter()
    tested_by_family = Counter()
    rejected_nondistinct = Counter()
    rejected_undefined = Counter()
    best = None
    candidate = None

    def test(family, tau):
        nonlocal best, candidate
        tau = list(map(lambda value: int(value) % prime, tau))
        if len(set(tau)) != 55:
            rejected_nondistinct[family] += 1
            return
        matrix = hankel_matrix(points, y0, tau, prime)
        rank = rank_mod(matrix, prime)
        histogram[rank] += 1
        tested_by_family[family] += 1
        record = {"family": family, "rank": rank, "tau": tau}
        if best is None or (rank, family, tau) < (best["rank"], best["family"], best["tau"]):
            best = record
        if rank < 20 and candidate is None:
            candidate = reconstruct_candidate(points, y0_coefficients, y0, tau, matrix, prime)
            candidate["source_family"] = family
            candidate["hankel_rank"] = rank

    # Natural coordinate along each transported orbit line, with every affine chart tried.
    for chart in range(prime):
        if all((s + chart * t) % prime for s, t in line_pairs):
            test("transported_line_parameter", [t * pow((s + chart * t) % prime, -1, prime) % prime
                                                  for s, t in line_pairs])
            break

    # Deterministic random permutations ensure many points of the full distinct-parameter chart.
    base = list(range(55))
    for _ in range(trials):
        rng.shuffle(base)
        test("random_distinct_assignment", base)

    # Low-degree functions of the marked target configuration are a construction ansatz.
    for degree in range(1, 7):
        exponents = monomial_exponents(3, degree)
        for _ in range(trials // 2):
            tau = evaluate_random_polynomial(affine_points, exponents, rng, prime)
            test(f"target_polynomial_degree_le_{degree}", tau)

    # Ratios are materially broader than the affine-polynomial ansatz and
    # include arbitrary target linear projections to P1 at degree one.
    for degree in range(1, 5):
        exponents = monomial_exponents(3, degree)
        family = f"target_rational_degree_le_{degree}"
        for _ in range(trials // 2):
            tau = evaluate_random_rational_function(affine_points, exponents, rng, prime)
            if tau is None:
                rejected_undefined[family] += 1
            else:
                test(family, tau)

    return {
        "schema": "s19-hankel-incidence-probe-v2",
        "source_sha256": {"universal_marked_family.json": digest(FAMILY)},
        "prime": prime,
        "zeta11": zeta,
        "hyperplane": hyperplane,
        "hilbert_function_d0_to_6": hilbert_function,
        "nonvanishing_target_coordinate": y0_coefficients,
        "matrix_shape": [105, 20],
        "rank_drop_condition": "rank < 20",
        "trials_requested_per_full_random_family": trials,
        "seed": seed,
        "tested_distinct_by_family": dict(sorted(tested_by_family.items())),
        "rejected_nondistinct_by_family": dict(sorted(rejected_nondistinct.items())),
        "rejected_undefined_by_family": dict(sorted(rejected_undefined.items())),
        "rank_histogram": {str(rank): count for rank, count in sorted(histogram.items())},
        "best_tested_point": best,
        "candidate": candidate,
        "strict_scope": [
            "a full-rank sample does not prove characteristic-zero or geometric emptiness",
            "a modular rank drop would be discovery evidence until lifted and checked",
            "the random search is not substituted for the saturated incidence scheme",
        ],
        "terminal_marker": "S19_HANKEL_MODULAR_RECONNAISSANCE_COMPLETE",
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=397)
    parser.add_argument("--zeta", type=int, default=256)
    parser.add_argument("--trials", type=int, default=5000)
    parser.add_argument("--seed", type=int, default=190055)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    if arguments.prime % 11 != 1 or pow(arguments.zeta, 11, arguments.prime) != 1 or arguments.zeta % arguments.prime == 1:
        raise SystemExit("zeta must have exact order 11 modulo a prime congruent to 1 mod 11")
    payload = run_probe(arguments.prime, arguments.zeta, arguments.trials, arguments.seed)
    encoded = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if arguments.write:
        OUTPUT.write_text(encoded)
        print(f"wrote {OUTPUT}")
    if arguments.check:
        if OUTPUT.read_text() != encoded:
            raise SystemExit("hankel probe payload mismatch")
        print("S19_HANKEL_PROBE_REPRODUCES")
    if not arguments.write and not arguments.check:
        print(encoded, end="")
    print(payload["terminal_marker"])


if __name__ == "__main__":
    main()
