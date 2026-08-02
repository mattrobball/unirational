#!/usr/bin/env python3
"""Emit an exact Singular verification of the reconstructed generic RUR.

The emitted calculation works over K=Q(A,u).  It constructs the field
K[Z]/(QZ), obtains the inverse of dQZ/dZ by an explicit Bezout lift, maps B
and Y to the reconstructed trace-dual coordinates, and reduces every member
of the full critical ideal and every accepted open gate.  Thus no sampled
specialization or interpolation identity is trusted by the verifier.
"""

from __future__ import annotations

import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
FACTORS = ROOT / "certificates/fold_normalization_t2r/saturation_factors"
OUTPUT = HERE / "verify_generic_rur.sing"


def load_source():
    spec = importlib.util.spec_from_file_location("fold_t11_specialized", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def source_poly(terms, derivative: tuple[int, ...] = ()) -> str:
    pieces: list[str] = []
    for exponents0, coefficient0 in sorted(terms, reverse=True):
        exponents = list(exponents0)
        coefficient = coefficient0
        for index in derivative:
            if exponents[index] == 0:
                coefficient = 0
                break
            coefficient *= exponents[index]
            exponents[index] -= 1
        if not coefficient:
            continue
        monomial = []
        for variable, power in zip(("A", "B", "Y", "Z", "u"), exponents):
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


def gate_poly(terms, with_u: bool) -> str:
    pieces: list[str] = []
    for exponents, coefficient in sorted(terms, reverse=True):
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


def tsv_poly(path: Path) -> str:
    pieces: list[str] = []
    with path.open() as stream:
        assert next(stream).strip() == "A\tu\tZ\tcoefficient"
        for line in stream:
            a, upow, z, coefficient = map(int, line.split())
            monomial = []
            for variable, power in (("A", a), ("u", upow), ("Z", z)):
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
    src = load_source()
    primitive = src.load_P()
    gates = {
        "ell": (src.load_tsv(FACTORS / "ell_lc_u.tsv"), False),
        "Q4": (src.load_tsv(FACTORS / "G_factor_Q4.tsv"), False),
        "PuuGate": (src.load_tsv(FACTORS / "P_uu.tsv", with_u=True), True),
        "Cgate": (src.load_tsv(FACTORS / "C_content.tsv"), False),
        "delta": (src.load_tsv(FACTORS / "delta_Cramer.tsv", with_u=True), True),
    }
    derivatives = {
        "P0": (),
        "Pu0": (4,),
        "PA0": (0,),
        "PB0": (1,),
        "PY0": (2,),
        "PZ0": (3,),
        "PBB0": (1, 1),
        "PBY0": (1, 2),
        "PBZ0": (1, 3),
        "PYY0": (2, 2),
        "PYZ0": (2, 3),
        "PZZ0": (3, 3),
        "PuB0": (4, 1),
        "PuY0": (4, 2),
        "PuZ0": (4, 3),
    }
    lines = ["ring S=(0,A,u),(B,Y,Z),dp;"]
    for name, derivative in derivatives.items():
        lines.append(f"poly {name}={source_poly(primitive, derivative)};")
    for name, (terms, with_u) in gates.items():
        lines.append(f"poly {name}0={gate_poly(terms, with_u)};")
    lines.extend(
        [
            "ring R=(0,A,u),(Z),lp;",
            f"poly q={tsv_poly(HERE / 'generic_singular_rur_QZ.tsv')};",
            f"poly nb={tsv_poly(HERE / 'generic_singular_rur_NB.tsv')};",
            f"poly ny={tsv_poly(HERE / 'generic_singular_rur_NY.tsv')};",
            "ideal Gq=std(ideal(q));",
            "poly qp=diff(q,Z);",
            "matrix bez=lift(ideal(q,qp),ideal(1));",
            "poly iq=reduce(bez[2,1],Gq);",
            'if (reduce(iq*qp,Gq)!=1) { print("FAIL_QPRIME_INVERSE"); quit; }',
            "poly b=reduce(nb*iq,Gq);",
            "poly y=reduce(ny*iq,Gq);",
            "map phi=S,b,y,Z;",
            'print("RUR_BEGIN");',
        ]
    )
    for name in ("P0", "Pu0", "PA0", "PB0", "PY0", "PZ0"):
        lines.extend(
            [
                f"poly r{name}=reduce(phi({name}),Gq);",
                f'print("REDUCE_{name}="+string(r{name}));',
                f'if (r{name}!=0) {{ print("FAIL_{name}"); quit; }}',
            ]
        )
    lines.extend(
        [
            "poly h11=phi(PBB0); poly h12=phi(PBY0); poly h13=phi(PBZ0);",
            "poly h22=phi(PYY0); poly h23=phi(PYZ0); poly h33=phi(PZZ0);",
            "poly v1=phi(PuB0); poly v2=phi(PuY0); poly v3=phi(PuZ0);",
            "matrix HM[4][4]=h11,h12,h13,v1,h12,h22,h23,v2,h13,h23,h33,v3,v1,v2,v3,0;",
            "matrix HC[3][3]=h11,h12,h13,h12,h22,h23,h13,h23,h33;",
            "poly dnode=reduce(det(HM),Gq);",
            "poly dchart=reduce(det(HC),Gq);",
            'if (dnode==0) { print("FAIL_BORDERED_HESSIAN_ZERO"); quit; }',
            'if (dchart==0) { print("FAIL_CHART_HESSIAN_ZERO"); quit; }',
            'print("BORDERED_HESSIAN_NONZERO=1");',
            'print("CHART_HESSIAN_NONZERO=1");',
            "ideal GateImages=phi(B),phi(ell0),phi(Q40),phi(PuuGate0),phi(Cgate0),phi(delta0),dnode,dchart;",
            "string GateNames[8]=\"B\",\"ell\",\"Q4\",\"Puu\",\"C\",\"delta\",\"Dnode\",\"Dchart\";",
            "int k; poly gv; matrix gbz;",
            "for (k=1;k<=8;k++) {",
            "  gv=reduce(GateImages[k],Gq);",
            '  if (gv==0) { print("FAIL_GATE_"+GateNames[k]); quit; }',
            "  gbz=lift(ideal(q,gv),ideal(1));",
            '  if (reduce(gbz[2,1]*gv,Gq)!=1) { print("FAIL_GATE_INVERSE_"+GateNames[k]); quit; }',
            '  print("GATE_UNIT_"+GateNames[k]+"=1");',
            "}",
            'print("RUR_DEGREE="+string(deg(q)));',
            'print("RUR_EXACT_MEMBERSHIP_PASS");',
            "quit;",
        ]
    )
    OUTPUT.write_text("\n".join(lines) + "\n")
    print(f"wrote {OUTPUT} ({OUTPUT.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
