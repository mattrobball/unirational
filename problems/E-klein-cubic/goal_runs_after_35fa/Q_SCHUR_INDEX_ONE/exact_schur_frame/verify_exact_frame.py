#!/usr/bin/env python3
"""Independent replay for the exact Schur Reynolds-frame certificate."""

from __future__ import annotations

import json
import runpy
from hashlib import sha256
from pathlib import Path

from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
CORE = HERE / "exact_representation_core.py"
CERTIFICATE = HERE / "exact_frame.json"


def word_matrix(word, generators, identity):
    result = identity
    for letter in word:
        result = result.matmul(generators[letter])
    return result


def reconstruct_generators(core):
    one6 = core["identity"](6)
    schur_a, schur_b = core["schur_generators"]()
    source = {
        letter: word_matrix(
            core["WEIL_TO_PFAFFIAN"][letter],
            {"A": schur_a, "B": schur_b},
            one6,
        )
        for letter in "ST"
    }
    target_s, target_t = core["weil_generators"]()
    return source, {"S": target_s, "T": target_t}


def reconstruct_records(core, words, source, target):
    records = []
    for word in words:
        source_matrix = core["identity"](6)
        target_inverse = core["identity"](5)
        for letter in word:
            source_matrix = source_matrix.matmul(source[letter])
            target_inverse = target[letter].inv().matmul(target_inverse)
        records.append((source_matrix.to_list(), target_inverse.to_list()))
    return records


def evaluate(point, records, field):
    frame = [[field.zero for _ in range(5)] for _ in range(5)]
    invariant = field.zero
    for source, target_inverse in records:
        linear = sum((source[5][column] * point[column] for column in range(6)), field.zero)
        value = linear**8
        invariant += value
        for row in range(5):
            for column in range(5):
                frame[row][column] += target_inverse[row][column] * value
    return frame, invariant


def expected_coefficient_table():
    table = {}
    for row in range(5):
        for first in range(5):
            for second in range(5):
                for third in range(5):
                    exponent = [0] * 5
                    for column in (first, second, third):
                        exponent[column] += 1
                    key = tuple(exponent)
                    table.setdefault(key, []).append(
                        [[row, first], [row, second], [(row + 1) % 5, third]]
                    )
    return [
        {"a_exponents": list(key), "products": table[key]}
        for key in sorted(table, key=lambda key: ",".join(map(str, key)))
    ]


def poly_add(left, right, field):
    result = dict(left)
    for exponent, coefficient in right.items():
        result[exponent] = result.get(exponent, field.zero) + coefficient
        if result[exponent] == field.zero:
            del result[exponent]
    return result


def poly_mul(left, right, field):
    result = {}
    for exponent_left, coefficient_left in left.items():
        for exponent_right, coefficient_right in right.items():
            exponent = tuple(a + b for a, b in zip(exponent_left, exponent_right))
            result[exponent] = (
                result.get(exponent, field.zero) + coefficient_left * coefficient_right
            )
    return {key: value for key, value in result.items() if value != field.zero}


def transformed_klein(matrix, field):
    rows = matrix.to_list()
    linear = []
    for row in range(5):
        linear.append(
            {
                tuple(1 if column == variable else 0 for variable in range(5)): rows[row][column]
                for column in range(5)
                if rows[row][column] != field.zero
            }
        )
    result = {}
    for row in range(5):
        square = poly_mul(linear[row], linear[row], field)
        result = poly_add(
            result, poly_mul(square, linear[(row + 1) % 5], field), field
        )
    return result


def klein(field):
    return {
        tuple(2 if j == i else 1 if j == (i + 1) % 5 else 0 for j in range(5)): field.one
        for i in range(5)
    }


def main():
    certificate = json.loads(CERTIFICATE.read_text())
    core = runpy.run_path(str(CORE))
    field = core["K11"]

    assert certificate["format"] == "q-schur-exact-degree8-frame-v1"
    assert certificate["headline"] == "EXACT_FRAME_NONDEGENERATE"
    assert sha256(CORE.read_bytes()).hexdigest() == certificate["source_core"]["sha256"]

    source, target = reconstruct_generators(core)
    frozen_source = [core["deserialize_matrix"](data) for data in certificate["source_generators_ST"]]
    frozen_target = [core["deserialize_matrix"](data) for data in certificate["target_generators_ST"]]
    assert frozen_source == [source["S"], source["T"]]
    assert frozen_target == [target["S"], target["T"]]
    assert transformed_klein(target["S"], field) == klein(field)
    assert transformed_klein(target["T"], field) == klein(field)
    print("PASS frozen exact Schur/Weil generators and Klein-cubic invariance")

    abstract, canonical_words = core["abstract_group"]()
    words = certificate["projective_words"]
    assert len(abstract) == len(words) == len(set(words)) == 660
    assert words == list(canonical_words.values())
    records = reconstruct_records(core, words, source, target)
    print("PASS canonical 660-element projective Reynolds transversal")

    point = tuple(field(value) for value in certificate["witness"])
    frame, invariant = evaluate(point, records, field)
    frozen_frame = [
        [core["from_coefficients"](entry, field) for entry in row]
        for row in certificate["frame_at_witness"]
    ]
    frozen_invariant = core["from_coefficients"](
        certificate["scalar_invariant_at_witness"], field
    )
    frozen_determinant = core["from_coefficients"](
        certificate["determinant_at_witness"], field
    )
    assert frame == frozen_frame
    assert invariant == frozen_invariant != field.zero
    determinant = DomainMatrix(frame, (5, 5), field).det()
    assert determinant == frozen_determinant != field.zero

    reduction = certificate["good_reduction"]
    assert reduction["prime"] == 23 and reduction["zeta_11"] == 2
    reduced_frame = [
        [core["reduce_k11"](entry, 2, 23) for entry in row] for row in frame
    ]
    assert reduced_frame == reduction["frame"]
    assert core["reduce_k11"](determinant, 2, 23) == reduction["determinant"] == 21
    assert core["reduce_k11"](invariant, 2, 23) == reduction["scalar_invariant"] == 10
    print("PASS exact witness, nonzero scalar invariant, and nonzero frame determinant")

    # Re-evaluate after both generators; this independently checks every action
    # convention used by the finite Reynolds recipe.
    frame_dm = DomainMatrix(frame, (5, 5), field)
    for letter in "ST":
        rows = source[letter].to_list()
        transformed_point = tuple(
            sum((rows[row][column] * point[column] for column in range(6)), field.zero)
            for row in range(6)
        )
        transformed_frame, transformed_invariant = evaluate(
            transformed_point, records, field
        )
        assert DomainMatrix(transformed_frame, (5, 5), field) == target[letter].matmul(frame_dm)
        assert transformed_invariant == invariant
    print("PASS exact Reynolds covariance and invariance for S,T")

    expected_table = expected_coefficient_table()
    assert certificate["cubic_coefficient_table"] == expected_table
    assert len(expected_table) == 35
    assert sum(len(item["products"]) for item in expected_table) == 625
    assert {tuple(item["a_exponents"]) for item in expected_table} == {
        exponent
        for exponent in __import__("itertools").product(range(4), repeat=5)
        if sum(exponent) == 3
    }
    print("PASS full 35-entry descended-cubic coefficient table (625 products)")
    print("Q_SCHUR_EXACT_FRAME_INDEPENDENT_REPLAY_OK")


if __name__ == "__main__":
    main()
