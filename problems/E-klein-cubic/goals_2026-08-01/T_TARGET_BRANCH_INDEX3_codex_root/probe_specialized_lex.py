#!/usr/bin/env python3
"""Discovery-only exact QQ specialized lex bases for the full six-generator ideal.

This reuses the sealed input parsers from the independent T11.1 verifier, but
writes and runs every generated artifact in this route's isolated directory.
The output is not itself a generic-function-field certificate.
"""
from __future__ import annotations

import argparse
import importlib.util
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent.parent / "certificates/fold_t11/verify_specialized_exact.py"
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
    args = parser.parse_args()

    src = load_source()
    P = src.load_P()
    gates = {
        "ell": src.load_tsv(src.FACTORS / "ell_lc_u.tsv"),
        "C": src.load_tsv(src.FACTORS / "C_content.tsv"),
        "P_uu": src.load_tsv(src.FACTORS / "P_uu.tsv", with_u=True),
        "delta": src.load_tsv(src.FACTORS / "delta_Cramer.tsv", with_u=True),
        "Q4": src.load_tsv(src.FACTORS / "G_factor_Q4.tsv"),
    }
    stem = f"specialized_lex_A{args.A}_u{args.u}"
    script = HERE / f"{stem}.m2"
    output = HERE / f"{stem}.out"
    with script.open("w") as f:
        f.write('needsPackage "FGLM";\n')
        f.write("R=QQ[B,Y,Z,MonomialOrder=>GRevLex];\n")
        for name, deriv in zip(
            ("P", "Pu", "PA", "PB", "PY", "PZ"),
            (None, "u", "A", "B", "Y", "Z"),
        ):
            terms = src.specialize_Z(P, args.A, args.u, deriv)
            f.write(f"{name}={src.sstr(terms)};\n")
        f.write(f"ell={src.sstr(src.prim_ufree(gates['ell'], args.A))};\n")
        f.write(f"Cgate={src.sstr(src.prim_ufree(gates['C'], args.A))};\n")
        f.write(f"Q4={src.sstr(src.prim_ufree(gates['Q4'], args.A))};\n")
        f.write(f"Puu={src.sstr(src.prim_u(gates['P_uu'], args.A, args.u))};\n")
        f.write(f"delta={src.sstr(src.prim_u(gates['delta'], args.A, args.u))};\n")
        f.write(
            """
I=ideal(P,Pu,PA,PB,PY,PZ);
scan({B,ell,Q4,Puu,Cgate,delta}, g -> I=saturate(I,g));
<< "SAT dim=" << dim I << " degree=" << degree I << endl;
S=QQ[B,Y,Z,MonomialOrder=>Lex];
t0=currentTime();
J=fglm(gb I,S);
<< "FGLM_SECONDS " << (currentTime()-t0) << endl;
<< "LEX_GENS_BEGIN" << endl;
scan(flatten entries gens J, g -> << toExternalString g << endl);
<< "LEX_GENS_END" << endl;
"""
        )
    with output.open("w") as out:
        proc = subprocess.run(
            [M2, "--script", str(script)],
            stdout=out,
            stderr=subprocess.STDOUT,
            timeout=args.timeout,
        )
    print(f"exit={proc.returncode} output={output}")
    print(output.read_text()[-12000:])


if __name__ == "__main__":
    main()
