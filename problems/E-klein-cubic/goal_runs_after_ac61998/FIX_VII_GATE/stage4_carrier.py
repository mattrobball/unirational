"""Stage 4: the Hessian-carrier cut.

I_C = saturate((H) + jacobian(H)), H = det Hess F  (dim 1, degree 20,
HP 20i - 25, HF(34) = 655).  For each profile-basis tuple T we reduce all five
components modulo a Groebner basis of I_C; n2 = n1 - rank of the resulting
linear map.  A zero normal form is exact ideal membership, so n2 is exact at
each prime (no sampling anywhere in this stage).
"""
import json
import os
import re
import subprocess
import sys
import time

import numpy as np

from gatelib import check, monomials, nmon, poly_m2, rank_mod

HERE = os.path.dirname(os.path.abspath(__file__))
DTOP = 34
INT = re.compile(r"-?\d+")


def build_ic(p):
    src = open(os.path.join(HERE, "hessian_curve.m2")).read()
    outf = os.path.join(HERE, "results", "IC_p%d.txt" % p)
    if not os.path.exists(outf):
        sc = os.path.join(HERE, "tmp", "hc%d.m2" % p)
        open(sc, "w").write(src.replace("PPP", str(p))
                            .replace("OUTFILE", '"%s"' % outf))
        r = subprocess.run(["M2", "--script", sc], capture_output=True,
                           text=True)
        if r.returncode:
            print(r.stdout[-3000:], r.stderr[-3000:])
            raise SystemExit("M2 I_C failed at p=%d" % p)
    info, gens, HF = {}, [], {}
    for line in open(outf):
        line = line.rstrip("\n")
        if line.startswith("gen "):
            gens.append(line[4:])
        elif line.startswith("HF "):
            _, d, v = line.split()
            HF[int(d)] = int(v)
        elif line.startswith("Hpoly "):
            info["H"] = line[6:]
        elif line and line != "END":
            k, v = line.split(" ", 1)
            info[k] = v.strip()
    info["gens"], info["HF"] = gens, HF
    return info


def m2_script(p, T, outfile):
    L = ["pp = %d;" % p,
         "kk = ZZ/pp;",
         "R = kk[x0,x1,x2,x3,x4];",
         "F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0;",
         "Hess = diff(transpose vars R, diff(vars R, F));",
         "H = det Hess;",
         "IC = saturate(ideal(H) + ideal jacobian ideal H);",
         "GB = gb IC;",
         "out = openOut %s;" % ('"%s"' % outfile),
         "emit = (tag, j, i, f) -> (",
         "  nf = f % GB;",
         '  out << "NFZ " << tag << " " << j << " " << i << " " '
         '<< (if nf == 0 then 1 else 0) << endl;',
         "  if nf != 0 then (",
         "    (mm, cc) = coefficients nf;",
         "    for k from 0 to numColumns mm - 1 do (",
         "      e = (exponents(mm_(0,k)))#0;",
         '      out << "NFT " << tag << " " << j << " " << i << " " << e#0 '
         '<< " " << e#1 << " " << e#2 << " " << e#3 << " " << e#4 << " " '
         "<< toString(cc_(k,0)) << endl;));",
         "  );",
         "-- control: the sealed degree-6 covariant H*x lies in I_C",
         "for i from 0 to 4 do emit(\"CTRL\", 0, i, H * R_i);",
         ]
    for j in range(T.shape[0]):
        for i in range(5):
            L.append('emit("NF", %d, %d, %s);' % (j, i, poly_m2(T[j, i],
                                                                DTOP, p)))
    L.append('out << "END" << endl;')
    L.append("close out;")
    L.append("exit 0")
    return "\n".join(L)


def parse_nf(path, n1):
    """-> (zero flags, dict (tag,j,i) -> {exponent tuple: coef}, ctrl flags)"""
    zero, terms = {}, {}
    for line in open(path):
        if line.startswith("NFZ "):
            _, tag, j, i, z = line.split()
            zero[(tag, int(j), int(i))] = bool(int(z))
        elif line.startswith("NFT "):
            f = line.split()
            tag, j, i = f[1], int(f[2]), int(f[3])
            e = tuple(int(x) for x in f[4:9])
            c = int(f[9])
            terms.setdefault((tag, j, i), {})[e] = c
    return zero, terms


def run(p, tag=""):
    t0 = time.time()
    log = lambda *a: print(*a, flush=True)
    log("=== Stage 4, p=%d ===" % p)
    info = build_ic(p)
    hp_ok = info["hilbPoly"].replace(" ", "") in ("20*i-25", "-25+20*i")
    ok = (info["dimProj"] == "1" and info["degree"] == "20" and hp_ok and
          info["HF"][DTOP] == 655 and info["ngens"] == "15")
    check("IC_ok" + tag, ok,
          "dimProj=%s degree=%s HP=%s ngens=%s(all deg 4) HF(34)=%d"
          % (info["dimProj"], info["degree"], info["hilbPoly"],
             info["ngens"], info["HF"][DTOP]))

    T = np.load(os.path.join(HERE, "payload", "profile_basis_p%d" % p,
                             "coeffs.npz"))["T"].astype(np.int64)
    n1 = T.shape[0]
    src = m2_script(p, T, os.path.join(HERE, "results", "NF_p%d.txt" % p))
    sc = os.path.join(HERE, "tmp", "carrier%d.m2" % p)
    open(sc, "w").write(src)
    log("  M2 source %.1f MB; reducing %d degree-34 polynomials ..."
        % (len(src) / 1e6, 5 * n1))
    r = subprocess.run(["M2", "--script", sc], capture_output=True, text=True)
    if r.returncode:
        print(r.stdout[-3000:], r.stderr[-3000:])
        raise SystemExit("M2 carrier reduction failed at p=%d" % p)
    log("  M2 done (%.0fs)" % (time.time() - t0))

    zero, terms = parse_nf(os.path.join(HERE, "results", "NF_p%d.txt" % p), n1)
    ctrl = [zero[("CTRL", 0, i)] for i in range(5)]
    check("carrier_control_Hx_in_IC" + tag, all(ctrl),
          "H*x_i reduces to 0 mod I_C for i=0..4: %s" % ctrl)

    support = sorted({e for (tg, j, i), d in terms.items() if tg == "NF"
                      for e in d})
    sidx = {e: k for k, e in enumerate(support)}
    Mrows = np.zeros((n1, 5 * max(1, len(support))), dtype=np.int64)
    for (tg, j, i), d in terms.items():
        if tg != "NF":
            continue
        for e, c in d.items():
            Mrows[j, i * len(support) + sidx[e]] = c % p
    rk = rank_mod(Mrows, p) if len(support) else 0
    n2 = n1 - rk
    allzero = sum(1 for j in range(n1) for i in range(5)
                  if zero[("NF", j, i)])
    log("  NF support %d monomials; rank %d; n1 %d -> n2 %d "
        "(%d/%d components already zero)"
        % (len(support), rk, n1, n2, allzero, 5 * n1))
    check("carrier_cut" + tag, True,
          "n1=%d rank(restriction to C)=%d  =>  n2=%d" % (n1, rk, n2))

    out = {"p": p, "n1": n1, "rank": int(rk), "n2": int(n2),
           "nf_support": len(support), "components_zero": allzero,
           "IC": {"dimProj": info["dimProj"], "degree": info["degree"],
                  "hilbPoly": info["hilbPoly"], "ngens": info["ngens"],
                  "HF34": info["HF"][DTOP]},
           "seconds": round(time.time() - t0, 1)}
    with open(os.path.join(HERE, "payload", "carrier_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=1)
    log("  Stage 4 total %.0fs" % (time.time() - t0))
    return out


if __name__ == "__main__":
    res = {}
    for pp in [int(a) for a in (sys.argv[1:] or ["67", "199"])]:
        res[pp] = run(pp, tag="_p%d" % pp)
    if len(res) > 1:
        vals = {p: r["n2"] for p, r in res.items()}
        check("carrier_cut_both_primes", len(set(vals.values())) == 1,
              "n2 = %s" % vals)
        with open(os.path.join(HERE, "payload", "carrier_summary.json"),
                  "w") as f:
            json.dump({str(k): v for k, v in res.items()}, f, indent=1)
