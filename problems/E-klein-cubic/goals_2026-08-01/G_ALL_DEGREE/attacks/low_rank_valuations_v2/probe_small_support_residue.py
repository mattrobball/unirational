#!/usr/bin/env python3
"""Discovery-only small-support search on the full f5/f6 residue twists.

This probe uses all five genuine Hilbert--90 frame columns.  It searches
two-atom supports through a requested degree range and three-atom supports
at the first previously unresolved degree, after reduction modulo 67 and
the divisor f5 or f6.  A survivor is only a discovery lead.  An empty output
is a bounded ansatz exclusion, never a local-pointlessness theorem.
"""

from __future__ import annotations

import argparse
import itertools
import json
import random
import sys
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[3]
sys.path.insert(0, str(PROBLEM / "tmp" / "generic_twist"))
sys.path.insert(0, str(PROBLEM / "tmp" / "kproj_arithmetic"))

from phi_coefficients import all_coefficients, evaluate_vector  # noqa: E402
from core import (  # noqa: E402
    PRIMARY_DEGREES,
    SECONDARY_DEGREES,
    evaluate_mod,
    forms,
    secondary_polynomials,
    weighted_exponents,
)


PRIME = 67
FRAME_NAMES = ("x", "C", "D", "E", "K")
FRAME_DEGREES = (1, 4, 5, 6, 7)
TARGET_INDEX = {5: 1, 6: 2}
TERNARY_MONOMIALS = tuple(
    exponents
    for exponents in itertools.product(range(4), repeat=3)
    if sum(exponents) == 3
)
TERNARY_INDEX = {exponents: index for index, exponents in enumerate(TERNARY_MONOMIALS)}


def quotient_basis(degree: int, target: int):
    if degree < 0:
        return []
    target_index = TARGET_INDEX[target]
    result = []
    for secondary_index, secondary_degree in enumerate(SECONDARY_DEGREES):
        remainder = degree - secondary_degree
        if remainder < 0:
            continue
        for exponents in weighted_exponents(remainder):
            if exponents[target_index] == 0:
                result.append((secondary_index, tuple(exponents)))
    return result


def candidates(target: int, total_degree: int):
    return [
        (frame_index, secondary_index, exponents)
        for frame_index, frame_degree in enumerate(FRAME_DEGREES)
        for secondary_index, exponents in quotient_basis(
            total_degree - frame_degree, target
        )
    ]


def basis_value(record, primary_values, secondary_values):
    _, secondary_index, exponents = record
    value = secondary_values[secondary_index]
    for base, exponent in zip(primary_values, exponents):
        value = value * pow(base, exponent, PRIME) % PRIME
    return value


def klein(vector):
    return sum(
        vector[index] * vector[index] * vector[(index + 1) % 5]
        for index in range(5)
    ) % PRIME


def source_samples(target: int, count: int):
    invariant_forms = forms()
    secondary_forms = secondary_polynomials()
    _, frame, _ = all_coefficients()
    rng = random.Random(202608019000 + target)
    samples = []
    attempts = 0
    while len(samples) < count:
        attempts += 1
        point = tuple(rng.randrange(PRIME) for _ in range(5))
        if point == (0, 0, 0, 0, 0):
            continue
        if evaluate_mod(invariant_forms[target], point, PRIME):
            continue
        primary_values = tuple(
            evaluate_mod(invariant_forms[degree], point, PRIME)
            for degree in PRIMARY_DEGREES
        )
        secondary_values = tuple(
            evaluate_mod(polynomial, point, PRIME)
            for polynomial in secondary_forms
        )
        frame_values = tuple(
            tuple(entry % PRIME for entry in evaluate_vector(vector, point))
            for vector in frame
        )
        samples.append((point, primary_values, secondary_values, frame_values))
    return attempts, samples


def evaluated_candidates(records, sample):
    _, primary_values, secondary_values, frame_values = sample
    answer = []
    for record in records:
        frame_index = record[0]
        scalar = basis_value(record, primary_values, secondary_values)
        answer.append(
            tuple(scalar * entry % PRIME for entry in frame_values[frame_index])
        )
    return answer


def label(record):
    frame_index, secondary_index, exponents = record
    return {
        "frame": FRAME_NAMES[frame_index],
        "frame_index": frame_index,
        "secondary": secondary_index,
        "primary_exponents": list(exponents),
    }


def trim(polynomial):
    answer = [entry % PRIME for entry in polynomial]
    while answer and answer[-1] == 0:
        answer.pop()
    return answer


def polynomial_remainder(dividend, divisor):
    work = trim(dividend)
    divisor = trim(divisor)
    assert divisor
    inverse = pow(divisor[-1], -1, PRIME)
    while len(work) >= len(divisor):
        coefficient = work[-1] * inverse % PRIME
        shift = len(work) - len(divisor)
        for index, entry in enumerate(divisor):
            work[index + shift] = (work[index + shift] - coefficient * entry) % PRIME
        work = trim(work)
    return work


def polynomial_gcd(left, right):
    left, right = trim(left), trim(right)
    while right:
        left, right = right, polynomial_remainder(left, right)
    if not left:
        return []
    inverse = pow(left[-1], -1, PRIME)
    return [(entry * inverse) % PRIME for entry in left]


def binary_coefficients(u, v):
    row = [0, 0, 0, 0]
    vectors = (u, v)
    for coordinate in range(5):
        following = (coordinate + 1) % 5
        for left, middle, right in itertools.product(range(2), repeat=3):
            coefficient = (
                vectors[left][coordinate]
                * vectors[middle][coordinate]
                * vectors[right][following]
            ) % PRIME
            exponent = left + middle + right
            row[exponent] = (row[exponent] + coefficient) % PRIME
    return trim(row)


def single_search(records, sample_values):
    return [
        label(record)
        for index, record in enumerate(records)
        if all(klein(values[index]) == 0 for values in sample_values)
    ]


def pair_search(records, sample_values):
    survivors = []
    for left in range(len(records)):
        for right in range(left + 1, len(records)):
            common = []
            for values in sample_values:
                u, v = values[left], values[right]
                polynomial = binary_coefficients(u, v)
                if not polynomial:
                    continue
                common = polynomial if not common else polynomial_gcd(common, polynomial)
                if len(common) == 1:
                    break
            if not common or len(common) > 1:
                survivors.append(
                    {
                        "left": label(records[left]),
                        "right": label(records[right]),
                        "common_factor_mod_67_low_to_high": common,
                        "common_factor_degree": None if not common else len(common) - 1,
                    }
                )
    return survivors


def ternary_coefficients(vectors):
    row = [0] * len(TERNARY_MONOMIALS)
    for coordinate in range(5):
        following = (coordinate + 1) % 5
        for left, middle, right in itertools.product(range(3), repeat=3):
            coefficient = (
                vectors[left][coordinate]
                * vectors[middle][coordinate]
                * vectors[right][following]
            ) % PRIME
            exponents = [0, 0, 0]
            exponents[left] += 1
            exponents[middle] += 1
            exponents[right] += 1
            slot = TERNARY_INDEX[tuple(exponents)]
            row[slot] = (row[slot] + coefficient) % PRIME
    return np.array(row, dtype=np.int64)


def projective_chart_values():
    ratios = [(left, right) for left in range(PRIME) for right in range(PRIME)]
    matrix = np.array(
        [
            [
                pow(left, exponents[1], PRIME)
                * pow(right, exponents[2], PRIME)
                % PRIME
                for exponents in TERNARY_MONOMIALS
            ]
            for left, right in ratios
        ],
        dtype=np.int64,
    )
    return ratios, matrix


def triple_search(records, sample_values):
    ratios, monomial_values = projective_chart_values()
    survivors = []
    for indices in itertools.combinations(range(len(records)), 3):
        if not any(records[index][0] >= 3 for index in indices):
            continue
        possible = np.ones(len(ratios), dtype=bool)
        for values in sample_values:
            coefficients = ternary_coefficients([values[index] for index in indices])
            evaluations = monomial_values @ coefficients % PRIME
            possible &= evaluations == 0
            if not possible.any():
                break
        if possible.any():
            survivors.append(
                {
                    "atoms": [label(records[index]) for index in indices],
                    "ratios_mod_67": [
                        list(ratios[index]) for index in np.flatnonzero(possible)
                    ],
                }
            )
    return survivors


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--upper", type=int, default=30)
    parser.add_argument("--samples", type=int, default=12)
    args = parser.parse_args()

    result = {
        "schema": "g_low_rank_small_support_probe_v1",
        "prime": PRIME,
        "scope": (
            "two basis atoms are screened geometrically by polynomial gcds through "
            "the displayed degree range; three atoms are discovery-only over F67 "
            "at the first open degree; full five-column frame"
        ),
        "targets": {},
        "strict_nonclaim": (
            "empty bounded supports do not prove residue pointlessness; "
            "finite-field survivors do not prove characteristic-zero points"
        ),
    }
    for target, first_open in ((5, 16), (6, 15)):
        attempts, samples = source_samples(target, args.samples)
        target_rows = {
            "source_sample_attempts": attempts,
            "source_points": [list(sample[0]) for sample in samples],
            "pair_rows": [],
        }
        for degree in range(first_open, args.upper + 1):
            records = candidates(target, degree)
            values = [evaluated_candidates(records, sample) for sample in samples]
            single_survivors = single_search(records, values)
            survivors = pair_search(records, values)
            target_rows["pair_rows"].append(
                {
                    "degree": degree,
                    "candidate_count": len(records),
                    "support_count": len(records) * (len(records) - 1) // 2,
                    "single_survivors": single_survivors,
                    "survivors": survivors,
                }
            )
            print(
                f"f{target} degree={degree} pairs={len(records)*(len(records)-1)//2} "
                f"single-survivors={len(single_survivors)} pair-survivors={len(survivors)}",
                flush=True,
            )
        records = candidates(target, first_open)
        values = [evaluated_candidates(records, sample) for sample in samples]
        triple_survivors = triple_search(records, values)
        target_rows["triple_first_open"] = {
            "degree": first_open,
            "candidate_count": len(records),
            "survivors": triple_survivors,
        }
        print(
            f"f{target} degree={first_open} triple-survivors={len(triple_survivors)}",
            flush=True,
        )
        result["targets"][f"f{target}"] = target_rows

    output = HERE / "small_support_probe.json"
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(f"SMALL_SUPPORT_RESIDUE_PROBE_COMPLETE output={output.name}")


if __name__ == "__main__":
    main()
