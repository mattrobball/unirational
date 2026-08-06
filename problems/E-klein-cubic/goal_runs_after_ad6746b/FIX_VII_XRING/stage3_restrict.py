"""Stage 3: restrict covariants to the Hessian curve C; TRUE ideal multiplicities."""
import json, os, re, subprocess, sys
import numpy as np
from lib_xring import *

HERE = os.path.dirname(os.path.abspath(__file__))

BOUND_MAP = [0, 0, 0, 0, 0, 2, 2, 4, 5, 8, 11, 14]     # d = 1..12
BOUND_POLAR = [0, 0, 0, 1, 1, 1, 3, 3, 5, 8, 10, 14]
SURJ_D = [3, 4, 5, 6]


def parse_ic(path):
    info, gens = {}, []
    for line in open(path):
        line = line.rstrip("\n")
        if line.startswith("gen "):
            gens.append(line[4:])
        elif line.startswith("HF "):
            _, d, v = line.split()
            info.setdefault("HF", {})[int(d)] = int(v)
        elif line.startswith("Hpoly "):
            info["H"] = line[6:]
        elif line and line != "END":
            k, v = line.split(" ", 1)
            info[k] = v.strip()
    info["gens"] = gens
    return info


def poly_m2(vec, d, p):
    """coefficient vector over the degree-d monomial list -> M2 source string."""
    mons, _ = monomials(d)
    terms = []
    for i, c in enumerate(vec):
        c = int(c) % p
        if not c:
            continue
        s = str(c)
        for k, e in enumerate(mons[i]):
            if e:
                s += "*x%d" % k + ("^%d" % e if e > 1 else "")
        terms.append(s)
    return "+".join(terms) if terms else "0_R"


def build_m2(p, bases, dmax=12):
    L = ["pp = %d;" % p,
         "kk = ZZ/pp;",
         "R = kk[x0,x1,x2,x3,x4];",
         "F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0;",
         "Hess = diff(transpose vars R, diff(vars R, F));",
         "H = det Hess;",
         "IC = saturate(ideal(H) + ideal jacobian ideal H);",
         "GB = gb IC;",
         "out = openOut OUTFILE;",
         "cvec = (f, mm) -> flatten entries lift(last coefficients("
         "matrix{{f}}, Monomials => mm), kk);",
         ]
    for kind in ("map", "polar"):
        for d in range(1, dmax + 1):
            B = bases["%s_%d" % (kind, d)]
            if len(B) == 0:
                L.append('out << "RANK %s %d 0 0" << endl;' % (kind, d))
                continue
            L.append("mm%d = basis(%d, R);" % (d, d))
            rows = []
            for t, C in enumerate(B):
                comps = ", ".join(poly_m2(C[j], d, p) for j in range(5))
                rows.append("{%s}" % comps)
            L.append("covs = {%s};" % ", ".join(rows))
            L.append("rws = for T in covs list flatten for j from 0 to 4 list "
                     "cvec((T#j) %% GB, mm%d);" % d)
            L.append("MM = matrix(kk, rws);")
            L.append('out << "RANK %s %d " << (#covs) << " " << (rank MM) << endl;'
                     % (kind, d))
    L.append('out << "END" << endl;')
    L.append("close out;")
    L.append("exit 0")
    return "\n".join(L)


def run(p, tag, dmax=12):
    print("=== Stage 3, p=%d ===" % p, flush=True)
    import run_m2
    icpath = run_m2.run(p)
    info = parse_ic(icpath)
    hp_ok = info["hilbPoly"].replace(" ", "") in ("20*i-25", "-25+20*i")
    ok = (info["dimProj"] == "1" and info["degree"] == "20" and hp_ok)
    check("IC_degree_20" + tag, ok, "dimProj=%s degree=%s HP=%s ngens=%s(deg 4)"
          % (info["dimProj"], info["degree"], info["hilbPoly"], info["ngens"]))
    print("  HF: %s" % {d: info["HF"][d] for d in range(1, 13)}, flush=True)

    bases = dict(np.load(os.path.join(HERE, "payload", "cov_bases_p%d.npz" % p)))
    src = build_m2(p, bases, dmax)
    outfile = os.path.join(HERE, "results", "restrict_p%d.txt" % p)
    src = src.replace("OUTFILE", '"%s"' % outfile)
    os.makedirs(os.path.join(HERE, "tmp"), exist_ok=True)
    script = os.path.join(HERE, "tmp", "restrict%d.m2" % p)
    open(script, "w").write(src)
    r = subprocess.run(["M2", "--script", script], capture_output=True, text=True)
    if r.returncode != 0:
        print(r.stdout[-3000:]); print(r.stderr[-3000:])
        raise SystemExit("M2 restriction failed")

    ranks = {}
    for line in open(outfile):
        if line.startswith("RANK "):
            _, kind, d, dim, rk = line.split()
            ranks[(kind, int(d))] = (int(dim), int(rk))

    table = {"map": [], "polar": []}
    for kind in ("map", "polar"):
        for d in range(1, dmax + 1):
            dim, rk = ranks[(kind, d)]
            table[kind].append({"d": d, "dim": dim, "rank": rk, "ideal_mult": dim - rk})
    print("  d : map(dim,rank,ideal) | polar(dim,rank,ideal)", flush=True)
    for d in range(1, dmax + 1):
        m, q = table["map"][d - 1], table["polar"][d - 1]
        print("  %2d: (%2d,%2d,%2d)          | (%2d,%2d,%2d)"
              % (d, m["dim"], m["rank"], m["ideal_mult"],
                 q["dim"], q["rank"], q["ideal_mult"]), flush=True)

    bad = []
    for d in range(1, dmax + 1):
        if table["map"][d - 1]["ideal_mult"] < BOUND_MAP[d - 1]:
            bad.append(("map", d, table["map"][d - 1]["ideal_mult"], BOUND_MAP[d - 1]))
        if table["polar"][d - 1]["ideal_mult"] < BOUND_POLAR[d - 1]:
            bad.append(("polar", d, table["polar"][d - 1]["ideal_mult"], BOUND_POLAR[d - 1]))
    check("ideal_table_consistent" + tag, not bad, "violations=%s" % bad)

    bad2 = []
    for d in SURJ_D:
        if table["map"][d - 1]["ideal_mult"] != BOUND_MAP[d - 1]:
            bad2.append(("map", d, table["map"][d - 1]["ideal_mult"], BOUND_MAP[d - 1]))
        if table["polar"][d - 1]["ideal_mult"] != BOUND_POLAR[d - 1]:
            bad2.append(("polar", d, table["polar"][d - 1]["ideal_mult"], BOUND_POLAR[d - 1]))
    check("surjectivity_where_HF_says" + tag, not bad2, "mismatches=%s" % bad2)

    with open(os.path.join(HERE, "payload", "ideal_table_p%d.json" % p), "w") as f:
        json.dump({"p": p, "HF_C": {str(d): info["HF"][d] for d in range(0, 15)},
                   "table": table, "bound_map": BOUND_MAP, "bound_polar": BOUND_POLAR},
                  f, indent=1)
    return table


if __name__ == "__main__":
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 397
    tag = sys.argv[2] if len(sys.argv) > 2 else ""
    run(p, tag)
