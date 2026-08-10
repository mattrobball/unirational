#!/usr/bin/env python3
"""Independent point counts, straight off the defining equations.

  * #C_sigma(F_p): enumerate P^5(F_p) and impose the 15 Plucker quadrics
    restricted to the ORIGINAL (un-adapted) basis of M_+.  This uses none of
    the tau-eigenbasis / twisted-cubic / branch-quartic machinery, so it is a
    genuinely independent check on the double-cover model c^2 = R(s,t).
    Feasible for p = 23 only (p^5 points).
  * #E_sigma(F_p): enumerate P^2(F_p) and impose the Pfaffian cubic Pf6
    restricted to P(W^+).  Independent of the Weierstrass reduction.
    Cheap at every prime.

Usage: python3 bruteforce.py <p> [<p> ...]
Reads results/model_<p>.json (produced by sextic.py).
"""
import sys, os, json
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, '..')

def count_quadrics(quads, mons, nvar, p, cap=None):
    """#{x in P^{nvar-1}(F_p) : all quadrics vanish}."""
    if cap is not None and p**(nvar-1) > cap:
        return None
    tot = 0
    for lead in range(nvar):
        nfree = nvar - 1 - lead
        vec = min(nfree, 3); outer = nfree - vec
        if vec > 0:
            grids = [g.reshape(-1) for g in np.indices((p,)*vec)]
            N = grids[0].size
        else:
            grids = []; N = 1
        for idx in range(p**outer):
            cols = [np.zeros(N, dtype=np.int64) for _ in range(lead)]
            cols.append(np.ones(N, dtype=np.int64))
            t = idx
            for _ in range(outer):
                cols.append(np.full(N, t % p, dtype=np.int64)); t //= p
            cols.extend(g.astype(np.int64) for g in grids)
            mask = np.ones(N, dtype=bool)
            for q in quads:
                val = np.zeros(N, dtype=np.int64)
                for k, c in enumerate(q):
                    if c % p == 0: continue
                    i, j = mons[k]
                    val = (val + c * cols[i] * cols[j]) % p
                mask &= (val % p == 0)
                if not mask.any(): break
            tot += int(mask.sum())
    return tot

def count_cubic(terms, p):
    """#{(a:b:c) in P^2(F_p) : F = 0}, terms = {(e0,e1,e2): coeff}."""
    tot = 0
    pts = [(1, b, c) for b in range(p) for c in range(p)] + \
          [(0, 1, c) for c in range(p)] + [(0, 0, 1)]
    for P in pts:
        v = 0
        for e, cf in terms.items():
            m = cf
            for k in range(3): m = m * pow(P[k], e[k], p)
            v = (v + m) % p
        if v % p == 0: tot += 1
    return tot

ok = True
for arg in sys.argv[1:]:
    p = int(arg)
    with open(f"{OUT}/results/model_{p}.json") as f: mdl = json.load(f)
    mons = [tuple(m) for m in mdl["monomials"]]
    quads = [[int(x) % p for x in q] for q in mdl["plucker_quadrics_Mplus"]]
    cub = {tuple(int(t) for t in k.split(",")): int(v) % p
           for k, v in mdl["plane_cubic_Ebasis"].items()}
    nE = count_cubic(cub, p)
    nE_model = mdl["counts"]["nE"]
    r1 = (nE == nE_model)
    print(f"CHECK brute_E_{p} {'PASS' if r1 else 'FAIL'} "
          f"#E_sigma(F_{p}) from the Pfaffian cubic in P^2 = {nE}, model says {nE_model}")
    ok &= r1
    nC = count_quadrics(quads, mons, 6, p, cap=10**7)
    nC_model = mdl["counts"]["nC"]
    if nC is None:
        print(f"CHECK brute_C_{p} SKIP p^5 = {p**5} points is too large for the P^5 sweep")
    else:
        r2 = (nC == nC_model)
        print(f"CHECK brute_C_{p} {'PASS' if r2 else 'FAIL'} "
              f"#C_sigma(F_{p}) from the 15 Plucker quadrics in P^5 = {nC}, model says {nC_model}")
        ok &= r2
print("ALLGREEN" if ok else "FAILURES PRESENT")
