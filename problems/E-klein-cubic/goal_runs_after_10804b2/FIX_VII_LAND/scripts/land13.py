import numpy as np, glob, random, itertools
random.seed(7); p = 67
base = '/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_ac61998/FIX_VII_GATE/payload/candidates_p67/'
cands = []
for fn in sorted(glob.glob(base + 'C*.txt')):
    comp = [[] for _ in range(5)]
    for line in open(fn):
        if line.startswith('#') or not line.strip(): continue
        t = line.split(); i = int(t[0]); e = tuple(map(int, t[1:6])); c = int(t[6]) % p
        comp[i].append((e, c))
    cands.append(comp)
K = len(cands); assert K == 13
def evalT(comp, x):
    PT = [[pow(int(xv), k, p) for k in range(35)] for xv in x]
    out = []
    for i in range(5):
        s = 0
        for e, c in comp[i]:
            s += c * PT[0][e[0]] * PT[1][e[1]] % p * PT[2][e[2]] % p * PT[3][e[3]] % p * PT[4][e[4]]
        out.append(s % p)
    return out
mons = list(itertools.combinations_with_replacement(range(K), 3))  # 455 cubic monomials
rows = []
NPTS = 60
for j in range(NPTS):
    x = [random.randrange(p) for _ in range(5)]
    M = np.array([evalT(c, x) for c in cands], dtype=np.int64).T % p   # 5 x 13
    # F(Mc) = sum_i (M_i . c)^2 (M_{i+1} . c): build symmetric cubic coefficient tensor
    C3 = np.zeros((K, K, K), dtype=np.int64)
    for i in range(5):
        a = M[i]; b = M[(i+1) % 5]
        C3 += np.einsum('u,v,w->uvw', a, a, b) % p
        C3 %= p
    row = []
    for (u, v, w) in mons:
        # coefficient of c_u c_v c_w: sum over distinct orderings of C3 entries
        perms = set(itertools.permutations((u, v, w)))
        row.append(sum(int(C3[q]) for q in perms) % p)
    rows.append(row)
print("system: %d cubics in %d vars mod %d" % (len(rows), K, p))
# write M2 script to test dim of the ideal
with open('land13.m2', 'w') as f:
    f.write('kk = ZZ/%d\nR = kk[c_0..c_12]\n' % p)
    f.write('mons = {' + ','.join('c_%d*c_%d*c_%d' % m for m in mons) + '}\n')
    f.write('eqs = {')
    f.write(',\n'.join('sum apply(%d, k -> (matrix{{%s}})_(0,k) * mons#k)' % (len(mons), ','.join(str(v)+'_kk' for v in row)) for row in rows))
    f.write('}\nI = ideal eqs;\n<< "dim (affine cone): " << dim I << "   (0 or -1 => projective EMPTY)" << endl\n')
    f.write('if dim I > 0 then << "degree: " << degree I << endl\n')
print("wrote land13.m2")
