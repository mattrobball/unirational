#!/usr/bin/env python3
"""Emit the constrained generic component test for Singular."""

from __future__ import annotations

import argparse
import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
ELIM = HERE / "singular_Z_eliminant_reconstructed.tsv"


def load_source():
    spec = importlib.util.spec_from_file_location("fold_t11_specialized", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def polynomial_string(terms):
    variables = ("A", "B", "Y", "Z", "u")
    pieces = []
    for exponents, coefficient in sorted(terms, reverse=True):
        monomial = []
        for variable, power in zip(variables, exponents):
            if power:
                monomial.append(variable if power == 1 else f"{variable}^{power}")
        if not monomial:
            pieces.append(str(coefficient))
        elif coefficient == 1:
            pieces.append("*".join(monomial))
        elif coefficient == -1:
            pieces.append("-" + "*".join(monomial))
        else:
            pieces.append(f"({coefficient})*" + "*".join(monomial))
    return "(" + "+".join(pieces).replace("+-", "-") + ")"


def load_eliminant():
    terms = []
    with ELIM.open() as stream:
        assert next(stream).strip() == "A\tu\tZ\tcoefficient"
        for line in stream:
            a, upow, z, coefficient = map(int, line.split())
            terms.append(((a, 0, 0, z, upow), coefficient))
    return terms


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--order", choices=("lp", "dp"), default="lp")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    output = args.output or HERE / f"generic_with_Z_eliminant_{args.order}.sing"
    primitive = load_source().load_P()
    lines = [
        "ring T=0,(A,u,B,Y,Z),dp;",
        f"poly P0={polynomial_string(primitive)};",
        "poly Pu0=diff(P0,u);",
        "poly PA0=diff(P0,A);",
        "poly PB0=diff(P0,B);",
        "poly PY0=diff(P0,Y);",
        "poly PZ0=diff(P0,Z);",
        f"poly q0={polynomial_string(load_eliminant())};",
        'print("STAGE source");',
        "ideal I0=P0,Pu0,PA0,PB0,PY0,PZ0,q0;",
        f"ring R=(0,A,u),(B,Y,Z),{args.order};",
        "ideal I=imap(T,I0);",
        'print("STAGE mapped");',
        "option(redSB);",
        "int before=timer;",
        "ideal G=std(I);",
        'print("GB_SECONDS="+string(timer-before));',
        'print("GB_DIM="+string(dim(G)));',
        'print("GB_VDIM="+string(vdim(G)));',
        'print("GB_SIZE="+string(size(G)));',
        'print("LEX_BEGIN");',
        "G;",
        'print("LEX_END");',
        "quit;",
    ]
    output.write_text("\n".join(lines) + "\n")
    print(f"wrote {output} ({output.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
