#!/usr/bin/env python3
"""Emit a generic Q(A,u) fold-singular calculation constrained by q_Z.

The unconstrained generic Groebner basis previously stalled.  The exact
interpolation phase produced a candidate degree-six eliminant q_Z.  Adding
q_Z before factorwise saturation should make the computation small enough to
test all original generators and recover the triangular algebra directly.

This emitter is discovery infrastructure.  Equality with the unconstrained
saturated ideal still needs an exhaustive degree or associated-cycle check.
"""

from __future__ import annotations

import importlib.util
from collections import defaultdict
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
ELIM = HERE / "singular_Z_eliminant_reconstructed.tsv"
OUTPUT = HERE / "generic_with_Z_eliminant.m2"


def load_source():
    spec = importlib.util.spec_from_file_location("fold_t11_specialized", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def primitive_terms(terms):
    """Combine repeated exponent vectors and remove integer content."""

    bucket = defaultdict(int)
    for exponents, coefficient in terms:
        bucket[tuple(exponents)] += coefficient
    answer = [(exponents, c) for exponents, c in bucket.items() if c]
    content = 0
    for _, coefficient in answer:
        content = gcd(content, abs(coefficient))
    if content > 1:
        answer = [(exponents, coefficient // content) for exponents, coefficient in answer]
    return answer


def derivative(terms, variable_index: int):
    answer = []
    for exponents, coefficient in terms:
        exponents = list(exponents)
        if not exponents[variable_index]:
            continue
        coefficient *= exponents[variable_index]
        exponents[variable_index] -= 1
        answer.append((tuple(exponents), coefficient))
    return primitive_terms(answer)


def generic_string(terms, with_u: bool = True):
    """Serialize terms in A,B,Y,Z,(u) into kk[B,Y,Z]."""

    pieces = []
    for exponents, coefficient in sorted(terms, reverse=True):
        if with_u:
            a, b, y, z, upow = exponents
        else:
            a, b, y, z = exponents
            upow = 0
        scalar = [str(coefficient)]
        if a:
            scalar.append("A" if a == 1 else f"A^{a}")
        if upow:
            scalar.append("u" if upow == 1 else f"u^{upow}")
        coefficient_string = "*".join(scalar)
        monomial = []
        for variable, power in (("B", b), ("Y", y), ("Z", z)):
            if power:
                monomial.append(variable if power == 1 else f"{variable}^{power}")
        if monomial:
            pieces.append(f"({coefficient_string}_kk)*" + "*".join(monomial))
        else:
            pieces.append(f"({coefficient_string}_kk)")
    return "(" + "+".join(pieces).replace("+-", "-") + ")+0*B"


def load_eliminant():
    terms = []
    with ELIM.open() as stream:
        assert next(stream).strip() == "A\tu\tZ\tcoefficient"
        for line in stream:
            a, upow, z, coefficient = map(int, line.split())
            terms.append(((a, 0, 0, z, upow), coefficient))
    return terms


def main() -> None:
    src = load_source()
    primitive = src.load_P()
    factors = src.FACTORS
    gates = {
        "ell": src.load_tsv(factors / "ell_lc_u.tsv"),
        "Cgate": src.load_tsv(factors / "C_content.tsv"),
        "PuuGate": src.load_tsv(factors / "P_uu.tsv", with_u=True),
        "delta": src.load_tsv(factors / "delta_Cramer.tsv", with_u=True),
        "Q4": src.load_tsv(factors / "G_factor_Q4.tsv"),
    }

    lines = [
        'needsPackage "FGLM";',
        "kk=frac(QQ[A,u]);",
        "R=kk[B,Y,Z,MonomialOrder=>GRevLex];",
        '<< "STAGE ring" << endl;',
    ]
    for name, variable_index in zip(
        ("P", "Pu", "PA", "PB", "PY", "PZ"),
        (None, 4, 0, 1, 2, 3),
    ):
        terms = primitive if variable_index is None else derivative(primitive, variable_index)
        lines.append(f"{name}={generic_string(terms)};")
    for name, terms in gates.items():
        lines.append(f"{name}={generic_string(terms, with_u=(name in {'PuuGate', 'delta'}))};")
    lines.extend(
        [
            f"qZ={generic_string(load_eliminant())};",
            '<< "STAGE polys" << endl;',
            "I=ideal(P,Pu,PA,PB,PY,PZ,qZ);",
            '<< "STAGE ideal" << endl;',
            "scan({B,ell,Q4,PuuGate,Cgate,delta}, g -> (",
            "  I=saturate(I,g);",
            '  << "SAT dim=" << dim I << " degree=" << degree I << " gens=" << numgens I << endl;',
            "));",
            '<< "FINAL dim=" << dim I << " degree=" << degree I << " gens=" << numgens I << endl;',
            "G=gb I;",
            '<< "GB_DONE" << endl;',
            "S=kk[B,Y,Z,MonomialOrder=>Lex];",
            "J=fglm(G,S);",
            '<< "LEX_BEGIN" << endl;',
            "scan(flatten entries gens J, g -> << toExternalString g << endl);",
            '<< "LEX_END" << endl;',
            "exit 0;",
        ]
    )
    OUTPUT.write_text("\n".join(lines) + "\n")
    print(f"wrote {OUTPUT} ({OUTPUT.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
