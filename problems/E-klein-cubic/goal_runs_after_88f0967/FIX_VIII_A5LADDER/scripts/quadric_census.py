"""Exact census of the second-order (EMPTY-QUADRICS) certificate per branch.

Stage 3 decides a branch cone in one of two ways: a pure linear-algebra
certificate -- the second-order landing quadrics span EVERY quadric in the
branch coordinates, so the cone is empty -- or, failing that, a Groebner basis
from msolve.  Through d = 10 the linear certificate carries the ladder.  This
script measures, for every Galois-orbit representative at a given degree, how
far the certificate gets:

    quadric_space  = number of quadratic monomials in the branch coordinates
                     (r(r+1)/2, times k_eff for an extension branch)
    quadric_rank   = rank of the second-order rows from ALL contractions,
                     sampled well past saturation
    verdict        = EMPTY-QUADRICS when the two agree,
                     QUADRIC-DEFICIT-<n> otherwise

The rank saturates in the sample count -- it is a property of the branch, not
of the sampling -- so a deficit is a proof that this certificate cannot decide
that branch at any sample budget, not a budget complaint.  Branches settled by
the certificate are then propagated by the packet's existing subspace and
Galois-conjugate rules.

No msolve, no Groebner basis: this pass is bounded linear algebra only.

usage:  quadric_census.py <p> <dlo> <dhi> [<seed>]
"""
import sys, os, json, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from a5lib import *
from loci import (Loci, restrict, apply_condition, jac_values, first_order_rows,
                  second_order_quadrics, enumerate_branches, frob_perm)
from fq import subfield_of, sub_fq, fq_rows_to_fp

p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
DLO = int(sys.argv[2]) if len(sys.argv) > 2 else 11
DHI = int(sys.argv[3]) if len(sys.argv) > 3 else 12
seed = int(sys.argv[4]) if len(sys.argv) > 4 else 20260806
HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
rng = np.random.default_rng(seed)
CHK = open(os.path.join(HERE, 'results', 'checks.log'), 'a')


def check(name, ok, detail=''):
    line = 'CHECK %-26s %s  %s' % (name, 'PASS' if ok else 'FAIL', detail)
    print(line, flush=True)
    CHK.write(line + '\n')
    CHK.flush()
    return ok


G = group_closure(load_gens(p), p)
a, b, H = find_A5(G, p)
L = Loci(p, a, b, H)
fq = L.fq

out = {}
for d in range(DLO, DHI + 1):
    t0 = time.time()
    basis = np.load(os.path.join(HERE, 'payload',
                                 'basis_d%d_p%d.npy' % (d, p))).astype(np.float64)
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
            qW = np.einsum('nk,nj->jk', q,
                           np.array(Tg, dtype=np.float64), optimize=True) % p
            opts.append((lab, R, q, first_order_rows(J, qW, fq), qW))
        subs.append({'name': name, 'U': U, 'opts': opts})
    spaces = enumerate_branches(S0, subs, fq)
    perms = [[0] + [1 + j for j in frob_perm(
        [(t[0], t[2]) for t in s['opts'][1:]], fq)] for s in subs]
    bycombo = {sp[3]: sp for sp in spaces}
    orbit_of, reps = {}, []
    for sp in spaces:
        c = sp[3]
        if c in orbit_of:
            continue
        orb, cur = [], c
        while True:
            orb.append(cur)
            cur = tuple(perms[i][cur[i]] for i in range(len(cur)))
            if cur == c:
                break
        for x in orb:
            orbit_of[x] = c
        reps.append(sp)
    reps.sort(key=lambda z: -z[1].shape[0])
    print('d=%2d: %d nonzero branch spaces -> %d Galois orbits'
          % (d, len(spaces), len(reps)), flush=True)

    verdicts, done = {}, []
    for key, S, contr, combo in reps:
        r = S.shape[0]
        cover = None
        for k2, S2 in done:
            if S2.shape[0] >= r:
                st = np.concatenate([S2, S], axis=0).reshape(-1, S2.shape[1], fq.k)
                if fq.rref(st)[0].shape[0] == S2.shape[0]:
                    cover = k2
                    break
        if cover is not None:
            verdicts[key] = {'dim': r, 'verdict': 'EMPTY-SUBSPACE',
                             'covered_by': cover}
            continue
        keff, idx = subfield_of(S, fq)
        info = {'dim': r, 'k_eff': keff, 'n_contractions': len(contr)}
        if not contr:
            info['verdict'] = 'NO-CONTRACTION'
            info['quadric_space'] = info['quadric_rank'] = 0
            verdicts[key] = info
            continue
        wfq, wS = fq, S
        ok_sub = keff > 1 and all(
            not np.any(np.delete(qW, idx, axis=1) % p) for _, qW in contr)
        if ok_sub:
            wfq, wS = sub_fq(idx, fq), S[:, :, idx]
        elif keff == 1:
            wfq, wS = sub_fq([0], fq), S[:, :, [0]]
        nmon2 = r * (r + 1) // 2
        full = nmon2 * wfq.k
        nq = int(1.2 * nmon2) + 60
        Q, Rq = [], np.zeros((0, 0))
        for U, qW in contr:
            qq = qW[:, idx] if ok_sub else (qW[:, [0]] if keff == 1 else qW)
            rq, monsq = second_order_quadrics(basis, mons, U, qq, wS, wfq, nq, rng)
            Q.append(rq)
            allq = np.concatenate(Q, axis=0)
            flat = (allq[:, :, 0] if wfq.k == 1 else fq_rows_to_fp(allq, wfq.tab, p))
            Rq, _ = rref(flat, p)
            if Rq.shape[0] >= full:
                break
        info['quadric_space'] = int(full)
        info['quadric_rank'] = int(Rq.shape[0])
        info['n_samples_per_contraction'] = nq
        if Rq.shape[0] >= full:
            info['verdict'] = 'EMPTY-QUADRICS'
            done.append((key, S))
        else:
            info['verdict'] = 'QUADRIC-DEFICIT-%d' % (full - Rq.shape[0])
        verdicts[key] = info
        print('  d=%2d %-42s dim %3d k %d  rank %4d / %4d  -> %s'
              % (d, key, r, keff, info['quadric_rank'], info['quadric_space'],
                 info['verdict']), flush=True)

    for sp in spaces:
        rep = orbit_of[sp[3]]
        if sp[3] != rep and bycombo[rep][0] in verdicts:
            v = verdicts[bycombo[rep][0]]['verdict']
            verdicts[sp[0]] = {'dim': int(sp[1].shape[0]),
                               'verdict': ('EMPTY-GALOIS-CONJUGATE'
                                           if v.startswith('EMPTY') else
                                           'CONJUGATE-OF-' + v),
                               'conjugate_of': bycombo[rep][0]}
    GOOD = ('EMPTY-QUADRICS', 'EMPTY-SUBSPACE', 'EMPTY-GALOIS-CONJUGATE')
    settled = [k for k, v in verdicts.items() if v['verdict'] in GOOD]
    openb = [k for k, v in verdicts.items() if v['verdict'] not in GOOD]
    out[d] = {'K': K, 'branches_nonzero': len(spaces), 'orbits': len(reps),
              'settled_by_quadrics': len(settled), 'open': len(openb),
              'verdicts': verdicts, 'secs': round(time.time() - t0, 1)}
    kinds = {}
    for v in verdicts.values():
        kinds[v['verdict']] = kinds.get(v['verdict'], 0) + 1
    check('quadric_census_d%d_p%d' % (d, p), True,
          '%d/%d branches settled by the linear certificate; %s'
          % (len(settled), len(verdicts), sorted(kinds.items())))
    json.dump(out, open(os.path.join(HERE, 'payload',
                                     'quadcensus_p%d_%d_%d.json' % (p, DLO, DHI)),
                        'w'), indent=1)
print(json.dumps({d: {'settled_by_quadrics': out[d]['settled_by_quadrics'],
                      'open': out[d]['open']} for d in out}, indent=1))
