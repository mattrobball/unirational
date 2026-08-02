#!/usr/bin/env python3
"""Independent replay of the exact generic Pluecker incidence.

This verifier does not import the producer.  It reconstructs every one of the
five Q(zeta11)[x]-valued hyperplanes from the sealed Q and Hilbert--90 data,
checks all fifteen Pluecker quadrics/charts, and evaluates the result at three
recorded fibres plus an unused fresh prime.
"""

from __future__ import annotations

import hashlib
import json
from fractions import Fraction
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PAIRS = tuple(combinations(range(6), 2))
PAIR_INDEX = {pair: index for index, pair in enumerate(PAIRS)}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def independently_rebuild(vector, q_coefficients):
    answer: dict[tuple[int, tuple[int, ...]], list[Fraction]] = {}
    for pair_number, (row, column) in enumerate(PAIRS):
        for coordinate in range(5):
            q_scalar = q_coefficients[row][column][coordinate]
            for monomial in vector[coordinate]:
                key = (pair_number, tuple(int(value) for value in monomial["exponents"]))
                coefficient = answer.setdefault(key, [Fraction(0) for _ in range(10)])
                for power, fraction in enumerate(q_scalar):
                    numerator, denominator = map(int, fraction)
                    coefficient[power] += (
                        int(monomial["coefficient"]) * Fraction(numerator, denominator)
                    )
    return [
        {
            "pluecker_index": pair_number,
            "pair": list(PAIRS[pair_number]),
            "x_exponents": list(exponents),
            "coefficient_Qzeta11": [
                [value.numerator, value.denominator] for value in coefficient
            ],
        }
        for (pair_number, exponents), coefficient in sorted(answer.items())
        if any(coefficient)
    ]


def primitive_root_11(prime: int) -> int:
    assert (prime - 1) % 11 == 0
    return next(value for value in range(2, prime) if pow(value, 11, prime) == 1)


def q11_mod(coefficient, prime: int, zeta: int) -> int:
    return sum(
        int(numerator) * pow(int(denominator), -1, prime) * pow(zeta, power, prime)
        for power, (numerator, denominator) in enumerate(coefficient)
    ) % prime


def evaluate_terms(terms, point, prime: int, zeta: int):
    row = [0] * 15
    for term in terms:
        value = q11_mod(term["coefficient_Qzeta11"], prime, zeta)
        for coordinate, exponent in zip(point, term["x_exponents"]):
            value = value * pow(int(coordinate), int(exponent), prime) % prime
        index = int(term["pluecker_index"])
        row[index] = (row[index] + value) % prime
    return row


def rank_mod(matrix, prime: int) -> int:
    work = [[int(entry) % prime for entry in row] for row in matrix]
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(pivot_row, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, prime)
        work[pivot_row] = [entry * inverse % prime for entry in work[pivot_row]]
        for row in range(len(work)):
            if row != pivot_row and work[row][column]:
                factor = work[row][column]
                work[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(work[row], work[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == len(work):
            break
    return pivot_row


def determinant_mod(matrix, prime: int) -> int:
    work = [[int(entry) % prime for entry in row] for row in matrix]
    determinant = 1
    for column in range(len(work)):
        pivot = next((row for row in range(column, len(work)) if work[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            determinant = -determinant
        diagonal = work[column][column]
        determinant = determinant * diagonal % prime
        inverse = pow(diagonal, -1, prime)
        for row in range(column + 1, len(work)):
            factor = work[row][column] * inverse % prime
            work[row] = [
                (left - factor * right) % prime
                for left, right in zip(work[row], work[column])
            ]
    return determinant % prime


def evaluate_vector(vector, point, prime: int):
    values = []
    for polynomial in vector:
        value = 0
        for term in polynomial:
            monomial = int(term["coefficient"]) % prime
            for coordinate, exponent in zip(point, term["exponents"]):
                monomial = monomial * pow(int(coordinate), int(exponent), prime) % prime
            value = (value + monomial) % prime
        values.append(value)
    return values


def main() -> None:
    manifest = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    payload = json.loads((HERE / "generic_pluecker_incidence.json").read_text())
    geometry = json.loads((HERE / "corrected_incidence_geometry.json").read_text())
    involution_entry = manifest["authoritative_inputs"]["involution"]
    five_entry = manifest["authoritative_inputs"]["distinguished_five_plane"]
    involution_path = ROOT / involution_entry["path"]
    five_path = ROOT / five_entry["path"]
    assert sha256(involution_path) == involution_entry["sha256"]
    assert sha256(five_path) == five_entry["sha256"]
    involution = json.loads(involution_path.read_text())
    five_plane = json.loads(five_path.read_text())

    assert payload["format"] == "c5-generic-pluecker-incidence-exact-v1"
    assert payload["source_sha256"] == {
        "involution": involution_entry["sha256"],
        "distinguished_five_plane": five_entry["sha256"],
    }
    equations = payload["equations"]
    canonical_hash = hashlib.sha256(
        json.dumps(equations, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest()
    assert canonical_hash == payload["equation_payload_sha256"]
    assert equations["pluecker_pairs_lexicographic"] == [list(pair) for pair in PAIRS]

    names = five_plane["hilbert90_frame"]["names"]
    assert [row["name"] for row in equations["linear_forms"]] == names
    for record, name in zip(equations["linear_forms"], names):
        rebuilt = independently_rebuild(
            five_plane["hilbert90_frame"]["vectors"][name],
            involution["Q_linear_coefficients"],
        )
        assert record["terms"] == rebuilt
        assert {sum(term["x_exponents"]) for term in rebuilt} == {record["x_degree"]}

    expected_quadrics = []
    for i, j, k, ell in combinations(range(6), 4):
        expected_quadrics.append(
            {
                "indices": [i, j, k, ell],
                "terms": [
                    {"coefficient": 1, "factors": [PAIR_INDEX[(i, j)], PAIR_INDEX[(k, ell)]]},
                    {"coefficient": -1, "factors": [PAIR_INDEX[(i, k)], PAIR_INDEX[(j, ell)]]},
                    {"coefficient": 1, "factors": [PAIR_INDEX[(i, ell)], PAIR_INDEX[(j, k)]]},
                ],
            }
        )
    assert equations["pluecker_quadrics"] == expected_quadrics
    assert len(payload["projective_cover"]) == 15
    assert {tuple(chart["pivot_pair"]) for chart in payload["projective_cover"]} == set(PAIRS)
    assert all(len(chart["variables"]) == 8 for chart in payload["projective_cover"])

    recorded = {row["prime"]: row for row in geometry["fibres"]}
    point = (1, 2, 3, 4, 5)
    for prime in (331, 463, 419, 617):
        zeta = primitive_root_11(prime)
        rows = [
            evaluate_terms(form["terms"], point, prime, zeta)
            for form in equations["linear_forms"]
        ]
        assert rank_mod(rows, prime) == 5
        q_matrix = [[0] * 6 for _ in range(6)]
        for value, (left, right) in zip(rows[0], PAIRS):
            q_matrix[left][right] = value
            q_matrix[right][left] = -value % prime
        assert determinant_mod(q_matrix, prime) != 0
        vectors = [
            evaluate_vector(five_plane["hilbert90_frame"]["vectors"][name], point, prime)
            for name in names
        ]
        frame_matrix = [[vectors[column][row] for column in range(5)] for row in range(5)]
        assert determinant_mod(frame_matrix, prime) != 0
        if prime in recorded:
            assert recorded[prime]["zeta11"] == zeta
            assert recorded[prime]["linear_rank"] == 5
            assert recorded[prime]["q_determinant"] == determinant_mod(q_matrix, prime)
            assert recorded[prime]["frame_determinant"] == determinant_mod(frame_matrix, prime)

    assert "not automatically" in payload["descent_semantics"]["warning"]
    print("PASS independently rebuilt all five exact Q(zeta11)[x] Pluecker hyperplanes")
    print("PASS all fifteen Pluecker quadrics and all fifteen Grassmann charts")
    print("PASS recorded fibres 331,463,419 and fresh-prime fibre 617")
    print("SCOPE exact generic split equations with explicit descent warning; no K_proj point")
    print("C5_GENERIC_PLUECKER_INCIDENCE_INDEPENDENTLY_VERIFIED")


if __name__ == "__main__":
    main()
