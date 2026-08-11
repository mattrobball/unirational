"""Lever 1, part d: hand the higher-multiplicity landing questions to Macaulay2.

For a jet order mu, a jet space A' of dimension n with evaluation map ev of
rank 2, and a target point c = (s:t) on the eigenline, write

        Phi(a)  =  sum_i a_i P_i  +  s Q1  +  t Q2 ,     P_i a basis of ker ev,

so that ev(Phi(a)) = (s,t) is the wanted value for every a.  Then

     c is realised   <=>   the affine variety of the cubic system
                           F(Phi(a)) = 0  is NON-EMPTY over the algebraic
                           closure   <=>   the ideal is not the unit ideal.

That is a single `dim` call per case (dim = -1 exactly for the unit ideal), so
the decision is exact and needs no rationality assumption on a.
"""
import json
import os
import subprocess
import sys

from s3core import Model
from s3a4 import A4Point, equivariant_space, eval_phi, F_of_phi, coords_in, nullspace_rows
from s3lever1c import build, xpoints_on_line, lincomb, solve_lin, addv


def poly_in_a(m, mons, mu, P, Q, s, t, k):
    """F(sum a_i P_i + s Q1 + t Q2) as a dict:  t-monomial -> (dict a-monomial ->
    coefficient).  Built by exact multivariate interpolation is overkill; we
    build it directly by symbolic expansion in the a_i."""
    p = m.p
    nm = len(mons)
    # component polynomials: comp[i][t-monomial] = linear form in (1, a_1..a_k)
    base = addv(m, [(s, Q[0]), (t, Q[1])])
    comp = []
    for i in range(5):
        d = {}
        for ai, al in enumerate(mons):
            lin = [base[ai][i] % p] + [P[j][ai][i] % p for j in range(k)]
            if any(lin):
                d[al] = lin
        comp.append(d)

    def mul_lin(u, v):
        """product of two polynomials in a, given as coefficient dicts over
        a-monomials (tuples of exponents)."""
        out = {}
        for ka, va in u.items():
            for kb, vb in v.items():
                kk = tuple(x + y for x, y in zip(ka, kb))
                out[kk] = (out.get(kk, 0) + va * vb) % p
        return {a: b for a, b in out.items() if b % p}

    def as_poly(lin):
        d = {}
        if lin[0] % p:
            d[tuple([0] * k)] = lin[0] % p
        for j in range(k):
            if lin[j + 1] % p:
                e = [0] * k
                e[j] = 1
                d[tuple(e)] = lin[j + 1] % p
        return d

    tot = {}
    for i in range(5):
        A, B = comp[i], comp[(i + 1) % 5]
        for k1, l1 in A.items():
            P1 = as_poly(l1)
            for k2, l2 in A.items():
                P2 = mul_lin(P1, as_poly(l2))
                if not P2:
                    continue
                for k3, l3 in B.items():
                    P3 = mul_lin(P2, as_poly(l3))
                    if not P3:
                        continue
                    kk = tuple(a + b + c for a, b, c in zip(k1, k2, k3))
                    cur = tot.setdefault(kk, {})
                    for a, b in P3.items():
                        cur[a] = (cur.get(a, 0) + b) % p
    return {kk: {a: b for a, b in v.items() if b % p} for kk, v in tot.items()}


def emit(cases, path):
    lines = ["-- STAGE2_SECOND_ORDER : lever-1 landing decisions",
             "results = {};"]
    for n, c in enumerate(cases):
        k = c["k"]
        p = c["p"]
        vars_ = ",".join("a%d" % i for i in range(k))
        lines.append('R%d = GF(%d)[%s];' % (n, p, vars_))
        gens = []
        for polydict in c["polys"]:
            terms = []
            for mono, co in sorted(polydict.items()):
                fac = [str(co)]
                for i, e in enumerate(mono):
                    if e:
                        fac.append("a%d^%d" % (i, e))
                terms.append("*".join(fac))
            if terms:
                gens.append("(" + "+".join(terms) + ")")
        if not gens:
            lines.append('results = append(results, ("%s", "EMPTY-SYSTEM"));'
                         % c["tag"])
            continue
        lines.append("I%d = ideal(%s);" % (n, ",".join(gens)))
        lines.append('results = append(results, ("%s", toString dim I%d));'
                     % (c["tag"], n))
    lines.append('<< "BEGIN_RESULTS" << endl;')
    lines.append('scan(results, r -> << r#0 << " | " << r#1 << endl);')
    lines.append('<< "END_RESULTS" << endl;')
    open(path, "w").write("\n".join(lines) + "\n")


def collect():
    cases = []
    for p in (331, 661):
        m = Model(p)
        for which in (0, 1):
            for dmod3 in (0, 1, 2):
                for mu in (3, 4, 5):   # mu = 6 needs 10-variable Groebner: not decided (THEOREM.md Tier 3.1)
                    for tag_row in ("row_dim1", "row_dim0"):
                        got = build(m, which, dmod3, mu, True)
                        if got is None:
                            continue
                        ap, mons, Ap, ev, aq = got
                        b = (aq + (1 if tag_row == "row_dim1" else 2)) % 3
                        w = (dmod3 * aq + mu * ((b - aq) % 3)) % 3
                        if w == 0:
                            continue
                        pts, B = xpoints_on_line(m, ap, w)
                        c6 = coords_in(m, B, ap.C6pt[w])
                        E = []
                        for C in Ap:
                            v = ev(C, b)
                            E.append(coords_in(m, B, v)
                                     if any(x % p for x in v) else [0, 0])
                        rows = [[E[kk][j] for kk in range(len(Ap))] for j in range(2)]
                        R, piv = m.rref([list(r) for r in E if any(r)], 2)
                        if len(R) < 2:
                            continue
                        K = nullspace_rows(m, rows, len(Ap))
                        P = [lincomb(m, Ap, kk) for kk in K]
                        Q = [lincomb(m, Ap, solve_lin(m, rows, list(tg)))
                             for tg in ((1, 0), (0, 1))]
                        for (s, t) in pts:
                            isc6 = (s * c6[1] - t * c6[0]) % p == 0
                            tot = poly_in_a(m, mons, mu, P, Q, s, t, len(P))
                            polys = list(tot.values())
                            cases.append({
                                "p": p, "k": len(P),
                                "tag": "p=%d|%s|d%d|mu=%d|%s|w=%d|%s"
                                       % (p, "omega" if aq == 1 else "omega2",
                                          dmod3, mu, tag_row, w,
                                          "C6pt" if isc6 else "exactC3"),
                                "polys": polys})
    return cases


def main():
    cases = collect()
    print("collected %d M2 cases" % len(cases))
    emit(cases, "scripts/lever1_landing.m2")
    out = subprocess.run(["M2", "--script", "scripts/lever1_landing.m2"],
                         capture_output=True, text=True, timeout=3600)
    txt = out.stdout
    open("results/m2_lever1.txt", "w").write(txt + "\n--- stderr ---\n" + out.stderr)
    res = {}
    inside = False
    for line in txt.splitlines():
        if line.strip() == "BEGIN_RESULTS":
            inside = True
            continue
        if line.strip() == "END_RESULTS":
            inside = False
            continue
        if inside and "|" in line:
            tag, val = line.rsplit("|", 1)
            res[tag.strip()] = val.strip()
    json.dump(res, open("results/lever1_m2.json", "w"), indent=1, sort_keys=True)
    nonempty = {k: v for k, v in res.items() if v not in ("-1",)}
    print("cases with a landing jet (dim >= 0): %d / %d" % (len(nonempty), len(res)))
    for k in sorted(res):
        print("  %-58s dim = %s  -> %s" % (k, res[k],
                                           "REALISED" if res[k] != "-1"
                                           else "NOT realised"))
    print("S3_M2_OK")


if __name__ == "__main__":
    main()
