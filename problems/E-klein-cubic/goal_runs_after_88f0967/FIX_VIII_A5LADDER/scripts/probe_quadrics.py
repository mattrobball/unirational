"""Probe: does the second-order quadric rank certificate settle branches on
its own (no msolve)?"""
import sys, os, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from a5lib import *
from loci import *
from fq import subfield_of, sub_fq, fq_rows_to_fp

p = int(sys.argv[1]); d = int(sys.argv[2]); NTOP = int(sys.argv[3]) if len(sys.argv) > 3 else 6
HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
rng = np.random.default_rng(5150)
G = group_closure(load_gens(p), p)
a, b, H = find_A5(G, p)
L = Loci(p, a, b, H)
fq = L.fq
basis = np.load(os.path.join(HERE, 'payload', 'basis_d%d_p%d.npy' % (d, p))).astype(np.float64)
mons = monlist(d)
K = basis.shape[0]
conds = L.conditions(d, H)
pre, rank1 = [], []
for name, U, Tg, mode, cands in conds:
    R = restrict(basis, mons, U, Tg, p, rng)
    (pre if mode == 'ZERO' else rank1).append(
        (name, R) if mode == 'ZERO' else (name, R, U, Tg, cands))
S0 = fq.fp(np.eye(K))
for name, R in pre:
    S0 = apply_condition(S0, R, None, fq)
subs = []
for name, R, U, Tg, cands in rank1:
    J = jac_values(basis, mons, U, p, rng)
    opts = [('Z', R, None, None, None)]
    for lab, q in cands:
        qW = np.einsum('nk,nj->jk', q, np.array(Tg, dtype=np.float64)) % p
        opts.append((lab, R, q, first_order_rows(J, qW, fq), qW))
    subs.append({'name': name, 'U': U, 'opts': opts})
spaces = enumerate_branches(S0, subs, fq)
print('branches:', len(spaces))
t0 = time.time()
fired = done = 0
for key, Sb, contr, _c in sorted(spaces, key=lambda t: -t[1].shape[0])[:NTOP]:
    r = Sb.shape[0]
    if r == 1 or not contr:
        continue
    keff, idx = subfield_of(Sb, fq)
    Q, monsq = [], None
    for U, qW in contr:
        rq, monsq = second_order_quadrics(basis, mons, U, qW, Sb, fq,
                                          2 * (r * (r + 1) // 2) + 40, rng)
        Q.append(rq)
    allq = np.concatenate(Q, axis=0)
    sub = sub_fq(idx, fq) if keff > 1 else None
    flat = allq[:, :, 0] if keff == 1 else fq_rows_to_fp(allq[:, :, idx], sub.tab, p)
    Rq, _ = rref(flat, p)
    full = len(monsq) * (1 if keff == 1 else keff)
    ok = Rq.shape[0] >= full
    print('  %-42s dim %2d keff %d  quadric rank %5d / %5d  %s (%.0fs)'
          % (key, r, keff, Rq.shape[0], full,
             'EMPTY-QUADRICS' if ok else 'partial', time.time() - t0), flush=True)
    done += 1
    fired += ok
print('fired %d / %d' % (fired, done))
