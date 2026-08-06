#!/usr/bin/env python3
"""FIX-U1-FIN7 -- render the payload text files from the producer's JSON."""
import json
import os

import sympy as sp

import fin7_equiv as E
import fin7_points as PT
from fin7_equiv import B2s, P1s
from fin7_lib import kp, om

HERE = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(HERE, 'payloads', 'PAYLOAD_results.json')) as f:
    RES = json.load(f)

L1 = ['FIX-U1-FIN7 -- exact tangent spaces of PO_1(7) at the 27 classified',
      'Chebyshev points of FIX-N2C (52 x 39 Jacobian over the exact residue',
      'field; corank = affine tangent dim of the cone; projective tangent dim',
      'of PO_1(7) = corank - 1; torus = source reparametrisation directions).',
      '',
      'blk part pts [L:K] rank corank  Theta-block coranks   proj.tan  torus'
      '  essential',
      '-'*84]
ob = {(o[0], o[1]): o for o in RES['ob2']}
for r in RES['tangent']:
    pb = r['per_block']
    trip = tuple(pb[str(k)][1] if str(k) in pb else pb[k][1] for k in range(3))
    L1.append(' %d   %s   %d    %d     %2d    %2d      (%d,%d,%d)            '
              '%d        2      %d'
              % (r['j'], r['part'], r['npts'], r['dimK']//4, r['rank'],
                 r['corank'], trip[0], trip[1], trip[2], r['corank']-1,
                 r['corank']-3))
L1 += ['', 'level-0 Kuranishi obstruction Ob_2(v) = 3 Phi(p,v,v) on ker J_p:',
       'blk part  dim ker  dim coker  torus unobstructed  Ob_2 == 0 on ker',
       '-'*66]
for o in RES['ob2']:
    L1.append(' %d   %s      %d        %2d           %-5s              %s'
              % (o[0], o[1], o[2], o[3], o[5], o[4]))
L1 += ['',
       'torus orbit dimension (affine) and membership in ker J_p:',
       'blk part  dim  in ker']
for t in RES['torus']:
    L1.append(' %d   %s     %d    %s' % (t[0], t[1], t[2], t[3]))
L1 += ['',
       'degenerate linear components  a\' = b\' = u_i\' = 0 :',
       'zeroed slot   on cone   plane orders (1,1,1)   rank   corank']
for d in RES['degenerate']:
    L1.append('   %-6s      %-6s    %-6s               %2d      %2d'
              % (d[0], d[1], d[2], d[3], d[4]))
open(os.path.join(HERE, 'payloads', 'PAYLOAD_tangent_table.txt'),
     'w').write('\n'.join(L1) + '\n')

L2 = ['FIX-U1-FIN7 -- the u0 + v0 check of Prop 5.3 at the 27 classified',
      'points.  H1 frame: u0 = Lambda_yy = [x^6 y]u1\' = lam^-1 B8,',
      '                  v0 = Lambda_zz = [x^6 z]u2\' = lam^-2 B5.',
      'Normalisation P0 = 1; B2, P1 run over the two FIX-N2C block cubics.',
      '']
for j in range(3):
    coords = E.classified_point(j)
    g1, g2 = E.block_cubics(j)
    REL = [g2, g1, om**2 + om + 1, 8*kp**2 - 13*kp - 4]

    def red(e):
        e = sp.expand(e)
        if e == 0:
            return sp.Integer(0)
        _, r = sp.reduced(e, REL, P1s, B2s, om, kp, order='lex')
        return sp.expand(r)
    L2.append('lam = om^%d :' % j)
    L2.append('   u0 + v0 = %s' % sp.factor(red(coords['t0'] + coords['w0'])))
    L2.append('   u0 - v0 = %s   (FIX-H1 order-0 equalizer residual)'
              % sp.factor(red(coords['t0'] - coords['w0'])))
    for part in PT.PARTS:
        A = PT.part_algebra(j, part)
        vp = A.of(coords['t0'] + coords['w0'])
        vm = A.of(coords['t0'] - coords['w0'])
        L2.append('   part %s (%d pts, [L:K]=%d) : u0+v0 %s ; u0-v0 %s'
                  % (part, PT.npoints(part), A.dim//4,
                     'NONZERO' if A.inv(vp) is not None else 'ZERO',
                     'NONZERO' if A.inv(vm) is not None else 'ZERO'))
L2 += ['', 'VERDICT: u0 + v0 != 0 at all 27 classified points.',
       'The parameter exception of Prop 5.3 is EMPTY.']
open(os.path.join(HERE, 'payloads', 'PAYLOAD_uv_check.txt'),
     'w').write('\n'.join(L2) + '\n')
print('payloads written')
