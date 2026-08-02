#!/usr/bin/env python3
"""Discovery audit for the degree-one/degree-three full-Schur pencil.

This script works only in the good fibre (23, zeta_11=2).  It reconstructs
the unique cubic self-covariant and the Reynolds quartic from the installed
action conventions, then expands

    I4(x + t*q3(x)).

Any factor found here is discovery data until separately lifted and checked
over Q(zeta_11).
"""
from __future__ import annotations

from collections import defaultdict
from functools import lru_cache
import argparse
import hashlib
import importlib.util
from itertools import product
from math import comb, factorial
from pathlib import Path
import sys
import subprocess
import tempfile

import numpy as np


ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
SOURCE = ROOT / "tmp/fano14_twist/fano_covariant_scan.py"
SPEC = importlib.util.spec_from_file_location("fano_pencil_mod23", SOURCE)
assert SPEC and SPEC.loader
fano = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = fano
SPEC.loader.exec_module(fano)

P = 23
N = 6
ZERO = (0,) * N
Polynomial = dict[tuple[int, ...], int]


def compositions(total: int, slots: int):
    if slots == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for tail in compositions(total - first, slots - 1):
            yield (first,) + tail


def multinomial(alpha: tuple[int, ...]) -> int:
    answer = factorial(sum(alpha))
    for exponent in alpha:
        answer //= factorial(exponent)
    return answer


def add(left: Polynomial, right: Polynomial, scale: int = 1) -> Polynomial:
    result = dict(left)
    for monomial, coefficient in right.items():
        value = (result.get(monomial, 0) + scale * coefficient) % P
        if value:
            result[monomial] = value
        else:
            result.pop(monomial, None)
    return result


def multiply(left: Polynomial, right: Polynomial) -> Polynomial:
    result: dict[tuple[int, ...], int] = defaultdict(int)
    for a, ca in left.items():
        for b, cb in right.items():
            monomial = tuple(x + y for x, y in zip(a, b))
            result[monomial] = (result[monomial] + ca * cb) % P
    return {monomial: coefficient for monomial, coefficient in result.items() if coefficient}


def power(polynomial: Polynomial, exponent: int) -> Polynomial:
    result = {ZERO: 1}
    base = polynomial
    while exponent:
        if exponent & 1:
            result = multiply(result, base)
        exponent //= 2
        if exponent:
            base = multiply(base, base)
    return result


def variable(index: int) -> Polynomial:
    exponent = [0] * N
    exponent[index] = 1
    return {tuple(exponent): 1}


def linear_power_coefficients(row: np.ndarray, degree: int) -> Polynomial:
    result = {}
    for alpha in compositions(degree, N):
        coefficient = multinomial(alpha)
        for entry, exponent in zip(row, alpha):
            coefficient = coefficient * pow(int(entry), exponent, P) % P
        if coefficient:
            result[alpha] = coefficient
    return result


def group_data():
    generators = fano.six_dimensional_generators()
    group = fano.generate_group(generators)
    assert len(group) == 1320
    inverses = [fano.inv(g) for g in group]
    return group, inverses


def reynolds_seed(
    group: list[np.ndarray],
    inverses: list[np.ndarray],
    degree: int,
    seed_output: int,
) -> list[Polynomial]:
    covariant = [{} for _ in range(N)]
    for g, inverse in zip(group, inverses):
        seed = linear_power_coefficients(g[5], degree)
        for output in range(N):
            covariant[output] = add(
                covariant[output], seed, int(inverse[output, seed_output])
            )
    return covariant


def reconstruct() -> tuple[Polynomial, list[Polynomial]]:
    group, inverses = group_data()

    quartic: Polynomial = {}
    for g in group:
        row = g[5]
        quartic = add(quartic, linear_power_coefficients(row, 4))
    # Installed degree-three Reynolds basis seed is output=0, x_5^3.
    cubic = reynolds_seed(group, inverses, 3, 0)
    assert quartic and all(cubic)
    assert all({sum(monomial) for monomial in component} == {3} for component in cubic)
    return quartic, cubic


def substitute_pencil(
    quartic: Polynomial, cubic: list[Polynomial]
) -> list[Polynomial]:
    """Return t-coefficients of I4(x+t*q3(x)), from t^0 through t^4."""
    coordinates = [variable(index) for index in range(N)]
    cubic_powers = [[power(cubic[index], exponent) for exponent in range(5)] for index in range(N)]
    answer = [{} for _ in range(5)]
    for alpha, outer_coefficient in quartic.items():
        choices = [tuple(range(exponent + 1)) for exponent in alpha]
        for beta in product(*choices):
            t_degree = sum(beta)
            coefficient = outer_coefficient
            term = {ZERO: 1}
            for index, (outer_exponent, cubic_exponent) in enumerate(zip(alpha, beta)):
                coefficient = (
                    coefficient * comb(outer_exponent, cubic_exponent)
                ) % P
                if outer_exponent > cubic_exponent:
                    term = multiply(
                        term,
                        power(coordinates[index], outer_exponent - cubic_exponent),
                    )
                if cubic_exponent:
                    term = multiply(term, cubic_powers[index][cubic_exponent])
            answer[t_degree] = add(answer[t_degree], term, coefficient)
    return answer


def evaluate(polynomial: Polynomial, point: tuple[int, ...]) -> int:
    total = 0
    for monomial, coefficient in polynomial.items():
        term = coefficient
        for coordinate, exponent in zip(point, monomial):
            term = term * pow(coordinate, exponent, P) % P
        total += term
    return total % P


def proportional(left: Polynomial, right: Polynomial) -> int | None:
    support = set(left) | set(right)
    pivot = next((m for m in support if right.get(m, 0)), None)
    if pivot is None:
        return None
    scalar = left.get(pivot, 0) * pow(right[pivot], -1, P) % P
    if all(left.get(m, 0) == scalar * right.get(m, 0) % P for m in support):
        return scalar
    return None


def singular_polynomial(coefficients: list[Polynomial]) -> str:
    terms = []
    for t_degree, coefficient in enumerate(coefficients):
        for monomial, scalar in coefficient.items():
            factors = []
            if t_degree == 1:
                factors.append("t")
            elif t_degree:
                factors.append(f"t^{t_degree}")
            for index, exponent in enumerate(monomial):
                if exponent == 1:
                    factors.append(f"x{index}")
                elif exponent:
                    factors.append(f"x{index}^{exponent}")
            terms.append(f"{scalar}*{'*'.join(factors) or '1'}")
    return "+".join(terms)


def factor_with_singular(coefficients: list[Polynomial]) -> str:
    polynomial = singular_polynomial(coefficients)
    digest = hashlib.sha256(polynomial.encode()).hexdigest()
    source = "\n".join(
        [
            "ring r=23,(t,x0,x1,x2,x3,x4,x5),dp;",
            f"poly f={polynomial};",
            "list L=factorize(f);",
            "intvec wt=1,0,0,0,0,0,0;",
            'print("FACTOR_COUNT_WITH_UNIT="+string(size(L[1])));',
            'print("INPUT_TOTAL_DEG="+string(deg(f))+" INPUT_T_DEG="+string(deg(f,wt)));',
            "for (int i=1;i<=size(L[1]);i++)",
            "{",
            '  print("FACTOR="+string(i)+" MULT="+string(L[2][i])+" TOTAL_DEG="+string(deg(L[1][i]))+" T_DEG="+string(deg(L[1][i],wt)));',
            "}",
            "quit;",
        ]
    ) + "\n"
    with tempfile.TemporaryDirectory(prefix="full_schur_pencil_factor_") as temporary:
        path = Path(temporary) / "pencil.sing"
        path.write_text(source)
        process = subprocess.run(
            ["Singular", "-q", str(path)],
            cwd=temporary,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
    print(f"SINGULAR_INPUT_TERMS={sum(len(c) for c in coefficients)}")
    print(f"SINGULAR_POLYNOMIAL_SHA256={digest}")
    print(process.stdout, end="")
    print(f"SINGULAR_RETURN_CODE={process.returncode}")
    return process.stdout


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--factor", action="store_true")
    arguments = parser.parse_args()
    quartic, cubic = reconstruct()
    print(f"I4_TERMS={len(quartic)}")
    print(f"Q3_TERMS={[len(component) for component in cubic]}")
    coefficients = substitute_pencil(quartic, cubic)
    print(f"PENCIL_TERMS={[len(coefficient) for coefficient in coefficients]}")
    print(f"PENCIL_X_DEGREES={[sorted({sum(m) for m in coefficient}) for coefficient in coefficients]}")
    assert coefficients[0] == quartic
    quartic_squared = power(quartic, 2)
    quartic_cubed = multiply(quartic_squared, quartic)
    print(
        "I4_OF_Q3_OVER_I4_CUBED="
        f"{proportional(coefficients[4], quartic_cubed)}"
    )

    # Test the most economical possible rational roots t=c/I4(x)^k allowed
    # by homogeneity.  A root t has scaling weight -2; no integral power of
    # the degree-four I4 alone has that weight, so this is just an identity
    # sanity check rather than an exhaustive search.
    rng = np.random.default_rng(2026080109)
    for _ in range(12):
        point = tuple(int(x) for x in rng.integers(0, P, N))
        direct = []
        for t in range(P):
            p = []
            for index in range(N):
                p.append((point[index] + t * evaluate(cubic[index], point)) % P)
            direct.append(evaluate(quartic, tuple(p)))
        expanded = [
            sum(evaluate(coefficients[k], point) * pow(t, k, P) for k in range(5)) % P
            for t in range(P)
        ]
        assert direct == expanded
    print("MOD23_PENCIL_EXPANSION_EXACT")
    if arguments.factor:
        factor_with_singular(coefficients)


if __name__ == "__main__":
    main()
