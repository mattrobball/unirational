#!/usr/bin/env python3
"""Independent replay verifier for the complete degree-six 11:5 theorem."""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path


HERE = Path(__file__).resolve().parent
DEGREE = 6
DIMENSION = 19
PRIME = 23
WEIGHTS = (1, 9, 4, 3, 5)
UNIT_SHA256 = "68d77439b2111e36e9ce84ef0111c7f0fc9502eed91f88dc0f41a14b64d4f4af"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compositions(total: int, length: int):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, length - 1):
            yield (first,) + rest


def shift(exponents: tuple[int, ...], amount: int) -> tuple[int, ...]:
    answer = [0] * 5
    for index, exponent in enumerate(exponents):
        answer[(index + amount) % 5] = exponent
    return tuple(answer)


def add(*values: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(sum(entries) for entries in zip(*values))


def equations(character: int, prime: int):
    basis = tuple(
        exponents
        for exponents in compositions(DEGREE, 5)
        if sum(a * b for a, b in zip(exponents, WEIGHTS)) % 11 == 1
    )
    if character:
        root5 = next(
            value
            for value in range(2, prime)
            if pow(value, 5, prime) == 1 and value != 1
        )
        scales = [pow(root5, character * index, prime) for index in range(5)]
    else:
        scales = [1] * 5
    rows: dict[tuple[int, ...], dict[tuple[int, ...], int]] = {}
    for cyclic_index in range(5):
        current = [shift(value, cyclic_index) for value in basis]
        following = [shift(value, cyclic_index + 1) for value in basis]
        scalar = (
            scales[cyclic_index] ** 2 * scales[(cyclic_index + 1) % 5]
        ) % prime
        for left, left_exp in enumerate(current):
            for middle, middle_exp in enumerate(current):
                for right, right_exp in enumerate(following):
                    source = add(left_exp, middle_exp, right_exp)
                    term = tuple(sorted((left, middle, right)))
                    row = rows.setdefault(source, {})
                    row[term] = (row.get(term, 0) + scalar) % prime
    rows = {
        source: {term: value for term, value in row.items() if value}
        for source, row in rows.items()
    }
    rows = {source: row for source, row in rows.items() if row}
    return basis, rows


def canonical_row_space(rows, prime: int):
    pivots = {}
    for source_row in rows:
        row = {term: value % prime for term, value in source_row.items() if value % prime}
        while row:
            pivot = max(row)
            if pivot not in pivots:
                inverse = pow(row[pivot], -1, prime)
                pivots[pivot] = {
                    term: value * inverse % prime for term, value in row.items()
                }
                break
            scale = row[pivot]
            for term, value in pivots[pivot].items():
                replacement = (row.get(term, 0) - scale * value) % prime
                if replacement:
                    row[term] = replacement
                else:
                    row.pop(term, None)
    for pivot in sorted(pivots):
        reducer = pivots[pivot]
        for larger in sorted((value for value in pivots if value > pivot)):
            scale = pivots[larger].get(pivot, 0)
            if not scale:
                continue
            row = pivots[larger]
            for term, value in reducer.items():
                replacement = (row.get(term, 0) - scale * value) % prime
                if replacement:
                    row[term] = replacement
                else:
                    row.pop(term, None)
    return tuple(
        (pivot, tuple(sorted(row.items()))) for pivot, row in sorted(pivots.items())
    )


def parse_polynomial(value: str, prime: int):
    row = {}
    for raw_term in value.rstrip(",").split("+"):
        factors = raw_term.split("*")
        coefficient = 1
        if factors[0].isdigit():
            coefficient = int(factors.pop(0)) % prime
        indices = []
        for factor in factors:
            match = re.fullmatch(r"c(\d+)(?:\^(\d+))?", factor)
            assert match is not None
            coordinate = int(match.group(1))
            exponent = int(match.group(2) or 1)
            assert 0 <= coordinate < DIMENSION and exponent > 0
            indices.extend([coordinate] * exponent)
        term = tuple(sorted(indices))
        assert len(term) == 3 and term not in row
        row[term] = coefficient
    return row


def index_weight(exponents: tuple[int, ...]) -> int:
    return sum(index * exponent for index, exponent in enumerate(exponents)) % 5


def main() -> None:
    base = HERE / "degree6_chi0_p23.in"
    lines = base.read_text().splitlines()
    assert lines[0].split(",") == [f"c{index}" for index in range(DIMENSION)]
    assert lines[1] == str(PRIME) and len(lines[2:]) == 128
    input_rows = [parse_polynomial(line, PRIME) for line in lines[2:]]
    basis, raw = equations(0, PRIME)
    assert len(basis) == DIMENSION and len(raw) == 640
    raw_space = canonical_row_space(raw.values(), PRIME)
    input_space = canonical_row_space(input_rows, PRIME)
    assert len(raw_space) == len(input_space) == 128 and raw_space == input_space

    prime331 = 331
    root5 = next(
        value
        for value in range(2, prime331)
        if pow(value, 5, prime331) == 1 and value != 1
    )
    basis0, equations0 = equations(0, prime331)
    checks = 0
    for character in range(5):
        basis_k, equations_k = equations(character, prime331)
        assert basis_k == basis0 and equations_k.keys() == equations0.keys()
        coefficient_scales = [
            pow(root5, -character * index_weight(exponents), prime331)
            for exponents in basis0
        ]
        for source, polynomial0 in equations0.items():
            polynomial_k = equations_k[source]
            assert polynomial_k.keys() == polynomial0.keys()
            equation_scale = pow(root5, character * index_weight(source), prime331)
            for term, coefficient0 in polynomial0.items():
                expected = equation_scale * coefficient0
                for coordinate in term:
                    expected *= coefficient_scales[coordinate]
                assert polynomial_k[term] == expected % prime331
                checks += 1
    assert checks == 90250

    chart_manifest = json.loads((HERE / "degree6_chi0_p23_charts.json").read_text())
    final = json.loads((HERE / "degree6_all_character_results.json").read_text())
    assert chart_manifest["charts_cover_projective_space"]
    assert final["schema"] == "klein-f55-degree6-all-character-decision-v1"
    assert final["projective_characters_mod_5"] == list(range(5))
    assert final["character_zero_all_projective_charts_empty"]
    assert final["all_characters_empty_in_characteristic_zero"]
    assert len(chart_manifest["records"]) == len(final["records"]) == DIMENSION
    for chart in range(DIMENSION):
        manifest_record = chart_manifest["records"][chart]
        final_record = final["records"][chart]
        assert manifest_record["chart"] == final_record["chart"] == chart
        chart_input = HERE / manifest_record["input_file"]
        expected_lines = lines[:-1] + [lines[-1] + ",", f"c{chart}-1"]
        assert chart_input.read_text() == "\n".join(expected_lines) + "\n"
        assert sha256(chart_input) == manifest_record["input_sha256"]
        leading = HERE / final_record["leading_file"]
        log = HERE / final_record["log_file"]
        assert sha256(leading) == final_record["leading_sha256"] == UNIT_SHA256
        assert sha256(log) == final_record["log_sha256"]
        leading_text = leading.read_text()
        assert "#field characteristic: 23" in leading_text
        assert "#length of basis:      1 element" in leading_text
        assert leading_text.rstrip().endswith("[1]:")
        log_text = log.read_text()
        assert "field characteristic            23" in log_text
        assert "homogeneous input?               0" in log_text
        assert "max pair selection            2000" in log_text
        assert "Grobner basis has a single element" in log_text
        assert "No solution" in log_text
        assert "msolve overall time" in log_text
        assert final_record["status"] == "unit_ideal_empty"

    assert PRIME % 11 == 1 and PRIME % 5 != 1
    print("PASS independent reconstruction: 640 cubics, row rank 128, exact row space")
    print("PASS independent diagonal-isomorphism checks: 90250 coefficients")
    print("PASS all 19 affine charts cover projective space and have unit ideals")
    print("PASS empty p=23 proper fibre transfers to characteristic zero")
    print("Q_F55_DEGREE6_ALL_PROJECTIVE_CHARACTERS_INDEPENDENT_REPLAY_OK")
    print("BOUNDARY degree six only; genuine Schur rational point remains undecided")


if __name__ == "__main__":
    main()
