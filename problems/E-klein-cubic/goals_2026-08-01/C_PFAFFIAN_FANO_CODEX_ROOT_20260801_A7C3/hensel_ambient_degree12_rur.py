#!/usr/bin/env python3
"""Hensel-lift the three simple degree-12 ambient points at p=23.

The computation uses the exact Q(zeta_11) group records, reduced at all ten
23-adic cyclotomic embeddings.  In each embedding it:

* selects 47 independent Pluecker equations on the chart a47=1;
* Newton-lifts all three simple modular roots;
* checks all 15 Pluecker equations at eight fixed source points; and
* recovers the canonical cubic RUR by symmetric products/interpolation.

The ten conjugate RURs are then interpolated in the power basis
1,zeta,...,zeta^9 and rationally reconstructed.  No characteristic-zero
artifact is written unless all 1450 scalar coefficients reconstruct and
reduce back to the p-adic data.
"""

from __future__ import annotations

import argparse
import ast
import json
import math
import multiprocessing
import runpy
from fractions import Fraction
from itertools import combinations
from pathlib import Path

import probe_ambient_degree12_char0_lift as exact_probe


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P = 23
PAIRS = tuple(combinations(range(6), 2))
PAIR_INDEX = {pair: index for index, pair in enumerate(PAIRS)}
QUADRUPLES = tuple(combinations(range(6), 4))
POINTS = (
    (13, 9, 5, 5, 8),
    (19, 0, 19, 11, 17),
    (10, 21, 7, 15, 6),
    (1, 22, 20, 8, 14),
    (18, 7, 17, 9, 19),
    (12, 11, 17, 11, 16),
    (0, 1, 0, 6, 4),
    (18, 12, 3, 19, 16),
    (1, 19, 6, 14, 15),
    (18, 17, 6, 3, 4),
    (2, 12, 18, 18, 15),
    (22, 3, 15, 5, 13),
    (19, 1, 10, 10, 9),
    (3, 1, 19, 4, 6),
    (7, 6, 4, 5, 16),
    (2, 18, 18, 2, 19),
    (7, 20, 13, 12, 10),
    (3, 8, 20, 20, 22),
    (15, 7, 13, 17, 11),
    (18, 14, 5, 8, 1),
)

WORKER_EXACT_RECORDS = None
WORKER_SEEDS = None
WORKER_MODULUS = None
WORKER_PRECISION = None
WORKER_ACTIVE_POINTS = None


def load_modular_points(filename: str):
    outer = ast.literal_eval((HERE / filename).read_text().strip().rstrip(":"))
    assert outer[0] == 0
    data = outer[1]
    prime, variable_count, degree, names = data[:4]
    assert (prime, variable_count, degree) == (P, 48, 3)
    assert names == ["a47", *[f"a{i}" for i in range(1, 47)], "a0"]
    eliminant, denominator, blocks = data[5][1]
    assert denominator == [0, [1]] and len(blocks) == 47
    w = list(eliminant[1])
    roots = [value for value in range(P) if poly_eval(w, value, P) == 0]
    assert len(roots) == 3
    vectors = []
    for root in roots:
        coordinates = {"a0": root}
        for name, block in zip(names[:-1], blocks):
            coordinates[name] = -poly_eval(list(block[0][1]), root, P) % P
        vector = [coordinates[f"a{i}"] for i in range(48)]
        assert vector[47] == 1
        vectors.append(vector)
    return names, w, roots, vectors


def poly_eval(coefficients, value, modulus):
    result = 0
    for coefficient in reversed(coefficients):
        result = (result * value + coefficient) % modulus
    return result


def lift_root_of_unity(residue: int, precision: int) -> int:
    modulus = P**precision
    value = residue
    for _ in range(2 * precision.bit_length() + 2):
        old = value
        function = (pow(value, 11, modulus) - 1) % modulus
        derivative = 11 * pow(value, 10, modulus) % modulus
        value = (value - function * pow(derivative, -1, modulus)) % modulus
        if value == old:
            break
    assert pow(value, 11, modulus) == 1 and value % P == residue
    return value


def reduce_anp(value, zeta: int, modulus: int) -> int:
    result = 0
    for coefficient in value.rep:
        numerator = int(coefficient.numerator)
        denominator = int(coefficient.denominator)
        assert math.gcd(denominator, modulus) == 1
        result = (result * zeta + numerator * pow(denominator, -1, modulus)) % modulus
    return result


def reduce_records(records, zeta: int, modulus: int):
    output = []
    for domain, target_inverse in records:
        output.append((
            [[reduce_anp(entry, zeta, modulus) for entry in row] for row in domain],
            [[reduce_anp(entry, zeta, modulus) for entry in row] for row in target_inverse],
        ))
    return output


def evaluate_covariants(records, seeds, point, modulus):
    result = [[0] * 15 for _ in seeds]
    for domain, target_inverse in records:
        transformed = [
            sum(domain[row][column] * point[column] for column in range(5)) % modulus
            for row in range(5)
        ]
        for seed_index, (output, exponents) in enumerate(seeds):
            scalar = 1
            for coordinate, exponent in zip(transformed, exponents):
                if exponent:
                    scalar = scalar * pow(coordinate, int(exponent), modulus) % modulus
            if scalar:
                for row in range(15):
                    result[seed_index][row] = (
                        result[seed_index][row] + scalar * target_inverse[row][output]
                    ) % modulus
    return result


def wedge_for(coefficients, values, modulus):
    return [
        sum(coefficients[index] * values[index][row] for index in range(48)) % modulus
        for row in range(15)
    ]


def residual(wedge, quadruple, modulus):
    i, j, k, ell = quadruple
    return (
        wedge[PAIR_INDEX[(i, j)]] * wedge[PAIR_INDEX[(k, ell)]]
        - wedge[PAIR_INDEX[(i, k)]] * wedge[PAIR_INDEX[(j, ell)]]
        + wedge[PAIR_INDEX[(i, ell)]] * wedge[PAIR_INDEX[(j, k)]]
    ) % modulus


def jacobian_row(wedge, values, quadruple, modulus):
    i, j, k, ell = quadruple
    ij, ik, iell = PAIR_INDEX[(i, j)], PAIR_INDEX[(i, k)], PAIR_INDEX[(i, ell)]
    jk, jell, kell = PAIR_INDEX[(j, k)], PAIR_INDEX[(j, ell)], PAIR_INDEX[(k, ell)]
    return [(
        values[index][ij] * wedge[kell] + wedge[ij] * values[index][kell]
        - values[index][ik] * wedge[jell] - wedge[ik] * values[index][jell]
        + values[index][iell] * wedge[jk] + wedge[iell] * values[index][jk]
    ) % modulus for index in range(47)]


def add_echelon_row(echelon, row):
    remainder = list(row)
    for pivot, basis_row in echelon:
        if remainder[pivot]:
            scalar = remainder[pivot]
            remainder = [(left - scalar * right) % P for left, right in zip(remainder, basis_row)]
    nonzero = [index for index, value in enumerate(remainder) if value]
    if not nonzero:
        return False
    pivot = nonzero[0]
    inverse = pow(remainder[pivot], -1, P)
    remainder = [value * inverse % P for value in remainder]
    echelon.append((pivot, remainder))
    return True


def select_equations(candidate, point_values):
    echelon = []
    selected = []
    for point_index, values in enumerate(point_values):
        wedge = wedge_for(candidate, values, P)
        for quadruple_index, quadruple in enumerate(QUADRUPLES):
            assert residual(wedge, quadruple, P) == 0
            row = jacobian_row(wedge, values, quadruple, P)
            if add_echelon_row(echelon, row):
                selected.append((point_index, quadruple_index))
            if len(selected) == 47:
                return selected
    raise AssertionError(f"Jacobian rank only {len(selected)}")


def solve_linear(matrix, vector, modulus):
    size = len(vector)
    augmented = [list(row) + [value % modulus] for row, value in zip(matrix, vector)]
    for column in range(size):
        pivot = next(
            row for row in range(column, size)
            if math.gcd(augmented[row][column], modulus) == 1
        )
        if pivot != column:
            augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        inverse = pow(augmented[column][column], -1, modulus)
        augmented[column] = [value * inverse % modulus for value in augmented[column]]
        for row in range(size):
            if row != column and augmented[row][column]:
                scalar = augmented[row][column]
                augmented[row] = [
                    (left - scalar * right) % modulus
                    for left, right in zip(augmented[row], augmented[column])
                ]
    return [augmented[index][-1] for index in range(size)]


def invert_matrix(matrix, modulus):
    size = len(matrix)
    augmented = [
        list(row) + [1 if row_index == column else 0 for column in range(size)]
        for row_index, row in enumerate(matrix)
    ]
    for column in range(size):
        pivot = next(
            row for row in range(column, size)
            if math.gcd(augmented[row][column], modulus) == 1
        )
        if pivot != column:
            augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        inverse = pow(augmented[column][column], -1, modulus)
        augmented[column] = [value * inverse % modulus for value in augmented[column]]
        for row in range(size):
            if row != column and augmented[row][column]:
                scalar = augmented[row][column]
                augmented[row] = [
                    (left - scalar * right) % modulus
                    for left, right in zip(augmented[row], augmented[column])
                ]
    assert all(
        augmented[row][column] == (1 if row == column else 0)
        for row in range(size) for column in range(size)
    )
    return [row[size:] for row in augmented]


def system(candidate, point_values, selected, modulus):
    wedges = [wedge_for(candidate, values, modulus) for values in point_values]
    functions = []
    jacobian = []
    for point_index, quadruple_index in selected:
        quadruple = QUADRUPLES[quadruple_index]
        functions.append(residual(wedges[point_index], quadruple, modulus))
        jacobian.append(jacobian_row(wedges[point_index], point_values[point_index], quadruple, modulus))
    return functions, jacobian


def hensel_lift(initial, point_values_full, selected, precision):
    candidate = list(initial)
    assert candidate[47] == 1
    current_precision = 1
    while current_precision < precision:
        next_precision = min(2 * current_precision, precision)
        modulus = P**next_precision
        point_values = [
            [[entry % modulus for entry in row] for row in values]
            for values in point_values_full
        ]
        functions, jacobian = system(candidate, point_values, selected, modulus)
        correction = solve_linear(jacobian, [(-value) % modulus for value in functions], modulus)
        candidate[:47] = [
            (value + delta) % modulus for value, delta in zip(candidate[:47], correction)
        ]
        candidate[47] = 1
        functions_after, _ = system(candidate, point_values, selected, modulus)
        assert functions_after == [0] * 47
        current_precision = next_precision
        print(f"  liftedPrecision={current_precision}", flush=True)
    modulus = P**precision
    for values in point_values_full:
        wedge = wedge_for(candidate, values, modulus)
        assert [residual(wedge, quadruple, modulus) for quadruple in QUADRUPLES] == [0] * 15
    return candidate


def poly_multiply(left, right, modulus):
    output = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            output[i + j] = (output[i + j] + a * b) % modulus
    return output


def interpolate_quadratic(roots, values, modulus):
    output = [0, 0, 0]
    for index in range(3):
        others = [j for j in range(3) if j != index]
        numerator = poly_multiply(
            [(-roots[others[0]]) % modulus, 1],
            [(-roots[others[1]]) % modulus, 1],
            modulus,
        )
        denominator = (
            (roots[index] - roots[others[0]]) * (roots[index] - roots[others[1]])
        ) % modulus
        scalar = values[index] * pow(denominator, -1, modulus) % modulus
        output = [(left + scalar * right) % modulus for left, right in zip(output, numerator)]
    assert [poly_eval(output, root, modulus) for root in roots] == [value % modulus for value in values]
    return output


def rur_from_points(names, points, modulus):
    roots = [point[0] for point in points]
    eliminant = [1]
    for root in roots:
        eliminant = poly_multiply(eliminant, [(-root) % modulus, 1], modulus)
    assert len(eliminant) == 4 and eliminant[-1] == 1
    flattened = eliminant[:]
    for name in names[:-1]:
        variable_index = int(name[1:])
        values = [(-point[variable_index]) % modulus for point in points]
        flattened.extend(interpolate_quadratic(roots, values, modulus))
    assert len(flattened) == 145
    return flattened


def rational_reconstruct(value, modulus):
    r0, s0 = modulus, 0
    r1, s1 = value % modulus, 1
    bound = math.isqrt(modulus // 2)
    while r1 >= bound:
        quotient = r0 // r1
        r0, r1 = r1, r0 - quotient * r1
        s0, s1 = s1, s0 - quotient * s1
    if s1 == 0 or abs(s1) >= bound:
        return None
    numerator, denominator = (-r1, -s1) if s1 < 0 else (r1, s1)
    candidate = Fraction(numerator, denominator)
    if math.gcd(candidate.denominator, modulus) != 1:
        return None
    if (candidate.numerator * pow(candidate.denominator, -1, modulus) - value) % modulus:
        return None
    return candidate


def encode_fraction(value):
    return [value.numerator, value.denominator]


def embedding_cache_path(precision, zeta_residue):
    return HERE / f"ambient_degree12_hensel_p23_precision{precision}_zeta{zeta_residue:03d}.json"


def lift_embedding(task):
    zeta_residue, filename = task
    assert WORKER_EXACT_RECORDS is not None
    assert WORKER_SEEDS is not None
    assert WORKER_MODULUS is not None
    assert WORKER_PRECISION is not None
    assert WORKER_ACTIVE_POINTS is not None
    names, _modular_w, modular_roots, modular_points = load_modular_points(filename)
    zeta = lift_root_of_unity(zeta_residue, WORKER_PRECISION)
    records = reduce_records(WORKER_EXACT_RECORDS, zeta, WORKER_MODULUS)
    point_values = [
        evaluate_covariants(records, WORKER_SEEDS, point, WORKER_MODULUS)
        for point in WORKER_ACTIVE_POINTS
    ]
    print(f"embeddingZeta={zeta_residue} valuesReady", flush=True)
    lifted_points = []
    selections = []
    for root, modular_point in zip(modular_roots, modular_points):
        values_mod_p = [
            [[entry % P for entry in row] for row in values]
            for values in point_values
        ]
        selected = select_equations(modular_point, values_mod_p)
        assert len(selected) == 47
        print(f"embeddingZeta={zeta_residue} root={root} jacobianRank=47", flush=True)
        lifted = hensel_lift(modular_point, point_values, selected, WORKER_PRECISION)
        lifted_points.append(lifted)
        selections.append([[a, b] for a, b in selected])
    rur = rur_from_points(names, lifted_points, WORKER_MODULUS)
    metadata = {
        "zeta_residue": zeta_residue,
        "roots_mod_23": modular_roots,
        "selected_equations": selections,
    }
    result = {
        "format": "ambient-degree12-hensel-embedding-cache-v1",
        "prime": P,
        "precision": WORKER_PRECISION,
        "point_count": len(WORKER_ACTIVE_POINTS),
        "zeta_residue": zeta_residue,
        "lifted_zeta": zeta,
        "lifted_rur": rur,
        "variable_names": names,
        "root_metadata": metadata,
    }
    path = embedding_cache_path(WORKER_PRECISION, zeta_residue)
    path.write_text(json.dumps(result) + "\n")
    print(f"embeddingCache={path.name}", flush=True)
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--precision", type=int, default=100)
    parser.add_argument("--point-count", type=int, default=len(POINTS))
    parser.add_argument("--workers", type=int, default=1)
    args = parser.parse_args()
    assert args.precision >= 2
    assert 8 <= args.point_count <= len(POINTS)
    assert 1 <= args.workers <= 4
    precision = args.precision
    modulus = P**precision
    active_points = POINTS[:args.point_count]

    pf = runpy.run_path(str(ROOT / "tmp/pfaffian_representation_alignment/core.py"))
    fw = runpy.run_path(str(ROOT / "tmp/pfaffian_rank2_idempotent_attack/full_wedge.py"))
    fano = fw["fano"]
    states = exact_probe.word_states(pf, fano)
    basis = exact_probe.source_basis(states, pf)
    exact_records = exact_probe.group_records(states, basis, pf)
    seeds = [
        (int(output), tuple(exponents))
        for output, exponents in json.loads((HERE / "ambient_degree12_a47_chart.json").read_text())["seeds"]
    ]
    assert len(exact_records) == 660 and len(seeds) == 48
    print("exactRecords=660 seeds=48", flush=True)

    primitive_residues = []
    residue = 1
    for _ in range(10):
        residue = residue * 2 % P
        primitive_residues.append(residue)
    assert len(set(primitive_residues)) == 10
    embeddings = []
    for zeta_residue in primitive_residues:
        c_residue = sum(pow(zeta_residue, exponent, P) for exponent in (9, 5, 4, 3, 1)) % P
        assert c_residue in (18, 4)
        filename = (
            "ambient_degree12_a47_chart.rur"
            if c_residue == 18
            else "ambient_degree12_zeta04_a47.rur"
        )
        embeddings.append((zeta_residue, filename))
    global WORKER_EXACT_RECORDS, WORKER_SEEDS, WORKER_MODULUS, WORKER_PRECISION, WORKER_ACTIVE_POINTS
    WORKER_EXACT_RECORDS = exact_records
    WORKER_SEEDS = seeds
    WORKER_MODULUS = modulus
    WORKER_PRECISION = precision
    WORKER_ACTIVE_POINTS = active_points
    results_by_residue = {}
    missing = []
    for task in embeddings:
        zeta_residue = task[0]
        path = embedding_cache_path(precision, zeta_residue)
        if path.is_file():
            cached = json.loads(path.read_text())
            if (
                cached.get("format") == "ambient-degree12-hensel-embedding-cache-v1"
                and cached.get("precision") == precision
                and cached.get("point_count") == args.point_count
                and cached.get("zeta_residue") == zeta_residue
            ):
                results_by_residue[zeta_residue] = cached
                print(f"reusedEmbeddingCache={path.name}", flush=True)
                continue
        missing.append(task)
    if missing and args.workers == 1:
        fresh = [lift_embedding(task) for task in missing]
    elif missing:
        context = multiprocessing.get_context("fork")
        with context.Pool(min(args.workers, len(missing))) as pool:
            fresh = pool.map(lift_embedding, missing)
    else:
        fresh = []
    for result in fresh:
        results_by_residue[result["zeta_residue"]] = result
    ordered_results = [results_by_residue[zeta_residue] for zeta_residue, _filename in embeddings]
    lifted_zetas = [result["lifted_zeta"] for result in ordered_results]
    lifted_rurs = [result["lifted_rur"] for result in ordered_results]
    root_metadata = [result["root_metadata"] for result in ordered_results]
    names = ordered_results[0]["variable_names"]

    cache = {
        "format": "ambient-degree12-hensel-cache-v1",
        "prime": P,
        "precision": precision,
        "point_count": args.point_count,
        "variable_names": names,
        "lifted_zetas": lifted_zetas,
        "lifted_rurs": lifted_rurs,
        "roots": root_metadata,
    }
    cache_path = HERE / f"ambient_degree12_hensel_p23_precision{precision}.json"
    cache_path.write_text(json.dumps(cache) + "\n")
    print(f"henselCache={cache_path.name}", flush=True)

    vandermonde = [
        [pow(zeta, exponent, modulus) for exponent in range(10)]
        for zeta in lifted_zetas
    ]
    vandermonde_inverse = invert_matrix(vandermonde, modulus)
    reconstructed = []
    unresolved = []
    max_numerator = 0
    max_denominator = 0
    for index, values in enumerate(zip(*lifted_rurs)):
        power_residues = [
            sum(vandermonde_inverse[row][column] * values[column] for column in range(10)) % modulus
            for row in range(10)
        ]
        power_coefficients = [rational_reconstruct(value, modulus) for value in power_residues]
        failed_powers = [power for power, value in enumerate(power_coefficients) if value is None]
        if failed_powers:
            unresolved.extend([[index, power] for power in failed_powers])
            reconstructed.append(None)
            continue
        encoded = []
        for value in power_coefficients:
            assert value is not None
            max_numerator = max(max_numerator, abs(value.numerator))
            max_denominator = max(max_denominator, value.denominator)
            encoded.append(encode_fraction(value))
        for zeta, expected in zip(lifted_zetas, values):
            reduced = 0
            for value in reversed(power_coefficients):
                assert value is not None
                reduced = (
                    reduced * zeta
                    + value.numerator * pow(value.denominator, -1, modulus)
                ) % modulus
            assert reduced == expected
        reconstructed.append(encoded)

    report = {
        "prime": P,
        "precision": precision,
        "modulus_digits": len(str(modulus)),
        "rational_reconstruction_bound_digits": len(str(math.isqrt(modulus // 2))),
        "cyclotomic_residues": lifted_zetas,
        "rur_coefficient_count": 145,
        "scalar_component_count": 1450,
        "resolved_component_count": 1450 - len(unresolved),
        "unresolved_slot_and_power": unresolved,
        "max_abs_numerator": max_numerator,
        "max_denominator": max_denominator,
        "roots": root_metadata,
    }
    (HERE / "ambient_degree12_hensel_report.json").write_text(json.dumps(report, indent=2) + "\n")
    print(
        f"resolvedComponents={report['resolved_component_count']} unresolvedComponents={len(unresolved)} "
        f"maxAbsNumerator={max_numerator} maxDenominator={max_denominator}",
        flush=True,
    )
    if unresolved:
        print("AMBIENT-D12-HENSEL-RECONSTRUCTION-INCOMPLETE", flush=True)
        return

    artifact = {
        "format": "ambient-degree12-rur-char0-qzeta11-v1",
        "field": {
            "generator": "zeta11",
            "minimal_polynomial_ascending": [1] * 11,
            "power_basis": [f"zeta11^{power}" for power in range(10)],
        },
        "hensel_prime": P,
        "hensel_precision": precision,
        "variable_names": names,
        "parameter": "a0",
        "chart": "a47=1",
        "raw_rur_coefficients_power_basis": reconstructed,
        "layout": {
            "eliminant": [0, 4],
            "coordinate_numerators": [4, 145],
            "coordinate_stride": 3,
            "coordinate_sign": -1,
            "denominator": [1],
        },
    }
    (HERE / "ambient_degree12_rur_char0.json").write_text(json.dumps(artifact, indent=2) + "\n")
    print("AMBIENT-D12-HENSEL-RUR-QC-RECONSTRUCTED", flush=True)


if __name__ == "__main__":
    main()
