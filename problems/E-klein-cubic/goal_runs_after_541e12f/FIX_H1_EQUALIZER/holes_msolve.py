#!/usr/bin/env python3
"""FIX-H1: one msolve run on a dehomogenised (m,r) = (1,r) cone system.

usage:  holes_msolve.py TAG r LAM VAR MODE[:p] [--lin] [msolve flags...]

  LAM   one | om | om2
  VAR   the plane-order-1 parameter that is set to 1
  MODE  ff:p  -- F_p with the split roots (om_p, kp_p)
        fv:p  -- F_p with om, kp as extra variables + minimal polynomials
        qq    -- QQ  with om, kp as extra variables + minimal polynomials
  --lin       apply the exact DEGREE-1-ONLY linear elimination cascade first
              (a variety isomorphism; keeps the system cubic)

Every emitted input is asserted parenthesis-free (msolve 0.10.1 silently
mis-parses parentheses -- FIX-N2C/MSOLVE_PARSER.md) and a zero-byte output is
reported as an ERROR, never as a verdict.
"""
import os
import sys
import time

import holes_lib as H
import holes_reduce as RD
import n2b_lib as L
import n2c_systems as S


def linear_only(names, polys, verbose=True):
    """elimination cascade restricted to substitutions of DEGREE <= 1."""
    names = list(names)
    polys = RD.dedup(polys)
    trail = []
    while True:
        done = False
        for (qi, i, nm) in RD.linear_candidates(names, polys):
            q = polys[qi]
            n = len(names)
            rest, lin = {}, None
            for k, v in q.items():
                if k[i] == 1:
                    lin = v
                else:
                    rest[k] = v
            if rest and max(sum(k) for k in rest) > 1:
                continue
            expr = S.p_scal(S.p_scal(rest, S.kinv(lin)), L.kneg(H.ONE))
            polys = [S.p_substitute(t, i, expr) for t in polys]
            polys = RD.dedup(polys)
            polys = [S.p_drop(t, {i}) for t in polys]
            newnames = [x for j, x in enumerate(names) if j != i]
            trail.append((nm, RD.polystr(S.p_drop(expr, {i}), newnames)))
            if verbose:
                print('   lin-eliminate %-4s := %s' % (nm, trail[-1][1]),
                      flush=True)
            names = newnames
            done = True
            break
        if not done:
            break
    return names, polys, trail


def build(r, lam, var, mode, lin=False, extra_gens=()):
    b, polys = H.block_system(r, H.LAMS[lam], orbit_reduce=True)
    names, dh = S.dehomogenise(b, polys, var)
    dh = list(dh) + list(extra_gens)
    if lin:
        names, dh, _ = linear_only(names, dh)
    dh = RD.dedup(dh)
    if mode.startswith('ff'):
        p = int(mode.split(':')[1])
        omp, kpp = S.find_roots(p)
        assert omp is not None and kpp is not None, 'prime %d is not split' % p
        return names, H.emit_ff(names, dh, p, omp, kpp)
    if mode.startswith('fv'):
        p = int(mode.split(':')[1])
        return names, H.emit_vars(names, dh, p)
    if mode == 'qq':
        return names, H.emit_vars(names, dh, 0)
    raise ValueError(mode)


def main():
    tag, r, lam, var, mode = sys.argv[1], int(sys.argv[2]), sys.argv[3], \
        sys.argv[4], sys.argv[5]
    rest = sys.argv[6:]
    lin = '--lin' in rest
    flags = [a for a in rest if a != '--lin']
    names, src = build(r, lam, var, mode, lin)
    nv = len(src.split('\n')[0].split(','))
    ng = len(src.strip().split(',\n'))
    print('[%s] r=%d lam=%s %s=1 mode=%s vars=%d gens=%d lin=%s'
          % (tag, r, lam, var, mode, nv, ng, lin), flush=True)
    print('   vars: %s' % ','.join(src.split('\n')[0].split(',')), flush=True)
    t0 = time.time()
    rc, dt, txt = H.run_msolve(tag, src, flags=flags,
                               nthreads=os.environ.get('NTH', '4'))
    print('   rc=%d  %.1f s  out=%d bytes' % (rc, dt, len(txt)), flush=True)
    head = txt[:1500].replace('\n', ' ')
    print('   out: %s' % head, flush=True)
    if txt.startswith('<'):
        print('   VERDICT-STATUS ERROR (no usable output)', flush=True)
    else:
        print('   UNIT-IDEAL/EMPTY = %s' % H.is_unit_ideal(txt), flush=True)
    print('   DONE %s' % tag, flush=True)


if __name__ == '__main__':
    main()
