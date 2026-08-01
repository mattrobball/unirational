#!/usr/bin/env python3
"""Search one- and two-support projective points in the degree-six systems."""

from __future__ import annotations

import argparse
import itertools

import probe_f55_covariants as model


PRIME = 331
DEGREE = 6


def evaluate_restricted(polynomial, left: int, right: int, value: int) -> int:
    total = 0
    for indices, coefficient in polynomial.items():
        if any(index not in (left, right) for index in indices):
            continue
        right_power = indices.count(right)
        total += coefficient * pow(value, right_power, PRIME)
    return total % PRIME


def search(character: int) -> None:
    basis, coefficient_equations = model.equations(
        DEGREE, character=character, prime=PRIME
    )
    equations = list(coefficient_equations.values())
    one_support = []
    for coordinate in range(len(basis)):
        if all(
            polynomial.get((coordinate, coordinate, coordinate), 0) % PRIME == 0
            for polynomial in equations
        ):
            one_support.append(coordinate)
    two_support = []
    for left, right in itertools.combinations(range(len(basis)), 2):
        restricted = [
            polynomial
            for polynomial in equations
            if any(
                all(index in (left, right) for index in monomial)
                for monomial in polynomial
            )
        ]
        for value in range(1, PRIME):
            if all(
                evaluate_restricted(polynomial, left, right, value) == 0
                for polynomial in restricted
            ):
                two_support.append((left, right, value))
    print(
        f"character={character} variables={len(basis)} "
        f"one_support={one_support} two_support={two_support}"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("characters", nargs="*", type=int, default=list(range(5)))
    arguments = parser.parse_args()
    assert all(character in range(5) for character in arguments.characters)
    for character in arguments.characters:
        search(character)
    print("Q_F55_DEGREE6_SPARSE_SEARCH_EXACT")


if __name__ == "__main__":
    main()
