#!/usr/bin/env python3
"""Discovery probe for a split conic parametrized by the primitive u.

On a finite specialization, seek

    X=a2*u^2+a1*u+a0,  y=b2*u^2+b1*u+b0,  w=1

such that the *polynomial identity* c(X,y,1)=lambda*P(u) holds.  A generic
characteristic-zero solution of this system would give both a K_proj-point
and a split conic.  Finite-field outcomes are discovery evidence only.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
from pathlib import Path
import subprocess
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
GOAL_F = HERE.parents[1]


def load_model():
    spec = importlib.util.spec_from_file_location("goal_f_model", GOAL_F / "model.py")
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


MODEL = load_model()
PRIME = 67
SAMPLES = (
    {"A": 1, "B": 2, "Y": 3, "Z": 4},
    {"A": 1, "B": 1, "Y": 1, "Z": 1},
    {"A": 2, "B": 3, "Y": 5, "Z": 7},
    {"A": 3, "B": 1, "Y": 4, "Z": 2},
)


def equations(sample: dict[str, int]):
    u = sp.symbols("u")
    variables = sp.symbols("a0:3 b0:3 lam invlam")
    a0, a1, a2, b0, b1, b2, lam, invlam = variables
    X = a0 + a1 * u + a2 * u**2
    y = b0 + b1 * u + b2 * u**2
    q, r = MODEL.specialized_cubic(sample, PRIME, 9)
    cubic = (
        X**3
        + X * (q[0] * y**2 + q[1] * y + q[2])
        + r[0] * y**3
        + r[1] * y**2
        + r[2] * y
        + r[3]
    )
    field = MODEL.specialized_field(sample, PRIME)
    modulus = field.modulus.monic().as_expr()
    identity = sp.expand(cubic - lam * modulus)
    coefficient_polys = []
    for degree in range(7):
        coefficient = identity.coeff(u, degree)
        coefficient_polys.append(sp.Poly(coefficient, *variables, modulus=PRIME))
    coefficient_polys.append(sp.Poly(lam * invlam - 1, *variables, modulus=PRIME))
    return variables, coefficient_polys


def emit(poly: sp.Poly) -> str:
    pieces = []
    for exponents, coefficient0 in poly.terms():
        coefficient = int(coefficient0) % PRIME
        factors = []
        if coefficient != 1 or not any(exponents):
            factors.append(str(coefficient))
        for variable, exponent in zip(poly.gens, exponents):
            if exponent == 1:
                factors.append(str(variable))
            elif exponent:
                factors.append(f"{variable}^{exponent}")
        pieces.append("*".join(factors) if factors else "1")
    return "+".join(pieces) if pieces else "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--run", action="store_true")
    parser.add_argument("--timeout", type=int, default=300)
    args = parser.parse_args()
    manifest = {"scope": "discovery only", "prime": PRIME, "runs": []}
    for index, sample in enumerate(SAMPLES):
        variables, polys = equations(sample)
        input_path = HERE / f"quadratic_u_param_{index}_p{PRIME}.ms"
        output_path = HERE / f"quadratic_u_param_{index}_p{PRIME}.out"
        input_path.write_text(
            ",".join(map(str, variables))
            + f"\n{PRIME}\n"
            + ",\n".join(emit(poly) for poly in polys)
            + "\n"
        )
        record = {
            "sample": sample,
            "input": input_path.name,
            "output": output_path.name,
            "variables": list(map(str, variables)),
            "equations": len(polys),
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
                record.update(status="completed", returncode=completed.returncode)
            except subprocess.TimeoutExpired as error:
                output = error.stdout or ""
                if isinstance(output, bytes):
                    output = output.decode(errors="replace")
                output_path.write_text(output + "\nTIMEOUT\n")
                record.update(status="timeout")
        manifest["runs"].append(record)
    (HERE / "quadratic_u_param_manifest.json").write_text(
        json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(manifest, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
