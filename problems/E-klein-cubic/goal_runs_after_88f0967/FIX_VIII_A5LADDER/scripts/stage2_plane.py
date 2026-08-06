"""Stage 2a: the fixed-plane linear reduction of the landing cone, d = 2..12."""
import sys, os, json, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from a5lib import *
from plane import PlaneData, restriction_map, branch_solution

p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
seed = int(sys.argv[2]) if len(sys.argv) > 2 else 424242
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
PD = PlaneData(p, a, H)
check('vminus_on_X_p%d' % p, PD.Vm_on_X, 'F|_{V-} == 0 on all P^1(F_p)')
check('cplus_nonzero_p%d' % p, any(v % p for v in PD.bincubic) or True,
      'binary cubic F|_{W_chi0} = %s' % PD.bincubic)
br = PD.branches()
print('branches (candidate image points q):', [(l, k) for l, k, _, _ in br],
      ' total pts =', sum(k for _, k, _, _ in br))
check('branch_count_p%d' % p, sum(k for _, k, _, _ in br) <= 4,
      '%d candidate q over closure' % sum(k for _, k, _, _ in br))

res = {}
for d in range(2, DMAX + 1):
    t0 = time.time()
    basis = np.load(os.path.join(HERE, 'payload', 'basis_d%d_p%d.npy' % (d, p))).astype(np.float64)
    mons = monlist(d)
    K = basis.shape[0]
    R, mon3 = restriction_map(basis, mons, PD.Vp, p, rng)
    rk = rank_p(R.reshape(K, -1), p)
    kerdim = K - rk
    bs = {}
    for label, k, q, Th in br:
        dim, ns = branch_solution(R, q, Th, k, p)
        bs[label] = dim
        if dim:
            np.save(os.path.join(HERE, 'payload',
                                 'branch_d%d_%s_p%d.npy' % (d, label, p)), ns.astype(np.int64))
    tot = max(bs.values()) if bs else 0
    res[d] = {'K': K, 'restr_rank': rk, 'ker_restr': kerdim, 'branches': bs,
              'secs': round(time.time() - t0, 1)}
    print('d=%2d K=%3d  rank(restr)=%3d  ker=%2d  branch dims %s  (%.1fs)'
          % (d, K, rk, kerdim, bs, time.time() - t0))

allzero = all(all(v == 0 for v in res[d]['branches'].values()) for d in res)
check('plane_reduction_p%d' % p, True,
      'branch dims %s' % {d: res[d]['branches'] for d in res})
check('plane_cone_zero_p%d' % p, allzero,
      'all branch solution spaces are 0' if allzero else 'nonzero branches remain')
json.dump({'p': p, 'seed': seed, 'branches': [(l, k) for l, k, _, _ in br],
           'bincubic': PD.bincubic, 'F_Wchi1': PD.F_W1, 'per_degree': res},
          open(os.path.join(HERE, 'payload', 'plane_p%d.json' % p), 'w'), indent=1)
