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
                  apply_fq_rows)
from fq import Fq
from land import cubic_rows, write_ms, run_msolve, gb_verdict, full_identity, ext_table

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
a, b, H = find_A5(G, p)
L = Loci(p, a, b, H)
fq = L.fq


def subfield_of(S, fq):
    """smallest block-subfield of fq containing all entries of S -> (k_eff, idx)"""
    used = set(np.nonzero(np.any(np.abs(S) > 0, axis=tuple(range(S.ndim - 1))))[0])
    ks = fq.ks
    cands = []
    if not ks:
        return 1, [0]
    strides, st = [], 1
    for kk in ks[::-1]:
        strides.insert(0, st)
        st *= kk
    # candidate subfields: any subset of blocks
    for mask in range(1 << len(ks)):
        idx = [0]
        for bi in range(len(ks)):
            if mask >> bi & 1:
                idx = [i + j * strides[bi] for i in idx for j in range(ks[bi])]
        idx = sorted(idx)
        if used <= set(idx):
            cands.append(idx)
    idx = min(cands, key=len)
    return len(idx), idx


def sub_fq(idx, fq):
    """Fq object on the sub-basis idx (must be closed under multiplication)"""
    k = len(idx)
    tab = fq.tab[np.ix_(idx, idx, list(range(fq.k)))]
    assert not np.any(np.delete(tab, idx, axis=2) % fq.p), 'not a subfield'
    sub = Fq.__new__(Fq)
    sub.p, sub.blocks, sub.ks, sub.k = fq.p, None, [k], k
    sub.tab = tab[:, :, idx] % fq.p
    return sub


def land_on_branch(d, basis, mons, S, label, tag):
    """S: (r, K, k) branch basis over fq.  Returns a verdict dict."""
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
    npts = max(60, 4 * nvar)
    if keff == 1:
        rows, monsl = cubic_rows(Bm[:, :, :, 0], mons, p, npts, rng, tab=None)
    else:                              # Weil restriction: r*keff F_p variables
        rows, monsl = weil_rows(Bm, mons, p, npts, sub)
    R, _ = rref(np.array(rows, dtype=np.float64), p)
    rows = [[int(v) for v in row] for row in R]
    info['n_cubics'] = len(rows)
    ms = os.path.join(RES, 'land_d%d_%s_p%d.ms' % (d, tag, p))
    ng = write_ms(rows, monsl, nvar, p, ms)
    t0 = time.time()
    st, body = run_msolve(ms, ms.replace('.ms', '.out'), CAP, gb=True)
    info['msolve'] = st
    info['secs'] = round(time.time() - t0, 1)
    info['verdict'] = 'UNDECIDED-TIMEOUT' if st == 'TIMEOUT' else (
        gb_verdict(body, nvar) if st == 'OK' else 'ERROR')
    info['gb_head'] = body[:120] if st == 'OK' else ''
    return info


def weil_rows(Bm, mons, p, npts, sub):
    """cubic system for lambda in F_{p^k}^r written over F_p (r*k variables)."""
    r, _, N, k = Bm.shape
    # unknown lambda_l = sum_j lam_{lj} theta^j with lam_{lj} in F_p, so the
    # F_p-basis of maps is  theta^j . B_l
    big = np.zeros((r * k, 5, N, k))
    for l in range(r):
        for j in range(k):
            e = np.zeros(k); e[j] = 1
            big[l * k + j] = np.einsum('ina,b,abt->int', Bm[l], e, sub.tab) % p
    rows, monsl = cubic_rows(big, mons, p, npts, np.random.default_rng(seed + 7),
                             tab=sub.tab)
    return rows, monsl


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
        opts = [('Z', R, None, None)]
        for lab, q in cands:
            qW = np.einsum('nk,nj->jk', q, np.array(Tg, dtype=np.float64)) % p
            opts.append((lab, R, q, first_order_rows(J, qW, fq)))
        subs.append((name, opts))
    verdicts, nb = {}, 0
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
        key = '|'.join(lab)
        if Sb.shape[0] == 0 or key in verdicts:
            continue
        nb += 1
        info = land_on_branch(d, basis, mons, Sb, key, 'b%d' % nb)
        verdicts[key] = info
        print('  d=%2d %-40s dim %2d k %d vars %3d -> %-18s %s'
              % (d, key, info['dim'], info['k_eff'], info['nvars'], info['verdict'],
                 info.get('msolve', '')))
    bad = [k for k, v in verdicts.items() if v['verdict'] not in ('EMPTY', 'ZEROMAP')]
    out[d] = {'K': K, 'branches_nonzero': len(verdicts), 'verdicts': verdicts,
              'unresolved': bad, 'secs': round(time.time() - t0, 1)}
    print('d=%2d : %d nonzero branches, %d unresolved  (%.0fs)'
          % (d, len(verdicts), len(bad), time.time() - t0))
    check('land_d%d_p%d' % (d, p), not bad,
          'all %d branches EMPTY' % len(verdicts) if not bad else 'unresolved: %s' % bad)
    json.dump(out, open(os.path.join(HERE, 'payload', 'land_p%d_%d_%d.json'
                                     % (p, DLO, DHI)), 'w'), indent=1)
print(json.dumps({d: {'unresolved': out[d]['unresolved']} for d in out}, indent=1))
