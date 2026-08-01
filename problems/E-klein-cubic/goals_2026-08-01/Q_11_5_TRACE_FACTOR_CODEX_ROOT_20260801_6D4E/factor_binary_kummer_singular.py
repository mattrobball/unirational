#!/usr/bin/env python3
"""Factor exact binary Kummer slices using Singular over Q(epsilon)[U,t]."""

from __future__ import annotations

import subprocess

import trace_core as trace


def qz_string(value) -> str:
    terms = []
    for degree, coefficient in enumerate(value.coefficients):
        if not coefficient:
            continue
        scalar = str(coefficient.numerator)
        if coefficient.denominator != 1:
            scalar = f"({scalar}/{coefficient.denominator})"
        factor = "1" if degree == 0 else ("e" if degree == 1 else f"e^{degree}")
        terms.append(f"({scalar})*{factor}")
    return "(" + "+".join(terms or ["0"]) + ")"


def monomial_string(exponent) -> str:
    variables = ("U1", "U2", "U3", "U4")
    factors = []
    for variable, power in zip(variables, exponent):
        if power < 0:
            raise AssertionError("Fourier components should have polynomial support")
        if power == 1:
            factors.append(variable)
        elif power > 1:
            factors.append(f"{variable}^{power}")
    return "*".join(factors or ["1"])


def polynomial_string(components) -> str:
    terms = []
    for t_degree, component in enumerate(components):
        for exponent, coefficient in sorted(component.items()):
            factors = [qz_string(coefficient), monomial_string(exponent)]
            if t_degree == 1:
                factors.append("t")
            elif t_degree > 1:
                factors.append(f"t^{t_degree}")
            terms.append("*".join(factors))
    return "+".join(terms)


def main() -> None:
    for p in range(5):
        for q in range(p + 1, 5):
            polynomial = polynomial_string(trace.components(p, q))
            code = f'''ring R=(0,e),(U1,U2,U3,U4,t),dp;
minpoly=e^4+e^3+e^2+e+1;
poly f={polynomial};
list L=factorize(f,1);
intvec wt=0,0,0,0,1;
size(L[1]);
for (int i=1;i<=size(L[1]);i++){{deg(L[1][i],wt);}}
'''
            result = subprocess.run(
                ["/opt/homebrew/bin/Singular", "-q"],
                input=code,
                text=True,
                capture_output=True,
                check=True,
            )
            values = [int(line.strip()) for line in result.stdout.splitlines()
                      if line.strip()]
            count, degrees = values[0], values[1:]
            assert len(degrees) == count
            assert sorted(degrees) in ([3], [0, 3])
            print(f"PAIR {p} {q} FACTORS {count} T_DEGREES {degrees}")
    print("H_TRACE_FOURIER_BINARY_FULL_FIELD_IRREDUCIBLE_OK")


if __name__ == "__main__":
    main()
