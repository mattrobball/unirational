#!/usr/bin/env python3
"""Termwise cross-check: independent sympy build  vs  FIX-N2B's n2b_lib engine."""
import sympy as sp, indep_r7 as I, n2c_systems as S
from indep_r7 import om, kp
import n2b_lib as L
from n2b_lib import ONE, OM, OM2

def k_to_sympy(v):
    return sp.expand(v[0] + v[1]*om + v[2]*kp + v[3]*om*kp)

def main():
    ok_all = True
    for tag, lamS, lamK in (('one', sp.Integer(1), ONE), ('om', om, OM),
                            ('om2', I.kred(om**2), OM2)):
        names, T, eqs = I.landing_equations(7, 1, lamS)
        syms = [sp.Symbol(n) for n in names]
        mine = dict(eqs)
        b = L.Block(7, 1, lamK)
        assert b.names == names, (b.names, names)
        Lp = L.landing_cpoly(b)
        theirs = {}
        for mo, pc in Lp.items():
            e = sp.Integer(0)
            for pm, c in pc.items():
                t = k_to_sympy(c)
                for j, ex in enumerate(pm):
                    if ex: t = t*syms[j]**ex
                e += t
            theirs[(2*mo[0]+1, 2*mo[1]+1, 2*mo[2]+1)] = sp.expand(e)
        same = set(mine) == set(theirs)
        bad = 0
        for mo in set(mine) | set(theirs):
            d = I.kred(sp.expand(mine.get(mo, 0) - theirs.get(mo, 0)))
            if d != 0:
                bad += 1
                if bad < 3: print('   MISMATCH at', mo, d, flush=True)
        print('lam=%-4s  #mine=%d #theirs=%d  same-support=%s  mismatches=%d'
              % (tag, len(mine), len(theirs), same, bad), flush=True)
        ok_all &= same and bad == 0
    print('INDEPENDENT REBUILD AGREES WITH FIX-N2B ENGINE:', ok_all)

if __name__ == '__main__':
    main()
