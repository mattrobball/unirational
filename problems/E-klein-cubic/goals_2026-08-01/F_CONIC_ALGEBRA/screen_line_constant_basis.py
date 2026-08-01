#!/usr/bin/env python3
"""Search a full sextic-basis point constant along (A,B,Y,Z)=(1,2,3,s).

This is a discovery-only finite-field ansatz.  It tests

    X=sum(a_i*u^i), y=sum(b_i*u^i), w=1

with the same twelve coefficients at several values of s.  Empty output does
not prove pointlessness over the generic function field.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import subprocess

import sympy as sp

from model import specialized_cubic, specialized_field
from screen_linear_ansatz import add, msolve_text, mul, scale
from screen_monomial_points import multiplication_tensor, vector


HERE = Path(__file__).resolve().parent
PRIME = 67
SAMPLES = tuple({"A": 1, "B": 2, "Y": 3, "Z": value} for value in (1, 2, 3, 4))


def equations_for_sample(sample, variables):
    field = specialized_field(sample, PRIME)
    tensor = multiplication_tensor(field)
    basis = []
    power = field.element(1)
    for _ in range(6):
        basis.append(vector(field, power))
        power = field.mul(power, field.u_element)
    a, b = variables[:6], variables[6:]
    X = [sum(a[index] * int(basis[index][slot]) for index in range(6)) for slot in range(6)]
    y = [sum(b[index] * int(basis[index][slot]) for index in range(6)) for slot in range(6)]
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


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--run", action="store_true")
    parser.add_argument("--timeout", type=int, default=600)
    args = parser.parse_args()
    variables = sp.symbols("a0:6 b0:6")
    polynomials = []
    for sample in SAMPLES:
        polynomials.extend(equations_for_sample(sample, variables))
    unique = {}
    for poly in polynomials:
        if not poly.is_zero:
            monic = poly.monic()
            unique[str(monic.as_expr())] = monic
    polynomials = list(unique.values())
    input_path = HERE / "line_constant_basis_p67.ms"
    output_path = HERE / "line_constant_basis_p67.out"
    payload_path = HERE / "line_constant_basis_p67.json"
    input_path.write_text(msolve_text(polynomials, variables))
    payload = {
        "scope": "discovery only",
        "prime": PRIME,
        "line": "(A,B,Y,Z)=(1,2,3,s)",
        "sample_s": [sample["Z"] for sample in SAMPLES],
        "variables": list(map(str, variables)),
        "equations": len(polynomials),
        "ansatz": "X=sum_0^5 a_i*u^i; y=sum_0^5 b_i*u^i; w=1; a_i,b_i constant in s",
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
