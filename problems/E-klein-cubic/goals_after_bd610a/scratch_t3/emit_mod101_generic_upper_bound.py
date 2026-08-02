#!/usr/bin/env python3
"""Emit a generic mod-101 Hilbert upper-bound calculation for I_sing.

A zero-dimensional quotient of length six over F_101(A,u), computed from the
*unconstrained* gate-saturated critical ideal, gives a characteristic-zero
Hilbert-function upper bound: every Macaulay-matrix rank visible modulo 101
is at most the corresponding rank in characteristic zero.  Combined with a
directly verified degree-six characteristic-zero RUR component, this proves
exhaustiveness without an affine-specialization/no-escape assumption.
"""

from __future__ import annotations

import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
OUTPUT = HERE / "mod101_generic_upper_bound.sing"


def load_source():
    spec = importlib.util.spec_from_file_location("fold_t11_specialized", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def polynomial_string(terms, with_u: bool):
    pieces = []
    for exponents, coefficient in sorted(terms, reverse=True):
        coefficient %= 101
        if coefficient > 50:
            coefficient -= 101
        if not coefficient:
            continue
        if with_u:
            a, b, y, z, upow = exponents
        else:
            a, b, y, z = exponents
            upow = 0
        monomial = []
        for variable, power in (("A", a), ("u", upow), ("B", b), ("Y", y), ("Z", z)):
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


def main() -> None:
    src = load_source()
    primitive = src.load_P()
    factors = src.FACTORS
    gates = {
        "ell": (src.load_tsv(factors / "ell_lc_u.tsv"), False),
        "Q4": (src.load_tsv(factors / "G_factor_Q4.tsv"), False),
        "PuuGate": (src.load_tsv(factors / "P_uu.tsv", with_u=True), True),
        "Cgate": (src.load_tsv(factors / "C_content.tsv"), False),
        "delta": (src.load_tsv(factors / "delta_Cramer.tsv", with_u=True), True),
    }
    lines = [
        'LIB "elim.lib";',
        "ring T=101,(A,u,B,Y,Z),dp;",
        f"poly P0={polynomial_string(primitive, True)};",
        "poly Pu0=diff(P0,u);",
        "poly PA0=diff(P0,A);",
        "poly PB0=diff(P0,B);",
        "poly PY0=diff(P0,Y);",
        "poly PZ0=diff(P0,Z);",
    ]
    for name, (terms, with_u) in gates.items():
        lines.append(f"poly {name}0={polynomial_string(terms, with_u)};")
    lines.extend(
        [
            'print("STAGE source");',
            "ideal I0=P0,Pu0,PA0,PB0,PY0,PZ0;",
            "ring R=(101,A,u),(B,Y,Z),dp;",
            "ideal I=imap(T,I0);",
            "poly ell=imap(T,ell0);",
            "poly Q4=imap(T,Q40);",
            "poly PuuGate=imap(T,PuuGate0);",
            "poly Cgate=imap(T,Cgate0);",
            "poly delta=imap(T,delta0);",
            'print("STAGE mapped");',
            "I=std(I);",
            'print("RAW_DIM="+string(dim(I))+" RAW_VDIM="+string(vdim(I)));',
            "list gates=B,ell,Q4,PuuGate,Cgate,delta;",
            "int k; list satresult;",
            "for (k=1;k<=size(gates);k++) {",
            "  satresult=sat(I,gates[k]); I=std(satresult[1]);",
            '  print("SAT_"+string(k)+" DIM="+string(dim(I))+" VDIM="+string(vdim(I))+" SIZE="+string(size(I)));',
            "}",
            'print("FINAL_BEGIN");',
            "I;",
            'print("FINAL_END");',
            "quit;",
        ]
    )
    OUTPUT.write_text("\n".join(lines) + "\n")
    print(f"wrote {OUTPUT} ({OUTPUT.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
