#!/usr/bin/env python3
"""Independently verify the frozen-F_23 line-pair residual census.

This verifier never imports or executes ``produce_line_pair_residuals.py``.
Starting from the sealed parent sources, it independently rebuilds the
660-matrix target action, the 55 involution minus-line sections, every polar
third-intersection residual, and every numerical orbit summary in the JSON
ledger.  Its polynomial gcd implementation is local and does not use SymPy.
"""

from __future__ import annotations

import hashlib
import json
import sys
from collections import Counter
from math import factorial
from pathlib import Path

import numpy as np


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
DATA = HERE / "line_pair_residuals.json"
sys.path.insert(0, str(PROJECTIVE))

from character_scan import FANO  # noqa: E402
from degree8_rational_frame import FRAME_SEEDS  # noqa: E402
from landing_scan import P, Scan  # noqa: E402


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def matrix_key(matrix: np.ndarray) -> tuple[int, ...]:
    return tuple(int(entry) % P for entry in matrix.reshape(-1))


def inverse_mod(matrix: np.ndarray) -> np.ndarray:
    """Gauss-Jordan inverse over F_P, implemented locally for this replay."""

    rows, columns = matrix.shape
    assert rows == columns
    augmented = np.concatenate(
        (matrix.astype(np.int64) % P, np.eye(rows, dtype=np.int64)), axis=1
    )
    for column in range(columns):
        pivot = next(
            (row for row in range(column, rows) if augmented[row, column]),
            None,
        )
        assert pivot is not None
        if pivot != column:
            augmented[[column, pivot]] = augmented[[pivot, column]]
        augmented[column] *= pow(int(augmented[column, column]), -1, P)
        augmented[column] %= P
        for row in range(rows):
            if row == column or not augmented[row, column]:
                continue
            augmented[row] -= augmented[row, column] * augmented[column]
            augmented[row] %= P
    result = augmented[:, columns:]
    assert np.array_equal(matrix @ result % P, np.eye(rows, dtype=np.int64))
    return result


def kernel_mod(matrix: np.ndarray) -> np.ndarray:
    """Return a deterministic column basis for the nullspace over F_P."""

    reduced = matrix.astype(np.int64) % P
    rows, columns = reduced.shape
    pivot_columns: list[int] = []
    pivot_row = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, rows) if reduced[row, column]),
            None,
        )
        if pivot is None:
            continue
        if pivot != pivot_row:
            reduced[[pivot_row, pivot]] = reduced[[pivot, pivot_row]]
        reduced[pivot_row] *= pow(int(reduced[pivot_row, column]), -1, P)
        reduced[pivot_row] %= P
        for row in range(rows):
            if row == pivot_row or not reduced[row, column]:
                continue
            reduced[row] -= reduced[row, column] * reduced[pivot_row]
            reduced[row] %= P
        pivot_columns.append(column)
        pivot_row += 1

    free_columns = [
        column for column in range(columns) if column not in pivot_columns
    ]
    basis = np.zeros((columns, len(free_columns)), dtype=np.int64)
    for basis_column, free_column in enumerate(free_columns):
        basis[free_column, basis_column] = 1
        for row, pivot_column in enumerate(pivot_columns):
            basis[pivot_column, basis_column] = -reduced[row, free_column] % P
    assert not np.any(matrix @ basis % P)
    return basis


def rank_mod(matrix: np.ndarray) -> int:
    reduced = matrix.astype(np.int64) % P
    rows, columns = reduced.shape
    rank = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(rank, rows) if reduced[row, column]), None
        )
        if pivot is None:
            continue
        if pivot != rank:
            reduced[[rank, pivot]] = reduced[[pivot, rank]]
        reduced[rank] *= pow(int(reduced[rank, column]), -1, P)
        reduced[rank] %= P
        for row in range(rank + 1, rows):
            if reduced[row, column]:
                reduced[row] -= reduced[row, column] * reduced[rank]
                reduced[row] %= P
        rank += 1
    return rank


def compositions(total: int, slots: int) -> list[tuple[int, ...]]:
    result: list[tuple[int, ...]] = []

    def visit(prefix: tuple[int, ...], remaining: int, left: int) -> None:
        if left == 1:
            result.append(prefix + (remaining,))
            return
        for value in range(remaining + 1):
            visit(prefix + (value,), remaining - value, left - 1)

    visit((), total, slots)
    return result


def multinomial(exponents: tuple[int, ...]) -> int:
    result = factorial(sum(exponents))
    for exponent in exponents:
        result //= factorial(exponent)
    return result


def reynolds_frame(scan: Scan, source_point: np.ndarray) -> np.ndarray:
    """Evaluate the five serialized Reynolds seeds without Scan.evaluate_seed."""

    expected_seed = (0, 0, 0, 0, 0, 8)
    assert FRAME_SEEDS == [(output, expected_seed) for output in range(5)]
    transformed = np.einsum("gij,j->gi", scan.domain_group, source_point) % P
    columns = []
    for output, exponents in FRAME_SEEDS:
        weights = np.ones(len(transformed), dtype=np.int64)
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                weights *= np.power(transformed[:, coordinate], exponent) % P
                weights %= P
        column = (
            scan.target_inverse_group[:, :, output] * weights[:, None]
        ).sum(axis=0) % P
        columns.append(column.astype(np.int64))
    return np.column_stack(columns) % P


def reynolds_cubic(scan: Scan) -> dict[tuple[int, ...], int]:
    """Expand the target Reynolds cubic independently from degree8_m2.py."""

    assert scan.cubic_seed == (0, 0, 0, 0, 3)
    rows = scan.target_group[:, 4, :]
    result: dict[tuple[int, ...], int] = {}
    for exponents in compositions(3, 5):
        values = np.ones(len(rows), dtype=np.int64)
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                values *= np.power(rows[:, coordinate], exponent) % P
                values %= P
        coefficient = multinomial(exponents) * int(values.sum()) % P
        if coefficient:
            result[exponents] = coefficient
    assert result
    return result


# Homogeneous binary forms use coefficients of s^(d-i)t^i, i=0,...,d.
def form_add(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    assert len(left) == len(right)
    return (left.astype(np.int64) + right.astype(np.int64)) % P


def form_scale(value: np.ndarray, scalar: int) -> np.ndarray:
    return value.astype(np.int64) * (int(scalar) % P) % P


def form_mul(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    return np.convolve(left.astype(np.int64), right.astype(np.int64)) % P


def form_power(value: np.ndarray, exponent: int) -> np.ndarray:
    result = np.array([1], dtype=np.int64)
    for _ in range(exponent):
        result = form_mul(result, value)
    return result


def target_coordinates(
    frame: np.ndarray, coordinates: list[np.ndarray]
) -> list[np.ndarray]:
    return [
        sum(
            (
                form_scale(coordinates[column], int(frame[row, column]))
                for column in range(5)
            ),
            np.zeros_like(coordinates[0]),
        )
        % P
        for row in range(5)
    ]


def evaluate_cubic(
    cubic: dict[tuple[int, ...], int], coordinates: list[np.ndarray]
) -> np.ndarray:
    degree = len(coordinates[0]) - 1
    assert all(len(coordinate) == degree + 1 for coordinate in coordinates)
    result = np.zeros(3 * degree + 1, dtype=np.int64)
    for exponents, coefficient in cubic.items():
        term = np.array([coefficient], dtype=np.int64)
        for variable, exponent in enumerate(exponents):
            if exponent:
                term = form_mul(term, form_power(coordinates[variable], exponent))
        result = form_add(result, term)
    return result


def polar_line_coefficients(
    cubic: dict[tuple[int, ...], int],
    first: list[np.ndarray],
    second: list[np.ndarray],
) -> list[np.ndarray]:
    """Return coefficients of x^(3-j)y^j in Phi(x*first+y*second)."""

    result = [np.zeros(4, dtype=np.int64) for _ in range(4)]
    for exponents, coefficient in cubic.items():
        factor_indices = [
            variable
            for variable, exponent in enumerate(exponents)
            for _ in range(exponent)
        ]
        assert len(factor_indices) == 3
        for mask in range(8):
            second_count = mask.bit_count()
            term = np.array([coefficient], dtype=np.int64)
            for factor, variable in enumerate(factor_indices):
                chosen = second[variable] if mask & (1 << factor) else first[variable]
                term = form_mul(term, chosen)
            result[second_count] = form_add(result[second_count], term)
    return result


# The following univariate routines store coefficients from x^0 upward.
def trim_low(coefficients: list[int]) -> list[int]:
    result = [int(value) % P for value in coefficients]
    while len(result) > 1 and result[-1] == 0:
        result.pop()
    return result


def poly_divmod_low(
    numerator: list[int], denominator: list[int]
) -> tuple[list[int], list[int]]:
    numerator = trim_low(numerator)
    denominator = trim_low(denominator)
    assert denominator != [0]
    if numerator == [0] or len(numerator) < len(denominator):
        return [0], numerator
    quotient = [0] * (len(numerator) - len(denominator) + 1)
    denominator_lead_inverse = pow(denominator[-1], -1, P)
    while numerator != [0] and len(numerator) >= len(denominator):
        shift = len(numerator) - len(denominator)
        coefficient = numerator[-1] * denominator_lead_inverse % P
        quotient[shift] = coefficient
        for index, value in enumerate(denominator):
            numerator[index + shift] -= coefficient * value
            numerator[index + shift] %= P
        numerator = trim_low(numerator)
    return trim_low(quotient), numerator


def poly_gcd_low(left: list[int], right: list[int]) -> list[int]:
    left, right = trim_low(left), trim_low(right)
    while right != [0]:
        _, remainder = poly_divmod_low(left, right)
        left, right = right, remainder
    assert left != [0]
    unit = pow(left[-1], -1, P)
    return [coefficient * unit % P for coefficient in left]


def normalized_map(
    coordinates: list[np.ndarray],
) -> tuple[tuple[int, ...], int, int]:
    """Cancel the homogeneous coordinate gcd and projectively normalize."""

    nominal_degree = len(coordinates[0]) - 1
    assert all(len(coordinate) == nominal_degree + 1 for coordinate in coordinates)
    nonzero = [coordinate % P for coordinate in coordinates if np.any(coordinate % P)]
    assert nonzero

    # Dehomogenization t=1 misses a common power of t, so remove and record it
    # first.  The remaining homogeneous gcd has nonzero s-leading coefficient
    # and is recovered exactly by a univariate Euclidean algorithm in x=s/t.
    common_t_power = min(int(np.flatnonzero(coordinate)[0]) for coordinate in nonzero)
    gcd_low: list[int] | None = None
    for coordinate in nonzero:
        dehomogenized_low = trim_low(
            list(reversed([int(value) % P for value in coordinate[common_t_power:]]))
        )
        gcd_low = (
            dehomogenized_low
            if gcd_low is None
            else poly_gcd_low(gcd_low, dehomogenized_low)
        )
    assert gcd_low is not None
    gcd_degree = common_t_power + len(gcd_low) - 1
    quotient_degree = nominal_degree - gcd_degree

    quotients: list[list[int]] = []
    for coordinate in coordinates:
        if not np.any(coordinate % P):
            quotients.append([0] * (quotient_degree + 1))
            continue
        numerator_low = trim_low(
            list(reversed([int(value) % P for value in coordinate[common_t_power:]]))
        )
        quotient_low, remainder = poly_divmod_low(numerator_low, gcd_low)
        assert remainder == [0]
        assert len(quotient_low) <= quotient_degree + 1
        quotient_low.extend([0] * (quotient_degree + 1 - len(quotient_low)))
        quotients.append(list(reversed(quotient_low)))

    vector = [value % P for quotient in quotients for value in quotient]
    first_nonzero = next(value for value in vector if value)
    unit = pow(first_nonzero, -1, P)
    key = tuple(value * unit % P for value in vector)
    return key, quotient_degree, gcd_degree


def main() -> None:
    data = json.loads(DATA.read_text())
    assert data["schema"] == "m3-line-pair-residuals-p23-v1"
    assert data["scope"] == (
        "exact frozen F_23 good-reduction specialization; pair-secant census only"
    )
    assert data["theorem_boundary"] == (
        "This finite-field certificate concerns only the displayed F_23 "
        "witness, specialized line maps, residual maps, and orbit census; "
        "it makes no characteristic-zero inference."
    )
    assert set(data) == {
        "schema",
        "scope",
        "theorem_boundary",
        "inputs",
        "witness",
        "residual_formula",
        "checks",
        "pair_orbits",
        "conclusions",
    }

    for relative, expected in data["inputs"].items():
        assert sha256(PROBLEM / relative) == expected, relative

    installed = json.loads(LINK.read_text())
    installed_witness = installed["good_reduction_witness"]
    assert P == installed_witness["prime"] == 23
    assert installed_witness["zeta11"] == 2
    source_point = np.asarray(installed_witness["source_point"], dtype=np.int64)

    # Rebuild the raw Schur action, its faithful 660-element target quotient,
    # the degree-eight Reynolds frame, and the target invariant cubic.
    scan = Scan()
    assert len(scan.domain_group) == len(scan.target_group) == 1320
    raw_target_multiplicities = Counter(
        matrix_key(matrix) for matrix in scan.target_group
    )
    assert len(raw_target_multiplicities) == 660
    assert set(raw_target_multiplicities.values()) == {2}
    matrix_by_key = {
        key: np.asarray(key, dtype=np.int64).reshape(5, 5)
        for key in raw_target_multiplicities
    }
    matrices = [matrix_by_key[key] for key in sorted(matrix_by_key)]
    matrix_index = {matrix_key(matrix): index for index, matrix in enumerate(matrices)}
    identity = np.eye(5, dtype=np.int64) % P
    assert matrix_key(identity) in matrix_index
    inverses = [inverse_mod(matrix) for matrix in matrices]
    assert all(matrix_key(value) in matrix_index for value in inverses)

    # Recover the two named Schur generators from the paired raw action.  The
    # right-multiplication checks below are coefficient-free identities in the
    # whole 1320-element representation, not tests at the frozen point.  They
    # are exactly the reindexing identities which prove
    #
    #                 Frame(G.p) = G_W Frame(p)
    #
    # for every p and G=S,T in the Reynolds construction.
    raw_source_index = {
        matrix_key(matrix): index for index, matrix in enumerate(scan.domain_group)
    }
    assert len(raw_source_index) == 1320
    named_generators: list[tuple[str, np.ndarray, np.ndarray]] = []
    for label, source_generator in zip(("S", "T"), FANO.six_dimensional_generators()):
        generator_index = raw_source_index[matrix_key(source_generator)]
        target_generator = scan.target_group[generator_index]
        for source_matrix, target_matrix in zip(
            scan.domain_group, scan.target_group
        ):
            product_index = raw_source_index[
                matrix_key(source_matrix @ source_generator % P)
            ]
            assert np.array_equal(
                scan.target_group[product_index],
                target_matrix @ target_generator % P,
            ), label
        assert Counter(
            matrix_key(matrix @ target_generator % P)
            for matrix in scan.target_group
        ) == raw_target_multiplicities
        named_generators.append(
            (label, source_generator % P, target_generator % P)
        )

    frame = reynolds_frame(scan, source_point)
    assert frame.tolist() == installed_witness["frame_matrix"]
    frame_inverse = inverse_mod(frame)
    cubic = reynolds_cubic(scan)

    involution_indices = [
        index
        for index, matrix in enumerate(matrices)
        if not np.array_equal(matrix, identity)
        and np.array_equal(matrix @ matrix % P, identity)
    ]
    assert len(involution_indices) == 55

    target_lines: list[np.ndarray] = []
    section_maps: list[np.ndarray] = []
    projection_determinants: list[int] = []
    for index in involution_indices:
        target_line = kernel_mod((matrices[index] + identity) % P)
        assert target_line.shape == (5, 2)
        assert rank_mod(target_line) == 2
        in_frame = frame_inverse @ target_line % P
        projection = in_frame[3:5, :]
        determinant = (
            int(projection[0, 0]) * int(projection[1, 1])
            - int(projection[0, 1]) * int(projection[1, 0])
        ) % P
        assert determinant
        section = in_frame @ inverse_mod(projection) % P
        assert np.array_equal(section[3:5, :], np.eye(2, dtype=np.int64))
        section_target = target_coordinates(
            frame, [section[row].copy() for row in range(5)]
        )
        assert not np.any(evaluate_cubic(cubic, section_target))
        target_lines.append(target_line)
        section_maps.append(section)
        projection_determinants.append(determinant)
    assert len({normalized_map([row for row in section])[0] for section in section_maps}) == 55

    witness = {
        "prime": P,
        "zeta11": installed_witness["zeta11"],
        "source_point": installed_witness["source_point"],
        "frame_matrix": frame.tolist(),
        "target_group_order": len(matrices),
        "involution_line_count": len(section_maps),
        "all_projection_minors_nonzero": all(projection_determinants),
    }
    assert data["witness"] == witness

    # Independently reconstruct the 660-element conjugation action on the 55
    # involutions/lines.  The sorted-matrix convention fixes all line labels.
    involution_position = {
        matrix_index_value: position
        for position, matrix_index_value in enumerate(involution_indices)
    }
    permutations: list[tuple[int, ...]] = []
    for matrix, matrix_inverse in zip(matrices, inverses):
        image: list[int] = []
        for involution_index in involution_indices:
            conjugate = matrix @ matrices[involution_index] @ matrix_inverse % P
            conjugate_index = matrix_index[matrix_key(conjugate)]
            assert conjugate_index in involution_position
            image.append(involution_position[conjugate_index])
        assert sorted(image) == list(range(55))
        permutations.append(tuple(image))
    assert len(set(permutations)) == 660

    assert data["residual_formula"] == {
        "alpha_ij": "dPhi_(P_i)(P_j)",
        "beta_ij": "dPhi_(P_j)(P_i)",
        "R_ij": "-beta_ij*P_i+alpha_ij*P_j",
    }
    input_line_keys = {
        normalized_map([section[row] for row in range(5)])[0]: index
        for index, section in enumerate(section_maps)
    }
    assert len(input_line_keys) == 55

    # Check all 1,485 polars and residual identities directly.  In contrast to
    # the producer's directional-derivative loop, polar_line_coefficients
    # expands Phi(xP+yQ) through all eight choices in every cubic monomial.
    pair_data: dict[
        tuple[int, int], tuple[tuple[int, ...], int, int, int | None]
    ] = {}
    cubic_identity_checks = 0
    graph_identity_checks = 0
    for first in range(55):
        first_target = target_coordinates(
            frame, [section_maps[first][row] for row in range(5)]
        )
        for second in range(first + 1, 55):
            second_target = target_coordinates(
                frame, [section_maps[second][row] for row in range(5)]
            )
            polar = polar_line_coefficients(cubic, first_target, second_target)
            assert not np.any(polar[0])
            assert not np.any(polar[3])
            alpha, beta = polar[1], polar[2]
            residual = [
                form_add(
                    form_scale(form_mul(beta, section_maps[first][row]), -1),
                    form_mul(alpha, section_maps[second][row]),
                )
                for row in range(5)
            ]
            assert any(np.any(coordinate) for coordinate in residual)

            residual_target = target_coordinates(frame, residual)
            assert not np.any(evaluate_cubic(cubic, residual_target))
            cubic_identity_checks += 1

            graph = form_add(
                form_mul(residual[3], np.array([0, 1], dtype=np.int64)),
                form_scale(
                    form_mul(residual[4], np.array([1, 0], dtype=np.int64)),
                    -1,
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
    assert len(pair_data) == 55 * 54 // 2 == 1485

    # Verify functoriality on actual normalized graph maps, rather than merely
    # noting that conjugation permutes the abstract involutions.  Since the
    # Reynolds cubic is a sum over the target group, the exact right-coset
    # permutation checked above also proves Phi(G_W x)=Phi(x).  For S and T we
    # now check frame covariance at the witness, all 55 normalized sections,
    # and every one of the 1,485 residual maps.  The relevant action on line
    # labels is inverse conjugation because the source point is transformed.
    for label, source_generator, target_generator in named_generators:
        transformed_frame = reynolds_frame(
            scan, source_generator @ source_point % P
        )
        assert np.array_equal(
            transformed_frame, target_generator @ frame % P
        ), label
        transformed_frame_inverse = inverse_mod(transformed_frame)
        transformed_sections: list[np.ndarray] = []
        for target_line in target_lines:
            in_transformed_frame = transformed_frame_inverse @ target_line % P
            projection = in_transformed_frame[3:5, :]
            determinant = (
                int(projection[0, 0]) * int(projection[1, 1])
                - int(projection[0, 1]) * int(projection[1, 0])
            ) % P
            assert determinant, (label, "projection")
            transformed_sections.append(
                in_transformed_frame @ inverse_mod(projection) % P
            )

        target_generator_inverse = inverse_mod(target_generator)
        pullback: list[int] = []
        forward: list[int] = []
        for position, involution_index in enumerate(involution_indices):
            involution = matrices[involution_index]
            inverse_conjugate = (
                target_generator_inverse @ involution @ target_generator % P
            )
            forward_conjugate = (
                target_generator @ involution @ target_generator_inverse % P
            )
            pullback_position = involution_position[
                matrix_index[matrix_key(inverse_conjugate)]
            ]
            forward_position = involution_position[
                matrix_index[matrix_key(forward_conjugate)]
            ]
            pullback.append(pullback_position)
            forward.append(forward_position)
            assert np.array_equal(
                transformed_sections[position], section_maps[pullback_position]
            ), (label, position)
            # Also check the target-space line action independently of the
            # normalized graph-coordinate calculation.
            assert rank_mod(
                np.concatenate(
                    (
                        target_generator @ target_lines[position] % P,
                        target_lines[forward_position],
                    ),
                    axis=1,
                )
            ) == 2
        assert sorted(pullback) == sorted(forward) == list(range(55))

        for first in range(55):
            transformed_first_target = target_coordinates(
                transformed_frame,
                [transformed_sections[first][row] for row in range(5)],
            )
            for second in range(first + 1, 55):
                transformed_second_target = target_coordinates(
                    transformed_frame,
                    [transformed_sections[second][row] for row in range(5)],
                )
                transformed_polar = polar_line_coefficients(
                    cubic, transformed_first_target, transformed_second_target
                )
                assert not np.any(transformed_polar[0])
                assert not np.any(transformed_polar[3])
                transformed_alpha = transformed_polar[1]
                transformed_beta = transformed_polar[2]
                transformed_residual = [
                    form_add(
                        form_scale(
                            form_mul(
                                transformed_beta, transformed_sections[first][row]
                            ),
                            -1,
                        ),
                        form_mul(
                            transformed_alpha, transformed_sections[second][row]
                        ),
                    )
                    for row in range(5)
                ]
                transformed_key = normalized_map(transformed_residual)[0]
                pulled_pair = tuple(sorted((pullback[first], pullback[second])))
                assert transformed_key == pair_data[pulled_pair][0], (
                    label,
                    first,
                    second,
                )

    unseen = set(pair_data)
    computed_orbits: list[dict[str, object]] = []
    triangle_sets: set[frozenset[int]] = set()
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
        assert orbit <= set(pair_data)
        unseen -= orbit

        stabilizer = [
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
            for permutation in stabilizer
        )
        swapping = sum(
            permutation[representative[0]] == representative[1]
            and permutation[representative[1]] == representative[0]
            for permutation in stabilizer
        )

        degrees = Counter(pair_data[pair][1] for pair in orbit)
        gcd_degrees = Counter(pair_data[pair][2] for pair in orbit)
        residual_keys = {pair_data[pair][0] for pair in orbit}
        matching_pairs = [pair for pair in orbit if pair_data[pair][3] is not None]
        matched_outputs = {int(pair_data[pair][3]) for pair in matching_pairs}
        span_ranks = Counter(
            rank_mod(
                np.concatenate(
                    (target_lines[pair[0]], target_lines[pair[1]]), axis=1
                )
            )
            for pair in orbit
        )

        for pair in matching_pairs:
            output = int(pair_data[pair][3])
            assert output not in pair
            triangle_sets.add(frozenset((pair[0], pair[1], output)))

        orbit_number = len(computed_orbits)
        computed_orbits.append(
            {
                "id": f"O{orbit_number}",
                "representative": list(representative),
                "size": len(orbit),
                "stabilizer_order": len(stabilizer),
                "pointwise_stabilizer_order": pointwise,
                "swapping_elements": swapping,
                "line_span_rank_histogram": {
                    str(key): value for key, value in sorted(span_ranks.items())
                },
                "residual_H_degree_histogram": {
                    str(key): value for key, value in sorted(degrees.items())
                },
                "coordinate_gcd_degree_histogram": {
                    str(key): value for key, value in sorted(gcd_degrees.items())
                },
                "distinct_residual_maps": len(residual_keys),
                "pairs_returning_input_line": len(matching_pairs),
                "distinct_input_line_outputs": len(matched_outputs),
            }
        )

    assert len(computed_orbits) == 6
    assert len(triangle_sets) == 55
    pair_sets = [frozenset(pair) for pair in pair_data]
    assert all(sum(pair <= triangle for pair in pair_sets) == 3 for triangle in triangle_sets)

    stored_orbits = data["pair_orbits"]
    assert len(stored_orbits) == len(computed_orbits)
    for index, (stored, computed) in enumerate(zip(stored_orbits, computed_orbits)):
        for key, expected in computed.items():
            assert stored[key] == expected, (index, key)
        expected_interpretation = (
            "55 specialized line triangles; residual returns the third specialized line map"
            if index == 0
            else (
                "all residual maps distinct at the frozen witness; the orbit "
                "contains a gcd-free coordinate-degree-four graph map"
            )
        )
        assert stored["scoped_interpretation"] == expected_interpretation

    output_multiplicities = Counter(key for key, _, _, _ in pair_data.values())
    fibre_histogram = Counter(output_multiplicities.values())
    computed_checks = {
        "unordered_pairs": len(pair_data),
        "cubic_identities": cubic_identity_checks,
        "graph_identities": graph_identity_checks,
        "pair_orbit_sizes": [entry["size"] for entry in computed_orbits],
        "total_distinct_residual_maps": len(output_multiplicities),
        "residual_map_fibre_size_histogram": {
            str(key): value for key, value in sorted(fibre_histogram.items())
        },
        "line_triangle_count": len(triangle_sets),
    }
    assert data["checks"] == computed_checks
    assert computed_checks["pair_orbit_sizes"] == [165, 330, 165, 330, 165, 330]
    assert computed_checks["total_distinct_residual_maps"] == 1375
    assert computed_checks["residual_map_fibre_size_histogram"] == {"1": 1320, "3": 55}
    assert data["conclusions"] == [
        "At the frozen F_23 witness, the triangle-pair orbit folds three-to-one onto the 55 specialized line maps.",
        "The other five specialized pair orbits have sizes 165 or 330 at this exact witness.",
        "Each nontriangle orbit contains a residual map over F_23 with coordinate gcd one and residual H-degree four.",
    ]

    # The serialized payload deliberately stops at the frozen-F_23 census.
    # There is nevertheless one safe, one-way characteristic-zero use of this
    # good specialization: an installed residual map fixed generically by G
    # would have a fixed reduction wherever the pinned formulas are defined.
    # All projection minors and all residual maps are defined here, while the
    # S,T-equivariant output orbits below are non-singleton.  Thus generic
    # non-fixedness follows for this installed direct pair-secant construction
    # only; it says nothing about an unrelated section or multisection.
    assert computed_orbits[0]["distinct_residual_maps"] == 55
    assert sum(
        int(entry["distinct_residual_maps"]) for entry in computed_orbits
    ) == len(output_multiplicities)
    for entry in computed_orbits[1:]:
        assert entry["distinct_residual_maps"] == entry["size"]
        assert int(entry["size"]) in (165, 330)
    assert all(int(entry["distinct_residual_maps"]) > 1 for entry in computed_orbits)

    print("PASS independently reconstructed the frozen F_23 660-matrix action")
    print("PASS independently reconstructed all 55 specialized line sections")
    print("PASS independently checked all 1,485 polar cubic and graph identities")
    print("PASS exact S,T frame/line/residual covariance for 2 x 1,485 pairs")
    print("PASS independently reproduced all six pair-orbit summaries")
    print("BRIDGE pinned good specialization excludes generic fixedness only for these installed residual maps")
    print("BOUNDARY exact frozen F_23 specialization only")
    print("M3_LINE_PAIR_RESIDUALS_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
