#!/usr/bin/env python3
"""Emit a small generic chart probe constrained by the reconstructed q_Z.

This is discovery only.  The raw derivative triple is known to have
extraneous gate-open components; adjoining q_Z may isolate the desired
degree-six component, but does not prove that q_Z belongs to the full
critical ideal.
"""

from __future__ import annotations

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


def derivative(terms, variable_index: int):
    answer = []
    for exponents, coefficient in terms:
        if exponents[variable_index]:
            new_exponents = list(exponents)
            coefficient *= new_exponents[variable_index]
            new_exponents[variable_index] -= 1
            answer.append((tuple(new_exponents), coefficient))
    return answer


def generic_string(terms):
    pieces = []
    for exponents, coefficient in sorted(terms, reverse=True):
        a, b, y, z, upow = exponents
        scalar = [str(coefficient)]
        if a:
            scalar.append("A" if a == 1 else f"A^{a}")
        if upow:
            scalar.append("u" if upow == 1 else f"u^{upow}")
        monomial = []
        for variable, power in (("B", b), ("Y", y), ("Z", z)):
            if power:
                monomial.append(variable if power == 1 else f"{variable}^{power}")
        term = f"({'*'.join(scalar)}_kk)"
        if monomial:
            term += "*" + "*".join(monomial)
        pieces.append(term)
    return "(" + "+".join(pieces).replace("+-", "-") + ")+0*B"


def singular_string(terms):
    pieces = []
    for exponents, coefficient in sorted(terms, reverse=True):
        a, b, y, z, upow = exponents
        factors = [str(coefficient)]
        for variable, power in (("A", a), ("u", upow), ("B", b), ("Y", y), ("Z", z)):
            if power:
                factors.append(variable if power == 1 else f"{variable}^{power}")
        pieces.append("*".join(factors))
    return "(" + "+".join(pieces).replace("+-", "-") + ")"


def load_eliminant():
    terms = []
    with ELIM.open() as stream:
        if next(stream).strip() != "A\tu\tZ\tcoefficient":
            raise RuntimeError("unexpected q_Z header")
        for line in stream:
            a, upow, z, coefficient = map(int, line.split())
            terms.append(((a, 0, 0, z, upow), coefficient))
    return terms


def main() -> None:
    source = load_source()
    primitive = source.load_P()
    lines = [
        'needsPackage "FGLM";',
        "kk=frac(QQ[A,u]);",
        "R=kk[B,Y,Z,MonomialOrder=>GRevLex];",
        f"qZ={generic_string(load_eliminant())};",
    ]
    for name, index in (("PB", 1), ("PY", 2), ("PZ", 3)):
        lines.append(f"{name}={generic_string(derivative(primitive, index))};")
    lines.extend(
        [
            '<< "POLYS_READY" << endl;',
            "I=ideal(qZ,PB,PY,PZ);",
            '<< "IDEAL dim=" << dim I << " degree=" << degree I << endl;',
            "G=gb I;",
            '<< "GB_DONE dim=" << dim I << " degree=" << degree I << endl;',
            "S=kk[B,Y,Z,MonomialOrder=>Lex];",
            "J=fglm(G,S);",
            '<< "LEX_BEGIN" << endl;',
            "scan(flatten entries gens J, g -> << toExternalString g << endl);",
            '<< "LEX_END" << endl;',
            "exit 0;",
        ]
    )
    output = HERE / "q_chart_probe.m2"
    output.write_text("\n".join(lines) + "\n")
    print(f"wrote {output} ({output.stat().st_size} bytes)")

    singular_lines = [
        'LIB "fglm.lib";',
        "ring R=(0,A,u),(B,Y,Z),dp;",
        f"poly qZ={singular_string(load_eliminant())};",
    ]
    for name, index in (("PB", 1), ("PY", 2), ("PZ", 3)):
        singular_lines.append(
            f"poly {name}={singular_string(derivative(primitive, index))};"
        )
    singular_lines.extend(
        [
            'print("POLYS_READY");',
            "ideal I=qZ,PB,PY,PZ;",
            "ideal G=std(I);",
            'print("GB_DONE");',
            'print("VDIM="+string(vdim(G)));',
            'print("DIM="+string(dim(G)));',
            "ring S=(0,A,u),(B,Y,Z),lp;",
            "ideal GS=imap(R,G);",
            "ideal J=fglm(R,GS);",
            'print("LEX_BEGIN");',
            "J;",
            'print("LEX_END");',
            "exit;",
        ]
    )
    singular_output = HERE / "q_chart_probe.sing"
    singular_output.write_text("\n".join(singular_lines) + "\n")
    print(f"wrote {singular_output} ({singular_output.stat().st_size} bytes)")

    modular_lines = [line.replace("(0,A,u)", "(101,A,u)") for line in singular_lines]
    modular_output = HERE / "q_chart_probe_p101.sing"
    modular_output.write_text("\n".join(modular_lines) + "\n")
    print(f"wrote {modular_output} ({modular_output.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
