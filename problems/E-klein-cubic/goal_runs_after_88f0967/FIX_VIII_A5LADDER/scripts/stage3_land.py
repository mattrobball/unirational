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
                  apply_fq_rows, second_order_quadrics, enumerate_branches,
                  frob_perm)
from fq import Fq, subfield_of, sub_fq, fq_rows_to_fp
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


def land_on_branch(d, basis, mons, S, label, tag, contractions=(), quad=True):
    """LAND on one branch space.  Order of attack:

      dim 1                  -> exact landing identity (grid, decisive)
      second-order quadrics  -> if they span ALL quadrics in the branch
                                coordinates the cone is empty (pure linear
                                algebra certificate, no Groebner basis)
      otherwise              -> saturated cubic system (+ the quadrics) -> msolve
    """
    r = S.shape[0]
    keff, idx = subfield_of(S, fq)
    sub = sub_fq(idx, fq) if keff > 1 else None
    Ssub = S[:, :, idx] if keff > 1 else S[:, :, [0]]
    Bm = np.transpose(np.tensordot(Ssub, basis, axes=([1], [0])) % p, (0, 2, 3, 1))
    info = {'dim': r, 'k_eff': keff, 'nvars': r if keff == 1 else r + 1}
    if r == 1:
        C = Bm[0] if keff > 1 else Bm[0][:, :, 0]
        if not np.any(C % p):
            info['verdict'] = 'ZEROMAP'
            return info
        ok, nz, npts = full_identity(C, p, d=d, tab=(sub.tab if keff > 1 else None))
        info['verdict'] = 'HIT' if ok else 'EMPTY-IDENTITY'
        info['grid_nonzero'], info['grid_points'] = nz, npts
        return info
    nvar = info['nvars']
    ms = os.path.join(RES, 'land_d%d_%s_p%d.ms' % (d, tag, p))
    quads = []
    if quad and contractions:
        nq = int(1.6 * (r * (r + 1) // 2)) + 60
        Q, monsq = [], None
        for U, qW in contractions:
            rq, monsq = second_order_quadrics(basis, mons, U, qW, S, fq, nq, rng)
            Q.append(rq[:, :, idx] if keff > 1 else rq)
        allq = np.concatenate(Q, axis=0)
        flat = allq[:, :, 0] if keff == 1 else fq_rows_to_fp(allq, sub.tab, p)
        Rq, _ = rref(flat, p)
        full = len(monsq) * keff
        info['quadric_rank'], info['quadric_space'] = int(Rq.shape[0]), full
        if Rq.shape[0] >= full:
            info['verdict'] = 'EMPTY-QUADRICS'
            return info
        quads = write_quadrics(Rq if keff == 1 else Rq.reshape(Rq.shape[0], -1, keff),
                               monsq, r, p, None if keff == 1 else sub.tab)
    # saturate the degree-3 part of the sampled landing ideal
    budget = 3000 if r <= 25 else 600
    blk = max(120, 3 * r)
    R, monsl, tot = None, None, 0
    while tot < budget:
        rows, monsl = cubic_rows(Bm[:, :, :, 0] if keff == 1 else Bm, mons, p, blk,
                                 rng, tab=None if keff == 1 else sub.tab)
        M = np.array(rows, dtype=np.float64)
        M = M if keff == 1 else fq_rows_to_fp(M, sub.tab, p)
        M = M if R is None else np.concatenate([R, M], axis=0)
        new, _ = rref(M, p)
        tot += blk
        stop = R is not None and new.shape[0] == R.shape[0]
        R = new
        if stop or R.shape[0] >= len(monsl) * keff:
            break
    info['n_cubics'], info['n_points'] = int(R.shape[0]), tot
    info['n_cubic_monomials'] = len(monsl) * keff
    if R.shape[0] >= len(monsl) * keff:
        info['verdict'] = 'EMPTY-ALL-CUBICS'
        return info
    if R.shape[0] == 0 and not quads:
        info['verdict'] = 'ALL-CUBICS-VANISH'
        return info
    import math
    want = int(1.4 * math.comb(r + 3, 4) / max(r, 1)) + 1
    nuse = min(R.shape[0], max(300, want))
    while nuse * len(monsl) * keff > 3_000_000 and nuse > 200:
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
    info['msolve'], info['secs'] = st, round(time.time() - t0, 1)
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
    # Galois: phi = Frobenius permutes the candidate image points, hence the
    # branches; conjugate branches have conjugate verdicts, so test one per orbit
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
    verdicts, nb, done = {}, 0, []
    for key, Sb, contr, combo in reps:
        cover = None
        for k2, S2 in done:            # subspace of an already-empty branch?
            if S2.shape[0] >= Sb.shape[0]:
                st = np.concatenate([S2, Sb], axis=0).reshape(-1, S2.shape[1], fq.k)
                if fq.rref(st)[0].shape[0] == S2.shape[0]:
                    cover = k2
                    break
        if cover is not None:
            verdicts[key] = {'dim': int(Sb.shape[0]), 'verdict': 'EMPTY-SUBSPACE',
                             'covered_by': cover}
            continue
        nb += 1
        info = land_on_branch(d, basis, mons, Sb, key, 'b%d' % nb, contractions=contr)
        verdicts[key] = info
        if info['verdict'] in ('EMPTY', 'EMPTY-ALL-CUBICS', 'EMPTY-IDENTITY',
                               'ZEROMAP'):
            done.append((key, Sb))     # label-independent => valid for subspaces
        print('  d=%2d %-42s dim %2d k %d vars %3d -> %-16s %s'
              % (d, key, info['dim'], info['k_eff'], info['nvars'], info['verdict'],
                 info.get('msolve', '')), flush=True)
    GOOD = ('EMPTY', 'EMPTY-ALL-CUBICS', 'EMPTY-QUADRICS', 'EMPTY-IDENTITY',
            'EMPTY-SUBSPACE', 'ZEROMAP')
    bad = [k for k, v in verdicts.items() if v['verdict'] not in GOOD]
    out[d] = {'K': K, 'branches_nonzero': len(verdicts), 'verdicts': verdicts,
              'unresolved': bad, 'secs': round(time.time() - t0, 1)}
    print('d=%2d : %d nonzero branches, %d unresolved  (%.0fs)'
          % (d, len(verdicts), len(bad), time.time() - t0))
    for sp in spaces:                     # record the conjugate branches
        rep = orbit_of[sp[3]]
        if sp[3] != rep and bycombo[rep][0] in verdicts:
            verdicts[sp[0]] = {'dim': int(sp[1].shape[0]),
                               'verdict': 'EMPTY-GALOIS-CONJUGATE',
                               'conjugate_of': bycombo[rep][0]}
    GOOD = GOOD + ('EMPTY-GALOIS-CONJUGATE',)
    bad = [k for k, v in verdicts.items() if v['verdict'] not in GOOD]
    check('land_d%d_p%d' % (d, p), not bad,
          'all %d branches EMPTY' % len(verdicts) if not bad else 'unresolved: %s' % bad)
    json.dump(out, open(os.path.join(HERE, 'payload', 'land_p%d_%d_%d%s.json'
                                     % (p, DLO, DHI, '' if not A5CLS else '_c%d' % A5CLS)), 'w'), indent=1)
print(json.dumps({d: {'unresolved': out[d]['unresolved']} for d in out}, indent=1))
