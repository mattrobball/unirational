#!/usr/bin/env python3
"""FIX-H1: positive/negative CONTROLS for the two char-0 leaf engines and for
the msolve unit-ideal parser.  A verdict engine that cannot detect a NON-empty
system is worthless; these controls make sure both engines report both answers.
"""
import holes_leaf as LF, holes_lib as H
from fractions import Fraction as Fr

ONE = (Fr(1), Fr(0), Fr(0), Fr(0))
OMc = (Fr(0), Fr(1), Fr(0), Fr(0))
NEG = (Fr(-1), Fr(0), Fr(0), Fr(0))


def poly(*terms):
    return {k: v for k, v in terms}


def main():
    ok = True
    # (1) NON-empty over K: a^2 - 2 = 0, b - a = 0   (a = sqrt 2 exists in Kbar)
    names = ['a', 'b']
    nonempty = [poly(((2, 0), ONE), ((0, 0), (Fr(-2), Fr(0), Fr(0), Fr(0)))),
                poly(((0, 1), ONE), ((1, 0), NEG))]
    u, _ = LF.sympy_verdict(names, nonempty)
    m, _ = LF.m2_verdict(names, nonempty, 'ctrl_nonempty')
    print('control NON-EMPTY : sympy-unit=%s (want False)  M2-unit=%s (want False)'
          % (u, m))
    ok &= (u is False) and (m is False)
    # (2) EMPTY over K: a = 0 and a - 1 = 0
    empty = [poly(((1, 0), ONE)), poly(((1, 0), ONE), ((0, 0), NEG))]
    u, _ = LF.sympy_verdict(names, empty)
    m, _ = LF.m2_verdict(names, empty, 'ctrl_empty')
    print('control EMPTY     : sympy-unit=%s (want True )  M2-unit=%s (want True )'
          % (u, m))
    ok &= (u is True) and (m is True)
    # (3) a K-specific control: om^2+om+1 = 0 means om^2 = -1-om is NOT a new
    #     condition -- the ideal (a - om, a^2 + a + 1) must be NON-unit.
    kctl = [poly(((1,), ONE), ((0,), (Fr(0), Fr(-1), Fr(0), Fr(0)))),
            poly(((2,), ONE), ((1,), ONE), ((0,), ONE))]
    u, _ = LF.sympy_verdict(['a'], kctl)
    m, _ = LF.m2_verdict(['a'], kctl, 'ctrl_om')
    print('control a=om      : sympy-unit=%s (want False)  M2-unit=%s (want False)'
          % (u, m))
    ok &= (u is False) and (m is False)
    # (4) a kp-specific control: kp is a root of 8x^2-13x-4, so (a-kp) is fine
    #     but (a-kp, 8a^2-13a-5) must be the UNIT ideal.
    kctl2 = [poly(((1,), ONE), ((0,), (Fr(0), Fr(0), Fr(-1), Fr(0)))),
             poly(((2,), (Fr(8), Fr(0), Fr(0), Fr(0))),
                  ((1,), (Fr(-13), Fr(0), Fr(0), Fr(0))),
                  ((0,), (Fr(-5), Fr(0), Fr(0), Fr(0))))]
    u, _ = LF.sympy_verdict(['a'], kctl2)
    m, _ = LF.m2_verdict(['a'], kctl2, 'ctrl_kp')
    print('control a=kp,8a^2-13a-5 : sympy-unit=%s (want True) M2-unit=%s (want True)'
          % (u, m))
    ok &= (u is True) and (m is True)
    print('CONTROLS %s' % ('PASS' if ok else 'FAIL'))
    return ok


if __name__ == '__main__':
    import sys
    sys.exit(0 if main() else 1)
