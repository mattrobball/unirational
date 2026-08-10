#!/usr/bin/env python3
"""Cross-check: the cubic system emitted here must equal, term for term, the
ideal in the Macaulay2 script that the original (killed) d = 6 rung used.

The M2 scripts `f55land_d<D>_s<S>.m2` live in the untracked director-probe
directory of the main checkout and are read here READ-ONLY; nothing depends on
them at run time.  This script exists so that the msolve verdicts can be
attributed to the same ideal the M2 run was asked about.

usage:  check_against_m2.py <d> [<m2dir>]
"""
import sys, os, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from f55_ladder_msolve import ladder_system

P = 661
D = int(sys.argv[1])
M2DIR = sys.argv[2] if len(sys.argv) > 2 else (
    '/Users/worker/unirational/problems/E-klein-cubic/director_probes_20260806')


def norm(poly):
    """canonical form of one M2/msolve polynomial: frozenset of (coeff, monomial)"""
    out = set()
    for term in poly.split('+'):
        term = term.strip()
        if not term:
            continue
        parts = term.split('*')
        cf = int(parts[0]) % P
        vars_ = []
        for q in parts[1:]:
            m = re.fullmatch(r'c(\d+)(?:\^(\d+))?', q)
            vars_.extend([int(m.group(1))] * int(m.group(2) or 1))
        out.add((cf, tuple(sorted(vars_))))
    return frozenset(out)


def mine(d, s):
    n, rows = ladder_system(d, P, s)
    out = []
    for row in rows:
        terms = set()
        for (k1, k2), k3 in row:
            terms.add((row[((k1, k2), k3)] % P, tuple(sorted((k1, k2, k3)))))
        out.append(frozenset(terms))
    return n, out


ok = True
for s in range(5):
    path = os.path.join(M2DIR, 'f55land_d%d_s%d.m2' % (D, s))
    if not os.path.exists(path):
        print('CHECK m2_parity_d%d_s%d  SKIP  no %s' % (D, s, path))
        continue
    src = open(path).read()
    body = src.split('I = ideal(', 1)[1].rsplit(');', 1)[0]
    theirs = [norm(q) for q in body.split(',')]
    n, ours = mine(D, s)
    same = set(map(frozenset, theirs)) == set(map(frozenset, ours))
    ok &= same and len(theirs) == len(ours)
    print('CHECK m2_parity_d%d_s%d  %s  %d vs %d generators in %d unknowns'
          % (D, s, 'PASS' if same and len(theirs) == len(ours) else 'FAIL',
             len(theirs), len(ours), n))
sys.exit(0 if ok else 1)
