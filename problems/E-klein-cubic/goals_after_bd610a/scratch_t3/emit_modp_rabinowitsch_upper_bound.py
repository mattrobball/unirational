#!/usr/bin/env python3
"""Emit a generic finite-field critical-ideal calculation with explicit inverses.

Unlike a post-reduction saturation, the Rabinowitsch equations define one
fixed integral ideal, so a finite modular quotient gives a Hilbert-function
upper bound after characteristic-zero lift.  ``--gates`` accepts a prefix of
the authoritative open, useful for finding the smallest inverse set that
removes the known extraneous critical components.
"""

from __future__ import annotations

import argparse
import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"


def load_source():
    spec = importlib.util.spec_from_file_location("fold_source", SOURCE)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def polynomial_string(terms, prime: int, with_u: bool) -> str:
    pieces = []
    for exponents, coefficient0 in sorted(terms, reverse=True):
        coefficient = coefficient0 % prime
        if coefficient > prime // 2:
            coefficient -= prime
        if coefficient == 0:
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
    parser.add_argument("--prime", type=int, default=101)
    parser.add_argument(
        "--gates",
        default="B",
        help="comma-separated subset of B,ell,Q4,Puu,C,delta",
    )
    args = parser.parse_args()
    requested = [item for item in args.gates.split(",") if item]
    allowed = ["B", "ell", "Q4", "Puu", "C", "delta"]
    if any(item not in allowed for item in requested):
        raise SystemExit("unknown gate")

    src = load_source()
    primitive = src.load_P()
    factors = src.FACTORS
    gate_terms = {
        "ell": (src.load_tsv(factors / "ell_lc_u.tsv"), False),
        "Q4": (src.load_tsv(factors / "G_factor_Q4.tsv"), False),
        "Puu": (src.load_tsv(factors / "P_uu.tsv", with_u=True), True),
        "C": (src.load_tsv(factors / "C_content.tsv"), False),
        "delta": (src.load_tsv(factors / "delta_Cramer.tsv", with_u=True), True),
    }
    p = args.prime
    lines = [f"ring T={p},(A,u,B,Y,Z),dp;", f"poly P0={polynomial_string(primitive,p,True)};"]
    lines += [
        "poly Pu0=diff(P0,u); poly PA0=diff(P0,A);",
        "poly PB0=diff(P0,B); poly PY0=diff(P0,Y); poly PZ0=diff(P0,Z);",
    ]
    for name in requested:
        if name == "B":
            continue
        terms, with_u = gate_terms[name]
        lines.append(f"poly {name}0={polynomial_string(terms,p,with_u)};")
    inverse_variables = [f"t{i}" for i in range(len(requested))]
    ring_variables = ",".join(["B", "Y", "Z", *inverse_variables])
    lines += [f"ring R=({p},A,u),({ring_variables}),dp;"]
    for name in ("P", "Pu", "PA", "PB", "PY", "PZ"):
        lines.append(f"poly {name}=imap(T,{name}0);")
    for name in requested:
        if name != "B":
            lines.append(f"poly {name}=imap(T,{name}0);")
    inverse_equations = []
    for i, name in enumerate(requested):
        inverse_equations.append(f"t{i}*{name}-1")
    lines += [
        'print("MAPPED");',
        "ideal I=" + ",".join(["P", "Pu", "PA", "PB", "PY", "PZ", *inverse_equations]) + ";",
        "I=std(I);",
        'print("FINAL_DIM="+string(dim(I))+" FINAL_VDIM="+string(vdim(I))+" SIZE="+string(size(I)));',
        'print("LEADING_BEGIN"); lead(I); print("LEADING_END");',
        "quit;",
    ]
    tag = "_".join(requested) if requested else "none"
    path = HERE / f"mod{p}_rabinowitsch_{tag}.sing"
    path.write_text("\n".join(lines) + "\n")
    print(path)


if __name__ == "__main__":
    main()
