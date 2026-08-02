#!/usr/bin/env python3
"""Emit an exact Q(u) saturation of the full critical ideal at fixed A."""

from __future__ import annotations

import argparse
import importlib.util
from collections import defaultdict
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
SOURCE=ROOT/"certificates/fold_t11/verify_specialized_exact.py"
FACTORS=ROOT/"certificates/fold_normalization_t2r/saturation_factors"


def source():
    spec=importlib.util.spec_from_file_location("src",SOURCE)
    module=importlib.util.module_from_spec(spec); spec.loader.exec_module(module)
    return module


def specialize(terms,a0,derivative=None,with_u=True):
    index={"A":0,"B":1,"Y":2,"Z":3,"u":4}
    bucket=defaultdict(int)
    for exps0,c0 in terms:
        if with_u:
            exps=list(exps0)
        else:
            a,b,y,z=exps0; exps=[a,b,y,z,0]
        c=c0
        if derivative:
            i=index[derivative]
            if not exps[i]: continue
            c*=exps[i]; exps[i]-=1
        c*=a0**exps[0]
        bucket[(exps[1],exps[2],exps[3],exps[4])]+=c
    pieces=[]
    for (b,y,z,k),c in sorted(bucket.items(),reverse=True):
        if not c: continue
        mon=[]
        for v,e in (("u",k),("B",b),("Y",y),("Z",z)):
            if e: mon.append(v if e==1 else f"{v}^{e}")
        body="*".join(mon)
        if not body: pieces.append(str(c))
        elif c==1: pieces.append(body)
        elif c==-1: pieces.append("-"+body)
        else: pieces.append(f"({c})*{body}")
    return "("+"+".join(pieces).replace("+-","-")+")"


def main():
    ap=argparse.ArgumentParser(); ap.add_argument("A",type=int)
    ap.add_argument(
        "--raw-only",
        action="store_true",
        help="compute the unsaturated critical ideal over Q(u)",
    )
    args=ap.parse_args()
    s=source(); P=s.load_P()
    gates={
      "ell":(s.load_tsv(FACTORS/"ell_lc_u.tsv"),False),
      "Q4":(s.load_tsv(FACTORS/"G_factor_Q4.tsv"),False),
      "PuuGate":(s.load_tsv(FACTORS/"P_uu.tsv",with_u=True),True),
      "Cgate":(s.load_tsv(FACTORS/"C_content.tsv"),False),
      "delta":(s.load_tsv(FACTORS/"delta_Cramer.tsv",with_u=True),True),
    }
    lines=["Q=QQ[u]; K=frac Q; R=K[B,Y,Z,MonomialOrder=>GRevLex];"]
    for n,d in zip(("P","Pu","PA","PB","PY","PZ"),(None,"u","A","B","Y","Z")):
        lines.append(f"{n}={specialize(P,args.A,d)};")
    for n,(terms,wu) in gates.items(): lines.append(f"{n}={specialize(terms,args.A,None,wu)};")
    lines += [
      '<< "STAGE_RAW" << endl;',
      "I=ideal(P,Pu,PA,PB,PY,PZ);",
    ]
    if not args.raw_only:
        lines.append("scan({B,ell,Q4,PuuGate,Cgate,delta},g->I=saturate(I,g));")
    lines += [
      '<< "FINAL_DIM=" << dim I << ",FINAL_DEG=" << degree I << endl;',
      "exit 0;",
    ]
    suffix = "raw" if args.raw_only else "saturation"
    path=HERE/f"A{args.A}_symbolic_u_{suffix}.m2"; path.write_text("\n".join(lines)+"\n")
    print(path)

if __name__=="__main__": main()
