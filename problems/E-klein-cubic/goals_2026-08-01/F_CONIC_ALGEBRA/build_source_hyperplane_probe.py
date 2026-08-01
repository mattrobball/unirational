#!/usr/bin/env python3
"""Build modular Jacobian charts for a source-hyperplane incidence.

The cleared pullback cubic on `P2_z x P4_x` is restricted to the exact
coordinate hyperplane `x4=0`.  If its singular locus is finite in every
product chart at a good prime, upper semicontinuity gives isolated
singularities in characteristic zero; a four-dimensional lci with isolated
singularities is locally factorial.
"""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path

import sympy as sp

from model import FORMS, _cyclotomic_residue


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PRIME = 23
ZETA = 2
x0, x1, x2, x3, x4, X, y, w = sp.symbols("x0 x1 x2 x3 x4 X y w")


def load_kproj():
    path = PROBLEM / "tmp/kproj_arithmetic/core.py"
    spec = importlib.util.spec_from_file_location("goal_f_source_hyperplane_kproj", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def invariant(expression_terms):
    variables = (x0, x1, x2, x3, x4)
    return sp.expand(sum(
        (int(coefficient) % PRIME)
        * sp.prod(variable**exponent for variable, exponent in zip(variables, exponents))
        for exponents, coefficient in expression_terms.items()
    ))


def plane_forms():
    slots = json.loads(FORMS.read_text())["binary_slots"]

    def row(name):
        return [_cyclotomic_residue(item, PRIME, ZETA) for item in slots[name]]

    def ternary(q, r, leading=False):
        value = X**3 if leading else 0
        value += X * (q[0] * y**2 + q[1] * y * w + q[2] * w**2)
        value += r[0] * y**3 + r[1] * y**2 * w + r[2] * y * w**2 + r[3] * w**3
        return value

    q0, qA, qY = row("q0"), row("qA"), row("qY")
    r0, rA, rB, rY, rZ = row("r0"), row("rA"), row("rB"), row("rY"), row("rZ")
    return (
        ternary(q0, r0, True),
        ternary(qA, rA),
        ternary((0, 0, 0), rB),
        ternary(qY, rY),
        ternary((0, 0, 0), rZ),
    )


def singular(expression):
    return str(sp.Poly(expression, *sorted(expression.free_symbols, key=str), modulus=PRIME).as_expr()).replace("**", "^")


def msolve_polynomial(expression, variables):
    pieces = []
    for exponents, coefficient0 in sp.Poly(expression, *variables, modulus=PRIME).terms():
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


def main() -> None:
    kproj = load_kproj()
    raw = kproj.forms()
    f3, f5, f6, f7, f9, f12 = (invariant(raw[degree]) for degree in (3, 5, 6, 7, 9, 12))
    F0, FA, FB, FY, FZ = plane_forms()
    inv18 = pow(18, -1, PRIME)
    total = (
        f3**4 * F0
        + f6 * f3**2 * FA
        + f5 * f7 * FB
        + f9 * f3 * FY
        + (f12 - 11 * inv18 * f6**2) * FZ
    )
    hyperplane = 0
    total = sp.Poly(total.subs(x4, hyperplane), x0, x1, x2, x3, X, y, w, modulus=PRIME).as_expr()
    print(f"total_terms={len(sp.Poly(total, x0,x1,x2,x3,X,y,w,modulus=PRIME).terms())}")
    factor_path = HERE / f"source_hyperplane_factor_p{PRIME}.sing"
    factor_path.write_text("\n".join([
        f"ring R={PRIME},(x0,x1,x2,x3,X,y,w),dp;",
        f"poly F={singular(total)};",
        "list FAC=factorize(F);",
        'print("FACTOR_COUNT="+string(size(FAC[1])));',
        "int i;",
        "for (i=1;i<=size(FAC[1]);i++)",
        "{",
        ' print("FACTOR_"+string(i)+"_DEG="+string(deg(FAC[1][i]))+',
        '       "_EXP="+string(FAC[2][i]));',
        "}",
        'print("SOURCE_HYPERPLANE_FACTOR_DONE");',
        "quit;",
    ]) + "\n")

    source = (x0, x1, x2, x3)
    plane = (X, y, w)
    manifest = []
    for plane_chart in plane:
        for source_chart in source:
            chart = sp.Poly(total.subs({plane_chart: 1, source_chart: 1}),
                            *(variable for variable in (*source, *plane) if variable not in (plane_chart, source_chart)),
                            modulus=PRIME).as_expr()
            variables = sorted(chart.free_symbols, key=str)
            assert len(variables) == 5
            name = f"source_hyperplane_{plane_chart}_{source_chart}_p{PRIME}.sing"
            rows = [
                f"ring R={PRIME},({','.join(map(str, variables))}),dp;",
                "option(redSB);",
                f"poly F={singular(chart)};",
                "ideal J=F," + ",".join(f"diff(F,{variable})" for variable in variables) + ";",
                "ideal G=slimgb(J);",
                f'print("CHART={plane_chart}_{source_chart}");',
                'print("SING_NF1="+string(reduce(1,G)));',
                'print("SING_DIM="+string(dim(G)));',
                'print("SING_DEG="+string(deg(G)));',
                'print("SOURCE_HYPERPLANE_CHART_DONE");',
                "quit;",
            ]
            path = HERE / name
            path.write_text("\n".join(rows) + "\n")
            equations = [chart, *(sp.diff(chart, variable) for variable in variables)]
            msolve_name = name.replace(".sing", ".ms")
            msolve_path = HERE / msolve_name
            msolve_path.write_text(
                ",".join(map(str, variables)) + f"\n{PRIME}\n"
                + ",\n".join(msolve_polynomial(equation, variables) for equation in equations)
                + "\n"
            )
            manifest.append({
                "plane_chart": str(plane_chart),
                "source_chart": str(source_chart),
                "file": name,
                "msolve_file": msolve_name,
                "terms": len(sp.Poly(chart, *variables, modulus=PRIME).terms()),
            })
            print(f"built={name} terms={manifest[-1]['terms']} bytes={path.stat().st_size}")
    (HERE / "source_hyperplane_probe_manifest.json").write_text(json.dumps({
        "scope": "modular characteristic-zero dimension certificate candidate",
        "prime": PRIME,
        "zeta": ZETA,
        "hyperplane": "x4=0",
        "charts": manifest,
    }, indent=2, sort_keys=True) + "\n")
    print("SOURCE_HYPERPLANE_PROBES_BUILT")


if __name__ == "__main__":
    main()
