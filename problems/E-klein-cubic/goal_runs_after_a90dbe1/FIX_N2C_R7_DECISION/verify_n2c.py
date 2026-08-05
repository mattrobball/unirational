#!/usr/bin/env python3
"""FIX-N2C -- the independent verifier.

Everything here recomputes rather than re-reads.  In order:

 1. INDEPENDENT REBUILD.  `indep_r7.py` constructs the (m,r) = (1,7) cell, the
    residual-C3 eigenblocks and the landing equations from the raw Klein normal
    form, as explicit polynomials in x,y,z with sympy -- no FIX-N2B code.  The
    52 coefficient equations are compared termwise with FIX-N2B's `n2b_lib`
    engine for all three lam.

 2. PLANE ORDERS.  The claim "B5 and B8 are exactly the plane-order-1
    parameters of the (1,7) cell" is recomputed from ideal-theoretic orders of
    the explicit monomials, for all three lam.

 3. MSOLVE PARSER REGRESSION.  msolve's input parser silently drops
    parenthesised coefficient groups.  The toy systems below exhibit it; every
    msolve input this packet writes is FULLY EXPANDED with integer
    coefficients, and the expansion is checked against the specialised
    numeric emission termwise.

 4. THE VERDICT EVIDENCE (filled in by `verdict_checks()` -- see STATUS.md).

usage:   python3 -u verify_n2c.py
"""
import os
import re
import subprocess
import sys
import tempfile

import sympy as sp

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import indep_r7 as I                                        # noqa: E402
import n2c_systems as S                                     # noqa: E402
from indep_r7 import om, kp, x, y, z                        # noqa: E402
import n2b_lib as L                                         # noqa: E402
from n2b_lib import ONE, OM, OM2                            # noqa: E402

FAIL = []


def check(name, cond, extra=''):
    print('%-58s %s %s' % (name, 'OK ' if cond else 'FAIL', extra), flush=True)
    if not cond:
        FAIL.append(name)


# --------------------------------------------------------------------------
def k_to_sympy(v):
    return sp.expand(v[0] + v[1]*om + v[2]*kp + v[3]*om*kp)


def step1_rebuild():
    print('\n== 1. independent rebuild of the (1,7) landing system ==')
    for tag, lamS, lamK in (('one', sp.Integer(1), ONE), ('om', om, OM),
                            ('om2', I.kred(om**2), OM2)):
        names, T, eqs = I.landing_equations(7, 1, lamS)
        syms = [sp.Symbol(n) for n in names]
        mine = dict(eqs)
        b = L.Block(7, 1, lamK)
        check('  lam=%-4s parameter names agree' % tag, b.names == names)
        Lp = L.landing_cpoly(b)
        theirs = {}
        for mo, pc in Lp.items():
            e = sp.Integer(0)
            for pm, c in pc.items():
                t = k_to_sympy(c)
                for j, ex in enumerate(pm):
                    if ex:
                        t = t*syms[j]**ex
                e += t
            theirs[(2*mo[0]+1, 2*mo[1]+1, 2*mo[2]+1)] = sp.expand(e)
        bad = sum(1 for mo in set(mine) | set(theirs)
                  if I.kred(sp.expand(mine.get(mo, 0) - theirs.get(mo, 0))) != 0)
        check('  lam=%-4s 52 coefficient equations termwise' % tag,
              len(mine) == 52 and set(mine) == set(theirs) and bad == 0,
              '(#eqs=%d, mismatches=%d)' % (len(mine), bad))


def step2_plane_orders():
    print('\n== 2. the plane-order-1 parameters of the (1,7) cell ==')
    for tag, lamS, lamK in (('one', sp.Integer(1), ONE), ('om', om, OM),
                            ('om2', I.kred(om**2), OM2)):
        names, T, _ = I.equivariant_tuple(7, 1, lamS) + (None,) \
            if False else (I.equivariant_tuple(7, 1, lamS) + (None,))
        names, T = names, T
        syms = [sp.Symbol(n) for n in names]
        # ord_{P_1}=(y,z), P_2=(x,z), P_3=(x,y): for x^A y^B z^C these are
        # B+C, A+C, A+B.  A parameter has plane order  min over its monomials.
        po = {}
        for s in syms:
            best = None
            for comp in T:
                P = sp.Poly(sp.expand(comp), x, y, z)
                for mono, c in zip(P.monoms(), P.coeffs()):
                    if sp.expand(c).coeff(s) == 0 and s not in sp.expand(c).free_symbols:
                        continue
                    A, B, C = mono
                    v = min(B + C, A + C, A + B)
                    best = v if best is None else min(best, v)
            po[str(s)] = best
        ones = sorted(n for n, v in po.items() if v == 1)
        check('  lam=%-4s plane-order-1 parameters = [B5, B8]' % tag,
              ones == ['B5', 'B8'], str(po))
        check('  lam=%-4s every parameter has plane order >= 1' % tag,
              all(v >= 1 for v in po.values()))


def _msolve(src, flags=('-g', '2')):
    d = tempfile.mkdtemp()
    f = os.path.join(d, 'a.ms')
    o = os.path.join(d, 'a.out')
    open(f, 'w').write(src)
    subprocess.run([S.MSOLVE, '-f', f, '-o', o] + list(flags),
                   capture_output=True, text=True, timeout=300)
    return open(o).read().strip() if os.path.exists(o) else ''


def step3_parser():
    print('\n== 3. msolve parser regression (parenthesised coefficients) ==')
    good = _msolve('x,om\n100057\nx+om*x+1,\nom^2+om+1\n')
    bad = _msolve('x,om\n100057\n(1+1*om)*x+(1),\nom^2+om+1\n')
    check('  expanded  x+om*x+1  gives  x-om', 'x^1+100056*om^1' in good, good.splitlines()[-1] if good else '')
    check('  parenthesised (1+1*om)*x+(1) is MIS-PARSED', good != bad,
          '(msolve returns %s)' % (bad.splitlines()[-1] if bad else '?'))
    bad2 = _msolve('x,om\n100057\n(2+3*om)*x,\nx-1\n')
    check('  parenthesised (2+3*om)*x with x=1 wrongly gives UNIT ideal',
          bad2.endswith('[1]:'), bad2.splitlines()[-1] if bad2 else '')
    # and: this packet's emitter is parenthesis-free and matches the numeric one
    p, omp, kpp = 100057, 1140, 74361
    ok = True
    for lam in ('one', 'om', 'om2'):
        for var in ('B5', 'B8'):
            b, polys = S.system(7, S.LAMS[lam])
            nm, dh = S.dehomogenise(b, polys, var)
            ff = S.emit_ff(nm, dh, p, omp, kpp)
            fv = S.emit_vars(nm, dh, p)
            ok &= '(' not in ff and '(' not in fv
            ok &= _same_mod_p(ff, fv, nm, p, omp, kpp)
    check('  this packet\'s emitters are paren-free and agree mod p', ok)


def _same_mod_p(ff, fv, names, p, omp, kpp):
    def parse(src, subs=None):
        out = []
        for line in src.strip().split('\n')[2:]:
            line = line.rstrip(',').replace('-', '+-')
            d = {}
            for term in line.split('+'):
                term = term.strip()
                if not term:
                    continue
                c, e = 1, [0]*len(names)
                for f in term.split('*'):
                    m = re.match(r'^(-?\d+)(?:/(\d+))?$', f)
                    if m:
                        c = c*int(m.group(1)) % p
                        if m.group(2):
                            c = c*pow(int(m.group(2)), p-2, p) % p
                        continue
                    m = re.match(r'^([A-Za-z]\w*)(?:\^(\d+))?$', f)
                    nm2, ex = m.group(1), int(m.group(2) or 1)
                    if subs and nm2 in subs:
                        c = c*pow(subs[nm2], ex, p) % p
                    else:
                        e[names.index(nm2)] += ex
                k = tuple(e)
                d[k] = (d.get(k, 0) + c) % p
            d = {k: v for k, v in d.items() if v}
            if d:
                out.append(d)
        return out

    def norm(d):
        k0 = max(d)
        c = pow(d[k0], p-2, p)
        return tuple(sorted((k, v*c % p) for k, v in d.items()))
    A = sorted(norm(d) for d in parse(ff))
    B = sorted(norm(d) for d in parse(fv, subs={'om': omp, 'kp': kpp}))
    return A == B


# --------------------------------------------------------------------------
def main():
    step1_rebuild()
    step2_plane_orders()
    step3_parser()
    try:
        import verdict_checks
        verdict_checks.run(check)
    except ImportError:
        print('\n(verdict_checks.py not present -- skipping step 4)')
    print()
    if FAIL:
        print('FIX_N2C_VERIFY_FAILED: %s' % '; '.join(FAIL))
        sys.exit(1)
    print('FIX_N2C_R7_DECISION_VERIFY_OK')


if __name__ == '__main__':
    main()
