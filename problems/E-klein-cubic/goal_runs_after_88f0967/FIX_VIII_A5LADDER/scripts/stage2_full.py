"""Stage 2: fixed-locus reduction of the A5 landing cone, d = 2..12.

For every A5 fixed locus U with target E (loci.py) the landing map satisfies
either  T|_U == 0  (sub-branch 'Z') or  T|_U = h.q with h != 0 and q in X
(sub-branch 'q'), and in the latter case ALSO the first-order condition
grad F(q)^T . DT(v) = 0 for all v in U.  Every branch is a linear subspace of
M_d^{A5}; the landing cone is contained in their union, so all-zero => EMPTY.
"""
import sys, os, json, time, itertools
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from a5lib import *
from loci import (Loci, restrict, apply_condition, jac_values, first_order_rows,
                  apply_fq_rows)

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
A5CLS = int(os.environ.get('A5CLASS', '0'))
if A5CLS:
    reps, ntot = a5_classes(G, p)
    a, b, H = reps[A5CLS]
    print('using A5 class %d of %d (%d subgroups total)'
          % (A5CLS, len(reps), ntot))
else:
    a, b, H = find_A5(G, p)
L = Loci(p, a, b, H)
fq = L.fq
print('p=%d  compositum F_p^%d  F(v0)=%d  F(Wchi1)=%d  cb_W0=%s  cb_Ew=%s'
      % (p, fq.k, L.F_v0, L.F_W1, L.cb_W0, L.cb_Ew))
check('loci_hyps_p%d' % p, L.F_v0 % p != 0 and all(v % p == 0 for v in L.cb_Vm),
      'F|_{V-}=0 and F(v0)!=0')

out = {}
for d in range(2, DMAX + 1):
    t0 = time.time()
    basis = np.load(os.path.join(HERE, 'payload', 'basis_d%d_p%d.npy' % (d, p))).astype(np.float64)
    mons = monlist(d)
    K = basis.shape[0]
    conds = L.conditions(d, H)
    pre = []            # branch-free ZERO conditions
    rank1 = []          # (name, R, U, target, candidates)
    for name, U, Tg, mode, cands in conds:
        R = restrict(basis, mons, U, Tg, p, rng)
        if mode == 'ZERO':
            pre.append((name, R))
        else:
            rank1.append((name, R, U, Tg, cands))
    S0 = fq.fp(np.eye(K))
    for name, R in pre:
        S0 = apply_condition(S0, R, None, fq)
    base_dim = S0.shape[0]
    # per-locus sub-branch machinery
    subs = []
    for name, R, U, Tg, cands in rank1:
        J = jac_values(basis, mons, U, p, rng)
        opts = [('Z', R, None, None)]
        for lab, q in cands:
            qW = np.einsum('nk,nj->jk', q, np.array(Tg, dtype=np.float64)) % p   # q in W
            opts.append((lab, R, q, first_order_rows(J, qW, fq)))
        subs.append((name, opts))
    worst, detail, wlab = 0, {}, ''
    for combo in itertools.product(*[range(len(o)) for _, o in subs]):
        Sb, lab = S0, []
        for (name, opts), j in zip(subs, combo):
            tag, R, q, FO = opts[j]
            lab.append('%s:%s' % (name, tag))
            Sb = apply_condition(Sb, R, q, fq)
            if q is not None and Sb.shape[0]:
                Sb = apply_fq_rows(Sb, FO, fq)
            if Sb.shape[0] == 0:
                break
        detail['|'.join(lab)] = Sb.shape[0]
        if Sb.shape[0] > worst:
            worst, wlab = Sb.shape[0], '|'.join(lab)
            np.save(os.path.join(HERE, 'payload', 'branchmax_d%d_p%d.npy' % (d, p)),
                    Sb.astype(np.int64))
    nz = {kk: v for kk, v in detail.items() if v}
    out[d] = {'K': K, 'after_zero': base_dim, 'branch_keys': len(detail),
              'max_dim': worst, 'max_label': wlab, 'n_nonzero': len(nz),
              'nonzero': nz if len(nz) <= 8 else 'omitted', 'secs': round(time.time() - t0, 1)}
    print('d=%2d K=%3d  pre %3d  keys %4d  MAX DIM %3d %s  nonzero %d  (%.1fs)'
          % (d, K, base_dim, len(detail), worst, wlab, len(nz), time.time() - t0))

allzero = all(out[d]['max_dim'] == 0 for d in out)
check('loci_reduction_p%d' % p, True,
      'max branch dims %s' % {d: out[d]['max_dim'] for d in out})
check('cone_empty_linear_certificate_p%d' % p, allzero,
      'every branch subspace is 0 for d=2..%d' % DMAX if allzero else 'branches remain')
json.dump({'p': p, 'seed': seed, 'fq_k': fq.k, 'per_degree': out},
          open(os.path.join(HERE, 'payload', 'loci_p%d%s.json' % (p, '' if not A5CLS else '_c%d' % A5CLS)), 'w'), indent=1)
print('ALL BRANCHES ZERO:', allzero)
