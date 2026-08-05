#!/usr/bin/env python3
"""FIX-N2C: the LINEAR forms in the saturation  (I : v^infinity),  exactly.

FIX-N2B's `p = 100057` leading ideal for the `r = 7`, `lam = 1`, `B5 = 1` system
has EIGHT degree-one leading monomials (`P0,P1,R0,R1,B0,B1,B2,B3`).  Because
grevlex is a graded order, a degree-one leading monomial in a REDUCED Groebner
basis forces the whole basis element to be linear.  So, if that computation is
right, the plane-order-1 component of the cone lies in a 5-dimensional linear
subspace, i.e. the homogeneous saturation `(I : B5^oo)` contains an
8-dimensional space of LINEAR FORMS.

That is a statement decidable by pure linear algebra:

    ell  in  (I : v^oo)   <=>   v^N * ell  in  I  for some N
                          <=>   v^N * ell  in  span_K { g_i * m : deg m = N-2 }

(the g_i are the cubic generators).  For each N this is one exact linear system
over K = QQ(om, kp).  No Groebner basis, no prime, no reconstruction --
characteristic zero, rigorous, and fast.

The same routine run modulo p reproduces (or refutes) the modular finding with
an independent algorithm.
"""
import itertools
import sys

import n2c_systems as S
import n2b_lib as L
from n2b_lib import ONE, ZERO


# --------------------------------------------------------------------------
def monomials(n, d):
    """all exponent tuples of length n and total degree d."""
    if d == 0:
        return [tuple([0]*n)]
    out = []
    for c in itertools.combinations_with_replacement(range(n), d):
        e = [0]*n
        for i in c:
            e[i] += 1
        out.append(tuple(e))
    return out


def shift(poly, m):
    return {tuple(a+b for a, b in zip(k, m)): v for k, v in poly.items()}


# --------------------------------------------------------------------------
# exact Gaussian elimination over K (or over F_p when p is given)
# --------------------------------------------------------------------------
def nullspace_K(rows, ncols):
    """rows: list of dict{col: Kelt}.  Returns a basis of the right nullspace."""
    piv = {}                                   # col -> reduced row (dict)
    order = []
    for r in rows:
        r = dict(r)
        while r:
            c = min(r)
            if c not in piv:
                inv = S.kinv(r[c])
                r = {k: L.kmul(v, inv) for k, v in r.items()}
                piv[c] = r
                order.append(c)
                break
            pr = piv[c]
            f = r[c]
            for k, v in pr.items():
                w = L.ksub(r.get(k, ZERO), L.kmul(v, f))
                if L.kiszero(w):
                    r.pop(k, None)
                else:
                    r[k] = w
        # r empty -> dependent row, drop
    pivcols = set(piv)
    free = [c for c in range(ncols) if c not in pivcols]
    # back-substitute to reduced row echelon form
    for c in sorted(piv, reverse=True):
        r = piv[c]
        for c2 in sorted(k for k in r if k != c and k in pivcols):
            pr = piv[c2]
            f = r[c2]
            for k, v in pr.items():
                w = L.ksub(r.get(k, ZERO), L.kmul(v, f))
                if L.kiszero(w):
                    r.pop(k, None)
                else:
                    r[k] = w
        piv[c] = r
    basis = []
    for f in free:
        vec = [ZERO]*ncols
        vec[f] = ONE
        for c, r in piv.items():
            if f in r:
                vec[c] = L.kneg(r[f])
        basis.append(vec)
    return basis


def nullspace_p(rows, ncols, p):
    piv = {}
    for r in rows:
        r = dict(r)
        while r:
            c = min(r)
            if c not in piv:
                inv = pow(r[c], p-2, p)
                r = {k: v*inv % p for k, v in r.items()}
                piv[c] = r
                break
            pr, f = piv[c], r[c]
            for k, v in pr.items():
                w = (r.get(k, 0) - v*f) % p
                if w:
                    r[k] = w
                else:
                    r.pop(k, None)
    pivcols = set(piv)
    for c in sorted(piv, reverse=True):
        r = piv[c]
        for c2 in sorted(k for k in r if k != c and k in pivcols):
            pr, f = piv[c2], r[c2]
            for k, v in pr.items():
                w = (r.get(k, 0) - v*f) % p
                if w:
                    r[k] = w
                else:
                    r.pop(k, None)
        piv[c] = r
    basis = []
    for f in [c for c in range(ncols) if c not in pivcols]:
        vec = [0]*ncols
        vec[f] = 1
        for c, r in piv.items():
            if f in r:
                vec[c] = (-r[f]) % p
        basis.append(vec)
    return basis


# --------------------------------------------------------------------------
def linear_forms_in_saturation(lam, var, N, p=None, omp=None, kpp=None,
                               verbose=True):
    """basis of { ell linear : var^N * ell in I }.

    Returns a list of coefficient vectors (length = #parameters).
    """
    b, gens = S.system(7, S.LAMS[lam])
    names = b.names
    n = len(names)
    iv = names.index(var)
    vN = [0]*n
    vN[iv] = N
    vN = tuple(vN)

    mons = monomials(n, N-2)
    # unknowns: ell coefficients (n) then lambda_{i,m}
    cols = []
    colpolys = []
    for j in range(n):
        e = [0]*n
        e[j] = 1
        colpolys.append(shift({tuple(e): ONE}, vN))       # var^N * x_j
        cols.append(('ell', names[j]))
    for i, g in enumerate(gens):
        for m in mons:
            colpolys.append({k: L.kneg(v) for k, v in shift(g, m).items()})
            cols.append(('lam', i, m))
    # rows indexed by degree-(N+1) monomials
    rowidx = {}
    rows = {}
    for c, poly in enumerate(colpolys):
        for k, v in poly.items():
            r = rowidx.setdefault(k, len(rowidx))
            rows.setdefault(r, {})[c] = v
    rowlist = [rows[r] for r in sorted(rows)]
    if verbose:
        print('  N=%d: %d unknowns, %d rows (deg-%d monomials)'
              % (N, len(cols), len(rowlist), N+1), flush=True)
    if p is None:
        ns = nullspace_K(rowlist, len(cols))
        ells = [v[:n] for v in ns]
        ells = [e for e in ells if any(not L.kiszero(c) for c in e)]
        # re-echelonise the ell-part to get its true dimension
        red = nullspace_dim_K(ells, n)
        return names, red
    rl = []
    for r in rowlist:
        rr = {c: L.kmod_p(v, p, omp, kpp) for c, v in r.items()}
        rr = {c: v for c, v in rr.items() if v}
        if rr:
            rl.append(rr)
    ns = nullspace_p(rl, len(cols), p)
    ells = [v[:n] for v in ns]
    ells = [e for e in ells if any(e)]
    return names, rowreduce_p(ells, n, p)


def nullspace_dim_K(vs, n):
    """row-reduce a list of K-vectors; return the reduced basis."""
    piv = {}
    for v in vs:
        r = {i: c for i, c in enumerate(v) if not L.kiszero(c)}
        while r:
            c = min(r)
            if c not in piv:
                inv = S.kinv(r[c])
                piv[c] = {k: L.kmul(x, inv) for k, x in r.items()}
                break
            pr, f = piv[c], r[c]
            for k, x in pr.items():
                w = L.ksub(r.get(k, ZERO), L.kmul(x, f))
                if L.kiszero(w):
                    r.pop(k, None)
                else:
                    r[k] = w
    out = []
    for c in sorted(piv):
        vec = [ZERO]*n
        for k, x in piv[c].items():
            vec[k] = x
        out.append(vec)
    return out


def rowreduce_p(vs, n, p):
    piv = {}
    for v in vs:
        r = {i: c for i, c in enumerate(v) if c}
        while r:
            c = min(r)
            if c not in piv:
                inv = pow(r[c], p-2, p)
                piv[c] = {k: x*inv % p for k, x in r.items()}
                break
            pr, f = piv[c], r[c]
            for k, x in pr.items():
                w = (r.get(k, 0) - x*f) % p
                if w:
                    r[k] = w
                else:
                    r.pop(k, None)
    out = []
    for c in sorted(piv):
        vec = [0]*n
        for k, x in piv[c].items():
            vec[k] = x
        out.append(vec)
    return out


def show(names, ells, tostr):
    for e in ells:
        print('    ' + ' + '.join('%s*%s' % (tostr(c), nm)
                                  for c, nm in zip(e, names)
                                  if tostr(c) != '0'), flush=True)


if __name__ == '__main__':
    lam = sys.argv[1] if len(sys.argv) > 1 else 'one'
    var = sys.argv[2] if len(sys.argv) > 2 else 'B5'
    Ns = [int(a) for a in sys.argv[3:]] or [2, 3]
    for N in Ns:
        print('== char 0, exact over K = QQ(om,kp) ==', flush=True)
        names, ells = linear_forms_in_saturation(lam, var, N)
        print('  lam=%s  %s^%d :  dim of linear forms in the saturation = %d'
              % (lam, var, N, len(ells)), flush=True)
        show(names, ells, L.kstr)
        print('== mod p = 100057 (independent algorithm, same question) ==',
              flush=True)
        names, ellp = linear_forms_in_saturation(lam, var, N, p=100057,
                                                 omp=1140, kpp=74361)
        print('  lam=%s  %s^%d :  dim mod p = %d'
              % (lam, var, N, len(ellp)), flush=True)
        show(names, ellp, str)
