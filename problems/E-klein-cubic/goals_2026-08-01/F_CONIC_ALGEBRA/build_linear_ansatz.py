#!/usr/bin/env python3
"""Build a bounded finite-field screen for affine-linear (t,u,v) points.

The ansatz is

    [X:y:w] = [x0+x1*t+x2*u+x3*v : y0+y1*t+y2*u+y3*v : 1].

Coefficients are required to be the same at several parameter fibres.  This
is only a discovery/refutation screen for this tiny formula class, never an
emptiness certificate for the conic criterion.
"""

from __future__ import annotations

from pathlib import Path

import sympy as sp

from model import specialized_cubic, specialized_field
from screen_monomial_points import multiplication_tensor, vector


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "linear_ansatz_p67.in"
VARIABLES = sp.symbols("x0:4 y0:4")
SAMPLES = (
    {"A": 1, "B": 2, "Y": 3, "Z": 4},
    {"A": 1, "B": 1, "Y": 1, "Z": 1},
    {"A": 2, "B": 3, "Y": 5, "Z": 7},
    {"A": 3, "B": 1, "Y": 4, "Z": 2},
)
PRIME = 67


def add(left, right):
    return [sp.expand(x + y) for x, y in zip(left, right)]


def scale(scalar, value):
    return [sp.expand(scalar * x) for x in value]


def mul(left, right, tensor):
    answer = []
    for output in range(6):
        value = 0
        for i in range(6):
            for j in range(6):
                coefficient = int(tensor[i, j, output]) % PRIME
                if coefficient:
                    value += coefficient * left[i] * right[j]
        answer.append(sp.Poly(value, *VARIABLES, modulus=PRIME).as_expr())
    return answer


def fibre_equations(sample):
    field = specialized_field(sample, PRIME)
    tensor = multiplication_tensor(field)
    basis = [
        vector(field, field.element(1)),
        vector(field, field.t_element),
        vector(field, field.u_element),
        vector(field, field.v_element),
    ]
    X = [sum(VARIABLES[index] * int(basis[index][row]) for index in range(4)) for row in range(6)]
    y = [sum(VARIABLES[4 + index] * int(basis[index][row]) for index in range(4)) for row in range(6)]
    w = [sp.Integer(1), 0, 0, 0, 0, 0]
    q, r = specialized_cubic(field.values, PRIME, 9)

    X2, y2 = mul(X, X, tensor), mul(y, y, tensor)
    value = mul(X2, X, tensor)
    qvalue = add(add(scale(q[0], y2), scale(q[1], y)), scale(q[2], w))
    value = add(value, mul(X, qvalue, tensor))
    rvalue = add(add(scale(r[0], mul(y2, y, tensor)), scale(r[1], y2)), add(scale(r[2], y), scale(r[3], w)))
    value = add(value, rvalue)
    return [sp.Poly(entry, *VARIABLES, modulus=PRIME).as_expr() for entry in value]


def msolve(expression) -> str:
    return str(sp.Poly(expression, *VARIABLES, modulus=PRIME).as_expr()).replace("**", "^")


def main() -> None:
    equations = []
    for sample in SAMPLES:
        equations.extend(fibre_equations(sample))
    assert len(equations) == 24
    text = ",".join(str(variable) for variable in VARIABLES) + "\n"
    text += f"{PRIME}\n"
    text += ",\n".join(msolve(equation) for equation in equations) + "\n"
    OUTPUT.write_text(text)
    print(f"output={OUTPUT}")
    print(f"equations={len(equations)} variables={len(VARIABLES)} bytes={len(text)}")
    print("LINEAR_ANSATZ_P67_INPUT_BUILT")


if __name__ == "__main__":
    main()
