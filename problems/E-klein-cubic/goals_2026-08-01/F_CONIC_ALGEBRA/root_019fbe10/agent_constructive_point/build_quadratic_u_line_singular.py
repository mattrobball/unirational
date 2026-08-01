#!/usr/bin/env python3
"""Build the quadratic-u split-conic system over GF(67)(s).

This asks whether the degree-144 finite solution scheme seen on constant
fibres has a rational point over the generic line (A,B,Y,Z)=(1,2,3,s).
It is a subroute test, not the full K_proj-point criterion.
"""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
GOAL_F = HERE.parents[1]
PROBLEM = GOAL_F.parents[1]
PRIME = 67


def load_model():
    spec = importlib.util.spec_from_file_location("goal_f_model_line", GOAL_F / "model.py")
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


MODEL = load_model()


def line_modulus(u, s):
    records = json.loads(
        (PROBLEM / "tmp/pathF_existence/line_eliminant_E_terms.json").read_text()
    )
    expression = 0
    for record in records:
        eu, es = map(int, record["exponents"])
        numerator = int(record["numerator"])
        denominator = int(record["denominator"])
        coefficient = numerator * pow(denominator, -1, PRIME) % PRIME
        expression += coefficient * u**eu * s**es
    return sp.Poly(expression, u, s, modulus=PRIME).as_expr()


def singular(poly) -> str:
    return str(sp.Poly(poly, *sorted(poly.free_symbols, key=str), modulus=PRIME).as_expr()).replace("**", "^")


def main() -> None:
    u, s = sp.symbols("u s")
    a0, a1, a2, b0, b1, b2, lam, invlam = sp.symbols(
        "a0 a1 a2 b0 b1 b2 lam invlam"
    )
    variables = (a0, a1, a2, b0, b1, b2, lam, invlam)
    sample0 = {"A": 1, "B": 2, "Y": 3, "Z": 0}
    sample1 = {"A": 1, "B": 2, "Y": 3, "Z": 1}
    q0, r0 = MODEL.specialized_cubic(sample0, PRIME, 9)
    q1, r1 = MODEL.specialized_cubic(sample1, PRIME, 9)
    assert q0 == q1
    r = tuple((r0[i] + s * ((r1[i] - r0[i]) % PRIME)) for i in range(4))
    X = a0 + a1 * u + a2 * u**2
    y = b0 + b1 * u + b2 * u**2
    cubic = (
        X**3
        + X * (q0[0] * y**2 + q0[1] * y + q0[2])
        + r[0] * y**3
        + r[1] * y**2
        + r[2] * y
        + r[3]
    )
    modulus = line_modulus(u, s)
    identity = sp.expand(cubic - lam * modulus)
    equations = [identity.coeff(u, degree) for degree in range(7)]
    equations.append(lam * invlam - 1)

    def emit(expression):
        # SymPy's centered modular coefficients are accepted by Singular.
        return str(sp.Poly(expression, *variables, domain=sp.GF(PRIME).frac_field(s)).as_expr()).replace("**", "^")

    body = [
        "option(redSB);",
        "option(prot);",
        "ring r=(67,s),(a0,a1,a2,b0,b1,b2,lam,invlam),dp;",
        "ideal I=" + ",\n".join(emit(eq) for eq in equations) + ";",
        'print("INPUT_READY");',
        "ideal G=std(I);",
        'print("STD_DONE");',
        'print("DIM="+string(dim(G)));',
        'print("VDIM="+string(vdim(G)));',
        'print("LM="+string(lead(G)));',
        "quit;",
    ]
    path = HERE / "quadratic_u_line_p67.sing"
    path.write_text("\n".join(body) + "\n")
    manifest = {
        "scope": "quadratic-u split-conic subroute over one generic line",
        "prime": PRIME,
        "line": {"A": 1, "B": 2, "Y": 3, "Z": "s"},
        "equations": len(equations),
        "variables": list(map(str, variables)),
        "script": path.name,
    }
    (HERE / "quadratic_u_line_manifest.json").write_text(
        json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(manifest, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
