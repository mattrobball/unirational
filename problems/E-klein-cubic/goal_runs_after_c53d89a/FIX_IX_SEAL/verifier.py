#!/usr/bin/env python3
# FIX-IX-SEAL verifier. Independent replay:
#  (1) fresh prime p = 353 end-to-end (seal.py 353 + the four M2 scripts);
#  (2) an INDEPENDENT identification of the 10'-summand at 353 by the
#      trace-sum method (no character averaging): match sum of Lambda^2
#      traces per projective-order class against the banked PSL(2,11)
#      character table, for all four candidate 5+10 decompositions;
#  (3) cross-check the 397 / 199 / K logs agree on the full profile.
# Exit 0 with ALLGREEN or nonzero with the first failure.
import subprocess, sys, os, re
HERE = os.path.dirname(os.path.abspath(__file__))
SC = os.path.join(HERE, 'scripts')
RES = os.path.join(HERE, 'results')
fails = []

def note(ok, msg):
    print(('PASS ' if ok else 'FAIL ') + msg)
    if not ok: fails.append(msg)

# (1) fresh prime
r = subprocess.run([sys.executable, os.path.join(SC, 'seal.py'), '353'],
                   capture_output=True, text=True, timeout=1200)
log353 = r.stdout
note(r.returncode == 0 and 'FAIL' not in log353, 'seal.py 353 all checks pass')
m2out = {}
for stem in ('m2_sigma_353', 'm2_d12_353', 'm2_smooth_353', 'm2_ambient_353'):
    rr = subprocess.run(['M2', '--script', os.path.join(SC, stem + '.m2')],
                        capture_output=True, text=True, timeout=1800)
    m2out[stem] = rr.stdout
    open(os.path.join(RES, stem + '.out'), 'w').write(rr.stdout)
sig = m2out['m2_sigma_353']
note('SIGPLUS dim 2 deg 6' in sig and 'hp 6*i' in sig, '353 sigma curve: dim 1, deg 6, pa 1')
note('SIGPLUS radical true' in sig and 'SIGPLUS ncomp 1' in sig, '353 sigma curve: reduced, irreducible')
note('SIGPLUS smooth true' in sig, '353 sigma curve: smooth (=> genus-1 sextic, no rational curve)')
note('SIGMINUS dim 1 deg 2' in sig and 'SIGMINUS reduced true' in sig, '353 sigma isolated part: 2 reduced points')
d12 = m2out['m2_d12_353']
note(d12.count('empty true') + d12.count('empty True') == 4, '353 V14^D12 empty in all four character pieces')
sm = m2out['m2_smooth_353']
note('PF6 nonzero true' in sm and 'JSYS empty true' in sm, '353 dual system empty (=> V14 smooth, pure dim 3)')
amb = m2out['m2_ambient_353']
note('AMBIENT dim 4 deg 14' in amb, '353 ambient: dim 3, degree 14')

# (2) independent 10'-identification by trace sums at 353
p = 353
g11 = next(t for t in range(2, p) if pow(t, 11, p) == 1 and t != 1)
gauss = sum(pow(g11, (k*k) % 11, p) for k in range(11)) % p
assert (gauss*gauss + 11) % p == 0
c = pow(gauss, p-2, p)
T6 = [[(pow(g11, (j*j) % 11, p) if i == j else 0) for j in range(6)] for i in range(6)]
S6 = [[(c if j == 0 else c*(pow(g11, (i*j) % 11, p) + pow(g11, (-i*j) % 11, p))) % p
       for j in range(6)] for i in range(6)]
def mm(A, B):
    return tuple(tuple(sum(A[i][k]*B[k][j] for k in range(6)) % p for j in range(6)) for i in range(6))
I6 = tuple(tuple((1 if i == j else 0) for j in range(6)) for i in range(6))
seen = {I6}; frontier = [I6]
T6t, S6t = tuple(map(tuple, T6)), tuple(map(tuple, S6))
while frontier:
    nxt = []
    for M in frontier:
        for g in (T6t, S6t):
            N = mm(M, g)
            if N not in seen: seen.add(N); nxt.append(N)
    frontier = nxt
GRP = list(seen)
note(len(GRP) == 1320, 'independent closure at 353 has order 1320')
def is_scal(A):
    d = A[0][0]
    return d != 0 and all(A[i][j] == (d if i == j else 0) for i in range(6) for j in range(6))
def po(M):
    A = M
    for k in range(1, 14):
        if is_scal(A): return k
        A = mm(A, M)
    return 99
from itertools import combinations
pairs = list(combinations(range(6), 2))
def tr_lam2(M):
    return sum((M[i][i]*M[j][j] - M[i][j]*M[j][i]) for (i, j) in pairs) % p
agg = {}
for M in GRP:
    k = po(M); a = agg.setdefault(k, [0, 0])
    a[0] += 1; a[1] = (a[1] + tr_lam2(M)) % p
s11 = next(t for t in range(p) if t*t % p == (p-11) % p)
half = pow(2, p-2, p)
lam, lamb = (p-1+s11)*half % p, (p-1-s11)*half % p
CL = ['1', '2', '3', '5A', '5B', '6', '11A', '11B']
CT = {'W':   [5, 1, p-1, 0, 0, 1, lam, lamb],
      'Wb':  [5, 1, p-1, 0, 0, 1, lamb, lam],
      'X10': [10, p-2, 1, 0, 0, 1, p-1, p-1],
      'X10p':[10, 2, 1, 0, 0, p-1, p-1, p-1]}
sizes = {'1':1, '2':55, '3':110, '5A':132, '5B':132, '6':110, '11A':60, '11B':60}
matches = []
for five in ('W', 'Wb'):
    for ten in ('X10', 'X10p'):
        ok = True
        for kord, classes in {1:['1'], 2:['2'], 3:['3'], 6:['6'], 5:['5A','5B'], 11:['11A','11B']}.items():
            exp = sum(2*sizes[cl]*(CT[five][CL.index(cl)] + CT[ten][CL.index(cl)]) for cl in classes) % p
            if agg.get(kord, [0,0])[1] != exp: ok = False; break
        if ok: matches.append((five, ten))
note(all(t == 'X10p' for (_, t) in matches) and len(matches) >= 1,
     f'trace-sum identification: Lambda^2 U contains X10-prime, not X10 (matches {matches})')

# (3) cross-log profile agreement
prof = {}
for tag in ('397', '199', 'K'):
    fn = os.path.join(RES, f'checks_{tag}.log')
    txt = open(fn).read() if os.path.exists(fn) else ''
    prof[tag] = ('sigma_split_6_4' in txt and 'PASS' in txt and 'FAIL' not in txt,
                 bool(re.search(r'D12_piece_dims_sum_\w+ PASS character piece dims \(2, 1, 1, 0\)', txt)))
note(all(all(v) for v in prof.values()), f'397/199/K seal logs all green with matching profile {prof}')

print('FIX-IX-SEAL-VERIFIER: ' + ('ALLGREEN' if not fails else f'{len(fails)} FAILURES'))
sys.exit(0 if not fails else 1)
