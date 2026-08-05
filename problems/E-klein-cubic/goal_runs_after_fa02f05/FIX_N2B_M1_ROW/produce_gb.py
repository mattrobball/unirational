#!/usr/bin/env python3
"""FIX-N2B: Groebner-basis driver for the C3-equivariant landing cones.

msolve is used in `-g` mode (print the reduced grevlex Groebner basis / its
leading ideal) rather than in solving mode: the cones are positive-dimensional
whenever they are nonempty, and the parametrisation step then does not
terminate, whereas the GB step does.

From the leading ideal we read off
  * the affine dimension of the cone (0 <=> the cone is {0}),
  * a plane-order verdict for each parameter v:  saturate by v, i.e. compute
    the GB of  I + (1 - w v)  -- the reduced GB is {1} exactly when v vanishes
    identically on the cone.

Coefficient regimes
  ff : F_100057 with om = 1140, kp = 74361   (fast filter, NOT used for any
       characteristic-zero emptiness claim on its own)
  qq : characteristic zero over QQ with om,kp adjoined as variables subject to
       om^2+om+1 and 8kp^2-13kp-4 (rigorous; the verdict then holds for every
       root, in particular for the Klein values)
"""
import itertools
import os
import re
import subprocess
import sys
import time

import n2b_lib as L
from n2b_lib import ONE, OM, OM2

MSOLVE = "/opt/homebrew/bin/msolve"
HERE = os.path.dirname(os.path.abspath(__file__))
FF_P, FF_OM, FF_KP = 100057, 1140, 74361
TAG = {ONE: 'one', OM: 'om', OM2: 'om2'}
LAMS = {'one': ONE, 'om': OM, 'om2': OM2}


def build(r, lam, mode, orbit_reduce=True):
    b = L.Block(r, 1, lam)
    eqs = L.equations(b, orbit_reduce=orbit_reduce)
    if mode == 'ff':
        polys = [L.eq_str(e, b.names, mod=True, p=FF_P, omp=FF_OM, kpp=FF_KP)
                 for e in eqs]
        variables, char = list(b.names), FF_P
    else:
        polys = [L.eq_str(e, b.names) for e in eqs]
        variables = list(b.names) + ['om', 'kp']
        char = 0
        polys = polys + ['om^2+om+1', '8*kp^2-13*kp-4']
    return b, variables, char, polys


def run_msolve(variables, char, polys, tag, gmode=2, timeout=3600, threads=6):
    src = '%s\n%d\n%s\n' % (','.join(variables), char, ',\n'.join(polys))
    inp = os.path.join(HERE, 'msolve', tag + '.ms')
    outp = os.path.join(HERE, 'msolve', tag + '.out')
    open(inp, 'w').write(src)
    t0 = time.time()
    try:
        subprocess.run([MSOLVE, '-t', str(threads), '-g', str(gmode),
                        '-f', inp, '-o', outp],
                       capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return None, time.time() - t0
    txt = open(outp).read() if os.path.exists(outp) else ''
    return txt, time.time() - t0


def is_unit_ideal(txt):
    """msolve -g output: the (leading) basis is {1} exactly when the ideal is (1).

    The file starts with '#'-comment header lines; the basis is the bracketed
    body.  A unit ideal prints as '[1]:'.
    """
    body = txt[txt.find('[') + 1:txt.rfind(']')].strip()
    return body == '1'


def parse_gb(txt, variables):
    """leading monomials (exponent vectors) of the printed grevlex GB."""
    body = txt.strip()
    body = body[body.find('[') + 1:body.rfind(']')]
    idx = {v: i for i, v in enumerate(variables)}
    lead = []
    polys = [s.strip() for s in body.split(',\n')]
    for pl in polys:
        pl = pl.strip().strip(',').strip()
        if not pl:
            continue
        # first term of the printed (grevlex-ordered) polynomial is the leader
        term = re.split(r'(?<![\^*])[+-]', pl)[0]
        e = [0] * len(variables)
        for fac in term.split('*'):
            fac = fac.strip()
            mm = re.match(r'^([A-Za-z]\w*)(?:\^(\d+))?$', fac)
            if mm and mm.group(1) in idx:
                e[idx[mm.group(1)]] += int(mm.group(2) or 1)
        lead.append(tuple(e))
    return lead


def dim_from_lead(lead, nvars, exclude=()):
    """affine dimension of V(lead ideal): max |S| with no generator supported in S."""
    allv = [i for i in range(nvars) if i not in exclude]
    supports = [set(i for i, e in enumerate(m) if e) for m in lead]
    best = 0
    for k in range(len(allv), -1, -1):
        found = False
        for S in itertools.combinations(allv, k):
            Ss = set(S)
            if all(not (sp <= Ss) for sp in supports):
                found = True
                break
        if found:
            return k
    return best


def cone_report(r, mode, lams=('one', 'om', 'om2'), timeout=3600,
                do_sat=True, orbit_reduce=True):
    out = []
    for lt in lams:
        lam = LAMS[lt]
        b, variables, char, polys = build(r, lam, mode, orbit_reduce)
        po = b.param_plane_orders()
        tag = 'gb_r%d_%s_%s' % (r, lt, mode)
        txt, dt = run_msolve(variables, char, polys, tag, gmode=2,
                             timeout=timeout)
        if txt is None:
            print('#### r=%d lam=%-4s free=%d  GB: TIMEOUT (%ds)'
                  % (r, lt, b.n, timeout))
            sys.stdout.flush()
            out.append((r, lt, 'TIMEOUT', None))
            continue
        lead = parse_gb(txt, variables)
        if mode == 'qq':
            d = dim_from_lead(lead, len(variables),
                              exclude=(len(variables) - 2, len(variables) - 1))
        else:
            d = dim_from_lead(lead, len(variables))
        print('#### r=%d lam=%-4s free=%d eqs=%d  CONE-DIM %d  (%.1fs, %d GB elts)'
              % (r, lt, b.n, len(polys), d, dt, len(lead)))
        sys.stdout.flush()
        sats = {}
        if do_sat and d > 0:
            for i, nm in enumerate(b.names):
                vs = variables + ['wsat']
                ps = polys + ['1-wsat*%s' % nm]
                t2, dt2 = run_msolve(vs, char, ps, tag + '_sat_' + nm,
                                     gmode=1, timeout=timeout)
                if t2 is None:
                    v = 'TIMEOUT'
                else:
                    v = 'forced-zero' if is_unit_ideal(t2) else 'CAN-BE-NONZERO'
                sats[nm] = (po[i], v)
                print('     %-4s (plane order %d) : %-15s (%.1fs)'
                      % (nm, po[i], v, dt2))
                sys.stdout.flush()
        out.append((r, lt, d, sats))
    return out


if __name__ == '__main__':
    mode = sys.argv[1]
    lams = ('one', 'om', 'om2')
    args = sys.argv[2:]
    if args and args[0] in ('one', 'om', 'om2'):
        lams = (args[0],)
        args = args[1:]
    for r in (int(v) for v in args):
        cone_report(r, mode, lams=lams)
