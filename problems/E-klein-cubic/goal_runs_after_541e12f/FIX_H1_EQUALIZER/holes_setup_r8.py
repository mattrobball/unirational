#!/usr/bin/env python3
"""FIX-H1 TASK 6, step (a): build the (m,r) = (1,8) systems and reproduce the
FIX-N2B block dimensions (18,18,18); identify the plane-order-1 parameters.
"""
import sys

import holes_lib as H
import n2b_lib as L
from n2b_lib import ONE, OM, OM2


def main():
    for r in (6, 7, 8, 9, 10):
        dims = []
        for tag in ('one', 'om', 'om2'):
            b = L.Block(r, 1, H.LAMS[tag])
            dims.append(b.n)
        print('r=%-2d  cell dims (a,b,u) = %s   block dims = %s'
              % (r, L.cell_dims(r, 1), tuple(dims)), flush=True)

    print()
    for r in (8, 10):
        for tag in ('one', 'om', 'om2'):
            b, eqs = H.block_system(r, H.LAMS[tag])
            _, eqs_all = H.block_system(r, H.LAMS[tag], orbit_reduce=False)
            po = b.param_plane_orders()
            print('r=%d lam=%-3s  n=%d  names=%s' % (r, tag, b.n, b.names),
                  flush=True)
            print('        plane orders  : %s' % po, flush=True)
            print('        PO1 params    : %s' % H.po1_params(b), flush=True)
            print('        equations     : %d (orbit-reduced) / %d (all)'
                  % (len(eqs), len(eqs_all)), flush=True)
            # monomial each B-parameter carries
            print('        B-monomials   : %s'
                  % [(nm, mo) for nm, mo in
                     zip([n for n in b.names if n.startswith('B')], b.sup_u)],
                  flush=True)
            print(flush=True)


if __name__ == '__main__':
    main()
