#!/usr/bin/env python3
"""Independent center-census and involution-line normal-bundle verifier."""

from __future__ import annotations

import json
import sys
from pathlib import Path

PACKET = Path(__file__).resolve().parent
PROBLEM = PACKET.parents[1]
sys.path.insert(0, str(PROBLEM / "certificates"))

import exact_weil_check as ew  # noqa: E402

DATA = json.loads((PACKET / "payload" / "centre_census.json").read_text())
PRIME = 331
ZETA = 270


def reduce_cyclotomic(value):
    total = 0
    power = 1
    for coefficient in value.a:
        total += (
            coefficient.numerator
            * pow(coefficient.denominator, -1, PRIME)
            * power
        )
        power = power * ZETA % PRIME
    return total % PRIME


def rref_nullspace(matrix):
    data = [[entry % PRIME for entry in row] for row in matrix]
    rows = len(data)
    columns = len(data[0])
    pivot_row = 0
    pivots = []
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, rows) if data[row][column]), None
        )
        if pivot is None:
            continue
        data[pivot_row], data[pivot] = data[pivot], data[pivot_row]
        inverse = pow(data[pivot_row][column], -1, PRIME)
        data[pivot_row] = [inverse * entry % PRIME for entry in data[pivot_row]]
        for row in range(rows):
            if row != pivot_row and data[row][column]:
                factor = data[row][column]
                data[row] = [
                    (data[row][j] - factor * data[pivot_row][j]) % PRIME
                    for j in range(columns)
                ]
        pivots.append(column)
        pivot_row += 1
    basis = []
    for free in (column for column in range(columns) if column not in pivots):
        vector = [0] * columns
        vector[free] = 1
        for row, column in enumerate(pivots):
            vector[column] = -data[row][free] % PRIME
        basis.append(vector)
    return basis


def rank(rows):
    data = [row[:] for row in rows]
    result = 0
    for column in range(len(data[0])):
        pivot = next(
            (row for row in range(result, len(data)) if data[row][column] % PRIME),
            None,
        )
        if pivot is None:
            continue
        data[result], data[pivot] = data[pivot], data[result]
        inverse = pow(data[result][column], -1, PRIME)
        data[result] = [inverse * entry % PRIME for entry in data[result]]
        for row in range(len(data)):
            if row != result and data[row][column]:
                factor = data[row][column]
                data[row] = [
                    (data[row][j] - factor * data[result][j]) % PRIME
                    for j in range(5)
                ]
        result += 1
    return result


def determinant(matrix):
    a = matrix
    return (
        a[0][0] * (a[1][1] * a[2][2] - a[1][2] * a[2][1])
        - a[0][1] * (a[1][0] * a[2][2] - a[1][2] * a[2][0])
        + a[0][2] * (a[1][0] * a[2][1] - a[1][1] * a[2][0])
    ) % PRIME


def verify_line_normal():
    involution = [[reduce_cyclotomic(entry) for entry in row] for row in ew.S]
    minus_equations = [
        [
            (involution[i][j] + (1 if i == j else 0)) % PRIME
            for j in range(5)
        ]
        for i in range(5)
    ]
    minus_basis = rref_nullspace(minus_equations)
    assert len(minus_basis) == 2
    rows = minus_basis[:]
    complement = []
    for coordinate in range(5):
        vector = [int(index == coordinate) for index in range(5)]
        if rank(rows + [vector]) > rank(rows):
            rows.append(vector)
            complement.append(vector)
        if len(complement) == 3:
            break

    first, second = minus_basis
    quadratic_matrix = []
    for normal in complement:
        u2 = uv = v2 = 0
        for i in range(5):
            following = (i + 1) % 5
            u2 += (
                2 * first[i] * normal[i] * first[following]
                + first[i] * first[i] * normal[following]
            )
            v2 += (
                2 * second[i] * normal[i] * second[following]
                + second[i] * second[i] * normal[following]
            )
            uv += (
                2
                * (
                    first[i] * normal[i] * second[following]
                    + second[i] * normal[i] * first[following]
                )
                + 2 * first[i] * second[i] * normal[following]
            )
        quadratic_matrix.append([u2 % PRIME, uv % PRIME, v2 % PRIME])

    witness = DATA["line_normal_witness_mod331"]
    assert witness["zeta11"] == ZETA
    assert minus_basis == witness["minus_basis"]
    assert complement == witness["ambient_complement"]
    assert quadratic_matrix == witness["quadratic_map_matrix"]
    assert determinant(quadratic_matrix) == witness["determinant"] == 222
    # Nonzero H^0(O^3)->H^0(O(2)) determinant means H^0(N(-1))=0.
    # Since deg N=0, the cubic-line splitting is O+O rather than O(1)+O(-1).
    assert witness["conclusion"] == "N_L/X=O+O"


def main():
    assert DATA["schema"] == "m2-equivariant-sarkisov-centres-v1"
    centers = DATA["centers"]
    assert [center["rank"] for center in centers] == list(range(1, 11))
    assert centers[0]["id"] == DATA["selected_center"]
    point = next(center for center in centers if center["id"] == "degree55_closed_point")
    assert point["ordinary_blowup_minus_K_cube"] == 24 - 8 * 55 == -416
    line = next(center for center in centers if center["id"] == "involution_minus_line_orbit")
    assert line["single_line_minus_K_cube"] == 22 - 4 * 1 + 2 * 0 == 18
    for center in DATA["standard_weak_fano_curve_types"]:
        assert center["volume"] == 22 - 4 * center["d"] + 2 * center["g"]
    assert len(DATA["standard_weak_fano_curve_types"]) == 10
    verify_line_normal()
    print("PASS ranked named center census and all weak-Fano volumes")
    print("PASS exact involution-line normal bundle N_L/X=O+O")
    print("M2_CENTRE_CENSUS_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()

