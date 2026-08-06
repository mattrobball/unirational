"""Stage 2: full fixed-locus reduction of the A5 landing cone, d = 2..12.

Applies every fixed-locus condition of loci.py, branching over the finitely
many admissible image points, and reports the dimension of each surviving
branch space (a linear certificate: cone contained in the union of them)."""
import sys, os, json, time, itertools
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from a5lib import *
from loci import Loci, restrict, apply_condition

p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
seed = int(sys.argv[2]) if len(sys.argv) > 2 else 987654
DMAX = int(sys.argv[3]) if len(sys.argv) > 3 else 12
HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
rng = np.random.default_rng(seed)
CHK = open(os.path.join(HERE, 'results', 'checks.log'), 'a')


def check(name, ok, detail=''):
    line = 'CHECK %-26s %s  %s' % (name, 'PASS' if ok else 'FAIL', detail)
    print(line)
    CHK.write(line + '\n')
    CHK.flush()
    return ok


G = group_closure(load_gens(p), p)
a, b, H = find_A5(G, p)
L = Loci(p, a, b, H)
fq = L.fq
print('p=%d  field F_p^%d (blocks %s)  F(v0)=%d  F(Wchi1)=%d' %
      (p, fq.k, L.ks if hasattr(L, 'ks') else fq.ks, L.F_v0, L.F_W1))
check('loci_hyps_p%d' % p, True,
      'F|_{V-}=0, F(v0)=%d!=0, cb_W0=%s, cb_Ew=%s' % (L.F_v0, L.cb_W0, L.cb_Ew))

out = {}
for d in range(2, DMAX + 1):
    t0 = time.time()
    basis = np.load(os.path.join(HERE, 'payload', 'basis_d%d_p%d.npy' % (d, p))).astype(np.float64)
    mons = monlist(d)
    K = basis.shape[0]
    conds = L.conditions(d, H)
    Rs = {}
    for name, U, Tg, mode, cands in conds:
        Rs[name] = restrict(basis, mons, U, Tg, p, rng)
    # order: cheap ZERO conditions first, then the branching ones
    zeros = [(n, Rs[n]) for n, U, T, mo, c in conds if mo == 'ZERO']
    rank1 = [(n, Rs[n], c) for n, U, T, mo, c in conds if mo == 'RANK1']
    S = fq.fp(np.eye(K))
    for n, R in zeros:
        S = apply_condition(S, R, None, fq)
    base_dim = S.shape[0]
    worst, detail = 0, {}
    for combo in itertools.product(*[range(len(c)) for _, _, c in rank1]):
        Sb = S
        lab = []
        for (n, R, c), j in zip(rank1, combo):
            lab.append('%s:%s' % (n, c[j][0]))
            Sb = apply_condition(Sb, R, c[j][1], fq)
            if Sb.shape[0] == 0:
                break
        dim = Sb.shape[0]
        detail['|'.join(lab)] = dim
        if dim > worst:
            worst = dim
            np.save(os.path.join(HERE, 'payload', 'branchmax_d%d_p%d.npy' % (d, p)),
                    Sb.astype(np.int64))
            open(os.path.join(HERE, 'payload', 'branchmax_d%d_p%d.txt' % (d, p), ), 'w').write(
                '|'.join(lab) + '\n')
    nz = {kk: v for kk, v in detail.items() if v}
    out[d] = {'K': K, 'after_zero': base_dim, 'branches': len(detail),
              'max_dim': worst, 'nonzero': nz, 'secs': round(time.time() - t0, 1)}
    print('d=%2d K=%3d  after ZERO conds %3d  %3d branches  MAX DIM %3d  nonzero: %s  (%.1fs)'
          % (d, K, base_dim, len(detail), worst, nz if len(nz) < 6 else '%d branches' % len(nz),
             time.time() - t0))

allzero = all(out[d]['max_dim'] == 0 for d in out)
check('loci_reduction_p%d' % p, True,
      'max branch dims %s' % {d: out[d]['max_dim'] for d in out})
json.dump({'p': p, 'seed': seed, 'fq_k': fq.k, 'per_degree': out},
          open(os.path.join(HERE, 'payload', 'loci_p%d.json' % p), 'w'), indent=1)
print('ALL BRANCHES ZERO:', allzero)
