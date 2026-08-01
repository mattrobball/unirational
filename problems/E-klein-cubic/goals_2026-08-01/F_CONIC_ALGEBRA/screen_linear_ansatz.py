#!/usr/bin/env python3
"""Search an affine-linear (1,t,u,v) point formula over F_67.

This is a discovery-only multispecialization screen.  It cannot prove that a
generic point is absent, but a hit would give a small characteristic-zero
reconstruction target.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import subprocess

import sympy as sp

from model import specialized_cubic, specialized_field
from screen_monomial_points import multiplication_tensor, vector


HERE = Path(__file__).resolve().parent
PRIME = 67
SAMPLES = (
    {"A": 1, "B": 2, "Y": 3, "Z": 4},
    {"A": 1, "B": 1, "Y": 1, "Z": 1},
    {"A": 2, "B": 3, "Y": 5, "Z": 7},
)


def mul(left, right, tensor):
    answer = [0] * 6
    for i, li in enumerate(left):
        if li == 0:
            continue
        for j, rj in enumerate(right):
            if rj == 0:
                continue
            for k in range(6):
                if tensor[i, j, k]:
                    answer[k] += li * rj * int(tensor[i, j, k])
    return [sp.expand(value) for value in answer]


def add(*rows):
    return [sp.expand(sum(row[index] for row in rows)) for index in range(6)]


def scale(scalar, row):
    return [sp.expand(scalar * value) for value in row]


def equations_for_sample(sample, variables):
    field = specialized_field(sample, PRIME)
    tensor = multiplication_tensor(field)
    basis = [
        vector(field, field.element(1)),
        vector(field, field.t_element),
        vector(field, field.u_element),
        vector(field, field.v_element),
    ]
    a = variables[:4]
    b = variables[4:]
    X = [sum(a[index] * int(basis[index][slot]) for index in range(4)) for slot in range(6)]
    y = [sum(b[index] * int(basis[index][slot]) for index in range(4)) for slot in range(6)]
    w = [1, 0, 0, 0, 0, 0]
    q, r = specialized_cubic(sample, PRIME, 9)
    X2, y2 = mul(X, X, tensor), mul(y, y, tensor)
    value = add(
        mul(X2, X, tensor),
        scale(q[0], mul(X, y2, tensor)),
        scale(q[1], mul(X, y, tensor)),
        scale(q[2], X),
        scale(r[0], mul(y2, y, tensor)),
        scale(r[1], y2),
        scale(r[2], y),
        scale(r[3], w),
    )
    return [sp.Poly(entry, *variables, modulus=PRIME) for entry in value]


def msolve_text(polynomials, variables):
    def emit(poly):
        pieces = []
        for exponents, coefficient0 in poly.terms():
            coefficient = int(coefficient0) % PRIME
            factors = []
            if coefficient != 1 or not any(exponents):
                factors.append(str(coefficient))
            for variable, exponent in zip(variables, exponents):
                if exponent == 1:
                    factors.append(str(variable))
                elif exponent:
                    factors.append(f"{variable}^{exponent}")
            pieces.append("*".join(factors) if factors else "1")
        return "+".join(pieces) if pieces else "0"

    return (
        ",".join(map(str, variables))
        + f"\n{PRIME}\n"
        + ",\n".join(emit(poly) for poly in polynomials)
        + "\n"
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--run", action="store_true")
    parser.add_argument("--timeout", type=int, default=300)
    args = parser.parse_args()
    variables = sp.symbols("a0:4 b0:4")
    polynomials = []
    for sample in SAMPLES:
        polynomials.extend(equations_for_sample(sample, variables))
    # Remove literal zero equations and duplicate normalized polynomials.
    unique = {}
    for poly in polynomials:
        if poly.is_zero:
            continue
        monic = poly.monic()
        unique[str(monic.as_expr())] = monic
    polynomials = list(unique.values())
    input_path = HERE / "linear_ansatz_p67.ms"
    output_path = HERE / "linear_ansatz_p67.out"
    payload_path = HERE / "linear_ansatz_p67.json"
    input_path.write_text(msolve_text(polynomials, variables))
    payload = {
        "scope": "discovery only",
        "prime": PRIME,
        "samples": SAMPLES,
        "variables": list(map(str, variables)),
        "equations": len(polynomials),
        "ansatz": "X=a0+a1*t+a2*u+a3*v; y=b0+b1*t+b2*u+b3*v; w=1",
        "status": "input-built",
    }
    if args.run:
        try:
            completed = subprocess.run(
                ["/opt/homebrew/bin/msolve", "-f", str(input_path)],
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                timeout=args.timeout,
                check=False,
            )
            output_path.write_text(completed.stdout)
            payload.update(status="completed", returncode=completed.returncode)
        except subprocess.TimeoutExpired as error:
            output = error.stdout or ""
            if isinstance(output, bytes):
                output = output.decode(errors="replace")
            output_path.write_text(output + "\nTIMEOUT\n")
            payload.update(status="timeout")
    payload_path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
