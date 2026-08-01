#!/usr/bin/env python3
"""Exact sparse search for a binomial point on the 11:5 trace cubic.

Search a=d*(1+lambda*u), where d,u are Laurent characters of the norm-one
torus product(r_i)=1.  The five-term trace is expanded in the Laurent basis,
and the coefficient polynomials in lambda are tested by exact Q[lambda] gcd.
"""

from __future__ import annotations

import argparse
from fractions import Fraction
from itertools import product


Exponent = tuple[int, int, int, int, int]
Poly = list[Fraction]
C = (0, 0, -1, 0, 0)  # c=r2^-1


def add(*vectors: Exponent) -> Exponent:
    return tuple(sum(entries) for entries in zip(*vectors))


def scale(multiplier: int, vector: Exponent) -> Exponent:
    return tuple(multiplier * entry for entry in vector)


def canonical(vector: Exponent) -> Exponent:
    """Use product(r_i)=1 to make the final exponent zero."""
    last = vector[-1]
    return tuple(entry - last for entry in vector)


def sigma(vector: Exponent) -> Exponent:
    answer = [0] * 5
    for index, entry in enumerate(vector):
        answer[(index + 1) % 5] = entry
    return canonical(tuple(answer))


def trace_add(target: dict[Exponent, list[int]], degree: int, exponent: Exponent, coefficient: int):
    for _ in range(5):
        exponent = canonical(exponent)
        row = target.setdefault(exponent, [0, 0, 0, 0])
        row[degree] += coefficient
        exponent = sigma(exponent)


def trace_coefficients(d: Exponent, u: Exponent) -> dict[Exponent, list[int]]:
    sd, su = sigma(d), sigma(u)
    weight = canonical(add(C, scale(2, d), sd))
    answer: dict[Exponent, list[int]] = {}
    trace_add(answer, 0, weight, 1)
    trace_add(answer, 1, add(weight, u), 2)
    trace_add(answer, 1, add(weight, su), 1)
    trace_add(answer, 2, add(weight, scale(2, u)), 1)
    trace_add(answer, 2, add(weight, u, su), 2)
    trace_add(answer, 3, add(weight, scale(2, u), su), 1)
    return {key: value for key, value in answer.items() if any(value)}


def trim(poly: Poly) -> Poly:
    while poly and poly[-1] == 0:
        poly.pop()
    return poly


def divmod_poly(left: Poly, right: Poly) -> tuple[Poly, Poly]:
    left, right = trim(left[:]), trim(right[:])
    quotient = [Fraction(0)] * max(0, len(left) - len(right) + 1)
    while left and len(left) >= len(right):
        shift = len(left) - len(right)
        coefficient = left[-1] / right[-1]
        quotient[shift] = coefficient
        for index, value in enumerate(right):
            left[index + shift] -= coefficient * value
        trim(left)
    return trim(quotient), left


def gcd_poly(left: Poly, right: Poly) -> Poly:
    left, right = trim(left[:]), trim(right[:])
    while right:
        _quotient, remainder = divmod_poly(left, right)
        left, right = right, remainder
    if not left:
        return []
    lead = left[-1]
    return [entry / lead for entry in left]


def common_root(rows: dict[Exponent, list[int]]) -> Poly:
    gcd: Poly = []
    for values in rows.values():
        poly = trim([Fraction(value) for value in values])
        gcd = poly if not gcd else gcd_poly(gcd, poly)
        if len(gcd) <= 1:
            return []
    # lambda=0 is not allowed; discard a pure power of lambda.
    while gcd and gcd[0] == 0:
        gcd = gcd[1:]
    return trim(gcd)


def vectors(bound: int) -> list[Exponent]:
    return [tuple(entries) + (0,) for entries in product(range(-bound, bound + 1), repeat=4)]


def mod_canonical(vector: Exponent, modulus: int) -> Exponent:
    last = vector[-1] % modulus
    return tuple((entry - last) % modulus for entry in vector)


def mod_sigma(vector: Exponent, modulus: int) -> Exponent:
    answer = [0] * 5
    for index, entry in enumerate(vector):
        answer[(index + 1) % 5] = entry
    return mod_canonical(tuple(answer), modulus)


def orbit_key(vector: Exponent, modulus: int) -> Exponent:
    orbit = []
    for _ in range(5):
        vector = mod_canonical(vector, modulus)
        orbit.append(vector)
        vector = mod_sigma(vector, modulus)
    return min(orbit)


def exact_orbit_key(vector: Exponent) -> Exponent:
    orbit = []
    for _ in range(5):
        vector = canonical(vector)
        orbit.append(vector)
        vector = sigma(vector)
    return min(orbit)


def modular_support_screen(modulus: int) -> None:
    candidates = [tuple(entries) + (0,) for entries in product(range(modulus), repeat=4)]
    survivors = 0
    examples = []
    for d in candidates:
        sd = mod_sigma(d, modulus)
        weight = mod_canonical(add(C, scale(2, d), sd), modulus)
        for u in candidates:
            if all(entry % modulus == 0 for entry in u):
                continue
            su = mod_sigma(u, modulus)
            labels = [
                (0, weight),
                (1, add(weight, u)),
                (1, add(weight, su)),
                (2, add(weight, scale(2, u))),
                (2, add(weight, u, su)),
                (3, add(weight, scale(2, u), su)),
            ]
            degree_sets = {}
            for degree, exponent in labels:
                degree_sets.setdefault(orbit_key(exponent, modulus), set()).add(degree)
            if all(len(degrees) >= 2 for degrees in degree_sets.values()):
                survivors += 1
                if len(examples) < 5:
                    examples.append((d, u, degree_sets))
    print(f"MODULAR_SUPPORT_SCREEN modulus={modulus} survivors={survivors}")
    for example in examples:
        print(f"SURVIVOR {example}")


def modular_trinomial_screen(modulus: int) -> None:
    """Necessary-support screen for d*(1+lambda*u+mu*v)."""
    candidates = [tuple(entries) + (0,) for entries in product(range(modulus), repeat=4)]
    sigmas = {vector: mod_sigma(vector, modulus) for vector in candidates}
    survivors = 0
    examples = []
    checked = 0
    zero = (0, 0, 0, 0, 0)
    parameter_labels = ((0, 0), (1, 0), (0, 1))
    for d in candidates:
        weight = mod_canonical(add(C, scale(2, d), sigmas[d]), modulus)
        for u in candidates:
            if u == zero:
                continue
            for v in candidates:
                if v == zero or v == u:
                    continue
                checked += 1
                terms = (zero, u, v)
                shifted = (zero, sigmas[u], sigmas[v])
                parameter_sets = {}
                for first in range(3):
                    for second in range(3):
                        for third in range(3):
                            exponent = add(
                                weight, terms[first], terms[second], shifted[third]
                            )
                            parameter = (
                                parameter_labels[first][0]
                                + parameter_labels[second][0]
                                + parameter_labels[third][0],
                                parameter_labels[first][1]
                                + parameter_labels[second][1]
                                + parameter_labels[third][1],
                            )
                            parameter_sets.setdefault(
                                orbit_key(exponent, modulus), set()
                            ).add(parameter)
                if all(len(parameters) >= 2 for parameters in parameter_sets.values()):
                    survivors += 1
                    if len(examples) < 5:
                        examples.append((d, u, v, parameter_sets))
    print(
        f"MODULAR_TRINOMIAL_SUPPORT_SCREEN modulus={modulus} "
        f"survivors={survivors} checked={checked}"
    )
    for example in examples:
        print(f"TRINOMIAL_SURVIVOR {example}")


def bounded_trinomial_support_screen(bound: int) -> None:
    candidates = vectors(bound)
    sigmas = {vector: sigma(vector) for vector in candidates}
    survivors = 0
    examples = []
    checked = 0
    zero = (0, 0, 0, 0, 0)
    parameter_labels = ((0, 0), (1, 0), (0, 1))
    for d in candidates:
        weight = canonical(add(C, scale(2, d), sigmas[d]))
        for u in candidates:
            if u == zero:
                continue
            for v in candidates:
                if v == zero or v == u:
                    continue
                checked += 1
                terms = (zero, u, v)
                shifted = (zero, sigmas[u], sigmas[v])
                parameter_sets = {}
                for first in range(3):
                    for second in range(3):
                        for third in range(3):
                            exponent = add(
                                weight, terms[first], terms[second], shifted[third]
                            )
                            parameter = (
                                parameter_labels[first][0]
                                + parameter_labels[second][0]
                                + parameter_labels[third][0],
                                parameter_labels[first][1]
                                + parameter_labels[second][1]
                                + parameter_labels[third][1],
                            )
                            parameter_sets.setdefault(
                                exact_orbit_key(exponent), set()
                            ).add(parameter)
                if all(len(parameters) >= 2 for parameters in parameter_sets.values()):
                    survivors += 1
                    if len(examples) < 20:
                        examples.append((d, u, v, parameter_sets))
    print(
        f"BOUNDED_TRINOMIAL_SUPPORT_SCREEN bound={bound} "
        f"survivors={survivors} checked={checked}"
    )
    for example in examples:
        print(f"EXACT_TRINOMIAL_SURVIVOR {example}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--bound", type=int, default=2)
    parser.add_argument("--modulus", type=int)
    parser.add_argument("--trinomial-modulus", type=int)
    parser.add_argument("--trinomial-bound", type=int)
    args = parser.parse_args()
    if args.trinomial_bound is not None:
        bounded_trinomial_support_screen(args.trinomial_bound)
        return
    if args.trinomial_modulus:
        modular_trinomial_screen(args.trinomial_modulus)
        return
    if args.modulus:
        modular_support_screen(args.modulus)
        return
    candidates = vectors(args.bound)
    checked = 0
    for d in candidates:
        for u in candidates:
            if u == (0, 0, 0, 0, 0):
                continue
            checked += 1
            rows = trace_coefficients(d, u)
            # A monomial occurring in only one lambda degree immediately
            # precludes a nonzero common root.
            if any(sum(value != 0 for value in row) == 1 for row in rows.values()):
                continue
            gcd = common_root(rows)
            if len(gcd) >= 2:
                print(f"FOUND d={d} u={u} minimalFactor={gcd} rows={len(rows)}")
                print(f"checked={checked}")
                return
    print(f"NO_BINOMIAL_TRACE_POINT bound={args.bound} pairs={checked}")


if __name__ == "__main__":
    main()
