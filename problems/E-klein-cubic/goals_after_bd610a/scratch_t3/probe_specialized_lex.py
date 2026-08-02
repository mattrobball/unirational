#!/usr/bin/env python3
"""Compute exact gate-saturated lex bases for specialized (A,u) fibres.

This is a discovery helper for Goal T3.  It reconstructs every polynomial
from the sealed primitive TSV, performs the same factorwise saturation used by
the independent T11 verifier, and converts the resulting degree-six algebra
to lex order.  All generated files stay beside this script.
"""

from __future__ import annotations

import argparse
import importlib.util
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
M2 = "/opt/homebrew/bin/M2"


def load_source():
    spec = importlib.util.spec_from_file_location("fold_t11_specialized", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("A", type=int)
    parser.add_argument("u", type=int)
    parser.add_argument("--timeout", type=int, default=300)
    parser.add_argument(
        "--order",
        choices=("BYZ", "ZYB"),
        default="BYZ",
        help="Variable order for the target lex ring.",
    )
    args = parser.parse_args()

    src = load_source()
    primitive = src.load_P()
    factors = src.FACTORS
    gates = {
        "ell": src.load_tsv(factors / "ell_lc_u.tsv"),
        "C": src.load_tsv(factors / "C_content.tsv"),
        "P_uu": src.load_tsv(factors / "P_uu.tsv", with_u=True),
        "delta": src.load_tsv(factors / "delta_Cramer.tsv", with_u=True),
        "Q4": src.load_tsv(factors / "G_factor_Q4.tsv"),
    }
    stem = f"specialized_lex_{args.order}_A{args.A}_u{args.u}"
    script = HERE / f"{stem}.m2"
    output = HERE / f"{stem}.out"
    variables = ",".join(args.order)

    lines = [
        'needsPackage "FGLM";',
        "R=QQ[B,Y,Z,MonomialOrder=>GRevLex];",
    ]
    for name, deriv in zip(
        ("P", "Pu", "PA", "PB", "PY", "PZ"),
        (None, "u", "A", "B", "Y", "Z"),
    ):
        terms = src.specialize_Z(primitive, args.A, args.u, deriv)
        lines.append(f"{name}={src.sstr(terms)};")
    lines.extend(
        [
            f"ell={src.sstr(src.prim_ufree(gates['ell'], args.A))};",
            f"Cgate={src.sstr(src.prim_ufree(gates['C'], args.A))};",
            f"Q4={src.sstr(src.prim_ufree(gates['Q4'], args.A))};",
            f"Puu={src.sstr(src.prim_u(gates['P_uu'], args.A, args.u))};",
            f"delta={src.sstr(src.prim_u(gates['delta'], args.A, args.u))};",
            "I=ideal(P,Pu,PA,PB,PY,PZ);",
            "scan({B,ell,Q4,Puu,Cgate,delta}, g -> I=saturate(I,g));",
            '<< "SAT dim=" << dim I << " degree=" << degree I << endl;',
            f"S=QQ[{variables},MonomialOrder=>Lex];",
            "J=fglm(gb I,S);",
            '<< "LEX_GENS_BEGIN" << endl;',
            "scan(flatten entries gens J, g -> << toExternalString g << endl);",
            '<< "LEX_GENS_END" << endl;',
            "exit 0;",
        ]
    )
    script.write_text("\n".join(lines) + "\n")
    with output.open("w") as stream:
        result = subprocess.run(
            [M2, "--script", str(script)],
            stdout=stream,
            stderr=subprocess.STDOUT,
            timeout=args.timeout,
            check=False,
        )
    print(f"exit={result.returncode} output={output}")
    print(output.read_text()[-16000:])


if __name__ == "__main__":
    main()
