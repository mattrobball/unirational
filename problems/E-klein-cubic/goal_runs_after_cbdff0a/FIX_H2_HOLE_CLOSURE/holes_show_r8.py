#!/usr/bin/env python3
"""FIX-H1 TASK 6: print the (1,8) landing equations, sorted by sparsity, with
their U,V,W monomial (the plane-adic level: U^a V^b W^c has
ord_{P_1} = 2(12-a), ord_{P_2} = 2(12-b), ord_{P_3} = 2(12-c)).

usage:  holes_show_r8.py [LAM] [r]
"""
import sys

import holes_lib as H
import n2b_lib as L


def eqstr(pc, names):
    terms = []
    for pm, c in sorted(pc.items()):
        mon = '*'.join('%s^%d' % (names[i], e) if e > 1 else names[i]
                       for i, e in enumerate(pm) if e)
        terms.append('(%s)%s' % (L.kstr(c), '*' + mon if mon else ''))
    return ' + '.join(terms) if terms else '0'


def main():
    lam = sys.argv[1] if len(sys.argv) > 1 else 'one'
    r = int(sys.argv[2]) if len(sys.argv) > 2 else 8
    b = L.Block(r, 1, H.LAMS[lam])
    Lp = L.landing_cpoly(b)
    rows = [(len(pc), mo, pc) for mo, pc in Lp.items() if pc]
    rows.sort()
    po1 = set(H.po1_params(b))
    print('lam=%s r=%d : %d nonzero coefficient equations, params %s'
          % (lam, r, len(rows), b.names))
    print('PO1 params: %s' % sorted(po1))
    print()
    for n, mo, pc in rows:
        involves = sorted({b.names[i] for pm in pc for i, e in enumerate(pm) if e}
                          & po1)
        lev = (2*(sum(mo)-mo[0]), 2*(sum(mo)-mo[1]), 2*(sum(mo)-mo[2]))
        print('U^%d V^%d W^%d  (ordP = %s)  nterms=%d  PO1vars=%s'
              % (mo[0], mo[1], mo[2], lev, n, involves))
        print('    %s' % eqstr(pc, b.names))
    print()


if __name__ == '__main__':
    main()
