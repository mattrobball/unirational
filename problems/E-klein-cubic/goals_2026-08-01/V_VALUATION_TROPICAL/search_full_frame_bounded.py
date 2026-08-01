#!/usr/bin/env python3
"""Bounded full-frame landing screen on the genuine twist at f5 and f6.

For total source degree N, every homogeneous point written in the primitive
Hilbert--90 frame has the form

    P*x + Q*C + R*D + S*E + T*K,

where the coefficients are invariants modulo the target divisor in degrees
N-(1,4,5,6,7).  The certified Hironaka basis enumerates these spaces exactly.
At deterministic F_67-points of f_d=0 we build necessary homogeneous cubic
equations in all coefficients.  Macaulay2 receives the equations on stdin;
this script writes no files.

If the sampled homogeneous ideal has affine-cone dimension zero, its
projective locus is empty, rigorously excluding that total degree over
characteristic zero.  A positive-dimensional sampled locus is a nonverdict.
No bounded range is promoted to an all-degree theorem.
"""

from __future__ import annotations

import argparse
import itertools
import math
import random
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
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
FRAME_DEGREES = (1, 4, 5, 6, 7)
TARGET_INDEX = {5: 1, 6: 2}


def compositions(total, length):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for tail in compositions(total - first, length - 1):
            yield (first,) + tail


def quotient_basis(degree, target):
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
                result.append((secondary_index, exponents))
    return result


def basis_value(record, primary_values, secondary_values):
    secondary_index, exponents = record
    value = secondary_values[secondary_index]
    for base, exponent in zip(primary_values, exponents):
        value = value * pow(base, exponent, PRIME) % PRIME
    return value


def add_echelon(basis, row):
    row = [entry % PRIME for entry in row]
    for pivot, old in basis:
        if row[pivot]:
            multiplier = row[pivot]
            row = [(a - multiplier * b) % PRIME for a, b in zip(row, old)]
    try:
        pivot = next(index for index, entry in enumerate(row) if entry)
    except StopIteration:
        return False
    inverse = pow(row[pivot], -1, PRIME)
    basis.append((pivot, [entry * inverse % PRIME for entry in row]))
    return True


def cubic_row(vectors, monomial_index):
    dimension = len(vectors)
    row = [0] * math.comb(dimension + 2, 3)
    for coordinate in range(5):
        following = (coordinate + 1) % 5
        for left, middle, right in itertools.product(range(dimension), repeat=3):
            coefficient = (
                vectors[left][coordinate]
                * vectors[middle][coordinate]
                * vectors[right][following]
            ) % PRIME
            if not coefficient:
                continue
            exponents = [0] * dimension
            exponents[left] += 1
            exponents[middle] += 1
            exponents[right] += 1
            slot = monomial_index[tuple(exponents)]
            row[slot] = (row[slot] + coefficient) % PRIME
    return row


def coefficient_term(coefficient, exponents):
    factors = []
    coefficient %= PRIME
    if coefficient != 1 or not any(exponents):
        factors.append(str(coefficient))
    for index, exponent in enumerate(exponents):
        if exponent == 1:
            factors.append(f"a{index}")
        elif exponent:
            factors.append(f"a{index}^{exponent}")
    return "*".join(factors)


def m2_dimension(echelon, monomials, dimension, timeout):
    equations = []
    for _, row in echelon:
        terms = [
            coefficient_term(coefficient, exponents)
            for coefficient, exponents in zip(row, monomials)
            if coefficient % PRIME
        ]
        equations.append("+".join(terms))
    variables = ",".join(f"a{index}" for index in range(dimension))
    program = f"""R=GF({PRIME})[{variables},MonomialOrder=>GRevLex];
I=ideal(
  {',\n  '.join(equations)}
  );
print (\"DIMENSION=\" | toString dim I);
print (\"GENERATORS=\" | toString numgens I);
"""
    try:
        completed = subprocess.run(
            ["M2", "--script", "/dev/stdin"],
            input=program,
            text=True,
            capture_output=True,
            timeout=timeout,
            check=False,
        )
    except subprocess.TimeoutExpired:
        return None
    if completed.returncode:
        raise RuntimeError(completed.stdout + completed.stderr)
    line = next(line for line in completed.stdout.splitlines() if line.startswith("DIMENSION="))
    return int(line.split("=", 1)[1])


def search_case(target, total_degree, timeout):
    blocks = [quotient_basis(total_degree - degree, target) for degree in FRAME_DEGREES]
    candidates = [
        (frame_index, record)
        for frame_index, block in enumerate(blocks)
        for record in block
    ]
    dimension = len(candidates)
    if not dimension:
        return dimension, [len(block) for block in blocks], 0, None, "EMPTY_COEFFICIENT_SPACE"

    invariant_forms = forms()
    secondary_forms = secondary_polynomials()
    _, frame, _ = all_coefficients()
    monomials = tuple(compositions(3, dimension))
    monomial_index = {exponents: index for index, exponents in enumerate(monomials)}
    rng = random.Random(202608015000 + 100 * target + total_degree)
    echelon = []
    stagnant = 0
    attempts = 0
    while len(echelon) < min(900, len(monomials)) and stagnant < 80:
        attempts += 1
        point = tuple(rng.randrange(PRIME) for _ in range(5))
        if point == (0, 0, 0, 0, 0):
            continue
        if evaluate_mod(invariant_forms[target], point, PRIME):
            continue
        primary_values = [
            evaluate_mod(invariant_forms[degree], point, PRIME)
            for degree in PRIMARY_DEGREES
        ]
        secondary_values = [evaluate_mod(polynomial, point, PRIME) for polynomial in secondary_forms]
        frame_values = [
            [entry % PRIME for entry in evaluate_vector(vector, point)]
            for vector in frame
        ]
        vectors = []
        for frame_index, record in candidates:
            scalar = basis_value(record, primary_values, secondary_values)
            vectors.append([scalar * entry % PRIME for entry in frame_values[frame_index]])
        if add_echelon(echelon, cubic_row(vectors, monomial_index)):
            stagnant = 0
        else:
            stagnant += 1
    cone_dimension = m2_dimension(echelon, monomials, dimension, timeout)
    if cone_dimension == 0:
        verdict = "PROJECTIVELY_EMPTY"
    elif cone_dimension is None:
        verdict = "TIMEOUT_NONVERDICT"
    else:
        verdict = "SAMPLED_SURVIVOR"
    return dimension, [len(block) for block in blocks], len(echelon), cone_dimension, verdict


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--lower", type=int, default=1)
    parser.add_argument("--upper", type=int, default=15)
    parser.add_argument("--timeout", type=int, default=300)
    parser.add_argument("--target", choices=("5", "6", "both"), default="both")
    args = parser.parse_args()
    failures = []
    targets = (5, 6) if args.target == "both" else (int(args.target),)
    for target in targets:
        for degree in range(args.lower, args.upper + 1):
            dimension, blocks, equation_rank, cone_dimension, verdict = search_case(
                target, degree, args.timeout
            )
            print(
                f"f{target} N={degree} blocks={blocks} candidates={dimension} "
                f"equation_rank={equation_rank} cone_dimension={cone_dimension} verdict={verdict}",
                flush=True,
            )
            if verdict == "SAMPLED_SURVIVOR":
                failures.append((target, degree))
    assert not failures, failures
    print("FULL_FRAME_BOUNDED_SCREEN_COMPLETE")


if __name__ == "__main__":
    main()
