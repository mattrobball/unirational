#!/usr/bin/env python3
"""Absolute-factor test for one-parameter specializations of pair (0,4)."""

from __future__ import annotations

from itertools import product
from fractions import Fraction
import subprocess

from factor_binary_kummer_singular import trace


def conjugate(value, power):
    answer = trace.ZERO
    for degree, coefficient in enumerate(value.coefficients):
        answer += coefficient * trace.Z ** (power*degree)
    return answer


def multiply(left, right):
    answer = {}
    for (sp1, tp1), c1 in left.items():
        for (sp2, tp2), c2 in right.items():
            key = (sp1+sp2, tp1+tp2)
            answer[key] = answer.get(key, trace.ZERO) + c1*c2
            if not answer[key]:
                del answer[key]
    return answer


def specialize(parts, retained, constants):
    assignments = {}
    cursor = 0
    for index in range(4):
        if index != retained:
            assignments[index] = constants[cursor]
            cursor += 1
    output = {}
    for t_degree, part in enumerate(parts):
        for exponent, coefficient in part.items():
            for index, value in assignments.items():
                coefficient *= value**exponent[index]
            key = (exponent[retained], t_degree)
            output[key] = output.get(key, trace.ZERO) + coefficient
            if not output[key]:
                del output[key]
    return output


def norm_polynomial(polynomial):
    answer = {(0, 0): trace.ONE}
    for power in range(1, 5):
        answer = multiply(answer, {
            key: conjugate(coefficient, power)
            for key, coefficient in polynomial.items()
        })
    rational = {}
    for key, coefficient in answer.items():
        assert all(value == 0 for value in coefficient.coefficients[1:])
        rational[key] = coefficient.coefficients[0]
    return rational


def singular_string(polynomial):
    terms = []
    for (s_power, t_power), coefficient in sorted(polynomial.items()):
        if not coefficient:
            continue
        scalar = str(coefficient.numerator)
        if coefficient.denominator != 1:
            scalar = f"({scalar}/{coefficient.denominator})"
        factors = [f"({scalar})"]
        if s_power == 1:
            factors.append("s")
        elif s_power > 1:
            factors.append(f"s^{s_power}")
        if t_power == 1:
            factors.append("t")
        elif t_power > 1:
            factors.append(f"t^{t_power}")
        terms.append("*".join(factors))
    return "+".join(terms)


def test(retained, constants):
    polynomial = specialize(trace.components(0, 4), retained, constants)
    if max(t_degree for _, t_degree in polynomial) != 3:
        return None
    norm = norm_polynomial(polynomial)
    code = f'''ring R=0,(s,t),dp;
poly f={singular_string(norm)};
list L=factorize(f,1);
size(L[1]);
LIB "absfact.lib";
def S=absFactorize(f);
setring S;
absolute_factors[4];
'''
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q"], input=code, text=True,
        capture_output=True, check=True,
    )
    values = [int(line.strip()) for line in result.stdout.splitlines()
              if line.strip().lstrip("-").isdigit()]
    return values[-2], values[-1], len(norm)


def main():
    for retained in range(4):
        for constants in product((-1, 0, 1), repeat=3):
            result = test(retained, constants)
            print(f"TRY retained={retained} constants={constants} result={result}")
            if result is not None and result[:2] == (1, 4):
                print(
                    "PAIR_0_4_ABSOLUTE_SPECIALIZATION_OK "
                    f"retained={retained} constants={constants} "
                    f"relative_factors={result[0]} absolute_factors={result[1]} "
                    f"norm_terms={result[2]}"
                )
                return
    raise AssertionError("no absolute-irreducible specialization found")


if __name__ == "__main__":
    main()
