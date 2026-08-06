#!/usr/bin/env python3
"""FIX-H1 (secondary): shared setup for the (1,8) and (1,6)-line-degree holes.

READ-ONLY reuse of the sibling packets:
  * FIX-N2B `n2b_lib` / `fullspace`  (the C3-eigenblock cell engine, exact over
    K = QQ(om,kp), om^2+om+1 = 0, 8kp^2-13kp-4 = 0),
  * FIX-N2C `n2c_systems`            (dehomogenisation, msolve emitters,
    parenthesis-free by construction -- see its MSOLVE_PARSER.md).

Nothing in the sibling packets is modified.
"""
import os
import sys

N2B = ('/Users/worker/unirational/problems/E-klein-cubic/'
       'goal_runs_after_fa02f05/FIX_N2B_M1_ROW')
N2C = ('/Users/worker/unirational/problems/E-klein-cubic/'
       'goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION')
for _p in (N2B, N2C):
    if _p not in sys.path:
        sys.path.insert(0, _p)

HERE = os.path.dirname(os.path.abspath(__file__))
MSOLVE = '/opt/homebrew/bin/msolve'
M2 = '/opt/homebrew/bin/M2'

import n2b_lib as L                                          # noqa: E402
import fullspace as FS                                       # noqa: E402
import n2c_systems as S                                      # noqa: E402
from n2b_lib import ONE, OM, OM2, ZERO, KP, KM               # noqa: E402

LAMS = {'one': ONE, 'om': OM, 'om2': OM2}
TAGOF = {ONE: 'one', OM: 'om', OM2: 'om2'}


# --------------------------------------------------------------------------
def block_system(r, lam, m=1, orbit_reduce=True):
    """(Block, [poly]) at cell (m,r) with residual-C3 scalar lam."""
    b = L.Block(r, m, lam)
    return b, [dict(pc) for pc in L.equations(b, orbit_reduce=orbit_reduce)]


def po1_params(b):
    """names of the parameters carrying a plane-order-1 monomial."""
    po = b.param_plane_orders()
    return [nm for nm, q in zip(b.names, po) if q == 1]


def assert_paren_free(src, what='msolve input'):
    assert '(' not in src and ')' not in src, \
        'PARENTHESIS FOUND in %s -- msolve 0.10.1 mis-parses it' % what
    return src


def run_msolve(tag, src, flags=(), nthreads='6', timeout=None, subdir='msolve'):
    """write `src`, run msolve, return (rc, seconds, output-text).

    Asserts the input is parenthesis-free and the output file is non-empty
    (a 0-byte msolve output is an ERROR, never a verdict).
    """
    import subprocess
    import time
    assert_paren_free(src, tag)
    d = os.path.join(HERE, subdir)
    os.makedirs(d, exist_ok=True)
    inp = os.path.join(d, tag + '.ms')
    outp = os.path.join(d, tag + '.out')
    open(inp, 'w').write(src)
    if os.path.exists(outp):
        os.remove(outp)
    cmd = [MSOLVE, '-t', nthreads, '-f', inp, '-o', outp] + list(flags)
    t0 = time.time()
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        rc, err = r.returncode, r.stderr
    except subprocess.TimeoutExpired:
        return -9, time.time() - t0, '<TIMEOUT>'
    dt = time.time() - t0
    if not os.path.exists(outp):
        return rc, dt, '<NO OUTPUT FILE: %s>' % err.strip()[:400]
    txt = open(outp).read()
    if len(txt) == 0:
        return rc, dt, '<ZERO-BYTE OUTPUT -- ERROR, NOT A VERDICT>'
    return rc, dt, txt


def is_unit_ideal(txt):
    """msolve output -> True iff the ideal is (1) / the solution set is empty.

    `-g 1/2` prints a '#'-comment header and then the bracketed basis; a unit
    ideal is `[1]:`.  Solving mode (`-P`, default) prints `[-1]:` when there is
    no solution in the algebraic closure.  (FIX-N2B's own parser, matched.)
    """
    t = txt.strip()
    assert t and not t.startswith('<'), 'unusable msolve output: %r' % t[:200]
    i, j = t.find('['), t.rfind(']')
    assert i >= 0 and j > i, 'unparseable msolve output: %r' % t[:200]
    body = t[i + 1:j].strip()
    return body in ('1', '-1')


# --------------------------------------------------------------------------
def emit_ff(names, polys, p, omp, kpp):
    return assert_paren_free(S.emit_ff(names, polys, p, omp, kpp))


def emit_vars(names, polys, char):
    return assert_paren_free(S.emit_vars(names, polys, char))
