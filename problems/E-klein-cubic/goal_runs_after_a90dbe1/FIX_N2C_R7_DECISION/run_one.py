#!/usr/bin/env python3
"""FIX-N2C driver: one msolve run on a dehomogenised (m,r)=(1,7) system.

usage:  run_one.py TAG LAM VAR MODE[:p] MSOLVEFLAGS...

  LAM   one | om | om2
  VAR   B5 | B8               (the plane-order-1 parameter set to 1)
  MODE  ff:p    -- F_p with the split roots (om_p, kp_p)
        fv:p    -- F_p with om, kp as extra variables + minimal polynomials
        qq      -- QQ with om, kp as extra variables + minimal polynomials
Extra flag  --noelim  keeps P0 (default: P0 is eliminated exactly).
"""
import os
import subprocess
import sys
import time

import n2c_systems as S

HERE = os.path.dirname(os.path.abspath(__file__))


def build(lam, var, mode, elim=True):
    b, polys = S.system(7, S.LAMS[lam])
    names, dh = S.dehomogenise(b, polys, var)
    info = None
    if elim:
        names, dh, info = S.eliminate_linear(names, dh, 'P0')
        assert info is not None, 'P0 not linearly eliminable'
    if mode.startswith('ff'):
        p = int(mode.split(':')[1])
        omp, kpp = S.find_roots(p)
        assert omp is not None and kpp is not None, 'prime %d not split' % p
        return names, S.emit_ff(names, dh, p, omp, kpp), info
    if mode.startswith('fv'):
        p = int(mode.split(':')[1])
        return names, S.emit_vars(names, dh, p), info
    if mode == 'qq':
        return names, S.emit_vars(names, dh, 0), info
    raise ValueError(mode)


def main():
    tag, lam, var, mode = sys.argv[1:5]
    flags = [a for a in sys.argv[5:] if a != '--noelim']
    elim = '--noelim' not in sys.argv[5:]
    names, src, info = build(lam, var, mode, elim)
    inp = os.path.join(HERE, 'msolve', tag + '.ms')
    outp = os.path.join(HERE, 'msolve', tag + '.out')
    open(inp, 'w').write(src)
    nv = len(src.split('\n')[0].split(','))
    print('[%s] lam=%s %s=1 mode=%s vars=%d(%s) eqs=%d elim_P0=%s'
          % (tag, lam, var, mode, nv, ','.join(names), len(src.strip().split(',\n')) - 1,
             elim), flush=True)
    t0 = time.time()
    cmd = [S.MSOLVE, '-t', os.environ.get('NTH','6'), '-f', inp, '-o', outp] + flags
    print('  cmd: %s' % ' '.join(cmd), flush=True)
    r = subprocess.run(cmd, capture_output=True, text=True)
    dt = time.time() - t0
    print('  rc=%d  %.1fs' % (r.returncode, dt), flush=True)
    if r.stderr.strip():
        print('  stderr:', r.stderr.strip()[:2000], flush=True)
    txt = open(outp).read() if os.path.exists(outp) else '<no output>'
    print('  out (%d bytes): %s' % (len(txt), txt[:3000]), flush=True)


if __name__ == '__main__':
    main()
