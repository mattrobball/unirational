#!/usr/bin/env python3
"""Build characteristic-zero qring charts for the normalized Q4 net."""

from __future__ import annotations

import json
from fractions import Fraction
from pathlib import Path

import sympy as sp

from model import FORMS


HERE = Path(__file__).resolve().parent
z, r, X, y, w = sp.symbols("z r X y w")
PLANE = (X, y, w)


def cyclotomic(pairs: list[list[int]]) -> sp.Expr:
    return sum(Fraction(int(a), int(b)) * z**i for i, (a, b) in enumerate(pairs))


def forms() -> dict[str, sp.Expr]:
    payload = json.loads(FORMS.read_text())["binary_slots"]

    def row(name: str) -> list[sp.Expr]:
        return [cyclotomic(item) for item in payload[name]]

    def q(values: list[sp.Expr]) -> sp.Expr:
        return values[0] * y**2 + values[1] * y * w + values[2] * w**2

    def c(values: list[sp.Expr]) -> sp.Expr:
        return values[0] * y**3 + values[1] * y**2 * w + values[2] * y * w**2 + values[3] * w**3

    return {
        "F0": X**3 + X * q(row("q0")) + c(row("r0")),
        "FA": X * q(row("qA")) + c(row("rA")),
        "FB": c(row("rB")),
        "FY": X * q(row("qY")) + c(row("rY")),
        "FT": c(row("rZ")),
    }


def net() -> tuple[sp.Expr, sp.Expr, sp.Expr]:
    f = forms()
    A0 = -sp.Rational(3, 2) * (2500 * r**2 - 11)
    B0 = -5625 * r**2
    Y0 = 33125 * r**2 - sp.Rational(9, 4)
    C0 = f["F0"] + A0 * f["FA"] + B0 * f["FB"] + Y0 * f["FY"]
    Crho = (r / 4 - sp.Rational(1, 200)) * f["FB"] + sp.Rational(1, 600) * f["FY"]
    CT = -sp.Rational(1, 2) * f["FB"] + f["FT"]
    cleared = []
    for value in (C0, Crho, CT):
        _, integral = sp.Poly(value, r, z, X, y, w, domain=sp.QQ).clear_denoms()
        cleared.append(integral.primitive()[1].as_expr())
    return tuple(sp.expand(value) for value in cleared)


def singular(expression: sp.Expr) -> str:
    return str(expression).replace("**", "^")


def main() -> None:
    values = net()
    manifest = {"charts": [], "terms": [len(sp.Poly(v, r, z, X, y, w).terms()) for v in values]}
    for chart in PLANE:
        remaining = tuple(variable for variable in PLANE if variable != chart)
        path = HERE / f"infinity_net_basepoint_{chart}_Qzeta.sing"
        specialized = [sp.expand(value.subs({chart: 1})) for value in values]
        rows = [
            f"ring R=(0,r),(z,{','.join(map(str, remaining))}),dp;",
            "ideal J=z10+z9+z8+z7+z6+z5+z4+z3+z2+z+1;",
            "qring Q=std(J);",
            "option(redSB);",
            "ideal I=" + ",\n".join(singular(value) for value in specialized) + ";",
            "ideal G=std(I);",
            'print("DIM="+string(dim(G)));',
            "print(G);",
            f'print("INFINITY_NET_BASEPOINT_{chart}_QZETA_DONE");',
            "quit;",
        ]
        path.write_text("\n".join(rows) + "\n")
        manifest["charts"].append(path.name)
    (HERE / "infinity_net_exact_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"terms={manifest['terms']}")
    print("INFINITY_NET_EXACT_SCRIPTS_WRITTEN")


if __name__ == "__main__":
    main()
