#!/usr/bin/env python3
"""FIX-U1-FIN7 -- verifier.  INDEPENDENT RECOMPUTE, not a replay.

  * harness self-test with unit AND non-unit controls, plus deliberately
    wrong controls that must FAIL;
  * a THIRD, independent build of the 52 landing equations (literal sympy
    polynomial substitution into the raw Klein normal form) checked against
    both builders in `fin7_lib`;
  * the 27 classified points re-verified on all 52 equations;
  * the exact Jacobian ranks recomputed (all 12 (block,part) pairs modularly
    at three primes = certified LOWER bounds, and exactly over the residue
    field at parts A and B of every block plus one part D);
  * the torus tangent directions, the u0 +/- v0 certificates and the
    degenerate 17-dimensional components re-verified exactly;
  * consistency with `payloads/PAYLOAD_results.json`.

Terminal line on success:  FIX_U1_FIN7_VERIFY_OK
"""
import json
import os
import sys
import time

import sympy as sp

import fin7_equiv as E
import fin7_jac as JJ
import fin7_lib as L
import fin7_modular as M
import fin7_points as PT
import fin7_tangent as TG
import fin7_theta as TH
from exalg import Alg
from fin7_equiv import B2s, P1s
from fin7_lib import kp, kred, om, OM2, x, y, z

HERE = os.path.dirname(os.path.abspath(__file__))
T0 = time.time()
FAIL = []
NCK = 0


def ck(name, cond, extra=''):
    global NCK
    NCK += 1
    print('  %-66s %s %s' % (name, 'OK  ' if cond else 'FAIL', extra),
          flush=True)
    if not cond:
        FAIL.append(name)
    return cond


def ck_must_fail(name, cond):
    """a control that MUST be false; the harness is broken if it passes."""
    global NCK
    NCK += 1
    print('  %-66s %s' % (name, 'OK (correctly false)' if not cond
                          else 'HARNESS BROKEN'), flush=True)
    if cond:
        FAIL.append('control that must fail: ' + name)


# ---------------------------------------------------------------------------
print('# FIX-U1-FIN7 verifier')
print()
print('## A. harness self-test')
Ac = Alg(B2s - 1, P1s - 2, 'ctl')
ck('control (non-unit): 0 has no inverse', Ac.inv(Ac.zero()) is None)
ck('control (unit): 1 has an inverse', Ac.inv(Ac.one()) is not None)
ck('control (unit): om*om^2 = 1 in K',
   Ac.mul(Ac.of(om), Ac.of(OM2)) == Ac.one())
ck('control: 8kp^2-13kp-4 reduces to 0', Ac.is_zero(Ac.of(8*kp**2 - 13*kp - 4)))
ck_must_fail('control: om - 1 must NOT be zero in K', Ac.is_zero(Ac.of(om - 1)))
Rp = JJ.Fp(100057)
r, _, _ = JJ.rank(Rp, [[1, 2], [2, 4]])
ck('control: modular rank of a rank-1 matrix is 1', r == 1)
r, _, _ = JJ.rank(Rp, [[1, 2], [2, 5]])
ck('control: modular rank of a rank-2 matrix is 2', r == 2)
Ak = PT.part_algebra(0, 'A')
r, _, _ = JJ.rank(Ak, [[Ak.of(om), Ak.of(sp.Integer(1))],
                       [Ak.of(sp.Integer(1)), Ak.of(OM2)]])
ck('control: exact rank over K of a singular 2x2 is 1', r == 1)
ck_must_fail('control: that same matrix must NOT have rank 2', r == 2)
print()

# ---------------------------------------------------------------------------
print('## B. a THIRD independent build of the 52 equations')
names, T, eqs_sym = L.landing_equations()
names_t, eqs_trm = L.landing_terms()
sup = L.param_names()


def third_build():
    """literal sympy polynomials in x,y,z substituted into the Klein form."""
    supp = L.supports()
    comps = []
    for i in range(5):
        comps.append(sp.expand(sum(sp.Symbol(sup[i][k])*x**m[0]*y**m[1]*z**m[2]
                                   for k, m in enumerate(supp[i]))))
    a, b, u0, u1, u2 = comps
    F = sp.expand(kp*a**3 + (sp.Rational(13, 8) - kp)*b**3
                  + a*(u0**2 + om*u1**2 + OM2*u2**2)
                  + b*(u0**2 + OM2*u1**2 + om*u2**2)
                  + u0*u1*u2)
    P = sp.Poly(F, x, y, z)
    out = {}
    for mon, cf in zip(P.monoms(), P.coeffs()):
        cf = kred(cf)
        if cf != 0:
            out[mon] = cf
    return out


d3 = third_build()
d1 = dict(eqs_sym)
ck('third build gives exactly 52 equations', len(d3) == 52, str(len(d3)))
ck('third build has the same monomial set', set(d3) == set(d1))
ck('third build agrees coefficient by coefficient with builder 1',
   all(sp.expand(d3[m] - d1[m]) == 0 for m in d3))
S = [sp.Symbol(n) for n in names]
ck('third build agrees coefficient by coefficient with builder 2 (terms)',
   all(sp.expand(sum(c*S[i]*S[j]*S[k] for c, (i, j, k) in tl) - d3[mon]) == 0
       for mon, tl in eqs_trm))
ck_must_fail('control: a perturbed equation must NOT match',
             sp.expand(d3[sorted(d3)[0]] + 1 - d1[sorted(d3)[0]]) == 0)
print()

# ---------------------------------------------------------------------------
print('## C. the 27 classified points, on all 52 equations (exact)')
Th = L.theta_matrix()
for j in range(3):
    g1, g2 = E.block_cubics(j)
    REL = [g2, g1, om**2 + om + 1, 8*kp**2 - 13*kp - 4]
    GENS = (P1s, B2s, om, kp)

    def red(e, REL=REL, GENS=GENS):
        e = sp.expand(e)
        if e == 0:
            return sp.Integer(0)
        _, rr = sp.reduced(e, REL, *GENS, order='lex')
        return sp.expand(rr)
    coords = E.classified_point(j)
    sub = {sp.Symbol(n): coords[n] for n in names}
    bad = [m for m in d3 if red(sp.expand(d3[m].subs(sub))) != 0]
    ck('lam=om^%d : all 52 third-build equations vanish at the 9 points' % j,
       not bad, '(%d nonzero)' % len(bad))
    ck('lam=om^%d : Theta(p) = om^%d p' % (j, j),
       not [n for n in names
            if red(sp.expand(Th[n].subs(sub) - kred(om**j)*coords[n])) != 0])
    ck_must_fail('control: lam=om^%d point is NOT an om^%d eigenvector' %
                 (j, (j + 1) % 3),
                 not [n for n in names
                      if red(sp.expand(Th[n].subs(sub)
                                       - kred(om**(j + 1))*coords[n])) != 0])
print()

# ---------------------------------------------------------------------------
print('## D. modular Jacobian ranks at all 27 points, three primes')
primes = M.good_primes(100000, 3)
seen = {}
for p, omp, kpp in primes:
    R = JJ.Fp(p)
    eq_p = M.eqs_mod(eqs_trm, p, omp, kpp)
    E3 = JJ.torus_rows()
    n = len(names)
    for j in range(3):
        coords = E.classified_point(j)
        r1, r2 = M.block_points_mod(j, p, omp, kpp)
        B20 = M.to_fp(sp.expand((2*om + 1)*om**(2*j)
                                * (sp.Rational(4, 3)*kp - sp.Rational(1, 3))),
                      {om: omp, kp: kpp}, p)
        P10 = M.to_fp(sp.expand(sp.Rational(4, 3)*om**(j + 1)
                                * (sp.Rational(4, 3)*kp - sp.Rational(1, 3))),
                      {om: omp, kp: kpp}, p)
        for B2v in r1:
            for P1v in r2:
                part = (('A' if P1v == P10 else 'B') if B2v == B20
                        else ('C' if P1v == P10 else 'D'))
                v = M.point_mod(j, B2v, P1v, p, omp, kpp, names, coords)
                onc = all(c == 0 for c in JJ.evaluate(R, v, eq_p))
                J = JJ.jacobian(R, v, eq_p, names)
                rk, _, _ = JJ.rank(R, J)
                Tv = [[R.mul(E3[a][t] % p, v[t]) for t in range(n)]
                      for a in range(3)]
                rt, _, _ = JJ.rank(R, Tv)
                ink = all(all(sum(J[i][t]*tv[t] for t in range(n)) % p == 0
                              for i in range(len(J))) for tv in Tv)
                seen.setdefault((j, part), set()).add((onc, rk, rt, ink))
for (j, part), s in sorted(seen.items()):
    ck('lam=om^%d part %s : same (on-cone, rank, torus dim, torus-in-ker) at '
       'all 3 primes' % (j, part), len(s) == 1, str(sorted(s)))
mods = {(j, part): list(s)[0] for (j, part), s in seen.items()}
ck('modular ranks: 34 at parts B,C,D and 31 at part A, all blocks',
   all(v[1] == (31 if k[1] == 'A' else 34) for k, v in mods.items()))
ck('modular: torus orbit is 3-dimensional and in ker J at all 27 points',
   all(v[2] == 3 and v[3] for v in mods.values()))
print()

# ---------------------------------------------------------------------------
print('## E. EXACT ranks over the residue fields (independent recompute)')
todo = [(j, 'A') for j in range(3)] + [(j, 'B') for j in range(3)] + [(0, 'D')]
exact = {}
for j, part in todo:
    r = TG.run_point(j, part)
    exact[(j, part)] = r
    ck('lam=om^%d part %s : exact rank %d (= modular rank), corank %d'
       % (j, part, r['rank'], r['corank']),
       r['rank'] == mods[(j, part)][1], '[%.0fs]' % r['secs'])
    ck('lam=om^%d part %s : block coranks sum to the total corank'
       % (j, part),
       sum(r['per_block'][k][1] for k in r['per_block']) == r['corank'])
    ck('lam=om^%d part %s : point on the cone, plane orders (1,1,1) certified'
       % (j, part), r['on_cone'] and r['po1_ok'])
print()

# ---------------------------------------------------------------------------
print('## F. u0 +/- v0 at the 27 points (Nullstellensatz certificates)')
for j in range(3):
    coords = E.classified_point(j)
    for part in PT.PARTS:
        A = PT.part_algebra(j, part)
        vp, vm = A.of(coords['t0'] + coords['w0']), A.of(coords['t0']
                                                         - coords['w0'])
        ck('lam=om^%d part %s : u0+v0 invertible (so != 0)' % (j, part),
           A.inv(vp) is not None)
        ck('lam=om^%d part %s : u0-v0 invertible (FIX-H1 equalizer fails)'
           % (j, part), A.inv(vm) is not None)
        iv = A.inv(vp)
        ck('lam=om^%d part %s : (u0+v0)*inverse = 1 (certificate checked)'
           % (j, part), A.mul(vp, iv) == A.one())
print()

# ---------------------------------------------------------------------------
print('## G. the degenerate 17-dimensional components')
A = PT.part_algebra(0, 'A')
n = len(names)
supp = L.supports()
slot_of = []
for si in range(5):
    slot_of += [si]*len(supp[si])
ceq = [(mon, [(A.of(c), idx) for c, idx in terms]) for mon, terms in eqs_trm]
for zero_slot, tag in ((4, "u2'"), (3, "u1'"), (2, "u0'")):
    vals = [A.zero()]*n
    cnt = 0
    for t in range(n):
        if slot_of[t] in (2, 3, 4) and slot_of[t] != zero_slot:
            cnt += 1
            vals[t] = A.of(sp.Integer(1 + (7*cnt) % 23))
    onc = all(A.is_zero(e) for e in TG.eq_values(A, vals, ceq))
    po = all(any(not A.is_zero(vals[names.index(nm)]) for nm, _s, _m in w)
             for w in L.po1_witnesses())
    prods = [[A.mul(vals[a], vals[b]) for b in range(n)] for a in range(n)]
    J = TG.jacobian(A, vals, ceq, prods)
    rk, _, _ = JJ.rank(A, J)
    ck("a'=b'=%s=0 member: on the cone with plane orders (1,1,1)" % tag,
       onc and po)
    ck("a'=b'=%s=0 member: exact corank 18 (component is the linear space)"
       % tag, n - rk == 18, 'corank=%d' % (n - rk))
ck_must_fail('control: a random point off the cone must NOT satisfy F(T)=0',
             all(A.is_zero(e) for e in TG.eq_values(
                 A, [A.of(sp.Integer(1 + (5*t) % 17)) for t in range(n)],
                 ceq)))
print()

# ---------------------------------------------------------------------------
print('## H. consistency with the recorded payload')
pj = os.path.join(HERE, 'payloads', 'PAYLOAD_results.json')
if os.path.exists(pj):
    with open(pj) as f:
        RES = json.load(f)
    tab = {(r['j'], r['part']): r for r in RES.get('tangent', [])}
    ck('payload records all 12 (block, part) pairs', len(tab) == 12)
    ck('payload ranks agree with this run',
       all(tab[(j, p2)]['rank'] == exact[(j, p2)]['rank'] for (j, p2) in exact))
    ck('payload ranks agree with the modular scan',
       all(tab[k]['rank'] == mods[k][1] for k in tab))
else:
    ck('payload present', False, '(run produce_fin7.py first)')
print()

print('checks run: %d, failed: %d, elapsed %.0f s'
      % (NCK, len(FAIL), time.time() - T0))
for f in FAIL:
    print('  FAILED: %s' % f)
print('FIX_U1_FIN7_VERIFY_%s' % ('OK' if not FAIL else 'FAIL'))
sys.exit(1 if FAIL else 0)
