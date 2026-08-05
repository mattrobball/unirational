import os, sys, subprocess
sys.path.insert(0,'/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_fa02f05/FIX_N2B_M1_ROW')
import n2b_lib as L, modular as MD
from n2b_lib import ONE, OM, OM2
p, omp, kpp = MD.P, MD.OMP, MD.KPP
lam = {'one':ONE,'om':OM,'om2':OM2}[sys.argv[1]]
r = int(sys.argv[2])
fix = dict(kv.split('=') for kv in sys.argv[3:])       # e.g. B5=1 B8=0
b = L.Block(r, 1, lam)
fixi = {b.names.index(k): int(v) % p for k, v in fix.items()}
names = [n for j, n in enumerate(b.names) if j not in fixi]
eqs = []
for pc in L.equations(b, orbit_reduce=False):
    terms = {}
    for pm, c in pc.items():
        cc = L.kmod_p(c, p, omp, kpp)
        if cc == 0: continue
        skip = False
        for j, v in fixi.items():
            if pm[j]:
                if v == 0: skip = True; break
                cc = cc * pow(v, pm[j], p) % p
        if skip: continue
        key = tuple(e for j, e in enumerate(pm) if j not in fixi)
        terms[key] = (terms.get(key, 0) + cc) % p
    t = [(k, v) for k, v in terms.items() if v]
    if t:
        eqs.append('+'.join('%d%s' % (v, ''.join('*%s^%d' % (names[j], e) if e > 1
                    else '*%s' % names[j] for j, e in enumerate(k) if e)) for k, v in t))
tag = 'sub_r%d_%s_%s' % (r, sys.argv[1], '_'.join(sys.argv[3:]))
src = '%s\n%d\n%s\n' % (','.join(names), p, ',\n'.join(eqs))
inp = '/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_fa02f05/FIX_N2B_M1_ROW/msolve/%s.ms' % tag
open(inp,'w').write(src)
print('vars', names, '#eqs', len(eqs))
out = inp[:-3]+'.out'
subprocess.run(['/opt/homebrew/bin/msolve','-t','4','-g','1','-f',inp,'-o',out], timeout=1200)
print(open(out).read()[:800])
