#!/usr/bin/env python3
"""FIX-U1-FIN7 -- Macaulay2 inputs: the SECOND ENGINE for the exact Jacobian
ranks at the 27 classified points, and for the non-vanishing certificates.

M2 is given the raw data only (the 52 cubics in the 39 parameters over K, the
39 point coordinates as polynomials in B2, P1) and does its own differentiation,
substitution and rank computation over `toField(QQ[om,kp,B2,P1]/(...))`.

M2 rule respected: no underscores in variable names.
"""
import os
import sys

import sympy as sp

import fin7_equiv as E
import fin7_lib as L
import fin7_points as PT
from fin7_equiv import B2s, P1s
from fin7_lib import kp, om

HERE = os.path.dirname(os.path.abspath(__file__))


def m2str(e):
    s = str(sp.expand(e))
    return s.replace('**', '^')


def build(j, part):
    names, eqs = L.landing_terms()
    l1, q1, l2, q2 = PT.block_factors(j)
    gB2 = l1 if part in ('A', 'B') else q1
    gP1 = l2 if part in ('A', 'C') else q2
    coords = E.classified_point(j)
    polys = []
    for _mon, terms in eqs:
        polys.append('+'.join(
            '(%s)*%s*%s*%s' % (m2str(c), names[i], names[jj], names[k])
            for c, (i, jj, k) in terms))
    pt = ','.join(m2str(coords[n]) for n in names)
    return ('kk = toField(QQ[om,kp,B2,P1]/ideal(om^2+om+1, 8*kp^2-13*kp-4,'
            ' %s, %s));\n'
            'R = kk[%s];\n'
            'F = {\n%s};\n'
            'pt = matrix{{%s}};\n'
            'vs = gens R;\n'
            'J = matrix apply(F, f -> apply(vs, v -> sub(diff(v,f), pt)));\n'
            'print("block=%d part=%s  size = "|toString(numrows J)|" x "'
            '|toString(numcols J));\n'
            'print("F(p) all zero : "|toString(all(F, f -> sub(f,pt) == 0)));\n'
            'print("rank J = "|toString rank J);\n'
            'print("corank = "|toString(numcols J - rank J));\n'
            'exit 0\n'
            % (m2str(gB2), m2str(gP1), ','.join(names),
               ',\n'.join(polys), pt, j, part))


if __name__ == '__main__':
    sel = sys.argv[1:] or ['%d%s' % (j, p) for j in range(3)
                           for p in PT.PARTS]
    for tag in sel:
        j, part = int(tag[0]), tag[1]
        path = os.path.join(HERE, 'm2', 'rank_j%d%s.m2' % (j, part))
        with open(path, 'w') as f:
            f.write(build(j, part))
        print('wrote', path)
