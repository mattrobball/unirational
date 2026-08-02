#!/usr/bin/env python3
"""Emit exact grouped RUR reductions over Q(A) at one integral u-slice."""

from __future__ import annotations

import argparse
import importlib.util
from collections import defaultdict
from pathlib import Path

ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
WORK = ROOT / "goals_after_bd610a"
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
RUR = WORK / "scratch_t3/generic_singular_rur"


def load_source():
    spec = importlib.util.spec_from_file_location("fold_t11_specialized", SOURCE)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def derivative(terms, indices=()):
    ans = []
    for exps0, coeff0 in terms:
        exps = list(exps0)
        coeff = coeff0
        for i in indices:
            if exps[i] == 0:
                coeff = 0
                break
            coeff *= exps[i]
            exps[i] -= 1
        if coeff:
            ans.append((tuple(exps), coeff))
    return ans


def scalar(c, factors):
    body = "*".join(
        v if p == 1 else f"{v}^{p}" for v, p in factors if p
    ) or "1"
    if c == 1:
        return body
    if c == -1:
        return "-" + body
    return f"({c})*{body}"


def tsv_rur(label, u0):
    bucket = defaultdict(int)
    with RUR.with_name(RUR.name + f"_{label}.tsv").open() as stream:
        next(stream)
        for line in stream:
            a, upow, z, c = map(int, line.split())
            bucket[(a, z)] += c * u0**upow
    return "(" + "+".join(
        scalar(c, (("A", a), ("Z", z)))
        for (a, z), c in sorted(bucket.items(), reverse=True) if c
    ).replace("+-", "-") + ")"


def emit_reduction(lines, name, terms, u0):
    degree = max(e[1] + e[2] for e, _ in terms)
    groups = defaultdict(lambda: defaultdict(int))
    for (a, b, y, z, upow), c in terms:
        groups[(b, y)][(a, z)] += c * u0**upow
    lines += [f'print("BEGIN_{name}");', f"poly r{name}=0;"]
    for b, y in sorted(groups):
        w = degree - b - y
        coeff = "(" + "+".join(
            scalar(c, (("A", a), ("Z", z)))
            for (a, z), c in sorted(groups[(b, y)].items(), reverse=True) if c
        ).replace("+-", "-") + ")"
        lines.append(f"r{name}=reduce(r{name}+reduce(({coeff})*m_{b}_{y}_{w},Gq),Gq);")
    lines += [
        f'if (r{name}!=0) {{ print("FAIL_{name}="+string(r{name})); quit; }}',
        f'print("PASS_{name}");',
    ]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("u", type=int)
    parser.add_argument("--output", type=Path, default=Path("/tmp/t111_u_slice.sing"))
    args = parser.parse_args()
    src = load_source()
    primitive = src.load_P()
    equations = {
        "P0": derivative(primitive),
        "Pu0": derivative(primitive, (4,)),
        "PA0": derivative(primitive, (0,)),
        "PB0": derivative(primitive, (1,)),
        "PY0": derivative(primitive, (2,)),
        "PZ0": derivative(primitive, (3,)),
    }
    lines = [
        "option(redSB);", "ring R=(0,A),(Z),lp;",
        f"poly q={tsv_rur('QZ', args.u)};",
        f"poly nb={tsv_rur('NB', args.u)};",
        f"poly ny={tsv_rur('NY', args.u)};",
        "poly qp=diff(q,Z); ideal Gq=std(ideal(q));",
        f'print("U_SLICE_BEGIN={args.u}");',
        "poly bp_0=1; poly yp_0=1; poly wp_0=1;",
    ]
    for j in range(1, 7):
        lines += [
            f"poly bp_{j}=reduce(bp_{j-1}*nb,Gq);",
            f"poly yp_{j}=reduce(yp_{j-1}*ny,Gq);",
            f"poly wp_{j}=reduce(wp_{j-1}*qp,Gq);",
        ]
    triples = set()
    for rows in equations.values():
        d = max(e[1] + e[2] for e, _ in rows)
        triples.update((e[1], e[2], d-e[1]-e[2]) for e, _ in rows)
    for b, y, w in sorted(triples):
        lines.append(f"poly m_{b}_{y}_{w}=reduce(reduce(bp_{b}*yp_{y},Gq)*wp_{w},Gq);")
    for name, rows in equations.items():
        emit_reduction(lines, name, rows, args.u)
    lines += [f'print("U_SLICE_PASS={args.u}");', "quit;"]
    args.output.write_text("\n".join(lines) + "\n")
    print(args.output, args.output.stat().st_size)


if __name__ == "__main__":
    main()
