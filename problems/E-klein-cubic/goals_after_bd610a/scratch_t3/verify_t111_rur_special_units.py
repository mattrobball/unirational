#!/usr/bin/env python3
"""Exact special RUR unit and Hessian checks at (A,u)=(17,1)."""

from __future__ import annotations

import importlib.util
import itertools
import hashlib
import json
from pathlib import Path

import sympy as sp

ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
WORK = ROOT / "goals_after_bd610a"
SRC = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
FACTORS = ROOT / "certificates/fold_normalization_t2r/saturation_factors"
A0, U0 = 17, 1
Z = sp.symbols("Z")
OUTPUT = WORK / "scratch_t3/verify_t111_rur_special_units_result.json"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_source():
    spec = importlib.util.spec_from_file_location("src", SRC)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def rur(label):
    coeffs = {}
    with (WORK / f"scratch_t3/generic_singular_rur_{label}.tsv").open() as stream:
        next(stream)
        for line in stream:
            a, u, z, c = map(int, line.split())
            coeffs[z] = coeffs.get(z, 0) + c*A0**a*U0**u
    return sp.Poly(sum(c*Z**z for z,c in coeffs.items()), Z, domain=sp.QQ)


def differentiated(terms, indices=()):
    ans=[]
    for e0,c0 in terms:
        e=list(e0);c=c0
        for i in indices:
            if not e[i]: c=0;break
            c*=e[i];e[i]-=1
        if c: ans.append((tuple(e),c))
    return ans


def eval_terms(terms, B, Y, q):
    bp=[sp.Poly(1,Z,domain=sp.QQ)]
    yp=[sp.Poly(1,Z,domain=sp.QQ)]
    maxb=max(e[1] for e,c in terms); maxy=max(e[2] for e,c in terms)
    for _ in range(maxb): bp.append((bp[-1]*B).rem(q))
    for _ in range(maxy): yp.append((yp[-1]*Y).rem(q))
    r=sp.Poly(0,Z,domain=sp.QQ)
    for (a,b,y,z,u),c in terms:
        term=(bp[b]*yp[y]).rem(q)
        term=(term*sp.Poly(Z**z,Z,domain=sp.QQ)).rem(q)
        r=(r+term.mul_ground(c*A0**a*U0**u)).rem(q)
    return r


def gate_terms(src, filename, with_u=False):
    rows=src.load_tsv(FACTORS/filename,with_u=with_u)
    if with_u: return rows
    return [((a,b,y,z,0),c) for (a,b,y,z),c in rows]


def det(matrix, q):
    n=len(matrix);ans=sp.Poly(0,Z,domain=sp.QQ)
    for p in itertools.permutations(range(n)):
        inv=sum(p[i]>p[j] for i in range(n) for j in range(i+1,n))
        term=sp.Poly((-1)**inv,Z,domain=sp.QQ)
        for i,j in enumerate(p): term=(term*matrix[i][j]).rem(q)
        ans=(ans+term).rem(q)
    return ans


def main():
    src=load_source(); primitive=src.load_P()
    qraw=rur("QZ"); _,q=qraw.primitive()
    nb=rur("NB");ny=rur("NY")
    inv=sp.invert(qraw.diff(),q)
    B=(nb*inv).rem(q);Y=(ny*inv).rem(q)
    assert sp.gcd(q,q.diff()).degree()==0
    _, factors = sp.factor_list(q)
    assert [(f.degree(), e) for f, e in factors] == [(6, 1)]
    hspec={
      "BB":(1,1),"BY":(1,2),"BZ":(1,3),"YY":(2,2),"YZ":(2,3),"ZZ":(3,3),
      "uB":(4,1),"uY":(4,2),"uZ":(4,3),
    }
    h={k:eval_terms(differentiated(primitive,v),B,Y,q) for k,v in hspec.items()}
    chart=[[h["BB"],h["BY"],h["BZ"]],[h["BY"],h["YY"],h["YZ"]],[h["BZ"],h["YZ"],h["ZZ"]]]
    bordered=[chart[0]+[h["uB"]],chart[1]+[h["uY"]],chart[2]+[h["uZ"]],[h["uB"],h["uY"],h["uZ"],sp.Poly(0,Z,domain=sp.QQ)]]
    checks={
      "Bgate": B,
      "ell": eval_terms(gate_terms(src,"ell_lc_u.tsv"),B,Y,q),
      "Q4": eval_terms(gate_terms(src,"G_factor_Q4.tsv"),B,Y,q),
      "PuuGate": eval_terms(gate_terms(src,"P_uu.tsv",True),B,Y,q),
      "Cgate": eval_terms(gate_terms(src,"C_content.tsv"),B,Y,q),
      "delta": eval_terms(gate_terms(src,"delta_Cramer.tsv",True),B,Y,q),
      "chart_hessian": det(chart,q),
      "bordered_hessian": det(bordered,q),
      "qprime": q.diff().rem(q),
    }
    result_checks = {}
    for name,value in checks.items():
        g=sp.gcd(value,q)
        print(name,"remainder_degree",value.degree(),"gcd_degree",g.degree(),"nonzero",not value.is_zero)
        assert not value.is_zero and g.degree()==0
        result_checks[name] = {
            "remainder_degree": int(value.degree()),
            "gcd_with_q_degree": int(g.degree()),
            "unit": True,
        }
    report = {
        "schema": "klein-t111-rur-special-unit-witness-v1",
        "status": "PASS",
        "specialization": {"A": A0, "u": U0},
        "q_factor_degrees_and_multiplicities": [[6, 1]],
        "checks": result_checks,
        "input_sha256": {
            label: sha(WORK / f"scratch_t3/generic_singular_rur_{label}.tsv")
            for label in ("QZ", "NB", "NY")
        },
        "proves": [
            "all required gate, q-prime, and Hessian classes are nonzero generically on the irreducible degree-six RUR component",
            "at the exact witness (17,1), every listed class is a unit in the specialized degree-six field",
        ],
        "does_not_prove": [
            "by itself, equality of the RUR component with the full gate-localized critical ideal",
        ],
    }
    OUTPUT.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print("SPECIAL_RUR_ALL_UNITS_PASS")


if __name__=="__main__": main()
