#!/usr/bin/env python3
"""Produce the sealed-p=23 involution-line pair-residual ledger.

This calculation is deliberately specialization-scoped.  It reconstructs the
55 involution minus-lines at the exact good-reduction witness installed by the
M2 Sarkisov packet, parametrizes every line as a degree-one section of the
specialized pencil, and applies third intersection to all 1,485 unordered
pairs.  Every returned claim concerns this frozen F_23 calculation only.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from collections import Counter
from pathlib import Path

import numpy as np
import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PROJECTIVE = PROBLEM / "tmp" / "projective_source"
LINK = (
    PROBLEM
    / "goal_runs_after_35fa"
    / "M_SARKISOV"
    / "links"
    / "schur_plane_012_dp3"
    / "link_payload.json"
)
sys.path.insert(0, str(PROJECTIVE))

from degree8_m2 import invariant_cubic_coefficients  # noqa: E402
from degree8_rational_frame import FRAME_SEEDS  # noqa: E402
from landing_scan import P, Scan  # noqa: E402


S, T = sp.symbols("s t")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def inverse(matrix: np.ndarray) -> np.ndarray:
    size = matrix.shape[0]
    data = np.concatenate(
        (matrix.copy() % P, np.eye(size, dtype=np.int64)), axis=1
    )
    for column in range(size):
        pivot = next(row for row in range(column, size) if data[row, column])
        data[[column, pivot]] = data[[pivot, column]]
        data[column] *= pow(int(data[column, column]), -1, P)
        data[column] %= P
        for row in range(size):
            if row != column and data[row, column]:
                data[row] -= data[row, column] * data[column]
                data[row] %= P
    return data[:, size:]


def kernel(matrix: np.ndarray) -> np.ndarray:
    data = matrix.copy() % P
    rows, columns = data.shape
    pivot_columns: list[int] = []
    pivot_row = 0
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
        pivot_columns.append(column)
        pivot_row += 1
    vectors = []
    for free in (column for column in range(columns) if column not in pivot_columns):
        vector = np.zeros(columns, dtype=np.int64)
        vector[free] = 1
        for row, pivot in enumerate(pivot_columns):
            vector[pivot] = -data[row, free] % P
        vectors.append(vector)
    return np.column_stack(vectors)


def rank(matrix: np.ndarray) -> int:
    data = matrix.copy() % P
    rows, columns = data.shape
    result = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(result, rows) if data[row, column]), None
        )
        if pivot is None:
            continue
        data[[result, pivot]] = data[[pivot, result]]
        data[result] *= pow(int(data[result, column]), -1, P)
        data[result] %= P
        for row in range(result + 1, rows):
            if data[row, column]:
                data[row] -= data[row, column] * data[result]
                data[row] %= P
        result += 1
    return result


# A homogeneous binary form of degree d is stored as the d+1 coefficients of
# s^(d-i)t^i.  Object dtype prevents accidental int64 overflow before reduction.
def poly_add(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    out = np.zeros(max(len(left), len(right)), dtype=object)
    out[: len(left)] += left
    out[: len(right)] += right
    return out % P


def poly_scale(value: np.ndarray, scalar: int) -> np.ndarray:
    return np.asarray(value, dtype=object) * int(scalar) % P


def poly_mul(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    return np.convolve(left, right).astype(object) % P


def poly_power(value: np.ndarray, exponent: int) -> np.ndarray:
    out = np.array([1], dtype=object)
    for _ in range(exponent):
        out = poly_mul(out, value)
    return out


def directional_derivative(
    frame: np.ndarray,
    cubic: dict[tuple[int, ...], int],
    point: np.ndarray,
    direction: np.ndarray,
) -> np.ndarray:
    """Return dPhi_point(direction), a binary cubic in (s,t)."""

    target_point = frame @ point % P
    target_direction = frame @ direction % P
    result = np.zeros(4, dtype=object)
    for exponents, coefficient in cubic.items():
        for differentiated, exponent in enumerate(exponents):
            if not exponent:
                continue
            term = np.array([int(coefficient) * exponent % P], dtype=object)
            for variable, power in enumerate(exponents):
                remaining = power - int(variable == differentiated)
                if remaining:
                    term = poly_mul(
                        term, poly_power(target_point[variable], remaining)
                    )
            term = poly_mul(term, target_direction[differentiated])
            result = poly_add(result, term)
    return result % P


def evaluate_cubic(
    frame: np.ndarray,
    cubic: dict[tuple[int, ...], int],
    coordinates: list[np.ndarray],
) -> np.ndarray:
    target = []
    for row in range(5):
        value = np.zeros(len(coordinates[0]), dtype=object)
        for column in range(5):
            value = poly_add(
                value, poly_scale(coordinates[column], int(frame[row, column]))
            )
        target.append(value)
    result = np.zeros(13, dtype=object)
    for exponents, coefficient in cubic.items():
        term = np.array([int(coefficient) % P], dtype=object)
        for variable, exponent in enumerate(exponents):
            if exponent:
                term = poly_mul(term, poly_power(target[variable], exponent))
        result = poly_add(result, term)
    return result % P


def sympy_poly(coefficients: np.ndarray) -> sp.Poly:
    degree = len(coefficients) - 1
    expression = sum(
        int(coefficient) % P * S ** (degree - index) * T**index
        for index, coefficient in enumerate(coefficients)
    )
    return sp.Poly(expression, S, T, modulus=P)


def normalized_map(
    coordinates: list[np.ndarray],
) -> tuple[tuple[int, ...], int, int]:
    polynomials = [sympy_poly(coordinate) for coordinate in coordinates]
    common = None
    for polynomial in polynomials:
        if polynomial.is_zero:
            continue
        common = polynomial if common is None else sp.gcd(common, polynomial)
    assert common is not None
    gcd_degree = int(common.total_degree())
    if gcd_degree:
        polynomials = [polynomial.exquo(common) for polynomial in polynomials]
    degree = max(int(polynomial.total_degree()) for polynomial in polynomials)
    vector: list[int] = []
    for polynomial in polynomials:
        terms = polynomial.as_dict()
        vector.extend(
            int(terms.get((degree - index, index), 0)) % P
            for index in range(degree + 1)
        )
    first = next(value for value in vector if value)
    unit = pow(first, -1, P)
    return tuple(value * unit % P for value in vector), degree, gcd_degree


def build_payload() -> dict[str, object]:
    installed = json.loads(LINK.read_text())
    witness = installed["good_reduction_witness"]
    assert witness["prime"] == P == 23
    source_point = np.asarray(witness["source_point"], dtype=np.int64)

    scan = Scan()
    frame = np.column_stack(
        [scan.evaluate_seed(*seed, source_point) for seed in FRAME_SEEDS]
    ) % P
    assert frame.tolist() == witness["frame_matrix"]
    frame_inverse = inverse(frame)

    matrix_by_key = {
        tuple(int(entry) for entry in matrix.ravel()): matrix
        for matrix in scan.target_group
    }
    matrix_keys = sorted(matrix_by_key)
    matrices = [matrix_by_key[key] for key in matrix_keys]
    matrix_index = {key: index for index, key in enumerate(matrix_keys)}
    identity = np.eye(5, dtype=np.int64) % P

    involution_indices = [
        index
        for index, matrix in enumerate(matrices)
        if not np.array_equal(matrix, identity)
        and np.array_equal(matrix @ matrix % P, identity)
    ]
    assert len(matrices) == 660 and len(involution_indices) == 55

    target_lines: list[np.ndarray] = []
    section_maps: list[np.ndarray] = []
    for index in involution_indices:
        target_line = kernel((matrices[index] + identity) % P)
        assert target_line.shape == (5, 2)
        in_frame = frame_inverse @ target_line % P
        quotient_minor = in_frame[3:5, :]
        quotient_determinant = (
            int(quotient_minor[0, 0]) * int(quotient_minor[1, 1])
            - int(quotient_minor[0, 1]) * int(quotient_minor[1, 0])
        ) % P
        assert quotient_determinant
        section = in_frame @ inverse(quotient_minor) % P
        assert np.array_equal(section[3:5, :], np.eye(2, dtype=np.int64))
        target_lines.append(target_line)
        section_maps.append(section)

    involution_position = {
        group_index: position
        for position, group_index in enumerate(involution_indices)
    }
    permutations = []
    for matrix in matrices:
        matrix_inverse = inverse(matrix)
        permutation = []
        for involution_index in involution_indices:
            conjugate = matrix @ matrices[involution_index] @ matrix_inverse % P
            conjugate_index = matrix_index[
                tuple(int(entry) for entry in conjugate.ravel())
            ]
            permutation.append(involution_position[conjugate_index])
        permutations.append(tuple(permutation))
    assert len(set(permutations)) == 660

    cubic = invariant_cubic_coefficients(scan)
    input_line_keys = {
        normalized_map([section[row] for row in range(5)])[0]: index
        for index, section in enumerate(section_maps)
    }

    pair_data: dict[
        tuple[int, int], tuple[tuple[int, ...], int, int, int | None]
    ] = {}
    cubic_identity_checks = 0
    graph_identity_checks = 0
    for first in range(55):
        for second in range(first + 1, 55):
            alpha = directional_derivative(
                frame, cubic, section_maps[first], section_maps[second]
            )
            beta = directional_derivative(
                frame, cubic, section_maps[second], section_maps[first]
            )
            residual = [
                poly_add(
                    poly_scale(poly_mul(beta, section_maps[first][row]), -1),
                    poly_mul(alpha, section_maps[second][row]),
                )
                for row in range(5)
            ]
            assert any(np.any(coordinate) for coordinate in residual)
            assert not np.any(evaluate_cubic(frame, cubic, residual))
            cubic_identity_checks += 1
            graph = poly_add(
                poly_mul(residual[3], np.array([0, 1], dtype=object)),
                poly_scale(
                    poly_mul(residual[4], np.array([1, 0], dtype=object)), -1
                ),
            )
            assert not np.any(graph)
            graph_identity_checks += 1
            key, degree, gcd_degree = normalized_map(residual)
            pair_data[(first, second)] = (
                key,
                degree,
                gcd_degree,
                input_line_keys.get(key),
            )

    unseen = set(pair_data)
    orbit_payloads = []
    triangle_sets: set[frozenset[int]] = set()
    orbit_index = 0
    while unseen:
        representative = min(unseen)
        orbit = {
            tuple(
                sorted(
                    (
                        permutation[representative[0]],
                        permutation[representative[1]],
                    )
                )
            )
            for permutation in permutations
        }
        unseen -= orbit

        setwise_stabilizer = [
            permutation
            for permutation in permutations
            if tuple(
                sorted(
                    (
                        permutation[representative[0]],
                        permutation[representative[1]],
                    )
                )
            )
            == representative
        ]
        pointwise = sum(
            permutation[representative[0]] == representative[0]
            and permutation[representative[1]] == representative[1]
            for permutation in setwise_stabilizer
        )
        swapping = sum(
            permutation[representative[0]] == representative[1]
            and permutation[representative[1]] == representative[0]
            for permutation in setwise_stabilizer
        )

        degrees = Counter(pair_data[pair][1] for pair in orbit)
        gcd_degrees = Counter(pair_data[pair][2] for pair in orbit)
        residual_keys = {pair_data[pair][0] for pair in orbit}
        matching_pairs = [
            pair for pair in orbit if pair_data[pair][3] is not None
        ]
        matched_outputs = {
            int(pair_data[pair][3]) for pair in matching_pairs
        }
        span_ranks = Counter(
            rank(
                np.concatenate(
                    (target_lines[pair[0]], target_lines[pair[1]]), axis=1
                )
            )
            for pair in orbit
        )

        if orbit_index == 0:
            assert len(orbit) == 165 and span_ranks == {3: 165}
            for pair in matching_pairs:
                output = int(pair_data[pair][3])
                assert output not in pair
                triangle_sets.add(frozenset((pair[0], pair[1], output)))

        orbit_payloads.append(
            {
                "id": f"O{orbit_index}",
                "representative": list(representative),
                "size": len(orbit),
                "stabilizer_order": len(setwise_stabilizer),
                "pointwise_stabilizer_order": pointwise,
                "swapping_elements": swapping,
                "line_span_rank_histogram": {
                    str(key): value for key, value in sorted(span_ranks.items())
                },
                "residual_H_degree_histogram": {
                    str(key): value for key, value in sorted(degrees.items())
                },
                "coordinate_gcd_degree_histogram": {
                    str(key): value
                    for key, value in sorted(gcd_degrees.items())
                },
                "distinct_residual_maps": len(residual_keys),
                "pairs_returning_input_line": len(matching_pairs),
                "distinct_input_line_outputs": len(matched_outputs),
                "scoped_interpretation": (
                    "55 specialized line triangles; residual returns the third "
                    "specialized line map"
                    if orbit_index == 0
                    else (
                        "all residual maps distinct at the frozen witness; the orbit "
                        "contains a gcd-free coordinate-degree-four graph map"
                    )
                ),
            }
        )
        orbit_index += 1

    output_multiplicities = Counter(
        key for key, _, _, _ in pair_data.values()
    )
    fibre_histogram = Counter(output_multiplicities.values())
    assert len(triangle_sets) == 55
    assert all(
        sum(pair <= triangle for pair in map(frozenset, pair_data)) == 3
        for triangle in triangle_sets
    )

    return {
        "schema": "m3-line-pair-residuals-p23-v1",
        "scope": (
            "exact frozen F_23 good-reduction specialization; pair-secant "
            "census only"
        ),
        "theorem_boundary": (
            "This finite-field certificate concerns only the displayed F_23 "
            "witness, specialized line maps, residual maps, and orbit census; "
            "it makes no characteristic-zero inference."
        ),
        "inputs": {
            "goal_runs_after_35fa/M_SARKISOV/links/schur_plane_012_dp3/link_payload.json": sha256(
                LINK
            ),
            "tmp/projective_source/landing_scan.py": sha256(
                PROJECTIVE / "landing_scan.py"
            ),
            "tmp/projective_source/character_scan.py": sha256(
                PROJECTIVE / "character_scan.py"
            ),
            "tmp/projective_source/invariant_scan.py": sha256(
                PROJECTIVE / "invariant_scan.py"
            ),
            "tmp/fano14_twist/fano_covariant_scan.py": sha256(
                PROBLEM / "tmp" / "fano14_twist" / "fano_covariant_scan.py"
            ),
            "tmp/projective_source/degree8_m2.py": sha256(
                PROJECTIVE / "degree8_m2.py"
            ),
            "tmp/projective_source/degree8_rational_frame.py": sha256(
                PROJECTIVE / "degree8_rational_frame.py"
            ),
        },
        "witness": {
            "prime": P,
            "zeta11": witness["zeta11"],
            "source_point": witness["source_point"],
            "frame_matrix": frame.tolist(),
            "target_group_order": len(matrices),
            "involution_line_count": len(section_maps),
            "all_projection_minors_nonzero": True,
        },
        "residual_formula": {
            "alpha_ij": "dPhi_(P_i)(P_j)",
            "beta_ij": "dPhi_(P_j)(P_i)",
            "R_ij": "-beta_ij*P_i+alpha_ij*P_j",
        },
        "checks": {
            "unordered_pairs": len(pair_data),
            "cubic_identities": cubic_identity_checks,
            "graph_identities": graph_identity_checks,
            "pair_orbit_sizes": [entry["size"] for entry in orbit_payloads],
            "total_distinct_residual_maps": len(output_multiplicities),
            "residual_map_fibre_size_histogram": {
                str(key): value for key, value in sorted(fibre_histogram.items())
            },
            "line_triangle_count": len(triangle_sets),
        },
        "pair_orbits": orbit_payloads,
        "conclusions": [
            "At the frozen F_23 witness, the triangle-pair orbit folds three-to-one onto the 55 specialized line maps.",
            "The other five specialized pair orbits have sizes 165 or 330 at this exact witness.",
            "Each nontriangle orbit contains a residual map over F_23 with coordinate gcd one and residual H-degree four.",
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    text = json.dumps(build_payload(), indent=2, sort_keys=True) + "\n"
    if args.write:
        output = HERE / "line_pair_residuals.json"
        output.write_text(text)
        print(f"WROTE {output}")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
