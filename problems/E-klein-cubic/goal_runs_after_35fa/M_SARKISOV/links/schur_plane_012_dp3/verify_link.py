#!/usr/bin/env python3
"""Independent exact verifier for the selected Schur-plane Sarkisov link."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

import numpy as np
import sympy as sp

HERE = Path(__file__).resolve().parent
PACKET = HERE.parents[1]
PROBLEM = HERE.parents[3]
PROJECTIVE = PROBLEM / "tmp" / "projective_source"
sys.path.insert(0, str(PROJECTIVE))

from degree8_m2 import invariant_cubic_coefficients  # noqa: E402
from degree8_rational_frame import (  # noqa: E402
    FRAME_SEEDS,
    determinant_mod_prime,
    scalar_reynolds_value,
)
from landing_scan import P, Scan  # noqa: E402

PAYLOAD = json.loads((HERE / "link_payload.json").read_text())
MORI = json.loads((PACKET / "payload" / "mori_cox.json").read_text())


def kernel(matrix: np.ndarray) -> np.ndarray:
    data = np.asarray(matrix, dtype=np.int64).copy() % P
    pivot_columns = []
    row = 0
    for column in range(data.shape[1]):
        candidates = np.flatnonzero(data[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        data[[row, pivot]] = data[[pivot, row]]
        data[row] = data[row] * pow(int(data[row, column]), -1, P) % P
        for other in range(data.shape[0]):
            if other != row and data[other, column]:
                data[other] = (data[other] - data[other, column] * data[row]) % P
        pivot_columns.append(column)
        row += 1
    free_columns = [column for column in range(data.shape[1]) if column not in pivot_columns]
    vectors = []
    for free in free_columns:
        vector = np.zeros(data.shape[1], dtype=np.int64)
        vector[free] = 1
        for pivot_row, pivot_column in enumerate(pivot_columns):
            vector[pivot_column] = -data[pivot_row, free] % P
        vectors.append(vector)
    return np.asarray(vectors, dtype=np.int64).T


def polynomial_and_smoothness(scan: Scan, frame: np.ndarray):
    cubic = invariant_cubic_coefficients(scan)
    variables = sp.symbols("x0:3")
    image = [
        sum(int(frame[row, column]) * variables[column] for column in range(3))
        for row in range(5)
    ]
    expression = 0
    for exponents, coefficient in cubic.items():
        term = int(coefficient)
        for linear, exponent in zip(image, exponents):
            term *= linear**exponent
        expression += term
    polynomial = sp.Poly(expression, *variables, modulus=P)
    terms = [
        {"exponents": list(monomial), "coefficient": int(coefficient)}
        for monomial, coefficient in polynomial.terms()
    ]
    derivatives = [sp.diff(polynomial.as_expr(), variable) for variable in variables]
    charts = []
    for fixed in range(3):
        remaining = tuple(variable for i, variable in enumerate(variables) if i != fixed)
        equations = [derivative.subs(variables[fixed], 1) for derivative in derivatives]
        groebner = sp.groebner(equations, *remaining, modulus=P, order="grevlex")
        charts.append(
            len(groebner.polys) == 1 and groebner.polys[0].as_expr() == 1
        )
    return terms, charts


def triple(first, second, third, ring):
    value = 0
    for mask in range(8):
        coefficient = 1
        exceptional_count = 0
        for index, divisor in enumerate((first, second, third)):
            use_exceptional = (mask >> index) & 1
            coefficient *= divisor[use_exceptional]
            exceptional_count += use_exceptional
        value += coefficient * ring[exceptional_count]
    return value


def main():
    assert PAYLOAD["schema"] == "m2-schur-plane-012-dp3-v1"
    scan = Scan()
    point = np.asarray(PAYLOAD["good_reduction_witness"]["source_point"], dtype=np.int64)
    frame = np.column_stack([scan.evaluate_seed(*seed, point) for seed in FRAME_SEEDS]) % P
    witness = PAYLOAD["good_reduction_witness"]
    assert frame.tolist() == witness["frame_matrix"]
    assert determinant_mod_prime(frame, P) == witness["frame_determinant"] == 9
    invariant = scalar_reynolds_value(scan, point)
    assert invariant == witness["I8_value"] == 10
    normalized = frame * pow(invariant, -1, P) % P
    assert determinant_mod_prime(normalized, P) == witness["normalized_determinant"] == 15

    terms, charts = polynomial_and_smoothness(scan, frame)
    assert terms == PAYLOAD["center"]["specialized_terms_centered_mod23"]
    assert charts == PAYLOAD["center"]["smooth_projective_charts"] == [True] * 3

    identity = np.eye(5, dtype=np.int64) % P
    matrices = {}
    for matrix in scan.target_group:
        matrices.setdefault(tuple(map(int, matrix.ravel())), matrix)
    involutions = []
    for key in sorted(matrices):
        matrix = matrices[key]
        if np.array_equal(matrix, identity):
            continue
        if np.array_equal(np.linalg.matrix_power(matrix, 2) % P, identity):
            involutions.append(matrix)
    determinants = []
    for involution in involutions:
        minus_space = kernel(involution + identity)
        assert minus_space.shape == (5, 2)
        determinants.append(
            determinant_mod_prime(
                np.concatenate((frame[:, :3], minus_space), axis=1), P
            )
        )
    orbit = PAYLOAD["line_orbit_avoidance"]
    assert len(matrices) == orbit["target_group_matrices"] == 660
    assert len(involutions) == orbit["involutions"] == 55
    assert determinants == orbit["incidence_determinants_mod23"]
    assert all(determinants)
    product = 1
    for value in determinants:
        product = product * value % P
    assert product == orbit["determinant_product_mod23"] == 10
    digest = hashlib.sha256(
        json.dumps(determinants, separators=(",", ":")).encode()
    ).hexdigest()
    assert digest == orbit["determinant_list_sha256"]

    ring_data = MORI["intersection_ring"]
    ring = (ring_data["H3"], ring_data["H2D"], ring_data["HD2"], ring_data["D3"])
    minus_k = tuple(MORI["classes"]["minus_K"])
    fibre = tuple(MORI["classes"]["L"])
    assert ring == (3, 0, -3, -6)
    assert triple(minus_k, minus_k, minus_k, ring) == ring_data["minus_K_cube"] == 12
    assert triple(fibre, fibre, (1, 0), ring) == ring_data["L2H"] == 0
    assert triple(fibre, fibre, (0, 1), ring) == ring_data["L2D"] == 0
    assert triple(fibre, fibre, fibre, ring) == ring_data["L3"] == 0

    variables = MORI["cox"]["variables"]
    assert variables["e"] == [0, 1]
    assert variables["y3"] == variables["y4"] == [1, -1]
    assert [variables["e"][i] + variables["y3"][i] for i in range(2)] == [1, 0]
    assert MORI["cox"]["relation_degree"] == [3, 0]
    for curve in MORI["curve_pairings"].values():
        assert curve["L"] == curve["H"] - curve["D"]
        assert curve["minus_K"] == 2 * curve["H"] - curve["D"] > 0

    fibre_data = PAYLOAD["generic_fibre"]
    assert fibre_data["zero_cycle_degrees"] == [3, 55]
    assert sp.gcd(3, 55) == fibre_data["index"] == 1
    assert fibre_data["headline"] == "OPEN"

    print("PASS genuine Schur frame and smooth plane-012 center")
    print("PASS all 55 involution lines are simultaneously disjoint from Pi_012")
    print("PASS graph, Cox grading, intersections, rays, and index-one arithmetic")
    print("M2_SCHUR_PLANE_LINK_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()

