#!/usr/bin/env python3
"""FIX-H2 TASK B: the CHARACTERISTIC-ZERO form of the (1,6) positive-line-degree
problem -- exactly the upgrade FIX-H1 STATUS.md section 6b specifies.

FIX-H1 decided line degrees 3, 4, 5 only MODULO p = 100057, over the 144
ordered pairs of the 24 exact r=6 cone lines, and mod-p emptiness does not
lift.  The specified upgrade replaces the 144 pointwise pairs by
FOUR runs per (n, lam) -- branch of T_0 times branch of T_n -- carrying the
endpoint parameters B_0, B_n as VARIABLES together with their minimal
polynomials, so that one run covers all six B-roots at once and is rigorous in
characteristic zero by the same Galois-transitivity argument as (1,8).

THE EXACT CONE LINES (transcribed from FIX-N2B `probe_family.cone_lines_r6`,
which FIX-H1 re-checked, and re-derived symbolically here).  For lam in
{om, om2} put kap = kp+ when lam = om2 and kap = km = 13/8 - kp+ when lam = om.
The 12 lines of the r=6 cone in E_lam are indexed by a branch in {A, B} and by
a root B of

        B^6 - (kap+2) B^3 + 1 = 0        (i.e. B^3 + B^-3 = kap+2)

-- the FIX-H0 trace curve -- with, writing the full-space coordinates as
P0..P6 | R0..R6 | C0_0..C0_5 | C1_* | C2_* ,

        head := R3 (lam = om)  or  P3 (lam = om2) ,   v[head] = -1
        branch A :  C0_4 = 1, C0_2 = B, C0_1 = B^-1
        branch B :  C0_0 = 1, C0_1 = B, C0_2 = B^-1
        C1 = lam^-1 sigma C0 ,  C2 = lam^-1 sigma C1 .

B^-1 is POLYNOMIAL in B: from B^6 - (kap+2)B^3 + 1 = 0,
        B^-1 = (kap+2) B^2 - B^5 ,
so the whole line is polynomial in B over K and no field inversion is needed.

THE LEVEL SYSTEM.  T = sum_{j=0}^n s^{n-j} t^j T_j with T_j in E_{mu_j},
mu_j = lam om^{-(n+j)} (FIX-H1 holes_ld, reproducing FIX-N2B section 2.4).
F(T) = 0 splits by (s,t)-bidegree into levels l = 0..3n; level 0 is F(T_0) = 0
and level 3n is F(T_n) = 0, both automatic for cone lines (ASSERTED here,
symbolically in B -- this is the build's own correctness check).  The unknowns
are the coefficients of T_1..T_{n-1} in their eigenblock bases.

VERDICT SHAPE.  For each plane-order-1 coordinate v of each T_j the
Rabinowitsch system  I + (v*zz - 1)  goes to the char-0 engines; `v is forced
to zero' iff that ideal is (1).

usage:
  h2_taskB.py sizes  [n]              -- system sizes for each (n, lam, branches)
  h2_taskB.py check  [n]              -- validate the exact build against
                                         FIX-H1's mod-p system (harness test)
  h2_taskB.py emit   n lam bA bB      -- write the msolve/M2 inputs
  h2_taskB.py run    n lam [--timeout=SEC]
"""
import os
import sys
import time

import h2_engines as E
import holes_lib as H
import holes_ld as LD
import fullspace as FS
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE, OM, OM2, ZERO, KP, KM

KAP = {'om': KM, 'om2': KP}          # which root the block carries


# --------------------------------------------------------------------------
# exact polynomials in the variables  [unknowns..., B0, Bn]  over K
# --------------------------------------------------------------------------
def pconst(c, nv):
    return {tuple([0] * nv): c} if not L.kiszero(c) else {}


def pvar(i, nv, c=ONE):
    e = [0] * nv
    e[i] = 1
    return {tuple(e): c}


def reduce_B(q, iB, kap, nv):
    """reduce modulo the endpoint minimal polynomial  B^6 = (kap+2)B^3 - 1.

    Legitimate: that polynomial is one of the ideal's own generators, so
    reducing by it changes neither the ideal nor the variety; it only keeps
    the B-degree below 6.
    """
    c3 = L.kadd(kap, L.kscal(2, ONE))
    out = dict(q)
    while True:
        hi = [k for k in out if k[iB] >= 6]
        if not hi:
            return {k: v for k, v in out.items() if not L.kiszero(v)}
        for k in hi:
            v = out.pop(k)
            k3 = list(k)
            k3[iB] -= 3
            k0 = list(k)
            k0[iB] -= 6
            for kk, cc in ((tuple(k3), L.kmul(v, c3)),
                           (tuple(k0), L.kneg(v))):
                nvv = L.kadd(out.get(kk, ZERO), cc)
                if L.kiszero(nvv):
                    out.pop(kk, None)
                else:
                    out[kk] = nvv


def cone_line(fs, lam_tag, branch, iB, nv):
    """the exact r=6 cone line as a list of fs.n polynomials in variable iB."""
    kap = KAP[lam_tag]
    lam = H.LAMS[lam_tag]
    lami = L.kinv_of_root_of_unity(lam)
    idx = {n: i for i, n in enumerate(fs.names)}
    v = [dict() for _ in range(fs.n)]
    head = 'R3' if lam_tag == 'om' else 'P3'
    v[idx[head]] = pconst(L.kneg(ONE), nv)
    # B^-1 = (kap+2) B^2 - B^5
    Binv = {}
    e2 = [0] * nv
    e2[iB] = 2
    e5 = [0] * nv
    e5[iB] = 5
    Binv[tuple(e2)] = L.kadd(kap, L.kscal(2, ONE))
    Binv[tuple(e5)] = L.kneg(ONE)
    B1 = pvar(iB, nv)
    if branch == 'A':
        c = {'C0_4': pconst(ONE, nv), 'C0_2': B1, 'C0_1': Binv}
    else:
        c = {'C0_0': pconst(ONE, nv), 'C0_1': B1, 'C0_2': Binv}
    for nm, val in c.items():
        v[idx[nm]] = dict(val)
    for j in (1, 2):
        for i, mo in enumerate(fs.su):
            src = fs.su.index((mo[1], mo[2], mo[0]))       # sigma^{-1} mo
            v[idx['C%d_%d' % (j, i)]] = S.p_scal(
                v[idx['C%d_%d' % (j - 1, src)]], lami)
    return v


def unknown_vectors(fs, lam_tag, nv, off):
    """T_j as fs.n polynomials, linear in the unknowns off..off+dim-1."""
    basis = fs.block_basis(H.LAMS[lam_tag])
    out = [dict() for _ in range(fs.n)]
    for k, b in enumerate(basis):
        for i, c in enumerate(b):
            if L.kiszero(c):
                continue
            e = [0] * nv
            e[off + k] = 1
            out[i] = S.p_add(out[i], {tuple(e): c})
    return out, len(basis)


def build(n, lam_tag, brA, brB, r=6):
    """(names, level_polys, po1_forms, minpolys, info)."""
    fs = FS.FullSpace(r, 1)
    mus = [LD.mu(lam_tag, n, j) for j in range(n + 1)]
    assert mus[0] != 'one' and mus[-1] != 'one', \
        'degenerate end: reduces to line degree %d' % (n - 1)
    dims = {t: len(fs.block_basis(H.LAMS[t])) for t in ('one', 'om', 'om2')}
    names, off = [], {}
    for j in range(1, n):
        off[j] = len(names)
        names += ['a%d_%d' % (j, i) for i in range(dims[mus[j]])]
    iB0 = len(names)
    iBn = iB0 + 1
    names = names + ['B0', 'Bn']
    nv = len(names)
    T = {}
    T[0] = cone_line(fs, mus[0], brA, iB0, nv)
    T[n] = cone_line(fs, mus[-1], brB, iBn, nv)
    for j in range(1, n):
        T[j], _ = unknown_vectors(fs, mus[j], nv, off[j])
    # F(T) expanded, graded by (U,V,W monomial, level l = j1+j2+j3)
    Lp = fs.landing_cpoly()
    acc = {}
    for mo, pc in Lp.items():
        for pm, c in pc.items():
            idxs = [i for i, e in enumerate(pm) for _ in range(e)]
            assert len(idxs) == 3
            for j1 in range(n + 1):
                if not any(T[j1][idxs[0]]):
                    continue
                for j2 in range(n + 1):
                    for j3 in range(n + 1):
                        t1 = T[j1][idxs[0]]
                        t2 = T[j2][idxs[1]]
                        t3 = T[j3][idxs[2]]
                        if not t1 or not t2 or not t3:
                            continue
                        pr = S.p_mul(S.p_mul(t1, t2), t3)
                        if not pr:
                            continue
                        pr = S.p_scal(pr, c)
                        key = (mo, j1 + j2 + j3)
                        acc[key] = S.p_add(acc.get(key, {}), pr)
    lev = {}
    for (mo, l), q in acc.items():
        q = reduce_B(reduce_B(q, iB0, KAP[mus[0]], nv), iBn, KAP[mus[-1]], nv)
        if q:
            lev.setdefault(l, []).append(q)
    # levels 0 and 3n must vanish MODULO the endpoint minimal polynomials:
    # T_0 and T_n are cone points.  (They do NOT vanish identically in B --
    # landing is exactly the statement B^3 + B^-3 = kap+2.)
    for l in (0, 3 * n):
        assert not lev.get(l), \
            ('level %d does not vanish modulo the endpoint minimal '
             'polynomial -- the cone line is wrong' % l)
    polys = []
    for l in range(1, 3 * n):
        polys += lev.get(l, [])
    import holes_reduce as RD
    polys = RD.dedup(polys)
    # plane-order-1 coordinates of each T_j, as linear forms in the unknowns
    po = fs.param_plane_orders()
    po1 = [i for i, q in enumerate(po) if q == 1]
    forms = []
    for j in range(1, n):
        for ci in po1:
            f = T[j][ci]
            if f:
                forms.append(('T%d' % j, fs.names[ci], f))
    minp = []
    # om^2+om+1 and 8kp^2-13kp-4 are added by the emitter (om, kp are its
    # own extra variables); here only the two endpoint minimal polynomials.
    for iB, tag in ((iB0, mus[0]), (iBn, mus[-1])):
        kap = KAP[tag]
        e6 = [0] * nv
        e6[iB] = 6
        e3 = [0] * nv
        e3[iB] = 3
        minp.append({tuple(e6): ONE,
                     tuple(e3): L.kneg(L.kadd(kap, L.kscal(2, ONE))),
                     tuple([0] * nv): ONE})
    info = {'mus': mus, 'dims': [dims[m] for m in mus], 'nvars': nv,
            'nlevels': 3 * n - 1, 'npolys': len(polys), 'npo1': len(forms)}
    return names, polys, forms, minp, info


# --------------------------------------------------------------------------
def sizes(nmax=6):
    print('=== FIX-H2 TASK B: exact char-0 (1,6) line-degree systems ===')
    for n in range(3, nmax + 1):
        for lam in ('one', 'om', 'om2'):
            mus = [LD.mu(lam, n, j) for j in range(n + 1)]
            if mus[0] == 'one' or mus[-1] == 'one':
                continue
            for brA in ('A', 'B'):
                for brB in ('A', 'B'):
                    t0 = time.time()
                    nm, pl, fo, mp, info = build(n, lam, brA, brB)
                    print('  n=%d lam=%-4s T0-branch %s / Tn-branch %s : '
                          'mu=%s dims=%s | %d vars (+om,kp) | %d gens | '
                          '%d po1-forms | %.1f s'
                          % (n, lam, brA, brB, info['mus'], info['dims'],
                             info['nvars'], info['npolys'], info['npo1'],
                             time.time() - t0), flush=True)


def check(n=3):
    """harness self-test: specialise the EXACT build at (om,kp,B) mod p and
    compare with FIX-H1's own mod-p construction of the same cone lines."""
    p, omp, kpp = LD.P, LD.OMP, LD.KPP
    fs = FS.FullSpace(6, 1)
    import probe_family as PF
    ok = True
    for lam_tag, lamv in (('om', OM), ('om2', OM2)):
        ref = PF.cone_lines_r6(lamv)
        nv = 2
        for (B, branch, vref) in ref:
            v = cone_line(fs, lam_tag, branch, 0, nv)
            got = []
            for q in v:
                s = 0
                for k, c in q.items():
                    tv = L.kmod_p(c, p, omp, kpp)
                    tv = tv * pow(B, k[0], p) % p
                    s = (s + tv) % p
                got.append(s)
            if got != [x % p for x in vref]:
                ok = False
                print('  MISMATCH lam=%s branch=%s B=%d' % (lam_tag, branch, B))
        print('  lam=%-4s : %d cone lines, exact build reproduces FIX-N2B/H1 '
              'mod p : %s' % (lam_tag, len(ref), 'OK' if ok else '*** FAIL'),
              flush=True)
    # and the exact levels 0 / 3n vanish identically (asserted inside build)
    for lam in ('om', 'om2'):
        mus = [LD.mu(lam, n, j) for j in range(n + 1)]
        if mus[0] == 'one' or mus[-1] == 'one':
            continue
        build(n, lam, 'A', 'A')
        print('  n=%d lam=%-4s : levels 0 and %d identically zero (cone lines '
              'land, symbolically in B) : OK' % (n, lam, 3 * n), flush=True)
    print('TASKB-CHECK %s' % ('PASS' if ok else 'FAIL'), flush=True)
    return ok


def run(n, lam, tmo=3600, only=None, mode='qq', p=100057, limit=None):
    """mode 'qq' -> characteristic zero (a VERDICT);
       mode 'ff' -> modulo p with om, kp, B_0, B_n still carried as VARIABLES
                    plus their minimal polynomials (a FINDING, but a strictly
                    stronger one than FIX-H1's: four runs cover all six roots
                    B of B^6-(kap+2)B^3+1 at once, instead of 144 pointwise
                    cone-line pairs)."""
    print('=== TASK B %s run: n=%d lam=%s ===' % (mode, n, lam), flush=True)
    nrun = 0
    allzero = True
    for brA in ('A', 'B'):
        for brB in ('A', 'B'):
            nm, pl, fo, mp, info = build(n, lam, brA, brB)
            base = list(pl) + list(mp)
            print(' branches %s/%s : %d vars (+om,kp), %d gens, %d po1-forms'
                  % (brA, brB, info['nvars'], len(base), len(fo)), flush=True)
            for (tj, cname, f) in fo:
                if only and only not in (tj, cname):
                    continue
                if limit is not None and nrun >= limit:
                    return allzero
                nv = info['nvars']
                names2 = nm + ['zz']
                fz = {tuple(list(k) + [1]): v for k, v in f.items()}
                fz[tuple([0] * (nv + 1))] = L.kneg(ONE)
                pz = [{tuple(list(k) + [0]): v for k, v in q.items()}
                      for q in base] + [fz]
                tag = 'tB_%s_n%d_%s_%s%s_%s_%s' % (mode, n, lam, brA, brB,
                                                   tj, cname)
                nrun += 1
                if mode == 'qq':
                    v, dt, i = E.qq(tag, names2, pz, timeout=tmo)
                else:
                    src = H.emit_vars(names2, pz, p)
                    rc, dt, txt = H.run_msolve(tag, src, flags=['-g', '1'],
                                               nthreads=E.NTH, timeout=tmo)
                    v = None if txt.startswith('<') else H.is_unit_ideal(txt)
                    i = txt[:120]
                print('   %-46s %s = %-5s (%.1f s) %s'
                      % (tag, mode, v, dt, '' if v is not None else i[:120]),
                      flush=True)
                if v is not True:
                    allzero = False
    print('TASK B %s n=%d lam=%s : %s (%d runs)'
          % (mode, n, lam,
             'ALL plane-order-1 coordinates FORCED ZERO'
             if allzero else 'NOT ALL FORCED ZERO / NOT-DECIDED', nrun),
          flush=True)
    return allzero


if __name__ == '__main__':
    what = sys.argv[1] if len(sys.argv) > 1 else 'sizes'
    if what == 'sizes':
        sizes(int(sys.argv[2]) if len(sys.argv) > 2 else 6)
    elif what == 'check':
        sys.exit(0 if check(int(sys.argv[2]) if len(sys.argv) > 2 else 3)
                 else 1)
    elif what == 'run':
        tmo = 3600
        for a in sys.argv:
            if a.startswith('--timeout='):
                tmo = int(a.split('=')[1])
        run(int(sys.argv[2]), sys.argv[3], tmo)
