#!/usr/bin/env python3
"""FIX-N2C: emit Macaulay2 input for the dehomogenised (1,7) systems.

Two coefficient regimes, both characteristic zero and both rigorous:

  nf  : the exact degree-4 number field
        K = toField(QQ[om,kp]/(om^2+om+1, 8kp^2-13kp-4))
  qq  : QQ with om, kp adjoined as variables and their minimal polynomials
        added to the ideal (the verdict then holds for every root, hence in
        particular for the packet's (om, kp+))

usage:  make_m2.py TAG LAM VAR REGIME [extra_equations...]
"""
import os
import sys

import n2c_systems as S
import n2b_lib as L

HERE = os.path.dirname(os.path.abspath(__file__))


def m2_source(lam, var, regime, extra=(), task='unit'):
    b, polys = S.system(7, S.LAMS[lam])
    names, dh = S.dehomogenise(b, polys, var)
    lines = []
    for q in dh:
        terms = []
        for k, v in sorted(q.items()):
            mon = '*'.join('%s^%d' % (names[i], e) if e > 1 else names[i]
                           for i, e in enumerate(k) if e)
            terms.append('(%s)%s' % (L.kstr(v), '*' + mon if mon else ''))
        lines.append('+'.join(terms))
    lines.extend(extra)
    hdr = []
    if regime == 'nf':
        hdr.append('A = QQ[om,kp];')
        hdr.append('K = toField(A/ideal(om^2+om+1, 8*kp^2-13*kp-4));')
        hdr.append('R = K[%s];' % ','.join(names))
    else:
        hdr.append('R = QQ[%s,om,kp];' % ','.join(names))
        lines.append('om^2+om+1')
        lines.append('8*kp^2-13*kp-4')
    hdr.append('I = ideal(\n  %s\n);' % ',\n  '.join(lines))
    body = [
        'stdio << "-- regime %s lam %s var %s" << endl << flush;' % (regime, lam, var),
        'tGB = timing (G = gens gb I);',
        'stdio << "GBTIME " << first tGB << endl << flush;',
        'stdio << "NGENS " << numgens source G << endl << flush;',
        'u = (1_R % I);',
        'stdio << "ONE-IN-I " << (u == 0) << endl << flush;',
        'if u == 0 then ( stdio << "VERDICT UNIT-IDEAL (locus EMPTY)" << endl )',
        'else ( stdio << "VERDICT NON-UNIT dim=" << dim I << " degree=" << degree I << endl;',
        '       stdio << "GB " << toString G << endl; );',
        'stdio << "M2-DONE" << endl << flush;',
        'exit 0',
    ]
    return '\n'.join(hdr + body) + '\n'


if __name__ == '__main__':
    tag, lam, var, regime = sys.argv[1:5]
    src = m2_source(lam, var, regime, extra=sys.argv[5:])
    p = os.path.join(HERE, 'm2', tag + '.m2')
    open(p, 'w').write(src)
    print(p)
