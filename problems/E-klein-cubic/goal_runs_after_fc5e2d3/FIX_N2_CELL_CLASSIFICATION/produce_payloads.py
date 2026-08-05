#!/usr/bin/env python3
"""FIX-N2: emit the exact payload files."""

import os

import sympy as sp

import cell_lib as CL
import produce_c3_equivariant as EQ
import verify_cells as VC
from cell_lib import om, kp, km, x, y, z

HERE = os.path.dirname(os.path.abspath(__file__))


def payload_dims():
    out = ['# FIX-N2 payload: cell dimensions (dim a\', dim b\', dim u0\', '
           'dim u1\', dim u2\')',
           '# cell (m,r): degree r in (x,y,z), all exponents <= r-m.', '']
    for m in range(1, 8):
        for r in range(1, 16):
            d = CL.cell_dims(r, m)
            tot = sum(d.values())
            if tot == 0:
                continue
            out.append('m=%d r=%-3d dims=(%d,%d,%d,%d,%d)  total=%d%s'
                       % (m, r, d['a'], d['b'], d['u0'], d['u1'], d['u2'], tot,
                          '   <- bottom cell r=ceil(3m/2)'
                          if r == -((-3 * m) // 2) else ''))
        out.append('')
    return '\n'.join(out)


def payload_shapes():
    out = ['# FIX-N2 payload: the unique K-equivariant pointwise shape and the',
           '# landing coefficient equations, per cell.  om^2+om+1=0.', '']
    for (m, r) in [(1, 2), (1, 3), (1, 4), (1, 5), (2, 3), (2, 4), (3, 5), (3, 6)]:
        eqs, coeffs, bases, forms = CL.landing_system(r, m)
        out.append('=== cell (m,r) = (%d,%d) ===' % (m, r))
        for nm, f in zip(['a\'', 'b\'', 'u0\'', 'u1\'', 'u2\''], forms):
            out.append('   %-4s = %s' % (nm, sp.factor(f)))
        out.append('   %d landing coefficient equations:' % len(eqs))
        for e in eqs:
            out.append('      %s' % sp.factor(e))
        out.append('')
    return '\n'.join(out)


def payload_c3_shapes():
    out = ['# FIX-N2 payload: dimensions of the three C3-eigen-blocks of the',
           '# cell (their sum is the full cell dimension - arithmetic check).',
           '']
    for r in range(2, 13):
        tot = sum(CL.cell_dims(r, 1).values())
        fs = []
        for lam in (1, om, om**2):
            res = EQ.equivariant_tuple(r, 1, lam)
            fs.append(0 if res is None else len(res[1]))
        out.append('m=1 r=%-3d  cell dim = %-3d  C3 blocks (lam=1,om,om^2) = '
                   '(%d,%d,%d)  sum = %d  %s'
                   % (r, tot, fs[0], fs[1], fs[2], sum(fs),
                      'OK' if sum(fs) == tot else 'MISMATCH'))
    return '\n'.join(out)


def payload_witnesses():
    B = sp.Symbol('B')
    kap = (B**3 - 1)**2 / B**3
    out = ['# FIX-N2 payload: explicit POPULATED witnesses (Theorem D).',
           '# a\' = -XYZ, b\' = 0, u0\' = X(X^2+B Y^2+B^-1 Z^2),',
           '# u1\' = om Y(...), u2\' = om^2 Z(...), Y = psi X, Z = psi^2 X,',
           '# kp = (B^3-1)^2/B^3.  Residual C3 scalar lam = om^2.', '']
    cases = [('X = x', x, 1, 'the seed: m = 0'),
             ('X = y z', y * z, 1, 'base packet section 4'),
             ('X = x y^2', x * y**2, 1,
              'NEW primitive witness above the first m=3 layer'),
             ('X = x^2 y z', x**2 * y * z, 1, ''),
             ('xyz * (X = x)', x, x * y * z,
              'NEW: the cell (2,6) is POPULATED - an even-m cell'),
             ('(x^2+y^2+z^2) * (X = y z)', y * z, x**2 + y**2 + z**2,
              'NEW imprimitive witness above the first m=3 layer')]
    for tag, X, mult, note in cases:
        T = [sp.expand(mult * f) for f in VC.generalised_family(X, B)]
        val = VC.reduce_om(sp.expand(sp.together(VC.klein(*T).subs(kp, kap))))
        monos = set()
        for f in T:
            f = sp.sympify(f)
            if f == 0:
                continue
            for mo, _ in sp.Poly(sp.expand(sp.numer(sp.together(f))),
                                 x, y, z).terms():
                monos.add(mo)
        r = max(sum(mo) for mo in monos)
        mx = max(max(mo) for mo in monos if sum(mo) == r)
        out.append('--- %s   %s' % (tag, note))
        out.append('    lands (F = 0 with kp = (B^3-1)^2/B^3): %s'
                   % (sp.simplify(val) == 0))
        out.append('    (m,r) = (%d,%d)' % (r - mx, r))
        for nm, f in zip(['a\'', 'b\'', 'u0\'', 'u1\'', 'u2\''], T):
            out.append('    %-4s = %s' % (nm, sp.factor(sp.together(f))))
        out.append('')
    return '\n'.join(out)


if __name__ == '__main__':
    for name, txt in (('PAYLOAD_dims.txt', payload_dims()),
                      ('PAYLOAD_shapes.txt', payload_shapes()),
                      ('PAYLOAD_c3_blocks.txt', payload_c3_shapes()),
                      ('PAYLOAD_witnesses.txt', payload_witnesses())):
        with open(os.path.join(HERE, name), 'w') as fh:
            fh.write(txt + '\n')
        print('wrote', name)
