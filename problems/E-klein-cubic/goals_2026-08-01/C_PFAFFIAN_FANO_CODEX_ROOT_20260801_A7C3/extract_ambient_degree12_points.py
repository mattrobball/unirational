#!/usr/bin/env python3
"""Extract and directly check the three mod-23 ambient projectors."""

from __future__ import annotations

import ast
import hashlib
import json
import runpy
from itertools import combinations
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
RUR = HERE / "ambient_degree12_a47_chart.rur"
OUT = HERE / "ambient_degree12_points_p23.json"
POINTS = ((1, 2, 3, 4, 5), (2, 5, 7, 11, 13), (3, 1, 4, 1, 5))


def peval(coefficients, value, p):
    return sum(int(coefficient) * pow(value, exponent, p) for exponent, coefficient in enumerate(coefficients)) % p


def parse_rur():
    data = ast.literal_eval(RUR.read_text().strip().rstrip(":"))
    assert data[0] == 0
    p, nvars, degree, names, linear_form, tail = data[1]
    assert (p, nvars, degree) == (23, 48, 3)
    assert linear_form == [0] * 47 + [1]
    _one, (eliminant, denominator, coordinate_blocks) = tail
    assert _one == 1 and denominator == [0, [1]] and len(coordinate_blocks) == 47
    w = eliminant[1]
    roots = [value for value in range(p) if peval(w, value, p) == 0]
    assert roots == [1, 6, 11]
    vectors = []
    for root in roots:
        coordinates = {names[-1]: root}
        for name, block in zip(names[:-1], coordinate_blocks):
            assert len(block) == 1
            coordinates[name] = -peval(block[0][1], root, p) % p
        vector = [coordinates[f"a{index}"] for index in range(48)]
        assert vector[47] == 1
        vectors.append(vector)
    return w, roots, vectors


def pluecker(values, pair_index, p):
    result = []
    for i, j, k, ell in combinations(range(6), 4):
        result.append((
            values[pair_index[(i, j)]] * values[pair_index[(k, ell)]]
            - values[pair_index[(i, k)]] * values[pair_index[(j, ell)]]
            + values[pair_index[(i, ell)]] * values[pair_index[(j, k)]]
        ) % p)
    return result


def skew(values, pairs, p):
    matrix = np.zeros((6, 6), dtype=np.int64)
    for value, (left, right) in zip(values, pairs):
        matrix[left, right] = value
        matrix[right, left] = -value % p
    return matrix


def projector(wedge, q, pairs, p):
    pivot = next((pair for value, pair in zip(wedge, pairs) if value % p), None)
    assert pivot is not None
    i, j = pivot
    pij = int(wedge[pairs.index((i, j))]) % p
    u = np.zeros(6, dtype=np.int64)
    v = np.zeros(6, dtype=np.int64)
    for k in range(6):
        if k == i:
            pik = 0
        elif i < k:
            pik = int(wedge[pairs.index((i, k))])
        else:
            pik = -int(wedge[pairs.index((k, i))])
        if k == j:
            pjk = 0
        elif j < k:
            pjk = int(wedge[pairs.index((j, k))])
        else:
            pjk = -int(wedge[pairs.index((k, j))])
        u[k] = pik % p
        v[k] = pjk * pow(pij, -1, p) % p
    basis = np.stack([u, v], axis=1) % p
    gram = basis.T @ q @ basis % p
    scalar = int(gram[0, 1]) % p
    assert scalar
    gram_inverse = np.array([[0, -pow(scalar, -1, p)], [pow(scalar, -1, p), 0]], dtype=np.int64) % p
    e = basis @ gram_inverse @ basis.T @ q % p
    identity = np.eye(6, dtype=np.int64) % p
    assert np.array_equal(e @ e % p, e)
    assert int(np.trace(e)) % p == 2
    q_inverse = inv_mod(q, p)
    assert np.array_equal(q_inverse @ e.T @ q % p, e)
    assert not np.array_equal(e, np.zeros((6, 6), dtype=np.int64))
    return e


def inv_mod(matrix, p):
    n = matrix.shape[0]
    work = np.concatenate([matrix.copy() % p, np.eye(n, dtype=np.int64)], axis=1)
    for column in range(n):
        candidates = np.flatnonzero(work[column:, column] % p)
        assert len(candidates)
        pivot = column + int(candidates[0])
        work[[column, pivot]] = work[[pivot, column]]
        work[column] = work[column] * pow(int(work[column, column]), -1, p) % p
        for row in range(n):
            if row != column and work[row, column] % p:
                work[row] = (work[row] - work[row, column] * work[column]) % p
    return work[:, n:] % p


def main():
    w, roots, vectors = parse_rur()
    fw = runpy.run_path(str(ROOT / "tmp" / "pfaffian_rank2_idempotent_attack" / "full_wedge.py"))
    scanner = fw["FullWedgeScanner"]()
    seeds = scanner.covariant_basis(12)
    assert len(seeds) == 48
    fano = fw["fano"]
    six = fano["six_dimensional_generators"]()
    dual = tuple(fano["inv"](generator).T % 23 for generator in six)
    dual_wedge = tuple(fano["exterior_square"](generator) for generator in dual)
    domain_basis, _other = fano["invariant_summands"](dual_wedge)
    pairs = tuple(combinations(range(6), 2))
    checks = []
    for root, coefficients in zip(roots, vectors):
        point_checks = []
        for point_tuple in POINTS:
            point = np.array(point_tuple, dtype=np.int64)
            values = np.stack([
                scanner.evaluate_seed(output, exponents, point)
                for output, exponents in seeds
            ])
            wedge = np.array(coefficients, dtype=np.int64) @ values % 23
            assert any(wedge) and pluecker(wedge, fano["PAIR_INDEX"], 23) == [0] * 15
            q_values = domain_basis @ point % 23
            q = skew(q_values, pairs, 23)
            assert fano["inv"](q) is not None
            e = projector(wedge, q, pairs, 23)
            five_residual = domain_basis.T @ wedge % 23
            point_checks.append({
                "point": list(point_tuple),
                "wedge_sha256": hashlib.sha256(bytes(wedge.astype(np.uint8))).hexdigest(),
                "projector_sha256": hashlib.sha256(bytes(e.astype(np.uint8))).hexdigest(),
                "q_pairing": int(np.dot(q_values, wedge) % 23),
                "distinguished_five_residual": [int(value) for value in five_residual],
                "lies_in_genuine_fano_linear_section": bool(np.all(five_residual == 0)),
            })
        checks.append({
            "eliminant_root": root,
            "coefficient_vector": coefficients,
            "support": sum(bool(value) for value in coefficients),
            "point_checks": point_checks,
        })
    OUT.write_text(json.dumps({
        "format": "ambient-degree12-projectors-p23-v1",
        "scope": "three modular ambient symplectic projectors; none is promoted to K_proj or to the genuine Fano section",
        "prime": 23,
        "eliminant_coefficients_ascending": w,
        "roots": roots,
        "checks": checks,
    }, indent=2) + "\n")
    print(f"WROTE {OUT}")
    print("AMBIENT-D12-THREE-MODULAR-PROJECTORS")


if __name__ == "__main__":
    main()
