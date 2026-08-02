#!/usr/bin/env python3
"""Emit the exact mod-101 delta-Rabinowitsch border/lift certificate."""

from __future__ import annotations

import importlib.util
from collections import defaultdict
from pathlib import Path

ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
SRC = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
HERE = Path(__file__).resolve().parent
OUT = HERE / "verify_t111_delta_rab_border.sing"
LIFT = HERE / "t111_delta_rab_lift_matrix.sing"
A0, U0, PRIME = 17, 1, 101
SUBSET = ("P", "Pu", "PA", "PB", "PY", "PZ")


def load():
    spec = importlib.util.spec_from_file_location("src", SRC)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def specialize(terms, deriv=()):
    bucket = defaultdict(int)
    for exps0, c0 in terms:
        exps = list(exps0)
        c = c0
        for i in deriv:
            if exps[i] == 0:
                c = 0
                break
            c *= exps[i]
            exps[i] -= 1
        if c:
            c *= A0 ** exps[0] * U0 ** exps[4]
            bucket[(exps[1], exps[2], exps[3], 0)] += c
    return {e: c % PRIME for e, c in bucket.items() if c % PRIME}


def polystr(rows):
    pieces = []
    for e, c in sorted(rows.items(), reverse=True):
        if c > PRIME // 2:
            c -= PRIME
        mon = []
        for v, p in zip(("B", "Y", "Z", "T"), e):
            if p:
                mon.append(v if p == 1 else f"{v}^{p}")
        body = "*".join(mon)
        if not body:
            pieces.append(str(c))
        elif c == 1:
            pieces.append(body)
        elif c == -1:
            pieces.append("-" + body)
        else:
            pieces.append(f"({c})*{body}")
    return "(" + "+".join(pieces).replace("+-", "-") + ")"


def main():
    src = load()
    P = src.load_P()
    delta0 = src.load_tsv(src.FACTORS / "delta_Cramer.tsv", with_u=True)
    specs = {
        "P": (), "Pu": (4,), "PA": (0,),
        "PB": (1,), "PY": (2,), "PZ": (3,),
    }
    lines = ["option(redSB);", "ring R=101,(B,Y,Z,T),dp;"]
    for name, deriv in specs.items():
        lines.append(f"poly {name}={polystr(specialize(P, deriv))};")
    lines.append(f"poly delta={polystr(specialize(delta0))};")
    lines += [
        "ideal I=" + ",".join((*SUBSET, "T*delta-1")) + ";",
        'print("RAB_BEGIN");',
        "matrix Tr; ideal G=liftstd(I,Tr);",
        f'write(":w {LIFT}","matrix Tr[7][10]=");',
        f'write(":a {LIFT}",string(Tr)+";");',
        'print("RAB_GB_DONE");',
        "matrix IM[1][7]=P,Pu,PA,PB,PY,PZ,T*delta-1; matrix GM=IM*Tr; ideal GfromI=GM;",
        "int exactlift=1; int ee; for (ee=1;ee<=size(G);ee++) { if (G[ee]-GfromI[ee]!=0) { exactlift=0; } }",
        'print("LIFT_IDENTITY="+string(exactlift));',
        'print("DIM="+string(dim(G))+" VDIM="+string(vdim(G))+" GSIZE="+string(size(G)));',
        'print("GB_BEGIN"); G; print("GB_END");',
        'print("LEAD_BEGIN"); lead(G); print("LEAD_END");',
        'print("TRANSFORM_DEGREES_BEGIN");',
        "int i; int j; int md; int rd; list generatorDegrees=6,6,6,5,5,5,11;",
        "for (i=1;i<=ncols(Tr);i++) { md=-1; rd=-1; for (j=1;j<=nrows(Tr);j++) { if (Tr[j,i]!=0 and deg(Tr[j,i])>md) { md=deg(Tr[j,i]); }; if (Tr[j,i]!=0 and deg(Tr[j,i])+generatorDegrees[j]>rd) { rd=deg(Tr[j,i])+generatorDegrees[j]; } }; print(string(i)+\" multiplier=\"+string(md)+\" row=\"+string(rd)); }",
        'print("TRANSFORM_DEGREES_END");',
        'print("TRANSFORM_TERMS_BEGIN");',
        "for (i=1;i<=ncols(Tr);i++) { for (j=1;j<=nrows(Tr);j++) { print(string(j)+\" \"+string(i)+\" \"+string(size(Tr[j,i]))); } }",
        'print("TRANSFORM_TERMS_END");',
        "quit;",
    ]
    OUT.write_text("\n".join(lines) + "\n")
    print(OUT, OUT.stat().st_size)


if __name__ == "__main__":
    main()
