#!/usr/bin/env python3
"""Emit an exact Singular probe for the generic T3 singular component.

The coefficient field is Q(A,u).  The curve is the generic fibre
``P=P_u=0`` in (B,Y,Z), while ``J`` is the reconstructed degree-six RUR
ideal.  The generated script first verifies that all six critical equations
reduce to zero modulo J.  With ``--run-normal`` it then calls normal.lib with
``isPrim`` and J as ``inputJ``; this is valid only after the accepted
target-integrality/common-open argument has identified the localized fold
curve with a prime generic fibre.
"""

from __future__ import annotations

import argparse
import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
RUR_PREFIX = HERE / "generic_singular_rur"


def load_source():
    spec = importlib.util.spec_from_file_location("fold_t11_specialized", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def primitive_expression(terms) -> str:
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


def rur_expression(path: Path) -> str:
    pieces = []
    with path.open() as stream:
        assert next(stream).strip() == "A\tu\tZ\tcoefficient"
        for line in stream:
            a, upow, z, coefficient = map(int, line.split())
            monomial = []
            for variable, power in (("A", a), ("u", upow), ("Z", z)):
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
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-normal", action="store_true")
    parser.add_argument("--normal-only", action="store_true")
    parser.add_argument("--univariate-inverse", action="store_true")
    parser.add_argument("--rur-rep-prefix", type=Path)
    parser.add_argument("--characteristic", type=int, default=0)
    parser.add_argument(
        "--output", type=Path, default=HERE / "generic_local_normalization.sing"
    )
    args = parser.parse_args()

    qz = rur_expression(RUR_PREFIX.with_name(RUR_PREFIX.name + "_QZ.tsv"))
    nb = rur_expression(RUR_PREFIX.with_name(RUR_PREFIX.name + "_NB.tsv"))
    ny = rur_expression(RUR_PREFIX.with_name(RUR_PREFIX.name + "_NY.tsv"))

    if args.univariate_inverse:
        lines = [
            "option(redSB);",
            f"ring R=({args.characteristic},A,u),(Z),dp;",
            f"poly QZ={qz};",
            f"poly NB={nb};",
            f"poly NY={ny};",
            "poly dQZ=diff(QZ,Z);",
            'print("EXTGCD_BEGIN");',
            "ideal EGin=QZ,dQZ; matrix EGtransform;",
            "ideal EG=liftstd(EGin,EGtransform);",
            'print("EXTGCD_DONE");',
            'print("GCD_BEGIN"); EG; print("GCD_END");',
            "poly inv=EGtransform[2,1]/EG[1];",
            "poly Brep=reduce(NB*inv,std(QZ));",
            "poly Yrep=reduce(NY*inv,std(QZ));",
        ]
        if args.rur_rep_prefix is None:
            lines += [
                'print("BREP_BEGIN"); Brep; print("BREP_END");',
                'print("YREP_BEGIN"); Yrep; print("YREP_END");',
            ]
        else:
            brep = args.rur_rep_prefix.with_name(args.rur_rep_prefix.name + "_B.txt")
            yrep = args.rur_rep_prefix.with_name(args.rur_rep_prefix.name + "_Y.txt")
            gcdp = args.rur_rep_prefix.with_name(args.rur_rep_prefix.name + "_gcd.txt")
            lines += [
                f'write("{brep}",Brep);',
                f'write("{yrep}",Yrep);',
                f'write("{gcdp}",EG[1]);',
                'print("REP_FILES_WRITTEN");',
            ]
        lines += ["quit;"]
        args.output.write_text("\n".join(lines) + "\n")
        print(f"wrote {args.output} ({args.output.stat().st_size} bytes)")
        return

    primitive = load_source().load_P()

    lines = [
        'option(redSB); LIB "normal.lib";',
        f"ring T={args.characteristic},(A,u,B,Y,Z),dp;",
        f"poly P0={primitive_expression(primitive)};",
        "poly Pu0=diff(P0,u); poly PA0=diff(P0,A);",
        "poly PB0=diff(P0,B); poly PY0=diff(P0,Y); poly PZ0=diff(P0,Z);",
        f"poly QZ0={qz};",
        f"poly NB0={nb};",
        f"poly NY0={ny};",
        'print("SOURCE_READY");',
        f"ring R=({args.characteristic},A,u),(B,Y,Z),dp;",
        "poly P=imap(T,P0); poly Pu=imap(T,Pu0); poly PA=imap(T,PA0);",
        "poly PB=imap(T,PB0); poly PY=imap(T,PY0); poly PZ=imap(T,PZ0);",
        "poly QZ=imap(T,QZ0); poly NB=imap(T,NB0); poly NY=imap(T,NY0);",
        "poly dQZ=diff(QZ,Z);",
        'print("MAPPED");',
        "ideal Jraw=QZ,B*dQZ-NB,Y*dQZ-NY;",
    ]
    if not args.normal_only:
        lines += [
            "ideal J=std(Jraw);",
            'print("J_DIM="+string(dim(J))); print("J_VDIM="+string(vdim(J)));',
            "ideal Critical=P,Pu,PA,PB,PY,PZ;",
            "ideal CriticalRemainders=reduce(Critical,J);",
            'print("CRITICAL_REMAINDERS_BEGIN"); CriticalRemainders; print("CRITICAL_REMAINDERS_END");',
            "ideal Qsquarefree=std(QZ,dQZ);",
            'print("Q_SQUAREFREE_IDEAL_BEGIN"); Qsquarefree; print("Q_SQUAREFREE_IDEAL_END");',
        ]
    if args.run_normal:
        lines += [
            "ideal K=P,Pu;",
            # The corrected RUR ideal is the proposed radical test ideal.
            # Feeding the six large critical generators back to normal.lib is
            # redundant and makes its initial interred step dominate runtime.
            "ideal JwithK=Jraw;",
            "printlevel=0;",
            'print("NORMAL_BEGIN");',
            'list N=normal(K,"isPrim",list("inputJ",JwithK));',
            'print("NORMAL_DONE");',
            'print("MODULE_BEGIN"); N[2]; print("MODULE_END");',
            'print("NORMAL_RING_BEGIN"); N[3]; print("NORMAL_RING_END");',
        ]
    lines += ["quit;"]
    args.output.write_text("\n".join(lines) + "\n")
    print(f"wrote {args.output} ({args.output.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
