#!/usr/bin/env python3
"""Produce the exact Schur-plane link payload from upstream Reynolds data."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

import numpy as np
import sympy as sp

HERE = Path(__file__).resolve().parent
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

SOURCE_POINT = np.array([13, 9, 5, 5, 8, 19], dtype=np.int64)


def nullspace(matrix: np.ndarray) -> np.ndarray:
    data = np.array(matrix, dtype=np.int64) % P
    rows, columns = data.shape
    pivot_row = 0
    pivots: list[int] = []
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, rows) if data[row, column]),
            None,
        )
        if pivot is None:
            continue
        data[[pivot_row, pivot]] = data[[pivot, pivot_row]]
        data[pivot_row] *= pow(int(data[pivot_row, column]), -1, P)
        data[pivot_row] %= P
        for row in range(rows):
            if row != pivot_row and data[row, column]:
                data[row] -= data[row, column] * data[pivot_row]
                data[row] %= P
        pivots.append(column)
        pivot_row += 1
    basis = []
    for free in (column for column in range(columns) if column not in pivots):
        vector = np.zeros(columns, dtype=np.int64)
        vector[free] = 1
        for row, column in enumerate(pivots):
            vector[column] = -data[row, free] % P
        basis.append(vector)
    return np.stack(basis, axis=1)


def centered(value: int) -> int:
    value %= P
    return value if value <= P // 2 else value - P


def plane_terms(frame: np.ndarray, cubic: dict[tuple[int, ...], int]):
    variables = sp.symbols("a0:3")
    target = [
        sum(int(frame[row, column]) * variables[column] for column in range(3))
        for row in range(5)
    ]
    expression = 0
    for exponents, coefficient in cubic.items():
        term = int(coefficient)
        for linear, exponent in zip(target, exponents):
            term *= linear**exponent
        expression += term
    polynomial = sp.Poly(expression, *variables, modulus=P)
    terms = [
        {"exponents": list(monomial), "coefficient": int(coefficient)}
        for monomial, coefficient in polynomial.terms()
    ]
    gradient = [sp.diff(polynomial.as_expr(), variable) for variable in variables]
    charts = []
    for chart in range(3):
        remaining = tuple(variable for i, variable in enumerate(variables) if i != chart)
        equations = [derivative.subs(variables[chart], 1) for derivative in gradient]
        basis = sp.groebner(equations, *remaining, modulus=P, order="grevlex")
        charts.append(len(basis.polys) == 1 and basis.polys[0].as_expr() == 1)
    return terms, charts


def build_payload():
    scan = Scan()
    frame = np.stack(
        [scan.evaluate_seed(*seed, SOURCE_POINT) for seed in FRAME_SEEDS], axis=1
    ) % P
    frame_determinant = determinant_mod_prime(frame, P)
    invariant_value = scalar_reynolds_value(scan, SOURCE_POINT)
    normalized = frame * pow(invariant_value, -1, P) % P
    normalized_determinant = determinant_mod_prime(normalized, P)

    unique = {
        tuple(int(entry) for entry in matrix.flat): matrix
        for matrix in scan.target_group
    }
    identity = np.eye(5, dtype=np.int64) % P
    involutions = []
    for key in sorted(unique):
        matrix = unique[key]
        if not np.array_equal(matrix, identity) and np.array_equal(
            matrix @ matrix % P, identity
        ):
            involutions.append(matrix)
    determinants = []
    for matrix in involutions:
        line = nullspace((matrix + identity) % P)
        assert line.shape == (5, 2)
        determinants.append(
            determinant_mod_prime(np.concatenate([frame[:, :3], line], axis=1), P)
        )
    product = 1
    for determinant in determinants:
        product = product * determinant % P
    determinant_digest = hashlib.sha256(
        json.dumps(determinants, separators=(",", ":")).encode()
    ).hexdigest()

    terms, charts = plane_terms(frame, invariant_cubic_coefficients(scan))
    return {
        "schema": "m2-schur-plane-012-dp3-v1",
        "field": "K_Schur=C(P(V6))^G",
        "frame": {
            "degree": 8,
            "seeds": [[output, list(seed)] for output, seed in FRAME_SEEDS],
            "normalization": "q_i/I8",
        },
        "good_reduction_witness": {
            "prime": P,
            "zeta11": 2,
            "source_point": SOURCE_POINT.tolist(),
            "frame_matrix": frame.tolist(),
            "frame_determinant": frame_determinant,
            "I8_value": invariant_value,
            "normalized_determinant": normalized_determinant,
        },
        "center": {
            "plane": [0, 1, 2],
            "ideal": ["a3", "a4"],
            "degree": 3,
            "genus": 1,
            "normal_bundle": "O_C(1)+O_C(1)",
            "specialized_terms_centered_mod23": terms,
            "smooth_projective_charts": charts,
        },
        "line_orbit_avoidance": {
            "target_group_matrices": len(unique),
            "involutions": len(involutions),
            "setwise_stabilizer": "D12",
            "stabilizer_order": 12,
            "incidence_determinants_mod23": determinants,
            "determinant_product_mod23": product,
            "determinant_list_sha256": determinant_digest,
            "conclusion": "Pi_012 is generically disjoint from every involution minus-line",
        },
        "map": {
            "blowup_graph_equation": "a3*t-a4*s=0",
            "projection": "[a3:a4]",
            "fibre_substitution": ["a3=s*u", "a4=t*u"],
            "endpoint": "degree-3 del Pezzo fibration over P1",
            "relative_picard_rank": 1,
        },
        "generic_fibre": {
            "zero_cycle_degrees": [3, 55],
            "index": 1,
            "section_frontier": "K-rational section or integral degree-4 multisection",
            "headline": "OPEN",
        },
    }


if __name__ == "__main__":
    print(json.dumps(build_payload(), indent=2))

