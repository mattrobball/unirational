#!/usr/bin/env python3
"""Emit a lean generic component test, parsing the primitive only once."""

from __future__ import annotations

import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
ELIM = HERE / "singular_Z_eliminant_reconstructed.tsv"
OUTPUT = HERE / "generic_with_Z_eliminant_lean.m2"


def load_source():
    spec = importlib.util.spec_from_file_location("fold_t11_specialized", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def t_string(terms):
    pieces = []
    variables = ("a", "b", "y", "z", "t")
    # The accepted TSV order is A,B,Y,Z,u; the T-ring is declared in the
    # order a,t,b,y,z, but names, not declaration positions, govern parsing.
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
    return "(" + "+".join(pieces).replace("+-", "-") + ")+0*a"


def load_eliminant():
    terms = []
    with ELIM.open() as stream:
        assert next(stream).strip() == "A\tu\tZ\tcoefficient"
        for line in stream:
            a, t, z, coefficient = map(int, line.split())
            # A,B,Y,Z,u exponent order for t_string.
            terms.append(((a, 0, 0, z, t), coefficient))
    return terms


def main() -> None:
    src = load_source()
    primitive = src.load_P()
    lines = [
        'needsPackage "FGLM";',
        "T=QQ[a,t,b,y,z,MonomialOrder=>GRevLex];",
        f"P0={t_string(primitive)};",
        '<< "STAGE primitive" << endl;',
        "Pt0=diff(t,P0); Pa0=diff(a,P0); Pb0=diff(b,P0); Py0=diff(y,P0); Pz0=diff(z,P0);",
        f"q0={t_string(load_eliminant())};",
        '<< "STAGE derivatives" << endl;',
        "kk=frac(QQ[A,u]);",
        "R=kk[B,Y,Z,MonomialOrder=>GRevLex];",
        "phi=map(R,T,{A,u,B,Y,Z});",
        "P=phi P0; Pu=phi Pt0; PA=phi Pa0; PB=phi Pb0; PY=phi Py0; PZ=phi Pz0; qZ=phi q0;",
        '<< "STAGE mapped" << endl;',
        "I=ideal(P,Pu,PA,PB,PY,PZ,qZ);",
        "G=gb I;",
        '<< "GB_DONE dim=" << dim G << " degree=" << degree G << endl;',
        "if dim G==0 then (",
        "  S=kk[B,Y,Z,MonomialOrder=>Lex];",
        "  J=fglm(G,S);",
        '  << "LEX_BEGIN" << endl;',
        "  scan(flatten entries gens J, g -> << toExternalString g << endl);",
        '  << "LEX_END" << endl;',
        ");",
        "exit 0;",
    ]
    OUTPUT.write_text("\n".join(lines) + "\n")
    print(f"wrote {OUTPUT} ({OUTPUT.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
