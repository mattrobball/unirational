#!/usr/bin/env python3
"""Extract and directly verify rational points of a modular ambient RUR."""

from __future__ import annotations

import argparse
import ast
import hashlib
import json
import runpy
from itertools import combinations
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
TEST_POINTS = ((1, 2, 3, 4, 5), (2, 5, 7, 11, 13), (3, 1, 4, 1, 5))


def peval(coefficients, value, prime):
    return sum(int(coefficient) * pow(value, exponent, prime) for exponent, coefficient in enumerate(coefficients)) % prime


def parse_rur(path: Path, expected_prime: int):
    data = ast.literal_eval(path.read_text().strip().rstrip(":"))
    assert data[0] == 0
    prime, nvars, degree, names, linear_form, tail = data[1]
    assert prime == expected_prime and nvars == 48
    assert linear_form == [0] * 47 + [1]
    one, body = tail
    assert one == 1
    eliminant, denominator, coordinate_blocks = body
    assert len(coordinate_blocks) == 47
    polynomial = eliminant[1]
    roots = [value for value in range(prime) if peval(polynomial, value, prime) == 0]
    denominator_polynomial = denominator[1]
    vectors = []
    for root in roots:
        denominator_value = peval(denominator_polynomial, root, prime)
        assert denominator_value
        coordinates = {names[-1]: root}
        for name, block in zip(names[:-1], coordinate_blocks):
            assert len(block) == 1
            coordinates[name] = (
                -peval(block[0][1], root, prime) * pow(denominator_value, -1, prime)
            ) % prime
        vector = [coordinates[f"a{index}"] for index in range(48)]
        assert vector[47] == 1
        vectors.append(vector)
    return degree, polynomial, roots, vectors


def pluecker(values, pair_index, prime):
    return [
        (
            values[pair_index[(i, j)]] * values[pair_index[(k, ell)]]
            - values[pair_index[(i, k)]] * values[pair_index[(j, ell)]]
            + values[pair_index[(i, ell)]] * values[pair_index[(j, k)]]
        ) % prime
        for i, j, k, ell in combinations(range(6), 4)
    ]


def skew(values, pairs, prime):
    matrix = np.zeros((6, 6), dtype=np.int64)
    for value, (left, right) in zip(values, pairs):
        matrix[left, right] = value
        matrix[right, left] = -value % prime
    return matrix


def inv_mod(matrix, prime):
    n = matrix.shape[0]
    work = np.concatenate([matrix.copy() % prime, np.eye(n, dtype=np.int64)], axis=1)
    for column in range(n):
        candidates = np.flatnonzero(work[column:, column] % prime)
        assert len(candidates)
        pivot = column + int(candidates[0])
        work[[column, pivot]] = work[[pivot, column]]
        work[column] = work[column] * pow(int(work[column, column]), -1, prime) % prime
        for row in range(n):
            if row != column and work[row, column] % prime:
                work[row] = (work[row] - work[row, column] * work[column]) % prime
    return work[:, n:] % prime


def projector(wedge, q, pairs, prime):
    pivot = next(pair for value, pair in zip(wedge, pairs) if value % prime)
    i, j = pivot
    pij = int(wedge[pairs.index((i, j))]) % prime
    u = np.zeros(6, dtype=np.int64)
    v = np.zeros(6, dtype=np.int64)
    for k in range(6):
        pik = 0 if k == i else int(wedge[pairs.index((i, k))]) if i < k else -int(wedge[pairs.index((k, i))])
        pjk = 0 if k == j else int(wedge[pairs.index((j, k))]) if j < k else -int(wedge[pairs.index((k, j))])
        u[k] = pik % prime
        v[k] = pjk * pow(pij, -1, prime) % prime
    basis = np.stack([u, v], axis=1) % prime
    gram = basis.T @ q @ basis % prime
    scalar = int(gram[0, 1]) % prime
    assert scalar
    gram_inverse = np.array(
        [[0, -pow(scalar, -1, prime)], [pow(scalar, -1, prime), 0]], dtype=np.int64
    ) % prime
    answer = basis @ gram_inverse @ basis.T @ q % prime
    q_inverse = inv_mod(q, prime)
    assert np.array_equal(answer @ answer % prime, answer)
    assert int(np.trace(answer)) % prime == 2
    assert np.array_equal(q_inverse @ answer.T @ q % prime, answer)
    return answer


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, required=True)
    parser.add_argument("--zeta", type=int)
    args = parser.parse_args()
    suffix = f"_zeta{args.zeta % args.prime}" if args.zeta is not None else ""
    metadata = json.loads((HERE / f"ambient_degree12_p{args.prime}{suffix}.json").read_text())
    zeta = metadata["zeta11"]
    degree, eliminant, roots, vectors = parse_rur(
        HERE / f"ambient_degree12_p{args.prime}{suffix}_a47.rur", args.prime
    )

    namespace = runpy.run_path(str(ROOT / "tmp/pfaffian_rank2_idempotent_attack/full_wedge.py"))
    live = namespace["FullWedgeScanner"].__init__.__globals__
    fano_live = live["fano"]["six_dimensional_generators"].__globals__
    live["P"] = args.prime
    fano_live["P"] = args.prime
    fano_live["ZETA"] = zeta
    scanner = namespace["FullWedgeScanner"]()
    seeds = [(entry[0], tuple(entry[1])) for entry in metadata["seeds"]]
    fano = live["fano"]
    six = fano["six_dimensional_generators"]()
    dual = tuple(fano["inv"](generator).T % args.prime for generator in six)
    dual_wedge = tuple(fano["exterior_square"](generator) for generator in dual)
    domain_basis, _ = fano["invariant_summands"](dual_wedge)
    pairs = tuple(combinations(range(6), 2))

    rng = np.random.default_rng(20260801 + args.prime + zeta)
    candidate_points = list(TEST_POINTS) + [
        tuple(int(value) for value in rng.integers(0, args.prime, size=5))
        for _ in range(40)
    ]
    checks = []
    for root, coefficients in zip(roots, vectors):
        evaluations = []
        for point_tuple in candidate_points:
            point = np.array(point_tuple, dtype=np.int64) % args.prime
            values = np.stack([
                scanner.evaluate_seed(output, exponents, point)
                for output, exponents in seeds
            ])
            wedge = np.array(coefficients, dtype=np.int64) @ values % args.prime
            if not np.any(wedge):
                continue
            assert pluecker(wedge, fano["PAIR_INDEX"], args.prime) == [0] * 15
            q_values = domain_basis @ point % args.prime
            q = skew(q_values, pairs, args.prime)
            try:
                e = projector(wedge, q, pairs, args.prime)
            except (AssertionError, StopIteration):
                continue
            residual = domain_basis.T @ wedge % args.prime
            evaluations.append({
                "point": list(point_tuple),
                "wedge_sha256": hashlib.sha256(bytes(wedge.astype(np.uint16).flat)).hexdigest(),
                "projector_sha256": hashlib.sha256(bytes(e.astype(np.uint16).flat)).hexdigest(),
                "distinguished_five_residual": [int(value) for value in residual],
                "lies_in_genuine_fano_linear_section": bool(np.all(residual == 0)),
            })
            if len(evaluations) == 3:
                break
        assert len(evaluations) == 3
        checks.append({
            "eliminant_root": root,
            "coefficient_vector": coefficients,
            "support": sum(bool(value) for value in coefficients),
            "evaluations": evaluations,
        })
    output = {
        "format": "ambient-projector-rational-residue-points-v1",
        "scope": "modular auxiliary projectors only",
        "prime": args.prime,
        "zeta11": zeta,
        "scheme_degree": degree,
        "eliminant_coefficients_ascending": eliminant,
        "rational_roots": roots,
        "checks": checks,
        "theorem_boundary": (
            "residue projectors are neither characteristic-zero Morita data nor "
            "points of the genuine Fano section"
        ),
    }
    out = HERE / f"ambient_degree12_points_p{args.prime}{suffix}.json"
    out.write_text(json.dumps(output, indent=2) + "\n")
    print(json.dumps({
        "prime": args.prime,
        "scheme_degree": degree,
        "rational_roots": roots,
        "fano_hits": sum(
            check["lies_in_genuine_fano_linear_section"]
            for row in checks for check in row["evaluations"]
        ),
    }, indent=2))
    print("AMBIENT-PROJECTOR-RATIONAL-RESIDUES-VERIFIED")


if __name__ == "__main__":
    main()
