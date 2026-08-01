#!/usr/bin/env python3
"""Build finite-field smoothness probes for divisors `u=g` of K_proj.

If `D_g : P(A,B,Y,Z,g)=0` is integral and the pulled-back cubic incidence is
smooth, its generic cubic is a candidate residue-index obstruction.  These
modular scripts are discovery tools; characteristic-zero transfer and the
Picard/index argument require separate certificates.
"""

from __future__ import annotations

import json
from pathlib import Path

import sympy as sp

from model import FORMS, _cyclotomic_residue


HERE = Path(__file__).resolve().parent
PRIMITIVE = HERE / "payload/global_primitive_u_sextic_exact.tsv"
PRIME = 23
ZETA = 2
A, B, Y, Z, X, y, w, lam = sp.symbols("A B Y Z X y w lambda")


def primitive_at(g: int):
    expression = 0
    with PRIMITIVE.open() as stream:
        next(stream)
        for line in stream:
            eA, eB, eY, eZ, eu, coefficient = map(int, line.split())
            expression += (coefficient % PRIME) * A**eA * B**eB * Y**eY * Z**eZ * pow(g, eu, PRIME)
    return sp.Poly(expression, A, B, Y, Z, modulus=PRIME).as_expr()


def cubic():
    slots = json.loads(FORMS.read_text())["binary_slots"]

    def row(name):
        return [_cyclotomic_residue(item, PRIME, ZETA) for item in slots[name]]

    q0, qA, qY = row("q0"), row("qA"), row("qY")
    r0, rA, rB, rY, rZ = row("r0"), row("rA"), row("rB"), row("rY"), row("rZ")
    inv18 = pow(18, -1, PRIME)
    T = Z - 11 * inv18 * A**2
    q = [q0[i] + A * qA[i] + Y * qY[i] for i in range(3)]
    r = [r0[i] + A * rA[i] + B * rB[i] + Y * rY[i] + T * rZ[i] for i in range(4)]
    value = X**3 + X * (q[0] * y**2 + q[1] * y * w + q[2] * w**2)
    value += r[0] * y**3 + r[1] * y**2 * w + r[2] * y * w**2 + r[3] * w**3
    return sp.Poly(value, A, B, Y, Z, X, y, w, modulus=PRIME).as_expr()


def singular(expression) -> str:
    return str(expression).replace("**", "^")


def build(g: int) -> Path:
    D = primitive_at(g)
    c = cubic()
    base = (A, B, Y, Z)
    projective = (X, y, w)
    derivatives_D = [sp.diff(D, variable) for variable in base]
    derivatives_c_base = [sp.diff(c, variable) for variable in base]
    derivatives_c_point = [sp.diff(c, variable) for variable in projective]

    rows = [
        f"ring R={PRIME},(A,B,Y,Z,X,y,w,lambda),dp;",
        "option(redSB);",
        "short=0;",
        f"poly D={singular(D)};",
        f"poly c={singular(c)};",
        "poly DA=diff(D,A); poly DB=diff(D,B); poly DY=diff(D,Y); poly DZ=diff(D,Z);",
        "ideal JD=D,DA,DB,DY,DZ;",
        "ideal GD=std(JD);",
        'print("D_SMOOTH_NF1="+string(reduce(1,GD)));',
        'print("D_SING_DIM="+string(dim(GD)));',
        "ideal JT=D,c,diff(c,X),diff(c,y),diff(c,w),",
    ]
    tangent = [
        derivatives_c_base[index] - lam * derivatives_D[index]
        for index in range(4)
    ]
    rows[-1] += ",".join(singular(value) for value in tangent) + ";"
    for chart in projective:
        rows.extend(
            [
                f"ideal J{chart}=JT,ideal({chart}-1);",
                f"ideal G{chart}=std(J{chart});",
                f'print("CHART_{chart}_NF1="+string(reduce(1,G{chart})));',
                f'print("CHART_{chart}_DIM="+string(dim(G{chart})));',
            ]
        )
    rows.extend([f'print("RESIDUE_DIVISOR_G={g}_PROBE_DONE");', "quit;"])
    output = HERE / f"residue_divisor_g{g}_p{PRIME}.sing"
    output.write_text("\n".join(rows) + "\n")
    return output


def build_divisor_only(g: int) -> Path:
    """Build the cheap four-variable singular-locus test first.

    Keeping this separate from the eight-variable incidence prevents a bad
    divisor from launching the substantially harder tangency calculation.
    """
    D = primitive_at(g)
    rows = [
        f"ring R={PRIME},(A,B,Y,Z),dp;",
        "option(redSB);",
        "short=0;",
        f"poly D={singular(D)};",
        "ideal JD=D,diff(D,A),diff(D,B),diff(D,Y),diff(D,Z);",
        "ideal GD=std(JD);",
        'print("D_SMOOTH_NF1="+string(reduce(1,GD)));',
        'print("D_SING_DIM="+string(dim(GD)));',
        f'print("RESIDUE_DIVISOR_G={g}_ONLY_DONE");',
        "quit;",
    ]
    output = HERE / f"residue_divisor_only_g{g}_p{PRIME}.sing"
    output.write_text("\n".join(rows) + "\n")
    return output


def main() -> None:
    for g in (1, 2, 3, 4, 5):
        divisor_path = build_divisor_only(g)
        print(f"built={divisor_path.name} bytes={divisor_path.stat().st_size}")
        path = build(g)
        print(f"built={path.name} bytes={path.stat().st_size}")
    print("RESIDUE_DIVISOR_SMOOTHNESS_PROBES_BUILT")


if __name__ == "__main__":
    main()
