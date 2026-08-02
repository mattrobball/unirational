#!/usr/bin/env python3
"""Emit an exact projective critical-fibre certificate.

The six full critical equations are specialized only after differentiating
the authoritative primitive P.  Homogenizing in (B,Y,Z,W) gives a proper
fibre which cannot miss a dominant critical component by affine escape.
"""

from __future__ import annotations

import argparse
import importlib.util
from collections import defaultdict
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"


def source():
    spec = importlib.util.spec_from_file_location("fold_source", SOURCE)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def specialize(terms, a0: int, u0: int, derivative: str | None = None) -> str:
    index = {"A": 0, "B": 1, "Y": 2, "Z": 3, "u": 4}
    bucket: dict[tuple[int, int, int], int] = defaultdict(int)
    for exponents0, coefficient0 in terms:
        exponents = list(exponents0)
        coefficient = coefficient0
        if derivative is not None:
            i = index[derivative]
            if exponents[i] == 0:
                continue
            coefficient *= exponents[i]
            exponents[i] -= 1
        coefficient *= a0 ** exponents[0]
        coefficient *= u0 ** exponents[4]
        bucket[(exponents[1], exponents[2], exponents[3])] += coefficient

    pieces: list[str] = []
    for (b, y, z), coefficient in sorted(bucket.items(), reverse=True):
        if coefficient == 0:
            continue
        monomial = []
        for variable, power in (("B", b), ("Y", y), ("Z", z)):
            if power:
                monomial.append(variable if power == 1 else f"{variable}^{power}")
        body = "*".join(monomial)
        if not body:
            pieces.append(str(coefficient))
        elif coefficient == 1:
            pieces.append(body)
        elif coefficient == -1:
            pieces.append("-" + body)
        else:
            pieces.append(f"({coefficient})*{body}")
    return "(" + "+".join(pieces).replace("+-", "-") + ")"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("A", type=int)
    parser.add_argument("u", type=int)
    args = parser.parse_args()
    primitive = source().load_P()

    lines = ["R=QQ[B,Y,Z,W,MonomialOrder=>GRevLex];"]
    for name, derivative in zip(
        ("P", "Pu", "PA", "PB", "PY", "PZ"),
        (None, "u", "A", "B", "Y", "Z"),
    ):
        lines.append(f"{name}=homogenize({specialize(primitive, args.A, args.u, derivative)},W);")
    lines += [
        '<< "POLYS_READY" << endl;',
        "I=saturate(ideal(P,Pu,PA,PB,PY,PZ),ideal(B,Y,Z,W));",
        '<< "PROJ_DIM=" << dim I << ",PROJ_DEG=" << degree I << endl;',
        "Iinf=saturate(I+ideal(W),ideal(B,Y,Z));",
        '<< "INFINITY_DIM=" << dim Iinf << ",INFINITY_DEG=" << degree Iinf << endl;',
        "Iaff=sub(I,R/(W-1));",
        '<< "AFFINE_DIM=" << dim Iaff << ",AFFINE_DEG=" << degree Iaff << endl;',
        "exit 0;",
    ]
    path = HERE / f"critical_projective_A{args.A}_u{args.u}.m2"
    path.write_text("\n".join(lines) + "\n")
    print(path)


if __name__ == "__main__":
    main()
