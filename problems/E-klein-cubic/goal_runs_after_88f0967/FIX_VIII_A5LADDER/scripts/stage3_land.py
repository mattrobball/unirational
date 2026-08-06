"""Stage 3: LAND on every surviving branch space.

For each degree d and each nonzero branch subspace B (stage 2), the landing
cone inside B is the projective variety of the cubics F(T_c)(x) = 0.  Sample
those cubics at random points (the sampled ideal is contained in the true
landing ideal, so emptiness of the sampled variety is decisive) and give them
to msolve.  Branches of dimension 1 are settled exactly by full_identity.
"""
import sys, os, json, time, itertools
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from a5lib import *
from loci import (Loci, restrict, apply_condition, jac_values, first_order_rows,
                  apply_fq_rows, second_order_quadrics, enumerate_branches)
from fq import Fq, subfield_of, sub_fq
from land import (cubic_rows, write_ms, write_ms_ext, run_msolve, gb_verdict,
                  full_identity, ext_table, write_quadrics)

p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
DLO = int(sys.argv[2]) if len(sys.argv) > 2 else 8
DHI = int(sys.argv[3]) if len(sys.argv) > 3 else 12
seed = int(sys.argv[4]) if len(sys.argv) > 4 else 20260806
CAP = int(sys.argv[5]) if len(sys.argv) > 5 else 600
HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
rng = np.random.default_rng(seed)
CHK = open(os.path.join(HERE, 'results', 'checks.log'), 'a')
RES = os.path.join(HERE, 'results')


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


def land_on_branch(d, basis, mons, S, label, tag, contractions=(), quad=False):
    """S: (r, K, k) branch basis over fq.  Returns a verdict dict.

    contractions: [(U, qW)] the loci this branch contracts (h != 0 there), used
    for the second-order quadrics when quad=True."""
    r = S.shape[0]
    keff, idx = subfield_of(S, fq)
    sub = sub_fq(idx, fq) if keff > 1 else None
    Ssub = S[:, :, idx] if keff > 1 else S[:, :, [0]]
    # maps: Bmaps[l] = sum_i S[l,i] T_i     (coeffs over F_{p^keff})
    Bm = np.tensordot(Ssub, basis, axes=([1], [0])) % p          # (r, keff, 5, N)
    Bm = np.transpose(Bm, (0, 2, 3, 1))                          # (r, 5, N, keff)
    nvar = r * keff
    info = {'dim': r, 'k_eff': keff, 'nvars': nvar}
    if r == 1:
        C = Bm[0] if keff > 1 else Bm[0][:, :, 0]
        if not np.any(C % p):
            info['verdict'] = 'ZEROMAP'
            return info
        ok, nz, npts = full_identity(C, p, d=d, tab=(sub.tab if keff > 1 else None))
        info['verdict'] = 'HIT' if ok else 'EMPTY'
        info['grid_nonzero'] = nz
        info['grid_points'] = npts
        return info
    nvar = r if keff == 1 else r + 1        # theta is one extra variable
    info['nvars'] = nvar
    # sample well past the brief's 4K: the landing ideal has ~C(3d+4,4)/60
    # independent cubics and using them all is what keeps the solving degree low
    npts = min(1500, max(200, 12 * r * keff))
    ms = os.path.join(RES, 'land_d%d_%s_p%d.ms' % (d, tag, p))
    tab = sub.tab if keff > 1 else None
    quads = []
    if quad and contractions:
        nq = 2 * (r * (r + 1) // 2) + 40
        Q, monsq = [], None
        for U, qW in contractions:
            rows_q, monsq = second_order_quadrics(basis, mons, U, qW, S, fq, nq, rng)
            Q.append(rows_q if keff == 1 or fq.k == keff else rows_q)
        allq = np.concatenate(Q, axis=0)
        if keff == 1:
            allq = allq[:, :, 0] if allq.ndim == 3 else allq
            Rq, _ = rref(allq, p)
            info['quadric_rank'] = int(Rq.shape[0])
            info['quadric_space'] = len(monsq)
            if Rq.shape[0] == len(monsq):
                info['verdict'] = 'EMPTY-QUADRICS'      # ideal contains all quadrics
                return info
            quads = write_quadrics(Rq, monsq, r, p, None)
        else:
            flat = allq.reshape(allq.shape[0], -1)
            Rq, _ = rref(flat, p)
            info['quadric_rank'] = int(Rq.shape[0])
            quads = write_quadrics(Rq.reshape(Rq.shape[0], -1, keff), monsq, r, p, sub.tab)
    # sample until the degree-3 part of the sampled ideal SATURATES: the true
    # landing ideal has only ~C(3d+4,4)/60 independent cubics, and capturing all
    # of them is what keeps the solving degree low.
    budget = 3000 if r <= 25 else 600
    blk = max(120, 3 * r)
    R, monsl, tot = None, None, 0
    while tot < budget:
        rows, monsl = cubic_rows(Bm[:, :, :, 0] if keff == 1 else Bm, mons, p, blk,
                                 rng, tab=None if keff == 1 else sub.tab)
        M = np.array(rows, dtype=np.float64)
        if keff > 1:
            M = M.reshape(M.shape[0], -1)
        M = M if R is None else np.concatenate([R, M], axis=0)
        new, _ = rref(M, p)
        tot += blk
        stop = R is not None and new.shape[0] == R.shape[0]
        R = new
        if stop or R.shape[0] >= len(monsl) * (1 if keff == 1 else keff):
            break
    info['n_cubics'] = int(R.shape[0])
    info['n_points'] = tot
    info['n_cubic_monomials'] = len(monsl)
    if R.shape[0] >= len(monsl) * (1 if keff == 1 else keff):
        # the ideal contains EVERY cubic form in the branch coordinates
        info['verdict'] = 'EMPTY-ALL-CUBICS'
        return info
    if R.shape[0] == 0 and not quads:
        info['verdict'] = 'ALL-CUBICS-VANISH'
        return info
    # msolve wants generic generators, not the whole echelon basis, and enough
    # of them that the degree-4 Macaulay matrix is already square (solving
    # degree 4).  Take random F_p-combinations of the saturated span.
    import math
    want = int(1.4 * math.comb(r + 3, 4) / max(r, 1)) + 1
    nuse = min(R.shape[0], max(300, want))
    while nuse * len(monsl) > 3_000_000 and nuse > 300:
        nuse = nuse // 2
    if nuse < R.shape[0]:
        Cmix = rng.integers(0, p, size=(nuse, R.shape[0])).astype(np.float64)
        R = mm(Cmix, R, p)
    info['n_generators'] = int(R.shape[0])
    if keff == 1:
        write_ms([[int(v) for v in row] for row in R], monsl, nvar, p, ms,
                 extra_gens=quads)
    else:
        write_ms_ext(R.reshape(R.shape[0], -1, keff), monsl, r, p, sub.tab, ms,
                     extra_gens=quads)
    t0 = time.time()
    st, body = run_msolve(ms, ms.replace('.ms', '.out'), CAP, gb=True)
    info['msolve'] = st
    info['secs'] = round(time.time() - t0, 1)
    info['verdict'] = 'UNDECIDED-TIMEOUT' if st == 'TIMEOUT' else (
        gb_verdict(body, r) if st == 'OK' else 'ERROR')
    info['gb_head'] = body[:150] if st == 'OK' else ''
    return info


out = {}
for d in range(DLO, DHI + 1):
    t0 = time.time()
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
    # collect the surviving branch subspaces (label, space, contracted loci)
    spaces = enumerate_branches(S0, subs, fq)
    # dedup identical branch spaces: the cubics-only test is label-independent,
    # so one run settles every label sharing a space.  A space that survives
    # cubics-only is retried per label with that label's own quadrics.
    alias, uniq = {}, []
    for key, Sb, contr in spaces:
        h = fq.rref(Sb.reshape(Sb.shape[0], -1, fq.k))[0].astype(np.int64).tobytes()
        if h in alias:
            alias[h].append((key, contr))
            continue
        alias[h] = [(key, contr)]
        uniq.append((key, Sb, h))
    uniq.sort(key=lambda z: -z[1].shape[0])
    print('d=%2d: %d branch labels -> %d distinct nonzero spaces'
          % (d, len(spaces), len(uniq)), flush=True)
    verdicts, nb, done = {}, 0, []
    for key, Sb, h in uniq:
        labels = alias[h]
        cover = None
        for k2, S2 in done:            # contained in a CUBICS-ONLY empty branch?
            if S2.shape[0] >= Sb.shape[0]:
                st = np.concatenate([S2, Sb], axis=0).reshape(-1, S2.shape[1], fq.k)
                if fq.rref(st)[0].shape[0] == S2.shape[0]:
                    cover = k2
                    break
        if cover is not None:
            verdicts[key] = {'dim': int(Sb.shape[0]), 'verdict': 'EMPTY',
                             'covered_by': cover, 'labels': len(labels)}
            continue
        nb += 1
        info = land_on_branch(d, basis, mons, Sb, key, 'b%d' % nb)      # cubics only
        info['labels'] = len(labels)
        if info['verdict'] in ('EMPTY', 'EMPTY-ALL-CUBICS', 'ZEROMAP'):
            done.append((key, Sb))      # cubics-only => valid for subspaces too
        else:                            # per-label retry with second-order quadrics
            sub_v = {}
            for li, (lk, lc) in enumerate(labels):
                if not lc:
                    sub_v[lk] = info['verdict']
                    continue
                i2 = land_on_branch(d, basis, mons, Sb, lk, 'b%dq%d' % (nb, li),
                                    contractions=lc, quad=True)
                sub_v[lk] = i2['verdict']
                verdicts[lk] = i2
            info = dict(info, verdict='PER-LABEL', per_label=sub_v,
                        cubics_only=info['verdict'])
        verdicts[key] = info
        print('  d=%2d %-40s dim %2d k %s vars %s -> %-18s %s'
              % (d, key, info['dim'], info.get('k_eff', '-'), info.get('nvars', '-'),
                 info['verdict'], info.get('msolve', '')), flush=True)
    GOOD = ('EMPTY', 'EMPTY-ALL-CUBICS', 'EMPTY-QUADRICS', 'ZEROMAP')
    bad = []
    for k, v in verdicts.items():
        if v['verdict'] in GOOD:
            continue
        if v['verdict'] == 'PER-LABEL' and all(
                x in GOOD for x in v['per_label'].values()):
            continue
        bad.append(k)
    out[d] = {'K': K, 'branches_nonzero': len(verdicts), 'verdicts': verdicts,
              'unresolved': bad, 'secs': round(time.time() - t0, 1)}
    print('d=%2d : %d nonzero branches, %d unresolved  (%.0fs)'
          % (d, len(verdicts), len(bad), time.time() - t0))
    check('land_d%d_p%d' % (d, p), not bad,
          'all %d branches EMPTY' % len(verdicts) if not bad else 'unresolved: %s' % bad)
    json.dump(out, open(os.path.join(HERE, 'payload', 'land_p%d_%d_%d%s.json'
                                     % (p, DLO, DHI, '' if not A5CLS else '_c%d' % A5CLS)), 'w'), indent=1)
print(json.dumps({d: {'unresolved': out[d]['unresolved']} for d in out}, indent=1))
