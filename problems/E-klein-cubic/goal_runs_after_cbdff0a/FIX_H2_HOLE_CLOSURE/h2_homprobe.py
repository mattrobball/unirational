#!/usr/bin/env python3
"""FIX-H2: fast RIGOROUS one-sided probe on the homogeneous formulation.

For the homogeneous ideal I (h2_homog.py) and f the parameter(s) the licence
lets us invert, the case is EMPTY iff f^k lies in I for some k.  Membership is
witnessed by a partial Groebner basis: if f^k reduces to 0 modulo a
DEGREE-LIMITED Groebner basis of I, then f^k IS in I -- the partial basis
consists of honest ideal members -- and the case is empty.  Failure to reduce
proves nothing (NOT-DECIDED), so the probe is one-sided and can never produce
a false EMPTY.

usage: h2_homprobe.py [r] [lam,...] [--dlim=6,8,10] [--kmax=10]
"""
import json, os, subprocess, sys, time
import h2_homog as HG
import holes_lib as H
import n2b_lib as L

def src(names, polys, f, dlim, kmax, tag):
    lines = []
    for q in polys:
        t = []
        for k, v in sorted(q.items()):
            mon = '*'.join('%s^%d' % (names[i], e) if e > 1 else names[i]
                           for i, e in enumerate(k) if e)
            t.append('(%s)%s' % (L.kstr(v), '*' + mon if mon else ''))
        lines.append('+'.join(t))
    return '\n'.join([
      'A = QQ[om,kp];',
      'K = toField(A/ideal(om^2+om+1, 8*kp^2-13*kp-4));',
      'R = K[%s];' % ','.join(names),
      'I = ideal(\n  %s\n);' % ',\n  '.join(lines),
      'stdio << "-- %s dlim=%d" << endl << flush;' % (tag, dlim),
      'stdio << "HOMOGENEOUS " << (isHomogeneous I) << endl << flush;',
      'G = gb(I, DegreeLimit => %d);' % dlim,
      'f = %s;' % f,
      'found = -1;',
      'for k from 1 to %d do ( if found < 0 and ((f^k) %% G) == 0 then found = k );' % kmax,
      'stdio << "FPOWER " << found << endl << flush;',
      'if found > 0 then ( stdio << "VERDICT UNIT-IDEAL (EMPTY): f^" << found << " is in I" << endl )'
      ' else ( stdio << "VERDICT NOT-DECIDED-AT-THIS-DEGREE" << endl );',
      'stdio << "M2-DONE" << endl << flush;',
      'exit 0']) + '\n'

def main():
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    lams = ('one','om','om2'); dlims = [6,8,10,12]; kmax = 12
    for a in sys.argv[2:]:
        if a.startswith('--dlim='): dlims = [int(x) for x in a.split('=')[1].split(',')]
        elif a.startswith('--kmax='): kmax = int(a.split('=')[1])
        elif not a.startswith('-'): lams = tuple(a.split(','))
    res = {}
    for lam in lams:
        for case, zeros, fexpr in (('Z', HG.ZERO_Z, 'B6'), ('N', HG.ZERO_N, 'B6*Y0')):
            names, polys, po1 = HG.system(r, lam, zeros)
            f = fexpr.replace('B6', po1[0])
            got = None
            for d in dlims:
                tag = 'h2hp_r%d_%s_%s_d%d' % (r, lam, case, d)
                p = os.path.join(H.HERE, 'm2', tag + '.m2')
                open(p, 'w').write(src(names, polys, f, d, kmax, tag))
                t0 = time.time()
                try:
                    out = subprocess.run([H.M2, '--script', p], capture_output=True,
                                         text=True, timeout=1200)
                    txt = out.stdout + out.stderr
                except subprocess.TimeoutExpired:
                    txt = '<TIMEOUT>'
                dt = time.time() - t0
                open(os.path.join(H.HERE, 'logs', tag + '.log'), 'w').write(txt)
                ok = 'UNIT-IDEAL' in txt
                print('  r=%d lam=%-4s CASE %s dlim=%2d -> %-12s (%.0f s) %s'
                      % (r, lam, case, d, 'EMPTY' if ok else 'not-decided', dt,
                         [l for l in txt.splitlines() if l.startswith('FPOWER')][:1]),
                      flush=True)
                if ok:
                    got = d; break
            res['%s_%s' % (lam, case)] = 'EMPTY' if got else 'NOT-DECIDED'
    p = os.path.join(H.HERE, 'payloads', 'taskA_homprobe_r%d.json' % r)
    old = json.load(open(p)) if os.path.exists(p) else {}
    old.update(res); json.dump(old, open(p,'w'), indent=1, sort_keys=True)
    print('\nFIX-H2 homogeneous probe r=%d: %s' % (r, old), flush=True)

if __name__ == '__main__':
    main()
