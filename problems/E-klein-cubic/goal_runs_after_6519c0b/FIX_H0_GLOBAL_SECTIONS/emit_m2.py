#!/usr/bin/env python3
"""Emit m2/eplane_smooth.m2: E_sigma = X cap P(W+_sigma) is a SMOOTH plane
cubic for all 55 involutions -- hence of genus 1, hence contains no rational
curve.  This is the third ingredient of Theorem H0-1 (the other two are the
sigma-parity of F and the absence of C_G(sigma)-fixed points on P(W+)/P(W-)).

Independent of FIX-A0's two elementary certificates and of FIX-A1's AUX-M2
run: the cubics are re-derived here from the rebuilt Weil representation.
All coefficients are emitted as bare integer combinations of a = zeta_11
divided by an integer -- no parenthesised coefficient expressions, per the
msolve landmine note (M2 parses parentheses correctly, but we keep the
discipline).
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from klein_exact import Cyc, ZERO, ONE, Grp, nullspace, Poly

NDEG = len(Cyc().n)


def eigbasis(M, sign):
    rows = [[M[i][j] - (Cyc.from_int(sign) if i == j else ZERO)
             for j in range(5)] for i in range(5)]
    return nullspace(rows, 5)


def klein_poly(c, nv):
    tot = Poly(nv=nv)
    for k in range(5):
        tot = tot + c[k] * c[k] * c[(k + 1) % 5]
    return tot


def restrict_F(basis, nv):
    coords = []
    for i in range(5):
        p = Poly(nv=nv)
        for k in range(nv):
            mono = tuple(1 if j == k else 0 for j in range(nv))
            p = p + Poly({mono: basis[k][i]}, nv=nv)
        coords.append(p)
    return klein_poly(coords, nv).c


def cyc_str(v):
    terms = []
    for i, n in enumerate(v.n):
        if n == 0:
            continue
        terms.append('%d*a^%d' % (n, i) if i else '%d' % n)
    if not terms:
        return '0'
    s = '+'.join(terms).replace('+-', '-')
    return '(%s)/%d' % (s, v.d) if v.d != 1 else '(%s)' % s


def main():
    G = Grp()
    invs = [i for i in range(G.n) if G.ord[i] == 2]
    lines = []
    lines.append('-- FIX-H0: smoothness of the 55 plus-plane cubics E_sigma')
    lines.append('R = QQ[a]/ideal(a^10+a^9+a^8+a^7+a^6+a^5+a^4+a^3+a^2+a+1);')
    lines.append('K = toField R;')
    lines.append('S = K[w0,w1,w2];')
    lines.append('bad = 0;')
    for k, s in enumerate(invs):
        Wp = eigbasis(G.mats[s], 1)
        C = restrict_F(Wp, 3)
        terms = []
        for mono, coef in C.items():
            if coef.is_zero():
                continue
            mstr = '*'.join('w%d^%d' % (i, e) for i, e in enumerate(mono) if e)
            terms.append('%s*%s' % (cyc_str(coef), mstr))
        lines.append('C%d = %s;' % (k, ' + '.join(terms)))
        lines.append('J%d = ideal jacobian ideal C%d;' % (k, k))
        lines.append('if dim J%d != 0 then bad = bad + 1;' % k)
    lines.append('print("n_cubics = " | toString %d);' % len(invs))
    lines.append('print("n_singular = " | toString bad);')
    lines.append('if bad == 0 then print "FIX_H0_EPLANE_SMOOTH_OK" '
                 'else print "FIX_H0_EPLANE_SMOOTH_FAIL";')
    os.makedirs(os.path.join(HERE, 'm2'), exist_ok=True)
    path = os.path.join(HERE, 'm2', 'eplane_smooth.m2')
    with open(path, 'w') as f:
        f.write('\n'.join(lines) + '\n')
    src = open(path).read()
    print('wrote', path, len(src), 'bytes')


if __name__ == '__main__':
    main()
