#!/usr/bin/env python3
"""Independent verifier for FIX-VIII-A5LADDER.

Re-derives, at BOTH primes and with DIFFERENT random seeds:

 1. G660 and the A5 subgroup, from the GATE generators, with its own group
    code   (CHECK v_group, v_a5).
 2. The A5-Molien table for Hom(S^d W, W)^{A5} by the MOLIEN SERIES
    (coefficient extraction from prod (1 - t*lam_i)^{-1}), which is a
    different computation from the Newton/h_d recursion used in stage 1
    (CHECK v_molien_agrees).
 3. Covariant spaces: K independent maps are built with fresh seeds and each
    is tested explicitly for T(gx) = g T(x) at random points; with K equal to
    the independent Molien count this certifies dim M_d^{A5} = K
    (CHECK v_dims).
 4. The geometric hypotheses of the fixed-locus reduction: F|_{V-} == 0
    exactly, F(v0) != 0, F|_{W_chi0} != 0, and C+ = X cap P(V+) SMOOTH --
    the last verified with MACAULAY2, not msolve (CHECK v_cplus_smooth);
    plus the orbit-size facts that license the pairwise-plane conditions
    (CHECK v_orbit15).
 5. The reduction itself with fresh seeds, and the LAND cone solve on every
    surviving branch with MORE sample points than the main run (>= 80 and
    >= 6*nvars), asserting the origin-only verdict (CHECK v_land_d<d>).
 6. The exact landing identity for every 1-dimensional branch (CHECK
    v_identity_d<d>).

Usage:  python3 verifier.py [p ...]      (default: 67 199)
"""
import sys, os, json, subprocess, itertools, time
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, 'scripts'))
from a5lib import (mm, rref, rank_p, inv_p, klein_F, monlist, monmat, load_gens,
                   covariant_basis, check_equivariance, group_closure, order_of)
from loci import (Loci, restrict, apply_condition, jac_values, first_order_rows,
                  apply_fq_rows)
from land import (cubic_rows, write_ms, write_ms_ext, run_msolve, gb_verdict,
                  full_identity)
from stage3_land import subfield_of, sub_fq          # reused helpers

FAILS = []
LOG = open(os.path.join(HERE, 'results', 'verifier.log'), 'w')


def check(name, ok, detail=''):
    line = 'CHECK %-24s %s  %s' % (name, 'PASS' if ok else 'FAIL', detail)
    print(line)
    LOG.write(line + '\n')
    LOG.flush()
    if not ok:
        FAILS.append(name)
    return ok


# ---------------------------------------------------------------- 1. group/A5
def own_closure(gens, p):
    """independent BFS closure (dict of byte keys -> matrix)"""
    I = np.eye(5, dtype=np.int64)
    tab = {I.tobytes(): I}
    front = [I]
    while front:
        nxt = []
        for A in front:
            for g in gens:
                B = (np.asarray(g, dtype=np.int64) @ A) % p
                if B.tobytes() not in tab:
                    tab[B.tobytes()] = B
                    nxt.append(B)
        front = nxt
    return list(tab.values())


def own_order(M, p):
    I = np.eye(5, dtype=np.int64)
    A, k = M % p, 1
    while not np.array_equal(A, I):
        A = A @ M % p
        k += 1
    return k


# ------------------------------------------------------------- 2. Molien series
def molien_series(dmax):
    """dim Hom(S^d W, W)^{A5} from  sum_c |c| chi_W(c) / det(1 - t rho(c))."""
    import mpmath as mp
    mp.mp.dps = 60
    w = mp.e ** (2 * mp.pi * mp.mpc(0, 1) / 3)
    z5 = [mp.e ** (2 * mp.pi * mp.mpc(0, 1) * k / 5) for k in range(5)]
    EIG = {'1': [mp.mpf(1)] * 5, '2': [mp.mpf(1)] * 3 + [mp.mpf(-1)] * 2,
           '3': [mp.mpf(1), w, w, w ** 2, w ** 2], '5A': z5, '5B': z5}
    SZ = {'1': 1, '2': 15, '3': 20, '5A': 12, '5B': 12}
    CHI = {'1': 5, '2': 1, '3': -1, '5A': 0, '5B': 0}
    tot = [mp.mpf(0)] * (dmax + 1)
    for c, ev in EIG.items():
        # series of prod 1/(1 - lam t) by repeated polynomial division
        ser = [mp.mpf(1)] + [mp.mpf(0)] * dmax
        for lam in ev:
            new = [mp.mpf(0)] * (dmax + 1)          # multiply by sum lam^j t^j
            acc = mp.mpf(0)
            for j in range(dmax + 1):
                acc = acc * lam + ser[j]
                new[j] = acc
            ser = new
        for j in range(dmax + 1):
            tot[j] += SZ[c] * CHI[c] * ser[j]
    out = []
    for j in range(dmax + 1):
        v = tot[j] / 60
        r = int(mp.nint(mp.re(v)))
        assert abs(v - r) < 1e-25, (j, v)
        out.append(r)
    return out


# --------------------------------------------------------------------- driver
def verify_prime(p, seed):
    print('\n================ p = %d  (verifier seed %d) ================' % (p, seed))
    rng = np.random.default_rng(seed)
    gens = load_gens(p)
    G = own_closure(gens, p)
    check('v_group_p%d' % p, len(G) == 660, 'closure %d' % len(G))
    prof = {}
    for M in G:
        o = own_order(M, p)
        prof[o] = prof.get(o, 0) + 1
    check('v_orderprofile_p%d' % p, prof == {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120},
          str(sorted(prof.items())))
    lam = set()
    for M in G[::37]:
        for _ in range(6):
            x = rng.integers(0, p, size=5).astype(np.float64)
            fx = klein_F(x, p)
            if fx:
                lam.add(klein_F(mm(np.asarray(M, dtype=np.float64), x, p).ravel(), p)
                        * pow(fx, p - 2, p) % p)
    check('v_preserves_F_p%d' % p, lam == {1}, 'multipliers %s' % sorted(lam))

    Gf = [np.asarray(M, dtype=np.float64) for M in G]
    from a5lib import find_A5
    a, b, H = find_A5(Gf, p)
    ninv = sum(1 for M in H if order_of(M, p) == 2)
    check('v_a5_p%d' % p, len(H) == 60 and ninv == 15,
          'order %d, %d involutions' % (len(H), ninv))

    mol_ref = molien_series(12)
    from a5lib import a5_molien
    check('v_molien_agrees_p%d' % p, mol_ref[1:] == a5_molien(12)[1:],
          'Molien-series table %s' % mol_ref[1:])

    L = Loci(p, a, b, H)
    fq = L.fq
    check('v_vminus_on_X_p%d' % p, all(v % p == 0 for v in L.cb_Vm),
          'F|_{V-} coefficients %s' % L.cb_Vm)
    check('v_Fv0_nonzero_p%d' % p, L.F_v0 % p != 0, 'F(v0) = %d' % L.F_v0)
    check('v_W0cubic_nonzero_p%d' % p, any(v % p for v in L.cb_W0), str(L.cb_W0))
    check('v_cplus_smooth_p%d' % p, *m2_smooth(L, p))
    check('v_orbit15_p%d' % p, *orbit_facts(L, H, p))

    bases, dims = {}, {}
    for d in range(1, 13):
        bs, mons, _ = covariant_basis(d, p, a, b, rng, target=mol_ref[d])
        ok, tot = check_equivariance(bs, mons, a, b, p, rng, ntest=3)
        assert ok == tot, (d, ok, tot)
        bases[d] = bs
        dims[d] = bs.shape[0]
    check('v_dims_p%d' % p, [dims[d] for d in range(1, 13)] == mol_ref[1:],
          'dims %s (each basis element passes T(gx)=gT(x))' % [dims[d] for d in range(1, 13)])

    summary = {}
    for d in range(2, 13):
        t0 = time.time()
        basis = bases[d].astype(np.float64)
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
        spaces, seen = [], set()
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
            if Sb.shape[0] == 0:
                continue
            h = fq.rref(Sb.reshape(Sb.shape[0], -1, fq.k))[0].astype(np.int64).tobytes()
            if h in seen:
                continue
            seen.add(h)
            spaces.append(('|'.join(lab), Sb))
        bad, ident = [], 0
        for key, Sb in spaces:
            v = land_branch(d, basis, mons, Sb, fq, p, rng, key)
            if v['verdict'] == 'EMPTY-IDENTITY':
                ident += 1
            if v['verdict'] not in ('EMPTY', 'EMPTY-IDENTITY', 'ZEROMAP'):
                bad.append((key, v))
        summary[d] = {'K': K, 'branches': len(spaces), 'unresolved': len(bad),
                      'dim1_identity': ident, 'secs': round(time.time() - t0, 1)}
        check('v_land_d%d_p%d' % (d, p), not bad,
              '%d branch spaces, all origin-only (%d settled by exact identity)'
              % (len(spaces), ident) if not bad else 'unresolved %s' % [k for k, _ in bad])
    return summary


def land_branch(d, basis, mons, S, fq, p, rng, key):
    r = S.shape[0]
    keff, idx = subfield_of(S, fq)
    sub = sub_fq(idx, fq) if keff > 1 else None
    Ssub = S[:, :, idx] if keff > 1 else S[:, :, [0]]
    Bm = np.transpose(np.tensordot(Ssub, basis, axes=([1], [0])) % p, (0, 2, 3, 1))
    if r == 1:
        C = Bm[0] if keff > 1 else Bm[0][:, :, 0]
        if not np.any(C % p):
            return {'verdict': 'ZEROMAP'}
        ok, nz, npts = full_identity(C, p, d=d, tab=(sub.tab if keff > 1 else None))
        return {'verdict': 'HIT' if ok else 'EMPTY-IDENTITY', 'grid_nonzero': nz}
    nvar = r if keff == 1 else r + 1
    npts = max(80, 6 * r * keff)                    # MORE points than the main run
    ms = os.path.join(HERE, 'results', 'v_land_d%d_p%d_%s.ms'
                      % (d, p, abs(hash(key)) % 10 ** 8))
    if keff == 1:
        rows, monsl = cubic_rows(Bm[:, :, :, 0], mons, p, npts, rng, tab=None)
        R, _ = rref(np.array(rows, dtype=np.float64), p)
        if R.shape[0] == 0:
            return {'verdict': 'ALL-CUBICS-VANISH'}
        write_ms([[int(v) for v in row] for row in R], monsl, nvar, p, ms)
    else:
        rows, monsl = cubic_rows(Bm, mons, p, npts, rng, tab=sub.tab)
        R, _ = rref(np.array(rows).reshape(len(rows), -1), p)
        if R.shape[0] == 0:
            return {'verdict': 'ALL-CUBICS-VANISH'}
        write_ms_ext(R.reshape(R.shape[0], -1, keff), monsl, r, p, sub.tab, ms)
    st, body = run_msolve(ms, ms.replace('.ms', '.out'), 900, gb=True)
    if st != 'OK':
        return {'verdict': st}
    return {'verdict': gb_verdict(body, r), 'gb': body[:100]}


def m2_smooth(L, p):
    """C+ = X cap P(V+) smooth, checked with Macaulay2 (independent of msolve)."""
    Vp = L.Vp
    mons3 = [(i, j, 3 - i - j) for i in range(3, -1, -1) for j in range(3 - i, -1, -1)]
    rng = np.random.default_rng(31337)
    pts = rng.integers(0, p, size=(len(mons3), 3)).astype(np.float64)
    A = np.array([[pow(int(q[0]), m[0], p) * pow(int(q[1]), m[1], p)
                   * pow(int(q[2]), m[2], p) % p for m in mons3] for q in pts])
    Ai = inv_p(A, p)
    if Ai is None:
        return False, 'singular interpolation'
    rhs = np.array([klein_F((q @ Vp) % p, p) for q in pts], dtype=np.float64)
    co = [int(v) % p for v in mm(Ai, rhs[:, None], p).ravel()]
    names = ['s', 't', 'u']
    F = '+'.join('%d*%s' % (c, '*'.join('%s^%d' % (names[i], m[i])
                                        for i in range(3) if m[i]))
                 for c, m in zip(co, mons3) if c)
    src = ('R = ZZ/%d[s,t,u]\nF = %s\nJ = ideal jacobian ideal F\n'
           '<< "SMOOTH " << (dim J <= 0) << " codimJ " << codim J << endl\n'
           'exit 0\n' % (p, F))
    path = os.path.join(HERE, 'results', 'v_cplus_p%d.m2' % p)
    open(path, 'w').write(src)
    try:
        out = subprocess.run(['M2', '--script', path], capture_output=True,
                             text=True, timeout=600).stdout
    except Exception as e:
        return False, 'M2 failed: %s' % e
    return ('SMOOTH true' in out), out.strip().replace('\n', ' ')[:90]


def orbit_facts(L, H, p):
    """(i) the A5-orbit of [W_chi1] has size 15; (ii) the order-3 element of
    A4 = N(V4) acts on W_chi0 with two distinct eigenvalues, so it 3-cycles the
    three roots of F|_{W_chi0} and fixes none.  Both license the pairwise-plane
    conditions T = 0 on V+(a) cap V+(a')."""
    q = L.W1[0]
    orb = set()
    for M in H:
        v = mm(np.asarray(M, dtype=np.float64), q[:, None], p).ravel() % p
        nz = next(int(t) for t in v if t)
        orb.add(tuple(int(t) * pow(nz, p - 2, p) % p for t in v))
    V4 = [M for M in H if np.array_equal(mm(M, L.a, p), mm(L.a, M, p))]
    g3 = None
    for M in H:
        if order_of(M, p) != 3:
            continue
        if all(any(np.array_equal(mm(mm(M, S, p), inv_p(M, p), p), T)
                   for T in V4) for S in V4):
            g3 = M
            break
    if g3 is None:
        return False, 'no order-3 normaliser of V4 found'
    W0 = L.W0
    sol = np.linalg.lstsq if False else None
    # matrix of g3 on W_chi0 in the basis W0
    img = mm(W0, np.asarray(g3, dtype=np.float64).T, p)
    from plane import coord_solver
    Mg = coord_solver(W0 % p, p)(img)                    # 2 x 2
    tr, det = (Mg[0, 0] + Mg[1, 1]) % p, (Mg[0, 0] * Mg[1, 1] - Mg[0, 1] * Mg[1, 0]) % p
    disc = (tr * tr - 4 * det) % p
    scalar = (Mg[0, 1] % p == 0 and Mg[1, 0] % p == 0 and Mg[0, 0] % p == Mg[1, 1] % p)
    return (len(orb) == 15 and not scalar,
            'orbit([W_chi1]) = %d, g3|W_chi0 scalar = %s (tr %d det %d disc %d)'
            % (len(orb), scalar, tr, det, disc))


if __name__ == '__main__':
    primes = [int(x) for x in sys.argv[1:]] or [67, 199]
    allsum = {}
    for i, p in enumerate(primes):
        allsum[p] = verify_prime(p, seed=101 + 7 * i)
    json.dump(allsum, open(os.path.join(HERE, 'payload', 'verifier_summary.json'), 'w'),
              indent=1)
    print('\nVERIFIER: %s' % ('ALL PASS' if not FAILS else 'FAILURES: %s' % FAILS))
    sys.exit(1 if FAILS else 0)
