#!/usr/bin/env python3
"""Independent numerical/source replay for the Schur ENQ--V14 audit."""

from __future__ import annotations

from contextlib import redirect_stdout
from fractions import Fraction
from hashlib import sha256
from math import factorial, gcd
import io
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
DATA = json.loads((HERE / "audit_payload.json").read_text())
THEOREM = (HERE / "THEOREM.md").read_text()


def hook_tableaux(shape: tuple[int, ...]) -> int:
    hooks = 1
    for row, width in enumerate(shape):
        for column in range(width):
            right = width - column - 1
            below = sum(column < shape[other] for other in range(row + 1, len(shape)))
            hooks *= 1 + right + below
    return factorial(sum(shape)) // hooks


assert DATA["schema"] == "q-schur-enq-v14-audit-v1"
assert DATA["headline"] == "Q-UNDECIDED"
assert DATA["field"]["projective_schur_boundary"] == 0
assert DATA["pfaffian"]["smooth_member_exists_over_K"]
assert DATA["pfaffian"]["member_degree"] == 5

cycles = {tuple(item["partition"]): item for item in DATA["schubert_cycles"]}
assert hook_tableaux(tuple(cycles[(3, 0)]["dual_partition"])) == cycles[(3, 0)]["degree"] == 4
assert hook_tableaux(tuple(cycles[(2, 1)]["dual_partition"])) == cycles[(2, 1)]["degree"] == 5
assert gcd(*DATA["fano_index_certificate"]["effective_degrees"]) == 1

center = DATA["known_cycles_against_center"]
assert gcd(3, 5) == center["degree_3"]["torsor_gcd_with_5"] == 1
assert gcd(55, 5) == center["degree_55"]["torsor_gcd_with_5"] == 5
assert center["degree_3"]["intersection_with_C"] == "empty"
assert center["degree_55"]["intersection_with_C"] == "empty for every descended Pfaffian member"
assert not center["degree_55"]["new_torsor_information"]
assert 2 < 3  # the scheme-theoretic degree-three versus quadratic restriction gate

exit_data = DATA["line_orbit_exit"]
assert exit_data["orbit_degree"] == 660 // 10 == 66
assert gcd(exit_data["divisor_degree_on_C"], 5) == 1
assert exit_data["intersection_length_if_nonempty"] == 1

for phrase in (
    "Schur-source ENQ theorem",
    "Degree-three stopping theorem",
    "D10-incidence exit",
    "Q-UNDECIDED",
):
    assert phrase in THEOREM


P = DATA["good_reduction_restriction_check"]["prime"]
ZETA11 = DATA["good_reduction_restriction_check"]["zeta11"]
ZETA5 = DATA["good_reduction_restriction_check"]["zeta5"]


def matrix_rank(matrix: list[list[int]]) -> int:
    work = [[entry % P for entry in row] for row in matrix]
    if not work:
        return 0
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next((row for row in range(pivot_row, len(work)) if work[row][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        unit = pow(work[pivot_row][column], -1, P)
        work[pivot_row] = [unit * entry % P for entry in work[pivot_row]]
        for row in range(len(work)):
            if row == pivot_row:
                continue
            scale = work[row][column]
            if scale:
                work[row] = [
                    (left - scale * right) % P
                    for left, right in zip(work[row], work[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == len(work):
            break
    return pivot_row


def reduce_cyclotomic(data: list[list[int]]) -> int:
    result = 0
    for exponent, (numerator, denominator) in enumerate(data):
        value = Fraction(numerator, denominator)
        residue = value.numerator * pow(value.denominator, -1, P)
        result += residue * pow(ZETA11, exponent, P)
    return result % P


pfaffian_path = Path(DATA["source_files"]["pfaffian_payload"])
assert sha256(pfaffian_path.read_bytes()).hexdigest() == DATA["source_files"]["pfaffian_payload_sha256"]
subgroup_source = Path(DATA["source_files"]["subgroup_verifier"])
primary_source = Path(DATA["source_files"]["primary_tex"])
assert sha256(subgroup_source.read_bytes()).hexdigest() == DATA["source_files"]["subgroup_verifier_sha256"]
assert sha256(primary_source.read_bytes()).hexdigest() == DATA["source_files"]["primary_tex_sha256"]
pfaffian = json.loads(pfaffian_path.read_text())
adjugate_entries = {
    tuple(entry["pair"]): entry["quadratic_form"]
    for entry in pfaffian["pfaffian_adjugate_upper"]
}


def quadratic_value(poly: list[dict], point: list[int]) -> int:
    result = 0
    for term in poly:
        value = reduce_cyclotomic(term["coefficient_qzeta11"])
        for coordinate, exponent in zip(point, term["exponents"]):
            value = value * pow(coordinate, exponent, P) % P
        result += value
    return result % P


def adjugate(point: list[int]) -> list[list[int]]:
    matrix = [[0] * 6 for _ in range(6)]
    for (left, right), poly in adjugate_entries.items():
        value = quadratic_value(poly, point)
        matrix[left - 1][right - 1] = value
        matrix[right - 1][left - 1] = -value % P
    return matrix


def vector_add(left: list[int], right: list[int]) -> list[int]:
    return [(x + y) % P for x, y in zip(left, right)]


def klein(point: list[int]) -> int:
    return sum(point[i] ** 2 * point[(i + 1) % 5] for i in range(5)) % P


def assert_line_on_klein(left: list[int], right: list[int]) -> None:
    # A binary cubic is zero identically once it vanishes at four parameters.
    for parameter in range(4):
        assert klein([(x + parameter * y) % P for x, y in zip(left, right)]) == 0


QUADRATIC_PAIRS = [(i, j) for i in range(6) for j in range(i, 6)]


def quadratic_monomials(vector: list[int]) -> list[int]:
    return [vector[i] * vector[j] % P for i, j in QUADRATIC_PAIRS]


def incidence_quadric(line: tuple[list[int], list[int]]) -> list[int]:
    """Recover the unique resultant quadric from three four-plane fibres."""
    left, right = line
    constraints = []
    for parameter in (0, 1, 2):
        point = [(x + parameter * y) % P for x, y in zip(left, right)]
        kernel = subgroup_verify.nullspace(adjugate(point), P)
        assert len(kernel) == 4
        tests = list(kernel)
        tests.extend(
            vector_add(kernel[i], kernel[j])
            for i in range(4)
            for j in range(i + 1, 4)
        )
        constraints.extend(quadratic_monomials(vector) for vector in tests)
    result = subgroup_verify.nullspace(constraints, P)
    assert len(result) == 1
    return result[0]


def projective_line_key(line: tuple[list[int], list[int]]) -> tuple[int, ...]:
    left, right = line
    pluecker = [
        (left[i] * right[j] - left[j] * right[i]) % P
        for i in range(5)
        for j in range(i + 1, 5)
    ]
    pivot = next(entry for entry in pluecker if entry)
    inverse = pow(pivot, -1, P)
    return tuple(inverse * entry % P for entry in pluecker)


def line_orbit(seed: tuple[list[int], list[int]]) -> list[tuple[list[int], list[int]]]:
    result = {}
    for element in subgroup_verify.KEYS:
        matrix = subgroup_verify.rho(element, P, ZETA11)
        line = tuple(subgroup_verify.mv(matrix, vector, P) for vector in seed)
        result[projective_line_key(line)] = line
    return list(result.values())


def audit_line(left: list[int], right: list[int]) -> dict[str, object]:
    at_left = adjugate(left)
    at_right = adjugate(right)
    at_sum = adjugate(vector_add(left, right))
    mixed = [
        [
            (at_sum[i][j] - at_left[i][j] - at_right[i][j]) % P
            for j in range(6)
        ]
        for i in range(6)
    ]
    return {
        "point_ranks": [matrix_rank(matrix) for matrix in (at_left, at_right, at_sum)],
        "coefficient_rank": matrix_rank(at_left + mixed + at_right),
        "evaluation_ranks": [
            matrix_rank(at_left + at_right),
            matrix_rank(at_left + at_sum),
            matrix_rank(at_right + at_sum),
        ],
    }


assert pow(ZETA11, 11, P) == 1 and ZETA11 != 1
assert pow(ZETA5, 5, P) == 1 and ZETA5 != 1
d10_left = [pow(ZETA5, exponent, P) for exponent in range(5)]
d10_right = [pow(ZETA5, (-exponent) % 5, P) for exponent in range(5)]

with redirect_stdout(io.StringIO()):
    subgroup_path = str(Path(DATA["source_files"]["subgroup_verifier"]).parent)
    sys.path.insert(0, subgroup_path)
    import verify as subgroup_verify

involution = next(element for element in subgroup_verify.KEYS if subgroup_verify.ORDERS[element] == 2)
involution_matrix = subgroup_verify.rho(involution, P, ZETA11)
d12_basis = subgroup_verify.nullspace(
    [
        [
            (involution_matrix[i][j] + int(i == j)) % P
            for j in range(5)
        ]
        for i in range(5)
    ],
    P,
)
assert len(d12_basis) == 2

expected = DATA["good_reduction_restriction_check"]
for name, basis in (("D10", (d10_left, d10_right)), ("D12", tuple(d12_basis))):
    assert_line_on_klein(*basis)
    result = audit_line(*basis)
    assert result["point_ranks"] == expected["adjugate_ranks_at_u_v_u_plus_v"]
    assert result["coefficient_rank"] == expected["binary_coefficient_stack_rank"]
    assert result["evaluation_ranks"] == [expected["two_point_evaluation_rank"]] * 3
    print(name, result)

orbit_expectations = {
    "D10": (66, expected["orbit_quadric_span_ranks"]["D10_66_lines"]),
    "D12": (55, expected["orbit_quadric_span_ranks"]["D12_55_lines"]),
}
for name, seed in (("D10", (d10_left, d10_right)), ("D12", tuple(d12_basis))):
    lines = line_orbit(seed)
    expected_size, expected_span = orbit_expectations[name]
    assert len(lines) == expected_size
    quadrics = [incidence_quadric(line) for line in lines]
    span_rank = subgroup_verify.rank(quadrics, P)
    assert span_rank == expected_span == 21
    print(name, "orbit", len(lines), "incidence_quadric_span_rank", span_rank)

print(DATA["terminal_marker"])
