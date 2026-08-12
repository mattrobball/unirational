#!/usr/bin/env python3
"""Collect F_{p^2}-points of C via hyperplane sections; rank the 37-cell."""
from __future__ import annotations

import os
import random
import subprocess
import sys
import time

import numpy as np

import paths
import fp2
import hesslib as H
import slicelib as SL

RES = paths.RES
TMP = paths.TMP


def run_hyper(p, L1, tag):
    src = open(os.path.join(os.path.dirname(__file__), "hyper_pts.m2")).read()
    outf = os.path.join(RES, "hyper_%s.txt" % tag)
    src = (src.replace("PPP", str(p)).replace("LFORM1", L1)
           .replace("OUTFILE", '"%s"' % outf))
    sc = os.path.join(TMP, "hyper_%s.m2" % tag)
    open(sc, "w").write(src)
    r = subprocess.run(["M2", "--script", sc], capture_output=True, text=True)
    return {"ok": r.returncode == 0, "path": outf, "rc": r.returncode}


def parse_linear_pts(path, p, st):
    pts = []
    cur = {}
    for line in open(path):
        if line.startswith("comp dim="):
            if cur and len(cur) >= 3:
                pts.append(cur)
            cur = {}
        elif line.startswith("gen "):
            body = line[4:].strip()
            if not body.startswith("y"):
                continue
            i = int(body[1])
            rest = body[2:]
            if rest.startswith("+"):
                rest = rest[1:]
            if rest.endswith("*y4"):
                rest = rest[:-3]
            elif rest.endswith("y4"):
                rest = rest[:-2]
                if rest in ("", "+"):
                    rest = "1"
                elif rest == "-":
                    rest = "-1"
            if rest.startswith("(") and rest.endswith(")"):
                rest = rest[1:-1]
            if not rest:
                rest = "1"
            cur[i] = rest
    if cur and len(cur) >= 3:
        pts.append(cur)
    out = []
    for c in pts:
        coords = []
        for i in range(5):
            if i in c:
                coef = fp2.parse_aa_coeff(c[i], p)
                coords.append(((-coef[0]) % p, (-coef[1]) % p))
            else:
                coords.append((1, 0))
        try:
            q = fp2.normalize_pt(coords, p, st)
        except Exception:
            continue
        if fp2.on_C_fp2(q, p, st):
            out.append(q)
    return out


def pt_key(q, p):
    return tuple((int(a[0]) % p, int(a[1]) % p) for a in q)


def minpoly_st(p):
    """Ask M2 for aa^2 = s*aa + t."""
    sc = os.path.join(TMP, "mp%d.m2" % p)
    outf = os.path.join(RES, "minpoly_p%d.txt" % p)
    open(sc, "w").write(
        'kk = GF(%d^2, Variable => aa);\n'
        'out = openOut "%s";\n'
        'out << "aa2 " << toString(aa^2) << endl;\n'
        'out << "END" << endl; close out; exit 0\n' % (p, outf)
    )
    subprocess.run(["M2", "--script", sc], check=True, capture_output=True)
    # aa^2 = s*aa + t   printed like "5*aa-3" or "5*aa+328"
    expr = None
    for line in open(outf):
        if line.startswith("aa2 "):
            expr = line[4:].strip()
    if not expr:
        raise RuntimeError("no aa2")
    coef = fp2.parse_aa_coeff(expr, p)
    # coef is (t, s) meaning t + s*aa
    return (coef[1], coef[0])


def collect_and_rank(p, n_hyper=8, seed=20260812):
    t0 = time.time()
    st = minpoly_st(p)
    print("p=%d minpoly aa^2 = %d*aa + %d" % (p, st[0], st[1]), flush=True)
    fr = SL.build_frame(p, verbose=False)
    A = np.load(os.path.join(paths.PAIR_RES, "layer0_A_p331.npy"))
    C = np.load(os.path.join(paths.PAIR_RES, "layer0_C_p331.npy"))
    NUL = np.load(os.path.join(paths.PAIR_RES, "layer0_null_p%d.npy" % p)) % p
    CELL = np.load(os.path.join(paths.SIEVE_RES, "cell37_p%d.npy" % p)) % p
    B = (CELL @ NUL) % p

    rng = random.Random(seed + p)
    seen = set()
    pts = []
    hyper_meta = []
    for i in range(n_hyper):
        c = [rng.randrange(1, p) for _ in range(5)]
        L1 = "+".join("%d*x%d" % (c[j], j) for j in range(5))
        tag = "p%d_%d" % (p, i)
        rec = run_hyper(p, L1, tag)
        if not rec.get("ok") and "path" not in rec:
            # run_hyper returns path on success via ok True
            pass
        path = os.path.join(RES, "hyper_%s.txt" % tag)
        if not os.path.exists(path):
            hyper_meta.append({"i": i, "ok": False})
            continue
        got = parse_linear_pts(path, p, st)
        new = 0
        for q in got:
            k = pt_key(q, p)
            if k not in seen:
                seen.add(k)
                pts.append(q)
                new += 1
        hyper_meta.append({"i": i, "n_on_C": len(got), "n_new": new})
        print("  hyper %d: %d on C, %d new (total %d)"
              % (i, len(got), new, len(pts)), flush=True)

    # plus sextet values (should be 0)
    sextet_path = os.path.join(RES, "sextet_p%d.txt" % p)
    n_sextet = 0
    if os.path.exists(sextet_path):
        try:
            sx = fp2.parse_sextet_points(sextet_path, p)
            good = []
            for q in sx:
                qn = fp2.normalize_pt(q, p, st)
                if fp2.on_C_fp2(qn, p, st):
                    good.append(qn)
            n_sextet = len(good)
            for q in good:
                k = pt_key(q, p)
                if k not in seen:
                    seen.add(k)
                    pts.append(q)
        except Exception as e:
            print("  sextet parse skipped: %s" % e, flush=True)

    print("eval %d Fp2-points..." % len(pts), flush=True)
    if not pts:
        return {"p": p, "error": "no points"}
    V = fp2.eval_seeds_fp2(fr, A, C, pts, p, st)
    val = np.tensordot(B, V, axes=(1, 0)) % p
    M = val.reshape(paths.DIM37, -1) % p
    rk = int(SL.rref_rank(M, p))
    ker = paths.DIM37 - rk
    sat = (rk == paths.ONCURVE_WB[35])
    print("  value rank %d  kernel %d  sat=%s  (%.1fs)"
          % (rk, ker, sat, time.time() - t0), flush=True)
    K = SL.nullspace(M, p) % p
    np.save(os.path.join(RES, "restr_fp2_p%d.npy" % p), M)
    np.save(os.path.join(RES, "kernel_p%d.npy" % p), K)
    return {
        "p": p,
        "st": list(st),
        "n_hyper": n_hyper,
        "hyper": hyper_meta,
        "n_fp2_points": len(pts),
        "n_sextet_included": n_sextet,
        "rank_values": rk,
        "kernel_dim": ker,
        "oncurve_Wb_bound": paths.ONCURVE_WB[35],
        "saturated_at_character_bound": sat,
        "seconds": round(time.time() - t0, 2),
    }


if __name__ == "__main__":
    ps = [int(a) for a in sys.argv[1:]] or [331]
    for p in ps:
        collect_and_rank(p)
