#!/usr/bin/env python3
"""FIX-N2C: the same treatment for the lam = om (or om^2) eigenblock at r = 7.

usage:  lam_om.py [om|om2]   (default: om)

The nine F_100057 points of `msolve/C2_ff100057_om_B5.out` again span only a
3-dimensional affine subspace.  Here the nine relation coefficients are
RECONSTRUCTED EXACTLY (as a + b*om with small integers a,b, verified mod p),
not read off by eye, and then substituted into the exact system over K.
"""
import os
import sys

import decode_param as D
import n2c_systems as S
import n2b_lib as L
from n2b_lib import ONE, OM, ZERO
from fractions import Fraction as Fr

HERE = os.path.dirname(os.path.abspath(__file__))
P, OMP, KPP = 100057, 1140, 74361


def recon(v, bound=8):
    """v mod p  ->  the unique small a + b*om  (a,b integers, |a|,|b| <= bound)."""
    out = []
    for a in range(-bound, bound+1):
        for b in range(-bound, bound+1):
            if (a + b*OMP) % P == v % P:
                out.append((a, b))
    if len(out) != 1:
        return None
    return out[0]


def relations(par, ms):
    names, _, polys = D.parse_system(ms)
    d = D.read_param(par)
    rest = d[1][5]
    elim = rest[1][0][1]
    nums = [t[0][1] for t in rest[1][2]]
    pts = []
    for t in D.roots_fp(elim, P):
        v = [-D.poly_eval(nc, t, P) % P for nc in nums] + [t]
        if all(q == 0 for q in D.evaluate(polys, v, P)):
            pts.append(v)
    n = len(names)
    ncol = n + 1
    piv = {}
    for r0 in [[1]+list(v) for v in pts]:
        r = {i: c % P for i, c in enumerate(r0) if c % P}
        while r:
            c = min(r)
            if c not in piv:
                inv = pow(r[c], P-2, P)
                piv[c] = {k: v*inv % P for k, v in r.items()}
                break
            pr, f = piv[c], r[c]
            for k, v in pr.items():
                w = (r.get(k, 0) - v*f) % P
                if w:
                    r[k] = w
                else:
                    r.pop(k, None)
    for c in sorted(piv, reverse=True):
        rr = piv[c]
        for c2 in sorted(k for k in rr if k != c and k in piv):
            pr, f = piv[c2], rr[c2]
            for k, v in pr.items():
                w = (rr.get(k, 0) - v*f) % P
                if w:
                    rr[k] = w
                else:
                    rr.pop(k, None)
        piv[c] = rr
    free = [c for c in range(ncol) if c not in piv]
    lab = ['B5'] + names
    rels = []
    for f in free:
        vec = [0]*ncol
        vec[f] = 1
        for c, r in piv.items():
            if f in r:
                vec[c] = (-r[f]) % P
        rr = {}
        for i, v in enumerate(vec):
            if v == 0:
                continue
            ab = recon(v)
            if ab is None:
                return None, None, 'coefficient %d of %s not small' % (v, lab[i])
            rr[lab[i]] = ab
        rels.append(rr)
    return names, rels, None


def kelt(ab):
    a, b = ab
    return (Fr(a), Fr(b), Fr(0), Fr(0))


def main():
    tag = sys.argv[1] if len(sys.argv) > 1 else 'om'
    stem = {'om': 'C2_ff100057_om_B5', 'om2': 'C3_ff100057_om2_B5'}[tag]
    names, rels, err = relations(
        os.path.join(HERE, 'msolve', stem + '.out'),
        os.path.join(HERE, 'msolve', stem + '.ms'))
    if err:
        print('RECONSTRUCTION FAILED:', err)
        return 1
    print('nine exactly reconstructed relations (lam = %s), a+b*om notation:' % tag)
    free_vars = []
    subst = {}
    for rr in rels:
        # the relation's "own" variable is the one with coefficient exactly 1
        # and largest index in b.names order; take the last such
        own = [k for k, ab in rr.items() if ab == (1, 0)]
        target = own[-1]
        expr = {k: ab for k, ab in rr.items() if k != target}
        subst[target] = expr
        print('   %-3s = %s' % (target, ' + '.join(
            '(%d%+d om)*%s' % (-a, -b, k) for k, (a, b) in expr.items())))
    b, gens = S.system(7, S.LAMS[tag], orbit_reduce=False)
    idx = {nm: i for i, nm in enumerate(b.names)}
    n = len(b.names)

    def var(nm, c):
        e = [0]*n
        e[idx[nm]] = 1
        return {tuple(e): c}

    polys = list(gens)
    for nm, expr in subst.items():
        e = {}
        for k, ab in expr.items():
            e = S.p_add(e, var(k, L.kneg(kelt(ab))))
        polys = [S.p_substitute(q, idx[nm], e) for q in polys]
    polys = [q for q in polys if q]
    keep = [nm for nm in b.names if nm not in subst]
    drop = {idx[nm] for nm in subst}
    polys = [S.p_drop(q, drop) for q in polys]
    print('reduced variables:', keep)
    seen, uq = set(), []
    for q in polys:
        k = tuple(sorted(q.items()))
        if k not in seen:
            seen.add(k)
            uq.append(q)
    print('%d distinct equations after substitution' % len(uq))
    # normalise P0 = 1 and hand to Macaulay2 over the exact number field
    i0 = keep.index('P0')
    dh = [S.p_setvar(q, i0, ONE) for q in uq]
    dh = [S.p_drop(q, {i0}) for q in dh if q]
    nm2 = [x for x in keep if x != 'P0']
    lines = []
    for q in dh:
        t = []
        for k, v in sorted(q.items()):
            mon = '*'.join('%s^%d' % (nm2[i], e) if e > 1 else nm2[i]
                           for i, e in enumerate(k) if e)
            t.append('(%s)%s' % (L.kstr(v), '*'+mon if mon else ''))
        lines.append('+'.join(t))
    src = ['A = QQ[om,kp];',
           'K = toField(A/ideal(om^2+om+1, 8*kp^2-13*kp-4));',
           'R = K[%s, MonomialOrder=>Lex];' % ','.join(nm2),
           'I = ideal(\n  %s\n);' % ',\n  '.join(lines),
           'G = flatten entries gens gb I;',
           'stdio << "ONE-IN-I " << ((1_R % I)==0) << endl;',
           'stdio << "DIM " << dim I << " DEGREE " << degree I << endl;',
           'scan(G, g -> stdio << "GBELT " << toString g << endl);',
           'stdio << "M2-DONE" << endl;', 'exit 0']
    dst = os.path.join(HERE, 'm2', 'RED_nf_%s_P0eq1.m2' % tag)
    src.insert(-3, 'stdio << "B5-NONZERO " << ((1_R % (I + ideal(B5)))==0) << endl;')
    open(dst, 'w').write('\n'.join(src)+'\n')
    print('wrote %s  (vars %s, %d eqs)' % (dst, nm2, len(dh)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
