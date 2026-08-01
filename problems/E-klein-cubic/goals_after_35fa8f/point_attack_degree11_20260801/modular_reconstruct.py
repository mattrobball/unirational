#!/usr/bin/env python3
"""Modular triangular certificates for the raw degree-11 Reynolds basis."""

from __future__ import annotations

from itertools import product
from pathlib import Path
import argparse
import subprocess
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import exact_reynolds as exact  # noqa: E402


POINTS = ((1, 2, 3), (1, 2, 4), (1, 2, 5), (1, 2, 6), (1, 2, 7), (1, 3, 2))


def raw_reynolds_value(seed, point, source, prime):
    output_coordinate, exponent = seed
    result = [0] * 5
    for g in exact.modp.base.A5_PERMS:
        moved = exact.modp.base.mv(source[g], point, prime)
        monomial = 1
        for value, power in zip(moved, exponent):
            monomial = monomial * pow(value, power, prime) % prime
        inverse_target = exact.EXACT_TARGET[exact.modp.base.pinv(g)]
        for output in range(5):
            result[output] = (
                result[output] + inverse_target[output][output_coordinate] * monomial
            ) % prime
    return result


def six_equations(prime, sqrt5, sqrt_minus11):
    source = exact.modp.base.source_representation(prime, sqrt5)
    parameter_monomials = exact.modp.monomials(5, 3)
    parameter_index = {exponent: index for index, exponent in enumerate(parameter_monomials)}
    t = (13 + sqrt_minus11) * pow(18, -1, prime) % prime
    equations = []
    for point in POINTS:
        values = [raw_reynolds_value(seed, point, source, prime) for seed in exact.SEEDS]
        values6 = [value + [-sum(value) % prime] for value in values]
        row = [0] * len(parameter_monomials)
        for scalar, triples in ((1, exact.O0_TRIPLES), (t, exact.O1_TRIPLES)):
            for i, j, k in triples:
                for selections in product(range(5), repeat=3):
                    coefficient = scalar
                    coefficient = coefficient * values6[selections[0]][i] % prime
                    coefficient = coefficient * values6[selections[1]][j] % prime
                    coefficient = coefficient * values6[selections[2]][k] % prime
                    exponent = tuple(selections.count(index) for index in range(5))
                    position = parameter_index[exponent]
                    row[position] = (row[position] + coefficient) % prime
        equations.append(row)
    return parameter_monomials, equations


def groebner(prime, sqrt5, sqrt_minus11):
    mons, rows = six_equations(prime, sqrt5, sqrt_minus11)
    a = sp.symbols("a0:5")
    expressions = []
    for row in rows:
        expression = sum(
            coefficient * sp.prod(variable ** power for variable, power in zip(a, exponent))
            for coefficient, exponent in zip(row, mons)
        )
        expressions.append(sp.expand(expression.subs(a[0], 1)))
    basis = sp.groebner(expressions, *a[1:], modulus=prime, order="lex")
    return basis


def singular_groebner(prime, sqrt5, sqrt_minus11):
    mons, rows = six_equations(prime, sqrt5, sqrt_minus11)
    variables = ("1", "a1", "a2", "a3", "a4")
    expressions = []
    for row in rows:
        terms = []
        for coefficient, exponent in zip(row, mons):
            coefficient %= prime
            if not coefficient:
                continue
            factors = []
            for variable, power in zip(variables, exponent):
                if variable == "1" or not power:
                    continue
                factors.append(variable if power == 1 else f"{variable}^{power}")
            monomial = "*".join(factors) if factors else "1"
            terms.append(f"({coefficient})*{monomial}")
        expressions.append("+".join(terms) if terms else "0")
    input_path = HERE / f"modular_p{prime}_s{sqrt5}_r{sqrt_minus11}.sing"
    input_path.write_text(
        f"ring rd={prime},(a1,a2,a3,a4),lp;\n"
        f"ideal I={','.join(expressions)};\n"
        "ideal J=std(I); J=interred(J);\n"
        'if (reduce(1,J)==0) { print("UNIT"); quit; }\n'
        'print("NONUNIT"); print("VDIM"); vdim(J);\n'
        "J;\n"
        "quit;\n"
    )
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=89)
    parser.add_argument("--sqrt5", type=int)
    parser.add_argument("--sqrt-minus11", type=int)
    args = parser.parse_args()
    roots5 = sp.sqrt_mod(5, args.prime, all_roots=True)
    roots11 = sp.sqrt_mod(-11, args.prime, all_roots=True)
    sqrt5 = args.sqrt5 if args.sqrt5 is not None else int(roots5[0])
    sqrt_minus11 = args.sqrt_minus11 if args.sqrt_minus11 is not None else int(roots11[0])
    print(f"prime={args.prime} sqrt5={sqrt5} sqrt_minus11={sqrt_minus11}")
    print(singular_groebner(args.prime, sqrt5, sqrt_minus11), end="")


if __name__ == "__main__":
    main()
