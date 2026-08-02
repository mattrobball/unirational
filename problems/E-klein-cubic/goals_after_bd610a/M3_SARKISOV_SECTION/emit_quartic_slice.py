#!/usr/bin/env python3
"""Emit a square candidate slice of the raw d=4 section scheme.

The binary cubic ``b`` is frozen to the squarefree common factor from the
modular boundary certificate.  Two A-coordinates are fixed at their boundary
values.  This leaves 13 cubic equations in 13 variables.  The guaranteed
common-factor point is a control; any solution not divisible by ``b`` is a
genuine basepoint-free modular section candidate and must then be lifted over
the projective Schur field before it has characteristic-zero meaning.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def msolve_text(poly: sp.Poly, prime: int) -> str:
    terms = []
    names = [str(value) for value in poly.gens]
    for exponents, raw in poly.terms():
        coefficient = int(raw) % prime
        if not coefficient:
            continue
        factors = [] if coefficient == 1 else [str(coefficient)]
        for name, exponent in zip(names, exponents):
            if exponent == 1:
                factors.append(name)
            elif exponent:
                factors.append(f"{name}^{exponent}")
        terms.append("*".join(factors) if factors else "1")
    return "+".join(terms) if terms else "0"


def build(prime: int):
    probe = load("m3_slice_probe", HERE / "probe_section_modp.py")
    modular = load("m3_slice_modular", HERE / "produce_modular_sections.py")
    frame_certificate = json.loads(probe.FRAME.read_text())
    _zeta, frame = probe.frame_mod_prime(frame_certificate, prime)
    phi = probe.transformed_klein(frame, prime)
    parameters, equations = modular.section_polynomials(probe, phi, 4, prime)
    boundary = json.loads((HERE / f"modular_section_boundary_p{prime}.json").read_text())
    values = dict(zip((str(value) for value in parameters), boundary["degree4_boundary_parameters"]))
    fixed_names = ["A0_0", "A0_1", "b_0", "b_1", "b_2", "b_3"]
    fixed = {sp.Symbol(name): values[name] for name in fixed_names}
    unknown = [value for value in parameters if str(value) not in fixed_names]
    assert len(unknown) == 13 and len(equations) == 13
    specialized = [sp.Poly(equation.as_expr().subs(fixed), *unknown, modulus=prime) for equation in equations]
    lines = [",".join(str(value) for value in unknown), str(prime)]
    lines.extend(
        msolve_text(equation, prime) + ("," if index + 1 < len(specialized) else "")
        for index, equation in enumerate(specialized)
    )
    manifest = {
        "schema": "m3-degree4-section-fixed-b-square-slice-v1",
        "scope": "modular discovery only",
        "dimension_status": "unresolved; square equation count does not imply dimension zero",
        "prime": prime,
        "fixed": {str(key): int(value) for key, value in fixed.items()},
        "unknowns": [str(value) for value in unknown],
        "equation_count": len(specialized),
        "degree_bound": [equation.total_degree() for equation in specialized],
        "contains_control_common_factor_point": True,
        "genuine_section_test": "reconstructed A0,A1,A2,b have gcd one in F_p[s,t]",
    }
    return "\n".join(lines) + "\n", manifest


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=23)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    content, manifest = build(args.prime)
    if args.write:
        (HERE / f"quartic_slice_p{args.prime}.in").write_text(content)
        (HERE / f"quartic_slice_p{args.prime}.json").write_text(
            json.dumps(manifest, indent=2, sort_keys=True) + "\n"
        )
    else:
        print(content, end="")


if __name__ == "__main__":
    main()
