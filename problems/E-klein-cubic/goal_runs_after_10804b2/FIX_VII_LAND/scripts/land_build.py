import numpy as np, glob, random, itertools, sys
prime = int(sys.argv[1]); random.seed(7); p = prime
base = '/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_ac61998/FIX_VII_GATE/payload/candidates_p%d/' % p
cands = []
for fn in sorted(glob.glob(base + 'C*.txt')):
    comp = [[] for _ in range(5)]
    for line in open(fn):
        if line.startswith('#') or not line.strip(): continue
        t = line.split(); comp[int(t[0])].append((tuple(map(int, t[1:6])), int(t[6]) % p))
    cands.append(comp)
K = len(cands); assert K == 13, K
def evalT(comp, x):
    PT = [[pow(int(xv), k, p) for k in range(35)] for xv in x]
    return [sum(c * PT[0][e[0]] * PT[1][e[1]] % p * PT[2][e[2]] % p * PT[3][e[3]] % p * PT[4][e[4]] for e, c in comp[i]) % p for i in range(5)]
mons = list(itertools.combinations_with_replacement(range(K), 3))
rows = []
for j in range(60):
    x = [random.randrange(p) for _ in range(5)]
    M = np.array([evalT(c, x) for c in cands], dtype=np.int64).T % p
    C3 = np.zeros((K, K, K), dtype=np.int64)
    for i in range(5):
        a, b = M[i], M[(i+1) % 5]
        C3 = (C3 + np.einsum('u,v,w->uvw', a, a, b)) % p
    rows.append([sum(int(C3[q]) for q in set(itertools.permutations(m))) % p for m in mons])
names = ','.join('c%d' % i for i in range(13))
polys = []
for row in rows:
    terms = ['%d*c%d*c%d*c%d' % (c, u, v, w) for c, (u, v, w) in zip(row, mons) if c % p]
    polys.append('+'.join(terms))
open('land13_p%d.ms' % p, 'w').write(names + '\n' + str(p) + '\n' + ',\n'.join(polys) + '\n')
print("wrote land13_p%d.ms" % p)
