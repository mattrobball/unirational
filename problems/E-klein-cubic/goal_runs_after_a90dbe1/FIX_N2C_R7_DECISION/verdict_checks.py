#!/usr/bin/env python3
"""FIX-N2C verifier, step 4: the verdict evidence, all recomputed.

Called by `verify_n2c.py`.  Nothing is read from a stored result file: the
witness is rebuilt from its defining cubics, the (2,7) control is rebuilt from
FIX-N2B's published block coordinates, the numerical check is redone at 40
digits, and the modular reproduction is re-validated by direct substitution.
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)


def run(check):
    print('\n== 4. the verdict: FIX-N2C-M1-R7-POPULATED ==')

    import control_27
    control_27.run(check)

    import witness
    witness.run(check)

    import witness_om
    witness_om.run(check)

    import witness_om2
    witness_om2.run(check)

    import numeric_check
    numeric_check.run(check)

    # modular reproduction of the FIX-N2B alarm, re-validated by substitution
    import decode_param as D
    ms = os.path.join(HERE, 'msolve', 'B1_ff100057_one_B5.ms')
    par = os.path.join(HERE, 'msolve', 'B1_ff100057_one_B5.out')
    if os.path.exists(par) and os.path.getsize(par) > 0:
        p = 100057
        names, _, polys = D.parse_system(ms)
        d = D.read_param(par)
        rest = d[1][5]
        elim = rest[1][0][1]
        nums = [t[0][1] for t in rest[1][2]]
        pts = []
        for t in D.roots_fp(elim, p):
            v = [-D.poly_eval(nc, t, p) % p for nc in nums] + [t]
            if all(q == 0 for q in D.evaluate(polys, v, p)):
                pts.append(v)
        check('  modular: 9 explicit F_100057 points, B5 = 1, all 18 cubics',
              len(pts) == 9, '(%d points)' % len(pts))
        check('  modular: every point has B8 != 0 and B1 = -B5 = -1',
              all(v[11] != 0 and v[5] == p-1 for v in pts))
    else:
        check('  modular: parametrization file present', False,
              '(rerun run_one.py B1_ff100057_one_B5 one B5 ff:100057 --noelim -P 1)')
