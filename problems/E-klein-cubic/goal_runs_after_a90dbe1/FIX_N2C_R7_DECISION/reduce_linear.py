#!/usr/bin/env python3
"""FIX-N2C: substitute the linear relations satisfied by the modular
plane-order-1 points into the EXACT system over K = QQ(om,kp).

The nine F_100057-points of `msolve/B1_ff100057_one_B5.out` span only a
3-dimensional affine subspace of the 12-dimensional (B5 = 1) chart, and the
nine affine relations have visibly exact coefficients in ZZ[om]:

    R0 =  om B5 - om^2 P0
    R1 = -om P1
    B0 = -om^2 B5 - (om^2-1) P0            ( = -B8 )
    B1 = -B5
    B3 = -2 om B5 - (2om+4) P0             ( = 2(B5+B8) )
    B4 = -B2
    B6 =  om B5 - (om^2-1) P0 - (om^2+2) P1
    B7 =  om B5 - (om^2-1) P0 - (om-1) P1
    B8 =  om^2 B5 + (om^2-1) P0

Substituting them leaves a homogeneous system in the FOUR parameters
(B5, P0, P1, B2), which is small enough to be settled exactly.

Logical status: a solution found here is a genuine point of the cone (the
substitution only restricts), so it PROVES population.  Finding none proves
only that the modular points' linear span carries no characteristic-zero
point -- it is evidence, not a certificate.
"""
import sys

import n2c_systems as S
import n2b_lib as L
from n2b_lib import ONE, OM, OM2, ZERO


def build_reduced(lam='one'):
    b, gens = S.system(7, S.LAMS[lam], orbit_reduce=False)
    names = b.names
    n = len(names)
    idx = {nm: i for i, nm in enumerate(names)}

    def var(nm, c=ONE):
        e = [0]*n
        e[idx[nm]] = 1
        return {tuple(e): c}

    def lin(*terms):
        out = {}
        for c, nm in terms:
            out = S.p_add(out, var(nm, c))
        return out

    om, om2 = OM, OM2
    m1 = L.kneg(ONE)
    rel = {
        'R0':  lin((om, 'B5'), (L.kneg(om2), 'P0')),
        'R1':  lin((L.kneg(om), 'P1'),),
        'B0':  lin((L.kneg(om2), 'B5'), (L.kneg(L.ksub(om2, ONE)), 'P0')),
        'B1':  lin((m1, 'B5'),),
        'B3':  lin((L.kscal(-2, om), 'B5'),
                   (L.kneg(L.kadd(L.kscal(2, om), L.kscal(4, ONE))), 'P0')),
        'B4':  lin((m1, 'B2'),),
        'B6':  lin((om, 'B5'), (L.kneg(L.ksub(om2, ONE)), 'P0'),
                   (L.kneg(L.kadd(om2, L.kscal(2, ONE))), 'P1')),
        'B7':  lin((om, 'B5'), (L.kneg(L.ksub(om2, ONE)), 'P0'),
                   (L.kneg(L.ksub(om, ONE)), 'P1')),
        'B8':  lin((om2, 'B5'), (L.ksub(om2, ONE), 'P0')),
    }
    polys = list(gens)
    for nm, expr in rel.items():
        polys = [S.p_substitute(q, idx[nm], expr) for q in polys]
    polys = [q for q in polys if q]
    keep = ['B5', 'P0', 'P1', 'B2']
    drop = {idx[nm] for nm in names if nm not in keep}
    polys = [S.p_drop(q, drop) for q in polys]
    kept = [nm for nm in names if nm in keep]
    return kept, polys, rel, names, idx


if __name__ == '__main__':
    lam = sys.argv[1] if len(sys.argv) > 1 else 'one'
    kept, polys, rel, names, idx = build_reduced(lam)
    print('lam=%s  reduced variables: %s' % (lam, kept))
    seen = set()
    uniq = []
    for q in polys:
        key = tuple(sorted(q.items()))
        if key not in seen:
            seen.add(key)
            uniq.append(q)
    print('%d equations (%d distinct) after substitution' % (len(polys), len(uniq)))
    for q in uniq:
        print('   ' + ' + '.join(
            '(%s)*%s' % (L.kstr(v), '*'.join(
                '%s^%d' % (kept[i], e) if e > 1 else kept[i]
                for i, e in enumerate(k) if e) or '1')
            for k, v in sorted(q.items())))
