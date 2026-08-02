#!/usr/bin/env python3
"""Emit a denominator-cleared exact verifier for the generic singular RUR."""

from __future__ import annotations

import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
FACTORS = ROOT / "certificates/fold_normalization_t2r/saturation_factors"
OUTPUT = HERE / "verify_generic_rur_cleared.sing"


def load_source():
    spec = importlib.util.spec_from_file_location("fold_t11_specialized", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def differentiated(terms, derivative=()):
    answer = []
    for exponents0, coefficient0 in terms:
        exponents = list(exponents0)
        coefficient = coefficient0
        for index in derivative:
            if not exponents[index]:
                coefficient = 0
                break
            coefficient *= exponents[index]
            exponents[index] -= 1
        if coefficient:
            answer.append((tuple(exponents), coefficient))
    return answer


def source_homog(terms, derivative=(), target_degree=None):
    terms = differentiated(terms, derivative)
    degree = max(b + y for (a, b, y, z, u), c in terms)
    if target_degree is None:
        target_degree = degree
    assert target_degree >= degree
    pieces = []
    for (a, b, y, z, upow), coefficient in sorted(terms, reverse=True):
        powers = (
            ("A", a),
            ("u", upow),
            ("B", b),
            ("Y", y),
            ("W", target_degree - b - y),
            ("Z", z),
        )
        body = "*".join(
            variable if power == 1 else f"{variable}^{power}"
            for variable, power in powers
            if power
        )
        if not body:
            pieces.append(str(coefficient))
        elif coefficient == 1:
            pieces.append(body)
        elif coefficient == -1:
            pieces.append("-" + body)
        else:
            pieces.append(f"({coefficient})*{body}")
    return "(" + "+".join(pieces).replace("+-", "-") + ")", target_degree


def gate_as_primitive(terms, with_u):
    answer = []
    for exponents, coefficient in terms:
        if with_u:
            a, b, y, z, upow = exponents
        else:
            a, b, y, z = exponents
            upow = 0
        answer.append(((a, b, y, z, upow), coefficient))
    return answer


def tsv_poly(path):
    pieces = []
    with path.open() as stream:
        next(stream)
        for line in stream:
            a, upow, z, coefficient = map(int, line.split())
            body = "*".join(
                variable if power == 1 else f"{variable}^{power}"
                for variable, power in (("A", a), ("u", upow), ("Z", z))
                if power
            )
            if not body:
                pieces.append(str(coefficient))
            elif coefficient == 1:
                pieces.append(body)
            elif coefficient == -1:
                pieces.append("-" + body)
            else:
                pieces.append(f"({coefficient})*{body}")
    return "(" + "+".join(pieces).replace("+-", "-") + ")"


def main():
    src = load_source()
    primitive = src.load_P()
    derivative_specs = {
        "P0": (), "Pu0": (4,), "PA0": (0,), "PB0": (1,), "PY0": (2,), "PZ0": (3,),
    }
    hessian_specs = {
        "PBB0": (1, 1), "PBY0": (1, 2), "PBZ0": (1, 3),
        "PYY0": (2, 2), "PYZ0": (2, 3), "PZZ0": (3, 3),
        "PuB0": (4, 1), "PuY0": (4, 2), "PuZ0": (4, 3),
    }
    hessian_degree = max(
        max(exps[1] + exps[2] for exps, _ in differentiated(primitive, spec))
        for spec in hessian_specs.values()
    )
    gates = {
        "Bgate": ([((0, 1, 0, 0, 0), 1)], False),
        "ell": (src.load_tsv(FACTORS / "ell_lc_u.tsv"), False),
        "Q4": (src.load_tsv(FACTORS / "G_factor_Q4.tsv"), False),
        "PuuGate": (src.load_tsv(FACTORS / "P_uu.tsv", with_u=True), True),
        "Cgate": (src.load_tsv(FACTORS / "C_content.tsv"), False),
        "delta": (src.load_tsv(FACTORS / "delta_Cramer.tsv", with_u=True), True),
    }
    lines = ["ring S=(0,A,u),(B,Y,W,Z),dp;"]
    degrees = {}
    for name, spec in derivative_specs.items():
        body, degree = source_homog(primitive, spec)
        degrees[name] = degree
        lines.append(f"poly {name}={body};")
    for name, spec in hessian_specs.items():
        body, degree = source_homog(primitive, spec, hessian_degree)
        degrees[name] = degree
        lines.append(f"poly {name}={body};")
    for name, (terms0, with_u) in gates.items():
        terms = terms0 if name == "Bgate" else gate_as_primitive(terms0, with_u)
        body, degree = source_homog(terms)
        degrees[name] = degree
        lines.append(f"poly {name}0={body};")
    lines.extend([
        "ring R=(0,A,u),(Z),lp;",
        f"poly q={tsv_poly(HERE/'generic_singular_rur_QZ.tsv')};",
        f"poly nb={tsv_poly(HERE/'generic_singular_rur_NB.tsv')};",
        f"poly ny={tsv_poly(HERE/'generic_singular_rur_NY.tsv')};",
        "poly qp=diff(q,Z); ideal Gq=std(ideal(q));",
        "map phi=S,nb,ny,qp,Z;",
        'print("CLEARED_RUR_BEGIN");',
    ])
    for name in derivative_specs:
        lines += [
            f"poly r{name}=reduce(phi({name}),Gq);",
            f'print("REDUCE_{name}="+string(r{name}));',
            f'if (r{name}!=0) {{ print("FAIL_{name}"); quit; }}',
        ]
    for name in hessian_specs:
        lines.append(f"poly {name}r=reduce(phi({name}),Gq);")
    lines += [
        "matrix HM[4][4]=PBB0r,PBY0r,PBZ0r,PuB0r,PBY0r,PYY0r,PYZ0r,PuY0r,PBZ0r,PYZ0r,PZZ0r,PuZ0r,PuB0r,PuY0r,PuZ0r,0;",
        "matrix HC[3][3]=PBB0r,PBY0r,PBZ0r,PBY0r,PYY0r,PYZ0r,PBZ0r,PYZ0r,PZZ0r;",
        "poly dnode=reduce(det(HM),Gq); poly dchart=reduce(det(HC),Gq);",
        'if (dnode==0) { print("FAIL_BORDERED_HESSIAN_ZERO"); quit; }',
        'if (dchart==0) { print("FAIL_CHART_HESSIAN_ZERO"); quit; }',
        'print("BORDERED_HESSIAN_NONZERO=1"); print("CHART_HESSIAN_NONZERO=1");',
    ]
    for name in gates:
        lines += [
            f"poly r{name}=reduce(phi({name}0),Gq);",
            f'if (r{name}==0) {{ print("FAIL_GATE_{name}"); quit; }}',
            f'print("GATE_NONZERO_{name}=1");',
        ]
    lines += [
        'if (reduce(qp,Gq)==0) { print("FAIL_QPRIME_ZERO"); quit; }',
        'print("QPRIME_NONZERO=1");',
        'print("RUR_EXACT_CLEARED_MEMBERSHIP_PASS");',
        "quit;",
    ]
    OUTPUT.write_text("\n".join(lines)+"\n")
    (HERE/"verify_generic_rur_cleared_degrees.txt").write_text(
        "\n".join(f"{k}={v}" for k,v in degrees.items())+"\n"
    )
    print(f"wrote {OUTPUT} ({OUTPUT.stat().st_size} bytes), hessian degree {hessian_degree}")


if __name__ == "__main__":
    main()
