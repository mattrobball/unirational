#!/usr/bin/env python3
"""FIX-N2B: LADDER RIGIDITY (Lemma S2) -- the second t-adic level.

For a point T_0 of the C3-equivariant pointwise cone with plane order rho,
set

    KK(T_0) = { e in E_mu : Phi(T_0,T_0,e) in J_{3 rho} } .

Always  J_rho ∩ E_mu subset KK(T_0).  Lemma S2 (ladder_lib.py) says: if equality
holds at every cone point, then every A4-equivariant family of triple-line order
r has common plane order >= rho >= 2, so the cell (1,r) is EMPTY for all line
degrees.

Equality is a RANK condition.  Because  J_a J_b subset J_{a+b}, the graded
piece  [Phi(T_0,T_0,e)]_nu  for nu < 3 rho only sees
   * the parameters of T_0 of plane order >= rho, and
   * the parameters of e of plane order < rho,
so the relevant matrix  M(t)  has
   columns = parameters of plane order < rho          (the classes of e)
   rows    = U,V,W-monomials of the landing polynomial with plane order < 3 rho
   entries = quadratic forms in the parameters t of plane order >= rho.
Equality  <=>  rank M(t) = #columns.

This module builds M(t) exactly over K = QQ(om,kp) and decides the rank both
generically and on the locus where T_0 has plane order EXACTLY rho.
"""
import random
import sys

import n2b_lib as L
from n2b_lib import ONE, OM, OM2, ZERO, kadd, ksub, kmul, kiszero, kstr, Fr
from ladder_lib import plane_order_F, kinv_K

TAG = {ONE: 'one', OM: 'om', OM2: 'om2'}


def ladder_matrix(r, lam, rho):
    """(block, col_idx, t_idx, rows) with rows = list of (mo, {col: {t_mono: K}})."""
    b = L.Block(r, 1, lam)
    po = b.param_plane_orders()
    col = [i for i, p in enumerate(po) if p < rho]
    tix = [i for i, p in enumerate(po) if p >= rho]
    tpos = {i: k for k, i in enumerate(tix)}
    Lp = L.landing_cpoly(b)
    rows = []
    for mo, pc in Lp.items():
        if plane_order_F(r, mo) >= 3 * rho:
            continue
        ent = {}
        for pm, c in pc.items():
            lowc = [i for i in col if pm[i]]
            if len(lowc) != 1 or pm[lowc[0]] != 1:
                continue
            i = lowc[0]
            tm = [0] * len(tix)
            ok = True
            for j, e in enumerate(pm):
                if j == i:
                    continue
                if e == 0:
                    continue
                if po[j] < rho:
                    ok = False
                    break
                tm[tpos[j]] += e
            if not ok:
                continue
            d = ent.setdefault(i, {})
            key = tuple(tm)
            d[key] = kadd(d.get(key, ZERO), c)
        ent = {i: {k: v for k, v in d.items() if not kiszero(v)}
               for i, d in ent.items()}
        ent = {i: d for i, d in ent.items() if d}
        if ent:
            rows.append((mo, ent))
    return b, col, tix, rows


def evalmat(rows, col, ntv, tval):
    out = []
    for mo, ent in rows:
        rw = []
        for i in col:
            acc = ZERO
            for tm, c in ent.get(i, {}).items():
                v = c
                for j, e in enumerate(tm):
                    for _ in range(e):
                        v = kmul(v, tval[j])
                acc = kadd(acc, v)
            rw.append(acc)
        out.append(rw)
    return out


def rank_K(mat, ncols):
    mat = [row[:] for row in mat]
    rr = 0
    for c in range(ncols):
        pr = None
        for i in range(rr, len(mat)):
            if not kiszero(mat[i][c]):
                pr = i
                break
        if pr is None:
            continue
        mat[rr], mat[pr] = mat[pr], mat[rr]
        inv = kinv_K(mat[rr][c])
        mat[rr] = [kmul(v, inv) for v in mat[rr]]
        for i in range(rr + 1, len(mat)):
            if not kiszero(mat[i][c]):
                f = mat[i][c]
                mat[i] = [ksub(a, kmul(f, bb)) for a, bb in zip(mat[i], mat[rr])]
        rr += 1
    return rr


def qq(n):
    return (Fr(n), Fr(0), Fr(0), Fr(0))


def report(r, lam, rho, ntrials=6, seed=1):
    b, col, tix, rows = ladder_matrix(r, lam, rho)
    po = b.param_plane_orders()
    print('r=%d lam=%-4s rho=%d : columns %s (plane orders %s), '
          't-params %s (plane orders %s), %d rows'
          % (r, TAG[lam], rho, [b.names[i] for i in col], [po[i] for i in col],
             [b.names[i] for i in tix], [po[i] for i in tix], len(rows)))
    rnd = random.Random(seed)
    best = 0
    for _ in range(ntrials):
        tval = [qq(rnd.randint(-9, 9)) for _ in tix]
        rk = rank_K(evalmat(rows, col, len(tix), tval), len(col))
        best = max(best, rk)
    print('    generic rank (%d random rational t) = %d / %d'
          % (ntrials, best, len(col)))
    return b, col, tix, rows, best


def print_columns(r, lam, rho):
    """print the matrix symbolically (small cases)."""
    b, col, tix, rows = ladder_matrix(r, lam, rho)
    tn = [b.names[i] for i in tix]

    def mono(tm):
        s = '*'.join('%s^%d' % (tn[i], e) if e > 1 else tn[i]
                     for i, e in enumerate(tm) if e)
        return s or '1'
    for mo, ent in rows:
        parts = []
        for i in col:
            if i not in ent:
                continue
            s = '+'.join('(%s)%s' % (kstr(c), '*' + mono(tm))
                         for tm, c in sorted(ent[i].items()))
            parts.append('%s:[%s]' % (b.names[i], s))
        print('  U^%dV^%dW^%d (pl.ord %d)  %s'
              % (mo[0], mo[1], mo[2], plane_order_F(r, mo), '  '.join(parts)))


if __name__ == '__main__':
    r = int(sys.argv[1])
    rhos = [int(v) for v in sys.argv[2:]] or [2, 3]
    for lam in (ONE, OM, OM2):
        for rho in rhos:
            report(r, lam, rho)
