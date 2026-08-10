"""Stage 1: build the model, emit ideal + G-action, run the python-side CHECKs."""
import json
import os
import sys
from collections import Counter

import fp
import v14lib as V

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
CHK = os.path.join(ROOT, "results", "checks.log")


def check(name, ok, detail=""):
    line = f"CHECK {name} {'PASS' if ok else 'FAIL'} {detail}".rstrip()
    with open(CHK, "a") as f:
        f.write(line + "\n")
    print(line, flush=True)
    return ok


def pfaffian6(Lam, p):
    """Pfaffian of a 6x6 skew matrix over F_p (entries may be poly dicts if
    a callable ring is used; here plain field elements)."""
    # perfect matchings of {0..5}
    tot = 0
    for m in MATCHINGS6:
        sgn, prs = m
        t = sgn
        for (i, j) in prs:
            t = t * Lam[i][j] % p
        tot = (tot + t) % p
    return tot % p


def _matchings(n):
    out = []

    def rec(rem, prs):
        if not rem:
            perm = [x for pr in prs for x in pr]
            # sign of the permutation
            s, seen = 1, list(perm)
            for i in range(len(seen)):
                for j in range(i + 1, len(seen)):
                    if seen[i] > seen[j]:
                        s = -s
            out.append((s, list(prs)))
            return
        a = rem[0]
        for k in range(1, len(rem)):
            b = rem[k]
            rec(rem[1:k] + rem[k + 1:], prs + [(a, b)])
    rec(list(range(n)), [])
    return out


MATCHINGS6 = _matchings(6)

# --- the complement/sign table for Lambda^4 U* -> Lambda^2 U
COMP = {}
for quad in V.QUADS:
    comp = tuple(x for x in range(6) if x not in quad)
    perm = list(quad) + list(comp)
    s = 1
    for i in range(6):
        for j in range(i + 1, 6):
            if perm[i] > perm[j]:
                s = -s
    COMP[quad] = (comp, s)


def build(p, tag):
    m = V.Model(p)
    g15 = m.group15()
    out = {}
    check(f"group_order_SL_{tag}", len(V.closure([m.A6, m.B6], p, 2000)) == 1320,
          "|<A,B>| on U = 1320")
    check(f"group_order_PSL_{tag}", len(g15) == 660, "|G| on Lambda^2 U = 660")
    check(f"isotypic_split_{tag}", len(m.Mrows) == 10 and len(m.Nrows) == 5,
          "Lambda^2 U = 5 + 10'")

    # character of the 10-dim summand (identifies which 10)
    chi10, chi5 = {}, {}
    for X in g15.values():
        o = V.order_of(X, p)
        D = m.to10(X)
        E = m.to5(X)
        chi10.setdefault(o, set()).add(sum(D[i][i] for i in range(10)) % p)
        chi5.setdefault(o, set()).add(sum(E[i][i] for i in range(5)) % p)
    tr2 = chi10[2]
    check(f"tenprime_identified_{tag}", tr2 == {2 % p},
          f"chi_10(2A)={sorted(tr2)} (10' has +2; the other 10 has -2)")
    out["chi10"] = {k: sorted(v) for k, v in sorted(chi10.items())}
    out["chi5"] = {k: sorted(v) for k, v in sorted(chi5.items())}

    quads = m.quadrics()
    # linear independence of the 15 quadrics in S^2(M*) (55-dim)
    mono = sorted({k for q in quads for k in q})
    allm = [(a, b) for a in range(10) for b in range(a, 10)]
    midx = {k: i for i, k in enumerate(allm)}
    rows = [[q.get(k, 0) for k in allm] for q in quads]
    r = fp.rank(rows, p)
    check(f"quadrics_independent_{tag}", r == 15, f"rank {r}/15 in S^2 M* (dim 55)")

    # G-invariance of the ideal: quadrics pulled back by generators stay in span
    gens10 = [m.to10(g) for g in m.gens15]
    ok = True
    for D in gens10:
        # substitute y -> D y  (columns of D give new linear forms)
        newb = [[sum(m.Mrows[a][t] * D[a][i] for a in range(10)) % p for t in range(15)]
                for i in range(10)]
        q2 = m.quadrics(basis=newb)
        rows2 = rows + [[q.get(k, 0) for k in allm] for q in q2]
        ok = ok and fp.rank(rows2, p) == 15
    check(f"G_invariant_{tag}", ok, "660-action permutes the 15 Plucker quadrics")

    # Ann(M) = the 5-dim space of skew forms cutting P(M); Pfaffian cubic
    ann = fp.rowspace_basis(fp.nullspace(m.Mrows, p), p)
    check(f"annM_dim_{tag}", len(ann) == 5, "dim Ann(M) = 5")

    out.update(dict(p=p, weil=m.weil, Mrows=m.Mrows, Nrows=m.Nrows, Mpiv=m.Mpiv,
                    ann=ann, quads=[{f"{a},{b}": c for (a, b), c in q.items()} for q in quads],
                    gens10=gens10, gens15=m.gens15, A6=m.A6, B6=m.B6))
    return m, out, quads, ann


def emit_m2_stage1(p, quads, ann, path):
    names = [f"y{i}" for i in range(10)]
    qs = ",\n  ".join(V.quad_to_str(q, names) for q in quads)
    # cubics for the global smoothness certificate on P(Ann M) = P^4
    lines = [
        f"kk = ZZ/{p};",
        f"R = kk[{','.join(names)}];",
        f"I = ideal(\n  {qs});",
        'print("dim_affine_cone " | toString dim I);',
        'print("codim " | toString codim I);',
        'print("degree " | toString degree I);',
        'print("saturated " | toString (I == saturate I));',
        'print("primdec_count " | toString (# minimalPrimes I));',
        'print("hilbert " | toString ((hilbertPolynomial(I, Projective=>false))));',
    ]
    with open(path, "w") as f:
        f.write("\n".join(lines) + "\n")


def main():
    open(CHK, "a").close()
    payload = {}
    for p, tag in ((397, "p397"), (199, "p199")):
        m, out, quads, ann = build(p, tag)
        payload[tag] = out
        emit_m2_stage1(p, quads, ann, os.path.join(HERE, f"m2_stage1_{tag}.m2"))
        with open(os.path.join(ROOT, "payload", f"model_{tag}.json"), "w") as f:
            json.dump(out, f)
    print("stage1 build done")


if __name__ == "__main__":
    main()
