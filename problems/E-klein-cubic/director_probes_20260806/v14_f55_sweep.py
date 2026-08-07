#!/usr/bin/env python3
# Decide the pentagram inventory COMPLETELY: any C11-stable irreducible
# curve through the pair (y_2, y_6) spans a C11-stable subspace S =
# (sum of eigenlines) containing v_2, v_6.  Sweep all 2^8 such S,
# decompose V14 cap P(S), and test for a component of dim >= 1 (affine
# >= 2) containing BOTH points.  Writes one M2 script; parses verdict.
import sys, subprocess, os
from itertools import combinations
p = int(sys.argv[1]) if len(sys.argv) > 1 else 397
exec(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'v14_f55_weights.py')).read().split("# tangent cone")[0])
eig = {e: V[0] for e, V in wt.items() if len(V) == 1}
chars = sorted(eig.keys())          # the ten nonzero residues
others = [c for c in chars if c not in (2, 6)]
# wedge table W[g][d] as 15-vectors
W = {}
for g in chars:
    for d in chars:
        if (g, d) not in W and (d, g) not in W:
            W[(g, d)] = wprod(eig[g], eig[d])
def getW(g, d):
    return W[(g, d)] if (g, d) in W else W[(d, g)]
lines = []
m2 = [f"kk = ZZ/{p};"]
subsets = []
for r in range(9):
    for extra in combinations(others, r):
        S = [2, 6] + list(extra)
        subsets.append(sorted(S))
m2.append(f'verdicts = new MutableHashTable;')
for idx, S in enumerate(subsets):
    n = len(S)
    vs = ",".join(f"l{i}" for i in range(n))
    quads = []
    for K in range(15):
        terms = []
        for i in range(n):
            for j in range(i, n):
                cf = getW(S[i], S[j])[K] * (1 if i == j else 2) % p
                if cf: terms.append(f"{cf}*l{i}*l{j}")
        quads.append("+".join(terms) if terms else "0")
    i2, i6 = S.index(2), S.index(6)
    pt2 = ",".join("1" if i == i2 else "0" for i in range(n))
    pt6 = ",".join("1" if i == i6 else "0" for i in range(n))
    m2.append(f'R = kk[{vs}]; I = ideal({",".join(quads)});')
    m2.append(f'ok = false; for P in minimalPrimes I do ( if dim P >= 2 then ( '
              f'if (sub(gens P, matrix{{{{{pt2}}}}}) == 0) and (sub(gens P, matrix{{{{{pt6}}}}}) == 0) '
              f'then ok = true ) );')
    m2.append(f'verdicts#{idx} = ok;')
m2.append('good = select(keys verdicts, k -> verdicts#k);')
m2.append('<< "SUBSETS WITH A THROUGH-CURVE: " << sort good << " of " << #(keys verdicts) << endl;')
open('sweep_tmp.m2', 'w').write("\n".join(m2))
r = subprocess.run(['M2', '--script', 'sweep_tmp.m2'], capture_output=True, text=True, timeout=3600)
print(r.stdout[-2000:] if r.stdout else r.stderr[-2000:])
with open('sweep_subsets.txt', 'w') as f:
    for i, S in enumerate(subsets): f.write(f"{i}: {S}\n")
