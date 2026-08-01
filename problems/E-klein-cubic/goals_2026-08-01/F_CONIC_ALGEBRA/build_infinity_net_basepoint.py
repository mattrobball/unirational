#!/usr/bin/env python3
"""Build exact small basepoint tests for the normalized infinity divisor.

On the Q4 infinity component, an explicit normalization chart has function
field C(r,rho,T).  The pulled-back fixed-frame cubic is

    C0(r) + rho*Crho(r) + T*CT.

The three coefficient cubics form a net over C(r).  Projective basepoint
freeness makes its universal incidence a P1-bundle and forces generic index
three.  The generated Singular charts test basepoint freeness over F_p(r).
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import sympy as sp

from model import FORMS, _cyclotomic_residue


HERE = Path(__file__).resolve().parent
r, X, y, w = sp.symbols("r X y w")
PLANE = (X, y, w)


def fixed_forms(prime: int, zeta: int) -> dict[str, sp.Expr]:
    payload = json.loads(FORMS.read_text())["binary_slots"]

    def row(name: str) -> list[int]:
        return [_cyclotomic_residue(item, prime, zeta) for item in payload[name]]

    def quadratic(values: list[int]) -> sp.Expr:
        return values[0] * y**2 + values[1] * y * w + values[2] * w**2

    def cubic(values: list[int]) -> sp.Expr:
        return values[0] * y**3 + values[1] * y**2 * w + values[2] * y * w**2 + values[3] * w**3

    return {
        "F0": X**3 + X * quadratic(row("q0")) + cubic(row("r0")),
        "FA": X * quadratic(row("qA")) + cubic(row("rA")),
        "FB": cubic(row("rB")),
        "FY": X * quadratic(row("qY")) + cubic(row("rY")),
        "FT": cubic(row("rZ")),
    }


def normalized_net(prime: int, zeta: int) -> tuple[sp.Poly, sp.Poly, sp.Poly]:
    forms = fixed_forms(prime, zeta)
    inv = lambda value: pow(value, -1, prime)
    A0 = -3 * inv(2) * (2500 * r**2 - 11)
    B0 = -5625 * r**2
    Y0 = 33125 * r**2 - 9 * inv(4)
    C0 = forms["F0"] + A0 * forms["FA"] + B0 * forms["FB"] + Y0 * forms["FY"]
    Crho = (inv(4) * r - inv(200)) * forms["FB"] + inv(600) * forms["FY"]
    CT = -inv(2) * forms["FB"] + forms["FT"]
    return tuple(sp.Poly(value, r, X, y, w, modulus=prime) for value in (C0, Crho, CT))


def singular(expression: sp.Expr) -> str:
    return str(sp.expand(expression)).replace("**", "^")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=89)
    parser.add_argument("--zeta", type=int)
    args = parser.parse_args()
    prime = args.prime
    zeta = args.zeta
    if zeta is None:
        zeta = next(a for a in range(2, prime) if pow(a, 11, prime) == 1 and a != 1)
    assert pow(zeta, 11, prime) == 1 and zeta != 1
    assert (prime, zeta) == (89, 2), "the sealed good-reduction packet uses (p,zeta)=(89,2)"
    net = normalized_net(prime, zeta)
    manifest = {
        "prime": prime,
        "zeta": zeta,
        "net_terms": [len(poly.terms()) for poly in net],
        "net_r_degrees": [poly.degree(r) for poly in net],
        "charts": [],
    }
    print(f"prime={prime} zeta={zeta} terms={manifest['net_terms']} r_degrees={manifest['net_r_degrees']}")
    for chart in PLANE:
        variables = tuple(variable for variable in PLANE if variable != chart)
        expressions = [poly.as_expr().subs({chart: 1}) for poly in net]
        path = HERE / f"infinity_net_basepoint_{chart}_p{prime}.sing"
        rows = [
            f"ring R=({prime},r),({','.join(map(str, variables))}),dp;",
            "option(redSB);",
            "ideal I=" + ",\n".join(singular(item) for item in expressions) + ";",
            "ideal G=std(I);",
            'print("DIM="+string(dim(G)));',
            "poly n=reduce(1,G);",
            'if (n==0) { print("UNIT=1"); } else { print("UNIT=0"); print(G); }',
            f'print("INFINITY_NET_BASEPOINT_{chart}_P{prime}_DONE");',
            "quit;",
        ]
        path.write_text("\n".join(rows) + "\n")
        manifest["charts"].append(path.name)

    # The w=1 basis seen at the good prime is a line plus a cubic field.
    Gbase = X**3 + (19 * r**2 - 31) * X + (-26 * r**2 + 14)
    factor_path = HERE / f"infinity_net_base_cubic_factor_p{prime}.sing"
    factor_path.write_text(
        "\n".join(
            [
                f"ring R=({prime},r),(X),dp;",
                f"poly G={singular(Gbase)};",
                "list L=factorize(G,1);",
                "ideal I=L[1];",
                'print("FACTOR_COUNT="+string(size(I)));',
                'print("FACTOR_1="+string(I[1]));',
                f'print("INFINITY_NET_BASE_CUBIC_FACTOR_P{prime}_DONE");',
                "quit;",
            ]
        )
        + "\n"
    )
    manifest["factor_script"] = factor_path.name

    # One smooth member proves that the generic net member is smooth.
    smooth_member = net[0].as_expr().subs({r: 1})
    smooth_paths = []
    for chart in PLANE:
        variables = tuple(variable for variable in PLANE if variable != chart)
        derivatives = [sp.diff(smooth_member, variable).subs({chart: 1}) for variable in PLANE]
        path = HERE / f"infinity_net_smooth_member_{chart}_p{prime}.sing"
        rows = [
            f"ring R={prime},({','.join(map(str, variables))}),dp;",
            "ideal I=" + ",\n".join(singular(value) for value in derivatives) + ";",
            "ideal G=std(I);",
            "poly n=reduce(1,G);",
            'if (n==0) { print("UNIT=1"); } else { print("UNIT=0"); }',
            f'print("INFINITY_NET_SMOOTH_MEMBER_{chart}_P{prime}_DONE");',
            "quit;",
        ]
        path.write_text("\n".join(rows) + "\n")
        smooth_paths.append(path.name)
    manifest["smooth_member_scripts"] = smooth_paths

    (HERE / f"infinity_net_basepoint_p{prime}.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print("INFINITY_NET_BASEPOINT_SCRIPTS_WRITTEN")


if __name__ == "__main__":
    main()
