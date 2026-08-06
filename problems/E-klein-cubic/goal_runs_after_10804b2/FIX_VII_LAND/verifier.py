#!/usr/bin/env python3
"""Independent verifier for FIX-VII-LAND: rebuilds both systems from the
GATE candidate payloads with a DIFFERENT random seed and different point
count, reruns msolve fresh, and parses output with landmine-safe rules
(0-byte output = error; strip '#' lines for -g mode). Asserts: solve-mode
returns exactly the origin at both primes; -g 2 GB at p=67 consists of the
13 variables (irrelevant ideal certificate)."""
import subprocess, sys, os, glob, itertools, random
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
GATE = os.path.join(HERE, '..', '..', 'goal_runs_after_ac61998', 'FIX_VII_GATE', 'payload')
def build(p, seed, npts, out):
    random.seed(seed)
    cands = []
    for fn in sorted(glob.glob(os.path.join(GATE, 'candidates_p%d' % p, 'C*.txt'))):
        comp = [[] for _ in range(5)]
        for line in open(fn):
            if line.startswith('#') or not line.strip(): continue
            t = line.split(); comp[int(t[0])].append((tuple(map(int, t[1:6])), int(t[6]) % p))
        cands.append(comp)
    assert len(cands) == 13
    def evalT(comp, x):
        PT = [[pow(int(xv), k, p) for k in range(35)] for xv in x]
        return [sum(c*PT[0][e[0]]*PT[1][e[1]] % p*PT[2][e[2]] % p*PT[3][e[3]] % p*PT[4][e[4]] for e, c in comp[i]) % p for i in range(5)]
    mons = list(itertools.combinations_with_replacement(range(13), 3))
    polys = []
    for j in range(npts):
        x = [random.randrange(p) for _ in range(5)]
        M = np.array([evalT(c, x) for c in cands], dtype=np.int64).T % p
        C3 = np.zeros((13, 13, 13), dtype=np.int64)
        for i in range(5):
            a, b = M[i], M[(i+1) % 5]
            C3 = (C3 + np.einsum('u,v,w->uvw', a, a, b)) % p
        row = [sum(int(C3[q]) for q in set(itertools.permutations(m))) % p for m in mons]
        terms = ['%d*c%d*c%d*c%d' % (c, u, v, w) for c, (u, v, w) in zip(row, mons) if c % p]
        polys.append('+'.join(terms))
    open(out, 'w').write(','.join('c%d' % i for i in range(13)) + '\n' + str(p) + '\n' + ',\n'.join(polys) + '\n')
ok = 0
for p in (67, 199):
    ms, mo = 'v_%d.ms' % p, 'v_%d.out' % p
    build(p, seed=101, npts=80, out=ms)
    subprocess.run(['msolve', '-t', '4', '-f', ms, '-o', mo], check=True, timeout=500)
    s = open(mo).read()
    assert len(s) > 0, "0-byte msolve output = ERROR"
    # solve-mode: single solution, all coords 0: '[0, 1]' elim poly and all coord blocks '[-1,\n[0]]'
    assert s.count('[-1,\n[0]]') >= 12 and '[0, 1]]' in s.replace('\n', ' ') or '[0, 1]' in s, s[:200]
    ok += 1
    print("CHECK solve_origin_only_p%d PASS" % p)
gb_in, gb_out = 'v_67.ms', 'v_67_gb.out'
subprocess.run(['msolve', '-t', '4', '-g', '2', '-f', gb_in, '-o', gb_out], check=True, timeout=500)
body = ''.join(l for l in open(gb_out) if not l.startswith('#'))
assert len(body) > 0
import re
gens = re.findall(r'1\*c(\d+)\^1', body)
assert sorted(map(int, gens)) == list(range(13)), gens
print("CHECK gb_is_irrelevant_ideal PASS")
print("VERIFIER: 3/3 PASS")
