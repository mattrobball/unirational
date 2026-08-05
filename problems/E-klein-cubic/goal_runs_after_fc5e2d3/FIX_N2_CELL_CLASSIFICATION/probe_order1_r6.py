#!/usr/bin/env python3
"""Targeted probe: does the r=6 C3-equivariant solution cone contain a point of
common plane order 1 (or 2)?  A positive answer would populate the cell (1,6)
(resp. (2,6)) already at line degree zero."""
import os, subprocess, sys
import sympy as sp
import cell_lib as CL, produce_c3_equivariant as EQ
from cell_lib import om, kp, km, x, y, z
MS = "/opt/homebrew/bin/msolve"
HERE = os.path.dirname(os.path.abspath(__file__))
FF_P, FF_OM, FF_KP, FF_KM = 100057, 1140, 74361, 63219
def s2(e): return str(sp.expand(e)).replace('**','^').replace(' ','')
r = int(sys.argv[1]); target_m = [int(v) for v in sys.argv[2:]] or [1,2]
for lam, tag in ((1,'one'),(om,'om'),(om**2,'om2')):
    res = EQ.equivariant_tuple(r,1,lam)
    if res is None: continue
    forms, free = res
    eqs = EQ.landing_eqs(forms)
    sub = {om:FF_OM, kp:FF_KP, km:FF_KM}
    polys = [s2(sp.expand(e.subs(sub))) for e in eqs]
    # collect coefficients of monomials realising plane order exactly m
    tests = {}
    for f in forms:
        f = sp.sympify(f)
        if f == 0: continue
        for mo, cf in sp.Poly(f, x,y,z).terms():
            m0 = r - max(mo)
            if m0 in target_m:
                tests.setdefault(m0, []).append(CL.reduce_om(cf))
    for m0 in sorted(tests):
        verdicts = []
        for i,c in enumerate(tests[m0]):
            src = '%s\n%d\n%s,\n%s-1\n' % (','.join(map(str,free)), FF_P,
                                           ',\n'.join(polys), s2(sp.expand(c.subs(sub))))
            inp = os.path.join(HERE,'msolve','probe_%d_%s_m%d_%d.ms'%(r,tag,m0,i))
            outp = inp[:-3]+'.out'
            open(inp,'w').write(src)
            subprocess.run([MS,'-t','6','-f',inp,'-o',outp],capture_output=True,text=True)
            txt = open(outp).read().strip() if os.path.exists(outp) else ''
            verdicts.append('none' if txt.startswith('[-1]') else 'SOLUTION EXISTS')
            print('   r=%d lam=%s plane-order-%d coef %d : %s'%(r,tag,m0,i,verdicts[-1]))
            sys.stdout.flush()
