#!/usr/bin/env python3
"""FIX-H1: INDEPENDENT rebuild of the (m,r) = (1,r) landing system in sympy,
straight from the RAW Klein normal form (V4 packet (1.1)), and a termwise
cross-check against FIX-N2B's block engine.

The rebuild is FIX-N2C's `indep_r7.py` (which never imports `n2b_lib`); it is
generic in (r, m, lam).  Checked here at r = 8 and r = 10:

  * the tuple really is residual-C3-equivariant, psi(T) = lam g(T);
  * the V4-characters / parities of the five slots;
  * the plane orders of every parameter, computed from the x,y,z exponents,
    agree with `Block.param_plane_orders` -- in particular WHICH parameters are
    the plane-order-1 ones;
  * every coefficient equation of F(T) = 0 agrees termwise with the block
    engine's (after the U,V,W <-> x,y,z dictionary).

usage:  holes_indep.py [r]
"""
import sys

import sympy as sp

import holes_lib as H
import indep_r7 as I
import n2b_lib as L
from indep_r7 import om, kp, x, y, z

LAMS = {'one': sp.Integer(1), 'om': om, 'om2': sp.expand(-1 - om)}


def kelt_to_sympy(c):
    return sp.expand(sp.Rational(c[0]) + sp.Rational(c[1])*om
                     + sp.Rational(c[2])*kp + sp.Rational(c[3])*om*kp)


def block_eqs_as_sympy(r, lam_tag):
    b = L.Block(r, 1, H.LAMS[lam_tag])
    syms = [sp.Symbol(n) for n in b.names]
    Lp = L.landing_cpoly(b)
    out = {}
    for mo, pc in Lp.items():
        e = sp.Integer(0)
        for pm, c in pc.items():
            t = kelt_to_sympy(c)
            for i, ex in enumerate(pm):
                if ex:
                    t *= syms[i]**ex
            e += t
        e = I.kred(sp.expand(e))
        if e != 0:
            out[mo] = e
    return b, out


def uvw_of_xyz(r, mono):
    """the U,V,W exponent of an x,y,z monomial of F(T) (r even: all even)."""
    A, B, C = mono
    assert A % 2 == 0 and B % 2 == 0 and C % 2 == 0, mono
    return (A // 2, B // 2, C // 2)


def main():
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    assert r % 2 == 0
    ok = True
    for tag in ('one', 'om', 'om2'):
        lam = LAMS[tag]
        names, T, eqs = I.landing_equations(r, 1, lam)
        assert I.check_equivariance(T, lam), 'independent tuple not equivariant'
        b, beqs = block_eqs_as_sympy(r, tag)
        # 1. same parameter names, same order
        same_names = (names == b.names)
        # 2. plane orders from the raw x,y,z exponents
        po_indep = []
        for nm in names:
            s = sp.Symbol(nm)
            ords = []
            for comp in T:
                P = sp.Poly(sp.expand(comp), x, y, z)
                for mono, c in zip(P.monoms(), P.coeffs()):
                    if sp.expand(c).has(s):
                        ords.append(r - max(mono))
            po_indep.append(min(ords))
        po_block = b.param_plane_orders()
        same_po = (po_indep == list(po_block))
        po1_indep = [nm for nm, q in zip(names, po_indep) if q == 1]
        # 3. termwise equality of the coefficient equations
        indep = {}
        for mono, c in eqs:
            indep[uvw_of_xyz(r, mono)] = I.kred(sp.expand(c))
        keys = set(indep) | set(beqs)
        bad = []
        for k in keys:
            d = I.kred(sp.expand(indep.get(k, 0) - beqs.get(k, 0)))
            if d != 0:
                bad.append((k, d))
        print('r=%d lam=%-4s : names-match=%s  planeorders-match=%s  PO1=%s  '
              'eqs %d/%d  mismatches=%d'
              % (r, tag, same_names, same_po, po1_indep,
                 len(indep), len(beqs), len(bad)), flush=True)
        ok &= same_names and same_po and not bad and len(indep) == len(beqs)
        if bad:
            print('   first mismatch: %s  %s' % (bad[0][0], bad[0][1]))
        # 4. the two sparse leading generators, checked in the RAW system
        idx = {nm: i for i, nm in enumerate(names)}
        P0, R0 = sp.Symbol(names[idx['P0']]), sp.Symbol(names[idx['R0']])
        P1, R1 = sp.Symbol(names[idx['P1']]), sp.Symbol(names[idx['R1']])
        v6, v9 = [sp.Symbol(n) for n in po1_indep]
        om2 = sp.expand(-1 - om)
        found_v6 = found_v9 = None
        for k, e in indep.items():
            for cand, target in ((v6, sp.expand((om2*P0 + om*R0)*v6**2)),
                                 (v9, sp.expand((om*P1 + om2*R1)*v9**2))):
                q = sp.simplify(sp.cancel(I.kred(sp.expand(e)) /
                                          I.kred(sp.expand(target))))
                if q.is_number and q != 0:
                    if cand is v6:
                        found_v6 = (k, q)
                    else:
                        found_v9 = (k, q)
        print('     raw sparse generators:  (om^2 P0 + om R0)*%s^2 at %s ;  '
              '(om P1 + om^2 R1)*%s^2 at %s'
              % (v6, found_v6, v9, found_v9), flush=True)
        ok &= (found_v6 is not None) and (found_v9 is not None)
    print('INDEP-CROSSCHECK %s' % ('OK' if ok else 'FAILED'))
    return ok


if __name__ == '__main__':
    sys.exit(0 if main() else 1)
